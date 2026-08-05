# Shared shell configuration, common to all home configs.
{...}: {
  home.shell.enableShellIntegration = true;

  home.shellAliases = {
    zj = "zellij";
    cat = "bat";
    ls = "eza";
    ll = "eza -l";
    la = "eza -la";
    lt = "eza -lT";
    tree = "eza -T";
  };

  programs = {
    bash.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;
    zellij.enable = true;
  };
}
