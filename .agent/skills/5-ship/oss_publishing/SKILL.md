---
name: oss_publishing
description: Publishing, maintaining, and growing open source projects across package registries and platforms
---

# OSS Publishing Skill

**Purpose**: Provides a comprehensive guide for preparing, publishing, and maintaining open source projects with proper documentation, licensing, CI/CD, and community management.

## :dart: TRIGGER COMMANDS

```text
"publish open source"
"create npm package"
"set up open source project"
"publish to PyPI"
"prepare repo for open source"
"Using oss_publishing skill: release library"
```

## :page_facing_up: REPOSITORY SETUP

### Essential Files Checklist

| File | Purpose | Required |
|------|---------|----------|
| `README.md` | First impression, usage guide | Yes |
| `LICENSE` | Legal terms for use | Yes |
| `CONTRIBUTING.md` | How to contribute | Yes |
| `CODE_OF_CONDUCT.md` | Community standards | Yes |
| `CHANGELOG.md` | Version history | Yes |
| `SECURITY.md` | Vulnerability reporting | Yes |
| `.github/ISSUE_TEMPLATE/` | Structured bug/feature reports | Recommended |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR guidelines | Recommended |
| `.github/FUNDING.yml` | Sponsorship links | Optional |

### README.md Template

```markdown
# project-name

[![npm version](https://img.shields.io/npm/v/project-name.svg)](https://npmjs.com/package/project-name)
[![CI](https://github.com/org/project-name/actions/workflows/ci.yml/badge.svg)](https://github.com/org/project-name/actions)
[![codecov](https://codecov.io/gh/org/project-name/badge.svg)](https://codecov.io/gh/org/project-name)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

One-line description of what this project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

npm install project-name

## Quick Start

import { thing } from 'project-name';
const result = thing.doSomething();

## API Reference

### `doSomething(options)`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `input` | `string` | required | The input value |
| `verbose` | `boolean` | `false` | Enable verbose logging |

Returns: `Promise<Result>`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and guidelines.

## License

[MIT](LICENSE) - see LICENSE file for details.
```

### CONTRIBUTING.md Template

```markdown
# Contributing to project-name

Thank you for your interest in contributing!

## Development Setup

1. Fork and clone the repository
2. Install dependencies: `npm install`
3. Run tests: `npm test`
4. Create a branch: `git checkout -b feature/your-feature`

## Commit Convention

We use [Conventional Commits](https://conventionalcommits.org/):

- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `test:` adding/updating tests
- `refactor:` code change that neither fixes a bug nor adds a feature
- `chore:` tooling, dependencies, CI changes

## Pull Request Process

1. Update documentation for any changed behavior
2. Add tests for new functionality
3. Ensure CI passes
4. Request review from maintainers

## Code of Conduct

This project follows our [Code of Conduct](CODE_OF_CONDUCT.md).
```

## :balance_scale: LICENSE SELECTION GUIDE

| License | Type | Patent Grant | Copyleft | SaaS Copyleft | Best For |
|---------|------|-------------|----------|---------------|----------|
| **MIT** | Permissive | No | No | No | Maximum adoption, simplest terms |
| **Apache-2.0** | Permissive | Yes | No | No | Corporate-friendly, patent protection |
| **BSD-2-Clause** | Permissive | No | No | No | Similar to MIT, academic origin |
| **BSD-3-Clause** | Permissive | No | No | No | BSD-2 + no endorsement clause |
| **ISC** | Permissive | No | No | No | Simplified MIT, npm default |
| **GPL-3.0** | Copyleft | Yes | Yes | No | Ensuring derivatives stay open |
| **AGPL-3.0** | Strong Copyleft | Yes | Yes | Yes | Preventing proprietary SaaS usage |
| **LGPL-3.0** | Weak Copyleft | Yes | Library only | No | Open libraries, proprietary apps OK |
| **MPL-2.0** | File-level Copyleft | Yes | Per-file | No | Middle ground (Firefox model) |
| **Unlicense** | Public Domain | N/A | No | No | Maximum freedom, no attribution |

> [!TIP]
> When in doubt, choose **MIT** for maximum adoption or **Apache-2.0** if patent protection matters. If you want to ensure forks stay open source, choose **GPL-3.0**. For SaaS products built on your code, **AGPL-3.0** is the only copyleft that covers network use.

> [!WARNING]
> Mixing GPL code with non-GPL code in the same project creates license compatibility issues. Always check dependency licenses before choosing your project license. Tools like `license-checker` or `licensee` can audit your dependency tree.

## :package: NPM PUBLISHING

### package.json Setup

```json
{
  "name": "@yourorg/package-name",
  "version": "1.0.0",
  "description": "One-line description of the package",
  "main": "dist/index.js",
  "module": "dist/index.mjs",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    },
    "./utils": {
      "import": "./dist/utils.mjs",
      "require": "./dist/utils.js",
      "types": "./dist/utils.d.ts"
    }
  },
  "files": [
    "dist",
    "README.md",
    "LICENSE"
  ],
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts",
    "test": "vitest run",
    "prepublishOnly": "npm run build && npm test",
    "release": "npx semantic-release"
  },
  "keywords": ["keyword1", "keyword2", "keyword3"],
  "author": "Your Name <email@example.com>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/org/package-name.git"
  },
  "bugs": {
    "url": "https://github.com/org/package-name/issues"
  },
  "homepage": "https://github.com/org/package-name#readme",
  "engines": {
    "node": ">=18"
  },
  "publishConfig": {
    "access": "public"
  }
}
```

> [!TIP]
> Use the `files` field in package.json rather than `.npmignore`. The `files` field is a whitelist approach (safer) while `.npmignore` is a blacklist (easy to accidentally publish secrets). Always run `npm pack --dry-run` to see exactly what will be published.

### Publishing Workflow

```bash
# First-time setup
npm login
npm whoami  # verify you are logged in

# Verify package contents before publishing
npm pack --dry-run

# Publish (runs prepublishOnly script automatically)
npm publish

# Scoped packages default to private; use --access public
npm publish --access public

# Publish a pre-release
npm version prerelease --preid=beta
npm publish --tag beta
```

## :snake: PYPI PUBLISHING

### pyproject.toml Setup

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "your-package"
version = "1.0.0"
description = "One-line description"
readme = "README.md"
license = { text = "MIT" }
requires-python = ">=3.9"
authors = [{ name = "Your Name", email = "email@example.com" }]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]
dependencies = ["requests>=2.28"]

[project.urls]
Homepage = "https://github.com/org/your-package"
Documentation = "https://your-package.readthedocs.io"
Repository = "https://github.com/org/your-package"
Issues = "https://github.com/org/your-package/issues"
```

```bash
# Build and publish to PyPI
pip install build twine
python -m build
twine check dist/*
twine upload dist/*

# Publish to Test PyPI first
twine upload --repository testpypi dist/*
pip install --index-url https://test.pypi.org/simple/ your-package
```

## :1234: SEMANTIC VERSIONING

| Version Bump | When | Example |
|-------------|------|---------|
| **MAJOR** (X.0.0) | Breaking API changes | Rename exported function, remove feature, change return type |
| **MINOR** (0.X.0) | New features, backward compatible | Add new function, add optional parameter |
| **PATCH** (0.0.X) | Bug fixes, backward compatible | Fix incorrect behavior, performance fix |
| **Pre-release** | Testing before release | `1.0.0-alpha.1`, `1.0.0-beta.3`, `1.0.0-rc.1` |

> [!WARNING]
> While at `0.x.y` (pre-1.0), the API is considered unstable. Minor version bumps may contain breaking changes. Once you release `1.0.0`, you are signaling API stability and must follow semver strictly.

## :robot_face: AUTOMATED RELEASES

### semantic-release Config

```json
// .releaserc.json
{
  "branches": ["main", { "name": "beta", "prerelease": true }],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/github",
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md", "package.json"],
        "message": "chore(release): ${nextRelease.version}\n\n${nextRelease.notes}"
      }
    ]
  ]
}
```

### GitHub Actions Publish Workflow

```yaml
# .github/workflows/publish.yml
name: Publish Package

on:
  push:
    branches: [main, beta]

permissions:
  contents: write
  issues: write
  pull-requests: write
  id-token: write

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 22]
        os: [ubuntu-latest, windows-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
      - name: Upload coverage
        if: matrix.node-version == 20 && matrix.os == 'ubuntu-latest'
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}

  publish:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          persist-credentials: false
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npx semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## :page_with_curl: ISSUE AND PR TEMPLATES

### Bug Report Template

```yaml
# .github/ISSUE_TEMPLATE/bug_report.yml
name: Bug Report
description: Report a bug or unexpected behavior
labels: ["bug", "triage"]
body:
  - type: markdown
    attributes:
      value: |
        Thank you for reporting a bug! Please fill out the sections below.
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: A clear and concise description of the bug.
    validations:
      required: true
  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: Minimal steps to reproduce the behavior.
      value: |
        1. Install with `npm install ...`
        2. Create file with ...
        3. Run ...
        4. See error
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What you expected to happen.
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: Package Version
      placeholder: "1.2.3"
    validations:
      required: true
  - type: dropdown
    id: node-version
    attributes:
      label: Node.js Version
      options:
        - "18"
        - "20"
        - "22"
    validations:
      required: true
  - type: dropdown
    id: os
    attributes:
      label: Operating System
      options:
        - macOS
        - Windows
        - Linux
    validations:
      required: true
```

### Feature Request Template

```yaml
# .github/ISSUE_TEMPLATE/feature_request.yml
name: Feature Request
description: Suggest a new feature or improvement
labels: ["enhancement"]
body:
  - type: textarea
    id: problem
    attributes:
      label: Problem
      description: What problem would this feature solve?
    validations:
      required: true
  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How do you envision this working?
    validations:
      required: true
  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Any alternative approaches you have considered.
```

### Pull Request Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->
## What Changed

Brief description of the changes.

## Why

Motivation and context for this change.

## How to Test

1. Step 1
2. Step 2
3. Expected result

## Checklist

- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Follows commit convention
- [ ] No breaking changes (or clearly documented)
```

## :shield: SECURITY

### SECURITY.md Template

```markdown
# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 2.x     | Yes       |
| 1.x     | Security fixes only |
| < 1.0   | No        |

## Reporting a Vulnerability

Please report security vulnerabilities by emailing security@yourproject.com.

Do NOT create a public GitHub issue for security vulnerabilities.

You should receive a response within 48 hours. We will work with you to
understand and address the issue before any public disclosure.
```

> [!TIP]
> Enable GitHub's private vulnerability reporting feature under repository Settings > Security > Advisories. This lets security researchers report issues privately without needing your email.

## :books: DOCUMENTATION GENERATION

```bash
# TypeScript projects: typedoc
npx typedoc --entryPoints src/index.ts --out docs

# JSDoc generation
npx jsdoc src/ -r -d docs

# Python: Sphinx or mkdocs
pip install mkdocs mkdocs-material
mkdocs build  # generates site/ from docs/

# Host on GitHub Pages
# .github/workflows/docs.yml deploys docs/ on push to main
```

## :white_check_mark: EXIT CHECKLIST

- [ ] README.md is complete with badges, install instructions, usage examples, and API reference
- [ ] LICENSE file present and appropriate for project goals
- [ ] CONTRIBUTING.md explains development setup and PR process
- [ ] CODE_OF_CONDUCT.md established
- [ ] CHANGELOG.md initialized (or auto-generated via semantic-release)
- [ ] SECURITY.md describes responsible disclosure process
- [ ] CI pipeline runs tests on multiple runtimes and operating systems
- [ ] Coverage reporting configured (Codecov / Coveralls)
- [ ] Package successfully published to target registry (npm / PyPI / crates.io)
- [ ] GitHub issue templates added (bug report, feature request)
- [ ] PR template guides contributors
- [ ] Automated release pipeline functional on merge to main
- [ ] API documentation generated and accessible
- [ ] Dependabot or Renovate configured for dependency updates

*Skill Version: 1.0 | Created: February 2026*
