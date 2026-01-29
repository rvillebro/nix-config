{
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    extraPackages = [
      pkgs.marksman
      pkgs.unstable.ruff
      pkgs.python3Packages.python-lsp-server
      pkgs.rust-analyzer
    ];
  };
  home.file."helix-configuration.toml" = {
    source = ./helix-configuration.toml;
    target = ".config/helix/config.toml";
  };
  # home.file."helix-languages.toml" = {
  #   source = ./helix-languages.toml;
  #   target = ".config/helix/languages.toml";
  # };
}
