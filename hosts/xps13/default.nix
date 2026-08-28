# xps13 host leaf: imports the desktop profile + its hardware; keeps only the
# hardware facts and the handful of plain per-box overrides true of this box.
{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/nixos/base.nix
    ../../profiles/nixos/desktop.nix
    ../../profiles/nixos/media-server.nix # dormant, zero-consumer
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = ["quiet" "udev.log_level=0"];
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
