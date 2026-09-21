---
name: web-scraping-advanced
version: 1.0.0
description: "Advanced web scraping: anti-bot, proxies, rotation."
tags: [scraping, web, anti-bot, proxy, automation]
platforms: [linux, macos]
author: Hermes Agent
license: MIT
---

# Advanced Web Scraping

Teknik scraping lanjut: anti-bot bypass, proxy rotation, rate limiting.

## When to Use
- Scraping sites with anti-bot protection
- Need proxy rotation for large-scale scraping
- Dealing with CAPTCHAs or rate limits
- Building production scrapers

## Prerequisites
- Python 3.8+
- `scrapling` package (`pip install scrapling`)
- `requests` or `httpx` for HTTP
- Optional: `playwright` for JS-rendered sites

## Quick Reference
```python
# Basic fetch with scrapling
from scrapling import Fetcher
fetcher = Fetcher()
page = fetcher.get('https://example.com')
print(page.css('h1::text'))

# Stealth fetch (anti-bot)
from scrapling import StealthyFetcher
fetcher = StealthyFetcher()
page = fetcher.fetch('https://protected-site.com')
```

## Anti-Bot Techniques
1. **User-Agent rotation** — rotate browser user-agents
2. **Proxy rotation** — use proxy pools
3. **Rate limiting** — add delays between requests
4. **Cookie handling** — maintain session cookies
5. **Header randomization** — vary request headers

## Proxy Setup
```python
# Free proxy list
import requests
proxies = ['http://proxy1:8080', 'http://proxy2:8080']

# Rotate proxies
proxy = proxies[count % len(proxies)]
response = requests.get(url, proxies={'http': proxy})
```

## Rate Limiting
```python
import time
import random

def fetch_with_delay(url, min_delay=1, max_delay=3):
    time.sleep(random.uniform(min_delay, max_delay))
    return requests.get(url)
```

## Common Patterns
1. **Pagination** — follow next/prev links
2. **Infinite scroll** — detect scroll triggers
3. **API interception** — find hidden APIs
4. **Session management** — maintain login state

## Pitfalls
- Respect robots.txt
- Don't hammer servers — use delays
- Some sites block cloud IPs
- JavaScript rendering needs headless browser
- CAPTCHAs may need manual solving

## Verification
```bash
test -f scrapling && echo 'scrapling installed' || echo 'not installed'
python3 -c 'import scrapling; print(scrapling.__version__)'
```