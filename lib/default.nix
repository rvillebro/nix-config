# Helper functions that build NixOS Hosts and standalone home-manager Users
# from their thin leaves. See `repository-structure.md` for the layer model.
{
  inputs,
  outputs,
  nixpkgs,
  home-manager,
}: let
  mkHost = import ./mkHost.nix {inherit inputs outputs nixpkgs;};
  mkHome = import ./mkHome.nix {inherit inputs outputs nixpkgs home-manager;};
in {
  inherit mkHost mkHome;
}
