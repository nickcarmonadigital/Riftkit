---
name: Community Management
description: Managing open source communities, contributor ecosystems, and project governance
---

# Community Management Skill

**Purpose**: Structured workflow for setting up, growing, and maintaining healthy open source communities with proper governance, contributor experience, and sustainable funding.

---

## 🎯 TRIGGER COMMANDS

```text
"Set up open source community for [project]"
"Contributor management for [repository]"
"Community guidelines for [project]"
"Open source governance for [organization]"
"Using community_management skill: [task]"
```

---

## 🏗️ Community Infrastructure

| Channel | Purpose | Tool Options | Priority |
|---------|---------|-------------|----------|
| **Code hosting** | Source code, issues, PRs | GitHub, GitLab, Codeberg | Required |
| **Discussions** | Q&A, ideas, show-and-tell | GitHub Discussions, Discourse | Required |
| **Real-time chat** | Quick questions, community bonding | Discord, Slack, Matrix/Element | Recommended |
| **Documentation** | Guides, API reference, tutorials | Docusaurus, MkDocs, Starlight | Required |
| **Blog / Changelog** | Announcements, release notes | Blog in docs site, GitHub Releases | Recommended |
| **Social media** | Awareness, engagement, announcements | Twitter/X, Mastodon, Bluesky, LinkedIn | Optional |
| **Video** | Tutorials, demos, community calls | YouTube, Twitch | Optional |

> [!TIP]
> Start with GitHub (code + issues + discussions) and one real-time chat platform (Discord for open communities, Slack for enterprise-focused projects). Add channels only as the community grows to justify them.

---

## 📄 Essential Repository Files

| File | Purpose | Template |
|------|---------|----------|
| `README.md` | First impression, project overview, quick start | See below |
| `CONTRIBUTING.md` | How to contribute (setup, standards, PR process) | See below |
| `CODE_OF_CONDUCT.md` | Community behavior expectations | Contributor Covenant |
| `LICENSE` | Legal terms for use and contribution | MIT, Apache 2.0, GPL, etc. |
| `CHANGELOG.md` | Version history and notable changes | Keep a Changelog format |
| `SECURITY.md` | How to report vulnerabilities | Private disclosure process |
| `.github/FUNDING.yml` | Sponsorship links | GitHub Sponsors, Open Collective |
| `.github/ISSUE_TEMPLATE/` | Structured issue reporting | Bug report, feature request |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR description structure | What, why, how to test |

---

## 📝 Issue Templates

### Bug Report Template (YAML)

```yaml
# .github/ISSUE_TEMPLATE/bug_report.yml
name: Bug Report
description: Report a bug or unexpected behavior
title: "[Bug]: "
labels: ["bug", "triage"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for reporting a bug! Please fill out the sections below
        so we can reproduce and fix the issue.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear description of what the bug is.
      placeholder: "When I click the submit button, the form..."
    validations:
      required: true

  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: Step-by-step instructions to reproduce the bug.
      value: |
        1. Go to '...'
        2. Click on '...'
        3. Scroll down to '...'
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

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happened. Include error messages or screenshots.
    validations:
      required: true

  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - "Low - Minor inconvenience"
        - "Medium - Feature partially broken"
        - "High - Feature completely broken"
        - "Critical - Data loss or security issue"
    validations:
      required: true

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Your system details.
      value: |
        - OS: [e.g., macOS 14, Windows 11, Ubuntu 22.04]
        - Node.js: [e.g., 20.x]
        - Package version: [e.g., 2.1.0]
        - Browser (if applicable): [e.g., Chrome 120]
    validations:
      required: true

  - type: textarea
    id: additional
    attributes:
      label: Additional Context
      description: Any other context, logs, or screenshots.
```

### Feature Request Template (YAML)

```yaml
# .github/ISSUE_TEMPLATE/feature_request.yml
name: Feature Request
description: Suggest a new feature or enhancement
title: "[Feature]: "
labels: ["enhancement"]
body:
  - type: textarea
    id: problem
    attributes:
      label: Problem Statement
      description: What problem does this feature solve? What is frustrating today?
      placeholder: "I'm always frustrated when..."
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How do you think this should work?
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: What other solutions or workarounds have you considered?

  - type: dropdown
    id: importance
    attributes:
      label: How important is this feature to you?
      options:
        - "Nice to have"
        - "Important - I work around it today"
        - "Critical - Blocking my use of this project"
    validations:
      required: true

  - type: checkboxes
    id: contribution
    attributes:
      label: Contribution
      options:
        - label: I would be willing to submit a PR to implement this feature
```

---

## 🔀 Pull Request Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->
## What Changed
<!-- Describe the changes in this PR. Link to related issues with "Closes #123". -->


## Why
<!-- Why is this change needed? What problem does it solve? -->


## How to Test
<!-- Step-by-step instructions for reviewers to test the changes. -->
1.
2.
3.

## Screenshots (if UI changes)
<!-- Before/after screenshots or recordings -->

## Breaking Changes
<!-- List any breaking changes and migration instructions. Leave empty if none. -->

## Checklist
- [ ] Tests added/updated for the changes
- [ ] Documentation updated (if applicable)
- [ ] CHANGELOG.md updated (for user-facing changes)
- [ ] No breaking changes (or migration guide provided)
- [ ] Self-reviewed the diff for typos, debug code, or leftover comments
```

---

## 🤝 CODE_OF_CONDUCT.md

The **Contributor Covenant** is the most widely adopted code of conduct, used by Linux, Kubernetes, Rails, Swift, and 200,000+ other projects.

| Section | Content |
|---------|---------|
| **Our Pledge** | Welcoming, inclusive, harassment-free experience for everyone |
| **Our Standards** | Examples of acceptable and unacceptable behavior |
| **Enforcement Responsibilities** | Maintainers clarify and enforce standards |
| **Scope** | Applies to all community spaces and representation |
| **Enforcement** | Reporting process and consequences |
| **Attribution** | Link to Contributor Covenant source |

> [!TIP]
> Adopt the Contributor Covenant v2.1 from [contributor-covenant.org](https://www.contributor-covenant.org). Do NOT write your own from scratch -- using a well-known standard signals professionalism and saves legal review time.

---

## 📘 CONTRIBUTING.md Structure

```markdown
<!-- CONTRIBUTING.md template -->
# Contributing to [Project Name]

Thank you for your interest in contributing! This guide will help you get started.

## Development Setup

### Prerequisites
- Node.js 20+
- pnpm 9+
- PostgreSQL 16+ (or Docker)

### Quick Start
\```bash
# Clone the repository
git clone https://github.com/org/project.git
cd project

# Install dependencies
pnpm install

# Set up environment
cp .env.example .env

# Start development
pnpm dev
\```

## Coding Standards

- **TypeScript**: Strict mode enabled, no `any` types
- **Formatting**: Prettier (runs on save, checked in CI)
- **Linting**: ESLint with recommended rules
- **Tests**: Jest for unit tests, Playwright for E2E

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

\```
feat: add user profile page
fix: resolve login timeout on slow connections
docs: update API reference for v2 endpoints
chore: upgrade dependencies to latest versions
\```

**Format**: `type(scope): description`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`

## Pull Request Process

1. Fork the repository and create a branch from `main`
2. Make your changes with tests
3. Run `pnpm test` and `pnpm lint` locally
4. Push your branch and open a Pull Request
5. Fill out the PR template completely
6. Wait for CI to pass and a maintainer review
7. Address feedback, then a maintainer will merge

## Review Process

- PRs require 1 maintainer approval
- CI must pass (tests, lint, build)
- Breaking changes require 2 approvals + RFC discussion
- Maintainers aim to review within 48 hours

## Release Process

We use semantic versioning. Releases are cut by maintainers from `main`:
- `feat` commits -> minor version bump
- `fix` commits -> patch version bump
- Breaking changes -> major version bump
```

---

## 🪜 Contributor Ladder

| Level | Criteria | Permissions | Recognition |
|-------|----------|-------------|-------------|
| **User** | Uses the project | Issues, discussions | None required |
| **Contributor** | 1+ merged PR | Issues, PRs, discussions | Listed in CONTRIBUTORS file |
| **Regular Contributor** | 5+ merged PRs, consistent quality | Triage label (can label/assign issues) | Contributor badge, release credits |
| **Committer** | 10+ PRs, deep domain knowledge, trusted | Write access to repo, review PRs | Team page listing, swag |
| **Maintainer** | Long-term commitment, project direction | Admin access, merge rights, releases | Decision-making authority, conference sponsorship |
| **Lead / BDFL** | Founded or stewarded the project | Full admin, final decisions | Project governance role |

### Onboarding New Contributors

- [ ] Label issues with `good first issue` (aim for 5-10 active at any time)
- [ ] Label issues with `help wanted` for intermediate contributions
- [ ] Provide clear "development setup" docs (copy-paste, not "figure it out")
- [ ] Offer mentorship: reply to first-time PR with welcome message and guidance
- [ ] Set up one-click dev environment (GitHub Codespaces, Gitpod, DevContainer)

---

## 🔄 Changelog Management

### Keep a Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature X for doing Y (#123)

### Fixed
- Resolve timeout error on large file uploads (#456)

## [2.1.0] - 2026-02-01

### Added
- Dashboard export to PDF (#400)
- Dark mode support (#389)

### Changed
- Improved search performance by 3x (#412)

### Deprecated
- Legacy API v1 endpoints (will be removed in v3.0)

### Fixed
- Fix memory leak in WebSocket handler (#401)
- Correct currency formatting for JPY (#405)
```

### Automated Changelog from Conventional Commits

```yaml
# .github/workflows/changelog.yml
name: Generate Changelog

on:
  push:
    tags:
      - 'v*'

jobs:
  changelog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate changelog
        uses: orhun/git-cliff-action@v3
        with:
          config: cliff.toml
          args: --latest --strip header
        env:
          OUTPUT: CHANGELOG.md

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          body_path: CHANGELOG.md
```

---

## 📢 Communication Practices

| Practice | Frequency | Purpose |
|----------|-----------|---------|
| **Release notes** | Per release | Inform users of changes |
| **RFC process** | As needed (major changes) | Community input on design decisions |
| **Community meetings** | Monthly (or quarterly) | Face-to-face discussion, roadmap alignment |
| **Roadmap updates** | Quarterly | Transparency on project direction |
| **Blog posts** | Monthly (aspirational) | Deep dives, tutorials, retrospectives |
| **Social media** | Weekly | Awareness, engagement, ecosystem growth |

### RFC Process for Major Changes

| Stage | Duration | Action |
|-------|----------|--------|
| **Draft** | Author writes | Proposal with problem, solution, alternatives |
| **Discussion** | 2 weeks | Community feedback in GitHub Discussion or issue |
| **Revision** | 1 week | Author incorporates feedback |
| **Decision** | Maintainers | Accept, reject, or defer with rationale |
| **Implementation** | Varies | Linked PRs reference the RFC |

---

## 🛡️ Moderation

### Enforcement Ladder

| Level | Behavior | Response |
|-------|----------|----------|
| **1. Correction** | First minor offense | Private message pointing to Code of Conduct |
| **2. Warning** | Repeated minor or single moderate offense | Public warning, required acknowledgment |
| **3. Temporary Ban** | Serious violation or continued behavior | 1-4 week ban from all community spaces |
| **4. Permanent Ban** | Severe violation, threats, sustained harassment | Permanent removal, block from all platforms |

> [!WARNING]
> Document all moderation actions privately. Keep records of the behavior, the action taken, and who made the decision. This protects both the community and the moderators if decisions are questioned.

---

## 🏆 Recognition and Retention

| Method | Effort | Impact | Implementation |
|--------|--------|--------|----------------|
| **CONTRIBUTORS file** | Low | Medium | Auto-generated from git history or all-contributors bot |
| **Release credits** | Low | Medium | "Thanks to @user1, @user2" in release notes |
| **Social media shoutout** | Low | High | Tweet/post about notable contributions |
| **Contributor badge** | Low | Medium | GitHub org membership, special Discord role |
| **Swag / merch** | Medium | High | Stickers, t-shirts for regular contributors |
| **Conference sponsorship** | High | Very High | Sponsor travel/tickets for top contributors |
| **Paid bounties** | High | Variable | Targeted funding for specific issues |

### All Contributors Bot

```json
// .all-contributorsrc
{
  "projectName": "my-project",
  "projectOwner": "my-org",
  "repoType": "github",
  "repoHost": "https://github.com",
  "files": ["README.md"],
  "imageSize": 100,
  "commit": true,
  "commitConvention": "angular",
  "contributorsPerLine": 7,
  "contributors": []
}
```

Usage: Comment `@all-contributors please add @username for code, docs` on any issue or PR.

---

## 💰 Funding Models

| Model | Best For | Examples | Considerations |
|-------|----------|---------|----------------|
| **GitHub Sponsors** | Individual maintainers | Profile-based sponsorship | Low friction, GitHub integration |
| **Open Collective** | Project-level funding | Transparent budget management | Public expense tracking, fiscal hosting |
| **Corporate sponsorship** | High-impact projects | Logo on README, priority support | Requires negotiation, potential conflicts |
| **Grants** | Infrastructure, public good | NLnet, Sovereign Tech Fund, Ford Foundation | Application process, deliverables required |
| **Dual licensing** | Developer tools, libraries | Open core + commercial license | Community edition free, enterprise paid |
| **Bounties** | Specific features/fixes | Funded by users who need them | IssueHunt, Polar, Algora |
| **Support/consulting** | Mature projects | Paid support tiers, consulting | Time-intensive, not scalable |

```yaml
# .github/FUNDING.yml
github: [maintainer-username]
open_collective: project-name
custom:
  - https://my-project.dev/sponsor
```

---

## 📊 Community Health Metrics

| Metric | How to Measure | Healthy Target |
|--------|---------------|----------------|
| **Issue response time** | Time from issue creation to first maintainer reply | < 48 hours |
| **PR merge time** | Time from PR creation to merge | < 1 week (for non-breaking) |
| **Contributor count** | Unique PR authors per quarter | Growing quarter-over-quarter |
| **Contributor retention** | % of contributors who contribute again within 6 months | > 30% |
| **Community growth** | Stars, forks, Discord members | Steady growth |
| **Bus factor** | Number of people who understand critical code | > 2 for each area |

---

## 🏛️ Governance Models

| Model | Decision Making | Best For | Examples |
|-------|----------------|----------|---------|
| **BDFL** | Single leader has final say | Small projects, strong vision | Python (historically), Linux |
| **Steering Committee** | Elected/appointed group votes | Medium projects, shared ownership | Node.js TSC, Rust Core Team |
| **Foundation** | Formal organization with bylaws | Large ecosystem projects | Apache, Linux Foundation, CNCF |
| **Corporate-backed** | Company drives development | Company-created open source | React (Meta), Angular (Google), Next.js (Vercel) |
| **Consensus** | All maintainers must agree | Small, tight-knit teams | Many small projects |

---

## 🤖 GitHub Actions for Community Automation

### Auto-Label PRs

```yaml
# .github/workflows/auto-label.yml
name: Auto Label PRs

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  label:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      - uses: actions/labeler@v5
        with:
          repo-token: "${{ secrets.GITHUB_TOKEN }}"
          configuration-path: .github/labeler.yml
```

```yaml
# .github/labeler.yml
documentation:
  - changed-files:
      - any-glob-to-any-file: ['docs/**', '*.md']

frontend:
  - changed-files:
      - any-glob-to-any-file: ['src/frontend/**', '*.tsx', '*.css']

backend:
  - changed-files:
      - any-glob-to-any-file: ['src/backend/**', 'src/api/**']

tests:
  - changed-files:
      - any-glob-to-any-file: ['**/*.test.*', '**/*.spec.*', 'tests/**']

dependencies:
  - changed-files:
      - any-glob-to-any-file: ['package.json', 'pnpm-lock.yaml', 'requirements.txt']
```

### Welcome First-Time Contributors

```yaml
# .github/workflows/welcome.yml
name: Welcome New Contributors

on:
  pull_request_target:
    types: [opened]

jobs:
  welcome:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      - uses: actions/first-interaction@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          pr-message: |
            Welcome to the project, @${{ github.event.pull_request.user.login }}! 🎉

            Thank you for your first pull request! A maintainer will review it shortly.

            While you wait, please make sure:
            - [ ] Tests pass (`pnpm test`)
            - [ ] Linting passes (`pnpm lint`)
            - [ ] PR description is filled out

            If you have questions, feel free to ask here or in our [Discord](https://discord.gg/example).
          issue-message: |
            Thanks for opening your first issue, @${{ github.event.issue.user.login }}!
            A maintainer will triage it shortly.
```

### Stale Issue Management

```yaml
# .github/workflows/stale.yml
name: Close Stale Issues

on:
  schedule:
    - cron: '0 6 * * 1'  # Every Monday at 6 AM UTC

jobs:
  stale:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      pull-requests: write
    steps:
      - uses: actions/stale@v9
        with:
          stale-issue-message: >
            This issue has been automatically marked as stale because it has
            not had activity in 60 days. It will be closed in 14 days if no
            further activity occurs. If this issue is still relevant, please
            comment to keep it open.
          stale-pr-message: >
            This pull request has been automatically marked as stale because
            it has not had activity in 30 days. Please update or close it.
          days-before-issue-stale: 60
          days-before-issue-close: 14
          days-before-pr-stale: 30
          days-before-pr-close: 14
          stale-issue-label: stale
          stale-pr-label: stale
          exempt-issue-labels: 'pinned,security,good first issue'
          exempt-pr-labels: 'pinned,work-in-progress'
```

---

## ✅ EXIT CHECKLIST

- [ ] README.md is welcoming with clear quick-start instructions
- [ ] CONTRIBUTING.md documents dev setup, coding standards, and PR process
- [ ] CODE_OF_CONDUCT.md adopted (Contributor Covenant recommended)
- [ ] LICENSE file present and appropriate for project goals
- [ ] Issue templates configured (bug report, feature request)
- [ ] PR template configured with checklist
- [ ] `good first issue` label applied to 5+ beginner-friendly issues
- [ ] CHANGELOG.md maintained (manually or auto-generated)
- [ ] SECURITY.md with vulnerability disclosure process
- [ ] Communication channels set up (Discussions, Discord/Slack)
- [ ] Moderation policy documented and enforceable
- [ ] FUNDING.yml configured (if accepting sponsorship)
- [ ] CI/CD runs on all PRs (tests, lint, build)
- [ ] Community automation in place (auto-label, welcome bot, stale management)

---

*Skill Version: 1.0 | Created: February 2026*
