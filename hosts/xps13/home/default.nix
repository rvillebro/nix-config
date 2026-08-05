# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../home/common
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
      bitwarden-cli
      gh
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

    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = "rasmus-villebro@hotmail.com";
      };
    };

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "rpi4" = {
          hostname = "rpi4";
          user = "rav";
          forwardAgent = true;
        };
      };
    };
  };
}
