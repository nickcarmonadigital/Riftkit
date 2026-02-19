# TypeScript Patterns for Full-Stack Development

> **TypeScript catches bugs before your users do.** These patterns apply to both your NestJS backend and React frontend.

---

## Strict Mode Configuration

```json
// tsconfig.json — every flag explained
{
  "compilerOptions": {
    // STRICT MODE (enable all of these)
    "strict": true,                    // Master switch for all strict checks
    "strictNullChecks": true,          // null and undefined are separate types
    "strictFunctionTypes": true,       // Stricter function parameter checking
    "strictBindCallApply": true,       // Check bind/call/apply arguments
    "strictPropertyInitialization": true, // Class properties must be initialized
    "noImplicitAny": true,             // Error on inferred 'any'
    "noImplicitThis": true,            // Error on 'this' with implied 'any' type

    // ADDITIONAL CHECKS (enable these too)
    "noUncheckedIndexedAccess": true,  // array[0] is T | undefined
    "noImplicitReturns": true,         // Every code path must return a value
    "noFallthroughCasesInSwitch": true, // Prevent switch case fallthrough
    "noUnusedLocals": true,            // Error on unused variables
    "noUnusedParameters": true,        // Error on unused parameters
    "exactOptionalPropertyTypes": true  // undefined must be explicit
  }
}
```

---

## Utility Types with DTO Examples

### Partial — Make All Properties Optional

```typescript
// Full DTO for creating a user
class CreateUserDto {
  name: string;
  email: string;
  role: Role;
}

// Update DTO — all fields optional
class UpdateUserDto extends PartialType(CreateUserDto) {}
// Equivalent to: { name?: string; email?: string; role?: Role }
```

### Pick — Select Specific Properties

```typescript
// From a full User, pick only what the login endpoint needs
type LoginDto = Pick<User, 'email' | 'password'>;
// { email: string; password: string }
```

### Omit — Remove Specific Properties

```typescript
// User response without sensitive fields
type UserResponse = Omit<User, 'password' | 'refreshToken'>;
// { id: string; name: string; email: string; role: Role; ... }
```

### Record — Typed Object Maps

```typescript
// Map of HTTP status code to error message
const errorMessages: Record<number, string> = {
  400: 'Bad Request',
  401: 'Unauthorized',
  403: 'Forbidden',
  404: 'Not Found',
};

// Map of role to permissions
type Permissions = Record<Role, string[]>;
const rolePermissions: Permissions = {
  ADMIN: ['read', 'write', 'delete'],
  USER: ['read'],
  VIEWER: ['read'],
};
```

### ReturnType — Extract Function Return Type

```typescript
// Get the return type of a service method
type FindOneResult = Awaited<ReturnType<UserService['findOne']>>;
// Resolves to whatever findOne returns (unwraps the Promise)
```

### Readonly — Prevent Mutation

```typescript
interface AppConfig {
  readonly port: number;
  readonly databaseUrl: string;
  readonly jwtSecret: string;
}

const config: AppConfig = { port: 3000, databaseUrl: '...', jwtSecret: '...' };
config.port = 4000; // TS Error: Cannot assign to 'port' because it is a read-only property
```

---

## Generics

### Generic CRUD Service (NestJS)

```typescript
// One base service that works for ANY Prisma model
@Injectable()
export abstract class BaseCrudService<
  T,                          // The model type (User, Project, etc.)
  CreateDto,                  // DTO for creating
  UpdateDto,                  // DTO for updating
> {
  constructor(
    protected readonly prisma: PrismaService,
    private readonly modelName: string,
  ) {}

  async findAll(where?: Partial<T>): Promise<T[]> {
    return (this.prisma[this.modelName] as any).findMany({ where });
  }

  async findOne(id: string): Promise<T> {
    const result = await (this.prisma[this.modelName] as any).findUnique({
      where: { id },
    });
    if (!result) throw new NotFoundException(`${this.modelName} not found`);
    return result;
  }

  async create(dto: CreateDto): Promise<T> {
    return (this.prisma[this.modelName] as any).create({ data: dto });
  }

  async update(id: string, dto: UpdateDto): Promise<T> {
    await this.findOne(id); // Verify exists
    return (this.prisma[this.modelName] as any).update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string): Promise<void> {
    await this.findOne(id); // Verify exists
    await (this.prisma[this.modelName] as any).delete({ where: { id } });
  }
}

// Usage — extends the base
@Injectable()
export class ProjectsService extends BaseCrudService<
  Project,
  CreateProjectDto,
  UpdateProjectDto
> {
  constructor(prisma: PrismaService) {
    super(prisma, 'project');
  }

  // Add project-specific methods here
}
```

### Generic React Hook

```typescript
// Generic API hook that works with any endpoint
function useApi<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(json => setData(json.data as T))
      .catch(err => setError(err))
      .finally(() => setLoading(false));
  }, [url]);

  return { data, loading, error };
}

// Usage — TypeScript infers the right type
const { data: users } = useApi<User[]>('/api/users');
const { data: project } = useApi<Project>('/api/projects/123');
```

---

## Type Guards & Discriminated Unions

### Type Guards (Narrow Unknown Types)

```typescript
// Type guard function
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'email' in value
  );
}

// Usage
function processResponse(data: unknown) {
  if (isUser(data)) {
    console.log(data.email); // TypeScript knows it's a User here
  }
}
```

### Discriminated Unions (State Machines)

```typescript
// API response state — exactly one of three states
type ApiState<T> =
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };

// TypeScript narrows the type based on `status`
function renderState<T>(state: ApiState<T>) {
  switch (state.status) {
    case 'loading':
      return <Spinner />;
    case 'success':
      return <DataView data={state.data} />; // TS knows data exists
    case 'error':
      return <ErrorMessage message={state.error} />; // TS knows error exists
  }
}
```

### Action Discriminated Union (Redux/useReducer)

```typescript
type Action =
  | { type: 'SET_USER'; payload: User }
  | { type: 'SET_LOADING'; payload: boolean }
  | { type: 'SET_ERROR'; payload: string }
  | { type: 'CLEAR_ERROR' };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'SET_USER':
      return { ...state, user: action.payload }; // payload is User
    case 'SET_LOADING':
      return { ...state, loading: action.payload }; // payload is boolean
    case 'SET_ERROR':
      return { ...state, error: action.payload }; // payload is string
    case 'CLEAR_ERROR':
      return { ...state, error: null }; // no payload
  }
}
```

---

## Avoiding `any`

### Use `unknown` Instead of `any`

```typescript
// BAD — any disables all type checking
function processData(data: any) {
  return data.name.toUpperCase(); // No error — could crash at runtime
}

// GOOD — unknown forces you to check the type first
function processData(data: unknown) {
  if (typeof data === 'object' && data !== null && 'name' in data) {
    return (data as { name: string }).name.toUpperCase(); // Safe
  }
  throw new Error('Invalid data');
}
```

### Use Generics Instead of `any`

```typescript
// BAD
function firstElement(arr: any[]): any {
  return arr[0];
}

// GOOD
function firstElement<T>(arr: T[]): T | undefined {
  return arr[0];
}
```

### Common `any` Escape Hatches

| Scenario | Instead of `any` | Use |
|----------|-----------------|-----|
| Unknown API response | `any` | `unknown` + type guard |
| Generic container | `any[]` | `T[]` with generic |
| Third-party lib with no types | `any` | Create a `.d.ts` declaration file |
| Complex object you'll type later | `any` | `Record<string, unknown>` |
| Event handlers | `any` | `React.MouseEvent<HTMLButtonElement>` |

---

## NestJS-Specific Patterns

### Typed Configuration

```typescript
// config/configuration.ts
export interface AppConfig {
  port: number;
  database: {
    url: string;
    poolSize: number;
  };
  jwt: {
    secret: string;
    expiresIn: string;
  };
}

export default (): AppConfig => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    url: process.env.DATABASE_URL,
    poolSize: parseInt(process.env.DB_POOL_SIZE, 10) || 10,
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN || '15m',
  },
});

// Usage in services — fully typed
@Injectable()
export class AuthService {
  constructor(private config: ConfigService<AppConfig, true>) {}

  getJwtSecret(): string {
    return this.config.get('jwt.secret', { infer: true });
    // TypeScript knows this returns string
  }
}
```

### Typed Decorators

```typescript
// Custom decorator with typed return
export const CurrentUser = createParamDecorator(
  (data: keyof JwtPayload | undefined, ctx: ExecutionContext): JwtPayload | string => {
    const request = ctx.switchToHttp().getRequest();
    const user: JwtPayload = request.user;
    return data ? user[data] : user;
  },
);

// Usage
@Get('profile')
async getProfile(@CurrentUser() user: JwtPayload) { ... }

@Get('email')
async getEmail(@CurrentUser('email') email: string) { ... }
```

---

## React-Specific Patterns

### Typed Props

```typescript
// Component with required and optional props
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  icon?: React.ReactNode;
}

const Button: React.FC<ButtonProps> = ({
  label,
  onClick,
  variant = 'primary',
  disabled = false,
  icon,
}) => (
  <button
    onClick={onClick}
    disabled={disabled}
    className={`btn btn-${variant}`}
  >
    {icon && <span className="mr-2">{icon}</span>}
    {label}
  </button>
);
```

### Typed Events

```typescript
// Form events
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setEmail(e.target.value);
};

const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
  e.preventDefault();
  // ...
};

// Click events
const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  e.stopPropagation();
};

// Keyboard events
const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
  if (e.key === 'Enter') submit();
};
```

### Typed Refs

```typescript
const inputRef = useRef<HTMLInputElement>(null);
const divRef = useRef<HTMLDivElement>(null);
const canvasRef = useRef<HTMLCanvasElement>(null);

// For mutable values (not DOM elements)
const timerRef = useRef<NodeJS.Timeout | null>(null);
const prevValueRef = useRef<string>('');
```

### Generic Components

```typescript
// A generic Select component that works with any option type
interface SelectProps<T> {
  options: T[];
  value: T | null;
  onChange: (value: T) => void;
  getLabel: (option: T) => string;
  getValue: (option: T) => string;
}

function Select<T>({ options, value, onChange, getLabel, getValue }: SelectProps<T>) {
  return (
    <select
      value={value ? getValue(value) : ''}
      onChange={(e) => {
        const selected = options.find(o => getValue(o) === e.target.value);
        if (selected) onChange(selected);
      }}
    >
      <option value="">Select...</option>
      {options.map(option => (
        <option key={getValue(option)} value={getValue(option)}>
          {getLabel(option)}
        </option>
      ))}
    </select>
  );
}

// Usage — TypeScript infers T from the options array
<Select
  options={users}
  value={selectedUser}
  onChange={setSelectedUser}
  getLabel={(user) => user.name}
  getValue={(user) => user.id}
/>
```

---

*TypeScript Patterns v1.0 | Created: February 13, 2026*
