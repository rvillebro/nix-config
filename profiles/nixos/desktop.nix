# Desktop NixOS profile: the graphical-desktop capability (xps13 only). Imports
# the Hyprland compositor module (ADR 0004); the GNOME block at the bottom is
# transitional and is deleted once the Hyprland migration checklist passes.
{
  lib,
  pkgs,
  ...
}: {
  imports = [../../modules/nixos/hyprland.nix];

  myConfig.hyprland.enable = true;

  networking.networkmanager.enable = lib.mkDefault true;

  # Kept for Electron/GTK apps even after GNOME removal (ADR 0004).
  programs.dconf.enable = true;

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

  # Transitional GNOME block, kept so the fallback session survives until the
  # Hyprland checklist passes (ADR 0004). Delete wholesale in the removal commit.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };
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
