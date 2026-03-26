#!/usr/bin/env bash
# Formats pane_current_path for tmux status bar:
#   - On cloud desktop inside a Brazil workspace: @ws/WorkspaceName/relative/path
#   - Otherwise: ~/relative/path (or full path if outside home)
path="$1"
home="/local/home/$USER"

# Workspace detection only on cloud desktops (hostname starts with dev-dsk-)
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

if [[ "$path" == "$home/"* ]]; then
  echo "~/${path#$home/}"
elif [[ "$path" == "$home" ]]; then
  echo "~"
else
  echo "$path"
fi
