{ pkgs,  ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = [
      pkgs.marksman
      pkgs.ruff
      pkgs.python3Packages.python-lsp-server
      pkgs.python3Packages.jedi-language-server
      pkgs.rust-analyzer
      pkgs.ty
    ];
  };
  home.file."helix-configuration.toml" = {
    source = ./helix-configuration.toml;
    target = ".config/helix/config.toml";
  };
}
