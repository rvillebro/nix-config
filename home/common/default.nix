# Shared home-manager configuration, common to all home configs.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./shell.nix
    ./editors/helix.nix
  ];

  xdg.enable = true;

  home = {
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      gnutar
      # useful tools
      ripgrep
    ];
    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "hx";
      PAGER = "less -RF";
    };
  };

  programs = {
    home-manager.enable = true;
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement of htop/nmon
    eza.enable = true; # modern replacement for ‘ls’
    aria2.enable = true; # download tool
  };

  # nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # services
  services.ssh-agent.enable = true;
}
