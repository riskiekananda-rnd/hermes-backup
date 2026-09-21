#!/usr/bin/env bash
# Check bot status in Telegram groups
# Usage: check_bot.sh [bot_username]
# Requires: TELEGRAM_BOT_TOKEN or token passed as argument
set -euo pipefail

BOT_TOKEN="${1:-${TELEGRAM_BOT_TOKEN:-}}"
BOT_NAME="${2:-}"

if [[ -z "$BOT_TOKEN" ]]; then
    echo "Usage: $0 <bot_token> [bot_username]"
    echo "   Or: TELEGRAM_BOT_TOKEN=xxx $0 [bot_username]"
    exit 1
fi

echo "=== Telegram Bot Status Check ==="
echo ""

# Get bot info
BOT_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
OK=$(echo "$BOT_INFO" | grep -o '"ok":[^,]*' | head -1 | cut -d: -f2)

if [[ "$OK" != "true" ]]; then
    echo "ERROR: Bot token is invalid or bot is unreachable."
    echo "Response: $BOT_INFO"
    exit 1
fi

BOT_ID=$(echo "$BOT_INFO" | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
BOT_USERNAME=$(echo "$BOT_INFO" | grep -o '"username":"[^"]*"' | head -1 | cut -d'"' -f4)
BOT_FIRST_NAME=$(echo "$BOT_INFO" | grep -o '"first_name":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "Bot: @$BOT_USERNAME ($BOT_FIRST_NAME)"
echo "ID:  $BOT_ID"
echo ""

# Check webhook status
WEBHOOK_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo")
WEBHOOK_URL=$(echo "$WEBHOOK_INFO" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)
WEBHOOK_PENDING=$(echo "$WEBHOOK_INFO" | grep -o '"pending_update_count":[0-9]*' | cut -d: -f2)
WEBHOOK_ERRORS=$(echo "$WEBHOOK_INFO" | grep -o '"last_error_message":"[^"]*"' | head -1 | cut -d'"' -f4)

if [[ -n "$WEBHOOK_URL" ]]; then
    echo "Webhook: $WEBHOOK_URL"
    echo "Pending updates: ${WEBHOOK_PENDING:-0}"
    if [[ -n "$WEBHOOK_ERRORS" ]]; then
        echo "Last error: $WEBHOOK_ERRORS"
    fi
else
    echo "Webhook: not set (using getUpdates polling)"
fi
echo ""

# Get recent updates count
UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates?limit=100" 2>/dev/null)
UPDATE_COUNT=$(echo "$UPDATES" | grep -o '"update_id"' | wc -l)
echo "Recent updates (last 100): $UPDATE_COUNT"

# List groups the bot is in via getMyMember (requires bot to be admin)
echo ""
echo "=== Bot is active and responding ==="
