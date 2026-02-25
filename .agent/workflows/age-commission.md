---
description: Commission an Adversarial Gap Engine (AGE) study on a topic.
---

# WORKFLOW: Commission Adversarial Gap Engine

**Purpose**: To launch a 25-loop deep-dive analysis on a complex topic using the Team of Rivals.

## 1. Setup

- [ ] Define the [Topic] clearly (e.g., "Cybersecurity AI Agent Team").
- [ ] Ensure `.agent/skills/9-intelligence/adversarial_gap_engine/memory/gaps.log` is empty (or backup old one).

## 2. Commissioning

Run the following prompt to the AI:

```
Using adversarial_gap_engine: Commission a 25-loop study on [Topic].
I want the Analyst, Adversary, Auditor, and Architect to debate each finding.
After 25 loops, have the CEO synthesize the results into 'synthesized-gaps.md'.
```

## 3. Review

- [ ] Watch the logs appear in `gaps.log`.
- [ ] Review the final `synthesized-gaps.md`.
- [ ] Decide which agents/skills to build based on the report.
