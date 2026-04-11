{ pkgs, ... }:
let
  streamConfigFile = ./stream_config.json;
  restConfigFile = ./rest_config.json;
  serviceUser = "binance-collector";
  serviceGroup = "data";
in
{
  # Create system user for binance collector
  users.users.${serviceUser} = {
    isSystemUser = true;
    group = serviceGroup;
  };

  # Create stable group for data readers
  users.groups.${serviceGroup} = { };

  systemd.services.binance-collector-stream = {
    description = "Binance WebSocket Stream Collector";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.binance-collector}/bin/binance-collector stream ${streamConfigFile} --out-dir $STATE_DIRECTORY";
      Restart = "always";
      RestartSec = "10sec";
      WatchdogSec = "10min";

      User = serviceUser;
      Group = serviceGroup;
      # State directory for collected data
      StateDirectory = "binance-collector-stream";
      # 02750: setgid bit ensures new files inherit group, owner rwx, group r-x
      StateDirectoryMode = "02750";

      # Ensure files are group-readable (files: 640, dirs: 750)
      UMask = "0027";

      # Add reader group as supplementary group
      SupplementaryGroups = [ serviceGroup ];

      # Set directory group ownership to wsdata on each start
      # "+" prefix runs as root (needed for chgrp with DynamicUser)
      # ExecStartPre = [
      #   "+${pkgs.coreutils}/bin/chgrp -R ${dataGroup} $STATE_DIRECTORY"
      #   "+${pkgs.coreutils}/bin/chmod 02750 $STATE_DIRECTORY"
      # ];

      # # Hardening
      # NoNewPrivileges = true;
      # ProtectSystem = "strict";
      # ProtectHome = true;
      # PrivateTmp = true;
    };
  };

  systemd.services.binance-collector-rest = {
    description = "Binance REST API Collector";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.binance-collector}/bin/binance-collector rest ${restConfigFile} --out-dir $STATE_DIRECTORY";
      Restart = "always";
      RestartSec = "10sec";
      WatchdogSec = "10min";

      User = serviceUser;
      Group = serviceGroup;

      # State directory for collected data
      StateDirectory = "binance-collector-rest";
      # 02750: setgid bit ensures new files inherit group, owner rwx, group r-x
      StateDirectoryMode = "02750";

      # Ensure files are group-readable (files: 640, dirs: 750)
      UMask = "0027";

      # Add reader group as supplementary group
      SupplementaryGroups = [ serviceGroup ];

      # # Set directory group ownership to wsdata on each start
      # # "+" prefix runs as root (needed for chgrp with DynamicUser)
      # ExecStartPre = [
      #   "+${pkgs.coreutils}/bin/chgrp -R ${dataGroup} $STATE_DIRECTORY"
      #   "+${pkgs.coreutils}/bin/chmod 02750 $STATE_DIRECTORY"
      # ];

      # # Hardening
      # NoNewPrivileges = true;
      # ProtectSystem = "strict";
      # ProtectHome = true;
      # PrivateTmp = true;
    };
  };
}
