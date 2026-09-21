---
name: termux-recovery
version: 2.0.0
description: "Recover from Termux crashes: backup, restore, prevent."
tags: [termux, backup, restore, recovery, crash-prevention]
platforms: [linux]
author: Hermes Agent
license: MIT
---

# Termux Recovery

Backup, restore, and crash prevention for Termux/Android.

## When to Use
- After a Hermes or FreeLLMAPI crash
- Before making config changes
- When files go missing
- During system maintenance

## Prerequisites
- `tar` (built-in)
- `sqlite3` (for state.db checks)
- `curl` (for API health checks)

## Quick Reference
```bash
# Backup
tar -czf ~/storage/shared/Download/hermes_$(date +%Y%m%d).tar.gz ~/.hermes/config.yaml ~/.hermes/.env ~/.hermes/memories/

# Restore
cd ~/ && tar -xzf ~/storage/shared/Download/hermes_*.tar.gz

# Check state.db integrity
sqlite3 ~/.hermes/state.db "PRAGMA integrity_check;"
```

## Prevention Rules
1. **NEVER** edit `.env` while service running
2. **NEVER** edit `state.db` while Hermes running
3. **ALWAYS** backup before config changes
4. **NEVER** restart FreeLLMAPI + Hermes simultaneously

## Common Crash Patterns
1. state.db corrupts → PRAGMA integrity_check → restore
2. .env overwritten → cat redirect kills config → restore
3. Battery dies mid-write → partial files → checksum
4. Storage full → `df -h ~` → cleanup
5. Node zombie → runaway-sentinel → kill + restart

## Verification
- `curl http://localhost:3001/v1/models` — FreeLLMAPI alive
- `sqlite3 ~/.hermes/state.db "PRAGMA integrity_check;"` — returns 'ok'
- `ls ~/.hermes/skills/` — skills intact