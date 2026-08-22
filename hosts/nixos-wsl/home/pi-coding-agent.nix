{
  pkgs,
  config,
  ...
}: let
  mattpocock-skills = builtins.fetchGit {
    url = "https://github.com/mattpocock/skills.git";
    rev = "6acc160e4e0cd062dbbbd7a1b26ae92855edf07e";
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
