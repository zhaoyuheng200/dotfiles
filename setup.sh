#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES"
echo ""

# Create ~/.config if needed
mkdir -p ~/.config

# Symlink nvim
if [ -L ~/.config/nvim ] || [ -e ~/.config/nvim ]; then
  echo "[skip] ~/.config/nvim already exists"
else
  ln -s "$DOTFILES/nvim" ~/.config/nvim
  echo "[done] Linked ~/.config/nvim"
fi

# Symlink tmux
if [ -L ~/.config/tmux ] || [ -e ~/.config/tmux ]; then
  echo "[skip] ~/.config/tmux already exists"
else
  ln -s "$DOTFILES/tmux" ~/.config/tmux
  echo "[done] Linked ~/.config/tmux"
fi

# Init git submodules (TPM)
echo ""
echo "=== Git Submodules ==="
git -C "$DOTFILES" submodule update --init --recursive
echo "[done] Submodules initialized"

# Neovim plugins + Mason
echo ""
echo "=== Neovim ==="
echo "Open nvim to auto-install lazy.nvim plugins and Mason packages."
echo "  nvim"
echo ""

# Tmux plugins
echo "=== Tmux ==="
echo "After starting tmux, install plugins with:"
echo "  prefix + I  (Ctrl-a then Shift+I, since your config rebinds prefix)"
echo ""
echo "On a fresh install where tmux.conf hasn't loaded yet, use:"
echo "  Ctrl-b then Shift+I  (default tmux prefix)"
echo ""
echo "This fetches all plugins defined in tmux.conf via TPM."
echo "You only need to do this once on a new machine."
