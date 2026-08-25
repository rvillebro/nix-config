# Nix Configuration

Personal NixOS and home-manager configuration managing multiple machines with shared modules.

## Language

**Host**:
A NixOS machine configuration (`hosts/<name>/`), declared as a `nixosConfiguration` in the flake. Currently: `xps13`, `rpi4`, `nixos-wsl`. The leaf of the layer: it imports the profile(s) that fit it plus its hardware, and overrides with `mkForce` anything true of only that box.
_Avoid_: Machine, system, box

**Profile**:
A reusable category config (`profiles/nixos/` for a kind of machine, `profiles/home/` for a persona) that imports modules and sets their options to sensible defaults (`mkDefault` or the module's own default) for its role. Declares no new options; a host (for a `profiles/nixos/`) or a user (for a `profiles/home/`) imports it and may override.
_Avoid_: Role, persona, category, bundle

**User**:
A person's home-manager configuration for one particular machine (`users/<name>/<host>.nix`), the home-manager counterpart to a host. Each person gets one file per machine they use, because their needs differ by machine. Whether the machine runs NixOS and the user rides along with the host (`home-manager.users`), or has no NixOS layer and the user configures the home on its own, is merely how that User is wired up — not a different concept. A User always configures user-level packages and dotfiles.
_Avoid_: Person, account, home
(There is no separate "standalone home-manager"; that name described how a User is used outside a host, not a distinct kind of thing.)

**Module**:
A reusable `.nix` file exposing options under a namespaced prefix. Lives in `modules/nixos/` (NixOS modules, option prefix `rav.nixos.*`) or `modules/home-manager/` (home-manager modules, option prefix `rav.home-manager.*`). Imported by profiles, hosts, and users; declares options and wires them to real options behind `mkIf`.
_Avoid_: Profile, mixin, class

**NixOS module**:
A module targeting `nixosSystem` consumers. Exposes options under `rav.nixos.*`. Deals with system-level concerns like boot, networking, display, users.
_Avoid_: System module

**Binance collector**:
The NixOS module (`rav.nixos.binance-collector`) that runs the Binance data-collection services on the rpi4 host. Owns the systemd units (stream and rest), the service user, and the group that grants read access to collected data.
_Avoid_: Data collection service, collector config

**Home-manager module**:
A module targeting `homeManagerConfiguration` consumers (both embedded in hosts and standalone). Exposes options under `rav.home-manager.*`. Deals with user-level concerns like editor, shell, git, browser.
_Avoid_: User module, dotfile module

**Option**:
A declared configuration knob on a module, e.g. `rav.home-manager.editor.helix.theme`. Modules use `lib.mkOption` and set defaults via `mkDefault`; hosts override with `mkForce`. Value-setting layers keep override intent explicit (`mkDefault` in profiles, `mkForce` in hosts).
_Avoid_: Setting, parameter

## Flagged ambiguities

- **"Configuration"** can refer to the entire repo, a host's `default.nix`, or a module's option set. Prefer the specific term (Host, Profile, Module, Option) over the generic "configuration."
- **"Profile"** here means a reusable config class (`profiles/nixos/`, `profiles/home/`), not a User. The configs that already exist (under `users/rav-*/` or via people) are all Users, never Profiles — a User wired to run without a host is still a User, don't call it one.
- **"Standalone"** describes how a User is wired (no host), not a distinct concept. There is no `standalone home-manager` term; it was removed as a duplicate of User.
- **Layering** — values flow downward through the layers. Nothing above a host imports a host; nothing above a profile imports a profile. Modules only declare; profiles and users set `mkDefault`; hosts override with `mkForce`.
  _The repo is not yet organised into `modules/ -> profiles/ -> hosts/` + `users/`; this vocabulary describes that target shape, not the current directory layout._

## Example dialogue

**Dev**: "I want to add a new machine. Do I create a host or a user?"
**Domain expert**: "If it runs NixOS, create a host under `hosts/<name>/`. Import the profile that fits its role (`profiles/nixos/desktop`, `headless`, …) plus its hardware, and override with `mkForce` anything true of only this box — don't invent host-specific modules. If it needs home-manager, give each person a user file under `users/<name>/<host>.nix` — the same User concept whether the harness runs NixOS alongside it or not."
**Dev**: "Got it. And do I create new modules or profiles for it?"
**Domain expert**: "Check `modules/nixos/` and `modules/home-manager/` first. Create a new module only if the capability isn't captured yet; create a new profile only if there's a genuinely new category of machine or persona."