# Shared work server home profile: the work-only toolset for all work servers.
{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      glab
    ];
    shellAliases = {
      wd = "cd /work/$USER";
      pd = "cd /people/$USER";
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
  in
    slurmView "sout" "StdOut" + slurmView "serr" "StdErr";

  programs = {
    rclone.enable = true;
    awscli.enable = true;
    git.settings.user.email = "rav@evaxion.ai";

    ssh = {
      enable = true;
      settings = {
        "*" = {
          IdentityFile = "${config.home.homeDirectory}/.ssh/rav-servers";
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
