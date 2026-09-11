# Host-wired User leaf for xps13: base + dev + gui personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/gui.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "24.05";
  };

  programs.git.settings = {
    user.name = "Rasmus Villebro";
    user.email = "rasmus-villebro@hotmail.com";
  };
}
