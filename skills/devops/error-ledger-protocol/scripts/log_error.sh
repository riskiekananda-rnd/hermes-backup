#!/bin/bash
# Error Ledger Protocol - Quick Error Logger
# Usage: ./log_error.sh "Error description" "Root cause" "Fix applied"

ERROR_DESC="${1:-No description}"
ROOT_CAUSE="${2:-Unknown}"
FIX_APPLIED="${3:-Pending}"

LEDGER_FILE="$HOME/.hermes/cache/scratch/error_ledger.md"

# Create ledger if not exists
if [ ! -f "$LEDGER_FILE" ]; then
    echo "# Error Ledger" > "$LEDGER_FILE"
    echo "Started: $(date '+%Y-%m-%d %H:%M')" >> "$LEDGER_FILE"
    echo "" >> "$LEDGER_FILE"
fi

# Append error
echo "### $(date '+%Y-%m-%d %H:%M') - $ERROR_DESC" >> "$LEDGER_FILE"
echo "- **Symptom:** $ERROR_DESC" >> "$LEDGER_FILE"
echo "- **Root Cause:** $ROOT_CAUSE" >> "$LEDGER_FILE"
echo "- **Fix:** $FIX_APPLIED" >> "$LEDGER_FILE"
echo "- **Status:** Logged" >> "$LEDGER_FILE"
echo "" >> "$LEDGER_FILE"

echo "Error logged to $LEDGER_FILE"
