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
  # Safe on hosts that never ran a previous cleanup (e.g. rpi4/nixos-wsl): the glob
  # only matches files HM created under backupFileExtension, so it never removes
  # unrelated user files. No host overrides backupFileExtension differently.
  system.userActivationScripts = {
    removeHomeManagerBackupFiles = {
      text = ''
        find ~ -type f -name "*.homeManagerBackupFileExtension" -delete
      '';
    };
  };
}
