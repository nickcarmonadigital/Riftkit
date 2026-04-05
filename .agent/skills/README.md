# Skills Guide

**352 skills** across 11 phases covering the complete software development lifecycle plus cross-cutting domains.

## Lifecycle Flow

```mermaid
graph LR
    P0[Phase 0\nContext\n23 skills] --> P1[Phase 1\nBrainstorm\n14 skills]
    P1 --> P2[Phase 2\nDesign\n29 skills]
    P2 --> P3[Phase 3\nBuild\n131 skills]
    P3 --> P4[Phase 4\nSecure\n47 skills]
    P4 --> P5[Phase 5\nShip\n25 skills]
    P5 --> P55[Phase 5.5\nAlpha\n10 skills]
    P55 --> P575[Phase 5.75\nBeta\n13 skills]
    P575 --> P6[Phase 6\nHandoff\n14 skills]
    P6 --> P7[Phase 7\nMaintenance\n13 skills]

    TK[Toolkit\n33 skills] -.-> P0
    TK -.-> P3
    TK -.-> P4
    TK -.-> P7

    style P0 fill:#e3f2fd,stroke:#1565c0
    style P1 fill:#e3f2fd,stroke:#1565c0
    style P2 fill:#e0f2f1,stroke:#00695c
    style P3 fill:#fff9c4,stroke:#fbc02d
    style P4 fill:#ffebee,stroke:#c62828
    style P5 fill:#f3e5f5,stroke:#7b1fa2
    style P55 fill:#f3e5f5,stroke:#7b1fa2
    style P575 fill:#f3e5f5,stroke:#7b1fa2
    style P6 fill:#fff3e0,stroke:#ef6c00
    style P7 fill:#f5f5f5,stroke:#616161
    style TK fill:#e8f5e9,stroke:#2e7d32
```

## Phase 3 — Build Domain Coverage

The Build phase covers 131 skills across these domains:

```mermaid
graph TD
    Build[Phase 3: Build\n131 skills] --> Web[Web & API\napi_design, frontend_patterns\nbackend_patterns, graphql_patterns]
    Build --> AI[AI & Agents\nai_agent_development\nagent_communication_protocols\nagent_memory_systems\nvoice_ai_patterns]
    Build --> ML[ML & Data\nml_pipeline, rag_advanced_patterns\nlora_finetuning_workflow\nnemo_guardrails]
    Build --> Trading[Trading & Finance\nquantitative_trading_strategies\nml_trading_signals\nportfolio_risk_management]
    Build --> Infra[Infrastructure\nkubernetes_operations\ndocker_development\nservice_mesh_patterns]
    Build --> Quantum[Quantum & Physics\nquantum_computing_fundamentals\nquantum_optimization_algorithms\ncomputational_physics]
    Build --> Frontier[Frontier Tech\nrobotrics_ros2, spatial_computing\nautonomous_systems\ndigital_twin_development]

    style Build fill:#fff9c4,stroke:#fbc02d
    style AI fill:#e8f5e9,stroke:#2e7d32
    style ML fill:#e8f5e9,stroke:#2e7d32
    style Trading fill:#fff3e0,stroke:#ef6c00
    style Quantum fill:#e3f2fd,stroke:#1565c0
    style Frontier fill:#f3e5f5,stroke:#7b1fa2
```

## Quick Navigation

| Phase | Count | Focus | Start Here |
|-------|-------|-------|------------|
| [0-context](./0-context/) | 23 | Project understanding | `new_project`, `codebase_navigation` |
| [1-brainstorm](./1-brainstorm/) | 14 | Ideas to specs | `idea_to_spec`, `prd_generator` |
| [2-design](./2-design/) | 29 | Architecture | `atomic_reverse_architecture`, `feature_architecture` |
| [3-build](./3-build/) | 131 | Implementation | `spec_build`, `ai_agent_development`, `api_design` |
| [4-secure](./4-secure/) | 47 | Testing + security | `security_audit`, `tdd_workflow`, `ai_red_teaming` |
| [5-ship](./5-ship/) | 25 | Deployment | `ci_cd_pipeline`, `deployment_patterns`, `nvidia_nim_deployment` |
| [5.5-alpha](./5.5-alpha/) | 10 | Early ops | `error_tracking`, `health_checks` |
| [5.75-beta](./5.75-beta/) | 13 | User feedback | `product_analytics`, `feedback_system` |
| [6-handoff](./6-handoff/) | 14 | Documentation | `api_reference`, `feature_walkthrough` |
| [7-maintenance](./7-maintenance/) | 13 | Sustainability | `incident_response_operations`, `slo_sla_management` |
| [toolkit](./toolkit/) | 33 | Cross-cutting | `age` (ATOM v3), `openclaw_platform_patterns` |

## Skill File Format

Every skill lives at `.agent/skills/{phase}/{skill_name}/SKILL.md` and contains:

```
---
name: "Skill Name"
description: "What it does"
triggers:
  - "/trigger-command"
---

# Skill Name

## WHEN TO USE
## PROCESS
## CHECKLIST
## Related Skills
```

For the complete 352-skill index, see [skills-index.md](../skills-index.md) or [CLAUDE.md](../../CLAUDE.md).
