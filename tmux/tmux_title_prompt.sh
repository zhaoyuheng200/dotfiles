#!/usr/bin/env bash
# tmux_title_prompt.sh - Prompt for window title on new tmux pane/window.
# Source this from zshrc: [ -n "$TMUX" ] && source ~/.config/tmux/tmux_title_prompt.sh
if [ -z "$TMUX_TITLE_SET" ]; then
  read -r "title?Window title (enter to skip): "
  if [ -n "$title" ]; then
    printf '\033]2;%s\033\\' "$title"
  fi
  export TMUX_TITLE_SET=1
fi
