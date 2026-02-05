{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        zj = "zellij";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;
    zellij.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          name = "Rasmus Villebro";
          email = "rasmus-villebro@hotmail.com";
        };
      };
    };

    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      settings = {
        theme = "Brogrammer";
      };
    };
  };
}