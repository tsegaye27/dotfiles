#!/bin/bash
# Get total memory in GB
total_gb=$(sysctl -n hw.memsize | awk '{printf "%.1f", $1/1024/1024/1024}')

# Get active memory (actually used by applications, matches neofetch)
vm_stat | python3 -c "
import sys
import re

vm_stat = sys.stdin.read()
pagesize = int(re.search(r'page size of (\d+)', vm_stat).group(1))
active = int(re.search(r'Pages active:\s+(\d+)', vm_stat).group(1))

used_gb = (active * pagesize) / (1024**3)
total_gb = $total_gb
print(f'{used_gb:.1f}/{total_gb:.1f}GB')
"
