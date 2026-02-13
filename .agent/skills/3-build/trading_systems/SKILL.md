---
name: Trading Systems
description: Building trading bots, backtesting engines, and financial data pipelines
---

# Trading Systems Skill

**Purpose**: Structured workflow for building automated trading systems, backtesting strategies against historical data, and constructing reliable financial data pipelines.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a trading bot for [exchange/asset]"
"Create a backtesting engine for [strategy]"
"Set up a financial data pipeline for [source]"
"Implement [strategy name] trading strategy"
"Using trading_systems skill: [task]"
```

---

## 🏗️ Trading System Architecture

A production trading system follows a strict pipeline from data ingestion to execution reporting.

```
┌─────────────┐    ┌──────────────────┐    ┌───────────────┐
│  Data Feed   │───▶│  Strategy Engine  │───▶│ Risk Manager  │
│  (Market)    │    │  (Signals)        │    │ (Validation)  │
└─────────────┘    └──────────────────┘    └──────┬────────┘
                                                   │
                   ┌──────────────────┐    ┌──────▼────────┐
                   │ Execution Report │◀───│ Order Manager │
                   │ (Logging)        │    │ (Routing)     │
                   └──────────────────┘    └──────┬────────┘
                                                   │
                                           ┌──────▼────────┐
                                           │   Exchange     │
                                           │   (Fills)      │
                                           └───────────────┘
```

| Component | Responsibility | Key Concerns |
|-----------|---------------|--------------|
| **Data Feed** | Ingest real-time and historical market data | Latency, reconnection, normalization |
| **Strategy Engine** | Generate buy/sell signals from data | Signal quality, parameter tuning |
| **Risk Manager** | Validate orders against risk rules | Position limits, drawdown caps, exposure |
| **Order Manager** | Route orders to exchanges, track state | Order types, partial fills, retries |
| **Exchange** | Execute trades on venue | API limits, authentication, uptime |
| **Execution Report** | Log fills, P&L, audit trail | Immutable records, reconciliation |

---

## 📡 Market Data Sources

| Category | Provider | Data Type | Cost | Notes |
|----------|----------|-----------|------|-------|
| **Exchange WebSocket** | Binance | Real-time trades, orderbook | Free | Highest volume crypto exchange |
| **Exchange WebSocket** | Coinbase | Real-time trades, orderbook | Free | US-regulated, institutional |
| **Exchange API** | Alpaca | US equities, real-time | Free tier | Commission-free, paper trading |
| **Aggregator** | CoinGecko | Price, volume, market cap | Free tier | 30+ calls/min free |
| **Aggregator** | Yahoo Finance | Equities, ETFs, FX | Free (unofficial) | `yfinance` Python library |
| **Professional** | Bloomberg | Full market coverage | $$$$ | Terminal + B-PIPE API |
| **Professional** | Refinitiv | Full market coverage | $$$$ | Eikon + Elektron API |
| **Free Alternative** | Alpha Vantage | Equities, FX, crypto | Free (5/min) | Good for prototyping |
| **Free Alternative** | Polygon.io | US equities, options, crypto | Free (5/min) | WebSocket + REST |
| **Free Alternative** | Twelve Data | Equities, FX, crypto | Free (8/min) | 800+ calls/day free |

> [!TIP]
> Start with free providers (Alpha Vantage, Polygon.io) for prototyping. Move to direct exchange WebSocket feeds for production — they have the lowest latency and highest reliability.

---

## 🔌 Exchange API Integration

### Authentication Pattern

Most exchanges use API key + secret with HMAC-SHA256 signing:

```python
import hmac
import hashlib
import time
import requests

class ExchangeClient:
    def __init__(self, api_key: str, api_secret: str, base_url: str):
        self.api_key = api_key
        self.api_secret = api_secret
        self.base_url = base_url

    def _sign(self, params: dict) -> str:
        query_string = "&".join(f"{k}={v}" for k, v in sorted(params.items()))
        return hmac.new(
            self.api_secret.encode(),
            query_string.encode(),
            hashlib.sha256
        ).hexdigest()

    def get_account(self) -> dict:
        params = {"timestamp": int(time.time() * 1000)}
        params["signature"] = self._sign(params)
        headers = {"X-MBX-APIKEY": self.api_key}
        resp = requests.get(
            f"{self.base_url}/api/v3/account",
            params=params,
            headers=headers,
        )
        resp.raise_for_status()
        return resp.json()
```

### WebSocket Feed Connection (Binance)

```python
import asyncio
import json
import websockets

async def binance_ws(symbol: str = "btcusdt"):
    """Connect to Binance WebSocket for real-time trade data."""
    url = f"wss://stream.binance.com:9443/ws/{symbol}@trade"

    async for ws in websockets.connect(url):
        try:
            async for message in ws:
                trade = json.loads(message)
                print(f"Price: {trade['p']} | Qty: {trade['q']} | Time: {trade['T']}")
        except websockets.ConnectionClosed:
            print("Connection lost. Reconnecting...")
            continue

if __name__ == "__main__":
    asyncio.run(binance_ws())
```

### Rate Limits

| Exchange | REST Limit | WebSocket Limit | Weight System |
|----------|-----------|-----------------|---------------|
| **Binance** | 1200 weight/min | 5 messages/sec | Endpoints have different weights |
| **Coinbase** | 10 req/sec | 8 subscriptions/conn | Per-endpoint limits |
| **Alpaca** | 200 req/min | 1 connection | Tiered by plan |
| **Kraken** | 15 req/sec | 25 subscriptions | Decaying counter |

> [!WARNING]
> Exceeding rate limits results in temporary IP bans (usually 5-15 minutes). Always implement exponential backoff and track your request weight budget.

---

## 🔬 Backtesting Framework

### Event-Driven Backtester Architecture

```python
from dataclasses import dataclass
from datetime import datetime
from typing import List, Optional
from enum import Enum

class Side(Enum):
    BUY = "BUY"
    SELL = "SELL"

@dataclass
class Bar:
    timestamp: datetime
    open: float
    high: float
    low: float
    close: float
    volume: float

@dataclass
class Signal:
    timestamp: datetime
    side: Side
    strength: float  # 0.0 to 1.0

@dataclass
class Order:
    timestamp: datetime
    side: Side
    quantity: float
    price: float
    filled: bool = False
    fill_price: Optional[float] = None

class Backtester:
    def __init__(self, initial_capital: float = 100_000.0):
        self.capital = initial_capital
        self.position = 0.0
        self.trades: List[Order] = []
        self.equity_curve: List[float] = []

    def run(self, bars: List[Bar], strategy) -> dict:
        for i, bar in enumerate(bars):
            # Generate signal from strategy
            lookback = bars[max(0, i - strategy.lookback):i + 1]
            signal = strategy.on_bar(bar, lookback)

            if signal:
                order = self._execute_order(signal, bar)
                if order:
                    self.trades.append(order)

            # Track equity
            equity = self.capital + (self.position * bar.close)
            self.equity_curve.append(equity)

        return self._calculate_metrics()

    def _execute_order(self, signal: Signal, bar: Bar) -> Optional[Order]:
        # Model slippage: 0.1% adverse price movement
        slippage = bar.close * 0.001
        fill_price = bar.close + slippage if signal.side == Side.BUY else bar.close - slippage

        # Model transaction cost: 0.1% commission
        commission = fill_price * 0.001

        quantity = (self.capital * signal.strength * 0.1) / fill_price

        if signal.side == Side.BUY and self.capital >= quantity * (fill_price + commission):
            self.capital -= quantity * (fill_price + commission)
            self.position += quantity
            return Order(bar.timestamp, Side.BUY, quantity, bar.close, True, fill_price)
        elif signal.side == Side.SELL and self.position >= quantity:
            self.capital += quantity * (fill_price - commission)
            self.position -= quantity
            return Order(bar.timestamp, Side.SELL, quantity, bar.close, True, fill_price)
        return None

    def _calculate_metrics(self) -> dict:
        if not self.equity_curve:
            return {}
        import numpy as np
        eq = np.array(self.equity_curve)
        returns = np.diff(eq) / eq[:-1]
        peak = np.maximum.accumulate(eq)
        drawdown = (peak - eq) / peak
        return {
            "total_return": (eq[-1] / eq[0]) - 1,
            "max_drawdown": np.max(drawdown),
            "sharpe_ratio": np.mean(returns) / np.std(returns) * np.sqrt(252) if np.std(returns) > 0 else 0,
            "total_trades": len(self.trades),
            "win_rate": sum(1 for t in self.trades if t.fill_price and t.side == Side.SELL) / max(len(self.trades), 1),
        }
```

### Backtesting Libraries

| Library | Language | Style | Strengths | Weaknesses |
|---------|----------|-------|-----------|------------|
| **Backtrader** | Python | Event-driven | Mature, large community, many indicators | Slower, complex API |
| **Zipline** | Python | Event-driven | Quantopian heritage, institutional feel | Maintenance uncertain |
| **vectorbt** | Python | Vectorized | Extremely fast, NumPy-based | Less intuitive for beginners |
| **QuantConnect (Lean)** | C#/Python | Event-driven | Cloud backtesting, live trading bridge | Vendor lock-in risk |
| **Custom** | Any | Any | Full control, no abstractions | Build everything yourself |

### Avoiding Common Backtesting Pitfalls

| Pitfall | Description | Mitigation |
|---------|-------------|------------|
| **Look-ahead bias** | Using future data in decisions | Strict time-ordered data access only |
| **Survivorship bias** | Only testing assets that still exist | Include delisted/failed assets in dataset |
| **Overfitting** | Strategy fits history but not future | Walk-forward analysis, out-of-sample testing |
| **Ignoring costs** | No slippage or commissions modeled | Add realistic transaction cost model |
| **Curve fitting** | Too many parameters tuned to past | Limit free parameters, use cross-validation |
| **Data snooping** | Testing many strategies, reporting best | Bonferroni correction, hold-out test set |

---

## 📊 Strategy Patterns

### Moving Average Crossover

```python
class MovingAverageCrossover:
    """Classic dual moving average crossover strategy."""

    def __init__(self, fast_period: int = 10, slow_period: int = 30):
        self.fast_period = fast_period
        self.slow_period = slow_period
        self.lookback = slow_period
        self.prev_fast = None
        self.prev_slow = None

    def on_bar(self, bar: Bar, history: List[Bar]) -> Optional[Signal]:
        if len(history) < self.slow_period:
            return None

        closes = [b.close for b in history]
        fast_ma = sum(closes[-self.fast_period:]) / self.fast_period
        slow_ma = sum(closes[-self.slow_period:]) / self.slow_period

        signal = None
        if self.prev_fast is not None and self.prev_slow is not None:
            # Golden cross: fast crosses above slow
            if self.prev_fast <= self.prev_slow and fast_ma > slow_ma:
                signal = Signal(bar.timestamp, Side.BUY, strength=0.8)
            # Death cross: fast crosses below slow
            elif self.prev_fast >= self.prev_slow and fast_ma < slow_ma:
                signal = Signal(bar.timestamp, Side.SELL, strength=0.8)

        self.prev_fast = fast_ma
        self.prev_slow = slow_ma
        return signal
```

### Strategy Quick Reference

| Strategy | Type | Timeframe | Complexity | Key Indicator |
|----------|------|-----------|------------|---------------|
| **MA Crossover** | Trend-following | Daily+ | Low | SMA/EMA |
| **Mean Reversion** | Counter-trend | Intraday-Daily | Medium | Bollinger Bands, Z-score |
| **Momentum** | Trend-following | Weekly | Low | RSI, Rate of Change |
| **Pairs Trading** | Market-neutral | Daily | High | Cointegration, spread |
| **Arbitrage** | Market-neutral | Tick-level | High | Cross-exchange price diff |
| **Market Making** | Neutral | Tick-level | Very High | Orderbook imbalance |

---

## 📈 Technical Indicators

| Indicator | Full Name | Use | Library Function |
|-----------|-----------|-----|-----------------|
| **SMA** | Simple Moving Average | Trend direction, support/resistance | `ta.sma()` |
| **EMA** | Exponential Moving Average | Faster trend detection | `ta.ema()` |
| **RSI** | Relative Strength Index | Overbought/oversold (>70 / <30) | `ta.rsi()` |
| **MACD** | Moving Avg Convergence Divergence | Trend momentum, signal crossovers | `ta.macd()` |
| **BB** | Bollinger Bands | Volatility, mean reversion | `ta.bbands()` |
| **VWAP** | Volume-Weighted Avg Price | Fair value benchmark | `ta.vwap()` |
| **ATR** | Average True Range | Volatility, stop-loss sizing | `ta.atr()` |

**Indicator Libraries**: `TA-Lib` (C bindings, fastest), `pandas-ta` (pure Python, 130+ indicators), `tulip` (C library, lightweight)

---

## 🛡️ Risk Management

### Position Sizing Methods

| Method | Formula | Best For |
|--------|---------|----------|
| **Fixed Fractional** | Risk = Capital x Fixed% (e.g., 1-2%) | Most traders, simple |
| **Kelly Criterion** | f* = (bp - q) / b | Maximizing geometric growth |
| **Volatility-Based** | Size = Risk$ / ATR | Adapts to market conditions |
| **Equal Weight** | Size = Capital / N positions | Portfolios with many assets |

### Risk Manager Implementation

```python
@dataclass
class RiskLimits:
    max_position_pct: float = 0.10       # Max 10% of capital in one position
    max_drawdown_pct: float = 0.15       # Stop trading at 15% drawdown
    max_daily_loss_pct: float = 0.03     # Max 3% daily loss
    max_open_positions: int = 5          # Max concurrent positions
    max_correlation: float = 0.7         # Max correlation between positions

class RiskManager:
    def __init__(self, limits: RiskLimits, capital: float):
        self.limits = limits
        self.initial_capital = capital
        self.current_capital = capital
        self.daily_pnl = 0.0
        self.open_positions: dict = {}

    def check_order(self, symbol: str, quantity: float, price: float) -> tuple[bool, str]:
        order_value = quantity * price

        # Check position size limit
        if order_value > self.current_capital * self.limits.max_position_pct:
            return False, f"Position size {order_value:.2f} exceeds {self.limits.max_position_pct*100}% limit"

        # Check max open positions
        if symbol not in self.open_positions and len(self.open_positions) >= self.limits.max_open_positions:
            return False, f"Max open positions ({self.limits.max_open_positions}) reached"

        # Check drawdown limit
        drawdown = (self.initial_capital - self.current_capital) / self.initial_capital
        if drawdown >= self.limits.max_drawdown_pct:
            return False, f"Max drawdown {self.limits.max_drawdown_pct*100}% breached ({drawdown*100:.1f}%)"

        # Check daily loss limit
        if self.daily_pnl <= -(self.initial_capital * self.limits.max_daily_loss_pct):
            return False, f"Daily loss limit {self.limits.max_daily_loss_pct*100}% breached"

        return True, "Order approved"
```

### Order Types

| Order Type | Execution | Use Case |
|------------|-----------|----------|
| **Market** | Immediate at best available price | Urgent entry/exit, high liquidity |
| **Limit** | Only at specified price or better | Price-sensitive entries |
| **Stop** | Becomes market when price hits trigger | Stop-loss protection |
| **Stop-Limit** | Becomes limit when price hits trigger | Controlled stop-loss, gap risk |
| **OCO** | One-Cancels-Other (take-profit + stop-loss) | Bracket orders |
| **TWAP** | Time-Weighted Average Price execution | Large orders, minimize impact |
| **VWAP** | Volume-Weighted Average Price execution | Institutional execution benchmark |

---

## 💾 Data Storage

### OHLCV Schema (TimescaleDB)

```sql
-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- OHLCV candle data table
CREATE TABLE candles (
    time        TIMESTAMPTZ NOT NULL,
    symbol      TEXT        NOT NULL,
    exchange    TEXT        NOT NULL,
    interval    TEXT        NOT NULL,  -- '1m', '5m', '1h', '1d'
    open        DOUBLE PRECISION NOT NULL,
    high        DOUBLE PRECISION NOT NULL,
    low         DOUBLE PRECISION NOT NULL,
    close       DOUBLE PRECISION NOT NULL,
    volume      DOUBLE PRECISION NOT NULL,
    trade_count INTEGER,
    vwap        DOUBLE PRECISION
);

-- Convert to hypertable for time-series optimization
SELECT create_hypertable('candles', 'time');

-- Composite index for fast lookups
CREATE INDEX idx_candles_symbol_time ON candles (symbol, exchange, interval, time DESC);

-- Compression policy: compress data older than 7 days
ALTER TABLE candles SET (
    timescaledb.compress,
    timescaledb.compress_segmentby = 'symbol, exchange, interval'
);
SELECT add_compression_policy('candles', INTERVAL '7 days');

-- Retention policy: drop data older than 2 years
SELECT add_retention_policy('candles', INTERVAL '2 years');

-- Continuous aggregate for daily summary from 1-minute candles
CREATE MATERIALIZED VIEW candles_daily
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 day', time) AS day,
    symbol,
    exchange,
    first(open, time)  AS open,
    max(high)           AS high,
    min(low)            AS low,
    last(close, time)   AS close,
    sum(volume)         AS volume
FROM candles
WHERE interval = '1m'
GROUP BY day, symbol, exchange;
```

### Time-Series Database Comparison

| Database | Best For | Compression | Query Language |
|----------|----------|-------------|---------------|
| **TimescaleDB** | PostgreSQL users, complex queries | 90-95% | SQL (full PostgreSQL) |
| **InfluxDB** | Metrics, simple time-series | 80-90% | Flux / InfluxQL |
| **QuestDB** | Ultra-low latency ingestion | 70-85% | SQL (subset) |
| **ClickHouse** | Analytical aggregations | 90-95% | SQL (dialect) |

---

## 📏 Performance Metrics

| Metric | Formula | Good Value | Interpretation |
|--------|---------|------------|----------------|
| **Sharpe Ratio** | (Return - Rf) / StdDev | > 1.5 | Risk-adjusted return |
| **Sortino Ratio** | (Return - Rf) / Downside StdDev | > 2.0 | Downside-risk-adjusted return |
| **Max Drawdown** | Peak-to-trough decline | < 15% | Worst loss from peak |
| **Win Rate** | Winning trades / Total trades | > 50% | Percentage of profitable trades |
| **Profit Factor** | Gross profit / Gross loss | > 1.5 | Dollars won per dollar lost |
| **Calmar Ratio** | Annual return / Max drawdown | > 2.0 | Return per unit drawdown |
| **Annualized Return** | (1 + Total) ^ (252/days) - 1 | > 15% | Yearly compounded return |

> [!TIP]
> No single metric tells the full story. A high Sharpe ratio with a 40% max drawdown is still dangerous. Always evaluate metrics together, and focus on risk-adjusted returns over absolute returns.

---

## ⚖️ Regulatory Awareness

| Regulator | Region | Scope | Key Rules |
|-----------|--------|-------|-----------|
| **SEC** | US | Securities, equities | Registration, reporting, insider trading |
| **FINRA** | US | Broker-dealers | Pattern day trader rule ($25K min), suitability |
| **CFTC** | US | Futures, commodities | Position limits, reporting thresholds |
| **FCA** | UK | All financial services | Authorization, conduct rules, best execution |
| **MiFID II** | EU | Investment services | Algo trading registration, kill switches, record keeping |
| **MAS** | Singapore | All financial services | Licensing, AML/CFT requirements |

> [!WARNING]
> This table is informational only. Algorithmic trading may require registration, licensing, or reporting in your jurisdiction. **Always consult a qualified legal professional** before deploying automated trading systems with real capital.

---

## 🚀 Live Trading Considerations

| Phase | Duration | Objective |
|-------|----------|-----------|
| **Backtest** | Until profitable across multiple periods | Validate strategy logic and edge |
| **Paper Trading** | Minimum 2 weeks | Verify execution, fill assumptions, latency |
| **Small Live** | 1-3 months at 10% target size | Validate with real money, real psychology |
| **Scale Up** | Gradual over months | Increase position size as confidence grows |

### Critical Live Trading Checks

- [ ] Order reconciliation between local state and exchange
- [ ] Fill monitoring with alerts for missed or partial fills
- [ ] Latency measurement and logging (order sent to fill received)
- [ ] Automatic shutdown on error (kill switch)
- [ ] Daily P&L reporting and drawdown monitoring
- [ ] Exchange connectivity heartbeat with auto-reconnect

---

## ✅ EXIT CHECKLIST

- [ ] Backtesting shows positive edge across multiple time periods (in-sample + out-of-sample)
- [ ] Transaction costs and slippage modeled realistically
- [ ] Risk management rules enforced (position size, drawdown, daily loss)
- [ ] Paper trading completed for minimum 2 weeks with acceptable results
- [ ] Exchange API integration tested (authentication, order placement, WebSocket feeds)
- [ ] Data pipeline reliable with reconnection handling and gap detection
- [ ] Performance metrics documented (Sharpe, Sortino, max drawdown, win rate)
- [ ] Kill switch implemented for emergency shutdown
- [ ] Logging and monitoring in place for all trades and system events
- [ ] Regulatory requirements reviewed with qualified professional

---

*Skill Version: 1.0 | Created: February 2026*
