{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    extraPackages = [
      pkgs.marksmen
      pkgs.unstable.ruff
      pkgs.python312Packages.python-lsp-server
    ];
  };
  home.file."helix-configuration.toml" = {
    source = "./helix-configuiration.toml";
    target = ".config/helix/config.toml";
  };
  home.file."helix-languages.toml" = {
    source = "./helix-languages.toml";
    target = ".config/helix/languages.toml";
  };
}