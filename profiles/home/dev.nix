# Dev home profile: shared headless tooling for every User.
{pkgs, ...}: let
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
      # pi settings: default model + scoped models for Ctrl+P cycling.
      # Declarative: edits made inside pi (/settings) are overwritten on switch.
      ".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "openrouter";
        defaultModel = "z-ai/glm-5.3-flash";
        defaultThinkingLevel = "high";
        enabledModels = [
          "z-ai/glm-*"
          "anthropic/claude-*"
          "openai/gpt-*"
        ];
      };
      ".pi/agent/skills/mattpocock-skills" = {
        source = "${mattpocock-skills}/skills";
        recursive = true;
      };
    };
  };
}
