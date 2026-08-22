# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{pkgs, ...}: {
  imports = [
    ../../../home/common
    ../../../home/common/git.nix
    ./pi-coding-agent.nix
  ];

  home = {
    packages = with pkgs; [
      bitwarden-cli
      gh
    ];
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };
}
