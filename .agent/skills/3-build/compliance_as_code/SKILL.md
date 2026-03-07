---
name: compliance_as_code
description: Automated compliance verification for SOC2, GDPR, HIPAA, and PCI-DSS using policy-as-code frameworks and CI/CD integration
---

# Compliance as Code Skill

**Purpose**: Define compliance requirements as executable policies, automate verification in CI/CD pipelines, and generate audit evidence programmatically. Replace manual compliance checklists with code that continuously validates your infrastructure and application against regulatory frameworks.

> [!IMPORTANT]
> **Compliance Drift Kills**: A system that passes an annual audit but drifts daily is not compliant. Continuous automated checks are the only reliable approach.

## TRIGGER COMMANDS

```text
"Add compliance checks for [SOC2/GDPR/HIPAA/PCI]"
"Setup policy-as-code for [project]"
"Automate audit evidence generation"
"Implement compliance pipeline"
"Check GDPR compliance for [service]"
"Using compliance_as_code skill: verify [framework] controls"
```

## When to Use

- Building compliance automation into CI/CD pipelines
- Preparing for SOC2, HIPAA, PCI-DSS, or GDPR audits
- Detecting compliance drift in infrastructure or application config
- Generating automated audit evidence and compliance reports
- Adding PII/PHI detection to code review workflows
- Integrating policy enforcement with existing security tools

---

## PART 1: ARCHITECTURE

```
Code Change
    │
    v
┌──────────────────────────────────────────────────┐
│ CI/CD Pipeline                                    │
│                                                   │
│  ┌─────────┐  ┌──────────┐  ┌────────────────┐  │
│  │ Conftest │  │ Snyk/    │  │ Custom Policy  │  │
│  │ (OPA)   │  │ GitGuard │  │ Checks         │  │
│  └────┬────┘  └────┬─────┘  └───────┬────────┘  │
│       │             │                │            │
│       v             v                v            │
│  ┌─────────────────────────────────────────────┐ │
│  │ Compliance Gate: PASS / FAIL / WARN          │ │
│  └──────────────────────┬──────────────────────┘ │
└─────────────────────────┼────────────────────────┘
                          │
                          v
              ┌───────────────────────┐
              │ Audit Evidence Store  │
              │ (S3 / Git / Artifact) │
              └───────────────────────┘
```

### Policy-as-Code Stack

| Tool | Purpose | Input |
|------|---------|-------|
| **OPA/Rego** | General policy engine | JSON/YAML configs, Terraform plans |
| **Conftest** | CLI for OPA against structured data | Dockerfiles, K8s manifests, Terraform |
| **Prowler** | AWS security & compliance scanner | AWS account |
| **ScoutSuite** | Multi-cloud security auditing | AWS/Azure/GCP accounts |
| **Snyk** | Dependency & container vulnerability | Code repos, container images |
| **GitGuardian** | Secret detection in source code | Git repositories |
| **Trivy** | Vulnerability & misconfiguration scanner | Images, filesystems, repos |

---

## PART 2: OPA / REGO POLICY DEFINITIONS

### Basic Policy Structure

```rego
# policy/terraform/encryption.rego
package terraform.encryption

# Deny S3 buckets without encryption
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
    not has_encryption(resource)
    msg := sprintf("S3 bucket '%s' must have server-side encryption enabled", [resource.name])
}

has_encryption(resource) {
    resource.change.after.server_side_encryption_configuration[_]
}

# Deny RDS instances without encryption at rest
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_db_instance"
    resource.change.after.storage_encrypted != true
    msg := sprintf("RDS instance '%s' must have storage encryption enabled", [resource.name])
}

# Deny unencrypted EBS volumes
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_ebs_volume"
    resource.change.after.encrypted != true
    msg := sprintf("EBS volume '%s' must be encrypted", [resource.name])
}
```

### Conftest Usage

```bash
# Validate Terraform plan
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
conftest test tfplan.json --policy policy/terraform/

# Validate Kubernetes manifests
conftest test k8s/deployment.yaml --policy policy/kubernetes/

# Validate Dockerfiles
conftest test Dockerfile --policy policy/docker/
```

### Kubernetes Policies

```rego
# policy/kubernetes/security.rego
package kubernetes.security

# Deny containers running as root
deny[msg] {
    input.kind == "Deployment"
    container := input.spec.template.spec.containers[_]
    not container.securityContext.runAsNonRoot
    msg := sprintf("Container '%s' must set runAsNonRoot: true", [container.name])
}

# Deny containers without resource limits
deny[msg] {
    input.kind == "Deployment"
    container := input.spec.template.spec.containers[_]
    not container.resources.limits.memory
    msg := sprintf("Container '%s' must define memory limits", [container.name])
}

# Deny privileged containers
deny[msg] {
    input.kind == "Deployment"
    container := input.spec.template.spec.containers[_]
    container.securityContext.privileged == true
    msg := sprintf("Container '%s' must not be privileged", [container.name])
}

# Require specific labels
deny[msg] {
    input.kind == "Deployment"
    not input.metadata.labels["app.kubernetes.io/managed-by"]
    msg := "Deployment must have 'app.kubernetes.io/managed-by' label"
}
```

### Dockerfile Policies

```rego
# policy/docker/best_practices.rego
package docker.best_practices

# Deny use of latest tag
deny[msg] {
    input[i].Cmd == "from"
    val := input[i].Value[0]
    endswith(val, ":latest")
    msg := "Do not use ':latest' tag in FROM — pin a specific version"
}

# Deny running as root (no USER instruction)
deny[msg] {
    not has_user_instruction
    msg := "Dockerfile must include a USER instruction to run as non-root"
}

has_user_instruction {
    input[_].Cmd == "user"
}

# Deny ADD when COPY would suffice
warn[msg] {
    input[i].Cmd == "add"
    not is_url(input[i].Value[0])
    not endswith(input[i].Value[0], ".tar")
    msg := "Use COPY instead of ADD unless extracting archives or fetching URLs"
}

is_url(val) { startswith(val, "http://") }
is_url(val) { startswith(val, "https://") }
```

---

## PART 3: SOC2 CONTROL VERIFICATION

### SOC2 Trust Service Criteria Mapping

```yaml
# compliance/soc2-controls.yaml
controls:
  CC6.1-access-control:
    description: "Logical access restricted to authorized users"
    checks:
      - type: opa
        policy: policy/soc2/access_control.rego
      - type: prowler
        checks: [iam_no_root_access_key, iam_password_policy_minimum_length_14]
      - type: custom
        script: scripts/check_mfa_enabled.sh

  CC6.6-encryption-in-transit:
    description: "Data encrypted in transit"
    checks:
      - type: opa
        policy: policy/soc2/encryption_transit.rego
      - type: prowler
        checks: [elb_ssl_policy, cloudfront_https_only]

  CC7.2-monitoring:
    description: "System anomalies detected and reported"
    checks:
      - type: prowler
        checks: [cloudtrail_enabled, guardduty_enabled, config_recorder_enabled]
      - type: custom
        script: scripts/check_alerting_configured.sh

  CC8.1-change-management:
    description: "Changes authorized and tested before deployment"
    checks:
      - type: custom
        script: scripts/check_branch_protection.sh
      - type: custom
        script: scripts/check_pr_reviews_required.sh
```

### Automated Access Control Check

```bash
#!/bin/bash
# scripts/check_branch_protection.sh
# SOC2 CC8.1 — Verify branch protection rules

REPO="$1"
BRANCH="${2:-main}"

protection=$(gh api "repos/${REPO}/branches/${BRANCH}/protection" 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "FAIL: Branch protection not enabled on ${BRANCH}"
    exit 1
fi

# Check required reviews
reviews=$(echo "$protection" | jq '.required_pull_request_reviews.required_approving_review_count // 0')
if [ "$reviews" -lt 1 ]; then
    echo "FAIL: At least 1 review required, found ${reviews}"
    exit 1
fi

# Check status checks
status_checks=$(echo "$protection" | jq '.required_status_checks.strict // false')
if [ "$status_checks" != "true" ]; then
    echo "WARN: Strict status checks not enabled"
fi

# Check force push disabled
force_push=$(echo "$protection" | jq '.allow_force_pushes.enabled // false')
if [ "$force_push" == "true" ]; then
    echo "FAIL: Force push must be disabled on ${BRANCH}"
    exit 1
fi

echo "PASS: Branch protection properly configured"
```

---

## PART 4: GDPR COMPLIANCE CHECKS

### PII Detection in Code

```rego
# policy/gdpr/pii_detection.rego
package gdpr.pii

import future.keywords.in

# Flag database columns that likely contain PII without encryption annotation
warn[msg] {
    model := input.models[_]
    field := model.fields[_]
    is_pii_field(field.name)
    not field.annotations["@encrypted"]
    msg := sprintf("Model '%s' field '%s' likely contains PII — add encryption or document exemption",
        [model.name, field.name])
}

is_pii_field(name) { name in ["email", "phone", "ssn", "dateOfBirth", "address",
    "firstName", "lastName", "fullName", "phoneNumber", "socialSecurity",
    "passport", "driverLicense", "creditCard", "ipAddress"] }

# Flag logging of PII fields
deny[msg] {
    log_statement := input.log_statements[_]
    field := log_statement.fields[_]
    is_pii_field(field)
    msg := sprintf("Logging PII field '%s' at %s:%d — must redact or remove",
        [field, log_statement.file, log_statement.line])
}
```

### Data Retention Policy Check

```python
# scripts/check_data_retention.py
"""GDPR Article 5(1)(e) — Storage limitation check."""
import json
import sys
from datetime import datetime, timedelta

def check_retention_policies(schema_path: str):
    """Verify all PII-containing tables have retention policies defined."""
    with open(schema_path) as f:
        schema = json.load(f)

    pii_tables = []
    missing_retention = []

    for table in schema["tables"]:
        pii_fields = [f for f in table["fields"] if f.get("pii", False)]
        if pii_fields:
            pii_tables.append(table["name"])
            if not table.get("retention_policy"):
                missing_retention.append({
                    "table": table["name"],
                    "pii_fields": [f["name"] for f in pii_fields],
                })

    if missing_retention:
        print(f"FAIL: {len(missing_retention)} PII tables without retention policy:")
        for item in missing_retention:
            print(f"  - {item['table']}: {', '.join(item['pii_fields'])}")
        sys.exit(1)

    print(f"PASS: All {len(pii_tables)} PII tables have retention policies")

if __name__ == "__main__":
    check_retention_policies(sys.argv[1])
```

### Consent Verification Check

```python
# scripts/check_consent_tracking.py
"""GDPR Article 7 — Verify consent is tracked for data processing."""

REQUIRED_CONSENT_FIELDS = [
    "consent_given",        # Boolean: user gave consent
    "consent_timestamp",    # When consent was given
    "consent_version",      # Which privacy policy version
    "consent_method",       # How consent was collected (checkbox, banner, etc.)
    "consent_withdrawable", # User can withdraw consent
]

def check_consent_model(schema):
    """Verify consent tracking model exists with required fields."""
    consent_tables = [t for t in schema["tables"]
                      if "consent" in t["name"].lower()]

    if not consent_tables:
        return "FAIL: No consent tracking table found"

    for table in consent_tables:
        field_names = {f["name"] for f in table["fields"]}
        missing = [f for f in REQUIRED_CONSENT_FIELDS if f not in field_names]
        if missing:
            return f"FAIL: Consent table '{table['name']}' missing: {', '.join(missing)}"

    return "PASS: Consent tracking properly modeled"
```

---

## PART 5: HIPAA COMPLIANCE CHECKS

### PHI Detection and Encryption Verification

```rego
# policy/hipaa/phi_protection.rego
package hipaa.phi

# PHI fields must be encrypted at rest
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_db_instance"
    resource.change.after.storage_encrypted != true
    msg := "HIPAA: Database storing PHI must have encryption at rest enabled"
}

# PHI access must be audited
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_db_instance"
    not has_audit_logging(resource)
    msg := "HIPAA: Database must have audit logging enabled for PHI access tracking"
}

has_audit_logging(resource) {
    resource.change.after.enabled_cloudwatch_logs_exports[_] == "audit"
}

# Backup encryption required
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_db_instance"
    resource.change.after.backup_retention_period < 7
    msg := "HIPAA: Database backup retention must be at least 7 days"
}
```

### Audit Logging Verification

```bash
#!/bin/bash
# scripts/check_hipaa_audit_logging.sh
# HIPAA §164.312(b) — Audit controls

echo "=== HIPAA Audit Logging Verification ==="

# Check CloudTrail is enabled and logging
TRAIL=$(aws cloudtrail describe-trails --query 'trailList[0]' 2>/dev/null)
if [ -z "$TRAIL" ]; then
    echo "FAIL: No CloudTrail trail configured"
    exit 1
fi

LOGGING=$(echo "$TRAIL" | jq -r '.IsLogging // false')
if [ "$LOGGING" != "true" ]; then
    echo "FAIL: CloudTrail logging is disabled"
    exit 1
fi

# Check log file validation
VALIDATION=$(echo "$TRAIL" | jq -r '.LogFileValidationEnabled // false')
if [ "$VALIDATION" != "true" ]; then
    echo "FAIL: CloudTrail log file validation not enabled (tamper detection)"
    exit 1
fi

# Check encryption
KMS_KEY=$(echo "$TRAIL" | jq -r '.KmsKeyId // empty')
if [ -z "$KMS_KEY" ]; then
    echo "FAIL: CloudTrail logs not encrypted with KMS"
    exit 1
fi

echo "PASS: HIPAA audit logging properly configured"
```

---

## PART 6: PCI-DSS COMPLIANCE CHECKS

```rego
# policy/pci/cardholder_data.rego
package pci.cardholder

# PCI-DSS Req 3 — Protect stored cardholder data
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
    not has_encryption(resource)
    has_tag(resource, "data-classification", "cardholder")
    msg := "PCI-DSS 3.4: Cardholder data buckets must be encrypted"
}

# PCI-DSS Req 7 — Restrict access by business need-to-know
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_policy"
    is_overly_permissive(resource)
    msg := "PCI-DSS 7.1: IAM policies must follow least privilege"
}

is_overly_permissive(resource) {
    statement := resource.change.after.policy.Statement[_]
    statement.Effect == "Allow"
    statement.Action[_] == "*"
    statement.Resource[_] == "*"
}

# PCI-DSS Req 8 — Strong authentication
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_account_password_policy"
    resource.change.after.minimum_password_length < 12
    msg := "PCI-DSS 8.2.3: Minimum password length must be 12 characters"
}
```

### Network Segmentation Check

```bash
#!/bin/bash
# scripts/check_pci_segmentation.sh
# PCI-DSS Req 1 — Network segmentation

echo "=== PCI-DSS Network Segmentation Verification ==="

# Check security groups for CDE (Cardholder Data Environment)
CDE_SGS=$(aws ec2 describe-security-groups \
    --filters "Name=tag:environment,Values=cde" \
    --query 'SecurityGroups[*].{ID:GroupId,Name:GroupName,Ingress:IpPermissions}' \
    --output json)

echo "$CDE_SGS" | jq -r '.[] | .Ingress[] | select(.IpRanges[].CidrIp == "0.0.0.0/0")' | while read -r rule; do
    if [ -n "$rule" ]; then
        echo "FAIL: CDE security group allows 0.0.0.0/0 ingress"
        exit 1
    fi
done

echo "PASS: CDE network segmentation verified"
```

---

## PART 7: CI/CD PIPELINE INTEGRATION

### GitHub Actions Compliance Pipeline

```yaml
# .github/workflows/compliance.yml
name: Compliance Checks
on:
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 6 * * 1'  # Weekly Monday 6AM UTC

jobs:
  policy-checks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Conftest
        run: |
          wget -q https://github.com/open-policy-agent/conftest/releases/download/v0.50.0/conftest_0.50.0_Linux_x86_64.tar.gz
          tar xzf conftest_*.tar.gz
          sudo mv conftest /usr/local/bin/

      - name: Validate Terraform
        if: hashFiles('**/*.tf') != ''
        run: |
          terraform init -backend=false
          terraform plan -out=tfplan
          terraform show -json tfplan > tfplan.json
          conftest test tfplan.json --policy policy/

      - name: Validate Kubernetes manifests
        if: hashFiles('k8s/**/*.yaml') != ''
        run: conftest test k8s/ --policy policy/kubernetes/

      - name: Validate Dockerfiles
        if: hashFiles('**/Dockerfile*') != ''
        run: |
          find . -name 'Dockerfile*' | while read f; do
            echo "Checking $f..."
            conftest test "$f" --policy policy/docker/
          done

  secret-scanning:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: GitGuardian Scan
        uses: GitGuardian/ggshield-action@v1
        env:
          GITGUARDIAN_API_KEY: ${{ secrets.GITGUARDIAN_API_KEY }}

      - name: Trivy Secret Scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: fs
          scanners: secret
          severity: HIGH,CRITICAL

  vulnerability-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Snyk Code & Dependencies
        uses: snyk/actions/node@master
        with:
          args: --severity-threshold=high
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

  compliance-report:
    needs: [policy-checks, secret-scanning, vulnerability-scan]
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'
    steps:
      - uses: actions/checkout@v4

      - name: Generate Compliance Report
        run: python scripts/generate_compliance_report.py

      - name: Upload Audit Evidence
        uses: actions/upload-artifact@v4
        with:
          name: compliance-report-${{ github.run_id }}
          path: reports/compliance-*.json
          retention-days: 365  # Keep for audit period
```

---

## PART 8: AUDIT EVIDENCE GENERATION

```python
# scripts/generate_compliance_report.py
"""Generate automated compliance evidence report."""
import json
import subprocess
from datetime import datetime, timezone

def generate_report(framework: str):
    report = {
        "framework": framework,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "generated_by": "compliance-pipeline",
        "version": "1.0",
        "controls": [],
    }

    controls = load_controls(framework)

    for control in controls:
        result = {
            "control_id": control["id"],
            "description": control["description"],
            "status": "PASS",
            "evidence": [],
            "checked_at": datetime.now(timezone.utc).isoformat(),
        }

        for check in control["checks"]:
            evidence = run_check(check)
            result["evidence"].append(evidence)
            if evidence["status"] == "FAIL":
                result["status"] = "FAIL"
            elif evidence["status"] == "WARN" and result["status"] == "PASS":
                result["status"] = "WARN"

        report["controls"].append(result)

    # Summary
    total = len(report["controls"])
    passed = sum(1 for c in report["controls"] if c["status"] == "PASS")
    report["summary"] = {
        "total_controls": total,
        "passed": passed,
        "failed": total - passed,
        "compliance_percentage": round(passed / total * 100, 1) if total > 0 else 0,
    }

    output_path = f"reports/compliance-{framework}-{datetime.now(timezone.utc).strftime('%Y%m%d')}.json"
    with open(output_path, "w") as f:
        json.dump(report, f, indent=2)

    print(f"Report generated: {output_path}")
    print(f"Compliance: {report['summary']['compliance_percentage']}% "
          f"({passed}/{total} controls passed)")

    return report

def run_check(check):
    """Execute a single compliance check and capture evidence."""
    try:
        if check["type"] == "opa":
            result = subprocess.run(
                ["conftest", "test", check.get("input", "."), "--policy", check["policy"], "-o", "json"],
                capture_output=True, text=True, timeout=60,
            )
            return {
                "type": "opa",
                "policy": check["policy"],
                "status": "PASS" if result.returncode == 0 else "FAIL",
                "output": result.stdout,
            }
        elif check["type"] == "custom":
            result = subprocess.run(
                ["bash", check["script"]], capture_output=True, text=True, timeout=120,
            )
            return {
                "type": "custom",
                "script": check["script"],
                "status": "PASS" if result.returncode == 0 else "FAIL",
                "output": result.stdout,
            }
    except subprocess.TimeoutExpired:
        return {"type": check["type"], "status": "FAIL", "output": "Check timed out"}

def load_controls(framework):
    """Load control definitions from YAML."""
    import yaml
    with open(f"compliance/{framework}-controls.yaml") as f:
        return yaml.safe_load(f)["controls"]

if __name__ == "__main__":
    import sys
    framework = sys.argv[1] if len(sys.argv) > 1 else "soc2"
    generate_report(framework)
```

---

## PART 9: DRIFT DETECTION

### Continuous Compliance Monitoring

```yaml
# .github/workflows/compliance-drift.yml
name: Compliance Drift Detection
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  drift-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Prowler (AWS)
        run: |
          pip install prowler
          prowler aws --compliance soc2 --output-formats json --output-directory reports/
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AUDIT_AWS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AUDIT_AWS_SECRET }}

      - name: Compare with baseline
        run: python scripts/detect_drift.py reports/ baseline/

      - name: Alert on drift
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "Compliance drift detected! Review: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_COMPLIANCE_WEBHOOK }}
```

### Drift Detection Script

```python
# scripts/detect_drift.py
"""Compare current compliance state against established baseline."""
import json
import sys

def detect_drift(current_dir: str, baseline_dir: str):
    current = load_latest_report(current_dir)
    baseline = load_latest_report(baseline_dir)

    new_failures = []
    for control in current["controls"]:
        baseline_control = find_control(baseline, control["control_id"])
        if baseline_control and baseline_control["status"] == "PASS" and control["status"] == "FAIL":
            new_failures.append({
                "control_id": control["control_id"],
                "description": control["description"],
                "was": "PASS",
                "now": "FAIL",
            })

    if new_failures:
        print(f"DRIFT DETECTED: {len(new_failures)} controls regressed")
        for f in new_failures:
            print(f"  - {f['control_id']}: {f['description']}")
        sys.exit(1)

    print("No compliance drift detected")

def find_control(report, control_id):
    return next((c for c in report["controls"] if c["control_id"] == control_id), None)

def load_latest_report(directory):
    import glob, os
    files = sorted(glob.glob(f"{directory}/compliance-*.json"), key=os.path.getmtime, reverse=True)
    with open(files[0]) as f:
        return json.load(f)

if __name__ == "__main__":
    detect_drift(sys.argv[1], sys.argv[2])
```

---

## PART 10: COMPLIANCE DASHBOARD

### Control Mapping Template

```markdown
# Compliance Control Mapping

## SOC2 Type II — Trust Service Criteria

| Control ID | Description | Automated Check | Frequency | Owner | Status |
|-----------|-------------|-----------------|-----------|-------|--------|
| CC6.1 | Logical access controls | IAM policy scan | Daily | Security | PASS |
| CC6.6 | Encryption in transit | TLS config check | Per-deploy | DevOps | PASS |
| CC6.7 | Encryption at rest | Storage encryption scan | Daily | Security | PASS |
| CC7.2 | Monitoring & detection | Alert config check | Weekly | SRE | PASS |
| CC8.1 | Change management | Branch protection check | Per-deploy | DevOps | PASS |

## GDPR — Key Articles

| Article | Requirement | Automated Check | Frequency | Status |
|---------|-------------|-----------------|-----------|--------|
| Art. 5(1)(e) | Storage limitation | Data retention check | Weekly | PASS |
| Art. 7 | Consent tracking | Consent model check | Per-deploy | PASS |
| Art. 25 | Data protection by design | PII encryption check | Per-deploy | PASS |
| Art. 32 | Security of processing | Vulnerability scan | Daily | PASS |
| Art. 33 | Breach notification | Incident process check | Monthly | PASS |
```

### Integration with Existing Tools

```yaml
# Tool integration matrix
integrations:
  snyk:
    purpose: Dependency vulnerabilities + license compliance
    frameworks: [SOC2-CC7.1, PCI-6.2, HIPAA-164.308]
    frequency: per-commit
    config: .snyk

  gitguardian:
    purpose: Secret detection in source code
    frameworks: [SOC2-CC6.1, PCI-3.4, HIPAA-164.312]
    frequency: per-commit
    config: .gitguardian.yml

  prowler:
    purpose: AWS security posture & compliance
    frameworks: [SOC2, PCI-DSS, HIPAA, GDPR]
    frequency: daily
    config: prowler-config.yaml

  trivy:
    purpose: Container image vulnerabilities + misconfig
    frameworks: [SOC2-CC7.1, PCI-6.2]
    frequency: per-build
    config: trivy.yaml
```

---

## Exit Checklist

- [ ] OPA/Rego policies defined for infrastructure (Terraform, K8s, Docker)
- [ ] Conftest integrated into CI/CD pipeline — blocks non-compliant merges
- [ ] SOC2 controls mapped to automated checks with evidence capture
- [ ] GDPR PII detection running against data models and log statements
- [ ] GDPR consent tracking model verified with required fields
- [ ] GDPR data retention policies defined for all PII-containing tables
- [ ] HIPAA PHI encryption and audit logging verified
- [ ] PCI-DSS cardholder data protection and network segmentation checked
- [ ] Secret scanning enabled (GitGuardian or Trivy) on every commit
- [ ] Vulnerability scanning enabled (Snyk or Trivy) with severity threshold
- [ ] Compliance report auto-generated with JSON evidence artifacts
- [ ] Audit evidence stored with 365+ day retention
- [ ] Drift detection running on schedule with Slack/PagerDuty alerting
- [ ] Control mapping document maintained with owner and frequency
- [ ] Baseline compliance state captured for drift comparison
