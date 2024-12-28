{ config, pkgs, ... }:
{
  programs = {
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement of htop/nmon
    eza.enable = true; # modern replacement for ‘ls’
    aria2.enable = true; # download tool

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
    
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-vscode-remote.remote-ssh
        rust-lang.rust-analyzer
        golang.go
        jnoortheen.nix-ide
        mkhl.direnv
      ];
    };
  };
}