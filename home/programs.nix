{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    bash.enable = true;
    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    aria2.enable = true;

    firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];
        settings = {
          "identity.fxaccounts.enabled" = false;
        };
        search = {
          default = "Google";
          order = ["Google" "GitHub" "Nix Packages" "NixOS Options" "Home Manager"];
          engines = {
            "Nix Packages" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }
              ];
            };
            "NixOS Options" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }
              ];
            };
            "Home Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }
              ];
            };
            "GitHub" = {
              iconUpdateURL = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@gh"];
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "DuckDuckGo".metaData.hidden = true; # builtin engines only support specifying one additional alias
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
      };
    };

    pyenv = {
      enable = true;
      enableBashIntegration = true;
    };

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
    
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-vscode-remote.remote-ssh
        rust-lang.rust-analyzer
        golang.go
        jnoortheen.nix-ide
        mkhl.direnv
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[›](bold green)";
          error_symbol = "[›](bold red)";
        };
      };
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    git = {
      enable = true;
      userName = "Rasmus Villebro";
      userEmail = "rasmus-villebro@hotmail.com";
    };
  };
}