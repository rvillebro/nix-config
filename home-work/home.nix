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
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      tar

      # python
      python311

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
    };
  };
}
