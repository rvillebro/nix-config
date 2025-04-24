{ lib, config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      autoprune = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    # oci-containers = {
    #   backend = "podman";
    #   containers.homeassistant = {
    #     volumes = [ "home-assistant:/config" ];
    #     environment.TZ = "Europe/Berlin";
    #     # Note: The image will not be updated on rebuilds, unless the version label changes
    #     image = "ghcr.io/home-assistant/home-assistant:stable";
    #     extraOptions = [ 
    #       # Use the host network namespace for all sockets
    #       "--network=host"
    #       # Pass devices into the container, so Home Assistant can discover and make use of them
    #       "--device=/dev/ttyACM0:/dev/ttyACM0"
    #     ];
    #   };
    # };
  };
}