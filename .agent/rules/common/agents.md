# Agent Orchestration

## Available Agents

Located in `.agent/agents/`:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| brainstorm-agent | Ideation and specification | Idea-to-spec, PRDs, competitive analysis |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| compliance-agent | Compliance verification | Audit logging, PII, HIPAA/SOC2/PCI/GDPR |
| security-reviewer | Security analysis | Before commits |
| security-agent | Full security audit | OWASP Top 10, secrets, supply chain |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| framework-router | Skill/agent routing | Navigating the framework, finding tools |
| refactor-cleaner | Dead code cleanup | Code maintenance |
| doc-updater | Documentation | Updating docs |
| database-reviewer | Database optimization | Schema design, query tuning, migrations |
| go-reviewer | Go code review | Go projects, idiomatic patterns |
| go-build-resolver | Go build error resolution | Go build/vet failures |
| python-reviewer | Python code review | Python projects, PEP 8, type hints |
| ship-agent | Deployment orchestration | CI/CD, Docker, IaC, deployment gates |
| sre-agent | SRE and observability | Monitoring, SLOs, incidents, capacity |

## Immediate Agent Usage

No user prompt needed:
1. Complex feature requests - Use **planner** agent
2. Code just written/modified - Use **code-reviewer** agent
3. Bug fix or new feature - Use **tdd-guide** agent
4. Architectural decision - Use **architect** agent

## Parallel Task Execution

ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth module
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utilities

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker
