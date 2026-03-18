---
name: nl_to_structured_output
description: Convert natural language to structured outputs including SQL, code, and validated JSON using constrained generation, schema-aware prompting, and AST validation
triggers:
  - /text-to-sql
  - /structured-output
  - /nl-to-code
---

# Natural Language to Structured Output

## WHEN TO USE

Use this skill when building text-to-SQL pipelines (schema-aware prompting, query validation, sandboxed execution), generating structured JSON from free text (function calling, Pydantic models), converting natural language to code with AST validation, or evaluating NL-to-structured systems for execution accuracy and semantic equivalence.

## PROCESS

1. **Define the output schema** — create a strict Pydantic model or JSON Schema that constrains the LLM output space.
   ```python
   from pydantic import BaseModel, Field
   from typing import Literal

   class SQLQuery(BaseModel):
       reasoning: str = Field(description="Step-by-step query plan")
       query: str = Field(description="Valid SQL query")
       tables_used: list[str]
       confidence: Literal["high", "medium", "low"]
   ```

2. **Build schema-aware context** — inject database schema, column descriptions, sample rows, and domain-specific terminology into the prompt.
   ```python
   def build_schema_context(db_path: str) -> str:
       inspector = inspect(create_engine(f"sqlite:///{db_path}"))
       context_parts = []
       for table in inspector.get_table_names():
           cols = inspector.get_columns(table)
           col_str = ", ".join(f"{c['name']} {c['type']}" for c in cols)
           context_parts.append(f"TABLE {table} ({col_str})")
       return "\n".join(context_parts)
   ```

3. **Generate structured output** — use Instructor (OpenAI function calling) or Outlines (local constrained generation) to guarantee valid structure.
   ```python
   import instructor
   from openai import OpenAI

   client = instructor.from_openai(OpenAI())
   result = client.chat.completions.create(
       model="gpt-4o",
       response_model=SQLQuery,
       messages=[
           {"role": "system", "content": f"Schema:\n{schema_ctx}"},
           {"role": "user", "content": user_question},
       ],
       max_retries=3,
   )
   ```

4. **Validate the output** — for SQL: parse with `sqlglot`, check referenced tables/columns exist, enforce read-only. For code: parse AST and run in sandbox.
   ```python
   import sqlglot

   def validate_sql(query: str, allowed_tables: set) -> bool:
       parsed = sqlglot.parse_one(query)
       if parsed.find(sqlglot.exp.Delete, sqlglot.exp.Drop, sqlglot.exp.Update):
           raise ValueError("Write operations not allowed")
       used_tables = {t.name for t in parsed.find_all(sqlglot.exp.Table)}
       if not used_tables.issubset(allowed_tables):
           raise ValueError(f"Unknown tables: {used_tables - allowed_tables}")
       return True
   ```

5. **Execute in a sandbox** — run validated SQL against a read-only replica or use Docker/subprocess jail for generated code.
   ```python
   from sqlalchemy import create_engine, text
   engine = create_engine(db_url, execution_options={"isolation_level": "AUTOCOMMIT"})
   with engine.connect() as conn:
       conn.execute(text("SET TRANSACTION READ ONLY"))
       results = conn.execute(text(result.query)).fetchall()
   ```

6. **Evaluate accuracy** — measure execution accuracy (does the query return correct results?), exact-match rate, and semantic equivalence using reference datasets like Spider or WikiSQL.
   ```python
   def execution_accuracy(predicted_sql, gold_sql, db_path):
       pred_result = execute(predicted_sql, db_path)
       gold_result = execute(gold_sql, db_path)
       return set(pred_result) == set(gold_result)
   ```

7. **Handle failures gracefully** — implement retry with error feedback (pass the validation error back to the LLM), fallback to simpler models, and log all failures for fine-tuning data collection.

8. **Ship with guardrails** — rate-limit queries, set execution timeouts, log all generated outputs, and add human-in-the-loop review for low-confidence results.

## CHECKLIST

- [ ] Output schema defined with Pydantic or JSON Schema, all fields typed
- [ ] Database/API schema injected into prompt with column descriptions
- [ ] Constrained generation enforced (Instructor, Outlines, or JSON mode)
- [ ] SQL validation: parsed with sqlglot, write ops blocked, tables verified
- [ ] Code validation: AST parsed successfully, sandbox execution passes
- [ ] Execution sandboxed: read-only DB replica or subprocess jail
- [ ] Retry loop with error feedback (max 3 attempts before fallback)
- [ ] Evaluation metrics tracked: execution accuracy, latency, failure rate

## Related Skills

- `prompt_engineering` — crafting effective schema-aware prompts
- `rag_advanced_patterns` — retrieving relevant schema and examples for context
