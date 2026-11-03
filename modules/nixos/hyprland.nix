# Hyprland desktop compositor capability: the Wayland session, the portals apps
# rely on, and the system services the desktop shell's widgets depend on
# (battery, bluetooth, power profiles) plus the keyring the GNOME bundle
# previously provided (ADR 0004). Off by default; the desktop profile enables it.
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myConfig.hyprland = {
    enable = lib.mkEnableOption "the Hyprland desktop session and its system services";
  };

  config = lib.mkIf config.myConfig.hyprland.enable {
    programs.hyprland = {
      enable = lib.mkDefault true;
      xwayland.enable = lib.mkDefault true;
    };

    # Hyprland's own portal covers screencast; the GTK portal is needed for
    # file-picker dialogs outside GNOME.
    xdg.portal.extraPortals = lib.mkDefault [pkgs.xdg-desktop-portal-gtk];

    # Polkit for the session (privilege prompts outside GNOME); the agent runs
    # as a systemd user service from the home module.
    security.polkit.enable = lib.mkDefault true;

    # Desktop shell widget backends: network (NetworkManager, from the desktop
    # profile), bluetooth, battery/power profiles, and the keyring the GNOME
    # bundle previously provided.
    hardware.bluetooth.enable = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
  };
}
