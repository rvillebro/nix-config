{ config, pkgs, ... }:
{
  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    file.".face".source = ./cool_rick.png;
    packages = with pkgs; [
      # image editor
      gimp
      # password manager
      bitwarden-desktop
      bitwarden-cli
      # archives
      zip
      unzip
      pigz
    ];
    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "hx";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
    };
  };
}