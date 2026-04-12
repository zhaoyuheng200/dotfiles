#!/usr/bin/env bash

linux_mem() {
  free | awk '$1 ~ /Mem/ {printf "%.1fG/%.0fG", $3/1024/1024, $2/1024/1024}'
}

mac_mem() {
  total=$(sysctl -n hw.memsize)
  used=$(vm_stat | awk '/Pages (active|wired down|occupied by compressor)/ {gsub(/\./,"",$NF); s+=$NF} END {print s*4096}')
  awk -v u="$used" -v t="$total" 'BEGIN {printf "%.1fG/%.0fG", u/1024/1024/1024, t/1024/1024/1024}'
}

win_host_mem() {
  cmd.exe /C "wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /value" 2>/dev/null \
    | tr -d '\r' \
    | awk -F= '/FreePhysicalMemory/{f=$2} /TotalVisibleMemorySize/{t=$2}
               END {printf "%.1fG/%.0fG", (t-f)/1024/1024, t/1024/1024}'
}

if [ "$(uname)" = "Darwin" ]; then
  mac_mem
elif grep -qi microsoft /proc/version 2>/dev/null; then
  linux_mem
  printf " | "
  win_host_mem
else
  linux_mem
fi
