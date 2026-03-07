---
name: Green Software Practices
description: Carbon-aware computing, energy-efficient algorithms, cloud region selection, and SCI scoring
---

# Green Software Practices Skill

**Purpose**: Reduce the environmental impact of software systems through carbon-aware computing, energy-efficient architecture choices, optimized cloud region selection, and Software Carbon Intensity (SCI) measurement.

---

## TRIGGER COMMANDS

```text
"Reduce carbon footprint of this application"
"Choose a green cloud region"
"Calculate SCI score"
"Optimize for energy efficiency"
"Using green_software_practices skill: [task]"
```

---

## Green Software Principles

| Principle | Description | Actions |
|-----------|-------------|---------|
| Carbon efficiency | Emit least carbon possible | Measure and reduce |
| Energy efficiency | Use least energy possible | Optimize algorithms, right-size |
| Carbon awareness | Do more when grid is clean | Time-shift, region-shift |
| Hardware efficiency | Use least hardware possible | Extend lifespan, maximize util |
| Measurement | Quantify impact | SCI scoring |

---

## Software Carbon Intensity (SCI)

### Formula

```
SCI = ((E * I) + M) per R

Where:
  E = Energy consumed (kWh)
  I = Carbon intensity of electricity (gCO2eq/kWh)
  M = Embodied carbon of hardware (gCO2eq)
  R = Functional unit (per request, per user, per transaction)
```

### SCI Calculation Example

```python
def calculate_sci(
    energy_kwh: float,
    carbon_intensity_gco2_per_kwh: float,
    embodied_carbon_gco2: float,
    functional_units: int,
) -> float:
    """Calculate Software Carbon Intensity score."""
    operational_carbon = energy_kwh * carbon_intensity_gco2_per_kwh
    total_carbon = operational_carbon + embodied_carbon_gco2
    sci = total_carbon / functional_units
    return sci

# Example: API server handling 1M requests/month
sci = calculate_sci(
    energy_kwh=720,              # 1 kW server * 720 hours/month
    carbon_intensity_gco2_per_kwh=400,  # US average grid
    embodied_carbon_gco2=50000,  # Server lifecycle / months
    functional_units=1_000_000,  # requests per month
)
# SCI = (720 * 400 + 50000) / 1000000 = 0.338 gCO2eq/request
```

### SCI Reduction Strategies

| Strategy | Reduces | Impact |
|----------|---------|--------|
| Move to clean region | I (carbon intensity) | 50-90% |
| Right-size instances | E (energy) | 20-40% |
| Time-shift batch jobs | I (carbon intensity) | 10-30% |
| Algorithm optimization | E (energy) | 10-50% |
| Extend hardware life | M (embodied) | 15-25% |
| Increase utilization | E per R | 20-40% |
| Cache aggressively | E per R | 30-60% |

---

## Carbon-Aware Computing

### Carbon-Aware SDK (Green Software Foundation)

```python
import requests
from datetime import datetime, timedelta

CARBON_AWARE_API = "http://carbon-aware-sdk:8080"

def get_best_region(regions: list[str]) -> dict:
    """Find the region with lowest carbon intensity right now."""
    response = requests.get(
        f"{CARBON_AWARE_API}/emissions/bylocations",
        params={"location": regions},
    )
    emissions = response.json()
    return min(emissions, key=lambda x: x["rating"])

def get_best_time(region: str, window_hours: int = 24) -> dict:
    """Find the lowest-carbon time window in the next N hours."""
    response = requests.get(
        f"{CARBON_AWARE_API}/emissions/forecasts/current",
        params={
            "location": region,
            "windowSize": 60,
            "dataStartAt": datetime.utcnow().isoformat(),
            "dataEndAt": (datetime.utcnow() + timedelta(hours=window_hours)).isoformat(),
        },
    )
    forecast = response.json()[0]
    return forecast["optimalDataPoints"][0]

# Usage
best = get_best_region(["eastus", "westeurope", "northeurope", "canadacentral"])
print(f"Deploy to: {best['location']} ({best['rating']} gCO2eq/kWh)")
```

### Carbon-Aware Job Scheduling

```python
from datetime import datetime, timedelta

def should_run_now(
    carbon_intensity: float,
    threshold: float = 200,
    deadline: datetime = None,
) -> bool:
    """Decide whether to run a deferrable job now or wait for cleaner grid."""
    if deadline and datetime.utcnow() >= deadline - timedelta(hours=1):
        return True  # Must run, deadline approaching
    return carbon_intensity <= threshold

# Kubernetes CronJob with carbon-aware gate
# Run the job, but skip if grid is dirty (unless deadline)
```

```yaml
# carbon-aware-keda-scaler.yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: carbon-aware-workers
spec:
  scaleTargetRef:
    name: batch-workers
  minReplicaCount: 1
  maxReplicaCount: 20
  triggers:
    - type: carbon-aware
      metadata:
        carbonIntensityThreshold: "200"
        preferredRegions: "northeurope,canadacentral"
```

---

## Cloud Region Selection

### Carbon Intensity by Region (Approximate)

| Cloud Region | Grid (gCO2eq/kWh) | Renewable % | Rating |
|-------------|-------------------|-------------|--------|
| AWS eu-north-1 (Stockholm) | 8-15 | 98% | Excellent |
| AWS ca-central-1 (Montreal) | 20-30 | 95% | Excellent |
| GCP europe-north1 (Finland) | 80-100 | 75% | Good |
| Azure North Europe (Ireland) | 300-400 | 40% | Fair |
| AWS us-east-1 (Virginia) | 350-400 | 35% | Fair |
| AWS ap-southeast-1 (Singapore) | 400-500 | 15% | Poor |
| GCP asia-east1 (Taiwan) | 500-600 | 10% | Poor |

> **Tip**: Check real-time data at electricitymaps.com or use WattTime API. Static tables are approximations — grid mix varies by hour and season.

### Multi-Region Carbon Strategy

```
+-------------------+       +--------------------+
| Latency-Sensitive |       | Batch / Deferrable |
| (user-facing)     |       | (ML training, ETL) |
+--------+----------+       +---------+----------+
         |                             |
         v                             v
  Deploy closest to       Deploy to lowest-carbon
  users (with green       region available
  region preference)      (time-shift if possible)
```

---

## Energy-Efficient Architecture

### Compute Right-Sizing

```bash
# AWS: Identify over-provisioned instances
aws compute-optimizer get-ec2-instance-recommendations \
  --filters name=Finding,values=OVER_PROVISIONED \
  --query 'instanceRecommendations[*].{Instance:instanceArn,Current:currentInstanceType,Recommended:recommendationOptions[0].instanceType}'

# Kubernetes: Check actual vs requested resources
kubectl top pods -n production --sort-by=cpu
kubectl top pods -n production --sort-by=memory
```

### Efficient Architecture Patterns

| Pattern | Carbon Savings | Description |
|---------|---------------|-------------|
| Serverless (Lambda/Cloud Run) | 30-70% | Zero idle, pay per invocation |
| ARM instances (Graviton) | 20-40% | Better perf/watt than x86 |
| Spot/preemptible instances | 10-30% | Use spare capacity |
| Auto-scaling to zero | 40-80% | No idle resources |
| Edge computing | 10-30% | Reduce data transfer |
| Static site generation | 50-90% | Pre-render, serve from CDN |

### ARM Migration Checklist

```bash
# Check if images support ARM
docker manifest inspect --verbose nginx:latest | grep architecture

# Build multi-arch images
docker buildx build --platform linux/amd64,linux/arm64 \
  -t registry/app:latest --push .

# AWS Graviton instances
# m7g (general), c7g (compute), r7g (memory)
# 20-40% better price-performance vs x86
```

---

## Algorithmic Efficiency

### Big-O Impact on Energy

| Complexity | 1K items | 1M items | Energy Impact |
|-----------|----------|----------|---------------|
| O(1) | 1 op | 1 op | Minimal |
| O(log n) | 10 ops | 20 ops | Low |
| O(n) | 1K ops | 1M ops | Moderate |
| O(n log n) | 10K ops | 20M ops | High |
| O(n^2) | 1M ops | 1T ops | Very high |

### Optimization Techniques

```python
# BAD: O(n^2) nested lookup
for order in orders:
    customer = next(c for c in customers if c["id"] == order["customer_id"])

# GOOD: O(n) with hash map
customer_map = {c["id"]: c for c in customers}
for order in orders:
    customer = customer_map[order["customer_id"]]

# BAD: Loading full dataset into memory
df = spark.read.parquet("s3://lake/events/")
df.filter(df.date == "2026-03-06")

# GOOD: Partition pruning (reads only relevant partition)
df = spark.read.parquet("s3://lake/events/date=2026-03-06/")
```

### Database Query Optimization

```sql
-- BAD: Full table scan
SELECT * FROM orders WHERE YEAR(created_at) = 2026;

-- GOOD: Index-friendly predicate
SELECT * FROM orders
WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01';

-- BAD: SELECT * with unused columns
SELECT * FROM orders JOIN customers ON orders.customer_id = customers.id;

-- GOOD: Only needed columns
SELECT o.id, o.total, c.email
FROM orders o JOIN customers c ON o.customer_id = c.id;
```

---

## Measurement and Monitoring

### Cloud Carbon Footprint Tool

```bash
# Install Cloud Carbon Footprint (CCF)
git clone https://github.com/cloud-carbon-footprint/cloud-carbon-footprint.git
cd cloud-carbon-footprint

# Configure for AWS
cp packages/api/.env.template packages/api/.env
# Edit .env with AWS credentials

# Run dashboard
yarn start
```

### Prometheus Carbon Metrics

```yaml
# Custom metrics for carbon tracking
- name: app_energy_consumption_kwh
  help: Estimated energy consumption in kWh
  type: gauge

- name: app_carbon_emissions_gco2
  help: Estimated carbon emissions in gCO2eq
  type: gauge

- name: app_sci_score
  help: Software Carbon Intensity per functional unit
  type: gauge
```

### Carbon Budget in CI

```yaml
# .github/workflows/carbon-check.yml
name: Carbon Budget
on: [pull_request]

jobs:
  carbon:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run carbon analysis
        run: |
          # Compare resource requests before/after
          BEFORE=$(git diff origin/main -- k8s/ | grep "^-.*cpu:" | awk '{sum += $2} END {print sum}')
          AFTER=$(git diff origin/main -- k8s/ | grep "^+.*cpu:" | awk '{sum += $2} END {print sum}')
          if [ "$AFTER" -gt "$((BEFORE * 120 / 100))" ]; then
            echo "::warning::Resource requests increased by more than 20%"
          fi
```

---

## Sustainability Checklist by Layer

| Layer | Actions |
|-------|---------|
| **Infrastructure** | Green region, ARM instances, right-size, auto-scale to zero |
| **Platform** | Serverless where possible, spot instances for batch |
| **Application** | Efficient algorithms, caching, pagination, lazy loading |
| **Data** | Partition pruning, columnar formats, data lifecycle policies |
| **Network** | CDN, compression, reduce payload size, HTTP/2 |
| **CI/CD** | Cache build artifacts, affected-only builds, efficient runners |

---

## Cross-References

- `3-build/kubernetes_operations` - Right-size K8s workloads
- `3-build/caching_strategies` - Reduce compute via caching
- `3-build/spark_data_processing` - Optimize Spark job efficiency
- `3-build/monorepo_tooling` - Affected-only builds reduce CI energy

---

## EXIT CHECKLIST

- [ ] SCI score calculated for primary workloads
- [ ] Cloud regions evaluated for carbon intensity
- [ ] Compute instances right-sized based on actual utilization
- [ ] ARM/Graviton instances used where supported
- [ ] Batch jobs time-shifted to low-carbon periods (or deadline-aware)
- [ ] Auto-scaling configured with scale-to-zero for non-critical workloads
- [ ] Database queries optimized (index usage, column selection, partition pruning)
- [ ] Caching in place to reduce redundant computation
- [ ] Carbon monitoring dashboard accessible
- [ ] Carbon budget check integrated into CI pipeline
- [ ] Data retention policies prevent unbounded storage growth
- [ ] Team educated on green software principles

---

*Skill Version: 1.0 | Created: March 2026*
