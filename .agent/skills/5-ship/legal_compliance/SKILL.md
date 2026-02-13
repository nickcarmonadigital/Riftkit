---
name: Legal Compliance
description: Terms of Service, Privacy Policy, Cookie Policy, and Acceptable Use Policy templates for SaaS applications
---

# Legal Compliance Skill

**Purpose**: Ensure every SaaS application ships with the required legal pages -- Terms of Service, Privacy Policy, Cookie Policy, and Acceptable Use Policy -- plus a functioning cookie consent banner and proper linking throughout the app.

> [!WARNING]
> **These are templates, not legal advice.** Every business has unique circumstances. Always have a qualified attorney review your legal documents before publishing. These templates provide a solid starting point but are NOT a substitute for professional legal counsel.

---

## 🎯 TRIGGER COMMANDS

```text
"Create legal pages"
"Add terms of service"
"Privacy policy"
"Set up cookie consent"
"Add legal compliance pages"
"Using legal_compliance skill: create [pages] for [project]"
```

---

## 📋 WHAT EVERY SAAS NEEDS

| Legal Page | Required? | Why |
|------------|-----------|-----|
| Terms of Service (ToS) | Yes | Defines the contract between you and users |
| Privacy Policy | Yes | Legally required if you collect ANY personal data |
| Cookie Policy | Yes (if using cookies) | GDPR/ePrivacy Directive requirement |
| Acceptable Use Policy (AUP) | Recommended | Defines prohibited behaviors, protects your platform |
| Data Processing Agreement (DPA) | If B2B | Required when processing data on behalf of business customers |

### When You Need a DPA

- [ ] You have business customers (B2B)
- [ ] You process personal data on behalf of those customers
- [ ] Your customers have EU users (GDPR Article 28)
- [ ] Your customers request one during procurement

---

## 🇪🇺 GDPR REQUIREMENTS CHECKLIST

If you have ANY users in the European Union:

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Lawful basis for processing | [ ] | Consent, contract, or legitimate interest |
| Right to access (Article 15) | [ ] | Export user data endpoint |
| Right to erasure (Article 17) | [ ] | Delete account + all data |
| Right to data portability (Article 20) | [ ] | Export data in machine-readable format |
| Right to rectification (Article 16) | [ ] | User can edit their data |
| Right to restrict processing (Article 18) | [ ] | Pause data processing on request |
| Data breach notification (72 hours) | [ ] | Incident response plan |
| Privacy by design | [ ] | Minimal data collection, encryption |
| Cookie consent before non-essential cookies | [ ] | Banner with opt-in (not opt-out) |
| Data Processing Agreements with vendors | [ ] | Stripe, analytics, AI providers |
| Record of processing activities | [ ] | Internal documentation |

> [!TIP]
> GDPR requires **opt-in** consent for non-essential cookies. Pre-checked boxes do NOT count as valid consent. Users must actively click "Accept" before you set analytics or marketing cookies.

---

## 🇺🇸 CCPA REQUIREMENTS CHECKLIST

If you have users in California (and meet thresholds):

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| "Do Not Sell My Personal Information" link | [ ] | Visible in footer |
| Right to know what data is collected | [ ] | Privacy policy details |
| Right to delete personal information | [ ] | Delete account feature |
| Right to opt-out of data sale | [ ] | Opt-out mechanism |
| Non-discrimination for exercising rights | [ ] | Same service regardless |
| Privacy policy updated annually | [ ] | Calendar reminder |
| Financial incentive disclosure | [ ] | If offering discounts for data |

---

## 📄 TERMS OF SERVICE: KEY SECTIONS

Every Terms of Service document should include these sections:

| Section | What It Covers | Priority |
|---------|---------------|----------|
| Definitions | Key terms (Service, User, Content, Account) | Required |
| Account Terms | Registration, eligibility, account security | Required |
| Acceptable Use | What users can and cannot do | Required |
| Payment Terms | Pricing, billing cycle, refunds, currency | If paid |
| Cancellation & Termination | How to cancel, what happens to data | Required |
| Intellectual Property | Who owns what (your IP vs user content) | Required |
| User Content & Data | User retains ownership, you get license to host | Required |
| Data Ownership | Users own their data, can export/delete | Required |
| Limitation of Liability | Cap on damages, exclusions | Required |
| Disclaimer of Warranties | "As is" / "as available" | Required |
| Indemnification | User indemnifies you for their misuse | Recommended |
| Governing Law | Which jurisdiction's laws apply | Required |
| Dispute Resolution | Arbitration vs courts | Recommended |
| Changes to Terms | How you notify users of changes | Required |
| Contact Information | How to reach you | Required |

---

## 🔒 PRIVACY POLICY: KEY SECTIONS

| Section | What to Include |
|---------|----------------|
| What Data We Collect | Name, email, payment info, usage data, cookies |
| How We Collect It | Forms, cookies, analytics, third-party login |
| Why We Collect It | Service delivery, improvement, communication |
| How We Use It | Feature delivery, analytics, support, marketing |
| Third-Party Sharing | Payment processor, analytics, AI providers, hosting |
| Data Retention | How long data is kept, deletion timeline |
| Data Security | Encryption, access controls, incident response |
| User Rights | Access, correct, delete, export, restrict, object |
| Children's Privacy | Under 13/16 policy (COPPA/GDPR) |
| International Transfers | If data moves across borders |
| Cookie Policy | Link to separate cookie policy |
| Changes to Policy | Notification method |
| Contact Information | Email, address, DPO if applicable |

### Third-Party Services to Disclose

```text
- Stripe (payment processing)
- Google Analytics (usage analytics)
- OpenAI / Anthropic / etc. (AI features)
- AWS / Railway / Vercel (hosting)
- SendGrid / Resend (email)
- Sentry (error tracking)
- Intercom / Crisp (support chat)
```

> [!WARNING]
> If you use AI providers (OpenAI, Anthropic, etc.), you MUST disclose this in your privacy policy. Users should know their data may be sent to AI services for processing. Check each provider's data processing terms.

---

## 🍪 COOKIE POLICY

### Cookie Categories

| Category | Consent Required? | Examples |
|----------|-------------------|----------|
| Strictly Necessary | No | Session cookies, CSRF tokens, auth tokens |
| Functional | Yes (GDPR) | Language preference, theme, UI settings |
| Analytics | Yes | Google Analytics, Mixpanel, Hotjar |
| Marketing | Yes | Facebook Pixel, Google Ads, retargeting |

### Cookie Consent Banner Implementation

```typescript
// components/CookieConsentBanner.tsx
import { useState, useEffect } from 'react';

interface CookiePreferences {
  necessary: boolean;   // Always true, cannot be disabled
  functional: boolean;
  analytics: boolean;
  marketing: boolean;
}

const DEFAULT_PREFERENCES: CookiePreferences = {
  necessary: true,
  functional: false,
  analytics: false,
  marketing: false,
};

export function CookieConsentBanner() {
  const [visible, setVisible] = useState(false);
  const [showDetails, setShowDetails] = useState(false);
  const [preferences, setPreferences] = useState<CookiePreferences>(DEFAULT_PREFERENCES);

  useEffect(() => {
    const stored = localStorage.getItem('cookie-consent');
    if (!stored) {
      setVisible(true);
    }
  }, []);

  const savePreferences = (prefs: CookiePreferences) => {
    localStorage.setItem('cookie-consent', JSON.stringify({
      preferences: prefs,
      timestamp: new Date().toISOString(),
      version: '1.0',
    }));
    setVisible(false);
    applyCookiePreferences(prefs);
  };

  const acceptAll = () => {
    savePreferences({
      necessary: true,
      functional: true,
      analytics: true,
      marketing: true,
    });
  };

  const rejectNonEssential = () => {
    savePreferences(DEFAULT_PREFERENCES);
  };

  const saveCustom = () => {
    savePreferences(preferences);
  };

  if (!visible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 bg-white border-t shadow-lg p-4 md:p-6">
      <div className="max-w-4xl mx-auto">
        <h3 className="text-lg font-semibold mb-2">We use cookies</h3>
        <p className="text-sm text-gray-600 mb-4">
          We use cookies to improve your experience. Some are necessary for the
          site to work, others help us understand how you use it.{' '}
          <a href="/cookies" className="text-blue-600 underline">
            Cookie Policy
          </a>
        </p>

        {showDetails && (
          <div className="mb-4 space-y-2">
            <label className="flex items-center gap-2">
              <input type="checkbox" checked disabled />
              <span className="text-sm">Strictly Necessary (always on)</span>
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={preferences.functional}
                onChange={(e) =>
                  setPreferences({ ...preferences, functional: e.target.checked })
                }
              />
              <span className="text-sm">Functional</span>
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={preferences.analytics}
                onChange={(e) =>
                  setPreferences({ ...preferences, analytics: e.target.checked })
                }
              />
              <span className="text-sm">Analytics</span>
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={preferences.marketing}
                onChange={(e) =>
                  setPreferences({ ...preferences, marketing: e.target.checked })
                }
              />
              <span className="text-sm">Marketing</span>
            </label>
          </div>
        )}

        <div className="flex flex-wrap gap-2">
          <button
            onClick={acceptAll}
            className="px-4 py-2 bg-blue-600 text-white rounded text-sm font-medium"
          >
            Accept All
          </button>
          <button
            onClick={rejectNonEssential}
            className="px-4 py-2 bg-gray-200 text-gray-800 rounded text-sm font-medium"
          >
            Reject Non-Essential
          </button>
          {showDetails ? (
            <button
              onClick={saveCustom}
              className="px-4 py-2 bg-gray-200 text-gray-800 rounded text-sm font-medium"
            >
              Save Preferences
            </button>
          ) : (
            <button
              onClick={() => setShowDetails(true)}
              className="px-4 py-2 text-blue-600 text-sm font-medium underline"
            >
              Customize
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

// Apply preferences by enabling/disabling tracking scripts
function applyCookiePreferences(prefs: CookiePreferences): void {
  if (prefs.analytics) {
    // Initialize analytics (e.g., Google Analytics)
    loadScript('https://www.googletagmanager.com/gtag/js?id=G-XXXXXXX');
  }
  if (prefs.marketing) {
    // Initialize marketing pixels
    loadScript('https://connect.facebook.net/en_US/fbevents.js');
  }
}

function loadScript(src: string): void {
  const script = document.createElement('script');
  script.src = src;
  script.async = true;
  document.head.appendChild(script);
}
```

---

## 🔗 WHERE TO LINK LEGAL PAGES

Legal pages must be accessible from multiple locations:

| Location | What to Link | Why |
|----------|-------------|-----|
| App footer | All 4 legal pages | Always accessible |
| Signup form | ToS + Privacy Policy (checkbox) | Consent at registration |
| Login page | ToS + Privacy Policy (small link) | Reminder on auth |
| Settings page | Privacy Policy, data export/delete | User rights access |
| Marketing website footer | All 4 legal pages | Pre-signup visibility |
| Cookie banner | Cookie Policy | Direct context |
| Email footer | Unsubscribe + Privacy Policy | CAN-SPAM compliance |

### Signup Form Consent Pattern

```typescript
// components/SignupForm.tsx (consent checkbox section)
<div className="mt-4">
  <label className="flex items-start gap-2">
    <input
      type="checkbox"
      required
      checked={agreedToTerms}
      onChange={(e) => setAgreedToTerms(e.target.checked)}
      className="mt-1"
    />
    <span className="text-sm text-gray-600">
      I agree to the{' '}
      <a href="/terms" target="_blank" className="text-blue-600 underline">
        Terms of Service
      </a>{' '}
      and{' '}
      <a href="/privacy" target="_blank" className="text-blue-600 underline">
        Privacy Policy
      </a>
    </span>
  </label>
</div>
```

### Footer Links Pattern

```typescript
// components/Footer.tsx (legal links section)
<div className="border-t pt-6 mt-8">
  <div className="flex flex-wrap gap-4 text-sm text-gray-500">
    <a href="/terms" className="hover:text-gray-700">Terms of Service</a>
    <a href="/privacy" className="hover:text-gray-700">Privacy Policy</a>
    <a href="/cookies" className="hover:text-gray-700">Cookie Policy</a>
    <a href="/acceptable-use" className="hover:text-gray-700">Acceptable Use</a>
  </div>
  <p className="text-xs text-gray-400 mt-2">
    &copy; {new Date().getFullYear()} YourCompany. All rights reserved.
  </p>
</div>
```

---

## 📍 HOSTING LEGAL PAGES

| Approach | Pros | Cons |
|----------|------|------|
| Marketing website (`/terms`, `/privacy`) | SEO-friendly, accessible without login | Need to maintain separately |
| Inside the app (`/app/legal/terms`) | Single codebase | Not accessible to non-users |
| **Recommended: Both** | Best of both worlds | Link app footer to website versions |

> [!TIP]
> Host the canonical legal pages on your marketing website (publicly accessible, indexable). In your app footer, link to those same pages. This way anyone can read your terms before signing up, and logged-in users can always find them.

---

## 📑 ACCEPTABLE USE POLICY: KEY SECTIONS

| Section | What to Include |
|---------|----------------|
| Prohibited Content | Illegal content, malware, hate speech, spam |
| Prohibited Behavior | Scraping, reverse engineering, DDoS, unauthorized access |
| AI-Specific Rules | No generating harmful content, no bypassing safety filters |
| Resource Limits | Fair use of compute, storage, API calls |
| Account Sharing | Whether multiple users can share one account |
| Enforcement | Warning, suspension, termination process |
| Reporting | How to report violations |

---

## 🔄 KEEPING LEGAL PAGES CURRENT

| Task | Frequency | Notes |
|------|-----------|-------|
| Review all legal pages | Every 6 months | Laws change, features change |
| Update after new feature launch | As needed | New data collection = policy update |
| CCPA annual update | Yearly (January) | California requirement |
| Log changes to ToS | Every change | Date + summary of what changed |
| Notify users of material changes | Every material change | Email + in-app banner |

### Versioning Legal Documents

```typescript
// Add at the top of each legal page
interface LegalDocument {
  title: string;
  effectiveDate: string;
  lastUpdated: string;
  version: string;
}

const termsOfService: LegalDocument = {
  title: 'Terms of Service',
  effectiveDate: '2026-03-01',
  lastUpdated: '2026-02-08',
  version: '1.0',
};
```

---

## ✅ EXIT CHECKLIST

- [ ] Terms of Service page created with all key sections
- [ ] Privacy Policy page created with data collection details
- [ ] Cookie Policy page created with cookie categories
- [ ] Acceptable Use Policy page created
- [ ] Cookie consent banner implemented and functional
- [ ] Banner blocks non-essential cookies until consent given
- [ ] Legal pages linked in app footer
- [ ] Legal pages linked in marketing website footer
- [ ] ToS + Privacy Policy checkbox on signup form
- [ ] Unsubscribe link + Privacy Policy in email footer
- [ ] Third-party services disclosed in Privacy Policy
- [ ] AI provider usage disclosed in Privacy Policy
- [ ] GDPR user rights implemented (access, delete, export)
- [ ] "Do Not Sell" link in footer (CCPA, if applicable)
- [ ] Legal review with attorney scheduled
- [ ] Calendar reminder set for 6-month review

---

*Skill Version: 1.0 | Created: February 2026*
