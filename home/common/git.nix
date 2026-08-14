# Canonical git identity, shared by every profile.
# Profiles may override the identity (e.g. rav-at-work) via a plain value,
# which takes precedence over this default.
{lib, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Rasmus Villebro";
      user.email = lib.mkDefault "rasmus-villebro@hotmail.com";
    };
  };
}
