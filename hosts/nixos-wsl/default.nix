# nixos-wsl host leaf: the complete inventory of the machine — its profile,
# its WSL glue, and the User it declares.
{inputs, ...}: {
  imports = [
    ../../modules/nixos/home-manager-wiring.nix
    inputs.nixos-wsl.nixosModules.wsl
    ../../profiles/nixos/base.nix
  ];

  # Declared Users: rav, at the system level and via home-manager.
  users.users.rav = {
    isNormalUser = true;
    description = "Rasmus Villebro";
    extraGroups = ["wheel"];
  };
  home-manager.users.rav = import ../../users/rav/nixos-wsl.nix;

  nix.settings.trusted-users = ["rav"];

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
