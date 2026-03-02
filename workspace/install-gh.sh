#!/bin/sh
# install-gh.sh — Safe, local install of GitHub CLI (gh) for ARM64
# Run with: chmod +x install-gh.sh && ./install-gh.sh

set -e

echo "🔍 Detecting architecture..."
ARCH=$(uname -m)
case "$ARCH" in
  arm64|aarch64) BIN_ARCH="arm64" ;;
  amd64|x86_64) BIN_ARCH="amd64" ;;
  *) echo "Error: Unsupported arch: $ARCH"; exit 1 ;;
esac

echo "📥 Downloading gh for $BIN_ARCH..."
URL="https://github.com/cli/cli/releases/latest/download/gh_2.46.0_linux_${BIN_ARCH}.tar.gz"
mkdir -p ~/.local/bin
cd /tmp || cd ~ || exit 1
wget -qO gh.tar.gz "$URL" || { echo "❌ Download failed"; exit 1; }
tar -xzf gh.tar.gz || { echo "❌ Extract failed"; exit 1; }
cp "gh_*/bin/gh" ~/.local/bin/gh || { echo "❌ Copy failed"; exit 1; }
rm -rf gh_* gh.tar.gz

echo "✅ Installed gh to ~/.local/bin/gh"
echo "🔧 Adding ~/.local/bin to PATH (for current session)..."
export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "🚀 To use gh permanently, add this to ~/.profile or ~/.bashrc:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "Test it now: ~/.local/bin/gh --version"