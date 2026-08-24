# Thin per-host layer for the nixos-wsl home.
# Imports the User home module and keeps pi-coding-agent (machine-specific)
# on top. The shared building blocks (shell, editors, git identity), gh,
# bitwarden-cli, and the ssh client config come from the User home module.
{...}: {
  imports = [
    ../../../home/user
    ./pi-coding-agent.nix
  ];

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };
}
