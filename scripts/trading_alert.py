#!/usr/bin/env python3
"""Trading alert checker - uses CoinGecko API. Silent when no alerts triggered."""
import json, sys, time, ssl
from pathlib import Path
from urllib.request import Request, urlopen

ALERTS_FILE = Path.home() / 'trading-monitor' / 'alerts.json'
STATE_FILE = Path.home() / 'trading-monitor' / 'alert_state.json'

SYMBOL_MAP = {
    'BTCUSDT': 'bitcoin', 'ETHUSDT': 'ethereum', 'SOLUSDT': 'solana',
    'BNBUSDT': 'binancecoin', 'XRPUSDT': 'ripple', 'DOGEUSDT': 'dogecoin',
    'ADAUSDT': 'cardano', 'AVAXUSDT': 'avalanche-2', 'DOTUSDT': 'polkadot',
    'LINKUSDT': 'chainlink',
}

def fetch_prices(symbols):
    coingecko_ids = list(set(SYMBOL_MAP.get(s, s) for s in symbols))
    url = f"https://api.coingecko.com/api/v3/simple/price?ids={','.join(coingecko_ids)}&vs_currencies=usd"
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    data = json.loads(urlopen(req, timeout=15, context=ctx).read())
    prices = {}
    for sym in symbols:
        cg_id = SYMBOL_MAP.get(sym, sym)
        if cg_id in data:
            prices[sym] = data[cg_id]['usd']
    return prices

def check_alerts():
    if not ALERTS_FILE.exists():
        return []
    
    alerts = json.loads(ALERTS_FILE.read_text())
    state = json.loads(STATE_FILE.read_text()) if STATE_FILE.exists() else {}
    triggered = []
    now = time.time()
    
    all_symbols = list(set(a['symbol'] for a in alerts))
    try:
        prices = fetch_prices(all_symbols)
    except Exception as e:
        print(f"⚠️ Error fetching prices: {e}")
        return []
    
    for alert in alerts:
        symbol = alert['symbol']
        direction = alert['direction']
        threshold = alert['threshold']
        name = alert.get('name', symbol)
        cooldown = alert.get('cooldown', 3600)
        
        if symbol not in prices:
            continue
        
        price = prices[symbol]
        state_key = f"{symbol}_{direction}_{threshold}"
        last = state.get(state_key, 0)
        
        hit = (direction == 'above' and price >= threshold) or \
              (direction == 'below' and price <= threshold)
        
        if hit and (now - last) > cooldown:
            triggered.append({
                'name': name, 'symbol': symbol,
                'price': price, 'threshold': threshold,
                'direction': direction
            })
            state[state_key] = now
    
    STATE_FILE.write_text(json.dumps(state, indent=2))
    
    # Only output if triggered - silent otherwise (watchdog pattern)
    if triggered:
        lines = ["🚨 *Trading Alert*\n"]
        for t in triggered:
            arrow = '📈' if t['direction'] == 'above' else '📉'
            lines.append(f"{arrow} *{t['name']}*: ${t['price']:,.2f}")
            lines.append(f"   Crossed {t['direction']} ${t['threshold']:,.2f}\n")
        
        # Add current prices summary
        lines.append("📊 *Harga saat ini:*")
        price_order = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'BNBUSDT', 'XRPUSDT']
        for sym in price_order:
            if sym in prices:
                lines.append(f"• {sym.replace('USDT','')}: ${prices[sym]:,.2f}")
        
        print('\n'.join(lines))
    
    return triggered

if __name__ == '__main__':
    check_alerts()
