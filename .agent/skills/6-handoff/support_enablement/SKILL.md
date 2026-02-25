---
name: Support Enablement
description: Onboard support teams with diagnostic decision trees, escalation matrices, known issue trackers, and knowledge base seed content
---

# Support Enablement Skill

**Purpose**: Bridge the gap between development documentation and support operations by creating the artifacts support teams need to diagnose, triage, and resolve user issues independently. This skill produces diagnostic decision trees, escalation matrices, known issue trackers, and knowledge base seed content so support agents can handle 80% of tickets without engineering escalation.

## TRIGGER COMMANDS

```text
"Create support playbook"
"Onboard support team"
"Build knowledge base"
"Set up support operations"
"Using support_enablement skill: enable support for [project]"
```

## When to Use

- Transitioning from "developers handle support" to a dedicated support function
- Onboarding a support team or outsourced support provider for the first time
- Support ticket volume is growing and response quality is inconsistent
- Preparing for GA launch when support load will increase significantly

---

## PROCESS

### Step 1: Build Diagnostic Decision Trees

Convert common symptoms into step-by-step diagnostic flows that any support agent can follow.

**Decision Tree Template**:

```text
SYMPTOM: User reports "I can't log in"
|
+-- Can the user reach the login page?
|   |
|   +-- NO: Check status page. Is the frontend down?
|   |       +-- YES: Escalate to Engineering (SEV1)
|   |       +-- NO: Ask user to clear cache and try incognito
|   |
|   +-- YES: What error message appears?
|       |
|       +-- "Invalid credentials"
|       |   +-- Has the user tried password reset?
|       |       +-- NO: Guide through password reset flow
|       |       +-- YES, reset email not received:
|       |           Check email service status, check spam folder
|       |
|       +-- "Account locked"
|       |   +-- Check admin panel for lockout status
|       |   +-- Unlock if legitimate user (verify identity first)
|       |
|       +-- "Something went wrong" (500 error)
|       |   +-- Check Sentry for recent errors matching timestamp
|       |   +-- Escalate to Engineering (SEV2) with error ID
|       |
|       +-- No error, page just spins
|           +-- Check browser console for errors
|           +-- Try different browser
|           +-- Check if user's company firewall blocks the domain
```

**Create decision trees for the top 10 support scenarios**:

| # | Symptom | Expected Resolution Rate |
|---|---------|------------------------|
| 1 | Cannot log in | 90% self-serve with decision tree |
| 2 | Feature not working as expected | 70% with known issues list |
| 3 | Data appears missing or incorrect | 60% with data troubleshooting guide |
| 4 | Performance complaints (slow/timeout) | 50% with status check + workaround |
| 5 | Billing/payment issues | 80% with Stripe dashboard access |
| 6 | Permission/access denied errors | 85% with role verification steps |
| 7 | Integration not syncing | 60% with integration troubleshooting |
| 8 | Email notifications not arriving | 75% with email delivery checklist |
| 9 | Export/import failures | 70% with format/size validation |
| 10 | Account deletion/data requests | 95% with GDPR/privacy procedures |

### Step 2: Define the Escalation Matrix

Clearly define when and how support agents escalate to engineering.

```markdown
# Escalation Matrix

## Severity Classification (for support agents)

| Severity | User Impact | Examples | Response Target |
|----------|-----------|---------|----------------|
| **SEV1** | Service down for all users | Complete outage, data loss | 15 min response |
| **SEV2** | Service degraded or down for subset | Feature broken, slow performance | 1 hour response |
| **SEV3** | Single user impacted, workaround exists | One account issue, UI bug | 4 hours response |
| **SEV4** | Minor issue, no business impact | Typo, cosmetic, feature request | 1 business day |

## Escalation Paths

| Severity | First Contact | If No Response in... | Escalate To |
|----------|--------------|---------------------|-------------|
| SEV1 | On-call engineer via PagerDuty | 15 minutes | Engineering manager + CTO |
| SEV2 | #support-engineering Slack channel | 1 hour | Engineering team lead |
| SEV3 | Engineering ticket (JIRA/Linear) | 24 hours | Engineering team lead |
| SEV4 | Backlog ticket | 1 week | Product manager |

## What to Include in an Escalation

Every escalation to engineering MUST include:
1. **User identifier** (email, user ID, org ID)
2. **Timestamp** of when the issue occurred
3. **Steps to reproduce** (what did the user do?)
4. **Expected vs actual behavior**
5. **Error messages** (exact text or screenshot)
6. **What you already tried** (from the decision tree)
7. **Severity classification** with justification
```

### Step 3: Seed the Known Issues Tracker

Pre-populate with known issues from beta feedback to prevent redundant investigation.

```markdown
# Known Issues Tracker

| ID | Issue | Status | Workaround | Affected Users | ETA |
|----|-------|--------|-----------|---------------|-----|
| KI-001 | Dashboard slow on 1000+ records | Open | Use filters to reduce result set | ~15% of Pro users | v2.1 |
| KI-002 | PDF export truncates long tables | Open | Export to CSV instead | Low | v2.2 |
| KI-003 | OAuth login fails with Safari 16 | Investigating | Use Chrome or Firefox | ~5% of users | TBD |
| KI-004 | Webhook delivery delayed during peak hours | Monitoring | Events arrive within 5 min | Enterprise users | v2.1 |

## Recently Resolved
| ID | Issue | Resolution | Resolved Date |
|----|-------|-----------|--------------|
| KI-005 | Email notifications delayed by 1h | Fixed email queue worker scaling | 2026-02-20 |
```

### Step 4: Create Support Agent Training Guide

Structure the onboarding for a new support agent joining the team.

```markdown
# Support Agent Onboarding Guide

## Week 1: Product Foundations (shadow experienced agent)
- [ ] Complete product walkthrough (as a user)
- [ ] Read user documentation end-to-end
- [ ] Shadow 10 support tickets with an experienced agent
- [ ] Set up access: admin panel, Sentry, Stripe dashboard, Slack channels
- [ ] Review known issues tracker

## Week 2: Guided Practice (handle tickets with review)
- [ ] Handle 5 SEV4 tickets independently (reviewed before sending)
- [ ] Practice using all diagnostic decision trees
- [ ] Learn escalation procedures (when, how, what to include)
- [ ] Review 5 past escalations to understand engineering handoff

## Week 3: Independent Handling (with backup)
- [ ] Handle SEV3 and SEV4 tickets independently
- [ ] Escalate 2 tickets to engineering (practice the process)
- [ ] Add 1 new entry to the known issues tracker
- [ ] Create 1 new FAQ entry from a repeated question

## Week 4: Full Responsibility
- [ ] Handle all severity levels (SEV1/2 with manager notification)
- [ ] On-call for urgent ticket triage
- [ ] Quality review: 90% customer satisfaction on handled tickets
```

### Step 5: Set Support SLA Targets

Define measurable targets for the support function.

| Metric | Target | Measurement |
|--------|--------|-------------|
| First response time (SEV1) | < 15 minutes | Ticket timestamp to first reply |
| First response time (SEV2-3) | < 4 hours | Business hours only |
| First response time (SEV4) | < 1 business day | Business hours only |
| Resolution time (SEV1) | < 4 hours | Including engineering escalation |
| Resolution time (SEV3-4) | < 3 business days | Support-resolvable tickets |
| Customer satisfaction (CSAT) | > 90% | Post-ticket survey |
| First-contact resolution rate | > 60% | Resolved without escalation |
| Engineering escalation rate | < 20% | Of total tickets |

---

## CHECKLIST

- [ ] Top 10 diagnostic decision trees created for common symptoms
- [ ] Escalation matrix defined with severity levels and response targets
- [ ] Escalation template specifies required information for engineering handoff
- [ ] Known issues tracker seeded with beta-period issues
- [ ] Support agent training guide covers weeks 1-4 onboarding
- [ ] Support agents have access to admin panel, error tracking, and billing dashboard
- [ ] Support SLA targets defined and measurable
- [ ] Knowledge base seed content published (FAQ, how-to articles)
- [ ] Support Slack channel created and engineering responders assigned
- [ ] Feedback loop established: support insights feed back to product team

---

*Skill Version: 1.0 | Created: February 2026*
