---
name: error-ledger-protocol
version: 3.0.0
description: "Track every error: log, root cause, fix, prevent."
tags: [error-tracking, debugging, root-cause, prevention]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Error Ledger Protocol

Setiap error WAJIB di-fix + simpan solusi permanen.

## When to Use
- Setelah error terjadi
- Debugging session
- Post-mortem analysis
- Preventing recurrence

## Prerequisites
- None (pure documentation)

## Flow
```
ERROR → Error Ledger → PESELALU → 5 Whys → Fix → Verify → Log
```

## PESELALU (Decomposition)
- **Pe**cah error jadi bagian kecil
- **Se**lesaikan satu per satu
- **La**yani user sementara debug
- **U**ji setiap fix

## 5 Whys Analysis
```
1. Kenapa error? → [immediate cause]
2. Kenapa itu terjadi? → [deeper cause]
3. Kenapa lebih dalam? → [systemic cause]
4. Kenapa sistem gagal? → [root cause]
5. Kenapa root cause tidak dicegah? → [prevention gap]
```

## Error Ledger Format
```markdown
### [DATE] Error: [short description]
- **Symptom:** What happened
- **Root Cause:** Why it happened (5 whys result)
- **Fix:** What was done
- **Verification:** How fix was verified
- **Prevention:** How to prevent recurrence
- **Related:** Links to similar errors
```

## Known Errors (from KimerBot crash)

### 1. .env Overwrite (2026-09-20)
- **Symptom:** FreeLLMAPI config lost, server crashed
- **Root Cause:** `cat > .env << 'EOF'` overwrote running config
- **Fix:** Restored from git clone
- **Prevention:** NEVER use cat redirect on .env. Always `cp .env .env.bak` first

### 2. state.db Corruption (2026-09-20)
- **Symptom:** Hermes gateway crash, sessions lost
- **Root Cause:** Force-edited state.db while gateway was running
- **Fix:** Fresh install
- **Prevention:** NEVER edit state.db manually. Use hermes CLI commands

### 3. Cascade Failure (2026-09-20)
- **Symptom:** All projects and folders deleted
- **Root Cause:** Bot attempted reinstall while both services running
- **Fix:** Manual recovery from backup
- **Prevention:** One service at a time. Verify backup before any destructive action

## Prevention Checklist
- [ ] Backup before config changes
- [ ] Check service status before edits
- [ ] Use hermes config set instead of manual edits
- [ ] Test in isolation first
- [ ] Monitor with auto-optimize cron job

## Verification
```bash
echo "Error ledger updated: $(date '+%Y-%m-%d %H:%M')"
```