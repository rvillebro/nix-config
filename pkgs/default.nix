# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  pythonNewScope = extra: lib.callPackageWith (pkgs.python3Packages // extra);
  defaultNewScope = extra: lib.callPackageWith (pkgs // extra);
in
lib.packagesFromDirectoryRecursive {
  callPackage = pythonNewScope {};
  newScope = pythonNewScope;
  directory = ./modules/python;
}
// lib.packagesFromDirectoryRecursive {
  callPackage = defaultNewScope {};
  newScope = defaultNewScope;
  directory = ./modules/default;
}
