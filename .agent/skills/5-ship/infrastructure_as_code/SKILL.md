---
name: Infrastructure as Code (IaC)
description: Define servers, databases, and networks as version-controlled code - no manual clicking in consoles
---

# Infrastructure as Code (IaC) Skill

**Purpose**: Treat infrastructure exactly like application code. It should be versioned, tested, and reproducible.

> [!CAUTION]
> **ClickOps Ban**: Do NOT configure production servers by clicking buttons in a web console. If it's not in code, it doesn't exist.

---

## 🎯 TRIGGER COMMANDS

```text
"Provision new server for [project]"
"Create docker compose for [app]"
"Setup terraform for [infra]"
"Using IaC skill: deploy [resource]"
```

---

## 🏰 CORE CONCEPTS

### 1. Declarative vs Imperative

* **Imperative (Bad)**: "First create a server, then install nginx, then start it." (Scripting)
* **Declarative (Good)**: "I want one server running nginx." (State Definition)

### 2. Idempotency

Running the code once or 100 times should have the same result.

* *Run 1*: Creates the server.
* *Run 2*: Sees server exists, does nothing.

### 3. Immutable Infrastructure

Don't SSH in and patch servers. **Replace them.**

* Need to update Node.js? Deploy a new container/VM image, destroy the old one.

---

## 🏗️ DEFINITION STANDARDS

### Docker (Local/Container)

Always include a `docker-compose.yml` for the full stack.

```yaml
version: '3.8'
services:
  app:
    build: .
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/main
  db:
    image: postgres:15
    volumes:
      - pgdata:/var/lib/postgresql/data
```

### Terraform/Pulumi (Cloud Resources)

Use these for databases, buckets, and permissions.

```hcl
resource "aws_s3_bucket" "assets" {
  bucket = "my-project-assets"
  tags = {
    Environment = "Production"
  }
}
```

---

## 🔄 WORKFLOW: THE OPS LOOP

1. **Define**: Write `.tf` or `.yml` file.
2. **Plan**: Run `terraform plan` or `docker compose config` to see what will change.
3. **Apply**: Execute the change.
4. **Verify**: Automation checks if the resource is healthy.

---

## ✅ IMPLEMENTATION CHECKLIST

* [ ] **Containerization**: `Dockerfile` exists for every service
* [ ] **Orchestration**: `docker-compose.yml` exists for local dev
* [ ] **Secrets**: No secrets committed to git (use `.env` or Vault)
* [ ] **State Management**: Terraform state is stored remotely (not local file)
* [ ] **Locking**: State is locked during updates to prevent collisions
* [ ] **Tear Down**: `make clean` or equivalent command exists to wipe headers

---

## 🛠️ RECOMMENDED TOOLS

* **Containers**: Docker
* **Provisioning**: Terraform or Pulumi
* **Configuration**: Ansible (if using VMs)
* **Secrets**: Infisical or AWS Secrets Manager
