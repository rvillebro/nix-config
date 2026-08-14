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
    ../common/git.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      gh
    ];
    stateVersion = "25.11";
  };

  nix.settings = {
    # Note that you need to be a trusted user to set these
    extra-substituters = [
      "https://cache.numtide.com"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  programs = {
    ssh = {
      enable = true;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
        };
        "rpi4" = {
          HostName = "rpi4";
          User = "rav";
          ForwardAgent = true;
        };
      };
    };
  };
}
