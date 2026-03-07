---
name: GitOps Workflow
description: GitOps with ArgoCD and Flux covering directory structures, sync strategies, rollback, and secrets management
---

# GitOps Workflow Skill

**Purpose**: Implement GitOps-based continuous delivery using ArgoCD or Flux, with proper repository structures, sync strategies, progressive rollouts, and secret management.

---

## TRIGGER COMMANDS

```text
"Set up GitOps deployment"
"Configure ArgoCD for this project"
"Create a Flux CD pipeline"
"GitOps directory structure"
"Using gitops_workflow skill: [task]"
```

---

## GitOps Principles

| Principle | Description |
|-----------|-------------|
| Declarative | Entire system described declaratively in Git |
| Versioned | Git as single source of truth, full audit trail |
| Automated | Approved changes auto-applied to the system |
| Self-healing | Drift detected and corrected automatically |

---

## Tool Comparison

| Feature | ArgoCD | Flux v2 |
|---------|--------|---------|
| UI Dashboard | Built-in web UI | Weave GitOps (optional) |
| Multi-cluster | App-of-apps, ApplicationSet | Kustomization references |
| Helm support | Native | HelmRelease CRD |
| Kustomize | Native | Native |
| Sync waves | Annotations | dependsOn field |
| Notifications | argocd-notifications | Flux notification controller |
| RBAC | Built-in project RBAC | K8s RBAC |
| Diff preview | Built-in UI diff | CLI only |
| Learning curve | Moderate | Lower |
| Best for | Multi-team, UI-driven | Lightweight, code-first |

---

## Repository Structure

### Monorepo Pattern (Small-Medium Teams)

```
gitops-repo/
  apps/
    base/
      api-server/
        deployment.yaml
        service.yaml
        kustomization.yaml
      web-app/
        deployment.yaml
        service.yaml
        kustomization.yaml
    overlays/
      staging/
        kustomization.yaml       # patches for staging
        api-server-patch.yaml
      production/
        kustomization.yaml       # patches for production
        api-server-patch.yaml
  infrastructure/
    base/
      cert-manager/
      ingress-nginx/
      monitoring/
    overlays/
      staging/
      production/
  clusters/
    staging/
      apps.yaml                  # ArgoCD Application or Flux Kustomization
      infrastructure.yaml
    production/
      apps.yaml
      infrastructure.yaml
```

### Polyrepo Pattern (Large Organizations)

```
# Repo 1: app-configs (per team or per app)
api-server/
  base/
  overlays/staging/
  overlays/production/

# Repo 2: platform-configs (platform team)
infrastructure/
  cert-manager/
  monitoring/
  ingress/

# Repo 3: cluster-configs (SRE team)
clusters/
  staging-us-east-1/
  production-us-east-1/
  production-eu-west-1/
```

### When to Use Each

| Pattern | Team Size | Repos | Pros | Cons |
|---------|-----------|-------|------|------|
| Monorepo | 1-5 teams | 1 | Simple, atomic commits | Noisy PRs, broad access |
| Polyrepo | 5+ teams | Many | Team isolation, granular access | Cross-repo coordination |

---

## ArgoCD Setup

### Application Definition

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: api-server
  namespace: argocd
  labels:
    app.kubernetes.io/part-of: platform
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: production
  source:
    repoURL: https://github.com/org/gitops-repo.git
    targetRevision: main
    path: apps/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - PruneLast=true
      - ServerSideApply=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
  ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
        - /spec/replicas
```

### AppProject (RBAC Boundary)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: production
  namespace: argocd
spec:
  description: Production applications
  sourceRepos:
    - https://github.com/org/gitops-repo.git
  destinations:
    - namespace: production
      server: https://kubernetes.default.svc
    - namespace: production-jobs
      server: https://kubernetes.default.svc
  clusterResourceWhitelist:
    - group: ""
      kind: Namespace
  namespaceResourceBlacklist:
    - group: ""
      kind: ResourceQuota
    - group: ""
      kind: LimitRange
  roles:
    - name: deployer
      description: CI/CD pipeline role
      policies:
        - p, proj:production:deployer, applications, sync, production/*, allow
        - p, proj:production:deployer, applications, get, production/*, allow
      groups:
        - ci-deployers
```

### ApplicationSet (Multi-Environment)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: api-server
  namespace: argocd
spec:
  generators:
    - list:
        elements:
          - env: staging
            cluster: https://staging.k8s.example.com
            revision: develop
          - env: production
            cluster: https://kubernetes.default.svc
            revision: main
  template:
    metadata:
      name: "api-server-{{env}}"
    spec:
      project: "{{env}}"
      source:
        repoURL: https://github.com/org/gitops-repo.git
        targetRevision: "{{revision}}"
        path: "apps/overlays/{{env}}"
      destination:
        server: "{{cluster}}"
        namespace: "{{env}}"
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

### Sync Waves (Ordering)

```yaml
# 1. Namespace first (wave -1)
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "-1"

# 2. ConfigMaps and Secrets (wave 0, default)

# 3. Deployment (wave 1)
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"

# 4. Post-deploy job (wave 2)
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "2"
    argocd.argoproj.io/hook: PostSync
```

---

## Flux v2 Setup

### GitRepository Source

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: gitops-repo
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/org/gitops-repo.git
  ref:
    branch: main
  secretRef:
    name: git-credentials
```

### Kustomization (Flux)

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps-production
  namespace: flux-system
spec:
  interval: 5m
  retryInterval: 2m
  timeout: 3m
  sourceRef:
    kind: GitRepository
    name: gitops-repo
  path: ./apps/overlays/production
  prune: true
  force: false
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: api-server
      namespace: production
  dependsOn:
    - name: infrastructure
```

### HelmRelease (Flux)

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: api-server
  namespace: production
spec:
  interval: 10m
  chart:
    spec:
      chart: api-server
      version: "~1.4"
      sourceRef:
        kind: HelmRepository
        name: internal-charts
        namespace: flux-system
  values:
    replicaCount: 5
    image:
      tag: "2.1.0"
  valuesFrom:
    - kind: ConfigMap
      name: api-server-values
  upgrade:
    remediation:
      retries: 3
      remediateLastFailure: true
  rollback:
    cleanupOnFail: true
```

---

## Secrets Management in GitOps

### Option Comparison

| Tool | Encryption | Storage | Rotation | Complexity |
|------|-----------|---------|----------|------------|
| SOPS + age/KMS | At rest in Git | Git | Manual | Low |
| Sealed Secrets | Asymmetric in Git | Git | Manual | Low |
| External Secrets | Never in Git | AWS SM/Vault | Automatic | Medium |
| Vault Sidecar | Never in Git | Vault | Automatic | High |

### SOPS with age (Recommended for Small Teams)

```bash
# Generate age key
age-keygen -o age.key

# Create SOPS config
cat > .sops.yaml << 'EOF'
creation_rules:
  - path_regex: .*\.enc\.yaml$
    age: age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
EOF

# Encrypt a secret
sops --encrypt --in-place secrets.enc.yaml

# Decrypt (for editing)
sops secrets.enc.yaml
```

### External Secrets Operator

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: db-credentials
    creationPolicy: Owner
  data:
    - secretKey: password
      remoteRef:
        key: production/db-credentials
        property: password
    - secretKey: host
      remoteRef:
        key: production/db-credentials
        property: host
```

---

## Rollback Strategies

### ArgoCD Rollback

```bash
# View sync history
argocd app history api-server

# Rollback to previous revision
argocd app rollback api-server <history-id>

# Manual sync to specific Git revision
argocd app sync api-server --revision abc123

# Hard refresh (clear cache)
argocd app get api-server --hard-refresh
```

### Flux Rollback

```bash
# Suspend reconciliation
flux suspend kustomization apps-production

# Revert Git commit
git revert HEAD
git push

# Resume reconciliation
flux resume kustomization apps-production
```

### Git-Based Rollback (Universal)

```bash
# Revert the last merge commit
git revert -m 1 HEAD
git push origin main
# GitOps controller auto-syncs the reverted state
```

> **Warning**: Never use `git reset --hard` or force-push on GitOps branches. Always use `git revert` to maintain audit trail.

---

## Progressive Delivery with GitOps

### ArgoCD + Argo Rollouts

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: api-server
  namespace: production
spec:
  replicas: 5
  strategy:
    canary:
      steps:
        - setWeight: 10
        - pause: {duration: 5m}
        - setWeight: 30
        - pause: {duration: 5m}
        - setWeight: 60
        - pause: {duration: 5m}
      analysis:
        templates:
          - templateName: success-rate
        startingStep: 2
        args:
          - name: service-name
            value: api-server
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
        - name: api-server
          image: registry.example.com/api-server:2.1.0
---
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: success-rate
spec:
  args:
    - name: service-name
  metrics:
    - name: success-rate
      interval: 60s
      successCondition: result[0] >= 0.99
      provider:
        prometheus:
          address: http://prometheus:9090
          query: |
            sum(rate(http_requests_total{service="{{args.service-name}}",status=~"2.."}[5m]))
            /
            sum(rate(http_requests_total{service="{{args.service-name}}"}[5m]))
```

---

## Notifications

### ArgoCD Notifications (Slack)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  trigger.on-sync-succeeded: |
    - when: app.status.sync.status == 'Synced'
      send: [app-sync-succeeded]
  trigger.on-sync-failed: |
    - when: app.status.sync.status == 'Unknown'
      send: [app-sync-failed]
  template.app-sync-succeeded: |
    message: |
      Application {{.app.metadata.name}} synced successfully.
      Revision: {{.app.status.sync.revision}}
  service.slack: |
    token: $slack-token
    channel: deployments
```

---

## Cross-References

- `3-build/kubernetes_operations` - K8s resources managed by GitOps
- `3-build/helm_chart_development` - Helm charts deployed via GitOps
- `4-secure/infrastructure_testing` - Validate manifests before merge

---

## EXIT CHECKLIST

- [ ] Repository structure follows monorepo or polyrepo pattern consistently
- [ ] Base + overlay (Kustomize) separation for environment differences
- [ ] ArgoCD Applications or Flux Kustomizations defined for all environments
- [ ] Automated sync enabled with prune and self-heal
- [ ] Sync waves or dependsOn ordering for resource dependencies
- [ ] Secrets encrypted (SOPS) or externalized (External Secrets Operator)
- [ ] No plaintext secrets committed to Git
- [ ] AppProject (ArgoCD) or namespace RBAC restricts deployment scope
- [ ] Rollback procedure documented and tested (git revert path)
- [ ] Progressive delivery configured for critical services
- [ ] Notifications configured for sync success/failure
- [ ] Health checks validate deployment succeeded post-sync
- [ ] Image update automation configured (Flux image reflector or ArgoCD Image Updater)

---

*Skill Version: 1.0 | Created: March 2026*
