{
  ...
}: {
  programs = {
    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rav@evaxion.ai";
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
