#!/bin/bash
# FreeLLMAPI Status Check
# Check API health, models, and database

echo "=== FreeLLMAPI Status $(date '+%H:%M') ==="

# Get unified key
FREELLMAPI_KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';" 2>/dev/null)

if [ -z "$FREELLMAPI_KEY" ]; then
    echo "❌ No API key found"
    exit 1
fi

# Check API health
echo "1. API Health:"
MODELS=$(curl -s http://localhost:3001/v1/models -H "Authorization: Bearer $FREELLMAPI_KEY" 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('data',[])))" 2>/dev/null)
if [ -n "$MODELS" ]; then
    echo "   ✅ Running ($MODELS models)"
else
    echo "   ❌ Not responding"
fi

# Check database
echo "2. Database:"
DB_SIZE=$(du -sh ~/freellmapi/server/data/freeapi.db 2>/dev/null | awk '{print $1}')
echo "   Size: $DB_SIZE"

# Check processes
echo "3. Processes:"
PROCS=$(ps aux | grep -E 'tsx|node' | grep -v grep | wc -l)
echo "   Active: $PROCS"

# Check for errors
echo "4. Recent Errors:"
ERRORS=$(grep -c 'ERROR\|FATAL' ~/freellmapi/logs/*.log 2>/dev/null || echo '0')
echo "   Count: $ERRORS"

echo ""
echo "=== Status Complete ==="
