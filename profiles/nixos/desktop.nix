# Desktop NixOS role profile: GNOME/GDM-specific capability (xps13 only).
# The X11 wing, GNOME desktop + GDM, keymap/fonts, printing, and the
# networking/wifi posture for the desktop box. Drawn from the old
# hosts/xps13/{default,configuration}.nix trees. Hyprland and greetd were
# dropped from the profile. Declares no options; only the networking posture
# (the one thing a desktop host may vary) is set with `lib.mkDefault`.
{
  lib,
  pkgs,
  ...
}: {
  # Networking / wifi for the desktop laptop (a host may choose ethernet-only).
  networking.networkmanager.enable = lib.mkDefault true;

  programs.dconf.enable = true; # dconf settings for GNOME and other applications

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Extend the shared user account definition
  users.users.rav.extraGroups = ["networkmanager" "wheel"];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-console # terminal
    geary
    epiphany # web browser
    yelp # help viewer
    simple-scan # document scanner
    gnome-music # music app
    gnome-logs # logs viewer
    gnome-disk-utility # disks utility
  ];
}
