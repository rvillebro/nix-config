{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    LESSKEY = "${config.xdg.configHome}/less/lesskey";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      completionInit = "autoload -U compinit && compinit -i";
      historySubstringSearch.enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
    starship.enable = true;
  };
}
