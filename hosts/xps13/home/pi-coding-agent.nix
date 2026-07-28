{ pkgs, config, ... }:
let
  mattpocock-skills = builtins.fetchGit {
    url = "https://github.com/mattpocock/skills.git";
    rev = "d574778f94cf620fcc8ce741584093bc650a61d3";
  };
in
{
  home = {
    sessionVariables = {
      PI_SKIP_VERSION_CHECK = "1";
    };
    packages = with pkgs; [
      unstable.pi-coding-agent
    ];
    file = {
      ".pi/agent/skills/mattpocock-skills" = {
        source = "${mattpocock-skills}/skills";
        recursive = true;
      };
    };
  };
}
