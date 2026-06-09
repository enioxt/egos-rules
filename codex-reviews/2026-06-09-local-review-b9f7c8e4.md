# Codex Local Review — 2026-06-09T14:18:07Z

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
session id: 019eacbf-736a-76b0-b074-d5d9a8f3c253
--------
user
changes against 'HEAD~3'
2026-06-09T14:18:09.564618Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T14:18:09.564926Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 84130718805a5e2b1dfb59fa9ea6059d00309e26 --stat && git diff 84130718805a5e2b1dfb59fa9ea6059d00309e26' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/end.md                       |  16 +++
 .claude/commands/end.md                        |  18 +++
 .claude/settings.json                          |   6 +-
 CLAUDE.md                                      |  14 +++
 TASKS.md                                       |   4 +-
 TASKS_ARCHIVE.md                               |   6 +
 apps/egos-gateway/openapi.yaml                 |  19 ++-
 apps/egos-gateway/src/channels/guard-brasil.ts |   4 +-
 apps/egos-gateway/src/orchestrator.ts          |   6 +-
 apps/egos-landing/public/timeline/rss          |   2 +-
 apps/egos-landing/public/timeline/rss.xml      |   2 +-
 docs/_inbox/ingest/README.md                   |  32 +++++
 docs/jobs/2026-06-08-doc-drift-verifier.json   |   6 +-
 docs/jobs/2026-06-08-pre-commit-pipeline.json  |  40 +++++++
 docs/presentations/mf-certificados-piloto.html | 154 +++++++++++--------------
 15 files changed, 217 insertions(+), 112 deletions(-)
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
diff --git a/CLAUDE.md b/CLAUDE.md
index 39ded78a..c71ea576 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -145,6 +145,20 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 2. Cliente quer resolver isso agora
 3. EGOS é o fit certo (e não algo mais simples)
 
+**Conteúdo de material diagnóstico (HTML/slides/doc):**
+
+| INCLUIR | PROIBIDO antes do diagnóstico |
+|---------|-------------------------------|
+| O que já existe e funciona (REAL, com evidência) | Prazo estimado de implantação |
+| Conceitos e como a tecnologia funciona | Custo de infraestrutura prometido |
+| Capacidades do sistema (o que pode fazer) | Decisões técnicas inferidas (ex: "CPF nunca vai ao LLM") |
+| Perguntas de diagnóstico para o cliente responder | Escopo de projeto assumido |
+| Dois cenários de trade-off (cliente escolhe) | ROI, economia, % de automação prometida |
+| Pesquisa recente com fonte e data | Timeline de "X dias para ir ao ar" |
+
+Tom correto: "Aqui está o que temos e sabemos. Você decide se faz sentido para você."
+Tom errado: "Vamos fazer X em Y dias por R$Z para resolver seu problema W."
+
 ---
 
 ## Token Economy [T2]
diff --git a/TASKS.md b/TASKS.md
index 84d959e6..1e20e0d0 100644
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
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index 93a8c16a..103d1bd5 100644
--- a/docs/presentations/mf-certificados-piloto.html
+++ b/docs/presentations/mf-certificados-piloto.html
@@ -236,10 +236,10 @@ tr:hover td { background: var(--bg); }
 
 <div class="top-header">
   <h1>MF Certificados × EGOS</h1>
-  <span class="meta">Piloto WhatsApp — Proposta Técnica 2026-06-08</span>
+  <span class="meta">Diagnóstico — Agente WhatsApp · 2026-06-09</span>
   <div class="header-btns">
     <button onclick="document.body.classList.toggle('dark')">Modo Escuro</button>
-    <span class="badge badge-blue">PILOTO</span>
+    <span class="badge badge-green">DIAGNÓSTICO</span>
   </div>
 </div>
 
@@ -250,17 +250,17 @@ tr:hover td { background: var(--bg); }
   <div class="sidebar-block">Visão Geral</div>
   <a class="sidebar-link" href="#resumo">Resumo executivo</a>
   <a class="sidebar-link" href="#hoje">O que já existe hoje</a>
-  <a class="sidebar-link" href="#proposta">O que construímos juntos</a>
+  <a class="sidebar-link" href="#proposta">Capacidades disponíveis</a>
 
-  <div class="sidebar-block">Arquitetura</div>
+  <div class="sidebar-block">Como funciona</div>
   <a class="sidebar-link" href="#fluxo">Fluxo do cliente</a>
   <a class="sidebar-link" href="#privacidade">Segurança do CPF</a>
   <a class="sidebar-link" href="#compliance">Compliance LGPD</a>
 
-  <div class="sidebar-block">Piloto</div>
-  <a class="sidebar-link" href="#cronograma">Cronograma 30 dias</a>
-  <a class="sidebar-link" href="#metricas">Métricas de sucesso</a>
-  <a class="sidebar-link" href="#decisoes">Decisões necessárias</a>
+  <div class="sidebar-block">Diagnóstico</div>
+  <a class="sidebar-link" href="#decisoes">3 perguntas</a>
+  <a class="sidebar-link" href="#cronograma">Piloto (se fizer sentido)</a>
+  <a class="sidebar-link" href="#metricas">Como medir sucesso</a>
 
   <div class="sidebar-block">Referência</div>
   <a class="sidebar-link" href="#o-que-nao">O que NÃO inclui</a>
@@ -273,26 +273,15 @@ tr:hover td { background: var(--bg); }
 
 <!-- HERO -->
 <div class="hero" id="resumo">
-  <h1>Agente WhatsApp para a MF Certificados</h1>
-  <p>Automatizar o atendimento no WhatsApp — agendamentos de videoconferência, status de pedidos e coleta de documentos — sem tocar na infraestrutura ICP-Brasil.</p>
-  <div class="hero-meta">
-    <span class="hero-chip">✓ Infraestrutura pronta</span>
-    <span class="hero-chip">✓ Em produção em outro cliente</span>
-    <span class="hero-chip">✓ CPF nunca vai ao LLM</span>
-    <span class="hero-chip">~2 semanas para ir ao ar</span>
-  </div>
+  <h1>Agente WhatsApp — o que o EGOS já sabe fazer</h1>
+  <p>Apresentação do que existe em produção hoje, como a tecnologia funciona, e três perguntas para entender juntos se faz sentido para a MF Certificados. Nada aqui é proposta fechada — é diagnóstico.</p>
 </div>
 
-<div class="grid-2">
-  <div class="mini-card">
-    <h3>Tempo estimado de implantação</h3>
-    <p class="num">14 dias</p>
-    <p style="font-size:13px; color:var(--muted)">Da configuração ao primeiro cliente real respondido pelo agente</p>
-  </div>
-  <div class="mini-card">
-    <h3>Custo de infraestrutura adicional</h3>
-    <p class="num">≈ R$0</p>
-    <p style="font-size:13px; color:var(--muted)">Reutiliza a infraestrutura EGOS/Hermes já em operação</p>
+<div class="card" style="border-left:4px solid var(--accent)">
+  <div class="card-body">
+    <p style="font-size:14px; color:var(--muted); margin:0">
+      <strong>Como ler este material:</strong> abaixo está o que já construímos e validamos em outro cliente, os conceitos por trás, e as capacidades do sistema. <strong>Não estamos assumindo o que vocês precisam</strong> — prazo, custo e escopo só fazem sentido depois que entendermos a operação de vocês. Por isso o material termina com três perguntas.
+    </p>
   </div>
 </div>
 
@@ -340,50 +329,44 @@ tr:hover td { background: var(--bg); }
 <!-- PROPOSTA -->
 <div class="card card-blue" id="proposta">
   <div class="card-header">
-    <h2>🔧 O que construímos para a MF Certificados</h2>
-    <span class="badge badge-blue">PILOTO</span>
+    <h2>🔧 Capacidades que o sistema pode oferecer</h2>
+    <span class="badge badge-blue">DISPONÍVEL</span>
   </div>
   <div class="card-body">
-    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">O que é específico para certificados digitais e precisa ser implementado:</p>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">O que o EGOS é capaz de fazer em um cenário de certificação digital. Cada item é uma <strong>capacidade existente</strong> — quais delas fazem sentido para a MF Certificados é parte do que queremos descobrir juntos, não algo que assumimos.</p>
 
     <table>
       <tr>
-        <th>Item</th>
-        <th>Descrição</th>
-        <th>Estimativa</th>
+        <th>Capacidade</th>
+        <th>O que faz</th>
       </tr>
       <tr>
-        <td><strong>Tenant MF Certificados</strong></td>
-        <td>Configuração do sistema prompt específico para fluxos de certificação — tom, regras, perguntas proibidas</td>
-        <td>2h</td>
+        <td><strong>Configuração por tenant</strong></td>
+        <td>Cada cliente tem seu próprio sistema prompt — tom, regras, perguntas que o agente nunca faz. Configuração, não código novo.</td>
       </tr>
       <tr>
-        <td><strong>Pseudonimização do CPF</strong></td>
-        <td>O CPF é extraído antes do LLM e substituído por um token. O modelo nunca vê o número real. (Explicado em detalhe na seção Segurança)</td>
-        <td>3h</td>
+        <td><strong>Proteção de dados sensíveis</strong></td>
+        <td>O CPF pode ser pseudonimizado antes de chegar ao modelo (Cenário B) ou trafegar normalmente (Cenário A). A escolha é do cliente — detalhada na seção Segurança.</td>
       </tr>
       <tr>
-        <td><strong>Ferramentas de certificação</strong></td>
-        <td>Consulta de status de pedido, agendamento de videoconferência, lista de documentos necessários por tipo de certificado</td>
-        <td>4–8h</td>
+        <td><strong>Ferramentas de atendimento</strong></td>
+        <td>Consulta de status de pedido, agendamento de videoconferência, lista de documentos por tipo de certificado — integráveis a sistemas externos.</td>
       </tr>
       <tr>
-        <td><strong>Testes de jornada</strong></td>
-        <td>Cenários: novo pedido, reenvio de documentos, reagendamento, certificado com erro — 10 casos de ouro</td>
-        <td>3h</td>
+        <td><strong>Jornadas testadas (casos de ouro)</strong></td>
+        <td>O sistema valida cenários como novo pedido, reenvio de documentos, reagendamento e erro de certificado antes de ir ao ar.</td>
       </tr>
       <tr>
-        <td><strong>Deploy + monitoramento</strong></td>
-        <td>Subir com variáveis de ambiente corretas, smoke test, alertas Telegram para erros críticos</td>
-        <td>2h</td>
+        <td><strong>Monitoramento e escalada</strong></td>
+        <td>Smoke test no deploy, alertas para erros críticos, e escalada para atendimento humano quando o agente não resolve.</td>
       </tr>
     </table>
 
     <div class="callout callout-green" style="margin-top:16px">
       <span class="callout-icon">💡</span>
       <div class="callout-body">
-        <strong>Total estimado: 14–18h de implementação</strong>
-        A maior parte é configuração e testes — não desenvolvimento de nova infraestrutura. O risco técnico é baixo porque a base já funciona em produção.
+        <strong>Nenhuma destas capacidades é obrigatória.</strong>
+        São peças que já existem e funcionam. O diagnóstico serve justamente para entender quais resolvem uma dor real da MF Certificados — e quais não fazem sentido para a operação de vocês. Prazo e custo só entram depois dessa conversa.
       </div>
     </div>
   </div>
@@ -584,9 +567,16 @@ tr:hover td { background: var(--bg); }
 <!-- CRONOGRAMA -->
 <div class="card card-blue" id="cronograma">
   <div class="card-header">
-    <h2>📅 Cronograma do piloto (30 dias)</h2>
+    <h2>📅 Como um piloto poderia ser estruturado</h2>
+    <span class="badge badge-blue">SE FIZER SENTIDO</span>
   </div>
   <div class="card-body">
+    <div class="callout callout-blue" style="margin-bottom:16px">
+      <span class="callout-icon">ℹ️</span>
+      <div class="callout-body">
+        <strong>Isto não é um cronograma fechado.</strong> É um exemplo de como um piloto costuma se organizar — apresentado só para dar previsibilidade. Os prazos reais dependem do que o diagnóstico revelar sobre a operação de vocês. Nada começa antes de responder as 3 perguntas e confirmar que há um problema que vale resolver.
+      </div>
+    </div>
     <div class="timeline">
       <div class="tl-item">
         <div class="tl-dot tl-dot-blue">1</div>
@@ -622,10 +612,11 @@ tr:hover td { background: var(--bg); }
 <!-- MÉTRICAS -->
 <div class="card card-green" id="metricas">
   <div class="card-header">
-    <h2>📊 Como medimos sucesso</h2>
+    <h2>📊 Como o sucesso poderia ser medido</h2>
+    <span class="badge badge-green">EXEMPLO</span>
   </div>
   <div class="card-body">
-    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Métricas objetivas ao final de 30 dias. Nenhuma é "satisfação do Enio" — são dados verificáveis.</p>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Exemplos de métricas objetivas e verificáveis — não "achismo". As metas reais e quais métricas importam dependem do fluxo que escolhermos juntos no diagnóstico.</p>
 
     <table>
       <tr>
@@ -666,8 +657,8 @@ tr:hover td { background: var(--bg); }
 
 <!-- DECISÕES -->
 <div class="decision-box" id="decisoes">
-  <h3>⚡ 3 perguntas que precisamos responder antes de começar</h3>
-  <p style="font-size:13px; color:var(--muted); margin-bottom:16px">Estas perguntas definem o escopo do piloto. Sem elas, a implementação começa no ponto errado.</p>
+  <h3>⚡ 3 perguntas para entendermos juntos</h3>
+  <p style="font-size:13px; color:var(--muted); margin-bottom:16px">Estas são as perguntas centrais do diagnóstico. As respostas dizem se há um problema real, se vale resolver agora, e qual caminho faz sentido — ou se o EGOS sequer é o encaixe certo para vocês. Sem elas, qualquer proposta seria chute.</p>
 
   <div class="decision-q">
     <p>1. Qual é o fluxo que mais dói hoje no WhatsApp?</p>
@@ -703,10 +694,10 @@ tr:hover td { background: var(--bg); }
 <!-- O QUE NÃO INCLUI -->
 <div class="card card-purple" id="o-que-nao">
   <div class="card-header">
-    <h2>🚫 O que o piloto NÃO inclui</h2>
+    <h2>🚫 O que normalmente fica fora de um primeiro passo</h2>
   </div>
   <div class="card-body">
-    <p style="font-size:14px; color:var(--muted); margin-bottom:12px">Escopo honesto — o que fica para uma segunda fase (se o piloto provar valor):</p>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:12px">Honestidade de escopo — coisas que costumam ficar para uma fase posterior, caso haja fase posterior. Não são limitações do sistema; são escolhas de não morder demais de uma vez:</p>
 
     <table>
       <tr>
@@ -740,44 +731,29 @@ tr:hover td { background: var(--bg); }
 <!-- PRÓXIMOS PASSOS -->
 <div class="card card-blue" id="proximos">
   <div class="card-header">
-    <h2>▶ Próximos passos concretos</h2>
+    <h2>▶ O único próximo passo</h2>
   </div>
   <div class="card-body">
-    <div class="timeline">
-      <div class="tl-item">
-        <div class="tl-dot tl-dot-orange">!</div>
-        <div class="tl-label">Esta semana (você)</div>
-        <div class="tl-title">Responder as 3 perguntas acima</div>
-        <div class="tl-desc">15 minutos de conversa define o escopo do piloto. Pode ser por WhatsApp, ligação ou presencialmente.</div>
-      </div>
-
-      <div class="tl-item">
-        <div class="tl-dot tl-dot-blue">1</div>
-        <div class="tl-label">Próxima semana (EGOS)</div>
-        <div class="tl-title">Configuração do ambiente MF Certificados</div>
-        <div class="tl-desc">Tenant configurado, pseudonimização implementada, system prompt revisado com você, ambiente de testes pronto.</div>
-      </div>
-
-      <div class="tl-item">
-        <div class="tl-dot tl-dot-green">2</div>
-        <div class="tl-label">Semana 2 (juntos)</div>
-        <div class="tl-title">Sessão de validação interna</div>
-        <div class="tl-desc">Você e sua equipe testam o agente antes de qualquer cliente real. Ajustamos o que não fizer sentido.</div>
-      </div>
-
-      <div class="tl-item">
-        <div class="tl-dot tl-dot-purple">3</div>
-        <div class="tl-label">Semana 3 em diante</div>
-        <div class="tl-title">Primeiros clientes reais</div>
-        <div class="tl-desc">Começamos com volume pequeno e controlado. Os dados guiam a expansão — não o entusiasmo.</div>
+    <div class="callout callout-green" style="margin-bottom:16px">
+      <span class="callout-icon">✓</span>
+      <div class="callout-body">
+        <strong>Uma conversa de 15 minutos.</strong>
+        Responder as 3 perguntas acima — por WhatsApp, ligação ou presencialmente. Nada além disso está combinado, e nada precisa estar. A conversa diz se há um problema que vale resolver, e se o EGOS é o encaixe. Só então faz sentido falar de piloto, prazo ou custo.
       </div>
     </div>
 
-    <div class="callout callout-green" style="margin-top:8px">
-      <span class="callout-icon">✓</span>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:8px"><strong>Se, e só se, a conversa mostrar que faz sentido</strong>, um caminho possível seria:</p>
+    <ul style="font-size:14px; color:var(--muted); line-height:1.8">
+      <li>Configurar um ambiente de teste com o fluxo que mais dói</li>
+      <li>Vocês e a equipe validam internamente, antes de qualquer cliente real</li>
+      <li>Começar com volume pequeno e controlado — os dados guiam a expansão, não o entusiasmo</li>
+    </ul>
+
+    <div class="callout callout-blue" style="margin-top:16px">
+      <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
-        <strong>Sem lock-in.</strong>
-        O piloto termina com evidências verificáveis. Se as métricas não baterem, encerramos limpo. Se baterem, decidimos juntos o que vem depois.
+        <strong>Sem lock-in, sem compromisso a partir deste material.</strong>
+        Este documento é diagnóstico gratuito. Se nada aqui fizer sentido para a operação de vocês, foi tempo bem gasto mesmo assim — vocês saem sabendo o que a tecnologia faz e o que não faz.
       </div>
     </div>
   </div>
@@ -790,7 +766,7 @@ tr:hover td { background: var(--bg); }
     <span class="badge badge-green">PRONTO</span>
   </div>
   <div class="card-body">
-    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Conteúdo gerado pelo NotebookLM a partir desta proposta. Útil para ouvir no carro ou compartilhar com sócios antes de uma reunião.</p>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Conteúdo gerado pelo NotebookLM a partir deste diagnóstico. Útil para ouvir no carro ou compartilhar com sócios antes de uma reunião.</p>
 
     <div style="background:var(--bg); border:1px solid var(--border); border-radius:10px; padding:16px; margin-bottom:16px;">
       <div style="font-size:12px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:8px">🎙️ Áudio Overview — PT-BR</div>

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "find apps/egos-gateway -maxdepth 3 -type f | sort | sed -n '1,120p'; grep -R \"gem-hunter\\|/learn\\|record a new learning\\|latest\" -n apps/egos-gateway/src apps/egos-gateway/openapi.yaml | head -100" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/.dockerignore
apps/egos-gateway/Dockerfile
apps/egos-gateway/README.md
apps/egos-gateway/bun.lock
apps/egos-gateway/docker-compose.yml
apps/egos-gateway/guardrails.yaml
apps/egos-gateway/node_modules/bun-types/CLAUDE.md
apps/egos-gateway/node_modules/bun-types/README.md
apps/egos-gateway/node_modules/bun-types/bun.d.ts
apps/egos-gateway/node_modules/bun-types/bun.ns.d.ts
apps/egos-gateway/node_modules/bun-types/bundle.d.ts
apps/egos-gateway/node_modules/bun-types/deprecated.d.ts
apps/egos-gateway/node_modules/bun-types/devserver.d.ts
apps/egos-gateway/node_modules/bun-types/extensions.d.ts
apps/egos-gateway/node_modules/bun-types/fetch.d.ts
apps/egos-gateway/node_modules/bun-types/ffi.d.ts
apps/egos-gateway/node_modules/bun-types/globals.d.ts
apps/egos-gateway/node_modules/bun-types/html-rewriter.d.ts
apps/egos-gateway/node_modules/bun-types/index.d.ts
apps/egos-gateway/node_modules/bun-types/jsc.d.ts
apps/egos-gateway/node_modules/bun-types/jsx.d.ts
apps/egos-gateway/node_modules/bun-types/overrides.d.ts
apps/egos-gateway/node_modules/bun-types/package.json
apps/egos-gateway/node_modules/bun-types/redis.d.ts
apps/egos-gateway/node_modules/bun-types/s3.d.ts
apps/egos-gateway/node_modules/bun-types/security.d.ts
apps/egos-gateway/node_modules/bun-types/serve.d.ts
apps/egos-gateway/node_modules/bun-types/shell.d.ts
apps/egos-gateway/node_modules/bun-types/sql.d.ts
apps/egos-gateway/node_modules/bun-types/sqlite.d.ts
apps/egos-gateway/node_modules/bun-types/test-globals.d.ts
apps/egos-gateway/node_modules/bun-types/test.d.ts
apps/egos-gateway/node_modules/bun-types/wasm.d.ts
apps/egos-gateway/node_modules/undici-types/LICENSE
apps/egos-gateway/node_modules/undici-types/README.md
apps/egos-gateway/node_modules/undici-types/agent.d.ts
apps/egos-gateway/node_modules/undici-types/api.d.ts
apps/egos-gateway/node_modules/undici-types/balanced-pool.d.ts
apps/egos-gateway/node_modules/undici-types/cache-interceptor.d.ts
apps/egos-gateway/node_modules/undici-types/cache.d.ts
apps/egos-gateway/node_modules/undici-types/client-stats.d.ts
apps/egos-gateway/node_modules/undici-types/client.d.ts
apps/egos-gateway/node_modules/undici-types/connector.d.ts
apps/egos-gateway/node_modules/undici-types/content-type.d.ts
apps/egos-gateway/node_modules/undici-types/cookies.d.ts
apps/egos-gateway/node_modules/undici-types/diagnostics-channel.d.ts
apps/egos-gateway/node_modules/undici-types/dispatcher.d.ts
apps/egos-gateway/node_modules/undici-types/env-http-proxy-agent.d.ts
apps/egos-gateway/node_modules/undici-types/errors.d.ts
apps/egos-gateway/node_modules/undici-types/eventsource.d.ts
apps/egos-gateway/node_modules/undici-types/fetch.d.ts
apps/egos-gateway/node_modules/undici-types/formdata.d.ts
apps/egos-gateway/node_modules/undici-types/global-dispatcher.d.ts
apps/egos-gateway/node_modules/undici-types/global-origin.d.ts
apps/egos-gateway/node_modules/undici-types/h2c-client.d.ts
apps/egos-gateway/node_modules/undici-types/handlers.d.ts
apps/egos-gateway/node_modules/undici-types/header.d.ts
apps/egos-gateway/node_modules/undici-types/index.d.ts
apps/egos-gateway/node_modules/undici-types/interceptors.d.ts
apps/egos-gateway/node_modules/undici-types/mock-agent.d.ts
apps/egos-gateway/node_modules/undici-types/mock-call-history.d.ts
apps/egos-gateway/node_modules/undici-types/mock-client.d.ts
apps/egos-gateway/node_modules/undici-types/mock-errors.d.ts
apps/egos-gateway/node_modules/undici-types/mock-interceptor.d.ts
apps/egos-gateway/node_modules/undici-types/mock-pool.d.ts
apps/egos-gateway/node_modules/undici-types/package.json
apps/egos-gateway/node_modules/undici-types/patch.d.ts
apps/egos-gateway/node_modules/undici-types/pool-stats.d.ts
apps/egos-gateway/node_modules/undici-types/pool.d.ts
apps/egos-gateway/node_modules/undici-types/proxy-agent.d.ts
apps/egos-gateway/node_modules/undici-types/readable.d.ts
apps/egos-gateway/node_modules/undici-types/retry-agent.d.ts
apps/egos-gateway/node_modules/undici-types/retry-handler.d.ts
apps/egos-gateway/node_modules/undici-types/round-robin-pool.d.ts
apps/egos-gateway/node_modules/undici-types/snapshot-agent.d.ts
apps/egos-gateway/node_modules/undici-types/util.d.ts
apps/egos-gateway/node_modules/undici-types/utility.d.ts
apps/egos-gateway/node_modules/undici-types/webidl.d.ts
apps/egos-gateway/node_modules/undici-types/websocket.d.ts
apps/egos-gateway/openapi.yaml
apps/egos-gateway/package.json
apps/egos-gateway/scripts/smoke-cross-tenant.sh
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
apps/egos-gateway/src/tenants/index.ts
apps/egos-gateway/supabase/migrations/001_g_pecas_demo.sql
apps/egos-gateway/tsconfig.json
apps/egos-gateway/src/health-monitor.ts:69:    pingUrl(`${GW_INTERNAL}/gem-hunter/health`).then(r => ({ name: "Gem Hunter", ...r })),
apps/egos-gateway/src/server.ts:11: *   GET  /gem-hunter/*          — Gem Hunter API (discovery engine)
apps/egos-gateway/src/server.ts:25:import { gemHunter } from "./channels/gem-hunter-api.js";
apps/egos-gateway/src/server.ts:48:    channels: ["whatsapp", "telegram", "knowledge", "gem-hunter", "guard-brasil-x402", "api-mestra-v1"],
apps/egos-gateway/src/server.ts:55:      "gem-hunter": "/gem-hunter/product",
apps/egos-gateway/src/server.ts:66:app.route("/gem-hunter", gemHunter);
apps/egos-gateway/src/server.ts:99:console.log(`[egos-gateway] Gem Hunter:  http://localhost:${PORT}/gem-hunter/health`);
apps/egos-gateway/src/orchestrator.ts:285:    const res = await fetch(`${GW}/gem-hunter/health`, { signal: AbortSignal.timeout(3000) });
apps/egos-gateway/src/orchestrator.ts:357:      ? `${GW}/gem-hunter/sector/${sector}`
apps/egos-gateway/src/orchestrator.ts:358:      : `${GW}/gem-hunter/latest?limit=5`;
apps/egos-gateway/src/orchestrator.ts:360:    if (!res.ok) return "💎 Gem Hunter sem dados. Rode: bun agent:run gem-hunter --exec";
apps/egos-gateway/src/orchestrator.ts:376:    const res = await fetch(`${GW}/gem-hunter/trending`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:380:    if (!gems.length) return "Sem trending (precisa de 2+ runs do gem-hunter).";
apps/egos-gateway/src/channels/gem-hunter-api.ts:5: * Backed by pre-computed reports (latest-run.json, SQLite history).
apps/egos-gateway/src/channels/gem-hunter-api.ts:8: *   GET  /gem-hunter/topics        — list all search topic categories
apps/egos-gateway/src/channels/gem-hunter-api.ts:9: *   GET  /gem-hunter/latest        — latest run: top gems by score
apps/egos-gateway/src/channels/gem-hunter-api.ts:10: *   GET  /gem-hunter/reports       — list available report files
apps/egos-gateway/src/channels/gem-hunter-api.ts:11: *   GET  /gem-hunter/sector/:name  — filter latest results by sector keyword
apps/egos-gateway/src/channels/gem-hunter-api.ts:12: *   GET  /gem-hunter/trending      — trending from SQLite history (multi-run)
apps/egos-gateway/src/channels/gem-hunter-api.ts:13: *   GET  /gem-hunter/health        — API health + last run info
apps/egos-gateway/src/channels/gem-hunter-api.ts:32:const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
apps/egos-gateway/src/channels/gem-hunter-api.ts:33:const LATEST_RUN_PATH = join(REPORTS_DIR, "latest-run.json");
apps/egos-gateway/src/channels/gem-hunter-api.ts:236:// ── Static topic definitions (mirrors gem-hunter.ts DEFAULT_QUERIES categories) ──
apps/egos-gateway/src/channels/gem-hunter-api.ts:278:      upgrade: "https://gateway.egos.ia.br/gem-hunter/product",
apps/egos-gateway/src/channels/gem-hunter-api.ts:290:gemHunter.use("/latest", authMiddleware);
apps/egos-gateway/src/channels/gem-hunter-api.ts:301:    service: "gem-hunter-api",
apps/egos-gateway/src/channels/gem-hunter-api.ts:308:    docs: "/gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:333:gemHunter.get("/latest", (c) => {
apps/egos-gateway/src/channels/gem-hunter-api.ts:335:  if (!run) return c.json({ error: "No latest run found. Run: bun agent:run gem-hunter --exec" }, 404);
apps/egos-gateway/src/channels/gem-hunter-api.ts:414:    return c.json({ message: "No history database yet — run gem-hunter a few times to build trends", trending: [] });
apps/egos-gateway/src/channels/gem-hunter-api.ts:466:      topics: "GET /gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:467:      latest: "GET /gem-hunter/latest?sector=ai&limit=20",
apps/egos-gateway/src/channels/gem-hunter-api.ts:468:      sector: "GET /gem-hunter/sector/{ai|crypto|systems|agents|governance|research}",
apps/egos-gateway/src/channels/gem-hunter-api.ts:469:      trending: "GET /gem-hunter/trending",
apps/egos-gateway/src/channels/gem-hunter-api.ts:470:      reports: "GET /gem-hunter/reports",
apps/egos-gateway/src/channels/knowledge.ts:12: *   GET  /learnings          — list learnings (filterable)
apps/egos-gateway/src/channels/knowledge.ts:13: *   POST /learnings          — record a new learning
apps/egos-gateway/src/channels/knowledge.ts:138:knowledge.get("/learnings", async (c) => {
apps/egos-gateway/src/channels/knowledge.ts:155:knowledge.post("/learnings", async (c) => {
apps/egos-gateway/src/channels/ui.ts:225:  const url = BASE + '/knowledge/learnings?limit=9' + (domain ? '&domain=' + domain : '');
apps/egos-gateway/src/channels/ui.ts:321:ui.get("/gem-hunter", async (c) => {
apps/egos-gateway/src/channels/telegram.ts:441:      // Trigger gem hunt via gem-hunter server — fire-and-forget
apps/egos-gateway/openapi.yaml:36:  - name: gem-hunter
apps/egos-gateway/openapi.yaml:222:  /knowledge/learnings:
apps/egos-gateway/openapi.yaml:255:  /gem-hunter/latest:
apps/egos-gateway/openapi.yaml:257:      tags: [gem-hunter]
apps/egos-gateway/openapi.yaml:258:      summary: List latest discovered GitHub gems

exec
/bin/bash -lc "sed -n '250,360p' apps/egos-gateway/src/channels/gem-hunter-api.ts; sed -n '130,180p' apps/egos-gateway/src/channels/knowledge.ts; sed -n '1,120p' apps/egos-gateway/openapi.yaml; sed -n '210,280p' apps/egos-gateway/openapi.yaml" in /home/enio/egos
 succeeded in 0ms:
  { sector: "research", name: "Academic Research / arXiv", description: "Latest papers from arXiv" },
  { sector: "research", name: "Early Warning — Researcher Launches (Day 0)", description: "New repos from researchers" },
  { sector: "crypto", name: "Blockchain / x402 / On-Chain Payments", description: "Web3, DeFi, and payment protocols" },
  { sector: "governance", name: "Strategic MCP Servers / Governance", description: "MCP servers for governance and compliance" },
  { sector: "governance", name: "A2A Agent Cards / Interoperability", description: "Agent interoperability standards" },
  { sector: "governance", name: "Strategic Signals / MCP + A2A + OpenClaw", description: "Strategic positioning signals" },
  { sector: "systems", name: "Local Research / Self-Hosted Search", description: "Self-hosted search and RAG tools" },
  { sector: "systems", name: "Web Extraction / Rendered Capture", description: "Scraping, crawling, content extraction" },
  { sector: "ai", name: "ProductHunt AI Developer Tools", description: "Latest AI tools on ProductHunt" },
  { sector: "ai", name: "Community Signals / Reddit Discussions", description: "Reddit discussions on AI/dev" },
];

// ── Auth + Rate Limit Middleware ───────────────────────────────────────────────

const authMiddleware: MiddlewareHandler<{ Variables: { tierCtx: TierContext } }> = async (c, next) => {
  const ip = c.req.header("x-forwarded-for")?.split(",")[0]?.trim() ?? c.req.header("x-real-ip") ?? "unknown";
  const auth = c.req.header("authorization");
  const ctx = await resolveTier(auth, ip);

  const { allowed, count } = await checkAndIncrementUsage(ctx.keyId, ctx.ip, ctx.requestsPerDay);

  if (!allowed) {
    return c.json({
      error: "rate_limit_exceeded",
      message: `Daily limit of ${ctx.requestsPerDay} requests reached for ${ctx.tier} tier. Resets at midnight UTC.`,
      tier: ctx.tier,
      limit: ctx.requestsPerDay,
      used: count,
      upgrade: "https://gateway.egos.ia.br/gem-hunter/product",
    }, 429);
  }

  c.set("tierCtx", ctx);
  c.header("X-RateLimit-Tier", ctx.tier);
  c.header("X-RateLimit-Limit", String(ctx.requestsPerDay));
  c.header("X-RateLimit-Used", String(count));

  await next();
};

gemHunter.use("/latest", authMiddleware);
gemHunter.use("/sector/*", authMiddleware);
gemHunter.use("/trending", authMiddleware);
gemHunter.use("/reports", authMiddleware);

// ── Routes ────────────────────────────────────────────────────────────────────

// Health
gemHunter.get("/health", (c) => {
  const run = readLatestRun();
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
            type: string
          example: "guard-brasil-api"
      responses:
        "200":
          description: Full page content
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/WikiPage"
        "404":
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

exec
/bin/bash -lc "grep -n \"bearerAuth\\|components:\" -n apps/egos-gateway/openapi.yaml; sed -n '280,420p' apps/egos-gateway/openapi.yaml; sed -n '1,80p' apps/egos-gateway/src/channels/knowledge.ts; sed -n '180,210p' apps/egos-gateway/src/channels/knowledge.ts" in /home/enio/egos
 succeeded in 0ms:
233:        - bearerAuth: []
285:components:
407:    bearerAuth:
      summary: Gateway health
      responses:
        "200":
          description: Healthy

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

exec
/bin/bash -lc "git show 84130718805a5e2b1dfb59fa9ea6059d00309e26:apps/egos-gateway/openapi.yaml | sed -n '220,275p'; git show 84130718805a5e2b1dfb59fa9ea6059d00309e26:apps/egos-gateway/openapi.yaml | grep -n \"gem-hunter\" -A35" in /home/enio/egos
 succeeded in 0ms:
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
  /gem-hunter/gems:
    get:
      tags: [gem-hunter]
      summary: List discovered GitHub gems
      parameters:
        - name: sector
          in: query
          schema:
            type: string
          example: "lgpd"
        - name: min_score
          in: query
          schema:
            type: integer
            default: 70
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        "200":
          description: Gem list
36:  - name: gem-hunter
37-    description: GitHub Gem Hunter intelligence (trending repos, scoring)
38-  - name: health
39-    description: System health and metadata
40-
41-paths:
42-  # ── Guard Brasil ────────────────────────────────────────────────────────────
43-  /guard-brasil/health:
44-    get:
45-      tags: [guard-brasil]
46-      summary: Guard Brasil health check
47-      description: Returns API status and available PII patterns. Free endpoint.
48-      responses:
49-        "200":
50-          description: API is healthy
51-          content:
52-            application/json:
53-              schema:
54-                type: object
55-                properties:
56-                  status:
57-                    type: string
58-                    example: ok
59-                  patterns:
60-                    type: integer
61-                    description: Number of active PII detection patterns
62-                    example: 16
63-                  version:
64-                    type: string
65-                    example: "0.2.3"
66-
67-  /guard-brasil/meta:
68-    get:
69-      tags: [guard-brasil]
70-      summary: Guard Brasil metadata
71-      description: Returns PII pattern list, categories, and pricing info.
--
253:  /gem-hunter/gems:
254-    get:
255:      tags: [gem-hunter]
256-      summary: List discovered GitHub gems
257-      parameters:
258-        - name: sector
259-          in: query
260-          schema:
261-            type: string
262-          example: "lgpd"
263-        - name: min_score
264-          in: query
265-          schema:
266-            type: integer
267-            default: 70
268-        - name: limit
269-          in: query
270-          schema:
271-            type: integer
272-            default: 20
273-      responses:
274-        "200":
275-          description: Gem list
276-
277-  # ── Health ──────────────────────────────────────────────────────────────────
278-  /health:
279-    get:
280-      tags: [health]
281-      summary: Gateway health
282-      responses:
283-        "200":
284-          description: Healthy
285-
286-components:
287-  schemas:
288-    InspectRequest:
289-      type: object
290-      required: [text]

exec
/bin/bash -lc "grep -R \"PRICE_PER_CALL\\|0.001\\|0.01\\|0.02\" -n apps/egos-gateway/src/channels/guard-brasil.ts apps/egos-gateway/README.md apps/egos-gateway/openapi.yaml | head -100" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/src/channels/guard-brasil.ts:10: *   POST /guard-brasil/inspect      — PII inspection ($0.001 USDC / call, Base chain)
apps/egos-gateway/src/channels/guard-brasil.ts:21: * Base network: https://base.org (L2, ~$0.00001/tx gas)
apps/egos-gateway/src/channels/guard-brasil.ts:27: *   - X402_PRICE_USDC_ATOMIC        — price per call in USDC atomic units (default 1000 = $0.001)
apps/egos-gateway/src/channels/guard-brasil.ts:30: *   $0.001 USDC/call = competitive with AWS Comprehend PII (~$0.0001/char × 10 chars avg)
apps/egos-gateway/src/channels/guard-brasil.ts:45:// Env-overridable pricing: USDC atomic units (6 decimals). 1000 = $0.001 per call.
apps/egos-gateway/src/channels/guard-brasil.ts:46:// Reference: AWS Comprehend PII ~$0.001/request; Guard Brasil goal: cost-covering + fair margin.
apps/egos-gateway/src/channels/guard-brasil.ts:47:const PRICE_PER_CALL_USDC_ATOMIC = Number(process.env.X402_PRICE_USDC_ATOMIC ?? "1000");
apps/egos-gateway/src/channels/guard-brasil.ts:91:        expectedAmount: PRICE_PER_CALL_USDC_ATOMIC.toString(),
apps/egos-gateway/src/channels/guard-brasil.ts:133:    price: `$${(PRICE_PER_CALL_USDC_ATOMIC / 1_000_000).toFixed(4)} USDC per call`,
apps/egos-gateway/src/channels/guard-brasil.ts:149:        price_per_call_usdc: PRICE_PER_CALL_USDC_ATOMIC / 1_000_000,
apps/egos-gateway/src/channels/guard-brasil.ts:176:      maxAmountRequired: PRICE_PER_CALL_USDC_ATOMIC.toString(),
apps/egos-gateway/src/channels/guard-brasil.ts:178:      description: "Guard Brasil PII inspection - $0.001 USDC on Base",
apps/egos-gateway/openapi.yaml:89:        **Pricing:** R$0.01/call (equivalent ~$0.001 USDC via x402).
apps/egos-gateway/openapi.yaml:397:          example: 0.001

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
exec
/bin/bash -lc "python3 - <<'PY'
import yaml
try:
 data=yaml.safe_load(open('apps/egos-gateway/openapi.yaml'))
 print('ok', data['openapi'])
 print(data['paths']['/knowledge/stats'])
except Exception as e:
 print('ERR',e)
PY" in /home/enio/egos
 succeeded in 0ms:
ok 3.1.0
{'get': {'tags': ['knowledge'], 'summary': 'Knowledge Base statistics', 'responses': {'200': {'description': 'KB stats', 'content': {'application/json': {'schema': {'type': 'object', 'properties': {'total_pages': {'type': 'integer'}, 'categories': {'type': 'array', 'items': {'type': 'string'}}, 'avg_quality': {'type': 'number'}}}}}}}}}

exec
/bin/bash -lc "nl -ba apps/egos-gateway/openapi.yaml | sed -n '225,240p'" in /home/enio/egos
 succeeded in 0ms:
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

exec
/bin/bash -lc 'cat .claude/settings.json' in /home/enio/egos
 succeeded in 0ms:
{
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "WebFetch",
      "WebSearch",
      "Agent",
      "Skill",
      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
      "Bash(echo \"EXIT: $?\")",
      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
      "Bash(cat)",
      "Bash(bash scripts/check-skills-drift.sh --fix)",
      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
      "mcp__notebooklm-mcp__studio_delete",
      "mcp__claude_ai_Supabase__execute_sql",
      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
      "mcp__claude_ai_Supabase__list_projects"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(rm -rf ~:*)",
      "Bash(dd if=:*)",
      "Bash(mkfs:*)"
    ],
    "defaultMode": "bypassPermissions",
    "additionalDirectories": [
      "/home/enio/egos/.claude/commands"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Grep|Glob|Read|Search",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/cbm-code-discovery-gate"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/pre-edit-safety"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/rm-guard"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/post-write-typecheck"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/tone-honesty-gate"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/budget-guard.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/session-status.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/frustration-detector"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/anti-compaction-guard"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/skill-auto-match"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/context-alarm.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {
    "codex@openai-codex": true
  },
  "extraKnownMarketplaces": {
    "openai-codex": {
      "source": {
        "source": "github",
        "repo": "openai/codex-plugin-cc"
      }
    }
  },
  "alwaysThinkingEnabled": true,
  "effortLevel": "medium",
  "skipDangerousModePermissionPrompt": true
}

exec
/bin/bash -lc 'cd apps/egos-gateway && bun tsc --noEmit' in /home/enio/egos
 succeeded in 2843ms:
exec
/bin/bash -lc 'grep -n "SECTOR_MAP" -A20 apps/egos-gateway/src/channels/gem-hunter-api.ts' in /home/enio/egos
 succeeded in 0ms:
204:const SECTOR_MAP: Record<string, string[]> = {
205-  ai: ["agents", "AI", "LLM", "GPT", "language model", "autonomous", "MCP", "orchestration"],
206-  crypto: ["blockchain", "crypto", "web3", "DeFi", "x402", "on-chain", "CoinGecko"],
207-  systems: ["systems dev", "runtime", "compiler", "bun", "typescript", "rust", "go"],
208-  agents: ["agent", "multi-agent", "tool use", "A2A", "MCP", "orchestration", "swarm"],
209-  governance: ["governance", "rules", "compliance", "SSOT", "audit", "policy"],
210-  research: ["arxiv", "paper", "academic", "research", "benchmark"],
211-};
212-
213-/** Sector aliases for API query normalization */
214-const SECTOR_ALIASES: Record<string, string> = {
215-  "ia": "ai",
216-  "inteligencia-artificial": "ai",
217-  "agentes": "agents",
218-  "orquestracao": "agents",
219-  "cripto": "crypto",
220-  "blockchain": "crypto",
221-  "governanca": "governance",
222-  "pesquisa": "research",
223-};
224-
--
227:  const keywords = SECTOR_MAP[normalizedSector];
228-  if (!keywords) return gems;
229-
230-  return gems.filter((g) => {
231-    const text = `${g.name} ${g.description} ${g.topic || ""} ${g.category || ""}`.toLowerCase();
232-    return keywords.some((kw) => text.includes(kw.toLowerCase()));
233-  });
234-}
235-
236-// ── Static topic definitions (mirrors gem-hunter.ts DEFAULT_QUERIES categories) ──
237-
238-const TOPICS = [
239-  { sector: "ai", name: "AI Agents / MCP / Tool Use", description: "LLM agents, tool calling, MCP servers" },
240-  { sector: "ai", name: "Agent Orchestration / Control Plane", description: "Multi-agent coordination, swarms, control planes" },
241-  { sector: "ai", name: "Autonomous Agents (Social + Ops)", description: "Social and operational autonomous agents" },
242-  { sector: "ai", name: "AI Report & Dashboard Generators", description: "AI-powered reporting and visualization" },
243-  { sector: "ai", name: "Multi-Agent Coordination / Chat Rooms", description: "Agent-to-agent communication protocols" },
244-  { sector: "ai", name: "Declarative Sub-Agents / Chains", description: "Declarative agent chaining patterns" },
245-  { sector: "ai", name: "AutoResearch / Autonomous Experiment Loops", description: "Self-directed research loops" },
246-  { sector: "ai", name: "Agent Safety / Red-Teaming", description: "Safety evaluation and adversarial testing" },
247-  { sector: "ai", name: "Agent Adapter / Polyglot Wrappers", description: "Cross-language agent adapters" },
--
307:    sectors: Object.keys(SECTOR_MAP),
308-    docs: "/gem-hunter/topics",
309-  });
310-});
311-
312-// List all topic categories
313-gemHunter.get("/topics", (c) => {
314-  const sectorFilter = c.req.query("sector");
315-  const topics = sectorFilter
316-    ? TOPICS.filter((t) => t.sector === sectorFilter.toLowerCase())
317-    : TOPICS;
318-
319-  const bySector: Record<string, typeof TOPICS> = {};
320-  for (const t of topics) {
321-    if (!bySector[t.sector]) bySector[t.sector] = [];
322-    bySector[t.sector].push(t);
323-  }
324-
325-  return c.json({
326-    total: topics.length,
327:    sectors: Object.keys(SECTOR_MAP),
328-    by_sector: bySector,
329-  });
330-});
331-
332-// Latest run — top gems
333-gemHunter.get("/latest", (c) => {
334-  const run = readLatestRun();
335-  if (!run) return c.json({ error: "No latest run found. Run: bun agent:run gem-hunter --exec" }, 404);
336-
337-  const tierCtx = c.get("tierCtx") as TierContext | undefined;
338-  const tierLimit = tierCtx?.resultsLimit ?? TIER_DEFAULTS.free.results_limit;
339-
340-  const requested = Math.min(Number(c.req.query("limit") || tierLimit), 100);
341-  const limit = Math.min(requested, tierLimit); // cap at tier's max
342-  const sector = c.req.query("sector");
343-
344-  let gems = run.gems || [];
345-  if (sector) gems = filterBySector(gems, sector);
346-
347-  // Sort by score descending
--
370:  if (!SECTOR_MAP[normalizedSector]) {
371:    return c.json({ error: `Unknown sector: ${sector}`, available: Object.keys(SECTOR_MAP) }, 400);
372-  }
373-
374-  const gems = filterBySector(run.gems || [], normalizedSector)
375-    .sort((a, b) => (b.score || 0) - (a.score || 0))
376-    .slice(0, tierLimit);
377-
378-  return c.json({
379-    sector: normalizedSector,
380-    date: run.date,
381-    tier: tierCtx?.tier ?? "free",
382-    results_limit: tierLimit,
383-    count: gems.length,
384-    gems,
385-  });
386-});
387-
388-// List reports
389-gemHunter.get("/reports", (c) => {
390-  if (!existsSync(REPORTS_DIR)) return c.json({ reports: [] });
391-
--
439:    sectors: Object.keys(SECTOR_MAP),
440-    sources: ["GitHub", "HuggingFace", "arXiv", "Exa", "Reddit", "StackOverflow", "ProductHunt", "X/Twitter", "npm", "GitLab", "CoinGecko", "DeFiLlama"],
441-    tiers: [
442-      {
443-        name: "Free",
444-        price: "R$0/mo",
445-        limits: { requests_per_day: 5, results_per_query: 5, sectors: ["ai"], sources: 2 },
446-      },
447-      {
448-        name: "Starter",
449-        price: "R$99/mo",
450-        limits: { requests_per_day: 50, results_per_query: 20, sectors: ["ai", "crypto", "systems"], sources: 6 },
451-        extras: ["email delivery", "trending alerts"],
452-      },
453-      {
454-        name: "Pro",
455-        price: "R$499/mo",
456-        limits: { requests_per_day: "unlimited", results_per_query: 100, sectors: "all", sources: "all" },
457-        extras: ["AI synthesis (Qwen)", "webhook delivery", "SQLite history export", "custom sectors", "priority support"],
458-      },
459-      {

codex
The patch introduces a security-contract mismatch: the API spec claims bearer authentication for a write endpoint, but the implementation remains unauthenticated. This should be corrected before considering the patch fully correct.

Review comment:

- [P2] Enforce bearer auth before documenting it — /home/enio/egos/apps/egos-gateway/openapi.yaml:232-233
  This adds `bearerAuth` to the OpenAPI contract for `POST /knowledge/learnings`, but the Hono route still accepts the POST without checking the `Authorization` header and writes through the Supabase service role. In deployments that rely on the OpenAPI spec for security review or client generation, this endpoint now appears protected while unauthenticated requests can still create learnings; either add middleware to the route or remove the security requirement until it is enforced.
The patch introduces a security-contract mismatch: the API spec claims bearer authentication for a write endpoint, but the implementation remains unauthenticated. This should be corrected before considering the patch fully correct.

Review comment:

- [P2] Enforce bearer auth before documenting it — /home/enio/egos/apps/egos-gateway/openapi.yaml:232-233
  This adds `bearerAuth` to the OpenAPI contract for `POST /knowledge/learnings`, but the Hono route still accepts the POST without checking the `Authorization` header and writes through the Supabase service role. In deployments that rely on the OpenAPI spec for security review or client generation, this endpoint now appears protected while unauthenticated requests can still create learnings; either add middleware to the route or remove the security requirement until it is enforced.
```
