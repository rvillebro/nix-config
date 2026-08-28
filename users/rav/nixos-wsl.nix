# Host-wired User leaf for nixos-wsl: base + dev personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
  ];

  home.stateVersion = "24.11";
}
