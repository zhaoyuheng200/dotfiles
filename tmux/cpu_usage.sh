#!/usr/bin/env bash
if [ "$(uname)" = "Darwin" ]; then
  cpu=$(top -l 1 -n 0 | awk '/CPU usage/ {printf "%.1f%%", 100-$7}')
  load=$(sysctl -n vm.loadavg | awk '{print $2}')
else
  cpu=$(top -bn1 | awk '/%Cpu/ {printf "%.1f%%", 100-$8}')
  load=$(awk '{print $1}' /proc/loadavg)
fi
echo "${cpu} (${load})"
