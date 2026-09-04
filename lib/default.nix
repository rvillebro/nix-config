# Helper function that builds standalone home-manager Users from their thin
# leaves. See `repository-structure.md` for the layer model. NixOS Hosts need
# no builder: the flake wires bare `nixosSystem` calls around their leaves.
{
  inputs,
  outputs,
  nixpkgs,
  home-manager,
}: {
  mkHome = import ./mkHome.nix {inherit inputs outputs nixpkgs home-manager;};
}
