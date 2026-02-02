#!/bin/bash
set -euo pipefail
log() { printf "\n==> %s\n" "$1"; }

HUGO_CMD="hugo"
REPO="gohugoio/hugo"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if command -v "$HUGO_CMD" >/dev/null 2>&1; then
  log "Hugo already installed"
  hugo version
else
  log "Hugo not found. Installing latest version..."

  log "Fetching latest Hugo release info..."
  LATEST_VERSION=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')

  if [[ -z "$LATEST_VERSION" ]]; then
    log "Failed to determine latest Hugo version"
    exit 1
  fi

  log "Latest version: $LATEST_VERSION"

  ARCHIVE="hugo_extended_${LATEST_VERSION}_linux-amd64.tar.gz"
  DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/${ARCHIVE}"

  log "Downloading Hugo..."
  curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/hugo.tar.gz"

  log "Extracting archive..."
  tar -xzf "$TMP_DIR/hugo.tar.gz" -C "$TMP_DIR"

  log "Installing Hugo (sudo required)..."
  sudo install -m 0755 "$TMP_DIR/hugo" "$INSTALL_DIR/hugo"

  log "Hugo installed successfully"
  hugo version
fi

if [[ -f ".gitmodules" ]]; then
  log "Git submodules detected. Initializing..."
  git submodule update --init --recursive
  log "Submodules ready"
else
  log "No git submodules found"
fi

log "Starting Hugo server..."
exec hugo server -D --bind 0.0.0.0
