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
    ./nix.nix
    ./configuration.nix
    ./plex.nix # nix server
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

  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS.
  programs.dconf.enable = true; # dconf settings for GNOME and other applications

  # enable home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "homeManagerBackupFileExtension";
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
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
