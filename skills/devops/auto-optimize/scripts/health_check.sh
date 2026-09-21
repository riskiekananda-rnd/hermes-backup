#!/bin/bash
# Auto-Optimize Health Check Script
# Run via cron every 6 hours

echo "=== Health Check $(date '+%Y-%m-%d %H:%M') ==="

# Disk usage
echo "Disk: $(df -h ~ | tail -1 | awk '{print $5}') used"

# Load average
LOAD=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
echo "Load: $LOAD"

# FreeLLMAPI check
FREELLMAPI_KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';" 2>/dev/null)
if [ -n "$FREELLMAPI_KEY" ]; then
    MODELS=$(curl -s http://localhost:3001/v1/models -H "Authorization: Bearer $FREELLMAPI_KEY" 2>/dev/null | python3 -c "import json,sys; print(len(json.load(sys.stdin).get('data',[])))" 2>/dev/null)
    echo "FreeLLMAPI: Running ($MODELS models)"
else
    echo "FreeLLMAPI: No API key"
fi

# Memory
echo "Memory: $(free -h 2>/dev/null | grep Mem | awk '{print $3}') used of $(free -h 2>/dev/null | grep Mem | awk '{print $2}')"

# Active processes
echo "Processes: $(ps aux | grep -E 'tsx|node|python' | grep -v grep | wc -l) active"

# Disk space alert
USAGE=$(df ~ | tail -1 | awk '{print $5}' | tr -d '%')
if [ $USAGE -gt 85 ]; then
    echo "⚠️ WARNING: Disk usage at ${USAGE}%!"
fi
