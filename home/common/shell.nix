# Shared shell configuration, common to all home configs.
{...}: {
  home.shell.enableShellIntegration = true;

  # The full alias set is intentionally applied to every profile (consistency
  # goal): xps13/rpi4/wsl previously had only `zj`, they now share the bat/eza
  # aliases used by the standalone configs. Safe to apply globally because bat
  # and eza are installed by home/common on all hosts, and shell aliases only
  # affect interactive shells — scripts calling ls/cat/tree are unaffected.
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
    # bash is the single interactive shell for every profile. rav@work used to
    # enable zsh; it was dropped so no profile has a second shell (and none
    # generates an unused .bashrc/.zshrc pair).
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
