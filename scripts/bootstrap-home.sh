#!/usr/bin/env bash
# Bootstrap this repo's home-manager configuration on a fresh machine.
# Idempotent: skips any step that is already done.
#
# Usage: scripts/bootstrap-home.sh [user@hostname]
#        With no argument, home-manager picks the entry automatically
#        (via its default $USER@$HOSTNAME lookup). Pass user@hostname
#        explicitly to override.
set -euo pipefail

REPO_DIR="${HOME}/nix-config"
REPO_URL="https://github.com/rvillebro/nix-config"
HM_RELEASE="release-26.05" # must match the home-manager input in flake.lock
FLAKE="github:rvillebro/nix-config"
if [[ $# -gt 1 ]]; then
  echo "Usage: $(basename "$0") [user@hostname]" >&2
  exit 1
elif [[ $# -eq 1 ]]; then
  ATTR="$1"
  FLAKE="${FLAKE}#${ATTR}"
fi

step() { printf '\n== %s\n' "$1"; }
skip() { printf '   skipped (already set up)\n'; }

step "Checking Nix"
if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is not installed. Install it first (multi-user install), then re-run:" >&2
  echo "  sh <(curl -L https://nixos.org/nix/install) --daemon" >&2
  exit 1
fi
echo "   nix $(nix --version)"

step "Checking repo clone at ${REPO_DIR}"
if [[ -d "${REPO_DIR}/.git" ]]; then
  skip
else
  if [[ -e "${REPO_DIR}" ]]; then
    echo "${REPO_DIR} exists but is not a git checkout; move it away and re-run." >&2
    exit 1
  fi
  git clone "${REPO_URL}" "${REPO_DIR}"
fi

step "Checking home-manager activation for ${ATTR}"
# Activated standalone home-manager shows up as a profile in the user state dir
# (older installs: ~/.nix-profile/home-manager).
if [[ -e "${HOME}/.local/state/nix/profiles/home-manager" ]] ||
  [[ -e "${HOME}/.nix-profile/home-manager" ]]; then
  skip
  echo "   To re-apply manually: home-manager switch --flake ${REPO_DIR}#${ATTR} -b backup"
  exit 0
fi

# Verify the flake actually has the requested entry before switching.
# (With no explicit attr, home-manager's own lookup is used as-is.)
if [[ -n "${ATTR:-}" ]] && ! nix eval --raw "${FLAKE}" >/dev/null 2>&1; then
  echo "No homeConfigurations.\"${ATTR}\" in the flake; check the hostname" >&2
  echo "against the work-server lists in flake.nix." >&2
  exit 1
fi

step "First activation (home-manager from its flake, -b backup)"
nix run "github:nix-community/home-manager/${HM_RELEASE}" -- \
  switch --flake "${FLAKE}" -b backup

step "Done"
echo "   home-manager is now in your profile; later switches from ${REPO_DIR}:"
echo "   home-manager switch --flake .${FLAKE#github:rvillebro/nix-config} -b backup"
