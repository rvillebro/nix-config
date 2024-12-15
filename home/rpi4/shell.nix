{ pkgs, ... }:
{
  programs = {
    bash.enable = true;
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

  home.file."alacritty.toml" = {
    source = ./alacritty.toml;
    target = ".config/alacritty/alacritty.toml";
  };
}