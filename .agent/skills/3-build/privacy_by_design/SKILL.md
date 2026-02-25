---
name: Privacy By Design
description: Implement data minimization, PII encryption, right-to-erasure, consent management, and GDPR audit logging.
---

# Privacy By Design Skill

**Purpose**: Embed privacy into the build process from the start rather than bolting it on later. Covers data minimization, PII classification, field-level encryption, right-to-erasure strategies, consent management, data retention policies, and GDPR-compliant audit logging.

## TRIGGER COMMANDS

```text
"Implement right to erasure"
"Add GDPR compliance for [feature]"
"Privacy by design"
```

## When to Use
- Building features that collect or process personal data
- Storing user profiles, emails, addresses, or payment information
- Operating in EU/UK markets (GDPR) or California (CCPA)
- Preparing for SOC2 or compliance audits
- Users request data deletion or export

---

## PROCESS

### Step 1: PII Classification Taxonomy

Classify every data field before storing it:

```text
CATEGORY A - Direct Identifiers (highest risk):
  email, phone, full name, SSN, passport, government ID
  --> Encrypt at rest, mask in logs, delete on erasure

CATEGORY B - Indirect Identifiers (medium risk):
  IP address, device fingerprint, geolocation, date of birth
  --> Anonymize or pseudonymize where possible

CATEGORY C - Sensitive Data (special category under GDPR):
  health data, biometrics, religion, ethnicity, political views
  --> Explicit consent required, encrypt, strict access control

CATEGORY D - Non-PII:
  anonymous usage metrics, aggregated statistics
  --> Safe to retain, no special handling needed
```

### Step 2: Data Minimization Patterns

```typescript
// RULE: Never collect more data than the feature requires

// BAD: Collecting everything "just in case"
@Post('register')
register(@Body() dto: {
  email: string;
  name: string;
  phone: string;       // Not needed for registration
  address: string;     // Not needed for registration
  dateOfBirth: string; // Not needed for registration
}) {}

// GOOD: Collect only what is needed for the current feature
@Post('register')
register(@Body() dto: {
  email: string;
  name: string;
}) {}

// Prisma: select only PII fields when actually needed
async getPublicProfile(userId: string) {
  return this.prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      displayName: true,  // Not PII (user-chosen alias)
      avatarUrl: true,
      // Do NOT select: email, phone, address
    },
  });
}
```

### Step 3: Field-Level PII Encryption

```typescript
// crypto/encryption.service.ts
import { Injectable } from '@nestjs/common';
import { createCipheriv, createDecipheriv, randomBytes, scryptSync } from 'crypto';

@Injectable()
export class EncryptionService {
  private readonly algorithm = 'aes-256-gcm';
  private readonly key: Buffer;

  constructor(private config: ConfigService) {
    // Derive key from master secret
    const masterKey = this.config.getOrThrow<string>('ENCRYPTION_MASTER_KEY');
    this.key = scryptSync(masterKey, 'salt', 32);
  }

  encrypt(plaintext: string): string {
    const iv = randomBytes(16);
    const cipher = createCipheriv(this.algorithm, this.key, iv);
    const encrypted = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
    const authTag = cipher.getAuthTag();
    // Store as: iv:authTag:ciphertext (all base64)
    return `${iv.toString('base64')}:${authTag.toString('base64')}:${encrypted.toString('base64')}`;
  }

  decrypt(encryptedValue: string): string {
    const [ivB64, authTagB64, cipherB64] = encryptedValue.split(':');
    const iv = Buffer.from(ivB64, 'base64');
    const authTag = Buffer.from(authTagB64, 'base64');
    const encrypted = Buffer.from(cipherB64, 'base64');
    const decipher = createDecipheriv(this.algorithm, this.key, iv);
    decipher.setAuthTag(authTag);
    return decipher.update(encrypted) + decipher.final('utf8');
  }
}

// Usage in service
async createUser(dto: CreateUserDto) {
  return this.prisma.user.create({
    data: {
      email: dto.email,  // Stored as-is for lookups (hashed index)
      emailEncrypted: this.encryption.encrypt(dto.email),
      phone: this.encryption.encrypt(dto.phone),
      name: this.encryption.encrypt(dto.name),
    },
  });
}
```

### Step 4: Right-to-Erasure Implementation

```typescript
// user/user-erasure.service.ts
@Injectable()
export class UserErasureService {
  constructor(private prisma: PrismaService, private logger: Logger) {}

  async eraseUser(userId: string): Promise<ErasureReport> {
    const report: ErasureReport = { userId, deletedAt: new Date(), actions: [] };

    await this.prisma.$transaction(async (tx) => {
      // 1. Hard-delete direct PII
      await tx.userProfile.delete({ where: { userId } });
      report.actions.push({ table: 'user_profile', action: 'deleted' });

      // 2. Anonymize records that must be retained (e.g., financial audit)
      await tx.order.updateMany({
        where: { userId },
        data: {
          customerName: '[REDACTED]',
          customerEmail: '[REDACTED]',
          userId: null,  // Break FK link
        },
      });
      report.actions.push({ table: 'orders', action: 'anonymized' });

      // 3. Delete user-generated content (if policy allows)
      await tx.comment.deleteMany({ where: { authorId: userId } });
      report.actions.push({ table: 'comments', action: 'deleted' });

      // 4. Delete the user account last
      await tx.user.delete({ where: { id: userId } });
      report.actions.push({ table: 'users', action: 'deleted' });
    });

    // 5. Log the erasure for compliance proof (no PII in the log)
    this.logger.log({
      event: 'user.erased',
      userId,  // UUID only, no PII
      actionsCount: report.actions.length,
      timestamp: report.deletedAt.toISOString(),
    });

    return report;
  }
}
```

### Step 5: Consent Management

```typescript
// Prisma schema for consent records
// model Consent {
//   id        String   @id @default(uuid())
//   userId    String
//   purpose   String   // e.g., "marketing_emails", "analytics", "third_party_sharing"
//   granted   Boolean
//   grantedAt DateTime?
//   revokedAt DateTime?
//   version   String   // Consent policy version user agreed to
//   ipAddress String?  // Record where consent was given
//   @@map("consents")
// }

@Injectable()
export class ConsentService {
  async grantConsent(userId: string, purpose: string, version: string) {
    return this.prisma.consent.upsert({
      where: { userId_purpose: { userId, purpose } },
      create: { userId, purpose, granted: true, grantedAt: new Date(), version },
      update: { granted: true, grantedAt: new Date(), revokedAt: null, version },
    });
  }

  async revokeConsent(userId: string, purpose: string) {
    return this.prisma.consent.update({
      where: { userId_purpose: { userId, purpose } },
      data: { granted: false, revokedAt: new Date() },
    });
  }

  async hasConsent(userId: string, purpose: string): Promise<boolean> {
    const consent = await this.prisma.consent.findUnique({
      where: { userId_purpose: { userId, purpose } },
    });
    return consent?.granted ?? false;
  }
}

// Guard: block processing if consent not given
@Injectable()
export class ConsentGuard implements CanActivate {
  constructor(private consentService: ConsentService, private reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const purpose = this.reflector.get<string>('requiredConsent', context.getHandler());
    if (!purpose) return true;

    const request = context.switchToHttp().getRequest();
    return this.consentService.hasConsent(request.user.sub, purpose);
  }
}
```

### Step 6: Data Retention with Scheduled Cleanup

```typescript
// retention/retention.service.ts
@Injectable()
export class RetentionService {
  private readonly policies: Record<string, number> = {
    sessions: 30,           // 30 days
    auditLogs: 365,         // 1 year
    deletedUsers: 90,       // 90 days post-deletion
    analyticsRaw: 180,      // 6 months
  };

  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async enforceRetention() {
    for (const [table, retentionDays] of Object.entries(this.policies)) {
      const cutoff = new Date();
      cutoff.setDate(cutoff.getDate() - retentionDays);

      const deleted = await this.prisma[table].deleteMany({
        where: { createdAt: { lt: cutoff } },
      });

      this.logger.log(`Retention: deleted ${deleted.count} rows from ${table} older than ${retentionDays}d`);
    }
  }
}
```

### Step 7: GDPR Audit Logging

```typescript
// audit/pii-access.interceptor.ts
// Log WHO accessed WHAT PII and WHEN

@Injectable()
export class PiiAccessInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const handler = context.getHandler();
    const isPiiEndpoint = this.reflector.get<boolean>('accessesPii', handler);
    if (!isPiiEndpoint) return next.handle();

    const request = context.switchToHttp().getRequest();

    return next.handle().pipe(
      tap(() => {
        this.auditService.log({
          event: 'pii.accessed',
          accessor: request.user.sub,
          endpoint: `${request.method} ${request.url}`,
          resourceId: request.params.id,
          timestamp: new Date().toISOString(),
          // Do NOT log the actual PII data
        });
      }),
    );
  }
}

// Mark endpoints that access PII
export const AccessesPii = () => SetMetadata('accessesPii', true);

@Get(':id/profile')
@AccessesPii()
getProfile(@Param('id') id: string) {
  return this.userService.getFullProfile(id);
}
```

---

## CHECKLIST

- [ ] Every data field classified by PII category (A/B/C/D)
- [ ] Data minimization: only fields required by the feature are collected
- [ ] Category A/C PII encrypted at field level in the database
- [ ] Right-to-erasure endpoint implemented with full cascade
- [ ] Erasure uses anonymization for audit-required records (not hard delete)
- [ ] Consent model stores purpose, version, grant/revoke timestamps
- [ ] ConsentGuard blocks processing without valid consent
- [ ] Data retention policies defined and enforced via scheduled jobs
- [ ] PII access audit log records who/what/when without logging actual PII
- [ ] PII masked in application logs (no email/phone in log output)
