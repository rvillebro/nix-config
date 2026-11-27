# Base home profile: the shared, person-level baseline for every User.
{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      zip
      unzip
      pigz
      gnutar
      bitwarden-cli
    ];

    shellAliases = {
      cat = "bat";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza -lT";
      tree = "eza -T";
    };

    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      LESSKEY = "${config.xdg.configHome}/less/lesskey";

      EDITOR = "hx";
      PAGER = "less -RF";
    };
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      # `ssh <host> <cmd>` runs a non-interactive shell, which returns from
      # ~/.bashrc at the interactive-only guard and would otherwise run with
      # a bare system PATH, missing profile tools (e.g. `hc`). bashrcExtra
      # is emitted before that guard and runs in non-interactive shells;
      # guard on interactivity so interactive shells don't double-source
      # what targets.genericLinux (initExtra) already sources for them.
      bashrcExtra = let
        hmSessionVars = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
      in ''
        if [[ $- != *i* ]]; then
          export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH"
          if [ -f "${hmSessionVars}" ]; then
            . "${hmSessionVars}"
          fi
        fi
      '';
    };
    git.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    starship.enable = true;

    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    aria2.enable = true;
    gh.enable = true;
    jq.enable = true;
    ripgrep.enable = true;

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          "line-number" = "relative";
          mouse = false;
        };
      };
      extraPackages = [
        pkgs.marksman
        pkgs.unstable.ruff
        pkgs.python3Packages.python-lsp-server
        pkgs.rust-analyzer
      ];
    };
  };

  systemd.user.startServices = "sd-switch";

  services.ssh-agent.enable = true;
}
