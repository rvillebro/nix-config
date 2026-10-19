# Dev home profile: shared headless tooling for every User.
{ pkgs, ... }:
let
  mattpocock-skills = fetchGit {
    url = "https://github.com/mattpocock/skills.git";
    rev = "24fe0ef7737efae15c87225755e9f6f5965e4888";
  };
in
{
  home = {
    sessionVariables = {
      PI_SKIP_VERSION_CHECK = "1";
    };
    packages = with pkgs; [
      unstable.pi-coding-agent
      unstable.nodejs
      unstable.bun
    ];
    file = {
      ".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "openrouter";
        defaultModel = "z-ai/glm-5.3-flash";
        defaultThinkingLevel = "high";
        packages = [
          "npm:pi-web-access"
          "npm:pi-subagents"
        ];
      };
      ".pi/agent/skills/mattpocock-skills" = {
        source = "${mattpocock-skills}/skills";
        recursive = true;
      };
    };
  };
}
