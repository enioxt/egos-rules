# Codex Local Review — 2026-06-01T14:29:18Z

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
session id: 019e8396-ce2f-7102-8334-90c07f39d5ca
--------
user
changes against 'HEAD~3'
2026-06-01T14:29:20.155469Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:29:20.155760Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:29:27.286673Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:29:27.655636Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:29:28.100803Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:29:28.458259Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T14:29:29.025054Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T14:29:29.971464Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T14:29:31.643713Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T14:29:35.234951Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 85baff23b812486946f1cfac46859f91f915a492' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index c3432524..359676bb 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -522,8 +522,8 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
 
 > Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
-- [/] **BLOCKCHAIN-001** [P1] `research` — Pesquisa: melhores contratos/stacks 2026 p/ provenance/attestation (não defi/meme); A(token próprio) vs B(chain existente) vs C(anchoring/attestation sem token tradeable). Frame de decisão. (Sonnet rodando.)
-- [ ] **BLOCKCHAIN-002** [P2] `redzone` — Corte do Enio sobre A/B/C + securities/estatuto. Nada on-chain sem este gate.
+- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
+- [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
 
 ## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
 
@@ -531,6 +531,13 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **HANDOFF-SCIHUB-001** [P0] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
 - [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
 
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
index 9c03c268..9a7ac4f8 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3309,3 +3309,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 📓 NOTEBOOKLM — notebook do framework EGOS sempre atualizado (Enio 2026-06-01)
 - [x] **NLM-FW-001** — Popular notebook framework com constituição + arquivos principais (7 fontes). Registrado em sync-log.
 
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
diff --git a/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md b/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md
new file mode 100644
index 00000000..722c7aff
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md
@@ -0,0 +1,46 @@
+# Handoff — 2026-06-01 — Alibaba incident + EGOS-Telegram F1
+
+## ✅ Accomplished (com SHAs)
+- **Alibaba investigation** — chave morta (401) nas 3 superfícies; VPS root cause `provider: alibaba_dashscope`→`alibaba` (+`DASHSCOPE_API_KEY`); rotacionada + validada e2e (qwen-plus PONG). Não commitado (ops VPS + rotação de secret).
+- **Part A** — `e9831cf5` — `scripts/doctor.ts` probe autenticado (401=FAIL), 3 callers CN→intl (`ssot-router`/`manifest-generator`/`chatbot-core/model-router`), chave Gemini hardcoded removida, PAT `gho_` tirado do `.git/config`, `CAPABILITY_REGISTRY §16`.
+- **Part B** — `fb24141d` — `docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md` (4 fases + decisão de runtime com evidência: egos-gateway TS dono do Telegram).
+- **F1a** — `e667d423` — `scripts/llm-usage-notify.ts` (saúde+usage→Telegram).
+- **F1b** — `70994fee` (folded por sessão paralela — atribuição errada, conteúdo ok) — migration `api_usage` + RLS (aplicada egos-lab), `logApiUsage()` no orchestrator, notifier com leitor .env robusto.
+- **Crons** — local (diário 08:00 + alert-only 0/6/12/18) + VPS (alert-only 3/9/15/21) → cobertura ≤3h 24/7.
+
+## 🔄 In Progress
+- (nenhum) — F1 entregue até o limite do que não exige redeploy.
+
+## ⏳ Blocked
+- **Usage $ real** — bloqueado em redeploy do gateway (logApiUsage só popula api_usage após deploy do container). Enio escolheu "depois — sem pressa".
+- **Codex review** — auto-dispatch via post-push (3x) NÃO retornou resultado local; não incorporado.
+
+## 🔗 Next Steps (priority order)
+1. **Revogar** token `gho_` (GitHub) + chave **OpenAI** morta (401) — ação Enio.
+2. **Redeploy gateway** (INC-PROD-001) → ativa logApiUsage → usage $ real no relatório.
+3. **F2** — MCP read-only (observability/ops/governance) + meta-prompts como tools do agente.
+4. (opcional) corrigir atribuição do `70994fee` / rotacionar token bot exposto.
+
+## 🌐 Environment State
+- Build/typecheck: ✅ (notifier + orchestrator limpos)
+- Tests: notifier verificado e2e (--dry + envio real ao @EGOSin_bot ✅); api_usage smoke ✅
+- Deploy: gateway NÃO redeployado (logApiUsage dormindo); bot live (long-polling healthy)
+- Git: HEAD d9178f9f, sync com origin
+
+## 📌 Decisions Made (architectural)
+- Runtime dono do Telegram = **egos-gateway TS** (hermes = WhatsApp; dividem por canal) — evidência via getWebhookInfo + hermes config.
+- `api_usage` = tabela canônica service-role-only (RLS), populada por logApiUsage em TODA chamada.
+- Crons "os dois" (local + VPS) por decisão Enio.
+- F3 (controle/escrita via Telegram) ADIADO por Enio.
+
+## ✅ Todos da sessão (snapshot)
+- [x] Alibaba investigation + rotação + validação e2e
+- [x] Part A (doctor autenticado + CN→intl + secrets) — e9831cf5
+- [x] Part B plano SSOT — fb24141d
+- [x] F1b api_usage + gateway logging + notifier — 70994fee
+- [x] Crons local + VPS + envio real
+- [ ] Redeploy gateway (Enio: depois)
+- [ ] Codex review incorporado (não retornou)
+
+## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
+- "Usage $ por provider funcionando" — [CONCEPT até redeploy]: tabela+logging prontos mas gateway não redeployado, então api_usage não recebe dados reais ainda.
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
diff --git a/docs/jobs/2026-06-01-pre-commit-pipeline.json b/docs/jobs/2026-06-01-pre-commit-pipeline.json
index 55d5822b..0b5f732a 100644
--- a/docs/jobs/2026-06-01-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -142,5 +142,13 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=bcf19847",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:29:27.473Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=0 sha=8e123152",
+    "repo": "/home/enio/egos"
   }
 ]
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

codex
The functional code changes are coherent: they add canonical `api_usage` logging in the gateway, introduce the corresponding Supabase migration with restrictive RLS, and make env loading in `llm-usage-notify.ts` more robust. I did not identify a concrete regression or blocking bug introduced by this diff.
The functional code changes are coherent: they add canonical `api_usage` logging in the gateway, introduce the corresponding Supabase migration with restrictive RLS, and make env loading in `llm-usage-notify.ts` more robust. I did not identify a concrete regression or blocking bug introduced by this diff.
```
