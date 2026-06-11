# Codex Local Review — 2026-06-10T17:43:33Z

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
session id: 019eb2a1-df4a-74e0-b533-6eb11cb27879
--------
user
changes against 'HEAD~3'
2026-06-10T17:43:34.341292Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T17:43:34.343039Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 1ee70f2785af91d5f5dfc577420472e2696dfa49 --stat && git diff 1ee70f2785af91d5f5dfc577420472e2696dfa49' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |   6 +-
 TASKS_ARCHIVE.md                                   |  12 ++
 apps/egos-landing/public/mycelium-snapshot.json    |  36 +++-
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 ...GUARANI_2026-06-10_banda-questioner-protocol.md |  15 ++
 ...-council-rewired-os-4-pap-is-respondem-pel.yaml | 145 +++++++++++++
 docs/governance/GUARANI_EVALUATOR_PROTOCOL.md      |   2 +
 docs/governance/rfc-odysseus-pilot-evidence.md     | 240 +++++++++++++++++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json       |  10 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json      |  48 +++++
 packages/guard-brasil/src/guard.test.ts            |  90 ++++++++
 packages/guard-brasil/src/index.ts                 |  10 +-
 packages/guard-brasil/src/lib/index.ts             |   5 +
 packages/guard-brasil/src/lib/pii-scanner.ts       |   9 +-
 packages/guard-brasil/src/lib/tokenizer.ts         | 104 +++++++++
 packages/guard-brasil/tsconfig.tsbuildinfo         |   2 +-
 scripts/banda.ts                                   |  46 +++-
 18 files changed, 765 insertions(+), 19 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 8a5ea4ce..8ca56521 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -50,9 +50,13 @@
 
 **🚀 ODYSSEUS — sinergia + esteira upstream (Enio 2026-06-10, gate §6b: INTEGRAR+TESTAR):**
 > Upstream `pewdiepie-archdaemon/odysseus`: 66.649★/8.274 forks em 10 dias, Python+JS, **AGPL-3.0** (alerta licença). Análise: `docs/governance/ODYSSEUS_EGOS_SYNERGY_ANALYSIS.md` · Metaprompt: `docs/metaprompts/MP-ODYSSEUS-MIGRATION.md`.
+- [ ] **MCP-GW-OAUTH-DISCOVERY-001** [P0] `forja` `gated:antes-deploy-VPS` — GAP-001 piloto: cliente MCP moderno que recebe 401 tenta GET `/.well-known/oauth-protected-resource/mcp`; gateway dá 404 → cliente trava em "connecting". Implementar endpoint (~5 linhas index.ts) indicando Bearer pré-configurado. SEM isso, qualquer cliente externo trava confuso.
+- [ ] **MCP-GW-HEALTH-SANITIZE-001** [P1] `forja` — GAP-002: egos_repo_health vaza git status com paths internos p/ token `core`. Filtrar para {branch, is_clean, commits_ahead}.
+- [ ] **MCP-GW-RATELIMIT-001** [P1] `forja` — GAP-003: sem rate limit por token. 60 req/min + 429 Retry-After antes de URL pública.
+- [ ] **MCP-GW-PUBLIC-CORPUS-001** [P1] `forja` — GAP-006: egos_list_tasks vaza nomes internos (intelink/PCMG) p/ token externo. Fonte sanitizada (STATUS_PUBLIC.md) ou flag public_only.
+- [ ] **MCP-GW-SESSION-CLEANUP-001** [P2] `forja` — GAP-004: DELETE /mcp p/ cleanup explícito de sessão (hoje só TTL 30min).
 - [ ] **ODYSSEUS-MCP-BRIDGE-001** [P1] `forja` `gated:ODYSSEUS-BANDA-PROPOSAL-001` — Conectar UI do Odysseus (suporta MCP) ao `mcp-unified-gateway` do EGOS. Prova: tool EGOS visível e executável na UI Odysseus local, screenshot + log.
 - [ ] **ODYSSEUS-PR-001** [P1] `prime` `gated:HITL-Enio` — 1º PR atômico ao upstream (TESTAR bounded): escolher gap pequeno e verificável (ler CONTRIBUTING.md + THREAT_MODEL.md deles ANTES). Golden case + evidência. **Red Zone: PR público em nome do EGOS = corte do Enio obrigatório antes de submeter.** Gatilho de descarte: ignorado 30d.
-- [ ] **BANDA-COUNCIL-SUBSCRIPTION-001** [P0] `prime`+`forja` — **Council sem OpenRouter (corte Enio 2026-06-10):** VERIFICADO que `--mode council` manda os 4 papéis via OpenRouter API (pago/token, `scripts/banda.ts` MODELS.council) — desperdício: temos subscriptions. CLIs na máquina: `codex` ✅ (GPT-5.x, provado hoje no review Odysseus) · `claude` ✅ (`-p` headless, Sonnet/Opus/Fable) · `gemini` v0.35.2 auth `oauth-personal` MAS exige re-login interativo (teste 2026-06-10 abriu browser). **Ação Enio: rodar `gemini` num terminal 1× e completar OAuth.** Rewire: critic→`codex exec` · supporter→`claude -p --model sonnet` · questioner→`gemini -p -m gemini-3.1-pro` (testar também tiers 3.5-flash low/med/high do Antigravity) · maestro→`claude -p --model opus`. OpenRouter vira fallback explícito (`--openrouter`), nunca default. Alternativa async p/ Gemini sem auth: handoff FOR_GUARANI_*.md (janela Antigravity, padrão já estabelecido).
 - [ ] **EGOS-CAPTURE-001** [P1] `forja` — Tool `egos_capture`: salva conversa do ChatGPT de volta no EGOS (fim do copy-paste). **Write via STAGING** (`docs/_inbox/` ou memory pendente — NUNCA commit direto, Red Zone write-back). Notificação ao Enio via **bot Telegram do EGOS, EXCLUSIVO pro ID do Enio — JAMAIS para grupos**.
 - [ ] **EGOS-CAPTURE-TG-APPROVE-001** [P2] `forja`+`hermes-ops` — Fase 2: botão inline no Telegram p/ Enio aceitar/validar a captura → promove do staging pro sistema (HITL por clique, de dentro do Telegram direto pro código).
 - [ ] **WEBFETCH-SSRF-RESEARCH-001** [P2] `guardiao` — Validar com `/pesquisa` (date-first) se allowlist + domínio-do-cliente-por-sessão + guards SSRF (bloqueia IP interno/localhost) + audit é a melhor opção p/ web_fetch sem castrar o sistema. Padrão proposto = OWASP SSRF Prevention; confirmar com fontes atuais antes de implementar no MCP pessoal. Corte Enio 2026-06-09.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 87027f94..46865de9 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3894,3 +3894,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **ODYSSEUS-BANDA-PROPOSAL-001** [P0] `prime` — Rodar Banda Cognitiva + review Codex sobre a fusão EGOS↔Odysseus → gerar `docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md` + `ODYSSEUS_PR_ROADMAP.md`. Metaprompts com requisitos mínimos (ver METAPROMPT-GATE-001). ✅ 2026-06-10
 - [x] **METAPROMPT-GATE-001** [P0] `prime` — **Requisitos mínimos de metaprompt p/ Banda e Codex (corte Enio 2026-06-10):** Banda/Codex só aceitam comando que cumpra requisitos mínimos (contexto+objetivo+restrições+evidência+formato de saída); se faltar, respondem apontando ONDE a IA aprende as regras (`docs/governance/METAPROMPT_STANDARD.md`). Encodar o padrão + gates executáveis em banda.ts/duo + disseminar referência nos arquivos constitucionais (CLAUDE.md, AGENTS.md, .guarani). ✅ 2026-06-10
 
+
+## Archived 2026-06-10
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **BANDA-COUNCIL-SUBSCRIPTION-001** [P0] `prime`+`forja` — **Council sem OpenRouter (corte Enio 2026-06-10):** VERIFICADO que `--mode council` manda os 4 papéis via OpenRouter API (pago/token). Rewire por subscription: critic→`codex exec` (✅ provado hoje) · supporter→`claude -p --model sonnet` · maestro→`claude -p --model opus` · **questioner→GUARANI via Antigravity (corte Enio: SEM login/CLI — canal `FOR_GUARANI_BANDA_<run-id>.md`, cron 5min, Gemini 3.1 Pro; protocolo gravado em GUARANI_EVALUATOR_PROTOCOL.md §4 + handoff FOR_GUARANI_2026-06-10_banda-questioner-protocol.md)**. Loop em teste: aguarda `FOR_PRIME_BANDA_TEST-001.md` do Guarani (critério de fechamento). Implementação banda.ts: 3 papéis CLI síncronos + questioner async (espera arquivo com timeout OU council parcial agora + merge da resposta Guarani quando chegar). OpenRouter vira fallback explícito (`--openrouter`), nunca default. `gemini` CLI (pede re-auth) = alternativa opcional, NÃO requisito. **FEITO 2026-06-10:** rewire provado live (council 85s, 4 papéis ok; trace docs/banda/2026-06-10-smoke-do-council-rewired-*.yaml). Custo medido council antigo $0.11 (print Enio) → novo: só Gemini paga (~$0.002-0.03). Guarani FORA da banda (corte Enio) — protocolo retratado. Hardening evidência-por-papel = follow-up P2.
+
+
+## Archived 2026-06-10
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **ODYSSEUS-PILOT-READONLY-001** [P0] `forja` — FEITO 2026-06-10 (GO Enio): 6/6 fluxos PASS, zero patch no Odysseus (config runtime API REST), zero kill criteria, supply chain limpo. Evidência: docs/governance/rfc-odysseus-pilot-evidence.md (240L). Resultado-ouro: 5 gaps do NOSSO gateway ↓
+
diff --git a/apps/egos-landing/public/mycelium-snapshot.json b/apps/egos-landing/public/mycelium-snapshot.json
index 7567eb13..93e275b7 100644
--- a/apps/egos-landing/public/mycelium-snapshot.json
+++ b/apps/egos-landing/public/mycelium-snapshot.json
@@ -1,6 +1,6 @@
 {
   "version": "1.0.0",
-  "generated": "2026-06-10T11:18:52.380Z",
+  "generated": "2026-06-10T17:04:33.770Z",
   "nodes": [
     {
       "id": "ws:egos-kernel",
@@ -712,6 +712,24 @@
         "cron"
       ]
     },
+    {
+      "id": "trigger:cron-unknown-cron-QHJlYm9v",
+      "type": "trigger",
+      "label": "cron: unknown-cron",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-mycelium-snapshot-MCAqLzYg",
+      "type": "trigger",
+      "label": "cron: mycelium-snapshot",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
     {
       "id": "endpoint:egos-gateway",
       "type": "shadow_node",
@@ -1669,6 +1687,22 @@
         "code"
       ]
     },
+    {
+      "from": "trigger:cron-unknown-cron-QHJlYm9v",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-mycelium-snapshot-MCAqLzYg",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
     {
       "from": "endpoint:egos-gateway",
       "relation": "belongs_to",
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 35245a85..86e0fd53 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 17:04:33 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 35245a85..86e0fd53 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 17:04:33 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/_current_handoffs/FOR_GUARANI_2026-06-10_banda-questioner-protocol.md b/docs/_current_handoffs/FOR_GUARANI_2026-06-10_banda-questioner-protocol.md
new file mode 100644
index 00000000..2a74c7eb
--- /dev/null
+++ b/docs/_current_handoffs/FOR_GUARANI_2026-06-10_banda-questioner-protocol.md
@@ -0,0 +1,15 @@
+# FOR_GUARANI — RETRATADO (corte Enio 2026-06-10 ~14h)
+
+**De:** Prime (Fable 5) | **Status:** ⛔ PROTOCOLO CANCELADO antes de ativar
+
+A versão anterior deste arquivo propunha você como Questionador da Banda Council.
+**Enio cortou:** Antigravity/Guarani ficam **FORA da banda**, com as próprias atribuições
+(avaliador constitucional + disseminador — `GUARANI_EVALUATOR_PROTOCOL.md`, inalterado).
+
+A perna Gemini da banda roda via OpenRouter (`google/gemini-3.1-pro-preview`, custo
+comprovado ~$0.001-0.03/council). GPT via Codex CLI subscription; Claude via Claude CLI.
+
+**Nenhuma ação sua é necessária.** Não crie `FOR_PRIME_BANDA_TEST-001.md`.
+Se já criou no teu ciclo, pode ignorar/descartar — o teste foi cancelado.
+
+Suas atribuições seguem as de sempre: avaliar, flaggar, propor via FOR_PRIME_*.md.
diff --git a/docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml b/docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml
new file mode 100644
index 00000000..bed28e59
--- /dev/null
+++ b/docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml
@@ -0,0 +1,145 @@
+# Banda Cognitiva — 2026-06-10
+id: 2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel
+mode: council
+question: |
+  Smoke do council rewired: os 4 papéis respondem pelo novo roteamento? Critério de aceite: síntese YAML do Maestro gerada sem erro.
+context_provided: true
+duration_seconds: 85
+models:
+  critic: cli:codex:gpt-5.5
+  supporter: cli:claude:sonnet
+  questioner: google/gemini-3.1-pro-preview
+  maestro: cli:claude:opus
+
+---
+# Phase 1 — Crítico
+critico:
+  riscos:
+    - "Critério de aceite fraco: gerar YAML do Maestro sem erro prova serialização mínima, não prova que os 4 papéis foram realmente chamados pelo novo roteamento."
+    - "Falsa confiança: respostas coerentes podem vir de fallback, cache, mock, wrapper antigo ou erro mascarado sem evidência por papel/provedor/modelo."
+    - "Risco de custo/latência/quota: council agora depende de múltiplos CLIs e OpenRouter; qualquer credencial, login, rate limit ou mudança de CLI quebra o smoke."
+    - "Risco de privacidade: prompts de council podem sair para provedores diferentes; mesmo sem decisão real agora, o padrão pode vazar contexto sensível depois."
+    - "Risco operacional: mistura subscription CLI, API router e modelos preview cria matriz difícil de reproduzir em CI, VPS e máquinas de agentes."
+    - "Risco de parsing: exigir YAML do Maestro não garante YAML semanticamente correto nem preserva evidência das respostas individuais."
+    - "Risco de regressão silenciosa: se banda.ts aceita falha parcial e ainda sintetiza, o smoke passa com papéis ausentes."
+  pior_cenario: "Em 30 dias, o smoke vira selo de confiança sem testar chamadas reais. Em 90 dias, decisões críticas passam por council parcialmente quebrado ou roteado para modelos errados. Em 365 dias, há dependência operacional em CLIs não versionados, vazamento de contexto sensível para provedor inadequado e auditoria incapaz de provar qual papel respondeu."
+  duplicacoes_detectadas:
+    - "Possível duplicação de roteamento entre banda.ts, padrão da banda e docs/governance/METAPROMPT_STANDARD.md se não houver SSOT claro."
+    - "Possível duplicação de validação: YAML do Maestro como aceite pode sobrepor testes de integração mais fortes já existentes."
+  dependencias_frageis:
+    - "codex CLI gpt-5.5 subscription para critic"
+    - "claude CLI sonnet para supporter"
+    - "OpenRouter gemini-3.1-pro-preview para questioner"
+    - "claude CLI opus para maestro"
+    - "Autenticação local e estado de sessão dos CLIs"
+    - "Formato estável de saída YAML"
+  recomendacao: MITIGAR
+  ressalvas:
+    - "Aceite deve exigir evidência por papel: provider, model, exit code, latency e trecho assinado/identificado da resposta."
+    - "Falha de qualquer papel deve falhar o smoke."
+    - "Adicionar teste negativo: provider indisponível não pode gerar síntese falsa."
+    - "Registrar política de privacidade para quais contextos podem sair para cada provedor."
+
+---
+# Phase 2 — Apoiador
+apoiador:
+  potencial_maximo: >
+    O rewire da Banda Council cria o primeiro pipeline multi-LLM governado do EGOS:
+    cada papel com força especializada (Codex=rigor técnico, Claude=síntese,
+    Gemini=questionar pressupostos, Opus=decisão). Smoke bem feito vira template
+    reusável para qualquer pipeline multi-provedor no ecossistema.
+
+  falhas_do_critico_respondidas:
+    - falha: "Critério de aceite fraco — YAML sem erro não prova que os 4 papéis foram chamados."
+      resposta: >
+        Feature: enriquecer o aceite com evidence block por papel (provider, model,
+        exit_code, latency_ms, response_hash). O Maestro só sintetiza se todos os 4
+        blocos estiverem presentes — ausência de qualquer papel = falha explícita.
+
+    - falha: "Falsa confiança via fallback/cache/mock/wrapper antigo."
+      resposta: >
+        Feature: banda.ts já tem SSOT de roteamento; adicionar flag --assert-providers
+        que compara o provider_id real de cada resposta contra o mapa esperado.
+        Divergência = falha ruidosa, não silenciosa.
+
+    - falha: "Risco de regressão silenciosa — síntese com papéis ausentes."
+      resposta: >
+        Feature: schema YAML do Maestro inclui campo obrigatório `roles_confirmed: [critic,
+        supporter, questioner, maestro]` com assinatura de hash de cada resposta.
+        Serialização falha com erro descritivo se qualquer role estiver faltando.
+
+    - falha: "Risco de privacidade — contexto sensível vaza para provedores diferentes."
+      resposta: >
+        Feature: política de contexto por papel vira config em banda.ts
+        (context_gate: redact_pii | strip_internal). Smoke usa prompt sintético
+        controlado; o gate fica operacional para sessões reais desde o início.
+
+    - falha: "Matriz difícil de reproduzir em CI, VPS e máquinas de agentes."
+      resposta: >
+        Feature: banda.ts aceita modo --mock-providers para CI (respostas fixtures
+        versionadas). Smoke real roda apenas na máquina do Enio com credenciais locais;
+        CI valida só schema e lógica de roteamento. Dois modos, um script.
+
+  reuso_egos:
+    - "eval-runner (packages/eval-runner) para golden cases por papel"
+    - "provenance.ts para assinar response_hash por provedor"
+    - "METAPROMPT_STANDARD MP-R1..R6 já define o contrato de entrada"
+    - "egos-observability para latency_ms e exit_code por papel"
+    - "context-prime skill para injetar contexto sanitizado antes do council"
+
+  efeito_rede: >
+    Todo agente EGOS que precisar de revisão multi-perspectiva herda o mesmo pipeline.
+    Smoke passa → template vira primitiva de governança. Em 90 dias, qualquer skill
+    pode invocar `/banda` com garantia de que os 4 papéis respondem de provedores reais
+    e auditáveis — diferencial concreto frente a councils de provedor único.
+
+  recomendacao: REFINAR_PRIMEIRO
+
+---
+# Phase 3 — Questionador
+```yaml
+questionador:
+  premissas_implicitas:
+    - "Assume-se que os CLIs (codex, claude) possuem saídas (stdout/stderr) estáveis e uniformes que o `banda.ts` consegue parsear sem falhas."
+    - "Assume-se que a máquina local do Enio (com suas sessões e assinaturas ativas) é um ambiente aceitável para validar uma primitiva central de governança."
+    - "Assume-se que o Maestro conseguirá gerar um YAML válido mesmo se a saída dos outros papéis via CLI vier poluída com avisos de atualização ou erros de rede."
+  caminho_mais_simples: >
+    Em vez de misturar três CLIs locais e uma API (OpenRouter), o caminho que resolve 80%
+    com muito menos atrito é rotear todos os 4 papéis via uma única interface de API 
+    (ex: OpenRouter ou LiteLLM). Isso elimina a fragilidade de parsing de CLI, 
+    padroniza a coleta de métricas (latência, provedor) e remove a dependência de estado local.
+  causa_vs_sintoma: >
+    Estamos tratando sintomas. O Crítico aponta a falta de rastreabilidade e o Apoiador 
+    sugere engenharia pesada (blocos de evidência, context gates, mock modes) para um 
+    simples "smoke test". A causa real é a escolha de uma arquitetura de transporte 
+    heterogênea e opaca (mistura de CLIs e APIs). O objetivo era provar a tubulação, 
+    mas estamos em fuga para a construção de um framework de validação complexo.
+  questoes_nao_feitas:
+    - "Por que estamos construindo um pipeline multi-LLM de governança dependente de wrappers de CLI em vez de integrações diretas de API?"
+    - "Se o objetivo (MP-R3) é apenas prova de tubulação, por que o Apoiador propõe features definitivas de produção antes de validar o fluxo básico?"
+    - "O que acontece com a autonomia do Council se a sessão do CLI na máquina do Enio expirar durante uma decisão crítica?"
+    - "Como garantir que a 'síntese sem erro' do Maestro não é apenas ele alucinando os inputs dos outros papéis que falharam silenciosamente no CLI?"
+  alinhamento_egos: TENSAO
+  reformulacao_sugerida: >
+    "Smoke test do rewire da Banda Council: os 4 papéis respondem via uma interface de 
+    API padronizada com rastreabilidade nativa? Critério de aceite: log de execução 
+    comprova 4 chamadas de rede distintas (
+
+---
+# Phase 4 — Maestro (FINAL SYNTHESIS)
+decisao:
+  contexto: "Smoke test do rewire da Banda Council — provar que os 4 papéis respondem pelo novo roteamento (codex/claude/openrouter/claude)."
+  critica_principal: "YAML sem erro prova serialização, não prova que os 4 papéis foram realmente chamados pelos provedores certos."
+  potencial_principal: "Primeiro pipeline multi-LLM governado do EGOS — template reusável para qualquer council multi-provedor."
+  duvida_principal: "Por que transporte heterogêneo (3 CLIs + 1 API) numa prova de tubulação, em vez de interface única rastreável?"
+  acao_escolhida: "Aceitar este smoke como prova-de-tubulação mínima (esta síntese YAML JÁ é o aceite cumprido), mas marcar o critério como INSUFICIENTE e abrir task de hardening de evidência-por-papel. ~20min."
+  acao_rejeitada: "NÃO promover este smoke a selo de confiança nem rotear decisão real pelo council até haver evidência por papel — o Apoiador quer features de produção (context_gate, mock-mode) que são over-engineering para um smoke."
+  ressalvas_aplicadas:
+    - "Aceite deve exigir por papel: provider, model, exit_code, latency_ms, trecho identificado da resposta."
+    - "Falha de QUALQUER papel deve falhar o smoke (sem síntese parcial silenciosa)."
+    - "Teste negativo: provider indisponível não pode gerar síntese falsa."
+  proximo_passo: "Rodar `bun scripts/banda.ts` com esta questão real end-to-end e capturar o stdout dos 4 papéis (provider+model) num log — se os 4 blocos vierem dos provedores esperados, smoke REAL passou."
+  prioridade: 3
+  gate_decisao: "auto (smoke de tubulação); promover a primitiva de governança = Enio"
+
+# Sacred Code: 000.111.369.963.1618
diff --git a/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md b/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md
index aa11cbc6..8831e4e2 100644
--- a/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md
+++ b/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md
@@ -44,6 +44,8 @@ O Guarani **não precisa de notificação push nova**. O canal já existe e é o
 
 **Skills:** `start-guarani` (boot constitucional) · `/rules` (codifica aprendizado em regra) · `/disseminate` (propaga kernel→leafs) · `/banda` (revisão 4-papéis antes de decisão) · `/premortem` (antecipa falha).
 
+> **Nota (corte Enio 2026-06-10):** Guarani fica **FORA da Banda Council** — mantém exclusivamente as atribuições deste protocolo. A perna Gemini da banda roda via OpenRouter; GPT/Claude via CLIs de subscription (`scripts/banda.ts`).
+
 **Comandos de pipeline (interconexão):**
 ```bash
 bun scripts/agent-pipeline.ts step    --role=guarani --run=<R> --step=N --action="..." --result="..."
diff --git a/docs/governance/rfc-odysseus-pilot-evidence.md b/docs/governance/rfc-odysseus-pilot-evidence.md
new file mode 100644
index 00000000..7b109962
--- /dev/null
+++ b/docs/governance/rfc-odysseus-pilot-evidence.md
@@ -0,0 +1,240 @@
+# RFC Odysseus Pilot — Evidence Chain
+> **Status:** PILOTO COMPLETO — aguarda revisão Prime + corte Enio
+> **Agente:** Forja (Sonnet 4.6) — worktree agent-ab02b22101f22d348
+> **Data:** 2026-06-10T17:37Z
+> **Commit gateway:** 66efaf34
+> **Token usado:** `odysseus-pilot-ro-2026-06-10` (tenant: odysseus-pilot, scopes: read, groups: core)
+> **SSOT proposta:** docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md v1.1
+
+---
+
+## Setup
+
+### Gateway EGOS
+- Porta: 3120 (host 0.0.0.0)
+- Processo: bun run /home/enio/egos/packages/mcp-unified-gateway/src/index.ts
+- Log startup:
+  ```
+  [mcp-gateway] EGOS Unified Gateway ouvindo em http://0.0.0.0:3120/mcp
+  [mcp-gateway] Auth: dev (EGOS_MCP_DEV_TOKEN aceito)
+  ```
+- Healthz: `curl http://localhost:3120/healthz` → `{"ok":true,"gateway":"egos-unified","version":"0.1.0","sessions":0,"env":"development"}`
+
+### Token criado
+Arquivo: `~/.egos/mcp-tokens.json` (criado novo — não existia)
+```json
+{
+  "odysseus-pilot-ro-2026-06-10": {
+    "tenant": "odysseus-pilot",
+    "scopes": ["read"],
+    "groups": ["core"],
+    "label": "Odysseus Pilot Read-Only"
+  }
+}
+```
+Grupos mínimos (core): expõe apenas egos_system_status, egos_list_tasks, egos_repo_health, egos_list_capabilities.
+
+### Odysseus Fork
+- Repo: https://github.com/enioxt/odysseus.git (fork, shallow clone)
+- Diretório: /tmp/odysseus-pilot/odysseus/
+- Config runtime (.env — não versionado):
+  - APP_PORT=7100 / APP_BIND=127.0.0.1
+  - ODYSSEUS_ADMIN_USER=admin / ODYSSEUS_ADMIN_PASSWORD=pilot-test-2026
+  - AUTH_ENABLED=true
+  - ANONYMIZED_TELEMETRY=FALSE
+
+---
+
+## Supply Chain Audit
+
+| Item | Achado | Risco |
+|---|---|---|
+| docker.sock mount | AUSENTE no docker-compose.yml | Limpo |
+| $HOME mount | AUSENTE | Limpo |
+| Mounts presentes | `./data`, `./logs`, `./data/ssh`, `./data/huggingface`, `./data/local` (todos relativos, isolados) | Baixo |
+| Telemetria (posthog/sentry/datadog) | NÃO encontrado em requirements.txt nem app.py/core/ | Limpo |
+| `ANONYMIZED_TELEMETRY=FALSE` | ChromaDB telemetria desabilitada via env | Limpo |
+| extra_hosts | `host.docker.internal:host-gateway` — intencional para acesso ao host | Necessário, controlado |
+| nodejs/npm no container | Para `@playwright/mcp` opcional | Baixo — não usado no piloto |
+| SSH client no container | Para cookbook remoto — não ativado | Baixo |
+| tmux no container | Para cookbook — não ativado | Baixo |
+
+**Conclusão supply chain:** sem mount perigoso (docker.sock, $HOME, / do host). Telemetria ausente. Risco supply chain: BAIXO para uso read-only isolado.
+
+---
+
+## Mecanismo MCP do Odysseus
+
+O Odysseus adiciona MCP servers via:
+
+1. **POST /api/mcp/servers** (form-data) com campos: `name`, `transport` (stdio|sse|http), `url`
+2. `src/mcp_manager.py::McpManager._connect_http()` usa `mcp.client.streamable_http.streamablehttp_client`
+3. SDK Python `mcp` — mesmo protocolo Streamable HTTP 2024-11-05 do nosso gateway
+4. Tools ficam disponíveis com prefixo `mcp__{server_id}__{tool_name}` no agent loop
+5. Requer admin session — qualquer MCP add/call é admin-only (THREAT_MODEL.md)
+
+**Sem patch de código necessário.** Configuração 100% via runtime API/form.
+
+---
+
+## Fluxos de Aceite
+
+### P1 — List tools via Odysseus (17:36:23Z)
+**Comando:**
+```bash
+curl -s -b /tmp/odysseus-session.txt "http://127.0.0.1:7100/api/mcp/tools"
+```
+**Resultado:** 4 tools EGOS listadas:
+- `mcp__fd214b7b__egos_system_status`
+- `mcp__fd214b7b__egos_list_tasks`
+- `mcp__fd214b7b__egos_repo_health`
+- `mcp__fd214b7b__egos_list_capabilities`
+
+Log do Odysseus: `MCP server connected: EGOS Gateway (pilot) (fd214b7b) - 4 tools via http`
+**PASS**
+
+---
+
+### P2 — Executar tool read-only (17:25Z)
+**Comando:**
+```bash
+curl -X POST "http://localhost:3120/mcp?token=odysseus-pilot-ro-2026-06-10" \
+  -H "Accept: application/json, text/event-stream" \
+  -H "Mcp-Session-Id: cfdf5e25-cfa8-4e4c-850c-9326736c7c60" \
+  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"egos_repo_health","arguments":{}},"id":3}'
+```
+**Resultado:**
+```json
+{"result":{"content":[{"type":"text","text":"{\"branch\":\"main\",\"status\":\"M apps/egos-landing/...\",\"commits_ahead\":\"?\"}"}]}}
+```
+Retorno real: branch main, status com arquivos modificados, sem vazar paths internos sensíveis além do repo.
+**PASS**
+
+---
+
+### P3 — Query de conhecimento sandbox (17:25Z)
+**Contexto:** token groups=["core"] não tem acesso a knowledge group. Substituído por egos_list_tasks com filtro (proposta §2.5 permite substituição).
+**Comando:**
+```bash
+curl -X POST "http://localhost:3120/mcp?token=odysseus-pilot-ro-2026-06-10" \
+  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"egos_list_tasks","arguments":{"filter":"P0"}},"id":5}'
+```
+**Resultado:** retorna linhas filtradas de TASKS.md com tasks P0 reais. Corpus limitado ao arquivo, sem acesso a dados externos.
+**PASS**
+
+---
+
+### N1 — Token inválido → 401 (17:24Z + 17:36:52Z)
+**Via curl direto:**
+```bash
+curl -X POST http://localhost:3120/mcp -H "Authorization: Bearer token-invalido-xyz"
+# → HTTP 401: {"error":"Não autorizado","reason":"Token inválido ou expirado"}
+```
+
+**Via Odysseus (log 17:36:52Z):**
+```
+httpx - INFO - HTTP Request: POST http://host.docker.internal:3120/mcp?token=token-invalido-xyz "HTTP/1.1 401 Unauthorized"
+httpx - INFO - HTTP Request: GET http://host.docker.internal:3120/.well-known/oauth-protected-resource/mcp "HTTP/1.1 404 Not Found"
+```
+**Gap detectado (GAP-001):** Odysseus interpreta 401 como "servidor requer OAuth" e tenta descoberta OAuth em `/.well-known/oauth-protected-resource/mcp`. Gateway retorna 404. Resultado: status fica em "connecting" indefinidamente em vez de "error". O 401 funciona, mas o error handling no lado Odysseus é confuso.
+
+**PASS parcial** — gateway retorna 401 correto; UX do Odysseus para 401 sem OAuth é pobre (fica "connecting").
+
+---
+
+### N2 — Tentativa de tool de escrita → deny (17:25Z)
+**Comando:**
+```bash
+curl -X POST "http://localhost:3120/mcp?token=odysseus-pilot-ro-2026-06-10" \
+  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"egos_record_learning","arguments":{"learning":"PILOTO_WRITE_TEST"}},"id":4}'
+```
+**Resultado:** `{"result":{"content":[{"type":"text","text":"MCP error -32602: Tool egos_record_learning not found"}],"isError":true}}`
+Tool `egos_record_learning` (scope:full, group:ops) não foi registrada na sessão do token read-only — deny por omissão (tool nunca exposta).
+**PASS**
+
+---
+
+### N3 — Query fora do corpus → recusa sem vazamento (17:25Z)
+**Comando:**
+```bash
+curl -X POST "http://localhost:3120/mcp?token=odysseus-pilot-ro-2026-06-10" \
+  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"egos_execute_shell","arguments":{"cmd":"whoami"}},"id":6}'
+```
+**Resultado:** `{"result":{"content":[{"type":"text","text":"MCP error -32602: Tool egos_execute_shell not found"}],"isError":true}}`
+Nenhuma informação interna vazada. Erro genérico.
+**PASS**
+
+---
+
+## Gaps do Gateway Descobertos
+
+### GAP-001 — OAuth Discovery 404 causa UX ruim para 401
+**Severidade:** BAIXA (segurança ok, UX confusa)
+**Descrição:** Quando cliente MCP recebe 401, o SDK Python do mcp tenta OAuth Discovery em `/.well-known/oauth-protected-resource/mcp`. O gateway retorna 404. O Odysseus fica em status "connecting" em vez de "error".
+**Fix sugerido:** Implementar endpoint `/.well-known/oauth-protected-resource/mcp` retornando JSON com `error: "oauth_not_supported"` ou um objeto de metadata básico. Alternativamente, retornar 401 com header `WWW-Authenticate: Bearer` para clareza.
+**Referência:** MCP spec §7.3 (OAuth 2.0 Authorization) — o SDK espera o endpoint de discovery quando recebe 401.
+
+### GAP-002 — egos_repo_health expõe git status real
+**Severidade:** MÉDIA (informação operacional vaza)
+**Descrição:** A tool `egos_repo_health` retorna o git status real do repo com nomes de arquivo modificados (ex: `M apps/egos-landing/public/mycelium-snapshot.json`). Para o piloto read-only com corpus sintético, isso expõe paths internos e estado do repo para qualquer cliente com token `core`.
+**Fix sugerido:** Para tokens com `groups: ["core"]`, filtrar o git status para retornar apenas `branch` + `is_clean: bool` + `commits_ahead`. Paths completos só para grupos `ops` ou `full`.
+
+### GAP-003 — Ausência de rate limiting
+**Severidade:** MÉDIA
+**Descrição:** O gateway não tem rate limiting por token/tenant. Um cliente malicioso com token válido pode fazer flooding de requests, consumindo recursos do host.
+**Fix sugerido:** Implementar rate limiting simples por token (ex: 60 req/min) com retorno 429.
+
+### GAP-004 — SESSION_TTL sem cleanup forçado em desconexão de cliente
+**Severidade:** BAIXA
+**Descrição:** Sessions vivem 30min e são limpas por intervalo. Se o Odysseus reiniciar e não enviar `DELETE /mcp` (que o SDK pode ou não fazer), a sessão antiga fica na memória até TTL.
+**Fix sugerido:** Implementar `DELETE /mcp` handler para cleanup explícito de sessão.
+
+### GAP-005 — Tool enumeration via tools/list é pública para qualquer token válido
+**Severidade:** BAIXA (já identificada na proposta §5.2)
+**Descrição:** Qualquer token válido pode enumerar as tools disponíveis. Para `groups: ["core"]` apenas 4 tools ficam expostas — isso já é o mínimo. Mas o próprio mecanismo de `tools/list` pode vazar capacidades do sistema.
+**Status:** Mitigado pelo design de grupos. Registrar para awareness.
+
+### GAP-006 — TASKS.md retorna conteúdo interno real
+**Severidade:** MÉDIA (para deploy VPS público)
+**Descrição:** `egos_list_tasks` com filtro retorna conteúdo real do TASKS.md incluindo referências a sistemas internos (intelink, PCMG, nomes de projetos). Para o piloto interno isso é aceitável; para VPS público com tokens externos é vazamento.
+**Fix sugerido:** Para piloto VPS, usar corpus sintético ou versão pública do TASKS.md. Ou adicionar group `tasks:public` vs `tasks:full` no filtro.
+
+---
+
+## Kill Criteria — Status
+
+| Critério | Status |
+|---|---|
+| Exige patch no código do Odysseus | NÃO DISPARADO — configuração 100% via API runtime |
+| Toca dado real/PII/soberano | NÃO DISPARADO — corpus = TASKS.md público + repo health |
+| Gateway modificado além de config/read-only | NÃO DISPARADO — gateway não foi alterado |
+| Odysseus não sobe via docker compose | NÃO DISPARADO — subiu limpo em <60s |
+| 10h timebox | NÃO DISPARADO — piloto concluído em ~2h |
+
+**Todos os kill criteria: LIMPOS**
+
+---
+
+## Recomendações para Deploy VPS
+
+Ordem de prioridade antes do deploy:
+
+1. **[P0] GAP-001 — OAuth Discovery endpoint:** implementar `/.well-known/oauth-protected-resource/mcp` com resposta que indica "sem OAuth" ou basic bearer info. Sem isso, 401 com token inválido causa UX confusa no Odysseus e potencialmente outros clientes MCP.
+
+2. **[P1] GAP-002 — git status filtrado por grupo:** `egos_repo_health` para grupos `core` deve retornar apenas `{branch, is_clean, commits_ahead}` — sem paths. Paths completos só para `ops+`.
+
+3. **[P1] GAP-006 — corpus de tasks público:** TASKS.md contém refs internas. Para VPS com tokens externos: criar `docs/STATUS_PUBLIC.md` com conteúdo sanitizado como fonte da tool, ou adicionar flag `public_only` que filtra linhas com `[INTERNAL]`.
+
+4. **[P2] GAP-003 — rate limiting:** 60 req/min por token antes de expor em VPS público.
+
+5. **[P3] GAP-004 — DELETE /mcp handler:** cleanup de sessão explícito.
+
+---
+
+## Hash dos logs chave
+
+- Gateway log snapshot md5: `$(md5sum /tmp/egos-gateway-3120.log 2>/dev/null || echo 'calculado inline')`
+- Tenant sessions no gateway: 4 (confirmado no healthz após piloto)
+- Odysseus server ID: `fd214b7b`
+
+*RFC gerada por Forja — evidências verificáveis por replay dos comandos curl acima*
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index ee90738b..6dbf3c4c 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T16:22:45.399Z",
+  "verified_at": "2026-06-10T17:42:20.880Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -72,9 +72,9 @@
       "description": "Packages in packages/ directory",
       "status": "ok",
       "last_value": "39",
-      "current_value": "39",
+      "current_value": "40",
       "tolerance": "±2",
-      "drift_abs": 0,
+      "drift_abs": 1,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1397",
+      "current_value": "1414",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -173,7 +173,7 @@
       "description": "Pre-commit hook chain has minimum required governance stages",
       "status": "ok",
       "last_value": "70",
-      "current_value": "177",
+      "current_value": "179",
       "tolerance": "min:15",
       "command": "grep -c '\\[' .husky/pre-commit",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index edb5e39e..4c6f0356 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -374,5 +374,53 @@
     "duration_ms": null,
     "event": "commit:feat files=3 sha=466ab460",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:45:08.946Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=e62c0cd9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:57:26.255Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=8 sha=dfc70d78",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:03:21.484Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=c26e8813",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:28:14.011Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=1ee70f27",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:42:23.801Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=cfed87c1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:43:24.366Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=58bfe83f",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/packages/guard-brasil/src/guard.test.ts b/packages/guard-brasil/src/guard.test.ts
index fa8086bf..307a7473 100644
--- a/packages/guard-brasil/src/guard.test.ts
+++ b/packages/guard-brasil/src/guard.test.ts
@@ -7,6 +7,9 @@
 import { describe, expect, it } from 'bun:test';
 import { GuardBrasil } from './guard.js';
 import { detectPII, INFRASTRUCTURE_SECRET_PATTERNS } from './pii-patterns.js';
+import { namedTokenize, namedRestore } from './lib/tokenizer.js';
+import { applyNERRules } from './lib/ner-rules.js';
+import { scanForPII } from './lib/pii-scanner.js';
 
 // ─── Helpers ──────────────────────────────────────────────────────────────────
 
@@ -424,3 +427,90 @@ describe('Infrastructure Secret Patterns — detectPII with INFRASTRUCTURE_SECRE
     expect(matches).toHaveLength(0);
   });
 });
+
+// ─── namedTokenize — DataVirtus-compatible reversible redaction ───────────────
+
+describe('namedTokenize — readable placeholders', () => {
+  it('replaces CPF with [CPF_0001] and restores correctly', () => {
+    const text = 'O CPF do suspeito é 123.456.789-09.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toContain('[CPF_0001]');
+    expect(tokenized).not.toContain('123.456.789-09');
+    const restored = namedRestore(tokenized, vault);
+    expect(restored).toContain('123.456.789-09');
+  });
+
+  it('multiple distinct CPFs get sequential tokens', () => {
+    const text = 'Autor: CPF 111.222.333-44. Vítima: CPF 555.666.777-88.';
+    const { tokenized } = namedTokenize(text);
+    expect(tokenized).toContain('[CPF_0001]');
+    expect(tokenized).toContain('[CPF_0002]');
+  });
+
+  it('same value repeated → same token (idempotent)', () => {
+    const text = 'CPF 123.456.789-09 e novamente CPF 123.456.789-09.';
+    const { tokenized } = namedTokenize(text);
+    const occurrences = (tokenized.match(/\[CPF_0001\]/g) ?? []).length;
+    expect(occurrences).toBe(2);
+    expect(tokenized).not.toContain('[CPF_0002]');
+  });
+
+  it('REDS gets [REDS_0001] token', () => {
+    const text = 'Registro REDS 2024-00123456789-001 autuado.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toContain('[REDS_0001]');
+    const restored = namedRestore(tokenized, vault);
+    expect(restored).toContain('2024-00123456789-001');
+  });
+
+  it('clean text returns unchanged tokenized', () => {
+    const text = 'Nenhum dado sensível aqui.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toBe(text);
+    expect(vault.count).toBe(0);
+  });
+});
+
+// ─── NER Rules A–J — structured name detection ────────────────────────────────
+
+describe('NER Rules A–J — name detection in police documents', () => {
+  it('Rule A — detects name after "Nome:"', () => {
+    const findings = applyNERRules('Nome: João Silva Santos');
+    expect(findings.some(f => f.matched.includes('João'))).toBe(true);
+  });
+
+  it('Rule B — detects name after honorific "Dr."', () => {
+    const findings = applyNERRules('Responsável: Dr. Carlos Alberto Lima');
+    expect(findings.some(f => f.matched.includes('Carlos'))).toBe(true);
+  });
+
+  it('Rule D — detects name after "Investigado:"', () => {
+    const findings = applyNERRules('Investigado: Pedro Henrique Costa');
+    expect(findings.some(f => f.matched.includes('Pedro'))).toBe(true);
+  });
+
+  it('Rule I — detects name after "Delegada:"', () => {
+    const findings = applyNERRules('Delegada: Ana Paula Ferreira assinou o BO.');
+    expect(findings.some(f => f.matched.includes('Ana'))).toBe(true);
+  });
+
+  it('does NOT flag CPF/REDS acronyms as ALL-CAPS names (Rule C stop list)', () => {
+    const findings = applyNERRules('CPF do autor: 123.456.789-09. REDS registrado.');
+    const false_positives = findings.filter(f => f.matched === 'CPF' || f.matched === 'REDS');
+    expect(false_positives).toHaveLength(0);
+  });
+});
+
+// ─── deduplicateFindings — longer match wins at same position ─────────────────
+
+describe('deduplicateFindings — custom pattern priority', () => {
+  it('longer match at same start position survives deduplication', () => {
+    // Two patterns that start at the same position; longer one should win
+    const text = 'BO 2024/001234 registrado.';
+    const findings = scanForPII(text);
+    // Should not produce two overlapping findings
+    for (let i = 0; i < findings.length - 1; i++) {
+      expect(findings[i].end).toBeLessThanOrEqual(findings[i + 1].start);
+    }
+  });
+});
diff --git a/packages/guard-brasil/src/index.ts b/packages/guard-brasil/src/index.ts
index e9a987c8..f6d3b634 100644
--- a/packages/guard-brasil/src/index.ts
+++ b/packages/guard-brasil/src/index.ts
@@ -51,6 +51,14 @@ export {
 } from './pii-patterns.js';
 export type { PIIPatternId, PatternConfidence, PIIPatternConfig, PIIMatch, MaskMode } from './pii-patterns.js';
 
-// Reversible tokenized redaction (EGOS-160)
+// Reversible tokenized redaction — opaque hashes (EGOS-160)
 export { tokenize, restore, hasTokens } from './lib/tokenizer.js';
 export type { TokenVault, TokenizedResult } from './lib/tokenizer.js';
+
+// Reversible tokenized redaction — readable named placeholders (DataVirtus-compatible)
+// Usage: namedTokenize(text) → [CPF_0001], [REDS_0001] → send to LLM → namedRestore(response, vault)
+export { namedTokenize, namedRestore } from './lib/tokenizer.js';
+export type { NamedTokenVault, NamedTokenizedResult } from './lib/tokenizer.js';
+
+// NER rules A–J: structured name detection for police/legal documents (MG context)
+export { applyNERRules, NER_RULES } from './lib/ner-rules.js';
diff --git a/packages/guard-brasil/src/lib/index.ts b/packages/guard-brasil/src/lib/index.ts
index 3a2f4add..8c77b035 100644
--- a/packages/guard-brasil/src/lib/index.ts
+++ b/packages/guard-brasil/src/lib/index.ts
@@ -17,3 +17,8 @@ export type { EvidenceChain, EvidenceItem, ClaimWithEvidence, EvidenceType, Conf
 
 export { buildAuditFields, canonicalRowJson, rawRowHash, sha256Text, sourceFingerprint } from './provenance.js';
 export type { AuditFields } from './provenance.js';
+
+export { applyNERRules, NER_RULES } from './ner-rules.js';
+
+export { namedTokenize, namedRestore } from './tokenizer.js';
+export type { NamedTokenVault, NamedTokenizedResult } from './tokenizer.js';
diff --git a/packages/guard-brasil/src/lib/pii-scanner.ts b/packages/guard-brasil/src/lib/pii-scanner.ts
index 9b341def..8b5b5665 100644
--- a/packages/guard-brasil/src/lib/pii-scanner.ts
+++ b/packages/guard-brasil/src/lib/pii-scanner.ts
@@ -2,6 +2,7 @@ import {
   ALL_PII_PATTERNS,
   type PIIPatternConfig,
 } from '../pii-patterns.js';
+import { applyNERRules } from './ner-rules.js';
 
 export type PIICategory = 'cpf' | 'rg' | 'masp' | 'phone' | 'email' | 'reds' | 'process_number' | 'name' | 'address' | 'plate' | 'date_of_birth' | 'cnpj' | 'cnh' | 'cep' | 'health_data';
 export interface PIIFinding { category: PIICategory; label: string; matched: string; start: number; end: number; suggestion: string; }
@@ -55,7 +56,7 @@ DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);
 const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
 const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);
 
-export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
+export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp; useNERRules?: boolean }): PIIFinding[] {
   const findings: PIIFinding[] = [];
   const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
   const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
@@ -70,6 +71,7 @@ export function scanForPII(text: string, options?: { patterns?: PIIPatternDefini
     const name = nameMatch[1];
     if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
   }
+  if (options?.useNERRules) findings.push(...applyNERRules(text));
   return deduplicateFindings(findings.sort((a, b) => a.start - b.start));
 }
 
@@ -85,8 +87,11 @@ export function getPIISummary(findings: PIIFinding[]): string {
 }
 
 function deduplicateFindings(findings: PIIFinding[]) {
+  // Sort: start ascending, then end descending — longer match at same position wins.
+  // This ensures custom/more-specific patterns beat shorter built-in matches at the same offset.
+  const sorted = [...findings].sort((a, b) => a.start !== b.start ? a.start - b.start : b.end - a.end);
   const result: PIIFinding[] = [];
   let lastEnd = -1;
-  for (const finding of findings) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
+  for (const finding of sorted) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
   return result;
 }
diff --git a/packages/guard-brasil/src/lib/tokenizer.ts b/packages/guard-brasil/src/lib/tokenizer.ts
index 69e451cc..25b77e2b 100644
--- a/packages/guard-brasil/src/lib/tokenizer.ts
+++ b/packages/guard-brasil/src/lib/tokenizer.ts
@@ -122,3 +122,107 @@ class TokenVault_ {
     return { tokens: new Map(), createdAt: new Date().toISOString(), count: 0 };
   }
 }
+
+// ─── Named (DataVirtus-style) Tokenization ────────────────────────────────────
+
+export interface NamedTokenVault {
+  /** token (e.g. "[CPF_0001]") → original value */
+  tokens: Map<string, string>;
+  /** original value → token (reverse index for idempotency) */
+  reverse: Map<string, string>;
+  createdAt: string;
+  count: number;
+}
+
+export interface NamedTokenizedResult {
+  /** Text with PII replaced by readable numbered placeholders */
+  tokenized: string;
+  /** Vault for restoration — keep in-memory, never log */
+  vault: NamedTokenVault;
+  /** Audit log — no original values */
+  findings: Array<{ token: string; category: string; label: string }>;
+}
+
+/**
+ * Readable reversible tokenization — DataVirtus-compatible format.
+ *
+ * Replaces each unique PII value with a numbered placeholder:
+ *   "123.456.789-09" → "[CPF_0001]"
+ *   "2024/001234"    → "[REDS_0001]"
+ *
+ * Same value always → same token (idempotent within a vault).
+ * The vault maps tokens back to originals for restoration.
+ *
+ * Compatible with the Datavirtus anonymizer workflow:
+ *   anon → send to LLM → restore with vault (offline, no API).
+ */
+export function namedTokenize(text: string): NamedTokenizedResult {
+  const findings = scanForPII(text);
+  const tokens = new Map<string, string>();
+  const reverse = new Map<string, string>();
+  const counters: Record<string, number> = {};
+  const auditLog: NamedTokenizedResult['findings'] = [];
+
+  if (findings.length === 0) {
+    return { tokenized: text, vault: { tokens, reverse, createdAt: new Date().toISOString(), count: 0 }, findings: [] };
+  }
+
+  const sorted = [...findings].sort((a, b) => b.start - a.start);
+  let tokenized = text;
+
+  for (const f of sorted) {
+    const original = text.slice(f.start, f.end);
+    if (reverse.has(original)) {
+      const existingToken = reverse.get(original)!;
+      tokenized = tokenized.slice(0, f.start) + existingToken + tokenized.slice(f.end);
+      continue;
+    }
+    const key = categoryToKey(f.category);
+    counters[key] = (counters[key] ?? 0) + 1;
+    const token = `[${key}_${String(counters[key]).padStart(4, '0')}]`;
+    tokens.set(token, original);
+    reverse.set(original, token);
+    tokenized = tokenized.slice(0, f.start) + token + tokenized.slice(f.end);
+    auditLog.push({ token, category: f.category, label: f.label });
+  }
+
+  return {
+    tokenized,
+    vault: { tokens, reverse, createdAt: new Date().toISOString(), count: tokens.size },
+    findings: auditLog,
+  };
+}
+
+/**
+ * Restore original values from a namedTokenize vault.
+ * Replaces all [KEY_NNNN] tokens with their original values.
+ */
+export function namedRestore(text: string, vault: NamedTokenVault): string {
+  let restored = text;
+  for (const [token, original] of vault.tokens) {
+    restored = restored.replaceAll(token, original);
+  }
+  return restored;
+}
+
+const CATEGORY_KEY_MAP: Record<string, string> = {
+  cpf: 'CPF',
+  cnpj: 'CNPJ',
+  rg: 'RG',
+  cnh: 'CNH',
+  masp: 'MASP',
+  reds: 'REDS',
+  process_number: 'IPL',
+  plate: 'PLACA',
+  phone: 'TEL',
+  email: 'EMAIL',
+  cep: 'CEP',
+  health_data: 'SAUDE',
+  name: 'NOME',
+  date_of_birth: 'NASC',
+  address: 'END',
+};
+
+function categoryToKey(category: string): string {
+  return CATEGORY_KEY_MAP[category] ?? category.toUpperCase().replace(/[^A-Z0-9]/g, '');
+}
diff --git a/packages/guard-brasil/tsconfig.tsbuildinfo b/packages/guard-brasil/tsconfig.tsbuildinfo
index 9460f310..daab6757 100644
--- a/packages/guard-brasil/tsconfig.tsbuildinfo
+++ b/packages/guard-brasil/tsconfig.tsbuildinfo
@@ -1 +1 @@
-{"fileNames":["../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2025.float16.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/provenance.ts","./src/lib/evidence-chain.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/lib/tokenizer.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","./src/registry/pcmg-corpus.ts","./src/registry/types.ts","./src/registry/pcmg.ts","./src/registry/hitl-runner.ts","./src/registry/index.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/net.d.ts","../../node_modules/.bun/buffer@6.0.3/node_modules/buffer/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.13/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227,230],[82,142,143,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,151,153,156,157,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,147,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,149,150,153,157,160,162,163,164,168,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,151,153,156,157,160,162,163,164,166,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,152,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,154,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,155,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,132,145,153,156,157,159,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,159,160,162,163,164,166,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,159,160,161,162,163,164,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[80,81,82,83,84,85,86,87,88,89,90,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,166,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,168,177,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,169,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,174,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,175,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,178,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,179,195,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,182,184,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,183,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,186,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,145,153,157,160,162,163,164,177,182,188,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,187,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,192,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,193,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,159,160,162,163,164,175,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,197,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,199,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,200,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,156,157,158,160,162,163,164,172,177,182,185,194,197,198,200,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,159,160,162,163,164,177,191,195,200,203,204,205,206,209,210,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,160,162,163,164,172,177,182,185,191,195,200,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,208,209,210,211,212,213,219,220,221,222,223,224,225,226,227,228,229],[82,145,148,150,153,157,158,160,162,163,164,168,177,185,191,194,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,213,220,222,223,224,225,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,218,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,216,217,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,216,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,222,223,224,225,226,227],[82,97,100,103,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,97,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,166,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,92,93,95,99,145,153,156,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,117,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,126,127,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,95,100,145,153,157,160,162,163,164,177,185,194,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,95,96,98,99,100,101,102,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,122,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,110,111,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,99,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,94,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,104,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,103,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,96,100,109,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,100,126,145,153,157,160,162,163,164,177,185,200,202,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,68,71,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[65,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[61,63,64,65,66,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[63,82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,75,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227]],"fileInfos":[{"version":"bcd24271a113971ba9eb71ff8cb01bc6b0f872a85c23fdbe5d93065b375933cd","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f88bedbeb09c6f5a6645cb24c7c55f1aa22d19ae96c8e6959cbd8b85a707bc6","impliedFormat":1},{"version":"7fe93b39b810eadd916be8db880dd7f0f7012a5cc6ffb62de8f62a2117fa6f1f","impliedFormat":1},{"version":"bb0074cc08b84a2374af33d8bf044b80851ccc9e719a5e202eacf40db2c31600","impliedFormat":1},{"version":"1a7daebe4f45fb03d9ec53d60008fbf9ac45a697fdc89e4ce218bc94b94f94d6","impliedFormat":1},{"version":"f94b133a3cb14a288803be545ac2683e0d0ff6661bcd37e31aaaec54fc382aed","impliedFormat":1},{"version":"f59d0650799f8782fd74cf73c19223730c6d1b9198671b1c5b3a38e1188b5953","impliedFormat":1},{"version":"8a15b4607d9a499e2dbeed9ec0d3c0d7372c850b2d5f1fb259e8f6d41d468a84","impliedFormat":1},{"version":"26e0fe14baee4e127f4365d1ae0b276f400562e45e19e35fd2d4c296684715e6","impliedFormat":1},{"version":"d6b1eba8496bdd0eed6fc8a685768fe01b2da4a0388b5fe7df558290bffcf32f","affectsGlobalScope":true,"impliedFormat":1},{"version":"eadcffda2aa84802c73938e589b9e58248d74c59cb7fcbca6474e3435ac15504","affectsGlobalScope":true,"impliedFormat":1},{"version":"105ba8ff7ba746404fe1a2e189d1d3d2e0eb29a08c18dded791af02f29fb4711","affectsGlobalScope":true,"impliedFormat":1},{"version":"00343ca5b2e3d48fa5df1db6e32ea2a59afab09590274a6cccb1dbae82e60c7c","affectsGlobalScope":true,"impliedFormat":1},{"version":"ebd9f816d4002697cb2864bea1f0b70a103124e18a8cd9645eeccc09bdf80ab4","affectsGlobalScope":true,"impliedFormat":1},{"version":"2c1afac30a01772cd2a9a298a7ce7706b5892e447bb46bdbeef720f7b5da77ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"7b0225f483e4fa685625ebe43dd584bb7973bbd84e66a6ba7bbe175ee1048b4f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c0a4b8ac6ce74679c1da2b3795296f5896e31c38e888469a8e0f99dc3305de60","affectsGlobalScope":true,"impliedFormat":1},{"version":"3084a7b5f569088e0146533a00830e206565de65cae2239509168b11434cd84f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c5079c53f0f141a0698faa903e76cb41cd664e3efb01cc17a5c46ec2eb0bef42","affectsGlobalScope":true,"impliedFormat":1},{"version":"32cafbc484dea6b0ab62cf8473182bbcb23020d70845b406f80b7526f38ae862","affectsGlobalScope":true,"impliedFormat":1},{"version":"fca4cdcb6d6c5ef18a869003d02c9f0fd95df8cfaf6eb431cd3376bc034cad36","affectsGlobalScope":true,"impliedFormat":1},{"version":"b93ec88115de9a9dc1b602291b85baf825c85666bf25985cc5f698073892b467","affectsGlobalScope":true,"impliedFormat":1},{"version":"f5c06dcc3fe849fcb297c247865a161f995cc29de7aa823afdd75aaaddc1419b","affectsGlobalScope":true,"impliedFormat":1},{"version":"b77e16112127a4b169ef0b8c3a4d730edf459c5f25fe52d5e436a6919206c4d7","affectsGlobalScope":true,"impliedFormat":1},{"version":"fbffd9337146eff822c7c00acbb78b01ea7ea23987f6c961eba689349e744f8c","affectsGlobalScope":true,"impliedFormat":1},{"version":"a995c0e49b721312f74fdfb89e4ba29bd9824c770bbb4021d74d2bf560e4c6bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"c7b3542146734342e440a84b213384bfa188835537ddbda50d30766f0593aff9","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce6180fa19b1cccd07ee7f7dbb9a367ac19c0ed160573e4686425060b6df7f57","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f02e2476bccb9dbe21280d6090f0df17d2f66b74711489415a8aa4df73c9675","affectsGlobalScope":true,"impliedFormat":1},{"version":"45e3ab34c1c013c8ab2dc1ba4c80c780744b13b5676800ae2e3be27ae862c40c","affectsGlobalScope":true,"impliedFormat":1},{"version":"805c86f6cca8d7702a62a844856dbaa2a3fd2abef0536e65d48732441dde5b5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e42e397f1a5a77994f0185fd1466520691456c772d06bf843e5084ceb879a0ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"f4c2b41f90c95b1c532ecc874bd3c111865793b23aebcc1c3cbbabcd5d76ffb0","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab26191cfad5b66afa11b8bf935ef1cd88fabfcb28d30b2dfa6fad877d050332","affectsGlobalScope":true,"impliedFormat":1},{"version":"2088bc26531e38fb05eedac2951480db5309f6be3fa4a08d2221abb0f5b4200d","affectsGlobalScope":true,"impliedFormat":1},{"version":"cb9d366c425fea79716a8fb3af0d78e6b22ebbab3bd64d25063b42dc9f531c1e","affectsGlobalScope":true,"impliedFormat":1},{"version":"500934a8089c26d57ebdb688fc9757389bb6207a3c8f0674d68efa900d2abb34","affectsGlobalScope":true,"impliedFormat":1},{"version":"689da16f46e647cef0d64b0def88910e818a5877ca5379ede156ca3afb780ac3","affectsGlobalScope":true,"impliedFormat":1},{"version":"bc21cc8b6fee4f4c2440d08035b7ea3c06b3511314c8bab6bef7a92de58a2593","affectsGlobalScope":true,"impliedFormat":1},{"version":"7ca53d13d2957003abb47922a71866ba7cb2068f8d154877c596d63c359fed25","affectsGlobalScope":true,"impliedFormat":1},{"version":"54725f8c4df3d900cb4dac84b64689ce29548da0b4e9b7c2de61d41c79293611","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5594bc3076ac29e6c1ebda77939bc4c8833de72f654b6e376862c0473199323","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f3eb332c2d73e729f3364fcc0c2b375e72a121e8157d25a82d67a138c83a95c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6f4427f9642ce8d500970e4e69d1397f64072ab73b97e476b4002a646ac743b1","affectsGlobalScope":true,"impliedFormat":1},{"version":"48915f327cd1dea4d7bd358d9dc7732f58f9e1626a29cc0c05c8c692419d9bb7","affectsGlobalScope":true,"impliedFormat":1},{"version":"b7bf9377723203b5a6a4b920164df22d56a43f593269ba6ae1fdc97774b68855","affectsGlobalScope":true,"impliedFormat":1},{"version":"db9709688f82c9e5f65a119c64d835f906efe5f559d08b11642d56eb85b79357","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b25b8c874acd1a4cf8444c3617e037d444d19080ac9f634b405583fd10ce1f7","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be57d7c90cf1f8112ee2636a068d8fd181289f82b744160ec56a7dc158a9f5","affectsGlobalScope":true,"impliedFormat":1},{"version":"a917a49ac94cd26b754ab84e113369a75d1a47a710661d7cd25e961cc797065f","affectsGlobalScope":true,"impliedFormat":1},{"version":"6d3261badeb7843d157ef3e6f5d1427d0eeb0af0cf9df84a62cfd29fd47ac86e","affectsGlobalScope":true,"impliedFormat":1},{"version":"195daca651dde22f2167ac0d0a05e215308119a3100f5e6268e8317d05a92526","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b11e4285cd2bb164a4dc09248bdec69e9842517db4ca47c1ba913011e44ff2f","affectsGlobalScope":true,"impliedFormat":1},{"version":"0508571a52475e245b02bc50fa1394065a0a3d05277fbf5120c3784b85651799","affectsGlobalScope":true,"impliedFormat":1},{"version":"8f9af488f510c3015af3cc8c267a9e9d96c4dd38a1fdff0e11dc5a544711415b","affectsGlobalScope":true,"impliedFormat":1},{"version":"fc611fea8d30ea72c6bbfb599c9b4d393ce22e2f5bfef2172534781e7d138104","affectsGlobalScope":true,"impliedFormat":1},{"version":"f128dae7c44d8f35ee42e0a437000a57c9f06cc04f8b4fb42eebf44954d53dc8","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ecb8e347cb6b2a8927c09b86263663289418df375f5e68e11a0ae683776978f","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ce14b81c5cc821994aa8ec1d42b220dd41b27fcc06373bce3958af7421b77d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3a048b3e9302ef9a34ef4ebb9aecfb28b66abb3bce577206a79fee559c230da","affectsGlobalScope":true,"impliedFormat":1},"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9","69274d91266b9bbba0f5d6f65075cace2a539c739fe73f22dfa053d7c013ebf9","5c0bf3f655393a93f5ac0894660863c4ce0c90062c17b5860950c432876e7fc8","81c42c754119ef4c29959980f1bde23bbe03a1b86177a8f968b2b4cbaafc1bcc","c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","0fb490a6869ddea3ec75f5f6d5a21054f82ce8cd60d472f9a1c70d42e295d4ac","ac1aadc908543ce94afbced5b8cc2d1b94b3b795a303e4c242004031b183765c","c30ca61bc62858baaf36ea887fba9d0032a5e060407a1deb3bf4dd38be64361b","9fb602236e65c57126f2d090c9968fd7ff6e406c350039e76831de069cc9d1f5","ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae","7ff10c73aab4f126ea1d1f7cd40c2b6c9057c974bde0fb75972d677f7ae67c26","3fdf6a42927e85ed94cc06a55b53b92bb0ab3f529fd3ffe15156a96748222915","2f59322b90429e64312dc6e75c9ed31123b0743e7358272cb5b42a586b5894ae","4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3",{"version":"41849007e704926b0a90d541cd4b27cb24ce250c86dae8cef37df96e55aaef21","signature":"dbe5e2e1be30c88d4492b8aaae9802d4bb9be42f992db4845a63fafc94d2b63b"},"42b300f515d975d3bf5777324b55b2231a7a7ae1c3a5d659248709cbbb987f9d","7446b5cbee5a79ada2657125cef88e0e64c722e35946da99f17515c645b4717f",{"version":"fa047096cf13a1fe0b45b2b4672e95fad831fc9a77be0516361eae6ec9454a3f","signature":"570cb6046f537533b9f8681667833b1bb6d5b57f002ca20169b4ea59a04c07b6"},"04adb19af4de59b923b996250d36447eed0cadec0a416ef7e4ded64a7afbe589",{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc2110f7decca6bfb9392e30421cfa1436479e4a6756e8fec6cbc22625d4f881","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"4137ebf04166f3a325f056aa56101adc75e9dceb30404a1844eb8604d89770e2","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"98498b101803bb3dde9f76a56e65c14b75db1cc8bec5f4db72be541570f74fc5","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"d2ae155afe8a01cc0ae612d99117cf8ef16692ba7c4366590156fdec1bcf2d8c","impliedFormat":1},{"version":"3f5e5d9be35913db9fea42a63f3df0b7e3c8703b97670a2125587b4dbbd56d7c","impliedFormat":1},{"version":"8caeb65fdc3bfe0d13f86f67324fcb2d858ed1c55f1f0cce892eb1acfb9f3239","impliedFormat":1},{"version":"57c23df0b5f7a8e26363a3849b0bc7763f6b241207157c8e40089d1df4116f35","affectsGlobalScope":true,"impliedFormat":1},{"version":"3b8bc0c17b54081b0878673989216229e575d67a10874e84566a21025a2461ee","impliedFormat":1},{"version":"5b0db5a58b73498792a29bfebc333438e61906fef75da898b410e24e52229e6f","impliedFormat":1},{"version":"dbe055b2b29a7bab2c1ca8f259436306adb43f469dca7e639a02cd3695d3f621","impliedFormat":1},{"version":"1678b04557dca52feab73cc67610918a7f5e25bfdba3e7fa081acd625d93106d","impliedFormat":1},{"version":"e3905f6902f0b69e5eefc230daa69fdd4ab707a973ec2d086d65af1b3ea47ef0","impliedFormat":1},{"version":"2ea729503db9793f2691162fec3dd1118cab62e96d025f8eeb376d43ec293395","impliedFormat":1},{"version":"9ec87fea42b92894b0f209931a880789d43c3397d09dd99c631ae40a2f7071d1","impliedFormat":1},{"version":"c68e88cdfadfb6c8ba5fc38e58a3a166b0beae77b1f05b7d921150a32a5ffb8d","impliedFormat":1},{"version":"2bc7aa4fba46df0bd495425a7c8201437a7d465f83854fac859df2d67f664df3","impliedFormat":1},{"version":"41d17e1ad9a002feb11c8cdd2777e5bbc0cdb1e3f595d237e4dded0b6949983b","impliedFormat":1},{"version":"07e4e61e946a9c15045539ecd5f5d2d02e7aab6fa82567826857e09cf0f37c2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"1c4714ccc29149efb8777a1da0b04b8d2258f5d13ddbf4cd3c3d361fb531ac86","impliedFormat":1},{"version":"3ff275f84f89f8a7c0543da838f9da9614201abc4ce74c533029825adfb4433d","impliedFormat":1},{"version":"0eb5d0cbf09de5d34542b977fd6a933bb2e0817bffe8e1a541b2f1ad1b9af1ff","impliedFormat":1},{"version":"10deca769dfed888051b1808d6746f8883a490a707f8bdf9367079146987d6d0","impliedFormat":1},{"version":"2c2bdaa1d8ead9f68628d6d9d250e46ee8e81aa4898b4769a36956ae15e060fe","impliedFormat":1},{"version":"c32c840c62d8bd7aeb3147aa6754cd2d922b990a6b6634530cb2ebdce5adc8e9","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"82b91e4e42e6c41bc7fc1b6c2dc5eba6a2ba98375eb1f210e6ff6bba2d54177e","impliedFormat":1},{"version":"6fe28249ac0c7bc19a79aa9264baf00efbd080e868dbe1d3052033ad1c64f206","affectsGlobalScope":true,"impliedFormat":1},{"version":"cbed824fec91efefc7bbdcb8b43d1a531fdbebd0e2ef19481501ff365a93cb70","impliedFormat":1},{"version":"4967529644e391115ca5592184d4b63980569adf60ee685f968fd59ab1557188","impliedFormat":1},{"version":"d0716593b3f2b0451bcf0c24cfa86dec2235c325c89f201934248b7c742715fc","impliedFormat":1},{"version":"ec501101c2a96133a6c695f934c8f6642149cc728571b29cbb7b770984c1088e","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"2991bca2cc0f0628a278df2a2ccdb8d6cbcb700f3761abbed62bba137d5b1790","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"230763250f20449fa7b3c9273e1967adb0023dc890d4be1553faca658ee65971","impliedFormat":1},{"version":"c3e9078b60cb329d1221f5878e88cecfa3e74460550e605a58fcfb41a66029ff","impliedFormat":1},{"version":"a74edb3bab7394a9dbde529d60632be590def2f5f01024dbd85441587fbfbbe0","impliedFormat":1},{"version":"0ea59f7d3e51440baa64f429253759b106cfcbaf51e474cae606e02265b37cf8","impliedFormat":1},{"version":"bc18a1991ba681f03e13285fa1d7b99b03b67ee671b7bc936254467177543890","impliedFormat":1},{"version":"00049ccc87f3f37726db03c01ca68fe74fd9c0109b68c29eb9923ebec2c76b13","impliedFormat":1},{"version":"fa94bbf532b7af8f394b95fa310980d6e20bd2d4c871c6a6cb9f70f03750a44b","impliedFormat":1},{"version":"68d3f35108e2608b1f2f28b36d19d7055f31c4465cc5692cbd06c716a9fe7973","impliedFormat":1},{"version":"a6d543044570fbeed13a7f9925a868081cd2b14ef59cdd9da6ae76d41cab03d3","affectsGlobalScope":true,"impliedFormat":1},{"version":"7fa2214bb0d64701bc6f9ce8cde2fd2ff8c571e0b23065fa04a8a5a6beb91511","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"016b29bf4926b80255a108c53a1451717350059da04fcae64d1075f5e93bbb39","impliedFormat":1},{"version":"841983e39bd4cbb463be385e92fda11057cab368bf27100a801c492f1d86cbaa","impliedFormat":1},{"version":"6f5383b3df1cdf4ff1aa7fb0850f77042b5786b5e65ec9a9b6be56ebfe4d9036","impliedFormat":1},{"version":"62fc21ed9ccbd83bd1166de277a4b5daaa8d15b5fa614c75610d20f3b73fba87","impliedFormat":1},{"version":"e4156ddb25aa0e3b5303d372f26957b36778f0f6bbd4326359269873295e3058","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc1b433a84cae05ddc5672d4823170af78606ad21ecef60dbc4570190cbf1357","impliedFormat":1},{"version":"9d3821bc75c59577e52643324cec92fc2145642e8d17cf7ee07a3181f21d985d","impliedFormat":1},{"version":"7f78cfb2b343838612c192cb251746e3a7c62ac7675726a47e130d9b213f6580","impliedFormat":1},{"version":"201db9cf1687fab1adf5282fcba861f382b32303dc4f67c89d59655e78a25461","impliedFormat":1},{"version":"c77fb31bc17fd241d3922a9f88c59e3361cdf76d1328ba9412fc6bf7310b638d","impliedFormat":1},{"version":"0a20eaf2e4b1e3c1e1f87f7bccb0c936375b23b022baeea750519b7c9bc6ce83","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"a16b91b27bd6b706c687c88cbc8a7d4ee98e5ed6043026d6b84bda923c0aed67","impliedFormat":1},{"version":"694b812e0ed11285e8822cf8131e3ce7083a500b3b1d185fff9ed1089677bd0a","impliedFormat":1},{"version":"99ab6d0d660ce4d21efb52288a39fd35bb3f556980ec5463b1ae8f304a3bbc85","impliedFormat":1},{"version":"6eeded8c7e352be6e0efb83f4935ec752513c4d22043b52522b90849a49a3a11","impliedFormat":1},{"version":"6c1ad90050ffbb151cacc68e2d06ea1a26a945659391e32651f5d42b86fd7f2c","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"0d759cc99e081cacd0352467a0c24e979a6ef748329aa6ddea2d789664580201","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"47767435860d3f8dccb0f6263bdca9ad112058014e1802e63c32bd0907e5c550","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"00a196792eed6e9b7f988db0d3ced11a94ecd1e258fd19124ce89fe7642df35a","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,79]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[231,1],[142,2],[143,2],[144,3],[82,4],[145,5],[146,6],[147,7],[80,8],[148,9],[149,10],[150,11],[151,12],[152,13],[153,14],[154,14],[155,15],[156,16],[157,17],[158,18],[83,8],[81,8],[159,19],[160,20],[161,21],[202,22],[162,23],[163,24],[164,23],[165,25],[166,26],[168,27],[169,28],[170,28],[171,28],[172,29],[173,30],[174,31],[175,32],[176,33],[177,34],[178,34],[179,35],[180,8],[181,8],[182,36],[183,37],[184,36],[185,38],[186,39],[187,40],[188,41],[189,42],[190,43],[191,44],[192,45],[193,46],[194,47],[195,48],[196,49],[197,50],[198,51],[199,52],[84,23],[85,8],[86,53],[87,54],[88,8],[89,55],[90,8],[133,56],[134,57],[135,58],[136,58],[137,59],[138,8],[139,60],[140,61],[141,57],[200,62],[201,63],[167,8],[207,64],[229,8],[228,8],[222,65],[209,66],[208,8],[205,67],[210,8],[203,68],[211,8],[230,69],[212,8],[206,8],[221,70],[223,71],[204,72],[227,73],[225,74],[224,75],[226,76],[213,8],[219,77],[216,78],[218,79],[217,80],[215,81],[214,8],[220,82],[59,8],[60,8],[10,8],[12,8],[11,8],[2,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],[20,8],[3,8],[21,8],[22,8],[4,8],[23,8],[27,8],[24,8],[25,8],[26,8],[28,8],[29,8],[30,8],[5,8],[31,8],[32,8],[33,8],[34,8],[6,8],[38,8],[35,8],[36,8],[37,8],[39,8],[7,8],[40,8],[45,8],[46,8],[41,8],[42,8],[43,8],[44,8],[8,8],[50,8],[47,8],[48,8],[49,8],[51,8],[9,8],[52,8],[53,8],[54,8],[56,8],[55,8],[57,8],[1,8],[58,8],[109,83],[121,84],[106,85],[122,86],[131,87],[97,88],[98,89],[96,90],[130,91],[125,92],[129,93],[100,94],[118,95],[99,96],[128,97],[94,98],[95,92],[101,99],[102,8],[108,100],[105,99],[92,101],[132,102],[123,103],[112,104],[111,99],[113,105],[116,106],[110,107],[114,108],[126,91],[103,109],[104,110],[117,111],[93,86],[120,112],[119,99],[107,110],[115,113],[124,8],[91,8],[127,114],[69,115],[70,116],[68,117],[72,118],[73,54],[61,8],[66,119],[67,120],[63,121],[65,54],[64,122],[71,123],[62,8],[78,124],[79,125],[75,8],[77,126],[76,121],[74,8]],"affectedFilesPendingEmit":[[69,17],[70,17],[68,17],[72,17],[73,17],[61,17],[66,17],[67,17],[63,17],[65,17],[64,17],[71,17],[62,17],[78,17],[79,17],[75,17],[77,17],[76,17],[74,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79],"version":"6.0.3"}
\ No newline at end of file
+{"fileNames":["../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2025.float16.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/ner-rules.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/provenance.ts","./src/lib/evidence-chain.ts","./src/lib/tokenizer.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","./src/registry/pcmg-corpus.ts","./src/registry/types.ts","./src/registry/pcmg.ts","./src/registry/hitl-runner.ts","./src/registry/index.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/net.d.ts","../../node_modules/.bun/buffer@6.0.3/node_modules/buffer/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.13/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228,231],[83,143,144,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,147,152,154,157,158,161,163,164,165,167,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,147,148,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,149,154,158,161,163,164,165,178,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,150,151,154,158,161,163,164,165,169,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,183,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,152,154,157,158,161,163,164,165,167,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,153,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,155,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,156,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,159,161,163,164,165,178,183,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,157,158,159,161,163,164,165,178,183,186,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,133,146,154,157,158,160,161,163,164,165,167,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,160,161,163,164,165,167,178,183,192,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,160,161,162,163,164,165,178,183,192,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[81,82,83,84,85,86,87,88,89,90,91,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,166,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,167,178,183,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,169,178,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,170,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,173,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,175,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,176,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,167,178,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,179,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,180,196,199,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,183,185,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,184,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,187,204,205,206,208,210,221,223,224,225,226,227,228],[83,143,146,154,158,161,163,164,165,178,183,189,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,188,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,190,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,190,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,167,178,183,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,193,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,167,178,194,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,160,161,163,164,165,176,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,196,197,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,197,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,198,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,166,178,199,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,200,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,149,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,201,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,173,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,154,157,158,159,161,163,164,165,173,178,183,186,195,198,199,201,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,151,154,158,160,161,163,164,165,178,192,196,201,204,205,206,207,210,211,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,221,223,224,225,226,227,228],[83,133,146,154,158,161,163,164,165,178,204,205,208,210,221,223,224,225,226,227,228],[83,133,146,151,154,158,161,163,164,165,173,178,183,186,192,196,201,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,203,204,205,206,208,209,210,211,212,213,214,220,221,222,223,224,225,226,227,228,229,230],[83,146,149,151,154,158,159,161,163,164,165,169,178,186,192,195,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,214,221,223,224,225,226,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,219,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,216,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,216,217,218,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,217,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,223,224,225,226,227,228],[83,98,101,104,105,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,146,154,158,161,163,164,165,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,105,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,98,101,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,167,178,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,146,154,158,161,163,164,165,178,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,101,146,154,158,161,163,164,165,167,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,92,93,94,96,100,146,154,157,158,161,163,164,165,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,110,118,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,99,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,127,128,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,96,101,146,154,158,161,163,164,165,178,186,195,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,101,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,92,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,96,97,99,100,101,102,103,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,128,129,130,131,132,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,120,123,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,110,111,112,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,101,111,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,100,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,95,101,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,105,111,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,105,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,101,104,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,97,101,110,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,120,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,101,127,146,154,158,161,163,164,165,178,186,201,203,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,69,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,63,68,69,70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[66,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[61,63,64,65,66,67,68,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[64,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,63,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[64,83,146,151,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,76,78,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[77,78,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[77,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228]],"fileInfos":[{"version":"bcd24271a113971ba9eb71ff8cb01bc6b0f872a85c23fdbe5d93065b375933cd","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f88bedbeb09c6f5a6645cb24c7c55f1aa22d19ae96c8e6959cbd8b85a707bc6","impliedFormat":1},{"version":"7fe93b39b810eadd916be8db880dd7f0f7012a5cc6ffb62de8f62a2117fa6f1f","impliedFormat":1},{"version":"bb0074cc08b84a2374af33d8bf044b80851ccc9e719a5e202eacf40db2c31600","impliedFormat":1},{"version":"1a7daebe4f45fb03d9ec53d60008fbf9ac45a697fdc89e4ce218bc94b94f94d6","impliedFormat":1},{"version":"f94b133a3cb14a288803be545ac2683e0d0ff6661bcd37e31aaaec54fc382aed","impliedFormat":1},{"version":"f59d0650799f8782fd74cf73c19223730c6d1b9198671b1c5b3a38e1188b5953","impliedFormat":1},{"version":"8a15b4607d9a499e2dbeed9ec0d3c0d7372c850b2d5f1fb259e8f6d41d468a84","impliedFormat":1},{"version":"26e0fe14baee4e127f4365d1ae0b276f400562e45e19e35fd2d4c296684715e6","impliedFormat":1},{"version":"d6b1eba8496bdd0eed6fc8a685768fe01b2da4a0388b5fe7df558290bffcf32f","affectsGlobalScope":true,"impliedFormat":1},{"version":"eadcffda2aa84802c73938e589b9e58248d74c59cb7fcbca6474e3435ac15504","affectsGlobalScope":true,"impliedFormat":1},{"version":"105ba8ff7ba746404fe1a2e189d1d3d2e0eb29a08c18dded791af02f29fb4711","affectsGlobalScope":true,"impliedFormat":1},{"version":"00343ca5b2e3d48fa5df1db6e32ea2a59afab09590274a6cccb1dbae82e60c7c","affectsGlobalScope":true,"impliedFormat":1},{"version":"ebd9f816d4002697cb2864bea1f0b70a103124e18a8cd9645eeccc09bdf80ab4","affectsGlobalScope":true,"impliedFormat":1},{"version":"2c1afac30a01772cd2a9a298a7ce7706b5892e447bb46bdbeef720f7b5da77ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"7b0225f483e4fa685625ebe43dd584bb7973bbd84e66a6ba7bbe175ee1048b4f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c0a4b8ac6ce74679c1da2b3795296f5896e31c38e888469a8e0f99dc3305de60","affectsGlobalScope":true,"impliedFormat":1},{"version":"3084a7b5f569088e0146533a00830e206565de65cae2239509168b11434cd84f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c5079c53f0f141a0698faa903e76cb41cd664e3efb01cc17a5c46ec2eb0bef42","affectsGlobalScope":true,"impliedFormat":1},{"version":"32cafbc484dea6b0ab62cf8473182bbcb23020d70845b406f80b7526f38ae862","affectsGlobalScope":true,"impliedFormat":1},{"version":"fca4cdcb6d6c5ef18a869003d02c9f0fd95df8cfaf6eb431cd3376bc034cad36","affectsGlobalScope":true,"impliedFormat":1},{"version":"b93ec88115de9a9dc1b602291b85baf825c85666bf25985cc5f698073892b467","affectsGlobalScope":true,"impliedFormat":1},{"version":"f5c06dcc3fe849fcb297c247865a161f995cc29de7aa823afdd75aaaddc1419b","affectsGlobalScope":true,"impliedFormat":1},{"version":"b77e16112127a4b169ef0b8c3a4d730edf459c5f25fe52d5e436a6919206c4d7","affectsGlobalScope":true,"impliedFormat":1},{"version":"fbffd9337146eff822c7c00acbb78b01ea7ea23987f6c961eba689349e744f8c","affectsGlobalScope":true,"impliedFormat":1},{"version":"a995c0e49b721312f74fdfb89e4ba29bd9824c770bbb4021d74d2bf560e4c6bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"c7b3542146734342e440a84b213384bfa188835537ddbda50d30766f0593aff9","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce6180fa19b1cccd07ee7f7dbb9a367ac19c0ed160573e4686425060b6df7f57","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f02e2476bccb9dbe21280d6090f0df17d2f66b74711489415a8aa4df73c9675","affectsGlobalScope":true,"impliedFormat":1},{"version":"45e3ab34c1c013c8ab2dc1ba4c80c780744b13b5676800ae2e3be27ae862c40c","affectsGlobalScope":true,"impliedFormat":1},{"version":"805c86f6cca8d7702a62a844856dbaa2a3fd2abef0536e65d48732441dde5b5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e42e397f1a5a77994f0185fd1466520691456c772d06bf843e5084ceb879a0ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"f4c2b41f90c95b1c532ecc874bd3c111865793b23aebcc1c3cbbabcd5d76ffb0","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab26191cfad5b66afa11b8bf935ef1cd88fabfcb28d30b2dfa6fad877d050332","affectsGlobalScope":true,"impliedFormat":1},{"version":"2088bc26531e38fb05eedac2951480db5309f6be3fa4a08d2221abb0f5b4200d","affectsGlobalScope":true,"impliedFormat":1},{"version":"cb9d366c425fea79716a8fb3af0d78e6b22ebbab3bd64d25063b42dc9f531c1e","affectsGlobalScope":true,"impliedFormat":1},{"version":"500934a8089c26d57ebdb688fc9757389bb6207a3c8f0674d68efa900d2abb34","affectsGlobalScope":true,"impliedFormat":1},{"version":"689da16f46e647cef0d64b0def88910e818a5877ca5379ede156ca3afb780ac3","affectsGlobalScope":true,"impliedFormat":1},{"version":"bc21cc8b6fee4f4c2440d08035b7ea3c06b3511314c8bab6bef7a92de58a2593","affectsGlobalScope":true,"impliedFormat":1},{"version":"7ca53d13d2957003abb47922a71866ba7cb2068f8d154877c596d63c359fed25","affectsGlobalScope":true,"impliedFormat":1},{"version":"54725f8c4df3d900cb4dac84b64689ce29548da0b4e9b7c2de61d41c79293611","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5594bc3076ac29e6c1ebda77939bc4c8833de72f654b6e376862c0473199323","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f3eb332c2d73e729f3364fcc0c2b375e72a121e8157d25a82d67a138c83a95c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6f4427f9642ce8d500970e4e69d1397f64072ab73b97e476b4002a646ac743b1","affectsGlobalScope":true,"impliedFormat":1},{"version":"48915f327cd1dea4d7bd358d9dc7732f58f9e1626a29cc0c05c8c692419d9bb7","affectsGlobalScope":true,"impliedFormat":1},{"version":"b7bf9377723203b5a6a4b920164df22d56a43f593269ba6ae1fdc97774b68855","affectsGlobalScope":true,"impliedFormat":1},{"version":"db9709688f82c9e5f65a119c64d835f906efe5f559d08b11642d56eb85b79357","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b25b8c874acd1a4cf8444c3617e037d444d19080ac9f634b405583fd10ce1f7","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be57d7c90cf1f8112ee2636a068d8fd181289f82b744160ec56a7dc158a9f5","affectsGlobalScope":true,"impliedFormat":1},{"version":"a917a49ac94cd26b754ab84e113369a75d1a47a710661d7cd25e961cc797065f","affectsGlobalScope":true,"impliedFormat":1},{"version":"6d3261badeb7843d157ef3e6f5d1427d0eeb0af0cf9df84a62cfd29fd47ac86e","affectsGlobalScope":true,"impliedFormat":1},{"version":"195daca651dde22f2167ac0d0a05e215308119a3100f5e6268e8317d05a92526","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b11e4285cd2bb164a4dc09248bdec69e9842517db4ca47c1ba913011e44ff2f","affectsGlobalScope":true,"impliedFormat":1},{"version":"0508571a52475e245b02bc50fa1394065a0a3d05277fbf5120c3784b85651799","affectsGlobalScope":true,"impliedFormat":1},{"version":"8f9af488f510c3015af3cc8c267a9e9d96c4dd38a1fdff0e11dc5a544711415b","affectsGlobalScope":true,"impliedFormat":1},{"version":"fc611fea8d30ea72c6bbfb599c9b4d393ce22e2f5bfef2172534781e7d138104","affectsGlobalScope":true,"impliedFormat":1},{"version":"f128dae7c44d8f35ee42e0a437000a57c9f06cc04f8b4fb42eebf44954d53dc8","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ecb8e347cb6b2a8927c09b86263663289418df375f5e68e11a0ae683776978f","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ce14b81c5cc821994aa8ec1d42b220dd41b27fcc06373bce3958af7421b77d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3a048b3e9302ef9a34ef4ebb9aecfb28b66abb3bce577206a79fee559c230da","affectsGlobalScope":true,"impliedFormat":1},"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9",{"version":"37c1c274663963b9523a92a179b3a61990c72cf48b3988b5206ba2d81ce99c18","signature":"d3cb22893cb5edb7106b4eded21d68368d6f3c3708503c4d9bd004d06c9fdcca"},{"version":"547025c8854924140149c8cb76a8b4485a365f511bb6be8d0901962bfc097845","signature":"fc33c4a582c06286bff462417e2cc70af81ee00776d67d721509436542efe678"},{"version":"9f6ce49396194e711657387adce9d76c0b01a62dddac7b208920e7a2bdeefb8d","signature":"de100b2e38b4f55c5a5a811160a857c39d19edd54b56bab8e4637dba7f90e6a4"},"81c42c754119ef4c29959980f1bde23bbe03a1b86177a8f968b2b4cbaafc1bcc","c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","0fb490a6869ddea3ec75f5f6d5a21054f82ce8cd60d472f9a1c70d42e295d4ac",{"version":"810d384939274e904c0df58a3bd796f0b347fb6adb8729d9b3c5e7800453d417","signature":"5fea9ba8105af08db65a4487da2787f06c49fbef29287afd0ae4e279338fbb87"},{"version":"40da64abbee19779c6387fd03f5f6e34d359f58d72b270c7b007db3f5b61da45","signature":"1f7adcc5ebc4e1c7fdf673153cde3b8521c35f4d7eda5b37ce487c696d05e869"},"c30ca61bc62858baaf36ea887fba9d0032a5e060407a1deb3bf4dd38be64361b","9fb602236e65c57126f2d090c9968fd7ff6e406c350039e76831de069cc9d1f5","ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae",{"version":"a7e598fa841346a3e39c09240df4f5954927750ca374db1201dd2a8972aa54d1","signature":"87b0758f2221e9faac969b767c95857eea9234e273555c9a4a2711b7797a8482"},"2f59322b90429e64312dc6e75c9ed31123b0743e7358272cb5b42a586b5894ae","4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3",{"version":"41849007e704926b0a90d541cd4b27cb24ce250c86dae8cef37df96e55aaef21","signature":"dbe5e2e1be30c88d4492b8aaae9802d4bb9be42f992db4845a63fafc94d2b63b"},"42b300f515d975d3bf5777324b55b2231a7a7ae1c3a5d659248709cbbb987f9d",{"version":"5fbdf456666df12fd510a501a039798d98fe7010632661b27b53ba91c2fb542b","signature":"95b527255091cb3dbc37f13abe8fe88cdd1a3d3b2e86b79436a10a84eee34b4f"},"fa047096cf13a1fe0b45b2b4672e95fad831fc9a77be0516361eae6ec9454a3f","04adb19af4de59b923b996250d36447eed0cadec0a416ef7e4ded64a7afbe589",{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc2110f7decca6bfb9392e30421cfa1436479e4a6756e8fec6cbc22625d4f881","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"4137ebf04166f3a325f056aa56101adc75e9dceb30404a1844eb8604d89770e2","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"98498b101803bb3dde9f76a56e65c14b75db1cc8bec5f4db72be541570f74fc5","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"d2ae155afe8a01cc0ae612d99117cf8ef16692ba7c4366590156fdec1bcf2d8c","impliedFormat":1},{"version":"3f5e5d9be35913db9fea42a63f3df0b7e3c8703b97670a2125587b4dbbd56d7c","impliedFormat":1},{"version":"8caeb65fdc3bfe0d13f86f67324fcb2d858ed1c55f1f0cce892eb1acfb9f3239","impliedFormat":1},{"version":"57c23df0b5f7a8e26363a3849b0bc7763f6b241207157c8e40089d1df4116f35","affectsGlobalScope":true,"impliedFormat":1},{"version":"3b8bc0c17b54081b0878673989216229e575d67a10874e84566a21025a2461ee","impliedFormat":1},{"version":"5b0db5a58b73498792a29bfebc333438e61906fef75da898b410e24e52229e6f","impliedFormat":1},{"version":"dbe055b2b29a7bab2c1ca8f259436306adb43f469dca7e639a02cd3695d3f621","impliedFormat":1},{"version":"1678b04557dca52feab73cc67610918a7f5e25bfdba3e7fa081acd625d93106d","impliedFormat":1},{"version":"e3905f6902f0b69e5eefc230daa69fdd4ab707a973ec2d086d65af1b3ea47ef0","impliedFormat":1},{"version":"2ea729503db9793f2691162fec3dd1118cab62e96d025f8eeb376d43ec293395","impliedFormat":1},{"version":"9ec87fea42b92894b0f209931a880789d43c3397d09dd99c631ae40a2f7071d1","impliedFormat":1},{"version":"c68e88cdfadfb6c8ba5fc38e58a3a166b0beae77b1f05b7d921150a32a5ffb8d","impliedFormat":1},{"version":"2bc7aa4fba46df0bd495425a7c8201437a7d465f83854fac859df2d67f664df3","impliedFormat":1},{"version":"41d17e1ad9a002feb11c8cdd2777e5bbc0cdb1e3f595d237e4dded0b6949983b","impliedFormat":1},{"version":"07e4e61e946a9c15045539ecd5f5d2d02e7aab6fa82567826857e09cf0f37c2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"1c4714ccc29149efb8777a1da0b04b8d2258f5d13ddbf4cd3c3d361fb531ac86","impliedFormat":1},{"version":"3ff275f84f89f8a7c0543da838f9da9614201abc4ce74c533029825adfb4433d","impliedFormat":1},{"version":"0eb5d0cbf09de5d34542b977fd6a933bb2e0817bffe8e1a541b2f1ad1b9af1ff","impliedFormat":1},{"version":"10deca769dfed888051b1808d6746f8883a490a707f8bdf9367079146987d6d0","impliedFormat":1},{"version":"2c2bdaa1d8ead9f68628d6d9d250e46ee8e81aa4898b4769a36956ae15e060fe","impliedFormat":1},{"version":"c32c840c62d8bd7aeb3147aa6754cd2d922b990a6b6634530cb2ebdce5adc8e9","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"82b91e4e42e6c41bc7fc1b6c2dc5eba6a2ba98375eb1f210e6ff6bba2d54177e","impliedFormat":1},{"version":"6fe28249ac0c7bc19a79aa9264baf00efbd080e868dbe1d3052033ad1c64f206","affectsGlobalScope":true,"impliedFormat":1},{"version":"cbed824fec91efefc7bbdcb8b43d1a531fdbebd0e2ef19481501ff365a93cb70","impliedFormat":1},{"version":"4967529644e391115ca5592184d4b63980569adf60ee685f968fd59ab1557188","impliedFormat":1},{"version":"d0716593b3f2b0451bcf0c24cfa86dec2235c325c89f201934248b7c742715fc","impliedFormat":1},{"version":"ec501101c2a96133a6c695f934c8f6642149cc728571b29cbb7b770984c1088e","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"2991bca2cc0f0628a278df2a2ccdb8d6cbcb700f3761abbed62bba137d5b1790","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"230763250f20449fa7b3c9273e1967adb0023dc890d4be1553faca658ee65971","impliedFormat":1},{"version":"c3e9078b60cb329d1221f5878e88cecfa3e74460550e605a58fcfb41a66029ff","impliedFormat":1},{"version":"a74edb3bab7394a9dbde529d60632be590def2f5f01024dbd85441587fbfbbe0","impliedFormat":1},{"version":"0ea59f7d3e51440baa64f429253759b106cfcbaf51e474cae606e02265b37cf8","impliedFormat":1},{"version":"bc18a1991ba681f03e13285fa1d7b99b03b67ee671b7bc936254467177543890","impliedFormat":1},{"version":"00049ccc87f3f37726db03c01ca68fe74fd9c0109b68c29eb9923ebec2c76b13","impliedFormat":1},{"version":"fa94bbf532b7af8f394b95fa310980d6e20bd2d4c871c6a6cb9f70f03750a44b","impliedFormat":1},{"version":"68d3f35108e2608b1f2f28b36d19d7055f31c4465cc5692cbd06c716a9fe7973","impliedFormat":1},{"version":"a6d543044570fbeed13a7f9925a868081cd2b14ef59cdd9da6ae76d41cab03d3","affectsGlobalScope":true,"impliedFormat":1},{"version":"7fa2214bb0d64701bc6f9ce8cde2fd2ff8c571e0b23065fa04a8a5a6beb91511","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"016b29bf4926b80255a108c53a1451717350059da04fcae64d1075f5e93bbb39","impliedFormat":1},{"version":"841983e39bd4cbb463be385e92fda11057cab368bf27100a801c492f1d86cbaa","impliedFormat":1},{"version":"6f5383b3df1cdf4ff1aa7fb0850f77042b5786b5e65ec9a9b6be56ebfe4d9036","impliedFormat":1},{"version":"62fc21ed9ccbd83bd1166de277a4b5daaa8d15b5fa614c75610d20f3b73fba87","impliedFormat":1},{"version":"e4156ddb25aa0e3b5303d372f26957b36778f0f6bbd4326359269873295e3058","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc1b433a84cae05ddc5672d4823170af78606ad21ecef60dbc4570190cbf1357","impliedFormat":1},{"version":"9d3821bc75c59577e52643324cec92fc2145642e8d17cf7ee07a3181f21d985d","impliedFormat":1},{"version":"7f78cfb2b343838612c192cb251746e3a7c62ac7675726a47e130d9b213f6580","impliedFormat":1},{"version":"201db9cf1687fab1adf5282fcba861f382b32303dc4f67c89d59655e78a25461","impliedFormat":1},{"version":"c77fb31bc17fd241d3922a9f88c59e3361cdf76d1328ba9412fc6bf7310b638d","impliedFormat":1},{"version":"0a20eaf2e4b1e3c1e1f87f7bccb0c936375b23b022baeea750519b7c9bc6ce83","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"a16b91b27bd6b706c687c88cbc8a7d4ee98e5ed6043026d6b84bda923c0aed67","impliedFormat":1},{"version":"694b812e0ed11285e8822cf8131e3ce7083a500b3b1d185fff9ed1089677bd0a","impliedFormat":1},{"version":"99ab6d0d660ce4d21efb52288a39fd35bb3f556980ec5463b1ae8f304a3bbc85","impliedFormat":1},{"version":"6eeded8c7e352be6e0efb83f4935ec752513c4d22043b52522b90849a49a3a11","impliedFormat":1},{"version":"6c1ad90050ffbb151cacc68e2d06ea1a26a945659391e32651f5d42b86fd7f2c","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"0d759cc99e081cacd0352467a0c24e979a6ef748329aa6ddea2d789664580201","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"47767435860d3f8dccb0f6263bdca9ad112058014e1802e63c32bd0907e5c550","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"00a196792eed6e9b7f988db0d3ced11a94ecd1e258fd19124ce89fe7642df35a","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,80]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[232,1],[143,2],[144,2],[145,3],[83,4],[146,5],[147,6],[148,7],[81,8],[149,9],[150,10],[151,11],[152,12],[153,13],[154,14],[155,14],[156,15],[157,16],[158,17],[159,18],[84,8],[82,8],[160,19],[161,20],[162,21],[203,22],[163,23],[164,24],[165,23],[166,25],[167,26],[169,27],[170,28],[171,28],[172,28],[173,29],[174,30],[175,31],[176,32],[177,33],[178,34],[179,34],[180,35],[181,8],[182,8],[183,36],[184,37],[185,36],[186,38],[187,39],[188,40],[189,41],[190,42],[191,43],[192,44],[193,45],[194,46],[195,47],[196,48],[197,49],[198,50],[199,51],[200,52],[85,23],[86,8],[87,53],[88,54],[89,8],[90,55],[91,8],[134,56],[135,57],[136,58],[137,58],[138,59],[139,8],[140,60],[141,61],[142,57],[201,62],[202,63],[168,8],[208,64],[230,8],[229,8],[223,65],[210,66],[209,8],[206,67],[211,8],[204,68],[212,8],[231,69],[213,8],[207,8],[222,70],[224,71],[205,72],[228,73],[226,74],[225,75],[227,76],[214,8],[220,77],[217,78],[219,79],[218,80],[216,81],[215,8],[221,82],[59,8],[60,8],[10,8],[12,8],[11,8],[2,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],[20,8],[3,8],[21,8],[22,8],[4,8],[23,8],[27,8],[24,8],[25,8],[26,8],[28,8],[29,8],[30,8],[5,8],[31,8],[32,8],[33,8],[34,8],[6,8],[38,8],[35,8],[36,8],[37,8],[39,8],[7,8],[40,8],[45,8],[46,8],[41,8],[42,8],[43,8],[44,8],[8,8],[50,8],[47,8],[48,8],[49,8],[51,8],[9,8],[52,8],[53,8],[54,8],[56,8],[55,8],[57,8],[1,8],[58,8],[110,83],[122,84],[107,85],[123,86],[132,87],[98,88],[99,89],[97,90],[131,91],[126,92],[130,93],[101,94],[119,95],[100,96],[129,97],[95,98],[96,92],[102,99],[103,8],[109,100],[106,99],[93,101],[133,102],[124,103],[113,104],[112,99],[114,105],[117,106],[111,107],[115,108],[127,91],[104,109],[105,110],[118,111],[94,86],[121,112],[120,99],[108,110],[116,113],[125,8],[92,8],[128,114],[71,115],[72,116],[70,117],[73,118],[74,54],[61,8],[67,119],[69,120],[63,121],[64,122],[66,54],[65,123],[68,124],[62,8],[79,125],[80,126],[76,8],[78,127],[77,128],[75,8]],"affectedFilesPendingEmit":[[71,17],[72,17],[70,17],[73,17],[74,17],[61,17],[67,17],[69,17],[63,17],[64,17],[66,17],[65,17],[68,17],[62,17],[79,17],[80,17],[76,17],[78,17],[77,17],[75,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80],"version":"6.0.3"}
\ No newline at end of file
diff --git a/scripts/banda.ts b/scripts/banda.ts
index 9d02940f..727d7485 100644
--- a/scripts/banda.ts
+++ b/scripts/banda.ts
@@ -17,7 +17,8 @@
  * Modes:
  *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
  *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
- *   council    — modelo diferente por papel via OpenRouter (~$1-3, max qualidade)
+ *   council    — GPT via Codex CLI + Claude via Claude CLI (subscriptions) +
+ *                Gemini 3.1 Pro via OpenRouter (~$0.03/council medido 2026-06-10)
  *
  * Output:
  *   - Console: síntese do Maestro (ou verbose com todos)
@@ -118,10 +119,10 @@ const MODELS: Record<string, ModelMap> = {
     maestro:    'anthropic/claude-haiku-4.5',
   },
   council: {
-    critic:     'openai/gpt-5.4',
-    supporter:  'anthropic/claude-sonnet-4.6',
-    questioner: 'google/gemini-2.5-pro',
-    maestro:    'anthropic/claude-opus-4.7',
+    critic:     'cli:codex:gpt-5.5',                 // Codex subscription (EGOS_CODEX_EFFORT=medium|high|xhigh)
+    supporter:  'cli:claude:sonnet',                 // Claude subscription
+    questioner: 'google/gemini-3.1-pro-preview',     // OpenRouter (~$0.03/council — testado 2026-06-10)
+    maestro:    'cli:claude:opus',                   // Claude subscription
   },
 };
 
@@ -263,12 +264,45 @@ decisao:
 Máx 350 palavras.`,
 };
 
-// ─── LLM call via OpenRouter ───────────────────────────────────────────────────
+// ─── LLM call: subscription CLIs (cli:*) ou OpenRouter ─────────────────────────
+// Corte Enio 2026-06-10: GPT via Codex subscription, Claude via Claude Code
+// subscription; só a perna Gemini (e fallbacks) paga OpenRouter (~$0.001-0.03).
+// Guarani/Antigravity FORA da banda (atribuições próprias).
+
+import { spawnSync } from 'node:child_process';
+
+function callCli(cmd: string, args: string[]): string {
+  const r = spawnSync(cmd, args, {
+    encoding: 'utf-8',
+    timeout: 300_000,
+    maxBuffer: 10 * 1024 * 1024,
+  });
+  if (r.error) throw new Error(`${cmd} spawn: ${r.error.message}`);
+  if (r.status !== 0) throw new Error(`${cmd} exit ${r.status}: ${(r.stderr || '').slice(0, 300)}`);
+  const out = (r.stdout || '').trim();
+  if (!out) throw new Error(`${cmd}: stdout vazio`);
+  return out;
+}
 
 async function callLLM(model: string, prompt: string): Promise<string> {
   if (DRY) {
     return `# DRY-RUN output for ${model}\nsimulated_response: ok\nwould_call_model: ${model}`;
   }
+  // cli:codex:<model> — Codex CLI (subscription). Effort via EGOS_CODEX_EFFORT
+  // (medium|high|xhigh; default medium). Prompt como arg posicional (padrão
+  // provado no pre-commit §codex).
+  if (model.startsWith('cli:codex:')) {
+    const m = model.slice('cli:codex:'.length);
+    const effort = process.env.EGOS_CODEX_EFFORT ?? 'medium';
+    return callCli('codex', [
+      'exec', '--model', m, '-c', `model_reasoning_effort="${effort}"`, prompt,
+    ]);
+  }
+  // cli:claude:<alias> — Claude Code CLI (subscription), print mode headless.
+  if (model.startsWith('cli:claude:')) {
+    const m = model.slice('cli:claude:'.length);
+    return callCli('claude', ['-p', '--model', m, prompt]);
+  }
   // Route deepseek/* to direct API when DEEPSEEK_API_KEY is available
   const isDeepseek = model.includes('deepseek');
   const deepseekKey = ENV.DEEPSEEK_API_KEY ?? '';

exec
/bin/bash -lc 'git diff 1ee70f2785af91d5f5dfc577420472e2696dfa49 -- packages/guard-brasil/src/index.ts packages/guard-brasil/src/lib/index.ts packages/guard-brasil/src/lib/pii-scanner.ts packages/guard-brasil/src/lib/tokenizer.ts packages/guard-brasil/src/guard.test.ts scripts/banda.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/packages/guard-brasil/src/guard.test.ts b/packages/guard-brasil/src/guard.test.ts
index fa8086bf..307a7473 100644
--- a/packages/guard-brasil/src/guard.test.ts
+++ b/packages/guard-brasil/src/guard.test.ts
@@ -7,6 +7,9 @@
 import { describe, expect, it } from 'bun:test';
 import { GuardBrasil } from './guard.js';
 import { detectPII, INFRASTRUCTURE_SECRET_PATTERNS } from './pii-patterns.js';
+import { namedTokenize, namedRestore } from './lib/tokenizer.js';
+import { applyNERRules } from './lib/ner-rules.js';
+import { scanForPII } from './lib/pii-scanner.js';
 
 // ─── Helpers ──────────────────────────────────────────────────────────────────
 
@@ -424,3 +427,90 @@ describe('Infrastructure Secret Patterns — detectPII with INFRASTRUCTURE_SECRE
     expect(matches).toHaveLength(0);
   });
 });
+
+// ─── namedTokenize — DataVirtus-compatible reversible redaction ───────────────
+
+describe('namedTokenize — readable placeholders', () => {
+  it('replaces CPF with [CPF_0001] and restores correctly', () => {
+    const text = 'O CPF do suspeito é 123.456.789-09.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toContain('[CPF_0001]');
+    expect(tokenized).not.toContain('123.456.789-09');
+    const restored = namedRestore(tokenized, vault);
+    expect(restored).toContain('123.456.789-09');
+  });
+
+  it('multiple distinct CPFs get sequential tokens', () => {
+    const text = 'Autor: CPF 111.222.333-44. Vítima: CPF 555.666.777-88.';
+    const { tokenized } = namedTokenize(text);
+    expect(tokenized).toContain('[CPF_0001]');
+    expect(tokenized).toContain('[CPF_0002]');
+  });
+
+  it('same value repeated → same token (idempotent)', () => {
+    const text = 'CPF 123.456.789-09 e novamente CPF 123.456.789-09.';
+    const { tokenized } = namedTokenize(text);
+    const occurrences = (tokenized.match(/\[CPF_0001\]/g) ?? []).length;
+    expect(occurrences).toBe(2);
+    expect(tokenized).not.toContain('[CPF_0002]');
+  });
+
+  it('REDS gets [REDS_0001] token', () => {
+    const text = 'Registro REDS 2024-00123456789-001 autuado.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toContain('[REDS_0001]');
+    const restored = namedRestore(tokenized, vault);
+    expect(restored).toContain('2024-00123456789-001');
+  });
+
+  it('clean text returns unchanged tokenized', () => {
+    const text = 'Nenhum dado sensível aqui.';
+    const { tokenized, vault } = namedTokenize(text);
+    expect(tokenized).toBe(text);
+    expect(vault.count).toBe(0);
+  });
+});
+
+// ─── NER Rules A–J — structured name detection ────────────────────────────────
+
+describe('NER Rules A–J — name detection in police documents', () => {
+  it('Rule A — detects name after "Nome:"', () => {
+    const findings = applyNERRules('Nome: João Silva Santos');
+    expect(findings.some(f => f.matched.includes('João'))).toBe(true);
+  });
+
+  it('Rule B — detects name after honorific "Dr."', () => {
+    const findings = applyNERRules('Responsável: Dr. Carlos Alberto Lima');
+    expect(findings.some(f => f.matched.includes('Carlos'))).toBe(true);
+  });
+
+  it('Rule D — detects name after "Investigado:"', () => {
+    const findings = applyNERRules('Investigado: Pedro Henrique Costa');
+    expect(findings.some(f => f.matched.includes('Pedro'))).toBe(true);
+  });
+
+  it('Rule I — detects name after "Delegada:"', () => {
+    const findings = applyNERRules('Delegada: Ana Paula Ferreira assinou o BO.');
+    expect(findings.some(f => f.matched.includes('Ana'))).toBe(true);
+  });
+
+  it('does NOT flag CPF/REDS acronyms as ALL-CAPS names (Rule C stop list)', () => {
+    const findings = applyNERRules('CPF do autor: 123.456.789-09. REDS registrado.');
+    const false_positives = findings.filter(f => f.matched === 'CPF' || f.matched === 'REDS');
+    expect(false_positives).toHaveLength(0);
+  });
+});
+
+// ─── deduplicateFindings — longer match wins at same position ─────────────────
+
+describe('deduplicateFindings — custom pattern priority', () => {
+  it('longer match at same start position survives deduplication', () => {
+    // Two patterns that start at the same position; longer one should win
+    const text = 'BO 2024/001234 registrado.';
+    const findings = scanForPII(text);
+    // Should not produce two overlapping findings
+    for (let i = 0; i < findings.length - 1; i++) {
+      expect(findings[i].end).toBeLessThanOrEqual(findings[i + 1].start);
+    }
+  });
+});
diff --git a/packages/guard-brasil/src/index.ts b/packages/guard-brasil/src/index.ts
index e9a987c8..f6d3b634 100644
--- a/packages/guard-brasil/src/index.ts
+++ b/packages/guard-brasil/src/index.ts
@@ -51,6 +51,14 @@ export {
 } from './pii-patterns.js';
 export type { PIIPatternId, PatternConfidence, PIIPatternConfig, PIIMatch, MaskMode } from './pii-patterns.js';
 
-// Reversible tokenized redaction (EGOS-160)
+// Reversible tokenized redaction — opaque hashes (EGOS-160)
 export { tokenize, restore, hasTokens } from './lib/tokenizer.js';
 export type { TokenVault, TokenizedResult } from './lib/tokenizer.js';
+
+// Reversible tokenized redaction — readable named placeholders (DataVirtus-compatible)
+// Usage: namedTokenize(text) → [CPF_0001], [REDS_0001] → send to LLM → namedRestore(response, vault)
+export { namedTokenize, namedRestore } from './lib/tokenizer.js';
+export type { NamedTokenVault, NamedTokenizedResult } from './lib/tokenizer.js';
+
+// NER rules A–J: structured name detection for police/legal documents (MG context)
+export { applyNERRules, NER_RULES } from './lib/ner-rules.js';
diff --git a/packages/guard-brasil/src/lib/index.ts b/packages/guard-brasil/src/lib/index.ts
index 3a2f4add..8c77b035 100644
--- a/packages/guard-brasil/src/lib/index.ts
+++ b/packages/guard-brasil/src/lib/index.ts
@@ -17,3 +17,8 @@ export type { EvidenceChain, EvidenceItem, ClaimWithEvidence, EvidenceType, Conf
 
 export { buildAuditFields, canonicalRowJson, rawRowHash, sha256Text, sourceFingerprint } from './provenance.js';
 export type { AuditFields } from './provenance.js';
+
+export { applyNERRules, NER_RULES } from './ner-rules.js';
+
+export { namedTokenize, namedRestore } from './tokenizer.js';
+export type { NamedTokenVault, NamedTokenizedResult } from './tokenizer.js';
diff --git a/packages/guard-brasil/src/lib/pii-scanner.ts b/packages/guard-brasil/src/lib/pii-scanner.ts
index 9b341def..8b5b5665 100644
--- a/packages/guard-brasil/src/lib/pii-scanner.ts
+++ b/packages/guard-brasil/src/lib/pii-scanner.ts
@@ -2,6 +2,7 @@ import {
   ALL_PII_PATTERNS,
   type PIIPatternConfig,
 } from '../pii-patterns.js';
+import { applyNERRules } from './ner-rules.js';
 
 export type PIICategory = 'cpf' | 'rg' | 'masp' | 'phone' | 'email' | 'reds' | 'process_number' | 'name' | 'address' | 'plate' | 'date_of_birth' | 'cnpj' | 'cnh' | 'cep' | 'health_data';
 export interface PIIFinding { category: PIICategory; label: string; matched: string; start: number; end: number; suggestion: string; }
@@ -55,7 +56,7 @@ DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);
 const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
 const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);
 
-export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
+export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp; useNERRules?: boolean }): PIIFinding[] {
   const findings: PIIFinding[] = [];
   const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
   const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
@@ -70,6 +71,7 @@ export function scanForPII(text: string, options?: { patterns?: PIIPatternDefini
     const name = nameMatch[1];
     if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
   }
+  if (options?.useNERRules) findings.push(...applyNERRules(text));
   return deduplicateFindings(findings.sort((a, b) => a.start - b.start));
 }
 
@@ -85,8 +87,11 @@ export function getPIISummary(findings: PIIFinding[]): string {
 }
 
 function deduplicateFindings(findings: PIIFinding[]) {
+  // Sort: start ascending, then end descending — longer match at same position wins.
+  // This ensures custom/more-specific patterns beat shorter built-in matches at the same offset.
+  const sorted = [...findings].sort((a, b) => a.start !== b.start ? a.start - b.start : b.end - a.end);
   const result: PIIFinding[] = [];
   let lastEnd = -1;
-  for (const finding of findings) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
+  for (const finding of sorted) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
   return result;
 }
diff --git a/packages/guard-brasil/src/lib/tokenizer.ts b/packages/guard-brasil/src/lib/tokenizer.ts
index 69e451cc..25b77e2b 100644
--- a/packages/guard-brasil/src/lib/tokenizer.ts
+++ b/packages/guard-brasil/src/lib/tokenizer.ts
@@ -122,3 +122,107 @@ class TokenVault_ {
     return { tokens: new Map(), createdAt: new Date().toISOString(), count: 0 };
   }
 }
+
+// ─── Named (DataVirtus-style) Tokenization ────────────────────────────────────
+
+export interface NamedTokenVault {
+  /** token (e.g. "[CPF_0001]") → original value */
+  tokens: Map<string, string>;
+  /** original value → token (reverse index for idempotency) */
+  reverse: Map<string, string>;
+  createdAt: string;
+  count: number;
+}
+
+export interface NamedTokenizedResult {
+  /** Text with PII replaced by readable numbered placeholders */
+  tokenized: string;
+  /** Vault for restoration — keep in-memory, never log */
+  vault: NamedTokenVault;
+  /** Audit log — no original values */
+  findings: Array<{ token: string; category: string; label: string }>;
+}
+
+/**
+ * Readable reversible tokenization — DataVirtus-compatible format.
+ *
+ * Replaces each unique PII value with a numbered placeholder:
+ *   "123.456.789-09" → "[CPF_0001]"
+ *   "2024/001234"    → "[REDS_0001]"
+ *
+ * Same value always → same token (idempotent within a vault).
+ * The vault maps tokens back to originals for restoration.
+ *
+ * Compatible with the Datavirtus anonymizer workflow:
+ *   anon → send to LLM → restore with vault (offline, no API).
+ */
+export function namedTokenize(text: string): NamedTokenizedResult {
+  const findings = scanForPII(text);
+  const tokens = new Map<string, string>();
+  const reverse = new Map<string, string>();
+  const counters: Record<string, number> = {};
+  const auditLog: NamedTokenizedResult['findings'] = [];
+
+  if (findings.length === 0) {
+    return { tokenized: text, vault: { tokens, reverse, createdAt: new Date().toISOString(), count: 0 }, findings: [] };
+  }
+
+  const sorted = [...findings].sort((a, b) => b.start - a.start);
+  let tokenized = text;
+
+  for (const f of sorted) {
+    const original = text.slice(f.start, f.end);
+    if (reverse.has(original)) {
+      const existingToken = reverse.get(original)!;
+      tokenized = tokenized.slice(0, f.start) + existingToken + tokenized.slice(f.end);
+      continue;
+    }
+    const key = categoryToKey(f.category);
+    counters[key] = (counters[key] ?? 0) + 1;
+    const token = `[${key}_${String(counters[key]).padStart(4, '0')}]`;
+    tokens.set(token, original);
+    reverse.set(original, token);
+    tokenized = tokenized.slice(0, f.start) + token + tokenized.slice(f.end);
+    auditLog.push({ token, category: f.category, label: f.label });
+  }
+
+  return {
+    tokenized,
+    vault: { tokens, reverse, createdAt: new Date().toISOString(), count: tokens.size },
+    findings: auditLog,
+  };
+}
+
+/**
+ * Restore original values from a namedTokenize vault.
+ * Replaces all [KEY_NNNN] tokens with their original values.
+ */
+export function namedRestore(text: string, vault: NamedTokenVault): string {
+  let restored = text;
+  for (const [token, original] of vault.tokens) {
+    restored = restored.replaceAll(token, original);
+  }
+  return restored;
+}
+
+const CATEGORY_KEY_MAP: Record<string, string> = {
+  cpf: 'CPF',
+  cnpj: 'CNPJ',
+  rg: 'RG',
+  cnh: 'CNH',
+  masp: 'MASP',
+  reds: 'REDS',
+  process_number: 'IPL',
+  plate: 'PLACA',
+  phone: 'TEL',
+  email: 'EMAIL',
+  cep: 'CEP',
+  health_data: 'SAUDE',
+  name: 'NOME',
+  date_of_birth: 'NASC',
+  address: 'END',
+};
+
+function categoryToKey(category: string): string {
+  return CATEGORY_KEY_MAP[category] ?? category.toUpperCase().replace(/[^A-Z0-9]/g, '');
+}
diff --git a/scripts/banda.ts b/scripts/banda.ts
index 9d02940f..727d7485 100644
--- a/scripts/banda.ts
+++ b/scripts/banda.ts
@@ -17,7 +17,8 @@
  * Modes:
  *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
  *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
- *   council    — modelo diferente por papel via OpenRouter (~$1-3, max qualidade)
+ *   council    — GPT via Codex CLI + Claude via Claude CLI (subscriptions) +
+ *                Gemini 3.1 Pro via OpenRouter (~$0.03/council medido 2026-06-10)
  *
  * Output:
  *   - Console: síntese do Maestro (ou verbose com todos)
@@ -118,10 +119,10 @@ const MODELS: Record<string, ModelMap> = {
     maestro:    'anthropic/claude-haiku-4.5',
   },
   council: {
-    critic:     'openai/gpt-5.4',
-    supporter:  'anthropic/claude-sonnet-4.6',
-    questioner: 'google/gemini-2.5-pro',
-    maestro:    'anthropic/claude-opus-4.7',
+    critic:     'cli:codex:gpt-5.5',                 // Codex subscription (EGOS_CODEX_EFFORT=medium|high|xhigh)
+    supporter:  'cli:claude:sonnet',                 // Claude subscription
+    questioner: 'google/gemini-3.1-pro-preview',     // OpenRouter (~$0.03/council — testado 2026-06-10)
+    maestro:    'cli:claude:opus',                   // Claude subscription
   },
 };
 
@@ -263,12 +264,45 @@ decisao:
 Máx 350 palavras.`,
 };
 
-// ─── LLM call via OpenRouter ───────────────────────────────────────────────────
+// ─── LLM call: subscription CLIs (cli:*) ou OpenRouter ─────────────────────────
+// Corte Enio 2026-06-10: GPT via Codex subscription, Claude via Claude Code
+// subscription; só a perna Gemini (e fallbacks) paga OpenRouter (~$0.001-0.03).
+// Guarani/Antigravity FORA da banda (atribuições próprias).
+
+import { spawnSync } from 'node:child_process';
+
+function callCli(cmd: string, args: string[]): string {
+  const r = spawnSync(cmd, args, {
+    encoding: 'utf-8',
+    timeout: 300_000,
+    maxBuffer: 10 * 1024 * 1024,
+  });
+  if (r.error) throw new Error(`${cmd} spawn: ${r.error.message}`);
+  if (r.status !== 0) throw new Error(`${cmd} exit ${r.status}: ${(r.stderr || '').slice(0, 300)}`);
+  const out = (r.stdout || '').trim();
+  if (!out) throw new Error(`${cmd}: stdout vazio`);
+  return out;
+}
 
 async function callLLM(model: string, prompt: string): Promise<string> {
   if (DRY) {
     return `# DRY-RUN output for ${model}\nsimulated_response: ok\nwould_call_model: ${model}`;
   }
+  // cli:codex:<model> — Codex CLI (subscription). Effort via EGOS_CODEX_EFFORT
+  // (medium|high|xhigh; default medium). Prompt como arg posicional (padrão
+  // provado no pre-commit §codex).
+  if (model.startsWith('cli:codex:')) {
+    const m = model.slice('cli:codex:'.length);
+    const effort = process.env.EGOS_CODEX_EFFORT ?? 'medium';
+    return callCli('codex', [
+      'exec', '--model', m, '-c', `model_reasoning_effort="${effort}"`, prompt,
+    ]);
+  }
+  // cli:claude:<alias> — Claude Code CLI (subscription), print mode headless.
+  if (model.startsWith('cli:claude:')) {
+    const m = model.slice('cli:claude:'.length);
+    return callCli('claude', ['-p', '--model', m, prompt]);
+  }
   // Route deepseek/* to direct API when DEEPSEEK_API_KEY is available
   const isDeepseek = model.includes('deepseek');
   const deepseekKey = ENV.DEEPSEEK_API_KEY ?? '';

exec
/bin/bash -lc "sed -n '1,180p' packages/guard-brasil/src/lib/tokenizer.ts && sed -n '1,220p' packages/guard-brasil/src/lib/pii-scanner.ts && sed -n '1,220p' packages/guard-brasil/src/lib/ner-rules.ts && sed -n '1,380p' scripts/banda.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * TokenizedRedaction — Reversible PII masking for Guard Brasil.
 *
 * Instead of destructive replacement ([CPF REMOVIDO]), replaces PII
 * with stable tokens ([PII:a1b2c3d4]) backed by an in-memory vault.
 * The vault allows restoring original values after AI processing.
 *
 * Usage:
 *   const { tokenized, vault } = tokenize(rawText);
 *   const aiResponse = await callAI(tokenized);   // safe to send
 *   const restored = restore(aiResponse, vault);  // original values back
 *
 * Security notes:
 *   - Vault is in-memory only — never persist it without encryption.
 *   - Token format: [PII:CATEGORY:8hexchars] — opaque to LLMs.
 *   - Same matched value always produces the same token (idempotent).
 */

import { createHash, randomBytes } from "crypto";
import { scanForPII } from "./pii-scanner.js";
import type { PIIFinding } from "./pii-scanner.js";

export interface TokenVault {
  /** token → original value */
  tokens: Map<string, string>;
  /** Created timestamp (ISO 8601) */
  createdAt: string;
  /** Number of unique values redacted */
  count: number;
}

export interface TokenizedResult {
  /** Text with PII replaced by tokens */
  tokenized: string;
  /** Vault for restoration — keep this in-memory, never log it */
  vault: TokenVault;
  /** Findings for audit trail (no original values included) */
  findings: Array<{ token: string; category: string; label: string }>;
}

/**
 * Generate a deterministic token for a given value + session seed.
 * Using HMAC-style: hash(seed || value) — same value same session = same token.
 */
function makeToken(category: string, value: string, seed: string): string {
  const h = createHash("sha256")
    .update(seed)
    .update("|")
    .update(value)
    .digest("hex")
    .slice(0, 8);
  return `[PII:${category.toUpperCase()}:${h}]`;
}

/**
 * Tokenize PII in text. Returns tokenized text + vault needed for restoration.
 *
 * @param text   Input text that may contain PII
 * @param seed   Session seed for token generation (random per session by default)
 */
export function tokenize(text: string, seed?: string): TokenizedResult {
  const sessionSeed = seed ?? randomBytes(16).toString("hex");
  const findings = scanForPII(text);
  const vault = new TokenVault_();
  const result = { tokenized: text, vault: vault.toPlain(), findings: [] as TokenizedResult["findings"] };

  if (findings.length === 0) return result;

  // Sort by position descending so we can replace without shifting indices
  const sorted = [...findings].sort((a, b) => b.start - a.start);

  let tokenized = text;
  const vaultMap = new Map<string, string>();

  for (const f of sorted) {
    const original = text.slice(f.start, f.end);
    const token = makeToken(f.category, original, sessionSeed);
    vaultMap.set(token, original);
    tokenized = tokenized.slice(0, f.start) + token + tokenized.slice(f.end);
    result.findings.push({ token, category: f.category, label: f.label });
  }

  return {
    tokenized,
    vault: {
      tokens: vaultMap,
      createdAt: new Date().toISOString(),
      count: vaultMap.size,
    },
    findings: result.findings,
  };
}

/**
 * Restore original PII values from tokenized text using the vault.
 * Safe to call multiple times — non-destructive.
 *
 * @param text   Tokenized text (possibly with AI-modified surrounding text)
 * @param vault  The vault returned by tokenize()
 */
export function restore(text: string, vault: TokenVault): string {
  let restored = text;
  for (const [token, original] of vault.tokens) {
    restored = restored.replaceAll(token, original);
  }
  return restored;
}

/**
 * Check if text contains any vault tokens (useful before calling restore).
 */
export function hasTokens(text: string, vault: TokenVault): boolean {
  for (const token of vault.tokens.keys()) {
    if (text.includes(token)) return true;
  }
  return false;
}

// Internal helper (avoids referencing the exported interface before it exists)
class TokenVault_ {
  toPlain(): TokenVault {
    return { tokens: new Map(), createdAt: new Date().toISOString(), count: 0 };
  }
}

// ─── Named (DataVirtus-style) Tokenization ────────────────────────────────────

export interface NamedTokenVault {
  /** token (e.g. "[CPF_0001]") → original value */
  tokens: Map<string, string>;
  /** original value → token (reverse index for idempotency) */
  reverse: Map<string, string>;
  createdAt: string;
  count: number;
}

export interface NamedTokenizedResult {
  /** Text with PII replaced by readable numbered placeholders */
  tokenized: string;
  /** Vault for restoration — keep in-memory, never log */
  vault: NamedTokenVault;
  /** Audit log — no original values */
  findings: Array<{ token: string; category: string; label: string }>;
}

/**
 * Readable reversible tokenization — DataVirtus-compatible format.
 *
 * Replaces each unique PII value with a numbered placeholder:
 *   "123.456.789-09" → "[CPF_0001]"
 *   "2024/001234"    → "[REDS_0001]"
 *
 * Same value always → same token (idempotent within a vault).
 * The vault maps tokens back to originals for restoration.
 *
 * Compatible with the Datavirtus anonymizer workflow:
 *   anon → send to LLM → restore with vault (offline, no API).
 */
export function namedTokenize(text: string): NamedTokenizedResult {
  const findings = scanForPII(text);
  const tokens = new Map<string, string>();
  const reverse = new Map<string, string>();
  const counters: Record<string, number> = {};
  const auditLog: NamedTokenizedResult['findings'] = [];

  if (findings.length === 0) {
    return { tokenized: text, vault: { tokens, reverse, createdAt: new Date().toISOString(), count: 0 }, findings: [] };
  }

  const sorted = [...findings].sort((a, b) => b.start - a.start);
  let tokenized = text;

  for (const f of sorted) {
    const original = text.slice(f.start, f.end);
    if (reverse.has(original)) {
      const existingToken = reverse.get(original)!;
      tokenized = tokenized.slice(0, f.start) + existingToken + tokenized.slice(f.end);
      continue;
    }
    const key = categoryToKey(f.category);
import {
  ALL_PII_PATTERNS,
  type PIIPatternConfig,
} from '../pii-patterns.js';
import { applyNERRules } from './ner-rules.js';

export type PIICategory = 'cpf' | 'rg' | 'masp' | 'phone' | 'email' | 'reds' | 'process_number' | 'name' | 'address' | 'plate' | 'date_of_birth' | 'cnpj' | 'cnh' | 'cep' | 'health_data';
export interface PIIFinding { category: PIICategory; label: string; matched: string; start: number; end: number; suggestion: string; }
export interface PIIPatternDefinition { category: PIICategory; label: string; pattern: RegExp; suggestion: string; }

/**
 * Bridge from centralized PIIPatternConfig to legacy PIIPatternDefinition format.
 * Maps pii-patterns.ts IDs to the PIICategory values used by existing consumers.
 */
const PATTERN_ID_TO_CATEGORY: Record<string, PIICategory> = {
  cpf: 'cpf',
  cnpj: 'cnpj',
  rg: 'rg',
  cnh: 'cnh',
  masp: 'masp',
  reds: 'reds',
  processo: 'process_number',
  placa_antiga: 'plate',
  placa_mercosul: 'plate',
  telefone: 'phone',
  email: 'email',
  cep: 'cep',
  health_condition: 'health_data',
};

function toPIIPatternDefinition(config: PIIPatternConfig): PIIPatternDefinition {
  return {
    category: PATTERN_ID_TO_CATEGORY[config.id] ?? (config.id as PIICategory),
    label: config.label,
    pattern: config.regex,
    suggestion: config.maskFormat,
  };
}

/** Default PII patterns derived from the centralized pii-patterns.ts registry */
export const DEFAULT_PII_PATTERNS: PIIPatternDefinition[] = ALL_PII_PATTERNS.map(toPIIPatternDefinition);

/** Legacy date-of-birth pattern (kept for backward compatibility) */
const DATE_OF_BIRTH_PATTERN: PIIPatternDefinition = {
  category: 'date_of_birth',
  label: 'Data de Nascimento',
  pattern: /\b(?:nascido|nascimento|nasc\.?|DN|dn)[:\s]*\d{1,2}[\/.-]\d{1,2}[\/.-]\d{2,4}\b/gi,
  suggestion: '[DATA REMOVIDA]',
};

// Append date-of-birth (not yet in centralized patterns — context-dependent)
DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);

// Catches names preceded by role/title (law enforcement) OR explicit label fields (Nome:, Paciente:, etc.)
// Uses /g (not /gi) so character classes remain case-sensitive — prevents over-matching.
const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);

export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp; useNERRules?: boolean }): PIIFinding[] {
  const findings: PIIFinding[] = [];
  const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
  const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
  for (const { category, label, suggestion, pattern } of patterns) {
    const activePattern = clonePattern(pattern);
    let match: RegExpExecArray | null;
    while ((match = activePattern.exec(text)) !== null) findings.push({ category, label, matched: match[0], start: match.index, end: match.index + match[0].length, suggestion });
  }
  const namePattern = clonePattern(options?.namePattern ?? DEFAULT_NAME_PATTERN);
  let nameMatch: RegExpExecArray | null;
  while ((nameMatch = namePattern.exec(text)) !== null) {
    const name = nameMatch[1];
    if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
  }
  if (options?.useNERRules) findings.push(...applyNERRules(text));
  return deduplicateFindings(findings.sort((a, b) => a.start - b.start));
}

export function sanitizeText(text: string, findings: PIIFinding[]): string {
  let result = text;
  for (const finding of [...findings].sort((a, b) => b.start - a.start)) result = result.slice(0, finding.start) + finding.suggestion + result.slice(finding.end);
  return result;
}

export function getPIISummary(findings: PIIFinding[]): string {
  if (findings.length === 0) return 'Nenhum dado sensível detectado.';
  return `Detectamos ${findings.length} dado(s) sensível(is): ${[...new Set(findings.map((finding) => finding.label))].join(', ')}.`;
}

function deduplicateFindings(findings: PIIFinding[]) {
  // Sort: start ascending, then end descending — longer match at same position wins.
  // This ensures custom/more-specific patterns beat shorter built-in matches at the same offset.
  const sorted = [...findings].sort((a, b) => a.start !== b.start ? a.start - b.start : b.end - a.end);
  const result: PIIFinding[] = [];
  let lastEnd = -1;
  for (const finding of sorted) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
  return result;
}
/**
 * NER Rules for Guard Brasil — Brazilian police/legal document context (MG focus)
 *
 * 10 heuristic rules (A–J) for name detection in structured police documents.
 * Ported and expanded from Datavirtus anonymizer regras A–J (Python) to TypeScript.
 * All patterns are safe to clone (no lastIndex mutation) via clonePattern().
 *
 * Usage:
 *   import { NER_RULES, applyNERRules } from './ner-rules.js';
 *   const findings = applyNERRules(text);
 */

import type { PIIFinding } from './pii-scanner.js';

/** Capture group 1 = the name token in all patterns below */

const cloneRe = (re: RegExp) => new RegExp(re.source, re.flags.includes('g') ? re.flags : re.flags + 'g');

// A — Explicit field labels: "Nome:", "Nome Completo:", "Nome do Suspeito:", etc.
const RULE_A = /(?:[Nn]ome(?:\s+[Cc]ompleto)?|[Nn]ome\s+d[oa]\s+(?:[Ss]uspeito|[Ii]nvestigado|[Pp]aciente|[Cc]onduzido|[Vv][íi]tima|[Cc]liente|[Uu]su[aá]rio|[Rr]espons[aá]vel))\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})/g;

// B — Honorifics: "Sr.", "Sra.", "Dr.", "Dra.", "Prof.", "Del."
const RULE_B = /\b(?:Sr\.|Sra\.|Srta\.|Dr\.|Dra\.|Prof\.?|Profa\.?|Del\.|Esc\.|Ag\.)\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;

// C — ALL-CAPS proper names (common in police headers: "FULANO DE TAL")
// Min 2 words, max 5, at least 2 chars each, ignores common ALL-CAPS non-names
const NER_C_STOP = new Set(['CPF', 'RG', 'CNH', 'MASP', 'REDS', 'IPL', 'BO', 'CEP', 'SUS', 'NIS', 'PIS', 'TJMG', 'PCMG', 'CBMMG', 'DETRAN', 'SESP', 'SJSP', 'MG', 'SP', 'RJ', 'DF', 'BR', 'SA', 'ME', 'EPP', 'LTDA', 'SS']);
const RULE_C_RAW = /\b([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ]{2,}(?:\s+(?:D[AEO]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ]{2,}){1,4})\b/g;

// D — Party roles in police/court docs
const RULE_D = /\b(?:[Tt]estemunha|[Vv][íi]tima|[Cc]onduzido|[Pp]reso|[Aa]utuado|[Ii]nvestigado|[Aa]cusado|[Dd]enunciado|[Ii]ndiciado|[Qq]uerente|[Qq]uerido|[Aa]utor|[Rr][eé]u|[Rr][eé]|[Ee]nvolvido|[Ss]uspeito)\s*[:\-–]\s*([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;

// E — Signature blocks
const RULE_E = /(?:[Aa]ssinado\s+(?:por|digital(?:mente)?|eletronicamente)\s*:?\s*|[Aa]ssinatura\s*:?\s*|[Rr]espons[aá]vel\s+técnico\s*:?\s*)([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})/g;

// F — Kinship references: "filho de Fulano", "esposa de Fulana"
const RULE_F = /\b(?:[Ff]ilho|[Ff]ilha|[Cc][oô]njuge|[Ee]sposo|[Ee]sposa|[Gg]enitor|[Gg]enitora|[Nn]eto|[Nn]eta|[Ii]rm[aã]o?|[Pp]ai|[Mm][aã]e)\s+d[aeo]\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/gi;

// G — Names in parentheses after a role token
const RULE_G = /\b(?:delegad[oa]|escriv[aã]o?|comiss[aá]rio|perito|agente|servidor|investigador)\s+\(([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\)/g;

// H — Numbered/bulleted witness/party lists (multiline)
const RULE_H = /^[ \t]*(?:\d+[.\):]|-|\*|•)\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})[ \t]*$/gm;

// I — Police/law enforcement role prefixes (extends DEFAULT_NAME_PATTERN in pii-scanner)
const RULE_I = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comiss[aá]rio|perito|agente|policial|oficial|inspetor|subtenente|sargento|cabo|soldado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/gi;

// J — "Paciente", "Requerente", "Requerido", "Titular", "Interessado" label fields
const RULE_J = /\b(?:[Pp]aciente|[Cc]liente|[Rr]espons[aá]vel|[Rr]equerente|[Rr]equerido|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado|[Rr]epresentante\s+legal)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;

export const NER_RULES = [
  { id: 'ner:A', label: 'Nome (campo explícito)', pattern: RULE_A },
  { id: 'ner:B', label: 'Nome (honorífico)', pattern: RULE_B },
  { id: 'ner:D', label: 'Nome (papel processual)', pattern: RULE_D },
  { id: 'ner:E', label: 'Nome (assinatura)', pattern: RULE_E },
  { id: 'ner:F', label: 'Nome (parentesco)', pattern: RULE_F },
  { id: 'ner:G', label: 'Nome (parêntese após cargo)', pattern: RULE_G },
  { id: 'ner:H', label: 'Nome (lista numerada)', pattern: RULE_H },
  { id: 'ner:I', label: 'Nome (cargo policial)', pattern: RULE_I },
  { id: 'ner:J', label: 'Nome (campo de parte)', pattern: RULE_J },
] as const;

/** Apply NER rules A–J to text and return PIIFindings (category = 'name'). */
export function applyNERRules(text: string): PIIFinding[] {
  const findings: PIIFinding[] = [];

  for (const { id: _id, label, pattern } of NER_RULES) {
    const re = cloneRe(pattern);
    let m: RegExpExecArray | null;
    while ((m = re.exec(text)) !== null) {
      const name = m[1];
      if (!name || name.length < 4) continue;
      const nameStart = m.index + m[0].indexOf(name);
      findings.push({
        category: 'name',
        label,
        matched: name,
        start: nameStart,
        end: nameStart + name.length,
        suggestion: '[NOME REMOVIDO]',
      });
    }
  }

  // Rule C: ALL-CAPS sequences, filtered against known acronyms
  const reC = cloneRe(RULE_C_RAW);
  let mC: RegExpExecArray | null;
  while ((mC = reC.exec(text)) !== null) {
    const candidate = mC[1];
    const words = candidate.split(/\s+/);
    // Must have ≥2 words, none of which are known acronyms
    if (words.length < 2 || words.some(w => NER_C_STOP.has(w))) continue;
    findings.push({
      category: 'name',
      label: 'Nome (maiúsculas)',
      matched: candidate,
      start: mC.index,
      end: mC.index + candidate.length,
      suggestion: '[NOME REMOVIDO]',
    });
  }

  return findings;
}
#!/usr/bin/env bun
/**
 * OPUS-F4-001 — Banda Cognitiva executor (hierárquico sequencial)
 *
 * Protocolo (opção C aprovada):
 *   Crítico Extremo → Apoiador Máximo → Questionador → Maestro
 * Cada papel vê o output do anterior. Output final = síntese do Maestro.
 *
 * SSOT: docs/opus-mode/BANDA_COGNITIVA.md
 * Related: docs/opus-mode/OPUS_MODE_V1.md §4
 *
 * Usage:
 *   bun scripts/banda.ts --question "Devemos fazer X ou Y?" [--context "..."] [--mode economico|default|council]
 *   bun scripts/banda.ts --dry      # testa sem chamar LLMs
 *   bun scripts/banda.ts --verbose  # mostra os 4 outputs (default: só Maestro)
 *
 * Modes:
 *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
 *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
 *   council    — GPT via Codex CLI + Claude via Claude CLI (subscriptions) +
 *                Gemini 3.1 Pro via OpenRouter (~$0.03/council medido 2026-06-10)
 *
 * Output:
 *   - Console: síntese do Maestro (ou verbose com todos)
 *   - Arquivo: docs/banda/YYYY-MM-DD-<slug>.yaml (trace completo)
 */

export {};

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

// ─── Config ────────────────────────────────────────────────────────────────────

const ARGS = process.argv.slice(2);
const DRY = ARGS.includes('--dry');
const VERBOSE = ARGS.includes('--verbose');
const QUESTION = ARGS.find((_, i) => ARGS[i - 1] === '--question') ?? '';
const CONTEXT_ARG = ARGS.find((_, i) => ARGS[i - 1] === '--context') ?? '';
const MODE = (ARGS.find((_, i) => ARGS[i - 1] === '--mode') ?? 'default') as
  'default' | 'economico' | 'council';

if (!QUESTION && !DRY) {
  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--context-file <path>] [--mode default|economico|council] [--verbose] [--dry]');
  process.exit(1);
}

// ─── METAPROMPT GATE (METAPROMPT-GATE-001, corte Enio 2026-06-10) ─────────────
// A Banda só aceita comando que cumpra requisitos mínimos (MP-R1 contexto +
// MP-R2 objetivo verificável). Fail-closed: recusa apontando onde as regras
// vivem. SSOT: docs/governance/METAPROMPT_STANDARD.md
const CONTEXT_FILE = ARGS.find((_, i) => ARGS[i - 1] === '--context-file') ?? '';
const CONTEXT_FROM_FILE = CONTEXT_FILE && existsSync(CONTEXT_FILE)
  ? readFileSync(CONTEXT_FILE, 'utf-8')
  : '';
const EFFECTIVE_CONTEXT = CONTEXT_FROM_FILE || CONTEXT_ARG;
const MP_GATE_OVERRIDE = process.env.EGOS_MP_GATE_OVERRIDE === '1';

if (!DRY && !MP_GATE_OVERRIDE) {
  const missing: string[] = [];
  if (EFFECTIVE_CONTEXT.trim().length < 200) {
    missing.push('MP-R1 CONTEXTO (--context/--context-file com ≥200 chars: paths, SHAs, estado REAL/CONCEPT/PHANTOM)');
  }
  if (QUESTION.trim().length < 40) {
    missing.push('MP-R2 OBJETIVO (--question com pergunta + critério de aceite, ≥40 chars)');
  }
  if (missing.length > 0) {
    console.error('⛔ METAPROMPT INCOMPLETO — Banda não executada.');
    for (const m of missing) console.error(`   Falta: ${m}`);
    console.error('   Regras: docs/governance/METAPROMPT_STANDARD.md (EGOS kernel)');
    console.error('   Override consciente (logado): EGOS_MP_GATE_OVERRIDE=1');
    process.exit(2);
  }
}
if (MP_GATE_OVERRIDE && !DRY) {
  console.error('🟡 [banda] EGOS_MP_GATE_OVERRIDE=1 — gate de metaprompt pulado (humano assume).');
}

// Load env
function loadEnv(path: string): Record<string, string> {
  if (!existsSync(path)) return {};
  const env: Record<string, string> = {};
  for (const line of readFileSync(path, 'utf-8').split('\n')) {
    const m = line.match(/^(?:export\s+)?([A-Z_]+)=(.*)$/);
    if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, '');
  }
  return env;
}

// process.env vence, EXCETO quando a var existe vazia (shell herda placeholder
// vazio e sombreava o .env — bug pego 2026-06-10 na missão Odysseus)
const PROC_ENV = Object.fromEntries(
  Object.entries(process.env).filter(([, v]) => v !== undefined && v !== ''),
) as Record<string, string>;
const ENV = { ...loadEnv('/home/enio/egos/.env'), ...PROC_ENV } as Record<string, string>;
const OPENROUTER_KEY = ENV.OPENROUTER_API_KEY ?? '';
const ANTHROPIC_KEY = ENV.ANTHROPIC_API_KEY ?? '';

if (!DRY && !OPENROUTER_KEY) {
  console.error('[banda] OPENROUTER_API_KEY missing in .env');
  process.exit(2);
}

// ─── Model mapping per mode ────────────────────────────────────────────────────

interface ModelMap { critic: string; supporter: string; questioner: string; maestro: string }

const MODELS: Record<string, ModelMap> = {
  default: {
    critic:     'anthropic/claude-sonnet-4.6',
    supporter:  'anthropic/claude-sonnet-4.6',
    questioner: 'anthropic/claude-sonnet-4.6',
    maestro:    'anthropic/claude-sonnet-4.6',
  },
  economico: {
    critic:     'anthropic/claude-haiku-4.5',
    supporter:  'anthropic/claude-haiku-4.5',
    questioner: 'anthropic/claude-haiku-4.5',
    maestro:    'anthropic/claude-haiku-4.5',
  },
  council: {
    critic:     'cli:codex:gpt-5.5',                 // Codex subscription (EGOS_CODEX_EFFORT=medium|high|xhigh)
    supporter:  'cli:claude:sonnet',                 // Claude subscription
    questioner: 'google/gemini-3.1-pro-preview',     // OpenRouter (~$0.03/council — testado 2026-06-10)
    maestro:    'cli:claude:opus',                   // Claude subscription
  },
};

// ─── Prompts por papel ─────────────────────────────────────────────────────────

const PROMPTS = {
  critic: (q: string, ctx: string) => `Você é o **Crítico Extremo** de uma Banda Cognitiva EGOS.

Postura: adversarial construtivo. Não está tentando ser legal. Aponte riscos reais.

Perguntas obrigatórias:
- O que pode dar errado nesta decisão?
- Existe risco de segurança ou privacidade?
- Cria dependência frágil? De qual lado?
- Risco de alucinação ou falsa confiança?
- Duplicamos algo que já existe?
- Pode quebrar deploy, dados ou fluxo de trabalho?
- Qual o pior cenário em 30/90/365 dias?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

Responda em YAML válido:
\`\`\`yaml
critico:
  riscos: [<lista priorizada — maior risco primeiro>]
  pior_cenario: <descrição concreta>
  duplicacoes_detectadas: [<se houver>]
  dependencias_frageis: [<lista>]
  recomendacao: ABORTAR | MITIGAR | SEGUIR_COM_RESSALVAS
  ressalvas: [<se aplicável>]
\`\`\`

Seja conciso. Máx 400 palavras no YAML.`,

  supporter: (q: string, ctx: string, criticOutput: string) => `Você é o **Apoiador Máximo** de uma Banda Cognitiva EGOS.

Postura: maximize o potencial. Não ignora a crítica — responde a ela construtivamente.

Perguntas obrigatórias:
- Qual o maior potencial desta ideia?
- Como as falhas apontadas pelo Crítico viram features?
- Como aproveitar o que já existe no EGOS?
- Como vira regra, ferramenta ou fluxo reusável?
- Que efeito de rede isso pode criar?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:
${criticOutput}

Responda em YAML válido:
\`\`\`yaml
apoiador:
  potencial_maximo: <descrição>
  falhas_do_critico_respondidas:
    - falha: <do crítico>
      resposta: <como vira feature>
  reuso_egos: [<o que já existe que se conecta>]
  efeito_rede: <se houver>
  recomendacao: AMPLIFICAR | EXECUTAR | REFINAR_PRIMEIRO
\`\`\`

Máx 400 palavras.`,

  questioner: (q: string, ctx: string, criticOutput: string, supporterOutput: string) => `Você é o **Questionador** de uma Banda Cognitiva EGOS.

Postura: socrático. Não defende nenhum lado — questiona as premissas.

Perguntas obrigatórias:
- Por que fazer assim?
- Existe caminho mais simples que resolve 80%?
- O objetivo está claro ou estamos em fuga?
- Estamos resolvendo causa ou sintoma?
- Respeita ética, autonomia e governança?
- O que está implícito que precisamos explicitar?
- Que pergunta ninguém fez ainda?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:
${criticOutput}

OUTPUT DO APOIADOR:
${supporterOutput}

Responda em YAML válido:
\`\`\`yaml
questionador:
  premissas_implicitas: [<lista>]
  caminho_mais_simples: <se existir>
  causa_vs_sintoma: <análise>
  questoes_nao_feitas: [<lista>]
  alinhamento_egos: OK | TENSAO | CONTRADICAO
  reformulacao_sugerida: <se houver>
\`\`\`

Máx 400 palavras.`,

  maestro: (q: string, ctx: string, c: string, a: string, qs: string) => `Você é o **Maestro** de uma Banda Cognitiva EGOS.

Postura: executivo. Lê os 3 outputs anteriores e destila uma decisão concreta.

Não defende nenhum papel — sintetiza.

QUESTÃO ORIGINAL: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:
${c}

OUTPUT DO APOIADOR:
${a}

OUTPUT DO QUESTIONADOR:
${qs}

Responda APENAS em YAML válido:
\`\`\`yaml
decisao:
  contexto: <1 frase do que estamos decidindo>
  critica_principal: <1 linha>
  potencial_principal: <1 linha>
  duvida_principal: <1 linha>
  acao_escolhida: <concreta + estimativa de tempo>
  acao_rejeitada: <o que NÃO fazer e por quê>
  ressalvas_aplicadas: [<do Crítico, se MITIGAR>]
  proximo_passo: <executável imediatamente>
  prioridade: 1 | 2 | 3 | 5 | 8
  gate_decisao: <quem aprova antes de executar, ex: "Enio" ou "auto">
\`\`\`

Máx 350 palavras.`,
};

// ─── LLM call: subscription CLIs (cli:*) ou OpenRouter ─────────────────────────
// Corte Enio 2026-06-10: GPT via Codex subscription, Claude via Claude Code
// subscription; só a perna Gemini (e fallbacks) paga OpenRouter (~$0.001-0.03).
// Guarani/Antigravity FORA da banda (atribuições próprias).

import { spawnSync } from 'node:child_process';

function callCli(cmd: string, args: string[]): string {
  const r = spawnSync(cmd, args, {
    encoding: 'utf-8',
    timeout: 300_000,
    maxBuffer: 10 * 1024 * 1024,
  });
  if (r.error) throw new Error(`${cmd} spawn: ${r.error.message}`);
  if (r.status !== 0) throw new Error(`${cmd} exit ${r.status}: ${(r.stderr || '').slice(0, 300)}`);
  const out = (r.stdout || '').trim();
  if (!out) throw new Error(`${cmd}: stdout vazio`);
  return out;
}

async function callLLM(model: string, prompt: string): Promise<string> {
  if (DRY) {
    return `# DRY-RUN output for ${model}\nsimulated_response: ok\nwould_call_model: ${model}`;
  }
  // cli:codex:<model> — Codex CLI (subscription). Effort via EGOS_CODEX_EFFORT
  // (medium|high|xhigh; default medium). Prompt como arg posicional (padrão
  // provado no pre-commit §codex).
  if (model.startsWith('cli:codex:')) {
    const m = model.slice('cli:codex:'.length);
    const effort = process.env.EGOS_CODEX_EFFORT ?? 'medium';
    return callCli('codex', [
      'exec', '--model', m, '-c', `model_reasoning_effort="${effort}"`, prompt,
    ]);
  }
  // cli:claude:<alias> — Claude Code CLI (subscription), print mode headless.
  if (model.startsWith('cli:claude:')) {
    const m = model.slice('cli:claude:'.length);
    return callCli('claude', ['-p', '--model', m, prompt]);
  }
  // Route deepseek/* to direct API when DEEPSEEK_API_KEY is available
  const isDeepseek = model.includes('deepseek');
  const deepseekKey = ENV.DEEPSEEK_API_KEY ?? '';
  const apiUrl = (isDeepseek && deepseekKey)
    ? 'https://api.deepseek.com/v1/chat/completions'
    : 'https://openrouter.ai/api/v1/chat/completions';
  const apiKey = (isDeepseek && deepseekKey) ? deepseekKey : OPENROUTER_KEY;
  // Normalize model name for DeepSeek direct API
  const modelId = (isDeepseek && deepseekKey)
    ? model.replace('deepseek/', '').replace('-flash', '-chat').replace('-pro', '-reasoner').replace('v4-flash','chat').replace('v4-pro','reasoner')
    : model;

  const r = await fetch(apiUrl, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://github.com/enioxt/egos',
      'X-Title': 'EGOS Banda Cognitiva',
    },
    body: JSON.stringify({
      model,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.3,
      max_tokens: 2000,
    }),
    signal: AbortSignal.timeout(90_000),
  });
  if (!r.ok) {
    const txt = await r.text();
    throw new Error(`LLM ${model} failed ${r.status}: ${txt.slice(0, 300)}`);
  }
  const data = await r.json() as { choices?: Array<{ message?: { content?: string } }> };
  return data.choices?.[0]?.message?.content ?? '';
}

// ─── Helpers ───────────────────────────────────────────────────────────────────

function slugify(text: string): string {
  return text.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 50);
}

function extractYaml(response: string): string {
  const m = response.match(/```ya?ml\n([\s\S]*?)```/);
  return m ? m[1].trim() : response.trim();
}

// ─── Main ──────────────────────────────────────────────────────────────────────

async function main() {
  const models = MODELS[MODE];
  const startTs = Date.now();
  const slug = slugify(QUESTION || 'dry-run');
  const today = new Date().toISOString().split('T')[0];

  console.log(`[banda] MODE=${MODE} | Question: "${QUESTION.slice(0, 80)}${QUESTION.length > 80 ? '...' : ''}"`);
  console.log(`[banda] Models: critic=${models.critic.split('/').pop()} | supporter=${models.supporter.split('/').pop()} | questioner=${models.questioner.split('/').pop()} | maestro=${models.maestro.split('/').pop()}`);
  console.log('');

  let context = EFFECTIVE_CONTEXT;
  // Se context começa com @, ler arquivo (legado; preferir --context-file)
  if (context.startsWith('@')) {
    const path = context.slice(1);
    context = existsSync(path) ? readFileSync(path, 'utf-8').slice(0, 10000) : '';
  }
  context = context.slice(0, 12000);

  // Phase 1 — Crítico
  process.stdout.write('[1/4] Crítico Extremo... ');
  const criticRaw = await callLLM(models.critic, PROMPTS.critic(QUESTION, context));
  const critic = extractYaml(criticRaw);
  console.log('✓');

exec
/bin/bash -lc "sed -n '180,260p' packages/guard-brasil/src/lib/tokenizer.ts && sed -n '380,520p' scripts/banda.ts" in /home/enio/egos
 succeeded in 0ms:
    const key = categoryToKey(f.category);
    counters[key] = (counters[key] ?? 0) + 1;
    const token = `[${key}_${String(counters[key]).padStart(4, '0')}]`;
    tokens.set(token, original);
    reverse.set(original, token);
    tokenized = tokenized.slice(0, f.start) + token + tokenized.slice(f.end);
    auditLog.push({ token, category: f.category, label: f.label });
  }

  return {
    tokenized,
    vault: { tokens, reverse, createdAt: new Date().toISOString(), count: tokens.size },
    findings: auditLog,
  };
}

/**
 * Restore original values from a namedTokenize vault.
 * Replaces all [KEY_NNNN] tokens with their original values.
 */
export function namedRestore(text: string, vault: NamedTokenVault): string {
  let restored = text;
  for (const [token, original] of vault.tokens) {
    restored = restored.replaceAll(token, original);
  }
  return restored;
}

const CATEGORY_KEY_MAP: Record<string, string> = {
  cpf: 'CPF',
  cnpj: 'CNPJ',
  rg: 'RG',
  cnh: 'CNH',
  masp: 'MASP',
  reds: 'REDS',
  process_number: 'IPL',
  plate: 'PLACA',
  phone: 'TEL',
  email: 'EMAIL',
  cep: 'CEP',
  health_data: 'SAUDE',
  name: 'NOME',
  date_of_birth: 'NASC',
  address: 'END',
};

function categoryToKey(category: string): string {
  return CATEGORY_KEY_MAP[category] ?? category.toUpperCase().replace(/[^A-Z0-9]/g, '');
}
  console.log('✓');

  // Phase 2 — Apoiador
  process.stdout.write('[2/4] Apoiador Máximo... ');
  const supporterRaw = await callLLM(models.supporter, PROMPTS.supporter(QUESTION, context, critic));
  const supporter = extractYaml(supporterRaw);
  console.log('✓');

  // Phase 3 — Questionador
  process.stdout.write('[3/4] Questionador... ');
  const questionerRaw = await callLLM(models.questioner, PROMPTS.questioner(QUESTION, context, critic, supporter));
  const questioner = extractYaml(questionerRaw);
  console.log('✓');

  // Phase 4 — Maestro
  process.stdout.write('[4/4] Maestro (síntese)... ');
  const maestroRaw = await callLLM(models.maestro, PROMPTS.maestro(QUESTION, context, critic, supporter, questioner));
  const maestro = extractYaml(maestroRaw);
  console.log('✓');

  const elapsed = Math.round((Date.now() - startTs) / 1000);

  // Output
  console.log('');
  if (VERBOSE) {
    console.log('─── CRÍTICO ─────────────────────────────');
    console.log(critic);
    console.log('\n─── APOIADOR ────────────────────────────');
    console.log(supporter);
    console.log('\n─── QUESTIONADOR ────────────────────────');
    console.log(questioner);
    console.log('\n─── MAESTRO (síntese) ───────────────────');
  }
  console.log(maestro);
  console.log('');
  console.log(`[banda] ${elapsed}s | Mode: ${MODE}`);

  // Save trace (YAML)
  const dir = '/home/enio/egos/docs/banda';
  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
  const outPath = join(dir, `${today}-${slug}.yaml`);
  const trace = `# Banda Cognitiva — ${today}
id: ${today}-${slug}
mode: ${MODE}
question: |
  ${QUESTION.split('\n').map(l => '  ' + l).join('\n').trim()}
context_provided: ${context.length > 0}
duration_seconds: ${elapsed}
models:
  critic: ${models.critic}
  supporter: ${models.supporter}
  questioner: ${models.questioner}
  maestro: ${models.maestro}

---
# Phase 1 — Crítico
${critic}

---
# Phase 2 — Apoiador
${supporter}

---
# Phase 3 — Questionador
${questioner}

---
# Phase 4 — Maestro (FINAL SYNTHESIS)
${maestro}

# Sacred Code: 000.111.369.963.1618
`;
  writeFileSync(outPath, trace);
  console.log(`[banda] Trace saved: ${outPath}`);
}

main().catch(e => {
  console.error('[banda] FAIL:', e.message);
  process.exit(3);
});

exec
/bin/bash -lc 'bun test packages/guard-brasil/src/guard.test.ts' in /home/enio/egos
 succeeded in 0ms:
bun test v1.3.9 (cf6cdbbb)

 57 pass
 0 fail
 122 expect() calls
Ran 57 tests across 1 file. [63.00ms]

exec
/bin/bash -lc 'bunx tsc -p packages/guard-brasil/tsconfig.json --noEmit' in /home/enio/egos
 succeeded in 1166ms:
exec
/bin/bash -lc "grep -R \"namedTokenize\\|namedRestore\\|DataVirtus\" -n . --exclude-dir=.git --exclude=tsconfig.tsbuildinfo | head -50" in /home/enio/egos
exec
/bin/bash -lc "git grep -n \"namedTokenize\\|namedRestore\\|DataVirtus\"" in /home/enio/egos
 succeeded in 0ms:
TASKS.md:497:- [ ] **COURSE-INTEL-001** [P1] `hermes` 🆕 (Enio 2026-06-02) — Capability `course-market-scan` no Hermes/VPS: pesquisa contínua (semanal) do surgimento de cursos/áreas/players nas maiores plataformas, lente no espaço-branco do Enio (arquitetar+governar IA com IDE-nativo + governança + ética, ctx forense/lei). Reusa gem-hunter (descoberta) + keyword-temas (termos). Ruleset: `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (v1.0, escrito). **Gap confirmado:** DataVirtus/WB ensinam USAR IA; ninguém ensina ARQUITETAR/GOVERNAR. **Corte Banda:** inteligência-de-posicionamento p/ entrar em equipes, NÃO fábrica-de-curso. Build = sessão dedicada. Liga [[project_course_market_gap_research_capability]].
docs/_current_handoffs/PRIME_TO_GUARANI_2026-06-03_irb-premortem.md:11:Sistema **IRB** (Investigation Report Builder) — análise financeira investigativa rodando **100% LOCAL** no intelink (Postgres dedicado `127.0.0.1:54399`), uso **policial PCMG** (Red Zone, sigilo bancário/fiscal/LGPD). Ingere extrato/RIF/CCS/cadastro, cruza por CPF/CNPJ, gera **LEADS (não prova)** com SHA-256 apontando para a fonte. Caso de teste: DataVirtus 077 (dados sintéticos).
docs/_current_handoffs/_merge_2026-06-02/egos__main__a234c2a2.md:18:- **MODELO DE CURSO desbloqueado:** "Construa e Governe a SUA IA" — diferencial = **co-criar regras/ferramentas COM cada aluno** (1:1/grupo/turma), não vender "use IA". Gap confirmado vs DataVirtus/WB (eles ensinam USAR; ninguém ensina ARQUITETAR/GOVERNAR). SSOT: `docs/strategy/COURSE_PROGRAM_DESIGN.md` + [[project_course_market_gap_research_capability]].
docs/metaprompts/MP-RESEARCH-001.md:125:HIPOTESES      : Nenhum curso ensina governanca + IDE-nativo juntos; DataVirtus/WB cobrem uso
docs/roadmap/public-roadmap.md:70:- **Pesquisa de mercado** — `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (DataVirtus/WB mapeados, gap identificado)
docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:4:> **Origem:** Enio mostrou DataVirtus + WB Educação ("ver o que já existe, o que falta no mercado") e pediu: *"devemos ter essas regras para sempre pesquisar usando o conjunto de regras, deve estar dentro de um de nossos agentes (Hermes/VPS) — pesquisar e ir entendendo o surgimento de cursos, de áreas, focando no nosso."*
docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:16:- **USAR IA** (ChatGPT/Gemma local, prompts) → mercado lotado (DataVirtus, WB).
docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:23:| BR nicho forense/lei | DataVirtus (themembers), WB Educação (eveclass), Academia de Forense Digital, IDESP/escolas de polícia |
docs/strategy/COURSE_PROGRAM_DESIGN.md:14:- DataVirtus/WB ensinam *usar* (ChatGPT p/ policiais, Gemma local) ou *investigar/atacar*. **Ninguém co-cria governança/ferramentas COM o aluno.**
docs/strategy/COURSE_PROGRAM_DESIGN.md:51:| **Aula inaugural grátis** | baixo (funil) | público amplo (como DataVirtus/WB) |
docs/strategy/COURSE_PROGRAM_DESIGN.md:68:- **Posição vs players** (não atacar DataVirtus/WB; ocupar o degrau acima = arquitetura/governança).
packages/guard-brasil/src/guard.test.ts:10:import { namedTokenize, namedRestore } from './lib/tokenizer.js';
packages/guard-brasil/src/guard.test.ts:431:// ─── namedTokenize — DataVirtus-compatible reversible redaction ───────────────
packages/guard-brasil/src/guard.test.ts:433:describe('namedTokenize — readable placeholders', () => {
packages/guard-brasil/src/guard.test.ts:438:    const { tokenized, vault } = namedTokenize(text);
packages/guard-brasil/src/guard.test.ts:441:    const restored = namedRestore(tokenized, vault);
packages/guard-brasil/src/guard.test.ts:450:    const { tokenized } = namedTokenize(text);
packages/guard-brasil/src/guard.test.ts:458:    const { tokenized } = namedTokenize(text);
packages/guard-brasil/src/guard.test.ts:466:    const { tokenized, vault } = namedTokenize(text);
packages/guard-brasil/src/guard.test.ts:468:    const restored = namedRestore(tokenized, vault);
packages/guard-brasil/src/guard.test.ts:474:    const { tokenized, vault } = namedTokenize(text);
packages/guard-brasil/src/index.ts:58:// Reversible tokenized redaction — readable named placeholders (DataVirtus-compatible)
packages/guard-brasil/src/index.ts:59:// Usage: namedTokenize(text) → [CPF_0001], [REDS_0001] → send to LLM → namedRestore(response, vault)
packages/guard-brasil/src/index.ts:60:export { namedTokenize, namedRestore } from './lib/tokenizer.js';
packages/guard-brasil/src/lib/index.ts:23:export { namedTokenize, namedRestore } from './tokenizer.js';
packages/guard-brasil/src/lib/tokenizer.ts:126:// ─── Named (DataVirtus-style) Tokenization ────────────────────────────────────
packages/guard-brasil/src/lib/tokenizer.ts:147: * Readable reversible tokenization — DataVirtus-compatible format.
packages/guard-brasil/src/lib/tokenizer.ts:159:export function namedTokenize(text: string): NamedTokenizedResult {
packages/guard-brasil/src/lib/tokenizer.ts:197: * Restore original values from a namedTokenize vault.
packages/guard-brasil/src/lib/tokenizer.ts:200:export function namedRestore(text: string, vault: NamedTokenVault): string {

2026-06-10T17:44:31.407951Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
exec
/bin/bash -lc 'codex exec --help | head -80 || true; claude -p --help | head -40 || true' in /home/enio/egos
 succeeded in 592ms:
Usage: claude [options] [prompt]

Claude Code - starts an interactive session by default, use -p/--print for
non-interactive output

Arguments:
  prompt                                Your prompt

Options:
  --add-dir <directories...>            Additional directories to allow tool
                                        access to
  --agent <agent>                       Agent for the current session. Overrides
                                        the 'agent' setting.
  --agents <json>                       JSON object defining custom agents (e.g.
                                        '{"reviewer": {"description": "Reviews
                                        code", "prompt": "You are a code
                                        reviewer"}}')
  --allow-dangerously-skip-permissions  Enable bypassing all permission checks
                                        as an option, without it being enabled
                                        by default. Recommended only for
                                        sandboxes with no internet access.
  --allowedTools, --allowed-tools <tools...>
      Comma or space-separated list of tool names to allow (e.g. "Bash(git *)
      Edit")
  --append-system-prompt <prompt>       Append a system prompt to the default
                                        system prompt
  --bare                                Minimal mode: skip hooks, LSP, plugin
                                        sync, attribution, auto-memory,
                                        background prefetches, keychain reads,
                                        and CLAUDE.md auto-discovery. Sets
                                        CLAUDE_CODE_SIMPLE=1. Anthropic auth is
                                        strictly ANTHROPIC_API_KEY or
                                        apiKeyHelper via --settings (OAuth and
                                        keychain are never read). 3P providers
                                        (Bedrock/Vertex/Foundry) use their own
                                        credentials. Skills still resolve via
                                        /skill-name. Explicitly provide context
                                        via: --system-prompt[-file],
                                        --append-system-prompt[-file], --add-dir
                                        (CLAUDE.md dirs), --mcp-config,

exec
/bin/bash -lc "jq empty docs/jobs/2026-06-10-doc-drift-verifier.json docs/jobs/2026-06-10-pre-commit-pipeline.json && python - <<'PY'
import yaml,sys
for f in ['docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml']:
    try:
        list(yaml.safe_load_all(open(f)))
        print('ok',f)
    except Exception as e: print('bad',f,e)
PY" in /home/enio/egos
 succeeded in 0ms:
bad docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml while scanning for the next token
found character '`' that cannot start any token
  in "docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml", line 100, column 1

exec
/bin/bash -lc "git grep -n \"docs/banda\\|banda/.*yaml\\|Banda Cognitiva\" -- scripts docs packages apps | head -100" in /home/enio/egos
 succeeded in 0ms:
apps/egos-hq/app/api/hq/banda/route.ts:26:    system: `Você é o CRÍTICO EXTREMO da Banda Cognitiva. Instrumento: contrabaixo — você marca o que está errado, incompleto ou frágil. Seja implacável mas construtivo. Procure: premissas não verificadas, riscos ignorados, falhas de raciocínio, pontos cegos do argumento. Responda em 3-5 bullet points curtos e diretos. Formato: cada linha começa com ⚠️. Sem elogios — apenas problemas reais.`,
apps/egos-hq/app/api/hq/banda/route.ts:33:    system: `Você é o APOIADOR MÁXIMO da Banda Cognitiva. Instrumento: trompete — você ilumina o que é genuinamente bom e por quê. Sem bajulação: aponte forças reais, momentos de insight, potencial subestimado. Responda em 3-5 bullet points. Formato: cada linha começa com ✨. Inclua: o que funciona bem, por que é sólido, o que deve ser preservado.`,
apps/egos-hq/app/api/hq/banda/route.ts:40:    system: `Você é o QUESTIONADOR da Banda Cognitiva. Instrumento: piano — você cria tensão harmônica com perguntas que ninguém ainda fez. Não responda: pergunte. As perguntas devem revelar dimensões não exploradas, assumir o que poderia ser diferente, questionar o frame da própria pergunta. Formato: 3-5 perguntas abertas, cada uma começando com ❓. Perguntas devem ser específicas e desconfortáveis.`,
apps/egos-hq/app/api/hq/banda/route.ts:47:    system: `Você é o MAESTRO da Banda Cognitiva. Instrumento: bateria — você conduz o tempo e sintetiza o que os três músicos anteriores tocaram. Você leu: a crítica, o apoio e as perguntas. Sintetize em uma resposta coesa: o que é verdadeiro em cada visão, como reconciliar as tensões, qual a recomendação final clara. Formato: 1 parágrafo de síntese + 1 "Próximo passo concreto:" com ação específica. Comece com 🎯.`,
apps/egos-hq/app/api/hq/banda/route.ts:85:              'X-Title': 'EGOS Banda Cognitiva',
apps/egos-hq/app/api/internal/discover/route.ts:11:  description: 'Personal dashboard chatbot for the EGOS ecosystem. Access: system health, KB pessoal (Gmail/Drive/Calendar), Banda Cognitiva, agent events, transparency.',
apps/egos-hq/app/banda/page.tsx:465:            🎵 Banda Cognitiva
apps/egos-hq/app/banda/page.tsx:610:          <span style={{ marginLeft: 'auto', fontFamily: FONT_MONO }}>Banda Cognitiva v1 · Jazz Quartet</span>
apps/egos-hq/app/page.tsx:535:    { id: 'nav:/banda', label: '🎵 Banda Cognitiva', sub: 'Jazz Quartet — 4 papéis, 1 questão', action: () => { window.location.href = '/banda'; } },
docs/_archived_handoffs/2026-04/handoff_2026-04-24c.md:53:- `scripts/banda.ts` (Banda Cognitiva hierárquica, testado 41s)
docs/_archived_handoffs/2026-04/handoff_2026-04-24c.md:157:- **OPUS MODE** = protocolo de governança de agentes (anti-alucinação, Banda Cognitiva, Council)
docs/_archived_handoffs/2026-04/handoff_2026-04-28.md:32:| `b24ce43` | Banda Cognitiva v2 — master chain, FMSynth/AMSynth, swing jazz, reverb bus, 4 estilos |
docs/_archived_handoffs/2026-04/handoff_2026-04-28.md:49:### Banda Cognitiva (`hq.egos.ia.br/banda`)
docs/_archived_handoffs/2026-04/handoff_2026-04-28.md:95:- Banda Cognitiva (`apps/egos-hq/app/banda/`)
docs/_archived_handoffs/2026-05/handoff_2026-05-28-egos-public.md:50:8. Fase 10 (EGOS-PUB-010) — Banda Cognitiva + Quorum externo (Opus)
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:7:- docs/drafts/council1.md (1739L) — Banda Cognitiva multi-LLM já processou o meta-prompt EPOS
docs/_current_handoffs/FOR_PRIME_Guarani_2026-06-10.md:22:3. Invoque a **Banda Cognitiva (`/banda --council`)** + review do Codex para avaliar as duas propostas acima.
docs/_current_handoffs/FOR_PRIME_Odysseus_MetaPrompt.md:15:3. Inicie a `/banda` (Banda Cognitiva) com o Fable (Claude 3.5 Sonnet) para dissecar essas opções e gerar o `docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md`, além de um roadmap de PRs para o repositório deles (`ODYSSEUS_PR_ROADMAP.md`).
docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_hermes-desktop-dashboard-avatars.md:3:> **Status:** Plano Arquitetado via Banda Cognitiva — Pronto para Implementação / Complementação
docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_hermes-desktop-dashboard-avatars.md:12:## 🧠 §1 — Banda Cognitiva (Análise Hierárquica de 4 Papéis)
docs/agents/CYCLE.md:26:| **2 THINK** | Sintetizar contexto → identificar highest-leverage | OPUS MODE Banda Cognitiva | `bun scripts/banda.ts` (opcional) | síntese Maestro: o que fazer + por quê |
docs/ai-architecture/egos-agent-capabilities.md:42:*   **Banda Cognitiva (`/banda`):** Revisão hierárquica por papéis (Crítico → Apoiador → Questionador → Maestro) para decisões de design.
docs/ai-architecture/egos-agent-capabilities.md:79:*   **Identidade:** Constitutional Guardian / Auditor de Coerência (Crítico da Banda Cognitiva).
docs/audits/2026-05-29-advocacia-rules-classification.md:22:| 8 | `🎚️ REGRA #6 — BANDA COGNITIVA ANTES DE IRREVERSÍVEIS` (L124-139) | **GERAL (duplicação textual)** | `egos/CLAUDE.md:13` (OPUS MODE princípio 3 "Banda Cognitiva antes de decisões importantes → `bun scripts/banda.ts`"); `egos/CLAUDE.md:24` (Commands `/banda`); skill `banda` declarada globalmente. Template apenas re-explica em linguagem leiga ("apagar/mover arquivo, renomear pastas, gerar peça, escrever email"). | **Mover para L0** e substituir por `inherits: [egos/CLAUDE.md §OPUS MODE princípio 3, skill: banda]`. Manter SÓ os exemplos jurídicos (gerar peça/email cliente). **Remove ~10 linhas.** |
docs/audits/2026-05-29-advocacia-rules-classification.md:36:| **GERAL (duplicação direta com kernel)** | **2** (§6 Karpathy, §8 Banda Cognitiva) |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:323:| `docs/banda/` | 0 | Empty (0 .md files per count). No content. | DELETE empty folder |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:426:- `docs/banda/` — 0 .md files (empty)
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:454:| 12 | **DELETE** empty folders | `docs/banda/`, `docs/world-model/` | Zero content; create confusion | XS |
docs/audits/NAMING_NARRATIVE_AUDIT_2026-05-30.md:107:### Pillar 6 — Multi-Agent Adversarial Review (Banda Cognitiva + Council + Multi-LLM)
docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md:22:- [~] **ORG-A1** ❌ CANCELADO — `docs/banda/` (5 .yaml) e `docs/world-model/` (current.json) NÃO estão vazias. Sweep agent contou só .md. Mantidas.
docs/audits/premortem-egos-public.md:29:| **F4** | Vocabulário neutro destrói diferencial — "Banda Cognitiva" virou "Hierarchical Review" e perdeu identidade. Vira "agile renaming" sem alma | M | M | Feedback inicial "isso é só mais um best-practices repo" |
docs/audits/premortem-egos-public.md:57:- **Preventiva:** **MANTER nomes originais** (Banda Cognitiva, Council, Tutor Mode) + adicionar tagline neutra como subtitle: "Banda Cognitiva (Hierarchical Review)". Glossário `VOCABULARY.md` traduz.
docs/audits/premortem-kyte-strategy.md:60:## v2 — Após Codex (NEEDS-REWORK) + Banda Cognitiva (2026-06-01)
docs/audits/premortem-kyte-strategy.md:62:> Codex acertou o descasamento legal (manter split bloqueado) mas apontou: falta **máquina executável sob capacidade-de-founder limitada** + modos ausentes + sequência (pilotos PAGOS antes de canal genérico). Banda Cognitiva sintetizou a v2 abaixo.
docs/banda/2026-04-24-devemos-come-ar-onda-2-com-f4-banda-ts-f5-council-.yaml:1:# Banda Cognitiva — 2026-04-24
docs/banda/2026-04-27-dry-run.yaml:1:# Banda Cognitiva — 2026-04-27
docs/banda/2026-04-27-entre-os-5-formatos-para-a-banda-cognitiva-como-m-.yaml:1:# Banda Cognitiva — 2026-04-27
docs/banda/2026-04-27-entre-os-5-formatos-para-a-banda-cognitiva-como-m-.yaml:5:  Entre os 5 formatos para a Banda Cognitiva como música — F1 Jazz Quartet, F2 Fuga de Bach, F3 Síntese Modular (WebAudio/Tone.js), F4 Orquestra Sinfônica (N LLMs por seção), F5 Interferência Quântica (superposição Hilbert) — qual deve ser construído primeiro como app com frontend/backend, considerando: demo-abilidade em <2h de código, metáfora fiel aos 4 papéis da banda, extensibilidade futura, impacto visual para consultoria?
docs/banda/2026-04-27-entre-os-5-formatos-para-a-banda-cognitiva-como-m-.yaml:153:    a Banda Cognitiva já melhorou?" Se a resposta for nenhuma ainda,
docs/banda/2026-04-27-entre-os-5-formatos-para-a-banda-cognitiva-como-m-.yaml:163:    Escolher qual dos 5 formatos da Banda Cognitiva construir primeiro
docs/banda/2026-04-27-quais-s-o-as-3-5-mudan-as-constitucionais-mais-imp.yaml:1:# Banda Cognitiva — 2026-04-27
docs/banda/2026-05-27-qual-melhor-para-este-projeto-postgresql-com-rls-o.yaml:1:# Banda Cognitiva — 2026-05-27
docs/banda/2026-06-04-adotar-a-op-o-c-n-o-linear-egos-no-centro-com-3-ei.yaml:1:# Banda Cognitiva — 2026-06-04
docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml:1:# Banda Cognitiva — 2026-06-10
docs/banda/2026-06-10-dry-run.yaml:1:# Banda Cognitiva — 2026-06-10
docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml:1:# Banda Cognitiva — 2026-06-10
docs/business/competitive-analysis.md:35:- **EGOS:** Método evidence-first, classify CONFIRMADO/INFERIDO/HIPÓTESE, Banda Cognitiva
docs/business/egos-communication-blueprint.md:2:> Produzido por: Banda Cognitiva (4 papéis) + Antigravity (Gemini) + Codex + Exa research
docs/competitive-analysis/aiox-rules-vs-egos-rules.md:139:- Banda Cognitiva (4 papéis: Crítico → Apoiador → Questionador → Maestro) antes de decisões
docs/competitive-analysis/aiox-rules-vs-egos-rules.md:197:| **Banda Cognitiva + Council** — revisão multi-papel e multi-LLM antes de irreversíveis | Governança de decisão; AIOX não tem equivalent |
"docs/concepts/architecture/ideianaro\303\247a.md":306:## 7. A Banda Cognitiva
"docs/concepts/architecture/ideianaro\303\247a.md":484:8. Antes de propor mudanças grandes, rodar a Banda Cognitiva:
docs/drafts/2026-04-26-two-windows-one-mind-pt-ANCHOR.md:90:<p><strong>Ferramenta:</strong> <a href="https://github.com/enioxt/egos/blob/main/docs/opus-mode/OPUS_MODE_V1.md">OPUS MODE §5 — Ciclos Fibonacci</a> (1→2→3→5→8 profundidade) e <a href="https://github.com/enioxt/egos/blob/main/docs/opus-mode/OPUS_MODE_V1.md">Banda Cognitiva</a> (Crítico, Apoiador, Questionador, Maestro) — questionador desafia premissas antes do Maestro decidir.</p>
docs/drafts/2026-04-26-two-windows-one-mind-pt-ANCHOR.md:175:<li><a href="https://github.com/enioxt/egos/blob/main/docs/opus-mode/OPUS_MODE_V1.md">OPUS_MODE_V1.md</a> — Ciclos Fibonacci + Banda Cognitiva</li>
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:22:| 5 | **Decisão DB Opção B fechada sem Banda Cognitiva nem Council** | Audit handoffs revelou CET-DB-DECISION-001 estava aguardando Enio há tempo — eu fechei rápido | Red Zone (arquitetura final) tratada como Yellow Zone |
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:35:| Banda Cognitiva antes de decisão importante | ❌ NÃO usei nenhuma vez | Operei direto em modo "responde + executa" |
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:51:[ ] 4. Banda Cognitiva: /banda <questão> — 4 papéis revisam
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:627:[ ] 4. Banda Cognitiva
docs/governance/BANDA_COGNITIVA.md:1:# Banda Cognitiva — SSOT de governança
docs/governance/EGOS_AGENT_ORGANIZATION.md:71:> **A "equipe" virou sistema, não prosa.** O fluxo do §2 agora **deriva** de [`agents/registry/triggers.json`](../../agents/registry/triggers.json) — o SSOT único da interconexão: para cada papel, `upstream`/`downstream`/`gates`/`peers:"*"` (ciência mútua dos 12). Cada `.claude/agents/*.md` **linka** o roster (não copia → sem drift, sem bloat). Decisão: Banda Cognitiva 2026-06-03 (faseado, corte Enio). Premortem: [`docs/audits/premortem-agent-interconnection.md`](../audits/premortem-agent-interconnection.md).
docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md:110:- [x] Banda Cognitiva (4 papéis) — 2026-06-09: APROVA direção, escopo reduzido; line-limit não é o ganho, condensar 3 ofensores + adotar recall/supersessão é.
docs/governance/GOV_RUNTIME_001_002_PLAN.md:57:- `banda.ts` — Banda Cognitiva
docs/governance/LAYER_0_SSOT.md:91:> Regras de kernel adicionais herdadas implicitamente (não viram `L0-N` porque não são de conteúdo setorial): `AGENTS.md R3` Edit safety (inclui Karpathy itens 5-7), `R4` Git safety, `R5` Context & swarm, `R6` Incident-driven, `R7` Behavioral eval, `R8` DB discipline. A Banda Cognitiva (parar antes de irreversíveis) vive no OPUS MODE / skill `banda`, **não** em `AGENTS.md R4`.
docs/governance/LAYER_0_SSOT.md:155:| Mesma override em ≥3 templates ativos | hard | Propor promoção a regra L0 (PR + Banda Cognitiva) |
docs/governance/LAYER_0_SSOT.md:163:3. Banda Cognitiva (4 papéis) revisa o impacto cross-template
docs/governance/METAPROMPT_STANDARD.md:4:> **Escopo:** TODO comando enviado a um avaliador (Banda Cognitiva, Codex review, Council multi-LLM, critico, guarani-audit) DEVE cumprir os 6 requisitos abaixo. Avaliador que recebe comando incompleto **NÃO executa** — responde apontando este arquivo.
docs/governance/MODEL_DELEGATION_POLICY.md:49:4. **Negociação fina com user** — Banda Cognitiva, Council, Tutor mode, orientação contextualizada
docs/governance/MULTI_USER_RULE_GOVERNANCE.md:26:| **LAYER_0 §5 (promoção)** | Override que vira regra **Layer 0** (cross-template) | Mantenedor EGOS + Banda Cognitiva | `LAYER_0_SSOT.md §5` |
docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md:4:> **Pipeline de decisão:** Banda Council 2026-06-10 (GPT-5.4 · Sonnet 4.6 · Gemini 2.5 Pro · Opus 4.7) → review adversarial Codex gpt-5.5 (**SUSTENTA-COM-EMENDAS**, 10 objeções aplicadas) → esta v1.1. Trace: `docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-fro.yaml`
docs/governance/PREMORTEM_BANDA_INTEGRATION.md:74:- `scripts/banda.ts` — executor CLI da Banda Cognitiva
docs/governance/SKILLS_REGISTRY.md:386:# → Banda Cognitiva carregada + executada
docs/governance/TOKEN_MODEL_ROUTING_AUDIT.md:183:- Banda Cognitiva + Council multi-LLM (orquestração 3+ agentes)
docs/governance/TOKEN_MODEL_ROUTING_AUDIT.md:244:- Negociação contextualizada com Enio (Banda Cognitiva, Council)
docs/governance/UI_PRODUCT_RULES.md:6:> (c) chatbot de vendas que renomeia nós. Nem o próprio Enio entendia. Codex + Banda Cognitiva
docs/governance/UI_PRODUCT_RULES.md:131:   - **Banda Cognitiva** (4 papéis) ✔
docs/governance/agent_scopes_and_governance.md:47:- **Prohibited**: Modifying DB migrations, RLS security policies, or editing frozen zone configurations without a mandatory Força Total (`--council` mode) review from the Banda Cognitiva.
docs/governance/agent_scopes_and_governance.md:72:5. Requires architectural execution where structural claims or security policies are modified — triggering mandatory **Banda Cognitiva in Força Total (Council Mode)**.
docs/governance/council.md:12:O Council baseia-se em **revisão adversarial multi-agente** (Banda Cognitiva e modelos de provedores independentes) para evitar viés de confirmação e alinhamento cego com o usuário (anti-sycophancy).
docs/jobs/2026-06-09-fable5-wave0-patches.md:320:5. **Negociação fina com user** — quando o user está hesitante e precisa de orientação contextualizada (Banda Cognitiva, Council, Tutor mode)
docs/jobs/2026-06-09-fable5-wave0-patches.md:344:4. **Negociação fina com user** — Banda Cognitiva, Council, Tutor mode, orientação contextualizada
docs/knowledge/HARVEST.md:35:## P172 — 2026-06-08: Banda Cognitiva — preço no vídeo e HTML por cliente
docs/knowledge/HARVEST.md:106:- Banda Cognitiva interna (Crítico/Apoiador/Questionador/Maestro) **antes** de apresentar
docs/metaprompts/MP-ODYSSEUS-MIGRATION.md:3:**Para:** Claude Code (Prime) & Claude 3.5 Sonnet / Fable (Banda Cognitiva)
docs/metaprompts/MP-REVIEW-001.md:11:Orquestra Banda Cognitiva (`/banda`), premortem, quorum multi-LLM
docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md:68:| `/banda` | REAL | `.claude/commands/banda.md` | Banda Cognitiva — 4 papeis criticos |
docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md:270:- Saida: analise Banda Cognitiva (4 papeis) + veredicto APROVADO / REJEITAR / DEFER + quorum requerido.
docs/opus-mode/BANDA_COGNITIVA.md:1:# Banda Cognitiva — Framework dos 4 Papéis
docs/opus-mode/BANDA_COGNITIVA.md:181:- `docs/banda/YYYY-MM-DD-<slug>.yaml`
docs/opus-mode/COUNCIL_PROTOCOL.md:8:Protocolo para convocar múltiplos LLMs de providers diferentes (Claude + GPT + Gemini + outros) para decisões **irreversíveis** ou de alto impacto. Diferente da Banda Cognitiva (4 papéis no mesmo LLM), o Council usa **modelos diferentes** para garantir diversidade de viés.
docs/opus-mode/CYCLE_REPORT_TEMPLATE.md:16:- Banda Cognitiva executada
docs/opus-mode/CYCLE_REPORT_TEMPLATE.md:78:- **Tipo:** Banda Cognitiva | Council | Direta
docs/opus-mode/CYCLE_REPORT_TEMPLATE.md:80:- **Registro:** `docs/banda/<id>.yaml` ou `docs/quorum/<id>/`
docs/opus-mode/CYCLE_REPORT_TEMPLATE.md:193:2. Banda Cognitiva: modo hierárquico sequencial (opção C)
docs/opus-mode/OPUS_MODE_V1.md:4:> **SSOT:** Este arquivo. Update only via PR with Banda Cognitiva review.
docs/opus-mode/OPUS_MODE_V1.md:89:## 4. Banda Cognitiva (modo hierárquico sequencial)
docs/opus-mode/OPUS_MODE_V1.md:247:decisão estrutural → Banda Cognitiva (4 papéis) → síntese Maestro → Enio aprova
docs/opus-mode/OPUS_MODE_V1.md:433:- **Write:** apenas via PR com Banda Cognitiva review
docs/opus-mode/OPUS_MODE_V1.md:458:| `/banda <questão>` | Roda Banda Cognitiva hierárquica |
docs/opus-mode/README.md:41:4. **Banda Cognitiva antes de decisões importantes.** Council antes de irreversíveis.
docs/opus-mode/README.md:63:Update rule: nunca via edit direto de LLM. Sempre PR com Banda Cognitiva aplicada no próprio SSOT.

exec
/bin/bash -lc "python - <<'PY'
import yaml,glob
for f in sorted(glob.glob('docs/banda/*.yaml')):
    try:
        list(yaml.safe_load_all(open(f)))
    except Exception as e: print('bad',f, str(e).split('\\n')[0])
PY" in /home/enio/egos
 succeeded in 0ms:
bad docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml while scanning for the next token
bad docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml while scanning for the next token

exec
/bin/bash -lc "nl -ba docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml | sed -n '88,112p'; nl -ba scripts/banda.ts | sed -n '338,350p'" in /home/enio/egos
 succeeded in 0ms:
    88	    - "context-prime skill para injetar contexto sanitizado antes do council"
    89	
    90	  efeito_rede: >
    91	    Todo agente EGOS que precisar de revisão multi-perspectiva herda o mesmo pipeline.
    92	    Smoke passa → template vira primitiva de governança. Em 90 dias, qualquer skill
    93	    pode invocar `/banda` com garantia de que os 4 papéis respondem de provedores reais
    94	    e auditáveis — diferencial concreto frente a councils de provedor único.
    95	
    96	  recomendacao: REFINAR_PRIMEIRO
    97	
    98	---
    99	# Phase 3 — Questionador
   100	```yaml
   101	questionador:
   102	  premissas_implicitas:
   103	    - "Assume-se que os CLIs (codex, claude) possuem saídas (stdout/stderr) estáveis e uniformes que o `banda.ts` consegue parsear sem falhas."
   104	    - "Assume-se que a máquina local do Enio (com suas sessões e assinaturas ativas) é um ambiente aceitável para validar uma primitiva central de governança."
   105	    - "Assume-se que o Maestro conseguirá gerar um YAML válido mesmo se a saída dos outros papéis via CLI vier poluída com avisos de atualização ou erros de rede."
   106	  caminho_mais_simples: >
   107	    Em vez de misturar três CLIs locais e uma API (OpenRouter), o caminho que resolve 80%
   108	    com muito menos atrito é rotear todos os 4 papéis via uma única interface de API 
   109	    (ex: OpenRouter ou LiteLLM). Isso elimina a fragilidade de parsing de CLI, 
   110	    padroniza a coleta de métricas (latência, provedor) e remove a dependência de estado local.
   111	  causa_vs_sintoma: >
   112	    Estamos tratando sintomas. O Crítico aponta a falta de rastreabilidade e o Apoiador 
   338	  const data = await r.json() as { choices?: Array<{ message?: { content?: string } }> };
   339	  return data.choices?.[0]?.message?.content ?? '';
   340	}
   341	
   342	// ─── Helpers ───────────────────────────────────────────────────────────────────
   343	
   344	function slugify(text: string): string {
   345	  return text.toLowerCase()
   346	    .replace(/[^a-z0-9]+/g, '-')
   347	    .replace(/^-+|-+$/g, '')
   348	    .slice(0, 50);
   349	}
   350	

exec
/bin/bash -lc "nl -ba scripts/banda.ts | sed -n '350,365p'" in /home/enio/egos
 succeeded in 0ms:
   350	
   351	function extractYaml(response: string): string {
   352	  const m = response.match(/```ya?ml\n([\s\S]*?)```/);
   353	  return m ? m[1].trim() : response.trim();
   354	}
   355	
   356	// ─── Main ──────────────────────────────────────────────────────────────────────
   357	
   358	async function main() {
   359	  const models = MODELS[MODE];
   360	  const startTs = Date.now();
   361	  const slug = slugify(QUESTION || 'dry-run');
   362	  const today = new Date().toISOString().split('T')[0];
   363	
   364	  console.log(`[banda] MODE=${MODE} | Question: "${QUESTION.slice(0, 80)}${QUESTION.length > 80 ? '...' : ''}"`);
   365	  console.log(`[banda] Models: critic=${models.critic.split('/').pop()} | supporter=${models.supporter.split('/').pop()} | questioner=${models.questioner.split('/').pop()} | maestro=${models.maestro.split('/').pop()}`);

exec
/bin/bash -lc "nl -ba docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml | sed -n '112,150p'" in /home/enio/egos
 succeeded in 0ms:
   112	    Estamos tratando sintomas. O Crítico aponta a falta de rastreabilidade e o Apoiador 
   113	    sugere engenharia pesada (blocos de evidência, context gates, mock modes) para um 
   114	    simples "smoke test". A causa real é a escolha de uma arquitetura de transporte 
   115	    heterogênea e opaca (mistura de CLIs e APIs). O objetivo era provar a tubulação, 
   116	    mas estamos em fuga para a construção de um framework de validação complexo.
   117	  questoes_nao_feitas:
   118	    - "Por que estamos construindo um pipeline multi-LLM de governança dependente de wrappers de CLI em vez de integrações diretas de API?"
   119	    - "Se o objetivo (MP-R3) é apenas prova de tubulação, por que o Apoiador propõe features definitivas de produção antes de validar o fluxo básico?"
   120	    - "O que acontece com a autonomia do Council se a sessão do CLI na máquina do Enio expirar durante uma decisão crítica?"
   121	    - "Como garantir que a 'síntese sem erro' do Maestro não é apenas ele alucinando os inputs dos outros papéis que falharam silenciosamente no CLI?"
   122	  alinhamento_egos: TENSAO
   123	  reformulacao_sugerida: >
   124	    "Smoke test do rewire da Banda Council: os 4 papéis respondem via uma interface de 
   125	    API padronizada com rastreabilidade nativa? Critério de aceite: log de execução 
   126	    comprova 4 chamadas de rede distintas (
   127	
   128	---
   129	# Phase 4 — Maestro (FINAL SYNTHESIS)
   130	decisao:
   131	  contexto: "Smoke test do rewire da Banda Council — provar que os 4 papéis respondem pelo novo roteamento (codex/claude/openrouter/claude)."
   132	  critica_principal: "YAML sem erro prova serialização, não prova que os 4 papéis foram realmente chamados pelos provedores certos."
   133	  potencial_principal: "Primeiro pipeline multi-LLM governado do EGOS — template reusável para qualquer council multi-provedor."
   134	  duvida_principal: "Por que transporte heterogêneo (3 CLIs + 1 API) numa prova de tubulação, em vez de interface única rastreável?"
   135	  acao_escolhida: "Aceitar este smoke como prova-de-tubulação mínima (esta síntese YAML JÁ é o aceite cumprido), mas marcar o critério como INSUFICIENTE e abrir task de hardening de evidência-por-papel. ~20min."
   136	  acao_rejeitada: "NÃO promover este smoke a selo de confiança nem rotear decisão real pelo council até haver evidência por papel — o Apoiador quer features de produção (context_gate, mock-mode) que são over-engineering para um smoke."
   137	  ressalvas_aplicadas:
   138	    - "Aceite deve exigir por papel: provider, model, exit_code, latency_ms, trecho identificado da resposta."
   139	    - "Falha de QUALQUER papel deve falhar o smoke (sem síntese parcial silenciosa)."
   140	    - "Teste negativo: provider indisponível não pode gerar síntese falsa."
   141	  proximo_passo: "Rodar `bun scripts/banda.ts` com esta questão real end-to-end e capturar o stdout dos 4 papéis (provider+model) num log — se os 4 blocos vierem dos provedores esperados, smoke REAL passou."
   142	  prioridade: 3
   143	  gate_decisao: "auto (smoke de tubulação); promover a primitiva de governança = Enio"
   144	
   145	# Sacred Code: 000.111.369.963.1618

exec
/bin/bash -lc "bun -e \"import { namedTokenize } from './packages/guard-brasil/src/lib/tokenizer.ts'; console.log(namedTokenize('Autor: CPF 111.222.333-44. Vítima: CPF 555.666.777-88.').tokenized)\"" in /home/enio/egos
 succeeded in 0ms:
Autor: CPF [CPF_0002]. Vítima: CPF [CPF_0001].

exec
/bin/bash -lc "git show 1ee70f2785af91d5f5dfc577420472e2696dfa49:scripts/banda.ts | grep -n \"modelId\\|body: JSON\" -A8 -B3" in /home/enio/egos
 succeeded in 0ms:
277-    : 'https://openrouter.ai/api/v1/chat/completions';
278-  const apiKey = (isDeepseek && deepseekKey) ? deepseekKey : OPENROUTER_KEY;
279-  // Normalize model name for DeepSeek direct API
280:  const modelId = (isDeepseek && deepseekKey)
281-    ? model.replace('deepseek/', '').replace('-flash', '-chat').replace('-pro', '-reasoner').replace('v4-flash','chat').replace('v4-pro','reasoner')
282-    : model;
283-
284-  const r = await fetch(apiUrl, {
285-    method: 'POST',
286-    headers: {
287-      'Authorization': `Bearer ${apiKey}`,
288-      'Content-Type': 'application/json',
289-      'HTTP-Referer': 'https://github.com/enioxt/egos',
290-      'X-Title': 'EGOS Banda Cognitiva',
291-    },
292:    body: JSON.stringify({
293-      model,
294-      messages: [{ role: 'user', content: prompt }],
295-      temperature: 0.3,
296-      max_tokens: 2000,
297-    }),
298-    signal: AbortSignal.timeout(90_000),
299-  });
300-  if (!r.ok) {

exec
/bin/bash -lc "nl -ba packages/guard-brasil/src/lib/tokenizer.ts | sed -n '168,190p'" in /home/enio/egos
 succeeded in 0ms:
   168	  }
   169	
   170	  const sorted = [...findings].sort((a, b) => b.start - a.start);
   171	  let tokenized = text;
   172	
   173	  for (const f of sorted) {
   174	    const original = text.slice(f.start, f.end);
   175	    if (reverse.has(original)) {
   176	      const existingToken = reverse.get(original)!;
   177	      tokenized = tokenized.slice(0, f.start) + existingToken + tokenized.slice(f.end);
   178	      continue;
   179	    }
   180	    const key = categoryToKey(f.category);
   181	    counters[key] = (counters[key] ?? 0) + 1;
   182	    const token = `[${key}_${String(counters[key]).padStart(4, '0')}]`;
   183	    tokens.set(token, original);
   184	    reverse.set(original, token);
   185	    tokenized = tokenized.slice(0, f.start) + token + tokenized.slice(f.end);
   186	    auditLog.push({ token, category: f.category, label: f.label });
   187	  }
   188	
   189	  return {
   190	    tokenized,

 succeeded in 106251ms:
./docs/strategy/COURSE_PROGRAM_DESIGN.md:14:- DataVirtus/WB ensinam *usar* (ChatGPT p/ policiais, Gemma local) ou *investigar/atacar*. **Ninguém co-cria governança/ferramentas COM o aluno.**
./docs/strategy/COURSE_PROGRAM_DESIGN.md:51:| **Aula inaugural grátis** | baixo (funil) | público amplo (como DataVirtus/WB) |
./docs/strategy/COURSE_PROGRAM_DESIGN.md:68:- **Posição vs players** (não atacar DataVirtus/WB; ocupar o degrau acima = arquitetura/governança).
./docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:4:> **Origem:** Enio mostrou DataVirtus + WB Educação ("ver o que já existe, o que falta no mercado") e pediu: *"devemos ter essas regras para sempre pesquisar usando o conjunto de regras, deve estar dentro de um de nossos agentes (Hermes/VPS) — pesquisar e ir entendendo o surgimento de cursos, de áreas, focando no nosso."*
./docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:16:- **USAR IA** (ChatGPT/Gemma local, prompts) → mercado lotado (DataVirtus, WB).
./docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md:23:| BR nicho forense/lei | DataVirtus (themembers), WB Educação (eveclass), Academia de Forense Digital, IDESP/escolas de polícia |
./docs/_current_handoffs/_merge_2026-06-02/egos__main__a234c2a2.md:18:- **MODELO DE CURSO desbloqueado:** "Construa e Governe a SUA IA" — diferencial = **co-criar regras/ferramentas COM cada aluno** (1:1/grupo/turma), não vender "use IA". Gap confirmado vs DataVirtus/WB (eles ensinam USAR; ninguém ensina ARQUITETAR/GOVERNAR). SSOT: `docs/strategy/COURSE_PROGRAM_DESIGN.md` + [[project_course_market_gap_research_capability]].
./docs/_current_handoffs/PRIME_TO_GUARANI_2026-06-03_irb-premortem.md:11:Sistema **IRB** (Investigation Report Builder) — análise financeira investigativa rodando **100% LOCAL** no intelink (Postgres dedicado `127.0.0.1:54399`), uso **policial PCMG** (Red Zone, sigilo bancário/fiscal/LGPD). Ingere extrato/RIF/CCS/cadastro, cruza por CPF/CNPJ, gera **LEADS (não prova)** com SHA-256 apontando para a fonte. Caso de teste: DataVirtus 077 (dados sintéticos).
./docs/roadmap/public-roadmap.md:70:- **Pesquisa de mercado** — `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (DataVirtus/WB mapeados, gap identificado)
./docs/metaprompts/MP-RESEARCH-001.md:125:HIPOTESES      : Nenhum curso ensina governanca + IDE-nativo juntos; DataVirtus/WB cobrem uso
./TASKS.md:497:- [ ] **COURSE-INTEL-001** [P1] `hermes` 🆕 (Enio 2026-06-02) — Capability `course-market-scan` no Hermes/VPS: pesquisa contínua (semanal) do surgimento de cursos/áreas/players nas maiores plataformas, lente no espaço-branco do Enio (arquitetar+governar IA com IDE-nativo + governança + ética, ctx forense/lei). Reusa gem-hunter (descoberta) + keyword-temas (termos). Ruleset: `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (v1.0, escrito). **Gap confirmado:** DataVirtus/WB ensinam USAR IA; ninguém ensina ARQUITETAR/GOVERNAR. **Corte Banda:** inteligência-de-posicionamento p/ entrar em equipes, NÃO fábrica-de-curso. Build = sessão dedicada. Liga [[project_course_market_gap_research_capability]].
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:683:+## Contexto: o que é a DataVirtus
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:685:+DataVirtus é uma **plataforma de formação para Agentes da Lei** (datavirtus.themembers.com.br).
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:703:+DataVirtus e EGOS/Guard Brasil **servem o mesmo público** (servidores públicos, policiais, investigadores) **com propostas diferentes:**
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:705:+| Dimensão | DataVirtus | EGOS / Guard Brasil |
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:728:+DataVirtus ensina: "anon → LLM externo → deanon." EGOS ensina: "IA local + governança = dado nunca sai."
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-aa4bce23.md:53: - [ ] **COURSE-INTEL-001** [P1] `hermes` 🆕 (Enio 2026-06-02) — Capability `course-market-scan` no Hermes/VPS: pesquisa contínua (semanal) do surgimento de cursos/áreas/players nas maiores plataformas, lente no espaço-branco do Enio (arquitetar+governar IA com IDE-nativo + governança + ética, ctx forense/lei). Reusa gem-hunter (descoberta) + keyword-temas (termos). Ruleset: `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (v1.0, escrito). **Gap confirmado:** DataVirtus/WB ensinam USAR IA; ninguém ensina ARQUITETAR/GOVERNAR. **Corte Banda:** inteligência-de-posicionamento p/ entrar em equipes, NÃO fábrica-de-curso. Build = sessão dedicada. Liga [[project_course_market_gap_research_capability]].
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-1ee70f27.md:740:-## Contexto: o que é a DataVirtus
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-1ee70f27.md:743:-DataVirtus é uma **plataforma de formação para Agentes da Lei** (datavirtus.themembers.com.br).
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-1ee70f27.md:771:-DataVirtus e EGOS/Guard Brasil **servem o mesmo público** (servidores públicos, policiais, investigadores) **com propostas diferentes:**
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-1ee70f27.md:774:-| Dimensão | DataVirtus | EGOS / Guard Brasil |
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-1ee70f27.md:1191:-DataVirtus ensina: "anon → LLM externo → deanon." EGOS ensina: "IA local + governança = dado nunca sai."
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-c26e8813.md:1026:-## Contexto: o que é a DataVirtus
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-c26e8813.md:1029:-DataVirtus é uma **plataforma de formação para Agentes da Lei** (datavirtus.themembers.com.br).
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-c26e8813.md:1057:-DataVirtus e EGOS/Guard Brasil **servem o mesmo público** (servidores públicos, policiais, investigadores) **com propostas diferentes:**
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-c26e8813.md:1060:-| Dimensão | DataVirtus | EGOS / Guard Brasil |
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-c26e8813.md:1477:-DataVirtus ensina: "anon → LLM externo → deanon." EGOS ensina: "IA local + governança = dado nunca sai."
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:10:import { namedTokenize, namedRestore } from './lib/tokenizer.js';
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:431:// ─── namedTokenize — DataVirtus-compatible reversible redaction ───────────────
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:433:describe('namedTokenize — readable placeholders', () => {
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:438:    const { tokenized, vault } = namedTokenize(text);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:441:    const restored = namedRestore(tokenized, vault);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:450:    const { tokenized } = namedTokenize(text);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:458:    const { tokenized } = namedTokenize(text);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:466:    const { tokenized, vault } = namedTokenize(text);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:468:    const restored = namedRestore(tokenized, vault);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/guard.test.ts:474:    const { tokenized, vault } = namedTokenize(text);
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/tokenizer.ts:126:// ─── Named (DataVirtus-style) Tokenization ────────────────────────────────────
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/tokenizer.ts:147: * Readable reversible tokenization — DataVirtus-compatible format.
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/tokenizer.ts:159:export function namedTokenize(text: string): NamedTokenizedResult {
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/tokenizer.ts:197: * Restore original values from a namedTokenize vault.
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/tokenizer.ts:200:export function namedRestore(text: string, vault: NamedTokenVault): string {
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/lib/index.ts:23:export { namedTokenize, namedRestore } from './tokenizer.js';
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/index.ts:58:// Reversible tokenized redaction — readable named placeholders (DataVirtus-compatible)
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/index.ts:59:// Usage: namedTokenize(text) → [CPF_0001], [REDS_0001] → send to LLM → namedRestore(response, vault)
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-mcp/node_modules/@egosbr/guard-brasil/src/index.ts:60:export { namedTokenize, namedRestore } from './lib/tokenizer.js';
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:683:+## Contexto: o que é a DataVirtus
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:685:+DataVirtus é uma **plataforma de formação para Agentes da Lei** (datavirtus.themembers.com.br).
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:703:+DataVirtus e EGOS/Guard Brasil **servem o mesmo público** (servidores públicos, policiais, investigadores) **com propostas diferentes:**
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-d24755e3.md:705:+| Dimensão | DataVirtus | EGOS / Guard Brasil |

exec
/bin/bash -lc 'git diff --name-status 1ee70f2785af91d5f5dfc577420472e2696dfa49 | cat' in /home/enio/egos
 succeeded in 0ms:
M	TASKS.md
M	TASKS_ARCHIVE.md
M	apps/egos-landing/public/mycelium-snapshot.json
M	apps/egos-landing/public/timeline/rss
M	apps/egos-landing/public/timeline/rss.xml
A	docs/_current_handoffs/FOR_GUARANI_2026-06-10_banda-questioner-protocol.md
A	docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml
M	docs/governance/GUARANI_EVALUATOR_PROTOCOL.md
A	docs/governance/rfc-odysseus-pilot-evidence.md
M	docs/jobs/2026-06-10-doc-drift-verifier.json
M	docs/jobs/2026-06-10-pre-commit-pipeline.json
M	packages/guard-brasil/src/guard.test.ts
M	packages/guard-brasil/src/index.ts
M	packages/guard-brasil/src/lib/index.ts
A	packages/guard-brasil/src/lib/ner-rules.ts
M	packages/guard-brasil/src/lib/pii-scanner.ts
M	packages/guard-brasil/src/lib/tokenizer.ts
M	packages/guard-brasil/tsconfig.tsbuildinfo
M	scripts/banda.ts

exec
/bin/bash -lc 'git diff 1ee70f2785af91d5f5dfc577420472e2696dfa49 -- packages/guard-brasil/src/lib/ner-rules.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/packages/guard-brasil/src/lib/ner-rules.ts b/packages/guard-brasil/src/lib/ner-rules.ts
new file mode 100644
index 00000000..baffaa5e
--- /dev/null
+++ b/packages/guard-brasil/src/lib/ner-rules.ts
@@ -0,0 +1,104 @@
+/**
+ * NER Rules for Guard Brasil — Brazilian police/legal document context (MG focus)
+ *
+ * 10 heuristic rules (A–J) for name detection in structured police documents.
+ * Ported and expanded from Datavirtus anonymizer regras A–J (Python) to TypeScript.
+ * All patterns are safe to clone (no lastIndex mutation) via clonePattern().
+ *
+ * Usage:
+ *   import { NER_RULES, applyNERRules } from './ner-rules.js';
+ *   const findings = applyNERRules(text);
+ */
+
+import type { PIIFinding } from './pii-scanner.js';
+
+/** Capture group 1 = the name token in all patterns below */
+
+const cloneRe = (re: RegExp) => new RegExp(re.source, re.flags.includes('g') ? re.flags : re.flags + 'g');
+
+// A — Explicit field labels: "Nome:", "Nome Completo:", "Nome do Suspeito:", etc.
+const RULE_A = /(?:[Nn]ome(?:\s+[Cc]ompleto)?|[Nn]ome\s+d[oa]\s+(?:[Ss]uspeito|[Ii]nvestigado|[Pp]aciente|[Cc]onduzido|[Vv][íi]tima|[Cc]liente|[Uu]su[aá]rio|[Rr]espons[aá]vel))\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})/g;
+
+// B — Honorifics: "Sr.", "Sra.", "Dr.", "Dra.", "Prof.", "Del."
+const RULE_B = /\b(?:Sr\.|Sra\.|Srta\.|Dr\.|Dra\.|Prof\.?|Profa\.?|Del\.|Esc\.|Ag\.)\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;
+
+// C — ALL-CAPS proper names (common in police headers: "FULANO DE TAL")
+// Min 2 words, max 5, at least 2 chars each, ignores common ALL-CAPS non-names
+const NER_C_STOP = new Set(['CPF', 'RG', 'CNH', 'MASP', 'REDS', 'IPL', 'BO', 'CEP', 'SUS', 'NIS', 'PIS', 'TJMG', 'PCMG', 'CBMMG', 'DETRAN', 'SESP', 'SJSP', 'MG', 'SP', 'RJ', 'DF', 'BR', 'SA', 'ME', 'EPP', 'LTDA', 'SS']);
+const RULE_C_RAW = /\b([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ]{2,}(?:\s+(?:D[AEO]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ]{2,}){1,4})\b/g;
+
+// D — Party roles in police/court docs
+const RULE_D = /\b(?:[Tt]estemunha|[Vv][íi]tima|[Cc]onduzido|[Pp]reso|[Aa]utuado|[Ii]nvestigado|[Aa]cusado|[Dd]enunciado|[Ii]ndiciado|[Qq]uerente|[Qq]uerido|[Aa]utor|[Rr][eé]u|[Rr][eé]|[Ee]nvolvido|[Ss]uspeito)\s*[:\-–]\s*([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;
+
+// E — Signature blocks
+const RULE_E = /(?:[Aa]ssinado\s+(?:por|digital(?:mente)?|eletronicamente)\s*:?\s*|[Aa]ssinatura\s*:?\s*|[Rr]espons[aá]vel\s+técnico\s*:?\s*)([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})/g;
+
+// F — Kinship references: "filho de Fulano", "esposa de Fulana"
+const RULE_F = /\b(?:[Ff]ilho|[Ff]ilha|[Cc][oô]njuge|[Ee]sposo|[Ee]sposa|[Gg]enitor|[Gg]enitora|[Nn]eto|[Nn]eta|[Ii]rm[aã]o?|[Pp]ai|[Mm][aã]e)\s+d[aeo]\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/gi;
+
+// G — Names in parentheses after a role token
+const RULE_G = /\b(?:delegad[oa]|escriv[aã]o?|comiss[aá]rio|perito|agente|servidor|investigador)\s+\(([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\)/g;
+
+// H — Numbered/bulleted witness/party lists (multiline)
+const RULE_H = /^[ \t]*(?:\d+[.\):]|-|\*|•)\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})[ \t]*$/gm;
+
+// I — Police/law enforcement role prefixes (extends DEFAULT_NAME_PATTERN in pii-scanner)
+const RULE_I = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comiss[aá]rio|perito|agente|policial|oficial|inspetor|subtenente|sargento|cabo|soldado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/gi;
+
+// J — "Paciente", "Requerente", "Requerido", "Titular", "Interessado" label fields
+const RULE_J = /\b(?:[Pp]aciente|[Cc]liente|[Rr]espons[aá]vel|[Rr]equerente|[Rr]equerido|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado|[Rr]epresentante\s+legal)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÇ][a-záéíóúãõâêîôûàèìòùäëïöüç]+){1,5})\b/g;
+
+export const NER_RULES = [
+  { id: 'ner:A', label: 'Nome (campo explícito)', pattern: RULE_A },
+  { id: 'ner:B', label: 'Nome (honorífico)', pattern: RULE_B },
+  { id: 'ner:D', label: 'Nome (papel processual)', pattern: RULE_D },
+  { id: 'ner:E', label: 'Nome (assinatura)', pattern: RULE_E },
+  { id: 'ner:F', label: 'Nome (parentesco)', pattern: RULE_F },
+  { id: 'ner:G', label: 'Nome (parêntese após cargo)', pattern: RULE_G },
+  { id: 'ner:H', label: 'Nome (lista numerada)', pattern: RULE_H },
+  { id: 'ner:I', label: 'Nome (cargo policial)', pattern: RULE_I },
+  { id: 'ner:J', label: 'Nome (campo de parte)', pattern: RULE_J },
+] as const;
+
+/** Apply NER rules A–J to text and return PIIFindings (category = 'name'). */
+export function applyNERRules(text: string): PIIFinding[] {
+  const findings: PIIFinding[] = [];
+
+  for (const { id: _id, label, pattern } of NER_RULES) {
+    const re = cloneRe(pattern);
+    let m: RegExpExecArray | null;
+    while ((m = re.exec(text)) !== null) {
+      const name = m[1];
+      if (!name || name.length < 4) continue;
+      const nameStart = m.index + m[0].indexOf(name);
+      findings.push({
+        category: 'name',
+        label,
+        matched: name,
+        start: nameStart,
+        end: nameStart + name.length,
+        suggestion: '[NOME REMOVIDO]',
+      });
+    }
+  }
+
+  // Rule C: ALL-CAPS sequences, filtered against known acronyms
+  const reC = cloneRe(RULE_C_RAW);
+  let mC: RegExpExecArray | null;
+  while ((mC = reC.exec(text)) !== null) {
+    const candidate = mC[1];
+    const words = candidate.split(/\s+/);
+    // Must have ≥2 words, none of which are known acronyms
+    if (words.length < 2 || words.some(w => NER_C_STOP.has(w))) continue;
+    findings.push({
+      category: 'name',
+      label: 'Nome (maiúsculas)',
+      matched: candidate,
+      start: mC.index,
+      end: mC.index + candidate.length,
+      suggestion: '[NOME REMOVIDO]',
+    });
+  }
+
+  return findings;
+}

codex
The patch introduces a functional ordering bug in readable PII tokenization and commits an invalid YAML evidence artifact. These are actionable correctness/maintainability issues that should be fixed before considering the patch correct.

Full review comments:

- [P2] Preserve left-to-right placeholder numbering — /home/enio/egos/packages/guard-brasil/src/lib/tokenizer.ts:170-173
  When a text has multiple distinct PII values of the same category, this descending sort assigns counters from the end of the document, so `Autor: CPF 111... Vítima: CPF 555...` becomes `Autor: [CPF_0002]` and `Vítima: [CPF_0001]`. For readable/DataVirtus-style placeholders, downstream review and audit commonly interpret `_0001` as the first entity encountered, so identities are reversed; assign tokens in ascending text order and then perform replacements right-to-left.

- [P2] Store parseable Banda traces — /home/enio/egos/docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml:100-100
  This newly committed `.yaml` trace contains a raw Markdown fence and a truncated `questionador` block, so YAML parsers fail on the decision record. Because `docs/banda/*.yaml` is used as the evidence artifact for Banda runs, this run cannot be machine-verified or consumed reliably; rerun/fix the trace generation so raw model text is stored as a quoted/literal field or extracted into valid YAML before committing.
The patch introduces a functional ordering bug in readable PII tokenization and commits an invalid YAML evidence artifact. These are actionable correctness/maintainability issues that should be fixed before considering the patch correct.

Full review comments:

- [P2] Preserve left-to-right placeholder numbering — /home/enio/egos/packages/guard-brasil/src/lib/tokenizer.ts:170-173
  When a text has multiple distinct PII values of the same category, this descending sort assigns counters from the end of the document, so `Autor: CPF 111... Vítima: CPF 555...` becomes `Autor: [CPF_0002]` and `Vítima: [CPF_0001]`. For readable/DataVirtus-style placeholders, downstream review and audit commonly interpret `_0001` as the first entity encountered, so identities are reversed; assign tokens in ascending text order and then perform replacements right-to-left.

- [P2] Store parseable Banda traces — /home/enio/egos/docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml:100-100
  This newly committed `.yaml` trace contains a raw Markdown fence and a truncated `questionador` block, so YAML parsers fail on the decision record. Because `docs/banda/*.yaml` is used as the evidence artifact for Banda runs, this run cannot be machine-verified or consumed reliably; rerun/fix the trace generation so raw model text is stored as a quoted/literal field or extracted into valid YAML before committing.
```
