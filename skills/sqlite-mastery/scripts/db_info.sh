#!/usr/bin/env bash
# Get SQLite database info
# Usage: db_info.sh <database_path>
set -euo pipefail

DB="${1:-}"

if [[ -z "$DB" ]]; then
    echo "Usage: $0 <database.sqlite>"
    exit 1
fi

if [[ ! -f "$DB" ]]; then
    echo "ERROR: File not found: $DB"
    exit 1
fi

if ! command -v sqlite3 &>/dev/null; then
    echo "ERROR: sqlite3 not found. Install with: pkg install sqlite"
    exit 1
fi

echo "=== SQLite Database Info ==="
echo "Database: $DB"
echo "Size:     $(du -h "$DB" | cut -f1)"
echo "Modified: $(stat -c '%y' "$DB" 2>/dev/null || stat -f '%Sm' "$DB" 2>/dev/null || echo 'unknown')"
echo ""

# Database header info
echo "=== Header ==="
sqlite3 "$DB" "PRAGMA database_list;" | while read -r _ name file; do
    echo "  Attached DB: $name -> $file"
done
echo ""

# Schema version
SCHEMA_VER=$(sqlite3 "$DB" "PRAGMA schema_version;")
echo "Schema version: $SCHEMA_VER"

# Page info
PAGE_SIZE=$(sqlite3 "$DB" "PRAGMA page_size;")
PAGE_COUNT=$(sqlite3 "$DB" "PRAGMA page_count;")
echo "Page size: $PAGE_SIZE bytes"
echo "Page count: $PAGE_COUNT"
echo ""

# Tables
echo "=== Tables ==="
TABLES=$(sqlite3 "$DB" "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
if [[ -z "$TABLES" ]]; then
    echo "  (no tables found)"
else
    echo "$TABLES" | while read -r table; do
        ROW_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM \"$table\";" 2>/dev/null || echo "?")
        # Get column info
        COLS=$(sqlite3 "$DB" "PRAGMA table_info(\"$table\");" | awk -F'|' '{print $2}' | tr '\n' ', ' | sed 's/,$//')
        printf "  %-30s %8s rows  [%s]\n" "$table" "$ROW_COUNT" "$COLS"
    done
fi
echo ""

# Indexes
INDEX_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='index';" 2>/dev/null || echo 0)
echo "=== Indexes: $INDEX_COUNT ==="

# Foreign keys
FK_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND sql LIKE '%FOREIGN KEY%';" 2>/dev/null || echo 0)
echo "=== Tables with FKs: $FK_COUNT ==="

# Triggers
TRIG_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='trigger';" 2>/dev/null || echo 0)
echo "=== Triggers: $TRIG_COUNT ==="

# Views
VIEW_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='view';" 2>/dev/null || echo 0)
echo "=== Views: $VIEW_COUNT ==="
