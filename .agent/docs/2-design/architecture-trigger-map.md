# Architecture Trigger Map

> **You don't need to memorize every technology. You need to recognize the symptoms that tell you when a technology is needed.**

This document teaches the **WHEN**, not the HOW. When you recognize a trigger pattern, hand it to your AI tool with the suggested prompt. The AI has the domain knowledge to implement it — your job is recognizing the signal.

**How to use this document:**
1. During the **design phase**, scan the universal triggers for patterns that apply to your project
2. Then scan the **domain-specific section** matching your blueprint category
3. When you recognize a trigger during development, use the "Ask AI" prompt to get implementation guidance
4. Not every trigger applies to every project — skip what doesn't match your context

---

## Part 1: Universal Triggers (All Project Types)

These patterns apply regardless of what you're building. Organized by the **symptom you'll observe**, not the technology you'll use.

---

### 1.1 Performance & Speed

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 1 | Same data requested repeatedly, responses feel slow | **Caching** (Redis, in-memory, HTTP cache) | "Which endpoints in my app serve the same data repeatedly? Design a caching strategy with TTLs and invalidation rules." |
| 2 | API responses contain way more data than the frontend uses | **Field selection / sparse fieldsets** | "Analyze my API responses — am I over-fetching? Should I add field selection or switch to GraphQL?" |
| 3 | Database queries getting slower as data grows | **Indexing & query optimization** | "Run EXPLAIN ANALYZE on my slowest queries. Which indexes am I missing? Are there N+1 problems?" |
| 4 | Page loads feel slow, especially on mobile | **Code splitting & lazy loading** | "Audit my bundle size. What can be lazy-loaded? Which dependencies are bloating the build?" |
| 5 | Images and static files loading slowly | **CDN & image optimization** | "Set up a CDN strategy for my static assets. Which images should be converted to WebP? Where should I add lazy loading?" |
| 6 | API response times spike during traffic surges | **Load balancing & auto-scaling** | "My server can't handle peak traffic. Design a scaling strategy — horizontal scaling, load balancer config, and connection pooling." |
| 7 | One slow operation blocks the entire request | **Async processing / background jobs** | "Which operations in this request don't need to complete before responding to the user? Move them to a background job." |
| 8 | Server CPU at 100% during specific operations | **Worker threads / offloading** | "This computation is CPU-intensive and blocking the event loop. Should I use worker threads, a job queue, or a separate service?" |
| 9 | Third-party API calls making your app slow | **External call optimization** | "This third-party API is slow. Should I cache responses, add a circuit breaker, make calls async, or batch requests?" |
| 10 | First page load is fast but navigation between pages is slow | **Prefetching & client-side caching** | "Add route prefetching and client-side data caching so navigation between pages feels instant." |

---

### 1.2 Scale & Load

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 11 | Single database server struggling under load | **Read replicas / connection pooling** | "My database is the bottleneck. Should I add read replicas, connection pooling, or both? What's the Prisma config?" |
| 12 | File storage growing beyond server disk | **Object storage** (S3, GCS, R2) | "Design a file storage strategy using object storage. Where should uploaded files live? How do I serve them?" |
| 13 | Users worldwide, some experiencing high latency | **Multi-region / edge computing** | "My users are global but my server is in one region. What's the simplest path to reduce latency for international users?" |
| 14 | Database writes overwhelming the system | **Write optimization / event sourcing** | "Too many writes are hitting my database at once. Should I batch writes, use a write-ahead queue, or consider event sourcing?" |
| 15 | Session data lost when servers restart or scale | **External session store** | "User sessions are lost on redeploy. Move session storage to Redis or a database so sessions survive restarts and work across multiple servers." |
| 16 | Configuration is different across environments and causing bugs | **Config management** | "My dev/staging/prod configs keep diverging. Set up a proper config management system with validation at startup." |
| 17 | Costs increasing linearly with every new user | **Cost optimization / resource efficiency** | "My infrastructure costs scale linearly with users. Where are the biggest cost drivers and what architectural changes would flatten the curve?" |

---

### 1.3 Real-Time & Live Updates

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 18 | Users need to see changes without refreshing the page | **WebSockets / Server-Sent Events** | "Users need live updates for [feature]. What's the simplest real-time approach for my stack — WebSockets, SSE, or polling?" |
| 19 | Multiple users editing the same data simultaneously | **Conflict resolution / CRDTs** | "Two users can edit the same [resource] at the same time. How do I handle conflicts — last-write-wins, optimistic locking, or real-time collaboration?" |
| 20 | Chat or messaging feature needed | **WebSocket rooms / pub-sub** | "Design a real-time chat system. How should I structure WebSocket rooms, message delivery, and message persistence?" |
| 21 | Users need instant notifications (not email) | **Push notifications** | "Add real-time in-app notifications. What's the notification delivery architecture — WebSocket channel, push API, or both?" |
| 22 | Long-running operation with no feedback to user | **Progress tracking / SSE** | "This operation takes 30+ seconds. Add a progress indicator using Server-Sent Events so users know it's working." |
| 23 | Collaborative features where users see each other's cursors/presence | **Presence system** | "Add user presence (who's online, who's viewing this page). What's the simplest architecture for presence tracking?" |

---

### 1.4 Data & Storage

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 24 | Users need to upload files, images, or documents | **File upload pipeline** | "Design the file upload flow — signed URLs, size limits, type validation, virus scanning, and storage location." |
| 25 | Search bar returns irrelevant results or is slow | **Full-text search** | "My LIKE-query search is slow and inaccurate. When do I need PostgreSQL full-text search vs Elasticsearch vs Algolia? What fits my scale?" |
| 26 | Need to track who changed what and when | **Audit trail / event log** | "Add an audit trail for [resource]. Should I use database triggers, application-level logging, or event sourcing?" |
| 27 | Reports and analytics queries slowing down the main app | **Read-optimized views / data warehouse** | "Analytics queries are competing with app queries. Should I use materialized views, a read replica, or a separate analytics database?" |
| 28 | Data relationships are deeply nested and complex to query | **Query strategy reassessment** | "My queries have 5+ joins and are getting complex. Should I denormalize, use a graph database, or restructure my data model?" |
| 29 | Sensitive data (PII, payments) stored in plain text | **Encryption at rest / field-level encryption** | "Audit my database for sensitive data stored in plain text. What needs encryption at rest? What needs field-level encryption?" |
| 30 | Need to roll back to a previous state of data | **Soft deletes / versioning / point-in-time recovery** | "Users need to undo changes and recover deleted items. Design a versioning or soft-delete strategy for [resource]." |
| 31 | Data growing fast, old data rarely accessed | **Data archival / partitioning** | "My main table has millions of rows but only recent data is accessed. Should I partition by date, archive old data, or both?" |

---

### 1.5 Async & Background Processing

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 32 | Sending emails is making API responses slow | **Email queue** | "Move all email sending to a background job queue. Set up the queue, worker, retry logic, and failure handling." |
| 33 | Need to generate PDFs, reports, or exports | **Async document generation** | "Report generation takes 10+ seconds. Move it to a background job with progress tracking and download notification." |
| 34 | Webhooks need to be delivered reliably to external services | **Webhook delivery queue** | "Design a reliable webhook delivery system with retries, exponential backoff, and dead letter handling." |
| 35 | Need to run tasks on a schedule (daily cleanup, weekly reports) | **Scheduled jobs / cron** | "Set up scheduled tasks for [list tasks]. What's the best approach — node-cron, database scheduler, or external cron service?" |
| 36 | Bulk operations timing out (import 10k records, mass update) | **Batch processing / chunking** | "This bulk operation times out. Design a chunked processing approach with progress tracking and error recovery." |
| 37 | Third-party API has rate limits you keep hitting | **Request queue with rate control** | "I keep hitting [service]'s rate limit. Set up a request queue that respects their rate limits with proper spacing and retry logic." |

---

### 1.6 Security & Trust Boundaries

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 38 | User input being used in queries, HTML, or shell commands | **Input validation & sanitization** | "Audit all user input paths in my app. Where am I vulnerable to injection (SQL, XSS, command)? Add validation using Zod/class-validator." |
| 39 | Different user types need different permissions | **RBAC / ABAC** | "Design a role-based access control system. What roles exist, what can each role do, and how do I enforce it at the API level?" |
| 40 | Sensitive operation needs extra verification | **Multi-factor authentication** | "Add MFA for [sensitive operations]. What's the simplest approach — TOTP, SMS, or email verification codes?" |
| 41 | API is publicly accessible on the internet | **API security hardening** | "Harden my public API — rate limiting, API keys, CORS config, request size limits, and abuse detection." |
| 42 | Handling credit cards or payment data | **PCI compliance / tokenization** | "I need to handle payments. Design a PCI-compliant flow using a payment processor so I never touch raw card data." |
| 43 | Secrets (API keys, passwords) scattered in code or env files | **Secret management** | "Audit my codebase for hardcoded secrets. Design a secret management approach — environment variables, Vault, or cloud secret manager." |
| 44 | Users staying logged in forever, no session expiry | **Session management & token rotation** | "Audit my auth flow — are tokens expiring? Is refresh token rotation implemented? Can sessions be revoked?" |
| 45 | Data leaving your system to third-party services | **Data flow audit** | "Map every place my user data leaves my system. Which third parties receive PII? Do I have DPAs in place? Am I GDPR/CCPA compliant?" |

---

### 1.7 Reliability & Resilience

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 46 | External API sometimes fails and crashes your feature | **Circuit breaker / graceful degradation** | "When [external service] is down, my app crashes. Add a circuit breaker so the app degrades gracefully instead of failing." |
| 47 | Deployments causing downtime | **Zero-downtime deployment** | "My deployments cause 30+ seconds of downtime. Set up blue-green or rolling deployments for zero-downtime releases." |
| 48 | Users lose work when an error occurs | **Auto-save / draft state** | "Add auto-save so users never lose work. How often should I save? Where should drafts be stored? How do I handle conflicts?" |
| 49 | Network unreliable for your users (mobile, field workers) | **Offline-first / retry queue** | "My users have unreliable connections. Design an offline-first approach — local storage, sync queue, conflict resolution on reconnect." |
| 50 | One failing service takes down unrelated features | **Service isolation / bulkhead** | "When [service A] fails, it takes down [unrelated service B]. How do I isolate these so failures don't cascade?" |
| 51 | Database migrations sometimes break production | **Safe migration strategy** | "My last migration caused downtime. Design a zero-downtime migration strategy — expand-and-contract, backward compatibility, rollback plan." |
| 52 | No idea if the app is healthy until users complain | **Health checks & monitoring** | "I have no visibility into app health. Add health check endpoints, uptime monitoring, and alerting so I know before users do." |
| 53 | Can't reproduce production bugs locally | **Error tracking & observability** | "Production bugs are invisible. Set up error tracking (Sentry), structured logging with correlation IDs, and request tracing." |

---

### 1.8 User Experience Patterns

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 54 | Page shows nothing while data loads | **Skeleton screens / optimistic UI** | "Replace the loading spinner with skeleton screens. For mutations, show optimistic updates before the server confirms." |
| 55 | Form errors frustrate users, data lost on failure | **Form state management** | "Improve form UX — inline validation, error persistence, draft saving, and never lose user input on error." |
| 56 | Users confused about what's happening (loading? error? success?) | **State communication** | "Audit my UI for missing loading, error, and empty states. Every async operation needs all three states handled." |
| 57 | Multi-step process is overwhelming users | **Wizard pattern / progressive disclosure** | "Break this form into a multi-step wizard with progress indicator, step validation, and the ability to go back." |
| 58 | App unusable on mobile | **Responsive design** | "Audit my app for mobile usability. What breaks below 768px? Add responsive breakpoints and touch-friendly interactions." |
| 59 | Users with disabilities can't use the app | **Accessibility (a11y)** | "Run a WCAG AA audit. Check keyboard navigation, screen reader compatibility, color contrast, and focus management." |
| 60 | Users performing the same actions repeatedly | **Bulk actions / shortcuts** | "Users are doing [action] one at a time on many items. Add bulk selection and batch operations." |

---

### 1.9 Integration & API Design

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 61 | Need to sync data with external systems (CRM, payment, etc.) | **Webhook / event-driven integration** | "Design the integration with [service]. Should I use webhooks, polling, or their SDK? How do I handle failures and retries?" |
| 62 | Multiple services in your system need to react to the same event | **Event bus / pub-sub** | "Multiple parts of my app need to know when [event] happens. Design an event bus so I don't hardwire service-to-service calls." |
| 63 | Frontend and backend are evolving at different speeds | **API versioning** | "My API is changing but old clients still exist. Design a versioning strategy — URL path, header, or query parameter?" |
| 64 | API consumers need different shapes of the same data | **BFF (Backend for Frontend)** | "My mobile app, web app, and admin panel all need different API responses. Should I build a BFF layer or use field selection?" |
| 65 | Third-party API changes frequently and breaks your code | **Adapter / anti-corruption layer** | "Wrap [third-party service] in an adapter so when their API changes, I only fix one file instead of 20." |
| 66 | Need to let other developers build on top of your platform | **Public API design** | "Design a public API for developers. What do I need — API keys, rate limits, documentation, SDKs, versioning?" |

---

### 1.10 Observability & Operations

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 67 | "It's broken" but you can't tell why | **Structured logging** | "Set up structured logging with request IDs so I can trace any user action from frontend to database and back." |
| 68 | Don't know if the service is healthy | **Health check endpoints** | "Add liveness and readiness endpoints. What should each check — database, Redis, external APIs, disk space?" |
| 69 | Performance degrading slowly over time | **APM & metrics** | "Set up application performance monitoring. Track response times, error rates, and throughput with alerting on anomalies." |
| 70 | Don't know which features users actually use | **Product analytics / telemetry** | "Add analytics to track feature usage. What events matter? How do I measure adoption without violating privacy?" |
| 71 | Costs increasing but can't tell where money goes | **Cost observability** | "Map my infrastructure costs to features. Which services cost the most? Where can I optimize without impacting performance?" |
| 72 | Incident happened and nobody knows what to do | **Runbook / incident playbook** | "Create runbooks for the top 5 failure scenarios in my app. For each: detection, diagnosis, resolution, and prevention." |

---

## Part 2: Domain-Specific Triggers

These triggers are **in addition to** the universal patterns above. Scan the section matching your blueprint category.

---

### 2.1 Web & Apps (Blueprint 01)

*Covers: SaaS, e-commerce, marketing sites, mobile apps, desktop apps, static websites, CLI tools, Chrome extensions, WordPress*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 73 | Users need to pay you money | **Payment integration** | "Integrate Stripe (or [provider]). Design the billing flow — checkout, subscriptions, invoices, webhooks, and failed payment handling." |
| 74 | Different customers need different features based on their plan | **Multi-tenancy / feature gating** | "Design multi-tenancy. How do I gate features by plan tier? Shared database with tenant isolation or separate schemas?" |
| 75 | Users want to invite team members to their account | **Organization & team management** | "Add organization support — invites, roles within a team, org-scoped data isolation, and billing per org." |
| 76 | Need to verify user email addresses or phone numbers | **Verification flow** | "Add email verification on signup, email change, and password reset. Design the token generation, delivery, and expiry flow." |
| 77 | Users asking for dark mode, custom themes, or branding | **Theming system** | "Design a theming system. Should it be CSS variables, Tailwind config, or a theme provider? Support dark mode and custom branding." |
| 78 | SEO matters for discoverability | **SSR / SSG / meta tags** | "Audit my app for SEO. Do I need server-side rendering? Are meta tags, Open Graph, and structured data in place?" |
| 79 | Content needs to be managed by non-technical people | **CMS integration / admin panel** | "Non-technical users need to edit [content]. Should I build an admin panel, integrate a headless CMS, or use a page builder?" |
| 80 | Mobile app and web app need to share logic | **Cross-platform strategy** | "I have a web app and want a mobile app. What logic can I share? React Native, Capacitor, PWA, or separate native apps?" |
| 81 | App needs to work when installed on desktop | **Desktop packaging** | "Package my web app as a desktop app. Electron, Tauri, or PWA? What platform-specific features do I need?" |
| 82 | Users want to export their data | **Data export / portability** | "Add data export (CSV, JSON, PDF). Design it as a background job with download notification for large datasets." |
| 83 | E-commerce: cart abandonment, inventory tracking | **E-commerce patterns** | "Design [cart/inventory/checkout]. What patterns prevent overselling? How do I handle cart expiry and abandoned carts?" |
| 84 | Need a CLI tool alongside the main app | **CLI design** | "Design a CLI tool for [purpose]. Interactive prompts, flags, help text, config file, and output formatting." |

---

### 2.2 Games (Blueprint 02)

*Covers: Web games, mobile games, PC/Steam games, console games*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 85 | Frame rate dropping below 60 FPS | **Rendering optimization** | "Profile my game's rendering pipeline. Where are the bottlenecks — draw calls, fill rate, overdraw, or garbage collection?" |
| 86 | Too many objects on screen causing lag | **Object pooling / spatial partitioning** | "Add object pooling for [bullets/particles/enemies]. Also evaluate whether I need spatial partitioning for collision detection." |
| 87 | Players in multiplayer seeing different game states | **State synchronization / netcode** | "Design my multiplayer netcode. Authoritative server, client prediction, lag compensation, and state reconciliation." |
| 88 | Players cheating by modifying client data | **Server-side validation / anti-cheat** | "All game logic runs on the client. Move critical calculations server-side and add validation for player actions." |
| 89 | Need to match players by skill level | **Matchmaking / ELO system** | "Design a matchmaking system. ELO or MMR? How do I handle queue times, skill brackets, and party queuing?" |
| 90 | Game world is too large to load at once | **Level streaming / chunk loading** | "My game world is too big for memory. Design a streaming system that loads/unloads chunks based on player position." |
| 91 | Need to save and resume game progress | **Save system / state serialization** | "Design a save game system. What state needs persisting? How do I handle save corruption, versioning, and cloud saves?" |
| 92 | AI enemies feel predictable and dumb | **Behavior trees / state machines** | "My enemy AI is basic if/else logic. Design a behavior tree or state machine that makes enemies feel intelligent and varied." |
| 93 | Physics behaving differently on different devices | **Deterministic physics / fixed timestep** | "My physics simulation gives different results on different hardware. Implement fixed timestep and deterministic calculations." |
| 94 | Loading screens too long | **Asset streaming / preloading** | "Reduce loading times. Which assets can be streamed? What should be preloaded? Can I show a playable loading screen?" |
| 95 | Need a tutorial that doesn't feel forced | **Onboarding / progressive complexity** | "Design a game tutorial that teaches through gameplay, not text walls. Progressive difficulty, contextual hints, skip option." |
| 96 | Players need to buy items / cosmetics | **In-game economy** | "Design an in-game economy. Currency types, pricing, anti-inflation measures, and platform store integration." |

---

### 2.3 Trading & Finance (Blueprint 03)

*Covers: Trading bots, algorithmic trading, TradingView indicators, MT4/MT5 EAs, DeFi protocols, quantitative research*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 97 | Market data needs to arrive in milliseconds | **Low-latency data pipeline** | "Optimize my market data feed. WebSocket vs FIX protocol? How do I minimize latency from exchange to decision engine?" |
| 98 | Strategy works in backtesting but fails live | **Backtest-to-live gap analysis** | "My strategy's live performance doesn't match backtest results. Audit for look-ahead bias, slippage modeling, and survivorship bias." |
| 99 | Calculation using 0.1 + 0.2 gives 0.30000000000000004 | **Decimal precision** | "I'm using floating point for financial calculations. Replace all money/price math with Decimal.js or BigNumber to avoid precision errors." |
| 100 | Need to prove trades were executed fairly for regulators | **Audit logging / compliance** | "Design an immutable audit trail for all trades. Timestamp, execution price, order book snapshot, and decision rationale." |
| 101 | One bad trade could wipe out the account | **Risk management engine** | "Add automated risk controls — position sizing, max drawdown limits, stop-losses, daily loss limits, and circuit breakers." |
| 102 | Market data volume overwhelming the system | **Time-series database** | "Standard SQL can't keep up with tick data volume. Evaluate TimescaleDB, InfluxDB, or QuestDB for my market data storage." |
| 103 | Need to react to news events automatically | **NLP / sentiment analysis pipeline** | "Add news sentiment analysis to my trading signals. Where do I source news? How do I score sentiment? How fast does it need to be?" |
| 104 | Strategy needs to trade on multiple exchanges | **Exchange adapter pattern** | "Add support for [exchanges]. Design an adapter layer so the strategy doesn't care which exchange it's trading on." |
| 105 | Portfolio drifting from target allocation | **Rebalancing engine** | "Design an automated rebalancing system. Threshold-based triggers, tax-aware rebalancing, and minimum trade size constraints." |
| 106 | Need to simulate strategy under extreme market conditions | **Stress testing / Monte Carlo** | "Stress test my strategy. Run Monte Carlo simulations with historical crash data, black swan events, and correlation breakdowns." |

---

### 2.4 Web3 & Blockchain (Blueprint 04)

*Covers: Smart contracts, dApps, tokens, NFTs, DAOs, DeFi, Layer 2s, wallets, blockchain explorers*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 107 | Gas fees making transactions too expensive | **Gas optimization** | "Audit my smart contract for gas optimization. Storage vs memory, packing structs, minimizing state changes, and batch operations." |
| 108 | Smart contract deployed with a bug, can't fix it | **Upgradeability pattern** | "My contract is immutable but has a bug. For future contracts, design an upgradeable proxy pattern (UUPS or Transparent Proxy)." |
| 109 | Need to read blockchain data without scanning every block | **Indexer / subgraph** | "Querying the blockchain directly is too slow. Set up an indexer (The Graph, custom) to make on-chain data queryable." |
| 110 | Users don't have crypto wallets | **Wallet abstraction / account abstraction** | "Most of my users don't have wallets. Design an onboarding flow using account abstraction or social login that creates wallets behind the scenes." |
| 111 | Token needs liquidity for trading | **AMM / liquidity pool** | "Design a liquidity strategy for my token. Uniswap pool, liquidity incentives, and impermanent loss considerations." |
| 112 | DAO needs fair governance voting | **Governance mechanism** | "Design a voting system for my DAO. Token-weighted, quadratic, or conviction voting? How do I prevent whale dominance?" |
| 113 | NFT metadata needs to be permanent | **Decentralized storage** | "Store NFT metadata and media on IPFS or Arweave so it survives even if my server goes down. Pin strategy and gateway configuration." |
| 114 | Bots front-running user transactions | **MEV protection** | "My users' transactions are being front-run. Implement commit-reveal scheme, use Flashbots Protect, or design MEV-resistant mechanics." |
| 115 | Need the app to work across multiple chains | **Cross-chain architecture** | "My dApp needs to work on Ethereum, Polygon, and Arbitrum. Design the multi-chain architecture — contract deployment, bridge integration, and chain detection." |
| 116 | Smart contract hasn't been security audited | **Contract security audit** | "Prepare my smart contract for a security audit. Run Slither, Mythril, and manual review. What are the top vulnerability patterns to check?" |

---

### 2.5 AI & Machine Learning (Blueprint 05)

*Covers: RAG applications, model training, fine-tuning, agents, computer vision, voice AI, recommendation systems, data pipelines*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 117 | Model accuracy not improving no matter what you try | **Data quality / feature engineering** | "My model is stuck. Audit my training data for quality issues — label errors, class imbalance, missing features, and data leakage." |
| 118 | Training takes hours/days per run | **Training optimization** | "Speed up my training pipeline. Mixed precision, gradient accumulation, data loading bottlenecks, distributed training, or smaller model?" |
| 119 | Model too large to deploy affordably | **Model compression** | "My model is too large for production inference. Evaluate quantization (INT8/INT4), distillation, pruning, or LoRA for my use case." |
| 120 | Need to serve predictions with low latency | **Model serving infrastructure** | "Design my inference pipeline. Should I use TensorFlow Serving, Triton, vLLM, or a simple FastAPI wrapper? What's my latency budget?" |
| 121 | Model accuracy degrading over time in production | **Data drift / model monitoring** | "My model's accuracy is dropping in production. Set up drift detection, monitoring dashboards, and automated retraining triggers." |
| 122 | Users asking "why did the AI decide this?" | **Explainability** | "Add explainability to my model's predictions. SHAP values, attention visualization, or natural language explanations — what fits my use case?" |
| 123 | RAG responses containing information not in the source documents | **Hallucination mitigation** | "My RAG app is hallucinating. Audit my retrieval quality, chunk strategy, prompt template, and add citation/source attribution." |
| 124 | Need to process images, audio, or video | **Multimodal pipeline** | "Design a pipeline to process [media type]. Preprocessing, model selection, batch vs real-time inference, and output formatting." |
| 125 | Fine-tuning is too expensive | **Parameter-efficient fine-tuning** | "Full fine-tuning is too expensive. Implement LoRA/QLoRA. What rank? Which layers? How much training data do I need?" |
| 126 | Need to label thousands of data points | **Active learning / labeling pipeline** | "I need labeled data but manual labeling is too slow. Design an active learning loop — model labels easy cases, humans verify edge cases." |
| 127 | AI agent getting stuck in loops or going off-track | **Agent orchestration / guardrails** | "My AI agent keeps looping or hallucinating actions. Add guardrails — max iterations, tool validation, output checking, and fallback strategies." |
| 128 | Vector search returning irrelevant results | **Embedding & retrieval optimization** | "My vector search returns poor results. Audit my embedding model choice, chunking strategy, metadata filtering, and re-ranking." |

---

### 2.6 Hardware & IoT (Blueprint 06)

*Covers: Arduino, Raspberry Pi, ESP32, drones, robotics, wearables, 3D printer firmware, home automation*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 129 | Battery draining faster than expected | **Power optimization** | "Profile my device's power consumption. Where can I add sleep modes, reduce polling frequency, or duty-cycle sensors?" |
| 130 | Sensor readings are noisy and unreliable | **Signal processing / filtering** | "My sensor data is noisy. Apply appropriate filtering — Kalman filter, moving average, or median filter based on my noise characteristics." |
| 131 | Devices need firmware updates in the field | **OTA update mechanism** | "Design an over-the-air update system. Firmware signing, delta updates, rollback on failure, and update scheduling." |
| 132 | Devices lose connection to the server intermittently | **Store-and-forward / MQTT QoS** | "My devices have unreliable connectivity. Design a store-and-forward system with MQTT QoS levels for reliable data delivery." |
| 133 | Managing hundreds/thousands of devices individually is unscalable | **Fleet management** | "I have [N] devices to manage. Design a fleet management system — device registry, group operations, monitoring, and remote diagnostics." |
| 134 | Sensor data volume overwhelming the cloud server | **Edge computing / local aggregation** | "Raw sensor data is too much for my server. Add edge processing — aggregate, filter, and compress data before sending to cloud." |
| 135 | Need guaranteed response time for safety-critical operations | **RTOS / real-time constraints** | "This control loop needs guaranteed timing. Should I switch to an RTOS? What's the interrupt priority scheme?" |
| 136 | Hardware component failing silently | **Watchdog timer / self-diagnostics** | "Add self-diagnostics — watchdog timer, sensor health checks, memory monitoring, and automatic recovery on failure." |
| 137 | Devices need to communicate with each other without a server | **Mesh networking** | "My devices need peer-to-peer communication. Evaluate BLE mesh, LoRa, Zigbee, or WiFi mesh for my range and power requirements." |
| 138 | Need to secure a device with limited CPU/memory | **Lightweight security** | "My device can't run full TLS. What security is feasible — DTLS, pre-shared keys, hardware security modules, or certificate pinning?" |
| 139 | Physical device needs a companion mobile/web app | **Device-to-app communication** | "Design the communication between my device and its companion app. BLE, WiFi direct, or cloud relay? How do I handle pairing?" |

---

### 2.7 Automation & DevOps (Blueprint 07)

*Covers: CI/CD pipelines, infrastructure as code, Kubernetes, monitoring, serverless, shell scripts*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 140 | Deployments are manual, error-prone, and scary | **CI/CD pipeline** | "Design a CI/CD pipeline for my project. Lint → test → build → deploy, with staging gate and rollback capability." |
| 141 | Infrastructure is configured differently across environments | **Infrastructure as Code** | "My environments keep drifting apart. Convert my infrastructure to Terraform/Pulumi with environment-specific variable files." |
| 142 | Secrets are in env files, shared over Slack | **Secret management** | "Move all secrets to a proper secret manager. Evaluate AWS SSM, Vault, or Doppler for my team size and infrastructure." |
| 143 | Need to scale containers automatically | **Container orchestration** | "I've outgrown docker-compose. Evaluate Kubernetes, ECS, or Cloud Run for my scale. What's the migration path?" |
| 144 | Logs from multiple services scattered everywhere | **Centralized logging** | "Aggregate logs from all my services into one searchable system. ELK stack, Loki, or CloudWatch — what fits my budget?" |
| 145 | Build times getting slower as codebase grows | **Build optimization** | "My CI pipeline takes 15+ minutes. Add caching (node_modules, Docker layers), parallel test execution, and incremental builds." |
| 146 | Need disaster recovery across regions | **Multi-region / DR automation** | "Design an automated disaster recovery setup. Multi-region database replication, failover DNS, and recovery time objectives." |
| 147 | Configuration changes causing production incidents | **GitOps** | "Move to GitOps — all config changes go through Git PRs with automated apply. ArgoCD, Flux, or custom GitHub Actions?" |
| 148 | Serverless cold starts affecting user experience | **Serverless optimization** | "My Lambda/Cloud Function cold starts take 3+ seconds. Provisioned concurrency, smaller bundles, or switch to containers?" |
| 149 | Need to run the same thing in dev, staging, and production identically | **Dev/prod parity** | "My app works in dev but breaks in production. Ensure dev/prod parity — same Docker images, same database engine, same environment structure." |

---

### 2.8 Plugins & Extensions (Blueprint 08)

*Covers: VS Code extensions, Chrome extensions, Figma plugins, Shopify apps, Slack/Discord bots, WordPress plugins, OBS plugins, VST audio plugins*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 150 | Host application updated and your plugin broke | **Version compatibility / graceful degradation** | "My plugin breaks when the host app updates. Add version detection and graceful degradation for API changes." |
| 151 | Plugin slowing down the host application | **Performance isolation** | "My plugin is making the host app slow. Move heavy computation to a web worker/background script and lazy-load components." |
| 152 | Plugin needs to store user settings and data | **Sandboxed storage** | "Design my plugin's storage strategy. Use the host's storage API, manage settings schema, and handle migration between versions." |
| 153 | Need to communicate between plugin and host app | **Message passing / event API** | "Design the communication protocol between my plugin UI and the host. Message types, serialization, and error handling." |
| 154 | Plugin UI looks out of place in the host app | **Theme integration** | "My plugin UI doesn't match the host app's look. Detect the host theme (dark/light) and use the host's design system tokens." |
| 155 | Users can't find or install your plugin easily | **Marketplace publishing** | "Prepare my plugin for [marketplace]. Required metadata, screenshots, review process, auto-update mechanism, and listing optimization." |
| 156 | Plugin conflicts with other plugins | **Namespace isolation** | "My plugin's CSS/JS might conflict with other plugins. Isolate my namespace — Shadow DOM, CSS modules, unique prefixes." |
| 157 | Plugin needs background processing when the UI isn't open | **Background execution** | "My plugin needs to run tasks when the user isn't actively using it. Design the background script/service worker architecture." |
| 158 | Need to monetize the plugin | **Plugin monetization** | "Add a freemium model to my plugin. License validation, feature gating, trial period, and payment integration within the platform's rules." |

---

### 2.9 Data & Analytics (Blueprint 09)

*Covers: ETL pipelines, dashboards, database design, reporting systems, web scraping*

| # | When you notice... | The pattern is called... | Ask AI this... |
|---|---|---|---|
| 159 | Analytical queries running on production database, slowing everything | **Data warehouse / OLAP separation** | "Move analytical queries off my production DB. Set up a data warehouse — what's the sync strategy and what schema (star/snowflake)?" |
| 160 | Data coming from multiple sources in different formats | **ETL/ELT pipeline** | "Design an ETL pipeline. Sources → extraction → transformation → load. Scheduling, error handling, and data quality checks." |
| 161 | Dashboard queries taking 10+ seconds | **Pre-aggregation / materialized views** | "My dashboard is slow because it aggregates on every request. Add pre-computed aggregation tables with scheduled refresh." |
| 162 | Data in the warehouse doesn't match production | **Data quality / validation pipeline** | "My analytics data doesn't match what's in production. Add data quality checks — row counts, null checks, freshness, and schema validation." |
| 163 | Need to track how data was transformed (for debugging or compliance) | **Data lineage / metadata catalog** | "I can't tell where a metric comes from or how it was calculated. Set up data lineage tracking and a metadata catalog." |
| 164 | Reports take too long to generate for stakeholders | **Scheduled reports / async generation** | "Stakeholders want daily/weekly reports. Automate report generation — schedule, template, delivery (email/Slack), and error alerting." |
| 165 | Scraping data from websites for analysis | **Ethical scraping pipeline** | "Design a web scraping pipeline. Respect robots.txt, handle rate limits, manage proxies, parse changes, and store structured output." |
| 166 | Real-time dashboards showing stale data | **Streaming / Change Data Capture** | "My dashboard shows data that's hours old. Implement CDC (Debezium/logical replication) for near-real-time data syncing." |
| 167 | Need to give non-technical users self-serve analytics | **BI tool / embedded analytics** | "Non-technical users need to explore data themselves. Integrate a BI tool (Metabase, Superset, Looker) or build embedded analytics." |
| 168 | Data governance — who can see what | **Access control for data** | "Different teams should see different data. Design row-level security, column masking, and access request workflows for my data warehouse." |

---

## Part 3: The Meta-Skill — How to Develop Trigger Recognition

You can't memorize this document. Instead, develop the **habit of asking these four questions** during every design and build phase:

### The Four Detection Questions

Ask these whenever you're about to build a feature:

**1. "What happens when this gets 10x more usage?"**
→ Reveals: caching, queuing, scaling, rate limiting, pagination, and batch processing needs

**2. "What happens when this fails?"**
→ Reveals: retry logic, circuit breakers, graceful degradation, offline support, error boundaries, and rollback needs

**3. "What doesn't the user need to wait for?"**
→ Reveals: background jobs, async processing, optimistic UI, webhooks, and queue needs

**4. "What would a malicious user try to do here?"**
→ Reveals: input validation, rate limiting, auth checks, permission boundaries, and abuse detection

### Using AI as Your Pattern Detector

When you're unsure if something applies, give AI your feature description and ask:

```
I'm building [feature description] for [app type] with [tech stack].

The feature does: [what it does]
Expected users: [rough number]
Data volume: [rough estimate]

What architectural patterns, infrastructure, or technologies
should I consider that I might be overlooking? Only mention
things that are actually relevant to this specific feature
at this specific scale — don't give me an encyclopedia.
```

This prompt leverages AI's pattern recognition while filtering for relevance. The AI has seen thousands of architectures and knows which patterns match which symptoms — you just need to describe your situation accurately.

### The Growth Path

| Stage | What you do | What develops |
|---|---|---|
| **Month 1-3** | Reference this document during design phase | Awareness that these patterns exist |
| **Month 3-6** | Start recognizing 2-3 triggers without looking | Pattern matching for common scenarios |
| **Month 6-12** | Anticipate triggers before they become problems | Architectural intuition |
| **Year 2+** | Teach others which patterns to use when | Engineering leadership |

The goal isn't to memorize 168 triggers. It's to internalize the **four detection questions** until they become automatic. The specific technologies change — the questions don't.

---

*Created: February 14, 2026*
*Part of the AI Development Workflow Framework v6.0*
*Purpose: Bridge the gap between "the framework teaches process" and "AI handles implementation"*
