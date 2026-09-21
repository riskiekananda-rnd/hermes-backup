#!/usr/bin/env python3
"""Trading Bot alert - only output when signal found."""
import sys
sys.path.insert(0, '/data/data/com.termux/files/home/trading-monitor')
from trading_bot import run_once, load_config, load_state, display_status

signals = run_once()
if signals:
    config = load_config()
    state = load_state()
    display_status(config, state)
