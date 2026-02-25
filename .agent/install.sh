#!/bin/bash
# install.sh — Install AI Dev Workflow Framework components globally
# Copies agents, commands, rules, and hooks to ~/.claude/ for use in any project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "=== AI Dev Workflow Framework Installer ==="
echo ""
echo "Source: ${SCRIPT_DIR}"
echo "Target: ${CLAUDE_DIR}"
echo ""

# Create target directories
mkdir -p "${CLAUDE_DIR}/agents"
mkdir -p "${CLAUDE_DIR}/commands"
mkdir -p "${CLAUDE_DIR}/rules/common"
mkdir -p "${CLAUDE_DIR}/rules/typescript"
mkdir -p "${CLAUDE_DIR}/rules/python"
mkdir -p "${CLAUDE_DIR}/rules/golang"
mkdir -p "${CLAUDE_DIR}/rules/swift"
mkdir -p "${CLAUDE_DIR}/hooks"
mkdir -p "${CLAUDE_DIR}/scripts/hooks"
mkdir -p "${CLAUDE_DIR}/scripts/ci"
mkdir -p "${CLAUDE_DIR}/scripts/lib"
mkdir -p "${CLAUDE_DIR}/contexts"

# Copy agents
echo "Installing agents..."
cp -r "${SCRIPT_DIR}/agents/"*.md "${CLAUDE_DIR}/agents/" 2>/dev/null || true
echo "  ✓ $(ls "${SCRIPT_DIR}/agents/"*.md 2>/dev/null | wc -l) agent files"

# Copy commands
echo "Installing commands..."
cp -r "${SCRIPT_DIR}/commands/"*.md "${CLAUDE_DIR}/commands/" 2>/dev/null || true
echo "  ✓ $(ls "${SCRIPT_DIR}/commands/"*.md 2>/dev/null | wc -l) command files"

# Copy rules
echo "Installing rules..."
for lang_dir in common typescript python golang swift; do
  if [ -d "${SCRIPT_DIR}/rules/${lang_dir}" ]; then
    cp -r "${SCRIPT_DIR}/rules/${lang_dir}/"*.md "${CLAUDE_DIR}/rules/${lang_dir}/" 2>/dev/null || true
  fi
done
echo "  ✓ $(find "${SCRIPT_DIR}/rules" -name "*.md" -not -name "README.md" | wc -l) rule files"

# Copy hooks
echo "Installing hooks..."
if [ -f "${SCRIPT_DIR}/hooks/hooks.json" ]; then
  cp "${SCRIPT_DIR}/hooks/hooks.json" "${CLAUDE_DIR}/hooks/"
fi
echo "  ✓ hooks.json"

# Copy scripts
echo "Installing scripts..."
cp -r "${SCRIPT_DIR}/scripts/hooks/"* "${CLAUDE_DIR}/scripts/hooks/" 2>/dev/null || true
cp -r "${SCRIPT_DIR}/scripts/ci/"* "${CLAUDE_DIR}/scripts/ci/" 2>/dev/null || true
cp -r "${SCRIPT_DIR}/scripts/lib/"* "${CLAUDE_DIR}/scripts/lib/" 2>/dev/null || true
echo "  ✓ $(find "${SCRIPT_DIR}/scripts" -name "*.js" | wc -l) script files"

# Copy contexts
echo "Installing contexts..."
cp -r "${SCRIPT_DIR}/contexts/"*.md "${CLAUDE_DIR}/contexts/" 2>/dev/null || true
echo "  ✓ $(ls "${SCRIPT_DIR}/contexts/"*.md 2>/dev/null | wc -l) context files"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Installed to: ${CLAUDE_DIR}"
echo ""
echo "Components:"
echo "  - Agents:   ${CLAUDE_DIR}/agents/"
echo "  - Commands:  ${CLAUDE_DIR}/commands/"
echo "  - Rules:     ${CLAUDE_DIR}/rules/"
echo "  - Hooks:     ${CLAUDE_DIR}/hooks/"
echo "  - Scripts:   ${CLAUDE_DIR}/scripts/"
echo "  - Contexts:  ${CLAUDE_DIR}/contexts/"
echo ""
echo "To verify installation, run:"
echo "  node ${CLAUDE_DIR}/scripts/ci/validate-agents.js"
echo "  node ${CLAUDE_DIR}/scripts/ci/validate-commands.js"
