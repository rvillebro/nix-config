# Work home profile: the work-only toolset (rav@t14s standalone only).
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
        "toml"
      ];
      extraPackages = with pkgs; [
        nixd
        nil
      ];
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
