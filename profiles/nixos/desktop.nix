# Desktop NixOS profile: the graphical-desktop capability (xps13 only) — the
# Hyprland session with the system services its desktop shell depends on, and
# the greetd login (ADR 0004).
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.noctalia-greeter.nixosModules.default];

  networking.networkmanager.enable = true;

  programs = {
    # Kept for Electron/GTK apps even after GNOME removal (ADR 0004).
    dconf.enable = true;

    hyprland.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware.bluetooth.enable = true;

  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;

    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Hyprland";
        keyboard.layout = "dk";
        cursor = {
          theme = "catppuccin-mocha-mauve-cursors";
          size = 24;
          path = pkgs.catppuccin-cursors.mochaMauve;
        };
      };
    };
  };

  # Hyprland's own portal covers screencast; the GTK portal is needed for
  # file-picker dialogs in non-GNOME apps.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.hyprland.default = ["hyprland" "gtk"];
  };
}
