---
name: Compliance Dashboard
description: Real-time compliance status visualization, control health scoring, evidence freshness tracking, audit readiness scoring, and drift detection
---

# Compliance Dashboard Skill

**Purpose**: Design and implement a compliance dashboard that provides real-time visibility into compliance posture across all regulatory frameworks. This skill covers control health scoring, evidence freshness tracking, audit readiness calculation, regulatory framework coverage matrices, drift detection, and executive reporting -- giving compliance teams and leadership a single pane of glass for compliance status.

## TRIGGER COMMANDS

```text
"Compliance dashboard"
"Compliance status overview"
"Audit readiness score"
"Control health report"
"Evidence freshness check"
"Compliance drift detection"
```

## When to Use
- Building a compliance monitoring dashboard from scratch
- Adding real-time compliance status to existing monitoring infrastructure
- Preparing audit readiness reports for leadership
- Tracking evidence freshness to prevent stale compliance artifacts
- Detecting compliance drift after infrastructure or process changes
- Generating executive compliance summaries for board reporting

### Cross-References
- **compliance_as_code** -- automated compliance checks that feed dashboard data
- **compliance_program** -- the compliance program this dashboard monitors
- **compliance_certification_handoff** -- transferring dashboard ownership

---

## PROCESS

### Step 1: Real-Time Compliance Status Visualization

Design a dashboard with four primary views: summary, framework detail, control detail, and evidence timeline.

**Dashboard architecture:**

```
Data Sources                    Processing              Visualization
-----------                    ----------              -------------
Vanta/Drata API          -->   Compliance    -->   Summary Dashboard
AWS Config               -->   Data Store    -->   Framework Detail
OPA Policy Results       -->   (PostgreSQL   -->   Control Drilldown
Custom Evidence Scripts  -->    or similar)   -->   Evidence Timeline
CI/CD Pipeline Results   -->                  -->   Executive Report
```

**Summary dashboard layout:**

```markdown
+------------------------------------------------------------------+
|  COMPLIANCE DASHBOARD                          Last updated: now  |
+------------------------------------------------------------------+
|                                                                    |
|  Overall Score: 94/100  [====================-]  HEALTHY          |
|                                                                    |
|  +----------------+  +----------------+  +----------------+       |
|  | SOC 2 Type II  |  | ISO 27001     |  | HIPAA          |       |
|  | Score: 96%     |  | Score: 93%    |  | Score: 91%     |       |
|  | Controls: 87   |  | Controls: 114 |  | Controls: 54   |       |
|  | Passing: 84    |  | Passing: 106  |  | Passing: 49    |       |
|  | Failing: 2     |  | Failing: 5    |  | Failing: 3     |       |
|  | Stale: 1       |  | Stale: 3      |  | Stale: 2       |       |
|  +----------------+  +----------------+  +----------------+       |
|                                                                    |
|  ALERTS                          UPCOMING AUDITS                  |
|  ! 3 controls failing            SOC 2: Jun 1 (87 days)          |
|  ! 6 evidence items stale        ISO 27001: Sep 1 (179 days)     |
|  ! 1 vendor cert expiring        PCI DSS: Nov 1 (240 days)       |
+------------------------------------------------------------------+
```

### Step 2: Control Health Scoring (Green/Yellow/Red)

Score each control based on evidence status, test results, and freshness.

**Scoring algorithm:**

```python
def calculate_control_health(control):
    """
    Returns: GREEN (passing), YELLOW (at risk), RED (failing)
    Score: 0-100
    """
    score = 100
    status = "GREEN"

    # Evidence exists?
    if not control.evidence_collected:
        return {"score": 0, "status": "RED", "reason": "No evidence collected"}

    # Evidence freshness
    days_since_collection = (today - control.last_evidence_date).days
    if days_since_collection > control.freshness_requirement_days:
        score -= 40
        status = "RED"
        reason = f"Evidence stale ({days_since_collection} days old)"
    elif days_since_collection > (control.freshness_requirement_days * 0.75):
        score -= 15
        status = "YELLOW"

    # Automated test result
    if control.last_test_result == "FAIL":
        score -= 50
        status = "RED"
    elif control.last_test_result == "WARN":
        score -= 20
        if status != "RED":
            status = "YELLOW"

    # Policy document current?
    if control.policy_last_reviewed_days > 365:
        score -= 10
        if status == "GREEN":
            status = "YELLOW"

    # Owner assigned?
    if not control.owner:
        score -= 10
        if status == "GREEN":
            status = "YELLOW"

    return {"score": max(score, 0), "status": status}
```

**Control health summary table:**

| Status | Criteria | Action Required |
|--------|----------|-----------------|
| GREEN | Evidence current, tests passing, policy reviewed within 12mo | None -- maintain |
| YELLOW | Evidence approaching staleness OR warnings OR policy review overdue | Schedule refresh within 2 weeks |
| RED | Evidence stale OR test failing OR no evidence OR no owner | Immediate remediation required |

**Health score aggregation:**

```python
def framework_health_score(framework_controls):
    """Aggregate control scores to framework level."""
    total = len(framework_controls)
    scores = [calculate_control_health(c)["score"] for c in framework_controls]

    return {
        "score": sum(scores) / total,
        "green": len([s for s in scores if s >= 80]),
        "yellow": len([s for s in scores if 40 <= s < 80]),
        "red": len([s for s in scores if s < 40]),
        "total": total
    }
```

### Step 3: Evidence Freshness Tracking

Track when each piece of evidence was last collected and alert when it becomes stale.

**Evidence freshness requirements by type:**

| Evidence Type | Freshness Requirement | Collection Method |
|--------------|----------------------|-------------------|
| IAM user/role audit | Monthly (30 days) | Automated (AWS CLI) |
| Security group review | Monthly (30 days) | Automated (AWS CLI) |
| Access reviews | Quarterly (90 days) | Semi-automated (report + manual review) |
| Policy documents | Annual (365 days) | Manual review |
| Penetration test | Annual (365 days) | Third-party engagement |
| Vendor SOC 2 reports | Annual (365 days) | Vendor request |
| Encryption config | Monthly (30 days) | Automated (config export) |
| Backup test restore | Quarterly (90 days) | Manual test |
| Incident response drill | Semi-annual (180 days) | Tabletop exercise |
| Employee security training | Annual (365 days) | LMS completion report |

**Freshness alert configuration:**

```yaml
# compliance-freshness-alerts.yml
alerts:
  - name: evidence-stale-warning
    condition: days_since_collection > (freshness_requirement * 0.75)
    severity: warning
    channel: "#compliance-alerts"
    message: "Evidence for control {control_id} is approaching staleness ({days} days old, limit: {limit} days)"

  - name: evidence-stale-critical
    condition: days_since_collection > freshness_requirement
    severity: critical
    channel: "#compliance-alerts"
    message: "STALE: Evidence for control {control_id} has expired ({days} days old, limit: {limit} days)"

  - name: evidence-collection-failed
    condition: last_collection_status == "FAILED"
    severity: critical
    channel: "#compliance-alerts"
    message: "Evidence collection FAILED for control {control_id}: {error_message}"
```

**Freshness tracking script:**

```bash
#!/bin/bash
# check-evidence-freshness.sh -- Run daily via cron
set -euo pipefail

EVIDENCE_DIR="compliance/evidence"
ALERTS=""

check_freshness() {
    local control_id="$1"
    local max_age_days="$2"
    local evidence_path="$3"

    if [ ! -d "$evidence_path" ]; then
        ALERTS+="RED: $control_id -- No evidence directory exists\n"
        return
    fi

    latest_file=$(find "$evidence_path" -type f -printf '%T@\n' | sort -rn | head -1)
    if [ -z "$latest_file" ]; then
        ALERTS+="RED: $control_id -- Evidence directory is empty\n"
        return
    fi

    age_days=$(( ($(date +%s) - ${latest_file%.*}) / 86400 ))
    warning_threshold=$(( max_age_days * 3 / 4 ))

    if [ "$age_days" -gt "$max_age_days" ]; then
        ALERTS+="RED: $control_id -- Evidence is ${age_days} days old (limit: ${max_age_days})\n"
    elif [ "$age_days" -gt "$warning_threshold" ]; then
        ALERTS+="YELLOW: $control_id -- Evidence is ${age_days} days old (warning at ${warning_threshold})\n"
    fi
}

check_freshness "AC-2" 30 "$EVIDENCE_DIR/ac-2"
check_freshness "CC6.1" 30 "$EVIDENCE_DIR/cc6-1"
check_freshness "IR-4" 180 "$EVIDENCE_DIR/ir-4"

if [ -n "$ALERTS" ]; then
    echo -e "$ALERTS"
    # Send to Slack, email, or monitoring system
fi
```

### Step 4: Audit Readiness Score Calculation

Calculate how prepared the organization is for its next audit.

**Readiness score formula:**

```python
def audit_readiness_score(framework, audit_date):
    """
    Score 0-100 representing audit readiness.
    Components:
    - Control health (40% weight)
    - Evidence freshness (30% weight)
    - Policy currency (15% weight)
    - Personnel readiness (15% weight)
    """
    controls = get_framework_controls(framework)
    health = framework_health_score(controls)

    # Control health: % of controls passing
    control_score = (health["green"] / health["total"]) * 100

    # Evidence freshness: % of evidence within freshness window
    fresh_count = sum(1 for c in controls if not is_stale(c))
    freshness_score = (fresh_count / len(controls)) * 100

    # Policy currency: % of policies reviewed within 12 months
    current_policies = sum(1 for p in get_policies(framework) if p.reviewed_within_year)
    total_policies = len(get_policies(framework))
    policy_score = (current_policies / total_policies) * 100 if total_policies > 0 else 100

    # Personnel readiness: all owners assigned, trained, available during audit
    personnel_ready = sum(1 for c in controls if c.owner and c.owner.available_for_audit)
    personnel_score = (personnel_ready / len(controls)) * 100

    readiness = (
        control_score * 0.40 +
        freshness_score * 0.30 +
        policy_score * 0.15 +
        personnel_score * 0.15
    )

    return {
        "overall": round(readiness, 1),
        "control_health": round(control_score, 1),
        "evidence_freshness": round(freshness_score, 1),
        "policy_currency": round(policy_score, 1),
        "personnel_readiness": round(personnel_score, 1),
        "days_to_audit": (audit_date - today).days,
        "recommendation": "READY" if readiness >= 90 else "AT RISK" if readiness >= 70 else "NOT READY"
    }
```

**Readiness score interpretation:**

| Score | Status | Recommended Action |
|-------|--------|-------------------|
| 90-100 | READY | Maintain current posture, minor polish |
| 70-89 | AT RISK | Prioritize gaps, schedule remediation sprints |
| 50-69 | NOT READY | Escalate to leadership, dedicated remediation team |
| 0-49 | CRITICAL | Consider postponing audit, major remediation needed |

### Step 5: Regulatory Framework Coverage Matrix

Show which controls map across multiple frameworks to identify shared coverage.

```markdown
## Control Coverage Matrix

| Control Area | SOC 2 | ISO 27001 | HIPAA | PCI DSS | GDPR | Status |
|-------------|-------|-----------|-------|---------|------|--------|
| Access Control | CC6.1-6.3 | A.9 | 164.312(a) | Req 7-8 | Art 32 | GREEN |
| Encryption | CC6.1,6.7 | A.10 | 164.312(a)(2)(iv) | Req 3-4 | Art 32 | GREEN |
| Logging/Monitoring | CC7.1-7.4 | A.12 | 164.312(b) | Req 10 | Art 30 | YELLOW |
| Incident Response | CC7.3-7.5 | A.16 | 164.308(a)(6) | Req 12.10 | Art 33-34 | GREEN |
| Vendor Management | CC9.2 | A.15 | 164.308(b) | Req 12.8 | Art 28 | GREEN |
| Change Management | CC8.1 | A.12,A.14 | 164.308(a)(8) | Req 6 | -- | RED |
| Data Retention | CC6.5 | A.8 | 164.530(j) | Req 3.1 | Art 5,17 | YELLOW |
| Physical Security | CC6.4 | A.11 | 164.310 | Req 9 | -- | GREEN |
| Training | CC1.4 | A.7 | 164.308(a)(5) | Req 12.6 | Art 39 | GREEN |
| Business Continuity | CC9.1 | A.17 | 164.308(a)(7) | -- | -- | GREEN |
```

### Step 6: Drift Detection and Remediation Tracking

Detect when compliant configurations drift out of compliance.

**Drift detection sources:**

```yaml
# compliance-drift-config.yml
drift_checks:
  - name: iam-mfa-enforcement
    source: aws_config
    rule: iam-user-mfa-enabled
    frequency: continuous
    remediation: Enable MFA for flagged users within 24 hours

  - name: encryption-at-rest
    source: aws_config
    rule: rds-storage-encrypted
    frequency: continuous
    remediation: Cannot retroactively encrypt -- create encrypted snapshot and restore

  - name: public-s3-buckets
    source: aws_config
    rule: s3-bucket-public-read-prohibited
    frequency: continuous
    auto_remediate: true

  - name: security-group-ssh
    source: aws_config
    rule: restricted-ssh
    frequency: continuous
    auto_remediate: true

  - name: k8s-pod-security
    source: opa_gatekeeper
    rule: restricted-pod-security-standard
    frequency: on_admission
    remediation: Reject non-compliant pod specs at admission
```

**Drift remediation tracker:**

| Drift ID | Detected | Control | Description | Severity | Owner | Status | Remediated |
|----------|----------|---------|-------------|----------|-------|--------|------------|
| D-2026-042 | Mar 1 | AC-2 | Service account without MFA | High | @bob | In Progress | -- |
| D-2026-041 | Feb 28 | CC6.1 | S3 bucket public read | Critical | @dave | Resolved | Mar 1 |
| D-2026-040 | Feb 25 | CC8.1 | Unreviewed change to prod | Medium | @carol | Open | -- |

### Step 7: Executive Summary Report Generation

**Monthly/quarterly executive report template:**

```markdown
## Compliance Executive Summary
**Period**: [Month/Quarter Year]
**Prepared by**: [Compliance Lead]
**Distribution**: [Leadership team]

### Overall Compliance Posture
- **Score**: 94/100 (up from 91 last period)
- **Status**: HEALTHY
- **Trend**: Improving

### Framework Status
| Framework | Score | Change | Next Audit | Readiness |
|-----------|-------|--------|------------|-----------|
| SOC 2 Type II | 96% | +2% | Jun 1, 2026 | READY |
| ISO 27001 | 93% | +3% | Sep 1, 2026 | AT RISK |
| HIPAA | 91% | +1% | N/A | READY |

### Key Metrics
- Controls passing: 239/255 (94%)
- Evidence items current: 198/212 (93%)
- Policies reviewed within 12mo: 18/20 (90%)
- Open drift items: 3 (1 critical, 1 high, 1 medium)
- Mean time to remediate drift: 4.2 days

### Top Risks
1. ISO 27001 A.12 (Logging) -- 3 controls YELLOW, logging gaps in new microservices
2. Vendor SOC 2 report pending for [vendor name] -- cert expires in 30 days
3. PCI DSS v4.0 transition -- 5 new controls not yet implemented

### Actions Taken This Period
- Remediated 12 drift items (avg 3.8 days to resolution)
- Completed annual access review for all production systems
- Onboarded 2 new vendors with full compliance review
- Updated incident response policy to reflect new escalation path

### Planned Next Period
- Complete ISO 27001 A.12 gap remediation
- Begin PCI DSS v4.0 transition project
- Conduct tabletop incident response exercise
- Renew penetration testing contract
```

---

## OUTPUT: Compliance Dashboard Specification

```markdown
## Compliance Dashboard Specification

### Views
1. **Summary**: Overall score, framework scores, active alerts, upcoming audits
2. **Framework Detail**: Per-framework control list with health status
3. **Control Drilldown**: Individual control evidence, test results, history
4. **Evidence Timeline**: Collection schedule, freshness status, gaps
5. **Drift Tracker**: Active drift items, remediation status, trends
6. **Executive Report**: Auto-generated monthly/quarterly PDF

### Data Sources
- Compliance platform API (Vanta/Drata)
- Cloud provider config rules (AWS Config, Azure Policy, GCP SCC)
- Policy engine results (OPA/Gatekeeper)
- Custom evidence collection scripts
- Audit calendar (manual or integrated)

### Refresh Rates
- Control health scores: Real-time (event-driven from data sources)
- Evidence freshness: Daily check (cron)
- Audit readiness score: Weekly recalculation
- Executive report: Monthly auto-generation
- Drift detection: Continuous (cloud-native) or hourly (custom)

### Alert Thresholds
- Evidence stale warning: 75% of freshness window
- Evidence stale critical: 100% of freshness window
- Control health degradation: Any GREEN -> YELLOW or YELLOW -> RED
- Audit readiness drop: Score falls below 90 within 60 days of audit
- Drift item unresolved: Critical >24h, High >7d, Medium >30d
```

## CHECKLIST

- [ ] Dashboard architecture designed with data sources and refresh rates
- [ ] Control health scoring algorithm implemented (GREEN/YELLOW/RED)
- [ ] Evidence freshness tracking configured with per-control requirements
- [ ] Stale evidence alerts configured (warning at 75%, critical at 100%)
- [ ] Audit readiness score calculation implemented (4 weighted components)
- [ ] Regulatory framework coverage matrix populated
- [ ] Drift detection connected to cloud provider config rules
- [ ] Drift remediation tracker with SLA tracking active
- [ ] Auto-remediation enabled for low-risk drift items (public S3, open SSH)
- [ ] Executive summary report template created
- [ ] Monthly report auto-generation scheduled
- [ ] Dashboard access granted to compliance team and leadership
- [ ] Integration with compliance_as_code output verified
- [ ] Historical trend data retained for quarter-over-quarter comparison

*Skill Version: 1.0 | Created: March 2026*
