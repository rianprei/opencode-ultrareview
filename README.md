# opencode-ultrareview

> **Local replica of Anthropic's `/code-review ultra`** — a fleet of 5 adversarial reviewers with an evidence gate. Every finding is independently verified before it reaches you. 100% local. No cloud. No quota. No browser. No limits.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-5.2-green.svg)](CHANGELOG.md)
[![Runtimes](https://img.shields.io/badge/runtimes-opencode%20%7C%20claude%20%7C%20codex%20%7C%20grok-blueviolet.svg)](#installation)
[![Cloud Free](https://img.shields.io/badge/cloud-free-brightgreen.svg)](#what-it-eliminates)
[![Quota Free](https://img.shields.io/badge/quota-unlimited-brightgreen.svg)](#what-it-eliminates)

## What it eliminates

The original `/code-review ultra` costs **$5–25 per review** (after 3 free runs), takes 5–10 minutes in a cloud sandbox, requires a claude.ai login, and refuses diffs over 500 files / 8,000 lines. If the review crashes, you burn a credit.

This replica runs in **seconds**, **free**, on **any code**, with **no quota**, and it **never loses work**.

## What it does

```
/ultrareview <file|folder|diff|nota>
```

Spawns **5 specialized reviewers in parallel** — each examining the same code through a different lens — then every finding crosses an **adversarial evidence gate** before appearing in the report:

```
Setup → Find → Dedupe → Verify → Relatório
```

| Stage | What happens |
|---|---|
| **Find** | 5 reviewers (logic, security, performance, tests, architecture) in parallel. Each finding has severity + evidence quote + confirmation step + grade (V1/V2/V3) |
| **Dedupe** | Same finding from 2+ reviewers → one, citing the angles |
| **Verify** | A fresh verifier tries to DISPROVE each finding. Only survivors become CONFIRMADO |
| **Relatório** | Numbered, severity-ordered, with REFUTADOS visible (and why) |

## The evidence gate

This is what separates ultrareview from a normal review:

| Grade | Meaning |
|---|---|
| **V1** | Command was run, output is pasted in the report |
| **V2** | Read from the cited code, quote included |
| **V3** | Hypothesis (marked, never mixed with confirmed) |

**Every citation is re-checked against the file NOW** — memory is not a citation.

**Secrets are redacted**: credential values show location + type + first 4 chars only. The value itself never enters the report.

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                  /ultrareview <alvo>                          │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─── SETUP ─────┐  git diff HEAD + untracked, or path      │
│  │ Terrain first │  "rápido" → fleet of 3                  │
│  └──────┬────────┘                                           │
│         ▼                                                     │
│  ┌─── FIND ──────┐  5 lenses in PARALLEL:                    │
│  │ Frota 5 agents │  logic · security · perf · tests · arch  │
│  │                 │  Each: [severity] file:line             │
│  │                 │  Evidência · Como confirmar · Grade     │
│  └──────┬─────────┘                                           │
│         ▼                                                     │
│  ┌─── DEDUPE ────┐  Merge duplicates, cite angles            │
│  └──────┬────────┘                                           │
│         ▼                                                     │
│  ┌─── VERIFY ────┐  Fresh verifier tries to DISPROVE:       │
│  │ Adversarial    │  CONFIRMADO | REFUTADO | SÓ EXECUTANDO  │
│  │ gate           │  Auditoria final: re-check NOW            │
│  └──────┬────────┘                                           │
│         ▼                                                     │
│  ┌─── RELATÓRIO ─┐  #N numbered, severity-ordered            │
│  │                │  REFUTADOS visible with the reason      │
│  │                │  Secrets redacted · Veredito             │
│  └────────────────┘                                          │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/rianprei/opencode-ultrareview/main/install.sh | bash
```

### Manual

| Runtime | File | Destination |
|---|---|---|
| **opencode** | `src/opencode/ultrareview.md` | `~/.config/opencode/commands/ultrareview.md` |
| **Claude Code** | `src/claude/ultrareview.md` | `~/.claude/commands/ultrareview.md` |
| **Codex** | `src/codex/SKILL.md` | `~/.codex/skills/ultrareview/SKILL.md` |
| **Grok Build** | `src/grok/SKILL.md` | `~/.grok/skills/ultrareview/SKILL.md` |

## Usage

```
/ultrareview                                # git diff + untracked
/ultrareview src/auth/                      # pasta
/ultrareview arquivo.py                     # arquivo
/ultrareview rápido                         # frota de 3 (logic+security+tests)
/ultrareview foca em race conditions no auth # nota de prioridade
```

Report format:

```
🔍 ULTRAREVIEW — escopo: <o que> (N arquivos, M linhas)
Modo: <5+1 | 3+1 rápido | sequencial | parcial>

## Confirmados
#1 [crítico] arquivo:linha — problema
  Evidência: <trecho> | Como confirmar: <passo> | Grade: V1 | Ângulos: logic+security

## Não confirmados — incluindo REFUTADOS e o porquê
## Resumo
3 confirmados (1 crítico, 2 altos), 1 refutado, 0 verificáveis.
Veredito: resolver 1 crítico antes do merge.
```

## Comparison vs the original

| Feature | Anthropic's `/code-review ultra` | This replica |
|---|---|---|
| Where | Cloud sandbox | **100% local** |
| Cost | 3 free runs, then $5-25/review | **Free (local tokens)** |
| Time | 5-10 min | **Seconds to minutes** |
| Max diff | 500 files / 8,000 lines (hard refusal) | **No limit (prioritizes, never refuses)** |
| Quota on crash | Burns a credit | **Zero cost** |
| Findings delivery | Truncated in CLI, full text in browser | **Full text in terminal, never truncated** |
| Network required | Yes (upload to Anthropic) | **Zero network** |
| Read-only guarantee | Sandbox isolation | Read-only perimeter + `agent: build` |
| Secret exposure | Uncommitted credentials upload to cloud on Windows | **Secrets redacted in report, never leave machine** |

## What the reviewers look for

| Lens | Hunt |
|---|---|
| **logic** | Off-by-one, edge cases, race conditions, condicionais invertidas, happy-path-only |
| **security** | Injection (SQL/command), credential exposure, trust boundaries, input validation |
| **performance** | O(n²) in hot paths, N+1, resource leaks, repeated I/O |
| **tests** | Swallowed exceptions, unchecked returns, missing edge-case tests |
| **architecture** | Logic duplication, name-contract violations, dead code, wrong coupling |

## The rationalization table

The command itself resists the agent's excuses to skip the gate:

| Excuse | Reality |
|---|---|
| "the reviewers are good" | Good reviewers err confidently; the gate is the stage a normal review doesn't have |
| "obvious finding, skip verification" | "Obvious" is exactly what most often becomes a false positive |
| "I already read it, remember the line" | The gate checks NOW, against the open file |
| "it's fast, let's go" | An unverified finding costs you more time than the verification would have |

## Provenance

- Anthropic's `/code-review ultra` official docs, changelog (55 entries), ~45 GitHub issues
- 9 open-source replicas dissected: goobreview, local-ultrareview, own-ultrareview, codex-ultrareview, ios-ultrareview, etc.
- Internal codename "Bug Hunter" (GitHub issue #65708)
- Full weakness catalog: 33 limiters documented and each removed or inverted

## License

MIT — see [LICENSE](LICENSE)
