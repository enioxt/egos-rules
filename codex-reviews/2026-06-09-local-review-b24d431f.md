# Codex Local Review — 2026-06-09T19:22:00Z

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
session id: 019eadd5-a78e-79b0-b2f8-86705ea28a75
--------
user
changes against 'HEAD~3'
2026-06-09T19:22:02.214027Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T19:22:02.227175Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 2def6c695a53a65c91594a7e23aa178c75bed396 --stat && git diff 2def6c695a53a65c91594a7e23aa178c75bed396' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |  5 +-
 TASKS_ARCHIVE.md                                   |  6 ++
 apps/egos-landing/public/timeline/rss              |  2 +-
 apps/egos-landing/public/timeline/rss.xml          |  2 +-
 .../handoff_2026-06-08.md                          |  0
 docs/_current_handoffs/handoff_2026-06-09.md       | 37 +++++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json       |  4 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json      | 88 ++++++++++++++++++++++
 8 files changed, 138 insertions(+), 6 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 8f4e0ebd..bd5a1850 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -22,6 +22,8 @@
 - [ ] **MCP-PESSOAL-ENIO-001** [P1] `prime`+`forja` — Consolidar núcleo curado de tools (10-20→30) num MCP autenticado (Bearer pessoal) bridgeado p/ ChatGPT Dev Mode. Núcleo: recon, readiness, guard_scan_pii, get_metaprompt, knowledge_search, memory_store/recall + egos_capture. Curadoria em andamento (workflow `wi5x1e8ue` → docs/strategy/MCP_PESSOAL_ENIO_CURADORIA.md). NÃO é público — é pessoal autenticado.
 - [ ] **EGOS-CAPTURE-001** [P1] `forja` — Tool `egos_capture`: salva conversa do ChatGPT de volta no EGOS (fim do copy-paste). **Write via STAGING** (`docs/_inbox/` ou memory pendente — NUNCA commit direto, Red Zone write-back). Notificação ao Enio via **bot Telegram do EGOS, EXCLUSIVO pro ID do Enio — JAMAIS para grupos**.
 - [ ] **EGOS-CAPTURE-TG-APPROVE-001** [P2] `forja`+`hermes-ops` — Fase 2: botão inline no Telegram p/ Enio aceitar/validar a captura → promove do staging pro sistema (HITL por clique, de dentro do Telegram direto pro código).
+- [ ] **WEBFETCH-SSRF-RESEARCH-001** [P2] `guardiao` — Validar com `/pesquisa` (date-first) se allowlist + domínio-do-cliente-por-sessão + guards SSRF (bloqueia IP interno/localhost) + audit é a melhor opção p/ web_fetch sem castrar o sistema. Padrão proposto = OWASP SSRF Prevention; confirmar com fontes atuais antes de implementar no MCP pessoal. Corte Enio 2026-06-09.
+- [ ] **CLAUDE-MD-SIMPLIFICADO-001** [P1] `prime` — Fluxo mínimo EGOS (corte Enio 2026-06-09): CLAUDE.md SIMPLIFICADO = router constitucional fino (anti-alucinação + CONFIRMADO/INFERIDO/HIPÓTESE + Red Zone + HITL + provenance + índice tools + quando-chamar) + EGOS MCP (profundidade via get_meta_prompt/get_skill on-demand) + NotebookLM MCP (didático). Roda em Claude Code E ChatGPT Dev Mode. Padrão roteador (liga memory_router_architecture).
 
 **Regras a encodar (R-DIAG-002 a 006) — pendente corte final do Enio:** ver `project_arquiteto_diagnosticador_identity_2026-06-09` na memória. R-DIAG-002 conversa-antes-de-código; R-DIAG-003 cadeia-fecha-no-funcionou; R-DIAG-004 diagnóstico-é-produto; R-DIAG-005 anti-espelho; R-DIAG-006 sistema-sem-pessoa-30d-congela.
 
@@ -122,8 +124,7 @@
 - [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
 - [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
 - [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
-- [ ] **CI-DEPENDABOT-BUNLOCK-001** [P1] `hermes-ops` — Causa-raiz (2026-06-09): TODOS os 7 PRs dependabot falham CI em `bun install --frozen-lockfile` ("lockfile had changes, but lockfile is frozen") — dependabot bumpa package.json mas NÃO regenera bun.lock. Nenhum mergeable até resolver. Fix: CI step que roda `bun install` (sem --frozen) em PR dependabot + commita o lock. ALERTA: PR #92 esconde `zod` 3→4 (major breaking) em grupo "minor-and-patch" — auditar. Decisão merge/close = Enio (deps sob freeze).
-- [ ] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — scrub do push FEITO (bc2aad3); ROTAÇÃO PENDENTE (corte Enio): Supabase `sbp_…`+PGPASSWORD `rTONDOKYmoGenDxN` (PROVÁVEL VIVO→rotar), Google `AIza…`/Alibaba `sk-…` (provável morto). Causa-raiz: gerador codex-review captura diffs com secret → adicionar scrub. [scrub done, rotação aberta — NÃO é phantom-done]
+- [ ] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — scrub do push FEITO (bc2aad3); ROTAÇÃO PENDENTE (corte Enio): Supabase `sbp_…`+PGPASSWORD `***REVOKED-2026-06-09***` (PROVÁVEL VIVO→rotar), Google `AIza…`/Alibaba `sk-…` (provável morto). Causa-raiz: gerador codex-review captura diffs com secret → adicionar scrub. [scrub done, rotação aberta — NÃO é phantom-done]
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 83f4b85d..10f7197d 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3784,3 +3784,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [x] **PII-RUNTIME-GATE-001** [P0-T0] `guardiao` — FEITO 2026-06-09 (exceção técnica aprovada pelo conselho §5.3, R-SEC-002 [T0]): `maskPII` de `@egosbr/guard-brasil` wired no `orchestrator.ts:1604` (Phase 1.5) ANTES de qualquer envio a LLM externo. 7 golden cases (`pii-gate.test.ts`) verde. saveHistory passa a salvar texto mascarado. Falta deploy VPS.
 
+
+## Archived 2026-06-09
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **CI-DEPENDABOT-BUNLOCK-001** [P1] `hermes-ops` — Causa-raiz (2026-06-09): TODOS os 7 PRs dependabot falham CI em `bun install --frozen-lockfile` ("lockfile had changes, but lockfile is frozen") — dependabot bumpa package.json mas NÃO regenera bun.lock. Nenhum mergeable até resolver. Fix: CI step que roda `bun install` (sem --frozen) em PR dependabot + commita o lock. ALERTA: PR #92 esconde `zod` 3→4 (major breaking) em grupo "minor-and-patch" — auditar. Decisão merge/close = Enio (deps sob freeze). ✅ 2026-06-09
+
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 986b4d5e..adc532e6 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
+    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 986b4d5e..adc532e6 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
+    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/_current_handoffs/handoff_2026-06-08.md b/docs/_archived_handoffs/handoff_2026-06-08.md
similarity index 100%
rename from docs/_current_handoffs/handoff_2026-06-08.md
rename to docs/_archived_handoffs/handoff_2026-06-08.md
diff --git a/docs/_current_handoffs/handoff_2026-06-09.md b/docs/_current_handoffs/handoff_2026-06-09.md
new file mode 100644
index 00000000..3430b34b
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-09.md
@@ -0,0 +1,37 @@
+# Handoff — 2026-06-09
+
+## Accomplished (com SHAs)
+- Identidade cortada: arquiteto-diagnosticador (prova machine-wide 14 sistemas=0 fecharam) — `a6bb400c` (FOCO+CONGELADO TASKS) + memória project_arquiteto_diagnosticador_identity_2026-06-09
+- Conselho multi-IA consolidado (Gemini/ChatGPT/Perplexity/Grok + Banda + Codex + Guarani/Runtime) — `4945ff28`
+- Princípio HITL (curva maturidade, EU AI Act/LGPD) — `e295e6eb`
+- Constituição de HTML (R-HTML-001..008) + skill /pesquisa + 3 HTML tutor mestres — `b17894a1`
+- PII runtime gate [T0] + Miguel diag HTML — `26f8ee3a`, `21200b24`
+- Curadoria MCP pessoal (90 tools→16) — `2def6c69`
+- Tasks MCP pessoal + egos_capture + web_fetch + CLAUDE.md simplificado — `ae6ec570`, `89b93aa2`
+
+## In Progress
+- MCP-PESSOAL-ENIO-001 — curadoria feita, falta build (endpoint consolidado Bearer + bridge) — próximo: implementar endpoint
+- EGOS-CAPTURE-001 — spec feita (staging fora-do-repo + PII gate + Telegram exclusivo) — próximo: ~80 LOC em mcp-memory
+
+## Blocked
+- R-DIAG-002..006 — pendente corte final do Enio (encodar no CLAUDE.md)
+- WEBFETCH-SSRF-RESEARCH-001 — validar OWASP via /pesquisa antes de implementar
+
+## Next Steps (priority order)
+1. CLAUDE-MD-SIMPLIFICADO-001 [P1] — router fino + EGOS MCP + NotebookLM MCP
+2. MCP-PESSOAL-ENIO-001 [P1] — endpoint consolidado + 16 tools + egos_capture
+3. FOCUS-MIGUEL-DIAG-001 [P0] / FOCUS-ITEMINTAKE-CLOSE-001 [P0] — fechar loop com pessoa real
+
+## Environment State
+- Build: OK (em sync, 0 ahead/behind) | Deploy: gateway PII gate live | Disk/RAM: N/A
+
+## Decisions Made (architectural)
+- Identidade = arquiteto-diagnosticador (não para de construir; constrói só a PROVA, escala por parceria/indicação)
+- NAO enterprise — começar pequeno (GPT gratuito pequenos diagnósticos esquenta lead)
+- Princípio da Ponte Simples: complexo=laboratório, simples=ponte
+- GPT por link = Actions (não MCP); MCP customizado fica backend pro Enio. Actions+Bearer PROVADO (g-pecas)
+- MCP pessoal: 1 endpoint consolidado, egos_capture fora-do-repo (_pending), web_fetch allowlist+SSRF+sessão
+- Isca de valor = comunidade/Hotmart, não o diagnóstico
+
+## Marked [CONCEPT]
+- mcp-egos-diagnostic / mcp-egos-public — não existem, build futuro
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index 1486fa51..d3c4a3fa 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T14:17:54.238Z",
+  "verified_at": "2026-06-09T18:12:56.852Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1286",
+      "current_value": "1294",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index befedf8b..fde750a5 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -118,5 +118,93 @@
     "duration_ms": null,
     "event": "commit:chore files=4 sha=ee38e623",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:51:42.179Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=4945ff28",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:54:17.785Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=83748a2e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:12:58.880Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=11 sha=26f8ee3a",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:31:18.782Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=3 sha=afee6fd9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:38:56.577Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=5 sha=b17894a1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:47:03.705Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=76e2a5f9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:52:58.514Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=ae6ec570",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:54:23.617Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=6dccf0bb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:56:26.125Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=2def6c69",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T19:16:50.929Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=2de69b0d",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T19:21:51.737Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=b24d431f",
+    "repo": "/home/enio/egos"
   }
 ]

exec
/bin/bash -lc "nl -ba TASKS_ARCHIVE.md | tail -30 && nl -ba TASKS.md | sed -n '115,130p' && nl -ba docs/_current_handoffs/handoff_2026-06-09.md | sed -n '1,45p'" in /home/enio/egos
 succeeded in 0ms:
  3763	## Archived 2026-06-09
  3764	
  3765	### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
  3766	- [x] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire em end.md. FEITO: Phase 8.6 adicionada em `.claude/commands/end.md` + `.agents/workflows/end.md`; pasta `docs/_inbox/ingest/` criada. 2026-06-09.
  3767	
  3768	
  3769	## Archived 2026-06-09
  3770	
  3771	### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
  3772	- [x] **COORD-WATCHER-STALE-001** [P2] `prime` — coordination-watcher reiniciado (nohup, PID 1412273). 2026-06-09.
  3773	- [x] **RULES-PENDING-CODIFY-001** [P2] `prime` — /rules executado: INC-GATEWAY-001 adicionado a AGENTS.md R6; 7 entradas rules-pending.jsonl marcadas processed; learnings em HARVEST. 2026-06-09.
  3774	
  3775	### 🔴 NOVO 2026-05-25 — INC-SYNC-001 + Home=Catalogo
  3776	- [x] **VPS-GATEWAY-AUTOSYNC-001** [P1] `prime` -- hermes-trigger.sh atualizado: detecta mudanças em apps/egos-gateway/ após git pull, roda rsync + docker rebuild automaticamente. 2026-06-09.
  3777	
  3778	
  3779	## Archived 2026-06-09
  3780	
  3781	### 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
  3782	- [x] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — FEITO 2026-06-09: gerador `scripts/generate-metaprompt.ts` lê o markdown canônico → `src/data/metaprompt-source.ts` (AUTO-GENERATED), App.tsx importa `METAPROMPT_V3`. Build wired no `package.json`. typecheck+build verde. Drift eliminado (grep confirma 0 inline).
  3783	
  3784	### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
  3785	- [x] **PII-RUNTIME-GATE-001** [P0-T0] `guardiao` — FEITO 2026-06-09 (exceção técnica aprovada pelo conselho §5.3, R-SEC-002 [T0]): `maskPII` de `@egosbr/guard-brasil` wired no `orchestrator.ts:1604` (Phase 1.5) ANTES de qualquer envio a LLM externo. 7 golden cases (`pii-gate.test.ts`) verde. saveHistory passa a salvar texto mascarado. Falta deploy VPS.
  3786	
  3787	
  3788	## Archived 2026-06-09
  3789	
  3790	### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
  3791	- [x] **CI-DEPENDABOT-BUNLOCK-001** [P1] `hermes-ops` — Causa-raiz (2026-06-09): TODOS os 7 PRs dependabot falham CI em `bun install --frozen-lockfile` ("lockfile had changes, but lockfile is frozen") — dependabot bumpa package.json mas NÃO regenera bun.lock. Nenhum mergeable até resolver. Fix: CI step que roda `bun install` (sem --frozen) em PR dependabot + commita o lock. ALERTA: PR #92 esconde `zod` 3→4 (major breaking) em grupo "minor-and-patch" — auditar. Decisão merge/close = Enio (deps sob freeze). ✅ 2026-06-09
  3792	
   115	> **Contexto:** Enio usou o Kyte (IA-first, estilo de empresa que admira), achou pontos de melhora vs o que o EGOS já tem. Vídeo do interior do Kyte: `~/Videos/Screencasts/Screencast from 2026-06-03 13-04-53.mp4`. Objetivo: mapear o que Kyte tem (que ele tentou em gpecas/forja e não conseguiu), comparar com o nosso, achar o gap REAL (experiência? foco? expertise? design? organização?) e CONSTRUIR/melhorar com toda a estrutura de agentes (Banda + Council + Codex review). **Para mostrar a um contato de empresa IA-first que ele admira.**
   116	- [ ] **KYTE-PRESENT-001** [P1] `redzone` — Material p/ mostrar ao contato IA-first (Red Zone: copy/posicionamento → corte Enio).
   117	
   118	## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
   119	- [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
   120	- [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
   121	- [ ] **MEMORY-DEDUP-ENGINE-001** [P1] `prime`/`forja` — RAIZ (Banda+Codex): construir no `packages/mcp-memory` (TDD) — (a) dedup-na-escrita (cosine/claim_key, checar relacionados antes de criar); (b) supersessão (claim_key marca superseded, exclui do recall); (c) reconciliar split de store (`~/.egos/memory/mcp-store/` vs `~/.claude/projects/.../memory/`); (d) opcional decay. egos-memory MCP v0.2.0 hoje só keyword store/recall (CONFIRMADO, source lido). Refs OSS: ashnode/agent-knowledge/conch/distill.
   122	- [ ] **MEMORY-ARCHIVE-001** [P2] `prime` — Criar `MEMORY_ARCHIVE.md` + mover entradas frias do MEMORY.md (652L/329). DEPOIS de MEMORY-DEDUP-ENGINE-001 (detecção de superseded popula o archive; evita corte arbitrário por idade).
   123	- [ ] **ESSENTIAL-FILES-ENFORCE-001** [P2] `prime` — Wire warn-only (Sentinela varre last_update→REVISAR >60d; /start avisa limites). Só DEPOIS do dedup. Comandos NUNCA bloqueiam. Resolver conflito AGENTS.md 200vs400.
   124	- [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
   125	- [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
   126	- [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
   127	- [ ] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — scrub do push FEITO (bc2aad3); ROTAÇÃO PENDENTE (corte Enio): Supabase `sbp_…`+PGPASSWORD `***REVOKED-2026-06-09***` (PROVÁVEL VIVO→rotar), Google `AIza…`/Alibaba `sk-…` (provável morto). Causa-raiz: gerador codex-review captura diffs com secret → adicionar scrub. [scrub done, rotação aberta — NÃO é phantom-done]
   128	
   129	## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
   130	> Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
     1	# Handoff — 2026-06-09
     2	
     3	## Accomplished (com SHAs)
     4	- Identidade cortada: arquiteto-diagnosticador (prova machine-wide 14 sistemas=0 fecharam) — `a6bb400c` (FOCO+CONGELADO TASKS) + memória project_arquiteto_diagnosticador_identity_2026-06-09
     5	- Conselho multi-IA consolidado (Gemini/ChatGPT/Perplexity/Grok + Banda + Codex + Guarani/Runtime) — `4945ff28`
     6	- Princípio HITL (curva maturidade, EU AI Act/LGPD) — `e295e6eb`
     7	- Constituição de HTML (R-HTML-001..008) + skill /pesquisa + 3 HTML tutor mestres — `b17894a1`
     8	- PII runtime gate [T0] + Miguel diag HTML — `26f8ee3a`, `21200b24`
     9	- Curadoria MCP pessoal (90 tools→16) — `2def6c69`
    10	- Tasks MCP pessoal + egos_capture + web_fetch + CLAUDE.md simplificado — `ae6ec570`, `89b93aa2`
    11	
    12	## In Progress
    13	- MCP-PESSOAL-ENIO-001 — curadoria feita, falta build (endpoint consolidado Bearer + bridge) — próximo: implementar endpoint
    14	- EGOS-CAPTURE-001 — spec feita (staging fora-do-repo + PII gate + Telegram exclusivo) — próximo: ~80 LOC em mcp-memory
    15	
    16	## Blocked
    17	- R-DIAG-002..006 — pendente corte final do Enio (encodar no CLAUDE.md)
    18	- WEBFETCH-SSRF-RESEARCH-001 — validar OWASP via /pesquisa antes de implementar
    19	
    20	## Next Steps (priority order)
    21	1. CLAUDE-MD-SIMPLIFICADO-001 [P1] — router fino + EGOS MCP + NotebookLM MCP
    22	2. MCP-PESSOAL-ENIO-001 [P1] — endpoint consolidado + 16 tools + egos_capture
    23	3. FOCUS-MIGUEL-DIAG-001 [P0] / FOCUS-ITEMINTAKE-CLOSE-001 [P0] — fechar loop com pessoa real
    24	
    25	## Environment State
    26	- Build: OK (em sync, 0 ahead/behind) | Deploy: gateway PII gate live | Disk/RAM: N/A
    27	
    28	## Decisions Made (architectural)
    29	- Identidade = arquiteto-diagnosticador (não para de construir; constrói só a PROVA, escala por parceria/indicação)
    30	- NAO enterprise — começar pequeno (GPT gratuito pequenos diagnósticos esquenta lead)
    31	- Princípio da Ponte Simples: complexo=laboratório, simples=ponte
    32	- GPT por link = Actions (não MCP); MCP customizado fica backend pro Enio. Actions+Bearer PROVADO (g-pecas)
    33	- MCP pessoal: 1 endpoint consolidado, egos_capture fora-do-repo (_pending), web_fetch allowlist+SSRF+sessão
    34	- Isca de valor = comunidade/Hotmart, não o diagnóstico
    35	
    36	## Marked [CONCEPT]
    37	- mcp-egos-diagnostic / mcp-egos-public — não existem, build futuro

exec
/bin/bash -lc 'python -m json.tool docs/jobs/2026-06-09-pre-commit-pipeline.json >/dev/null && python -m json.tool docs/jobs/2026-06-09-doc-drift-verifier.json >/dev/null && echo ok' in /home/enio/egos
 succeeded in 0ms:
ok

codex
The patch incorrectly marks an unresolved CI/dependency task as completed and removes it from active tracking. This can cause a known Dependabot CI blocker to be lost.

Review comment:

- [P2] Keep unresolved Dependabot CI task active — /home/enio/egos/TASKS_ARCHIVE.md:3791-3791
  When this task still states that all 7 Dependabot PRs are failing CI, none are mergeable, and the merge/close decision is pending with Enio, archiving it as `[x]` removes the active tracker for an unresolved CI blocker. It also lacks the repo-required evidence for marking a task done, so this should stay in `TASKS.md` until the lockfile/CI fix or explicit closure is recorded.
The patch incorrectly marks an unresolved CI/dependency task as completed and removes it from active tracking. This can cause a known Dependabot CI blocker to be lost.

Review comment:

- [P2] Keep unresolved Dependabot CI task active — /home/enio/egos/TASKS_ARCHIVE.md:3791-3791
  When this task still states that all 7 Dependabot PRs are failing CI, none are mergeable, and the merge/close decision is pending with Enio, archiving it as `[x]` removes the active tracker for an unresolved CI blocker. It also lacks the repo-required evidence for marking a task done, so this should stay in `TASKS.md` until the lockfile/CI fix or explicit closure is recorded.
```
