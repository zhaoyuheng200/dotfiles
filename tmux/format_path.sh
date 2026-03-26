#!/usr/bin/env bash
# format_path.sh - Format pane_current_path for tmux status bar display.
#
# This dotfiles config is shared across Amazon cloud desktops and personal
# machines (Mac, etc). The formatting adapts based on environment:
#
# On Amazon cloud desktops (hostname starts with "dev-dsk-"):
#   - Brazil workspaces live at /workplace/$USER/<WorkspaceName>/
#   - Paths inside workspaces display as: @ws/WorkspaceName/src/PackageName
#   - This makes it easy to identify which workspace you're in
#
# On all machines:
#   - Home directory paths use ~ shorthand
#   - Note: tmux reports the *real* path via /proc/<pid>/cwd, so on cloud
#     desktops where /home/$USER is a symlink to /local/home/$USER, the path
#     starts with /local/home/. We match against that resolved path.
#
# Usage in tmux.conf:
#   set -g @catppuccin_directory_text " #(~/.config/tmux/format_path.sh #{pane_current_path})"

path="$1"
home="/local/home/$USER"

# Workspace detection only on Amazon cloud desktops.
# Cloud desktops use the hostname pattern "dev-dsk-<user>-<id>.<region>.amazon.com".
# Personal machines (Mac, Linux) won't match, so workspace formatting is skipped.
if [[ "$(hostname)" == dev-dsk-* ]]; then
  ws_root="/workplace/$USER"
  if [[ "$path" == "$ws_root/"* ]]; then
    rel="${path#$ws_root/}"
    ws_name="${rel%%/*}"
    rest="${rel#$ws_name}"
    echo "@ws/${ws_name}${rest}"
    exit 0
  fi
fi

# Collapse home directory to ~
if [[ "$path" == "$home/"* ]]; then
  echo "~/${path#$home/}"
elif [[ "$path" == "$home" ]]; then
  echo "~"
else
  echo "$path"
fi
