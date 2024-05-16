{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  users.users.rav = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = ["wheel"];
  };
}
