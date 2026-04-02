#!/bin/bash
top -l 1 -n 0 | awk '/CPU usage/ {
  cpu=100-$7
  printf "%.1f%%", cpu
}'
