# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, config, ... }: 
{
  # You can import other home-manager modules here
  imports = [
    ./editors
    ./shell.nix
    ./browser.nix
  ];

  xdg.enable = true;

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      # image editor
      gimp
      # password manager
      bitwarden-desktop
      bitwarden-cli
      # archives
      zip
      unzip
      pigz
      ripgrep
      gh
      # cursor
      unstable.code-cursor-fhs
    ];
    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "hx";
      BROWSER = "firefox";
      TERMINAL = "ghostty";
      PAGER = "less -RF";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement of htop/nmon
    eza.enable = true; # modern replacement for ‘ls’
    aria2.enable = true; # download tool

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
    
    ssh = {
      enable = true;
      enableDefaultConfig = false;
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

  # nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # services
  services.ssh-agent.enable = true;
}
