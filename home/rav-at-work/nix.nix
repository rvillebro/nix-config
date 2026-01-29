{
  outputs,
  pkgs,
}:
{
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config.allowUnfree = true;
  };

  # nix settings
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    registry.evaxpkgs = {
      from = {
        id = "evaxpkgs";
        type = "indirect";
      };
      to = {
        type = "git";
        url = "ssh://git@git.evax.ai/tools/evaxpkgs.git";
      };
    };
  };
}