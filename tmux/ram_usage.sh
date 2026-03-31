#!/usr/bin/env bash
if command -v free &>/dev/null; then
  free | awk '$1 ~ /Mem/ {printf "%.1fG/%.0fG", $3/1024/1024, $2/1024/1024}'
else
  total=$(sysctl -n hw.memsize)
  used=$(vm_stat | awk '/Pages (active|wired down|occupied by compressor)/ {gsub(/\./,"",$NF); s+=$NF} END {print s*4096}')
  awk -v u="$used" -v t="$total" 'BEGIN {printf "%.1fG/%.0fG", u/1024/1024/1024, t/1024/1024/1024}'
fi
