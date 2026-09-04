# Base NixOS profile: the shared system baseline for every Host.
{
  outputs,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # Plain list, not mkDefault: overlays is a list option whose definitions
    # concatenate, so a host leaf can append (e.g. nur on xps13) without
    # dropping the shared set.
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };

  time.timeZone = lib.mkDefault "Europe/Copenhagen";

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

  console.keyMap = "dk-latin1";

  users.users.rav = {
    isNormalUser = true;
    description = "Rasmus Villebro";
  };

  # Plain list, not mkDefault: environment.systemPackages has a non-empty
  # built-in default, and list definitions concatenate at the leaf.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    sysstat
    fastfetch
  ];

  programs.nix-ld.enable = true;

  # Plain value, not mkDefault: hosts layer additional registries onto the set.
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
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

  # weekly gc keeps disk usage low (hosts may tune the schedule)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
