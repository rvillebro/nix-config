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
    zsh.enable = true;
    direnv.enable = true;
    starship.enable = true;
    zellij.enable = true;
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    jq.enable = true;
    gh.enable = true;
    ripgrep.enable = true;
    rclone.enable = true;
    awscli.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = "rav@evaxion.ai";
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          addKeysToAgent = "yes";
        };
        "utopia-1" = {
          hostname = "utopia-1";
        "utopia-2" = {
          hostname = "utopia-2";
        };
      };
    };
  };
}
