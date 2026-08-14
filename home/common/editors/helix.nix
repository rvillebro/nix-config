# Shared Helix editor configuration, common to all home configs.
#
# Single unified LSP/formatting toolchain — no per-host extraPackages.
# The old xps13-only `jedi-language-server` and `ty` were dropped deliberately
# (no languages config references them); `ruff` is pinned to unstable,
# matching rpi4/wsl and the rest of the config.
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
