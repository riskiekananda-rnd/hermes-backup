---
name: hermes-curator-guide
version: 1.0.0
description: "Guide to Hermes skill curator lifecycle management."
tags: [curator, skills, lifecycle, automation]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Hermes Curator Guide

Panduan untuk memahami dan menggunakan Hermes skill curator.

## When to Use
- Ingin memahami bagaimana skill di-automate
- Ingin mengelola skill lifecycle
- Ingin mengatur curator settings

## Quick Reference
```bash
# Check curator status
hermes curator status

# Run curator manually
hermes curator run

# Dry run (preview only)
hermes curator run --dry-run

# Pause curator
hermes curator pause

# Resume curator
hermes curator resume

# Pin a skill (prevent archiving)
hermes curator pin <skill-name>

# Unpin a skill
hermes curator unpin <skill-name>

# Archive a skill
hermes curator archive <skill-name>

# Restore a skill
hermes curator restore <skill-name>
```

## How Curator Works
1. **Activity tracking** — Skill usage is tracked in `.usage.json`
2. **Inactivity detection** — Skills unused for `stale_after_days` are marked stale
3. **Auto-archiving** — Skills unused for `archive_after_days` are archived
4. **LLM consolidation** — Optional: AI can merge/consolidate similar skills

## Default Settings
```yaml
curator:
  enabled: true
  interval_hours: 168  # 7 days
  min_idle_hours: 2
  stale_after_days: 14
  archive_after_days: 30
  consolidate: false  # LLM consolidation (opt-in)
```

## Curator States
- **Active** — Skill is in use, no action needed
- **Stale** — Skill hasn't been used in 14 days
- **Archived** — Skill hasn't been used in 30 days (recoverable)

## Pinned Skills
- Bundled skills (from hermes-agent repo) are never archived
- Cron-referenced skills are treated as pinned
- Manually pinned skills bypass all auto-transitions

## Archive Location
```bash
~/.hermes/skills/.archive/  # Archived skills
```

## Best Practices
1. **Pin important skills** — Prevent accidental archiving
2. **Review stale skills** — Decide to keep or archive
3. **Use consolidate wisely** — LLM can merge similar skills
4. **Monitor usage** — Check `.usage.json` for insights

## Verification
```bash
hermes curator status
cat ~/.hermes/skills/.usage.json | python3 -m json.tool | head -20
```