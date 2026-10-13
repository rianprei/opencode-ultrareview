#!/usr/bin/env bash
# install.sh — opencode-ultrareview
# Installs for all detected runtimes. Requires git for remote install.
set -uo pipefail

REPO="rianprei/opencode-ultrareview"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📋 Installing opencode-ultrareview..."

cleanup() { [ -n "${TMPDIR:-}" ] && [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"; }
TMPDIR=""

install_opencode() {
  mkdir -p ~/.config/opencode/commands
  cp "$SRC_DIR/opencode/ultrareview.md" ~/.config/opencode/commands/ultrareview.md
  echo "  ✅ opencode: ~/.config/opencode/commands/ultrareview.md"
  INSTALLED=$((INSTALLED+1))
}

install_claude() {
  mkdir -p ~/.claude/commands
  cp "$SRC_DIR/claude/ultrareview.md" ~/.claude/commands/ultrareview.md
  echo "  ✅ Claude Code: ~/.claude/commands/ultrareview.md"
  INSTALLED=$((INSTALLED+1))
}

install_codex() {
  mkdir -p ~/.codex/skills/ultrareview
  cp "$SRC_DIR/codex/SKILL.md" ~/.codex/skills/ultrareview/SKILL.md
  echo "  ✅ Codex: ~/.codex/skills/ultrareview/SKILL.md"
  INSTALLED=$((INSTALLED+1))
}

install_grok() {
  mkdir -p ~/.grok/skills/ultrareview
  cp "$SRC_DIR/grok/SKILL.md" ~/.grok/skills/ultrareview/SKILL.md
  echo "  ✅ Grok Build: ~/.grok/skills/ultrareview/SKILL.md"
  INSTALLED=$((INSTALLED+1))
}

INSTALLED=0

# Source: local repo or download
if [ -f "$SCRIPT_DIR/src/opencode/ultrareview.md" ]; then
  SRC_DIR="$SCRIPT_DIR"
  echo "  📁 Installing from local directory: $SCRIPT_DIR"
else
  # Remote: need git
  if ! command -v git >/dev/null 2>&1; then
    echo "  ❌ git not found — required for remote install. Install git or clone manually."
    echo "     Manual: git clone https://github.com/$REPO.git && cd $(basename $REPO) && bash install.sh"
    exit 1
  fi
  echo "  ⬇ Downloading from github.com/$REPO..."
  TMPDIR=$(mktemp -d) || { echo "  ❌ Cannot create temp dir"; exit 1; }
  trap cleanup EXIT
  if ! git clone --depth 1 "https://github.com/$REPO.git" "$TMPDIR/repo" 2>&1; then
    echo "  ❌ git clone failed — check network and try again"
    exit 1
  fi
  SRC_DIR="$TMPDIR/repo"
fi

# Detect and install for all available runtimes
if command -v opencode >/dev/null 2>&1 || [ -d ~/.config/opencode ]; then install_opencode; fi
if command -v claude >/dev/null 2>&1 || [ -d ~/.claude ]; then install_claude; fi
if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then install_codex; fi
if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then install_grok; fi

# Fail if nothing installed
if [ "$INSTALLED" -eq 0 ]; then
  echo ""
  echo "  ⚠ No runtimes detected. Install opencode, Claude Code, Codex, or Grok Build first."
  echo "    Or copy manually from $SRC_DIR/src/ to:"
  echo "    opencode: ~/.config/opencode/commands/ultrareview.md"
  echo "    claude:  ~/.claude/commands/ultrareview.md"
  echo "    codex:   ~/.codex/skills/ultrareview/SKILL.md"
  echo "    grok:    ~/.grok/skills/ultrareview/SKILL.md"
  exit 1
fi

echo ""
echo "  Done. Use: /ultrareview <file|folder|diff>| /ultrareview"
