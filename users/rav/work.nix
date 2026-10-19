# Standalone User leaf for rav@work: the shared baseline plus work-only tooling.
{config, ...}: {
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/work.nix
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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityFile = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      };
      "utopia-1".HostName = "utopia-1";
    };
  };

  targets.genericLinux.enable = true;
}
