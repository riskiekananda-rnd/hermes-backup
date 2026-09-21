---
name: telegram-group-mgmt
version: 1.0.0
description: "Manage Telegram groups: privacy mode, mentions, reactions."
tags: [telegram, group, bot, privacy, mentions]
---

# Telegram Group Management

Kelola bot di Telegram groups dan forum topics.

## Group Config (config.yaml)
```yaml
telegram:
  allowed_chats:
    - "-1003990707098"  # KimerAI group
  require_mention: true
  observe_unmentioned_group_messages: true
  reactions: true
  extra:
    status_indicator: true
    drop_pending_on_cold_boot: false  # Termux: phone turns off!
```

## Privacy Mode
Bot MUST be admin to see all messages in groups.
- Bot menu → Privacy Mode → disable
- Or add bot as admin with read messages permission
- Without this, bot only sees /commands and @mentions

## Group Actions
```bash
# Check if bot is in group
hermes channels list

# Test group connection
curl -s "https://api.telegram.org/bot<TOKEN>/getChat?chat_id=-1003990707098"

# Check bot permissions in group
curl -s "https://api.telegram.org/bot<TOKEN>/getChatMember?chat_id=-1003990707098&user_id=<BOT_ID>"

# Send message to group
curl -s -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" \
  -H 'Content-Type: application/json' \
  -d '{"chat_id":"-1003990707098","text":"Hello from Hermes!","message_thread_id":1}'
```

## Forum Topics
- Telegram groups with Topics enabled use `message_thread_id`
- Each topic has its own thread ID
- Bot must target specific thread_id when replying

## Common Issues
1. **Bot doesn't respond in group** → check privacy mode, check admin status
2. **Bot responds to everyone** → set `require_mention: true`
3. **Messages lost on restart** → set `drop_pending_on_cold_boot: false`
4. **Wrong topic reply** → verify thread_id in message metadata