# Build a NixOS Host configuration from its thin leaf (hosts/<name>).
#
# `hostName` picks the host-integration module for that box among the NixOS
# hardware quirks (dell-xps / raspberry-pi-4) or the NixOS-WSL glue (wsl).
# `module` is the host leaf directory; `users` optionally wires home-manager
# Users as `home-manager.users.<name>`, each pointing at the User's leaf
# (users/<person>/<host>.nix).
{
  inputs,
  outputs,
  nixpkgs,
}: {
  hostName,
  system,
  module,
  users ? {},
}: let
  # Chosen host input: hardware quirks module or WSL glue for this box.
  hostInput =
    {
      xps13 = inputs.hardware.nixosModules.dell-xps-13-9370;
      rpi4 = inputs.hardware.nixosModules.raspberry-pi-4;
      nixos-wsl = inputs.nixos-wsl.nixosModules.wsl;
    }
    .${
      hostName
    };

  # Turn the users map ({ rav = ./users/rav/xps13.nix }) into a module wiring
  # `home-manager.users.rav = import ./users/rav/xps13.nix`.
  userWiring = {
    home-manager.users = nixpkgs.lib.mapAttrs (_: path: import path) users;
  };

  # Shared home-manager wiring for NixOS Hosts (same for every host).
  homeManagerWiring = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "homeManagerBackupFileExtension";
      extraSpecialArgs = {inherit inputs outputs;};
    };

    # Clean up leftover home-manager backup files (matching backupFileExtension
    # above). The glob only matches files HM created under that extension, so it
    # never removes unrelated user files.
    system.userActivationScripts.removeHomeManagerBackupFiles.text = ''
      find ~ -type f -name "*.homeManagerBackupFileExtension" -delete
    '';
  };
in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {inherit inputs outputs;};
    modules = [
      inputs.home-manager.nixosModules.home-manager
      hostInput
      homeManagerWiring
      module
      userWiring
    ];
  }
