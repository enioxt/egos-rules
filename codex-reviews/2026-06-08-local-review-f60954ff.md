# Codex Local Review — 2026-06-08T17:51:25Z

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
session id: 019ea85c-5e0a-71f0-8281-95fe9b44f4e6
--------
user
changes against 'HEAD~3'
2026-06-08T17:51:27.292048Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-08T17:51:27.292048Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 4e22addec81a6593261b99237c5ae3178b4931ae --stat && git diff 4e22addec81a6593261b99237c5ae3178b4931ae' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                        |  6 ++--
 TASKS.md                                     | 10 +++---
 TASKS_ARCHIVE.md                             | 13 ++++++++
 apps/egos-gateway/src/orchestrator.ts        | 32 +++++++++++++++++--
 apps/egos-landing/public/timeline/rss        |  2 +-
 apps/egos-landing/public/timeline/rss.xml    |  2 +-
 docs/_current_handoffs/handoff_2026-06-08.md | 43 ++++++++++++++++++++++++++
 docs/knowledge/HARVEST.md                    | 46 ++++++++++++++++++++++++++--
 docs/strategy/GOW_DEMO_RUNBOOK.md            | 42 +++++++++++++++++++++++++
 9 files changed, 181 insertions(+), 15 deletions(-)
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
diff --git a/TASKS.md b/TASKS.md
index eedc35ed..7300c110 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -13,10 +13,10 @@
 
 ## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
 > Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
-- [ ] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio.
-- [ ] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto).
-- [ ] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — VERIFICAR ANTES da demo: política Meta/WhatsApp Business restringe uso por segurança/governo; Enio é PCMG. Desenhar como agente de negócio/rotina com escopo declarado, não institucional de segurança. Gate jurídico. SSOT: HERMES_WHATSAPP_USECASE_MAP.md §5.
-- [ ] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medir quantos dos 80 CBCs têm ≥3 golden cases PASSANDO (run_golden_cases). NÃO apresentar "80 CBCs" como maturidade sem esse número. A honestidade é a prova.
+- [/] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — pesquisa feita, aplicar no design da demo. PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
+- [/] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medição feita; falta preencher os 57 golden ausentes. MEDIDO ao vivo: 80 CBCs, **9 com golden real**, 57 contrato-sem-teste; harness rodou **mcp-runner 88/93 pass**, bun test 78/82. Frase honesta GOW: "9 MCPs com golden (88/93), resto contrato-pendente; infra existe, gap é preenchimento". 4 falhas metaprompts (MP-PRICE/MP-MATERIAL falta red-zone) = fix simples futuro.
+> Anti-atropelo (deferidas, sprint GOW — não fazer antes da demo): Diagnostic Protocol = PAUSADO (docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md, risco segurança/loop — Codex). 3 dashboards de observabilidade = deferido (dados existem: api_usage/mcp_audit/egos_agent_events; só após GOW validar). NotebookLM slides+vídeo do sistema = deferido. Distribuição egos-mcp/repo-por-cliente (Enio) = ideia registrada, pós-validação. Wire dos gaps #1(guard pré-LLM)/#2(evidence sempre)/#4(Hermes-L2) = só se GOW pagar.
+- [ ] **GOW-METAPROMPT-EVAL-FIX-001** [P2] `voz` — 4 golden cases falhando (MP-PRICE-001-005, MP-MATERIAL-EVAL-001 em packages/eval-runner/evals/metaprompts): falta seção "red zone" + nota anti-cópia-cega nesses .md. Fix simples → sobe a cobertura de prova (relevante p/ honestidade GOW).
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
@@ -66,7 +66,6 @@
 - [ ] **GLOBAL-USER-PATTERN-001** [P2] `curador` `gated:HITL` — Plano de análise do padrão GLOBAL do usuário (commits + tasks + /start + /end + provenance + telemetria + Mycelium), não só por área. Classificar REAL/PATTERN/HYPOTHESIS/QUESTION/UNKNOWN. Sem psicologizar sem evidência. `docs/research/user-patterns/global-pattern-analysis-plan.md`. NÃO executar análise invasiva sem HITL.
 
 **Privacidade radical — ingestão WhatsApp (P0 política ANTES de qualquer ingest):**
-- [ ] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio.
 - [ ] **CONCEPT-ATOMIZATION-MODEL-001** [P1] `curador` `gated:WA-PRIVACY-POLICY-001` — Modelo de atomização: vivido → remove identificável → reconstrói conhecimento útil sem dado pessoal. `docs/architecture/concept-atoms.md`. Exemplo: "João me disse em Patos..." → "pessoa próxima relatou situação de confiança/frustração em contexto social".
 - [ ] **PROV-TELEM-MYCELIUM-MAP-001** [P2] `prime` — Mapa de como provenance/telemetria/Mycelium/start/end/pre-commit/commits entram na arquitetura de autodescoberta com privacidade (fonte/tipo/risco/tratamento/uso permitido/uso proibido/retenção/HITL). `docs/architecture/provenance-telemetry-mycelium-integration.md`.
 - [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
@@ -883,7 +882,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
 - [ ] **DISCOVER-GATE-004** [P2] `sentinela` — Auto-consulta periódica (cron + Layer `/start` reportando drift de registry via `gen-registry-parity-counts.ts`).
-- [ ] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar.
 
 ---
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index f3a72ad3..a86ccf7b 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3740,3 +3740,16 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **DISCOVER-GATE-002** [P1] — 5.95-capability-detector.sh estendido: +`novo_slash_command` (`.claude/commands/*.md`) + `nova_agent_skill` (`agents/skills/*.ts`).
 - [x] **DISCOVER-GATE-003** [P1] — `.husky/_checks/14-discover-gate.sh` wired em pre-commit (após check 13). Exige `CONSULTED-SSOT: <fonte>` no commit body quando detecta sinais de nova capability. Escape: `DISCOVER-GATE-SKIP: <razão>`.
 
+
+## Archived 2026-06-08
+
+### 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
+- [x] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio. ✅ 2026-06-08
+- [x] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto). ✅ 2026-06-08 → docs/strategy/GOW_DEMO_RUNBOOK.md
+
+### 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
+- [x] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio. ✅ 2026-06-08
+
+### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
+- [x] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar. ✅ 2026-06-08
+
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
diff --git a/docs/_current_handoffs/handoff_2026-06-08.md b/docs/_current_handoffs/handoff_2026-06-08.md
new file mode 100644
index 00000000..e5cbb61c
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-08.md
@@ -0,0 +1,43 @@
+# Handoff — 2026-06-08 (sprint GOW + fecho da maratona propósito→use-case)
+
+> Sessão monumental: propósito convergido → produto B2C (GPT/comunidade R$4) → use-case B2B (GOW WhatsApp/Hermes) com PROVA. Codex+Banda travaram a dispersão (A vs B). Tudo no GitHub.
+
+## ✅ Accomplished (com SHAs)
+- **Gap#3 evidence-chain VISÍVEL** — `d592ae02` — [orchestrator.ts](../../apps/egos-gateway/src/orchestrator.ts): footer mostra ferramentas/fontes + "decisão final é sua". Env-gated `EGOS_EVIDENCE_FOOTER` (off=g-pecas produção intocado; on=demo GOW). Typecheck ok + testado off/on. + fix R-SEC-002 (telefone hardcoded removido).
+- **Runbook da demo GOW** — `869e8329` — [GOW_DEMO_RUNBOOK.md](../strategy/GOW_DEMO_RUNBOOK.md): 20min, o que mostrar/não-mostrar, 3 perguntas.
+- **Mapa de arquitetura** — `9d535a7d` — [HERMES_WHATSAPP_USECASE_MAP.md](../strategy/HERMES_WHATSAPP_USECASE_MAP.md): fluxo funciona em prod + gaps + dados p/ dashboard. + regra R-DOC-AUDIENCE-001 (README=humano; resto AI<>AI; humano via HTML).
+- **GPT EGOS pronto p/ criar** — `b768190c`/`a4b92102` — [gpt-instrucoes-COLAR.md](../strategy/gpt-instrucoes-COLAR.md) (identidade EGOS fixa) + 3 knowledge .md em [gpt-knowledge/](../strategy/gpt-knowledge/).
+- **Landing v2 pessoa-comum NO AR** — `d59bfeee`/`a9156f52` — egos.ia.br (hero "A IA ajuda. O EGOS organiza." + casos por área).
+- **Material/roteiro de vídeo + Hotmart** — `cdc292b9`/`68654ab1` — [APRESENTACAO_EGOS.md](../strategy/APRESENTACAO_EGOS.md).
+
+## 🔄 In Progress
+- VALIDATE-BOTH-EXPERIMENT-001 — deploy feito; falta 1ª pessoa real usar o GPT/artefato.
+- GOW sprint — gap#3 done; falta: deploy gateway c/ EGOS_EVIDENCE_FOOTER=1 (HITL) + rodar demo.
+
+## ⏳ Blocked / Decisões Enio
+- Criar o GPT no ChatGPT (pacote pronto) → link → eu coloco na landing + Telegram.
+- Deploy gateway com evidence footer (HITL).
+- As 3 perguntas anti-dispersão da GOW (decidem se vira contrato).
+- Compliance: enquadrar como agente de negócio (não investigativo) — Red Zone.
+
+## 🔗 Next Steps (priority order)
+1. **GOW:** deploy gateway (EGOS_EVIDENCE_FOOTER=1) → rodar demo pelo runbook → responder 3 perguntas.
+2. **B2C:** criar o GPT EGOS + compartilhar link + achar 1ª pessoa (VALIDATE-BOTH).
+3. COPY-PRICE-REMOVE-001 (voz) + GOW-METAPROMPT-EVAL-FIX-001.
+
+## 🌐 Environment State
+- HEAD: `869e8329` | BEHIND/AHEAD 0/0 (tudo pushado) | Uncommitted: ruído auto-gen (rss/manifest/harvest)
+- Gateway: produção g-pecas intocada (footer off por padrão). Landing: no ar.
+- Dispersão saída 🔴 92 scopes/297 commits 7d — mas GERATIVA (propósito + use-case provado + multi-janela).
+
+## 📌 Decisions Made
+- **A vs B = 2 produtos** (Codex+Banda). GOW = TESTAR bounded, NÃO pivô. Manter A intocado.
+- **GPT = identidade EGOS fixa** (corte Enio), não [Nome] em branco.
+- **Preço nunca público** (corte Enio); R$4 ×2 só no checkout.
+- **Diagnostic Protocol = PAUSADO** (Codex: risco segurança/loop).
+- **Voz pública = EGOS-entidade, colaborativa, sem absoluto, sem persona, PT-BR.**
+- **"O valor sou eu" = você PROVADO pelo código** (não guru).
+
+## 🚫 Marked [CONCEPT]
+- 3 dashboards observabilidade, NotebookLM slides/vídeo, egos-mcp/repo-por-cliente — deferidos pós-GOW.
+- Wire gaps #1/#2/#4 do Hermes — só se GOW pagar.
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
/bin/bash -lc "sed -n '1320,1710p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
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

// Cache: tenant tem kb_pages? (evita fetch a cada msg)
const tenantHasKbCache: Map<string, { has: boolean; ts: number }> = new Map();

async function tenantHasKbPages(clientSlug: string): Promise<boolean> {
  const cached = tenantHasKbCache.get(clientSlug);
  if (cached && Date.now() - cached.ts < 300_000) return cached.has; // 5min cache

  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/kb_pages?tenant=eq.${encodeURIComponent(clientSlug)}&select=id&limit=1`,
      { headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}` }, signal: AbortSignal.timeout(3000) }
    );
    const rows = res.ok ? await res.json() as unknown[] : [];
    const has = rows.length > 0;
    tenantHasKbCache.set(clientSlug, { has, ts: Date.now() });
    return has;
  } catch {
    return false;
  }
}

async function verifyCitations(text: string, clientSlug: string | undefined): Promise<string> {
  if (!clientSlug || !SUPABASE_URL || !SUPABASE_KEY) return text;

  // CHAT-TOOLS-FIX-001 (2026-05-13): skip se tenant não tem KB de texto
  // Tenants comerciais (G Peças = catálogo de produtos, não KB) marcavam toda
  // palavra em **bold** com "[?]" — ruído visual nas respostas.
  if (!await tenantHasKbPages(clientSlug)) return text;

  // Collect candidates: bold markdown *text* or 📄...📄 markers
  const candidates: string[] = [];
  const boldRe = /\*([^*]{20,})\*/g;
  const docRe = /📄([^📄]+)📄/g;
  let m: RegExpExecArray | null;
  while ((m = boldRe.exec(text)) !== null && candidates.length < 5) {
    candidates.push(m[1].trim());
  }
  while ((m = docRe.exec(text)) !== null && candidates.length < 5) {
    const c = m[1].trim();
    if (!candidates.includes(c)) candidates.push(c);
  }

  if (candidates.length === 0) return text;

  let result = text;
  await Promise.all(
    candidates.map(async (candidate) => {
      try {
        const res = await fetch(
          `${SUPABASE_URL}/rest/v1/kb_pages?tenant=eq.${encodeURIComponent(clientSlug)}&title=ilike.${encodeURIComponent(`%${candidate}%`)}&select=id&limit=1`,
          { headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}` }, signal: AbortSignal.timeout(3000) }
        );
        const rows = res.ok ? await res.json() as { id: string }[] : [];
        const tag = rows.length > 0 ? " [✓]" : " [?]";
        result = result.replace(`*${candidate}*`, `*${candidate}*${tag}`);
      } catch { /* best-effort — leave text unmodified */ }
    })
  );
  return result;
}

// ─── Format response per channel ─────────────────────────────────────────────

function formatForChannel(text: string, channel: Channel): string {
  if (channel === "whatsapp") {
    // WhatsApp uses *bold*, _italic_, ~strikethrough~, `mono`
    // Remove markdown headers (##) and convert to bold
    return text
      .replace(/^#{1,3}\s+(.+)$/gm, "*$1*")
      .replace(/\*\*(.+?)\*\*/g, "*$1*")
      .replace(/__(.+?)__/g, "_$1_")
      // Limit to 1500 chars for WhatsApp
      .slice(0, 1500);
  }
  // Telegram: already using * for bold — keep as is, just limit length
  return text.slice(0, 2000);
}

// ─── Evidence footer (GOW-EVIDENCE-CHAIN-001 / gap#3) ───────────────────────────
// Torna a evidence-chain VISÍVEL: mostra quais ferramentas (fontes) fundamentaram
// a resposta + a postura de governança. Gated por env EGOS_EVIDENCE_FOOTER (off por
// padrão → g-pecas/produção NÃO muda; on p/ demo GOW). Karpathy: mínimo, opt-in.
const TOOL_EVIDENCE_LABELS: Record<string, string> = {
  search_g_pecas_products: "catálogo de produtos",
  search_products: "catálogo de produtos",
  search_faq_entries: "base de perguntas (FAQ)",
  search_faq: "base de perguntas (FAQ)",
  kb_search_client: "base de conhecimento do cliente",
  wiki: "base de conhecimento",
  guard_test: "verificação de dados sensíveis (Guard Brasil)",
  calendar: "agenda",
  gmail: "e-mail",
  notify_human: "encaminhamento para um atendente humano",
};

function buildEvidenceFooter(toolsUsed: string[], channel: Channel): string {
  if (!process.env.EGOS_EVIDENCE_FOOTER) return "";
  if (!toolsUsed.length) return "";
  const labels = Array.from(new Set(toolsUsed.map((t) => TOOL_EVIDENCE_LABELS[t] ?? t)));
  const sep = channel === "whatsapp" ? "\n\n———\n" : "\n\n———\n";
  const bold = (s: string) => (channel === "whatsapp" ? `*${s}*` : `*${s}*`);
  return `${sep}${bold("🔎 Evidência")}: esta resposta consultou ${labels.join(", ")}. Decisão final é sua; confira o que for importante.`;
}

// ─── System prompt ────────────────────────────────────────────────────────────

// ─── Karpathy Doctrine — Banned Absolutes (A53) ──────────────────────────────
// Fonte: ~/.claude/CLAUDE.md §1 + docs/personal-os/FOCUS_GATES.md
// Aplicável a TODAS respostas do orchestrator pra clientes externos.
const BANNED_ABSOLUTES_RULE = `
PALAVRAS ABSOLUTAS PROIBIDAS (Karpathy Doctrine — A53):
• NUNCA use: "100%", "perfeito", "garantido", "infalível", "sem erros", "único no Brasil"
• Substituir por: "alta acurácia validada", "múltiplas camadas de validação", "resistente e auditável"
• Se perguntarem "é garantido?": diga "temos validação em múltiplas camadas, mas nenhum sistema é infallible"
• Se perguntarem "funciona sempre?": diga "funciona na grande maioria dos casos, com mecanismos de fallback"
`;

const TRANSPARENCY_NOTICE_RULE = `
AVISO OBRIGATÓRIO (LGPD + transparência):
• Na PRIMEIRA mensagem de qualquer conversa nova: inclua naturalmente que é um assistente digital supervisionado
• Ex: "Sou o assistente digital de [empresa], supervisionado pela equipe. Posso ajudar com..."
• NÃO precisa repetir em todas mensagens — apenas na abertura
`;

function buildSystemPrompt(channel: Channel, client?: ClientContext): string {
  const today = new Date().toLocaleDateString("pt-BR", { weekday: "long", year: "numeric", month: "long", day: "numeric" });
  const fmt = channel === "whatsapp" ? "WhatsApp (*negrito*, _itálico_, `código`)" : "Telegram (*negrito*, _itálico_, `código`)";

  return `${client ? TRANSPARENCY_NOTICE_RULE + BANNED_ABSOLUTES_RULE : ""}Você é o EGOS — assistente pessoal de IA do Enio Rocha, engenheiro e empreendedor.
Data de hoje: ${today}

CONTEXTO DO SISTEMA:
O EGOS é uma plataforma multi-agente de IA em produção. Principais produtos:
• Guard Brasil — API de detecção de PII/LGPD (live em guard.egos.ia.br)
• Gem Hunter — motor de descoberta de ferramentas open-source (gemhunter.egos.ia.br)
• Knowledge Base — 51+ páginas de conhecimento compilado (wiki pages + learnings)
• Gateway — este servidor (WhatsApp + Telegram + API REST)
Meta: R$30k+ MRR até junho 2026 (Guard Brasil + Gem Hunter)
${client ? `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXTO DO CLIENTE: ${client.name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Você NÃO é mais o EGOS do Enio. Você é o assistente de IA de *${client.name}*.

USUÁRIO ATUAL: ${client.memberName ?? "Administrador"} (perfil: ${client.memberRole ?? "owner"})
${client.kbAccess?.length ? `⚠️ ACESSO RESTRITO: este usuário só pode ver categorias: ${client.kbAccess.join(", ")}. NÃO mostre informações de outras categorias.` : ""}

SEU PAPEL:
• Responder perguntas com base nos documentos de ${client.name}
• Ajudar a equipe a encontrar informações rapidamente
• Setor: ${client.sector} | KB: ${client.kbSource}
• Cota API: R${client.apiUsedBrl.toFixed(2)} / R${client.apiBudgetBrl.toFixed(2)}/mês

REGRAS OBRIGATÓRIAS:
1. ${(client.slug === "g-pecas" || client.slug === "ferro-velho-patense") ? "SEMPRE use search_products (catálogo) e search_faq (política) antes de afirmar qualquer coisa sobre produto ou política da loja. NÃO use kb_search_client — esta loja não tem KB de documentos." : "SEMPRE use kb_search_client antes de responder sobre documentos, processos, prazos, contratos"}
2. Se não encontrar na base: diga "Não encontrei esse assunto. Quer que eu avise a equipe?"
3. NUNCA invente informações — cite sempre a fonte
4. NUNCA revele dados de outros clientes
5. Para ações irreversíveis (enviar email, criar evento): sempre pedir confirmação explícita

COMUNICAÇÃO:
• Tom: direto e humano, linguagem simples ("avô entende")
• Evite jargão técnico
• Uma resposta curta e certa vale mais que um texto longo e vago
• WhatsApp: use *negrito* para termos importantes, não abuse de emojis

MODO TUTOR:
• Se o usuário parecer novo ou fizer perguntas básicas: explique brevemente o que fez e ofereça uma dica extra no final
• Ex: "_Dica: você também pode perguntar sobre prazos do processo pelo número_"
• Quando o usuário demonstrar fluência OU pedir "para de ensinar" / "já sei" / "modo direto": PARE de dar dicas extras
• O sistema está em evolução — se surgir um tema que você não consegue responder bem, diga: "Ainda não tenho essa integração ativa, mas o Enio pode ativar. Devo avisá-lo?"

COMANDOS QUE O USUÁRIO PODE USAR:
• /custo — gasto de API do mês
• /modelo auto|rapido|premium — escolher modelo de IA
• /exportar — exportar documentos indexados
• /relatorio — relatório de uso mensal
• /ajuda — listar todos os comandos

FERRAMENTAS DISPONÍVEIS:
${(client.slug === "g-pecas" || client.slug === "ferro-velho-patense") ? `• search_products(query, max_price?, condition?) — PRINCIPAL: catálogo REAL de produtos
• search_faq(query) — política da loja (horário, pagamento, frete, garantia, troca, instalação, desconto, contato)
• notify_human(message, urgency) — escalar para humano (desconto >5%, reclamação, instalação)` : `• kb_search_client(query) — PRINCIPAL: busca nos documentos de ${client.name}
• notify_human(message, urgency) — avisar o Enio (use quando: lead quente, problema urgente, pergunta fora do escopo)
• calendar_list / calendar_create — agenda
• gmail_search / gmail_send — emails (pede confirmação antes de enviar)
• memory_search — busca em conversas anteriores`}` : ""}

FERRAMENTAS DISPONÍVEIS (use proativamente):
1. system_status — status completo: Guard Brasil, KB, Gem Hunter, VPS
2. guard_status — detalhes da API Guard Brasil
3. guard_test(text) — testa detecção de PII num texto
4. gem_search(query, sector) — busca tools/repos por setor [ai|crypto|systems|agents|governance|research]
5. gem_trending — gems que apareceram em múltiplos runs (alta confiabilidade)
6. wiki_search(query) — busca no Knowledge Base
7. wiki_page(slug) — lê conteúdo completo de uma página
8. list_agents — lista os ~17 agentes EGOS registrados
9. get_tasks(filter) — tarefas pendentes do TASKS.md [p0|p1|all]
10. recent_commits(limit) — últimos commits do repositório
11. get_costs — custos de API de hoje
12. knowledge_stats — estatísticas do Knowledge Base
13. world_model — snapshot de saúde do sistema
14. memory_search(query) — busca no histórico de conversas passadas (use quando Enio perguntar sobre algo já discutido)
15. kb_search_client(query) — busca na KB do cliente ativo (documentos, contratos, processos, prazos)
16. gmail_search(query) — busca emails do cliente ativo (requer /setup-gmail se não configurado)
17. gmail_send(to, subject, body) — envia email pelo cliente ativo (confirmar antes de enviar)
18. calendar_list(days_ahead?, query?) — agenda do cliente ativo nos próximos N dias
19. calendar_create(title, date, duration_minutes?, description?) — cria evento (confirmar antes)

MEMÓRIA PERSISTENTE:
• As últimas mensagens desta conversa já estão no contexto acima (histórico automático)
• Use memory_search para buscar conversas mais antigas por assunto
• Nunca diga "não tenho acesso ao histórico" — você tem via memory_search

ESTILO DE RESPOSTA:
• Formato: ${fmt}
• Idioma: Português brasileiro sempre
• Tom: direto, técnico, sem rodeios — Enio é dev experiente
• Comprimento: curto para perguntas simples; em análises, SEJA COMPLETO — nunca trunque no meio do raciocínio (preferir terminar a ideia a cortar)
• VISUAL (Enio pediu — Telegram renderiza *negrito*, _itálico_, \`código\`): use *negrito* nos pontos de destaque, separe seções com LINHA EM BRANCO, divida com bullets • — priorize clareza visual e espaçamento, sem poluir
• Use bullet points • e emojis funcionais (não decorativos)
• Se a resposta requer múltiplas ferramentas, use todas antes de responder
• Nunca invente dados — se não souber, diga claramente
• Para tarefas críticas: mencione P0 blockers se relevante
• Se Enio perguntar "lembra quando..." ou "o que falamos sobre..." → use memory_search antes de responder${client?.extraRules ? `\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\nREGRAS ESPECÍFICAS DESTE CLIENTE:\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${client.extraRules}` : ""}`;
}

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


exec
/bin/bash -lc "sed -n '1710,1860p' apps/egos-gateway/src/orchestrator.ts && sed -n '820,930p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:

      messages.push({ role: "tool", tool_call_id: tc.id, name: tc.function.name, content: result });
    }
  }

  const fallback = "Processamento completo.";
  saveHistory(msg.channel, msg.from, userText, fallback, toolsUsed, msg.mediaType).catch(() => {});
  return { text: fallback, toolsUsed };
}
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
      categories: kbAccess?.length ? kbAccess : null,
      decay_rate: 0.01, // RATIO-ABSORB-005: exponential recency decay
    };
    const rpcRes = await fetch(
      `${SUPABASE_URL}/rest/v1/rpc/match_kb_hybrid`,
      {
        method: "POST",
        headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json" },
        body: JSON.stringify(rpcBody),
        signal: AbortSignal.timeout(8000),

exec
/bin/bash -lc "grep -R \"function dispatchTool\\|case \\\"notify_human\\|notify_human\" -n apps/egos-gateway/src/orchestrator.ts | head -50 && nl -ba apps/egos-gateway/src/orchestrator.ts | sed -n '880,910p;1414,1448p;1684,1690p'" in /home/enio/egos
 succeeded in 0ms:
828:      name: "notify_human",
878:    const allow = new Set(["search_products", "search_faq", "notify_human"]);
1127:async function dispatchTool(
1147:    case "notify_human":     return toolNotifyHuman(args.message as string ?? "", args.urgency as string | undefined);
1431:  notify_human: "encaminhamento para um atendente humano",
1521:• notify_human(message, urgency) — escalar para humano (desconto >5%, reclamação, instalação)` : `• kb_search_client(query) — PRINCIPAL: busca nos documentos de ${client.name}
1522:• notify_human(message, urgency) — avisar o Enio (use quando: lead quente, problema urgente, pergunta fora do escopo)
   880	  }
   881	  return TOOL_DEFS;
   882	}
   883	
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
   901	    return "✅ Enio foi notificado. Ele responderá em breve.";
   902	  } catch (e) {
   903	    return `Erro ao notificar admin: ${(e as Error).message}`;
   904	  }
   905	}
   906	
   907	async function toolKbSearchClient(query: string, clientSlug?: string, kbAccess?: string[]): Promise<string> {
   908	  if (!clientSlug) return "Nenhum cliente ativo. Use /cliente SLUG para selecionar.";
   909	  if (!SUPABASE_URL || !SUPABASE_KEY) return "KB indisponível (Supabase não configurado).";
   910	
  1414	  return text.slice(0, 2000);
  1415	}
  1416	
  1417	// ─── Evidence footer (GOW-EVIDENCE-CHAIN-001 / gap#3) ───────────────────────────
  1418	// Torna a evidence-chain VISÍVEL: mostra quais ferramentas (fontes) fundamentaram
  1419	// a resposta + a postura de governança. Gated por env EGOS_EVIDENCE_FOOTER (off por
  1420	// padrão → g-pecas/produção NÃO muda; on p/ demo GOW). Karpathy: mínimo, opt-in.
  1421	const TOOL_EVIDENCE_LABELS: Record<string, string> = {
  1422	  search_g_pecas_products: "catálogo de produtos",
  1423	  search_products: "catálogo de produtos",
  1424	  search_faq_entries: "base de perguntas (FAQ)",
  1425	  search_faq: "base de perguntas (FAQ)",
  1426	  kb_search_client: "base de conhecimento do cliente",
  1427	  wiki: "base de conhecimento",
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
  1443	// ─── System prompt ────────────────────────────────────────────────────────────
  1444	
  1445	// ─── Karpathy Doctrine — Banned Absolutes (A53) ──────────────────────────────
  1446	// Fonte: ~/.claude/CLAUDE.md §1 + docs/personal-os/FOCUS_GATES.md
  1447	// Aplicável a TODAS respostas do orchestrator pra clientes externos.
  1448	const BANNED_ABSOLUTES_RULE = `
  1684	    const { finish_reason, message } = choice;
  1685	
  1686	    if (finish_reason === "stop" || !message.tool_calls?.length) {
  1687	      const raw = message.content ?? "Sem resposta.";
  1688	      const verified = client?.slug ? await verifyCitations(raw, client.slug) : raw;
  1689	      const formatted = formatForChannel(verified, msg.channel) + buildEvidenceFooter(toolsUsed, msg.channel);
  1690	      // Persist conversation turn + token log (non-blocking)

exec
/bin/bash -lc "sed -n '1080,1170p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
      { headers: { Authorization: `Bearer ${auth.token}` }, signal: AbortSignal.timeout(10000) }
    );
    const data = await res.json() as { items?: Array<{ summary?: string; start?: { dateTime?: string; date?: string }; description?: string }> };
    if (!data.items?.length) return `📅 Nenhum evento nos próximos ${daysAhead} dias.`;

    const events = data.items.map(e => {
      const start = e.start?.dateTime ?? e.start?.date ?? "?";
      const dt = start !== "?" ? new Date(start).toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo", dateStyle: "short", timeStyle: "short" }) : "?";
      return `• *${e.summary ?? "Sem título"}* — ${dt}`;
    });
    return `📅 *Agenda — próximos ${daysAhead} dias:*\n\n${events.join("\n")}`;
  } catch (e) {
    return `Erro Calendar: ${(e as Error).message}`;
  }
}

async function toolCalendarCreate(title: string, date: string, durationMinutes: number, description: string | undefined, clientSlug?: string): Promise<string> {
  const auth = await getClientGoogleToken(clientSlug);
  if (!auth) {
    return `📅 *Google Calendar não configurado* para este cliente. Use /setup-calendar para autorizar.`;
  }
  try {
    const start = new Date(date);
    const end = new Date(start.getTime() + durationMinutes * 60_000);
    const body = {
      summary: title,
      description: description ?? "",
      start: { dateTime: start.toISOString(), timeZone: "America/Sao_Paulo" },
      end: { dateTime: end.toISOString(), timeZone: "America/Sao_Paulo" },
    };
    const res = await fetch("https://www.googleapis.com/calendar/v3/calendars/primary/events", {
      method: "POST",
      headers: { Authorization: `Bearer ${auth.token}`, "Content-Type": "application/json" },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(10000),
    });
    if (res.ok) {
      const ev = await res.json() as { htmlLink?: string };
      return `✅ Evento "*${title}*" criado para ${start.toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" })}.\n${ev.htmlLink ?? ""}`;
    }
    const err = await res.json() as { error?: { message?: string } };
    return `❌ Erro ao criar evento: ${err.error?.message ?? res.status}`;
  } catch (e) {
    return `Erro Calendar: ${(e as Error).message}`;
  }
}

async function dispatchTool(
  name: string,
  args: Record<string, unknown>,
  ctx: { channel: Channel; userId: string; clientSlug?: string; kbAccess?: string[] },
): Promise<string> {
  switch (name) {
    case "system_status":    return toolSystemStatus();
    case "guard_status":     return toolGuardStatus();
    case "guard_test":       return toolGuardTest(args.text as string ?? "");
    case "gem_search":       return toolGemSearch(args.query as string ?? "", args.sector as string | undefined);
    case "gem_trending":     return toolGemTrending();
    case "wiki_search":      return toolWikiSearch(args.query as string ?? "");
    case "wiki_page":        return toolWikiPage(args.slug as string ?? "");
    case "list_agents":      return toolListAgents();
    case "get_tasks":        return toolGetTasks((args.filter as "p0" | "p1" | "all") ?? "p0");
    case "recent_commits":   return toolRecentCommits(Number(args.limit ?? 7));
    case "get_costs":        return toolGetCosts();
    case "knowledge_stats":  return toolKnowledgeStats();
    case "world_model":      return toolWorldModel();
    case "memory_search":    return toolMemorySearch(args.query as string ?? "", ctx.channel, ctx.userId);
    case "notify_human":     return toolNotifyHuman(args.message as string ?? "", args.urgency as string | undefined);
    case "kb_search_client": return toolKbSearchClient(args.query as string ?? "", ctx.clientSlug, ctx.kbAccess);
    case "gmail_search":     return toolGmailSearch(args.query as string ?? "", Number(args.max_results ?? 5), ctx.clientSlug);
    case "gmail_send":       return toolGmailSend(args.to as string ?? "", args.subject as string ?? "", args.body as string ?? "", ctx.clientSlug);
    case "calendar_list":    return toolCalendarList(Number(args.days_ahead ?? 7), args.query as string | undefined, ctx.clientSlug);
    case "calendar_create":  return toolCalendarCreate(args.title as string ?? "", args.date as string ?? "", Number(args.duration_minutes ?? 60), args.description as string | undefined, ctx.clientSlug);
    // Aliases novos (genéricos) + legados (backward compat — LLMs em sessões antigas podem chamar nomes velhos)
    case "search_products":        return toolSearchGPecasProducts(args.query as string ?? "", args.max_price as number | undefined, args.condition as string | undefined, ctx.clientSlug);
    case "search_faq":             return toolSearchGPecasFaq(args.query as string ?? "", ctx.clientSlug);
    case "search_gpecas_products": return toolSearchGPecasProducts(args.query as string ?? "", args.max_price as number | undefined, args.condition as string | undefined, ctx.clientSlug);
    case "search_gpecas_faq":      return toolSearchGPecasFaq(args.query as string ?? "", ctx.clientSlug);
    default:                 return `Ferramenta "${name}" não reconhecida.`;
  }
}

/**
 * Tool: search_gpecas_faq — FAQ KB (CHAT-RAG-FAQ-001, 2026-05-13)
 *
 * Anti-hallucination R3: bot consulta política real antes de afirmar
 * horário, pagamento, frete, garantia, etc.
 *
 * CET-DB-FAQ-001 (2026-05-18): usa search_faq_entries (canônico multi-tenant)
 * com fallback para search_g_pecas_faq (legado G Peças).
 */

exec
/bin/bash -lc "nl -ba .claude/settings.json | sed -n '1,40p'" in /home/enio/egos
 succeeded in 0ms:
     1	{
     2	  "permissions": {
     3	    "allow": [
     4	      "Bash(*)",
     5	      "Read",
     6	      "Write",
     7	      "Edit",
     8	      "Glob",
     9	      "Grep",
    10	      "WebFetch",
    11	      "WebSearch",
    12	      "Agent",
    13	      "Skill",
    14	      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
    15	      "Bash(echo \"EXIT: $?\")",
    16	      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
    17	      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
    18	      "Bash(cat)",
    19	      "Bash(bash scripts/check-skills-drift.sh --fix)",
    20	      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
    21	      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
    22	      "mcp__notebooklm-mcp__studio_delete",
    23	      "mcp__claude_ai_Supabase__execute_sql",
    24	      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
    25	      "mcp__claude_ai_Supabase__list_projects"
    26	    ],
    27	    "deny": [
    28	      "Bash(rm -rf /:*)",
    29	      "Bash(rm -rf ~:*)",
    30	      "Bash(dd if=:*)",
    31	      "Bash(mkfs:*)"
    32	    ],
    33	    "defaultMode": "bypassPermissions",
    34	    "additionalDirectories": [
    35	      "/home/enio/egos/.claude/commands"
    36	    ]
    37	  },
    38	  "hooks": {
    39	    "PreToolUse": [
    40	      {

exec
/bin/bash -lc 'grep -R "WA_ADMIN_NUMBER" -n . apps docs scripts | head -20' in /home/enio/egos
2026-06-08T17:52:31.029408Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
exec
/bin/bash -lc "git grep -n \"WA_ADMIN_NUMBER\" -- . ':"'!node_modules'"'" in /home/enio/egos
 succeeded in 0ms:
.env.example:117:WA_ADMIN_NUMBER=                     # apps/egos-gateway/src/orchestrator.ts:871 e.g. 553492374363
apps/egos-gateway/src/channels/whatsapp.ts:40:const ADMIN_NUMBER = process.env.WA_ADMIN_NUMBER ?? "5534992374363"; // Enio
apps/egos-gateway/src/health-monitor.ts:148:const ADMIN_PHONE = process.env.WA_ADMIN_NUMBER ?? "553492374363";
apps/egos-gateway/src/orchestrator.ts:890:  const adminPhone = process.env.WA_ADMIN_NUMBER ?? ""; // R-SEC-002: número via env, nunca hardcoded
docs/exports/notebooklm-ready/codigo-gateway-whatsapp.ts.txt:23:const ADMIN_NUMBER = process.env.WA_ADMIN_NUMBER ?? "553492374363"; // Enio

codex
The security-motivated removal of the hardcoded admin number leaves the notification tool broken in environments where WA_ADMIN_NUMBER is not configured. Other changes appear non-blocking.

Review comment:

- [P2] Fail before sending notifications without an admin number — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:890-897
  When `WA_ADMIN_NUMBER` is unset or left blank as in `.env.example`, `notify_human` now posts to Evolution with `number: ""`, so escalations for urgent support/lead handoff fail at runtime instead of reaching the previous fallback recipient. Keeping the hardcoded number out is right, but this path should explicitly require/configure a non-empty admin number and return a clear configuration error before attempting the send.
The security-motivated removal of the hardcoded admin number leaves the notification tool broken in environments where WA_ADMIN_NUMBER is not configured. Other changes appear non-blocking.

Review comment:

- [P2] Fail before sending notifications without an admin number — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:890-897
  When `WA_ADMIN_NUMBER` is unset or left blank as in `.env.example`, `notify_human` now posts to Evolution with `number: ""`, so escalations for urgent support/lead handoff fail at runtime instead of reaching the previous fallback recipient. Keeping the hardcoded number out is right, but this path should explicitly require/configure a non-empty admin number and return a clear configuration error before attempting the send.
2026-06-08T17:52:49.760196Z ERROR codex_core::session: failed to record rollout items: thread 019ea85c-5e9a-7953-b7fe-38817ac0694b not found
```
