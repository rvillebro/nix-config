{ config, lib, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "rav";
  wsl.docker-desktop.enable = true;
  wsl.useWindowsDriver = true;
  environment.sessionVariables.LD_LIBRARY_PATH = ["/usr/lib/wsl/lib"];

  programs.nix-ld.enable = true;

    # enable home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "homeManagerBackupFileExtension";
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.users.rav = import ./home;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}