# Thin per-host layer for the xps13 home.
# Imports the User home module and keeps the GUI stack on top.
{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../home/user
    ./editors
    ./browser.nix
    ./pi-coding-agent.nix
  ];

  home = {
    packages = with pkgs; [
      # image editor
      gimp
      # password manager
      bitwarden-desktop
    ];
    sessionVariables = {
      # set default applications
      BROWSER = "firefox";
      TERMINAL = "ghostty";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  programs = {
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      settings = {
        theme = "Brogrammer";
      };
    };

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
  };
}
