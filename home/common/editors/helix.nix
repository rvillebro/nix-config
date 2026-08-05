# Shared Helix editor configuration, common to all home configs.
{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        "line-number" = "relative";
        mouse = false;
      };
    };
    extraPackages = [
      pkgs.marksman
      pkgs.unstable.ruff
      pkgs.python3Packages.python-lsp-server
      pkgs.rust-analyzer
    ];
  };
}
