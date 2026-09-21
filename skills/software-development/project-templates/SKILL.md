---
name: project-templates
description: "Bootstrap Python, Node.js, bot, scraper, crypto projects."
category: software-development
tags: [scaffolding, bootstrap, templates, python, nodejs, telegram, crypto]
---

# Project Templates — Quick Bootstrapping

Use these templates when starting a new project. Each includes full file structure, boilerplate content, and setup commands.

---

## 1. Python Project

**File Structure:**
```
project-name/
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── requirements.txt
├── requirements-dev.txt
├── .gitignore
├── pyproject.toml
├── README.md
├── Makefile
└── .env.example
```

**Key Files:**

`src/project_name/__init__.py`
```python
"""Project description."""
__version__ = "0.1.0"
```

`src/project_name/main.py`
```python
"""Main entry point."""
import sys

def main() -> int:
    print("Hello from project_name!")
    return 0

if __name__ == "__main__":
    sys.exit(main())
```

`tests/test_main.py`
```python
"""Tests for main module."""
from project_name.main import main

def test_main_returns_zero():
    assert main() == 0
```

`requirements.txt`
```
# Add production dependencies here
```

`requirements-dev.txt`
```
-r requirements.txt
pytest>=7.0
black>=23.0
ruff>=0.1.0
mypy>=1.0
```

`pyproject.toml`
```toml
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "project-name"
version = "0.1.0"
description = "A short description"
requires-python = ">=3.10"
dependencies = []

[project.optional-dependencies]
dev = ["pytest>=7.0", "black>=23.0", "ruff>=0.1.0", "mypy>=1.0"]

[tool.ruff]
line-length = 88

[tool.mypy]
python_version = "3.10"
strict = true
```

`.gitignore`
```gitignore
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.eggs/
*.egg
.venv/
venv/
env/
.env
.mypy_cache/
.pytest_cache/
.ruff_cache/
*.so
.DS_Store
```

`Makefile`
```makefile
.PHONY: install dev test lint format clean

install:
	pip install -r requirements.txt

dev:
	pip install -r requirements-dev.txt

test:
	pytest tests/ -v

lint:
	ruff check src/ tests/
	mypy src/

format:
	black src/ tests/
	ruff check --fix src/ tests/

clean:
	rm -rf __pycache__ .pytest_cache .mypy_cache .ruff_cache
	find . -name "__pycache__" -exec rm -rf {} +
```

`README.md`
```markdown
# project-name

A short description.

## Setup

```bash
python -m venv .venv
source .venv/bin/activate
make dev
```

## Usage

```bash
python -m project_name.main
```

## Development

```bash
make test
make lint
make format
```
```

**Setup Commands:**
```bash
# Clone or create directory
mkdir project-name && cd project-name

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Create directory structure
mkdir -p src/project_name tests

# Create files (copy from templates above, then):
make dev        # install dev dependencies
make test       # verify setup works
git init && git add -A && git commit -m "initial commit"
```

---

## 2. Node.js Project

**File Structure:**
```
project-name/
├── src/
│   ├── index.js
│   └── lib/
│       └── utils.js
├── tests/
│   └── utils.test.js
├── package.json
├── .gitignore
├── .eslintrc.json
├── README.md
└── .env.example
```

**Key Files:**

`package.json`
```json
{
  "name": "project-name",
  "version": "1.0.0",
  "description": "A short description",
  "main": "src/index.js",
  "type": "module",
  "scripts": {
    "start": "node src/index.js",
    "dev": "node --watch src/index.js",
    "test": "node --test tests/",
    "lint": "eslint src/ tests/",
    "format": "prettier --write 'src/**/*.js' 'tests/**/*.js'"
  },
  "devDependencies": {
    "eslint": "^9.0",
    "prettier": "^3.0"
  }
}
```

`src/index.js`
```javascript
console.log("Hello from project-name!");

function main() {
  // Your code here
}

main();
```

`src/lib/utils.js`
```javascript
export function formatDate(date = new Date()) {
  return date.toISOString().split("T")[0];
}

export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
```

`tests/utils.test.js`
```javascript
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { formatDate, sleep } from "../src/lib/utils.js";

describe("formatDate", () => {
  it("returns YYYY-MM-DD format", () => {
    const result = formatDate(new Date("2024-01-15T10:30:00Z"));
    assert.equal(result, "2024-01-15");
  });
});
```

`.gitignore`
```gitignore
node_modules/
.env
dist/
build/
coverage/
*.log
.DS_Store
```

`README.md`
```markdown
# project-name

A short description.

## Setup

```bash
npm install
```

## Usage

```bash
npm start        # run production
npm run dev      # run with file watching
```

## Development

```bash
npm test         # run tests
npm run lint     # lint code
npm run format   # format code
```
```

**Setup Commands:**
```bash
mkdir project-name && cd project-name
npm init -y
# Edit package.json with content above
npm install
npm test  # verify
git init && git add -A && git commit -m "initial commit"
```

---

## 3. Telegram Bot Project (Python)

**File Structure:**
```
tg-bot/
├── src/
│   ├── bot.py
│   ├── handlers/
│   │   ├── __init__.py
│   │   ├── start.py
│   │   └── help.py
│   ├── keyboards/
│   │   └── __init__.py
│   ├── middlewares/
│   │   └── __init__.py
│   ├── config.py
│   └── __init__.py
├── tests/
│   ├── __init__.py
│   └── test_bot.py
├── requirements.txt
├── .gitignore
├── .env.example
├── docker-compose.yml
└── README.md
```

**Key Files:**

`src/config.py`
```python
"""Bot configuration."""
import os
from dataclasses import dataclass, field

@dataclass
class Config:
    bot_token: str = field(default_factory=lambda: os.environ["BOT_TOKEN"])
    allowed_users: list[int] = field(
        default_factory=lambda: [
            int(x) for x in os.environ.get("ALLOWED_USERS", "").split(",") if x
        ]
    )
    debug: bool = field(
        default_factory=lambda: os.environ.get("DEBUG", "false").lower() == "true"
    )

config = Config()
```

`src/bot.py`
```python
"""Main bot entry point."""
import asyncio
import logging

from aiogram import Bot, Dispatcher
from aiogram.fsm.storage.memory import MemoryStorage

from config import config
from handlers import start, help as help_handler

logging.basicConfig(
    level=logging.DEBUG if config.debug else logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)

async def main():
    bot = Bot(token=config.bot_token)
    dp = Dispatcher(storage=MemoryStorage())

    # Register routers (handlers)
    dp.include_router(start.router)
    dp.include_router(help_handler.router)

    logger.info("Bot starting...")
    try:
        await dp.start_polling(bot)
    finally:
        await bot.session.close()

if __name__ == "__main__":
    asyncio.run(main())
```

`src/handlers/start.py`
```python
"""Start command handler."""
from aiogram import Router, types
from aiogram.filters import CommandStart

router = Router()

@router.message(CommandStart())
async def cmd_start(message: types.Message):
    await message.answer(
        f"👋 Hello, {message.from_user.first_name}!\n\n"
        "I'm your bot. Send /help for available commands."
    )
```

`src/handlers/help.py`
```python
"""Help command handler."""
from aiogram import Router, types
from aiogram.filters import Command

router = Router()

@router.message(Command("help"))
async def cmd_help(message: types.Message):
    await message.answer(
        "📋 Available commands:\n\n"
        "/start — Start the bot\n"
        "/help  — Show this message"
    )
```

`requirements.txt`
```
aiogram>=3.0
python-dotenv>=1.0
aiohttp>=3.0
```

`.env.example`
```
BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
ALLOWED_USERS=
DEBUG=false
```

`docker-compose.yml`
```yaml
version: "3.8"
services:
  bot:
    build: .
    restart: unless-stopped
    env_file: .env
    volumes:
      - .:/app
    working_dir: /app
    command: python -m src.bot
```

`Dockerfile`
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "-m", "src.bot"]
```

**Setup Commands:**
```bash
mkdir tg-bot && cd tg-bot
python -m venv .venv && source .venv/bin/activate

# Copy files from templates above
cp .env.example .env
# Edit .env with your BOT_TOKEN

pip install -r requirements.txt
python -m src.bot

# Or with Docker:
docker-compose up -d
```

---

## 4. Web Scraper Project

**File Structure:**
```
scraper/
├── src/
│   ├── scraper.py
│   ├── parsers/
│   │   ├── __init__.py
│   │   └── base.py
│   ├── exporters/
│   │   ├── __init__.py
│   │   └── csv_exporter.py
│   ├── config.py
│   └── __init__.py
├── data/
│   └── .gitkeep
├── tests/
│   ├── __init__.py
│   └── test_scraper.py
├── requirements.txt
├── .gitignore
├── .env.example
└── README.md
```

**Key Files:**

`src/config.py`
```python
"""Scraper configuration."""
import os
from dataclasses import dataclass, field

@dataclass
class ScraperConfig:
    base_url: str = ""
    delay_between_requests: float = 1.0
    max_retries: int = 3
    timeout: int = 30
    output_dir: str = "data"
    user_agent: str = (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    )
    proxy: str = field(default_factory=lambda: os.environ.get("PROXY_URL", ""))

config = ScraperConfig()
```

`src/scraper.py`
```python
"""Core scraper with retry logic and rate limiting."""
import asyncio
import logging
from typing import Any

import aiohttp

from config import config

logger = logging.getLogger(__name__)


class Scraper:
    def __init__(self, session: aiohttp.ClientSession | None = None):
        self._session = session
        self._own_session = session is None

    async def __aenter__(self):
        if self._own_session:
            self._session = aiohttp.ClientSession(
                headers={"User-Agent": config.user_agent},
                timeout=aiohttp.ClientTimeout(total=config.timeout),
            )
        return self

    async def __aexit__(self, *exc):
        if self._own_session and self._session:
            await self._session.close()

    async def fetch(self, url: str) -> str:
        """Fetch a URL with retry logic."""
        for attempt in range(1, config.max_retries + 1):
            try:
                async with self._session.get(url) as resp:
                    resp.raise_for_status()
                    return await resp.text()
            except Exception as e:
                logger.warning(f"Attempt {attempt}/{config.max_retries} failed: {e}")
                if attempt == config.max_retries:
                    raise
                await asyncio.sleep(config.delay_between_requests * attempt)

        raise RuntimeError(f"Failed to fetch {url}")

    async def fetch_json(self, url: str) -> Any:
        """Fetch JSON endpoint."""
        for attempt in range(1, config.max_retries + 1):
            try:
                async with self._session.get(url) as resp:
                    resp.raise_for_status()
                    return await resp.json()
            except Exception as e:
                logger.warning(f"Attempt {attempt} failed: {e}")
                if attempt == config.max_retries:
                    raise
                await asyncio.sleep(config.delay_between_requests * attempt)
        raise RuntimeError(f"Failed to fetch {url}")
```

`src/parsers/base.py`
```python
"""Base parser class."""
from abc import ABC, abstractmethod
from dataclasses import dataclass


@dataclass
class ScrapedItem:
    url: str
    title: str
    data: dict


class BaseParser(ABC):
    @abstractmethod
    def parse(self, html: str, url: str) -> list[ScrapedItem]:
        ...
```

`src/exporters/csv_exporter.py`
```python
"""CSV export functionality."""
import csv
from pathlib import Path
from typing import Any

from config import config


def export_to_csv(items: list[dict[str, Any]], filename: str) -> Path:
    """Export items to CSV file."""
    output_path = Path(config.output_dir) / filename
    output_path.parent.mkdir(parents=True, exist_ok=True)

    if not items:
        return output_path

    fieldnames = list(items[0].keys())
    with open(output_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(items)

    return output_path
```

`requirements.txt`
```
aiohttp>=3.0
beautifulsoup4>=4.12
lxml>=5.0
aiofiles>=23.0
```

`.env.example`
```
PROXY_URL=
```

`README.md`
```markdown
# scraper

Async web scraper with retry logic and CSV export.

## Setup

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

## Usage

```python
import asyncio
from src.scraper import Scraper

async def main():
    async with Scraper() as s:
        html = await s.fetch("https://example.com")
        print(html[:200])

asyncio.run(main())
```

## Architecture

- `scraper.py` — core fetch with retry + rate limiting
- `parsers/` — HTML parsing (BeautifulSoup, lxml)
- `exporters/` — save data (CSV, JSON)
- `config.py` — settings via env vars
```

---

## 5. Crypto Trading Bot Project

**File Structure:**
```
crypto-bot/
├── src/
│   ├── bot.py
│   ├── exchanges/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── binance.py
│   │   └── hyperliquid.py
│   ├── strategies/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   └── arbitrage.py
│   ├── risk/
│   │   ├── __init__.py
│   │   └── manager.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── order.py
│   ├── config.py
│   ├── logger.py
│   └── __init__.py
├── data/
│   ├── trades/
│   │   └── .gitkeep
│   └── .gitkeep
├── tests/
│   ├── __init__.py
│   ├── test_arbitrage.py
│   └── test_risk.py
├── requirements.txt
├── .gitignore
├── .env.example
├── docker-compose.yml
└── README.md
```

**Key Files:**

`src/config.py`
```python
"""Bot configuration — all secrets from env."""
import os
from dataclasses import dataclass, field


@dataclass
class ExchangeConfig:
    name: str
    api_key: str
    api_secret: str
    testnet: bool = True


@dataclass
class BotConfig:
    # Exchanges
    binance_key: str = field(default_factory=lambda: os.environ.get("BINANCE_API_KEY", ""))
    binance_secret: str = field(default_factory=lambda: os.environ.get("BINANCE_API_SECRET", ""))
    hyperliquid_key: str = field(default_factory=lambda: os.environ.get("HYPERLIQUID_API_KEY", ""))
    hyperliquid_secret: str = field(default_factory=lambda: os.environ.get("HYPERLIQUID_API_SECRET", ""))

    # Trading
    testnet: bool = field(default_factory=lambda: os.environ.get("TESTNET", "true").lower() == "true")
    max_position_usd: float = field(default_factory=lambda: float(os.environ.get("MAX_POSITION_USD", "100")))
    min_profit_pct: float = field(default_factory=lambda: float(os.environ.get("MIN_PROFIT_PCT", "0.3")))
    max_loss_pct: float = field(default_factory=lambda: float(os.environ.get("MAX_LOSS_PCT", "2.0")))

    # Polling
    poll_interval_sec: float = field(default_factory=lambda: float(os.environ.get("POLL_INTERVAL", "5")))

    # Logging
    log_level: str = field(default_factory=lambda: os.environ.get("LOG_LEVEL", "INFO"))

config = BotConfig()
```

`src/logger.py`
```python
"""Structured logging for trade events."""
import json
import logging
import sys
from datetime import datetime, timezone


class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            "ts": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
        }
        if hasattr(record, "trade_data"):
            log_entry["trade"] = record.trade_data
        return json.dumps(log_entry)


def setup_logger(level: str = "INFO") -> logging.Logger:
    logger = logging.getLogger("crypto_bot")
    logger.setLevel(getattr(logging, level.upper()))

    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(JSONFormatter())
    logger.addHandler(handler)
    return logger

logger = setup_logger()
```

`src/models/order.py`
```python
"""Order and trade data models."""
from dataclasses import dataclass, field
from datetime import datetime, timezone
from enum import Enum


class Side(str, Enum):
    BUY = "buy"
    SELL = "sell"


class OrderStatus(str, Enum):
    PENDING = "pending"
    FILLED = "filled"
    CANCELLED = "cancelled"
    FAILED = "failed"


@dataclass
class Order:
    exchange: str
    symbol: str
    side: Side
    amount: float
    price: float
    status: OrderStatus = OrderStatus.PENDING
    order_id: str = ""
    created_at: datetime = field(default_factory=lambda: datetime.now(timezone.utc))
    filled_at: datetime | None = None

    @property
    def total_usd(self) -> float:
        return self.amount * self.price


@dataclass
class ArbitrageOpportunity:
    symbol: str
    buy_exchange: str
    sell_exchange: str
    buy_price: float
    sell_price: float
    profit_pct: float
    max_amount: float
    detected_at: datetime = field(default_factory=lambda: datetime.now(timezone.utc))

    @property
    def estimated_profit_usd(self) -> float:
        return self.max_amount * self.profit_pct / 100
```

`src/exchanges/base.py`
```python
"""Abstract exchange interface."""
from abc import ABC, abstractmethod
from typing import Any

from models.order import Order, Side


class BaseExchange(ABC):
    def __init__(self, name: str, testnet: bool = True):
        self.name = name
        self.testnet = testnet

    @abstractmethod
    async def get_ticker(self, symbol: str) -> float:
        """Get last price for a symbol."""
        ...

    @abstractmethod
    async def get_orderbook(self, symbol: str, depth: int = 5) -> dict:
        """Get order book."""
        ...

    @abstractmethod
    async def place_order(self, order: Order) -> str:
        """Place an order, return order ID."""
        ...

    @abstractmethod
    async def cancel_order(self, order_id: str, symbol: str) -> bool:
        """Cancel an order."""
        ...

    @abstractmethod
    async def get_balance(self, asset: str) -> float:
        """Get available balance for an asset."""
        ...
```

`src/exchanges/binance.py`
```python
"""Binance exchange connector."""
import aiohttp

from config import config
from exchanges.base import BaseExchange
from models.order import Order


class BinanceExchange(BaseExchange):
    BASE_URL = "https://api.binance.com"
    TESTNET_URL = "https://testnet.binance.vision"

    def __init__(self):
        super().__init__("binance", config.testnet)
        self.base = self.TESTNET_URL if self.testnet else self.BASE_URL

    async def get_ticker(self, symbol: str) -> float:
        async with aiohttp.ClientSession() as s:
            async with s.get(f"{self.base}/api/v3/ticker/price", params={"symbol": symbol}) as r:
                data = await r.json()
                return float(data["price"])

    async def get_orderbook(self, symbol: str, depth: int = 5) -> dict:
        async with aiohttp.ClientSession() as s:
            params = {"symbol": symbol, "limit": depth}
            async with s.get(f"{self.base}/api/v3/depth", params=params) as r:
                return await r.json()

    async def place_order(self, order: Order) -> str:
        # Implement with HMAC signing
        raise NotImplementedError("Implement with your API keys")

    async def cancel_order(self, order_id: str, symbol: str) -> bool:
        raise NotImplementedError

    async def get_balance(self, asset: str) -> float:
        raise NotImplementedError
```

`src/strategies/base.py`
```python
"""Base strategy interface."""
from abc import ABC, abstractmethod
from models.order import ArbitrageOpportunity


class BaseStrategy(ABC):
    @abstractmethod
    async def scan(self) -> list[ArbitrageOpportunity]:
        """Scan for opportunities."""
        ...

    @abstractmethod
    async def execute(self, opportunity: ArbitrageOpportunity) -> bool:
        """Execute a detected opportunity."""
        ...
```

`src/strategies/arbitrage.py`
```python
"""Cross-exchange arbitrage strategy."""
import logging
from typing import Any

from config import config
from exchanges.base import BaseExchange
from models.order import ArbitrageOpportunity, Order, Side
from risk.manager import RiskManager
from strategies.base import BaseStrategy

logger = logging.getLogger("crypto_bot.arbitrage")


class ArbitrageStrategy(BaseStrategy):
    def __init__(self, exchanges: list[BaseExchange]):
        self.exchanges = {e.name: e for e in exchanges}
        self.risk = RiskManager()
        self.pairs = ["BTCUSDT", "ETHUSDT", "SOLUSDT"]

    async def scan(self) -> list[ArbitrageOpportunity]:
        opportunities = []

        for pair in self.pairs:
            prices = {}
            for name, exchange in self.exchanges.items():
                try:
                    prices[name] = await exchange.get_ticker(pair)
                except Exception as e:
                    logger.warning(f"Failed to get price from {name}: {e}")
                    continue

            # Check all exchange pairs for arbitrage
            for buy_ex, buy_price in prices.items():
                for sell_ex, sell_price in prices.items():
                    if buy_ex == sell_ex:
                        continue

                    profit_pct = ((sell_price - buy_price) / buy_price) * 100

                    if profit_pct >= config.min_profit_pct:
                        opp = ArbitrageOpportunity(
                            symbol=pair,
                            buy_exchange=buy_ex,
                            sell_exchange=sell_ex,
                            buy_price=buy_price,
                            sell_price=sell_price,
                            profit_pct=profit_pct,
                            max_amount=config.max_position_usd / buy_price,
                        )

                        if self.risk.check_opportunity(opp):
                            opportunities.append(opp)
                            logger.info(
                                f"🎯 {pair}: {buy_ex}@{buy_price} → "
                                f"{sell_ex}@{sell_price} = {profit_pct:.2f}%"
                            )

        return opportunities

    async def execute(self, opp: ArbitrageOpportunity) -> bool:
        logger.info(f"Executing arbitrage: {opp.symbol} {opp.buy_exchange}→{opp.sell_exchange}")

        buy_exchange = self.exchanges[opp.buy_exchange]
        sell_exchange = self.exchanges[opp.sell_exchange]

        buy_order = Order(
            exchange=opp.buy_exchange,
            symbol=opp.symbol,
            side=Side.BUY,
            amount=opp.max_amount,
            price=opp.buy_price,
        )

        sell_order = Order(
            exchange=opp.sell_exchange,
            symbol=opp.symbol,
            side=Side.SELL,
            amount=opp.max_amount,
            price=opp.sell_price,
        )

        try:
            buy_id = await buy_exchange.place_order(buy_order)
            sell_id = await sell_exchange.place_order(sell_order)
            logger.info(f"✅ Orders placed: buy={buy_id}, sell={sell_id}")
            return True
        except Exception as e:
            logger.error(f"❌ Execution failed: {e}")
            return False
```

`src/risk/manager.py`
```python
"""Risk management: position limits, loss caps, drawdown tracking."""
import logging
from datetime import datetime, timezone

from config import config
from models.order import ArbitrageOpportunity

logger = logging.getLogger("crypto_bot.risk")


class RiskManager:
    def __init__(self):
        self.daily_pnl: float = 0.0
        self.daily_trades: int = 0
        self.max_daily_trades: int = 50
        self.last_reset: datetime = datetime.now(timezone.utc)
        self.total_exposure_usd: float = 0.0

    def _reset_if_new_day(self):
        now = datetime.now(timezone.utc)
        if now.date() > self.last_reset.date():
            logger.info(f"Daily reset: PnL={self.daily_pnl:.2f}, trades={self.daily_trades}")
            self.daily_pnl = 0.0
            self.daily_trades = 0
            self.last_reset = now

    def check_opportunity(self, opp: ArbitrageOpportunity) -> bool:
        """Return True if opportunity passes all risk checks."""
        self._reset_if_new_day()

        checks = [
            self._check_position_size(opp),
            self._check_daily_trades(),
            self._check_daily_loss(),
            self._check_total_exposure(opp),
        ]

        passed = all(checks)
        if not passed:
            logger.warning(f"Risk check failed for {opp.symbol}: {[c for c in checks if not c]}")
        return passed

    def _check_position_size(self, opp: ArbitrageOpportunity) -> bool:
        max_usd = config.max_position_usd
        if opp.estimated_profit_usd > max_usd * 0.1:
            logger.warning("Position too large relative to profit")
            return False
        return True

    def _check_daily_trades(self) -> bool:
        return self.daily_trades < self.max_daily_trades

    def _check_daily_loss(self) -> bool:
        return self.daily_pnl > -(config.max_loss_pct / 100) * config.max_position_usd

    def _check_total_exposure(self, opp: ArbitrageOpportunity) -> bool:
        new_exposure = self.total_exposure_usd + opp.max_amount * opp.buy_price
        return new_exposure <= config.max_position_usd * 3

    def record_trade(self, pnl_usd: float):
        self.daily_pnl += pnl_usd
        self.daily_trades += 1
```

`src/bot.py`
```python
"""Main bot loop."""
import asyncio
import logging

from config import config
from exchanges.binance import BinanceExchange
from strategies.arbitrage import ArbitrageStrategy

logger = logging.getLogger("crypto_bot")


async def main():
    logging.basicConfig(level=getattr(logging, config.log_level))

    exchanges = [BinanceExchange()]
    strategy = ArbitrageStrategy(exchanges)

    logger.info(f"🚀 Crypto bot starting | testnet={config.testnet} | min_profit={config.min_profit_pct}%")

    while True:
        try:
            opportunities = await strategy.scan()

            for opp in opportunities:
                logger.info(f"Found: {opp.symbol} {opp.buy_exchange}→{opp.sell_exchange} ({opp.profit_pct:.2f}%)")
                await strategy.execute(opp)

            if not opportunities:
                logger.debug("No opportunities this cycle")

        except Exception as e:
            logger.error(f"Error in main loop: {e}")

        await asyncio.sleep(config.poll_interval_sec)


if __name__ == "__main__":
    asyncio.run(main())
```

`requirements.txt`
```
aiohttp>=3.0
python-dotenv>=1.0
```

`.env.example`
```
# Exchange API Keys
BINANCE_API_KEY=
BINANCE_API_SECRET=
HYPERLIQUID_API_KEY=
HYPERLIQUID_API_SECRET=

# Trading Settings
TESTNET=true
MAX_POSITION_USD=100
MIN_PROFIT_PCT=0.3
MAX_LOSS_PCT=2.0
POLL_INTERVAL=5

# Logging
LOG_LEVEL=INFO
```

`README.md`
```markdown
# crypto-bot

Cross-exchange crypto arbitrage bot.

## Setup

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your API keys
```

## Usage

```bash
# Run bot
python -m src.bot

# Or with Docker
docker-compose up -d
```

## Architecture

- `exchanges/` — Exchange connectors (Binance, Hyperliquid)
- `strategies/` — Trading strategies (arbitrage)
- `risk/` — Risk management (position limits, loss caps)
- `models/` — Data models (Order, Opportunity)

## Risk Controls

- Max position size per trade
- Daily trade count limit
- Daily loss cap
- Total exposure limit

⚠️ Always test with TESTNET=true first.
```

`docker-compose.yml`
```yaml
version: "3.8"
services:
  bot:
    build: .
    restart: unless-stopped
    env_file: .env
    volumes:
      - ./data:/app/data
      - ./src:/app/src
```

---

## Universal Templates

### `.gitignore` (Python)
```gitignore
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.venv/
venv/
.env
.mypy_cache/
.pytest_cache/
.DS_Store
```

### `.gitignore` (Node.js)
```gitignore
node_modules/
.env
dist/
build/
coverage/
*.log
.DS_Store
```

### `.env.example`
```bash
# App settings
DEBUG=false
LOG_LEVEL=INFO

# API keys — copy to .env and fill in
API_KEY=
API_SECRET=
```

---

## Quick Bootstrap Commands

| Project | Command |
|---------|---------|
| Python | `mkdir proj && cd proj && python -m venv .venv && source .venv/bin/activate && mkdir -p src/proj tests` |
| Node.js | `mkdir proj && cd proj && npm init -y && npm install` |
| TG Bot | `mkdir tg-bot && cd tg-bot && python -m venv .venv && source .venv/bin/activate && pip install aiogram python-dotenv` |
| Scraper | `mkdir scraper && cd scraper && python -m venv .venv && source .venv/bin/activate && pip install aiohttp beautifulsoup4 lxml` |
| Crypto Bot | `mkdir crypto-bot && cd crypto-bot && python -m venv .venv && source .venv/bin/activate && pip install aiohttp python-dotenv` |
