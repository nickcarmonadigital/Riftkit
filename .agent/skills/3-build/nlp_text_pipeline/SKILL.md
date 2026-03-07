---
name: NLP Text Pipeline
description: Build NLP pipelines for tokenization, NER, sentiment analysis, text classification, and summarization
---

# NLP Text Pipeline Skill

**Purpose**: Design and implement production-grade NLP pipelines covering text preprocessing, tokenization, named entity recognition, sentiment analysis, text classification, and summarization using spaCy, Hugging Face Transformers, and custom components.

---

## TRIGGER COMMANDS

```text
"Build an NLP pipeline for text classification"
"Set up named entity recognition for this domain"
"Create a text preprocessing and analysis pipeline"
"Using nlp_text_pipeline skill: [task]"
```

---

## NLP Task Selection Matrix

| Task | Best Tool | Model Size | Latency | Accuracy | Use Case |
|------|-----------|------------|---------|----------|----------|
| Tokenization | spaCy / HF Tokenizers | Tiny | <1ms | N/A | All NLP tasks |
| NER (general) | spaCy (en_core_web_trf) | 500MB | 20-50ms | High | Person, Org, Location |
| NER (domain) | Fine-tuned BERT | 400MB | 20-50ms | Highest | Medical, Legal, Finance |
| Sentiment | distilbert-sst2 | 260MB | 10-30ms | Good | Reviews, social media |
| Classification | Fine-tuned BERT/RoBERTa | 400MB | 20-50ms | High | Custom categories |
| Summarization | BART / T5 / Pegasus | 1-3GB | 200ms-2s | Good | Articles, documents |
| Zero-shot classification | bart-large-mnli | 1.5GB | 50-100ms | Moderate | No training data |
| Keyword extraction | KeyBERT / YAKE | 400MB | 10-30ms | Good | Topic discovery |

### Decision Guide

```
Have labeled training data?
  +-- YES: Fine-tune task-specific model (BERT/RoBERTa)
  +-- NO:  Zero-shot or few-shot approach
      +-- Simple sentiment?      --> Pretrained pipeline
      +-- Custom categories?     --> Zero-shot (bart-large-mnli)
      +-- Entity extraction?     --> spaCy + custom rules

Need real-time (<50ms)?
  +-- YES: distilbert or spaCy models
  +-- NO:  Full-size transformers

Processing volume?
  +-- >10K docs/day: Batch processing + GPU
  +-- <10K docs/day: Real-time API or CPU
```

---

## Text Preprocessing Pipeline

### Standard Preprocessing

```python
import re
import unicodedata
from typing import Callable

class TextPreprocessor:
    """Configurable text preprocessing pipeline."""

    def __init__(self, steps: list[str] = None):
        self.available_steps: dict[str, Callable] = {
            "lowercase": self._lowercase,
            "normalize_unicode": self._normalize_unicode,
            "remove_urls": self._remove_urls,
            "remove_emails": self._remove_emails,
            "remove_html": self._remove_html,
            "remove_extra_whitespace": self._remove_extra_whitespace,
            "remove_special_chars": self._remove_special_chars,
            "normalize_numbers": self._normalize_numbers,
        }
        self.steps = steps or [
            "normalize_unicode",
            "remove_urls",
            "remove_emails",
            "remove_html",
            "lowercase",
            "remove_extra_whitespace",
        ]

    def process(self, text: str) -> str:
        for step_name in self.steps:
            if step_name in self.available_steps:
                text = self.available_steps[step_name](text)
        return text.strip()

    def _lowercase(self, text: str) -> str:
        return text.lower()

    def _normalize_unicode(self, text: str) -> str:
        return unicodedata.normalize("NFKD", text)

    def _remove_urls(self, text: str) -> str:
        return re.sub(r"https?://\S+|www\.\S+", " ", text)

    def _remove_emails(self, text: str) -> str:
        return re.sub(r"\S+@\S+\.\S+", " ", text)

    def _remove_html(self, text: str) -> str:
        return re.sub(r"<[^>]+>", " ", text)

    def _remove_extra_whitespace(self, text: str) -> str:
        return re.sub(r"\s+", " ", text)

    def _remove_special_chars(self, text: str) -> str:
        return re.sub(r"[^a-zA-Z0-9\s.,!?;:'\"-]", " ", text)

    def _normalize_numbers(self, text: str) -> str:
        return re.sub(r"\d+", "NUM", text)

# Usage
preprocessor = TextPreprocessor(steps=[
    "normalize_unicode", "remove_urls", "remove_html",
    "lowercase", "remove_extra_whitespace",
])
clean_text = preprocessor.process(raw_text)
```

### Tokenization with Hugging Face

```python
from transformers import AutoTokenizer

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

# Basic tokenization
tokens = tokenizer.tokenize("The quick brown fox jumps over the lazy dog.")
print(tokens)  # ['the', 'quick', 'brown', 'fox', 'jumps', 'over', 'the', 'lazy', 'dog', '.']

# Encode for model input
encoded = tokenizer(
    "Hello, world!",
    padding="max_length",
    truncation=True,
    max_length=128,
    return_tensors="pt",
)
print(encoded.keys())  # dict_keys(['input_ids', 'token_type_ids', 'attention_mask'])

# Batch encoding
texts = ["First sentence.", "Second sentence that is longer."]
batch = tokenizer(
    texts,
    padding=True,
    truncation=True,
    max_length=128,
    return_tensors="pt",
)

# Fast tokenizer for high throughput
from tokenizers import Tokenizer, models, trainers

# Train custom BPE tokenizer
custom_tokenizer = Tokenizer(models.BPE())
trainer = trainers.BpeTrainer(
    vocab_size=30000,
    special_tokens=["[PAD]", "[UNK]", "[CLS]", "[SEP]", "[MASK]"],
)
custom_tokenizer.train(files=["corpus.txt"], trainer=trainer)
```

---

## Named Entity Recognition (NER)

### spaCy NER

```python
import spacy

# Load transformer-based model for best accuracy
nlp = spacy.load("en_core_web_trf")

# Process text
doc = nlp("Apple Inc. was founded by Steve Jobs in Cupertino, California in 1976.")

# Extract entities
for ent in doc.ents:
    print(f"{ent.text:20s} {ent.label_:10s} {ent.start_char}-{ent.end_char}")

# Output:
# Apple Inc.           ORG        0-10
# Steve Jobs           PERSON     26-36
# Cupertino            GPE        40-49
# California           GPE        51-61
# 1976                 DATE       65-69
```

### Custom NER with Hugging Face

```python
from transformers import AutoTokenizer, AutoModelForTokenClassification, pipeline

# Use pretrained NER model
ner_pipeline = pipeline(
    "ner",
    model="dslim/bert-base-NER",
    aggregation_strategy="simple",
)

results = ner_pipeline("Elon Musk founded SpaceX in Hawthorne, California.")
for entity in results:
    print(f"{entity['word']:20s} {entity['entity_group']:10s} {entity['score']:.3f}")

# Fine-tune NER for custom entities
from transformers import (
    AutoModelForTokenClassification,
    TrainingArguments,
    Trainer,
    DataCollatorForTokenClassification,
)
from datasets import load_dataset

# Load and prepare dataset
dataset = load_dataset("conll2003")
label_list = dataset["train"].features["ner_tags"].feature.names

# Load model
model = AutoModelForTokenClassification.from_pretrained(
    "bert-base-uncased",
    num_labels=len(label_list),
)
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

def tokenize_and_align_labels(examples):
    tokenized = tokenizer(
        examples["tokens"],
        truncation=True,
        is_split_into_words=True,
        padding="max_length",
        max_length=128,
    )
    labels = []
    for i, label in enumerate(examples["ner_tags"]):
        word_ids = tokenized.word_ids(batch_index=i)
        label_ids = []
        previous_word_idx = None
        for word_idx in word_ids:
            if word_idx is None:
                label_ids.append(-100)
            elif word_idx != previous_word_idx:
                label_ids.append(label[word_idx])
            else:
                label_ids.append(-100)  # Subword tokens
            previous_word_idx = word_idx
        labels.append(label_ids)
    tokenized["labels"] = labels
    return tokenized

tokenized_dataset = dataset.map(tokenize_and_align_labels, batched=True)

training_args = TrainingArguments(
    output_dir="./ner-model",
    learning_rate=2e-5,
    per_device_train_batch_size=16,
    num_train_epochs=3,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    load_best_model_at_end=True,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset["train"],
    eval_dataset=tokenized_dataset["validation"],
    tokenizer=tokenizer,
    data_collator=DataCollatorForTokenClassification(tokenizer),
)

trainer.train()
```

---

## Sentiment Analysis

### Pretrained Sentiment Pipeline

```python
from transformers import pipeline

# General sentiment
sentiment = pipeline("sentiment-analysis", model="distilbert/distilbert-base-uncased-finetuned-sst-2-english")

results = sentiment([
    "This product is amazing! Best purchase ever.",
    "Terrible experience. Would not recommend.",
    "It's okay, nothing special.",
])
for r in results:
    print(f"{r['label']:10s} {r['score']:.3f}")

# Multilabel sentiment (positive, negative, neutral)
multilabel_sentiment = pipeline(
    "text-classification",
    model="cardiffnlp/twitter-roberta-base-sentiment-latest",
    top_k=None,
)

results = multilabel_sentiment("I just got the new phone and it's pretty good overall!")
for r in results[0]:
    print(f"{r['label']:10s} {r['score']:.3f}")
```

### Fine-Tuned Sentiment Classifier

```python
from transformers import (
    AutoModelForSequenceClassification,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
)
from datasets import Dataset
import pandas as pd

# Prepare custom dataset
df = pd.read_csv("reviews.csv")  # columns: text, label
dataset = Dataset.from_pandas(df)
dataset = dataset.train_test_split(test_size=0.2)

model_name = "distilbert-base-uncased"
tokenizer = AutoTokenizer.from_pretrained(model_name)

def tokenize(examples):
    return tokenizer(examples["text"], truncation=True, padding="max_length", max_length=256)

tokenized = dataset.map(tokenize, batched=True)

model = AutoModelForSequenceClassification.from_pretrained(
    model_name,
    num_labels=3,  # positive, negative, neutral
)

training_args = TrainingArguments(
    output_dir="./sentiment-model",
    learning_rate=2e-5,
    per_device_train_batch_size=32,
    num_train_epochs=3,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    load_best_model_at_end=True,
    metric_for_best_model="f1",
)

from sklearn.metrics import f1_score, accuracy_score
import numpy as np

def compute_metrics(eval_pred):
    logits, labels = eval_pred
    preds = np.argmax(logits, axis=-1)
    return {
        "accuracy": accuracy_score(labels, preds),
        "f1": f1_score(labels, preds, average="weighted"),
    }

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized["train"],
    eval_dataset=tokenized["test"],
    compute_metrics=compute_metrics,
)

trainer.train()
trainer.save_model("./sentiment-model-final")
```

---

## Text Classification

### Zero-Shot Classification

```python
from transformers import pipeline

classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")

text = "The stock market rallied today after the Federal Reserve announced a rate cut."

result = classifier(
    text,
    candidate_labels=["finance", "politics", "technology", "sports", "health"],
    multi_label=False,
)

for label, score in zip(result["labels"], result["scores"]):
    print(f"{label:15s} {score:.3f}")
```

### Multi-Label Classification

```python
from transformers import pipeline

multi_label = pipeline(
    "zero-shot-classification",
    model="facebook/bart-large-mnli",
)

text = "New AI regulations proposed by EU could impact tech companies' stock prices."

result = multi_label(
    text,
    candidate_labels=["technology", "politics", "finance", "regulation", "AI"],
    multi_label=True,  # Multiple labels can be true
)

for label, score in zip(result["labels"], result["scores"]):
    print(f"{label:15s} {score:.3f}")
```

---

## Text Summarization

### Abstractive Summarization

```python
from transformers import pipeline

summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

article = """
The United Nations Climate Change Conference brought together representatives
from over 190 countries to discuss strategies for reducing carbon emissions.
Key topics included renewable energy investments, carbon trading mechanisms,
and financial support for developing nations. Several countries announced
new commitments to achieve net-zero emissions by 2050, while others pledged
to phase out coal power within the next decade. The conference concluded
with a joint declaration emphasizing the need for immediate action.
"""

summary = summarizer(
    article,
    max_length=60,
    min_length=20,
    do_sample=False,
)
print(summary[0]["summary_text"])

# For longer documents, use a model with larger context
long_summarizer = pipeline("summarization", model="google/pegasus-large")
```

### Extractive Summarization

```python
from transformers import AutoTokenizer, AutoModel
import torch
import numpy as np
from sklearn.cluster import KMeans

def extractive_summarize(text: str, num_sentences: int = 3) -> str:
    """Extract the most representative sentences using embeddings."""
    # Split into sentences
    import re
    sentences = re.split(r'(?<=[.!?])\s+', text.strip())
    if len(sentences) <= num_sentences:
        return text

    # Get sentence embeddings
    tokenizer = AutoTokenizer.from_pretrained("sentence-transformers/all-MiniLM-L6-v2")
    model = AutoModel.from_pretrained("sentence-transformers/all-MiniLM-L6-v2")

    encoded = tokenizer(sentences, padding=True, truncation=True, return_tensors="pt")
    with torch.no_grad():
        outputs = model(**encoded)
    embeddings = outputs.last_hidden_state[:, 0, :].numpy()

    # Cluster sentences and pick closest to centroid
    kmeans = KMeans(n_clusters=num_sentences, random_state=42)
    kmeans.fit(embeddings)

    selected_indices = []
    for i in range(num_sentences):
        cluster_mask = kmeans.labels_ == i
        cluster_embeddings = embeddings[cluster_mask]
        distances = np.linalg.norm(cluster_embeddings - kmeans.cluster_centers_[i], axis=1)
        closest_idx = np.where(cluster_mask)[0][np.argmin(distances)]
        selected_indices.append(closest_idx)

    # Return sentences in original order
    selected_indices.sort()
    summary_sentences = [sentences[i] for i in selected_indices]
    return " ".join(summary_sentences)
```

---

## Multilingual NLP

```python
from transformers import pipeline

# Multilingual NER
multilingual_ner = pipeline("ner", model="Davlan/xlm-roberta-large-ner-hrl", aggregation_strategy="simple")

# Works across languages
results_en = multilingual_ner("Barack Obama was born in Hawaii.")
results_fr = multilingual_ner("Emmanuel Macron est le president de la France.")
results_de = multilingual_ner("Angela Merkel war die Bundeskanzlerin von Deutschland.")

# Multilingual sentiment
multilingual_sentiment = pipeline(
    "sentiment-analysis",
    model="nlptown/bert-base-multilingual-uncased-sentiment",
)

# Multilingual zero-shot classification
from transformers import pipeline
multilingual_zs = pipeline(
    "zero-shot-classification",
    model="joeddav/xlm-roberta-large-xnli",
)

result = multilingual_zs(
    "Ce film est incroyable!",
    candidate_labels=["positive", "negative", "neutral"],
)
```

---

## Production Pipeline Architecture

```python
from dataclasses import dataclass, field
from typing import Any

@dataclass
class NLPResult:
    text: str
    preprocessed_text: str = ""
    entities: list[dict] = field(default_factory=list)
    sentiment: dict = field(default_factory=dict)
    classification: dict = field(default_factory=dict)
    summary: str = ""
    metadata: dict = field(default_factory=dict)

class NLPPipeline:
    """Composable NLP pipeline for production use."""

    def __init__(self, steps: list[str], config: dict = None):
        self.steps = steps
        self.config = config or {}
        self._init_components()

    def _init_components(self):
        self.preprocessor = TextPreprocessor()
        if "ner" in self.steps:
            self.ner = pipeline("ner", model=self.config.get("ner_model", "dslim/bert-base-NER"),
                              aggregation_strategy="simple")
        if "sentiment" in self.steps:
            self.sentiment = pipeline("sentiment-analysis",
                                    model=self.config.get("sentiment_model",
                                    "distilbert/distilbert-base-uncased-finetuned-sst-2-english"))
        if "classification" in self.steps:
            self.classifier = pipeline("zero-shot-classification",
                                     model=self.config.get("classifier_model", "facebook/bart-large-mnli"))
        if "summarization" in self.steps:
            self.summarizer = pipeline("summarization",
                                     model=self.config.get("summarizer_model", "facebook/bart-large-cnn"))

    def process(self, text: str, labels: list[str] = None) -> NLPResult:
        result = NLPResult(text=text)

        if "preprocess" in self.steps:
            result.preprocessed_text = self.preprocessor.process(text)
            proc_text = result.preprocessed_text
        else:
            proc_text = text

        if "ner" in self.steps:
            entities = self.ner(proc_text)
            result.entities = [
                {"text": e["word"], "label": e["entity_group"], "score": round(e["score"], 3)}
                for e in entities
            ]

        if "sentiment" in self.steps:
            sent = self.sentiment(proc_text[:512])[0]
            result.sentiment = {"label": sent["label"], "score": round(sent["score"], 3)}

        if "classification" in self.steps and labels:
            cls = self.classifier(proc_text[:1024], candidate_labels=labels)
            result.classification = {
                "labels": cls["labels"],
                "scores": [round(s, 3) for s in cls["scores"]],
            }

        if "summarization" in self.steps and len(proc_text) > 200:
            summary = self.summarizer(proc_text[:1024], max_length=100, min_length=20)
            result.summary = summary[0]["summary_text"]

        return result

    def process_batch(self, texts: list[str], labels: list[str] = None, batch_size: int = 32) -> list[NLPResult]:
        results = []
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            for text in batch:
                results.append(self.process(text, labels))
        return results

# Usage
pipeline_instance = NLPPipeline(
    steps=["preprocess", "ner", "sentiment", "classification"],
    config={"ner_model": "dslim/bert-base-NER"},
)

result = pipeline_instance.process(
    "Apple reported record Q4 earnings today in Cupertino.",
    labels=["technology", "finance", "politics"],
)
print(f"Entities: {result.entities}")
print(f"Sentiment: {result.sentiment}")
print(f"Classification: {result.classification}")
```

---

## Evaluation Metrics for NLP

```python
from sklearn.metrics import classification_report, confusion_matrix
from evaluate import load
import numpy as np

# Classification metrics
def evaluate_classifier(y_true, y_pred, label_names):
    report = classification_report(y_true, y_pred, target_names=label_names, output_dict=True)
    return {
        "accuracy": report["accuracy"],
        "macro_f1": report["macro avg"]["f1-score"],
        "weighted_f1": report["weighted avg"]["f1-score"],
        "per_class": {
            name: {"precision": report[name]["precision"],
                   "recall": report[name]["recall"],
                   "f1": report[name]["f1-score"]}
            for name in label_names
        },
    }

# NER metrics (entity-level)
def evaluate_ner(true_entities: list[list[dict]], pred_entities: list[list[dict]]) -> dict:
    """Compute precision, recall, F1 at entity level."""
    tp, fp, fn = 0, 0, 0
    for true_ents, pred_ents in zip(true_entities, pred_entities):
        true_set = {(e["text"], e["label"]) for e in true_ents}
        pred_set = {(e["text"], e["label"]) for e in pred_ents}
        tp += len(true_set & pred_set)
        fp += len(pred_set - true_set)
        fn += len(true_set - pred_set)

    precision = tp / (tp + fp) if (tp + fp) > 0 else 0
    recall = tp / (tp + fn) if (tp + fn) > 0 else 0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0

    return {"precision": precision, "recall": recall, "f1": f1}

# Summarization metrics
rouge = load("rouge")
def evaluate_summarization(predictions: list[str], references: list[str]) -> dict:
    result = rouge.compute(predictions=predictions, references=references)
    return {
        "rouge1": result["rouge1"],
        "rouge2": result["rouge2"],
        "rougeL": result["rougeL"],
    }
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track NLP experiment results
- Related: `3-build/synthetic_data_generation` -- Generate synthetic NLP training data
- Related: `4-secure/llm_evaluation_benchmarking` -- Evaluate NLP model quality
- Related: `2-design/feature_store_design` -- Serve NLP features in production
- Related: `toolkit/responsible_ai_framework` -- Bias in NLP models

---

## EXIT CHECKLIST

- [ ] Text preprocessing pipeline configured for data characteristics
- [ ] Tokenization strategy selected (BPE, WordPiece, SentencePiece)
- [ ] Model selected based on task, latency, and accuracy requirements
- [ ] Fine-tuning completed with appropriate training data (if applicable)
- [ ] Evaluation metrics computed and meet thresholds
- [ ] Multilingual support addressed (if required)
- [ ] Batch and real-time inference paths tested
- [ ] Pipeline components composable and independently testable
- [ ] Model serving latency benchmarked and within SLA
- [ ] Edge cases tested (empty strings, very long text, special characters)

---

*Skill Version: 1.0 | Created: March 2026*
