---
name: Infrastructure Testing
description: IaC testing with Terratest, Checkov, tfsec, Conftest, Kitchen-Terraform, and policy-as-code
---

# Infrastructure Testing Skill

**Purpose**: Validate infrastructure-as-code correctness, security, and compliance using static analysis, unit tests, integration tests, and policy-as-code frameworks.

---

## TRIGGER COMMANDS

```text
"Test infrastructure code"
"Run security scan on Terraform"
"Set up policy-as-code"
"Validate IaC compliance"
"Using infrastructure_testing skill: [task]"
```

---

## Testing Pyramid for Infrastructure

```
              /\
             /  \
            / E2E \        Integration tests against real cloud
           /  Tests \      (Terratest, Kitchen-Terraform)
          /----------\
         / Integration\    Plan-based validation
        /    Tests     \   (Conftest on terraform plan)
       /----------------\
      /  Static Analysis  \  Linting, security scanning
     /   & Unit Tests      \ (tfsec, Checkov, terraform validate)
    /------------------------\
```

| Layer | Tool | Speed | Cost | Coverage |
|-------|------|-------|------|----------|
| Static analysis | tfsec, Checkov, trivy | Seconds | Free | Misconfig, CVE |
| Unit tests | terraform validate, OPA | Seconds | Free | Syntax, logic |
| Plan validation | Conftest + plan JSON | Seconds | Free | Policy compliance |
| Integration tests | Terratest | Minutes | Cloud cost | Real infrastructure |
| E2E tests | Kitchen-Terraform | Minutes | Cloud cost | Full stack |

---

## Static Analysis

### tfsec

```bash
# Install
brew install tfsec

# Scan directory
tfsec ./terraform/

# Scan with specific checks
tfsec ./terraform/ --include-passed --format json --out report.json

# Suppress specific rule
tfsec ./terraform/ --exclude aws-s3-enable-bucket-logging
```

```hcl
# Inline suppression
resource "aws_s3_bucket" "logs" {
  bucket = "my-logs-bucket"

  #tfsec:ignore:aws-s3-enable-versioning -- Log bucket, versioning not needed
}
```

### Checkov

```bash
# Install
pip install checkov

# Scan Terraform
checkov -d ./terraform/ --framework terraform

# Scan with custom policy
checkov -d ./terraform/ --external-checks-dir ./policies/

# Scan Kubernetes manifests
checkov -d ./k8s/ --framework kubernetes

# Scan Dockerfile
checkov -f Dockerfile --framework dockerfile

# Output formats
checkov -d ./terraform/ -o json -o sarif --output-file-path results/
```

### Checkov Custom Policy

```python
# policies/check_encryption.py
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckResult, CheckCategories

class S3EncryptionCheck(BaseResourceCheck):
    def __init__(self):
        name = "Ensure S3 bucket has server-side encryption"
        id = "CUSTOM_S3_001"
        supported_resources = ["aws_s3_bucket"]
        categories = [CheckCategories.ENCRYPTION]
        super().__init__(name=name, id=id, categories=categories,
                        supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        # Check for server_side_encryption_configuration
        if "server_side_encryption_configuration" in conf:
            return CheckResult.PASSED
        return CheckResult.FAILED

check = S3EncryptionCheck()
```

### trivy (IaC Scanning)

```bash
# Scan Terraform
trivy config ./terraform/

# Scan with severity filter
trivy config --severity HIGH,CRITICAL ./terraform/

# Scan Kubernetes manifests
trivy config ./k8s/

# Scan Dockerfile
trivy config ./Dockerfile
```

---

## Policy-as-Code with OPA/Conftest

### Conftest with Terraform Plan

```bash
# Generate Terraform plan as JSON
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json

# Run Conftest policies against plan
conftest test plan.json -p policies/ --output json
```

### OPA/Rego Policies

```rego
# policies/terraform.rego
package main

import rego.v1

# Deny resources without required tags
deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    tags := resource.change.after.tags
    not tags.Environment
    msg := sprintf("Resource %s missing required tag 'Environment'", [resource.address])
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    tags := resource.change.after.tags
    not tags.Owner
    msg := sprintf("Resource %s missing required tag 'Owner'", [resource.address])
}

# Deny public S3 buckets
deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket_acl"
    resource.change.after.acl == "public-read"
    msg := sprintf("S3 bucket %s must not be public", [resource.address])
}

# Deny overly permissive security groups
deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_security_group_rule"
    resource.change.after.cidr_blocks[_] == "0.0.0.0/0"
    resource.change.after.from_port == 0
    resource.change.after.to_port == 65535
    msg := sprintf("Security group %s allows all traffic from 0.0.0.0/0", [resource.address])
}

# Enforce instance type restrictions
deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_instance"
    instance_type := resource.change.after.instance_type
    not allowed_instance_type(instance_type)
    msg := sprintf("Instance type %s not allowed for %s", [instance_type, resource.address])
}

allowed_instance_type(t) if startswith(t, "t3.")
allowed_instance_type(t) if startswith(t, "m6i.")
allowed_instance_type(t) if startswith(t, "c6i.")
allowed_instance_type(t) if startswith(t, "r6i.")
```

### Conftest for Kubernetes

```rego
# policies/kubernetes.rego
package main

import rego.v1

# Deny containers without resource limits
deny contains msg if {
    container := input.spec.template.spec.containers[_]
    not container.resources.limits
    msg := sprintf("Container %s must have resource limits", [container.name])
}

# Deny running as root
deny contains msg if {
    container := input.spec.template.spec.containers[_]
    container.securityContext.runAsUser == 0
    msg := sprintf("Container %s must not run as root", [container.name])
}

# Deny latest tag
deny contains msg if {
    container := input.spec.template.spec.containers[_]
    endswith(container.image, ":latest")
    msg := sprintf("Container %s must not use :latest tag", [container.name])
}

# Require readiness probe
deny contains msg if {
    container := input.spec.template.spec.containers[_]
    not container.readinessProbe
    msg := sprintf("Container %s must have a readiness probe", [container.name])
}
```

---

## Integration Testing with Terratest

### Go Test Structure

```go
// test/vpc_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/stretchr/testify/assert"
)

func TestVPC(t *testing.T) {
    t.Parallel()

    awsRegion := "us-east-1"

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "../terraform/modules/vpc",
        Vars: map[string]interface{}{
            "vpc_cidr":     "10.99.0.0/16",
            "environment":  "test",
            "project_name": "terratest",
        },
        EnvVars: map[string]string{
            "AWS_DEFAULT_REGION": awsRegion,
        },
    })

    // Clean up after test
    defer terraform.Destroy(t, terraformOptions)

    // Deploy
    terraform.InitAndApply(t, terraformOptions)

    // Validate outputs
    vpcID := terraform.Output(t, terraformOptions, "vpc_id")
    assert.NotEmpty(t, vpcID)

    // Validate VPC exists in AWS
    vpc := aws.GetVpcById(t, vpcID, awsRegion)
    assert.Equal(t, "10.99.0.0/16", vpc.CidrBlock)

    // Validate subnets
    publicSubnets := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
    assert.Equal(t, 3, len(publicSubnets))

    privateSubnets := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
    assert.Equal(t, 3, len(privateSubnets))

    // Validate tags
    tags := aws.GetTagsForVpc(t, vpcID, awsRegion)
    assert.Equal(t, "test", tags["Environment"])
}
```

### Testing ECS Cluster

```go
func TestECSCluster(t *testing.T) {
    t.Parallel()

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "../terraform/modules/ecs",
        Vars: map[string]interface{}{
            "cluster_name": "test-cluster",
            "environment":  "test",
        },
    })

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    clusterName := terraform.Output(t, terraformOptions, "cluster_name")
    assert.Equal(t, "test-cluster", clusterName)

    // Verify cluster is ACTIVE
    clusterARN := terraform.Output(t, terraformOptions, "cluster_arn")
    cluster := aws.GetEcsCluster(t, "us-east-1", clusterARN)
    assert.Equal(t, "ACTIVE", aws.StringValue(cluster.Status))
}
```

### Terratest Best Practices

| Practice | Description |
|----------|-------------|
| t.Parallel() | Run tests concurrently |
| Unique naming | Use random suffix to avoid conflicts |
| Retryable errors | Use WithDefaultRetryableErrors |
| Timeouts | Set terraform.Timeout for long operations |
| Stages | Use test_structure.RunTestStage for setup/teardown |
| Cost | Use small instances, short-lived resources |

---

## Helm Chart Testing

### Helm Lint + Template

```bash
# Lint chart
helm lint ./charts/api-server/

# Template and validate with kubeval
helm template test ./charts/api-server/ -f ci/values.yaml | kubeval --strict

# Template and validate with kubeconform
helm template test ./charts/api-server/ -f ci/values.yaml | kubeconform -strict
```

### Conftest for Helm Output

```bash
# Validate Helm output against policies
helm template test ./charts/api-server/ -f ci/values.yaml | conftest test - -p policies/
```

---

## CI/CD Integration

### GitHub Actions Pipeline

```yaml
name: Infrastructure Tests
on:
  pull_request:
    paths:
      - 'terraform/**'
      - 'k8s/**'
      - 'charts/**'

jobs:
  static-analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: tfsec
        uses: aquasecurity/tfsec-action@v1.0.0
        with:
          working_directory: terraform/
          soft_fail: false

      - name: Checkov
        uses: bridgecrewio/checkov-action@v12
        with:
          directory: terraform/
          framework: terraform
          output_format: sarif
          output_file_path: checkov.sarif

      - name: trivy IaC scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: config
          scan-ref: terraform/
          severity: HIGH,CRITICAL
          exit-code: 1

      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: checkov.sarif

  policy-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: hashicorp/setup-terraform@v3

      - name: Terraform Init & Plan
        run: |
          cd terraform/
          terraform init -backend=false
          terraform plan -out=plan.tfplan
          terraform show -json plan.tfplan > plan.json

      - name: Conftest policy check
        uses: open-policy-agent/conftest-action@v2
        with:
          files: terraform/plan.json
          policy: policies/

  helm-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: azure/setup-helm@v4

      - name: Lint charts
        run: helm lint charts/*/

      - name: Template and validate
        run: |
          for chart in charts/*/; do
            helm template test "$chart" -f "$chart/ci/values.yaml" | kubeconform -strict
          done

      - name: Policy check
        run: |
          for chart in charts/*/; do
            helm template test "$chart" -f "$chart/ci/values.yaml" | conftest test - -p policies/kubernetes/
          done

  integration-test:
    runs-on: ubuntu-latest
    if: github.event.pull_request.label == 'run-integration-tests'
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Run Terratest
        run: |
          cd test/
          go test -v -timeout 30m -run TestVPC
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

## Pre-Commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-tf-docs
    rev: v0.12.1
    hooks:
      - id: terraform-fmt
      - id: terraform-validate
      - id: terraform-docs
        args: ['--hook-config=--path-to-file=README.md']

  - repo: https://github.com/aquasecurity/tfsec
    rev: v1.28.4
    hooks:
      - id: tfsec

  - repo: https://github.com/bridgecrewio/checkov
    rev: 3.2.0
    hooks:
      - id: checkov
        args: ['--framework', 'terraform']
```

---

## Cross-References

- `3-build/kubernetes_operations` - K8s resources validated by policies
- `3-build/helm_chart_development` - Helm charts tested with ct and kubeconform
- `5-ship/gitops_workflow` - Policy gates before GitOps sync
- `4-secure/chaos_engineering` - Test infrastructure resilience

---

## EXIT CHECKLIST

- [ ] Static analysis tools configured (tfsec, Checkov, trivy)
- [ ] terraform validate passes for all modules
- [ ] OPA/Rego policies cover tagging, encryption, and access controls
- [ ] Conftest validates terraform plan output against policies
- [ ] Helm charts linted and validated with kubeconform
- [ ] Terratest integration tests exist for critical modules (VPC, ECS, RDS)
- [ ] CI pipeline runs static analysis on every PR
- [ ] Integration tests run on-demand or nightly (not every PR)
- [ ] Pre-commit hooks catch issues before push
- [ ] SARIF reports uploaded for code scanning dashboard
- [ ] Policy failures block merge (not just warn)
- [ ] Test infrastructure costs tracked and cleaned up

---

*Skill Version: 1.0 | Created: March 2026*
