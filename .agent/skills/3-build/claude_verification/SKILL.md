---
name: Claude Verification
description: High-level code review and security check by a second intelligence (Claude/Gemini).
---

# Claude Verification

**Trigger**: "Review this code", "Check for security issues", or "Verify my changes"

## When to use

Use this skill after completing a significant feature or complex refactor, before considering the task "Done". It acts as a second pair of eyes.

## Process

1. **Prepare**: Gather the files you changed.
2. **Prompt**: Ask the reviewer (Claude/Gemini) to check for:
    * **Logic Errors**: Edge cases, off-by-one errors, infinite loops.
    * **Security**: Injection queries, exposed secrets, missing auth.
    * **Performance**: N+1 queries, memory leaks.
    * **Style**: Consistency with the codebase.
3. **Review**: Read the feedback.
4. **Action**:
    * If **Approved**: Proceed.
    * If **Issues**: Create a list of fixes and implement them immediately.

## Checklist

- [ ] Code diff prepared
* [ ] Review requested
* [ ] Feedback analyzed
* [ ] Critical issues fixed
