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
    nvidiaPatches = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      # if your cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
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
      hyprpaper
      # launcher
      tofi
    ];
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  }

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
