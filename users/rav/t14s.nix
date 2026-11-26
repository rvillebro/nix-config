# Standalone User leaf for rav@t14s (work laptop): the shared baseline plus work-only tooling.
{
  lib,
  pkgs,
  config,
  ...
}: let
  # Evaxion palettes. `ansi` is the 16-color terminal palette in order
  # 0-15 (black red green yellow blue magenta cyan white, then brights).
  evaxion = {
    dark = {
      bg = "#263238";
      fg = "#e0ecf9";
      surface = "#35444c";
      cursor = "#e56159";
      ansi = [
        "#35444c"
        "#e56159"
        "#a7ab67"
        "#c2b295"
        "#8fb3dc"
        "#9c8fd4"
        "#8cc0c4"
        "#e0ecf9"
        "#7d8c95"
        "#f08a83"
        "#c4c78c"
        "#ddd0b6"
        "#b8d2f0"
        "#bdb3e6"
        "#b5dadd"
        "#ffffff"
      ];
    };
    light = {
      bg = "#ffffff";
      fg = "#35444c";
      surface = "#e0ecf9";
      cursor = "#c8423a";
      ansi = [
        "#35444c"
        "#c8423a"
        "#6f7333"
        "#756c5f"
        "#3d6a9e"
        "#6d5da9"
        "#2f7479"
        "#e0ecf9"
        "#6b7a83"
        "#e56159"
        "#8a8e4c"
        "#8f8574"
        "#5a86b8"
        "#8577c0"
        "#4a8f94"
        "#f5f5f5"
      ];
    };
  };

  ghosttyTheme = p: {
    background = p.bg;
    foreground = p.fg;
    cursor-color = p.cursor;
    cursor-text = p.bg;
    selection-background = p.surface;
    selection-foreground = p.fg;
    palette = lib.imap0 (i: c: "${toString i}=${c}") p.ansi;
  };
in {
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "25.11";

    packages = [pkgs.nerd-fonts.geist-mono];
    sessionVariables.TERMINAL = "ghostty";
  };

  programs = {
    git.settings = {
      user.name = "Rasmus Villebro";
      user.email = "rav@evaxion.ai";
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          IdentityFile = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
        };
        "utopia-1".HostName = "utopia-1";
      };
    };

    # systemd + D-Bus integration (https://ghostty.org/docs/linux/systemd):
    # home-manager ships the app-com.mitchellh.ghostty.service user unit and
    # the com.mitchellh.ghostty D-Bus service, so new windows can be created
    # via `ghostty +new-window` and D-Bus activation, with centralized
    # logging under `journalctl --user -u app-com.mitchellh.ghostty.service`.
    # Avoid setting `class` in the config; it breaks the unit/D-Bus wiring.
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      systemd.enable = true;
      settings = {
        theme = "light:Evaxion Light,dark:Evaxion Dark";
        font-family = "GeistMono Nerd Font";
        shell-integration-features = ["ssh-terminfo" "ssh-env"];

        # Linux default is true (quit when the last window closes); false
        # keeps the systemd service resident so new-window launches are
        # always instant, at the cost of a small resident memory footprint.
        quit-after-last-window-closed = false;
      };
      themes = {
        "Evaxion Dark" = ghosttyTheme evaxion.dark;
        "Evaxion Light" = ghosttyTheme evaxion.light;
      };
    };
  };

  targets.genericLinux.enable = true;
}
