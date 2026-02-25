---
name: Accessibility Design
description: WCAG 2.1/2.2 conformance planning with keyboard navigation, ARIA patterns, and accessible form validation design
---

# Accessibility Design Skill

**Purpose**: Establishes the accessibility architecture during Phase 2 so that WCAG conformance is designed in rather than patched after build. Defines the target conformance level, keyboard navigation patterns, ARIA landmark strategy, color contrast requirements, and produces an accessibility checklist that Phase 3 frontend developers must satisfy.

## TRIGGER COMMANDS

```text
"Design accessibility for [product]"
"Define WCAG requirements"
"Accessibility plan"
```

## When to Use
- When building any user-facing web or mobile application
- When the product targets public-sector, healthcare, or education users
- When European Accessibility Act 2025 (EAA) compliance is required
- When the product roadmap includes accessibility as a first-class concern

---

## PROCESS

### Step 1: Set WCAG Conformance Target

Select the target level based on product context:

| Level | Criteria Count | When to Choose |
|-------|---------------|----------------|
| **A** | 30 criteria | Absolute minimum, internal tools only |
| **AA** | 50 criteria | Industry standard, most products should target this |
| **AAA** | 78 criteria | Specialized accessibility products, government |

**Decision factors**:
- Legal/regulatory: EAA and ADA lawsuits typically require AA
- User base: If users include assistive technology users, AA minimum
- Market: Enterprise SaaS buyers increasingly require VPAT/AA

Document the decision as: "Target: WCAG 2.2 Level AA" with rationale.

### Step 2: Define Keyboard Navigation Patterns

For each complex UI component, specify the keyboard interaction model:

```markdown
## Keyboard Navigation Patterns

| Component | Keys | Behavior |
|-----------|------|----------|
| Modal Dialog | Tab/Shift+Tab | Trap focus within modal |
| | Escape | Close modal, return focus to trigger |
| Dropdown Menu | Arrow Down/Up | Navigate options |
| | Enter/Space | Select option |
| | Escape | Close, return focus to trigger |
| Tab Panel | Arrow Left/Right | Switch between tabs |
| | Tab | Move into tab content |
| Data Table | Arrow keys | Navigate cells |
| | Enter | Activate cell action |
| Toast/Alert | (automatic) | Announced by screen reader, no focus steal |
```

**Focus management rules**:
- Focus must be visible at all times (no `outline: none` without replacement)
- Focus order must follow logical reading order (no positive `tabindex`)
- Focus must move to new content after navigation (SPA route changes)

### Step 3: Specify ARIA Landmarks and Roles

Define the landmark structure for the application:

```html
<body>
  <header role="banner">         <!-- Site header, logo, global nav -->
    <nav role="navigation">      <!-- Primary navigation -->
  </header>
  <aside role="complementary">   <!-- Sidebar, secondary info -->
  </aside>
  <main role="main">             <!-- Primary page content -->
    <form role="form">           <!-- Data entry forms -->
    <section role="region">      <!-- Distinct content sections -->
  </main>
  <footer role="contentinfo">    <!-- Site footer -->
  </footer>
</body>
```

**ARIA rules**:
- Use semantic HTML first; only add ARIA when native semantics are insufficient
- Every `role` must have an accessible name (`aria-label` or `aria-labelledby`)
- Dynamic content regions use `aria-live="polite"` (or `assertive` for errors)
- Custom widgets must implement the corresponding WAI-ARIA Authoring Practices pattern

### Step 4: Define Color and Contrast Requirements

```markdown
## Color Contrast Requirements

| Element | Minimum Ratio (AA) | Enhanced Ratio (AAA) |
|---------|--------------------|--------------------|
| Normal text (< 18px) | 4.5:1 | 7:1 |
| Large text (>= 18px or 14px bold) | 3:1 | 4.5:1 |
| UI components and icons | 3:1 | 3:1 |
| Focus indicators | 3:1 | 3:1 |

## Color Independence Rule
Information must NEVER be conveyed by color alone. Always pair with:
- Text labels
- Icons or patterns
- Underlines (for links)

Example: Error state = red border + error icon + error text message
```

### Step 5: Accessible Form Validation Patterns

```markdown
## Form Validation Requirements

1. **Error identification**: Errors must identify the specific field and describe the error
2. **Error suggestion**: When the error is detectable, provide a correction suggestion
3. **Error association**: Use `aria-describedby` linking error messages to fields
4. **Error timing**: Validate on submit (not on blur for screen reader users)
5. **Success confirmation**: Announce successful submission via `aria-live` region

## Pattern
<label for="email">Email address</label>
<input id="email" aria-describedby="email-error" aria-invalid="true" />
<span id="email-error" role="alert">Enter a valid email address</span>
```

### Step 6: Produce Accessibility Requirements Checklist

Generate the checklist that Phase 3 developers must satisfy before feature completion.

---

## OUTPUT

**Path**: `.agent/docs/2-design/accessibility-design.md`

---

## CHECKLIST

- [ ] WCAG conformance level chosen with documented rationale
- [ ] Keyboard navigation patterns defined for all complex components
- [ ] Focus management rules established (trap, restore, visible indicator)
- [ ] ARIA landmark structure defined for the application shell
- [ ] Custom widgets mapped to WAI-ARIA Authoring Practices patterns
- [ ] Color contrast ratios specified per element type
- [ ] Color independence rule documented with examples
- [ ] Form validation pattern defined with error association
- [ ] Screen reader announcement strategy for dynamic content
- [ ] Phase 3 accessibility checklist produced for developers
- [ ] Testing tools specified (axe-core, Lighthouse, NVDA/VoiceOver)

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P2*
