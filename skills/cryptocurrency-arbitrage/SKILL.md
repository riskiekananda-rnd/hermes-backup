---
name: cryptocurrency-arbitrage
version: 1.0.0
description: "Crypto arbitrage scanner: multi-exchange price comparison."
tags: [crypto, arbitrage, trading, scanner]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Cryptocurrency Arbitrage Scanner

Scanner untuk mendeteksi arbitrage opportunities antar exchange.

## When to Use
- Membangun eye_bot.py
- Scanning price differences
- Monitoring market inefficiencies

## Quick Reference
```bash
# Check Binance prices
curl -s 'https://api.binance.com/api/v3/ticker/price' | python3 -c "import json,sys; [print(f'{d[\"symbol\"]}: {d[\"price\"]}') for d in json.load(sys.stdin) if 'USDT' in d['symbol"]][:10]"

# Check Indodax prices
curl -s 'https://indodax.com/api/ticker' | python3 -c "import json,sys; d=json.load(sys.stdin); [print(f'{k}: {v[\"last\"]}') for k,v in d.items()][:10]"
```

## Arbitrage Formula
```
Spread = (Sell Price - Buy Price) / Buy Price × 100%
Net Profit = Spread - Trading Fee - Withdrawal Fee

Example:
- Buy BTC on Binance: $60,000 (0.1% fee)
- Sell BTC on Indodax: $60,500 (0.3% fee)
- Spread: 0.83%
- Fees: 0.4%
- Net Profit: 0.43%
```

## Exchange APIs
| Exchange | Ticker Endpoint | Fee |
|----------|-----------------|-----|
| Binance | api.binance.com/api/v3/ticker/price | 0.1% |
| Indodax | indodax.com/api/ticker | 0.3% |
| Tokocrypto | api.tokocrypto.com/api/v1/ticker | 0.1% |
| OKX | www.okx.com/api/v5/market/tickers | 0.1% |

## Multi-Exchange Scanner
```python
import requests
import json

def get_binance_prices():
    url = 'https://api.binance.com/api/v3/ticker/price'
    data = requests.get(url).json()
    return {d['symbol']: float(d['price']) for d in data if 'USDT' in d['symbol']}

def get_indodax_prices():
    url = 'https://indodax.com/api/ticker'
    data = requests.get(url).json()
    return {k: float(v['last']) for k, v in data.items()}

# Compare prices
binance = get_binance_prices()
indodax = get_indodax_prices()

for symbol in binance:
    if symbol in indodax:
        spread = (indodax[symbol] - binance[symbol]) / binance[symbol] * 100
        if abs(spread) > 1:  # 1% threshold
            print(f'{symbol}: {spread:.2f}% spread')
```

## Risk Management
- Minimum spread: 1% (after fees)
- Maximum position: 10% of portfolio
- Stop loss: -5%
- Take profit: +10%

## Pitfalls
- Withdrawal fees can eat profits
- Transfer time affects execution
- Price volatility during transfer
- Minimum order sizes vary

## Verification
```bash
curl -s 'https://api.binance.com/api/v3/ping' && echo 'OK'
```