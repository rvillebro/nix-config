{ config, pkgs, ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
    Host rpi4
      Hostname rpi4
      Username rav
      ForwardAgent yes
    '';
  };
}