{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        l = "eza";
        ll = "eza -lh";
        la = "eza -alh";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[›](bold green)";
          error_symbol = "[›](bold red)";
        };
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rav@evaxion-biotech.com";
    };

    neovim = {
      enable = true;
      vimAlias = true;
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    aria2.enable = true;
  };
}
