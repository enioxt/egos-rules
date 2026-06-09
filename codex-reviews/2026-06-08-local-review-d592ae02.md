# Codex Local Review — 2026-06-08T17:12:38Z

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
session id: 019ea838-da23-7d20-833f-47b005902ca2
--------
user
changes against 'HEAD~3'
2026-06-08T17:12:40.068255Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-08T17:12:40.068282Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 07faf96360e94e34cc7a2653bf99bf25f3049601 --stat && git diff 07faf96360e94e34cc7a2653bf99bf25f3049601' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                     |  6 ++--
 .husky/pre-commit                         |  8 ++++++
 AGENTS.md                                 |  3 +-
 TASKS.md                                  | 12 ++++----
 apps/egos-gateway/src/orchestrator.ts     | 32 +++++++++++++++++++--
 apps/egos-landing/public/timeline/rss     |  2 +-
 apps/egos-landing/public/timeline/rss.xml |  2 +-
 docs/knowledge/HARVEST.md                 | 46 +++++++++++++++++++++++++++++--
 docs/strategy/GOW_DEMO_RUNBOOK.md         | 42 ++++++++++++++++++++++++++++
 9 files changed, 137 insertions(+), 16 deletions(-)
diff --git a/.claude/settings.json b/.claude/settings.json
index 8b7be6e1..922bef13 100644
--- a/.claude/settings.json
+++ b/.claude/settings.json
@@ -11,7 +11,6 @@
       "WebSearch",
       "Agent",
       "Skill",
-      "mcp__*",
       "Bash(bash ~/.claude/hooks/context-alarm.sh)",
       "Bash(echo \"EXIT: $?\")",
       "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
@@ -20,7 +19,10 @@
       "Bash(bash scripts/check-skills-drift.sh --fix)",
       "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
       "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
-      "mcp__notebooklm-mcp__studio_delete"
+      "mcp__notebooklm-mcp__studio_delete",
+      "mcp__claude_ai_Supabase__execute_sql",
+      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
+      "mcp__claude_ai_Supabase__list_projects"
     ],
     "deny": [
       "Bash(rm -rf /:*)",
diff --git a/.husky/pre-commit b/.husky/pre-commit
index 6316e682..e9b72f67 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -661,6 +661,14 @@ bash .husky/_checks/5.95-capability-detector.sh 2>/dev/null || true
 echo "  [13/N] registry-parity: scanning staged adds for missing registry entries..."
 bash .husky/_checks/13-registry-parity.sh || exit 1
 
+# 14. Discover Gate — exige CONSULTED-SSOT: no body ao criar nova capability (DISCOVER-GATE-003)
+# Escape: `DISCOVER-GATE-SKIP: <razão>` no commit body ou DISCOVER_GATE_SKIP=<razão> no env
+# SSOT: scripts/discover-capability.ts | R-DISCOVER-001
+if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
+  echo "  [14/N] discover-gate: verificando prova de consulta para nova capability..."
+  bash .husky/_checks/14-discover-gate.sh || exit 1
+fi
+
 # 6. File Intelligence — Classification + Compliance + PII scan
 echo "  [5/5] file intelligence: classifying and checking staged files..."
 bash scripts/file-intelligence.sh 2>/dev/null || {
diff --git a/AGENTS.md b/AGENTS.md
index 496ee253..e3f435df 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -124,9 +124,10 @@ Canonical eval strategy: `docs/knowledge/AI_EVAL_STRATEGY.md` (being written —
 **R9 — Agentic Governance & Scopes (2026-05-30):** agentes seguem escopos/permissões/notificação de [agent_scopes_and_governance.md](docs/governance/agent_scopes_and_governance.md). Out-of-scope → lock `.egos-lock` + escalar Council/HITL (Telegram/WhatsApp). Anti-repetição: checar `TASKS.md` + `git log` antes de planejar.
 
 **R10 — Cooperação e Banda Cognitiva (Guarani ↔ Prime - 2026-06-04):** O Guarani (runtime Antigravity/Gemini) propõe código e correções técnicas, mas NUNCA realiza commits diretamente. Toda alteração de produção proposta pelo Guarani DEVE passar pela revisão final do Prime (Claude Code/Opus). Decisões de segurança crítica, modificações no schema de Banco de Dados, regras de RLS ou arquivos em Frozen Zones exigem obrigatoriamente a invocação da Banda Cognitiva (`/banda`) com Força Total (`--council` acionando Opus/Gemini Pro/GPT-5 via OpenRouter), assegurando verificação estrutural e AST anti-phantom.
-
 **R-SEC-002 [T0] — Dado soberano nunca sai da máquina (INC-PII-001 2026-06-04):** dado real de investigação / PII de terceiros / dado PCMG NUNCA versionado em git (nem privado), NUNCA servido em domínio público, NUNCA em VPS/nuvem. Git = apenas dados sintéticos; dado real = local cifrado. App com dado real → nunca domínio público aberto. Scanner pré-commit: `bun scripts/security/scan-hardcoded-sensitive.ts --staged`.
 **R-SEC-003 [T1] — Segurança = enforcement:** toda regra de segurança DEVE ter gate executável. Scanner sem wiring = doc morto. Sugestão mock/fixture: `// scan-ok: mock` ou `<!-- scan-ok -->`. SSOT: `docs/INCIDENTS/INC-PII-001_investigation-data-leak.md`.
+**R-DISCOVER-001 [T2] — Discover-before-create (2026-06-08):** antes de criar capability nova (package/command/skill/CBC/registry), rodar `bun scripts/discover-capability.ts <termo>` e incluir `CONSULTED-SSOT: <resultado>` no commit body. Gate 14 bloqueia sem prova. Escape: `DISCOVER-GATE-SKIP: <razão>`. Evita INC-009-leaf-silo.
+**R11 [T2] — Observabilidade warn-not-block (2026-06-05):** falha em telemetria/agent-observatory = warn-only, nunca bloqueia execução de agente. SSOT: `docs/governance/MULTI_AGENT_OBSERVABILITY.md`.
 <!-- PROPAGATE-RULES-END -->
 
 ---
diff --git a/TASKS.md b/TASKS.md
index eedc35ed..d978f72d 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -13,10 +13,10 @@
 
 ## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
 > Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
-- [ ] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio.
-- [ ] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto).
-- [ ] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — VERIFICAR ANTES da demo: política Meta/WhatsApp Business restringe uso por segurança/governo; Enio é PCMG. Desenhar como agente de negócio/rotina com escopo declarado, não institucional de segurança. Gate jurídico. SSOT: HERMES_WHATSAPP_USECASE_MAP.md §5.
-- [ ] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medir quantos dos 80 CBCs têm ≥3 golden cases PASSANDO (run_golden_cases). NÃO apresentar "80 CBCs" como maturidade sem esse número. A honestidade é a prova.
+- [x] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio. ✅ 2026-06-08
+- [x] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto). ✅ 2026-06-08
+- [x] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
+- [x] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — MEDIDO ao vivo: 80 CBCs, **9 com golden real**, 57 contrato-sem-teste; harness rodou **mcp-runner 88/93 pass**, bun test 78/82. Frase honesta GOW: "9 MCPs com golden (88/93), resto contrato-pendente; infra existe, gap é preenchimento". 4 falhas metaprompts (MP-PRICE/MP-MATERIAL falta red-zone) = fix simples futuro.
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
@@ -66,7 +66,7 @@
 - [ ] **GLOBAL-USER-PATTERN-001** [P2] `curador` `gated:HITL` — Plano de análise do padrão GLOBAL do usuário (commits + tasks + /start + /end + provenance + telemetria + Mycelium), não só por área. Classificar REAL/PATTERN/HYPOTHESIS/QUESTION/UNKNOWN. Sem psicologizar sem evidência. `docs/research/user-patterns/global-pattern-analysis-plan.md`. NÃO executar análise invasiva sem HITL.
 
 **Privacidade radical — ingestão WhatsApp (P0 política ANTES de qualquer ingest):**
-- [ ] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio.
+- [x] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio. ✅ 2026-06-08
 - [ ] **CONCEPT-ATOMIZATION-MODEL-001** [P1] `curador` `gated:WA-PRIVACY-POLICY-001` — Modelo de atomização: vivido → remove identificável → reconstrói conhecimento útil sem dado pessoal. `docs/architecture/concept-atoms.md`. Exemplo: "João me disse em Patos..." → "pessoa próxima relatou situação de confiança/frustração em contexto social".
 - [ ] **PROV-TELEM-MYCELIUM-MAP-001** [P2] `prime` — Mapa de como provenance/telemetria/Mycelium/start/end/pre-commit/commits entram na arquitetura de autodescoberta com privacidade (fonte/tipo/risco/tratamento/uso permitido/uso proibido/retenção/HITL). `docs/architecture/provenance-telemetry-mycelium-integration.md`.
 - [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
@@ -883,7 +883,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
 - [ ] **DISCOVER-GATE-004** [P2] `sentinela` — Auto-consulta periódica (cron + Layer `/start` reportando drift de registry via `gen-registry-parity-counts.ts`).
-- [ ] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar.
+- [x] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar. ✅ 2026-06-08
 
 ---
 
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index deb06b9d..961f95e9 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -814,7 +814,7 @@ const TOOL_DEFS = [
         type: "object",
         properties: {
           title: { type: "string", description: "Título do evento" },
-          date: { type: "string", description: "Data e hora (ISO 8601, ex: 2026-04-25T14:00:00-03:00)" },
+          date: { type: "string", description: "Data e hora (ISO 8601, ex: 2026-04-25T14:00:00-03:00)" }, // scan-ok: mock (exemplo de data, não placa)
           duration_minutes: { type: "number", description: "Duração em minutos (padrão: 60)" },
           description: { type: "string", description: "Descrição do evento" },
         },
@@ -887,7 +887,7 @@ async function toolNotifyHuman(message: string, urgency: string = "medium"): Pro
   const evolutionBase = process.env.EVOLUTION_API_URL ?? "http://localhost:8080";
   const evolutionKey = process.env.EVOLUTION_API_KEY ?? "";
   const instance = process.env.EVOLUTION_INSTANCE ?? "egos-consulting";
-  const adminPhone = process.env.WA_ADMIN_NUMBER ?? "553492374363";
+  const adminPhone = process.env.WA_ADMIN_NUMBER ?? ""; // R-SEC-002: número via env, nunca hardcoded
   const icon = urgency === "high" ? "🚨" : urgency === "low" ? "ℹ️" : "⚠️";
   const text = `${icon} *[Notificação do Agente]*\n\n${message}\n\n_Urgência: ${urgency}_`;
   try {
@@ -1414,6 +1414,32 @@ function formatForChannel(text: string, channel: Channel): string {
   return text.slice(0, 2000);
 }
 
+// ─── Evidence footer (GOW-EVIDENCE-CHAIN-001 / gap#3) ───────────────────────────
+// Torna a evidence-chain VISÍVEL: mostra quais ferramentas (fontes) fundamentaram
+// a resposta + a postura de governança. Gated por env EGOS_EVIDENCE_FOOTER (off por
+// padrão → g-pecas/produção NÃO muda; on p/ demo GOW). Karpathy: mínimo, opt-in.
+const TOOL_EVIDENCE_LABELS: Record<string, string> = {
+  search_g_pecas_products: "catálogo de produtos",
+  search_products: "catálogo de produtos",
+  search_faq_entries: "base de perguntas (FAQ)",
+  search_faq: "base de perguntas (FAQ)",
+  kb_search_client: "base de conhecimento do cliente",
+  wiki: "base de conhecimento",
+  guard_test: "verificação de dados sensíveis (Guard Brasil)",
+  calendar: "agenda",
+  gmail: "e-mail",
+  notify_human: "encaminhamento para um atendente humano",
+};
+
+function buildEvidenceFooter(toolsUsed: string[], channel: Channel): string {
+  if (!process.env.EGOS_EVIDENCE_FOOTER) return "";
+  if (!toolsUsed.length) return "";
+  const labels = Array.from(new Set(toolsUsed.map((t) => TOOL_EVIDENCE_LABELS[t] ?? t)));
+  const sep = channel === "whatsapp" ? "\n\n———\n" : "\n\n———\n";
+  const bold = (s: string) => (channel === "whatsapp" ? `*${s}*` : `*${s}*`);
+  return `${sep}${bold("🔎 Evidência")}: esta resposta consultou ${labels.join(", ")}. Decisão final é sua; confira o que for importante.`;
+}
+
 // ─── System prompt ────────────────────────────────────────────────────────────
 
 // ─── Karpathy Doctrine — Banned Absolutes (A53) ──────────────────────────────
@@ -1660,7 +1686,7 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
     if (finish_reason === "stop" || !message.tool_calls?.length) {
       const raw = message.content ?? "Sem resposta.";
       const verified = client?.slug ? await verifyCitations(raw, client.slug) : raw;
-      const formatted = formatForChannel(verified, msg.channel);
+      const formatted = formatForChannel(verified, msg.channel) + buildEvidenceFooter(toolsUsed, msg.channel);
       // Persist conversation turn + token log (non-blocking)
       saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
       if (data.usage?.prompt_tokens) {
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
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
 
diff --git a/docs/strategy/GOW_DEMO_RUNBOOK.md b/docs/strategy/GOW_DEMO_RUNBOOK.md
new file mode 100644
index 00000000..461a82d7
--- /dev/null
+++ b/docs/strategy/GOW_DEMO_RUNBOOK.md
@@ -0,0 +1,42 @@
+# GOW — Runbook da Demo (20 min) — o que JÁ existe, com provas
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT — corte Enio + compliance gate antes de rodar.
+**Princípio (Codex+Banda):** demo com o que JÁ funciona em produção. Zero construção nova. Não apresentar Diagnostic Protocol como produto.
+
+## PRÉ-VOO (antes de chamar a GOW)
+1. 🔴 **Compliance gate** (`GOW-COMPLIANCE-META-PCMG-001`): demo = **agente de NEGÓCIO/rotina com escopo declarado** (tool calls), NÃO chat aberto, NÃO conteúdo investigativo/PII (ativaria categoria "Law Enforcement" da Meta). Evolution API só p/ demo interna; produção = Cloud API oficial. Pitch menciona o path oficial. (Vento a favor: Meta lançou Business Agent jun/2026.)
+2. **Ligar a evidência:** no gateway, `EGOS_EVIDENCE_FOOTER=1` (env) → a resposta passa a mostrar as fontes. (Off em produção normal.) Deploy = HITL.
+3. **Conferir golden cases:** `bun packages/eval-runner/src/mcp-runner.ts --all` deve dar ~88/93 pass.
+
+## A DEMO (roteiro)
+**[1 · O problema — 2min]** "Todo mundo usa IA, mas no escuro: ela inventa e pode vazar dado. Vou mostrar um agente que prova o que faz."
+
+**[2 · O fluxo ao vivo — 6min]** Manda uma mensagem no WhatsApp (tenant g-pecas, que JÁ roda): ex. "tem pastilha de freio pra Gol 2015?". O agente:
+- consulta o catálogo (tool call real, RAG Supabase),
+- responde,
+- **mostra a evidência** no rodapé: *"🔎 Evidência: esta resposta consultou catálogo de produtos. Decisão final é sua."* ← isto é a governança verificável (gap#3, `d592ae02`).
+- Mostra que se pedir dado sensível, o Guard Brasil mascara (tool guard_test).
+
+**[3 · A prova comportamental — 6min]** Roda golden cases AO VIVO: `mcp-runner --all`. Mostra **88 de 93 casos passando** nos 9 MCPs. Explica: "não é teste unitário — é prova de COMPORTAMENTO: a capacidade só conta como real se passa ≥3 golden cases (regra R7). Se o código fosse stub, o caso falharia."
+- **Número HONESTO (não inflar):** "9 MCPs com cobertura de prova rodando; os outros têm o contrato escrito, teste pendente. A infraestrutura existe e funciona; o gap é de preenchimento, não de arquitetura."
+
+**[4 · A telemetria — 3min]** Mostra que cada chamada de LLM é registrada (`api_usage`: modelo, tokens, custo). "Tudo auditável — você vê o que aconteceu."
+
+**[5 · O fecho — 3min]** "Isso roda hoje. O que eu construo PRA VOCÊS é o mesmo motor, com escopo da GOW, integrações que vocês precisam, e governança no núcleo. Não vendo IA mágica — vendo IA que prova."
+
+## O QUE NÃO MOSTRAR (Codex)
+- ❌ Diagnostic Protocol como produto (rascunho interno).
+- ❌ Dashboards que ainda não existem.
+- ❌ "80 CBCs" como maturidade (use o número honesto).
+- ❌ Qualquer cena investigativa/PII de terceiro (Red Zone Meta).
+
+## O FECHO REAL — as 3 perguntas (responder ANTES, decidem se vale)
+1. Depois da demo, que decisão a GOW toma? (paga piloto / indica cliente / só elogia?)
+2. Que parte provou valor com o que JÁ existe? (resposta: o fluxo + golden cases + telemetria — tudo pronto)
+3. Se a GOW não pagar, o que de A (GPT/comunidade) segue igual amanhã? (resposta: tudo — A não depende de B)
+
+## EVIDÊNCIAS (commits, p/ honestidade)
+- gap#3 evidence footer: `d592ae02` (env-gated, typecheck ok, testado)
+- mapa de arquitetura: `HERMES_WHATSAPP_USECASE_MAP.md`
+- cobertura medida: 9/80 CBCs com golden real, 88/93 cases pass (mcp-runner)
+- compliance: COMPLIANT com condições (ver `project_gow_b2b_vs_b2c_diagnostic` memory)

exec
/bin/bash -lc "sed -n '1600,1715p' apps/egos-gateway/src/orchestrator.ts && sed -n '820,920p' apps/egos-gateway/src/orchestrator.ts && sed -n '1,140p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
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
      const raw = message.content ?? "Sem resposta.";
      const verified = client?.slug ? await verifyCitations(raw, client.slug) : raw;
      const formatted = formatForChannel(verified, msg.channel) + buildEvidenceFooter(toolsUsed, msg.channel);
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
        },
        required: ["title", "date"],
      },
    },
  },
  {
    type: "function" as const,
    function: {
      name: "notify_human",
      description: "Envia uma notificação urgente para o Enio (admin) via WhatsApp. Use quando: lead qualificado encontrado, cliente precisa de suporte humano urgente, erro crítico, ou solicitação que exige ação humana.",
      parameters: {
        type: "object",
        properties: {
          message: { type: "string", description: "Mensagem para o Enio (inclua contexto: quem é, o que precisa, urgência)" },
          urgency: { type: "string", enum: ["low", "medium", "high"], description: "Nível de urgência (padrão: medium)" },
        },
        required: ["message"],
      },
    },
  },
  {
    type: "function" as const,
    function: {
      name: "search_products",
      description: "BUSCA produtos REAIS no catálogo da loja deste tenant. USE ESTA TOOL antes de afirmar qualquer disponibilidade, preço, marca, estoque ou condição. NUNCA invente produtos. Use somente quando cliente perguntar sobre algo específico (ex: 'tem geladeira?', 'quanto custa air fryer?', 'tem motor consul 220v?'). Não use para perguntas genéricas ou conversa social. ATENÇÃO: se a pergunta for sobre compatibilidade ('serve?', 'encaixa?', 'é compatível?'), só use para sugerir opções DEPOIS que o cliente informar o modelo completo do equipamento ou enviar foto da etiqueta técnica. Sem isso, não confirme compatibilidade.",
      parameters: {
        type: "object",
        properties: {
          query: { type: "string", description: "Termo de busca em português (ex: 'geladeira 300L', 'motor consul', 'air fryer')" },
          max_price: { type: "number", description: "Filtro opcional de preço máximo em R$ (ex: 1500)" },
          condition: { type: "string", enum: ["novo", "usado"], description: "Filtro opcional: 'novo' ou 'usado'" },
        },
        required: ["query"],
      },
    },
  },
  {
    type: "function" as const,
    function: {
      name: "search_faq",
      description: "BUSCA na FAQ da loja sobre política operacional (horário, formas de pagamento, frete, garantia, troca, instalação, usado vs novo, desconto, contato, endereço). USE ESTA TOOL antes de inferir qualquer informação operacional. NUNCA invente política. Categorias: horario, pagamento, entrega, garantia, troca_devolucao, instalacao, usado_vs_novo, desconto, contato, localizacao.",
      parameters: {
        type: "object",
        properties: {
          query: { type: "string", description: "Pergunta do cliente em português (ex: 'horário', 'forma de pagamento', 'tem frete?')" },
        },
        required: ["query"],
      },
    },
  },
];

// Tool subset por tenant — tenants de loja (g-pecas, ferro-velho-patense) não veem
// kb_search_client nem gmail/calendar. Sem isso o LLM escolhia ferramentas erradas.
// SSOT do filtro: aqui. Adicionar novo tenant de loja = adicionar ao Set abaixo.
const STOREFRONT_TENANTS = new Set(["g-pecas", "ferro-velho-patense"]);
function toolsForTenant(slug: string | undefined): typeof TOOL_DEFS {
  if (slug && STOREFRONT_TENANTS.has(slug)) {
    const allow = new Set(["search_products", "search_faq", "notify_human"]);
    return TOOL_DEFS.filter(t => allow.has(t.function.name));
  }
  return TOOL_DEFS;
}

// ─── Tool dispatcher ──────────────────────────────────────────────────────────

async function toolNotifyHuman(message: string, urgency: string = "medium"): Promise<string> {
  const evolutionBase = process.env.EVOLUTION_API_URL ?? "http://localhost:8080";
  const evolutionKey = process.env.EVOLUTION_API_KEY ?? "";
  const instance = process.env.EVOLUTION_INSTANCE ?? "egos-consulting";
  const adminPhone = process.env.WA_ADMIN_NUMBER ?? ""; // R-SEC-002: número via env, nunca hardcoded
  const icon = urgency === "high" ? "🚨" : urgency === "low" ? "ℹ️" : "⚠️";
  const text = `${icon} *[Notificação do Agente]*\n\n${message}\n\n_Urgência: ${urgency}_`;
  try {
    const res = await fetch(`${evolutionBase}/message/sendText/${instance}`, {
      method: "POST",
      headers: { "Content-Type": "application/json", apikey: evolutionKey },
      body: JSON.stringify({ number: adminPhone, text }),
      signal: AbortSignal.timeout(10000),
    });
    if (!res.ok) return `Erro ao notificar admin: ${res.status}`;
    return "✅ Enio foi notificado. Ele responderá em breve.";
  } catch (e) {
    return `Erro ao notificar admin: ${(e as Error).message}`;
  }
}

async function toolKbSearchClient(query: string, clientSlug?: string, kbAccess?: string[]): Promise<string> {
  if (!clientSlug) return "Nenhum cliente ativo. Use /cliente SLUG para selecionar.";
  if (!SUPABASE_URL || !SUPABASE_KEY) return "KB indisponível (Supabase não configurado).";

  type KbRow = { id?: number; title?: string; content?: string; source_url?: string; quality_score?: number; rrf_score?: number; updated_at?: string };

  // ── Hybrid search via match_kb_hybrid RPC (RATIO-ABSORB-001) ──────────────
  try {
    const rpcBody = {
      query_text: query,
      query_embedding: null, // embedding generation deferred; enables FTS-only path
      tenant_slug: clientSlug,
      match_count: 5,
      k: 60,
/**
 * EGOS Gateway — AI Orchestrator v2
 *
 * Shared LLM orchestration for WhatsApp + Telegram chatbots.
 * Model: google/gemini-2.0-flash-001 (OpenRouter)
 * Transcription: Groq Whisper-large-v3-turbo
 * Vision: google/gemini-2.0-flash-001 (multimodal)
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

const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";

/**
 * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
 *
 * Default: gemini-2.0-flash-001 via OpenRouter (PT-BR nativo, tool-calling sólido,
 * multimodal nativo).
 *
 * Override: setar CHATBOT_PRIMARY_MODEL no .env do gateway.
 *
 * Fallback chain: primary → fallback (último recurso).
 */
interface LLMProvider {
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
    });
    return res.ok ? res.json() : null;
  } catch {
    return null;
  }
}

async function sbInsert(table: string, row: Record<string, unknown>): Promise<boolean> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return false;
  try {

exec
/bin/bash -lc 'grep -n "function formatForChannel" -A30 apps/egos-gateway/src/orchestrator.ts && grep -n "toolsUsed" -n apps/egos-gateway/src/orchestrator.ts | head -20' in /home/enio/egos
 succeeded in 0ms:
1402:function formatForChannel(text: string, channel: Channel): string {
1403-  if (channel === "whatsapp") {
1404-    // WhatsApp uses *bold*, _italic_, ~strikethrough~, `mono`
1405-    // Remove markdown headers (##) and convert to bold
1406-    return text
1407-      .replace(/^#{1,3}\s+(.+)$/gm, "*$1*")
1408-      .replace(/\*\*(.+?)\*\*/g, "*$1*")
1409-      .replace(/__(.+?)__/g, "_$1_")
1410-      // Limit to 1500 chars for WhatsApp
1411-      .slice(0, 1500);
1412-  }
1413-  // Telegram: already using * for bold — keep as is, just limit length
1414-  return text.slice(0, 2000);
1415-}
1416-
1417-// ─── Evidence footer (GOW-EVIDENCE-CHAIN-001 / gap#3) ───────────────────────────
1418-// Torna a evidence-chain VISÍVEL: mostra quais ferramentas (fontes) fundamentaram
1419-// a resposta + a postura de governança. Gated por env EGOS_EVIDENCE_FOOTER (off por
1420-// padrão → g-pecas/produção NÃO muda; on p/ demo GOW). Karpathy: mínimo, opt-in.
1421-const TOOL_EVIDENCE_LABELS: Record<string, string> = {
1422-  search_g_pecas_products: "catálogo de produtos",
1423-  search_products: "catálogo de produtos",
1424-  search_faq_entries: "base de perguntas (FAQ)",
1425-  search_faq: "base de perguntas (FAQ)",
1426-  kb_search_client: "base de conhecimento do cliente",
1427-  wiki: "base de conhecimento",
1428-  guard_test: "verificação de dados sensíveis (Guard Brasil)",
1429-  calendar: "agenda",
1430-  gmail: "e-mail",
1431-  notify_human: "encaminhamento para um atendente humano",
1432-};
97:  toolsUsed?: string[];
179:  toolsUsed: string[],
198:    tools_used: toolsUsed,
1434:function buildEvidenceFooter(toolsUsed: string[], channel: Channel): string {
1436:  if (!toolsUsed.length) return "";
1437:  const labels = Array.from(new Set(toolsUsed.map((t) => TOOL_EVIDENCE_LABELS[t] ?? t)));
1573:  const toolsUsed: string[] = [];
1580:    toolsUsed.push("whisper");
1585:    toolsUsed.push("qwen-vl");
1672:      return { text: "❌ Erro no AI. Tente novamente.", toolsUsed };
1689:      const formatted = formatForChannel(verified, msg.channel) + buildEvidenceFooter(toolsUsed, msg.channel);
1691:      saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
1696:      return { text: formatted, toolsUsed };
1709:      toolsUsed.push(tc.function.name);
1716:  saveHistory(msg.channel, msg.from, userText, fallback, toolsUsed, msg.mediaType).catch(() => {});
1717:  return { text: fallback, toolsUsed };

exec
/bin/bash -lc 'ls -l .husky/_checks/14-discover-gate.sh || true; git ls-files .husky/_checks/14-discover-gate.sh; git status --short' in /home/enio/egos
 succeeded in 0ms:
-rwxrwxr-x 1 enio enio 4021 Jun  8 13:50 .husky/_checks/14-discover-gate.sh
.husky/_checks/14-discover-gate.sh
 M .claude/settings.json
M  TASKS.md
 M apps/egos-landing/public/timeline/rss
 M apps/egos-landing/public/timeline/rss.xml
 M docs/knowledge/HARVEST.md
A  docs/strategy/GOW_DEMO_RUNBOOK.md
?? docs/jobs/2026-06-07-doc-drift-verifier.json
?? docs/jobs/2026-06-07-pre-commit-pipeline.json
?? docs/jobs/2026-06-08-doc-drift-verifier.json
?? docs/jobs/2026-06-08-pre-commit-pipeline.json
?? docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md
?? docs/strategy/landing-copy-v2-pessoa-comum.md

exec
/bin/bash -lc "grep -n \"case \\|function dispatchTool\\|async function dispatchTool\" -A90 apps/egos-gateway/src/orchestrator.ts | sed -n '1,140p'" in /home/enio/egos
 succeeded in 0ms:
1127:async function dispatchTool(
1128-  name: string,
1129-  args: Record<string, unknown>,
1130-  ctx: { channel: Channel; userId: string; clientSlug?: string; kbAccess?: string[] },
1131-): Promise<string> {
1132-  switch (name) {
1133:    case "system_status":    return toolSystemStatus();
1134:    case "guard_status":     return toolGuardStatus();
1135:    case "guard_test":       return toolGuardTest(args.text as string ?? "");
1136:    case "gem_search":       return toolGemSearch(args.query as string ?? "", args.sector as string | undefined);
1137:    case "gem_trending":     return toolGemTrending();
1138:    case "wiki_search":      return toolWikiSearch(args.query as string ?? "");
1139:    case "wiki_page":        return toolWikiPage(args.slug as string ?? "");
1140:    case "list_agents":      return toolListAgents();
1141:    case "get_tasks":        return toolGetTasks((args.filter as "p0" | "p1" | "all") ?? "p0");
1142:    case "recent_commits":   return toolRecentCommits(Number(args.limit ?? 7));
1143:    case "get_costs":        return toolGetCosts();
1144:    case "knowledge_stats":  return toolKnowledgeStats();
1145:    case "world_model":      return toolWorldModel();
1146:    case "memory_search":    return toolMemorySearch(args.query as string ?? "", ctx.channel, ctx.userId);
1147:    case "notify_human":     return toolNotifyHuman(args.message as string ?? "", args.urgency as string | undefined);
1148:    case "kb_search_client": return toolKbSearchClient(args.query as string ?? "", ctx.clientSlug, ctx.kbAccess);
1149:    case "gmail_search":     return toolGmailSearch(args.query as string ?? "", Number(args.max_results ?? 5), ctx.clientSlug);
1150:    case "gmail_send":       return toolGmailSend(args.to as string ?? "", args.subject as string ?? "", args.body as string ?? "", ctx.clientSlug);
1151:    case "calendar_list":    return toolCalendarList(Number(args.days_ahead ?? 7), args.query as string | undefined, ctx.clientSlug);
1152:    case "calendar_create":  return toolCalendarCreate(args.title as string ?? "", args.date as string ?? "", Number(args.duration_minutes ?? 60), args.description as string | undefined, ctx.clientSlug);
1153-    // Aliases novos (genéricos) + legados (backward compat — LLMs em sessões antigas podem chamar nomes velhos)
1154:    case "search_products":        return toolSearchGPecasProducts(args.query as string ?? "", args.max_price as number | undefined, args.condition as string | undefined, ctx.clientSlug);
1155:    case "search_faq":             return toolSearchGPecasFaq(args.query as string ?? "", ctx.clientSlug);
1156:    case "search_gpecas_products": return toolSearchGPecasProducts(args.query as string ?? "", args.max_price as number | undefined, args.condition as string | undefined, ctx.clientSlug);
1157:    case "search_gpecas_faq":      return toolSearchGPecasFaq(args.query as string ?? "", ctx.clientSlug);
1158-    default:                 return `Ferramenta "${name}" não reconhecida.`;
1159-  }
1160-}
1161-
1162-/**
1163- * Tool: search_gpecas_faq — FAQ KB (CHAT-RAG-FAQ-001, 2026-05-13)
1164- *
1165- * Anti-hallucination R3: bot consulta política real antes de afirmar
1166- * horário, pagamento, frete, garantia, etc.
1167- *
1168- * CET-DB-FAQ-001 (2026-05-18): usa search_faq_entries (canônico multi-tenant)
1169- * com fallback para search_g_pecas_faq (legado G Peças).
1170- */
1171-async function toolSearchGPecasFaq(query: string, tenantSlug = "g-pecas"): Promise<string> {
1172-  if (!SUPABASE_URL || !SUPABASE_KEY) return "[FAQ não configurada]";
1173-  if (!query) return "Query obrigatória — me diga sobre o que quer informação";
1174-  try {
1175-    // Canônico: search_faq_entries (multi-tenant, por slug)
1176-    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/search_faq_entries`, {
1177-      method: "POST",
1178-      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json" },
1179-      body: JSON.stringify({ p_tenant_slug: tenantSlug, query_text: query, max_results: 3 }),
1180-      signal: AbortSignal.timeout(5000),
1181-    });
1182-    if (res.ok) {
1183-      const faqs = await res.json() as Array<{ id: string; question: string; answer: string }>;
1184-      if (faqs.length > 0) {
1185-        const lines = faqs.map(f => `P: ${f.question}\nR: ${f.answer}`);
1186-        return `FAQ (use como verdade canonical):\n\n${lines.join("\n\n")}`;
1187-      }
1188-    }
1189-    // Fallback: search_g_pecas_faq (legado — apenas G Peças)
1190-    if (tenantSlug === "g-pecas") {
1191-      const fallback = await fetch(`${SUPABASE_URL}/rest/v1/rpc/search_g_pecas_faq`, {
1192-        method: "POST",
1193-        headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json" },
1194-        body: JSON.stringify({ query_text: query, max_results: 3 }),
1195-        signal: AbortSignal.timeout(5000),
1196-      });
1197-      if (fallback.ok) {
1198-        const faqs = await fallback.json() as Array<{ question: string; answer: string; category: string }>;
1199-        if (faqs.length > 0) {
1200-          const lines = faqs.map(f => `[${f.category}] P: ${f.question}\nR: ${f.answer}`);
1201-          return `FAQ encontrada:\n\n${lines.join("\n\n")}`;
1202-        }
1203-      }
1204-    }
1205-    return `Nenhuma FAQ encontrada para "${query}". Encaminhar para equipe via /humano.`;
1206-  } catch (e) {
1207-    return `Erro consultando FAQ: ${(e as Error).message}`;
1208-  }
1209-}
1210-
1211-/**
1212- * Tool: search_gpecas_products — RAG do catálogo real (CHAT-RAG-001, 2026-05-13)
1213- *
1214- * Rota por tenant:
1215- *  - g-pecas: RPC search_g_pecas_products (prefixed-table, legado)
1216- *  - outros storefronts: RPC search_products(p_tenant_slug, ...) (neutral-table, GATEWAY-TENANT-FIX-001)
1217- *
1218- * Filtros opcionais: max_price (R$), condition ('novo' | 'usado').
1219- */
1220-async function toolSearchGPecasProducts(
1221-  query: string,
1222-  maxPrice?: number,
1223-  condition?: string,
1224-  tenantSlug?: string,
1225-): Promise<string> {
1226-  const compatibilityIntent = /\b(compat[ií]vel|compatibilidade|serve|encaixa|funciona no meu|funciona em|d[aá] certo no|d[aá] certo em|serve no|serve na|serve pra|serve para|peça certa|modelo completo)\b/i.test(query);
1227-  const fullModelIdentifier = /\b(?:modelo|mod\.?|part(?:\s|-)?number|p\/n|pn)?\s*[A-Z]{1,5}[0-9]{2,}[A-Z0-9-]*\b/i.test(query);
1228-  if (compatibilityIntent && !fullModelIdentifier) {
1229-    return "Para confirmar compatibilidade, preciso do modelo completo do equipamento ou uma foto da etiqueta técnica. Assim evito indicar uma peça incompatível.";
1230-  }
1231-  if (!SUPABASE_URL || !SUPABASE_KEY) return "[Catálogo não configurado]";
1232-  if (!query) return "Query obrigatória — me diga o que procura (ex: 'geladeira 300L')";
1233-
1234-  // Roteamento por tenant: g-pecas usa tabela prefixada; demais usam tabela neutra.
1235-  const slug = tenantSlug ?? "g-pecas";
1236-  const useGenericRpc = slug !== "g-pecas";
1237-  const rpcEndpoint = useGenericRpc ? "search_products" : "search_g_pecas_products";
1238-  const rpcBody = useGenericRpc
1239-    ? JSON.stringify({ p_tenant_slug: slug, query_text: query, max_results: 8 })
1240-    : JSON.stringify({ query_text: query, max_results: 8 });
1241-
1242-  try {
1243-    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/${rpcEndpoint}`, {
1244-      method: "POST",
1245-      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json" },
1246-      body: rpcBody,
1247-      signal: AbortSignal.timeout(5000),

exec
/bin/bash -lc "nl -ba apps/egos-gateway/src/orchestrator.ts | sed -n '1428,1442p;1684,1691p;884,900p'" in /home/enio/egos
 succeeded in 0ms:
   884	// ─── Tool dispatcher ──────────────────────────────────────────────────────────
   885	
   886	async function toolNotifyHuman(message: string, urgency: string = "medium"): Promise<string> {
   887	  const evolutionBase = process.env.EVOLUTION_API_URL ?? "http://localhost:8080";
   888	  const evolutionKey = process.env.EVOLUTION_API_KEY ?? "";
   889	  const instance = process.env.EVOLUTION_INSTANCE ?? "egos-consulting";
   890	  const adminPhone = process.env.WA_ADMIN_NUMBER ?? ""; // R-SEC-002: número via env, nunca hardcoded
   891	  const icon = urgency === "high" ? "🚨" : urgency === "low" ? "ℹ️" : "⚠️";
   892	  const text = `${icon} *[Notificação do Agente]*\n\n${message}\n\n_Urgência: ${urgency}_`;
   893	  try {
   894	    const res = await fetch(`${evolutionBase}/message/sendText/${instance}`, {
   895	      method: "POST",
   896	      headers: { "Content-Type": "application/json", apikey: evolutionKey },
   897	      body: JSON.stringify({ number: adminPhone, text }),
   898	      signal: AbortSignal.timeout(10000),
   899	    });
   900	    if (!res.ok) return `Erro ao notificar admin: ${res.status}`;
  1428	  guard_test: "verificação de dados sensíveis (Guard Brasil)",
  1429	  calendar: "agenda",
  1430	  gmail: "e-mail",
  1431	  notify_human: "encaminhamento para um atendente humano",
  1432	};
  1433	
  1434	function buildEvidenceFooter(toolsUsed: string[], channel: Channel): string {
  1435	  if (!process.env.EGOS_EVIDENCE_FOOTER) return "";
  1436	  if (!toolsUsed.length) return "";
  1437	  const labels = Array.from(new Set(toolsUsed.map((t) => TOOL_EVIDENCE_LABELS[t] ?? t)));
  1438	  const sep = channel === "whatsapp" ? "\n\n———\n" : "\n\n———\n";
  1439	  const bold = (s: string) => (channel === "whatsapp" ? `*${s}*` : `*${s}*`);
  1440	  return `${sep}${bold("🔎 Evidência")}: esta resposta consultou ${labels.join(", ")}. Decisão final é sua; confira o que for importante.`;
  1441	}
  1442	
  1684	    const { finish_reason, message } = choice;
  1685	
  1686	    if (finish_reason === "stop" || !message.tool_calls?.length) {
  1687	      const raw = message.content ?? "Sem resposta.";
  1688	      const verified = client?.slug ? await verifyCitations(raw, client.slug) : raw;
  1689	      const formatted = formatForChannel(verified, msg.channel) + buildEvidenceFooter(toolsUsed, msg.channel);
  1690	      // Persist conversation turn + token log (non-blocking)
  1691	      saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});

codex
The evidence footer feature can be unintentionally enabled by false-like env values, and removing the admin phone fallback can break human escalation when the new required env var is missing. These are runtime issues that should be addressed before considering the patch correct.

Full review comments:

- [P2] Require explicit opt-in for evidence footer — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1435-1435
  When `EGOS_EVIDENCE_FOOTER` is set to common false-like values such as `0` or `false`, this check still enables the footer because environment variables are strings. In production environments that template the variable as disabled, this would unexpectedly change customer-facing responses; prefer checking for an explicit enabled value like `"1"` or `"true"`.

- [P2] Fail clearly when admin phone is not configured — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:890-890
  With the hardcoded fallback removed, any deployment that has not set `WA_ADMIN_NUMBER` now sends `number: ""` to Evolution and the `notify_human` handoff path will fail at runtime. Since this tool is used for urgent human escalation, add an explicit config check or deployment requirement so missing configuration is surfaced before attempting the request.
The evidence footer feature can be unintentionally enabled by false-like env values, and removing the admin phone fallback can break human escalation when the new required env var is missing. These are runtime issues that should be addressed before considering the patch correct.

Full review comments:

- [P2] Require explicit opt-in for evidence footer — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1435-1435
  When `EGOS_EVIDENCE_FOOTER` is set to common false-like values such as `0` or `false`, this check still enables the footer because environment variables are strings. In production environments that template the variable as disabled, this would unexpectedly change customer-facing responses; prefer checking for an explicit enabled value like `"1"` or `"true"`.

- [P2] Fail clearly when admin phone is not configured — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:890-890
  With the hardcoded fallback removed, any deployment that has not set `WA_ADMIN_NUMBER` now sends `number: ""` to Evolution and the `notify_human` handoff path will fail at runtime. Since this tool is used for urgent human escalation, add an explicit config check or deployment requirement so missing configuration is surfaced before attempting the request.
```
