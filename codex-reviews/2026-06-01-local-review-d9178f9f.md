# Codex Local Review — 2026-06-01T14:16:29Z

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
session id: 019e838b-1426-7931-b231-7b79029ce834
--------
user
changes against 'HEAD~3'
2026-06-01T14:16:31.373093Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:16:31.385974Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:16:35.879671Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:16:37.316739Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:16:37.712076Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:16:38.086761Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T14:16:38.661531Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T14:16:39.614399Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T14:16:41.245500Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T14:16:44.570077Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff e962b29885c3215b4871e2d8e6efc1a53112f12c' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index ddfe4cad..359676bb 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -514,6 +514,30 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **FE-SYNC-005** [P2] — README do repo público `egos-governance`: mencionar MCPs live + Resolver Doctrine + 79 caps (hoje marca mcp-eval-runner como "Alpha"). Factual.
 - [ ] **FE-SYNC-006** [P3] — Auto-regen do snapshot (cron quebrado desde abr) — wire `status-snapshot.ts` num cron/Hermes pós-deploy p/ não estagnar de novo.
 
+## 📓 NOTEBOOKLM — notebook do framework EGOS sempre atualizado (Enio 2026-06-01)
+
+> Notebook "EGOS Central Kernel — Framework Core" (`db55b6b8`). ✅ 2026-06-01: adicionadas constituição (CLAUDE.md + RULES_INDEX) + RESOLVER_DOCTRINE + CAPABILITY_REGISTRY (3→7 fontes). Regra: NotebookLM Obrigatório (versionar ADD-only, HITL deleção).
+- [ ] **NLM-FW-002** [P1] — Auto-sync OBRIGATÓRIO: doc canônico atualizado (CLAUDE.md/RULES_INDEX/AGENTS/RESOLVER/CAPABILITY_REGISTRY) → post-push Hermes → `source_delete`+`source_add` da MESMA fonte no notebook. Wire `notebook-sync-local.ts` (nunca rodou --exec) ao post-push. HITL só p/ deleção; ADD-only automático.
+
+## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
+
+> Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
+- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
+- [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
+
+## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
+
+> Guarani deixou 8 arquivos staged. ⚠️ Sci-Hub = circumvention de paywall — **Red Zone legal/reputacional p/ policial ativo + repo público**. NÃO commito o scraper sem corte do Enio.
+- [ ] **HANDOFF-SCIHUB-001** [P0] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
+- [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
+
+## 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
+
+> SSOT: `docs/governance/UI_FUNCTIONAL_TESTING_STANDARD.md` v1.0. Tooling existe (`mcp-browser-automation` + Playwright + §10 + visual-proof) mas NÃO há mapa por-página nem é seguido (drift egos.ia.br provou). Meta 80/20 → melhorar.
+- [ ] **UI-TEST-001** [P1] — Criar `docs/qa/pagemaps/egos-site.md`: mapa de TODAS as rotas do egos.ia.br (/, /status, /showcase, /skills, /timeline, /lab, /en/*) com elementos/APIs/estados. Base pro crawl.
+- [ ] **UI-TEST-002** [P1] — Wire Hermes crawl: percorre o mapa via browser-automation + Playwright, roda critérios §3 automatizáveis (rota/links/APIs/console/latência/screenshot), classifica com modelo barato (qwen/haiku), escreve `docs/qa/reports/`. ~$0.
+- [ ] **UI-TEST-003** [P2] — Enforce: gate pré-commit (toca UI → exige mapa+prova) + Layer QA no /start + Phase UI no /end.
+
 ## 🎓 CURSOS ↔ FRAMEWORK ↔ GOVERNO — Enio 2026-06-01
 
 > Tese: curso = ponte framework→governo + magistério (vetor seguro PCMG). Princípio "método aberto + dado soberano/local". SSOT `docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md` + memory `project_courses_framework_gov_thesis`. Red Zone: posições/pitch de governo = corte do Enio.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 280937eb..9a7ac4f8 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3303,3 +3303,21 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🌊 ONDA 3 — GOVERNANÇA E LIMPEZA (3-7 dias)
 - [x] **W3-T4** [P2] `1h` — CLAUDE.md sync: header em projeto referenciando global v5.3.0 + lazy `~/.claude/egos-rules/`.
 
+
+## Archived 2026-06-01
+
+### 📓 NOTEBOOKLM — notebook do framework EGOS sempre atualizado (Enio 2026-06-01)
+- [x] **NLM-FW-001** — Popular notebook framework com constituição + arquivos principais (7 fontes). Registrado em sync-log.
+
+
+## Archived 2026-06-01
+
+### ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
+- [x] **BLOCKCHAIN-001** — Pesquisa feita (Sonnet). **ACHADO:** `$ETHIK` JÁ está LIVE na Base (`0x633b346b85c4877ace4d47f7aa72c2a092136cb5`, Flaunch/Uniswap V4, tradeable) — `egos-lab/docs/ETHIK_COMPLETE.md`. Recomendação: **caminho do meio (C)** — anchoring (OpenTimestamps em commits) + EAS attestations na Base p/ governança, SEM token tradeable. $ETHIK dormente até parecer legal.
+
+
+## Archived 2026-06-01
+
+### 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
+- [x] **UI-TEST-000** — Standard escrito (critérios §3, mapa §2, automação Hermes §4, sign-off duplo §5).
+
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 35af7343..5f2c9d9e 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -238,6 +238,32 @@ async function logTokenUsage(
   } catch { /* best-effort */ }
 }
 
+// Canonical per-call usage log (api_usage) — written on EVERY LLM call, not just
+// tenant ones. Read by get_costs + scripts/llm-usage-notify.ts. Before 2026-06-01
+// nothing wrote here, so cost tracking was silently dead.
+function providerFromModel(model: string): string {
+  const m = model.toLowerCase();
+  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
+  if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3")) return "OpenAI";
+  if (m.includes("gemini") || m.includes("gemma")) return "Google";
+  if (m.includes("claude")) return "Anthropic";
+  if (m.includes("deepseek") || m.includes("/")) return "OpenRouter";
+  return "Other";
+}
+
+async function logApiUsage(model: string, inputTokens: number, outputTokens: number, channel: string): Promise<void> {
+  if (!SUPABASE_URL || !SUPABASE_KEY) return;
+  const cost = estimateCostUsd(model, inputTokens, outputTokens);
+  try {
+    await fetch(`${SUPABASE_URL}/rest/v1/api_usage`, {
+      method: "POST",
+      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json", Prefer: "return=minimal" },
+      body: JSON.stringify({ provider: providerFromModel(model), model, tokens_in: inputTokens, tokens_out: outputTokens, cost_usd: cost, channel }),
+      signal: AbortSignal.timeout(5000),
+    });
+  } catch { /* best-effort */ }
+}
+
 // ─── Tool: system_status ──────────────────────────────────────────────────────
 
 async function toolSystemStatus(): Promise<string> {
@@ -305,7 +331,7 @@ async function toolGuardStatus(): Promise<string> {
 // ─── Tool: guard_test ─────────────────────────────────────────────────────────
 
 async function toolGuardTest(text: string): Promise<string> {
-  if (!text) return "Forneça um texto para testar (ex: 'João Silva CPF 123.456.789-00')";
+  if (!text) return "Forneça um texto para testar (ex: 'João Silva CPF XXX.XXX.XXX-XX')";
   try {
     const res = await fetch(`${GUARD_URL}/v1/inspect`, {
       method: "POST",
@@ -606,7 +632,7 @@ const TOOL_DEFS = [
       description: "Testa detecção de PII/dados sensíveis em um texto usando a Guard Brasil API. Útil para demos e validações.",
       parameters: {
         type: "object",
-        properties: { text: { type: "string", description: "Texto para análise de PII (ex: 'João CPF 123.456.789-00')" } },
+        properties: { text: { type: "string", description: "Texto para análise de PII (ex: 'João CPF XXX.XXX.XXX-XX')" } },
         required: ["text"],
       },
     },
@@ -1638,7 +1664,9 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
       // Persist conversation turn + token log (non-blocking)
       saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
       if (data.usage?.prompt_tokens) {
-        logTokenUsage(client?.slug, data.model ?? "qwen-plus", data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
+        const usedModel = data.model ?? "qwen-plus";
+        logTokenUsage(client?.slug, usedModel, data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
+        logApiUsage(usedModel, data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
       }
       return { text: formatted, toolsUsed };
     }
diff --git a/docs/governance/UI_FUNCTIONAL_TESTING_STANDARD.md b/docs/governance/UI_FUNCTIONAL_TESTING_STANDARD.md
new file mode 100644
index 00000000..4bcde975
--- /dev/null
+++ b/docs/governance/UI_FUNCTIONAL_TESTING_STANDARD.md
@@ -0,0 +1,68 @@
+# UI/UX Functional Testing Standard — mapa + critérios + sign-off
+
+> **Status:** CANONICAL v1.0 (2026-06-01) · T1 (obrigatório p/ qualquer página/UI declarada "done")
+> **Origem:** Enio 2026-06-01 — "toda funcionalidade deve ter um mapa e confirmação manual minha e sua; testar todos os usos reais (digitações, cliques seguidos, ir/voltar, headers, botões, rotas, APIs, velocidade)".
+> **Estende:** §10 FLOW VALIDATION GATE (`~/.claude/CLAUDE.md`) + gate Visual Proof (`§0.5`). Tooling: `mcp-browser-automation` (`check_links`, `check_url`, `fetch_page`, `visual_proof_gate`, `check_playwright`) + Playwright.
+> **Meta:** começar em **80/20** (cobrir 80% do valor com 20% do esforço) e melhorar os critérios iterativamente.
+
+---
+
+## §1 — Regra (T1)
+
+Nenhuma página/rota/feature de UI é **[DONE]** sem: (1) entrada no **mapa de funcionalidades** (`§2`), (2) **teste funcional real** passando nos critérios `§3`, (3) **prova** (screenshot + console limpo + latências), (4) **sign-off duplo** — Prime marca `prime-ok`, Enio marca `enio-ok`. Sem os dois → `[CONCEPT]`, não `[DONE]`.
+
+## §2 — Mapa de funcionalidades (formato)
+
+Um arquivo por app: `docs/qa/pagemaps/<app>.md`. Cada página = uma linha:
+
+```
+| Rota | Elementos (headers/botões/links/forms) | APIs chamadas | Estados (loading/erro/vazio) | Última verificação | prime-ok | enio-ok |
+|------|----------------------------------------|---------------|------------------------------|--------------------|----------|---------|
+| /status | header, cards serviços, bloco framework, link status.json | GET /status.json | ok / 503 snapshot ausente | 2026-06-01 | ✅ | ⏳ |
+```
+
+O mapa é o SSOT do "o que existe pra testar". Página nova → linha nova no mesmo commit.
+
+## §3 — Critérios de teste (matriz — v1, melhorar iterativamente)
+
+Por página, verificar:
+
+| Categoria | Critério (v1 80/20) |
+|---|---|
+| **Rota** | HTTP 200 (ou status esperado); sem redirect quebrado; `/en/*` espelha PT quando aplicável |
+| **Header/nav** | links do header existem e resolvem (200); logo clica → home; consistência entre páginas |
+| **Botões/CTAs** | cada botão tem destino válido (200, não 404/#); hover não quebra (Codex P2: `e.currentTarget`) |
+| **Links** | `check_links` → 0 quebrados (404/500/timeout) |
+| **Navegação** | ir→voltar (browser back) mantém estado; clicar 2x seguidas não duplica/quebra; deep-link direto funciona |
+| **Forms/digitação** | input vazio, input válido, input inválido, caracteres especiais/acentos, paste — todos tratados (sem crash, msg de erro clara) |
+| **APIs** | cada fetch da página responde no contrato (status + shape); erro de API → UI mostra estado de erro, não tela branca |
+| **Consistência** | header/footer/tema iguais entre páginas; sem "snapshot indisponível"/dado estagnado |
+| **Velocidade** | TTFB < 1s; página interativa < 3s; APIs < 2s (medir, registrar; acima → flag) |
+| **Console** | zero erro no console; zero warning crítico |
+| **Prova visual** | screenshot da página renderizada anexado (`visual_proof_gate`) |
+
+**80/20 inicial:** Rota + Header + Links + APIs + Console + Prova visual = os 6 que pegam a maioria dos defeitos. Forms/navegação/velocidade entram na 2ª onda. Melhorar critérios a cada incidente achado.
+
+## §4 — Automação (Hermes + modelo barato)
+
+Crawl periódico, custo ~$0:
+1. **Hermes** (VPS) roda um job que, via `mcp-browser-automation` + Playwright, percorre cada rota do mapa, executa os critérios `§3` automatizáveis (rota/links/APIs/console/latência/screenshot).
+2. **Modelo barato** (qwen/haiku via llm-router) classifica o resultado e descreve regressões em linguagem clara — não precisa de modelo caro pra "o link X deu 404".
+3. Saída → `docs/qa/reports/<app>-<data>.md` + flag no blackboard se algo quebrou. Gera as linhas de "última verificação" do mapa.
+4. O que a automação NÃO cobre (julgamento de UX, "tá feio", fluxo confuso) → fica pro **sign-off manual** do Enio.
+
+## §5 — Sign-off duplo (manual)
+
+- **prime-ok:** Prime rodou os critérios `§3` (auto + leitura da prova) e atesta no mapa.
+- **enio-ok:** Enio olhou a página real e aprovou UX/conteúdo (Red Zone de copy/visual continua sendo corte dele).
+- Só com os dois `✅` a feature é `[DONE]`. Discordância → volta pra `[CONCEPT]`.
+
+## §6 — Como isso é enforced
+
+- **Pré-commit (advisory→strict):** se o commit toca UI (`apps/*/src/**`, `*.jsx/tsx`, rotas), o gate lembra de atualizar o mapa + anexar prova. Strict depois que os mapas existirem.
+- **/start:** Layer de QA reporta páginas sem `prime-ok+enio-ok` recente.
+- **/end:** Phase de UI — toda rota nova da sessão precisa de linha no mapa + prova.
+
+---
+
+*SSOT desta regra. Tasks: UI-TEST-001 (mapa egos.ia.br), UI-TEST-002 (Hermes crawl automático), UI-TEST-003 (wire pré-commit/start/end). Melhorar critérios §3 a cada defeito real encontrado (loop 80/20 → 90/10 → …).*
diff --git a/docs/notebooklm/sync-log.md b/docs/notebooklm/sync-log.md
index b94ec5fa..7e280e38 100644
--- a/docs/notebooklm/sync-log.md
+++ b/docs/notebooklm/sync-log.md
@@ -27,3 +27,5 @@
 | 2026-05-30 | EGOS Central Kernel | AGENTS.md | — | source_add (a0ffac94) | regras canônicas R0-R8 (§9.1 companion obrigatório) |
 | 2026-05-30 | EGOS Central Kernel | docs/EGOS_BOOTSTRAP.md | — | source_add (949b2a4a) | arquitetura/SSOT map (§9.1 companion obrigatório) |
 | 2026-05-30 | EGOS Central Kernel | README.md (dup) | — | source_delete (c521b437) | correção: bug idempotência pré-fix re-adicionou README; deletado duplicado, canonical = e031fb88. Fix: processar só ops cujo último status=detected |
+
+| 2026-06-01 | EGOS Central Kernel — Framework Core (db55b6b8) | CLAUDE.md + .guarani/RULES_INDEX.md + RESOLVER_DOCTRINE.md + CAPABILITY_REGISTRY.md | ADD (3→7 fontes) | constituição + arquivos principais; auto-sync pendente NLM-FW-002 |
diff --git a/scripts/llm-usage-notify.ts b/scripts/llm-usage-notify.ts
index e66696a8..10b7e1ad 100644
--- a/scripts/llm-usage-notify.ts
+++ b/scripts/llm-usage-notify.ts
@@ -26,9 +26,28 @@
 export {};
 
 import { spawnSync } from "child_process";
-import { readFileSync } from "fs";
+import { existsSync, readFileSync } from "fs";
 import { join } from "path";
 
+// Robust env read: process.env first, else parse ROOT/.env directly. The repo's
+// .env mixes `export VAR=` lines and values that break dotenv's parser partway,
+// so late keys (SUPABASE/TELEGRAM) silently never load. This sidesteps that.
+let _envFile: Record<string, string> | null = null;
+function fileEnv(name: string): string {
+  if (process.env[name]?.trim()) return process.env[name]!.trim();
+  if (_envFile === null) {
+    _envFile = {};
+    const p = join(process.cwd(), ".env");
+    if (existsSync(p)) {
+      for (const line of readFileSync(p, "utf-8").split("\n")) {
+        const m = line.match(/^\s*(?:export\s+)?([A-Z0-9_]+)\s*=\s*(.*)$/);
+        if (m) _envFile[m[1]] = m[2].trim().replace(/^["']|["']$/g, "");
+      }
+    }
+  }
+  return _envFile[name] ?? "";
+}
+
 // ── Args ──────────────────────────────────────────────────────────────────────
 const args = process.argv.slice(2);
 const DRY = args.includes("--dry");
@@ -37,10 +56,10 @@ const daysIdx = args.indexOf("--days");
 const DAYS = daysIdx >= 0 ? Math.max(1, parseInt(args[daysIdx + 1] ?? "1", 10)) : 1;
 
 const ROOT = process.cwd();
-const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
-const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
-const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN ?? process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS ?? "";
-const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID ?? "171767219";
+const SUPABASE_URL = fileEnv("SUPABASE_URL");
+const SUPABASE_KEY = fileEnv("SUPABASE_SERVICE_ROLE_KEY");
+const TELEGRAM_BOT_TOKEN = fileEnv("TELEGRAM_BOT_TOKEN") || fileEnv("TELEGRAM_BOT_TOKEN_AI_AGENTS");
+const TELEGRAM_CHAT_ID = fileEnv("TELEGRAM_ADMIN_CHAT_ID") || "171767219";
 
 // ── Model → provider mapping ────────────────────────────────────────────────
 function providerOf(model: string): string {
diff --git a/supabase/migrations/20260601105458_api_usage.sql b/supabase/migrations/20260601105458_api_usage.sql
new file mode 100644
index 00000000..75091f1e
--- /dev/null
+++ b/supabase/migrations/20260601105458_api_usage.sql
@@ -0,0 +1,36 @@
+-- api_usage — per-call LLM usage/cost log (egos-gateway orchestrator)
+--
+-- Why: 2026-06-01 — get_costs (orchestrator tool) and llm-usage-notify both
+-- read public.api_usage, but the table was NEVER created. logTokenUsage wrote
+-- to consulting_token_log (also missing) only for tenant calls. Net effect:
+-- EGOS had zero working LLM usage/cost tracking. This table is the canonical
+-- per-call log, populated by logApiUsage() on EVERY gateway LLM call.
+--
+-- Discipline: internal cost table — NOT storefront/anon-facing. RLS enabled to
+-- deny client-side reads; the gateway + notifier use the service role (which
+-- bypasses RLS). No anon/authenticated policy by design.
+
+CREATE TABLE IF NOT EXISTS public.api_usage (
+  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
+  date        date NOT NULL DEFAULT ((now() AT TIME ZONE 'utc')::date),
+  provider    text,
+  model       text NOT NULL,
+  tokens_in   integer NOT NULL DEFAULT 0,
+  tokens_out  integer NOT NULL DEFAULT 0,
+  cost_usd    numeric(12,6) NOT NULL DEFAULT 0,
+  channel     text,
+  created_at  timestamptz NOT NULL DEFAULT now()
+);
+
+CREATE INDEX IF NOT EXISTS idx_api_usage_date ON public.api_usage(date);
+CREATE INDEX IF NOT EXISTS idx_api_usage_model ON public.api_usage(model);
+
+ALTER TABLE public.api_usage ENABLE ROW LEVEL SECURITY;
+
+COMMENT ON TABLE public.api_usage IS
+  'Per-call LLM usage/cost log (egos-gateway). Read by get_costs + llm-usage-notify. Service-role only (RLS denies anon/authenticated).';
+
+-- Explicit policy (R-RLS-001): service role only. Anon/authenticated get no
+-- policy => RLS denies them by default (internal cost data, not storefront).
+CREATE POLICY api_usage_service_role_all ON public.api_usage
+  FOR ALL TO service_role USING (true) WITH CHECK (true);

exec
/bin/bash -lc "sed -n '1,260p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * EGOS Gateway — AI Orchestrator v2
 *
 * Shared LLM orchestration for WhatsApp + Telegram chatbots.
 * Model: qwen-plus (Alibaba DashScope)
 * Transcription: Groq Whisper-large-v3-turbo
 * Vision: qwen-vl-plus
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

const DASHSCOPE_BASE =
  process.env.ALIBABA_DASHSCOPE_BASE_URL ??
  "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";

/**
 * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
 *
 * Default: gemini-2.5-flash via OpenRouter (60% mais barato que qwen-plus,
 * PT-BR nativo, tool-calling sólido).
 *
 * Rollback: setar CHATBOT_PRIMARY_MODEL=qwen-plus no .env do gateway.
 *
 * Fallback chain: primary → fallback → qwen-plus (último recurso).
 */
interface LLMProvider {
  name: string;
  base: string;
  key: string;
  model: string;
}

const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "qwen-plus";

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
  // Qwen via DashScope direto
  if (modelName.startsWith("qwen-")) {
    if (!DASHSCOPE_KEY) return null;
    return {
      name: modelName,
      base: DASHSCOPE_BASE,
      key: DASHSCOPE_KEY,
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
    });
    return res.ok ? res.json() : null;
  } catch {
    return null;
  }
}

async function sbInsert(table: string, row: Record<string, unknown>): Promise<boolean> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return false;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}`, {
      method: "POST",
      headers: SB_HEADERS(),
      body: JSON.stringify(row),
      signal: AbortSignal.timeout(6000),
    });
    return res.status === 201 || res.status === 200;
  } catch {
    return false;
  }
}

// ─── Conversation memory ──────────────────────────────────────────────────────

interface HistoryRow {
  role: "user" | "assistant";
  content: string;
  created_at: string;
}

async function loadHistory(channel: string, userId: string, limit = 12): Promise<HistoryRow[]> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return [];
  try {
    const rows = await sbFetch(
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
  "qwen-plus":               { input: 0.0004, output: 0.0012 },
  "qwen-max":                { input: 0.0024, output: 0.0072 },
  "qwen-turbo":              { input: 0.0001, output: 0.0003 },
  "minimax/minimax-m2.5":    { input: 0.0002, output: 0.0002 },
  "google/gemini-2.0-flash": { input: 0.0001, output: 0.0004 },
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
  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
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
      method: "POST",
      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json", Prefer: "return=minimal" },

exec
/bin/bash -lc "grep -n \"function providerOf\\|provider\" -n scripts/llm-usage-notify.ts apps/egos-gateway/src/orchestrator.ts | head -n 40" in /home/enio/egos
 succeeded in 0ms:
scripts/llm-usage-notify.ts:5: * Pushes a daily LLM usage + provider-key-health report to Telegram.
scripts/llm-usage-notify.ts:10: *   1. KEY HEALTH — runs `doctor.ts --json` (authenticated probe). A provider
scripts/llm-usage-notify.ts:13: *      aggregated by provider for the window.
scripts/llm-usage-notify.ts:23: *      TELEGRAM_ADMIN_CHAT_ID (default 171767219), + provider keys for doctor.
scripts/llm-usage-notify.ts:64:// ── Model → provider mapping ────────────────────────────────────────────────
scripts/llm-usage-notify.ts:65:function providerOf(model: string): string {
scripts/llm-usage-notify.ts:92:    .filter((x: any) => x.category === "provider")
scripts/llm-usage-notify.ts:127:  lines.push("*Chaves de provider:*");
scripts/llm-usage-notify.ts:137:  // Usage by provider
scripts/llm-usage-notify.ts:141:    const p = providerOf(r.model ?? "?");
scripts/llm-usage-notify.ts:150:  lines.push("*Usage por provider:*");
apps/egos-gateway/src/orchestrator.ts:244:function providerFromModel(model: string): string {
apps/egos-gateway/src/orchestrator.ts:261:      body: JSON.stringify({ provider: providerFromModel(model), model, tokens_in: inputTokens, tokens_out: outputTokens, cost_usd: cost, channel }),
apps/egos-gateway/src/orchestrator.ts:1609:      const provider = getProvider(modelName);
apps/egos-gateway/src/orchestrator.ts:1610:      if (!provider) return null;
apps/egos-gateway/src/orchestrator.ts:1613:          Authorization: `Bearer ${provider.key}`,
apps/egos-gateway/src/orchestrator.ts:1617:        if (provider.base.includes("openrouter.ai")) {
apps/egos-gateway/src/orchestrator.ts:1621:        const res = await fetch(`${provider.base}/chat/completions`, {
apps/egos-gateway/src/orchestrator.ts:1625:            model: provider.model,
apps/egos-gateway/src/orchestrator.ts:1635:          console.error(`[orchestrator] ${provider.name} ${res.status}: ${(await res.text()).substring(0, 200)}`);
apps/egos-gateway/src/orchestrator.ts:1640:        console.error(`[orchestrator] ${provider.name} error: ${(e as Error).message}`);
apps/egos-gateway/src/orchestrator.ts:1651:      console.error(`[orchestrator] ALL providers failed`);

exec
/bin/bash -lc "sed -n '60,90p' scripts/llm-usage-notify.ts" in /home/enio/egos
 succeeded in 0ms:
const SUPABASE_KEY = fileEnv("SUPABASE_SERVICE_ROLE_KEY");
const TELEGRAM_BOT_TOKEN = fileEnv("TELEGRAM_BOT_TOKEN") || fileEnv("TELEGRAM_BOT_TOKEN_AI_AGENTS");
const TELEGRAM_CHAT_ID = fileEnv("TELEGRAM_ADMIN_CHAT_ID") || "171767219";

// ── Model → provider mapping ────────────────────────────────────────────────
function providerOf(model: string): string {
  const m = model.toLowerCase();
  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
  if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3") || m.includes("openai")) return "OpenAI";
  if (m.includes("gemini") || m.includes("gemma")) return "Google";
  if (m.includes("claude")) return "Anthropic";
  if (m.includes("deepseek") || m.includes(":free") || m.includes("/")) return "OpenRouter";
  return "Other";
}

// ── 1. Key health via doctor.ts --json ───────────────────────────────────────
interface ProviderHealth { item: string; status: string; detail?: string }

function getKeyHealth(): ProviderHealth[] {
  // Run doctor (writes docs/_generated/doctor-report.json). Prefer the file it
  // writes; fall back to stdout JSON.
  const r = spawnSync("bun", ["scripts/doctor.ts", "--json"], {
    cwd: ROOT, encoding: "utf-8", timeout: 60000,
  });
  let report: any = null;
  try {
    report = JSON.parse(readFileSync(join(ROOT, "docs/_generated/doctor-report.json"), "utf-8"));
  } catch {
    try { report = JSON.parse(r.stdout ?? "{}"); } catch { report = null; }
  }
  if (!report?.results) return [];

exec
/bin/bash -lc "grep -n \"toolGetCosts\\|get_costs\\|api_usage\" -n apps/egos-gateway/src/orchestrator.ts | head -n 40" in /home/enio/egos
 succeeded in 0ms:
12: *   get_costs, knowledge_stats, world_model
241:// Canonical per-call usage log (api_usage) — written on EVERY LLM call, not just
242:// tenant ones. Read by get_costs + scripts/llm-usage-notify.ts. Before 2026-06-01
258:    await fetch(`${SUPABASE_URL}/rest/v1/api_usage`, {
517:// ─── Tool: get_costs ─────────────────────────────────────────────────────────
519:async function toolGetCosts(): Promise<string> {
521:  const data = await sbFetch(`api_usage?select=model,tokens_in,tokens_out,cost_usd&date=eq.${today}`) as
721:      name: "get_costs",
1150:    case "get_costs":        return toolGetCosts();
1519:11. get_costs — custos de API de hoje

exec
/bin/bash -lc "sed -n '517,560p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
// ─── Tool: get_costs ─────────────────────────────────────────────────────────

async function toolGetCosts(): Promise<string> {
  const today = new Date().toISOString().slice(0, 10);
  const data = await sbFetch(`api_usage?select=model,tokens_in,tokens_out,cost_usd&date=eq.${today}`) as
    | Array<{ model?: string; tokens_in?: number; tokens_out?: number; cost_usd?: number }>
    | null;

  if (!data || !data.length) {
    return `💰 Sem dados de custo para ${today}.\n(Supabase não configurado localmente)`;
  }
  let total = 0;
  const lines = [`💰 *Custos de hoje (${today}):*`];
  for (const r of data) {
    const c = r.cost_usd ?? 0;
    total += c;
    lines.push(`• ${r.model ?? "?"}: $${c.toFixed(4)} (${r.tokens_in ?? 0}in/${r.tokens_out ?? 0}out)`);
  }
  lines.push(`\n*Total: $${total.toFixed(4)}*`);
  return lines.join("\n");
}

// ─── Tool: knowledge_stats ───────────────────────────────────────────────────

async function toolKnowledgeStats(): Promise<string> {
  try {
    const res = await fetch(`${GW}/knowledge/stats`, { signal: AbortSignal.timeout(5000) });
    if (!res.ok) return "Knowledge Base indisponível.";
    const d = await res.json() as {
      pages: { total: number; avg_quality: number; by_category: Record<string, number> };
      learnings: { total: number; by_domain: Record<string, number>; by_outcome: Record<string, number> };
    };
    const cats = Object.entries(d.pages.by_category)
      .sort(([, a], [, b]) => b - a)
      .map(([k, v]) => `${k}:${v}`)
      .join(", ");
    const domains = Object.entries(d.learnings.by_domain)
      .sort(([, a], [, b]) => b - a)
      .slice(0, 4)
      .map(([k, v]) => `${k}:${v}`)
      .join(", ");
    return `📚 *Knowledge Base Stats:*\nPáginas: ${d.pages.total} | Qualidade média: ${d.pages.avg_quality}/100\nCategorias: ${cats}\nLearnings: ${d.learnings.total} (${domains})`;
  } catch {
    return "Knowledge Base indisponível.";

exec
/bin/bash -lc "ls -1 .env* && ( [ -f .env.example ] && sed -n '1,80p' .env.example || true )" in /home/enio/egos
 succeeded in 0ms:
.env
.env.backup-1777031943
.env.backup-2026-05-27-pre-keyrot
.env.example
.env.local
# ═══════════════════════════════════════════════════════════
# EGOS Core — Environment Variables
# Copy to .env and fill in your values. NEVER commit .env.
# ═══════════════════════════════════════════════════════════

# ── LLM Providers ──
ALIBABA_DASHSCOPE_API_KEY=
ALIBABA_DASHSCOPE_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1
OPENROUTER_API_KEY=
OPENAI_API_KEY=
GROQ_API_KEY=

# ── Orchestrator Defaults ──
EGOS_ORCHESTRATOR_PROVIDER=alibaba
EGOS_ORCHESTRATOR_MODEL=qwen-plus
LLM_PROVIDER=alibaba

# ── Search & Research ──
SERPER_API_KEY=
BRAVE_API=
EXA_API_KEY=

# ── GitHub ──
GITHUB_PERSONAL_ACCESS_TOKEN=
GITHUB_TOKEN=

# ── Stitch (UI Design) ──
STITCH_API_KEY=

# ── Supabase (optional — for leaf repos that need persistence) ──
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# ── Supabase (EGOS kernel / MCP servers) ──
EGOS_SUPABASE_URL=          # same as SUPABASE_URL for kernel
EGOS_SUPABASE_KEY=          # anon key (mcp-bridge audit log)
EGOS_SUPABASE_SERVICE_KEY=  # service-role key (mcp-audit-lite write)

# ── MCP Infrastructure ──
EGOS_MCP_TOKEN=             # bearer token for mcp-bridge auth (prod)
EGOS_MCP_ALLOWED_ORIGINS=   # comma-separated allowed origins (e.g. https://claude.ai)
EGOS_TENANT_ID=kernel       # tenant id for audit events
EGOS_GATEWAY_URL=https://gateway.egos.ia.br  # internal gateway for knowledge-mcp

# ── Telegram (notifications + cron digests) ──
TELEGRAM_BOT_TOKEN=         # @BotFather token
TELEGRAM_CHAT_ID=           # target chat/group id
TELEGRAM_ADMIN_CHAT_ID=     # admin-only notifications
TELEGRAM_AUTHORIZED_USER_ID= # whitelist for admin commands

# ── Substack dual-publish (timeline-approval-bot) ──
# SUBSTACK_SID=  # Get from browser DevTools > Application > Cookies > substack.com > substack.sid
# SUBSTACK_PUBLICATION_URL=https://egos.substack.com
# TIMELINE_BASE_URL=https://egos.ia.br  # base URL for article links in Substack notes

# ── Guard Brasil x402 Payment Channel (API-004/005) ──
# Recipient wallet on Base chain (USDC). Only the address needed (no private key).
GUARD_BRASIL_PAYMENT_ADDRESS=0x7f43b82a000a1977cc355c6e7ece166dfbb885ab
GUARD_BRASIL_API_URL=https://guard.egos.ia.br
GUARD_BRASIL_API_KEY=   # internal service key (get from guard.egos.ia.br/v1/keys)
# Pricing config — env-overridable, default $0.001 USDC/call (market reference)
X402_PRICE_USDC_ATOMIC=1000
X402_NETWORK=base
X402_FACILITATOR_URL=https://x402.org/facilitator

# === Auto-documented 2026-05-30 (used in code, was undocumented) ===

# ── Anthropic / Claude ──
ANTHROPIC_API_KEY=                   # packages/shared/src/local-llm-router.ts:214

# ── Google / Gemini ──
GEMINI_API_KEY=                      # scripts/ssot-router.ts:151
GOOGLE_AI_STUDIO_API_KEY=            # packages/shared/src/llm-providers/llm-router.ts (alias for Gemini)
GOOGLE_CLIENT_ID=                    # apps/egos-gateway/src/orchestrator.ts:952
GOOGLE_CLIENT_SECRET=                # apps/egos-gateway/src/orchestrator.ts:953
GEMINI_DAILY_REQUEST_LIMIT=10000     # scripts/gemini-quota-tracker.ts:134
GEMINI_DAILY_TOKEN_LIMIT=1000000     # scripts/gemini-quota-tracker.ts:133
GEMINI_LOG_FILE=/var/log/egos/gemini.log  # scripts/gemini-quota-tracker.ts:13


exec
/bin/bash -lc "nl -ba scripts/llm-usage-notify.ts | sed -n '30,60p'" in /home/enio/egos
 succeeded in 0ms:
    30	import { join } from "path";
    31	
    32	// Robust env read: process.env first, else parse ROOT/.env directly. The repo's
    33	// .env mixes `export VAR=` lines and values that break dotenv's parser partway,
    34	// so late keys (SUPABASE/TELEGRAM) silently never load. This sidesteps that.
    35	let _envFile: Record<string, string> | null = null;
    36	function fileEnv(name: string): string {
    37	  if (process.env[name]?.trim()) return process.env[name]!.trim();
    38	  if (_envFile === null) {
    39	    _envFile = {};
    40	    const p = join(process.cwd(), ".env");
    41	    if (existsSync(p)) {
    42	      for (const line of readFileSync(p, "utf-8").split("\n")) {
    43	        const m = line.match(/^\s*(?:export\s+)?([A-Z0-9_]+)\s*=\s*(.*)$/);
    44	        if (m) _envFile[m[1]] = m[2].trim().replace(/^["']|["']$/g, "");
    45	      }
    46	    }
    47	  }
    48	  return _envFile[name] ?? "";
    49	}
    50	
    51	// ── Args ──────────────────────────────────────────────────────────────────────
    52	const args = process.argv.slice(2);
    53	const DRY = args.includes("--dry");
    54	const ALERT_ONLY = args.includes("--alert-only");
    55	const daysIdx = args.indexOf("--days");
    56	const DAYS = daysIdx >= 0 ? Math.max(1, parseInt(args[daysIdx + 1] ?? "1", 10)) : 1;
    57	
    58	const ROOT = process.cwd();
    59	const SUPABASE_URL = fileEnv("SUPABASE_URL");
    60	const SUPABASE_KEY = fileEnv("SUPABASE_SERVICE_ROLE_KEY");

codex
The fallback env loader introduced in this patch can parse common `.env` lines incorrectly by including inline comments in values, which can break Supabase/Telegram connectivity in the intended execution mode.

Review comment:

- [P2] Strip inline comments when parsing .env fallback values — /home/enio/egos/scripts/llm-usage-notify.ts:44-44
  The new `fileEnv` fallback parser stores everything after `=` as the value, so `.env` lines like `SUPABASE_URL=https://... # comment` or `TELEGRAM_BOT_TOKEN=abc # prod` become invalid values with trailing comment text. In runs where `process.env` is not pre-populated (the exact case this fallback is meant to fix), this causes malformed URLs/tokens and breaks usage fetch/notification delivery.
The fallback env loader introduced in this patch can parse common `.env` lines incorrectly by including inline comments in values, which can break Supabase/Telegram connectivity in the intended execution mode.

Review comment:

- [P2] Strip inline comments when parsing .env fallback values — /home/enio/egos/scripts/llm-usage-notify.ts:44-44
  The new `fileEnv` fallback parser stores everything after `=` as the value, so `.env` lines like `SUPABASE_URL=https://... # comment` or `TELEGRAM_BOT_TOKEN=abc # prod` become invalid values with trailing comment text. In runs where `process.env` is not pre-populated (the exact case this fallback is meant to fix), this causes malformed URLs/tokens and breaks usage fetch/notification delivery.
```
