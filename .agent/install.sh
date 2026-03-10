#!/bin/bash
# install.sh — Install riftkit components globally
# Copies agents, commands, rules, hooks, skills, workflows, and docs to ~/.claude/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "=== riftkit Installer ==="
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
mkdir -p "${CLAUDE_DIR}/rules/java"
mkdir -p "${CLAUDE_DIR}/rules/rust"
mkdir -p "${CLAUDE_DIR}/hooks"
mkdir -p "${CLAUDE_DIR}/scripts/hooks"
mkdir -p "${CLAUDE_DIR}/scripts/ci"
mkdir -p "${CLAUDE_DIR}/scripts/lib"
mkdir -p "${CLAUDE_DIR}/contexts"
mkdir -p "${CLAUDE_DIR}/workflows"
mkdir -p "${CLAUDE_DIR}/docs"

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
for lang_dir in common typescript python golang swift java rust; do
  if [ -d "${SCRIPT_DIR}/rules/${lang_dir}" ]; then
    mkdir -p "${CLAUDE_DIR}/rules/${lang_dir}"
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

# Copy skills (the core framework content)
echo "Installing skills..."
if [ -d "${SCRIPT_DIR}/skills" ]; then
  cp -r "${SCRIPT_DIR}/skills" "${CLAUDE_DIR}/skills"
  SKILL_COUNT=$(find "${SCRIPT_DIR}/skills" -name "SKILL.md" | wc -l)
  echo "  ✓ ${SKILL_COUNT} skill files"
fi

# Copy workflows
echo "Installing workflows..."
if [ -d "${SCRIPT_DIR}/workflows" ]; then
  cp -r "${SCRIPT_DIR}/workflows/"* "${CLAUDE_DIR}/workflows/" 2>/dev/null || true
  WORKFLOW_COUNT=$(find "${SCRIPT_DIR}/workflows" -name "*.md" -not -name "README.md" -not -name "WORKFLOWS_README.md" -not -name "WORKFLOW_ECOSYSTEM.md" | wc -l)
  echo "  ✓ ${WORKFLOW_COUNT} workflow files"
fi

# Copy docs
echo "Installing docs..."
if [ -d "${SCRIPT_DIR}/docs" ]; then
  cp -r "${SCRIPT_DIR}/docs" "${CLAUDE_DIR}/docs"
  DOC_COUNT=$(find "${SCRIPT_DIR}/docs" -name "*.md" | wc -l)
  echo "  ✓ ${DOC_COUNT} doc files"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Installed to: ${CLAUDE_DIR}"
echo ""
echo "Components:"
echo "  - Agents:    ${CLAUDE_DIR}/agents/"
echo "  - Commands:  ${CLAUDE_DIR}/commands/"
echo "  - Rules:     ${CLAUDE_DIR}/rules/"
echo "  - Hooks:     ${CLAUDE_DIR}/hooks/"
echo "  - Scripts:   ${CLAUDE_DIR}/scripts/"
echo "  - Contexts:  ${CLAUDE_DIR}/contexts/"
echo "  - Skills:    ${CLAUDE_DIR}/skills/"
echo "  - Workflows: ${CLAUDE_DIR}/workflows/"
echo "  - Docs:      ${CLAUDE_DIR}/docs/"
echo ""
echo "To verify installation, run:"
echo "  node ${CLAUDE_DIR}/scripts/ci/validate-agents.js"
echo "  node ${CLAUDE_DIR}/scripts/ci/validate-commands.js"
echo "  node ${CLAUDE_DIR}/scripts/ci/validate-skills.js"
