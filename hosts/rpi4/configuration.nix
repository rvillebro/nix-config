{
  lib,
  config,
  pkgs,
  ...
}: {
  # Extend the shared user account definition
  users.users.rav.extraGroups = ["wheel"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unstable.devenv
  ];
}
