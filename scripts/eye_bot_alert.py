#!/usr/bin/env python3
"""Eye Bot alert - only output when arbitrage found (silent otherwise)."""
import sys
sys.path.insert(0, '/data/data/com.termux/files/home/trading-monitor')
from eye_bot import scan_once

opportunities = scan_once()
if opportunities:
    print(f"\n🔍 *Eye Bot Alert* - {len(opportunities)} peluang arbitrage!")
    for i, opp in enumerate(opportunities[:3], 1):
        print(f"#{i} {opp['symbol']}: {opp['buy_exchange']}→{opp['sell_exchange']} | Net: {opp['net_profit_pct']:.2f}%")
