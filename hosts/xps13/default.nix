# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
    ./media-server.nix # nix server
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=0" ];
  };

  # Networking.
  networking = {
    hostName = "xps13";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  programs.dconf.enable = true; # dconf settings for GNOME and other applications

  # xps13-specific nixpkgs additions
  nixpkgs.overlays = [ inputs.nur.overlays.default ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  # enable home-manager
  home-manager.users.rav = import ./home;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}