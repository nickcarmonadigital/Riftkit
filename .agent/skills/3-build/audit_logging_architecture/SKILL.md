---
name: Audit Logging Architecture
description: Design and implement compliance-grade immutable audit logging with tamper detection, structured event schemas, and auditor-ready evidence packages for SOC2, HIPAA, and PCI-DSS
---

# Audit Logging Architecture Skill

**Purpose**: Design and implement an audit logging system that satisfies regulatory requirements for SOC 2, HIPAA, PCI-DSS, and similar frameworks. Audit logs are fundamentally different from application logs -- they are legal evidence of system activity, must be immutable, tamper-evident, and retained for years. This skill covers event schema design, immutability patterns, tamper detection, framework-specific implementations (NestJS, Django), storage architecture, access controls, retention policies, and auditor-ready export.

> [!IMPORTANT]
> **Audit logs are not application logs.** Application logs help you debug. Audit logs prove to regulators and auditors that your controls are working. They must be append-only, tamper-evident, and independently secured. Mixing them is a compliance failure.

## TRIGGER COMMANDS

```text
"Design audit logging for [SOC2/HIPAA/PCI]"
"Implement compliance audit trail"
"Build immutable audit log"
"Set up tamper-evident logging"
"Create audit event schema"
"Using audit_logging_architecture skill: design audit system for [project]"
```

## When to Use
- Implementing logging controls required by SOC 2 (CC7.x), HIPAA (164.312(b)), or PCI-DSS (Req 10)
- Building audit trails for sensitive resource access (PHI, PII, financial data)
- Designing tamper-evident log storage for regulatory evidence
- Preparing for compliance audits that require log evidence packages
- Any system where "who did what, when, and what happened" must be provable

---

## PART 1: AUDIT LOG vs APPLICATION LOG

Understanding the distinction is critical. Conflating them leads to compliance failures.

| Attribute | Application Log | Audit Log |
|-----------|----------------|-----------|
| **Purpose** | Debugging, monitoring, performance | Legal evidence, compliance proof |
| **Audience** | Developers, SRE | Auditors, compliance officers, legal |
| **Mutability** | Mutable (rotate, delete, compress) | Immutable (append-only, never delete) |
| **Retention** | Days to weeks | 1-7 years (regulation-dependent) |
| **Storage** | ELK, CloudWatch, Datadog | WORM storage, separate database, S3 Object Lock |
| **Access** | Engineering team | Restricted (read: auditors + security; write: system only) |
| **Schema** | Unstructured or semi-structured | Strictly structured, validated |
| **Tampering** | Not a concern | Must be detectable (hash chains, signatures) |
| **Content** | Errors, traces, metrics, debug info | Who, what, when, where, outcome, on which resource |

**Rule**: Audit logs MUST be stored in a separate system from application logs with independent access controls.

---

## PART 2: WHAT TO LOG

### Mandatory Audit Events

Every audit event must answer: **Who** did **what** to **which resource**, **when**, from **where**, and **what was the outcome**?

**Events to capture:**

| Category | Events | Regulation |
|----------|--------|-----------|
| Authentication | Login success/failure, logout, MFA challenge, password change, session timeout | All (SOC2, HIPAA, PCI) |
| Authorization | Permission granted/denied, role change, privilege escalation | All |
| Data Access | Read/view of sensitive records (PHI, PII, PAN) | HIPAA 164.312(b), PCI 10.2 |
| Data Modification | Create, update, delete of sensitive records | All |
| Data Export | Download, report generation, API bulk retrieval of sensitive data | HIPAA, GDPR |
| Admin Actions | User create/disable, config change, system setting modification | SOC2 CC6.1, PCI 10.2.2 |
| Security Events | Firewall rule change, encryption key rotation, certificate renewal | PCI 10.2, SOC2 CC7.2 |
| System Events | Application start/stop, deployment, backup, restore | SOC2 CC7.1 |
| Consent | Consent given, withdrawn, preference changed | GDPR Art. 7 |
| Audit Log Access | Who viewed/exported audit logs | All (meta-auditing) |

### What NOT to Put in Audit Logs

- Passwords, tokens, secrets, or API keys (even hashed)
- Full credit card numbers (mask to last 4)
- Unmasked SSNs (mask to last 4)
- Raw PHI beyond what's needed to identify the record accessed
- Application debug information

---

## PART 3: STRUCTURED AUDIT EVENT SCHEMA

### JSON Event Schema

```json
{
  "event_id": "uuid-v7-sortable",
  "event_type": "data.read",
  "timestamp": "2026-03-05T14:30:00.000Z",
  "actor": {
    "user_id": "usr_abc123",
    "email": "nurse@hospital.org",
    "role": "clinical_staff",
    "session_id": "sess_xyz789",
    "ip_address": "10.0.1.45",
    "user_agent": "Mozilla/5.0..."
  },
  "resource": {
    "type": "patient_record",
    "id": "pat_456def",
    "name": "Patient Chart #456",
    "classification": "L4_restricted"
  },
  "action": {
    "operation": "READ",
    "fields_accessed": ["diagnosis", "medications", "lab_results"],
    "query_context": "chart_review"
  },
  "outcome": {
    "status": "SUCCESS",
    "reason": null
  },
  "context": {
    "service": "patient-portal",
    "version": "2.4.1",
    "environment": "production",
    "correlation_id": "req_abc123",
    "regulation": ["HIPAA"]
  },
  "integrity": {
    "sequence_number": 1048576,
    "previous_hash": "sha256:abc123...",
    "event_hash": "sha256:def456..."
  }
}
```

### Required Fields (Non-Negotiable)

| Field | Type | Description |
|-------|------|-------------|
| `event_id` | UUIDv7 | Globally unique, time-sortable identifier |
| `event_type` | enum | Dot-notation category (auth.login, data.read, admin.config_change) |
| `timestamp` | ISO 8601 | UTC, millisecond precision, from trusted time source |
| `actor.user_id` | string | Authenticated user performing the action |
| `actor.ip_address` | string | Source IP of the request |
| `resource.type` | string | Type of resource acted upon |
| `resource.id` | string | Unique identifier of the resource |
| `action.operation` | enum | CREATE, READ, UPDATE, DELETE, LOGIN, LOGOUT, EXPORT, ADMIN |
| `outcome.status` | enum | SUCCESS, FAILURE, DENIED, ERROR |
| `integrity.event_hash` | string | SHA-256 hash of the event for tamper detection |

---

## PART 4: IMMUTABILITY PATTERNS

### Pattern 1: Append-Only Database Table

```sql
-- PostgreSQL: Append-only audit log with no UPDATE/DELETE
CREATE TABLE audit_log (
    event_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type      VARCHAR(100) NOT NULL,
    timestamp       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    actor_user_id   VARCHAR(100) NOT NULL,
    actor_ip        INET,
    resource_type   VARCHAR(100) NOT NULL,
    resource_id     VARCHAR(255) NOT NULL,
    operation       VARCHAR(20) NOT NULL,
    outcome         VARCHAR(20) NOT NULL,
    event_data      JSONB NOT NULL,
    previous_hash   VARCHAR(64),
    event_hash      VARCHAR(64) NOT NULL
);

-- Prevent updates and deletes at the database level
CREATE RULE audit_no_update AS ON UPDATE TO audit_log DO INSTEAD NOTHING;
CREATE RULE audit_no_delete AS ON DELETE TO audit_log DO INSTEAD NOTHING;

-- Partition by month for performance and retention management
CREATE TABLE audit_log_2026_03 PARTITION OF audit_log
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');

-- Index for common query patterns
CREATE INDEX idx_audit_actor ON audit_log (actor_user_id, timestamp DESC);
CREATE INDEX idx_audit_resource ON audit_log (resource_type, resource_id, timestamp DESC);
CREATE INDEX idx_audit_type ON audit_log (event_type, timestamp DESC);
```

**Database user permissions:**
```sql
-- Application service account: INSERT only
GRANT INSERT ON audit_log TO audit_writer;
-- Audit reader: SELECT only
GRANT SELECT ON audit_log TO audit_reader;
-- NO user gets UPDATE or DELETE
```

### Pattern 2: S3 Object Lock (WORM Storage)

```python
# S3 with Object Lock for regulatory WORM compliance
import boto3, json, hashlib
from datetime import datetime, timedelta

s3 = boto3.client('s3')

def write_audit_batch(events: list[dict], bucket: str = "audit-logs-worm"):
    date_prefix = datetime.utcnow().strftime("%Y/%m/%d/%H")
    batch_id = events[0]["event_id"]
    key = f"{date_prefix}/{batch_id}.jsonl"

    body = "\n".join(json.dumps(e, sort_keys=True) for e in events)
    content_hash = hashlib.sha256(body.encode()).hexdigest()

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=body.encode(),
        ContentType="application/x-ndjson",
        ObjectLockMode="GOVERNANCE",        # or COMPLIANCE for stricter
        ObjectLockRetainUntilDate=datetime.utcnow() + timedelta(days=2555),  # 7 years
        Metadata={"content-hash": content_hash},
    )
```

**S3 Bucket Configuration:**
- Object Lock enabled at bucket creation (cannot be added later)
- Versioning enabled (required for Object Lock)
- Default retention: GOVERNANCE or COMPLIANCE mode
- Lifecycle rules: transition to Glacier after 90 days, Deep Archive after 1 year

### Pattern 3: Hash Chain (Tamper Detection)

```typescript
import { createHash } from 'crypto';

interface AuditEvent {
  event_id: string;
  timestamp: string;
  actor: { user_id: string; ip_address: string };
  resource: { type: string; id: string };
  action: { operation: string };
  outcome: { status: string };
  event_data: Record<string, unknown>;
}

interface SignedAuditEvent extends AuditEvent {
  integrity: {
    sequence_number: number;
    previous_hash: string;
    event_hash: string;
  };
}

function computeEventHash(event: AuditEvent, previousHash: string): string {
  const canonical = JSON.stringify({
    event_id: event.event_id,
    timestamp: event.timestamp,
    actor: event.actor,
    resource: event.resource,
    action: event.action,
    outcome: event.outcome,
    previous_hash: previousHash,
  });
  return createHash('sha256').update(canonical).digest('hex');
}

function verifyChain(events: SignedAuditEvent[]): { valid: boolean; brokenAt?: number } {
  for (let i = 0; i < events.length; i++) {
    const expected = computeEventHash(events[i], events[i].integrity.previous_hash);
    if (expected !== events[i].integrity.event_hash) {
      return { valid: false, brokenAt: events[i].integrity.sequence_number };
    }
    if (i > 0 && events[i].integrity.previous_hash !== events[i - 1].integrity.event_hash) {
      return { valid: false, brokenAt: events[i].integrity.sequence_number };
    }
  }
  return { valid: true };
}
```

---

## PART 5: NESTJS IMPLEMENTATION

### Audit Interceptor

```typescript
// src/audit/audit.interceptor.ts
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable, tap } from 'rxjs';
import { AuditService } from './audit.service';
import { AUDIT_METADATA_KEY } from './audit.decorator';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(
    private readonly auditService: AuditService,
    private readonly reflector: Reflector,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const auditMeta = this.reflector.get(AUDIT_METADATA_KEY, context.getHandler());
    if (!auditMeta) return next.handle();

    const req = context.switchToHttp().getRequest();
    const startTime = Date.now();

    return next.handle().pipe(
      tap({
        next: () => {
          this.auditService.log({
            event_type: auditMeta.eventType,
            actor: {
              user_id: req.user?.sub,
              email: req.user?.email,
              ip_address: req.ip,
              user_agent: req.headers['user-agent'],
            },
            resource: {
              type: auditMeta.resourceType,
              id: req.params[auditMeta.resourceIdParam] || req.params.id,
            },
            action: { operation: auditMeta.operation },
            outcome: { status: 'SUCCESS' },
          });
        },
        error: (err) => {
          this.auditService.log({
            event_type: auditMeta.eventType,
            actor: {
              user_id: req.user?.sub,
              email: req.user?.email,
              ip_address: req.ip,
              user_agent: req.headers['user-agent'],
            },
            resource: {
              type: auditMeta.resourceType,
              id: req.params[auditMeta.resourceIdParam] || req.params.id,
            },
            action: { operation: auditMeta.operation },
            outcome: { status: 'FAILURE', reason: err.message },
          });
        },
      }),
    );
  }
}
```

### Audit Decorator

```typescript
// src/audit/audit.decorator.ts
import { SetMetadata } from '@nestjs/common';

export const AUDIT_METADATA_KEY = 'audit_metadata';

export interface AuditMetadata {
  eventType: string;
  resourceType: string;
  operation: 'CREATE' | 'READ' | 'UPDATE' | 'DELETE' | 'EXPORT' | 'ADMIN';
  resourceIdParam?: string;
}

export const Audited = (meta: AuditMetadata) => SetMetadata(AUDIT_METADATA_KEY, meta);
```

### Usage in Controller

```typescript
// src/patients/patients.controller.ts
@Controller('patients')
@UseGuards(JwtAuthGuard)
@UseInterceptors(AuditInterceptor)
export class PatientsController {
  @Get(':id')
  @Audited({
    eventType: 'data.read',
    resourceType: 'patient_record',
    operation: 'READ',
    resourceIdParam: 'id',
  })
  findOne(@Param('id') id: string) {
    return this.patientsService.findOne(id);
  }

  @Patch(':id')
  @Audited({
    eventType: 'data.update',
    resourceType: 'patient_record',
    operation: 'UPDATE',
    resourceIdParam: 'id',
  })
  update(@Param('id') id: string, @Body() dto: UpdatePatientDto) {
    return this.patientsService.update(id, dto);
  }

  @Delete(':id')
  @Audited({
    eventType: 'data.delete',
    resourceType: 'patient_record',
    operation: 'DELETE',
    resourceIdParam: 'id',
  })
  remove(@Param('id') id: string) {
    return this.patientsService.remove(id);
  }
}
```

---

## PART 6: DJANGO IMPLEMENTATION

### Audit Middleware

```python
# audit/middleware.py
import json, uuid, hashlib
from datetime import datetime, timezone
from django.conf import settings
from .models import AuditLog

AUDITED_METHODS = {'POST', 'PUT', 'PATCH', 'DELETE'}

class AuditMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        if request.method in AUDITED_METHODS and hasattr(request, 'user') and request.user.is_authenticated:
            AuditLog.objects.create(
                event_id=uuid.uuid7() if hasattr(uuid, 'uuid7') else uuid.uuid4(),
                event_type=self._classify_event(request),
                actor_user_id=str(request.user.pk),
                actor_email=request.user.email,
                actor_ip=self._get_client_ip(request),
                resource_type=self._extract_resource_type(request),
                resource_id=self._extract_resource_id(request),
                operation=request.method,
                outcome='SUCCESS' if response.status_code < 400 else 'FAILURE',
                event_data={
                    'path': request.path,
                    'status_code': response.status_code,
                    'user_agent': request.META.get('HTTP_USER_AGENT', ''),
                },
            )

        return response

    def _get_client_ip(self, request):
        forwarded = request.META.get('HTTP_X_FORWARDED_FOR')
        return forwarded.split(',')[0].strip() if forwarded else request.META.get('REMOTE_ADDR')

    def _classify_event(self, request):
        method_map = {'POST': 'data.create', 'PUT': 'data.update', 'PATCH': 'data.update', 'DELETE': 'data.delete'}
        return method_map.get(request.method, 'data.unknown')

    def _extract_resource_type(self, request):
        parts = request.path.strip('/').split('/')
        return parts[1] if len(parts) > 1 else 'unknown'

    def _extract_resource_id(self, request):
        parts = request.path.strip('/').split('/')
        return parts[2] if len(parts) > 2 else None
```

### Django Audit Model

```python
# audit/models.py
from django.db import models

class AuditLog(models.Model):
    event_id = models.UUIDField(primary_key=True)
    event_type = models.CharField(max_length=100, db_index=True)
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
    actor_user_id = models.CharField(max_length=100, db_index=True)
    actor_email = models.CharField(max_length=255)
    actor_ip = models.GenericIPAddressField()
    resource_type = models.CharField(max_length=100, db_index=True)
    resource_id = models.CharField(max_length=255, null=True, db_index=True)
    operation = models.CharField(max_length=20)
    outcome = models.CharField(max_length=20)
    event_data = models.JSONField(default=dict)
    previous_hash = models.CharField(max_length=64, null=True)
    event_hash = models.CharField(max_length=64)

    class Meta:
        db_table = 'audit_log'
        managed = True
        ordering = ['-timestamp']
        # Django doesn't enforce append-only; use DB rules (see Part 4)

    def save(self, *args, **kwargs):
        if self.pk and AuditLog.objects.filter(pk=self.pk).exists():
            raise ValueError("Audit log entries cannot be modified")
        super().save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        raise ValueError("Audit log entries cannot be deleted")
```

---

## PART 7: COMPLIANCE MAPPING

### Which Audit Events Satisfy Which Controls

| Regulation | Control | Required Audit Events |
|-----------|---------|----------------------|
| **SOC 2** CC6.1 | Logical access security | auth.login, auth.logout, auth.mfa, admin.user_create, admin.role_change |
| **SOC 2** CC6.2 | Access provisioning | admin.user_create, admin.user_disable, admin.role_change |
| **SOC 2** CC7.2 | System monitoring | All security events, system.start, system.deploy |
| **SOC 2** CC8.1 | Change management | admin.config_change, system.deploy, data.schema_change |
| **HIPAA** 164.312(b) | Audit controls | data.read (PHI), data.update (PHI), data.export (PHI) |
| **HIPAA** 164.312(d) | Person/entity authentication | auth.login, auth.mfa, auth.password_change |
| **HIPAA** 164.308(a)(5) | Security awareness | audit_log.access (meta-auditing) |
| **PCI-DSS** 10.2.1 | Individual user access to cardholder data | data.read (PAN), data.update (PAN) |
| **PCI-DSS** 10.2.2 | Actions by any individual with root/admin privileges | All admin.* events |
| **PCI-DSS** 10.2.4 | Invalid logical access attempts | auth.login (FAILURE), authorization.denied |
| **PCI-DSS** 10.2.5 | Changes to identification/authentication mechanisms | admin.user_create, auth.password_change, admin.role_change |
| **PCI-DSS** 10.2.7 | Creation/deletion of system-level objects | admin.config_change, data.schema_change |

### Retention Requirements

| Regulation | Minimum Retention | Recommended |
|-----------|------------------|-------------|
| SOC 2 | 1 year | 2 years |
| HIPAA | 6 years | 7 years |
| PCI-DSS | 1 year (3 months immediately available) | 2 years |
| GDPR | No minimum (but must justify) | Duration of processing + 1 year |
| FedRAMP | 3 years | 3 years |
| SOX | 7 years | 7 years |

---

## PART 8: SEARCH AND QUERY

### Elasticsearch/OpenSearch Index

```json
{
  "mappings": {
    "properties": {
      "event_id": { "type": "keyword" },
      "event_type": { "type": "keyword" },
      "timestamp": { "type": "date" },
      "actor.user_id": { "type": "keyword" },
      "actor.email": { "type": "keyword" },
      "actor.ip_address": { "type": "ip" },
      "resource.type": { "type": "keyword" },
      "resource.id": { "type": "keyword" },
      "action.operation": { "type": "keyword" },
      "outcome.status": { "type": "keyword" },
      "context.service": { "type": "keyword" },
      "context.correlation_id": { "type": "keyword" }
    }
  },
  "settings": {
    "index.number_of_replicas": 2,
    "index.blocks.write": false
  }
}
```

**Common audit queries:**
- "Show all PHI access for patient X in the last 30 days"
- "Show all failed login attempts from IP range Y"
- "Show all admin actions by user Z between dates"
- "Show all data exports exceeding N records"
- "Show all access to audit logs (meta-auditing)"

### Access Control on Audit Logs

| Role | Permissions | Use Case |
|------|------------|----------|
| audit_writer | INSERT only | Application services writing events |
| audit_reader | SELECT only | Compliance officers reviewing logs |
| audit_exporter | SELECT + export API | Generating evidence packages |
| audit_admin | SELECT + manage retention | Managing partitions and archival |
| **nobody** | UPDATE, DELETE | No human or system can modify or delete |

---

## PART 9: EXPORT AND REPORTING

### Auditor-Ready Evidence Package

```markdown
## Evidence Package: [Control ID] - [Audit Period]

### Metadata
- Control: SOC 2 CC6.1 - Logical Access Security
- Period: 2026-01-01 to 2026-03-31
- Generated: 2026-04-01T10:00:00Z
- Generated by: audit-export-service v1.2
- Hash chain verified: YES (all 1,048,576 events valid)

### Summary Statistics
- Total events: 1,048,576
- Unique actors: 142
- Failed auth attempts: 2,341 (0.22%)
- Admin actions: 891
- PHI access events: 45,221

### Sample Events (first 100)
[JSONL file attached]

### Integrity Verification
- First event hash: sha256:abc123...
- Last event hash: sha256:def456...
- Chain integrity: VERIFIED
- Missing sequence numbers: NONE
```

**Export formats:**
- JSONL (machine-readable, one event per line)
- CSV (for spreadsheet analysis)
- PDF report (executive summary with charts)

---

## ARCHITECTURE DECISION RECORD

```markdown
## ADR: Audit Logging Architecture

### Decision
Implement a dual-write audit system: primary to PostgreSQL (append-only, partitioned by month)
with async replication to S3 Object Lock (WORM) for long-term retention.

### Rationale
- PostgreSQL provides fast queries for operational audit review
- S3 Object Lock provides regulatory WORM compliance
- Hash chain provides tamper evidence across both stores
- Partitioning enables retention management without deleting from active tables

### Alternatives Considered
- Elasticsearch-only: No WORM guarantee, harder to prove immutability
- Blockchain-based: Overkill for most regulated industries, high cost
- Application-log-based: Fails compliance (mutable, shared access, no schema)

### Consequences
- Storage cost: ~$50-200/month for most applications
- Write latency: <5ms for primary, async for S3
- Query performance: Excellent for recent data, archive query via Athena for old data
```

---

## CHECKLIST

- [ ] Audit log system separated from application logging
- [ ] Structured event schema defined with all required fields
- [ ] Immutability enforced at database level (no UPDATE/DELETE rules)
- [ ] Hash chain implemented for tamper detection
- [ ] Chain verification procedure documented and tested
- [ ] WORM storage configured for long-term retention (S3 Object Lock or equivalent)
- [ ] All mandatory event categories captured (auth, data access, admin, security)
- [ ] Sensitive data excluded from audit events (no passwords, full PANs, raw PHI)
- [ ] Access controls enforced (INSERT-only for writers, SELECT-only for readers)
- [ ] Retention policies configured per regulation
- [ ] Partitioning strategy implemented for performance and retention
- [ ] Search capability deployed (Elasticsearch/OpenSearch or equivalent)
- [ ] Evidence export procedure documented and tested
- [ ] Compliance mapping documented (events to specific regulatory controls)
- [ ] Meta-auditing enabled (audit log access is itself audited)
- [ ] Architecture Decision Record written

---

*Skill Version: 1.0 | Phase: 3-Build | Priority: P1*
