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
      gh
    ];
    stateVersion = "25.11";
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
