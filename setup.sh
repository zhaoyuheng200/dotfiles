#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES"
echo ""

# Prerequisites: git, zsh, curl must be installed via system package manager
for cmd in git zsh curl unzip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[error] $cmd is required but not installed. Install it first:"
    echo "  sudo apt install $cmd"
    exit 1
  fi
done

# Install mise
echo "=== mise ==="
if command -v mise >/dev/null 2>&1 || [ -x "$HOME/.local/bin/mise" ]; then
  echo "[skip] mise already installed"
else
  echo "[info] Installing mise..."
  curl https://mise.run | sh
fi
MISE="$HOME/.local/bin/mise"

# Install tools via mise
echo ""
echo "=== Tools (via mise) ==="
$MISE install neovim@latest fzf@latest fd@latest ripgrep@latest yazi@latest node@lts 2>&1
$MISE use -g neovim@latest fzf@latest fd@latest ripgrep@latest yazi@latest node@lts 2>&1

# Install tldr via npm
echo ""
echo "=== tldr ==="
if command -v tldr >/dev/null 2>&1 || [ -x "$HOME/.local/share/mise/shims/tldr" ]; then
  echo "[skip] tldr already installed"
else
  echo "[info] Installing tldr..."
  export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
  npm install -g tldr
fi

# Install oh-my-zsh to XDG path
echo ""
echo "=== Oh My Zsh ==="
OMZ_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"
if [ -d "$OMZ_DIR" ]; then
  echo "[skip] oh-my-zsh already installed at $OMZ_DIR"
else
  echo "[info] Installing oh-my-zsh..."
  ZSH="$OMZ_DIR" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Install oh-my-zsh custom plugins
echo ""
echo "=== Oh My Zsh Plugins ==="
OMZ_CUSTOM="$OMZ_DIR/custom/plugins"
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [you-should-use]="https://github.com/MichaelAquilina/zsh-you-should-use"
)
for name in "${!plugins[@]}"; do
  if [ -d "$OMZ_CUSTOM/$name" ]; then
    echo "[skip] $name already installed"
  else
    echo "[info] Installing $name..."
    git clone "${plugins[$name]}" "$OMZ_CUSTOM/$name"
  fi
done

# Create ~/.config if needed
mkdir -p ~/.config

# Symlink zshrc
echo ""
echo "=== Symlinks ==="
if [ -L ~/.zshrc ] || [ -e ~/.zshrc ]; then
  echo "[skip] ~/.zshrc already exists"
else
  ln -s "$DOTFILES/zshrc" ~/.zshrc
  echo "[done] Linked ~/.zshrc"
fi

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

# Manual steps
echo ""
echo "=== Manual Steps ==="
echo "1. Open nvim to auto-install lazy.nvim plugins and Mason packages:"
echo "     nvim"
echo ""
echo "2. Start tmux and install plugins with TPM:"
echo "     prefix + I  (Ctrl-a then Shift+I)"
echo ""
echo "3. Change default shell to zsh (if not already):"
echo "     chsh -s \$(which zsh)"
