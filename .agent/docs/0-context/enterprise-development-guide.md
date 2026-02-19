# Enterprise Development Guide

> **What changes when you work at a company vs. building personal projects.** Enterprise development has processes, approvals, compliance, and team structures that exist for good reasons. This guide explains what they are and why they matter.

---

## 1. Team Structures & Roles

### Who You'll Work With

| Role | What They Do | How You Interact |
|------|-------------|-----------------|
| **Engineering Manager (EM)** | People management, hiring, 1:1s, career growth | Your direct manager. Weekly 1:1s. Discuss career, blockers, feedback |
| **Tech Lead (TL)** | Technical direction, architecture decisions, code quality | Your technical mentor. Approve designs, review PRs, guide decisions |
| **Staff/Principal Engineer** | Cross-team architecture, technical strategy | Set standards you follow. Consult on complex designs |
| **Product Manager (PM)** | What to build and why (priorities, roadmap, user needs) | They define requirements. You estimate effort and flag risks |
| **Designer (UX/UI)** | User experience, mockups, design systems | Provide Figma designs. You implement them. Ask questions early |
| **QA Engineer** | Testing strategy, test automation, bug triage | They test your features. Share test plans. Fix bugs they find |
| **SRE / DevOps** | Infrastructure, deployments, monitoring, on-call | They manage prod. You write code that runs on their infra |
| **Security Engineer** | Threat modeling, security reviews, compliance | Review security-sensitive code with them |

### IC Levels (Individual Contributor Career Ladder)

| Level | Title | Expectations |
|-------|-------|-------------|
| L3 / Junior | Junior/Associate Engineer | Execute well-defined tasks. Learn the codebase. Ask questions. |
| L4 / Mid | Software Engineer | Own features end-to-end. Design simple systems. Mentor juniors. |
| L5 / Senior | Senior Engineer | Lead projects. Design complex systems. Influence team direction. |
| L6 / Staff | Staff Engineer | Cross-team impact. Define architecture. Set technical strategy. |
| L7 / Principal | Principal Engineer | Org-wide impact. Industry expertise. Define technical vision. |

**Where you are**: L3/L4. Your job is to execute tasks well, learn quickly, and communicate proactively. Nobody expects you to design systems yet.

---

## 2. Compliance Frameworks

### Why Compliance Exists

Companies that handle user data, financial data, or health data are legally required to protect it. Violations mean fines (millions of dollars), lawsuits, and lost customer trust.

As a developer, compliance affects HOW you write code. You don't need to memorize regulations, but you need to follow the engineering practices they require.

### Framework Overview

| Framework | Applies When | What It Means for You |
|-----------|-------------|----------------------|
| **GDPR** | You have EU users | User data deletion on request, consent for data collection, data portability, privacy by design |
| **SOC 2** | B2B SaaS companies | Access controls, audit logging, change management, encryption, incident response |
| **HIPAA** | Health data | Encryption at rest + in transit, access logging, minimum necessary access, BAAs with vendors |
| **PCI-DSS** | Credit card processing | Never store raw card numbers, use Stripe/payment processor, network segmentation |
| **CCPA** | California users | Similar to GDPR — opt-out of data sale, deletion rights, disclosure of data collected |

### What Developers Must Do

```
ALWAYS:
✅ Encrypt sensitive data at rest and in transit (HTTPS, bcrypt)
✅ Log access to sensitive data (who accessed what, when)
✅ Implement role-based access control
✅ Support data deletion requests (GDPR right to be forgotten)
✅ Use environment variables for secrets (never hardcode)
✅ Review third-party dependencies for security

NEVER:
❌ Store raw credit card numbers (use Stripe tokens)
❌ Log passwords, SSNs, or full credit card numbers
❌ Give everyone admin access "for convenience"
❌ Skip encryption because "it's just internal"
❌ Use personal email for work communications
❌ Copy production data to your local machine
```

---

## 3. Change Management / CAB

### Why Changes Need Approval

In personal projects, you push to production whenever you want. In enterprise, a bad deployment can:
- Cost the company revenue (downtime)
- Violate SLAs with customers
- Corrupt data for thousands of users
- Trigger compliance violations

### Change Advisory Board (CAB)

The CAB reviews significant changes before they go to production. Not every change needs CAB review — most companies have tiers:

| Change Type | Approval Needed | Example |
|-------------|----------------|---------|
| **Standard** | Pre-approved, no review needed | Dependency update, config change, feature flag toggle |
| **Normal** | Team lead approval + CI passing | New feature, API change, schema migration |
| **Emergency** | Manager approval, post-review | Hotfix for production outage |
| **Major** | CAB review, scheduled maintenance window | Database migration, infrastructure change, breaking API change |

### Change Request Template

```markdown
## Change Request

**What**: [What you're changing]
**Why**: [Business reason]
**Risk**: Low / Medium / High
**Rollback plan**: [How to undo if something goes wrong]
**Testing done**: [What tests passed]
**Affected services**: [What could break]
**Deployment window**: [When you want to deploy]
```

---

## 4. Incident Management / On-Call

### Severity Levels

| Severity | Impact | Response Time | Example |
|----------|--------|--------------|---------|
| **SEV1** (Critical) | Service completely down, all users affected | Immediate (15 min) | Database crashed, app returns 500 for all requests |
| **SEV2** (High) | Major feature broken, many users affected | 30 minutes | Login broken, payment processing failing |
| **SEV3** (Medium) | Feature degraded, some users affected | 4 hours | Search is slow, dashboard shows stale data |
| **SEV4** (Low) | Minor issue, workaround exists | Next business day | UI alignment bug, non-critical feature broken |

### Incident Response Process

```
1. DETECT    → Alert fires OR user reports issue
2. TRIAGE    → Assess severity (SEV1-4)
3. ASSEMBLE  → Page the on-call engineer + incident commander
4. MITIGATE  → Stop the bleeding (rollback, disable feature, scale up)
5. FIX       → Root cause fix (may be after mitigation)
6. REVIEW    → Postmortem within 48 hours (blameless!)
```

### The Incident Commander

During a SEV1/SEV2, one person is the Incident Commander (IC). They:
- Coordinate the response (who does what)
- Communicate status updates to stakeholders
- Make decisions (rollback vs. hotfix)
- Document the timeline

**You won't be IC as a junior.** But you may be on-call and need to triage and escalate.

### Blameless Postmortems

After an incident, the team writes a postmortem. The goal is to improve the system, NOT to blame a person.

```markdown
## Postmortem: [Incident Title]

**Date**: [Date]
**Duration**: [Start time → End time]
**Severity**: SEV[1-4]
**Impact**: [What users experienced]

### Timeline
- HH:MM — [What happened]
- HH:MM — [Action taken]

### Root Cause
[Why it happened — technical root cause]

### Contributing Factors
[Process/tooling gaps that allowed it]

### Action Items
- [ ] [Fix to prevent recurrence] — Owner: [Name] — Due: [Date]
- [ ] [Process improvement] — Owner: [Name] — Due: [Date]

### Lessons Learned
[What we learned]
```

---

## 5. SLA / SLO / SLI

### Definitions

| Term | What It Is | Example |
|------|-----------|---------|
| **SLI** (Service Level Indicator) | The metric you measure | Request latency p95, error rate, uptime percentage |
| **SLO** (Service Level Objective) | Your internal target | "99.9% of requests complete in < 500ms" |
| **SLA** (Service Level Agreement) | Contractual promise to customers | "99.9% uptime. If we violate, you get service credits" |

### What "Nines" Mean

| Uptime | Downtime/Year | Downtime/Month | Downtime/Week |
|--------|--------------|----------------|---------------|
| 99% | 3.65 days | 7.3 hours | 1.68 hours |
| 99.9% | 8.77 hours | 43.8 minutes | 10.1 minutes |
| 99.95% | 4.38 hours | 21.9 minutes | 5.04 minutes |
| 99.99% | 52.6 minutes | 4.38 minutes | 1.01 minutes |

**Reality check**: 99.9% uptime means you can only have ~43 minutes of downtime PER MONTH. Every deployment, every migration, every bug — all included.

---

## 6. Multi-Tenancy

### What It Is

Most enterprise SaaS serves multiple customers (tenants) from the same application. The challenge: keep each tenant's data completely isolated.

### Strategies

| Strategy | How It Works | When to Use |
|----------|-------------|-------------|
| **Row-Level Security** | All tenants share tables, filtered by `tenantId` | Most common. Simple. Works for most apps. |
| **Schema-Per-Tenant** | Each tenant gets their own PostgreSQL schema | Medium isolation. More complex migrations. |
| **Database-Per-Tenant** | Each tenant gets their own database | Maximum isolation. Most complex. Required for some compliance. |

### Row-Level Security in Practice (Prisma)

```typescript
// Every query MUST include tenantId
const projects = await this.prisma.project.findMany({
  where: {
    tenantId: user.tenantId, // ALWAYS filter by tenant
    ...otherFilters,
  },
});

// Middleware to enforce tenant isolation
prisma.$use(async (params, next) => {
  if (params.action === 'findMany' || params.action === 'findFirst') {
    if (!params.args.where?.tenantId) {
      throw new Error('tenantId is required for all queries');
    }
  }
  return next(params);
});
```

---

## 7. Release Management

### Release Process

| Phase | What Happens |
|-------|-------------|
| **Feature Development** | Developers work on feature branches, merge to `develop` |
| **Code Freeze** | No new features. Only bug fixes for the release |
| **Release Candidate (RC)** | Deploy `develop` to staging. QA tests. Fix bugs found. |
| **Release** | Merge to `main`, tag version, deploy to production |
| **Hotfix** | Emergency fix branched from `main`, deployed immediately |

### Versioning (Semantic Versioning)

```
MAJOR.MINOR.PATCH
  3.2.1

MAJOR = Breaking changes (users must update their code)
MINOR = New features (backwards compatible)
PATCH = Bug fixes (backwards compatible)
```

### Feature Flags

Feature flags let you deploy code to production without exposing it to all users:

```typescript
// Code is deployed but hidden behind a flag
if (await this.featureFlags.isEnabled('new-dashboard', user.id)) {
  return this.newDashboardService.getData();
} else {
  return this.legacyDashboardService.getData();
}
```

Benefits:
- Deploy anytime, enable when ready
- Gradual rollout (1% → 10% → 50% → 100%)
- Instant rollback (disable the flag)
- A/B testing

---

## 8. CODEOWNERS

### What It Is

A `CODEOWNERS` file in your repository specifies who must review changes to specific directories.

```
# .github/CODEOWNERS

# Backend team owns all backend code
/src/backend/          @backend-team

# Frontend team owns all frontend code
/src/frontend/         @frontend-team

# Security team must review auth changes
/src/auth/             @security-team @backend-team

# DevOps team must review infrastructure
/infrastructure/       @devops-team
/.github/workflows/    @devops-team

# Database schema changes require DBA review
prisma/schema.prisma   @dba-team @backend-team
```

When you create a PR that modifies a file, the CODEOWNERS for that file are automatically requested as reviewers. Their approval is required before merging.

---

## 9. Enterprise Tooling Patterns

### Jira / Linear (Project Management)

Ticket lifecycle:
```
Backlog → To Do → In Progress → Code Review → QA → Done
```

Ticket conventions:
```
[PROJ-123] Add user dashboard analytics

**Description**: As a user, I want to see my usage analytics...
**Acceptance Criteria**:
- [ ] Dashboard shows daily/weekly/monthly views
- [ ] Charts load within 2 seconds
- [ ] Empty state for new users
**Story Points**: 5
**Labels**: feature, frontend, backend
```

### Confluence / Notion (Documentation)

Common pages:
- Architecture Decision Records (ADRs)
- Runbooks (how to handle incidents)
- Onboarding guides
- API documentation
- Meeting notes (architecture reviews, RFCs)

### Slack (Communication)

Channel conventions:
```
#team-backend         — Backend team discussions
#team-frontend        — Frontend team discussions
#incidents            — Active incident coordination
#deployments          — Deployment announcements
#code-review          — PR review requests
#random               — Non-work chat
```

**Thread your messages.** Don't have full conversations in the main channel — use threads. This keeps channels scannable.

---

## 10. Meeting Culture

### Common Meetings

| Meeting | Cadence | Duration | Purpose |
|---------|---------|----------|---------|
| **Daily Standup** | Daily | 15 min | Yesterday/today/blockers |
| **Sprint Planning** | Every 2 weeks | 1-2 hours | Decide what to build this sprint |
| **Sprint Retro** | Every 2 weeks | 1 hour | What went well, what didn't, action items |
| **1:1 with Manager** | Weekly | 30 min | Career growth, feedback, concerns |
| **Architecture Review** | As needed | 1 hour | Review designs before building |
| **RFC Review** | As needed | 30-60 min | Discuss technical proposals |
| **Demo / Sprint Review** | Every 2 weeks | 30 min | Show what was built to stakeholders |

### Meeting Tips for New Developers

1. **Come prepared.** Read the agenda. Have your standup update ready.
2. **Take notes.** Write down action items assigned to you.
3. **Ask questions.** "I don't understand" is always better than guessing.
4. **Mute when not speaking.** Background noise is distracting.
5. **Camera on when possible.** Builds connection with remote teams.
6. **Don't code during meetings.** If you're not paying attention, decline the meeting.

---

## 11. Performance Reviews & Growth

### What to Expect

Most companies have performance reviews every 6-12 months. They evaluate:
- **Impact**: What did you ship? What problems did you solve?
- **Technical growth**: Are you taking on harder problems? Learning new skills?
- **Collaboration**: Do you help others? Communicate well? Participate in reviews?
- **Reliability**: Do you meet commitments? Communicate when blocked?

### Building Your Case

Keep a "brag document" — a running list of everything you accomplish:

```markdown
## Q1 2026

### Features Shipped
- Built user dashboard analytics (3 sprints)
- Implemented cursor-based pagination for all list endpoints
- Added Playwright E2E tests for auth flow (12 tests)

### Improvements
- Reduced dashboard load time from 4s to 1.2s
- Fixed N+1 query in project listing (60% faster)

### Collaboration
- Reviewed 15 PRs
- Mentored new hire on NestJS patterns
- Wrote ADR for state management decision

### Learning
- Completed PostgreSQL performance course
- Learned Kubernetes basics for deployment
```

---

## 12. Knowledge Sharing

### Pair Programming

Two developers, one computer:
- **Driver**: Types the code
- **Navigator**: Reviews each line, thinks ahead, catches mistakes

Rotate every 30 minutes. Both learn. Both understand the code.

**When to pair**:
- Onboarding a new team member (they drive, you navigate)
- Complex or risky code (two brains > one)
- You're stuck (rubber duck debugging with a human)

### Knowledge Sharing Sessions (Brown Bags / Tech Talks)

Many teams have weekly or biweekly sessions where someone presents a topic. As a new developer:
- Attend all of them (free learning)
- Present after 2-3 months (teach what you've learned — teaching solidifies knowledge)

### Documentation as Knowledge Sharing

The best way to share knowledge is to write it down:
- ADRs for decisions
- READMEs for setup
- Runbooks for operations
- Code comments for WHY (not what)

---

## Quick Reference: Your First Month

### Week 1: Orient
- [ ] Get access to all tools (Git, Jira, Slack, CI/CD, staging environment)
- [ ] Read the README and get the app running locally
- [ ] Read the last 10 PRs (learn code style and review expectations)
- [ ] Attend all meetings (even if you don't contribute yet)
- [ ] Set up 1:1 with your manager

### Week 2: Contribute
- [ ] Ship your first PR (small — a bug fix or test)
- [ ] Review someone else's PR (comment with questions to learn)
- [ ] Ask "why" about at least one architectural decision
- [ ] Start your brag document

### Week 3-4: Build
- [ ] Own a small feature end-to-end
- [ ] Write tests for your feature
- [ ] Present in standup with confidence
- [ ] Identify one thing you'd improve (and discuss with tech lead)

---

*Enterprise Development Guide v1.0 | Created: February 13, 2026*
