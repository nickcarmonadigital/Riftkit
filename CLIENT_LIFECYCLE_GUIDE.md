# Client Project Lifecycle Guide

> **The "Meta Workflow" for building, shipping, and handing over client projects.**

This guide maps the 6 core stages of software delivery to the specific AI workflows included in this framework. Follow this linear path to ensure consistency, security, and quality from day one.

---

## 1. Design & Plan

**Goal:** A signed-off specification and approved UI/UX design.

* **Step 1: `/1-brainstorm`**
  * *Usage:* "Run /1-brainstorm to get my ideas for [Project X] on paper."
  * *Output:* A raw `feature_braindump.md` file with all your scattered thoughts organized.
* **Step 2: `/2-design`**
  * *Usage:* "Run /2-design to turn the braindump into a technical architecture."
  * *Output:* `implementation_plan.md` and `atomic_reverse_architecture.md`.
* **Step 3: `/toolkit/design-review`**
  * *Usage:* "Run /toolkit/design-review on these mockups [upload images] or this description."
  * *Output:* `ui_ux_review.md` with improvements for accessibility, aesthetics, and flow.

---

## 2. Build

**Goal:** A functional, bug-free application.

* **Step 1: `/new-project`**
  * *Usage:* "Run /new-project to set up the boilerplate."
  * *Output:* Folder structure, config files, and initialized git repo.
* **Step 2: `/3-build`**
  * *Usage:* "Run /3-build for the User Auth feature."
  * *Output:* The actual code implementation + `code_changelog.md`.
* **Step 3: `/debug`**
  * *Usage:* "Run /debug. The login button is not working."
  * *Output:* Root cause analysis and a fixed codebase.
* **Step 4: `/post-task`**
  * *Usage:* "Run /post-task." (Run this after *every* significant session).
  * *Output:* Updated usage guides and context files.

---

## 3. Secure

**Goal:** A hardened application safe for public release.

* **Step 1: `/4-secure`**
  * *Usage:* "Run /4-secure to check for security vulnerabilities."
  * *Output:* `security_audit.md` with a list of Critical, High, and Medium risks to fix.

---

## 4. Ship

**Goal:** Deployment to production.

* **Step 1: `/5-ship`**
  * *Usage:* "Run /5-ship to prepare for release."
  * *Output:* `release_notes.md`, version bump, and final pre-flight checklist.
* **Step 2: `/launch`**
  * *Usage:* "Run /launch to go live."
  * *Output:* DNS verification, SSL check, and "Hello World" in production.

---

## 5. Handover

**Goal:** Transfer ownership to the client (or your future self).

* **Step 1: `/6-handoff`**
  * *Usage:* "Run /6-handoff."
  * *Output:* `EXIT_PACKAGE.md` containing credential maps, admin guides, and training videos.

---

## 6. Maintain

**Goal:** Long-term stability and updates.

* **Step 1: `/7-maintenance`**
  * *Usage:* "Run /7-maintenance to upgrade dependencies."
  * *Output:* Dependency audit and upgrade plan.

---

## Summary Checklist

* [ ] **Design**: `/1-brainstorm` -> `/2-design` -> `/design-review`
* [ ] **Build**: `/new-project` -> `/3-build` -> `/debug` -> `/post-task`
* [ ] **Secure**: `/4-secure`
* [ ] **Ship**: `/5-ship` -> `/launch`
* [ ] **Handover**: `/6-handoff`
* [ ] **Maintain**: `/7-maintenance`
