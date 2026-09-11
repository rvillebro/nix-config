# Host-wired User leaf for rpi4: base + dev personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    # per-machine fact kept from the old hosts/rpi4/home leaf
    sessionVariables.TERM = "xterm-256color";
    stateVersion = "24.05";
  };

  programs.git.settings = {
    user.name = "Rasmus Villebro";
    user.email = "rasmus-villebro@hotmail.com";
  };
}
