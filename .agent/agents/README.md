# Specialized Agents

19 AI subagents for automated development workflows. Each agent is optimized for a specific role with appropriate model selection and tool access.

## Usage

Reference agents in your CLAUDE.md or invoke via slash commands:

```
Use the code-reviewer agent to review my changes
```

## Available Agents

| Agent | Model | Tools | Phase |
|-------|-------|-------|-------|
| planner | Opus | Read, Grep, Glob | 2-design, 3-build |
| architect | Opus | Read, Grep, Glob | 2-design |
| code-reviewer | Sonnet | Read, Grep, Glob, Bash | 3-build, 4-secure |
| security-reviewer | Opus | Read, Grep, Glob, Bash | 4-secure |
| tdd-guide | Sonnet | All | 3-build, 4-secure |
| build-error-resolver | Sonnet | All | 3-build |
| e2e-runner | Sonnet | All | 4-secure |
| doc-updater | Haiku | All | 6-handoff |
| refactor-cleaner | Sonnet | All | 3-build, 7-maintenance |
| database-reviewer | Sonnet | Read, Grep, Glob, Bash | 3-build |
| go-reviewer | Sonnet | Read, Grep, Glob, Bash | 3-build |
| go-build-resolver | Sonnet | All | 3-build |
| python-reviewer | Sonnet | Read, Grep, Glob, Bash | 3-build |
| brainstorm-agent | Sonnet | Read, Grep, Glob | 1-brainstorm |
| compliance-agent | Sonnet | Read, Grep, Glob, Bash | 4-secure |
| security-agent | Sonnet | Read, Grep, Glob, Bash | 4-secure |
| sre-agent | Sonnet | All | 7-maintenance |
| ship-agent | Sonnet | All | 5-ship |
| framework-router | Sonnet | Read, Grep, Glob | All phases |

## Model Selection Guide

- **Opus**: Complex reasoning tasks (planning, architecture, security)
- **Sonnet**: Balanced capability (reviews, testing, building)
- **Haiku**: Fast, simple tasks (documentation updates)

## Related

- [Slash Commands](../commands/README.md) — Many commands invoke these agents
- [Rules](../rules/README.md) — Agents follow these coding guidelines
- [Skills Index](../skills-index.md) — Full skill catalog by lifecycle phase
