---
name: Monitoring Handoff
description: Transfer monitoring ownership with alert maps, on-call rotation setup, dashboard inventory, and alert fatigue assessment
---

# Monitoring Handoff Skill

**Purpose**: Transfer monitoring and alerting ownership from the development team to the operations or receiving team. This skill produces an alert ownership map, configures on-call rotations, documents every dashboard and its purpose, reviews alert thresholds against GA SLOs, assesses alert fatigue, and links alerts to corresponding disaster recovery runbooks. Alerts without clear owners get ignored -- this skill ensures every alert has a name next to it.

## TRIGGER COMMANDS

```text
"Transfer monitoring ownership"
"On-call setup"
"Alert ownership handoff"
"Dashboard inventory"
"Using monitoring_handoff skill: transfer monitoring for [project]"
```

## When to Use

- Handing off operations to a new team that will own monitoring and incident response
- After `sla_handoff` has defined SLOs (alert thresholds must match SLO targets)
- Setting up on-call rotations for the first time
- Reviewing monitoring coverage before GA launch

---

## PROCESS

### Step 1: Build the Alert Ownership Map

Every alert must have a named owner (person or team) and a linked runbook.

```markdown
# Alert Ownership Map - [Project Name]
**Last Updated**: YYYY-MM-DD

## Critical Alerts (Page Immediately)

| Alert Name | Condition | Owner | Runbook | Escalation |
|-----------|-----------|-------|---------|-----------|
| API Down | Health check fails for 2 min | On-call engineer | [DR: Backend Down](#) | Engineering Manager at 15 min |
| Database Unreachable | Connection timeout for 1 min | On-call engineer | [DR: Database](#) | DBA at 10 min |
| Error Rate Spike | 5xx rate > 1% for 5 min | On-call engineer | [DR: Performance](#) | Engineering Lead at 30 min |
| SSL Certificate Expiry | < 14 days to expiry | Platform team | [Rotate SSL cert](#) | Engineering Manager at 7 days |
| Disk Usage Critical | > 90% on any volume | Platform team | [Expand storage](#) | Engineering Manager at 95% |

## Warning Alerts (Slack Notification)

| Alert Name | Condition | Owner | Runbook | Review Cadence |
|-----------|-----------|-------|---------|---------------|
| p95 Latency Elevated | > 500ms for 10 min | Backend team | [Performance tuning](#) | Weekly |
| Memory Usage High | > 80% for 30 min | Backend team | [Memory investigation](#) | Weekly |
| Queue Depth Growing | > 1000 messages for 15 min | Backend team | [Queue backlog](#) | Daily |
| Error Budget Burn | > 5% consumed in 1 hour | Engineering Lead | [Error budget policy](#) | Real-time |
| Failed Backup | Daily backup job fails | Platform team | [Backup verification](#) | Daily |
| Slow Query Detected | Query > 5s in production | Backend team | [Query optimization](#) | Weekly |

## Informational Alerts (Dashboard Only)

| Alert Name | Condition | Purpose | Dashboard |
|-----------|-----------|---------|-----------|
| Deploy completed | New version deployed | Audit trail | Deployment dashboard |
| User signup spike | 2x normal signup rate | Growth signal | Product dashboard |
| Feature flag changed | Any flag toggled | Change tracking | Feature flag dashboard |
```

### Step 2: Configure On-Call Rotation

Set up on-call schedules so there is always a named responder for every alert.

**On-Call Configuration**:

```markdown
# On-Call Rotation

## Schedule

| Rotation | Primary | Secondary | Hours | Tool |
|----------|---------|-----------|-------|------|
| Weekday daytime | Rotates weekly | Previous week's primary | Mon-Fri 9AM-6PM | PagerDuty |
| Weekday nights | Rotates weekly | Engineering Manager | Mon-Fri 6PM-9AM | PagerDuty |
| Weekends | Rotates weekly | Engineering Manager | Sat-Sun all day | PagerDuty |

## Rotation Members

| Name | Role | Phone | Timezone | Availability Notes |
|------|------|-------|----------|-------------------|
| [Name A] | Backend Engineer | +1-xxx-xxx | US Eastern | No weekends in March |
| [Name B] | Backend Engineer | +1-xxx-xxx | US Pacific | |
| [Name C] | Platform Engineer | +44-xxx-xxx | UK | Covers EU hours |

## On-Call Expectations

1. **Acknowledge** alerts within 5 minutes
2. **Assess** severity within 15 minutes
3. **Escalate** if unable to resolve within 30 minutes
4. **Communicate** status updates every 30 minutes during active incidents
5. **Document** incident in post-incident review within 48 hours

## On-Call Compensation
- [Define per your organization: comp time, on-call stipend, or similar]

## Handoff Procedure (Weekly)
- Outgoing on-call writes a brief summary of the week (incidents, ongoing issues)
- Incoming on-call reviews summary and active monitoring state
- Handoff happens at [time] on [day] via a 15-minute sync call
```

**PagerDuty/OpsGenie Setup Checklist**:

```text
- [ ] Service created for each monitored component
- [ ] Escalation policies configured (primary -> secondary -> manager)
- [ ] On-call schedules created with rotation
- [ ] Integration configured with monitoring tools (Datadog, Sentry, UptimeRobot)
- [ ] Notification rules set per engineer (push, SMS, phone call progression)
- [ ] Acknowledgement timeout set to 5 minutes
- [ ] Auto-escalation after 15 minutes of no acknowledgement
```

### Step 3: Create Dashboard Inventory

Document every dashboard, its purpose, and who uses it.

```markdown
# Dashboard Inventory

| # | Dashboard Name | Tool | Purpose | Primary Audience | URL |
|---|---------------|------|---------|-----------------|-----|
| 1 | System Overview | Grafana | Real-time health of all services | On-call engineer | [link] |
| 2 | API Performance | Datadog | Request latency, throughput, error rates | Backend team | [link] |
| 3 | Database Metrics | Grafana | Query performance, connections, replication lag | DBA / Backend | [link] |
| 4 | Error Tracking | Sentry | Unresolved errors, error trends | All engineers | [link] |
| 5 | Uptime Monitor | UptimeRobot | External availability from multiple regions | On-call + Status page | [link] |
| 6 | Product Analytics | PostHog | User behavior, feature adoption, funnels | Product team | [link] |
| 7 | Billing Dashboard | Stripe | Revenue, subscriptions, failed payments | Finance + Product | [link] |
| 8 | Deployment History | GitHub Actions | Build status, deploy frequency, rollbacks | Engineering team | [link] |
| 9 | SLO Tracker | Grafana | Error budget consumption per SLO | Engineering Lead | [link] |
| 10 | Support Metrics | Zendesk/Intercom | Ticket volume, response times, CSAT | Support Lead | [link] |

## Dashboard Access

| Dashboard | Access Level | How to Get Access |
|-----------|-------------|------------------|
| System Overview | All engineers | SSO auto-provisioned |
| Billing Dashboard | Finance + Engineering Lead | Request via IT |
| Product Analytics | Product + Engineering | SSO auto-provisioned |
```

### Step 4: Conduct Alert Fatigue Assessment

Too many alerts causes "alert fatigue" where responders start ignoring all alerts.

**Assessment Criteria**:

| Metric | Healthy | Unhealthy | Action |
|--------|---------|-----------|--------|
| Alerts per on-call shift | < 5 actionable | > 20 | Tune thresholds or consolidate |
| Alert acknowledgement rate | > 95% | < 80% | Investigate ignored alerts |
| False positive rate | < 10% | > 30% | Increase alert thresholds |
| Alerts requiring no action | < 20% | > 50% | Convert to informational or remove |
| Duplicate/redundant alerts | 0 | > 3 per incident | Deduplicate alert rules |

**Alert Hygiene Review Process**:

```text
Monthly alert review (30 minutes):
1. Pull all alerts that fired in the past month
2. Categorize each: Actionable / False Positive / Informational / Duplicate
3. For each false positive: tune threshold or add exception
4. For each informational: downgrade to dashboard-only
5. For each duplicate: consolidate into a single alert
6. Track alert count trend month-over-month (should decrease or stabilize)
```

### Step 5: Link Alerts to Runbooks

Every critical and warning alert must link to a specific runbook from the `disaster_recovery` skill.

```markdown
# Alert-to-Runbook Mapping

| Alert | Runbook | First Action | Estimated Resolution |
|-------|---------|-------------|---------------------|
| API Down | DR-001: Backend Service Down | Check hosting dashboard | 30 minutes |
| Database Unreachable | DR-003: Database Failure | Check Supabase status | 1-4 hours |
| Error Rate Spike | DR-008: Performance Degradation | Identify bottleneck | 30 min - 1 week |
| Payment Webhook Failure | DR-005: Payment Issues | Check Stripe dashboard | 1 hour |
| Auth Service Down | DR-004: Auth Provider Down | Check provider status | Varies |
| Memory Usage Critical | DR-008: Performance Degradation | Restart service, investigate | 30 minutes |
| SSL Cert Expiring | MAINT-001: Certificate Rotation | Renew via Cloudflare | 15 minutes |

Runbooks stored at: [location, e.g., /docs/runbooks/ or Notion/Confluence URL]
```

---

## CHECKLIST

- [ ] Alert ownership map complete: every alert has a named owner
- [ ] Every critical alert links to a specific disaster recovery runbook
- [ ] On-call rotation configured in PagerDuty/OpsGenie with escalation policies
- [ ] On-call handoff procedure documented (weekly sync, summary notes)
- [ ] Dashboard inventory documents every dashboard with purpose and audience
- [ ] Dashboard access provisioned for the receiving team
- [ ] Alert fatigue assessment conducted (false positive rate < 10%)
- [ ] Alert thresholds aligned with SLO targets from `sla_handoff`
- [ ] Monthly alert review process established
- [ ] On-call compensation and expectations documented
- [ ] Receiving team has completed a shadow on-call shift before full handoff

---

*Skill Version: 1.0 | Created: February 2026*


## Related Skills
- [`observability_handoff`](../observability_handoff/SKILL.md)
