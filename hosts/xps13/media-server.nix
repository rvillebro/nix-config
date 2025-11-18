{
  pkgs,
  ...
}: {
  users.groups.multimedia = { };
  users.users.multimedia = {
    isSystemUser = true;
    group = "multimedia";
    home = "/var/lib/multimedia";
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  services.transmission = {
    enable = true;
    home = "/var/lib/transmission";
    openFirewall = true;
    user = "multimedia";
    group = "multimedia";
  };
  
  services.radarr = {
    enable = true;
    dataDir = "/var/lib/radarr";
    openFirewall = true;
    user = "multimedia";
    group = "multimedia";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/var/lib/sonarr";
    openFirewall = true;
    user = "multimedia";
    group = "multimedia";
  };

  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "multimedia";
    group = "multimedia";
  };
}
