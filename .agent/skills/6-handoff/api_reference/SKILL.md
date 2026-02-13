---
name: API Reference Documentation
description: Standard for documenting machine-readable API specifications (OpenAPI/Swagger) for consumers
---

# API Reference Documentation Skill

**Purpose**: Treat your API documentation as a product. If the API is documented poorly, it is unusable.

> [!NOTE]
> **Code-First vs Design-First**: This skill supports both, but prefers **Code-First Generation** (TS -> OpenAPI) to prevent drift.

---

## 🎯 TRIGGER COMMANDS

```text
"Document the API endpoints"
"Generate swagger for [service]"
"Create openapi spec for [backend]"
"Using api_reference skill: document [controller]"
```

---

## 📜 THE STANDARD (OpenAPI 3.0+)

We use the OpenAPI (formerly Swagger) specification.

### Key Components

1. **Paths**: The URL structure (`GET /users/{id}`)
2. **Methods**: Verbs (`GET`, `POST`, `PUT`, `DELETE`)
3. **Parameters**: Path, Query, Header, Body
4. **Responses**: Success (200) AND Errors (400, 401, 403, 500)
5. **Schemas**: The data shape (`User`, `Error`)

---

## 📝 DOCUMENTATION CHECKLIST

For **Every** Endpoint:

### 1. Description

* What does it do?
* What permission is required? (e.g., `Required Scope: users:read`)

### 2. Request Example

* Don't just say "Object". Show the JSON.

```json
{
  "email": "user@example.com",
  "name": "Jane Doe"
}
```

### 3. Response Examples (Success & Failure)

* Show the 200 OK body.
* Show the 400 Validation Error body.

### 4. Authentication

* Which mechanism? Bearer Token? API Key?
* Where does it go? Header `Authorization`?

---

## 🤖 AUTOMATION STRATEGIES

Don't write YAML by hand. Generate it.

### Node.js / NestJS

Decorate the code:

```typescript
@ApiOperation({ summary: 'Create Cat' })
@ApiResponse({ status: 403, description: 'Forbidden.' })
async create(@Body() createCatDto: CreateCatDto) { ... }
```

### Python / FastAPI

Automatic based on types:

```python
@app.post("/items/", response_model=Item)
async def create_item(item: Item): ...
```

---

## ✅ API EMPATHY CHECKS

Ask these questions from the consumer's perspective:
* [ ] "How do I authenticate?"
* [ ] "What happens if I send invalid data?"
* [ ] "What is the rate limit?"
* [ ] "Is this value optional or required?"
* [ ] "What is the format of this date?"

---

## 🛠️ RECOMMENDED TOOLS

* **Generation**: Swagger UI, Redoc
* **Testing**: Postman, Insomnia
* **Hosting**: ReadMe.com, Mintlify
