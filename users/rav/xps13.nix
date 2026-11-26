# Host-wired User leaf for xps13: base + dev + gui + umbriel personas.
{pkgs, ...}: {
  imports = [
    ../../profiles/home/base.nix
    ../../profiles/home/dev.nix
    ../../profiles/home/gui.nix
    ../../profiles/home/umbriel.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    stateVersion = "24.05";
  };

  home.packages = [pkgs.unstable.herdr pkgs.yazi pkgs.lazygit];

  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        dark = true;
        navigate = true;
        line-numbers = true;
      };
    };

    lazygit = {
      enable = true;
      settings.git.diffRenderers = [
        {command = "delta --{{colorScheme}} --paging=never";}
      ];
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    git.settings = {
      user.name = "Rasmus Villebro";
      user.email = "rasmus-villebro@hotmail.com";
    };
  };
}
