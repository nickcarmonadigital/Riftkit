---
name: NVIDIA NeMo Data Curation
description: NeMo Curator for training data filtering, deduplication, quality scoring, PII removal, language classification, and dataset preparation pipelines
triggers:
  - /nemo-curator
  - /data-curation
  - /training-data
---

# NVIDIA NeMo Data Curation Skill

**Purpose**: Build scalable training data pipelines using NVIDIA NeMo Curator — filter low-quality text, deduplicate at scale, remove PII, classify languages, score quality, and prepare clean datasets for LLM fine-tuning or pretraining.

---

## WHEN TO USE

- Preparing a large text corpus for LLM pretraining or fine-tuning
- Cleaning web-scraped data (Common Crawl, custom scrapes)
- Removing duplicate documents that inflate training cost without benefit
- Stripping PII (emails, phone numbers, SSNs) from training data
- Filtering to a specific language or quality threshold
- Building a reproducible data pipeline that runs on GPU-accelerated infrastructure

---

## PROCESS

### 1. Install NeMo Curator

```bash
pip install nemo-curator[all]
# Requires: Python 3.10+, CUDA 12.x, Dask, cuDF (for GPU acceleration)
```

### 2. Define the Curation Pipeline

A typical pipeline chains these stages:

```text
Raw Corpus → Language ID → Quality Scoring → Heuristic Filters → PII Removal → Deduplication → Clean Dataset
```

### 3. Language Classification

Filter to your target language(s) before expensive downstream steps:

```python
from nemo_curator import ScoreFilter
from nemo_curator.filters import FastTextLangId
from nemo_curator.datasets import DocumentDataset
import dask.dataframe as dd

# Load raw documents
docs = DocumentDataset(dd.read_parquet("data/raw/*.parquet"))

# Classify language and keep only English
lang_filter = FastTextLangId(model_path="lid.176.bin")
english_docs = ScoreFilter(
    lang_filter,
    score_field="language",
    score_type=str,
    filter_fn=lambda score: score == "en",
).filter(docs)
```

### 4. Quality Scoring and Filtering

```python
from nemo_curator.filters import WordCountFilter, MeanWordLengthFilter, RepeatedParagraphFilter

# Chain heuristic quality filters
pipeline = [
    WordCountFilter(min_words=50, max_words=100000),
    MeanWordLengthFilter(min_mean=3.0, max_mean=10.0),
    RepeatedParagraphFilter(max_repeated_ratio=0.3),
]

filtered_docs = english_docs
for f in pipeline:
    filtered_docs = ScoreFilter(f).filter(filtered_docs)

print(f"Retained {len(filtered_docs)} / {len(english_docs)} documents")
```

**Classifier-based quality scoring** for higher precision:

```python
from nemo_curator.filters import QualityClassifierFilter

quality_filter = QualityClassifierFilter(
    model_path="models/quality_classifier.pth",
    min_score=0.7,  # Keep top 30% quality
)
high_quality_docs = ScoreFilter(quality_filter).filter(filtered_docs)
```

### 5. PII Removal

```python
from nemo_curator.modifiers import PiiModifier

pii_remover = PiiModifier(
    supported_entities=["EMAIL_ADDRESS", "PHONE_NUMBER", "US_SSN", "CREDIT_CARD", "IP_ADDRESS"],
    anonymize_action="replace",  # or "redact", "hash"
)
clean_docs = pii_remover.modify(high_quality_docs)
```

### 6. Deduplication

NeMo Curator supports exact, fuzzy (MinHash LSH), and semantic dedup:

```python
from nemo_curator import ExactDuplicates, FuzzyDuplicates
from nemo_curator.modules import MinHashConfig

# Exact dedup (fast, catches identical docs)
exact_dedup = ExactDuplicates(hash_method="md5", id_field="doc_id")
deduped = exact_dedup.compute(clean_docs)

# Fuzzy dedup with MinHash LSH (catches near-duplicates)
minhash_config = MinHashConfig(
    num_hashes=128,
    ngram_size=5,
    jaccard_threshold=0.8,
    num_bands=8,
)
fuzzy_dedup = FuzzyDuplicates(config=minhash_config, id_field="doc_id")
final_docs = fuzzy_dedup.compute(deduped)

print(f"Final dataset: {len(final_docs)} documents")
```

### 7. Export Clean Dataset

```python
# Save as parquet for efficient loading during training
final_docs.df.to_parquet("data/clean/", write_index=False)

# Or export as JSONL for Hugging Face datasets
final_docs.df.to_json("data/clean/dataset.jsonl", orient="records", lines=True)
```

### 8. Validate the Pipeline

```python
import pandas as pd

df = pd.read_parquet("data/clean/")
assert df["text"].str.len().min() > 100, "Short docs slipped through"
assert df["text"].str.contains(r"\b\d{3}-\d{2}-\d{4}\b").sum() == 0, "SSNs still present"
assert df.duplicated(subset=["text"]).sum() == 0, "Exact duplicates remain"
print(f"Clean dataset: {len(df)} docs, {df['text'].str.split().str.len().sum()} tokens approx")
```

---

## CHECKLIST

- [ ] NeMo Curator installed with GPU support (cuDF/Dask)
- [ ] Raw corpus loaded as DocumentDataset (Parquet or JSONL)
- [ ] Language classification applied — target language(s) filtered
- [ ] Heuristic quality filters configured (word count, mean word length, repetition)
- [ ] Classifier-based quality scoring applied with threshold tuned
- [ ] PII removal enabled for all relevant entity types
- [ ] Exact deduplication run (MD5 or SHA256)
- [ ] Fuzzy deduplication run (MinHash LSH, Jaccard >= 0.8)
- [ ] Clean dataset exported in training-ready format (Parquet or JSONL)
- [ ] Validation checks pass: no PII, no duplicates, min doc length enforced
- [ ] Pipeline is reproducible (configs versioned, random seeds set)

---

## Related Skills

- [Synthetic Data Generation](../../3-build/synthetic_data_generation/SKILL.md)
- [LoRA Fine-Tuning Workflow](../../3-build/lora_finetuning_workflow/SKILL.md)

---

*Skill Version: 1.0 | Created: March 2026*
