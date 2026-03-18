---
name: Prompt Ops
description: DevOps for prompts — versioning, testing pipelines, A/B comparison, performance metrics, review workflows, template engines, registries, and rollback procedures
triggers:
  - /prompt-ops
  - /prompt-versioning
  - /prompt-management
---

# Prompt Ops Skill

## WHEN TO USE

- Managing prompts across environments (dev, staging, prod) with version control
- Running A/B tests to compare prompt variants on quality, cost, and latency
- Building a prompt registry so teams share and review prompts before deployment
- Setting up CI/CD for prompts: lint, evaluate, approve, deploy, rollback

---

## PROCESS

1. **Establish a prompt storage strategy.** Choose git-based (prompts as files in repo, e.g. `prompts/chat_assistant/v1.0.0.jinja2` + `metadata.yaml`) for small teams, or DB-backed (Postgres/Redis with version column) for dynamic updates without redeploy.

2. **Use a template engine for variable injection.** Jinja2 for Python, Handlebars for Node.js. Never concatenate strings:
   ```python
   from jinja2 import Environment, FileSystemLoader
   env = Environment(loader=FileSystemLoader("prompts/chat_assistant"))
   rendered = env.get_template("v1.1.0.jinja2").render(user_name=name, context=docs)
   ```

3. **Build an evaluation pipeline.** For each prompt version, run a test suite of 20-50 representative inputs. Score outputs using LLM-as-judge, regex validators, or human review. Store results in a comparison table:
   ```bash
   # promptfoo example
   npx promptfoo eval --config prompts/chat_assistant/eval.yaml
   npx promptfoo view   # opens browser dashboard with A/B results
   ```

4. **Implement a review workflow.** Prompt changes go through PR review like code. The PR includes: the diff, eval results vs baseline, cost delta, and latency delta. No prompt ships without at least one reviewer sign-off.

5. **Deploy through a prompt registry.** The registry maps `(prompt_name, version)` to template content. Your app fetches the active version at startup or per-request. Implement `get_prompt(name, version=None)` that resolves the active version from a `prompt:{name}:active_version` key, and `rollback(name, to_version)` that repoints that key.

6. **Monitor prompt performance in production.** Track per-prompt-version metrics: avg tokens used, cost per call, latency p50/p95, user satisfaction signal (thumbs up/down), and error rate. Set alerts for cost spikes or quality regression.

7. **Rollback fast.** If a new prompt version degrades quality or spikes cost, revert the active version pointer in the registry. No redeploy needed for DB-backed registries. For git-based, revert the `active_version` field in `metadata.yaml` and push.

---

## CHECKLIST

- [ ] Prompt storage strategy chosen (git-based or DB-backed)
- [ ] Template engine integrated (Jinja2, Handlebars, or equivalent)
- [ ] Eval suite created with representative inputs and scoring criteria
- [ ] A/B comparison run between current and proposed prompt versions
- [ ] PR review workflow enforced for all prompt changes
- [ ] Prompt registry deployed with version resolution and rollback method
- [ ] Production metrics tracked per prompt version (cost, latency, quality)
- [ ] Rollback procedure tested end-to-end
- [ ] Deprecated prompt versions archived, not deleted

---

## Related Skills

- [Prompt Engineering](../../3-build/prompt_engineering/SKILL.md) -- writing effective prompts; Prompt Ops handles the lifecycle after they are written
- [AI Agent Development](../../3-build/ai_agent_development/SKILL.md) -- agents consume prompts managed by Prompt Ops

---

*Skill Version: 1.0 | Created: March 2026*
