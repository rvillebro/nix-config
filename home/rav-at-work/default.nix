# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/nix.nix
    ./editor
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
    zsh.enable = true;
    jq.enable = true;
    gh.enable = true;
    ripgrep.enable = true;
    rclone.enable = true;
    awscli.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = "rav@evaxion.ai";
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          addKeysToAgent = "yes";
        };
        "utopia-1" = {
          hostname = "utopia-1";
        };
        "utopia-2" = {
          hostname = "utopia-2";
        };
      };
    };
  };
}