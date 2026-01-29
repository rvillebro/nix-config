{ 
  pkgs
}:
{
  imports = [
    ./editor
    ./shell.nix
    ./nix.nix
    ./configuration.nix
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
      rclone
      jq  # json processor
      gh  # github cli
      glab  # gitlab cli
      ripgrep  # grep alternative
    ];
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
