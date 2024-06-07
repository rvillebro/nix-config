{
  config,
  pkgs,
  ...
}: {
  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.unstable.alacritty;
}