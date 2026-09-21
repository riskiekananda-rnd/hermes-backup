---
name: hermes-memory-optimization
version: 1.0.0
description: "Optimize Hermes memory usage and context window."
tags: [memory, optimization, context, compression]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Hermes Memory Optimization

Optimasi penggunaan memory dan context window di Hermes.

## When to Use
- Memory usage tinggi
- Context window hampir penuh
- Performance lambat
- Ingin efisiensi token

## Quick Reference
```bash
# Check memory usage
cat ~/.hermes/memories/MEMORY.md | wc -c

# Check session tokens
sqlite3 ~/.hermes/state.db "SELECT session_id, total_tokens FROM sessions ORDER BY total_tokens DESC LIMIT 5;"

# Compress context
# Di Telegram: /compress
# Di CLI: hermes compress
```

## Memory Best Practices
1. **Keep entries compact** — High-signal, low-volume
2. **Use skills for procedures** — Not memory
3. **Remove stale facts** — Memory is for durable facts only
4. **Consolidate related entries** — Merge similar info

## Context Window Optimization
```bash
# Check context length
cat ~/.hermes/memories/MEMORY.md | wc -l

# Check user profile
cat ~/.hermes/memories/USER.md | wc -l

# Optimal sizes:
# MEMORY.md: < 2000 chars
# USER.md: < 1000 chars
# SOUL.md: < 500 chars
```

## Memory Cleanup Script
```bash
#!/bin/bash
echo "=== Memory Cleanup ==="

# Check sizes
MEMORY_SIZE=$(wc -c < ~/.hermes/memories/MEMORY.md 2>/dev/null || echo 0)
USER_SIZE=$(wc -c < ~/.hermes/memories/USER.md 2>/dev/null || echo 0)
SOUL_SIZE=$(wc -c < ~/.hermes/soul.md 2>/dev/null || echo 0)

echo "MEMORY.md: $MEMORY_SIZE chars"
echo "USER.md: $USER_SIZE chars"
echo "SOUL.md: $SOUL_SIZE chars"

if [ $MEMORY_SIZE -gt 2000 ]; then
    echo "⚠️ MEMORY.md is too large! Consider cleanup."
fi

if [ $USER_SIZE -gt 1000 ]; then
    echo "⚠️ USER.md is too large! Consider cleanup."
fi
```

## Token Efficiency
- **Skills** — Load on-demand, not in system prompt
- **Memory** — Durable facts only, not procedures
- **Context files** — Load at startup, capped
- **Compression** — Use `/compress` when context full

## Common Issues
1. **Memory full** — Remove stale entries, consolidate
2. **Context overflow** — Use /compress
3. **Slow responses** — Reduce memory, use smaller model
4. **Token waste** — Move procedures to skills

## Verification
```bash
echo "Memory: $(wc -c < ~/.hermes/memories/MEMORY.md) chars"
echo "User: $(wc -c < ~/.hermes/memories/USER.md) chars"
```