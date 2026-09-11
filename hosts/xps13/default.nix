# xps13 host leaf: the complete inventory of the machine — its profiles, its
# hardware, and the Users it declares — plus the handful of plain per-box
# overrides true of only this box.
{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/home-manager-wiring.nix
    inputs.hardware.nixosModules.dell-xps-13-9370
    ../../profiles/nixos/base.nix
    ../../profiles/nixos/desktop.nix
    ../../profiles/nixos/media-server.nix # dormant, zero-consumer
  ];

  nix.settings.trusted-users = ["rav"];

  # Declared Users: rav, at the system level and via home-manager.
  users.users.rav = {
    isNormalUser = true;
    description = "Rasmus Villebro";
    extraGroups = ["networkmanager" "wheel"];
  };
  home-manager.users.rav = import ../../users/rav/xps13.nix;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=0"
    ];
  };

  networking = {
    hostName = "xps13";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # xps13-specific nixpkgs additions (appended to the shared base overlays).
  nixpkgs.overlays = [inputs.nur.overlays.default];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
