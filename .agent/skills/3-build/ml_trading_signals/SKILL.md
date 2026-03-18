---
name: ML Trading Signals
description: Feature engineering for financial data, time series models (LSTM, Transformer, N-BEATS), reinforcement learning for portfolio management (PPO, SAC), alternative data integration, regime detection, ML-based risk models
triggers:
  - /ml-trading
  - /trading-ml
  - /alpha-signals
tools:
  - PyTorch
  - scikit-learn
  - stable-baselines3
  - yfinance
---

# ML Trading Signals

## WHEN TO USE

- Engineering predictive features from OHLCV, fundamentals, or alternative data
- Training time series forecasting models (LSTM, Temporal Fusion Transformer, N-BEATS)
- Applying reinforcement learning agents (PPO, SAC) for portfolio allocation
- Detecting market regimes (risk-on/risk-off, trending/mean-reverting)
- Building ML-based risk models (volatility forecasting, tail risk estimation)

## PROCESS

1. **Collect and align multi-source data**
   ```python
   import yfinance as yf
   df = yf.download("SPY", start="2015-01-01", interval="1d")
   ```

2. **Feature engineering**
   - Technical: RSI, MACD, Bollinger width, ATR, volume z-score
   - Fundamental: earnings surprise, P/E rank, credit spreads
   - Alternative: sentiment scores, satellite data, web traffic
   ```python
   df["rsi_14"] = ta.rsi(df["Close"], length=14)
   df["atr_20"] = ta.atr(df["High"], df["Low"], df["Close"], length=20)
   df["vol_zscore"] = (df["Volume"] - df["Volume"].rolling(60).mean()) / df["Volume"].rolling(60).std()
   ```

3. **Regime detection with Hidden Markov Models**
   ```python
   from hmmlearn.hmm import GaussianHMM
   returns = df["Close"].pct_change().dropna().values.reshape(-1, 1)
   model = GaussianHMM(n_components=3, covariance_type="diag", n_iter=200)
   model.fit(returns)
   regimes = model.predict(returns)
   ```

4. **Train time series model (LSTM example)**
   ```python
   import torch
   import torch.nn as nn

   class AlphaLSTM(nn.Module):
       def __init__(self, input_dim, hidden_dim=64):
           super().__init__()
           self.lstm = nn.LSTM(input_dim, hidden_dim, batch_first=True, num_layers=2)
           self.head = nn.Linear(hidden_dim, 1)
       def forward(self, x):
           out, _ = self.lstm(x)
           return self.head(out[:, -1, :])
   ```

5. **Reinforcement learning for portfolio management**
   ```python
   from stable_baselines3 import PPO
   from stable_baselines3.common.vec_env import DummyVecEnv
   # TradingEnv wraps gym.Env with observation=features, action=portfolio weights
   env = DummyVecEnv([lambda: TradingEnv(df)])
   agent = PPO("MlpPolicy", env, learning_rate=3e-4, verbose=1)
   agent.learn(total_timesteps=500_000)
   ```

6. **Purged k-fold cross-validation**
   - Use purged group time-series split to prevent leakage
   - Embargo period between train/test folds >= max feature lookback

7. **Signal deployment and monitoring**
   - Export model to ONNX or TorchScript for inference latency
   - Track feature drift with PSI (Population Stability Index)
   - Log prediction distribution daily for regime shift alerts

## CHECKLIST

- [ ] No future data leakage in features (all lookbacks use `.shift(1)` minimum)
- [ ] Purged cross-validation with embargo period applied
- [ ] Hyperparameter tuning done on validation set, not test set
- [ ] Model performance reported on true out-of-sample window
- [ ] Feature importance analyzed (SHAP or permutation importance)
- [ ] Regime detector tested for stability across market cycles
- [ ] RL reward function penalizes drawdown, not just returns
- [ ] Inference latency measured and acceptable for target frequency

## Related Skills

- [quantitative_trading_strategies](../quantitative_trading_strategies/SKILL.md) -- Factor models and stat-arb frameworks
- [ml_pipeline](../ml_pipeline/SKILL.md) -- General ML training and deployment pipelines
