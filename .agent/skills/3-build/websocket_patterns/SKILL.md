---
name: "WebSocket & Real-Time Patterns"
description: "WebSocket implementation, real-time communication, Socket.IO, SSE, and pub/sub patterns"
triggers:
  - "/websocket"
  - "/realtime"
  - "/real-time"
  - "/socket-io"
---

# WebSocket & Real-Time Patterns

## WHEN TO USE
- Building real-time features (chat, notifications, live updates)
- Implementing WebSocket servers (ws, Socket.IO, Phoenix Channels)
- Choosing between WebSocket, SSE, and long polling
- Scaling real-time connections across multiple servers

## PROCESS

### 1. Protocol Selection
| Need | Use |
|------|-----|
| Bidirectional, low latency | WebSocket |
| Server-push only, simple | Server-Sent Events (SSE) |
| Behind strict proxies/firewalls | Long polling (fallback) |
| Browser + mobile + reconnection | Socket.IO (handles all above) |

### 2. Connection Management
- Implement heartbeat/ping-pong to detect stale connections
- Handle reconnection with exponential backoff
- Authenticate on connection (JWT in query param or first message)
- Set connection limits per user/IP

### 3. Message Design
- Use structured message format: `{ type, payload, timestamp, id }`
- Implement message acknowledgment for critical operations
- Add message ordering guarantees where needed (sequence numbers)
- Compress large payloads (permessage-deflate)

### 4. Scaling
- Use Redis Pub/Sub or NATS for multi-server message broadcasting
- Implement sticky sessions or use a message broker
- Horizontal scaling: each server handles its connections, broker distributes
- Monitor connection counts, message rates, and memory per connection

### 5. Security
- Validate all incoming messages (schema validation)
- Rate limit messages per connection
- Implement room/channel authorization
- Never trust client-sent user IDs — use server-side session

## CHECKLIST
- [ ] Protocol chosen based on requirements
- [ ] Heartbeat/ping-pong implemented
- [ ] Reconnection with backoff implemented
- [ ] Authentication on connection (not per-message)
- [ ] Message validation on all incoming data
- [ ] Rate limiting per connection
- [ ] Horizontal scaling strategy defined
- [ ] Memory monitoring for connection count

## Related Skills
- [`event_driven_architecture`](../event_driven_architecture/SKILL.md)
- [`multiplayer_systems`](../multiplayer_systems/SKILL.md)
