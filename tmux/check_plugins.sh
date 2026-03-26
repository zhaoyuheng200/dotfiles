#!/usr/bin/env bash
# check_plugins.sh - Alert when tmux plugins declared in tmux.conf are not installed.
#
# TPM (Tmux Plugin Manager) does NOT auto-install plugins. It only installs
# when you explicitly run prefix+I. This means after cloning dotfiles to a new
# machine, plugins will be missing until you manually trigger installation.
#
# This script runs on every tmux start/reload via run-shell in tmux.conf.
# It parses all `set -g @plugin` lines, checks if each plugin directory exists,
# and shows a tmux display-message reminder if any are missing.
#
# Note: TPM uses `set -ogq` (don't overwrite) for plugin defaults, so if a
# plugin was never installed, its format variables (icons, colors) will be empty.

conf="$HOME/.config/tmux/tmux.conf"
plugins_dir="$HOME/.config/tmux/plugins"
missing=""

while IFS= read -r plugin; do
  dir="${plugin##*/}"    # extract repo name from "user/repo"
  dir="${dir%%#*}"       # strip version pinning (e.g. "tmux#v2.1.1" -> "tmux")
  [ ! -d "$plugins_dir/$dir" ] && missing="$missing $dir"
done < <(grep -oP "set\s+-g\s+@plugin\s+['\"]?\K[^'\"#]+" "$conf")

TMUX_BIN=$(command -v tmux || echo /usr/local/bin/tmux)
[ -n "$missing" ] && "$TMUX_BIN" display-message "Missing tmux plugins:$missing -- press prefix+I to install"
exit 0
