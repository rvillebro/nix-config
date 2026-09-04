## Agent skills

### Issue tracker

GitHub Issues (uses the `gh` CLI). See `docs/agents/issue-tracker.md`.

### Triage labels

Default canonical labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context; `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

### Formatting

The flake's `formatter` output is alejandra; `nix fmt` runs it. Always point it at files (or `.` for the whole repo), with no args it reads stdin and fails:

```
nix fmt -- --check <files>   # verify (list files, or `.` for everything)
nix fmt <files>              # apply
```

The `--` forwards flags to alejandra; `nix fmt --check ...` without `--` fails (`unrecognised flag`).

### Verifying a config change

Evaluate a host/standalone attribute directly rather than reading the store path:

```
nix eval --raw '.#nixosConfigurations.<host>.config.<path>'          # NixOS hosts (xps13/rpi4/nixos-wsl)
nix eval --json '.#homeConfigurations."<profile>".config.<path>'    # standalone (rav@home, rav@work)
```

For systemd units, evaluate `<service>.serviceConfig` (not `systemd.units`/`unitText`). `nix run
.#formatter.*` and `nix eval` need `--check`/`--raw` care as shown.

### Parsing nix JSON output

`python3` and `jq` are **not** on the agent PATH. To read `nix eval --json` output, pipe it to a temp file
and use `nix run 'nixpkgs#jq' -- <filter> < /tmp/out.json`.
