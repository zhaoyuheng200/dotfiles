# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managing Neovim, tmux, and WezTerm configs. Designed to work across macOS, Linux, and Amazon cloud desktops (dev-dsk-* hostnames), with adaptive behavior per environment.

## Setup

```bash
./setup.sh           # Install deps, symlink configs, init submodules
```

Post-install: open `nvim` (auto-installs plugins), then in tmux press `Ctrl-a Shift+I` (install TPM plugins).

For tree-sitter GLIBC errors on AL2023: `./build-tree-sitter-al2023.sh`

## Repository Structure

- `nvim/` -> symlinked to `~/.config/nvim` — LazyVim-based Neovim config
- `tmux/` -> symlinked to `~/.config/tmux` — tmux config with catppuccin theming
- `wezterm/` -> WezTerm terminal config
- `scripts/` — helper scripts
- `packages.config` — Chocolatey packages (Windows)

## Neovim Architecture

Built on **LazyVim** (not raw Neovim config). Plugin specs go in `nvim/lua/plugins/`, config modules in `nvim/lua/config/`.

Key choices:
- **Picker:** fzf-lua (not telescope)
- **Python LSP:** pyright
- **Autoformat:** disabled globally (`vim.g.autoformat = false`)
- **Colorscheme:** catppuccin (macchiato)
- **Completion:** blink.cmp
- **Navigation:** vim-tmux-navigator (Ctrl+h/j/k/l shared with tmux)

Lua formatting: `stylua` with 2-space indent, 120 column width (see `nvim/stylua.toml`).

## Tmux Architecture

- **Prefix:** `Ctrl-a` (not default Ctrl-b)
- **Plugin manager:** TPM (git submodule at `tmux/plugins/tpm`)
- **Theme:** catppuccin macchiato with custom status modules
- **Session persistence:** tmux-resurrect + tmux-continuum (auto-save every 5 min)

Helper scripts in `tmux/` (pane borders, path formatting, CPU/RAM monitoring) detect the environment — battery and IP modules are skipped on Amazon cloud desktops (hostname `dev-dsk-*`). Custom catppuccin status modules live in `tmux/custom_modules/`.

`tmux/format_path.sh` handles Amazon workspace paths (`/workplace/$USER`) and home directory shorthand.
