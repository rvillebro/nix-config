# Zed editor configuration. Import this module where Zed is wanted.
{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
  };
}