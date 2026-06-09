# Codex Local Review — 2026-06-09T12:48:09Z

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
session id: 019eac6d-1287-7031-85cd-0e7ea12479c6
--------
user
changes against 'HEAD~3'
2026-06-09T12:48:10.861977Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T12:48:10.861976Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff b3410639cce644232465f101be0df1516a5e21f4 --stat && git diff b3410639cce644232465f101be0df1516a5e21f4' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                         |  6 ++--
 TASKS.md                                      |  5 +++-
 apps/egos-landing/public/timeline/rss         |  2 +-
 apps/egos-landing/public/timeline/rss.xml     |  2 +-
 docs/jobs/2026-06-08-doc-drift-verifier.json  |  6 ++--
 docs/jobs/2026-06-08-pre-commit-pipeline.json | 40 +++++++++++++++++++++++++++
 docs/knowledge/HARVEST.md                     |  9 ++++--
 docs/personal-os/ENIO_UNDERSTANDING_MAP.md    |  6 +++-
 prompts/personal-os/SELF_MAPPING_INTERVIEW.md | 15 ++++++----
 9 files changed, 75 insertions(+), 16 deletions(-)
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
index 3694be61..16bfff74 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -17,7 +17,7 @@
 - [ ] **GPT-CREATE-001** [P0] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
 - [ ] **MIGUEL-GOW-SEND-001** [P0] `prime` — Enviar HTML piloto MF Certificados para Miguel (dono da GOW). Arquivo: docs/presentations/mf-certificados-piloto.html. Incluir link NotebookLM (áudio overview pronto). Registrar envio aqui.
 - [ ] **SOCIAL-LAUNCH-001** [P0] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
-- [ ] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
+- [/] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
 
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 > Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
@@ -89,6 +89,9 @@
 ## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
 - [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
+- [x] **MEMORY-ROUTER-ARCH-001** [P1] `prime` `gated:HITL` — Arquitetar política de "arquivos essenciais = roteadores, não enciclopédias" (Enio 2026-06-08). Inventário FEITO: MEMORY.md 652L, end.md 1058L, TASKS.md 904L, start.md 645L, memory/ 329 arquivos/17.9k linhas = sprawl. Entregar: (1) padrão metadata por arquivo (last_update/status/freshness/cross-refs); (2) política de tamanho+trigger de condensação por tipo (principal/temático/profundo); (3) padrão de cross-reference + expansão progressiva (índice→temático→profundo→evidência); (4) freshness (ATUAL/REVISAR/PESQUISAR/HISTÓRICO) + sugerir pesquisa externa (Exa/WebSearch/RAG; Firecrawl ausente). Passar por Banda+Codex. DECISÃO ENIO pendente: limite = alerta flexível | bloqueio pre-commit | só relatório. Não criar limites rígidos antes de pesquisar práticas jun/2026. ✅ 2026-06-09
+- [x] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão de conhecimento do Enio (Enio 2026-06-08): ele despeja .md de conversas ChatGPT/Grok/notas/estudos → EGOS atomiza→memória/RAG (egos-knowledge ingest_file + record_learning). Definir: pasta de drop (ex: `docs/_inbox/ingest/`), pipeline de processamento (anonimizar→atomizar→linkar→arquivar), uso do `/process-inbox`. Liga MEMORY-ROUTER-ARCH-001. ✅ 2026-06-09
+- [x] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar ao Enio: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire na skill end.md (nova Phase). Depende de KNOWLEDGE-INGEST-CHANNEL-001 (onde o conteúdo cai). ✅ 2026-06-09
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
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
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 12bd4752..8438dcce 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,8 +1,13 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
+> **VERSION:** 5.17.0 | **UPDATED:** 2026-06-09 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+> **Latest:** P174 — Guard Brasil: auditoria machine-wide (6 pacotes, 3 repos, PRONTO flagship)
+
+---
+
+**P174 — Guard Brasil: estado real após auditoria machine-wide (2026-06-09)**
+`@egosbr/guard-brasil` v0.2.3 — 6 implementações em 3 repos. Core TS (20/20 testes), REST API `guard.egos.ia.br` (prod Hetzner), MCP Server v0.2.0 (SDK oficial), Python SDK (funcional, falta PyPI), LangChain wrapper (CONCEPT/esqueleto), frontend legado `_archived/`. 12 padrões PII BR + ATRiAN + Evidence Chain SHA-256. Pronto para divulgação como FLAGSHIP. Gaps: PyPI publish (2h), OpenAPI docs (3h), consolidar frontend, LangChain completo. CAPABILITY_REGISTRY §1.
 
 ---
 
diff --git a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
index fc8abf33..87f0a4d4 100644
--- a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
+++ b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
@@ -5,7 +5,7 @@ type: governance
 version: 1.1
 status: active
 created: 2026-05-08
-last_update: 2026-05-08 (B1+B2 entrevista — atoms A1-A52)
+last_update: 2026-06-08 (EPOS B2-Q1/Q2 retomada — flow zones + mecanismo produção∞/captura-adiada)
 ---
 
 # Enio Understanding Map
@@ -36,6 +36,10 @@ Agente pode usar linguagem técnica densa, pular explicações básicas, ir dire
 - **Modelo de venda Discovery+Build** (A40) — cliente traz problema, ele arquiteta. Lucas/pixelart provou. NÃO é Pitch+Sell
 - **Self-awareness operacional alta** (A48) — nomeia próprios bloqueios, valida protocolos contra si mesmo
 
+**Validado pela retomada EPOS B2 (2026-06-08):**
+- **Flow zones (B2-Q1):** flui em (1) CONVERSAR (assunto interessante → horas) e (2) RESOLVER/CONSTRUIR/PESQUISAR — próprios e dos outros. Auto-rótulo "resolvedor de problemas, mesmo que tenha que criar/amplificar eles" (Jordan). → agente pode usar isso como combustível, mas vigiar o lado dispersor (criar problema pra ter o que resolver).
+- **Mecanismo produção∞/captura-adiada (B2-Q1+Q2):** o que ADIA é RECEBER/capturar valor (dinheiro fora da polícia). Explica 460 commits/R$0 + dispersão 🔴. Quando ele hesitar em cobrar/fechar → é o nó de receber (🔴 abaixo), não falta de valor. Está em movimento (Miguel/GOW/Hotmart = rampa). 🔒 protegido. Ver `memory/user_enio_flow_zones_capture_block_2026-06-08.md`.
+
 **Validado pela clarificação 2026-05-20 (atom A78 — ver IDENTITY_AND_METHOD.md):**
 - **Habilidade central canonical:** transformar caos informacional em clareza estratégica aplicável (não é pivot — é nome para o padrão que sempre existiu)
 - **Método-mãe canonical:** Espiral de Escuta — escuta + maiêutica + síntese + needs[]/next_actions[] + audit. Aplicação transversal (comércio/investigação/interpessoal/replicação)
diff --git a/prompts/personal-os/SELF_MAPPING_INTERVIEW.md b/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
index c90eef91..de9a10a2 100644
--- a/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
+++ b/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
@@ -141,13 +141,18 @@ Persistido em `data/personal-os/private/interview_state.json` (gitignore):
 2. Re-apresentar com 6 seções completas
 3. Tag `Q-PROTO-VIOLATION-<data>` em handoff (≥3 violations = revisão do protocolo)
 
-### Persistência (v1.1 schema)
+### Persistência (v1.2 — LOOP VIVO, corte Enio 2026-06-08)
 
-Quando resposta válida chega, agente:
+> **Causa:** auditoria 2026-06-08 — os atoms eram um **sumidouro write-only**. Nenhum script lê o `.jsonl` em runtime; o `/start` só conta linhas (`wc -l`), não carrega conteúdo; o `.jsonl` é gitignored (não dissemina). O ENIO_UNDERSTANDING_MAP.md (projeção) ficou stale 31/mai→08/jun. O canal que de fato influencia toda sessão é o sistema de **MEMÓRIA** (`~/.claude/projects/.../memory/*.md` + `MEMORY.md`), populado manualmente. Decisão Enio: toda resposta validada gera **atom + memória sempre** (sem construir script — disciplina do protocolo).
 
-1. Atomizar em 1+ atoms rascunho
-2. Persist em `data/personal-os/private/enio_profile_atoms.jsonl` (gitignore) APÓS Enio confirmar
-3. Update `interview_state.json`:
+Quando resposta válida chega, agente faz **os 3 (não só o atom)**:
+
+1. **Atom** (trilha de auditoria) — persist em `data/personal-os/private/enio_profile_atoms.jsonl` APÓS validar.
+2. **Memória (CANAL VIVO — obrigatório se a resposta revela padrão de calibração):** escrever/atualizar `~/.claude/projects/-home-enio-egos/memory/<slug>.md` + linha no `MEMORY.md`. É isto que faz a próxima sessão e os outros agentes herdarem — em tempo real, sem código.
+3. **MAP:** refletir em `ENIO_UNDERSTANDING_MAP.md` (mover 🟡→🟢, add 🔴, etc.) quando muda nível de delegação. Bump `last_update`.
+4. **Regra (só quando o padrão estabiliza):** se vira calibração durável (ex: bloqueio de receber → cuidado com pricing), virar candidata a `/rules`. Não prematuro.
+
+Depois, update `interview_state.json`:
    - `questions_answered` += [ID]
    - `current_question_id` = next
    - `last_activity` = now

exec
/bin/bash -lc "nl -ba .claude/settings.json | sed -n '1,80p'; nl -ba prompts/personal-os/SELF_MAPPING_INTERVIEW.md | sed -n '135,165p'; nl -ba docs/knowledge/HARVEST.md | sed -n '1,25p'" in /home/enio/egos
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
   135	- ❌ §5 vago ("razoável", "o que você achar")
   136	- ❌ Apresentar sem §6 Impacto — decisão fica órfã
   137	
   138	### Recovery (se Enio sinalizar "lista solta" / "não argumentou")
   139	
   140	1. Reconhecer falha em 1 linha — sem 3 desculpas
   141	2. Re-apresentar com 6 seções completas
   142	3. Tag `Q-PROTO-VIOLATION-<data>` em handoff (≥3 violations = revisão do protocolo)
   143	
   144	### Persistência (v1.2 — LOOP VIVO, corte Enio 2026-06-08)
   145	
   146	> **Causa:** auditoria 2026-06-08 — os atoms eram um **sumidouro write-only**. Nenhum script lê o `.jsonl` em runtime; o `/start` só conta linhas (`wc -l`), não carrega conteúdo; o `.jsonl` é gitignored (não dissemina). O ENIO_UNDERSTANDING_MAP.md (projeção) ficou stale 31/mai→08/jun. O canal que de fato influencia toda sessão é o sistema de **MEMÓRIA** (`~/.claude/projects/.../memory/*.md` + `MEMORY.md`), populado manualmente. Decisão Enio: toda resposta validada gera **atom + memória sempre** (sem construir script — disciplina do protocolo).
   147	
   148	Quando resposta válida chega, agente faz **os 3 (não só o atom)**:
   149	
   150	1. **Atom** (trilha de auditoria) — persist em `data/personal-os/private/enio_profile_atoms.jsonl` APÓS validar.
   151	2. **Memória (CANAL VIVO — obrigatório se a resposta revela padrão de calibração):** escrever/atualizar `~/.claude/projects/-home-enio-egos/memory/<slug>.md` + linha no `MEMORY.md`. É isto que faz a próxima sessão e os outros agentes herdarem — em tempo real, sem código.
   152	3. **MAP:** refletir em `ENIO_UNDERSTANDING_MAP.md` (mover 🟡→🟢, add 🔴, etc.) quando muda nível de delegação. Bump `last_update`.
   153	4. **Regra (só quando o padrão estabiliza):** se vira calibração durável (ex: bloqueio de receber → cuidado com pricing), virar candidata a `/rules`. Não prematuro.
   154	
   155	Depois, update `interview_state.json`:
   156	   - `questions_answered` += [ID]
   157	   - `current_question_id` = next
   158	   - `last_activity` = now
   159	   - **`current_presentation`** (NEW v1.1): clear ao avançar
   160	   - **`atoms_pending_validation`** (NEW v1.1): mover atom para `enio_profile_atoms.jsonl` quando validado
   161	4. Update TASKS / MAPs conforme §6 Impacto
   162	5. Commit (R0.5 — immediately)
   163	
   164	**Quando agente APRESENTA pergunta** (antes da resposta), persiste:
   165	- `current_presentation.fired_at` = now
     1	# HARVEST.md — EGOS Core Knowledge
     2	
     3	> **VERSION:** 5.17.0 | **UPDATED:** 2026-06-09 UTC-3
     4	> **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
     5	> **Latest:** P174 — Guard Brasil: auditoria machine-wide (6 pacotes, 3 repos, PRONTO flagship)
     6	
     7	---
     8	
     9	**P174 — Guard Brasil: estado real após auditoria machine-wide (2026-06-09)**
    10	`@egosbr/guard-brasil` v0.2.3 — 6 implementações em 3 repos. Core TS (20/20 testes), REST API `guard.egos.ia.br` (prod Hetzner), MCP Server v0.2.0 (SDK oficial), Python SDK (funcional, falta PyPI), LangChain wrapper (CONCEPT/esqueleto), frontend legado `_archived/`. 12 padrões PII BR + ATRiAN + Evidence Chain SHA-256. Pronto para divulgação como FLAGSHIP. Gaps: PyPI publish (2h), OpenAPI docs (3h), consolidar frontend, LangChain completo. CAPABILITY_REGISTRY §1.
    11	
    12	---
    13	
    14	## P173 — 2026-06-08: Fluxo unificado HTML + NotebookLM por cliente
    15	
    16	**Trigger:** Sessão GOW/MF Certificados — necessidade de apresentar proposta de piloto ao owner.
    17	
    18	**Padrão descoberto:** R-DOC-AUDIENCE-001 (README=máquina, HTML=humano) tem uma extensão natural: NotebookLM como amplificador de inteligência. O HTML é o shell de navegação (offline, sem login, compartilhável), o NotebookLM gera os artefatos derivados (áudio overview PT-BR para ouvir no carro, slides para reunião, briefing para o tomador de decisão).
    19	
    20	**Arquitetura:**
    21	1. `.md` fonte (AI↔AI) → NotebookLM via MCP (`source_add`)
    22	2. NotebookLM gera: áudio overview 5-10min PT-BR / slides / briefing executivo
    23	3. HTML atualizado com seção "Materiais" linkando artefatos
    24	4. GitHub per client: HTML standalone + README.md como fonte AI
    25	

exec
/bin/bash -lc 'git log --oneline --decorate -5' in /home/enio/egos
 succeeded in 0ms:
0dbcd0c0 (HEAD -> main, origin/main) chore(tasks): +MEMORY-ROUTER-ARCH-001 +KNOWLEDGE-INGEST-CHANNEL-001 +END-INGEST-PROMPT-001
8c2dbb5e feat(epos): fecha loop EPOS→sistema (atom+memória+MAP) — corte Enio 2026-06-08
4529821b chore(audit): Guard Brasil machine-wide audit P174 + task done — 6 impl, 3 repos, flagship
b3410639 feat(launch): roteiro 2:30 + inventário Hotmart + drafts divulgação + tasks lançamento
5aecdd0d chore(drift): governance drift report [2026-06-09]

exec
/bin/bash -lc "node -e \"JSON.parse(require('fs').readFileSync('.claude/settings.json','utf8')); JSON.parse(require('fs').readFileSync('docs/jobs/2026-06-08-pre-commit-pipeline.json','utf8')); JSON.parse(require('fs').readFileSync('docs/jobs/2026-06-08-doc-drift-verifier.json','utf8')); console.log('ok')\"" in /home/enio/egos
 succeeded in 0ms:
ok

exec
/bin/bash -lc 'ls -l .claude/commands/purge.md /home/enio/egos/.claude/commands/purge.md 2>&1 || true; ls .claude/commands | head' in /home/enio/egos
 succeeded in 0ms:
-rw-rw-r-- 1 enio enio 3881 Jun  7 16:58 .claude/commands/purge.md
-rw-rw-r-- 1 enio enio 3881 Jun  7 16:58 /home/enio/egos/.claude/commands/purge.md
ativar.md
banda.md
central-egos.md
client-onboard.md
daily-article.md
dead-code-cleanup.md
dep-audit.md
disseminate.md
duo.md
end.md

exec
/bin/bash -lc "grep -R \"\\[/\\]\" -n TASKS.md docs scripts | head -20" in /home/enio/egos
 succeeded in 0ms:
TASKS.md:20:- [/] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
TASKS.md:27:- [/] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — pesquisa feita, aplicar no design da demo. PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
TASKS.md:28:- [/] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medição feita; falta preencher os 57 golden ausentes. MEDIDO ao vivo: 80 CBCs, **9 com golden real**, 57 contrato-sem-teste; harness rodou **mcp-runner 88/93 pass**, bun test 78/82. Frase honesta GOW: "9 MCPs com golden (88/93), resto contrato-pendente; infra existe, gap é preenchimento". 4 falhas metaprompts (MP-PRICE/MP-MATERIAL falta red-zone) = fix simples futuro.
TASKS.md:32:- [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
TASKS.md:33:- [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
TASKS.md:36:- [/] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — Golden Example Tutor→Operacional REDIGIDO (gpt-tier0-package.md §2, bloco a anexar). Falta HITL + colar no artefato/GPT. Guarani #3.
TASKS.md:45:- [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
TASKS.md:260:- [/] **AGENT-INTERCONNECT-001** [P1] `prime` — Interconexão dos 12 agentes (se conhecerem/triggers/gates). **FEITO 2026-06-03 (Fase 1 + F4, Banda+premortem):** SSOT `agents/registry/triggers.json` (roster up/down/gates/peers); `agent-pipeline.ts gate --gate-type` generalizado (5 gates, compat 7/7 golden); autoconsciência linkada nos 10 defs; Sentinela flags `PIPELINE_BYPASS` + `MULTI_WINDOW_COLLISION` (F4 detector; mecanismo egos-worktree.sh já existia). SSOT: `docs/audits/premortem-agent-interconnection.md`. **DEFERIDO (Banda — dentes fracos):** validação DURA de transição no handoff (hoje nota soft) até 2º caso concreto.
TASKS.md:261:- [/] **TG-FIX-001** [P0] `gateway` — Diagnosticar+consertar `@EGOSin_bot`. **CÓDIGO FEITO 2026-06-03 (Forja):** gate `TELEGRAM_MODE` (polling|webhook|disabled) em `telegram.ts` + `.env.example` (typecheck limpo). Resolve 409/duplicação (local+VPS competindo). **FALTA (Enio/Red Zone):** setar `TELEGRAM_MODE=webhook` no `.env.production` da VPS + homologar live.
TASKS.md:264:- [/] **TASKS-ROADMAP-001** [P1] — Mover pending de longo prazo p/ `docs/strategy/ROADMAP.md` (TASKS.md > hard-limit 600, grace até 2026-06-15). Archive só remove done. **PARCIAL 2026-06-03 (Prime):** bloco AUTORES v2 Fase 0-4 movido (895→796L, 9 tasks). Resto = corte do Enio sobre quais P1/P0 abertos deferir (não deferir unilateralmente).
TASKS.md:349:- [/] **GUARANI-004** [P1] `guarani` — Enforcement técnico da TRAVA DE COMMIT (GUARANI.md §12.1): pre-commit bloqueia commit cujo autor/sessão = Guarani tocando frozen zone (`.guarani/`, `.husky/`, governance). Caso-teste = incidente `4e7bcb43` (auto-commit + symlink damage 2026-05-31). Guarani propõe diff; Prime commita. **HARDENED 2026-05-31 (Prime):** fail-closed-by-default via sinal `CLAUDECODE` (Prime=Claude Code tem; Guarani=Antigravity não) + override humano `EGOS_FROZEN_OVERRIDE=1` (Enio). Codex review aplicado (value-leak fix + threat-model honesto). FALTA p/ `[x]`: enforcement tamper-proof (env vars são forjáveis → exige pre-receive server-side, não wired no setup solo). Hoje = defesa-em-profundidade + registro de intenção, NÃO authz à prova de adulteração.
TASKS.md:354:- [/] **GUARD-STD-003** [P1] `prime` `gated:001,002` — Definir contrato `guardrails.yaml` (schema) + matriz de conformidade. **PARCIAL 2026-06-02:** schema v0.1 + regras de validação + mínimos por tipo + matriz skeleton em `AGENT_GUARDRAILS_STANDARD.md` §8/§9. Fundações de auditoria A2A (ASI 2026) e JCS RFC 8785 Ed25519 implementadas e expostas no mcp-governance (2026-06-02). FALTA: refinar métodos pós-pesquisa (001/002), preencher matriz por código (evidence-first), corte Enio nos mínimos (parte de 006). <!-- scan-ok: FP-placa -->
TASKS.md:355:- [/] **GUARD-STD-004** [P1] `prime` `gated:003` — Wirar L0/L2/L3 guards. **L3 LLM-gate FEITO 2026-06-03 (corte Enio: escalação-only):** `pri.ts` ganhou injeção de `llmEvaluator` (default=mock; L3 só roda quando L1/L2 inconclusivos, confidence<60); avaliador real `callHermes` em `packages/shared/src/guards/pri-llm-evaluator.ts` (fail-closed BLOCK). @egos/core continua sem dep de shared. 4/4 testes pri passam. **FALTA:** wirar L0 (injection/scope) + L2 (ATRiAN+PII output) em todos os chatbots + injetar o evaluator nos callers reais.
TASKS.md:375:- [/] **CTX-HANDOFF-001** [P1] `prime` — Handoff fidelity telemetry (A+B+C). **FEITO (build, push retido):** (A) `scripts/handoff-fidelity.ts` — score read-only 0-100 (claims-com-SHA / next-step / todos persistidos / decisões captadas) → docs/jobs + Supabase; heurística honesta INC-006 (sem-evidência ≠ 100). (B) seção "Todos da sessão (snapshot TodoWrite)" no template do `/end` Phase 4 — recupera artefato hoje 100% perdido. (C) `docs/_current_handoffs/_TEMPLATE_sync.md` cross-window + Phase 4.1 gate no `/end`. Validado em 3 handoffs reais (sync=100, guarani-close=60, master-plan=45). FALTA `[x]`: push após validação Enio + decidir se o design muda com CTX-ROTATION-001.
TASKS.md:408:- [/] **SITE-VOICE-001** [P1] `redzone` `research` — ✅ DRAFT 2026-06-02 (Sonnet pesquisou Linear/Resend/Railway/Supabase/Anthropic): `docs/strategy/EGOS_VOICE_GUIDE.md` — 5 princípios + 3 headlines draft + 5 perguntas pro Enio. **Resta: corte do Enio** nas headlines + 5 perguntas (língua, quanto do Enio, ego-balance público, proof status, PCMG no texto).
TASKS.md:412:- [/] **CURRICULUM-001** [P1] `redzone` — Currículo/posicionamento do Enio. **Substância aprovada Enio 2026-06-01**, SSOT persistido `docs/strategy/ENIO_CURRICULUM_POSITIONING.md` (identidade "investigador-arquiteto"; frase "não vendo hora de perito" CORTADA). Pendente: corte final da versão expandida + aterrissagem na seção "Sobre". Respeita estatuto PCMG (IP/magistério/advisory).
TASKS.md:417:- [/] **ARTICLE-RULES-001** [P1] — Melhorar regras de geração de artigo (VOICE+TEMPLATE) p/ público Claude Code/Windsurf + novatos curiosos; tom explicativo+confiável; confiança via matemática/auditabilidade. (Sonnet propondo edições; Opus revisa.)
TASKS.md:418:- [/] **ARTICLE-002** [P1] `redzone` — Escrever artigo #2 no tom investigador-arquiteto: explicar+mostrar+validar EGOS. Evidence-first (citar só o que existe no repo). HITL antes de publicar. (Sonnet redigindo draft; Opus revisa Red Zone.)
TASKS.md:424:- [/] **CAREER-GAP-001** [P1] `redzone` `research` — Matriz % de cobertura de capacidade vs requisitos do role top (F1: forense on-chain + arquitetura/segurança IA): cada requisito → % coberto → evidência real (artefato/número do repo) → se exige cert, provar que evidência substitui. + overall % por tier + tese credential-skip evidenciada + gaps honestos (ex: uptime não medido → construir status page público). (Sonnet pesquisando; Opus sintetiza/corta.)
TASKS.md:589:- [/] **FE-SYNC-001** [P0] `prime` — **ACHADO RAIZ 2026-06-01:** o `/opt/egos-site/src/server.ts` em produção está **~1931 linhas ATRÁS** do repo (sem i18n/trading/tema/render novo). **É POR ISSO que o frontend não reflete nada** — prod roda server.ts de meses atrás (deploy drift). ✅ Dado já LIVE: `git pull` em `/opt/egos-git` (mount `docs/jobs:ro`) → `/status.json` fresco hoje + bloco framework (79/27/MCPs). ❌ Falta: **release controlado do egos-site** (deploy do server.ts atual = release GRANDE, não rebuild trivial — testar i18n/trading/deps no env prod + 502-safe + prova visual §10). Build context `/opt/egos-site` é NÃO-git → precisa pipeline de deploy real. NÃO fazer blind.

exec
/bin/bash -lc "grep -R \"HARVEST.md\\|docs/knowledge/HARVEST\\|"'^## P" -n scripts packages apps . | head -100' in /home/enio/egos
 succeeded in 7808ms:
scripts/recon.ts:136:## Perfil
scripts/autores-ingest-incidents.ts:383:Consultar \`docs/knowledge/HARVEST.md\` pelos IDs listados.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:353:| **HARVEST.md Patterns** | `egos/docs/knowledge/HARVEST.md` | A | egos | ALL | `docs`, `patterns`, `learnings` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:813:| `post-commit` | Extract `LEARNING:` lines from commit body | Appends to `docs/knowledge/HARVEST.md` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:838:or HARVEST.md are missing, it skips silently. This prevents hook failures from blocking commits.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:3259:| `/process-inbox` | `.claude/skills/process-inbox/SKILL.md` | HARVEST.md, 00-Inbox processing | ✅ active |
scripts/wiki-repos-sync.ts:36:  { file: "docs/knowledge/HARVEST.md",   category: "pattern",  prefix: (r: string) => `${r}-harvest` },
scripts/openrouter-benchmark-advanced.ts:36:## PRIVACIDADE E FOCO INSTITUCIONAL
scripts/dedup-harvest.ts:3: * KB-019: HARVEST.md Deduplication Script
scripts/dedup-harvest.ts:5: * Problem: HARVEST.md has grown to 10,000+ lines with potential triplication
scripts/dedup-harvest.ts:19:const HARVEST_PATH = join(__dirname, '../docs/knowledge/HARVEST.md');
scripts/dedup-harvest.ts:20:const BACKUP_PATH = join(__dirname, '../docs/knowledge/HARVEST.md.backup');
scripts/dedup-harvest.ts:94:  let output = `# HARVEST.md — EGOS Core Knowledge\n\n`;
scripts/dedup-harvest.ts:122:  console.log('🔍 KB-019: Analyzing HARVEST.md for duplicates...\n');
scripts/dedup-harvest.ts:130:  console.log(`💾 Backup created: HARVEST.md.backup\n`);
scripts/dedup-harvest.ts:150:  console.log('✅ KB-019 complete. Review HARVEST.md and delete backup if satisfied.');
scripts/rapid-response.ts:107:      "docs/knowledge/HARVEST.md",
scripts/openrouter-benchmark.ts:33:## PRIVACIDADE E FOCO INSTITUCIONAL
scripts/governance-propagate.sh:166:## Project: ${repo_name}
scripts/ssot-router.ts:84:  const alwaysOkNames = ["AGENTS.md", "CLAUDE.md", "README.md", "TASKS.md", "HARVEST.md"];
scripts/kbs/seed-egos-advocacia.ts:135:## Partes
scripts/autores-ingest-harvest.ts:5: * Ingere 165 learnings do HARVEST.md como SEED PRIMÁRIA para o sistema AUTORESEARCH.
scripts/autores-ingest-harvest.ts:25:const HARVEST_PATH = "/home/enio/egos/docs/knowledge/HARVEST.md";
scripts/autores-ingest-harvest.ts:100:// Parser: extract learning entries from HARVEST.md
scripts/autores-ingest-harvest.ts:139:          file: "docs/knowledge/HARVEST.md",
scripts/autores-ingest-harvest.ts:166:          file: "docs/knowledge/HARVEST.md",
scripts/autores-ingest-harvest.ts:195:      file: "docs/knowledge/HARVEST.md",
scripts/autores-ingest-harvest.ts:265:> Fonte: docs/knowledge/HARVEST.md | Total: ${total} learnings
scripts/autores-ingest-harvest.ts:339:    console.error(`ERRO: HARVEST.md não encontrado em ${HARVEST_PATH}`);
scripts/skill-candidate-extractor.ts:182:      action: "Review harvested knowledge → filter signal from noise → add to HARVEST.md",
scripts/skill-candidate-extractor.ts:183:      output: "Validated P-entries ready for HARVEST.md",
scripts/skill-candidate-extractor.ts:223:## Pattern detected
scripts/auto-disseminate.sh:10:#   2. Extract LEARNING: lines from commit body → append to HARVEST.md
scripts/auto-disseminate.sh:28:HARVEST_FILE="$REPO_ROOT/docs/knowledge/HARVEST.md"
scripts/auto-disseminate.sh:150:# ── 2. LEARNING: lines → HARVEST.md ─────────────────────────────────────────
scripts/auto-disseminate.sh:155:    echo "  [DRY] would append learnings to HARVEST.md:"
scripts/auto-disseminate.sh:166:    echo "[auto-disseminate] learnings appended to HARVEST.md"
scripts/monitor-publico-onboard.sh:98:## Próximos passos
scripts/governance/ssot-crosslink-validator.ts:31:  "docs/knowledge/HARVEST.md",
scripts/governance/ssot-crosslink-validator.ts:162:  if (rel.startsWith("docs/knowledge/")) return "docs/knowledge/HARVEST.md";
scripts/session-aggregator.sh:108:## P0 Blockers (still open)
scripts/egos-showcase-ingest.ts:7: * - HARVEST.md → entities (Pattern)
scripts/egos-showcase-ingest.ts:24:    harvest: "docs/knowledge/HARVEST.md",
scripts/egos-showcase-ingest.ts:99:        source: "HARVEST.md",
scripts/egos-showcase-ingest.ts:103:    console.error("Error parsing HARVEST.md:", e);
scripts/skills-daily-report.ts:103:## Por source
scripts/autoresearch-mine-history.ts:338:  sections.push(`---`, `## 3. Human Learnings (HARVEST.md Seed Highlights)`, `Highlight of selected key actionable learnings from HARVEST.`, ``);
scripts/openrouter-benchmark-v2.ts:30:## PRIVACIDADE E FOCO INSTITUCIONAL
scripts/validate-ssot.ts:9: * - HARVEST.md (patterns + decisions)
scripts/validate-ssot.ts:27:  'docs/knowledge/HARVEST.md',
scripts/validate-ssot.ts:148:    const harvestPath = path.join(ROOT, 'docs/knowledge/HARVEST.md');
scripts/validate-ssot.ts:173:      result.errors.push(`❌ HARVEST.md has ${deadLinks.length} broken links: ${deadLinks.join(', ')}`);
scripts/validate-ssot.ts:176:      result.warnings.push('✓ HARVEST.md links validated');
scripts/validate-ssot.ts:181:      result.warnings.push('⚠️  HARVEST.md contains date markers (should be evergreen, no timestamps)');
scripts/validate-ssot.ts:184:    result.errors.push(`❌ Failed to validate HARVEST.md: ${e}`);
scripts/validate-ssot.ts:205:    const harvestPath = path.join(ROOT, 'docs/knowledge/HARVEST.md');
scripts/validate-ssot.ts:242:    { name: 'HARVEST.md', fn: validateHarvestReferences },
scripts/openrouter-benchmark-v3.ts:30:## PRIVACIDADE E FOCO INSTITUCIONAL
scripts/sync-egos-rules.sh:88:## Purpose
packages/atrian-observability/src/instrumentation/context-watcher.ts:8: * forces new sub-agent at 180k." — @ericosiu (HARVEST.md P87)
packages/mcp-bridge/node_modules/typescript/SECURITY.md:33:## Preferred Languages
packages/mcp-bridge/node_modules/typescript/SECURITY.md:37:## Policy
packages/mcp-governance/node_modules/path-to-regexp/Readme.md:79:## PathToRegexp
packages/mcp-governance/node_modules/express/Readme.md:117:## Philosophy
packages/mcp-governance/node_modules/fast-deep-equal/README.md:52:## Performance benchmark
packages/mcp-governance/node_modules/ajv/README.md:91:## Performance
packages/mcp-governance/node_modules/@egos/audit/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-governance/node_modules/@egos/shared/node_modules/@egosbr/audit/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-governance/node_modules/@egos/shared/node_modules/@egos/audit/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-governance/node_modules/typescript/SECURITY.md:33:## Preferred Languages
packages/mcp-governance/node_modules/typescript/SECURITY.md:37:## Policy
packages/search-engine/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-browser-automation/node_modules/@egos/shared/node_modules/@egosbr/audit/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-browser-automation/node_modules/@egos/shared/node_modules/@egos/audit/node_modules/@egos/core/README.md:17:## PRIGate — principal diferencial
packages/mcp-browser-automation/node_modules/playwright/README.md:23:## Playwright Test
packages/mcp-browser-automation/node_modules/playwright/README.md:111:## Playwright CLI
packages/mcp-browser-automation/node_modules/playwright/README.md:159:## Playwright MCP
packages/mcp-browser-automation/node_modules/playwright/README.md:212:## Playwright Library
packages/mcp-browser-automation/node_modules/typescript/SECURITY.md:33:## Preferred Languages
packages/mcp-browser-automation/node_modules/typescript/SECURITY.md:37:## Policy
packages/auth/node_modules/bun-types/docs/bundler/plugins.mdx:89:## Plugin lifecycle
packages/auth/node_modules/bun-types/docs/bundler/fullstack.mdx:253:## Production Mode
packages/auth/node_modules/bun-types/docs/bundler/fullstack.mdx:405:## Plugins
packages/auth/node_modules/bun-types/docs/bundler/esbuild.mdx:21:## Performance
packages/auth/node_modules/bun-types/docs/bundler/esbuild.mdx:179:## Plugin API
packages/auth/node_modules/bun-types/docs/bundler/bytecode.mdx:61:## Performance impact
packages/auth/node_modules/bun-types/docs/bundler/bytecode.mdx:138:## Production deployment
packages/auth/node_modules/bun-types/docs/bundler/html-static.mdx:216:## Plugins
packages/auth/node_modules/bun-types/docs/bundler/html-static.mdx:417:## Plugin API
packages/auth/node_modules/bun-types/docs/guides/test/concurrent-test-glob.mdx:10:## Project Structure
packages/auth/node_modules/bun-types/docs/guides/util/upgrade.mdx:75:## Package manager users
packages/auth/node_modules/bun-types/docs/project/license.mdx:47:## Polyfills
packages/auth/node_modules/bun-types/docs/project/building-windows.mdx:10:## Prerequisites
packages/auth/node_modules/bun-types/docs/pm/cli/install.mdx:159:## Production mode
packages/auth/node_modules/bun-types/docs/pm/cli/install.mdx:414:## Platform-specific dependencies?
packages/auth/node_modules/bun-types/docs/pm/cli/install.mdx:432:## Peer dependencies?
packages/auth/node_modules/bun-types/docs/pm/cli/install.mdx:452:## Platform-specific backends
packages/auth/node_modules/bun-types/docs/pm/cli/publish.mdx:11:## Publishing the package from the current working directory
packages/auth/node_modules/bun-types/docs/pm/bunx.mdx:74:## Package flag
packages/auth/node_modules/bun-types/docs/pm/catalogs.mdx:287:## Publishing

exec
/bin/bash -lc "sed -n '90,150p' scripts/autores-ingest-harvest.ts; sed -n '80,120p' scripts/egos-showcase-ingest.ts; sed -n '130,190p' scripts/auto-disseminate.sh" in /home/enio/egos
 succeeded in 0ms:
  const text = content.toLowerCase();
  return /solut|fix|implement|criado|added|atualizado|updated|instala|deve|obrigatório|padrão|regra/.test(text);
}

function extractIncRefs(content: string): string[] {
  const matches = content.matchAll(/INC-\d{3}[a-zA-Z-]*/g);
  return [...new Set([...matches].map(m => m[0]))];
}

// ---------------------------------------------------------------------------
// Parser: extract learning entries from HARVEST.md
// ---------------------------------------------------------------------------

function parseHarvest(content: string): HarvestEntry[] {
  const lines = content.split("\n");
  const entries: HarvestEntry[] = [];
  let currentEntry: { id: string; titleLine: string; startLine: number } | null = null;
  let currentContent: string[] = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Match: ## P97 — ..., ## P42-P45 Patterns ..., ## P5 Session Patterns ...
    const headerMatch = line.match(/^## (P[\d][\w-]*)/);

    if (headerMatch) {
      // Save previous entry
      if (currentEntry) {
        const body = currentContent.join("\n");
        const titleRest = currentEntry.titleLine.replace(/^## P[\w-]+ ?[—-]? ?/, "").trim();

        // Extract date from header
        const dateMatch = currentEntry.titleLine.match(/(\d{4}-\d{2}-\d{2})/);
        const date = dateMatch ? dateMatch[1] : "2026-04-01";

        const domain = classifyDomain(titleRest, body);
        const severity = classifySeverity(titleRest, body);
        const evQuality = classifyEvidenceQuality(body);
        const actionable = isActionable(body);
        const incRefs = extractIncRefs(body);

        entries.push({
          learning_id: currentEntry.id,
          domain,
          severity,
          is_actionable: actionable,
          evidence_quality: evQuality,
          title: titleRest.slice(0, 200),
          content: body.slice(0, 2000),
          file: "docs/knowledge/HARVEST.md",
          line: currentEntry.startLine,
          date,
          inc_refs: incRefs,
          ingested_at: NOW,
        });
      }

      currentEntry = { id: headerMatch[1], titleLine: line, startLine: i + 1 };
      currentContent = [];
    } else if (currentEntry) {
      // Stop collecting at next top-level section (##) that's not a P-entry
function parseHarvestMd(): Entity[] {
  const entities: Entity[] = [];
  try {
    const content = readFileSync(CONFIG.sources.harvest, "utf-8");
    
    // Extract patterns (P###)
    const patternRegex = /## P(\d+):\s*(.+)/g;
    let match;
    
    while ((match = patternRegex.exec(content)) !== null) {
      const [, num, title] = match;
      entities.push({
        id: `pattern-P${num}`,
        type: "Pattern",
        name: title.trim(),
        attributes: {
          patternNumber: parseInt(num),
          fullId: `P${num}`,
        },
        source: "HARVEST.md",
      });
    }
  } catch (e) {
    console.error("Error parsing HARVEST.md:", e);
  }
  return entities;
}

function parseCapabilitiesMd(): Entity[] {
  const entities: Entity[] = [];
  try {
    const content = readFileSync(CONFIG.sources.capabilities, "utf-8");
    
    // Extract capability sections
    const capRegex = /## (\w+-\d+):\s*(.+?)\n/g;
    let match;
    
    while ((match = capRegex.exec(content)) !== null) {
      const [, id, name] = match;
      entities.push({
        id: `capability-${id}`,
      continue
    fi
    # Match checkbox pattern: - [ ] ... TASK-ID ...
    if grep -qE "^\- \[ \].*\b${task_id}\b" "$TASKS_FILE" 2>/dev/null; then
      if [ "$DRY" = "--dry" ]; then
        echo "  [DRY] [deprecated subject] would mark $task_id done"
      else
        sed -i "s/^- \[ \] \(.*\b${task_id}\b.*\)/- [x] \1 ✅ ${DATE}/" "$TASKS_FILE"
        echo "  ⚠️  [deprecated] marked $task_id via subject (migrate to: Closes $task_id in body)"
        MARKED=$((MARKED + 1))
      fi
    fi
  done
  [ "$MARKED" -gt 0 ] && echo "[auto-disseminate] $MARKED task(s) marked via subject (DEPRECATED — use Closes trailers)"
elif [ "$SKIP_AUTOMARK" = "1" ]; then
  echo "[auto-disseminate] skipping subject auto-mark — negative-completion keywords or list notation"
elif [ -n "$TASK_IDS" ] && [ "$_in_rebase" = "1" ]; then
  echo "  [rebase] skipping TASKS.md modification to avoid dirty worktree"
fi

# ── 2. LEARNING: lines → HARVEST.md ─────────────────────────────────────────
LEARNINGS=$(echo "$COMMIT_MSG" | grep -E '^LEARNING:' | sed 's/^LEARNING:[[:space:]]*//' || true)

if [ -n "$LEARNINGS" ] && [ -f "$HARVEST_FILE" ]; then
  if [ "$DRY" = "--dry" ]; then
    echo "  [DRY] would append learnings to HARVEST.md:"
    echo "$LEARNINGS" | sed 's/^/    - /'
  else
    {
      echo ""
      echo "### Auto-harvested — $COMMIT_HASH ($DATE)"
      echo ""
      while IFS= read -r learning; do
        echo "- $learning"
      done <<< "$LEARNINGS"
    } >> "$HARVEST_FILE"
    echo "[auto-disseminate] learnings appended to HARVEST.md"
  fi
fi

# ── 3. New capability warning ────────────────────────────────────────────────
# If commit subject starts with "feat(" and CAPABILITY_REGISTRY.md exists,
# check that the capability name appears somewhere in the registry.
if echo "$COMMIT_SUBJECT" | grep -qE '^feat\('; then
  CAP_NAME=$(echo "$COMMIT_SUBJECT" | grep -oP '(?<=feat\()([^)]+)' || true)
  if [ -n "$CAP_NAME" ] && [ -f "$CAP_REG" ]; then
    if ! grep -qi "$CAP_NAME" "$CAP_REG" 2>/dev/null; then
      echo "  ⚠️  WARNING: feat($CAP_NAME) not found in CAPABILITY_REGISTRY.md"
      echo "       Consider adding a §N entry: docs/CAPABILITY_REGISTRY.md"
    fi
  fi
fi

# ── 4. PUBLISH: trigger → Telegram approval gate (DISS-005) ─────────────────
# If commit body has "PUBLISH: <topic>" line, queue for human approval via Telegram.
# NEVER auto-publishes — article-writer only runs after /approve-pub <hash>.
PUBLISH_TOPIC=$(echo "$COMMIT_MSG" | grep -E '^PUBLISH:' | sed 's/^PUBLISH:[[:space:]]*//' | head -1 || true)

if [ -n "$PUBLISH_TOPIC" ]; then
  PENDING_FILE="/tmp/egos-publish-pending.json"
  ARTICLE_WRITER="$REPO_ROOT/agents/agents/article-writer.ts"

exec
/bin/bash -lc "grep -n '"'^## P17[0-9]'"' docs/knowledge/HARVEST.md | head -10" in /home/enio/egos
 succeeded in 0ms:
14:## P173 — 2026-06-08: Fluxo unificado HTML + NotebookLM por cliente
35:## P172 — 2026-06-08: Banda Cognitiva — preço no vídeo e HTML por cliente
45:## P171 — 2026-06-08: Guard Brasil — escopo correto vs pseudonimização
57:## P170 — 2026-06-07: Mapa de Consumo de Tokens LLM (OpenRouter/Gemini)

codex
The patch introduces a HARVEST entry that does not follow the format consumed by existing ingestion scripts, so the newly documented learning will not be discoverable by downstream tooling.

Review comment:

- [P2] Use the P-entry heading format for P174 — /home/enio/egos/docs/knowledge/HARVEST.md:9-10
  When HARVEST is ingested by existing tooling, this new P174 entry will be skipped because it is formatted as bold text instead of the established `## P...` section header; for example `scripts/autores-ingest-harvest.ts` only starts entries on lines matching `^## (P[\d][\w-]*)`. As a result the file advertises P174 as latest, but RAG/autoresearch ingestion will still only see P173 and older entries.
The patch introduces a HARVEST entry that does not follow the format consumed by existing ingestion scripts, so the newly documented learning will not be discoverable by downstream tooling.

Review comment:

- [P2] Use the P-entry heading format for P174 — /home/enio/egos/docs/knowledge/HARVEST.md:9-10
  When HARVEST is ingested by existing tooling, this new P174 entry will be skipped because it is formatted as bold text instead of the established `## P...` section header; for example `scripts/autores-ingest-harvest.ts` only starts entries on lines matching `^## (P[\d][\w-]*)`. As a result the file advertises P174 as latest, but RAG/autoresearch ingestion will still only see P173 and older entries.
```
