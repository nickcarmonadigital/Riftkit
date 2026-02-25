# Project Templates & Blueprints

> **Quick-Start Reference** — Choose the right blueprint for your project type and get building.

The `.agent/blueprints/` directory contains starter templates for common project types. Each blueprint includes a `starter-context.md` that configures your AI assistant with the right tech stack, architecture patterns, and project structure.

---

## Choosing the Right Blueprint

```
What are you building?
│
├── A web application with users, data, and APIs?
│   └── 01-web-and-apps/full-stack-app
│
├── A marketing site or landing page?
│   └── 01-web-and-apps/marketing-sites
│
├── A Chrome extension or browser tool?
│   └── 01-web-and-apps/chrome-extensions (or 08-plugins/chrome-extensions)
│
├── A game?
│   ├── For the web (browser)? → 02-games/web-games
│   ├── For mobile? → 02-games/mobile-games
│   └── For PC/console? → 02-games/steam-pc-games or console-games
│
├── A trading bot or financial tool?
│   ├── Algorithmic trading? → 03-trading/trading-algorithms
│   ├── TradingView indicator? → 03-trading/tradingview-indicators
│   └── DeFi protocol? → 03-trading/defi-protocols
│
├── A blockchain/Web3 project?
│   ├── Smart contract? → 04-web3/smart-contract-auditing
│   ├── dApp? → 04-web3/dapp
│   ├── NFT collection/marketplace? → 04-web3/nft-collection
│   └── Token or DAO? → 04-web3/custom-crypto-token or dao
│
├── An AI/ML project?
│   ├── RAG application? → 05-ai-ml/rag-application
│   ├── Chatbot/agent? → 05-ai-ml/ai-agent-chatbot
│   ├── ML model training? → 05-ai-ml/ml-model-training
│   └── Data pipeline? → 05-ai-ml/data-pipeline
│
├── A hardware/IoT project?
│   ├── Arduino/ESP32? → 06-hardware/arduino-projects or esp32-esp8266
│   ├── Raspberry Pi? → 06-hardware/raspberry-pi
│   └── Home automation? → 06-hardware/home-automation
│
├── DevOps/automation?
│   ├── CI/CD pipelines? → 07-automation/ci-cd-pipelines
│   ├── Infrastructure as Code? → 07-automation/infrastructure-as-code
│   └── Shell scripts/automation? → 07-automation/shell-scripts
│
├── A plugin or extension?
│   ├── VS Code? → 08-plugins/vs-code-extensions
│   ├── Shopify? → 08-plugins/shopify-apps
│   ├── Slack/Discord bot? → 08-plugins/slack-discord-bots
│   └── WordPress? → 08-plugins/wordpress-plugins
│
└── A data/analytics project?
    ├── Dashboard? → 09-data/data-dashboards
    ├── ETL pipeline? → 09-data/etl-pipelines
    └── Web scraper? → 09-data/scraping-crawling
```

---

## All Blueprint Categories

### 01 — Web and Apps

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **full-stack-app** | Next.js / React + NestJS + Supabase + Tailwind | SaaS products, dashboards, internal tools |
| **marketing-sites** | Astro / Next.js + Tailwind | Landing pages, company sites, portfolios |
| **static-websites** | Astro / Hugo / Eleventy | Blogs, documentation sites, simple content |
| **e-commerce** | Next.js + Stripe + Supabase | Online stores, marketplaces |
| **mobile-apps** | React Native / Expo | iOS and Android apps |
| **desktop-apps** | Electron / Tauri | Desktop applications |
| **chrome-extensions** | React + Chrome APIs | Browser extensions |
| **cli-tools** | Node.js + Commander.js | Terminal tools and utilities |
| **wordpress-themes** | PHP + WordPress | Custom WordPress themes |

### 02 — Games

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **web-games** | Phaser / Three.js / PlayCanvas | Browser-based games |
| **mobile-games** | Unity (C#) / Godot (GDScript) | Mobile game development |
| **steam-pc-games** | Unity / Unreal / Godot | PC game distribution via Steam |
| **console-games** | Unity / Unreal | PlayStation, Xbox, Switch |

### 03 — Trading and Finance

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **trading-algorithms** | Python + Pandas + NumPy | Algorithmic trading strategies |
| **trading-bots** | Python / Node.js + Exchange APIs | Automated trading execution |
| **tradingview-indicators** | Pine Script | Custom TradingView indicators |
| **mt4-mt5-expert-advisors** | MQL4/MQL5 | MetaTrader automated strategies |
| **defi-protocols** | Solidity + Hardhat | DeFi protocol development |
| **quantitative-research** | Python + Jupyter | Quantitative analysis and backtesting |

### 04 — Web3 and Blockchain

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **dapp** | React + Ethers.js / Wagmi + Solidity | Decentralized applications |
| **smart-contract-auditing** | Solidity + Foundry/Hardhat | Smart contract development and security |
| **nft-collection** | Solidity + IPFS + React | NFT minting and display |
| **nft-marketplace** | React + Solidity + The Graph | NFT trading platform |
| **custom-crypto-token** | Solidity (ERC-20/ERC-721) | Token creation and deployment |
| **dao** | Solidity + Aragon/Snapshot | Decentralized governance |
| **wallet** | React Native + WalletConnect | Cryptocurrency wallets |
| **blockchain-explorer** | React + Etherscan API | Chain data visualization |
| **layer-2-solutions** | Solidity + L2 SDKs | Scaling solutions |

### 05 — AI and ML

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **rag-application** | LangChain / LlamaIndex + pgvector | AI-powered search and Q&A |
| **ai-agent-chatbot** | LangChain / Claude SDK + React | Conversational AI interfaces |
| **ml-model-training** | Python + PyTorch/TensorFlow | Custom model training |
| **fine-tuning-pipeline** | Python + Hugging Face | Fine-tuning existing models |
| **data-pipeline** | Python + Apache Airflow | Data processing workflows |
| **computer-vision** | Python + OpenCV + YOLO | Image/video analysis |
| **recommendation-system** | Python + collaborative filtering | Content/product recommendations |
| **voice-ai** | Whisper + TTS + streaming | Voice-enabled applications |

### 06 — Hardware and IoT

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **arduino-projects** | C++ + Arduino IDE | Microcontroller projects |
| **esp32-esp8266** | C++ + PlatformIO | WiFi-enabled IoT devices |
| **raspberry-pi** | Python + GPIO | Single-board computer projects |
| **home-automation** | Home Assistant + MQTT | Smart home systems |
| **robotics** | ROS + Python/C++ | Robot control systems |
| **drone-uav** | PX4/ArduPilot | Drone flight controllers |
| **wearables** | Embedded C + BLE | Wearable device firmware |
| **3d-printer-firmware** | Marlin / Klipper | 3D printer customization |

### 07 — Automation and DevOps

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **ci-cd-pipelines** | GitHub Actions / GitLab CI | Automated build and deploy |
| **infrastructure-as-code** | Terraform / Pulumi / CDK | Cloud resource management |
| **kubernetes-configs** | K8s manifests / Helm charts | Container orchestration |
| **serverless-functions** | AWS Lambda / Vercel Functions | Event-driven compute |
| **monitoring-dashboards** | Grafana + Prometheus | System observability |
| **shell-scripts** | Bash / Zsh | System automation |

### 08 — Plugins and Extensions

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **vs-code-extensions** | TypeScript + VS Code API | Editor extensions |
| **chrome-extensions** | React/Vanilla + Chrome APIs | Browser tools |
| **shopify-apps** | React + Shopify API | E-commerce plugins |
| **slack-discord-bots** | Node.js + Bot SDKs | Team communication bots |
| **wordpress-plugins** | PHP + WordPress Plugin API | WordPress functionality |
| **figma-plugins** | TypeScript + Figma API | Design tool extensions |
| **obs-plugins** | C/Lua + OBS API | Streaming software plugins |
| **vst-audio-plugins** | C++ + JUCE | Audio processing plugins |

### 09 — Data and Analytics

| Blueprint | Stack | When to Use |
|-----------|-------|-------------|
| **data-dashboards** | React + D3.js / Recharts | Data visualization |
| **etl-pipelines** | Python + Apache Airflow/dbt | Data transformation |
| **reporting-systems** | Python + Pandas + PDF generation | Automated reports |
| **database-design** | PostgreSQL / MongoDB | Database architecture |
| **scraping-crawling** | Python + Scrapy / Puppeteer | Web data extraction |

---

## How to Use a Blueprint

1. Navigate to `.agent/blueprints/[Category]/[Blueprint]/`
2. Copy the `starter-context.md` content
3. Paste it into your project's `.agent/docs/0-context/project-context.md`
4. Customize the tech stack, features, and architecture for your specific needs
5. Run the `new_project` skill to scaffold the project

> **Note**: Most blueprint directories are empty scaffolds awaiting `starter-context.md` files. The `01-web-and-apps/full-stack-app/` blueprint is the only one with content. Contributions welcome for other categories.

---

## Customizing Blueprints

Every blueprint is a starting point, not a rigid template. Common customizations:

| Default | Alternative | When |
|---------|------------|------|
| Next.js | Vite + React | No SSR needed, pure SPA |
| Supabase | NestJS + Prisma + PostgreSQL | Full backend control needed |
| Tailwind | Styled Components / CSS Modules | Team prefers CSS-in-JS |
| GitHub Actions | GitLab CI / CircleCI | Different Git platform |
| Vercel | Railway / Fly.io / AWS | Different hosting needs |
