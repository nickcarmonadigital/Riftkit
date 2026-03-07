---
name: Service Mesh Patterns
description: Service mesh with Istio and Linkerd covering traffic management, mTLS, observability, and circuit breaking
---

# Service Mesh Patterns Skill

**Purpose**: Implement service mesh capabilities for microservice architectures using Istio or Linkerd, covering traffic management, mutual TLS, observability, circuit breaking, and progressive delivery.

---

## TRIGGER COMMANDS

```text
"Set up a service mesh"
"Configure Istio traffic management"
"Enable mTLS between services"
"Implement circuit breaking"
"Using service_mesh_patterns skill: [task]"
```

---

## Tool Comparison

| Feature | Istio | Linkerd |
|---------|-------|---------|
| Complexity | High (many CRDs) | Low (minimal config) |
| Resource overhead | ~100MB per sidecar | ~20MB per sidecar |
| Control plane | istiod (single binary) | controller, proxy-injector, etc. |
| Data plane proxy | Envoy | linkerd2-proxy (Rust) |
| mTLS | Automatic or manual | Automatic (on by default) |
| Traffic splitting | VirtualService | TrafficSplit (SMI) |
| Multi-cluster | Built-in | Built-in |
| Protocol support | HTTP, gRPC, TCP, WebSocket | HTTP, gRPC, TCP |
| Authorization policy | Rich L7 rules | Server/ServerAuthorization |
| Learning curve | Steep | Moderate |
| Best for | Large enterprise, complex routing | Simplicity, low overhead |

---

## Istio Setup

### Installation

```bash
# Install Istio with production profile
istioctl install --set profile=default \
  --set values.pilot.resources.requests.cpu=500m \
  --set values.pilot.resources.requests.memory=2Gi \
  --set meshConfig.enableTracing=true \
  --set meshConfig.defaultConfig.tracing.zipkin.address=jaeger:9411 \
  --set meshConfig.accessLogFile=/dev/stdout

# Enable sidecar injection for namespace
kubectl label namespace production istio-injection=enabled

# Verify installation
istioctl verify-install
istioctl analyze -n production
```

### Architecture

```
                    +-------------------+
                    |     istiod        |
                    | (Pilot, Citadel,  |
                    |  Galley)          |
                    +--------+----------+
                             |  xDS API
              +--------------+--------------+
              |                             |
    +---------+----------+      +-----------+---------+
    | Pod A              |      | Pod B               |
    | +------+ +-------+ |      | +------+ +--------+ |
    | | App  | | Envoy | |<---->| | Envoy| | App    | |
    | |      | | Proxy | | mTLS | | Proxy| |        | |
    | +------+ +-------+ |      | +------+ +--------+ |
    +--------------------+      +---------------------+
```

---

## Traffic Management

### VirtualService (Routing Rules)

```yaml
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: api-server
  namespace: production
spec:
  hosts:
    - api-server
  http:
    # Canary: 90/10 traffic split
    - match:
        - headers:
            x-canary:
              exact: "true"
      route:
        - destination:
            host: api-server
            subset: canary
    - route:
        - destination:
            host: api-server
            subset: stable
          weight: 90
        - destination:
            host: api-server
            subset: canary
          weight: 10
      timeout: 10s
      retries:
        attempts: 3
        perTryTimeout: 3s
        retryOn: 5xx,reset,connect-failure
```

### DestinationRule (Subsets and Policies)

```yaml
apiVersion: networking.istio.io/v1
kind: DestinationRule
metadata:
  name: api-server
  namespace: production
spec:
  host: api-server
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
        connectTimeout: 5s
      http:
        h2UpgradePolicy: DEFAULT
        maxRequestsPerConnection: 100
    loadBalancer:
      simple: LEAST_REQUEST
    outlierDetection:
      consecutive5xxErrors: 3
      interval: 30s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
  subsets:
    - name: stable
      labels:
        version: v1
    - name: canary
      labels:
        version: v2
```

### Circuit Breaking

```yaml
apiVersion: networking.istio.io/v1
kind: DestinationRule
metadata:
  name: payment-service
  namespace: production
spec:
  host: payment-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 50
      http:
        maxRequestsPerConnection: 10
        maxRetries: 3
        h2UpgradePolicy: DEFAULT
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 10s
      baseEjectionTime: 60s
      maxEjectionPercent: 30
      minHealthPercent: 70
```

### Circuit Breaker States

```
     +--------+       consecutive failures > threshold
     | CLOSED |  ─────────────────────────────────────>  +------+
     | (normal)|                                         | OPEN |
     +--------+  <─────────────────────────────────────  |(fail)|
         ^            timer expires, single request       +------+
         |                                                   |
         |            +----------+                           |
         +────────────| HALF-OPEN|<──────────────────────────+
          test passes | (probe)  |  test fails → back to OPEN
                      +----------+
```

---

## Mutual TLS (mTLS)

### Strict mTLS (Production)

```yaml
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: default
  namespace: production
spec:
  mtls:
    mode: STRICT
```

### Permissive mTLS (Migration Period)

```yaml
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: default
  namespace: production
spec:
  mtls:
    mode: PERMISSIVE
  selector:
    matchLabels:
      app: legacy-service
```

### mTLS Migration Path

| Phase | Mode | Duration | Description |
|-------|------|----------|-------------|
| 1. Baseline | PERMISSIVE | 1-2 weeks | Enable mesh, observe traffic |
| 2. Monitor | PERMISSIVE | 1 week | Verify all services have sidecars |
| 3. Enforce | STRICT | Permanent | Reject plaintext connections |

> **Warning**: Before switching to STRICT mode, verify all services have sidecar proxies injected. Non-meshed services will be rejected.

---

## Authorization Policy

### Deny-by-Default + Allow List

```yaml
# Deny all traffic by default
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: deny-all
  namespace: production
spec:
  {}
---
# Allow specific service-to-service communication
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: allow-api-to-db
  namespace: production
spec:
  selector:
    matchLabels:
      app: postgres
  action: ALLOW
  rules:
    - from:
        - source:
            principals: ["cluster.local/ns/production/sa/api-server"]
      to:
        - operation:
            ports: ["5432"]
---
# Allow ingress gateway to API
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: allow-ingress-to-api
  namespace: production
spec:
  selector:
    matchLabels:
      app: api-server
  action: ALLOW
  rules:
    - from:
        - source:
            namespaces: ["istio-system"]
      to:
        - operation:
            methods: ["GET", "POST", "PUT", "DELETE"]
            paths: ["/api/*"]
```

---

## Observability

### Distributed Tracing (Jaeger)

```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    enableTracing: true
    defaultConfig:
      tracing:
        sampling: 10.0    # 10% sampling in production
        zipkin:
          address: jaeger-collector.observability:9411
```

### Kiali Service Graph

```bash
# Install Kiali for service mesh visualization
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/kiali.yaml

# Access dashboard
istioctl dashboard kiali
```

### Prometheus Metrics (Auto-Generated)

| Metric | Description |
|--------|-------------|
| istio_requests_total | Request count by source, dest, response code |
| istio_request_duration_milliseconds | Request latency histogram |
| istio_tcp_connections_opened_total | TCP connections opened |
| istio_tcp_connections_closed_total | TCP connections closed |
| istio_request_bytes | Request body size |
| istio_response_bytes | Response body size |

### Grafana Dashboard Queries

```promql
# Request success rate (non-5xx)
sum(rate(istio_requests_total{reporter="destination",
  destination_service="api-server.production.svc.cluster.local",
  response_code!~"5.."}[5m]))
/
sum(rate(istio_requests_total{reporter="destination",
  destination_service="api-server.production.svc.cluster.local"}[5m]))

# P99 latency
histogram_quantile(0.99,
  sum(rate(istio_request_duration_milliseconds_bucket{reporter="destination",
    destination_service="api-server.production.svc.cluster.local"}[5m]))
  by (le))
```

---

## Linkerd Setup

### Installation

```bash
# Install CLI
curl -sL https://run.linkerd.io/install | sh

# Pre-check
linkerd check --pre

# Install CRDs and control plane
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -

# Verify
linkerd check

# Inject sidecar into namespace
kubectl annotate namespace production linkerd.io/inject=enabled

# Install viz extension (dashboard)
linkerd viz install | kubectl apply -f -
```

### Traffic Split (Linkerd)

```yaml
apiVersion: split.smi-spec.io/v1alpha4
kind: TrafficSplit
metadata:
  name: api-server
  namespace: production
spec:
  service: api-server
  backends:
    - service: api-server-stable
      weight: 900
    - service: api-server-canary
      weight: 100
```

### Service Profile (Retries and Timeouts)

```yaml
apiVersion: linkerd.io/v1alpha2
kind: ServiceProfile
metadata:
  name: api-server.production.svc.cluster.local
  namespace: production
spec:
  routes:
    - name: GET /api/orders
      condition:
        method: GET
        pathRegex: /api/orders
      responseClasses:
        - condition:
            status:
              min: 500
              max: 599
          isFailure: true
      timeout: 5s
      isRetryable: true
    - name: POST /api/orders
      condition:
        method: POST
        pathRegex: /api/orders
      timeout: 10s
      isRetryable: false
  retryBudget:
    retryRatio: 0.2
    minRetriesPerSecond: 10
    ttl: 30s
```

---

## Common Patterns

### Fault Injection (Testing)

```yaml
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: payment-service-fault
  namespace: staging
spec:
  hosts:
    - payment-service
  http:
    - fault:
        delay:
          percentage:
            value: 10
          fixedDelay: 5s
        abort:
          percentage:
            value: 5
          httpStatus: 503
      route:
        - destination:
            host: payment-service
```

### Request Mirroring (Shadow Traffic)

```yaml
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: api-server-mirror
spec:
  hosts:
    - api-server
  http:
    - route:
        - destination:
            host: api-server
            subset: stable
      mirror:
        host: api-server
        subset: canary
      mirrorPercentage:
        value: 20
```

---

## Cross-References

- `3-build/kubernetes_operations` - K8s workloads that service mesh wraps
- `3-build/api_gateway_patterns` - North-south traffic (gateway) vs east-west (mesh)
- `4-secure/chaos_engineering` - Fault injection via service mesh
- `3-build/log_aggregation_pipeline` - Collect mesh access logs

---

## EXIT CHECKLIST

- [ ] Service mesh installed and verified (`istioctl analyze` or `linkerd check`)
- [ ] Sidecar injection enabled for target namespaces
- [ ] mTLS mode set (PERMISSIVE during migration, STRICT for production)
- [ ] Authorization policies follow deny-by-default pattern
- [ ] Traffic routing rules defined (VirtualService or TrafficSplit)
- [ ] Circuit breaking configured for critical dependencies
- [ ] Retry and timeout policies set per route
- [ ] Distributed tracing enabled with appropriate sampling rate
- [ ] Service mesh dashboards accessible (Kiali, Grafana, Linkerd viz)
- [ ] Fault injection tested in staging environment
- [ ] Resource overhead measured and within budget
- [ ] Non-meshed services identified and migration planned

---

*Skill Version: 1.0 | Created: March 2026*
