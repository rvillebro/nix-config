{ pkgs,  ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = [
      pkgs.marksman
      pkgs.unstable.ruff
      pkgs.python312Packages.python-lsp-server
      pkgs.rust-analyzer
    ];
  };
  home.file."helix-configuration.toml" = {
    source = ./helix-configuration.toml;
    target = ".config/helix/config.toml";
  };
}
