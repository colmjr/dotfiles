#!/usr/bin/env bash
# Symlink dotfiles into $HOME using GNU stow.
# Usage: ./install.sh [macbook|thinkpad]   (auto-detects if omitted)
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null; then
  echo "GNU stow not found. Install it first:" >&2
  echo "  macOS:  brew install stow" >&2
  echo "  Arch:   sudo pacman -S stow" >&2
  exit 1
fi

machine="${1:-}"
if [[ -z "$machine" ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    machine=macbook
  else
    machine=thinkpad
  fi
fi

case "$machine" in
  macbook|thinkpad) ;;
  *)
    echo "usage: $0 [macbook|thinkpad]" >&2
    exit 1
    ;;
esac

echo "Stowing 'shared' and '$machine' into $HOME"
stow -v -t "$HOME" shared "$machine"
