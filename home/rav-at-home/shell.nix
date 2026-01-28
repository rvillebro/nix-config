{
  config,
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
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = "rasmus-villebro@hotmail.com";
      };
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "rpi4" = {
          hostname = "rpi4";
          user = "rav";
          forwardAgent = true;
        };
      };
    };
  };
}
