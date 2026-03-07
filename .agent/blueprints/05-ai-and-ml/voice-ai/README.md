# Blueprint: Voice AI

Building voice AI applications: automatic speech recognition (ASR), text-to-speech (TTS), voice agents, telephony integration, wake word detection, and real-time voice processing pipelines.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| OpenAI Whisper + TTS API | End-to-end voice pipeline, highest quality, cloud-based |
| Deepgram + ElevenLabs | Real-time ASR + premium voice synthesis, low latency |
| Vapi / Bland.ai | Turnkey voice agents, telephony built-in, no infra management |
| Whisper.cpp + Piper TTS | On-device/edge, offline operation, privacy-sensitive |
| Azure Speech Services | Enterprise, multi-language, custom voice models |
| LiveKit + Deepgram | WebRTC voice rooms, real-time transcription, multi-party |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define voice interaction model (command, conversation, dictation)
- **prd_generator** -- Document supported languages, latency SLA, accuracy requirements
- **competitive_analysis** -- Evaluate ASR providers, TTS quality, telephony platforms

Key scoping questions:
- What is the interaction model? (Voice commands, conversational agent, transcription, dictation)
- Real-time or offline? (Live conversation needs <500ms total latency)
- Where does processing run? (Cloud, edge, on-device)
- Telephony needed? (SIP/PSTN integration adds significant complexity)
- Multi-language or single? (Multilingual ASR is harder, affects model choice)

### Phase 2: Architecture
- **schema_design** -- Audio storage, transcript format, conversation history
- **api_design** -- Streaming audio API, WebSocket protocol, webhook callbacks

Architecture patterns:
- **Voice command pipeline**: Wake word -> ASR -> Intent classification -> Action -> TTS response
- **Voice agent pipeline**: Audio stream -> ASR (streaming) -> LLM -> TTS (streaming) -> Audio out
- **Transcription pipeline**: Audio upload -> ASR (batch) -> Speaker diarization -> Formatted transcript
- **Telephony agent**: SIP/PSTN -> Media stream -> ASR -> LLM -> TTS -> Audio bridge

### Phase 3: Implementation
- **tdd_workflow** -- Test audio processing, ASR accuracy on test set, intent parsing
- **error_handling** -- Noisy audio, silence detection, ASR failures, TTS timeout
- **code_review** -- Review audio buffering, latency measurements, resource cleanup

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end: audio in -> transcription -> response -> audio out
- **security_audit** -- Audio data privacy, PII in transcripts, voice cloning prevention
- **load_testing** -- Concurrent voice sessions, ASR throughput, memory usage

### Phase 5: Deployment
- **ci_cd_pipeline** -- Model versioning, voice profile deployment, A/B testing
- **deployment_patterns** -- GPU instances for Whisper, WebSocket scaling, media servers
- **monitoring_setup** -- ASR accuracy, latency percentiles, call quality metrics

## Key Domain-Specific Concerns

### ASR (Speech-to-Text) Selection

| Provider/Model | Latency | Accuracy | Cost | Best For |
|---------------|---------|----------|------|----------|
| Whisper large-v3 | High (batch) | Excellent | Self-host | Offline transcription, 100+ languages |
| Whisper turbo | Medium | Good | Self-host/API | Balance of speed and quality |
| Deepgram Nova-2 | Very low | Excellent | $0.0043/min | Real-time, streaming, production |
| Google Chirp 2 | Low | Excellent | $0.016/min | Multi-language, enterprise |
| Azure Speech | Low | Good | $0.016/min | Enterprise, custom models |
| Whisper.cpp | Medium | Good | Free | Edge, on-device, privacy |

### TTS (Text-to-Speech) Selection

| Provider | Latency | Quality | Cost | Best For |
|----------|---------|---------|------|----------|
| ElevenLabs | Low | Premium | $0.30/1K chars | Most natural, voice cloning |
| OpenAI TTS | Low | Good | $0.015/1K chars | Cost-effective, consistent |
| Deepgram Aura | Very low | Good | $0.0150/1K chars | Real-time, low latency |
| Piper TTS | Medium | Decent | Free | On-device, offline, privacy |
| Azure Neural TTS | Low | Good | $0.016/1K chars | Enterprise, SSML control |
| Cartesia Sonic | Very low | Good | $0.040/1K chars | Ultra-low latency streaming |

### Latency Optimization (Critical for Voice Agents)
- Target <500ms total round-trip for conversational agents
- Use streaming ASR: start processing as user speaks, not after they stop
- Use streaming TTS: start playing audio as soon as first chunk is generated
- Implement voice activity detection (VAD) to detect end-of-utterance quickly
- Pre-warm TTS connections -- first-byte latency is often the bottleneck
- Use WebSocket for bidirectional audio streaming, not REST
- Consider sentence-level TTS: generate first sentence while LLM produces the rest
- LLM latency is usually the bottleneck -- use faster models for voice (GPT-4o-mini, Claude Haiku)

### Audio Processing
- Sample rate: 16kHz mono for ASR input (standard), 24kHz+ for TTS output
- Use WebM/Opus for browser audio, PCM/WAV for server processing
- Implement echo cancellation if building full-duplex voice (user and agent talk simultaneously)
- Buffer audio in chunks (100-200ms) for streaming processing
- Handle silence detection: 1.5-2s silence typically indicates end of utterance
- Normalize audio levels before ASR for consistent accuracy

### Telephony Integration
- Use Twilio, Vonage, or Telnyx for SIP/PSTN connectivity
- Media streams arrive as base64-encoded mulaw/alaw audio over WebSocket
- Handle DTMF tones for IVR-style menu navigation
- Implement call transfer, hold, and conference capabilities
- Monitor call quality: jitter, packet loss, MOS score
- Comply with call recording laws (two-party consent states, GDPR)

### Wake Word Detection
- Use Picovoice Porcupine for custom wake words (runs on-device)
- Alternative: Snowboy (deprecated but functional), OpenWakeWord (open-source)
- Wake word models run continuously -- optimize for low CPU/memory
- Implement false activation rate testing: run against hours of ambient audio
- Buffer 1-2s of pre-wake-word audio to capture the full utterance

### Conversation Management for Voice Agents
- Implement barge-in: let users interrupt the agent mid-response
- Handle disfluencies: "um", "uh", false starts -- do not treat as commands
- Use turn-taking signals: pitch drop, lengthened final syllable, silence
- Maintain conversation state across turns with session memory
- Add confirmation for high-stakes actions: "You want to transfer $500. Is that right?"

## Getting Started

1. **Define the voice interaction** -- Command-based, conversational, or transcription?
2. **Choose ASR provider** -- Deepgram for real-time, Whisper for batch/self-hosted
3. **Choose TTS provider** -- ElevenLabs for quality, OpenAI for cost, Piper for offline
4. **Build audio capture** -- Browser MediaRecorder, WebSocket streaming, or telephony
5. **Implement ASR pipeline** -- Audio -> text with timestamps and confidence
6. **Add intent processing** -- LLM or classifier to determine user intent
7. **Build response generation** -- LLM for open conversation, templates for commands
8. **Implement TTS pipeline** -- Text -> audio with streaming playback
9. **Add conversation management** -- Turn-taking, barge-in, session memory
10. **Deploy with monitoring** -- Latency dashboards, ASR accuracy tracking, call analytics

## Project Structure

```
src/
  audio/
    capture.py              # Audio input (mic, WebSocket, telephony)
    playback.py             # Audio output and streaming
    vad.py                  # Voice activity detection
    processing.py           # Normalization, resampling, format conversion
  asr/
    transcriber.py          # ASR provider abstraction
    streaming.py            # Real-time streaming transcription
    batch.py                # Batch file transcription
    diarization.py          # Speaker identification
  tts/
    synthesizer.py          # TTS provider abstraction
    streaming.py            # Streaming audio generation
    voice_profiles.py       # Voice selection and customization
  agent/
    conversation.py         # Conversation state management
    turn_taking.py          # Barge-in, silence detection, turn signals
    intent.py               # Intent classification
    response.py             # Response generation (LLM or template)
  telephony/
    sip.py                  # SIP/PSTN integration
    media_stream.py         # WebSocket media stream handling
    dtmf.py                 # Touch-tone processing
    call_control.py         # Transfer, hold, conference
  wake_word/
    detector.py             # Wake word detection
    models/                 # Wake word model files
  api/
    websocket.py            # WebSocket endpoint for streaming audio
    rest.py                 # REST endpoints for batch operations
    webhooks.py             # Telephony webhook handlers
config/
  asr.yaml                  # ASR provider config
  tts.yaml                  # TTS provider and voice config
  telephony.yaml            # SIP trunk, phone numbers
  agent.yaml                # Conversation settings, timeouts
```
