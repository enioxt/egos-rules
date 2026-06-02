# LLM Orchestration Matrix — EGOS-080

> **Version:** 1.1.0 | **Updated:** 2026-05-30
> **SSOT:** `packages/shared/src/llm-providers/llm-router.ts` (routing formula) | [agent_scopes_and_governance.md](file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md) (scopes)
> **Applies to:** All AI calls within the EGOS ecosystem

---

## Lane Definitions

| Lane | Authority / Agent | Owns | Approval Mode | Cost Tier |
|------|-------------------|------|---------------|-----------|
| `planner` | **EGOS Prime** | Multi-step reasoning, architecture decisions, complex analysis | confirm | $$$  (gpt-5.4 / Opus, ~$0.0025/1k) |
| `executor` | **EGOS Operator** | Code generation, structured JSON output, high-precision tasks | auto | $$  (claude-sonnet, ~$0.003/1k) |
| `cheap` | **EGOS Gemini** | Classification, PII detection, summarization, high-volume calls | auto | $  (gemini-flash, ~$0.0001/1k) |
| `sovereign` | **Sovereign Lane** | Any task requiring data sovereignty or offline-capable routing | confirm | $  (qwen-plus via DashScope, ~$0.0004/1k) |

---

## Orchestrator Ownership

### EGOS Prime (this session — terminal)
- **Authority:** Executor + Planner for kernel tasks
- **Allowed:** Architecture decisions, new files, governance changes, agent wiring, SSOT edits
- **Approval mode:** auto for code writes; confirm for frozen zone edits
- **Model used:** claude-opus-4-7 / claude-sonnet-4-6 (default CLI context)
- **Do NOT route through llm-router.ts** — EGOS Prime is the orchestrator consumer

### EGOS Operator (background, async)
- **Authority:** Executor
- **Allowed:** Code generation from specs, test writing, refactoring scoped tasks
- **Approval mode:** auto (unless editing frozen files)
- **Model used:** routeTask('code_generation', { preferLane: 'executor' })
- **Conflict rule:** If EGOS Prime is active on same task → EGOS Operator defers

### Guarani (Antigravity Agent — this runtime context)
- **Authority:** Evaluator & Coordinator
- **Allowed:** Repository analysis, verification checkpoints, rules comparison, duplicate detection
- **Approval mode:** confirm (requires HITL validation before execution)
- **Model used:** Gemini (Antigravity internal runtime — NOT routed via llm-router.ts)
- **Identity SSOT:** `.guarani/GUARANI.md`

### ?!? (EGOS Codex Agent — background / CLI commands)
- **Authority:** Deep review and adversarial audit — procura gaps, faz perguntas difíceis
- **Allowed:** Code reviews, generation of unit tests, AST parsing, and code lint checks
- **Approval mode:** confirm (never runs autonomously on kernel files without human ACK)
- **Trigger:** acionado pelo EGOS Prime (orquestrador) ou outro agente dentro do Claude Code
- **Model used:** gpt-5.5 (low→xhigh) / gpt-5.4 / gpt-5.3-codex — reasoning tier por tarefa
- **Conflict rule:** Active session check before executing heavy reviews

### EGOS Gemini Agent
- **Authority:** Visual / Multi-modal verification
- **Allowed:** UI/UX checks, visual proof analysis
- **Model used:** google/gemini-2.0-flash-001 (cheap lane via OpenRouter)

### Hermes Agent (messaging / notifications)
- **Authority:** Event-Bus handler
- **Allowed:** Post webhooks to Evolution API/Telegram, read lockfiles, alert system
- **Model used:** NÃO é um modelo — sistema de automação event-driven (`scripts/hermes-trigger.sh` + `hermes-*.ts`). Para LLM, roteia via llm-router.ts (tier free/minimax).


---

## When to Use llm-router.ts vs Hardcode

### Use `routeTask()` (llm-router.ts)
- Agent code making API calls at runtime
- Guard Brasil API (PRI layer, bias analysis, classification)
- Any task type from the `TaskType` union
- When cost optimization matters (>100 calls/day)

### Hardcode the model
- Claude Code session = always claude-sonnet-4-6 (this process IS the model)
- Cascade = always Cascade internal (not in registry)
- One-off scripts where exact reproducibility matters more than cost
- Emergency runbook steps (use the specific model that was tested)

---

## Routing Decision Flow

```
New AI call needed?
  ├─ Is this Claude Code session itself? → No route. You ARE the model.
  ├─ Does task require BR data sovereignty? → routeTask(type, { preferLane: 'sovereign' })
  ├─ Is it Guard Brasil API? → routeGuardBrasil(type)
  ├─ Is it complex_reasoning or architecture? → routeTask(type, { preferLane: 'planner' })
  ├─ Is it code_generation or structured_output? → routeTask(type, { preferLane: 'executor' })
  └─ Default → routeTask(type) — formula picks best
```

---

## Emergency Fallback Chain

When a model is down or quota-exhausted, the router builds `fallbackChain` automatically (different providers preferred). Manual override:

```
1. qwen-plus (DashScope) — always available, sovereign
2. gemini-flash (OpenRouter) — cheapest, high quota
3. claude-sonnet (OpenRouter) — most capable, use last (cost)
```

If ALL providers are down: return cached result if <1h old, else surface `503 / DEFER` via PRI gate.

---

## Conflict Resolution

| Scenario | Rule |
|----------|------|
| Claude Code + Cascade on same file | Claude Code wins. Cascade must exit worktree first. |
| Codex + Cascade on same task | Check worktrees.json lock. First writer wins. |
| Two agents hit same model quota | Router auto-demotes to next lane. Log in `cost_usd` field. |
| DashScope + OpenRouter both available | Prefer DashScope for sovereign tasks; OpenRouter for speed. |
| Planner lane hit for bulk task (>50 calls) | Block. Force reclassify as cheap/executor. Cost gate in agent checklist. |

---

## Escalation Rules

| Trigger | Escalate to |
|---------|-------------|
| Task requires frozen zone edit | Human confirm required. Claude Code cannot self-approve. |
| Cost projection >$5 for single task | Stop. Log. Show projection. Await human ACK. |
| Model returns confidence <60% on PII | PRI gate: DEFER → human review queue |
| Two orchestrators claim same worktree | Lock wins. Challenger logs conflict in TASKS.md and waits. |

---

## References

- Routing formula: `packages/shared/src/llm-router.ts` — `routeTask()`, `routeGuardBrasil()`
- Model registry: `DEFAULT_MODELS` in llm-router.ts (qwen-plus, qwen-turbo, gemini-flash, claude-sonnet, gpt-5.4)
- PRI safety gate: `packages/core/src/guards/pri.ts`
- Worktree locks: `.guarani/worktrees.json`
- Domain rules: `.guarani/orchestration/DOMAIN_RULES.md` §2
