---
name: "Voice AI Patterns"
description: "Voice AI development — STT, TTS, real-time audio streaming, barge-in detection, and conversational AI"
triggers:
  - "/voice-ai"
  - "/voice"
  - "/stt-tts"
  - "/speech"
---

# Voice AI Patterns

## WHEN TO USE
- Building voice-enabled AI agents or assistants
- Implementing real-time speech-to-text and text-to-speech
- Creating phone/WebSocket-based voice interactions
- Handling barge-in (interruption) detection

## PROCESS

### 1. Provider Selection
| Component | Options | Latency |
|-----------|---------|---------|
| STT | Deepgram, Google Speech, Whisper, AssemblyAI | 100-500ms |
| TTS | ElevenLabs, Cartesia, Google TTS, OpenAI TTS | 200-800ms |
| LLM | Gemini (fast), Claude (quality), GPT-4o (balanced) | 500-2000ms |
| Telephony | Telnyx, Twilio, Vonage | N/A |

### 2. Audio Pipeline
- Use WebSocket for real-time audio streaming (not REST)
- Buffer audio in chunks (20-100ms frames)
- Handle audio format conversion (PCM, mulaw, WAV)
- Implement voice activity detection (VAD) for endpoint detection

### 3. Latency Optimization
- Target less than 300ms total round-trip for natural conversation
- Stream TTS output (do not wait for full generation)
- Use sentence-level chunking for LLM to TTS pipeline
- Pre-warm connections to all providers on session start

### 4. Barge-In Detection
- Monitor for speech during TTS playback
- When detected: stop TTS, capture new input, process
- Avoid false triggers from echo/feedback (use echo cancellation)
- Implement minimum speech threshold before interrupting

### 5. Conversation Memory
- Maintain chat history across turns (not just single-turn)
- Pass history to LLM on each turn for context
- Implement context window management (summarize old turns)
- Persist conversation for analytics and debugging

### 6. Error Handling
- Provider failover: if primary STT fails, switch to backup
- Silence handling: what to do when user goes quiet
- Audio quality issues: handle noise, low volume, encoding errors
- Graceful degradation: text fallback if voice pipeline fails

## CHECKLIST
- [ ] STT/TTS/LLM providers selected with latency targets
- [ ] WebSocket audio streaming implemented
- [ ] Round-trip latency under 300ms achieved
- [ ] Barge-in detection working
- [ ] Chat history persisted across turns
- [ ] Provider failover configured
- [ ] Silence/error handling implemented
- [ ] Cost monitoring per session

## Related Skills
- [`ai_agent_development`](../ai_agent_development/SKILL.md)
- [`websocket_patterns`](../websocket_patterns/SKILL.md)
