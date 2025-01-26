{ pkgs,  ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      ms-vscode-remote.remote-ssh
      rust-lang.rust-analyzer
      golang.go
      jnoortheen.nix-ide
      mkhl.direnv
    ];
  };
}