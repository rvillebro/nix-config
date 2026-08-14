{
  lib,
  config,
  pkgs,
  ...
}: {
  # Extend the shared user account definition
  users.users.rav.extraGroups = ["wheel"];
}
