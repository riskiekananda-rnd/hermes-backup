---
name: trading-monitor
version: 2.0.0
description: "Monitor crypto prices and alerts across exchanges."
tags: [crypto, trading, monitor, alert, price, exchange]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
metadata:
  hermes:
    category: research
    requires_toolsets: [terminal]
    related_skills: [crypto-trading, cryptocurrency-arbitrage, watchers]
---

# Trading Monitor v2

Real-time crypto price monitoring, threshold alerts, arbitrage scanning, and trading bot.

## When to Use
- User wants to check current crypto prices
- User wants alerts when price crosses a threshold
- User wants to scan arbitrage opportunities
- User wants automated trading bot
- User wants to track portfolio value

## Tools Overview

| Tool | File | Purpose |
|------|------|---------|
| Alert Checker | `~/trading-monitor/alert_checker.py` | Price threshold alerts |
| Eye Bot v2 | `~/trading-monitor/eye_bot.py` | Arbitrage scanner |
| Trading Bot | `~/trading-monitor/trading_bot.py` | Auto buy/sell |
| Airdrop Tracker | `~/trading-monitor/airdrop_tracker.py` | Monitor airdrops |

## Quick Commands

```bash
# Check alerts
python3 ~/trading-monitor/alert_checker.py

# Scan arbitrage
python3 ~/trading-monitor/eye_bot.py

# Trading bot status
python3 ~/trading-monitor/trading_bot.py

# Check airdrops
python3 ~/trading-monitor/airdrop_tracker.py
```

## Cron Jobs

- Trading Alert Monitor: every 15m → KimerGroup thread 68
- Eye Bot Scanner: every 30m → KimerGroup thread 68
- Trading Bot Monitor: every 15m → KimerGroup thread 68

## Configuration

- `~/trading-monitor/alerts.json` — price alert thresholds
- `~/trading-monitor/bot_config.json` — trading bot settings
- `~/trading-monitor/bot_state.json` — bot positions & trades

## Risk Management

- Default modal: Rp200,000
- Max position: 30% per trade
- Stop loss: -5%
- Take profit: +10%
- Paper mode by default (simulasi)

## Pitfalls

1. Binance/OKX/Bybit API blocked on some devices (use CoinGecko + Gate.io)
2. SSL issues on Android/Termux - need custom SSL context
3. Rate limits: CoinGecko 10-30 req/min
4. Arbitrage spreads usually <0.5% (market efficient)
5. Small capital = small profits, focus on learning

## Commands

```bash
# Run eye bot continuous
python3 ~/trading-monitor/eye_bot.py --continuous

# Run trading bot continuous
python3 ~/trading-monitor/trading_bot.py --continuous

# Reset trading bot state
python3 ~/trading-monitor/trading_bot.py --reset
```