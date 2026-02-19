---
name: api_reference
description: OpenAPI/Swagger documentation for NestJS APIs — setup, decorators, client SDK generation
---

# API Reference Documentation Skill

**Purpose**: Treat your API documentation as a product. If the API is documented poorly, consumers (frontend devs, mobile devs, third-party integrators) will struggle to use it. Code-first Swagger generation keeps docs in sync with your actual API.

> [!NOTE]
> **Code-First vs Design-First**: This skill uses **Code-First Generation** — decorators on your NestJS code generate the OpenAPI spec automatically, preventing docs from drifting out of sync.

## 🎯 TRIGGER COMMANDS

```text
"Document the API endpoints"
"Generate Swagger for [service]"
"Create OpenAPI spec for [backend]"
"Setup Swagger UI in NestJS"
"Generate API client SDK"
"Using api_reference skill: document [controller]"
```

## When to Use

- Setting up Swagger/OpenAPI in a new NestJS project
- Documenting existing endpoints with proper decorators
- Generating typed client SDKs for frontend consumption
- Adding authentication to Swagger UI
- Versioning API documentation

---

## PART 1: NESTJS SWAGGER SETUP

### Installation

```bash
npm install @nestjs/swagger
```

### main.ts Configuration

```typescript
// main.ts
import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Swagger configuration
  const config = new DocumentBuilder()
    .setTitle('My API')
    .setDescription('API documentation for My Application')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'Authorization',
        description: 'Enter your JWT token',
        in: 'header',
      },
      'JWT-auth',  // Security scheme name (referenced in @ApiBearerAuth)
    )
    .addTag('auth', 'Authentication endpoints')
    .addTag('users', 'User management')
    .addTag('projects', 'Project operations')
    .build();

  const document = SwaggerModule.createDocument(app, config);

  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: {
      persistAuthorization: true,  // Keep token across page refreshes
      docExpansion: 'none',        // Collapse all by default
      filter: true,                // Enable search/filter
      showRequestDuration: true,   // Show response time
    },
  });

  await app.listen(3000);
  console.log('Swagger UI: http://localhost:3000/api/docs');
}
bootstrap();
```

### Enable CLI Plugin (Auto-detect DTOs)

```json
// nest-cli.json
{
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "plugins": [
      {
        "name": "@nestjs/swagger",
        "options": {
          "classValidatorShim": true,
          "introspectComments": true
        }
      }
    ]
  }
}
```

With the CLI plugin, Swagger automatically detects:
- DTO property types from TypeScript
- Validation rules from class-validator decorators
- Property descriptions from JSDoc comments

---

## PART 2: CONTROLLER DECORATORS

### Full Controller Example

```typescript
import {
  Controller, Get, Post, Put, Delete, Param, Body, Query,
  UseGuards, HttpCode, HttpStatus,
} from '@nestjs/common';
import {
  ApiTags, ApiBearerAuth, ApiOperation, ApiResponse,
  ApiParam, ApiQuery, ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/user.decorator';

@ApiTags('projects')
@ApiBearerAuth('JWT-auth')
@UseGuards(JwtAuthGuard)
@Controller('api/projects')
export class ProjectController {
  constructor(private readonly projectService: ProjectService) {}

  @Get()
  @ApiOperation({
    summary: 'List all projects',
    description: 'Returns paginated list of projects for the authenticated user',
  })
  @ApiQuery({ name: 'page', required: false, type: Number, example: 1 })
  @ApiQuery({ name: 'limit', required: false, type: Number, example: 20 })
  @ApiQuery({ name: 'search', required: false, type: String })
  @ApiResponse({
    status: 200,
    description: 'Projects retrieved successfully',
    type: PaginatedProjectDto,
  })
  @ApiResponse({ status: 401, description: 'Unauthorized — invalid or missing JWT' })
  async findAll(
    @CurrentUser() user: UserPayload,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
    @Query('search') search?: string,
  ) {
    return this.projectService.findAll(user.sub, { page, limit, search });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a project by ID' })
  @ApiParam({ name: 'id', type: String, format: 'uuid', description: 'Project UUID' })
  @ApiResponse({ status: 200, description: 'Project found', type: ProjectDto })
  @ApiResponse({ status: 404, description: 'Project not found' })
  async findOne(
    @CurrentUser() user: UserPayload,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.projectService.findOne(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new project' })
  @ApiBody({ type: CreateProjectDto })
  @ApiResponse({ status: 201, description: 'Project created', type: ProjectDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Project name already exists' })
  async create(
    @CurrentUser() user: UserPayload,
    @Body() dto: CreateProjectDto,
  ) {
    return this.projectService.create(user.sub, dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a project' })
  @ApiParam({ name: 'id', type: String, format: 'uuid' })
  @ApiBody({ type: UpdateProjectDto })
  @ApiResponse({ status: 200, description: 'Project updated', type: ProjectDto })
  @ApiResponse({ status: 404, description: 'Project not found' })
  async update(
    @CurrentUser() user: UserPayload,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateProjectDto,
  ) {
    return this.projectService.update(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a project' })
  @ApiParam({ name: 'id', type: String, format: 'uuid' })
  @ApiResponse({ status: 204, description: 'Project deleted' })
  @ApiResponse({ status: 404, description: 'Project not found' })
  async remove(
    @CurrentUser() user: UserPayload,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.projectService.remove(id, user.sub);
  }
}
```

---

## PART 3: DTO DECORATORS (@ApiProperty)

### Basic Properties

```typescript
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum, MinLength, MaxLength, IsUUID } from 'class-validator';

export class CreateProjectDto {
  @ApiProperty({
    description: 'The project name',
    example: 'My Awesome Project',
    minLength: 1,
    maxLength: 100,
  })
  @IsString()
  @MinLength(1)
  @MaxLength(100)
  name: string;

  @ApiPropertyOptional({
    description: 'Project description',
    example: 'A project for managing tasks',
    maxLength: 500,
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  description?: string;

  @ApiProperty({
    description: 'Project status',
    enum: ProjectStatus,
    example: ProjectStatus.ACTIVE,
    default: ProjectStatus.ACTIVE,
  })
  @IsEnum(ProjectStatus)
  status: ProjectStatus;
}
```

### Nested Objects and Arrays

```typescript
export class CreateOrderDto {
  @ApiProperty({
    description: 'Order items',
    type: [OrderItemDto],       // Array of nested DTOs
    minItems: 1,
  })
  @ValidateNested({ each: true })
  @Type(() => OrderItemDto)
  items: OrderItemDto[];

  @ApiProperty({
    description: 'Shipping address',
    type: AddressDto,           // Nested object
  })
  @ValidateNested()
  @Type(() => AddressDto)
  address: AddressDto;
}

export class OrderItemDto {
  @ApiProperty({ description: 'Product ID', format: 'uuid' })
  @IsUUID()
  productId: string;

  @ApiProperty({ description: 'Quantity', minimum: 1, example: 2 })
  @IsInt()
  @Min(1)
  quantity: number;
}
```

### Response DTOs

```typescript
export class ProjectDto {
  @ApiProperty({ format: 'uuid', example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: 'My Project' })
  name: string;

  @ApiPropertyOptional({ example: 'A description' })
  description?: string;

  @ApiProperty({ enum: ProjectStatus })
  status: ProjectStatus;

  @ApiProperty({ format: 'date-time', example: '2026-02-13T10:30:00.000Z' })
  createdAt: Date;

  @ApiProperty({ format: 'date-time' })
  updatedAt: Date;
}

export class PaginatedProjectDto {
  @ApiProperty({ type: [ProjectDto] })
  data: ProjectDto[];

  @ApiProperty({ example: 42 })
  total: number;

  @ApiProperty({ example: 1 })
  page: number;

  @ApiProperty({ example: 20 })
  limit: number;

  @ApiProperty({ example: true })
  hasMore: boolean;
}
```

### Reusable Error Response

```typescript
export class ErrorResponseDto {
  @ApiProperty({ example: 400 })
  statusCode: number;

  @ApiProperty({ example: 'Validation failed' })
  message: string;

  @ApiProperty({ example: 'Bad Request' })
  error: string;

  @ApiPropertyOptional({
    description: 'Validation error details',
    example: ['name must be at least 1 character', 'email must be an email'],
    type: [String],
  })
  details?: string[];
}
```

---

## PART 4: SWAGGER UI AUTHENTICATION

### Using Bearer Token in Swagger UI

After configuring `addBearerAuth` in DocumentBuilder:

```
1. Click "Authorize" button in Swagger UI
2. Enter: Bearer <your-jwt-token>
3. Click "Authorize"
4. All requests now include the Authorization header
```

### Login Flow for Testing

```typescript
// Create an auth endpoint that returns a token
@ApiTags('auth')
@Controller('api/auth')
export class AuthController {
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login and get JWT token' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        email: { type: 'string', example: 'user@example.com' },
        password: { type: 'string', example: 'password123' },
      },
      required: ['email', 'password'],
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Login successful',
    schema: {
      type: 'object',
      properties: {
        success: { type: 'boolean', example: true },
        data: {
          type: 'object',
          properties: {
            accessToken: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIs...' },
            refreshToken: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIs...' },
          },
        },
      },
    },
  })
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto.email, dto.password);
  }
}
```

---

## PART 5: API VERSIONING IN DOCS

### NestJS URI Versioning

```typescript
// main.ts
app.enableVersioning({
  type: VersioningType.URI,
  defaultVersion: '1',
});
```

```typescript
// Versioned controller
@Controller({ path: 'api/projects', version: '1' })
export class ProjectV1Controller { ... }

@Controller({ path: 'api/projects', version: '2' })
export class ProjectV2Controller { ... }
```

### Separate Swagger Docs per Version

```typescript
// main.ts — create separate docs
const v1Config = new DocumentBuilder()
  .setTitle('My API v1')
  .setVersion('1.0')
  .addBearerAuth(/* ... */)
  .build();

const v2Config = new DocumentBuilder()
  .setTitle('My API v2')
  .setVersion('2.0')
  .addBearerAuth(/* ... */)
  .build();

const v1Document = SwaggerModule.createDocument(app, v1Config, {
  include: [AuthModule, ProjectV1Module, UserModule],
});
SwaggerModule.setup('api/v1/docs', app, v1Document);

const v2Document = SwaggerModule.createDocument(app, v2Config, {
  include: [AuthModule, ProjectV2Module, UserModule],
});
SwaggerModule.setup('api/v2/docs', app, v2Document);
```

---

## PART 6: GENERATING CLIENT SDKs

### Why Generate SDKs?

Instead of manually writing fetch/axios calls on the frontend, generate a typed client from your OpenAPI spec:

```
Before (manual):
  const res = await fetch('/api/projects', { headers: { Authorization: `Bearer ${token}` } });
  const data = await res.json();  // data is `any` — no type safety

After (generated):
  const data = await api.projects.findAll();  // Fully typed response
```

### Export OpenAPI JSON

```typescript
// Add to main.ts after creating the document
import { writeFileSync } from 'fs';

const document = SwaggerModule.createDocument(app, config);

// Export spec for SDK generation
if (process.env.NODE_ENV === 'development') {
  writeFileSync('./openapi.json', JSON.stringify(document, null, 2));
}
```

### Generate with Orval (Recommended for React)

```bash
# Install
npm install -D orval

# Create config
```

```typescript
// orval.config.ts
import { defineConfig } from 'orval';

export default defineConfig({
  api: {
    input: './openapi.json',       // From NestJS export
    output: {
      target: '../frontend/src/api/generated.ts',
      client: 'react-query',       // Generates React Query hooks
      mode: 'tags-split',          // Separate files per tag
      override: {
        mutator: {
          path: '../frontend/src/api/axios-instance.ts',
          name: 'customInstance',
        },
      },
    },
  },
});
```

```bash
# Generate
npx orval

# Output:
# frontend/src/api/auth.ts        — useLogin(), useRegister()
# frontend/src/api/projects.ts    — useGetProjects(), useCreateProject()
# frontend/src/api/users.ts       — useGetUser(), useUpdateUser()
```

### Generated Hook Usage (React Query)

```typescript
// The generated hooks are fully typed
import { useGetProjects, useCreateProject } from '../api/projects';

function ProjectList() {
  // Typed query — data is ProjectDto[]
  const { data, isLoading } = useGetProjects({ page: 1, limit: 20 });

  // Typed mutation — dto is CreateProjectDto
  const createMutation = useCreateProject();

  const handleCreate = () => {
    createMutation.mutate({
      name: 'New Project',        // TypeScript knows this is required
      description: 'Optional',    // TypeScript knows this is optional
    });
  };

  return (/* ... */);
}
```

### Generate with openapi-generator (Language-Agnostic)

```bash
# Generate TypeScript Axios client
npx @openapitools/openapi-generator-cli generate \
  -i openapi.json \
  -g typescript-axios \
  -o ../frontend/src/api/generated

# Generate for other languages
# -g python, -g java, -g go, -g ruby, -g csharp
```

---

## PART 7: DOCUMENTATION BEST PRACTICES

### Every Endpoint Must Have

```
1. Summary — One-line description of what it does
2. Description — Detailed explanation (if complex)
3. Request body example — Show the JSON, not just the schema
4. Response examples — Success AND error responses
5. Auth requirements — Which guard/role is needed
6. Status codes — All possible responses (200, 400, 401, 404, 409, 500)
```

### API Empathy Checks

Ask these from the consumer's perspective:

```
[ ] "How do I authenticate?"
    → Swagger UI has a working Authorize button

[ ] "What happens if I send invalid data?"
    → 400 responses documented with example validation errors

[ ] "What is the rate limit?"
    → Documented in description or headers

[ ] "Is this field optional or required?"
    → Every field marked clearly in the schema

[ ] "What format is this date?"
    → ISO 8601 format noted with examples

[ ] "What does this error mean?"
    → Error codes and messages documented

[ ] "Can I try this right now?"
    → Swagger UI allows testing with real requests
```

### Common Documentation Mistakes

```
BAD:
├── No examples — Consumer has to guess the format
├── Missing error responses — Only documenting the happy path
├── Stale docs — Decorators don't match actual behavior
├── "Returns object" — What object? What shape?
└── No auth info — Consumer doesn't know what token to send

GOOD:
├── Every field has an example value
├── All error responses documented (400, 401, 403, 404, 409, 500)
├── Decorators match class-validator rules
├── Response DTOs match actual response shape
└── Swagger UI configured with auth for testing
```

---

## PART 8: KEEPING DOCS IN SYNC

### Code-First Advantages

```
Code changes → Decorators update → Swagger updates automatically

No separate YAML/JSON to maintain
No drift between docs and implementation
TypeScript compiler catches mismatches
```

### CI Check for Spec Changes

```yaml
# .github/workflows/api-spec.yml
- name: Generate OpenAPI spec
  run: |
    npm run build
    npm run generate:openapi  # Script that exports openapi.json

- name: Check for uncommitted spec changes
  run: |
    git diff --exit-code openapi.json || \
      (echo "OpenAPI spec has changed. Commit the updated openapi.json" && exit 1)
```

---

## ✅ Exit Checklist

- [ ] Swagger UI accessible at `/api/docs`
- [ ] Bearer auth configured and working in Swagger UI
- [ ] All controllers have `@ApiTags` and `@ApiBearerAuth`
- [ ] All endpoints have `@ApiOperation` with summary
- [ ] All endpoints have `@ApiResponse` for success AND error status codes
- [ ] All DTOs have `@ApiProperty` with examples
- [ ] Nested objects and arrays properly typed
- [ ] CLI plugin enabled for auto-detection
- [ ] API versioning reflected in docs (if applicable)
- [ ] OpenAPI spec exported for client SDK generation
- [ ] Generated client SDK is typed and up to date
