#!/bin/bash
# Notify local WezTerm that Kiro started working. See notify-done.sh for the
# $KIRO_NOTIFY_TTY rationale (kiro-cli blanks $TTY).
TARGET_TTY="$KIRO_NOTIFY_TTY"
[ -z "$TARGET_TTY" ] && TARGET_TTY="$(tmux display-message -p "#{pane_tty}" 2>/dev/null)"
[ -z "$TARGET_TTY" ] && TARGET_TTY="$SSH_TTY"

TMUX_INFO=$(tmux display-message -p "#S:#I.#P #W" 2>/dev/null || echo "unknown")
printf "\ePtmux;\e\033]1337;SetUserVar=%s=%s\007\e\\" kiro_start "$(echo -n "$TMUX_INFO" | base64 -w 0)" > "$TARGET_TTY" 2>/dev/null
