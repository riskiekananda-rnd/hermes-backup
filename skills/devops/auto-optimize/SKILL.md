---
name: auto-optimize
version: 3.0.0
description: "Maintenance: clean cache, rotate logs, health."
tags: [maintenance, cleanup, cron, health]
platforms: [linux]
author: Hermes Agent
license: MIT
---

# Auto-Optimize

Maintenance otomatis untuk Termux + Hermes.

## When to Use
- Scheduled maintenance (cron job)
- Disk space low
- Performance issues
- System health check

## Prerequisites
- `df`, `free`, `uptime` (built-in)
- `curl` (for API checks)
- `sqlite3` (for DB checks)

## Quick Reference
```bash
# Run health check
bash ~/.hermes/scripts/health_check.sh

# Clean cache
find ~/.hermes/cache/terminal-output/ -name '*.txt' | head -10 | xargs rm -f
find ~/.hermes/cache/scratch/ -mtime +3 -delete 2>/dev/null

# Rotate logs
find ~/.hermes/logs/ -name '*.log' -size +10M -exec truncate -s 1M {} \;

# Clean npm cache
npm cache clean --force 2>/dev/null

# Clean Python bytecode
find ~ -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null
```

## Health Check Script
```bash
#!/bin/bash
echo "=== Health Check $(date '+%Y-%m-%d %H:%M') ==="
echo "Disk: $(df -h ~ | tail -1 | awk '{print $5}') used"
echo "Load: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')"
FREELLMAPI_KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';" 2>/dev/null)
if [ -n "$FREELLMAPI_KEY" ]; then
    MODELS=$(curl -s http://localhost:3001/v1/models -H "Authorization: Bearer $FREELLMAPI_KEY" 2>/dev/null | python3 -c "import json,sys; print(len(json.load(sys.stdin).get('data',[])))" 2>/dev/null)
    echo "FreeLLMAPI: Running ($MODELS models)"
fi
echo "Memory: $(free -h 2>/dev/null | grep Mem | awk '{print $3}') used of $(free -h 2>/dev/null | grep Mem | awk '{print $2}')"
echo "Processes: $(ps aux | grep -E 'tsx|node|python' | grep -v grep | wc -l) active"
```

## Cleanup Actions (in order)
1. Terminal output cache: `rm -f ~/.hermes/cache/terminal-output/*.txt`
2. Scratch files > 72h: `find ~/.hermes/cache/scratch/ -mtime +3 -delete`
3. Logs > 10MB: `find ~/.hermes/logs/ -name '*.log' -size +10M -exec truncate -s 1M {} \;`
4. npm cache: `npm cache clean --force`
5. Python bytecode: `find ~ -name '__pycache__' -type d -exec rm -rf {} +`
6. Termux packages: `pkg clean`

## Disk Alert
```bash
USAGE=$(df ~ | tail -1 | awk '{print $5}' | tr -d '%')
if [ $USAGE -gt 85 ]; then echo "⚠️ Disk at ${USAGE}%!"; fi
```

## Verification
```bash
bash ~/.hermes/scripts/health_check.sh
```