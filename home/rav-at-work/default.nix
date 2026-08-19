# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/git.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      glab # gitlab cli
    ];
    stateVersion = "25.11";
  };

  nix.registry.evaxpkgs = {
    from = {
      id = "evaxpkgs";
      type = "indirect";
    };
    to = {
      type = "git";
      url = "ssh://git@git.evax.ai/tools/evaxpkgs.git";
    };
  };

  programs = {
    jq.enable = true;
    gh.enable = true;
    ripgrep.enable = true;
    rclone.enable = true;
    awscli.enable = true;

    git = {
      settings.user.email = "rav@evaxion.ai";
    };

    ssh = {
      enable = true;
      settings = {
        "*" = {
          IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
        };
        "utopia-1" = {
          HostName = "utopia-1";
        };
        "utopia-2" = {
          HostName = "utopia-2";
        };
      };
    };
  };
}
