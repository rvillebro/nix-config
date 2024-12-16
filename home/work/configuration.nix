{
  ...
}: {
  programs = {
    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rav@evaxion-biotech.com";
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

    pyenv.enable = true;
    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    aria2.enable = true;
  };
}