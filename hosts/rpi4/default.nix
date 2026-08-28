# rpi4 host leaf: imports the server profile + hardware; keeps the binance
# module wiring and the handful of plain per-box overrides true of this box.
{
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../../profiles/nixos/base.nix
    ../../profiles/nixos/server.nix

    # Binance data-collection services (stream + rest), owned by the module.
    # Imports the whole modules/nixos collection ({ imports = [ ... ] }).
    outputs.nixosModules
  ];

  # Binance data collection on the rpi4, via the myConfig.binance-collector
  # module. Read access to collected data goes through `readers`.
  myConfig.binance-collector = {
    stream = {
      enable = true;
      configFile = ./binance/stream_config.json;
    };
    rest = {
      enable = true;
      configFile = ./binance/rest_config.json;
    };
    readers = ["rav"];
  };

  # Extend the shared user account definition.
  users.users.rav.extraGroups = ["wheel"];

  # Bootloader + kernel for the Raspberry Pi 4.
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Filesystem.
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime"];
  };

  # Networking.
  networking = {
    hostName = "rpi4";
    networkmanager.enable = true;
  };

  # Bluetooth.
  hardware.raspberry-pi."4".bluetooth.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.enableRedistributableFirmware = true;

  services.openssh.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
