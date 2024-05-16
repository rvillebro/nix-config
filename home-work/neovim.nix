{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };
}