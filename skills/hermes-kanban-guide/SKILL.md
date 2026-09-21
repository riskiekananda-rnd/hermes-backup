---
name: hermes-kanban-guide
version: 1.0.0
description: "Guide to Hermes kanban multi-agent work queue."
tags: [kanban, multi-agent, workflow, tasks]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Hermes Kanban Guide

Panduan untuk menggunakan Hermes kanban multi-agent work queue.

## When to Use
- Mengelola task dalam proyek
- Koordinasi multiple agents
- Tracking progress dan status

## Quick Reference
```bash
# Initialize kanban board
hermes kanban init

# Create a task
hermes kanban create "Task title" --body "Description"

# List tasks
hermes kanban list

# Show task details
hermes kanban show <task-id>

# Assign task
hermes kanban assign <task-id> <agent-name>

# Complete task
hermes kanban complete <task-id>

# Block task
hermes kanban block <task-id> --reason "Waiting for input"

# Add comment
hermes kanban comment <task-id> "Progress update"
```

## Task States
- **Open** — Not started
- **In Progress** — Being worked on
- **Blocked** — Waiting for something
- **Review** — Needs review
- **Done** — Completed

## Task Fields
```yaml
title: Task title
description: Detailed description
assignee: agent-name
status: open | in_progress | blocked | review | done
priority: 0-5
skills: [skill-name1, skill-name2]
model: model-override
```

## Multi-Agent Workflow
1. **Create tasks** — Define what needs to be done
2. **Assign agents** — Match tasks to capabilities
3. **Track progress** — Monitor status updates
4. **Review completion** — Verify quality

## Best Practices
1. **Keep tasks small** — One task = one deliverable
2. **Clear descriptions** — Avoid ambiguity
3. **Set priorities** — Focus on important work
4. **Use comments** — Document progress
5. **Link related tasks** — Show dependencies

## Verification
```bash
hermes kanban list
hermes kanban stats
```