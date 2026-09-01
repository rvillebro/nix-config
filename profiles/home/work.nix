# Work home profile: the work-only toolset (rav@work standalone only).
{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    glab
  ];

  programs = {
    rclone.enable = true;
    awscli.enable = true;
    git.settings.user.email = "rav@evaxion.ai";

    zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];
      extraPackages = with pkgs; [
        nixd
        nil
      ];
    };

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
