# Codex Local Review — 2026-06-07T19:56:22Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.5
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019ea3a8-6e7d-7180-8cd1-eefabbcda9a1
--------
user
changes against 'HEAD~3'
2026-06-07T19:56:26.947591Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T19:56:26.958040Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d --stat && git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d' in /home/enio/egos
 succeeded in 0ms:
 .egos-manifest.yaml                                |  27 +++--
 TASKS.md                                           |   5 +-
 TASKS_ARCHIVE.md                                   |  10 ++
 agents/agents/article-writer.ts                    |  61 ++---------
 agents/agents/wiki-compiler.ts                     |  18 ++--
 apps/egos-gateway/src/orchestrator.ts              |  49 ++++-----
 .../app/api/hq/actions/codex-review/route.ts       |  75 +++++--------
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 apps/egos-landing/src/App.tsx                      |  70 ++++++++----
 apps/egos-landing/src/components/MyceliumPage.tsx  |   2 +-
 docs/knowledge/HARVEST.md                          |  46 +++++++-
 packages/chatbot-core/src/index.ts                 |   1 -
 packages/chatbot-core/src/model-router.ts          |  34 +++---
 packages/mcp-ops/src/index.ts                      |   6 +-
 packages/pii-purge/README.md                       |  19 +++-
 packages/pii-purge/package.json                    |   2 +-
 packages/pii-purge/src/cli.ts                      |  37 ++++++-
 packages/pii-purge/src/patterns.ts                 |   2 +-
 packages/pii-purge/src/pii-purge.test.ts           |  38 ++++++-
 packages/pii-purge/src/purge.ts                    |  25 ++++-
 packages/pii-purge/src/scanner.ts                  | 118 +++++++++++++++++----
 packages/pii-purge/src/verify.ts                   |  30 ++++--
 packages/shared/src/__tests__/llm-provider.test.ts |  60 +++--------
 packages/shared/src/__tests__/model-router.test.ts |  62 ++++-------
 packages/shared/src/index.ts                       |   2 +-
 packages/shared/src/llm-orchestrator.ts            |  22 ++--
 packages/shared/src/llm-provider.ts                |  98 ++++-------------
 packages/shared/src/llm-providers/llm-router.ts    |  96 ++++-------------
 .../src/mcp-clients/llm-router-mcp-client.ts       |  10 +-
 packages/shared/src/metrics-tracker.ts             |   2 +-
 packages/shared/src/model-router.ts                |  47 +-------
 scripts/activation-check.ts                        |   1 -
 scripts/ai-commit-security.ts                      |   2 +-
 scripts/ai-coverage-scan.ts                        |   4 +-
 scripts/bench-providers.ts                         |   2 +-
 scripts/context-manager.ts                         |   4 +-
 scripts/debrief/pipeline.ts                        |  22 ++--
 scripts/doctor.ts                                  |   3 +-
 scripts/gem-hunter-digest.ts                       |  50 ++-------
 scripts/kbs/seed-egos-advocacia.ts                 |   3 +-
 scripts/manifest-generator.ts                      |  30 +++---
 scripts/review_models.ts                           |  12 +--
 scripts/ssot-router.ts                             |  30 +++---
 scripts/start-audit.ts                             |   2 +-
 scripts/start-v6.ts                                |   4 +-
 scripts/test-alibaba-orchestrator.ts               |  39 -------
 scripts/token-compaction-pilot.ts                  |   4 +-
 scripts/x-opportunity-alert.ts                     |  51 +++------
 scripts/x-post-approval-bot.ts                     |  20 ++--
 50 files changed, 627 insertions(+), 734 deletions(-)
diff --git a/.egos-manifest.yaml b/.egos-manifest.yaml
index 5199a4d7..f77236dd 100644
--- a/.egos-manifest.yaml
+++ b/.egos-manifest.yaml
@@ -88,7 +88,7 @@ claims:
   - id: completed_tasks_total
     description: "Total completed tasks in TASKS.md"
     readme_location: "TASKS.md"
-    command: "grep -c '^- \\[x\\]' TASKS.md"
+    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
     tolerance: "min:1"
     last_value: "1"
     last_verified_at: "2026-05-25"
@@ -167,6 +167,16 @@ claims:
     category: "governance"
     note: "Main stages: gitleaks, start-v6.0, tsc, doc-proliferation, governance-sync, SSOT-drift, doc-drift, evidence-gate, file-intelligence, vocab-guard, hook-telemetry-collector"
 
+  - id: cross_repo_capabilities
+    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
+    readme_location: "docs/knowledge/CAPABILITY_CROSS_INDEX.md"
+    command: "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
+    tolerance: "min:10"
+    last_value: "28"
+    last_verified_at: "2026-05-05"
+    category: "custom"
+    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+
 domains:
   - url: "https://guard.egos.ia.br/health"
     expected_status: "200"
@@ -177,7 +187,7 @@ domains:
     checked_at: "2026-04-29"
     note: "Redirects to /login"
   - url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
-    expected_status: "200"
+    expected_status: "301"
     checked_at: "2026-04-29"
   - url: "https://eagleeye.egos.ia.br/"
     expected_status: "200"
@@ -199,16 +209,5 @@ endpoints:
   - name: "gem_hunter_topics"
     url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
     method: "GET"
-    expected_status: "200"
-    expected_contains: "Gem Hunter"
-
-  - id: cross_repo_capabilities
-    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
-    readme_location: "docs/CAPABILITY_CROSS_INDEX.md"
-    command: "grep -c '^- \\*\\*' docs/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
-    tolerance: "min:10"
-    last_value: "28"
-    last_verified_at: "2026-05-05"
-    category: "custom"
-    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+    expected_status: "301"
 
diff --git a/TASKS.md b/TASKS.md
index 7d575eb6..44cbdf18 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -115,7 +115,6 @@
 > Página que mostra o EGOS trabalhando AO VIVO. Ocioso → batimento Hermes (always-on) + tiles de serviço; ativo → cada call/agente/workflow/commit pulsa. Arquitetura 3 camadas: SINK (tabela mycelium_events Supabase, eventos sanitizados {type,source,status,ts}, NUNCA payload/secret/PII) → READ (SSE no Hermes/gateway, público=agregado sanitizado, auth=detalhe) → FRONTEND (egos-site, reusa apps/_archived/commons/src/lib/mycelium.ts). Honest: público mostra camada always-on (VPS/MCP/serviços via egos-observability pm2_status); sessões Claude Code precisam de bridge ~/.egos/*.jsonl→sink (decisão Enio: a=só-VPS b=bridge). Liga /mycelium skill (Kernel Reality Check).
 - [ ] **CONTEXT-ALARM-RESTORE-001** [P2] `hermes-ops` `redzone` — Restaurar dente do `context-alarm.sh` (threshold/freeze removidos 2026-05-22) + consolidar 3 hooks de custo sobrepostos (context-alarm/session-status/budget-guard) (L-02, L-06 — corte Enio: bloqueante ou aviso?).
 - [ ] **SESSION-START-RESET-001** [P2] `forja` — Consertar divergência doc/código: `session-start.sh` não reseta contadores pós-compact apesar de CLAUDE.md §5.1 afirmar (proveniência-por-ação).
-- [ ] **GEMHUNTER-QUEUE-BUG-001** [P3] `forja` — Verificar `queueForAutoIntegration()` no gem-hunter v6.1 (órfã suspeita no premortem 2026-05-30): bug ativo ou dead-code? (L-05).
 - [ ] **CONTEXT-AUDIT-RERUN-001** [P3] — Re-rodar `context-audit.ts` (última ~2026-05-06; skills cresceram) p/ atualizar math 49k vs 275k overhead (E-05).
 
 ## 🎓 EGOS FOUNDERS COURSE — produto educacional público (Enio 2026-06-04, "paguei minha dívida, agora prospero")
@@ -872,8 +871,8 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
 - [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
 - [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
-- [ ] **PII-PURGE-BUG-001** [P1] `forja` — BUG: dict com placa duplicada (`JIZ-6956`+`JIZ6956`) → 2 padrões casam o mesmo span → output corrompido `[PESSOA_1]_1]`. Fix: dedupe de spans sobrepostos antes da substituição (longest-wins) OU dedupe de padrões por entidade. Repro: route.ts no purge 2026-06-07.
-- [ ] **PII-PURGE-VERIFY-001** [P1] `forja` — `verifyCleanExit` confia só nos padrões do dict — texto em campo `reds` (numérico) escapou silencioso. Fix: verify roda TAMBÉM scan estrutural genérico (guard-brasil `detectPII`) + avisa quando valor de dict não casa nenhum padrão (campo errado).
+- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — Wire `--verify-only` no pre-commit (R-SEC-005) + paths de publicação (push/NotebookLM/deploy). Mecanismo pronto; falta plugar nos hooks.
+- [ ] **PII-PURGE-SKILL-001** [P2] `prime` — Skill `/purge <repo>`: monta dict (HITL) + dry-run + relatório + apply (HITL) + runbook "como limpar um sistema". Casca ergonômica para qualquer um/IA limpar com 1 comando.
 - [ ] **INTELINK-PLATFORM-GH-CACHE-001** [P1] `prime`+`hermes-ops` — GitHub pode reter `f0cfdb7` (18 PII) por SHA até GC + em forks/PRs. Como INC-PII-001: contatar GitHub Support p/ purgar cache + checar forks/network. Force-push limpou o branch, não garante o cache.
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index e10a7f4f..44eb39bc 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3716,3 +3716,13 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
 - [x] **PII-PURGE-007** [P0] `prime` — Aplicado ao `intelink-clean` (2026-06-07): rm 2 RELINT + mascarar 7 arquivos + orphan squash + force-push. `origin/main` = baseline limpo `4bb4665` (0 PII; era f0cfdb7 c/ 18 hits). Backup local `backup-pre-squash-2026-06-07`.
 
+
+## Archived 2026-06-07
+
+### 🍄 MYCELIUM — egos.ia.br/mycelium (sistema vivo, Enio já pediu antes)
+- [x] **GEMHUNTER-QUEUE-BUG-001** [P3] `forja` — Verificar `queueForAutoIntegration()` no gem-hunter v6.1 (órfã suspeita no premortem 2026-05-30): bug ativo ou dead-code? (L-05). ✅ 2026-06-07
+
+### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
+- [x] **PII-PURGE-BUG-001** [P1] `prime` — FIX `e9886022`: dedupe de spans sobrepostos (longest-wins) em `applyReplacements`. Teste + smoke: placa com/sem traço → 1 token limpo, sem corrupção `[PESSOA_N]_`.
+- [x] **PII-PURGE-VERIFY-001** [P1] `prime` — FIX `e9886022`: safety-net de busca literal (`scanLiteralValues`/`flattenEntityValues`) ligado ao `verify` — independe da tipagem do campo; pega valor de texto em campo numérico. + `--verify-only` (publish gate) + exclui o próprio dict do scan. 31 testes verdes.
+
diff --git a/agents/agents/article-writer.ts b/agents/agents/article-writer.ts
index 9bb8f178..dcb7f5a6 100644
--- a/agents/agents/article-writer.ts
+++ b/agents/agents/article-writer.ts
@@ -52,17 +52,13 @@ const TRANSLATION_OF_ARG = (() => {
 
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE_URL =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const GUARD_BRASIL_URL = "https://guard.egos.ia.br/v1/inspect";
 const GUARD_BRASIL_API_KEY = process.env.GUARD_BRASIL_API_KEY ?? "";
 
 // Rough token cost estimates (USD per 1k tokens)
-const COST_PER_1K_INPUT_QWEN = 0.0004;
-const COST_PER_1K_OUTPUT_QWEN = 0.0012;
+const COST_PER_1K_INPUT_GEMINI = 0.0001;
+const COST_PER_1K_OUTPUT_GEMINI = 0.0004;
 
 // ── Types ──────────────────────────────────────────────────────────────────
 
@@ -373,47 +369,7 @@ async function fetchWikiPages(): Promise<Array<{ slug: string; title: string }>>
 async function callLLM(prompt: string): Promise<LLMResult> {
   const messages = [{ role: "user" as const, content: prompt }];
 
-  // Primary: DashScope qwen-plus
-  if (DASHSCOPE_API_KEY) {
-    try {
-      const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-        method: "POST",
-        headers: {
-          "Content-Type": "application/json",
-          Authorization: `Bearer ${DASHSCOPE_API_KEY}`,
-        },
-        body: JSON.stringify({
-          model: "qwen-plus",
-          messages,
-          max_tokens: 1500,
-          temperature: 0.6,
-        }),
-        signal: AbortSignal.timeout(30000),
-      });
-
-      if (res.ok) {
-        const data = (await res.json()) as {
-          choices?: Array<{ message?: { content?: string } }>;
-          usage?: { prompt_tokens?: number; completion_tokens?: number };
-        };
-        const raw = data.choices?.[0]?.message?.content?.trim() ?? "";
-        const inputTokens = data.usage?.prompt_tokens ?? Math.floor(prompt.length / 4);
-        const outputTokens = data.usage?.completion_tokens ?? Math.floor(raw.length / 4);
-        const costUsd =
-          (inputTokens / 1000) * COST_PER_1K_INPUT_QWEN +
-          (outputTokens / 1000) * COST_PER_1K_OUTPUT_QWEN;
-
-        const content = parseArticleJSON(raw);
-        if (content) {
-          return { content, provider: "alibaba/qwen-plus", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: costUsd };
-        }
-      }
-    } catch (err) {
-      console.warn(`⚠️  DashScope error: ${err} — falling back to OpenRouter`);
-    }
-  }
-
-  // Fallback: OpenRouter free model
+  // Primary: OpenRouter gemini-2.0-flash-001
   if (OPENROUTER_API_KEY) {
     try {
       const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
@@ -421,9 +377,11 @@ async function callLLM(prompt: string): Promise<LLMResult> {
         headers: {
           "Content-Type": "application/json",
           Authorization: `Bearer ${OPENROUTER_API_KEY}`,
+          "HTTP-Referer": "https://egos.dev",
+          "X-Title": "egos-article-writer",
         },
         body: JSON.stringify({
-          model: "google/gemma-4-26b-a4b-it:free",
+          model: "google/gemini-2.0-flash-001",
           messages,
           max_tokens: 1500,
           temperature: 0.6,
@@ -439,10 +397,13 @@ async function callLLM(prompt: string): Promise<LLMResult> {
         const raw = data.choices?.[0]?.message?.content?.trim() ?? "";
         const inputTokens = data.usage?.prompt_tokens ?? Math.floor(prompt.length / 4);
         const outputTokens = data.usage?.completion_tokens ?? Math.floor(raw.length / 4);
+        const costUsd =
+          (inputTokens / 1000) * COST_PER_1K_INPUT_GEMINI +
+          (outputTokens / 1000) * COST_PER_1K_OUTPUT_GEMINI;
 
         const content = parseArticleJSON(raw);
         if (content) {
-          return { content, provider: "openrouter/gemma-4-26b-free", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: 0 };
+          return { content, provider: "openrouter/gemini-2.0-flash-001", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: costUsd };
         }
       }
     } catch (err) {
@@ -450,7 +411,7 @@ async function callLLM(prompt: string): Promise<LLMResult> {
     }
   }
 
-  throw new Error("No LLM available (ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY required)");
+  throw new Error("No LLM available (OPENROUTER_API_KEY required)");
 }
 
 function parseArticleJSON(raw: string): ArticleContent | null {
diff --git a/agents/agents/wiki-compiler.ts b/agents/agents/wiki-compiler.ts
index 4f652521..f49ecfee 100644
--- a/agents/agents/wiki-compiler.ts
+++ b/agents/agents/wiki-compiler.ts
@@ -786,22 +786,20 @@ async function dedup(): Promise<void> {
 
 // ─── KB-014: LLM Enrichment ──────────────────────────────────────────────────
 
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
+const OPENROUTER_KEY_WC = process.env.OPENROUTER_API_KEY ?? "";
 
 async function enrichPage(page: { id: string; title: string; content: string; category: string }): Promise<{
   summary: string;
   tags: string[];
   quality_boost: number;
 }> {
-  if (!DASHSCOPE_KEY) throw new Error("ALIBABA_DASHSCOPE_API_KEY not set");
+  if (!OPENROUTER_KEY_WC) throw new Error("OPENROUTER_API_KEY not set");
 
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
     method: "POST",
-    headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
+    headers: { Authorization: `Bearer ${OPENROUTER_KEY_WC}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos-wiki-compiler" },
     body: JSON.stringify({
-      model: "qwen-plus",
+      model: "google/gemini-2.0-flash-001",
       messages: [
         {
           role: "system",
@@ -823,14 +821,14 @@ Content (truncated): ${page.content.slice(0, 1500)}`,
     signal: AbortSignal.timeout(20000),
   });
 
-  if (!res.ok) throw new Error(`DashScope ${res.status}`);
+  if (!res.ok) throw new Error(`OpenRouter ${res.status}`);
   const data = await res.json() as { choices: Array<{ message: { content: string } }> };
   return JSON.parse(data.choices[0].message.content);
 }
 
 async function enrich(): Promise<void> {
-  if (!DASHSCOPE_KEY) {
-    console.error("[wiki-compiler] ALIBABA_DASHSCOPE_API_KEY not set — cannot enrich");
+  if (!OPENROUTER_KEY_WC) {
+    console.error("[wiki-compiler] OPENROUTER_API_KEY not set — cannot enrich");
     return;
   }
 
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..deb06b9d 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -2,9 +2,9 @@
  * EGOS Gateway — AI Orchestrator v2
  *
  * Shared LLM orchestration for WhatsApp + Telegram chatbots.
- * Model: qwen-plus (Alibaba DashScope)
+ * Model: google/gemini-2.0-flash-001 (OpenRouter)
  * Transcription: Groq Whisper-large-v3-turbo
- * Vision: qwen-vl-plus
+ * Vision: google/gemini-2.0-flash-001 (multimodal)
  *
  * Tools (13):
  *   system_status, guard_status, guard_test, gem_search, gem_trending,
@@ -18,22 +18,18 @@ import { execSync } from "child_process";
 
 // ─── Config ───────────────────────────────────────────────────────────────────
 
-const DASHSCOPE_BASE =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
 const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
 const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 
 /**
  * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
  *
- * Default: gemini-2.5-flash via OpenRouter (60% mais barato que qwen-plus,
- * PT-BR nativo, tool-calling sólido).
+ * Default: gemini-2.0-flash-001 via OpenRouter (PT-BR nativo, tool-calling sólido,
+ * multimodal nativo).
  *
- * Rollback: setar CHATBOT_PRIMARY_MODEL=qwen-plus no .env do gateway.
+ * Override: setar CHATBOT_PRIMARY_MODEL no .env do gateway.
  *
- * Fallback chain: primary → fallback → qwen-plus (último recurso).
+ * Fallback chain: primary → fallback (último recurso).
  */
 interface LLMProvider {
   name: string;
@@ -43,7 +39,7 @@ interface LLMProvider {
 }
 
 const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
-const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "qwen-plus";
+const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";
 
 function getProvider(modelName: string): LLMProvider | null {
   // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
@@ -61,13 +57,12 @@ function getProvider(modelName: string): LLMProvider | null {
       model: orModel,
     };
   }
-  // Qwen via DashScope direto
-  if (modelName.startsWith("qwen-")) {
-    if (!DASHSCOPE_KEY) return null;
+  // Via OpenRouter (fallback genérico com prefixo de provider)
+  if (OPENROUTER_KEY && modelName.includes("/")) {
     return {
       name: modelName,
-      base: DASHSCOPE_BASE,
-      key: DASHSCOPE_KEY,
+      base: "https://openrouter.ai/api/v1",
+      key: OPENROUTER_KEY,
       model: modelName,
     };
   }
@@ -207,11 +202,10 @@ async function saveHistory(
 // ─── Token accounting (RATIO-ABSORB-004) ─────────────────────────────────────
 
 const MODEL_COST_PER_1K: Record<string, { input: number; output: number }> = {
-  "qwen-plus":               { input: 0.0004, output: 0.0012 },
-  "qwen-max":                { input: 0.0024, output: 0.0072 },
-  "qwen-turbo":              { input: 0.0001, output: 0.0003 },
-  "minimax/minimax-m2.5":    { input: 0.0002, output: 0.0002 },
-  "google/gemini-2.0-flash": { input: 0.0001, output: 0.0004 },
+  "google/gemini-2.0-flash-001": { input: 0.0001, output: 0.0004 },
+  "google/gemini-2.5-pro":       { input: 0.0025, output: 0.0100 },
+  "minimax/minimax-m2.5":        { input: 0.0002, output: 0.0002 },
+  "google/gemini-2.0-flash":     { input: 0.0001, output: 0.0004 },
 };
 
 function estimateCostUsd(model: string, inputTokens: number, outputTokens: number): number {
@@ -243,7 +237,6 @@ async function logTokenUsage(
 // nothing wrote here, so cost tracking was silently dead.
 function providerFromModel(model: string): string {
   const m = model.toLowerCase();
-  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
   if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3")) return "OpenAI";
   if (m.includes("gemini") || m.includes("gemma")) return "Google";
   if (m.includes("claude")) return "Anthropic";
@@ -1314,14 +1307,14 @@ export async function transcribeAudio(audioBase64: string, mime: string): Promis
 }
 
 export async function describeImage(imageBase64: string, mime: string, caption?: string): Promise<string> {
-  if (!DASHSCOPE_KEY) return "[Análise de imagem não configurada]";
+  if (!OPENROUTER_KEY) return "[Análise de imagem não configurada]";
   try {
     const dataUrl = `data:${mime};base64,${imageBase64}`;
-    const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
-      headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
+      headers: { Authorization: `Bearer ${OPENROUTER_KEY}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos" },
       body: JSON.stringify({
-        model: "qwen-vl-plus",
+        model: "google/gemini-2.0-flash-001",
         messages: [{
           role: "user",
           content: [
@@ -1547,8 +1540,8 @@ ESTILO DE RESPOSTA:
 // ─── Main orchestrator ────────────────────────────────────────────────────────
 
 export async function orchestrate(msg: IncomingMessage, client?: ClientContext): Promise<OrchestratorResponse> {
-  if (!DASHSCOPE_KEY) {
-    return { text: "❌ ALIBABA_DASHSCOPE_API_KEY não configurado." };
+  if (!OPENROUTER_KEY) {
+    return { text: "❌ OPENROUTER_API_KEY não configurado." };
   }
 
   const toolsUsed: string[] = [];
diff --git a/apps/egos-hq/app/api/hq/actions/codex-review/route.ts b/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
index 3f884837..09df7252 100644
--- a/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
+++ b/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
@@ -1,58 +1,33 @@
 import { NextResponse } from 'next/server';
 
-// Triggers a constitutional review via Alibaba DashScope (qwen-plus)
-// Migrated from Codex proxy → DashScope 2026-04-08 (CDX→HRM migration)
+// Triggers a constitutional review via OpenRouter (google/gemini-2.0-flash-001)
+// Migrated: DashScope (free grant expired 2026-06) → OpenRouter 2026-06-07
 // POST /api/hq/actions/codex-review
 
-const DASHSCOPE_BASE_URL = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1';
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? '';
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? '';
 
 async function callLLM(prompt: string): Promise<string> {
-  // Primary: Alibaba DashScope qwen-plus
-  if (DASHSCOPE_API_KEY) {
-    const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-      method: 'POST',
-      headers: {
-        'Authorization': `Bearer ${DASHSCOPE_API_KEY}`,
-        'Content-Type': 'application/json',
-      },
-      body: JSON.stringify({
-        model: 'qwen-plus',
-        messages: [{ role: 'user', content: prompt }],
-        max_tokens: 512,
-      }),
-      signal: AbortSignal.timeout(30000),
-    });
-    if (res.ok) {
-      const data = await res.json();
-      return data?.choices?.[0]?.message?.content ?? '';
-    }
-  }
-
-  // Fallback: OpenRouter (Gemma 4 26B free)
-  if (OPENROUTER_API_KEY) {
-    const res = await fetch('https://openrouter.ai/api/v1/chat/completions', {
-      method: 'POST',
-      headers: {
-        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
-        'Content-Type': 'application/json',
-        'HTTP-Referer': 'https://hq.egos.ia.br',
-      },
-      body: JSON.stringify({
-        model: 'google/gemma-4-26b-a4b-it:free',
-        messages: [{ role: 'user', content: prompt }],
-        max_tokens: 512,
-      }),
-      signal: AbortSignal.timeout(30000),
-    });
-    if (res.ok) {
-      const data = await res.json();
-      return data?.choices?.[0]?.message?.content ?? '';
-    }
-  }
-
-  throw new Error('No LLM provider available');
+  if (!OPENROUTER_API_KEY) throw new Error('OPENROUTER_API_KEY not set');
+
+  const res = await fetch('https://openrouter.ai/api/v1/chat/completions', {
+    method: 'POST',
+    headers: {
+      'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
+      'Content-Type': 'application/json',
+      'HTTP-Referer': 'https://hq.egos.ia.br',
+      'X-Title': 'egos-codex-review',
+    },
+    body: JSON.stringify({
+      model: 'google/gemini-2.0-flash-001',
+      messages: [{ role: 'user', content: prompt }],
+      max_tokens: 512,
+    }),
+    signal: AbortSignal.timeout(30000),
+  });
+
+  if (!res.ok) throw new Error(`OpenRouter error: ${res.status}`);
+  const data = await res.json();
+  return data?.choices?.[0]?.message?.content ?? '';
 }
 
 export async function POST() {
@@ -62,14 +37,14 @@ export async function POST() {
 2. Check if recent commits follow conventional commit format
 3. Verify 90-day focus is maintained (Guard Brasil + Gem Hunter only)
 4. Output: one-line status per check + overall score (0-100)
-5. Sign with: REVIEWED_BY: DashScope-HQ-trigger / ${new Date().toISOString()}`;
+5. Sign with: REVIEWED_BY: OpenRouter-gemini-2.0-flash-001 / ${new Date().toISOString()}`;
 
     const content = await callLLM(reviewPrompt);
 
     return NextResponse.json({
       ok: true,
       review: content,
-      provider: DASHSCOPE_API_KEY ? 'alibaba-dashscope/qwen-plus' : 'openrouter/gemma-4-26b',
+      provider: 'openrouter/gemini-2.0-flash-001',
       triggered_at: new Date().toISOString(),
     });
   } catch (err) {
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..730fe163 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 19:50:51 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..730fe163 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 19:50:51 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index ba3c38a8..1aca1271 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -475,13 +475,13 @@ function App() {
                 onClick={() => navigateTo('grok')}
                 style={{ color: currentRoute === 'grok' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Grok Hunter
+                Checador de IA
               </button>
               <button
                 onClick={() => navigateTo('mycelium')}
                 style={{ color: currentRoute === 'mycelium' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Mycelium
+                Rede de conhecimento
               </button>
             </div>
           )}
@@ -537,8 +537,8 @@ function App() {
             { route: 'transparencia', label: 'Transparência' },
             { route: 'guard', label: 'Guard Brasil' },
             { route: 'tools', label: 'Ferramentas' },
-            { route: 'grok', label: 'Grok Hunter' },
-            { route: 'mycelium', label: 'Mycelium' },
+            { route: 'grok', label: 'Checador de IA' },
+            { route: 'mycelium', label: 'Rede de conhecimento' },
           ] as { route: string; label: string }[]).map(({ route, label }) => (
             <button
               key={route || 'home'}
@@ -567,16 +567,16 @@ function App() {
             <div>
               {/* Hero Banner */}
               <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>Framework de IA Governada</span>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
                 <h1 className="display-xl" style={{ marginBottom: '24px' }}>
-                  IA que você pode <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>auditar, explicar e controlar</span>
+                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
                 </h1>
                 <p className="body-l muted" style={{ marginBottom: '32px' }}>
-                  EGOS é um framework de orquestração de agentes com governança embutida — rastreabilidade por design, conformidade LGPD, e gates de segurança que rodam antes de qualquer dado sair da sua máquina.
+                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
                 </p>
                 <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
-                  <a href="https://egos.ia.br/tools" className="btn btn-primary">Usar ferramentas →</a>
-                  <button onClick={() => navigateTo('timeline')} className="btn btn-ghost">Ver builds ao vivo</button>
+                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
+                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
                 </div>
               </section>
 
@@ -585,31 +585,59 @@ function App() {
                 <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
                 <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px' }}>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Governança</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🎯</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>1. Escolha seu tipo de trabalho</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      Regras constitucionais com precedência T0→T4. Cada decisão de agente é classificada antes de executar. Gates pré-commit bloqueiam dado sensível.
+                      O EGOS parte da sua realidade — advocacia, clínica, contabilidade, comércio, sala de aula. Assim a IA recebe instruções claras do que fazer e do que evitar.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🤖</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Agentes</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>2. Proteja as informações sensíveis</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      12 papéis especializados (Guardião, Curador, Investigador, Sentinela…) com escopo definido e HITL obrigatório em Red Zones.
+                      Antes de mandar algo para a IA, o EGOS ajuda a identificar dados como CPF, CNPJ, prontuário e dados de cliente — para diminuir o risco de expor o que não deve sair do seu controle.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>⚙️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Ferramentas</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>✅</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>3. Confira antes de confiar</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      MCPs, Guard Brasil (PII), eval-runner com casos dourados, e pipelines auditáveis. Cada capability tem evidência — stub sem teste é code morto.
+                      O EGOS organiza a resposta da IA para você separar o que é fato, o que precisa de conferência e o que é só sugestão. A decisão final continua com você.
                     </p>
                   </div>
                 </div>
               </section>
 
-              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              {/* ── Como você usa na sua área ── */}
               <section style={{ margin: '56px 0' }}>
+                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
+                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Para o seu dia a dia</span>
+                  <h2 className="h2">Como você usa na sua área</h2>
+                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
+                    O EGOS se adapta ao seu trabalho. Alguns exemplos de quem já pode usar hoje.
+                  </p>
+                </div>
+                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px' }}>
+                  {[
+                    { icon: '⚖️', area: 'Advogado', problema: 'Analisar documentos e responder clientes sem expor dados do processo.', ajuda: 'Um assistente que lê documentos com cuidado, responde pelo WhatsApp e guarda registro de cada atendimento.' },
+                    { icon: '🩺', area: 'Médico / Clínica', problema: 'Usar IA no dia a dia sem expor prontuário ou dados de paciente.', ajuda: 'Mostra como usar IA com os dados protegidos e revisão humana antes de qualquer orientação sensível.' },
+                    { icon: '🧾', area: 'Contador', problema: 'Dados fiscais, CPF e CNPJ passam por muitas tarefas repetitivas.', ajuda: 'Ajuda a organizar as informações para análise sem tratar dado sensível como texto comum.' },
+                    { icon: '🍽️', area: 'Comércio / Restaurante', problema: 'Cardápio e catálogo vivem em foto, papel ou mensagem de WhatsApp.', ajuda: 'Transforma a foto do cardápio ou catálogo em planilha pronta — com conferência humana antes de cadastrar.' },
+                    { icon: '📚', area: 'Professor', problema: 'IA cria material bonito, mas às vezes com erro ou fonte fraca.', ajuda: 'Organiza aulas, exercícios e resumos com pontos de conferência antes de usar com os alunos.' },
+                    { icon: '🌾', area: 'Agrônomo', problema: 'Laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.', ajuda: 'Um assistente da área que organiza as informações e destaca o que precisa ser validado por um profissional.' },
+                  ].map((c) => (
+                    <div key={c.area} className="card" style={{ padding: '28px' }}>
+                      <div style={{ fontSize: '28px', marginBottom: '12px' }}>{c.icon}</div>
+                      <h3 className="h3" style={{ marginBottom: '8px' }}>{c.area}</h3>
+                      <p style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.6, marginBottom: '10px' }}>{c.problema}</p>
+                      <p style={{ fontSize: '14px', color: 'var(--text-strong)', lineHeight: 1.6 }}>{c.ajuda}</p>
+                    </div>
+                  ))}
+                </div>
+              </section>
+
+              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              <section id="comece" style={{ margin: '56px 0' }}>
                 <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                   <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
                   <h2 className="h2">Comece aqui</h2>
@@ -1258,8 +1286,8 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
           {currentRoute === 'grok' && (
             <div>
               <section style={{ textAlign: 'center', marginBottom: '40px' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Inteligência em Tempo Real (X.com)</span>
-                <h1 className="h2">Grok Hunter Assistant</h1>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Pesquisa de tendências com IA</span>
+                <h1 className="h2">Checador de IA</h1>
                 <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '12px auto 0' }}>
                   Gere prompts otimizados para buscar tendências, repositórios e artigos no Grok e importe de graça no EGOS.
                 </p>
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 9e5abbd4..63e0a41d 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -330,7 +330,7 @@ export function MyceliumPage() {
             Sistema vivo · tempo real
           </span>
           <h1 style={{ fontSize: '30px', fontWeight: 800, color: 'var(--text-strong)', margin: '0 0 10px' }}>
-            Mycelium — o EGOS por dentro
+            Rede de conhecimento — o EGOS por dentro
           </h1>
           <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '0 auto', fontSize: '14px', lineHeight: 1.6 }}>
             Cada nó é uma peça real do sistema. As linhas são as conexões — quem fala com quem.
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index c4c9c6fc..8c95e42d 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,8 +1,50 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.15.0 | **UPDATED:** 2026-06-03 UTC-3
+> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P169 — Orquestração Local Rápida (Guarani e Prime/Claude Code)
+> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+
+---
+
+## P170 — 2026-06-07: Mapa de Consumo de Tokens LLM (OpenRouter/Gemini)
+
+**Trigger:** Contexto alarm mostrou $77.30 — usuário perguntou onde estamos gastando tanto com Gemini.
+
+**Achado crítico:** O $77.30 era custo da **sessão Claude Code** (Opus model, 429 msgs), NÃO do sistema EGOS.
+
+### Superfícies LLM ativas no EGOS (2026-06-07)
+
+| Superfície | Trigger | Modelo | Custo estimado |
+|-----------|---------|--------|---------------|
+| Gateway chatbot (WhatsApp/TG/web) | Por mensagem de usuário | gemini-2.0-flash-001 | ~$0.0001/msg |
+| HQ codex-review | Por PR review solicitado | gemini-2.0-flash-001 | ~$0.001/review |
+| HQ chat/banda | Por chamada manual | gemini-2.0-flash-001 | ~$0.0001/call |
+| x-opportunity-alert | VPS cron 0 */2 * * * (2h) | gemini-2.0-flash-001 | ~$0.001-0.01/run |
+| x-reply-bot | VPS cron 0 * * * * (1h) | gemini-2.0-flash-001 | ~$0.001/run |
+| llm-model-monitor | A cada 6h (polling /models) | N/A (API pública) | $0 (sem chat) |
+| Hermes cron jobs | 2 semanais (Mon+Sun) | claude-sonnet-4-6 via Anthropic | custo Anthropic API |
+| Scripts manuais | On-demand | gemini-2.0-flash-001 | ad hoc |
+
+**Dados reais Supabase `api_usage`:**
+- Total: 8 calls | $0.0145 USD | Google gemini-2.5-flash
+- Última entrada: 2026-06-03 — logging incompleto ou VPS scripts não rodando
+
+**Hermes default model:** `claude-sonnet-4-6` via Anthropic API — cron runners usam Anthropic, não OpenRouter.
+
+### Cadeia de fallback implementada (llm-provider.ts)
+
+1. **Google AI Studio (free):** gemini-2.5-flash (500 req/day) → gemma-4-31b-it (1500 req/day) — GRATUITO
+2. **OpenRouter (pago):** gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
+
+**Custo projetado mensal** (uso moderado — gateway 50 msgs/dia + VPS crons):
+- Google free tier absorve ~1500 req/dia → OpenRouter só entra no overflow
+- Estimativa conservadora: < $5/mês se free tier estiver funcionando
+
+### Maior fonte de custo real (não-Gemini)
+
+**Claude Code sessions com Opus:** $77.30/sessão longa. Este é o custo dominante — não o Gemini.
+- Usar Sonnet 4.6 (default) em vez de Opus reduz custo ~5x
+- Sessões com 429+ msgs = custo acumulado de cache_read crescente
 
 ---
 
diff --git a/packages/chatbot-core/src/index.ts b/packages/chatbot-core/src/index.ts
index f7ddbea4..1a255be0 100644
--- a/packages/chatbot-core/src/index.ts
+++ b/packages/chatbot-core/src/index.ts
@@ -24,7 +24,6 @@ export {
   fetchWithFailover,
   resolveTiers,
   EGOS_DEFAULT_MODELS,
-  DASHSCOPE_BASE_URL,
   OPENROUTER_BASE_URL,
 } from './model-router.js';
 export type { ResolvedTier, FetchResult } from './model-router.js';
diff --git a/packages/chatbot-core/src/model-router.ts b/packages/chatbot-core/src/model-router.ts
index 9b8e605f..bda5d09f 100644
--- a/packages/chatbot-core/src/model-router.ts
+++ b/packages/chatbot-core/src/model-router.ts
@@ -14,12 +14,10 @@
 import type { ModelTier, ModelConfig } from './types.js';
 
 // ---------------------------------------------------------------------------
-// DashScope preset (ALIBABA cloud — primary for EGOS projects)
-// Docs: https://help.aliyun.com/zh/model-studio/
+// OpenRouter preset — primary for EGOS projects
+// Docs: https://openrouter.ai/docs
 // ---------------------------------------------------------------------------
 
-// INTL endpoint — international API keys (sk-ws-*) 401 on the CN host (dashscope.aliyuncs.com).
-export const DASHSCOPE_BASE_URL = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';
 export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completions';
 
 /**
@@ -28,27 +26,27 @@ export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completion
  */
 export const EGOS_DEFAULT_MODELS: ModelConfig = {
   primary: {
-    modelId: 'qwen-plus',
-    providerEnvKey: 'DASHSCOPE_API_KEY',
-    baseUrl: DASHSCOPE_BASE_URL,
-    inputCostPerMillion: 0.40,
-    outputCostPerMillion: 1.20,
+    modelId: 'openai/gpt-oss-120b:free',
+    providerEnvKey: 'OPENROUTER_API_KEY',
+    baseUrl: OPENROUTER_BASE_URL,
+    inputCostPerMillion: 0,
+    outputCostPerMillion: 0,
   },
   fallback: {
-    modelId: 'deepseek-chat-v3-0324',
-    providerEnvKey: 'DASHSCOPE_API_KEY',
-    baseUrl: DASHSCOPE_BASE_URL,
-    inputCostPerMillion: 0.20,
-    outputCostPerMillion: 0.77,
-  },
-  fast: {
-    // Emergency tier — OpenRouter hosted, no DashScope required
-    modelId: 'meta-llama/llama-4-maverick:free',
+    modelId: 'qwen/qwen3-coder:free',
     providerEnvKey: 'OPENROUTER_API_KEY',
     baseUrl: OPENROUTER_BASE_URL,
     inputCostPerMillion: 0,
     outputCostPerMillion: 0,
   },
+  fast: {
+    // Emergency tier — OpenRouter hosted
+    modelId: 'google/gemini-2.0-flash-001',
+    providerEnvKey: 'OPENROUTER_API_KEY',
+    baseUrl: OPENROUTER_BASE_URL,
+    inputCostPerMillion: 0.1,
+    outputCostPerMillion: 0.4,
+  },
 };
 
 // ---------------------------------------------------------------------------
diff --git a/packages/mcp-ops/src/index.ts b/packages/mcp-ops/src/index.ts
index 30ac0345..5c62b98c 100644
--- a/packages/mcp-ops/src/index.ts
+++ b/packages/mcp-ops/src/index.ts
@@ -69,9 +69,7 @@ const MODELS = [
   { id: "gpt-5.3-codex", provider: "openai", role: "scaffolding", cost_per_1m: 5.0, quota: "plus_20" },
   { id: "gpt-5.5", provider: "openai", role: "adversarial-review", cost_per_1m: 30.0, quota: "plus_20_rare" },
   { id: "gemini-2.0-flash", provider: "google", role: "implementation", cost_per_1m: 0.075 },
-  { id: "qwen-turbo", provider: "alibaba", role: "fast-briefing", cost_per_1m: 0 },
-  { id: "qwen-plus", provider: "alibaba", role: "implementation", cost_per_1m: 0 },
-  { id: "qwen-max", provider: "alibaba", role: "architecture", cost_per_1m: 0 },
+  { id: "google/gemini-2.0-flash-001", provider: "openrouter", role: "primary", cost_per_1m: 0.1 },
 ];
 
 // ── MCP Server ─────────────────────────────────────────────────────────────
@@ -86,7 +84,7 @@ server.registerTool(
   {
     description: "List available LLM models in the EGOS llm-router registry.",
     inputSchema: {
-      provider: z.enum(["anthropic", "openai", "google", "alibaba", "all"]).optional(),
+      provider: z.enum(["anthropic", "openai", "google", "openrouter", "all"]).optional(),
     } as any,
   },
   (async ({ provider = "all" }: { provider?: string }) => {
diff --git a/packages/pii-purge/README.md b/packages/pii-purge/README.md
index 22466b3b..d8f56c3a 100644
--- a/packages/pii-purge/README.md
+++ b/packages/pii-purge/README.md
@@ -1,8 +1,8 @@
 # @egos/pii-purge
 
-**v0.1.0** | Status: MVP ativo
+**v0.2.0** | Status: ativo (endurecido)
 
-Motor de purge de PII conhecida em diretórios — encontra e substitui entidades sensíveis (CPF/telefone/placa/nome/REDS) antes de publicação pública. Parte do gate `R-SEC-005` (publish gate).
+Motor de purge de PII conhecida em diretórios — encontra e substitui entidades sensíveis (CPF/telefone/placa/nome/REDS) antes de publicação pública. Capacidade **system-wide do EGOS**: serve para limpar QUALQUER sistema/repo, não só o intelink. Parte do gate `R-SEC-005` (publish gate). Registro: `CAPABILITY_REGISTRY §114`.
 
 ---
 
@@ -51,8 +51,17 @@ bun packages/pii-purge/src/cli.ts \
   --entity-dict ~/.egos-purge-entities.json \
   --target ~/intelink-clean \
   --json
+
+# VERIFY-ONLY (publish gate): só verifica, NÃO purga. Exit 1 se achar qualquer
+# entidade conhecida. Use em pre-commit / antes de push/deploy (R-SEC-005).
+bun packages/pii-purge/src/cli.ts \
+  --entity-dict ~/.egos-purge-entities.json \
+  --target ~/intelink-clean \
+  --verify-only
 ```
 
+> **Regra:** o `--entity-dict` deve viver **FORA** do `--target` (o motor exclui o próprio dict do scan, mas mantê-lo fora evita confusão e mantém o dado real fora do repo).
+
 ---
 
 ## Formato do dicionário
@@ -96,6 +105,12 @@ cd packages/pii-purge && bun run typecheck
 - Audit log hash-chained: cada registro inclui `sha256Before` + `sha256After` + `prevHash`
 - Dicionário real deve estar em path gitignored (`~/.egos-purge-entities.json` ou equivalente)
 - Exit 1 se restar qualquer `REVIEW_REQUIRED` — bloqueia publicação até resolução humana
+- **Safety-net literal (VERIFY-001):** o `verify`/`--verify-only` também faz busca literal de cada valor cru do dict — independente da tipagem do campo. Um valor de texto posto num campo numérico (`reds`) **não escapa** silenciosamente.
+- **Sem corrupção por sobreposição (BUG-001):** padrões que casam o mesmo span (ex.: `JIZ-6956` e `JIZ6956`) são deduplicados (longest-wins) antes da substituição — nunca geram `[PESSOA_1]_1]`.
+
+## Lições de campo (2026-06-07)
+
+> O `verifyCleanExit` do motor **não substitui** uma varredura independente. Na 1ª aplicação real (intelink-platform), o verify reportou "clean" mas um valor mal-tipado escapou. Por isso o safety-net literal foi adicionado. **Sempre faça o sweep independente** (tokens + corrupção + genérico) antes de publicar.
 
 ---
 
diff --git a/packages/pii-purge/package.json b/packages/pii-purge/package.json
index 13b49de3..5f1be670 100644
--- a/packages/pii-purge/package.json
+++ b/packages/pii-purge/package.json
@@ -1,6 +1,6 @@
 {
   "name": "@egos/pii-purge",
-  "version": "0.1.0",
+  "version": "0.2.0",
   "description": "Motor de purge de PII conhecida em diretórios — EntityDictionary, pattern variants, audit hash-chained",
   "type": "module",
   "private": true,
diff --git a/packages/pii-purge/src/cli.ts b/packages/pii-purge/src/cli.ts
index 66d2597f..035eab55 100644
--- a/packages/pii-purge/src/cli.ts
+++ b/packages/pii-purge/src/cli.ts
@@ -17,7 +17,7 @@
 
 import { loadDictionary } from './dictionary.js';
 import { generateAllPatterns } from './patterns.js';
-import { scanDirectory } from './scanner.js';
+import { scanDirectory, scanDirectoryLiteral, flattenEntityValues } from './scanner.js';
 import { buildTokenMap, runPurge } from './purge.js';
 import { verify } from './verify.js';
 import { resolve, dirname } from 'node:path';
@@ -30,6 +30,7 @@ function parseArgs(argv: string[]): {
   target: string;
   apply: boolean;
   json: boolean;
+  verifyOnly: boolean;
 } {
   const args: Record<string, string | boolean> = {};
   for (let i = 0; i < argv.length; i++) {
@@ -37,6 +38,7 @@ function parseArgs(argv: string[]): {
     if (arg === '--apply') { args['apply'] = true; }
     else if (arg === '--dry-run') { args['dry-run'] = true; }
     else if (arg === '--json') { args['json'] = true; }
+    else if (arg === '--verify-only') { args['verify-only'] = true; }
     else if (arg.startsWith('--')) {
       const key = arg.slice(2);
       args[key] = argv[i + 1] ?? true;
@@ -61,6 +63,7 @@ function parseArgs(argv: string[]): {
     target: resolve(target),
     apply: args['apply'] === true,
     json: args['json'] === true,
+    verifyOnly: args['verify-only'] === true,
   };
 }
 
@@ -80,11 +83,37 @@ async function main(): Promise<void> {
     console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
   }
 
-  // 2. Generate patterns
+  // 2. Generate patterns + flatten raw values (literal safety net — VERIFY-001)
   const patterns = generateAllPatterns(dict.entities);
+  const literalValues = flattenEntityValues(dict.entities);
+
+  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.
+  // Wire this into pre-commit / publish paths (R-SEC-005) to block on known entities.
+  if (opts.verifyOnly) {
+    const patternHits = (await scanDirectory(opts.target, patterns, opts.entityDict)).filter(f => f.matchType !== 'fuzzy-REVIEW');
+    const literalHits = await scanDirectoryLiteral(opts.target, literalValues, opts.entityDict);
+    const total = patternHits.length + literalHits.length;
+    if (opts.json) {
+      console.log(JSON.stringify({
+        mode: 'verify-only',
+        clean: total === 0,
+        findings: [...patternHits, ...literalHits].map(f => ({
+          file: f.file, line: f.line, entityId: f.entityId, type: f.type, matchType: f.matchType,
+        })),
+      }, null, 2));
+    } else if (total === 0) {
+      console.log('[pii-purge] VERIFY-ONLY: clean — zero known-entity findings');
+    } else {
+      console.error(`[pii-purge] VERIFY-ONLY FAILED: ${total} known-entity finding(s) remain`);
+      for (const f of [...patternHits, ...literalHits]) {
+        console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}`);
+      }
+    }
+    process.exit(total === 0 ? 0 : 1);
+  }
 
   // 3. Scan
-  const findings = await scanDirectory(opts.target, patterns);
+  const findings = await scanDirectory(opts.target, patterns, opts.entityDict);
 
   const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
   const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
@@ -126,7 +155,7 @@ async function main(): Promise<void> {
   // 6. Verify (only in apply mode — meaningful post-write)
   let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
   if (mode === 'apply') {
-    verifyResult = await verify(opts.target, patterns);
+    verifyResult = await verify(opts.target, patterns, literalValues, opts.entityDict);
     if (!opts.json) {
       if (verifyResult.cleanExit) {
         console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
diff --git a/packages/pii-purge/src/patterns.ts b/packages/pii-purge/src/patterns.ts
index 420dac38..772f8cfb 100644
--- a/packages/pii-purge/src/patterns.ts
+++ b/packages/pii-purge/src/patterns.ts
@@ -16,7 +16,7 @@ import type { Entity } from './dictionary.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
-export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW';
+export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW' | 'literal-LEFTOVER';
 export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';
 
 export interface EntityPattern {
diff --git a/packages/pii-purge/src/pii-purge.test.ts b/packages/pii-purge/src/pii-purge.test.ts
index ddd3e6c9..c2756872 100644
--- a/packages/pii-purge/src/pii-purge.test.ts
+++ b/packages/pii-purge/src/pii-purge.test.ts
@@ -14,7 +14,7 @@ import { tmpdir } from 'node:os';
 
 import { validateDictionary, type EntityDictionary } from './dictionary.js';
 import { generateAllPatterns, normalizeOrtho } from './patterns.js';
-import { scanText, scanDirectory } from './scanner.js';
+import { scanText, scanDirectory, scanLiteralValues, flattenEntityValues } from './scanner.js';
 import { buildTokenMap, applyReplacements, runPurge } from './purge.js';
 import { verify } from './verify.js';
 
@@ -458,3 +458,39 @@ describe('applyReplacements', () => {
     expect(appliedCount).toBe(0);
   });
 });
+
+describe('BUG-001 — overlapping spans do not corrupt output', () => {
+  test('duplicate plate variants produce a single clean token (no [PESSOA_N]_ corruption)', () => {
+    // Both "TST-1234" and "TST1234" generate the same regex \bTST[-]?1234\b → match same span
+    const dict: EntityDictionary = { entities: [{ id: 'ent-x', plates: ['TST-1234', 'TST1234'] }] };
+    const patterns = generateAllPatterns(dict.entities);
+    const text = 'Veiculo placa TST1234 localizado';
+    const findings = scanText(text, 'x.txt', patterns).filter(f => f.matchType !== 'fuzzy-REVIEW');
+    expect(findings.length).toBeGreaterThan(1); // two patterns hit the same span (the bug trigger)
+
+    const tokenMap = buildTokenMap(dict.entities);
+    const { result, appliedCount } = applyReplacements(text, findings, tokenMap);
+    expect(result).toBe('Veiculo placa [PESSOA_1] localizado');
+    expect(result).not.toMatch(/\[PESSOA_\d+\]_/); // no corruption like [PESSOA_1]_1]
+    expect(appliedCount).toBe(1); // overlaps deduped → exactly one replacement
+  });
+});
+
+describe('VERIFY-001 — literal scan catches a mis-typed dict field', () => {
+  test('text value placed in numeric `reds` field escapes patterns but is caught literally', () => {
+    const dict: EntityDictionary = { entities: [{ id: 'ent-g', reds: ['grupo alfa secreto'] }] };
+    const text = 'contato no grupo alfa secreto hoje';
+
+    // Pattern scan MISSES it (text in a numeric field generates no working pattern)
+    const patterns = generateAllPatterns(dict.entities);
+    expect(scanText(text, 'x.txt', patterns).length).toBe(0);
+
+    // Literal safety net CATCHES it
+    const literals = flattenEntityValues(dict.entities);
+    const litHits = scanLiteralValues(text, 'x.txt', literals);
+    expect(litHits.length).toBe(1);
+    expect(litHits[0]!.matchType).toBe('literal-LEFTOVER');
+    // and the finding NEVER carries the raw value (T0 §3)
+    expect(JSON.stringify(litHits[0])).not.toContain('grupo alfa secreto');
+  });
+});
diff --git a/packages/pii-purge/src/purge.ts b/packages/pii-purge/src/purge.ts
index 83e8fb0c..88f445aa 100644
--- a/packages/pii-purge/src/purge.ts
+++ b/packages/pii-purge/src/purge.ts
@@ -109,12 +109,29 @@ export function applyReplacements(
     token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   }));
 
-  // Sort end-to-start (line desc, offset desc)
+  // BUG-001 fix: remove OVERLAPPING spans before replacing.
+  // Two patterns (a plate written with and without its dash) can match the same span; // scan-ok: format note
+  // applying both corrupts the output ([PESSOA_1]_1]). Keep longest-wins, drop overlaps.
+  // Sort start-to-end (line asc, offset asc, length desc) then greedily keep non-overlapping.
   spans.sort((a, b) =>
-    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
+    a.lineIdx - b.lineIdx || a.lineOffset - b.lineOffset || b.matchLength - a.matchLength,
   );
+  const kept: Span[] = [];
+  const lastEndByLine = new Map<number, number>();
+  for (const s of spans) {
+    const lastEnd = lastEndByLine.get(s.lineIdx) ?? -1;
+    if (s.lineOffset >= lastEnd) {
+      kept.push(s);
+      lastEndByLine.set(s.lineIdx, s.lineOffset + s.matchLength);
+    }
+    // else: overlaps an already-kept span on this line → drop (avoids corruption)
+  }
 
-  for (const span of spans) {
+  // Apply kept spans end-to-start (line desc, offset desc) so earlier offsets stay valid
+  kept.sort((a, b) =>
+    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
+  );
+  for (const span of kept) {
     const line = lines[span.lineIdx];
     if (line === undefined) continue;
     lines[span.lineIdx] =
@@ -123,7 +140,7 @@ export function applyReplacements(
       line.slice(span.lineOffset + span.matchLength);
   }
 
-  return { result: lines.join('\n'), appliedCount: applicable.length };
+  return { result: lines.join('\n'), appliedCount: kept.length };
 }
 
 // ─── Main purge function ──────────────────────────────────────────────────────
diff --git a/packages/pii-purge/src/scanner.ts b/packages/pii-purge/src/scanner.ts
index 018c1e98..3bd2aa47 100644
--- a/packages/pii-purge/src/scanner.ts
+++ b/packages/pii-purge/src/scanner.ts
@@ -12,6 +12,7 @@ import { readdir, readFile, stat } from 'node:fs/promises';
 import { join, extname } from 'node:path';
 import { execSync } from 'node:child_process';
 import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
+import type { Entity } from './dictionary.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -121,6 +122,28 @@ export function scanText(
   return findings;
 }
 
+/**
+ * Resolve the list of readable text files under `targetDir`, preferring git-tracked.
+ * Yields { path, text } for each, skipping binaries and files >2MB.
+ */
+async function readScannableFiles(targetDir: string): Promise<Array<{ path: string; text: string }>> {
+  const allFiles = await collectFiles(targetDir);
+  const gitTracked = getGitTrackedFiles(targetDir);
+  const filesToScan = gitTracked ? allFiles.filter(f => gitTracked.has(f)) : allFiles;
+
+  const out: Array<{ path: string; text: string }> = [];
+  for (const path of filesToScan) {
+    const s = await stat(path);
+    if (s.size > 2 * 1024 * 1024) continue; // skip very large files
+    try {
+      out.push({ path, text: await readFile(path, 'utf-8') });
+    } catch {
+      // Binary or unreadable — skip
+    }
+  }
+  return out;
+}
+
 /**
  * Walk a target directory and scan all eligible files.
  * Returns a deduplicated, stable list of findings.
@@ -131,33 +154,88 @@ export function scanText(
 export async function scanDirectory(
   targetDir: string,
   patterns: EntityPattern[],
+  excludeFile?: string,
 ): Promise<Finding[]> {
-  const allFiles = await collectFiles(targetDir);
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanText(text, path, patterns));
+  }
+  return allFindings;
+}
 
-  // Filter to git-tracked files when possible
-  const gitTracked = getGitTrackedFiles(targetDir);
-  const filesToScan = gitTracked
-    ? allFiles.filter(f => gitTracked.has(f))
-    : allFiles;
+// ─── Literal-value safety net (VERIFY-001) ─────────────────────────────────────
+// The pattern generator's output depends on the dict FIELD TYPE (a text value put
+// in a numeric `reds` field generates no working pattern → escapes silently).
+// This literal scan searches for each raw dict value case-insensitively, independent
+// of field typing — the catch-all that makes a mis-typed dict field non-fatal.
 
-  const allFindings: Finding[] = [];
+export interface LiteralValue {
+  raw: string;
+  entityId: string;
+  type: EntityFieldType;
+}
 
-  for (const filePath of filesToScan) {
-    const s = await stat(filePath);
-    // Skip very large files (>2MB) to avoid memory spikes
-    if (s.size > 2 * 1024 * 1024) continue;
+/** Flatten every raw identifier value from the entity dictionary. */
+export function flattenEntityValues(entities: Entity[]): LiteralValue[] {
+  const out: LiteralValue[] = [];
+  for (const e of entities) {
+    for (const v of e.cpfs ?? []) out.push({ raw: v, entityId: e.id, type: 'cpf' });
+    for (const v of e.phones ?? []) out.push({ raw: v, entityId: e.id, type: 'phone' });
+    for (const v of e.plates ?? []) out.push({ raw: v, entityId: e.id, type: 'plate' });
+    for (const v of e.names ?? []) out.push({ raw: v, entityId: e.id, type: 'name' });
+    for (const v of e.reds ?? []) out.push({ raw: v, entityId: e.id, type: 'reds' });
+  }
+  return out;
+}
 
-    let text: string;
-    try {
-      text = await readFile(filePath, 'utf-8');
-    } catch {
-      // Binary or unreadable — skip
-      continue;
+/**
+ * Case-insensitive literal substring search for raw dict values.
+ * NEVER includes the matched value in a Finding (T0 §3).
+ */
+export function scanLiteralValues(
+  text: string,
+  filePath: string,
+  values: LiteralValue[],
+): Finding[] {
+  const findings: Finding[] = [];
+  const lines = text.split('\n');
+  for (const v of values) {
+    const needle = (v.raw ?? '').toLowerCase();
+    if (needle.length < 3) continue; // avoid trivial/noisy short matches
+    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
+      const hay = lines[lineIdx]!.toLowerCase();
+      let from = 0;
+      let idx: number;
+      while ((idx = hay.indexOf(needle, from)) !== -1) {
+        findings.push({
+          file: filePath,
+          line: lineIdx + 1,
+          entityId: v.entityId,
+          type: v.type,
+          matchType: 'literal-LEFTOVER',
+          lineOffset: idx,
+          matchLength: v.raw.length,
+        });
+        from = idx + needle.length;
+      }
     }
-
-    const findings = scanText(text, filePath, patterns);
-    allFindings.push(...findings);
   }
+  return findings;
+}
 
+/** Walk a directory and literal-scan all eligible files for raw dict values. */
+export async function scanDirectoryLiteral(
+  targetDir: string,
+  values: LiteralValue[],
+  excludeFile?: string,
+): Promise<Finding[]> {
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanLiteralValues(text, path, values));
+  }
   return allFindings;
 }
diff --git a/packages/pii-purge/src/verify.ts b/packages/pii-purge/src/verify.ts
index 62fe8075..abcf5745 100644
--- a/packages/pii-purge/src/verify.ts
+++ b/packages/pii-purge/src/verify.ts
@@ -7,13 +7,13 @@
  */
 
 import type { EntityPattern } from './patterns.js';
-import type { Finding } from './scanner.js';
-import { scanDirectory } from './scanner.js';
+import type { Finding, LiteralValue } from './scanner.js';
+import { scanDirectory, scanDirectoryLiteral } from './scanner.js';
 
 export interface VerifyResult {
-  /** True only when zero auto-purgeable findings remain */
+  /** True only when zero auto-purgeable AND zero literal-leftover findings remain */
   cleanExit: boolean;
-  /** Remaining auto-purgeable findings (should be empty on success) */
+  /** Remaining auto-purgeable findings (pattern + literal-leftover; should be empty on success) */
   remaining: Finding[];
   /** Remaining fuzzy-REVIEW findings (human review required) */
   reviewRequired: Finding[];
@@ -21,18 +21,30 @@ export interface VerifyResult {
 
 /**
  * Re-scan the target directory after purge.
+ * Runs BOTH the pattern scan AND a literal-value scan (VERIFY-001 safety net) —
+ * the literal scan catches values that escaped because of a mis-typed dict field.
  *
- * @param targetDir  - directory that was purged
- * @param patterns   - same patterns used for original scan
+ * @param targetDir       - directory that was purged
+ * @param patterns        - same patterns used for original scan
+ * @param literalValues   - raw dict values (from flattenEntityValues) for the safety net
  */
 export async function verify(
   targetDir: string,
   patterns: EntityPattern[],
+  literalValues: LiteralValue[] = [],
+  excludeFile?: string,
 ): Promise<VerifyResult> {
-  const findings = await scanDirectory(targetDir, patterns);
+  const patternFindings = await scanDirectory(targetDir, patterns, excludeFile);
+  const literalFindings = literalValues.length
+    ? await scanDirectoryLiteral(targetDir, literalValues, excludeFile)
+    : [];
 
-  const remaining = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
-  const reviewRequired = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  const reviewRequired = patternFindings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  // "remaining" = anything that must block: non-fuzzy pattern hits + any literal leftover
+  const remaining = [
+    ...patternFindings.filter(f => f.matchType !== 'fuzzy-REVIEW'),
+    ...literalFindings,
+  ];
 
   return {
     cleanExit: remaining.length === 0,
diff --git a/packages/shared/src/__tests__/llm-provider.test.ts b/packages/shared/src/__tests__/llm-provider.test.ts
index d63c064d..a0aada64 100644
--- a/packages/shared/src/__tests__/llm-provider.test.ts
+++ b/packages/shared/src/__tests__/llm-provider.test.ts
@@ -6,13 +6,11 @@
  * Run: bun test packages/shared/src/__tests__/llm-provider.test.ts
  */
 import { describe, it, expect, beforeEach, afterEach } from 'bun:test';
-import { ALIBABA_MODELS } from '../llm-provider';
 
 // Save and restore env
 const savedEnv: Record<string, string | undefined> = {};
 
 beforeEach(() => {
-  savedEnv.ALIBABA_DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY;
   savedEnv.OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
   savedEnv.LLM_PROVIDER = process.env.LLM_PROVIDER;
 });
@@ -24,84 +22,50 @@ afterEach(() => {
   }
 });
 
-// ═══════════════════════════════════════════════════════════
-// Model catalog
-// ═══════════════════════════════════════════════════════════
-describe('LLM Provider — Model catalog', () => {
-  it('exports Alibaba test models', () => {
-    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
-    expect(ALIBABA_MODELS).toContain('qwen-plus');
-    expect(ALIBABA_MODELS).toContain('qwen-flash');
-  });
-
-  it('includes coder model', () => {
-    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
-  });
-});
-
 // ═══════════════════════════════════════════════════════════
 // Provider detection — throws when no API key
 // ═══════════════════════════════════════════════════════════
 describe('LLM Provider — API key validation', () => {
-  it('throws when ALIBABA key missing and alibaba provider requested', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
+  it('throws when OPENROUTER key missing and openrouter provider requested', async () => {
     delete process.env.OPENROUTER_API_KEY;
 
-    // Dynamic import to get fresh module state
     const { chatWithLLM } = await import('../llm-provider');
     try {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'qwen-plus',
-        provider: 'alibaba',
+        model: 'google/gemini-2.0-flash-001',
+        provider: 'openrouter',
       });
       expect(true).toBe(false); // should not reach
     } catch (e: unknown) {
-      expect((e as Error).message).toContain('ALIBABA_DASHSCOPE_API_KEY');
+      expect((e as Error).message).toContain('OPENROUTER_API_KEY');
     }
   });
 
-  it('throws when OPENROUTER key missing and openrouter provider requested', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-    delete process.env.OPENROUTER_API_KEY;
+  it('throws when GOOGLE key missing and google provider requested', async () => {
+    delete process.env.GOOGLE_AI_STUDIO_API_KEY;
 
     const { chatWithLLM } = await import('../llm-provider');
     try {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'google/gemini-2.0-flash-001',
-        provider: 'openrouter',
+        model: 'gemini-2.5-flash',
+        provider: 'google',
       });
       expect(true).toBe(false);
     } catch (e: unknown) {
-      expect((e as Error).message).toContain('OPENROUTER_API_KEY');
+      expect((e as Error).message).toContain('GOOGLE_AI_STUDIO_API_KEY');
     }
   });
 });
 
 // ═══════════════════════════════════════════════════════════
-// Provider auto-detection — qwen prefix → alibaba
+// Provider auto-detection
 // ═══════════════════════════════════════════════════════════
 describe('LLM Provider — Auto-detection', () => {
-  it('detects alibaba from qwen model prefix', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-    const { chatWithLLM } = await import('../llm-provider');
-    try {
-      await chatWithLLM({
-        systemPrompt: 'test',
-        userPrompt: 'test',
-        model: 'qwen-plus',
-      });
-    } catch (e: unknown) {
-      // Should throw about ALIBABA key, proving alibaba was detected
-      expect((e as Error).message).toContain('ALIBABA_DASHSCOPE_API_KEY');
-    }
-  });
-
-  it('falls back to openrouter for non-qwen models', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
+  it('falls back to openrouter for non-gemini models', async () => {
     delete process.env.OPENROUTER_API_KEY;
     delete process.env.LLM_PROVIDER;
     const { chatWithLLM } = await import('../llm-provider');
@@ -109,7 +73,7 @@ describe('LLM Provider — Auto-detection', () => {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'google/gemini-2.0-flash',
+        model: 'google/gemini-2.0-flash-001',
       });
     } catch (e: unknown) {
       // Should throw about OPENROUTER key
diff --git a/packages/shared/src/__tests__/model-router.test.ts b/packages/shared/src/__tests__/model-router.test.ts
index a7cffa2d..dc129a5b 100644
--- a/packages/shared/src/__tests__/model-router.test.ts
+++ b/packages/shared/src/__tests__/model-router.test.ts
@@ -11,18 +11,10 @@ import { resolveModel, routeForChat, listAvailableModels, MODEL_CATALOG } from '
 const savedEnv: Record<string, string | undefined> = {};
 
 beforeEach(() => {
-  // Save current env
-  savedEnv.ALIBABA_DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY;
   savedEnv.OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
 });
 
 afterEach(() => {
-  // Restore env
-  if (savedEnv.ALIBABA_DASHSCOPE_API_KEY !== undefined) {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = savedEnv.ALIBABA_DASHSCOPE_API_KEY;
-  } else {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-  }
   if (savedEnv.OPENROUTER_API_KEY !== undefined) {
     process.env.OPENROUTER_API_KEY = savedEnv.OPENROUTER_API_KEY;
   } else {
@@ -34,8 +26,8 @@ afterEach(() => {
 // Catalog integrity
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Catalog', () => {
-  it('has at least 5 models in catalog', () => {
-    expect(MODEL_CATALOG.length).toBeGreaterThanOrEqual(5);
+  it('has at least 3 models in catalog', () => {
+    expect(MODEL_CATALOG.length).toBeGreaterThanOrEqual(3);
   });
 
   it('every model has required fields', () => {
@@ -59,6 +51,11 @@ describe('Model Router — Catalog', () => {
     const premium = MODEL_CATALOG.filter(m => m.tier === 'premium');
     expect(premium.length).toBeGreaterThan(0);
   });
+
+  it('no model uses alibaba provider', () => {
+    const alibaba = MODEL_CATALOG.filter(m => m.provider === 'alibaba');
+    expect(alibaba.length).toBe(0);
+  });
 });
 
 // ═══════════════════════════════════════════════════════════
@@ -66,33 +63,30 @@ describe('Model Router — Catalog', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Routing', () => {
   it('routes fast_check to economy model', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'fast_check', cost: 'economy' });
     expect(route.profile.tier).toBe('economy');
   });
 
   it('routes orchestration with premium preference to premium model', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'orchestration', cost: 'premium' });
     expect(route.profile.tier).toBe('premium');
   });
 
-  it('prefers alibaba provider when specified', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+  it('prefers openrouter provider when specified', () => {
     process.env.OPENROUTER_API_KEY = 'test-key';
-    const route = resolveModel({ task: 'chat', preferProvider: 'alibaba' });
-    expect(route.provider).toBe('alibaba');
+    const route = resolveModel({ task: 'chat', preferProvider: 'openrouter' });
+    expect(route.provider).toBe('openrouter');
   });
 
   it('throws when no provider available', () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
     delete process.env.OPENROUTER_API_KEY;
     expect(() => resolveModel('chat')).toThrow('No LLM provider available');
   });
 
   it('accepts string shorthand for task', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel('summarization');
     expect(route.model).toBeTruthy();
     expect(route.provider).toBeTruthy();
@@ -104,7 +98,6 @@ describe('Model Router — Routing', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Context filtering', () => {
   it('filters by minContext requirement', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'analysis', minContext: 200000 });
     expect(route.profile.maxContext).toBeGreaterThanOrEqual(200000);
@@ -116,7 +109,7 @@ describe('Model Router — Context filtering', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — routeForChat', () => {
   it('returns model and provider only', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const result = routeForChat('chat');
     expect(result).toHaveProperty('model');
     expect(result).toHaveProperty('provider');
@@ -128,30 +121,13 @@ describe('Model Router — routeForChat', () => {
 // Cheap-first policy (EGOS-071)
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Cheap-first policy', () => {
-  it('defaults to balanced tier (default cost preference)', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
-    // Default cost preference is 'balanced' (economy requires explicit opt-in)
-    const route = resolveModel('chat');
-    expect(route.profile.tier).toBe('balanced');
-  });
-
-  it('routes fast_check to free qwen-flash by default', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
-    const route = resolveModel('fast_check');
-    expect(route.model).toBe('qwen-flash');
-    expect(route.profile.costPer1MInput).toBe(0);
-  });
-
   it('breaks ties by lower cost', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
-    // summarization has multiple economy options - should pick cheapest
     const route = resolveModel('summarization');
     expect(route.profile.costPer1MInput).toBeLessThanOrEqual(0.1);
   });
 
   it('can override to premium when needed', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'orchestration', cost: 'premium' });
     expect(route.profile.tier).toBe('premium');
@@ -162,13 +138,17 @@ describe('Model Router — Cheap-first policy', () => {
 // listAvailableModels
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — listAvailableModels', () => {
-  it('marks models as available when env key is set', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+  it('marks openrouter models as available when key is set', () => {
+    process.env.OPENROUTER_API_KEY = 'test-key';
+    const models = listAvailableModels();
+    const openrouter = models.filter(m => m.provider === 'openrouter');
+    for (const m of openrouter) expect(m.available).toBe(true);
+  });
+
+  it('marks openrouter models as unavailable when key is missing', () => {
     delete process.env.OPENROUTER_API_KEY;
     const models = listAvailableModels();
-    const alibaba = models.filter(m => m.provider === 'alibaba');
     const openrouter = models.filter(m => m.provider === 'openrouter');
-    for (const m of alibaba) expect(m.available).toBe(true);
     for (const m of openrouter) expect(m.available).toBe(false);
   });
 });
diff --git a/packages/shared/src/index.ts b/packages/shared/src/index.ts
index 8e2ad0ea..23b5fd62 100644
--- a/packages/shared/src/index.ts
+++ b/packages/shared/src/index.ts
@@ -5,7 +5,7 @@
  * Domain-specific utilities (OSINT, social, etc.) live in leaf repos.
  */
 
-export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
+export { chatWithLLM, chatWithLLM as analyzeWithAI } from './llm-provider';
 export type { SharedLLMProvider } from './llm-provider';
 export { resolveModel, routeForChat, listAvailableModels, MODEL_CATALOG } from './model-router';
 export type { TaskType, CostPreference, RouteOptions, ResolvedRoute, ModelProfile } from './model-router';
diff --git a/packages/shared/src/llm-orchestrator.ts b/packages/shared/src/llm-orchestrator.ts
index 1ee63df0..cf99a5fc 100644
--- a/packages/shared/src/llm-orchestrator.ts
+++ b/packages/shared/src/llm-orchestrator.ts
@@ -1,12 +1,12 @@
 /**
  * LLM Orchestrator — Multi-Model Economic Routing
- * 
+ *
  * Orquestra chamadas LLM priorizando modelos mais baratos quando possível.
- * Usa qwen-plus apenas para tasks complexas que justificam o custo.
+ * Usa OpenRouter para todas as chamadas (free tier quando disponível).
  */
 
 export type TaskComplexity = 'simple' | 'moderate' | 'complex';
-export type LLMProvider = 'alibaba' | 'openrouter' | 'openai';
+export type LLMProvider = 'openrouter' | 'openai';
 
 export interface ModelConfig {
   provider: LLMProvider;
@@ -17,22 +17,22 @@ export interface ModelConfig {
 }
 
 export const MODEL_REGISTRY: Record<string, ModelConfig> = {
-  // Alibaba DashScope
+  // OpenRouter (Qwen via OpenRouter)
   'qwen-turbo': {
-    provider: 'alibaba',
-    model: 'qwen-turbo',
-    costPer1kTokens: 0.002, // ~$0.002/1k tokens (estimado)
+    provider: 'openrouter',
+    model: 'qwen/qwen3-coder:free',
+    costPer1kTokens: 0.0,
     maxTokens: 8000,
     bestFor: ['simple'],
   },
   'qwen-plus': {
-    provider: 'alibaba',
-    model: 'qwen-plus',
-    costPer1kTokens: 0.008, // ~$0.008/1k tokens (estimado)
+    provider: 'openrouter',
+    model: 'openai/gpt-oss-120b:free',
+    costPer1kTokens: 0.0,
     maxTokens: 32000,
     bestFor: ['moderate', 'complex'],
   },
-  
+
   // OpenRouter (via Gemini)
   'gemini-flash': {
     provider: 'openrouter',
diff --git a/packages/shared/src/llm-provider.ts b/packages/shared/src/llm-provider.ts
index eb9f869f..b6179a36 100644
--- a/packages/shared/src/llm-provider.ts
+++ b/packages/shared/src/llm-provider.ts
@@ -1,39 +1,23 @@
 import type { AIAnalysisResult } from './types';
 
-export type SharedLLMProvider = 'openrouter' | 'alibaba' | 'google';
+export type SharedLLMProvider = 'openrouter' | 'google';
 
 // ── Architecture ────────────────────────────────────────────────────────────
 // ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
-//   → Unlimited rate limit on all 3 models
 //   → This session IS the primary orchestrator, not routed through here
 //
 // BACKGROUND AGENTS (VPS): Use this fallback chain
-//   Priority: Google AI Studio → Alibaba DashScope → OpenRouter
+//   Priority: Google AI Studio (free) → OpenRouter (gemini-2.0-flash-001)
 //
 // Google AI Studio (PRIORITY 1 — Completely Free, No Expiry):
 //   Models: gemma-4-31b-it (1,500 req/day), gemini-2.5-flash (500 req/day)
 //   Key: GOOGLE_AI_STUDIO_API_KEY | Base: generativelanguage.googleapis.com
-//   WARNING: gemma-4-31b is excellent for reasoning/coding but weak on tool-calling
 //
-// Alibaba DashScope (PRIORITY 2 — Free One-Time Grant):
-//   Models: qwen-flash, qwen-plus, qwen-max, qwq-plus (reasoning)
-//   ONE-TIME 1M token grant per model (90-day validity)
-//   Rate limits: 30K RPM (fast), 15K RPM (default), 600 RPM (deep)
-//
-// OpenRouter (PRIORITY 3 — Paid Fallback):
-//   qwen3.6-plus:free → $0/token, unlimited rate (primary free option here)
-//   Hermes-3, Gemini Flash, Llama 4 — only when others exhausted
-//   NO Claude models — orchestrator handles Claude via Claude Code plan
-
-export const ALIBABA_MODELS = [
-  'qwen-max',
-  'qwen-plus',
-  'qwen-flash',
-  'qwen3-coder-plus',
-  'qwen3.5-plus',
-  'qwen-turbo',
-  'qwq-plus',
-] as const;
+// OpenRouter (PRIORITY 2 — Paid, low cost):
+//   PRIMARY: google/gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
+//   Fallback: gemini-2.5-pro, llama-4-maverick
+//   Key: OPENROUTER_API_KEY
+//   NOTE: Alibaba DashScope REMOVED — free grant period expired ($500 used)
 
 // ── Fallback Chain ─────────────────────────────────────────────────────────
 
@@ -54,39 +38,15 @@ const GOOGLE_CHAIN: ModelEntry[] = [
   { provider: 'google', model: 'gemini-2.5-pro',   tier: 'deep' },
 ];
 
-// Tier 1: Alibaba (FREE one-time grant — exhaust before OpenRouter)
-const ALIBABA_CHAIN: ModelEntry[] = [
-  // Fast tier — 30K RPM, 10M TPM (free 1M tokens)
-  { provider: 'alibaba', model: 'qwen3.5-flash',   tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen-flash',       tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen-turbo',       tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen3-coder-plus', tier: 'fast' },
-
-  // Default tier — 15K RPM, 5M TPM
-  { provider: 'alibaba', model: 'qwen-plus',    tier: 'default' },
-  { provider: 'alibaba', model: 'qwen3.5-plus', tier: 'default' },
-
-  // Deep tier — 600 RPM, 1M TPM (reasoning/planning)
-  { provider: 'alibaba', model: 'qwen-max',  tier: 'deep' },
-  { provider: 'alibaba', model: 'qwq-plus',  tier: 'deep' },
-];
-
-// Tier 2: OpenRouter — free model first, then cheap paid
+// Tier 1: OpenRouter — gemini-2.0-flash-001 as primary paid model
 const OPENROUTER_CHAIN: ModelEntry[] = [
-  // FREE — Qwen 3.6 Plus (prompt=0, completion=0, no rate limit published)
-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'fast' },
-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'default' },
+  // Fast tier — Gemini 2.0 Flash (~$0.10/1M in, $0.40/1M out)
+  { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'fast' },
 
-  // MiniMax M2.5 — benchmark winner Apr 2026: 7.1/10, 67% tool accuracy, $0.36/mo
-  { provider: 'openrouter', model: 'minimax/minimax-m2.5', tier: 'default' },
-
-  // Gemini Flash (essentially free)
+  // Default tier — Gemini 2.0 Flash (best cost/quality for PT-BR tasks)
   { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'default' },
 
-  // Hermes-3 for BRAID/structured output (BRAID mechanical executor)
-  { provider: 'openrouter', model: 'nousresearch/hermes-3-llama-3.1-70b', tier: 'default' },
-
-  // Deep tier — High capability, low cost (no Claude)
+  // Deep tier — Gemini 2.5 Pro (strongest reasoning)
   { provider: 'openrouter', model: 'google/gemini-2.5-pro',       tier: 'deep' },
   { provider: 'openrouter', model: 'meta-llama/llama-4-maverick', tier: 'deep' },
 ];
@@ -124,10 +84,7 @@ async function callModel(
   let baseUrl: string;
   let apiKey: string | undefined;
 
-  if (provider === 'alibaba') {
-    baseUrl = `${(process.env.ALIBABA_DASHSCOPE_BASE_URL || 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1').replace(/\/+$/, '')}/chat/completions`;
-    apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
-  } else if (provider === 'google') {
+  if (provider === 'google') {
     // Google AI Studio: OpenAI-compatible endpoint
     baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
     apiKey = process.env.GOOGLE_AI_STUDIO_API_KEY;
@@ -137,7 +94,7 @@ async function callModel(
   }
 
   if (!apiKey) {
-    const keyName = provider === 'alibaba' ? 'ALIBABA_DASHSCOPE_API_KEY' : provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
+    const keyName = provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
     throw new Error(`SKIP: ${keyName} not set`);
   }
 
@@ -210,8 +167,7 @@ export async function chatWithLLM(params: {
   if (params.model) {
     const explicitProvider: SharedLLMProvider =
       params.provider ??
-      (params.model.startsWith('qwen') && !params.model.includes(':') ? 'alibaba'
-        : params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
+      (params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
         : 'openrouter');
     return callModel(
       { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
@@ -219,7 +175,7 @@ export async function chatWithLLM(params: {
     );
   }
 
-  // Build chain: Google (free/daily limit) → Alibaba (free grant) → OpenRouter (paid fallback)
+  // Build chain: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
   const tier = params.tier ?? 'default';
 
   const googleModels = GOOGLE_CHAIN.filter((e: ModelEntry) =>
@@ -228,22 +184,14 @@ export async function chatWithLLM(params: {
     : e.tier !== 'deep'
   );
 
-  let alibabaModels: ModelEntry[];
-  let openrouterModels: ModelEntry[];
-
-  if (tier === 'fast') {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
-  } else if (tier === 'deep') {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
-  } else {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
-  }
+  const openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) =>
+    tier === 'fast' ? e.tier === 'fast'
+    : tier === 'deep' ? true
+    : e.tier !== 'deep'
+  );
 
-  // Chain order: Google (free) → Alibaba (free grant) → OpenRouter
-  let chain: ModelEntry[] = [...googleModels, ...alibabaModels, ...openrouterModels];
+  // Chain order: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
+  let chain: ModelEntry[] = [...googleModels, ...openrouterModels];
 
   // If a provider is forced, prioritize it at front of chain
   if (params.provider) {
diff --git a/packages/shared/src/llm-providers/llm-router.ts b/packages/shared/src/llm-providers/llm-router.ts
index b5ea15ac..d398bc9b 100644
--- a/packages/shared/src/llm-providers/llm-router.ts
+++ b/packages/shared/src/llm-providers/llm-router.ts
@@ -1,44 +1,31 @@
 /**
  * EGOS LLM Router v2.1 (ex-hermes.ts — renomeado 2026-05-06)
- * Roteador LLM com fallback chain de 5 tiers: Alibaba → OpenRouter free → Gemini → Sonnet → Haiku.
+ * Roteador LLM com fallback chain de 4 tiers: OpenRouter free → Gemini → Sonnet → Haiku.
  * NÃO confundir com Hermes (NousResearch) — são coisas distintas.
  * Bridges EGOS TypeScript codebase with multi-provider LLM routing.
  *
  * Provider Chain (Priority Order):
- *   Phase 1: Alibaba ModelStudio (free quota - all models)
- *     1. qwen3-max (best for complex tasks)
- *     2. qwen3.5-plus (balanced performance)
- *     3. qwen3.6-plus (1M context, latest)
- *     4. qwen-plus (stable)
- *     5. qwen3-coder-plus (coding agent)
- *     6. qwen3.5-flash (fast)
- *     7. qwen-flash (cost-effective)
- *     8. qwen-turbo (qwen3 series)
- *     9. qwq-plus (reasoning)
- *   Phase 2: OpenRouter FREE (when Alibaba quota exhausted)
- *     10. qwen/qwen3.6-plus:free
- *     11. google/gemma-4-26b-a4b-it:free
- *     12. qwen/qwen3-coder:free
- *     13. meta-llama/llama-4-maverick:free
- *   Phase 3: OpenRouter PAID (after 5 consecutive failures)
- *     14. google/gemini-2.0-flash-001 (~$0.10/1M tokens)
- *   Phase 4: Claude (Anthropic direct API — last resort, rate-limited 20 calls/day)
- *     15. claude-haiku-4-5-20251001 (fastest, cheapest)
+ *   Phase 1: OpenRouter FREE
+ *     1. openai/gpt-oss-120b:free
+ *     2. qwen/qwen3-coder:free
+ *     3. meta-llama/llama-3.3-70b-instruct:free
+ *     4. minimax/minimax-m2.5:free
+ *   Phase 2: OpenRouter PAID (after free failures)
+ *     5. google/gemini-2.0-flash-001 (~$0.10/1M tokens)
+ *   Phase 3: Claude (Anthropic direct API — last resort, rate-limited 20 calls/day)
+ *     6. claude-haiku-4-5-20251001 (fastest, cheapest)
  *
  * Rate limit handling: automatic retry with next model
- * Max attempts: 5 free models → 1 paid model → 1 Claude fallback
+ * Max attempts: 4 free models → 1 paid model → 1 Claude fallback
  *
  * Migrated from Codex proxy — 2026-04-08 (CDX→HRM migration)
- * Updated with full ModelStudio chain — 2026-04-16
+ * Migrated from Alibaba DashScope to OpenRouter — 2026-06-07
  */
 
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1';
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? '';
 const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? '';
 
 // Model chain ordered by capability (best first)
-const ALIBABA_MODELS = [
+export const ALIBABA_MODELS = [
   'qwen3-max',           // Best for complex tasks, most capable
   'qwen3.5-plus',        // Balanced performance, speed, cost
   'qwen3.6-plus',        // Native multimodal, 1M context
@@ -91,7 +78,7 @@ export interface HermesOptions {
 }
 
 interface ModelAttempt {
-  provider: 'alibaba' | 'openrouter-free' | 'openrouter-paid' | 'claude';
+  provider: 'openrouter-free' | 'openrouter-paid' | 'claude';
   model: string;
   attempt: number;
 }
@@ -122,23 +109,18 @@ function buildModelChain(options: HermesOptions): ModelAttempt[] {
   const chain: ModelAttempt[] = [];
   let attemptNum = 1;
 
-  // Phase 1: Alibaba ModelStudio models
-  for (const model of ALIBABA_MODELS) {
-    chain.push({ provider: 'alibaba', model, attempt: attemptNum++ });
-  }
-
-  // Phase 2: OpenRouter FREE models
+  // Phase 1: OpenRouter FREE models
   for (const model of OPENROUTER_FREE_MODELS) {
     chain.push({ provider: 'openrouter-free', model, attempt: attemptNum++ });
   }
 
-  // Phase 3: OpenRouter PAID model
+  // Phase 2: OpenRouter PAID model
   const allowPaid = options.allowPaidFallback !== false;
   if (allowPaid) {
     chain.push({ provider: 'openrouter-paid', model: OPENROUTER_PAID_MODEL, attempt: attemptNum++ });
   }
 
-  // Phase 4: Claude direct API (last resort — rate-limited 20 calls/day)
+  // Phase 3: Claude direct API (last resort — rate-limited 20 calls/day)
   if (CLAUDE_API_KEY) {
     chain.push({ provider: 'claude', model: CLAUDE_FALLBACK_MODEL, attempt: attemptNum++ });
   }
@@ -147,8 +129,7 @@ function buildModelChain(options: HermesOptions): ModelAttempt[] {
 }
 
 /**
- * Call Alibaba ModelStudio with full fallback chain to OpenRouter.
- * Tries all Alibaba models first, then OpenRouter free, then OpenRouter paid.
+ * Call LLM with full fallback chain: OpenRouter free → OpenRouter paid → Claude.
  * Auto-retries on rate limit, quota exhaustion, or network errors.
  */
 export async function callHermes(
@@ -168,9 +149,7 @@ export async function callHermes(
     try {
       let result: { content: string; provider: string; model: string } | null = null;
 
-      if (attempt.provider === 'alibaba' && DASHSCOPE_KEY) {
-        result = await callAlibaba(attempt.model, messages, maxTokens, timeoutMs);
-      } else if ((attempt.provider === 'openrouter-free' || attempt.provider === 'openrouter-paid') && OPENROUTER_KEY) {
+      if ((attempt.provider === 'openrouter-free' || attempt.provider === 'openrouter-paid') && OPENROUTER_KEY) {
         result = await callOpenRouter(attempt.model, messages, maxTokens, timeoutMs, attempt.provider === 'openrouter-paid');
       } else if (attempt.provider === 'claude' && CLAUDE_API_KEY) {
         if (claudeBreakerOpen()) {
@@ -213,39 +192,6 @@ export async function callHermes(
   throw new Error(`Hermes: All models exhausted after ${chain.length} attempts. Errors:\n${errors.join('\n')}`);
 }
 
-/** Call Alibaba DashScope API */
-async function callAlibaba(
-  model: string,
-  messages: HermesMessage[],
-  maxTokens: number,
-  timeoutMs: number
-): Promise<{ content: string; provider: string; model: string } | null> {
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
-    method: 'POST',
-    headers: {
-      'Authorization': `Bearer ${DASHSCOPE_KEY}`,
-      'Content-Type': 'application/json',
-    },
-    body: JSON.stringify({ model, messages, max_tokens: maxTokens }),
-    signal: AbortSignal.timeout(timeoutMs),
-  });
-
-  const body = await res.text();
-
-  if (!res.ok) {
-    const err: any = new Error(`Alibaba ${model}: HTTP ${res.status} - ${body.slice(0, 200)}`);
-    err.status = res.status;
-    err.body = body;
-    throw err;
-  }
-
-  const data = JSON.parse(body);
-  const content = data?.choices?.[0]?.message?.content ?? '';
-  if (!content) return null;
-
-  return { content, provider: 'alibaba-dashscope', model };
-}
-
 /** Call OpenRouter API */
 async function callOpenRouter(
   model: string,
@@ -407,7 +353,7 @@ if (import.meta.main) {
   console.log(`\n✅ Chain built: ${chain.length} models`);
 
   // Test with a simple prompt if env vars are set
-  if (DASHSCOPE_KEY || OPENROUTER_KEY) {
+  if (OPENROUTER_KEY) {
     console.log('\n🚀 Testing with sample prompt...');
     try {
       const result = await callHermes('Say "Hermes v2.0 is working" and list the provider you are.', {
@@ -423,7 +369,7 @@ if (import.meta.main) {
       process.exit(1);
     }
   } else {
-    console.log('\n⚠️  No API keys set (ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY)');
+    console.log('\n⚠️  No API keys set (OPENROUTER_API_KEY or ANTHROPIC_API_KEY)');
     console.log('    Set keys to run live test.');
   }
 }
diff --git a/packages/shared/src/mcp-clients/llm-router-mcp-client.ts b/packages/shared/src/mcp-clients/llm-router-mcp-client.ts
index 886a6bcf..d6cd7c25 100644
--- a/packages/shared/src/mcp-clients/llm-router-mcp-client.ts
+++ b/packages/shared/src/mcp-clients/llm-router-mcp-client.ts
@@ -2,7 +2,7 @@
  * LLM Router MCP Client
  *
  * Multi-provider LLM orchestration with cost tracking and intelligent model selection
- * Supports: Alibaba Qwen, OpenRouter (Claude, Llama, etc.)
+ * Supports: OpenRouter (Claude, Llama, Qwen, Gemini, etc.)
  *
  * Responsibilities:
  * - Estimate token usage and costs
@@ -69,9 +69,9 @@ export class LLMRouterMCPClient {
     // Initialize default models
     const defaultModels: ModelConfig[] = [
       {
-        provider: 'alibaba',
-        model: 'qwen-plus',
-        costPer1mTokens: 0.0005,
+        provider: 'openrouter',
+        model: 'qwen/qwen3-coder:free',
+        costPer1mTokens: 0.0,
         tier: 'fast-cheap',
       },
       {
@@ -104,7 +104,7 @@ export class LLMRouterMCPClient {
    * Estimate token usage and cost for a prompt
    */
   estimateCost(prompt: string, model?: string): CostEstimate {
-    const selectedModel = model || 'alibaba/qwen-plus';
+    const selectedModel = model || 'qwen/qwen3-coder:free';
     const config = this.models.get(selectedModel);
 
     if (!config) {
diff --git a/packages/shared/src/metrics-tracker.ts b/packages/shared/src/metrics-tracker.ts
index 4e6519b3..f825e8fb 100644
--- a/packages/shared/src/metrics-tracker.ts
+++ b/packages/shared/src/metrics-tracker.ts
@@ -8,7 +8,7 @@
  */
 
 export interface ToolUsageMetric {
-  tool: 'hermes' | 'alibaba' | 'claude_code' | 'openrouter' | 'dashscope' | 'gemini' | 'cascade' | 'other';
+  tool: 'hermes' | 'claude_code' | 'openrouter' | 'gemini' | 'cascade' | 'other';
   operation: string;
   timestamp: string;
   durationMs?: number;
diff --git a/packages/shared/src/model-router.ts b/packages/shared/src/model-router.ts
index 97b713d2..03d10e9a 100644
--- a/packages/shared/src/model-router.ts
+++ b/packages/shared/src/model-router.ts
@@ -49,51 +49,6 @@ export interface ModelProfile {
 }
 
 export const MODEL_CATALOG: ModelProfile[] = [
-  // ── Alibaba / DashScope ──
-  {
-    id: 'qwen-max',
-    provider: 'alibaba',
-    displayName: 'Qwen Max',
-    costPer1MInput: 1.6,
-    costPer1MOutput: 6.4,
-    maxContext: 32768,
-    strengths: ['orchestration', 'analysis', 'code_review'],
-    tier: 'premium',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen-plus',
-    provider: 'alibaba',
-    displayName: 'Qwen Plus',
-    costPer1MInput: 0.8,
-    costPer1MOutput: 2.0,
-    maxContext: 131072,
-    strengths: ['orchestration', 'code_generation', 'analysis', 'chat', 'extraction'],
-    tier: 'balanced',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen3-coder-plus',
-    provider: 'alibaba',
-    displayName: 'Qwen3 Coder Plus',
-    costPer1MInput: 0.8,
-    costPer1MOutput: 2.0,
-    maxContext: 131072,
-    strengths: ['code_generation', 'code_review'],
-    tier: 'balanced',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen-flash',
-    provider: 'alibaba',
-    displayName: 'Qwen Flash',
-    costPer1MInput: 0.0,
-    costPer1MOutput: 0.0,
-    maxContext: 131072,
-    strengths: ['fast_check', 'classification', 'summarization', 'translation', 'chat'],
-    tier: 'economy',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
   // ── OpenRouter ──
   {
     id: 'google/gemini-2.0-flash-001',
@@ -260,7 +215,7 @@ export function resolveModel(taskOrOpts: TaskType | RouteOptions): ResolvedRoute
 
   if (candidates.length === 0) {
     throw new Error(
-      `No LLM provider available. Set ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY in .env`
+      `No LLM provider available. Set OPENROUTER_API_KEY in .env`
     );
   }
 
diff --git a/scripts/activation-check.ts b/scripts/activation-check.ts
index cd070efc..fe772866 100644
--- a/scripts/activation-check.ts
+++ b/scripts/activation-check.ts
@@ -73,7 +73,6 @@ const REQUIRED_FILES = [
 // ═══════════════════════════════════════════════════════════
 
 const REQUIRED_ENV = [
-  'ALIBABA_DASHSCOPE_API_KEY',
   'OPENROUTER_API_KEY',
 ];
 
diff --git a/scripts/ai-commit-security.ts b/scripts/ai-commit-security.ts
index f742ea50..62965cd8 100644
--- a/scripts/ai-commit-security.ts
+++ b/scripts/ai-commit-security.ts
@@ -2,7 +2,7 @@
 /**
  * ai-commit-security.ts — AI-SECURITY-001
  *
- * Inline pre-commit security check via LLM (qwen-turbo, <500ms target).
+ * Inline pre-commit security check via LLM (gemini-2.0-flash-001, <500ms target).
  * Scans STAGED DIFF ONLY for security patterns EGOS static tools miss:
  *   - SQL injection in raw queries
  *   - Auth bypass (missing auth checks in new routes)
diff --git a/scripts/ai-coverage-scan.ts b/scripts/ai-coverage-scan.ts
index bfc37d2e..4d0fda07 100644
--- a/scripts/ai-coverage-scan.ts
+++ b/scripts/ai-coverage-scan.ts
@@ -30,12 +30,12 @@ const AI_PATTERNS = [
   "anthropic\\.messages",
   "gemini\\.generateContent",
   "fetch.*openrouter",
-  "fetch.*dashscope",
+  "fetch.*openrouter",
   "fetch.*openai",
   "createMessage",
   "chat\\.completions\\.create",
   "openrouter\\.ai/api",
-  "dashscope-intl\\.aliyuncs\\.com",
+  "openrouter\\.ai/api",
   "googleapis.*generativelanguage",
 ];
 
diff --git a/scripts/bench-providers.ts b/scripts/bench-providers.ts
index 5b29bca6..65174509 100644
--- a/scripts/bench-providers.ts
+++ b/scripts/bench-providers.ts
@@ -12,7 +12,7 @@ const CONFIG = {
   version: "1.0.0",
   timestamp: new Date().toISOString(),
   providers: [
-    { name: "Alibaba DashScope", model: "qwen-plus", baseUrl: "https://dashscope-intl.aliyuncs.com" },
+    { name: "OpenRouter Gemini Flash", model: "google/gemini-2.0-flash-001", baseUrl: "https://openrouter.ai" },
     { name: "OpenRouter Gemini", model: "google/gemini-2.0-flash", baseUrl: "https://openrouter.ai" },
     { name: "OpenRouter Claude", model: "anthropic/claude-3.5-sonnet", baseUrl: "https://openrouter.ai" },
   ],
diff --git a/scripts/context-manager.ts b/scripts/context-manager.ts
index cb02a311..8316338e 100755
--- a/scripts/context-manager.ts
+++ b/scripts/context-manager.ts
@@ -124,8 +124,8 @@ class ContextManager {
     const llmConfig: { primary?: string; fallback?: string } = {};
     try {
       const envContent = await fs.readFile(path.join(cwd, '.env'), 'utf-8');
-      if (envContent.includes('ALIBABA_DASHSCOPE_API_KEY')) llmConfig.primary = 'Alibaba Qwen';
-      if (envContent.includes('OPENROUTER_API_KEY')) llmConfig.fallback = 'OpenRouter';
+      if (envContent.includes('OPENROUTER_API_KEY')) llmConfig.primary = 'OpenRouter';
+      if (envContent.includes('GOOGLE_AI_STUDIO_API_KEY')) llmConfig.fallback = 'Google AI Studio';
     } catch (e) {
       // .env não encontrado
     }
diff --git a/scripts/debrief/pipeline.ts b/scripts/debrief/pipeline.ts
index bee23271..8f2f1472 100644
--- a/scripts/debrief/pipeline.ts
+++ b/scripts/debrief/pipeline.ts
@@ -6,7 +6,7 @@
  * 5-layer pipeline for processing client discovery meetings:
  *   L1: Groq Whisper   — audio → raw transcript
  *   L2: Gemini Flash   — contextual correction (legal/technical terms)
- *   L3: Qwen-plus      — structured JSON extraction (DPIO scoring, gaps, insights)
+ *   L3: OpenRouter gemini-2.0-flash-001 — structured JSON extraction (DPIO scoring, gaps, insights)
  *   L4: EGOS KB cross  — cross-reference with existing knowledge + gap detection
  *   L5: Persistence    — write to consulting/clientes/[slug]/ + Supabase
  *
@@ -34,9 +34,7 @@ const MANUAL_TEXT = process.argv.find(a => a.startsWith("--text="))?.slice(7)
 
 const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
 const GEMINI_KEY = process.env.GOOGLE_AI_STUDIO_API_KEY ?? "";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
 
@@ -173,14 +171,14 @@ ${rawTranscript}` }] }],
   return data.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? rawTranscript;
 }
 
-// ─── L3: Qwen-plus structured JSON extraction ─────────────────────────────────
+// ─── L3: OpenRouter gemini-2.0-flash-001 — structured JSON extraction ─────────
 
 async function layer3Extract(transcript: string): Promise<DebriefInsights> {
-  if (!DASHSCOPE_KEY) {
-    console.log("  L3 Qwen: SKIP (no key) — using defaults");
+  if (!OPENROUTER_KEY) {
+    console.log("  L3 OpenRouter: SKIP (no key) — using defaults");
     return defaultInsights();
   }
-  console.log("  L3 Qwen-plus: extracting structured insights...");
+  console.log("  L3 OpenRouter gemini-2.0-flash-001: extracting structured insights...");
 
   const schema = `{
   "sector": "advocacia|contabilidade|agronomia|saude|policia|geral",
@@ -202,14 +200,16 @@ async function layer3Extract(transcript: string): Promise<DebriefInsights> {
   "confidence": <0.0-1.0: quão confiante está nessa extração>
 }`;
 
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
     method: "POST",
     headers: {
-      Authorization: `Bearer ${DASHSCOPE_KEY}`,
+      Authorization: `Bearer ${OPENROUTER_KEY}`,
       "Content-Type": "application/json",
+      "HTTP-Referer": "https://egos.dev",
+      "X-Title": "egos",
     },
     body: JSON.stringify({
-      model: "qwen-plus",
+      model: "google/gemini-2.0-flash-001",
       messages: [
         {
           role: "system",
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index 4bb91330..07feb407 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -124,7 +124,7 @@ const results: CheckResult[] = [];
 
 // ─── 1. Environment Variables ───
 function checkEnvironmentVariables() {
-  const required = ['ALIBABA_DASHSCOPE_API_KEY', 'OPENROUTER_API_KEY'];
+  const required = ['OPENROUTER_API_KEY'];
   const optional = [
     'OPENAI_API_KEY',
     'GROQ_API_KEY',
@@ -189,7 +189,6 @@ function checkFileFreshness() {
 // ─── 3. Provider Readiness ───
 async function checkProviderReadiness() {
   const providers = [
-    { name: 'Alibaba DashScope', url: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/models', envKey: 'ALIBABA_DASHSCOPE_API_KEY' },
     { name: 'OpenRouter', url: 'https://openrouter.ai/api/v1/models', envKey: 'OPENROUTER_API_KEY' },
     { name: 'OpenAI', url: 'https://api.openai.com/v1/models', envKey: 'OPENAI_API_KEY', optional: true },
   ];
diff --git a/scripts/gem-hunter-digest.ts b/scripts/gem-hunter-digest.ts
index 03093517..77222b52 100644
--- a/scripts/gem-hunter-digest.ts
+++ b/scripts/gem-hunter-digest.ts
@@ -31,10 +31,6 @@ const DAYS_BACK = parseInt(
 
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE_URL =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN ?? "";
 const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID ?? "";
@@ -125,47 +121,23 @@ Description: ${gem.description.slice(0, 300)}
 
 Write a single sentence (max 120 chars) explaining WHY this repo matters to developers building AI agents or data-compliance tools. Be concrete, not hype. Answer in English.`;
 
-  const body = JSON.stringify({
-    model: "qwen-plus",
-    messages: [{ role: "user", content: prompt }],
-    max_tokens: 100,
-    temperature: 0.4,
-  });
-
-  // Primary: DashScope
-  if (DASHSCOPE_API_KEY) {
-    try {
-      const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-        method: "POST",
-        headers: {
-          "Content-Type": "application/json",
-          Authorization: `Bearer ${DASHSCOPE_API_KEY}`,
-        },
-        body,
-        signal: AbortSignal.timeout(10000),
-      });
-      if (res.ok) {
-        const data = (await res.json()) as {
-          choices?: { message?: { content?: string } }[];
-        };
-        const text = data.choices?.[0]?.message?.content?.trim() ?? "";
-        if (text) return { text: text.slice(0, 200), provider: "alibaba/qwen-plus" };
-      }
-    } catch {
-      // fall through to OpenRouter
-    }
-  }
-
-  // Fallback: OpenRouter free
+  // Primary: OpenRouter
   if (OPENROUTER_API_KEY) {
     try {
       const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
         method: "POST",
         headers: {
           "Content-Type": "application/json",
-          Authorization: `Bearer ${OPENROUTER_API_KEY}`,
+          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
+          "HTTP-Referer": "https://egos.dev",
+          "X-Title": "egos",
         },
-        body: JSON.stringify({ ...JSON.parse(body), model: "google/gemma-4-26b-a4b-it:free" }),
+        body: JSON.stringify({
+          model: "google/gemini-2.0-flash-001",
+          messages: [{ role: "user", content: prompt }],
+          max_tokens: 100,
+          temperature: 0.4,
+        }),
         signal: AbortSignal.timeout(15000),
       });
       if (res.ok) {
@@ -173,7 +145,7 @@ Write a single sentence (max 120 chars) explaining WHY this repo matters to deve
           choices?: { message?: { content?: string } }[];
         };
         const text = data.choices?.[0]?.message?.content?.trim() ?? "";
-        if (text) return { text: text.slice(0, 200), provider: "openrouter/gemma-4-26b" };
+        if (text) return { text: text.slice(0, 200), provider: "openrouter/gemini-2.0-flash-001" };
       }
     } catch {
       // no LLM available
diff --git a/scripts/kbs/seed-egos-advocacia.ts b/scripts/kbs/seed-egos-advocacia.ts
index ff47b905..bdd69ada 100644
--- a/scripts/kbs/seed-egos-advocacia.ts
+++ b/scripts/kbs/seed-egos-advocacia.ts
@@ -18,8 +18,7 @@ const COUNT = Number(process.argv.find(a => a.startsWith('--count='))?.split('='
 const TENANT = 'egos-advocacia-demo';
 const SUPABASE_URL = process.env.SUPABASE_URL ?? '';
 const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? '';
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? '';
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1';
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? '';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
diff --git a/scripts/manifest-generator.ts b/scripts/manifest-generator.ts
index efcef679..1a4b3f4c 100644
--- a/scripts/manifest-generator.ts
+++ b/scripts/manifest-generator.ts
@@ -3,7 +3,7 @@
  * manifest-generator.ts — DRIFT-011
  *
  * Auto-generates or updates .egos-manifest.yaml from a repo's README.md
- * using LLM extraction (Gemini Flash → Alibaba Qwen → regex fallback).
+ * using LLM extraction (OpenRouter gemini-2.0-flash-001 → Gemini Flash → regex fallback).
  *
  * Extracts quantitative claims like:
  *   - "83.7M nodes" → claim: neo4j_nodes
@@ -39,7 +39,7 @@ const GEMINI_KEY =
   process.env.GEMINI_API_KEY ||
   ""; // hardcoded key removed (SEC) — set GOOGLE_AI_STUDIO_API_KEY or GEMINI_API_KEY
 
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -222,29 +222,31 @@ Return [] if no quantitative claims found. JSON array only, no markdown.`;
   }
 }
 
-// ─── LLM extraction via Alibaba ───────────────────────────────────────────────
+// ─── LLM extraction via OpenRouter ───────────────────────────────────────────
 
-async function llmExtractAlibaba(
+async function llmExtractOpenRouter(
   repoName: string,
   readmeContent: string
 ): Promise<ExtractedClaim[]> {
-  if (!DASHSCOPE_KEY) return [];
+  if (!OPENROUTER_KEY) return [];
 
   const prompt = `Extract quantitative claims from README. JSON array: [{"id":"snake_id","description":"...","value":"numeric_string","unit":"...","raw":"..."}]
 README: ${readmeContent.slice(0, 1000)}`;
 
   try {
     const controller = new AbortController();
-    const timeout = setTimeout(() => controller.abort(), 8000);
+    const timeout = setTimeout(() => controller.abort(), 15000);
 
-    const resp = await fetch("https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions", {
+    const resp = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
       headers: {
-        "Authorization": `Bearer ${DASHSCOPE_KEY}`,
+        "Authorization": `Bearer ${OPENROUTER_KEY}`,
         "Content-Type": "application/json",
+        "HTTP-Referer": "https://egos.dev",
+        "X-Title": "egos",
       },
       body: JSON.stringify({
-        model: "qwen-turbo",
+        model: "google/gemini-2.0-flash-001",
         messages: [{ role: "user", content: prompt }],
         max_tokens: 800,
         temperature: 0,
@@ -350,12 +352,12 @@ async function processRepo(repoDir: string, dry: boolean): Promise<void> {
   console.log(`\n── ${repoName}`);
 
   // Try LLM first, fall back to regex
-  let claims = await llmExtractGemini(repoName, content);
-  let method = "gemini";
+  let claims = await llmExtractOpenRouter(repoName, content);
+  let method = "openrouter";
 
   if (claims.length === 0) {
-    claims = await llmExtractAlibaba(repoName, content);
-    method = "alibaba";
+    claims = await llmExtractGemini(repoName, content);
+    method = "gemini";
   }
 
   if (claims.length === 0) {
@@ -394,7 +396,7 @@ const repos = all
   : [process.cwd()];
 
 console.log(`\n🧠 Manifest Generator${dry ? " (dry)" : ""} — ${repos.length} repo(s)`);
-console.log(`   Strategy: Gemini Flash → Alibaba Qwen → regex`);
+console.log(`   Strategy: OpenRouter gemini-2.0-flash-001 → Gemini Flash → regex`);
 
 for (const repo of repos) {
   await processRepo(repo, dry);
diff --git a/scripts/review_models.ts b/scripts/review_models.ts
index b341142b..d8fea748 100644
--- a/scripts/review_models.ts
+++ b/scripts/review_models.ts
@@ -5,12 +5,12 @@ import { chatWithLLM } from '../packages/shared/src/llm-provider';
 async function runReview() {
   const content = fs.readFileSync(path.join(process.cwd(), 'docs/strategy/MULTI_MODEL_PLANNING.md'), 'utf-8');
   
-  console.log('Sending to Alibaba (Qwen)...');
+  console.log('Sending to OpenRouter (Gemini)...');
   const alibabaResponse = await chatWithLLM({
-    systemPrompt: "Você é o Alibaba Qwen, o cérebro principal focado em execução bruta e análise fria. Revise criticamente o plano proposto, aponte inconsistências operacionais ou de custo, e defina se a estratégia de pivotar o framework inteiro para focar no ATRiAN e PII-BR é sólida.",
+    systemPrompt: "Você é o revisor executivo do EGOS. Revise criticamente o plano proposto, aponte inconsistências operacionais ou de custo, e defina se a estratégia proposta é sólida.",
     userPrompt: `Revise este documento:\n\n${content}`,
-    provider: 'alibaba',
-    model: 'qwen-plus',
+    provider: 'openrouter',
+    model: 'google/gemini-2.0-flash-001',
     maxTokens: 2000
   });
 
@@ -24,9 +24,9 @@ async function runReview() {
   });
 
   const appendData = `
-## Fase 3: Validação do Conselho (Alibaba & Codex)
+## Fase 3: Validação do Conselho (OpenRouter Gemini & Codex)
 
-### Parecer do Alibaba (Qwen-Plus) - Execução e Viabilidade
+### Parecer Executivo (OpenRouter/gemini-2.0-flash-001) - Execução e Viabilidade
 ${alibabaResponse.content}
 
 ### Parecer do Codex (OpenRouter/Reviewer) - Segurança e Arquitetura
diff --git a/scripts/ssot-router.ts b/scripts/ssot-router.ts
index b18d7bc2..039ebc97 100644
--- a/scripts/ssot-router.ts
+++ b/scripts/ssot-router.ts
@@ -3,7 +3,7 @@
  * ssot-router.ts — Pre-commit SSOT Gate
  *
  * Checks if a newly created .md file belongs to an existing SSOT domain.
- * Uses LLM (Gemini Flash → Alibaba Qwen → local keyword matching) with fallback.
+ * Uses LLM (Gemini Flash via OpenRouter → local keyword matching) with fallback.
  *
  * Triggered by .husky/pre-commit when new .md files are staged.
  *
@@ -48,7 +48,7 @@ interface RouterResult {
   domain?: string;
   ssot?: string;
   reason: string;
-  method: "keyword" | "llm-gemini" | "llm-alibaba" | "skip";
+  method: "keyword" | "llm-gemini" | "llm-openrouter" | "skip";
 }
 
 // ─── Load SSOT map ─────────────────────────────────────────────────────────────
@@ -216,14 +216,14 @@ Rules:
   }
 }
 
-// ─── LLM routing via Alibaba DashScope ────────────────────────────────────────
+// ─── LLM routing via OpenRouter ───────────────────────────────────────────────
 
-async function llmRouteAlibaba(
+async function llmRouteOpenRouter(
   filePath: string,
   content: string,
   ssotMap: SsotMap
 ): Promise<RouterResult | null> {
-  const apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
+  const apiKey = process.env.OPENROUTER_API_KEY;
   if (!apiKey) return null;
 
   const domainSummary = ssotMap.domains
@@ -236,14 +236,16 @@ async function llmRouteAlibaba(
     const controller = new AbortController();
     const timeout = setTimeout(() => controller.abort(), 8000);
 
-    const resp = await fetch("https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions", {
+    const resp = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
       headers: {
         "Authorization": `Bearer ${apiKey}`,
         "Content-Type": "application/json",
+        "HTTP-Referer": "https://egos.dev",
+        "X-Title": "egos",
       },
       body: JSON.stringify({
-        model: "qwen-turbo",
+        model: "google/gemini-2.0-flash-001",
         messages: [{ role: "user", content: prompt }],
         max_tokens: 100,
         temperature: 0,
@@ -264,7 +266,7 @@ async function llmRouteAlibaba(
       domain: parsed.domain ?? undefined,
       ssot: parsed.ssot ?? undefined,
       reason: parsed.reason ?? "LLM routed",
-      method: "llm-alibaba",
+      method: "llm-openrouter",
     };
   } catch {
     return null;
@@ -309,12 +311,12 @@ if (keywordResult && keywordResult.action === "block") {
   } else if (geminiResult && geminiResult.action === "block") {
     result = { ...geminiResult, method: "llm-gemini" };
   } else {
-    // Gemini unavailable — try Alibaba
-    const alibabaResult = await llmRouteAlibaba(filePath, content, ssotMap);
-    if (alibabaResult && alibabaResult.action === "ok") {
-      result = { action: "ok", reason: "Alibaba LLM overrode keyword match", method: "llm-alibaba" };
-    } else if (alibabaResult && alibabaResult.action === "block") {
-      result = { ...alibabaResult, method: "llm-alibaba" };
+    // Gemini unavailable — try OpenRouter
+    const openrouterResult = await llmRouteOpenRouter(filePath, content, ssotMap);
+    if (openrouterResult && openrouterResult.action === "ok") {
+      result = { action: "ok", reason: "OpenRouter LLM overrode keyword match", method: "llm-openrouter" };
+    } else if (openrouterResult && openrouterResult.action === "block") {
+      result = { ...openrouterResult, method: "llm-openrouter" };
     } else {
       // All LLMs unavailable — fall back to keyword with warn-only
       result = { ...keywordResult, action: warnOnly ? "warn" : "block" };
diff --git a/scripts/start-audit.ts b/scripts/start-audit.ts
index bc9c0e58..f5b77895 100644
--- a/scripts/start-audit.ts
+++ b/scripts/start-audit.ts
@@ -58,7 +58,7 @@ async function inspect(repo: RepoConfig): Promise<RepoState> {
 }
 async function aiSummary(states: RepoState[]) {
   const userPrompt = JSON.stringify(states.map(({ name, modified, untracked, ahead, behind, missingDocs, modifiedFiles, handoff, health }) => ({ name, modified, untracked, ahead, behind, missingDocs, modifiedFiles, handoff, health })), null, 2)
-  const result = await chatWithLLM({ provider: 'alibaba', model: 'qwen-plus', temperature: 0.2, maxTokens: 900, systemPrompt: 'Você é o reconciliador de startup do EGOS. Analise o estado multi-repo e responda em markdown curto com: 1) riscos críticos, 2) drift entre local/docs/github/vps, 3) quais repos precisam commit/push, 4) próximas ações em ordem.', userPrompt })
+  const result = await chatWithLLM({ provider: 'openrouter', model: 'google/gemini-2.0-flash-001', temperature: 0.2, maxTokens: 900, systemPrompt: 'Você é o reconciliador de startup do EGOS. Analise o estado multi-repo e responda em markdown curto com: 1) riscos críticos, 2) drift entre local/docs/github/vps, 3) quais repos precisam commit/push, 4) próximas ações em ordem.', userPrompt })
   return result.content
 }
 
diff --git a/scripts/start-v6.ts b/scripts/start-v6.ts
index 93c74372..ebdbfa1a 100755
--- a/scripts/start-v6.ts
+++ b/scripts/start-v6.ts
@@ -95,7 +95,7 @@ async function diagnose() {
     requiredFiles[file] = existsSync(file);
   }
 
-  const hasApiKey = !!process.env.ALIBABA_DASHSCOPE_API_KEY;
+  const hasApiKey = !!process.env.OPENROUTER_API_KEY;
   const hasSupabase = !!process.env.SUPABASE_URL;
 
   const gatesPassing = Object.values(requiredFiles).every(Boolean) && typeCheckPassing;
@@ -110,7 +110,7 @@ async function diagnose() {
   const recommendations: string[] = [];
   if (blockers.length > 0) recommendations.push(`Fix ${blockers.length} blocker(s) before proceeding`);
   if (tasksDone < tasksTotal * 0.7) recommendations.push("Review P0 tasks — health below 70%");
-  if (!hasApiKey) recommendations.push("Set ALIBABA_DASHSCOPE_API_KEY");
+  if (!hasApiKey) recommendations.push("Set OPENROUTER_API_KEY");
   if (agentsDead > 0) recommendations.push(`${agentsDead} dead agents — consider cleanup`);
   recommendations.push("Run: bun run typecheck && npm test");
 
diff --git a/scripts/test-alibaba-orchestrator.ts b/scripts/test-alibaba-orchestrator.ts
deleted file mode 100644
index 71282ec4..00000000
--- a/scripts/test-alibaba-orchestrator.ts
+++ /dev/null
@@ -1,39 +0,0 @@
-#!/usr/bin/env bun
-/**
- * Test Alibaba Orchestrator — Multi-Model Economic Routing
- */
-
-import { llmOrchestrator } from '../packages/shared/src/llm-orchestrator';
-
-const testCases = [
-  { prompt: 'Olá, como vai?', expected: 'simple' },
-  { prompt: 'Explique como funciona autenticação OAuth2 com PKCE em detalhes, incluindo os passos de autorização, token exchange e refresh.', expected: 'moderate' },
-  { prompt: 'Crie um sistema completo de agendamento com:\n1. Backend em TypeScript\n2. Frontend em React\n3. Database schema\n4. API endpoints\n5. Testes unitários\n```typescript\n// exemplo\n```', expected: 'complex' },
-];
-
-console.log('🧪 Testing LLM Orchestrator\n');
-
-for (const test of testCases) {
-  const result = await llmOrchestrator.orchestrate({ prompt: test.prompt });
-  const complexity = llmOrchestrator.estimateComplexity(test.prompt);
-  
-  console.log(`Prompt: "${test.prompt.substring(0, 60)}..."`);
-  console.log(`Complexity: ${complexity} (expected: ${test.expected})`);
-  console.log(`Model: ${result.model.provider}/${result.model.model}`);
-  console.log(`Cost: $${result.estimatedCost.toFixed(4)}`);
-  console.log(`Match: ${complexity === test.expected ? '✅' : '❌'}\n`);
-}
-
-console.log('\n💰 Cost Comparison:\n');
-const complexPrompt = testCases[2].prompt;
-const models = ['gemini-flash', 'qwen-turbo', 'qwen-plus'];
-
-for (const modelKey of models) {
-  const result = await llmOrchestrator.orchestrate({ 
-    prompt: complexPrompt, 
-    forceModel: modelKey 
-  });
-  console.log(`${modelKey.padEnd(15)} → $${result.estimatedCost.toFixed(4)}`);
-}
-
-console.log('\n✅ Orchestrator configured. Use free/cheap models first, qwen-plus only when needed.');
diff --git a/scripts/token-compaction-pilot.ts b/scripts/token-compaction-pilot.ts
index 9f7dc76e..44671bc9 100644
--- a/scripts/token-compaction-pilot.ts
+++ b/scripts/token-compaction-pilot.ts
@@ -34,7 +34,7 @@ interface CompactionResult {
 
 const TOKEN_LIMITS = {
   // Grok suggested: keep window under these per model
-  'qwen-plus': 8000,
+  'google/gemini-2.0-flash-001': 12000,
   'gemini-2.0-flash': 12000,
   'minimax-m2.5': 10000,
   'claude-haiku': 16000,
@@ -119,7 +119,7 @@ function summarizeBatch(messages: ContextWindow['messages']): string {
  */
 export function compactContext(
   window: ContextWindow,
-  targetTokens: number = TOKEN_LIMITS['qwen-plus'],
+  targetTokens: number = TOKEN_LIMITS['google/gemini-2.0-flash-001'],
   mode: 'dry' | 'exec' = 'dry'
 ): CompactionResult {
   const originalTokens = Math.ceil(
diff --git a/scripts/x-opportunity-alert.ts b/scripts/x-opportunity-alert.ts
index c6dd963d..e2fb2a12 100755
--- a/scripts/x-opportunity-alert.ts
+++ b/scripts/x-opportunity-alert.ts
@@ -32,8 +32,6 @@ const EVOLUTION_API_URL = process.env.EVOLUTION_API_URL ?? "";
 const EVOLUTION_API_KEY = process.env.EVOLUTION_API_KEY ?? "";
 const WHATSAPP_INSTANCE = process.env.WHATSAPP_INSTANCE ?? "egos-alerts";
 const STATE_FILE = "/tmp/x-opportunity-state.json";
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE_URL = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? "";
 
 // ── Rate Limiting ─────────────────────────────────────────────────────────
@@ -600,7 +598,7 @@ async function searchX(query: string, maxResults: number = 10): Promise<any[]> {
   }
 }
 
-// ── LLM Analysis (DashScope qwen-plus → OpenRouter fallback) ──────────────
+// ── LLM Analysis (OpenRouter gemini-2.0-flash-001) ────────────────────────
 
 interface AIAnalysis {
   summary: string;      // 1-line pt-BR
@@ -627,43 +625,22 @@ Responda em JSON com exatamente estes campos:
   "fit_score": <0-100 fit com EGOS>
 }`;
 
-  const body = JSON.stringify({
-    model: "qwen-plus",
-    messages: [{ role: "user", content: prompt }],
-    max_tokens: 300,
-    temperature: 0.3,
-  });
-
-  // Primary: Alibaba DashScope
-  if (DASHSCOPE_API_KEY) {
-    try {
-      const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-        method: "POST",
-        headers: { "Content-Type": "application/json", Authorization: `Bearer ${DASHSCOPE_API_KEY}` },
-        body,
-        signal: AbortSignal.timeout(10000),
-      });
-      if (res.ok) {
-        const data = await res.json() as { choices?: { message?: { content?: string } }[] };
-        const content = data.choices?.[0]?.message?.content ?? "";
-        const jsonMatch = content.match(/\{[\s\S]*\}/);
-        if (jsonMatch) {
-          const parsed = JSON.parse(jsonMatch[0]) as Omit<AIAnalysis, "provider">;
-          return { ...parsed, fit_score: Math.min(100, Math.max(0, Number(parsed.fit_score) || 0)), provider: "alibaba/qwen-plus" };
-        }
-      }
-    } catch {
-      // fall through to OpenRouter
-    }
-  }
-
-  // Fallback: OpenRouter free
   if (OPENROUTER_API_KEY) {
     try {
       const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
         method: "POST",
-        headers: { "Content-Type": "application/json", Authorization: `Bearer ${OPENROUTER_API_KEY}` },
-        body: JSON.stringify({ ...JSON.parse(body), model: "google/gemma-4-26b-a4b-it:free" }),
+        headers: {
+          "Content-Type": "application/json",
+          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
+          "HTTP-Referer": "https://egos.dev",
+          "X-Title": "egos",
+        },
+        body: JSON.stringify({
+          model: "google/gemini-2.0-flash-001",
+          messages: [{ role: "user", content: prompt }],
+          max_tokens: 300,
+          temperature: 0.3,
+        }),
         signal: AbortSignal.timeout(15000),
       });
       if (res.ok) {
@@ -672,7 +649,7 @@ Responda em JSON com exatamente estes campos:
         const jsonMatch = content.match(/\{[\s\S]*\}/);
         if (jsonMatch) {
           const parsed = JSON.parse(jsonMatch[0]) as Omit<AIAnalysis, "provider">;
-          return { ...parsed, fit_score: Math.min(100, Math.max(0, Number(parsed.fit_score) || 0)), provider: "openrouter/gemma-4-26b" };
+          return { ...parsed, fit_score: Math.min(100, Math.max(0, Number(parsed.fit_score) || 0)), provider: "openrouter/gemini-2.0-flash-001" };
         }
       }
     } catch {
diff --git a/scripts/x-post-approval-bot.ts b/scripts/x-post-approval-bot.ts
index 1ce6a14c..322ba36d 100644
--- a/scripts/x-post-approval-bot.ts
+++ b/scripts/x-post-approval-bot.ts
@@ -4,7 +4,7 @@
  *
  * Flow:
  *   1. Poll Supabase x_post_queue for status='pending' posts
- *   2. Generate 3 alternatives via DashScope LLM (bold / conversational / technical)
+ *   2. Generate 3 alternatives via OpenRouter LLM (bold / conversational / technical)
  *      personalized by x_post_preferences learning data
  *   3. Send to Telegram with inline keyboard: [A] [B] [C] [✏️ Edit] [⏭️ Skip]
  *   4. User picks an option (or edits)
@@ -26,8 +26,7 @@ const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
 const TELEGRAM_TOKEN = process.env.TELEGRAM_BOT_TOKEN ?? "";
 const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID ?? "";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_URL = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const X_API_KEY = process.env.X_API_KEY ?? "";
 const X_API_SECRET = process.env.X_API_SECRET ?? "";
 const X_ACCESS_TOKEN = process.env.X_ACCESS_TOKEN ?? "";
@@ -179,14 +178,17 @@ Generate exactly 3 post alternatives with different tones. Output ONLY a JSON ob
   ].filter(Boolean).join("\n");
 
   try {
-    const res = await fetch(`${DASHSCOPE_URL}/chat/completions`, {
+    if (!OPENROUTER_KEY) throw new Error("OPENROUTER_API_KEY not set");
+    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
       headers: {
-        "Authorization": `Bearer ${DASHSCOPE_KEY}`,
+        "Authorization": `Bearer ${OPENROUTER_KEY}`,
         "Content-Type": "application/json",
+        "HTTP-Referer": "https://egos.dev",
+        "X-Title": "egos",
       },
       body: JSON.stringify({
-        model: "qwen-plus",
+        model: "google/gemini-2.0-flash-001",
         messages: [
           { role: "system", content: systemPrompt },
           { role: "user", content: userPrompt },
@@ -196,7 +198,7 @@ Generate exactly 3 post alternatives with different tones. Output ONLY a JSON ob
       }),
     });
 
-    if (!res.ok) throw new Error(`DashScope ${res.status}`);
+    if (!res.ok) throw new Error(`OpenRouter ${res.status}`);
     const data = await res.json() as { choices: Array<{ message: { content: string } }> };
     const content = data.choices[0].message.content.trim();
 
@@ -214,7 +216,7 @@ Generate exactly 3 post alternatives with different tones. Output ONLY a JSON ob
       toneA: parsed.tone_a ?? "bold",
       toneB: parsed.tone_b ?? "conversational",
       toneC: parsed.tone_c ?? "technical",
-      model: "qwen-plus",
+      model: "google/gemini-2.0-flash-001",
     };
   } catch (err) {
     console.error("[generate] LLM error:", err);
@@ -476,7 +478,7 @@ async function finalizeChoice(
     preferred_tone: tone,
     preferred_length: finalText.length,
     telegram_msg_id: msgId > 0 ? msgId : null,
-    model_used: "qwen-plus",
+    model_used: "google/gemini-2.0-flash-001",
   });
 
   // Update post queue

exec
/bin/bash -lc 'git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d -- packages/shared/src/llm-provider.ts packages/shared/src/llm-providers/llm-router.ts packages/shared/src/model-router.ts packages/chatbot-core/src/model-router.ts apps/egos-gateway/src/orchestrator.ts packages/pii-purge/src/scanner.ts packages/pii-purge/src/purge.ts packages/pii-purge/src/verify.ts packages/pii-purge/src/cli.ts apps/egos-hq/app/api/hq/actions/codex-review/route.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..deb06b9d 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -2,9 +2,9 @@
  * EGOS Gateway — AI Orchestrator v2
  *
  * Shared LLM orchestration for WhatsApp + Telegram chatbots.
- * Model: qwen-plus (Alibaba DashScope)
+ * Model: google/gemini-2.0-flash-001 (OpenRouter)
  * Transcription: Groq Whisper-large-v3-turbo
- * Vision: qwen-vl-plus
+ * Vision: google/gemini-2.0-flash-001 (multimodal)
  *
  * Tools (13):
  *   system_status, guard_status, guard_test, gem_search, gem_trending,
@@ -18,22 +18,18 @@ import { execSync } from "child_process";
 
 // ─── Config ───────────────────────────────────────────────────────────────────
 
-const DASHSCOPE_BASE =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
 const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
 const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 
 /**
  * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
  *
- * Default: gemini-2.5-flash via OpenRouter (60% mais barato que qwen-plus,
- * PT-BR nativo, tool-calling sólido).
+ * Default: gemini-2.0-flash-001 via OpenRouter (PT-BR nativo, tool-calling sólido,
+ * multimodal nativo).
  *
- * Rollback: setar CHATBOT_PRIMARY_MODEL=qwen-plus no .env do gateway.
+ * Override: setar CHATBOT_PRIMARY_MODEL no .env do gateway.
  *
- * Fallback chain: primary → fallback → qwen-plus (último recurso).
+ * Fallback chain: primary → fallback (último recurso).
  */
 interface LLMProvider {
   name: string;
@@ -43,7 +39,7 @@ interface LLMProvider {
 }
 
 const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
-const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "qwen-plus";
+const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";
 
 function getProvider(modelName: string): LLMProvider | null {
   // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
@@ -61,13 +57,12 @@ function getProvider(modelName: string): LLMProvider | null {
       model: orModel,
     };
   }
-  // Qwen via DashScope direto
-  if (modelName.startsWith("qwen-")) {
-    if (!DASHSCOPE_KEY) return null;
+  // Via OpenRouter (fallback genérico com prefixo de provider)
+  if (OPENROUTER_KEY && modelName.includes("/")) {
     return {
       name: modelName,
-      base: DASHSCOPE_BASE,
-      key: DASHSCOPE_KEY,
+      base: "https://openrouter.ai/api/v1",
+      key: OPENROUTER_KEY,
       model: modelName,
     };
   }
@@ -207,11 +202,10 @@ async function saveHistory(
 // ─── Token accounting (RATIO-ABSORB-004) ─────────────────────────────────────
 
 const MODEL_COST_PER_1K: Record<string, { input: number; output: number }> = {
-  "qwen-plus":               { input: 0.0004, output: 0.0012 },
-  "qwen-max":                { input: 0.0024, output: 0.0072 },
-  "qwen-turbo":              { input: 0.0001, output: 0.0003 },
-  "minimax/minimax-m2.5":    { input: 0.0002, output: 0.0002 },
-  "google/gemini-2.0-flash": { input: 0.0001, output: 0.0004 },
+  "google/gemini-2.0-flash-001": { input: 0.0001, output: 0.0004 },
+  "google/gemini-2.5-pro":       { input: 0.0025, output: 0.0100 },
+  "minimax/minimax-m2.5":        { input: 0.0002, output: 0.0002 },
+  "google/gemini-2.0-flash":     { input: 0.0001, output: 0.0004 },
 };
 
 function estimateCostUsd(model: string, inputTokens: number, outputTokens: number): number {
@@ -243,7 +237,6 @@ async function logTokenUsage(
 // nothing wrote here, so cost tracking was silently dead.
 function providerFromModel(model: string): string {
   const m = model.toLowerCase();
-  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
   if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3")) return "OpenAI";
   if (m.includes("gemini") || m.includes("gemma")) return "Google";
   if (m.includes("claude")) return "Anthropic";
@@ -1314,14 +1307,14 @@ export async function transcribeAudio(audioBase64: string, mime: string): Promis
 }
 
 export async function describeImage(imageBase64: string, mime: string, caption?: string): Promise<string> {
-  if (!DASHSCOPE_KEY) return "[Análise de imagem não configurada]";
+  if (!OPENROUTER_KEY) return "[Análise de imagem não configurada]";
   try {
     const dataUrl = `data:${mime};base64,${imageBase64}`;
-    const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
-      headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
+      headers: { Authorization: `Bearer ${OPENROUTER_KEY}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos" },
       body: JSON.stringify({
-        model: "qwen-vl-plus",
+        model: "google/gemini-2.0-flash-001",
         messages: [{
           role: "user",
           content: [
@@ -1547,8 +1540,8 @@ ESTILO DE RESPOSTA:
 // ─── Main orchestrator ────────────────────────────────────────────────────────
 
 export async function orchestrate(msg: IncomingMessage, client?: ClientContext): Promise<OrchestratorResponse> {
-  if (!DASHSCOPE_KEY) {
-    return { text: "❌ ALIBABA_DASHSCOPE_API_KEY não configurado." };
+  if (!OPENROUTER_KEY) {
+    return { text: "❌ OPENROUTER_API_KEY não configurado." };
   }
 
   const toolsUsed: string[] = [];
diff --git a/apps/egos-hq/app/api/hq/actions/codex-review/route.ts b/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
index 3f884837..09df7252 100644
--- a/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
+++ b/apps/egos-hq/app/api/hq/actions/codex-review/route.ts
@@ -1,58 +1,33 @@
 import { NextResponse } from 'next/server';
 
-// Triggers a constitutional review via Alibaba DashScope (qwen-plus)
-// Migrated from Codex proxy → DashScope 2026-04-08 (CDX→HRM migration)
+// Triggers a constitutional review via OpenRouter (google/gemini-2.0-flash-001)
+// Migrated: DashScope (free grant expired 2026-06) → OpenRouter 2026-06-07
 // POST /api/hq/actions/codex-review
 
-const DASHSCOPE_BASE_URL = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1';
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? '';
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? '';
 
 async function callLLM(prompt: string): Promise<string> {
-  // Primary: Alibaba DashScope qwen-plus
-  if (DASHSCOPE_API_KEY) {
-    const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-      method: 'POST',
-      headers: {
-        'Authorization': `Bearer ${DASHSCOPE_API_KEY}`,
-        'Content-Type': 'application/json',
-      },
-      body: JSON.stringify({
-        model: 'qwen-plus',
-        messages: [{ role: 'user', content: prompt }],
-        max_tokens: 512,
-      }),
-      signal: AbortSignal.timeout(30000),
-    });
-    if (res.ok) {
-      const data = await res.json();
-      return data?.choices?.[0]?.message?.content ?? '';
-    }
-  }
-
-  // Fallback: OpenRouter (Gemma 4 26B free)
-  if (OPENROUTER_API_KEY) {
-    const res = await fetch('https://openrouter.ai/api/v1/chat/completions', {
-      method: 'POST',
-      headers: {
-        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
-        'Content-Type': 'application/json',
-        'HTTP-Referer': 'https://hq.egos.ia.br',
-      },
-      body: JSON.stringify({
-        model: 'google/gemma-4-26b-a4b-it:free',
-        messages: [{ role: 'user', content: prompt }],
-        max_tokens: 512,
-      }),
-      signal: AbortSignal.timeout(30000),
-    });
-    if (res.ok) {
-      const data = await res.json();
-      return data?.choices?.[0]?.message?.content ?? '';
-    }
-  }
-
-  throw new Error('No LLM provider available');
+  if (!OPENROUTER_API_KEY) throw new Error('OPENROUTER_API_KEY not set');
+
+  const res = await fetch('https://openrouter.ai/api/v1/chat/completions', {
+    method: 'POST',
+    headers: {
+      'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
+      'Content-Type': 'application/json',
+      'HTTP-Referer': 'https://hq.egos.ia.br',
+      'X-Title': 'egos-codex-review',
+    },
+    body: JSON.stringify({
+      model: 'google/gemini-2.0-flash-001',
+      messages: [{ role: 'user', content: prompt }],
+      max_tokens: 512,
+    }),
+    signal: AbortSignal.timeout(30000),
+  });
+
+  if (!res.ok) throw new Error(`OpenRouter error: ${res.status}`);
+  const data = await res.json();
+  return data?.choices?.[0]?.message?.content ?? '';
 }
 
 export async function POST() {
@@ -62,14 +37,14 @@ export async function POST() {
 2. Check if recent commits follow conventional commit format
 3. Verify 90-day focus is maintained (Guard Brasil + Gem Hunter only)
 4. Output: one-line status per check + overall score (0-100)
-5. Sign with: REVIEWED_BY: DashScope-HQ-trigger / ${new Date().toISOString()}`;
+5. Sign with: REVIEWED_BY: OpenRouter-gemini-2.0-flash-001 / ${new Date().toISOString()}`;
 
     const content = await callLLM(reviewPrompt);
 
     return NextResponse.json({
       ok: true,
       review: content,
-      provider: DASHSCOPE_API_KEY ? 'alibaba-dashscope/qwen-plus' : 'openrouter/gemma-4-26b',
+      provider: 'openrouter/gemini-2.0-flash-001',
       triggered_at: new Date().toISOString(),
     });
   } catch (err) {
diff --git a/packages/chatbot-core/src/model-router.ts b/packages/chatbot-core/src/model-router.ts
index 9b8e605f..bda5d09f 100644
--- a/packages/chatbot-core/src/model-router.ts
+++ b/packages/chatbot-core/src/model-router.ts
@@ -14,12 +14,10 @@
 import type { ModelTier, ModelConfig } from './types.js';
 
 // ---------------------------------------------------------------------------
-// DashScope preset (ALIBABA cloud — primary for EGOS projects)
-// Docs: https://help.aliyun.com/zh/model-studio/
+// OpenRouter preset — primary for EGOS projects
+// Docs: https://openrouter.ai/docs
 // ---------------------------------------------------------------------------
 
-// INTL endpoint — international API keys (sk-ws-*) 401 on the CN host (dashscope.aliyuncs.com).
-export const DASHSCOPE_BASE_URL = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';
 export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completions';
 
 /**
@@ -28,27 +26,27 @@ export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completion
  */
 export const EGOS_DEFAULT_MODELS: ModelConfig = {
   primary: {
-    modelId: 'qwen-plus',
-    providerEnvKey: 'DASHSCOPE_API_KEY',
-    baseUrl: DASHSCOPE_BASE_URL,
-    inputCostPerMillion: 0.40,
-    outputCostPerMillion: 1.20,
+    modelId: 'openai/gpt-oss-120b:free',
+    providerEnvKey: 'OPENROUTER_API_KEY',
+    baseUrl: OPENROUTER_BASE_URL,
+    inputCostPerMillion: 0,
+    outputCostPerMillion: 0,
   },
   fallback: {
-    modelId: 'deepseek-chat-v3-0324',
-    providerEnvKey: 'DASHSCOPE_API_KEY',
-    baseUrl: DASHSCOPE_BASE_URL,
-    inputCostPerMillion: 0.20,
-    outputCostPerMillion: 0.77,
-  },
-  fast: {
-    // Emergency tier — OpenRouter hosted, no DashScope required
-    modelId: 'meta-llama/llama-4-maverick:free',
+    modelId: 'qwen/qwen3-coder:free',
     providerEnvKey: 'OPENROUTER_API_KEY',
     baseUrl: OPENROUTER_BASE_URL,
     inputCostPerMillion: 0,
     outputCostPerMillion: 0,
   },
+  fast: {
+    // Emergency tier — OpenRouter hosted
+    modelId: 'google/gemini-2.0-flash-001',
+    providerEnvKey: 'OPENROUTER_API_KEY',
+    baseUrl: OPENROUTER_BASE_URL,
+    inputCostPerMillion: 0.1,
+    outputCostPerMillion: 0.4,
+  },
 };
 
 // ---------------------------------------------------------------------------
diff --git a/packages/pii-purge/src/cli.ts b/packages/pii-purge/src/cli.ts
index 66d2597f..035eab55 100644
--- a/packages/pii-purge/src/cli.ts
+++ b/packages/pii-purge/src/cli.ts
@@ -17,7 +17,7 @@
 
 import { loadDictionary } from './dictionary.js';
 import { generateAllPatterns } from './patterns.js';
-import { scanDirectory } from './scanner.js';
+import { scanDirectory, scanDirectoryLiteral, flattenEntityValues } from './scanner.js';
 import { buildTokenMap, runPurge } from './purge.js';
 import { verify } from './verify.js';
 import { resolve, dirname } from 'node:path';
@@ -30,6 +30,7 @@ function parseArgs(argv: string[]): {
   target: string;
   apply: boolean;
   json: boolean;
+  verifyOnly: boolean;
 } {
   const args: Record<string, string | boolean> = {};
   for (let i = 0; i < argv.length; i++) {
@@ -37,6 +38,7 @@ function parseArgs(argv: string[]): {
     if (arg === '--apply') { args['apply'] = true; }
     else if (arg === '--dry-run') { args['dry-run'] = true; }
     else if (arg === '--json') { args['json'] = true; }
+    else if (arg === '--verify-only') { args['verify-only'] = true; }
     else if (arg.startsWith('--')) {
       const key = arg.slice(2);
       args[key] = argv[i + 1] ?? true;
@@ -61,6 +63,7 @@ function parseArgs(argv: string[]): {
     target: resolve(target),
     apply: args['apply'] === true,
     json: args['json'] === true,
+    verifyOnly: args['verify-only'] === true,
   };
 }
 
@@ -80,11 +83,37 @@ async function main(): Promise<void> {
     console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
   }
 
-  // 2. Generate patterns
+  // 2. Generate patterns + flatten raw values (literal safety net — VERIFY-001)
   const patterns = generateAllPatterns(dict.entities);
+  const literalValues = flattenEntityValues(dict.entities);
+
+  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.
+  // Wire this into pre-commit / publish paths (R-SEC-005) to block on known entities.
+  if (opts.verifyOnly) {
+    const patternHits = (await scanDirectory(opts.target, patterns, opts.entityDict)).filter(f => f.matchType !== 'fuzzy-REVIEW');
+    const literalHits = await scanDirectoryLiteral(opts.target, literalValues, opts.entityDict);
+    const total = patternHits.length + literalHits.length;
+    if (opts.json) {
+      console.log(JSON.stringify({
+        mode: 'verify-only',
+        clean: total === 0,
+        findings: [...patternHits, ...literalHits].map(f => ({
+          file: f.file, line: f.line, entityId: f.entityId, type: f.type, matchType: f.matchType,
+        })),
+      }, null, 2));
+    } else if (total === 0) {
+      console.log('[pii-purge] VERIFY-ONLY: clean — zero known-entity findings');
+    } else {
+      console.error(`[pii-purge] VERIFY-ONLY FAILED: ${total} known-entity finding(s) remain`);
+      for (const f of [...patternHits, ...literalHits]) {
+        console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}`);
+      }
+    }
+    process.exit(total === 0 ? 0 : 1);
+  }
 
   // 3. Scan
-  const findings = await scanDirectory(opts.target, patterns);
+  const findings = await scanDirectory(opts.target, patterns, opts.entityDict);
 
   const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
   const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
@@ -126,7 +155,7 @@ async function main(): Promise<void> {
   // 6. Verify (only in apply mode — meaningful post-write)
   let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
   if (mode === 'apply') {
-    verifyResult = await verify(opts.target, patterns);
+    verifyResult = await verify(opts.target, patterns, literalValues, opts.entityDict);
     if (!opts.json) {
       if (verifyResult.cleanExit) {
         console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
diff --git a/packages/pii-purge/src/purge.ts b/packages/pii-purge/src/purge.ts
index 83e8fb0c..88f445aa 100644
--- a/packages/pii-purge/src/purge.ts
+++ b/packages/pii-purge/src/purge.ts
@@ -109,12 +109,29 @@ export function applyReplacements(
     token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   }));
 
-  // Sort end-to-start (line desc, offset desc)
+  // BUG-001 fix: remove OVERLAPPING spans before replacing.
+  // Two patterns (a plate written with and without its dash) can match the same span; // scan-ok: format note
+  // applying both corrupts the output ([PESSOA_1]_1]). Keep longest-wins, drop overlaps.
+  // Sort start-to-end (line asc, offset asc, length desc) then greedily keep non-overlapping.
   spans.sort((a, b) =>
-    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
+    a.lineIdx - b.lineIdx || a.lineOffset - b.lineOffset || b.matchLength - a.matchLength,
   );
+  const kept: Span[] = [];
+  const lastEndByLine = new Map<number, number>();
+  for (const s of spans) {
+    const lastEnd = lastEndByLine.get(s.lineIdx) ?? -1;
+    if (s.lineOffset >= lastEnd) {
+      kept.push(s);
+      lastEndByLine.set(s.lineIdx, s.lineOffset + s.matchLength);
+    }
+    // else: overlaps an already-kept span on this line → drop (avoids corruption)
+  }
 
-  for (const span of spans) {
+  // Apply kept spans end-to-start (line desc, offset desc) so earlier offsets stay valid
+  kept.sort((a, b) =>
+    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
+  );
+  for (const span of kept) {
     const line = lines[span.lineIdx];
     if (line === undefined) continue;
     lines[span.lineIdx] =
@@ -123,7 +140,7 @@ export function applyReplacements(
       line.slice(span.lineOffset + span.matchLength);
   }
 
-  return { result: lines.join('\n'), appliedCount: applicable.length };
+  return { result: lines.join('\n'), appliedCount: kept.length };
 }
 
 // ─── Main purge function ──────────────────────────────────────────────────────
diff --git a/packages/pii-purge/src/scanner.ts b/packages/pii-purge/src/scanner.ts
index 018c1e98..3bd2aa47 100644
--- a/packages/pii-purge/src/scanner.ts
+++ b/packages/pii-purge/src/scanner.ts
@@ -12,6 +12,7 @@ import { readdir, readFile, stat } from 'node:fs/promises';
 import { join, extname } from 'node:path';
 import { execSync } from 'node:child_process';
 import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
+import type { Entity } from './dictionary.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -121,6 +122,28 @@ export function scanText(
   return findings;
 }
 
+/**
+ * Resolve the list of readable text files under `targetDir`, preferring git-tracked.
+ * Yields { path, text } for each, skipping binaries and files >2MB.
+ */
+async function readScannableFiles(targetDir: string): Promise<Array<{ path: string; text: string }>> {
+  const allFiles = await collectFiles(targetDir);
+  const gitTracked = getGitTrackedFiles(targetDir);
+  const filesToScan = gitTracked ? allFiles.filter(f => gitTracked.has(f)) : allFiles;
+
+  const out: Array<{ path: string; text: string }> = [];
+  for (const path of filesToScan) {
+    const s = await stat(path);
+    if (s.size > 2 * 1024 * 1024) continue; // skip very large files
+    try {
+      out.push({ path, text: await readFile(path, 'utf-8') });
+    } catch {
+      // Binary or unreadable — skip
+    }
+  }
+  return out;
+}
+
 /**
  * Walk a target directory and scan all eligible files.
  * Returns a deduplicated, stable list of findings.
@@ -131,33 +154,88 @@ export function scanText(
 export async function scanDirectory(
   targetDir: string,
   patterns: EntityPattern[],
+  excludeFile?: string,
 ): Promise<Finding[]> {
-  const allFiles = await collectFiles(targetDir);
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanText(text, path, patterns));
+  }
+  return allFindings;
+}
 
-  // Filter to git-tracked files when possible
-  const gitTracked = getGitTrackedFiles(targetDir);
-  const filesToScan = gitTracked
-    ? allFiles.filter(f => gitTracked.has(f))
-    : allFiles;
+// ─── Literal-value safety net (VERIFY-001) ─────────────────────────────────────
+// The pattern generator's output depends on the dict FIELD TYPE (a text value put
+// in a numeric `reds` field generates no working pattern → escapes silently).
+// This literal scan searches for each raw dict value case-insensitively, independent
+// of field typing — the catch-all that makes a mis-typed dict field non-fatal.
 
-  const allFindings: Finding[] = [];
+export interface LiteralValue {
+  raw: string;
+  entityId: string;
+  type: EntityFieldType;
+}
 
-  for (const filePath of filesToScan) {
-    const s = await stat(filePath);
-    // Skip very large files (>2MB) to avoid memory spikes
-    if (s.size > 2 * 1024 * 1024) continue;
+/** Flatten every raw identifier value from the entity dictionary. */
+export function flattenEntityValues(entities: Entity[]): LiteralValue[] {
+  const out: LiteralValue[] = [];
+  for (const e of entities) {
+    for (const v of e.cpfs ?? []) out.push({ raw: v, entityId: e.id, type: 'cpf' });
+    for (const v of e.phones ?? []) out.push({ raw: v, entityId: e.id, type: 'phone' });
+    for (const v of e.plates ?? []) out.push({ raw: v, entityId: e.id, type: 'plate' });
+    for (const v of e.names ?? []) out.push({ raw: v, entityId: e.id, type: 'name' });
+    for (const v of e.reds ?? []) out.push({ raw: v, entityId: e.id, type: 'reds' });
+  }
+  return out;
+}
 
-    let text: string;
-    try {
-      text = await readFile(filePath, 'utf-8');
-    } catch {
-      // Binary or unreadable — skip
-      continue;
+/**
+ * Case-insensitive literal substring search for raw dict values.
+ * NEVER includes the matched value in a Finding (T0 §3).
+ */
+export function scanLiteralValues(
+  text: string,
+  filePath: string,
+  values: LiteralValue[],
+): Finding[] {
+  const findings: Finding[] = [];
+  const lines = text.split('\n');
+  for (const v of values) {
+    const needle = (v.raw ?? '').toLowerCase();
+    if (needle.length < 3) continue; // avoid trivial/noisy short matches
+    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
+      const hay = lines[lineIdx]!.toLowerCase();
+      let from = 0;
+      let idx: number;
+      while ((idx = hay.indexOf(needle, from)) !== -1) {
+        findings.push({
+          file: filePath,
+          line: lineIdx + 1,
+          entityId: v.entityId,
+          type: v.type,
+          matchType: 'literal-LEFTOVER',
+          lineOffset: idx,
+          matchLength: v.raw.length,
+        });
+        from = idx + needle.length;
+      }
     }
-
-    const findings = scanText(text, filePath, patterns);
-    allFindings.push(...findings);
   }
+  return findings;
+}
 
+/** Walk a directory and literal-scan all eligible files for raw dict values. */
+export async function scanDirectoryLiteral(
+  targetDir: string,
+  values: LiteralValue[],
+  excludeFile?: string,
+): Promise<Finding[]> {
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanLiteralValues(text, path, values));
+  }
   return allFindings;
 }
diff --git a/packages/pii-purge/src/verify.ts b/packages/pii-purge/src/verify.ts
index 62fe8075..abcf5745 100644
--- a/packages/pii-purge/src/verify.ts
+++ b/packages/pii-purge/src/verify.ts
@@ -7,13 +7,13 @@
  */
 
 import type { EntityPattern } from './patterns.js';
-import type { Finding } from './scanner.js';
-import { scanDirectory } from './scanner.js';
+import type { Finding, LiteralValue } from './scanner.js';
+import { scanDirectory, scanDirectoryLiteral } from './scanner.js';
 
 export interface VerifyResult {
-  /** True only when zero auto-purgeable findings remain */
+  /** True only when zero auto-purgeable AND zero literal-leftover findings remain */
   cleanExit: boolean;
-  /** Remaining auto-purgeable findings (should be empty on success) */
+  /** Remaining auto-purgeable findings (pattern + literal-leftover; should be empty on success) */
   remaining: Finding[];
   /** Remaining fuzzy-REVIEW findings (human review required) */
   reviewRequired: Finding[];
@@ -21,18 +21,30 @@ export interface VerifyResult {
 
 /**
  * Re-scan the target directory after purge.
+ * Runs BOTH the pattern scan AND a literal-value scan (VERIFY-001 safety net) —
+ * the literal scan catches values that escaped because of a mis-typed dict field.
  *
- * @param targetDir  - directory that was purged
- * @param patterns   - same patterns used for original scan
+ * @param targetDir       - directory that was purged
+ * @param patterns        - same patterns used for original scan
+ * @param literalValues   - raw dict values (from flattenEntityValues) for the safety net
  */
 export async function verify(
   targetDir: string,
   patterns: EntityPattern[],
+  literalValues: LiteralValue[] = [],
+  excludeFile?: string,
 ): Promise<VerifyResult> {
-  const findings = await scanDirectory(targetDir, patterns);
+  const patternFindings = await scanDirectory(targetDir, patterns, excludeFile);
+  const literalFindings = literalValues.length
+    ? await scanDirectoryLiteral(targetDir, literalValues, excludeFile)
+    : [];
 
-  const remaining = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
-  const reviewRequired = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  const reviewRequired = patternFindings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  // "remaining" = anything that must block: non-fuzzy pattern hits + any literal leftover
+  const remaining = [
+    ...patternFindings.filter(f => f.matchType !== 'fuzzy-REVIEW'),
+    ...literalFindings,
+  ];
 
   return {
     cleanExit: remaining.length === 0,
diff --git a/packages/shared/src/llm-provider.ts b/packages/shared/src/llm-provider.ts
index eb9f869f..b6179a36 100644
--- a/packages/shared/src/llm-provider.ts
+++ b/packages/shared/src/llm-provider.ts
@@ -1,39 +1,23 @@
 import type { AIAnalysisResult } from './types';
 
-export type SharedLLMProvider = 'openrouter' | 'alibaba' | 'google';
+export type SharedLLMProvider = 'openrouter' | 'google';
 
 // ── Architecture ────────────────────────────────────────────────────────────
 // ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
-//   → Unlimited rate limit on all 3 models
 //   → This session IS the primary orchestrator, not routed through here
 //
 // BACKGROUND AGENTS (VPS): Use this fallback chain
-//   Priority: Google AI Studio → Alibaba DashScope → OpenRouter
+//   Priority: Google AI Studio (free) → OpenRouter (gemini-2.0-flash-001)
 //
 // Google AI Studio (PRIORITY 1 — Completely Free, No Expiry):
 //   Models: gemma-4-31b-it (1,500 req/day), gemini-2.5-flash (500 req/day)
 //   Key: GOOGLE_AI_STUDIO_API_KEY | Base: generativelanguage.googleapis.com
-//   WARNING: gemma-4-31b is excellent for reasoning/coding but weak on tool-calling
 //
-// Alibaba DashScope (PRIORITY 2 — Free One-Time Grant):
-//   Models: qwen-flash, qwen-plus, qwen-max, qwq-plus (reasoning)
-//   ONE-TIME 1M token grant per model (90-day validity)
-//   Rate limits: 30K RPM (fast), 15K RPM (default), 600 RPM (deep)
-//
-// OpenRouter (PRIORITY 3 — Paid Fallback):
-//   qwen3.6-plus:free → $0/token, unlimited rate (primary free option here)
-//   Hermes-3, Gemini Flash, Llama 4 — only when others exhausted
-//   NO Claude models — orchestrator handles Claude via Claude Code plan
-
-export const ALIBABA_MODELS = [
-  'qwen-max',
-  'qwen-plus',
-  'qwen-flash',
-  'qwen3-coder-plus',
-  'qwen3.5-plus',
-  'qwen-turbo',
-  'qwq-plus',
-] as const;
+// OpenRouter (PRIORITY 2 — Paid, low cost):
+//   PRIMARY: google/gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
+//   Fallback: gemini-2.5-pro, llama-4-maverick
+//   Key: OPENROUTER_API_KEY
+//   NOTE: Alibaba DashScope REMOVED — free grant period expired ($500 used)
 
 // ── Fallback Chain ─────────────────────────────────────────────────────────
 
@@ -54,39 +38,15 @@ const GOOGLE_CHAIN: ModelEntry[] = [
   { provider: 'google', model: 'gemini-2.5-pro',   tier: 'deep' },
 ];
 
-// Tier 1: Alibaba (FREE one-time grant — exhaust before OpenRouter)
-const ALIBABA_CHAIN: ModelEntry[] = [
-  // Fast tier — 30K RPM, 10M TPM (free 1M tokens)
-  { provider: 'alibaba', model: 'qwen3.5-flash',   tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen-flash',       tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen-turbo',       tier: 'fast' },
-  { provider: 'alibaba', model: 'qwen3-coder-plus', tier: 'fast' },
-
-  // Default tier — 15K RPM, 5M TPM
-  { provider: 'alibaba', model: 'qwen-plus',    tier: 'default' },
-  { provider: 'alibaba', model: 'qwen3.5-plus', tier: 'default' },
-
-  // Deep tier — 600 RPM, 1M TPM (reasoning/planning)
-  { provider: 'alibaba', model: 'qwen-max',  tier: 'deep' },
-  { provider: 'alibaba', model: 'qwq-plus',  tier: 'deep' },
-];
-
-// Tier 2: OpenRouter — free model first, then cheap paid
+// Tier 1: OpenRouter — gemini-2.0-flash-001 as primary paid model
 const OPENROUTER_CHAIN: ModelEntry[] = [
-  // FREE — Qwen 3.6 Plus (prompt=0, completion=0, no rate limit published)
-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'fast' },
-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'default' },
+  // Fast tier — Gemini 2.0 Flash (~$0.10/1M in, $0.40/1M out)
+  { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'fast' },
 
-  // MiniMax M2.5 — benchmark winner Apr 2026: 7.1/10, 67% tool accuracy, $0.36/mo
-  { provider: 'openrouter', model: 'minimax/minimax-m2.5', tier: 'default' },
-
-  // Gemini Flash (essentially free)
+  // Default tier — Gemini 2.0 Flash (best cost/quality for PT-BR tasks)
   { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'default' },
 
-  // Hermes-3 for BRAID/structured output (BRAID mechanical executor)
-  { provider: 'openrouter', model: 'nousresearch/hermes-3-llama-3.1-70b', tier: 'default' },
-
-  // Deep tier — High capability, low cost (no Claude)
+  // Deep tier — Gemini 2.5 Pro (strongest reasoning)
   { provider: 'openrouter', model: 'google/gemini-2.5-pro',       tier: 'deep' },
   { provider: 'openrouter', model: 'meta-llama/llama-4-maverick', tier: 'deep' },
 ];
@@ -124,10 +84,7 @@ async function callModel(
   let baseUrl: string;
   let apiKey: string | undefined;
 
-  if (provider === 'alibaba') {
-    baseUrl = `${(process.env.ALIBABA_DASHSCOPE_BASE_URL || 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1').replace(/\/+$/, '')}/chat/completions`;
-    apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
-  } else if (provider === 'google') {
+  if (provider === 'google') {
     // Google AI Studio: OpenAI-compatible endpoint
     baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
     apiKey = process.env.GOOGLE_AI_STUDIO_API_KEY;
@@ -137,7 +94,7 @@ async function callModel(
   }
 
   if (!apiKey) {
-    const keyName = provider === 'alibaba' ? 'ALIBABA_DASHSCOPE_API_KEY' : provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
+    const keyName = provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
     throw new Error(`SKIP: ${keyName} not set`);
   }
 
@@ -210,8 +167,7 @@ export async function chatWithLLM(params: {
   if (params.model) {
     const explicitProvider: SharedLLMProvider =
       params.provider ??
-      (params.model.startsWith('qwen') && !params.model.includes(':') ? 'alibaba'
-        : params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
+      (params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
         : 'openrouter');
     return callModel(
       { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
@@ -219,7 +175,7 @@ export async function chatWithLLM(params: {
     );
   }
 
-  // Build chain: Google (free/daily limit) → Alibaba (free grant) → OpenRouter (paid fallback)
+  // Build chain: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
   const tier = params.tier ?? 'default';
 
   const googleModels = GOOGLE_CHAIN.filter((e: ModelEntry) =>
@@ -228,22 +184,14 @@ export async function chatWithLLM(params: {
     : e.tier !== 'deep'
   );
 
-  let alibabaModels: ModelEntry[];
-  let openrouterModels: ModelEntry[];
-
-  if (tier === 'fast') {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
-  } else if (tier === 'deep') {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
-  } else {
-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
-    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
-  }
+  const openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) =>
+    tier === 'fast' ? e.tier === 'fast'
+    : tier === 'deep' ? true
+    : e.tier !== 'deep'
+  );
 
-  // Chain order: Google (free) → Alibaba (free grant) → OpenRouter
-  let chain: ModelEntry[] = [...googleModels, ...alibabaModels, ...openrouterModels];
+  // Chain order: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
+  let chain: ModelEntry[] = [...googleModels, ...openrouterModels];
 
   // If a provider is forced, prioritize it at front of chain
   if (params.provider) {
diff --git a/packages/shared/src/llm-providers/llm-router.ts b/packages/shared/src/llm-providers/llm-router.ts
index b5ea15ac..d398bc9b 100644
--- a/packages/shared/src/llm-providers/llm-router.ts
+++ b/packages/shared/src/llm-providers/llm-router.ts
@@ -1,44 +1,31 @@
 /**
  * EGOS LLM Router v2.1 (ex-hermes.ts — renomeado 2026-05-06)
- * Roteador LLM com fallback chain de 5 tiers: Alibaba → OpenRouter free → Gemini → Sonnet → Haiku.
+ * Roteador LLM com fallback chain de 4 tiers: OpenRouter free → Gemini → Sonnet → Haiku.
  * NÃO confundir com Hermes (NousResearch) — são coisas distintas.
  * Bridges EGOS TypeScript codebase with multi-provider LLM routing.
  *
  * Provider Chain (Priority Order):
- *   Phase 1: Alibaba ModelStudio (free quota - all models)
- *     1. qwen3-max (best for complex tasks)
- *     2. qwen3.5-plus (balanced performance)
- *     3. qwen3.6-plus (1M context, latest)
- *     4. qwen-plus (stable)
- *     5. qwen3-coder-plus (coding agent)
- *     6. qwen3.5-flash (fast)
- *     7. qwen-flash (cost-effective)
- *     8. qwen-turbo (qwen3 series)
- *     9. qwq-plus (reasoning)
- *   Phase 2: OpenRouter FREE (when Alibaba quota exhausted)
- *     10. qwen/qwen3.6-plus:free
- *     11. google/gemma-4-26b-a4b-it:free
- *     12. qwen/qwen3-coder:free
- *     13. meta-llama/llama-4-maverick:free
- *   Phase 3: OpenRouter PAID (after 5 consecutive failures)
- *     14. google/gemini-2.0-flash-001 (~$0.10/1M tokens)
- *   Phase 4: Claude (Anthropic direct API — last resort, rate-limited 20 calls/day)
- *     15. claude-haiku-4-5-20251001 (fastest, cheapest)
+ *   Phase 1: OpenRouter FREE
+ *     1. openai/gpt-oss-120b:free
+ *     2. qwen/qwen3-coder:free
+ *     3. meta-llama/llama-3.3-70b-instruct:free
+ *     4. minimax/minimax-m2.5:free
+ *   Phase 2: OpenRouter PAID (after free failures)
+ *     5. google/gemini-2.0-flash-001 (~$0.10/1M tokens)
+ *   Phase 3: Claude (Anthropic direct API — last resort, rate-limited 20 calls/day)
+ *     6. claude-haiku-4-5-20251001 (fastest, cheapest)
  *
  * Rate limit handling: automatic retry with next model
- * Max attempts: 5 free models → 1 paid model → 1 Claude fallback
+ * Max attempts: 4 free models → 1 paid model → 1 Claude fallback
  *
  * Migrated from Codex proxy — 2026-04-08 (CDX→HRM migration)
- * Updated with full ModelStudio chain — 2026-04-16
+ * Migrated from Alibaba DashScope to OpenRouter — 2026-06-07
  */
 
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1';
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? '';
 const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? '';
 
 // Model chain ordered by capability (best first)
-const ALIBABA_MODELS = [
+export const ALIBABA_MODELS = [
   'qwen3-max',           // Best for complex tasks, most capable
   'qwen3.5-plus',        // Balanced performance, speed, cost
   'qwen3.6-plus',        // Native multimodal, 1M context
@@ -91,7 +78,7 @@ export interface HermesOptions {
 }
 
 interface ModelAttempt {
-  provider: 'alibaba' | 'openrouter-free' | 'openrouter-paid' | 'claude';
+  provider: 'openrouter-free' | 'openrouter-paid' | 'claude';
   model: string;
   attempt: number;
 }
@@ -122,23 +109,18 @@ function buildModelChain(options: HermesOptions): ModelAttempt[] {
   const chain: ModelAttempt[] = [];
   let attemptNum = 1;
 
-  // Phase 1: Alibaba ModelStudio models
-  for (const model of ALIBABA_MODELS) {
-    chain.push({ provider: 'alibaba', model, attempt: attemptNum++ });
-  }
-
-  // Phase 2: OpenRouter FREE models
+  // Phase 1: OpenRouter FREE models
   for (const model of OPENROUTER_FREE_MODELS) {
     chain.push({ provider: 'openrouter-free', model, attempt: attemptNum++ });
   }
 
-  // Phase 3: OpenRouter PAID model
+  // Phase 2: OpenRouter PAID model
   const allowPaid = options.allowPaidFallback !== false;
   if (allowPaid) {
     chain.push({ provider: 'openrouter-paid', model: OPENROUTER_PAID_MODEL, attempt: attemptNum++ });
   }
 
-  // Phase 4: Claude direct API (last resort — rate-limited 20 calls/day)
+  // Phase 3: Claude direct API (last resort — rate-limited 20 calls/day)
   if (CLAUDE_API_KEY) {
     chain.push({ provider: 'claude', model: CLAUDE_FALLBACK_MODEL, attempt: attemptNum++ });
   }
@@ -147,8 +129,7 @@ function buildModelChain(options: HermesOptions): ModelAttempt[] {
 }
 
 /**
- * Call Alibaba ModelStudio with full fallback chain to OpenRouter.
- * Tries all Alibaba models first, then OpenRouter free, then OpenRouter paid.
+ * Call LLM with full fallback chain: OpenRouter free → OpenRouter paid → Claude.
  * Auto-retries on rate limit, quota exhaustion, or network errors.
  */
 export async function callHermes(
@@ -168,9 +149,7 @@ export async function callHermes(
     try {
       let result: { content: string; provider: string; model: string } | null = null;
 
-      if (attempt.provider === 'alibaba' && DASHSCOPE_KEY) {
-        result = await callAlibaba(attempt.model, messages, maxTokens, timeoutMs);
-      } else if ((attempt.provider === 'openrouter-free' || attempt.provider === 'openrouter-paid') && OPENROUTER_KEY) {
+      if ((attempt.provider === 'openrouter-free' || attempt.provider === 'openrouter-paid') && OPENROUTER_KEY) {
         result = await callOpenRouter(attempt.model, messages, maxTokens, timeoutMs, attempt.provider === 'openrouter-paid');
       } else if (attempt.provider === 'claude' && CLAUDE_API_KEY) {
         if (claudeBreakerOpen()) {
@@ -213,39 +192,6 @@ export async function callHermes(
   throw new Error(`Hermes: All models exhausted after ${chain.length} attempts. Errors:\n${errors.join('\n')}`);
 }
 
-/** Call Alibaba DashScope API */
-async function callAlibaba(
-  model: string,
-  messages: HermesMessage[],
-  maxTokens: number,
-  timeoutMs: number
-): Promise<{ content: string; provider: string; model: string } | null> {
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
-    method: 'POST',
-    headers: {
-      'Authorization': `Bearer ${DASHSCOPE_KEY}`,
-      'Content-Type': 'application/json',
-    },
-    body: JSON.stringify({ model, messages, max_tokens: maxTokens }),
-    signal: AbortSignal.timeout(timeoutMs),
-  });
-
-  const body = await res.text();
-
-  if (!res.ok) {
-    const err: any = new Error(`Alibaba ${model}: HTTP ${res.status} - ${body.slice(0, 200)}`);
-    err.status = res.status;
-    err.body = body;
-    throw err;
-  }
-
-  const data = JSON.parse(body);
-  const content = data?.choices?.[0]?.message?.content ?? '';
-  if (!content) return null;
-
-  return { content, provider: 'alibaba-dashscope', model };
-}
-
 /** Call OpenRouter API */
 async function callOpenRouter(
   model: string,
@@ -407,7 +353,7 @@ if (import.meta.main) {
   console.log(`\n✅ Chain built: ${chain.length} models`);
 
   // Test with a simple prompt if env vars are set
-  if (DASHSCOPE_KEY || OPENROUTER_KEY) {
+  if (OPENROUTER_KEY) {
     console.log('\n🚀 Testing with sample prompt...');
     try {
       const result = await callHermes('Say "Hermes v2.0 is working" and list the provider you are.', {
@@ -423,7 +369,7 @@ if (import.meta.main) {
       process.exit(1);
     }
   } else {
-    console.log('\n⚠️  No API keys set (ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY)');
+    console.log('\n⚠️  No API keys set (OPENROUTER_API_KEY or ANTHROPIC_API_KEY)');
     console.log('    Set keys to run live test.');
   }
 }
diff --git a/packages/shared/src/model-router.ts b/packages/shared/src/model-router.ts
index 97b713d2..03d10e9a 100644
--- a/packages/shared/src/model-router.ts
+++ b/packages/shared/src/model-router.ts
@@ -49,51 +49,6 @@ export interface ModelProfile {
 }
 
 export const MODEL_CATALOG: ModelProfile[] = [
-  // ── Alibaba / DashScope ──
-  {
-    id: 'qwen-max',
-    provider: 'alibaba',
-    displayName: 'Qwen Max',
-    costPer1MInput: 1.6,
-    costPer1MOutput: 6.4,
-    maxContext: 32768,
-    strengths: ['orchestration', 'analysis', 'code_review'],
-    tier: 'premium',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen-plus',
-    provider: 'alibaba',
-    displayName: 'Qwen Plus',
-    costPer1MInput: 0.8,
-    costPer1MOutput: 2.0,
-    maxContext: 131072,
-    strengths: ['orchestration', 'code_generation', 'analysis', 'chat', 'extraction'],
-    tier: 'balanced',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen3-coder-plus',
-    provider: 'alibaba',
-    displayName: 'Qwen3 Coder Plus',
-    costPer1MInput: 0.8,
-    costPer1MOutput: 2.0,
-    maxContext: 131072,
-    strengths: ['code_generation', 'code_review'],
-    tier: 'balanced',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
-  {
-    id: 'qwen-flash',
-    provider: 'alibaba',
-    displayName: 'Qwen Flash',
-    costPer1MInput: 0.0,
-    costPer1MOutput: 0.0,
-    maxContext: 131072,
-    strengths: ['fast_check', 'classification', 'summarization', 'translation', 'chat'],
-    tier: 'economy',
-    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
-  },
   // ── OpenRouter ──
   {
     id: 'google/gemini-2.0-flash-001',
@@ -260,7 +215,7 @@ export function resolveModel(taskOrOpts: TaskType | RouteOptions): ResolvedRoute
 
   if (candidates.length === 0) {
     throw new Error(
-      `No LLM provider available. Set ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY in .env`
+      `No LLM provider available. Set OPENROUTER_API_KEY in .env`
     );
   }
 

exec
/bin/bash -lc 'git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d -- packages/pii-purge/src/scanner.ts packages/pii-purge/src/verify.ts packages/pii-purge/src/pii-purge.test.ts packages/pii-purge/src/patterns.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/packages/pii-purge/src/patterns.ts b/packages/pii-purge/src/patterns.ts
index 420dac38..772f8cfb 100644
--- a/packages/pii-purge/src/patterns.ts
+++ b/packages/pii-purge/src/patterns.ts
@@ -16,7 +16,7 @@ import type { Entity } from './dictionary.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
-export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW';
+export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW' | 'literal-LEFTOVER';
 export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';
 
 export interface EntityPattern {
diff --git a/packages/pii-purge/src/pii-purge.test.ts b/packages/pii-purge/src/pii-purge.test.ts
index ddd3e6c9..c2756872 100644
--- a/packages/pii-purge/src/pii-purge.test.ts
+++ b/packages/pii-purge/src/pii-purge.test.ts
@@ -14,7 +14,7 @@ import { tmpdir } from 'node:os';
 
 import { validateDictionary, type EntityDictionary } from './dictionary.js';
 import { generateAllPatterns, normalizeOrtho } from './patterns.js';
-import { scanText, scanDirectory } from './scanner.js';
+import { scanText, scanDirectory, scanLiteralValues, flattenEntityValues } from './scanner.js';
 import { buildTokenMap, applyReplacements, runPurge } from './purge.js';
 import { verify } from './verify.js';
 
@@ -458,3 +458,39 @@ describe('applyReplacements', () => {
     expect(appliedCount).toBe(0);
   });
 });
+
+describe('BUG-001 — overlapping spans do not corrupt output', () => {
+  test('duplicate plate variants produce a single clean token (no [PESSOA_N]_ corruption)', () => {
+    // Both "TST-1234" and "TST1234" generate the same regex \bTST[-]?1234\b → match same span
+    const dict: EntityDictionary = { entities: [{ id: 'ent-x', plates: ['TST-1234', 'TST1234'] }] };
+    const patterns = generateAllPatterns(dict.entities);
+    const text = 'Veiculo placa TST1234 localizado';
+    const findings = scanText(text, 'x.txt', patterns).filter(f => f.matchType !== 'fuzzy-REVIEW');
+    expect(findings.length).toBeGreaterThan(1); // two patterns hit the same span (the bug trigger)
+
+    const tokenMap = buildTokenMap(dict.entities);
+    const { result, appliedCount } = applyReplacements(text, findings, tokenMap);
+    expect(result).toBe('Veiculo placa [PESSOA_1] localizado');
+    expect(result).not.toMatch(/\[PESSOA_\d+\]_/); // no corruption like [PESSOA_1]_1]
+    expect(appliedCount).toBe(1); // overlaps deduped → exactly one replacement
+  });
+});
+
+describe('VERIFY-001 — literal scan catches a mis-typed dict field', () => {
+  test('text value placed in numeric `reds` field escapes patterns but is caught literally', () => {
+    const dict: EntityDictionary = { entities: [{ id: 'ent-g', reds: ['grupo alfa secreto'] }] };
+    const text = 'contato no grupo alfa secreto hoje';
+
+    // Pattern scan MISSES it (text in a numeric field generates no working pattern)
+    const patterns = generateAllPatterns(dict.entities);
+    expect(scanText(text, 'x.txt', patterns).length).toBe(0);
+
+    // Literal safety net CATCHES it
+    const literals = flattenEntityValues(dict.entities);
+    const litHits = scanLiteralValues(text, 'x.txt', literals);
+    expect(litHits.length).toBe(1);
+    expect(litHits[0]!.matchType).toBe('literal-LEFTOVER');
+    // and the finding NEVER carries the raw value (T0 §3)
+    expect(JSON.stringify(litHits[0])).not.toContain('grupo alfa secreto');
+  });
+});
diff --git a/packages/pii-purge/src/scanner.ts b/packages/pii-purge/src/scanner.ts
index 018c1e98..3bd2aa47 100644
--- a/packages/pii-purge/src/scanner.ts
+++ b/packages/pii-purge/src/scanner.ts
@@ -12,6 +12,7 @@ import { readdir, readFile, stat } from 'node:fs/promises';
 import { join, extname } from 'node:path';
 import { execSync } from 'node:child_process';
 import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
+import type { Entity } from './dictionary.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -121,6 +122,28 @@ export function scanText(
   return findings;
 }
 
+/**
+ * Resolve the list of readable text files under `targetDir`, preferring git-tracked.
+ * Yields { path, text } for each, skipping binaries and files >2MB.
+ */
+async function readScannableFiles(targetDir: string): Promise<Array<{ path: string; text: string }>> {
+  const allFiles = await collectFiles(targetDir);
+  const gitTracked = getGitTrackedFiles(targetDir);
+  const filesToScan = gitTracked ? allFiles.filter(f => gitTracked.has(f)) : allFiles;
+
+  const out: Array<{ path: string; text: string }> = [];
+  for (const path of filesToScan) {
+    const s = await stat(path);
+    if (s.size > 2 * 1024 * 1024) continue; // skip very large files
+    try {
+      out.push({ path, text: await readFile(path, 'utf-8') });
+    } catch {
+      // Binary or unreadable — skip
+    }
+  }
+  return out;
+}
+
 /**
  * Walk a target directory and scan all eligible files.
  * Returns a deduplicated, stable list of findings.
@@ -131,33 +154,88 @@ export function scanText(
 export async function scanDirectory(
   targetDir: string,
   patterns: EntityPattern[],
+  excludeFile?: string,
 ): Promise<Finding[]> {
-  const allFiles = await collectFiles(targetDir);
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanText(text, path, patterns));
+  }
+  return allFindings;
+}
 
-  // Filter to git-tracked files when possible
-  const gitTracked = getGitTrackedFiles(targetDir);
-  const filesToScan = gitTracked
-    ? allFiles.filter(f => gitTracked.has(f))
-    : allFiles;
+// ─── Literal-value safety net (VERIFY-001) ─────────────────────────────────────
+// The pattern generator's output depends on the dict FIELD TYPE (a text value put
+// in a numeric `reds` field generates no working pattern → escapes silently).
+// This literal scan searches for each raw dict value case-insensitively, independent
+// of field typing — the catch-all that makes a mis-typed dict field non-fatal.
 
-  const allFindings: Finding[] = [];
+export interface LiteralValue {
+  raw: string;
+  entityId: string;
+  type: EntityFieldType;
+}
 
-  for (const filePath of filesToScan) {
-    const s = await stat(filePath);
-    // Skip very large files (>2MB) to avoid memory spikes
-    if (s.size > 2 * 1024 * 1024) continue;
+/** Flatten every raw identifier value from the entity dictionary. */
+export function flattenEntityValues(entities: Entity[]): LiteralValue[] {
+  const out: LiteralValue[] = [];
+  for (const e of entities) {
+    for (const v of e.cpfs ?? []) out.push({ raw: v, entityId: e.id, type: 'cpf' });
+    for (const v of e.phones ?? []) out.push({ raw: v, entityId: e.id, type: 'phone' });
+    for (const v of e.plates ?? []) out.push({ raw: v, entityId: e.id, type: 'plate' });
+    for (const v of e.names ?? []) out.push({ raw: v, entityId: e.id, type: 'name' });
+    for (const v of e.reds ?? []) out.push({ raw: v, entityId: e.id, type: 'reds' });
+  }
+  return out;
+}
 
-    let text: string;
-    try {
-      text = await readFile(filePath, 'utf-8');
-    } catch {
-      // Binary or unreadable — skip
-      continue;
+/**
+ * Case-insensitive literal substring search for raw dict values.
+ * NEVER includes the matched value in a Finding (T0 §3).
+ */
+export function scanLiteralValues(
+  text: string,
+  filePath: string,
+  values: LiteralValue[],
+): Finding[] {
+  const findings: Finding[] = [];
+  const lines = text.split('\n');
+  for (const v of values) {
+    const needle = (v.raw ?? '').toLowerCase();
+    if (needle.length < 3) continue; // avoid trivial/noisy short matches
+    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
+      const hay = lines[lineIdx]!.toLowerCase();
+      let from = 0;
+      let idx: number;
+      while ((idx = hay.indexOf(needle, from)) !== -1) {
+        findings.push({
+          file: filePath,
+          line: lineIdx + 1,
+          entityId: v.entityId,
+          type: v.type,
+          matchType: 'literal-LEFTOVER',
+          lineOffset: idx,
+          matchLength: v.raw.length,
+        });
+        from = idx + needle.length;
+      }
     }
-
-    const findings = scanText(text, filePath, patterns);
-    allFindings.push(...findings);
   }
+  return findings;
+}
 
+/** Walk a directory and literal-scan all eligible files for raw dict values. */
+export async function scanDirectoryLiteral(
+  targetDir: string,
+  values: LiteralValue[],
+  excludeFile?: string,
+): Promise<Finding[]> {
+  const files = await readScannableFiles(targetDir);
+  const allFindings: Finding[] = [];
+  for (const { path, text } of files) {
+    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
+    allFindings.push(...scanLiteralValues(text, path, values));
+  }
   return allFindings;
 }
diff --git a/packages/pii-purge/src/verify.ts b/packages/pii-purge/src/verify.ts
index 62fe8075..abcf5745 100644
--- a/packages/pii-purge/src/verify.ts
+++ b/packages/pii-purge/src/verify.ts
@@ -7,13 +7,13 @@
  */
 
 import type { EntityPattern } from './patterns.js';
-import type { Finding } from './scanner.js';
-import { scanDirectory } from './scanner.js';
+import type { Finding, LiteralValue } from './scanner.js';
+import { scanDirectory, scanDirectoryLiteral } from './scanner.js';
 
 export interface VerifyResult {
-  /** True only when zero auto-purgeable findings remain */
+  /** True only when zero auto-purgeable AND zero literal-leftover findings remain */
   cleanExit: boolean;
-  /** Remaining auto-purgeable findings (should be empty on success) */
+  /** Remaining auto-purgeable findings (pattern + literal-leftover; should be empty on success) */
   remaining: Finding[];
   /** Remaining fuzzy-REVIEW findings (human review required) */
   reviewRequired: Finding[];
@@ -21,18 +21,30 @@ export interface VerifyResult {
 
 /**
  * Re-scan the target directory after purge.
+ * Runs BOTH the pattern scan AND a literal-value scan (VERIFY-001 safety net) —
+ * the literal scan catches values that escaped because of a mis-typed dict field.
  *
- * @param targetDir  - directory that was purged
- * @param patterns   - same patterns used for original scan
+ * @param targetDir       - directory that was purged
+ * @param patterns        - same patterns used for original scan
+ * @param literalValues   - raw dict values (from flattenEntityValues) for the safety net
  */
 export async function verify(
   targetDir: string,
   patterns: EntityPattern[],
+  literalValues: LiteralValue[] = [],
+  excludeFile?: string,
 ): Promise<VerifyResult> {
-  const findings = await scanDirectory(targetDir, patterns);
+  const patternFindings = await scanDirectory(targetDir, patterns, excludeFile);
+  const literalFindings = literalValues.length
+    ? await scanDirectoryLiteral(targetDir, literalValues, excludeFile)
+    : [];
 
-  const remaining = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
-  const reviewRequired = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  const reviewRequired = patternFindings.filter(f => f.matchType === 'fuzzy-REVIEW');
+  // "remaining" = anything that must block: non-fuzzy pattern hits + any literal leftover
+  const remaining = [
+    ...patternFindings.filter(f => f.matchType !== 'fuzzy-REVIEW'),
+    ...literalFindings,
+  ];
 
   return {
     cleanExit: remaining.length === 0,

exec
/bin/bash -lc 'bun test packages/pii-purge/src/pii-purge.test.ts && bun run typecheck' in /home/enio/egos
 succeeded in 14570ms:
exec
/bin/bash -lc "sed -n '35,130p' apps/egos-gateway/src/orchestrator.ts && sed -n '1540,1660p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
  name: string;
  base: string;
  key: string;
  model: string;
}

const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";

function getProvider(modelName: string): LLMProvider | null {
  // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
  if (modelName.startsWith("gemini-") || modelName.startsWith("gpt-") ||
      modelName.startsWith("claude-") || modelName.startsWith("deepseek-")) {
    if (!OPENROUTER_KEY) return null;
    const orModel = modelName.startsWith("gemini-") ? `google/${modelName}`
                  : modelName.startsWith("gpt-") ? `openai/${modelName}`
                  : modelName.startsWith("claude-") ? `anthropic/${modelName}`
                  : `deepseek/${modelName}`;
    return {
      name: modelName,
      base: "https://openrouter.ai/api/v1",
      key: OPENROUTER_KEY,
      model: orModel,
    };
  }
  // Via OpenRouter (fallback genérico com prefixo de provider)
  if (OPENROUTER_KEY && modelName.includes("/")) {
    return {
      name: modelName,
      base: "https://openrouter.ai/api/v1",
      key: OPENROUTER_KEY,
      model: modelName,
    };
  }
  return null;
}
const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
const GUARD_URL = "https://guard.egos.ia.br";
const GW_PORT = process.env.GATEWAY_PORT ?? "3000";
const GW = `http://localhost:${GW_PORT}`;
const ROOT = join(import.meta.dir, "../../..");

// ─── Types ────────────────────────────────────────────────────────────────────

export type MediaType = "audio" | "image" | "video" | "document" | "sticker";
export type Channel = "whatsapp" | "telegram";

export interface IncomingMessage {
  from: string;
  channel: Channel;
  text?: string;
  mediaType?: MediaType;
  mediaBase64?: string;
  mediaMime?: string;
  mediaUrl?: string;
  caption?: string;
  fileName?: string;
}

export interface OrchestratorResponse {
  text: string;
  toolsUsed?: string[];
}

export interface ClientContext {
  slug: string;
  name: string;
  sector: string;
  kbSource: "notion" | "obsidian" | "supabase";
  kbNotionWorkspace?: string;
  apiBudgetBrl: number;
  apiUsedBrl: number;
  // Member context (optional — populated when request comes from a team member)
  memberName?: string;
  memberRole?: "owner" | "partner" | "associate" | "intern";
  kbAccess?: string[]; // empty = full access
  // Extra rules injected per-client (anti-hallucination, tone, restrictions)
  extraRules?: string;
}

// ─── Supabase helpers ─────────────────────────────────────────────────────────

const SB_HEADERS = () => ({
  apikey: SUPABASE_KEY,
  Authorization: `Bearer ${SUPABASE_KEY}`,
  "Content-Type": "application/json",
  Prefer: "return=minimal",
});

async function sbFetch(path: string): Promise<unknown> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return null;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
      headers: SB_HEADERS(),
      signal: AbortSignal.timeout(6000),
// ─── Main orchestrator ────────────────────────────────────────────────────────

export async function orchestrate(msg: IncomingMessage, client?: ClientContext): Promise<OrchestratorResponse> {
  if (!OPENROUTER_KEY) {
    return { text: "❌ OPENROUTER_API_KEY não configurado." };
  }

  const toolsUsed: string[] = [];
  let userText = msg.text ?? "";

  // Phase 1: Process media → text
  if (msg.mediaType === "audio" && msg.mediaBase64 && msg.mediaMime) {
    const transcription = await transcribeAudio(msg.mediaBase64, msg.mediaMime);
    userText = `[Transcrição do áudio]: ${transcription}`;
    toolsUsed.push("whisper");
    console.log(`[orchestrator] Audio transcribed: "${transcription.slice(0, 80)}"`);
  } else if (msg.mediaType === "image" && msg.mediaBase64 && msg.mediaMime) {
    const description = await describeImage(msg.mediaBase64, msg.mediaMime, msg.caption);
    userText = `[Imagem]: ${description}${msg.caption ? ` | Legenda do usuário: "${msg.caption}"` : ""}`;
    toolsUsed.push("qwen-vl");
    console.log(`[orchestrator] Image described: "${description.slice(0, 60)}"`);
  } else if (msg.mediaType === "document") {
    userText = `[Arquivo recebido: ${msg.fileName ?? "sem nome"}]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo conteúdo de arquivos ainda.`;
  } else if (msg.mediaType === "video") {
    userText = `[Vídeo recebido]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo vídeos ainda. Posso transcrever áudio e descrever imagens.`;
  } else if (msg.mediaType === "sticker") {
    return { text: "😄" };
  } else if (!userText) {
    return { text: "Mensagem recebida mas não reconhecida. Envie texto, áudio ou imagem." };
  }

  // Phase 2: Load conversation history + build messages
  type ChatMsg = {
    role: "system" | "user" | "assistant" | "tool";
    content: string | unknown;
    tool_call_id?: string;
    name?: string;
    tool_calls?: unknown;
  };

  const history = await loadHistory(msg.channel, msg.from, 12);

  const messages: ChatMsg[] = [
    { role: "system", content: buildSystemPrompt(msg.channel, client) },
    ...history.map((h) => ({ role: h.role as "user" | "assistant", content: h.content })),
    { role: "user", content: userText },
  ];

  for (let iter = 0; iter < 4; iter++) {
    let data: {
      choices?: Array<{
        finish_reason: string;
        message: {
          content?: string;
          tool_calls?: Array<{ id: string; function: { name: string; arguments: string } }>;
        };
      }>;
      usage?: { prompt_tokens?: number; completion_tokens?: number };
      model?: string;
    };

    // Try primary → fallback chain
    const tryProvider = async (modelName: string): Promise<typeof data | null> => {
      const provider = getProvider(modelName);
      if (!provider) return null;
      try {
        const headers: Record<string, string> = {
          Authorization: `Bearer ${provider.key}`,
          "Content-Type": "application/json",
        };
        // OpenRouter requires HTTP-Referer (uses for billing analytics)
        if (provider.base.includes("openrouter.ai")) {
          headers["HTTP-Referer"] = "https://gateway.egos.ia.br";
          headers["X-Title"] = "EGOS Gateway";
        }
        const res = await fetch(`${provider.base}/chat/completions`, {
          method: "POST",
          headers,
          body: JSON.stringify({
            model: provider.model,
            messages,
            tools: toolsForTenant(client?.slug),
            tool_choice: "auto",
            max_tokens: 1800,
            temperature: 0.2,
          }),
          signal: AbortSignal.timeout(25000),
        });
        if (!res.ok) {
          console.error(`[orchestrator] ${provider.name} ${res.status}: ${(await res.text()).substring(0, 200)}`);
          return null;
        }
        return await res.json();
      } catch (e) {
        console.error(`[orchestrator] ${provider.name} error: ${(e as Error).message}`);
        return null;
      }
    };

    data = await tryProvider(PRIMARY_MODEL) as typeof data;
    if (!data) {
      console.warn(`[orchestrator] primary ${PRIMARY_MODEL} failed, trying fallback ${FALLBACK_MODEL}`);
      data = await tryProvider(FALLBACK_MODEL) as typeof data;
    }
    if (!data) {
      console.error(`[orchestrator] ALL providers failed`);
      return { text: "❌ Erro no AI. Tente novamente.", toolsUsed };
    }

    // Codex #2: log usage for EVERY model round-trip (tool-call turns consume
    // tokens too) — not just the final stop turn. Defaults to 0 if absent.
    if (data.usage) {
      logApiUsage(data.model ?? "qwen-plus", data.usage.prompt_tokens ?? 0, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
    }

    const choice = data.choices?.[0];
    if (!choice) break;

    const { finish_reason, message } = choice;

    if (finish_reason === "stop" || !message.tool_calls?.length) {

exec
/bin/bash -lc "sed -n '1660,1760p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
    if (finish_reason === "stop" || !message.tool_calls?.length) {
      const raw = message.content ?? "Sem resposta.";
      const verified = client?.slug ? await verifyCitations(raw, client.slug) : raw;
      const formatted = formatForChannel(verified, msg.channel);
      // Persist conversation turn + token log (non-blocking)
      saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
      if (data.usage?.prompt_tokens) {
        // logApiUsage moved above (logs every round-trip); keep tenant billing here.
        logTokenUsage(client?.slug, data.model ?? "qwen-plus", data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
      }
      return { text: formatted, toolsUsed };
    }

    // Push assistant message with tool_calls
    messages.push({ role: "assistant", content: message.content ?? "", tool_calls: message.tool_calls });

    // Execute each tool call
    for (const tc of message.tool_calls) {
      let args: Record<string, unknown> = {};
      try { args = JSON.parse(tc.function.arguments); } catch { /* noop */ }

      console.log(`[orchestrator] Tool: ${tc.function.name}(${JSON.stringify(args)})`);
      const result = await dispatchTool(tc.function.name, args, { channel: msg.channel, userId: msg.from, clientSlug: client?.slug, kbAccess: client?.kbAccess });
      toolsUsed.push(tc.function.name);

      messages.push({ role: "tool", tool_call_id: tc.id, name: tc.function.name, content: result });
    }
  }

  const fallback = "Processamento completo.";
  saveHistory(msg.channel, msg.from, userText, fallback, toolsUsed, msg.mediaType).catch(() => {});
  return { text: fallback, toolsUsed };
}

exec
/bin/bash -lc 'git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d -- agents/agents/wiki-compiler.ts agents/agents/article-writer.ts scripts/gem-hunter-digest.ts scripts/manifest-generator.ts scripts/debrief/pipeline.ts packages/shared/src/__tests__/llm-provider.test.ts packages/shared/src/__tests__/model-router.test.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/agents/agents/article-writer.ts b/agents/agents/article-writer.ts
index 9bb8f178..dcb7f5a6 100644
--- a/agents/agents/article-writer.ts
+++ b/agents/agents/article-writer.ts
@@ -52,17 +52,13 @@ const TRANSLATION_OF_ARG = (() => {
 
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE_URL =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const GUARD_BRASIL_URL = "https://guard.egos.ia.br/v1/inspect";
 const GUARD_BRASIL_API_KEY = process.env.GUARD_BRASIL_API_KEY ?? "";
 
 // Rough token cost estimates (USD per 1k tokens)
-const COST_PER_1K_INPUT_QWEN = 0.0004;
-const COST_PER_1K_OUTPUT_QWEN = 0.0012;
+const COST_PER_1K_INPUT_GEMINI = 0.0001;
+const COST_PER_1K_OUTPUT_GEMINI = 0.0004;
 
 // ── Types ──────────────────────────────────────────────────────────────────
 
@@ -373,47 +369,7 @@ async function fetchWikiPages(): Promise<Array<{ slug: string; title: string }>>
 async function callLLM(prompt: string): Promise<LLMResult> {
   const messages = [{ role: "user" as const, content: prompt }];
 
-  // Primary: DashScope qwen-plus
-  if (DASHSCOPE_API_KEY) {
-    try {
-      const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-        method: "POST",
-        headers: {
-          "Content-Type": "application/json",
-          Authorization: `Bearer ${DASHSCOPE_API_KEY}`,
-        },
-        body: JSON.stringify({
-          model: "qwen-plus",
-          messages,
-          max_tokens: 1500,
-          temperature: 0.6,
-        }),
-        signal: AbortSignal.timeout(30000),
-      });
-
-      if (res.ok) {
-        const data = (await res.json()) as {
-          choices?: Array<{ message?: { content?: string } }>;
-          usage?: { prompt_tokens?: number; completion_tokens?: number };
-        };
-        const raw = data.choices?.[0]?.message?.content?.trim() ?? "";
-        const inputTokens = data.usage?.prompt_tokens ?? Math.floor(prompt.length / 4);
-        const outputTokens = data.usage?.completion_tokens ?? Math.floor(raw.length / 4);
-        const costUsd =
-          (inputTokens / 1000) * COST_PER_1K_INPUT_QWEN +
-          (outputTokens / 1000) * COST_PER_1K_OUTPUT_QWEN;
-
-        const content = parseArticleJSON(raw);
-        if (content) {
-          return { content, provider: "alibaba/qwen-plus", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: costUsd };
-        }
-      }
-    } catch (err) {
-      console.warn(`⚠️  DashScope error: ${err} — falling back to OpenRouter`);
-    }
-  }
-
-  // Fallback: OpenRouter free model
+  // Primary: OpenRouter gemini-2.0-flash-001
   if (OPENROUTER_API_KEY) {
     try {
       const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
@@ -421,9 +377,11 @@ async function callLLM(prompt: string): Promise<LLMResult> {
         headers: {
           "Content-Type": "application/json",
           Authorization: `Bearer ${OPENROUTER_API_KEY}`,
+          "HTTP-Referer": "https://egos.dev",
+          "X-Title": "egos-article-writer",
         },
         body: JSON.stringify({
-          model: "google/gemma-4-26b-a4b-it:free",
+          model: "google/gemini-2.0-flash-001",
           messages,
           max_tokens: 1500,
           temperature: 0.6,
@@ -439,10 +397,13 @@ async function callLLM(prompt: string): Promise<LLMResult> {
         const raw = data.choices?.[0]?.message?.content?.trim() ?? "";
         const inputTokens = data.usage?.prompt_tokens ?? Math.floor(prompt.length / 4);
         const outputTokens = data.usage?.completion_tokens ?? Math.floor(raw.length / 4);
+        const costUsd =
+          (inputTokens / 1000) * COST_PER_1K_INPUT_GEMINI +
+          (outputTokens / 1000) * COST_PER_1K_OUTPUT_GEMINI;
 
         const content = parseArticleJSON(raw);
         if (content) {
-          return { content, provider: "openrouter/gemma-4-26b-free", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: 0 };
+          return { content, provider: "openrouter/gemini-2.0-flash-001", input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: costUsd };
         }
       }
     } catch (err) {
@@ -450,7 +411,7 @@ async function callLLM(prompt: string): Promise<LLMResult> {
     }
   }
 
-  throw new Error("No LLM available (ALIBABA_DASHSCOPE_API_KEY or OPENROUTER_API_KEY required)");
+  throw new Error("No LLM available (OPENROUTER_API_KEY required)");
 }
 
 function parseArticleJSON(raw: string): ArticleContent | null {
diff --git a/agents/agents/wiki-compiler.ts b/agents/agents/wiki-compiler.ts
index 4f652521..f49ecfee 100644
--- a/agents/agents/wiki-compiler.ts
+++ b/agents/agents/wiki-compiler.ts
@@ -786,22 +786,20 @@ async function dedup(): Promise<void> {
 
 // ─── KB-014: LLM Enrichment ──────────────────────────────────────────────────
 
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
+const OPENROUTER_KEY_WC = process.env.OPENROUTER_API_KEY ?? "";
 
 async function enrichPage(page: { id: string; title: string; content: string; category: string }): Promise<{
   summary: string;
   tags: string[];
   quality_boost: number;
 }> {
-  if (!DASHSCOPE_KEY) throw new Error("ALIBABA_DASHSCOPE_API_KEY not set");
+  if (!OPENROUTER_KEY_WC) throw new Error("OPENROUTER_API_KEY not set");
 
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
     method: "POST",
-    headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
+    headers: { Authorization: `Bearer ${OPENROUTER_KEY_WC}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos-wiki-compiler" },
     body: JSON.stringify({
-      model: "qwen-plus",
+      model: "google/gemini-2.0-flash-001",
       messages: [
         {
           role: "system",
@@ -823,14 +821,14 @@ Content (truncated): ${page.content.slice(0, 1500)}`,
     signal: AbortSignal.timeout(20000),
   });
 
-  if (!res.ok) throw new Error(`DashScope ${res.status}`);
+  if (!res.ok) throw new Error(`OpenRouter ${res.status}`);
   const data = await res.json() as { choices: Array<{ message: { content: string } }> };
   return JSON.parse(data.choices[0].message.content);
 }
 
 async function enrich(): Promise<void> {
-  if (!DASHSCOPE_KEY) {
-    console.error("[wiki-compiler] ALIBABA_DASHSCOPE_API_KEY not set — cannot enrich");
+  if (!OPENROUTER_KEY_WC) {
+    console.error("[wiki-compiler] OPENROUTER_API_KEY not set — cannot enrich");
     return;
   }
 
diff --git a/packages/shared/src/__tests__/llm-provider.test.ts b/packages/shared/src/__tests__/llm-provider.test.ts
index d63c064d..a0aada64 100644
--- a/packages/shared/src/__tests__/llm-provider.test.ts
+++ b/packages/shared/src/__tests__/llm-provider.test.ts
@@ -6,13 +6,11 @@
  * Run: bun test packages/shared/src/__tests__/llm-provider.test.ts
  */
 import { describe, it, expect, beforeEach, afterEach } from 'bun:test';
-import { ALIBABA_MODELS } from '../llm-provider';
 
 // Save and restore env
 const savedEnv: Record<string, string | undefined> = {};
 
 beforeEach(() => {
-  savedEnv.ALIBABA_DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY;
   savedEnv.OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
   savedEnv.LLM_PROVIDER = process.env.LLM_PROVIDER;
 });
@@ -24,84 +22,50 @@ afterEach(() => {
   }
 });
 
-// ═══════════════════════════════════════════════════════════
-// Model catalog
-// ═══════════════════════════════════════════════════════════
-describe('LLM Provider — Model catalog', () => {
-  it('exports Alibaba test models', () => {
-    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
-    expect(ALIBABA_MODELS).toContain('qwen-plus');
-    expect(ALIBABA_MODELS).toContain('qwen-flash');
-  });
-
-  it('includes coder model', () => {
-    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
-  });
-});
-
 // ═══════════════════════════════════════════════════════════
 // Provider detection — throws when no API key
 // ═══════════════════════════════════════════════════════════
 describe('LLM Provider — API key validation', () => {
-  it('throws when ALIBABA key missing and alibaba provider requested', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
+  it('throws when OPENROUTER key missing and openrouter provider requested', async () => {
     delete process.env.OPENROUTER_API_KEY;
 
-    // Dynamic import to get fresh module state
     const { chatWithLLM } = await import('../llm-provider');
     try {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'qwen-plus',
-        provider: 'alibaba',
+        model: 'google/gemini-2.0-flash-001',
+        provider: 'openrouter',
       });
       expect(true).toBe(false); // should not reach
     } catch (e: unknown) {
-      expect((e as Error).message).toContain('ALIBABA_DASHSCOPE_API_KEY');
+      expect((e as Error).message).toContain('OPENROUTER_API_KEY');
     }
   });
 
-  it('throws when OPENROUTER key missing and openrouter provider requested', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-    delete process.env.OPENROUTER_API_KEY;
+  it('throws when GOOGLE key missing and google provider requested', async () => {
+    delete process.env.GOOGLE_AI_STUDIO_API_KEY;
 
     const { chatWithLLM } = await import('../llm-provider');
     try {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'google/gemini-2.0-flash-001',
-        provider: 'openrouter',
+        model: 'gemini-2.5-flash',
+        provider: 'google',
       });
       expect(true).toBe(false);
     } catch (e: unknown) {
-      expect((e as Error).message).toContain('OPENROUTER_API_KEY');
+      expect((e as Error).message).toContain('GOOGLE_AI_STUDIO_API_KEY');
     }
   });
 });
 
 // ═══════════════════════════════════════════════════════════
-// Provider auto-detection — qwen prefix → alibaba
+// Provider auto-detection
 // ═══════════════════════════════════════════════════════════
 describe('LLM Provider — Auto-detection', () => {
-  it('detects alibaba from qwen model prefix', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-    const { chatWithLLM } = await import('../llm-provider');
-    try {
-      await chatWithLLM({
-        systemPrompt: 'test',
-        userPrompt: 'test',
-        model: 'qwen-plus',
-      });
-    } catch (e: unknown) {
-      // Should throw about ALIBABA key, proving alibaba was detected
-      expect((e as Error).message).toContain('ALIBABA_DASHSCOPE_API_KEY');
-    }
-  });
-
-  it('falls back to openrouter for non-qwen models', async () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
+  it('falls back to openrouter for non-gemini models', async () => {
     delete process.env.OPENROUTER_API_KEY;
     delete process.env.LLM_PROVIDER;
     const { chatWithLLM } = await import('../llm-provider');
@@ -109,7 +73,7 @@ describe('LLM Provider — Auto-detection', () => {
       await chatWithLLM({
         systemPrompt: 'test',
         userPrompt: 'test',
-        model: 'google/gemini-2.0-flash',
+        model: 'google/gemini-2.0-flash-001',
       });
     } catch (e: unknown) {
       // Should throw about OPENROUTER key
diff --git a/packages/shared/src/__tests__/model-router.test.ts b/packages/shared/src/__tests__/model-router.test.ts
index a7cffa2d..dc129a5b 100644
--- a/packages/shared/src/__tests__/model-router.test.ts
+++ b/packages/shared/src/__tests__/model-router.test.ts
@@ -11,18 +11,10 @@ import { resolveModel, routeForChat, listAvailableModels, MODEL_CATALOG } from '
 const savedEnv: Record<string, string | undefined> = {};
 
 beforeEach(() => {
-  // Save current env
-  savedEnv.ALIBABA_DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY;
   savedEnv.OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
 });
 
 afterEach(() => {
-  // Restore env
-  if (savedEnv.ALIBABA_DASHSCOPE_API_KEY !== undefined) {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = savedEnv.ALIBABA_DASHSCOPE_API_KEY;
-  } else {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
-  }
   if (savedEnv.OPENROUTER_API_KEY !== undefined) {
     process.env.OPENROUTER_API_KEY = savedEnv.OPENROUTER_API_KEY;
   } else {
@@ -34,8 +26,8 @@ afterEach(() => {
 // Catalog integrity
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Catalog', () => {
-  it('has at least 5 models in catalog', () => {
-    expect(MODEL_CATALOG.length).toBeGreaterThanOrEqual(5);
+  it('has at least 3 models in catalog', () => {
+    expect(MODEL_CATALOG.length).toBeGreaterThanOrEqual(3);
   });
 
   it('every model has required fields', () => {
@@ -59,6 +51,11 @@ describe('Model Router — Catalog', () => {
     const premium = MODEL_CATALOG.filter(m => m.tier === 'premium');
     expect(premium.length).toBeGreaterThan(0);
   });
+
+  it('no model uses alibaba provider', () => {
+    const alibaba = MODEL_CATALOG.filter(m => m.provider === 'alibaba');
+    expect(alibaba.length).toBe(0);
+  });
 });
 
 // ═══════════════════════════════════════════════════════════
@@ -66,33 +63,30 @@ describe('Model Router — Catalog', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Routing', () => {
   it('routes fast_check to economy model', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'fast_check', cost: 'economy' });
     expect(route.profile.tier).toBe('economy');
   });
 
   it('routes orchestration with premium preference to premium model', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'orchestration', cost: 'premium' });
     expect(route.profile.tier).toBe('premium');
   });
 
-  it('prefers alibaba provider when specified', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+  it('prefers openrouter provider when specified', () => {
     process.env.OPENROUTER_API_KEY = 'test-key';
-    const route = resolveModel({ task: 'chat', preferProvider: 'alibaba' });
-    expect(route.provider).toBe('alibaba');
+    const route = resolveModel({ task: 'chat', preferProvider: 'openrouter' });
+    expect(route.provider).toBe('openrouter');
   });
 
   it('throws when no provider available', () => {
-    delete process.env.ALIBABA_DASHSCOPE_API_KEY;
     delete process.env.OPENROUTER_API_KEY;
     expect(() => resolveModel('chat')).toThrow('No LLM provider available');
   });
 
   it('accepts string shorthand for task', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel('summarization');
     expect(route.model).toBeTruthy();
     expect(route.provider).toBeTruthy();
@@ -104,7 +98,6 @@ describe('Model Router — Routing', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Context filtering', () => {
   it('filters by minContext requirement', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'analysis', minContext: 200000 });
     expect(route.profile.maxContext).toBeGreaterThanOrEqual(200000);
@@ -116,7 +109,7 @@ describe('Model Router — Context filtering', () => {
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — routeForChat', () => {
   it('returns model and provider only', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+    process.env.OPENROUTER_API_KEY = 'test-key';
     const result = routeForChat('chat');
     expect(result).toHaveProperty('model');
     expect(result).toHaveProperty('provider');
@@ -128,30 +121,13 @@ describe('Model Router — routeForChat', () => {
 // Cheap-first policy (EGOS-071)
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — Cheap-first policy', () => {
-  it('defaults to balanced tier (default cost preference)', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
-    // Default cost preference is 'balanced' (economy requires explicit opt-in)
-    const route = resolveModel('chat');
-    expect(route.profile.tier).toBe('balanced');
-  });
-
-  it('routes fast_check to free qwen-flash by default', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
-    const route = resolveModel('fast_check');
-    expect(route.model).toBe('qwen-flash');
-    expect(route.profile.costPer1MInput).toBe(0);
-  });
-
   it('breaks ties by lower cost', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
-    // summarization has multiple economy options - should pick cheapest
     const route = resolveModel('summarization');
     expect(route.profile.costPer1MInput).toBeLessThanOrEqual(0.1);
   });
 
   it('can override to premium when needed', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
     process.env.OPENROUTER_API_KEY = 'test-key';
     const route = resolveModel({ task: 'orchestration', cost: 'premium' });
     expect(route.profile.tier).toBe('premium');
@@ -162,13 +138,17 @@ describe('Model Router — Cheap-first policy', () => {
 // listAvailableModels
 // ═══════════════════════════════════════════════════════════
 describe('Model Router — listAvailableModels', () => {
-  it('marks models as available when env key is set', () => {
-    process.env.ALIBABA_DASHSCOPE_API_KEY = 'test-key';
+  it('marks openrouter models as available when key is set', () => {
+    process.env.OPENROUTER_API_KEY = 'test-key';
+    const models = listAvailableModels();
+    const openrouter = models.filter(m => m.provider === 'openrouter');
+    for (const m of openrouter) expect(m.available).toBe(true);
+  });
+
+  it('marks openrouter models as unavailable when key is missing', () => {
     delete process.env.OPENROUTER_API_KEY;
     const models = listAvailableModels();
-    const alibaba = models.filter(m => m.provider === 'alibaba');
     const openrouter = models.filter(m => m.provider === 'openrouter');
-    for (const m of alibaba) expect(m.available).toBe(true);
     for (const m of openrouter) expect(m.available).toBe(false);
   });
 });
diff --git a/scripts/debrief/pipeline.ts b/scripts/debrief/pipeline.ts
index bee23271..8f2f1472 100644
--- a/scripts/debrief/pipeline.ts
+++ b/scripts/debrief/pipeline.ts
@@ -6,7 +6,7 @@
  * 5-layer pipeline for processing client discovery meetings:
  *   L1: Groq Whisper   — audio → raw transcript
  *   L2: Gemini Flash   — contextual correction (legal/technical terms)
- *   L3: Qwen-plus      — structured JSON extraction (DPIO scoring, gaps, insights)
+ *   L3: OpenRouter gemini-2.0-flash-001 — structured JSON extraction (DPIO scoring, gaps, insights)
  *   L4: EGOS KB cross  — cross-reference with existing knowledge + gap detection
  *   L5: Persistence    — write to consulting/clientes/[slug]/ + Supabase
  *
@@ -34,9 +34,7 @@ const MANUAL_TEXT = process.argv.find(a => a.startsWith("--text="))?.slice(7)
 
 const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
 const GEMINI_KEY = process.env.GOOGLE_AI_STUDIO_API_KEY ?? "";
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL
-  ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
 
@@ -173,14 +171,14 @@ ${rawTranscript}` }] }],
   return data.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? rawTranscript;
 }
 
-// ─── L3: Qwen-plus structured JSON extraction ─────────────────────────────────
+// ─── L3: OpenRouter gemini-2.0-flash-001 — structured JSON extraction ─────────
 
 async function layer3Extract(transcript: string): Promise<DebriefInsights> {
-  if (!DASHSCOPE_KEY) {
-    console.log("  L3 Qwen: SKIP (no key) — using defaults");
+  if (!OPENROUTER_KEY) {
+    console.log("  L3 OpenRouter: SKIP (no key) — using defaults");
     return defaultInsights();
   }
-  console.log("  L3 Qwen-plus: extracting structured insights...");
+  console.log("  L3 OpenRouter gemini-2.0-flash-001: extracting structured insights...");
 
   const schema = `{
   "sector": "advocacia|contabilidade|agronomia|saude|policia|geral",
@@ -202,14 +200,16 @@ async function layer3Extract(transcript: string): Promise<DebriefInsights> {
   "confidence": <0.0-1.0: quão confiante está nessa extração>
 }`;
 
-  const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
+  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
     method: "POST",
     headers: {
-      Authorization: `Bearer ${DASHSCOPE_KEY}`,
+      Authorization: `Bearer ${OPENROUTER_KEY}`,
       "Content-Type": "application/json",
+      "HTTP-Referer": "https://egos.dev",
+      "X-Title": "egos",
     },
     body: JSON.stringify({
-      model: "qwen-plus",
+      model: "google/gemini-2.0-flash-001",
       messages: [
         {
           role: "system",
diff --git a/scripts/gem-hunter-digest.ts b/scripts/gem-hunter-digest.ts
index 03093517..77222b52 100644
--- a/scripts/gem-hunter-digest.ts
+++ b/scripts/gem-hunter-digest.ts
@@ -31,10 +31,6 @@ const DAYS_BACK = parseInt(
 
 const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
 const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
-const DASHSCOPE_API_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
-const DASHSCOPE_BASE_URL =
-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
-  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
 const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY ?? "";
 const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN ?? "";
 const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID ?? "";
@@ -125,47 +121,23 @@ Description: ${gem.description.slice(0, 300)}
 
 Write a single sentence (max 120 chars) explaining WHY this repo matters to developers building AI agents or data-compliance tools. Be concrete, not hype. Answer in English.`;
 
-  const body = JSON.stringify({
-    model: "qwen-plus",
-    messages: [{ role: "user", content: prompt }],
-    max_tokens: 100,
-    temperature: 0.4,
-  });
-
-  // Primary: DashScope
-  if (DASHSCOPE_API_KEY) {
-    try {
-      const res = await fetch(`${DASHSCOPE_BASE_URL}/chat/completions`, {
-        method: "POST",
-        headers: {
-          "Content-Type": "application/json",
-          Authorization: `Bearer ${DASHSCOPE_API_KEY}`,
-        },
-        body,
-        signal: AbortSignal.timeout(10000),
-      });
-      if (res.ok) {
-        const data = (await res.json()) as {
-          choices?: { message?: { content?: string } }[];
-        };
-        const text = data.choices?.[0]?.message?.content?.trim() ?? "";
-        if (text) return { text: text.slice(0, 200), provider: "alibaba/qwen-plus" };
-      }
-    } catch {
-      // fall through to OpenRouter
-    }
-  }
-
-  // Fallback: OpenRouter free
+  // Primary: OpenRouter
   if (OPENROUTER_API_KEY) {
     try {
       const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
         method: "POST",
         headers: {
           "Content-Type": "application/json",
-          Authorization: `Bearer ${OPENROUTER_API_KEY}`,
+          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
+          "HTTP-Referer": "https://egos.dev",
+          "X-Title": "egos",
         },
-        body: JSON.stringify({ ...JSON.parse(body), model: "google/gemma-4-26b-a4b-it:free" }),
+        body: JSON.stringify({
+          model: "google/gemini-2.0-flash-001",
+          messages: [{ role: "user", content: prompt }],
+          max_tokens: 100,
+          temperature: 0.4,
+        }),
         signal: AbortSignal.timeout(15000),
       });
       if (res.ok) {
@@ -173,7 +145,7 @@ Write a single sentence (max 120 chars) explaining WHY this repo matters to deve
           choices?: { message?: { content?: string } }[];
         };
         const text = data.choices?.[0]?.message?.content?.trim() ?? "";
-        if (text) return { text: text.slice(0, 200), provider: "openrouter/gemma-4-26b" };
+        if (text) return { text: text.slice(0, 200), provider: "openrouter/gemini-2.0-flash-001" };
       }
     } catch {
       // no LLM available
diff --git a/scripts/manifest-generator.ts b/scripts/manifest-generator.ts
index efcef679..1a4b3f4c 100644
--- a/scripts/manifest-generator.ts
+++ b/scripts/manifest-generator.ts
@@ -3,7 +3,7 @@
  * manifest-generator.ts — DRIFT-011
  *
  * Auto-generates or updates .egos-manifest.yaml from a repo's README.md
- * using LLM extraction (Gemini Flash → Alibaba Qwen → regex fallback).
+ * using LLM extraction (OpenRouter gemini-2.0-flash-001 → Gemini Flash → regex fallback).
  *
  * Extracts quantitative claims like:
  *   - "83.7M nodes" → claim: neo4j_nodes
@@ -39,7 +39,7 @@ const GEMINI_KEY =
   process.env.GEMINI_API_KEY ||
   ""; // hardcoded key removed (SEC) — set GOOGLE_AI_STUDIO_API_KEY or GEMINI_API_KEY
 
-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
+const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -222,29 +222,31 @@ Return [] if no quantitative claims found. JSON array only, no markdown.`;
   }
 }
 
-// ─── LLM extraction via Alibaba ───────────────────────────────────────────────
+// ─── LLM extraction via OpenRouter ───────────────────────────────────────────
 
-async function llmExtractAlibaba(
+async function llmExtractOpenRouter(
   repoName: string,
   readmeContent: string
 ): Promise<ExtractedClaim[]> {
-  if (!DASHSCOPE_KEY) return [];
+  if (!OPENROUTER_KEY) return [];
 
   const prompt = `Extract quantitative claims from README. JSON array: [{"id":"snake_id","description":"...","value":"numeric_string","unit":"...","raw":"..."}]
 README: ${readmeContent.slice(0, 1000)}`;
 
   try {
     const controller = new AbortController();
-    const timeout = setTimeout(() => controller.abort(), 8000);
+    const timeout = setTimeout(() => controller.abort(), 15000);
 
-    const resp = await fetch("https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions", {
+    const resp = await fetch("https://openrouter.ai/api/v1/chat/completions", {
       method: "POST",
       headers: {
-        "Authorization": `Bearer ${DASHSCOPE_KEY}`,
+        "Authorization": `Bearer ${OPENROUTER_KEY}`,
         "Content-Type": "application/json",
+        "HTTP-Referer": "https://egos.dev",
+        "X-Title": "egos",
       },
       body: JSON.stringify({
-        model: "qwen-turbo",
+        model: "google/gemini-2.0-flash-001",
         messages: [{ role: "user", content: prompt }],
         max_tokens: 800,
         temperature: 0,
@@ -350,12 +352,12 @@ async function processRepo(repoDir: string, dry: boolean): Promise<void> {
   console.log(`\n── ${repoName}`);
 
   // Try LLM first, fall back to regex
-  let claims = await llmExtractGemini(repoName, content);
-  let method = "gemini";
+  let claims = await llmExtractOpenRouter(repoName, content);
+  let method = "openrouter";
 
   if (claims.length === 0) {
-    claims = await llmExtractAlibaba(repoName, content);
-    method = "alibaba";
+    claims = await llmExtractGemini(repoName, content);
+    method = "gemini";
   }
 
   if (claims.length === 0) {
@@ -394,7 +396,7 @@ const repos = all
   : [process.cwd()];
 
 console.log(`\n🧠 Manifest Generator${dry ? " (dry)" : ""} — ${repos.length} repo(s)`);
-console.log(`   Strategy: Gemini Flash → Alibaba Qwen → regex`);
+console.log(`   Strategy: OpenRouter gemini-2.0-flash-001 → Gemini Flash → regex`);
 
 for (const repo of repos) {
   await processRepo(repo, dry);

exec
/bin/bash -lc 'git diff e8ee9b6507520d3867ca86e3a06c16cce4e8357d -- apps/egos-landing/src/App.tsx apps/egos-landing/src/components/MyceliumPage.tsx packages/mcp-ops/src/index.ts packages/shared/src/index.ts packages/shared/src/llm-orchestrator.ts packages/shared/src/metrics-tracker.ts scripts/ai-coverage-scan.ts scripts/context-manager.ts scripts/doctor.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index ba3c38a8..1aca1271 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -475,13 +475,13 @@ function App() {
                 onClick={() => navigateTo('grok')}
                 style={{ color: currentRoute === 'grok' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Grok Hunter
+                Checador de IA
               </button>
               <button
                 onClick={() => navigateTo('mycelium')}
                 style={{ color: currentRoute === 'mycelium' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Mycelium
+                Rede de conhecimento
               </button>
             </div>
           )}
@@ -537,8 +537,8 @@ function App() {
             { route: 'transparencia', label: 'Transparência' },
             { route: 'guard', label: 'Guard Brasil' },
             { route: 'tools', label: 'Ferramentas' },
-            { route: 'grok', label: 'Grok Hunter' },
-            { route: 'mycelium', label: 'Mycelium' },
+            { route: 'grok', label: 'Checador de IA' },
+            { route: 'mycelium', label: 'Rede de conhecimento' },
           ] as { route: string; label: string }[]).map(({ route, label }) => (
             <button
               key={route || 'home'}
@@ -567,16 +567,16 @@ function App() {
             <div>
               {/* Hero Banner */}
               <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>Framework de IA Governada</span>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
                 <h1 className="display-xl" style={{ marginBottom: '24px' }}>
-                  IA que você pode <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>auditar, explicar e controlar</span>
+                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
                 </h1>
                 <p className="body-l muted" style={{ marginBottom: '32px' }}>
-                  EGOS é um framework de orquestração de agentes com governança embutida — rastreabilidade por design, conformidade LGPD, e gates de segurança que rodam antes de qualquer dado sair da sua máquina.
+                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
                 </p>
                 <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
-                  <a href="https://egos.ia.br/tools" className="btn btn-primary">Usar ferramentas →</a>
-                  <button onClick={() => navigateTo('timeline')} className="btn btn-ghost">Ver builds ao vivo</button>
+                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
+                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
                 </div>
               </section>
 
@@ -585,31 +585,59 @@ function App() {
                 <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
                 <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px' }}>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Governança</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🎯</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>1. Escolha seu tipo de trabalho</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      Regras constitucionais com precedência T0→T4. Cada decisão de agente é classificada antes de executar. Gates pré-commit bloqueiam dado sensível.
+                      O EGOS parte da sua realidade — advocacia, clínica, contabilidade, comércio, sala de aula. Assim a IA recebe instruções claras do que fazer e do que evitar.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🤖</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Agentes</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>2. Proteja as informações sensíveis</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      12 papéis especializados (Guardião, Curador, Investigador, Sentinela…) com escopo definido e HITL obrigatório em Red Zones.
+                      Antes de mandar algo para a IA, o EGOS ajuda a identificar dados como CPF, CNPJ, prontuário e dados de cliente — para diminuir o risco de expor o que não deve sair do seu controle.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>⚙️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Ferramentas</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>✅</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>3. Confira antes de confiar</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      MCPs, Guard Brasil (PII), eval-runner com casos dourados, e pipelines auditáveis. Cada capability tem evidência — stub sem teste é code morto.
+                      O EGOS organiza a resposta da IA para você separar o que é fato, o que precisa de conferência e o que é só sugestão. A decisão final continua com você.
                     </p>
                   </div>
                 </div>
               </section>
 
-              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              {/* ── Como você usa na sua área ── */}
               <section style={{ margin: '56px 0' }}>
+                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
+                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Para o seu dia a dia</span>
+                  <h2 className="h2">Como você usa na sua área</h2>
+                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
+                    O EGOS se adapta ao seu trabalho. Alguns exemplos de quem já pode usar hoje.
+                  </p>
+                </div>
+                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px' }}>
+                  {[
+                    { icon: '⚖️', area: 'Advogado', problema: 'Analisar documentos e responder clientes sem expor dados do processo.', ajuda: 'Um assistente que lê documentos com cuidado, responde pelo WhatsApp e guarda registro de cada atendimento.' },
+                    { icon: '🩺', area: 'Médico / Clínica', problema: 'Usar IA no dia a dia sem expor prontuário ou dados de paciente.', ajuda: 'Mostra como usar IA com os dados protegidos e revisão humana antes de qualquer orientação sensível.' },
+                    { icon: '🧾', area: 'Contador', problema: 'Dados fiscais, CPF e CNPJ passam por muitas tarefas repetitivas.', ajuda: 'Ajuda a organizar as informações para análise sem tratar dado sensível como texto comum.' },
+                    { icon: '🍽️', area: 'Comércio / Restaurante', problema: 'Cardápio e catálogo vivem em foto, papel ou mensagem de WhatsApp.', ajuda: 'Transforma a foto do cardápio ou catálogo em planilha pronta — com conferência humana antes de cadastrar.' },
+                    { icon: '📚', area: 'Professor', problema: 'IA cria material bonito, mas às vezes com erro ou fonte fraca.', ajuda: 'Organiza aulas, exercícios e resumos com pontos de conferência antes de usar com os alunos.' },
+                    { icon: '🌾', area: 'Agrônomo', problema: 'Laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.', ajuda: 'Um assistente da área que organiza as informações e destaca o que precisa ser validado por um profissional.' },
+                  ].map((c) => (
+                    <div key={c.area} className="card" style={{ padding: '28px' }}>
+                      <div style={{ fontSize: '28px', marginBottom: '12px' }}>{c.icon}</div>
+                      <h3 className="h3" style={{ marginBottom: '8px' }}>{c.area}</h3>
+                      <p style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.6, marginBottom: '10px' }}>{c.problema}</p>
+                      <p style={{ fontSize: '14px', color: 'var(--text-strong)', lineHeight: 1.6 }}>{c.ajuda}</p>
+                    </div>
+                  ))}
+                </div>
+              </section>
+
+              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              <section id="comece" style={{ margin: '56px 0' }}>
                 <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                   <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
                   <h2 className="h2">Comece aqui</h2>
@@ -1258,8 +1286,8 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
           {currentRoute === 'grok' && (
             <div>
               <section style={{ textAlign: 'center', marginBottom: '40px' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Inteligência em Tempo Real (X.com)</span>
-                <h1 className="h2">Grok Hunter Assistant</h1>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Pesquisa de tendências com IA</span>
+                <h1 className="h2">Checador de IA</h1>
                 <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '12px auto 0' }}>
                   Gere prompts otimizados para buscar tendências, repositórios e artigos no Grok e importe de graça no EGOS.
                 </p>
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 9e5abbd4..63e0a41d 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -330,7 +330,7 @@ export function MyceliumPage() {
             Sistema vivo · tempo real
           </span>
           <h1 style={{ fontSize: '30px', fontWeight: 800, color: 'var(--text-strong)', margin: '0 0 10px' }}>
-            Mycelium — o EGOS por dentro
+            Rede de conhecimento — o EGOS por dentro
           </h1>
           <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '0 auto', fontSize: '14px', lineHeight: 1.6 }}>
             Cada nó é uma peça real do sistema. As linhas são as conexões — quem fala com quem.
diff --git a/packages/mcp-ops/src/index.ts b/packages/mcp-ops/src/index.ts
index 30ac0345..5c62b98c 100644
--- a/packages/mcp-ops/src/index.ts
+++ b/packages/mcp-ops/src/index.ts
@@ -69,9 +69,7 @@ const MODELS = [
   { id: "gpt-5.3-codex", provider: "openai", role: "scaffolding", cost_per_1m: 5.0, quota: "plus_20" },
   { id: "gpt-5.5", provider: "openai", role: "adversarial-review", cost_per_1m: 30.0, quota: "plus_20_rare" },
   { id: "gemini-2.0-flash", provider: "google", role: "implementation", cost_per_1m: 0.075 },
-  { id: "qwen-turbo", provider: "alibaba", role: "fast-briefing", cost_per_1m: 0 },
-  { id: "qwen-plus", provider: "alibaba", role: "implementation", cost_per_1m: 0 },
-  { id: "qwen-max", provider: "alibaba", role: "architecture", cost_per_1m: 0 },
+  { id: "google/gemini-2.0-flash-001", provider: "openrouter", role: "primary", cost_per_1m: 0.1 },
 ];
 
 // ── MCP Server ─────────────────────────────────────────────────────────────
@@ -86,7 +84,7 @@ server.registerTool(
   {
     description: "List available LLM models in the EGOS llm-router registry.",
     inputSchema: {
-      provider: z.enum(["anthropic", "openai", "google", "alibaba", "all"]).optional(),
+      provider: z.enum(["anthropic", "openai", "google", "openrouter", "all"]).optional(),
     } as any,
   },
   (async ({ provider = "all" }: { provider?: string }) => {
diff --git a/packages/shared/src/index.ts b/packages/shared/src/index.ts
index 8e2ad0ea..23b5fd62 100644
--- a/packages/shared/src/index.ts
+++ b/packages/shared/src/index.ts
@@ -5,7 +5,7 @@
  * Domain-specific utilities (OSINT, social, etc.) live in leaf repos.
  */
 
-export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
+export { chatWithLLM, chatWithLLM as analyzeWithAI } from './llm-provider';
 export type { SharedLLMProvider } from './llm-provider';
 export { resolveModel, routeForChat, listAvailableModels, MODEL_CATALOG } from './model-router';
 export type { TaskType, CostPreference, RouteOptions, ResolvedRoute, ModelProfile } from './model-router';
diff --git a/packages/shared/src/llm-orchestrator.ts b/packages/shared/src/llm-orchestrator.ts
index 1ee63df0..cf99a5fc 100644
--- a/packages/shared/src/llm-orchestrator.ts
+++ b/packages/shared/src/llm-orchestrator.ts
@@ -1,12 +1,12 @@
 /**
  * LLM Orchestrator — Multi-Model Economic Routing
- * 
+ *
  * Orquestra chamadas LLM priorizando modelos mais baratos quando possível.
- * Usa qwen-plus apenas para tasks complexas que justificam o custo.
+ * Usa OpenRouter para todas as chamadas (free tier quando disponível).
  */
 
 export type TaskComplexity = 'simple' | 'moderate' | 'complex';
-export type LLMProvider = 'alibaba' | 'openrouter' | 'openai';
+export type LLMProvider = 'openrouter' | 'openai';
 
 export interface ModelConfig {
   provider: LLMProvider;
@@ -17,22 +17,22 @@ export interface ModelConfig {
 }
 
 export const MODEL_REGISTRY: Record<string, ModelConfig> = {
-  // Alibaba DashScope
+  // OpenRouter (Qwen via OpenRouter)
   'qwen-turbo': {
-    provider: 'alibaba',
-    model: 'qwen-turbo',
-    costPer1kTokens: 0.002, // ~$0.002/1k tokens (estimado)
+    provider: 'openrouter',
+    model: 'qwen/qwen3-coder:free',
+    costPer1kTokens: 0.0,
     maxTokens: 8000,
     bestFor: ['simple'],
   },
   'qwen-plus': {
-    provider: 'alibaba',
-    model: 'qwen-plus',
-    costPer1kTokens: 0.008, // ~$0.008/1k tokens (estimado)
+    provider: 'openrouter',
+    model: 'openai/gpt-oss-120b:free',
+    costPer1kTokens: 0.0,
     maxTokens: 32000,
     bestFor: ['moderate', 'complex'],
   },
-  
+
   // OpenRouter (via Gemini)
   'gemini-flash': {
     provider: 'openrouter',
diff --git a/packages/shared/src/metrics-tracker.ts b/packages/shared/src/metrics-tracker.ts
index 4e6519b3..f825e8fb 100644
--- a/packages/shared/src/metrics-tracker.ts
+++ b/packages/shared/src/metrics-tracker.ts
@@ -8,7 +8,7 @@
  */
 
 export interface ToolUsageMetric {
-  tool: 'hermes' | 'alibaba' | 'claude_code' | 'openrouter' | 'dashscope' | 'gemini' | 'cascade' | 'other';
+  tool: 'hermes' | 'claude_code' | 'openrouter' | 'gemini' | 'cascade' | 'other';
   operation: string;
   timestamp: string;
   durationMs?: number;
diff --git a/scripts/ai-coverage-scan.ts b/scripts/ai-coverage-scan.ts
index bfc37d2e..4d0fda07 100644
--- a/scripts/ai-coverage-scan.ts
+++ b/scripts/ai-coverage-scan.ts
@@ -30,12 +30,12 @@ const AI_PATTERNS = [
   "anthropic\\.messages",
   "gemini\\.generateContent",
   "fetch.*openrouter",
-  "fetch.*dashscope",
+  "fetch.*openrouter",
   "fetch.*openai",
   "createMessage",
   "chat\\.completions\\.create",
   "openrouter\\.ai/api",
-  "dashscope-intl\\.aliyuncs\\.com",
+  "openrouter\\.ai/api",
   "googleapis.*generativelanguage",
 ];
 
diff --git a/scripts/context-manager.ts b/scripts/context-manager.ts
index cb02a311..8316338e 100755
--- a/scripts/context-manager.ts
+++ b/scripts/context-manager.ts
@@ -124,8 +124,8 @@ class ContextManager {
     const llmConfig: { primary?: string; fallback?: string } = {};
     try {
       const envContent = await fs.readFile(path.join(cwd, '.env'), 'utf-8');
-      if (envContent.includes('ALIBABA_DASHSCOPE_API_KEY')) llmConfig.primary = 'Alibaba Qwen';
-      if (envContent.includes('OPENROUTER_API_KEY')) llmConfig.fallback = 'OpenRouter';
+      if (envContent.includes('OPENROUTER_API_KEY')) llmConfig.primary = 'OpenRouter';
+      if (envContent.includes('GOOGLE_AI_STUDIO_API_KEY')) llmConfig.fallback = 'Google AI Studio';
     } catch (e) {
       // .env não encontrado
     }
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index 4bb91330..07feb407 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -124,7 +124,7 @@ const results: CheckResult[] = [];
 
 // ─── 1. Environment Variables ───
 function checkEnvironmentVariables() {
-  const required = ['ALIBABA_DASHSCOPE_API_KEY', 'OPENROUTER_API_KEY'];
+  const required = ['OPENROUTER_API_KEY'];
   const optional = [
     'OPENAI_API_KEY',
     'GROQ_API_KEY',
@@ -189,7 +189,6 @@ function checkFileFreshness() {
 // ─── 3. Provider Readiness ───
 async function checkProviderReadiness() {
   const providers = [
-    { name: 'Alibaba DashScope', url: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/models', envKey: 'ALIBABA_DASHSCOPE_API_KEY' },
     { name: 'OpenRouter', url: 'https://openrouter.ai/api/v1/models', envKey: 'OPENROUTER_API_KEY' },
     { name: 'OpenAI', url: 'https://api.openai.com/v1/models', envKey: 'OPENAI_API_KEY', optional: true },
   ];

exec
/bin/bash -lc "grep -R \"ALIBABA_DASHSCOPE\\|dashscope\" -n --exclude-dir=node_modules --exclude-dir=.git . | head -100" in /home/enio/egos
 succeeded in 841ms:
./docs/jobs/_archived/2026-04/2026-04-09-code-security.md:101:- **Sensitive vars:** SUPABASE_KEY, EVOLUTION_API_KEY, ALIBABA_DASHSCOPE_API_KEY — all loaded from env, never committed
./docs/jobs/_archived/2026-04/2026-04-30-code-security-audit.md:99:- `ALIBABA_DASHSCOPE_API_KEY`
./docs/jobs/_archived/2026-04/2026-04-30-code-security-audit.md:109:envKey: 'ALIBABA_DASHSCOPE_API_KEY',  // config reference, not literal
./docs/agents/start.md:551:echo -n "Alibaba Qwen: "; grep -q ALIBABA_DASHSCOPE .env 2>/dev/null && echo "✅" || echo "❌"
./docs/CAPABILITY_REGISTRY.md:186:| DashScope Fallback Chain | `egos/packages/shared/src/llm-provider.ts` | A | egos, egos-lab | 852, forja | `ai`, `dashscope`, `fallback` |
./docs/CAPABILITY_REGISTRY.md:634:| Hermes LLM Provider | `packages/shared/src/llm-providers/hermes.ts` | A | egos | `dashscope`, `qwen-plus`, `openrouter`, `fallback-chain` |
./docs/CAPABILITY_REGISTRY.md:637:| Constitutional Review (migrated) | `apps/egos-hq/app/api/hq/actions/codex-review/route.ts` | A | egos-hq | `governance`, `review`, `dashscope` |
./docs/CAPABILITY_REGISTRY.md:641:| X Opportunity LLM Analysis | `scripts/x-opportunity-alert.ts#analyzeWithLLM` | A | egos | `x.com`, `ai-analysis`, `telegram`, `dashscope` |
./docs/CAPABILITY_REGISTRY.md:644:1. Alibaba DashScope `qwen-plus` — `ALIBABA_DASHSCOPE_API_KEY` + `dashscope-intl.aliyuncs.com/compatible-mode/v1`
./docs/CAPABILITY_REGISTRY.md:650:- Config: `/root/.hermes/config.yaml` → **`provider: alibaba`** (NOT `alibaba_dashscope` — that id is unknown to hermes' models.dev catalog and silently falls back to OpenRouter), `model: qwen-plus`
./docs/CAPABILITY_REGISTRY.md:651:- .env: `/root/.hermes/.env` → hermes' `alibaba` provider reads **`DASHSCOPE_API_KEY`** (register the pooled cred with `hermes auth add alibaba --type api-key --api-key env:DASHSCOPE_API_KEY`). TS scripts read `ALIBABA_DASHSCOPE_API_KEY` — keep both in sync.
./docs/CAPABILITY_REGISTRY.md:702:- **Auth (2026-04-08):** DashScope qwen-plus via `ALIBABA_DASHSCOPE_API_KEY`. OpenRouter free as fallback. Anthropic OAuth removed (key invalid).
./docs/CAPABILITY_REGISTRY.md:704:- **Config:** `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
./docs/CAPABILITY_REGISTRY.md:830:LEARNING: DashScope requires dashscope-intl endpoint (not dashscope) for international access
./docs/products-specs/forja.md:72:cp .env.example .env  # NEXT_PUBLIC_SUPABASE_URL, OPENROUTER_API_KEY, ALIBABA_DASHSCOPE_API_KEY
./docs/governance/INTEGRATION_REGISTRY.md:50:| **Alibaba DashScope** | Qwen models (flash/plus/max/qwq) | API Key | — | `packages/shared/src/llm-provider.ts` (provider `'alibaba'`, env `ALIBABA_DASHSCOPE_API_KEY`) | ✅ prod (LLM primary) |
./docs/governance/MCP_ENV_VARS_REFERENCE.md:74:- Alibaba DashScope: https://dashscope.console.aliyun.com/api-key
./docs/governance/AUTORESEARCH_SSOT.md:147:# ALIBABA_DASHSCOPE_API_KEY (primário — Qwen-Plus)
./docs/governance/AI_COVERAGE_MAP.md:80:**Coverage notes:** DashScope endpoint `dashscope-intl.aliyuncs.com` (Singapore). `isRateLimitError()` detects 429/503 for automatic fallback.
./docs/governance/ACTIVATION_GUIDE.md:26:export ALIBABA_DASHSCOPE_API_KEY="your_key"   # For Qwen models
./docs/governance/ACTIVATION_GUIDE.md:295:| Alibaba | ALIBABA_DASHSCOPE_API_KEY | ✅ Have | Windsurf config |
./docs/_archived_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md:4:- **Alibaba investigation** — chave morta (401) nas 3 superfícies; VPS root cause `provider: alibaba_dashscope`→`alibaba` (+`DASHSCOPE_API_KEY`); rotacionada + validada e2e (qwen-plus PONG). Não commitado (ops VPS + rotação de secret).
./docs/_archived_handoffs/handoff_2026-03-22_session.md:17:* **API Testing / Security**: Refizemos o teste na `dashscope.aliyuncs.com` com a nova chave da Alibaba (sk-bcab09...). O token demonstrou ser válido (sem erro no parsing auth), mas entrou em **Timeout** absoluto de rede a partir do VPS Contabo.
./docs/_archived_handoffs/handoff_2026-03-22_session_final.md:39:- **Alibaba DashScope**: ✅ Configured (`ALIBABA_DASHSCOPE_API_KEY`)
./docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md:10:- **3-provider fallback chain** — [models.json](~/.openclaw/agents/main/agent/models.json): `anthropic-subscription/haiku` → `openrouter/qwen3-235b:free` → `dashscope/qwen-turbo`. VPS version uses `172.19.0.1:18801`.
./docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:35:Base URL: https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:122:1. Crie conta: https://dashscope.console.aliyun.com
./docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:125:   - **Custom Base URL**: `https://dashscope-intl.aliyuncs.com/compatible-mode/v1`
./docs/_archived_handoffs/2026-05/OPENCLAW_SSOT.md:66:| `dashscope` | `openai-completions` | qwen-turbo, qwen-plus, qwen3-235b-a22b | Alibaba API — cheap paid fallback |
./docs/_archived_handoffs/2026-05/OPENCLAW_SSOT.md:76:**To use subscription models:** set `agents.defaults.model: "anthropic-subscription/claude-haiku-4-5-20251001"` for default (Haiku). Fallback chain: `openrouter/qwen3-235b:free` → `dashscope/qwen-turbo`. Sonnet for complex tasks only..
./docs/_archived_handoffs/2026-05/OBSIDIAN_MCP_SETUP_GUIDE.md:45:1. Acesse: https://dashscope.console.aliyun.com
./docs/_archived_handoffs/2026-05/OBSIDIAN_MCP_SETUP_GUIDE.md:63:Base URL: https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./docs/_archived_handoffs/handoff_2026-05-31-guarani-close.md:167:- **Missing Environment Keys**: O script `doctor` reporta falha em variáveis `ALIBABA_DASHSCOPE_API_KEY` e `OPENROUTER_API_KEY`. Embora funcionais no terminal do Enio, elas precisam ser adicionadas aos ambientes locais de debug (`.env.local`) de forma segura.
./docs/_generated/doctor-report.json:9:      "item": "ALIBABA_DASHSCOPE_API_KEY",
./docs/stack/PROVIDER_ROUTING.md:26:| Alibaba DashScope (global) | `https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions` |
./docs/stack/PROVIDER_ROUTING.md:27:| Alibaba DashScope (domestic) | `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` |
./docs/knowledge/LLM_MODEL_MONITOR.md:235:    { model: 'qwen-plus', provider: 'dashscope', tier: 'S' },
./docs/knowledge/LLM_MODEL_MONITOR.md:247:    { model: 'qwen-plus', provider: 'dashscope', tier: 'S' },
./docs/knowledge/HARVEST.md:2441:- DashScope endpoint: `dashscope-intl.aliyuncs.com` (Singapore — not mainland China endpoint)
./docs/knowledge/HARVEST.md:3070:3. `dashscope` → qwen-turbo (Alibaba, very cheap, 1M context)
./docs/knowledge/HARVEST.md:3080:    "dashscope": {"api": "openai-completions", "apiKey": "sk-...", "baseUrl": "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"}
./docs/knowledge/HARVEST.md:3917:- **DashScope URL:** `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions`
./docs/modules/CHATBOT_SSOT.md:488:      providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY',
./docs/modules/CHATBOT_SSOT.md:489:      baseUrl: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions',
./docs/modules/CHATBOT_SSOT.md:544:    fallback: { modelId: 'qwen-plus', providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY',
./docs/modules/CHATBOT_SSOT.md:545:                baseUrl: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions' },
./docs/modules/TELEMETRY_SSOT.md:265:  system?: 'vercel' | 'supabase' | 'vps' | 'ali_dashscope';
./docs/modules/HERMES_SSOT.md:47:| 1 | Alibaba DashScope | `qwen-plus` | `dashscope-intl.aliyuncs.com/compatible-mode/v1` | `ALIBABA_DASHSCOPE_API_KEY` | Free tier (8 models) |
./docs/modules/HERMES_SSOT.md:83:provider: alibaba_dashscope
./docs/modules/HERMES_SSOT.md:90:ALIBABA_DASHSCOPE_API_KEY=<set>
./docs/modules/HERMES_SSOT.md:91:ALIBABA_DASHSCOPE_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./docs/modules/HERMES_SSOT.md:136:| HTTP 401 from DashScope | Wrong endpoint (cn vs intl) | Use `dashscope-intl.aliyuncs.com`, not `dashscope.aliyuncs.com` |
./docs/modules/DOCTOR_COMMAND_SPEC.md:41:- `ALIBABA_DASHSCOPE_API_KEY` - Primary LLM provider
./docs/modules/DOCTOR_COMMAND_SPEC.md:68:- Alibaba DashScope: `https://dashscope-intl.aliyuncs.com/compatible-mode/v1/models`
./docs/audits/ECOSYSTEM_AUDIT.md:128:https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./docs/audits/ECOSYSTEM_AUDIT.md:151:DASHSCOPE_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./docs/audits/INTEGRATION_COVERAGE_2026-05-30.md:74:| 5 | **Alibaba DashScope (Qwen)** | `packages/shared/src/llm-provider.ts:127-140` (env `ALIBABA_DASHSCOPE_API_KEY`), múltiplos modelos Qwen | ✅ prod |
./docs/audits/INTEGRATION_COVERAGE_2026-05-30.md:163:+ | **Alibaba DashScope** | Qwen models (flash/plus/max/qwq) | API Key | — | `packages/shared/src/llm-provider.ts` (provider `'alibaba'`, env `ALIBABA_DASHSCOPE_API_KEY`) | ✅ prod (LLM primary) |
./docs/audits/INCIDENT_RESPONSE_MCP.md:35:  - **DashScope:** https://dashscope.console.aliyun.com/api-key → revoke
./.github/workflows/gem-hunter-adaptive.yml:43:          ALIBABA_DASHSCOPE_API_KEY: ${{ secrets.ALIBABA_DASHSCOPE_API_KEY }}
./.env.backup-2026-05-27-pre-keyrot:7:ALIBABA_DASHSCOPE_API_KEY=sk-d2c***REDACTED***
./.env.backup-2026-05-27-pre-keyrot:8:ALIBABA_DASHSCOPE_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./.env.backup-1777031943:7:ALIBABA_DASHSCOPE_API_KEY=sk-d2c***REDACTED***
./.env.backup-1777031943:8:ALIBABA_DASHSCOPE_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./.obsidian-llm-config.json:6:      "base_url": "https://dashscope-intl.aliyuncs.com/compatible-mode/v1",
./.obsidian-llm-config.json:45:    "custom_model_url": "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
./.obsidian/plugins/egos-llm-connector/main.js:116:      href: "https://dashscope.console.aliyun.com/apiKey"
./.obsidian/plugins/egos-llm-connector/main.js:137:  alibabaBaseUrl: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1",
./.claude/settings.local.json:68:      "Bash(if grep -q \"ALIBABA_DASHSCOPE_API_KEY\" .env)",
./.claude/worktrees/agent-ac1433679f0d59800/docs/jobs/2026-04-09-code-security.md:101:- **Sensitive vars:** SUPABASE_KEY, EVOLUTION_API_KEY, ALIBABA_DASHSCOPE_API_KEY — all loaded from env, never committed
./.claude/worktrees/agent-ac1433679f0d59800/docs/jobs/2026-04-30-code-security-audit.md:99:- `ALIBABA_DASHSCOPE_API_KEY`
./.claude/worktrees/agent-ac1433679f0d59800/docs/jobs/2026-04-30-code-security-audit.md:109:envKey: 'ALIBABA_DASHSCOPE_API_KEY',  // config reference, not literal
./.claude/worktrees/agent-ac1433679f0d59800/docs/agents/start.md:551:echo -n "Alibaba Qwen: "; grep -q ALIBABA_DASHSCOPE .env 2>/dev/null && echo "✅" || echo "❌"
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:158:| DashScope Fallback Chain | `egos/packages/shared/src/llm-provider.ts` | A | egos, egos-lab | 852, forja | `ai`, `dashscope`, `fallback` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:606:| Hermes LLM Provider | `packages/shared/src/llm-providers/hermes.ts` | A | egos | `dashscope`, `qwen-plus`, `openrouter`, `fallback-chain` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:609:| Constitutional Review (migrated) | `apps/egos-hq/app/api/hq/actions/codex-review/route.ts` | A | egos-hq | `governance`, `review`, `dashscope` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:613:| X Opportunity LLM Analysis | `scripts/x-opportunity-alert.ts#analyzeWithLLM` | A | egos | `x.com`, `ai-analysis`, `telegram`, `dashscope` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:616:1. Alibaba DashScope `qwen-plus` — `ALIBABA_DASHSCOPE_API_KEY` + `dashscope-intl.aliyuncs.com/compatible-mode/v1`
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:622:- Config: `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:673:- **Auth (2026-04-08):** DashScope qwen-plus via `ALIBABA_DASHSCOPE_API_KEY`. OpenRouter free as fallback. Anthropic OAuth removed (key invalid).
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:675:- **Config:** `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
./.claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md:785:LEARNING: DashScope requires dashscope-intl endpoint (not dashscope) for international access
./.claude/worktrees/agent-ac1433679f0d59800/docs/governance/MCP_ENV_VARS_REFERENCE.md:74:- Alibaba DashScope: https://dashscope.console.aliyun.com/api-key
./.claude/worktrees/agent-ac1433679f0d59800/docs/governance/AI_COVERAGE_MAP.md:80:**Coverage notes:** DashScope endpoint `dashscope-intl.aliyuncs.com` (Singapore). `isRateLimitError()` detects 429/503 for automatic fallback.
./.claude/worktrees/agent-ac1433679f0d59800/docs/governance/ACTIVATION_GUIDE.md:26:export ALIBABA_DASHSCOPE_API_KEY="your_key"   # For Qwen models
./.claude/worktrees/agent-ac1433679f0d59800/docs/governance/ACTIVATION_GUIDE.md:295:| Alibaba | ALIBABA_DASHSCOPE_API_KEY | ✅ Have | Windsurf config |
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/handoff_2026-03-22_session.md:17:* **API Testing / Security**: Refizemos o teste na `dashscope.aliyuncs.com` com a nova chave da Alibaba (sk-bcab09...). O token demonstrou ser válido (sem erro no parsing auth), mas entrou em **Timeout** absoluto de rede a partir do VPS Contabo.
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/handoff_2026-03-22_session_final.md:39:- **Alibaba DashScope**: ✅ Configured (`ALIBABA_DASHSCOPE_API_KEY`)
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md:10:- **3-provider fallback chain** — [models.json](~/.openclaw/agents/main/agent/models.json): `anthropic-subscription/haiku` → `openrouter/qwen3-235b:free` → `dashscope/qwen-turbo`. VPS version uses `172.19.0.1:18801`.
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:35:Base URL: https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:122:1. Crie conta: https://dashscope.console.aliyun.com
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OBSIDIAN_LLM_INTEGRATION.md:125:   - **Custom Base URL**: `https://dashscope-intl.aliyuncs.com/compatible-mode/v1`
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OPENCLAW_SSOT.md:66:| `dashscope` | `openai-completions` | qwen-turbo, qwen-plus, qwen3-235b-a22b | Alibaba API — cheap paid fallback |
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OPENCLAW_SSOT.md:76:**To use subscription models:** set `agents.defaults.model: "anthropic-subscription/claude-haiku-4-5-20251001"` for default (Haiku). Fallback chain: `openrouter/qwen3-235b:free` → `dashscope/qwen-turbo`. Sonnet for complex tasks only..
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OBSIDIAN_MCP_SETUP_GUIDE.md:45:1. Acesse: https://dashscope.console.aliyun.com
./.claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/OBSIDIAN_MCP_SETUP_GUIDE.md:63:Base URL: https://dashscope-intl.aliyuncs.com/compatible-mode/v1
./.claude/worktrees/agent-ac1433679f0d59800/docs/products/forja.md:72:cp .env.example .env  # NEXT_PUBLIC_SUPABASE_URL, OPENROUTER_API_KEY, ALIBABA_DASHSCOPE_API_KEY
./.claude/worktrees/agent-ac1433679f0d59800/docs/stack/PROVIDER_ROUTING.md:26:| Alibaba DashScope (global) | `https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/stack/PROVIDER_ROUTING.md:27:| Alibaba DashScope (domestic) | `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` |
./.claude/worktrees/agent-ac1433679f0d59800/docs/knowledge/LLM_MODEL_MONITOR.md:235:    { model: 'qwen-plus', provider: 'dashscope', tier: 'S' },

exec
/bin/bash -lc "sed -n '1,280p' packages/shared/src/model-router.ts && sed -n '1,260p' packages/shared/src/llm-provider.ts && sed -n '1,180p' packages/shared/src/llm-orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Model Router — Task-Aware LLM Selection
 *
 * Similar to OpenRouter's model routing but local and cost-aware.
 * Each task type maps to the optimal model/provider combo based on:
 *   - capability fit
 *   - cost per 1M tokens
 *   - latency profile
 *   - quota availability
 *
 * Usage:
 *   const route = resolveModel('code_review');
 *   const result = await chatWithLLM({ ...route, systemPrompt, userPrompt });
 */

import type { SharedLLMProvider } from './llm-provider';

// ═══════════════════════════════════════════════════════════
// Task Types
// ═══════════════════════════════════════════════════════════

export type TaskType =
  | 'orchestration'     // agent coordination, planning, complex reasoning
  | 'code_generation'   // writing new code
  | 'code_review'       // reviewing diffs, finding bugs
  | 'analysis'          // data analysis, research synthesis
  | 'summarization'     // condensing long text
  | 'classification'    // intent detection, categorization
  | 'chat'              // conversational, general purpose
  | 'translation'       // language translation
  | 'extraction'        // structured data extraction from text
  | 'fast_check'        // quick validation, yes/no, simple checks
  ;

// ═══════════════════════════════════════════════════════════
// Model Profiles
// ═══════════════════════════════════════════════════════════

export interface ModelProfile {
  id: string;
  provider: SharedLLMProvider;
  displayName: string;
  costPer1MInput: number;   // USD
  costPer1MOutput: number;  // USD
  maxContext: number;        // tokens
  strengths: TaskType[];
  tier: 'premium' | 'balanced' | 'economy';
  envKey: string;            // which env var holds the API key
}

export const MODEL_CATALOG: ModelProfile[] = [
  // ── OpenRouter ──
  {
    id: 'google/gemini-2.0-flash-001',
    provider: 'openrouter',
    displayName: 'Gemini 2.0 Flash',
    costPer1MInput: 0.1,
    costPer1MOutput: 0.4,
    maxContext: 1048576,
    strengths: ['summarization', 'translation', 'chat', 'fast_check', 'extraction'],
    tier: 'economy',
    envKey: 'OPENROUTER_API_KEY',
  },
  {
    id: 'openai/gpt-4o-mini',
    provider: 'openrouter',
    displayName: 'GPT-4o Mini',
    costPer1MInput: 0.15,
    costPer1MOutput: 0.6,
    maxContext: 128000,
    strengths: ['chat', 'extraction', 'classification', 'fast_check'],
    tier: 'economy',
    envKey: 'OPENROUTER_API_KEY',
  },
  {
    id: 'anthropic/claude-sonnet-4-20250514',
    provider: 'openrouter',
    displayName: 'Claude Sonnet 4',
    costPer1MInput: 3.0,
    costPer1MOutput: 15.0,
    maxContext: 200000,
    strengths: ['orchestration', 'code_generation', 'code_review', 'analysis'],
    tier: 'premium',
    envKey: 'OPENROUTER_API_KEY',
  },
  {
    id: 'deepseek/deepseek-chat-v3-0324',
    provider: 'openrouter',
    displayName: 'DeepSeek V3',
    costPer1MInput: 0.27,
    costPer1MOutput: 1.1,
    maxContext: 65536,
    strengths: ['code_generation', 'code_review', 'analysis'],
    tier: 'balanced',
    envKey: 'OPENROUTER_API_KEY',
  },
];

// ═══════════════════════════════════════════════════════════
// Router Logic
// ═══════════════════════════════════════════════════════════

export type CostPreference = 'economy' | 'balanced' | 'premium';

export interface RouteOptions {
  task: TaskType;
  cost?: CostPreference;
  preferProvider?: SharedLLMProvider;
  minContext?: number;
}

export interface ResolvedRoute {
  model: string;
  provider: SharedLLMProvider;
  profile: ModelProfile;
}

// ═══════════════════════════════════════════════════════════
// Circuit Breaker (in-memory, per provider)
// ═══════════════════════════════════════════════════════════

type CBState = 'closed' | 'open' | 'half_open';

interface ProviderCBEntry {
  state: CBState;
  failures: number;
  lastFailure: number;   // ms timestamp
  cooldownUntil: number; // ms timestamp when to try half_open
}

const _cb: Record<string, ProviderCBEntry> = {};
const CB_FAILURE_THRESHOLD = 3;
const CB_COOLDOWN_MS = 30_000; // 30s before attempting recovery

function _getCB(provider: string): ProviderCBEntry {
  if (!_cb[provider]) {
    _cb[provider] = { state: 'closed', failures: 0, lastFailure: 0, cooldownUntil: 0 };
  }
  const entry = _cb[provider];
  // Transition open → half_open after cooldown
  if (entry.state === 'open' && Date.now() >= entry.cooldownUntil) {
    entry.state = 'half_open';
  }
  return entry;
}

/** Call when a provider request fails. Opens circuit after CB_FAILURE_THRESHOLD. */
export function recordProviderFailure(provider: string): void {
  const entry = _getCB(provider);
  entry.failures += 1;
  entry.lastFailure = Date.now();
  if (entry.failures >= CB_FAILURE_THRESHOLD) {
    entry.state = 'open';
    entry.cooldownUntil = Date.now() + CB_COOLDOWN_MS;
  }
}

/** Call when a provider request succeeds. Resets the circuit. */
export function recordProviderSuccess(provider: string): void {
  const entry = _getCB(provider);
  entry.state = 'closed';
  entry.failures = 0;
  entry.lastFailure = 0;
  entry.cooldownUntil = 0;
}

/** Returns true when a provider is in OPEN state (fast-fail). */
export function isProviderCircuitOpen(provider: string): boolean {
  return _getCB(provider).state === 'open';
}

/** Snapshot of all circuit states — for observability (HQ dashboard, telemetry). */
export function getCircuitBreakerSnapshot(): Record<string, { state: CBState; failures: number; lastFailure: number; cooldownRemainingMs: number }> {
  const now = Date.now();
  return Object.fromEntries(
    Object.entries(_cb).map(([provider, entry]) => [
      provider,
      {
        state: entry.state,
        failures: entry.failures,
        lastFailure: entry.lastFailure,
        cooldownRemainingMs: Math.max(0, entry.cooldownUntil - now),
      },
    ])
  );
}

function isAvailable(profile: ModelProfile): boolean {
  return !!process.env[profile.envKey] && !isProviderCircuitOpen(profile.provider);
}

const TIER_SCORE: Record<string, Record<string, number>> = {
  economy:  { economy: 3, balanced: 2, premium: 1 },
  balanced: { economy: 1, balanced: 3, premium: 2 },
  premium:  { economy: 1, balanced: 2, premium: 3 },
};

/**
 * Resolve the best model for a given task and cost preference.
 *
 * Scoring: strength match (4) + tier preference (1-3) + provider preference (1)
 * Ties broken by lower cost.
 */
export function resolveModel(taskOrOpts: TaskType | RouteOptions): ResolvedRoute {
  const opts: RouteOptions = typeof taskOrOpts === 'string'
    ? { task: taskOrOpts }
    : taskOrOpts;

  const { task, cost = 'balanced', preferProvider, minContext } = opts;
  const tierMap = TIER_SCORE[cost] ?? TIER_SCORE.balanced;

  const candidates = MODEL_CATALOG
    .filter(isAvailable)
    .filter(p => !minContext || p.maxContext >= minContext);

  if (candidates.length === 0) {
    throw new Error(
      `No LLM provider available. Set OPENROUTER_API_KEY in .env`
    );
  }

  const scored = candidates.map(p => {
    let score = 0;
    if (p.strengths.includes(task)) score += 4;
    score += tierMap[p.tier] ?? 1;
    if (preferProvider && p.provider === preferProvider) score += 1;
    const avgCost = (p.costPer1MInput + p.costPer1MOutput) / 2;
    return { profile: p, score, avgCost };
  });

  scored.sort((a, b) => {
    if (b.score !== a.score) return b.score - a.score;
    return a.avgCost - b.avgCost;
  });

  const best = scored[0].profile;
  return { model: best.id, provider: best.provider, profile: best };
}

/**
 * Convenience: resolve + format for chatWithLLM params.
 */
export function routeForChat(taskOrOpts: TaskType | RouteOptions): {
  model: string;
  provider: SharedLLMProvider;
} {
  const { model, provider } = resolveModel(taskOrOpts);
  return { model, provider };
}

/**
 * List all available models with their task strengths and pricing.
 */
export function listAvailableModels(): Array<ModelProfile & { available: boolean }> {
  return MODEL_CATALOG.map(p => ({ ...p, available: isAvailable(p) }));
}
import type { AIAnalysisResult } from './types';

export type SharedLLMProvider = 'openrouter' | 'google';

// ── Architecture ────────────────────────────────────────────────────────────
// ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
//   → This session IS the primary orchestrator, not routed through here
//
// BACKGROUND AGENTS (VPS): Use this fallback chain
//   Priority: Google AI Studio (free) → OpenRouter (gemini-2.0-flash-001)
//
// Google AI Studio (PRIORITY 1 — Completely Free, No Expiry):
//   Models: gemma-4-31b-it (1,500 req/day), gemini-2.5-flash (500 req/day)
//   Key: GOOGLE_AI_STUDIO_API_KEY | Base: generativelanguage.googleapis.com
//
// OpenRouter (PRIORITY 2 — Paid, low cost):
//   PRIMARY: google/gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
//   Fallback: gemini-2.5-pro, llama-4-maverick
//   Key: OPENROUTER_API_KEY
//   NOTE: Alibaba DashScope REMOVED — free grant period expired ($500 used)

// ── Fallback Chain ─────────────────────────────────────────────────────────

interface ModelEntry {
  provider: SharedLLMProvider;
  model: string;
  tier: 'fast' | 'default' | 'deep';
}

// Tier 0: Google AI Studio (FREE — no expiry, 1500 req/day for 31B model)
// NOTE: gemma-4-31b-it weak on tool-calling → use for reasoning/coding only
const GOOGLE_CHAIN: ModelEntry[] = [
  // Fast tier — gemini-2.5-flash (500 req/day free, multimodal)
  { provider: 'google', model: 'gemini-2.5-flash', tier: 'fast' },
  // Default tier — gemma-4-31b-it (1,500 req/day free, best coding/reasoning)
  { provider: 'google', model: 'gemma-4-31b-it',   tier: 'default' },
  // Deep tier — gemini-2.5-pro (50 req/day free, strongest reasoning)
  { provider: 'google', model: 'gemini-2.5-pro',   tier: 'deep' },
];

// Tier 1: OpenRouter — gemini-2.0-flash-001 as primary paid model
const OPENROUTER_CHAIN: ModelEntry[] = [
  // Fast tier — Gemini 2.0 Flash (~$0.10/1M in, $0.40/1M out)
  { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'fast' },

  // Default tier — Gemini 2.0 Flash (best cost/quality for PT-BR tasks)
  { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'default' },

  // Deep tier — Gemini 2.5 Pro (strongest reasoning)
  { provider: 'openrouter', model: 'google/gemini-2.5-pro',       tier: 'deep' },
  { provider: 'openrouter', model: 'meta-llama/llama-4-maverick', tier: 'deep' },
];

/** Detect rate-limit or quota exhaustion from HTTP status + response body */
function isRateLimitError(status: number, body: string): boolean {
  if (status === 429) return true;
  const lower = body.toLowerCase();
  return (
    lower.includes('rate limit exceeded') ||
    lower.includes('requests rate limit') ||
    lower.includes('allocated quota exceeded') ||
    lower.includes('request rate increased too quickly') ||
    lower.includes('throttl') ||
    lower.includes('quota') ||
    lower.includes('insufficient funds') ||
    lower.includes('credit exhausted')
  );
}

// ── Single model caller ────────────────────────────────────────────────────

async function callModel(
  entry: ModelEntry,
  params: {
    systemPrompt: string;
    userPrompt: string;
    maxTokens?: number;
    temperature?: number;
    responseFormat?: 'json_object' | 'text';
  }
): Promise<AIAnalysisResult> {
  const { provider, model } = entry;

  let baseUrl: string;
  let apiKey: string | undefined;

  if (provider === 'google') {
    // Google AI Studio: OpenAI-compatible endpoint
    baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
    apiKey = process.env.GOOGLE_AI_STUDIO_API_KEY;
  } else {
    baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
    apiKey = process.env.OPENROUTER_API_KEY;
  }

  if (!apiKey) {
    const keyName = provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
    throw new Error(`SKIP: ${keyName} not set`);
  }

  const body: Record<string, unknown> = {
    model,
    messages: [
      { role: 'system', content: params.systemPrompt },
      { role: 'user', content: params.userPrompt },
    ],
    max_tokens: params.maxTokens ?? 2000,
    temperature: params.temperature ?? 0.3,
  };

  if (params.responseFormat === 'json_object' && provider === 'openrouter') {
    body.response_format = { type: 'json_object' };
  }

  const response = await fetch(baseUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
      ...(provider === 'openrouter'
        ? { 'HTTP-Referer': 'https://egos.dev', 'X-Title': 'egos' }
        : {}),
    },
    body: JSON.stringify(body),
  });

  const responseText = await response.text();

  if (!response.ok) {
    if (isRateLimitError(response.status, responseText)) {
      throw new Error(`RATE_LIMIT: ${provider}/${model} (HTTP ${response.status})`);
    }
    // Auth errors — don't bother continuing chain
    if (response.status === 401 || response.status === 403) {
      throw new Error(`AUTH_ERROR: ${provider}/${model} (HTTP ${response.status}): ${responseText.slice(0, 200)}`);
    }
    throw new Error(`API_ERROR: ${provider}/${model} (HTTP ${response.status}): ${responseText.slice(0, 200)}`);
  }

  const data = JSON.parse(responseText) as {
    model?: string;
    usage?: AIAnalysisResult['usage'];
    choices?: Array<{ message?: { content?: string } }>;
  };
  return {
    content: data.choices?.[0]?.message?.content ?? '',
    model: data.model ?? model,
    usage: data.usage ?? { prompt_tokens: 0, completion_tokens: 0, total_tokens: 0 },
    cost_usd: 0,
  };
}

// ── Main export with automatic fallback chain ─────────────────────────────

export async function chatWithLLM(params: {
  systemPrompt: string;
  userPrompt: string;
  model?: string;
  maxTokens?: number;
  temperature?: number;
  provider?: SharedLLMProvider;
  responseFormat?: 'json_object' | 'text';
  /** Task tier — controls which models are tried first. Default: 'default' */
  tier?: 'fast' | 'default' | 'deep';
}): Promise<AIAnalysisResult> {
  // Explicit model: single attempt, no fallback chain
  if (params.model) {
    const explicitProvider: SharedLLMProvider =
      params.provider ??
      (params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
        : 'openrouter');
    return callModel(
      { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
      params
    );
  }

  // Build chain: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
  const tier = params.tier ?? 'default';

  const googleModels = GOOGLE_CHAIN.filter((e: ModelEntry) =>
    tier === 'fast' ? e.tier === 'fast'
    : tier === 'deep' ? true
    : e.tier !== 'deep'
  );

  const openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) =>
    tier === 'fast' ? e.tier === 'fast'
    : tier === 'deep' ? true
    : e.tier !== 'deep'
  );

  // Chain order: Google (free) → OpenRouter (gemini-2.0-flash-001 primary)
  let chain: ModelEntry[] = [...googleModels, ...openrouterModels];

  // If a provider is forced, prioritize it at front of chain
  if (params.provider) {
    const pref = chain.filter((e: ModelEntry) => e.provider === params.provider);
    const rest = chain.filter((e: ModelEntry) => e.provider !== params.provider);
    chain = [...pref, ...rest];
  }

  let lastError = '';
  for (const entry of chain) {
    try {
      const result = await callModel(entry, params);
      if (lastError) {
        console.warn(`[llm-provider] Used ${entry.provider}/${entry.model} after fallback. Prior error: ${lastError}`);
      }
      return result;
    } catch (err: any) {
      lastError = err?.message ?? String(err);
      // Hard auth errors — abort chain immediately
      if (lastError.startsWith('AUTH_ERROR:')) throw err;
      // Rate limit or missing key — continue to next in chain
      continue;
    }
  }
  throw new Error(`[llm-provider] All models in chain exhausted. Last error: ${lastError}`);
}
/**
 * LLM Orchestrator — Multi-Model Economic Routing
 *
 * Orquestra chamadas LLM priorizando modelos mais baratos quando possível.
 * Usa OpenRouter para todas as chamadas (free tier quando disponível).
 */

export type TaskComplexity = 'simple' | 'moderate' | 'complex';
export type LLMProvider = 'openrouter' | 'openai';

export interface ModelConfig {
  provider: LLMProvider;
  model: string;
  costPer1kTokens: number;
  maxTokens: number;
  bestFor: TaskComplexity[];
}

export const MODEL_REGISTRY: Record<string, ModelConfig> = {
  // OpenRouter (Qwen via OpenRouter)
  'qwen-turbo': {
    provider: 'openrouter',
    model: 'qwen/qwen3-coder:free',
    costPer1kTokens: 0.0,
    maxTokens: 8000,
    bestFor: ['simple'],
  },
  'qwen-plus': {
    provider: 'openrouter',
    model: 'openai/gpt-oss-120b:free',
    costPer1kTokens: 0.0,
    maxTokens: 32000,
    bestFor: ['moderate', 'complex'],
  },

  // OpenRouter (via Gemini)
  'gemini-flash': {
    provider: 'openrouter',
    model: 'google/gemini-2.0-flash-exp:free',
    costPer1kTokens: 0.0, // Free tier
    maxTokens: 8000,
    bestFor: ['simple', 'moderate'],
  },
  'gemini-flash-paid': {
    provider: 'openrouter',
    model: 'google/gemini-2.0-flash-001',
    costPer1kTokens: 0.0001, // Very cheap
    maxTokens: 8000,
    bestFor: ['simple', 'moderate'],
  },
};

export interface OrchestratorConfig {
  preferFree: boolean;
  maxCostPerCall: number; // USD
  fallbackChain: string[];
}

export class LLMOrchestrator {
  private config: OrchestratorConfig;
  
  constructor(config: Partial<OrchestratorConfig> = {}) {
    this.config = {
      preferFree: config.preferFree ?? true,
      maxCostPerCall: config.maxCostPerCall ?? 0.05,
      fallbackChain: config.fallbackChain ?? ['gemini-flash', 'gemini-flash-paid', 'qwen-turbo', 'qwen-plus'],
    };
  }
  
  /**
   * Seleciona o melhor modelo para a task baseado em complexidade e custo
   */
  selectModel(complexity: TaskComplexity, estimatedTokens: number = 1000): ModelConfig {
    const candidates = this.config.fallbackChain
      .map(key => MODEL_REGISTRY[key])
      .filter(model => model.bestFor.includes(complexity));
    
    if (this.config.preferFree) {
      const freeModel = candidates.find(m => m.costPer1kTokens === 0);
      if (freeModel) return freeModel;
    }
    
    // Ordena por custo (menor primeiro)
    const sorted = candidates.sort((a, b) => a.costPer1kTokens - b.costPer1kTokens);
    
    // Retorna o mais barato que cabe no orçamento
    const estimatedCost = (estimatedTokens / 1000) * (sorted[0]?.costPer1kTokens || 0);
    if (estimatedCost <= this.config.maxCostPerCall) {
      return sorted[0];
    }
    
    // Fallback: retorna o primeiro disponível
    return sorted[0] || MODEL_REGISTRY['gemini-flash'];
  }
  
  /**
   * Estima complexidade baseado no prompt
   */
  estimateComplexity(prompt: string): TaskComplexity {
    const length = prompt.length;
    const hasCode = /```|function|class|import/.test(prompt);
    const hasMultiStep = /step|first|then|finally|\d\./gi.test(prompt);
    
    if (length > 2000 || (hasCode && hasMultiStep)) return 'complex';
    if (length > 500 || hasCode || hasMultiStep) return 'moderate';
    return 'simple';
  }
  
  /**
   * Orquestra chamada LLM com seleção automática de modelo
   */
  async orchestrate(params: {
    prompt: string;
    complexity?: TaskComplexity;
    maxTokens?: number;
    forceModel?: string;
  }): Promise<{ model: ModelConfig; estimatedCost: number }> {
    const complexity = params.complexity || this.estimateComplexity(params.prompt);
    const estimatedTokens = params.maxTokens || Math.min(params.prompt.length * 2, 4000);
    
    const model = params.forceModel 
      ? MODEL_REGISTRY[params.forceModel] 
      : this.selectModel(complexity, estimatedTokens);
    
    const estimatedCost = (estimatedTokens / 1000) * model.costPer1kTokens;
    
    return { model, estimatedCost };
  }
}

// Singleton instance
export const llmOrchestrator = new LLMOrchestrator();

exec
/bin/bash -lc "git show e8ee9b6507520d3867ca86e3a06c16cce4e8357d:packages/shared/src/llm-provider.ts | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
import type { AIAnalysisResult } from './types';

export type SharedLLMProvider = 'openrouter' | 'alibaba' | 'google';

// ── Architecture ────────────────────────────────────────────────────────────
// ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
//   → Unlimited rate limit on all 3 models
//   → This session IS the primary orchestrator, not routed through here
//
// BACKGROUND AGENTS (VPS): Use this fallback chain
//   Priority: Google AI Studio → Alibaba DashScope → OpenRouter
//
// Google AI Studio (PRIORITY 1 — Completely Free, No Expiry):
//   Models: gemma-4-31b-it (1,500 req/day), gemini-2.5-flash (500 req/day)
//   Key: GOOGLE_AI_STUDIO_API_KEY | Base: generativelanguage.googleapis.com
//   WARNING: gemma-4-31b is excellent for reasoning/coding but weak on tool-calling
//
// Alibaba DashScope (PRIORITY 2 — Free One-Time Grant):
//   Models: qwen-flash, qwen-plus, qwen-max, qwq-plus (reasoning)
//   ONE-TIME 1M token grant per model (90-day validity)
//   Rate limits: 30K RPM (fast), 15K RPM (default), 600 RPM (deep)
//
// OpenRouter (PRIORITY 3 — Paid Fallback):
//   qwen3.6-plus:free → $0/token, unlimited rate (primary free option here)
//   Hermes-3, Gemini Flash, Llama 4 — only when others exhausted
//   NO Claude models — orchestrator handles Claude via Claude Code plan

export const ALIBABA_MODELS = [
  'qwen-max',
  'qwen-plus',
  'qwen-flash',
  'qwen3-coder-plus',
  'qwen3.5-plus',
  'qwen-turbo',
  'qwq-plus',
] as const;

// ── Fallback Chain ─────────────────────────────────────────────────────────

interface ModelEntry {
  provider: SharedLLMProvider;
  model: string;
  tier: 'fast' | 'default' | 'deep';
}

// Tier 0: Google AI Studio (FREE — no expiry, 1500 req/day for 31B model)
// NOTE: gemma-4-31b-it weak on tool-calling → use for reasoning/coding only
const GOOGLE_CHAIN: ModelEntry[] = [
  // Fast tier — gemini-2.5-flash (500 req/day free, multimodal)
  { provider: 'google', model: 'gemini-2.5-flash', tier: 'fast' },
  // Default tier — gemma-4-31b-it (1,500 req/day free, best coding/reasoning)
  { provider: 'google', model: 'gemma-4-31b-it',   tier: 'default' },
  // Deep tier — gemini-2.5-pro (50 req/day free, strongest reasoning)
  { provider: 'google', model: 'gemini-2.5-pro',   tier: 'deep' },
];

// Tier 1: Alibaba (FREE one-time grant — exhaust before OpenRouter)
const ALIBABA_CHAIN: ModelEntry[] = [
  // Fast tier — 30K RPM, 10M TPM (free 1M tokens)
  { provider: 'alibaba', model: 'qwen3.5-flash',   tier: 'fast' },
  { provider: 'alibaba', model: 'qwen-flash',       tier: 'fast' },
  { provider: 'alibaba', model: 'qwen-turbo',       tier: 'fast' },
  { provider: 'alibaba', model: 'qwen3-coder-plus', tier: 'fast' },

  // Default tier — 15K RPM, 5M TPM
  { provider: 'alibaba', model: 'qwen-plus',    tier: 'default' },
  { provider: 'alibaba', model: 'qwen3.5-plus', tier: 'default' },

  // Deep tier — 600 RPM, 1M TPM (reasoning/planning)
  { provider: 'alibaba', model: 'qwen-max',  tier: 'deep' },
  { provider: 'alibaba', model: 'qwq-plus',  tier: 'deep' },
];

// Tier 2: OpenRouter — free model first, then cheap paid
const OPENROUTER_CHAIN: ModelEntry[] = [
  // FREE — Qwen 3.6 Plus (prompt=0, completion=0, no rate limit published)
  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'fast' },
  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'default' },

  // MiniMax M2.5 — benchmark winner Apr 2026: 7.1/10, 67% tool accuracy, $0.36/mo
  { provider: 'openrouter', model: 'minimax/minimax-m2.5', tier: 'default' },

  // Gemini Flash (essentially free)
  { provider: 'openrouter', model: 'google/gemini-2.0-flash-001', tier: 'default' },

  // Hermes-3 for BRAID/structured output (BRAID mechanical executor)
  { provider: 'openrouter', model: 'nousresearch/hermes-3-llama-3.1-70b', tier: 'default' },

  // Deep tier — High capability, low cost (no Claude)
  { provider: 'openrouter', model: 'google/gemini-2.5-pro',       tier: 'deep' },
  { provider: 'openrouter', model: 'meta-llama/llama-4-maverick', tier: 'deep' },
];

/** Detect rate-limit or quota exhaustion from HTTP status + response body */
function isRateLimitError(status: number, body: string): boolean {
  if (status === 429) return true;
  const lower = body.toLowerCase();
  return (
    lower.includes('rate limit exceeded') ||
    lower.includes('requests rate limit') ||
    lower.includes('allocated quota exceeded') ||
    lower.includes('request rate increased too quickly') ||
    lower.includes('throttl') ||
    lower.includes('quota') ||
    lower.includes('insufficient funds') ||
    lower.includes('credit exhausted')
  );
}

// ── Single model caller ────────────────────────────────────────────────────

async function callModel(
  entry: ModelEntry,
  params: {
    systemPrompt: string;
    userPrompt: string;
    maxTokens?: number;
    temperature?: number;
    responseFormat?: 'json_object' | 'text';
  }
): Promise<AIAnalysisResult> {
  const { provider, model } = entry;

  let baseUrl: string;
  let apiKey: string | undefined;

  if (provider === 'alibaba') {
    baseUrl = `${(process.env.ALIBABA_DASHSCOPE_BASE_URL || 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1').replace(/\/+$/, '')}/chat/completions`;
    apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
  } else if (provider === 'google') {
    // Google AI Studio: OpenAI-compatible endpoint
    baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
    apiKey = process.env.GOOGLE_AI_STUDIO_API_KEY;
  } else {
    baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
    apiKey = process.env.OPENROUTER_API_KEY;
  }

  if (!apiKey) {
    const keyName = provider === 'alibaba' ? 'ALIBABA_DASHSCOPE_API_KEY' : provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
    throw new Error(`SKIP: ${keyName} not set`);
  }

  const body: Record<string, unknown> = {
    model,
    messages: [
      { role: 'system', content: params.systemPrompt },
      { role: 'user', content: params.userPrompt },
    ],
    max_tokens: params.maxTokens ?? 2000,
    temperature: params.temperature ?? 0.3,
  };

  if (params.responseFormat === 'json_object' && provider === 'openrouter') {
    body.response_format = { type: 'json_object' };
  }

  const response = await fetch(baseUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
      ...(provider === 'openrouter'
        ? { 'HTTP-Referer': 'https://egos.dev', 'X-Title': 'egos' }
        : {}),
    },
    body: JSON.stringify(body),
  });

  const responseText = await response.text();

  if (!response.ok) {
    if (isRateLimitError(response.status, responseText)) {
      throw new Error(`RATE_LIMIT: ${provider}/${model} (HTTP ${response.status})`);
    }
    // Auth errors — don't bother continuing chain
    if (response.status === 401 || response.status === 403) {
      throw new Error(`AUTH_ERROR: ${provider}/${model} (HTTP ${response.status}): ${responseText.slice(0, 200)}`);
    }
    throw new Error(`API_ERROR: ${provider}/${model} (HTTP ${response.status}): ${responseText.slice(0, 200)}`);
  }

  const data = JSON.parse(responseText) as {
    model?: string;
    usage?: AIAnalysisResult['usage'];
    choices?: Array<{ message?: { content?: string } }>;
  };
  return {
    content: data.choices?.[0]?.message?.content ?? '',
    model: data.model ?? model,
    usage: data.usage ?? { prompt_tokens: 0, completion_tokens: 0, total_tokens: 0 },
    cost_usd: 0,
  };
}

// ── Main export with automatic fallback chain ─────────────────────────────

export async function chatWithLLM(params: {
  systemPrompt: string;
  userPrompt: string;
  model?: string;
  maxTokens?: number;
  temperature?: number;
  provider?: SharedLLMProvider;
  responseFormat?: 'json_object' | 'text';
  /** Task tier — controls which models are tried first. Default: 'default' */
  tier?: 'fast' | 'default' | 'deep';
}): Promise<AIAnalysisResult> {
  // Explicit model: single attempt, no fallback chain
  if (params.model) {
    const explicitProvider: SharedLLMProvider =
      params.provider ??
      (params.model.startsWith('qwen') && !params.model.includes(':') ? 'alibaba'
        : params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
        : 'openrouter');
    return callModel(
      { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
      params
    );
  }

  // Build chain: Google (free/daily limit) → Alibaba (free grant) → OpenRouter (paid fallback)
  const tier = params.tier ?? 'default';

  const googleModels = GOOGLE_CHAIN.filter((e: ModelEntry) =>
    tier === 'fast' ? e.tier === 'fast'
    : tier === 'deep' ? true
    : e.tier !== 'deep'
  );

  let alibabaModels: ModelEntry[];
  let openrouterModels: ModelEntry[];

  if (tier === 'fast') {
    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
  } else if (tier === 'deep') {
    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
  } else {
    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
  }

  // Chain order: Google (free) → Alibaba (free grant) → OpenRouter
  let chain: ModelEntry[] = [...googleModels, ...alibabaModels, ...openrouterModels];

  // If a provider is forced, prioritize it at front of chain
  if (params.provider) {
    const pref = chain.filter((e: ModelEntry) => e.provider === params.provider);
    const rest = chain.filter((e: ModelEntry) => e.provider !== params.provider);
    chain = [...pref, ...rest];
  }

  let lastError = '';
  for (const entry of chain) {
    try {
      const result = await callModel(entry, params);
      if (lastError) {
        console.warn(`[llm-provider] Used ${entry.provider}/${entry.model} after fallback. Prior error: ${lastError}`);

exec
/bin/bash -lc "sed -n '1,100p' .github/workflows/gem-hunter-adaptive.yml && grep -R \"gem-hunter-digest\" -n .github scripts package.json" in /home/enio/egos
 succeeded in 8132ms:
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:3204:Landing page do Gem Hunter — sistema de descoberta de ferramentas/repos relevantes para o EGOS. HTML estático servido por Bun. Deploy via Caddy. Complementa `packages/gem-hunter/` (engine) + `apps/egos-gateway/src/channels/gem-hunter.ts` (API) + `scripts/gem-hunter-digest.ts` (cron diário).
scripts/gem-hunter-digest.ts:13://   bun run scripts/gem-hunter-digest.ts              # last 7 days, live
scripts/gem-hunter-digest.ts:14://   bun run scripts/gem-hunter-digest.ts --dry-run    # generate only, no save/send
scripts/gem-hunter-digest.ts:15://   bun run scripts/gem-hunter-digest.ts --days 14    # look back 14 days
scripts/gem-hunter-digest.ts:219:  lines.push(`*Generated at ${new Date().toISOString()} by gem-hunter-digest.ts (GH-074)*`);

exec
/bin/bash -lc "sed -n '1,220p' packages/chatbot-core/src/model-router.ts && grep -R \"EGOS_DEFAULT_MODELS\\|providerEnvKey\\|DASHSCOPE_BASE_URL\" -n packages/chatbot-core src apps packages | head -100" in /home/enio/egos
exec
/bin/bash -lc "git show e8ee9b6507520d3867ca86e3a06c16cce4e8357d:packages/shared/src/llm-orchestrator.ts | sed -n '1,90p'" in /home/enio/egos
 succeeded in 0ms:
/**
 * LLM Orchestrator — Multi-Model Economic Routing
 * 
 * Orquestra chamadas LLM priorizando modelos mais baratos quando possível.
 * Usa qwen-plus apenas para tasks complexas que justificam o custo.
 */

export type TaskComplexity = 'simple' | 'moderate' | 'complex';
export type LLMProvider = 'alibaba' | 'openrouter' | 'openai';

export interface ModelConfig {
  provider: LLMProvider;
  model: string;
  costPer1kTokens: number;
  maxTokens: number;
  bestFor: TaskComplexity[];
}

export const MODEL_REGISTRY: Record<string, ModelConfig> = {
  // Alibaba DashScope
  'qwen-turbo': {
    provider: 'alibaba',
    model: 'qwen-turbo',
    costPer1kTokens: 0.002, // ~$0.002/1k tokens (estimado)
    maxTokens: 8000,
    bestFor: ['simple'],
  },
  'qwen-plus': {
    provider: 'alibaba',
    model: 'qwen-plus',
    costPer1kTokens: 0.008, // ~$0.008/1k tokens (estimado)
    maxTokens: 32000,
    bestFor: ['moderate', 'complex'],
  },
  
  // OpenRouter (via Gemini)
  'gemini-flash': {
    provider: 'openrouter',
    model: 'google/gemini-2.0-flash-exp:free',
    costPer1kTokens: 0.0, // Free tier
    maxTokens: 8000,
    bestFor: ['simple', 'moderate'],
  },
  'gemini-flash-paid': {
    provider: 'openrouter',
    model: 'google/gemini-2.0-flash-001',
    costPer1kTokens: 0.0001, // Very cheap
    maxTokens: 8000,
    bestFor: ['simple', 'moderate'],
  },
};

export interface OrchestratorConfig {
  preferFree: boolean;
  maxCostPerCall: number; // USD
  fallbackChain: string[];
}

export class LLMOrchestrator {
  private config: OrchestratorConfig;
  
  constructor(config: Partial<OrchestratorConfig> = {}) {
    this.config = {
      preferFree: config.preferFree ?? true,
      maxCostPerCall: config.maxCostPerCall ?? 0.05,
      fallbackChain: config.fallbackChain ?? ['gemini-flash', 'gemini-flash-paid', 'qwen-turbo', 'qwen-plus'],
    };
  }
  
  /**
   * Seleciona o melhor modelo para a task baseado em complexidade e custo
   */
  selectModel(complexity: TaskComplexity, estimatedTokens: number = 1000): ModelConfig {
    const candidates = this.config.fallbackChain
      .map(key => MODEL_REGISTRY[key])
      .filter(model => model.bestFor.includes(complexity));
    
    if (this.config.preferFree) {
      const freeModel = candidates.find(m => m.costPer1kTokens === 0);
      if (freeModel) return freeModel;
    }
    
    // Ordena por custo (menor primeiro)
    const sorted = candidates.sort((a, b) => a.costPer1kTokens - b.costPer1kTokens);
    
    // Retorna o mais barato que cabe no orçamento
    const estimatedCost = (estimatedTokens / 1000) * (sorted[0]?.costPer1kTokens || 0);
    if (estimatedCost <= this.config.maxCostPerCall) {
      return sorted[0];
    }

exec
/bin/bash -lc 'grep -R "ALIBABA_MODELS" -n --exclude-dir=node_modules --exclude-dir=.git .' in /home/enio/egos
2026-06-07T19:58:35.602991Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
 succeeded in 14118ms:
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/llm-provider.ts:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/llm-providers/llm-router.ts:41:const ALIBABA_MODELS = [
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/llm-providers/llm-router.ts:74:  | typeof ALIBABA_MODELS[number]
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/llm-providers/llm-router.ts:126:  for (const model of ALIBABA_MODELS) {
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/__tests__/llm-provider.test.ts:9:import { ALIBABA_MODELS } from '../llm-provider';
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/__tests__/llm-provider.test.ts:32:    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/__tests__/llm-provider.test.ts:33:    expect(ALIBABA_MODELS).toContain('qwen-plus');
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/__tests__/llm-provider.test.ts:34:    expect(ALIBABA_MODELS).toContain('qwen-flash');
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/__tests__/llm-provider.test.ts:38:    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/index.ts:8:export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/llm-provider.ts:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/llm-providers/llm-router.ts:41:const ALIBABA_MODELS = [
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/llm-providers/llm-router.ts:74:  | typeof ALIBABA_MODELS[number]
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/llm-providers/llm-router.ts:126:  for (const model of ALIBABA_MODELS) {
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/__tests__/llm-provider.test.ts:9:import { ALIBABA_MODELS } from '../llm-provider';
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/__tests__/llm-provider.test.ts:32:    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/__tests__/llm-provider.test.ts:33:    expect(ALIBABA_MODELS).toContain('qwen-plus');
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/__tests__/llm-provider.test.ts:34:    expect(ALIBABA_MODELS).toContain('qwen-flash');
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/__tests__/llm-provider.test.ts:38:    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/index.ts:8:export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/llm-provider.ts:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/llm-providers/llm-router.ts:41:const ALIBABA_MODELS = [
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/llm-providers/llm-router.ts:74:  | typeof ALIBABA_MODELS[number]
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/llm-providers/llm-router.ts:126:  for (const model of ALIBABA_MODELS) {
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/__tests__/llm-provider.test.ts:9:import { ALIBABA_MODELS } from '../llm-provider';
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/__tests__/llm-provider.test.ts:32:    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/__tests__/llm-provider.test.ts:33:    expect(ALIBABA_MODELS).toContain('qwen-plus');
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/__tests__/llm-provider.test.ts:34:    expect(ALIBABA_MODELS).toContain('qwen-flash');
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/__tests__/llm-provider.test.ts:38:    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/index.ts:8:export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/llm-provider.ts:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/llm-providers/llm-router.ts:41:const ALIBABA_MODELS = [
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/llm-providers/llm-router.ts:74:  | typeof ALIBABA_MODELS[number]
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/llm-providers/llm-router.ts:126:  for (const model of ALIBABA_MODELS) {
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/__tests__/llm-provider.test.ts:9:import { ALIBABA_MODELS } from '../llm-provider';
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/__tests__/llm-provider.test.ts:32:    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/__tests__/llm-provider.test.ts:33:    expect(ALIBABA_MODELS).toContain('qwen-plus');
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/__tests__/llm-provider.test.ts:34:    expect(ALIBABA_MODELS).toContain('qwen-flash');
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/__tests__/llm-provider.test.ts:38:    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/index.ts:8:export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/llm-provider.ts:28:export const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/llm-providers/llm-router.ts:41:const ALIBABA_MODELS = [
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/llm-providers/llm-router.ts:74:  | typeof ALIBABA_MODELS[number]
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/llm-providers/llm-router.ts:126:  for (const model of ALIBABA_MODELS) {
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/__tests__/llm-provider.test.ts:9:import { ALIBABA_MODELS } from '../llm-provider';
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/__tests__/llm-provider.test.ts:32:    expect(ALIBABA_MODELS.length).toBeGreaterThan(0);
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/__tests__/llm-provider.test.ts:33:    expect(ALIBABA_MODELS).toContain('qwen-plus');
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/__tests__/llm-provider.test.ts:34:    expect(ALIBABA_MODELS).toContain('qwen-flash');
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/__tests__/llm-provider.test.ts:38:    expect(ALIBABA_MODELS).toContain('qwen3-coder-plus');
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/index.ts:8:export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:1031:-export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2325:-export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:2922:export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3233:/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3248:28:export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:3371:28:export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:4391:-export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5311:-export const ALIBABA_MODELS = [
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5711:packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:5802:     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6354:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./.egos/codex-reviews/2026-06-07-local-review-e8ee9b65.md:6363:  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.
./packages/shared/src/llm-providers/llm-router.ts:28:export const ALIBABA_MODELS = [
./packages/shared/src/llm-providers/llm-router.ts:61:  | typeof ALIBABA_MODELS[number]
./packages/mcp-g-pecas/dist/index.js:38785:var ALIBABA_MODELS = [
./packages/mcp-g-pecas/dist/index.js:38817:  for (const model of ALIBABA_MODELS) {

exec
/bin/bash -lc "sed -n '1,140p' packages/pii-purge/src/scanner.ts && sed -n '1,90p' packages/pii-purge/src/cli.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Scanner — Walks a target directory and returns Findings for each entity match.
 *
 * Safety rules:
 * - NEVER include the matched value in a Finding (T0 §3)
 * - Skip binary files, node_modules, .git
 * - Only process git-tracked text files (falls back to all text if not in a git repo)
 * - fuzzy-REVIEW matches are flagged but never auto-purgeable
 */

import { readdir, readFile, stat } from 'node:fs/promises';
import { join, extname } from 'node:path';
import { execSync } from 'node:child_process';
import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
import type { Entity } from './dictionary.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Finding {
  /** Absolute or relative path of the file containing the match */
  file: string;
  /** 1-based line number */
  line: number;
  /** Entity id from the dictionary */
  entityId: string;
  /** Which field type matched (cpf, phone, plate, name, reds) */
  type: EntityFieldType;
  /** Whether this is auto-purgeable or requires human review */
  matchType: MatchType;
  /** Byte offset of match start within the line (for stable replacements) */
  lineOffset: number;
  /** Length of matched text (never the value itself) */
  matchLength: number;
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

const BINARY_EXTENSIONS = new Set([
  '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp',
  '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
  '.zip', '.tar', '.gz', '.bz2', '.rar', '.7z',
  '.mp3', '.mp4', '.avi', '.mov', '.wav', '.flac',
  '.woff', '.woff2', '.ttf', '.eot',
  '.lock', '.bin', '.exe', '.dll', '.so', '.dylib',
  '.db', '.sqlite', '.sqlite3',
]);

function isBinary(filePath: string): boolean {
  return BINARY_EXTENSIONS.has(extname(filePath).toLowerCase());
}

function isSkippedDir(name: string): boolean {
  return name === 'node_modules' || name === '.git' || name === 'dist' || name === '.next';
}

/**
 * Returns the set of git-tracked files under `dir`, relative to `dir`.
 * Falls back to null if not in a git repo — caller handles fallback.
 */
function getGitTrackedFiles(dir: string): Set<string> | null {
  try {
    const out = execSync('git ls-files', { cwd: dir, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] });
    return new Set(out.trim().split('\n').filter(Boolean).map(f => join(dir, f)));
  } catch {
    return null;
  }
}

/**
 * Recursively collect all candidate file paths under `dir`.
 */
async function collectFiles(dir: string): Promise<string[]> {
  const results: string[] = [];
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (isSkippedDir(entry.name)) continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...(await collectFiles(full)));
    } else if (entry.isFile() && !isBinary(full)) {
      results.push(full);
    }
  }
  return results;
}

// ─── Core scanner ─────────────────────────────────────────────────────────────

/**
 * Scan a single file for all entity patterns.
 * NEVER includes matched values in returned findings.
 */
export function scanText(
  text: string,
  filePath: string,
  patterns: EntityPattern[],
): Finding[] {
  const findings: Finding[] = [];
  const lines = text.split('\n');

  for (const pattern of patterns) {
    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const line = lines[lineIdx]!;
      // Reset regex state for each line (patterns have 'g' flag)
      const re = new RegExp(pattern.regex.source, pattern.regex.flags);
      let match: RegExpExecArray | null;
      while ((match = re.exec(line)) !== null) {
        findings.push({
          file: filePath,
          line: lineIdx + 1, // 1-based
          entityId: pattern.entityId,
          type: pattern.fieldType,
          matchType: pattern.matchType,
          lineOffset: match.index,
          matchLength: match[0].length,
          // NEVER include match[0] — T0 §3
        });
      }
    }
  }

  return findings;
}

/**
 * Resolve the list of readable text files under `targetDir`, preferring git-tracked.
 * Yields { path, text } for each, skipping binaries and files >2MB.
 */
async function readScannableFiles(targetDir: string): Promise<Array<{ path: string; text: string }>> {
  const allFiles = await collectFiles(targetDir);
  const gitTracked = getGitTrackedFiles(targetDir);
  const filesToScan = gitTracked ? allFiles.filter(f => gitTracked.has(f)) : allFiles;

  const out: Array<{ path: string; text: string }> = [];
  for (const path of filesToScan) {
    const s = await stat(path);
    if (s.size > 2 * 1024 * 1024) continue; // skip very large files
    try {
      out.push({ path, text: await readFile(path, 'utf-8') });
    } catch {
#!/usr/bin/env bun
/**
 * CLI — pii-purge
 *
 * Usage:
 *   bun packages/pii-purge/src/cli.ts \
 *     --entity-dict <path-to-dict.json> \
 *     --target <directory> \
 *     [--apply] \
 *     [--json]
 *
 * Defaults to --dry-run (safe). Writing requires explicit --apply.
 * Exits 1 if: verify fails OR REVIEW_REQUIRED findings remain (blocks publish).
 *
 * NEVER prints matched values (T0 §3).
 */

import { loadDictionary } from './dictionary.js';
import { generateAllPatterns } from './patterns.js';
import { scanDirectory, scanDirectoryLiteral, flattenEntityValues } from './scanner.js';
import { buildTokenMap, runPurge } from './purge.js';
import { verify } from './verify.js';
import { resolve, dirname } from 'node:path';
import { mkdirSync } from 'node:fs';

// ─── Arg parsing ──────────────────────────────────────────────────────────────

function parseArgs(argv: string[]): {
  entityDict: string;
  target: string;
  apply: boolean;
  json: boolean;
  verifyOnly: boolean;
} {
  const args: Record<string, string | boolean> = {};
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i]!;
    if (arg === '--apply') { args['apply'] = true; }
    else if (arg === '--dry-run') { args['dry-run'] = true; }
    else if (arg === '--json') { args['json'] = true; }
    else if (arg === '--verify-only') { args['verify-only'] = true; }
    else if (arg.startsWith('--')) {
      const key = arg.slice(2);
      args[key] = argv[i + 1] ?? true;
      i++;
    }
  }

  const entityDict = args['entity-dict'];
  const target = args['target'];

  if (!entityDict || typeof entityDict !== 'string') {
    console.error('[pii-purge] ERROR: --entity-dict <path> is required');
    process.exit(1);
  }
  if (!target || typeof target !== 'string') {
    console.error('[pii-purge] ERROR: --target <directory> is required');
    process.exit(1);
  }

  return {
    entityDict: resolve(entityDict),
    target: resolve(target),
    apply: args['apply'] === true,
    json: args['json'] === true,
    verifyOnly: args['verify-only'] === true,
  };
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const opts = parseArgs(process.argv.slice(2));
  const mode = opts.apply ? 'apply' : 'dry-run';

  if (!opts.json) {
    console.log(`[pii-purge] mode=${mode} dict=${opts.entityDict} target=${opts.target}`);
  }

  // 1. Load dictionary
  const dict = await loadDictionary(opts.entityDict);
  if (!opts.json) {
    console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
  }

  // 2. Generate patterns + flatten raw values (literal safety net — VERIFY-001)
  const patterns = generateAllPatterns(dict.entities);
  const literalValues = flattenEntityValues(dict.entities);

  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.

 succeeded in 35649ms:
grep: src: No such file or directory
grep: apps/egos-hq/.next/cache/webpack/server-production/2.pack: binary file matches
grep: apps/egos-hq/.next/cache/webpack/server-production/16.pack: binary file matches
grep: apps/egos-hq/.next/cache/webpack/server-production/0.pack: binary file matches
grep: apps/egos-hq/.next/cache/webpack/server-production/13.pack: binary file matches
grep: apps/_archived/vendas-portal/node_modules/react: No such file or directory
packages/chatbot-core/src/types.ts:32:  providerEnvKey: string;
packages/chatbot-core/src/create-chatbot.ts:13: *     models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY', baseUrl: '...' } },
packages/chatbot-core/src/create-chatbot.ts:240:        primary: { ...models.primary, providerEnvKey: '__BYOK__' },
packages/chatbot-core/src/create-chatbot.ts:247:      process.env[models.primary.providerEnvKey] ||
packages/chatbot-core/src/create-chatbot.ts:248:      (models.fallback && process.env[models.fallback.providerEnvKey]) ||
packages/chatbot-core/src/create-chatbot.ts:249:      (models.fast && process.env[models.fast.providerEnvKey]);
packages/chatbot-core/src/model-router.ts:27:export const EGOS_DEFAULT_MODELS: ModelConfig = {
packages/chatbot-core/src/model-router.ts:30:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:37:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:45:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:75:      const apiKey = process.env[tier.providerEnvKey] ?? '';
packages/chatbot-core/src/index.ts:11: *   models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY' } },
packages/chatbot-core/src/index.ts:26:  EGOS_DEFAULT_MODELS,
packages/chatbot-core/README.md:25:    primary: { modelId: 'qwen-turbo', providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY' },
packages/chatbot-core/README.md:26:    fallback: { modelId: 'qwen/qwen3-coder:free', providerEnvKey: 'OPENROUTER_API_KEY',
apps/egos-hq/node_modules/@egos/chatbot-core/src/types.ts:32:  providerEnvKey: string;
apps/egos-hq/node_modules/@egos/chatbot-core/src/create-chatbot.ts:13: *     models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY', baseUrl: '...' } },
apps/egos-hq/node_modules/@egos/chatbot-core/src/create-chatbot.ts:240:        primary: { ...models.primary, providerEnvKey: '__BYOK__' },
apps/egos-hq/node_modules/@egos/chatbot-core/src/create-chatbot.ts:247:      process.env[models.primary.providerEnvKey] ||
apps/egos-hq/node_modules/@egos/chatbot-core/src/create-chatbot.ts:248:      (models.fallback && process.env[models.fallback.providerEnvKey]) ||
apps/egos-hq/node_modules/@egos/chatbot-core/src/create-chatbot.ts:249:      (models.fast && process.env[models.fast.providerEnvKey]);
apps/egos-hq/node_modules/@egos/chatbot-core/src/model-router.ts:27:export const EGOS_DEFAULT_MODELS: ModelConfig = {
apps/egos-hq/node_modules/@egos/chatbot-core/src/model-router.ts:30:    providerEnvKey: 'OPENROUTER_API_KEY',
apps/egos-hq/node_modules/@egos/chatbot-core/src/model-router.ts:37:    providerEnvKey: 'OPENROUTER_API_KEY',
apps/egos-hq/node_modules/@egos/chatbot-core/src/model-router.ts:45:    providerEnvKey: 'OPENROUTER_API_KEY',
apps/egos-hq/node_modules/@egos/chatbot-core/src/model-router.ts:75:      const apiKey = process.env[tier.providerEnvKey] ?? '';
apps/egos-hq/node_modules/@egos/chatbot-core/src/index.ts:11: *   models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY' } },
apps/egos-hq/node_modules/@egos/chatbot-core/src/index.ts:26:  EGOS_DEFAULT_MODELS,
apps/egos-hq/node_modules/@egos/chatbot-core/README.md:25:    primary: { modelId: 'qwen-turbo', providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY' },
apps/egos-hq/node_modules/@egos/chatbot-core/README.md:26:    fallback: { modelId: 'qwen/qwen3-coder:free', providerEnvKey: 'OPENROUTER_API_KEY',
apps/egos-hq/.next/server/app/api/hq/actions/codex-review/route.js:1:(()=>{var a={};a.id=9972,a.ids=[9972],a.modules={261:a=>{"use strict";a.exports=require("next/dist/shared/lib/router/utils/app-paths")},3295:a=>{"use strict";a.exports=require("next/dist/server/app-render/after-task-async-storage.external.js")},10846:a=>{"use strict";a.exports=require("next/dist/compiled/next-server/app-page.runtime.prod.js")},12288:(a,b,c)=>{"use strict";c.r(b),c.d(b,{handler:()=>F,patchFetch:()=>E,routeModule:()=>A,serverHooks:()=>D,workAsyncStorage:()=>B,workUnitAsyncStorage:()=>C});var d={};c.r(d),c.d(d,{POST:()=>z});var e=c(93905),fgrep: apps/_archived/vendas-portal/node_modules/next: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/.bin/next: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/@supabase/ssr: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/@supabase/supabase-js: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/typescript: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/@types/react: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/@types/node: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/@types/react-dom: No such file or directory
grep: apps/_archived/vendas-portal/node_modules/react-dom: No such file or directory
grep: apps/_archived/trust-page/node_modules/react: No such file or directory
grep: apps/_archived/trust-page/node_modules/next: No such file or directory
grep: apps/_archived/trust-page/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/trust-page/node_modules/.bin/next: No such file or directory
grep: apps/_archived/trust-page/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/trust-page/node_modules/tailwindcss: No such file or directory
grep: apps/_archived/trust-page/node_modules/@tailwindcss/postcss: No such file or directory
grep: apps/_archived/trust-page/node_modules/typescript: No such file or directory
grep: apps/_archived/trust-page/node_modules/@types/react: No such file or directory
grep: apps/_archived/trust-page/node_modules/@types/node: No such file or directory
grep: apps/_archived/trust-page/node_modules/@types/react-dom: No such file or directory
grep: apps/_archived/trust-page/node_modules/react-dom: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/react: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/next: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@egosbr/guard-brasil: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@privy-io/react-auth: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/.bin/next: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/tailwindcss: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@supabase/supabase-js: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@tailwindcss/postcss: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/typescript: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@types/react: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@types/node: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/@types/react-dom: No such file or directory
grep: apps/_archived/guard-brasil-web/node_modules/react-dom: No such file or directory
grep: apps/_archived/egos-landing/node_modules/react: No such file or directory
grep: apps/_archived/egos-landing/node_modules/vite: No such file or directory
grep: apps/_archived/egos-landing/node_modules/@vitejs/plugin-react: No such file or directory
grep: apps/_archived/egos-landing/node_modules/.bin/vite: No such file or directory
grep: apps/_archived/egos-landing/node_modules/react-dom: No such file or directory
grep: apps/_archived/commons/node_modules/react: No such file or directory
grep: apps/_archived/commons/node_modules/eslint-plugin-react-hooks: No such file or directory
grep: apps/_archived/commons/node_modules/react-router-dom: No such file or directory
grep: apps/_archived/commons/node_modules/vite: No such file or directory
grep: apps/_archived/commons/node_modules/lucide-react: No such file or directory
grep: apps/_archived/commons/node_modules/eslint: No such file or directory
grep: apps/_archived/commons/node_modules/@vitejs/plugin-react: No such file or directory
grep: apps/_archived/commons/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/commons/node_modules/.bin/vite: No such file or directory
grep: apps/_archived/commons/node_modules/.bin/eslint: No such file or directory
grep: apps/_archived/commons/node_modules/.bin/autoprefixer: No such file or directory
grep: apps/_archived/commons/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/commons/node_modules/postcss: No such file or directory
grep: apps/_archived/commons/node_modules/autoprefixer: No such file or directory
grep: apps/_archived/commons/node_modules/tailwindcss: No such file or directory
grep: apps/_archived/commons/node_modules/@supabase/supabase-js: No such file or directory
grep: apps/_archived/commons/node_modules/@eslint/js: No such file or directory
grep: apps/_archived/commons/node_modules/eslint-plugin-react-refresh: No such file or directory
grep: apps/_archived/commons/node_modules/typescript-eslint: No such file or directory
grep: apps/_archived/commons/node_modules/@tailwindcss/vite: No such file or directory
grep: apps/_archived/commons/node_modules/typescript: No such file or directory
grep: apps/_archived/commons/node_modules/@types/react: No such file or directory
grep: apps/_archived/commons/node_modules/@types/node: No such file or directory
grep: apps/_archived/commons/node_modules/@types/react-dom: No such file or directory
grep: apps/_archived/commons/node_modules/globals: No such file or directory
grep: apps/_archived/commons/node_modules/react-dom: No such file or directory
grep: apps/_archived/egos-site/node_modules/hono: No such file or directory
grep: apps/_archived/egos-site/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/egos-site/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/egos-site/node_modules/@supabase/supabase-js: No such file or directory
grep: apps/_archived/egos-site/node_modules/typescript: No such file or directory
grep: apps/_archived/egos-site/node_modules/@types/bun: No such file or directory
grep: apps/_archived/egos-council/node_modules/react: No such file or directory
grep: apps/_archived/egos-council/node_modules/next: No such file or directory
grep: apps/_archived/egos-council/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/egos-council/node_modules/.bin/next: No such file or directory
grep: apps/_archived/egos-council/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/egos-council/node_modules/typescript: No such file or directory
grep: apps/_archived/egos-council/node_modules/@types/react: No such file or directory
grep: apps/_archived/egos-council/node_modules/@types/node: No such file or directory
grep: apps/_archived/egos-council/node_modules/@types/react-dom: No such file or directory
grep: apps/_archived/egos-council/node_modules/react-dom: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/hono: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@supabase/supabase-js: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/typescript: No such file or directory
grep: apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@types/bun: No such file or directory
grep: apps/_archived/auth-server/node_modules/bun-types: No such file or directory
grep: apps/_archived/auth-server/node_modules/hono: No such file or directory
grep: apps/_archived/auth-server/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/auth-server/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/auth-server/node_modules/@egos/auth: No such file or directory
grep: apps/_archived/auth-server/node_modules/typescript: No such file or directory
grep: apps/_archived/auth-server/node_modules/@types/node: No such file or directory
grep: apps/_archived/auth-server/node_modules/zod: No such file or directory
grep: apps/_archived/gem-hunter-landing/node_modules/hono: No such file or directory
grep: apps/_archived/gem-hunter-landing/node_modules/.bin/tsserver: No such file or directory
grep: apps/_archived/gem-hunter-landing/node_modules/.bin/tsc: No such file or directory
grep: apps/_archived/gem-hunter-landing/node_modules/typescript: No such file or directory
grep: apps/_archived/gem-hunter-landing/node_modules/@types/bun: No such file or directory
=c(84078),g=c(60965),h=c(44357),i=c(16655),j=c(261),k=c(73125),l=c(30507),m=c(56077),n=c(40382),o=c(28608),p=c(33114),q=c(39448),r=c(17537),s=c(86439),t=c(66479),u=c(79568);let v=process.env.ALIBABA_DASHSCOPE_BASE_URL??"https://dashscope-intl.aliyuncs.com/compatible-mode/v1",w=process.env.ALIBABA_DASHSCOPE_API_KEY??"",x=process.env.OPENROUTER_API_KEY??"";async function y(a){if(w){let b=await fetch(`${v}/chat/completions`,{method:"POST",headers:{Authorization:`Bearer ${w}`,"Content-Type":"application/json"},body:JSON.stringify({model:"qwen-plus",messages:[{role:"user",content:a}],max_tokens:512}),signal:AbortSignal.timeout(3e4)});if(b.ok){let a=await b.json();return a?.choices?.[0]?.message?.content??""}}if(x){let b=await fetch("https://openrouter.ai/api/v1/chat/completions",{method:"POST",headers:{Authorization:`Bearer ${x}`,"Content-Type":"application/json","HTTP-Referer":"https://hq.egos.ia.br"},body:JSON.stringify({model:"google/gemma-4-26b-a4b-it:free",messages:[{role:"user",content:a}],max_tokens:512}),signal:AbortSignal.timeout(3e4)});if(b.ok){let a=await b.json();return a?.choices?.[0]?.message?.content??""}}throw Error("No LLM provider available")}async function z(){try{let a=`You are the EGOS Constitutional Reviewer. Run a quick health check:
apps/egos-hq/.next/standalone/apps/egos-hq/.next/server/app/api/hq/actions/codex-review/route.js:1:(()=>{var a={};a.id=9972,a.ids=[9972],a.modules={261:a=>{"use strict";a.exports=require("next/dist/shared/lib/router/utils/app-paths")},3295:a=>{"use strict";a.exports=require("next/dist/server/app-render/after-task-async-storage.external.js")},10846:a=>{"use strict";a.exports=require("next/dist/compiled/next-server/app-page.runtime.prod.js")},12288:(a,b,c)=>{"use strict";c.r(b),c.d(b,{handler:()=>F,patchFetch:()=>E,routeModule:()=>A,serverHooks:()=>D,workAsyncStorage:()=>B,workUnitAsyncStorage:()=>C});var d={};c.r(d),c.d(d,{POST:()=>z});var e=c(93905),f=c(84078),g=c(60965),h=c(44357),i=c(16655),j=c(261),k=c(73125),l=c(30507),m=c(56077),n=c(40382),o=c(28608),p=c(33114),q=c(39448),r=c(17537),s=c(86439),t=c(66479),u=c(79568);let v=process.env.ALIBABA_DASHSCOPE_BASE_URL??"https://dashscope-intl.aliyuncs.com/compatible-mode/v1",w=process.env.ALIBABA_DASHSCOPE_API_KEY??"",x=process.env.OPENROUTER_API_KEY??"";async function y(a){if(w){let b=await fetch(`${v}/chat/completions`,{method:"POST",headers:{Authorization:`Bearer ${w}`,"Content-Type":"application/json"},body:JSON.stringify({model:"qwen-plus",messages:[{role:"user",content:a}],max_tokens:512}),signal:AbortSignal.timeout(3e4)});if(b.ok){let a=await b.json();return a?.choices?.[0]?.message?.content??""}}if(x){let b=await fetch("https://openrouter.ai/api/v1/chat/completions",{method:"POST",headers:{Authorization:`Bearer ${x}`,"Content-Type":"application/json","HTTP-Referer":"https://hq.egos.ia.br"},body:JSON.stringify({model:"google/gemma-4-26b-a4b-it:free",messages:[{role:"user",content:a}],max_tokens:512}),signal:AbortSignal.timeout(3e4)});if(b.ok){let a=await b.json();return a?.choices?.[0]?.message?.content??""}}throw Error("No LLM provider available")}async function z(){try{let a=`You are the EGOS Constitutional Reviewer. Run a quick health check:
apps/_archived/egos-site/src/content/posts/egos-showcase.md:139:cat packages/chatbot-core/src/model-router.ts | grep "EGOS_DEFAULT_MODELS" -A 10
apps/_archived/egos-site-pre-v3-2026-05-07/src/content/posts/egos-showcase.md:139:cat packages/chatbot-core/src/model-router.ts | grep "EGOS_DEFAULT_MODELS" -A 10
packages/chatbot-core/src/types.ts:32:  providerEnvKey: string;
packages/chatbot-core/src/create-chatbot.ts:13: *     models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY', baseUrl: '...' } },
packages/chatbot-core/src/create-chatbot.ts:240:        primary: { ...models.primary, providerEnvKey: '__BYOK__' },
packages/chatbot-core/src/create-chatbot.ts:247:      process.env[models.primary.providerEnvKey] ||
packages/chatbot-core/src/create-chatbot.ts:248:      (models.fallback && process.env[models.fallback.providerEnvKey]) ||
packages/chatbot-core/src/create-chatbot.ts:249:      (models.fast && process.env[models.fast.providerEnvKey]);
packages/chatbot-core/src/model-router.ts:27:export const EGOS_DEFAULT_MODELS: ModelConfig = {
packages/chatbot-core/src/model-router.ts:30:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:37:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:45:    providerEnvKey: 'OPENROUTER_API_KEY',
packages/chatbot-core/src/model-router.ts:75:      const apiKey = process.env[tier.providerEnvKey] ?? '';
packages/chatbot-core/src/index.ts:11: *   models: { primary: { modelId: 'qwen-plus', providerEnvKey: 'DASHSCOPE_API_KEY' } },
packages/chatbot-core/src/index.ts:26:  EGOS_DEFAULT_MODELS,
packages/chatbot-core/README.md:25:    primary: { modelId: 'qwen-turbo', providerEnvKey: 'ALIBABA_DASHSCOPE_API_KEY' },
packages/chatbot-core/README.md:26:    fallback: { modelId: 'qwen/qwen3-coder:free', providerEnvKey: 'OPENROUTER_API_KEY',
packages/mcp-g-pecas/dist/index.js:38782:var DASHSCOPE_BASE = process.env.ALIBABA_DASHSCOPE_BASE_URL ?? "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";

exec
/bin/bash -lc 'cd packages/pii-purge && git ls-files | head -5 && cd ../.. && git ls-files packages/pii-purge | head -5' in /home/enio/egos
 succeeded in 0ms:
README.md
package.json
src/cli.ts
src/dictionary.ts
src/patterns.ts
packages/pii-purge/README.md
packages/pii-purge/package.json
packages/pii-purge/src/cli.ts
packages/pii-purge/src/dictionary.ts
packages/pii-purge/src/patterns.ts

exec
/bin/bash -lc "sed -n '1,240p' packages/pii-purge/src/purge.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Purge Engine — Replaces entity identifiers with stable tokens.
 *
 * Safety rules:
 * - --dry-run (default): compute planned changes, NEVER write files
 * - --apply: write files + emit hash-chained audit log
 * - fuzzy-REVIEW matches are SKIPPED (never auto-purged)
 * - Token map is stable: same entity always gets same [PESSOA_N] across all files
 * - Replacements are done end-to-start to preserve offsets
 * - Audit log: each record has sha256(before) + sha256(after) + prevHash chain
 */

import { createHash } from 'node:crypto';
import { readFile, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import type { Entity } from './dictionary.js';
import type { EntityPattern } from './patterns.js';
import type { Finding } from './scanner.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface TokenMap {
  /** entity.id → replacement token string */
  [entityId: string]: string;
}

export interface PlannedChange {
  file: string;
  findingsCount: number;
  /** The replacement token that will be applied (safe to log) */
  token: string;
}

export interface AuditRecord {
  ts: string;
  file: string;
  sha256Before: string;
  sha256After: string;
  findingsApplied: number;
  prevHash: string;
  recordHash: string;
}

export interface PurgeResult {
  mode: 'dry-run' | 'apply';
  planned: PlannedChange[];
  applied: string[];
  skippedFuzzy: number;
  auditLog: AuditRecord[];
  auditLogPath?: string;
}

// ─── Token map ────────────────────────────────────────────────────────────────

/**
 * Build a stable token map from the entity list.
 * Entities are assigned [PESSOA_1], [PESSOA_2], ... in dict order (index).
 * The same token is used for ALL identifiers belonging to that entity.
 */
export function buildTokenMap(entities: Entity[]): TokenMap {
  const map: TokenMap = {};
  for (let i = 0; i < entities.length; i++) {
    map[entities[i]!.id] = `[PESSOA_${i + 1}]`;
  }
  return map;
}

// ─── Hash helper ──────────────────────────────────────────────────────────────

function sha256(text: string): string {
  return createHash('sha256').update(text, 'utf-8').digest('hex');
}

// ─── Text replacement ─────────────────────────────────────────────────────────

/**
 * Apply all non-fuzzy findings to a text string, replacing matched spans with tokens.
 * Replacements are done from last to first (end-to-start) so earlier offsets stay valid.
 *
 * @returns { result, appliedCount } — result is the replaced text
 */
export function applyReplacements(
  text: string,
  findings: Finding[],
  tokenMap: TokenMap,
): { result: string; appliedCount: number } {
  // Filter out fuzzy-REVIEW (never auto-purge)
  const applicable = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');

  if (applicable.length === 0) {
    return { result: text, appliedCount: 0 };
  }

  const lines = text.split('\n');

  // Group by line, process each line end-to-start within findings
  // Build a flat list of { lineIdx, lineOffset, matchLength, token }
  interface Span {
    lineIdx: number;
    lineOffset: number;
    matchLength: number;
    token: string;
  }

  const spans: Span[] = applicable.map(f => ({
    lineIdx: f.line - 1,
    lineOffset: f.lineOffset,
    matchLength: f.matchLength,
    token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
  }));

  // BUG-001 fix: remove OVERLAPPING spans before replacing.
  // Two patterns (a plate written with and without its dash) can match the same span; // scan-ok: format note
  // applying both corrupts the output ([PESSOA_1]_1]). Keep longest-wins, drop overlaps.
  // Sort start-to-end (line asc, offset asc, length desc) then greedily keep non-overlapping.
  spans.sort((a, b) =>
    a.lineIdx - b.lineIdx || a.lineOffset - b.lineOffset || b.matchLength - a.matchLength,
  );
  const kept: Span[] = [];
  const lastEndByLine = new Map<number, number>();
  for (const s of spans) {
    const lastEnd = lastEndByLine.get(s.lineIdx) ?? -1;
    if (s.lineOffset >= lastEnd) {
      kept.push(s);
      lastEndByLine.set(s.lineIdx, s.lineOffset + s.matchLength);
    }
    // else: overlaps an already-kept span on this line → drop (avoids corruption)
  }

  // Apply kept spans end-to-start (line desc, offset desc) so earlier offsets stay valid
  kept.sort((a, b) =>
    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
  );
  for (const span of kept) {
    const line = lines[span.lineIdx];
    if (line === undefined) continue;
    lines[span.lineIdx] =
      line.slice(0, span.lineOffset) +
      span.token +
      line.slice(span.lineOffset + span.matchLength);
  }

  return { result: lines.join('\n'), appliedCount: kept.length };
}

// ─── Main purge function ──────────────────────────────────────────────────────

/**
 * Run the purge engine over a set of findings.
 *
 * @param findings       - all findings from the scanner
 * @param patterns       - all compiled patterns (used only for fuzzy count)
 * @param tokenMap       - entity id → replacement token
 * @param mode           - 'dry-run' (default) or 'apply'
 * @param auditLogDir    - where to write the audit log (only used in apply mode)
 */
export async function runPurge(
  findings: Finding[],
  tokenMap: TokenMap,
  mode: 'dry-run' | 'apply',
  auditLogDir?: string,
): Promise<PurgeResult> {
  // Group findings by file
  const byFile = new Map<string, Finding[]>();
  for (const f of findings) {
    const arr = byFile.get(f.file) ?? [];
    arr.push(f);
    byFile.set(f.file, arr);
  }

  const planned: PlannedChange[] = [];
  const applied: string[] = [];
  const auditLog: AuditRecord[] = [];
  let skippedFuzzy = 0;
  let prevHash = '0'.repeat(64);

  // Count fuzzy findings (for reporting)
  for (const f of findings) {
    if (f.matchType === 'fuzzy-REVIEW') skippedFuzzy++;
  }

  for (const [filePath, fileFindings] of byFile) {
    const nonFuzzy = fileFindings.filter(f => f.matchType !== 'fuzzy-REVIEW');
    if (nonFuzzy.length === 0) continue;

    // Pick the first token seen for this file (for reporting)
    const firstEntityId = nonFuzzy[0]!.entityId;
    const token = tokenMap[firstEntityId] ?? '[PESSOA_?]';

    planned.push({ file: filePath, findingsCount: nonFuzzy.length, token });

    if (mode === 'apply') {
      const before = await readFile(filePath, 'utf-8');
      const hashBefore = sha256(before);

      const { result: after, appliedCount } = applyReplacements(before, fileFindings, tokenMap);
      const hashAfter = sha256(after);

      await writeFile(filePath, after, 'utf-8');
      applied.push(filePath);

      // Build audit record
      const record: Omit<AuditRecord, 'recordHash'> = {
        ts: new Date().toISOString(),
        file: filePath,
        sha256Before: hashBefore,
        sha256After: hashAfter,
        findingsApplied: appliedCount,
        prevHash,
      };
      const recordHash = sha256(JSON.stringify(record));
      const fullRecord: AuditRecord = { ...record, recordHash };
      auditLog.push(fullRecord);
      prevHash = recordHash;
    }
  }

  let auditLogPath: string | undefined;
  if (mode === 'apply' && auditLog.length > 0 && auditLogDir) {
    const ts = new Date().toISOString().replace(/[:.]/g, '-');
    auditLogPath = join(auditLogDir, `pii-purge-audit-${ts}.jsonl`);
    const lines = auditLog.map(r => JSON.stringify(r)).join('\n') + '\n';
    await writeFile(auditLogPath, lines, 'utf-8');
  }

  return {
    mode,
    planned,
    applied,
    skippedFuzzy,
    auditLog,
    auditLogPath,
  };
}

exec
/bin/bash -lc "sed -n '1,240p' packages/pii-purge/src/patterns.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Pattern Generator — Builds all format-variant RegExps for a given Entity.
 *
 * Safety rules:
 * - CPF: formatted (NNN.NNN.NNN-NN) AND unformatted (NNNNNNNNNNN) → exact/format-variant
 * - Phone: with/without DDD parens/spaces/dash → exact/format-variant
 * - Plate: old AAA-0000/AAA0000 AND Mercosul AAA0A00 → exact/format-variant (scan-ok: format-spec)
 * - Name: exact string case-insensitive → exact match
 *         normalizeOrtho variant → fuzzy-REVIEW only (NEVER auto-purge)
 * - REDS: raw number match → exact
 *
 * Helpers are reimplemented locally — do NOT import from intelink.
 */

import type { Entity } from './dictionary.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW' | 'literal-LEFTOVER';
export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';

export interface EntityPattern {
  entityId: string;
  fieldType: EntityFieldType;
  matchType: MatchType;
  /** The compiled regex. Always has 'g' flag. */
  regex: RegExp;
}

// ─── Local format helpers (no intelink import) ────────────────────────────────

/** Strip all non-digit chars */
function digitsOnly(s: string): string {
  return s.replace(/\D/g, '');
}

/**
 * Strip combining diacritics (accents) and lower-case.
 * Used for fuzzy name normalization.
 */
export function normalizeOrtho(s: string): string {
  return s
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .trim();
}

/** Escape all regex-special chars in a string */
function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// ─── Per-type pattern builders ────────────────────────────────────────────────

/**
 * CPF — generates two patterns per CPF value:
 *   1. exact match (the string as given, escaped)
 *   2. all format variants (with/without dots and dash)
 * Both are `format-variant` matchType because they are structural equivalents.
 */
function cpfPatterns(entityId: string, cpfs: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const cpf of cpfs) {
    const digits = digitsOnly(cpf);
    if (digits.length !== 11) continue; // skip malformed

    // Formatted: DDD.DDD.DDD-DD
    const formatted = `${digits.slice(0, 3)}\\.${digits.slice(3, 6)}\\.${digits.slice(6, 9)}-${digits.slice(9)}`;
    // Unformatted: DDDDDDDDDDD (word boundary to avoid partial matches)
    const unformatted = digits;

    // Single pattern that matches both variants
    const src = `\\b(?:${formatted}|${unformatted})\\b`;
    results.push({
      entityId,
      fieldType: 'cpf',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Phone — matches with/without DDD parens, spaces, dashes.
 * Ex.: (11) 90000-0000 → 11900000000 → various delimiters (scan-ok: synthetic example)
 */
function phonePatterns(entityId: string, phones: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const phone of phones) {
    const digits = digitsOnly(phone);
    if (digits.length < 10 || digits.length > 13) continue; // skip malformed

    // Strip country code if present (+55)
    const local = digits.startsWith('55') && digits.length > 11 ? digits.slice(2) : digits;
    const ddd = local.slice(0, 2);
    const num = local.slice(2);

    // num may be 8 or 9 digits
    const half1 = num.slice(0, num.length - 4);
    const half2 = num.slice(-4);

    // Pattern: optional +55, optional parens on DDD, various delimiters
    const dddPart = `(?:\\+55[\\s-]?)?(?:\\(?${escapeRegex(ddd)}\\)?[\\s-]?)`;
    const numPart = `${escapeRegex(half1)}[-\\s]?${escapeRegex(half2)}`;
    const src = `\\b${dddPart}${numPart}\\b`;

    results.push({
      entityId,
      fieldType: 'phone',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Plate — matches old format (AAA-0000 / AAA0000) and Mercosul (AAA0A00). (scan-ok: format-spec)
 * We also handle the reverse: given Mercosul, emit both.
 */
function platePatterns(entityId: string, plates: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const plate of plates) {
    // Normalize: strip spaces/dashes, upper-case
    const clean = plate.replace(/[\s-]/g, '').toUpperCase();

    // Detect old format: 3 letters + 4 digits
    const isOld = /^[A-Z]{3}\d{4}$/.test(clean);
    // Detect Mercosul: 3 letters + digit + letter + 2 digits
    const isMercosul = /^[A-Z]{3}\d[A-Z]\d{2}$/.test(clean);

    if (!isOld && !isMercosul) continue;

    const escaped = escapeRegex(clean);
    let src: string;

    if (isOld) {
      // Match with or without dash: ABC-1234 or ABC1234 (scan-ok: format-spec)
      const letters = escapeRegex(clean.slice(0, 3));
      const digits = escapeRegex(clean.slice(3));
      src = `\\b${letters}[-]?${digits}\\b`;
    } else {
      // Mercosul — exact only (no dash variant exists)
      src = `\\b${escaped}\\b`;
    }

    results.push({
      entityId,
      fieldType: 'plate',
      matchType: isOld ? 'format-variant' : 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Name — two patterns per name:
 *   1. Exact case-insensitive string match (matchType: 'exact') → auto-purgeable
 *   2. Accent-stripped/ortho-normalized version (matchType: 'fuzzy-REVIEW') → flag only
 */
function namePatterns(entityId: string, names: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const name of names) {
    const trimmed = name.trim();
    if (!trimmed) continue;

    // Exact match (case-insensitive)
    const exactSrc = `\\b${escapeRegex(trimmed)}\\b`;
    results.push({
      entityId,
      fieldType: 'name',
      matchType: 'exact',
      regex: new RegExp(exactSrc, 'gi'),
    });

    // Ortho-normalized (accent-stripped) variant — REVIEW only
    const normalized = normalizeOrtho(trimmed);
    if (normalized !== trimmed.toLowerCase()) {
      const fuzzyEscaped = escapeRegex(normalized);
      results.push({
        entityId,
        fieldType: 'name',
        matchType: 'fuzzy-REVIEW',
        regex: new RegExp(`\\b${fuzzyEscaped}\\b`, 'gi'),
      });
    }
  }
  return results;
}

/**
 * REDS — matches the raw REDS number (digits only) with optional keyword prefix.
 */
function redsPatterns(entityId: string, reds: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const r of reds) {
    const digits = digitsOnly(r);
    if (!digits) continue;
    const src = `\\b(?:REDS[:\\s]*)?${escapeRegex(digits)}\\b`;
    results.push({
      entityId,
      fieldType: 'reds',
      matchType: 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * Generate all EntityPatterns for a single Entity.
 * Returns patterns in a deterministic order: cpf → phone → plate → reds → name.
 * Name fuzzy patterns are always last (lowest priority for matching).
 */
export function generateEntityPatterns(entity: Entity): EntityPattern[] {
  const patterns: EntityPattern[] = [];
  if (entity.cpfs?.length) patterns.push(...cpfPatterns(entity.id, entity.cpfs));
  if (entity.phones?.length) patterns.push(...phonePatterns(entity.id, entity.phones));
  if (entity.plates?.length) patterns.push(...platePatterns(entity.id, entity.plates));
  if (entity.reds?.length) patterns.push(...redsPatterns(entity.id, entity.reds));
  if (entity.names?.length) patterns.push(...namePatterns(entity.id, entity.names));
  return patterns;
}

/**
 * Generate all EntityPatterns for every entity in the dictionary.
 * Entities are processed in dict order (index 0 first).
 */
export function generateAllPatterns(entities: Entity[]): EntityPattern[] {
  return entities.flatMap(generateEntityPatterns);
}

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/scanner.ts | sed -n '185,222p'" in /home/enio/egos
 succeeded in 0ms:
   185	    for (const v of e.phones ?? []) out.push({ raw: v, entityId: e.id, type: 'phone' });
   186	    for (const v of e.plates ?? []) out.push({ raw: v, entityId: e.id, type: 'plate' });
   187	    for (const v of e.names ?? []) out.push({ raw: v, entityId: e.id, type: 'name' });
   188	    for (const v of e.reds ?? []) out.push({ raw: v, entityId: e.id, type: 'reds' });
   189	  }
   190	  return out;
   191	}
   192	
   193	/**
   194	 * Case-insensitive literal substring search for raw dict values.
   195	 * NEVER includes the matched value in a Finding (T0 §3).
   196	 */
   197	export function scanLiteralValues(
   198	  text: string,
   199	  filePath: string,
   200	  values: LiteralValue[],
   201	): Finding[] {
   202	  const findings: Finding[] = [];
   203	  const lines = text.split('\n');
   204	  for (const v of values) {
   205	    const needle = (v.raw ?? '').toLowerCase();
   206	    if (needle.length < 3) continue; // avoid trivial/noisy short matches
   207	    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
   208	      const hay = lines[lineIdx]!.toLowerCase();
   209	      let from = 0;
   210	      let idx: number;
   211	      while ((idx = hay.indexOf(needle, from)) !== -1) {
   212	        findings.push({
   213	          file: filePath,
   214	          line: lineIdx + 1,
   215	          entityId: v.entityId,
   216	          type: v.type,
   217	          matchType: 'literal-LEFTOVER',
   218	          lineOffset: idx,
   219	          matchLength: v.raw.length,
   220	        });
   221	        from = idx + needle.length;
   222	      }

exec
/bin/bash -lc "sed -n '90,190p' packages/pii-purge/src/cli.ts" in /home/enio/egos
 succeeded in 0ms:
  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.
  // Wire this into pre-commit / publish paths (R-SEC-005) to block on known entities.
  if (opts.verifyOnly) {
    const patternHits = (await scanDirectory(opts.target, patterns, opts.entityDict)).filter(f => f.matchType !== 'fuzzy-REVIEW');
    const literalHits = await scanDirectoryLiteral(opts.target, literalValues, opts.entityDict);
    const total = patternHits.length + literalHits.length;
    if (opts.json) {
      console.log(JSON.stringify({
        mode: 'verify-only',
        clean: total === 0,
        findings: [...patternHits, ...literalHits].map(f => ({
          file: f.file, line: f.line, entityId: f.entityId, type: f.type, matchType: f.matchType,
        })),
      }, null, 2));
    } else if (total === 0) {
      console.log('[pii-purge] VERIFY-ONLY: clean — zero known-entity findings');
    } else {
      console.error(`[pii-purge] VERIFY-ONLY FAILED: ${total} known-entity finding(s) remain`);
      for (const f of [...patternHits, ...literalHits]) {
        console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}`);
      }
    }
    process.exit(total === 0 ? 0 : 1);
  }

  // 3. Scan
  const findings = await scanDirectory(opts.target, patterns, opts.entityDict);

  const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
  const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');

  if (!opts.json) {
    console.log(`[pii-purge] Scan complete: ${findings.length} total findings`);
    console.log(`  auto-purgeable: ${autoFindings.length}`);
    console.log(`  REVIEW_REQUIRED (fuzzy): ${reviewFindings.length}`);
    for (const f of findings) {
      // NEVER print matched value — only metadata
      const flag = f.matchType === 'fuzzy-REVIEW' ? ' [REVIEW_REQUIRED]' : '';
      console.log(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}${flag}`);
    }
  }

  // 4. Build token map
  const tokenMap = buildTokenMap(dict.entities);

  // 5. Purge (or dry-run)
  const auditLogDir = dirname(opts.entityDict);
  mkdirSync(auditLogDir, { recursive: true });

  const purgeResult = await runPurge(findings, tokenMap, mode, auditLogDir);

  if (!opts.json) {
    if (mode === 'dry-run') {
      console.log(`[pii-purge] DRY-RUN: would modify ${purgeResult.planned.length} file(s)`);
      for (const p of purgeResult.planned) {
        console.log(`  ${p.file} → ${p.findingsCount} replacement(s) with ${p.token}`);
      }
    } else {
      console.log(`[pii-purge] APPLIED to ${purgeResult.applied.length} file(s)`);
      if (purgeResult.auditLogPath) {
        console.log(`[pii-purge] Audit log: ${purgeResult.auditLogPath}`);
      }
    }
  }

  // 6. Verify (only in apply mode — meaningful post-write)
  let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
  if (mode === 'apply') {
    verifyResult = await verify(opts.target, patterns, literalValues, opts.entityDict);
    if (!opts.json) {
      if (verifyResult.cleanExit) {
        console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
      } else {
        console.error(`[pii-purge] VERIFY FAILED: ${verifyResult.remaining.length} auto-purgeable finding(s) remain`);
        for (const f of verifyResult.remaining) {
          console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type}`);
        }
      }
    }
  }

  if (opts.json) {
    console.log(JSON.stringify({
      mode,
      findings: findings.map(f => ({
        file: f.file,
        line: f.line,
        entityId: f.entityId,
        type: f.type,
        matchType: f.matchType,
        // matched value intentionally omitted (T0 §3)
      })),
      planned: purgeResult.planned,
      applied: purgeResult.applied,
      skippedFuzzy: purgeResult.skippedFuzzy,
      verifyCleanExit: verifyResult.cleanExit,
      reviewRequiredCount: verifyResult.reviewRequired.length,
      auditLogPath: purgeResult.auditLogPath ?? null,
    }, null, 2));
  }


exec
/bin/bash -lc "sed -n '190,230p' packages/pii-purge/src/cli.ts" in /home/enio/egos
 succeeded in 0ms:

  // 7. Exit code
  const hasFuzzy = verifyResult.reviewRequired.length > 0;
  const hasRemaining = !verifyResult.cleanExit;

  if (hasFuzzy || hasRemaining) {
    if (!opts.json) {
      if (hasFuzzy) {
        console.warn(`[pii-purge] ${verifyResult.reviewRequired.length} REVIEW_REQUIRED finding(s) — resolve manually before publishing`);
      }
    }
    process.exit(1);
  }

  process.exit(0);
}

main().catch(err => {
  console.error('[pii-purge] Fatal error:', err instanceof Error ? err.message : String(err));
  process.exit(1);
});

exec
/bin/bash -lc 'tmp=$(mktemp -d); cd "$tmp"; git init -q; echo '"'contato Joao hoje' > a.txt; cat > dict.json <<'EOF'
{\"entities\":[{\"id\":\"e1\",\"names\":[\"João\"]}]}
EOF
git add a.txt dict.json && git commit -qm init; bun /home/enio/egos/packages/pii-purge/src/cli.ts --entity-dict dict.json --target . --verify-only; echo exit="'$?' in /home/enio/egos
 succeeded in 0ms:
[pii-purge] mode=dry-run dict=/tmp/tmp.zw3Ys6SvFU/dict.json target=/tmp/tmp.zw3Ys6SvFU
[pii-purge] Loaded 1 entities
[pii-purge] VERIFY-ONLY: clean — zero known-entity findings
exit=0

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/cli.ts | sed -n '88,110p'" in /home/enio/egos
 succeeded in 0ms:
    88	  const literalValues = flattenEntityValues(dict.entities);
    89	
    90	  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.
    91	  // Wire this into pre-commit / publish paths (R-SEC-005) to block on known entities.
    92	  if (opts.verifyOnly) {
    93	    const patternHits = (await scanDirectory(opts.target, patterns, opts.entityDict)).filter(f => f.matchType !== 'fuzzy-REVIEW');
    94	    const literalHits = await scanDirectoryLiteral(opts.target, literalValues, opts.entityDict);
    95	    const total = patternHits.length + literalHits.length;
    96	    if (opts.json) {
    97	      console.log(JSON.stringify({
    98	        mode: 'verify-only',
    99	        clean: total === 0,
   100	        findings: [...patternHits, ...literalHits].map(f => ({
   101	          file: f.file, line: f.line, entityId: f.entityId, type: f.type, matchType: f.matchType,
   102	        })),
   103	      }, null, 2));
   104	    } else if (total === 0) {
   105	      console.log('[pii-purge] VERIFY-ONLY: clean — zero known-entity findings');
   106	    } else {
   107	      console.error(`[pii-purge] VERIFY-ONLY FAILED: ${total} known-entity finding(s) remain`);
   108	      for (const f of [...patternHits, ...literalHits]) {
   109	        console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}`);
   110	      }

exec
/bin/bash -lc 'tmp=$(mktemp -d); cd "$tmp"; git init -q; echo '"'banana split' > a.txt; cat > dict.json <<'EOF'
{\"entities\":[{\"id\":\"e1\",\"names\":[\"Ana\"]}]}
EOF
git add a.txt dict.json && git commit -qm init; bun /home/enio/egos/packages/pii-purge/src/cli.ts --entity-dict dict.json --target . --verify-only; echo exit="'$?' in /home/enio/egos
 succeeded in 0ms:
[pii-purge] mode=dry-run dict=/tmp/tmp.cnNJp8NOhS/dict.json target=/tmp/tmp.cnNJp8NOhS
[pii-purge] Loaded 1 entities
[pii-purge] VERIFY-ONLY FAILED: 1 known-entity finding(s) remain
  /tmp/tmp.cnNJp8NOhS/a.txt:1 entity=e1 type=name matchType=literal-LEFTOVER
exit=1

exec
/bin/bash -lc "grep -R \"last_value\\|tolerance\\|command:\" -n scripts packages | grep manifest -n | head -80 && grep -R \"grep -c.*echo 0\" -n .egos-manifest.yaml" in /home/enio/egos
 succeeded in 18377ms:
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/bds/models/__pycache__/batching_based_odh_patching_config.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/bds/models/__pycache__/domain_based_patching_configs.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/bds/models/__pycache__/domain_based_odh_patching_config.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/bds/models/__pycache__/batching_based_patching_configs.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/distributed_database/models/__pycache__/create_catalog_peer_with_dedicated_infra_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/distributed_database/models/__pycache__/shard_peer_with_dedicated_infra.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/distributed_database/models/__pycache__/catalog_peer_with_dedicated_infra.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/distributed_database/models/__pycache__/create_shard_peer_with_dedicated_infra_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/batch/models/__pycache__/create_compute_task_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/batch/models/__pycache__/compute_task.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_safe/models/__pycache__/mask_data_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/container_instances/models/__pycache__/container.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/container_instances/models/__pycache__/create_container_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/generative_ai_inference/models/__pycache__/summarize_text_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/fleet_apps_management/models/__pycache__/script_based_execution_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/__pycache__/authentication_factor_settings_totp_settings.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_science/models/__pycache__/job_exec_probe_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/sql_type_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/top_processes_usage.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/sql_text.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/addm_db_sql_statement_summary.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/host_top_processes.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/opsi/models/__pycache__/top_processes_usage_trend_aggregation.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/create_autonomous_container_database_dataguard_association_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/autonomous_container_database_dataguard.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/edit_autonomous_container_database_dataguard_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/add_standby_autonomous_container_database_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/create_autonomous_container_database_base.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/autonomous_container_database_dataguard_association.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database/models/__pycache__/update_autonomous_container_database_data_guard_association_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_object_store_script_user_defined_custom_precheck_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_local_script_user_defined_custom_precheck_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_object_store_script_user_defined_custom_precheck_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_local_script_user_defined_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_object_store_script_user_defined_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_object_store_script_user_defined_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_local_script_user_defined_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_local_script_user_defined_custom_precheck_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/cloud_bridge/models/__pycache__/vmware_vm_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/process_set_specification_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/os_command_update_query_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/os_command_query_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/urllib3/contrib/__pycache__/pyopenssl.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/pip/_internal/utils/__pycache__/misc.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/pip/_vendor/urllib3/contrib/__pycache__/pyopenssl.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/dotenv/__pycache__/cli.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/bds/models/__pycache__/batching_based_odh_patching_config.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/bds/models/__pycache__/domain_based_patching_configs.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/bds/models/__pycache__/domain_based_odh_patching_config.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/bds/models/__pycache__/batching_based_patching_configs.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/distributed_database/models/__pycache__/create_catalog_peer_with_dedicated_infra_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/distributed_database/models/__pycache__/shard_peer_with_dedicated_infra.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/distributed_database/models/__pycache__/catalog_peer_with_dedicated_infra.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/distributed_database/models/__pycache__/create_shard_peer_with_dedicated_infra_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/batch/models/__pycache__/create_compute_task_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/batch/models/__pycache__/compute_task.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/data_safe/models/__pycache__/mask_data_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/container_instances/models/__pycache__/container.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/container_instances/models/__pycache__/create_container_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/generative_ai_inference/models/__pycache__/summarize_text_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/fleet_apps_management/models/__pycache__/script_based_execution_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/identity_domains/models/__pycache__/authentication_factor_settings_totp_settings.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/data_science/models/__pycache__/job_exec_probe_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/sql_type_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/top_processes_usage.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/sql_text.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/addm_db_sql_statement_summary.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/host_top_processes.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/opsi/models/__pycache__/top_processes_usage_trend_aggregation.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/create_autonomous_container_database_dataguard_association_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/autonomous_container_database_dataguard.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/edit_autonomous_container_database_dataguard_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/add_standby_autonomous_container_database_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/create_autonomous_container_database_base.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/autonomous_container_database_dataguard_association.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/database/models/__pycache__/update_autonomous_container_database_data_guard_association_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_object_store_script_user_defined_custom_precheck_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_local_script_user_defined_custom_precheck_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_object_store_script_user_defined_custom_precheck_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_local_script_user_defined_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/update_run_object_store_script_user_defined_step_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_object_store_script_user_defined_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_local_script_user_defined_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/disaster_recovery/models/__pycache__/run_local_script_user_defined_custom_precheck_step.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/cloud_bridge/models/__pycache__/vmware_vm_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/process_set_specification_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/os_command_update_query_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/oci/stack_monitoring/models/__pycache__/os_command_query_properties.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/urllib3/contrib/__pycache__/pyopenssl.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/pip/_internal/utils/__pycache__/misc.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/pip/_vendor/urllib3/contrib/__pycache__/pyopenssl.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib64/python3.12/site-packages/dotenv/__pycache__/cli.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/bin/python: binary file matches
grep: scripts/oracle-instance-launcher/.venv/bin/python3.12: binary file matches
grep: scripts/oracle-instance-launcher/.venv/bin/python3: binary file matches
2:scripts/egos-home/docs/CAPABILITY_REGISTRY.md:661:- **`readme-syncer`** — patches `<!-- metric:ID -->` annotations from manifest `last_value`
467:scripts/manifest-generator.ts:60:    command: string;
468:scripts/manifest-generator.ts:61:    tolerance: string;
469:scripts/manifest-generator.ts:62:    last_value: string;
470:scripts/manifest-generator.ts:324:        command: buildVerificationCommand(claim.id, claim.value, repoDir),
471:scripts/manifest-generator.ts:325:        tolerance: "±10%",
472:scripts/manifest-generator.ts:326:        last_value: claim.value,
91:    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
173:    command: "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"

codex
The new PII verify-only path can both miss fuzzy known-entity variants and falsely block clean text due to raw substring literal matching. These issues undermine the new publish-gate behavior introduced by the patch.

Full review comments:

- [P1] Count fuzzy matches in verify-only gate — /home/enio/egos/packages/pii-purge/src/cli.ts:93-93
  When `--verify-only` is used, this filters out `fuzzy-REVIEW` findings before deciding the exit code, so accent/orthography variants that the scanner already marks as requiring HITL are reported clean. For example, a dict entry `names: ["João"]` and target text `Joao` produces only a fuzzy finding, no literal hit, and exits 0; that defeats the intended publish/pre-commit gate for known PII variants.

- [P2] Match literal values on token boundaries — /home/enio/egos/packages/pii-purge/src/scanner.ts:211-211
  The literal safety-net uses raw substring search, so short/common names in the dictionary match inside unrelated words and make `--verify-only` or post-purge verification fail on clean text. For example, `names: ["Ana"]` flags `banana` as `literal-LEFTOVER`, whereas the normal name pattern uses word boundaries; this can block publishing after a successful purge until the literal scan applies type-appropriate boundaries or skips ambiguous short values.
The new PII verify-only path can both miss fuzzy known-entity variants and falsely block clean text due to raw substring literal matching. These issues undermine the new publish-gate behavior introduced by the patch.

Full review comments:

- [P1] Count fuzzy matches in verify-only gate — /home/enio/egos/packages/pii-purge/src/cli.ts:93-93
  When `--verify-only` is used, this filters out `fuzzy-REVIEW` findings before deciding the exit code, so accent/orthography variants that the scanner already marks as requiring HITL are reported clean. For example, a dict entry `names: ["João"]` and target text `Joao` produces only a fuzzy finding, no literal hit, and exits 0; that defeats the intended publish/pre-commit gate for known PII variants.

- [P2] Match literal values on token boundaries — /home/enio/egos/packages/pii-purge/src/scanner.ts:211-211
  The literal safety-net uses raw substring search, so short/common names in the dictionary match inside unrelated words and make `--verify-only` or post-purge verification fail on clean text. For example, `names: ["Ana"]` flags `banana` as `literal-LEFTOVER`, whereas the normal name pattern uses word boundaries; this can block publishing after a successful purge until the literal scan applies type-appropriate boundaries or skips ambiguous short values.
```
