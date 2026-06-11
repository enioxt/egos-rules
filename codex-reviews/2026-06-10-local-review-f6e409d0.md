# Codex Local Review — 2026-06-10T10:51:54Z

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
session id: 019eb129-04ab-7630-baa7-f43c23fb0a60
--------
user
changes against 'HEAD~3'
2026-06-10T10:51:56.948335Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T10:51:56.948487Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff fb3be6aabe9b3abefa2220c813adaea25730c449 --stat && git diff fb3be6aabe9b3abefa2220c813adaea25730c449' in /home/enio/egos
 succeeded in 0ms:
 .claude/agents/neon.md                      |  16 +-
 .husky/_checks/15-agent-gate.sh             | 152 +++++++
 TASKS.md                                    |  11 +-
 TASKS_ARCHIVE.md                            |  12 +
 docs/concepts/mycelium/MYCELIUM_OVERVIEW.md |  47 ++-
 docs/knowledge/HARVEST.md                   |   4 +
 scripts/mycelium-snapshot.ts                | 618 ++++++++++++++++++++++++++++
 7 files changed, 841 insertions(+), 19 deletions(-)
diff --git a/.claude/agents/neon.md b/.claude/agents/neon.md
index fb898ad2..8619276d 100644
--- a/.claude/agents/neon.md
+++ b/.claude/agents/neon.md
@@ -2,6 +2,7 @@
 name: neon
 description: "Creative Intelligence (Sonnet tier) — viral strategy, behavioral design, cinematic briefs. Aplica STEPPS/Fogg/ABCD/Peak-End. HITL obrigatório antes de publicar. Use para: brief criativo de vídeo viral, análise de tendências culturais, roteiro comportamental, prompts de geração IA (Sora/Veo/Kling). NÃO usa para: publicação direta, gestão de ads, métricas de performance, commits."
 model: sonnet
+status: agent_candidate
 ---
 
 # Neon — Creative Intelligence & Behavioral Design
@@ -43,7 +44,7 @@ Regra central: **o consumidor é o herói. O produto é o catalisador.** Você n
 
 **PODE:**
 - Executar o pipeline completo de 9 etapas
-- Pesquisar tendências via Perplexity Sonar Pro (OpenRouter) + Grok 4.20 (OpenRouter)
+- Gerar metaprompts + arquivos .md para pesquisa manual em Perplexity/Grok/ChatGPT (NOT via API interna)
 - Analisar páginas públicas via browser-automation MCP
 - Consultar Gemini 2.5 Flash para análise multimodal
 - Entregar brief criativo (para gravação humana) OU prompts de vídeo IA (Sora/Veo/Kling) — especificar no dispatch
@@ -63,14 +64,15 @@ Regra central: **o consumidor é o herói. O produto é o catalisador.** Você n
 
 ## Fontes de Pesquisa
 
+**Regra de pesquisa EGOS:** NÃO chamar APIs externas (OpenRouter/Perplexity/Grok) diretamente. Gerar metaprompts + arquivos `.md` que o Enio leva manualmente às plataformas externas quando necessário.
+
 | Fonte | Acesso | Uso |
 |---|---|---|
-| Perplexity Sonar Pro | OpenRouter `perplexity/sonar-pro-search` | Tendências em tempo real, artigos, dados de plataforma |
-| Grok 4.20 | OpenRouter `x-ai/grok-4.20` | Zeitgeist cultural, análise de social media, cultura digital |
-| Gemini 2.5 Flash | API direta ou `google/gemini-2.5-flash` via OpenRouter | Análise multimodal, grounding de imagens/vídeos |
-| Browser automation MCP | `mcp__egos-browser-automation__fetch_page` | Scraping de páginas públicas, exemplos virais, tendências |
+| Perplexity / Grok | **Metaprompt gerado** → uso manual externo | Tendências em tempo real, zeitgeist cultural |
+| Browser automation MCP | `mcp__egos-browser-automation__fetch_page` | Scraping de páginas públicas, exemplos virais |
+| Gemini (via EGOS router) | `mcp__egos-ops__route_request` se disponível | Análise multimodal, grounding de imagens |
 
-**Regra:** nunca afirmar tendência sem citar a fonte consultada (`source: perplexity/grok/url`).
+**Regra:** ao iniciar pesquisa, gerar `docs/drafts/neon-research-<slug>.md` com queries prontas para copiar nas plataformas externas. Nunca afirmar tendência sem citar fonte.
 
 ---
 
@@ -102,7 +104,7 @@ Restrições: [legais / de marca / de audiência]
 
 ### ETAPA 1 — DIAGNÓSTICO COMPORTAMENTAL
 
-Pesquisar via Perplexity Sonar Pro: o que está em tendência na plataforma/nicho agora.
+Gerar arquivo `docs/drafts/neon-research-<slug>.md` com queries prontas para pesquisa manual (Perplexity/Grok). O que está em tendência na plataforma/nicho agora.
 
 Identificar e justificar:
 - **Desejo de identidade**: quem o público QUER se tornar (não o que ele é)
diff --git a/.husky/_checks/15-agent-gate.sh b/.husky/_checks/15-agent-gate.sh
new file mode 100755
index 00000000..74f0a1dd
--- /dev/null
+++ b/.husky/_checks/15-agent-gate.sh
@@ -0,0 +1,152 @@
+#!/usr/bin/env bash
+# 15-agent-gate.sh — AGENT-GATE-001
+# Exige roster + triggers.json + golden case ao criar nova persona LLM em .claude/agents/
+# Escape: status: agent_candidate no frontmatter | AGENT_GATE_SKIP=<razão> no env
+# NOTA: escape via commit body é IMPOSSÍVEL em pre-commit — COMMIT_EDITMSG ainda
+# contém a mensagem do commit ANTERIOR neste momento (fail-open detectado 2026-06-09:
+# 28bce96f documentava a string do escape e pulava o gate dos commits seguintes).
+# SSOT: docs/governance/EGOS_AGENT_ORGANIZATION.md §1
+
+set -euo pipefail
+
+# ── Skip explícito via env ────────────────────────────────────────────────────
+if [ -n "${AGENT_GATE_SKIP:-}" ]; then
+  echo "  [15] agent-gate SKIP via env: $AGENT_GATE_SKIP"
+  exit 0
+fi
+
+STAGED=$(git diff --cached --name-only 2>/dev/null || true)
+[ -z "$STAGED" ] && exit 0
+
+# ── Detectar arquivos novos de persona em .claude/agents/ ────────────────────
+# --diff-filter=A = apenas arquivos adicionados (novos)
+NEW_AGENTS=$(git diff --cached --name-only --diff-filter=A 2>/dev/null \
+  | grep -E "^\.claude/agents/[^/]+\.md$" \
+  | grep -vE "\-brief\.md$" \
+  | grep -vE "\-template\.md$" \
+  || true)
+
+[ -z "$NEW_AGENTS" ] && exit 0
+
+echo "  [15] agent-gate ativado: novos agentes detectados"
+
+# ── Processar cada arquivo de agente novo ─────────────────────────────────────
+GATE_FAILED=0
+
+while IFS= read -r AGENT_FILE; do
+  echo "  [15] verificando: $AGENT_FILE"
+
+  # Extrair as primeiras 10 linhas do arquivo staged
+  FRONTMATTER=$(git show ":$AGENT_FILE" 2>/dev/null | head -10 || true)
+
+  # Extrair name: e model: do frontmatter
+  HAS_NAME=$(echo "$FRONTMATTER" | grep -cE "^name: *[^[:space:]]+" || true)
+  HAS_MODEL=$(echo "$FRONTMATTER" | grep -cE "^model: *[^[:space:]]+" || true)
+
+  # ── Discriminação: fragmento vs persona ──────────────────────────────────
+  if [ "$HAS_NAME" -eq 0 ] || [ "$HAS_MODEL" -eq 0 ]; then
+    echo ""
+    echo "  [15] ⚠️  AVISO: frontmatter incompleto em $AGENT_FILE"
+    echo "  [15]    complete frontmatter com name: + model: ou renomeie para *-brief.md"
+    echo ""
+    # Warn apenas, não bloqueia
+    continue
+  fi
+
+  # Extrair o nome do agente
+  NAME=$(echo "$FRONTMATTER" | grep -oE "^name: *[^[:space:]]+" | head -1 | sed 's/^name: *//')
+
+  echo "  [15] persona detectada: '$NAME'"
+
+  # ── Verificar escape: status: agent_candidate ─────────────────────────────
+  IS_CANDIDATE=$(echo "$FRONTMATTER" | grep -cE "^status: *agent_candidate" || true)
+  if [ "$IS_CANDIDATE" -gt 0 ]; then
+    echo "  [15] ⚠️  CANDIDATO: '$NAME' — obrigações pendentes (ver AGENT-GATE-001)"
+    echo "  [15]    status: agent_candidate detectado — checagens puladas"
+    continue
+  fi
+
+  # ── Obrigação 1: NAME em EGOS_AGENT_ORGANIZATION.md ──────────────────────
+  ROSTER_FILE="docs/governance/EGOS_AGENT_ORGANIZATION.md"
+  if [ ! -f "$ROSTER_FILE" ]; then
+    echo ""
+    echo "  [15] ❌ AGENT-GATE: $ROSTER_FILE não encontrado"
+    GATE_FAILED=1
+    continue
+  fi
+
+  if ! grep -qi "$NAME" "$ROSTER_FILE" 2>/dev/null; then
+    echo ""
+    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' não está no roster $ROSTER_FILE §1"
+    echo "  [15]    Resolução: adicione '$NAME' em $ROSTER_FILE §1"
+    GATE_FAILED=1
+  else
+    echo "  [15] ✅ roster OK: '$NAME' encontrado em $ROSTER_FILE"
+  fi
+
+  # ── Obrigação 2: NAME em agents/registry/triggers.json ───────────────────
+  TRIGGERS_FILE="agents/registry/triggers.json"
+  if [ ! -f "$TRIGGERS_FILE" ]; then
+    echo ""
+    echo "  [15] ❌ AGENT-GATE: $TRIGGERS_FILE não encontrado"
+    GATE_FAILED=1
+  elif ! grep -q "$NAME" "$TRIGGERS_FILE" 2>/dev/null; then
+    echo ""
+    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem entrada em agents/registry/triggers.json"
+    echo "  [15]    Resolução: adicione '$NAME' em agents/registry/triggers.json"
+    GATE_FAILED=1
+  else
+    echo "  [15] ✅ triggers OK: '$NAME' encontrado em $TRIGGERS_FILE"
+  fi
+
+  # ── Obrigação 3: golden case em tests/eval/ ───────────────────────────────
+  EVAL_DIR="tests/eval"
+  if [ ! -d "$EVAL_DIR" ]; then
+    echo ""
+    echo "  [15] ❌ AGENT-GATE: diretório $EVAL_DIR não encontrado"
+    GATE_FAILED=1
+  else
+    GOLDEN_COUNT=$(find "$EVAL_DIR" -name "*${NAME}*" 2>/dev/null | wc -l || echo 0)
+    if [ "$GOLDEN_COUNT" -eq 0 ]; then
+      echo ""
+      echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem golden case em tests/eval/ (R7 — ≥1 obrigatório)"
+      echo "  [15]    Resolução: crie tests/eval/${NAME}-golden.md"
+      GATE_FAILED=1
+    else
+      echo "  [15] ✅ golden OK: $GOLDEN_COUNT arquivo(s) em $EVAL_DIR para '$NAME'"
+    fi
+  fi
+
+done <<< "$NEW_AGENTS"
+
+# ── Bloqueio se alguma obrigação falhou ───────────────────────────────────────
+if [ "$GATE_FAILED" -ne 0 ]; then
+  echo ""
+  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
+  echo "  [15] ❌ AGENT-GATE-001: persona LLM sem obrigações cumpridas"
+  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
+  echo ""
+  echo "  Para cada nova persona em .claude/agents/<name>.md, você precisa:"
+  echo ""
+  echo "  1. Registrar no roster:"
+  echo "       docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
+  echo ""
+  echo "  2. Registrar nos triggers:"
+  echo "       agents/registry/triggers.json"
+  echo ""
+  echo "  3. Criar ao menos 1 golden case:"
+  echo "       tests/eval/<name>-golden.md"
+  echo ""
+  echo "  ── ESCAPES ──────────────────────────────────────────────────────"
+  echo "  • Frontmatter do agente:  status: agent_candidate"
+  echo "    (warn apenas; obrigações ficam pendentes para commit futuro)"
+  echo ""
+  echo "  • Env var:      AGENT_GATE_SKIP=<razão> git commit ..."
+  echo ""
+  echo "  SSOT: AGENT-GATE-001 | docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
+  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
+  echo ""
+  exit 1
+fi
+
+exit 0
diff --git a/TASKS.md b/TASKS.md
index 1868e78a..2ce2736d 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -96,12 +96,7 @@
 
 > **Diagnóstico:** o Mycelium existe em 3 versões que não conversam: (a) grafo hardcoded em MyceliumPage.tsx, (b) referenceGraph em egos-lab jamais lido pelo frontend, (c) bus EventEmitter com 7 publishers e 0 subscribers reais. Solução: snapshot gerado da realidade → tudo lê o mesmo arquivo.
 > **Regra dura:** nenhuma task FIND nova neste programa enquanto fila RESOLVE P0+P1 > 5 itens. "Encontrar é barato, fechar é o produto."
-
-- [ ] **MYCELIUM-001** [P0] `forja` `gated:none`
-  Origin: corte Enio 2026-06-10 · L: 3×3×3=27
-  AC: `~/.egos/mycelium-snapshot.json` existe com ≥40 nós; `graphHealth()` retorna sem órfãos inesperados
-  Proof: `ls -la ~/.egos/mycelium-snapshot.json && jq '.nodes | length' ~/.egos/mycelium-snapshot.json`
-  **mycelium-snapshot.ts:** GERA grafo da realidade (agents.json + triggers.json + .mcp.json + crontab + repos git machine-wide) usando schema `reference-graph.ts` existente → escreve `~/.egos/mycelium-snapshot.json`
+> **MYCELIUM-001 ✅ FECHADA** (archive L3846): snapshot REAL em `~/.egos/mycelium-snapshot.json` — 103 nós/129 arestas, 0 órfãos, gerado por `scripts/mycelium-snapshot.ts`.
 
 - [ ] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001`
   Origin: corte Enio 2026-06-10 · L: 3×3×3=27
@@ -455,11 +450,7 @@
 
 > **Origem:** criei `.claude/agents/neon.md` e chamei de "agente" sem ele cumprir as obrigações (R7 golden cases, roster, guardrails). Os gates 13/14 do pre-commit são CEGOS para `.claude/agents/` (`.husky/_checks/14-discover-gate.sh:43-56`, `scripts/check-registry-parity.sh:260`). **Mesma doença do R-ARCH-001** (`SEMANTIC_RULE_ENFORCEMENT_ARCH.md`): falha de DESCOBERTA (obrigação espalhada em 10 arquivos), não de gate. Diferença: agente é regra ESTRUTURAL → gate determinístico resolve 100% (sem LLM). É o caso fácil que prova o método. Princípio Enio: "só pode chamar de agente se for testado, validado, documentado, com tools/skills/capacidades claras". Desenho aprovado: fail-closed + escape `status: agent_candidate` no frontmatter.
 
-- [ ] **AGENT-GATE-001** [P0] `prime`+`forja` — Gate determinístico de criação de agente. (1) `forja` cria `.husky/_checks/15-agent-gate.sh` espelhando o gate 14: dispara em novo `.claude/agents/*.md` (`--diff-filter=A`, ≠ `*-brief.md`); discrimina persona de fragmento por frontmatter (`name:`+`model:`); exige **roster** (`EGOS_AGENT_ORGANIZATION.md` §1) + **triggers.json** + **golden case** (`tests/eval/**/<name>*`) — guardrails.yaml = WARN (standard ainda draft). Escape honesto: `status: agent_candidate` no frontmatter → libera com warn ("candidato, não verified"). Escape emergência: `AGENT-GATE-SKIP:` no commit body. Fail-closed. (2) `forja` entrega TESTE standalone (dummy agent bloqueia; candidate passa) — NÃO commita. (3) `prime` fia em `.husky/pre-commit` (FROZEN ZONE — só Prime) + live test real. Liga `SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
-- [ ] **AGENT-DOD-001** [P1] `prime`+`curador` — Consolidar a "definition of done" de agente numa SSOT ÚNICA (mata os 10 arquivos espalhados = a causa-raiz de descoberta). Estender `.guarani/AGENT_CHECKLIST.md` (ou seção canônica) cobrindo AMBOS os tipos: persona LLM (`.claude/agents/`) E executável (`agents.json`). O gate AGENT-GATE-001 aponta a mensagem de bloqueio pra ela. Inventário completo das obrigações: 2 Sonnets já mapearam (10 fontes, 60% consolidado/40% espalhado, contradição SSOT ECOSYSTEM_REGISTRY vs EGOS_AGENT_ORGANIZATION §1.1).
-- [ ] **NEON-HONEST-001** [P1] `prime`+`forja` — Tornar o `neon` honesto e compliant com seu próprio gate: (a) marcar `status: agent_candidate` no frontmatter; (b) corrigir seção "Fontes de Pesquisa" — neon GERA metaprompt + `.md` para plataformas externas (Perplexity/Grok/ChatGPT manual), **NÃO** chama OpenRouter API (corte Enio 2026-06-10: não queimar créditos OpenRouter em pesquisa); (c) adicionar linha-candidato no roster `EGOS_AGENT_ORGANIZATION.md` §1 marcada CANDIDATO.
 - [ ] **NEON-PROMOTE-001** [P2] `prime`+`provador` — (futuro, SE mantivermos neon) Promover candidato→verified: ≥3 golden cases `tests/eval/capabilities/CBC-NEON-*` provando o pipeline 9-etapas (STEPPS/Fogg/ABCD), entrada `triggers.json` (upstream Prime, downstream Voz+Provador, peers `*`, gates), `guardrails.yaml` (kind:agent, L3.hitl). Só então remove `agent_candidate`.
-- [ ] **AGENT-GATE-FAMILY-001** [P2] `prime` — Após AGENT-GATE-001 provado: registrar em `SEMANTIC_RULE_ENFORCEMENT_ARCH.md` como o "caso estrutural fácil" da mesma família (prova o padrão determinístico antes do caso semântico/LLM); nota em AGENTS.md; disseminar gate aos leaves com `.claude/agents/`.
 - [/] **TASKS-ROADMAP-001** [P1] — Mover pending de longo prazo p/ `docs/strategy/ROADMAP.md` (TASKS.md > hard-limit 600, grace até 2026-06-15). Archive só remove done. **PARCIAL 2026-06-03 (Prime):** bloco AUTORES v2 Fase 0-4 movido (895→796L, 9 tasks). Resto = corte do Enio sobre quais P1/P0 abertos deferir (não deferir unilateralmente).
 
 ## 🎯 LOOP DE AQUISIÇÃO + ENTREGA #3-#7 — North Star (council 2026-05-30)
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index d81ada98..d69a06a4 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3839,3 +3839,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 
 ### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
 
+
+## Archived 2026-06-10
+
+### 🕸️ MYCELIUM v1 — interconexão REAL (corte Enio 2026-06-10, P0 — 1 ano de tentativa, 3 grafos divergentes, bus 7-pub/0-sub)
+- [x] **MYCELIUM-001** [P0] `forja` `gated:none`
+
+### 🚪 AGENT-GATE — enforcement de criação de agente (Opus arquitetou 2026-06-10, pós-falha neon)
+- [x] **AGENT-GATE-001** [P0] `prime`+`forja` — Gate determinístico de criação de agente. (1) `forja` cria `.husky/_checks/15-agent-gate.sh` espelhando o gate 14: dispara em novo `.claude/agents/*.md` (`--diff-filter=A`, ≠ `*-brief.md`); discrimina persona de fragmento por frontmatter (`name:`+`model:`); exige **roster** (`EGOS_AGENT_ORGANIZATION.md` §1) + **triggers.json** + **golden case** (`tests/eval/**/<name>*`) — guardrails.yaml = WARN (standard ainda draft). Escape honesto: `status: agent_candidate` no frontmatter → libera com warn ("candidato, não verified"). Escape emergência: `AGENT-GATE-SKIP:` no commit body. Fail-closed. (2) `forja` entrega TESTE standalone (dummy agent bloqueia; candidate passa) — NÃO commita. (3) `prime` fia em `.husky/pre-commit` (FROZEN ZONE — só Prime) + live test real. Liga `SEMANTIC_RULE_ENFORCEMENT_ARCH.md`. ✅ 2026-06-09
+- [x] **AGENT-DOD-001** [P1] `prime`+`curador` — Consolidar a "definition of done" de agente numa SSOT ÚNICA (mata os 10 arquivos espalhados = a causa-raiz de descoberta). Estender `.guarani/AGENT_CHECKLIST.md` (ou seção canônica) cobrindo AMBOS os tipos: persona LLM (`.claude/agents/`) E executável (`agents.json`). O gate AGENT-GATE-001 aponta a mensagem de bloqueio pra ela. Inventário completo das obrigações: 2 Sonnets já mapearam (10 fontes, 60% consolidado/40% espalhado, contradição SSOT ECOSYSTEM_REGISTRY vs EGOS_AGENT_ORGANIZATION §1.1). ✅ 2026-06-09
+- [x] **NEON-HONEST-001** [P1] `prime`+`forja` — Tornar o `neon` honesto e compliant com seu próprio gate: (a) marcar `status: agent_candidate` no frontmatter; (b) corrigir seção "Fontes de Pesquisa" — neon GERA metaprompt + `.md` para plataformas externas (Perplexity/Grok/ChatGPT manual), **NÃO** chama OpenRouter API (corte Enio 2026-06-10: não queimar créditos OpenRouter em pesquisa); (c) adicionar linha-candidato no roster `EGOS_AGENT_ORGANIZATION.md` §1 marcada CANDIDATO. ✅ 2026-06-09
+- [x] **AGENT-GATE-FAMILY-001** [P2] `prime` — Após AGENT-GATE-001 provado: registrar em `SEMANTIC_RULE_ENFORCEMENT_ARCH.md` como o "caso estrutural fácil" da mesma família (prova o padrão determinístico antes do caso semântico/LLM); nota em AGENTS.md; disseminar gate aos leaves com `.claude/agents/`. ✅ 2026-06-09
+
diff --git a/docs/concepts/mycelium/MYCELIUM_OVERVIEW.md b/docs/concepts/mycelium/MYCELIUM_OVERVIEW.md
index f34aea19..65793efb 100644
--- a/docs/concepts/mycelium/MYCELIUM_OVERVIEW.md
+++ b/docs/concepts/mycelium/MYCELIUM_OVERVIEW.md
@@ -1,11 +1,54 @@
 # Repository Mesh (Mycelium): Ecossistema EGOS
 
-> **Data:** 2026-04-09 | **Versão:** 1.1.0 | **EGOS-118** — Nome técnico: Repository Mesh
+> **Data:** 2026-04-09 | **Versão:** 1.2.0 | **EGOS-118** — Nome técnico: Repository Mesh
 > **Status:** Visão canônica consolidada
 > **Metáfora:** "O Sistema Radicular Fúngico". Assim como o micélio conecta florestas há bilhões de anos, transportando nutrientes e sinais de alerta, o **Repository Mesh** (codename: Mycelium) conecta superfícies, eventos e referências do ecossistema EGOS.
-> 
+>
 > **Nota sobre nomenclatura:** "Repository Mesh" é o nome técnico padrão (EGOS-118). "Mycelium" permanece como codename reconhecido por voz para compatibilidade com comandos históricos.
 
+---
+
+## Definição constitucional (corte Enio 2026-06-10)
+
+**Mycelium é o grafo de identidades do EGOS: o registro vivo de quem existe, para quê existe, e como se relaciona — gerado da realidade, nunca escrito à mão. Objetivo: tornar todo nó DESCOBRÍVEL e toda relação AUDITÁVEL — pré-condição para orquestrar sem colisão e compor/dissolver partes sem perder rastro.**
+
+### R-MYC-001 — Nó sem ego não entra no grafo
+
+**Ego** = 7 campos obrigatórios:
+
+| Campo | Descrição |
+|-------|-----------|
+| `nome` | ID canônico (imutável) |
+| `objetivo` | O que "feito" significa para este nó |
+| `regras` | O que pode fazer / nunca pode fazer |
+| `fronteiras_dados` | PII / secrets / scope de dados que toca |
+| `relacoes` | upstream / downstream / gates que dispara |
+| `substrato` | modelo / runtime / tier |
+| `estado_prova` | `active` / `degraded` / `planned` com evidência verificável |
+
+Nó real sem ego completo entra como `shadow_node` (tipo canônico no schema `reference-graph.ts`) — **visível, não-integrado, cobrando nomeação**. O `shadow_node` sinaliza dívida de identidade: o nó existe na realidade mas não declarou quem é.
+
+**Lifecycle (individuação):**
+1. **Diferenciação** — ganha ego completo (os 7 campos preenchidos)
+2. **Ida ao mundo** — entra no grafo com tipo pleno, declara arestas (upstream/downstream/gates)
+3. **Integração/dissolução** — composto, fundido ou aposentado sem perder auditoria (arestas permanecem com nota `dissolved_at`)
+
+**Fundamento:** `docs/soul/EGOS_SOUL.md` (Shadow Governance) + corte Enio 2026-06-10.
+
+### "Agente" neste contexto
+
+**Agente** = qualquer nó com ego completo que **age**: papel Claude, worker TypeScript, MCP, serviço, daemon. O critério não é o runtime — é a presença do ego (os 7 campos) combinada com capacidade de ação autônoma.
+
+---
+
+## Changelog
+
+| Versão | Data | Mudança |
+|--------|------|---------|
+| 1.2.0 | 2026-06-10 | Definição constitucional R-MYC-001 + conceito de ego/shadow_node/lifecycle (corte Enio) |
+| 1.1.0 | 2026-04-09 | EGOS-118: separação camadas (Bus / Snapshot / Reference Graph / Legado) |
+| 1.0.0 | — | Versão inicial |
+
 <!-- llmrefs:start -->
 
 ## LLM Reference Signature
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 8438dcce..5b2c4f56 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -6077,3 +6077,7 @@ Divisão clara de papéis e canais de transferência física local (`docs/_curre
 
 ### Key Rule
 Nunca competir por commits. O Guarani propõe patches e rascunha as análises de forma assíncrona; o Prime valida, commita e envia. O uso de arquivos de transferência locais elimina a latência de rede e reduz a fricção cognitiva, permitindo velocidade máxima de pair-programming agentic.
+
+### Auto-harvested — 9af71508 (2026-06-09)
+
+- model-ID hardcoded em 20+ arquivos = sem fonte única; candidato a MODEL_CONFIG central (liga Patch 3 papel→modelo).
diff --git a/scripts/mycelium-snapshot.ts b/scripts/mycelium-snapshot.ts
new file mode 100644
index 00000000..f627812b
--- /dev/null
+++ b/scripts/mycelium-snapshot.ts
@@ -0,0 +1,618 @@
+#!/usr/bin/env bun
+/**
+ * mycelium-snapshot.ts — MYCELIUM-001
+ *
+ * Gera o grafo de identidades do EGOS da realidade e escreve:
+ *   ~/.egos/mycelium-snapshot.json
+ *   /tmp/egos-mycelium-snapshot.json
+ *
+ * Fontes:
+ *   1. Repos git da máquina (ls /home/enio/*  com .git)
+ *   2. agents/registry/triggers.json → 12 papéis com arestas
+ *   3. agents/registry/agents.json → workers com status real
+ *   4. .mcp.json → integrações MCP (shadow_node)
+ *   5. crontab -l → triggers agendados
+ *   6. Serviços/portas conhecidos → endpoints (shadow_node)
+ *
+ * Usage:
+ *   bun scripts/mycelium-snapshot.ts --dry
+ *   bun scripts/mycelium-snapshot.ts --exec
+ */
+
+import { execSync } from 'child_process';
+import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'fs';
+import { homedir } from 'os';
+import { join } from 'path';
+
+import type {
+  NodeStatus,
+  ReferenceEdge,
+  ReferenceGraph,
+  ReferenceNode,
+} from '../packages/shared/src/mycelium/reference-graph.ts';
+import { graphHealth } from '../packages/shared/src/mycelium/reference-graph.ts';
+
+// ═══════════════════════════════════════════════════════════
+// CLI
+// ═══════════════════════════════════════════════════════════
+
+const args = process.argv.slice(2);
+const DRY = args.includes('--dry') || !args.includes('--exec');
+
+const REPO_ROOT = join(import.meta.dir, '..');
+const HOME = homedir();
+const NOW_S = Math.floor(Date.now() / 1000);
+const THIRTY_DAYS = 30 * 24 * 3600;
+const NINETY_DAYS = 90 * 24 * 3600;
+
+// ═══════════════════════════════════════════════════════════
+// Helpers
+// ═══════════════════════════════════════════════════════════
+
+function gitLastCommitTs(repoPath: string): number | null {
+  try {
+    const ts = execSync(`git -C "${repoPath}" log -1 --format="%ct" 2>/dev/null`, {
+      encoding: 'utf8',
+      timeout: 5000,
+    }).trim();
+    return ts ? parseInt(ts, 10) : null;
+  } catch {
+    return null;
+  }
+}
+
+function repoStatus(lastCommitTs: number | null): NodeStatus {
+  if (lastCommitTs === null) return 'offline';
+  const age = NOW_S - lastCommitTs;
+  if (age < THIRTY_DAYS) return 'active';
+  if (age < NINETY_DAYS) return 'degraded';
+  return 'offline';
+}
+
+function readJsonSafe<T>(filePath: string): T | null {
+  try {
+    return JSON.parse(readFileSync(filePath, 'utf8')) as T;
+  } catch {
+    return null;
+  }
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 1 — Git repos
+// ═══════════════════════════════════════════════════════════
+
+const EXCLUDE_DIRS = new Set([
+  'node_modules', 'Trash', '.trash', 'archive', 'Archives',
+  'android-sdk', 'snap', 'go', 'bin', 'models', 'lancedb',
+  'ProgramasRFB', 'IRPF2026', 'anythingllm',
+  'antigravity-backup-20260402', 'antigravity-preserve-20260323-180052',
+  'antigravity-preserve-20260323-180054',
+  'egos_notebooklm_COMPLETO_2026-05-04', 'egos_templates_setoriais_2026-05-05',
+  'EGOSv2', 'EGOSv3', 'vps-backup-hetzner', 'windsurf_backups',
+  'backupfotosjessica', 'backups', 'backup',
+  'Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Public', 'Templates', 'Videos',
+  'reorganization-scripts', 'research-studies', 'testesEXAMES', 'INPI',
+  'Obsidian Vault', 'marizanotto-videos', 'CascadeProjects',
+]);
+
+function buildRepoNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  let homeDirs: string[];
+  try {
+    const raw = execSync(`ls -d /home/enio/*/`, { encoding: 'utf8', timeout: 5000 });
+    homeDirs = raw.trim().split('\n').map(d => d.replace(/\/$/, ''));
+  } catch {
+    homeDirs = [];
+  }
+
+  const WORKSPACE_ID = 'ws:egos-kernel';
+
+  for (const dirPath of homeDirs) {
+    const name = dirPath.split('/').pop() ?? '';
+    if (EXCLUDE_DIRS.has(name)) continue;
+    if (!existsSync(join(dirPath, '.git'))) continue;
+
+    const ts = gitLastCommitTs(dirPath);
+    const status = repoStatus(ts);
+    const id = `repo:${name}`;
+
+    // egos kernel is already represented as ws:egos-kernel — skip as duplicate repository
+    if (name === 'egos') continue;
+
+    nodes.push({
+      id,
+      type: 'repository',
+      label: name,
+      status,
+      evidence: ['code'],
+      sourcePath: dirPath,
+      note: ts ? `last_commit: ${new Date(ts * 1000).toISOString().slice(0, 10)}` : 'no commits found',
+    });
+
+    edges.push({
+      from: WORKSPACE_ID,
+      relation: 'governs',
+      to: id,
+      evidence: ['code'],
+      note: 'workspace governance',
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 2 — triggers.json → 12 papéis EGOS
+// ═══════════════════════════════════════════════════════════
+
+interface TriggerAgent {
+  tier: string;
+  runtime: string;
+  role: string;
+  upstream: string[];
+  downstream: string[];
+  trigger: string;
+  gates: string[];
+  peers: string;
+  dispatchable?: boolean;
+  note?: string;
+}
+
+interface TriggersJson {
+  roster: string[];
+  agents: Record<string, TriggerAgent>;
+  gates: Record<string, { requester: string; approver: string; hitl: boolean; reason: string; wired: boolean }>;
+}
+
+function buildAgentNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  const triggersPath = join(REPO_ROOT, 'agents/registry/triggers.json');
+  const data = readJsonSafe<TriggersJson>(triggersPath);
+  if (!data) return { nodes, edges };
+
+  for (const agentName of data.roster) {
+    const def = data.agents[agentName];
+    if (!def) continue;
+
+    const id = `agent:${agentName}`;
+    nodes.push({
+      id,
+      type: 'agent',
+      label: agentName,
+      status: 'active', // all roster agents in triggers.json are active by definition
+      evidence: ['code'],
+      sourcePath: triggersPath,
+      tags: [`tier:${def.tier}`, `runtime:${def.runtime}`],
+      note: def.role,
+    });
+
+    // Upstream → this agent
+    for (const up of def.upstream) {
+      edges.push({
+        from: `agent:${up}`,
+        relation: 'routes_to',
+        to: id,
+        evidence: ['code'],
+        note: 'upstream handoff',
+      });
+    }
+
+    // This agent → downstream
+    for (const down of def.downstream) {
+      edges.push({
+        from: id,
+        relation: 'routes_to',
+        to: `agent:${down}`,
+        evidence: ['code'],
+        note: 'downstream handoff',
+      });
+    }
+
+    // Gates this agent fires
+    for (const gate of def.gates) {
+      const gateId = `policy:gate-${gate}`;
+      edges.push({
+        from: id,
+        relation: 'validates',
+        to: gateId,
+        evidence: ['code'],
+        note: `fires gate: ${gate}`,
+      });
+    }
+
+    // Belongs to egos kernel
+    edges.push({
+      from: id,
+      relation: 'belongs_to',
+      to: 'ws:egos-kernel',
+      evidence: ['code'],
+    });
+  }
+
+  // Add gate policy nodes
+  for (const [gateName, gateDef] of Object.entries(data.gates ?? {})) {
+    const id = `policy:gate-${gateName}`;
+    nodes.push({
+      id,
+      type: 'policy',
+      label: `Gate: ${gateName}`,
+      status: gateDef.wired ? 'active' : 'planned',
+      evidence: ['code'],
+      sourcePath: triggersPath,
+      note: gateDef.reason,
+      tags: [gateDef.hitl ? 'hitl' : 'auto', gateDef.wired ? 'wired' : 'unwired'],
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 3 — agents.json → workers
+// ═══════════════════════════════════════════════════════════
+
+interface AgentEntry {
+  id: string;
+  name: string;
+  kind: string;
+  description: string;
+  area: string;
+  entrypoint: string;
+  status: string;
+  last_run_date?: string;
+  last_status?: string;
+  approval_level?: string;
+}
+
+interface AgentsJson {
+  agents: AgentEntry[];
+}
+
+function buildWorkerNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  const agentsPath = join(REPO_ROOT, 'agents/registry/agents.json');
+  const data = readJsonSafe<AgentsJson>(agentsPath);
+  if (!data) return { nodes, edges };
+
+  for (const agent of data.agents) {
+    const id = `worker:${agent.id}`;
+    const rawStatus = agent.status ?? 'planned';
+    const status: NodeStatus = (['active', 'degraded', 'offline', 'planned'] as NodeStatus[]).includes(rawStatus as NodeStatus)
+      ? (rawStatus as NodeStatus)
+      : 'planned';
+
+    nodes.push({
+      id,
+      type: 'worker',
+      label: agent.name,
+      status,
+      evidence: ['code'],
+      sourcePath: agent.entrypoint,
+      tags: [`area:${agent.area}`, `kind:${agent.kind}`],
+      note: agent.description.slice(0, 80),
+    });
+
+    edges.push({
+      from: id,
+      relation: 'belongs_to',
+      to: 'ws:egos-kernel',
+      evidence: ['code'],
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 4 — .mcp.json → MCP integrations (shadow_node)
+// ═══════════════════════════════════════════════════════════
+
+interface McpJson {
+  mcpServers: Record<string, { command: string; args: string[]; description?: string }>;
+}
+
+function buildMcpNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  const mcpPath = join(REPO_ROOT, '.mcp.json');
+  const data = readJsonSafe<McpJson>(mcpPath);
+  if (!data) return { nodes, edges };
+
+  for (const [serverName, serverDef] of Object.entries(data.mcpServers)) {
+    const id = `integration:mcp-${serverName}`;
+    nodes.push({
+      id,
+      type: 'shadow_node',
+      label: `MCP: ${serverName}`,
+      status: 'active',
+      evidence: ['code'],
+      sourcePath: serverDef.args?.[0] ?? mcpPath,
+      tags: ['mcp', 'integration'],
+      note: 'R-MYC-001: aguarda identity card (ego incompleto — faltam: objetivo canonico, regras, fronteiras_dados)',
+    });
+
+    edges.push({
+      from: id,
+      relation: 'belongs_to',
+      to: 'ws:egos-kernel',
+      evidence: ['code'],
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 5 — crontab → trigger nodes
+// ═══════════════════════════════════════════════════════════
+
+function buildCronNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  let crontabOutput = '';
+  try {
+    crontabOutput = execSync('crontab -l 2>/dev/null', { encoding: 'utf8', timeout: 5000 });
+  } catch {
+    return { nodes, edges };
+  }
+
+  const lines = crontabOutput.split('\n').filter(l => l.trim() && !l.trim().startsWith('#'));
+
+  for (const line of lines) {
+    // Match cron schedule lines: "*/15 * * * * command..."
+    const match = line.match(/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+)\s+(.+)$/);
+    if (!match) continue;
+
+    const schedule = match[1];
+    const command = match[2].trim();
+
+    // Extract script name from command for a readable ID
+    const scriptMatch = command.match(/(?:bun|bash|python3?)\s+([^\s]+)/);
+    const scriptName = scriptMatch?.[1]?.split('/').pop()?.replace(/\.\w+$/, '') ?? 'unknown-cron';
+    const id = `trigger:cron-${scriptName}-${Buffer.from(schedule).toString('base64').slice(0, 8)}`;
+
+    nodes.push({
+      id,
+      type: 'trigger',
+      label: `cron: ${scriptName}`,
+      status: 'active',
+      evidence: ['code'],
+      sourcePath: scriptMatch?.[1] ?? '',
+      note: `schedule: ${schedule}`,
+      tags: ['cron'],
+    });
+
+    // Trigger emits to script/worker if we can identify it
+    const entrypointId = scriptMatch?.[1]
+      ? `worker:${scriptName}`
+      : null;
+
+    if (entrypointId) {
+      edges.push({
+        from: id,
+        relation: 'emits',
+        to: entrypointId,
+        evidence: ['code'],
+        note: `schedule: ${schedule}`,
+      });
+    }
+
+    edges.push({
+      from: id,
+      relation: 'belongs_to',
+      to: 'ws:egos-kernel',
+      evidence: ['code'],
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Source 6 — Known endpoints/services (shadow_node)
+// ═══════════════════════════════════════════════════════════
+
+const KNOWN_ENDPOINTS = [
+  { id: 'endpoint:egos-gateway', label: 'egos-gateway', port: 3050, repo: 'apps/egos-gateway' },
+  { id: 'endpoint:egos-lab-chat', label: 'egos-lab-chat', port: 3095, repo: 'egos-lab-chat' },
+  { id: 'endpoint:mcp-governance', label: 'MCP Governance', port: 7001, repo: 'packages/mcp-governance' },
+  { id: 'endpoint:mcp-memory', label: 'MCP Memory', port: 7002, repo: 'packages/mcp-memory' },
+  { id: 'endpoint:mcp-knowledge', label: 'MCP Knowledge', port: 7003, repo: 'packages/knowledge-mcp' },
+  { id: 'endpoint:mcp-security', label: 'MCP Security', port: 7004, repo: 'packages/guard-brasil-mcp' },
+  { id: 'endpoint:mcp-eval-runner', label: 'MCP Eval Runner', port: 7005, repo: 'packages/mcp-eval-runner' },
+  { id: 'endpoint:mcp-ops', label: 'MCP Ops', port: 7006, repo: 'packages/mcp-ops' },
+  { id: 'endpoint:mcp-skills-registry', label: 'MCP Skills Registry', port: 7007, repo: 'packages/mcp-skills-registry' },
+  { id: 'endpoint:mcp-observability', label: 'MCP Observability', port: 7008, repo: 'packages/mcp-observability' },
+  { id: 'endpoint:mcp-browser-automation', label: 'MCP Browser Automation', port: 7009, repo: 'packages/mcp-browser-automation' },
+];
+
+function buildEndpointNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
+  const nodes: ReferenceNode[] = [];
+  const edges: ReferenceEdge[] = [];
+
+  for (const ep of KNOWN_ENDPOINTS) {
+    nodes.push({
+      id: ep.id,
+      type: 'shadow_node',
+      label: ep.label,
+      status: 'planned', // unknown without live check — shadow_node
+      evidence: ['plan'],
+      sourcePath: ep.repo,
+      tags: ['endpoint', `port:${ep.port}`],
+      note: 'R-MYC-001: shadow_node sem ego completo — faltam: objetivo, regras, fronteiras_dados verificados em runtime',
+    });
+
+    edges.push({
+      from: ep.id,
+      relation: 'belongs_to',
+      to: 'ws:egos-kernel',
+      evidence: ['plan'],
+    });
+  }
+
+  return { nodes, edges };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Workspace root node (anchor)
+// ═══════════════════════════════════════════════════════════
+
+function buildWorkspaceNode(): ReferenceNode {
+  return {
+    id: 'ws:egos-kernel',
+    type: 'workspace_root',
+    label: 'EGOS Kernel (/home/enio/egos)',
+    status: 'active',
+    evidence: ['code', 'runtime'],
+    sourcePath: REPO_ROOT,
+    note: 'root anchor — todos os nós do ecossistema pertencem ou são governados por este workspace',
+  };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Dedup — merge arestas duplicadas
+// ═══════════════════════════════════════════════════════════
+
+function deduplicateEdges(edges: ReferenceEdge[]): ReferenceEdge[] {
+  const seen = new Set<string>();
+  return edges.filter(e => {
+    const key = `${e.from}|${e.relation}|${e.to}`;
+    if (seen.has(key)) return false;
+    seen.add(key);
+    return true;
+  });
+}
+
+// ═══════════════════════════════════════════════════════════
+// Build full graph
+// ═══════════════════════════════════════════════════════════
+
+function buildGraph(): ReferenceGraph {
+  const allNodes: ReferenceNode[] = [];
+  const allEdges: ReferenceEdge[] = [];
+
+  // Workspace anchor
+  allNodes.push(buildWorkspaceNode());
+
+  // Source 1: repos
+  const repos = buildRepoNodes();
+  allNodes.push(...repos.nodes);
+  allEdges.push(...repos.edges);
+
+  // Source 2: trigger agents
+  const agents = buildAgentNodes();
+  allNodes.push(...agents.nodes);
+  allEdges.push(...agents.edges);
+
+  // Source 3: workers
+  const workers = buildWorkerNodes();
+  allNodes.push(...workers.nodes);
+  allEdges.push(...workers.edges);
+
+  // Source 4: MCPs
+  const mcps = buildMcpNodes();
+  allNodes.push(...mcps.nodes);
+  allEdges.push(...mcps.edges);
+
+  // Source 5: cron triggers
+  const crons = buildCronNodes();
+  allNodes.push(...crons.nodes);
+  allEdges.push(...crons.edges);
+
+  // Source 6: known endpoints
+  const endpoints = buildEndpointNodes();
+  allNodes.push(...endpoints.nodes);
+  allEdges.push(...endpoints.edges);
+
+  // Dedup edges
+  const uniqueEdges = deduplicateEdges(allEdges);
+
+  // Remove edges referencing non-existent nodes (dangling)
+  const nodeIds = new Set(allNodes.map(n => n.id));
+  const validEdges = uniqueEdges.filter(e => nodeIds.has(e.from) && nodeIds.has(e.to));
+
+  return {
+    version: '1.0.0',
+    generated: new Date().toISOString(),
+    nodes: allNodes,
+    edges: validEdges,
+  };
+}
+
+// ═══════════════════════════════════════════════════════════
+// Sumário por tipo
+// ═══════════════════════════════════════════════════════════
+
+function printSummary(graph: ReferenceGraph): void {
+  const health = graphHealth(graph);
+
+  // Count by type
+  const byType: Record<string, number> = {};
+  for (const node of graph.nodes) {
+    byType[node.type] = (byType[node.type] ?? 0) + 1;
+  }
+
+  const shadowCount = graph.nodes.filter(n => n.type === 'shadow_node').length;
+
+  console.log('\n══════════════════════════════════════════════');
+  console.log('MYCELIUM SNAPSHOT — SUMÁRIO');
+  console.log('══════════════════════════════════════════════');
+  console.log(`Total nós   : ${health.totalNodes}`);
+  console.log(`Total arestas: ${health.totalEdges}`);
+  console.log(`Active       : ${health.active}`);
+  console.log(`Degraded     : ${health.degraded}`);
+  console.log(`Planned      : ${health.planned}`);
+  console.log(`Offline      : ${health.offline}`);
+  console.log(`Shadow nodes : ${shadowCount}`);
+  console.log('');
+  console.log('Nós por tipo:');
+  for (const [type, count] of Object.entries(byType).sort((a, b) => b[1] - a[1])) {
+    console.log(`  ${type.padEnd(22)} ${count}`);
+  }
+  console.log('');
+  if (health.orphanNodes.length > 0) {
+    console.log(`Orphans (${health.orphanNodes.length}): ${health.orphanNodes.join(', ')}`);
+  } else {
+    console.log('Orphans: NENHUM');
+  }
+  console.log('══════════════════════════════════════════════\n');
+
+  // Sample 2 nodes
+  const sampleNodes = graph.nodes.slice(0, 2);
+  console.log('Amostra (2 nós):');
+  console.log(JSON.stringify(sampleNodes, null, 2));
+}
+
+// ═══════════════════════════════════════════════════════════
+// Main
+// ═══════════════════════════════════════════════════════════
+
+const graph = buildGraph();
+
+printSummary(graph);
+
+if (DRY) {
+  console.log('[--dry] Nenhum arquivo escrito.');
+} else {
+  const egosDir = join(HOME, '.egos');
+  if (!existsSync(egosDir)) mkdirSync(egosDir, { recursive: true });
+
+  const primaryPath = join(egosDir, 'mycelium-snapshot.json');
+  const tmpPath = '/tmp/egos-mycelium-snapshot.json';
+
+  const json = JSON.stringify(graph, null, 2);
+  writeFileSync(primaryPath, json, 'utf8');
+  writeFileSync(tmpPath, json, 'utf8');
+
+  console.log(`[--exec] Snapshot escrito em:`);
+  console.log(`  ${primaryPath}`);
+  console.log(`  ${tmpPath}`);
+}

exec
/bin/bash -lc "sed -n '1,240p' scripts/mycelium-snapshot.ts && sed -n '240,520p' scripts/mycelium-snapshot.ts && sed -n '520,760p' scripts/mycelium-snapshot.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * mycelium-snapshot.ts — MYCELIUM-001
 *
 * Gera o grafo de identidades do EGOS da realidade e escreve:
 *   ~/.egos/mycelium-snapshot.json
 *   /tmp/egos-mycelium-snapshot.json
 *
 * Fontes:
 *   1. Repos git da máquina (ls /home/enio/*  com .git)
 *   2. agents/registry/triggers.json → 12 papéis com arestas
 *   3. agents/registry/agents.json → workers com status real
 *   4. .mcp.json → integrações MCP (shadow_node)
 *   5. crontab -l → triggers agendados
 *   6. Serviços/portas conhecidos → endpoints (shadow_node)
 *
 * Usage:
 *   bun scripts/mycelium-snapshot.ts --dry
 *   bun scripts/mycelium-snapshot.ts --exec
 */

import { execSync } from 'child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'fs';
import { homedir } from 'os';
import { join } from 'path';

import type {
  NodeStatus,
  ReferenceEdge,
  ReferenceGraph,
  ReferenceNode,
} from '../packages/shared/src/mycelium/reference-graph.ts';
import { graphHealth } from '../packages/shared/src/mycelium/reference-graph.ts';

// ═══════════════════════════════════════════════════════════
// CLI
// ═══════════════════════════════════════════════════════════

const args = process.argv.slice(2);
const DRY = args.includes('--dry') || !args.includes('--exec');

const REPO_ROOT = join(import.meta.dir, '..');
const HOME = homedir();
const NOW_S = Math.floor(Date.now() / 1000);
const THIRTY_DAYS = 30 * 24 * 3600;
const NINETY_DAYS = 90 * 24 * 3600;

// ═══════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════

function gitLastCommitTs(repoPath: string): number | null {
  try {
    const ts = execSync(`git -C "${repoPath}" log -1 --format="%ct" 2>/dev/null`, {
      encoding: 'utf8',
      timeout: 5000,
    }).trim();
    return ts ? parseInt(ts, 10) : null;
  } catch {
    return null;
  }
}

function repoStatus(lastCommitTs: number | null): NodeStatus {
  if (lastCommitTs === null) return 'offline';
  const age = NOW_S - lastCommitTs;
  if (age < THIRTY_DAYS) return 'active';
  if (age < NINETY_DAYS) return 'degraded';
  return 'offline';
}

function readJsonSafe<T>(filePath: string): T | null {
  try {
    return JSON.parse(readFileSync(filePath, 'utf8')) as T;
  } catch {
    return null;
  }
}

// ═══════════════════════════════════════════════════════════
// Source 1 — Git repos
// ═══════════════════════════════════════════════════════════

const EXCLUDE_DIRS = new Set([
  'node_modules', 'Trash', '.trash', 'archive', 'Archives',
  'android-sdk', 'snap', 'go', 'bin', 'models', 'lancedb',
  'ProgramasRFB', 'IRPF2026', 'anythingllm',
  'antigravity-backup-20260402', 'antigravity-preserve-20260323-180052',
  'antigravity-preserve-20260323-180054',
  'egos_notebooklm_COMPLETO_2026-05-04', 'egos_templates_setoriais_2026-05-05',
  'EGOSv2', 'EGOSv3', 'vps-backup-hetzner', 'windsurf_backups',
  'backupfotosjessica', 'backups', 'backup',
  'Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Public', 'Templates', 'Videos',
  'reorganization-scripts', 'research-studies', 'testesEXAMES', 'INPI',
  'Obsidian Vault', 'marizanotto-videos', 'CascadeProjects',
]);

function buildRepoNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  let homeDirs: string[];
  try {
    const raw = execSync(`ls -d /home/enio/*/`, { encoding: 'utf8', timeout: 5000 });
    homeDirs = raw.trim().split('\n').map(d => d.replace(/\/$/, ''));
  } catch {
    homeDirs = [];
  }

  const WORKSPACE_ID = 'ws:egos-kernel';

  for (const dirPath of homeDirs) {
    const name = dirPath.split('/').pop() ?? '';
    if (EXCLUDE_DIRS.has(name)) continue;
    if (!existsSync(join(dirPath, '.git'))) continue;

    const ts = gitLastCommitTs(dirPath);
    const status = repoStatus(ts);
    const id = `repo:${name}`;

    // egos kernel is already represented as ws:egos-kernel — skip as duplicate repository
    if (name === 'egos') continue;

    nodes.push({
      id,
      type: 'repository',
      label: name,
      status,
      evidence: ['code'],
      sourcePath: dirPath,
      note: ts ? `last_commit: ${new Date(ts * 1000).toISOString().slice(0, 10)}` : 'no commits found',
    });

    edges.push({
      from: WORKSPACE_ID,
      relation: 'governs',
      to: id,
      evidence: ['code'],
      note: 'workspace governance',
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Source 2 — triggers.json → 12 papéis EGOS
// ═══════════════════════════════════════════════════════════

interface TriggerAgent {
  tier: string;
  runtime: string;
  role: string;
  upstream: string[];
  downstream: string[];
  trigger: string;
  gates: string[];
  peers: string;
  dispatchable?: boolean;
  note?: string;
}

interface TriggersJson {
  roster: string[];
  agents: Record<string, TriggerAgent>;
  gates: Record<string, { requester: string; approver: string; hitl: boolean; reason: string; wired: boolean }>;
}

function buildAgentNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  const triggersPath = join(REPO_ROOT, 'agents/registry/triggers.json');
  const data = readJsonSafe<TriggersJson>(triggersPath);
  if (!data) return { nodes, edges };

  for (const agentName of data.roster) {
    const def = data.agents[agentName];
    if (!def) continue;

    const id = `agent:${agentName}`;
    nodes.push({
      id,
      type: 'agent',
      label: agentName,
      status: 'active', // all roster agents in triggers.json are active by definition
      evidence: ['code'],
      sourcePath: triggersPath,
      tags: [`tier:${def.tier}`, `runtime:${def.runtime}`],
      note: def.role,
    });

    // Upstream → this agent
    for (const up of def.upstream) {
      edges.push({
        from: `agent:${up}`,
        relation: 'routes_to',
        to: id,
        evidence: ['code'],
        note: 'upstream handoff',
      });
    }

    // This agent → downstream
    for (const down of def.downstream) {
      edges.push({
        from: id,
        relation: 'routes_to',
        to: `agent:${down}`,
        evidence: ['code'],
        note: 'downstream handoff',
      });
    }

    // Gates this agent fires
    for (const gate of def.gates) {
      const gateId = `policy:gate-${gate}`;
      edges.push({
        from: id,
        relation: 'validates',
        to: gateId,
        evidence: ['code'],
        note: `fires gate: ${gate}`,
      });
    }

    // Belongs to egos kernel
    edges.push({
      from: id,
      relation: 'belongs_to',
      to: 'ws:egos-kernel',
      evidence: ['code'],
    });
  }

  // Add gate policy nodes
  for (const [gateName, gateDef] of Object.entries(data.gates ?? {})) {
    const id = `policy:gate-${gateName}`;
    nodes.push({
      id,
      id,
      type: 'policy',
      label: `Gate: ${gateName}`,
      status: gateDef.wired ? 'active' : 'planned',
      evidence: ['code'],
      sourcePath: triggersPath,
      note: gateDef.reason,
      tags: [gateDef.hitl ? 'hitl' : 'auto', gateDef.wired ? 'wired' : 'unwired'],
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Source 3 — agents.json → workers
// ═══════════════════════════════════════════════════════════

interface AgentEntry {
  id: string;
  name: string;
  kind: string;
  description: string;
  area: string;
  entrypoint: string;
  status: string;
  last_run_date?: string;
  last_status?: string;
  approval_level?: string;
}

interface AgentsJson {
  agents: AgentEntry[];
}

function buildWorkerNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  const agentsPath = join(REPO_ROOT, 'agents/registry/agents.json');
  const data = readJsonSafe<AgentsJson>(agentsPath);
  if (!data) return { nodes, edges };

  for (const agent of data.agents) {
    const id = `worker:${agent.id}`;
    const rawStatus = agent.status ?? 'planned';
    const status: NodeStatus = (['active', 'degraded', 'offline', 'planned'] as NodeStatus[]).includes(rawStatus as NodeStatus)
      ? (rawStatus as NodeStatus)
      : 'planned';

    nodes.push({
      id,
      type: 'worker',
      label: agent.name,
      status,
      evidence: ['code'],
      sourcePath: agent.entrypoint,
      tags: [`area:${agent.area}`, `kind:${agent.kind}`],
      note: agent.description.slice(0, 80),
    });

    edges.push({
      from: id,
      relation: 'belongs_to',
      to: 'ws:egos-kernel',
      evidence: ['code'],
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Source 4 — .mcp.json → MCP integrations (shadow_node)
// ═══════════════════════════════════════════════════════════

interface McpJson {
  mcpServers: Record<string, { command: string; args: string[]; description?: string }>;
}

function buildMcpNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  const mcpPath = join(REPO_ROOT, '.mcp.json');
  const data = readJsonSafe<McpJson>(mcpPath);
  if (!data) return { nodes, edges };

  for (const [serverName, serverDef] of Object.entries(data.mcpServers)) {
    const id = `integration:mcp-${serverName}`;
    nodes.push({
      id,
      type: 'shadow_node',
      label: `MCP: ${serverName}`,
      status: 'active',
      evidence: ['code'],
      sourcePath: serverDef.args?.[0] ?? mcpPath,
      tags: ['mcp', 'integration'],
      note: 'R-MYC-001: aguarda identity card (ego incompleto — faltam: objetivo canonico, regras, fronteiras_dados)',
    });

    edges.push({
      from: id,
      relation: 'belongs_to',
      to: 'ws:egos-kernel',
      evidence: ['code'],
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Source 5 — crontab → trigger nodes
// ═══════════════════════════════════════════════════════════

function buildCronNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  let crontabOutput = '';
  try {
    crontabOutput = execSync('crontab -l 2>/dev/null', { encoding: 'utf8', timeout: 5000 });
  } catch {
    return { nodes, edges };
  }

  const lines = crontabOutput.split('\n').filter(l => l.trim() && !l.trim().startsWith('#'));

  for (const line of lines) {
    // Match cron schedule lines: "*/15 * * * * command..."
    const match = line.match(/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+)\s+(.+)$/);
    if (!match) continue;

    const schedule = match[1];
    const command = match[2].trim();

    // Extract script name from command for a readable ID
    const scriptMatch = command.match(/(?:bun|bash|python3?)\s+([^\s]+)/);
    const scriptName = scriptMatch?.[1]?.split('/').pop()?.replace(/\.\w+$/, '') ?? 'unknown-cron';
    const id = `trigger:cron-${scriptName}-${Buffer.from(schedule).toString('base64').slice(0, 8)}`;

    nodes.push({
      id,
      type: 'trigger',
      label: `cron: ${scriptName}`,
      status: 'active',
      evidence: ['code'],
      sourcePath: scriptMatch?.[1] ?? '',
      note: `schedule: ${schedule}`,
      tags: ['cron'],
    });

    // Trigger emits to script/worker if we can identify it
    const entrypointId = scriptMatch?.[1]
      ? `worker:${scriptName}`
      : null;

    if (entrypointId) {
      edges.push({
        from: id,
        relation: 'emits',
        to: entrypointId,
        evidence: ['code'],
        note: `schedule: ${schedule}`,
      });
    }

    edges.push({
      from: id,
      relation: 'belongs_to',
      to: 'ws:egos-kernel',
      evidence: ['code'],
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Source 6 — Known endpoints/services (shadow_node)
// ═══════════════════════════════════════════════════════════

const KNOWN_ENDPOINTS = [
  { id: 'endpoint:egos-gateway', label: 'egos-gateway', port: 3050, repo: 'apps/egos-gateway' },
  { id: 'endpoint:egos-lab-chat', label: 'egos-lab-chat', port: 3095, repo: 'egos-lab-chat' },
  { id: 'endpoint:mcp-governance', label: 'MCP Governance', port: 7001, repo: 'packages/mcp-governance' },
  { id: 'endpoint:mcp-memory', label: 'MCP Memory', port: 7002, repo: 'packages/mcp-memory' },
  { id: 'endpoint:mcp-knowledge', label: 'MCP Knowledge', port: 7003, repo: 'packages/knowledge-mcp' },
  { id: 'endpoint:mcp-security', label: 'MCP Security', port: 7004, repo: 'packages/guard-brasil-mcp' },
  { id: 'endpoint:mcp-eval-runner', label: 'MCP Eval Runner', port: 7005, repo: 'packages/mcp-eval-runner' },
  { id: 'endpoint:mcp-ops', label: 'MCP Ops', port: 7006, repo: 'packages/mcp-ops' },
  { id: 'endpoint:mcp-skills-registry', label: 'MCP Skills Registry', port: 7007, repo: 'packages/mcp-skills-registry' },
  { id: 'endpoint:mcp-observability', label: 'MCP Observability', port: 7008, repo: 'packages/mcp-observability' },
  { id: 'endpoint:mcp-browser-automation', label: 'MCP Browser Automation', port: 7009, repo: 'packages/mcp-browser-automation' },
];

function buildEndpointNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
  const nodes: ReferenceNode[] = [];
  const edges: ReferenceEdge[] = [];

  for (const ep of KNOWN_ENDPOINTS) {
    nodes.push({
      id: ep.id,
      type: 'shadow_node',
      label: ep.label,
      status: 'planned', // unknown without live check — shadow_node
      evidence: ['plan'],
      sourcePath: ep.repo,
      tags: ['endpoint', `port:${ep.port}`],
      note: 'R-MYC-001: shadow_node sem ego completo — faltam: objetivo, regras, fronteiras_dados verificados em runtime',
    });

    edges.push({
      from: ep.id,
      relation: 'belongs_to',
      to: 'ws:egos-kernel',
      evidence: ['plan'],
    });
  }

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════
// Workspace root node (anchor)
// ═══════════════════════════════════════════════════════════

function buildWorkspaceNode(): ReferenceNode {
  return {
    id: 'ws:egos-kernel',
    type: 'workspace_root',
    label: 'EGOS Kernel (/home/enio/egos)',
    status: 'active',
    evidence: ['code', 'runtime'],
    sourcePath: REPO_ROOT,
    note: 'root anchor — todos os nós do ecossistema pertencem ou são governados por este workspace',
  };
}

// ═══════════════════════════════════════════════════════════
// Dedup — merge arestas duplicadas
// ═══════════════════════════════════════════════════════════

function deduplicateEdges(edges: ReferenceEdge[]): ReferenceEdge[] {
  const seen = new Set<string>();
  return edges.filter(e => {
    const key = `${e.from}|${e.relation}|${e.to}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

// ═══════════════════════════════════════════════════════════
// Build full graph
// ═══════════════════════════════════════════════════════════

function buildGraph(): ReferenceGraph {
  const allNodes: ReferenceNode[] = [];
  const allEdges: ReferenceEdge[] = [];

  // Workspace anchor
  allNodes.push(buildWorkspaceNode());

  // Source 1: repos
  const repos = buildRepoNodes();
  allNodes.push(...repos.nodes);
  allEdges.push(...repos.edges);

  // Source 2: trigger agents
  const agents = buildAgentNodes();
  allNodes.push(...agents.nodes);
  allEdges.push(...agents.edges);

  // Source 3: workers
  const workers = buildWorkerNodes();
  allNodes.push(...workers.nodes);
  allEdges.push(...workers.edges);

  // Source 4: MCPs
  // Source 4: MCPs
  const mcps = buildMcpNodes();
  allNodes.push(...mcps.nodes);
  allEdges.push(...mcps.edges);

  // Source 5: cron triggers
  const crons = buildCronNodes();
  allNodes.push(...crons.nodes);
  allEdges.push(...crons.edges);

  // Source 6: known endpoints
  const endpoints = buildEndpointNodes();
  allNodes.push(...endpoints.nodes);
  allEdges.push(...endpoints.edges);

  // Dedup edges
  const uniqueEdges = deduplicateEdges(allEdges);

  // Remove edges referencing non-existent nodes (dangling)
  const nodeIds = new Set(allNodes.map(n => n.id));
  const validEdges = uniqueEdges.filter(e => nodeIds.has(e.from) && nodeIds.has(e.to));

  return {
    version: '1.0.0',
    generated: new Date().toISOString(),
    nodes: allNodes,
    edges: validEdges,
  };
}

// ═══════════════════════════════════════════════════════════
// Sumário por tipo
// ═══════════════════════════════════════════════════════════

function printSummary(graph: ReferenceGraph): void {
  const health = graphHealth(graph);

  // Count by type
  const byType: Record<string, number> = {};
  for (const node of graph.nodes) {
    byType[node.type] = (byType[node.type] ?? 0) + 1;
  }

  const shadowCount = graph.nodes.filter(n => n.type === 'shadow_node').length;

  console.log('\n══════════════════════════════════════════════');
  console.log('MYCELIUM SNAPSHOT — SUMÁRIO');
  console.log('══════════════════════════════════════════════');
  console.log(`Total nós   : ${health.totalNodes}`);
  console.log(`Total arestas: ${health.totalEdges}`);
  console.log(`Active       : ${health.active}`);
  console.log(`Degraded     : ${health.degraded}`);
  console.log(`Planned      : ${health.planned}`);
  console.log(`Offline      : ${health.offline}`);
  console.log(`Shadow nodes : ${shadowCount}`);
  console.log('');
  console.log('Nós por tipo:');
  for (const [type, count] of Object.entries(byType).sort((a, b) => b[1] - a[1])) {
    console.log(`  ${type.padEnd(22)} ${count}`);
  }
  console.log('');
  if (health.orphanNodes.length > 0) {
    console.log(`Orphans (${health.orphanNodes.length}): ${health.orphanNodes.join(', ')}`);
  } else {
    console.log('Orphans: NENHUM');
  }
  console.log('══════════════════════════════════════════════\n');

  // Sample 2 nodes
  const sampleNodes = graph.nodes.slice(0, 2);
  console.log('Amostra (2 nós):');
  console.log(JSON.stringify(sampleNodes, null, 2));
}

// ═══════════════════════════════════════════════════════════
// Main
// ═══════════════════════════════════════════════════════════

const graph = buildGraph();

printSummary(graph);

if (DRY) {
  console.log('[--dry] Nenhum arquivo escrito.');
} else {
  const egosDir = join(HOME, '.egos');
  if (!existsSync(egosDir)) mkdirSync(egosDir, { recursive: true });

  const primaryPath = join(egosDir, 'mycelium-snapshot.json');
  const tmpPath = '/tmp/egos-mycelium-snapshot.json';

  const json = JSON.stringify(graph, null, 2);
  writeFileSync(primaryPath, json, 'utf8');
  writeFileSync(tmpPath, json, 'utf8');

  console.log(`[--exec] Snapshot escrito em:`);
  console.log(`  ${primaryPath}`);
  console.log(`  ${tmpPath}`);
}

exec
/bin/bash -lc "nl -ba scripts/mycelium-snapshot.ts | sed -n '140,230p'
cat tsconfig.json | sed -n '1,160p'
bun --version && bun scripts/mycelium-snapshot.ts --dry" in /home/enio/egos
 succeeded in 0ms:
   140	    });
   141	  }
   142	
   143	  return { nodes, edges };
   144	}
   145	
   146	// ═══════════════════════════════════════════════════════════
   147	// Source 2 — triggers.json → 12 papéis EGOS
   148	// ═══════════════════════════════════════════════════════════
   149	
   150	interface TriggerAgent {
   151	  tier: string;
   152	  runtime: string;
   153	  role: string;
   154	  upstream: string[];
   155	  downstream: string[];
   156	  trigger: string;
   157	  gates: string[];
   158	  peers: string;
   159	  dispatchable?: boolean;
   160	  note?: string;
   161	}
   162	
   163	interface TriggersJson {
   164	  roster: string[];
   165	  agents: Record<string, TriggerAgent>;
   166	  gates: Record<string, { requester: string; approver: string; hitl: boolean; reason: string; wired: boolean }>;
   167	}
   168	
   169	function buildAgentNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
   170	  const nodes: ReferenceNode[] = [];
   171	  const edges: ReferenceEdge[] = [];
   172	
   173	  const triggersPath = join(REPO_ROOT, 'agents/registry/triggers.json');
   174	  const data = readJsonSafe<TriggersJson>(triggersPath);
   175	  if (!data) return { nodes, edges };
   176	
   177	  for (const agentName of data.roster) {
   178	    const def = data.agents[agentName];
   179	    if (!def) continue;
   180	
   181	    const id = `agent:${agentName}`;
   182	    nodes.push({
   183	      id,
   184	      type: 'agent',
   185	      label: agentName,
   186	      status: 'active', // all roster agents in triggers.json are active by definition
   187	      evidence: ['code'],
   188	      sourcePath: triggersPath,
   189	      tags: [`tier:${def.tier}`, `runtime:${def.runtime}`],
   190	      note: def.role,
   191	    });
   192	
   193	    // Upstream → this agent
   194	    for (const up of def.upstream) {
   195	      edges.push({
   196	        from: `agent:${up}`,
   197	        relation: 'routes_to',
   198	        to: id,
   199	        evidence: ['code'],
   200	        note: 'upstream handoff',
   201	      });
   202	    }
   203	
   204	    // This agent → downstream
   205	    for (const down of def.downstream) {
   206	      edges.push({
   207	        from: id,
   208	        relation: 'routes_to',
   209	        to: `agent:${down}`,
   210	        evidence: ['code'],
   211	        note: 'downstream handoff',
   212	      });
   213	    }
   214	
   215	    // Gates this agent fires
   216	    for (const gate of def.gates) {
   217	      const gateId = `policy:gate-${gate}`;
   218	      edges.push({
   219	        from: id,
   220	        relation: 'validates',
   221	        to: gateId,
   222	        evidence: ['code'],
   223	        note: `fires gate: ${gate}`,
   224	      });
   225	    }
   226	
   227	    // Belongs to egos kernel
   228	    edges.push({
   229	      from: id,
   230	      relation: 'belongs_to',
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM"],
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "strict": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "types": ["node", "bun"],
    "paths": {
      "@egos/shared": ["./packages/shared/src"],
      "@egos/shared/*": ["./packages/shared/src/*"],
      "@egos/search-engine": ["./packages/search-engine/src"],
      "@egos/search-engine/*": ["./packages/search-engine/src/*"],
      "@egos/atomizer": ["./packages/atomizer/src"],
      "@egos/atomizer/*": ["./packages/atomizer/src/*"],
      "@egos/types": ["./packages/types/src"],
      "@egos/types/*": ["./packages/types/src/*"],
      "@egos/core": ["./packages/core/src"],
      "@egos/core/*": ["./packages/core/src/*"],
      "@egos/audit": ["./packages/audit/src"],
      "@egos/audit/*": ["./packages/audit/src/*"],
      "@egos/registry": ["./packages/registry/src"],
      "@egos/registry/*": ["./packages/registry/src/*"],
      "@egos/guard-brasil": ["./packages/guard-brasil/src"],
      "@egos/guard-brasil/*": ["./packages/guard-brasil/src/*"]
    }
  },
  "include": [
    "agents/**/*.ts",
    "packages/**/*.ts",
    "scripts/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "**/*.test.ts",
    "packages/core/src/auth",
    "packages/audit/src/activation-audit.ts",
    "packages/shared/src/mcp-audit-handler.ts",
    "packages/mcp-memory",
    "packages/mcp-bridge",
    "packages/mcp-browser-automation",
    "packages/mcp-eval-runner",
    "packages/mcp-g-pecas",
    "packages/mcp-governance",
    "packages/mcp-observability",
    "packages/mcp-ops",
    "packages/mcp-security",
    "packages/mcp-skills-registry",
    "packages/mcp-literature",
    "packages/knowledge-mcp",
    "packages/guard-brasil-langchain",
    "packages/guard-brasil-python",
    "packages/shared/src/intelink-llm-router.ts"
  ]
}
1.3.9

══════════════════════════════════════════════
MYCELIUM SNAPSHOT — SUMÁRIO
══════════════════════════════════════════════
Total nós   : 103
Total arestas: 129
Active       : 82
Degraded     : 4
Planned      : 17
Offline      : 0
Shadow nodes : 20

Nós por tipo:
  worker                 27
  repository             22
  shadow_node            20
  trigger                16
  agent                  12
  policy                 5
  workspace_root         1

Orphans: NENHUM
══════════════════════════════════════════════

Amostra (2 nós):
[
  {
    "id": "ws:egos-kernel",
    "type": "workspace_root",
    "label": "EGOS Kernel (/home/enio/egos)",
    "status": "active",
    "evidence": [
      "code",
      "runtime"
    ],
    "sourcePath": "/home/enio/egos",
    "note": "root anchor — todos os nós do ecossistema pertencem ou são governados por este workspace"
  },
  {
    "id": "repo:852",
    "type": "repository",
    "label": "852",
    "status": "active",
    "evidence": [
      "code"
    ],
    "sourcePath": "/home/enio/852",
    "note": "last_commit: 2026-06-09"
  }
]
[--dry] Nenhum arquivo escrito.

exec
/bin/bash -lc 'bun run typecheck' in /home/enio/egos
 succeeded in 9203ms:
exec
/bin/bash -lc "sed -n '1,220p' .husky/pre-commit && find .husky -maxdepth 2 -type f -name '*.sh' -print | sort" in /home/enio/egos
 succeeded in 0ms:
#!/bin/sh
# EGOS Pre-Commit Hook — Maximum Enforcement
# FROZEN ZONE: Do not weaken without explicit approval + proof-of-work.
# Cross-platform hardening: 2026-05-11 — jq fallback + path lint + junk-file guard.
# Pairs with docs/governance/CROSS_PLATFORM_RULES.md.

set -eu

# Cross-platform JSON reader. jq is the preferred tool but isn't on every
# platform (e.g. git-bash Windows). Falls back to python3, then "null".
# See CROSS_PLATFORM_RULES.md §3. Past misfire: missing jq → GATES=false →
# git rebase swallowed the real error and reported "must edit merge conflicts".
json_get() {
  # stdin = json string, $1 = jq-style key path like .validation.gates_pass
  _jg_key="${1:-.}"
  if command -v jq > /dev/null 2>&1; then
    jq -r "$_jg_key" 2>/dev/null
  elif command -v python3 > /dev/null 2>&1; then
    python3 -c "
import sys, json
key = sys.argv[1].lstrip('.').split('.')
try:
    d = json.load(sys.stdin)
    for k in key: d = d[k]
    print(d if d is not None else 'null')
except Exception:
    print('null')
" "$_jg_key" 2>/dev/null
  else
    echo "null"
  fi
}

echo "🔒 EGOS Pre-Commit: Maximum enforcement active"

# 0.1 ZONA EXTREMA — cross-window commit discipline (INC-SYMLINK-001 follow-up).
# Multiple agent windows (EGOS Prime / Antigravity-Guarani) share ONE checkout and
# .git/index. Uncontrolled accumulation in one window contaminates the other (64-file
# incident 2026-05-31). Two thresholds tuned to not block fast dev but force frequent
# commit+push. SSOT: docs/governance/ZONA_EXTREMA.md. Override: EGOS_ZONA_EXTREMA_OVERRIDE=1.
ZE_PUSH_LAG_MAX=5
ZE_UNCOMMITTED_MAX=25
if [ "${EGOS_ZONA_EXTREMA_OVERRIDE:-0}" != "1" ]; then
  # Optional explicit cross-window lock: a window starting a long uninterruptible
  # batch writes .egos-commit-lock (gitignored): "owner|pid|epoch|reason". The OTHER
  # window is blocked while the lock is fresh (<30min). Stale locks auto-expire.
  ZE_LOCK="$(git rev-parse --show-toplevel 2>/dev/null)/.egos-commit-lock"
  if [ -f "$ZE_LOCK" ]; then
    ZE_LOCK_OWNER=$(cut -d'|' -f1 "$ZE_LOCK" 2>/dev/null || echo "")
    ZE_LOCK_EPOCH=$(cut -d'|' -f3 "$ZE_LOCK" 2>/dev/null || echo 0)
    ZE_LOCK_REASON=$(cut -d'|' -f4 "$ZE_LOCK" 2>/dev/null || echo "")
    ZE_NOW=$(date +%s)
    ZE_AGE=$(( ZE_NOW - ${ZE_LOCK_EPOCH:-0} ))
    if [ "$ZE_AGE" -gt 1800 ]; then
      echo "⚠️  Zona Extrema: stale commit lock from '$ZE_LOCK_OWNER' (${ZE_AGE}s) — ignoring + removing."
      rm -f "$ZE_LOCK"
    elif [ "${EGOS_WINDOW_OWNER:-unknown}" != "$ZE_LOCK_OWNER" ]; then
      echo "🔴 ZONA EXTREMA: commit lock held by '$ZE_LOCK_OWNER' — \"$ZE_LOCK_REASON\""
      echo "   Another window is mid-batch on this shared checkout. Wait for it to commit+push."
      echo "   Override (rare): EGOS_ZONA_EXTREMA_OVERRIDE=1 git commit ..."
      exit 1
    fi
  fi
  ZE_AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)
  if [ "$ZE_AHEAD" -ge "$ZE_PUSH_LAG_MAX" ]; then
    echo "🔴 ZONA EXTREMA: $ZE_AHEAD commits ahead of origin/main (max $ZE_PUSH_LAG_MAX)."
    echo "   Too much unpushed work. Push first: bash scripts/safe-push.sh main"
    echo "   Override (rare): EGOS_ZONA_EXTREMA_OVERRIDE=1 git commit ..."
    exit 1
  fi
  # Count files NOT staged for this commit (untracked + unstaged-modified). Staged files
  # have a space in column 2, so committing always reduces this count → no deadlock.
  ZE_SPRAWL=$(git status --porcelain 2>/dev/null | awk 'substr($0,2,1)!=" " || /^\?\?/' | wc -l | tr -d ' ')
  if [ "$ZE_SPRAWL" -ge "$ZE_UNCOMMITTED_MAX" ]; then
    echo "🔴 ZONA EXTREMA: $ZE_SPRAWL files dirty/untracked outside this commit (max $ZE_UNCOMMITTED_MAX)."
    echo "   Work is sprawling without commits — protects the shared index across windows."
    echo "   Stage + commit in smaller logical batches until below $ZE_UNCOMMITTED_MAX."
    echo "   Override (rare): EGOS_ZONA_EXTREMA_OVERRIDE=1 git commit ..."
    exit 1
  fi
fi

# 0.2 Coordination Watcher health check
BLACKBOARD="$HOME/.egos/coordination-blackboard.json"

# 0.25 Versioned Coordination Lock Gate (Trava de coordenação de agentes)
COORD_LOCK="docs/governance/COORDINATION_LOCK.json"
if [ -f "$COORD_LOCK" ]; then
  LOCK_STATUS=$(cat "$COORD_LOCK" | json_get '.status' 2>/dev/null || echo "null")
  if [ "$LOCK_STATUS" = "locked" ]; then
    if git diff --cached "$COORD_LOCK" 2>/dev/null | grep -qE '^\+.*"status"\s*:\s*"resolved"'; then
      echo "🔓 COORD_LOCK: Desbloqueando coordenação via commit..."
    else
      LOCK_BY=$(cat "$COORD_LOCK" | json_get '.locked_by' 2>/dev/null || echo "unknown")
      LOCK_REASON=$(cat "$COORD_LOCK" | json_get '.reason' 2>/dev/null || echo "")
      echo "❌ BLOCKED: Coordenação obrigatória ativa em docs/governance/COORDINATION_LOCK.json"
      echo "   Bloqueado por: $LOCK_BY"
      echo "   Motivo: $LOCK_REASON"
      echo "   Instruções:"
      cat "$COORD_LOCK" | json_get '.instructions' 2>/dev/null | sed 's/^/    /' || true
      echo ""
      echo "   Para liberar o commit, resolva as pendências e edite '$COORD_LOCK'"
      echo "   mudando o campo \"status\" para \"resolved\"."
      exit 1
    fi
  fi
fi
if [ -f "$BLACKBOARD" ]; then
  AGE=$(python3 -c "
import json, datetime
try:
    with open('$BLACKBOARD') as f:
        data = json.load(f)
        dt = datetime.datetime.fromisoformat(data['timestamp'].replace('Z','+00:00'))
        now = datetime.datetime.now(datetime.timezone.utc)
        print(int((now-dt).total_seconds()))
except Exception:
    print(9999)
" 2>/dev/null || echo 9999)
  if [ "$AGE" -gt 120 ]; then
    echo "❌ BLOCKED: Coordination watcher stale (${AGE}s) or not running."
    echo "   Ensure it is running: bun scripts/coordination-watcher.ts &"
    echo "   Bypass: EGOS_WATCHER_OVERRIDE=1 git commit ..."
    if [ "${EGOS_WATCHER_OVERRIDE:-0}" != "1" ]; then
      exit 1
    fi
  fi
fi

# Portability gate (CROSS_PLATFORM_RULES.md §1) — block staged files that
# introduce hardcoded user-specific absolute paths. Allows comments but not
# value-side usage. Exempts the rules doc itself and archived handoffs.
STAGED_TEXT=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null | \
  grep -vE '\.(png|jpg|jpeg|gif|webp|pdf|zip|tar|gz|lock|ico)$|^docs/_archived_handoffs/|^docs/governance/CROSS_PLATFORM_RULES\.md$' || true)
if [ -n "$STAGED_TEXT" ]; then
  HARDCODED=""
  for f in $STAGED_TEXT; do
    [ -f "$f" ] || continue
    if git diff --cached -- "$f" 2>/dev/null | grep -E '^\+' | grep -v '^\+\+\+' | \
       grep -qE '["'"'"'`=]\s*/home/enio/egos|["'"'"'`=]\s*C:\\\\Users\\\\Usuario\\\\.egos'; then
      HARDCODED="$HARDCODED $f"
    fi
  done
  if [ -n "$HARDCODED" ]; then
    echo "❌ BLOCKED: hardcoded absolute path detected in staged file(s):"
    for f in $HARDCODED; do echo "    $f"; done
    echo "    Use \$EGOS_ROOT / git rev-parse instead. See docs/governance/CROSS_PLATFORM_RULES.md §1."
    exit 1
  fi
fi

# Janitorial gate (CROSS_PLATFORM_RULES.md §2) — block Windows shell-redirect
# artifacts. PowerShell '2>null' (vs '2>$null') creates a file literally named
# 'null' at repo root.
for junk in null nul NUL; do
  if [ -f "$junk" ]; then
    echo "❌ BLOCKED: file '$junk' in repo root — likely PowerShell redirect typo (use 2>\$null or 2>/dev/null)."
    echo "    Remove: rm '$junk'"
    exit 1
  fi
done

# 0. FOCUS ENFORCEMENT — 90-day strategic commitment (April 3 - June 30, 2026)
echo "  [0/8] focus enforcement: checking 90-day commitment..."
bash .husky/focus-enforcement || exit 1

# 0.5. SESSION COUNTER — track commits, emit [CHECKPOINT-NEEDED] if thresholds exceeded
# Skip if commit message contains [CHECKPOINT] to avoid loop
COMMIT_MSG_FILE="${GIT_DIR:-.git}/COMMIT_EDITMSG"
if [ -f "$COMMIT_MSG_FILE" ] && grep -q "\[CHECKPOINT\]" "$COMMIT_MSG_FILE" 2>/dev/null; then
  echo "  [0.5/8] session counter: [CHECKPOINT] commit — skip threshold check"
else
  if command -v bun > /dev/null 2>&1 && [ -f "scripts/session-init.ts" ]; then
    bun scripts/session-init.ts --commit 2>/dev/null || true
    bun scripts/session-init.ts --check 2>/dev/null || {
      echo ""
      echo "⚠️  [CHECKPOINT-NEEDED] Session thresholds exceeded."
      echo "   Run /checkpoint to spawn a fresh session before continuing."
      echo "   (Non-blocking — commit proceeds. Address before next session.)"
    }
  fi
fi

# 0.6. HERMES REVIEW GATE — sync queue from VPS then block if CRITICAL
# sync-review-queue.sh runs silently (<5s hard timeout) — fails gracefully if VPS offline
# INC-FIX-2026-05-20: wrapped in `timeout 5` — SSH rsync was hanging indefinitely
if [ -f "scripts/sync-review-queue.sh" ]; then
  timeout 5 bash scripts/sync-review-queue.sh 2>/dev/null || true
fi
if [ -f "$HOME/.egos/review-queue.jsonl" ]; then
  # Use count exported by sync-review-queue.sh (recent CRITICALs only, stale ones are warnings)
  CRITICAL_COUNT_FILE="$HOME/.egos/review-queue.jsonl.critical-count"
  if [ -f "$CRITICAL_COUNT_FILE" ]; then
    CRITICAL_COUNT=$(cat "$CRITICAL_COUNT_FILE" 2>/dev/null || echo 0)
  else
    # Fallback: raw count (legacy behavior)
    CRITICAL_COUNT=$(grep -c '"severity":"CRITICAL"' "$HOME/.egos/review-queue.jsonl" 2>/dev/null || echo 0)
  fi
  if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo ""
    echo "❌ BLOCKED: $CRITICAL_COUNT recent (≤7d) unresolved CRITICAL finding(s) in Hermes review queue."
    echo "   Run: cat ~/.egos/review-queue.jsonl | grep CRITICAL to see details."
    echo "   To mark resolved: bash scripts/resolve-review.sh <commit-sha>"
    exit 1
  fi
fi

# 0.7. VISUAL PROOF GATE — Karpathy Doctrine (INC-2026-05-08)
# Dispara quando staged diff toca UI surface (apps/*-landing/, components/, *.jsx, *.tsx, *.html)
# Modo warn-only por padrão. EGOS_VISUAL_PROOF_STRICT=1 → bloqueia.
# SSOT: docs/personal-os/FOCUS_GATES.md §4
if [ -f "scripts/check-visual-proof.sh" ]; then
  bash scripts/check-visual-proof.sh "${GIT_DIR:-.git}/COMMIT_EDITMSG" || exit 1
fi

# 0.72. UI/UX SYNC AND DATABASE INTEGRITY GATE — R8/R2.5 Sync
# Ensures storefront configs, tenant registries, and database schemas are synced.
if [ -f "scripts/ui-sync-check.ts" ] && command -v bun > /dev/null 2>&1; then
  bun scripts/ui-sync-check.ts || exit 1
fi
.husky/_/husky.sh
.husky/_checks/01-secrets.sh
.husky/_checks/02-typecheck.sh
.husky/_checks/03-doc-size.sh
.husky/_checks/04-frozen-zones.sh
.husky/_checks/05-doc-proliferation.sh
.husky/_checks/06-pii-scan.sh
.husky/_checks/07-sanity.sh
.husky/_checks/08-skills-health.sh
.husky/_checks/09-hermes-upstream.sh
.husky/_checks/10-uncommitted-stale.sh
.husky/_checks/11-leaf-canonical-check.sh
.husky/_checks/12-phantom-cbc.sh
.husky/_checks/13-registry-parity.sh
.husky/_checks/14-discover-gate.sh
.husky/_checks/15-agent-gate.sh
.husky/_checks/5.95-capability-detector.sh
.husky/_checks/conflict-markers.sh
.husky/_profiles/kernel.sh
.husky/_profiles/leaf.sh
.husky/_profiles/minimal.sh
.husky/_profiles/product.sh
.husky/doc-drift-check.sh

exec
/bin/bash -lc "sed -n '220,520p' .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:
fi


# 0.75. BANNED WORDS GATE — A53 Karpathy Doctrine (100%, perfeito, garantido, infalível)
# Dispara em staged copy pública (*.md *.html *.jsx *.tsx)
# Modo warn-only por padrão. EGOS_BANNED_STRICT=1 → bloqueia.
# SSOT: ~/.claude/CLAUDE.md §1 "Banned absolutes" + docs/personal-os/FOCUS_GATES.md
if [ -f "scripts/check-banned-words.sh" ]; then
  bash scripts/check-banned-words.sh || exit 1
fi

# 0.78. CAP-MODULAR GATE — K5 (packages/integrations/ sem entry em CAPABILITY_REGISTRY)
# SSOT: .guarani/orchestration/GATES.md K5
if [ -f "scripts/check-cap-modular.sh" ]; then
  bash scripts/check-cap-modular.sh || exit 1
fi

# 0.8. PROJECT INCEPTION GATE (PIG) — A59 (INC-2026-05-08-INSIGHT)
# Dispara em PRIMEIRO commit em repo NOVO fora dos canonical
# Modo warn-only por padrão. EGOS_INCEPTION_STRICT=1 → bloqueia.
# SSOT: docs/personal-os/FOCUS_GATES.md §6 + .claude/commands/inception.md
if [ -f "scripts/check-inception.sh" ]; then
  bash scripts/check-inception.sh "${GIT_DIR:-.git}/COMMIT_EDITMSG" || exit 1
fi

# 1. Gitleaks — Secret scanning
if command -v gitleaks > /dev/null 2>&1; then
  echo "  [1/5] gitleaks: scanning for secrets..."
  gitleaks protect --staged --no-banner || {
    echo "❌ BLOCKED: Secrets detected. Remove them before committing."
    exit 1
  }
else
  echo "  [1/5] gitleaks: NOT INSTALLED (install: brew install gitleaks)"
fi

# 1.5. audit-secrets — INC-007 prevention (EGOS-specific patterns + fallback anti-pattern)
echo "  [1.5/5] audit-secrets: scanning staged files for EGOS-specific secrets..."
if command -v bun > /dev/null 2>&1 && [ -f "scripts/security/audit-secrets.ts" ]; then
  if ! bun scripts/security/audit-secrets.ts --staged > /tmp/audit-secrets.out 2>&1; then
    tail -20 /tmp/audit-secrets.out
    echo "❌ BLOCKED: audit-secrets found critical/high findings in staged files."
    echo "   Fix issues or remove the secret before committing."
    exit 1
  fi
  tail -3 /tmp/audit-secrets.out
else
  echo "  [1.5/5] audit-secrets: script not found (skipping)"
fi

# 1.6. AI Security check — inline LLM scan of staged diff (AI-SECURITY-001)
# Uses qwen-turbo (<500ms), fail-open on LLM timeout. Warn-only by default.
# Set AI_SECURITY_STRICT=1 to block on CRITICAL findings.
# Skip if diff is docs-only (no TS/JS/SQL risk).
echo "  [1.6/5] ai-security: scanning staged diff for security issues..."
if command -v bun > /dev/null 2>&1 && [ -f "scripts/ai-commit-security.ts" ]; then
  bun scripts/ai-commit-security.ts --staged 2>/dev/null || true
else
  echo "  [1.6/5] ai-security: bun not found or script missing — skipped"
fi

# 1.7. R-SEC-001 — Hardcoded sensitive-data gate (INC-PII-001 prevention 2026-06-04)
# Blocks commit of real PII (names/CPF/RG), law-enforcement operation names,
# internal IPs hardcoded in source. Origin: investigation data leaked (INC-PII-001)
# into git history of 3 repos. NEVER print matched value (T0 §3). Mock/fixture:
# add `// scan-ok: mock` (or `<!-- scan-ok -->` in markdown) on the line.
echo "  [1.7/5] R-SEC-001: scanning staged files for hardcoded sensitive data..."
if command -v bun > /dev/null 2>&1 && [ -f "scripts/security/scan-hardcoded-sensitive.ts" ]; then
  if ! bun scripts/security/scan-hardcoded-sensitive.ts --staged > /tmp/r-sec-001.out 2>&1; then
    cat /tmp/r-sec-001.out
    echo "❌ BLOCKED: dado sensível hardcoded detectado (R-SEC-001 / INC-PII-001)."
    echo "   Dado de investigação real, PII ou nome de operação NUNCA vai pro git."
    echo "   Mova para .env / Supabase vault / sistema interno. Mock? '// scan-ok: mock'."
    echo "   Override consciente (NÃO recomendado): EGOS_RSEC_OVERRIDE=1"
    [ "${EGOS_RSEC_OVERRIDE:-0}" = "1" ] && echo "   ⚠️  EGOS_RSEC_OVERRIDE=1 — prosseguindo sob responsabilidade explícita." || exit 1
  fi
  tail -1 /tmp/r-sec-001.out
else
  echo "  [1.7/5] R-SEC-001: script não encontrado — skipped"
fi

# 1.8. R-PLAN-001 — Strategy Provenance Gate (2026-06-08)
# Docs estratégicos sobre empresas nomeadas com afirmações quantitativas
# DEVEM ter marcadores de proveniência: [REAL] [INFERIDO] [HIPÓTESE] [Source:]
echo "  [1.8/5] R-PLAN-001: checking strategy docs provenance..."
if command -v bun > /dev/null 2>&1 && [ -f "scripts/security/strategy-provenance-check.ts" ]; then
  if ! bun scripts/security/strategy-provenance-check.ts --staged > /tmp/r-plan-001.out 2>&1; then
    cat /tmp/r-plan-001.out
    echo "❌ BLOCKED: docs estratégicos sem marcadores de proveniência (R-PLAN-001)."
    echo "   Adicione [REAL] [INFERIDO] [HIPÓTESE] ou [Source: url] em afirmações quantitativas."
    echo "   Override: adicione <!-- R-PLAN-001-OK --> na linha ou RPLAN_OVERRIDE=1 git commit"
    [ "${RPLAN_OVERRIDE:-0}" = "1" ] && echo "   ⚠️  RPLAN_OVERRIDE=1 — prosseguindo." || exit 1
  fi
  tail -1 /tmp/r-plan-001.out
else
  echo "  [1.8/5] R-PLAN-001: script não encontrado — skipped"
fi

# 2. Session health check — /start v6.0 validation gates
echo "  [2/5] start-v6.0: running system health checks..."
HEALTH=$(bun scripts/start-v6.ts --json 2>/dev/null)
GATES=$(printf '%s' "$HEALTH" | json_get '.validation.gates_pass')
if [ "$GATES" != "true" ]; then
  echo "❌ BLOCKED: System health gates failed."
  if command -v jq > /dev/null 2>&1; then
    echo "$HEALTH" | jq '.blockers, .recommendations[:2]' 2>/dev/null
  else
    echo "    (jq not installed — install via 'winget install jqlang.jq' on Windows, 'apt install jq' on Linux)"
    echo "    Run for details: bun scripts/start-v6.ts --full"
  fi
  exit 1
fi

# 2.5. TypeScript — Strict type check
echo "  [2.5/5] tsc: running strict type check..."
npx tsc --noEmit 2>/dev/null || bun run typecheck 2>/dev/null || {
  echo "❌ BLOCKED: TypeScript errors found. Fix before committing."
  exit 1
}

# 3. Frozen Zones — Check for unauthorized changes
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
FROZEN_VIOLATED=0

for frozen in \
  "agents/runtime/runner.ts" \
  "agents/runtime/event-bus.ts" \
  ".husky/pre-commit" \
  ".guarani/orchestration/PIPELINE.md" \
  ".guarani/orchestration/GATES.md"; do
  if echo "$STAGED" | grep -q "^${frozen}$"; then
    echo "  FROZEN ZONE: $frozen is staged for commit."
    echo "   This file requires explicit user approval + proof-of-work."
    FROZEN_VIOLATED=1
  fi
done

if [ "$FROZEN_VIOLATED" -eq 1 ]; then
  echo ""
  echo "❌ BLOCKED: Frozen zone files modified."
  echo "   To override: git commit --no-verify (requires proof-of-work in message)"
  exit 1
fi

# 3.5. Frozen-zone / governance commit AUTHORITY gate (hardened GUARANI-004 + HITL_CATALOG §5.1)
# Fail-closed-by-DEFAULT: a commit touching frozen zones / governance is blocked unless the window
# is a Prime session (Claude Code sets CLAUDECODE automatically) OR Enio sets an explicit human
# override. Guarani (Antigravity/Gemini) has no CLAUDECODE, so it is blocked WITHOUT relying on an
# honor-system env var. THREAT MODEL (Codex 2026-05-31): these are process env vars and therefore
# forgeable — this gate stops accidents/defaults and records intent, it is NOT tamper-proof authz.
# Real enforcement still rests on process discipline (Guarani never commits) + sole-committer Prime;
# a server-side pre-receive hook would be required for hard authz (not wired for this solo setup).
GOV_FROZEN=$(echo "$STAGED" | grep -E '^\.guarani/|^\.husky/|^docs/governance/|^AGENTS\.md$|^CLAUDE\.md$|^agents/runtime/' || true)
if [ -n "$GOV_FROZEN" ]; then
  AUTHORIZED=0
  WHO="unknown"
  # Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
  if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
  # Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
  if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
  # Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
  if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
  if [ "$AUTHORIZED" -ne 1 ]; then
    echo "❌ BLOCKED: frozen-zone/governance commit requires a Prime window or explicit human override."
    if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
    echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
    echo "   Offending staged files:"
    echo "$GOV_FROZEN" | sed 's/^/     - /'
    echo "   Guarani proposes diffs; Prime/Enio reviews and commits. See GUARANI.md §12.1 + HITL_CATALOG §5.1."
    echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
    exit 1
  fi
fi


# 4.1. Frozen Zone — .guarani/ must stay REAL files (anti-symlink-conversion guard)
# Root cause INC-SYMLINK-001 (2026-05-31, recurred same day): governance:sync:exec /
# ~/.egos/sync.sh converts kernel .guarani/ into symlinks to ~/.egos/guarani/. The kernel
# is the REAL source — symlink conversions must never be committed. Catches any window/script.
GUARANI_SYMLINKED=$(git diff --cached --raw 2>/dev/null | awk '$2=="120000" && /\.guarani\// {print $NF}' || true)
if [ -n "$GUARANI_SYMLINKED" ]; then
  if [ "${EGOS_ALLOW_GUARANI_SYMLINK:-0}" != "1" ]; then
    echo "❌ BLOCKED: .guarani/ files staged as SYMLINKS (kernel must be the real source)."
    echo "   Offending paths:"
    echo "$GUARANI_SYMLINKED" | sed 's/^/     - /'
    echo "   Cause: governance:sync:exec / ~/.egos/sync.sh converted kernel .guarani/ to symlinks."
    echo "   Fix:   git restore --staged .guarani/ && git checkout HEAD -- .guarani/"
    echo "   Override (intentional migration ONLY): EGOS_ALLOW_GUARANI_SYMLINK=1 git commit ..."
    exit 1
  fi
  echo "⚠️  .guarani/ symlink conversion ALLOWED via EGOS_ALLOW_GUARANI_SYMLINK=1"
fi

# 4.5. Modification Size Guard — Alert on excessive changes
STAGED_DIFF_STAT=$(git diff --cached --stat --numstat 2>/dev/null || true)
if [ -n "$STAGED_DIFF_STAT" ]; then
  TOTAL_ADDS=$(echo "$STAGED_DIFF_STAT" | awk '{sum+=$1} END {print sum+0}')
  TOTAL_DELS=$(echo "$STAGED_DIFF_STAT" | awk '{sum+=$2} END {print sum+0}')
  TOTAL_LINES=$(( ${TOTAL_ADDS:-0} + ${TOTAL_DELS:-0} ))
  TOTAL_FILES=$(echo "$STAGED_DIFF_STAT" | wc -l)
  
  # Alert if more than 500 lines changed
  if [ "$TOTAL_LINES" -gt 500 ]; then
    echo ""
    echo "⚠️  WARNING: Large commit detected ($TOTAL_LINES lines changed across $TOTAL_FILES files)"
    echo "   This makes reviews harder and increases rollback risk."
    echo "   Consider: git reset HEAD and split into smaller commits."
    echo ""
    echo "   Files with most changes:"
    echo "$STAGED_DIFF_STAT" | sort -k1 -k2 -n -r | head -5 | awk '{print "   - " $3 " (" $1 "+ / " $2 "-)"}'
    echo ""
    if [ -t 0 ]; then
      read -p "Continue anyway? [y/N] " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
      fi
    else
      echo "   ⚠️  Non-interactive mode — allowing large commit (add smaller commits when possible)"
    fi
  fi
fi

# 4. Doc Proliferation — Block timestamped docs
echo "  [4/5] doc proliferation: checking for timestamped docs..."
bash scripts/check-doc-proliferation.sh || exit 1

# 4.1 docs/ root guard — only 9 canonical files allowed
DOCS_ROOT_ALLOWLIST="EGOS_BOOTSTRAP.md CAPABILITY_REGISTRY.md GTM_SSOT.md COORDINATION.md COORDINATION_PATTERN.md CROSS_REPO_CONTEXT_ROUTER.md SYSTEM_MAP.md AGENT_BOOTSTRAP.md SPRINT_PROTOCOL.md"
NEW_DOCS_ROOT=$(echo "$STAGED" | grep -E '^docs/[^/]+\.md$' | sed 's|docs/||' || true)
if [ -n "$NEW_DOCS_ROOT" ]; then
  VIOLATIONS=""
  for f in $NEW_DOCS_ROOT; do
    if ! echo "$DOCS_ROOT_ALLOWLIST" | grep -qw "$f"; then
      VIOLATIONS="$VIOLATIONS $f"
    fi
  done
  if [ -n "$VIOLATIONS" ]; then
    echo "❌ BLOCKED: New docs/*.md file(s) not in canonical allowlist:"
    for v in $VIOLATIONS; do echo "   docs/$v"; done
    echo "   Move to a subdirectory (docs/governance/, docs/strategy/, etc.)"
    echo "   See: CLAUDE.md §7 'docs/ Root Rule' | Audit: bun scripts/docs-root-audit.ts"
    exit 1
  fi
fi

# 4. Governance propagation — canonical kernel files must be synced to ~/.egos
if echo "$STAGED" | grep -Eq '^\.guarani/|^\.windsurf/workflows/|^docs/SSOT_REGISTRY\.md$|^docs/CAPABILITY_REGISTRY\.md$|^docs/modules/CHATBOT_SSOT\.md$'; then
  echo "  [3/5] governance sync: checking kernel -> ~/.egos drift..."
  sh scripts/governance-sync.sh --check >/dev/null 2>&1 || {
    echo "❌ BLOCKED: Governance drift detected between kernel and ~/.egos."
    echo "   Run: bun run governance:sync:exec"
    exit 1
  }
else
  echo "  [3/5] governance sync: no canonical governance changes staged"
fi

# 4.1. Template inheritance — INHERITS/OVERRIDES schema + 16-field gate (L0-CODEX-005)
if echo "$STAGED" | grep -q '^central-egos/products/'; then
  echo "  [3.1/5] template inheritance: validating INHERITS/OVERRIDES schema..."
  bun scripts/validate-inherits.ts || {
    echo "❌ BLOCKED: template inheritance schema errors (see above)."
    echo "   SSOT: docs/governance/TEMPLATE_INHERITANCE_PROTOCOL.md §2/§2.1"
    exit 1
  }
  bun scripts/lint-domain-template.ts || {
    echo "❌ BLOCKED: domain template missing required fields (see above)."
    echo "   SSOT: docs/governance/DOMAIN_TEMPLATE_SPEC.md §2/§3"
    exit 1
  }
fi

# 4.2. Skills drift — warn if egos/ copy diverges from .egos/ SSOT (non-blocking)
# Cobre /start, /end e qualquer skill em check-skills-drift.sh
if echo "$STAGED" | grep -qE '^\.claude/commands/(start|end)\.md$' || [ -f scripts/check-skills-drift.sh ]; then
  if [ -x scripts/check-skills-drift.sh ]; then
    bash scripts/check-skills-drift.sh --quiet || {
      echo "⚠️  Skills drift: edit propagated to one location only."
      echo "   Run: bash scripts/check-skills-drift.sh --fix"
      echo "   (Non-blocking — commit proceeds.)"
    }
  fi
fi

# 5. SSOT Drift — Check file size limits
echo "  [4/5] SSOT drift: checking file size limits..."
check_lines() {
  _cl_file="$1"; _cl_max="$2"
  if [ -f "$_cl_file" ]; then
    _cl_lines=$(wc -l < "$_cl_file")
    if [ "$_cl_lines" -gt "$_cl_max" ]; then
      echo "SSOT DRIFT: $_cl_file has $_cl_lines lines (max: $_cl_max)"
      return 1
    fi
  fi
}

check_lines "AGENTS.md" 200 || exit 1

# TASKS.md enforcement v2 — auto-archive [x] + size limits

exec
/bin/bash -lc "sed -n '520,900p' .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:
# TASKS.md enforcement v2 — auto-archive [x] + size limits
# Spec: docs/governance/TASKS_OPERATING_MODEL_v1.md §2 (updated 2026-05-11)
# Thresholds: soft-warn=250, archive-required=400, hard-block=600
if [ -f "TASKS.md" ]; then

  # 0pre) PROVENANCE phantom-done guard (Enio 2026-06-04 — §1 proveniência-por-ação / AGENTS R1.5)
  #   Roda ANTES do auto-archive (senão o [x] phantom é movido p/ archive e some).
  #   Um [x] recém-marcado precisa de EVIDÊNCIA na linha: SHA(7+ hex) | arquivo c/ extensão |
  #   Closes/Fixes/Resolves | PR/commit/http link. Bare "✅ data" NÃO conta (caso LANDING-EVOLVE).
  #   Override consciente: EGOS_PROVENANCE_OVERRIDE=1.
  _new_done=$(git diff --cached -U0 -- TASKS.md 2>/dev/null | grep -E '^\+- \[x\]' || true)
  if [ -n "$_new_done" ]; then
    _phantom=$(echo "$_new_done" | grep -vE '\b[0-9a-f]{7,40}\b|Closes|Fixes|Resolves|PR #|https?://|commit ' || true)
    if [ -n "$_phantom" ]; then
      echo "  🔴 PROVENÂNCIA (phantom-done): task(s) marcada(s) [x] SEM evidência verificável:"
      echo "$_phantom" | sed -E 's/^\+- \[x\] ?/    /' | cut -c1-100 | head -5
      echo "     Regra §1/AGENTS R1.5: 'done' exige SHA, arquivo, Closes/Fixes ou prova. Bare ✅/data não conta."
      echo "     → Reabra [ ] OU adicione evidência na linha. Override consciente: EGOS_PROVENANCE_OVERRIDE=1"
      [ "${EGOS_PROVENANCE_OVERRIDE:-0}" = "1" ] || { echo "  ❌ BLOCKED: phantom-done."; exit 1; }
      echo "  ⚠️  EGOS_PROVENANCE_OVERRIDE=1 — phantom-done permitido conscientemente."
    fi
  fi

  # 0) AUTO-ARCHIVE: move [x] lines to TASKS_ARCHIVE on EVERY commit
  #    v2.1 (2026-05-11): runs whenever [x] exists in working tree, not just when
  #    TASKS.md is staged. Closes gap where [x] could persist across commits that
  #    don't touch TASKS.md. Resulting changes are auto-staged into this commit.
  _done_count=$(grep -c '^- \[x\]' TASKS.md 2>/dev/null || true)
  _done_count=${_done_count:-0}
  if [ "${_done_count}" -gt 0 ] 2>/dev/null; then
    # Skip if working tree has uncommitted TASKS.md changes that aren't staged
    # (avoid clobbering active agent edits)
    _has_unstaged=$(git diff --name-only TASKS.md 2>/dev/null | wc -l)
    if echo "$STAGED" | grep -q "TASKS\.md" || [ "${_has_unstaged:-0}" -eq 0 ]; then
      echo "  🗄️  Auto-archiving $_done_count completed task(s) from TASKS.md..."
      if command -v bun >/dev/null 2>&1; then
        bun scripts/tasks-archive.ts --exec --root="$(pwd)" 2>/dev/null && \
          git add TASKS.md TASKS_ARCHIVE.md 2>/dev/null && \
          echo "  ✅ Auto-archive done — TASKS.md + TASKS_ARCHIVE.md staged into this commit"
      fi
    else
      echo "  ⚠️  TASKS.md has $_done_count [x] but unstaged changes detected — skipping auto-archive (manual: bun scripts/tasks-archive.ts --exec)"
    fi
  fi

  _tasks_lines=$(wc -l < "TASKS.md")
  _policy_grace=""
  if [ -f ".tasks-policy.json" ]; then
    # jq preferred (cross-platform); python3 fallback; grep last resort
    _policy_grace=$(printf '%s' "$(cat .tasks-policy.json)" | json_get '.grace_end' 2>/dev/null || \
      python3 -c "import json,sys; p=json.load(open('.tasks-policy.json')); print(p.get('grace_end',''))" 2>/dev/null || \
      grep -o '"grace_end"[[:space:]]*:[[:space:]]*"[0-9-]*"' .tasks-policy.json | grep -o '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' || \
      true)
  fi

  # 1) IMMEDIATE BLOCK: duplicate task IDs (no grace period)
  _dup_ids=$(grep -oP '(?<=\*\*)[A-Z]+-[0-9]+(?=\s*\[)' TASKS.md 2>/dev/null | sort | uniq -d | head -5 || true)
  if [ -n "$_dup_ids" ]; then
    echo "  🔴 BLOCKED: Duplicate task IDs in TASKS.md:"
    echo "$_dup_ids" | sed 's/^/    - /'
    echo "  Fix: remove or renumber duplicate IDs before committing."
    exit 1
  fi

  # 2) SIZE CHECKS (new thresholds: 250/400/600)
  if [ "$_tasks_lines" -ge 600 ]; then
    _today=$(date +%Y-%m-%d)
    if [ -n "$_policy_grace" ] && [ "$_today" \< "$_policy_grace" ]; then
      echo "  🚨 TASKS.md has $_tasks_lines lines (hard-block: 600). Grace until $_policy_grace."
      echo "     Move long-term tasks to docs/strategy/ROADMAP.md + run: bun scripts/tasks-archive.ts --exec"
    else
      echo "  🔴 BLOCKED: TASKS.md has $_tasks_lines lines (≥600). Archive or move to ROADMAP.md."
      echo "     bun scripts/tasks-archive.ts --exec && git add TASKS.md TASKS_ARCHIVE.md"
      exit 1
    fi
  elif [ "$_tasks_lines" -ge 400 ]; then
    echo "  🚨 URGENT: TASKS.md has $_tasks_lines lines (archive required at 400). Run: bun scripts/tasks-archive.ts --exec"
  elif [ "$_tasks_lines" -ge 250 ]; then
    echo "  ⚠️  TASKS.md has $_tasks_lines lines (soft warn at 250). Archive when convenient."
  fi
fi

check_lines ".windsurfrules" 250 || exit 1
check_lines ".guarani/PREFERENCES.md" 100 || exit 1
check_lines "docs/SSOT_REGISTRY.md" 200 || exit 1

# 5.5. LLMRefs Staleness (non-blocking warning)
if echo "$STAGED" | grep -q '\.md$'; then
  STALE=$(python3 scripts/qa/llmrefs_staleness.py --root . 2>&1 | grep "LLMREFS_STALE" | grep -oP '\d+' || echo "0")
  if [ "$STALE" -gt 0 ] 2>/dev/null; then
    echo "  ⚠️  LLMRefs: $STALE stale link(s) in docs (non-blocking, run: python3 scripts/qa/llmrefs_staleness.py --root .)"
  fi
fi

# 5.5. Doc-Drift Check — Layer 2 of the Doc-Drift Shield
echo "  [5.5/8] doc-drift: verifying .egos-manifest.yaml claims..."
if [ -t 0 ]; then
  bash .husky/doc-drift-check.sh || exit 1
else
  bash .husky/doc-drift-check.sh </dev/null || exit 1
fi

# 5.7. SSOT Gate — Block new .md files that belong to existing SSOTs
NEW_MD_FILES=$(git diff --cached --name-only --diff-filter=A 2>/dev/null | grep '\.md$' || true)
if [ -n "$NEW_MD_FILES" ]; then
  COMMIT_MSG=$(cat .git/COMMIT_EDITMSG 2>/dev/null || echo "")
  if echo "$COMMIT_MSG" | grep -q "SSOT-NEW:"; then
    echo "  [5.7/8] ssot-gate: override detected (SSOT-NEW in commit message) — skipping"
  else
    echo "  [5.7/8] ssot-gate: checking new .md files against SSOT map..."
    SSOT_BLOCK=0
    for md_file in $NEW_MD_FILES; do
      if bun scripts/ssot-router.ts --file "$md_file" --warn-only 2>&1; then
        true
      else
        SSOT_BLOCK=1
      fi
    done
    if [ "$SSOT_BLOCK" -eq 1 ]; then
      echo ""
      echo "❌ BLOCKED: New .md file belongs to existing SSOT domain."
      echo "   See suggestions above. To override: add 'SSOT-NEW: <reason>' to commit message."
      exit 1
    fi
  fi
fi

# 5.8. AUTO-GEN Guard — Block handwritten edits inside AUTO-GEN blocks (INC-006 MSSOT-002)
# Override: include 'MSSOT-MANUAL-OVERRIDE: <reason>' in commit body.
echo "  [5.8/8] auto-gen guard: checking AUTO-GEN block integrity..."
COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"
if [ -f "$COMMIT_MSG_FILE" ] && grep -q "MSSOT-MANUAL-OVERRIDE:" "$COMMIT_MSG_FILE" 2>/dev/null; then
  echo "  [5.8/8] auto-gen guard: MSSOT-MANUAL-OVERRIDE detected — skipping"
else
  bun scripts/auto-gen-guard.ts --staged-only || {
    echo "❌ BLOCKED: Handwritten edit inside AUTO-GEN block (INC-006)."
    echo "   Override: add 'MSSOT-MANUAL-OVERRIDE: <reason>' to commit body."
    exit 1
  }
fi

# 5.85. SSOT Claim Check — Warn on scored tables without evidence (INC-006 SHIM-004, non-blocking)
echo "  [5.85/8] ssot claim-check: scanning for phantom-prone scored tables..."
bun scripts/ssot-claim-check.ts --all 2>/dev/null | head -6 || true

# 5.9. Evidence Gate — §33 Evidence-First Principle (warning-only until 2026-04-16)
echo "  [5.9/8] evidence-gate: checking claim backing in staged docs..."
bun scripts/evidence-gate.ts --staged-only 2>/dev/null || {
  echo "⚠️  evidence-gate: script error (non-blocking). Run: bun scripts/evidence-gate.ts --staged-only"
}

# 5.95. Capability Detector — validate new capabilities have CBC + eval (MCP-F4-001)
# Ativado via EGOS_CAPABILITY_VALIDATE=1 (warn) ou EGOS_CAPABILITY_STRICT=1 (block)
bash .husky/_checks/5.95-capability-detector.sh 2>/dev/null || true

# 13. Registry Parity — hard-fail on NEW packages/apps/agents missing §-entry (REG-PARITY-001)
# Escape: `REGISTRY-PARITY-SKIP: <reason>` in commit body, or EGOS_REGISTRY_PARITY_SKIP=<reason>
# SSOT: docs/governance/REGISTRY_PARITY_DECISION.md
echo "  [13/N] registry-parity: scanning staged adds for missing registry entries..."
bash .husky/_checks/13-registry-parity.sh || exit 1

# 14. Discover Gate — exige CONSULTED-SSOT: no body ao criar nova capability (DISCOVER-GATE-003)
# Escape: `DISCOVER-GATE-SKIP: <razão>` no commit body ou DISCOVER_GATE_SKIP=<razão> no env
# SSOT: scripts/discover-capability.ts | R-DISCOVER-001
if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
  echo "  [14/N] discover-gate: verificando prova de consulta para nova capability..."
  bash .husky/_checks/14-discover-gate.sh || exit 1
fi

# 6. File Intelligence — Classification + Compliance + PII scan
echo "  [5/5] file intelligence: classifying and checking staged files..."
bash scripts/file-intelligence.sh 2>/dev/null || {
  echo "❌ BLOCKED: File intelligence found critical violations."
  echo "   Run: bash scripts/file-intelligence.sh for details"
  exit 1
}

# 7. Vocab Guard — Block phantom architecture terms in docs
STAGED_MD=$(git diff --cached --name-only 2>/dev/null | grep '\.md$' || true)
if [ -n "$STAGED_MD" ]; then
  PHANTOM_FOUND=0
  for md_file in $STAGED_MD; do
    if [ -f "$md_file" ]; then
      MATCHES=$(git diff --cached -- "$md_file" 2>/dev/null | grep '^+' | grep -v '^+++' | \
        grep -iE '\b(NATS transport|NATS broker|NATS server|ZKP|zero.knowledge proof|shadow node|QuantumSearch|quantum search|DAG engine|DAG workflow|DAG.based pipeline|Gardener cycle|Gardener v[0-9]|gardener-scan|gardener-prune|Cognee.Bridge|EGOS.CogneeBridge|EGOS.Memory v[0-9]|Hyperspace watcher|Hyperspace-watcher|\bKOIOS\b|\bCORUJA\b|qmd hybrid indexer|MemFactory|ATRiAN pre-forget gate|MemPalace v[0-9]|ETHIK points|Bjork.s New Theory)\b' | grep -v 'vocab-guard: planned' || true)
      if [ -n "$MATCHES" ]; then
        echo "  VOCAB GUARD: $md_file adds phantom architecture terms:"
        echo "$MATCHES" | head -5 | sed 's/^/    /'
        PHANTOM_FOUND=1
      fi
    fi
  done
  if [ "$PHANTOM_FOUND" -eq 1 ]; then
    echo ""
    echo "❌ BLOCKED: Documentation references unimplemented architecture."
    echo "   Terms blocked: NATS, ZKP, shadow nodes, QuantumSearch, DAG engine/workflow"
    echo "   Also blocked (INC-005 phantom terms): Gardener cycle/v2+, Cognee-Bridge, MemPalace vN,"
    echo "   Hyperspace watcher, KOIOS, CORUJA, qmd hybrid indexer, MemFactory, ETHIK points, ATRiAN pre-forget gate"
    echo "   These are planned-only — no code exists. To proceed:"
    echo "   Option A: Add code first, then document it."
    echo "   Option B: Mark planned terms with: <!-- vocab-guard: planned -->"
    echo "   Option C: git commit --no-verify (requires justification in commit message)"
    exit 1
  fi
  echo "  [7/7] vocab guard: no phantom architecture terms in staged docs"
fi

# 8. Legacy Code Detector — warns on debug logs, TODOs, dead code
bash scripts/check-legacy-code.sh 2>/dev/null || true  # non-blocking

# 9. Supabase Safety (INC-004) — Realtime publication, rate limits, RLS
STAGED_TS=$(git diff --cached --name-only 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|sql)$' || true)
if [ -n "$STAGED_TS" ]; then
  echo "  [9/9] supabase-safety: checking DB write patterns..."
  bash scripts/check-supabase-safety.sh 2>/dev/null || {
    echo "❌ BLOCKED: Supabase safety violations found."
    echo "   Run: bash scripts/check-supabase-safety.sh for details"
    exit 1
  }
fi

# 9.5. RLS Policy Validator (INC-006 prevention) — Catch misconfigured {public} roles
STAGED_SQL=$(git diff --cached --name-only 2>/dev/null | grep -E '\.sql$' || true)
if [ -n "$STAGED_SQL" ]; then
  echo "  [9.5/10] rls-validator: checking Row-Level Security policy roles..."
  if command -v bun > /dev/null 2>&1 && [ -f "scripts/security/rls-validator.ts" ]; then
    if ! bun scripts/security/rls-validator.ts --staged-only 2>/dev/null; then
      echo "❌ BLOCKED: RLS policy violations detected (role misconfiguration)."
      echo "   Fix violations above before committing. See: docs/security/RLS_POLICY_GUIDE.md"
      exit 1
    fi
  else
    echo "  ⚠️  rls-validator: script not found (skipping)"
  fi
fi

# README freshness gate
if [ -f "$HOME/.egos/hooks/readme-freshness.sh" ]; then
  bash "$HOME/.egos/hooks/readme-freshness.sh" "${1:-}" || exit 1
else
  echo "  [readme-freshness] hook not installed in ~/.egos/hooks — skipping (CROSS_PLATFORM_RULES §3)"
fi

# §10 FLOW VALIDATION — warn when new API routes staged without smoke evidence
NEW_API_ROUTES=$(git diff --cached --name-only 2>/dev/null | grep "route\.ts$\|route\.js$" | wc -l)
if [ "$NEW_API_ROUTES" -gt 0 ]; then
  echo "  [flow-validation] §10 CLAUDE.md: $NEW_API_ROUTES nova(s) route(s) API staged"
  # Verificar se commit message ou STAGED tem evidência de smoke
  HAS_SMOKE=$(git diff --cached 2>/dev/null | grep -ciE "HTTP [0-9]{3}|curl|smoke|tested|SMOKE-TESTED|SMOKE-PENDING" || true)
  if [ "$HAS_SMOKE" -eq 0 ]; then
    echo "  ⚠️  [flow-validation] Nenhuma evidência de smoke test detectada nos arquivos staged."
    echo "  ⚠️  Execute curl contra o endpoint e inclua o resultado no commit message."
    echo "  ⚠️  Ou adicione: <!-- SMOKE-PENDING: motivo --> no arquivo se ainda não deployado."
    echo "  ⚠️  (non-blocking — §10 CLAUDE.md exige smoke antes de declarar [DONE])"
  else
    echo "  ✅ [flow-validation] Evidência de smoke detectada"
  fi
fi

# README drift — warn when apps/ or packages/ code changes without README update
CODE_APPS=$(git diff --cached --name-only 2>/dev/null | grep -E "^(apps|packages)/" | wc -l)
README_APPS=$(git diff --cached --name-only 2>/dev/null | grep -iE "readme" | wc -l)
if [ "$CODE_APPS" -gt 3 ] && [ "$README_APPS" -eq 0 ]; then
  echo "  ⚠️  [readme-drift] $CODE_APPS arquivos de app/package staged sem README atualizado."
  echo "  ⚠️  Considere atualizar o README do app afetado (§7 SSOT + CLAUDE.md Convenções)."
fi

# SKILLS-002: Write context signals for /start skill auto-activation
SIGNALS_FILE="$HOME/.egos/context-signals.jsonl"
mkdir -p "$(dirname "$SIGNALS_FILE")" 2>/dev/null || true
TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo unknown)")
STAGED_COUNT=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
STAGED_TYPES=$(git diff --cached --name-only 2>/dev/null | grep -oE '\.[a-z]+$' | sort -u | tr '\n' ',' | sed 's/,$//')

# Detect signal type from what was staged
SIGNAL="commit"
if git diff --cached --name-only 2>/dev/null | grep -qE '\.guarani/|AGENTS\.md$|CLAUDE\.md$'; then
  SIGNAL="governance_change"
elif git diff --cached --name-only 2>/dev/null | grep -qE '\.husky/|hooks/'; then
  SIGNAL="hook_change"
elif git diff --cached --name-only 2>/dev/null | grep -qE '^docs/'; then
  SIGNAL="docs_change"
elif git diff --cached --name-only 2>/dev/null | grep -qE '\.(ts|tsx|js|jsx|py)$'; then
  SIGNAL="code_change"
fi

printf '{"ts":"%s","repo":"%s","signal":"%s","detail":"%s files (%s)"}\n' \
  "$TS" "$REPO_NAME" "$SIGNAL" "$STAGED_COUNT" "$STAGED_TYPES" >> "$SIGNALS_FILE"

# Keep only last 100 signals (avoid unbounded growth)
if [ -f "$SIGNALS_FILE" ]; then
  tail -100 "$SIGNALS_FILE" > "${SIGNALS_FILE}.tmp" && mv "${SIGNALS_FILE}.tmp" "$SIGNALS_FILE"
fi

# CROSSREFS (GOV-W2-001): warn on broken markdown links + archived textual refs (flags A3/A10)
# Warn-only — never blocks. Runs only when .md files are staged.
if git diff --cached --name-only 2>/dev/null | grep -qE '\.md$'; then
  if command -v bun > /dev/null 2>&1 && [ -f "scripts/check-crossrefs.ts" ]; then
    echo "  [cross-refs] checking broken refs in staged markdown..."
    bun scripts/check-crossrefs.ts --report 2>/dev/null | grep -E "^  ARCHIVED:|^  MISSING:|ARCHIVED:|MISSING:" | head -10 || true
  fi
fi

  # [HEALTH] Periodic system health check (VPS, DBs, Hermes) — 24h interval
  if [ -f "scripts/health-check-periodic.sh" ]; then
    bash scripts/health-check-periodic.sh || exit 1
  fi

# [AI-WORKFLOW R3] Bloqueia commit com marcadores de merge não resolvidos
# Ver: docs/governance/AI_AGENT_WORKFLOW.md
if [ -x ".husky/_checks/conflict-markers.sh" ]; then
  .husky/_checks/conflict-markers.sh || exit 1
fi

# [SSOT-POLICY 2026-05-18] Bloqueia leaf-repos declarando canonical/SSOT
# Ver: docs/governance/SSOT_LOCATION_POLICY.md
# Skip no kernel egos (auto-detect by repo name).
if [ -x ".husky/_checks/11-leaf-canonical-check.sh" ]; then
  .husky/_checks/11-leaf-canonical-check.sh || exit 1
fi

# === Anti-Rsync-Prod Gate (T0 #7 — added 2026-05-13 INC-PROD-001) ===
# Bloqueia commits que adicionam rsync direto pra produção em scripts/shell
# fora dos scripts canonical scripts/deploy-*.sh (que implementam gates R1-R8).
# SSOT: docs/governance/PRODUCTION_DEPLOY_RULES.md §4
STAGED_SHELL=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null | \
  grep -E '\.(sh|bash|ts|js|mjs|cjs)$|^scripts/|^\.husky/' | \
  grep -v '^scripts/deploy-' | \
  grep -v '_archived' || true)
if [ -n "$STAGED_SHELL" ]; then
  PROD_RSYNC=""
  for f in $STAGED_SHELL; do
    [ -f "$f" ] || continue
    # Detecta rsync para domínios de produção EGOS (hetzner alias OU IP VPS OU prod paths)
    if git diff --cached -- "$f" 2>/dev/null | grep -E '^\+' | grep -v '^\+\+\+' | \
       grep -qE '(rsync.*hetzner:|rsync.*204\.168\.217\.125|rsync.*/opt/apps/|rsync.*/opt/egos-)'; then
      PROD_RSYNC="$PROD_RSYNC $f"
    fi
  done
  if [ -n "$PROD_RSYNC" ]; then
    echo ""
    echo "❌ BLOCKED: rsync direto para produção fora de scripts/deploy-*.sh:"
    for f in $PROD_RSYNC; do echo "    $f"; done
    echo ""
    echo "   Origem: INC-PROD-001 (2026-05-13) — rsync sem gates causou catálogo vazio"
    echo "          em gpecas.egos.ia.br. Cada deploy DEVE usar script com R1-R8."
    echo ""
    echo "   Soluções:"
    echo "   1. Mover rsync pra scripts/deploy-<app>.sh seguindo template scripts/deploy-gpecas.sh"
    echo "   2. Adicionar gates: env validation, bundle compiled check, backup, smoke test, rollback"
    echo "   3. SSOT: docs/governance/PRODUCTION_DEPLOY_RULES.md §4"
    echo ""
    echo "   Override emergencial (use com cuidado, justifique em commit message):"
    echo "     PROD_RSYNC_OVERRIDE=1 git commit ..."
    if [ "${PROD_RSYNC_OVERRIDE:-0}" != "1" ]; then
      exit 1
    else
      echo "   ⚠️  OVERRIDE detectado (PROD_RSYNC_OVERRIDE=1) — commit prossegue"
    fi
  fi
fi
# === End Anti-Rsync-Prod Gate ===

# === Phantom CBC Check — PHANTOM-CBC-HOOK-001 (2026-05-18) ===
# Bloqueia CBC-*.md com status alpha/beta/stable mas case_count=0 (INC-008)
# Override: "PHANTOM_OVERRIDE: <reason>" no corpo do commit
if [ -x ".husky/_checks/12-phantom-cbc.sh" ]; then
  .husky/_checks/12-phantom-cbc.sh || exit 1
fi
# === End Phantom CBC Check ===

# === Codex Review (opt-in, non-blocking) — added 2026-05-12 ===
# Ativa com: export EGOS_CODEX_REVIEW=1
# SSOT: docs/governance/MULTI_LLM_ORCHESTRATION.md §4
if [ "${EGOS_CODEX_REVIEW:-0}" = "1" ] && command -v codex >/dev/null 2>&1; then
  DIFF_LINES=$(git diff --cached --shortstat 2>/dev/null | grep -oE '[0-9]+' | head -1 || echo 0)
  CRITICAL=$(git diff --cached --name-only 2>/dev/null | grep -E "^(auth|migrations|lib/prompts|docs/governance)/" | head -1 || true)
  MODEL="gpt-5.3-codex"
  if [ "${DIFF_LINES:-0}" -gt 500 ] || [ -n "$CRITICAL" ]; then
    MODEL="gpt-5.5"

exec
/bin/bash -lc "sed -n '900,1100p' .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:
    MODEL="gpt-5.5"
  fi
  echo "  [codex-review] running non-blocking review (model=$MODEL)..."
  git diff --cached | codex exec --model "$MODEL" "Review this staged diff briefly. Flag any bugs, security issues, or anti-patterns. Be concise." > .git/CODEX_REVIEW.md 2>&1 || true
  REVIEW_LINES=$(wc -l < .git/CODEX_REVIEW.md 2>/dev/null || echo 0)
  echo "  [codex-review] review at .git/CODEX_REVIEW.md (${REVIEW_LINES} lines)"
fi
# === End Codex Review ===

# [doc-sync] Enforcer code↔docs (Enio 2026-05-20)
# Default = warn-only. Ative strict via: export EGOS_DOC_SYNC_STRICT=1
if [ -x "scripts/pre-commit-doc-sync.sh" ]; then
  bash scripts/pre-commit-doc-sync.sh ".git/COMMIT_EDITMSG" 2>&1
  DOC_SYNC_EXIT=$?
  if [ "$DOC_SYNC_EXIT" = "2" ]; then
    echo "❌ EGOS Pre-Commit: doc-sync BLOCKED. Resolva e tente novamente."
    exit 1
  fi
fi
# === End doc-sync ===

# [governance-boundary] Central EGOS: governance NUNCA em clients/<slug>/ (2026-05-21)
if [ -x "scripts/pre-commit-governance-boundary.sh" ]; then
  bash scripts/pre-commit-governance-boundary.sh ".git/COMMIT_EDITMSG" 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ EGOS Pre-Commit: governance-boundary BLOCKED."
    exit 1
  fi
fi
# === End governance-boundary ===

# [db-discipline] INC-DB-001 (2026-05-22) — Anti-bug silencioso Supabase
if [ -x "scripts/pre-commit-db-discipline.sh" ]; then
  bash scripts/pre-commit-db-discipline.sh 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ EGOS Pre-Commit: db-discipline BLOCKED. SSOT: docs/governance/DB_DISCIPLINE.md"
    exit 1
  fi
fi
# === End db-discipline ===

echo "✅ EGOS Pre-Commit: Commit approved."

exec
/bin/bash -lc "jq '.roster, .agents | to_entries[0:3]' agents/registry/triggers.json && jq -r '.agents[] | [.upstream[], .downstream[]] | @tsv' agents/registry/triggers.json | tr '\\t' '\\n' | sort | uniq -c" in /home/enio/egos
 succeeded in 0ms:
[
  {
    "key": 0,
    "value": "sentinela"
  },
  {
    "key": 1,
    "value": "prime"
  },
  {
    "key": 2,
    "value": "forja"
  }
]
[
  {
    "key": "sentinela",
    "value": {
      "tier": "haiku",
      "runtime": "Hermes VPS (cron) / local",
      "role": "analista always-on — lê estado, flagga",
      "upstream": [],
      "downstream": [
        "prime"
      ],
      "trigger": "cron 10-15min (sleep-otimista)",
      "gates": [],
      "peers": "*",
      "dispatchable": true
    }
  },
  {
    "key": "prime",
    "value": {
      "tier": "opus",
      "runtime": "Claude Code",
      "role": "arquiteto/orquestrador — triagem R=L/C, decide, Red Zone, roteia",
      "upstream": [
        "sentinela",
        "guarani"
      ],
      "downstream": [
        "forja",
        "critico",
        "provador",
        "pixel",
        "voz",
        "hermes-ops",
        "investigador",
        "guardiao",
        "curador"
      ],
      "trigger": "on-demand (Enio) / flag da Sentinela",
      "gates": [
        "frozen-zone"
      ],
      "peers": "*",
      "dispatchable": false,
      "note": "Prime e Guarani NÃO são sub-agentes despacháveis (são runtimes)."
    }
  },
  {
    "key": "forja",
    "value": {
      "tier": "sonnet",
      "runtime": "Claude Code / worktree",
      "role": "developer — implementa código + testes, não commita",
      "upstream": [
        "prime"
      ],
      "downstream": [
        "critico"
      ],
      "trigger": "dispatch do Prime (task ID + plano + arquivos + critério)",
      "gates": [
        "pii-code",
        "frozen-zone"
      ],
      "peers": "*",
      "dispatchable": true
    }
  }
]
      4 critico
      1 curador
      4 forja
      1 guarani
      2 guardiao
      2 hermes-ops
      2 investigador
      2 pixel
     14 prime
      3 provador
      2 sentinela
      1 voz

exec
/bin/bash -lc "jq -r '.roster[]' agents/registry/triggers.json" in /home/enio/egos
 succeeded in 0ms:
sentinela
prime
forja
critico
provador
pixel
voz
hermes-ops
guarani
investigador
guardiao
curador

exec
/bin/bash -lc "sed -n '1,220p' packages/shared/src/mycelium/reference-graph.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Mycelium Reference Graph — Canonical Schema & Seed
 *
 * This is the Phase 1 implementation from REFERENCE_GRAPH_DESIGN.md.
 * It defines the canonical types for the EGOS mesh topology and seeds
 * the initial graph from current known surfaces.
 *
 * The reference graph answers: what exists, how it connects, and what
 * evidence proves each relation. It is NOT the event stream.
 *
 * @see docs/concepts/mycelium/REFERENCE_GRAPH_DESIGN.md
 */

// ═══════════════════════════════════════════════════════════
// Entity Types
// ═══════════════════════════════════════════════════════════

export type ReferenceEntityType =
  | 'workspace_root'
  | 'repository'
  | 'human'
  | 'artifact'
  | 'reference'
  | 'citation'
  | 'surface'
  | 'runtime'
  | 'agent'
  | 'worker'
  | 'endpoint'
  | 'event_topic'
  | 'queue'
  | 'database'
  | 'trigger'
  | 'bot'
  | 'document'
  | 'workflow'
  | 'issue'
  | 'task'
  | 'metric'
  | 'schema'
  | 'projection'
  | 'integration'
  | 'shadow_node'
  | 'policy'
  | 'reference_snapshot';

// ═══════════════════════════════════════════════════════════
// Relation Types
// ═══════════════════════════════════════════════════════════

export type ReferenceRelation =
  // Structural
  | 'belongs_to'
  | 'depends_on'
  | 'contains'
  | 'exposes'
  | 'subscribes_to'
  | 'emits'
  | 'persists_to'
  | 'reads_from'
  | 'writes_to'
  | 'routes_to'
  | 'references'
  | 'cites'
  | 'contributes_to'
  // Governance
  | 'documents'
  | 'governs'
  | 'tracks'
  | 'plans'
  | 'validates'
  | 'derives_from'
  | 'mirrors'
  | 'flags'
  // Evidence
  | 'observed_in_code'
  | 'observed_in_runtime'
  | 'observed_in_log'
  | 'observed_in_plan';

// ═══════════════════════════════════════════════════════════
// Evidence
// ═══════════════════════════════════════════════════════════

export type ReferenceEvidence = 'code' | 'runtime' | 'log' | 'plan' | 'issue';

export type NodeStatus = 'active' | 'degraded' | 'offline' | 'planned';

// ═══════════════════════════════════════════════════════════
// Core Interfaces
// ═══════════════════════════════════════════════════════════

export interface ReferenceNode {
  id: string;
  type: ReferenceEntityType;
  label: string;
  status: NodeStatus;
  evidence: ReferenceEvidence[];
  sourcePath?: string;
  note?: string;
  tags?: string[];
}

export interface ReferenceEdge {
  from: string;
  relation: ReferenceRelation;
  to: string;
  evidence: ReferenceEvidence[];
  note?: string;
}

export interface ReferenceGraph {
  version: string;
  generated: string;
  nodes: ReferenceNode[];
  edges: ReferenceEdge[];
}

// ═══════════════════════════════════════════════════════════
// Graph Utilities
// ═══════════════════════════════════════════════════════════

export function createGraph(
  nodes: ReferenceNode[],
  edges: ReferenceEdge[],
): ReferenceGraph {
  return {
    version: '1.0.0',
    generated: new Date().toISOString(),
    nodes,
    edges,
  };
}

export function findNode(graph: ReferenceGraph, id: string): ReferenceNode | undefined {
  return graph.nodes.find(n => n.id === id);
}

export function findEdgesFrom(graph: ReferenceGraph, nodeId: string): ReferenceEdge[] {
  return graph.edges.filter(e => e.from === nodeId);
}

export function findEdgesTo(graph: ReferenceGraph, nodeId: string): ReferenceEdge[] {
  return graph.edges.filter(e => e.to === nodeId);
}

export function nodesByType(graph: ReferenceGraph, type: ReferenceEntityType): ReferenceNode[] {
  return graph.nodes.filter(n => n.type === type);
}

export function nodesByStatus(graph: ReferenceGraph, status: NodeStatus): ReferenceNode[] {
  return graph.nodes.filter(n => n.status === status);
}

/**
 * Returns a health summary of the graph.
 */
export function graphHealth(graph: ReferenceGraph): {
  totalNodes: number;
  totalEdges: number;
  active: number;
  degraded: number;
  planned: number;
  offline: number;
  orphanNodes: string[];
} {
  const connectedIds = new Set<string>();
  for (const e of graph.edges) {
    connectedIds.add(e.from);
    connectedIds.add(e.to);
  }
  const orphanNodes = graph.nodes
    .filter(n => !connectedIds.has(n.id))
    .map(n => n.id);

  return {
    totalNodes: graph.nodes.length,
    totalEdges: graph.edges.length,
    active: graph.nodes.filter(n => n.status === 'active').length,
    degraded: graph.nodes.filter(n => n.status === 'degraded').length,
    planned: graph.nodes.filter(n => n.status === 'planned').length,
    offline: graph.nodes.filter(n => n.status === 'offline').length,
    orphanNodes,
  };
}

// ═══════════════════════════════════════════════════════════
// Kernel Seed Graph — Current EGOS Reality
// ═══════════════════════════════════════════════════════════

const KERNEL_NODES: ReferenceNode[] = [
  // Workspace roots
  { id: 'ws:egos-home', type: 'workspace_root', label: '~/.egos (Shared Governance)', status: 'active', evidence: ['code'], sourcePath: '~/.egos' },
  { id: 'ws:egos-kernel', type: 'repository', label: 'egos (Kernel)', status: 'active', evidence: ['code', 'runtime'], sourcePath: '/home/enio/egos' },

  // Leaf repos
  { id: 'repo:egos-lab', type: 'repository', label: 'egos-lab', status: 'active', evidence: ['code', 'runtime'], sourcePath: '/home/enio/egos-lab' },
  { id: 'repo:carteira-livre', type: 'repository', label: 'carteira-livre', status: 'active', evidence: ['code', 'runtime'], sourcePath: '/home/enio/carteira-livre' },
  { id: 'repo:br-acc', type: 'repository', label: 'br-acc', status: 'active', evidence: ['code', 'runtime'], sourcePath: '/home/enio/br-acc' },
  { id: 'repo:forja', type: 'repository', label: 'forja', status: 'active', evidence: ['code'], sourcePath: '/home/enio/forja' },
  { id: 'repo:852', type: 'repository', label: '852', status: 'active', evidence: ['code', 'runtime'], sourcePath: '/home/enio/852' },
  { id: 'repo:policia', type: 'repository', label: 'policia', status: 'degraded', evidence: ['code'], sourcePath: '/home/enio/policia' },
  { id: 'repo:egos-self', type: 'repository', label: 'egos-self', status: 'degraded', evidence: ['code'], sourcePath: '/home/enio/egos-self' },

  // Runtime surfaces
  { id: 'runtime:agent-runner', type: 'runtime', label: 'Agent Runner', status: 'active', evidence: ['code'], sourcePath: 'agents/runtime/runner.ts' },
  { id: 'runtime:event-bus', type: 'runtime', label: 'Event Bus', status: 'active', evidence: ['code'], sourcePath: 'agents/runtime/event-bus.ts' },

  // Agents
  { id: 'agent:context-tracker', type: 'agent', label: 'Context Tracker', status: 'active', evidence: ['code'], sourcePath: 'agents/agents/context-tracker.ts' },

  // Shared packages
  { id: 'pkg:llm-provider', type: 'integration', label: 'LLM Provider', status: 'active', evidence: ['code', 'runtime'], sourcePath: 'packages/shared/src/llm-provider.ts' },
  { id: 'pkg:model-router', type: 'integration', label: 'Model Router', status: 'active', evidence: ['code', 'runtime'], sourcePath: 'packages/shared/src/model-router.ts' },
  { id: 'pkg:atrian', type: 'integration', label: 'ATRiAN Validator', status: 'active', evidence: ['code'], sourcePath: 'packages/shared/src/atrian.ts' },
  { id: 'pkg:pii-scanner', type: 'integration', label: 'PII Scanner', status: 'active', evidence: ['code'], sourcePath: 'packages/shared/src/pii-scanner.ts' },
  { id: 'pkg:conversation-memory', type: 'integration', label: 'Conversation Memory', status: 'active', evidence: ['code'], sourcePath: 'packages/shared/src/conversation-memory.ts' },

  // Governance
  { id: 'doc:guarani', type: 'document', label: '.guarani Governance DNA', status: 'active', evidence: ['code'], sourcePath: '.guarani/' },

exec
/bin/bash -lc "nl -ba .husky/_checks/15-agent-gate.sh | sed -n '1,180p'
nl -ba scripts/mycelium-snapshot.ts | sed -n '80,120p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bash
     2	# 15-agent-gate.sh — AGENT-GATE-001
     3	# Exige roster + triggers.json + golden case ao criar nova persona LLM em .claude/agents/
     4	# Escape: status: agent_candidate no frontmatter | AGENT_GATE_SKIP=<razão> no env
     5	# NOTA: escape via commit body é IMPOSSÍVEL em pre-commit — COMMIT_EDITMSG ainda
     6	# contém a mensagem do commit ANTERIOR neste momento (fail-open detectado 2026-06-09:
     7	# 28bce96f documentava a string do escape e pulava o gate dos commits seguintes).
     8	# SSOT: docs/governance/EGOS_AGENT_ORGANIZATION.md §1
     9	
    10	set -euo pipefail
    11	
    12	# ── Skip explícito via env ────────────────────────────────────────────────────
    13	if [ -n "${AGENT_GATE_SKIP:-}" ]; then
    14	  echo "  [15] agent-gate SKIP via env: $AGENT_GATE_SKIP"
    15	  exit 0
    16	fi
    17	
    18	STAGED=$(git diff --cached --name-only 2>/dev/null || true)
    19	[ -z "$STAGED" ] && exit 0
    20	
    21	# ── Detectar arquivos novos de persona em .claude/agents/ ────────────────────
    22	# --diff-filter=A = apenas arquivos adicionados (novos)
    23	NEW_AGENTS=$(git diff --cached --name-only --diff-filter=A 2>/dev/null \
    24	  | grep -E "^\.claude/agents/[^/]+\.md$" \
    25	  | grep -vE "\-brief\.md$" \
    26	  | grep -vE "\-template\.md$" \
    27	  || true)
    28	
    29	[ -z "$NEW_AGENTS" ] && exit 0
    30	
    31	echo "  [15] agent-gate ativado: novos agentes detectados"
    32	
    33	# ── Processar cada arquivo de agente novo ─────────────────────────────────────
    34	GATE_FAILED=0
    35	
    36	while IFS= read -r AGENT_FILE; do
    37	  echo "  [15] verificando: $AGENT_FILE"
    38	
    39	  # Extrair as primeiras 10 linhas do arquivo staged
    40	  FRONTMATTER=$(git show ":$AGENT_FILE" 2>/dev/null | head -10 || true)
    41	
    42	  # Extrair name: e model: do frontmatter
    43	  HAS_NAME=$(echo "$FRONTMATTER" | grep -cE "^name: *[^[:space:]]+" || true)
    44	  HAS_MODEL=$(echo "$FRONTMATTER" | grep -cE "^model: *[^[:space:]]+" || true)
    45	
    46	  # ── Discriminação: fragmento vs persona ──────────────────────────────────
    47	  if [ "$HAS_NAME" -eq 0 ] || [ "$HAS_MODEL" -eq 0 ]; then
    48	    echo ""
    49	    echo "  [15] ⚠️  AVISO: frontmatter incompleto em $AGENT_FILE"
    50	    echo "  [15]    complete frontmatter com name: + model: ou renomeie para *-brief.md"
    51	    echo ""
    52	    # Warn apenas, não bloqueia
    53	    continue
    54	  fi
    55	
    56	  # Extrair o nome do agente
    57	  NAME=$(echo "$FRONTMATTER" | grep -oE "^name: *[^[:space:]]+" | head -1 | sed 's/^name: *//')
    58	
    59	  echo "  [15] persona detectada: '$NAME'"
    60	
    61	  # ── Verificar escape: status: agent_candidate ─────────────────────────────
    62	  IS_CANDIDATE=$(echo "$FRONTMATTER" | grep -cE "^status: *agent_candidate" || true)
    63	  if [ "$IS_CANDIDATE" -gt 0 ]; then
    64	    echo "  [15] ⚠️  CANDIDATO: '$NAME' — obrigações pendentes (ver AGENT-GATE-001)"
    65	    echo "  [15]    status: agent_candidate detectado — checagens puladas"
    66	    continue
    67	  fi
    68	
    69	  # ── Obrigação 1: NAME em EGOS_AGENT_ORGANIZATION.md ──────────────────────
    70	  ROSTER_FILE="docs/governance/EGOS_AGENT_ORGANIZATION.md"
    71	  if [ ! -f "$ROSTER_FILE" ]; then
    72	    echo ""
    73	    echo "  [15] ❌ AGENT-GATE: $ROSTER_FILE não encontrado"
    74	    GATE_FAILED=1
    75	    continue
    76	  fi
    77	
    78	  if ! grep -qi "$NAME" "$ROSTER_FILE" 2>/dev/null; then
    79	    echo ""
    80	    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' não está no roster $ROSTER_FILE §1"
    81	    echo "  [15]    Resolução: adicione '$NAME' em $ROSTER_FILE §1"
    82	    GATE_FAILED=1
    83	  else
    84	    echo "  [15] ✅ roster OK: '$NAME' encontrado em $ROSTER_FILE"
    85	  fi
    86	
    87	  # ── Obrigação 2: NAME em agents/registry/triggers.json ───────────────────
    88	  TRIGGERS_FILE="agents/registry/triggers.json"
    89	  if [ ! -f "$TRIGGERS_FILE" ]; then
    90	    echo ""
    91	    echo "  [15] ❌ AGENT-GATE: $TRIGGERS_FILE não encontrado"
    92	    GATE_FAILED=1
    93	  elif ! grep -q "$NAME" "$TRIGGERS_FILE" 2>/dev/null; then
    94	    echo ""
    95	    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem entrada em agents/registry/triggers.json"
    96	    echo "  [15]    Resolução: adicione '$NAME' em agents/registry/triggers.json"
    97	    GATE_FAILED=1
    98	  else
    99	    echo "  [15] ✅ triggers OK: '$NAME' encontrado em $TRIGGERS_FILE"
   100	  fi
   101	
   102	  # ── Obrigação 3: golden case em tests/eval/ ───────────────────────────────
   103	  EVAL_DIR="tests/eval"
   104	  if [ ! -d "$EVAL_DIR" ]; then
   105	    echo ""
   106	    echo "  [15] ❌ AGENT-GATE: diretório $EVAL_DIR não encontrado"
   107	    GATE_FAILED=1
   108	  else
   109	    GOLDEN_COUNT=$(find "$EVAL_DIR" -name "*${NAME}*" 2>/dev/null | wc -l || echo 0)
   110	    if [ "$GOLDEN_COUNT" -eq 0 ]; then
   111	      echo ""
   112	      echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem golden case em tests/eval/ (R7 — ≥1 obrigatório)"
   113	      echo "  [15]    Resolução: crie tests/eval/${NAME}-golden.md"
   114	      GATE_FAILED=1
   115	    else
   116	      echo "  [15] ✅ golden OK: $GOLDEN_COUNT arquivo(s) em $EVAL_DIR para '$NAME'"
   117	    fi
   118	  fi
   119	
   120	done <<< "$NEW_AGENTS"
   121	
   122	# ── Bloqueio se alguma obrigação falhou ───────────────────────────────────────
   123	if [ "$GATE_FAILED" -ne 0 ]; then
   124	  echo ""
   125	  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   126	  echo "  [15] ❌ AGENT-GATE-001: persona LLM sem obrigações cumpridas"
   127	  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   128	  echo ""
   129	  echo "  Para cada nova persona em .claude/agents/<name>.md, você precisa:"
   130	  echo ""
   131	  echo "  1. Registrar no roster:"
   132	  echo "       docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
   133	  echo ""
   134	  echo "  2. Registrar nos triggers:"
   135	  echo "       agents/registry/triggers.json"
   136	  echo ""
   137	  echo "  3. Criar ao menos 1 golden case:"
   138	  echo "       tests/eval/<name>-golden.md"
   139	  echo ""
   140	  echo "  ── ESCAPES ──────────────────────────────────────────────────────"
   141	  echo "  • Frontmatter do agente:  status: agent_candidate"
   142	  echo "    (warn apenas; obrigações ficam pendentes para commit futuro)"
   143	  echo ""
   144	  echo "  • Env var:      AGENT_GATE_SKIP=<razão> git commit ..."
   145	  echo ""
   146	  echo "  SSOT: AGENT-GATE-001 | docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
   147	  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   148	  echo ""
   149	  exit 1
   150	fi
   151	
   152	exit 0
    80	// ═══════════════════════════════════════════════════════════
    81	// Source 1 — Git repos
    82	// ═══════════════════════════════════════════════════════════
    83	
    84	const EXCLUDE_DIRS = new Set([
    85	  'node_modules', 'Trash', '.trash', 'archive', 'Archives',
    86	  'android-sdk', 'snap', 'go', 'bin', 'models', 'lancedb',
    87	  'ProgramasRFB', 'IRPF2026', 'anythingllm',
    88	  'antigravity-backup-20260402', 'antigravity-preserve-20260323-180052',
    89	  'antigravity-preserve-20260323-180054',
    90	  'egos_notebooklm_COMPLETO_2026-05-04', 'egos_templates_setoriais_2026-05-05',
    91	  'EGOSv2', 'EGOSv3', 'vps-backup-hetzner', 'windsurf_backups',
    92	  'backupfotosjessica', 'backups', 'backup',
    93	  'Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Public', 'Templates', 'Videos',
    94	  'reorganization-scripts', 'research-studies', 'testesEXAMES', 'INPI',
    95	  'Obsidian Vault', 'marizanotto-videos', 'CascadeProjects',
    96	]);
    97	
    98	function buildRepoNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
    99	  const nodes: ReferenceNode[] = [];
   100	  const edges: ReferenceEdge[] = [];
   101	
   102	  let homeDirs: string[];
   103	  try {
   104	    const raw = execSync(`ls -d /home/enio/*/`, { encoding: 'utf8', timeout: 5000 });
   105	    homeDirs = raw.trim().split('\n').map(d => d.replace(/\/$/, ''));
   106	  } catch {
   107	    homeDirs = [];
   108	  }
   109	
   110	  const WORKSPACE_ID = 'ws:egos-kernel';
   111	
   112	  for (const dirPath of homeDirs) {
   113	    const name = dirPath.split('/').pop() ?? '';
   114	    if (EXCLUDE_DIRS.has(name)) continue;
   115	    if (!existsSync(join(dirPath, '.git'))) continue;
   116	
   117	    const ts = gitLastCommitTs(dirPath);
   118	    const status = repoStatus(ts);
   119	    const id = `repo:${name}`;
   120	

exec
/bin/bash -lc 'grep -R "15-agent-gate" -n .husky/pre-commit .husky/_profiles .husky/_checks || true' in /home/enio/egos
 succeeded in 0ms:
.husky/_checks/15-agent-gate.sh:2:# 15-agent-gate.sh — AGENT-GATE-001

exec
/bin/bash -lc "cat package.json | jq '.scripts | with_entries(select(.key|test(\"mycelium|agent|precommit|lint|type\")))'" in /home/enio/egos
 succeeded in 0ms:
{
  "agent:list": "bun agents/cli.ts list",
  "agent:run": "bun agents/cli.ts run",
  "agent:lint": "bun agents/cli.ts lint-registry",
  "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
  "lint": "eslint .",
  "precommit": "bash .husky/pre-commit",
  "wiki:lint": "bun agents/agents/wiki-compiler.ts --lint"
}

codex
The added agent gate does not actually run as part of pre-commit, so the main enforcement change is ineffective. The snapshot script also silently omits repositories outside the author's hardcoded home path.

Full review comments:

- [P1] Wire the agent gate into pre-commit — /home/enio/egos/.husky/_checks/15-agent-gate.sh:21-27
  This new gate is never invoked by the commit hook: `.husky/pre-commit` calls checks 13 and 14 directly, but there is no call to `_checks/15-agent-gate.sh`. As a result, adding a new `.claude/agents/*.md` still bypasses the roster/triggers/golden-case enforcement entirely unless someone runs this script manually.

- [P2] Use the current home directory when scanning repos — /home/enio/egos/scripts/mycelium-snapshot.ts:102-105
  On any machine or user account where repos are not under `/home/enio`, this command throws and the catch silently returns no repo nodes, so the generated snapshot no longer reflects the machine-wide repository mesh. The script already computes `HOME = homedir()`, so this scan should use that instead of hardcoding one user path.
The added agent gate does not actually run as part of pre-commit, so the main enforcement change is ineffective. The snapshot script also silently omits repositories outside the author's hardcoded home path.

Full review comments:

- [P1] Wire the agent gate into pre-commit — /home/enio/egos/.husky/_checks/15-agent-gate.sh:21-27
  This new gate is never invoked by the commit hook: `.husky/pre-commit` calls checks 13 and 14 directly, but there is no call to `_checks/15-agent-gate.sh`. As a result, adding a new `.claude/agents/*.md` still bypasses the roster/triggers/golden-case enforcement entirely unless someone runs this script manually.

- [P2] Use the current home directory when scanning repos — /home/enio/egos/scripts/mycelium-snapshot.ts:102-105
  On any machine or user account where repos are not under `/home/enio`, this command throws and the catch silently returns no repo nodes, so the generated snapshot no longer reflects the machine-wide repository mesh. The script already computes `HOME = homedir()`, so this scan should use that instead of hardcoding one user path.
```
