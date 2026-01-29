# setup basic nix configurations
{
  outputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config.allowUnfree = true;
  };

  # nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      # Note that you need to be a trusted user to set these
      extra-substituters = [ 
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
        "https://cache.nixos-cuda.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}