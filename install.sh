#!/usr/bin/env bash
# install.sh — opencode-ultrareview
# One-liner installer: detects runtime, copies the right file.
set -euo pipefail

REPO="rianprei/opencode-ultrareview"
BRANCH="main"

echo "📋 Installing opencode-ultrareview..."

# Detect runtimes
install_opencode() {
  mkdir -p ~/.config/opencode/commands
  cp src/opencode/ultrareview.md ~/.config/opencode/commands/ultrareview.md
  echo "  ✅ opencode: ~/.config/opencode/commands/ultrareview.md"
}

install_claude() {
  mkdir -p ~/.claude/commands
  cp src/claude/ultrareview.md ~/.claude/commands/ultrareview.md
  echo "  ✅ Claude Code: ~/.claude/commands/ultrareview.md"
}

install_codex() {
  mkdir -p ~/.codex/skills/ultrareview
  cp src/codex/SKILL.md ~/.codex/skills/ultrareview/SKILL.md
  echo "  ✅ Codex: ~/.codex/skills/ultrareview/SKILL.md"
}

install_grok() {
  mkdir -p ~/.grok/skills/ultrareview
  cp src/grok/SKILL.md ~/.grok/skills/ultrareview/SKILL.md
  echo "  ✅ Grok Build: ~/.grok/skills/ultrareview/SKILL.md"
}

# If running from the repo (files present), copy directly
if [ -f "src/opencode/ultrareview.md" ]; then
  if command -v opencode >/dev/null 2>&1; then install_opencode; fi
  if [ -d ~/.claude ]; then install_claude; fi
  if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then install_codex; fi
  if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then install_grok; fi
else
  # Download and install
  echo "  Downloading..."
  tmpdir=$(mktemp -d)
  git clone --depth 1 "https://github.com/$REPO.git" "$tmpdir/repo" 2>/dev/null
  cd "$tmpdir/repo"
  if command -v opencode >/dev/null 2>&1; then install_opencode; fi
  if [ -d ~/.claude ]; then install_claude; fi
  if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then install_codex; fi
  if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then install_grok; fi
  cd /
  rm -rf "$tmpdir"
fi

echo ""
echo "  Done. Use: /ultrareview <objective>"
