---
name: error_handling
description: Comprehensive error handling patterns for NestJS backend and React frontend
---

# Error Handling Skill

**Purpose**: Implement consistent, informative error handling across your full stack. Complements `error_boundaries` (React UI) and `error_tracking` (Sentry) — this skill covers the ARCHITECTURE of error handling.

## 🎯 TRIGGER COMMANDS

```text
"Set up error handling for [project]"
"Create exception filter for NestJS"
"Handle Prisma errors properly"
"Add error states to React components"
"Standardize error responses"
"Using error_handling skill"
```

## When to Use

- Setting up error handling for a new project
- Creating custom exception filters
- Mapping database errors to HTTP responses
- Implementing frontend error states (loading/error/success)
- Standardizing error response format across the API

---

## PART 1: NESTJS EXCEPTION FILTERS

### Built-in Exceptions

```typescript
// Use the right exception for the right situation
throw new BadRequestException('Invalid input');           // 400
throw new UnauthorizedException('Token expired');         // 401
throw new ForbiddenException('Insufficient permissions'); // 403
throw new NotFoundException('User not found');            // 404
throw new ConflictException('Email already exists');      // 409
throw new InternalServerErrorException('Unexpected error'); // 500

// With details
throw new BadRequestException({
  message: 'Validation failed',
  details: [
    { field: 'email', message: 'Must be a valid email' },
  ],
});
```

### Global Exception Filter

```typescript
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';
    let details: any = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      message = typeof res === 'string' ? res : (res as any).message;
      details = (res as any).details;
    } else if (exception instanceof Error) {
      this.logger.error(exception.message, exception.stack);
    }

    // Never expose stack traces to clients
    response.status(status).json({
      statusCode: status,
      error: HttpStatus[status],
      message,
      ...(details && { details }),
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}

// Register in main.ts
app.useGlobalFilters(new GlobalExceptionFilter());
```

---

## PART 2: PRISMA ERROR MAPPING

```typescript
@Catch(Prisma.PrismaClientKnownRequestError)
export class PrismaExceptionFilter implements ExceptionFilter {
  catch(exception: Prisma.PrismaClientKnownRequestError, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();

    switch (exception.code) {
      case 'P2002': {
        // Unique constraint violation
        const field = (exception.meta?.target as string[])?.join(', ');
        response.status(409).json({
          statusCode: 409,
          error: 'Conflict',
          message: `A record with this ${field} already exists`,
        });
        break;
      }

      case 'P2025':
        // Record not found
        response.status(404).json({
          statusCode: 404,
          error: 'Not Found',
          message: 'Record not found',
        });
        break;

      case 'P2003':
        // Foreign key constraint
        response.status(400).json({
          statusCode: 400,
          error: 'Bad Request',
          message: 'Referenced record does not exist',
        });
        break;

      case 'P2014':
        // Relation violation
        response.status(400).json({
          statusCode: 400,
          error: 'Bad Request',
          message: 'Cannot delete: related records exist',
        });
        break;

      default:
        response.status(500).json({
          statusCode: 500,
          error: 'Internal Server Error',
          message: 'Database error',
        });
    }
  }
}
```

### Common Prisma Error Codes

| Code | Meaning | HTTP Status |
|------|---------|-------------|
| P2002 | Unique constraint violation | 409 Conflict |
| P2003 | Foreign key constraint failure | 400 Bad Request |
| P2014 | Relation violation (required relation) | 400 Bad Request |
| P2025 | Record not found | 404 Not Found |
| P2024 | Connection pool timeout | 503 Service Unavailable |

---

## PART 3: FRONTEND ERROR PATTERNS

### API State with Discriminated Union

```typescript
type ApiState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };

function UserProfile({ userId }: { userId: string }) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['users', userId],
    queryFn: () => api.getUser(userId),
  });

  if (isLoading) return <Skeleton className="h-32" />;
  if (error) return <ErrorCard message={error.message} onRetry={() => refetch()} />;
  if (!data) return null;

  return <UserCard user={data} />;
}
```

### Error Card Component

```tsx
function ErrorCard({ message, onRetry }: { message: string; onRetry?: () => void }) {
  return (
    <div className="rounded-lg border border-red-200 bg-red-50 p-4">
      <div className="flex items-center gap-2">
        <AlertCircle className="h-5 w-5 text-red-500" />
        <p className="text-sm text-red-700">{message}</p>
      </div>
      {onRetry && (
        <button
          onClick={onRetry}
          className="mt-2 text-sm text-red-600 hover:text-red-700 underline"
        >
          Try again
        </button>
      )}
    </div>
  );
}
```

### Toast Notifications

```typescript
// API call with toast feedback
const createUser = useMutation({
  mutationFn: (dto: CreateUserDto) => api.createUser(dto),
  onSuccess: () => {
    toast.success('User created successfully');
    queryClient.invalidateQueries({ queryKey: ['users'] });
  },
  onError: (error: AxiosError<ErrorResponse>) => {
    const message = error.response?.data?.message || 'Something went wrong';
    toast.error(message);
  },
});
```

### Form Validation Errors

```tsx
function LoginForm() {
  const { register, handleSubmit, formState: { errors }, setError } = useForm();

  const onSubmit = async (data) => {
    try {
      await api.login(data);
    } catch (error) {
      if (error.response?.status === 401) {
        setError('root', { message: 'Invalid email or password' });
      } else if (error.response?.data?.details) {
        // Map server validation errors to form fields
        error.response.data.details.forEach(({ field, message }) => {
          setError(field, { message });
        });
      }
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {errors.root && (
        <div className="text-red-500 text-sm mb-4">{errors.root.message}</div>
      )}
      <input {...register('email')} />
      {errors.email && <span className="text-red-500">{errors.email.message}</span>}
    </form>
  );
}
```

---

## PART 4: OPERATIONAL VS PROGRAMMER ERRORS

| Type | What It Is | Example | How to Handle |
|------|-----------|---------|--------------|
| **Operational** | Expected failures | Network timeout, invalid input, DB down | Handle gracefully, show user message |
| **Programmer** | Bugs in code | TypeError, null reference, wrong logic | Fix the code, log for debugging |

```typescript
// Operational — expected, handle gracefully
try {
  const result = await externalApi.call();
} catch (error) {
  if (error.code === 'ECONNREFUSED') {
    throw new ServiceUnavailableException('External service is down');
  }
  throw error; // Unknown error — let global filter handle
}

// Programmer — unexpected, should never happen in correct code
// These bubble up to the global exception filter and return 500
// Fix the root cause, don't catch them
```

---

## PART 5: WHAT TO LOG VS NOT LOG

```typescript
// ✅ DO log
this.logger.error({
  message: 'Payment processing failed',
  userId: user.id,
  orderId: order.id,
  error: error.message,
  stack: error.stack,
  requestId: request.headers['x-request-id'],
});

// ❌ NEVER log
this.logger.error({
  password: user.password,        // NEVER
  creditCard: payment.cardNumber, // NEVER
  token: request.headers.authorization, // NEVER
  ssn: user.socialSecurityNumber, // NEVER
});
```

---

## ✅ Exit Checklist

- [ ] Global exception filter catches all unhandled errors
- [ ] Prisma errors mapped to proper HTTP status codes
- [ ] Error response format is consistent across all endpoints
- [ ] Frontend has loading/error/success states for all API calls
- [ ] Sensitive data never appears in error responses or logs
- [ ] Toast notifications for user-facing error feedback
- [ ] Form validation errors display per-field messages
