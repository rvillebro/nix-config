{
  pkgs,
  ...
}: {
  programs = {
    tmux = {
      enable = true;
      clock24 = true;
    };
    zellij.enable = true;
  };
}
