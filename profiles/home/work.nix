# Work home profile: the work-only toolset (rav@work standalone only).
{pkgs, ...}: {
  home.packages = with pkgs; [
    glab
  ];

  programs = {
    rclone.enable = true;
    awscli.enable = true;

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
