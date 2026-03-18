---
name: Backtesting Methodology
description: Rigorous backtesting with walk-forward optimization, Monte Carlo simulation, out-of-sample testing, bias detection (lookahead, survivorship, selection), performance metrics (Sharpe, Sortino, Calmar, max drawdown), statistical significance
triggers:
  - /backtest
  - /backtesting
  - /strategy-validation
tools:
  - Backtrader
  - vectorbt
  - QuantConnect
---

# Backtesting Methodology

## WHEN TO USE

- Validating a new trading strategy before allocating capital
- Auditing an existing backtest for common biases (lookahead, survivorship, selection)
- Running walk-forward optimization to prevent overfitting
- Stress-testing strategy robustness with Monte Carlo simulation
- Comparing strategy variants with statistically significant metrics

## PROCESS

1. **Define the test harness and data splits**
   - In-sample (IS): parameter fitting and signal tuning
   - Out-of-sample (OOS): final evaluation, never touched during development
   - Reserve at least 20% of total data for OOS
   ```python
   split_idx = int(len(data) * 0.8)
   is_data, oos_data = data[:split_idx], data[split_idx:]
   ```

2. **Run bias audit before backtesting**
   - Lookahead: verify no feature uses future data (`shift(1)` on all inputs)
   - Survivorship: confirm universe includes delisted securities
   - Selection: document why this universe/timeframe was chosen pre-test
   ```python
   # Quick lookahead check: correlate signal at t with return at t (should be ~0)
   spurious_corr = signal.corrwith(returns)  # flag if |corr| > 0.3
   ```

3. **Implement the strategy in Backtrader or vectorbt**
   ```python
   import backtrader as bt

   class MeanReversionStrategy(bt.Strategy):
       params = (("lookback", 20), ("entry_z", -2.0), ("exit_z", 0.0))
       def __init__(self):
           self.zscore = bt.ind.ZScore(self.data.close, period=self.p.lookback)
       def next(self):
           if self.zscore[0] < self.p.entry_z and not self.position:
               self.buy(size=self.broker.getvalue() * 0.02 / self.data.close[0])
           elif self.zscore[0] > self.p.exit_z and self.position:
               self.close()

   cerebro = bt.Cerebro()
   cerebro.addstrategy(MeanReversionStrategy)
   cerebro.adddata(bt.feeds.PandasData(dataname=is_data))
   cerebro.broker.setcash(100_000)
   cerebro.broker.setcommission(commission=0.001)
   results = cerebro.run()
   ```

4. **Walk-forward optimization**
   - Split IS into rolling windows (e.g., 252-day train, 63-day test)
   - Optimize parameters on each train window, apply to test window
   - Concatenate test-window returns for aggregate performance
   ```python
   import vectorbt as vbt
   pf = vbt.Portfolio.from_signals(data, entries, exits, fees=0.001, freq="1D")
   # Use vbt's built-in split methods for anchored walk-forward
   (in_sample, out_sample) = data.vbt.rolling_split(window_len=252, set_lens=(189, 63))
   ```

5. **Monte Carlo simulation for robustness**
   - Shuffle daily returns (bootstrap) to generate 10,000 synthetic equity curves
   - Compute confidence intervals on Sharpe, max drawdown, CAGR
   ```python
   import numpy as np
   daily_returns = pf.returns().values
   mc_sharpes = []
   for _ in range(10_000):
       shuffled = np.random.choice(daily_returns, size=len(daily_returns), replace=True)
       mc_sharpes.append(np.mean(shuffled) / np.std(shuffled) * np.sqrt(252))
   ci_lower, ci_upper = np.percentile(mc_sharpes, [5, 95])
   ```

6. **Compute performance metrics on OOS data**
   ```python
   sharpe = pf.sharpe_ratio()
   sortino = pf.sortino_ratio()
   calmar = pf.calmar_ratio()
   max_dd = pf.max_drawdown()
   print(f"Sharpe={sharpe:.2f} Sortino={sortino:.2f} Calmar={calmar:.2f} MaxDD={max_dd:.2%}")
   ```

7. **Statistical significance test**
   - Apply the Deflated Sharpe Ratio (DSR) to account for multiple testing
   - Strategy passes if DSR p-value < 0.05

## CHECKLIST

- [ ] Lookahead bias audit passed (no future data in features or signals)
- [ ] Survivorship bias addressed (delisted securities included)
- [ ] Selection bias documented (universe and timeframe justified pre-test)
- [ ] Walk-forward optimization used instead of single in-sample fit
- [ ] Monte Carlo 5th-percentile Sharpe > 0 (strategy survives randomization)
- [ ] OOS performance within 30% of IS performance (no severe overfit)
- [ ] Transaction costs and slippage modeled realistically
- [ ] Deflated Sharpe Ratio p-value < 0.05
- [ ] Maximum drawdown acceptable for target risk budget
- [ ] Results reproducible with fixed random seeds

## Related Skills

- [quantitative_trading_strategies](../../3-build/quantitative_trading_strategies/SKILL.md) -- Factor model and stat-arb strategy design
- [performance_testing](../performance_testing/SKILL.md) -- General system and load testing methodology
