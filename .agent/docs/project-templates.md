# Project Templates

Quick-start structures for common project types. Copy the structure that fits your project.

---

## 🌐 Next.js Full-Stack App

```
my-nextjs-app/
├── .agent/                      ← This framework
│   ├── skills/
│   └── docs/
├── src/
│   ├── app/                     # App router pages
│   │   ├── (auth)/              # Auth group
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── (dashboard)/         # Dashboard group
│   │   │   └── dashboard/
│   │   ├── api/                 # API routes
│   │   │   └── auth/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── ui/                  # Reusable UI
│   │   ├── forms/               # Form components
│   │   └── layout/              # Layout components
│   ├── lib/
│   │   ├── db.ts                # Database client
│   │   ├── auth.ts              # Auth helpers
│   │   └── utils.ts             # Utility functions
│   ├── hooks/                   # Custom hooks
│   └── types/                   # TypeScript types
├── prisma/
│   └── schema.prisma
├── public/
├── .env.local
├── .env.example
├── package.json
├── tailwind.config.ts
└── README.md
```

---

## ⚡ Vite + React SPA

```
my-vite-app/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── assets/                  # Static assets
│   ├── components/
│   │   ├── common/              # Shared components
│   │   ├── layout/              # Layout components
│   │   └── features/            # Feature-specific
│   ├── hooks/                   # Custom hooks
│   ├── pages/                   # Page components
│   ├── services/                # API services
│   │   └── api.ts
│   ├── store/                   # State management
│   ├── types/                   # TypeScript types
│   ├── utils/                   # Utilities
│   ├── App.tsx
│   ├── main.tsx
│   └── index.css
├── public/
├── .env
├── .env.example
├── index.html
├── package.json
├── vite.config.ts
└── README.md
```

---

## 🏗️ NestJS Backend API

```
my-nestjs-api/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── common/
│   │   ├── decorators/          # Custom decorators
│   │   ├── filters/             # Exception filters
│   │   ├── guards/              # Auth guards
│   │   ├── interceptors/        # Interceptors
│   │   └── pipes/               # Validation pipes
│   ├── config/
│   │   └── configuration.ts
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.module.ts
│   │   │   └── dto/
│   │   └── users/
│   │       ├── users.controller.ts
│   │       ├── users.service.ts
│   │       ├── users.module.ts
│   │       └── dto/
│   ├── prisma/
│   │   ├── prisma.service.ts
│   │   └── prisma.module.ts
│   ├── app.module.ts
│   └── main.ts
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── test/
├── .env
├── .env.example
├── package.json
└── README.md
```

---

## 🎨 Static Website (Vanilla)

```
my-website/
├── .agent/
│   ├── skills/
│   └── docs/
├── assets/
│   ├── css/
│   │   ├── reset.css
│   │   ├── variables.css
│   │   ├── components.css
│   │   └── main.css
│   ├── js/
│   │   └── main.js
│   ├── images/
│   └── fonts/
├── pages/
│   ├── about.html
│   ├── services.html
│   └── contact.html
├── index.html
├── 404.html
├── robots.txt
├── sitemap.xml
└── README.md
```

---

## 📦 Monorepo (Turborepo)

```
my-monorepo/
├── .agent/
│   ├── skills/
│   └── docs/
├── apps/
│   ├── web/                     # Next.js frontend
│   │   ├── src/
│   │   └── package.json
│   └── api/                     # NestJS backend
│       ├── src/
│       └── package.json
├── packages/
│   ├── ui/                      # Shared UI components
│   │   ├── src/
│   │   └── package.json
│   ├── config/                  # Shared config
│   │   ├── eslint/
│   │   └── typescript/
│   └── utils/                   # Shared utilities
│       ├── src/
│       └── package.json
├── turbo.json
├── package.json
├── pnpm-workspace.yaml
└── README.md
```

---

## 📝 Documentation Site

```
my-docs/
├── .agent/
│   ├── skills/
│   └── docs/
├── docs/
│   ├── getting-started/
│   │   ├── installation.md
│   │   └── quick-start.md
│   ├── guides/
│   │   ├── guide-1.md
│   │   └── guide-2.md
│   └── api/
│       └── reference.md
├── src/                         # Docusaurus/VitePress
│   └── ...
├── static/
│   └── img/
├── docusaurus.config.js         # or vitepress config
├── package.json
└── README.md
```

---

## 🗂️ File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Utilities | camelCase | `formatDate.ts` |
| Hooks | camelCase with `use` | `useAuth.ts` |
| Types | PascalCase | `User.ts` |
| Constants | UPPER_SNAKE | `API_URL` |
| CSS modules | kebab-case | `button-styles.module.css` |
| Folders | kebab-case | `user-profile/` |

---

## ⚙️ Essential Config Files

### .env.example

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Auth
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d

# External APIs
API_KEY=your-api-key

# Environment
NODE_ENV=development
```

### .gitignore (essentials)

```
# Dependencies
node_modules/
.pnpm-store/

# Environment
.env
.env.local
.env.*.local

# Build
dist/
build/
.next/
out/

# IDE
.idea/
.vscode/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/
```

---

## 📈 Trading Algorithm (Python)

```
my-trading-algo/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── data/
│   │   ├── loader.py              # Market data fetching
│   │   ├── providers/
│   │   │   ├── binance.py         # Crypto exchange
│   │   │   ├── alpaca.py          # Stocks/ETFs
│   │   │   └── tradingview.py     # Multi-market
│   │   └── cache.py               # Local data caching
│   ├── indicators/
│   │   ├── moving_averages.py
│   │   ├── oscillators.py
│   │   └── custom/
│   ├── strategies/
│   │   ├── base_strategy.py       # Abstract base
│   │   ├── momentum.py
│   │   └── mean_reversion.py
│   ├── risk/
│   │   ├── position_sizing.py
│   │   ├── stop_loss.py
│   │   └── portfolio.py
│   ├── backtest/
│   │   ├── engine.py              # Backtesting engine
│   │   ├── metrics.py             # Sharpe, drawdown, etc.
│   │   └── visualizer.py          # Equity curves, charts
│   ├── execution/
│   │   ├── broker.py              # Broker interface
│   │   ├── order_manager.py
│   │   └── live_trader.py
│   ├── config.py
│   └── main.py
├── notebooks/
│   ├── research/
│   └── analysis/
├── data/
│   ├── historical/
│   └── processed/
├── tests/
├── .env
├── requirements.txt
└── README.md
```

---

## 🤖 Trading Bot (Python + Async)

```
my-trading-bot/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── core/
│   │   ├── bot.py                 # Main bot class
│   │   ├── event_loop.py          # Async event handling
│   │   └── scheduler.py           # Cron-like scheduling
│   ├── exchange/
│   │   ├── base.py                # Abstract exchange
│   │   ├── binance.py
│   │   ├── coinbase.py
│   │   └── kraken.py
│   ├── strategies/
│   │   ├── base.py
│   │   ├── grid_trading.py
│   │   ├── dca.py                 # Dollar cost average
│   │   └── arbitrage.py
│   ├── signals/
│   │   ├── webhook.py             # TradingView alerts
│   │   ├── telegram.py            # Bot commands
│   │   └── discord.py
│   ├── risk/
│   │   ├── position_manager.py
│   │   ├── circuit_breaker.py     # Emergency stop
│   │   └── exposure.py
│   ├── monitoring/
│   │   ├── logger.py
│   │   ├── metrics.py
│   │   └── alerter.py
│   ├── database/
│   │   ├── models.py
│   │   └── trades_db.py
│   ├── api/
│   │   ├── server.py              # REST API for control
│   │   └── routes/
│   ├── config.py
│   └── main.py
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── tests/
├── .env
├── requirements.txt
└── README.md
```

---

## 📊 TradingView Indicator (Pine Script)

```
my-tradingview-indicator/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── main.pine                  # Main indicator code
│   ├── library/
│   │   ├── math_utils.pine        # Helper functions
│   │   └── plot_utils.pine
│   ├── overlays/                  # Indicators on price
│   │   ├── moving_averages.pine
│   │   ├── support_resistance.pine
│   │   └── trend_lines.pine
│   ├── oscillators/               # Separate pane indicators
│   │   ├── custom_rsi.pine
│   │   ├── momentum.pine
│   │   └── volume_profile.pine
│   └── strategies/                # strategy() scripts
│       ├── backtest_strategy.pine
│       └── alert_strategy.pine
├── docs/
│   ├── usage.md
│   ├── inputs.md                  # Input parameters
│   └── alerts.md                  # Alert setup guide
├── screenshots/
│   ├── chart_example.png
│   └── settings.png
├── versions/
│   ├── v1.0.pine
│   └── v2.0.pine
└── README.md
```

### Pine Script Template

```pine
//@version=5
indicator("My Custom Indicator", overlay=true)

// === INPUTS ===
length = input.int(14, "Length", minval=1)
source = input.source(close, "Source")
show_signals = input.bool(true, "Show Signals")

// === CALCULATIONS ===
ma = ta.sma(source, length)
signal_up = ta.crossover(source, ma)
signal_down = ta.crossunder(source, ma)

// === PLOTS ===
plot(ma, "Moving Average", color=color.blue)

// === SIGNALS ===
plotshape(show_signals and signal_up, "Buy", 
          shape.triangleup, location.belowbar, 
          color=color.green, size=size.small)
plotshape(show_signals and signal_down, "Sell", 
          shape.triangledown, location.abovebar, 
          color=color.red, size=size.small)

// === ALERTS ===
alertcondition(signal_up, "Buy Signal", "Buy: {{ticker}} crossed above MA")
alertcondition(signal_down, "Sell Signal", "Sell: {{ticker}} crossed below MA")
```

---

## 🏦 MT4/MT5 Expert Advisor (MQL)

```
my-expert-advisor/
├── .agent/
│   ├── skills/
│   └── docs/
├── MQL5/
│   ├── Experts/
│   │   └── MyEA/
│   │       ├── MyEA.mq5           # Main EA file
│   │       └── Include/
│   │           ├── TradeManager.mqh
│   │           ├── RiskManager.mqh
│   │           └── SignalEngine.mqh
│   ├── Indicators/
│   │   └── MyIndicator/
│   │       └── CustomIndicator.mq5
│   ├── Include/
│   │   ├── Utils.mqh
│   │   └── Logger.mqh
│   └── Scripts/
│       └── Backtester.mq5
├── Presets/
│   ├── conservative.set
│   ├── aggressive.set
│   └── default.set
├── Backtests/
│   └── results/
├── docs/
│   ├── installation.md
│   ├── settings.md
│   └── strategy.md
└── README.md
```

---

## 🪙 ERC-20 Token (Solidity + Hardhat)

```
my-token/
├── .agent/
│   ├── skills/
│   └── docs/
├── contracts/
│   ├── Token.sol                  # Main ERC-20 contract
│   ├── Staking.sol                # Optional: Staking mechanism
│   ├── Vesting.sol                # Optional: Token vesting
│   └── interfaces/
│       └── IToken.sol
├── scripts/
│   ├── deploy.ts                  # Deployment script
│   ├── verify.ts                  # Etherscan verification
│   └── tasks/
│       ├── mint.ts
│       └── transfer.ts
├── test/
│   ├── Token.test.ts
│   ├── Staking.test.ts
│   └── fixtures/
├── ignition/                      # Hardhat Ignition modules
│   └── modules/
│       └── Token.ts
├── .env                           # RPC URLs, private keys
├── .env.example
├── hardhat.config.ts
├── package.json
├── tsconfig.json
└── README.md
```

### Solidity Token Template

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1B tokens
    
    constructor() ERC20("My Token", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, MAX_SUPPLY);
    }
    
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
```

---

## 🎨 NFT Collection (Solidity + Hardhat)

```
my-nft-collection/
├── .agent/
│   ├── skills/
│   └── docs/
├── contracts/
│   ├── NFT.sol                    # Main ERC-721 contract
│   ├── NFTMarketplace.sol         # Optional: Marketplace
│   └── interfaces/
│       └── INFT.sol
├── scripts/
│   ├── deploy.ts
│   ├── mint.ts
│   ├── reveal.ts                  # For reveal mechanics
│   └── upload-metadata.ts         # IPFS upload
├── test/
│   ├── NFT.test.ts
│   └── Marketplace.test.ts
├── assets/
│   ├── images/                    # 10000 images
│   └── metadata/                  # JSON metadata
├── frontend/                      # Minting dApp
│   ├── src/
│   │   ├── app/
│   │   ├── components/
│   │   │   ├── MintButton.tsx
│   │   │   ├── WalletConnect.tsx
│   │   │   └── NFTGallery.tsx
│   │   ├── hooks/
│   │   │   └── useContract.ts
│   │   └── lib/
│   │       └── wagmi.ts
│   ├── package.json
│   └── next.config.js
├── .env
├── hardhat.config.ts
├── package.json
└── README.md
```

### NFT Contract Template

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.05 ether;
    uint256 private _tokenIds;
    string private _baseTokenURI;
    
    constructor() ERC721("My NFT Collection", "MNFT") Ownable(msg.sender) {}
    
    function mint(uint256 quantity) external payable {
        require(_tokenIds + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= MINT_PRICE * quantity, "Insufficient payment");
        
        for (uint256 i = 0; i < quantity; i++) {
            _tokenIds++;
            _safeMint(msg.sender, _tokenIds);
        }
    }
    
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
    
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
```

---

## 🌐 dApp (Solidity + Next.js + wagmi)

```
my-dapp/
├── .agent/
│   ├── skills/
│   └── docs/
├── contracts/
│   ├── Protocol.sol               # Main protocol contract
│   ├── Governance.sol             # Optional: DAO voting
│   └── Treasury.sol               # Optional: Treasury
├── scripts/
│   ├── deploy.ts
│   └── tasks/
├── test/
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx           # Landing
│   │   │   ├── dashboard/         # User dashboard
│   │   │   └── admin/             # Admin panel
│   │   ├── components/
│   │   │   ├── WalletButton.tsx
│   │   │   ├── TransactionButton.tsx
│   │   │   └── NetworkSwitcher.tsx
│   │   ├── hooks/
│   │   │   ├── useContract.ts
│   │   │   ├── useBalance.ts
│   │   │   └── useTransaction.ts
│   │   ├── lib/
│   │   │   ├── wagmi.ts           # wagmi config
│   │   │   ├── contracts.ts       # ABI imports
│   │   │   └── chains.ts          # Supported chains
│   │   └── providers/
│   │       └── Web3Provider.tsx
│   ├── public/
│   ├── .env.local
│   ├── package.json
│   └── next.config.js
├── subgraph/                      # Optional: The Graph
│   ├── schema.graphql
│   ├── subgraph.yaml
│   └── src/
│       └── mapping.ts
├── .env
├── hardhat.config.ts
├── package.json
└── README.md
```

---

## 🤖 AI Agent (Python + LangChain)

```
my-ai-agent/
├── .agent/
│   ├── skills/
│   └── docs/
├── src/
│   ├── agent/
│   │   ├── main.py                # Agent entry point
│   │   ├── prompts.py             # System prompts
│   │   └── tools/                 # Custom tools
│   │       ├── search.py
│   │       ├── calculator.py
│   │       └── database.py
│   ├── chains/
│   │   ├── qa_chain.py            # Q&A chain
│   │   ├── summarize_chain.py
│   │   └── router_chain.py
│   ├── memory/
│   │   ├── conversation.py
│   │   └── vector_store.py
│   ├── loaders/
│   │   ├── pdf_loader.py
│   │   ├── web_loader.py
│   │   └── database_loader.py
│   ├── embeddings/
│   │   └── embedder.py
│   ├── api/
│   │   ├── server.py              # FastAPI server
│   │   └── routes/
│   ├── config.py
│   └── main.py
├── data/
│   ├── documents/
│   └── vector_db/
├── notebooks/
├── tests/
├── .env
├── requirements.txt
├── docker-compose.yml
└── README.md
```

---

*Pick a template. Start building.*

**If it's code, Antigravity can build it.** 🚀
