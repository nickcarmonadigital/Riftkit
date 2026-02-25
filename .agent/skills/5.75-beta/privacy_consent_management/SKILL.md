---
name: Privacy Consent Management
description: GDPR/CCPA consent infrastructure with consent collection, withdrawal flows, audit trails, and cookie consent implementation
---

# Privacy Consent Management Skill

**Purpose**: Build compliant consent infrastructure that respects user privacy while enabling the analytics and tracking your product needs. This skill covers GDPR and CCPA consent collection, withdrawal flows, audit trails, cookie consent banners (without dark patterns), and consent propagation to third-party services. Consent violations carry fines up to 4% of global revenue -- this is not optional.

## TRIGGER COMMANDS

```text
"Set up consent management"
"GDPR consent infrastructure"
"Cookie consent implementation"
"Privacy compliance setup"
"Using privacy_consent_management skill: implement consent for [project]"
```

## When to Use

- Product collects any personal data from users (analytics, tracking, cookies)
- Serving users in the EU (GDPR), California (CCPA), or other regulated jurisdictions
- Using third-party analytics, advertising, or tracking services
- Existing `product_analytics` skill needs consent gating before going live

---

## PROCESS

### Step 1: Map Data Processing Activities

Before building consent UI, understand what you collect and why.

| Data Category | Purpose | Legal Basis | Consent Required |
|--------------|---------|-------------|-----------------|
| **Essential cookies** | Authentication, CSRF protection | Legitimate interest | No (strictly necessary) |
| **Analytics** | Usage tracking, feature adoption | Consent | Yes |
| **Marketing** | Email campaigns, retargeting | Consent | Yes |
| **Functional** | User preferences, language | Legitimate interest | No |
| **Third-party** | PostHog, Stripe, Intercom | Consent (data sharing) | Yes |

> Strictly necessary cookies do NOT require consent under GDPR. Do not ask permission for session cookies or CSRF tokens. Over-asking degrades the consent experience and trains users to click "Accept All."

### Step 2: Implement the Consent Data Model

Store consent records as an immutable audit trail. Never overwrite -- always append.

```sql
CREATE TABLE consent_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  anonymous_id VARCHAR(255),         -- for pre-auth consent
  consent_type VARCHAR(50) NOT NULL, -- 'analytics', 'marketing', 'third_party'
  granted BOOLEAN NOT NULL,
  source VARCHAR(50) NOT NULL,       -- 'cookie_banner', 'settings_page', 'signup_form'
  ip_address VARCHAR(45),
  user_agent TEXT,
  version VARCHAR(20) NOT NULL,      -- consent policy version
  created_at TIMESTAMP DEFAULT NOW()
);

-- Index for quick lookups
CREATE INDEX idx_consent_user_type ON consent_records(user_id, consent_type);
CREATE INDEX idx_consent_anonymous ON consent_records(anonymous_id, consent_type);
```

**Consent Service**:

```typescript
// src/privacy/consent.service.ts
@Injectable()
export class ConsentService {
  constructor(private readonly prisma: PrismaService) {}

  async recordConsent(params: {
    userId?: string;
    anonymousId?: string;
    consentType: 'analytics' | 'marketing' | 'third_party';
    granted: boolean;
    source: string;
    ipAddress: string;
    userAgent: string;
  }): Promise<void> {
    await this.prisma.consentRecord.create({
      data: { ...params, version: CURRENT_CONSENT_VERSION },
    });
  }

  async hasConsent(userId: string, consentType: string): Promise<boolean> {
    const latest = await this.prisma.consentRecord.findFirst({
      where: { userId, consentType },
      orderBy: { createdAt: 'desc' },
    });
    return latest?.granted ?? false;
  }

  async getConsentHistory(userId: string): Promise<ConsentRecord[]> {
    return this.prisma.consentRecord.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
```

### Step 3: Build the Cookie Consent Banner

Follow these rules to avoid dark patterns and regulatory risk.

**Required Behaviors**:

| Rule | Implementation |
|------|---------------|
| Equal prominence | "Accept" and "Reject" buttons must be the same size and color |
| No pre-checked boxes | All optional categories default to unchecked |
| Granular choice | Users can accept analytics but reject marketing |
| Easy withdrawal | Consent settings accessible from footer or settings page |
| No consent wall | Users can use the product without accepting optional cookies |
| Persistent choice | Remember the choice; do not re-ask on every visit |

**Cookie Banner Component**:

```tsx
// components/privacy/CookieConsentBanner.tsx
interface ConsentState {
  analytics: boolean;
  marketing: boolean;
  thirdParty: boolean;
}

export function CookieConsentBanner() {
  const [showDetails, setShowDetails] = useState(false);
  const [consent, setConsent] = useState<ConsentState>({
    analytics: false,   // NOT pre-checked
    marketing: false,
    thirdParty: false,
  });

  const handleAcceptAll = () => saveConsent({ analytics: true, marketing: true, thirdParty: true });
  const handleRejectAll = () => saveConsent({ analytics: false, marketing: false, thirdParty: false });
  const handleSaveChoices = () => saveConsent(consent);

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t shadow-lg p-4 z-50">
      <p className="text-sm text-gray-700">
        We use cookies to improve your experience. You can choose which types to allow.
      </p>
      {showDetails && (
        <div className="mt-3 space-y-2">
          <label className="flex items-center gap-2 text-sm">
            <input type="checkbox" checked disabled /> Essential (required)
          </label>
          <label className="flex items-center gap-2 text-sm">
            <input type="checkbox" checked={consent.analytics}
              onChange={(e) => setConsent({ ...consent, analytics: e.target.checked })} />
            Analytics
          </label>
          <label className="flex items-center gap-2 text-sm">
            <input type="checkbox" checked={consent.marketing}
              onChange={(e) => setConsent({ ...consent, marketing: e.target.checked })} />
            Marketing
          </label>
        </div>
      )}
      <div className="mt-3 flex gap-3">
        {/* Equal prominence: same size, same visual weight */}
        <button onClick={handleRejectAll}
          className="px-4 py-2 border border-gray-300 rounded text-sm font-medium">
          Reject All
        </button>
        <button onClick={() => setShowDetails(!showDetails)}
          className="px-4 py-2 border border-gray-300 rounded text-sm font-medium">
          Customize
        </button>
        <button onClick={handleAcceptAll}
          className="px-4 py-2 border border-gray-300 rounded text-sm font-medium">
          Accept All
        </button>
      </div>
    </div>
  );
}
```

### Step 4: Propagate Consent to Third-Party Services

When consent is granted or withdrawn, notify all downstream services.

```typescript
// src/privacy/consent-propagation.service.ts
async function propagateConsent(userId: string, consent: ConsentState): Promise<void> {
  if (consent.analytics) {
    posthog.opt_in_capturing();
  } else {
    posthog.opt_out_capturing();
  }

  if (consent.marketing) {
    await emailService.subscribe(userId);
  } else {
    await emailService.unsubscribe(userId);
  }

  // Log propagation for audit
  await auditLog.record('consent_propagated', { userId, consent });
}
```

### Step 5: Implement Withdrawal Flow

Users must be able to withdraw consent as easily as they granted it.

**Withdrawal Locations**:

- Footer link: "Cookie Preferences" or "Privacy Settings"
- Account settings page: dedicated privacy/consent section
- Email unsubscribe link: one-click for marketing consent

**Data Deletion on Withdrawal** (GDPR Right to Erasure):

```text
When analytics consent is withdrawn:
1. Stop collecting new analytics events immediately
2. Queue deletion of historical analytics data for this user
3. Notify third-party analytics providers of deletion request
4. Record the withdrawal in the consent audit trail
5. Confirm deletion to the user within 30 days
```

---

## CHECKLIST

- [ ] Data processing activities mapped with legal basis for each
- [ ] Consent data model implemented as append-only audit trail
- [ ] ConsentService provides grant, check, and history methods
- [ ] Cookie consent banner displays with equal prominence buttons
- [ ] No pre-checked optional consent boxes
- [ ] Granular consent choices available (analytics, marketing, third-party)
- [ ] Consent propagated to all third-party services on change
- [ ] Withdrawal flow accessible from footer and account settings
- [ ] Data deletion workflow triggered on consent withdrawal
- [ ] Consent version tracking enables re-consent when policy changes
- [ ] No consent wall -- product is usable without optional cookies

---

*Skill Version: 1.0 | Created: February 2026*
