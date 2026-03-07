---
name: runtime_security_monitoring
description: Real-time threat detection, WAF configuration, container runtime security, and automated incident response for production applications
---

# Runtime Security Monitoring Skill

**Purpose**: Detect and respond to active threats against running applications. Shift security from "build-time only" to continuous runtime protection — catch SQL injection attempts, brute force attacks, container escapes, and API abuse as they happen.

> [!IMPORTANT]
> **Build-time security is necessary but not sufficient**. Attackers don't care about your CI/CD pipeline — they attack your running application. Runtime monitoring closes the gap.

## TRIGGER COMMANDS

```text
"Setup WAF for [service]"
"Add runtime security monitoring"
"Configure threat detection for [project]"
"Implement rate limiting and brute force protection"
"Setup container runtime security with Falco"
"Using runtime_security_monitoring skill: protect [component]"
```

## When to Use

- Deploying a web application or API to production
- Setting up WAF rules for common attack patterns
- Implementing rate limiting and brute force protection
- Adding container runtime security (Falco, Seccomp, AppArmor)
- Configuring automated alerting and blocking for security events
- Detecting API abuse patterns (scraping, enumeration, account takeover)

---

## PART 1: DEFENSE LAYERS

```
Internet
    │
    v
┌──────────────┐
│ CDN/WAF      │  Layer 1: Edge filtering (Cloudflare, AWS WAF)
│ DDoS + Rules │  Block known-bad IPs, rate limit, geo-block
└──────┬───────┘
       │
       v
┌──────────────┐
│ Load Balancer│  Layer 2: TLS termination, health checks
│ Rate Limits  │  Connection limits, request size limits
└──────┬───────┘
       │
       v
┌──────────────┐
│ Application  │  Layer 3: Input validation, auth, RASP
│ Middleware   │  Request validation, session management
└──────┬───────┘
       │
       v
┌──────────────┐
│ Container    │  Layer 4: Syscall filtering, file integrity
│ Runtime      │  Falco rules, Seccomp profiles, read-only FS
└──────────────┘
```

---

## PART 2: WAF CONFIGURATION

### AWS WAF — Managed Rules + Custom Rules

```json
{
  "Name": "production-web-acl",
  "DefaultAction": { "Allow": {} },
  "Rules": [
    {
      "Name": "AWSManagedRulesCommonRuleSet",
      "Priority": 1,
      "Statement": {
        "ManagedRuleGroupStatement": {
          "VendorName": "AWS",
          "Name": "AWSManagedRulesCommonRuleSet",
          "ExcludedRules": []
        }
      },
      "OverrideAction": { "None": {} },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "CommonRuleSet"
      }
    },
    {
      "Name": "AWSManagedRulesSQLiRuleSet",
      "Priority": 2,
      "Statement": {
        "ManagedRuleGroupStatement": {
          "VendorName": "AWS",
          "Name": "AWSManagedRulesSQLiRuleSet"
        }
      },
      "OverrideAction": { "None": {} },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "SQLiRuleSet"
      }
    },
    {
      "Name": "RateLimit-Global",
      "Priority": 5,
      "Statement": {
        "RateBasedStatement": {
          "Limit": 2000,
          "AggregateKeyType": "IP"
        }
      },
      "Action": { "Block": {} },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "RateLimitGlobal"
      }
    },
    {
      "Name": "RateLimit-Login",
      "Priority": 6,
      "Statement": {
        "RateBasedStatement": {
          "Limit": 100,
          "AggregateKeyType": "IP",
          "ScopeDownStatement": {
            "ByteMatchStatement": {
              "FieldToMatch": { "UriPath": {} },
              "PositionalConstraint": "STARTS_WITH",
              "SearchString": "/api/auth/login",
              "TextTransformations": [{ "Priority": 0, "Type": "LOWERCASE" }]
            }
          }
        }
      },
      "Action": { "Block": {} },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "RateLimitLogin"
      }
    }
  ]
}
```

### Cloudflare WAF Rules (Terraform)

```hcl
resource "cloudflare_ruleset" "waf_custom" {
  zone_id = var.zone_id
  name    = "Custom WAF Rules"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  # Block known malicious user agents
  rules {
    action      = "block"
    expression  = "(http.user_agent contains \"sqlmap\") or (http.user_agent contains \"nikto\") or (http.user_agent contains \"masscan\")"
    description = "Block known attack tools"
  }

  # Block requests with suspicious query strings
  rules {
    action      = "block"
    expression  = "(http.request.uri.query contains \"UNION SELECT\") or (http.request.uri.query contains \"<script\") or (http.request.uri.query contains \"../../../\")"
    description = "Block SQLi/XSS/path traversal in query string"
  }

  # Challenge requests to admin endpoints from non-office IPs
  rules {
    action      = "managed_challenge"
    expression  = "(http.request.uri.path contains \"/admin\") and not (ip.src in {10.0.0.0/8 172.16.0.0/12})"
    description = "Challenge non-internal admin access"
  }

  # Rate limit API endpoints
  rules {
    action      = "block"
    expression  = "(http.request.uri.path starts_with \"/api/\") and (rate(http.request.uri.path, 60) > 300)"
    description = "API rate limit: 300 req/min per path"
  }
}
```

### ModSecurity (NGINX)

```nginx
# /etc/nginx/modsecurity/modsecurity.conf
SecRuleEngine On
SecRequestBodyAccess On
SecResponseBodyAccess Off
SecAuditEngine RelevantOnly
SecAuditLog /var/log/modsecurity/audit.log

# Include OWASP Core Rule Set
Include /etc/nginx/modsecurity/crs/crs-setup.conf
Include /etc/nginx/modsecurity/crs/rules/*.conf

# Custom rule: Block path traversal in file upload names
SecRule FILES_NAMES "@contains ../" \
    "id:10001,phase:2,deny,status:403,msg:'Path traversal in filename'"

# Custom rule: Block requests with excessively long cookies
SecRule REQUEST_COOKIES_NAMES "@gt 64" \
    "id:10002,phase:1,deny,status:403,msg:'Oversized cookie name'"
```

---

## PART 3: REAL-TIME THREAT DETECTION

### Application-Level Threat Detection Middleware

```typescript
// middleware/threat-detection.middleware.ts
import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

interface ThreatSignal {
  type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  detail: string;
}

@Injectable()
export class ThreatDetectionMiddleware implements NestMiddleware {
  private readonly logger = new Logger('ThreatDetection');

  use(req: Request, res: Response, next: NextFunction) {
    const signals = this.detectThreats(req);

    if (signals.length > 0) {
      const critical = signals.filter(s => s.severity === 'critical');
      const high = signals.filter(s => s.severity === 'high');

      // Log all signals
      for (const signal of signals) {
        this.logger.warn('Threat signal detected', {
          type: signal.type,
          severity: signal.severity,
          detail: signal.detail,
          ip: req.ip,
          method: req.method,
          url: req.originalUrl,
          userAgent: req.headers['user-agent']?.substring(0, 200),
          userId: (req as any).user?.sub,
        });
      }

      // Block on critical signals
      if (critical.length > 0) {
        res.status(403).json({ error: 'Request blocked by security policy' });
        return;
      }

      // Tag high signals for downstream processing
      if (high.length > 0) {
        (req as any).securityFlags = signals;
      }
    }

    next();
  }

  private detectThreats(req: Request): ThreatSignal[] {
    const signals: ThreatSignal[] = [];
    const url = req.originalUrl.toLowerCase();
    const body = JSON.stringify(req.body || {}).toLowerCase();
    const headers = JSON.stringify(req.headers).toLowerCase();

    // SQL injection patterns
    const sqliPatterns = [
      /union\s+(all\s+)?select/i,
      /;\s*drop\s+table/i,
      /'\s*or\s+'1'\s*=\s*'1/i,
      /'\s*;\s*--/i,
      /sleep\s*\(\s*\d+\s*\)/i,
      /benchmark\s*\(/i,
    ];
    for (const pattern of sqliPatterns) {
      if (pattern.test(url) || pattern.test(body)) {
        signals.push({ type: 'sqli', severity: 'critical', detail: `Pattern: ${pattern.source}` });
      }
    }

    // XSS patterns
    const xssPatterns = [
      /<script[^>]*>/i,
      /javascript\s*:/i,
      /on(error|load|click|mouseover)\s*=/i,
      /<iframe[^>]*>/i,
      /<object[^>]*>/i,
    ];
    for (const pattern of xssPatterns) {
      if (pattern.test(url) || pattern.test(body)) {
        signals.push({ type: 'xss', severity: 'high', detail: `Pattern: ${pattern.source}` });
      }
    }

    // Path traversal
    if (/\.\.[\/\\]/.test(url) || /\.\.[\/\\]/.test(body)) {
      signals.push({ type: 'path_traversal', severity: 'critical', detail: 'Directory traversal attempt' });
    }

    // Command injection
    const cmdiPatterns = [/;\s*(ls|cat|wget|curl|bash|sh|nc)\s/i, /\$\(.*\)/, /`[^`]+`/];
    for (const pattern of cmdiPatterns) {
      if (pattern.test(body)) {
        signals.push({ type: 'command_injection', severity: 'critical', detail: `Pattern: ${pattern.source}` });
      }
    }

    // Suspicious user agent
    const badAgents = ['sqlmap', 'nikto', 'masscan', 'nmap', 'dirbuster', 'gobuster'];
    const ua = (req.headers['user-agent'] || '').toLowerCase();
    for (const agent of badAgents) {
      if (ua.includes(agent)) {
        signals.push({ type: 'recon_tool', severity: 'high', detail: `Tool: ${agent}` });
      }
    }

    return signals;
  }
}
```

### Brute Force Detection

```typescript
// guards/brute-force.guard.ts
import { Injectable, CanActivate, ExecutionContext, HttpException, HttpStatus, Logger } from '@nestjs/common';

interface LoginAttempt {
  count: number;
  firstAttempt: number;
  blocked: boolean;
  blockedUntil: number;
}

@Injectable()
export class BruteForceGuard implements CanActivate {
  private readonly logger = new Logger('BruteForce');
  private attempts = new Map<string, LoginAttempt>();  // Use Redis in production

  private readonly MAX_ATTEMPTS = 5;
  private readonly WINDOW_MS = 15 * 60 * 1000;    // 15 minutes
  private readonly BLOCK_DURATION_MS = 30 * 60 * 1000; // 30 minutes

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const key = this.getKey(request);

    const attempt = this.attempts.get(key);

    if (attempt?.blocked && Date.now() < attempt.blockedUntil) {
      this.logger.warn('Blocked login attempt', {
        ip: request.ip,
        email: request.body?.email,
        blockedUntil: new Date(attempt.blockedUntil).toISOString(),
      });
      throw new HttpException('Too many login attempts. Try again later.', HttpStatus.TOO_MANY_REQUESTS);
    }

    // Reset if window expired
    if (attempt && Date.now() - attempt.firstAttempt > this.WINDOW_MS) {
      this.attempts.delete(key);
    }

    return true;
  }

  recordFailedAttempt(ip: string, email: string) {
    const key = `${ip}:${email}`;
    const attempt = this.attempts.get(key) || { count: 0, firstAttempt: Date.now(), blocked: false, blockedUntil: 0 };

    attempt.count++;

    if (attempt.count >= this.MAX_ATTEMPTS) {
      attempt.blocked = true;
      attempt.blockedUntil = Date.now() + this.BLOCK_DURATION_MS;
      this.logger.warn('Account temporarily locked', {
        ip, email, attempts: attempt.count,
        blockedUntil: new Date(attempt.blockedUntil).toISOString(),
      });
    }

    this.attempts.set(key, attempt);
  }

  recordSuccessfulLogin(ip: string, email: string) {
    this.attempts.delete(`${ip}:${email}`);
  }

  private getKey(request: any): string {
    return `${request.ip}:${request.body?.email || 'unknown'}`;
  }
}
```

---

## PART 4: RATE LIMITING

### Application-Level Rate Limiting (NestJS + Redis)

```typescript
// rate-limit.module.ts
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { ThrottlerStorageRedisService } from '@nest-lab/throttler-storage-redis';

@Module({
  imports: [
    ThrottlerModule.forRoot({
      throttlers: [
        { name: 'short', ttl: 1000, limit: 10 },    // 10 req/sec
        { name: 'medium', ttl: 60000, limit: 100 },  // 100 req/min
        { name: 'long', ttl: 3600000, limit: 1000 }, // 1000 req/hour
      ],
      storage: new ThrottlerStorageRedisService({
        host: process.env.REDIS_HOST || 'localhost',
        port: 6379,
      }),
    }),
  ],
  providers: [{ provide: APP_GUARD, useClass: ThrottlerGuard }],
})
export class RateLimitModule {}
```

```typescript
// Per-endpoint overrides
@Controller('auth')
export class AuthController {
  @Post('login')
  @Throttle({ short: { ttl: 1000, limit: 3 }, medium: { ttl: 60000, limit: 10 } })
  async login(@Body() dto: LoginDto) { /* ... */ }

  @Post('forgot-password')
  @Throttle({ medium: { ttl: 60000, limit: 3 }, long: { ttl: 3600000, limit: 5 } })
  async forgotPassword(@Body() dto: ForgotPasswordDto) { /* ... */ }
}
```

### IP Reputation with fail2ban

```ini
# /etc/fail2ban/jail.d/webapp.conf
[webapp-auth]
enabled  = true
port     = http,https
filter   = webapp-auth
logpath  = /var/log/app/security.log
maxretry = 5
findtime = 900     # 15 minutes
bantime  = 1800    # 30 minutes
action   = iptables-multiport[name=webapp, port="http,https"]
           slack-notify[channel=#security]

[webapp-scanner]
enabled  = true
port     = http,https
filter   = webapp-scanner
logpath  = /var/log/nginx/access.log
maxretry = 20
findtime = 60
bantime  = 3600
```

```ini
# /etc/fail2ban/filter.d/webapp-auth.conf
[Definition]
failregex = .*"type":"auth_failure".*"ip":"<HOST>".*
            .*"type":"brute_force".*"ip":"<HOST>".*
ignoreregex =
```

---

## PART 5: CONTAINER RUNTIME SECURITY

### Falco Rules

```yaml
# falco-rules.yaml
- rule: Terminal shell in container
  desc: Detect a shell spawned in a container (possible exec breakout)
  condition: >
    spawned_process and container and
    shell_procs and not proc.pname in (cron, crond, supervisord)
  output: >
    Shell spawned in container (user=%user.name container=%container.name
    shell=%proc.name parent=%proc.pname command=%proc.cmdline)
  priority: WARNING
  tags: [container, shell, mitre_execution]

- rule: Read sensitive file
  desc: Detect reading of sensitive files inside container
  condition: >
    open_read and container and
    (fd.name startswith /etc/shadow or
     fd.name startswith /etc/passwd or
     fd.name startswith /proc/self/environ)
  output: >
    Sensitive file read in container (user=%user.name file=%fd.name
    container=%container.name command=%proc.cmdline)
  priority: CRITICAL
  tags: [container, filesystem, mitre_credential_access]

- rule: Unexpected outbound connection
  desc: Detect outbound connections to unexpected ports
  condition: >
    outbound and container and
    not (fd.sport in (80, 443, 53, 5432, 6379, 4317)) and
    not proc.name in (curl, wget, node, python, java)
  output: >
    Unexpected outbound connection (user=%user.name command=%proc.cmdline
    connection=%fd.name container=%container.name)
  priority: WARNING
  tags: [container, network, mitre_exfiltration]

- rule: Package management in container
  desc: Detect package installation in running container (should use image builds)
  condition: >
    spawned_process and container and
    proc.name in (apt, apt-get, yum, dnf, apk, pip, npm)
  output: >
    Package management in container (user=%user.name command=%proc.cmdline
    container=%container.name)
  priority: ERROR
  tags: [container, software_mgmt, mitre_persistence]

- rule: Write to /etc
  desc: Detect writes to system configuration
  condition: >
    open_write and container and fd.name startswith /etc/
  output: >
    Write to /etc in container (user=%user.name file=%fd.name
    container=%container.name command=%proc.cmdline)
  priority: ERROR
  tags: [container, filesystem, mitre_persistence]
```

### Seccomp Profiles

```json
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {
      "names": [
        "accept", "accept4", "access", "bind", "brk", "chdir", "chmod",
        "clock_getres", "clock_gettime", "clone", "close", "connect",
        "dup", "dup2", "epoll_create", "epoll_create1", "epoll_ctl",
        "epoll_wait", "eventfd2", "execve", "exit", "exit_group",
        "faccessat", "fadvise64", "fchmod", "fchown", "fcntl",
        "fdatasync", "flock", "fork", "fstat", "fstatfs", "fsync",
        "ftruncate", "futex", "getcwd", "getdents", "getdents64",
        "getegid", "geteuid", "getgid", "getpeername", "getpid",
        "getppid", "getrandom", "getresgid", "getresuid",
        "getsockname", "getsockopt", "gettid", "gettimeofday",
        "getuid", "ioctl", "kill", "listen", "lseek", "lstat",
        "madvise", "memfd_create", "mincore", "mkdir", "mmap",
        "mprotect", "mremap", "munmap", "nanosleep", "newfstatat",
        "open", "openat", "pipe", "pipe2", "poll", "ppoll", "prctl",
        "pread64", "preadv", "prlimit64", "pwrite64", "pwritev",
        "read", "readlink", "readlinkat", "readv", "recvfrom",
        "recvmsg", "rename", "renameat", "renameat2", "rmdir",
        "rt_sigaction", "rt_sigprocmask", "rt_sigreturn",
        "sched_getaffinity", "sched_yield", "seccomp", "select",
        "sendfile", "sendmsg", "sendto", "set_robust_list",
        "set_tid_address", "setgid", "setgroups", "setsockopt",
        "setuid", "shutdown", "sigaltstack", "socket", "socketpair",
        "stat", "statfs", "symlink", "sysinfo", "tgkill",
        "timerfd_create", "timerfd_settime", "umask", "uname",
        "unlink", "unlinkat", "wait4", "waitid", "write", "writev"
      ],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
```

### Kubernetes Security Context

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000
        seccompProfile:
          type: Localhost
          localhostProfile: profiles/app-seccomp.json

      containers:
        - name: app
          image: app:1.0.0
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: [ALL]
              add: [NET_BIND_SERVICE]  # Only if binding to port < 1024

          volumeMounts:
            - name: tmp
              mountPath: /tmp
            - name: cache
              mountPath: /app/.cache

      volumes:
        - name: tmp
          emptyDir: { sizeLimit: 100Mi }
        - name: cache
          emptyDir: { sizeLimit: 200Mi }
```

---

## PART 6: API ABUSE DETECTION

### Common Abuse Patterns

```
Pattern                  │ Indicators                           │ Response
─────────────────────────┼──────────────────────────────────────┼──────────────────
Scraping                 │ High rate, sequential IDs, no JS     │ Rate limit + CAPTCHA
Account enumeration      │ Many 404s on /users/{id}             │ Consistent responses
Credential stuffing      │ Many failed logins, diverse IPs      │ CAPTCHA + account lock
API key abuse            │ Burst traffic from single key        │ Key throttle + revoke
Content farming          │ Automated POST patterns              │ Rate limit + review
Parameter tampering      │ Modified prices, IDs, roles          │ Server-side validation
```

### Anomaly Detection Service

```typescript
// services/anomaly-detection.service.ts
import { Injectable, Logger } from '@nestjs/common';

interface RequestProfile {
  requestCount: number;
  uniqueEndpoints: Set<string>;
  errorCount: number;
  avgResponseTime: number;
  firstSeen: number;
  lastSeen: number;
}

@Injectable()
export class AnomalyDetectionService {
  private readonly logger = new Logger('AnomalyDetection');
  private profiles = new Map<string, RequestProfile>();  // Use Redis in production

  trackRequest(ip: string, endpoint: string, statusCode: number, responseTimeMs: number) {
    const profile = this.profiles.get(ip) || {
      requestCount: 0, uniqueEndpoints: new Set(), errorCount: 0,
      avgResponseTime: 0, firstSeen: Date.now(), lastSeen: Date.now(),
    };

    profile.requestCount++;
    profile.uniqueEndpoints.add(endpoint);
    if (statusCode >= 400) profile.errorCount++;
    profile.avgResponseTime = (profile.avgResponseTime * (profile.requestCount - 1) + responseTimeMs) / profile.requestCount;
    profile.lastSeen = Date.now();

    this.profiles.set(ip, profile);
    this.checkAnomalies(ip, profile);
  }

  private checkAnomalies(ip: string, profile: RequestProfile) {
    const windowMs = profile.lastSeen - profile.firstSeen;
    const requestRate = profile.requestCount / Math.max(windowMs / 1000, 1);

    // Scraping: high rate + many unique endpoints
    if (requestRate > 5 && profile.uniqueEndpoints.size > 50) {
      this.alert('scraping', ip, {
        rate: requestRate, endpoints: profile.uniqueEndpoints.size,
      });
    }

    // Enumeration: high error rate on sequential endpoints
    const errorRate = profile.errorCount / profile.requestCount;
    if (errorRate > 0.8 && profile.requestCount > 20) {
      this.alert('enumeration', ip, {
        errorRate, totalRequests: profile.requestCount,
      });
    }

    // Credential stuffing: many auth failures
    if (profile.errorCount > 10 && errorRate > 0.9) {
      this.alert('credential_stuffing', ip, {
        failedAttempts: profile.errorCount,
      });
    }
  }

  private alert(type: string, ip: string, metadata: Record<string, any>) {
    this.logger.error(`Anomaly detected: ${type}`, { ip, type, ...metadata });
    // Integrate with PagerDuty/Slack/automated blocking here
  }
}
```

---

## PART 7: ALERTING AND RESPONSE

### Security Event Correlation

```typescript
// services/security-events.service.ts
import { Injectable, Logger } from '@nestjs/common';

interface SecurityEvent {
  type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  ip: string;
  userId?: string;
  detail: string;
  timestamp: number;
}

@Injectable()
export class SecurityEventsService {
  private readonly logger = new Logger('SecurityEvents');

  async recordEvent(event: SecurityEvent) {
    // Structured log for SIEM ingestion
    this.logger.warn('security_event', {
      event_type: event.type,
      severity: event.severity,
      source_ip: event.ip,
      user_id: event.userId,
      detail: event.detail,
      timestamp: new Date(event.timestamp).toISOString(),
    });

    // Alert on high/critical
    if (event.severity === 'critical' || event.severity === 'high') {
      await this.sendAlert(event);
    }
  }

  private async sendAlert(event: SecurityEvent) {
    // Slack alert
    await fetch(process.env.SLACK_SECURITY_WEBHOOK, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        text: `*Security Alert* [${event.severity.toUpperCase()}]\nType: ${event.type}\nIP: ${event.ip}\nUser: ${event.userId || 'N/A'}\nDetail: ${event.detail}`,
      }),
    });

    // PagerDuty for critical
    if (event.severity === 'critical') {
      await fetch('https://events.pagerduty.com/v2/enqueue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          routing_key: process.env.PAGERDUTY_ROUTING_KEY,
          event_action: 'trigger',
          payload: {
            summary: `${event.type}: ${event.detail}`,
            severity: 'critical',
            source: event.ip,
            component: 'runtime-security',
          },
        }),
      });
    }
  }
}
```

### Sentry Integration for Security Context

```typescript
// Enrich Sentry errors with security context
import * as Sentry from '@sentry/node';

function enrichWithSecurityContext(req: Request) {
  const securityFlags = (req as any).securityFlags || [];

  if (securityFlags.length > 0) {
    Sentry.setTag('security.flagged', 'true');
    Sentry.setTag('security.threat_type', securityFlags[0].type);
    Sentry.setContext('security', {
      flags: securityFlags.map((f: any) => `${f.type}:${f.severity}`),
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    });
  }
}
```

---

## PART 8: AUTOMATED BLOCKING

### Dynamic IP Blocking with Redis

```typescript
// services/ip-blocker.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { Redis } from 'ioredis';

@Injectable()
export class IpBlockerService {
  private readonly logger = new Logger('IpBlocker');
  private redis: Redis;

  constructor() {
    this.redis = new Redis(process.env.REDIS_URL);
  }

  async blockIp(ip: string, reason: string, durationSeconds: number = 3600) {
    const key = `blocked:${ip}`;
    await this.redis.set(key, JSON.stringify({ reason, blockedAt: Date.now() }), 'EX', durationSeconds);
    this.logger.warn('IP blocked', { ip, reason, duration: durationSeconds });
  }

  async isBlocked(ip: string): Promise<boolean> {
    return (await this.redis.exists(`blocked:${ip}`)) === 1;
  }

  async unblock(ip: string) {
    await this.redis.del(`blocked:${ip}`);
    this.logger.log('IP unblocked', { ip });
  }
}
```

```typescript
// middleware/ip-block.middleware.ts
@Injectable()
export class IpBlockMiddleware implements NestMiddleware {
  constructor(private ipBlocker: IpBlockerService) {}

  async use(req: Request, res: Response, next: NextFunction) {
    if (await this.ipBlocker.isBlocked(req.ip)) {
      res.status(403).json({ error: 'Access denied' });
      return;
    }
    next();
  }
}
```

---

## PART 9: MONITORING STACK DEPLOYMENT

### Docker Compose — Security Monitoring

```yaml
# docker-compose.security.yml
services:
  falco:
    image: falcosecurity/falco:latest
    privileged: true
    volumes:
      - /var/run/docker.sock:/host/var/run/docker.sock
      - /proc:/host/proc:ro
      - /boot:/host/boot:ro
      - /lib/modules:/host/lib/modules:ro
      - ./falco-rules.yaml:/etc/falco/falco_rules.local.yaml
    environment:
      - FALCO_GRPC_ENABLED=true

  falco-sidekick:
    image: falcosecurity/falcosidekick:latest
    environment:
      - SLACK_WEBHOOKURL=${SLACK_SECURITY_WEBHOOK}
      - SLACK_MINIMUMPRIORITY=warning
      - PAGERDUTY_ROUTINGKEY=${PAGERDUTY_ROUTING_KEY}
      - PAGERDUTY_MINIMUMPRIORITY=critical
    depends_on:
      - falco

  waf-dashboard:
    image: grafana/grafana:latest
    ports:
      - "3002:3000"
    volumes:
      - ./grafana/dashboards/security.json:/var/lib/grafana/dashboards/security.json
      - ./grafana/provisioning:/etc/grafana/provisioning
```

---

## Exit Checklist

- [ ] WAF deployed at edge with managed rule sets (SQLi, XSS, common attacks)
- [ ] Custom WAF rules for application-specific patterns
- [ ] Rate limiting configured: global, per-endpoint, and per-user/IP
- [ ] Login endpoint has brute force protection (5 attempts / 15 min window)
- [ ] Threat detection middleware inspects requests for injection patterns
- [ ] Known attack tool user agents blocked (sqlmap, nikto, etc.)
- [ ] Path traversal and command injection patterns detected and blocked
- [ ] Container security context: non-root, read-only rootfs, dropped capabilities
- [ ] Seccomp profile applied to restrict syscalls
- [ ] Falco rules deployed for shell detection, sensitive file reads, unexpected connections
- [ ] API abuse detection tracking scraping, enumeration, and credential stuffing
- [ ] Security events logged in structured format for SIEM ingestion
- [ ] Alerting configured: Slack for high severity, PagerDuty for critical
- [ ] Security context enriched in error tracking (Sentry tags)
- [ ] Dynamic IP blocking with Redis and auto-expiry
- [ ] fail2ban configured for repeat offenders at OS level
