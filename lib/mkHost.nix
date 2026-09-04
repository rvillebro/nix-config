# Build a NixOS Host configuration from its thin leaf (hosts/<name>).
# Host leaves declare their own Users and import their own hardware/glue
# modules (see hosts/xps13), so what remains is bare wiring: the shared
# home-manager glue (modules/nixos/home-manager-wiring.nix) plus the leaf.
{
  inputs,
  outputs,
  nixpkgs,
}: {
  system,
  module,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {inherit inputs outputs;};
  modules = [
    ../modules/nixos/home-manager-wiring.nix
    module
  ];
}
