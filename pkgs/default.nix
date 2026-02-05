# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: rec {
  # example = pkgs.callPackage ./example { };
  binance-core = pkgs.python3Packages.callPackage ./binance-core {};
  binance-collector = pkgs.python3Packages.callPackage ./binance-collector {
    inherit binance-core;
  };
}
