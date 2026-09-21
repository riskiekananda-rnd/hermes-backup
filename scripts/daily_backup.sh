#!/bin/bash
DATE=$(date +%Y%m%d)
BACKUP_DIR=~/storage/shared/Download/backups
mkdir -p $BACKUP_DIR

# Backup Hermes config
tar -czf $BACKUP_DIR/hermes_config_$DATE.tar.gz \
  ~/.hermes/config.yaml \
  ~/.hermes/.env \
  ~/.hermes/memories/ \
  2>/dev/null

# Backup FreeLLMAPI config
cp ~/freellmapi/.env $BACKUP_DIR/freellmapi_env_$DATE.bak 2>/dev/null

# Save skills list
ls ~/.hermes/skills/ > $BACKUP_DIR/skills_list_$DATE.txt 2>/dev/null

echo "Backup $DATE: $(du -sh $BACKUP_DIR/ | awk '{print $1}') total"
