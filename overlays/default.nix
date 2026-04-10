# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs {pkgs = final; lib = prev.lib;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      # nixos-25.11 removed top-level xorg aliases (libX11, libXaw, libXmu, …).
      # Re-add them explicitly so packages in pkgs/by-name that still reference the
      # old capitalized argument names (e.g. hwloc, groff) keep working.
      xorgLibXNames = [
        "libX11" "libXScrnSaver" "libXTrap" "libXau" "libXaw"
        "libXcomposite" "libXcursor" "libXdamage" "libXdmcp" "libXext"
        "libXfixes" "libXfont" "libXfont2" "libXft" "libXi" "libXinerama"
        "libXmu" "libXp" "libXpm" "libXpresent" "libXrandr" "libXrender"
        "libXres" "libXt" "libXtst" "libXv" "libXvMC"
        "libXxf86dga" "libXxf86misc" "libXxf86vm"
      ];
      xorgLibXAliases = builtins.listToAttrs (map (n: { name = n; value = prev.xorg.${n}; }) xorgLibXNames);
    in
    xorgLibXAliases // {
      # nixos-25.11 renamed/moved these; various package.nix files still
      # reference the old argument names.
      libpthreadstubs = prev.libpthread-stubs;
      xcbutilkeysyms = prev.xorg.xcbutilkeysyms;
      libICE = prev.xorg.libICE;
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
