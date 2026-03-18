# Riftkit Domain Gap Analysis

**Date**: 2026-03-18
**Current Skills**: 304 (298 indexed + 6 unindexed)
**Analyst**: Claude Code gap analysis against user priority domains

---

## Indexing Note

6 skills exist on disk but are missing from `skills-index.md`:
- `ai_agent_fleet_management` (3-build)
- `llm_provider_management` (3-build)
- `voice_ai_patterns` (3-build)
- `websocket_patterns` (3-build)
- `graphql_patterns` (3-build)
- `dast_scanning` (4-secure)

These should be added to the index. Actual skill count is **304**.

---

## Existing Coverage Summary

Before listing gaps, here is what IS covered that touches the requested domains:

| Requested Area | Existing Skill(s) | Coverage Level |
|---|---|---|
| Multi-agent systems | `ai_agent_development` (supervisor, CrewAI, AutoGen patterns) | Partial — build patterns only, no protocol specs |
| Agent fleet ops | `ai_agent_fleet_management` (provisioning, monitoring, coordination) | Partial — operational, not architectural |
| Trading systems | `trading_systems` (bots, backtesting, data pipelines) | Partial — no quant-specific ML, no HFT |
| Prompt injection defense | `ai_safety_guardrails` (content filtering, injection defense, red teaming) | Moderate — focused on app-level, not production hardening patterns |
| AI governance | `responsible_ai_framework`, `eu_ai_act_compliance` | Moderate — policy-level, no model cards or audit trail specs |
| IoT | `iot_platform`, `firmware_development` | Moderate — cloud platform focus, not edge AI |
| LLM eval | `llm_evaluation_benchmarking`, `eval_harness` | Good for LLMs, no agent-level eval |

---

## PRIORITY 1 — AI Agent Infrastructure

### GAP 1.1: Agent-to-Agent Communication Protocols
- **Domain**: Standardized protocols for agents to discover, authenticate, and exchange messages with each other
- **Why it matters**: Anyone building multi-agent systems (Nick's OpenClaw, Jeremy's Utari.ai fleet). Without protocol standards, every integration is bespoke. Google's A2A protocol, OpenAI's agent protocol, and the emerging Agent Communication Protocol (ACP) are becoming standards.
- **What exists**: `ai_agent_development` covers supervisor/crew patterns but not wire-level protocols
- **Skills to create**:
  1. `agent_communication_protocols` — A2A, ACP, MCP integration, agent discovery, message schemas, authentication between agents
  2. `agent_registry_discovery` — Service registry for agents (who can do what), capability advertisement, dynamic routing
- **Phase**: 3-build
- **Priority**: **Critical**

### GAP 1.2: Agent Memory and State Management
- **Domain**: Persistent memory, shared context, session continuity, and long-term knowledge for agents
- **Why it matters**: Agents that forget between sessions are useless for ongoing work. This is the #1 production pain point.
- **What exists**: `ai_agent_development` mentions LangGraph checkpointing briefly. `project_state_persistence` is framework-meta, not agent memory.
- **Skills to create**:
  1. `agent_memory_systems` — Short-term (conversation buffer), long-term (vector store), episodic (event log), semantic (knowledge graph). Memory retrieval strategies, memory compaction, forgetting policies. Implementations with Mem0, Zep, LangGraph checkpointers, custom Redis/Postgres stores.
- **Phase**: 3-build
- **Priority**: **Critical**

### GAP 1.3: Agent Conflict Resolution and Deadlock Prevention
- **Domain**: What happens when two agents try to edit the same resource, contradict each other, or create circular dependencies
- **Why it matters**: Fleet of 15 Mac Minis running agents simultaneously. Without conflict resolution, agents destroy each other's work.
- **What exists**: `ai_agent_fleet_management` mentions it in a checklist item but has zero implementation guidance
- **Skills to create**:
  1. `agent_conflict_resolution` — Mutex/lock patterns for shared resources, optimistic concurrency for agent outputs, consensus protocols (simple voting, authority-based), deadlock detection and break strategies, conflict merge strategies
- **Phase**: 3-build
- **Priority**: **Critical**

### GAP 1.4: Agent Evaluation and Benchmarking
- **Domain**: Evaluating agent systems (not just LLMs) — task completion rate, tool use accuracy, multi-step reasoning, cost per task, latency
- **Why it matters**: `llm_evaluation_benchmarking` evaluates model quality, not agent system quality. You need to know if your agent actually completes the job correctly.
- **Skills to create**:
  1. `agent_evaluation_framework` — Task completion metrics, tool call accuracy, multi-step trajectory evaluation, cost-per-task tracking, regression testing for agent behaviors, A/B testing agent configurations, benchmarking harnesses (AgentBench, SWE-bench patterns)
- **Phase**: 4-secure
- **Priority**: **Critical**

### GAP 1.5: NVIDIA NeMo Ecosystem
- **Domain**: NeMo Guardrails (programmable guardrails for LLM apps), NeMo Curator (data curation), NeMo Framework (training)
- **Why it matters**: NeMo Guardrails is becoming the production standard for guardrailing LLM applications. It provides Colang-based programmable rails that go far beyond basic prompt injection defense. NeMo Curator is the go-to for training data quality.
- **What exists**: `ai_safety_guardrails` covers generic defense patterns but not NeMo-specific tooling
- **Skills to create**:
  1. `nemo_guardrails` — Colang 2.0 rail definitions, topical rails, fact-checking rails, jailbreak detection, integration with LangChain/LlamaIndex, custom action handlers, guardrail testing
  2. `nemo_data_curation` — NeMo Curator for training data filtering, deduplication, quality scoring, PII removal, language classification, dataset preparation pipelines
- **Phase**: 3-build (guardrails), 3-build (curation)
- **Priority**: **Critical**

### GAP 1.6: NVIDIA NIMs (Inference Microservices)
- **Domain**: NVIDIA's pre-built, optimized inference containers for deploying LLMs, vision models, and embedding models
- **Why it matters**: NIMs are the fastest path from "I have a model" to "it's serving in production with TensorRT optimization." They're becoming the standard for self-hosted inference.
- **What exists**: `model_serving_deployment` covers vLLM, TGI, Triton but not NIM-specific patterns
- **Skills to create**:
  1. `nvidia_nim_deployment` — NIM container setup, GPU resource allocation, model catalog selection, TensorRT-LLM optimization profiles, scaling with Kubernetes, health monitoring, NIM + API gateway patterns, cost comparison vs cloud APIs
- **Phase**: 5-ship
- **Priority**: **High**

### GAP 1.7: Prompt Library Management and Versioning
- **Domain**: Treating prompts as versioned artifacts — storage, testing, A/B comparison, rollback, governance
- **Why it matters**: Production LLM apps have dozens of prompts. When someone edits a prompt and quality drops, you need rollback. This is prompt ops.
- **What exists**: `prompt_engineering` covers writing prompts. Nothing covers managing them at scale.
- **Skills to create**:
  1. `prompt_ops` — Prompt versioning (git-based, DB-backed), prompt testing pipelines, A/B prompt comparison, prompt performance metrics, prompt review workflows, prompt template engines (Jinja, Handlebars), prompt registries, rollback procedures
- **Phase**: 3-build
- **Priority**: **High**

### GAP 1.8: OpenClaw Platform Patterns
- **Domain**: Patterns specific to the OpenClaw AI agent platform architecture
- **Why it matters**: This is Nick's core product. Framework should encode the patterns learned.
- **What exists**: Generic agent development skills, no OpenClaw-specific encoding
- **Skills to create**:
  1. `openclaw_platform_patterns` — OpenClaw architecture conventions, agent definition schemas, AgentIQ integration patterns, Riftkit-to-OpenClaw deployment workflows, OpenClaw-specific testing patterns
- **Phase**: toolkit
- **Priority**: **High**

---

## PRIORITY 2 — Quantum + Physics + Trading

### GAP 2.1: Quantum Computing Fundamentals
- **Domain**: Quantum circuits, gates, qubits, measurement, quantum algorithms (Grover, Shor, VQE, QAOA)
- **Why it matters**: Quantum is transitioning from research to early production. Optimization problems (logistics, finance, drug discovery) are the first real-world applications.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `quantum_computing_fundamentals` — Qiskit, Cirq, PennyLane SDK setup. Qubit types, gate operations, circuit design, measurement. Simulators vs real hardware (IBM Quantum, AWS Braket, Azure Quantum). Common algorithms with implementations.
  2. `quantum_optimization_algorithms` — QAOA, VQE, quantum annealing (D-Wave), hybrid classical-quantum solvers, problem encoding (QUBO formulation), benchmarking quantum vs classical
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 2.2: Quantum Machine Learning
- **Domain**: Variational quantum circuits, quantum kernels, quantum neural networks, hybrid models
- **Why it matters**: QML is where quantum and AI intersect. PennyLane + PyTorch/TensorFlow integration makes this accessible now.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `quantum_machine_learning` — Variational quantum eigensolver patterns, quantum kernel methods, parameterized quantum circuits, PennyLane + PyTorch hybrid training, barren plateau mitigation, quantum feature maps, NISQ-era practical applications
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 2.3: Physics Simulations
- **Domain**: Computational physics, numerical methods, simulation frameworks
- **Why it matters**: Scientific computing, engineering simulations, game physics, climate modeling
- **What exists**: Zero coverage
- **Skills to create**:
  1. `computational_physics` — Numerical methods (PDE/ODE solvers), simulation frameworks (FEniCS, OpenFOAM, PyBullet), GPU-accelerated physics (CUDA, JAX), molecular dynamics, fluid dynamics, N-body simulations, visualization with ParaView/Matplotlib
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 2.4: Quantitative Trading and AI-Driven Alpha
- **Domain**: Quantitative strategies, factor models, ML for alpha generation, reinforcement learning for trading
- **Why it matters**: `trading_systems` covers bot architecture and basic backtesting. It does NOT cover quant research methodology, factor investing, or ML-based signal generation.
- **What exists**: `trading_systems` (basic architecture), `ml_pipeline` (generic ML)
- **Skills to create**:
  1. `quantitative_trading_strategies` — Factor models (Fama-French, momentum, mean reversion), statistical arbitrage, pairs trading, alpha research methodology, signal combination, transaction cost modeling, slippage estimation
  2. `ml_trading_signals` — Feature engineering for financial data, time series models (LSTM, Transformer, N-BEATS), reinforcement learning for portfolio management (PPO, SAC), alternative data integration, regime detection, ML-based risk models
- **Phase**: 3-build
- **Priority**: **High**

### GAP 2.5: Backtesting Frameworks (Deep Dive)
- **Domain**: Rigorous backtesting methodology — avoiding lookahead bias, survivorship bias, overfitting, walk-forward optimization
- **Why it matters**: `trading_systems` mentions backtesting but lacks the statistical rigor section. Bad backtests lose real money.
- **What exists**: Basic backtesting in `trading_systems`
- **Skills to create**:
  1. `backtesting_methodology` — Frameworks (Backtrader, Zipline, vectorbt, QuantConnect), walk-forward optimization, Monte Carlo simulation, out-of-sample testing, bias detection (lookahead, survivorship, selection), performance metrics (Sharpe, Sortino, Calmar, max drawdown), statistical significance testing
- **Phase**: 4-secure (testing/validation domain)
- **Priority**: **High**

### GAP 2.6: Risk Management and Portfolio Optimization
- **Domain**: Position sizing, portfolio construction, VaR, expected shortfall, correlation management
- **Why it matters**: Building a trading bot without risk management is gambling. This is the missing safety layer for `trading_systems`.
- **What exists**: `trading_systems` mentions a risk manager component but has no depth
- **Skills to create**:
  1. `portfolio_risk_management` — Modern Portfolio Theory, Black-Litterman, risk parity, VaR/CVaR computation, position sizing (Kelly criterion, fixed fractional), correlation matrices, drawdown management, portfolio rebalancing algorithms, stress testing
- **Phase**: 3-build
- **Priority**: **High**

### GAP 2.7: High-Frequency Trading Infrastructure
- **Domain**: Ultra-low-latency systems, kernel bypass networking, FPGA acceleration, co-location, order book microstructure
- **Why it matters**: Niche but represents the extreme end of systems engineering. Useful for anyone building latency-sensitive systems.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `hft_infrastructure` — Kernel bypass (DPDK, Solarflare/Xilinx), lock-free data structures, memory-mapped I/O, FPGA order routing, co-location architecture, market microstructure (order book dynamics, Level 2/3 data), tick-to-trade latency measurement
- **Phase**: 3-build
- **Priority**: **Low**

---

## PRIORITY 3 — Other Missing Domains

### GAP 3.1: Edge Computing and Edge AI
- **Domain**: Running ML models and computation at the edge (IoT devices, mobile, on-prem servers) rather than cloud
- **Why it matters**: Latency-sensitive applications (autonomous vehicles, industrial IoT, real-time video), data sovereignty, bandwidth constraints. The `iot_platform` skill is cloud-centric.
- **What exists**: `iot_platform` (cloud focus), `firmware_development` (bare metal), `model_serving_deployment` (server-side)
- **Skills to create**:
  1. `edge_ai_deployment` — Model optimization for edge (quantization, pruning, distillation, ONNX Runtime, TensorFlow Lite, Core ML, NVIDIA Jetson), edge orchestration (KubeEdge, AWS Greengrass, Azure IoT Edge), offline-first inference, model update OTA, edge-cloud sync patterns
- **Phase**: 5-ship
- **Priority**: **High**

### GAP 3.2: Federated Learning
- **Domain**: Training ML models across decentralized data without centralizing it
- **Why it matters**: Healthcare (HIPAA prevents data centralization), finance (competing banks can't share data), mobile (user privacy). Growing regulatory pressure makes this increasingly important.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `federated_learning` — Federated averaging (FedAvg), secure aggregation, differential privacy in FL, frameworks (PySyft, Flower, TensorFlow Federated, NVIDIA FLARE), communication efficiency, heterogeneous data handling, federated evaluation
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 3.3: Digital Twins
- **Domain**: Virtual replicas of physical systems that sync with real-time data for simulation, monitoring, and prediction
- **Why it matters**: Manufacturing, smart buildings, infrastructure monitoring, supply chain. NVIDIA Omniverse is making this accessible.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `digital_twin_development` — Twin architecture (physical-virtual mapping), real-time data sync (IoT to twin), simulation engines (NVIDIA Omniverse, Azure Digital Twins, AWS IoT TwinMaker), state management, predictive maintenance models, 3D visualization
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 3.4: AR/VR Development
- **Domain**: Augmented and virtual reality applications beyond gaming — training, remote collaboration, spatial computing
- **Why it matters**: Apple Vision Pro, Meta Quest, enterprise training, remote assistance, spatial data visualization. `game_development` covers game engines but not spatial computing patterns.
- **What exists**: `game_development` (game-focused), `liquid_glass_design` (iOS UI only)
- **Skills to create**:
  1. `spatial_computing` — ARKit/ARCore/WebXR, spatial anchors, hand tracking, eye tracking, spatial UI patterns, 3D asset pipelines, passthrough/mixed reality, multi-user shared spaces, Unity/Unreal XR toolkits, visionOS development
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 3.5: Robotics and ROS
- **Domain**: Robot Operating System, motion planning, SLAM, sensor fusion, robot simulation
- **Why it matters**: Manufacturing automation, warehouse robots, drones, autonomous delivery. ROS 2 is the industry standard.
- **What exists**: `firmware_development` (microcontroller level), zero robotics coverage
- **Skills to create**:
  1. `robotics_ros2` — ROS 2 node architecture, topic/service/action communication, navigation stack (Nav2), SLAM (simultaneous localization and mapping), motion planning (MoveIt), sensor fusion, Gazebo/Isaac Sim simulation, real-time control loops, safety standards (ISO 13849)
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 3.6: Autonomous Systems
- **Domain**: Self-driving vehicles, drones, autonomous inspection — perception, planning, control stacks
- **Why it matters**: Beyond robotics — this is the full autonomous stack including perception (cameras, LiDAR), path planning, behavior prediction, and safety certification.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `autonomous_systems` — Perception pipeline (object detection, tracking, sensor fusion), planning (path planning, behavior planning, decision making), control (PID, MPC), simulation (CARLA, AirSim, NVIDIA Drive Sim), safety validation (scenario-based testing, formal verification), V2X communication
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 3.7: Natural Language to SQL / Code Generation
- **Domain**: Text-to-SQL, text-to-code, structured output generation from natural language
- **Why it matters**: Every business intelligence tool is adding "ask questions in English" features. This is a high-demand production pattern distinct from generic prompt engineering.
- **What exists**: `prompt_engineering` (generic), `rag_advanced_patterns` (retrieval)
- **Skills to create**:
  1. `nl_to_structured_output` — Text-to-SQL (schema-aware prompting, query validation, execution sandboxing), text-to-code (constrained generation, AST validation), structured output (JSON mode, function calling, Pydantic models), evaluation metrics (execution accuracy, semantic equivalence), guardrails for generated code
- **Phase**: 3-build
- **Priority**: **High**

### GAP 3.8: Knowledge Graphs and Ontologies
- **Domain**: Graph-based knowledge representation, ontology design, graph databases, knowledge-enhanced AI
- **Why it matters**: GraphRAG (Microsoft) combines knowledge graphs with RAG for dramatically better retrieval. Enterprise knowledge management. Agent long-term memory.
- **What exists**: `rag_advanced_patterns` mentions graph-based retrieval briefly, `vector_database_operations` covers vector DBs
- **Skills to create**:
  1. `knowledge_graph_systems` — Graph database operations (Neo4j, Amazon Neptune, Apache AGE), ontology design (OWL, RDF, SKOS), entity extraction and relation mapping, GraphRAG implementation, knowledge graph construction pipelines, graph embeddings, reasoning over graphs, graph + vector hybrid retrieval
- **Phase**: 3-build
- **Priority**: **High**

### GAP 3.9: Causal Inference in Production
- **Domain**: Moving beyond correlation to causation — A/B test design, uplift modeling, do-calculus, causal discovery
- **Why it matters**: Product teams making decisions based on correlational data make bad decisions. Causal inference is the difference between "users who do X have higher retention" and "doing X causes higher retention."
- **What exists**: `product_analytics` (tracking), `assumption_testing` (experimentation framework)
- **Skills to create**:
  1. `causal_inference` — DoWhy/EconML frameworks, DAG-based causal modeling, instrumental variables, regression discontinuity, difference-in-differences, synthetic control, uplift modeling, causal discovery algorithms (PC, FCI), integration with A/B testing platforms
- **Phase**: 3-build
- **Priority**: **Medium**

### GAP 3.10: MLOps for Edge Devices
- **Domain**: CI/CD for ML models targeting edge deployment — model optimization, OTA updates, A/B testing on devices
- **Why it matters**: `mlops_pipeline` is server-focused. Edge MLOps has unique constraints: limited compute, intermittent connectivity, heterogeneous hardware.
- **What exists**: `mlops_pipeline` (cloud), `firmware_development` (bare metal)
- **Skills to create**:
  1. `edge_mlops` — Model compilation targets (TFLite, Core ML, ONNX, TensorRT), on-device A/B testing, OTA model updates, edge model monitoring (on-device drift detection), device fleet management for ML, hardware-aware neural architecture search
- **Phase**: 5-ship
- **Priority**: **Medium**

### GAP 3.11: Data Mesh Architecture
- **Domain**: Decentralized data ownership with domain-oriented data products, self-serve data infrastructure, federated governance
- **Why it matters**: Organizations with multiple teams producing data. Alternative to centralized data warehouse/lake. `data_warehouse` is centralized-only.
- **What exists**: `data_warehouse` (centralized), `etl_pipeline` (centralized)
- **Skills to create**:
  1. `data_mesh_architecture` — Domain-oriented data products, data product specifications (SLOs, schemas, ownership), self-serve data infrastructure, federated computational governance, data contracts, data mesh on Databricks/Snowflake/BigQuery, mesh vs monolith decision framework
- **Phase**: 2-design
- **Priority**: **Medium**

### GAP 3.12: Confidential Computing / TEEs
- **Domain**: Trusted Execution Environments — Intel SGX, AMD SEV, ARM TrustZone, Azure Confidential Computing
- **Why it matters**: Processing sensitive data (healthcare, finance) where even the cloud provider shouldn't see the data. Required for some regulated industries.
- **What exists**: Zero coverage
- **Skills to create**:
  1. `confidential_computing` — TEE concepts, Intel SGX enclaves, AMD SEV-SNP, Azure Confidential Computing, AWS Nitro Enclaves, attestation protocols, secure multiparty computation, encrypted computation patterns, confidential containers (Kata, Gramine)
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 3.13: Zero-Knowledge Proofs (Beyond Web3)
- **Domain**: ZKP for authentication, identity verification, private computation, compliance proofs — not just blockchain
- **Why it matters**: Proving you're over 18 without revealing your birthdate. Proving compliance without revealing data. This has applications far beyond crypto.
- **What exists**: `web3_security`, `smart_contract_dev` (blockchain context only)
- **Skills to create**:
  1. `zero_knowledge_proofs` — ZK-SNARKs/ZK-STARKs theory, Circom/snarkjs tooling, ZK for identity (age verification, credential proofs), ZK for compliance (prove data meets rules without revealing data), ZK-ML (prove model inference without revealing model), performance considerations, proof generation optimization
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 3.14: Homomorphic Encryption
- **Domain**: Computing on encrypted data without decryption
- **Why it matters**: Ultimate privacy-preserving computation. Healthcare analytics on encrypted patient data. Financial analysis without exposing portfolio. Still performance-limited but maturing.
- **What exists**: `data_privacy_design` (classification, not crypto), `privacy_by_design` (implementation patterns, not HE)
- **Skills to create**:
  1. `homomorphic_encryption` — FHE concepts (BFV, CKKS, TFHE schemes), Microsoft SEAL, OpenFHE, Concrete/Zama, practical FHE applications (encrypted search, private aggregation), performance budgets, CKKS for ML inference, hybrid approaches
- **Phase**: 3-build
- **Priority**: **Low**

### GAP 3.15: AI Governance and Model Cards
- **Domain**: Model documentation, AI system inventory, model risk management, production model governance
- **Why it matters**: `responsible_ai_framework` covers principles. This gap is about the operational artifacts — model cards, data sheets, AI system registries, model risk tiers. Required by EU AI Act.
- **What exists**: `responsible_ai_framework` (principles), `eu_ai_act_compliance` (regulatory)
- **Skills to create**:
  1. `ai_model_governance` — Model cards (Mitchell et al. format), data sheets for datasets, AI system inventory/registry, model risk tiering (SR 11-7 for finance), model validation workflows, bias audit reports, production model governance board processes, automated model documentation generation
- **Phase**: toolkit
- **Priority**: **High**

### GAP 3.16: Prompt Injection Defense (Production Hardening)
- **Domain**: Defense-in-depth for production LLM apps — beyond basic filtering to architectural patterns
- **Why it matters**: `ai_safety_guardrails` covers the attack taxonomy and basic defenses. Production hardening means architectural patterns like dual-LLM, input/output sandboxing, capability-based security for tool use, and continuous monitoring for new attack vectors.
- **What exists**: `ai_safety_guardrails` (attack taxonomy + basic defense)
- **Skills to create**:
  1. `prompt_injection_hardening` — Dual-LLM pattern (privileged/unprivileged), capability-based tool authorization, output validation pipelines, indirect injection defense (document/email/web content poisoning), continuous red team automation, canary token injection detection, production monitoring for injection attempts, incident response for injection breaches
- **Phase**: 4-secure
- **Priority**: **High**

### GAP 3.17: AI Red Teaming Methodologies
- **Domain**: Systematic adversarial testing of AI systems — not just prompt injection but model behavior, bias exploitation, capability elicitation
- **Why it matters**: `ai_safety_guardrails` covers basic red teaming. This is the full methodology — team structure, attack playbooks, reporting standards, continuous red teaming in CI/CD.
- **What exists**: `ai_safety_guardrails` (section on red teaming), `security_audit` (general)
- **Skills to create**:
  1. `ai_red_teaming` — Red team structure and roles, attack taxonomy (MITRE ATLAS), capability elicitation testing, bias and stereotyping probes, multi-turn attack strategies, automated red teaming tools (Garak, PyRIT, Promptfoo adversarial), red team reporting standards, purple teaming (red + blue integration), continuous red teaming in CI/CD
- **Phase**: 4-secure
- **Priority**: **High**

---

## Summary Table

| # | Gap | Domain | Phase | Priority | New Skills |
|---|-----|--------|-------|----------|------------|
| 1.1 | Agent-to-Agent Communication | AI Agents | 3-build | **Critical** | 2 |
| 1.2 | Agent Memory & State | AI Agents | 3-build | **Critical** | 1 |
| 1.3 | Agent Conflict Resolution | AI Agents | 3-build | **Critical** | 1 |
| 1.4 | Agent Evaluation | AI Agents | 4-secure | **Critical** | 1 |
| 1.5 | NVIDIA NeMo Ecosystem | AI Agents | 3-build | **Critical** | 2 |
| 1.6 | NVIDIA NIMs | AI Infra | 5-ship | High | 1 |
| 1.7 | Prompt Library Management | AI Ops | 3-build | High | 1 |
| 1.8 | OpenClaw Platform Patterns | AI Agents | toolkit | High | 1 |
| 2.1 | Quantum Computing | Quantum | 3-build | Medium | 2 |
| 2.2 | Quantum ML | Quantum | 3-build | Low | 1 |
| 2.3 | Physics Simulations | Physics | 3-build | Low | 1 |
| 2.4 | Quant Trading & ML Alpha | Trading | 3-build | High | 2 |
| 2.5 | Backtesting Methodology | Trading | 4-secure | High | 1 |
| 2.6 | Portfolio Risk Management | Trading | 3-build | High | 1 |
| 2.7 | HFT Infrastructure | Trading | 3-build | Low | 1 |
| 3.1 | Edge AI | Edge | 5-ship | High | 1 |
| 3.2 | Federated Learning | ML | 3-build | Medium | 1 |
| 3.3 | Digital Twins | Simulation | 3-build | Medium | 1 |
| 3.4 | AR/VR / Spatial Computing | XR | 3-build | Medium | 1 |
| 3.5 | Robotics / ROS 2 | Robotics | 3-build | Medium | 1 |
| 3.6 | Autonomous Systems | Autonomy | 3-build | Low | 1 |
| 3.7 | NL-to-SQL / Code Gen | AI | 3-build | High | 1 |
| 3.8 | Knowledge Graphs | AI/Data | 3-build | High | 1 |
| 3.9 | Causal Inference | Data Science | 3-build | Medium | 1 |
| 3.10 | Edge MLOps | ML Ops | 5-ship | Medium | 1 |
| 3.11 | Data Mesh | Data Arch | 2-design | Medium | 1 |
| 3.12 | Confidential Computing | Security | 3-build | Low | 1 |
| 3.13 | Zero-Knowledge Proofs | Crypto | 3-build | Low | 1 |
| 3.14 | Homomorphic Encryption | Crypto | 3-build | Low | 1 |
| 3.15 | AI Model Governance | AI Ops | toolkit | High | 1 |
| 3.16 | Prompt Injection Hardening | Security | 4-secure | High | 1 |
| 3.17 | AI Red Teaming | Security | 4-secure | High | 1 |

---

## Totals

| Priority | Gaps | New Skills |
|----------|------|------------|
| Critical | 5 | 7 |
| High | 12 | 13 |
| Medium | 8 | 8 |
| Low | 7 | 7 |
| **Total** | **32** | **35** |

Post-expansion framework size: **304 + 35 = 339 skills**

---

## Recommended Build Order

### Wave 1 — Ship This Week (Critical)
1. `agent_communication_protocols` (3-build)
2. `agent_memory_systems` (3-build)
3. `agent_conflict_resolution` (3-build)
4. `agent_evaluation_framework` (4-secure)
5. `nemo_guardrails` (3-build)
6. `nemo_data_curation` (3-build)

### Wave 2 — Ship Next (High, AI-adjacent)
7. `nvidia_nim_deployment` (5-ship)
8. `prompt_ops` (3-build)
9. `openclaw_platform_patterns` (toolkit)
10. `ai_model_governance` (toolkit)
11. `prompt_injection_hardening` (4-secure)
12. `ai_red_teaming` (4-secure)
13. `knowledge_graph_systems` (3-build)
14. `nl_to_structured_output` (3-build)

### Wave 3 — Ship Next (High, Trading)
15. `quantitative_trading_strategies` (3-build)
16. `ml_trading_signals` (3-build)
17. `backtesting_methodology` (4-secure)
18. `portfolio_risk_management` (3-build)
19. `edge_ai_deployment` (5-ship)

### Wave 4 — Medium Priority
20. `quantum_computing_fundamentals` (3-build)
21. `quantum_optimization_algorithms` (3-build)
22. `federated_learning` (3-build)
23. `digital_twin_development` (3-build)
24. `spatial_computing` (3-build)
25. `robotics_ros2` (3-build)
26. `causal_inference` (3-build)
27. `edge_mlops` (5-ship)
28. `data_mesh_architecture` (2-design)
29. `agent_registry_discovery` (3-build)

### Wave 5 — Low Priority
30. `quantum_machine_learning` (3-build)
31. `computational_physics` (3-build)
32. `hft_infrastructure` (3-build)
33. `autonomous_systems` (3-build)
34. `confidential_computing` (3-build)
35. `zero_knowledge_proofs` (3-build)
36. `homomorphic_encryption` (3-build)

---

## Also Fix: Index Sync

Add these 6 existing skills to `skills-index.md`:
- `ai_agent_fleet_management` (3-build)
- `llm_provider_management` (3-build)
- `voice_ai_patterns` (3-build)
- `websocket_patterns` (3-build)
- `graphql_patterns` (3-build)
- `dast_scanning` (4-secure)

This brings the indexed count from 298 to 304, matching reality.
