#!/usr/bin/env python3
"""
Eye Bot v2 - Crypto Arbitrage Scanner
Uses CoinGecko + Gate.io (SSL compatible)
"""
import json, ssl, time
from urllib.request import Request, urlopen
from datetime import datetime

# ============ CONFIG ============
SCAN_INTERVAL = 60
MIN_SPREAD_PCT = 0.5
ALERT_FILE = '/data/data/com.termux/files/home/trading-monitor/arbitrage_alerts.json'

CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

def fetch_json(url, timeout=10):
    req = Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
    return json.loads(urlopen(req, timeout=timeout, context=CTX).read())

# ============ EXCHANGE API ============
def get_coingecko():
    """CoinGecko top coins"""
    url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100'
    data = fetch_json(url)
    return {c['symbol'].upper() + 'USDT': c['current_price'] for c in data if c.get('current_price')}

def get_gate():
    """Gate.io USDT pairs"""
    data = fetch_json('https://api.gateio.ws/api/v4/spot/tickers')
    result = {}
    for d in data:
        sym = d['currency_pair'].replace('_', '')
        if 'USDT' in sym and float(d.get('quote_volume', 0)) > 100000:
            result[sym] = float(d['last'])
    return result

# ============ ARBITRAGE LOGIC ============
def find_arbitrage(prices_a, prices_b, name_a, name_b):
    """Cari spread antara 2 exchange"""
    opportunities = []
    common_symbols = set(prices_a.keys()) & set(prices_b.keys())
    
    for sym in common_symbols:
        price_a = prices_a[sym]
        price_b = prices_b[sym]
        
        if price_a < price_b:
            buy_ex, buy_price = name_a, price_a
            sell_ex, sell_price = name_b, price_b
        else:
            buy_ex, buy_price = name_b, price_b
            sell_ex, sell_price = name_a, price_a
        
        spread_pct = ((sell_price - buy_price) / buy_price) * 100
        
        # Fees: Gate 0.2%, CoinGecko reference (no fee)
        total_fee = 0.2  # Gate fee
        net_spread = spread_pct - total_fee
        
        if net_spread >= MIN_SPREAD_PCT:
            opportunities.append({
                'symbol': sym,
                'buy_exchange': buy_ex,
                'buy_price': buy_price,
                'sell_exchange': sell_ex,
                'sell_price': sell_price,
                'spread_pct': spread_pct,
                'net_profit_pct': net_spread
            })
    
    return sorted(opportunities, key=lambda x: x['net_profit_pct'], reverse=True)

# ============ DISPLAY ============
def display_results(opportunities, coingecko, gate):
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"{'='*60}")
    print(f"🔍 EYE BOT v2 - Arbitrage Scanner")
    print(f"⏰ {now}")
    print(f"{'='*60}\n")
    
    # Market overview
    major = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'BNBUSDT', 'XRPUSDT']
    print("📊 Harga CoinGecko:")
    for sym in major:
        base = sym.replace('USDT', '')
        if base in coingecko:
            print(f"  {base:>6}: ${coingecko[base]:>12,.2f}")
    print()
    
    print(f"🏪 CoinGecko: {len(coingecko)} pairs | Gate.io: {len(gate)} pairs")
    print(f"{'─'*60}\n")
    
    if not opportunities:
        print("❌ Tidak ada peluang arbitrage saat ini")
        print(f"   (minimum spread: {MIN_SPREAD_PCT}% after fees)")
    else:
        print(f"✅ {len(opportunities)} PELUANG DITEMUKAN!\n")
        for i, opp in enumerate(opportunities[:10], 1):
            emoji = '🔥' if opp['net_profit_pct'] >= 2 else '💰' if opp['net_profit_pct'] >= 1 else '💵'
            print(f"{emoji} #{i} {opp['symbol']}")
            print(f"   Beli: {opp['buy_exchange']} @ ${opp['buy_price']:,.2f}")
            print(f"   Jual: {opp['sell_exchange']} @ ${opp['sell_price']:,.2f}")
            print(f"   Spread: {opp['spread_pct']:.2f}% | Net: {opp['net_profit_pct']:.2f}%")
            
            modal = 200000
            profit_idr = modal * (opp['net_profit_pct'] / 100)
            print(f"   💵 Estimasi profit (200rb): Rp{profit_idr:,.0f}")
            print()
    
    print(f"{'='*60}")

# ============ MAIN ============
def scan_once():
    print("⏳ Scanning...")
    
    try:
        print("  📡 Fetching CoinGecko...")
        coingecko = get_coingecko()
        print(f"  ✓ CoinGecko: {len(coingecko)} pairs")
    except Exception as e:
        print(f"  ✗ CoinGecko: {e}")
        coingecko = {}
    
    try:
        print("  📡 Fetching Gate.io...")
        gate = get_gate()
        print(f"  ✓ Gate.io: {len(gate)} pairs")
    except Exception as e:
        print(f"  ✗ Gate.io: {e}")
        gate = {}
    
    if not coingecko and not gate:
        print("\n⚠️ Tidak ada exchange yang aktif!")
        return []
    
    # Find arbitrage
    opportunities = find_arbitrage(coingecko, gate, 'CoinGecko', 'Gate.io')
    
    display_results(opportunities, coingecko, gate)
    
    if opportunities:
        try:
            existing = []
            try:
                with open(ALERT_FILE, 'r') as f:
                    existing = json.load(f)
            except:
                pass
            existing = opportunities[:50] + existing[:50]
            with open(ALERT_FILE, 'w') as f:
                json.dump(existing[:100], f, indent=2)
        except:
            pass
    
    return opportunities

def continuous_scan():
    print("🚀 Eye Bot v2 - Continuous Mode")
    print(f"   Interval: {SCAN_INTERVAL}s | Min Spread: {MIN_SPREAD_PCT}%")
    print(f"   Tekan Ctrl+C untuk stop\n")
    
    scan_count = 0
    while True:
        try:
            scan_count += 1
            print(f"\n🔄 Scan #{scan_count}")
            scan_once()
            print(f"\n⏳ Next scan in {SCAN_INTERVAL}s...")
            time.sleep(SCAN_INTERVAL)
        except KeyboardInterrupt:
            print("\n\n👋 Stopped.")
            break
        except Exception as e:
            print(f"\n❌ Error: {e}")
            time.sleep(5)

if __name__ == '__main__':
    import sys
    if '--continuous' in sys.argv or '-c' in sys.argv:
        continuous_scan()
    else:
        scan_once()
