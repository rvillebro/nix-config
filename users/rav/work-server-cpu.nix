# Standalone User leaf for rav@work-server-cpu.
{
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work-server.nix
  ];
}
