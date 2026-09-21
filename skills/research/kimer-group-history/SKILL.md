---
name: kimer-group-history
description: Recall KimerGroup projects, commands, and chat patterns.
---
# KimerGroup History Analysis

Based on 1154 messages from Telegram export.
Chat ID: -1003990707098 (KimerAI group)

## Participants
- RGamer-Z (Riski): 522 msgs (45.2%) - main operator
- KimerBot: 576 msgs (49.9%) - previous bot
- KimerAI: 30 msgs (2.6%) - current Hermes
- Chindy Khd: 26 msgs (2.3%) - group member

## Top Topics
1. AI/ML: 487 msgs
2. Telegram Bot: 174 msgs
3. Python: 121 msgs
4. Crypto/Trading: 102 msgs
5. Web Dev: 63 msgs
6. Projects: 29 msgs
7. Kuliah: 18 msgs
8. Security: 11 msgs

## Projects
1. Penjaga Hati (RSUD Loekmono) - healthcare app
2. KDI Website - digital marketing training
3. The Sato Hotel - hotel website, Vercel
4. Sapphire Boutique Hotel - hotel website
5. Safin Pati University - university website
6. GOKIL Restaurant - restaurant website
7. GenBI Reorganisasi - Google Apps Script
8. Brain Academy Kudus - promo playbook
9. Crypto Hunter - arbitrage scanner (eye_bot.py)
10. DealScout AI - Lablab x AMD challenge
11. Radar Diskon Gadget - e-commerce page

## Scraper Projects (KimerSearch topic)

### Tokopedia Scraper (Apify Actor)
- Repo: ~/tokopedia-scraper/ (GitHub: 202251239-cell/tokopedia-scraper)
- Actor ID: 2WuxWPdRnmpiYg2JQ (rgamerz/tokopedia-scraper)
- Status: LIVE on Apify Store, production-ready
- Features: keyword search, minRating filter, dedup, 21 fields
- Pricing: $0.002/item (FREE), $0.0012 (GOLD+)
- Batches: Batch1=keyword search, Batch2=bulk keywords, Batch3=store scraper

### Tokopedia Store Scraper
- Actor ID: AlQPTHQZPmisrQXLp (rgamerz/tokopedia-store-scraper)
- Status: WORKS (176 products from Xiaomi tested)
- Tech: GraphQL ShopProducts endpoint, auto shop ID detection
- Anti-bot: warm-up strategy (search page first, then store page)

### Shopee Store Scraper
- Status: BLOCKED by CAPTCHA in headless browser
- Needs residential proxy or different approach
- Riski said: fokus tokopedia aja dulu

### eye_bot.py (Crypto Arbitrage)
- 4 exchanges: Binance, OKX, KuCoin + 1 more
- Dynamic watchlist (top 30 volume, refresh 2 jam)
- Mode: paper trading, trigger >=0.3% net
- Cronjob: eye-bot-watchdog (auto-restart if dead)

### DealScout AI Pipeline
- Components: Tokopedia Apify adapter + RSS scraper + ranking engine
- Pipeline: scrape -> rank -> export -> Telegram alert
- Bot: @DealScoutAIKimer_bot
- Results: 120 Tokopedia products, 10 RSS items, 5 ranked deals
- Next: search-based scraper for specific keywords

### Local Website Prospecting
- Skill: local-website-prospecting
- Purpose: find businesses in Kudus without websites
- Method: web research (Overpass API was down)
- Results: GOKIL Restaurant, hotels (Salam Asri, Sunrise, Simpang7)

### Radar Diskon Gadget
- Price monitor for electronics deals
- Tokopedia scraping -> discount ranking -> alerts

## Files
- brain_academy_kit.txt - promo chat variations
- Code.txt - GenBI Apps Script
- inbound_playbook.txt - marketing playbook
- KDI_Website.html - training website
- penjaga_hati_rsud_loekmono.pptx
- script_telpon_kudus.txt - telesales script
- Security_Audit_Penjaga_Hati_2026.pdf

## Commands Used
- /model (50+ times), /status, /reset
- /stop, /resume, /new, /save, /topic

## Riski Command Patterns
1. Kimer, lanjut project X
2. Buatkan web untuk [nama]
3. Analisis [URL/link]
4. Buatkan PPT
5. Laporkan statusnya
6. Coba cek [link]
7. Buatkan kalimat untuk DM [target]
8. Optimalkan / Fix
9. Rebuild pakai [tech]
10. Buat plan, goal, analisis, data, eksekusi

## Riski Workflow
1. Plan 2. Analyze 3. Execute 4. Fix
No unnecessary questions. Execute autonomously.

## GitHub Account
- OLD (SUSPENDED): RiskiGamer-Z
- NEW (ACTIVE): 202251239-cell (education pack, UMK)
- Email: 202251239@std.umk.ac.id
- Repos: ~/projects/scrapers/ + ~/projects/websites/

## GitHub Safety (from suspension history)
1. NO automated mass commits/pushes
2. NO bot-driven repo interactions rapidly
3. NO scraping GitHub itself
4. Space API calls (min 2 sec between)
5. Max 10-20 commits/day automated
6. Prefer manual review before push
7. Never push test/debug code to main

## Apify Account
- Username: rgamerz | Plan: FREE ($5/mo)
- Token: ~/.hermes/secrets/apify_token.txt
- Actors: tokopedia-scraper (54 runs),
  tokopedia-store-scraper (78 runs),
  shopee-id-scraper (13), shopee-store-scraper (12)

## Files Location
Export: ~/.hermes/cache/documents/histori_kimer/
JSON: ~/.hermes/cache/scratch/kimer_analysis.json
Local repos: ~/projects/scrapers/, ~/projects/websites/