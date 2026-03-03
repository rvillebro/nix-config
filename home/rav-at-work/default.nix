{ 
  pkgs,
  ...
}:
{
  imports = [
    ./editor
    ./shell.nix
    ./nix.nix
  ];

  home = {
    username = "rav";
    homeDirectory = "/home/rav";
    packages = with pkgs; [
      # archives
      zip
      unzip
      pigz
      gnutar
      glab  # gitlab cli
    ];
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
