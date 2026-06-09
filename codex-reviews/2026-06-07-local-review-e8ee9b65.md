# Codex Local Review — 2026-06-07T19:24:43Z

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
session id: 019ea38b-6e76-7f23-b150-5bceac6908e3
--------
user
changes against 'HEAD~3'
2026-06-07T19:24:45.919760Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T19:24:45.919753Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff fdff002133ce42df149089d6147728cc91c44511 --stat && git diff fdff002133ce42df149089d6147728cc91c44511 --' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |  11 +-
 TASKS_ARCHIVE.md                                   |  12 +++
 agents/agents/article-writer.ts                    |  61 ++---------
 apps/egos-gateway/src/orchestrator.ts              |  45 ++++----
 .../app/api/hq/actions/codex-review/route.ts       |  75 +++++--------
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md       |   2 +-
 docs/strategy/landing-copy-v2-pessoa-comum.md      |  54 ++++++++++
 packages/pii-purge/README.md                       |  19 +++-
 packages/pii-purge/package.json                    |   2 +-
 packages/pii-purge/src/cli.ts                      |  37 ++++++-
 packages/pii-purge/src/patterns.ts                 |   2 +-
 packages/pii-purge/src/pii-purge.test.ts           |  38 ++++++-
 packages/pii-purge/src/purge.ts                    |  25 ++++-
 packages/pii-purge/src/scanner.ts                  | 118 +++++++++++++++++----
 packages/pii-purge/src/verify.ts                   |  30 ++++--
 packages/shared/src/llm-provider.ts                |  96 ++++-------------
 scripts/activation-check.ts                        |   1 -
 scripts/debrief/pipeline.ts                        |  22 ++--
 scripts/gem-hunter-digest.ts                       |  50 ++-------
 scripts/manifest-generator.ts                      |  18 ++--
 scripts/ssot-router.ts                             |  30 +++---
 scripts/test-alibaba-orchestrator.ts               |  39 -------
 scripts/x-opportunity-alert.ts                     |  51 +++------
 scripts/x-post-approval-bot.ts                     |  20 ++--
 26 files changed, 456 insertions(+), 406 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 74e4a4f6..485efdb0 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -144,7 +144,8 @@
 > aiox-core README como referência de qualidade: hooks por IDE, "Comece Aqui 10min", CLI First hierarquia, badges, first-value binário, multilíngue.
 > SSOT do que aprender: docs/competitive-analysis/aiox-learnings.md (a criar)
 
-- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) bilíngue PT/EN. HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
+- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN no máximo opcional/secundário, NUNCA lidera nem bloqueia.** HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
+- [ ] **README-PUBLICO-PT-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07 "tudo PT": o README público (egos-governance) tem seções em INGLÊS ("Why This Exists" L120, comentários de código L179/L192, "Contributing" L262, "License" L272). Traduzir p/ PT-BR (Por que o EGOS existe / Contribuindo / Licença / comentários). Público-alvo é Brasil. HITL antes de push no repo público.
 - [ ] **README-HOOKS-TABLE-001** [P1] `curador` — Criar tabela de paridade de hooks EGOS por IDE (análogo ao aiox): Claude Code (completo — hooks pre/post tool, session, commands), Gemini CLI / Antigravity (GEMINI.md, sem hooks nativos), Codex CLI (AGENTS.md + skills, parcial), Windsurf (rules, parcial), Cursor (cursor-rules, sem hooks), ChatGPT/GPT (system prompt + memory, sem hooks). Salvar em docs/governance/HOOKS_IDE_COMPATIBILITY.md.
 - [ ] **README-FIRST-VALUE-001** [P1] `voz` — Definir "first-value EGOS" (binário, como aiox faz): configurar 1 metaprompt profissional + 1 agente respondendo do jeito certo em <= 10 minutos = first-value atingido. Incluir no README como metric de onboarding.
 - [ ] **README-MULTILINGUAL-001** [P2] `voz` — Criar README.en.md (versão EN do README principal). O EGOS tem público potencial fora do BR — governança de IA é tema global. Estrutura igual ao PT, tradução profissional (não automática).
@@ -369,8 +370,8 @@
 - [ ] **BERNARDO-PW-001** [P2] `prime` — Setar `BERNARDO_PASSWORD_SHA256` em prod p/ rotacionar o default documentado `bernardo2026` (server-side, `central-egos/template/src/app/api/bernardo-guide/route.ts:12`).
 
 ## 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA — sessão 2026-06-04 (Guarani)
-- [ ] **HERMES-DESKTOP-001** [P1] `guarani` `gated:decisão` 🆕 — Instalação e teste e2e do Vite web UI no ambiente local de desenvolvimento do Hermes.
 - [ ] **HERMES-DESKTOP-002** [P1] `pixel` 🆕 — Implementar a UI React dos 5 painéis estendidos (Status, Roster, Audit, Blackboard, Dispersion/Costs) no Hermes Desktop.
+- [ ] **HERMES-DESKTOP-SANDBOX-001** [P2] `5min` — Corrigir sandbox Electron para lançar app nativo: `sudo chown root:root ~/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/chrome-sandbox && sudo chmod 4755 [...]`. Requer terminal com TTY. Alternativa: usar dashboard web em localhost:9119.
 - [ ] **AGENT-AVATARS-001** [P2] `pixel` 🆕 — Criar componente React para geração de avatares etéreos SVG a partir das chaves públicas dos agentes.
 - [ ] **AUDIT-CRYPT-001** [P1] `prime` 🆕 — Implementar o helper de geração de par de chaves e assinatura off-chain secp256k1 para relatórios e commits.
 - [ ] **AUDIT-NOSTR-001** [P2] `prime` 🆕 — Publicação descentralizada de identidades no Nostr (NIP-05) e provas temporais no Bitcoin via OpenTimestamps.
@@ -871,7 +872,11 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
 - [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
 - [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
-- [ ] **PII-PURGE-007** [P0] `prime` `gated:HITL` — Aplicar o motor ao `intelink-clean` (resolve WS1 automaticamente): remover RELINT + mascarar 6 arquivos + verify. Nada vai pro GitHub sem corte do Enio.
+- [x] **PII-PURGE-BUG-001** [P1] `prime` — FIX (2026-06-07): dedupe de spans sobrepostos (longest-wins) em `applyReplacements`. Teste + smoke: `JIZ-6956`+`JIZ6956` → 1 token limpo, sem `[PESSOA_1]_1]`.
+- [x] **PII-PURGE-VERIFY-001** [P1] `prime` — FIX (2026-06-07): safety-net de busca literal (`scanLiteralValues`/`flattenEntityValues`) ligado ao `verify` — independe da tipagem do campo; pega valor de texto em campo numérico. + `--verify-only` (publish gate) + exclui o próprio dict do scan. 31 testes verdes.
+- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — Wire `--verify-only` no pre-commit (R-SEC-005) + paths de publicação (push/NotebookLM/deploy). Mecanismo pronto; falta plugar nos hooks.
+- [ ] **PII-PURGE-SKILL-001** [P2] `prime` — Skill `/purge <repo>`: monta dict (HITL) + dry-run + relatório + apply (HITL) + runbook "como limpar um sistema". Casca ergonômica para qualquer um/IA limpar com 1 comando.
+- [ ] **INTELINK-PLATFORM-GH-CACHE-001** [P1] `prime`+`hermes-ops` — GitHub pode reter `f0cfdb7` (18 PII) por SHA até GC + em forks/PRs. Como INC-PII-001: contatar GitHub Support p/ purgar cache + checar forks/network. Force-push limpou o branch, não garante o cache.
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
 - [ ] **DISCOVER-GATE-001** [P1] `forja` — `scripts/discover-capability.ts <termo>`: busca 4 registries (CAPABILITY/MCP/INTEGRATION/SKILLS) + codebase-memory-mcp + CBC-*. Devolve reuse|extend|new + justificativa.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 24db24f8..e10a7f4f 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3704,3 +3704,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **PRODUCT-TIERS-001** [P0] — OBSOLETA: Enio cravou "sem tiers" (PRODUCT_MODEL); canais≠tiers clarificado v1.1 (bdb5d265). GPT grátis + WhatsApp R$4 = 1 produto pago. Sem pirâmide de preços.
 - [x] **PRODUCT-R4-DEFINITION-001** [P0] — coberto em PRODUCT_MODEL.md "O que está incluso" + "preço não é público". SSOT = PRODUCT_MODEL.md (não criar product-r4.md).
 
+
+## Archived 2026-06-07
+
+### 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA — sessão 2026-06-04 (Guarani)
+- [x] **HERMES-DESKTOP-001** [P1] `guarani` — ✅ 2026-06-07: Hermes v0.16.0 instalado, atualizado, dashboard web :9119 rodando, Telegram @EGOSin_bot configurado (171767219), 2 crons criados (auto-update seg 9h + upstream-watch dom 8h).
+
+
+## Archived 2026-06-07
+
+### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
+- [x] **PII-PURGE-007** [P0] `prime` — Aplicado ao `intelink-clean` (2026-06-07): rm 2 RELINT + mascarar 7 arquivos + orphan squash + force-push. `origin/main` = baseline limpo `4bb4665` (0 PII; era f0cfdb7 c/ 18 hits). Backup local `backup-pre-squash-2026-06-07`.
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
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..e9a6089c 100644
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
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
index b10c9a85..04a2c2ca 100644
--- a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -110,7 +110,7 @@
 
 ## 8. README — abertura (DRAFT p/ HITL — README-FOCUS-REFLECT-001)
 
-> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. Substitui a abertura atual; o overhaul completo (badges/bilíngue) fica no README-OVERHAUL-001.
+> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN nunca lidera.** Substitui a abertura atual; o overhaul completo (badges) fica no README-OVERHAUL-001.
 
 ```markdown
 # EGOS
diff --git a/docs/strategy/landing-copy-v2-pessoa-comum.md b/docs/strategy/landing-copy-v2-pessoa-comum.md
new file mode 100644
index 00000000..c9a9c202
--- /dev/null
+++ b/docs/strategy/landing-copy-v2-pessoa-comum.md
@@ -0,0 +1,54 @@
+# Landing — Copy v2 "pessoa comum" (DRAFT — HITL)
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT pendente corte Enio (R-PUB-001) — não aplicado na landing ainda.
+**Origem:** review Codex gpt-5.5 sobre a landing inteira (Explore extraiu o copy; Codex reescreveu p/ pessoa comum + casos por área).
+**Voz:** PT-BR, EGOS-entidade, colaborativo, sem absoluto, sem preço, sem persona. Liga [EGOS_ONBOARDING_LAUNCH_PLAN.md](EGOS_ONBOARDING_LAUNCH_PLAN.md).
+
+> **Diagnóstico:** só "Comece aqui" + ConsentGate falavam com leigo. Hero/showcase/mycelium/grok eram jargão dev ("orquestração de agentes", "T0→T4", "MCP", "HITL", "stub"). Esta v2 traduz pra gente comum + adiciona casos concretos por área (temos 16 personas de setor prontas).
+
+## 1. Hero — 2 opções (Enio escolhe)
+**Opção A:**
+- Eyebrow: Método gratuito para usar IA com mais segurança
+- H1: **Use IA sem cair em conversa fiada**
+- P: O EGOS ajuda você a usar ChatGPT, Claude ou Gemini com mais método: separando fato de achismo, cuidando de dados sensíveis e organizando o que precisa ser conferido por uma pessoa. É para quem quer ganhar tempo com IA sem entregar CPF, dados de cliente ou decisões importantes no escuro.
+- Botões: "Começar com o metaprompt gratuito" / "Ver checklist de segurança"
+
+**Opção B (recomendada — concisa):**
+- Eyebrow: IA com método para profissionais brasileiros
+- H1: **A IA ajuda. O EGOS organiza.**
+- P: O EGOS mostra como transformar a IA em uma assistente mais útil para o seu trabalho, com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
+- Botões: "Criar meu assistente de IA" / "Detectar dados sensíveis"
+
+## 2. "Como funciona" — 3 passos simples (substitui T0→T4/agentes/MCP)
+1. **Escolha seu tipo de trabalho** — advocacia, clínica, contabilidade, comércio, sala de aula. A IA recebe instruções claras do que fazer e do que evitar.
+2. **Proteja as informações sensíveis** — antes de mandar pra IA, o EGOS ajuda a identificar CPF, CNPJ, prontuário, dados de cliente. Diminui o risco de expor o que não deveria sair do seu controle.
+3. **Confira antes de confiar** — o EGOS organiza a resposta pra você separar o que é fato, o que precisa conferência e o que é sugestão. A decisão final é da pessoa.
+
+## 3. NOVA seção "Como você usa na sua área" (6 cards)
+- **⚖️ Advogado** — analisar documentos e responder clientes sem expor dados do processo. → assistente que lê com cuidado, responde no WhatsApp, mantém registro. *(temos advocacia-starter completo)*
+- **🩺 Médico/Clínica** — usar IA sem expor prontuário/dados de paciente. → IA com dados protegidos + revisão humana antes de orientação sensível.
+- **🧾 Contador** — dados fiscais/CPF/CNPJ em tarefas repetitivas. → organizar pra análise sem tratar dado sensível como texto comum.
+- **🍽️ Comerciante/Restaurante** — cardápio/catálogo em foto/papel/WhatsApp. → foto vira planilha pronta pra revisão. *(temos item-intake LIVE)*
+- **📚 Professor** — material com IA pode ter erro/fonte fraca. → organiza aulas/exercícios/resumos com pontos de conferência antes de usar com alunos.
+- **🌾 Agrônomo** — laudos de solo, orientações de plantio, relatórios de campo, dados de produtores. → assistente da área que organiza e destaca o que precisa validação profissional. *(card ajustado: exemplo mais concreto p/ revisão Codex)*
+
+## 4. Tabela de tradução (aplicar nas outras páginas: showcase/mycelium/guard/grok)
+| Jargão | Versão humana |
+|---|---|
+| orquestração de agentes | organizar tarefas da IA com mais ordem |
+| T0→T4 | níveis de cuidado: do dado mais sensível ao mais público |
+| MCP | conectar a IA a ferramentas/informações autorizadas |
+| HITL | uma pessoa revisa antes de algo importante ser usado/enviado |
+| eval-runner | testes pra ver se a IA faz o que promete |
+| stub | parte incompleta que ainda não é "pronta" |
+| pipeline | sequência de passos até um resultado conferido |
+| SSOT | o lugar principal onde a informação oficial fica |
+| RAG | a IA consulta uma base antes de responder |
+| KB | base de conhecimento que a IA pode consultar |
+
+## 5. Grok Hunter & Mycelium (técnicos demais p/ público comum)
+- **Grok Hunter** → renomear/apresentar como "checador de respostas da IA" (separa fato/dúvida/achismo), OU esconder do menu público.
+- **Mycelium** → apresentar como "rede de conhecimento" (informações organizadas pra IA consultar com contexto), OU manter como página técnica secundária.
+
+---
+*DRAFT. Aplicar na landing (App.tsx + ToolsHub + MyceliumPage) só após corte do Enio. Depois: rebuild + deploy + smoke (deploy.sh).*
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
index 83e8fb0c..9d7f7ea9 100644
--- a/packages/pii-purge/src/purge.ts
+++ b/packages/pii-purge/src/purge.ts
@@ -109,12 +109,29 @@ export function applyReplacements(
     token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   }));
 
-  // Sort end-to-start (line desc, offset desc)
+  // BUG-001 fix: remove OVERLAPPING spans before replacing.
+  // Two patterns (e.g. plate "TST-1234" and "TST1234") can match the same span;
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
index eb9f869f..709f8e76 100644
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
index efcef679..0ca6688c 100644
--- a/scripts/manifest-generator.ts
+++ b/scripts/manifest-generator.ts
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
/bin/bash -lc 'git diff fdff002133ce42df149089d6147728cc91c44511 -- packages/pii-purge/src/scanner.ts packages/pii-purge/src/purge.ts packages/pii-purge/src/verify.ts packages/pii-purge/src/cli.ts packages/pii-purge/src/patterns.ts packages/pii-purge/src/pii-purge.test.ts packages/pii-purge/package.json packages/shared/src/llm-provider.ts apps/egos-gateway/src/orchestrator.ts apps/egos-hq/app/api/hq/actions/codex-review/route.ts scripts/debrief/pipeline.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..e9a6089c 100644
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
index 83e8fb0c..9d7f7ea9 100644
--- a/packages/pii-purge/src/purge.ts
+++ b/packages/pii-purge/src/purge.ts
@@ -109,12 +109,29 @@ export function applyReplacements(
     token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   }));
 
-  // Sort end-to-start (line desc, offset desc)
+  // BUG-001 fix: remove OVERLAPPING spans before replacing.
+  // Two patterns (e.g. plate "TST-1234" and "TST1234") can match the same span;
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
index eb9f869f..709f8e76 100644
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

exec
/bin/bash -lc "sed -n '1,260p' packages/pii-purge/src/scanner.ts && sed -n '1,220p' packages/pii-purge/src/purge.ts && sed -n '1,260p' packages/shared/src/llm-provider.ts && sed -n '75,150p' packages/shared/src/llm-provider.ts" in /home/enio/egos
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
 * Walk a target directory and scan all eligible files.
 * Returns a deduplicated, stable list of findings.
 *
 * @param targetDir  - directory to scan
 * @param patterns   - compiled entity patterns to search for
 */
export async function scanDirectory(
  targetDir: string,
  patterns: EntityPattern[],
): Promise<Finding[]> {
  const allFiles = await collectFiles(targetDir);

  // Filter to git-tracked files when possible
  const gitTracked = getGitTrackedFiles(targetDir);
  const filesToScan = gitTracked
    ? allFiles.filter(f => gitTracked.has(f))
    : allFiles;

  const allFindings: Finding[] = [];

  for (const filePath of filesToScan) {
    const s = await stat(filePath);
    // Skip very large files (>2MB) to avoid memory spikes
    if (s.size > 2 * 1024 * 1024) continue;

    let text: string;
    try {
      text = await readFile(filePath, 'utf-8');
    } catch {
      // Binary or unreadable — skip
      continue;
    }

    const findings = scanText(text, filePath, patterns);
    allFindings.push(...findings);
  }

  return allFindings;
}
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

  // Sort end-to-start (line desc, offset desc)
  spans.sort((a, b) =>
    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
  );

  for (const span of spans) {
    const line = lines[span.lineIdx];
    if (line === undefined) continue;
    lines[span.lineIdx] =
      line.slice(0, span.lineOffset) +
      span.token +
      line.slice(span.lineOffset + span.matchLength);
  }

  return { result: lines.join('\n'), appliedCount: applicable.length };
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

exec
/bin/bash -lc "git status --short && grep -n \"ALIBABA_MODELS\\|SharedLLMProvider\\|OPENROUTER_CHAIN\\|explicitProvider\" -A5 -B2 packages/shared/src/llm-provider.ts && sed -n '100,150p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
 succeeded in 0ms:
?? docs/jobs/2026-06-07-doc-drift-verifier.json
?? docs/jobs/2026-06-07-pre-commit-pipeline.json
1-import type { AIAnalysisResult } from './types';
2-
3:export type SharedLLMProvider = 'openrouter' | 'alibaba' | 'google';
4-
5-// ── Architecture ────────────────────────────────────────────────────────────
6-// ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
7-//   → Unlimited rate limit on all 3 models
8-//   → This session IS the primary orchestrator, not routed through here
--
26-//   NO Claude models — orchestrator handles Claude via Claude Code plan
27-
28:export const ALIBABA_MODELS = [
29-  'qwen-max',
30-  'qwen-plus',
31-  'qwen-flash',
32-  'qwen3-coder-plus',
33-  'qwen3.5-plus',
--
39-
40-interface ModelEntry {
41:  provider: SharedLLMProvider;
42-  model: string;
43-  tier: 'fast' | 'default' | 'deep';
44-}
45-
46-// Tier 0: Google AI Studio (FREE — no expiry, 1500 req/day for 31B model)
--
73-
74-// Tier 2: OpenRouter — free model first, then cheap paid
75:const OPENROUTER_CHAIN: ModelEntry[] = [
76-  // FREE — Qwen 3.6 Plus (prompt=0, completion=0, no rate limit published)
77-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'fast' },
78-  { provider: 'openrouter', model: 'qwen/qwen3.6-plus:free', tier: 'default' },
79-
80-  // MiniMax M2.5 — benchmark winner Apr 2026: 7.1/10, 67% tool accuracy, $0.36/mo
--
202-  maxTokens?: number;
203-  temperature?: number;
204:  provider?: SharedLLMProvider;
205-  responseFormat?: 'json_object' | 'text';
206-  /** Task tier — controls which models are tried first. Default: 'default' */
207-  tier?: 'fast' | 'default' | 'deep';
208-}): Promise<AIAnalysisResult> {
209-  // Explicit model: single attempt, no fallback chain
210-  if (params.model) {
211:    const explicitProvider: SharedLLMProvider =
212-      params.provider ??
213-      (params.model.startsWith('qwen') && !params.model.includes(':') ? 'alibaba'
214-        : params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
215-        : 'openrouter');
216-    return callModel(
217:      { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
218-      params
219-    );
220-  }
221-
222-  // Build chain: Google (free/daily limit) → Alibaba (free grant) → OpenRouter (paid fallback)
--
234-  if (tier === 'fast') {
235-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
236:    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');
237-  } else if (tier === 'deep') {
238-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
239:    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'deep' || e.tier === 'default');
240-  } else {
241-    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
242:    openrouterModels = OPENROUTER_CHAIN.filter((e: ModelEntry) => e.tier === 'default' || e.tier === 'fast');
243-  }
244-
245-  // Chain order: Google (free) → Alibaba (free grant) → OpenRouter
246-  let chain: ModelEntry[] = [...googleModels, ...alibabaModels, ...openrouterModels];
247-
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
 * Walk a target directory and scan all eligible files.
 * Returns a deduplicated, stable list of findings.
 *
 * @param targetDir  - directory to scan
 * @param patterns   - compiled entity patterns to search for
 */
export async function scanDirectory(
  targetDir: string,
  patterns: EntityPattern[],
): Promise<Finding[]> {
  const allFiles = await collectFiles(targetDir);

  // Filter to git-tracked files when possible
  const gitTracked = getGitTrackedFiles(targetDir);
  const filesToScan = gitTracked
    ? allFiles.filter(f => gitTracked.has(f))
    : allFiles;

  const allFindings: Finding[] = [];

  for (const filePath of filesToScan) {
    const s = await stat(filePath);
    // Skip very large files (>2MB) to avoid memory spikes
    if (s.size > 2 * 1024 * 1024) continue;

    let text: string;

exec
/bin/bash -lc "git rev-parse HEAD && git merge-base HEAD fdff002133ce42df149089d6147728cc91c44511 || true && git diff --name-only fdff002133ce42df149089d6147728cc91c44511 | head -20 && git diff fdff002133ce42df149089d6147728cc91c44511 -- packages/shared/src/llm-provider.ts | head -30 && git show HEAD:packages/shared/src/llm-provider.ts | grep -n \"SharedLLMProvider\\|ALIBABA\" | head" in /home/enio/egos
 succeeded in 0ms:
e8ee9b6507520d3867ca86e3a06c16cce4e8357d
fdff002133ce42df149089d6147728cc91c44511
TASKS.md
TASKS_ARCHIVE.md
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
scripts/gem-hunter-digest.ts
3:export type SharedLLMProvider = 'openrouter' | 'alibaba' | 'google';
28:export const ALIBABA_MODELS = [
41:  provider: SharedLLMProvider;
58:const ALIBABA_CHAIN: ModelEntry[] = [
128:    baseUrl = `${(process.env.ALIBABA_DASHSCOPE_BASE_URL || 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1').replace(/\/+$/, '')}/chat/completions`;
129:    apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
140:    const keyName = provider === 'alibaba' ? 'ALIBABA_DASHSCOPE_API_KEY' : provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
204:  provider?: SharedLLMProvider;
211:    const explicitProvider: SharedLLMProvider =
235:    alibabaModels = ALIBABA_CHAIN.filter((e: ModelEntry) => e.tier === 'fast');

exec
/bin/bash -lc 'git diff --stat fdff002133ce42df149089d6147728cc91c44511 && git diff fdff002133ce42df149089d6147728cc91c44511 --' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |  11 +-
 TASKS_ARCHIVE.md                                   |  12 +++
 agents/agents/article-writer.ts                    |  61 ++---------
 apps/egos-gateway/src/orchestrator.ts              |  45 ++++----
 .../app/api/hq/actions/codex-review/route.ts       |  75 +++++--------
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md       |   2 +-
 docs/strategy/landing-copy-v2-pessoa-comum.md      |  54 ++++++++++
 packages/pii-purge/README.md                       |  19 +++-
 packages/pii-purge/package.json                    |   2 +-
 packages/pii-purge/src/cli.ts                      |  37 ++++++-
 packages/pii-purge/src/patterns.ts                 |   2 +-
 packages/pii-purge/src/pii-purge.test.ts           |  38 ++++++-
 packages/pii-purge/src/purge.ts                    |  25 ++++-
 packages/pii-purge/src/scanner.ts                  | 118 +++++++++++++++++----
 packages/pii-purge/src/verify.ts                   |  30 ++++--
 packages/shared/src/llm-provider.ts                |  96 ++++-------------
 scripts/activation-check.ts                        |   1 -
 scripts/debrief/pipeline.ts                        |  22 ++--
 scripts/gem-hunter-digest.ts                       |  50 ++-------
 scripts/manifest-generator.ts                      |  28 ++---
 scripts/ssot-router.ts                             |  30 +++---
 scripts/test-alibaba-orchestrator.ts               |  39 -------
 scripts/x-opportunity-alert.ts                     |  51 +++------
 scripts/x-post-approval-bot.ts                     |  20 ++--
 26 files changed, 461 insertions(+), 411 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 74e4a4f6..485efdb0 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -144,7 +144,8 @@
 > aiox-core README como referência de qualidade: hooks por IDE, "Comece Aqui 10min", CLI First hierarquia, badges, first-value binário, multilíngue.
 > SSOT do que aprender: docs/competitive-analysis/aiox-learnings.md (a criar)
 
-- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) bilíngue PT/EN. HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
+- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN no máximo opcional/secundário, NUNCA lidera nem bloqueia.** HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
+- [ ] **README-PUBLICO-PT-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07 "tudo PT": o README público (egos-governance) tem seções em INGLÊS ("Why This Exists" L120, comentários de código L179/L192, "Contributing" L262, "License" L272). Traduzir p/ PT-BR (Por que o EGOS existe / Contribuindo / Licença / comentários). Público-alvo é Brasil. HITL antes de push no repo público.
 - [ ] **README-HOOKS-TABLE-001** [P1] `curador` — Criar tabela de paridade de hooks EGOS por IDE (análogo ao aiox): Claude Code (completo — hooks pre/post tool, session, commands), Gemini CLI / Antigravity (GEMINI.md, sem hooks nativos), Codex CLI (AGENTS.md + skills, parcial), Windsurf (rules, parcial), Cursor (cursor-rules, sem hooks), ChatGPT/GPT (system prompt + memory, sem hooks). Salvar em docs/governance/HOOKS_IDE_COMPATIBILITY.md.
 - [ ] **README-FIRST-VALUE-001** [P1] `voz` — Definir "first-value EGOS" (binário, como aiox faz): configurar 1 metaprompt profissional + 1 agente respondendo do jeito certo em <= 10 minutos = first-value atingido. Incluir no README como metric de onboarding.
 - [ ] **README-MULTILINGUAL-001** [P2] `voz` — Criar README.en.md (versão EN do README principal). O EGOS tem público potencial fora do BR — governança de IA é tema global. Estrutura igual ao PT, tradução profissional (não automática).
@@ -369,8 +370,8 @@
 - [ ] **BERNARDO-PW-001** [P2] `prime` — Setar `BERNARDO_PASSWORD_SHA256` em prod p/ rotacionar o default documentado `bernardo2026` (server-side, `central-egos/template/src/app/api/bernardo-guide/route.ts:12`).
 
 ## 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA — sessão 2026-06-04 (Guarani)
-- [ ] **HERMES-DESKTOP-001** [P1] `guarani` `gated:decisão` 🆕 — Instalação e teste e2e do Vite web UI no ambiente local de desenvolvimento do Hermes.
 - [ ] **HERMES-DESKTOP-002** [P1] `pixel` 🆕 — Implementar a UI React dos 5 painéis estendidos (Status, Roster, Audit, Blackboard, Dispersion/Costs) no Hermes Desktop.
+- [ ] **HERMES-DESKTOP-SANDBOX-001** [P2] `5min` — Corrigir sandbox Electron para lançar app nativo: `sudo chown root:root ~/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/chrome-sandbox && sudo chmod 4755 [...]`. Requer terminal com TTY. Alternativa: usar dashboard web em localhost:9119.
 - [ ] **AGENT-AVATARS-001** [P2] `pixel` 🆕 — Criar componente React para geração de avatares etéreos SVG a partir das chaves públicas dos agentes.
 - [ ] **AUDIT-CRYPT-001** [P1] `prime` 🆕 — Implementar o helper de geração de par de chaves e assinatura off-chain secp256k1 para relatórios e commits.
 - [ ] **AUDIT-NOSTR-001** [P2] `prime` 🆕 — Publicação descentralizada de identidades no Nostr (NIP-05) e provas temporais no Bitcoin via OpenTimestamps.
@@ -871,7 +872,11 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
 - [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
 - [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
-- [ ] **PII-PURGE-007** [P0] `prime` `gated:HITL` — Aplicar o motor ao `intelink-clean` (resolve WS1 automaticamente): remover RELINT + mascarar 6 arquivos + verify. Nada vai pro GitHub sem corte do Enio.
+- [x] **PII-PURGE-BUG-001** [P1] `prime` — FIX (2026-06-07): dedupe de spans sobrepostos (longest-wins) em `applyReplacements`. Teste + smoke: `JIZ-6956`+`JIZ6956` → 1 token limpo, sem `[PESSOA_1]_1]`.
+- [x] **PII-PURGE-VERIFY-001** [P1] `prime` — FIX (2026-06-07): safety-net de busca literal (`scanLiteralValues`/`flattenEntityValues`) ligado ao `verify` — independe da tipagem do campo; pega valor de texto em campo numérico. + `--verify-only` (publish gate) + exclui o próprio dict do scan. 31 testes verdes.
+- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — Wire `--verify-only` no pre-commit (R-SEC-005) + paths de publicação (push/NotebookLM/deploy). Mecanismo pronto; falta plugar nos hooks.
+- [ ] **PII-PURGE-SKILL-001** [P2] `prime` — Skill `/purge <repo>`: monta dict (HITL) + dry-run + relatório + apply (HITL) + runbook "como limpar um sistema". Casca ergonômica para qualquer um/IA limpar com 1 comando.
+- [ ] **INTELINK-PLATFORM-GH-CACHE-001** [P1] `prime`+`hermes-ops` — GitHub pode reter `f0cfdb7` (18 PII) por SHA até GC + em forks/PRs. Como INC-PII-001: contatar GitHub Support p/ purgar cache + checar forks/network. Force-push limpou o branch, não garante o cache.
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
 - [ ] **DISCOVER-GATE-001** [P1] `forja` — `scripts/discover-capability.ts <termo>`: busca 4 registries (CAPABILITY/MCP/INTEGRATION/SKILLS) + codebase-memory-mcp + CBC-*. Devolve reuse|extend|new + justificativa.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 24db24f8..e10a7f4f 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3704,3 +3704,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **PRODUCT-TIERS-001** [P0] — OBSOLETA: Enio cravou "sem tiers" (PRODUCT_MODEL); canais≠tiers clarificado v1.1 (bdb5d265). GPT grátis + WhatsApp R$4 = 1 produto pago. Sem pirâmide de preços.
 - [x] **PRODUCT-R4-DEFINITION-001** [P0] — coberto em PRODUCT_MODEL.md "O que está incluso" + "preço não é público". SSOT = PRODUCT_MODEL.md (não criar product-r4.md).
 
+
+## Archived 2026-06-07
+
+### 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA — sessão 2026-06-04 (Guarani)
+- [x] **HERMES-DESKTOP-001** [P1] `guarani` — ✅ 2026-06-07: Hermes v0.16.0 instalado, atualizado, dashboard web :9119 rodando, Telegram @EGOSin_bot configurado (171767219), 2 crons criados (auto-update seg 9h + upstream-watch dom 8h).
+
+
+## Archived 2026-06-07
+
+### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
+- [x] **PII-PURGE-007** [P0] `prime` — Aplicado ao `intelink-clean` (2026-06-07): rm 2 RELINT + mascarar 7 arquivos + orphan squash + force-push. `origin/main` = baseline limpo `4bb4665` (0 PII; era f0cfdb7 c/ 18 hits). Backup local `backup-pre-squash-2026-06-07`.
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
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..e9a6089c 100644
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
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
index b10c9a85..04a2c2ca 100644
--- a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -110,7 +110,7 @@
 
 ## 8. README — abertura (DRAFT p/ HITL — README-FOCUS-REFLECT-001)
 
-> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. Substitui a abertura atual; o overhaul completo (badges/bilíngue) fica no README-OVERHAUL-001.
+> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN nunca lidera.** Substitui a abertura atual; o overhaul completo (badges) fica no README-OVERHAUL-001.
 
 ```markdown
 # EGOS
diff --git a/docs/strategy/landing-copy-v2-pessoa-comum.md b/docs/strategy/landing-copy-v2-pessoa-comum.md
new file mode 100644
index 00000000..c9a9c202
--- /dev/null
+++ b/docs/strategy/landing-copy-v2-pessoa-comum.md
@@ -0,0 +1,54 @@
+# Landing — Copy v2 "pessoa comum" (DRAFT — HITL)
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT pendente corte Enio (R-PUB-001) — não aplicado na landing ainda.
+**Origem:** review Codex gpt-5.5 sobre a landing inteira (Explore extraiu o copy; Codex reescreveu p/ pessoa comum + casos por área).
+**Voz:** PT-BR, EGOS-entidade, colaborativo, sem absoluto, sem preço, sem persona. Liga [EGOS_ONBOARDING_LAUNCH_PLAN.md](EGOS_ONBOARDING_LAUNCH_PLAN.md).
+
+> **Diagnóstico:** só "Comece aqui" + ConsentGate falavam com leigo. Hero/showcase/mycelium/grok eram jargão dev ("orquestração de agentes", "T0→T4", "MCP", "HITL", "stub"). Esta v2 traduz pra gente comum + adiciona casos concretos por área (temos 16 personas de setor prontas).
+
+## 1. Hero — 2 opções (Enio escolhe)
+**Opção A:**
+- Eyebrow: Método gratuito para usar IA com mais segurança
+- H1: **Use IA sem cair em conversa fiada**
+- P: O EGOS ajuda você a usar ChatGPT, Claude ou Gemini com mais método: separando fato de achismo, cuidando de dados sensíveis e organizando o que precisa ser conferido por uma pessoa. É para quem quer ganhar tempo com IA sem entregar CPF, dados de cliente ou decisões importantes no escuro.
+- Botões: "Começar com o metaprompt gratuito" / "Ver checklist de segurança"
+
+**Opção B (recomendada — concisa):**
+- Eyebrow: IA com método para profissionais brasileiros
+- H1: **A IA ajuda. O EGOS organiza.**
+- P: O EGOS mostra como transformar a IA em uma assistente mais útil para o seu trabalho, com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
+- Botões: "Criar meu assistente de IA" / "Detectar dados sensíveis"
+
+## 2. "Como funciona" — 3 passos simples (substitui T0→T4/agentes/MCP)
+1. **Escolha seu tipo de trabalho** — advocacia, clínica, contabilidade, comércio, sala de aula. A IA recebe instruções claras do que fazer e do que evitar.
+2. **Proteja as informações sensíveis** — antes de mandar pra IA, o EGOS ajuda a identificar CPF, CNPJ, prontuário, dados de cliente. Diminui o risco de expor o que não deveria sair do seu controle.
+3. **Confira antes de confiar** — o EGOS organiza a resposta pra você separar o que é fato, o que precisa conferência e o que é sugestão. A decisão final é da pessoa.
+
+## 3. NOVA seção "Como você usa na sua área" (6 cards)
+- **⚖️ Advogado** — analisar documentos e responder clientes sem expor dados do processo. → assistente que lê com cuidado, responde no WhatsApp, mantém registro. *(temos advocacia-starter completo)*
+- **🩺 Médico/Clínica** — usar IA sem expor prontuário/dados de paciente. → IA com dados protegidos + revisão humana antes de orientação sensível.
+- **🧾 Contador** — dados fiscais/CPF/CNPJ em tarefas repetitivas. → organizar pra análise sem tratar dado sensível como texto comum.
+- **🍽️ Comerciante/Restaurante** — cardápio/catálogo em foto/papel/WhatsApp. → foto vira planilha pronta pra revisão. *(temos item-intake LIVE)*
+- **📚 Professor** — material com IA pode ter erro/fonte fraca. → organiza aulas/exercícios/resumos com pontos de conferência antes de usar com alunos.
+- **🌾 Agrônomo** — laudos de solo, orientações de plantio, relatórios de campo, dados de produtores. → assistente da área que organiza e destaca o que precisa validação profissional. *(card ajustado: exemplo mais concreto p/ revisão Codex)*
+
+## 4. Tabela de tradução (aplicar nas outras páginas: showcase/mycelium/guard/grok)
+| Jargão | Versão humana |
+|---|---|
+| orquestração de agentes | organizar tarefas da IA com mais ordem |
+| T0→T4 | níveis de cuidado: do dado mais sensível ao mais público |
+| MCP | conectar a IA a ferramentas/informações autorizadas |
+| HITL | uma pessoa revisa antes de algo importante ser usado/enviado |
+| eval-runner | testes pra ver se a IA faz o que promete |
+| stub | parte incompleta que ainda não é "pronta" |
+| pipeline | sequência de passos até um resultado conferido |
+| SSOT | o lugar principal onde a informação oficial fica |
+| RAG | a IA consulta uma base antes de responder |
+| KB | base de conhecimento que a IA pode consultar |
+
+## 5. Grok Hunter & Mycelium (técnicos demais p/ público comum)
+- **Grok Hunter** → renomear/apresentar como "checador de respostas da IA" (separa fato/dúvida/achismo), OU esconder do menu público.
+- **Mycelium** → apresentar como "rede de conhecimento" (informações organizadas pra IA consultar com contexto), OU manter como página técnica secundária.
+
+---
+*DRAFT. Aplicar na landing (App.tsx + ToolsHub + MyceliumPage) só após corte do Enio. Depois: rebuild + deploy + smoke (deploy.sh).*
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
index 83e8fb0c..9d7f7ea9 100644
--- a/packages/pii-purge/src/purge.ts
+++ b/packages/pii-purge/src/purge.ts
@@ -109,12 +109,29 @@ export function applyReplacements(
     token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   }));
 
-  // Sort end-to-start (line desc, offset desc)
+  // BUG-001 fix: remove OVERLAPPING spans before replacing.
+  // Two patterns (e.g. plate "TST-1234" and "TST1234") can match the same span;
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
index eb9f869f..709f8e76 100644
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
index efcef679..8809bb0a 100644
--- a/scripts/manifest-generator.ts
+++ b/scripts/manifest-generator.ts
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
/bin/bash -lc 'bun test packages/pii-purge/src/pii-purge.test.ts' in /home/enio/egos
 succeeded in 0ms:
bun test v1.3.9 (cf6cdbbb)

 31 pass
 0 fail
 62 expect() calls
Ran 31 tests across 1 file. [100.00ms]

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "git diff fdff002133ce42df149089d6147728cc91c44511 --unified=40 -- apps/egos-gateway/src/orchestrator.ts | sed -n '1,220p' && git diff fdff002133ce42df149089d6147728cc91c44511 --unified=40 -- packages/shared/src/llm-provider.ts | sed -n '1,280p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 4b5ebb6c..e9a6089c 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -1,110 +1,105 @@
 /**
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
  *   wiki_search, wiki_page, list_agents, get_tasks, recent_commits,
  *   get_costs, knowledge_stats, world_model
  */
 
 import { join } from "path";
 import { existsSync, readFileSync } from "fs";
 import { execSync } from "child_process";
 
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
   base: string;
   key: string;
   model: string;
 }
 
 const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
-const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "qwen-plus";
+const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";
 
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
@@ -170,117 +165,115 @@ async function loadHistory(channel: string, userId: string, limit = 12): Promise
       `egos_chat_history?channel=eq.${encodeURIComponent(channel)}&user_id=eq.${encodeURIComponent(userId)}&order=created_at.desc&limit=${limit}&select=role,content,created_at`
     ) as HistoryRow[] | null;
     if (!rows?.length) return [];
     return rows.reverse(); // oldest first for LLM context
   } catch {
     return [];
   }
 }
 
 async function saveHistory(
   channel: string,
   userId: string,
   userContent: string,
   assistantContent: string,
   toolsUsed: string[],
   mediaType?: string,
 ): Promise<void> {
   if (!SUPABASE_URL || !SUPABASE_KEY) return;
   // Save user turn
   await sbInsert("egos_chat_history", {
     channel,
     user_id: userId,
     role: "user",
     content: userContent,
     media_type: mediaType ?? null,
     tools_used: [],
   });
   // Save assistant turn
   await sbInsert("egos_chat_history", {
     channel,
     user_id: userId,
     role: "assistant",
     content: assistantContent,
     tools_used: toolsUsed,
   });
 }
 
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
   const rates = MODEL_COST_PER_1K[model] ?? { input: 0.0005, output: 0.0015 };
   return (inputTokens / 1000) * rates.input + (outputTokens / 1000) * rates.output;
 }
 
 async function logTokenUsage(
   clientSlug: string | undefined,
   model: string,
   inputTokens: number,
   outputTokens: number,
   channel: string,
 ): Promise<void> {
   if (!SUPABASE_URL || !SUPABASE_KEY || !clientSlug) return;
   const cost = estimateCostUsd(model, inputTokens, outputTokens);
   try {
     await fetch(`${SUPABASE_URL}/rest/v1/consulting_token_log`, {
       method: "POST",
       headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json", Prefer: "return=minimal" },
       body: JSON.stringify({ tenant: clientSlug, model, input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: cost, channel }),
       signal: AbortSignal.timeout(5000),
     });
   } catch { /* best-effort */ }
 }
 
 // Canonical per-call usage log (api_usage) — written on EVERY LLM call, not just
 // tenant ones. Read by get_costs + scripts/llm-usage-notify.ts. Before 2026-06-01
 // nothing wrote here, so cost tracking was silently dead.
 function providerFromModel(model: string): string {
   const m = model.toLowerCase();
-  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
   if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3")) return "OpenAI";
   if (m.includes("gemini") || m.includes("gemma")) return "Google";
   if (m.includes("claude")) return "Anthropic";
   if (m.includes("deepseek") || m.includes("/")) return "OpenRouter";
   return "Other";
 }
 
 async function logApiUsage(model: string, inputTokens: number, outputTokens: number, channel: string): Promise<void> {
   if (!SUPABASE_URL || !SUPABASE_KEY) return;
   const cost = estimateCostUsd(model, inputTokens, outputTokens);
   try {
     await fetch(`${SUPABASE_URL}/rest/v1/api_usage`, {
diff --git a/packages/shared/src/llm-provider.ts b/packages/shared/src/llm-provider.ts
index eb9f869f..709f8e76 100644
--- a/packages/shared/src/llm-provider.ts
+++ b/packages/shared/src/llm-provider.ts
@@ -1,272 +1,220 @@
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
 
-  if (provider === 'alibaba') {
-    baseUrl = `${(process.env.ALIBABA_DASHSCOPE_BASE_URL || 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1').replace(/\/+$/, '')}/chat/completions`;
-    apiKey = process.env.ALIBABA_DASHSCOPE_API_KEY;
-  } else if (provider === 'google') {
+  if (provider === 'google') {
     // Google AI Studio: OpenAI-compatible endpoint
     baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
     apiKey = process.env.GOOGLE_AI_STUDIO_API_KEY;
   } else {
     baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
     apiKey = process.env.OPENROUTER_API_KEY;
   }
 
   if (!apiKey) {
-    const keyName = provider === 'alibaba' ? 'ALIBABA_DASHSCOPE_API_KEY' : provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
+    const keyName = provider === 'google' ? 'GOOGLE_AI_STUDIO_API_KEY' : 'OPENROUTER_API_KEY';
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
-      (params.model.startsWith('qwen') && !params.model.includes(':') ? 'alibaba'
-        : params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
+      (params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
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
     const pref = chain.filter((e: ModelEntry) => e.provider === params.provider);
     const rest = chain.filter((e: ModelEntry) => e.provider !== params.provider);
     chain = [...pref, ...rest];
   }

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
exec
/bin/bash -lc "git diff fdff002133ce42df149089d6147728cc91c44511 --unified=20 -- apps/egos-gateway/src/orchestrator.ts | sed -n '220,420p'" in /home/enio/egos
 succeeded in 0ms:
-        model: "qwen-vl-plus",
+        model: "google/gemini-2.0-flash-001",
         messages: [{
           role: "user",
           content: [
             { type: "image_url", image_url: { url: dataUrl } },
             { type: "text", text: caption ? `Descreva esta imagem. Contexto: "${caption}"` : "Descreva o que você vê nesta imagem." },
           ],
         }],
         max_tokens: 500,
       }),
       signal: AbortSignal.timeout(20000),
     });
     if (!res.ok) return "[Erro na análise da imagem]";
     const d = await res.json() as { choices?: Array<{ message: { content: string } }> };
     return d.choices?.[0]?.message?.content ?? "[Sem descrição]";
   } catch (e) {
     return `[Erro na análise: ${(e as Error).message}]`;
   }
 }
 
 // ─── Citation verification (RATIO-ABSORB-002) ────────────────────────────────

exec
/bin/bash -lc "git diff fdff002133ce42df149089d6147728cc91c44511 --unified=10 -- apps/egos-gateway/src/orchestrator.ts | grep -n \"DASHSCOPE_KEY\\|OPENROUTER_KEY\\|ALIBABA\" -C4" in /home/enio/egos
 succeeded in 0ms:
25- 
26- // ─── Config ───────────────────────────────────────────────────────────────────
27- 
28--const DASHSCOPE_BASE =
29:-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
30--  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
31:-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
32- const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
33: const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
34- 
35- /**
36-  * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
37-  *
--
60- function getProvider(modelName: string): LLMProvider | null {
61-   // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
62-   if (modelName.startsWith("gemini-") || modelName.startsWith("gpt-") ||
63-       modelName.startsWith("claude-") || modelName.startsWith("deepseek-")) {
64:     if (!OPENROUTER_KEY) return null;
65-     const orModel = modelName.startsWith("gemini-") ? `google/${modelName}`
66-                   : modelName.startsWith("gpt-") ? `openai/${modelName}`
67-                   : modelName.startsWith("claude-") ? `anthropic/${modelName}`
68-                   : `deepseek/${modelName}`;
69-     return {
70-       name: modelName,
71-       base: "https://openrouter.ai/api/v1",
72:       key: OPENROUTER_KEY,
73-       model: orModel,
74-     };
75-   }
76--  // Qwen via DashScope direto
77--  if (modelName.startsWith("qwen-")) {
78:-    if (!DASHSCOPE_KEY) return null;
79-+  // Via OpenRouter (fallback genérico com prefixo de provider)
80:+  if (OPENROUTER_KEY && modelName.includes("/")) {
81-     return {
82-       name: modelName,
83--      base: DASHSCOPE_BASE,
84:-      key: DASHSCOPE_KEY,
85-+      base: "https://openrouter.ai/api/v1",
86:+      key: OPENROUTER_KEY,
87-       model: modelName,
88-     };
89-   }
90-   return null;
--
156-   }
157- }
158- 
159- export async function describeImage(imageBase64: string, mime: string, caption?: string): Promise<string> {
160:-  if (!DASHSCOPE_KEY) return "[Análise de imagem não configurada]";
161:+  if (!OPENROUTER_KEY) return "[Análise de imagem não configurada]";
162-   try {
163-     const dataUrl = `data:${mime};base64,${imageBase64}`;
164--    const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
165-+    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
166-       method: "POST",
167:-      headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
168:+      headers: { Authorization: `Bearer ${OPENROUTER_KEY}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos" },
169-       body: JSON.stringify({
170--        model: "qwen-vl-plus",
171-+        model: "google/gemini-2.0-flash-001",
172-         messages: [{

exec
/bin/bash -lc "git diff fdff002133ce42df149089d6147728cc91c44511 -- apps/egos-gateway/src/orchestrator.ts | grep -n \"DASHSCOPE\\|OPENROUTER\\|configurado\"" in /home/enio/egos
 succeeded in 0ms:
21:-const DASHSCOPE_BASE =
22:-  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
24:-const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
26: const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";
59:-    if (!DASHSCOPE_KEY) return null;
61:+  if (OPENROUTER_KEY && modelName.includes("/")) {
64:-      base: DASHSCOPE_BASE,
65:-      key: DASHSCOPE_KEY,
67:+      key: OPENROUTER_KEY,
99:-  if (!DASHSCOPE_KEY) return "[Análise de imagem não configurada]";
100:+  if (!OPENROUTER_KEY) return "[Análise de imagem não configurada]";
103:-    const res = await fetch(`${DASHSCOPE_BASE}/chat/completions`, {
106:-      headers: { Authorization: `Bearer ${DASHSCOPE_KEY}`, "Content-Type": "application/json" },
107:+      headers: { Authorization: `Bearer ${OPENROUTER_KEY}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos" },

exec
/bin/bash -lc 'pwd; ls -l packages/shared/src/llm-provider.ts; git ls-files -s packages/shared/src/llm-provider.ts; git status --short --untracked-files=no; git diff --quiet fdff002133ce42df149089d6147728cc91c44511 -- packages/shared/src/llm-provider.ts; echo diff_exit=$?; sha256sum packages/shared/src/llm-provider.ts <(git show HEAD:packages/shared/src/llm-provider.ts) <(git show fdff002133ce42df149089d6147728cc91c44511:packages/shared/src/llm-provider.ts)' in /home/enio/egos
 succeeded in 0ms:
/home/enio/egos
-rw-rw-r-- 1 enio enio 8461 Jun  7 16:25 packages/shared/src/llm-provider.ts
100644 eb9f869fb9ac8f91dd4709009997a24df334408b 0	packages/shared/src/llm-provider.ts
 M TASKS.md
 M agents/agents/article-writer.ts
 M apps/egos-gateway/src/orchestrator.ts
 M apps/egos-hq/app/api/hq/actions/codex-review/route.ts
 M apps/egos-landing/public/timeline/rss
 M apps/egos-landing/public/timeline/rss.xml
A  docs/strategy/landing-copy-v2-pessoa-comum.md
 M packages/pii-purge/README.md
 M packages/pii-purge/package.json
 M packages/pii-purge/src/cli.ts
 M packages/pii-purge/src/patterns.ts
 M packages/pii-purge/src/pii-purge.test.ts
 M packages/pii-purge/src/purge.ts
 M packages/pii-purge/src/scanner.ts
 M packages/pii-purge/src/verify.ts
 M packages/shared/src/llm-provider.ts
 M scripts/activation-check.ts
 M scripts/debrief/pipeline.ts
 M scripts/gem-hunter-digest.ts
 M scripts/manifest-generator.ts
 M scripts/ssot-router.ts
 D scripts/test-alibaba-orchestrator.ts
 M scripts/x-opportunity-alert.ts
 M scripts/x-post-approval-bot.ts
diff_exit=1
4447cb6ed6c6d6dac55ca096e92d303000d1824fa10ba12a17d9c6730470e656  packages/shared/src/llm-provider.ts
5d1f056fc64a5051a749c6be640a7ceef1d856c207865aea886a3d3ba4908df2  /dev/fd/63
5d1f056fc64a5051a749c6be640a7ceef1d856c207865aea886a3d3ba4908df2  /dev/fd/62

exec
/bin/bash -lc 'bun typecheck' in /home/enio/egos
 exited 2 in 12646ms:
packages/shared/src/index.ts(8,53): error TS2305: Module '"./llm-provider"' has no exported member 'ALIBABA_MODELS'.
packages/shared/src/model-router.ts(55,5): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider'.
packages/shared/src/model-router.ts(66,5): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider'.
packages/shared/src/model-router.ts(77,5): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider'.
packages/shared/src/model-router.ts(88,5): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider'.
scripts/review_models.ts(12,5): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider | undefined'.
scripts/start-audit.ts(61,38): error TS2322: Type '"alibaba"' is not assignable to type 'SharedLLMProvider | undefined'.

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "nl -ba packages/shared/src/llm-provider.ts | sed -n '1,40p;150,180p' && nl -ba packages/shared/src/index.ts | sed -n '1,20p' && nl -ba packages/shared/src/model-router.ts | sed -n '45,95p'" in /home/enio/egos
 succeeded in 0ms:
     1	import type { AIAnalysisResult } from './types';
     2	
     3	export type SharedLLMProvider = 'openrouter' | 'google';
     4	
     5	// ── Architecture ────────────────────────────────────────────────────────────
     6	// ORCHESTRATOR: Claude Code (Opus + Sonnet + Haiku) - R$550/mês plan
     7	//   → This session IS the primary orchestrator, not routed through here
     8	//
     9	// BACKGROUND AGENTS (VPS): Use this fallback chain
    10	//   Priority: Google AI Studio (free) → OpenRouter (gemini-2.0-flash-001)
    11	//
    12	// Google AI Studio (PRIORITY 1 — Completely Free, No Expiry):
    13	//   Models: gemma-4-31b-it (1,500 req/day), gemini-2.5-flash (500 req/day)
    14	//   Key: GOOGLE_AI_STUDIO_API_KEY | Base: generativelanguage.googleapis.com
    15	//
    16	// OpenRouter (PRIORITY 2 — Paid, low cost):
    17	//   PRIMARY: google/gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
    18	//   Fallback: gemini-2.5-pro, llama-4-maverick
    19	//   Key: OPENROUTER_API_KEY
    20	//   NOTE: Alibaba DashScope REMOVED — free grant period expired ($500 used)
    21	
    22	// ── Fallback Chain ─────────────────────────────────────────────────────────
    23	
    24	interface ModelEntry {
    25	  provider: SharedLLMProvider;
    26	  model: string;
    27	  tier: 'fast' | 'default' | 'deep';
    28	}
    29	
    30	// Tier 0: Google AI Studio (FREE — no expiry, 1500 req/day for 31B model)
    31	// NOTE: gemma-4-31b-it weak on tool-calling → use for reasoning/coding only
    32	const GOOGLE_CHAIN: ModelEntry[] = [
    33	  // Fast tier — gemini-2.5-flash (500 req/day free, multimodal)
    34	  { provider: 'google', model: 'gemini-2.5-flash', tier: 'fast' },
    35	  // Default tier — gemma-4-31b-it (1,500 req/day free, best coding/reasoning)
    36	  { provider: 'google', model: 'gemma-4-31b-it',   tier: 'default' },
    37	  // Deep tier — gemini-2.5-pro (50 req/day free, strongest reasoning)
    38	  { provider: 'google', model: 'gemini-2.5-pro',   tier: 'deep' },
    39	];
    40	
   150	  };
   151	}
   152	
   153	// ── Main export with automatic fallback chain ─────────────────────────────
   154	
   155	export async function chatWithLLM(params: {
   156	  systemPrompt: string;
   157	  userPrompt: string;
   158	  model?: string;
   159	  maxTokens?: number;
   160	  temperature?: number;
   161	  provider?: SharedLLMProvider;
   162	  responseFormat?: 'json_object' | 'text';
   163	  /** Task tier — controls which models are tried first. Default: 'default' */
   164	  tier?: 'fast' | 'default' | 'deep';
   165	}): Promise<AIAnalysisResult> {
   166	  // Explicit model: single attempt, no fallback chain
   167	  if (params.model) {
   168	    const explicitProvider: SharedLLMProvider =
   169	      params.provider ??
   170	      (params.model.startsWith('gemma') || params.model.startsWith('gemini') ? 'google'
   171	        : 'openrouter');
   172	    return callModel(
   173	      { provider: explicitProvider, model: params.model, tier: params.tier ?? 'default' },
   174	      params
   175	    );
   176	  }
   177	
   178	  // Build chain: Google (free/daily limit) → Alibaba (free grant) → OpenRouter (paid fallback)
   179	  const tier = params.tier ?? 'default';
   180	
     1	/**
     2	 * @egos/shared — Core EGOS framework utilities
     3	 * 
     4	 * Exports only framework-level infrastructure.
     5	 * Domain-specific utilities (OSINT, social, etc.) live in leaf repos.
     6	 */
     7	
     8	export { chatWithLLM, chatWithLLM as analyzeWithAI, ALIBABA_MODELS } from './llm-provider';
     9	export type { SharedLLMProvider } from './llm-provider';
    10	export { resolveModel, routeForChat, listAvailableModels, MODEL_CATALOG } from './model-router';
    11	export type { TaskType, CostPreference, RouteOptions, ResolvedRoute, ModelProfile } from './model-router';
    12	export { createAtrianValidator } from './atrian';
    13	export { scanForPII, sanitizeText, getPIISummary } from './pii-scanner';
    14	export { shouldSummarizeConversation, buildConversationTranscript, normalizeConversationSummary, buildConversationMemoryBlock } from './conversation-memory';
    15	export { RateLimiter } from './rate-limiter';
    16	export { CircuitBreaker, CircuitOpenError } from './circuit-breaker';
    17	export type { CircuitState, CircuitBreakerOptions, CircuitBreakerStatus } from './circuit-breaker';
    18	export type { AtrianConfig, AtrianResult, AtrianViolation, ViolationLevel } from './atrian';
    19	export type { ConversationMemoryOptions, ConversationMessage } from './conversation-memory';
    20	export type { PIICategory, PIIFinding, PIIPatternDefinition } from './pii-scanner';
    45	  maxContext: number;        // tokens
    46	  strengths: TaskType[];
    47	  tier: 'premium' | 'balanced' | 'economy';
    48	  envKey: string;            // which env var holds the API key
    49	}
    50	
    51	export const MODEL_CATALOG: ModelProfile[] = [
    52	  // ── Alibaba / DashScope ──
    53	  {
    54	    id: 'qwen-max',
    55	    provider: 'alibaba',
    56	    displayName: 'Qwen Max',
    57	    costPer1MInput: 1.6,
    58	    costPer1MOutput: 6.4,
    59	    maxContext: 32768,
    60	    strengths: ['orchestration', 'analysis', 'code_review'],
    61	    tier: 'premium',
    62	    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
    63	  },
    64	  {
    65	    id: 'qwen-plus',
    66	    provider: 'alibaba',
    67	    displayName: 'Qwen Plus',
    68	    costPer1MInput: 0.8,
    69	    costPer1MOutput: 2.0,
    70	    maxContext: 131072,
    71	    strengths: ['orchestration', 'code_generation', 'analysis', 'chat', 'extraction'],
    72	    tier: 'balanced',
    73	    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
    74	  },
    75	  {
    76	    id: 'qwen3-coder-plus',
    77	    provider: 'alibaba',
    78	    displayName: 'Qwen3 Coder Plus',
    79	    costPer1MInput: 0.8,
    80	    costPer1MOutput: 2.0,
    81	    maxContext: 131072,
    82	    strengths: ['code_generation', 'code_review'],
    83	    tier: 'balanced',
    84	    envKey: 'ALIBABA_DASHSCOPE_API_KEY',
    85	  },
    86	  {
    87	    id: 'qwen-flash',
    88	    provider: 'alibaba',
    89	    displayName: 'Qwen Flash',
    90	    costPer1MInput: 0.0,
    91	    costPer1MOutput: 0.0,
    92	    maxContext: 131072,
    93	    strengths: ['fast_check', 'classification', 'summarization', 'translation', 'chat'],
    94	    tier: 'economy',
    95	    envKey: 'ALIBABA_DASHSCOPE_API_KEY',

exec
/bin/bash -lc 'git diff fdff002133ce42df149089d6147728cc91c44511 -- scripts/activation-check.ts apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md packages/pii-purge/README.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
index b10c9a85..04a2c2ca 100644
--- a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -110,7 +110,7 @@
 
 ## 8. README — abertura (DRAFT p/ HITL — README-FOCUS-REFLECT-001)
 
-> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. Substitui a abertura atual; o overhaul completo (badges/bilíngue) fica no README-OVERHAUL-001.
+> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN nunca lidera.** Substitui a abertura atual; o overhaul completo (badges) fica no README-OVERHAUL-001.
 
 ```markdown
 # EGOS
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
 

exec
/bin/bash -lc "sed -n '1,260p' packages/pii-purge/src/patterns.ts" in /home/enio/egos
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
/bin/bash -lc "nl -ba packages/pii-purge/src/cli.ts | sed -n '80,190p'" in /home/enio/egos
 succeeded in 0ms:
    80	  // 1. Load dictionary
    81	  const dict = await loadDictionary(opts.entityDict);
    82	  if (!opts.json) {
    83	    console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
    84	  }
    85	
    86	  // 2. Generate patterns + flatten raw values (literal safety net — VERIFY-001)
    87	  const patterns = generateAllPatterns(dict.entities);
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
   111	    }
   112	    process.exit(total === 0 ? 0 : 1);
   113	  }
   114	
   115	  // 3. Scan
   116	  const findings = await scanDirectory(opts.target, patterns, opts.entityDict);
   117	
   118	  const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
   119	  const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
   120	
   121	  if (!opts.json) {
   122	    console.log(`[pii-purge] Scan complete: ${findings.length} total findings`);
   123	    console.log(`  auto-purgeable: ${autoFindings.length}`);
   124	    console.log(`  REVIEW_REQUIRED (fuzzy): ${reviewFindings.length}`);
   125	    for (const f of findings) {
   126	      // NEVER print matched value — only metadata
   127	      const flag = f.matchType === 'fuzzy-REVIEW' ? ' [REVIEW_REQUIRED]' : '';
   128	      console.log(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}${flag}`);
   129	    }
   130	  }
   131	
   132	  // 4. Build token map
   133	  const tokenMap = buildTokenMap(dict.entities);
   134	
   135	  // 5. Purge (or dry-run)
   136	  const auditLogDir = dirname(opts.entityDict);
   137	  mkdirSync(auditLogDir, { recursive: true });
   138	
   139	  const purgeResult = await runPurge(findings, tokenMap, mode, auditLogDir);
   140	
   141	  if (!opts.json) {
   142	    if (mode === 'dry-run') {
   143	      console.log(`[pii-purge] DRY-RUN: would modify ${purgeResult.planned.length} file(s)`);
   144	      for (const p of purgeResult.planned) {
   145	        console.log(`  ${p.file} → ${p.findingsCount} replacement(s) with ${p.token}`);
   146	      }
   147	    } else {
   148	      console.log(`[pii-purge] APPLIED to ${purgeResult.applied.length} file(s)`);
   149	      if (purgeResult.auditLogPath) {
   150	        console.log(`[pii-purge] Audit log: ${purgeResult.auditLogPath}`);
   151	      }
   152	    }
   153	  }
   154	
   155	  // 6. Verify (only in apply mode — meaningful post-write)
   156	  let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
   157	  if (mode === 'apply') {
   158	    verifyResult = await verify(opts.target, patterns, literalValues, opts.entityDict);
   159	    if (!opts.json) {
   160	      if (verifyResult.cleanExit) {
   161	        console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
   162	      } else {
   163	        console.error(`[pii-purge] VERIFY FAILED: ${verifyResult.remaining.length} auto-purgeable finding(s) remain`);
   164	        for (const f of verifyResult.remaining) {
   165	          console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type}`);
   166	        }
   167	      }
   168	    }
   169	  }
   170	
   171	  if (opts.json) {
   172	    console.log(JSON.stringify({
   173	      mode,
   174	      findings: findings.map(f => ({
   175	        file: f.file,
   176	        line: f.line,
   177	        entityId: f.entityId,
   178	        type: f.type,
   179	        matchType: f.matchType,
   180	        // matched value intentionally omitted (T0 §3)
   181	      })),
   182	      planned: purgeResult.planned,
   183	      applied: purgeResult.applied,
   184	      skippedFuzzy: purgeResult.skippedFuzzy,
   185	      verifyCleanExit: verifyResult.cleanExit,
   186	      reviewRequiredCount: verifyResult.reviewRequired.length,
   187	      auditLogPath: purgeResult.auditLogPath ?? null,
   188	    }, null, 2));
   189	  }
   190	

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/cli.ts | sed -n '190,230p'" in /home/enio/egos
 succeeded in 0ms:
   190	
   191	  // 7. Exit code
   192	  const hasFuzzy = verifyResult.reviewRequired.length > 0;
   193	  const hasRemaining = !verifyResult.cleanExit;
   194	
   195	  if (hasFuzzy || hasRemaining) {
   196	    if (!opts.json) {
   197	      if (hasFuzzy) {
   198	        console.warn(`[pii-purge] ${verifyResult.reviewRequired.length} REVIEW_REQUIRED finding(s) — resolve manually before publishing`);
   199	      }
   200	    }
   201	    process.exit(1);
   202	  }
   203	
   204	  process.exit(0);
   205	}
   206	
   207	main().catch(err => {
   208	  console.error('[pii-purge] Fatal error:', err instanceof Error ? err.message : String(err));
   209	  process.exit(1);
   210	});

codex
The patch currently breaks TypeScript compilation and weakens the new verify-only publish gate for fuzzy PII findings. These issues should be fixed before considering the change correct.

Full review comments:

- [P1] Restore Alibaba compatibility or update dependents — /home/enio/egos/packages/shared/src/llm-provider.ts:3-3
  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.

- [P1] Block fuzzy findings in verify-only mode — /home/enio/egos/packages/pii-purge/src/cli.ts:93-95
  For `--verify-only` publish-gate runs, filtering out `fuzzy-REVIEW` means a target containing only fuzzy name hits can exit 0 and be reported clean, even though normal apply mode still blocks those findings as requiring human review. Since this mode is intended to block publication on known-entity findings, include fuzzy hits in the verify-only failure path or report them separately with a nonzero exit.
The patch currently breaks TypeScript compilation and weakens the new verify-only publish gate for fuzzy PII findings. These issues should be fixed before considering the change correct.

Full review comments:

- [P1] Restore Alibaba compatibility or update dependents — /home/enio/egos/packages/shared/src/llm-provider.ts:3-3
  With `alibaba` removed from `SharedLLMProvider` and `ALIBABA_MODELS` deleted, existing shared exports and model catalog entries no longer typecheck: `bun typecheck` fails in `packages/shared/src/index.ts`, `packages/shared/src/model-router.ts`, `scripts/review_models.ts`, and `scripts/start-audit.ts`. Either keep the compatibility type/export or update those dependents in the same patch.

- [P1] Block fuzzy findings in verify-only mode — /home/enio/egos/packages/pii-purge/src/cli.ts:93-95
  For `--verify-only` publish-gate runs, filtering out `fuzzy-REVIEW` means a target containing only fuzzy name hits can exit 0 and be reported clean, even though normal apply mode still blocks those findings as requiring human review. Since this mode is intended to block publication on known-entity findings, include fuzzy hits in the verify-only failure path or report them separately with a nonzero exit.
```
