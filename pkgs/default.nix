# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs,
  ...
}:
pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs.python3Packages) callPackage newScope;
  directory = ./modules/python;
}
// pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./modules/default;
}
