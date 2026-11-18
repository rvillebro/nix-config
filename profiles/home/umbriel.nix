# Umbriel home profile: the desktop session for graphical machines —
# theming, the Noctalia shell, idle locking, and clipboard tooling (ADR 0005).
# Imported explicitly by the User leaf (ADR 0003). Compositor keybinds and
# autostart live in the user's ~/.config/umbriel/config.toml, outside nix.
{
  config,
  inputs,
  pkgs,
  ...
}: let
  # Exact cursor theme directory name under the package's share/icons —
  # xcursor resolves by directory name (case-sensitive), and the greeter
  # resolves the same way, so login and session cursors match.
  cursorName = "catppuccin-mocha-mauve-cursors";
  cursorSize = 24;
in {
  imports = [inputs.noctalia.homeModules.default];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = cursorName;
    size = cursorSize;
    gtk.enable = true;
  };

  # Privilege prompts (pkexec/sudo GUI) need an agent in the session; the
  # packaged user service covers it. Compositor-agnostic, so it serves the
  # Umbriel session too.
  services.hyprpolkitagent.enable = true;

  # GNOME owned GTK theming before; home-manager owns it now.
  gtk = {
    enable = true;
    # Explicit for clarity: keep the GTK3 theme on GTK4 apps too (pre-26.05
    # home-manager default, silenced warning).
    gtk4.theme = {
      inherit (config.gtk.theme) package name;
    };
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        variant = "mocha";
      };
      name = "catppuccin-mocha-mauve-standard+default";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # What apps read for dark-mode detection: Firefox, Chromium/Electron, and
  # libadwaita apps query the xdg-desktop-portal Settings interface
  # (org.freedesktop.appearance color-scheme), which the GTK portal sources
  # from this GSettings key. GNOME used to own it; without it apps stay light
  # even with the dark GTK theme above. The gtk module pulls in dconf, so this
  # persists on its own.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  programs.noctalia = {
    enable = true;
    settings = {
      shell.font_family = "FiraCode Nerd Font";
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
    };
  };

  # Idle daemon for the Umbriel session: it listens on ext-idle-notify-v1,
  # which Umbriel implements, so this Hyprland-packaged daemon works here
  # unchanged. DPMS is driven through Umbriel's own IPC (`umbriel msg
  # dpms-off`/`dpms-on`) instead of hyprctl.
  services.hypridle = {
    enable = true;
    settings = {
      # Noctalia answers loginctl lock-session while it is running.
      general = {
        # NOTE: lock_cmd must NOT be "loginctl lock-session". hypridle runs
        # lock_cmd every time it *receives* the logind Lock event, so pointing
        # it back at loginctl creates an infinite re-lock loop (unlocks, then
        # locks again immediately). Noctalia shows the lock screen on the
        # D-Bus Lock event itself, so hypridle needs no lock_cmd here.
        after_sleep_cmd = "umbriel msg dpms-on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "umbriel msg dpms-off";
          on-resume = "umbriel msg dpms-on";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
