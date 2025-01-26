# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, config, ... }: 
{
  # You can import other home-manager modules here
  imports = [
    ./editor
    ./shell.nix
  ];

  xdg.enable = true;

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      bitwarden-cli
      # archives
      zip
      unzip
      pigz
    ];
    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "hx";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  # enable home-manager
  programs = {
    home-manager.enable = true;
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement of htop/nmon
    eza.enable = true; # modern replacement for ‘ls’
    aria2.enable = true; # download tool
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
