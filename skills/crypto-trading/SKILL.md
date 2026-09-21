---
name: crypto-trading
version: 2.0.0
description: "Crypto trading: prices, arbitrage, exchange APIs."
tags: [crypto, trading, arbitrage, exchange, defi]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Crypto Trading

Price checking, arbitrage scanning, and exchange API access.

## When to Use
- Checking crypto prices across exchanges
- Building arbitrage scanners (eye_bot.py)
- Monitoring market conditions
- Trading bot development

## Prerequisites
- `curl` (for API calls)
- `python3` (for data processing)
- Optional: `requests` library for advanced calls

## Quick Reference
```bash
# Binance price
curl -s 'https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT'

# Multiple prices
curl -s 'https://api.binance.com/api/v3/ticker/price' | python3 -c "import json,sys; [print(f'{d[\"symbol\"]}: {d[\"price\"]}') for d in json.load(sys.stdin) if 'USDT' in d['symbol"]][:20]"

# IDR rate
curl -s 'https://api.exchangerate-api.com/v4/latest/USDT' | python3 -c "import json,sys; print(f'1 USDT = {json.load(sys.stdin)[\"rates\"][\"IDR\"]} IDR')"
```

## Exchange APIs
| Exchange | API | Fee |
|----------|-----|-----|
| Binance | api.binance.com | 0.1% |
| Indodax | api.indodax.com | 0.3% |
| Tokocrypto | api.tokocrypto.com | 0.1% |
| OKX | www.okx.com/api | 0.1% |

## Arbitrage Concepts
1. **Price difference** between exchanges
2. **Spread** = sell price - buy price
3. **Net profit** = spread - fees - slippage
4. **Execution speed** = API latency + order fill

## Risk Management
- Stop-loss: -5% per trade
- Take-profit: +10-15%
- Diversify: 3-5 coins
- Never invest more than you can afford to lose

## Hermes Optional Skills
- `stocks` — Yahoo Finance data
- `evm` — On-chain wallet/token queries
- `solana` — Solana wallet data
- `hyperliquid` — Hyperliquid DEX

## Pitfalls
- Rate limits vary per exchange
- WebSocket feeds need reconnection logic
- Order book depth affects execution price
- Withdrawal fees can eat profits

## Verification
```bash
# Test Binance API
curl -s 'https://api.binance.com/api/v3/ping' && echo 'OK'

# Test price fetch
curl -s 'https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT' | python3 -m json.tool
```