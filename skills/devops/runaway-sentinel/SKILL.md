---
name: runaway-sentinel
version: 3.0.0
description: "Detect and kill zombie/busy-loop processes."
tags: [cpu, ram, zombie, sentinel, monitor]
platforms: [linux]
author: Hermes Agent
license: MIT
---

# Runaway Sentinel

Deteksi + bunuh proses shell busy-loop yang makan CPU/RAM berlebihan.

## When to Use
- High CPU usage detected
- System unresponsive
- Process consuming too much memory
- Battery draining fast

## Prerequisites
- `ps` (built-in)
- `kill` (built-in)
- `uptime` (built-in)

## Quick Scan
```bash
# Top CPU consumers
ps aux --sort=-%cpu | head -10

# Top RAM consumers
ps aux --sort=-%mem | head -10

# System overview
uptime

# Load average check (Termux = 8 cores)
awk '{if ($1 > 8) print "⚠️ Overloaded! Load: " $1}' /proc/loadavg 2>/dev/null
```

## Kill Protocol
```bash
# Graceful
kill <PID>

# Wait 5 seconds, then force if still alive
sleep 5 && kill -0 <PID> 2>/dev/null && kill -9 <PID>
```

## Auto-Detection Thresholds
| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| CPU % | > 60% | > 90% for 5 min | kill -9 |
| RAM % | > 80% | > 90% | find & kill biggest |
| Load avg | > 8 | > 16 | kill non-essential |
| Swap | > 50% | > 80% | kill + alert |
| Battery temp | > 40°C | > 45°C | reduce workload |

## Common Runaway Patterns
1. **npm/node loop:** `pkill -f 'tsx watch'` then restart
2. **Python infinite loop:** check with `strace -p <PID>` then `kill -9`
3. **PDF processing stuck:** `pkill -f 'pdfplumber'` or `pkill -f 'pdf2image'`
4. **Browser automation hung:** `pkill -f 'chromium'` or `pkill -f 'playwright'`

## Prevention
- Set timeouts on all background processes
- Use `timeout 300` for long-running tasks
- Monitor with auto-optimize cron job
- Never run `npm install` without `--no-audit --no-fund`

## Verification
```bash
ps aux --sort=-%cpu | head -5
uptime
```