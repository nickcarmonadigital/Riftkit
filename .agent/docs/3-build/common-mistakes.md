# Common Mistakes to Avoid

Learn from others' failures. These are the most common mistakes when building with AI coding assistants.

---

## 🚫 Prompting Mistakes

### 1. Being Too Vague

❌ **Bad**: "Build me a login page"

✅ **Good**: "Build a login page with email/password fields, forgot password link, 'remember me' checkbox, and redirect to /dashboard on success. Use React + Tailwind. Include form validation and error states."

**Why it matters**: Vague prompts = unpredictable outputs. The AI will fill in gaps with assumptions that may not match your needs.

---

### 2. Not Providing Context

❌ **Bad**: "Fix this bug" + [code snippet]

✅ **Good**: "This login form isn't submitting. When I click Submit, nothing happens. No console errors. Expected: form should POST to /api/auth/login and redirect to dashboard. Here's the relevant code: [code] and here's the API route it should hit: [code]"

**Why it matters**: The AI can't see your full codebase. Context is everything.

---

### 3. Accepting First Output

❌ **Bad**: Copy-paste whatever the AI generates without review

✅ **Good**:

- Read the code
- Ask "what does this line do?"
- Test edge cases
- Request improvements

**Why it matters**: AI-generated code often works for the happy path but misses edge cases, security considerations, and best practices.

---

### 4. Not Iterating

❌ **Bad**: Give up if first response isn't perfect

✅ **Good**:

- "This is close but the button should be on the right"
- "Can you add error handling for network failures?"
- "Make this more performant"

**Why it matters**: AI coding is a conversation, not a vending machine.

---

## 💻 Technical Mistakes

### 5. No Version Control

❌ **Bad**: Let AI write directly to files without commits

✅ **Good**: Commit frequently, use branches for AI experiments

```bash
git checkout -b ai/feature-name
# Let AI make changes
git diff  # Review what changed
git commit -m "feat: add login form (AI-assisted)"
```

**Why it matters**: Easier to rollback bad AI suggestions.

---

### 6. Blind Trust in Dependencies

❌ **Bad**: AI suggests `npm install obscure-package-name`, you install it

✅ **Good**:

- Check npm for package existence
- Check weekly downloads
- Check last publish date
- Read the package source

**Why it matters**: AI can hallucinate package names. You might install malware.

---

### 7. Ignoring Security

❌ **Bad**: Assume AI-generated code is secure

✅ **Good**:

- Run `security_audit` skill on new features
- Never hardcode secrets
- Validate all user input
- Check auth on every endpoint

**Why it matters**: AI doesn't think about security by default. You must.

---

### 8. Not Testing

❌ **Bad**: "It compiles, ship it"

✅ **Good**:

- Test happy path
- Test edge cases
- Test error states
- Test on mobile
- Test with slow network

**Why it matters**: AI code often works for demos but breaks in production.

---

## 🏗️ Architecture Mistakes

### 9. Over-Engineering Early

❌ **Bad**: "Let's add microservices, event sourcing, and CQRS for this todo app"

✅ **Good**: Start simple, add complexity when needed

**Why it matters**: AI loves to suggest sophisticated patterns that you don't need yet.

---

### 10. Copy-Paste Architecture

❌ **Bad**: Copy code structure from AI without understanding it

✅ **Good**:

- Ask "why is it structured this way?"
- Understand each file's purpose
- Modify to fit YOUR project's needs

**Why it matters**: You'll need to maintain this code. Understand it.

---

### 11. Ignoring Existing Patterns

❌ **Bad**: Let AI create new patterns that conflict with your codebase

✅ **Good**: "Follow the same patterns as [existing file]. Here's an example: [code]"

**Why it matters**: Consistency makes code maintainable.

---

## 📝 Documentation Mistakes

### 12. No Context Trail

❌ **Bad**: Build features without documenting decisions

✅ **Good**:

- Use `project_context` skill to track state
- Create architecture docs for complex features
- Write ADRs for major decisions

**Why it matters**: Future you (or future AI sessions) won't remember why things are this way.

---

### 13. Outdated Context

❌ **Bad**: Start session with old context doc

✅ **Good**: Update context after every session

**Why it matters**: AI will give wrong suggestions based on stale information.

---

## ⚠️ Process Mistakes

### 14. Going Too Fast

❌ **Bad**: Vibe code for 4 hours straight without review

✅ **Good**:

- Build in small chunks
- Review after each feature
- Test before moving on
- Commit frequently

**Why it matters**: Bugs compound. Small mistakes early become big problems later.

---

### 15. Not Reading the Skill

❌ **Bad**: Use a skill without reading the SKILL.md

✅ **Good**: Read the skill first, understand the process, then use it

**Why it matters**: Skills have specific triggers, steps, and checklists. Using them correctly gets better results.

---

## ✅ The Fix

1. **Slow down** - Quality over speed
2. **Be specific** - Context is king
3. **Review everything** - Trust but verify
4. **Document as you go** - Future you will thank you
5. **Use the skills** - They encode best practices

---

*Learn from others' mistakes. Don't repeat them.*
