# Desktop NixOS profile: the graphical-desktop capability (xps13 only) — the
# Umbriel session with the system services its desktop shell depends on, and
# the greetd login (ADR 0005).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  networking.networkmanager.enable = true;

  programs = {
    # Kept for Electron/GTK apps even after GNOME removal (ADR 0004). Umbriel's
    # module also enables it, but HM's dconf.settings needs the system service
    # and this is the desktop capability, so it is declared here too.
    dconf.enable = true;

    # Registers the Umbriel session for the greeter (ADR 0005). The module
    # pulls in Umbriel's own portal (screencast) plus the GTK portal, sets
    # config.umbriel itself, and enables polkit (via wayland-session.nix);
    # the user config lives unmanaged in ~/.config/umbriel/config.toml
    # (live-reloadable, no rebuild needed).
    umbriel.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # polkit is enabled by Umbriel's module (wayland-session.nix) and the
  # noctalia-greeter module, so it is not repeated here.
  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;

    # Not a GNOME leftover: greetd's PAM config unlocks the keyring at login
    # (enableGnomeKeyring defaults to this option in the greetd module), and
    # it backs Electron/Bitwarden safeStorage. Deliberate, keep.
    gnome.gnome-keyring.enable = true;

    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Umbriel";
        keyboard.layout = "dk";
        cursor = {
          theme = "catppuccin-mocha-mauve-cursors";
          size = 24;
          path = pkgs.catppuccin-cursors.mochaMauve;
        };
      };
    };
  };

  # Umbriel's module wires the portals itself: xdg-desktop-portal-umbriel for
  # screencast, xdg-desktop-portal-gtk (via wayland-session.nix) for
  # file-picker dialogs and the Settings (dark-mode) interface, and
  # config.umbriel = ["umbriel" "gtk"].
}
