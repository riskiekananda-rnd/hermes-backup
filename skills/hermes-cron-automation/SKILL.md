---
name: hermes-cron-automation
version: 1.0.0
description: "Guide to Hermes cron jobs and automation."
tags: [cron, automation, scheduling, jobs]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Hermes Cron Automation

Panduan untuk menggunakan Hermes cron jobs dan automation.

## When to Use
- Ingin menjalankan task secara berkala
- Ingin mengotomatiskan maintenance
- Ingin schedule alerting

## Quick Reference
```bash
# List all cron jobs
hermes cron list

# Create a cron job
hermes cron add "every 6h" "Check system health"

# Run a job immediately
hermes cron run <job-id>

# Pause a job
hermes cron pause <job-id>

# Resume a job
hermes cron resume <job-id>

# Remove a job
hermes cron remove <job-id>
```

## Schedule Formats
- `30m` — Every 30 minutes
- `2h` — Every 2 hours
- `1d` — Every day
- `every monday 9am` — Weekly
- `0 9 * * *` — Cron syntax (daily 9am)
- `2026-06-01T09:00:00` — One-shot

## Job Fields
```yaml
name: job-name
schedule: every 6h
prompt: "Check system health and report"
skills: [auto-optimize]
script: health_check.sh  # Pre-run script
deliver: local  # or 'origin', 'all', 'telegram:chat_id'
no_agent: false  # true = script-only, no LLM
```

## Common Automation Patterns
```bash
# Health check every 6h
hermes cron add "every 6h" "Run health check" --script health_check.sh

# Backup daily at 3am
hermes cron add "every day at 3am" "Backup configs" --script daily_backup.sh

# Monitor FreeLLMAPI every hour
hermes cron add "every 1h" "Check FreeLLMAPI status" --script monitor.sh
```

## Script Integration
```bash
#!/bin/bash
# health_check.sh
echo "=== Health Check ==="
echo "Disk: $(df -h ~ | tail -1 | awk '{print $5}') used"
echo "Load: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')"
```

## Best Practices
1. **Use scripts for data collection** — Keep prompts simple
2. **Set deliver targets** — Where to send results
3. **Use no_agent for simple tasks** — Script-only mode
4. **Monitor job history** — Check `hermes cron list` for errors

## Verification
```bash
hermes cron list
```