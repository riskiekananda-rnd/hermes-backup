#!/usr/bin/env bash
# Quick crypto price checker via CoinGecko (free, no API key)
# Usage: price_check.sh [coin_ids...]  (default: bitcoin,ethereum)
set -euo pipefail

COINS="${*:---}"
DEFAULT_COINS="bitcoin,ethereum"

# Handle positional args
if [[ "$COINS" == "---" ]]; then
    COINS="$DEFAULT_COINS"
fi

# Replace spaces with commas for CoinGecko API
COINS=$(echo "$COINS" | tr ' ' ',' | tr '[:upper:]' '[:lower:]')

echo "=== Crypto Price Check ==="
echo "Fetching: $COINS"
echo ""

RESPONSE=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=${COINS}&vs_currencies=usd&include_24hr_change=true&include_market_cap=true")

if [[ -z "$RESPONSE" || "$RESPONSE" == *"error"* ]]; then
    echo "ERROR: Failed to fetch prices. Check network or try again."
    echo "$RESPONSE"
    exit 1
fi

# Parse and display
echo "$RESPONSE" | python3 -c "
import sys, json

data = json.load(sys.stdin)
for coin, vals in data.items():
    price = vals.get('usd', 'N/A')
    change = vals.get('usd_24h_change', 0)
    mcap = vals.get('usd_market_cap', 0)

    # Format
    if isinstance(price, (int, float)):
        if price >= 1:
            price_str = f'\${price:,.2f}'
        else:
            price_str = f'\${price:.6f}'
    else:
        price_str = str(price)

    if isinstance(change, (int, float)):
        arrow = '▲' if change >= 0 else '▼'
        change_str = f'{arrow} {change:+.2f}%'
    else:
        change_str = str(change)

    if isinstance(mcap, (int, float)) and mcap > 0:
        if mcap >= 1e12:
            mcap_str = f'\${mcap/1e12:.2f}T'
        elif mcap >= 1e9:
            mcap_str = f'\${mcap/1e9:.2f}B'
        elif mcap >= 1e6:
            mcap_str = f'\${mcap/1e6:.2f}M'
        else:
            mcap_str = f'\${mcap:,.0f}'
    else:
        mcap_str = 'N/A'

    print(f'{coin.upper():>15}  {price_str:>14}  {change_str:>12}  MCap: {mcap_str}')
"
echo ""
echo "Source: CoinGecko | $(date '+%Y-%m-%d %H:%M:%S')"
