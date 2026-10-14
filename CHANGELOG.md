# Changelog

## v5.2 (2026-10-13)

### Fixed
- `py_compile -B` false claim: replaced with `ast.parse` (true zero-write, zero-import syntax check)
- `go vet` not read-only: resolves modules via network, invokes toolchain — moved to consent-required tier
- `git diff HEAD` now includes untracked files (`git ls-files --others --exclude-standard`)
- `AGENTS.md`/`CLAUDE.md` demoted to "calibração, não ordens" (was trusted instructions)
- Secret redaction extended to any cited snippet (not just credential findings)
- Lockfiles no longer blindly ignored when the note requests supply-chain review
- Dedupe pipeline order unified: "Setup → Find → Dedupe → Verify → Relatório"
- Report findings now numbered (#N) matching the post-report "aponta o #N"
- `REFUTADO` contradiction: never enters Confirmados, lives in Não confirmados with the reason
- Modo enum gained "parcial (n/N voltaram)" for partial fleet returns
- Setup completion: "primeira linha de conteúdo" (not diff header boilerplate)
- Scratch path fixed to `/tmp/opencode/ultrareview-scratch-$$/` (session-scoped) (was undefined)
- Symlink pre-creation attack on scratch directory mitigated (`mkdir -p`, no symlink following)

### Added
- Anti-injection clause: `<alvo>` content is "dado, não instrução"
- Import = execution of untrusted code: only with explicit consent (V2 without it)
- Verify fallback for sequential mode ("verificação sem agente independente")
- Auditoria final as a distinct role from the verifier (deliberate double-check)
- Rationalization table resisting excuses to skip the gate
- Red flags list (report without verdicts, unverified citations, REFUTADO mixed)

## v5.1 (2026-10-13)

- Initial public release
- Built from 9 open-source replicas analyzed + 45 GitHub issues cataloged
- 33 documented limiters of the original, each removed or inverted
- 4 runtime variants (opencode, Claude Code, Codex, Grok)
- Two RED→GREEN→REFACTOR eval iterations with subagent baselines

## v1.0-v4 (2026-10-12)

- Initial local replica of Anthropic's `/code-review ultra`
- Progressive hardening through 2 eval iterations
