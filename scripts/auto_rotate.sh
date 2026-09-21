#!/bin/bash
# Auto-Rotate FreeLLMAPI - Failover between free providers
source ~/.hermes/scripts/rotate_providers.sh

KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db \
  "SELECT value FROM settings WHERE key='unified_api_key';" 2>/dev/null)
URL="http://localhost:3001/v1/chat/completions"
PROMPT="${1:-Hello}"
TOKENS="${2:-100}"

for entry in "${PROVIDERS[@]}"; do
    IFS=':' read -r prov model _rpm <<< "$entry"
    printf "🔄 %-6s %s ... " "$prov" "${model:0:40}"
    
    RESP=$(curl -s --max-time 30 "$URL" \
      -H "Authorization: Bearer $KEY" \
      -H "Content-Type: application/json" \
      -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"$PROMPT\"}],\"max_tokens\":$TOKENS}" 2>/dev/null)
    
    OUT=$(echo "$RESP" | python3 -c "
import json,sys
d=json.load(sys.stdin)
if 'choices' in d: print(d['choices'][0]['message']['content'][:200])
elif 'error' in d: print('FAIL: '+d['error'].get('message','')[:80])
else: print('FAIL: unknown')
" 2>/dev/null)
    
    if [[ "$OUT" != FAIL:* ]]; then
        echo "✅"
        echo "$OUT"
        exit 0
    fi
    echo "❌ ${OUT#FAIL: }"
done

echo "❌ All providers exhausted"
exit 1
