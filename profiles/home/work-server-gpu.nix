# Work server GPU home profile: extends the shared base with GPU tooling.
{pkgs, ...}: {
  imports = [
    ./work-server.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.full
  ];
}
