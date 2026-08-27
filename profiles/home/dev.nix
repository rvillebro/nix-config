# Dev home persona: shared headless tooling for every User that writes code.
#
# `pi-coding-agent` only, headless, pinned to a single locked skill revision
# shared by all dev Users. The per-machine source forks that used to live in
# `hosts/*/home/pi-coding-agent.nix` are removed — there is no per-machine
# override point here.
{pkgs, ...}: let
  mattpocock-skills = builtins.fetchGit {
    url = "https://github.com/mattpocock/skills.git";
    rev = "d574778f94cf620fcc8ce741584093bc650a61d3";
  };
in {
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
