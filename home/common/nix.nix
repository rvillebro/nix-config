# Shared nix configuration for standalone home-manager setups.
# Only imported by non-NixOS home configs (hosts configure nix at the system level).
{
  outputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./cachix.nix
  ];

  nixpkgs = {
    overlays = [outputs.overlays.unstable-packages];
    config.allowUnfree = true;
  };

  # nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      extra-substituters = [config.cachix.nix-community.substituter];
      extra-trusted-public-keys = [config.cachix.nix-community.publicKey];
    };
  };
}
