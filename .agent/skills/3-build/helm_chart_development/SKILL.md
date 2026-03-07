---
name: Helm Chart Development
description: Helm chart creation, templating, values management, dependencies, testing, and chart repository publishing
---

# Helm Chart Development Skill

**Purpose**: Build, test, and publish production-grade Helm charts with proper templating, dependency management, and chart testing workflows.

---

## TRIGGER COMMANDS

```text
"Create a Helm chart"
"Package this app as a Helm chart"
"Add Helm chart templating"
"Set up chart testing"
"Using helm_chart_development skill: [task]"
```

---

## Chart Structure

```
mychart/
  Chart.yaml              # Chart metadata and dependencies
  Chart.lock              # Locked dependency versions
  values.yaml             # Default values
  values-staging.yaml     # Environment override
  values-production.yaml  # Environment override
  templates/
    _helpers.tpl          # Template helpers / named templates
    deployment.yaml
    service.yaml
    ingress.yaml
    hpa.yaml
    configmap.yaml
    secret.yaml
    serviceaccount.yaml
    networkpolicy.yaml
    NOTES.txt             # Post-install instructions
  charts/                 # Dependency charts (auto-populated)
  tests/
    test-connection.yaml  # Helm test pod
  ci/
    ci-values.yaml        # Values for CI testing
```

---

## Chart.yaml

```yaml
apiVersion: v2
name: api-server
description: Production API server chart
type: application
version: 1.4.2        # Chart version (semver)
appVersion: "2.1.0"   # Application version
kubeVersion: ">=1.27.0"
home: https://github.com/org/api-server
maintainers:
  - name: Platform Team
    email: platform@example.com
annotations:
  artifacthub.io/changes: |
    - kind: added
      description: Network policy support
    - kind: fixed
      description: HPA metric threshold
dependencies:
  - name: postgresql
    version: "~15.0"
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
  - name: redis
    version: "^18.0"
    repository: https://charts.bitnami.com/bitnami
    condition: redis.enabled
```

---

## Template Helpers (_helpers.tpl)

```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified app name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mychart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Chart name and version for chart label
*/}}
{{- define "mychart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "mychart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mychart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
```

---

## Values.yaml Best Practices

```yaml
# values.yaml - sensible defaults, override per environment
replicaCount: 2

image:
  repository: registry.example.com/api-server
  tag: ""  # Defaults to Chart.appVersion
  pullPolicy: IfNotPresent

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name: ""

podAnnotations: {}

podSecurityContext:
  fsGroup: 1000
  runAsNonRoot: true

securityContext:
  readOnlyRootFilesystem: true
  runAsUser: 1000
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["ALL"]

service:
  type: ClusterIP
  port: 80
  targetPort: 8080

ingress:
  enabled: false
  className: nginx
  annotations: {}
  hosts:
    - host: api.example.com
      paths:
        - path: /
          pathType: Prefix
  tls: []

resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

nodeSelector: {}
tolerations: []
affinity: {}

# Application-specific config
config:
  logLevel: info
  metricsEnabled: true
  metricsPort: 9090

# Dependency toggles
postgresql:
  enabled: true
  auth:
    database: appdb
redis:
  enabled: false
```

### Environment Override (values-production.yaml)

```yaml
replicaCount: 5

resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: "2"
    memory: 1Gi

autoscaling:
  enabled: true
  minReplicas: 5
  maxReplicas: 30

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: api.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: api-tls
      hosts:
        - api.example.com

config:
  logLevel: warn
```

---

## Templating Patterns

### Conditional Resources

```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "mychart.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
{{- end }}
```

### Iterating Over Maps

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "mychart.fullname" . }}-config
data:
  {{- range $key, $value := .Values.config }}
  {{ $key }}: {{ $value | quote }}
  {{- end }}
```

### Required Values Validation

```yaml
# In deployment.yaml
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
{{- if not .Values.image.repository }}
  {{- fail "image.repository is required" }}
{{- end }}
```

### toYaml with nindent

```yaml
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
```

---

## Dependency Management

```bash
# Add dependency
helm dependency update ./mychart

# List dependencies
helm dependency list ./mychart

# Build (download) dependencies
helm dependency build ./mychart
```

### Accessing Sub-Chart Values

```yaml
# Parent values.yaml - override sub-chart defaults
postgresql:
  enabled: true
  auth:
    database: myapp
    username: appuser
    existingSecret: pg-credentials
  primary:
    resources:
      requests:
        cpu: 500m
        memory: 512Mi
```

### Importing Values from Sub-Charts

```yaml
# Chart.yaml
dependencies:
  - name: postgresql
    version: "~15.0"
    repository: https://charts.bitnami.com/bitnami
    import-values:
      - child: primary.service
        parent: database
```

---

## Chart Testing

### Helm Test Pod

```yaml
# templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "mychart.fullname" . }}-test"
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  containers:
    - name: curl
      image: curlimages/curl:8.5.0
      command: ['curl']
      args: ['--fail', '--silent', 'http://{{ include "mychart.fullname" . }}:{{ .Values.service.port }}/healthz']
  restartPolicy: Never
```

### chart-testing (ct) in CI

```yaml
# .github/workflows/chart-test.yml
name: Chart Testing
on:
  pull_request:
    paths:
      - 'charts/**'

jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: azure/setup-helm@v4

      - uses: helm/chart-testing-action@v2

      - name: Lint charts
        run: ct lint --config ct.yaml

      - name: Create kind cluster
        uses: helm/kind-action@v1

      - name: Install and test charts
        run: ct install --config ct.yaml
```

### ct.yaml Configuration

```yaml
# ct.yaml
remote: origin
target-branch: main
chart-dirs:
  - charts
validate-maintainers: false
check-version-increment: true
```

### helm-unittest

```yaml
# tests/deployment_test.yaml
suite: deployment tests
templates:
  - deployment.yaml
tests:
  - it: should set correct replicas
    set:
      replicaCount: 5
    asserts:
      - equal:
          path: spec.replicas
          value: 5

  - it: should use chart appVersion as default tag
    asserts:
      - matchRegex:
          path: spec.template.spec.containers[0].image
          pattern: ":.*$"

  - it: should fail without image repository
    set:
      image.repository: ""
    asserts:
      - failedTemplate: {}
```

---

## Chart Repository Publishing

### Using OCI Registry (Recommended)

```bash
# Login to registry
helm registry login registry.example.com -u user

# Package chart
helm package ./mychart

# Push to OCI registry
helm push mychart-1.4.2.tgz oci://registry.example.com/charts

# Install from OCI
helm install myrelease oci://registry.example.com/charts/mychart --version 1.4.2
```

### ChartMuseum

```bash
# Run ChartMuseum
docker run -d -p 8080:8080 \
  -e STORAGE=local \
  -e STORAGE_LOCAL_ROOTDIR=/charts \
  -v /data/charts:/charts \
  ghcr.io/helm/chartmuseum:latest

# Add repo and push
helm repo add myrepo http://localhost:8080
helm cm-push mychart/ myrepo
```

---

## Common Commands

```bash
# Development workflow
helm template myrelease ./mychart -f values-staging.yaml    # Render locally
helm lint ./mychart                                          # Lint chart
helm install myrelease ./mychart --dry-run --debug           # Dry run

# Release management
helm install myrelease ./mychart -n production -f values-production.yaml
helm upgrade myrelease ./mychart -n production -f values-production.yaml
helm rollback myrelease 3 -n production
helm history myrelease -n production

# Debugging
helm get values myrelease -n production
helm get manifest myrelease -n production
helm get all myrelease -n production
```

---

## Cross-References

- `3-build/kubernetes_operations` - K8s resources that Helm charts manage
- `5-ship/gitops_workflow` - Deploy Helm charts via ArgoCD/Flux
- `4-secure/infrastructure_testing` - Lint and validate Helm charts in CI

---

## EXIT CHECKLIST

- [ ] Chart.yaml has correct apiVersion (v2), version, and appVersion
- [ ] _helpers.tpl defines name, fullname, labels, selectorLabels
- [ ] values.yaml has sensible defaults for all configurable fields
- [ ] Environment overrides exist (values-staging.yaml, values-production.yaml)
- [ ] All resources use template helpers for names and labels
- [ ] Security context set (non-root, read-only FS, drop caps)
- [ ] Resource requests and limits configurable via values
- [ ] Conditional resources gated by values (ingress.enabled, autoscaling.enabled)
- [ ] Dependencies declared and locked (Chart.lock committed)
- [ ] `helm lint` passes cleanly
- [ ] `helm template` renders valid manifests
- [ ] Helm test pod validates service connectivity
- [ ] NOTES.txt provides post-install guidance
- [ ] Chart packaged and pushed to OCI registry or ChartMuseum

---

*Skill Version: 1.0 | Created: March 2026*
