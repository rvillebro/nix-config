# Host-wired User leaf for nixos-wsl: base + dev personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "24.11";
  };

  programs.git.settings = {
    user.name = "Rasmus Villebro";
    user.email = "rasmus-villebro@hotmail.com";
  };
}
