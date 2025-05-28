{ lib, config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    oci-containers = {
      backend = "podman";
      containers.homeassistant = {
        volumes = [
          "home-assistant:/config"
          "/etc/localtime:/etc/localtime:ro"
          "/run/dbus:/run/dbus:ro"
        ];
        # environment.TZ = "Europe/Copenhagen";
        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [ 
          # Use the host network namespace for all sockets
          "--network=host"
          # Pass devices into the container, so Home Assistant can discover and make use of them
          "--device=/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_ce0109eb7c4bef11be56c2a079f42d1b-if00-port0:/dev/ttyACM0"
        ];
      };
    };
  };
  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 8123 ];  # home assistant port
}