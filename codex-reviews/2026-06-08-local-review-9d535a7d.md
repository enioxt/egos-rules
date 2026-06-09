# Codex Local Review — 2026-06-08T16:48:31Z

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
session id: 019ea822-cd74-71b1-a8c4-e8070602a5ec
--------
user
changes against 'HEAD~3'
2026-06-08T16:48:34.689148Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-08T16:48:34.700376Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 68654ab1a6a45106aa16f3fdb49d4073fbbca7dd --stat && git diff 68654ab1a6a45106aa16f3fdb49d4073fbbca7dd' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                              |  6 ++-
 .egos-manifest.yaml                                | 27 +++++-----
 CLAUDE.md                                          |  1 +
 TASKS.md                                           |  7 +++
 apps/egos-landing/public/timeline/rss              |  2 +-
 apps/egos-landing/public/timeline/rss.xml          |  2 +-
 docs/knowledge/HARVEST.md                          | 46 +++++++++++++++-
 docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md          | 61 ++++++++++++++++++++++
 docs/strategy/HERMES_WHATSAPP_USECASE_MAP.md       | 55 +++++++++++++++++++
 docs/strategy/gpt-instrucoes-COLAR.md              | 53 +++++++++++++++++++
 docs/strategy/gpt-knowledge/egos-casos-por-area.md | 30 +++++++++++
 .../gpt-knowledge/egos-metodo-e-checklist.md       | 33 ++++++++++++
 docs/strategy/gpt-knowledge/egos-o-que-e.md        | 26 +++++++++
 13 files changed, 329 insertions(+), 20 deletions(-)
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
 
diff --git a/CLAUDE.md b/CLAUDE.md
index d3c6845e..9413d5f0 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -91,6 +91,7 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
   - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
   - Atualizar README na mesma sessão que muda funcionalidade
   - Auditar com `/start` + checar score ao iniciar em qualquer repo
+- **DOC AUDIENCE [T1 — Enio 2026-06-07, R-DOC-AUDIENCE-001]:** O **README é a ÚNICA doc para humano** (PT-BR, didático). **TODA a demais documentação de sistema é AI⟷AI** — escrita para outra IA consumir (densa, machine-parseable, sem floreio/repetição/narrativa humana; estrutura > prosa; classificação REAL/CONCEPT/PHANTOM; paths/IDs explícitos). **Humano interage preferencialmente via HTML / visualização / gráficos / explicação renderizada — não markdown cru.** Logo: dashboards, páginas vivas e relatórios HTML são a interface humana; markdown é contexto de máquina. Disseminar (`/disseminate`) a toda a frota. Origem: foco GOW (prova > prosa) + economia de contexto.
 - **Sync Frontend↔Backend [T1 — Enio 2026-06-04]:** o frontend não pode ficar mais que **20%** atrás do backend (Pareto 80/20 → mirar 99%). Quando o backend evolui e o frontend não reflete, é **obrigatório criar tasks priorizadas de frontend** (o gate **gera tasks, não bloqueia** o commit — não trava flow/estado do backend). O frontend deve **mostrar o que já temos**, sem medo, **em nome do EGOS** (entidade/empresa), nunca em 1ª pessoa do Enio. Gate a implementar: `FE-BE-SYNC-GATE-001`.
 
 ---
diff --git a/TASKS.md b/TASKS.md
index 4968af40..e7fcbf89 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -10,6 +10,13 @@
 
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 > Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
+
+## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
+> Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
+- [ ] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio.
+- [ ] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto).
+- [ ] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — VERIFICAR ANTES da demo: política Meta/WhatsApp Business restringe uso por segurança/governo; Enio é PCMG. Desenhar como agente de negócio/rotina com escopo declarado, não institucional de segurança. Gate jurídico. SSOT: HERMES_WHATSAPP_USECASE_MAP.md §5.
+- [ ] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medir quantos dos 80 CBCs têm ≥3 golden cases PASSANDO (run_golden_cases). NÃO apresentar "80 CBCs" como maturidade sem esse número. A honestidade é a prova.
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
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
 
diff --git a/docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md b/docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md
new file mode 100644
index 00000000..a4d4a0bd
--- /dev/null
+++ b/docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md
@@ -0,0 +1,61 @@
+# EGOS Diagnostic Protocol — instruções portáteis (rodar no Claude Code da pessoa)
+
+**Versão:** 0.1 DRAFT | **Data:** 2026-06-07 | **Audiência:** AI⟷AI (R-DOC-AUDIENCE-001) — este doc é consumido por OUTRA IA (o Claude Code da pessoa). Humano vê o RELATÓRIO HTML no fim.
+**Origem:** corte Enio 2026-06-07 (sprint GOW). Une `/diag` + `/readiness` + `/inception` + método anti-alucinação + CBC/eval-runner num protocolo portátil e auto-rigoroso.
+
+## O que é
+Um conjunto de instruções que a pessoa cola/roda no Claude Code (ou Cursor/Windsurf) **na máquina/repo dela**. A IA dela executa o protocolo: descobre o sistema, classifica tudo REAL/CONCEPT/PHANTOM, mede contra critérios EGOS, e produz um **diagnóstico pontuado em HTML**. O critério de aceitação é **rigoroso e cresce** conforme a IA coleta mais informação (ciclos Fibonacci, com teto).
+
+## Por que é o formato mais compartilhável (e prova valor)
+- A pessoa NÃO precisa confiar em slide: ela **roda na máquina dela** e vê o EGOS-método agir sobre o sistema dela.
+- O output é honesto (REAL/CONCEPT/PHANTOM + score) — a honestidade É a venda.
+- Para a GOW: roda no repo deles → mostra exatamente onde o sistema de IA deles está forte/fraco em governança, anti-alucinação, observabilidade, cobertura de eval, segurança.
+
+## PROTOCOLO (a IA executora segue isto, ciclo a ciclo)
+
+### Ciclo 1 — Descoberta (barato, amplo)
+1. Mapeie o sistema: linguagens, frameworks, serviços, agentes/LLM, MCPs/tools, CI, testes.
+2. Classifique CADA componente afirmado: **REAL** (existe+roda, cite path:line) · **CONCEPT** (código existe, não wired) · **PHANTOM** (mencionado, sem evidência).
+3. Regra dura: nenhuma afirmação sem fonte consultada (path/comando). Afirmação sem prova = inválida.
+4. Saída do ciclo: inventário classificado + lista de incógnitas.
+
+### Ciclo 2 — Medição contra os 6 eixos EGOS (cada eixo 0–100, com evidência)
+1. **Governança** — há regras versionadas? gates? precedência? (procure CLAUDE.md/AGENTS.md/pre-commit/rules).
+2. **Anti-alucinação** — o sistema separa fato/inferência/hipótese? evita afirmar sem fonte?
+3. **Segurança/dado** — PII/secrets têm scanner+gate? dado sensível protegido? (gitleaks, PII scan).
+4. **Observabilidade** — há telemetria de LLM calls/tool calls/jobs? dá pra ver "o que aconteceu"?
+5. **Cobertura de prova (eval)** — capacidades têm teste COMPORTAMENTAL (golden cases ≥3), não só unit? Qual % das capacidades declaradas tem prova?
+6. **Reversibilidade/HITL** — ações de impacto pedem confirmação? há rollback/audit trail?
+> Cada eixo: nota + 2-3 evidências (path) + 1 gap. Sem evidência → nota baixa, não "assumir bom".
+
+### Ciclo 3 — Aprofundamento (só nos eixos < 60)
+Para cada eixo fraco, investigue a causa-raiz (1 nível mais fundo) e proponha o **menor passo** que sobe a nota. Pare quando: todos os eixos têm evidência OU 3 ciclos sem achado novo (loop-until-dry).
+
+### Critério de ACEITAÇÃO (rigoroso e crescente)
+O diagnóstico só é "completo" quando:
+- [ ] Todo componente afirmado está classificado REAL/CONCEPT/PHANTOM com path.
+- [ ] Os 6 eixos têm nota + ≥2 evidências cada.
+- [ ] Nenhuma nota foi dada sem fonte consultada (anti-alucinação).
+- [ ] Gaps têm o menor-passo proposto.
+- [ ] Há ≥1 métrica dura medida (ex: "% de capacidades com golden case passando").
+- [ ] O relatório HTML foi gerado.
+> "Crescente": a cada incógnita resolvida, novos sub-critérios entram (ex: achou MCPs → exigir audit trail dos MCPs). Teto: 5 ciclos.
+
+### Saída (para o HUMANO) — HTML, não markdown cru (R-DOC-AUDIENCE-001)
+Gerar `diagnostico-egos.html`: score geral + radar dos 6 eixos + tabela REAL/CONCEPT/PHANTOM + top-5 gaps com menor-passo + 1 métrica dura. Visual, escaneável em 30s.
+
+## Pacote de distribuição (o que a pessoa recebe)
+1. **`EGOS_DIAGNOSTIC_PROTOCOL.md`** (este) — cola no Claude Code dela.
+2. **NotebookLM** (slides + vídeo) explicando: o que é o EGOS, a stack, as provas (eval-runner/CBC), por que o diagnóstico importa. Fonte = os .md do sistema.
+3. **HTML de exemplo** — um diagnóstico do PRÓPRIO EGOS (auto-diagnóstico) como amostra ("rodamos em nós mesmos, olha o resultado honesto").
+
+## Próximos passos (build — sprint GOW)
+1. [ ] Refinar este protocolo (Banda + 1 teste real rodando no próprio EGOS = auto-diagnóstico → gera o HTML de amostra).
+2. [ ] Gerar o HTML do auto-diagnóstico EGOS (prova: rodamos em nós).
+3. [ ] NotebookLM MCP: subir os .md do sistema → gerar slides + vídeo.
+4. [ ] Empacotar e testar com 1 repo externo (sandbox) antes da GOW.
+
+## ⚠️ Travas (Karpathy + gate)
+- Critério "crescente" tem **teto (5 ciclos)** — não vira loop infinito.
+- Diagnóstico roda na máquina da pessoa → **não exfiltra dado**; só lê e classifica localmente. Relatório fica com ela.
+- Não prometer nota; o valor é a honestidade do REAL/CONCEPT/PHANTOM.
diff --git a/docs/strategy/HERMES_WHATSAPP_USECASE_MAP.md b/docs/strategy/HERMES_WHATSAPP_USECASE_MAP.md
new file mode 100644
index 00000000..07a42d91
--- /dev/null
+++ b/docs/strategy/HERMES_WHATSAPP_USECASE_MAP.md
@@ -0,0 +1,55 @@
+# EGOS — Use Case Hermes/WhatsApp: Mapa do que EXISTE (evidência) + gaps + dados p/ dashboard
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** mapeamento (3 sondas, proveniência). Base: PPTX `egos_hermes_whatsapp_architecture.pptx` (14 slides) + repo real.
+**Arquiteto:** EGOS Prime. Anti-alucinação: tudo REAL/CONCEPT/PHANTOM com path.
+
+## 1. O fluxo WhatsApp→Hermes→resposta — FUNCIONA HOJE (REAL, em produção)
+- Evolution API (container VPS) → webhook `POST /channels/whatsapp/webhook` (`apps/egos-gateway/src/channels/whatsapp.ts:827`) → tenant routing + kill-switch (fail-closed) + anti-ban + parse mídia → `orchestrate()` (`orchestrator.ts:1542`).
+- `orchestrate`: histórico Supabase (12 msgs) → system prompt por tenant → **OpenRouter gemini-2.5-flash** → **loop de até 4 tool calls** (`orchestrator.ts:1588`) → resposta formatada por canal → `sendText()` Evolution.
+- 21 tools no loop: search_products/faq (RAG Supabase FTS REAL), guard_test (PII via guard.egos.ia.br), notify_human, kb_search, gmail, calendar, wiki...
+- Persistência: `egos_chat_history`; billing: `consulting_token_log`+`api_usage` (custo por LLM call). Telegram idem (só Enio).
+- **Caso mais completo: tenant g-pecas** (RAG catálogo+FAQ em operação real).
+
+## 2. Gaps vs "Hermes executor governado com evidência" (o que falta)
+1. **Classificação de risco pré-LLM ausente** — guard só roda se o LLM decidir chamar `guard_test`; não é gate obrigatório na entrada.
+2. **Evidence chain não está na resposta** — `packages/hermes-schema` (severity+finding_type+evidence) existe mas só no pipeline de review de commit, desconectado do chat.
+3. **callHermes L1 isolado do gateway** — `packages/shared/.../llm-router.ts` (fallback+circuit breaker) NÃO é importado pelo gateway (Docker standalone reimplementou LLM inline). Dois caminhos LLM.
+4. **Hermes L2 (Python VPS, fork NousResearch, 19 plugins)** — roda systemd mas status "unverified" e NÃO conectado ao webhook WhatsApp.
+5. **Sem tool registry / intent routing central** — Claude Code injeta tools; `mcp-ops::route_request` é lookup estático.
+
+## 3. Capacidades que o agente PODE chamar HOJE (9 MCPs wired + g-pecas)
+- egos-security: `guard_scan_pii`/`guard_check_safe` (npm `@egosbr/guard-brasil-mcp` v0.2.0, auditado em `mcp_audit_events` — o pipeline MAIS completo)
+- egos-knowledge: `search_wiki`/`get_page`/`kb_export_citations`
+- egos-memory, egos-governance (`repo_health`/`list_tasks`), egos-eval-runner (`run_golden_cases`), egos-ops (`route_request`/`health_check`), egos-observability (`pm2_status`/`audit_query`/`system_metrics`), egos-skills-registry, egos-browser-automation
+- **mcp-g-pecas: 33 tools** (catalog/orders/faq/kpi + 17 admin) — DEPLOYED (gpecas.egos.ia.br) mas fora do `.mcp.json` kernel
+- API: `/api/v1/meta-prompts`, gateway `/v1/*` (health/tenants/storefront/ops)
+- **A construir:** `mcp-egos-public` (CONCEPT, task MCP-EGOS-PUBLIC-001) p/ expor ao GPT/externos; item_intake como tool.
+
+## 4. Dados REAIS p/ dashboard (a observabilidade JÁ existe)
+| Fonte | Path | Mostra | Live? |
+|---|---|---|---|
+| api_usage (Supabase) | orchestrator.ts:1652 | **LLM calls: model, tokens, custo, canal** | live (por chamada, desde 2026-06-01) |
+| mcp_audit_events | migration 20260514 | invocações MCP: tool, success/error, duration | live (cache 60s no HQ) |
+| egos_agent_events | migration 20260406 | eventos de 8+ agentes, severity, payload | live (polling 15s) |
+| coordination-history.jsonl | ~/.egos (511) | LLM por commit: modelo, tokens, latência, custo | append |
+| sentinela-flags.jsonl | ~/.egos (1769) | P0/SMOKE_FAIL/TASKS_OVERSIZE | cron |
+| agents/.logs/events.jsonl | egos/agents (1784) | event bus agentes internos | append (sem frontend) |
+| review-queue + hermes-finding-events | ~/.egos | fila + transições de findings | append |
+| MyceliumPage | egos-landing | grafo SVG live (Supabase Realtime `mycelium_live`) | live MAS pulsos simulados manualmente |
+| HQ (apps/egos-hq) | /events /governance/mcp-audit /vps | heartbeat agentes, MCP audit, health, VPS | polling (WS comentado) |
+| atrian-observability | packages/atrian-observability | 12 span types (tool.call, llm.request...) | PRONTO, sem adoção |
+| middleware tool-metrics/prompt-snapshot | packages/shared/src/middleware | tabelas existem, NÃO wired | vazio |
+
+**Veredito:** dá pra montar dashboard com dados REAIS hoje (HQ já mostra parte: LLM calls, MCP audit, agent events, health). Falta p/ "tudo ao vivo": (a) push real (SSE/WS — hoje é polling, WS comentado no HQ), (b) tool-call/prompt telemetry por turno (middleware atrian/tool-metrics PRONTO mas não adotado), (c) Mycelium pulsar com evento REAL (hoje manual).
+
+## 5. Red Zone — Compliance (slide 12 do deck, crítico p/ Enio)
+Política Meta/WhatsApp Business cita **restrições a órgãos de segurança/militar/inteligência/governo**. Desenhar como **agente operacional de negócio/rotina com escopo declarado**, NÃO assistente genérico distribuído publicamente, NEM uso institucional de segurança. Gate jurídico antes de produção. Começar: número controlado, sandbox, dados fictícios, comandos de baixo risco.
+
+## 6. O que isso diz do Enio (arquiteto)
+A obra PROVA: ele não fala sobre IA agentic — ele tem em produção um agente WhatsApp→LLM→tools governado, com audit trail, kill-switch fail-closed, telemetria, 9 MCPs, evidence-first. Definição: **arquiteto de sistemas de IA governados e observáveis** (a versão concreta de "investigador de IA / arquiteto de confiança"). Este use case é a prova viva de "o valor sou eu, provado pelo código".
+
+## 7. Próximos passos (ordem)
+1. **3 dashboards (mockup HTML)** sobre os dados reais da §4 — iterar/escolher.
+2. Wire mínimo p/ "ao vivo": Mycelium pulsar com `api_usage`/`mcp_audit` reais + SSE no HQ.
+3. Gate obrigatório guard pré-LLM (gap #1) + evidence chain na resposta (gap #2).
+4. Compliance gate (§5) antes de qualquer demo pública.
diff --git a/docs/strategy/gpt-instrucoes-COLAR.md b/docs/strategy/gpt-instrucoes-COLAR.md
new file mode 100644
index 00000000..32dd58ee
--- /dev/null
+++ b/docs/strategy/gpt-instrucoes-COLAR.md
@@ -0,0 +1,53 @@
+# GPT EGOS — Instruções prontas pra COLAR (v2 — identidade EGOS fixa)
+
+**Status:** DRAFT-HITL. Correção (Enio 2026-06-07): o GPT É o EGOS (identidade fixa), pergunta a ÁREA só pra adaptar a ajuda — não "vira" outro assistente.
+
+## Campos do GPT
+- **Nome:** `EGOS`
+- **Descrição:** `Te ajuda a usar IA com método: sem inventar respostas, sem vazar seus dados. Diz sua área e o EGOS adapta a ajuda pra você.`
+- **Instruções:** colar o bloco abaixo.
+- **Conversation starters (4):**
+  - Qual é a minha área? Quero usar IA com método no meu trabalho.
+  - Como eu uso IA sem ela inventar resposta?
+  - Tenho um dado sensível de cliente — como uso a IA sem vazar?
+  - O que é o EGOS e por onde eu começo?
+- **Knowledge (anexar os 3 .md de `docs/strategy/gpt-knowledge/`):** método+checklist, casos por área, o que é o EGOS.
+
+## INSTRUÇÕES (colar inteiro)
+```
+Você é o EGOS — um assistente de IA governada, criado pelo framework aberto EGOS (egos.ia.br · github.com/enioxt/egos-governance). Você SEMPRE é o EGOS; nunca troca de identidade nem "vira" outro assistente. Você se adapta à ÁREA de trabalho da pessoa (advocacia, saúde, contabilidade, comércio, educação, agro, etc.) para ajudar melhor — mas continua sendo o EGOS.
+
+Seu papel: ajudar a pessoa a usar IA (ChatGPT, Claude, Gemini) com método — sem inventar respostas, sem expor dados sensíveis, separando o que é fato do que é achismo.
+
+── PRIMEIRA INTERAÇÃO (boas-vindas) ──
+Apresente-se em 1 linha e faça UMA pergunta. Linguagem natural, sem formato rígido aqui:
+"Olá! Eu sou o EGOS. Te ajudo a usar IA com método — sem ela inventar e sem expor seus dados. Pra começar, me conta: qual é a sua área de trabalho?"
+Com a resposta, proponha em 2–4 linhas COMO você vai ajudar naquela área (o que você cobre, o que evita, e 1 exemplo concreto). Confirme com a pessoa e siga ajudando — sempre como EGOS.
+Regra de ouro: UMA pergunta por vez quando houver dúvida. Conduza, não despeje.
+
+── COMO O EGOS PENSA (Triplo Filtro) ──
+1. Dado seguro — o que é sensível (CPF, dados de cliente, prontuário) não deve ir pra IA sem necessidade; avise e mascare (ex: CPF ***.***.***-**).
+2. Grau de certeza — classifique o que afirma: CONFIRMADO (base verificável) · INFERIDO (deduzido) · HIPÓTESE (plausível, não verificado) · NÃO SEI (falta base) · AÇÃO (próximo passo).
+3. Revisão humana — a decisão final é sempre da pessoa. Você propõe, ela dispõe.
+
+── ANTI-ALUCINAÇÃO ──
+Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências ou links. Sem base = HIPÓTESE ou NÃO SEI; diga o que falta. Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira "alta confiança baseada em evidências".
+
+── ZONA VERMELHA (pause antes) ──
+Antes de ação de alto impacto (enviar comunicação oficial, publicar, deletar, assinar, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível): identifique a ação, liste riscos, proponha alternativa mais segura, aguarde confirmação explícita.
+
+── LIMITAÇÕES ──
+Você não substitui profissional habilitado. Em decisão de consequência jurídica/médica/financeira: "Esta análise é auxiliar. Consulte um profissional habilitado."
+
+── MODO DE RESPOSTA ──
+Direto, profissional, sem jargão. Resumo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
+Em análises relevantes, use o formato: Classificação / Síntese / Evidências / Riscos / Próxima ação.
+
+── SOBRE O EGOS (quando perguntarem) ──
+O EGOS é um framework aberto de governança para IA — método, ferramentas e comunidade pra usar IA com clareza e segurança. Tem ferramentas grátis em egos.ia.br (inclusive um detector de dados sensíveis), o código aberto em github.com/enioxt/egos-governance, e a comunidade no Telegram t.me/ethikin. Convide com naturalidade, sem empurrar. NUNCA fale de preço.
+
+── REGRA FINAL ──
+Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.
+```
+
+*FORA do GPT (não colar/anexar — vazaria): infra, dado real, paths /home, tokens, contexto PCMG. Só método público.*
diff --git a/docs/strategy/gpt-knowledge/egos-casos-por-area.md b/docs/strategy/gpt-knowledge/egos-casos-por-area.md
new file mode 100644
index 00000000..597e84a9
--- /dev/null
+++ b/docs/strategy/gpt-knowledge/egos-casos-por-area.md
@@ -0,0 +1,30 @@
+# EGOS — Como usar IA com método na sua área
+
+Use estes exemplos para adaptar a ajuda à área da pessoa. O método é sempre o mesmo (Triplo Filtro); muda só o que ela coloca dentro.
+
+## ⚖️ Advogado / escritório
+- Problema: analisar documentos e responder clientes sem expor dados do processo.
+- Como ajudar: organizar peças e prazos, resumir documentos (com os dados sensíveis mascarados), preparar rascunhos. Nunca dar parecer conclusivo — isso é do advogado. Tudo com registro do que foi feito.
+
+## 🩺 Médico / dentista / veterinário / clínica
+- Problema: usar IA sem expor prontuário ou dados de paciente.
+- Como ajudar: organizar textos, orientações e materiais com os dados protegidos; sempre com revisão humana antes de qualquer orientação clínica. Não substitui avaliação profissional.
+
+## 🧾 Contador
+- Problema: dados fiscais, CPF e CNPJ em tarefas repetitivas.
+- Como ajudar: organizar informações para conferência e análise sem tratar dado sensível como texto comum; checklists de obrigações; rascunhos de comunicação com clientes.
+
+## 🍽️ Comércio / restaurante
+- Problema: cardápio e catálogo vivem em foto, papel ou WhatsApp.
+- Como ajudar: transformar foto de cardápio/catálogo em planilha organizada (com conferência humana antes de cadastrar); textos de divulgação; respostas padrão de atendimento.
+
+## 📚 Professor / escola
+- Problema: IA cria material bonito, mas às vezes com erro ou fonte fraca.
+- Como ajudar: montar aulas, exercícios e resumos com pontos de conferência antes de usar com alunos; adaptar linguagem por nível; separar o que é fato do que precisa checar.
+
+## 🌾 Agrônomo / produtor rural
+- Problema: laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.
+- Como ajudar: organizar informações, preparar relatórios e destacar o que precisa ser validado por um profissional antes de virar recomendação.
+
+## Outras áreas (corretor, representante, transportadora, RH...)
+O mesmo método se aplica: descobrir a área → adaptar o que cobre e o que evita → ajudar com dado protegido, certeza classificada e revisão humana.
diff --git a/docs/strategy/gpt-knowledge/egos-metodo-e-checklist.md b/docs/strategy/gpt-knowledge/egos-metodo-e-checklist.md
new file mode 100644
index 00000000..45ba7b21
--- /dev/null
+++ b/docs/strategy/gpt-knowledge/egos-metodo-e-checklist.md
@@ -0,0 +1,33 @@
+# EGOS — O Método e o Checklist de Segurança de IA
+
+## O Triplo Filtro (o coração do método)
+Toda vez que você usa IA no trabalho, passe pelos 3 filtros:
+
+**1. Dado seguro** — o que é sensível não vai pra IA sem necessidade.
+- Pergunte: "a IA precisa deste dado, ou posso descrever o padrão?"
+- Mascare antes de colar: CPF/nome/processo → `[NOME]`, `[CPF]`, `[PROCESSO]`.
+- LLM externo (ChatGPT/Claude/Gemini) é servidor de terceiro — não é ambiente sigiloso.
+
+**2. Grau de certeza** — separe fato de achismo. Classifique:
+- **CONFIRMADO** — tem base verificável (documento, fonte).
+- **INFERIDO** — é uma dedução lógica a partir dos dados.
+- **HIPÓTESE** — é plausível, mas precisa checar.
+- **NÃO SEI** — falta base; diga o que falta.
+- **AÇÃO** — um próximo passo concreto.
+> Exemplo: a IA diz "o artigo 5º garante isso". Sem você ver o artigo, isso é **HIPÓTESE**, não CONFIRMADO. Verifique antes de usar.
+
+**3. Revisão humana** — a decisão final é sempre sua. A IA propõe, você dispõe. Releia antes de publicar: alucinação de IA é confiante — leia com o olho de quem vai receber.
+
+## Checklist de Segurança de IA (1 página)
+- [ ] **Dado real só com necessidade** — "preciso colar isso ou posso descrever?"
+- [ ] **PII mascarada antes de colar** — CPF, nome, processo viram etiquetas.
+- [ ] **LLM externo ≠ sigilo** — verifique os termos de uso; sigilo profissional pede cuidado redobrado.
+- [ ] **Output de IA é INFERIDO** — número, data ou citação gerada precisa de verificação independente.
+- [ ] **Nunca cole credenciais** — senha, token, chave, certificado ficam fora do prompt.
+- [ ] **Histórico tem memória** — usou dado sensível? limpe depois; veja se a conta não treina com seus dados.
+- [ ] **Releia antes de publicar** — a IA erra com confiança.
+
+## Como o EGOS te ajuda a aplicar isso
+- Um GPT/assistente que já vem com esses filtros embutidos (este aqui).
+- Um detector de dados sensíveis (Guard Brasil) em egos.ia.br que mascara CPF/CNPJ/telefone antes de enviar.
+- Uma comunidade pra trocar o que funciona, por área.
diff --git a/docs/strategy/gpt-knowledge/egos-o-que-e.md b/docs/strategy/gpt-knowledge/egos-o-que-e.md
new file mode 100644
index 00000000..aa6306ef
--- /dev/null
+++ b/docs/strategy/gpt-knowledge/egos-o-que-e.md
@@ -0,0 +1,26 @@
+# EGOS — O que é, e por onde ir mais fundo
+
+## O que é o EGOS
+O EGOS é um framework aberto de **governança para IA** — um conjunto de método, ferramentas e comunidade para usar inteligência artificial (ChatGPT, Claude, Gemini) com mais clareza e segurança. A ideia central: a IA é muito útil, mas precisa de método para **não inventar respostas** e **não expor seus dados**. O EGOS organiza esse uso.
+
+## O que NÃO é
+- Não é "mais um amontoado de PDF". O valor está no método, nas ferramentas que funcionam e na comunidade.
+- Não promete enriquecimento, renda fácil nem resultado garantido.
+- Não substitui profissional habilitado (advogado, médico, contador).
+
+## O método em uma frase
+Fazer a IA (e você) trabalhar com o **Triplo Filtro**: dado seguro + grau de certeza (fato vs. achismo) + revisão humana.
+
+## O que já existe pra usar hoje (grátis)
+- **Este GPT** — te ajuda a usar IA com método, adaptado à sua área.
+- **egos.ia.br** — site com ferramentas, incluindo um detector de dados sensíveis (Guard Brasil) que mascara CPF/CNPJ/telefone antes de enviar a qualquer IA.
+- **github.com/enioxt/egos-governance** — o método e parte do código, abertos, pra quem quiser inspecionar.
+
+## A comunidade
+- **Telegram (aberto, gratuito): t.me/ethikin** — onde a gente conversa, compartilha ferramentas e aprendizados, e ajuda cada um a melhorar sua literacia em IA, por área.
+- O conteúdo cresce com o tempo; cada área vai ganhando ferramenta própria, construída com quem vive o problema.
+
+## Por que o EGOS é diferente
+A maioria por aí ensina a usar IA. O EGOS nasce de quem **construiu** sistemas de IA governada rodando em dado real, no aberto — então é evidência, não só discurso. Você não precisa acreditar: dá pra conferir no GitHub.
+
+> Convide as pessoas com naturalidade pra conhecer egos.ia.br e o Telegram. Nunca fale de preço.

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
exec
/bin/bash -lc "ls docs/knowledge/CAPABILITY_CROSS_INDEX.md docs/CAPABILITY_CROSS_INDEX.md 2>&1 || true
python3 - <<'PY'
import yaml
with open('.egos-manifest.yaml') as f: d=yaml.safe_load(f)
print(type(d), d.keys())
print('claims', len(d['claims']), 'endpoints', len(d.get('endpoints',[])))
print([c['id'] for c in d['claims'] if c['id']=='cross_repo_capabilities'])
PY" in /home/enio/egos
 succeeded in 0ms:
ls: cannot access 'docs/CAPABILITY_CROSS_INDEX.md': No such file or directory
docs/knowledge/CAPABILITY_CROSS_INDEX.md
<class 'dict'> dict_keys(['schema_version', 'repo', 'updated_at', 'updated_by', 'manifest_doc', 'claims', 'domains', 'endpoints'])
claims 17 endpoints 2
['cross_repo_capabilities']

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
exec
/bin/bash -lc 'bun agents/agents/doc-drift-verifier.ts --manifest .egos-manifest.yaml --json' in /home/enio/egos
 succeeded in 6387ms:
  ✅ total_agents: 27 → 27
  ✅ total_capabilities: 168 → 168 (Δ0)
  ✅ guarani_governance_files: 97 → 97 (Δ0)
  ✅ slash_commands: 61 → 62 (Δ1)
  ✅ operating_surface_entries: 35 → 35 (Δ0)
  ✅ kernel_packages: 36 → 37 (Δ1)
  ✅ commits_30d_all_repos: 1466 → 1249
  ✅ unique_differentials: 22 → 22
  ❌ completed_tasks_total: 1 → 0
0 (Δ1)
  ✅ active_products: 7 → 7
  ✅ capability_registry_sections: 19 → 97
  ✅ evg008_simplicity_check_function: 2 → 2
  ✅ karpathy_principles_in_global_claude: 1 → 1
  ✅ disseminate_pipeline_scripts: 2 → 2
  ✅ evidence_gate_blocking_schedule: 2 → 2
  ✅ pre_commit_hook_chain_stages: 70 → 168
  ✅ cross_repo_capabilities: 28 → 23

[doc-drift] Checking 8 domain(s) ...
  ✅ https://guard.egos.ia.br/health → 200 (expected 200)
  ✅ https://hq.egos.ia.br/ → 200 (expected 200)
  ✅ https://gemhunter.egos.ia.br/gem-hunter/topics → 301 (expected 301)
  ✅ https://eagleeye.egos.ia.br/ → 200 (expected 200)
  ✅ https://852.egos.ia.br/ → 200 (expected 200)
  ✅ https://inteligencia.egos.ia.br/ → 200 (expected 200)
  ✅ https://guard.egos.ia.br/health → 200 (expected 200)
  ✅ https://gemhunter.egos.ia.br/gem-hunter/topics → 301 (expected 301)
{
  "manifest": ".egos-manifest.yaml",
  "repo": "egos",
  "verified_at": "2026-06-08T16:49:36.514Z",
  "summary": {
    "total_claims": 17,
    "passed": 16,
    "warned": 0,
    "drifted": 1,
    "errors": 0,
    "total_domains": 8,
    "domains_ok": 8,
    "domains_drifted": 0
  },
  "results": [
    {
      "id": "total_agents",
      "description": "Agents registered in agents.json",
      "status": "ok",
      "last_value": "27",
      "current_value": "27",
      "tolerance": "min:18",
      "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
      "severity": "ok"
    },
    {
      "id": "total_capabilities",
      "description": "Capabilities declared in CAPABILITY_REGISTRY.md",
      "status": "ok",
      "last_value": "168",
      "current_value": "168",
      "tolerance": "±10",
      "drift_abs": 0,
      "command": "grep -c '^### ' docs/CAPABILITY_REGISTRY.md",
      "severity": "ok"
    },
    {
      "id": "guarani_governance_files",
      "description": "Governance rule files in .guarani/",
      "status": "ok",
      "last_value": "97",
      "current_value": "97",
      "tolerance": "±5",
      "drift_abs": 0,
      "command": "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
      "severity": "ok"
    },
    {
      "id": "slash_commands",
      "description": "User-invocable slash commands in .claude/commands/",
      "status": "ok",
      "last_value": "61",
      "current_value": "62",
      "tolerance": "±5",
      "drift_abs": 1,
      "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
      "severity": "ok"
    },
    {
      "id": "operating_surface_entries",
      "description": "Entradas no mapa machine-wide da superfície de operação (EGOS_OPERATING_SURFACE.yaml)",
      "status": "ok",
      "last_value": "35",
      "current_value": "35",
      "tolerance": "±4",
      "drift_abs": 0,
      "command": "grep -cE '^  - id:' docs/governance/EGOS_OPERATING_SURFACE.yaml 2>/dev/null | tr -d ' '",
      "severity": "ok"
    },
    {
      "id": "kernel_packages",
      "description": "Packages in packages/ directory",
      "status": "ok",
      "last_value": "36",
      "current_value": "37",
      "tolerance": "±2",
      "drift_abs": 1,
      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
      "severity": "ok"
    },
    {
      "id": "commits_30d_all_repos",
      "description": "Total commits across all active EGOS repos in last 30 days",
      "status": "ok",
      "last_value": "1466",
      "current_value": "1249",
      "tolerance": "min:50",
      "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
      "severity": "ok"
    },
    {
      "id": "unique_differentials",
      "description": "Unique technical differentials documented in EGOS_STATE",
      "status": "ok",
      "last_value": "22",
      "current_value": "22",
      "tolerance": "min:6",
      "command": "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
      "severity": "ok"
    },
    {
      "id": "completed_tasks_total",
      "description": "Total completed tasks in TASKS.md",
      "status": "drifted",
      "last_value": "1",
      "current_value": "0\n0",
      "tolerance": "min:1",
      "drift_abs": 1,
      "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
      "severity": "drift"
    },
    {
      "id": "active_products",
      "description": "Live products with public URLs in EGOS ecosystem",
      "status": "ok",
      "last_value": "7",
      "current_value": "7",
      "tolerance": "min:5",
      "command": "grep -c '\\*\\*URL:\\*\\*' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
      "severity": "ok"
    },
    {
      "id": "capability_registry_sections",
      "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
      "status": "ok",
      "last_value": "19",
      "current_value": "97",
      "tolerance": "min:10",
      "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
      "severity": "ok"
    },
    {
      "id": "evg008_simplicity_check_function",
      "description": "EVG-008: detectSimplicityViolations function present in evidence-gate.ts (§K.2 enforcement)",
      "status": "ok",
      "last_value": "2",
      "current_value": "2",
      "tolerance": "min:2",
      "command": "grep -c 'detectSimplicityViolations' scripts/evidence-gate.ts",
      "severity": "ok"
    },
    {
      "id": "karpathy_principles_in_global_claude",
      "description": "§K Karpathy Principles in egos-rules lazy-load (moved from CLAUDE.md core in GOV-W2-009)",
      "status": "ok",
      "last_value": "1",
      "current_value": "1",
      "tolerance": "min:1",
      "command": "grep -c 'Simplicity First' ~/.claude/egos-rules/karpathy-principles.md",
      "severity": "ok"
    },
    {
      "id": "disseminate_pipeline_scripts",
      "description": "Auto-disseminate pipeline scripts present (propagator + scanner)",
      "status": "ok",
      "last_value": "2",
      "current_value": "2",
      "tolerance": "eq:2",
      "command": "test -f scripts/disseminate-propagator.ts && test -f scripts/disseminate-scanner.ts && echo 2 || echo 0",
      "severity": "ok"
    },
    {
      "id": "evidence_gate_blocking_schedule",
      "description": "Evidence gate blocking activation date configured (WEEK2_START = 2026-04-16)",
      "status": "ok",
      "last_value": "2",
      "current_value": "2",
      "tolerance": "min:2",
      "command": "grep -c 'WEEK2_START' scripts/evidence-gate.ts",
      "severity": "ok"
    },
    {
      "id": "pre_commit_hook_chain_stages",
      "description": "Pre-commit hook chain has minimum required governance stages",
      "status": "ok",
      "last_value": "70",
      "current_value": "168",
      "tolerance": "min:15",
      "command": "grep -c '\\[' .husky/pre-commit",
      "severity": "ok"
    },
    {
      "id": "cross_repo_capabilities",
      "description": "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)",
      "status": "ok",
      "last_value": "28",
      "current_value": "23",
      "tolerance": "min:10",
      "command": "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0",
      "severity": "ok"
    }
  ],
  "domains": [
    {
      "url": "https://guard.egos.ia.br/health",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200"
    },
    {
      "url": "https://hq.egos.ia.br/",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200"
    },
    {
      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
      "status": "ok",
      "expected_status": "301",
      "actual_status": "301"
    },
    {
      "url": "https://eagleeye.egos.ia.br/",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200"
    },
    {
      "url": "https://852.egos.ia.br/",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200"
    },
    {
      "url": "https://inteligencia.egos.ia.br/",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200"
    },
    {
      "url": "https://guard.egos.ia.br/health",
      "status": "ok",
      "expected_status": "200",
      "actual_status": "200",
      "contains_check": true
    },
    {
      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
      "status": "ok",
      "expected_status": "301",
      "actual_status": "301"
    }
  ],
  "exit_code": 0
}

exec
/bin/bash -lc "nl -ba .egos-manifest.yaml | sed -n '84,94p'" in /home/enio/egos
 succeeded in 0ms:
    84	    last_value: "22"
    85	    last_verified_at: "2026-04-14"
    86	    category: "custom"
    87	
    88	  - id: completed_tasks_total
    89	    description: "Total completed tasks in TASKS.md"
    90	    readme_location: "TASKS.md"
    91	    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
    92	    tolerance: "min:1"
    93	    last_value: "1"
    94	    last_verified_at: "2026-05-25"

exec
/bin/bash -lc "nl -ba docs/strategy/HERMES_WHATSAPP_USECASE_MAP.md | sed -n '44,52p'
nl -ba TASKS.md | sed -n '13,18p'
nl -ba docs/strategy/gpt-instrucoes-COLAR.md | sed -n '51,53p'" in /home/enio/egos
 succeeded in 0ms:
    44	
    45	## 5. Red Zone — Compliance (slide 12 do deck, crítico p/ Enio)
    46	Política Meta/WhatsApp Business cita **restrições a órgãos de segurança/militar/inteligência/governo**. Desenhar como **agente operacional de negócio/rotina com escopo declarado**, NÃO assistente genérico distribuído publicamente, NEM uso institucional de segurança. Gate jurídico antes de produção. Começar: número controlado, sandbox, dados fictícios, comandos de baixo risco.
    47	
    48	## 6. O que isso diz do Enio (arquiteto)
    49	A obra PROVA: ele não fala sobre IA agentic — ele tem em produção um agente WhatsApp→LLM→tools governado, com audit trail, kill-switch fail-closed, telemetria, 9 MCPs, evidence-first. Definição: **arquiteto de sistemas de IA governados e observáveis** (a versão concreta de "investigador de IA / arquiteto de confiança"). Este use case é a prova viva de "o valor sou eu, provado pelo código".
    50	
    51	## 7. Próximos passos (ordem)
    52	1. **3 dashboards (mockup HTML)** sobre os dados reais da §4 — iterar/escolher.
    13	
    14	## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
    15	> Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
    16	- [ ] **GOW-EVIDENCE-CHAIN-001** [P0] `forja`+`prime` — gap#3: tornar evidence-chain VISÍVEL na resposta do agente (apps/egos-gateway/src/orchestrator.ts). A resposta passa a incluir bloco curto: tool(s) chamada(s) + fonte que fundamentou (ex: "fonte: catálogo G Peças") + classificação CONFIRMADO/INFERIDO. Bounded 1-2 dias, isolado. ⚠️ código de PRODUÇÃO (deployed) — testar com cuidado, backup, smoke. Corte Enio.
    17	- [ ] **GOW-DEMO-PREP-001** [P0] `prime` — preparar demo 20min: fluxo g-pecas (WhatsApp→Hermes→tools) que JÁ roda + 3 golden cases antes/depois (rodar via eval-runner) + resposta com evidência (depende de GOW-EVIDENCE-CHAIN-001). Roteiro de demo. NADA novo (sem dashboard/diagnóstico-produto).
    18	- [ ] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — VERIFICAR ANTES da demo: política Meta/WhatsApp Business restringe uso por segurança/governo; Enio é PCMG. Desenhar como agente de negócio/rotina com escopo declarado, não institucional de segurança. Gate jurídico. SSOT: HERMES_WHATSAPP_USECASE_MAP.md §5.
    51	```
    52	
    53	*FORA do GPT (não colar/anexar — vazaria): infra, dado real, paths /home, tokens, contexto PCMG. Só método público.*

exec
/bin/bash -lc 'grep -RIn "PCMG" docs/strategy TASKS.md' in /home/enio/egos
 succeeded in 0ms:
docs/strategy/MONETIZATION_PLAYBOOK.md:101:**RESOLVIDO 2026-05-22 (Q5):** Flat padrão + Transacional opt-in (só Add-on Checkout MP). NÃO Revenue Share. combina com perfil PCMG/comércio MG. G Peças hoje é Flat — testar B com APeças?
docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md:58:| Gerador RCI (relatório PCMG .docx) | BETA | 1 de 6 tipos implementado |
docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md:65:**🔴 NÃO divulgar:** conteúdo de operações reais, REDS/nomes/casos, estrutura fin_*, credenciais/IP do VPS, referências DHPP/PCMG em andamento.
docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md:87:- **DORMANTE por decisão** (`BLOCKCHAIN-002-ETHIK-LEGAL` P0 redzone): policial ativo → risco Art.117 PCMG (gerência) + classificação CVM/BCB (valor mobiliário/VASP). Regra atual: **"ETHIK símbolo, não venda" — não promover/distribuir até parecer legal.**
docs/strategy/sales-templates/oferta-vendedor-ia-gpecas.md:3:> **Status:** DRAFT pré-parecer · **Uso:** 1 página para a reunião com Julio · **Vetor:** serviço técnico/licença PF (NF), dentro do que o parecer PCMG liberar.
docs/strategy/sales-templates/oferta-vendedor-ia-gpecas.md:4:> ⚠️ Não enviar antes do gate legal (parecer estatuto PCMG) e da decisão de pricing do Enio.
docs/strategy/COURSE_PROGRAM_DESIGN.md:5:> **Gate legal:** magistério = vetor seguro p/ policial PCMG ativo ([[user_enio_active_police]]); pricing/estrutura comercial = Red Zone (corte Enio + verificar estatuto).
docs/strategy/COURSE_PROGRAM_DESIGN.md:66:- **Pricing & estrutura comercial** (estatuto PCMG — magistério é seguro, comércio precisa cuidado).
docs/strategy/MCP_VPS_BENCHMARKS.md:48:**Aplicabilidade EGOS:** média — bom para skills públicas, ruim para Intelink (compliance PCMG exige isolamento).
docs/strategy/EGOS_PROJECT_ATLAS.md:20:| **intelink.ia.br** | 200 | EGOS Inteligência | intelink | ✅ produção (PCMG) |
docs/strategy/EGOS_PROJECT_ATLAS.md:50:| **intelink** | 1.026 | 5h atrás | ✅ produção PCMG | **privado** |
docs/strategy/gpt-tier0-package.md:55:❌ infra/ops/observability/browser-automation · dado real/PII/PCMG/cliente · secrets/tokens/bridge interno · qualquer coisa que você não publicaria. (Coerente com transparência radical: método aberto; máquina e dado, não.)
docs/strategy/EGOS_VOICE_GUIDE.md:198:5. **Estatuto PCMG:** a âncora da credibilidade inclui "em atividade". Qualquer frase que associe EGOS diretamente ao empregador PCMG precisa de revisão de estatuto. Minha sugestão: nunca mencionar PCMG no material do EGOS; mencionar só "investigador criminal" ou "construtor com background em investigação".
docs/strategy/EGOS_OFFERING_CATALOG.md:73:- ETL pipelines: BNMP, Datajud, PCMG-doc, PCMG-video
docs/strategy/EGOS_OFFERING_CATALOG.md:173:- ETL pipelines para fontes públicas (BNMP, Datajud, PCMG)
docs/strategy/MARKET_READY_FEATURES.md:94:- [ ] Piloto ativo com PCMG
docs/strategy/MARKET_READY_FEATURES.md:110:| **852** | Produção | Sem piloto ativo | Apresentar para PCMG |
docs/strategy/MARKET_READY_FEATURES.md:119:4. **852:** Preparar apresentação para PCMG
docs/strategy/benchmarks/OPENROUTER_BENCHMARK_RESULTS.md:233:- `institutional_search` — Search PCMG structure, portarias
docs/strategy/benchmarks/OPENROUTER_BENCHMARK_ADVANCED_ANALYSIS.md:43:- **Institutional Context 9.2/10**: Melhor compreensão da estrutura PCMG
docs/strategy/benchmarks/OPENROUTER_BENCHMARK_ADVANCED_ANALYSIS.md:107:> "Com base na estrutura da PCMG, o REDS é o Registro Digital... [ferramenta desnecessária]"
docs/strategy/benchmarks/OPENROUTER_BENCHMARK_ADVANCED_ANALYSIS.md:252:> 1. Consultar o intranet da PCMG
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:69:**FORA (vazaria + viola R-SEC-002):** infra/ops/observability/browser-automation, dado real/PII/PCMG/cliente, secrets/bridge. Coerente com transparência radical.
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:84:5. Founding Pass R$4 ligado (PCMG: corte Enio assumido) — link de pagamento + grupo.
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:3:> **Status:** substância aprovada pelo Enio 2026-06-01 · pendente corte final da versão expandida · **Red Zone** (identidade pública + estatuto PCMG)
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:5:> **Guardrails:** estatuto PCMG ativo — ver `user_enio_active_police` (memory) + `docs/personal-os/CAREER_FIT_STUDY.md` §0.1.
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:15:3. **Estatuto PCMG no público:** nota sóbria de "limites institucionais", nunca box vermelho "vedado a servidor ativo".
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:29:Passei 16 anos na investigação criminal (PCMG, **em atividade**) aprendendo a transformar caos em clareza e a sustentar cadeia de evidência sob escrutínio. Desde 2017 estou em cripto/Web3 — não como espectador, mas rastreando, entendendo fluxos, lendo o que a blockchain registra.
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:39:| Metodologia de investigação / cadeia de evidência | 16 anos PCMG (em atividade) |
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:45:## Oferta — só pelos vetores seguros (estatuto PCMG ativo)
docs/strategy/gpt-instrucoes-COLAR.md:53:*FORA do GPT (não colar/anexar — vazaria): infra, dado real, paths /home, tokens, contexto PCMG. Só método público.*
docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md:48:- Estatuto PCMG ativo: curso = magistério (esporádico, consulta Corregedoria); não-comércio, não sócio-gerente. Ver `CAREER_FIT_STUDY §0.1`.
docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md:70:**Gaps p/ virar ensinável:** (1) **"Caso Alfa" sintético** — `casos/` é restrito; precisa exemplo fake p/ os labs. (2) **camada pedagógica** (objetivos/exercícios — hoje tudo é doc de eng). (3) **conteúdo legal LGPD** (além dos patterns). (4) **repo de cursos greenfield** ainda não existe ([[project_egos_courses_repo]]). (5) compat **Windows/PCMG** nos labs.
docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md:162:- **Legal / privacy + active police officer (Red Zone)** — public-chain anchoring of investigation artifacts could collide with *sigilo*, custody rules, and COI monetization constraints (Enio is PCMG **in active duty**). Must stay hash-only, off-chain content, **never touch case data**. Any investigation-data use → task + Enio cut, never auto-resolve.
TASKS.md:12:> Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
TASKS.md:18:- [ ] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — VERIFICAR ANTES da demo: política Meta/WhatsApp Business restringe uso por segurança/governo; Enio é PCMG. Desenhar como agente de negócio/rotina com escopo declarado, não institucional de segurança. Gate jurídico. SSOT: HERMES_WHATSAPP_USECASE_MAP.md §5.
TASKS.md:118:> Missão: build NOVO isolado (intelink.egos.ia.br) — dados 100% SINTÉTICOS (IDs SYN-*), Busca Global + Timeline núcleo, agentic (9 agentes), transparência radical segura. TRAVA GUARDIÃO: Intelink real = PCMG/PII (Enio policial ativo) → NUNCA tocar/anonimizar dado real (sintético na origem); deploy/público = HITL. Workflow wf_c3ce671f-9f6 produz planos (não publica).
TASKS.md:130:> **Nome recomendado:** "EGOS: Governança de IA para Investigadores" · **Gate:** corte Enio no texto + verificação estatuto PCMG antes de qualquer cobrança.
TASKS.md:138:- [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade. Resultado do workflow (14 agentes): classificação completa em PUBLIC_DOCS/PUBLIC_DEMO/PRIVATE_CORE/PRIVATE_SECURITY/PRIVATE_PCMG/ARCHIVE/NEEDS_REVIEW disponível em docs/audit/repositories-public-private-classification.md (a criar). NENHUM repo abre ou fecha sem auditoria + HITL do Enio. Prioridade: qual repo público principal (candidato: egos-governance já público, mas enxuto — candidato principal para ser o hub educacional).
TASKS.md:143:- [ ] **COURSE-PCMG-GATE-001** [P0] `redzone` 🔴 — Verificar formalmente se recebimento de pagamento por cursos via pessoa física é compatível com o estatuto do servidor PCMG. Liga BLOCKCHAIN-002-ETHIK-LEGAL (aberto). Magistério esporádico = OK por lei; venda direta via plataforma digital = verificar. Recomendação provisória: usar Hotmart (eles são a empresa que vende, Enio recebe como "produtor" — estrutura aceita pela maioria dos servidores públicos). HITL obrigatório antes de ativar qualquer cobrança.
TASKS.md:395:- [/] **SITE-VOICE-001** [P1] `redzone` `research` — ✅ DRAFT 2026-06-02 (Sonnet pesquisou Linear/Resend/Railway/Supabase/Anthropic): `docs/strategy/EGOS_VOICE_GUIDE.md` — 5 princípios + 3 headlines draft + 5 perguntas pro Enio. **Resta: corte do Enio** nas headlines + 5 perguntas (língua, quanto do Enio, ego-balance público, proof status, PCMG no texto).
TASKS.md:399:- [/] **CURRICULUM-001** [P1] `redzone` — Currículo/posicionamento do Enio. **Substância aprovada Enio 2026-06-01**, SSOT persistido `docs/strategy/ENIO_CURRICULUM_POSITIONING.md` (identidade "investigador-arquiteto"; frase "não vendo hora de perito" CORTADA). Pendente: corte final da versão expandida + aterrissagem na seção "Sobre". Respeita estatuto PCMG (IP/magistério/advisory).
TASKS.md:589:> Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
TASKS.md:590:- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
TASKS.md:668:> Tese: curso = ponte framework→governo + magistério (vetor seguro PCMG). Princípio "método aberto + dado soberano/local". SSOT `docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md` + memory `project_courses_framework_gov_thesis`. Red Zone: posições/pitch de governo = corte do Enio.
TASKS.md:672:- [ ] **COURSE-PROGRAM-003** [P1] `redzone` — Modelo de entrega (individual/grupo/turma) + estrutura comercial. **Red Zone:** pricing + estatuto PCMG (magistério=seguro, comércio=cuidado) + LGPD de dado de aluno na co-criação + banir absolutos. Corte Enio antes de publicar.
TASKS.md:685:  - 🔴 **Proteger (auth/de-route):** `ops`, `observability`, `browser-automation` (atacam a MÁQUINA), `memory` (pessoal/PCMG), `security` (resultados PII).

codex
The manifest change introduces malformed verifier output in the current repository state, leaving the completed-tasks claim drifted and harder to interpret. The rest of the diff is mostly documentation/config updates.

Review comment:

- [P2] Avoid emitting duplicate zero for empty task counts — /home/enio/egos/.egos-manifest.yaml:91-91
  When `TASKS.md` has no completed tasks, `grep -c` already prints `0` but exits with status 1, so this fallback appends a second `0`. Running the manifest verifier now reports `completed_tasks_total` as `current_value: "0\n0"`, which makes the doc-drift report malformed and still drifted for the `min:1` claim; use a fallback that preserves a single numeric output, such as suppressing the nonzero exit rather than echoing another count.
The manifest change introduces malformed verifier output in the current repository state, leaving the completed-tasks claim drifted and harder to interpret. The rest of the diff is mostly documentation/config updates.

Review comment:

- [P2] Avoid emitting duplicate zero for empty task counts — /home/enio/egos/.egos-manifest.yaml:91-91
  When `TASKS.md` has no completed tasks, `grep -c` already prints `0` but exits with status 1, so this fallback appends a second `0`. Running the manifest verifier now reports `completed_tasks_total` as `current_value: "0\n0"`, which makes the doc-drift report malformed and still drifted for the `min:1` claim; use a fallback that preserves a single numeric output, such as suppressing the nonzero exit rather than echoing another count.
```
