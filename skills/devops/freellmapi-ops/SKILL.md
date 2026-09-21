---
name: freellmapi-ops
version: 3.2.0
description: "Manage FreeLLMAPI LLM gateway on Termux."
tags: [freellmapi, llm, gateway, api-keys]
---

# FreeLLMAPI Operations

Unified LLM gateway: 34+ providers, 635 endpoints, one OpenAI-compatible URL.
Self-hosted at `~/freellmapi/`. Keys encrypted AES-256-GCM in local SQLite.

## Status
- **Dashboard:** http://localhost:5173 (Vite dev) / http://localhost:3001/ (built)
- **API:** http://localhost:3001/v1
- **Database:** ~/freellmapi/server/data/freeapi.db
- **Account:** riskigamerz@gmail.com

## Start/Stop
```bash
cd ~/freellmapi && npm run dev   # start (dev mode, Vite hot-reload)
cd ~/freellmapi && npm run build # build client for production
pkill -f 'tsx watch'              # stop
```

## Unified Key
```bash
sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';"
```

## Dashboard Login
```bash
curl -s -X POST http://localhost:3001/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"riskigamerz@gmail.com","password":"<password>"}' | python3 -m json.tool
```
Use token as `x-dashboard-token` header for `/api/*` routes.

## First-Time Setup / Rebuild
```bash
# 1. Clone + install
cd ~ && git clone https://github.com/tashfeenahmed/freellmapi.git && cd freellmapi && npm install
# 2. Build client (REQUIRED — without this, dashboard at :3001 returns ENOENT)
npm run build
# 3. Create .env (auto-generates encryption key)
echo 'ENCRYPTION_KEY=$(node -e "console.log(require(\"crypto\").randomBytes(32).toString(\"hex\"))")' > .env
echo 'PORT=3001' >> .env
echo 'HOST=127.0.0.1' >> .env
# 4. Start server + create account
cd ~/freellmapi && npm run dev
# Open http://localhost:5173 and create account (or use API)
curl -s -X POST http://localhost:3001/api/auth/setup \
  -H 'Content-Type: application/json' \
  -d '{"email":"riskigamerz@gmail.com","password":"<password>"}'
```

**Pitfall: Stale API Keys after Rebuild.** A fresh clone wipes the database. Old API keys in `~/.hermes/config.yaml` will return 401 Unauthorized. After any rebuild, generate a new key in the dashboard (Keys page) and update the Hermes config.

**Pitfall: Missing client/dist on fresh clone.** The repo ships source only. `npm run build` MUST run after `npm install` or the dashboard at :3001 throws `ENOENT: client/dist/index.html`. The Vite dev server at :5173 works without build, but the production route at :3001 needs the built assets.

## Model Catalog Verification
After a rebuild or update, the available model list may change (e.g., providers rotate free tiers). Always verify before relying on a specific model:
```bash
curl -s http://localhost:3001/v1/models -H "Authorization: Bearer <key>" | python3 -c "import sys,json;print([m['id'] for m in json.load(sys.stdin)['data']])"
```
If a model is missing, set `model.default: auto` in `~/.hermes/config.yaml` to let the gateway pick the best available.

## Adding a Provider

1. Check if the platform is built-in:
   ```bash
   grep 'platform:' ~/freellmapi/server/src/providers/index.ts | grep -i <name>
   ```
2. **Built-in platform** (nvidia, groq, google, cloudflare, etc.): add key via Dashboard → Keys page
3. **Custom platform** (OpenAI-compatible endpoint): use `platform: 'custom'` with `baseUrl` in config JSON
4. Restart server after adding keys

### Headless Key Addition (no dashboard login needed)

When dashboard session is unavailable (fresh install, forgot password), add keys via `FREEAPI_CONFIG_JSON` in `~/freellmapi/.env`:
```bash
echo 'FREEAPI_CONFIG_JSON={"keys":[{"platform":"nvidia","key":"nvapi-...","label":"NVIDIA NIM"}]}' >> ~/freellmapi/.env
# Then restart the server
pkill -f 'tsx watch' && cd ~/freellmapi && npm run dev
```
This applies on next boot. Multiple keys: nest them in the `keys` array. Check `/v1/models` after restart to confirm availability.

## Keyless Provider Setup (OVH, Kilo, LLM7)

Keyless providers need a **sentinel key** added via the dashboard API. Without this, routing fails with `"No candidate model has a configured, usable provider key"`.

```bash
# Get dashboard token
DASH_TOKEN=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"riskigamerz@gmail.com","password":"<pass>"}' | python3 -c "import json,sys;print(json.load(sys.stdin)['token'])")

# Add sentinel keys for each keyless platform
curl -s -X POST http://localhost:3001/api/keys \
  -H "x-dashboard-token: $DASH_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"platform":"ovh","label":"OVH Keyless","key":"keyless"}'

curl -s -X POST http://localhost:3001/api/keys \
  -H "x-dashboard-token: $DASH_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"platform":"kilo","label":"Kilo Keyless","key":"keyless"}'

curl -s -X POST http://localhost:3001/api/keys \
  -H "x-dashboard-token: $DASH_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"platform":"llm7","label":"LLM7 Keyless","key":"keyless"}'
```

After adding, verify with a test call:
```bash
FREELLMAPI_KEY=$(sqlite3 ~/freellmapi/server/data/freeapi.db "SELECT value FROM settings WHERE key='unified_api_key';")
curl -s http://localhost:3001/v1/chat/completions \
  -H "Authorization: Bearer $FREELLMAPI_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"model":"codestral-latest","messages":[{"role":"user","content":"hi"}],"max_tokens":5}'
```

**Pitfall:** The `key` field must literally be the string `"keyless"` — not an empty string, not omitted. FreeLLMAPI uses this sentinel to identify keyless routing vs. missing-key rejection.

## Diagnosing Routing Issues

```bash
# Check which models are enabled
sqlite3 ~/freellmapi/server/data/freeapi.db \
  "SELECT model_id, display_name, enabled FROM models WHERE platform='<platform>';"

# Check provider key status
TOKEN=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"riskigamerz@gmail.com","password":"<pass>"}' | python3 -c "import json,sys;print(json.load(sys.stdin)['token'])")
curl -s http://localhost:3001/api/keys -H "x-dashboard-token: $TOKEN" | python3 -m json.tool

# Check request routing from response header X-Routed-Via
```

## Test API
```bash
curl http://localhost:3001/v1/models -H "Authorization: Bearer <unified-key>"
```

## Auto-Rotation\n\nUse the custom rotate script to failover between free models automatically:\n```bash\n# List all available free models\nbash ~/.hermes/scripts/auto_rotate.sh --list\n\n# Send a request with auto-failover\nbash ~/.hermes/scripts/auto_rotate.sh \"Your prompt here\"\n```\n
## Providers (Free/Keyless)
- OVH — 2 req/min per IP (fallback only)
- Kilo, LLM7 — no rate limit (keyless)
- Bazaarlink, OpenRouter, Agnes, AI Horde, HuggingFace — keyless available
- Google/Gemini — free 1500 req/day (needs key)
- Groq — free 30 req/day (needs key)
- Mistral — free 1 req/sec (needs key)
- Cerebras — free tier (needs key)
- Cloudflare — free tier (**key format: account_id:api_token**, not bare token)
- NVIDIA — free tier (needs key)

## ⚠️ CRITICAL RULES (from crash lessons)
1. **NEVER** overwrite .env with `cat > .env` while server is running
2. **ALWAYS** backup before editing config: `cp .env .env.bak`
3. **NEVER** restart FreeLLMAPI and Hermes simultaneously
4. **State.db corrupts** if edited while process is active
5. **Use `hermes config set`** instead of manual YAML edits
6. **Cloudflare key format** is `account_id:api_token` — wrong format = silent failure
7. **OVH keyless** is 2 req/min — fallback only, not primary
8. **Client dist not built**: Vite dev mode is normal at :5173; 404 at :3001/ if not built
9. **Model Catalog Rotation**: Providers rotate free tiers; if a model returns 404, check `/v1/models` and switch to `auto` in Hermes config

## Security Model
- Keys encrypted AES-256-GCM at rest in SQLite
- ENCRYPTION_KEY auto-generated in dev mode if not set
- No telemetry/phoning home
- Only network call: catalog sync (signed metadata, not keys)
- Open source MIT — auditable at ~/freellmapi/