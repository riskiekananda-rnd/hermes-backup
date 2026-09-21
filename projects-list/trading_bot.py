#!/usr/bin/env python3
"""
Trading Bot v1 - Auto Buy/Sell di target harga
Untuk modal kecil dengan risk management ketat.
"""
import json, ssl, time
from pathlib import Path
from urllib.request import Request, urlopen
from datetime import datetime

# ============ CONFIG ============
STATE_FILE = Path.home() / 'trading-monitor' / 'bot_state.json'
CONFIG_FILE = Path.home() / 'trading-monitor' / 'bot_config.json'

CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

def fetch_json(url, timeout=10):
    req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    return json.loads(urlopen(req, timeout=timeout, context=CTX).read())

def load_config():
    if CONFIG_FILE.exists():
        return json.loads(CONFIG_FILE.read_text())
    # Default config
    default = {
        "modal_total": 200000,
        "max_position_pct": 30,
        "stop_loss_pct": 5,
        "take_profit_pct": 10,
        "trading_pairs": [
            {"symbol": "BTCUSDT", "entry": 80000, "stop_loss": 76000, "take_profit": 88000},
            {"symbol": "ETHUSDT", "entry": 2500, "stop_loss": 2375, "take_profit": 2750},
            {"symbol": "SOLUSDT", "entry": 105, "stop_loss": 100, "take_profit": 115},
        ],
        "mode": "paper"  # paper = simulasi, live = real trading
    }
    CONFIG_FILE.write_text(json.dumps(default, indent=2))
    return default

def load_state():
    if STATE_FILE.exists():
        return json.loads(STATE_FILE.read_text())
    return {"positions": [], "trades": [], "balance": 200000}

def save_state(state):
    STATE_FILE.write_text(json.dumps(state, indent=2))

def get_current_price(symbol):
    """Get price from CoinGecko"""
    symbol_map = {
        'BTCUSDT': 'bitcoin', 'ETHUSDT': 'ethereum', 'SOLUSDT': 'solana',
        'BNBUSDT': 'binancecoin', 'XRPUSDT': 'ripple',
    }
    cg_id = symbol_map.get(symbol, symbol)
    url = f"https://api.coingecko.com/api/v3/simple/price?ids={cg_id}&vs_currencies=usd"
    data = fetch_json(url)
    return data.get(cg_id, {}).get('usd', 0)

# ============ TRADING LOGIC ============
def check_signals(config, state):
    """Check apakah ada sinyal buy/sell"""
    signals = []
    
    for pair in config['trading_pairs']:
        symbol = pair['symbol']
        try:
            price = get_current_price(symbol)
        except Exception as e:
            print(f"  ⚠️ Error get {symbol}: {e}")
            continue
        
        entry = pair['entry']
        sl = pair['stop_loss']
        tp = pair['take_profit']
        
        # Cek posisi yang sudah ada
        existing_pos = next((p for p in state['positions'] if p['symbol'] == symbol), None)
        
        if existing_pos:
            # Cek stop loss / take profit
            entry_price = existing_pos['entry_price']
            pnl_pct = ((price - entry_price) / entry_price) * 100
            
            if price <= sl:
                signals.append({
                    'action': 'SELL',
                    'reason': 'STOP LOSS',
                    'symbol': symbol,
                    'price': price,
                    'entry_price': entry_price,
                    'pnl_pct': pnl_pct
                })
            elif price >= tp:
                signals.append({
                    'action': 'SELL',
                    'reason': 'TAKE PROFIT',
                    'symbol': symbol,
                    'price': price,
                    'entry_price': entry_price,
                    'pnl_pct': pnl_pct
                })
        else:
            # Cek entry point
            if price <= entry * 1.02:  # Within 2% of entry
                signals.append({
                    'action': 'BUY',
                    'reason': 'ENTRY POINT',
                    'symbol': symbol,
                    'price': price,
                    'target_entry': entry
                })
    
    return signals

def execute_signal(signal, state, config):
    """Execute trading signal (paper atau live)"""
    now = datetime.now().isoformat()
    
    if signal['action'] == 'BUY':
        # Hitung position size
        max_position = config['modal_total'] * (config['max_position_pct'] / 100)
        amount_idr = min(max_position, state['balance'] * 0.3)  # Max 30% balance
        
        if amount_idr < 10000:  # Minimum 10rb
            return None
        
        position = {
            'symbol': signal['symbol'],
            'entry_price': signal['price'],
            'amount_idr': amount_idr,
            'amount_coin': amount_idr / signal['price'],
            'entry_time': now,
            'stop_loss': signal['price'] * (1 - config['stop_loss_pct'] / 100),
            'take_profit': signal['price'] * (1 + config['take_profit_pct'] / 100)
        }
        
        state['positions'].append(position)
        state['balance'] -= amount_idr
        
        trade = {
            'type': 'BUY',
            'symbol': signal['symbol'],
            'price': signal['price'],
            'amount_idr': amount_idr,
            'time': now
        }
        state['trades'].append(trade)
        
        return {
            'emoji': '🟢',
            'action': 'BUY',
            'symbol': signal['symbol'],
            'price': signal['price'],
            'amount': amount_idr,
            'balance': state['balance']
        }
    
    elif signal['action'] == 'SELL':
        # Cari posisi
        pos_idx = next((i for i, p in enumerate(state['positions']) if p['symbol'] == signal['symbol']), None)
        if pos_idx is None:
            return None
        
        pos = state['positions'][pos_idx]
        sell_value = pos['amount_coin'] * signal['price']
        pnl = sell_value - pos['amount_idr']
        pnl_pct = signal['pnl_pct']
        
        state['positions'].pop(pos_idx)
        state['balance'] += sell_value
        
        trade = {
            'type': 'SELL',
            'symbol': signal['symbol'],
            'price': signal['price'],
            'amount_idr': sell_value,
            'pnl': pnl,
            'pnl_pct': pnl_pct,
            'time': now
        }
        state['trades'].append(trade)
        
        emoji = '💰' if pnl >= 0 else '💸'
        return {
            'emoji': emoji,
            'action': 'SELL',
            'reason': signal['reason'],
            'symbol': signal['symbol'],
            'price': signal['price'],
            'pnl': pnl,
            'pnl_pct': pnl_pct,
            'balance': state['balance']
        }

# ============ DISPLAY ============
def display_status(config, state):
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"\n{'='*60}")
    print(f"🤖 TRADING BOT v1 - Status")
    print(f"⏰ {now} | Mode: {config['mode'].upper()}")
    print(f"{'='*60}\n")
    
    print(f"💰 Modal: Rp{config['modal_total']:,.0f}")
    print(f"💵 Balance: Rp{state['balance']:,.0f}")
    
    # Portfolio value
    total_value = state['balance']
    if state['positions']:
        print(f"\n📊 Posisi Aktif ({len(state['positions'])}):")
        for pos in state['positions']:
            try:
                current = get_current_price(pos['symbol'])
                value = pos['amount_coin'] * current
                pnl = value - pos['amount_idr']
                pnl_pct = ((current - pos['entry_price']) / pos['entry_price']) * 100
                total_value += value
                
                emoji = '🟢' if pnl >= 0 else '🔴'
                print(f"  {emoji} {pos['symbol']}")
                print(f"     Entry: ${pos['entry_price']:,.2f} → Now: ${current:,.2f}")
                print(f"     Amount: Rp{pos['amount_idr']:,.0f} ({pos['amount_coin']:.6f} coin)")
                print(f"     PnL: {emoji} Rp{pnl:,.0f} ({pnl_pct:+.2f}%)")
                print(f"     SL: ${pos['stop_loss']:,.2f} | TP: ${pos['take_profit']:,.2f}")
            except:
                print(f"  ⚠️ {pos['symbol']}: Error fetching price")
    else:
        print("\n📊 Tidak ada posisi aktif")
    
    # Total portfolio
    print(f"\n💎 Total Portfolio: Rp{total_value:,.0f}")
    print(f"   Return: {((total_value / config['modal_total']) - 1) * 100:+.2f}%")
    
    # Recent trades
    if state['trades']:
        print(f"\n📜 Trade Terakhir (5):")
        for t in state['trades'][-5:]:
            if t['type'] == 'BUY':
                print(f"  🟢 BUY {t['symbol']} @ ${t['price']:,.2f} | Rp{t['amount_idr']:,.0f}")
            else:
                emoji = '💰' if t.get('pnl', 0) >= 0 else '💸'
                print(f"  {emoji} SELL {t['symbol']} @ ${t['price']:,.2f} | PnL: Rp{t.get('pnl', 0):,.0f} ({t.get('pnl_pct', 0):+.2f}%)")
    
    print(f"\n{'='*60}")

# ============ MAIN ============
def run_once():
    """Run sekali"""
    config = load_config()
    state = load_state()
    
    display_status(config, state)
    
    print("\n🔍 Checking signals...")
    signals = check_signals(config, state)
    
    if not signals:
        print("  ❌ Tidak ada sinyal")
    else:
        for sig in signals:
            print(f"\n  📨 {sig['action']} {sig['symbol']} - {sig['reason']}")
            
            if config['mode'] == 'paper':
                result = execute_signal(sig, state, config)
                if result:
                    print(f"  {result['emoji']} PAPER TRADE EXECUTED!")
                    print(f"     Balance: Rp{result['balance']:,.0f}")
                    save_state(state)
            else:
                print(f"  ⚠️ LIVE MODE - Butuh API key untuk execute")
    
    return signals

def continuous_run(interval=60):
    """Run terus menerus"""
    print("🚀 Trading Bot v1 - Continuous Mode")
    print(f"   Interval: {interval}s | Press Ctrl+C to stop\n")
    
    while True:
        try:
            run_once()
            print(f"\n⏳ Next check in {interval}s...")
            time.sleep(interval)
        except KeyboardInterrupt:
            print("\n\n👋 Stopped.")
            break
        except Exception as e:
            print(f"\n❌ Error: {e}")
            time.sleep(5)

if __name__ == '__main__':
    import sys
    if '--continuous' in sys.argv or '-c' in sys.argv:
        continuous_run()
    elif '--reset' in sys.argv:
        save_state({"positions": [], "trades": [], "balance": 200000})
        print("✅ State reset!")
    else:
        run_once()
