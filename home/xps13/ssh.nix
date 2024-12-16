{ config, pkgs, ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "rpi4" = {
        hostname = "rpi4";
        user = "rav";
        forwardAgent = true;
      };
    };
  };
}