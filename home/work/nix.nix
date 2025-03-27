# setup basic nix configurations
{
  outputs,
  lib,
  ...
}:
{
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config.allowUnfree = true;
  };

  nix.registry.evaxpkgs.flake = "ssh://git@gitlab.lan.evaxion-biotech.com/tools/evaxpkgs.git";

  # nix settings
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

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };
}