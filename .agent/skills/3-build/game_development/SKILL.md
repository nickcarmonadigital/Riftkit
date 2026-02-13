---
name: game_development
description: Game architecture patterns, engine selection, and core system implementation for 2D and 3D games
---

# Game Development Skill

**Purpose**: Provides architecture guidance, design patterns, and practical implementation strategies for building games across engines and platforms, from web-based 2D to native 3D.

## :dart: TRIGGER COMMANDS

```text
"build a game"
"game architecture"
"set up game project"
"implement game loop"
"add physics to game"
"Using game_development skill: design game systems"
```

## :joystick: ENGINE SELECTION

| Engine | Language | 2D | 3D | License | Bundle Size | Best For |
|--------|----------|----|----|---------|-------------|----------|
| **Unity** | C# | Great | Great | Proprietary (free tier) | 50MB+ | Mobile, indie, VR/AR, largest asset store |
| **Unreal Engine** | C++ / Blueprints | OK | Excellent | Free (5% royalty >$1M) | 100MB+ | AAA quality, cinematic, FPS |
| **Godot** | GDScript / C# | Excellent | Good | MIT (free) | 30MB+ | Indie, open source, lightweight |
| **Phaser** | JavaScript/TS | Excellent | No | MIT | 1MB | Web 2D games, game jams |
| **PixiJS** | JavaScript/TS | Excellent | No | MIT | 500KB | 2D rendering, interactive apps |
| **Three.js** | JavaScript/TS | Limited | Great | MIT | 600KB | Web 3D, visualizations |
| **Babylon.js** | JavaScript/TS | Limited | Excellent | Apache-2.0 | 1MB | Web 3D, PBR, physics built-in |
| **Bevy** | Rust | Good | Good | MIT/Apache-2.0 | 10MB+ | Rust ECS, performance-critical |
| **pygame** | Python | Good | No | LGPL | 10MB | Prototyping, education |

> [!TIP]
> For web games, Phaser (2D) or Three.js/Babylon.js (3D) deploy instantly to any browser with zero install. For native desktop/mobile, Godot offers the best open-source experience. Unity has the largest ecosystem but its pricing model has caused controversy.

## :arrows_counterclockwise: GAME LOOP FUNDAMENTALS

The game loop is the heartbeat of every game. It runs continuously, processing input, updating game state, and rendering frames.

### Fixed vs Variable Timestep

| Approach | Pros | Cons | Use When |
|----------|------|------|----------|
| **Variable timestep** | Simple, smooth visuals | Physics instability, non-deterministic | Casual games, UI-heavy |
| **Fixed timestep** | Deterministic physics, reproducible | Potential spiral of death | Physics-heavy, multiplayer |
| **Semi-fixed** (fixed update + variable render) | Best of both worlds | More complex | Most games (recommended) |

```typescript
// Semi-fixed timestep game loop (recommended)
class GameLoop {
  private readonly TICK_RATE = 60;
  private readonly TICK_DURATION = 1000 / this.TICK_RATE;
  private previousTime = 0;
  private accumulator = 0;
  private running = false;

  start(): void {
    this.running = true;
    this.previousTime = performance.now();
    requestAnimationFrame((t) => this.loop(t));
  }

  private loop(currentTime: number): void {
    if (!this.running) return;

    const elapsed = currentTime - this.previousTime;
    this.previousTime = currentTime;
    this.accumulator += elapsed;

    // Process input once per frame
    this.processInput();

    // Fixed-rate updates for deterministic physics
    while (this.accumulator >= this.TICK_DURATION) {
      this.fixedUpdate(this.TICK_DURATION / 1000); // delta in seconds
      this.accumulator -= this.TICK_DURATION;
    }

    // Interpolation factor for smooth rendering between ticks
    const alpha = this.accumulator / this.TICK_DURATION;
    this.render(alpha);

    requestAnimationFrame((t) => this.loop(t));
  }

  private processInput(): void { /* poll keyboard, mouse, gamepad */ }
  private fixedUpdate(dt: number): void { /* physics, collision, game logic */ }
  private render(alpha: number): void { /* draw interpolated state */ }
}
```

> [!WARNING]
> Never tie game logic to frame rate. A game running at 144fps should behave identically to one at 30fps. Always multiply movement by delta time (`velocity * dt`), and use fixed timestep for physics.

## :bricks: ENTITY COMPONENT SYSTEM (ECS)

ECS separates data (Components) from behavior (Systems) and identity (Entities), providing better performance and flexibility than deep inheritance hierarchies.

| Concept | Description | Example |
|---------|-------------|---------|
| **Entity** | Just an ID (number/UUID) | Player entity = ID `42` |
| **Component** | Pure data, no behavior | `Position { x, y }`, `Velocity { dx, dy }`, `Sprite { texture }` |
| **System** | Logic that operates on entities with specific components | `MovementSystem` processes all entities with `Position` + `Velocity` |

```typescript
// Conceptual ECS implementation
interface Component {}

class Position implements Component {
  constructor(public x: number, public y: number) {}
}

class Velocity implements Component {
  constructor(public dx: number, public dy: number) {}
}

class Health implements Component {
  constructor(public current: number, public max: number) {}
}

class World {
  private nextId = 0;
  private entities: Map<number, Map<string, Component>> = new Map();

  createEntity(): number {
    const id = this.nextId++;
    this.entities.set(id, new Map());
    return id;
  }

  addComponent(entityId: number, name: string, component: Component): void {
    this.entities.get(entityId)?.set(name, component);
  }

  query(...componentNames: string[]): [number, Map<string, Component>][] {
    return [...this.entities.entries()].filter(([_, components]) =>
      componentNames.every((name) => components.has(name))
    );
  }
}

// Systems operate on queried entities
function movementSystem(world: World, dt: number): void {
  for (const [id, components] of world.query('position', 'velocity')) {
    const pos = components.get('position') as Position;
    const vel = components.get('velocity') as Velocity;
    pos.x += vel.dx * dt;
    pos.y += vel.dy * dt;
  }
}

// Usage
const world = new World();
const player = world.createEntity();
world.addComponent(player, 'position', new Position(100, 200));
world.addComponent(player, 'velocity', new Velocity(50, 0));
world.addComponent(player, 'health', new Health(100, 100));
```

> [!TIP]
> For production ECS in TypeScript, consider libraries like **bitECS** (high-performance, ArrayBuffer-backed), **ECSY** (Mozilla), or **miniplex** (React-friendly). In Rust, Bevy's ECS is best-in-class.

## :world_map: SCENE MANAGEMENT

```typescript
// Scene manager with transitions
interface Scene {
  name: string;
  onEnter(data?: unknown): void;
  onExit(): void;
  update(dt: number): void;
  render(): void;
}

class SceneManager {
  private scenes: Map<string, Scene> = new Map();
  private currentScene: Scene | null = null;
  private transitioning = false;

  register(scene: Scene): void {
    this.scenes.set(scene.name, scene);
  }

  async switchTo(sceneName: string, data?: unknown): Promise<void> {
    if (this.transitioning) return;
    this.transitioning = true;

    const next = this.scenes.get(sceneName);
    if (!next) throw new Error(`Scene "${sceneName}" not found`);

    // Fade out current scene
    if (this.currentScene) {
      await this.fadeOut();
      this.currentScene.onExit();
    }

    // Transition to new scene
    this.currentScene = next;
    this.currentScene.onEnter(data);
    await this.fadeIn();
    this.transitioning = false;
  }

  update(dt: number): void {
    this.currentScene?.update(dt);
  }

  render(): void {
    this.currentScene?.render();
  }

  private fadeOut(): Promise<void> { /* animation */ return Promise.resolve(); }
  private fadeIn(): Promise<void> { /* animation */ return Promise.resolve(); }
}
```

## :file_folder: ASSET PIPELINE

| Asset Type | Formats | Loading Strategy | Optimization |
|-----------|---------|------------------|--------------|
| Sprites/Textures | PNG, WebP, KTX2 | Preload or sprite atlas | Texture packing, power-of-2 sizes |
| Audio (SFX) | WAV, OGG, MP3 | Preload | Compress, short clips |
| Audio (Music) | OGG, MP3 | Stream | Don't load fully into memory |
| 3D Models | GLTF/GLB, FBX | Lazy load per scene | LOD variants, Draco compression |
| Level Data | JSON, Tiled (.tmx) | Load on scene enter | Chunk large levels |
| Fonts | WOFF2, MSDF | Preload | Signed distance field for crisp text |
| Shaders | GLSL, WGSL | Compile at startup | Shader variants, warm-up |

```typescript
// Asset loader with progress tracking
class AssetLoader {
  private cache: Map<string, unknown> = new Map();
  private queue: { key: string; url: string; type: string }[] = [];

  enqueue(key: string, url: string, type: 'image' | 'audio' | 'json'): void {
    this.queue.push({ key, url, type });
  }

  async loadAll(onProgress: (pct: number) => void): Promise<void> {
    let loaded = 0;
    const total = this.queue.length;

    const promises = this.queue.map(async ({ key, url, type }) => {
      const asset = await this.loadOne(url, type);
      this.cache.set(key, asset);
      loaded++;
      onProgress(loaded / total);
    });

    await Promise.all(promises);
    this.queue = [];
  }

  get<T>(key: string): T {
    return this.cache.get(key) as T;
  }

  private async loadOne(url: string, type: string): Promise<unknown> {
    switch (type) {
      case 'image': {
        const img = new Image();
        img.src = url;
        await img.decode();
        return img;
      }
      case 'audio': {
        const res = await fetch(url);
        return await res.arrayBuffer();
      }
      case 'json': {
        const res = await fetch(url);
        return await res.json();
      }
      default:
        throw new Error(`Unknown asset type: ${type}`);
    }
  }
}
```

## :video_game: STATE MACHINE

```typescript
// Game state machine
enum GameState {
  MainMenu = 'main_menu',
  Playing = 'playing',
  Paused = 'paused',
  GameOver = 'game_over',
  Victory = 'victory',
  Loading = 'loading',
}

type StateTransition = {
  from: GameState;
  to: GameState;
  condition?: () => boolean;
};

class GameStateMachine {
  private state: GameState = GameState.MainMenu;
  private transitions: StateTransition[] = [];
  private enterCallbacks: Map<GameState, () => void> = new Map();
  private exitCallbacks: Map<GameState, () => void> = new Map();

  get current(): GameState {
    return this.state;
  }

  addTransition(from: GameState, to: GameState, condition?: () => boolean): void {
    this.transitions.push({ from, to, condition });
  }

  onEnter(state: GameState, callback: () => void): void {
    this.enterCallbacks.set(state, callback);
  }

  onExit(state: GameState, callback: () => void): void {
    this.exitCallbacks.set(state, callback);
  }

  transitionTo(target: GameState): boolean {
    const valid = this.transitions.find(
      (t) => t.from === this.state && t.to === target
    );
    if (!valid) return false;
    if (valid.condition && !valid.condition()) return false;

    this.exitCallbacks.get(this.state)?.();
    this.state = target;
    this.enterCallbacks.get(this.state)?.();
    return true;
  }
}

// Usage
const fsm = new GameStateMachine();
fsm.addTransition(GameState.MainMenu, GameState.Loading);
fsm.addTransition(GameState.Loading, GameState.Playing);
fsm.addTransition(GameState.Playing, GameState.Paused);
fsm.addTransition(GameState.Paused, GameState.Playing);
fsm.addTransition(GameState.Playing, GameState.GameOver);
fsm.addTransition(GameState.Playing, GameState.Victory);
fsm.addTransition(GameState.GameOver, GameState.MainMenu);
fsm.addTransition(GameState.Victory, GameState.MainMenu);
```

## :collision: PHYSICS AND COLLISION

### Collision Detection Methods

| Method | Shape | Performance | Accuracy | Use Case |
|--------|-------|-------------|----------|----------|
| **AABB** | Rectangle | O(1) | Low (no rotation) | Fast broad-phase, UI elements |
| **Circle** | Circle | O(1) | Medium | Particles, projectiles |
| **SAT** | Convex polygon | O(n) | High | Complex shapes, rotating objects |
| **GJK** | Any convex | O(n) | Highest | 3D physics engines |
| **Quadtree** | Spatial index | O(n log n) | N/A (broad phase) | Reducing pair checks in large worlds |

```typescript
// AABB collision detection
interface AABB {
  x: number; y: number;
  width: number; height: number;
}

function aabbOverlap(a: AABB, b: AABB): boolean {
  return (
    a.x < b.x + b.width &&
    a.x + a.width > b.x &&
    a.y < b.y + b.height &&
    a.y + a.height > b.y
  );
}

// Circle collision detection
interface Circle {
  x: number; y: number;
  radius: number;
}

function circleOverlap(a: Circle, b: Circle): boolean {
  const dx = a.x - b.x;
  const dy = a.y - b.y;
  const distSq = dx * dx + dy * dy;
  const radiusSum = a.radius + b.radius;
  return distSq <= radiusSum * radiusSum; // avoid sqrt
}
```

### Physics Engines

| Engine | Platform | 2D/3D | Language | Notes |
|--------|----------|-------|----------|-------|
| **Box2D** | Cross-platform | 2D | C (bindings everywhere) | Industry standard for 2D |
| **Rapier** | Cross-platform | 2D + 3D | Rust (WASM for web) | Modern, fast, deterministic |
| **Cannon.js** | Web | 3D | JavaScript | Works with Three.js |
| **Ammo.js** | Web | 3D | JS (Bullet port) | Bullet physics for web |
| **Matter.js** | Web | 2D | JavaScript | Simple API, great for prototyping |

## :musical_keyboard: INPUT HANDLING

```typescript
// Input manager with action mapping (supports rebinding)
class InputManager {
  private keyState: Map<string, boolean> = new Map();
  private keyJustPressed: Set<string> = new Set();
  private actionMap: Map<string, string[]> = new Map();

  constructor() {
    window.addEventListener('keydown', (e) => {
      if (!this.keyState.get(e.code)) {
        this.keyJustPressed.add(e.code);
      }
      this.keyState.set(e.code, true);
    });
    window.addEventListener('keyup', (e) => {
      this.keyState.set(e.code, false);
    });
  }

  bindAction(action: string, keys: string[]): void {
    this.actionMap.set(action, keys);
  }

  isActionHeld(action: string): boolean {
    const keys = this.actionMap.get(action) || [];
    return keys.some((key) => this.keyState.get(key));
  }

  isActionJustPressed(action: string): boolean {
    const keys = this.actionMap.get(action) || [];
    return keys.some((key) => this.keyJustPressed.has(key));
  }

  endFrame(): void {
    this.keyJustPressed.clear();
  }
}

// Usage
const input = new InputManager();
input.bindAction('jump', ['Space', 'ArrowUp', 'KeyW']);
input.bindAction('left', ['ArrowLeft', 'KeyA']);
input.bindAction('right', ['ArrowRight', 'KeyD']);
input.bindAction('shoot', ['KeyZ', 'Enter']);
```

## :loud_sound: AUDIO MANAGEMENT

```typescript
// Audio pool for sound effects (prevents overlapping/cutting)
class AudioPool {
  private context: AudioContext;
  private buffers: Map<string, AudioBuffer> = new Map();
  private musicGain: GainNode;
  private sfxGain: GainNode;

  constructor() {
    this.context = new AudioContext();
    this.musicGain = this.context.createGain();
    this.sfxGain = this.context.createGain();
    this.musicGain.connect(this.context.destination);
    this.sfxGain.connect(this.context.destination);
  }

  async load(key: string, url: string): Promise<void> {
    const response = await fetch(url);
    const arrayBuffer = await response.arrayBuffer();
    const audioBuffer = await this.context.decodeAudioData(arrayBuffer);
    this.buffers.set(key, audioBuffer);
  }

  playSFX(key: string, volume = 1.0): void {
    const buffer = this.buffers.get(key);
    if (!buffer) return;
    const source = this.context.createBufferSource();
    const gain = this.context.createGain();
    gain.gain.value = volume;
    source.buffer = buffer;
    source.connect(gain).connect(this.sfxGain);
    source.start();
  }

  setMusicVolume(volume: number): void {
    this.musicGain.gain.value = Math.max(0, Math.min(1, volume));
  }

  setSFXVolume(volume: number): void {
    this.sfxGain.gain.value = Math.max(0, Math.min(1, volume));
  }
}
```

## :zap: PERFORMANCE PATTERNS

### Object Pooling

```typescript
// Object pool to avoid garbage collection spikes
class ObjectPool<T> {
  private pool: T[] = [];
  private active: Set<T> = new Set();

  constructor(
    private factory: () => T,
    private reset: (obj: T) => void,
    initialSize: number = 50
  ) {
    for (let i = 0; i < initialSize; i++) {
      this.pool.push(factory());
    }
  }

  acquire(): T {
    const obj = this.pool.pop() || this.factory();
    this.active.add(obj);
    return obj;
  }

  release(obj: T): void {
    if (!this.active.has(obj)) return;
    this.active.delete(obj);
    this.reset(obj);
    this.pool.push(obj);
  }

  get activeCount(): number {
    return this.active.size;
  }
}

// Usage: bullet pool
const bulletPool = new ObjectPool(
  () => ({ x: 0, y: 0, dx: 0, dy: 0, active: false }),
  (b) => { b.x = 0; b.y = 0; b.dx = 0; b.dy = 0; b.active = false; },
  200
);
```

### Spatial Partitioning (Quadtree)

| Technique | Dimensions | Best For | Complexity |
|-----------|-----------|----------|------------|
| **Quadtree** | 2D | Variable-density worlds | O(n log n) |
| **Octree** | 3D | 3D worlds, large scenes | O(n log n) |
| **Grid** | 2D/3D | Uniform-density worlds | O(1) lookup |
| **BSP Tree** | 2D/3D | Static geometry, raycasting | O(n log n) build, O(log n) query |
| **R-Tree** | 2D/3D | Database spatial queries | O(n log n) |

## :trophy: GENRE-SPECIFIC SYSTEMS

### Platformer Core Systems

- [ ] Character controller: ground check, jump buffer, coyote time
- [ ] Gravity and variable jump height (hold to jump higher)
- [ ] Tile-based collision with tilemap
- [ ] Moving platforms and one-way platforms
- [ ] Camera follow with lookahead and deadzone

### RPG Core Systems

- [ ] Stats system: HP, MP, STR, DEX, INT with level scaling
- [ ] Inventory: grid or list, weight/slot limits, item stacking
- [ ] Dialogue system: branching trees, NPC portraits, choices
- [ ] Quest tracker: objectives, completion conditions, rewards
- [ ] Save/load: serialize full game state to JSON or binary

### RTS Core Systems

- [ ] Unit selection: click, drag box, control groups
- [ ] Pathfinding: A* on nav mesh or grid, flow fields for groups
- [ ] Fog of war: visibility grid, explored vs visible vs hidden
- [ ] Resource gathering: workers, resource nodes, stockpiles
- [ ] Build system: placement preview, construction time, tech tree

### Puzzle Core Systems

- [ ] Grid system: 2D array, cell states, neighbor queries
- [ ] Rule engine: validate moves, check win condition
- [ ] Undo/redo stack for move history
- [ ] Hint system and optional solver
- [ ] Level progression and difficulty curve

## :white_check_mark: EXIT CHECKLIST

- [ ] Core gameplay loop runs at stable frame rate (60fps target)
- [ ] Game loop uses fixed timestep for physics, variable for rendering
- [ ] Assets load with progress indication, no blocking main thread
- [ ] Physics and collision detection working for all game objects
- [ ] State machine handles all game states (menu, play, pause, game over)
- [ ] Input system responsive with configurable bindings
- [ ] Audio plays correctly (SFX and music with separate volume controls)
- [ ] Performance profiled: no GC spikes, draw calls reasonable
- [ ] Object pools used for frequently created/destroyed objects (bullets, particles)
- [ ] Save/load system preserves game progress
- [ ] Game feels good: responsive controls, screen shake, juice effects

*Skill Version: 1.0 | Created: February 2026*
