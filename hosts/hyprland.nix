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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # nvidiaPatches = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      # if your cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
      # needed for kitty
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
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
      wofi
      dolphin

      kitty
      gtk3
    ];
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
