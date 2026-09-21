# 🔒 Hermes Agent Full Backup
**Backup Date:** 21 September 2026
**Device:** Xiaomi Mi 11T, Android 14, Termux
**Account:** 202251239-cell (Education Pack UMK)

---

## 📋 IS BACKUP

### 1. Skills (31 kategori, 103+ skills)
Semua skill Hermes Agent termasuk:
- `kimer-group-history` — analisis histori grup + semua project
- `freellmapi-ops` — managing FreeLLMAPI gateway
- `crypto-trading`, `cryptocurrency-arbitrage` — crypto tools
- `web-scraping-advanced`, `telegram-group-mgmt`
- Dan semua skill bawaan Hermes

### 2. Config
- `config.yaml` — konfigurasi utama Hermes
- `.env` — environment variables
- `auth.json` — authentication tokens
- SOUL.md — personality definition

### 3. Memory (penting!)
- Memory entries Riski & environment
- Group history analysis
- GitHub safety rules
- Apify & project locations

### 4. Cron Jobs
- Health check job

### 5. Projects (referensi)
- eye_bot.py, trading_bot.py, airdrop_tracker.py

---

## 🔑 ACCOUNTS & ACCESS

### GitHub
- **Username:** 202251239-cell
- **Email:** 202251239@std.umk.ac.id
- **Plan:** Education Pack (free pro)
- **Repos:** tokopedia-scraper, tokopedia-store-scraper, shopee-id-scraper, gokil-restaurant
- ⚠️ OLD ACCOUNT RiskiGamer-Z = SUSPENDED

### Apify
- **Username:** rgamerz
- **Plan:** FREE ($5/mo credits)
- **Token:** (stored in .hermes/secrets/apify_token.txt)
- **Actors:** 4 active (157 total runs)

### FreeLLMAPI
- **Location:** ~/freellmapi/
- **URL:** localhost:3001/v1
- **Account:** riskigamerz@gmail.com
- **Default Model:** nvidia/nemotron-3-super-120b-a12b:free

### Telegram
- **Bot:** @kimerai_bot
- **Group:** KimerAI (-1003990707098)
- **Chat ID:** 1358706063

---

## 📁 PROJECT LOCATIONS

```
~/projects/
├── scrapers/
│   ├── tokopedia-scraper/     (Apify Actor, LIVE)
│   ├── tokopedia-store-scraper/ (Apify Actor, LIVE)
│   └── shopee-id-scraper/     (Apify Actor, CAPTCHA blocked)
└── websites/
    └── gokil-restaurant/      (HTML website)

~/trading-monitor/
├── eye_bot.py                 (Crypto arbitrage scanner)
├── trading_bot.py             (Trading bot)
├── airdrop_tracker.py         (Airdrop tracker)
└── alert_checker.py           (Alert system)

~/freellmapi/                  (LLM Gateway)
~/gateway/                     (Telegram gateway)
~/hermes-agent/                (Hermes source)
```

---

## ⚠️ GITHUB SAFETY RULES
1. NO automated mass commits/pushes
2. NO bot-driven rapid interactions
3. Space API calls (min 2 sec)
4. Max 10-20 auto commits/day
5. Review before push
6. Never push debug/test to main

---

## 🔄 RESTORE INSTRUCTIONS
1. Clone this repo: `git clone https://github.com/202251239-cell/hermes-backup.git`
2. Copy skills: `cp -r skills/* ~/.hermes/skills/`
3. Copy config: `cp config/* ~/.hermes/`
4. Copy memory: `cp memory/* ~/.hermes/memories/`
5. Install Apify token: `cp secrets/apify_token.txt ~/.hermes/secrets/`
6. Restart Hermes: `hermes restart`

---

*Backup otomatis oleh KimerAI — 21 September 2026*
