#!/usr/bin/env bash
conf="$HOME/.config/tmux/tmux.conf"
plugins_dir="$HOME/.config/tmux/plugins"
missing=""

while IFS= read -r plugin; do
  dir="${plugin##*/}"
  dir="${dir%%#*}"
  [ ! -d "$plugins_dir/$dir" ] && missing="$missing $dir"
done < <(grep -oP "set\s+-g\s+@plugin\s+['\"]?\K[^'\"#]+" "$conf")

TMUX_BIN=$(command -v tmux || echo /usr/local/bin/tmux)
[ -n "$missing" ] && "$TMUX_BIN" display-message "Missing tmux plugins:$missing -- press prefix+I to install"
exit 0
