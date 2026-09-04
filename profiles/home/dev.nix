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
      ".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "openrouter";
        defaultModel = "z-ai/glm-5.3-flash";
        defaultThinkingLevel = "high";
        enabledModels = [
          "z-ai/glm-5.3-flash"
          "deepseek/deepseek-v4-flash-0731"
          "deepseek/deepseek-v4-pro-0813"
          "deepseek/deepseek-v4-flash-vision-exp"
          "anthropic/claude-sonnet-5"
          "anthropic/claude-opus-5"
          "openai/gpt-5.6-luna"
          "openai/gpt-5.6-terra"
          "openai/gpt-5.6-sol"
          "google/gemini-3.8-flash"
        ];
      };
      ".pi/agent/skills/mattpocock-skills" = {
        source = "${mattpocock-skills}/skills";
        recursive = true;
      };
    };
  };
}
