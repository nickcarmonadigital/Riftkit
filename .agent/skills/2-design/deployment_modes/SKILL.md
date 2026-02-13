---
name: Deployment Modes Architecture
description: Mandatory 3-tier compliance check (Cloud/Hybrid/Sovereign) for every feature, spec, and workflow
---

# Deployment Modes Architecture Skill

**Purpose**: Ensure every feature in Zenith-OS supports all 3 deployment modes from the start. This skill is **MANDATORY** for every feature spec.

> [!IMPORTANT]
> **This is a BLOCKING check.** No feature spec is complete without the Deployment Modes section.

---

## 🎯 TRIGGER COMMANDS

This skill should be referenced for:

```text
- Every feature spec during Phase 2 (Skills Scan)
- Every implementation plan before coding begins
- Every workflow that touches user data
- Every onboarding flow (most critical)
```

---

## 📋 THE 3 DEPLOYMENT MODES

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    ZENITH-OS DEPLOYMENT MODES                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ← FULLY CLOUD                    HYBRID                    SOVEREIGN →          │
│  (Easy, Managed)                  (Best of Both)            (Max Control)        │
│                                                                                  │
│  ┌────────────────┐         ┌────────────────┐         ┌────────────────┐       │
│  │     CLOUD      │         │     HYBRID     │         │   SOVEREIGN    │       │
│  │                │         │                │         │                │       │
│  │  Supabase DB   │         │  Your Cloud DB │         │  Local SQLite  │       │
│  │  Cloud Storage │         │  + Local Cache │         │  Local Files   │       │
│  │  Cloud AI APIs │         │  + Local AI    │         │  Local AI Only │       │
│  │                │         │                │         │                │       │
│  │  [For Teams]   │         │ [For Growing]  │         │ [For Privacy]  │       │
│  └────────────────┘         └────────────────┘         └────────────────┘       │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🧬 MODE DEFINITIONS

### 1. CLOUD Mode

**Who it's for**: Teams who want managed infrastructure, quick setup, collaboration.

| Component | Implementation |
|-----------|----------------|
| **Database** | Supabase (PostgreSQL) |
| **Storage** | Supabase Storage / Cloudflare R2 / S3 |
| **AI Models** | OpenAI, Claude, Gemini via API |
| **Processing** | Cloud functions / Serverless |
| **Authentication** | Supabase Auth |

**Privacy Note**: Data stored in cloud. May be used to train third-party AI (OpenAI, etc.) unless opted out.

---

### 2. HYBRID Mode

**Who it's for**: Growing companies who want cloud convenience with local processing power.

| Component | Implementation |
|-----------|----------------|
| **Database** | Cloud DB (AWS RDS, GCP SQL) OR Supabase |
| **Storage** | Cloud + Local cache for large files |
| **AI Models** | Cloud APIs + Local Ollama for sensitive tasks |
| **Processing** | Local FFmpeg, local Whisper, cloud fallback |
| **Authentication** | Cloud Auth OR local JWT |

**Privacy Note**: User chooses what goes to cloud vs stays local.

---

### 3. SOVEREIGN Mode

**Who it's for**: Maximum privacy, compliance (HIPAA, SOC2), air-gapped environments.

| Component | Implementation |
|-----------|----------------|
| **Database** | Local SQLite OR local PostgreSQL |
| **Storage** | Local filesystem (`./data/`) |
| **AI Models** | Ollama only (Llama, Mistral, DeepSeek) |
| **Processing** | 100% local (FFmpeg, Whisper local) |
| **Authentication** | Local JWT, no external auth |

**Privacy Note**: Zero data leaves the machine. **Zenith-OS does NOT train on any data.**

---

## 🏗️ ABSTRACTION PATTERNS

### Database Abstraction

Every database operation MUST use the abstraction layer:

```typescript
// ❌ WRONG - Direct Supabase call
const { data } = await supabase.from('contacts').select('*');

// ✅ CORRECT - Use repository pattern
const data = await contactRepository.findAll();
```

**Repository Pattern**:

```typescript
// backend/src/common/database/repository.interface.ts
interface Repository<T> {
  findAll(options?: QueryOptions): Promise<T[]>;
  findById(id: string): Promise<T | null>;
  create(data: Partial<T>): Promise<T>;
  update(id: string, data: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
}

// Implementations switch based on mode:
// - CloudRepository → uses Prisma/Supabase
// - SovereignRepository → uses SQLite via Prisma
```

---

### Storage Abstraction

Every file operation MUST use the storage provider:

```typescript
// ❌ WRONG - Direct S3 call
await s3.upload({ Bucket: 'my-bucket', Key: path, Body: file });

// ✅ CORRECT - Use storage provider
await storageProvider.upload(file, path);
```

**Storage Provider Interface**:

```typescript
// backend/src/common/storage/storage.interface.ts
interface StorageProvider {
  upload(file: Buffer, path: string): Promise<string>;
  download(path: string): Promise<Buffer>;
  delete(path: string): Promise<void>;
  getSignedUrl(path: string, expiresIn?: number): Promise<string>;
  exists(path: string): Promise<boolean>;
}

// Implementations:
// - CloudStorage → R2/S3/Supabase Storage
// - LocalStorage → local filesystem
// - HybridStorage → local cache + cloud sync
```

---

### AI Provider Abstraction

Every AI call MUST use the provider abstraction:

```typescript
// ❌ WRONG - Direct OpenAI call
const response = await openai.chat.completions.create({ ... });

// ✅ CORRECT - Use AI provider
const response = await aiProvider.chat(messages, options);
```

**AI Provider Interface**:

```typescript
// backend/src/common/ai/ai-provider.interface.ts
interface AIProvider {
  chat(messages: Message[], options?: ChatOptions): Promise<ChatResponse>;
  embed(text: string): Promise<number[]>;
  transcribe(audio: Buffer, options?: TranscribeOptions): Promise<Transcript>;
  generate(prompt: string, options?: GenerateOptions): Promise<string>;
}

// Implementations:
// - OpenAIProvider, ClaudeProvider, GeminiProvider → Cloud
// - OllamaProvider → Local (Sovereign)
// - WhisperLocalProvider → Local transcription
```

---

### Processing Abstraction

Every heavy processing MUST support local execution:

```typescript
// FFmpeg, Whisper, Image Processing
interface Processor {
  process(input: string, options: ProcessOptions): Promise<string>;
  isAvailable(): Promise<boolean>;
  getCapabilities(): ProcessorCapabilities;
}

// Implementations:
// - LocalFFmpegProcessor → runs ffmpeg locally
// - CloudFFmpegProcessor → uses cloud transcoding (future)
```

---

## 📋 MANDATORY SPEC SECTION

**Every feature spec MUST include this section:**

```markdown
## Deployment Modes Compliance

### Database Operations

| Operation | Cloud | Hybrid | Sovereign |
|-----------|-------|--------|-----------|
| User CRUD | Supabase | Any PostgreSQL | SQLite |
| [Feature] CRUD | Supabase | Any PostgreSQL | SQLite |

### Storage Operations

| Operation | Cloud | Hybrid | Sovereign |
|-----------|-------|--------|-----------|
| File uploads | R2/S3 | Cloud + local cache | Local filesystem |
| Large media | R2/S3 | Local preferred | Local only |

### AI Operations

| Operation | Cloud | Hybrid | Sovereign |
|-----------|-------|--------|-----------|
| Text generation | OpenAI/Claude | Cloud or Ollama | Ollama only |
| Transcription | Deepgram | Deepgram or Whisper | Whisper local |
| Embeddings | OpenAI | OpenAI or local | Local embeddings |

### Heavy Processing

| Operation | Cloud | Hybrid | Sovereign |
|-----------|-------|--------|-----------|
| Video clipping | Cloud worker | Local FFmpeg | Local FFmpeg |
| Image generation | DALL-E/SD | Cloud or local SD | Local SD only |

### Abstraction Verification

- [ ] All database calls use Repository pattern
- [ ] All storage calls use StorageProvider
- [ ] All AI calls use AIProvider abstraction
- [ ] All processing has local fallback
- [ ] Feature works offline (Sovereign mode)
```

---

## 🔄 ONBOARDING INTEGRATION

**Critical**: Onboarding MUST capture deployment mode choice:

### Onboarding Questions

```markdown
## Deployment Mode Selection (Phase 0)

**Question**: How do you want to run Zenith-OS?

[ ] **Cloud Mode** (Recommended for Teams)
    - Quick setup, managed infrastructure
    - Data synced across devices
    - Requires internet connection
    
[ ] **Hybrid Mode** (Best of Both)
    - Your cloud + local AI
    - Sensitive data stays local
    - Works offline for most features
    
[ ] **Sovereign Mode** (Maximum Privacy)
    - 100% on your machine
    - No data leaves your computer
    - Requires local compute power
```

### Migration Path

Users can migrate between modes:

```text
Cloud → Hybrid → Sovereign (Export & import data)
Sovereign → Hybrid → Cloud (Sync to cloud)
```

---

## ✅ COMPLIANCE CHECKLIST

Before marking any feature spec complete:

### Phase 0: Foundation Check

- [ ] Feature uses Repository pattern for all DB operations
- [ ] Feature uses StorageProvider for all file operations
- [ ] Feature uses AIProvider for all AI operations

### Phase 1: Cloud Mode

- [ ] Works with Supabase database
- [ ] Works with cloud storage (R2/S3)
- [ ] Works with cloud AI (OpenAI/Claude/Gemini)

### Phase 2: Hybrid Mode

- [ ] Works with external PostgreSQL
- [ ] Local caching implemented for large files
- [ ] Can switch between cloud and local AI

### Phase 3: Sovereign Mode

- [ ] Works with SQLite database
- [ ] Works with local filesystem
- [ ] Works with Ollama (local LLM)
- [ ] Feature functional without internet

### Phase 4: Graceful Degradation

- [ ] Clear error messages when feature unavailable in mode
- [ ] UI shows what's available vs. requires upgrade
- [ ] No crashes when AI provider unavailable

---

## 🚨 COMMON MISTAKES

| Mistake | Problem | Solution |
|---------|---------|----------|
| Hardcoded `supabase.from()` | Breaks Sovereign mode | Use Repository |
| Direct S3 calls | Breaks local storage | Use StorageProvider |
| Direct OpenAI calls | Breaks Sovereign mode | Use AIProvider |
| Assuming internet | Breaks offline mode | Add connectivity check |
| No local AI fallback | Feature unusable Sovereign | Add Ollama support |

---

## 📁 FILE STRUCTURE

```text
backend/src/common/
├── database/
│   ├── repository.interface.ts      ← Base interface
│   ├── cloud.repository.ts          ← Supabase/Prisma
│   ├── sovereign.repository.ts      ← SQLite/Prisma
│   └── repository.factory.ts        ← Mode switcher
├── storage/
│   ├── storage.interface.ts         ← Base interface
│   ├── cloud.storage.ts             ← R2/S3
│   ├── local.storage.ts             ← Filesystem
│   └── storage.factory.ts           ← Mode switcher
├── ai/
│   ├── ai-provider.interface.ts     ← Base interface
│   ├── openai.provider.ts           ← OpenAI
│   ├── claude.provider.ts           ← Claude
│   ├── gemini.provider.ts           ← Gemini
│   ├── ollama.provider.ts           ← Local
│   └── ai.factory.ts                ← Mode switcher
└── config/
    └── deployment-mode.config.ts    ← Mode detection
```

---

## 🎯 QUICK REFERENCE

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          DEPLOYMENT MODE QUICK CHECK                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  FOR EVERY NEW FEATURE, ASK:                                                     │
│                                                                                  │
│  1. □ Does this touch the DATABASE?                                             │
│       → Use Repository pattern                                                   │
│                                                                                  │
│  2. □ Does this touch FILES/MEDIA?                                              │
│       → Use StorageProvider                                                      │
│                                                                                  │
│  3. □ Does this use AI?                                                         │
│       → Use AIProvider abstraction                                               │
│       → Ensure Ollama fallback exists                                            │
│                                                                                  │
│  4. □ Does this require INTERNET?                                               │
│       → Add offline mode handling                                                │
│       → Show clear "requires cloud" message                                      │
│                                                                                  │
│  5. □ Does this need HEAVY PROCESSING?                                          │
│       → Ensure local processor available                                         │
│       → FFmpeg, Whisper must run locally                                         │
│                                                                                  │
│  IF ANY ANSWER IS "YES" → ADD TO DEPLOYMENT MODES TABLE IN SPEC                 │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

*"Build for Cloud. Test for Sovereign. Ship for Everyone."*
