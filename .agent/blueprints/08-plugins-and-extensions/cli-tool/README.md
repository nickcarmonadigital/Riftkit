# Blueprint: CLI Tool

A command-line interface tool -- programs invoked from the terminal with arguments, flags, and subcommands. This blueprint covers argument parsing, output formatting, cross-platform concerns, and distribution.

## Recommended Tech Stacks

| Stack | Language | Best For |
|-------|----------|----------|
| Commander / Yargs | TypeScript/JS | Node.js ecosystem, npm distribution |
| Click / Typer | Python | Python ecosystem, rapid development |
| Cobra | Go | Single binary, cross-platform, fast startup |
| Clap | Rust | Performance-critical, system-level tools |
| oclif | TypeScript | Plugin-based CLIs, Heroku/Salesforce style |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define CLI purpose, target users, and command surface
- **prd_generator** -- Document commands, flags, expected behavior
- **competitive_analysis** -- Research existing CLI tools in the space
- **user_research** -- Understand terminal workflows of target users

### Phase 2: Architecture
- **api_design** -- Command hierarchy and naming conventions
- **schema_design** -- Config file format (TOML, YAML, JSON)
- **error_handling** -- Exit codes, error messages, verbose mode

### Phase 3: Implementation
- **tdd_workflow** -- Test each command with fixture inputs
- **code_review** -- Review command handlers and argument parsing
- **validation_patterns** -- Input validation for arguments and flags

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end command execution tests
- **security_audit** -- Check for command injection, path traversal
- **secrets_scanning** -- Ensure no credentials in default configs

### Phase 5: Deployment
- **ci_cd_pipeline** -- Build matrix for multiple OS/arch targets
- **deployment_patterns** -- Package registry publishing (npm, PyPI, Homebrew)
- **release_signing** -- Binary signing for trust verification

### Phase 6-7: Release and Operations
- **monitoring_setup** -- Crash reporting, usage analytics (opt-in)
- **api_versioning** -- CLI flag deprecation strategy

## Key Domain-Specific Concerns

### Command Design
- Follow established conventions: `tool <command> [subcommand] [flags] [args]`
- Use verbs for commands: `create`, `list`, `delete`, `init`, `run`
- Short flags for common options: `-v` (verbose), `-o` (output), `-f` (force)
- Long flags for clarity: `--dry-run`, `--no-color`, `--format json`
- Always provide `--help` and `--version`

### Output Formatting
- Default to human-readable output (tables, colored text)
- Offer `--json` flag for machine-readable output (scripting, piping)
- Respect `NO_COLOR` environment variable
- Use stderr for progress/status, stdout for data (enables piping)
- Exit codes: 0 = success, 1 = general error, 2 = usage error

### Configuration
- Support config file + env vars + flags (flags override env override config)
- Standard config locations: `~/.config/tool/config.toml` or `~/.toolrc`
- `tool config set key value` for interactive configuration
- Never store secrets in plaintext config -- use system keychain or env vars

### Cross-Platform
- Test on Linux, macOS, and Windows (especially path separators)
- Use `os.homedir()` / `Path.home()` not hardcoded paths
- Handle terminal width for table formatting
- Avoid shell-specific assumptions (bash-isms)

### Distribution
| Method | Pros | Cons |
|--------|------|------|
| npm / PyPI | Easy install, auto-updates | Requires runtime |
| Homebrew tap | Native macOS experience | macOS/Linux only |
| GitHub Releases | Universal, no runtime needed | Manual update |
| Docker image | Isolated, reproducible | Requires Docker |
| AUR / apt / dnf | Native Linux package | Per-distro effort |

### Error Messages
- Be specific: "File not found: config.toml" not "Error reading config"
- Suggest fixes: "Did you mean 'deploy'?" for typos
- Include `--verbose` output for debugging details
- Link to documentation for complex errors

## Getting Started

1. **Map your command tree** -- List all commands, subcommands, and their flags
2. **Choose your framework** -- Match to your language and distribution strategy
3. **Scaffold the project** -- Use framework CLI generator if available
4. **Implement `--help` first** -- Define the full interface before writing logic
5. **Build the core command** -- Start with the primary use case
6. **Add config management** -- Config file loading, env var support
7. **Add output formatting** -- Human-readable default, `--json` for machines
8. **Write integration tests** -- Test actual command execution with assertions
9. **Set up CI build matrix** -- Linux + macOS + Windows, multiple architectures
10. **Publish and document** -- README with install instructions and usage examples

## Project Structure (Node.js/Commander Example)

```
src/
  index.ts              # Entry point, commander setup
  commands/
    init.ts             # tool init
    create.ts           # tool create <name>
    list.ts             # tool list [--format json]
    config.ts           # tool config set/get
  utils/
    output.ts           # Table formatting, colors, JSON mode
    config.ts           # Config file loading
    errors.ts           # Error formatting, exit codes
  types.ts
bin/
  tool                  # Shebang entry point
test/
  commands/
    init.test.ts
    create.test.ts
package.json            # bin field, pkg config
```
