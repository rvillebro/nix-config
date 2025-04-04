# setup basic nix configurations
{
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config.allowUnfree = true;
  };

  # nix settings
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "nix-command flakes";

    # Note that you need to be a trusted user to set these
    extra-substituters = [ 
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # internal evaxion pkgs repository
  nix.registry.evaxpkgs = {
    from = {
      id = "evaxpkgs";
      type = "indirect";
    };
    to = {
      type = "git";
      url = "ssh://git@git.evax.ai/tools/evaxpkgs.git";
    };
  };
}