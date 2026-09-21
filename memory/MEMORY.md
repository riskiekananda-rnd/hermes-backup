FreeLLMAPI gateway: localhost:3001/v1. Config: ~/.hermes/config.yaml (provider: custom, base_url, default: auto). Account: riskigamerz@gmail.com. NEVER overwrite .env while running. Failover: ~/.hermes/scripts/auto_rotate.sh. NVIDIA NIM key active.
§
User communicates in Indonesian. Prefers casual, friendly tone.
§
When user asks to recall memory/old sessions/projects: check in order — (1) ~/.hermes/memories/*.md, (2) ~/.hermes/sessions/sessions.json for metadata, (3) ~/.hermes/state.db sessions+messages tables, (4) ~/.hermes/kanban.db tasks, (5) ~/.hermes_backup/, (6) ~/ for project dirs. Use sqlite3 CLI for .db files. Parse jsonl transcripts with python3 json.loads. Android storage via ~/storage/ symlinks.
§
User: Riski Eka Nanda. Email: 202251239@std.umk.ac.id. Prodi: Teknik Informatika UMK, semester 8, wisuda Oktober 2026. Skills: web dev, AI agents, crypto arbitrage. Projects: eye_bot.py (arbitrage scanner), DealScout AI (Lablab x AMD challenge), TaskFlow, FreeLLMAPI setup. GitHub: RiskiGamer-Z. Telegram groups: KimerAI (-1003990707098). Chat ID: 1358706063.
§
Telegram KimerAI group: chat_id -1003990707098. Crash: state.db corrupts mid-edit. FreeLLMAPI rebuilt ~/freellmapi/. Device: Xiaomi Mi 11T, Android 14, Termux. GitHub: 202251239-cell (edu UMK). OLD RiskiGamer-Z SUSPENDED. Apify: rgamerz (FREE). Scrapers: ~/projects/scrapers/. Safety: no mass commits, max 10-20 auto/day.
§
Skill: kimer-group-history — 1154 msgs, 11 projects + scrapers (Tokopedia, Shopee, eye_bot, DealScout). Riski workflow: plan→analyze→execute→fix.
§
FreeLLMAPI gateway runs at http://localhost:3001/v1. In ~/.hermes/config.yaml, use provider: custom, base_url: http://localhost:3001/v1, and default: auto for smart routing. Pitfall: freellmapi cli setup-hermes may insert ${FREELLMAPI_API_KEY} placeholder; if the env var is missing, Hermes fallbacks to other providers. Fix: hardcode the key in config.yaml.