# CHATBOT_SSOT — Canonical Chatbot Standard

> **VERSION:** 2.2.0 | **UPDATED:** 2026-05-14
> **OPERATIONAL CANON:** `/home/enio/egos/docs/modules/CHATBOT_SSOT.md` + `/home/enio/egos/packages/chatbot-core/` + `/home/enio/egos/apps/egos-gateway/src/` + relevant safety primitives in `/home/enio/egos/packages/shared/src/`
> **REFERENCE SOURCES:** `/home/enio/852` (historical chatbot SSE + eval patterns + extraction source) + `/home/enio/intelink` (5-tier LLM router + tool-calling + RAG patterns)
> **STATUS:** Active — all new chatbots MUST follow this standard

---

## Purpose

This document defines the canonical chatbot architecture for the EGOS ecosystem.
Every chatbot (Forja, carteira-livre, future projects) MUST implement these
modules or explicitly document why a module is skipped.

The current operational canon lives in `egos`.
The `852` project remains a high-value historical and extraction source, especially for eval patterns, chat UX, and earlier prompt/runtime primitives.

---

## 1. Modular Prompt Architecture

**Reference sources:** `852/src/lib/prompt.ts` + current kernel prompt/runtime composition in `egos`

### Pattern

Prompts are assembled from composable sections, not monolithic strings:

```
FOUNDATION + GOVERNANCE + GUARDRAILS + PRIVACY + DOMAIN_REFERENCES + TASK_INSTRUCTIONS + OUTPUT_FORMAT
```

### Required Sections

| Section | Purpose | Required |
|---------|---------|----------|
| `FOUNDATION` | EGOS identity, project context, core principles | YES |
| `GOVERNANCE` | Legal boundaries, channel limits, formal redirects | YES |
| `GUARDRAILS` | ATRiAN truth layer (see Module 2) | YES |
| `PRIVACY` | PII rules, anonymization requirements | YES |
| `DOMAIN_REFERENCES` | Domain-specific knowledge (laws, acronyms, etc.) | Per project |
| `TASK_INSTRUCTIONS` | Context-specific behavior (chat vs review vs report) | YES |
| `OUTPUT_FORMAT` | Structured output schemas (JSON for non-chat tasks) | Per task |

### Required Function

```typescript
function buildPrompt(context: TaskContext, memoryBlock?: string | null): string
```

- Accepts a task context enum and optional memory block
- Memory block is prepended (most recent context first)
- Returns fully assembled system prompt

### Task Contexts (minimum)

Every chatbot MUST support at least: `chat`, `review`, `conversation_summary`.
Additional contexts are project-specific.

---

## 2. ATRiAN Ethical Validation Layer

**Reference:** `egos/packages/shared/src/atrian.ts` (ported from `852/src/lib/atrian.ts`)

### Architecture

ATRiAN operates as a **post-response validator** — it checks AI output AFTER generation,
not just at the prompt level. This catches hallucinations that bypass prompt instructions.

### Required Checks

| # | Category | Level | Description |
|---|----------|-------|-------------|
| 1 | `blocked_entity` | CRITICAL | Domain-specific blocklist (entities that must never appear) |
| 2 | `invented_acronym` | WARNING | Acronyms not in known whitelist |
| 3 | `absolute_claim` | WARNING | Claims without epistemic hedging |
| 4 | `fabricated_data` | ERROR | References to unverifiable statistics/studies |
| 5 | `false_promise` | ERROR | Promises of action the system cannot fulfill |

### Required Interface

```typescript
interface AtrianResult {
  passed: boolean;        // false if any CRITICAL or ERROR
  violations: AtrianViolation[];
  score: number;          // 0-100, 100 = fully compliant
}

function validateResponse(text: string): AtrianResult;
function validateAndReport(text: string): AtrianResult;
function filterChunk(chunk: string): string;  // Stream-level critical filter
```

### Scoring

| Level | Deduction | Action |
|-------|-----------|--------|
| info | -2 | Log only |
| warning | -5 | Log + flag in telemetry |
| error | -15 | Log + block sharing/publishing |
| critical | -30 | Log + redact from output |

### Customization Per Project

Each project MUST define its own:
- `BLOCKED_ENTITIES` list (domain-specific)
- `KNOWN_ACRONYMS` whitelist (domain-specific)
- Additional pattern detectors as needed

---

## 3. PII Scanner

**Reference:** `egos/packages/shared/src/pii-scanner.ts` (ported from `852/src/lib/pii-scanner.ts`)

### Required Categories (Brazilian context)

| Category | Pattern | Suggestion |
|----------|---------|------------|
| `cpf` | `\d{3}.\d{3}.\d{3}-\d{2}` | `[CPF REMOVIDO]` |
| `phone` | Brazilian phone formats | `[TELEFONE REMOVIDO]` |
| `email` | Standard email regex | `[EMAIL REMOVIDO]` |
| `name` | Heuristic (role + capitalized words) | `[NOME REMOVIDO]` |

Additional categories are project-specific (RG, MASP, plates, REDS, etc.).

### Required Functions

```typescript
function scanForPII(text: string): PIIFinding[];
function sanitizeText(text: string, findings: PIIFinding[]): string;
function getPIISummary(findings: PIIFinding[]): string;
```

### UI Integration

Findings include `start` and `end` positions for highlighting in the UI.

---

## 4. Conversation Memory

**Reference:** `egos/packages/shared/src/conversation-memory.ts` (ported from `852/src/lib/conversation-memory.ts`)

### Pattern

1. After a conversation reaches 4+ messages, generate an AI summary (max 6 bullets)
2. Store summary in conversation metadata (Supabase or equivalent)
3. On new conversation, fetch last N summaries for same identity
4. Inject as a `## MEMÓRIA DE SESSÕES ANTERIORES` block in the system prompt

### Epistemic Safety

Memory block MUST include hedging:
> "Use apenas como contexto, sem afirmar como fato novo."
> "Se algo parecer desatualizado, confirme com o usuário antes de assumir continuidade."

### Configuration

| Parameter | Default | Description |
|-----------|---------|-------------|
| `MAX_MEMORY_ITEMS` | 3 | Max previous conversation summaries |
| `MIN_MESSAGES_FOR_SUMMARY` | 4 | Min messages before generating summary |
| `MAX_SUMMARY_LENGTH` | 1200 chars | Truncation limit |
| `SUMMARY_TEMPERATURE` | 0.2 | Low temperature for factual summaries |

---

## 5. Task-Based Model Routing

**Reference:** `852/src/lib/ai-provider.ts`

### Pattern

Different tasks route to different models based on cost/quality tradeoffs:

| Task Type | Recommended Model | Reasoning |
|-----------|-------------------|-----------|
| `chat` | Primary (Qwen-plus) | Best quality for conversation |
| `review` | Fast (Gemini Flash) | Structured output, speed matters |
| `html_report` | Fast (Gemini Flash) | Template generation |
| `intelligence_report` | Premium (Qwen-max) | Complex synthesis |
| `conversation_summary` | Fast (Gemini Flash) | Short, factual |
| `name_validation` | Fast (Gemini Flash) | Binary classification |

### Required: 3-Tier Fallback

```
Primary (DashScope/Alibaba) → Fallback (OpenRouter/Gemini) → Emergency (OpenAI)
```

### Required: Budget Mode

Support `AI_BUDGET_MODE` env var: `conservative` | `balanced` | `aggressive`

### Required: Cost Tracking

Every AI call MUST calculate and record cost:
```typescript
const cost = (inputTokens / 1000) * pricing.input + (outputTokens / 1000) * pricing.output;
```

---

## 6. Writing Style Rules

### Mandatory for ALL Chatbots

| Rule | Description |
|------|-------------|
| **Epistemic markers** | Use "com base no que foi relatado", "isso sugere", "isso pode indicar" |
| **Question limit** | Max 2 questions per response |
| **Depth over breadth** | Explore one topic deeply before switching |
| **No fabrication** | Never invent facts, statistics, or institutional links |
| **No false promises** | Never promise actions the system cannot fulfill |
| **Transparency** | Be explicit about limitations and uncertainty |
| **Conciseness** | Professional, direct, human tone |

### Configurable Per Project

| Rule | 852 Value | Forja Value | Default |
|------|-----------|-------------|---------|
| **No em-dashes** | Yes (public copy) | TBD | No |
| **Language** | pt-BR (formal) | pt-BR (informal/field) | pt-BR |
| **Tone** | Institutional | Operational | Professional |

---

## 7. Telemetry

**Reference:** `852/src/lib/telemetry.ts`

### Required Events

| Event Type | When | Data |
|------------|------|------|
| `chat_completion` | After every AI response | model, provider, tokens, cost, IP |
| `chat_error` | On API error | error message, IP |
| `rate_limit_hit` | On 429 | IP, endpoint |
| `atrian_violation` | On ATRiAN check fail | score, categories, levels |
| `provider_unavailable` | On 503 | — |

### Dual Output

1. **Structured logs** (JSON to stdout for Docker/observability)
2. **Persistent store** (Supabase or equivalent for dashboards)

---

## 8. Production Hardening

### Required for ALL Public Chatbots

| Control | Default | Description |
|---------|---------|-------------|
| Rate limiting | 12 msgs / 5 min / IP | In-memory or Redis |
| Message sanitization | Max 12 messages, 4000 chars each | Prevent context overflow |
| Provider availability check | Before every request | Return 503 if no provider |
| Input validation | Reject empty/malformed | Return 400 |
| Cost headers | X-Model-Id, X-Provider, X-Model-Free | Transparency |
| Rate headers | X-RateLimit-Remaining, X-RateLimit-Reset | Client awareness |

---

## 9. Implementation Checklist

For any new chatbot project, verify all modules:

- [ ] Modular prompt with composable sections
- [ ] ATRiAN validation layer with project-specific blocklists
- [ ] PII scanner with Brazilian patterns (minimum: CPF, phone, email, name)
- [ ] Conversation memory with epistemic hedging
- [ ] Task-based model routing with 3-tier fallback
- [ ] Writing style rules documented in `.guarani/PREFERENCES.md`
- [ ] Telemetry (dual output: logs + persistent store)
- [ ] Rate limiting
- [ ] Message sanitization
- [ ] Provider availability check
- [ ] Cost tracking per request
- [ ] ATRiAN violations dashboard (admin)

---

## 10. MCP Tool Integration (NEW — 2026-03-21)

**Status:** Architecture designed | **Reference Implementation:** Forja (`src/lib/tools/`)

### When to Use MCP Tools

Chatbots WITHOUT tool calling (852 today) work well for pure conversation. When a chatbot needs to **take action** (schedule, query, create, modify), it needs tools. MCP is the standard protocol for connecting tools.

### Architecture Pattern

```text
User → Chat API → PII Scan → LLM (with tool schemas) → Tool Call?
                                                          ├─ YES → MCP Server → Execute → Response
                                                          └─ NO  → Stream text response
```

### Custom MCP Server Design Rules

1. **Outcomes, not operations** — Expose `schedule_lesson(student, instructor, date)`, not `insert_into_table(sql)`
2. **5-15 tools per server** — One server per domain. Split by persona if needed.
3. **Guardrails baked in** — PII scanning and ATRiAN validation inside the MCP server, not delegated to the chatbot
4. **Mycelium events** — Every tool call emits an event to the Mycelium bus for audit and cross-agent awareness
5. **Graceful degradation** — If MCP server is unreachable, chatbot falls to tool-less conversational mode

### Required MCP Server Interface

```typescript
// Each custom MCP server MUST expose:
// 1. Health check tool (for auto-healing)
// 2. Domain tools (outcome-oriented)
// 3. Structured error responses with user-friendly messages

// Tool naming: {domain}_{action}_{target}
// Examples: marketplace_schedule_lesson, erp_create_quote, intel_search_company
```

### Planned EGOS MCP Servers

| Server | Domain | Tools | Priority |
|--------|--------|-------|----------|
| `@egos/mcp-governance` | All repos | ssot_check_drift, task_list, deploy_gate | P1 |
| `@egos/mcp-memory` | All chatbots | memory_store, memory_recall, memory_search | P1 |
| `@egos/mcp-marketplace` | carteira-livre | lesson_schedule, instructor_match, payment_create | P2 |
| `@egos/mcp-erp` | forja | quote_create, inventory_check, order_track | P2 |
| `@egos/mcp-intelligence` | 852/policia | report_generate, ovm_process, correlation_search | P2 |
| `@egos/mcp-osint` | br-acc | company_search, network_analyze, pattern_detect | P2 |

### Existing MCPs (DO NOT REBUILD)

filesystem, memory, supabase, exa, github, sequential-thinking — already available via IDE MCP config.

### Implementation Checklist (per new MCP server)

- [ ] `package.json` with `@modelcontextprotocol/sdk` dependency
- [ ] Zod schemas for all tool inputs
- [ ] Health check tool
- [ ] ATRiAN validation on outputs containing user-facing text
- [ ] PII scanning on inputs before processing
- [ ] Mycelium event emission on tool execution
- [ ] Rate limiting per-caller
- [ ] Structured error responses (code + user message + suggestion)
- [ ] JSONL audit log of all tool calls

---

## 11. Auto-Healing & Symbiotic Patterns (NEW — 2026-03-21)

### Auto-Healing

| Pattern | Implementation | Status |
|---------|---------------|--------|
| Circuit Breaker | `carteira-livre/lib/ai/guardrails.ts` (R$50/day cap) | A — needs kernel extraction |
| Provider Fallback | `egos/packages/shared/src/model-router.ts` (3-tier) | A — LIVE |
| Health Heartbeats | Mycelium `network.heartbeat` events | C — Planned |
| Graceful Degradation | Tool-less mode when MCP servers down | C — Planned |
| Cost Watchdog | Budget enforcement at orchestrator level | B — per-project |

### Symbiotic Patterns (Mycelium-Inspired)

| Pattern | Description | Mechanism |
|---------|-------------|-----------|
| Knowledge Harvesting | Conversations generate learnings | Chat → Mycelium bus → Memory MCP |
| Cross-Pollination | Insights from one domain inform another | Event topics across repos |
| Collective Intelligence | Aggregated metrics from all chatbots | Telemetry MCP → Dashboard |
| Adaptive Prompts | Usage patterns feed prompt engineering | Ambient Disseminator agent |

---

## 12. Live Replication Protocol

Every chatbot/module rollout MUST follow this order:

1. **Analyze** — locate the real chat surface, prompt assembly point, provider layer, telemetry path, and memory store.
2. **Research** — compare target code against `docs/CAPABILITY_REGISTRY.md`, this SSOT, and the strongest repo-specific implementation.
3. **Implement minimally** — prefer shared modules from `@egos/shared` before copying local logic.
4. **Test** — run the narrowest typecheck/build validation that proves integration did not break the target.
5. **Validate** — run `chatbot_compliance_checker` and record the score as evidence, not as proof of production parity.
6. **Human loop** — stop for explicit review when auth, frozen zones, destructive migrations, or product-direction choices appear.
7. **Disseminate** — update `TASKS.md`, `docs/CAPABILITY_REGISTRY.md`, `/disseminate`, and the adoption table below.

Minimum evidence per rollout:

- typecheck/build output
- compliance checker output
- exact files changed
- adoption status updated with nuanced maturity (`SSOT`, `HAS`, `FOUNDATION`, `BASIC`, `PLAN`)

---

## 13. Adoption Status

> ⚠️ **INC-005 REVERSAL v2 (2026-04-17):** Previous version (committed 2026-04-16 by Windsurf/Kimi) contained FABRICATED compliance scores. My first reversal attempt (earlier this session) used an Explore subagent's audit that ALSO contained errors (claimed Forja = skeleton, claimed carteira-livre uses `@egos/shared router`). Both were wrong. This v2 rebuilds §12 from **codebase-memory-mcp `get_code_snippet` on actual route files** — every claim has a file:line anchor. See `docs/INCIDENTS/INC-005-external-llm-narrative.md`.
>
> **Methodology (applied here, required going forward):**
> - Each chatbot was inspected via `search_graph` → `get_code_snippet` on its `/api/chat` route file
> - `trace_call_path` used to verify whether modules (ATRiAN, PII) are actually INVOKED or just exist
> - Score = module-by-module checklist scoped to use case, not uniform "100/100"
> - Scored here is the **primary LLM route** of each product — not every chat-adjacent endpoint

<!-- AUTO-GEN-BEGIN:chatbot-compliance -->
<!-- Generated by chatbot-manifest-aggregator — 2026-04-17 -->
<!-- DO NOT EDIT: regenerate with: bun agents/agents/chatbot-manifest-aggregator.ts --write -->

## §12 Chatbot Compliance Matrix (Auto-Generated)

> Scores are computed from live manifest endpoints — no handwritten values.
> ➖ = N/A for this use case. ✅ = present. ❌ = absent.

| Chatbot | Use Case | Score | ATRiAN | SSE | PII | Rate | Telemetry | Multi-Tenant | Tools | Evidence |
|---------|----------|-------|--------|-----|-----|------|-----------|--------------|-------|----------|
| `852` | Public chatbot for Brazilian legal/institutiona… | 100% (5/5) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | `github.com/enioxt/852/api/_internal/chatbot-manifest` |
| `forja` | B2B ERP chat assistant for industrial clients (… | 100% (5/5) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | `github.com/enioxt/forja/api/_internal/chatbot-manifest` |
| `carteira-livre` | Marketplace AI assistance (scheduling, lesson p… | 75% (3/4) | ➖ | ❌ | ✅ | ✅ | ✅ | ➖ | ✅ | `github.com/enioxt/carteira-livre/api/_internal/chatbot-manifest` |
| `egos-inteligencia` | Police investigation assistant (Brazilian law e… | 100% (5/5) | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ | ✅ | `github.com/enioxt/egos-inteligencia/api/_internal/chatbot-manifest` |

**VERIFIED_AT:** 2026-04-17 | **method:** chatbot-manifest-aggregator.ts | **evidence:** manifest route.ts files in each repo
<!-- AUTO-GEN-END -->

### ⚠️ Insight crítico descoberto 2026-04-17

A tabela original §12 estava conceitualmente errada: comparava chatbots com casos de uso fundamentalmente diferentes (assistente policial vs OSINT agent vs helper de marketplace vs bot interno Telegram) contra uma rubrica uniforme de "compliance 100/100". Isso **gera phantoms estruturalmente** — não é erro de um modelo específico.

**Correção arquitetural (pendente MSSOT-001):** Scores de compliance devem ser **scoped to primary use case**. Um chatbot que não precisa de cross-session memory (ex: ai-assist de marketplace) não deve ser "penalizado" por não ter.

---

## 14. v2.0 Upgrade Roadmap (2026-04-07)

**Architectural decisions:**
- Vercel AI SDK v4+ is canonical TS adapter (not custom streaming)
- LangGraph is canonical Python orchestrator for agent loops
- JSON Schema source-of-truth for TS↔Python parity (types generated from `packages/shared/contracts/`)
- OpenTelemetry for traces + Supabase for queryable analytics (duals, not competitors)
- Memory is layered: Working → Episodic (AI summary) → Semantic (pgvector) → Entity (facts)

**New modules (M9–M16):**
- M9: Tool Calling & Agent Loop (`runAgentLoop`, lifted from br-acc into shared)
- M10: Structured Output Layer (Zod/Pydantic with auto-retry)
- M11: Multi-modal Message Parts (text/image/file/tool canonical type)
- M12: Conversation Forking & Edit
- M13: Resumable Streams (stream IDs + buffer)
- M14: Eval & Regression Harness (golden set CI gate)
- M15: Dual-Runtime Spec (TS + Python `packages/shared_py/`)
- M16: Agent Handoff Swarm-style (`transfer_to_<agent>` primitive)

**P0 tasks:** CHAT-001..010 in `TASKS.md`

---

---

## 15. `@egos/chatbot-core` — API Reference (2026-04-15)

> **Package:** `packages/chatbot-core/` | **Exported as:** `@egos/chatbot-core`  
> **Status:** Active — replaces duplicated LLM boilerplate across all repos  
> Forja migrated ✅ 2026-04-15. 852/Intelink: see notes below.

### 15.1 `createChatbot(config)` — Full HTTP handler factory

Creates a self-contained chat handler for a Next.js App Router endpoint.

```typescript
import { createChatbot } from '@egos/chatbot-core';

const bot = createChatbot({
  name: 'MyBot',                          // used in logging
  systemPrompt: 'Você é...',             // static string or (ctx) => string
  tools: {                               // optional ToolRegistry
    my_tool: {
      description: 'What the tool does',
      inputSchema: { type: 'object', properties: { q: { type: 'string' } } },
      execute: async ({ q }) => ({ result: '...' }),
    },
  },
  models: {
    primary: {
      modelId: 'google/gemini-2.0-flash-001',
      providerEnvKey: 'OPENROUTER_API_KEY',
      inputCostPerMillion: 0.075,
      outputCostPerMillion: 0.30,
    },
    fallback: {                           // optional — used when primary rate-limits
      modelId: 'qwen-plus',
      providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY',
      baseUrl: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions',
    },
  },
  atrian: {                              // optional — ethical validation
    blockedEntities: ['entity_name'],
    knownAcronyms: ['LGPD', 'CPF'],
  },
  rateLimit: { limit: 12, windowMs: 5 * 60 * 1000 }, // 12 req/5min per IP
});

// In Next.js App Router:
export const POST = bot.streamHandler;   // SSE streaming response
// or:
export const POST = bot.batchHandler;   // JSON batch response
```

**SSE events emitted by `streamHandler`:**

| event | payload | when |
|-------|---------|------|
| `thinking` | `{ status, model }` | start of each request |
| `tool_call` | `{ tool, args }` | before each tool execution |
| `tool_result` | `{ tool, count }` | after tool returns |
| `complete` | `{ reply, toolsUsed, costUsd, rounds }` | final answer ready |
| `error` | `{ message }` | on any failure |

**Frontend consumption:**
```typescript
const res = await fetch('/api/chat', { method: 'POST', body: JSON.stringify({ message: '...' }) });
const reader = res.body!.getReader();
// parse event: type\ndata: json\n\n format
// handle 'complete' event for the final reply
```

---

### 15.2 `fetchWithFailover(payload, models, headers?)` — Low-level LLM call

For projects that need custom HTTP handling (not a plain Next.js endpoint).  
Used internally by `runToolLoop` and exported for direct use (e.g., Forja's runtime wrapper).

```typescript
import { fetchWithFailover } from '@egos/chatbot-core';

const { data, tierUsed } = await fetchWithFailover(
  {
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userMessage },
    ],
    max_tokens: 1200,
    temperature: 0.3,
  },
  {
    primary: { modelId: 'google/gemini-2.0-flash-001', providerEnvKey: 'OPENROUTER_API_KEY' },
    fallback: { modelId: 'qwen-plus', providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY',
                baseUrl: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions' },
  },
  { 'HTTP-Referer': 'https://myapp.com', 'X-Title': 'MyApp' },
);

const reply = (data.choices as any)[0]?.message?.content ?? '';
```

Returns `{ data: Record<string, unknown>, tierUsed: ResolvedTier }`.  
Throws if ALL tiers fail after retries.

---

### 15.3 Conversation utilities

```typescript
import {
  shouldSummarizeConversation,  // (msgs: ConversationMessage[]) => boolean — true if ≥4 messages
  buildConversationTranscript,  // (msgs) => string — last 12 msgs, max 400 chars each
  buildConversationMemoryBlock, // (items: {title?, summary?}[]) => string | null
} from '@egos/chatbot-core';
```

These replace duplicated implementations in Forja/carteira-livre/egos.

---

### 15.4 Adding chatbot-core to a project

**In the project's `package.json`:**
```json
{
  "dependencies": {
    "@egos/chatbot-core": "file:../egos/packages/chatbot-core",
    "@egos/shared": "file:../egos/packages/shared"
  }
}
```

**In `tsconfig.json` (if project is NOT in the egos workspace):**
```json
{
  "compilerOptions": {
    "paths": {
      "@egos/chatbot-core": ["../egos/packages/chatbot-core/src/index.ts"],
      "@egos/shared": ["../egos/packages/shared/src/index.ts"]
    }
  }
}
```

---

### 15.5 Project integration status

| Project | Pattern | Status | Notes |
|---------|---------|--------|-------|
| **@egos/chatbot-core** | Library | ✅ Live | Source of truth |
| **Forja** | `fetchWithFailover` + conv utils | ✅ 2026-04-15 | Full migration blocked: per-request tenant context |
| **carteira-livre** | Manual (duplicated) | Pending | Same pattern as Forja — candidate for same migration |
| **852** | AI SDK v6 streaming | Deferred [P2] | Architecture mismatch; extract model-config to @egos/shared |
| **Intelink** | Telegram bot + OpenAI embeddings | Deferred [P3] | createChatbot HTTP pattern doesn't apply; embeddings not in core |

---

### 15.6 Limitations / Known gaps

- **Per-request tool context** (tenantId, userId): `createChatbot()` takes tools at config time. Multi-tenant apps must create chatbot per-request or use closure workaround.
- **Embeddings**: Not supported. Projects needing embeddings keep OpenAI SDK directly.
- **Streaming token-by-token**: `complete` event sends the full reply at once. Not suitable for UX that requires progressive streaming (like 852's `streamText` pattern).
- **Memory persistence**: `MemoryConfig` is typed but Supabase implementation is planned (not yet built).

---

*"Confiança verificável, não crença cega." — ATRiAN*

---

## 16. Gateway Architecture — Opção C (2026-04-18)

**Decision:** Opção C (Hybrid Gateway) approved via QUORUM (CHAT-GW-001..006).

### 16.1 Architecture Diagram

```
                        ┌─────────────────────────────────────┐
                        │         egos-gateway                │
                        │  POST /api/chat  (CHAT-GW-002)      │
                        │  GET  /api/chatbots (CHAT-GW-003)   │
                        └──────────────┬──────────────────────┘
                                       │
                     reads GATEWAY_REGISTRY env (JSON)
                                       │
               ┌───────────────────────┼───────────────────────┐
               │                       │                       │
     ┌─────────▼──────┐    ┌──────────▼──────┐    ┌──────────▼──────┐
     │  852 chatbot   │    │  forja chatbot  │    │  (future)       │
     │  :3001         │    │  :3002          │    │  :300N          │
     │  /api/chat     │    │  /api/chat      │    │                 │
     │  /api/_internal│    │  /api/_internal │    │                 │
     │  /discover     │    │  /discover      │    │                 │
     └────────────────┘    └─────────────────┘    └─────────────────┘
```

### 16.2 Components Implemented

| Component | File | Status |
|-----------|------|--------|
| Discovery helper (`discoverHandler`) | `packages/chatbot-core/src/discovery.ts` | ✅ CHAT-GW-001 |
| Chat proxy route | `apps/egos-gateway/src/channels/chat.ts` | ✅ CHAT-GW-002 |
| Discovery aggregator | `apps/egos-gateway/src/channels/discover.ts` | ✅ CHAT-GW-003 |
| 852 internal discover | `852/src/app/api/_internal/discover/route.ts` | ✅ CHAT-GW-004 |
| VPS deploy + Caddy route | Pending CHAT-GW-005 | ⏳ P2 |

### 16.3 Routing Logic

1. `POST /api/chat` receives request with optional `use_case` field
2. Gateway reads `GATEWAY_REGISTRY` env (JSON array)
3. Selects chatbot matching `use_case` OR falls back to `default: true` entry
4. Proxies request verbatim (including Auth header) to `<upstream>/api/chat`
5. Streams response back transparently

### 16.4 Opções Rejected

- **Opção A (Monolith):** All chatbots in one process — rejected: cross-project coupling, shared runtime bugs
- **Opção B (Direct routing per-client):** Each client calls chatbot directly — rejected: no centralized auth/rate-limiting
- **Opção C (Hybrid Gateway) ← APPROVED:** Thin stateless proxy + isolated chatbots

---

## 17. Chatbot Integration Protocol (CHATBOT-EVO-INTELINK-001, 2026-04-22)

Contrato que cada chatbot do ecossistema implementa para ser descoberto e roteado pelo gateway. Referência canônica: **intelink** (Next.js 14 / App Router / TS).

### 17.1 Descoberta — `GET /api/internal/discover`

Endpoint público (sem auth) que retorna manifest JSON. Gateway usa em startup e health-check para popular `/api/chatbots`.

**Path decision:** `/api/internal/discover` (NOT `/api/_internal/...`). Folders com prefixo `_` são **private folders** no Next.js App Router e não são roteadas. Evidência: commit `bc56d25` (intelink) + `0e253a6` (gateway) — bug afetava todos chatbots Next.js.

**Response schema** (`ChatbotManifest`):
```typescript
{
  name: string              // Human-readable nome
  slug: string              // Identificador único (intelink, 852, gem-hunter)
  version: string           // SemVer
  description: string
  capabilities: string[]    // ex: ['streaming', 'tool-calling', 'rag', 'memory', 'tenant-isolation']
  use_case: string          // 'police-intelligence', 'osint', 'gem-discovery', etc
  status: 'active' | 'deprecated' | 'experimental'
  model: string             // Model ID atual (ex: 'minimax/minimax-m2.5')
  evidence: {               // Paths canônicos para auditoria (INC-006 anti-phantom)
    chat_route: string
    tools?: string
    memory?: string
    rag?: string
  }
}
```

**Middleware:** `/api/internal` deve estar em `PUBLIC_PATHS` — gateway não envia cookie de auth no discover.

**Honesty rule (INC-006):** Só liste em `capabilities` o que o chatbot efetivamente entrega. Streaming listado sem SSE real = phantom claim.

### 17.2 Chat — `POST /api/chat`

**Request:**
```typescript
{
  messages: Array<{ role: 'user' | 'assistant' | 'system', content: string }>
  // Opcionais — cada chatbot pode aceitar campos extra:
  systemPrompt?: string
  investigationId?: string   // intelink-specific: binds conversation to an investigation
  mode?: string              // intelink: 'single' | 'central'
  sessionId?: string
  saveHistory?: boolean
  behavior?: object          // MACI modulation
}
```

**Response (intelink — JSON, não streaming — 2026-04-22):**
```typescript
{
  response: string
  usage: { prompt_tokens, completion_tokens, total_tokens }
  mode: string
  contextSize: number
  sessionId?: string
  compliance: {
    atrian: { passed, score, violations }
    pii: { findings, summary }
  }
}
```

**Streaming upgrade path (INTELINK-002, pending):** converter para SSE (`Content-Type: text/event-stream`) com chunks `data: <delta>\n\n` e terminator `data: [DONE]\n\n`. Enquanto o chatbot retornar JSON, `streaming` **não deve** estar em `capabilities`.

### 17.3 Auth contract

- Chatbots protegem `/api/chat` com a sua própria auth (JWT cookie, Supabase session, etc).
- Gateway faz proxy transparente do header `Authorization` e cookies — ele não injeta auth próprio.
- Rate-limit pode ser aplicado em ambos (gateway para ataques, chatbot para fair-use por tenant).

### 17.4 Provenance (INTELINK-003, pending)

Todo chatbot que faz tool-calling deve expor `GET /api/chat/:sessionId/provenance` retornando:
```typescript
Array<{
  tool: string
  args_hash: string    // SHA-256 dos args normalizados
  result_hash: string  // SHA-256 do resultado
  source: string       // Ex: 'neo4j:bracc', 'supabase:intelink_investigations'
  ts: string           // ISO-8601
  cost_usd?: number
}>
```

Campo para admissibilidade legal em investigações (intelink) e auditoria de cadeias de consulta.

### 17.5 Reference implementations

| Chatbot | Repo | Discover path | Streaming? | Tools |
|---------|------|---------------|------------|-------|
| **intelink** | `/home/enio/intelink/` | `/api/internal/discover` ✅ | ❌ JSON (INTELINK-002 pending) | 15 |
| **852** | `/home/enio/852/` | `/api/internal/discover` ⚠️ pending fix | ✅ SSE | — |
| **gem-hunter** | `/home/enio/egos/agents/agents/gem-hunter.ts` | Not yet exposed (CHATBOT-EVO-GH-004) | — | — |

852 precisa do mesmo rename `_internal`→`internal` aplicado em intelink (mesmo bug, tracking em task separada).

---

## 18. Local LLM Tier — Intelink Agente Pattern (2026-04-29)

**Reference:** `/home/enio/intelink/lib/intelink-llm-router.ts`

### 18.1 5-Tier Fallback Chain

Padrão canônico para chatbots que precisam de LLM local (custo zero) com fallback robusto:

```typescript
const TIERS = [
  { name: 'local',     endpoint: 'http://localhost:11434',           model: 'intelink-agente-v1' },
  { name: 'vps',       endpoint: 'http://vps-host:11434',            model: 'intelink-agente-v1' },
  { name: 'or-free',   endpoint: 'https://openrouter.ai/api/v1',     model: 'qwen/qwen-2.5-7b-instruct:free' },
  { name: 'or-paid',   endpoint: 'https://openrouter.ai/api/v1',     model: 'google/gemini-2.0-flash-001' },
  { name: 'anthropic', endpoint: 'https://api.anthropic.com/v1',     model: 'claude-haiku-4-5-20251001' },
];
```

**Trigger de fallback:** timeout 30s, HTTP 5xx, ou resposta vazia. Cada tier tenta uma vez antes de descer.

### 18.2 Fine-Tuning Pipeline (Optional)

Se o domínio é especializado o suficiente (ex: linguagem policial PCMG), vale fine-tunar:

| Componente | Path | Responsabilidade |
|-----------|------|------------------|
| Training script | `intelink-agente/scripts/train.py` | QLoRA fine-tuning com PyTorch |
| Dataset | `intelink-agente/data/training_pairs.jsonl` | 76+ pares de instrução/resposta |
| LoRA adapters | `intelink-agente/models/v1/lora_adapters/` | Pesos fine-tunados (~50MB) |
| Eval suite | `intelink-agente/scripts/run_eval.py` | Benchmark contra base model |
| Ollama Modelfile | `intelink-agente/Modelfile` | Empacota base + adapters |

**Custo:** Run #1 do Intelink rodou em 1m13s (Qwen2.5-7B, RTX 5060 Ti, 1 epoch).

### 18.3 Quando usar local LLM

| Caso | Decisão |
|------|---------|
| Dados sensíveis (LGPD, sigilo policial) | **Sim** — não pode sair do servidor |
| Volume alto, queries repetitivas | **Sim** — economia significativa |
| Domínio muito especializado | **Sim** — fine-tuning melhora resposta |
| Generalista (chat aberto) | **Não** — Claude/Gemini são melhores |
| Latência crítica (<500ms) | **Sim** — local elimina round-trip |

### 18.4 Tool-Calling com LLM Local

Modelos pequenos (7B) têm tool-calling fraco. Padrão recomendado:

1. **LLM local** decide intenção → emite `{tool: "buscar", args: {...}}`
2. **Backend** executa tool → retorna resultado
3. **LLM local OU paid tier** sintetiza resposta final
4. Para tools críticas com dados sensíveis: Guard Brasil disponível como módulo opcional de compliance LGPD — ativar quando cliente exigir auditoria formal ou operar em setor regulado (saúde, financeiro, jurídico)

Reference: `intelink/app/api/chat/route.ts` — chat handler com 6 tools (`buscarPessoa`, `getOccurrences`, `getLinks`, `getPhoto`, `criarProposta`, `lerObservacoes`).

### 18.5 Reference Implementation Status

| Capability | 852 | intelink | Notes |
|-----------|-----|----------|-------|
| Streaming SSE | ✅ | ✅ | Both implement SSE per §17.2 |
| ATRiAN validation | ✅ | ✅ | `lib/atrian.ts` |
| PII Scanner | ✅ | ✅ | `lib/pii-scanner.ts` |
| Conversation Memory | ✅ | ✅ | 10-turn rolling window |
| Multi-LLM router | ✅ (3-tier) | ✅ (5-tier) | intelink adds local + VPS |
| Tool-calling | ❌ | ✅ (6 tools) | intelink leads here |
| RAG | ❌ | ✅ | `lib/intelligence/rag-context-retriever.ts` |
| Fine-tuned model | ❌ | ✅ (v1) | Qwen2.5-7B QLoRA |
| Provenance hash chain | ❌ | ✅ | SHA-256 chained audit log |

**Gap closed (2026-05-01):** `packages/shared/src/local-llm-router.ts` ✅ — fábrica genérica `createLocalLLMRouter(config)`. Sem deps de SDK (usa fetch). `intelink-llm-router.ts` é wrapper fino sobre o genérico.

```typescript
import { createLocalLLMRouter } from '@egos/shared';

const route = createLocalLLMRouter({
  localModel: 'forja-agent-v1',
  systemPrompt: 'Você é o assistente Forja...',
  vpsURLEnv: 'FORJA_LLM_VPS_URL',
  vpsTokenEnv: 'FORJA_LLM_VPS_TOKEN',
});

const result = await route([{ role: 'user', content: 'consulta de estoque' }]);
```

### 18.6 Eval-Runner Vendoring Protocol (EVAL-X5)

When a downstream repo (e.g., intelink) needs the eval harness before `@egos/shared` publishes it:

**Pattern: local vendor copy**
```
intelink/
  lib/eval/
    eval-runner.ts   ← vendor copy of packages/shared/src/eval/runner.ts
    golden/
      intelink.ts    ← golden cases specific to intelink chatbot
```

**Rules:**
1. Vendor copy lives at `lib/eval/eval-runner.ts` (NOT in `src/eval/`)
2. Top of file must have: `// VENDORED from @egos/shared — sync on shared update`
3. When `@egos/shared` publishes `eval/runner`, replace vendor with: `export * from '@egos/shared/eval/runner'`
4. Golden cases (`lib/eval/golden/*.ts`) are always repo-specific — never vendored

**Current state (2026-05-02):**
| Repo | Eval harness | Status |
|------|-------------|--------|
| 852 | `src/eval/eval-runner.ts` | Primary implementation, not yet shared |
| intelink | `lib/eval/eval-runner.ts` (if exists) | Vendor copy from 852 |
| @egos/shared | Not yet exported | Pending EVAL-MIGRATE-001 |

---

---

## 19. Memory Tiers — Extended Architecture (NEW 2026-05-21)

> **Status:** PROPOSAL → SHADOW MODE → ATIVAÇÃO pós-Constitution v1.0 (2026-06-12)
> **Premortem:** `docs/audits/premortem-chatbot-hybrid-evolution.md`
> **Substitui §4? NÃO.** §19 **estende** §4 — episodic summaries continuam padrão; tiers superiores são opt-in via `tenant_bot_config.memory_level`.

### 19.1 Motivação

§4 atual entrega memória de sessão única + cross-session via episodic summaries (852 reference). Gaps identificados (audit 2026-05-21):

- Memória entre sessões frágil — só FTS, sem retrieval semântico
- Conversa > 100 msgs perdida (auto-cleanup)
- Sem perfil persistente de usuário/cliente
- Sem core memory editável pelo agente (Letta pattern)

### 19.2 Arquitetura 4-camadas

```
Camada 0 — Working memory  (in-context, últimas N msgs)        [já existe — §4]
Camada 1 — Episodic recall (Supabase FTS, summaries)            [já existe — §4]
Camada 2 — Archival vectors (pgvector, msgs > 7 dias)            [NOVO §19.3]
Camada 3 — Core memory blocks (persona, user_facts, context)     [NOVO §19.4]
```

### 19.3 Archival vectors (Wave 1A)

Tabela `agent_archival_memory`:
```sql
CREATE TABLE agent_archival_memory (
  id uuid PRIMARY KEY,
  workspace_id text NOT NULL,
  tenant_slug text NOT NULL,
  identity_hash text NOT NULL,         -- phone hash / user_id hash
  content text NOT NULL,
  embedding vector(1536),
  source_message_ids uuid[],
  created_at timestamptz DEFAULT now()
);
CREATE INDEX ON agent_archival_memory USING ivfflat (embedding vector_cosine_ops);
```

**Retrieval:** top-k similarity em pgvector + filter por `tenant_slug + identity_hash`. Inject em prompt como `## CONTEXTO HISTÓRICO (sem afirmar como fato presente)`.

**Geração de embeddings:** worker assíncrono, batch nightly. Modelo: `text-embedding-3-small` (OpenAI) ou `gemini-embedding-001`.

### 19.4 Core memory blocks (Wave 1B)

Tabela `agent_memory_blocks`:
```sql
CREATE TABLE agent_memory_blocks (
  id uuid PRIMARY KEY,
  workspace_id text NOT NULL,
  tenant_slug text NOT NULL,
  identity_hash text NOT NULL,
  block_name text NOT NULL,            -- 'persona' | 'user_facts' | 'context'
  content text NOT NULL,
  version int DEFAULT 1,
  updated_at timestamptz DEFAULT now(),
  UNIQUE (tenant_slug, identity_hash, block_name)
);
```

**Pipeline determinístico pós-turn (NÃO agent-driven):**

```
Conversa turn N termina
  ↓
Worker classifier (Gemini Flash 8B dedicado, NOT main LLM)
  ↓
Extrai propostas: { facts_to_add[], persona_updates[], context_refresh? }
  ↓
ATRiAN valida (categoria nova: compliance_critical_omission)
  ↓
Guard Brasil masking
  ↓
Append-only write em agent_memory_blocks (version++)
```

**Justificativa (Codex 2026-05-21):** Letta confia em LLM principal chamando `update_memory_block` — com Gemini Flash, reliability <70%. Pipeline determinístico evita contaminação cross-user e drift de persona.

### 19.5 Configuração por tenant

`tenant_bot_config.memory_level`:
- `0` — só §4 episodic summaries (default, current 852/forja/intelink/carteira-livre)
- `1` — §4 + archival vectors (G Peças pós-Wave 1A)
- `2` — §4 + archival + core blocks (G Peças pós-Wave 1B)
- `3` — full + summarization custom per-tenant (futuro)

**Migration rule:** nunca subir level sem golden cases passando em shadow mode + 7 dias de telemetria estável.

### 19.6 Implementation Checklist

- [ ] Migration `agent_archival_memory` + index
- [ ] Migration `agent_memory_blocks` + UNIQUE constraint
- [ ] Migration `tenant_bot_config.memory_level int DEFAULT 0`
- [ ] Worker `archival-embedder.ts` (batch nightly)
- [ ] Worker `memory-classifier.ts` (per-turn, async)
- [ ] Retrieval helper `getMemoryContext(tenant, identity, level)`
- [ ] ATRiAN category `compliance_critical_omission`
- [ ] Golden cases regression suite (shadow mode)
- [ ] Telemetry: `memory_write_rate`, `archival_retrieval_relevance`, `block_update_count`

---

## 20. Slot-Filling Dialog Manager + Durable HITL (NEW 2026-05-21)

> **Status:** PROPOSAL → Wave 2 (pós-Wave 0+1)
> **Referência:** Botpress v12 slot-filling pattern + pg-boss durable execution
> **Substrate:** Postgres-native (pg-boss). **NÃO usar Inngest** (decisão Codex 2026-05-21).

### 20.1 Motivação

Coleta de dados multi-step hoje (whatsapp.ts lines 1134–1164 G Peças) é hardcoded em if-statements espalhados. HITL com email-aprovação não tem state durável — se Docker reinicia, conversa volta ao zero.

### 20.2 Slot-filling tabela

```sql
CREATE TABLE agent_form_state (
  id uuid PRIMARY KEY,
  workspace_id text NOT NULL,
  tenant_slug text NOT NULL,
  identity_hash text NOT NULL,
  form_name text NOT NULL,             -- 'gpecas_lead', 'consulting_intake', etc.
  current_step int NOT NULL,
  collected_fields jsonb DEFAULT '{}',
  validators jsonb DEFAULT '[]',
  status text DEFAULT 'in_progress',   -- 'in_progress' | 'completed' | 'abandoned'
  resume_token text UNIQUE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
```

### 20.3 Form definition (YAML)

```yaml
# forms/gpecas_lead.yaml
name: gpecas_lead
steps:
  - field: customer_name
    prompt: "Como posso te chamar?"
    validator: { type: name, min: 2, max: 50 }
  - field: vehicle_model
    prompt: "Qual o modelo do seu veículo?"
    validator: { type: text, min: 3 }
  - field: part_needed
    prompt: "Qual peça você procura?"
  - field: contact_phone
    prompt: "Confirma seu telefone para contato?"
    validator: { type: phone_br }
on_complete:
  - action: create_lead
  - action: notify_admin
```

### 20.4 Durable HITL com pg-boss

**Pattern: send-email → wait → resume:**

```typescript
// Tool: request_human_approval(action, payload)
await pgBoss.send('approval-pending', { conversation_id, action, payload, resume_token });
// Conversation pauses; agent_form_state.status = 'awaiting_approval'

// Admin clicks approval link → webhook
await pgBoss.send('approval-received', { resume_token, decision });
// pg-boss worker resumes conversation:
//   - Loads agent_form_state
//   - Injects approval result in context
//   - Continues form flow
```

**pg-boss schemas:** `pgboss.job`, `pgboss.archive`. Idempotency via `singletonKey = resume_token`.

### 20.5 Por que pg-boss (não Inngest, não BullMQ)

| Critério | pg-boss | Inngest | BullMQ |
|---|---|---|---|
| Self-hosted | ✅ Postgres-only | ❌ SaaS | ⚠️ requer Redis |
| Vendor lock-in | Nenhum | Alto | Nenhum (Redis ubíquo) |
| Já temos infra | ✅ Supabase | ❌ | ❌ +Redis |
| Idempotência built-in | ✅ singletonKey | ✅ | ⚠️ manual |
| Maturidade | 5+ anos, 1.5k+ stars | Jovem | Maduro mas Redis-bound |
| Soberania de dados | Total | Cloud SaaS | Total |
| **Decisão** | ✅ | ❌ | ⚠️ futuro se latência ruim |

### 20.6 Implementation Checklist

- [ ] Migration `agent_form_state` + UNIQUE resume_token
- [ ] Setup pg-boss em Supabase (schema `pgboss`)
- [ ] Form loader (YAML → in-memory definitions)
- [ ] Slot-filling DM: `processFormStep(state, userInput) → nextStep`
- [ ] Tool `request_human_approval(action, payload)` no orchestrator
- [ ] Webhook `/api/approvals/:token` (admin clica link → resume)
- [ ] Worker pg-boss `approval-resume` (idempotente, com replay test)
- [ ] Migration G Peças `wa_customers` flow para `agent_form_state` (gradual)
- [ ] Golden case GP-GC-007: data collection with bad input recovery

---

## 21. Observability Foundation (Wave 0 — PROMOTED FROM Wave 3)

> **Status:** PROPOSAL → Wave 0 (PRIMEIRO, antes de qualquer mudança comportamental)
> **Decisão Codex 2026-05-21:** sem baseline = sem causal evidence. Promovida a Wave 0.

### 21.1 Trace ID propagation

Toda conversa recebe `trace_id` (UUID v7) gerado no webhook entry:

```typescript
// channels/whatsapp.ts entry
const traceId = crypto.randomUUID();
context.traceId = traceId;
// Propagado em:
//   - logs (structured)
//   - tool calls
//   - LLM calls (header X-Trace-Id quando possível)
//   - Supabase writes
//   - ATRiAN logs
//   - Guard Brasil logs
```

### 21.2 Structured logging (substitui console.log)

```typescript
// packages/shared/src/logger.ts (new)
log.info({ trace_id, tenant, event: 'tool_call', tool: name, duration_ms, status });
log.error({ trace_id, tenant, event: 'tool_error', tool, error_class, error_message });
log.info({ trace_id, tenant, event: 'llm_call', model, input_tokens, output_tokens, cost_usd });
```

**Output:** JSON em stdout (Docker captura) + persist em `egos_observability_events`.

### 21.3 Prompt snapshots

Tabela `agent_prompt_snapshots`:
```sql
CREATE TABLE agent_prompt_snapshots (
  id uuid PRIMARY KEY,
  trace_id uuid NOT NULL,
  tenant_slug text NOT NULL,
  turn_index int,
  system_prompt text,
  context_messages jsonb,
  tools_offered text[],
  model_used text,
  response_text text,
  tool_calls jsonb,
  created_at timestamptz DEFAULT now()
);
```

Permite reproduzir bug exato: dado `trace_id`, sabemos o prompt completo enviado ao LLM.

### 21.4 Tool-call metrics

Tabela `agent_tool_metrics`:
```sql
CREATE TABLE agent_tool_metrics (
  id uuid PRIMARY KEY,
  trace_id uuid NOT NULL,
  tenant_slug text NOT NULL,
  tool_name text NOT NULL,
  duration_ms int,
  status text,                          -- 'success' | 'error' | 'timeout'
  error_class text,
  retry_count int DEFAULT 0,
  created_at timestamptz DEFAULT now()
);
```

Permite SLO: "tool X p95 latency", "tool Y error rate", "retry budget consumido".

### 21.5 Eval dashboard

Página `/admin/observability/evals` no central-egos-template:
- Golden cases status (passing/failing) por tenant
- ATRiAN score distribution (heatmap)
- Memory write rate (vs target 70%)
- Tool error rate (vs SLO)
- Trace search por `trace_id` ou `tenant + date range`

### 21.6 Implementation Checklist (Wave 0 — 1 semana, isolada)

- [ ] Migration `egos_observability_events`, `agent_prompt_snapshots`, `agent_tool_metrics`
- [ ] `packages/shared/src/logger.ts` (structured logging)
- [ ] Trace ID propagation em `channels/whatsapp.ts`, `channels/telegram.ts`, `orchestrator.ts`
- [ ] Prompt snapshot middleware (após cada `runModel`)
- [ ] Tool metrics middleware (wrap `dispatchTool`)
- [ ] Dashboard `/admin/observability/evals` (read-only, basic)
- [ ] Retention policy (snapshots = 30d, metrics = 90d, events = 14d)

---

## 22. Decisões locked (2026-05-21 — pós-premortem + Codex)

| # | Decisão | Razão | Fonte |
|---|---|---|---|
| D1 | **NÃO** adotar Mastra/LangGraph wholesale | Lock-in + 40-50% rewrite + API churn | Audit 2026-05-21 |
| D2 | **NÃO** usar Inngest | SaaS vendor lock-in conflita com soberania EGOS | Codex 2026-05-21 |
| D3 | **NÃO** confiar em LLM agent-driven memory writes | Gemini Flash reliability <70%; cross-user contamination risk | Codex 2026-05-21 |
| D4 | **SIM** pg-boss para durable HITL | Postgres-native; já temos infra; battle-tested | Codex 2026-05-21 |
| D5 | **SIM** pipeline determinístico pós-turn para memory writes | Append-only + ATRiAN + Guard Brasil antes de persistir | Codex 2026-05-21 |
| D6 | **SIM** Observability FIRST (Wave 0) | Sem baseline = sem causal evidence | Codex 2026-05-21 |
| D7 | **SIM** Additive-only com `memory_level` feature flag | 852/forja/intelink default 0 (current); G Peças sandbox | Premortem F5 |
| D8 | **SIM** Shadow mode até Constitution v1.0 (2026-06-12) | Evitar regressão pré-lock | Premortem F1+F10 |
| D9 | **SIM** ATRiAN aplicado em summaries também | Categoria nova `compliance_critical_omission` | Premortem F8 |
| D10 | **SIM** WIP=1 por wave, hard cap 2 semanas | Anti scope-creep | Premortem F7 |

---

*Last updated: 2026-05-21 (§19 Memory Tiers + §20 Slot-Filling + §21 Observability + §22 Decisões locked — premortem + Codex review)*
