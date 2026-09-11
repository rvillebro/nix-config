# Standalone User leaf for rav@work-server-cpu.
{config, ...}: {
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work-server.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "25.11";
  };

  programs.git.settings = {
    user.name = "Rasmus Villebro";
    user.email = "rav@evaxion.ai";
  };

  programs.ssh.settings."*".IdentityFile = [
    "${config.home.homeDirectory}/.ssh/rav-servers"
  ];

  targets.genericLinux.enable = true;
}
