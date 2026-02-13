---
name: qa_playbook
description: Manual QA testing procedures with structured test cases and severity classification
---

# QA Playbook Skill

**Purpose**: Provide a structured manual testing framework so any team member can systematically verify application quality before releases, catch regressions after deploys, and classify bugs by severity for prioritized resolution.

## 🎯 TRIGGER COMMANDS

```text
"create QA tests"
"manual test plan"
"test playbook"
"regression checklist"
"Using qa_playbook skill: build a test plan for [feature]"
```

## 📋 TEST CASE STRUCTURE

Every test case follows this hierarchy:

```
Section (e.g., Authentication)
  └─ Test Case (e.g., TC-AUTH-001: Login with valid credentials)
       └─ Preconditions
       └─ Steps (numbered, specific)
       └─ Expected Result (one assertion)
       └─ Actual Result (filled during testing)
       └─ Status: Pass / Fail / Blocked / Skipped
```

### Test Case Template

| Field | Description |
|-------|-------------|
| **ID** | `TC-{SECTION}-{NUMBER}` (e.g., `TC-AUTH-001`) |
| **Title** | Short, descriptive action statement |
| **Preconditions** | What must be true before running this test |
| **Steps** | Numbered list of exact actions to perform |
| **Expected Result** | Single, verifiable outcome |
| **Severity** | P0-P4 (see classification below) |

> [!TIP]
> Write test cases so someone who has never seen the app can follow them. Avoid "click the button" -- say "click the blue **Save** button in the top-right corner." Specificity prevents ambiguity.

## 🔐 SECTION 1: AUTHENTICATION FLOW

| ID | Test | Steps | Expected Result | Pass/Fail |
|----|------|-------|-----------------|-----------|
| TC-AUTH-001 | Register with valid email | 1. Navigate to `/register` 2. Enter valid email, password (8+ chars, 1 uppercase, 1 number) 3. Click **Create Account** | Account created, redirect to dashboard, welcome email sent | |
| TC-AUTH-002 | Register with existing email | 1. Navigate to `/register` 2. Enter email that already exists 3. Click **Create Account** | Error: "An account with this email already exists" | |
| TC-AUTH-003 | Login with valid credentials | 1. Navigate to `/login` 2. Enter valid email and password 3. Click **Sign In** | Redirect to dashboard, JWT stored, user menu shows name | |
| TC-AUTH-004 | Login with wrong password | 1. Navigate to `/login` 2. Enter valid email, wrong password 3. Click **Sign In** | Error: "Invalid email or password" (generic, no info leak) | |
| TC-AUTH-005 | Login with non-existent email | 1. Same as TC-AUTH-004 but with non-existent email | Same error: "Invalid email or password" (same message for both cases) | |
| TC-AUTH-006 | JWT expiration | 1. Login successfully 2. Wait for token expiry (or manually expire) 3. Make API request | 401 response, redirect to login page, token cleared | |
| TC-AUTH-007 | Logout | 1. Login successfully 2. Click user menu → **Logout** | Redirect to login, JWT cleared, back button doesn't access dashboard | |
| TC-AUTH-008 | Password reset flow | 1. Click **Forgot Password** 2. Enter email 3. Check email for reset link 4. Click link 5. Enter new password 6. Login with new password | Password updated, old password no longer works | |

## 📝 SECTION 2: CRUD OPERATIONS

For each major entity in the application, test all four operations:

| ID | Test | Steps | Expected Result | Pass/Fail |
|----|------|-------|-----------------|-----------|
| TC-CRUD-001 | Create entity | 1. Navigate to entity list 2. Click **Create New** 3. Fill all required fields 4. Click **Save** | Entity appears in list, success toast shown, data persisted on refresh | |
| TC-CRUD-002 | Create with missing required fields | 1. Navigate to create form 2. Leave required fields empty 3. Click **Save** | Validation errors shown inline for each missing field | |
| TC-CRUD-003 | Read entity list | 1. Navigate to entity list | List loads within 2 seconds, pagination works, correct count shown | |
| TC-CRUD-004 | Read entity detail | 1. Click on entity in list | Detail view shows all fields, data matches what was entered | |
| TC-CRUD-005 | Update entity | 1. Open entity detail 2. Click **Edit** 3. Change a field 4. Click **Save** | Updated value persisted, list reflects change, success toast | |
| TC-CRUD-006 | Delete entity | 1. Open entity detail 2. Click **Delete** 3. Confirm deletion dialog | Entity removed from list, cannot access detail view, 404 if URL visited directly | |
| TC-CRUD-007 | Delete with confirmation cancel | 1. Click **Delete** 2. Click **Cancel** on confirmation dialog | Entity not deleted, dialog closes | |

> [!WARNING]
> Always test the "cancel" path for destructive actions. A common bug is the cancel button still triggering the deletion.

## ⚠️ SECTION 3: ERROR HANDLING

| ID | Test | Steps | Expected Result | Pass/Fail |
|----|------|-------|-----------------|-----------|
| TC-ERR-001 | 404 page | 1. Navigate to `/nonexistent-page` | Custom 404 page shown, navigation still works | |
| TC-ERR-002 | API server down | 1. Stop backend server 2. Try to use the app | Friendly error message, retry button, no blank screens | |
| TC-ERR-003 | Network disconnection | 1. Open DevTools → Network → Offline 2. Try to perform an action | "No internet connection" message, queued actions retry when back online (if applicable) | |
| TC-ERR-004 | Invalid form input | 1. Enter XSS payload `<script>alert(1)</script>` in text fields 2. Submit | Input sanitized or escaped, no script execution, no 500 error | |
| TC-ERR-005 | Concurrent edit conflict | 1. Open entity in two tabs 2. Edit in Tab 1, save 3. Edit in Tab 2, save | Tab 2 gets conflict error or merges gracefully, no silent data loss | |
| TC-ERR-006 | File upload too large | 1. Try to upload a file exceeding the size limit | Clear error: "File exceeds maximum size of X MB" | |
| TC-ERR-007 | Console errors check | 1. Open DevTools Console 2. Navigate through all major pages | No red console errors during normal usage | |

## 🏎️ SECTION 4: PERFORMANCE SPOT-CHECK

Not a load test -- just manual verification that the app feels fast:

| ID | Test | Steps | Expected | Pass/Fail |
|----|------|-------|----------|-----------|
| TC-PERF-001 | Initial page load | 1. Clear cache 2. Navigate to home page 3. Measure in DevTools → Network | First Contentful Paint < 2 seconds | |
| TC-PERF-002 | Dashboard load | 1. Login 2. Time until dashboard is interactive | Time to Interactive < 3 seconds | |
| TC-PERF-003 | Large list performance | 1. Navigate to a list with 100+ items | List renders without jank, scrolling is smooth | |
| TC-PERF-004 | Search response time | 1. Type a search query 2. Measure time to results | Results appear within 500ms of typing | |
| TC-PERF-005 | Form submission | 1. Fill out a form 2. Click **Save** 3. Measure time to success | Response within 1 second, button shows loading state | |

## 🔒 SECTION 5: SECURITY SPOT-CHECK

| ID | Test | Steps | Expected | Pass/Fail |
|----|------|-------|----------|-----------|
| TC-SEC-001 | Access without auth | 1. Clear all cookies/storage 2. Navigate directly to `/dashboard` | Redirect to `/login`, no data leaked | |
| TC-SEC-002 | Access another user's data | 1. Login as User A 2. Note User B's resource ID 3. Navigate to `/resource/{User-B-ID}` | 403 Forbidden or 404 Not Found (never 200 with the data) | |
| TC-SEC-003 | SQL injection | 1. Enter `'; DROP TABLE users; --` in a search field | No error, input treated as literal text | |
| TC-SEC-004 | Sensitive data in URL | 1. Check all URLs in browser | No passwords, tokens, or PII in URL parameters | |
| TC-SEC-005 | HTTPS enforcement | 1. Try to access the app via `http://` in production | Redirected to `https://` | |

## 💳 SECTION 6: SaaS-SPECIFIC TESTS

### Billing & Subscriptions

| ID | Test | Steps | Expected | Pass/Fail |
|----|------|-------|----------|-----------|
| TC-BILL-001 | Subscribe to paid plan | 1. Navigate to billing 2. Select plan 3. Enter test card 4. Confirm | Subscription active, features unlocked, receipt email | |
| TC-BILL-002 | Cancel subscription | 1. Go to billing 2. Click **Cancel** 3. Confirm | Access until end of billing period, downgrade afterward | |
| TC-BILL-003 | Payment failure | 1. Use Stripe test card `4000000000000002` (decline) | Clear error, subscription not activated, can retry | |

### Multi-Tenancy Isolation

| ID | Test | Steps | Expected | Pass/Fail |
|----|------|-------|----------|-----------|
| TC-TENANT-001 | Data isolation | 1. Login as Org A user 2. List all resources | Only Org A resources visible, zero Org B data | |
| TC-TENANT-002 | Cross-tenant API access | 1. As Org A user, call API with Org B resource ID | 403 or 404 (never the actual data) | |

### Role-Based Access

| ID | Test | Steps | Expected | Pass/Fail |
|----|------|-------|----------|-----------|
| TC-ROLE-001 | Admin-only page as member | 1. Login as member role 2. Navigate to admin page | 403 page or redirect, no admin data visible | |
| TC-ROLE-002 | Admin-only action as member | 1. Login as member 2. Try to DELETE via API (Postman/curl) | 403 Forbidden | |

## 🐛 BUG SEVERITY CLASSIFICATION

| Level | Name | Definition | Response Time | Example |
|-------|------|-----------|---------------|---------|
| **P0** | Blocker | App is down, data loss, security breach | Fix within 1 hour | Production database unreachable |
| **P1** | Critical | Major feature completely broken, no workaround | Fix within 4 hours | Users cannot login |
| **P2** | Major | Feature partially broken, workaround exists | Fix within 24 hours | Search returns wrong results |
| **P3** | Minor | Cosmetic issue, minor UX problem | Fix within 1 week | Button text truncated on mobile |
| **P4** | Trivial | Nitpick, suggestion, improvement | Backlog | Favicon missing |

### Bug Report Template

```markdown
## Bug Report: [Short Title]

**Severity**: P[0-4]
**Test Case**: TC-[SECTION]-[NUMBER] (if from test plan)
**Environment**: [Production / Staging / Local]
**Browser**: [Chrome 120 / Firefox 121 / Safari 17]
**URL**: [exact URL where the bug occurs]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [Step where bug occurs]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Screenshots/Videos
[Attach evidence]

### Console Errors
[Paste any errors from browser DevTools]
```

## 🔁 REGRESSION CHECKLIST (5-MINUTE SMOKE TEST)

Run this after **every deploy**:

- [ ] Home page loads without errors
- [ ] Login works with valid credentials
- [ ] Dashboard loads and shows data
- [ ] Create a new entity (any type)
- [ ] Edit the entity you just created
- [ ] Delete the entity
- [ ] Search works and returns results
- [ ] No console errors on any visited page
- [ ] API health check returns 200 (`/health`)

> [!TIP]
> Automate this smoke test with Playwright or Cypress for CI/CD. But always have the manual version as a fallback when automation is broken or not yet written.

## 🧪 EXPLORATORY TESTING GUIDELINES

Dedicated exploratory testing sessions (30-60 minutes) should:

1. **Pick a theme**: "What happens if the user is really fast?" or "What if the data is really large?"
2. **Set a timer**: 30 minutes focused on one area
3. **Take notes continuously**: Record every observation, even non-bugs
4. **Try edge cases**: Empty inputs, very long strings, special characters, rapid clicking, back button
5. **Test on mobile**: Responsive layout, touch targets, keyboard on mobile
6. **Test with slow network**: DevTools → Network → Slow 3G

## 🌐 BROWSER TESTING MATRIX

| Browser | Version | Priority | Notes |
|---------|---------|----------|-------|
| Chrome | Latest | P0 | Primary target |
| Firefox | Latest | P1 | Second priority |
| Safari | Latest | P1 | Different rendering engine |
| Chrome Mobile | Latest | P1 | Android users |
| Safari Mobile | Latest | P1 | iOS users |
| Edge | Latest | P2 | Chromium-based, usually matches Chrome |

> [!WARNING]
> Safari handles dates, modals, and scroll behavior differently from Chrome. Always test on actual Safari, not just "responsive mode" in Chrome DevTools.

## 📊 TEST EXECUTION TRACKING

Track results in a simple table per release:

```markdown
## Release v1.2.0 QA Results — 2026-02-08

**Tester**: [Name]
**Environment**: Staging (staging.example.com)
**Build**: commit abc1234

| Section | Total | Pass | Fail | Blocked | Notes |
|---------|-------|------|------|---------|-------|
| Auth    | 8     | 7    | 1    | 0       | TC-AUTH-006 fails — JWT not expiring |
| CRUD    | 7     | 7    | 0    | 0       | |
| Errors  | 7     | 6    | 0    | 1       | TC-ERR-003 blocked — can't test offline in staging |
| Perf    | 5     | 5    | 0    | 0       | |
| Security| 5     | 5    | 0    | 0       | |

**Overall**: 30/32 passed | 1 fail (P2) | 1 blocked
**Recommendation**: Ship with known issue documented
```

## ✅ EXIT CHECKLIST

- [ ] All P0 (Blocker) test cases pass
- [ ] All P1 (Critical) test cases pass
- [ ] P2 (Major) failures documented with workarounds
- [ ] Regression smoke test passes (all items checked)
- [ ] No console errors during normal usage flows
- [ ] Browser testing completed on Chrome + one other browser
- [ ] Mobile responsiveness verified
- [ ] Bug reports filed for all failures with severity classification
- [ ] Test results documented with pass/fail counts per section

*Skill Version: 1.0 | Created: February 2026*
