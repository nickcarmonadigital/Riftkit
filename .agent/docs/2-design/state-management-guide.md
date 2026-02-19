# State Management Guide

> **UI = f(state).** Your interface is a function of your data. Messy state = buggy UI. Clear state = predictable UI.

---

## 5 Types of State

| Type | What It Is | Example | Tool | Update Frequency |
|------|-----------|---------|------|-----------------|
| **Server State** | Data from your API | User list, projects | React Query / TanStack Query | On fetch, mutation |
| **URL State** | Current page, filters | `/users?page=2&role=admin` | useSearchParams | On navigation |
| **Local State** | Component-specific | Modal open, form input | useState | On user interaction |
| **Global Client State** | App-wide UI preferences | Theme, sidebar collapsed | Zustand / Context | Rarely |
| **Ephemeral State** | Temporary, not persisted | Hover, scroll position | CSS / useRef | Constantly |

**The key insight**: Different types of state need different tools. Using Redux for everything is like using a sledgehammer for every nail.

---

## React Query / TanStack Query

### Why React Query

React Query manages **server state** — data that lives on your API server. It handles:
- Caching (don't re-fetch data you already have)
- Background refetching (keep data fresh)
- Loading/error states (no more `isLoading` useState)
- Deduplication (10 components requesting the same data = 1 API call)
- Optimistic updates (update UI before API confirms)

### Queries (Reading Data)

```typescript
import { useQuery } from '@tanstack/react-query';

// Basic query
function UserList() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['users'],           // Cache key (must be unique)
    queryFn: () => api.getUsers(), // Function that fetches data
    staleTime: 5 * 60 * 1000,     // Consider fresh for 5 minutes
  });

  if (isLoading) return <Spinner />;
  if (error) return <ErrorMessage error={error} />;
  return <UserTable users={data} />;
}

// Query with parameters
function UserDetail({ userId }: { userId: string }) {
  const { data: user } = useQuery({
    queryKey: ['users', userId],    // Unique key per user
    queryFn: () => api.getUser(userId),
    enabled: !!userId,              // Don't fetch if no userId
  });
}

// Query with filters
function ProjectList() {
  const [filters, setFilters] = useState({ status: 'active', page: 1 });

  const { data } = useQuery({
    queryKey: ['projects', filters],  // Re-fetches when filters change
    queryFn: () => api.getProjects(filters),
    keepPreviousData: true,           // Show old data while loading new
  });
}
```

### Mutations (Writing Data)

```typescript
import { useMutation, useQueryClient } from '@tanstack/react-query';

function CreateUserForm() {
  const queryClient = useQueryClient();

  const createUser = useMutation({
    mutationFn: (dto: CreateUserDto) => api.createUser(dto),
    onSuccess: () => {
      // Invalidate the user list cache → triggers refetch
      queryClient.invalidateQueries({ queryKey: ['users'] });
      toast.success('User created!');
    },
    onError: (error) => {
      toast.error(error.message);
    },
  });

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      createUser.mutate({ name, email });
    }}>
      <button disabled={createUser.isPending}>
        {createUser.isPending ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}
```

### Optimistic Updates

```typescript
const updateUser = useMutation({
  mutationFn: (dto) => api.updateUser(userId, dto),
  onMutate: async (newData) => {
    // Cancel any outgoing refetches
    await queryClient.cancelQueries({ queryKey: ['users', userId] });

    // Snapshot previous value
    const previousUser = queryClient.getQueryData(['users', userId]);

    // Optimistically update the cache
    queryClient.setQueryData(['users', userId], (old) => ({
      ...old,
      ...newData,
    }));

    return { previousUser }; // Return context for rollback
  },
  onError: (err, newData, context) => {
    // Rollback on error
    queryClient.setQueryData(['users', userId], context.previousUser);
    toast.error('Update failed');
  },
  onSettled: () => {
    // Always refetch to ensure consistency
    queryClient.invalidateQueries({ queryKey: ['users', userId] });
  },
});
```

---

## Zustand (Global Client State)

### When to Use Zustand

Use Zustand for **client-side global state** that doesn't come from an API:
- UI preferences (theme, sidebar state, layout mode)
- Temporary app state (selected items, active tab across pages)
- Auth state (current user info cached client-side)

### Creating a Store

```typescript
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface UIStore {
  // State
  sidebarOpen: boolean;
  theme: 'light' | 'dark';

  // Actions
  toggleSidebar: () => void;
  setTheme: (theme: 'light' | 'dark') => void;
}

export const useUIStore = create<UIStore>()(
  devtools(
    persist(
      (set) => ({
        sidebarOpen: true,
        theme: 'light',

        toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
        setTheme: (theme) => set({ theme }),
      }),
      { name: 'ui-store' } // localStorage key for persistence
    )
  )
);

// Usage in any component
function Sidebar() {
  const { sidebarOpen, toggleSidebar } = useUIStore();
  // No prop drilling needed!
}
```

### Slices Pattern (for Large Stores)

```typescript
// Split a large store into slices
interface AuthSlice {
  user: User | null;
  setUser: (user: User | null) => void;
  logout: () => void;
}

interface UISlice {
  sidebarOpen: boolean;
  toggleSidebar: () => void;
}

const createAuthSlice = (set): AuthSlice => ({
  user: null,
  setUser: (user) => set({ user }),
  logout: () => set({ user: null }),
});

const createUISlice = (set): UISlice => ({
  sidebarOpen: true,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
});

export const useStore = create<AuthSlice & UISlice>()((...a) => ({
  ...createAuthSlice(...a),
  ...createUISlice(...a),
}));
```

---

## Context API

### When Context Is Enough

Context is great for:
- Values that rarely change (theme, locale, auth status)
- Values needed deep in the component tree
- Avoiding prop drilling for 2-3 levels

Context is NOT great for:
- Frequently updating values (causes re-renders of all consumers)
- Complex state logic (no built-in actions/reducers)
- Large amounts of state (one big context = many unnecessary re-renders)

```typescript
// Theme context — perfect use case (changes rarely)
const ThemeContext = createContext<{
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}>({ theme: 'light', toggleTheme: () => {} });

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  const toggleTheme = () => setTheme(t => t === 'light' ? 'dark' : 'light');

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export const useTheme = () => useContext(ThemeContext);
```

---

## URL State

### Why URL State Matters

URL state is shareable. If a user filters a table, they should be able to copy the URL and share it with a colleague who sees the exact same filtered view.

```typescript
import { useSearchParams } from 'react-router-dom';

function ProjectList() {
  const [searchParams, setSearchParams] = useSearchParams();

  const page = Number(searchParams.get('page') || '1');
  const status = searchParams.get('status') || 'all';
  const search = searchParams.get('q') || '';

  const updateFilters = (updates: Record<string, string>) => {
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev);
      Object.entries(updates).forEach(([key, value]) => {
        if (value) next.set(key, value);
        else next.delete(key);
      });
      return next;
    });
  };

  return (
    <>
      <input
        value={search}
        onChange={(e) => updateFilters({ q: e.target.value, page: '1' })}
        placeholder="Search projects..."
      />
      <Select
        value={status}
        onChange={(value) => updateFilters({ status: value, page: '1' })}
        options={['all', 'active', 'archived']}
      />
      <Pagination
        page={page}
        onChange={(p) => updateFilters({ page: String(p) })}
      />
    </>
  );
  // URL: /projects?q=dashboard&status=active&page=2
}
```

---

## Form State (React Hook Form + Zod)

```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

// Define schema with Zod
const createUserSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  role: z.enum(['USER', 'ADMIN']),
  age: z.number().min(18, 'Must be 18 or older').optional(),
});

type CreateUserForm = z.infer<typeof createUserSchema>;

function CreateUserForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<CreateUserForm>({
    resolver: zodResolver(createUserSchema),
    defaultValues: { role: 'USER' },
  });

  const onSubmit = async (data: CreateUserForm) => {
    await createUser.mutateAsync(data);
    reset();
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div>
        <input {...register('name')} placeholder="Name" />
        {errors.name && <span className="text-red-500">{errors.name.message}</span>}
      </div>
      <div>
        <input {...register('email')} placeholder="Email" />
        {errors.email && <span className="text-red-500">{errors.email.message}</span>}
      </div>
      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}
```

---

## Decision Matrix

| Scenario | Use | Why |
|----------|-----|-----|
| Data from API (users, projects, comments) | React Query | Caching, dedup, background refetch |
| Page filters, search, pagination | URL (useSearchParams) | Shareable, bookmarkable, back button works |
| Form inputs, validation | React Hook Form + Zod | Performance, validation, typed |
| Modal open, accordion state | useState | Local, simple, component-specific |
| Theme, language, layout preferences | Zustand or Context | Global, changes rarely |
| Selected items across pages | Zustand | Persists across navigation |
| Hover state, animations | CSS / useRef | No re-renders needed |
| Data derived from other state | Compute it (useMemo) | Never store what you can derive |

---

*State Management Guide v1.0 | Created: February 13, 2026*
