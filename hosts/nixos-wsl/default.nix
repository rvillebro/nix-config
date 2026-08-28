# nixos-wsl host leaf: imports the base profile + WSL glue.
{...}: {
  imports = [
    ../../profiles/nixos/base.nix
  ];

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
