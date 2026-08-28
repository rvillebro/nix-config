# Host-wired User leaf for rpi4: base + dev personas.
{
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
  ];

  home = {
    # per-machine fact kept from the old hosts/rpi4/home leaf
    sessionVariables.TERM = "xterm-256color";
    stateVersion = "24.05";
  };
}
