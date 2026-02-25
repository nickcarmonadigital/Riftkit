---
name: Secret Management
description: Progress from .env files to production-grade secret management with rotation and detection.
---

# Secret Management Skill

**Purpose**: Implement secret management at the appropriate maturity level for your project. Covers the progression from local `.env` files through CI secrets to cloud Secrets Managers, including rotation patterns, secret detection in code, the "secret zero" problem, and per-environment scoping.

## TRIGGER COMMANDS

```text
"Set up secrets for [project]"
"Move from .env to Secrets Manager"
"Rotate secrets"
```

## When to Use
- Starting a new project and need to handle API keys and credentials
- Moving from development to staging/production environments
- A secret has been leaked and needs rotation
- Compliance requires secret audit trails (SOC2, HIPAA)
- Adding a new external service integration that requires credentials

---

## PROCESS

### Step 1: Assess Secret Maturity Level

```text
Level 0: Hardcoded in source         --> NEVER acceptable
Level 1: .env file (gitignored)      --> Local development only
Level 2: CI/CD secrets (GitHub/GitLab)--> Staging, small teams
Level 3: Cloud Secrets Manager       --> Production workloads
Level 4: HashiCorp Vault             --> Enterprise, multi-cloud
```

Most projects should target Level 2 for CI and Level 3 for production.

### Step 2: Local Development (.env Pattern)

```bash
# .env.example (committed to repo -- no real values)
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
JWT_SECRET=your-jwt-secret-here
OPENAI_API_KEY=sk-your-key-here
REDIS_URL=redis://localhost:6379

# .gitignore (MUST include)
.env
.env.local
.env.*.local
```

```typescript
// NestJS ConfigModule setup
import { ConfigModule } from '@nestjs/config';
import * as Joi from 'joi';

@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema: Joi.object({
        DATABASE_URL: Joi.string().required(),
        JWT_SECRET: Joi.string().min(32).required(),
        OPENAI_API_KEY: Joi.string().pattern(/^sk-/).required(),
        NODE_ENV: Joi.string().valid('development', 'staging', 'production').default('development'),
      }),
      validationOptions: {
        abortEarly: true,  // Fail fast on missing secrets
      },
    }),
  ],
})
export class AppModule {}
```

### Step 3: CI/CD Secrets (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production    # Ties to GitHub Environment with protection rules
    steps:
      - name: Deploy
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          JWT_SECRET: ${{ secrets.JWT_SECRET }}
        run: npm run deploy
```

Rules for CI secrets:
- One set of secrets per environment (dev, staging, production)
- Use GitHub Environments with required reviewers for production
- Never echo or log secret values in CI output
- Rotate after any team member departure

### Step 4: AWS Secrets Manager Integration

```typescript
// secrets/aws-secrets.service.ts
import { Injectable, OnModuleInit } from '@nestjs/common';
import { SecretsManagerClient, GetSecretValueCommand } from '@aws-sdk/client-secrets-manager';

@Injectable()
export class AwsSecretsService implements OnModuleInit {
  private client: SecretsManagerClient;
  private cache = new Map<string, { value: string; expiresAt: number }>();

  constructor() {
    this.client = new SecretsManagerClient({ region: process.env.AWS_REGION ?? 'us-east-1' });
  }

  async onModuleInit() {
    // Pre-load critical secrets at startup
    await this.getSecret('myapp/production/database');
    await this.getSecret('myapp/production/jwt');
  }

  async getSecret(secretId: string): Promise<string> {
    // Check cache (5 min TTL)
    const cached = this.cache.get(secretId);
    if (cached && cached.expiresAt > Date.now()) {
      return cached.value;
    }

    const command = new GetSecretValueCommand({ SecretId: secretId });
    const response = await this.client.send(command);
    const value = response.SecretString!;

    this.cache.set(secretId, {
      value,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    return value;
  }
}
```

### Step 5: Secret Rotation (Zero-Downtime)

```typescript
// Pattern: dual-read during rotation window
// 1. Generate new secret, store as "pending" version
// 2. Deploy app that accepts BOTH old and new
// 3. Activate new secret as "current"
// 4. Remove old secret after grace period

// jwt/jwt.service.ts -- dual-key verification
@Injectable()
export class JwtService {
  async verify(token: string): Promise<JwtPayload> {
    const currentSecret = await this.secrets.getSecret('jwt/current');
    const previousSecret = await this.secrets.getSecret('jwt/previous');

    try {
      return jwt.verify(token, currentSecret) as JwtPayload;
    } catch {
      // Fallback to previous key during rotation window
      return jwt.verify(token, previousSecret) as JwtPayload;
    }
  }

  async sign(payload: JwtPayload): Promise<string> {
    // Always sign with current key
    const currentSecret = await this.secrets.getSecret('jwt/current');
    return jwt.sign(payload, currentSecret, { expiresIn: '24h' });
  }
}
```

### Step 6: Secret Detection in Code (Pre-Commit)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

# Alternative: detect-secrets
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

```bash
# Initialize baseline (one-time)
detect-secrets scan > .secrets.baseline

# CI gate
detect-secrets scan --baseline .secrets.baseline
if [ $? -ne 0 ]; then
  echo "New secrets detected in code. Commit blocked."
  exit 1
fi
```

### Step 7: The "Secret Zero" Problem

The bootstrapping challenge: how does your app authenticate to the Secrets Manager?

```text
Solution by environment:
- Local dev:     AWS CLI profile (~/.aws/credentials) or .env
- CI/CD:         GitHub OIDC --> AWS IAM Role (no static keys)
- ECS/Fargate:   IAM Task Role (automatic, no secrets needed)
- Kubernetes:    IRSA (IAM Roles for Service Accounts)
- EC2:           Instance Profile (IAM Role attached to instance)
```

```yaml
# GitHub Actions OIDC -- no AWS keys stored as secrets
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789:role/GitHubActionsRole
      aws-region: us-east-1
```

---

## CHECKLIST

- [ ] No secrets hardcoded in source code (Level 0 eliminated)
- [ ] `.env.example` committed with placeholder values
- [ ] `.env` and all `.env.*local` files in `.gitignore`
- [ ] ConfigModule validates all required secrets at startup
- [ ] CI/CD uses environment-scoped secrets (not repo-wide)
- [ ] Production uses Secrets Manager or Vault (Level 3+)
- [ ] Secret rotation procedure documented and tested
- [ ] Pre-commit hook detects secrets before they reach the repo
- [ ] "Secret zero" solved with IAM roles or OIDC (no static bootstrap keys)
- [ ] Secret access is logged and auditable
