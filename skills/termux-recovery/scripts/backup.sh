#!/usr/bin/env bash
# Hermes config backup script
# Creates timestamped backups of .hermes directory
set -euo pipefail

HERMES_DIR="${HERMES_DIR:-$HOME/.hermes}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/hermes-backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="hermes-backup-${TIMESTAMP}.tar.gz"
MAX_BACKUPS="${MAX_BACKUPS:-10}"

mkdir -p "$BACKUP_DIR"

echo "Backing up Hermes configs..."
echo "  Source: $HERMES_DIR"
echo "  Dest:   $BACKUP_DIR/$BACKUP_NAME"

# Create compressed backup excluding cache and large temp files
tar -czf "$BACKUP_DIR/$BACKUP_NAME" \
    --exclude='cache/scratch/*' \
    --exclude='cache/browser*' \
    --exclude='*.log' \
    --warning=no-file-changed \
    -C "$(dirname "$HERMES_DIR")" \
    "$(basename "$HERMES_DIR")" 2>/dev/null || {
    # Check if archive was actually created (exit 1 = file changed during read, not fatal)
    if [[ -f "$BACKUP_DIR/$BACKUP_NAME" && -s "$BACKUP_DIR/$BACKUP_NAME" ]]; then
        echo "Warning: Archive created with minor warnings"
    else
        echo "ERROR: Backup failed" >&2
        exit 1
    fi
}

SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
echo "Backup created: $BACKUP_NAME ($SIZE)"

# Rotate old backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/hermes-backup-*.tar.gz 2>/dev/null | wc -l)
if (( BACKUP_COUNT > MAX_BACKUPS )); then
    REMOVE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))
    echo "Rotating $REMOVE_COUNT old backup(s)..."
    ls -1t "$BACKUP_DIR"/hermes-backup-*.tar.gz | tail -n "$REMOVE_COUNT" | xargs rm -f
    echo "Remaining backups: $MAX_BACKUPS"
fi

echo "Done. To restore: tar -xzf $BACKUP_DIR/$BACKUP_NAME -C \$HOME"
