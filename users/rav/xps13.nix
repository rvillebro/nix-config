# Host-wired User leaf for xps13: base + dev + gui personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/gui.nix
  ];

  home.stateVersion = "24.05";
}
