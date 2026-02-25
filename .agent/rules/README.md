# Coding Rules

Always-follow coding guidelines organized by language. Rules are automatically applied when working in the corresponding language context.

## Structure

```
rules/
├── common/          # 9 language-agnostic rules
│   ├── coding-style.md
│   ├── git-workflow.md
│   ├── testing.md
│   ├── performance.md
│   ├── patterns.md
│   ├── hooks.md
│   ├── agents.md
│   ├── security.md
│   └── development-workflow.md
├── typescript/      # 5 TypeScript-specific rules
├── python/          # 5 Python-specific rules
├── golang/          # 5 Go-specific rules
└── swift/           # 5 Swift-specific rules
```

## Usage

Rules are loaded automatically based on project context. You can also reference them explicitly:

```
Follow the rules in .agent/rules/typescript/coding-style.md
```

## Installation

Copy to global Claude config for universal access:
```bash
cp -r .agent/rules/ ~/.claude/rules/
```

## Rule Priority

When language-specific rules and common rules conflict, **language-specific rules take precedence** (specific overrides general). This follows the standard layered configuration pattern.

- `rules/common/` defines universal defaults applicable to all projects.
- `rules/golang/`, `rules/python/`, `rules/typescript/`, etc. override those defaults where language idioms differ.

## Rules vs Skills

- **Rules** define standards, conventions, and checklists that apply broadly (e.g., "80% test coverage", "no hardcoded secrets").
- **Skills** (`skills/` directory) provide deep, actionable reference material for specific tasks.

Language-specific rule files reference relevant skills where appropriate. Rules tell you *what* to do; skills tell you *how* to do it.

## Adding a New Language

To add support for a new language (e.g., `rust/`):

1. Create a `rules/rust/` directory
2. Add files that extend the common rules:
   - `coding-style.md` — formatting tools, idioms, error handling patterns
   - `testing.md` — test framework, coverage tools, test organization
   - `patterns.md` — language-specific design patterns
   - `hooks.md` — PostToolUse hooks for formatters, linters, type checkers
   - `security.md` — secret management, security scanning tools
3. Each file should start with:
   ```
   > This file extends [common/xxx.md](../common/xxx.md) with <Language> specific content.
   ```
4. Reference existing skills if available, or create new ones under `skills/`.

## Related

- [Agents](../agents/README.md) — Agents follow these rules
- [Commands](../commands/README.md) — Commands enforce these rules
