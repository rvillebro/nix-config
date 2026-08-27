# GUI home persona: the desktop-only graphical toolset (xps13 only).
#
# Machine-independent, as derived from the old `hosts/xps13/home` tree. No
# value here is set with `mkDefault` — this persona is a consumer leaf that a
# user pulls in rather than a default that gets overridden.
{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      # image editor
      gimp
      # password manager (desktop app)
      bitwarden-desktop
    ];
    sessionVariables = {
      # set default applications
      BROWSER = "firefox";
      TERMINAL = "ghostty";
    };
  };

  programs = {
    # --- editors (in addition to the shared Helix in the base persona) ---
    vscode = {
      enable = true;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
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
    };
    zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];
    };

    # --- browser ---
    firefox = {
      enable = true;
      policies = {
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisableAccount = true;
        DisableTelemetry = true;
        DisablePocket = true;
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
        Homepage = {
          "StartPage" = "previous-session";
        };
      };
      profiles.default = {
        id = 0;
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];
        search = {
          default = "google";
          order = ["google" "GitHub" "Nix Packages" "NixOS Options" "Home Manager"];
          engines = {
            "Nix Packages" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
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
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Home Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "GitHub" = {
              icon = "https://github.com/favicon.ico";
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
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "ddg".metaData.hidden = true; # builtin engines only support specifying one additional alias
            "bing".metaData.hidden = true;
            "wikipedia".metaData.hidden = true;
          };
        };
      };
    };

    # --- terminal + mail ---
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      settings = {
        theme = "Brogrammer";
      };
    };

    thunderbird = {
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
  };
}
