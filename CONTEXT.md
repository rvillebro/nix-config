# Nix Configuration

Personal NixOS and home-manager configuration managing multiple machines with shared modules.

## Language

**Host**:
A NixOS machine configuration (`hosts/<name>/`), declared as a `nixosConfiguration` in the flake. Currently: `xps13`, `rpi4`, `nixos-wsl`.
_Avoid_: Machine, system, box

**Standalone home-manager**:
A home-manager configuration used on non-NixOS machines, declared as a `homeConfiguration` in the flake (`home/rav-at-home`, `home/rav-at-work`). Manages user-level packages and dotfiles without NixOS.
_Avoid_: Profile, user config

**Module**:
A reusable `.nix` file exposing options under a namespaced prefix. Lives in `modules/nixos/` (NixOS modules, option prefix `rav.nixos.*`) or `modules/home-manager/` (home-manager modules, option prefix `rav.home-manager.*`). Both host configs and standalone home-manager configs import from modules.
_Avoid_: Component, mixin

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
A declared configuration knob on a module, e.g. `rav.home-manager.editor.helix.theme`. Modules use `lib.mkOption` and `lib.mkDefault` for overridable defaults.
_Avoid_: Setting, parameter

## Flagged ambiguities

- **"Configuration"** can refer to the entire repo, a host's `default.nix`, or a module's option set. In this project, prefer the specific term (Host, Module, Option) over the generic "configuration."

## Example dialogue

**Dev**: "I want to add a new machine. Do I create a host or a standalone home-manager?"
**Domain expert**: "If it runs NixOS, create a host under `hosts/<name>/`. Import the NixOS modules you need (`base-system`, `desktop`, `nix-config`) and set your host-specific boot/networking. If it's not NixOS, create a standalone under `home/rav-<profile>/` and import home-manager modules instead."
**Dev**: "Got it. And do I create new modules for it?"
**Domain expert**: "Only if what you're configuring isn't already captured by an existing module. Check `modules/nixos/` and `modules/home-manager/` first."