#!/usr/bin/env bash
# pane_border_format.sh - Generate pane border label with catppuccin styling.
# Called from tmux.conf via #(). Receives pane_active, pane_current_command,
# pane_current_path, and 4 catppuccin colors as arguments.
#
# Active pane: accent pill with dark text
# Inactive pane: surface pill with muted text

active="$1"
command="$2"
path="$3"

formatted_path=$(~/.config/tmux/format_path.sh "$path")

if [ "$active" = "1" ]; then
  bg=$(tmux show-option -gqv @thm_mauve)
  fg=$(tmux show-option -gqv @thm_crust)
else
  bg=$(tmux show-option -gqv @thm_surface_0)
  fg=$(tmux show-option -gqv @thm_overlay_1)
fi

LEFT=$'\xee\x82\xb6'
RIGHT=$'\xee\x82\xb4'

echo "#[fg=${bg},bg=default]${LEFT}#[fg=${fg},bg=${bg}] ${command}  ${formatted_path} #[fg=${bg},bg=default]${RIGHT}"
