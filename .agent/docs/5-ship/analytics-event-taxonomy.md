# Analytics Event Taxonomy

**Purpose**: Standardized event naming and tracking plan for product analytics (PostHog, Mixpanel, Amplitude, or similar).

---

## 1. Naming Convention

**Format**: `noun_verb` in snake_case, past tense.

| Pattern | Example | Description |
|---------|---------|-------------|
| `noun_verbed` | `contact_created` | A resource was created |
| `noun_verbed` | `pipeline_updated` | A resource was modified |
| `noun_verbed` | `document_deleted` | A resource was removed |
| `action_verbed` | `signup_completed` | A user action finished |
| `feature_verbed` | `ai_chat_sent` | A feature was used |

**Rules**:
- Always snake_case, always past tense
- Noun first, then verb: `page_viewed` not `viewed_page`
- Be specific: `contact_created` not `item_created`
- No abbreviations: `organization_switched` not `org_switched`
- Prefix with feature area for clarity when needed: `billing_plan_upgraded`

---

## 2. Auth Events

| Event Name | When Fired | Properties |
|------------|------------|------------|
| `signup_started` | User lands on signup page | `{ source: "website" \| "invite" \| "direct" }` |
| `signup_completed` | Account created successfully | `{ method: "email" \| "google" \| "github", plan: "free" }` |
| `login_completed` | Successful login | `{ method: "email" \| "google" \| "github" }` |
| `login_failed` | Failed login attempt | `{ reason: "invalid_password" \| "account_locked" \| "not_found" }` |
| `logout_completed` | User logged out | `{}` |
| `password_reset_requested` | Reset email sent | `{}` |
| `password_reset_completed` | Password successfully changed | `{}` |
| `onboarding_step_completed` | Each onboarding step finished | `{ step: number, step_name: string }` |
| `onboarding_completed` | Full onboarding flow done | `{ duration_seconds: number }` |
| `onboarding_skipped` | User skipped onboarding | `{ skipped_at_step: number }` |

---

## 3. Feature Events

| Event Name | When Fired | Properties |
|------------|------------|------------|
| `page_viewed` | Any page navigation | `{ page: string, referrer: string }` |
| `contact_created` | New contact added | `{ source: "manual" \| "import" \| "api" }` |
| `contact_updated` | Contact edited | `{ fields_changed: string[] }` |
| `contact_deleted` | Contact removed | `{}` |
| `contact_imported` | Bulk import completed | `{ count: number, source: "csv" \| "api" }` |
| `pipeline_created` | New pipeline created | `{ template: string \| null }` |
| `pipeline_updated` | Pipeline modified | `{ change_type: "stage_added" \| "stage_removed" \| "renamed" }` |
| `deal_stage_changed` | Deal moved to new stage | `{ from_stage: string, to_stage: string, deal_value: number }` |
| `document_created` | Document generated | `{ type: "proposal" \| "invoice" \| "contract" }` |
| `ai_chat_sent` | AI chat message sent | `{ provider: string, model: string, token_count: number }` |
| `ai_response_received` | AI response returned | `{ provider: string, latency_ms: number, token_count: number }` |
| `search_performed` | User searched | `{ query_length: number, results_count: number, area: string }` |
| `export_completed` | Data exported | `{ format: "csv" \| "pdf" \| "json", record_count: number }` |
| `integration_connected` | Third-party connected | `{ provider: string }` |
| `integration_disconnected` | Third-party disconnected | `{ provider: string, reason: "manual" \| "error" }` |

---

## 4. Billing Events

| Event Name | When Fired | Properties |
|------------|------------|------------|
| `billing_plan_viewed` | Pricing page opened | `{ current_plan: string }` |
| `billing_plan_upgraded` | Upgrade completed | `{ from_plan: string, to_plan: string, billing_period: "monthly" \| "annual" }` |
| `billing_plan_downgraded` | Downgrade completed | `{ from_plan: string, to_plan: string }` |
| `billing_plan_cancelled` | Subscription cancelled | `{ plan: string, reason: string, feedback: string }` |
| `billing_payment_succeeded` | Payment processed | `{ amount_cents: number, currency: string }` |
| `billing_payment_failed` | Payment failed | `{ reason: string }` |
| `billing_trial_started` | Trial period began | `{ plan: string, trial_days: number }` |
| `billing_trial_ended` | Trial expired | `{ converted: boolean }` |

---

## 5. Error Events

| Event Name | When Fired | Properties |
|------------|------------|------------|
| `error_api` | API call returned error | `{ endpoint: string, status_code: number, error_message: string }` |
| `error_ui` | Unhandled frontend error caught | `{ component: string, error_message: string, stack: string }` |
| `error_validation` | Form validation failed | `{ form: string, fields: string[] }` |
| `error_timeout` | Request timed out | `{ endpoint: string, timeout_ms: number }` |

---

## 6. User Properties (set on identify)

Set these properties when calling `posthog.identify(userId, properties)`:

| Property | Type | Description |
|----------|------|-------------|
| `email` | string | User email |
| `name` | string | Full name |
| `role` | string | User role (admin, member, viewer) |
| `org_id` | string | Current organization ID |
| `org_name` | string | Current organization name |
| `plan` | string | Current billing plan |
| `signup_date` | datetime | When user registered |
| `last_login` | datetime | Most recent login |
| `feature_flags` | string[] | Active feature flags |
| `onboarding_completed` | boolean | Whether onboarding is done |

---

## 7. Group / Organization Properties

Set these when calling `posthog.group('organization', orgId, properties)`:

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Organization name |
| `plan` | string | Billing plan |
| `member_count` | number | Total members |
| `created_at` | datetime | Org creation date |
| `mrr_cents` | number | Monthly recurring revenue |
| `industry` | string | Self-reported industry |
| `features_used` | string[] | List of features used at least once |

---

## 8. Dashboard Templates

### Activation Funnel

Track: `signup_completed` -> `onboarding_completed` -> `contact_created` -> Day 7 return visit

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Signup to onboarding complete | > 60% | Funnel: signup_completed -> onboarding_completed |
| Onboarding to first value action | > 40% | Funnel: onboarding_completed -> contact_created |
| Day 1 retention | > 50% | Users who return within 24h of signup |
| Day 7 retention | > 25% | Users who return within 7 days of signup |

### Feature Adoption

| Metric | How to Measure |
|--------|----------------|
| Feature usage by plan | Count events grouped by user plan property |
| Most used features | Top events by count (exclude page_viewed) |
| Feature discovery time | Time from signup to first use of each feature |
| Power users | Users with > 50 events per week |

### Revenue Metrics

| Metric | How to Measure |
|--------|----------------|
| Trial to paid conversion | billing_trial_ended where converted = true |
| Upgrade rate | billing_plan_upgraded count / total active users |
| Churn rate | billing_plan_cancelled count / total paid users |
| Revenue per user | Sum of billing_payment_succeeded.amount_cents / active paid users |

### Error Health

| Metric | Target | How to Measure |
|--------|--------|----------------|
| API error rate | < 1% | error_api count / total API calls |
| UI error rate | < 0.1% | error_ui count / total page views |
| P95 response time | < 500ms | Backend performance monitoring |
