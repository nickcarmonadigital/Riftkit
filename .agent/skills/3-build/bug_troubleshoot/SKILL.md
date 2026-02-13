---
name: Bug Troubleshoot
description: Structured process for identifying, isolating, and fixing bugs.
---

# Bug Troubleshoot

**Trigger**: "Bug: [description]", "It's broken", or "Error: [message]"

## When to use

Use this skill whenever you encounter an unexpected error, a test failure, or broken functionality.

## Process

1. **Define**: Fill out the bug report template:
    * **Expected**: What should happen?
    * **Actual**: What is happening?
    * **Steps**: How to reproduce it?
    * **Error Logs**: Copy/paste full stack traces.
    * **Recent Changes**: What did we just touch?

2. **Isolate**:
    * Can you reproduce it consistently?
    * Is it a frontend or backend issue?
    * Is it data-related?

3. **Fix**:
    * Propose a fix.
    * Implement the fix.

4. **Verify**:
    * Run the reproduction steps again to confirm the fix.
    * Run regression tests to ensure nothing else broke.

## Checklist

- [ ] Bug reproduced
* [ ] Root cause identified
* [ ] Fix implemented
* [ ] Fix verified
