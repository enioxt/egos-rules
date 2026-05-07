# EGOS Capability Registry

<!-- llmrefs:start -->
## LLM Reference Signature

- **Role:** capability map + adoption matrix for reusable EGOS surfaces
- **Summary:** Canonical registry of capabilities by domain, with SSOT source, quality, adoption, and rollout targets.
- **Read next:**
  - `TASKS.md` — execution priorities and gaps
  - `docs/SSOT_REGISTRY.md` — ownership/freshness contracts
  - `docs/SYSTEM_MAP.md` — architecture placement of capabilities
<!-- llmrefs:end -->

> **VERSION:** 1.11.0 | **UPDATED:** 2026-05-01
> **PURPOSE:** Master index of all capabilities across the EGOS ecosystem
> **SSOT STATUS:** This file IS the canonical capability map
> **LATEST:** Timeline Publishing Pipeline, Rich Article Rendering, AI Discovery Layer, Timeline KB Sync (§23)

<!-- llmrefs:start -->

## LLM Reference Signature

- **Role:** Master capability inventory for EGOS ecosystem
- **Summary:** Cross-repo SSOT for all reusable capabilities (chatbot, security, integration, AI). Quality-rated and adoption-mapped.
- **Read next:**
  - `SSOT_REGISTRY.md` — which capabilities are canonical vs local
  - `docs/modules/CHATBOT_SSOT.md` — chatbot-specific standards
  - `TASKS.md` — what capabilities are in-flight or blocked
  - `/start` activation flow — how to use this registry during onboarding

<!-- llmrefs:end -->

---

## How to Read This Registry

Each capability has:
- **SSOT**: The canonical source (best implementation)
- **Quality**: A/B/C rating (A = production-proven, B = functional, C = prototype)
- **Adopted By**: Repos currently using it
- **Should Adopt**: Repos that would benefit from adoption
- **Tags**: For filtering and cross-referencing

---

## By Repo Group (Quick Navigation)

> Added 2026-04-15 (REPO-MAP-005). Cross-reference: which capabilities are primary for each repo group.

| Repo Group | Primary Capabilities | Registry Sections |
|-----------|---------------------|------------------|
| **PRODUCTION: guard-brasil** | PII Scanner (Brazilian), ATRiAN Ethical Validation, Guard Brasil Stack | §1 Guard Brasil Stack, §3 Auth |
| **PRODUCTION: forja** | Modular Prompt Architecture, Task-Based Model Routing, WhatsApp Integration, Chatbot Core (fetchWithFailover) | §1, §9, §12c |
| **PRODUCTION: 852** | Conversation Memory, AI Conversation Review, Gamification, Chatbot Core | §1, §8 |
| **PRODUCTION: gem-hunter** | AI Discovery Layer, GitHub/HF/npm scanning, Gem Hunter API tiers | §2, §11 |
| **PRODUCTION: egos-gateway** | Hono REST API, x402 micropayments, OAS 3.1, Health monitor | §6, §15 |
| **PLATFORM: egos (kernel)** | Agent Runtime, Governance Pipeline, SSOT system, MCP servers, Evidence Gate | §4, §5, §5b |
| **PLATFORM: egos-hq** | Mission Control UI, Claude Code tooling, Dashboards | §14 |
| **ACTIVE-DEV: egos-inteligencia** | Entity extraction, Neo4j 83.7M nodes, NER PT-BR, Cross-reference engine | §12b |
| **ABSORBING: policia** | Groq transcription, Investigation templates, Intelink integration | §12b |
| **ABSORBING: br-acc** | Neo4j graph source, FastAPI OSINT, 18 routers | §12b |

---

## 1. CHATBOT & CONVERSATION

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Modular Prompt Architecture | `egos/docs/modules/CHATBOT_SSOT.md` | A | 852, intelink, forja, egos-web | carteira-livre, br-acc | `chatbot`, `prompt`, `composable`, `ssot` |
| ATRiAN Ethical Validation | `egos/packages/shared/src/atrian.ts` | A | 852 (origin), egos, intelink, carteira-livre, forja, egos-web, br-acc | — | `chatbot`, `ethics`, `validation`, `atrian` |
| PII Scanner (Brazilian) | `egos/packages/shared/src/pii-scanner.ts` | A | 852 (origin), egos, intelink, carteira-livre, forja, egos-web, br-acc | — | `chatbot`, `privacy`, `lgpd`, `pii` |
| Conversation Memory | `egos/packages/shared/src/conversation-memory.ts` | A | 852 (origin), egos, intelink, carteira-livre, forja, egos-web, br-acc | — | `chatbot`, `memory`, `context` |
| Task-Based Model Routing | `852/src/lib/ai-provider.ts` | A | 852, intelink, carteira-livre, forja, egos-web (basic) | br-acc | `chatbot`, `ai`, `routing`, `cost` |
| AI Conversation Review | `852/src/app/api/review/route.ts` | A | 852 | forja | `chatbot`, `review`, `quality` |
| Smart Correlation Engine | `852/src/app/api/correlate/route.ts` | A | 852 | forja, intelink | `chatbot`, `correlation`, `ai` |
| Chat Streaming (Vercel AI SDK) | `852/src/app/api/chat/route.ts` | A | 852, intelink | forja | `chatbot`, `streaming`, `api` |
| Export (PDF/DOCX/MD/WhatsApp) | `852/src/components/chat/ExportMenu.tsx` | A | 852 | forja, intelink | `chatbot`, `export`, `pdf` |
| Hot Topics / Trending | `852/src/app/api/hot-topics/route.ts` | A | 852 | — | `chatbot`, `community`, `engagement` |
| Tool-Calling Chat (27 tools) | `br-acc/api/src/bracc/routers/chat.py` | A | br-acc | forja (adapted) | `chatbot`, `tools`, `python` |
| Public Guard / LGPD Masking (Python) | `br-acc/api/src/bracc/services/public_guard.py` | A | br-acc | forja | `privacy`, `lgpd`, `masking` |
| **Public Guard BR (TypeScript)** | `egos/packages/shared/src/public-guard.ts` | A | egos | carteira-livre, forja, egos-web | `privacy`, `lgpd`, `masking`, `guard-brasil` |
| **Guard Brasil Python SDK** | `br-acc/etl/src/bracc_etl/guard.py` | B | br-acc | — | `privacy`, `lgpd`, `pii`, `python`, `etl`, `guard-brasil` |
| **Evidence Chain** | `egos/packages/shared/src/evidence-chain.ts` | A | egos | 852, forja, br-acc | `evidence`, `traceability`, `audit`, `guard-brasil` |
| **Activation Audit Logger** | `egos/packages/audit/src/activation-audit.ts` | A | egos | — | `audit`, `mcp`, `compliance`, `activation` |

| **GuardBrasil Facade** | `egos/packages/guard-brasil/src/guard.ts` | A | egos | 852, forja, br-acc | `guard-brasil`, `facade`, `lgpd`, `sdk` |
| **PRI Safety Gate (Guard Brasil REST/MCP)** | `egos/packages/core/src/guards/pri.ts` + `egos/apps/api/src/server.ts` | B | egos | 852, forja, br-acc | `guard-brasil`, `pri`, `safety`, `privacy` |

### Guard Brasil Stack

> **EGOS Guard Brasil** (`@egosbr/guard-brasil` v0.2.3) — ATRiAN + PII Scanner + Public Guard + Evidence Chain.
> **16 PII patterns:** CPF, CNPJ, RG, CNH, SUS, NIS/PIS, MASP, REDS, Processo, Placa (2), Email, Telefone, Título de Eleitor, CEP, **Dado de Saúde** (LGPD art.11)
> **Name detection:** Detects person names after 12 context labels (Nome:, Paciente:, Requerente:, etc.)
> Package: `packages/guard-brasil/` | Product brief: `docs/strategy/FLAGSHIP_BRIEF.md`
> Demo: `bun run packages/guard-brasil/src/demo.ts`
> Tests: 20/20 pass (`bun test packages/guard-brasil/src/guard.test.ts`)
>
> **⚠️ Posicionamento:** Módulo **OPCIONAL** de compliance LGPD — não é pré-requisito de venda. Ativar para setores regulados (saúde, financeiro, jurídico, governo) ou quando cliente exigir auditoria formal. Ver: `docs/strategy/GUARD_BRASIL_POSITIONING.md`

| **Chatbot Gateway (Hybrid)** | `egos-gateway/src/routes/chat.ts` *(PLANNED — CHAT-GW-002)* | C | — | 852, forja | `chatbot`, `gateway`, `routing`, `proxy` |
| **Chatbot Discovery Endpoint** | `egos/packages/chatbot-core/src/discovery.ts` *(PLANNED — CHAT-GW-001)* | C | — | forja, 852 | `chatbot`, `discovery`, `registry` |

### Canonical Standard

> **`egos/docs/modules/CHATBOT_SSOT.md`** — Every chatbot MUST follow this spec. Architecture: Opção C (Hybrid Gateway) — stateless proxy → independent chatbots.

---

## 2. AI & LLM INFRASTRUCTURE

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **Google AI (Gemini 2.5 Flash)** | `egos/packages/chatbot-core/src/google-ai-provider.ts` | A | egos | 852, forja, intelink | `ai`, `gemini`, `google`, `llm` |
| Multi-LLM Provider (TS) | `egos/packages/shared/src/llm-provider.ts` | A | egos, egos-lab | 852 (has own) | `ai`, `provider`, `shared` |
| DashScope Fallback Chain | `egos/packages/shared/src/llm-provider.ts` | A | egos, egos-lab | 852, forja | `ai`, `dashscope`, `fallback` |
| qwq-plus Reasoning Tier | `egos/packages/shared/src/llm-provider.ts` | A | egos | ALL (deep tasks) | `ai`, `reasoning`, `qwq` |
| AI Coverage Map | `egos/docs/AI_COVERAGE_MAP.md` | A | egos | — | `ai`, `coverage`, `telemetry` |
| AI Coverage Scanner | `egos/scripts/ai-coverage-scan.ts` | A | egos | — | `ai`, `scan`, `pre-commit` |
| AI Client (OpenRouter) | `egos-lab/packages/shared/src/ai-client.ts` | A | egos-lab, telegram-bot | forja | `ai`, `client`, `openrouter` |
| Rate Limiter (shared) | `egos-lab/packages/shared/src/rate-limiter.ts` | A | egos-lab | forja | `ai`, `rate-limit`, `shared` |
| Cost Tracking (per-request) | `852/src/lib/ai-provider.ts` | A | 852 | ALL | `ai`, `cost`, `budget` |
| Budget Mode (conservative/balanced) | `852/src/lib/ai-provider.ts` | A | 852 | forja | `ai`, `cost`, `config` |
| Prompt System (meta-prompts) | `.guarani/prompts/PROMPT_SYSTEM.md` | B | egos | egos-lab | `ai`, `prompt`, `meta` |
| Licitação Taxonomy | `egos-lab/eagle-eye/src/types.ts` | A | eagle-eye | — | `ai`, `procurement`, `taxonomy` |

---

## 3. AUTHENTICATION & IDENTITY

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Anonymous Identity (nicknames) | `852/src/lib/nickname-generator.ts` | A | 852 | — | `auth`, `anonymous`, `privacy` |
| AI Name Validator | `852/src/lib/name-validator.ts` | A | 852 | — | `auth`, `privacy`, `ai` |
| PBKDF2 + Supabase Sessions | `852/src/lib/user-auth.ts` | A | 852 | — | `auth`, `supabase`, `sessions` |
| MASP Registration Flow | `852/src/app/api/auth/register/route.ts` | A | 852 | — | `auth`, `registration`, `domain` |
| Supabase Auth (GoTrue) | `carteira-livre/services/api-utils.ts` | A | carteira-livre | forja | `auth`, `supabase`, `rbac` |
| Admin Auth | `852/src/lib/admin-auth.ts` | B | 852 | — | `auth`, `admin` |

---

## 4. GOVERNANCE & SSOT

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Governance Symlink Converter (legacy) | `~/.egos/governance-symlink.sh` | C | Manual cleanup only | — | `governance`, `symlink`, `legacy` |
| Governance Sync Plane | `egos/scripts/governance-sync.sh` + `~/.egos/sync.sh` | A | Kernel + synced leaves | — | `governance`, `sync`, `ssot` |
| SSOT Registry | `egos/docs/SSOT_REGISTRY.md` | A | egos (canonical) | ALL | `governance`, `ssot`, `registry` |
| Pre-commit Drift Detection | `.husky/pre-commit` | A | carteira-livre, forja | — | `governance`, `drift`, `hooks` |
| CRCDM Universal Hook | `scripts/hooks/crcdm-pre-commit.sh` → `~/.egos/hooks/pre-commit` | A | ALL (symlink) | — | `governance`, `security`, `crcdm`, `hooks` |
| Cross-Repo Health Dashboard | `egos/scripts/egos-repo-health.sh` | A | egos (run before installers) | — | `observability`, `governance`, `git` |
| **MANUAL_ACTIONS Tracker** | `egos/MANUAL_ACTIONS.md` | A | egos (wired into /start INTAKE) | ALL | `governance`, `manual`, `blocker`, `gtm` |
| Context Persistence (Fibonacci) | `scripts/context-manager.ts` + `/snapshot` command | A | ALL (9 repos) | — | `context`, `session`, `persistence` |
| Secret Leak Detection | `.gitleaks.toml` + CRCDM hook regex | A | ALL | — | `security`, `secrets`, `compliance` |
| Context Tracker | `egos/agents/agents/context-tracker.ts` | A | egos | ALL | `governance`, `context`, `observability` |
| SSOT Drift Check | `egos-lab/scripts/ssot-drift-check.ts` | A | egos-lab | — | `governance`, `drift`, `api` |
| API Registry Check | `egos-lab/scripts/ssot-api-registry-check.ts` | A | egos-lab | — | `governance`, `api`, `drift` |
| Orchestration Pipeline (7-phase) | `.guarani/orchestration/PIPELINE.md` | A | ALL | — | `governance`, `pipeline`, `frozen` |
| Frozen Zones | `egos/.windsurfrules` | A | ALL | — | `governance`, `frozen`, `security` |
| **SSOT Visit Protocol v2** | `.guarani/orchestration/DOMAIN_RULES.md §7` | A | egos (kernel law) | ALL | `governance`, `ssot`, `cross-repo`, `intra-repo` |
| ~~Agent Claim Contract~~ | ~~`.guarani/orchestration/AGENT_CLAIM_CONTRACT.md`~~ | ARCHIVED | egos | — | replaced by `AGENTS.md §R2` |
| **Agent Claim Linter** | `scripts/agent-claim-lint.ts` | A | egos | egos-lab | `governance`, `agent`, `lint`, `ci` |
| **Ecosystem Classification Registry** | `docs/ECOSYSTEM_CLASSIFICATION_REGISTRY.md` | A | egos | ALL | `governance`, `classification`, `ssot` |
| **Workflow Inheritance Report** | `docs/WORKFLOW_INHERITANCE_REPORT.md` | B | egos | — | `governance`, `workflow`, `inheritance` |
| **Workflow Sync Check** | `scripts/workflow-sync-check.sh` | B | egos | ALL | `governance`, `workflow`, `drift` |
| ~~Clarity Review Gate~~ | ~~`.guarani/orchestration/CLARITY_REVIEW.md`~~ | ARCHIVED | egos | — | `governance`, `review`, `monthly` |
| **Mycelium Truth Report** | `docs/MYCELIUM_TRUTH_REPORT.md` | A | egos | — | `governance`, `mycelium`, `audit` |
| **LLM Orchestration Matrix** | `.guarani/orchestration/LLM_ORCHESTRATION_MATRIX.md` | A | egos | ALL | `ai`, `orchestration`, `routing` |
| ~~Benchmark Enforcement~~ | ~~`.guarani/orchestration/BENCHMARK_ENFORCEMENT.md`~~ | ARCHIVED | egos | — | `governance`, `multi-agent`, `enforcement` |
| ~~QA Loop Contract~~ | ~~`.guarani/orchestration/QA_LOOP_CONTRACT.md`~~ | ARCHIVED | egos | — | `governance`, `qa`, `contract` |
| **Operator Map** | `docs/OPERATOR_MAP.md` | A | egos | — | `governance`, `control-plane`, `founder` |
| **Kernel Consolidation Plan** | `docs/KERNEL_CONSOLIDATION_PLAN.md` | A | egos | — | `governance`, `consolidation`, `migration` |
| **SSOT Registry v2** | `docs/SSOT_REGISTRY.md` | A | egos | ALL | `governance`, `ssot`, `30-domains` |
| **Injection Hardening Contract** | `.guarani/security/INJECTION_HARDENING.md` | B | egos | ALL | `security`, `injection`, `hardening` |
| **File Intelligence** | `scripts/file-intelligence.sh` | B | egos | ALL | `governance`, `compliance`, `pre-commit`, `classification` |
| **Rules Index** | `.guarani/RULES_INDEX.md` | A | egos | ALL | `governance`, `rules`, `discovery`, `ssot` |

---

## 5. AGENT RUNTIME

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Agent Runner | `egos/agents/runtime/runner.ts` | A | egos (FROZEN) | — | `agent`, `runtime`, `frozen` |
| Event Bus | `egos/agents/runtime/event-bus.ts` | A | egos (FROZEN) | — | `agent`, `events`, `frozen` |
| Agent Registry | `egos-lab/agents/registry/agents.json` | A | egos-lab (29) | egos (2) | `agent`, `registry`, `ssot` |
| Agent CLI | `egos-lab/agents/cli.ts` | A | egos-lab | egos | `agent`, `cli` |
| Worker Infrastructure | `egos-lab/agents/worker/` | B | egos-lab (Railway) | — | `agent`, `worker`, `infra` |
| **Circuit Breaker** | `egos/packages/shared/src/circuit-breaker.ts` | A | egos | ALL | `resilience`, `circuit-breaker`, `shared` |
| **Mycelium Redis Bridge** | `egos/packages/shared/src/mycelium/redis-bridge.ts` | B | egos (scaffold) | egos-lab | `mycelium`, `redis`, `pubsub`, `bridge` |
| **Event Bus (Supabase Realtime)** | `egos/packages/shared/src/event-bus.ts` | B | egos | egos-lab, 852 | `agent`, `events`, `supabase`, `coordination` |
| **MasterOrchestrator** | `egos-lab/agents/agents/master-orchestrator.ts` | B | egos-lab | egos | `agent`, `orchestrator`, `scheduling`, `quota` |

## 5b. MCP SERVERS

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **MCP Governance** | `egos/packages/mcp-governance/src/index.ts` | B | egos | ALL | `mcp`, `governance`, `ssot`, `drift` |
| **MCP Memory** | `egos/packages/mcp-memory/src/index.ts` | B | egos | ALL | `mcp`, `memory`, `recall`, `store` |

---

## 6. DEPLOYMENT & INFRA

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Docker + Caddy + VPS | `852/docker-compose.yml` | A | 852, br-acc | forja | `deploy`, `docker`, `vps` |
| **Guard Brasil REST API** | `egos/apps/api/src/server.ts` + `apps/api/deploy.sh` | A | egos (LIVE: guard.egos.ia.br) | — | `deploy`, `docker`, `guard-brasil`, `api` |
| **Guard Brasil MCP Server** | `egos/apps/api/src/mcp-server.ts` | A | egos (stdio JSON-RPC 2.0) | — | `deploy`, `mcp`, `guard-brasil` |
| One-Command Release | `852: npm run release:prod` | A | 852 | forja | `deploy`, `release`, `automation` |
| Vercel Auto-Deploy | `egos-lab/apps/egos-web` | A | egos-lab | — | `deploy`, `vercel` |
| Brand Import (Stitch) | `852: npm run brand:import` | B | 852 | — | `deploy`, `assets`, `stitch` |
| Smoke Tests (curl) | `852: npm run smoke:public` | A | 852 | ALL VPS projects | `deploy`, `smoke`, `testing` |
| egos-site deploy + network attach | `egos/infra/egos-site/deploy.sh` | A | egos (LIVE: egos.ia.br) | — | `deploy`, `docker`, `caddy` |
| egos-site health monitor (cron 5min) | `egos/infra/egos-site/health-monitor.sh` | A | egos (cron on VPS) | — | `deploy`, `monitor`, `auto-recovery` |

---

## 7. TELEMETRY & OBSERVABILITY

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Dual Telemetry (logs + Supabase) | `852/src/lib/telemetry.ts` | A | 852 | forja | `telemetry`, `logging`, `supabase` |
| Microsoft Clarity | `852/src/components/ClarityAnalytics.tsx` | A | 852, egos-lab | forja | `telemetry`, `analytics` |
| ATRiAN Violations Dashboard | `852/src/app/admin/telemetry/page.tsx` | A | 852 | — | `telemetry`, `atrian`, `admin` |
| Activity Feed | `br-acc/api/src/bracc/routers/activity.py` | A | br-acc | forja | `telemetry`, `feed`, `audit` |
| Rho Health Score | `egos-lab/scripts/rho.ts` | B | egos-lab | egos | `telemetry`, `health`, `score` |

---

## 8. GAMIFICATION & ENGAGEMENT

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Points + Ranks (Recruta-Comissario) | `852/src/lib/gamification.ts` | A | 852 | — | `gamification`, `ranks`, `engagement` |
| Leaderboard API | `852/src/app/api/leaderboard/route.ts` | A | 852 | — | `gamification`, `leaderboard` |
| Voting (issues upvote/downvote) | `852/src/app/issues/page.tsx` | A | 852 | — | `gamification`, `voting`, `community` |

---

## 9. WHATSAPP & MESSAGING

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **WhatsApp Integration Architecture** | `egos/docs/knowledge/WHATSAPP_SSOT.md` | A | forja | 852, carteira-livre | `whatsapp`, `architecture`, `ssot` |
| **Multi-Channel Runtime Pattern** | `egos/docs/knowledge/WHATSAPP_SSOT.md` | A | forja | ALL | `whatsapp`, `multi-channel`, `runtime` |
| **Evolution API Deployment** | `egos/docs/knowledge/WHATSAPP_SSOT.md` | A | forja | ALL | `whatsapp`, `evolution`, `docker` |
| **QR Drift Recovery Protocol** | `egos/docs/knowledge/WHATSAPP_SSOT.md` | A | forja | ALL | `whatsapp`, `recovery`, `qr` |
| **WhatsApp Runtime Distribution Bundle** | `egos/integrations/distribution/whatsapp-runtime/` | A | egos | forja, 852, carteira-livre | `whatsapp`, `distribution`, `bundle` |
| **Integration Memory Pattern** | `forja/docs/INTEGRATIONS_MEMORY.md` | A | forja | ALL | `infrastructure`, `memory`, `ssot` |
| Evolution API Client | `carteira-livre/services/whatsapp/evolution-api.ts` | B | carteira-livre | — | `whatsapp`, `client`, `legacy` |
| WhatsApp Notification Service | `forja/src/lib/whatsapp/notifications.ts` | A | forja | 852, carteira-livre | `whatsapp`, `notifications`, `templates` |
| WhatsApp Webhook Handler | `forja/src/app/api/notifications/whatsapp/route.ts` | A | forja | 852, carteira-livre | `whatsapp`, `webhook`, `api` |
| WhatsApp Sharing | `852/src/components/chat/ExportMenu.tsx` | A | 852 | — | `whatsapp`, `sharing` |
| Telegram Bot | `egos-lab/apps/telegram-bot/` | B | egos-lab | — | `telegram`, `bot` |
| Notifications (webhook/Telegram) | `852/src/lib/notifications.ts` | B | 852 | forja | `notifications`, `webhook` |

### WhatsApp Integration Stack (2026-03-30)

> **Canonical Architecture:** Hetzner VPS as runtime SSOT → Evolution API (single deployment) → One instance per product/channel → Vercel app for webhooks → Supabase for audit → Redis for queue (future).
>
> **Philosophy:** WhatsApp as workflow surface (alerts, confirmations, status), NOT open-chat platform.
>
> **Validated:** forja-notifications (state: open, 2026-03-30)
>
> **Complete Guide:** `egos/docs/knowledge/WHATSAPP_SSOT.md`

---

## 10. DATA & SEARCH

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| Supabase + RLS Pattern | `852/sql/schema.sql` | A | 852, carteira-livre | forja | `database`, `rls`, `supabase` |
| Evidence Chain (audit trail) | `br-acc/api/src/bracc/routers/chat.py` | A | br-acc | forja | `audit`, `evidence`, `compliance` |
| Redis Cache Layer | `br-acc/api/src/bracc/services/cache.py` | A | br-acc | forja | `cache`, `redis` |
| pgvector RAG | — (planned for Forja) | C | — | forja | `rag`, `vector`, `search` |

---

## 11. DOCUMENTATION & KNOWLEDGE

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| ~~Integration Release Contract~~ | ~~`egos/.guarani/orchestration/INTEGRATION_RELEASE_CONTRACT.md`~~ | ARCHIVED | egos | — | replaced by `bun run integration:check` + manifests |
| Chatbot Production Playbook | `852/docs/CHATBOT_PRODUCTION_REVERSE_ENGINEERING.md` | A | 852 | ALL new chatbots | `docs`, `playbook`, `deploy` |
| Archaeology Digger Agent | `egos/agents/agents/archaeology-digger.ts` | A | egos | egos-lab | `docs`, `archaeology`, `agent` |
| Evolution Tree (interactive) | `egos/docs/evolution-tree.html` | A | egos | — | `docs`, `visualization`, `history` |
| Mycelium Architecture | `egos/docs/concepts/mycelium/` | A | egos | — | `docs`, `architecture`, `mycelium` |
| **Knowledge System (wiki)** | `egos/agents/agents/wiki-compiler.ts` + `docs/knowledge/` | A | egos | — | `docs`, `wiki`, `knowledge`, `supabase` |
| **HARVEST.md Patterns** | `egos/docs/knowledge/HARVEST.md` | A | egos | ALL | `docs`, `patterns`, `learnings` |

---

## 12. GTM & COMMERCIAL

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **Partnership Strategy** | `egos/docs/strategy/PARTNERSHIP_STRATEGY.md` | B | egos | — | `gtm`, `partners`, `distribution` |
| **Outreach Email Templates** | `egos/docs/business/OUTREACH_EMAIL_TEMPLATES.md` | B | egos | — | `gtm`, `outreach`, `lgpd` |
| **X.com Reply Bot** | `egos/scripts/x-reply-bot.ts` (VPS cron hourly) | A | egos | — | `gtm`, `x.com`, `social`, `bot` |
| **Rapid Response Thread** | `egos/scripts/rapid-response.ts` | B | egos | — | `gtm`, `x.com`, `thread`, `showcase` |
| **Gem Hunter Partner Track** | `docs/gem-hunter/SSOT.md` → partner/community track | C | egos (planned) | — | `gtm`, `gem-hunter`, `discovery` |

---

## 12b. INTELLIGENCE & INVESTIGATION (Intelink Harvest 2026-04-14)

> **Origem:** Audit completo do `/home/enio/egos-inteligencia/` — 27 routers, 90+ endpoints, 138 componentes, 48 queries Cypher.
> **Status:** capabilities funcionais em intelink; registry para adoção em outros repos e extração como packages.
> **Priorização:** P0 = disseminar como regra | P1 = extrair como package | P2 = manter no intelink e documentar.

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **Pramana Confidence System** (Fact/Inference/Disputed/Unknown) | `egos-inteligencia/frontend/src/lib/intelligence/confidence-system.ts` | A | egos-inteligencia | egos (rule global), guard-brasil, gem-hunter, 852 | `epistemology`, `trust`, `ui`, `evidence`, `pramana` |
| **Sacred Math Scoring** (razão áurea φ para confidence) | `egos-inteligencia/api/src/egos_inteligencia/services/patterns/pattern_detector.py` | A | egos-inteligencia | egos (extract to package), gem-hunter | `scoring`, `pattern-detection`, `phi`, `fibonacci` |
| **Tool-Calling Loop Pattern** (8-round + cost tracking + OpenAI schema) | `egos-inteligencia/api/src/egos_inteligencia/routers/chat.py` | A | egos-inteligencia | 852, forja (agents), egos (rule) | `chatbot`, `tools`, `cost`, `agents` |
| **BYOK Pattern** (x-openrouter-key header) | `egos-inteligencia/api/src/egos_inteligencia/routers/chat.py` | A | egos-inteligencia | 852, forja | `ai`, `byok`, `provider`, `tiered-access` |
| **Circuit Breaker (host-level)** | `egos-inteligencia/api/src/egos_inteligencia/services/circuit_breaker.py` | A | egos-inteligencia | ALL (external APIs) | `resilience`, `fallback`, `external-api` |
| **Investigation Templates (5 domains)** | `egos-inteligencia/api/src/egos_inteligencia/services/investigation_templates.py` | A | egos-inteligencia | egos (KB-as-a-Service) | `templates`, `cypher`, `kb`, `consultoria` |
| **Cross-Reference Engine (6 levels)** | `egos-inteligencia/api/src/egos_inteligencia/services/cross_reference_engine.py` | A | egos-inteligencia | — (domain-specific) | `dedup`, `jaro-winkler`, `similarity`, `graph` |
| **BERTimbau NER (PT-BR legal)** | `egos-inteligencia/api/src/egos_inteligencia/services/nlp/bertimbau_ner.py` | A | egos-inteligencia | forja, 852 (via API) | `ner`, `portuguese`, `bert`, `legal` |
| **Journey System (record + replay)** | `egos-inteligencia/frontend/src/providers/JourneyContext.tsx` | B | egos-inteligencia | egos (abstract as "Session Replay") | `audit`, `replay`, `investigation`, `workflow` |
| **CRDT Offline-First (RxDB + Automerge + AES-256-GCM)** | `egos-inteligencia/apps/web/lib/db/` | A | egos-inteligencia (apps/web) | — (field-ops specific) | `offline`, `crdt`, `encryption`, `pbkdf2` |
| **31-Tool Transparency Suite** (Brazilian gov data) | `egos-inteligencia/api/src/egos_inteligencia/services/transparency_tools.py` | A | egos-inteligencia | 852 (subset via chat), br-acc | `osint`, `transparency`, `cnpj`, `datajud` |
| **Graph Algorithms Library** (BFS, centrality, DFS) | `egos-inteligencia/frontend/src/lib/intelligence/graph-algorithms.ts` | B | egos-inteligencia | egos (extract to package) | `graph`, `algorithms`, `bfs`, `centrality` |

### Intelink Framework — Consultoria Track

> **Propósito:** Extrair capabilities universais como packages `@egos/*` para uso em consultorias de KB + agentes para terceiros.
> **Plano de extração:** ver `TASKS.md` track `🧬 INTELINK HARVEST`.

### Intelink Capacidades Únicas (Audit 2026-05-05)

> **Origem:** CAPABILITY_INDEX.md auditado e commitado em `intelink/CAPABILITY_INDEX.md`
> **Evidências:** file:line verificadas no código real

| Capability | SSOT | Quality | Tags |
|-----------|------|---------|------|
| **Rho Governance** (anti-tunnel vision, centralização max 10%) | `intelink/lib/rho-governance.ts` | A | `governance`, `graph`, `bias-detection` |
| **Adamic-Adar Link Prediction** (ML análise de rede criminal) | `intelink/lib/intelligence/graph-algorithms.ts` | A | `algorithms`, `network-analysis`, `ml` |
| **Reconhecimento Facial** (face embedding + busca comparativa) | `intelink/app/api/face/embed/route.ts` | B | `face-recognition`, `biometrics` |
| **OCR Tesseract.js** (PNG/JPG/PDF → texto) | `intelink/app/api/ocr/route.ts` | A | `ocr`, `document-processing` |
| **Dedup multi-nível 6-tier** (Jaro-Winkler + Soundex + Levenshtein + CPF + placa) | `intelink/lib/entity-resolution/matcher.ts` | A | `dedup`, `entity-resolution` |
| **Pipeline NER em massa (Ollama)** (batch local/VPS) | `intelink/scripts/ner-mass-run.sh` | B | `nlp`, `batch`, `local-llm` |
| **Cross-case analysis** (entidades em múltiplas operações) | `intelink/lib/intelligence/cross-case-utils.ts` | A | `intelligence`, `cross-reference` |
| **Mobile hub /m** (interface mobile para campo) | `intelink/app/m/` | B | `mobile`, `responsive`, `field-ops` |

---

## 12c. CHATBOT SETORIAL — ESPIRAL DE ESCUTA (2026-05-05)

> **Repo:** `egos-lab-chat` (github.com/enioxt/egos-lab-chat — privado)
> **Live:** lab.egos.ia.br · **Stack:** Bun + Hono + Supabase + OpenRouter
> **Pattern:** 3 partes — Usuário + IA + Enio (monitoramento ao vivo)

| Capability | SSOT | Quality | Tags |
|-----------|------|---------|------|
| **Sector Routing (8 setores)** (advocacia, saúde, varejo, indústria, imóveis, contabilidade, educação, outros) | `egos-lab-chat/src/index.ts` | A | `chatbot`, `routing`, `sectors` |
| **Espiral de Escuta** (Enio monitora via SSE, pausa IA, injeta mensagens) | `egos-lab-chat/src/index.ts:renderMonitorPage()` | A | `chatbot`, `sse`, `live-monitoring`, `human-in-loop` |
| **Lead Persistence + Insights** (coleta + geração LLM após qualificação) | `egos-lab-chat/src/index.ts:generateInsights()` | A | `chatbot`, `crm`, `leads`, `insights` |
| **Telegram First-Contact Alert** (notificação imediata + link monitoramento) | `egos-lab-chat/src/index.ts:sendTelegramNotif()` | A | `chatbot`, `telegram`, `alerts` |

---

## 13. AUDITABLE LIVE SANDBOX (UX Pattern)

> **Pattern SSOT:** `docs/patterns/AUDITABLE_SANDBOX_PATTERN.md`
> Apply to any API/MCP/validation product. First impl: Guard Brasil.

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **Auditable Live Sandbox** | `docs/patterns/AUDITABLE_SANDBOX_PATTERN.md` | A | guard-brasil-web (LIVE) | gem-hunter-web, eagle-eye-web, kb-api | `sandbox`, `ux`, `pattern`, `trust` |
| **Sandbox Dataset Generator** | `apps/guard-brasil-web/app/sandbox/README.md` | B | guard-brasil | ALL viable | `sandbox`, `dataset`, `testing` |
| **Client SHA-256 Receipt Verify** | `sandbox-client.tsx:sha256hex()` | A | guard-brasil-web | ALL APIs with receipts | `trust`, `crypto`, `receipt`, `lgpd` |
| **Session Audit Trail Export** | `sandbox-client.tsx:exportAudit()` | A | guard-brasil-web | eagle-eye, gem-hunter | `audit`, `compliance`, `export` |

---

## 14. MISSION CONTROL (HQ)

| Capability | SSOT | Quality | Adopted By | Should Adopt | Tags |
|-----------|------|---------|------------|-------------|------|
| **EGOS HQ Dashboard** | `egos/apps/egos-hq/` (hq.egos.ia.br:3060) | A | egos (LIVE) | — | `hq`, `dashboard`, `mission-control` |
| **HQ JWT Auth** | `apps/egos-hq/src/middleware.ts` + `DASHBOARD_MASTER_SECRET` | A | egos (LIVE) | — | `hq`, `auth`, `jwt` |
| **HQ X Monitor** | `apps/egos-hq/app/x/` — 3 tabs: queue/search/history | A | egos (LIVE) | — | `hq`, `x.com`, `monitor` |
| **Claude Code Skills (22+)** | `~/.claude/commands/` (22 skills) | A | egos | — | `dx`, `skills`, `automation` |
| **Claude Code Hooks (12)** | `~/.claude/hooks/` + `~/.claude/settings.json` | A | egos | — | `dx`, `hooks`, `safety` |
| **Gem Hunter deps-watch** | `agents/agents/gem-hunter.ts` → SearchTrack deps-watch | B | egos (manual) | — | `dx`, `deps`, `monitoring` |

---

## Cross-Reference: Module Reuse Matrix

| Module | 852 | carteira-livre | intelink | forja | br-acc | egos-web |
|--------|-----|---------------|----------|-------|--------|----------|
| ATRiAN Validation | SSOT | HAS | HAS | HAS | HAS | HAS |
| PII Scanner | SSOT | HAS | HAS | HAS | HAS (Python) | HAS |
| Conversation Memory | SSOT | HAS | HAS | HAS | HAS (Python) | HAS |
| Model Routing | SSOT | HAS | HAS | HAS | Python variant | HAS |
| Telemetry | SSOT | HAS | BASIC | HAS | Python variant | BASIC |
| Rate Limiting | SSOT | BASIC | BASIC | HAS | Python variant | BASIC |
| Evolution API | -- | SSOT | -- | PLAN | -- | -- |
| Tool-Calling (27) | -- | -- | -- | PLAN | SSOT | -- |
| Supabase RLS | HAS | SSOT | -- | PLAN | -- | -- |
| Export (PDF/DOCX) | SSOT | -- | -- | PLAN | -- | -- |

**Legend:** SSOT = canonical source, HAS = implemented and verified (compliance-checker 100/100), BASIC = minimal variant present, PLAN = planned, -- = not applicable

---

## Tag Index

| Tag | Capabilities |
|-----|-------------|
| `chatbot` | 12 capabilities |
| `ai` | 8 capabilities |
| `governance` | 7 capabilities |
| `deploy` | 5 capabilities |
| `telemetry` | 5 capabilities |
| `auth` | 6 capabilities |
| `privacy` | 4 capabilities |
| `agent` | 5 capabilities |
| `whatsapp` | 3 capabilities |
| `gamification` | 3 capabilities |

---

## 12c. CHATBOT CORE (2026-04-14)

> **Package:** `packages/chatbot-core/` — `@egos/chatbot-core` | **Status:** v1.0.0 ✅ | **TS clean, 0 errors**
> **Objetivo:** Um módulo base para todos os chatbots EGOS. Cada projeto configura tools/KB/ATRiAN/modelo. Elimina drift cross-repo.

| Capability | SSOT | Quality | Adopted By | Should Adopt |
|------------|------|---------|-----------|--------------|
| `createChatbot()` factory | `packages/chatbot-core/src/create-chatbot.ts` | A | — | 852, intelink-frontend, forja |
| SSE streaming (`sseStream()`) | `packages/chatbot-core/src/sse-stream.ts` | A | intelink-api ✅ | 852, forja |
| Tool registry (pluggável) | `packages/chatbot-core/src/types.ts#ToolRegistry` | A | — | todos |
| SseEvent types | `packages/chatbot-core/src/types.ts` | A | intelink-frontend ✅ | 852 |
| Rate limiting inline | `create-chatbot.ts#checkRateLimit` | B | — | todos (migrar para Redis) |
| BYOK via header | `create-chatbot.ts#byokHeader` | A | intelink ✅ | 852, forja |

### Migration Status (CHATBOT-CORE-002..005)
- **CHATBOT-CORE-002:** Migrate 852 chat route to use `createChatbot()` | P0
- **CHATBOT-CORE-003:** Migrate Intelink frontend chatbot | P1
- **CHATBOT-CORE-004:** Migrate Forja | P1
- **CHATBOT-CORE-005:** Docs + migration guide | P2

---

## 12. MCP & UNIFIED AGENT ARCHITECTURE (Planned)

> **Research completed:** 2026-03-21 | **Status:** Architecture designed, implementation pending

### Custom MCP Servers (TO BUILD)

| MCP Server | Purpose | Priority | Depends On |
|-----------|---------|----------|------------|
| `@egos/mcp-governance` | SSOT drift, task management, deployment gates | P1 | `@egos/shared` |
| `@egos/mcp-memory` | Persistent conversation memory via Supabase/Redis | P1 | cross-session-memory.ts |
| `@egos/mcp-intelligence` | Investigation tools, OVM, report gen (852/policia) | P2 | 852 domain logic |
| `@egos/mcp-marketplace` | Lesson scheduling, instructor matching (carteira-livre) | P2 | carteira-livre domain |
| `@egos/mcp-erp` | Quoting, inventory, production orders (forja) | P2 | forja tool contracts |
| `@egos/mcp-osint` | Company network analysis, Neo4j graph queries (br-acc) | P2 | br-acc chat tools |

### Existing MCPs Already Covering Needs (DO NOT REBUILD)

| MCP | Provides | Used By |
|-----|---------|---------|
| `filesystem` | File operations | All IDE agents |
| `memory` | Knowledge graph | All IDE agents |
| `supabase` | Raw DB access | carteira-livre, egos-lab |
| `exa` | Web search | All IDE agents |
| `github` | Repo operations | All IDE agents |
| `sequential-thinking` | Reasoning | All IDE agents |

### Architecture Layers

```
L1: @egos/shared (kernel)     — ATRiAN, PII, memory, model-router, telemetry
L2: Chatbot Runtime (extract)  — Standardized chat loop from 852
L3: Custom MCP Servers (build) — Domain-specific outcome-oriented tools
L4: Mycelium Bus (extend)      — Redis Pub/Sub bridge for cross-process events
L5: Agent Registry + Skills    — Auto-discovery, hot-reload, marketplace pattern
```

### Key Design Decisions

1. **Outcomes over operations** — MCP tools expose domain goals, not raw API wrappers
2. **5-15 tools per server** — Curated, not exhaustive
3. **Guardrails at MCP layer** — PII/ATRiAN baked into servers, not per-chatbot
4. **Mycelium events from MCP** — Tool calls auto-emit to event bus
5. **Graceful degradation** — If MCP server down, chatbot falls back to tool-less mode

### Framework Landscape (2026 Research)

| Framework | Best For | Our Relevance |
|-----------|----------|---------------|
| LangGraph | Complex branching workflows | Reference for Mycelium Phase 2 |
| CrewAI | Fast prototyping role-based agents | Inspiration for agent registry |
| ~~OpenClaw~~ | ~~DECOMMISSIONED 2026-04-08~~ — ChatGPT subscription cancelled. Replaced by DashScope qwen-plus + OpenRouter free fallback (see §16) | N/A |
| Vercel AI SDK | Chat streaming + tool calling | Already used in 852/forja |
| Mastra | TypeScript-first graph workflows | Alternative if LangGraph too heavy |

---

*"Tudo que temos, onde vive, o que é melhor." — EGOS SSOT Discipline*
## 13. X.COM & RAPID RESPONSE (2026-04-01)

| Capability | SSOT | Quality | Adopted By | Tags |
|-----------|------|---------|------------|------|
| X Reply Bot | `egos/scripts/x-reply-bot.ts` | A | egos | `x.com`, `automation`, `social`, `oauth` |
| Rapid Response System | `egos/scripts/rapid-response.ts` | A | egos | `x.com`, `showcase`, `threads`, `rapid` |
| Task Reconciliation | `egos/scripts/task-reconciliation.ts` | A | egos | `governance`, `tasks`, `automation` |
| Legacy Code Detector | `egos/scripts/check-legacy-code.sh` | A | egos | `pre-commit`, `quality`, `non-blocking` |
| Hermes-3 Executor | `egos/packages/shared/src/llm-provider.ts` | A | egos | `llm`, `braid`, `structured-output`, `openrouter` |
| BRAID Capability Profile | `egos/scripts/rapid-response.ts#braid_serv` | B | egos | `braid`, `grd`, `multi-agent`, `showcase` |

**X.com Rate Limits (Free tier):** 50 writes/day, 10 searches/15min. Bot: 40 replies/day, 3/run, hourly cron on Hetzner.

**VPS deploy path:** `/opt/egos-lab/.env` has X API keys. Cron: `0 * * * * bun /home/enio/egos/scripts/x-reply-bot.ts`


## 14. MISSION CONTROL & CLAUDE CODE TOOLING (2026-04-05)

| Capability | SSOT | Quality | Adopted By | Tags |
|-----------|------|---------|------------|------|
| EGOS HQ Dashboard | `apps/egos-hq/` → hq.egos.ia.br | A | egos | `dashboard`, `mission-control`, `private`, `jwt-auth` |
| X.com Reply Queue | `apps/egos-hq/app/x/page.tsx` + `x_reply_runs` | A | egos | `x.com`, `queue`, `approval-flow`, `supabase` |
| HQ Health API | `apps/egos-hq/app/api/hq/health/route.ts` | A | egos | `health`, `monitoring`, `guard-brasil`, `gateway` |
| Claude Code Skills (11) | `~/.claude/commands/` | A | global | `slash-commands`, `commit`, `pr-review`, `worktrees` |
| rm-guard Hook | `~/.claude/hooks/rm-guard` | A | global | `safety`, `hooks`, `pre-tool-use`, `bash` |
| PR Review Action | `.github/workflows/pr-review.yml` | A | egos | `github-actions`, `code-review`, `claude`, `automation` |

**EGOS HQ URLs:**
- Dashboard: https://hq.egos.ia.br (private, requires DASHBOARD_MASTER_SECRET)
- Container: `docker ps | grep egos-hq` on VPS port 3060
- Deploy: `/opt/apps/egos-hq/` on Hetzner 204.168.217.125

## 15. GATEWAY P24 — AUTH + TELEGRAM COMMANDS + FTS (2026-04-06)

| Capability | SSOT | Quality | Adopted By | Tags |
|-----------|------|---------|------------|------|
| Gem Hunter API Key Auth | `egos-gateway/src/channels/gem-hunter-api.ts` | A | egos | `auth`, `sha256`, `supabase`, `middleware` |
| Gem Hunter Rate Limiting | `gem-hunter-api.ts#checkAndIncrementUsage` | A | egos | `rate-limit`, `tier`, `usage-tracking` |
| Gateway Health Monitor | `egos-gateway/src/health-monitor.ts` | A | egos | `health`, `telegram-alert`, `weighted-score` |
| Telegram /hunt /sector /trending | `egos-gateway/src/channels/telegram.ts` | A | egos | `telegram`, `slash-commands`, `gem-hunter` |
| Knowledge FTS (pg_trgm + phfts) | `egos-gateway/src/channels/knowledge.ts` | A | egos | `fts`, `pg_trgm`, `portuguese`, `search` |
| Gem Hunter Dashboard (inline SSR) | `agents/api/gem-hunter-server.ts` | A | egos | `dashboard`, `bun`, `ssr`, `gem-hunter` |
| X Bot Daily Report | `scripts/x-reply-bot.ts#sendDailyReport` | A | egos | `x.com`, `telegram`, `reporting`, `automation` |
| Rapid Response Profiles | `scripts/rapid-response.ts` | A | egos | `x.com`, `showcase`, `br_acc`, `sistema_852`, `gem_hunter` |
| Gem Signal Auto-append | `agents/agents/gem-hunter.ts` + `gem-signals.ts` | A | egos | `signals`, `world-model`, `gem-hunter`, `intel` |

**Gateway deploy:** `rsync src → /opt/apps/egos-gateway/src/ && docker compose build --no-cache && docker compose up -d`
**No volume mounts** — source baked into image. Always rebuild after rsync.

## 16. LLM EXECUTION ENGINE — DASHSCOPE + OPENROUTER (2026-04-08)

> **Replaces:** Codex Proxy + OpenClaw billing proxy (both decommissioned 2026-04-08 — ChatGPT subscription cancelled)

| Capability | SSOT | Quality | Adopted By | Tags |
|-----------|------|---------|------------|------|
| Hermes LLM Provider | `packages/shared/src/llm-providers/hermes.ts` | A | egos | `dashscope`, `qwen-plus`, `openrouter`, `fallback-chain` |
| DashScope qwen-plus (primary) | `packages/shared/src/llm-providers/hermes.ts` | A | egos, egos-hq | `alibaba`, `qwen-plus`, `cheap`, `fast` |
| OpenRouter free fallback | `packages/shared/src/llm-providers/hermes.ts` | A | egos | `openrouter`, `gemma-4-26b`, `free` |
| Constitutional Review (migrated) | `apps/egos-hq/app/api/hq/actions/codex-review/route.ts` | A | egos-hq | `governance`, `review`, `dashscope` |
| Smart TASKS.md Archive | `scripts/archive-tasks.sh` + `.husky/pre-commit` | A | egos | `governance`, `tasks`, `archiving`, `pre-commit` |
| HQ Action Endpoints | `apps/egos-hq/app/api/hq/actions/` | A | egos | `hq`, `actions`, `codex-review` |
| HQ Collapsible Dashboard | `apps/egos-hq/app/page.tsx` (v2) | A | egos | `hq`, `collapsible`, `quota-bar`, `5-services` |
| X Opportunity LLM Analysis | `scripts/x-opportunity-alert.ts#analyzeWithLLM` | A | egos | `x.com`, `ai-analysis`, `telegram`, `dashscope` |

**LLM chain (priority order):**
1. Alibaba DashScope `qwen-plus` — `ALIBABA_DASHSCOPE_API_KEY` + `dashscope-intl.aliyuncs.com/compatible-mode/v1`
2. OpenRouter `google/gemma-4-26b-a4b-it:free` — `OPENROUTER_API_KEY`
3. OpenRouter `qwen/qwen3-coder:free` — optional 3rd slot

**Hermes gateway (VPS):**
- Service: `systemctl status hermes-gateway` → port 18800, 142MB RAM
- Config: `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
- .env: `/root/.hermes/.env` (DashScope key + OpenRouter key)

## 17. DOC-DRIFT SHIELD — 4-LAYER DOCUMENTATION INTEGRITY (2026-04-07)

> **Status:** LIVE — all 4 layers operational | **SSOT:** `docs/DOC_DRIFT_SHIELD.md`

### Layer Architecture
| Layer | Artifact | Trigger | Scope |
|-------|----------|---------|-------|
| L1 | `.egos-manifest.yaml` per repo | Manual + generator | claim contracts |
| L2 | `doc-drift-verifier.ts` + `.husky/doc-drift-check.sh` | Pre-commit (staged code files) | egos repo |
| L3 | `doc-drift-sentinel.ts` | Local cron 0h17 BRT daily | all known repos |
| L3.5 | `doc-drift-analyzer.ts` | CCR `governance-drift.yml` | egos repo (GH Actions) |
| L4 | CLAUDE.md §27 + SSOT gate | Every session + pre-commit | global |

### New Agents (Registered in agents.json)
- **`doc-drift-sentinel`** — autonomous daily drift detector + fixer (branch + issue + telegram)
- **`readme-syncer`** — patches `<!-- metric:ID -->` annotations from manifest `last_value`
- **`doc-drift-verifier`** (CLI) — `--all/--repo/--fail-on-drift/--markdown`

### SSOT Gate (Pre-Commit Step 5.7)
- `.ssot-map.yaml` — 26-domain machine-readable SSOT map
- `scripts/ssot-router.ts` — LLM gate (Gemini Flash → Alibaba → keyword → warn-only)
- Triggers only on **new `.md` files** (not modifications)
- Override: `SSOT-NEW: <reason>` in commit message

### Supporting Scripts
- `scripts/manifest-generator.ts` — DRIFT-011: auto-extract claims from READMEs via LLM
- `scripts/run-doc-drift-sentinel.sh` — cron wrapper with `cd /home/enio/egos`
- `.github/workflows/governance-drift.yml` — daily CCR + doc-drift-verifier + safe-push

### Manifest Rollout Status
| Repo | Manifest | Claims | Notes |
|------|----------|--------|-------|
| egos | ✅ | 8 | Baseline, verified |
| carteira-livre | ✅ | 6 | readme-syncer annotations live |
| br-acc | ✅ | 5 | 83.7M nodes verified |
| 852 | ✅ | 5 | New this session |
| forja | ✅ | 2 | Baseline |
| egos-lab | ✅ | 4 | Baseline |
| egos-inteligencia | ✅ | 5 | Not a git repo — manifest on filesystem |

## 19. HERMES AGENT — ALWAYS-ON EXECUTOR (2026-04-07)

> **Status:** LIVE — MVP deployed | **Version:** v0.7.0 | **Author:** NousResearch (MIT)

### What It Is
Python-based AI agent runtime with persistent TUI, 40+ tools (bash, file ops, browser/CDP), scheduled automations, skills (procedural memory that self-improves), messaging gateway (Telegram/Discord), and sub-agent spawning. Not a framework — a full application.

### EGOS Integration
- **Auth (2026-04-08):** DashScope qwen-plus via `ALIBABA_DASHSCOPE_API_KEY`. OpenRouter free as fallback. Anthropic OAuth removed (key invalid).
- **Gateway service:** `systemctl status hermes-gateway` — VPS systemd, `ExecStart=cli.py --gateway`, MemoryMax=512M, Restart=always
- **Config:** `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
- **Install:**
  - Local: `~/.hermes-agent` (source) + `~/.hermes-venv` (Python env) + `~/.local/bin/hermes` (symlink)
  - VPS: `/opt/hermes-agent` + `/opt/hermes-venv` + `/root/.local/bin/hermes`

### Non-interactive (scripting)
```bash
hermes chat --provider openai --model qwen-plus -q "task here" --yolo -Q
# (provider=openai = DashScope-compatible endpoint)
```

### Next steps
- HERMES-005: 1-week trial (2026-04-07 → 2026-04-15), go/no-go gate
- HERMES-006: Scale to 6 profiles per domain (post-trial)
- HERMES-008: Connect Gem Hunter v7 as Hermes cron job

## 18. ARR — ADAPTIVE ATOMIC RETRIEVAL (DORMANT) (2026-04-07)

> **Status:** DORMANT — implemented, not wired | **Packages:** `@egos/atomizer` + `@egos/search-engine`

### What It Is
In-memory full-text search with hierarchical scoring at sentence/claim level.
Scoring: exact substring (high) > token overlap (medium) > atom confidence (base).

### Current State
- Code: `packages/atomizer/src/` + `packages/search-engine/src/`
- Consumer: **NONE** — not imported anywhere in production
- "Quantum Search" (deprecated alias) = vocab-guard blocked term in pre-commit

### Activation Path
1. **ARR-001**: `import { AtomizerCore } from '@egos/atomizer'` in gem-hunter pipeline
2. **ARR-002**: Wire into KB wiki search (replace raw grep in wiki-compiler.ts)
3. Complements (not replaces): codebase-memory-mcp graph, Supabase pg_trgm FTS

---

## §19 — Partial Masking Mode (Guard Brasil) (2026-04-07)

**Module:** `packages/guard-brasil/src/pii-patterns.ts` + `lib/public-guard.ts` + `apps/api/src/server.ts`

**Capability:** Banking-style partial PII reveal for confirmation UIs.

- `MaskMode = 'full' | 'partial'` on all masking APIs
- Per-pattern `partialMaskFn` (CPF, CNPJ, telefone, email)
- API: `POST /v1/inspect { mask_mode: "partial" }`
- Full masking remains default — partial is opt-in

---

## §20 — Schema-Driven Prompt Assembler (2026-04-07)

**Module:** `packages/shared/src/prompt-assembler.ts` (+ `852/src/lib/prompt-assembler.ts` local copy)

**Capability:** Typed, conditional, cacheable prompt section assembly.

- `PromptSection<TCtx>`: id, content, condition, cacheable, priority
- `createAssembler(sections)` → reusable builder bound to section registry
- `AssembledPrompt`: text + cacheableIds + dynamicIds for Anthropic cache integration
- 852 prompt.ts fully refactored to use this pattern

---

## §21 — MemoryStore Adapter (2026-04-07)

**Module:** `packages/shared/src/memory-store.ts`

**Capability:** Backend-agnostic conversational memory persistence.

- `MemoryStore` interface: getRecent / save / buildMemoryBlock
- `SupabaseMemoryStore` — configurable column mapping, production
- `InMemoryStore` — process-scoped, dev/test, clearable
- `NullMemoryStore` — no-op for CI/offline

---

## §22 — Eval Harness (2026-04-07)

**Module:** `packages/shared/src/eval/runner.ts` + `852/src/eval/golden/852.ts`

**Capability:** Golden case regression testing for chatbot responses.

- `GoldenCase`: mustContain, mustNotContain, minLength, maxLength, custom score fn
- `runEval(cases, chatFn, opts)` → `EvalReport` with passRate, avgScore, failures
- 20 golden cases for 852 across 7 categories: PII safety, ATRiAN, governance, legal, ops, tone, anti-hallucination
- Run: `BASE_URL=http://localhost:3001 bun run eval`



---

## 20. AUTO-DISSEMINATE PIPELINE (2026-04-08)

**Scripts:** `scripts/auto-disseminate.sh` · `scripts/session-aggregator.sh` · `.husky/post-commit`

**Capability:** Automatic SSOT propagation after every commit — no manual dissemination required for standard flows.

### What it does

| Trigger | Action | Output |
|---------|--------|--------|
| `post-commit` | Parse task IDs from commit subject | Marks `- [ ] TASK-ID` done in TASKS.md |
| `post-commit` | Extract `LEARNING:` lines from commit body | Appends to `docs/knowledge/HARVEST.md` |
| `post-commit` | Check `feat(X)` against CAPABILITY_REGISTRY.md | Warns if X not registered |
| Daily cron 23:30 BRT | `session-aggregator.sh AUTO_COMMIT=1` | Generates `docs/_current_handoffs/handoff_YYYY-MM-DD.md` |

### Commit conventions

```
feat(hermes): X-COM-018 LLM analysis layer live

LEARNING: DashScope requires dashscope-intl endpoint (not dashscope) for international access
LEARNING: OpenRouter gemma-4-26b free tier rate-limits per minute, not per day
```

Task IDs matched: `[A-Z][A-Z0-9_]+-[0-9]+` (e.g. `X-COM-018`, `HERMES-005`, `DRIFT-012`, `M-007`)

### What still requires manual /disseminate

- New SSOT domain in `.ssot-map.yaml`
- `agents/registry/agents.json` changes (requires `bun agent:lint`)
- Memory file creation in `memory/*.md`
- Social/X.com posts

### Non-blocking design

`auto-disseminate.sh` never exits non-zero. It is a best-effort propagator. If TASKS.md
or HARVEST.md are missing, it skips silently. This prevents hook failures from blocking commits.

---

## §23 — Timeline + AI Publishing System (2026-04-08)

**What it does:** Converts every git commit into a published article. HITL flow ensures human approval before anything goes public.

**Key components:**
- `supabase/migrations/20260408_timeline_publishing.sql` — 3 tables: timeline_drafts, timeline_articles, x_post_queue
- `agents/agents/article-writer.ts` — commit → qwen-plus → draft (DashScope + OpenRouter fallback)
- `scripts/publish.sh` — manual trigger: `bash scripts/publish.sh "topic" [hash]`
- `scripts/timeline-approval-bot.ts` — Telegram inline buttons (✅ Approve / ❌ Reject / ✏️ Edit in HQ)
- `apps/egos-site/` — Bun/Hono server, port 3071: GET /timeline + GET /timeline/:slug

**Live endpoints:**
- egos.ia.br → egos-site:3071 (Caddy 2026-04-08)
- egos.ia.br/timeline — paginated article list
- egos.ia.br/timeline/:slug — article render + view tracking

**Principles:** HITL (never blind publish), PII guard (Guard Brasil), zero auto-post to X.com.

### Timeline Publishing Pipeline (2026-04-12) — LIVE/VERIFIED

| Capability | SSOT | Quality | Adopted By | Tags |
|-----------|------|---------|------------|------|
| Timeline Cron Pipeline | `scripts/timeline-cron-daily.sh` + `agents/agents/article-writer.ts` | A | egos (LIVE) | `timeline`, `cron`, `publishing`, `guard-brasil` |
| Rich Article Rendering | `apps/egos-site/src/server.ts` | A | egos (LIVE: egos.ia.br/timeline) | `timeline`, `json-ld`, `schema.org`, `ux` |
| AI Discovery Layer | `apps/egos-site/src/server.ts` (GET /llms.txt, GET /robots.txt) | A | egos (LIVE: egos.ia.br) | `seo`, `ai-discovery`, `llms.txt`, `robots.txt` |
| Timeline KB Sync | `agents/agents/article-writer.ts#publishDraft` | A | egos (LIVE) | `timeline`, `knowledge-base`, `wiki`, `sync` |

**Article System v1.1 (2026-04-17):** ARTICLE_VOICE.md v1.1 — 800-word floor enforced, bilingual (PT-BR primary + EN cultural translation) mandatory, draft stub flow (`docs/drafts/<slug>.md` → Supabase on approval), epistemic_status (seedling/budding/evergreen), tag taxonomy (§9 ARTICLE_VOICE), "Related in EGOS" block obrigatório. Schema: `word_count` + `tags` columns added via migration `20260417_article_schema_v1.sql`. 10 draft stubs ready in `docs/drafts/`.

**Timeline Publishing Pipeline:** `article-writer.ts` generates LLM drafts from commits, Guard Brasil PII check, `publish.sh --approve` moves draft → article + KB. Cron 03:00 UTC daily via `scripts/timeline-cron-daily.sh`.

**Rich Article Rendering:** egos-site renders articles with JSON-LD `schema.org` metadata, TOC sidebar, heading anchors, code copy buttons, reading progress bar, related articles, FAQ accordion. Server: `apps/egos-site/src/server.ts`.

**AI Discovery Layer:** `/llms.txt` serves dynamic article list from Supabase (spec: llmstxt.org). `/robots.txt` allows GPTBot, ClaudeBot, PerplexityBot. Live at egos.ia.br.

**Timeline KB Sync:** `publishDraft()` auto-creates `egos_wiki_pages` entry (category=timeline, cross_refs, tenant-isolated). Bridges `timeline_articles` and knowledge base.

## §24 — X.com Post HITL Approval + LLM Learning (2026-04-08)

**What:** 3-option Telegram approval flow for X.com posts. LLM generates bold/conversational/technical alternatives personalized by accumulated user choice history.

**Components:**
- `scripts/x-post-approval-bot.ts` — daemon: polls `x_post_queue` → generates 3 alternatives via DashScope → Telegram inline keyboard → records choice → posts to X API
- `supabase/migrations/20260408_x_post_hitl.sql` — `x_post_options`, `x_post_choices`, `x_post_preferences` tables
- VPS: daemon running, watchdog cron `*/5 * * * *`

**Learning loop:**
- Every choice records: option chosen, was_edited, edit_distance, preferred_tone, preferred_length
- `x_post_preferences` aggregated: tone %, avg_length, pct_edited, avg_edit_distance
- Preference summary injected into LLM system prompt for next generation

**User flow:** Telegram inline keyboard → [A Bold][B Conv][C Tech][Edit A][Edit B][Edit C][Skip] → type edited text if editing → auto-posts to X after approval.

### Timeline Bilingual Publishing (2026-04-16) — LIVE/VERIFIED

**What:** Full bilingual (PT-BR + EN) article pipeline with graph interconnection layer.

**Components:**
- `agents/agents/article-writer.ts` — added `--lang pt-br|en`, `--translation-of <id>`, fetches prior articles + wiki pages for graph context (builds_on, opens_questions, wiki_refs, epistemic_status)
- `scripts/insert-draft.ts` — inserts manually-written markdown drafts (with YAML frontmatter) into Supabase `timeline_drafts`. Supports `--translation-of` for bilingual pairing.
- `scripts/x-post.ts` — posts article as 3-tweet X.com thread. OAuth 1.0a. HITL confirmation. Bilingual URLs: `/timeline/<slug>` (PT) + `/en/timeline/<slug>` (EN).
- `docs/social/ARTICLE_VOICE.md` v1.0 — SSOT for voice, structure, footer, interconnection, epistemic status, bilingual rules, canonical tags
- `supabase/migrations/20260416_timeline_interconnection.sql` — adds `lang`, `builds_on`, `opens_questions`, `wiki_refs`, `epistemic_status`, `translation_of` to `timeline_drafts` + `timeline_articles`. `timeline_backlinks` view.

**First article:** `20260416-doc-drift-shield` — PT-BR (9d5c8416) + EN (eebece09), pending approval in HQ.

**Epistemic status lifecycle:** seedling 🌱 → budding 🌿 → evergreen 🌳 (per ARTICLE_VOICE.md §8)

## §25 — Auto-Disseminate Pipeline (2026-04-08)

**What:** 3-agent pipeline that propagates kernel rule changes across all EGOS repos automatically.
**Trigger:** Post-commit on kernel files (CLAUDE.md, .windsurfrules, CAPABILITY_REGISTRY.md, RULES_INDEX.md)
**Status:** Architecture defined → implementation pending (DISS-001..006)

**Pipeline:**
1. **Agent-Scanner** (`scripts/disseminate-scanner.ts`): `git diff HEAD~1` on kernel files → builds propagation manifest (what changed, which repos affected)
2. **Agent-Propagator** (`scripts/disseminate-propagator.ts`): per repo → update kernel block at `# EGOS-KERNEL-PROPAGATED` marker → commit with `chore(kernel): propagate YYYY-MM-DD`
3. **Agent-Verifier** (`scripts/disseminate-verifier.ts`): re-reads each repo → confirms marker + last_modified + changed rule present → outputs pass/fail per repo
4. **Orchestrator** (Claude Code / Telegram): receives summary report → Enio approves/rejects per-repo via Telegram inline buttons

**Repos:** arch, INPI, santiago, carteira-livre, commons, egos-self, egos-inteligencia, smartbuscas, br-acc, egos-lab, 852, policia (12 local) + 4 VPS repos

**Manual fallback:** `bash scripts/governance-propagate.sh --exec` (existing, idempotent)

## §26 — Kernel Change Scanner + Heartbeat Loop (2026-04-08)

**What:** Two infrastructure primitives added to EGOS kernel.

### §26a — Disseminate Scanner (DISS-001 + DISS-004)

**What:** Detects governance drift before it accumulates across repos.
**Components:**
- `scripts/disseminate-scanner.ts` — diffs 4 kernel files (`~/.claude/CLAUDE.md`, `.windsurfrules`, `CLAUDE.md`, `CAPABILITY_REGISTRY.md`), extracts changed sections by markdown heading, writes `.egos-disseminate-manifest.json`
- `.husky/post-commit` — triggers scanner automatically when kernel files are in a commit
**Output:** `{changed_rules[], affected_repos[], propagation_needed: bool}` — feeds DISS-002 propagator

### §26b — Heartbeat Loop (PAP-001)

**What:** Paperclip-inspired native 30min wake/sleep cycle for long-running agents.
**Component:** `agents/runtime/heartbeat.ts` — wraps `runAgent()` in configurable loop
**API:**
```typescript
const handle = startHeartbeat({
  agentId: 'gem-hunter',
  intervalMs: 30 * 60 * 1000,
  checkWorkQueue: async () => hasNewRepos(),  // skip if nothing to do
  handler: gemHunterHandler,
});
handle.stop();     // graceful shutdown
handle.status();   // { cycleCount, lastRunAt, nextRunAt, lastResult }
```
**Events:** emits `agent.heartbeat.complete` on Mycelium bus after each cycle
**Events:** emits `agent.heartbeat.complete` on Mycelium bus after each cycle

## §27 — KBS — Knowledge Base as a Service (2026-04-08)

**What:** Notion-based knowledge management SaaS for 10 professional profiles in small Brazilian cities. Uses Claude Code + Notion MCP as the zero-infra engine.

**Components:**
- `packages/knowledge-mcp/templates/sectors/` — sector templates: industrial-forja, medico, advocacia, contador, agronomo (5 ready)
- `agents/agents/wiki-compiler.ts` — converts Markdown → searchable Notion database entries
- `supabase/tables/knowledge_base` — 1648 rows ARR embeddings (vector search via pgvector)
- `packages/search-engine/` — ARR (Adaptive Atomic Retrieval): sentence-level semantic indexing
- Notion MCP (nativo Claude Code) — zero custom integration, uses Claude's native Notion tools

**Profiles supported:** Consultor Agrícola, Veterinário, Agrônomo, Engenheiro Civil, Médico/Clínica, Contador Rural, Advogado (Direito Agrário), Cooperativa, Imobiliária Rural, SENAR/Escola

**Business model:** R$1.5k setup + R$200/mês (starter) | R$5k setup + R$800/mês (full)
**Current state:** 10 profiles + 12 Notion databases populated (KBS-PM-001..011 ✅ 2026-04-08)
**SSOT:** `docs/strategy/KB_AS_A_SERVICE_PLAN.md` + `docs/strategy/KBS_PATOS_DE_MINAS_PERSONAS.md`

**Tools added (2026-04-09):**
- `scripts/kb-ingest.ts` — PDF/DOCX/Markdown ingestor with Guard Brasil PII scan (KBS-006 ✅)
- `scripts/kb-lint.ts` — KB quality auditor: orphans, stale, broken_refs, low_quality, duplicates (KBS-007 ✅)
- `packages/knowledge-mcp/`: `ingest_file` MCP tool added (calls kb-ingest.ts)

**Strategic update (2026-04-09):** Notion announced native Claude AI Agents (2026-04-08).
"Your task board is Claude's to-do list." Anthropic = motor, Notion = orchestration layer.
EGOS positioning: Notion + Claude Agents = frontend power, EGOS .guarani/ = governance kernel.
Differentiator: LGPD compliance (Guard Brasil), audit trail, frozen zones, spec-driven execution.
→ See TASKS.md NOTION-AGENTS-001..005 for integration roadmap.

**KBS v2 — Entity Graph Layer (2026-04-12):**
- Architecture pivot: flat RAG → entity extraction + relationship graph + intelligence reports
- ICP: already uses AI ($20+/month Claude/OpenAI), has digital data, feels "can't find what I need"
- EGOS = first complete demo case (before/after: 8→151 wikilinks, 0 broken, MOC 56 links)
- Sector validation path: EGOS internal → DHPP/policial → advocacia → agronomia
- New tables planned: `egos_entities`, `egos_relationships` (KBS-028)
- New agents planned: `kb-entity-extractor`, relationship mapper (KBS-029/030)
- Pitch: "inteligência estruturada que conecta tudo" não "chatbot com seus PDFs"
- Tasks: KBS-027..039 in TASKS.md

## §29 — Platform Monitor (2026-04-09)

**What:** Daily monitoring of EGOS stack platform versions — detects breaking changes before they break production.

**Platforms tracked:** claude-code, anthropic-sdk, notion-client, mcp-sdk, bun
**Source:** npm registry (latest tag) + GitHub releases API
**Impact assessment:** major version → critical, minor → high, patch → medium/low
**Alerts:** Telegram for high/critical only (no noise for patches)
**Storage:** Supabase `platform_updates` table (RLS service_role)
**Cron:** VPS daily 9h BRT (12h UTC) via `/etc/cron.d/platform-monitor`

**Files:** `scripts/platform-monitor.ts`, `supabase/migrations/20260409_platform_updates.sql`
**Baseline set:** claude-code 2.1.97, anthropic-sdk 0.86.1, notion-client 5.17.0, mcp-sdk 1.29.0, bun 1.3.11

## §28 — X.com Reply Bot — Quality Scoring v2 (2026-04-08)

**What:** Scoring improvements to x-reply-bot.ts that prevent false positives (news overscored) and false negatives (real engineers underscored).

**File:** `scripts/x-reply-bot.ts` (545 lines, queue mode → Supabase `x_reply_runs`)

**Changes shipped 2026-04-08 (XRB-002..004):**
- **Few-shot examples injected into scoring prompt** (XRB-002): 5 gems (vacacafe/MrCl0wnLab/PreyWebthree/zhuokaiz/TFTC21) + 3 rejects (hasantoxr/LOWTAXALT/claudeai-news)
- **Low-visibility big-tech bypass** (XRB-003): If tweet contains bigtech company name + code snippet (```, github.com) → `effectiveMinLikes = min(2, topic.min_likes)`. Captures @zhuokaiz-style engineers with few likes posting real code.
- **Corporate announcement detector** (XRB-004): If tweet contains "announcing/introducing/launching" + "anthropic/openai/google/meta ai/microsoft" → `stats.rejected++; continue`. Prevents PR posts from scoring as gems.

**Scoring principle (documented in scoring-v1.md §5):**
> "A gem is a signal BEFORE it's popular. Official announcements are never gems — they're already known."

**Pending:** GH-091 (Qwen replaces heuristic in scoreGem()), GH-093 (Telegram inline feedback keyboard)

## §30 — Claude Code Cost Tracker (2026-04-09)

**What:** Reads `~/.claude/projects/**/*.jsonl` to compute real token usage and estimated cost per project/session/model.

**Files:** `scripts/claude-cost.ts`, `scripts/claude-cost-alert.sh`
**Pricing:** Haiku ($0.80/$4/1M), Sonnet ($3/$15/1M), Opus ($15/$75/1M) + cache_write/read
**Usage:** `bun scripts/claude-cost.ts --days 30 [--project egos] [--json]`
**Insight (2026-04-09):** cache_creation_input_tokens = ~90% of total cost. 30-day result: ~$3k across 81 sessions in 6 projects, dominated by Opus sessions with full context.
**Cron:** VPS Friday 21h UTC via `/etc/cron.d/claude-cost-alert` (Telegram: top project + total)
**Skill:** `/usage-report` at `~/.egos/.claude/commands/usage-report.md`

## §31 — LLM Test Suite Standard (2026-04-09)

**What:** Standardized evaluation suite for LLMs discovered by platform-monitor or llm-model-monitor. 9 tests across 5 categories, scored 0-100 per test.

**File:** `scripts/llm-test-suite.ts`
**Categories:**
- `coding` (2 tests): TypeScript generation, bug identification
- `reasoning` (2 tests): math with steps, logical deduction (affirm fallacy)
- `long_ctx` (1 test): context retention across context switch
- `agentic` (2 tests): JSON structured output, tool call simulation
- `ptbr` (2 tests): professional PT-BR writing, LGPD terminology

**EGOS-specific:** PT-BR category designed for Brazilian market (metalurgy professionals, LGPD compliance)
**Storage:** Supabase `llm_test_results` table (`20260409_llm_test_results.sql`)
**Usage:** `bun scripts/llm-test-suite.ts --model <id> [--category ptbr] [--dry]`
**Pending:** LLM-MON-006 auto-trigger for S-tier models detected by llm-model-monitor

## §32 — Report Standard Package (2026-04-09)

**What:** `@egos/report-standard` — canonical schema + validator for all EGOS intelligence reports. Unifies report structure across egos, 852, br-acc, egos-inteligencia.

**Package:** `packages/report-standard/`
**Schema version:** 2.0.0 (JSON Schema at `packages/report-standard/schemas/report-v2.json`)
**Types:** analytics, audit, compliance, dissemination, incident, intelligence, research, strategy, technical
**Sections:** executive_summary, methodology, findings, recommendations, appendix, metadata
**Validation:** `validateReport(data)` → `{valid, errors, warnings, report, metadata}`
**Migration:** `migrateLegacyReport(legacy)` → normalizes old formats to v2.0.0
**Zod v4:** uses `z.record(z.string(), z.any())` and `error.issues` (not `error.errors`)
**Next:** REPORT-002 CLI validator, REPORT-003 Supabase adapter, REPORT-004 npm publish

## §33 — OmniView v0.1 — Local Video Analysis (2026-04-14)

**What:** Sistema local-first para análise forense de vídeos de câmeras de segurança. Detecta movimentos, agrupa em eventos, gera thumbnails e clips, timeline clicável, revisão humana com chain-of-custody auditável.

**Repo:** `/home/enio/omniview` | **GitHub:** `enioxt/omniview` (criado 2026-04-15)
**Status:** Phase 0+1+2+3 completas ✅ + DVR converter ✅

**Engine (Python 3.12 + FastAPI):**
- `app/core/integrity.py` — SHA-256 streaming (chunks 1MB)
- `app/core/ingest.py` — upload → quarantine → hash → dedup → working copy → probe
- `app/core/motion.py` — MOG2 dual-threshold: S_motion > σ1 AND contour_area > σ2
- `app/core/event_grouping.py` — fusão temporal com peak frame selection
- `app/core/thumbnails.py` — WebP ao frame de pico
- `app/core/clips.py` — FFmpeg stream-copy ±seg por evento
- `app/workers/scan_worker.py` — orquestra pipeline completo (sync + async)
- `app/services/audit_service.py` — HMAC-per-row append-only audit log
- `app/services/provenance_service.py` — JSON proveniência com transforms[]
- `app/core/auth.py` — bcrypt + itsdangerous sessions + 3-role RBAC
- `app/db/models.py` — 9 tabelas SQLAlchemy (videos/events/reviews/audit_logs/users)
- `app/cli/main.py` — `omniview-cli ingest/process/list/verify`

**API (FastAPI — 19 rotas):**
- `POST /api/videos` — upload + ingest + background scan
- `GET /api/videos/{id}/events` — lista eventos com filtro
- `POST /api/events/{id}/reviews` — revisão humana versionada
- `GET /api/events/{id}/thumbnail` — WebP do evento
- `GET /api/events/{id}/clip` — clip MP4 do evento
- `GET /api/videos/{id}/provenance` — JSON cadeia de custódia
- `GET /api/metrics` — Prometheus format

**Engine adicional (Phase 2+3+DVR):**
- `app/core/converter.py` — DVR auto-conversion: `.264/.dav/.h264/.m2ts` → H.264 MP4 via ffmpeg; cache, graceful degradation, timeout 600s
- `app/services/export_service.py` — ZIP forense + HMAC manifest + HTML report
- `app/core/retention.py` — purge noncritical(30d) / critical(365d)
- `app/core/progress.py` — asyncio.Queue pub/sub para WebSocket scan progress
- `omniview-cli verify <zip>` — HMAC check + SHA-256
- `omniview-cli export <video_id>` / `omniview-cli retention [--dry-run]`

**UI (React 18 + TypeScript + Tailwind + i18n PT-BR):** ✅ completa
- VideoPlayer, EventTimeline, EventGallery, ReviewPanel (hotkeys 1-9), FiltersBar
- LoginPage, IngestPage, ReviewPage, EventDetailPage, ExportPage

**Testes:** 26+ passando (unit + integration + converter com 9 testes DVR)

**Princípios hard-coded:**
1. Original imutável após ingest (chmod 444)
2. Sem cloud por padrão
3. Funciona sem LLM, sem synopsis no MVP
4. Motion-first gating (detector pesado na Phase 4)
5. Chain-of-custody em tudo que sai do sistema

**Não reimplementar em sessões futuras:** os módulos acima já existem. Ver `engine/app/` diretamente.

---

## §34 — Pochete2.0 v4.0 — Browser Video Toolkit (2026-04-15)

**What:** Editor de vídeo 100% no navegador para perícia policial. Zero install, zero cloud, vídeo nunca sai da máquina.

**Repo:** `/home/enio/video-editor` | **GitHub:** `enioxt/Pochete2.0` (v4.0 — 2026-04-15)
**URL:** [video.egos.ia.br](https://video.egos.ia.br) | **Serving:** nginx no VPS Hetzner

**Features v4.0:**
- ✂️ Corte por tempo com timeline visual arrastável
- 🎯 Detector de movimento (canvas pixel-diff, 3 sensibilidades: low/mid/high)
  - `MOT_CFG`: `diffThreshold`, `motionPixelPct`, `gapMs`, `minDurationMs`
  - "Enviar para Corte" preenche aba Cortar com horários + 2s de margem
- 🔄 Rotação com preview ao vivo (90°/180°/270°) — AR-matching para evitar crop
- 📷 Capturar quadro como PNG
- 🗗 Player adaptável: `object-fit: contain` em container 420px fixo
- ⌨️ Atalhos: Espaço/←/→/,/.
- LEIAME.md em PT-BR para agente não técnico

**Stack:** HTML5 + vanilla JS + ffmpeg.wasm (814.ffmpeg.js) | **Headers:** COOP + COEP (SharedArrayBuffer)

**Não reimplementar:** o arquivo único é `/home/enio/video-editor/index.html` (~1700 linhas).

---

## §35 — Consulting Framework — KB-as-a-Service + Debrief Pipeline (2026-04-15)

**What:** End-to-end consulting system for Brazilian sector professionals (advocacia, contabilidade, agronomia, saúde, polícia). Includes client onboarding, 5-layer debrief pipeline, trust page, and LGPD compliance API.

**Repos:** `egos` (kernel), `apps/egos-gateway`, `apps/trust-page`
**URLs:** `trust.egos.ia.br` (trust page), `api.egos.ia.br/api/lgpd/*` (LGPD API)

**Components:**
- **Trust Page** (`apps/trust-page/`): Next.js 15 standalone — landing, how-it-works, pricing, LGPD policy, sub-processors, security, status, client dashboard (`/clients/[slug]`)
- **Debrief Pipeline** (`scripts/debrief/pipeline.ts`): 5-layer audio→KB pipeline
  - L1: Groq Whisper transcription (pt)
  - L2: Gemini Flash sector-context correction
  - L3: Qwen-plus JSON extraction (DebriefInsights schema)
  - L4: Supabase `egos_wiki_pages` cross-reference
  - L5: File persistence + `debrief_sessions` patch
- **LGPD Compliance API** (`apps/egos-gateway/src/channels/lgpd.ts`): `GET /api/lgpd/export/:slug`, `GET /api/lgpd/report/:slug`, `POST /api/lgpd/delete/:slug`, `GET /api/lgpd/dsrform`
- **Client Dashboard** (`apps/trust-page/app/clients/[slug]/page.tsx`): KB stats, budget progress, category breakdown, LGPD rights
- **KB Seed** (`scripts/kbs/seed-egos-advocacia.ts`): 75 advocacia KB pages seeded in Supabase

**DB Tables (Supabase `lhscgsqhiooyatkebose`):**
- `kb_pages`: tenant, title, content, category, source_url, tags, quality_score, slug — RLS per tenant
- `consulting_clients`: slug, name, sector, api_budget_brl, api_used_brl, google_refresh_token, active
- `debrief_sessions`: client_slug, meeting_date, transcript, insights, gaps, status
- `debrief_questions`: client_slug, question, layer (L3 extraction schema)

**CLI:** `bun scripts/debrief/pipeline.ts --client advocacia-1 --audio meeting.mp3 [--dry]`
**CLI:** `bun scripts/kbs/seed-egos-advocacia.ts [--dry-run]`

**LGPD Auth:** Bearer `LGPD_AUTH_TOKEN` (admin) or `${slug}-lgpd-access` (client self-service)

**Não reimplementar:** pipeline completo funcional. Tabelas já criadas. Seeds aplicados. Google OAuth integrado no orchestrator (tools 16–19).

**Novos componentes (2026-04-16):**
- **WhatsApp Onboarding Bot** — chip dedicado + bot qualificação mini-DPIO (5-7 perguntas, score ≥25 gate) + `notify_human` tool + whitelist por tenant. Spec: `docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md`
- **Retention Cron** (`scripts/consulting/retention-cron.ts`): LGPD art.16 — deleta dados >6 meses de clientes inativos
- **PJe Demo** (`scripts/demos/pje-demo.ts`): Demo seed 8 KB pages + 2 queries IA (<10s)
- **Contrato Template** (`docs/strategy/CONTRATO_SERVICO_TEMPLATE.md`): 9 cláusulas + LGPD + subprocessadores
- **DataFlow SVG** (`apps/trust-page/app/components/DataFlowSVG.tsx`): Pipeline visual interativo 5 nós
- **Kit instalação** (planned): VS Code + Claude Code ($20/mês embutido) + Obsidian + Notion
- **Ratio patterns absorbed** (planned): Hybrid Search RRF, Citation Verification, Anti-Sycophancy Guard, Token Accounting per-query

**Novos componentes (2026-04-17 — esta sessão):**
- **Skill Resolver** (`scripts/skill-resolver.ts`): SKILL-AUTO-001 — lê context-signals.jsonl + git log + prompt text → emite `[SKILL-SUGGEST] /skill PRIORITY — reason`. Integrado ao session-init --reset. Trigger patterns: §18 completo (PT+EN).
- **Recency Decay KB Search** (`supabase/migrations/20260417_kb_recency_decay.sql`): RATIO-ABSORB-005 — `match_kb_hybrid` com `decay_rate float default 0.01`, `final_score = rrf_score * exp(-0.01 * days_since_update)`. Half-life ≈70 dias. `decay_rate=0` desativa.
- **Content Track** (TASKS.md §CONTENT TRACK): Pipeline editorial completo — ART-001..008 + X-001..004 + TL-001..004 + SITE-010..013 + TOP-011..018. Foco: artigos técnicos reais → threads X.com → egos.ia.br/timeline.

## §36 — CRC-PATTERN-v1 — Cross-Repo Coordination Protocol (2026-04-26)

**Trigger:** N parallel agent sessions in different EGOS repos (kernel + leaf-apps) need to coordinate without falling into wrong "merge/absorb" frames or phantom claims about each other.

**Canonical doc:** `docs/COORDINATION_PATTERN.md` (kernel SSOT, written by Janela A intelink, 2026-04-26).

**Components verified live 2026-04-26:**
- `docs/COORDINATION.md` — kernel SSOT for active/closed coord entries
- `docs/CROSS_REPO_CONTEXT_ROUTER.md` — pull-based topic→repo resolver
- `intelink/docs/UPSTREAM_KERNEL.md` — leaf-side reciprocity contract (commit `bd9e5f5`)
- Supabase `coord_events` table (egos-lab, RLS public-read + service-role write)
- Public endpoint `https://intelink.ia.br/api/coord` (HTTP 200, JSON, 60s cache)
- CLI `intelink/scripts/coord-register.ts` (commit `7a12fa7`)
- Mutual Error Acknowledgement section in `docs/COORDINATION.md` — public template for symmetric verification failures

**5 rules of CRC-v1:**
1. Repos distintos não mergeiam — somos camadas (kernel + leaf), não horizontal
2. Verificação simétrica obrigatória — CLAUDE.md §1 aplica nos dois sentidos (about-self AND about-others)
3. Acordo só com SHAs em remotes públicos — não com palavras
4. Cada turno termina com `git push` — outra janela verifica via `git ls-remote`, não por confiança
5. User is the third vertex, not a supervisor — sem ele o canal síncrono cross-repo não existe

**Reference impl SHAs (verifiable on remotes):**
- `enioxt/egos@16eaf75` — kernel registers COORD-A/B/C
- `enioxt/intelink@b2f69a9` — leaf retracts merge frame
- `enioxt/egos@2ce5cba` — kernel counter-signs + Mutual Error
- `enioxt/intelink@bd9e5f5` — leaf creates UPSTREAM_KERNEL.md
- `enioxt/egos@542af99` — kernel adopts CRC-PATTERN-v1 canonical
- `enioxt/intelink@7a12fa7` — leaf ships /api/coord + Supabase + CLI

**First case shipped:** `egos.ia.br/timeline/two-windows-one-mind` (PT-BR + EN, HTTP 200, published 2026-04-26).

---

## §36 — Cross-Repo Coordination Pattern v1 (CRC-PATTERN-v1) (2026-04-26)

**Quality:** A (validated end-to-end with two real SHAs in two public remotes)
**Owner:** egos kernel
**Adoption:** intelink (leaf)
**Tags:** `coordination`, `governance`, `multi-agent`, `cross-repo`

### Summary
Reusable protocol for parallel agent windows operating on related-but-separate repos in the EGOS ecosystem. Replaces ad-hoc "absorb/discard" framing with material reciprocity proven via git SHAs across remotes.

### Components
| Artifact | Location | Purpose |
|----------|----------|---------|
| Canonical doc | `egos/docs/COORDINATION_PATTERN.md` | 5 rules + 6-step protocol |
| Active registry | `egos/docs/COORDINATION.md` | Live entries (pending → done) |
| Leaf reference | `<leaf>/docs/UPSTREAM_KERNEL.md` | Each leaf-app commits this once |
| Supabase table | `coord_events` (egos-lab project) | Persistent record with both SHAs |
| Public feed | `https://intelink.ia.br/api/coord` | JSON, no auth, cache 60s |
| Register script | `intelink/scripts/coord-register.ts` | CLI to add new event |

### Reference run (first validated execution)
- `COORD-2026-04-26-A` — kernel `16eaf75` ↔ leaf `7ab4577` (Intelink CPF normalization)
- `COORD-2026-04-26-B` — kernel `d57c633` (HQ ChatPanel privacy fix)
- `COORD-2026-04-26-C` — kernel `2ce5cba` ↔ leaf `bd9e5f5` (reciprocity proof)

### Adoption checklist for new leaf-apps
1. Commit `docs/UPSTREAM_KERNEL.md` referencing `enioxt/egos`
2. Add upstream pointer in `AGENTS.md` header
3. When parallel session arises: open coord entry in `egos/docs/COORDINATION.md` first
4. Each turn ends with `git push` — never trust verbal/textual claims about other repos

### Anti-patterns (recorded)
- ❌ "Absorb the other window" framing
- ❌ Cross-repo `git merge` (remotes are separate)
- ❌ Narrative templates without verification (violates CLAUDE.md §1 + INC-005)
- ❌ Hierarchy by perceived "size" of work (only by function: kernel vs leaf)

---

## §37 — HQ Live Dashboard — Agent Events + Hermes Panel (2026-04-30)

**Quality:** A | **Repo:** egos (`apps/egos-hq/`) | **Commits:** `07d7a9e`, `5cd8fdb`, `f73229f`

Real-time observability dashboard for the EGOS kernel. Wires 4 cron agents to `egos_agent_events` Supabase table and displays them live.

| Component | Path | Description |
|-----------|------|-------------|
| Agent Events Dashboard | `apps/egos-hq/app/hq/agents/` | Live event stream per agent |
| Hermes Panel | `apps/egos-hq/app/hq/hermes/` | Hermes gateway status + free model list |
| Agents Status Strip | `apps/egos-hq/components/AgentStatusStrip.tsx` | Top-bar live agent health |
| Deep Drill Sheets | `apps/egos-hq/app/hq/agents/[id]/` | Per-agent metrics + governance gates |
| Guided Tour Modal | `apps/egos-hq/components/GuidedTour.tsx` | First-visit onboarding overlay |
| Live Verification | `apps/egos-hq/app/api/hq/verify/` | Endpoint health checks with UI buttons |

**Adopted by:** egos-hq (origin) | **Should adopt:** — (HQ-specific)
**Tags:** `hq`, `observability`, `dashboard`, `agents`, `real-time`

---

## §38 — Full-System Health-Check + Periodic Monitor (2026-04-30)

**Quality:** A | **Repo:** egos (`scripts/health-check.ts`) | **Commit:** `de12c70`

Periodic health-check that runs across all VPS services and reports to `egos_agent_events`.

| Component | Path | Description |
|-----------|------|-------------|
| Health check script | `scripts/health-check.ts` | Checks Guard Brasil API, HQ, Hermes, Neo4j |
| Hermes free models fix | `packages/shared/src/llm-providers/hermes.ts` | Updated free model list (Qwen3 free tier) |
| Snapshot KB | `scripts/snapshot-kb.ts` | KB state snapshot on each health run |

**Adopted by:** egos (origin), VPS cron | **Tags:** `infra`, `health`, `monitoring`, `hermes`

---

## §39 — Intelink Agente — Local Police LLM (2026-04-29)

**Quality:** B | **Repo:** intelink + egos | **Commits:** `5018e54`, `cea1e60`, `f55bd5d`

Fine-tuned local LLM for police investigation queries. QLoRA Qwen2.5-7B, 76 training pairs, runs on local RTX 5060 Ti + VPS Ollama.

| Component | Path | Description |
|-----------|------|-------------|
| LLM Router (5-tier) | `intelink/lib/intelink-llm-router.ts` | local→VPS→OR-free→OR-paid→Anthropic |
| LoRA Adapters | `intelink-agente/models/v1/lora_adapters/` | Fine-tuned weights (QLoRA run #1) |
| Training Pipeline | `intelink-agente/scripts/train.py` | QLoRA training with PyTorch + Blackwell |
| Eval Suite | `intelink-agente/scripts/run_eval.py` | Benchmark against base model |
| GitHub Repo | `github.com/enioxt/intelink-agente` | Public training artifacts |

**Adopted by:** intelink (origin) | **Should adopt:** policia (when Windows migration complete)
**Tags:** `llm`, `fine-tuning`, `local`, `police`, `qlora`, `intelink`

---

## §40 — Instagram Caption Generator + Lead Capture (2026-05-01)

**Quality:** A | **Repo:** egos (`scripts/instagram-caption-generator.ts`) | **Commit:** `388431d`

Automated caption generation for 4 content types (educacao/caso/demo/social) + Supabase lead capture for Instagram-driven prospects.

| Component | Path | Description |
|-----------|------|-------------|
| Caption generator | `scripts/instagram-caption-generator.ts` | 4 content types, hashtags, CTA |
| Lead capture table | `supabase/migrations/20260501_lead_discovery.sql` | `lead_discovery_sessions` with source tracking |
| Landing page | `apps/egos-hq/app/implementacoes-gratuitas/` | Hero + 3 steps + Instagram CTA |
| Deploy pipeline | `scripts/deploy-hq.sh` | 4-step automated HQ deploy to VPS |

**Adopted by:** egos (origin) | **Should adopt:** 852, carteira-livre (lead capture pattern)
**Tags:** `instagram`, `marketing`, `lead-capture`, `gtm`, `content`

---

## §41 — EGOS Practitioner Certification (2026-04-30)

**Quality:** A | **Repo:** egos (`apps/egos-hq/`) | **Commit:** `1e5071c`

Automatic lightweight certification issued after 90 days of active EGOS Lab membership. Verifiable via Supabase + public badge endpoint.

| Component | Path | Description |
|-----------|------|-------------|
| Certification logic | `apps/api/src/routes/lab-certification.ts` | 90-day check + badge generation |
| Badge endpoint | `apps/egos-hq/app/api/certifications/` | Public verification URL |
| Lab landing page | `apps/egos-hq/app/lab/` | EGOS Lab CTA + pricing + certification info |

**Adopted by:** egos (origin) | **Tags:** `lab`, `certification`, `community`, `gamification`

---

## §42 — Intelink Intelligence Modules (2026-04-12 → 2026-05-01)

**Quality:** A | **Repo:** intelink | **Multiple commits**

Advanced investigation capabilities built into the Intelink platform for PCMG.

| Capability | Commit | Description |
|-----------|--------|-------------|
| BR-ACC Cross-reference | `b3f29b7` | PEP + sanction flags on Person nodes via br-acc API |
| CEAP → Neo4j import | `b3f29b7` | Deputy spending data linked to REDS occurrences |
| Web Search tool (chat) | `ad2b560` | DuckDuckGo + Brave opt-in in investigation chat |
| Journey Tracker | `021e814` | Click-through navigation audit trail per investigation |
| Vehicle detail page | `0e8d8d6` | `/veiculo/[placa]` with journey tracking |
| Occurrence detail | `ce24889` | `/ocorrencia/[reds]` with full timeline |
| Family relation scan | `5af2327` | Detect sibling/family pairs in dedup pipeline |
| NER prompt v7 | `1601e0b` | Unified entity extraction prompt for all document types |
| Nightly cross-ref cron | `1601e0b` | Scheduled pipeline for overnight enrichment |
| Documents tab + viewer | `76b3c7b` | Inline document viewer per Person page |
| Mobile hub `/m` | `a591f6a` | Mobile-optimized search + agent (busca + chat SSE) |

**Adopted by:** intelink (origin) | **Should adopt:** policia (subset)
**Tags:** `intelink`, `investigation`, `neo4j`, `police`, `enrichment`, `mobile`

---

## §43 — Capability Registry Scanner (2026-05-01)

**Quality:** A | **Repo:** egos (`scripts/update-capability-registry.ts`)

Automated scanner that reads git log `--since` last registry update across all ecosystem repos and identifies feat commits not yet registered. Non-destructive — outputs candidates for human review.

```bash
bun scripts/update-capability-registry.ts              # scan all repos since last update
bun scripts/update-capability-registry.ts --since 7d   # last 7 days
bun scripts/update-capability-registry.ts --repo intelink
```

**Adopted by:** egos (origin) | **Should adopt:** runs as pre-commit advisory (non-blocking)
**Tags:** `governance`, `documentation`, `automation`, `registry`

---

## §44 — README Cross-Reference System (2026-05-01)

**Quality:** A | **Repo:** all 9 active repos | **Commit:** this session

Standardized README format across all ecosystem repos with versioning, real status, upstream/downstream dependency mapping.

**Fields per repo:**

- `Versão: X.Y.Z | Atualizado: YYYY-MM-DD | Status: PROD/BETA/PAUSA`
- `Parte do ecossistema EGOS`
- `## Ecossistema EGOS — Dependências` section with upstream/downstream

**Repos with updated READMEs:** egos, intelink, 852, carteira-livre, forja, arch, egos-lab, br-acc, policia
**Tags:** `documentation`, `cross-reference`, `ecosystem`, `governance`

---

## §45 — Chatbot Portal Multi-Agente (2026-05-03)

**Quality:** A (Phase 0 live) | **Repo:** egos | **Commit:** a4b3597, 255bf1e

Portal `chatbot.egos.ia.br` com 5 agentes (Labs/Pixel/Tira-Voz/Forja/Arch) + lead capture com funil `agent_clicked`.

**Componentes:**
- `docs/projects/chatbot-portal-snapshot-2026-05-03.html` — Phase 0 estático, live
- `supabase/migrations/20260504_egos_lab_leads.sql` — tabela `egos_lab_leads` (email, agent_clicked, status funil)
- `apps/egos-hq/app/api/hq/leads/route.ts` — POST /api/hq/leads + Telegram notify
- `egos-lab/apps/egos-lab-kb/` — bootstrap Phase 1 (RAG chat + KB upload + schema multi-tenant)

**Adotado por:** chatbot.egos.ia.br (live), hq.egos.ia.br (API)
**Tags:** `chatbot`, `portal`, `lead-capture`, `rag`, `multi-tenant`

---

## §46 — BISP/REDS Ingestion Pipeline (2026-05-04)

**Quality:** A | **Repo:** intelink | **Commit:** b815c0c

Pipeline ETL para ingestão de planilhas XLSX exportadas do BISP (sistema policial) no Neo4j, com dedup inteligente por número REDS normalizado.

**Componentes:**
- `scripts/ingest-xlsx-reds.ts` — parser multi-aba (Ocorrências + Envolvidos + Armas), MERGE por REDS norm, detecção REDS referenciados no histórico
- Dedup: REDS number normalizado (strip hífens) = chave única; Person MERGE por CPF → nome+mãe+nasc
- Testado: 121REGIAO1 (8.803 ocorrências, 4.682 pessoas novas, 2.338 referências cruzadas)

**Tags:** `etl`, `neo4j`, `bisp`, `reds`, `police`, `dedup`

---

## §47 — Cross-Ref Nightly v2 (7 steps) (2026-05-04)

**Quality:** A | **Repo:** intelink | **Commit:** b815c0c

Cron diário expandido de 5 para 7 etapas automáticas.

**Novos steps (4.5, 6, 7):**
- **4.5 ETL-BAIRRO**: fuzzy match Jaro-Winkler ≥0.88 contra 85 bairros de Patos de Minas → preenche `bairro_fato`
- **6 FAMILY_DETECTOR**: `detectSiblingsByRegistry(500, true)` + `createFamilyEdgesFromNER()` — SIBLING_OF automático
- **7 VEHICLE_NODES**: MERGE Vehicle nodes de `vehicle_plates[]` + `(Person)-[:OPERATES_VEHICLE]->(Vehicle)`

**Componentes:**
- `lib/etl/bairro-matcher.ts` — dicionário 85 bairros + sliding window fuzzy
- `scripts/auto-merge-sameas.ts` — runner para 1.510 SAME_AS (conf≥95% auto, conf≥85%+CPF=igual)
- `scripts/fix-cpf-type.ts` — detecção e correção de CPF como StringArray

**Tags:** `etl`, `neo4j`, `cron`, `family-detection`, `vehicle`, `bairro`, `dedup`

---

## §48 — Tool Registry de Investigação (2026-05-03)

**Quality:** B | **Repo:** intelink | **Commit:** b52f722

Catálogo de 8 ferramentas de investigação policial com `suggestTools(missingFields, crimeTypes)`.

**Ferramentas catalogadas:** BISP, INFOSEG, Sinesp, SESP/DHPP, Receita Federal, DETRAN-MG, Redes Sociais, WhatsApp Operacional

**API:** `suggestTools(missingFields[], crimeTypes[])` → retorna ferramentas ordenadas por gravidade (homicídio > lesão > tráfico > arma > roubo > furto)

**Componente:** `lib/config/tool-registry.ts`
**Tags:** `intelligence`, `investigation`, `tools`, `police`, `suggestion`

---

## §49 — Chat Central Neo4j Conectado (2026-05-04)

**Quality:** A | **Repo:** intelink | **Commit:** dbb7ab8

Chatbot `/chat` agora conectado à base real de dados Neo4j (16k+ pessoas, REDS).

**Mudanças:**
- `loadCentralContext()` injeta stats Neo4j (total_persons, total_reds, top 5 por REDS) no contexto
- `get_top_connected_entities` usa Neo4j em modo central (sem investigationId)
- `GLOBAL_TOOLS` expandido: global_search + get_top_connected_entities + detect_criminal_articles + assess_risk
- System prompt corrigido: não nega mais acesso a dados REDS

**Tags:** `chatbot`, `neo4j`, `rag`, `intelligence`, `central-mode`

---

## §50 — EGOS Project Atlas (2026-05-04)

**Quality:** A | **Repo:** egos | **Commits:** ATLAS-1.1/1.2/1.3

Registry centralizado de todos os projetos EGOS no Supabase com busca híbrida FTS + semântica.

**Schema:** `egos_project_atlas` — slug, name, tagline, stack[], features[], embeddings (1536 dims), searchable tsvector
**Embeddings:** `openai/text-embedding-3-small` via OpenRouter (8 projetos seedados)
**Endpoints:** `GET /api/atlas/search?q=&mode=semantic|fts|auto` + `GET /api/atlas/projects`
**Populate:** `bun scripts/atlas-populate.ts --exec`
**EGOS Network footer:** pixelart.egos.ia.br carrega projetos dinamicamente via Atlas API

**Tags:** `atlas`, `search`, `registry`, `semantic`, `pgvector`, `embeddings`

---

## §51 — Atlas Semantic Search + pgvector RPC (2026-05-04)

**Quality:** A | **Repo:** egos | **Supabase fn:** `search_atlas_semantic()`

Busca semântica via cosine similarity no `embedding_purpose`. Fallback automático: semantic → FTS → ilike.

**Tested:** "vídeo commercial filmmaking" → PixelArt 54.6% similarity (correto)
**RPC function:** `search_atlas_semantic(query_embedding vector(1536), match_count int)`
**Client:** lab.egos.ia.br/api/atlas/search?mode=semantic (gera embedding on-the-fly via OpenRouter)

**Tags:** `semantic-search`, `pgvector`, `atlas`, `embeddings`, `rpc`

---

## §52 — llm.egos.ia.br — Ollama Gateway (2026-05-04)

**Quality:** A | **Repo:** egos | **URL:** https://llm.egos.ia.br

Acesso externo autenticado ao Ollama local (VPS Hetzner). Bearer token protegido via Caddy.

**Modelos disponíveis:** `intelink-agente-v1` (QLoRA fine-tuned), `qwen2.5:7b`, `intelink-agente`, `llama3.1:8b`
**Auth:** `Authorization: Bearer <token>` (token em /opt/bracc/infra/Caddyfile)
**DNS:** `llm.egos.ia.br → 204.168.217.125` propagado (2026-05-04)
**Timeout:** 180-240s response (modelos grandes precisam de tempo)

**Tags:** `llm`, `ollama`, `gateway`, `local-model`, `auth`

---

## §53 — CBC-PATTERN-v1 — Capability Card System (2026-05-04)

**Quality:** A | **Repo:** egos | **Path:** docs/capabilities/

Sistema de registro de capabilities reutilizáveis com frontmatter YAML padronizado. 13 cards criados (5 kernel + 2 PixelArt + 4 Onda 2 + 2 Intelink).

**Template:** `docs/capabilities/_TEMPLATE.md`
**Cards kernel:** GUARD-BR-001, HERMES-001, EVOLUTION-001, TELEGRAM-ALERT-001, LEAD-CAPTURE-001
**Cards PixelArt:** PIXEL-PROMPT-001, STORAGE-001, IMG-GEN-001, IG-PUBLISHER-001, BRIEFING-GEN-001, LEAD-SCORER-001
**Cards Intelink:** NER-001, FACE-001 (via outra janela)
**Disseminação:** CLAUDE.md global + egos/CLAUDE.md SSOT Map + MEMORY.md

**Tags:** `governance`, `capabilities`, `cbc-pattern`, `registry`, `documentation`

---

## §54 — CRON_SECRET + Intelink Cross-Ref Nightly (2026-05-04)

**Quality:** A | **Repo:** intelink | **Endpoint:** /api/cron/cross-ref-nightly

CRON_SECRET configurado no intelink .env (era vazio, bloqueando auth). Rebuild feito. Cron nightly testado com sucesso.

**Secret:** `intelink_cron_3d5f9fa9a9c4b11b93b1ec4cb69c513b`
**Output testado:** `{"ok":true, "elapsed": 79.9s, "mentioned_in_created": 166, "fuzzy_matches": 62}`
**Também em:** egos-hq container env (CRON_SECRET + STRIPE_SECRET_KEY + STRIPE_RESTRICTED_KEY)

**Tags:** `cron`, `intelink`, `nightly`, `cross-ref`, `auth`

---

## §55 — EGOS Trading Dashboard (2026-05-04)

**Quality:** A | **Repo:** egos | **URL:** egos.ia.br/trading | **Module:** `apps/egos-site/src/trading.ts`

Dashboard de análise e automação de trading de criptomoedas integrado ao EGOS. 6 abas funcionais.

### Capacidades implementadas (v2.0)

| Capacidade | Endpoint | Auth | Status |
|-----------|---------|------|--------|
| Ticker de preços live (BTC/ETH/SOL/BNB/XRP) | `GET /trading/market` | Pública | ✅ |
| Top 60 pares por volume (pair picker) | `GET /trading/instruments` | Pública | ✅ |
| Klines históricos Bybit (candles) | `GET /trading/klines` | Pública | ✅ |
| Parser CSV Bybit (3 formatos) | `POST /trading/analyze` | Sem auth | ✅ |
| Engine de padrões + recomendações | `POST /trading/analyze` | Sem auth | ✅ |
| API Bybit — saldos | `POST /trading/bybit/connect` | API key | ✅ |
| API Bybit — ordem spot | `POST /trading/bybit/order` | API key | ✅ |
| Posições abertas futuros + P&L | `POST /trading/live/positions` | API key | ✅ |
| Histórico de ordens direto da API | `POST /trading/live/orders` | API key | ✅ |
| Signal Executor (TradingView→Bybit) | `POST /trading/webhook` | Webhook key | ✅ |
| Registro de webhook key | `POST /trading/webhook/register` | API key | ✅ |
| AI Insight — análise CSV | `POST /trading/ai/analyze` | Sem auth | ✅ |
| AI Insight — contexto mercado | `POST /trading/ai/market` | Sem auth | ✅ |
| AI Explainer — padrão individual | `POST /trading/ai/explain` | Sem auth | ✅ |
| Notificações Telegram | `POST /trading/notify/register` | Sem auth | ✅ |
| Notificações Discord | `POST /trading/notify/register` | Sem auth | ✅ |
| Notificações WhatsApp (Evolution) | `POST /trading/notify/register` | Sem auth | ✅ |
| Broadcast em ordem executada | interno | — | ✅ |

### LLM integration
- **Modelo:** `google/gemini-2.0-flash-001` via OpenRouter (§16)
- **Override:** `TRADING_LLM_MODEL` env var
- **Custo estimado:** ~$0.0002/análise (600 tokens)
- **Ref:** `apps/egos-site/src/trading-ai.ts`

### Notification system
- **Canais:** Telegram Bot, Discord Webhook, WhatsApp via Evolution API
- **Triggers:** `order_executed` | `webhook_error` | `daily_summary`
- **Storage:** memória de sessão (nunca persistido)
- **Ref:** `apps/egos-site/src/trading-notify.ts`

**Formatos CSV suportados:** Bybit Futures Closed P&L · Bybit Spot Orders · Bybit Order History

**Tags:** `trading`, `bybit`, `csv-analysis`, `webhook`, `signal-executor`, `llm`, `notifications`, `ai-insights`

---

## §56 — Trading AI Engine (OpenRouter/Gemini) (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `apps/egos-site/src/trading-ai.ts`

Motor de análise com LLM para o Trading Dashboard. Usa OpenRouter com Gemini 2.0 Flash.

**Rotas:**
- `POST /trading/ai/analyze` — interpreta resultado da análise CSV em PT-BR (diagnóstico + 3 ações + bot recomendado)
- `POST /trading/ai/market` — contexto de mercado baseado em preços live e funding rate
- `POST /trading/ai/explain` — explica um padrão detectado em linguagem simples

**Config:** `OPENROUTER_API_KEY` + `TRADING_LLM_MODEL` (opcional, default: `google/gemini-2.0-flash-001`)
**Alinhamento §16:** OpenRouter como canal, modelo configurável, nunca loga credenciais.

**Tags:** `trading`, `llm`, `openrouter`, `gemini`, `insights`, `ai-analysis`

---

## §57 — Trading Notification System (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `apps/egos-site/src/trading-notify.ts`

Sistema de notificações multi-canal para eventos do Trading Dashboard.

**Canais:** Telegram · Discord · WhatsApp (Evolution API já no VPS)
**Triggers:** `order_executed` · `webhook_error` · `daily_summary` · `price_alert`
**Broadcast:** chamado automaticamente no webhook executor ao executar ordens

**Rotas:**
- `POST /trading/notify/register` — registra canal (valida campos obrigatórios por tipo)
- `POST /trading/notify/test` — envia mensagem de teste formatada
- `GET /trading/notify/list` — lista canais ativos com contadores
- `POST /trading/notify/toggle` — ativa/desativa canal
- `DELETE /trading/notify/remove` — remove canal

**Tags:** `trading`, `notifications`, `telegram`, `discord`, `evolution`, `whatsapp`, `alerts`

---

## §58 — Trading Backtest Engine + Indicators (2026-05-04)

**Quality:** A | **Repo:** egos | **Modules:** `apps/egos-site/src/trading-backtest.ts` + `trading-indicators.ts`

Engine de backtest sobre klines reais do Bybit + biblioteca de indicadores técnicos em TS puro (zero deps).

### Indicadores implementados (pure TS)
- SMA, EMA (com seed correto), RSI (Wilder smoothing)
- Bollinger Bands (period + multiplicador configuráveis)
- MACD (fast, slow, signal)
- ATR (true range com EMA smoothing)
- crossedAbove/crossedBelow para detecção de cruzamentos

### Backtest Engine
- 10 tipos de regras (rsi_below/above, ema_cross_up/down, price_above/below_ema, price_drop/rise_pct, bb_lower/upper_touch)
- Lógica AND/OR para combinar regras de entrada e saída
- Stop Loss + Take Profit configuráveis (% do preço de entrada)
- Position sizing (0-100% do capital)
- Taxa por trade (default 0.1%)
- Métricas: Total Return, Win Rate, Profit Factor, Max Drawdown, Sharpe Ratio, Avg Win/Loss, Best/Worst Trade
- Equity curve por candle para visualização

### Pre-built strategies
- `rsi_mean_reversion` — RSI<30 + preço>EMA200, exit RSI>70 (conservador)
- `ema_trend_follow` — EMA20 cruza EMA50, exit no cross-down (testado: +9.23% em 1000 candles BTC 1h)
- `bb_squeeze` — Bollinger lower + RSI<35
- `buy_the_dip` — queda 5% em 10 candles + preço>EMA200

### Customização (frontend)
- Strategy Builder visual: adicionar/remover regras, escolher tipo, ajustar thresholds
- Save/Load estratégias customizadas via localStorage do browser
- Preset selector com 4 estratégias prontas
- Toggle de indicadores no gráfico (EMA20/50/200, Bollinger Bands)

### Visualização (lightweight-charts via CDN)
- Gráfico de candles (TradingView lightweight-charts v4.2.0, MIT)
- Overlays de indicadores (EMAs, Bollinger Bands)
- Markers de entrada/saída (setas verdes/vermelhas)
- Equity curve em chart separado
- Tabela de trades completa com motivo de saída

**Endpoints:**
- `POST /trading/backtest/run` — roda backtest e retorna resultado completo + candles + indicators
- `GET /trading/backtest/presets` — lista estratégias prontas

**Tags:** `trading`, `backtest`, `indicators`, `strategies`, `lightweight-charts`, `pure-typescript`, `customizable`

---

## §59 — Trading Risk Calculator (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** integrado em `trading.ts` (UI + JS)

Calculadora de risco no client-side (sem chamadas server).

**Inputs:** Capital, Risk % por trade, Preço de entrada, Stop Loss, Alavancagem, R:R ratio
**Outputs:**
- Tamanho da posição em USDT
- Tamanho em units do ativo
- Margem necessária (com leverage)
- Distância % do stop
- Take Profit calculado pelo R:R
- Max Loss em USDT
- Reward potencial em USDT
- Liquidação estimada (quando leverage > 1)

Recálculo automático em tempo real conforme o usuário edita.

**Tags:** `trading`, `risk-management`, `calculator`, `position-sizing`, `client-side`

---

## §60 — Trading Storage (Supabase Persistence) (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `apps/egos-site/src/trading-storage.ts`
**Supabase Project:** `lhscgsqhiooyatkebose` (egos-lab) | **Tables:** 7 com prefixo `trading_`

Camada de persistência completa para o Trading Dashboard. Substitui localStorage por DB compartilhado.

### Tabelas criadas

| Tabela | Descrição |
|--------|-----------|
| `trading_strategies` | Estratégias customizadas (regras + risk + capital) |
| `trading_watchlists` | Watchlists customizáveis de pares (auto-cria Default) |
| `trading_backtest_runs` | Histórico de execuções de backtest com métricas |
| `trading_bots` | Bots ativos (DCA, Grid, webhook_strategy, price_alert) |
| `trading_bot_executions` | Audit trail de cada ação de bot (FK → bots) |
| `trading_price_alerts` | Alertas de preço sem execução |
| `trading_user_prefs` | Preferências por usuário (default pair, interval, etc.) |

### Pattern multi-tenant
- `user_id` text NOT NULL — UUID gerado no browser (localStorage `egos_trading_user`)
- Header `x-trading-user` enviado em toda request
- Server filtra por user_id em queries (defesa-em-profundidade mesmo sem RLS)
- Estratégias podem ser `is_public=true` para compartilhar entre usuários

### Endpoints
- CRUD em `/trading/storage/strategies`, `/watchlists`, `/backtest-runs`, `/prefs`
- Auto-create de watchlist Default na primeira chamada
- Triggers `set_updated_at` em strategies/watchlists/bots/prefs

**Tags:** `trading`, `supabase`, `persistence`, `multi-tenant`, `user-prefs`, `watchlists`

---

## §61 — Trading Bot Creator (DCA + Grid via Bybit API) (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `apps/egos-site/src/trading-bots.ts`

Bot creator que executa estratégias DCA (compra recorrente) e Grid (ordens em escada) via Bybit API direta. Persistência completa no Supabase.

### Tipos de bot

| Tipo | Como funciona |
|------|---------------|
| **DCA** | Market buy do valor X a cada N horas. Cron checa `next_run_at` periodicamente |
| **Grid** | Coloca todas as ordens limit imediatamente — N compras abaixo + N vendas acima do preço atual |

### Endpoints
- `POST /trading/bots/create` — cria config (status=inactive)
- `POST /trading/bots/start/:id` — para Grid: coloca ordens. Para DCA: ativa scheduler
- `POST /trading/bots/stop/:id` — pausa + cancela ordens (Grid)
- `DELETE /trading/bots/:id` — remove config
- `GET /trading/bots/list` — lista bots (sem expor apiKey/Secret)
- `GET /trading/bots/executions/:id` — log de execuções (até 50 últimas)
- `POST /trading/bots/run-due` — cron endpoint: executa DCA bots com `next_run_at <= now`. Auth via `CRON_SECRET`

### Multi-Timeframe Backtest

Endpoint adicional em `trading-backtest.ts`:
- `POST /trading/backtest/multi-tf` — roda mesma estratégia em 15m/1h/4h/1D simultaneamente
- Retorna métricas comparativas para identificar melhor timeframe

### Validação real
- BTC EMA Trend Follow Multi-TF testado: 1h=+4.08% | 4h=+6.25% (best) | 1D=+1.49%
- Mostra que estratégia funciona melhor em 4h

### Cron necessário (próximo passo)
```bash
# Adicionar ao crontab do VPS:
*/5 * * * * curl -X POST -H "Authorization: Bearer $CRON_SECRET" https://egos.ia.br/trading/bots/run-due
```

**Tags:** `trading`, `bot-creator`, `dca`, `grid`, `bybit`, `multi-timeframe`, `supabase`

---

## §62 — Trading Evolution (WhatsApp QR inline) (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `apps/egos-site/src/trading-evolution.ts`

Integração nativa com Evolution API (já no VPS) — segue mesmo padrão do SSOT
`apps/egos-hq/public/whatsapp-connect.html`. QR code inline com auto-refresh 55s,
status polling, isolamento por usuário (instâncias prefixadas `trading-{userId}`).

**Endpoints:**
- `GET /trading/evolution/list` — lista instâncias do usuário (filtra por prefixo)
- `POST /trading/evolution/create` — cria nova (máx 3/usuário)
- `GET /trading/evolution/qr/:instance` — QR fresco + status polling
- `POST /trading/evolution/disconnect/:instance` — logout (mantém)
- `DELETE /trading/evolution/:instance` — remove
- `POST /trading/evolution/send-test/:instance` — mensagem de teste

**UX:** Modal QR com countdown bar verde→amarelo→vermelho, polling de conexão a cada 3s, ao conectar oferece "+ Adicionar como canal" que registra automaticamente em `trading-notify` com `apiKey='internal'` (usa env do servidor).

**Tags:** `trading`, `whatsapp`, `evolution`, `qr-code`, `notifications`

---

## §63 — Trading Centralized Credentials (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `trading.ts` (settings modal + JS)

Painel único de credenciais Bybit no header. Substitui inputs duplicados em 5 abas.

- LocalStorage `egos_bybit_creds` `{ key, secret, mode }`
- Mode: `readonly` (badge verde) | `trade` (badge laranja)
- Auto-fill em todos os inputs (`bybit-key`, `live-key`, `wh-key`, `bot-api-key`, etc.) a cada 1s
- Status indicator no header (verde pulsando = readonly, laranja = trade, cinza = não configurado)
- Test connection antes de salvar
- Clear creds com confirmação

**Tags:** `trading`, `credentials`, `localStorage`, `single-source-of-truth`, `ux`

---

## §64 — Trading RLS Hardening (2026-05-04)

**Quality:** A | **Repo:** egos-lab Supabase | **Migration:** `trading_dashboard_rls`

Row Level Security habilitado em todas as 7 tabelas `trading_*`.
- Anon/authenticated: acesso negado (sem policies = sem acesso)
- Server (egos-site): usa `SUPABASE_SERVICE_KEY` que bypassa RLS
- Exceção: policy `anon_read_public_strategies` para futura strategy library pública (`is_public=true`)

**Tags:** `trading`, `supabase`, `rls`, `security`

---

## §65 — Trading Multi-Exchange Layer + Ticker Customization (2026-05-04)

**Quality:** A | **Repo:** egos | **Modules:** `trading-exchanges.ts` + ticker config in `trading.ts`

Camada de abstração para múltiplas exchanges + ticker totalmente customizável.

### Multi-Exchange (`trading-exchanges.ts`)
- Interface `ExchangeAdapter` com: id, label, status, features, signaturePattern, getTicker, validateAuth
- **Bybit** (live) — getTicker + validateAuth implementados
- **Binance** (beta) — getTicker + validateAuth implementados (sem order/cancel ainda)
- **OKX** (planned) — stub
- **Hyperliquid** (planned) — stub (RSA signing)

**Endpoints:**
- `GET /trading/exchanges/list` — lista adapters disponíveis
- `GET /trading/exchanges/ticker/:exchange/:symbol` — ticker multi-exchange
- `POST /trading/exchanges/validate` — valida API key em qualquer exchange

### Ticker Customization
- Pares customizáveis (até 12) via modal
- Refresh interval: 10s / 30s / 1min / 5min / manual
- Currency: USD ou BRL (auto-conversão via /fx-rate)
- Source: Bybit (default) ou Binance (beta)
- Timestamp ao vivo + tooltip com fonte
- Persistência em localStorage `egos_ticker_cfg`

### `/fx-rate` endpoint
- Free FX via awesomeapi.com.br (USD/BRL)
- Cache 5min server-side
- Fallback rate=5.0 se API down

**Tags:** `trading`, `multi-exchange`, `ticker`, `customization`, `fx-rate`, `binance`, `okx`, `hyperliquid`

---

## §66 — Trading Sprint 1 Hardening (2026-05-04)

**Quality:** A | **Repo:** egos | **Modules:** `trading-crypto.ts`, `trading-alerts.ts` + middleware in `trading.ts`

Sprint 1 — Operacionalização e segurança de bots/alertas.

### Encryption at rest (`trading-crypto.ts`)
- AES-256-GCM com env `TRADING_ENCRYPTION_KEY` (64 hex chars = 32 bytes)
- Format: `enc:v1:<base64(iv[12]+tag[16]+ct)>`
- Backward-compat: valores sem prefixo retornam plain (legacy migration lazy)
- Aplicado em `trading_bots.config.apiKey/apiSecret` (encrypt on create, decrypt on use)

### Number whitelist (`trading-evolution.ts`)
- Env `TRADING_WHATSAPP_ALLOWED` (CSV de números) ou `WHATSAPP_ALLOWED_NUMBERS` (compat)
- Enforcement no GET `/qr/:instance` quando status=connected
- Auto-revoga conexão de número não autorizado + retorna 403

### Price Alerts (`trading-alerts.ts`)
- Tabela `trading_price_alerts` (já existia da Fase 5)
- CRUD: list, create, toggle, delete
- Cron `POST /alerts/check` (auth via CRON_SECRET):
  - Single batch fetch Bybit tickers
  - Para cada alert: testa above/below, anti-spam 1h
  - Trigger via `broadcastNotification('price_alert', msg)` para todos canais ativos
- UI inline na aba Live (criar + listar + toggle + delete)

### Rate Limiting (`trading.ts` middleware)
- Token bucket por IP, in-memory, cleanup 10min
- 60 req/min para `/market`, `/instruments`, `/klines`, `/fx-rate`
- 10 req/min para `/analyze` (CSV parser intensivo)
- Headers respondidos: 429 + JSON com mensagem em PT-BR

### Cron VPS (manual setup)
```bash
*/5 * * * * curl -fsS -X POST -H "Authorization: Bearer $CRON_SECRET" https://egos.ia.br/trading/bots/run-due
*/2 * * * * curl -fsS -X POST -H "Authorization: Bearer $CRON_SECRET" https://egos.ia.br/trading/alerts/check
```

**Tags:** `trading`, `security`, `encryption`, `aes-256-gcm`, `rate-limit`, `whitelist`, `price-alerts`, `cron`

---

## §67 — Trading News Aggregator (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `trading-news.ts` + `trading_news_sources` table

Agregador de notícias cripto via fontes gratuitas. Cache 10min server-side.

### Fontes default (12)
- **RSS:** CoinDesk, CoinTelegraph, Decrypt, The Block, Bitcoin Magazine, CryptoSlate, NewsBTC
- **Reddit JSON:** r/CryptoCurrency, r/Bitcoin, r/ethereum, r/CryptoMarkets
- **Special:** Fear & Greed Index (alternative.me)

### Custom sources (per user)
- Tabela `trading_news_sources` com tipo: rss, reddit, youtube, twitter
- UI inline na aba News para adicionar/remover
- YouTube via RSS oficial (`/feeds/videos.xml?channel_id=UC...`)

### Endpoints
- `GET /trading/news/feed?cacheMin=10` — feed agregado, ordenado por data desc
- `GET /trading/news/sources` — lista defaults + custom
- `POST /trading/news/sources` — adiciona fonte custom
- `DELETE /trading/news/sources/:id` — remove

### Custo
$0/mês — todas fontes gratuitas, cache evita rate limit, parsing puro TS sem deps.

**Tags:** `trading`, `news`, `rss`, `reddit`, `youtube`, `fear-greed`, `aggregator`

---

## §68 — Trading Sprint 2 Strategy Deploy (2026-05-04)

**Quality:** A | **Repo:** egos | **Module:** `trading-deploy.ts`

Sprint 2 — Estratégia → Production em 1-clique.

### STR-001: Backtest history viewer
- Modal com lista dos últimos 20 runs
- Métricas: trades, win rate, profit factor, retorno
- Click linha → detalhes (placeholder para próximo sprint)

### STR-002: Deploy as webhook
- Botão "🚀 Deploy" no Lab tab pós-backtest
- `POST /trading/deploy/deploy` cria bot type='webhook_strategy'
- **Auto-gera Pine Script** com strategy.entry/exit + alert_message JSON
- Webhook key salva em `trading_bots.webhook_key`
- Webhook receiver lê do DB se key não está em memória (persistente entre restarts)

### STR-004: TP/SL auto-setup
- Webhook payload aceita `takeProfitPct` e `stopLossPct`
- Após entrada bem-sucedida, server calcula preços e coloca:
  - TP: limit order do lado oposto
  - SL: stop order com triggerPrice + triggerDirection

### STR-005: Conditional orders
- Webhook payload aceita `triggerPrice`, `triggerDirection`, `triggerBy`, `reduceOnly`
- Permite ordens stop-loss / take-profit standalone via webhook
- `orderFilter: 'StopOrder'` quando trigger é definido

### STR-003: Strategy library
- `GET /trading/deploy/library` — lista estratégias `is_public=true`
- Foundation pronta, UI pública será adicionada em sprint futuro

### Pine Script generator
Mapeia 10 tipos de regras EGOS para Pine Script v5:
- `rsi_below/above` → `ta.rsi() < N`
- `ema_cross_up/down` → `ta.crossover/under(ta.ema(), ta.ema())`
- `price_above/below_ema` → `close > ta.ema()`
- `price_drop/rise_pct` → `(close[N] - close) / close[N] * 100 >= X`
- `bb_lower/upper_touch` → `low <= ta.bb().lower`

**Tags:** `trading`, `strategy-deploy`, `pine-script`, `webhook`, `tp-sl`, `conditional-orders`
