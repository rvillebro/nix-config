# GNOME replaced by Hyprland + Noctalia on the desktop

*Executed 2026-11 (PRs #60–#63); the migration strategy below is kept as the
record of how. The decision and its consequences remain the standing rationale
for `profiles/nixos/desktop.nix`, `profiles/home/hyprland.nix`, and the greeter
setup.*
The xps13 is the only graphical machine in the repo, and its desktop ran GNOME/GDM. We decided to replace GNOME with a Wayland stack: **Hyprland** as compositor/tiler, **Noctalia Shell** as the desktop shell, and **Noctalia Greeter** (greetd-based) as the login screen. GNOME's bundle was heavier than needed and a tiling compositor + Quickshell shell fits the repo's minimal, declarative style better.

## Migration strategy

Parallel transition, not big-bang: Hyprland is added while GNOME stays available as a second session, a verification checklist must pass, and only then is GNOME removed in a follow-up commit. GDM stays through the transition; the greeter swap (greetd + noctalia-greeter) lands as its own commit.

## Considered options

- **Big-bang replacement** — rejected: risks losing the fallback session while the new stack is unproven.
- **Keeping GDM permanently** — rejected: Noctalia Greeter provides a login screen in the same visual language, and greetd is lighter than GDM.

## Consequences

- `profiles/nixos/desktop.nix` becomes the generic graphical-desktop capability (pipewire, fonts, printing, NetworkManager); GNOME/GDM-specific bits move out and are deleted in the removal commit.
- The system services live inline in `profiles/nixos/desktop.nix` (the desktop capability, fixed facts — no module per ADR 0002) and the session config in a new `profiles/home/hyprland.nix`, imported explicitly by the User leaf (ADR 0003).
- `programs.dconf.enable` is kept even after GNOME removal: Electron apps (Bitwarden) still use the dconf backend.
- The `dk` keyboard layout is configured in Hyprland's input config immediately; `services.xserver.xkb` goes away together with the transitional GNOME block in the removal commit.