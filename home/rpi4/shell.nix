{ ... }:
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
      userName = "Rasmus Villebro";
      userEmail = "rasmus-villebro@hotmail.com";
    };
  };
}
