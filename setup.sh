#!/bin/bash
set -euo pipefail
log() { printf "==> %s\n" "$1"; }

# Global variables
HUGO_CMD="hugo"
REPO="gohugoio/hugo"
INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Always reinstall latest
install_hugo() {
  log "Ensuring latest Hugo installation..."

  # Remove existing Hugo
  if command -v "$HUGO_CMD" >/dev/null 2>&1; then
    log "Removing existing Hugo installation..."
    rm -f "$INSTALL_DIR/hugo"
  fi

  # Fetch latest Hugo version
  log "Fetching latest Hugo release info..."
  LATEST_VERSION=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')

  # Download Hugo archive
  ARCHIVE="hugo_extended_${LATEST_VERSION}_linux-amd64.tar.gz"
  DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/${ARCHIVE}"

  log "Downloading Hugo..."
  curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/hugo.tar.gz"

  log "Extracting archive..."
  tar -xzf "$TMP_DIR/hugo.tar.gz" -C "$TMP_DIR"

  # Install on user-environment
  log "Installing Hugo..."
  if [[ ! -d "$INSTALL_DIR" ]]; then
    mkdir -p "$INSTALL_DIR"
  fi
  install -m 0755 "$TMP_DIR/hugo" "$INSTALL_DIR/hugo"
  log "Hugo installed successfully..."
  hugo version
}

# Initialize git submodules
load_submodules() {
  if [[ -f ".gitmodules" ]]; then
    log "Git submodules detected. Initializing..."
    git submodule update --init --recursive
    log "Submodules ready"
  else
    log "No git submodules found"
  fi
}

# Start the Hugo development server
start_hugo() {
  log "Starting Hugo server..."
  exec hugo server -D --bind 0.0.0.0
}

# Bootstrap process
main() {
  install_hugo
  load_submodules
  start_hugo
}

# Enable function calling
if [[ "$#" -eq 0 ]]; then
    main
else
    for fn in "$@"; do
        if declare -F "$fn" >/dev/null; then
            log "Running $fn"
            "$fn"
        else
            log "Error: function '$fn' not found" >&2
            exit 1
        fi
    done
fi
