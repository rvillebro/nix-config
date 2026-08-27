# Base home profile: the shared, person-level baseline for every User.
{
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    username = lib.mkDefault "rav";
    homeDirectory = lib.mkDefault "/home/rav";
    stateVersion = lib.mkDefault "25.11";

    packages = with pkgs; [
      zip
      unzip
      pigz
      gnutar
      bitwarden-cli
    ];

    shellAliases = {
      zj = "zellij";
      cat = "bat";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza -lT";
      tree = "eza -T";
    };

    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      EDITOR = "hx";
      PAGER = "less -RF";
    };
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;

  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  programs = {
    home-manager.enable = true;

    bash.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;
    zellij.enable = true;

    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    aria2.enable = true;
    gh.enable = true;
    jq.enable = true;
    ripgrep.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          "line-number" = "relative";
          mouse = false;
        };
      };
      extraPackages = [
        pkgs.marksman
        pkgs.unstable.ruff
        pkgs.python3Packages.python-lsp-server
        pkgs.rust-analyzer
      ];
    };

    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = lib.mkDefault "rasmus-villebro@hotmail.com";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  services.ssh-agent.enable = true;
}
