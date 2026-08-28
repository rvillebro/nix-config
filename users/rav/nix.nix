# Standalone-only nix facts for the standalone User leaves (rav@home, rav@work).
{
  outputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = [outputs.overlays.unstable-packages];
    config.allowUnfree = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
