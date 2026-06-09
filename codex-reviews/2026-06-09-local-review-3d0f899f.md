# Codex Local Review — 2026-06-09T14:23:04Z

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
session id: 019eacc3-f8dd-78b1-b6a2-e87e19848bd9
--------
user
changes against 'HEAD~3'
2026-06-09T14:23:05.751159Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T14:23:05.751659Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 21200b24e369e89228c5034ddd907d1ce625e1c1 --stat && git diff 21200b24e369e89228c5034ddd907d1ce625e1c1' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/end.md                       | 16 +++++++++++
 .claude/commands/end.md                        | 18 ++++++++++++
 .claude/settings.json                          |  6 ++--
 TASKS.md                                       |  5 +++-
 TASKS_ARCHIVE.md                               |  6 ++++
 apps/egos-gateway/openapi.yaml                 | 19 ++++++------
 apps/egos-gateway/src/channels/guard-brasil.ts |  4 +--
 apps/egos-gateway/src/orchestrator.ts          |  6 ++--
 apps/egos-landing/public/timeline/rss          |  2 +-
 apps/egos-landing/public/timeline/rss.xml      |  2 +-
 docs/_inbox/ingest/README.md                   | 32 +++++++++++++++++++++
 docs/jobs/2026-06-08-doc-drift-verifier.json   |  6 ++--
 docs/jobs/2026-06-08-pre-commit-pipeline.json  | 40 ++++++++++++++++++++++++++
 13 files changed, 139 insertions(+), 23 deletions(-)
diff --git a/.agents/workflows/end.md b/.agents/workflows/end.md
index 6b2e2179..31cd3b82 100644
--- a/.agents/workflows/end.md
+++ b/.agents/workflows/end.md
@@ -559,6 +559,22 @@ Se o usuário corrigiu approach OU validou approach não-óbvio durante a sessã
 
 ---
 
+## PHASE 8.6 — Knowledge Ingest Gate [OBRIGATÓRIO — END-INGEST-PROMPT-001]
+
+**SEMPRE executar — sem skip.** Perguntar ao Enio ANTES de fechar:
+
+> "📥 **Tem algo a acrescentar desta sessão?**
+> Notas soltas, resumos do ChatGPT/Grok, estudos lidos, áudios transcritos, ideias anotadas no celular — qualquer coisa que ficou fora da conversa.
+> Se sim: drope aqui ou em `docs/_inbox/ingest/` e eu processo (atomizo → memória → RAG).
+> Se não: 'nada' e seguimos."
+
+**Processar resposta:**
+- **"nada" / silêncio**: registrar no handoff: "Phase 8.6: nenhum ingest externo". Seguir.
+- **Conteúdo dropado**: atomizar → memory write → arquivar em `docs/_inbox/ingest/processed/`.
+- **"tem mas não agora"**: criar task INGEST-PENDENTE-<data> no TASKS.md e registrar no handoff.
+
+---
+
 ## PHASE 9 — Daily Article (CONDITIONAL)
 
 **Skip se:**
diff --git a/.claude/commands/end.md b/.claude/commands/end.md
index b98681c6..1f96db6c 100644
--- a/.claude/commands/end.md
+++ b/.claude/commands/end.md
@@ -643,6 +643,24 @@ Afirmação: "Nenhuma inteligência de subagente com valor de referência ficou
 
 ---
 
+## PHASE 8.6 — Knowledge Ingest Gate [OBRIGATÓRIO — END-INGEST-PROMPT-001]
+
+**SEMPRE executar — sem skip.** Perguntar ao Enio ANTES de fechar:
+
+> "📥 **Tem algo a acrescentar desta sessão?**
+> Notas soltas, resumos do ChatGPT/Grok, estudos lidos, áudios transcritos, ideias anotadas no celular — qualquer coisa que ficou fora da conversa.
+> Se sim: drope aqui ou em `docs/_inbox/ingest/` e eu processo (atomizo → memória → RAG).
+> Se não: 'nada' e seguimos."
+
+**Processar resposta:**
+- **"nada" / silêncio**: registrar no handoff: "Phase 8.6: nenhum ingest externo". Seguir.
+- **Conteúdo dropado**: executar pipeline KNOWLEDGE-INGEST-CHANNEL-001 (quando implementado) OU atomizar manualmente → memory write → arquivar em `docs/_inbox/ingest/processed/`.
+- **"tem mas não agora"**: criar task INGEST-PENDENTE-<data> no TASKS.md e registrar no handoff.
+
+**Origem:** Enio 2026-06-08 — "todo /end talvez você deveria me perguntar se temos algo a acrescentar de anotações, chatgpt, grok, estudos — inclua isso, tornar obrigatório". SSOT: KNOWLEDGE-INGEST-CHANNEL-001.
+
+---
+
 ## PHASE 9 — Daily Article (CONDITIONAL)
 
 **Skip se:**
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
index 84d959e6..019766f9 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -93,7 +93,9 @@
 - [ ] **MEMORY-ARCHIVE-001** [P2] `prime` — Criar `MEMORY_ARCHIVE.md` + mover entradas frias do MEMORY.md (652L/329). DEPOIS de MEMORY-DEDUP-ENGINE-001 (detecção de superseded popula o archive; evita corte arbitrário por idade).
 - [ ] **ESSENTIAL-FILES-ENFORCE-001** [P2] `prime` — Wire warn-only (Sentinela varre last_update→REVISAR >60d; /start avisa limites). Só DEPOIS do dedup. Comandos NUNCA bloqueiam. Resolver conflito AGENTS.md 200vs400.
 - [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
-- [ ] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire em end.md. Depende de KNOWLEDGE-INGEST-CHANNEL-001. NÃO feito.
+- [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
+- [ ] **COORD-WATCHER-STALE-001** [P2] `prime` — coordination-watcher stale (416391s). Reiniciar: `bun scripts/coordination-watcher.ts &`. Pre-existing issue, não regressão desta sessão.
+- [ ] **RULES-PENDING-CODIFY-001** [P2] `prime` — 5 candidatos de regra em `~/.egos/rules-pending.jsonl` desta sessão. Rodar `/rules` p/ codificar (AGENTS.md+.guarani).
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
@@ -773,6 +775,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### 🔴 NOVO 2026-05-25 — INC-SYNC-001 + Home=Catalogo
 
+- [ ] **VPS-GATEWAY-AUTOSYNC-001** [P1] `prime` -- VPS: /opt/egos-gateway e copia independente de /opt/egos-git/apps/egos-gateway. Push GitHub NAO atualiza automaticamente. Criar sync no pos-push Hermes. Descoberto 2026-06-09.
 - [ ] **DEPLOY-SYNC-PRECOMMIT-001** [P2] `1h Sonnet` — Pre-commit detecta mudanças em `central-egos/template/src/` e exige `deploy-all-tenants.sh` `(P0→P2 2026-06-03: pivô despriorizou storefront)`
 - [ ] **UX-HOME-AS-CATALOG-001** [P2] `3h Sonnet` — Home `/` reutiliza componentes `/catalogo` (sidebar+filtros+grid+sort). Opção C: refator `app/page.tsx`. NÃO redirecionar. `(P0→P2 2026-06-03: pivô despriorizou storefront)`
 - [ ] **SSOT-SYNC-WATCHDOG-001** [P1] `2h` — Hermes job semanal compara `pm2 describe created_at` de todos tenants. Diff >48h = alerta Telegram.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 4c6958c8..a24b67a7 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3759,3 +3759,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [x] **MEMORY-ROUTER-ARCH-001** [P1] `prime` — Política "arquivos essenciais = roteadores" FEITA + validada Banda+Codex. SSOT: `docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md`. Cortes Enio 2026-06-09: dedup primeiro (raiz), warn-only, criar MEMORY_ARCHIVE. Follow-ons abaixo. ✅ 2026-06-09
 
+
+## Archived 2026-06-09
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire em end.md. FEITO: Phase 8.6 adicionada em `.claude/commands/end.md` + `.agents/workflows/end.md`; pasta `docs/_inbox/ingest/` criada. 2026-06-09.
+
diff --git a/apps/egos-gateway/openapi.yaml b/apps/egos-gateway/openapi.yaml
index 924d55ec..ae883fba 100644
--- a/apps/egos-gateway/openapi.yaml
+++ b/apps/egos-gateway/openapi.yaml
@@ -12,7 +12,7 @@ info:
     Paid endpoints accept `X-Payment-Payload` header (x402 protocol).
 
     ## Marketplaces
-    Available on: APINow.fun, Proxies.sx, AgentCash, Smithery, Glama.
+    Em processo de cadastro: Smithery, Glama, AgentCash.
 
   contact:
     name: Enio Rocha — EGOS
@@ -86,7 +86,7 @@ paths:
         Returns detections with positions and confidence scores.
         LGPD-compliant — no text is stored.
 
-        **Pricing:** R$0.02/call (equivalent ~$0.001 USDC via x402).
+        **Pricing:** R$0.01/call (equivalent ~$0.001 USDC via x402).
         **Free tier:** 500 calls/month — contact enio@egos.ia.br.
       requestBody:
         required: true
@@ -229,6 +229,8 @@ paths:
     post:
       tags: [knowledge]
       summary: Record a new learning
+      security:
+        - bearerAuth: []
       requestBody:
         required: true
         content:
@@ -250,29 +252,26 @@ paths:
           description: Learning recorded
 
   # ── Gem Hunter ──────────────────────────────────────────────────────────────
-  /gem-hunter/gems:
+  /gem-hunter/latest:
     get:
       tags: [gem-hunter]
-      summary: List discovered GitHub gems
+      summary: List latest discovered GitHub gems
       parameters:
         - name: sector
           in: query
           schema:
             type: string
           example: "lgpd"
-        - name: min_score
-          in: query
-          schema:
-            type: integer
-            default: 70
+          description: "Filter by sector: lgpd, agents, governance, ai, crypto, systems, research"
         - name: limit
           in: query
           schema:
             type: integer
             default: 20
+          description: Max results (default 20)
       responses:
         "200":
-          description: Gem list
+          description: Gem list (sorted by discovery date)
 
   # ── Health ──────────────────────────────────────────────────────────────────
   /health:
diff --git a/apps/egos-gateway/src/channels/guard-brasil.ts b/apps/egos-gateway/src/channels/guard-brasil.ts
index 313c9b1c..9e75bd79 100644
--- a/apps/egos-gateway/src/channels/guard-brasil.ts
+++ b/apps/egos-gateway/src/channels/guard-brasil.ts
@@ -1,7 +1,7 @@
 /**
  * Guard Brasil x402 Channel — HTTP 402 Payment Required middleware
  *
- * Implements x402 protocol (EIP-7702 pattern) for micropayment-gated Guard Brasil API calls.
+ * Implements x402 protocol (EIP-7702 pattern) for micropayment-gated Guard Brasil API calls. // scan-ok: EIP-7702 is an Ethereum standard, not a plate
  * Uses Coinbase public facilitator (x402.org) to settle USDC on Base — no own infra required.
  *
  * Routes:
@@ -175,7 +175,7 @@ guardBrasil.post("/inspect", async (c) => {
       network: NETWORK,
       maxAmountRequired: PRICE_PER_CALL_USDC_ATOMIC.toString(),
       resource: `${GUARD_API_URL}/v1/inspect`,
-      description: "Guard Brasil PII inspection — $0.001 USDC on Base",
+      description: "Guard Brasil PII inspection - $0.001 USDC on Base",
       mimeType: "application/json",
       payTo: PAYMENT_ADDRESS || "pending",
       maxTimeoutSeconds: 60,
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 961f95e9..28e4d05e 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -6,7 +6,7 @@
  * Transcription: Groq Whisper-large-v3-turbo
  * Vision: google/gemini-2.0-flash-001 (multimodal)
  *
- * Tools (13):
+ * Tools (21):
  *   system_status, guard_status, guard_test, gem_search, gem_trending,
  *   wiki_search, wiki_page, list_agents, get_tasks, recent_commits,
  *   get_costs, knowledge_stats, world_model
@@ -1471,7 +1471,7 @@ CONTEXTO DO SISTEMA:
 O EGOS é uma plataforma multi-agente de IA em produção. Principais produtos:
 • Guard Brasil — API de detecção de PII/LGPD (live em guard.egos.ia.br)
 • Gem Hunter — motor de descoberta de ferramentas open-source (gemhunter.egos.ia.br)
-• Knowledge Base — 51+ páginas de conhecimento compilado (wiki pages + learnings)
+• Knowledge Base — 500+ páginas de conhecimento compilado (wiki pages + learnings)
 • Gateway — este servidor (WhatsApp + Telegram + API REST)
 Meta: R$30k+ MRR até junho 2026 (Guard Brasil + Gem Hunter)
 ${client ? `
@@ -1582,7 +1582,7 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
   } else if (msg.mediaType === "image" && msg.mediaBase64 && msg.mediaMime) {
     const description = await describeImage(msg.mediaBase64, msg.mediaMime, msg.caption);
     userText = `[Imagem]: ${description}${msg.caption ? ` | Legenda do usuário: "${msg.caption}"` : ""}`;
-    toolsUsed.push("qwen-vl");
+    toolsUsed.push("gemini-2.0-flash");
     console.log(`[orchestrator] Image described: "${description.slice(0, 60)}"`);
   } else if (msg.mediaType === "document") {
     userText = `[Arquivo recebido: ${msg.fileName ?? "sem nome"}]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo conteúdo de arquivos ainda.`;
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
diff --git a/docs/_inbox/ingest/README.md b/docs/_inbox/ingest/README.md
new file mode 100644
index 00000000..85235c28
--- /dev/null
+++ b/docs/_inbox/ingest/README.md
@@ -0,0 +1,32 @@
+# docs/_inbox/ingest — Canal de Ingestão do Enio
+
+> **last_update:** 2026-06-09 · **status:** ATUAL · **owner:** prime
+> **Origem:** END-INGEST-PROMPT-001 + KNOWLEDGE-INGEST-CHANNEL-001 (Enio 2026-06-08)
+
+## Como usar
+
+1. **Drope aqui** qualquer arquivo `.md` de nota, resumo de ChatGPT/Grok, estudo, áudio transcrito, ideia do celular
+2. **Avise o EGOS** (no /end ou qualquer mensagem) — ele processa
+3. **Pipeline:** anonimizar → atomizar → memory write → arquivar em `processed/`
+
+## O que vai pra cá
+
+- Resumos de conversas com ChatGPT, Grok, Gemini
+- Notas de estudos (livros, artigos, vídeos)
+- Áudios transcritos (reunião, reflexão)
+- Ideias anotadas no celular / Obsidian
+- Qualquer coisa que ficou **fora** da sessão Claude Code mas tem valor de memória
+
+## O que NÃO vai pra cá
+
+- Dados de investigação / PII real (R-SEC-002 T0 — local cifrado apenas)
+- Código (vai direto no repo)
+- Tasks (vai no TASKS.md)
+
+## processed/
+
+Arquivos já processados (atomizados + memory write feito). Mantidos para auditoria de proveniência.
+
+## SSOT
+
+`KNOWLEDGE-INGEST-CHANNEL-001` em TASKS.md · Pipeline completo a implementar nessa task.
diff --git a/docs/jobs/2026-06-08-doc-drift-verifier.json b/docs/jobs/2026-06-08-doc-drift-verifier.json
index 51d2f152..84e0ca95 100644
--- a/docs/jobs/2026-06-08-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-08-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-08T17:02:56.838Z",
+  "verified_at": "2026-06-08T19:52:45.610Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1248",
+      "current_value": "1260",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -123,7 +123,7 @@
       "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
       "status": "ok",
       "last_value": "19",
-      "current_value": "97",
+      "current_value": "100",
       "tolerance": "min:10",
       "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-08-pre-commit-pipeline.json b/docs/jobs/2026-06-08-pre-commit-pipeline.json
index 3f671b13..793779a7 100644
--- a/docs/jobs/2026-06-08-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-08-pre-commit-pipeline.json
@@ -78,5 +78,45 @@
     "duration_ms": null,
     "event": "commit:chore files=2 sha=f60954ff",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:45:35.773Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=10 sha=88201591",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:52:46.190Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=d8411241",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:01:10.597Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=7d6b09c6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:04:30.180Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=5 sha=b3d62d99",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:05:50.745Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=f9369018",
+    "repo": "/home/enio/egos"
   }
 ]

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "find apps/egos-gateway/src -maxdepth 3 -type f -print | sort && sed -n '1,260p' apps/egos-gateway/src/index.ts 2>/dev/null || true && grep -R \"gem-hunter\\|knowledge\\|record\" -n apps/egos-gateway/src apps/egos-gateway/openapi.yaml" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/src/channels/chat.ts
apps/egos-gateway/src/channels/discover.ts
apps/egos-gateway/src/channels/gem-hunter-api.ts
apps/egos-gateway/src/channels/guard-brasil.ts
apps/egos-gateway/src/channels/knowledge.ts
apps/egos-gateway/src/channels/lgpd.ts
apps/egos-gateway/src/channels/telegram.ts
apps/egos-gateway/src/channels/ui.ts
apps/egos-gateway/src/channels/v1.ts
apps/egos-gateway/src/channels/whatsapp.ts
apps/egos-gateway/src/health-monitor.ts
apps/egos-gateway/src/orchestrator.ts
apps/egos-gateway/src/server.ts
apps/egos-gateway/src/tenants/g-pecas/extra-rules.ts
apps/egos-gateway/src/tenants/index.ts
apps/egos-gateway/src/health-monitor.ts:69:    pingUrl(`${GW_INTERNAL}/gem-hunter/health`).then(r => ({ name: "Gem Hunter", ...r })),
apps/egos-gateway/src/server.ts:10: *   GET  /knowledge/*           — Knowledge API (wiki pages + learnings)
apps/egos-gateway/src/server.ts:11: *   GET  /gem-hunter/*          — Gem Hunter API (discovery engine)
apps/egos-gateway/src/server.ts:23:import { knowledge } from "./channels/knowledge.js";
apps/egos-gateway/src/server.ts:25:import { gemHunter } from "./channels/gem-hunter-api.js";
apps/egos-gateway/src/server.ts:48:    channels: ["whatsapp", "telegram", "knowledge", "gem-hunter", "guard-brasil-x402", "api-mestra-v1"],
apps/egos-gateway/src/server.ts:54:      knowledge: "/knowledge/stats",
apps/egos-gateway/src/server.ts:55:      "gem-hunter": "/gem-hunter/product",
apps/egos-gateway/src/server.ts:65:app.route("/knowledge", knowledge);
apps/egos-gateway/src/server.ts:66:app.route("/gem-hunter", gemHunter);
apps/egos-gateway/src/server.ts:99:console.log(`[egos-gateway] Gem Hunter:  http://localhost:${PORT}/gem-hunter/health`);
apps/egos-gateway/src/orchestrator.ts:12: *   get_costs, knowledge_stats, world_model
apps/egos-gateway/src/orchestrator.ts:276:    const res = await fetch(`${GW}/knowledge/stats`, { signal: AbortSignal.timeout(3000) });
apps/egos-gateway/src/orchestrator.ts:285:    const res = await fetch(`${GW}/gem-hunter/health`, { signal: AbortSignal.timeout(3000) });
apps/egos-gateway/src/orchestrator.ts:357:      ? `${GW}/gem-hunter/sector/${sector}`
apps/egos-gateway/src/orchestrator.ts:358:      : `${GW}/gem-hunter/latest?limit=5`;
apps/egos-gateway/src/orchestrator.ts:360:    if (!res.ok) return "💎 Gem Hunter sem dados. Rode: bun agent:run gem-hunter --exec";
apps/egos-gateway/src/orchestrator.ts:376:    const res = await fetch(`${GW}/gem-hunter/trending`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:380:    if (!gems.length) return "Sem trending (precisa de 2+ runs do gem-hunter).";
apps/egos-gateway/src/orchestrator.ts:392:    const res = await fetch(`${GW}/knowledge/search?q=${encodeURIComponent(query)}`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:408:    const res = await fetch(`${GW}/knowledge/pages/${slug}`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:532:// ─── Tool: knowledge_stats ───────────────────────────────────────────────────
apps/egos-gateway/src/orchestrator.ts:536:    const res = await fetch(`${GW}/knowledge/stats`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:722:      name: "knowledge_stats",
apps/egos-gateway/src/orchestrator.ts:1144:    case "knowledge_stats":  return toolKnowledgeStats();
apps/egos-gateway/src/orchestrator.ts:1539:12. knowledge_stats — estatísticas do Knowledge Base
apps/egos-gateway/src/channels/gem-hunter-api.ts:8: *   GET  /gem-hunter/topics        — list all search topic categories
apps/egos-gateway/src/channels/gem-hunter-api.ts:9: *   GET  /gem-hunter/latest        — latest run: top gems by score
apps/egos-gateway/src/channels/gem-hunter-api.ts:10: *   GET  /gem-hunter/reports       — list available report files
apps/egos-gateway/src/channels/gem-hunter-api.ts:11: *   GET  /gem-hunter/sector/:name  — filter latest results by sector keyword
apps/egos-gateway/src/channels/gem-hunter-api.ts:12: *   GET  /gem-hunter/trending      — trending from SQLite history (multi-run)
apps/egos-gateway/src/channels/gem-hunter-api.ts:13: *   GET  /gem-hunter/health        — API health + last run info
apps/egos-gateway/src/channels/gem-hunter-api.ts:32:const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
apps/egos-gateway/src/channels/gem-hunter-api.ts:146:  const record = await lookupApiKey(raw);
apps/egos-gateway/src/channels/gem-hunter-api.ts:147:  if (!record) {
apps/egos-gateway/src/channels/gem-hunter-api.ts:152:    tier: record.tier,
apps/egos-gateway/src/channels/gem-hunter-api.ts:153:    resultsLimit: record.results_limit,
apps/egos-gateway/src/channels/gem-hunter-api.ts:154:    requestsPerDay: record.requests_per_day,
apps/egos-gateway/src/channels/gem-hunter-api.ts:155:    keyId: record.id,
apps/egos-gateway/src/channels/gem-hunter-api.ts:236:// ── Static topic definitions (mirrors gem-hunter.ts DEFAULT_QUERIES categories) ──
apps/egos-gateway/src/channels/gem-hunter-api.ts:278:      upgrade: "https://gateway.egos.ia.br/gem-hunter/product",
apps/egos-gateway/src/channels/gem-hunter-api.ts:301:    service: "gem-hunter-api",
apps/egos-gateway/src/channels/gem-hunter-api.ts:308:    docs: "/gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:335:  if (!run) return c.json({ error: "No latest run found. Run: bun agent:run gem-hunter --exec" }, 404);
apps/egos-gateway/src/channels/gem-hunter-api.ts:414:    return c.json({ message: "No history database yet — run gem-hunter a few times to build trends", trending: [] });
apps/egos-gateway/src/channels/gem-hunter-api.ts:466:      topics: "GET /gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:467:      latest: "GET /gem-hunter/latest?sector=ai&limit=20",
apps/egos-gateway/src/channels/gem-hunter-api.ts:468:      sector: "GET /gem-hunter/sector/{ai|crypto|systems|agents|governance|research}",
apps/egos-gateway/src/channels/gem-hunter-api.ts:469:      trending: "GET /gem-hunter/trending",
apps/egos-gateway/src/channels/gem-hunter-api.ts:470:      reports: "GET /gem-hunter/reports",
apps/egos-gateway/src/channels/knowledge.ts:13: *   POST /learnings          — record a new learning
apps/egos-gateway/src/channels/knowledge.ts:14: *   GET  /stats              — knowledge base stats
apps/egos-gateway/src/channels/knowledge.ts:39:export const knowledge = new Hono();
apps/egos-gateway/src/channels/knowledge.ts:42:knowledge.get("/pages", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:58:knowledge.get("/pages/:slug", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:70:knowledge.get("/index", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:108:knowledge.get("/search", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:138:knowledge.get("/learnings", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:155:knowledge.post("/learnings", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:179:    return c.json({ error: "Failed to record learning", detail: err }, 500);
apps/egos-gateway/src/channels/knowledge.ts:187:knowledge.get("/stats", async (c) => {
apps/egos-gateway/src/channels/ui.ts:5: * Fetches data from the /knowledge/* API endpoints on the same gateway.
apps/egos-gateway/src/channels/ui.ts:177:    const r = await fetch(BASE + '/knowledge/stats');
apps/egos-gateway/src/channels/ui.ts:189:    const r = await fetch(BASE + '/knowledge/index');
apps/egos-gateway/src/channels/ui.ts:225:  const url = BASE + '/knowledge/learnings?limit=9' + (domain ? '&domain=' + domain : '');
apps/egos-gateway/src/channels/ui.ts:232:      grid.innerHTML = '<p class="text-gray-600 text-sm col-span-3">No learnings recorded yet.</p>';
apps/egos-gateway/src/channels/ui.ts:251:    const r = await fetch(BASE + '/knowledge/pages/' + slug);
apps/egos-gateway/src/channels/ui.ts:285:    const r = await fetch(BASE + '/knowledge/search?q=' + encodeURIComponent(q));
apps/egos-gateway/src/channels/ui.ts:321:ui.get("/gem-hunter", async (c) => {
apps/egos-gateway/src/channels/whatsapp.ts:466:function recordIncoming(remoteJid: string): void {
apps/egos-gateway/src/channels/whatsapp.ts:475:  for (const [recordedPhone, ts] of incomingHistory.entries()) {
apps/egos-gateway/src/channels/whatsapp.ts:476:    if (samePhone(phone, recordedPhone) && Date.now() - ts < windowMs) {
apps/egos-gateway/src/channels/whatsapp.ts:909:  recordIncoming(senderPhone);
apps/egos-gateway/src/channels/whatsapp.ts:1368:  recordIncoming(senderPhone);
apps/egos-gateway/src/channels/telegram.ts:69:  const records = lines.map((l) => JSON.parse(l) as HitlRecord);
apps/egos-gateway/src/channels/telegram.ts:70:  const idx = records.findIndex((r) => r.id === id);
apps/egos-gateway/src/channels/telegram.ts:73:  const resolved: HitlRecord = { ...records[idx], status, decided_at: new Date().toISOString() };
apps/egos-gateway/src/channels/telegram.ts:75:  // Rewrite pending without this record
apps/egos-gateway/src/channels/telegram.ts:76:  const remaining = records.filter((r) => r.id !== id);
apps/egos-gateway/src/channels/telegram.ts:318:  // 1. Resolve pending record
apps/egos-gateway/src/channels/telegram.ts:441:      // Trigger gem hunt via gem-hunter server — fire-and-forget
apps/egos-gateway/src/channels/lgpd.ts:55:    // Fetch client record
apps/egos-gateway/openapi.yaml:34:  - name: knowledge
apps/egos-gateway/openapi.yaml:36:  - name: gem-hunter
apps/egos-gateway/openapi.yaml:114:  /knowledge/stats:
apps/egos-gateway/openapi.yaml:116:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:135:  /knowledge/search:
apps/egos-gateway/openapi.yaml:137:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:169:  /knowledge/pages:
apps/egos-gateway/openapi.yaml:171:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:201:  /knowledge/pages/{slug}:
apps/egos-gateway/openapi.yaml:203:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:222:  /knowledge/learnings:
apps/egos-gateway/openapi.yaml:224:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:230:      tags: [knowledge]
apps/egos-gateway/openapi.yaml:252:          description: Learning recorded
apps/egos-gateway/openapi.yaml:255:  /gem-hunter/latest:
apps/egos-gateway/openapi.yaml:257:      tags: [gem-hunter]

exec
/bin/bash -lc "sed -n '1,230p' apps/egos-gateway/src/channels/knowledge.ts && sed -n '300,380p' apps/egos-gateway/src/channels/gem-hunter-api.ts && sed -n '1,140p' apps/egos-gateway/openapi.yaml && sed -n '220,285p' apps/egos-gateway/openapi.yaml" in /home/enio/egos
 succeeded in 0ms:
/**
 * EGOS Gateway — Knowledge Channel
 *
 * REST API for the EGOS Knowledge System (wiki pages + learnings).
 * Backed by Supabase tables: egos_wiki_pages, egos_learnings, egos_wiki_changelog.
 *
 * Endpoints:
 *   GET  /pages              — list all wiki pages (paginated)
 *   GET  /pages/:slug        — get a single page by slug
 *   GET  /index              — wiki index grouped by category
 *   GET  /search?q=term      — search pages (mode=ilike|fts, default: ilike)
 *   GET  /learnings          — list learnings (filterable)
 *   POST /learnings          — record a new learning
 *   GET  /stats              — knowledge base stats
 */

import { Hono } from "hono";

const SUPABASE_URL = process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL || "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || "";

// ── Supabase helper ───────────────────────────────────────────────────

async function sbFetch(path: string, init?: RequestInit): Promise<Response> {
  return fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    ...init,
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
      ...(init?.headers || {}),
    },
  });
}

// ── Routes ────────────────────────────────────────────────────────────

export const knowledge = new Hono();

// List pages (paginated)
knowledge.get("/pages", async (c) => {
  const limit = Math.min(Number(c.req.query("limit") || 50), 100);
  const offset = Number(c.req.query("offset") || 0);
  const category = c.req.query("category");

  let params = `select=slug,title,category,tags,quality_score,updated_at&order=updated_at.desc&limit=${limit}&offset=${offset}`;
  if (category) params += `&category=eq.${category}`;

  const res = await sbFetch(`egos_wiki_pages?${params}`);
  if (!res.ok) return c.json({ error: "Failed to fetch pages" }, 500);

  const pages = await res.json();
  return c.json({ pages, count: (pages as unknown[]).length, limit, offset });
});

// Get single page
knowledge.get("/pages/:slug", async (c) => {
  const slug = c.req.param("slug");
  const res = await sbFetch(`egos_wiki_pages?slug=eq.${slug}&limit=1`);
  if (!res.ok) return c.json({ error: "Failed to fetch page" }, 500);

  const pages = (await res.json()) as unknown[];
  if (pages.length === 0) return c.json({ error: "Page not found" }, 404);

  return c.json(pages[0]);
});

// Wiki index (grouped by category)
knowledge.get("/index", async (c) => {
  const res = await sbFetch(
    "egos_wiki_pages?select=slug,title,category,tags,quality_score,updated_at&order=category,title"
  );
  if (!res.ok) return c.json({ error: "Failed to fetch index" }, 500);

  const pages = (await res.json()) as Array<{
    slug: string;
    title: string;
    category: string;
    tags: string[];
    quality_score: number;
    updated_at: string;
  }>;

  const grouped: Record<string, typeof pages> = {};
  for (const p of pages) {
    if (!grouped[p.category]) grouped[p.category] = [];
    grouped[p.category].push(p);
  }

  const avgQuality = pages.length
    ? Math.round(pages.reduce((s, p) => s + p.quality_score, 0) / pages.length)
    : 0;

  return c.json({
    total_pages: pages.length,
    avg_quality: avgQuality,
    categories: grouped,
    generated_at: new Date().toISOString(),
  });
});

// Full-text search
// Query params:
//   ?q=term        — search term (required, min 2 chars)
//   ?mode=fts      — PostgreSQL full-text search via phfts (Portuguese, uses idx_wiki_pages_tsvec)
//   ?mode=ilike    — (default) backward-compatible pattern search (uses idx_wiki_pages_*_trgm)
knowledge.get("/search", async (c) => {
  const q = c.req.query("q");
  if (!q || q.length < 2) return c.json({ error: "Query too short (min 2 chars)" }, 400);

  const mode = c.req.query("mode") ?? "ilike";

  let res: Response;

  if (mode === "fts") {
    // PostgreSQL full-text search (phfts = plainto_tsquery, handles natural language).
    // Hits the idx_wiki_pages_tsvec GIN index (KB-015 migration).
    const ftsQuery = encodeURIComponent(q);
    res = await sbFetch(
      `egos_wiki_pages?select=slug,title,category,tags,quality_score,updated_at&or=(title.phfts(portuguese).${ftsQuery},content.phfts(portuguese).${ftsQuery})&order=quality_score.desc&limit=20`
    );
  } else {
    // Default ilike — backward-compatible; accelerated by pg_trgm GIN indexes (KB-015).
    const encoded = encodeURIComponent(`%${q}%`);
    res = await sbFetch(
      `egos_wiki_pages?select=slug,title,category,tags,quality_score,updated_at&or=(title.ilike.${encoded},content.ilike.${encoded})&order=quality_score.desc&limit=20`
    );
  }

  if (!res.ok) return c.json({ error: "Search failed" }, 500);

  const results = await res.json();
  return c.json({ query: q, mode, results, count: (results as unknown[]).length });
});

// List learnings
knowledge.get("/learnings", async (c) => {
  const domain = c.req.query("domain");
  const outcome = c.req.query("outcome");
  const limit = Math.min(Number(c.req.query("limit") || 30), 100);

  let params = `select=*&order=created_at.desc&limit=${limit}`;
  if (domain) params += `&domain=eq.${domain}`;
  if (outcome) params += `&outcome=eq.${outcome}`;

  const res = await sbFetch(`egos_learnings?${params}`);
  if (!res.ok) return c.json({ error: "Failed to fetch learnings" }, 500);

  const learnings = await res.json();
  return c.json({ learnings, count: (learnings as unknown[]).length });
});

// Record a learning
knowledge.post("/learnings", async (c) => {
  const body = await c.req.json();

  const required = ["domain", "outcome", "summary"];
  for (const field of required) {
    if (!body[field]) return c.json({ error: `Missing required field: ${field}` }, 400);
  }

  const res = await sbFetch("egos_learnings", {
    method: "POST",
    body: JSON.stringify({
      session_id: body.session_id || null,
      domain: body.domain,
      outcome: body.outcome,
      summary: body.summary,
      detail: body.detail || null,
      pattern: body.pattern || null,
      evidence: body.evidence || [],
      impact: body.impact || "low",
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    return c.json({ error: "Failed to record learning", detail: err }, 500);
  }

  const result = await res.json();
  return c.json({ ok: true, learning: (result as unknown[])[0] }, 201);
});

// Knowledge base stats
knowledge.get("/stats", async (c) => {
  // Page count + category breakdown
  const pagesRes = await sbFetch(
    "egos_wiki_pages?select=category,quality_score"
  );
  const learningsRes = await sbFetch(
    "egos_learnings?select=domain,outcome"
  );

  if (!pagesRes.ok || !learningsRes.ok) {
    return c.json({ error: "Failed to fetch stats" }, 500);
  }

  const pages = (await pagesRes.json()) as Array<{ category: string; quality_score: number }>;
  const learnings = (await learningsRes.json()) as Array<{ domain: string; outcome: string }>;

  const categoryCount: Record<string, number> = {};
  let totalQuality = 0;
  for (const p of pages) {
    categoryCount[p.category] = (categoryCount[p.category] || 0) + 1;
    totalQuality += p.quality_score;
  }

  const domainCount: Record<string, number> = {};
  const outcomeCount: Record<string, number> = {};
  for (const l of learnings) {
    domainCount[l.domain] = (domainCount[l.domain] || 0) + 1;
    outcomeCount[l.outcome] = (outcomeCount[l.outcome] || 0) + 1;
  }

  return c.json({
    pages: {
      total: pages.length,
      avg_quality: pages.length ? Math.round(totalQuality / pages.length) : 0,
      by_category: categoryCount,
    },
    learnings: {
      total: learnings.length,
      by_domain: domainCount,
      by_outcome: outcomeCount,
    },
    generated_at: new Date().toISOString(),
  });
});
  return c.json({
    service: "gem-hunter-api",
    version: "1.0.0",
    status: run ? "operational" : "no_data",
    last_run: run?.date || null,
    last_modified: getLastModified(LATEST_RUN_PATH),
    total_gems: run?.gems?.length || 0,
    sectors: Object.keys(SECTOR_MAP),
    docs: "/gem-hunter/topics",
  });
});

// List all topic categories
gemHunter.get("/topics", (c) => {
  const sectorFilter = c.req.query("sector");
  const topics = sectorFilter
    ? TOPICS.filter((t) => t.sector === sectorFilter.toLowerCase())
    : TOPICS;

  const bySector: Record<string, typeof TOPICS> = {};
  for (const t of topics) {
    if (!bySector[t.sector]) bySector[t.sector] = [];
    bySector[t.sector].push(t);
  }

  return c.json({
    total: topics.length,
    sectors: Object.keys(SECTOR_MAP),
    by_sector: bySector,
  });
});

// Latest run — top gems
gemHunter.get("/latest", (c) => {
  const run = readLatestRun();
  if (!run) return c.json({ error: "No latest run found. Run: bun agent:run gem-hunter --exec" }, 404);

  const tierCtx = c.get("tierCtx") as TierContext | undefined;
  const tierLimit = tierCtx?.resultsLimit ?? TIER_DEFAULTS.free.results_limit;

  const requested = Math.min(Number(c.req.query("limit") || tierLimit), 100);
  const limit = Math.min(requested, tierLimit); // cap at tier's max
  const sector = c.req.query("sector");

  let gems = run.gems || [];
  if (sector) gems = filterBySector(gems, sector);

  // Sort by score descending
  gems = gems.sort((a, b) => (b.score || 0) - (a.score || 0)).slice(0, limit);

  return c.json({
    date: run.date,
    total: gems.length,
    tier: tierCtx?.tier ?? "free",
    results_limit: tierLimit,
    sector: sector || "all",
    gems,
  });
});

// Filter by sector
gemHunter.get("/sector/:name", (c) => {
  const sector = c.req.param("name").toLowerCase();
  const run = readLatestRun();
  if (!run) return c.json({ error: "No data available" }, 404);

  const tierCtx = c.get("tierCtx") as TierContext | undefined;
  const tierLimit = tierCtx?.resultsLimit ?? TIER_DEFAULTS.free.results_limit;

  const normalizedSector = SECTOR_ALIASES[sector] || sector;
  if (!SECTOR_MAP[normalizedSector]) {
    return c.json({ error: `Unknown sector: ${sector}`, available: Object.keys(SECTOR_MAP) }, 400);
  }

  const gems = filterBySector(run.gems || [], normalizedSector)
    .sort((a, b) => (b.score || 0) - (a.score || 0))
    .slice(0, tierLimit);

  return c.json({
    sector: normalizedSector,
    date: run.date,
openapi: "3.1.0"
info:
  title: EGOS Gateway API
  version: "1.2.0"
  description: |
    EGOS Gateway — unified API for Guard Brasil PII detection (LGPD compliance),
    Knowledge Base access, Gem Hunter intelligence, and EGOS orchestration.

    ## Authentication
    Some endpoints use x402 micropayments (USDC via Base L2).
    Free endpoints require no authentication.
    Paid endpoints accept `X-Payment-Payload` header (x402 protocol).

    ## Marketplaces
    Em processo de cadastro: Smithery, Glama, AgentCash.

  contact:
    name: Enio Rocha — EGOS
    email: enio@egos.ia.br
    url: https://egos.ia.br
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://gateway.egos.ia.br
    description: Production (Hetzner VPS, Caddy TLS)
  - url: http://localhost:3050
    description: Local development

tags:
  - name: guard-brasil
    description: PII detection and LGPD compliance (Brazilian data protection)
  - name: knowledge
    description: Knowledge Base — wiki pages, learnings, search
  - name: gem-hunter
    description: GitHub Gem Hunter intelligence (trending repos, scoring)
  - name: health
    description: System health and metadata

paths:
  # ── Guard Brasil ────────────────────────────────────────────────────────────
  /guard-brasil/health:
    get:
      tags: [guard-brasil]
      summary: Guard Brasil health check
      description: Returns API status and available PII patterns. Free endpoint.
      responses:
        "200":
          description: API is healthy
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    example: ok
                  patterns:
                    type: integer
                    description: Number of active PII detection patterns
                    example: 16
                  version:
                    type: string
                    example: "0.2.3"

  /guard-brasil/meta:
    get:
      tags: [guard-brasil]
      summary: Guard Brasil metadata
      description: Returns PII pattern list, categories, and pricing info.
      responses:
        "200":
          description: Metadata response
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/GuardMeta"

  /guard-brasil/inspect:
    post:
      tags: [guard-brasil]
      summary: Inspect text for PII (paid — x402 micropayment)
      description: |
        Scans text for 16 Brazilian PII patterns (CPF, RG, CNPJ, email, phone, etc.).
        Returns detections with positions and confidence scores.
        LGPD-compliant — no text is stored.

        **Pricing:** R$0.01/call (equivalent ~$0.001 USDC via x402).
        **Free tier:** 500 calls/month — contact enio@egos.ia.br.
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/InspectRequest"
            example:
              text: "Entre em contato: NOME_EXEMPLO, CPF 000.000.000-00, email contato@empresa.com.br"
      responses:
        "200":
          description: PII detection results
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InspectResponse"
        "402":
          description: Payment required (x402)
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/PaymentRequired"

  # ── Knowledge Base ──────────────────────────────────────────────────────────
  /knowledge/stats:
    get:
      tags: [knowledge]
      summary: Knowledge Base statistics
      responses:
        "200":
          description: KB stats
          content:
            application/json:
              schema:
                type: object
                properties:
                  total_pages:
                    type: integer
                  categories:
                    type: array
                    items:
                      type: string
                  avg_quality:
                    type: number

  /knowledge/search:
    get:
      tags: [knowledge]
      summary: Full-text search across KB pages
      parameters:
        - name: q
          description: Page not found

  /knowledge/learnings:
    get:
      tags: [knowledge]
      summary: List learnings (HARVEST entries)
      responses:
        "200":
          description: Learnings list
    post:
      tags: [knowledge]
      summary: Record a new learning
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [content, category]
              properties:
                content:
                  type: string
                category:
                  type: string
                tags:
                  type: array
                  items:
                    type: string
      responses:
        "201":
          description: Learning recorded

  # ── Gem Hunter ──────────────────────────────────────────────────────────────
  /gem-hunter/latest:
    get:
      tags: [gem-hunter]
      summary: List latest discovered GitHub gems
      parameters:
        - name: sector
          in: query
          schema:
            type: string
          example: "lgpd"
          description: "Filter by sector: lgpd, agents, governance, ai, crypto, systems, research"
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
          description: Max results (default 20)
      responses:
        "200":
          description: Gem list (sorted by discovery date)

  # ── Health ──────────────────────────────────────────────────────────────────
  /health:
    get:
      tags: [health]
      summary: Gateway health
      responses:
        "200":
          description: Healthy

components:

exec
/bin/bash -lc "sed -n '285,420p' apps/egos-gateway/openapi.yaml && sed -n '1,210p' apps/egos-gateway/src/channels/gem-hunter-api.ts" in /home/enio/egos
 succeeded in 0ms:
components:
  schemas:
    InspectRequest:
      type: object
      required: [text]
      properties:
        text:
          type: string
          description: Text to inspect for PII
          maxLength: 10000
        context:
          type: string
          description: Optional context (e.g. 'juridico', 'saude')

    InspectResponse:
      type: object
      properties:
        has_pii:
          type: boolean
        pii_count:
          type: integer
        detections:
          type: array
          items:
            type: object
            properties:
              type:
                type: string
                description: PII type (cpf, rg, cnpj, email, phone, etc.)
                example: cpf
              value:
                type: string
                description: Detected value (masked for security)
                example: "000.000.000-**"
              confidence:
                type: number
                minimum: 0
                maximum: 1
              position:
                type: integer
        redacted:
          type: string
          description: Text with PII replaced by [TIPO_REDACTED]
        lgpd_summary:
          type: string
          description: Human-readable LGPD compliance note

    GuardMeta:
      type: object
      properties:
        version:
          type: string
        patterns:
          type: array
          items:
            type: object
            properties:
              id:
                type: string
              name:
                type: string
              category:
                type: string
              example:
                type: string

    WikiPageSummary:
      type: object
      properties:
        slug:
          type: string
        title:
          type: string
        category:
          type: string
        quality_score:
          type: integer
        tags:
          type: array
          items:
            type: string
        summary:
          type: string

    WikiPage:
      allOf:
        - $ref: "#/components/schemas/WikiPageSummary"
        - type: object
          properties:
            content:
              type: string
            source_files:
              type: array
              items:
                type: string
            updated_at:
              type: string
              format: date-time

    PaymentRequired:
      type: object
      properties:
        error:
          type: string
          example: "Payment required"
        accepts:
          type: array
          items:
            type: string
          example: ["x402/usdc-base"]
        amount_usdc:
          type: number
          example: 0.001
        payment_url:
          type: string

  securitySchemes:
    x402Payment:
      type: apiKey
      in: header
      name: X-Payment-Payload
      description: x402 micropayment payload (USDC on Base L2)
    bearerAuth:
      type: http
      scheme: bearer
      description: API key (contact enio@egos.ia.br for access)
/**
 * EGOS Gateway — Gem Hunter API Channel
 *
 * Exposes Gem Hunter discovery engine results as a REST API.
 * Backed by pre-computed reports (latest-run.json, SQLite history).
 *
 * Endpoints:
 *   GET  /gem-hunter/topics        — list all search topic categories
 *   GET  /gem-hunter/latest        — latest run: top gems by score
 *   GET  /gem-hunter/reports       — list available report files
 *   GET  /gem-hunter/sector/:name  — filter latest results by sector keyword
 *   GET  /gem-hunter/trending      — trending from SQLite history (multi-run)
 *   GET  /gem-hunter/health        — API health + last run info
 *
 * Auth (GH-068): Bearer token validation via Supabase gem_hunter_api_keys
 * Rate limiting (GH-069): Tier-aware daily limits via gem_hunter_usage
 *
 * Product: Gem Hunter API (revenue stream)
 *   Free tier  : 5 req/day, top 5 results (no key required — IP-based)
 *   Starter    : R$99/mo, 50 req/day, top 20 results
 *   Pro        : R$499/mo, unlimited, all sectors, AI synthesis
 */

import { Hono } from "hono";
import type { MiddlewareHandler } from "hono";
import { createHash } from "crypto";
import { join } from "path";
import { existsSync, readdirSync, readFileSync, statSync } from "fs";
import Database from "bun:sqlite";

const ROOT = join(import.meta.dir, "../../../..");
const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
const LATEST_RUN_PATH = join(REPORTS_DIR, "latest-run.json");
const HISTORY_DB_PATH = join(REPORTS_DIR, "history.db");

const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";

// ── Auth & Rate Limiting (GH-068/069) ─────────────────────────────────────────

type Tier = "free" | "starter" | "pro" | "pay-per-use";

interface ApiKeyRecord {
  id: string;
  tier: Tier;
  requests_per_day: number;
  results_limit: number;
  active: boolean;
}

const TIER_DEFAULTS: Record<Tier, { requests_per_day: number; results_limit: number }> = {
  free:          { requests_per_day: 5,  results_limit: 5 },
  starter:       { requests_per_day: 50, results_limit: 20 },
  pro:           { requests_per_day: 999999, results_limit: 100 },
  "pay-per-use": { requests_per_day: 100, results_limit: 20 },
};

const SB_HEADERS = {
  apikey: SUPABASE_KEY,
  Authorization: `Bearer ${SUPABASE_KEY}`,
  "Content-Type": "application/json",
};

async function lookupApiKey(raw: string): Promise<ApiKeyRecord | null> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return null;
  const hash = createHash("sha256").update(raw).digest("hex");
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/gem_hunter_api_keys?key_hash=eq.${hash}&active=eq.true&select=id,tier,requests_per_day,results_limit,active`,
      { headers: SB_HEADERS, signal: AbortSignal.timeout(4000) }
    );
    if (!res.ok) return null;
    const rows = (await res.json()) as ApiKeyRecord[];
    return rows[0] ?? null;
  } catch {
    return null;
  }
}

async function checkAndIncrementUsage(keyId: string | null, ip: string, limit: number): Promise<{ allowed: boolean; count: number }> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return { allowed: true, count: 0 }; // no-op if no Supabase

  const today = new Date().toISOString().slice(0, 10);
  const filter = keyId
    ? `key_id=eq.${keyId}&usage_date=eq.${today}`
    : `ip=eq.${encodeURIComponent(ip)}&usage_date=eq.${today}&key_id=is.null`;

  try {
    // Get current count
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/gem_hunter_usage?${filter}&select=id,count`,
      { headers: SB_HEADERS, signal: AbortSignal.timeout(4000) }
    );
    const rows = res.ok ? ((await res.json()) as { id: number; count: number }[]) : [];
    const current = rows[0]?.count ?? 0;

    if (current >= limit) return { allowed: false, count: current };

    // Upsert: increment or create
    const upsertBody = keyId
      ? { key_id: keyId, usage_date: today, count: current + 1, updated_at: new Date().toISOString() }
      : { ip, usage_date: today, count: current + 1, updated_at: new Date().toISOString() };

    const upsertRes = await fetch(`${SUPABASE_URL}/rest/v1/gem_hunter_usage`, {
      method: rows[0] ? "PATCH" : "POST",
      headers: { ...SB_HEADERS, Prefer: rows[0] ? "return=minimal" : "return=minimal" },
      body: JSON.stringify(rows[0]
        ? { count: current + 1, updated_at: new Date().toISOString() }
        : upsertBody),
      signal: AbortSignal.timeout(4000),
    });

    // For PATCH, we need to filter
    if (rows[0]) {
      await fetch(`${SUPABASE_URL}/rest/v1/gem_hunter_usage?id=eq.${rows[0].id}`, {
        method: "PATCH",
        headers: { ...SB_HEADERS, Prefer: "return=minimal" },
        body: JSON.stringify({ count: current + 1, updated_at: new Date().toISOString() }),
        signal: AbortSignal.timeout(4000),
      });
    }

    void upsertRes; // already handled above
    return { allowed: true, count: current + 1 };
  } catch {
    return { allowed: true, count: 0 }; // fail open to avoid blocking legit traffic
  }
}

// Hono middleware: resolves tier from Bearer token (or defaults to free IP-based)
interface TierContext {
  tier: Tier;
  resultsLimit: number;
  requestsPerDay: number;
  keyId: string | null;
  ip: string;
}

async function resolveTier(authHeader: string | undefined, ip: string): Promise<TierContext> {
  const defaults = TIER_DEFAULTS.free;
  if (!authHeader?.startsWith("Bearer ")) {
    return { tier: "free", resultsLimit: defaults.results_limit, requestsPerDay: defaults.requests_per_day, keyId: null, ip };
  }

  const raw = authHeader.slice(7).trim();
  const record = await lookupApiKey(raw);
  if (!record) {
    return { tier: "free", resultsLimit: defaults.results_limit, requestsPerDay: defaults.requests_per_day, keyId: null, ip };
  }

  return {
    tier: record.tier,
    resultsLimit: record.results_limit,
    requestsPerDay: record.requests_per_day,
    keyId: record.id,
    ip,
  };
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const gemHunter = new Hono<{ Variables: { tierCtx: TierContext } }>();

// ── Types ──────────────────────────────────────────────────────────────────────

interface GemResult {
  name: string;
  description: string;
  url: string;
  source: string;
  stars?: number;
  score?: number;
  topic?: string;
  category?: string;
  tags?: string[];
}

interface LatestRun {
  date: string;
  gems: GemResult[];
  totalFound?: number;
  topKeywords?: string[];
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function readLatestRun(): LatestRun | null {
  if (!existsSync(LATEST_RUN_PATH)) return null;
  try {
    return JSON.parse(readFileSync(LATEST_RUN_PATH, "utf-8")) as LatestRun;
  } catch {
    return null;
  }
}

function getLastModified(path: string): string | null {
  try {
    return statSync(path).mtime.toISOString();
  } catch {
    return null;
  }
}

/** Map user-facing sector names to internal topic keywords */
const SECTOR_MAP: Record<string, string[]> = {
  ai: ["agents", "AI", "LLM", "GPT", "language model", "autonomous", "MCP", "orchestration"],
  crypto: ["blockchain", "crypto", "web3", "DeFi", "x402", "on-chain", "CoinGecko"],
  systems: ["systems dev", "runtime", "compiler", "bun", "typescript", "rust", "go"],
  agents: ["agent", "multi-agent", "tool use", "A2A", "MCP", "orchestration", "swarm"],
  governance: ["governance", "rules", "compliance", "SSOT", "audit", "policy"],
  research: ["arxiv", "paper", "academic", "research", "benchmark"],

exec
/bin/bash -lc "nl -ba .claude/settings.json | sed -n '1,80p' && nl -ba apps/egos-gateway/openapi.yaml | sed -n '220,245p' && nl -ba apps/egos-gateway/src/channels/knowledge.ts | sed -n '150,170p'" in /home/enio/egos
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
    41	        "matcher": "Grep|Glob|Read|Search",
    42	        "hooks": [
    43	          {
    44	            "type": "command",
    45	            "command": "~/.claude/hooks/cbm-code-discovery-gate"
    46	          }
    47	        ]
    48	      },
    49	      {
    50	        "matcher": "Edit",
    51	        "hooks": [
    52	          {
    53	            "type": "command",
    54	            "command": "~/.claude/hooks/pre-edit-safety"
    55	          }
    56	        ]
    57	      },
    58	      {
    59	        "matcher": "Bash",
    60	        "hooks": [
    61	          {
    62	            "type": "command",
    63	            "command": "~/.claude/hooks/rm-guard"
    64	          }
    65	        ]
    66	      }
    67	    ],
    68	    "PostToolUse": [
    69	      {
    70	        "matcher": "Write|Edit",
    71	        "hooks": [
    72	          {
    73	            "type": "command",
    74	            "command": "~/.claude/hooks/post-write-typecheck"
    75	          },
    76	          {
    77	            "type": "command",
    78	            "command": "~/.claude/hooks/tone-honesty-gate"
    79	          }
    80	        ]
   220	          description: Page not found
   221	
   222	  /knowledge/learnings:
   223	    get:
   224	      tags: [knowledge]
   225	      summary: List learnings (HARVEST entries)
   226	      responses:
   227	        "200":
   228	          description: Learnings list
   229	    post:
   230	      tags: [knowledge]
   231	      summary: Record a new learning
   232	      security:
   233	        - bearerAuth: []
   234	      requestBody:
   235	        required: true
   236	        content:
   237	          application/json:
   238	            schema:
   239	              type: object
   240	              required: [content, category]
   241	              properties:
   242	                content:
   243	                  type: string
   244	                category:
   245	                  type: string
   150	  const learnings = await res.json();
   151	  return c.json({ learnings, count: (learnings as unknown[]).length });
   152	});
   153	
   154	// Record a learning
   155	knowledge.post("/learnings", async (c) => {
   156	  const body = await c.req.json();
   157	
   158	  const required = ["domain", "outcome", "summary"];
   159	  for (const field of required) {
   160	    if (!body[field]) return c.json({ error: `Missing required field: ${field}` }, 400);
   161	  }
   162	
   163	  const res = await sbFetch("egos_learnings", {
   164	    method: "POST",
   165	    body: JSON.stringify({
   166	      session_id: body.session_id || null,
   167	      domain: body.domain,
   168	      outcome: body.outcome,
   169	      summary: body.summary,
   170	      detail: body.detail || null,

exec
/bin/bash -lc "git show 21200b24e369e89228c5034ddd907d1ce625e1c1:apps/egos-gateway/openapi.yaml | nl -ba | sed -n '222,250p' && git show 21200b24e369e89228c5034ddd907d1ce625e1c1:.claude/settings.json | nl -ba | sed -n '1,35p'" in /home/enio/egos
 succeeded in 0ms:
   222	  /knowledge/learnings:
   223	    get:
   224	      tags: [knowledge]
   225	      summary: List learnings (HARVEST entries)
   226	      responses:
   227	        "200":
   228	          description: Learnings list
   229	    post:
   230	      tags: [knowledge]
   231	      summary: Record a new learning
   232	      requestBody:
   233	        required: true
   234	        content:
   235	          application/json:
   236	            schema:
   237	              type: object
   238	              required: [content, category]
   239	              properties:
   240	                content:
   241	                  type: string
   242	                category:
   243	                  type: string
   244	                tags:
   245	                  type: array
   246	                  items:
   247	                    type: string
   248	      responses:
   249	        "201":
   250	          description: Learning recorded
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
    14	      "mcp__*",
    15	      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
    16	      "Bash(echo \"EXIT: $?\")",
    17	      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
    18	      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
    19	      "Bash(cat)",
    20	      "Bash(bash scripts/check-skills-drift.sh --fix)",
    21	      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
    22	      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
    23	      "mcp__notebooklm-mcp__studio_delete"
    24	    ],
    25	    "deny": [
    26	      "Bash(rm -rf /:*)",
    27	      "Bash(rm -rf ~:*)",
    28	      "Bash(dd if=:*)",
    29	      "Bash(mkfs:*)"
    30	    ],
    31	    "defaultMode": "bypassPermissions",
    32	    "additionalDirectories": [
    33	      "/home/enio/egos/.claude/commands"
    34	    ]
    35	  },

exec
/bin/bash -lc "python - <<'PY'
import yaml,sys
with open('apps/egos-gateway/openapi.yaml') as f:
 data=yaml.safe_load(f)
print(data['openapi'], list(data['paths'].keys()))
PY" in /home/enio/egos
 succeeded in 0ms:
3.1.0 ['/guard-brasil/health', '/guard-brasil/meta', '/guard-brasil/inspect', '/knowledge/stats', '/knowledge/search', '/knowledge/pages', '/knowledge/pages/{slug}', '/knowledge/learnings', '/gem-hunter/latest', '/health']

exec
/bin/bash -lc 'git log --oneline --decorate -3 && git diff --check 21200b24e369e89228c5034ddd907d1ce625e1c1' in /home/enio/egos
 succeeded in 0ms:
3d0f899f (HEAD -> main, origin/main) chore(tasks): VPS-GATEWAY-AUTOSYNC-001 -- gap /opt/egos-gateway nao sincroniza do git automaticamente
b9f7c8e4 fix(gateway): 5 bugs criticos MCP/ChatGPT -- inspect 500->402, phantom /gems, pricing, KB count, telemetria
1a2b9415 feat(end): [rework-ok] Phase 8.6 obrigatória — Knowledge Ingest Gate (END-INGEST-PROMPT-001)

exec
/bin/bash -lc "sed -n '1,230p' apps/egos-gateway/src/channels/guard-brasil.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Guard Brasil x402 Channel — HTTP 402 Payment Required middleware
 *
 * Implements x402 protocol (EIP-7702 pattern) for micropayment-gated Guard Brasil API calls. // scan-ok: EIP-7702 is an Ethereum standard, not a plate
 * Uses Coinbase public facilitator (x402.org) to settle USDC on Base — no own infra required.
 *
 * Routes:
 *   GET  /guard-brasil/health       — channel health (free)
 *   GET  /guard-brasil/meta         — pricing + capabilities (free)
 *   POST /guard-brasil/inspect      — PII inspection ($0.001 USDC / call, Base chain)
 *
 * x402 flow:
 *   1. Client POSTs /guard-brasil/inspect without payment
 *   2. Server returns 402 with X-Payment-Required header (price, network, recipient)
 *   3. Client sends payment TX via Coinbase facilitator, includes X-Payment header
 *   4. Server verifies payment via facilitator, proxies to Guard Brasil API
 *   5. Server returns result + X-Payment-Response header
 *
 * x402 spec: https://x402.org
 * Facilitator: https://x402.org/facilitator (public Coinbase endpoint, no auth needed)
 * Base network: https://base.org (L2, ~$0.00001/tx gas)
 *
 * API-004 ✅ Base wallet: 0x7f43b82a000a1977cc355c6e7ece166dfbb885ab
 * API-005 ✅ Skeleton live. Env vars required for production:
 *   - GUARD_BRASIL_PAYMENT_ADDRESS  — Base chain USDC recipient (see API-004)
 *   - GUARD_BRASIL_API_KEY          — internal key for proxied calls
 *   - X402_PRICE_USDC_ATOMIC        — price per call in USDC atomic units (default 1000 = $0.001)
 *
 * Pricing rationale (market reference, not revenue target):
 *   $0.001 USDC/call = competitive with AWS Comprehend PII (~$0.0001/char × 10 chars avg)
 *   Free tier: via Guard Brasil API free keys (150 calls/mo), no x402 needed
 *   Always prefer free/freemium first — x402 for agent-to-agent programmatic use
 */

import { Hono } from "hono";

// ── Constants (all env-overridable — no hardcoded production values) ───────────

const GUARD_API_URL = process.env.GUARD_BRASIL_API_URL ?? "https://guard.egos.ia.br";
const GUARD_API_KEY = process.env.GUARD_BRASIL_API_KEY ?? "";
// API-004: Base wallet for USDC payments. Set via env — default is the known wallet.
const PAYMENT_ADDRESS = process.env.GUARD_BRASIL_PAYMENT_ADDRESS ?? "0x7f43b82a000a1977cc355c6e7ece166dfbb885ab";
const FACILITATOR_URL = process.env.X402_FACILITATOR_URL ?? "https://x402.org/facilitator";

// Env-overridable pricing: USDC atomic units (6 decimals). 1000 = $0.001 per call.
// Reference: AWS Comprehend PII ~$0.001/request; Guard Brasil goal: cost-covering + fair margin.
const PRICE_PER_CALL_USDC_ATOMIC = Number(process.env.X402_PRICE_USDC_ATOMIC ?? "1000");
const NETWORK = process.env.X402_NETWORK ?? "base";
const CURRENCY = "USDC";

// ── Types ──────────────────────────────────────────────────────────────────────

interface PaymentPayload {
  network: string;
  txHash: string;
  amount: number; // USDC atomic units
  recipient: string;
}

interface FacilitatorVerifyResponse {
  isValid: boolean;
  invalidReason?: string;
  settlement?: {
    txHash: string;
    amount: string;
    network: string;
  };
}

// ── Payment Verification ───────────────────────────────────────────────────────

/**
 * Verify payment via Coinbase x402 facilitator (no viem needed — HTTP call only).
 * Full verification (on-chain) requires viem + API-004 wallet.
 */
async function verifyPayment(payment: PaymentPayload): Promise<{ ok: boolean; reason?: string }> {
  if (!PAYMENT_ADDRESS) {
    // API-004 not done yet — log and allow (dev mode)
    console.warn("[x402] GUARD_BRASIL_PAYMENT_ADDRESS not set — payment verification skipped (dev mode)");
    return { ok: true };
  }

  try {
    const res = await fetch(`${FACILITATOR_URL}/verify`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        network: payment.network,
        txHash: payment.txHash,
        expectedRecipient: PAYMENT_ADDRESS,
        expectedAmount: PRICE_PER_CALL_USDC_ATOMIC.toString(),
        expectedCurrency: CURRENCY,
      }),
    });

    if (!res.ok) {
      return { ok: false, reason: `facilitator ${res.status}` };
    }

    const data = (await res.json()) as FacilitatorVerifyResponse;
    if (!data.isValid) {
      return { ok: false, reason: data.invalidReason ?? "invalid payment" };
    }

    return { ok: true };
  } catch (err) {
    console.error("[x402] Facilitator verify error:", err);
    return { ok: false, reason: "facilitator unreachable" };
  }
}

/** Parse X-Payment header into PaymentPayload. Format: "network:txHash:amount" */
function parsePaymentHeader(header: string | null): PaymentPayload | null {
  if (!header) return null;
  const parts = header.split(":");
  if (parts.length < 3) return null;
  const [network, txHash, amountStr] = parts;
  const amount = Number(amountStr);
  if (!network || !txHash || isNaN(amount)) return null;
  return { network, txHash, amount, recipient: PAYMENT_ADDRESS };
}

// ── Hono Router ───────────────────────────────────────────────────────────────

export const guardBrasil = new Hono();

/** Health — free, no auth */
guardBrasil.get("/health", (c) => {
  return c.json({
    service: "guard-brasil-x402",
    status: "operational",
    payment: PAYMENT_ADDRESS ? "configured" : "dev-mode (no payment address)",
    price: `$${(PRICE_PER_CALL_USDC_ATOMIC / 1_000_000).toFixed(4)} USDC per call`,
    network: NETWORK,
    facilitator: FACILITATOR_URL,
    upstream: GUARD_API_URL,
  });
});

/** Meta — pricing + capabilities, free */
guardBrasil.get("/meta", async (c) => {
  try {
    const res = await fetch(`${GUARD_API_URL}/v1/meta`);
    if (!res.ok) return c.json({ error: "upstream unavailable" }, 503);
    const data = await res.json();
    return c.json({
      ...data as object,
      x402: {
        price_per_call_usdc: PRICE_PER_CALL_USDC_ATOMIC / 1_000_000,
        network: NETWORK,
        currency: CURRENCY,
        recipient: PAYMENT_ADDRESS || "pending API-004",
        facilitator: FACILITATOR_URL,
      },
    });
  } catch {
    return c.json({ error: "upstream unreachable" }, 503);
  }
});

/**
 * Inspect — PII detection gated by x402 micropayment.
 *
 * Without X-Payment header → 402 with payment instructions.
 * With valid X-Payment header → proxy to Guard Brasil API, return result.
 */
guardBrasil.post("/inspect", async (c) => {
  const xPayment = c.req.header("X-Payment");
  const payment = parsePaymentHeader(xPayment ?? null);

  // ── 402: No payment provided ──────────────────────────────────────────────
  if (!payment) {
    c.header("X-Payment-Required", JSON.stringify({
      scheme: "exact",
      network: NETWORK,
      maxAmountRequired: PRICE_PER_CALL_USDC_ATOMIC.toString(),
      resource: `${GUARD_API_URL}/v1/inspect`,
      description: "Guard Brasil PII inspection - $0.001 USDC on Base",
      mimeType: "application/json",
      payTo: PAYMENT_ADDRESS || "pending",
      maxTimeoutSeconds: 60,
      asset: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913", // USDC on Base
      extra: { name: "USDC", version: "1" },
    }));
    c.header("Access-Control-Expose-Headers", "X-Payment-Required");
    return c.json({
      error: "Payment Required",
      message: "Include X-Payment header with Base USDC transaction. See X-Payment-Required for details.",
      x402_spec: "https://x402.org",
    }, 402);
  }

  // ── Verify payment via facilitator ─────────────────────────────────────────
  const verification = await verifyPayment(payment);
  if (!verification.ok) {
    return c.json({
      error: "Payment Invalid",
      reason: verification.reason,
    }, 402);
  }

  // ── Proxy to Guard Brasil API ──────────────────────────────────────────────
  if (!GUARD_API_KEY) {
    return c.json({ error: "Gateway misconfigured — GUARD_BRASIL_API_KEY not set" }, 503);
  }

  try {
    const body = await c.req.json();
    const upstream = await fetch(`${GUARD_API_URL}/v1/inspect`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${GUARD_API_KEY}`,
      },
      body: JSON.stringify(body),
    });

    if (!upstream.ok) {
      const err = await upstream.text();
      return c.json({ error: "upstream error", detail: err }, upstream.status as 400 | 422 | 500);
    }

    const result = await upstream.json();
    c.header("X-Payment-Response", JSON.stringify({ success: true, txHash: payment.txHash }));
    return c.json(result);
  } catch (err) {
    console.error("[x402] Upstream proxy error:", err);
    return c.json({ error: "upstream unreachable" }, 503);
  }
});

exec
/bin/bash -lc "grep -n \"SECTOR_ALIASES\\|lgpd\" -n apps/egos-gateway/src/channels/gem-hunter-api.ts" in /home/enio/egos
 succeeded in 0ms:
214:const SECTOR_ALIASES: Record<string, string> = {
226:  const normalizedSector = SECTOR_ALIASES[sector.toLowerCase()] || sector.toLowerCase();
369:  const normalizedSector = SECTOR_ALIASES[sector] || sector;

exec
/bin/bash -lc "sed -n '205,235p' apps/egos-gateway/src/channels/gem-hunter-api.ts" in /home/enio/egos
 succeeded in 0ms:
  ai: ["agents", "AI", "LLM", "GPT", "language model", "autonomous", "MCP", "orchestration"],
  crypto: ["blockchain", "crypto", "web3", "DeFi", "x402", "on-chain", "CoinGecko"],
  systems: ["systems dev", "runtime", "compiler", "bun", "typescript", "rust", "go"],
  agents: ["agent", "multi-agent", "tool use", "A2A", "MCP", "orchestration", "swarm"],
  governance: ["governance", "rules", "compliance", "SSOT", "audit", "policy"],
  research: ["arxiv", "paper", "academic", "research", "benchmark"],
};

/** Sector aliases for API query normalization */
const SECTOR_ALIASES: Record<string, string> = {
  "ia": "ai",
  "inteligencia-artificial": "ai",
  "agentes": "agents",
  "orquestracao": "agents",
  "cripto": "crypto",
  "blockchain": "crypto",
  "governanca": "governance",
  "pesquisa": "research",
};

function filterBySector(gems: GemResult[], sector: string): GemResult[] {
  const normalizedSector = SECTOR_ALIASES[sector.toLowerCase()] || sector.toLowerCase();
  const keywords = SECTOR_MAP[normalizedSector];
  if (!keywords) return gems;

  return gems.filter((g) => {
    const text = `${g.name} ${g.description} ${g.topic || ""} ${g.category || ""}`.toLowerCase();
    return keywords.some((kw) => text.includes(kw.toLowerCase()));
  });
}


codex
The patch introduces API contract mismatches, including documenting bearer protection for a write endpoint that does not enforce it. These should be corrected before considering the patch fully safe.

Full review comments:

- [P2] Enforce the documented bearer requirement — /home/enio/egos/apps/egos-gateway/openapi.yaml:232-233
  If `/knowledge/learnings` is meant to require an API key, this OpenAPI change only updates the contract: `knowledge.post('/learnings')` still accepts the request body and inserts via the Supabase service role without checking `Authorization`. Published clients/operators will now see this as protected while the write endpoint remains publicly callable, so either add auth middleware here or remove the `bearerAuth` requirement from the spec.

- [P3] Align the documented Gem Hunter sort order — /home/enio/egos/apps/egos-gateway/openapi.yaml:279-279
  For `/gem-hunter/latest`, the implementation sorts results by score descending before slicing, not by discovery date. Clients using this newly documented contract may page or display results incorrectly if they expect chronological order, so the response description should match the actual score-based ordering or the handler should sort by date.
The patch introduces API contract mismatches, including documenting bearer protection for a write endpoint that does not enforce it. These should be corrected before considering the patch fully safe.

Full review comments:

- [P2] Enforce the documented bearer requirement — /home/enio/egos/apps/egos-gateway/openapi.yaml:232-233
  If `/knowledge/learnings` is meant to require an API key, this OpenAPI change only updates the contract: `knowledge.post('/learnings')` still accepts the request body and inserts via the Supabase service role without checking `Authorization`. Published clients/operators will now see this as protected while the write endpoint remains publicly callable, so either add auth middleware here or remove the `bearerAuth` requirement from the spec.

- [P3] Align the documented Gem Hunter sort order — /home/enio/egos/apps/egos-gateway/openapi.yaml:279-279
  For `/gem-hunter/latest`, the implementation sorts results by score descending before slicing, not by discovery date. Clients using this newly documented contract may page or display results incorrectly if they expect chronological order, so the response description should match the actual score-based ordering or the handler should sort by date.
```
