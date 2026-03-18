---
name: portfolio_risk_management
description: Portfolio construction and risk management using Modern Portfolio Theory, Black-Litterman, risk parity, VaR/CVaR, Kelly criterion sizing, and stress testing
triggers:
  - /portfolio-risk
  - /risk-management
  - /position-sizing
---

# Portfolio Risk Management

## WHEN TO USE

Use this skill when building portfolio optimization pipelines, computing risk metrics (VaR, CVaR, max drawdown), sizing positions via Kelly criterion, constructing correlation/covariance matrices, running stress tests or Monte Carlo simulations, or implementing rebalancing algorithms.

## PROCESS

1. **Gather universe and return data** — pull historical prices via `yfinance` or a broker API, compute log returns, and clean for survivorship bias.

2. **Build covariance and correlation matrices** — use Ledoit-Wolf shrinkage or the Oracle Approximating Shrinkage estimator to stabilize estimates.
   ```python
   from pypfopt import risk_models
   cov_matrix = risk_models.CovarianceShrinkage(prices).ledoit_wolf()
   ```

3. **Select optimization objective** — choose from mean-variance (Markowitz), Black-Litterman (with investor views), risk parity, or min-CVaR.
   ```python
   from pypfopt import BlackLittermanModel, EfficientFrontier
   bl = BlackLittermanModel(cov_matrix, pi=market_prior, Q=views, P=pick_matrix)
   rets = bl.bl_returns()
   ef = EfficientFrontier(rets, cov_matrix)
   weights = ef.max_sharpe()
   ```

4. **Compute risk metrics** — calculate VaR (parametric + historical), CVaR, max drawdown, and Sortino ratio.
   ```python
   import riskfolio as rp
   port = rp.Portfolio(returns=returns_df)
   port.assets_stats(method_mu="hist", method_cov="ledoit")
   var_95 = port.returns.quantile(0.05)
   cvar_95 = port.returns[port.returns <= var_95].mean()
   ```

5. **Apply position sizing** — use fractional Kelly criterion (half-Kelly recommended) to convert edge estimates into allocation percentages.
   ```python
   def half_kelly(win_rate, win_loss_ratio):
       kelly = win_rate - (1 - win_rate) / win_loss_ratio
       return max(kelly / 2, 0)
   ```

6. **Stress test the portfolio** — run Monte Carlo simulation and replay historical crisis scenarios (2008, 2020-COVID, 2022 rate shock).
   ```python
   from scipy.stats import norm
   simulated = norm.rvs(loc=mu, scale=sigma, size=(10000, horizon))
   drawdowns = (simulated.cummax(axis=1) - simulated) / simulated.cummax(axis=1)
   ```

7. **Implement rebalancing** — set calendar-based (monthly/quarterly) or threshold-based (5% drift) triggers, log every rebalance with before/after weights.

8. **Validate and deploy** — backtest with `vectorbt` or `zipline-reloaded`, compare Sharpe/Sortino/Calmar against benchmarks, then schedule via cron or PM2.

## CHECKLIST

- [ ] Return data cleaned: no NaNs, adjusted for splits/dividends
- [ ] Covariance matrix uses shrinkage estimator (not raw sample)
- [ ] Optimization constraints set: max weight per asset, sector limits
- [ ] VaR and CVaR computed at 95% and 99% confidence
- [ ] Kelly sizing uses half-Kelly or smaller fraction
- [ ] Stress tests cover at least 3 historical crisis periods
- [ ] Rebalancing logic handles transaction costs and slippage
- [ ] Backtest shows out-of-sample performance, not just in-sample

## Related Skills

- `quantitative_trading_strategies` — signal generation and execution logic
- `ml_trading_signals` — ML-based alpha signals feeding into this portfolio layer
