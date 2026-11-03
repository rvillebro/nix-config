# Hyprland home capability: compositor settings, the Noctalia shell, idle
# locking, theming, and clipboard tooling for the graphical session (ADR 0004).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cursorSize = "24";
  cursorTheme = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "Catppuccin-Mocha-Mauve-Cursors";
  };
in {
  imports = [inputs.noctalia.homeModules.default];

  options.myConfig.hyprland = {
    enable = lib.mkEnableOption "the Hyprland home configuration: shell, theming, and session tools";
  };

  config = lib.mkIf config.myConfig.hyprland.enable {
    home.packages = with pkgs; [
      wl-clipboard
      cliphist
    ];

    home.sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = cursorSize;
    };

    # Privilege prompts (pkexec/sudo GUI) need an agent in the session; this
    # channel has no NixOS module for it, so wire the packaged user unit here.
    systemd.user.services.hyprpolkitagent = {
      Unit = {
        Description = "Hyprland Polkit authentication agent";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };

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
      cursorTheme = cursorTheme;
    };

    programs.noctalia = {
      enable = true;
      settings = {
        shell.font = "FiraCode Nerd Font";
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        # Noctalia answers loginctl lock-session while it is running.
        general = {
          lock_cmd = "loginctl lock-session";
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
          "XCURSOR_THEME,${cursorTheme.name}"
          "XCURSOR_SIZE,${cursorSize}"
        ];

        exec-once = [
          "noctalia"
          "wl-paste --watch cliphist store"
        ];

        windowrule = ["float, class:^(dev.noctalia.Noctalia)$"];

        bind = [
          # Core
          "$mod, Return, exec, ghostty"
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

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
