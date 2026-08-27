# Work home persona: the work-only toolset (rav@work standalone only).
#
# Composed on top of the base persona (which supplies the shared shell,
# editors, git identity, gh/jq/ripgrep). This persona only adds work-specific
# facts, so shared/base tools are not duplicated here.
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    glab # gitlab cli
  ];

  programs = {
    rclone.enable = true;
    awscli.enable = true;

    # Work git identity override — plain value takes precedence over the
    # `mkDefault` supplied by the base persona.
    git.settings.user.email = "rav@evaxion.ai";

    ssh = {
      enable = true;
      settings = {
        "*" = {
          IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
        };
        "utopia-1" = {
          HostName = "utopia-1";
        };
        "utopia-2" = {
          HostName = "utopia-2";
        };
      };
    };
  };

  nix.registry.evaxpkgs = {
    from = {
      id = "evaxpkgs";
      type = "indirect";
    };
    to = {
      type = "git";
      url = "ssh://git@git.evax.ai/tools/evaxpkgs.git";
    };
  };
}
