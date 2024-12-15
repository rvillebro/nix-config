{ config, pkgs, ... }:
{
  programs = {
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement of htop/nmon
    eza.enable = true; # modern replacement for ‘ls’
    aria2.enable = true; # download tool
    
    pyenv = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}