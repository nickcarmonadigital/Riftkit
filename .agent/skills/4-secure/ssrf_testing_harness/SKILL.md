---
name: SSRF Testing Harness
description: Comprehensive Server-Side Request Forgery testing methodology covering attack taxonomy, cloud metadata protection, DNS rebinding, redirect chains, and framework-specific mitigations
---

# SSRF Testing Harness Skill

**Purpose**: Systematically test for Server-Side Request Forgery (SSRF) vulnerabilities across all attack vectors. Covers basic, blind, and partial SSRF with cloud-specific, framework-specific, and protocol-specific test cases.

---

## TRIGGER COMMANDS

```text
"Test for SSRF in [feature]"
"SSRF audit for [endpoint]"
"Check URL validation in [service]"
"Cloud metadata protection test"
"Using ssrf_testing_harness skill: test [feature]"
```

---

## SSRF ATTACK TAXONOMY

```text
SSRF Attack Types:

  BASIC SSRF                BLIND SSRF              PARTIAL SSRF
  Server fetches            Server fetches           Attacker controls
  attacker-chosen URL       URL but response         part of the URL
  and returns response      is not returned          (path, query, fragment)
       |                         |                        |
       v                         v                        v
  Read internal             Detect via timing,       Path traversal,
  resources, scan           DNS lookups, or          parameter injection,
  ports, access             out-of-band callbacks    open redirect chaining
  cloud metadata
```

### Where SSRF Occurs

| Feature | SSRF Vector | Risk |
|---------|-------------|------|
| URL preview / link unfurling | User-supplied URL fetched server-side | High |
| Webhook delivery | User configures callback URL | High |
| File import from URL | User provides file URL to download | High |
| PDF/image generation | URL rendered server-side (wkhtmltopdf, Puppeteer) | High |
| OAuth callback URLs | Redirect URI manipulation | Medium |
| RSS/feed parsing | Feed URL fetched server-side | Medium |
| API proxy / gateway | Forwarding requests to user-specified backend | High |
| Avatar/image URL | Profile picture from URL | Medium |
| Health check endpoints | Internal service URL probing | Low |

---

## URL VALIDATION TESTING

### Schema Validation

| Test Case | Input | Expected | Status |
|-----------|-------|----------|--------|
| HTTP allowed | http://example.com | Depends on policy | [ ] |
| HTTPS required | https://example.com | 200 | [ ] |
| file:// schema | file:///etc/passwd | 400 blocked | [ ] |
| gopher:// schema | gopher://internal:25/ | 400 blocked | [ ] |
| dict:// schema | dict://internal:11211/ | 400 blocked | [ ] |
| ftp:// schema | ftp://internal/file | 400 blocked | [ ] |
| data:// schema | data:text/html,<script>x</script> | 400 blocked | [ ] |
| jar:// schema | jar:http://evil.com/file.jar!/path | 400 blocked | [ ] |
| No schema | //evil.com/path | 400 blocked | [ ] |
| Mixed case schema | hTtP://evil.com | Normalized and validated | [ ] |
| Null bytes in URL | http://evil.com%00.internal.com | 400 blocked | [ ] |

### IP Address Bypass Techniques

| Test Case | Input | Resolves To | Status |
|-----------|-------|-------------|--------|
| Standard loopback | http://127.0.0.1 | localhost | [ ] |
| Shortened loopback | http://127.1 | localhost | [ ] |
| Hex loopback | http://0x7f000001 | 127.0.0.1 | [ ] |
| Octal loopback | http://0177.0.0.1 | 127.0.0.1 | [ ] |
| Decimal loopback | http://2130706433 | 127.0.0.1 | [ ] |
| IPv6 loopback | http://[::1] | localhost | [ ] |
| IPv6 mapped IPv4 | http://[::ffff:127.0.0.1] | 127.0.0.1 | [ ] |
| IPv6 shorthand | http://[0:0:0:0:0:0:0:1] | localhost | [ ] |
| Zero address | http://0.0.0.0 | localhost | [ ] |
| CNAME to localhost | http://localtest.me | 127.0.0.1 | [ ] |
| Private range 10.x | http://10.0.0.1 | Internal | [ ] |
| Private range 172.16.x | http://172.16.0.1 | Internal | [ ] |
| Private range 192.168.x | http://192.168.1.1 | Internal | [ ] |
| Link-local | http://169.254.169.254 | Cloud metadata | [ ] |
| URL with credentials | http://user:pass@127.0.0.1 | localhost | [ ] |
| Domain with internal IP | http://internal.attacker.com | Resolves to 10.x | [ ] |

### IP Validation Remediation

```typescript
import { isIP } from 'net';
import { lookup } from 'dns/promises';

async function isUrlSafe(urlString: string): Promise<boolean> {
  let parsed: URL;
  try {
    parsed = new URL(urlString);
  } catch {
    return false;
  }

  // Schema whitelist
  if (!['http:', 'https:'].includes(parsed.protocol)) return false;

  // Block credentials in URL
  if (parsed.username || parsed.password) return false;

  // Resolve hostname to IP and validate
  const hostname = parsed.hostname.replace(/[\[\]]/g, ''); // Strip IPv6 brackets

  let ip: string;
  if (isIP(hostname)) {
    ip = hostname;
  } else {
    try {
      const result = await lookup(hostname);
      ip = result.address;
    } catch {
      return false;
    }
  }

  return !isPrivateOrReservedIP(ip);
}

function isPrivateOrReservedIP(ip: string): boolean {
  // IPv4 checks
  const parts = ip.split('.').map(Number);
  if (parts.length === 4) {
    if (parts[0] === 127) return true;                              // Loopback
    if (parts[0] === 10) return true;                               // 10.0.0.0/8
    if (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) return true; // 172.16.0.0/12
    if (parts[0] === 192 && parts[1] === 168) return true;         // 192.168.0.0/16
    if (parts[0] === 169 && parts[1] === 254) return true;         // Link-local
    if (parts[0] === 0) return true;                                // 0.0.0.0/8
    if (parts[0] === 100 && parts[1] >= 64 && parts[1] <= 127) return true; // CGNAT
  }

  // IPv6 checks
  if (ip === '::1') return true;                                    // Loopback
  if (ip.startsWith('fe80:')) return true;                          // Link-local
  if (ip.startsWith('fc') || ip.startsWith('fd')) return true;     // Unique local
  if (ip.startsWith('::ffff:')) {                                   // Mapped IPv4
    const mapped = ip.slice(7);
    if (isIP(mapped) === 4) return isPrivateOrReservedIP(mapped);
  }

  return false;
}
```

---

## CLOUD METADATA SERVICE PROTECTION

### AWS IMDSv1 / IMDSv2

| Test Case | Input | Expected | Status |
|-----------|-------|----------|--------|
| IMDSv1 direct | http://169.254.169.254/latest/meta-data/ | Blocked | [ ] |
| IMDSv1 credentials | http://169.254.169.254/latest/meta-data/iam/security-credentials/ | Blocked | [ ] |
| IMDSv1 user-data | http://169.254.169.254/latest/user-data | Blocked | [ ] |
| IPv6 metadata | http://[fd00:ec2::254]/latest/meta-data/ | Blocked | [ ] |
| DNS alias for metadata IP | http://metadata.attacker.com (A: 169.254.169.254) | Blocked | [ ] |
| Redirect to metadata | http://evil.com -> 302 -> http://169.254.169.254/ | Blocked | [ ] |

**AWS IMDSv2 enforcement** (infrastructure-level mitigation):

```bash
# Enforce IMDSv2 (requires token, blocks SSRF via 1-hop TTL)
aws ec2 modify-instance-metadata-options \
  --instance-id i-1234567890abcdef0 \
  --http-tokens required \
  --http-put-response-hop-limit 1 \
  --http-endpoint enabled
```

### GCP Metadata

| Test Case | Input | Expected | Status |
|-----------|-------|----------|--------|
| GCP metadata | http://metadata.google.internal/computeMetadata/v1/ | Blocked | [ ] |
| GCP without header | Above without Metadata-Flavor: Google | 403 (GCP-side) | [ ] |
| GCP service account token | http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token | Blocked | [ ] |
| GCP alternate IP | http://169.254.169.254/computeMetadata/v1/ | Blocked | [ ] |

**GCP requires `Metadata-Flavor: Google` header** — SSRF without custom headers is partially mitigated, but application-level blocking is still required.

### Azure IMDS

| Test Case | Input | Expected | Status |
|-----------|-------|----------|--------|
| Azure metadata | http://169.254.169.254/metadata/instance?api-version=2021-02-01 | Blocked | [ ] |
| Azure identity token | http://169.254.169.254/metadata/identity/oauth2/token | Blocked | [ ] |
| Azure without header | Above without Metadata: true | 400 (Azure-side) | [ ] |

### Cloud Metadata Remediation

```text
Defense in Depth:
1. Application layer: Block all requests to 169.254.169.254 and metadata hostnames
2. DNS layer: Block DNS resolution to link-local addresses
3. Network layer: iptables/firewall rules blocking metadata IP from application containers
4. Cloud layer: Enforce IMDSv2 (AWS), require headers (GCP/Azure)
5. Container layer: Use network policies to block metadata access from pods
```

```bash
# iptables rule to block metadata access from application user
iptables -A OUTPUT -m owner --uid-owner appuser -d 169.254.169.254 -j DROP

# Kubernetes NetworkPolicy to block metadata
# apiVersion: networking.k8s.io/v1
# kind: NetworkPolicy
# spec:
#   egress:
#   - to:
#     - ipBlock:
#         cidr: 0.0.0.0/0
#         except:
#         - 169.254.169.254/32
```

---

## DNS REBINDING DETECTION AND PREVENTION

### How DNS Rebinding Works

```text
Attack Flow:
1. Attacker controls evil.com DNS
2. First DNS query: evil.com -> 1.2.3.4 (attacker IP) — passes validation
3. Application validates URL (not internal IP — safe)
4. DNS TTL expires (attacker sets TTL=0)
5. Second DNS query (actual fetch): evil.com -> 127.0.0.1 — resolves to internal
6. Application fetches http://evil.com which now hits localhost
```

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Zero TTL domain | Domain with TTL=0, changes IP between resolve/fetch | Blocked | [ ] |
| Multiple A records (one internal) | Domain with A: 1.2.3.4, A: 127.0.0.1 | Blocked | [ ] |
| CNAME chain to internal | evil.com CNAME -> internal.corp | Blocked | [ ] |
| Time-of-check-to-time-of-use | Validate IP, delay, IP changes | Blocked | [ ] |

### Remediation: Resolve-then-Fetch Pattern

```typescript
import { lookup } from 'dns/promises';
import http from 'http';
import https from 'https';

async function safeFetch(urlString: string): Promise<Response> {
  const parsed = new URL(urlString);

  // Step 1: Resolve DNS ourselves
  const { address } = await lookup(parsed.hostname);

  // Step 2: Validate resolved IP (not the hostname)
  if (isPrivateOrReservedIP(address)) {
    throw new Error(`Blocked: ${parsed.hostname} resolves to private IP ${address}`);
  }

  // Step 3: Fetch using the resolved IP directly (pinned DNS)
  // This prevents DNS rebinding between validation and fetch
  const agent = parsed.protocol === 'https:'
    ? new https.Agent({ lookup: (_host, _opts, cb) => cb(null, address, 4) })
    : new http.Agent({ lookup: (_host, _opts, cb) => cb(null, address, 4) });

  return fetch(urlString, {
    signal: AbortSignal.timeout(10000),
    redirect: 'manual',  // Do not follow redirects automatically
    // @ts-ignore — Node.js fetch supports agent via dispatcher
    dispatcher: agent,
  });
}
```

---

## REDIRECT-BASED SSRF TESTING

### Test Matrix

| Test Case | Input | Expected | Status |
|-----------|-------|----------|--------|
| 302 redirect to localhost | http://evil.com -> 302 -> http://127.0.0.1 | Blocked | [ ] |
| 307 redirect to metadata | http://evil.com -> 307 -> http://169.254.169.254 | Blocked | [ ] |
| Redirect chain (3 hops) | A -> B -> C -> internal | Blocked at any hop | [ ] |
| Redirect to file:// | http://evil.com -> 302 -> file:///etc/passwd | Blocked | [ ] |
| Redirect to different schema | http://evil.com -> 302 -> gopher://internal | Blocked | [ ] |
| Meta refresh redirect | HTML with meta refresh to internal | Blocked (if HTML rendered) | [ ] |
| JavaScript redirect | HTML with window.location to internal | Blocked (if JS executed) | [ ] |
| Redirect with credentials | 302 -> http://user:pass@internal/ | Blocked | [ ] |

### Remediation: Redirect Handling

```typescript
async function safeFetchWithRedirects(urlString: string, maxRedirects = 3): Promise<Response> {
  let currentUrl = urlString;

  for (let i = 0; i <= maxRedirects; i++) {
    // Validate EVERY URL in the redirect chain
    const parsed = new URL(currentUrl);
    const { address } = await lookup(parsed.hostname);

    if (isPrivateOrReservedIP(address)) {
      throw new Error(`Blocked redirect to private IP: ${currentUrl} -> ${address}`);
    }

    if (!['http:', 'https:'].includes(parsed.protocol)) {
      throw new Error(`Blocked redirect to disallowed schema: ${parsed.protocol}`);
    }

    const response = await fetch(currentUrl, {
      redirect: 'manual',
      signal: AbortSignal.timeout(10000),
    });

    if ([301, 302, 303, 307, 308].includes(response.status)) {
      const location = response.headers.get('location');
      if (!location) throw new Error('Redirect without Location header');
      currentUrl = new URL(location, currentUrl).toString();
      continue;
    }

    return response;
  }

  throw new Error(`Too many redirects (max ${maxRedirects})`);
}
```

---

## OUTBOUND REQUEST ALLOWLIST TESTING

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Allowed domain | http://api.allowed-partner.com | 200 | [ ] |
| Disallowed domain | http://evil.com | 400 blocked | [ ] |
| Subdomain of allowed | http://evil.allowed-partner.com | Policy-dependent | [ ] |
| Allowed domain, non-standard port | http://allowed-partner.com:8080 | Policy-dependent | [ ] |
| IP address of allowed domain | http://93.184.216.34 (example.com IP) | Blocked (use domain) | [ ] |
| Wildcard subdomain bypass | http://allowed-partner.com.evil.com | Blocked | [ ] |

### Allowlist Implementation

```typescript
const ALLOWED_OUTBOUND_DOMAINS = new Set([
  'api.stripe.com',
  'api.sendgrid.com',
  'hooks.slack.com',
]);

function isDomainAllowed(hostname: string): boolean {
  // Exact match only — no subdomain wildcards unless explicitly needed
  return ALLOWED_OUTBOUND_DOMAINS.has(hostname.toLowerCase());
}

// For subdomain support:
function isDomainAllowedWithSubdomains(hostname: string, allowedDomains: string[]): boolean {
  const lower = hostname.toLowerCase();
  return allowedDomains.some(domain => {
    return lower === domain || lower.endsWith('.' + domain);
  });
}
```

---

## INTERNAL NETWORK ENUMERATION PREVENTION

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Port scanning via SSRF | http://127.0.0.1:{1-65535} | All blocked (same error) | [ ] |
| Internal service discovery | http://elasticsearch:9200 | Blocked | [ ] |
| Docker socket | http://127.0.0.1:2375/containers/json | Blocked | [ ] |
| Kubernetes API | https://kubernetes.default.svc | Blocked | [ ] |
| Redis | http://127.0.0.1:6379 | Blocked | [ ] |
| Internal hostname guessing | http://db, http://cache, http://queue | All blocked | [ ] |

### Remediation

```text
[ ] All private/reserved IPs blocked at application level
[ ] DNS resolution restricted to public IPs for user-supplied URLs
[ ] Error messages do not reveal internal network topology
[ ] Connection errors return generic "could not fetch URL" (no port-open vs port-closed distinction)
[ ] Internal services not reachable from application network segment (network segmentation)
[ ] Docker socket not mounted in application containers
```

---

## NESTJS-SPECIFIC PATTERNS

### HttpService/Axios Interceptor for SSRF Prevention

```typescript
import { Injectable, OnModuleInit } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { lookup } from 'dns/promises';

@Injectable()
export class SsrfGuardService implements OnModuleInit {
  constructor(private readonly httpService: HttpService) {}

  onModuleInit() {
    this.httpService.axiosRef.interceptors.request.use(async (config) => {
      const url = new URL(config.url, config.baseURL);

      // Schema check
      if (!['http:', 'https:'].includes(url.protocol)) {
        throw new Error(`Blocked schema: ${url.protocol}`);
      }

      // Resolve and validate IP
      const { address } = await lookup(url.hostname);
      if (this.isPrivateIP(address)) {
        throw new Error(`Blocked: ${url.hostname} resolves to private IP`);
      }

      // Disable redirect following — handle manually if needed
      config.maxRedirects = 0;

      // Set timeout
      config.timeout = config.timeout || 10000;

      // Set max response size
      config.maxContentLength = config.maxContentLength || 5 * 1024 * 1024;

      return config;
    });
  }

  private isPrivateIP(ip: string): boolean {
    const parts = ip.split('.').map(Number);
    if (parts.length === 4) {
      if (parts[0] === 127) return true;
      if (parts[0] === 10) return true;
      if (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) return true;
      if (parts[0] === 192 && parts[1] === 168) return true;
      if (parts[0] === 169 && parts[1] === 254) return true;
      if (parts[0] === 0) return true;
    }
    if (ip === '::1' || ip.startsWith('fe80:') || ip.startsWith('fc') || ip.startsWith('fd')) {
      return true;
    }
    return false;
  }
}
```

### NestJS Module Integration

```typescript
import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { SsrfGuardService } from './ssrf-guard.service';

@Module({
  imports: [HttpModule],
  providers: [SsrfGuardService],
  exports: [HttpModule, SsrfGuardService],
})
export class SafeHttpModule {}

// Usage: import SafeHttpModule instead of HttpModule in feature modules
// All outbound requests automatically validated against SSRF
```

---

## DJANGO-SPECIFIC PATTERNS

### Requests Library URL Validation

```python
import ipaddress
import socket
from urllib.parse import urlparse

import requests

BLOCKED_SCHEMES = {'file', 'ftp', 'gopher', 'dict', 'data', 'jar'}

def safe_fetch(url: str, timeout: int = 10, max_redirects: int = 3) -> requests.Response:
    """Fetch URL with SSRF protection."""
    _validate_url(url)

    session = requests.Session()
    session.max_redirects = max_redirects

    # Override resolve to pin DNS and validate each redirect
    original_send = session.send
    def safe_send(prepared, **kwargs):
        _validate_url(prepared.url)
        kwargs['allow_redirects'] = False
        kwargs['timeout'] = timeout
        return original_send(prepared, **kwargs)
    session.send = safe_send

    # Manual redirect following with validation
    response = session.get(url, allow_redirects=False, timeout=timeout)
    redirects = 0
    while response.is_redirect and redirects < max_redirects:
        next_url = response.headers.get('Location')
        if not next_url:
            break
        # Resolve relative URLs
        next_url = requests.compat.urljoin(response.url, next_url)
        _validate_url(next_url)
        response = session.get(next_url, allow_redirects=False, timeout=timeout)
        redirects += 1

    return response


def _validate_url(url: str) -> None:
    """Validate URL is not targeting internal resources."""
    parsed = urlparse(url)

    if parsed.scheme.lower() in BLOCKED_SCHEMES:
        raise ValueError(f"Blocked scheme: {parsed.scheme}")

    if not parsed.scheme or parsed.scheme.lower() not in ('http', 'https'):
        raise ValueError(f"Only HTTP(S) allowed, got: {parsed.scheme}")

    if parsed.username or parsed.password:
        raise ValueError("URLs with credentials are not allowed")

    hostname = parsed.hostname
    if not hostname:
        raise ValueError("No hostname in URL")

    # Resolve hostname to IP
    try:
        addr_info = socket.getaddrinfo(hostname, parsed.port or 443)
    except socket.gaierror:
        raise ValueError(f"Cannot resolve hostname: {hostname}")

    for family, _type, _proto, _canonname, sockaddr in addr_info:
        ip = ipaddress.ip_address(sockaddr[0])
        if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved:
            raise ValueError(f"Blocked: {hostname} resolves to private/reserved IP {ip}")
```

### Django Middleware Pattern

```python
# middleware/ssrf_guard.py
from django.conf import settings

SSRF_PROTECTED_VIEWS = getattr(settings, 'SSRF_PROTECTED_VIEWS', [])

class SSRFGuardMiddleware:
    """Log and monitor outbound requests from views handling user-supplied URLs."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

# settings.py
SSRF_PROTECTED_VIEWS = [
    'webhooks.views.test_webhook',
    'integrations.views.fetch_url',
    'imports.views.import_from_url',
]
```

---

## TESTING TOOLS AND CANARY PATTERNS

### Burp Suite Collaborator Patterns

```text
For blind SSRF detection where response is not returned:

1. Use Burp Collaborator or interactsh to generate unique callback URLs
2. Inject callback URL into SSRF vectors
3. Monitor for HTTP/DNS callbacks from the target server

Example:
  POST /api/fetch-preview
  {"url": "http://uniqueid.burpcollaborator.net"}

If Collaborator receives a request, SSRF is confirmed even if the
application returns a generic error.
```

### Custom Canary Server

```python
# Simple canary server for SSRF detection
# Run on an external server you control

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
from datetime import datetime

class CanaryHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Log the request — this proves SSRF if hit from target
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'client_ip': self.client_address[0],
            'method': 'GET',
            'path': self.path,
            'headers': dict(self.headers),
        }
        with open('canary_log.jsonl', 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
        print(f"[CANARY HIT] {self.client_address[0]} -> {self.path}")

        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'canary')

    do_POST = do_GET
    do_PUT = do_GET

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8888), CanaryHandler)
    print("Canary server running on :8888")
    server.serve_forever()
```

### Redirect Chain Server (for redirect-based SSRF testing)

```python
# Test server that redirects to internal addresses
# Use ONLY in authorized testing environments

from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

class RedirectHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # /redirect?to=http://169.254.169.254/latest/meta-data/
        params = parse_qs(urlparse(self.path).query)
        target = params.get('to', [None])[0]

        if target:
            self.send_response(302)
            self.send_header('Location', target)
            self.end_headers()
        else:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Use /redirect?to=<url>')

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8889), RedirectHandler)
    print("Redirect server running on :8889")
    server.serve_forever()
```

---

## OUTPUT: SSRF TEST MATRIX

After running this skill, create: `.agent/docs/4-secure/ssrf-test-matrix-[date].md`

```markdown
# SSRF Test Matrix

**Date**: [Date]
**Service**: [Service Name]
**Tester**: [Agent/Human]
**Scope**: [Endpoints that accept URLs or make outbound requests]

## Attack Surface

| Feature | Endpoint | Accepts URL | Makes Outbound Request | Status |
|---------|----------|-------------|----------------------|--------|
| URL Preview | POST /api/preview | Yes | Yes | [ ] |
| Webhook Config | POST /api/webhooks | Yes | Yes (async) | [ ] |
| File Import | POST /api/import | Yes | Yes | [ ] |
| Avatar Upload | PUT /api/users/avatar | URL optional | Conditional | [ ] |

## Test Results by Category

### URL Validation
| Test | Result | Notes |
|------|--------|-------|
| Schema validation (file://, gopher://) | | |
| IP blocklist (loopback, private, link-local) | | |
| IP encoding bypasses (hex, octal, decimal) | | |
| IPv6 bypasses (::1, ::ffff:127.0.0.1) | | |
| Null byte injection | | |
| Credentials in URL | | |

### Cloud Metadata
| Test | Result | Notes |
|------|--------|-------|
| AWS IMDSv1 (169.254.169.254) | | |
| AWS IMDSv2 enforcement | | |
| GCP metadata.google.internal | | |
| Azure IMDS | | |
| DNS alias to metadata IP | | |

### DNS Rebinding
| Test | Result | Notes |
|------|--------|-------|
| Zero-TTL domain | | |
| Multiple A records | | |
| TOCTOU gap exploitable | | |

### Redirect Chains
| Test | Result | Notes |
|------|--------|-------|
| 302 to internal IP | | |
| 307 to metadata service | | |
| Multi-hop redirect chain | | |
| Redirect to different schema | | |

### Internal Network
| Test | Result | Notes |
|------|--------|-------|
| Port scanning via SSRF | | |
| Internal hostname resolution | | |
| Docker/K8s API access | | |
| Error message information leak | | |

## Findings

### [SSRF-001] [Title]
- **Type**: Basic / Blind / Partial
- **Endpoint**: [METHOD /path]
- **Severity**: Critical / High / Medium / Low
- **Bypass Method**: [How the filter was bypassed]
- **Impact**: [What internal resources were accessible]
- **Reproduction**:
  ```bash
  curl -X POST https://target/api/preview \
    -H "Content-Type: application/json" \
    -d '{"url": "[payload]"}'
  ```
- **Remediation**: [Specific fix]

## Remediation Summary

| Defense Layer | Implemented | Notes |
|---------------|-------------|-------|
| URL schema whitelist (HTTP/HTTPS only) | [ ] | |
| DNS resolution to IP validation | [ ] | |
| Private/reserved IP blocklist | [ ] | |
| DNS pinning (resolve-then-fetch) | [ ] | |
| Redirect validation at each hop | [ ] | |
| Cloud metadata IP blocked | [ ] | |
| IMDSv2 enforced (AWS) | [ ] | |
| Network segmentation | [ ] | |
| Outbound request allowlist | [ ] | |
| Response size limits | [ ] | |
| Request timeouts | [ ] | |
```

---

## EXIT CHECKLIST

- [ ] All URL-accepting endpoints identified and cataloged
- [ ] URL schema validation tested (blocked: file, gopher, dict, ftp, data)
- [ ] IP address bypass techniques tested (hex, octal, decimal, IPv6)
- [ ] Cloud metadata endpoints blocked (AWS, GCP, Azure)
- [ ] IMDSv2 enforcement verified (AWS environments)
- [ ] DNS rebinding protection tested (resolve-then-fetch pattern)
- [ ] Redirect chain handling tested (validation at each hop)
- [ ] Outbound request allowlist tested (if implemented)
- [ ] Internal network enumeration prevention verified
- [ ] Error messages checked for information leakage
- [ ] Framework-specific SSRF guards implemented (NestJS/Django)
- [ ] Blind SSRF tested with out-of-band detection (Collaborator/canary)
- [ ] SSRF Test Matrix document generated with all findings
- [ ] Remediation plan created with defense-in-depth layers

---

*Skill Version: 1.0 | Created: March 2026 | Cross-references: api_security_testing (API7), security_audit*
