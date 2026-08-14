# Shared nix-community cachix substituter + public key.
# Single canonical copy, referenced by `home/common/nix.nix`.
{lib, ...}: {
  options.cachix.nix-community = lib.mkOption {
    type = lib.types.submodule {
      options = {
        substituter = lib.mkOption {type = lib.types.str;};
        publicKey = lib.mkOption {type = lib.types.str;};
      };
    };
  };

  config.cachix.nix-community = {
    substituter = "https://nix-community.cachix.org";
    publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };
}
