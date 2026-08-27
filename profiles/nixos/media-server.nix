# Media-server NixOS role profile: dormant, zero-consumer profile preserving the
# shape-intent for a future headless box. All services are commented out; only
# the shared `multimedia` group/user scaffold is active. Referenced by no host.
{pkgs, ...}: {
  # A shared group/user for media downloads to land in (the one active fact).
  users.groups.multimedia = {};
  users.users.multimedia = {
    isSystemUser = true;
    group = "multimedia";
    home = "/var/lib/multimedia";
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # services.transmission = {
  #   enable = true;
  #   home = "/var/lib/transmission";
  #   openFirewall = true;
  #   user = "multimedia";
  #   group = "multimedia";
  # };

  # services.radarr = {
  #   enable = true;
  #   dataDir = "/var/lib/radarr";
  #   openFirewall = true;
  #   user = "multimedia";
  #   group = "multimedia";
  # };

  # services.sonarr = {
  #   enable = true;
  #   dataDir = "/var/lib/sonarr";
  #   openFirewall = true;
  #   user = "multimedia";
  #   group = "multimedia";
  # };

  # services.plex = {
  #   enable = true;
  #   package = pkgs.unstable.plex;
  #   dataDir = "/var/lib/plex";
  #   openFirewall = true;
  #   user = "multimedia";
  #   group = "multimedia";
  # };
}
