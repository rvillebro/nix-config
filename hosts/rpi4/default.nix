# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
    ./virtualisation.nix

    # Binance data-collection services (stream + rest), owned by the module.
    # Imports the whole modules/nixos collection ({ imports = [ ... ] }).
    outputs.nixosModules

    # Import your generated (nixos-generate-config) hardware configuration
    #./hardware-configuration.nix
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

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Filesystem
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # Networking
  networking = {
    hostName = "rpi4";
    networkmanager.enable = true;
  };

  # Bluetooth
  hardware.raspberry-pi."4".bluetooth.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.openssh.enable = true;

  hardware.enableRedistributableFirmware = true;

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
