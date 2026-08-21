# Thin per-host layer for the rpi4 home.
# Imports the User home module and overrides deployment-fact defaults.
{...}: {
  imports = [
    ../../../home/user
  ];

  home = {
    sessionVariables = {
      TERM = "xterm-256color";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };
}
