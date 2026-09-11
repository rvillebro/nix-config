# Shared work server home profile: the work-only toolset for all work servers.
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      glab
    ];
    shellAliases = {
      sstate = "sinfo -Np any --Format NodeHost,AllocMem,Memory,CPUsState,GRES:25,GRESUSED:35,STATELONG";
    };
  };

  # SLURM job output viewers. scontrol/sinfo come from the servers
  # themselves — no slurm package here, to avoid version mismatch with the
  # cluster's controller.
  programs.bash.initExtra = let
    slurmView = name: field: ''
      ${name}() {
        # Get ${field} of a Slurm job
        if [ $# -ne 1 ]; then
          echo "Get ${field} of Slurm Job"
          echo "Usage: ${name} <job_id>"
          return 1
        fi

        # Get job information using scontrol; bail early on a bad/aged-out id
        if ! job_info=$(scontrol show job "$1"); then
          echo "Slurm job not found: $1"
          return 1
        fi

        # Extract the ${field} filepath from the job information
        filepath=$(echo "$job_info" | grep -o '${field}=[^ ]*' | cut -d= -f2)

        if [ -z "$filepath" ]; then
          echo "Job $1 has no ${field} path"
          return 1
        fi

        # Display the content of the ${field} file
        if [ -e "$filepath" ]; then
          ''${PAGER:-less} "$filepath"
        else
          echo "${field} file not found: $filepath"
        fi
      }
    '';
    # pd/wd: jump to a directory under /people/<user> or /work/<user>. The
    # optional argument is a path relative to that base; an absolute path is
    # used as-is; no argument returns to the base directory itself. Tab
    # completes directories relative to the base.
    baseCd = ''
      # Shared implementation for pd and wd
      __basecd() {
        local base="$1" name="$2"
        shift 2
        if [ "$#" -gt 1 ]; then
          echo "Usage: $name [path]"
          return 1
        fi
        if [ "$#" -eq 0 ]; then
          cd "$base" || return 1
        elif [[ "$1" == /* ]]; then
          cd "$1" || return 1
        else
          cd "$base/$1" || return 1
        fi
      }

      pd() {
        __basecd "/people/$USER" pd "$@"
      }

      wd() {
        __basecd "/work/$USER" wd "$@"
      }

      # Directory-path completion relative to a base directory ($1) for the
      # word being completed ($2). Suggests directories only, building the
      # relative path level by level; absolute words are completed as-is.
      __basecd_compgen() {
        local base="$1" word="$2" root stem m
        if [[ "$word" == /* ]]; then
          # Absolute word: list against the filesystem, reply with full paths
          root="''${word%/*}"
          root="''${root%/}"
          [ -z "$root" ] && root="/"
          stem="''${word##*/}"
          [ -d "$root" ] || return 0
          while IFS= read -r m; do
            COMPREPLY+=("$m/")
          done < <(compgen -d -- "''${root%/}/$stem" 2>/dev/null)
        else
          # Relative word: list against the base, reply with base-relative paths
          if [[ "$word" == */ ]]; then
            root="$base/''${word%/}"
            stem=""
          elif [[ "$word" == */* ]]; then
            root="$base/''${word%/*}"
            stem="''${word##*/}"
          else
            root="$base"
            stem="$word"
          fi
          [ -d "$root" ] || return 0
          while IFS= read -r m; do
            COMPREPLY+=("''${m#"$base"/}/")
          done < <(compgen -d -- "$root/$stem" 2>/dev/null)
        fi
      }

      _pd_complete() { __basecd_compgen "/people/$USER" "$2"; }
      _wd_complete() { __basecd_compgen "/work/$USER" "$2"; }
      complete -o nospace -F _pd_complete pd
      complete -o nospace -F _wd_complete wd
    '';
  in
    slurmView "sout" "StdOut" + slurmView "serr" "StdErr" + baseCd;

  programs = {
    rclone.enable = true;
    awscli.enable = true;

    ssh = {
      enable = true;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };

  nix.registry.evaxpkgs = {
    from = {
      id = "evaxpkgs";
      type = "indirect";
    };
    to = {
      type = "git";
      url = "ssh://git@git.evax.ai/tools/evaxpkgs.git";
    };
  };
}
