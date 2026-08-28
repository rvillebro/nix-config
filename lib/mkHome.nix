# Build a standalone home-manager User configuration from its User leaf
# (users/<person>/<deployment>.nix). Wraps
# `home-manager.lib.homeManagerConfiguration` with the shared specialArgs.
{
  inputs,
  outputs,
  nixpkgs,
  home-manager,
}: {
  system,
  modules,
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {inherit inputs outputs;};
  inherit modules;
}
