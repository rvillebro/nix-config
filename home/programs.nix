{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    bash.enable = true;
    firefox.enable = true;
    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    ssh.enable = true;
    aria2.enable = true;

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

    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.95;
        window.dynamic_padding = true;
        scrolling.history = 10000;
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
      userEmail = "rasmus-villebro@hotmail.com";
    };
  };
}
