#!/bin/bash
# Runaway Sentinel - Process Scanner
# Detect and report resource-heavy processes

echo "=== Runaway Sentinel $(date '+%Y-%M %H:%M') ==="
echo ""

# Top CPU consumers
echo "=== Top CPU Consumers ==="
ps aux --sort=-%cpu | head -10
echo ""

# Top RAM consumers
echo "=== Top RAM Consumers ==="
ps aux --sort=-%mem | head -10
echo ""

# System overview
echo "=== System Overview ==="
uptime
echo ""

# Load average check
LOAD=$(awk '{print $1}' /proc/loadavg 2>/dev/null || uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
if [ $(echo "$LOAD > 8" | bc 2>/dev/null || echo 0) -eq 1 ]; then
    echo "⚠️ WARNING: Load average $LOAD is high!"
fi

# Memory check
MEM_USED=$(free -h 2>/dev/null | grep Mem | awk '{print $3}')
MEM_TOTAL=$(free -h 2>/dev/null | grep Mem | awk '{print $2}')
echo "Memory: $MEM_USED used of $MEM_TOTAL"

# Process count
PROCS=$(ps aux | grep -E 'tsx|node|python' | grep -v grep | wc -l)
echo "Active processes: $PROCS"

# Potential runaways
echo ""
echo "=== Potential Runaways ==="
ps aux | awk '$3 > 50 || $4 > 50 {print "⚠️ " $11 " (CPU:" $3 "% MEM:" $4 "%)"}' | head -5
