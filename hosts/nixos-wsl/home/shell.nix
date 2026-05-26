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
      settings = {
        user.name = "Rasmus Villebro";
        user.email = "rasmus-villebro@hotmail.com";
      };
    };
  };
}
