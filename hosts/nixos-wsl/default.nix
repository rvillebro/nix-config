{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "rav";
  wsl.docker-desktop.enable = true;
  wsl.useWindowsDriver = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  programs.nix-ld.enable = true;
  environment.sessionVariables.LD_LIBRARY_PATH = ["/usr/lib/wsl/lib"];
  environment.systemPackages = with pkgs; [
    helix
    wget
    curl
    git
    sysstat
    neofetch
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}