---
description: Incident response workflow — structured process from detection through post-mortem for production incidents, with severity-based triage, role assignment, and blameless review.
---

# /incident-response Workflow

> Use when a production incident occurs (alert fires, user reports, monitoring detects anomaly). Follow steps sequentially — do not skip triage or post-mortem.

## When to Use

- [ ] Production alert fired (error rate, latency, availability)
- [ ] User-reported outage or degraded experience
- [ ] Monitoring shows anomalous behavior
- [ ] Security incident detected

---

## Step 1: Detect

Confirm the incident is real and gather initial signals.

```bash
view_file .agent/skills/5.5-alpha/error_tracking/SKILL.md
view_file .agent/skills/5.5-alpha/health_checks/SKILL.md
```

- [ ] Alert source identified (monitoring, user report, error tracker)
- [ ] Impact scope estimated (number of users, affected services)
- [ ] Incident timeline started (when did it begin?)
- [ ] Health check endpoints verified

---

## Step 2: Triage — Severity Classification

Classify severity to determine response urgency.

```bash
view_file .agent/skills/7-maintenance/incident_response_operations/SKILL.md
```

| Severity | Criteria | Response Time |
|----------|----------|---------------|
| SEV1 | Full outage, data loss, security breach | Immediate, all hands |
| SEV2 | Major feature broken, significant user impact | < 30 minutes |
| SEV3 | Minor feature degraded, workaround exists | < 4 hours |
| SEV4 | Cosmetic issue, minimal impact | Next business day |

- [ ] Severity assigned (SEV1-4)
- [ ] Response timeline set based on severity

---

## Step 3: Assemble — Role Assignment

Assign incident roles. One person per role minimum.

- [ ] **Incident Commander (IC)**: owns decisions, coordinates response
- [ ] **Tech Lead**: drives root cause analysis and fix
- [ ] **Comms Lead**: handles stakeholder and user communication

**Gate**: Do NOT proceed to mitigation without an IC assigned.

---

## Step 4: Mitigate — Root Cause and Rollback

Find the root cause and stop the bleeding.

```bash
view_file .agent/skills/3-build/bug_troubleshoot/SKILL.md
view_file .agent/skills/5-ship/deployment_patterns/SKILL.md
```

- [ ] Recent deployments checked (last 24h)
- [ ] Logs reviewed for error patterns
- [ ] Root cause hypothesis formed
- [ ] Decision: rollback vs. forward-fix
- [ ] If rollback: execute deployment rollback procedure
- [ ] If forward-fix: minimal patch prepared

**Rollback Procedure**: If mitigation fails within 15 minutes for SEV1/SEV2, escalate and rollback immediately.

---

## Step 5: Communicate

Keep stakeholders informed throughout.

```bash
view_file .agent/skills/3-build/stakeholder_communication/SKILL.md
view_file .agent/skills/5.5-alpha/alpha_incident_communication/SKILL.md
```

- [ ] Internal status update posted (team channel)
- [ ] External status page updated (if applicable)
- [ ] Affected users notified with ETA
- [ ] Updates sent every 30 minutes until resolved (SEV1/SEV2)

---

## Step 6: Resolve — Fix and Verify

Apply the permanent fix with proper testing.

```bash
view_file .agent/skills/3-build/code_review/SKILL.md
view_file .agent/skills/4-secure/tdd_workflow/SKILL.md
```

- [ ] Root cause confirmed (not just symptoms)
- [ ] Code fix implemented (minimal, targeted)
- [ ] Regression test written covering the failure mode
- [ ] Code review completed (expedited for SEV1/SEV2)

---

## Step 7: Deploy Fix

Deploy with verification at each stage.

```bash
view_file .agent/skills/5-ship/ci_cd_pipeline/SKILL.md
view_file .agent/skills/5-ship/deployment_verification/SKILL.md
```

- [ ] Fix deployed to staging, smoke tested
- [ ] Fix deployed to production
- [ ] Monitoring confirms error rate back to baseline
- [ ] Health checks all passing

---

## Step 8: Post-Mortem — Blameless Review

Conduct within 48 hours of resolution.

```bash
view_file .agent/skills/7-maintenance/incident_response_operations/SKILL.md
```

- [ ] Timeline documented (detect -> triage -> mitigate -> resolve)
- [ ] Root cause analysis written (5 Whys or Fishbone)
- [ ] Contributing factors identified (not just the trigger)
- [ ] Blameless review meeting held
- [ ] Action items assigned with owners and due dates

---

## Step 9: Follow-Up

Track action items to completion.

```bash
view_file .agent/skills/7-maintenance/ssot_update/SKILL.md
```

- [ ] Action items entered into tracking system
- [ ] Monitoring gaps addressed (new alerts added)
- [ ] Runbooks updated with lessons learned
- [ ] SSoT updated with architectural changes
- [ ] Follow-up review scheduled (2 weeks)

---

## Exit Checklist — Incident Closed

- [ ] Service fully restored and stable for 24+ hours
- [ ] Post-mortem document completed and shared
- [ ] All action items have owners and due dates
- [ ] Monitoring improved to catch this class of issue
- [ ] Regression test prevents recurrence
- [ ] Stakeholders notified of resolution

*Workflow Version: 1.0 | Created: March 2026*
