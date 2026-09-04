# Shared home-manager wiring for NixOS Hosts: the HM NixOS module import plus
# the settings every Host needs for its declared Users (global pkgs, user
# packages, backup-file handling, specialArgs). Wiring glue, not a capability
# module — imported explicitly by every Host leaf (which declares its
# Users via `home-manager.users.<name>`); deliberately not part
# of the exported `modules/nixos` collection.
{
  inputs,
  outputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

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
}
