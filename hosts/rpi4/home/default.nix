# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, ... }: 
{
  imports = [
    ../../../home/common
    ./editor
  ];

  home = {
    packages = with pkgs; [
      bitwarden-cli
    ];
    sessionVariables = {
      TERM = "xterm-256color";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Rasmus Villebro";
      user.email = "rasmus-villebro@hotmail.com";
    };
  };
}