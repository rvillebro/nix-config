# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, ... }: 
{
  # You can import other home-manager modules here
  imports = [
    ./shell
    ./editor
    ./home.nix
    ./browser.nix
    ./programs.nix
    ./ssh.nix
  ];

  xdg.enable = true;

  # enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}