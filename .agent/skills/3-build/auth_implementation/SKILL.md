---
name: auth_implementation
description: Authentication and authorization patterns including JWT, RBAC, OAuth, and session management
---

# Auth Implementation Skill

**Purpose**: Implement secure authentication and authorization for NestJS applications — from JWT flows to RBAC to OAuth integration.

## 🎯 TRIGGER COMMANDS

```text
"Set up authentication for [project]"
"Implement JWT auth"
"Add role-based access control"
"Set up OAuth login (Google/GitHub)"
"Implement refresh token rotation"
"Add MFA/2FA"
"Using auth_implementation skill"
```

## When to Use

- Setting up authentication for a new project
- Adding JWT with refresh tokens
- Implementing role-based access control (RBAC)
- Integrating OAuth providers (Google, GitHub)
- Adding multi-factor authentication (MFA)
- Reviewing auth security

---

## PART 1: JWT FLOW

```
Login Flow:
  Client sends { email, password }
    → Server validates credentials (bcrypt.compare)
      → Server generates access token (15min) + refresh token (7d)
        → Server stores refresh token hash in DB
          → Server returns both tokens to client

Authenticated Request:
  Client sends request with Authorization: Bearer <access_token>
    → JwtAuthGuard extracts token from header
      → JwtStrategy validates signature + expiry
        → Payload { sub, email } attached to request.user
          → Controller handles request with @CurrentUser()

Token Refresh:
  Client sends { refreshToken }
    → Server verifies refresh token exists in DB + not expired
      → Server generates NEW access + refresh tokens
        → Server invalidates OLD refresh token (rotation)
          → Server returns new tokens
```

---

## PART 2: CORE IMPLEMENTATION

### JWT Strategy

```typescript
// auth/jwt.strategy.ts
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private config: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
  }

  async validate(payload: { sub: string; email: string; role: string }) {
    return { sub: payload.sub, email: payload.email, role: payload.role };
  }
}
```

### Auth Guard

```typescript
// auth/jwt-auth.guard.ts
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
```

### Current User Decorator

```typescript
// auth/user.decorator.ts
export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);
```

### Auth Service

```typescript
@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private config: ConfigService,
  ) {}

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user || !(await bcrypt.compare(dto.password, user.password))) {
      throw new UnauthorizedException('Invalid credentials');
      // Generic message — don't reveal if email exists
    }

    const tokens = await this.generateTokens(user);
    await this.saveRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async refreshTokens(refreshToken: string) {
    const decoded = this.jwtService.verify(refreshToken, {
      secret: this.config.get('JWT_REFRESH_SECRET'),
    });

    const stored = await this.prisma.refreshToken.findFirst({
      where: { userId: decoded.sub, token: refreshToken, revoked: false },
    });

    if (!stored) throw new UnauthorizedException('Invalid refresh token');

    // Rotate: revoke old, issue new
    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revoked: true },
    });

    const user = await this.prisma.user.findUnique({ where: { id: decoded.sub } });
    const tokens = await this.generateTokens(user);
    await this.saveRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  private async generateTokens(user: User) {
    const payload = { sub: user.id, email: user.email, role: user.role };
    return {
      accessToken: this.jwtService.sign(payload, { expiresIn: '15m' }),
      refreshToken: this.jwtService.sign(payload, {
        secret: this.config.get('JWT_REFRESH_SECRET'),
        expiresIn: '7d',
      }),
    };
  }
}
```

---

## PART 3: RBAC (Role-Based Access Control)

### Roles Decorator

```typescript
// auth/roles.decorator.ts
export const ROLES_KEY = 'roles';
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);
```

### Roles Guard

```typescript
// auth/roles.guard.ts
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<Role[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) return true; // No roles required

    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.includes(user.role);
  }
}
```

### Usage

```typescript
@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AdminController {
  @Get('users')
  @Roles(Role.ADMIN, Role.SUPER_ADMIN)
  async getAllUsers() {
    return this.usersService.findAll();
  }

  @Delete('users/:id')
  @Roles(Role.SUPER_ADMIN)
  async deleteUser(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
```

---

## PART 4: OAUTH (GOOGLE/GITHUB)

### Google OAuth Strategy

```typescript
// auth/google.strategy.ts
@Injectable()
export class GoogleStrategy extends PassportStrategy(Strategy, 'google') {
  constructor(private config: ConfigService) {
    super({
      clientID: config.get('GOOGLE_CLIENT_ID'),
      clientSecret: config.get('GOOGLE_CLIENT_SECRET'),
      callbackURL: config.get('GOOGLE_CALLBACK_URL'),
      scope: ['email', 'profile'],
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    return {
      email: profile.emails[0].value,
      name: profile.displayName,
      picture: profile.photos[0]?.value,
      provider: 'google',
      providerId: profile.id,
    };
  }
}

// Controller
@Get('google')
@UseGuards(AuthGuard('google'))
async googleLogin() {} // Redirects to Google

@Get('google/callback')
@UseGuards(AuthGuard('google'))
async googleCallback(@Req() req) {
  // req.user is the profile from GoogleStrategy.validate()
  const user = await this.authService.findOrCreateOAuthUser(req.user);
  const tokens = await this.authService.generateTokens(user);
  // Redirect to frontend with tokens
  return res.redirect(`${frontendUrl}/auth/callback?token=${tokens.accessToken}`);
}
```

---

## PART 5: PASSWORD SECURITY

```typescript
// Registration — hash the password
async register(dto: RegisterDto) {
  const salt = await bcrypt.genSalt(12); // 12 rounds minimum
  const hashedPassword = await bcrypt.hash(dto.password, salt);

  return this.prisma.user.create({
    data: {
      email: dto.email,
      name: dto.name,
      password: hashedPassword,
    },
  });
}

// Login — compare password
async validateUser(email: string, password: string) {
  const user = await this.prisma.user.findUnique({ where: { email } });
  if (!user) return null;

  const isValid = await bcrypt.compare(password, user.password);
  if (!isValid) return null;

  return user;
}
```

### Password Policy DTO

```typescript
class RegisterDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  @Matches(/[A-Z]/, { message: 'Must contain at least one uppercase letter' })
  @Matches(/[a-z]/, { message: 'Must contain at least one lowercase letter' })
  @Matches(/[0-9]/, { message: 'Must contain at least one number' })
  password: string;
}
```

---

## PART 6: TOKEN STORAGE

### Frontend Token Storage Options

| Method | XSS Safe? | CSRF Safe? | Best For |
|--------|-----------|-----------|----------|
| httpOnly Cookie | Yes | Needs CSRF token | Web apps (most secure) |
| localStorage | No (JS can read) | Yes | Quick start (less secure) |
| sessionStorage | No (JS can read) | Yes | Temporary sessions |
| Memory (variable) | Yes | Yes | Most secure but lost on refresh |

### Recommended: httpOnly Cookies

```typescript
// Backend — set cookie on login
@Post('login')
async login(@Body() dto: LoginDto, @Res() res: Response) {
  const tokens = await this.authService.login(dto);

  res.cookie('access_token', tokens.accessToken, {
    httpOnly: true,      // JavaScript can't read it
    secure: true,        // HTTPS only
    sameSite: 'strict',  // CSRF protection
    maxAge: 15 * 60 * 1000, // 15 minutes
  });

  res.cookie('refresh_token', tokens.refreshToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    path: '/api/auth/refresh', // Only sent to refresh endpoint
  });

  return res.json({ success: true });
}
```

---

## PART 7: SECURITY CHECKLIST

```
Authentication:
[ ] Passwords hashed with bcrypt (12+ rounds) or argon2
[ ] Generic login error messages ("Invalid credentials")
[ ] Rate limiting on login (5 attempts per minute)
[ ] Account lockout after N failed attempts
[ ] JWT expiration enforced (15min access, 7d refresh)
[ ] Refresh token rotation (old token revoked on use)

Authorization:
[ ] RBAC enforced server-side (not just frontend)
[ ] Every endpoint checks user ownership of resources
[ ] Admin endpoints have explicit role checks
[ ] API endpoints protected by default (opt-out public, not opt-in auth)

Token Security:
[ ] JWT secret is strong (256+ bit) and in env vars
[ ] Refresh tokens stored hashed in database
[ ] Tokens don't contain sensitive data (no passwords, no PII)
[ ] Logout invalidates refresh tokens
```

---

## ✅ Exit Checklist

- [ ] JWT authentication working (login, access token, refresh token)
- [ ] Refresh token rotation implemented
- [ ] Passwords hashed with bcrypt (12+ rounds)
- [ ] RBAC guards enforced on admin endpoints
- [ ] Generic error messages for login failures
- [ ] Rate limiting on auth endpoints
- [ ] Token storage follows security best practices
- [ ] OAuth integration working (if required)
