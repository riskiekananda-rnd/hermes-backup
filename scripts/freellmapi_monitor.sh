#!/bin/bash
echo "=== FreeLLMAPI Monitor $(date '+%H:%M') ==="

# API health with auth
FREELLMAPI_KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';" 2>/dev/null)
if [ -n "$FREELLMAPI_KEY" ]; then
    MODELS=$(curl -s http://localhost:3001/v1/models -H "Authorization: Bearer $FREELLMAPI_KEY" 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('data',[])))" 2>/dev/null)
    echo "API: Running ($MODELS models)"
else
    echo "API: No key"
fi

# Database size
DB_SIZE=$(du -sh ~/freellmapi/server/data/freeapi.db 2>/dev/null | awk '{print $1}')
echo "DB: $DB_SIZE"

# Node processes
PROCS=$(ps aux | grep -E 'tsx|node' | grep -v grep | wc -l)
echo "Processes: $PROCS"

# Check for errors in logs
ERRORS=$(grep -c 'ERROR\|FATAL' ~/freellmapi/logs/*.log 2>/dev/null || echo '0')
echo "Errors: $ERRORS"
