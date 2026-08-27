# Base home persona: the shared, person-level baseline for every User.
#
# Folds the old `home/user`, `home/common`, and `home/common/shell.nix`,
# `home/common/git.nix`, `home/common/editors/helix.nix` content into a single
# persona. Declares no options; every value it sets uses `mkDefault` so a
# rawer leaf can override.
#
# Home-lean declaration policy: `gh`, `jq`, and `ripgrep` are declared exactly
# once, here, via their `programs.*` switches (see spec). Cachix is a plain
# `nix.settings` entry (nix-community cache incl. key), not a module.
{
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    # Deployment facts, overridable by hosts/users (e.g. stateVersion stays
    # aligned with the host's system stateVersion).
    username = lib.mkDefault "rav";
    homeDirectory = lib.mkDefault "/home/rav";
    stateVersion = lib.mkDefault "25.11";

    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      gnutar
      # password manager
      bitwarden-cli
    ];

    # The full alias set is applied to every profile (consistency goal).
    # bat/eza are installed by this persona on every machine, and shell
    # aliases only affect interactive shells — scripts calling ls/cat/tree
    # are unaffected.
    shellAliases = {
      zj = "zellij";
      cat = "bat";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza -lT";
      tree = "eza -T";
    };

    sessionVariables = {
      # clean up ~
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      # set default applications
      EDITOR = "hx";
      PAGER = "less -RF";
    };
  };

  # Fontconfig lets standalone home configs discover fonts installed via
  # home.packages / nix-env. Redundant (but harmless) on NixOS hosts, where
  # it's configured at the system level.
  fonts.fontconfig.enable = true;

  # Apply the XDG base-directory layout to standalone setups (rav@home,
  # rav@work), re-homing HM-managed dotfiles under ~/.config. Intended.
  xdg.enable = true;

  # Shared nix-community cachix substituter + public key. Plain `nix.settings`
  # entry (not a module) so every machine and standalone user shares the same
  # substituter posture.
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  programs = {
    home-manager.enable = true;

    # shell
    bash.enable = true; # the single interactive shell for every profile
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;
    zellij.enable = true;

    # tools
    bat.enable = true; # modern replacement for cat
    btop.enable = true; # modern replacement for htop/nmon
    eza.enable = true; # modern replacement for 'ls'
    aria2.enable = true; # download tool
    gh.enable = true; # GitHub cli
    jq.enable = true; # JSON processor
    ripgrep.enable = true; # fast search

    # editor
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          "line-number" = "relative";
          mouse = false;
        };
      };
      # Single unified LSP/formatting toolchain — no per-host extraPackages.
      extraPackages = [
        pkgs.marksman
        pkgs.unstable.ruff
        pkgs.python3Packages.python-lsp-server
        pkgs.rust-analyzer
      ];
    };

    # Canonical git identity, shared by every User. Profiles may override the
    # identity (e.g. rav@work) via a plain value, which takes precedence over
    # this `mkDefault`.
    git = {
      enable = true;
      settings = {
        user.name = "Rasmus Villebro";
        user.email = lib.mkDefault "rasmus-villebro@hotmail.com";
      };
    };

    # Declare the client config explicitly so it keeps working when
    # home-manager removes its ssh defaults.
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
        };
        "rpi4" = {
          HostName = "rpi4";
          User = "rav";
          ForwardAgent = true;
        };
      };
    };
  };

  # nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # services
  services.ssh-agent.enable = true;
}
