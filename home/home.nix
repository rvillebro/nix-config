{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    file.".face".source = ./cool_rick.png;
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz

      # python
      python312

      # nix tooling
      alejandra
      deadnix
      statix
    ];
    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "vim";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
    };
  };
}