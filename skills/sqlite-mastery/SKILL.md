---
name: sqlite-mastery
version: 1.0.0
description: "SQLite mastery: queries, optimization, schema design."
tags: [sqlite, database, sql, optimization]
platforms: [linux, macos, windows]
author: Hermes Agent
license: MIT
---

# SQLite Mastery

SQLite queries, optimization, schema design, and debugging.

## When to Use
- Debugging database issues
- Optimizing slow queries
- Designing database schemas
- Migrating data between databases

## Quick Reference
```bash
# Basic operations
sqlite3 database.db "SELECT * FROM table;"
sqlite3 database.db ".schema"
sqlite3 database.db ".tables"

# Integrity check
sqlite3 database.db "PRAGMA integrity_check;"

# Backup
sqlite3 database.db ".backup backup.db"

# Performance
sqlite3 database.db "ANALYZE;"
sqlite3 database.db "VACUUM;"
```

## Schema Design
```sql
-- Create table with proper types
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Index for fast lookups
CREATE INDEX idx_users_email ON users(email);

-- Foreign key
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## Query Optimization
1. **Use indexes** — EXPLAIN QUERY PLAN shows usage
2. **Avoid SELECT *** — specify columns
3. **Use LIMIT** for large result sets
4. **Batch inserts** — use transactions
5. **WAL mode** — better concurrent reads

```sql
-- Enable WAL mode
PRAGMA journal_mode=WAL;

-- Check query plan
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email='test@test.com';
```

## Common Issues
1. **Database locked** — another process has write lock
2. **Corrupt database** — PRAGMA integrity_check
3. **Slow queries** — EXPLAIN + indexes
4. **Disk full** — VACUUM to reclaim space

## Python Integration
```python
import sqlite3

# Connect with context manager
with sqlite3.connect('database.db') as conn:
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users')
    for row in cursor.fetchall():
        print(dict(row))
```

## Pitfalls
- No concurrent writers (WAL helps)
- INTEGER PRIMARY KEY = rowid alias
- TEXT vs BLOB for binary data
- Date storage: TEXT ISO8601 or INTEGER unix

## Verification
```bash
sqlite3 database.db "PRAGMA integrity_check;" && echo 'OK'
```