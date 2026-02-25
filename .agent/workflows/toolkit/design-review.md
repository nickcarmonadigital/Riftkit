---
description: Review UI/UX designs before implementation, integrate with external design tools
---

# /design-review Workflow

> Use before building frontend to review designs and integrate with tools like Google Stitch

## When to Use

- Before implementing UI components
- When you have mockups to review
- To get design approval before coding
- To integrate with Stitch-generated designs

---

## Step 1: Read Design Skills

// turbo

```bash
view_file .agent/skills/website_build/SKILL.md
view_file .agent/docs/2-design/frontend-architect-standards.md
```

---

## Step 2: Gather Design Inputs

Collect all design assets:

- [ ] Mockups from Stitch/Figma
- [ ] Brand guidelines
- [ ] Color palette
- [ ] Typography choices
- [ ] Component examples

---

## Step 3: External Tool Integration

### For Google Stitch Designs

1. Export design as PNG/SVG or get component code
2. Translate to React/Next.js components
3. Apply your design system tokens
4. Keep Stitch's visual intent, adapt to your stack

### For Figma Designs

1. Extract design tokens (colors, spacing, fonts)
2. Export assets (icons, images)
3. Note component patterns

---

## Step 4: Design System Check

Using website_build skill and frontend-architect-standards:

- [ ] Colors from palette (no generic AI slop blues)
- [ ] Typography is distinctive (not Inter/Roboto)
- [ ] Spacing uses 8px grid
- [ ] Consistent border-radius
- [ ] Hover/focus states defined
- [ ] Mobile-first responsive

---

## Step 5: Accessibility Review

- [ ] Color contrast 4.5:1 minimum
- [ ] Touch targets 44px minimum
- [ ] Focus states visible
- [ ] Semantic HTML planned

---

## Step 6: User Approval

**STOP HERE** - Present design decisions to user:

- Color palette
- Typography
- Key component patterns
- Responsive approach

Get approval before proceeding to /build.

---

## Exit Checklist

- [ ] All design assets collected
- [ ] Design system tokens defined
- [ ] Accessibility requirements met
- [ ] User approved the approach
- [ ] Ready for /build workflow
