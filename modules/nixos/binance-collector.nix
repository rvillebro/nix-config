{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.rav.nixos.binance-collector;

  # Single unit builder generating both collector services from
  # (subcommand, config file, state-directory name). Preserves the
  # original runtime behaviour: Type=notify, watchdog, restart with
  # backoff, User/Group, a per-unit StateDirectory with mode 02750
  # (setgid), a restrictive UMask, and the module's group as a
  # supplementary group.
  mkCollectorService = name: configFile: stateDirectory: {
    description = "Binance ${name} collector";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig =
      {
        Type = "notify";
        ExecStart = "${pkgs.binance-collector}/bin/binance-collector ${name} ${configFile} --out-dir $STATE_DIRECTORY";
        Restart = "always";
        RestartSec = "10sec";
        WatchdogSec = "10min";

        User = cfg.user;
        Group = cfg.group;

        # State directory for collected data
        StateDirectory = stateDirectory;
        # 02750: setgid bit ensures new files inherit group, owner rwx, group r-x
        StateDirectoryMode = "02750";

        # Ensure files are group-readable (files: 640, dirs: 750)
        UMask = "0027";

        # Add the module's group as a supplementary group
        SupplementaryGroups = [cfg.group];
      }
      # Hardening sits behind the single hardening.enable boolean.
      // lib.optionalAttrs cfg.hardening.enable {
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
  };
in {
  options.rav.nixos.binance-collector = {
    stream = {
      enable = lib.mkEnableOption "the Binance WebSocket stream collector";

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to the stream collector's config JSON. Required when
          `stream.enable` is true; evaluation otherwise fails with a clear
          message.
        '';
      };
    };

    rest = {
      enable = lib.mkEnableOption "the Binance REST API collector";

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to the REST collector's config JSON. Required when
          `rest.enable` is true; evaluation otherwise fails with a clear
          message.
        '';
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "binance-collector";
      description = "System user running the collector services.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "data";
      description = ''
        Group that owns collected data. Also the service user's primary
        group; declared `readers` are members of this group, so read access
        can't drift apart from group creation.
      '';
    };

    readers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users granted read access to collected data via membership of `group`.";
    };

    hardening = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to apply systemd hardening to the collector services.";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !cfg.stream.enable || cfg.stream.configFile != null;
        message = ''
          rav.nixos.binance-collector.stream.enable requires
          rav.nixos.binance-collector.stream.configFile to be set.
        '';
      }
      {
        assertion = !cfg.rest.enable || cfg.rest.configFile != null;
        message = ''
          rav.nixos.binance-collector.rest.enable requires
          rav.nixos.binance-collector.rest.configFile to be set.
        '';
      }
    ];

    # The service user is a system user whose primary group is the module's
    # group; reader users are members of the group via its member list.
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = {
      members = cfg.readers;
    };

    systemd.services = lib.mkMerge [
      (lib.mkIf cfg.stream.enable {
        binance-collector-stream = mkCollectorService "stream" cfg.stream.configFile "binance-collector-stream";
      })
      (lib.mkIf cfg.rest.enable {
        binance-collector-rest = mkCollectorService "rest" cfg.rest.configFile "binance-collector-rest";
      })
    ];
  };
}
