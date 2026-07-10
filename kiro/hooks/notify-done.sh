#!/bin/bash
# Notify local WezTerm (via tmux passthrough) that Kiro finished a response.
# kiro-cli blanks $TTY when spawning hooks, so .zshrc re-exports it as
# $KIRO_NOTIFY_TTY (a name kiro-cli leaves untouched). Fall back to tmux / $SSH_TTY.
TARGET_TTY="$KIRO_NOTIFY_TTY"
[ -z "$TARGET_TTY" ] && TARGET_TTY="$(tmux display-message -p "#{pane_tty}" 2>/dev/null)"
[ -z "$TARGET_TTY" ] && TARGET_TTY="$SSH_TTY"

TMUX_INFO=$(tmux display-message -p "#S:#I.#P #W" 2>/dev/null || echo "unknown")
printf "\ePtmux;\e\033]1337;SetUserVar=%s=%s\007\e\\" kiro_done "$(echo -n "$TMUX_INFO" | base64 -w 0)" > "$TARGET_TTY" 2>/dev/null
