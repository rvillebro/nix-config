# nix-config repository structure guide

A reference for organizing a multi-host, multi-user Nix configuration repo using
the `modules → profiles → hosts` pattern for NixOS, extended with a matching
layer for home-manager.

---

## 1. The mental model

Four kinds of files, each with one job:

| Layer | Declares options? | Sets values? | Reused by | Analogy |
|---|---|---|---|---|
| **modules** | yes | rarely (only `mkIf`-gated defaults) | profiles, hosts | a class definition |
| **profiles** | no | yes, via `mkDefault` | hosts | a role / persona |
| **hosts** | no | yes, freely, `mkForce` when needed | nobody — it's the leaf | one physical machine |
| **users** (home-manager) | no | yes | hosts (per user, per host) | a home-manager "host" |

Everything flows downward through `imports`. Nothing above a host imports a
host. Nothing above a profile imports a profile.

---

## 2. Full directory tree

```
nix-config/
├── flake.nix
├── flake.lock
├── lib/
│   ├── default.nix              # helper functions (mkHome, ...)
│   └── mkHome.nix               # standalone home-manager builder
├── modules/
│   ├── nixos/                   # system-level option-declaring modules
│   │   ├── networking.nix
│   │   ├── syncthing.nix
│   │   ├── users.nix
│   │   └── default.nix          # imports = [ everything in this dir ]
│   └── home-manager/            # user-level option-declaring modules
│       ├── shell.nix
│       ├── git.nix
│       └── default.nix
├── profiles/
│   ├── nixos/
│   │   ├── desktop.nix          # bundles modules for "a desktop machine"
│   │   ├── headless.nix         # bundles modules for "a server"
│   │   └── laptop.nix           # can build on top of desktop.nix
│   └── home/
│       ├── dev.nix              # bundles home-manager modules for "a dev persona"
│       └── gui.nix              # bundles home-manager modules for GUI apps
├── hosts/
│   ├── laptop1/
│   │   ├── default.nix          # imports profile(s) + hardware + overrides
│   │   └── hardware-configuration.nix
│   └── server1/
│       ├── default.nix
│       └── hardware-configuration.nix
├── users/
│   └── me/
│       ├── laptop1.nix          # home-manager entrypoint for me@laptop1
│       └── server1.nix          # home-manager entrypoint for me@server1
├── overlays/
│   └── default.nix
└── pkgs/
    └── my-custom-package/
        └── default.nix
```

You don't need every directory on day one — `overlays/` and `pkgs/` are
optional extras. The core four are `modules/`, `profiles/`, `hosts/`, `users/`.

---

## 3. What goes in each directory

### `modules/nixos/*.nix` — declare, don't decide

Each file declares one coherent set of options under your own namespace
(pick something short, e.g. `myConfig`) and wires them to real NixOS options
behind `lib.mkIf`. It should work correctly with **zero** assumptions about
who imports it.

```nix
# modules/nixos/syncthing.nix
{ config, lib, ... }:
let
  cfg = config.myConfig.syncthing;
in
{
  options.myConfig.syncthing = {
    enable = lib.mkEnableOption "Syncthing file sync";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = cfg.openFirewall;
    };
  };
}
```

```nix
# modules/nixos/default.nix
{
  imports = [
    ./networking.nix
    ./syncthing.nix
    ./users.nix
  ];
}
```

The `default.nix` per directory is a convenience so a profile can just say
`../../modules/nixos` instead of listing every file.

### `modules/home-manager/*.nix` — same idea, user-scoped

```nix
# modules/home-manager/git.nix
{ config, lib, ... }:
let
  cfg = config.myConfig.git;
in
{
  options.myConfig.git = {
    enable = lib.mkEnableOption "git configuration";
    userName = lib.mkOption { type = lib.types.str; };
    userEmail = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
    };
  };
}
```

### `profiles/nixos/*.nix` — bundle, decide, but stay overridable

A profile imports the modules it needs and turns the knobs to sensible
defaults for a *category* of machine. It declares no new options. Every
value it sets should use `lib.mkDefault` (or leave it out entirely and rely
on the module's own default) so a host can override without a conflict
error.

```nix
# profiles/nixos/desktop.nix
{ lib, ... }:
{
  imports = [ ../../modules/nixos ];

  myConfig.networking.enable = true;
  myConfig.syncthing.enable = lib.mkDefault true;

  services.printing.enable = lib.mkDefault true;
  environment.systemPackages = [ ]; # add desktop-common packages here
}
```

```nix
# profiles/nixos/headless.nix
{ lib, ... }:
{
  imports = [ ../../modules/nixos ];

  myConfig.networking.enable = true;
  myConfig.syncthing.enable = lib.mkDefault false;

  services.openssh.enable = lib.mkDefault true;
  documentation.enable = lib.mkDefault false;
}
```

`profiles/nixos/laptop.nix` can build on `desktop.nix` by importing it and
layering on laptop-only concerns (power management, `services.tlp`), which
is the natural place for a "profile hierarchy" if you want one.

### `profiles/home/*.nix` — same idea, at the user level

```nix
# profiles/home/dev.nix
{ ... }:
{
  imports = [ ../../modules/home-manager ];

  myConfig.git.enable = true;
  programs.neovim.enable = true;
}
```

### `hosts/<name>/default.nix` — the specific machine

This is where the profile meets reality: hardware, hostname, disk layout,
and any override that's true of *only this box*.

```nix
# hosts/laptop1/default.nix
{ lib, ... }:
{
  imports = [
    ../../profiles/nixos/laptop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop1";
  system.stateVersion = "25.05";

  # This laptop has no printer — override the profile's default.
  services.printing.enable = lib.mkForce false;
}
```

`hardware-configuration.nix` is the file `nixos-generate-config` produces on
the actual machine — copy it in as-is, don't hand-edit its structure.

### `users/<name>/<host>.nix` — home-manager per person, per machine

Each user gets one file per host they log into, because their needs differ
by machine (a dev profile on a workstation, a bare-minimum profile on a
shared server).

```nix
# users/me/laptop1.nix
{ ... }:
{
  imports = [
    ../../profiles/home/dev.nix
    ../../profiles/home/gui.nix
  ];

  myConfig.git.userEmail = "me@example.com";
  home.stateVersion = "25.05";
}
```

```nix
# users/me/server1.nix — same person, no GUI on the server
{ ... }:
{
  imports = [ ../../profiles/home/dev.nix ];

  myConfig.git.userEmail = "me@example.com";
  home.stateVersion = "25.05";
}
```

---

## 4. Wiring it together in `flake.nix`

Two host-level outputs matter here: `nixosConfigurations` (for machines you
own) and, if you also want home-manager usable standalone on a non-NixOS
box, `homeConfigurations`.

```nix
{
  description = "My nix-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      laptop1 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop1
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.me = import ./users/me/laptop1.nix;
          }
        ];
      };

      server1 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/server1
          home-manager.nixosModules.home-manager
          {
            home-manager.users.me = import ./users/me/server1.nix;
          }
        ];
      };
    };

    # Standalone home-manager, e.g. for a work Mac with no matching
    # nixosConfiguration.
    homeConfigurations."me@work-mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./users/me/work-mac.nix ];
    };
  };
}
```

Rebuild commands:

```bash
sudo nixos-rebuild switch --flake .#laptop1
home-manager switch --flake .#me@work-mac   # standalone only
```

Because home-manager is wired as a NixOS module for `laptop1` and `server1`,
a single `nixos-rebuild switch` activates both the system and that user's
home in one step — you don't run `home-manager switch` separately on those
machines.

---

## 5. Override priority cheat sheet

| You want to... | Use |
|---|---|
| Set a value a lower layer can freely override | `lib.mkDefault value` |
| Set a value that always wins, even over a host's plain assignment | `lib.mkForce value` |
| Set a value normally, expecting nobody else touches it | plain `option = value` |
| Merge a list/attrset instead of replacing it | `lib.mkMerge [ ... ]` across files |

Rule of thumb: **modules** mostly leave values unset; **profiles** set
values with `mkDefault`; **hosts** set values plainly, and reach for
`mkForce` only when overriding something a profile set *without*
`mkDefault`.

---

## 6. Adding things — the common workflows

**Add a new reusable capability (e.g. a new service):**
1. Create `modules/nixos/<thing>.nix` declaring `options.myConfig.<thing>.*`.
2. Add it to `modules/nixos/default.nix`'s `imports`.
3. Turn it on in whichever profile(s) want it as the default.

**Add a new machine:**
1. Install NixOS, run `nixos-generate-config`, copy `hardware-configuration.nix`
   into `hosts/<name>/`.
2. Write `hosts/<name>/default.nix` importing the closest-fitting profile.
3. Add a `nixosConfigurations.<name>` entry in `flake.nix`.
4. If the machine has a user, add `users/<name-or-me>/<host>.nix` and wire
   `home-manager.users.<name> = import ...` into that host's module list.

**Add a new profile (a new category of machine):**
1. Create `profiles/nixos/<role>.nix`, import the modules it needs, set
   sensible `mkDefault` values.
2. Point any host that fits this role at it.

**Add a new user:**
1. Create `users/<name>/` with one file per host they use.
2. Add `home-manager.users.<name> = import ./users/<name>/<host>.nix;` to
   each relevant host's module list.

---

## 7. Why there is no `lib/mkHost` helper

Once you have more than 2–3 hosts, the repeated `nixpkgs.lib.nixosSystem { ... }`
blocks in `flake.nix` can be tempting to collapse into a `mkHost` helper that
takes a host name, a list of users, and wires everything up. Resist it for
hosts: a helper becomes a layer between the flake and the host leaf where
wiring can hide — which users live on a machine, which hardware module it
needs, which shared settings apply — so reading the leaf no longer tells you
what the machine pulls in. Bare `nixosSystem` calls with `system`,
`specialArgs`, and the leaf (see section 4) keep the flake a boring registry,
and the host leaf remains the complete inventory of the machine.

A `lib/` helper still earns its keep for standalone home-manager
configurations: `lib/mkHome.nix` wraps
`home-manager.lib.homeManagerConfiguration` with the shared `pkgs` and
`extraSpecialArgs`, and that wiring never grows beyond it.
