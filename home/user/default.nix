# Canonical User home module for user rav.
# Single source of truth for the shared user environment: the shared
# building blocks (shell, editors, git identity), the gh and bitwarden-cli
# packages, the ssh client config, and the deployment-fact defaults
# (username, homeDirectory, stateVersion).
#
# Hosts and the rav@home standalone deployment are built from this module;
# hosts layer machine-specific extras on top and override the defaults.
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/git.nix
  ];

  home = {
    # Deployment facts, overridable by hosts (e.g. stateVersion stays
    # aligned with the host's system stateVersion).
    username = lib.mkDefault "rav";
    homeDirectory = lib.mkDefault "/home/rav";
    packages = with pkgs; [
      gh
      bitwarden-cli
    ];
    stateVersion = lib.mkDefault "25.11";
  };

  programs = {
    ssh = {
      enable = true;
      # Declare the client config explicitly so it keeps working when
      # home-manager removes its ssh defaults.
      enableDefaultConfig = false;
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
