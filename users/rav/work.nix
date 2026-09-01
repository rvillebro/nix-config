# Standalone User leaf for rav@work: the shared baseline plus work-only tooling.
{
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work.nix
  ];

  targets.genericLinux.enable = true;
}
