{
  config,
  pkgs,
  ...
}: {
  home.shell.enableShellIntegration = true;

  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    LESSKEY = "${config.xdg.configHome}/less/lesskey";
  };

  home.shellAliases = {
    zj = "zellij";
    cat = "bat";
    ls = "eza";
    ll = "eza -l";
    la = "eza -la";
    lt = "eza -lT";
    tree = "eza -T";
  };

  services.ssh-agent.enable = true;

  programs = {
    bash.enable = true;
    direnv.enable = true;
    starship.enable = true;
    zellij.enable = true;
    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rasmus-villebro@hotmail.com";
    };
    bat.enable = true; # a modern replacement for cat
    btop.enable = true; # a modern replacement of htop/nmon
    eza.enable = true; # a modern replacement for 'ls'
  };
}
