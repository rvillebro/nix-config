{ pkgs, ... }:
{
  programs.firfox = {
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
}