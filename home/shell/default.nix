{
  pkgs,
  ...
}: {
  programs = {
    bash.enable = true;
    alacritty = {
      enable = true;
      package = pkgs.unstable.alacritty;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;
  };

  home.file."alacritty.toml" = {
    source = "./alacritty.toml";
    target = ".config/alacritty/alacritty.toml";
  };
}