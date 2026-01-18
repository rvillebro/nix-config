{
  ...
}: {
  fonts.fontconfig.enable = true;

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      gnutar
    ];
  };
  
  programs = {
    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rasmus-villebro@hotmail.com";
    };

    # ssh = {
    #   enable = False;
    #   extraConfig = ''
    #     IdentityFile ~/.ssh/rav-servers
    #   '';
    # };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    aria2.enable = true;
  };
}
