# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./shell.nix
    ./neovim.nix
    ./programs.nix
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      gnutar

      # nix tooling
      alejandra
      deadnix
      statix

      # fonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };

  # enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
