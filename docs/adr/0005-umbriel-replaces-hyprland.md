# Umbriel replaces Hyprland as xps13's compositor

*Executed 2026-11. Supersedes the compositor half of ADR 0004; the greeter
swap and the shell decision from that ADR remain standing.*

After the Umbriel trial (commit `9d21a23`: Umbriel added as a second session
alongside Hyprland), the compositor adoption is settled: **Umbriel** becomes
xps13's only Wayland session and **Hyprland is removed**. Noctalia Shell and
Noctalia Greeter are unchanged — Umbriel is from the same Noctalia family, and
the shell already targets it.

## Why

- The trial proved out: keybinds, layout (scrolling columns with tabs), and
  the Noctalia integration all live in the user's `~/.config/umbriel/config.toml`
  and were tuned to the point of preference. Running both compositors means
  two configs to keep in sync for no benefit.
- Umbriel is developed alongside Noctalia Shell, so shell/compositor features
  land together; Hyprland integration is a second front the shell must support.

## Consequences

- `programs.umbriel.enable` moves into `profiles/nixos/desktop.nix` (the
  desktop capability) together with the `inputs.umbriel.nixosModules.default`
  import; the host leaf keeps only the machine-specific binary-cache settings
  (`umbriel.cachix.org` substituter + key, matching the pinned `cachix` branch).
- The greeter's default session becomes `Umbriel`.
- Umbriel's own `xdg-desktop-portal-umbriel` replaces
  `xdg-desktop-portal-hyprland` for screencast; the GTK portal stays for
  file-picker dialogs and the Settings (dark-mode) interface. The umbriel
  module sets `config.umbriel` itself.
- `profiles/home/hyprland.nix` is renamed to `profiles/home/umbriel.nix`; the
  Hyprland config block (keybinds, gestures, env, window rules) is deleted —
  all of it lives in the user's config.toml now.
- `services.hypridle` is kept despite the name: it speaks
  ext-idle-notify-v1, which Umbriel implements, and DPMS goes through
  `umbriel msg dpms-off`/`dpms-on` instead of hyprctl. Locking still goes
  through `loginctl lock-session` → Noctalia's lock screen.
- `services.hyprpolkitagent` is kept: the agent is compositor-agnostic.
- Clipboard history keeps working via the `wl-paste --watch cliphist store`
  autostart, now in the user's config.toml (previously a Hyprland exec-once).
- The user config stays unmanaged, per the trial's design: live-reloadable,
  no rebuild needed.
