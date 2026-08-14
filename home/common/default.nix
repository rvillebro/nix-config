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

  # Fontconfig lets standalone home configs discover fonts installed via
  # home.packages / nix-env. Redundant (but harmless) on NixOS hosts, where
  # it's configured at the system level.
  fonts.fontconfig.enable = true;

  # Apply the XDG base-directory layout to standalone setups (rav@home,
  # rav@work), re-homing HM-managed dotfiles under ~/.config. Intended.
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
