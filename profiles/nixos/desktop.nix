# Desktop NixOS profile: the GNOME/GDM desktop capability (xps13 only).
{
  lib,
  pkgs,
  ...
}: {
  networking.networkmanager.enable = lib.mkDefault true;

  programs.dconf.enable = true;

  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.rav.extraGroups = ["networkmanager" "wheel"];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-console
    geary
    epiphany
    yelp
    simple-scan
    gnome-music
    gnome-logs
    gnome-disk-utility
  ];
}
