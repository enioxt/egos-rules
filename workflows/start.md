---
description: start workflow
---

# /start — Session Initialization (v5.5)

## 1. Load Core Context

Read these files in order (all paths relative to repo root):

- `AGENTS.md` — Project config, stack, commands, SSOT files list
- `TASKS.md` — Current priorities (P0 → P1 → P2)
- `docs/CAPABILITY_REGISTRY.md` — Ecosystem capability map and current adoption truth
- `.guarani/PREFERENCES.md` — Coding standards and rules
- `.guarani/IDENTITY.md` — Agent identity and mission

If `docs/CAPABILITY_REGISTRY.md` is missing in a leaf repo, load the canonical fallback at `/home/enio/egos/docs/CAPABILITY_REGISTRY.md` and flag the local absence as governance drift.

## 2. Load Orchestration System

Read the orchestration pipeline that governs ALL work:

- `.guarani/orchestration/PIPELINE.md` — 7-phase protocol (INTAKE → CHALLENGE → PLAN → GATE → EXECUTE → VERIFY → LEARN)
- `.guarani/orchestration/GATES.md` — 5-dimension quality scoring (score >= 75 to proceed)
- `.guarani/orchestration/QUESTION_BANK.md` — 70+ maieutic questions by domain
- `.guarani/orchestration/DOMAIN_RULES.md` — Project-specific checklists

Acknowledge: "Orchestration Protocol loaded. Pipeline: 7 phases. Gate threshold: 75."

## 3. Load Meta-Prompt System

Scan `.guarani/prompts/triggers.json` for active trigger mappings:

- `.guarani/prompts/PROMPT_SYSTEM.md` — Meta-prompt index (anatomy, triggers, catalog)
- `.guarani/prompts/triggers.json` — Machine-readable keyword→prompt mappings
- `.guarani/prompts/meta/universal-strategist.md` — Game Theory + Oriental philosophy
- `.guarani/prompts/meta/brainet-collective.md` — Collective intelligence lens
- `.guarani/prompts/meta/mycelium-orchestrator.md` — Recursive sync, mesh reality, self-improvement loop
- `.guarani/philosophy/TSUN_CHA_PROTOCOL.md` — Dialectical debate protocol

Acknowledge: "Meta-prompt system loaded. [N] prompts, [N] triggers active."

If the task mentions `mycelium`, `mesh`, `sync`, `agents`, `auto melhorar`, or `teia`, load `.windsurf/workflows/mycelium.md` immediately after `/start`.
If that workflow is absent in the current repo, load `docs/concepts/mycelium/MYCELIUM_OVERVIEW.md` instead and flag the missing workflow as drift.

If the task mentions `chatbot`, `prompt`, `replication`, `shared modules`, `backfill`, or `compliance`, load `docs/modules/CHATBOT_SSOT.md` immediately after `/start`.
If that file is absent in the current repo, load `/home/enio/egos/docs/modules/CHATBOT_SSOT.md` instead and flag the local absence as drift.

## 4. Load Refinery (Intent Processing)

For MODERATE+ tasks, the Refinery activates automatically:

- `.guarani/refinery/classifier.md` — Intent classification (FEATURE/BUG/REFACTOR/KNOWLEDGE)
- `.guarani/refinery/interrogators/` — 4 specialized interrogators by type
- `.guarani/preprocessor.md` — Vague→explicit translation with persona simulation

These are loaded ON-DEMAND when the pipeline activates. No need to read all at start.

If the local repo does not ship these Refinery surfaces, load the shared fallback from `~/.egos/guarani/refinery/*` and `~/.egos/guarani/preprocessor.md`, then record the missing local surfaces as drift instead of silently claiming them loaded.

If the task involves setup, auth, platform configuration, or multiple valid paths, prefer `ask_user_question` early to keep the human in the loop. Default to multiple-choice prompts unless the choice is strictly binary/exclusive.

## 5. Rule Checksum Validation

> **CRITICAL:** LLMs suffer from probabilistic rule drift over long contexts.

Read `.windsurfrules` and confirm the active ruleset:

- Print: "Rules v[X.X.X] loaded. Mandamentos: [count]. Frozen zones: [count]."
- Verify `AGENTS.md` version matches `.windsurfrules` expectations.

## 6. System Map & Handoff

- Read `docs/SYSTEM_MAP.md` for the repo-local system overview
- Use `~/.egos/SYSTEM_MAP.md` only when the task requires cross-repo topology beyond this kernel
- Check latest handoff in `docs/_current_handoffs/` (most recent file)
- Recent commits: `git log --oneline -5`

## 7. Cost Monitor

| Resource | Warning | Critical |
|----------|---------|----------|
| Vercel usage | > 50% | > 75% (STOP) |
| Supabase DB | > 500 MB | > 2 GB (EMERGENCY) |

## 8. Tooling Session Check (MANDATORY)

The agent MUST verify these before implementation work:

| Tool | Check command | Required? | Default |
|------|--------------|-----------|--------|
| Gem Hunter SecOps | `ls -t docs/gem-hunter/secops-*.md 2>/dev/null \| xargs grep -l UNMITIGATED` | YES (BLOCKING) | Must mitigate CVEs first |
| Codex | `codex --version` | MODERATE+ tasks | `codex review --uncommitted` |
| Codex cloud | `codex cloud list` | If pending tasks exist | Inspect before new work |
| Alibaba | `.env` has `ALIBABA_DASHSCOPE_API_KEY` | Yes | `alibaba:qwen-plus` |
| Session guard | `bun run session:guard` | Only if this repo exposes it | Else use `bun run governance:check` + `bun run agent:lint` |
| Gem Hunter | `ls -t docs/gem-hunter/gems-*.md 2>/dev/null \| head -1` | Research sessions in repos that ship Gem Hunter | Suggest if > 7 days old |
| Report Generator | `ls -t docs/reports/report-*.html 2>/dev/null \| head -1` | Research sessions in repos that ship report generation | `bun agent:run report-generator --exec` |

Rules:

- **[NEW] SecOps Gate**: If a critical zero-day is found in `docs/gem-hunter/secops-*.md`, the agent MUST abort the start and instruct the user to mitigate the CVE immediately.
- Codex runs in a **parallel terminal**, NEVER in main chat
- Codex NEVER owns SSOT; it reviews under human/Cascade supervision
- Alibaba is the preferred orchestrator when configured
- If Alibaba is not configured, the agent MUST say `unavailable` and MUST NOT claim `alibaba:qwen-plus` is active
- Kernel repos may not expose `session:guard`, `docs/gem-hunter`, or `docs/reports`; treat them as optional surfaces, not activation blockers

## 9. Output Briefing

Present to user:

- **Security Status:** Critical active CVEs or Clean Network
- **Rules:** Version + mandamento count + orchestration status
- **Tasks:** P0 blockers → P1 sprint → P2 backlog (counts)
- **Handoff:** Last session summary (1-2 lines)
- **Recent commits:** Last 5 commits
- **Meta-prompts:** Count loaded + active triggers
- **Codex:** Availability + pending cloud tasks + chosen mode (cloud vs local read-only)
- **Alibaba:** Availability + chosen orchestrator provider/model
- **Research:** Latest gem-hunter/report state or `N/A` for kernel repos without those surfaces
- **Orchestration:** "Pipeline active. Refinery ready. Gate threshold: 75."
- **Agent Signature:** confirm signature contract loaded and enforced on every operational message
- **Git Provenance:** confirm signature footer includes repo/branch/commit/push-remote fields for Codex, Antigravity, and Google AI Studio lanes

---

## File Existence Check

Required (flag if missing): `AGENTS.md`, `TASKS.md`, `docs/CAPABILITY_REGISTRY.md`, `.windsurfrules`, `.guarani/PREFERENCES.md`, `.guarani/IDENTITY.md`, `.guarani/orchestration/PIPELINE.md`, `.guarani/orchestration/GATES.md`, `.guarani/orchestration/QUESTION_BANK.md`, `.guarani/orchestration/DOMAIN_RULES.md`, `.guarani/refinery/classifier.md`, `.guarani/refinery/interrogators/*.md`, `.guarani/preprocessor.md`, `.guarani/prompts/PROMPT_SYSTEM.md`, `.guarani/prompts/triggers.json`, `docs/SYSTEM_MAP.md`.

For leaf repos, missing required files MUST produce both: (1) an explicit drift note in the `/start` briefing, and (2) a canonical fallback load when a verified upstream source exists.

Optional: `.guarani/philosophy/TSUN_CHA_PROTOCOL.md`, `.guarani/MCP_ORCHESTRATION_GUIDE.md`, `.guarani/DESIGN_STANDARDS.md`.

---

## 10. Agent Signature Activation (MANDATORY)

Load and enforce:
- `.guarani/standards/AGENT_MESSAGE_SIGNATURE_CONTRACT.md`

Propagation step (kernel governance change):
1. `bun run governance:sync:exec`
2. `bun run governance:check`

Delegation instruction to other agents/environments:
- "Activate `AGENT_MESSAGE_SIGNATURE_CONTRACT.md` locally and enforce signature footer on every operational reply."

---

*v5.5 — Added Capability Registry + SecOps CISA KEV Dependency scanning.*
