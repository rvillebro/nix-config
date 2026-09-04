# nixos-wsl host leaf: the complete inventory of the machine — its profile,
# its WSL glue, and the User it declares.
{inputs, ...}: {
  imports = [
    ../../modules/nixos/home-manager-wiring.nix
    inputs.nixos-wsl.nixosModules.wsl
    ../../profiles/nixos/base.nix
  ];

  # Declared Users: rav's home-manager configuration for this machine.
  home-manager.users.rav = import ../../users/rav/nixos-wsl.nix;

  users.users.rav.extraGroups = ["wheel"];

  wsl = {
    enable = true;
    defaultUser = "rav";
    # wsl.docker-desktop.enable = true;
    useWindowsDriver = true;
  };

  environment.sessionVariables.LD_LIBRARY_PATH = ["/usr/lib/wsl/lib"];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
