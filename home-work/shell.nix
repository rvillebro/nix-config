{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    LESSKEY = "${config.xdg.configHome}/less/lesskey";
  };

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
  };
}