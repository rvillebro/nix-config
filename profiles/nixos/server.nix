# Server NixOS role profile: openssh + podman/home-assistant posture (rpi4 only).
# Drawn from the old hosts/rpi4/{default,virtualisation}.nix trees. Defaults are
# set with `lib.mkDefault`; `devenv` is dropped (no longer a special-case extra).
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Remote access + the podman/home-assistant stack.
  services.openssh.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    oci-containers = {
      backend = "podman";
      containers.home-assistant = {
        volumes = [
          "home-assistant:/config"
          "/etc/localtime:/etc/localtime:ro"
          "/run/dbus:/run/dbus:ro"
        ];
        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [
          # Use the host network namespace for all sockets
          "--network=host"
          # Pass devices into the container, so Home Assistant can discover and make use of them
          "--device=/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_ce0109eb7c4bef11be56c2a079f42d1b-if00-port0:/dev/ttyACM0"
        ];
        serviceName = "home-assistant";
        pull = "newer";
        autoStart = true;
      };
    };
  };

  # Firewall posture: open everything for the broadly-host-networked containers.
  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 8123 ];  # home assistant port

  systemd.timers.home-assistant-timer = {
    description = "Weekly home-assistant restart timer";
    timerConfig = {
      OnCalendar = "Sun 03:00:00";
      Persistent = false;
      Unit = "home-assistant-restart.service";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.home-assistant-restart = {
    description = "Home-assistant restart service";
    path = [pkgs.systemd];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "systemctl try-restart home-assistant.service";
    };
  };
}
