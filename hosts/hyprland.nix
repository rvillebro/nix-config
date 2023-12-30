{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      # topbar
      waybar
      # notifications
      dunst
      libnotify
      # wallpaper
      hyprpapr
      # launcher
      tofi
    ];
  };

  hardware.opengl.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}