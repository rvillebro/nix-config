# Common home-manager wiring shared by all NixOS hosts.
{
  inputs,
  outputs,
  ...
}: {
  # enable home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "homeManagerBackupFileExtension";
  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  # Clean up leftover home-manager backup files (matching backupFileExtension above).
  system.userActivationScripts = {
    removeHomeManagerBackupFiles = {
      text = ''
        find ~ -type f -name "*.homeManagerBackupFileExtension" -delete
      '';
    };
  };
}
