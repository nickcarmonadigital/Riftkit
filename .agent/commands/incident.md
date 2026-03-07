---
description: Start incident response workflow with severity classification, role assignment, timeline tracking, and guided resolution.
---

# Incident Command

Initiates and guides structured incident response from detection through resolution and postmortem.

## Instructions

### Mode: New Incident (default)

1. **Classify Severity**
   - SEV1: Complete outage, data loss, security breach
   - SEV2: Major feature broken, significant user impact
   - SEV3: Degraded performance, partial feature loss
   - SEV4: Minor issue, workaround available

2. **Initialize Incident Record**
   - Assign incident ID (INC-YYYY-MM-DD-NNN)
   - Record start time, reporter, initial description
   - Set status to INVESTIGATING

3. **Triage and Diagnosis**
   - Check recent deployments (last 24h)
   - Review error logs and metrics for anomalies
   - Identify affected services and dependencies
   - Check for related infrastructure alerts

4. **Guide Resolution**
   - Suggest rollback if recent deploy correlates
   - Identify relevant code paths and owners
   - Propose mitigation steps (immediate) vs. fix steps (permanent)
   - Track actions taken with timestamps

5. **Communication Updates**
   - Generate status update template for stakeholders
   - Include: severity, impact, ETA, current status
   - Recommend communication cadence by severity

6. **Resolution and Close**
   - Confirm service restored
   - Document root cause and fix applied
   - Set status to RESOLVED with resolution time
   - Calculate incident duration

### Mode: Postmortem (`/incident postmortem`)

1. Gather incident timeline from record
2. Identify contributing factors (not blame)
3. Generate postmortem document:
   - Summary, impact, timeline, root cause
   - What went well, what went wrong
   - Action items with owners and due dates
4. Suggest preventive measures and monitoring improvements

## Output

```
INCIDENT: INC-YYYY-MM-DD-NNN
Status:   [INVESTIGATING/IDENTIFIED/MITIGATING/RESOLVED]
Severity: [SEV1/SEV2/SEV3/SEV4]
Duration: [Xh Xm]
Impact:   [description]

Timeline:
  HH:MM  Issue detected
  HH:MM  Investigation started
  HH:MM  Root cause identified
  HH:MM  Fix applied
  HH:MM  Service restored

Root Cause: [summary]
Action Items: [X items]
```

## Arguments

$ARGUMENTS can be:
- `sev1|sev2|sev3|sev4` - Severity level
- `"description"` - Brief incident description
- `postmortem` - Generate postmortem for recent/specified incident
- `status` - Show current active incidents
- `--rollback` - Include rollback as first mitigation step

## Example Usage

```
/incident sev2 "API returning 500s on /checkout"
/incident sev1 "Database connection pool exhausted"
/incident postmortem
/incident status
```

## Mapped Skills

- `incident_response_operations` - Incident lifecycle management
- `disaster_recovery` - Recovery procedures and rollback
- `bug_troubleshoot` - Root cause analysis and debugging

## Related Commands

- `/deploy` - Rollback via redeployment
- `/observe` - Check system health during incident
- `/security-audit` - If incident is security-related
