{ pkgs, config, ... }:
let
  mattpocock-skills = builtins.fetchGit {
    url = "https://github.com/mattpocock/skills.git";
    ref = "main";
    rev = "b8be62ffacb0118fa3eaa29a0923c87c8c11985c";
    sparseCheckout = [ "skills" ];
  };
in
{
  home.packages = with pkgs; [
    unstable.pi-coding-agent
  ];

  home.file.".pi/agent/skills/engineering" = {
    source = "${mattpocock-skills}/engineering";
    recursive = true;
  };
}