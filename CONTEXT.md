# Nix Configuration

Personal NixOS and home-manager configuration managing multiple machines with shared modules.

## Language

**Module**:
A reusable `.nix` file exposing options in `modules/nixos/` (system-level) or `modules/home-manager/` (user-level). Imported by profiles, hosts, and users; declares options and wires them to real options behind `mkIf`.
_Avoid_: Profile, mixin, class, system module, user module

**Option**:
A declared configuration knob on a module, e.g. `myConfig.editor.helix.theme`. Modules use `lib.mkOption`. Layers set plain values by default — plain sets merge; `mkDefault` and `mkForce` are intent declarations used only when priority matters: `mkDefault` when a value is a suggestion a leaf is expected to override, `mkForce` when a value must win over any other definition. They are not layer badges; no layer reaches for them by default.
_Avoid_: Setting, parameter

**Binance collector**:
The NixOS module that runs the Binance data-collection services on the rpi4 host. Owns the systemd units (stream and rest), the service user, and the group that grants read access to collected data.
_Avoid_: Data collection service, collector config

**Profile**:
A reusable category config (`profiles/nixos/` for a kind of machine, `profiles/home/` for a persona) that imports modules and sets their options to sensible defaults for its role — plain values, or `mkDefault` where a leaf is expected to override. Declares no new options; a host (for a `profiles/nixos/`) or a user (for a `profiles/home/`) imports it and may override. Profiles never import other profiles — the leaf (host or user) lists every profile it imports, so its `imports` list is a complete inventory of what is pulled in.
_Avoid_: Role, persona, category, bundle

**Host**:
A NixOS machine configuration (`hosts/<name>/`), declared as a `nixosConfiguration` in the flake. Currently: `xps13`, `rpi4`, `nixos-wsl`. The leaf for machines: its leaf file is the complete inventory of what the machine pulls in — the profile(s) that fit it, its hardware, and the Users it declares — and it overrides anything true of only that box (`mkForce` only when a plain set would not win). A Host only sets NixOS-level things; home-level configuration, even machine-specific, belongs in the User file. A Host always declares its own Users; the flake never wires Users to a Host behind the Host's back.
_Avoid_: Machine, system, box

**User**:
A person's home-manager configuration for one particular machine (`users/<name>/<host>.nix`), the home-manager counterpart to a host. Each person gets one file per machine they use, because their needs differ by machine. A User is the flex point of the chain: a Host pulls it up (declaring it in the Host's leaf), or the flake exposes it directly as a standalone home — in which case the User is the leaf. How a User is wired is not a different concept. A User always configures user-level packages and dotfiles.
_Avoid_: Person, account, home

## Flagged ambiguities

- **"Configuration"** can refer to the entire repo, a host's `default.nix`, or a module's option set. Prefer the specific term (Host, Profile, Module, Option) over the generic "configuration."
- **"Profile"** here means a reusable config class (`profiles/nixos/`, `profiles/home/`), not a User. The configs that already exist (under `users/rav-*/` or via people) are all Users, never Profiles — a User wired to run without a host is still a User, don't call it one.
- **"Standalone"** describes how a User is wired (no host), not a distinct concept. There is no `standalone home-manager` term; it was removed as a duplicate of User.
- **Layering** — the repo is one chain, not a tree: modules ← profiles ← users ← hosts. Values flow downward through the layers. Profiles never import profiles (see ADR 0003) — only Users and Hosts compose profiles. Users are the flex point: a Host declares its Users in its own leaf, or the flake exposes the User directly (standalone home), making the User the leaf. Modules only declare; every layer sets plain values and reaches for `mkDefault`/`mkForce` only to express override intent (see Option).

## Example dialogue

**Dev**: "I want to add a new machine. Do I create a host or a user?"
**Domain expert**: "If it runs NixOS, create a host under `hosts/<name>/`. Import the profile that fits its role (`profiles/nixos/desktop`, `headless`, …), its hardware, and each person's user file under `users/<name>/<host>.nix` — the host leaf lists all of it. Override with `mkForce` anything true of only this box — don't invent host-specific modules. A user file is the same User concept whether a Host declares it or the flake exposes it standalone."
**Dev**: "Got it. And do I create new modules or profiles for it?"
**Domain expert**: "Check `modules/nixos/` and `modules/home-manager/` first. Create a new module only if the capability isn't captured yet; create a new profile only if there's a genuinely new category of machine or persona."
