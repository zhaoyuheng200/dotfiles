#!/bin/bash
set -e

# Build tree-sitter CLI from source for systems with old glibc
# where the prebuilt binary fails.

INSTALL_DIR="$HOME/.local/bin"
BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

echo "=== tree-sitter source build ==="

# Check requirements
missing=()
command -v git >/dev/null 2>&1 || missing+=("git")
command -v cc >/dev/null 2>&1 || missing+=("cc (gcc/clang)")

if [ ${#missing[@]} -ne 0 ]; then
  echo "[error] Missing required tools: ${missing[*]}"
  exit 1
fi

# Install cargo if missing
if ! command -v cargo >/dev/null 2>&1; then
  echo "[info] cargo not found, installing via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

echo "[info] cargo: $(cargo --version)"
echo "[info] git:   $(git --version)"
echo "[info] cc:    $(cc --version 2>&1 | head -1)"

# Clone and build
echo ""
echo "[build] Cloning tree-sitter..."
git clone --depth 1 https://github.com/tree-sitter/tree-sitter.git "$BUILD_DIR/tree-sitter"

echo "[build] Building tree-sitter (this may take a few minutes)..."
cd "$BUILD_DIR/tree-sitter"
cargo build --release

# Install
mkdir -p "$INSTALL_DIR"
cp target/release/tree-sitter "$INSTALL_DIR/tree-sitter"
chmod +x "$INSTALL_DIR/tree-sitter"

echo ""
echo "[done] Installed: $INSTALL_DIR/tree-sitter"
"$INSTALL_DIR/tree-sitter" --version

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "[warn] $INSTALL_DIR is not in your PATH."
  echo "       Add to your shell rc:"
  echo "         export PATH=\"$INSTALL_DIR:\$PATH\""
fi
