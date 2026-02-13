---
name: Gemini Handoff
description: Standardized format for ingesting specs from Gemini (Product Architect).
---

# Gemini Handoff

**Trigger**: "Here's the spec from Gemini" or "Incoming from Architect"

## When to use

Use this skill when you have verified a plan with Gemini (the Product Architect) and are ready to hand it over to the Builder AI (Cursor/Windsurf) for implementation.

## Process

1. **Paste**: Paste the full markdown spec from Gemini.
2. **Analyze**: Builder AI reads the spec to understand:
    * Files to create/modify.
    * Libraries to install.
    * Step-by-step implementation plan.
3. **Execute**: Builder AI starts the `spec_build` loop.

## The Format

The handoff should ideally look like this:

```markdown
# [Feature Name] Implementation Plan

## Files
- `src/components/NewFeature.tsx`
- `src/utils/helper.ts`

## Steps
1. Install dependencies...
2. Create component...
3. Add tests...
```

## Checklist

- [ ] Spec pasted
* [ ] Builder AI acknowledged receipt
* [ ] Implementation plan created (`spec_build`)
