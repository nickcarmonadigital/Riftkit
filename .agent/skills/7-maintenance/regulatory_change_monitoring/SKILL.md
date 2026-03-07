---
name: Regulatory Change Monitoring
description: Regulatory feed monitoring, change impact assessment, compliance gap analysis, implementation tracking, and policy version control
---

# Regulatory Change Monitoring Skill

**Purpose**: Establish a systematic process for monitoring regulatory changes, assessing their impact on the organization, identifying compliance gaps, tracking implementation of new requirements, and maintaining version-controlled compliance policies. This skill ensures the organization is never surprised by a regulatory change and can proactively adapt its compliance posture before enforcement deadlines.

## TRIGGER COMMANDS

```text
"Regulatory change monitoring"
"New regulation impact"
"Compliance gap analysis"
"Regulation tracking"
"Policy version control"
"Annual compliance review"
```

## When to Use
- Setting up regulatory change monitoring for the first time
- A new regulation or amendment has been published that may affect the organization
- Conducting periodic compliance gap analysis after regulatory changes
- Tracking implementation timelines for upcoming regulatory requirements
- Establishing version control and review cadence for compliance policies
- Preparing for annual compliance program review

### Cross-References
- **compliance_program** -- the overall compliance program these changes feed into
- **regulated_industry_context** -- industry-specific regulatory requirements
- **compliance_dashboard** -- visualizing regulatory change impact

---

## PROCESS

### Step 1: Regulatory Feed Monitoring

Set up monitoring for regulatory changes across all relevant jurisdictions and frameworks.

**Primary monitoring sources:**

| Source | URL | Scope | Monitor Method | Frequency |
|--------|-----|-------|---------------|-----------|
| Federal Register | federalregister.gov | US federal regulations | RSS + API | Daily |
| EU Official Journal | eur-lex.europa.eu | EU regulations (GDPR, AI Act, DORA) | RSS | Weekly |
| ICO (UK) | ico.org.uk/about-the-ico | UK data protection guidance | RSS | Weekly |
| HHS/OCR | hhs.gov/hipaa | HIPAA guidance and enforcement | Email subscription | Weekly |
| PCI SSC | blog.pcisecuritystandards.org | PCI DSS updates | RSS | Monthly |
| NIST | csrc.nist.gov | Security frameworks (CSF, SP 800-*) | RSS | Monthly |
| State legislatures | legiscan.com | US state privacy laws | API (LegiScan) | Weekly |
| SEC | sec.gov/rules | Financial regulations | RSS | Weekly |
| FTC | ftc.gov/enforcement | Consumer protection, data practices | RSS | Weekly |
| CISA | cisa.gov/news-events | Cybersecurity advisories and directives | RSS + email | Daily |

**Automated feed aggregation:**

```python
#!/usr/bin/env python3
"""regulatory_feed_monitor.py -- Aggregate regulatory changes from RSS feeds."""

import feedparser
import json
from datetime import datetime, timedelta
from pathlib import Path

FEEDS = {
    "federal_register_privacy": "https://www.federalregister.gov/api/v1/documents.rss?conditions%5Btopics%5D%5B%5D=privacy",
    "nist_publications": "https://csrc.nist.gov/publications/rss",
    "pci_ssc_blog": "https://blog.pcisecuritystandards.org/rss.xml",
    "ico_uk": "https://ico.org.uk/about-the-ico/media-centre/news-and-blogs/rss/",
    "cisa_alerts": "https://www.cisa.gov/cybersecurity-advisories/all.xml",
}

KEYWORDS = [
    "privacy", "data protection", "cybersecurity", "breach notification",
    "encryption", "access control", "audit", "compliance", "HIPAA",
    "GDPR", "PCI", "SOC", "ISO 27001", "AI regulation", "incident response",
]

def check_feeds(lookback_days=7):
    cutoff = datetime.now() - timedelta(days=lookback_days)
    changes = []

    for name, url in FEEDS.items():
        feed = feedparser.parse(url)
        for entry in feed.entries:
            published = datetime(*entry.published_parsed[:6])
            if published < cutoff:
                continue

            title_lower = entry.title.lower()
            summary_lower = getattr(entry, "summary", "").lower()
            relevance = [kw for kw in KEYWORDS
                         if kw.lower() in title_lower or kw.lower() in summary_lower]

            if relevance:
                changes.append({
                    "source": name,
                    "title": entry.title,
                    "url": entry.link,
                    "published": published.isoformat(),
                    "keywords_matched": relevance,
                })

    return changes

if __name__ == "__main__":
    changes = check_feeds()
    output_path = Path("compliance/regulatory-changes-latest.json")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(changes, indent=2))
    print(f"Found {len(changes)} relevant regulatory changes")
```

**Cron schedule:**

```bash
# Run daily at 7 AM
0 7 * * * cd /app && python3 compliance/scripts/regulatory_feed_monitor.py

# Weekly summary email (Fridays at 4 PM)
0 16 * * 5 cd /app && python3 compliance/scripts/regulatory_weekly_summary.py | mail -s "Weekly Regulatory Changes" compliance-team@company.com
```

### Step 2: Change Impact Assessment Framework

When a regulatory change is identified, assess whether and how it affects the organization.

**Impact assessment decision tree:**

```markdown
## Regulatory Change Impact Assessment

### Question 1: Does this regulation apply to us?
- [ ] Geographic scope: Does it cover our operating jurisdictions?
- [ ] Industry scope: Does it apply to our industry/sector?
- [ ] Data scope: Does it cover the types of data we process?
- [ ] Size scope: Do we meet the threshold (revenue, employees, data volume)?
- [ ] If NO to all: Log as "Not Applicable" and close.

### Question 2: What is the compliance impact?
- [ ] New controls required that we don't have?
- [ ] Existing controls need modification?
- [ ] New reporting/disclosure requirements?
- [ ] Changes to data subject rights?
- [ ] New vendor/third-party requirements?
- [ ] New technical requirements (encryption, access control)?

### Question 3: What is the timeline?
- [ ] Enforcement date identified?
- [ ] Grace period or phased implementation?
- [ ] Early adoption incentives?
- [ ] Retroactive application?

### Question 4: What is the risk of non-compliance?
- [ ] Financial penalties (specify max amount)
- [ ] Operational restrictions (license revocation, business limitations)
- [ ] Reputational impact (public disclosure of violations)
- [ ] Criminal liability (for officers/directors)
```

**Impact classification:**

| Impact Level | Description | Response SLA | Approval Required |
|-------------|-------------|-------------|-------------------|
| Critical | New regulation directly applicable, significant changes required | 7 days assessment | VP + Legal |
| High | Existing regulation amended, moderate changes to controls | 14 days assessment | Compliance Lead + Legal |
| Medium | Guidance updated, minor control adjustments needed | 30 days assessment | Compliance Lead |
| Low | Informational, best practice recommendation | 60 days review | Compliance Analyst |
| None | Not applicable to organization | Log and close | Compliance Analyst |

### Step 3: Compliance Gap Analysis When Regulations Change

Systematically identify gaps between current compliance posture and new requirements.

**Gap analysis template:**

```markdown
## Compliance Gap Analysis
**Regulation**: [Name and citation]
**Published**: [Date]
**Enforcement Date**: [Date]
**Assessor**: [Name]
**Assessment Date**: [Date]

### New Requirements vs. Current State

| Req ID | Requirement | Current State | Gap | Severity | Effort | Owner |
|--------|-------------|---------------|-----|----------|--------|-------|
| R1 | Encrypt all PII at rest with AES-256 | AES-256 in place for DB, not for file storage | Partial | High | 2 weeks | @dave |
| R2 | 72-hour breach notification | Current SLA is 96 hours | Gap | Critical | 1 week | @eve |
| R3 | Annual privacy impact assessment | Not currently performed | Gap | High | 4 weeks | @carol |
| R4 | Data retention max 3 years | Current retention is 5 years | Gap | Medium | 3 weeks | @bob |
| R5 | Right to data portability | Export exists but not machine-readable | Partial | Medium | 2 weeks | @dave |

### Summary
- **Total requirements**: 5
- **Fully compliant**: 0
- **Partially compliant**: 2
- **Gaps**: 3
- **Estimated remediation effort**: 12 weeks
- **Critical gaps requiring immediate action**: 1 (breach notification SLA)
```

**Gap severity matrix:**

| Severity | Impact if Not Addressed | Remediation Timeline |
|----------|------------------------|---------------------|
| Critical | Direct regulatory violation, fines likely | Before enforcement date or within 30 days |
| High | Significant compliance risk, audit finding | Within 60 days |
| Medium | Minor compliance risk, observation | Within 90 days |
| Low | Best practice gap, no regulatory risk | Within 180 days or next annual review |

### Step 4: Implementation Timeline Tracking

Track remediation of compliance gaps through to completion.

**Implementation tracking table:**

```markdown
## Regulatory Change Implementation Tracker

### Regulation: [Name]
### Enforcement Date: [Date]
### Overall Status: IN PROGRESS (3/5 complete)

| Req ID | Task | Owner | Start | Due | Status | Blockers |
|--------|------|-------|-------|-----|--------|----------|
| R1 | Enable file storage encryption | @dave | Mar 1 | Mar 14 | Complete | -- |
| R2 | Update breach notification SLA to 72h | @eve | Mar 1 | Mar 7 | Complete | -- |
| R2 | Update incident response runbook | @eve | Mar 7 | Mar 14 | Complete | -- |
| R3 | Create PIA template and process | @carol | Mar 15 | Apr 12 | In Progress | Legal review pending |
| R4 | Implement data retention policy changes | @bob | Mar 15 | Apr 5 | Not Started | Depends on R3 PIA |
| R5 | Build machine-readable data export | @dave | Apr 1 | Apr 14 | Not Started | -- |

### Milestones
- [x] Gap analysis complete (Mar 1)
- [x] Critical gaps remediated (Mar 14)
- [ ] High gaps remediated (Apr 12)
- [ ] Medium gaps remediated (May 1)
- [ ] Full compliance verified (May 15)
- [ ] Evidence collected for all new controls (May 30)
```

### Step 5: Stakeholder Notification Workflow

```markdown
## Regulatory Change Notification Process

### Notification Tiers

| Impact Level | Notify | Method | Timing |
|-------------|--------|--------|--------|
| Critical | Leadership + Legal + All control owners | Email + Slack + meeting | Within 24 hours |
| High | Compliance Lead + Legal + Affected control owners | Email + Slack | Within 3 business days |
| Medium | Compliance Lead + Affected control owners | Slack | Within 1 week |
| Low | Compliance team | Weekly digest | Next weekly summary |

### Notification Template

Subject: [IMPACT LEVEL] Regulatory Change: [Regulation Name]

Body:
- **What changed**: [Brief description of the regulatory change]
- **Source**: [Link to official publication]
- **Enforcement date**: [Date]
- **Impact assessment**: [Critical/High/Medium/Low]
- **Affected controls**: [List of control IDs]
- **Affected teams**: [List of teams]
- **Required actions**: [Summary of what needs to change]
- **Next steps**: Gap analysis meeting scheduled for [date]
- **Owner**: [Compliance Lead name]
```

### Step 6: Version Control for Compliance Policies

Maintain all compliance policies in version control with formal review and approval workflows.

**Policy repository structure:**

```
compliance/policies/
  access-control/
    access-control-policy.md      # Current version
    CHANGELOG.md                   # Version history
  incident-response/
    incident-response-policy.md
    CHANGELOG.md
  data-protection/
    data-protection-policy.md
    CHANGELOG.md
  vendor-management/
    vendor-management-policy.md
    CHANGELOG.md
  acceptable-use/
    acceptable-use-policy.md
    CHANGELOG.md
  POLICY_INDEX.md                  # Master index of all policies
```

**Policy metadata header:**

```markdown
---
title: Access Control Policy
version: 3.2
effective_date: 2026-03-01
last_reviewed: 2026-02-15
next_review: 2027-02-15
owner: @bob
approver: @vp-engineering
frameworks: [SOC 2, ISO 27001, HIPAA, PCI DSS]
change_reason: Updated for PCI DSS v4.0 MFA requirements
---
```

**Policy change workflow:**

```yaml
# .github/workflows/policy-review.yml
name: Policy Change Review
on:
  pull_request:
    paths: ['compliance/policies/**']

jobs:
  policy-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate policy metadata
        run: |
          for file in $(git diff --name-only HEAD~1 -- compliance/policies/); do
            if [[ "$file" == *.md ]]; then
              # Check required metadata fields
              for field in title version effective_date owner approver; do
                if ! grep -q "^${field}:" "$file"; then
                  echo "ERROR: $file missing required field: $field"
                  exit 1
                fi
              done
            fi
          done

      - name: Require legal review for critical policies
        run: |
          CRITICAL_POLICIES="incident-response data-protection vendor-management"
          CHANGED=$(git diff --name-only HEAD~1 -- compliance/policies/)
          for policy in $CRITICAL_POLICIES; do
            if echo "$CHANGED" | grep -q "$policy"; then
              echo "::warning::Critical policy changed: $policy -- Legal review required"
            fi
          done
```

### Step 7: Annual Compliance Review Cadence

```markdown
## Annual Compliance Review Calendar

| Month | Activity | Owner | Deliverable |
|-------|----------|-------|-------------|
| January | Annual compliance program review kickoff | Compliance Lead | Review plan |
| February | Policy review cycle begins (all policies) | Policy owners | Updated policies |
| March | Vendor compliance review (annual SOC 2 requests) | Vendor Mgmt | Vendor risk report |
| April | Q1 compliance dashboard report | Compliance Lead | Executive summary |
| May | Employee security training refresh | HR + Security | Training completion report |
| June | SOC 2 Type II audit (if applicable) | Compliance Lead | Audit report |
| July | Q2 compliance dashboard report + mid-year review | Compliance Lead | Executive summary |
| August | Penetration test (annual) | Security team | Pentest report |
| September | ISO 27001 surveillance audit (if applicable) | Compliance Lead | Audit report |
| October | Q3 compliance dashboard report | Compliance Lead | Executive summary |
| November | Regulatory landscape review (next year planning) | Compliance Lead | Regulatory outlook |
| December | Annual compliance report + Q4 report | Compliance Lead | Annual summary |

### Quarterly Review Meeting Agenda
1. Compliance dashboard review (scores, trends, drift)
2. Open gap remediation status
3. Upcoming regulatory changes and impact
4. Vendor compliance status updates
5. Incident/breach review (if any)
6. Budget and resource needs
7. Action items for next quarter
```

---

## CHECKLIST

- [ ] Regulatory feed monitoring configured for all relevant sources
- [ ] RSS feeds or API integrations active and delivering daily/weekly updates
- [ ] Keyword filters set for organization-relevant regulatory topics
- [ ] Impact assessment framework documented and understood by compliance team
- [ ] Impact classification matrix (Critical/High/Medium/Low) defined with SLAs
- [ ] Gap analysis template created and available for rapid deployment
- [ ] Implementation tracking process established (Jira, spreadsheet, or similar)
- [ ] Stakeholder notification workflow configured by impact level
- [ ] All compliance policies stored in version control with metadata headers
- [ ] Policy change review workflow enforced via PR process
- [ ] Policy review cadence established (annual minimum for all policies)
- [ ] Annual compliance review calendar published and recurring meetings set
- [ ] Quarterly compliance review meetings scheduled with leadership
- [ ] Regulatory change log maintained with assessment and disposition

*Skill Version: 1.0 | Created: March 2026*
