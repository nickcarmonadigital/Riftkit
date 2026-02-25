# Slash Commands

32 slash commands for Claude Code automation. Commands are the primary interface for invoking agents, workflows, and development tools.

## Usage

Invoke commands in Claude Code with the `/` prefix:

```
/plan — Create implementation plan
/tdd — Test-driven development workflow
/code-review — Automated code review
/build-fix — Fix build errors
/e2e — Run end-to-end tests
```

## Available Commands

### Planning & Architecture
- `/plan` — Create detailed implementation plan
- `/multi-plan` — Multi-step planning for complex features
- `/orchestrate` — Orchestrate multi-agent workflows

### Development
- `/tdd` — Test-driven development workflow  
- `/build-fix` — Automated build error resolution
- `/go-build` — Go build error resolution
- `/go-review` — Go code review
- `/go-test` — Go test workflow
- `/python-review` — Python code review
- `/refactor-clean` — Dead code removal and cleanup

### Testing & Quality
- `/code-review` — Comprehensive code review
- `/e2e` — End-to-end test execution
- `/verify` — Verification loop
- `/test-coverage` — Test coverage analysis
- `/eval` — Evaluation harness

### Multi-Agent
- `/multi-execute` — Multi-agent execution
- `/multi-workflow` — Multi-agent workflow
- `/multi-backend` — Multi-agent backend development
- `/multi-frontend` — Multi-agent frontend development

### Learning & Evolution
- `/learn` — Extract patterns from session
- `/learn-eval` — Evaluate learned patterns
- `/evolve` — Evolve instincts from patterns
- `/skill-create` — Create new skills
- `/instinct-status` — View instinct status
- `/instinct-export` — Export instincts
- `/instinct-import` — Import instincts

### Documentation & Maintenance
- `/update-docs` — Update documentation
- `/update-codemaps` — Update code maps
- `/checkpoint` — Create session checkpoint

### Infrastructure
- `/sessions` — Manage sessions
- `/pm2` — PM2 process management
- `/setup-pm` — Setup package manager

## Installation

To install commands globally:
```bash
./install.sh  # Copies to ~/.claude/commands/
```

Or copy individual commands:
```bash
cp .agent/commands/plan.md ~/.claude/commands/
```

## Related

- [Agents](../agents/README.md) — Commands invoke these agents
- [Rules](../rules/README.md) — Commands follow these guidelines
- [Hooks](../hooks/README.md) — Event-driven automations
