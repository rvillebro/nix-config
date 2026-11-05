# Desktop NixOS profile: the graphical-desktop capability (xps13 only) — the
# Hyprland session with the system services its desktop shell depends on, the
# greetd login, and the transitional GNOME block kept until the migration
# checklist passes (ADR 0004).
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.noctalia-greeter.nixosModules.default];

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

  # The Hyprland session, and the system services its desktop shell's widgets
  # depend on: network (NetworkManager above), bluetooth, battery/power
  # profiles, and the keyring the GNOME bundle previously provided.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Hyprland's own portal covers screencast; the GTK portal is needed for
  # file-picker dialogs outside GNOME.
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  # Polkit for the session (privilege prompts outside GNOME); the agent runs
  # as a systemd user service from the home side.
  security.polkit.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Login: Noctalia Greeter on greetd (ADR 0004). The greetd module creates the
  # `greeter` user and wires the session command; gnome-keyring PAM unlock is
  # automatic for greetd in this nixpkgs. Cursor theme matches the home profile.
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "Hyprland";
      keyboard.layout = "dk";
      cursor = {
        theme = "Catppuccin-Mocha-Mauve-Cursors";
        size = 24;
        path = pkgs.catppuccin-cursors.mochaMauve;
      };
    };
  };

  # Transitional GNOME block, kept so the fallback session survives until the
  # Hyprland checklist passes (ADR 0004). Delete wholesale in the removal commit.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
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
