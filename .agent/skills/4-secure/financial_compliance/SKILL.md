---
name: Financial Compliance
description: Regulatory compliance guidance for financial and fintech applications
---

# Financial Compliance Skill

**Purpose**: Structured guidance for implementing regulatory compliance in financial technology applications, covering KYC, AML, data protection, and audit requirements across major jurisdictions.

---

## 🎯 TRIGGER COMMANDS

```text
"Run a financial compliance check on [project]"
"Regulatory audit for [fintech feature]"
"Fintech compliance requirements for [jurisdiction]"
"Implement KYC/AML for [application]"
"Using financial_compliance skill: [task]"
```

---

> [!WARNING]
> This skill provides **guidance only**. It is NOT legal advice. ALWAYS consult qualified legal and compliance professionals for your specific jurisdiction and use case. Fines for non-compliance can reach millions of dollars, with personal liability for founders and officers.

---

## 🌍 Regulatory Landscape by Region

### United States

| Regulator | Full Name | Scope | Key Requirements |
|-----------|-----------|-------|------------------|
| **SEC** | Securities and Exchange Commission | Securities, investment products | Registration of securities, broker-dealer licensing, Reg D/A+ exemptions |
| **FINRA** | Financial Industry Regulatory Authority | Broker-dealers | Suitability, know your customer, advertising rules |
| **CFTC** | Commodity Futures Trading Commission | Futures, commodities, swaps | Registration, position limits, reporting |
| **FinCEN** | Financial Crimes Enforcement Network | AML/CFT | BSA compliance, SAR/CTR filing, recordkeeping |
| **OCC** | Office of the Comptroller of the Currency | National banks, fintech charters | Capital requirements, safety and soundness |
| **CFPB** | Consumer Financial Protection Bureau | Consumer finance | Fair lending, disclosure, complaint handling |
| **State MTLs** | State Money Transmitter Licenses | Money transmission | Per-state licensing (47 states + DC + territories) |

### European Union

| Regulation | Scope | Key Requirements |
|------------|-------|------------------|
| **MiFID II** | Investment services and activities | Authorization, best execution, record keeping, transaction reporting |
| **PSD2** | Payment services | Strong customer authentication (SCA), open banking API access |
| **DORA** | Digital operational resilience | ICT risk management, incident reporting, resilience testing |
| **MiCA** | Crypto-assets | Authorization for CASPs, stablecoin reserves, consumer protection |
| **GDPR** | Personal data processing | Consent, data minimization, right to erasure, DPO requirement |
| **AMLD 5/6** | Anti-money laundering | Customer due diligence, beneficial ownership, crypto exchange registration |

### United Kingdom

| Regulator | Scope | Key Requirements |
|-----------|-------|------------------|
| **FCA** | Financial conduct and consumer protection | Authorization, conduct rules, appointed representatives |
| **PRA** | Prudential regulation (banks, insurers) | Capital adequacy, stress testing, recovery planning |

### Global Standards

| Body | Standard | Application |
|------|----------|-------------|
| **FATF** | 40 Recommendations | AML/CFT framework adopted by 200+ jurisdictions |
| **Basel Committee** | Basel III/IV | Bank capital and liquidity requirements |
| **IOSCO** | Principles for Securities Regulation | Cross-border securities oversight |

---

## 🔍 KYC (Know Your Customer)

### Identity Verification Tiers

| Tier | Requirements | Transaction Limits | Use Case |
|------|-------------|-------------------|----------|
| **Basic** | Email + phone verification | Low limits (e.g., $1K/day) | Onboarding, free accounts |
| **Standard** | Government ID + selfie match | Medium limits (e.g., $10K/day) | Most retail users |
| **Enhanced** | ID + address proof + source of funds | High/unlimited | High-value accounts, PEPs |

### KYC Implementation Checklist

- [ ] **Identity Verification**: Government-issued photo ID (passport, driver's license, national ID)
- [ ] **Liveness Check**: Selfie matching against ID photo (anti-spoofing)
- [ ] **Address Verification**: Utility bill, bank statement, or government letter (< 3 months old)
- [ ] **Sanctions Screening**: Check against OFAC (US), EU consolidated list, UN Security Council list
- [ ] **PEP Screening**: Politically Exposed Persons database check
- [ ] **Adverse Media**: Negative news screening for financial crime, fraud, terrorism
- [ ] **Ongoing Monitoring**: Re-screen at regular intervals (annually for standard, quarterly for high-risk)

### Third-Party KYC Providers

| Provider | Strengths | Coverage | Pricing Model |
|----------|-----------|----------|---------------|
| **Sumsub** | All-in-one KYC/AML, fast integration | 220+ countries | Per verification |
| **Onfido** | AI-powered document verification | 195+ countries | Per verification |
| **Jumio** | Strong liveness detection | 200+ countries | Per verification |
| **Sardine** | Fraud + compliance combined | US-focused | Platform fee |
| **Persona** | Flexible workflows, good UX | Global | Per verification |

---

## 🚨 AML (Anti-Money Laundering)

### Transaction Monitoring Rules

| Rule | Threshold (US) | Action Required |
|------|----------------|-----------------|
| **Currency Transaction Report (CTR)** | $10,000+ cash transaction | Automatic filing with FinCEN |
| **Suspicious Activity Report (SAR)** | Any suspicious pattern | File within 30 days of detection |
| **Structuring Detection** | Multiple transactions just under $10K | Flag and investigate, potential SAR |
| **Wire Transfer Record** | $3,000+ wire transfers | Record and retain for 5 years |
| **Travel Rule** | $3,000+ (crypto: varies) | Share originator/beneficiary info |

### Transaction Monitoring Alert Thresholds

```typescript
// NestJS middleware for AML transaction monitoring
import { Injectable, NestMiddleware } from '@nestjs/common';

interface TransactionAlert {
  type: 'CTR' | 'SAR' | 'STRUCTURING' | 'VELOCITY' | 'GEOGRAPHIC';
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  description: string;
}

@Injectable()
export class AmlMonitoringService {
  private readonly RULES = {
    CTR_THRESHOLD: 10_000,        // USD - automatic CTR filing
    SAR_REVIEW_THRESHOLD: 5_000,  // USD - manual review trigger
    STRUCTURING_WINDOW: 24,       // hours
    STRUCTURING_THRESHOLD: 9_500, // USD - just under CTR threshold
    VELOCITY_MAX_COUNT: 10,       // transactions per hour
    HIGH_RISK_COUNTRIES: ['KP', 'IR', 'SY', 'MM'],  // FATF blacklist
  };

  async analyzeTransaction(tx: {
    userId: string;
    amount: number;
    currency: string;
    type: string;
    country?: string;
  }): Promise<TransactionAlert[]> {
    const alerts: TransactionAlert[] = [];

    // CTR: Report transactions over $10,000
    if (tx.amount >= this.RULES.CTR_THRESHOLD) {
      alerts.push({
        type: 'CTR',
        severity: 'HIGH',
        description: `Transaction of $${tx.amount} requires CTR filing`,
      });
    }

    // Structuring: Detect transactions just under threshold
    if (tx.amount >= this.RULES.STRUCTURING_THRESHOLD && tx.amount < this.RULES.CTR_THRESHOLD) {
      const recentTxCount = await this.getRecentTransactionCount(
        tx.userId,
        this.RULES.STRUCTURING_WINDOW
      );
      if (recentTxCount >= 2) {
        alerts.push({
          type: 'STRUCTURING',
          severity: 'CRITICAL',
          description: `Potential structuring: ${recentTxCount + 1} transactions near CTR threshold in ${this.RULES.STRUCTURING_WINDOW}h`,
        });
      }
    }

    // Geographic risk: High-risk country
    if (tx.country && this.RULES.HIGH_RISK_COUNTRIES.includes(tx.country)) {
      alerts.push({
        type: 'GEOGRAPHIC',
        severity: 'CRITICAL',
        description: `Transaction involves FATF high-risk jurisdiction: ${tx.country}`,
      });
    }

    // Velocity: Too many transactions in short period
    const hourlyCount = await this.getRecentTransactionCount(tx.userId, 1);
    if (hourlyCount >= this.RULES.VELOCITY_MAX_COUNT) {
      alerts.push({
        type: 'VELOCITY',
        severity: 'MEDIUM',
        description: `Unusual velocity: ${hourlyCount} transactions in past hour`,
      });
    }

    return alerts;
  }

  private async getRecentTransactionCount(userId: string, hours: number): Promise<number> {
    // Implementation: query transaction database for count in time window
    return 0; // placeholder
  }
}
```

### Record Keeping Requirements

| Requirement | Retention Period | Jurisdiction |
|-------------|-----------------|-------------|
| **AML records** | 5 years after account closure | US (BSA), EU (AMLD) |
| **SEC records** | 7 years | US (SEC Rule 17a-4) |
| **Tax records** | 7 years | US (IRS), varies by jurisdiction |
| **KYC documents** | 5 years after relationship ends | FATF recommendation |
| **Transaction records** | 5-7 years | Varies by jurisdiction |
| **Communication records** | 3-7 years | Depends on regulator |

---

## 🔐 Data Protection & Encryption

### Technical Requirements

| Requirement | Standard | Implementation |
|-------------|----------|---------------|
| **Encryption at rest** | AES-256 | Database-level encryption, encrypted backups |
| **Encryption in transit** | TLS 1.3 | HTTPS everywhere, certificate pinning for mobile |
| **Key management** | HSM or KMS | AWS KMS, Azure Key Vault, HashiCorp Vault |
| **Access controls** | RBAC + least privilege | Role-based with audit trail |
| **Data masking** | PII redaction | Mask SSN, account numbers in logs |

### Audit Log Implementation

```typescript
// Immutable audit log for financial compliance
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

interface AuditEntry {
  action: string;
  entityType: string;
  entityId: string;
  userId: string;
  ipAddress: string;
  userAgent: string;
  previousValue?: any;
  newValue?: any;
  metadata?: Record<string, any>;
}

@Injectable()
export class AuditLogService {
  constructor(private prisma: PrismaService) {}

  async log(entry: AuditEntry): Promise<void> {
    // Compute hash of previous entry for chain integrity
    const lastEntry = await this.prisma.auditLog.findFirst({
      orderBy: { createdAt: 'desc' },
    });

    const crypto = await import('crypto');
    const chainHash = crypto
      .createHash('sha256')
      .update(JSON.stringify(lastEntry) || 'genesis')
      .digest('hex');

    await this.prisma.auditLog.create({
      data: {
        action: entry.action,
        entityType: entry.entityType,
        entityId: entry.entityId,
        performedBy: entry.userId,
        ipAddress: entry.ipAddress,
        userAgent: entry.userAgent,
        previousValue: entry.previousValue ? JSON.stringify(entry.previousValue) : null,
        newValue: entry.newValue ? JSON.stringify(entry.newValue) : null,
        metadata: entry.metadata ? JSON.stringify(entry.metadata) : null,
        chainHash,
        // createdAt is set automatically and NEVER updated
      },
    });
  }

  async verifyChainIntegrity(): Promise<{ valid: boolean; brokenAt?: string }> {
    const entries = await this.prisma.auditLog.findMany({
      orderBy: { createdAt: 'asc' },
    });

    const crypto = await import('crypto');
    for (let i = 1; i < entries.length; i++) {
      const expectedHash = crypto
        .createHash('sha256')
        .update(JSON.stringify(entries[i - 1]))
        .digest('hex');

      if (entries[i].chainHash !== expectedHash) {
        return { valid: false, brokenAt: entries[i].id };
      }
    }
    return { valid: true };
  }
}
```

> [!TIP]
> For true immutability, consider append-only databases or write the audit hash to a blockchain/timestamping service. Regular integrity checks should run as a scheduled job.

---

## 💳 Payment Processing Compliance

### PCI DSS Requirements (Credit Cards)

| Requirement | Category | Description |
|-------------|----------|-------------|
| **1-2** | Network Security | Firewall, no vendor defaults for passwords |
| **3-4** | Cardholder Data | Encrypt stored data (AES-256), encrypt transmission (TLS) |
| **5-6** | Vulnerability Management | Anti-malware, secure development lifecycle |
| **7-9** | Access Control | Need-to-know basis, unique IDs, physical access controls |
| **10-11** | Monitoring | Log all access, regular security testing |
| **12** | Policy | Information security policy, employee training |

> [!TIP]
> **Avoid PCI scope entirely** by using tokenization. Services like Stripe, Braintree, and Adyen handle card data so you never touch it. Your PCI questionnaire drops from SAQ D (300+ questions) to SAQ A (22 questions).

### SOC 2 Compliance

| Type | Duration | What It Proves |
|------|----------|---------------|
| **Type I** | Point-in-time assessment | Controls are designed appropriately |
| **Type II** | 3-12 month observation period | Controls operate effectively over time |

**Trust Service Criteria**:

| Criterion | Focus | Required? |
|-----------|-------|-----------|
| **Security** | Protection against unauthorized access | Always (common criteria) |
| **Availability** | System uptime and accessibility | If you have SLAs |
| **Processing Integrity** | Data processing is complete, accurate, timely | If you process transactions |
| **Confidentiality** | Protection of confidential information | If you handle sensitive data |
| **Privacy** | Personal information handling | If you collect personal data |

---

## 🪙 Crypto-Specific Compliance

| Requirement | Description | Key Consideration |
|-------------|-------------|-------------------|
| **Travel Rule** | Share originator/beneficiary info for transfers > threshold | FATF guideline, adopted by most jurisdictions |
| **Howey Test** | Determines if a token is a security (US) | Investment of money, common enterprise, expectation of profit from others |
| **BitLicense** | New York State crypto license | Required for ANY crypto business serving NY residents |
| **Stablecoin Reserves** | Proof of 1:1 backing with reserve assets | Monthly attestations, approved reserve assets |
| **DeFi Compliance** | Uncertain regulatory status | Some jurisdictions treating DeFi protocols as financial intermediaries |

### Blockchain Analytics Tools

| Tool | Specialty | Use Case |
|------|-----------|----------|
| **Chainalysis** | Blockchain investigation, sanctions screening | Transaction monitoring, SAR evidence |
| **Elliptic** | Risk scoring, compliance automation | Wallet screening, regulatory reporting |
| **TRM Labs** | Multi-chain analytics | Cross-chain tracking, DeFi monitoring |
| **Crystal Blockchain** | Visualization, investigation | Law enforcement, compliance teams |

---

## 📋 Data Retention Policy Implementation

```typescript
// Automated data retention enforcement
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataRetentionService {
  private readonly logger = new Logger(DataRetentionService.name);

  // Retention policies by data category (in days)
  private readonly RETENTION_POLICIES = {
    transactionRecords: 7 * 365,     // 7 years (SEC Rule 17a-4)
    amlRecords: 5 * 365,             // 5 years (BSA)
    kycDocuments: 5 * 365,           // 5 years after relationship ends
    auditLogs: 7 * 365,             // 7 years (conservative)
    sessionLogs: 90,                 // 90 days (operational)
    analyticsEvents: 365,            // 1 year (business)
    tempFiles: 30,                   // 30 days (cleanup)
  };

  constructor(private prisma: PrismaService) {}

  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async enforceRetentionPolicies(): Promise<void> {
    this.logger.log('Starting data retention enforcement...');

    for (const [category, retentionDays] of Object.entries(this.RETENTION_POLICIES)) {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - retentionDays);

      try {
        // Archive before deletion (regulatory requirement)
        await this.archiveExpiredRecords(category, cutoffDate);

        // Soft-delete or hard-delete based on category
        const deletedCount = await this.deleteExpiredRecords(category, cutoffDate);

        this.logger.log(
          `Retention: ${category} - deleted ${deletedCount} records older than ${cutoffDate.toISOString()}`
        );
      } catch (error) {
        this.logger.error(`Retention enforcement failed for ${category}`, error);
      }
    }
  }

  private async archiveExpiredRecords(category: string, before: Date): Promise<void> {
    // Implementation: export to cold storage (S3 Glacier, etc.) before deletion
  }

  private async deleteExpiredRecords(category: string, before: Date): Promise<number> {
    // Implementation: delete from active database
    return 0; // placeholder
  }
}
```

---

## 🛠️ Compliance Integration Providers

| Provider | Service | Integration | Best For |
|----------|---------|-------------|----------|
| **Plaid** | Banking connections, identity | REST API, SDKs | Account linking, income verification |
| **Sardine** | Fraud + compliance platform | REST API | All-in-one fraud and compliance |
| **Alloy** | Identity decisioning | REST API | KYC orchestration, credit checks |
| **Unit21** | Transaction monitoring | REST API | AML detection, case management |
| **Hummingbird** | SAR/CTR filing | Platform | Regulatory report generation |

---

## 📊 Compliance Reporting Requirements

| Report | Frequency | Regulator | Trigger |
|--------|-----------|-----------|---------|
| **SAR** (Suspicious Activity Report) | As needed (within 30 days) | FinCEN | Suspicious transaction detected |
| **CTR** (Currency Transaction Report) | Per transaction | FinCEN | Cash transaction > $10,000 |
| **Form ADV** | Annually | SEC | Investment adviser registration |
| **FOCUS Report** | Monthly/quarterly | FINRA | Broker-dealer financial condition |
| **Call Report** | Quarterly | OCC/FDIC | Bank financial condition |
| **PCI SAQ** | Annually | PCI SSC | Credit card data handling |

---

## ✅ EXIT CHECKLIST

- [ ] KYC flow implemented with identity verification, sanctions screening, and PEP checks
- [ ] AML transaction monitoring active with configurable alert thresholds
- [ ] Audit logs are immutable, chain-hashed, and cover all financial operations
- [ ] Data encrypted at rest (AES-256) and in transit (TLS 1.3)
- [ ] Data retention policies configured and automated per regulatory requirement
- [ ] Access controls enforce least privilege with role-based permissions
- [ ] SAR/CTR filing process documented and tested
- [ ] PCI DSS scope minimized (tokenization) or full compliance achieved
- [ ] Qualified legal counsel engaged for applicable jurisdictions
- [ ] Compliance documentation maintained and audit-ready
- [ ] Employee training program established for AML/compliance awareness
- [ ] Incident response plan includes regulatory notification procedures

---

*Skill Version: 1.0 | Created: February 2026*
