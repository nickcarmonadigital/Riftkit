---
name: Infrastructure Audit
description: Map networking, DNS, load balancers, CDN, caches, databases, and deployment topology with cost analysis.
---

# Infrastructure Audit

## TRIGGER COMMANDS
- "Audit the infrastructure"
- "Map the deployment topology"
- "What's our infrastructure look like"
- "Document the server setup"
- "Where is everything deployed"
- "Inventory the infrastructure"
- "What are we running and where"

## When to Use
Use this skill when taking over operational responsibility for a system, when infrastructure costs are growing unexpectedly, when planning a migration to a new cloud provider or region, or when a security audit requires a complete infrastructure inventory. This provides a comprehensive map of everything that is running, how it connects, and what it costs.

## The Process

### 1. Deployment Topology
- Map all environments: development, staging, QA, production, disaster recovery
- For each environment, document:
  - Cloud provider and region(s)
  - How it differs from production (scaled down? different config? shared resources?)
  - Who has access and at what permission level
- Document the code promotion path: how does code flow from dev to staging to production?
- Identify environment drift: are staging and production actually configured the same way?
- Map multi-region or multi-cloud deployments if they exist
- Document any on-premises infrastructure and how it connects to cloud resources

### 2. Network Architecture
- Document DNS configuration: registrar, nameservers, critical DNS records, TTL values
- Map load balancer setup: type (L4/L7), algorithm (round-robin, least connections), health check configuration
- Document CDN configuration: provider, cache rules, origin shield, invalidation process
- Map firewall rules and security groups: what ports are open, to whom, and why
- Document VPC/subnet layout: public vs private subnets, NAT gateways, VPN connections
- Identify service mesh or API gateway if present: routing rules, rate limiting, authentication
- Map internal service communication: direct calls, service discovery, message queues
- Document any static IP addresses, elastic IPs, or reserved addresses and what depends on them

### 3. Compute Resources
- Inventory all servers, containers, and serverless functions:
  - Type and size (instance type, CPU, memory)
  - Count (current instances, min/max for auto-scaling)
  - Utilization (average and peak CPU, memory, disk)
- Document auto-scaling configuration: scaling triggers, cooldown periods, scaling limits
- Identify over-provisioned resources (paying for capacity that is never used)
- Identify under-provisioned resources (running near capacity, risk of failure under load)
- Map container orchestration: Kubernetes clusters, ECS services, Docker Compose stacks
- Document scheduled compute: cron jobs, batch processing, scheduled Lambda functions

### 4. Data Layer
- Inventory all databases:
  - Type (PostgreSQL, MySQL, MongoDB, DynamoDB, etc.) and version
  - Size (storage used, row/document count for critical tables)
  - Replication configuration (primary-replica, multi-master, cross-region)
  - Backup schedule and retention policy, last verified restore
- Document cache layers: Redis/Memcached configuration, cluster mode, eviction policy, hit rate
- Map message queues: type (Kafka, RabbitMQ, SQS), topic/queue inventory, retention, consumer groups
- Identify data warehouses and analytics databases if present
- Document object storage: S3 buckets, lifecycle policies, access controls
- Check for orphaned data stores: databases or buckets that nothing uses anymore

### 5. CI/CD Pipeline
- Document the build system: CI platform (GitHub Actions, Jenkins, GitLab CI, CircleCI), build configuration
- Map the deployment mechanism: how code gets from a merged PR to running in production
  - Container image builds and registry
  - Infrastructure as Code (Terraform, CloudFormation, Pulumi)
  - Deployment strategy (rolling, blue-green, canary)
- Document rollback capability: how to revert a bad deployment, time to rollback, is it automated?
- Map environment promotion: how artifacts move from staging to production
- Identify manual steps in the deployment process (any step that requires a human)
- Check for deployment frequency metrics: how often does the team deploy?

### 6. Monitoring & Alerting
- Inventory monitoring tools: APM (Datadog, New Relic), logging (ELK, CloudWatch), metrics (Prometheus, Grafana)
- Document what is monitored: which metrics, which logs, which traces
- Review alert configuration: thresholds, notification channels, escalation rules
- Check for alert fatigue: how many alerts fire per day? What percentage are actionable?
- Document on-call rotation: who is on call, how are they contacted, what is the escalation path
- Review incident response process: how are incidents declared, managed, and resolved
- Identify monitoring gaps: what should be monitored but is not?
- Check for SLO/SLA definitions and whether they are tracked

### 7. Security Posture
- Review TLS configuration: certificate management (auto-renewal?), minimum TLS version, cipher suites
- Document secret management: where are secrets stored (Vault, AWS Secrets Manager, .env files), rotation policy
- Audit IAM/RBAC: who has access to what, are permissions least-privilege, are there orphaned accounts
- Check network segmentation: are databases accessible only from application servers? Are admin interfaces restricted?
- Review logging for security events: authentication failures, permission denials, data access patterns
- Document compliance requirements: SOC2, HIPAA, GDPR, PCI-DSS and their infrastructure implications
- Check for encryption at rest and in transit for all data stores
- Review vulnerability scanning: are infrastructure components scanned regularly? Are findings acted on?

### 8. Cost Analysis
- Break down monthly infrastructure spend by service category:
  - Compute (servers, containers, functions)
  - Data (databases, caches, storage)
  - Network (bandwidth, load balancers, CDN, DNS)
  - Monitoring and tooling
  - Licenses and SaaS subscriptions
- Identify the top 5 cost drivers and whether they are proportional to business value
- Find optimization opportunities:
  - Reserved instances or savings plans for predictable workloads
  - Right-sizing over-provisioned resources
  - Spot/preemptible instances for fault-tolerant workloads
  - Storage tiering for infrequently accessed data
  - Eliminating orphaned resources (unused EBS volumes, idle load balancers)
- Calculate cost per unit of business value (cost per user, cost per transaction, cost per API call)
- Project costs at 2x and 5x current scale

### 9. Disaster Recovery
- Document RTO (Recovery Time Objective) and RPO (Recovery Point Objective) for each critical system
- Verify backup procedures:
  - Are backups automated?
  - Are backups stored in a different region/account?
  - When was the last successful restore test?
- Review failover mechanisms: automatic vs manual, tested vs untested
- Document the disaster recovery plan: step-by-step procedures for each failure scenario
- Check for chaos engineering practices: does the team regularly test failure scenarios?
- Identify dependencies on single providers or regions that could cause total outage
- Verify that disaster recovery documentation is accessible during an actual disaster (not hosted on the infrastructure that is down)

## Checklist
- [ ] All environments mapped with their configurations and access controls
- [ ] Network architecture documented including DNS, load balancers, CDN, and firewall rules
- [ ] All compute resources inventoried with sizing and utilization data
- [ ] All databases, caches, queues, and storage documented with replication and backup details
- [ ] CI/CD pipeline mapped end-to-end with rollback capability verified
- [ ] Monitoring and alerting inventory completed with gap analysis
- [ ] Security posture reviewed covering TLS, secrets, IAM, and network segmentation
- [ ] Monthly cost breakdown produced with optimization opportunities identified
- [ ] Disaster recovery plan documented with RTO/RPO targets and last test date
- [ ] Infrastructure audit report is comprehensive enough to onboard a new DevOps engineer
