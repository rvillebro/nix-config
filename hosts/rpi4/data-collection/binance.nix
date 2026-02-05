{ pkgs, ... }:
let
  streamConfigFile = ./stream_config.json;
  dataGroup = "wsdata";
in
{
  # Create stable group for data readers
  users.groups.${dataGroup} = { };

  systemd.services.binance-stream-collector = {
    description = "Binance WebSocket Stream Collector";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.binance-collector}/bin/bc collect-stream ${streamConfigFile} --out-dir $STATE_DIRECTORY";
      Restart = "always";
      WatchdogSec = "5min";

      # Run as ephemeral dynamic user
      DynamicUser = true;

      # State directory for collected data
      StateDirectory = "binance-collector";
      # 02750: setgid bit ensures new files inherit group, owner rwx, group r-x
      StateDirectoryMode = "02750";

      # Ensure files are group-readable (files: 640, dirs: 750)
      UMask = "0027";

      # Add reader group as supplementary group
      SupplementaryGroups = [ dataGroup ];

      # Set directory group ownership to wsdata on each start
      # "+" prefix runs as root (needed for chgrp with DynamicUser)
      ExecStartPre = [
        "+${pkgs.coreutils}/bin/chgrp -R ${dataGroup} ${stateDir}"
        "+${pkgs.coreutils}/bin/chmod 02750 ${stateDir}"
      ];

      # Hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };
}
