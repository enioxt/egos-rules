# ⚙️ SHARED PREFERENCES — Cross-Repo Coding Standards

> **Version:** 1.1.0 | **Updated:** 2026-03-30
> **Applies to:** ALL repos that link to ~/.egos

---

## Cross-Repo SSOT Visit Protocol (MANDATORY)

**Rule:** Whenever you access a file that is contextually distant — another repo OR deep inside the current repo (archive/, docs/, >2 dirs from root, not in TASKS/AGENTS/SYSTEM_MAP) — log the visit immediately.

**Motivation:** Large repos have "lost gems": files created, forgotten, never referenced again. Logging surfaces them and prevents silent SSOT drift.

1. **LOG the visit** in `TASKS.md`:
   `- [x] SSOT-VISIT [date]: [path] → [what extracted] → [disposition]`
2. **MARK duplicates**: `<!-- DUPLICATE: canonical at [path] -->`
3. **ARCHIVE** aspirational/wrong docs to `archive/` + log entry
4. **NEVER leave a visit unlogged** — governance violation

Triggers: cross-repo file | file in archive/docs/legacy/ | file >2 dirs deep | file found via grep search | file not committed in >30d

Disposition tags: `archived` | `merged` | `kept-as-ref` | `superseded` | `independent` | `gem-found` | `stale-confirmed`

Full spec: `egos/.guarani/orchestration/DOMAIN_RULES.md` §7

---

## Universal Rules (ALL Repos)

### Commits
```
type(scope): description

Types: feat | fix | docs | refactor | chore
```
Every commit MUST contain enough context for the OTHER agent to understand.

### File Size Limits
- **500 linhas** max por componente
- **400 linhas** max por arquivo de lógica
- **300 linhas** max por API route

### Security (ENFORCED)
1. **No PII in logs** — NEVER log CPF, email, tokens, passwords
2. **No hardcoded secrets** — Use `.env` + `.gitignore`
3. **Rate limiting** — Every external API call must use a rate limiter
4. **Auth first** — Every API route must check authentication

### TypeScript
```typescript
// ✅ ESM imports
import { thing } from './module';

// ❌ CommonJS
const { thing } = require('./module');

// ✅ Explicit types on public functions
export function analyzeGazette(gazette: GazetteItem): AnalysisResult { }

// ❌ any type
function doThing(data: any) { }
```

### Error Handling
```typescript
// ✅ Always catch and log meaningfully
try {
  await externalCall();
} catch (error) {
  console.error(`[${MODULE}] Failed:`, error instanceof Error ? error.message : 'Unknown');
  throw error;
}

// ❌ Silent catch
try { await thing(); } catch {}
```

## Design Standard: Google Stitch

**ALL UI/dashboard designs MUST go through Google Stitch first.**

1. Write prompt → `docs/stitch/[feature].md`
2. Generate in Stitch → export mockup
3. Implement code matching design
4. **NEVER build UI without Stitch mockup**

## Idea Ingestion

**Source:** `/home/enio/Downloads/compiladochats/`
- Scan before every session or on pre-commit
- Only `.md` files from AI chat exports (ChatGPT, Gemini, Claude, Grok)
- Categorize: business → `docs/plans/business/`, tech → `docs/plans/tech/`
- Personal/archive → separate directories, don't pollute business

## AI Cost Tracking (OBRIGATÓRIO)

Every AI API call must log cost. Monthly budget: **< $10 total across all repos.**

## SSOT Topology (Cross-Repo)

1. **Global topological truth:** `~/.egos/SYSTEM_MAP.md`
2. **Operational workspace truth:** `/home/enio/egos-lab/docs/EGOS_WORKSPACE_MAP.md`
3. **Reference/mycelium truth:** `/home/enio/egos-lab/docs/research/MYCELIUM_REFERENCE_GRAPH_DESIGN_2026-03-07.md`
4. **Local repo state:** each repo `AGENTS.md`, `TASKS.md`, `.windsurfrules`
5. **No parallel maps:** never create a new system/workspace/reference map without updating the canonical map in the same change
6. **Update order:** map first, tasks second, code third

## AI Orchestration (Terminal Sub-Agents)

**Crucial Directive for IDE Agents (Antigravity/Gemini & Windsurf/Cascade):**
You are the **Orchestrator**. You have full control of the terminal and can spawn specialized sub-agents to parallelize work, get second opinions, or perform deep code reviews.

1. **Codex CLI (Code Review & Sandbox):**
   - Available globally as `codex`. 
   - **Spawn pattern:** Open a background terminal with a unique PID.
   - **Usage:** Use `codex exec --sandbox read-only -C <path> "<prompt>"` for non-interactive analysis or `codex review --uncommitted` to review your own staged/unstaged changes before committing.
   - *Why?* Codex is excellent at catching logic flaws or security vulnerabilities you might miss.

2. **EGOS-Lab Agent Platform (Alibaba/Qwen-backed agents):**
   - Available via `bun agents/cli.ts` inside `/home/enio/egos-lab`.
   - **Discover:** Run `bun agents/cli.ts list` to inspect the registry and status of each agent.
   - **Spawn pattern:** Open a background terminal with a unique PID. Run `bun agents/cli.ts run <agent_id> --dry` or `bun agents/cli.ts run <agent_id> --exec`.
   - **Usage:** Delegate specific tasks (like `ssot_auditor`, `security_scanner`, `ui_designer`) through the CLI. Gather their JSONL outputs from `agents/.logs/` to inform your next steps.
   - **Live provider probe:** Use `bun run alibaba:test` to validate the Alibaba/Qwen integration when a real network/API check is needed.
   - *Why?* Qwen-backed agents are cost-effective and specialized according to the local `agents.json` registry. `agents/runtime/runner.ts` is the runtime core, but `agents/cli.ts` is the operator entrypoint.

**Execution Flow:**
- Do not assume you must do everything sequentially.
- Launch `codex` or `bun agents/cli.ts ...` in background terminals `(e.g., using tool run_command with WaitMsBeforeAsync > 0)`.
- Continue your own planning/file editing while they run.
- Check their output `(e.g., using tool command_status)` to merge their findings into your final implementation.
