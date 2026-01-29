#!/bin/bash

set -euo pipefail

HUGO_CMD="hugo"
REPO="gohugoio/hugo"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if command -v "$HUGO_CMD" >/dev/null 2>&1; then
  echo "✅ Hugo already installed:"
  hugo version
else
  echo "📦 Hugo not found. Installing latest version..."

  echo "➡️  Fetching latest Hugo release info..."
  LATEST_VERSION=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')

  if [[ -z "$LATEST_VERSION" ]]; then
    echo "❌ Failed to determine latest Hugo version"
    exit 1
  fi

  echo "➡️  Latest version: $LATEST_VERSION"

  ARCHIVE="hugo_extended_${LATEST_VERSION}_linux-amd64.tar.gz"
  DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/${ARCHIVE}"

  echo "⬇️  Downloading Hugo..."
  curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/hugo.tar.gz"

  echo "📂 Extracting..."
  tar -xzf "$TMP_DIR/hugo.tar.gz" -C "$TMP_DIR"

  echo "🚀 Installing Hugo (sudo required)..."
  sudo install -m 0755 "$TMP_DIR/hugo" "$INSTALL_DIR/hugo"

  echo "✅ Hugo installed successfully!"
  hugo version
fi

echo "🌐 Starting Hugo server..."
exec hugo server -D --bind 0.0.0.0
