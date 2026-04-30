#!/bin/bash
export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

log_info "--- System Dashboard ---"
echo -n "CPU Usage: "; top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}' || echo "N/A"
echo -n "RAM Usage: "; free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' || echo "N/A"
echo -n "Disk Space: "; df -h /data | awk '$NF=="/data"{printf "%s/%s (%s)\n", $3,$2,$5}' || echo "N/A"
echo "Active Sessions:"
ps aux | grep vncserver | grep -v grep || echo "  None"
echo "------------------------"
