# Shared work server home profile: the work-only toolset for all work servers.
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    glab
  ];

  programs = {
    rclone.enable = true;
    awscli.enable = true;
    git.settings.user.email = "rav@evaxion.ai";

    ssh = {
      enable = true;
      settings = {
        "*" = {
          IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
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
