#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES"
echo ""

# Install system dependencies
echo "=== System Dependencies ==="
if command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y gcc make
elif command -v apt >/dev/null 2>&1; then
  sudo apt install -y gcc make
elif command -v brew >/dev/null 2>&1; then
  brew install gcc make
fi

# fzf: use official git installer (works everywhere, includes shell integration)
if ! command -v fzf >/dev/null 2>&1; then
  echo "[info] Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/share/fzf
  ~/.local/share/fzf/install --bin
fi

# ripgrep: use musl static binary (no glibc dependency)
if ! command -v rg >/dev/null 2>&1; then
  echo "[info] Installing ripgrep..."
  RG_VERSION=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep tag_name | cut -d '"' -f 4)
  curl -Lo /tmp/rg.tar.gz "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf /tmp/rg.tar.gz -C /tmp
  mkdir -p ~/.local/bin
  mv /tmp/ripgrep-*/rg ~/.local/bin/
  rm -rf /tmp/rg.tar.gz /tmp/ripgrep-*
fi

# fd: use musl static binary (no glibc dependency)
if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
  echo "[info] Installing fd..."
  FD_VERSION=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep tag_name | cut -d '"' -f 4)
  curl -Lo /tmp/fd.tar.gz "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf /tmp/fd.tar.gz -C /tmp
  mkdir -p ~/.local/bin
  mv /tmp/fd-*/fd ~/.local/bin/
  rm -rf /tmp/fd.tar.gz /tmp/fd-*
fi

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
