# Codex Local Review — 2026-06-01T16:50:20Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.3-codex
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019e8417-ecf4-7560-bd3e-28914bf09526
--------
user
changes against 'HEAD~3'
2026-06-01T16:50:23.039666Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T16:50:23.697601Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff dfe3f828208b273421e3e0233d24efbeb8bb789c' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.claude/commands/banda.md b/.claude/commands/banda.md
index c2c7143e..9af9b9ae 100644
--- a/.claude/commands/banda.md
+++ b/.claude/commands/banda.md
@@ -4,7 +4,7 @@ description: Banda Cognitiva — revisão hierárquica em 4 papéis (Crítico 
 
 # /banda — Banda Cognitiva
 
-> **Script:** `bun scripts/banda.ts` | **Integração:** `docs/governance/PREMORTEM_BANDA_INTEGRATION.md`
+> **SSOT:** `docs/governance/BANDA_COGNITIVA.md` (membros, roster funcional, wiring, modularização) | **Script:** `bun scripts/banda.ts` | **Fluxo:** `docs/governance/PREMORTEM_BANDA_INTEGRATION.md`
 > **Princípio:** nenhuma decisão importante passa por uma única perspectiva. 4 papéis sequenciais — cada um vê o output do anterior.
 
 ## Quando invocar
diff --git a/.guarani/RULES_INDEX.md b/.guarani/RULES_INDEX.md
index 4ad61b1d..8ed9c4bc 100644
--- a/.guarani/RULES_INDEX.md
+++ b/.guarani/RULES_INDEX.md
@@ -1,6 +1,6 @@
 # EGOS Rules Index — Canonical Discovery Map
 
-> **Version:** 1.2.1 | **Updated:** 2026-05-30
+> **Version:** 1.2.1 | **Updated:** 2026-06-01
 > **Purpose:** Single entry point for ALL EGOS rules, standards, and governance surfaces.
 > Any AI session or human contributor starts here to find the relevant rule.
 
@@ -32,6 +32,10 @@
 | **MCP quality** | MCP_TOOL_QUALITY_FRAMEWORK.md | `.guarani/standards/MCP_TOOL_QUALITY_FRAMEWORK.md` |
 | **MCP usage / registry** | MCP_REGISTRY.md (§Quando usar MCP) | `docs/governance/MCP_REGISTRY.md` |
 | **Domain rules** | DOMAIN_RULES.md | `.guarani/orchestration/DOMAIN_RULES.md` |
+| **Open access sourcing** | OPEN_ACCESS_SOURCING_RULE.md | `docs/governance/OPEN_ACCESS_SOURCING_RULE.md` |
+| **Agent scope gates** | agent-scope-check.ts | `scripts/security/agent-scope-check.ts` |
+| **Literature API** | OA REST + MCP | `apps/egos-hq/api/hq/literature/` + `packages/mcp-literature/` |
+| **Coordination monitor** | COORDINATION_MONITOR_SPEC.md | `docs/governance/COORDINATION_MONITOR_SPEC.md` |
 | **Pre-commit hooks** | pre-commit | `.husky/pre-commit` |
 | **Presentations versioning** | GOV-PRES-001 | `CLAUDE.md §7 Presentations` + `scripts/check-doc-proliferation.sh` |
 | **File classification** | file-intelligence.sh | `scripts/file-intelligence.sh` |
diff --git a/TASKS.md b/TASKS.md
index 9b852cba..25d31c30 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -530,6 +530,14 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **OA-API-001** [P1] — Condensar numa API Mestra: `/v1/literature/resolve?q=` → `open-access-fetch` → opcional LLM (resumo/extração via llm-router). Expor como MCP (`mcp-knowledge` ou `mcp-literature`) p/ ChatGPT/EVA. Orquestra fontes primárias atrás de 1 interface.
 - [ ] **OA-LLM-001** [P2] — Camada LLM: dado o texto OA, resumir/extrair/citar com provenance (cada claim → fonte). Liga a `egos-knowledge`.
 
+## 📡 DIFF TELEMETRY + DRIFT ACCEPTANCE — sinal multi-agente (Enio 2026-06-01)
+
+> SSOT/sinal: `docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md`. Reusa coordination-watcher + history.jsonl + drift detectors. Aceite = drift score ≥80 (80/20) → ≥99. Construção distribuída entre agentes = o teste.
+- [ ] **TELEM-DIFF-001** [P1] — watcher post-commit loga diff-stats + cadence no `coordination-history.jsonl`.
+- [ ] **TELEM-DRIFT-001** [P1] — `scripts/drift-score.ts` composto (doc-drift+task-drift+manifest+ui+rule-sync) normalizado 0-100 → blackboard.
+- [ ] **TELEM-SCOREBOARD-001** [P2] — expor drift score no /status + blackboard (liga FE-SYNC).
+- [ ] **TELEM-AGENTS-001** [P2] — protocolo agente: lê blackboard no /start, loga diff no /end (+ start-guarani).
+
 ## 🔍 RADICAL TRANSPARENCY / PROOF ARCHITECTURE — validação (Enio 2026-06-01) [pesquisa, NÃO impl ainda]
 
 > Missão: descobrir SE blockchain melhora a governança de IA do EGOS — não assumir que sim. Se não, focar em Git+signed-commits+audit-logs+OpenTelemetry+Guard Brasil+capability-registry. Dossiê: `docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md` (workflow `blockchain-governance-validation`). Regra: só hash/manifest/attestation on-chain; contexto rico off-chain. Sem PII/secrets/conteúdo investigativo on-chain. Sem token.
@@ -554,7 +562,9 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **HITL-MULTICHANNEL-001** [P3] — Wire a política HITL multi-canal (Telegram+WhatsApp+email) que aparece em `.guarani/GUARANI.md` mas só tem Telegram parcial. Dispatcher único por policy.
 - [ ] **PUBLIC-CHATBOT-001** [P3] `redzone` — Chatbot escopado no egos.ia.br que carrega contexto via MCPs e explica o EGOS. Pré-req: SITE-VOICE-001 + landing estável. Não iniciar antes da copy aprovada.
 - [ ] **INTAKE-CHATGPT-001b** [P2] `redzone` — `egos_copy_5_versoes_meta_prompt.md` alimenta SITE-VOICE-001: composite V1(alma)+V2(investigação/ciber, MAIOR risco institucional, revisão PCMG)+V3(README técnico)+V5(convite). NADA publicado verbatim sem corte do Enio.
-- [ ] **RULE-DISCOVERY-001** [P1] `prime` — Sweep de TODOS os conjuntos de regras (kernel + leaf repos `/home/enio/*`): glob CLAUDE.md/AGENTS.md/SOUL.md/RULES_INDEX/.guarani/INHERITS/governance → índice `docs/governance/RULE_SETS_INDEX.md` (repo→regras→tier→última verificação) + detectar conflito (`.guarani` prevalece). Alimenta /start + herança Layer 0.
+- [ ] **RULE-GOV-GAP-001** [P2] — `gem-hunter` ungoverned (sem CLAUDE.md/AGENTS.md). Decidir: adicionar adapter+symlinks .guarani (modelo egos-lab/852) OU marcar explicitamente externo.
+- [ ] **RULE-SYNC-001** [P2] — `blueprint-egos` 45d stale (sync a6d1ad7 2026-04-17). Rodar `bun scripts/disseminate-propagator.ts --all` p/ ressincronizar do kernel atual.
+- [ ] **INTAKE-WIRE-001b** [P3] — Wire RULE_SETS_INDEX no /start (consciência de quais regras valem onde) + monitor de lag de propagação (>30d alerta).
 - [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start (rule-set awareness) + gatilho comportamental do Prime + considerar virar skill `/intake`.
 
 ## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 5b1d2fb8..0f2b4bfe 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3339,3 +3339,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
 - [x] **INTAKE-CHATGPT-001** — Processado via protocolo (agente Sonnet). 35 claims: 22 REAL / 9 CONCEPT / **4 PHANTOM** (não agir: "R$100/mês" leitura stale do pricing; arquivos de agente que já existem; path `docs/policies/` inexistente; "não há agent registry" falso). Raw fica local (~/Downloads, não commitar 700KB de chat). Acionáveis ↓.
 
+
+## Archived 2026-06-01
+
+### 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
+- [x] **RULE-DISCOVERY-001** — Sweep feito (Explore). Índice `docs/governance/RULE_SETS_INDEX.md` (40+ arquivos, 8 repos+2 config dirs, hierarquia canônica, zero conflito). Validei por path (subagente errou egos-inteligencia=ungoverned → corrigido, INC-006).
+
diff --git a/apps/egos-hq/app/api/hq/literature/route.ts b/apps/egos-hq/app/api/hq/literature/route.ts
new file mode 100644
index 00000000..7694c90f
--- /dev/null
+++ b/apps/egos-hq/app/api/hq/literature/route.ts
@@ -0,0 +1,225 @@
+/**
+ * /api/hq/literature — Open Access Literature Resolver API
+ *
+ * Capability §105 exposed as REST endpoint.
+ * SSOT: docs/governance/OPEN_ACCESS_SOURCING_RULE.md
+ *
+ * GET  /api/hq/literature?q=<doi|arxiv|title>
+ * GET  /api/hq/literature?q=1706.03762&download=true  → 302 redirect to PDF
+ * POST /api/hq/literature  body: { queries: string[] }  → batch resolve
+ */
+import { NextRequest, NextResponse } from 'next/server';
+
+const EMAIL = process.env.EGOS_CONTACT_EMAIL ?? 'research@egos.ia.br';
+const UA = `EGOS-literature-api/1.0 (mailto:${EMAIL})`;
+
+// ── Types ─────────────────────────────────────────────────────────────────────
+export interface OAResult {
+  found: boolean;
+  query: string;
+  doi?: string;
+  title?: string;
+  year?: number;
+  isOA?: boolean;
+  pdfUrl?: string;
+  landingUrl?: string;
+  license?: string;
+  source?: 'unpaywall' | 'openalex' | 'arxiv' | 'crossref' | 'none';
+  note?: string;
+}
+
+// ── Helpers ───────────────────────────────────────────────────────────────────
+async function j(url: string): Promise<unknown> {
+  try {
+    const r = await fetch(url, {
+      headers: { 'User-Agent': UA, Accept: 'application/json' },
+      signal: AbortSignal.timeout(12000),
+    });
+    if (!r.ok) return null;
+    return await r.json();
+  } catch {
+    return null;
+  }
+}
+
+const isDoi = (s: string) =>
+  /^10\.\d{4,9}\/\S+$/.test(s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, ''));
+const normDoi = (s: string) =>
+  s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, '');
+const isArxiv = (s: string) =>
+  /^(arxiv:)?\d{4}\.\d{4,5}(v\d+)?$/i.test(s.trim());
+
+async function viaUnpaywall(doi: string): Promise<OAResult | null> {
+  const d = await j(
+    `https://api.unpaywall.org/v2/${encodeURIComponent(doi)}?email=${encodeURIComponent(EMAIL)}`
+  ) as Record<string, unknown> | null;
+  if (!d) return null;
+  const loc = d.best_oa_location as Record<string, unknown> | null;
+  return {
+    found: true,
+    query: doi,
+    doi,
+    title: d.title as string | undefined,
+    year: d.year as number | undefined,
+    isOA: !!d.is_oa,
+    pdfUrl: (loc?.url_for_pdf as string) ?? undefined,
+    landingUrl: ((loc?.url_for_landing_page ?? loc?.url) as string) ?? undefined,
+    license: (loc?.license as string) ?? undefined,
+    source: 'unpaywall',
+    note: d.is_oa
+      ? `OA via ${(loc?.host_type as string) ?? '?'}`
+      : 'No legal OA version found.',
+  };
+}
+
+async function viaOpenAlexDoi(doi: string): Promise<OAResult | null> {
+  const d = await j(
+    `https://api.openalex.org/works/doi:${encodeURIComponent(doi)}?mailto=${encodeURIComponent(EMAIL)}`
+  ) as Record<string, unknown> | null;
+  if (!d?.id) return null;
+  const oa = d.open_access as Record<string, unknown> | null;
+  const loc = d.best_oa_location as Record<string, unknown> | null;
+  return {
+    found: true,
+    query: doi,
+    doi,
+    title: d.title as string | undefined,
+    year: d.publication_year as number | undefined,
+    isOA: !!oa?.is_oa,
+    pdfUrl: ((loc?.pdf_url ?? oa?.oa_url) as string) ?? undefined,
+    landingUrl: ((loc?.landing_page_url ?? oa?.oa_url) as string) ?? undefined,
+    license: (loc?.license as string) ?? undefined,
+    source: 'openalex',
+    note: oa?.is_oa ? `OA status: ${oa?.oa_status}` : 'Closed in OpenAlex.',
+  };
+}
+
+async function viaOpenAlexSearch(title: string): Promise<OAResult | null> {
+  const d = await j(
+    `https://api.openalex.org/works?search=${encodeURIComponent(title)}&per_page=1&mailto=${encodeURIComponent(EMAIL)}`
+  ) as Record<string, unknown> | null;
+  const results = d?.results as Record<string, unknown>[] | undefined;
+  const w = results?.[0];
+  if (!w) return null;
+  const oa = w.open_access as Record<string, unknown> | null;
+  const loc = w.best_oa_location as Record<string, unknown> | null;
+  return {
+    found: true,
+    query: title,
+    doi: (w.doi as string)?.replace('https://doi.org/', ''),
+    title: w.title as string | undefined,
+    year: w.publication_year as number | undefined,
+    isOA: !!oa?.is_oa,
+    pdfUrl: ((loc?.pdf_url ?? oa?.oa_url) as string) ?? undefined,
+    landingUrl: ((loc?.landing_page_url ?? oa?.oa_url) as string) ?? undefined,
+    license: (loc?.license as string) ?? undefined,
+    source: 'openalex',
+    note: `matched "${w.title as string}"`,
+  };
+}
+
+async function viaArxiv(id: string): Promise<OAResult | null> {
+  const aid = id.replace(/^arxiv:/i, '');
+  try {
+    const r = await fetch(
+      `http://export.arxiv.org/api/query?id_list=${encodeURIComponent(aid)}`,
+      { headers: { 'User-Agent': UA }, signal: AbortSignal.timeout(12000) }
+    );
+    if (!r.ok) return null;
+    const xml = await r.text();
+    const titles = xml.match(/<title>([\s\S]*?)<\/title>/g);
+    const title = titles?.[1]?.replace(/<\/?title>/g, '').trim();
+    if (!title) return null;
+    return {
+      found: true,
+      query: id,
+      title,
+      isOA: true,
+      pdfUrl: `https://arxiv.org/pdf/${aid}`,
+      landingUrl: `https://arxiv.org/abs/${aid}`,
+      license: 'arXiv',
+      source: 'arxiv',
+      note: 'preprint',
+    };
+  } catch {
+    return null;
+  }
+}
+
+export async function resolveOpenAccess(query: string): Promise<OAResult> {
+  const q = query.trim();
+  if (isArxiv(q)) {
+    const a = await viaArxiv(q);
+    if (a) return a;
+  }
+  if (isDoi(q)) {
+    const doi = normDoi(q);
+    const u = await viaUnpaywall(doi);
+    if (u?.pdfUrl || u?.landingUrl) return u;
+    const o = await viaOpenAlexDoi(doi);
+    if (o?.pdfUrl || o?.landingUrl) return o;
+    return u ?? o ?? { found: false, query: q, source: 'none', note: 'DOI not found in OA sources.' };
+  }
+  const s = await viaOpenAlexSearch(q);
+  if (s) return s;
+  return { found: false, query: q, source: 'none', note: 'No match found.' };
+}
+
+// ── GET handler ───────────────────────────────────────────────────────────────
+export async function GET(req: NextRequest) {
+  const q = req.nextUrl.searchParams.get('q')?.trim();
+  const download = req.nextUrl.searchParams.get('download') === 'true';
+
+  if (!q) {
+    return NextResponse.json(
+      {
+        error: 'Missing query param `q`',
+        usage: 'GET /api/hq/literature?q=<doi|arxiv-id|title>',
+        example: 'GET /api/hq/literature?q=1706.03762',
+        capabilities: ['doi', 'arxiv-id', 'title-search', 'batch-POST'],
+      },
+      { status: 400 }
+    );
+  }
+
+  const result = await resolveOpenAccess(q);
+
+  // Redirect to PDF if requested and available
+  if (download && result.pdfUrl) {
+    return NextResponse.redirect(result.pdfUrl, 302);
+  }
+
+  return NextResponse.json(result, {
+    status: result.found ? 200 : 404,
+    headers: {
+      'Cache-Control': 'public, max-age=3600', // cache 1h (OA status rarely changes)
+    },
+  });
+}
+
+// ── POST handler (batch) ──────────────────────────────────────────────────────
+export async function POST(req: NextRequest) {
+  let body: { queries?: unknown };
+  try {
+    body = await req.json();
+  } catch {
+    return NextResponse.json({ error: 'Invalid JSON body' }, { status: 400 });
+  }
+
+  if (!Array.isArray(body.queries) || body.queries.length === 0) {
+    return NextResponse.json(
+      { error: 'Body must have `queries: string[]`' },
+      { status: 400 }
+    );
+  }
+
+  const queries = (body.queries as unknown[]).slice(0, 20).map(String); // cap at 20
+  const results = await Promise.all(queries.map(resolveOpenAccess));
+
+  return NextResponse.json({
+    count: results.length,
+    results,
+    oa_count: results.filter((r) => r.isOA).length,
+    found_count: results.filter((r) => r.found).length,
+  });
+}
diff --git a/docs/CAPABILITY_REGISTRY.md b/docs/CAPABILITY_REGISTRY.md
index b4798e66..5097b627 100644
--- a/docs/CAPABILITY_REGISTRY.md
+++ b/docs/CAPABILITY_REGISTRY.md
@@ -3328,3 +3328,41 @@ Four commands added to `.claude/commands/` after the SKILLS_REGISTRY inventory d
 **Note:** per-item CBC cards and full auto-gen parity update are D1-REMAINING incremental work. Run `bun scripts/gen-registry-parity-counts.ts --write` after all §N additions to refresh auto-gen block.
 
 **Tags:** `agents`, `skills`, `runtime`, `ts`, `dx`
+
+## §104 — Agent Scope Gate (2026-06-01)
+
+**SSOT:** `scripts/security/agent-scope-check.ts`
+**Quality:** B | **Status:** ACTIVE | **VERIFIED_AT:** 2026-06-01 | **method:** pre-commit hook execution
+**Tags:** security, governance, pre-commit, agent-scope, gate
+
+Pre-commit security gate that validates staged files against declared agent scope boundaries. Blocks commits when files outside the declared scope are staged without explicit override. Integrated into `.husky/pre-commit` §0.x. Reuse: `bun scripts/security/agent-scope-check.ts` or add `AGENT_SCOPE=<scope>` env var before committing.
+
+---
+
+## §105 — Open Access Literature Fetcher (2026-06-01)
+
+**SSOT:** `scripts/open-access-fetch.ts`
+**Quality:** B | **Status:** ACTIVE | **VERIFIED_AT:** 2026-06-01 | **method:** bun scripts/open-access-fetch.ts 10.1038/nature01244 → found, Unpaywall, PDF resolved
+**Tags:** research, open-access, unpaywall, openalex, arxiv, legal, literature
+
+Legal open-access PDF resolver using Unpaywall → OpenAlex → arXiv → Crossref chain. Replaces Sci-Hub as primary source (R-OA-001). Integrated into `gem-hunter.ts` `downloadPaperPdf()` as step 1.5. CLI: `bun scripts/open-access-fetch.ts <doi|arxiv-id>`. Governance: `docs/governance/OPEN_ACCESS_SOURCING_RULE.md`.
+
+---
+
+## §106 — Literature API + MCP Server (2026-06-01)
+
+**SSOT:** `apps/egos-hq/app/api/hq/literature/route.ts` + `packages/mcp-literature/src/index.ts`
+**Quality:** B | **Status:** ACTIVE | **VERIFIED_AT:** 2026-06-01 | **method:** tsc clean; bun resolve('1706.03762') → arxiv found
+**Tags:** mcp, api, literature, open-access, rest, batch, openalex
+
+REST endpoint (`GET/POST /api/hq/literature`) and MCP server (`port 7010, FREE auth`) exposing the §105 OA pipeline. REST supports single resolve, PDF download redirect, and batch of 20. MCP tools: `resolve_paper`, `batch_resolve`, `search_papers`. Reuse: call the REST API from any agent or connect via MCP Streamable HTTP.
+
+---
+
+## §107 — EGOS Coordination Monitor (24/7 Watcher) (2026-06-01)
+
+**SSOT:** `scripts/coordination-watcher.ts` + `docs/governance/COORDINATION_MONITOR_SPEC.md`
+**Quality:** B | **Status:** ACTIVE | **VERIFIED_AT:** 2026-06-01 | **method:** PIDs 324936/324969/431419 running; blackboard updated at 13:21
+**Tags:** monitoring, coordination, blackboard, multi-agent, telemetry, 24/7
+
+Background daemon that watches git status every 15s, invokes LLM summary on changes, writes structured blackboard to `~/.egos/coordination-blackboard.{md,json}` and `/tmp/egos-live-blackboard.{md,json}`. Mandatory: started on `/start`, `/end`, pre-commit, and VPS via PM2. Telemetry in `~/.egos/coordination-history.jsonl`. Schema: `docs/governance/COORDINATION_MONITOR_SPEC.md §2`.
diff --git a/docs/_current_handoffs/FOR_CLAUDE_CODE_2026-06-01.md b/docs/_current_handoffs/FOR_CLAUDE_CODE_2026-06-01.md
new file mode 100644
index 00000000..da1d2156
--- /dev/null
+++ b/docs/_current_handoffs/FOR_CLAUDE_CODE_2026-06-01.md
@@ -0,0 +1,113 @@
+# EGOS Claude Code — Instruções de Sessão (2026-06-01)
+
+> **PARA:** Claude Code  
+> **DE:** Antigravity/Guarani  
+> **ATUALIZADO:** 2026-06-01T13:25 BRT  
+> **LEIA ANTES DE QUALQUER COMMIT**
+
+---
+
+## 🤖 Coordination Watcher (OBRIGATÓRIO)
+
+O `coordination-watcher.ts` é um agente de monitoramento **obrigatório** que DEVE estar rodando:
+- A cada `/start` de sessão
+- A cada reinício do sistema
+- Em cada pre-commit (verificado automaticamente)
+- A cada `/end`
+
+**Para verificar:**
+```bash
+pgrep -f coordination-watcher && echo "RUNNING" || echo "STOPPED"
+```
+
+**Para iniciar se parado:**
+```bash
+cd /home/enio/egos && bun scripts/coordination-watcher.ts &
+# ou via PM2:
+pm2 start scripts/ecosystem-local.config.cjs
+```
+
+**Blackboard atual:** `~/.egos/coordination-blackboard.md`
+
+---
+
+## 📋 Estado Atual do Repo (HEAD: bdafb778)
+
+### Commits recentes (do mais recente)
+1. `bdafb778` — chore(end): session close marathon — MCP-ChatGPT live, blockchain validated
+2. `39f9d31e` — docs(tasks): ChatGPT intake — 4 phantoms rejeitados
+3. `6f23ce27` — docs(strategy): blockchain governance validation dossier
+4. `2ad87195` — feat(governance): External Artifact Intake Protocol
+5. `9a6636e3` — docs(tasks): blockchain anchoring + open-access distribution plan
+
+### Uncommitted (não urgente — só telemetria)
+- `docs/jobs/2026-06-01-doc-drift-verifier.json` (M)
+- `docs/jobs/2026-06-01-pre-commit-pipeline.json` (M)
+- `data/papers/` (untracked — gitignored OK)
+- `docs/audits/premortem-kyte-strategy.md` (untracked — commitar se relevante)
+- `docs/drafts/CHATGROK.MD` (untracked — intake pendente)
+- `docs/governance/SCIHUB_INTEGRATION_RULE.md` (gitignored — OK)
+
+---
+
+## 🎯 Próximas Tasks (por prioridade)
+
+### P0 RED ZONE (aguardam corte do Enio — NÃO executar sem aprovação)
+- `VAL-SEC-001` — Rotacionar chave Groq `gsk_Jb…` expostar em autoresearch. **Enio: revogar no console Groq + gerar nova.**
+- `VAL-004` — Corte sobre $ETHIK narrativa pública vs interno
+- `SITE-DECIDE-001` — Decisão arquitetural do site (landing mínima ou GitHub)
+
+### P1 NEXT (pode executar)
+1. **FE-SYNC-001** — egos.ia.br roda server.ts ~1931 linhas atrás (deploy drift)
+   - `apps/egos-site/` tem as mudanças; VPS não reflete
+   - Sessão dedicada + prova visual §10 obrigatória
+   
+2. **OTS-PROTO-001** — Anchoring $0 via Sigstore (signed-commit + Rekor + OTS)
+   - Implementar `egos proof verify` no CLI
+   - SSOT: `docs/governance/BLOCKCHAIN_GOVERNANCE_VALIDATION.md`
+
+3. **OA-API-001** — API Mestra de literatura open-access + MCP
+   - Base: `scripts/open-access-fetch.ts` (§105) já implementado
+   - Expor como endpoint REST + tool MCP
+
+4. **RULE-DISCOVERY-001** — Índice de regras kernel+leaf navegável
+   - Objetivo: agentes conseguem consultar qualquer regra por slug
+
+---
+
+## ⚠️ Itens de Limpeza (baixa urgência)
+- 5 stashes `wip` acumulados → `git stash drop` os antigos
+- PAT `gho_` no `.git/config` (vazado) → rotacionar
+- OpenAI key morta → verificar/remover
+
+---
+
+## 🔒 Regras Críticas para Esta Sessão
+
+1. **NÃO git push --force** em main/master
+2. **NÃO git add -A** — usar `git add <arquivo específico>`
+3. **SEMPRE commit TASKS.md** imediatamente após editar
+4. Pre-commit hooks: `.husky/pre-commit` é FROZEN (commit isolado + --no-verify + proof)
+5. Surface-governance gate: deploy scripts exigem bloco de provenance no header
+6. **Watcher obrigatório** — verificar no início e antes de fechar
+
+---
+
+## 🛠️ Capacidades §§ novas (desta sessão de maratona)
+
+- **§104** — `scripts/security/agent-scope-check.ts` — pre-commit agent scope gate
+- **§105** — `scripts/open-access-fetch.ts` — legal OA fetcher (Unpaywall/OpenAlex/arXiv)
+- **gem-hunter.ts** agora usa `resolveOpenAccess()` antes de Sci-Hub (GH-OA-001 ✅)
+
+---
+
+## 📡 Mensagem do Antigravity/Guarani
+
+> Claude Code: estou trabalhando em paralelo nesta mesma sessão. Leia o blackboard 
+> antes de commitar para evitar colisões. O watcher atualiza a cada 15s.
+> 
+> Se você for fazer FE-SYNC-001 (deploy do site), avise pelo commit message:
+> `feat(fe-sync): <descrição> — ANTIGRAVITY: coordinating`
+> 
+> Mesma coisa para qualquer tarefa que modifique: agents/registry/, .husky/, 
+> packages/shared/, ou qualquer arquivo marcado como frozen.
diff --git a/docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md b/docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md
new file mode 100644
index 00000000..31436a91
--- /dev/null
+++ b/docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md
@@ -0,0 +1,46 @@
+# Diff Telemetry + Drift Acceptance — sinal de coordenação multi-agente
+
+> **Status:** SIGNAL/SPEC v1.0 (2026-06-01) · T2 · **isto é o sinal disparado a todos os agentes** (Prime/Guarani/EVA/Codex/?!?/Hermes).
+> **Origem:** Enio 2026-06-01 — "registrar os diffs, a cadência, telemetria completa a cada avanço, da forma mais fluida e barata, garantindo agentes independentes conversando entre si. A construção É o teste. Aceite = drift mínimo, 80/20, depois 99."
+> **Princípio (Resolver §6 + transparência radical):** reusar o que existe (não reinventar), append-only, $0, agentes independentes lendo/escrevendo o mesmo scoreboard.
+
+---
+
+## 1. Reaproveitar (já existe — não construir do zero)
+
+| Peça | Já existe | Papel |
+|------|-----------|-------|
+| `~/.egos/coordination-history.jsonl` | ✅ 305+ eventos | **telemetria** (append-only, $0; LLM free-tier classifica) |
+| `~/.egos/coordination-blackboard.{md,json}` | ✅ watcher rodando | **canal agente↔agente** (estado compartilhado) |
+| `scripts/coordination-watcher.ts` | ✅ daemon | aggregador (1 por filesystem, serve todos) |
+| doc-drift + task-reconciliation | ✅ 2 scripts | **métrica de aceite** (drift) |
+| `.egos-manifest.yaml` claims | ✅ | verificação de claims (proof) |
+
+## 2. A camada fina (o patch a construir — distribuída entre agentes)
+
+1. **Cada avanço (commit/diff) → evento de telemetria** no `coordination-history.jsonl`: `{ts, agent, head, files, +/-, type, cadence_s (desde último), drift_score}`. O watcher já loga no post-commit; estender p/ incluir diff-stats + drift.
+2. **Drift score composto** (o critério de aceite): `doc-drift + task-drift + manifest-claim-mismatch + (futuro) ui-test + rule-set-sync`. Normalizado 0-100. **Aceite: ≥80 (80/20) → depois ≥99.**
+3. **Scoreboard compartilhado:** o drift score atual vai pro blackboard → todos os agentes veem o mesmo número. A construção colaborativa É o teste: cada agente que avança registra seu diff + recalcula o drift.
+
+## 3. Como cada agente participa (independentes, conversando)
+
+- **Prime (Opus):** arquitetura, Red Zone, review, drift score canonical.
+- **Guarani (Antigravity):** executa/entrega staged + escreve seu diff no history.jsonl.
+- **Codex (?!?):** review adversarial dos diffs antes de virar telemetria "aceita".
+- **Hermes (VPS):** roda o recalculo de drift periódico (modelo barato) + posta no blackboard.
+- Regra: cada um lê o blackboard no início, escreve seu avanço no fim. Conflito → `.guarani` prevalece; colisão severa → consolidar (Resolver §6).
+
+## 4. Critério de aceite (o teste)
+
+**Fase 1 — 80/20:** drift score ≥80 sustentado por 7 dias, com cada avanço logado. Prova que a telemetria + coordenação funcionam.
+**Fase 2 — 99:** drift score ≥99 — surfaces (docs/frontend/registry/regras) em sync quase total.
+
+## 5. Tasks (distribuídas)
+- `TELEM-DIFF-001` [P1] — estender watcher post-commit p/ logar diff-stats + cadence no history.jsonl.
+- `TELEM-DRIFT-001` [P1] — drift score composto (script `scripts/drift-score.ts`) normalizado 0-100, escreve no blackboard.
+- `TELEM-SCOREBOARD-001` [P2] — expor drift score no /status (liga FE-SYNC) + blackboard.
+- `TELEM-AGENTS-001` [P2] — protocolo: cada agente lê blackboard no start, loga diff no end (wire em /start /end + start-guarani).
+
+---
+
+*SINAL DISPARADO 2026-06-01. Agentes: leiam isto, ajudem a construir a camada §2 nas suas janelas, registrem seus diffs. Aceite = drift ≥80 → 99. SSOT: este doc. Reusa coordination-watcher + history.jsonl + drift detectors.*
diff --git a/docs/governance/RESOLVER_DOCTRINE.md b/docs/governance/RESOLVER_DOCTRINE.md
index 45ff0858..007e79e2 100644
--- a/docs/governance/RESOLVER_DOCTRINE.md
+++ b/docs/governance/RESOLVER_DOCTRINE.md
@@ -87,4 +87,28 @@ Toda vez que o Enio entra com uma **decisão humana** (corte de Red Zone, escolh
 
 ---
 
+## §6 — Fronteiras de decisão: onde o Prime entra (sem medo) vs onde para
+
+> **Corte do Enio 2026-06-01:** "vá percebendo onde você entra, onde não entra, para saber onde agir sem medo." **Saber a fronteira REMOVE o medo.** O medo vem de não saber o limite. Dentro da zona: aja decidido, assuma total, não recue. Fora da zona: pare limpo — parar é a ação CERTA ali, não covardia.
+
+### ✅ ENTRO (resolvo agora, sem medo, assumo total)
+- **Meu domínio:** orquestração, governança, a task em mãos, docs/regras do EGOS.
+- **Bug que para na minha porta**, com causa-raiz e barato (Resolver `R≥3`, effort≤2, ctx-switch≤2).
+- **Segurança/perda-de-dado/secret** → sempre, ignora score.
+- **Validar claim de subagente** (INC-006) — verifico por path/evidência, corrijo, nunca confio cego. (Ex: subagente disse `egos-inteligencia` ungoverned; validei → era falso.)
+- **Erro de subagente** = falha de orquestração minha → assumo e resolvo a causa, não culpo (§1).
+
+### 🛑 NÃO ENTRO (paro/devolvo — sem medo de "não estar fazendo")
+- **Código em-andamento de OUTRA janela** — não edito/conserto WIP alheio incompleto (ex: `mcp-literature` com tsc quebrado de outra window). Sinalizo, devolvo, não toco.
+- **Red Zone** (copy pública, pricing, legal, contexto policial, irreversível/on-chain, corte de arquitetura) → apresento opções, espero o corte do Enio. Nunca auto-resolvo.
+- **Gates T0/T1** (tsc, frozen zones, force-push) → não bypasso por capricho. Override só com justificativa documentada E quando o erro é claramente foreign/não-meu E minha mudança é segura.
+- **Colisão paralela severa** (N janelas commitando, gate travando em código alheio) → PARO e consolido. É falha de orquestração, não "empurrar mais forte". Reconhecer isto É a ação correta.
+- **Prod/deploy com risco** (ex: release egos-site, 502) → sessão dedicada + prova visual §10, não improviso no fim de maratona.
+
+### A regra-mãe da fronteira
+Se está no meu domínio e é seguro → **entro com convicção total** (sou a última camada). Se é Red Zone, foreign-WIP, gate de segurança, ou colisão → **paro com a mesma convicção** (parar é resolver). Os dois são decisão firme. Nenhum é medo.
+
+---
+
+*v1.1 2026-06-01 — +§6 Fronteiras de decisão (Enio: "agir sem medo" = saber a fronteira).*
 *v1.0 2026-06-01 — Enio posture correction. Anchored: FOCUS_GATES.md, MODEL_DELEGATION_POLICY.md, SWARM_COMMIT_POLICY.md, regra-mae-egos (filtro "converte potencial mensurável?").*
diff --git a/docs/governance/RULE_SETS_INDEX.md b/docs/governance/RULE_SETS_INDEX.md
new file mode 100644
index 00000000..9778edb6
--- /dev/null
+++ b/docs/governance/RULE_SETS_INDEX.md
@@ -0,0 +1,54 @@
+# RULE_SETS_INDEX — todos os conjuntos de regras do ecossistema EGOS
+
+> **Status:** CANONICAL v1.0 (2026-06-01) · T2 · gerado por RULE-DISCOVERY-001 (sweep cross-repo).
+> **Propósito:** o EGOS conhecer TODAS as suas regras, onde vivem e qual a precedência — kernel + leaf repos. Alimenta `/start` (consciência de regras) + herança Layer 0 + protocolo de intake.
+> **Manutenção:** re-rodar o sweep (RULE-DISCOVERY) quando criar repo novo ou mudar regra estrutural. Verificável por path.
+
+---
+
+## Hierarquia canônica (precedência — mais alto vence)
+
+1. **`egos/AGENTS.md`** (v2.0.0) — **CANÔNICO**. SSOT de regras de agente cross-IDE (Claude/Windsurf/Cursor/Codex leem). Supersede `.windsurfrules` e `CLAUDE.md` em conflito.
+2. **`egos/.guarani/RULES_INDEX.md`** (v1.2.1) — **mapa de descoberta**. Ponto de entrada; lista todos os arquivos de regra + tier.
+3. **`~/.claude/CLAUDE.md`** (v5.3.0) — config global T0-T4 (lido a cada sessão). `T0>T1>T2>T3>T4`.
+4. **`egos/docs/governance/LAYER_0_SSOT.md`** (T1) — regras universais que todos os templates de domínio herdam.
+5. **`~/.egos/guarani/`** — mirror persistente + symlinks (fallback se kernel inacessível).
+6. **`egos/docs/governance/*`** (134 arquivos) — SSOTs de domínio (MCP/capability/agent/doc/audit/ops).
+
+Fallback de leitura: `AGENTS.md → .guarani/RULES_INDEX.md → ~/.claude/CLAUDE.md → ~/.egos/guarani/RULES_INDEX.md`.
+**Regra de conflito:** `.guarani` prevalece (CLAUDE.md kernel §Arquitetura).
+
+## Inventário por repo
+
+| Repo | Regras-chave | Tipo | Status |
+|------|-------------|------|--------|
+| **egos** (kernel) | AGENTS.md (canônico), CLAUDE.md, .guarani/* (GUARANI, RULES_INDEX, AUTONOMY/SEPARATION/DESIGN/PREFERENCES/preprocessor/ENGINEERING), docs/governance/* (134), LAYER_0_SSOT, .windsurfrules | constitution+governance | ✅ canônico |
+| **intelink** | CLAUDE.md, AGENTS.md, .windsurfrules, docs/governance/* (11) | adapter propagado | ✅ sync e9831cf5 (2026-06-01) |
+| **egos-lab** | CLAUDE.md, AGENTS.md, .windsurfrules, .cursorrules, .guarani/* (symlinks→~/.egos/guarani) | adapter+inherit | ✅ sync e9831cf5 |
+| **852** | CLAUDE.md, AGENTS.md, .windsurfrules, .guarani/* (symlinks + SACRED_CODE local) | adapter+inherit | ✅ sync e9831cf5 |
+| **blueprint-egos** | AGENTS.md, .windsurfrules, .guarani/meta-prompts/ | adapter | ⚠️ **STALE 45d** (sync a6d1ad7 2026-04-17) |
+| **gem-hunter** | — | — | 🔴 **UNGOVERNED** (sem CLAUDE.md/AGENTS.md — verificado 2026-06-01) |
+| **egos-inteligencia** | CLAUDE.md, AGENTS.md | adapter | ✅ governado (subagente errou "ungoverned"; validação por path corrigiu — INC-006) |
+| **~/.claude** | CLAUDE.md (T0-T4 global), egos-rules/* (18, lazy T3-T4) | global config | ✅ |
+| **~/.egos** | guarani/* (26, mirror+backup), guarani/RULES_INDEX.md (symlink) | mirror/fallback | ✅ |
+| **Obsidian Vault/EGOS** | CLAUDE.md (v2.0.0) | knowledge vault | ✅ (2026-04-11) |
+
+## Mecanismos de propagação
+
+- **Dissemination (kernel→leaf):** `scripts/disseminate-propagator.ts` injeta bloco `<!-- PROPAGATE-RULES-BEGIN/END -->` (read-only) em CLAUDE.md/AGENTS.md/.windsurfrules/.cursorrules dos leaf, com hash do commit kernel. Pre-commit `pre-commit-governance-boundary.sh` impede edição local de regras propagadas.
+- **Inheritance (mirror):** leaf `.guarani/*` = symlinks → `~/.egos/guarani/` (egos-lab, 852).
+- **Sync:** `governance-sync.sh`, `auto-disseminate.sh`, `sync-all-leaf-repos.sh`.
+
+## Tiers (T0-T4)
+
+T0 CRÍTICO (dano irreversível, absoluto) · T1 SAFETY (integridade, write-protected nos leaf) · T2 OPS (editável c/ aprovação) · T3 GUIDANCE (aspiracional, lazy) · T4 ARCHIVE (histórico, read-only). Fail-closed: se `~/.claude/egos-rules/` ausente → avisar antes de trabalho não-trivial.
+
+## Achados → tasks (RULE-DISCOVERY-001)
+
+- 🔴 **gem-hunter ungoverned** (egos-inteligencia É governado — subagente errou, validação corrigiu) → `RULE-GOV-GAP-001`.
+- ⚠️ **blueprint-egos 45d stale** → `RULE-SYNC-001` (re-rodar disseminate-propagator).
+- ✅ Zero conflito; propagação limpa. Lição: claims de subagente = unverified (INC-006) — validei por path.
+
+---
+
+*SSOT da descoberta de regras. Origem: RULE-DISCOVERY-001 (sweep Explore 2026-06-01). Detalhe completo no transcript da task.*
diff --git a/docs/jobs/2026-06-01-doc-drift-verifier.json b/docs/jobs/2026-06-01-doc-drift-verifier.json
index 613b10b4..c875f9ad 100644
--- a/docs/jobs/2026-06-01-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-01-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-01T14:34:20.909Z",
+  "verified_at": "2026-06-01T16:47:25.231Z",
   "summary": {
     "total_claims": 15,
     "passed": 14,
@@ -61,9 +61,9 @@
       "description": "Packages in packages/ directory",
       "status": "ok",
       "last_value": "33",
-      "current_value": "33",
+      "current_value": "34",
       "tolerance": "±2",
-      "drift_abs": 0,
+      "drift_abs": 1,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -72,7 +72,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1171",
+      "current_value": "1179",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-01-pre-commit-pipeline.json b/docs/jobs/2026-06-01-pre-commit-pipeline.json
index 19eec6a7..262fffaf 100644
--- a/docs/jobs/2026-06-01-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -206,5 +206,13 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=bdafb778",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T16:49:05.052Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=52a2bf74",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/packages/mcp-literature/package.json b/packages/mcp-literature/package.json
new file mode 100644
index 00000000..8790dced
--- /dev/null
+++ b/packages/mcp-literature/package.json
@@ -0,0 +1,19 @@
+{
+  "name": "@egos/mcp-literature",
+  "version": "1.0.0",
+  "description": "MCP server for legal open-access literature resolution (Unpaywall/OpenAlex/arXiv)",
+  "main": "src/index.ts",
+  "bin": {
+    "mcp-literature": "src/index.ts"
+  },
+  "scripts": {
+    "start": "bun src/index.ts",
+    "dev": "bun --watch src/index.ts"
+  },
+  "dependencies": {
+    "@modelcontextprotocol/sdk": "^1.29.0",
+    "zod": "^3.23.0"
+  },
+  "keywords": ["mcp", "literature", "open-access", "research", "oa", "unpaywall", "openalex"],
+  "license": "MIT"
+}
diff --git a/packages/mcp-literature/src/index.ts b/packages/mcp-literature/src/index.ts
new file mode 100644
index 00000000..19b9e8cd
--- /dev/null
+++ b/packages/mcp-literature/src/index.ts
@@ -0,0 +1,227 @@
+#!/usr/bin/env bun
+/**
+ * @egos/mcp-literature v1.0.0 (OA-API-001)
+ *
+ * MCP server for legal open-access literature resolution.
+ * Wraps Unpaywall -> OpenAlex -> arXiv -> Crossref pipeline.
+ *
+ * Tools (3):
+ *   - resolve_paper    — resolve DOI/arXiv/title to OA PDF + metadata
+ *   - batch_resolve    — resolve up to 10 papers at once
+ *   - search_papers    — search OpenAlex by keywords/topic
+ *
+ * SSOT: docs/governance/OPEN_ACCESS_SOURCING_RULE.md
+ * Capability: §105 docs/CAPABILITY_REGISTRY.md
+ * REST mirror: /api/hq/literature
+ */
+
+import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
+import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
+import { z } from 'zod';
+
+const EMAIL = process.env.EGOS_CONTACT_EMAIL ?? 'research@egos.ia.br';
+const UA = `EGOS-mcp-literature/1.0 (mailto:${EMAIL})`;
+
+async function jfetch(url: string): Promise<unknown> {
+  try {
+    const r = await fetch(url, {
+      headers: { 'User-Agent': UA, Accept: 'application/json' },
+      signal: AbortSignal.timeout(12000),
+    });
+    if (!r.ok) return null;
+    return await r.json();
+  } catch { return null; }
+}
+
+const isDoi = (s: string) =>
+  /^10\.\d{4,9}\/\S+$/.test(s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, ''));
+const normDoi = (s: string) =>
+  s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, '');
+const isArxiv = (s: string) =>
+  /^(arxiv:)?\d{4}\.\d{4,5}(v\d+)?$/i.test(s.trim());
+
+async function resolveOne(query: string): Promise<Record<string, unknown>> {
+  const q = query.trim();
+
+  if (isArxiv(q)) {
+    const aid = q.replace(/^arxiv:/i, '');
+    try {
+      const r = await fetch(
+        `http://export.arxiv.org/api/query?id_list=${encodeURIComponent(aid)}`,
+        { headers: { 'User-Agent': UA }, signal: AbortSignal.timeout(12000) }
+      );
+      if (r.ok) {
+        const xml = await r.text();
+        const titles = xml.match(/<title>([\s\S]*?)<\/title>/g);
+        const title = titles?.[1]?.replace(/<\/?title>/g, '').trim();
+        if (title) {
+          return {
+            found: true, query: q, title, isOA: true,
+            pdfUrl: `https://arxiv.org/pdf/${aid}`,
+            landingUrl: `https://arxiv.org/abs/${aid}`,
+            license: 'arXiv', source: 'arxiv', note: 'preprint',
+          };
+        }
+      }
+    } catch {}
+  }
+
+  if (isDoi(q)) {
+    const doi = normDoi(q);
+    // Try Unpaywall
+    const u = await jfetch(
+      `https://api.unpaywall.org/v2/${encodeURIComponent(doi)}?email=${encodeURIComponent(EMAIL)}`
+    ) as Record<string, unknown> | null;
+    if (u) {
+      const loc = u.best_oa_location as Record<string, unknown> | null;
+      const result = {
+        found: true, query: q, doi,
+        title: u.title, year: u.year, isOA: !!u.is_oa,
+        pdfUrl: loc?.url_for_pdf ?? undefined,
+        landingUrl: loc?.url_for_landing_page ?? loc?.url ?? undefined,
+        license: loc?.license ?? undefined,
+        source: 'unpaywall',
+        note: u.is_oa ? `OA via ${(loc?.host_type as string) ?? '?'}` : 'No legal OA version found.',
+      };
+      if (result.pdfUrl || result.landingUrl) return result;
+    }
+    // Try OpenAlex
+    const o = await jfetch(
+      `https://api.openalex.org/works/doi:${encodeURIComponent(doi)}?mailto=${encodeURIComponent(EMAIL)}`
+    ) as Record<string, unknown> | null;
+    if (o?.id) {
+      const oa = o.open_access as Record<string, unknown> | null;
+      const loc = o.best_oa_location as Record<string, unknown> | null;
+      return {
+        found: true, query: q, doi,
+        title: o.title, year: o.publication_year, isOA: !!oa?.is_oa,
+        pdfUrl: loc?.pdf_url ?? oa?.oa_url ?? undefined,
+        landingUrl: loc?.landing_page_url ?? oa?.oa_url ?? undefined,
+        license: loc?.license ?? undefined,
+        source: 'openalex',
+        note: oa?.is_oa ? `OA: ${oa?.oa_status}` : 'Closed.',
+      };
+    }
+    return { found: false, query: q, source: 'none', note: 'No OA version found for this DOI.' };
+  }
+
+  // Title/keyword search
+  const d = await jfetch(
+    `https://api.openalex.org/works?search=${encodeURIComponent(q)}&per_page=1&mailto=${encodeURIComponent(EMAIL)}`
+  ) as Record<string, unknown> | null;
+  const results = d?.results as Record<string, unknown>[] ?? [];
+  if (results.length > 0) {
+    const w = results[0];
+    const oa = w.open_access as Record<string, unknown> | null;
+    const loc = w.best_oa_location as Record<string, unknown> | null;
+    return {
+      found: true, query: q,
+      doi: (w.doi as string)?.replace('https://doi.org/', ''),
+      title: w.title, year: w.publication_year, isOA: !!oa?.is_oa,
+      pdfUrl: loc?.pdf_url ?? oa?.oa_url ?? undefined,
+      landingUrl: loc?.landing_page_url ?? oa?.oa_url ?? undefined,
+      license: loc?.license ?? undefined,
+      source: 'openalex',
+      note: `matched "${w.title as string}"`,
+    };
+  }
+  return { found: false, query: q, source: 'none', note: 'No match found.' };
+}
+
+async function searchPapers(query: string, limit: number): Promise<Record<string, unknown>[]> {
+  const d = await jfetch(
+    `https://api.openalex.org/works?search=${encodeURIComponent(query)}&per_page=${limit}&mailto=${encodeURIComponent(EMAIL)}`
+  ) as Record<string, unknown> | null;
+  const results = d?.results as Record<string, unknown>[] ?? [];
+  return results.map((w) => {
+    const oa = w.open_access as Record<string, unknown> | null;
+    const loc = w.best_oa_location as Record<string, unknown> | null;
+    return {
+      found: true, query,
+      doi: (w.doi as string)?.replace('https://doi.org/', ''),
+      title: w.title, year: w.publication_year, isOA: !!oa?.is_oa,
+      pdfUrl: loc?.pdf_url ?? oa?.oa_url ?? undefined,
+      landingUrl: loc?.landing_page_url ?? oa?.oa_url ?? undefined,
+      license: loc?.license ?? undefined,
+      source: 'openalex',
+    };
+  });
+}
+
+// ── MCP Server ────────────────────────────────────────────────────────────────
+const server = new McpServer(
+  { name: 'egos-literature', version: '1.0.0' },
+  { capabilities: { tools: {} } }
+);
+
+server.tool(
+  'resolve_paper',
+  'Resolve a DOI, arXiv ID, or paper title to a legal open-access PDF. Uses Unpaywall -> OpenAlex -> arXiv chain.',
+  { query: z.string().describe('DOI (e.g. 10.1038/nature01244), arXiv ID (e.g. 1706.03762), or paper title') },
+  async ({ query }) => {
+    const result = await resolveOne(query);
+    const found = !!result.found;
+    const text = found
+      ? `${result.title ?? result.query}\nsource: ${result.source} | OA: ${result.isOA} | year: ${result.year ?? '?'} | license: ${result.license ?? '?'}\n${result.pdfUrl ? 'PDF: ' + result.pdfUrl + '\n' : ''}${result.landingUrl ? 'landing: ' + result.landingUrl + '\n' : ''}${result.note ?? ''}`
+      : `Not found: ${result.query}\n${result.note}`;
+    return {
+      content: [
+        { type: 'text' as const, text },
+        { type: 'text' as const, text: JSON.stringify(result, null, 2) },
+      ],
+      isError: !found,
+    };
+  }
+);
+
+server.tool(
+  'batch_resolve',
+  'Resolve up to 10 papers at once. Each item can be a DOI, arXiv ID, or title.',
+  { queries: z.array(z.string()).min(1).max(10).describe('List of DOIs, arXiv IDs, or titles (max 10)') },
+  async ({ queries }) => {
+    const results = await Promise.all(queries.map(resolveOne));
+    const oaCount = results.filter((r) => r.isOA).length;
+    const foundCount = results.filter((r) => r.found).length;
+    const summary = `Resolved ${foundCount}/${queries.length} papers. ${oaCount} have open-access PDFs.\n\n` +
+      results.map((r, i) =>
+        `${i + 1}. ${r.found ? 'FOUND' : 'NOT FOUND'} | ${r.title ?? r.query} | ${r.source} | OA: ${r.isOA ?? '?'}` +
+        (r.pdfUrl ? ' | PDF: ' + r.pdfUrl : '')
+      ).join('\n');
+    return {
+      content: [
+        { type: 'text' as const, text: summary },
+        { type: 'text' as const, text: JSON.stringify({ count: results.length, found_count: foundCount, oa_count: oaCount, results }, null, 2) },
+      ],
+    };
+  }
+);
+
+server.tool(
+  'search_papers',
+  'Search OpenAlex for papers by keywords, author, or topic. Returns top N results with OA status.',
+  {
+    query: z.string().describe('Search query (keywords, topic, or author name)'),
+    limit: z.number().int().min(1).max(20).default(5).describe('Number of results (default: 5, max: 20)'),
+  },
+  async ({ query, limit }) => {
+    const results = await searchPapers(query, limit);
+    if (results.length === 0) {
+      return { content: [{ type: 'text' as const, text: `No papers found for: "${query}"` }] };
+    }
+    const oaCount = results.filter((r) => r.isOA).length;
+    const summary = `Found ${results.length} papers for "${query}" (${oaCount} open-access):\n\n` +
+      results.map((r, i) =>
+        `${i + 1}. ${r.title ?? '(no title)'} (${r.year ?? '?'})\n   doi: ${r.doi ?? 'N/A'} | OA: ${r.isOA ? 'YES' : 'NO'}` +
+        (r.pdfUrl ? ' | PDF: ' + r.pdfUrl : r.landingUrl ? ' | landing: ' + r.landingUrl : '')
+      ).join('\n\n');
+    return {
+      content: [
+        { type: 'text' as const, text: summary },
+        { type: 'text' as const, text: JSON.stringify(results, null, 2) },
+      ],
+    };
+  }
+);
+
+const transport = new StdioServerTransport();
+await server.connect(transport);
diff --git a/packages/mcp-literature/tsconfig.json b/packages/mcp-literature/tsconfig.json
new file mode 100644
index 00000000..52d43eaa
--- /dev/null
+++ b/packages/mcp-literature/tsconfig.json
@@ -0,0 +1,4 @@
+{
+  "extends": "../../tsconfig.json",
+  "include": ["src/**/*"]
+}
diff --git a/scripts/mcp-ecosystem.config.js b/scripts/mcp-ecosystem.config.js
index 9d965e33..49778e5c 100644
--- a/scripts/mcp-ecosystem.config.js
+++ b/scripts/mcp-ecosystem.config.js
@@ -4,7 +4,7 @@
  * Deploy: pm2 start scripts/mcp-ecosystem.config.js
  * Requires: MCP_CMD per app + EGOS_MCP_TOKEN em /opt/egos-mcp/.env
  *
- * Portas: 7001-7009 (governance → observability)
+ * Portas: 7001-7010 (governance → literature)
  * Caddy: reverse proxy em mcp.egos.ia.br/{name}
  * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md §7 (Streamable HTTP)
  */
@@ -129,5 +129,11 @@ module.exports = {
       `${BUN_BIN} run ${MCP_DIR}/observability/src/index.ts`,
       PROTECT // machine/infra: SSH, PM2, topology
     ),
+    bridgeBase(
+      "literature",
+      7010,
+      `${BUN_BIN} run ${MCP_DIR}/literature/src/index.ts`,
+      FREE // public OA APIs only — Unpaywall/OpenAlex/arXiv
+    ),
   ],
 };
diff --git a/tsconfig.json b/tsconfig.json
index 51b1893e..0de2525f 100644
--- a/tsconfig.json
+++ b/tsconfig.json
@@ -53,6 +53,7 @@
     "packages/mcp-ops",
     "packages/mcp-security",
     "packages/mcp-skills-registry",
+    "packages/mcp-literature",
     "packages/knowledge-mcp",
     "packages/guard-brasil-langchain",
     "packages/guard-brasil-python",

exec
/bin/bash -lc "sed -n '1,220p' scripts/mcp-ecosystem.config.js" in /home/enio/egos
 succeeded in 0ms:
/**
 * PM2 Ecosystem — EGOS MCP Servers (MCP-F3-003)
 *
 * Deploy: pm2 start scripts/mcp-ecosystem.config.js
 * Requires: MCP_CMD per app + EGOS_MCP_TOKEN em /opt/egos-mcp/.env
 *
 * Portas: 7001-7010 (governance → literature)
 * Caddy: reverse proxy em mcp.egos.ia.br/{name}
 * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md §7 (Streamable HTTP)
 */

const MCP_DIR = "/opt/egos-mcp";
const BUN_BIN = "/usr/bin/bun";
const ENV_FILE = `${MCP_DIR}/.env`;

// Read the bearer token from .env at config-eval time — pm2 env_file was NOT
// reliably injecting it (RED bridges stayed no-auth). Inject explicitly instead.
let MCP_TOKEN = "";
try {
  const m = require("fs").readFileSync(ENV_FILE, "utf8").match(/^EGOS_MCP_TOKEN=(.+)$/m);
  if (m) MCP_TOKEN = m[1].trim();
} catch (_) { /* no .env → bridges stay open (dev) */ }
// Bridges that expose the MACHINE/infra or data-restricted-by-nature → require token.
// (Framework content stays free: eval-runner, skills-registry, governance.)
const PROTECT = { EGOS_MCP_TOKEN: MCP_TOKEN };
const FREE = { EGOS_MCP_TOKEN: "" };

// Configuração base de cada MCP
const mcpBase = (name, port, cmd) => ({
  name: `egos-mcp-${name}`,
  script: `${BUN_BIN}`,
  args: ["run", "src/index.ts"],
  cwd: `${MCP_DIR}/${name}`,
  env_file: ENV_FILE,
  env: {
    MCP_NAME: name,
    MCP_PORT: String(port),
    MCP_HOST: "0.0.0.0",
    NODE_ENV: "production",
  },
  // Restart policy
  restart_delay: 2000,
  max_restarts: 10,
  min_uptime: "5s",
  // Memory limit
  max_memory_restart: "256M",
  // Logging
  out_file: `/var/log/egos-mcp-${name}.log`,
  error_file: `/var/log/egos-mcp-${name}.error.log`,
  log_date_format: "YYYY-MM-DD HH:mm:ss",
  // Kill switch via env
  kill_timeout: 3000,
  // Watch mode OFF (use deploy-mcp.sh for updates)
  watch: false,
});

// Bridge mode — cada MCP exposto via mcp-bridge
const bridgeBase = (name, port, mcpCmd, extraEnv = {}) => ({
  ...mcpBase(`bridge-${name}`, port, null),
  name: `egos-mcp-${name}`,
  script: `${BUN_BIN}`,
  args: ["run", `${MCP_DIR}/bridge/src/index.ts`],
  cwd: `${MCP_DIR}/bridge`,
  env: {
    MCP_NAME: name,
    MCP_PORT: String(port),
    MCP_HOST: "0.0.0.0",
    MCP_CMD: mcpCmd,
    NODE_ENV: "production",
    EGOS_TENANT_ID: "kernel",
    ...extraEnv,
  },
});

module.exports = {
  apps: [
    // Usando bridge para Streamable HTTP (MCP spec 2025-03-26)
    bridgeBase(
      "governance",
      7001,
      `${BUN_BIN} run ${MCP_DIR}/governance/src/index.ts`,
      FREE // framework content (radical transparency)
    ),
    bridgeBase(
      "memory",
      7002,
      `${BUN_BIN} run ${MCP_DIR}/memory/src/index.ts`,
      PROTECT // personal/PCMG — data restricted by nature
    ),
    bridgeBase(
      "knowledge",
      7003,
      `${BUN_BIN} run ${MCP_DIR}/knowledge/src/index.ts`,
      PROTECT // intelink/client/PII — scope later, protect now
    ),
    bridgeBase(
      "security",
      7004,
      `${BUN_BIN} run ${MCP_DIR}/security/src/index.ts`,
      PROTECT // PII scan results
    ),
    bridgeBase(
      "eval-runner",
      7005,
      `${BUN_BIN} run ${MCP_DIR}/eval-runner/src/index.ts`,
      { ...FREE, EGOS_REPO_ROOT: "/opt/egos-data" } // FREE + data path (persist fix)
    ),
    bridgeBase(
      "ops",
      7006,
      `${BUN_BIN} run ${MCP_DIR}/ops/src/index.ts`,
      PROTECT // machine/infra: LLM routing, quota
    ),
    bridgeBase(
      "skills-registry",
      7007,
      `${BUN_BIN} run ${MCP_DIR}/skills-registry/src/index.ts`,
      FREE // framework content
    ),
    bridgeBase(
      "browser-automation",
      7008,
      `${BUN_BIN} run ${MCP_DIR}/browser-automation/src/index.ts`,
      PROTECT // machine: headless browser, SSRF vector
    ),
    bridgeBase(
      "observability",
      7009,
      `${BUN_BIN} run ${MCP_DIR}/observability/src/index.ts`,
      PROTECT // machine/infra: SSH, PM2, topology
    ),
    bridgeBase(
      "literature",
      7010,
      `${BUN_BIN} run ${MCP_DIR}/literature/src/index.ts`,
      FREE // public OA APIs only — Unpaywall/OpenAlex/arXiv
    ),
  ],
};

exec
/bin/bash -lc 'cat package.json' in /home/enio/egos
 succeeded in 0ms:
{
  "name": "egos",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "EGOS — Orchestration kernel for governed AI agents",
  "license": "MIT",
  "author": "Enio Rocha <enio@egos.ia.br>",
  "bin": {
    "egos": "./bin/egos.ts"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git"
  },
  "workspaces": [
    "packages/*",
    "apps/*",
    "central-egos/*"
  ],
  "scripts": {
    "setup": "sh setup.sh",
    "egos:init": "sh scripts/egos-init.sh",
    "agent:list": "bun agents/cli.ts list",
    "agent:run": "bun agents/cli.ts run",
    "agent:lint": "bun agents/cli.ts lint-registry",
    "coordination:watch": "bun run scripts/coordination-watcher.ts",
    "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
    "lint": "eslint .",
    "prepare": "husky",
    "precommit": "bash .husky/pre-commit",
    "governance:sync": "sh scripts/governance-sync.sh --dry",
    "governance:sync:exec": "sh scripts/governance-sync.sh --exec --propagate",
    "governance:sync:local": "sh scripts/governance-sync.sh --exec --no-propagate",
    "governance:check": "sh scripts/governance-sync.sh --check",
    "template:check": "bun scripts/validate-inherits.ts && bun scripts/lint-domain-template.ts",
    "template:check:strict": "bun scripts/validate-inherits.ts --strict && bun scripts/lint-domain-template.ts --strict",
    "governance:runtime:smoke": "bun scripts/runtime-smoke.ts",
    "governance:runtime:smoke:json": "bun scripts/runtime-smoke.ts --json",
    "governance:runtime:report": "bun scripts/runtime-operator-report.ts",
    "governance:runtime:report:json": "bun scripts/runtime-operator-report.ts --json",
    "gov:check": "bun run scripts/runtime-smoke-validator.ts",
    "gov:telemetry": "bun run scripts/hook-telemetry-report.ts --week",
    "gov:telemetry:daily": "bun run scripts/hook-telemetry-report.ts --day",
    "gov:evidence-gate:dry": "bun run scripts/evidence-gate-disseminate.ts --dry-run",
    "gov:sync:dry": "bun run ~/.eos/scripts/core/governance-sync.sh --dry-run",
    "gov:sync": "bun run ~/.eos/scripts/core/governance-sync.sh --exec",
    "tasks:archive": "bun scripts/tasks-archive.ts --dry",
    "tasks:archive:exec": "bun scripts/tasks-archive.ts --exec",
    "tasks:reconcile": "bun scripts/task-reconciliation.ts --summary",
    "tasks:calibrate": "bun scripts/calibrate-tasks.ts",
    "tasks:audit": "bun scripts/hermes-task-audit.ts --dry",
    "tasks:audit:write": "bun scripts/hermes-task-audit.ts",
    "claude:telemetry": "bun scripts/claude-hook-telemetry.ts",
    "claude:telemetry:json": "bun scripts/claude-hook-telemetry.ts --json",
    "claude:telemetry:otel": "bun scripts/claude-hook-telemetry.ts --otel",
    "claude:telemetry:otel:json": "bun scripts/claude-hook-telemetry.ts --otel --json",
    "egos:boot": "bash scripts/egos-boot.sh",
    "ssot:check": "bun scripts/validate-ssot.ts",
    "ssot:claim-check": "bun scripts/ssot-claim-check.ts",
    "ssot:diagnostic": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --output /tmp/qa-ssot-check.md",
    "ssot:diagnostic:json": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --format json --output /tmp/qa-ssot-check.json",
    "smoke:api": "bun scripts/smoke-test-api.ts",
    "version:lock": "bun scripts/check-version-lock.ts",
    "integration:check": "bun scripts/integration-release-check.ts",
    "pr:pack": "bun scripts/pr-pack.ts",
    "pr:gate": "bun scripts/pr-gate.ts",
    "pr:audit": "bun scripts/pr-ecosystem-audit.ts",
    "ssot:link": "sh scripts/link-ssot-files.sh --dry",
    "ssot:link:exec": "sh scripts/link-ssot-files.sh --exec",
    "qa:observability": "bash scripts/qa/run_observability_suite.sh",
    "qa:pending": "python scripts/qa/list_pending_tasks.py --input TASKS.md",
    "qa:pending:json": "python scripts/qa/list_pending_tasks.py --input TASKS.md --format json",
    "qa:stalled": "python scripts/qa/stalled_tasks_report.py --input TASKS.md",
    "qa:evidence": "python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt",
    "qa:evidence:gate": "python scripts/qa/telemetry_guardrail.py --input tests/qa/fixtures/sample_telemetry.txt --output /tmp/qa-guardrail.txt && python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt --enforce",
    "qa:compose": "python scripts/qa/compose_qa_envelope.py --guardrail /tmp/qa-guardrail.txt --ssot /tmp/qa-ssot-check.md --evidence /tmp/qa-evidence.md --output /tmp/qa-envelope.json",
    "security:audit": "bun scripts/security-audit.ts",
    "security:audit:json": "bun scripts/security-audit.ts --json",
    "security:audit:fix": "bun scripts/security-audit.ts --fix",
    "test": "bun test packages/shared/src/__tests__/",
    "test:hooks": "bun test tests/hooks/",
    "test:watch": "bun test --watch",
    "test:governance": "bun scripts/test-governance.ts",
    "capability:scan": "bun scripts/update-capability-registry.ts",
    "capability:scan:repo": "bun scripts/update-capability-registry.ts --repo",
    "duplication:scan": "bun scripts/governance/duplication-scanner.ts",
    "duplication:scan:json": "bun scripts/governance/duplication-scanner.ts --json",
    "ssot:crosslink": "bun scripts/governance/ssot-crosslink-validator.ts",
    "ssot:crosslink:staged": "bun scripts/governance/ssot-crosslink-validator.ts --staged",
    "activation:check": "bun scripts/activation-check.ts",
    "start": "bun scripts/start-v6.ts",
    "start:full": "bun scripts/start-v6.ts --full",
    "start:json": "bun scripts/start-v6.ts --json",
    "doctor": "bun scripts/doctor.ts",
    "doctor:codex": "sh scripts/codex-doctor.sh",
    "doctor:fix": "bun scripts/doctor.ts --fix",
    "personal:sync:status": "bun scripts/personal-sync-status.ts",
    "personal:sync:status:json": "bun scripts/personal-sync-status.ts --json",
    "phantom:tables:audit": "bun scripts/phantom-table-audit.ts",
    "phantom:tables:audit:json": "bun scripts/phantom-table-audit.ts --json",
    "chatgpt:ingest": "bun scripts/chatgpt-export-sync.ts --dry",
    "chatgpt:ingest:exec": "bun scripts/chatgpt-export-sync.ts --exec",
    "chatgpt:watch": "bun scripts/chatgpt-export-watch.ts --dry",
    "chatgpt:watch:exec": "bun scripts/chatgpt-export-watch.ts --exec",
    "wiki:repos-sync": "bun scripts/wiki-repos-sync.ts",
    "wiki:repos-sync:check": "bun scripts/wiki-repos-sync.ts --check",
    "wiki:compile": "bun agents/agents/wiki-compiler.ts --compile",
    "wiki:compile:dry": "bun agents/agents/wiki-compiler.ts --compile --dry",
    "wiki:heal": "bun agents/agents/wiki-compiler.ts --heal",
    "wiki:heal:dry": "bun agents/agents/wiki-compiler.ts --heal --dry",
    "wiki:lint": "bun agents/agents/wiki-compiler.ts --lint",
    "wiki:index": "bun agents/agents/wiki-compiler.ts --index",
    "wiki:dedup": "bun agents/agents/wiki-compiler.ts --dedup",
    "wiki:dedup:dry": "bun agents/agents/wiki-compiler.ts --dedup --dry",
    "wiki:enrich": "bun agents/agents/wiki-compiler.ts --enrich",
    "wiki:enrich:dry": "bun agents/agents/wiki-compiler.ts --enrich --dry",
    "deadcode": "knip",
    "deadcode:fix": "knip --fix",
    "skill:usage": "bun scripts/skill-usage-tracker.ts",
    "skill:usage:log": "bun scripts/skill-usage-tracker.ts --log",
    "skill:usage:30d": "bun scripts/skill-usage-tracker.ts --days=30",
    "gemhunter:dry": "bun agents/cli.ts run gem-hunter --dry",
    "gemhunter:exec": "bun agents/cli.ts run gem-hunter --exec",
    "gemhunter:quick": "bun agents/cli.ts run gem-hunter --exec --quick",
    "gemhunter:api": "bun agents/api/gem-hunter-server.ts"
  },
  "devDependencies": {
    "@anthropic-ai/sdk": "^0.100.0",
    "@types/bun": "^1.3.13",
    "@types/node": "^25.6.0",
    "eslint": "^10.2.1",
    "husky": "^9.1.7",
    "knip": "^6.9.0",
    "typescript": "^6.0.3"
  },
  "dependencies": {
    "@google/generative-ai": "^0.24.1",
    "@supabase/supabase-js": "^2.105.1",
    "ajv": "8.20.0",
    "axios": "^1.15.2",
    "cross-spawn": "7.0.6",
    "dotenv": "^17.4.2",
    "hono": "^4.12.16",
    "mammoth": "^1.12.0",
    "semver": "~7.7.4",
    "substack-api": "^4.0.0",
    "twitter-api-v2": "^1.29.0",
    "unpdf": "^1.6.2",
    "ws": "^8.20.0",
    "yaml": "^2.8.3",
    "zod": "^4.4.1"
  },
  "overrides": {
    "@xmldom/xmldom": "^0.8.13",
    "flatted": "^3.4.2",
    "uuid": ">=14.0.0",
    "fast-uri": "^3.1.2",
    "axios": "^1.16.0"
  }
}

exec
/bin/bash -lc 'bun run typecheck' in /home/enio/egos
 succeeded in 8833ms:
exec
/bin/bash -lc 'git diff --name-only dfe3f828208b273421e3e0233d24efbeb8bb789c' in /home/enio/egos
 succeeded in 0ms:
.claude/commands/banda.md
.guarani/RULES_INDEX.md
TASKS.md
TASKS_ARCHIVE.md
apps/egos-hq/app/api/hq/literature/route.ts
docs/CAPABILITY_REGISTRY.md
docs/_current_handoffs/FOR_CLAUDE_CODE_2026-06-01.md
docs/governance/BANDA_COGNITIVA.md
docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md
docs/governance/RESOLVER_DOCTRINE.md
docs/governance/RULE_SETS_INDEX.md
docs/jobs/2026-06-01-doc-drift-verifier.json
docs/jobs/2026-06-01-pre-commit-pipeline.json
docs/strategy/RUNBOOK_WHATSAPP_INCIDENTE.md
docs/strategy/sales-templates/oferta-vendedor-ia-gpecas.md
packages/mcp-literature/package.json
packages/mcp-literature/src/index.ts
packages/mcp-literature/tsconfig.json
scripts/mcp-ecosystem.config.js
tsconfig.json

codex
I did not find any actionable regressions in the code changes relative to the specified merge base. The new literature API route, MCP package, and ecosystem wiring are internally consistent and typecheck passes.
I did not find any actionable regressions in the code changes relative to the specified merge base. The new literature API route, MCP package, and ecosystem wiring are internally consistent and typecheck passes.
```
