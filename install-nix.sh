#!/usr/bin/env bash
#
# Nix-based Dev Environment Setup
#
# Alternative to install-osx.sh / install-linux.sh.
# Bootstraps Nix (via the Determinate Systems installer) and then runs
# either `darwin-rebuild switch` (macOS) or `home-manager switch` (Linux)
# against ./nix/flake.nix.
#

if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail
trap 'echo "[ERROR] line $LINENO" >&2' ERR

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLAKE_DIR="$SCRIPT_DIR/nix"
HOSTNAME_LABEL=mac   # must match `darwinConfigurations.<name>` in flake.nix

if [[ ! -f "$FLAKE_DIR/flake.nix" ]]; then
  echo "flake.nix not found at $FLAKE_DIR — aborting." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 1. Install Nix (multi-user, flakes pre-enabled)
# ---------------------------------------------------------------------------
if ! command -v nix &>/dev/null; then
  echo "Installing Nix (Determinate Systems installer)..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
fi

NIX_FLAGS=(--extra-experimental-features "nix-command flakes")

# ---------------------------------------------------------------------------
# 2. Apply the flake
# ---------------------------------------------------------------------------
case "$(uname -s)" in
  Darwin)
    echo "Applying nix-darwin config → $FLAKE_DIR#$HOSTNAME_LABEL"
    nix "${NIX_FLAGS[@]}" run github:LnL7/nix-darwin -- \
      switch --flake "$FLAKE_DIR#$HOSTNAME_LABEL"
    ;;
  Linux)
    USERNAME=$(id -un)
    echo "Applying home-manager config → $FLAKE_DIR#$USERNAME@linux"
    nix "${NIX_FLAGS[@]}" run github:nix-community/home-manager -- \
      switch --flake "$FLAKE_DIR#$USERNAME@linux"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

echo
echo "Done. Rebuild in the future with one of:"
echo "  darwin-rebuild switch --flake $FLAKE_DIR#$HOSTNAME_LABEL"
echo "  home-manager switch   --flake $FLAKE_DIR#\$USER@linux"
