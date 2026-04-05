---
name: Form UX Mastery
description: Design and build high-converting forms with proper validation, multi-step flows, smart defaults, mobile optimization, and accessible error handling
---

# Form UX Mastery

**Purpose**: Build forms that users actually complete — using proven patterns for field design, validation, multi-step flows, smart defaults, mobile optimization, and error recovery that maximize conversion while maintaining accessibility.

---

## TRIGGER COMMANDS

```text
"Fix the form UX on [page]"
"Build a multi-step form for [purpose]"
"Users are abandoning the form at [step]"
"Make this form mobile-friendly"
"Add proper validation to [form]"
"Using form_ux_mastery skill: [target]"
```

---

## WHEN TO USE

- Building any form with more than 3 fields
- Form completion rates are below 60%
- Redesigning checkout, registration, or onboarding forms
- Adding validation to existing forms
- Optimizing forms for mobile users

---

## 1. FORM FIELD DESIGN

### Label Placement

| Placement | Pros | Cons | Use When |
|---|---|---|---|
| **Top-aligned** | Fastest completion, best mobile | Uses vertical space | Default choice, mobile forms |
| **Left-aligned** | Scannable, familiar | Slower completion, bad on mobile | Wide desktop forms with short labels |
| **Floating labels** | Space-efficient, modern feel | Accessibility concerns, less scannable | Space-constrained UI, secondary forms |
| **Inline/placeholder only** | Most compact | Terrible UX — label disappears on focus | Never (anti-pattern) |

### Field Sizing Rules
- **Match expected input length** — don't use a full-width field for a ZIP code
- **Consistent width** for fields in the same group (e.g., all address fields same width)
- **Minimum touch target**: 48px height on mobile, 40px on desktop
- **Minimum label font size**: 14px (never smaller)

### Required vs Optional
- If most fields are required → mark the few **optional** ones "(optional)"
- If most fields are optional → mark the few **required** ones with `*`
- Never use color alone to indicate required (accessibility fail)

### Field Type Selection

| Input | Use | Don't Use |
|---|---|---|
| **Text input** | Names, addresses, free-form | When options are limited |
| **Select/dropdown** | 5-15 predefined options | <5 options (use radio), >15 (use search) |
| **Radio buttons** | 2-5 mutually exclusive options | >5 options |
| **Checkboxes** | Multi-select, boolean toggles | Mutually exclusive options |
| **Date picker** | Selecting specific dates | Entering birthdates (use 3 dropdowns or text) |
| **Toggle** | Binary on/off with instant effect | When user needs to "submit" the change |
| **Textarea** | Multi-line input (comments, bio) | Single-line input |

### Checklist
```
[ ] Labels are top-aligned (or floating for space-constrained)
[ ] Field sizes match expected input length
[ ] Required/optional clearly indicated
[ ] Correct input type used for each field
[ ] Touch targets are 48px+ on mobile
[ ] Tab order follows visual order
[ ] Autofocus on first field when form loads
```

---

## 2. VALIDATION PATTERNS

### Validation Timing

| Timing | When to Use | How |
|---|---|---|
| **On blur (field exit)** | Default for most fields | Validate when user tabs/clicks away |
| **On input (real-time)** | Password strength, character counts | Validate as user types |
| **On submit** | Last resort, complex cross-field validation | Validate all fields on submit click |
| **Never on focus** | — | Don't show errors before user has typed anything |

### Validation Rules
- **Validate on blur** for most fields — not on every keystroke
- **Positive validation** — show green checkmark when field is valid (don't just show red for errors)
- **Don't validate empty fields on blur** — only validate once user has entered and left the field
- **Password fields** — real-time strength meter as user types
- **Email fields** — validate on blur, allow `+` aliases

### Error Message Design

| Element | Rule |
|---|---|
| **Placement** | Directly below the field, not in a toast or alert banner |
| **Color** | Red text (#DC2626 or similar) + red border on field |
| **Icon** | Error icon (!) to the left of message (don't rely on color alone) |
| **Copy** | Specific: "Email must include @" not "Invalid input" |
| **Timing** | Appear on blur, disappear as soon as user starts fixing |
| **Screen reader** | `aria-describedby` linking field to error, `aria-invalid="true"` |

### Error Message Copy Rules

| Bad | Good | Why |
|---|---|---|
| "Invalid input" | "Enter a valid email (e.g., name@example.com)" | Specific + example |
| "Error" | "Password must be at least 8 characters" | Actionable |
| "Required" | "Enter your first name" | Context-specific |
| "Invalid date" | "Enter a date in MM/DD/YYYY format" | Shows expected format |
| "Passwords don't match" | "Passwords don't match — re-enter your password" | Tells what to do |

### Checklist
```
[ ] Validation triggers on blur, not on focus or every keystroke
[ ] Positive validation (green checkmarks) for completed fields
[ ] Error messages appear below the field, not in banners
[ ] Every error message says what to do to fix it
[ ] Errors clear as soon as user starts correcting
[ ] Password has real-time strength indicator
[ ] Required field validation doesn't fire on empty blur (first visit)
[ ] aria-invalid and aria-describedby set on error fields
```

---

## 3. MULTI-STEP FORMS

### When to Use Multi-Step
- Form has **more than 7 fields**
- Fields have **natural groupings** (personal info → address → payment)
- Collecting information that **builds on previous answers** (conditional logic)
- User research shows **single-page form feels overwhelming**

### Multi-Step Rules
```
[ ] Maximum 5 steps (3-4 is ideal)
[ ] Progress indicator visible: step names + current position
[ ] "Back" button on every step (never trap users)
[ ] Save progress between steps (don't lose data on browser back)
[ ] First step is the easiest (build momentum)
[ ] Last step is review/confirm (reduce errors)
[ ] Step titles are descriptive: "Your Details" not "Step 1"
[ ] Each step fits above the fold without scrolling
```

### Progress Indicator Patterns

| Pattern | Use When |
|---|---|
| **Step counter** ("Step 2 of 4") | Simple forms, <5 steps |
| **Named steps** (breadcrumb-style) | Steps have meaningful names |
| **Progress bar** | Percentage completion matters |
| **Don't show steps** | 2-step form (step indicator adds more cognitive load than it saves) |

### Save & Resume
- Save after each step completion (not just on submit)
- If user returns after abandoning, resume from last completed step
- Show "Welcome back! You left off at [step name]" message
- Allow restarting from scratch

---

## 4. SMART DEFAULTS & AUTOFILL

### Default Values

| Field | Smart Default |
|---|---|
| Country | Geo-detect from IP |
| Currency | Match detected country |
| Phone code | Match detected country (+1, +44, etc.) |
| Language | Browser language setting |
| Date format | Match locale (MM/DD vs DD/MM) |
| Timezone | Browser timezone |
| Shipping = Billing | Default checked (most common case) |

### Browser Autofill Optimization
- Use correct `autocomplete` attributes on every field
- Common values: `name`, `email`, `tel`, `street-address`, `postal-code`, `cc-number`
- Use `type="email"` for email fields (triggers mobile keyboard)
- Use `type="tel"` for phone fields
- Use `inputmode="numeric"` for numeric-only fields (ZIP, credit card)

### Conditional Logic
- Show/hide fields based on previous answers (don't show irrelevant fields)
- Pre-fill fields when answers can be inferred
- Remember user preferences across sessions (with consent)

### Checklist
```
[ ] Country/locale auto-detected from browser/IP
[ ] All fields have correct autocomplete attributes
[ ] Input types match content (email, tel, url, number)
[ ] Conditional fields hidden until relevant
[ ] Previous session data pre-filled (with consent)
[ ] "Same as above" shortcuts for duplicate data (billing = shipping)
```

---

## 5. MOBILE FORM OPTIMIZATION

### Mobile-Specific Rules
- **Touch target minimum**: 48px x 48px for all interactive elements
- **Input height**: 48px minimum (44px absolute minimum)
- **Font size**: 16px minimum for inputs (prevents iOS zoom on focus)
- **Padding between fields**: 16px minimum
- **Labels above fields always** — never left-aligned on mobile

### Keyboard Optimization

| Field Type | inputmode | Keyboard Shown |
|---|---|---|
| Email | `email` | @ and . easily accessible |
| Phone | `tel` | Numeric dialpad |
| Number | `numeric` | Number pad |
| URL | `url` | / and .com accessible |
| Search | `search` | Search/Go button |
| Credit card | `numeric` | Number pad |
| ZIP code | `numeric` | Number pad |

### Thumb Zone Design
- Primary actions (Submit, Next) in the **bottom-center** thumb zone
- Avoid placing critical buttons in top corners (hard to reach)
- Single-column layout only — never side-by-side fields on mobile
- Sticky submit button at bottom of screen for long forms

### Checklist
```
[ ] All inputs are 48px+ height with 16px+ font size
[ ] Correct inputmode set for every field (numeric, email, tel)
[ ] Single-column layout on mobile (no side-by-side)
[ ] Submit button in thumb-reachable zone
[ ] No iOS zoom on focus (font-size >= 16px)
[ ] Fields don't require horizontal scrolling
[ ] Tested on both iOS and Android real devices
```

---

## 6. ERROR PREVENTION & RECOVERY

### Prevention Techniques

| Technique | Example |
|---|---|
| **Input masks** | Phone: (___) ___-____, Date: __/__/____ |
| **Character counters** | "42/280 characters" for bio fields |
| **Format hints** | "MM/DD/YYYY" below date field |
| **Confirmation fields** | "Re-enter email" for critical fields |
| **Undo** | "You deleted 3 items. Undo?" for destructive actions |
| **Type-ahead** | Suggest valid options as user types (addresses, cities) |

### Destructive Action Protection
- **Confirmation dialog** for delete/remove actions
- **Type to confirm** for high-risk actions ("Type DELETE to confirm")
- **Undo window** (5-10 seconds) instead of immediate execution
- **Soft delete** — mark as deleted, allow recovery for 30 days

### Recovery After Errors
```
[ ] Form data persists after validation errors (no field clearing)
[ ] Submit button shows loading state (no double-submit)
[ ] Network error: "Couldn't save — your data is safe, try again"
[ ] Server error: specific message + retry button
[ ] Session timeout: saved draft available on re-login
[ ] Browser back: form state preserved
```

---

## 7. ACCESSIBLE FORMS

### Required ARIA Attributes

| Scenario | Attribute |
|---|---|
| Field has error | `aria-invalid="true"` + `aria-describedby="error-id"` |
| Field has help text | `aria-describedby="help-text-id"` |
| Required field | `aria-required="true"` (or HTML `required`) |
| Field group | `<fieldset>` + `<legend>` for radio/checkbox groups |
| Live error updates | `aria-live="polite"` on error container |
| Loading state | `aria-busy="true"` on form during submission |

### Focus Management
- On validation error → focus the first invalid field
- On step change (multi-step) → focus the first field of new step
- On success → focus the success message or next logical element
- Never trap focus inside a form section

### Screen Reader Testing
```
[ ] Every field has a visible <label> with for/id match
[ ] Error messages are announced when they appear
[ ] Form purpose is clear from heading or aria-label
[ ] Required fields are announced as required
[ ] Fieldsets group related fields with descriptive legends
[ ] Submit button label describes the action ("Create Account" not "Submit")
```

---

## 8. FORM CONVERSION OPTIMIZATION

### Field Reduction
- Every field you add reduces conversion by ~7%
- Ask: "Do we NEED this at sign-up, or can we ask later?"
- Name: one field ("Full Name") unless legal requirement for separate first/last
- Phone: don't ask unless you'll actually call/text
- Company: ask later unless B2B product

### Trust Signals Near Submit
```
[ ] Security badge near payment fields ("256-bit encryption")
[ ] Privacy statement near email field ("We'll never share your email")
[ ] Social proof near submit ("Join 50,000+ users")
[ ] Money-back guarantee near purchase button
[ ] Terms link (not full text) near submit
```

### Submit Button Design
- **Specific label**: "Create Free Account" not "Submit"
- **Color**: Primary action color, highest contrast on page
- **Size**: Larger than other buttons, full-width on mobile
- **Position**: Below last field, left-aligned or centered
- **Loading state**: Disable + spinner + "Creating account..." text
- **Never "Submit"** — always describe what happens

---

## EXIT CRITERIA

```
[ ] Labels are properly positioned (top-aligned default)
[ ] Every field uses correct input type and autocomplete attribute
[ ] Validation fires on blur with specific, actionable error messages
[ ] Multi-step forms have progress indicator and back button
[ ] Smart defaults reduce manual entry (geo-detect, autofill)
[ ] Mobile: 48px targets, 16px font, correct inputmode, single column
[ ] Error prevention in place (masks, hints, undo for destructive actions)
[ ] All ARIA attributes set (aria-invalid, aria-describedby, aria-required)
[ ] Focus management handles error states and step transitions
[ ] Submit button has specific label and loading state
[ ] Form tested on mobile (iOS + Android) and screen reader
[ ] Conversion optimized: minimum fields, trust signals, clear CTA
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: UX research + form conversion optimization studies*
