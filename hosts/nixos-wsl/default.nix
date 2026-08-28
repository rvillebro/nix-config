# nixos-wsl host leaf: imports the base profile + WSL glue. Stays named
# `nixos-wsl` (renaming deferred); keeps only WSL facts and per-box overrides.
{...}: {
  imports = [
    ../../profiles/nixos/base.nix
  ];

  # Extend the shared user account definition.
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
