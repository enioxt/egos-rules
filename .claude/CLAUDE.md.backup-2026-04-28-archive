# EGOS Global Config — v5.0.0
# Read by Claude Code + Windsurf at every session across all repos
# QUORUM 2026-04-28: condensed to T0+T1+T2 core; T3+T4 lazy-loaded from ~/.claude/egos-rules/

---

## RULE PRECEDENCE

T0 > T1 > T2 > T3 > T4 — higher tier always wins on conflict.

| Tier | Scope | Where |
|------|-------|-------|
| **T0 — CRITICAL** | Irreversible damage prevention | This file §0 |
| **T1 — SAFETY** | Code/data integrity | This file §1-§4 |
| **T2 — CORE OPS** | Operating inside EGOS | This file §5-§9 |
| **T3 — ALIGNMENT** | Enio-specific behavior | `~/.claude/egos-rules/` lazy-load |
| **T4 — REFERENCE** | Lookup tables | `~/.claude/egos-rules/` lazy-load |

**Fail-closed:** if `~/.claude/egos-rules/` does not exist on this machine, warn user before proceeding with non-trivial work.

**Lazy-loaded files (load on demand):**
- `karpathy-principles.md` — think before coding, simplicity, surgical, goal-driven
- `posture-autonomy.md` — challenge mode, act-first-report-after, blockers
- `enio-profile.md` — Single Pursuit (Lídia/Delegacia until 2026-05-12), no jobs rule
- `session-checklist.md` — every response ends with ✅/🔄/⏳
- `skill-auto-activation.md` — when to invoke /start /end /disseminate etc
- `action-meta-cog.md` — for non-trivial tasks (3+ calls / 5+ files)
- `vocabulary.md`, `integrations.md`, `repo-map.md`, `doc-drift.md`, `jobs-monitoring.md`, `llm-routing.md`, `product-gtm.md`

---

## §0. CRITICAL NON-NEGOTIABLES [T0]

5 rules that cause irreversible damage if violated:

1. **NEVER force-push main** — Use `bash scripts/safe-push.sh`. Full: §4.
2. **NEVER log secrets** — Never print env var values. Never commit `.env`.
3. **NEVER publish without human approval** — Articles, X posts, outreach. HITL always.
4. **NEVER `git add -A` in agents** — Use `git add <specific-file>`. INC-002.
5. **COMMIT TASKS.md immediately** after edit — parallel agents lose uncommitted state.

**Incidental findings triage:** CRITICAL → fix now | HIGH → fix if <30min | MODERATE → P1 task | LOW → `LEARNING:` in commit.

---

## §1. MANDATORY VERIFICATION GATES [T1]

| Gate | Rule |
|------|------|
| File exists | Glob/Grep before Read/Edit |
| Function exists | Grep before referencing |
| Claim from other session | Never trust — check actual file |
| "All repos" | List which ones you actually checked |
| Deployment state | SSH or curl — don't infer from code |
| **Implementation estimate** | `ls packages/*/src/` + `grep -rl keyword packages/` + `ls supabase/migrations/` BEFORE stating hours. Estimate without scan = unverified claim (INC-009). |

If memory says "X exists at Y" — verify with Glob. Claims without proof are invalid (§8).

After file modification: run `bun run typecheck`. NEVER report "Done!" without it. Suspiciously small tool results → re-execute, flag truncation.

**External LLM Artifact Check (INC-005):** When user pastes ChatGPT/Gemini/Grok/Perplexity output: treat EVERY named feature/file/commit as **unverified claim**. `git log --grep` + `Glob` + `grep` BEFORE acknowledging. Classify: REAL | CONCEPT | PHANTOM. High-density buzzword lists (8+ caps as "systems") = phantom signal. Never say "we have X" or "you built Y" based on external LLM text alone.

**Subagent Audit Check (INC-006):** Audits from Agent/Explore/Plan = UNVERIFIED CLAIMS. Re-verify top 3 claims via `codebase-memory-mcp` (`search_graph`→`get_code_snippet`→`trace_call_path`). Absolutes ("X doesn't exist") without `file:line` anchors = PHANTOM until verified. Subagent prompts MUST require `{claim, evidence_path, evidence_line}` tuples + `UNVERIFIED:` prefix on unanchored.

**Scored SSOT Tables (INC-006):** Any table with columns `Compliance/Score/%/Coverage/Maturity/Readiness/Grade` MUST be `<!-- AUTO-GEN-BEGIN -->` block OR every row carries `VERIFIED_AT + method + evidence`. Handwritten scored tables are PHANTOM VECTORS.

**Use-Case Scoped Scoring:** Before uniform rubric across products: declare each product's primary use case, mark rows REQUIRED/OPTIONAL/N/A per use case. "N/A for this use case" ≠ fail.

**Code Discovery Order:** For code claims, codebase-memory-mcp is PRIMARY. Read/Grep is fallback for docs/config/markdown only.

---

## §2. EDIT SAFETY [T1]

1. Read before Edit (at least the relevant section)
2. Confirm exact string from Read output
3. Edit existing files — never write from scratch if avoidable
4. Non-unique old_string → add 5+ lines context
5. Re-read after edit to confirm
6. Max 3 edits per file before verification read
7. Rename/signature → grep all callers first

**Destructive checklist** (confirm before): `rm` tracked file, force-push, modifying frozen zones (`.guarani/`, `.husky/pre-commit`), Caddyfile routing.

**Large files (>300 LOC):** Remove dead code first (separate commit), break into phases (max 5 files), advance only after verification.

**Simplicity First (Karpathy):** Minimum code that solves the problem. No speculative abstractions, no helpers for one-time ops, no hypothetical future requirements. Test: "Would a senior engineer say this is overcomplicated?" If yes → simplify.

---

## §3. SECURITY [T1]

- Never log/echo/print env var values
- Never commit `.env` or files with secrets
- Validate user input at system boundaries only
- Gitleaks must pass — investigate, don't bypass
- **Test fixtures with credential patterns:** ALWAYS dynamic string construction (`'sk_' + 'live_' + 'fake'`). NEVER literal `sk_live_*`, `ghp_*`, `AKIA*`, `postgres://user:pass@*` in source. NEVER real domains in fake credentials — use `*.example.internal`/`*.test.local`
- Guard Brasil audits EGOS's own outputs before publish (§8)

---

## §4. GIT SAFETY [T1]

**Force-push FORBIDDEN** on main/master/production/prod/release/hotfix. Exception: `EGOS_ALLOW_FORCE_PUSH=1` in that shell only.

- Always `bash scripts/safe-push.sh <branch>` (fetch+rebase+retry)
- Before push from automation: `git fetch && git rebase origin/<branch>` first
- `.husky/pre-push` blocks non-FF. Answer = `git fetch && git rebase`, never `--no-verify`
- GitHub branch protection: `allow_force_pushes=false`, `allow_deletions=false`

**Swarm git rules (INC-002):**
- Background agents: `git add <specific-file>` — NEVER `git add -A`, `git add .`, `git checkout .`, `git restore .`
- Before spawning agents: commit TASKS.md + CLAUDE.md first
- TASKS.md: edit → commit within 60s
- Read-parallel / Write-sequential: never spawn 2+ write agents on same repo
- After 10+ turns or compaction: re-read TASKS.md + current file

---

## §5. CONTEXT MANAGEMENT [T2]

- ~200k token window. Autocompact ~167k.
- After 10+ turns: re-read task statement
- Files >500 LOC: read only relevant section (offset/limit)
- 5+ independent files to modify → spawn parallel Explore agents
- Research first, implement after (sequential, not simultaneous)

---

## §6. AGENT & SWARM RULES [T2]

Use Agent tool when: 5+ files to read, >3 Glob/Grep rounds expected, research+implement needed. Skip for: single-file edits, git ops, known answers.

- Independent → all agents in ONE message
- Dependent → sequential (wait for result)
- Haiku for mechanical, Sonnet for planning, Opus for deep review
- Single-context task → cheapest model

**Cost control:** 3 retries fail same error → STOP. Report `[BLOCKER]` to human.

---

## §7. SSOT & ANTI-DISPERSÃO [T2]

Each domain has exactly ONE SSOT file. New content → existing SSOT, never new file.

| Domain | SSOT |
|--------|------|
| Tasks | `TASKS.md` |
| Capabilities | `docs/CAPABILITY_REGISTRY.md` |
| GTM/social | `docs/GTM_SSOT.md` |
| Learnings | `docs/knowledge/HARVEST.md` |
| Handoffs | `docs/_current_handoffs/handoff_YYYY-MM-DD.md` |
| Strategy | `docs/strategy/EGOS_PATH_B_C_PLAN.md` |
| Quorum decisions | `docs/quorum/YYYY-MM-DD-<topic>/decision.md` |

Before creating any doc: check SSOT table. If exists → add there. Never create `docs/business/`, `docs/sales/`, `docs/notes/`, `docs/tmp/`.

**Anti-proliferação (token + arquivo):**
- Sem análise em arquivo — pesquisa e síntese ficam na conversa ou em HARVEST.md
- Sem script one-off — execute inline (`bash -c`, Python `-c`); só persiste se entrar em `scripts/` com nome canônico
- Sem variante de script existente — `morning-report-v2.ts`, `merge-fix2.py` proibidos. Edita o canônico
- Handoffs: 1 arquivo ativo (`docs/_current_handoffs/handoff_YYYY-MM-DD.md`)

SSOT hierarchy: TASKS.md → agents.json → CAPABILITY_REGISTRY.md → `.guarani/RULES_INDEX.md`

---

## §8. EVIDENCE-FIRST PRINCIPLE [T2]

**Claim without proof = invalid claim.** SSOT: `docs/strategy/EGOS_PATH_B_C_PLAN.md` §1.1.

Every claim in docs/README/article needs: (1) automated test, (2) confirming metric, (3) manifest entry, (4) dashboard tile OR reproducible dry-run.

Unproven claims marked `unverified:`. Don't enter showcase or public material.

**Doc-Drift Shield:** manifest claims verified in pre-commit. Override only with `DOC-DRIFT-ACCEPTED: <reason>` in commit body.

**Evidence gate:** `scripts/evidence-gate.ts` — warning week 1, blocking week 2+ for kernel docs.

### §8.1 Behavioral eval for claimed capabilities (INC-008)

Any capability claimed in manifest/`/api/*/discover`/README MUST have a behavioral eval — POST to real endpoint, assert on real response. Unit tests on pure functions are NOT enough.

- ≥3 golden cases before merge where stub implementation would fail
- Forbidden in main: stub compliance/safety code returning `[]`/unchanged. Use `throw new Error('NOT IMPLEMENTED')` during refactors. Silent swallow on compliance = banned.
- Canonical harness: `packages/eval-runner/`. Layer promptfoo for YAML/redteam.
- Weekly: run eval against production. Pass-rate drop = silent regression.

---

## §9. GOVERNANCE & FINDINGS [T2]

**Before structural changes:** `bun run governance:check` + `bun agent:lint`

**Incident postmortems:**
- INC-001 (force-push to main): use `bash scripts/safe-push.sh`
- INC-002 (git swarm): `git add <specific-file>`. Commit TASKS.md before spawning agents
- INC-003 (TASKS.md hallucination): verify artifact doesn't exist before adding
- INC-005 (external LLM narrative): see §1
- INC-006 (subagent phantom): see §1
- INC-009 (estimate without scan): see §1

**Quorum Protocol:** Critical decisions (CLAUDE.md changes, architecture pivots, public articles) require 3+ external LLM review. Full: `docs/governance/QUORUM_PROTOCOL.md`.

**Frozen zones:** `.guarani/` core files, `.husky/pre-commit` chain.

---

## §L. ACTION & PROOF-OF-FUNCTION [T2 — advisory]

**Rule:** Primary proof a change works = real test executed against real system.

- Code → run actual command triggering new path. Type-check alone insufficient.
- Hook/governance → emit instrumentation line, verify in log.
- Docs → grep/click every cross-reference.
- Agent outputs → UNVERIFIED until 1 structural claim re-verified.

**Exception:** Irreversible/destructive → plan test in dry-run/sandbox first. Never use prod as first execution.

Detail: `~/.claude/egos-rules/action-meta-cog.md` (load on non-trivial task).

---

*Version: 5.0.0 — 2026-04-28 (council-approved condensation)*
*v4.0 baseline (Quorum 2026-04-10). v5.0 condensed T0+T1+T2 core, T3+T4 lazy-loaded.*
*Backup: `~/.claude/CLAUDE.md.backup-2026-04-28`*
