---
description: New developer onboarding workflow — structured ramp-up process from project context through first contribution, ensuring new team members learn codebase conventions and deliver safely.
---

# /onboarding-new-dev Workflow

> Use when a new developer joins the team. Follow steps in order — each builds on the previous. Goal: first meaningful contribution within the first week.

## When to Use

- [ ] New developer joining the team
- [ ] Developer switching to an unfamiliar project
- [ ] Contractor or consultant starting engagement
- [ ] Returning developer after extended absence

---

## Step 1: Context — Understand the Project

Learn what the project does, who it serves, and why it exists.

```bash
view_file .agent/skills/0-context/project_context/SKILL.md
view_file .agent/skills/0-context/codebase_navigation/SKILL.md
```

- [ ] Project purpose and business context understood
- [ ] Target users and key use cases identified
- [ ] Tech stack cataloged (language, framework, database, infrastructure)
- [ ] Repository structure navigated (where things live)
- [ ] Key entry points identified (main files, routers, config)
- [ ] Existing documentation read (README, architecture docs, ADRs)

---

## Step 2: Environment — Get Running Locally

Set up a working development environment.

```bash
view_file .agent/skills/3-build/dev_environment_setup/SKILL.md
```

- [ ] Repository cloned and dependencies installed
- [ ] Environment variables configured (.env from .env.example)
- [ ] Database running locally (Docker or local install)
- [ ] Application starts without errors
- [ ] Tests run and pass locally
- [ ] Development server accessible in browser (if applicable)
- [ ] IDE/editor configured (linting, formatting, extensions)

**Gate**: Application must build, start, and pass tests locally before proceeding.

---

## Step 3: Architecture — Understand the System Design

Learn how the system is structured and why decisions were made.

```bash
view_file .agent/skills/2-design/architecture_recovery/SKILL.md
view_file .agent/skills/2-design/system_design_review/SKILL.md
```

- [ ] High-level architecture diagram reviewed (or created if missing)
- [ ] Data model understood (key entities and relationships)
- [ ] API structure understood (routes, controllers, services)
- [ ] Authentication and authorization flow understood
- [ ] External integrations identified (APIs, services, queues)
- [ ] Key architectural decisions understood (why X instead of Y)

---

## Step 4: Guidelines — Learn Team Standards

Understand how this team writes and ships code.

```bash
view_file .agent/skills/0-context/project_guidelines/SKILL.md
view_file .agent/skills/3-build/git_workflow/SKILL.md
```

- [ ] Coding style and conventions reviewed (linting rules, naming)
- [ ] Git workflow understood (branching strategy, commit conventions)
- [ ] PR process understood (reviewers, required checks, merge strategy)
- [ ] Testing expectations understood (unit, integration, e2e)
- [ ] Deployment process understood (how code gets to production)
- [ ] Communication norms understood (standups, channels, async vs. sync)

---

## Step 5: First Task — Low-Risk Starter

Ship something small to build confidence and learn the workflow end-to-end.

```bash
view_file .agent/skills/3-build/bug_troubleshoot/SKILL.md
```

- [ ] Starter task assigned (small bug fix or minor enhancement)
- [ ] Task is low-risk (non-critical path, easily reversible)
- [ ] Task touches a representative part of the codebase
- [ ] Buddy or mentor assigned for questions
- [ ] Implementation completed following team conventions
- [ ] Full workflow exercised: branch, code, test, PR, deploy

---

## Step 6: Code Review — Learn Team Standards in Practice

Submit work for review and learn from feedback.

```bash
view_file .agent/skills/4-secure/code_review_response/SKILL.md
```

- [ ] PR submitted following team template
- [ ] Code review feedback received and addressed
- [ ] Review comments used as learning opportunities (not just fixes)
- [ ] Common patterns noted (what reviewers consistently flag)
- [ ] PR approved and merged
- [ ] Deployment verified for merged changes

---

## Step 7: Testing — Learn Test Patterns

Understand how the team tests and write tests for your code.

```bash
view_file .agent/skills/3-build/tdd_workflow/SKILL.md
```

- [ ] Test structure understood (file organization, naming conventions)
- [ ] Test utilities and helpers discovered (factories, fixtures, mocks)
- [ ] Unit test written for a function or service method
- [ ] Integration test written for an API endpoint
- [ ] Test coverage tools understood (how to check, minimum thresholds)
- [ ] CI test pipeline understood (what runs, when, how to debug failures)

---

## Step 8: Documentation — Document What You Learned

Capture knowledge gaps and improve docs for the next person.

```bash
view_file .agent/skills/6-handoff/feature_walkthrough/SKILL.md
```

- [ ] "New developer" perspective documented (what was confusing, what was missing)
- [ ] Setup instructions verified and updated (anything that didn't work)
- [ ] Architecture documentation gaps filled (if any found)
- [ ] FAQ or gotchas document updated with lessons learned
- [ ] Knowledge shared with team (standup, retro, or written summary)

---

## Exit Checklist — Onboarding Complete

- [ ] Development environment fully functional
- [ ] Architecture and codebase understood at working level
- [ ] Team conventions and workflow internalized
- [ ] First contribution merged and deployed
- [ ] Code review process experienced
- [ ] Test patterns understood and practiced
- [ ] Documentation improved for next new developer
- [ ] Comfortable picking up tasks independently

*Workflow Version: 1.0 | Created: March 2026*
