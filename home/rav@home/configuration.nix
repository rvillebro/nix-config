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


  };
}
