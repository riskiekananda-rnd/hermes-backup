---
name: termux-battery-optimization
version: 1.0.0
description: "Optimize battery usage for Termux services."
tags: [battery, optimization, power, termux]
platforms: [linux]
author: Hermes Agent
license: MIT
---

# Termux Battery Optimization

Optimasi penggunaan baterai untuk services di Termux.

## When to Use
- Battery draining fast
- Services running in background
- Optimizing for all-day usage

## Quick Reference
```bash
# Check battery status
termux-battery-status 2>/dev/null | python3 -m json.tool

# Check wakelock
termux-wake-lock -l 2>/dev/null

# Remove wakelock
termux-wake-unlock 2>/dev/null

# Check running services
ps aux | grep -E 'tsx|node|python' | grep -v grep
```

## Power Saving Tips
1. **Reduce polling frequency** — Check every 5 min instead of every 1 min
2. **Use wake locks wisely** — Only when needed
3. **Kill idle processes** — runaway-sentinel skill
4. **Dim screen** — Lower brightness
5. **Disable WiFi** — When not needed

## Service Optimization
```bash
# Check service CPU usage
top -bn1 | grep -E 'tsx|node|python' | head -5

# Reduce FreeLLMAPI polling
# Edit ~/.hermes/config.yaml
# cron:
#   interval_minutes: 5  # instead of 1
```

## Battery Monitor Script
```bash
#!/bin/bash
BATTERY=$(termux-battery-status 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['percentage'])" 2>/dev/null)
TEMP=$(termux-battery-status 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('temperature', 'N/A'))" 2>/dev/null)
STATUS=$(termux-battery-status 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['status'])" 2>/dev/null)

echo "Battery: ${BATTERY}% | Temp: ${TEMP}°C | Status: ${STATUS}"

if [ ${BATTERY:-100} -lt 20 ]; then
    echo "⚠️ Low battery! Consider reducing workload."
fi
```

## Verification
```bash
termux-battery-status 2>/dev/null | python3 -m json.tool
```