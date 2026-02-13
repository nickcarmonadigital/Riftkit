---
name: multiplayer_systems
description: Real-time multiplayer game networking architecture, netcode patterns, and scalable backend infrastructure
---

# Multiplayer Systems Skill

**Purpose**: Provides architecture patterns, netcode fundamentals, and infrastructure guidance for building real-time and turn-based multiplayer games with reliable, low-latency networking.

## :dart: TRIGGER COMMANDS

```text
"add multiplayer"
"build multiplayer game"
"netcode architecture"
"set up game server"
"implement matchmaking"
"Using multiplayer_systems skill: design multiplayer backend"
```

## :globe_with_meridians: ARCHITECTURE PATTERNS

| Pattern | Authority | Latency | Anti-Cheat | Complexity | Best For |
|---------|-----------|---------|------------|------------|----------|
| **Client-Server (Authoritative)** | Server | Medium (1 RTT) | Strong | Medium | FPS, competitive, most games |
| **Client-Server (Relay)** | Host client | Medium | Weak | Low | Casual co-op |
| **Peer-to-Peer (Lockstep)** | All peers | High (slowest peer) | Moderate | High | RTS, fighting games |
| **Peer-to-Peer (Rollback)** | All peers | Low (local prediction) | Moderate | Very High | Fighting games (GGPO) |
| **Hybrid** | Server + prediction | Low (predicted) | Strong | High | MMOs, battle royale |

### Why Authoritative Server Wins

```
Client-Server (Authoritative) — The Gold Standard

  Client A                Server                 Client B
     |                      |                       |
     |--- Input (move) ---->|                       |
     |   [predict locally]  |                       |
     |                      |--- State update ------>|
     |                      |   [interpolate]        |
     |<--- State update ----|                       |
     |   [reconcile]        |                       |

Key principle: Clients send INPUTS, server sends STATE.
The server is the single source of truth.
Clients predict locally for responsiveness, then reconcile with server state.
```

> [!TIP]
> Always start with an authoritative server model unless you have a very specific reason not to (e.g., fighting game with GGPO rollback). It is far easier to prevent cheating when the server validates every action than to detect cheating in peer-to-peer.

## :electric_plug: NETWORKING PROTOCOLS

| Protocol | Reliability | Ordering | Latency | Overhead | Use Case |
|----------|------------|----------|---------|----------|----------|
| **TCP** | Guaranteed | Ordered | Higher (head-of-line blocking) | 20+ bytes | Chat, inventory, login |
| **UDP** | None | None | Lowest | 8 bytes | Position updates, FPS state |
| **WebSocket** | Guaranteed (TCP) | Ordered | Medium | 2-14 bytes frame | Web games, turn-based |
| **WebRTC DataChannel** | Configurable | Configurable | Low | Varies | Web games needing UDP-like |
| **ENet** | Configurable | Configurable | Low | Small | Native games, reliable UDP |
| **KCP** | Reliable over UDP | Ordered | Low | Small | High-frequency state sync |

> [!WARNING]
> TCP's head-of-line blocking means one dropped packet delays ALL subsequent packets. For fast-paced games (FPS, racing), this creates unacceptable lag spikes. Use UDP with custom reliability layers, or WebRTC DataChannel for web games. Reserve TCP/WebSocket for non-time-critical data (chat, leaderboards, login).

### Protocol Selection by Game Type

| Game Type | Primary Protocol | Secondary Protocol |
|-----------|-----------------|-------------------|
| FPS / Action | UDP (ENet/custom) | TCP (login, chat) |
| MOBA | UDP | TCP (shop, chat) |
| RTS (Lockstep) | TCP or reliable UDP | N/A |
| MMO | TCP + UDP | TCP (world), UDP (combat) |
| Turn-based | WebSocket/TCP | N/A |
| Web multiplayer | WebSocket or WebRTC | WebSocket (fallback) |
| Mobile casual | WebSocket | N/A |

## :crystal_ball: NETCODE FUNDAMENTALS

### Client-Side Prediction

The client immediately applies the player's input locally without waiting for server confirmation. This makes the game feel responsive despite network latency.

```typescript
// Client-side prediction
class PredictedPlayer {
  private position: Vector2 = { x: 0, y: 0 };
  private pendingInputs: PlayerInput[] = [];
  private inputSequence = 0;

  // Called every client tick
  processInput(input: PlayerInput): void {
    input.sequence = this.inputSequence++;

    // Apply input locally (prediction)
    this.applyInput(input);

    // Store for later reconciliation
    this.pendingInputs.push(input);

    // Send to server
    this.sendToServer(input);
  }

  // Called when server state arrives
  onServerState(serverState: ServerState): void {
    // Set position to authoritative server state
    this.position = { ...serverState.position };

    // Remove inputs the server has already processed
    this.pendingInputs = this.pendingInputs.filter(
      (input) => input.sequence > serverState.lastProcessedInput
    );

    // Re-apply pending inputs that server hasn't processed yet
    for (const input of this.pendingInputs) {
      this.applyInput(input);
    }
  }

  private applyInput(input: PlayerInput): void {
    // Deterministic movement calculation
    if (input.left) this.position.x -= MOVE_SPEED * TICK_DURATION;
    if (input.right) this.position.x += MOVE_SPEED * TICK_DURATION;
    if (input.up) this.position.y -= MOVE_SPEED * TICK_DURATION;
    if (input.down) this.position.y += MOVE_SPEED * TICK_DURATION;
  }

  private sendToServer(input: PlayerInput): void { /* network send */ }
}
```

### Server Reconciliation

When a server state update arrives that disagrees with the client's prediction, the client "snaps" to the server state and re-applies any inputs the server has not yet acknowledged.

### Entity Interpolation

Other players (non-local entities) are rendered between two known server states, creating smooth visual movement despite receiving updates at a lower rate than the render frame rate.

```typescript
// Entity interpolation for remote players
class InterpolatedEntity {
  private stateBuffer: { position: Vector2; timestamp: number }[] = [];
  private readonly INTERPOLATION_DELAY = 100; // ms (render 100ms in the past)

  // Called when a new server state arrives
  addState(position: Vector2, serverTime: number): void {
    this.stateBuffer.push({ position, timestamp: serverTime });

    // Keep only recent states (1 second buffer)
    const cutoff = serverTime - 1000;
    this.stateBuffer = this.stateBuffer.filter((s) => s.timestamp >= cutoff);
  }

  // Called every render frame
  getInterpolatedPosition(currentServerTime: number): Vector2 {
    const renderTime = currentServerTime - this.INTERPOLATION_DELAY;

    // Find the two states to interpolate between
    let before = this.stateBuffer[0];
    let after = this.stateBuffer[0];

    for (let i = 0; i < this.stateBuffer.length - 1; i++) {
      if (this.stateBuffer[i].timestamp <= renderTime &&
          this.stateBuffer[i + 1].timestamp >= renderTime) {
        before = this.stateBuffer[i];
        after = this.stateBuffer[i + 1];
        break;
      }
    }

    // Linear interpolation
    const range = after.timestamp - before.timestamp;
    const t = range > 0 ? (renderTime - before.timestamp) / range : 0;

    return {
      x: before.position.x + (after.position.x - before.position.x) * t,
      y: before.position.y + (after.position.y - before.position.y) * t,
    };
  }
}
```

### Lag Compensation

For hit detection in FPS games, the server "rewinds" the game state to the time when the shooting player actually fired, accounting for their latency.

```typescript
// Server-side lag compensation (conceptual)
class LagCompensation {
  private worldHistory: Map<number, WorldSnapshot> = new Map(); // tick -> snapshot

  // Store world state every tick
  saveSnapshot(tick: number, snapshot: WorldSnapshot): void {
    this.worldHistory.set(tick, snapshot);
    // Prune old snapshots (keep 1 second)
    const cutoff = tick - this.server.tickRate;
    for (const [t] of this.worldHistory) {
      if (t < cutoff) this.worldHistory.delete(t);
    }
  }

  // When processing a shoot command
  processShoot(shooterInput: ShootInput): HitResult {
    // Estimate the tick when the shooter saw the world
    const clientTick = shooterInput.clientTick;
    const latencyTicks = Math.round(
      shooterInput.latencyMs / (1000 / this.server.tickRate)
    );
    const rewindTick = Math.max(0, clientTick - latencyTicks);

    // Get historical world state
    const historicalState = this.worldHistory.get(rewindTick);
    if (!historicalState) return { hit: false };

    // Perform hit detection against rewound positions
    return this.raycast(
      shooterInput.origin,
      shooterInput.direction,
      historicalState.playerPositions
    );
  }

  private raycast(
    origin: Vector3, direction: Vector3, targets: PlayerPosition[]
  ): HitResult { /* raycast implementation */ return { hit: false }; }
}
```

## :stopwatch: TICK RATE AND SEND RATE

| Setting | Typical Value | Impact |
|---------|--------------|--------|
| **Server tick rate** | 60-128 Hz (FPS), 20-30 Hz (casual) | Higher = more accurate simulation, more CPU |
| **Client send rate** | 30-64 Hz | How often client sends input to server |
| **Server send rate** | 20-30 Hz | How often server sends state to clients |
| **Interpolation delay** | 100ms (3 ticks at 30Hz) | Trade-off: smoothness vs responsiveness |
| **Max acceptable RTT** | <100ms competitive, <200ms casual | Region-based matchmaking threshold |

> [!TIP]
> You do NOT need to send state updates at the same rate as the server tick rate. A 64-tick server can send snapshots at 20Hz and clients interpolate between them. This dramatically reduces bandwidth. Valorant runs at 128 tick server but sends updates at 30Hz to clients.

## :door: LOBBY SYSTEM

```typescript
// Room/lobby management (conceptual, works with any framework)
interface Room {
  id: string;
  name: string;
  hostId: string;
  players: Map<string, PlayerInfo>;
  maxPlayers: number;
  state: 'waiting' | 'ready' | 'in_game' | 'finished';
  settings: GameSettings;
}

class LobbyManager {
  private rooms: Map<string, Room> = new Map();

  createRoom(host: PlayerInfo, settings: GameSettings): string {
    const room: Room = {
      id: crypto.randomUUID(),
      name: `${host.name}'s Room`,
      hostId: host.id,
      players: new Map([[host.id, host]]),
      maxPlayers: settings.maxPlayers,
      state: 'waiting',
      settings,
    };
    this.rooms.set(room.id, room);
    return room.id;
  }

  joinRoom(roomId: string, player: PlayerInfo): boolean {
    const room = this.rooms.get(roomId);
    if (!room) return false;
    if (room.state !== 'waiting') return false;
    if (room.players.size >= room.maxPlayers) return false;

    room.players.set(player.id, player);
    this.broadcastToRoom(roomId, { type: 'player_joined', player });
    return true;
  }

  setReady(roomId: string, playerId: string, ready: boolean): void {
    const room = this.rooms.get(roomId);
    if (!room) return;
    const player = room.players.get(playerId);
    if (player) player.ready = ready;

    // Check if all players are ready
    const allReady = [...room.players.values()].every((p) => p.ready);
    if (allReady && room.players.size >= 2) {
      this.startGame(roomId);
    }
  }

  // Host migration when host disconnects
  migrateHost(roomId: string): void {
    const room = this.rooms.get(roomId);
    if (!room) return;
    room.players.delete(room.hostId);

    const nextHost = room.players.values().next().value;
    if (nextHost) {
      room.hostId = nextHost.id;
      this.broadcastToRoom(roomId, { type: 'host_migrated', newHostId: nextHost.id });
    } else {
      this.rooms.delete(roomId); // no players left
    }
  }

  private startGame(roomId: string): void { /* transition to game state */ }
  private broadcastToRoom(roomId: string, message: unknown): void { /* send to all players */ }
}
```

## :trophy: MATCHMAKING

### Skill-Based Matchmaking

| System | Complexity | Best For | Notes |
|--------|-----------|----------|-------|
| **ELO** | Low | 1v1 games | Chess-style, simple formula |
| **Glicko-2** | Medium | 1v1, small teams | Accounts for rating uncertainty |
| **TrueSkill** | High | Team games | Microsoft's system, handles teams |
| **Custom MMR** | Variable | Any | Tune to your game's needs |

```typescript
// Simple ELO matchmaking
class Matchmaker {
  private queue: QueueEntry[] = [];
  private readonly MATCH_RANGE = 200; // initial MMR range
  private readonly EXPAND_RATE = 50; // expand range every 30 seconds
  private readonly MAX_RANGE = 500;

  addToQueue(player: PlayerInfo): void {
    this.queue.push({
      player,
      mmr: player.mmr,
      queuedAt: Date.now(),
      range: this.MATCH_RANGE,
    });
  }

  // Run periodically (every 1-5 seconds)
  findMatches(): Match[] {
    const matches: Match[] = [];
    const now = Date.now();

    // Expand search range for players waiting longer
    for (const entry of this.queue) {
      const waitSeconds = (now - entry.queuedAt) / 1000;
      entry.range = Math.min(
        this.MAX_RANGE,
        this.MATCH_RANGE + Math.floor(waitSeconds / 30) * this.EXPAND_RATE
      );
    }

    // Sort by wait time (longest waiting first)
    this.queue.sort((a, b) => a.queuedAt - b.queuedAt);

    // Try to pair players
    const matched = new Set<string>();
    for (let i = 0; i < this.queue.length; i++) {
      if (matched.has(this.queue[i].player.id)) continue;

      for (let j = i + 1; j < this.queue.length; j++) {
        if (matched.has(this.queue[j].player.id)) continue;

        const mmrDiff = Math.abs(this.queue[i].mmr - this.queue[j].mmr);
        const maxRange = Math.max(this.queue[i].range, this.queue[j].range);

        if (mmrDiff <= maxRange) {
          matches.push({
            players: [this.queue[i].player, this.queue[j].player],
          });
          matched.add(this.queue[i].player.id);
          matched.add(this.queue[j].player.id);
          break;
        }
      }
    }

    // Remove matched players from queue
    this.queue = this.queue.filter((e) => !matched.has(e.player.id));
    return matches;
  }
}
```

## :shield: ANTI-CHEAT STRATEGIES

| Strategy | Server-Side | Detects | Implementation |
|----------|------------|---------|----------------|
| **Input validation** | Yes | Speed hacks, teleporting | Clamp movement per tick to max speed |
| **State validation** | Yes | Impossible states | Verify health > 0 when acting, inventory consistency |
| **Rate limiting** | Yes | Rapid-fire hacks | Max N actions per tick |
| **Position verification** | Yes | Teleport/noclip | Server physics simulation, reject impossible moves |
| **Replay analysis** | Post-game | Aimbots, wallhacks | Record inputs, analyze statistically |
| **Encrypted protocol** | Both | Packet manipulation | Encrypt game traffic, HMAC messages |
| **Kernel anti-cheat** | Client-side | Memory editing, injectors | EasyAntiCheat, BattlEye, Vanguard |

```typescript
// Server-side input validation example
function validatePlayerInput(
  input: PlayerInput,
  lastValidState: PlayerState,
  tickDuration: number
): ValidationResult {
  const maxMoveDistance = MAX_SPEED * tickDuration * 1.1; // 10% tolerance

  // Calculate intended position
  const newPos = applyInput(lastValidState.position, input, tickDuration);

  // Check movement speed
  const distance = distanceBetween(lastValidState.position, newPos);
  if (distance > maxMoveDistance) {
    return { valid: false, reason: 'speed_hack', correctedPosition: lastValidState.position };
  }

  // Check fire rate
  const timeSinceLastShot = input.tick - lastValidState.lastShotTick;
  if (input.shoot && timeSinceLastShot < WEAPON_COOLDOWN_TICKS) {
    return { valid: false, reason: 'rapid_fire' };
  }

  // Check collision (can't walk through walls)
  if (collidesWithWorld(newPos)) {
    return { valid: false, reason: 'noclip', correctedPosition: lastValidState.position };
  }

  return { valid: true };
}
```

> [!WARNING]
> Client-side anti-cheat is a deterrent, not a solution. Any sufficiently motivated cheater can bypass client-side checks. Always implement server-side validation as the primary defense. Client-side anti-cheat (kernel-level like EasyAntiCheat) raises the barrier but is never foolproof.

## :cloud: BACKEND INFRASTRUCTURE

### Dedicated Game Server Options

| Platform | Scaling | Regions | Cost Model | Best For |
|----------|---------|---------|------------|----------|
| **Agones** (K8s) | Auto | Any (your clusters) | Infrastructure cost | Full control, K8s expertise |
| **AWS GameLift** | Auto | 15+ AWS regions | Per instance + bandwidth | AWS ecosystem |
| **Hathora** | Auto | 10+ regions | Per active server-hour | Fastest setup, serverless-like |
| **Edgegap** | Auto | 500+ locations | Per deployment | Edge computing, lowest latency |
| **Photon Server** | Managed | Global | Per CCU | Unity integration |
| **PlayFab** (Microsoft) | Managed | Azure regions | Per MAU + compute | Xbox/PC, Azure ecosystem |

### WebSocket-Based Multiplayer (Web Games)

| Framework | Language | Rooms | State Sync | Scalability |
|-----------|----------|-------|------------|-------------|
| **Colyseus** | Node.js/TS | Built-in | Schema-based delta | Horizontal (multi-process) |
| **Socket.IO** | Node.js | Rooms built-in | Manual | Redis adapter for multi-node |
| **Nakama** | Go | Match handler | Manual | Horizontal, battle-tested |
| **PartyKit** | JS/TS (Cloudflare) | Per-party | Manual | Edge, serverless |

```typescript
// Colyseus room example (Node.js game server)
import { Room, Client } from 'colyseus';
import { Schema, type, MapSchema } from '@colyseus/schema';

class Player extends Schema {
  @type('number') x: number = 0;
  @type('number') y: number = 0;
  @type('number') score: number = 0;
}

class GameState extends Schema {
  @type({ map: Player }) players = new MapSchema<Player>();
}

class GameRoom extends Room<GameState> {
  maxClients = 8;
  fixedTimeStep = 1000 / 60; // 60 tick

  onCreate(options: any): void {
    this.setState(new GameState());

    // Fixed tick update loop
    let elapsedTime = 0;
    this.setSimulationInterval((deltaTime) => {
      elapsedTime += deltaTime;
      while (elapsedTime >= this.fixedTimeStep) {
        this.fixedUpdate(this.fixedTimeStep);
        elapsedTime -= this.fixedTimeStep;
      }
    });

    // Handle player input
    this.onMessage('input', (client, input) => {
      const player = this.state.players.get(client.sessionId);
      if (!player) return;

      // Validate and apply input (server authoritative)
      if (input.left) player.x -= 5;
      if (input.right) player.x += 5;
      if (input.up) player.y -= 5;
      if (input.down) player.y += 5;

      // Clamp to world bounds
      player.x = Math.max(0, Math.min(800, player.x));
      player.y = Math.max(0, Math.min(600, player.y));
    });
  }

  onJoin(client: Client): void {
    const player = new Player();
    player.x = Math.random() * 800;
    player.y = Math.random() * 600;
    this.state.players.set(client.sessionId, player);
  }

  onLeave(client: Client): void {
    this.state.players.delete(client.sessionId);
  }

  fixedUpdate(dt: number): void {
    // Game logic: collision detection, scoring, etc.
  }
}
```

### Binary Message Protocol

```typescript
// Efficient binary protocol for game messages
enum MessageType {
  PLAYER_INPUT = 1,
  STATE_UPDATE = 2,
  PLAYER_JOIN = 3,
  PLAYER_LEAVE = 4,
  CHAT = 5,
}

class BinaryProtocol {
  // Encode player input (minimal bytes)
  static encodeInput(input: PlayerInput): ArrayBuffer {
    const buffer = new ArrayBuffer(10);
    const view = new DataView(buffer);
    view.setUint8(0, MessageType.PLAYER_INPUT);
    view.setUint32(1, input.sequence);
    // Pack input flags into a single byte
    let flags = 0;
    if (input.left) flags |= 1;
    if (input.right) flags |= 2;
    if (input.up) flags |= 4;
    if (input.down) flags |= 8;
    if (input.shoot) flags |= 16;
    if (input.jump) flags |= 32;
    view.setUint8(5, flags);
    view.setFloat32(6, input.aimAngle); // 4 bytes
    return buffer;
  }

  // Decode player input
  static decodeInput(buffer: ArrayBuffer): PlayerInput {
    const view = new DataView(buffer);
    const flags = view.getUint8(5);
    return {
      sequence: view.getUint32(1),
      left: !!(flags & 1),
      right: !!(flags & 2),
      up: !!(flags & 4),
      down: !!(flags & 8),
      shoot: !!(flags & 16),
      jump: !!(flags & 32),
      aimAngle: view.getFloat32(6),
    };
  }
}
```

> [!TIP]
> JSON wastes 3-10x bandwidth compared to binary protocols. For fast-paced games sending 30-60 updates per second per player, binary encoding is essential. Use DataView for manual packing, or libraries like FlatBuffers, MessagePack, or Protocol Buffers for structured serialization.

## :jigsaw: GENRE-SPECIFIC ARCHITECTURES

### FPS

| Component | Tick Rate | Protocol | Key Challenge |
|-----------|-----------|----------|---------------|
| Server simulation | 64-128 Hz | UDP | Hit registration at high speed |
| Client prediction | 64-128 Hz | UDP | Smooth movement feel |
| Lag compensation | Per-shot | Server-side | Rewinding world state accurately |
| Anti-cheat | Continuous | Server-side | Aimbot/wallhack detection |

### RTS (Lockstep)

| Component | Tick Rate | Protocol | Key Challenge |
|-----------|-----------|----------|---------------|
| Simulation | 10-20 Hz | Reliable UDP | Deterministic across all clients |
| Input sharing | Per-turn | Reliable | Wait for all inputs before advancing |
| Checksum | Every N ticks | Reliable | Detect desync (hash game state) |
| Replay | Record inputs | N/A | Entire game replayable from inputs |

### MMO

| Component | Architecture | Key Challenge |
|-----------|-------------|---------------|
| Zone servers | Sharded by area | Seamless zone transitions |
| Interest management | AOI (area of interest) | Only sync nearby entities |
| Persistence | Database per shard | Consistent saves under load |
| Chat/social | Separate service | Cross-zone communication |

## :chart_with_upwards_trend: SCALING

| Strategy | How | When |
|----------|-----|------|
| **Vertical scaling** | Bigger server instances | Quick fix, limited ceiling |
| **Horizontal scaling** | More server instances | >500 concurrent players per region |
| **Sticky sessions** | Route player to same server | Stateful game servers |
| **Global regions** | US-East, EU-West, Asia, etc. | Latency >100ms for distant players |
| **CDN for assets** | CloudFront, Fastly | Large asset downloads (maps, textures) |
| **Microservices** | Separate matchmaking, chat, auth | Independent scaling per concern |
| **Sharding** | Split world into zones | MMOs, large persistent worlds |

## :white_check_mark: EXIT CHECKLIST

- [ ] Authoritative server validates all player actions (no trusting the client)
- [ ] Client-side prediction provides responsive local movement
- [ ] Entity interpolation smooths remote player movement
- [ ] Lag compensation handles hit detection fairly across latencies
- [ ] Matchmaking pairs players of similar skill and region
- [ ] Lobby system handles room creation, joining, ready checks
- [ ] Anti-cheat: server rejects impossible inputs (speed, rate, collision)
- [ ] Binary protocol minimizes bandwidth usage
- [ ] Game is playable at <100ms RTT, degraded-but-functional at <200ms
- [ ] Disconnection handling: graceful reconnect, timeout, host migration
- [ ] Load tested with expected concurrent player count
- [ ] Deployed to multiple regions for global coverage

*Skill Version: 1.0 | Created: February 2026*
