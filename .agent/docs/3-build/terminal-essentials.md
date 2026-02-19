# Terminal Essentials

> **The terminal is your power tool.** GUI tools are limited by what buttons someone put on the screen. The terminal is limited only by what you can type.

---

## Navigation & File Operations

```bash
# Navigation
pwd                         # Print working directory
ls                          # List files
ls -la                      # List ALL files (including hidden) with details
cd /path/to/dir             # Change directory
cd ..                       # Go up one level
cd -                        # Go back to previous directory
cd ~                        # Go to home directory

# File operations
mkdir -p src/components/ui  # Create nested directories (-p creates parents)
touch src/utils/helpers.ts  # Create empty file
cp file.ts backup.ts        # Copy file
cp -r src/ src-backup/      # Copy directory recursively
mv old.ts new.ts            # Rename/move file
rm file.ts                  # Delete file
rm -rf dist/                # Delete directory recursively (CAREFUL!)

# File permissions
chmod +x script.sh          # Make file executable
chmod 600 .env              # Owner read/write only (secrets)
chown user:group file       # Change file owner

# Symlinks
ln -s /path/to/target link  # Create symbolic link
```

---

## Process Management

```bash
# View processes
ps aux                      # List all running processes
ps aux | grep node          # Find Node.js processes
top                         # Live process monitor (q to quit)
htop                        # Better process monitor (if installed)

# Kill processes
kill <PID>                  # Graceful shutdown (SIGTERM)
kill -9 <PID>               # Force kill (SIGKILL) — use as last resort

# Port conflicts (most common issue)
lsof -i :3000               # What's using port 3000?
kill $(lsof -t -i:3000)     # Kill whatever is using port 3000
npx kill-port 3000          # npm alternative

# Background processes
node server.js &            # Run in background
nohup node server.js &      # Run in background, survives terminal close
jobs                        # List background jobs
fg %1                       # Bring job 1 to foreground
```

---

## Pipes & Redirection

```bash
# Pipes (send output of one command to another)
cat file.txt | grep "error"      # Find lines containing "error"
ps aux | grep node | wc -l       # Count Node processes
ls -la | sort -k5 -n             # Sort files by size

# Redirection
echo "hello" > file.txt          # Write to file (overwrites)
echo "world" >> file.txt         # Append to file
command 2> error.log             # Redirect errors to file
command > out.log 2>&1           # Redirect both stdout and stderr
command > /dev/null 2>&1         # Discard all output

# Useful combinations
tee output.log                   # Write to file AND display on screen
xargs                           # Convert input to arguments
find src -name "*.ts" | xargs wc -l  # Count lines in all .ts files
```

---

## SSH Essentials

```bash
# Generate SSH key (for GitHub, servers, etc.)
ssh-keygen -t ed25519 -C "your@email.com"
# Keys are saved to ~/.ssh/id_ed25519 (private) and ~/.ssh/id_ed25519.pub (public)

# Add key to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# SSH config file (~/.ssh/config) — saves typing
Host myserver
    HostName 192.168.1.100
    User deploy
    Port 22
    IdentityFile ~/.ssh/id_ed25519

# Now instead of:  ssh deploy@192.168.1.100 -i ~/.ssh/id_ed25519
# You type:        ssh myserver

# SSH tunneling (access remote database locally)
ssh -L 5433:localhost:5432 myserver
# Now connect to localhost:5433 to reach the remote PostgreSQL on port 5432

# Copy files over SSH
scp file.txt myserver:/path/to/dest    # Copy TO server
scp myserver:/path/file.txt ./local/   # Copy FROM server
rsync -avz ./src/ myserver:/app/src/   # Sync directory (faster, incremental)
```

---

## curl for API Testing

```bash
# GET request
curl http://localhost:3000/api/users

# GET with headers (pretty JSON)
curl -s http://localhost:3000/api/users | jq .

# POST with JSON body
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Jane", "email": "jane@example.com"}'

# With authentication
curl http://localhost:3000/api/profile \
  -H "Authorization: Bearer eyJhbGciOi..."

# Verbose mode (see headers)
curl -v http://localhost:3000/api/users

# See response headers only
curl -I http://localhost:3000/api/users

# Timing information
curl -w "\nDNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTotal: %{time_total}s\n" \
  -o /dev/null -s http://localhost:3000/api/users

# Save response to file
curl -o response.json http://localhost:3000/api/users

# Follow redirects
curl -L http://example.com/old-url

# PUT/PATCH/DELETE
curl -X PATCH http://localhost:3000/api/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name": "Updated Name"}'

curl -X DELETE http://localhost:3000/api/users/123
```

---

## Environment Variables

```bash
# View current environment
printenv                    # All variables
echo $PATH                  # Specific variable
echo $DATABASE_URL

# Set temporarily (current session only)
export NODE_ENV=development
export PORT=3000

# Set for a single command
DATABASE_URL=postgres://... npx prisma migrate dev

# .env files (loaded by dotenv or NestJS ConfigModule)
# .env.example — committed to git (documents required vars)
DATABASE_URL=postgres://user:password@localhost:5432/mydb
JWT_SECRET=your-secret-here
REDIS_URL=redis://localhost:6379

# .env — NOT committed to git (actual values)
# .env.local — local overrides
```

---

## Package Manager CLI

### npm vs pnpm vs yarn

| Command | npm | pnpm | yarn |
|---------|-----|------|------|
| Install all deps | `npm install` | `pnpm install` | `yarn` |
| Add dependency | `npm install express` | `pnpm add express` | `yarn add express` |
| Add dev dependency | `npm install -D jest` | `pnpm add -D jest` | `yarn add -D jest` |
| Remove dependency | `npm uninstall express` | `pnpm remove express` | `yarn remove express` |
| Run script | `npm run dev` | `pnpm dev` | `yarn dev` |
| CI install (exact) | `npm ci` | `pnpm install --frozen-lockfile` | `yarn --frozen-lockfile` |
| Update deps | `npm update` | `pnpm update` | `yarn upgrade` |
| Audit security | `npm audit` | `pnpm audit` | `yarn audit` |

### Key Concepts

```bash
# npm ci vs npm install
npm install    # Updates lockfile if package.json changed — DON'T use in CI
npm ci         # Installs EXACTLY what's in lockfile — USE in CI

# Lockfile importance
# package-lock.json / pnpm-lock.yaml / yarn.lock
# ALWAYS commit to git. Ensures everyone gets the same versions.

# npx — run a package without installing it globally
npx prisma studio
npx create-next-app@latest
npx kill-port 3000
```

---

## Git Quick Reference

```bash
# Daily workflow
git status                          # What's changed?
git diff                            # See unstaged changes
git diff --staged                   # See staged changes
git add src/users/                  # Stage specific files/dirs
git commit -m "feat: add user list" # Commit with message
git push                            # Push to remote

# Branching
git branch                          # List local branches
git checkout -b feature/new-thing   # Create and switch to new branch
git checkout main                   # Switch to main
git merge feature/new-thing         # Merge branch into current
git branch -d feature/new-thing     # Delete merged branch

# Syncing
git fetch                           # Download remote changes (don't merge)
git pull                            # Fetch + merge
git pull --rebase                   # Fetch + rebase (cleaner history)

# History
git log --oneline -20               # Last 20 commits, compact
git log --graph --oneline --all     # Visual branch graph
git show <commit-hash>              # Show specific commit details
git blame src/auth/auth.service.ts  # Who changed each line?

# Undoing things
git checkout -- file.ts             # Discard unstaged changes to file
git reset HEAD file.ts              # Unstage a file
git reset --soft HEAD~1             # Undo last commit, keep changes staged
git stash                           # Save changes temporarily
git stash pop                       # Restore stashed changes

# Remote
git remote -v                       # Show remote URLs
git remote add origin <url>         # Add remote
```

---

## Productivity Tips

### Aliases (add to ~/.bashrc or ~/.zshrc)

```bash
# Git aliases
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline -20"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"

# Development aliases
alias dev="npm run start:dev"
alias build="npm run build"
alias test="npm run test"
alias studio="npx prisma studio"
alias migrate="npx prisma migrate dev"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -la"
```

### History Search

```bash
# Ctrl+R — reverse search through command history
# Start typing to filter, Ctrl+R to cycle matches, Enter to execute

# Search history
history | grep "docker"
```

### tmux Basics (Terminal Multiplexer)

```bash
tmux new -s dev              # Create named session
tmux ls                      # List sessions
tmux attach -t dev           # Reattach to session

# Inside tmux:
# Ctrl+B, %     — Split vertically
# Ctrl+B, "     — Split horizontally
# Ctrl+B, arrow — Switch panes
# Ctrl+B, d     — Detach (session keeps running)
# Ctrl+B, c     — New window
# Ctrl+B, n     — Next window
```

---

*Terminal Essentials v1.0 | Created: February 13, 2026*
