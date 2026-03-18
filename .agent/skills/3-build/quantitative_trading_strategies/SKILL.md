---
name: Quantitative Trading Strategies
description: Factor models (Fama-French, momentum, mean reversion), statistical arbitrage, pairs trading, alpha research methodology, signal combination, transaction cost modeling, slippage estimation
triggers:
  - /quant-trading
  - /quant-strategies
  - /factor-models
tools:
  - QuantConnect
  - Zipline
  - vectorbt
---

# Quantitative Trading Strategies

## WHEN TO USE

- Designing or evaluating systematic trading strategies based on quantitative signals
- Building factor models (value, momentum, quality, low volatility, mean reversion)
- Implementing statistical arbitrage or pairs trading systems
- Researching new alpha sources and combining signals into composite scores
- Modeling transaction costs, slippage, and market impact for realistic P&L estimation

## PROCESS

1. **Define the investment universe and data pipeline**
   - Pull price/fundamental data via yfinance or a vendor API
   - Clean for splits, dividends, survivorship bias
   ```python
   import vectorbt as vbt
   data = vbt.YFData.download(["AAPL", "MSFT", "GOOG"], start="2018-01-01").get("Close")
   ```

2. **Construct factor exposures**
   - Compute cross-sectional factor scores (e.g., 12-1 month momentum, book-to-market)
   ```python
   momentum = data.pct_change(252).shift(21)  # 12-1 month momentum
   z_scores = (momentum - momentum.mean(axis=1, keepdims=True)) / momentum.std(axis=1, keepdims=True)
   ```

3. **Build signal combination and portfolio weights**
   - Rank or z-score normalize each factor, then blend with equal or optimized weights
   - Apply gross/net exposure constraints and sector neutralization

4. **Model transaction costs and slippage**
   - Estimate spread cost as a function of ADV; add fixed commission per share
   ```python
   spread_cost_bps = 5  # basis points half-spread
   turnover = weights.diff().abs().sum(axis=1)
   tc_drag = turnover * spread_cost_bps / 10000
   ```

5. **Run vectorbt or Zipline backtest**
   ```python
   pf = vbt.Portfolio.from_signals(data, entries=z_scores > 1.5, exits=z_scores < 0,
                                    fees=0.001, freq="1D")
   print(pf.stats())
   ```

6. **Evaluate with pairs trading / stat-arb lens**
   - Cointegration test (Engle-Granger or Johansen) for pair selection
   - Z-score of spread as entry/exit trigger

7. **Iterate on alpha research**
   - Information coefficient (IC) analysis per factor
   - Decay analysis to measure signal half-life
   - Combine top factors using IC-weighted blending

## CHECKLIST

- [ ] Universe free of survivorship bias (include delisted tickers)
- [ ] Factor scores computed cross-sectionally, not time-series only
- [ ] Transaction cost model calibrated to realistic spread + commission
- [ ] Slippage estimate accounts for order size vs. ADV
- [ ] Signal combination tested for multicollinearity between factors
- [ ] Out-of-sample period reserved (minimum 20% of data)
- [ ] Turnover and capacity constraints documented
- [ ] Strategy Sharpe, max drawdown, and Calmar ratio logged

## Related Skills

- [ml_trading_signals](../ml_trading_signals/SKILL.md) -- ML-based alpha generation and regime detection
- [trading_systems](../trading_systems/SKILL.md) -- Live execution infrastructure and order management
