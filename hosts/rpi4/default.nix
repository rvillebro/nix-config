# rpi4 host leaf: the complete inventory of the machine — its profiles, its
# hardware, and the Users it declares — plus the binance module wiring and the
# handful of plain per-box overrides true of this box.
{
  inputs,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../../modules/nixos/home-manager-wiring.nix
    inputs.hardware.nixosModules.raspberry-pi-4
    ../../profiles/nixos/base.nix
    ../../profiles/nixos/server.nix
    outputs.nixosModules
  ];

  # Declared Users: rav's home-manager configuration for this machine.
  home-manager.users.rav = import ../../users/rav/rpi4.nix;

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

  users.users.rav.extraGroups = ["wheel"];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime"];
  };

  networking = {
    hostName = "rpi4";
    networkmanager.enable = true;
  };

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
