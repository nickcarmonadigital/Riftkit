---
name: Kubernetes Operations
description: K8s workload management covering deployments, statefulsets, jobs, CRDs, RBAC, networking, and storage
---

# Kubernetes Operations Skill

**Purpose**: Manage Kubernetes workloads end-to-end, from deploying applications to configuring RBAC, networking policies, persistent storage, and custom resources.

---

## TRIGGER COMMANDS

```text
"Deploy to Kubernetes"
"Create a K8s deployment"
"Set up RBAC for the cluster"
"Configure persistent storage in K8s"
"Using kubernetes_operations skill: [task]"
```

---

## Workload Types Decision Matrix

| Workload Type | Use When | Scaling | Storage | Identity |
|---------------|----------|---------|---------|----------|
| Deployment | Stateless apps, APIs | HPA/VPA | EmptyDir, ConfigMap | Random pod names |
| StatefulSet | Databases, queues, caches | Manual or operator | PVC per pod | Stable ordinal names |
| DaemonSet | Node agents, log collectors | Per-node automatic | HostPath, local | One per node |
| Job | One-off tasks, migrations | Parallelism field | Ephemeral | Completion-based |
| CronJob | Scheduled tasks, reports | Concurrency policy | Ephemeral | Time-triggered |
| ReplicaSet | Managed by Deployment | Direct replicas | Same as Deployment | Random pod names |

---

## Deployments

### Production-Ready Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: production
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/version: "1.4.2"
    app.kubernetes.io/component: backend
    app.kubernetes.io/managed-by: helm
spec:
  replicas: 3
  revisionHistoryLimit: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app.kubernetes.io/name: api-server
  template:
    metadata:
      labels:
        app.kubernetes.io/name: api-server
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"
    spec:
      serviceAccountName: api-server
      terminationGracePeriodSeconds: 60
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: topology.kubernetes.io/zone
          whenUnsatisfiable: DoNotSchedule
          labelSelector:
            matchLabels:
              app.kubernetes.io/name: api-server
      containers:
        - name: api-server
          image: registry.example.com/api-server:1.4.2
          ports:
            - name: http
              containerPort: 8080
            - name: metrics
              containerPort: 9090
          env:
            - name: DB_HOST
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: host
            - name: LOG_LEVEL
              valueFrom:
                configMapKeyRef:
                  name: api-config
                  key: log-level
          resources:
            requests:
              cpu: 250m
              memory: 256Mi
            limits:
              cpu: "1"
              memory: 512Mi
          readinessProbe:
            httpGet:
              path: /healthz
              port: http
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /healthz
              port: http
            initialDelaySeconds: 15
            periodSeconds: 20
            failureThreshold: 5
          startupProbe:
            httpGet:
              path: /healthz
              port: http
            initialDelaySeconds: 10
            periodSeconds: 5
            failureThreshold: 30
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "sleep 15"]
          securityContext:
            runAsNonRoot: true
            runAsUser: 1000
            readOnlyRootFilesystem: true
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
      volumes:
        - name: tmp
          emptyDir: {}
```

### Deployment Strategies Comparison

| Strategy | Zero Downtime | Rollback Speed | Resource Cost | Use Case |
|----------|--------------|----------------|---------------|----------|
| RollingUpdate | Yes | Slow (re-roll) | Low (surge) | Default for most apps |
| Recreate | No (brief) | Fast | None extra | DB schema changes |
| Blue/Green | Yes | Instant (switch) | 2x resources | Critical apps |
| Canary | Yes | Instant (scale down) | Low (% traffic) | High-risk releases |

---

## StatefulSets

### Database StatefulSet Pattern

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: data
spec:
  serviceName: postgres-headless
  replicas: 3
  podManagementPolicy: OrderedReady
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      partition: 0
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          ports:
            - containerPort: 5432
              name: tcp-postgres
          env:
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-secret
                  key: password
            - name: PGDATA
              value: /var/lib/postgresql/data/pgdata
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
          resources:
            requests:
              cpu: 500m
              memory: 1Gi
            limits:
              cpu: "2"
              memory: 4Gi
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: gp3-encrypted
        resources:
          requests:
            storage: 100Gi
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-headless
  namespace: data
spec:
  clusterIP: None
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: tcp-postgres
```

> **Tip**: Use `podManagementPolicy: Parallel` for StatefulSets where ordering does not matter (e.g., Cassandra). Keep `OrderedReady` for primary/replica setups like PostgreSQL.

---

## Jobs and CronJobs

### Database Migration Job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migrate-v1-4-2
  namespace: production
spec:
  backoffLimit: 3
  activeDeadlineSeconds: 600
  ttlSecondsAfterFinished: 86400
  template:
    spec:
      restartPolicy: Never
      serviceAccountName: db-migrator
      containers:
        - name: migrate
          image: registry.example.com/migrator:1.4.2
          command: ["flyway", "migrate"]
          env:
            - name: FLYWAY_URL
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: jdbc-url
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 256Mi
```

### Scheduled Report CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: daily-report
  namespace: analytics
spec:
  schedule: "0 6 * * *"
  timeZone: "America/New_York"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 5
  startingDeadlineSeconds: 300
  jobTemplate:
    spec:
      backoffLimit: 2
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: reporter
              image: registry.example.com/reporter:latest
              command: ["python", "generate_report.py"]
```

---

## RBAC

### RBAC Architecture

```
+------------------+     +----------+     +---------------------------+
| ServiceAccount   |---->| RoleBinding |-->| Role (namespaced)         |
| or User/Group    |     +----------+     | - get pods                |
+------------------+          |           | - list deployments        |
                              |           +---------------------------+
                              |
                         +----+--------+  +---------------------------+
                         | ClusterRole |  | ClusterRoleBinding        |
                         | Binding     |->| (cluster-wide)            |
                         +-------------+  +---------------------------+
```

### Least-Privilege RBAC for a Microservice

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-server
  namespace: production
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789:role/api-server
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: api-server-role
  namespace: production
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "watch"]
    resourceNames: ["api-config"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get"]
    resourceNames: ["db-credentials", "api-keys"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-server-binding
  namespace: production
subjects:
  - kind: ServiceAccount
    name: api-server
    namespace: production
roleRef:
  kind: Role
  name: api-server-role
  apiGroup: rbac.authorization.k8s.io
```

### Common RBAC Patterns

| Pattern | Scope | Use Case |
|---------|-------|----------|
| Namespace admin | Namespace | Team-owned namespace full access |
| Read-only viewer | Cluster | Dashboard, monitoring tools |
| CI deployer | Namespace | CI/CD pipeline deploy access |
| Log reader | Namespace | Log aggregation service |
| Secret manager | Namespace | External secret operator |

---

## Networking

### Service Types

| Type | Access Scope | Use Case | DNS |
|------|-------------|----------|-----|
| ClusterIP | Internal only | Service-to-service | svc.namespace.svc.cluster.local |
| NodePort | External via node IP | Dev/test access | N/A |
| LoadBalancer | External via cloud LB | Production ingress | Cloud DNS |
| ExternalName | CNAME redirect | External service alias | Returns CNAME |
| Headless (ClusterIP: None) | Internal, direct pod | StatefulSets | pod-0.svc.ns.svc.cluster.local |

### Network Policy (Zero-Trust)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-server-netpol
  namespace: production
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: api-server
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app.kubernetes.io/name: ingress-nginx
        - namespaceSelector:
            matchLabels:
              name: monitoring
      ports:
        - protocol: TCP
          port: 8080
        - protocol: TCP
          port: 9090
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: postgres
      ports:
        - protocol: TCP
          port: 5432
    - to:
        - namespaceSelector: {}
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
```

> **Warning**: Always allow DNS egress (port 53 UDP to kube-dns) or pods will fail to resolve any service names.

### Ingress with TLS

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: production
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.example.com
      secretName: api-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-server
                port:
                  number: 8080
```

---

## Storage

### StorageClass Selection

| StorageClass | Provider | IOPS | Use Case |
|-------------|----------|------|----------|
| gp3 | AWS EBS | 3000 base | General workloads |
| io2 | AWS EBS | Up to 64000 | High-perf databases |
| standard | GCE PD | Burstable | Dev/test |
| premium-rwo | GKE | High | Production databases |
| efs-sc | AWS EFS | Shared | Multi-pod read/write |
| local-path | Rancher | Disk-speed | Edge, single-node |

### Dynamic PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
  namespace: production
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp3-encrypted
  resources:
    requests:
      storage: 50Gi
```

### Volume Snapshot for Backup

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: postgres-snap-2026-03-06
  namespace: data
spec:
  volumeSnapshotClassName: csi-aws-vsc
  source:
    persistentVolumeClaimName: data-postgres-0
```

---

## Custom Resource Definitions (CRDs)

### Creating a CRD

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: featureflags.config.example.com
spec:
  group: config.example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required: ["flagName", "enabled"]
              properties:
                flagName:
                  type: string
                enabled:
                  type: boolean
                percentage:
                  type: integer
                  minimum: 0
                  maximum: 100
      additionalPrinterColumns:
        - name: Flag
          type: string
          jsonPath: .spec.flagName
        - name: Enabled
          type: boolean
          jsonPath: .spec.enabled
  scope: Namespaced
  names:
    plural: featureflags
    singular: featureflag
    kind: FeatureFlag
    shortNames: ["ff"]
```

### Using the CRD

```yaml
apiVersion: config.example.com/v1
kind: FeatureFlag
metadata:
  name: dark-mode
  namespace: production
spec:
  flagName: dark-mode
  enabled: true
  percentage: 50
```

---

## Autoscaling

### Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-server-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 3
  maxReplicas: 20
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Percent
          value: 50
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Pods
          value: 1
          periodSeconds: 120
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Pods
      pods:
        metric:
          name: http_requests_per_second
        target:
          type: AverageValue
          averageValue: "1000"
```

---

## Operational Commands Reference

```bash
# Rollout management
kubectl rollout status deployment/api-server -n production
kubectl rollout history deployment/api-server -n production
kubectl rollout undo deployment/api-server -n production --to-revision=3

# Debugging
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production --previous
kubectl exec -it <pod-name> -n production -- /bin/sh
kubectl top pods -n production --sort-by=memory

# Resource inspection
kubectl get events -n production --sort-by='.lastTimestamp'
kubectl get pods -n production -o wide --show-labels
kubectl api-resources --verbs=list --namespaced -o name

# Dry-run validation
kubectl apply -f manifest.yaml --dry-run=server
kubectl diff -f manifest.yaml

# Node management
kubectl cordon node-1
kubectl drain node-1 --grace-period=60 --ignore-daemonsets --delete-emptydir-data
kubectl uncordon node-1
```

---

## Cross-References

- `3-build/helm_chart_development` - Package K8s manifests into reusable charts
- `5-ship/gitops_workflow` - Deploy K8s resources via GitOps
- `3-build/service_mesh_patterns` - Layer service mesh on K8s workloads
- `4-secure/infrastructure_testing` - Test K8s configurations with policy-as-code

---

## EXIT CHECKLIST

- [ ] Correct workload type selected (Deployment vs StatefulSet vs Job)
- [ ] Resource requests and limits set for all containers
- [ ] Readiness, liveness, and startup probes configured
- [ ] Security context applied (non-root, read-only FS, drop capabilities)
- [ ] RBAC follows least-privilege (no cluster-admin for workloads)
- [ ] Network policies restrict ingress and egress
- [ ] Pod topology spread or anti-affinity configured for HA
- [ ] PVCs use appropriate StorageClass for workload needs
- [ ] HPA configured with scale-down stabilization window
- [ ] Rollback procedure validated with `kubectl rollout undo`
- [ ] Labels follow kubernetes.io naming conventions
- [ ] Secrets managed via external secrets operator (not plain K8s secrets)

---

*Skill Version: 1.0 | Created: March 2026*
