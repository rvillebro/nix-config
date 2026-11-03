# GNOME replaced by Hyprland + Noctalia on the desktop

The xps13 is the only graphical machine in the repo, and its desktop ran GNOME/GDM. We decided to replace GNOME with a Wayland stack: **Hyprland** as compositor/tiler, **Noctalia Shell** as the desktop shell, and **Noctalia Greeter** (greetd-based) as the login screen. GNOME's bundle was heavier than needed and a tiling compositor + Quickshell shell fits the repo's minimal, declarative style better.

## Migration strategy

Parallel transition, not big-bang: Hyprland is added while GNOME stays available as a second session, a verification checklist must pass, and only then is GNOME removed in a follow-up commit. GDM stays through the transition; the greeter swap (greetd + noctalia-greeter) lands as its own commit.

## Considered options

- **Big-bang replacement** — rejected: risks losing the fallback session while the new stack is unproven.
- **Keeping GDM permanently** — rejected: Noctalia Greeter provides a login screen in the same visual language, and greetd is lighter than GDM.

## Consequences

- `profiles/nixos/desktop.nix` becomes the generic graphical-desktop capability (pipewire, fonts, printing, NetworkManager); GNOME/GDM-specific bits move out and are deleted in the removal commit.
- Hyprland, Noctalia Shell, and Noctalia Greeter arrive as flake inputs (both following the repo's nixpkgs) with system modules plus a home-manager module for Hyprland/Noctalia/theming config, imported by `profiles/home/gui.nix`.
- `programs.dconf.enable` is kept even after GNOME removal: Electron apps (Bitwarden) still use the dconf backend.
- The `dk` keyboard layout is configured in Hyprland's input config immediately; `services.xserver.xkb` goes away together with the transitional GNOME block in the removal commit.