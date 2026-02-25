---
name: Beta SLA Definition
description: Define and communicate beta service level commitments including uptime targets, data durability, and support response times
---

# Beta SLA Definition Skill

**Purpose**: Set and communicate realistic service level expectations for beta testers. Beta is not production, but your testers still need to know what to expect regarding uptime, data safety, response times, and planned maintenance. Clear SLA communication prevents frustration and sets the right expectations for a pre-GA product.

## TRIGGER COMMANDS

```text
"Define beta SLA"
"Beta uptime commitment"
"What do we promise beta users"
"Beta service levels"
"Using beta_sla_definition skill: define SLA for [project]"
```

## When to Use

- Launching a beta program and need to set tester expectations
- Enterprise trial users are asking about reliability commitments
- Planning maintenance windows and need a communication framework
- Preparing inputs for `beta_graduation_criteria` and GA `sla_handoff`

---

## PROCESS

### Step 1: Define Beta SLOs (Internal Targets)

SLOs are internal engineering targets. They are aspirational and not communicated to users.

| Service Level Objective | Target | Measurement |
|------------------------|--------|-------------|
| **Availability** | 99.5% monthly (3.6h downtime/month allowed) | Uptime monitoring (Pingdom, UptimeRobot) |
| **API Response Time** | p95 < 500ms | APM (Datadog, New Relic, or k6 baseline) |
| **Data Durability** | Zero data loss for committed writes | Database backup verification |
| **Deployment Frequency** | 2-5 deploys/week | CI/CD pipeline metrics |
| **Incident Response** | Acknowledge SEV1 within 30 minutes | On-call rotation tracking |
| **Bug Fix SLA** | P0: 24h fix, P1: 72h fix, P2: 2 weeks | Issue tracker metrics |

### Step 2: Define Beta SLA (External Commitments)

SLAs are commitments to beta testers. Set them conservatively -- below your SLO targets.

**Beta SLA Document Template**:

```markdown
# [Product Name] Beta Service Level Agreement

**Effective Date**: YYYY-MM-DD
**Applies To**: All users in the beta program
**Version**: 1.0

## What This Beta SLA Covers

This document describes the service levels you can expect during the
beta period. Beta is a pre-release phase -- some instability is expected.

## Uptime Commitment

- **Target**: 99% monthly availability (7.3 hours downtime/month allowed)
- **Measurement**: Checked every 60 seconds from external monitoring
- **Excludes**: Scheduled maintenance windows (see below)

Note: This is lower than our GA target. We prioritize shipping
improvements during beta, which occasionally requires downtime.

## Data Commitments

- **Your data is real**: We treat beta data as production data
- **Daily backups**: Automated daily backups with 7-day retention
- **No surprise resets**: We will NEVER wipe beta data without 14 days notice
- **Migration to GA**: Your beta data carries over to GA -- no re-entry required

## Response Times

| Channel | Response Time | Hours |
|---------|--------------|-------|
| In-app feedback | 24 hours | Business days |
| Email support | 48 hours | Business days |
| Critical issues (data loss, security) | 4 hours | 24/7 |

## Planned Maintenance

- **Window**: Tuesdays 2:00-4:00 AM UTC
- **Notice**: 24 hours minimum for scheduled maintenance
- **Duration**: Typically 15-30 minutes
- **Frequency**: Weekly or as needed

## What Beta Does NOT Guarantee

- 100% feature parity with GA (some features are in progress)
- Response times under load equal to GA targets
- Availability during infrastructure migrations
- Third-party service uptime (Stripe, email providers, etc.)

## Incident Communication

During outages, we will:
1. Post updates to our status page within 15 minutes
2. Send email notification for outages exceeding 1 hour
3. Provide a post-incident summary within 48 hours

## Feedback and Escalation

- **General feedback**: [feedback channel/email]
- **Urgent issues**: [urgent contact method]
- **Status page**: [status page URL]
```

### Step 3: Establish Monitoring for SLO Tracking

You cannot meet SLAs you do not measure. Set up monitoring aligned with your SLOs.

| SLO | Monitoring Tool | Alert Threshold | Alert Channel |
|-----|----------------|-----------------|---------------|
| Availability 99.5% | UptimeRobot / Pingdom | Any downtime > 1 min | PagerDuty + Slack |
| p95 latency < 500ms | APM / custom metrics | p95 > 500ms for 5 min | Slack #alerts |
| Error rate < 0.1% | Sentry / error tracking | Error rate > 0.5% for 5 min | PagerDuty |
| Backup success | Cron health check | Missed backup | Email + Slack |

**Error Budget Tracking**:

```text
Monthly error budget = (1 - SLO) * total minutes in month

Example for 99.5% availability:
  Budget = 0.5% * 43,200 minutes = 216 minutes of downtime allowed

Week 1: 12 min downtime (204 min remaining)
Week 2: 0 min downtime (204 min remaining)
Week 3: 45 min downtime (159 min remaining)
Week 4: 8 min downtime (151 min remaining)

Status: 151 min remaining -- HEALTHY
```

### Step 4: Communicate and Publish

| Action | Channel | When |
|--------|---------|------|
| Publish Beta SLA document | Help center / docs site | Before beta launch |
| Link in beta onboarding email | Email | At beta signup |
| Reference in Terms of Service | Legal page | Before beta launch |
| Share status page URL | Onboarding flow + footer | Permanent |
| Post maintenance schedule | Status page + docs | Weekly |

---

## CHECKLIST

- [ ] Internal SLOs defined with specific numeric targets
- [ ] External Beta SLA document written and reviewed
- [ ] SLA is conservative (below SLO targets, appropriate for beta)
- [ ] Data commitments clearly stated (no surprise resets, migration to GA)
- [ ] Maintenance windows defined and communicated
- [ ] Response time commitments defined per channel
- [ ] Monitoring configured for each SLO metric
- [ ] Error budget tracking established
- [ ] Status page operational and linked from product
- [ ] Beta SLA published in help center and referenced in onboarding
- [ ] SLA metrics feed into `beta_graduation_criteria` scorecard
- [ ] SLA document versioned for future updates

---

*Skill Version: 1.0 | Created: February 2026*
