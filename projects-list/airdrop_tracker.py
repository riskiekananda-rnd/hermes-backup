#!/usr/bin/env python3
"""
Airdrop Tracker - Monitor airdrop potensial
Cari airdrop yang belum claim atau yang akan datang.
"""
import json, ssl
from urllib.request import Request, urlopen
from datetime import datetime

CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

def fetch_json(url, timeout=10):
    req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    return json.loads(urlopen(req, timeout=timeout, context=CTX).read())

# ============ SOURCES ============
def check_defillama_airdrops():
    """Check airdrop dari DefiLlama"""
    try:
        data = fetch_json('https://api.llama.fi/protocols')
        airdrops = []
        for p in data:
            if p.get('airdrop'):
                airdrops.append({
                    'name': p['name'],
                    'symbol': p.get('symbol', 'N/A'),
                    'category': p.get('category', 'N/A'),
                    'tvl': p.get('tvl', 0),
                    'source': 'DefiLlama'
                })
        return airdrops
    except Exception as e:
        return [{'error': str(e)}]

def check_coingecko_trending():
    """Check trending coins (potensi airdrop)"""
    try:
        url = 'https://api.coingecko.com/api/v3/search/trending'
        data = fetch_json(url)
        trending = []
        for coin in data.get('coins', [])[:10]:
            item = coin.get('item', {})
            trending.append({
                'name': item.get('name'),
                'symbol': item.get('symbol'),
                'market_cap_rank': item.get('market_cap_rank'),
                'score': item.get('score'),
                'source': 'CoinGecko Trending'
            })
        return trending
    except Exception as e:
        return [{'error': str(e)}]

def check_new_listings():
    """Check new coin listings"""
    try:
        url = 'https://api.coingecko.com/api/v3/coins/list'
        data = fetch_json(url)
        # This gives all coins, we'd need to filter by recent additions
        # For now, just return count
        return [{'total_coins': len(data), 'note': 'Use trending for recent additions'}]
    except Exception as e:
        return [{'error': str(e)}]

# ============ KNOWN AIRDROPS ============
KNOWN_AIRDROPS = [
    {
        'name': 'LayerZero',
        'symbol': 'ZRO',
        'status': 'Claimed',
        'check_url': 'https://layerzero.network',
        'notes': 'Bridge users mungkin eligible'
    },
    {
        'name': 'zkSync',
        'symbol': 'ZK',
        'status': 'Active',
        'check_url': 'https://zksync.io',
        'notes': 'Check eligibility di zkSync.io'
    },
    {
        'name': 'Starknet',
        'symbol': 'STRK',
        'status': 'Active',
        'check_url': 'https://starknet.io',
        'notes': 'Ethereum L2, bridge users'
    },
    {
        'name': 'Scroll',
        'symbol': 'TBD',
        'status': 'Rumored',
        'check_url': 'https://scroll.io',
        'notes': 'Belum launch token'
    },
    {
        'name': 'Linea',
        'symbol': 'TBD',
        'status': 'Rumored',
        'check_url': 'https://linea.build',
        'notes': 'ConsenSys L2, belum launch'
    },
    {
        'name': 'Base',
        'symbol': 'TBD',
        'status': 'Rumored',
        'check_url': 'https://base.org',
        'notes': 'Coinbase L2, belum launch token'
    },
]

# ============ DISPLAY ============
def display_airdrops():
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"\n{'='*60}")
    print(f"🪂 AIRDROP TRACKER")
    print(f"⏰ {now}")
    print(f"{'='*60}\n")
    
    # Known airdrops
    print("📋 KNOWN AIRDROPS:")
    print("─" * 60)
    for a in KNOWN_AIRDROPS:
        status_emoji = {
            'Active': '🟢',
            'Claimed': '✅',
            'Rumored': '🟡',
            'Ended': '🔴'
        }.get(a['status'], '⚪')
        
        print(f"\n{status_emoji} {a['name']} ({a['symbol']})")
        print(f"   Status: {a['status']}")
        print(f"   Check: {a['check_url']}")
        print(f"   Notes: {a['notes']}")
    
    print(f"\n{'─' * 60}\n")
    
    # Trending
    print("🔥 TRENDING (Potential Airdrops):")
    print("─" * 60)
    trending = check_coingecko_trending()
    for t in trending:
        if 'error' in t:
            print(f"  ⚠️ Error: {t['error']}")
        else:
            rank = t.get('market_cap_rank', '?')
            print(f"  • {t['name']} ({t['symbol']}) - Rank #{rank}")
    
    print(f"\n{'─' * 60}\n")
    
    # DefiLlama airdrops
    print("📊 DeFi PROTOCOLS (Check for Airdrops):")
    print("─" * 60)
    airdrops = check_defillama_airdrops()
    for a in airdrops[:10]:
        if 'error' in a:
            print(f"  ⚠️ Error: {a['error']}")
        else:
            tvl = a.get('tvl', 0)
            if tvl > 1000000:
                print(f"  • {a['name']} ({a['symbol']}) - TVL: ${tvl/1e6:.1f}M")
    
    print(f"\n{'=' * 60}")
    print("💡 TIPS:")
    print("  • Selalu check eligibility di website resmi")
    print("  • Jangan pernah kasih private key!")
    print("  • Gas fee untuk claim biasanya $1-5")
    print("  • Backup wallet sebelum claim")
    print(f"{'=' * 60}")

# ============ MAIN ============
def scan_airdrops():
    """Scan semua airdrop sources"""
    display_airdrops()

if __name__ == '__main__':
    scan_airdrops()
