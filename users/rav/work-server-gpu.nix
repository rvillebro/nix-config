# Standalone User leaf for rav@work-server-gpu.
{pkgs, ...}: {
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work-server.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.full
  ];
}
