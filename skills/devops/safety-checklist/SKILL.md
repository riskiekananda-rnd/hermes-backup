---
name: safety-checklist
version: 1.0.0
description: "Safety checklist before destructive operations."
tags: [safety, checklist, backup, destructive]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Safety Checklist

Checklist wajib sebelum operasi destructive di Hermes.

## When to Use
- Sebelum delete file/folder
- Sebelum edit config penting (.env, config.yaml)
- Sebelum restart services
- Sebelum update/upgrade

## Pre-Destructive Checklist
- [ ] Backup config: `cp .env .env.bak`
- [ ] Check disk space: `df -h ~`
- [ ] Check running processes: `ps aux | grep -E 'tsx|node'`
- [ ] Verify state.db integrity: `sqlite3 ~/.hermes/state.db "PRAGMA integrity_check;"`
- [ ] Document what will be changed

## Post-Destructive Checklist
- [ ] Verify changes applied correctly
- [ ] Test services still running
- [ ] Check for errors in logs: `tail -20 ~/.hermes/logs/errors.log`
- [ ] Update error-ledger-protocol if something went wrong

## Quick Commands
```bash
# Backup before change
cp .env .env.bak
cp config.yaml config.yaml.bak

# Verify after change
sqlite3 ~/.hermes/state.db "PRAGMA integrity_check;"
curl -s http://localhost:3001/v1/models | head -5

# Rollback if needed
cp .env.bak .env
cp config.yaml.bak config.yaml
```

## Common Mistakes to Avoid
1. Editing .env while service running
2. Editing state.db while Hermes running
3. Restarting multiple services at once
4. Not testing after changes
5. Not documenting what was changed

## Verification
```bash
echo "Checklist complete: $(date '+%Y-%m-%d %H:%M')"
```
