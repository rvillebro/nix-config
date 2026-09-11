# Standalone User leaf for rav@home: the minimal everyday setup.
{
  imports = [
    ./nix.nix
    ../../profiles/home/base.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "25.11";
  };

  programs.git.settings = {
    user.name = "Rasmus Villebro";
    user.email = "rasmus-villebro@hotmail.com";
  };
}
