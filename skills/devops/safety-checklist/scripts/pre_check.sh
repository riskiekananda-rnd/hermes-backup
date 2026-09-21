#!/bin/bash
# Safety Checklist - Pre/Post Operation Check
# Run before destructive operations

echo "=== Safety Checklist $(date '+%Y-%m-%d %H:%M') ==="
echo ""

# Pre-operation checks
echo "=== PRE-OPERATION CHECKS ==="

# 1. Backup config
echo "1. Backup config:"
if [ -f ~/.hermes/.env ]; then
    echo "   ✅ .env exists"
else
    echo "   ❌ .env missing!"
fi

if [ -f ~/.hermes/config.yaml ]; then
    echo "   ✅ config.yaml exists"
else
    echo "   ❌ config.yaml missing!"
fi

# 2. Check disk space
echo "2. Disk space:"
DISK_USAGE=$(df -h ~ | tail -1 | awk '{print $5}' | tr -d '%')
if [ $DISK_USAGE -lt 85 ]; then
    echo "   ✅ ${DISK_USAGE}% used"
else
    echo "   ⚠️ ${DISK_USAGE}% used - low space!"
fi

# 3. Check running services
echo "3. Running services:"
if pgrep -f "tsx watch" > /dev/null; then
    echo "   ⚠️ FreeLLMAPI is running"
else
    echo "   ✅ FreeLLMAPI not running"
fi

if pgrep -f "hermes gateway" > /dev/null; then
    echo "   ⚠️ Hermes gateway is running"
else
    echo "   ✅ Hermes gateway not running"
fi

# 4. Check state.db integrity
echo "4. State.db integrity:"
if sqlite3 ~/.hermes/state.db "PRAGMA integrity_check;" 2>/dev/null | grep -q "ok"; then
    echo "   ✅ state.db OK"
else
    echo "   ❌ state.db may be corrupted"
fi

echo ""
echo "=== Checklist Complete ==="
echo "Review warnings before proceeding with operation."
