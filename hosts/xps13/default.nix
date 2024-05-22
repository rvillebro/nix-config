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
    ../system.nix
    ../hyprland.nix
    ../users.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "xps13"; # Define your hostname.
    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = "/run/secrets/wireless.env";
      networks."@SSID_HOME@".psk = "@PSK_HOME@";
    }; # Enables wireless support via wpa_supplicant.
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
