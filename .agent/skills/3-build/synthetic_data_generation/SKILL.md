---
name: Synthetic Data Generation
description: Generate high-quality synthetic training data using LLMs, statistical methods, GANs, and augmentation techniques
---

# Synthetic Data Generation Skill

**Purpose**: Generate synthetic training data that preserves statistical properties and privacy while expanding dataset coverage using LLM-based generation, statistical synthesis, GANs, and augmentation techniques.

---

## TRIGGER COMMANDS

```text
"Generate synthetic training data for this ML task"
"Create privacy-preserving synthetic dataset from production data"
"Augment this dataset with synthetic samples"
"Using synthetic_data_generation skill: [task]"
```

---

## Method Selection Matrix

| Method | Data Type | Privacy | Quality | Cost | Best For |
|--------|-----------|---------|---------|------|----------|
| LLM generation | Text, structured | High | High | Moderate | NLP tasks, instruction tuning |
| CTGAN/TVAE | Tabular | High | Moderate | Low | Tabular ML, analytics |
| SDV (Synthetic Data Vault) | Multi-table relational | High | Moderate-High | Low | Database simulation |
| Gretel | Any structured | High | High | Moderate | Enterprise, compliance |
| Copula-based | Tabular | High | Moderate | Low | Financial data |
| GAN (image) | Images | Moderate | High | High | Computer vision |
| Data augmentation | Text/Image | N/A | Moderate | Low | Expanding existing data |
| Rule-based templates | Structured text | High | Moderate | Low | Testing, edge cases |

### Decision Guide

```
Need synthetic tabular data?
  +-- Small dataset (<10K rows)   --> CTGAN or Copula
  +-- Large dataset (>10K rows)   --> SDV or Gretel
  +-- Multi-table relational      --> SDV
  +-- Financial/sensitive         --> Copula + differential privacy

Need synthetic text data?
  +-- Instruction tuning data     --> LLM distillation
  +-- Classification labels       --> LLM + validation
  +-- Conversational data         --> LLM multi-turn generation
  +-- NER/extraction training     --> Template + LLM augmentation

Need synthetic images?
  +-- Medical/sensitive           --> Diffusion models + privacy audit
  +-- Augmentation                --> Albumentations/torchvision transforms
  +-- Style transfer              --> GANs
```

---

## LLM-Based Synthetic Data Generation

### Instruction Dataset Generation

```python
from openai import OpenAI
import json
import hashlib

client = OpenAI()

GENERATION_PROMPT = """Generate {n} diverse, realistic examples for the following task.

Task: {task_description}

Requirements:
- Each example must be unique and realistic
- Cover different scenarios and edge cases
- Include both typical and challenging cases
- Format as JSON array with fields: {fields}

Examples of the desired output format:
{few_shot_examples}

Generate {n} new examples (do NOT repeat the examples above):"""

def generate_synthetic_examples(
    task_description: str,
    fields: list[str],
    few_shot_examples: list[dict],
    n: int = 20,
    model: str = "gpt-4o",
    temperature: float = 0.8,
) -> list[dict]:
    """Generate synthetic examples using LLM."""
    prompt = GENERATION_PROMPT.format(
        n=n,
        task_description=task_description,
        fields=", ".join(fields),
        few_shot_examples=json.dumps(few_shot_examples, indent=2),
    )

    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature,
        max_tokens=4096,
    )

    content = response.choices[0].message.content
    # Extract JSON from response
    start = content.find("[")
    end = content.rfind("]") + 1
    examples = json.loads(content[start:end])

    return examples

# Usage: Generate customer support tickets
few_shots = [
    {"text": "My order #12345 hasn't arrived after 2 weeks", "category": "shipping", "urgency": "high"},
    {"text": "How do I change my subscription plan?", "category": "billing", "urgency": "low"},
]

synthetic = generate_synthetic_examples(
    task_description="Customer support ticket classification with urgency level",
    fields=["text", "category", "urgency"],
    few_shot_examples=few_shots,
    n=50,
)
print(f"Generated {len(synthetic)} synthetic examples")
```

### LLM Distillation Dataset

```python
import asyncio
from openai import AsyncOpenAI

async_client = AsyncOpenAI()

DISTILLATION_SYSTEM = """You are an expert assistant. Provide detailed, accurate, and helpful responses.
Think step-by-step for complex questions."""

async def generate_distillation_pair(prompt: str, teacher_model: str = "gpt-4o") -> dict:
    """Generate a high-quality response from teacher model for distillation."""
    response = await async_client.chat.completions.create(
        model=teacher_model,
        messages=[
            {"role": "system", "content": DISTILLATION_SYSTEM},
            {"role": "user", "content": prompt},
        ],
        temperature=0.7,
        max_tokens=2048,
    )
    return {
        "instruction": prompt,
        "response": response.choices[0].message.content,
        "teacher_model": teacher_model,
    }

async def generate_distillation_dataset(
    prompts: list[str],
    teacher_model: str = "gpt-4o",
    max_concurrent: int = 10,
) -> list[dict]:
    """Generate distillation dataset with concurrency control."""
    semaphore = asyncio.Semaphore(max_concurrent)

    async def bounded_generate(prompt):
        async with semaphore:
            return await generate_distillation_pair(prompt, teacher_model)

    tasks = [bounded_generate(p) for p in prompts]
    results = await asyncio.gather(*tasks, return_exceptions=True)

    # Filter out errors
    dataset = [r for r in results if isinstance(r, dict)]
    errors = [r for r in results if isinstance(r, Exception)]
    print(f"Generated {len(dataset)} pairs, {len(errors)} errors")
    return dataset

# Generate diverse prompts for distillation
PROMPT_GENERATION = """Generate {n} diverse, challenging questions that a user might ask about {domain}.
Cover different difficulty levels and question types.
Output as JSON array of strings."""

def generate_diverse_prompts(domain: str, n: int = 100) -> list[str]:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": PROMPT_GENERATION.format(n=n, domain=domain)}],
        temperature=1.0,
    )
    content = response.choices[0].message.content
    start = content.find("[")
    end = content.rfind("]") + 1
    return json.loads(content[start:end])
```

### Multi-Turn Conversation Generation

```python
CONVERSATION_SEED = """Generate a realistic multi-turn conversation between a user and an AI assistant about {topic}.

Requirements:
- {num_turns} turns total (user + assistant alternating)
- The conversation should feel natural and progress logically
- Include follow-up questions that reference earlier context
- The assistant should be helpful, accurate, and appropriately detailed

Output as JSON array of objects with "role" and "content" fields."""

def generate_conversations(
    topics: list[str],
    num_turns: int = 6,
    num_conversations_per_topic: int = 5,
) -> list[list[dict]]:
    """Generate multi-turn conversations for chat model training."""
    all_conversations = []

    for topic in topics:
        for i in range(num_conversations_per_topic):
            response = client.chat.completions.create(
                model="gpt-4o",
                messages=[{"role": "user", "content": CONVERSATION_SEED.format(
                    topic=topic, num_turns=num_turns,
                )}],
                temperature=0.9,
            )
            content = response.choices[0].message.content
            start = content.find("[")
            end = content.rfind("]") + 1
            conversation = json.loads(content[start:end])
            all_conversations.append({
                "topic": topic,
                "conversation": conversation,
                "variant": i,
            })

    return all_conversations
```

---

## Statistical Synthetic Data (CTGAN / SDV)

### CTGAN for Tabular Data

```bash
pip install sdv
```

```python
from sdv.single_table import CTGANSynthesizer
from sdv.metadata import SingleTableMetadata
import pandas as pd

# Load real data
real_data = pd.read_csv("customers.csv")

# Define metadata
metadata = SingleTableMetadata()
metadata.detect_from_dataframe(real_data)

# Override detected types if needed
metadata.update_column("customer_id", sdtype="id")
metadata.update_column("email", sdtype="email")
metadata.update_column("signup_date", sdtype="datetime", datetime_format="%Y-%m-%d")
metadata.update_column("plan_type", sdtype="categorical")
metadata.update_column("monthly_spend", sdtype="numerical")

# Train CTGAN
synthesizer = CTGANSynthesizer(
    metadata,
    epochs=300,
    batch_size=500,
    generator_dim=(256, 256),
    discriminator_dim=(256, 256),
    verbose=True,
)
synthesizer.fit(real_data)

# Generate synthetic data
synthetic_data = synthesizer.sample(num_rows=10000)

# Save synthesizer for later use
synthesizer.save("models/ctgan_customers.pkl")

# Evaluate quality
from sdv.evaluation.single_table import evaluate_quality, run_diagnostic

quality_report = evaluate_quality(real_data, synthetic_data, metadata)
print(f"Overall Quality Score: {quality_report.get_score():.2%}")

diagnostic = run_diagnostic(real_data, synthetic_data, metadata)
print(f"Diagnostic Score: {diagnostic.get_score():.2%}")
```

### Multi-Table Relational Data (SDV)

```python
from sdv.multi_table import HMASynthesizer
from sdv.metadata import MultiTableMetadata

# Define multi-table metadata
metadata = MultiTableMetadata()

# Add tables
metadata.detect_table_from_dataframe("customers", customers_df)
metadata.detect_table_from_dataframe("orders", orders_df)
metadata.detect_table_from_dataframe("order_items", order_items_df)

# Define relationships
metadata.set_primary_key("customers", "customer_id")
metadata.set_primary_key("orders", "order_id")
metadata.set_primary_key("order_items", "item_id")

metadata.add_relationship(
    parent_table_name="customers",
    child_table_name="orders",
    parent_primary_key="customer_id",
    child_foreign_key="customer_id",
)
metadata.add_relationship(
    parent_table_name="orders",
    child_table_name="order_items",
    parent_primary_key="order_id",
    child_foreign_key="order_id",
)

# Train multi-table synthesizer
synthesizer = HMASynthesizer(metadata)
synthesizer.fit({
    "customers": customers_df,
    "orders": orders_df,
    "order_items": order_items_df,
})

# Generate synthetic relational data
synthetic_tables = synthesizer.sample(scale=2)  # 2x the original size
synthetic_customers = synthetic_tables["customers"]
synthetic_orders = synthetic_tables["orders"]
synthetic_items = synthetic_tables["order_items"]
```

---

## Quality Validation

### Statistical Validation

```python
import pandas as pd
import numpy as np
from scipy import stats

def validate_synthetic_quality(real: pd.DataFrame, synthetic: pd.DataFrame,
                               numerical_cols: list[str],
                               categorical_cols: list[str]) -> dict:
    """Validate synthetic data quality against real data."""
    results = {"numerical": {}, "categorical": {}, "correlations": {}}

    # Numerical column validation
    for col in numerical_cols:
        ks_stat, ks_pval = stats.ks_2samp(real[col].dropna(), synthetic[col].dropna())
        results["numerical"][col] = {
            "real_mean": real[col].mean(),
            "synth_mean": synthetic[col].mean(),
            "mean_diff_pct": abs(real[col].mean() - synthetic[col].mean()) / (abs(real[col].mean()) + 1e-10) * 100,
            "real_std": real[col].std(),
            "synth_std": synthetic[col].std(),
            "ks_statistic": ks_stat,
            "ks_p_value": ks_pval,
            "distribution_match": ks_pval > 0.05,
        }

    # Categorical column validation
    for col in categorical_cols:
        real_dist = real[col].value_counts(normalize=True)
        synth_dist = synthetic[col].value_counts(normalize=True)

        # Align categories
        all_cats = set(real_dist.index) | set(synth_dist.index)
        real_aligned = np.array([real_dist.get(c, 0) for c in all_cats])
        synth_aligned = np.array([synth_dist.get(c, 0) for c in all_cats])

        # Jensen-Shannon divergence
        from scipy.spatial.distance import jensenshannon
        js_div = jensenshannon(real_aligned, synth_aligned)

        results["categorical"][col] = {
            "real_categories": len(real_dist),
            "synth_categories": len(synth_dist),
            "new_categories": len(set(synth_dist.index) - set(real_dist.index)),
            "js_divergence": js_div,
            "distribution_match": js_div < 0.1,
        }

    # Correlation preservation
    real_corr = real[numerical_cols].corr()
    synth_corr = synthetic[numerical_cols].corr()
    corr_diff = (real_corr - synth_corr).abs()
    results["correlations"] = {
        "max_correlation_diff": corr_diff.max().max(),
        "mean_correlation_diff": corr_diff.mean().mean(),
        "correlation_preserved": corr_diff.mean().mean() < 0.1,
    }

    # Overall score
    num_pass = sum(1 for v in results["numerical"].values() if v["distribution_match"])
    cat_pass = sum(1 for v in results["categorical"].values() if v["distribution_match"])
    total = len(numerical_cols) + len(categorical_cols)
    results["overall_pass_rate"] = (num_pass + cat_pass) / total if total > 0 else 0

    return results
```

### Privacy Validation

```python
from sklearn.neighbors import NearestNeighbors
import numpy as np

def check_privacy_distance(real: pd.DataFrame, synthetic: pd.DataFrame,
                           feature_cols: list[str],
                           k: int = 5) -> dict:
    """Check that synthetic records are not too close to real records (privacy risk)."""
    # Normalize features
    from sklearn.preprocessing import StandardScaler
    scaler = StandardScaler()
    real_scaled = scaler.fit_transform(real[feature_cols].fillna(0))
    synth_scaled = scaler.transform(synthetic[feature_cols].fillna(0))

    # Find nearest real neighbor for each synthetic record
    nn = NearestNeighbors(n_neighbors=k, metric="euclidean")
    nn.fit(real_scaled)
    distances, indices = nn.kneighbors(synth_scaled)

    min_distances = distances[:, 0]  # Distance to closest real record

    return {
        "min_distance_mean": float(np.mean(min_distances)),
        "min_distance_median": float(np.median(min_distances)),
        "min_distance_5th_pct": float(np.percentile(min_distances, 5)),
        "exact_matches": int((min_distances < 1e-6).sum()),
        "near_matches": int((min_distances < 0.1).sum()),
        "privacy_risk": "HIGH" if (min_distances < 0.1).mean() > 0.01 else "LOW",
    }

def check_membership_inference(real: pd.DataFrame, synthetic: pd.DataFrame,
                                holdout: pd.DataFrame,
                                feature_cols: list[str]) -> dict:
    """Test if a membership inference attack can distinguish real from holdout data
    using the synthetic data as a proxy."""
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.model_selection import cross_val_score

    # Create attack dataset: real (member=1) vs holdout (member=0)
    real_features = real[feature_cols].fillna(0)
    holdout_features = holdout[feature_cols].fillna(0)

    X = pd.concat([real_features, holdout_features])
    y = np.array([1] * len(real_features) + [0] * len(holdout_features))

    # Train attack model
    attack_model = RandomForestClassifier(n_estimators=100, random_state=42)
    scores = cross_val_score(attack_model, X, y, cv=5, scoring="roc_auc")

    return {
        "attack_auc_mean": float(scores.mean()),
        "attack_auc_std": float(scores.std()),
        "privacy_risk": "HIGH" if scores.mean() > 0.6 else "LOW",
        "interpretation": (
            "Synthetic data leaks membership information"
            if scores.mean() > 0.6
            else "Synthetic data is privacy-safe"
        ),
    }
```

---

## Text Data Augmentation

```python
import random
import nlpaug.augmenter.word as naw
import nlpaug.augmenter.sentence as nas

# Synonym replacement
syn_aug = naw.SynonymAug(aug_src="wordnet", aug_p=0.3)

# Contextual word insertion (BERT-based)
insert_aug = naw.ContextualWordEmbsAug(
    model_path="bert-base-uncased",
    action="insert",
    aug_p=0.1,
)

# Back-translation augmentation
def back_translate(text: str, src_lang: str = "en",
                   pivot_lang: str = "de") -> str:
    """Augment text via back-translation."""
    from transformers import MarianMTModel, MarianTokenizer

    # English to pivot
    fwd_model_name = f"Helsinki-NLP/opus-mt-{src_lang}-{pivot_lang}"
    fwd_tokenizer = MarianTokenizer.from_pretrained(fwd_model_name)
    fwd_model = MarianMTModel.from_pretrained(fwd_model_name)

    encoded = fwd_tokenizer(text, return_tensors="pt", truncation=True)
    translated = fwd_model.generate(**encoded)
    pivot_text = fwd_tokenizer.decode(translated[0], skip_special_tokens=True)

    # Pivot back to English
    bwd_model_name = f"Helsinki-NLP/opus-mt-{pivot_lang}-{src_lang}"
    bwd_tokenizer = MarianTokenizer.from_pretrained(bwd_model_name)
    bwd_model = MarianMTModel.from_pretrained(bwd_model_name)

    encoded = bwd_tokenizer(pivot_text, return_tensors="pt", truncation=True)
    back_translated = bwd_model.generate(**encoded)
    result = bwd_tokenizer.decode(back_translated[0], skip_special_tokens=True)

    return result

# Augmentation pipeline
def augment_text_dataset(texts: list[str], labels: list, multiplier: int = 3) -> tuple:
    """Augment a text classification dataset."""
    augmented_texts = list(texts)
    augmented_labels = list(labels)

    augmenters = [syn_aug, insert_aug]

    for text, label in zip(texts, labels):
        for _ in range(multiplier - 1):
            aug = random.choice(augmenters)
            try:
                new_text = aug.augment(text)
                if isinstance(new_text, list):
                    new_text = new_text[0]
                augmented_texts.append(new_text)
                augmented_labels.append(label)
            except Exception:
                continue

    return augmented_texts, augmented_labels
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track synthetic data generation experiments
- Related: `3-build/nlp_text_pipeline` -- Use synthetic data in NLP pipelines
- Related: `4-secure/llm_evaluation_benchmarking` -- Evaluate models trained on synthetic data
- Related: `toolkit/responsible_ai_framework` -- Privacy and fairness in synthetic data
- Related: `toolkit/ai_cost_optimization` -- Cost of LLM-based generation at scale

---

## EXIT CHECKLIST

- [ ] Synthetic data generation method selected based on data type and requirements
- [ ] Quality validation passed (statistical similarity, correlation preservation)
- [ ] Privacy validation completed (distance checks, membership inference test)
- [ ] No exact matches between synthetic and real records
- [ ] Synthetic data covers edge cases and minority classes
- [ ] Generation pipeline is reproducible (seeds, configs documented)
- [ ] Generated data reviewed by domain expert for realism
- [ ] Downstream model performance validated with synthetic data
- [ ] Cost of generation estimated and within budget
- [ ] Data lineage documented (generation method, source data version, parameters)

---

*Skill Version: 1.0 | Created: March 2026*
