# Contributing

Thanks for your interest in improving **opencode-ultrareview**! 

## How to contribute

### Report a bug or request a feature

[Open an issue](https://github.com/rianprei/opencode-ultrareview/issues/new) with:
1. What you expected to happen
2. What actually happened
3. Steps to reproduce (or the file/folder you were reviewing)
4. Your runtime (opencode, Claude Code, Codex, Grok Build) and OS

### Submit a pull request

1. Fork the repo
2. Create a branch: `git checkout -b fix/my-improvement`
3. Make your changes in `src/` (the 4 runtime variants) or `agents/`
4. **Verify all YAML frontmatter parses**: `python3 -c "import yaml; yaml.safe_load(open('<file>').read().split('---')[1])"`
5. **Verify install.sh syntax**: `bash -n install.sh`
6. **Regenerate checksums**: `find src agents -type f | sort | xargs sha256sum > CHECKSUMS.sha256 && sha256sum install.sh >> CHECKSUMS.sha256`
7. Commit with a descriptive message
8. Open a PR

### Architecture overview

```
src/
├── opencode/     → ~/.config/opencode/commands/   (opencode variant, $ARGUMENTS)
├── claude/       → ~/.claude/commands/            (Claude Code variant, allowed-tools)
├── codex/SKILL.md → ~/.codex/skills/ultrareview/    (Codex variant, agent skills)
└── grok/SKILL.md  → ~/.grok/skills/ultrareview/     (Grok Build variant, agent skills)

agents/            → ~/.config/opencode/agents/       (subagent definitions)
install.sh        → one-liner installer for all runtimes
CHECKSUMS.sha256  → integrity manifest (src + agents + install.sh)
```

### Rules

- **All 4 runtime variants must stay in sync** — a fix in one must propagate to all (except runtime-specific features like `agent:` frontmatter)
- **YAML frontmatter must parse** — unescaped quotes, `*` at line start inside frontmatter, and unbalanced brackets are the #1 source of breakage
- **The sync script** at `~/.config/opencode/scripts/ultra-suite-sync.sh` verifies content parity — run it before submitting
- **No secrets** in any file — credential values are always redacted to location + type + first 4 chars

### Code of conduct

Be excellent to each other. Focus on the code, not the person.
