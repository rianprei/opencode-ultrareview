#!/usr/bin/env bash
# install.sh — opencode-ultrareview
# Installs command files AND agent files for all detected runtimes.
# Usage: bash install.sh (from repo root) or curl | bash (downloads first)
set -uo pipefail

REPO="rianprei/opencode-ultrareview"

echo "📋 Installing opencode-ultrareview..."

# Determine source directory (repo root)
if [ -f "$(pwd)/src/opencode/ultrareview.md" ]; then
  SRC_DIR="$(pwd)"
elif [ -f "$(dirname "$0")/src/opencode/ultrareview.md" ]; then
  SRC_DIR="$(dirname "$0")"
else
  # Download
  if ! command -v git >/dev/null 2>&1; then
    echo "  ❌ git not found — required for remote install"
    echo "     Manual: git clone https://github.com/$REPO.git && cd opencode-ultrareview && bash install.sh"
    exit 1
  fi
  echo "  ⬇ Downloading from github.com/$REPO..."
  TMPDIR="$(mktemp -d)" || { echo "  ❌ Cannot create temp dir"; exit 1; }
  trap '[ -n "$TMPDIR" ] && [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"' EXIT
  if ! git clone --depth 1 "https://github.com/$REPO.git" "$TMPDIR/repo" 2>&1; then
    echo "  ❌ git clone failed — check network"
    exit 1
  fi
  SRC_DIR="$TMPDIR/repo"

# Verify integrity
if [ -f "$SRC_DIR/CHECKSUMS.sha256" ]; then
  (cd "$SRC_DIR" && sha256sum -c CHECKSUMS.sha256 --quiet 2>/dev/null) || echo "  ⚠ Checksum mismatch — verify manually with: cd $SRC_DIR && sha256sum -c CHECKSUMS.sha256"
fi
fi

INSTALLED=0
FAILED=0

# Install command files
install_opencode() {
  local dest=~/.config/opencode/commands
  mkdir -p "$dest" || return 1
  cp "$SRC_DIR/src/opencode/ultrareview.md" "$dest/ultrareview.md" || return 1
  echo "  ✅ opencode: $dest/ultrareview.md"
  INSTALLED=$((INSTALLED+1))
}

install_claude() {
  local dest=~/.claude/commands
  mkdir -p "$dest" || return 1
  cp "$SRC_DIR/src/claude/ultrareview.md" "$dest/ultrareview.md" || return 1
  echo "  ✅ Claude Code: $dest/ultrareview.md"
  INSTALLED=$((INSTALLED+1))
}

install_codex() {
  local dest=~/.codex/skills/ultrareview
  mkdir -p "$dest" || return 1
  cp "$SRC_DIR/src/codex/SKILL.md" "$dest/SKILL.md" || return 1
  echo "  ✅ Codex: $dest/SKILL.md"
  INSTALLED=$((INSTALLED+1))
}

install_grok() {
  local dest=~/.grok/skills/ultrareview
  mkdir -p "$dest" || return 1
  cp "$SRC_DIR/src/grok/SKILL.md" "$dest/SKILL.md" || return 1
  echo "  ✅ Grok Build: $dest/SKILL.md"
  INSTALLED=$((INSTALLED+1))
}

# Install agents (opencode only)
install_agents() {
  local dest=~/.config/opencode/agents
  mkdir -p "$dest" || return 1
  local count=0
  for agent in "$SRC_DIR"/agents/*.md; do
    [ -f "$agent" ] || continue
    cp "$agent" "$dest/" || return 1
    count=$((count+1))
  done
  if [ "$count" -gt 0 ]; then
    echo "  ✅ agents: $count files → $dest"
  fi
}

# Detect and install
if command -v opencode >/dev/null 2>&1 || [ -d ~/.config/opencode ]; then
  install_opencode && install_agents || { echo "  ⚠ opencode install had errors"; FAILED=$((FAILED+1)); }
fi
if command -v claude >/dev/null 2>&1 || [ -d ~/.claude ]; then
  install_claude || { echo "  ⚠ Claude Code install had errors"; FAILED=$((FAILED+1)); }
fi
if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then
  install_codex || { echo "  ⚠ Codex install had errors"; FAILED=$((FAILED+1)); }
fi
if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then
  install_grok || { echo "  ⚠ Grok Build install had errors"; FAILED=$((FAILED+1)); }
fi

if [ "$INSTALLED" -eq 0 ]; then
  echo ""
  echo "  ⚠ No runtimes detected. Install opencode, Claude Code, Codex, or Grok Build first."
  echo "    Or copy manually from $SRC_DIR/src/ to:"
  echo "    opencode: ~/.config/opencode/commands/ultrareview.md"
  echo "    claude:  ~/.claude/commands/ultrareview.md"
  echo "    codex:   ~/.codex/skills/ultrareview/SKILL.md"
  echo "    grok:    ~/.grok/skills/ultrareview/SKILL.md"
  echo "    agents:  ~/.config/opencode/agents/"
if [ "$FAILED" -gt 0 ]; then
  echo "  ⚠ $FAILED runtime(s) had installation errors — check output above"
  exit 1
fi
  exit 1
fi

echo ""
echo "  Done. Use: /ultrareview <file|folder|diff> or just /ultrareview"
