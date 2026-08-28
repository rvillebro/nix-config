# Base NixOS role profile: the shared system baseline imported by every Host.
# Drawn from the old hosts/common base + nix trees. Declares no options. Values
# a host may plausibly vary (timezone, nix settings, gc schedule, overlays) are
# set with `lib.mkDefault` so the host leaf can override without conflict;
# uniform base facts are plain values.
{
  outputs,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # All overlays apply to every host (incl. rpi4/nixos-wsl) for parity with xps13.
    # This is fine: `additions` only provides custom packages, `modifications` is
    # currently empty, and `unstable-packages` merely exposes the pinned unstable
    # channel as pkgs.unstable.
    overlays = lib.mkDefault [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };

  # Set your time zone (per-machine; hosts may choose differently).
  time.timeZone = lib.mkDefault "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rav = {
    isNormalUser = true;
    description = "Rasmus Villebro";
  };

  # List packages installed in system profile.
  # Note: left as a plain list, not mkDefault — environment.systemPackages has a
  # non-empty built-in default, and list definitions concatenate at the leaf.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    sysstat
    fastfetch
  ];

  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS.

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  # (Left as a plain value, not mkDefault: hosts layer additional registries on
  # top of this attrset rather than override the whole set.)
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # nix settings
  nix.settings = lib.mkDefault {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["rav"];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = lib.mkDefault {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
