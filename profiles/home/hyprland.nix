# Hyprland home profile: the desktop session for graphical machines —
# compositor settings, the Noctalia shell, idle locking, theming, and
# clipboard tooling (ADR 0004). Imported explicitly by the User leaf (ADR 0003).
{
  config,
  inputs,
  pkgs,
  ...
}: let
  # Exact cursor theme directory name under the package's share/icons —
  # xcursor/hyprcursor resolve by directory name (case-sensitive), and the
  # greeter resolves the same way, so login and session cursors match.
  cursorName = "catppuccin-mocha-mauve-cursors";
  cursorSize = 24;
in {
  imports = [inputs.noctalia.homeModules.default];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];

  # Owns the cursor theme installation: the ~/.icons and default index.theme
  # symlinks (how apps actually resolve the theme), the GTK cursor theme, and
  # the XCURSOR/HYPRCURSOR session variables. The Hyprland env block below
  # re-declares the same values because greetd sessions do not inherit
  # home-manager sessionVariables.
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = cursorName;
    size = cursorSize;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  # Privilege prompts (pkexec/sudo GUI) need an agent in the session; the
  # packaged user service covers it.
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

  programs.noctalia = {
    enable = true;
    settings = {
      shell.font_family = "FiraCode Nerd Font";
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      # Fade the desktop wallpaper in at shell startup instead of popping it
      # over Hyprland's plain fallback backdrop (upstream renders the source
      # transparently, so the fade composes with misc below).
      wallpaper.transition_on_startup = true;
    };
  };

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
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang"; # legacy default pre-26.05, explicit to silence warning
    settings = {
      "$mod" = "SUPER";

      monitor = [",preferred,auto,1"];

      input = {
        kb_layout = "dk";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
      };

      env = [
        "XCURSOR_THEME,${cursorName}"
        "XCURSOR_SIZE,${toString cursorSize}"
        "HYPRCURSOR_THEME,${cursorName}"
        "HYPRCURSOR_SIZE,${toString cursorSize}"
      ];

      # No default backdrop (ASCII-art splash) before Noctalia's wallpaper
      # daemon draws; the gap renders as a plain background that the Noctalia
      # wallpaper fades in over (transition_on_startup above).
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      exec-once = [
        "noctalia"
        "wl-paste --watch cliphist store"
      ];

      # Hyprland 0.53+ windowrule syntax: match props and valued boolean
      # effects ("float on"); the old "float, class:..." form is invalid.
      windowrule = ["float on, match:class ^(dev.noctalia.Noctalia)$"];

      bind = [
        # Core
        "$mod, Return, exec, ghostty"
        "$mod, W, exec, firefox"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, L, exec, loginctl lock-session"

        # Noctalia panels
        "$mod, Space, exec, noctalia msg panel-toggle launcher"
        "$mod, C, exec, noctalia msg panel-toggle control-center"
        "ALT, Tab, exec, noctalia msg window-switcher hold"
        "ALT SHIFT, Tab, exec, noctalia msg window-switcher hold reverse"

        # Noctalia OSDs (volume/brightness)
        ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
        ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
        ", XF86AudioMute, exec, noctalia msg volume-mute"
        ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
        ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
      ];

      # Touchpad gestures: three-finger horizontal swipe switches workspaces
      gesture = [
        "3, horizontal, workspace"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
