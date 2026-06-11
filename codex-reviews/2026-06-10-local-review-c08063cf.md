# Codex Local Review — 2026-06-10T11:17:30Z

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
session id: 019eb140-721a-7191-8e0a-a3aec8ebcea9
--------
user
changes against 'HEAD~3'
2026-06-10T11:17:32.329573Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T11:17:32.329571Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 --stat && git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794' in /home/enio/egos
 succeeded in 0ms:
 .claude/agents/guarani.md                          |   81 +
 .claude/agents/prime.md                            |   63 +
 .claude/commands/disseminate.md                    |    7 +-
 .guarani/RULES_INDEX.md                            |    4 +-
 .husky/pre-commit                                  |    8 +
 AGENTS.md                                          |    9 +-
 CLAUDE.md                                          |   26 +-
 TASKS.md                                           |   20 +-
 agents/registry/leaf-repos.json                    |   88 +
 agents/subscribers/bus-redis-bridge.ts             |  117 ++
 agents/subscribers/sentinela-bus-subscriber.ts     |   85 +-
 apps/egos-landing/package.json                     |    4 +-
 apps/egos-landing/public/mycelium-snapshot.json    | 1761 ++++++++++++++++++++
 apps/egos-landing/public/timeline/rss              |    2 +-
 apps/egos-landing/public/timeline/rss.xml          |    2 +-
 apps/egos-landing/src/components/MyceliumPage.tsx  |  250 +--
 docs/governance/MODEL_DELEGATION_POLICY.md         |   92 +-
 docs/governance/MYCELIUM_BUS_DECISION.md           |   56 +
 docs/governance/RESOLVER_DOCTRINE.md               |    2 +-
 docs/governance/RULE_SETS_INDEX.md                 |    4 +-
 .../shared/src/mycelium/file-reference-manifest.ts |  198 +++
 scripts/disseminate-scanner.ts                     |   30 +-
 scripts/mycelium-snapshot.ts                       |   42 +
 scripts/test-mycelium-bus.ts                       |  281 +++-
 tests/eval/guarani-golden.md                       |   36 +
 tests/eval/prime-golden.md                         |   36 +
 26 files changed, 3084 insertions(+), 220 deletions(-)
diff --git a/.claude/agents/guarani.md b/.claude/agents/guarani.md
new file mode 100644
index 00000000..472a97cd
--- /dev/null
+++ b/.claude/agents/guarani.md
@@ -0,0 +1,81 @@
+---
+name: guarani
+description: "Auditor constitucional (Gemini tier) — coerência cross-layer, drift detection, propõe correções. Use para: auditoria de consistência de regras, detecção de phantom/drift em SSOTs, verificação de integridade pré-sprint. NÃO usa para: implementação, commit, decisões arquiteturais (propõe; Prime decide/commita)."
+model: claude-haiku-4-5
+status: agent_candidate
+---
+
+# Guarani — Auditor Constitucional
+
+# FONTE-DO-ROSTER: agents/registry/triggers.json — este arquivo descreve o papel;
+# triggers.json é SSOT de tier/upstream/downstream/dispatchable.
+# Em conflito, triggers.json prevalece.
+
+> **Equipe (autoconsciência):** você é 1 dos **12 agentes EGOS**. Os outros 11 pares, seus gatilhos (upstream/downstream) e os gates que você dispara vivem em [`agents/registry/triggers.json`](../../agents/registry/triggers.json) (SSOT, Banda 2026-06-03). Você existe e sabe que os outros existem — só se diferencia ao **assumir a postura**. Fluxo entre papéis: `docs/governance/EGOS_AGENT_ORGANIZATION.md` §2.
+
+**Tier:** Gemini (runtime Antigravity) | fallback: Haiku para auditorias locais
+**Runtime canônico:** Antigravity / cron 5min
+**Papel no registro:** `triggers.json → guarani` | `dispatchable: false` | downstream: prime
+
+> **Nota sobre model:** o campo `model` neste frontmatter é o fallback Claude local. O runtime canônico é Gemini via Antigravity. `dispatchable: false` — Guarani não é sub-agente; é runtime separado que reporta ao Prime.
+
+## Propósito
+
+Guardar a coerência constitucional do sistema. O Guarani lê continuamente as leis, SSOTs e estado do repo — e detecta drift antes que se torne incidente. **Propõe; nunca decide.** Toda proposta de Guarani passa pelo Prime antes de virar commit.
+
+## Escopo
+
+**PODE acessar (read-only):**
+- Todos os arquivos de lei: `AGENTS.md`, `CLAUDE.md` (global + repo), `.guarani/RULES_INDEX.md`, `docs/governance/RULE_SETS_INDEX.md`
+- `TASKS.md`, `CAPABILITY_REGISTRY.md`, `docs/MASTER_INDEX.md`
+- `agents/registry/triggers.json` — roster de papéis
+- `git log --oneline -20` + `git status` — estado do repo
+- `docs/jobs/` — jobs anteriores (detectar drift entre sessões)
+- Pre-commit hooks (verifica se gates estão wired, não só declarados)
+
+**NUNCA toca:**
+- Arquivos de código (`.ts`, `.tsx`, `.py`)
+- Frozen zones (`.guarani/orchestration/PIPELINE.md`, `.husky/pre-commit`, `agents/runtime/`)
+- Secrets / `.env`
+- Commit de qualquer natureza (Guarani propõe; Prime commita)
+
+## Gatilho
+
+- Cron 5min (Antigravity/Hermes)
+- On-demand: Prime solicita auditoria antes de sprint ou ADR
+
+## Output Format
+
+```
+GUARANI AUDIT — <timestamp>
+==========================
+COERÊNCIA: [CONSISTENTE | DRIFT DETECTADO | CONFLITO CONSTITUCIONAL]
+
+CONFLITOS:
+  [CONSTITUCIONAL] <lei A>:<linha> contradiz <lei B>:<linha> — proposta: <1 linha>
+  [DRIFT] <SSOT>:<claim> != <realidade> — proposta: <1 linha>
+  [PHANTOM] <path>:<linha> aponta arquivo inexistente — proposta: corrigir path
+
+PONTOS SAUDÁVEIS:
+  - <list> (confirmados nesta auditoria)
+
+PROPOSTA PARA O PRIME:
+  <patch específico ou task a criar>
+
+FONTES CONSULTADAS: <file:line para cada claim>
+```
+
+## Telemetria
+
+Todo ciclo loga em `~/.egos/agent-runs/guarani-<runid>.jsonl`:
+```json
+{"ts":"<ISO>","step":N,"action":"<descrição>","result":"<resumo>"}
+```
+
+## Regras EGOS aplicadas
+
+- **Evidence-first:** toda flag tem source (`arquivo:linha`)
+- **Guarani propõe; Prime commita** — nunca toca frozen zones; autoridade de proposta, não de decisão
+- **Cláusula-árbitro:** em conflito de REGRA de agente, AGENTS.md vence sobre .guarani; em conflito de PROCESSO/pipeline, .guarani vence
+- **Claim sem prova = UNVERIFIED:** prefixar achados não confirmados por leitura direta
+- **Sem `git add -A`** — mesmo que nunca commite, nunca prepara staging
diff --git a/.claude/agents/prime.md b/.claude/agents/prime.md
new file mode 100644
index 00000000..8e1ee2fd
--- /dev/null
+++ b/.claude/agents/prime.md
@@ -0,0 +1,63 @@
+---
+name: prime
+description: "Orquestrador/arquiteto (Opus tier) — triagem R=L/C, decide, Red Zone, distribui sprint, commita. Use para: decisões arquiteturais, triagem de achados, orquestração de sprint 3+ agentes, revisão de diff antes de commit, Red Zone com corte do Enio. NÃO usa para: implementação de feature, edição mecânica de código, commit de worktree (Prime commita o diff consolidado, nunca em paralelo com outro agente no mesmo repo)."
+model: opus
+status: agent_candidate
+---
+
+# Prime — Orquestrador/Arquiteto
+
+# FONTE-DO-ROSTER: agents/registry/triggers.json — este arquivo descreve o papel;
+# triggers.json é SSOT de tier/upstream/downstream/dispatchable.
+# Em conflito, triggers.json prevalece.
+
+> **Equipe (autoconsciência):** você é 1 dos **12 agentes EGOS**. Os outros 11 pares, seus gatilhos (upstream/downstream) e os gates que você dispara vivem em [`agents/registry/triggers.json`](../../agents/registry/triggers.json) (SSOT, Banda 2026-06-03). Você existe e sabe que os outros existem — só se diferencia ao **assumir a postura**. Fluxo entre papéis: `docs/governance/EGOS_AGENT_ORGANIZATION.md` §2.
+
+**Tier:** Opus (executor arquitetural) | ou Fable (papel arquiteto puro quando disponível — ver `docs/governance/MODEL_DELEGATION_POLICY.md`)
+**Runtime:** Claude Code (janela principal)
+**Papel no registro:** `triggers.json → prime` | `dispatchable: false` | upstream: sentinela, guarani
+
+## Propósito
+
+A **última camada de resolução**. O que para na porta do Prime é assumido — nunca devolvido com medo. Prime define arquitetura, faz triagem matemática (R=L/C), distribui trabalho, revisa diff dos agentes, commita consolidado. Nunca deixa trabalho empilhar por mais de 40 arquivos.
+
+## Escopo
+
+**FAZ:**
+- Triagem R=L/C de achados que chegam no contexto
+- Distribui tasks para forja/critico/provador/pixel/voz/hermes-ops/investigador/guardiao/curador
+- Revisa diffs entregues pelos agentes antes de commitar
+- Decide Red Zone (copywriting público, pricing, arquitetura, PII) — nunca auto-resolve, corte do Enio
+- Commit consolidado (`git add <arquivo-específico>`, nunca `git add -A`) — INC-002
+- Aciona `bun run typecheck` antes de declarar done
+- Mantém TASKS.md atualizado a cada decisão
+
+**NUNCA:**
+- `git add -A` ou `git add .` — INC-002
+- Commitar em paralelo com outro agente no mesmo index
+- Implementar feature diretamente (delega Forja)
+- Auto-resolver Red Zone sem corte do Enio
+- Declarar "done" sem evidência de typecheck + smoke passando (§10 CLAUDE.md)
+
+## Triagem Matemática
+
+Achado no meio do contexto: compute `R = L/C` antes de parar tudo.
+
+`L = Impact × StrategicFit × Urgency` (1-3 cada)
+`C = ContextCost × AgentCost` (1-3 cada)
+
+R ≥ 1.5 = RESOLVE NOW | 0.7-1.5 = task prioritized | < 0.7 = LEARNING: no commit body
+
+## Gatilho
+
+- Enio on-demand
+- Flag da Sentinela (flag CRÍTICO/ATENÇÃO)
+- Entrega de diff pela Forja/Pixel (revisão antes de commit)
+
+## Regras EGOS aplicadas
+
+- **Resolver Doctrine:** `docs/governance/RESOLVER_DOCTRINE.md` — Prime é a última camada
+- **Sem git add -A** — INC-002
+- **Red Zone → Enio:** nunca auto-resolver copy, pricing, PII, arquitetura irreversível
+- **Evidence-first:** toda declaração de "done" exige typecheck + smoke real
+- **Problema nunca chega 2×:** se delegação falhou e o problema voltou, Prime absorve e resolve
diff --git a/.claude/commands/disseminate.md b/.claude/commands/disseminate.md
index 49388528..d152a919 100644
--- a/.claude/commands/disseminate.md
+++ b/.claude/commands/disseminate.md
@@ -49,9 +49,10 @@ bun scripts/disseminate-propagator.ts --all                    # R2 leaves (bloc
 bash ~/.egos/sync.sh                                            # R2 symlinks + commands
 # ⚠️ GAP CRÍTICO (achado 2026-06-03): o propagator COMMITA nos leaves mas NÃO PUSHA.
 # "Disseminado" ≠ "commitado local" — só está disseminado quando está no GitHub.
-# PUSH OBRIGATÓRIO dos leaves que ficaram ahead:
-for d in /home/enio/intelink /home/enio/egos-inteligencia /home/enio/egos-lab /home/enio/852 \
-         /home/enio/smartbuscas /home/enio/santiago /home/enio/arch /home/enio/egos-self; do
+# PUSH OBRIGATÓRIO dos leaves que ficaram ahead.
+# Lista canônica lida de agents/registry/leaf-repos.json (MYCELIUM-006 — não editar aqui):
+LEAF_REPOS_JSON=~/egos/agents/registry/leaf-repos.json
+for d in $(jq -r '.leaf_repos[].path' "$LEAF_REPOS_JSON"); do
   [ -d "$d/.git" ] || continue
   ahead=$(git -C "$d" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
   [ "$ahead" -gt 0 ] && echo "push $(basename $d) ($ahead ahead)" && git -C "$d" push origin "$(git -C "$d" branch --show-current)" 2>&1 | grep -E "\->|rejected|error" | head -1
diff --git a/.guarani/RULES_INDEX.md b/.guarani/RULES_INDEX.md
index 8ed9c4bc..9687c34e 100644
--- a/.guarani/RULES_INDEX.md
+++ b/.guarani/RULES_INDEX.md
@@ -32,7 +32,7 @@
 | **MCP quality** | MCP_TOOL_QUALITY_FRAMEWORK.md | `.guarani/standards/MCP_TOOL_QUALITY_FRAMEWORK.md` |
 | **MCP usage / registry** | MCP_REGISTRY.md (§Quando usar MCP) | `docs/governance/MCP_REGISTRY.md` |
 | **Domain rules** | DOMAIN_RULES.md | `.guarani/orchestration/DOMAIN_RULES.md` |
-| **Open access sourcing** | OPEN_ACCESS_SOURCING_RULE.md | `docs/governance/OPEN_ACCESS_SOURCING_RULE.md` |
+| **Open access sourcing** | OPEN_ACCESS_INTEGRATION_RULE.md | `docs/governance/OPEN_ACCESS_INTEGRATION_RULE.md` |
 | **Agent scope gates** | agent-scope-check.ts | `scripts/security/agent-scope-check.ts` |
 | **Literature API** | OA REST + MCP | `apps/egos-hq/api/hq/literature/` + `packages/mcp-literature/` |
 | **Coordination monitor** | COORDINATION_MONITOR_SPEC.md | `docs/governance/COORDINATION_MONITOR_SPEC.md` |
@@ -84,7 +84,7 @@ When starting any work, check:
 > **Rule:** Challenge stale P0s, scope creep, and false claims (§16).
 > **Rule:** Every discovery/architecture decision must produce FACT/INFERENCE/PROPOSAL (§20).
 > **Rule:** Use Enio's vocabulary map for term translation (§21).
-> **Rule:** If any adapter surface (`CLAUDE.md`, `.windsurfrules`) conflicts with `.guarani`, `.guarani` wins.
+> **Rule (C1/C2 — cláusula-árbitro Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence. Adapters (`.windsurfrules`, `CLAUDE.md` repo-level) são subordinados a ambos conforme este árbitro.
 > **Rule:** Include task IDs in commit subjects for auto-propagation to TASKS.md (§28).
 > **Rule:** Add `LEARNING: <insight>` lines to commit bodies to auto-append to HARVEST.md (§28).
 > **Rule:** On `/start`, read last 3 days of `docs/jobs/` — surface CRITICAL as [BLOCKER] (§29).
diff --git a/.husky/pre-commit b/.husky/pre-commit
index f461d9e3..c8a0f04d 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -686,6 +686,14 @@ if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
   bash .husky/_checks/14-discover-gate.sh || exit 1
 fi
 
+# 15. Agent Gate — exige roster + triggers.json + golden case ao criar persona LLM (AGENT-GATE-001)
+# Escape: status: agent_candidate no frontmatter | AGENT-GATE-SKIP: <razão> no commit body
+# SSOT: docs/governance/EGOS_AGENT_ORGANIZATION.md §1
+if [ -x ".husky/_checks/15-agent-gate.sh" ]; then
+  echo "  [15/N] agent-gate: verificando obrigações de nova persona LLM..."
+  bash .husky/_checks/15-agent-gate.sh || exit 1
+fi
+
 # 6. File Intelligence — Classification + Compliance + PII scan
 echo "  [5/5] file intelligence: classifying and checking staged files..."
 bash scripts/file-intelligence.sh 2>/dev/null || {
diff --git a/AGENTS.md b/AGENTS.md
index a502bf68..b92392af 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -16,6 +16,8 @@ Output primes: non-negotiables, recent phantoms (INC-001..006), SSOT hashes, las
 
 This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**.
 
+> **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
+
 > 🃏 **4 pilares (TL;DR — resume R0-R8; conflito→texto completo. Corte Enio 2026-06-03):** **1)** §R0 safe-push, sem segredo, sem publish-sem-HITL, sem `git add -A`, commit TASKS.md já · **2)** §R1/R7 memory-mcp p/ código, externo=REAL/CONCEPT/PHANTOM, subagente=síntese, capacidade=≥3 golden cases · **3)** §R3/R4/R8/RLS frozen via Prime/`EGOS_FROZEN_OVERRIDE`, Guarani propõe/Prime commita, DB schema-first+RLS anon · **4)** §R2/Karpathy mínimo código, falhe visível, SSOT>duplicação.
 ### Highest-Leverage Rule
 EGOS maximizes value when it turns proven operational capability into governed reusable infrastructure.
@@ -121,6 +123,7 @@ Canonical eval strategy: `docs/knowledge/AI_EVAL_STRATEGY.md` (being written —
 
 **R10 — Cooperação e Banda Cognitiva (Guarani ↔ Prime - 2026-06-04):** O Guarani (runtime Antigravity/Gemini) propõe código e correções técnicas, mas NUNCA realiza commits diretamente. Toda alteração de produção proposta pelo Guarani DEVE passar pela revisão final do Prime (Claude Code/Opus). Decisões de segurança crítica, modificações no schema de Banco de Dados, regras de RLS ou arquivos em Frozen Zones exigem obrigatoriamente a invocação da Banda Cognitiva (`/banda`) com Força Total (`--council` acionando Opus/Gemini Pro/GPT-5 via OpenRouter), assegurando verificação estrutural e AST anti-phantom.
 **R-SEC-002 [T0] — Dado soberano nunca sai da máquina (INC-PII-001 2026-06-04):** dado real de investigação / PII de terceiros / dado PCMG NUNCA versionado em git (nem privado), NUNCA servido em domínio público, NUNCA em VPS/nuvem. Git = apenas dados sintéticos; dado real = local cifrado. App com dado real → nunca domínio público aberto. Scanner pré-commit: `bun scripts/security/scan-hardcoded-sensitive.ts --staged`.
+**R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente (corte Enio 2026-06-10):** vendor/preço/prazo/stack/canal de CLIENTE sem confirmação = PARE → placeholder (`{PAYMENT_PROVIDER}`, `{PRICE}`, `{TIMELINE}`) + trade-off dos 2 caminhos; cliente escolhe no diagnóstico. Consolida R-DIAG-002..006 + R-ARCH-CLIENT-VENDOR (mata a proliferação de 7 versões). Full: `egos/CLAUDE.md §R-ARCH-001` · SSOT: `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
 **R-SEC-003 [T1] — Segurança = enforcement:** toda regra de segurança DEVE ter gate executável. Scanner sem wiring = doc morto. Sugestão mock/fixture: `// scan-ok: mock` ou `<!-- scan-ok -->`. SSOT: `docs/INCIDENTS/INC-PII-001_investigation-data-leak.md`.
 **R-DISCOVER-001 [T2] — Discover-before-create (2026-06-08):** antes de criar capability nova (package/command/skill/CBC/registry), rodar `bun scripts/discover-capability.ts <termo>` e incluir `CONSULTED-SSOT: <resultado>` no commit body. Gate 14 bloqueia sem prova. Escape: `DISCOVER-GATE-SKIP: <razão>`. Evita INC-009-leaf-silo.
 **R11 [T2] — Observabilidade warn-not-block (2026-06-05):** falha em telemetria/agent-observatory = warn-only, nunca bloqueia execução de agente. SSOT: `docs/governance/MULTI_AGENT_OBSERVABILITY.md`.
@@ -139,8 +142,8 @@ Canonical eval strategy: `docs/knowledge/AI_EVAL_STRATEGY.md` (being written —
 - **Read next:**
   - `.guarani/RULES_INDEX.md` — canonical governance entry point
   - `TASKS.md` — current priorities
-  - `docs/SSOT_REGISTRY.md` — canonical cross-repo SSOT registry
-  - `docs/DOCUMENTATION_ARCHITECTURE_MAP.md` — principal documentation navigation map
+  - `docs/modules/SSOT_REGISTRY.md` — canonical cross-repo SSOT registry
+  - `docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md` — principal documentation navigation map
 
 <!-- llmrefs:end -->
 
@@ -193,4 +196,4 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 ## Templates de domínio (L0-DEF-002 — 2026-05-29)
 Vertical setorial em `central-egos/products/<slug>/` que herda Layer 0 (T0-T2 + R0-R6 + .guarani) sem duplicar. **Ativos:** advocacia-starter v1.0. **Protocolo:** (1) `INHERITS.md` obrigatório com frontmatter YAML; (2) overrides só via `OVERRIDES.md` com justificativa — T0 nunca sobrescrito; (3) duplicação do kernel deve virar ref curta. **SSOTs:** [LAYER_0_SSOT.md](docs/governance/LAYER_0_SSOT.md) · [TEMPLATE_INHERITANCE_PROTOCOL.md](docs/governance/TEMPLATE_INHERITANCE_PROTOCOL.md) · [DOMAIN_TEMPLATE_SPEC.md](docs/governance/DOMAIN_TEMPLATE_SPEC.md).
 ## Meta-Prompts + Docs
-`README.md` · `docs/MASTER_INDEX.md` · `docs/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/business/MONETIZATION_SSOT.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
+`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/business/MONETIZATION_SSOT.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
diff --git a/CLAUDE.md b/CLAUDE.md
index c71ea576..ee6cb208 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -16,7 +16,7 @@
 
 **O que os comandos fazem (enriquecem, não "ativam" a identidade):** `/start` = carrega contexto profundo da sessão (regras, memória, handoff, estado). `/opus` = aprofunda (Banda/Council/Fibonacci). `/end` = consolida e passa adiante. **Sem eles você ainda é EGOS — só com menos contexto carregado.** Se a conversa for não-trivial e você não rodou `/start`, ofereça rodá-lo para carregar o contexto completo.
 
-> Mapa de regras: `docs/governance/RULE_SETS_INDEX.md` · Constituição: `AGENTS.md` (R0-R8) + `~/.claude/CLAUDE.md` (T0-T4) + `.guarani/RULES_INDEX.md`. Em conflito: `.guarani` prevalece.
+> Mapa de regras: `docs/governance/RULE_SETS_INDEX.md` · Constituição: `AGENTS.md` (R0-R8) + `~/.claude/CLAUDE.md` (T0-T4) + `.guarani/RULES_INDEX.md`. **Cláusula-árbitro:** regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
 ---
 
@@ -121,6 +121,30 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 
 ---
 
+## R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente
+
+> Consolida R-DIAG-002..006 + R-ARCH-CLIENT-VENDOR. Corte Enio 2026-06-10. SSOT: `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
+
+Antes de especificar QUALQUER decisão que pertence ao cliente/humano, PARE e use placeholder.
+Decisões do cliente (NUNCA inferir): fornecedor de pagamento, gateway, banco, provider de OCR/IA,
+canal (WhatsApp/Telegram), preço, prazo, custo de infra, escopo, stack específica, ROI, % automação.
+
+**GATILHOS (prestes a escrever qualquer um destes SEM o cliente ter confirmado → PARE):**
+- nome de vendor concreto (Mercado Pago, OpenPix, EFÍ Bank, Twilio, AWS, Stripe…)
+- valor em R$ de preço/custo/economia para o cliente
+- prazo ("em X dias", "2 semanas", timeline de entrega)
+- "vamos usar [tecnologia]" numa spec de cliente
+- decisão técnica inferida apresentada como fato ("o CPF nunca vai ao LLM")
+- comparar 2 fornecedores e escolher um pelo cliente
+
+**EM VEZ DISSO:** use `{PAYMENT_PROVIDER}`, `{OCR_PROVIDER}`, `{WA_CHANNEL}`, `{PRICE}`, `{TIMELINE}`.
+Apresente o FLUXO arquitetural com o trade-off dos dois caminhos; o cliente escolhe no diagnóstico.
+
+**POR QUÊ:** decidir vendor sem conhecer o processo do cliente = tempo gasto numa decisão que não é nossa.
+O conhecimento do fluxo vem do diagnóstico (R-DIAG-001), não da inferência.
+
+---
+
 ## R-DIAG-001 — Diagnóstico Antes de Demo [T1 — Enio 2026-06-09]
 
 > Origem: tentação de "mostrar tudo funcionando" = desconfiança no próprio valor. Diagnóstico bem feito IS a prova de valor.
diff --git a/TASKS.md b/TASKS.md
index 2ce2736d..13a3ac4a 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -31,8 +31,8 @@
 > **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
 
 **🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
-- [ ] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`.
-- [ ] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo).
+- [x] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`. ✅ 2026-06-10
+- [x] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo). ✅ 2026-06-10
 
 **🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
 - [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
@@ -42,8 +42,8 @@
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
 - [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
-- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
-- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio).
+- [x] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001. ✅ 2026-06-10
+- [x] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). ✅ 2026-06-10
 
 **🧩 MCP CUSTOMIZADO = FEATURE PRINCIPAL DO EGOS (corte Enio 2026-06-10):**
 
@@ -88,9 +88,9 @@
 
 **🏛️ ENFORCEMENT SEMÂNTICO — plano de 3 camadas (Opus arquiteto 2026-06-10, SSOT `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`):**
 > Diagnóstico CONFIRMADO machine-wide: a regra "não decidir prematuro" não prevalece por **falta de DESCOBERTA** (vive em TASKS.md, não na constituição auto-carregada), não por falta de enforcement. 7 versões da mesma regra existem = a proliferação é o sintoma. LLM no pre-commit JÁ funciona (`ssot-router.ts:181` chama gemini-2.0-flash via Google AI Studio). Mas pre-commit é camada errada: o tempo já foi gasto na inferência. Ordem de alavancagem: Camada 1 > Camada 3 > Camada 2.
-- [ ] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão.
+- [x] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão. ✅ 2026-06-10
 - [ ] **RULE-SEMANTIC-L3-MCP-001** [P1] `prime`+`forja` `gated:MCP-EASY-INSTALL-001` — **Camada 3 (CURA PROFUNDA):** o playbook de diagnóstico + fluxos de referência viram tools/metaprompts no MCP EGOS → conhecimento do fluxo PRESENTE no momento da decisão (o que o Enio nomeou: "se tenho o fluxo, não perco esse tempo"). Elimina a causa-raiz upstream. Liga MCP-EASY-INSTALL-001.
-- [ ] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro.
+- [x] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro. ✅ 2026-06-10
 
 ## 🕸️ MYCELIUM v1 — interconexão REAL (corte Enio 2026-06-10, P0 — 1 ano de tentativa, 3 grafos divergentes, bus 7-pub/0-sub)
 
@@ -98,25 +98,25 @@
 > **Regra dura:** nenhuma task FIND nova neste programa enquanto fila RESOLVE P0+P1 > 5 itens. "Encontrar é barato, fechar é o produto."
 > **MYCELIUM-001 ✅ FECHADA** (archive L3846): snapshot REAL em `~/.egos/mycelium-snapshot.json` — 103 nós/129 arestas, 0 órfãos, gerado por `scripts/mycelium-snapshot.ts`.
 
-- [ ] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001`
+- [x] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×3=27
   AC: zero nodes/edges hardcoded em MyceliumPage.tsx; zero em egos-lab/mycelium-stats.ts; ambos lêem o snapshot
   Proof: screenshot MyceliumPage renderizando dados reais + `curl /api/mycelium/stats | jq '.nodeCount'`
   **MyceliumPage.tsx + egos-lab/mycelium-stats.ts** passam a LER o snapshot → mata 3 grafos divergentes
 
-- [ ] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001`
+- [x] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: blackboard lista estado de ≥10 repos (hoje só egos); colisão como d988385b não passa despercebida
   Proof: `cat ~/.egos/coordination-blackboard.json | jq '.repos | length'`
   **coordination-watcher machine-wide:** varre todos os repos do snapshot (hoje só egos; janelas cegas entre si — colisão d988385b é a prova)
 
-- [ ] **MYCELIUM-004** [P1] `forja` `gated:none`
+- [x] **MYCELIUM-004** [P1] `forja` `gated:none` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 2×3×3=18
   AC: evento `architecture.ssot_violation` publicado no bus gera flag visível em `~/.egos/sentinela-flags.jsonl`
   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
   **1º subscriber real no bus:** Sentinela assina `architecture.ssot_violation` → flag
 
-- [ ] **MYCELIUM-005** [P1] `prime` `gated:none`
+- [x] **MYCELIUM-005** [P1] `prime` `gated:none` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: registro formal da decisão em `docs/governance/MYCELIUM_BUS_DECISION.md` com Banda+premortem feitos
   Proof: arquivo criado com seção "Decisão Enio" preenchida
diff --git a/agents/registry/leaf-repos.json b/agents/registry/leaf-repos.json
new file mode 100644
index 00000000..c66470f8
--- /dev/null
+++ b/agents/registry/leaf-repos.json
@@ -0,0 +1,88 @@
+{
+  "$schema": "./schema.json",
+  "_ssot": "agents/registry/leaf-repos.json",
+  "_generated": "2026-06-10",
+  "_note": "Single canonical source of leaf repos for EGOS kernel dissemination. Read by disseminate-scanner.ts (DISS-001) and disseminate.md §3 push loop. MYCELIUM-006.",
+  "leaf_repos": [
+    {
+      "name": "852",
+      "path": "/home/enio/852",
+      "description": "852 Inteligência — Canal Anônimo para Policiais Civis de MG",
+      "ring": "R2"
+    },
+    {
+      "name": "br-acc",
+      "path": "/home/enio/br-acc",
+      "description": "EGOS Inteligência — Plataforma Aberta de Cruzamento de Dados Públicos",
+      "ring": "R2"
+    },
+    {
+      "name": "carteira-livre",
+      "path": "/home/enio/carteira-livre",
+      "description": "Carteira Livre — Marketplace de Instrutores de Trânsito Autônomos",
+      "ring": "R2"
+    },
+    {
+      "name": "intelink",
+      "path": "/home/enio/intelink",
+      "description": "Intelink — Sistema de Inteligência PCMG",
+      "ring": "R2"
+    },
+    {
+      "name": "egos-lab",
+      "path": "/home/enio/egos-lab",
+      "description": "egos-lab — Monorepo de Apps e Agents do Ecossistema EGOS",
+      "ring": "R2"
+    },
+    {
+      "name": "forja",
+      "path": "/home/enio/forja",
+      "description": "Forja — Assistente Operacional Corporativo",
+      "ring": "R2"
+    },
+    {
+      "name": "smartbuscas",
+      "path": "/home/enio/smartbuscas",
+      "description": "SmartBuscas — Automação de Extração e Contato",
+      "ring": "R2"
+    },
+    {
+      "name": "santiago",
+      "path": "/home/enio/santiago",
+      "description": "Café Santiago — Delivery App",
+      "ring": "R2"
+    },
+    {
+      "name": "commons",
+      "path": "/home/enio/commons",
+      "description": "EGOS Commons — Pacotes compartilhados (sem git próprio)",
+      "ring": "R2"
+    },
+    {
+      "name": "arch",
+      "path": "/home/enio/arch",
+      "description": "EGOS Arch — Referência de Arquitetura",
+      "ring": "R2"
+    },
+    {
+      "name": "egos-self",
+      "path": "/home/enio/egos-self",
+      "description": "EGOS Self — Repositório de auto-aprendizado e introspection",
+      "ring": "R2"
+    },
+    {
+      "name": "INPI",
+      "path": "/home/enio/INPI",
+      "description": "INPI — Integração com base de dados do INPI (sem git próprio)",
+      "ring": "R2"
+    },
+    {
+      "name": "egos-inteligencia",
+      "path": "/home/enio/egos-inteligencia",
+      "description": "EGOS Inteligência — alias symlink para /home/enio/br-acc (mesmo repo físico)",
+      "ring": "R2",
+      "alias_of": "br-acc",
+      "_note": "egos-inteligencia -> /home/enio/br-acc (symlink descoberto MYCELIUM-006). disseminate-propagator deve usar o path real br-acc, não o alias."
+    }
+  ]
+}
diff --git a/agents/subscribers/bus-redis-bridge.ts b/agents/subscribers/bus-redis-bridge.ts
new file mode 100644
index 00000000..b55b0641
--- /dev/null
+++ b/agents/subscribers/bus-redis-bridge.ts
@@ -0,0 +1,117 @@
+/**
+ * Bus→Redis Bridge — MYCELIUM-005 (Decisão A)
+ *
+ * Assina o bus in-process e re-publica cada evento no canal Redis
+ * `egos:mycelium:events` via redis-bridge (EGOS-089, zero deps).
+ *
+ * Design:
+ * - Fail-visible: Redis off → console.warn 1x, bus in-process continua
+ * - Solo o mínimo necessário para MYCELIUM-005 AC
+ * - Padrão wildcard '*' captura TODOS os tópicos (inclui architecture.ssot_violation)
+ *
+ * @module Mycelium/Bridge
+ */
+
+import {
+  createRedisBridge,
+  type RedisBridge,
+  type MyceliumEvent as RedisBridgeEvent,
+} from '../../packages/shared/src/mycelium/redis-bridge';
+import { type MyceliumBus, type MyceliumEvent } from '../runtime/event-bus';
+
+// ─── Config ───────────────────────────────────────────────────
+
+const REDIS_URL = process.env.REDIS_URL ?? 'redis://localhost:6379';
+const CHANNEL = 'egos:mycelium:events';
+
+// ─── Type mapping ─────────────────────────────────────────────
+
+/**
+ * Mapeia MyceliumEvent (bus interno) para RedisBridgeEvent (redis-bridge).
+ * O campo `type` do bridge aceita apenas os literais definidos no redis-bridge;
+ * usamos 'node_updated' como envelope genérico para eventos de bus.
+ */
+function toBridgeEvent(event: MyceliumEvent): RedisBridgeEvent {
+  return {
+    type: 'node_updated', // envelope genérico — payload contém o topic real
+    timestamp: event.timestamp,
+    source: event.source,
+    payload: {
+      busEventId: event.id,
+      topic: event.topic,
+      correlationId: event.correlationId,
+      payload: event.payload,
+      metadata: event.metadata,
+    },
+  };
+}
+
+// ─── Bridge handle ────────────────────────────────────────────
+
+export interface BusRedisBridgeHandle {
+  /** Para a ponte e fecha conexões Redis */
+  close: () => Promise<void>;
+  /** Transporte em uso: 'redis' | 'mock' */
+  readonly transport: string;
+}
+
+// ─── Main export ──────────────────────────────────────────────
+
+/**
+ * Liga o bus in-process ao canal Redis.
+ *
+ * Assina o padrão wildcard '*' no bus (todos os tópicos) e re-publica
+ * cada evento no canal `egos:mycelium:events` via redis-bridge.
+ *
+ * Fail-visible: se Redis não estiver disponível, redis-bridge retorna
+ * mock transport e logs vão para console.warn (comportamento de EGOS-089).
+ *
+ * @example
+ * ```ts
+ * const handle = await bridgeBusToRedis(getGlobalBus());
+ * // ... processo em execução ...
+ * await handle.close();
+ * ```
+ */
+export async function bridgeBusToRedis(bus: MyceliumBus): Promise<BusRedisBridgeHandle> {
+  let bridge: RedisBridge;
+
+  try {
+    bridge = await createRedisBridge({
+      redisUrl: REDIS_URL,
+      channel: CHANNEL,
+      publishOnMutation: false,
+    });
+  } catch (err) {
+    console.warn(
+      '[bus-redis-bridge] falha ao criar bridge Redis — eventos não serão propagados cross-process.',
+      (err as Error).message,
+    );
+    // Retorna handle no-op para não quebrar o processo
+    return {
+      transport: 'failed',
+      close: async () => {},
+    };
+  }
+
+  console.log(`[bus-redis-bridge] transport=${bridge.transport} channel=${CHANNEL}`);
+
+  // Assina todos os tópicos via wildcard '*'
+  const sub = bus.on('*', async (event: MyceliumEvent) => {
+    try {
+      await bridge.publish(toBridgeEvent(event));
+    } catch (err) {
+      console.warn('[bus-redis-bridge] publish error:', (err as Error).message);
+    }
+  }, 'bus-redis-bridge');
+
+  return {
+    transport: bridge.transport,
+
+    async close(): Promise<void> {
+      bus.off(sub);
+      await bridge.close();
+      console.log('[bus-redis-bridge] closed');
+    },
+  };
+}
diff --git a/agents/subscribers/sentinela-bus-subscriber.ts b/agents/subscribers/sentinela-bus-subscriber.ts
index cf0705e6..f737be4d 100644
--- a/agents/subscribers/sentinela-bus-subscriber.ts
+++ b/agents/subscribers/sentinela-bus-subscriber.ts
@@ -1,19 +1,12 @@
 /**
- * Sentinela Bus Subscriber — MYCELIUM-004
+ * Sentinela Bus Subscriber — MYCELIUM-004 / MYCELIUM-005
  *
- * Registers handlers on the Mycelium in-process bus for events that Sentinela
- * should persist to ~/.egos/sentinela-flags.jsonl.
+ * MYCELIUM-004: in-process subscriber (getGlobalBus) → ~/.egos/sentinela-flags.jsonl
+ * MYCELIUM-005: cross-process subscriber via Redis pub/sub (canal egos:mycelium:events)
  *
- * TOPOLOGIA IMPORTANTE (IN-PROCESS ONLY):
- *   O MyceliumBus é um singleton in-process (getGlobalBus() usa module-level _globalBus).
- *   Este subscriber recebe eventos apenas do MESMO processo Node/Bun.
- *   Quando runner.ts executa agentes em processo separado, os eventos publicados
- *   lá NÃO chegam aqui. A decisão de substrato cross-process (Redis pub/sub,
- *   JSONL tail, Unix socket, etc.) é MYCELIUM-005 — Red Zone, requer Prime.
- *
- *   USO VÁLIDO AGORA:
- *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
- *   - Orquestradores que importam este módulo e rodam agents no mesmo processo
+ * Topologia após MYCELIUM-005:
+ *   Processo runner: bus.emit → bus-redis-bridge → Redis canal egos:mycelium:events
+ *   Processo Sentinela: subscribeViaRedis() → lê do Redis → escreve flag JSONL
  *
  * @module Mycelium/Subscribers
  */
@@ -22,6 +15,10 @@ import { appendFileSync, mkdirSync, existsSync } from 'node:fs';
 import { resolve } from 'node:path';
 import { homedir } from 'node:os';
 import { getGlobalBus, Topics, type MyceliumEvent } from '../runtime/event-bus';
+import {
+  createRedisBridge,
+  type MyceliumEvent as RedisBridgeEvent,
+} from '../../packages/shared/src/mycelium/redis-bridge';
 
 // ─── Paths ────────────────────────────────────────────────────
 
@@ -102,3 +99,65 @@ export function registerSentinelaSubscriptions(): () => void {
     bus.off(archWildcardSub);
   };
 }
+
+// ─── Redis subscriber (MYCELIUM-005) ─────────────────────────
+
+const REDIS_URL_SENTINELA = process.env.REDIS_URL ?? 'redis://localhost:6379';
+const REDIS_CHANNEL = 'egos:mycelium:events';
+
+/**
+ * Abre subscrição no canal Redis e escreve flag JSONL para cada evento recebido.
+ * source = 'mycelium-redis' para distinguir de flags in-process.
+ *
+ * Returns a close function — call it to stop receiving and close the socket.
+ */
+export async function subscribeViaRedis(): Promise<() => Promise<void>> {
+  const bridge = await createRedisBridge({
+    redisUrl: REDIS_URL_SENTINELA,
+    channel: REDIS_CHANNEL,
+    publishOnMutation: false,
+  });
+
+  console.log(
+    `[sentinela-redis] subscribed to channel=${REDIS_CHANNEL} transport=${bridge.transport}`,
+  );
+
+  const unsubscribe = bridge.subscribe((bridgeEvent: RedisBridgeEvent) => {
+    // payload envelope criado por bus-redis-bridge.toBridgeEvent
+    const envelope = bridgeEvent.payload as {
+      busEventId?: string;
+      topic?: string;
+      correlationId?: string;
+      payload?: unknown;
+    } | null;
+
+    const topic = envelope?.topic ?? bridgeEvent.type;
+    const eventId = envelope?.busEventId ?? 'unknown';
+    const correlationId = envelope?.correlationId ?? 'unknown';
+    const innerPayload = envelope?.payload ?? bridgeEvent.payload;
+
+    if (!existsSync(EGOS_DIR)) {
+      mkdirSync(EGOS_DIR, { recursive: true });
+    }
+
+    const flag: BusFlag = {
+      ts: new Date().toISOString(),
+      event: topic,
+      payload: innerPayload,
+      source: 'mycelium-redis',
+      correlationId,
+      eventId,
+    };
+
+    appendFileSync(SENTINEL_FLAGS, JSON.stringify(flag) + '\n', 'utf8');
+    console.log(
+      `[sentinela-redis] flag written — topic=${topic} eventId=${eventId}`,
+    );
+  });
+
+  return async () => {
+    unsubscribe();
+    await bridge.close();
+    console.log('[sentinela-redis] unsubscribed and closed');
+  };
+}
diff --git a/apps/egos-landing/package.json b/apps/egos-landing/package.json
index d6e890e0..7c7358d5 100644
--- a/apps/egos-landing/package.json
+++ b/apps/egos-landing/package.json
@@ -5,7 +5,7 @@
   "type": "module",
   "scripts": {
     "dev": "vite",
-    "build": "bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && tsc -b && vite build",
+    "build": "bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && bun run ../../scripts/mycelium-snapshot.ts --exec --public --out ./public/mycelium-snapshot.json && tsc -b && vite build",
     "lint": "eslint .",
     "preview": "vite preview"
   },
@@ -28,4 +28,4 @@
     "typescript-eslint": "^8.59.2",
     "vite": "^8.0.12"
   }
-}
+}
\ No newline at end of file
diff --git a/apps/egos-landing/public/mycelium-snapshot.json b/apps/egos-landing/public/mycelium-snapshot.json
new file mode 100644
index 00000000..f405a85e
--- /dev/null
+++ b/apps/egos-landing/public/mycelium-snapshot.json
@@ -0,0 +1,1761 @@
+{
+  "version": "1.0.0",
+  "generated": "2026-06-10T11:03:48.094Z",
+  "nodes": [
+    {
+      "id": "ws:egos-kernel",
+      "type": "workspace_root",
+      "label": "EGOS Kernel",
+      "status": "active"
+    },
+    {
+      "id": "repo:egos-governance",
+      "type": "repository",
+      "label": "egos-governance",
+      "status": "active"
+    },
+    {
+      "id": "repo:egos-lab",
+      "type": "repository",
+      "label": "egos-lab",
+      "status": "active"
+    },
+    {
+      "id": "repo:egos-public-work",
+      "type": "repository",
+      "label": "egos-public-work",
+      "status": "active"
+    },
+    {
+      "id": "repo:gem-hunter",
+      "type": "repository",
+      "label": "gem-hunter",
+      "status": "active"
+    },
+    {
+      "id": "repo:hermes-egos",
+      "type": "repository",
+      "label": "hermes-egos",
+      "status": "active"
+    },
+    {
+      "id": "agent:sentinela",
+      "type": "agent",
+      "label": "sentinela",
+      "status": "active",
+      "tags": [
+        "tier:haiku",
+        "runtime:Hermes VPS (cron) / local"
+      ]
+    },
+    {
+      "id": "agent:prime",
+      "type": "agent",
+      "label": "prime",
+      "status": "active",
+      "tags": [
+        "tier:opus",
+        "runtime:Claude Code"
+      ]
+    },
+    {
+      "id": "agent:forja",
+      "type": "agent",
+      "label": "forja",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code / worktree"
+      ]
+    },
+    {
+      "id": "agent:critico",
+      "type": "agent",
+      "label": "critico",
+      "status": "active",
+      "tags": [
+        "tier:sonnet|codex",
+        "runtime:Codex / Sonnet"
+      ]
+    },
+    {
+      "id": "agent:provador",
+      "type": "agent",
+      "label": "provador",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:eval-runner"
+      ]
+    },
+    {
+      "id": "agent:pixel",
+      "type": "agent",
+      "label": "pixel",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code"
+      ]
+    },
+    {
+      "id": "agent:voz",
+      "type": "agent",
+      "label": "voz",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code"
+      ]
+    },
+    {
+      "id": "agent:hermes-ops",
+      "type": "agent",
+      "label": "hermes-ops",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Hermes / Claude Code"
+      ]
+    },
+    {
+      "id": "agent:guarani",
+      "type": "agent",
+      "label": "guarani",
+      "status": "active",
+      "tags": [
+        "tier:gemini",
+        "runtime:Antigravity"
+      ]
+    },
+    {
+      "id": "agent:investigador",
+      "type": "agent",
+      "label": "investigador",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code (+ MCP OSINT)"
+      ]
+    },
+    {
+      "id": "agent:guardiao",
+      "type": "agent",
+      "label": "guardiao",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code / pre-commit"
+      ]
+    },
+    {
+      "id": "agent:curador",
+      "type": "agent",
+      "label": "curador",
+      "status": "active",
+      "tags": [
+        "tier:sonnet",
+        "runtime:Claude Code / cron"
+      ]
+    },
+    {
+      "id": "policy:gate-ingest-real",
+      "type": "policy",
+      "label": "Gate: ingest-real",
+      "status": "active",
+      "tags": [
+        "hitl",
+        "wired"
+      ]
+    },
+    {
+      "id": "policy:gate-public-copy",
+      "type": "policy",
+      "label": "Gate: public-copy",
+      "status": "planned",
+      "tags": [
+        "hitl",
+        "unwired"
+      ]
+    },
+    {
+      "id": "policy:gate-pii-code",
+      "type": "policy",
+      "label": "Gate: pii-code",
+      "status": "planned",
+      "tags": [
+        "auto",
+        "unwired"
+      ]
+    },
+    {
+      "id": "policy:gate-prod-deploy",
+      "type": "policy",
+      "label": "Gate: prod-deploy",
+      "status": "planned",
+      "tags": [
+        "hitl",
+        "unwired"
+      ]
+    },
+    {
+      "id": "policy:gate-frozen-zone",
+      "type": "policy",
+      "label": "Gate: frozen-zone",
+      "status": "active",
+      "tags": [
+        "hitl",
+        "wired"
+      ]
+    },
+    {
+      "id": "worker:ssot-auditor",
+      "type": "worker",
+      "label": "SSOT Auditor",
+      "status": "active",
+      "tags": [
+        "area:architecture",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:ssot-fixer",
+      "type": "worker",
+      "label": "SSOT Fixer",
+      "status": "active",
+      "tags": [
+        "area:architecture",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:drift-sentinel",
+      "type": "worker",
+      "label": "Drift Sentinel",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:dep-auditor",
+      "type": "worker",
+      "label": "Dependency Auditor",
+      "status": "active",
+      "tags": [
+        "area:architecture",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:archaeology-digger",
+      "type": "worker",
+      "label": "Archaeology Digger",
+      "status": "active",
+      "tags": [
+        "area:knowledge",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:dead-code-detector",
+      "type": "worker",
+      "label": "Dead Code Detector",
+      "status": "active",
+      "tags": [
+        "area:qa",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:capability-drift-checker",
+      "type": "worker",
+      "label": "Capability Drift Checker",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:context-tracker",
+      "type": "worker",
+      "label": "Context Tracker",
+      "status": "active",
+      "tags": [
+        "area:observability",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:framework-benchmarker",
+      "type": "worker",
+      "label": "Framework Benchmarker",
+      "status": "active",
+      "tags": [
+        "area:knowledge",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:mcp-router",
+      "type": "worker",
+      "label": "MCP Router",
+      "status": "active",
+      "tags": [
+        "area:infrastructure",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:spec-router",
+      "type": "worker",
+      "label": "Spec Pipeline Router",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:workflow"
+      ]
+    },
+    {
+      "id": "worker:gem-hunter",
+      "type": "worker",
+      "label": "Gem Hunter v6.0",
+      "status": "active",
+      "tags": [
+        "area:intelligence",
+        "kind:discovery"
+      ]
+    },
+    {
+      "id": "worker:kol-discovery",
+      "type": "worker",
+      "label": "KOL Discovery",
+      "status": "planned",
+      "tags": [
+        "area:intelligence",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:gem-hunter-api",
+      "type": "worker",
+      "label": "Gem Hunter API",
+      "status": "planned",
+      "tags": [
+        "area:intelligence",
+        "kind:service"
+      ]
+    },
+    {
+      "id": "worker:agent-validator",
+      "type": "worker",
+      "label": "Agent Registry Validator",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:wiki-compiler",
+      "type": "worker",
+      "label": "Wiki Compiler",
+      "status": "active",
+      "tags": [
+        "area:knowledge",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:doc-drift-sentinel",
+      "type": "worker",
+      "label": "Doc-Drift Sentinel",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:undefined"
+      ]
+    },
+    {
+      "id": "worker:egos-pr",
+      "type": "worker",
+      "label": "EGOS PR Creator",
+      "status": "planned",
+      "tags": [
+        "area:git",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:article-writer",
+      "type": "worker",
+      "label": "Article Writer",
+      "status": "active",
+      "tags": [
+        "area:publishing",
+        "kind:undefined"
+      ]
+    },
+    {
+      "id": "worker:doc-drift-verifier",
+      "type": "worker",
+      "label": "Doc-Drift Verifier",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:undefined"
+      ]
+    },
+    {
+      "id": "worker:doc-drift-analyzer",
+      "type": "worker",
+      "label": "Doc-Drift Analyzer",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:undefined"
+      ]
+    },
+    {
+      "id": "worker:readme-syncer",
+      "type": "worker",
+      "label": "README Syncer",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:undefined"
+      ]
+    },
+    {
+      "id": "worker:chatbot-manifest-aggregator",
+      "type": "worker",
+      "label": "Chatbot Manifest Aggregator",
+      "status": "active",
+      "tags": [
+        "area:compliance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:skill-candidate-extractor",
+      "type": "worker",
+      "label": "Skill Candidate Extractor",
+      "status": "active",
+      "tags": [
+        "area:intelligence",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:chatbot-compliance-checker",
+      "type": "worker",
+      "label": "Chatbot Compliance Checker",
+      "status": "active",
+      "tags": [
+        "area:compliance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:gtm-harvester",
+      "type": "worker",
+      "label": "GTM Harvester",
+      "status": "active",
+      "tags": [
+        "area:intelligence",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "worker:capability-scanner",
+      "type": "worker",
+      "label": "Capability Scanner",
+      "status": "active",
+      "tags": [
+        "area:governance",
+        "kind:tool"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-governance",
+      "type": "shadow_node",
+      "label": "MCP: egos-governance",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-memory",
+      "type": "shadow_node",
+      "label": "MCP: egos-memory",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-knowledge",
+      "type": "shadow_node",
+      "label": "MCP: egos-knowledge",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-security",
+      "type": "shadow_node",
+      "label": "MCP: egos-security",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-eval-runner",
+      "type": "shadow_node",
+      "label": "MCP: egos-eval-runner",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-ops",
+      "type": "shadow_node",
+      "label": "MCP: egos-ops",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-skills-registry",
+      "type": "shadow_node",
+      "label": "MCP: egos-skills-registry",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-observability",
+      "type": "shadow_node",
+      "label": "MCP: egos-observability",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "integration:mcp-egos-browser-automation",
+      "type": "shadow_node",
+      "label": "MCP: egos-browser-automation",
+      "status": "active",
+      "tags": [
+        "mcp",
+        "integration"
+      ]
+    },
+    {
+      "id": "trigger:cron-governance-sync-MCAxMiAq",
+      "type": "trigger",
+      "label": "cron: governance-sync",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-scheduler-MCAqICog",
+      "type": "trigger",
+      "label": "cron: scheduler",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-unknown-cron-MCA2ICog",
+      "type": "trigger",
+      "label": "cron: unknown-cron",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-refresh-token-Ki81ICog",
+      "type": "trigger",
+      "label": "cron: refresh-token",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-session-aggregator-MzAgMiAq",
+      "type": "trigger",
+      "label": "cron: session-aggregator",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-governance-propagate-MCA0ICog",
+      "type": "trigger",
+      "label": "cron: governance-propagate",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-unknown-cron-MCAyICog",
+      "type": "trigger",
+      "label": "cron: unknown-cron",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-gmail-sync-MCAqLzQg",
+      "type": "trigger",
+      "label": "cron: gmail-sync",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-calendar-sync-MzAgKi80",
+      "type": "trigger",
+      "label": "cron: calendar-sync",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-drive-personal-sync-NDUgKi80",
+      "type": "trigger",
+      "label": "cron: drive-personal-sync",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-chatgpt-export-ingest-MTUgKiAq",
+      "type": "trigger",
+      "label": "cron: chatgpt-export-ingest",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-skill-usage-tracker-MCA2ICog",
+      "type": "trigger",
+      "label": "cron: skill-usage-tracker",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-autoresearch-MCA3ICog",
+      "type": "trigger",
+      "label": "cron: autoresearch",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-llm-usage-notify-MCA4ICog",
+      "type": "trigger",
+      "label": "cron: llm-usage-notify",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-llm-usage-notify-MCAqLzYg",
+      "type": "trigger",
+      "label": "cron: llm-usage-notify",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-agent-sentinela-Ki8xNSAq",
+      "type": "trigger",
+      "label": "cron: agent-sentinela",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "endpoint:egos-gateway",
+      "type": "shadow_node",
+      "label": "egos-gateway",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:3050"
+      ]
+    },
+    {
+      "id": "endpoint:egos-lab-chat",
+      "type": "shadow_node",
+      "label": "egos-lab-chat",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:3095"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-governance",
+      "type": "shadow_node",
+      "label": "MCP Governance",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7001"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-memory",
+      "type": "shadow_node",
+      "label": "MCP Memory",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7002"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-knowledge",
+      "type": "shadow_node",
+      "label": "MCP Knowledge",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7003"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-security",
+      "type": "shadow_node",
+      "label": "MCP Security",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7004"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-eval-runner",
+      "type": "shadow_node",
+      "label": "MCP Eval Runner",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7005"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-ops",
+      "type": "shadow_node",
+      "label": "MCP Ops",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7006"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-skills-registry",
+      "type": "shadow_node",
+      "label": "MCP Skills Registry",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7007"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-observability",
+      "type": "shadow_node",
+      "label": "MCP Observability",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7008"
+      ]
+    },
+    {
+      "id": "endpoint:mcp-browser-automation",
+      "type": "shadow_node",
+      "label": "MCP Browser Automation",
+      "status": "planned",
+      "tags": [
+        "endpoint",
+        "port:7009"
+      ]
+    }
+  ],
+  "edges": [
+    {
+      "from": "ws:egos-kernel",
+      "relation": "governs",
+      "to": "repo:egos-governance",
+      "evidence": [
+        "code"
+      ],
+      "note": "workspace governance"
+    },
+    {
+      "from": "ws:egos-kernel",
+      "relation": "governs",
+      "to": "repo:egos-lab",
+      "evidence": [
+        "code"
+      ],
+      "note": "workspace governance"
+    },
+    {
+      "from": "ws:egos-kernel",
+      "relation": "governs",
+      "to": "repo:egos-public-work",
+      "evidence": [
+        "code"
+      ],
+      "note": "workspace governance"
+    },
+    {
+      "from": "ws:egos-kernel",
+      "relation": "governs",
+      "to": "repo:gem-hunter",
+      "evidence": [
+        "code"
+      ],
+      "note": "workspace governance"
+    },
+    {
+      "from": "ws:egos-kernel",
+      "relation": "governs",
+      "to": "repo:hermes-egos",
+      "evidence": [
+        "code"
+      ],
+      "note": "workspace governance"
+    },
+    {
+      "from": "agent:sentinela",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:sentinela",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:guarani",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "upstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:forja",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:critico",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:provador",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:pixel",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:voz",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:hermes-ops",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:investigador",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:guardiao",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "routes_to",
+      "to": "agent:curador",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "validates",
+      "to": "policy:gate-frozen-zone",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: frozen-zone"
+    },
+    {
+      "from": "agent:prime",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:forja",
+      "relation": "routes_to",
+      "to": "agent:critico",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:forja",
+      "relation": "validates",
+      "to": "policy:gate-pii-code",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: pii-code"
+    },
+    {
+      "from": "agent:forja",
+      "relation": "validates",
+      "to": "policy:gate-frozen-zone",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: frozen-zone"
+    },
+    {
+      "from": "agent:forja",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:pixel",
+      "relation": "routes_to",
+      "to": "agent:critico",
+      "evidence": [
+        "code"
+      ],
+      "note": "upstream handoff"
+    },
+    {
+      "from": "agent:critico",
+      "relation": "routes_to",
+      "to": "agent:provador",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:critico",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:critico",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:forja",
+      "relation": "routes_to",
+      "to": "agent:provador",
+      "evidence": [
+        "code"
+      ],
+      "note": "upstream handoff"
+    },
+    {
+      "from": "agent:provador",
+      "relation": "routes_to",
+      "to": "agent:hermes-ops",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:provador",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:provador",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:pixel",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:pixel",
+      "relation": "validates",
+      "to": "policy:gate-public-copy",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: public-copy"
+    },
+    {
+      "from": "agent:pixel",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:voz",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:voz",
+      "relation": "validates",
+      "to": "policy:gate-public-copy",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: public-copy"
+    },
+    {
+      "from": "agent:voz",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:hermes-ops",
+      "relation": "routes_to",
+      "to": "agent:sentinela",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:hermes-ops",
+      "relation": "validates",
+      "to": "policy:gate-prod-deploy",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: prod-deploy"
+    },
+    {
+      "from": "agent:hermes-ops",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:guarani",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:investigador",
+      "relation": "routes_to",
+      "to": "agent:guardiao",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:investigador",
+      "relation": "validates",
+      "to": "policy:gate-ingest-real",
+      "evidence": [
+        "code"
+      ],
+      "note": "fires gate: ingest-real"
+    },
+    {
+      "from": "agent:investigador",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:forja",
+      "relation": "routes_to",
+      "to": "agent:guardiao",
+      "evidence": [
+        "code"
+      ],
+      "note": "upstream handoff"
+    },
+    {
+      "from": "agent:guardiao",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:guardiao",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "agent:curador",
+      "relation": "routes_to",
+      "to": "agent:prime",
+      "evidence": [
+        "code"
+      ],
+      "note": "downstream handoff"
+    },
+    {
+      "from": "agent:curador",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:ssot-auditor",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:ssot-fixer",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:drift-sentinel",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:dep-auditor",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:archaeology-digger",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:dead-code-detector",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:capability-drift-checker",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:context-tracker",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:framework-benchmarker",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:mcp-router",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:spec-router",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:gem-hunter",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:kol-discovery",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:gem-hunter-api",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:agent-validator",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:wiki-compiler",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:doc-drift-sentinel",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:egos-pr",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:article-writer",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:doc-drift-verifier",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:doc-drift-analyzer",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:readme-syncer",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:chatbot-manifest-aggregator",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:skill-candidate-extractor",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:chatbot-compliance-checker",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:gtm-harvester",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "worker:capability-scanner",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-governance",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-memory",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-knowledge",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-security",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-eval-runner",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-ops",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-skills-registry",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-observability",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "integration:mcp-egos-browser-automation",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-governance-sync-MCAxMiAq",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-scheduler-MCAqICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-unknown-cron-MCA2ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-refresh-token-Ki81ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-session-aggregator-MzAgMiAq",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-governance-propagate-MCA0ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-unknown-cron-MCAyICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-gmail-sync-MCAqLzQg",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-calendar-sync-MzAgKi80",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-drive-personal-sync-NDUgKi80",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-chatgpt-export-ingest-MTUgKiAq",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-skill-usage-tracker-MCA2ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-autoresearch-MCA3ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-llm-usage-notify-MCA4ICog",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-llm-usage-notify-MCAqLzYg",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-agent-sentinela-Ki8xNSAq",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "endpoint:egos-gateway",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:egos-lab-chat",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-governance",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-memory",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-knowledge",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-security",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-eval-runner",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-ops",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-skills-registry",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-observability",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    },
+    {
+      "from": "endpoint:mcp-browser-automation",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "plan"
+      ]
+    }
+  ]
+}
\ No newline at end of file
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index adc532e6..d61770b9 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:03:48 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index adc532e6..d61770b9 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:03:48 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 63e0a41d..15937033 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -1,10 +1,11 @@
 import { useState, useEffect, useMemo } from 'react'
 import { supabase } from '../lib/supabase'
 
-type NodeStatus = 'active' | 'degraded' | 'planned'
+// ─── Types matching the visual layer ───
+type NodeStatus = 'active' | 'degraded' | 'planned' | 'offline'
 type NodeType =
   | 'workspace_root' | 'repository' | 'runtime' | 'agent'
-  | 'integration' | 'document' | 'workflow'
+  | 'integration' | 'document' | 'workflow' | 'worker' | 'policy' | 'trigger'
 
 interface Node {
   id: string
@@ -19,103 +20,51 @@ interface Edge {
   to: string
 }
 
-interface LiveEvent {
+// ─── Snapshot shape (subset we consume from /mycelium-snapshot.json) ───
+interface SnapshotNode {
   id: string
-  nodeId: string
-  eventType: string
+  type: string
   label: string
-  color: string
-  detail: string
-  timestamp: string
+  status: string
 }
 
-const NODES: Node[] = [
-  // Workspace roots
-  { id: 'ws:egos-home', type: 'workspace_root', label: '~/.egos (Governance)', status: 'active' },
-  { id: 'ws:egos-kernel', type: 'workspace_root', label: 'egos (Kernel)', status: 'active' },
-  // Leaf repos
-  { id: 'repo:egos-lab', type: 'repository', label: 'egos-lab', status: 'active' },
-  { id: 'repo:carteira-livre', type: 'repository', label: 'carteira-livre', status: 'active' },
-  { id: 'repo:br-acc', type: 'repository', label: 'br-acc', status: 'active' },
-  { id: 'repo:forja', type: 'repository', label: 'forja', status: 'active' },
-  { id: 'repo:852', type: 'repository', label: '852', status: 'active' },
-  { id: 'repo:policia', type: 'repository', label: 'policia', status: 'degraded' },
-  { id: 'repo:egos-self', type: 'repository', label: 'egos-self', status: 'degraded' },
-  // Runtime
-  { id: 'runtime:agent-runner', type: 'runtime', label: 'Agent Runner', status: 'active' },
-  { id: 'runtime:event-bus', type: 'runtime', label: 'Event Bus', status: 'active' },
-  // Agents
-  { id: 'agent:context-tracker', type: 'agent', label: 'Context Tracker', status: 'active' },
-  // Shared packages & integrations
-  { id: 'pkg:llm-provider', type: 'integration', label: 'LLM Provider', status: 'active' },
-  { id: 'pkg:model-router', type: 'integration', label: 'Model Router', status: 'active' },
-  { id: 'pkg:atrian', type: 'integration', label: 'ATRiAN Validator', status: 'active' },
-  { id: 'pkg:pii-scanner', type: 'integration', label: 'PII Scanner', status: 'active' },
-  { id: 'pkg:conversation-memory', type: 'integration', label: 'Conversation Memory', status: 'active' },
-  { id: 'integration:whatsapp', type: 'integration', label: 'WhatsApp Gateway', status: 'active' },
-  { id: 'integration:telegram', type: 'integration', label: 'Telegram Gateway', status: 'active' },
-  // Governance docs
-  { id: 'doc:guarani', type: 'document', label: '.guarani DNA', status: 'active' },
-  { id: 'doc:domain-rules', type: 'document', label: 'Domain Rules', status: 'active' },
-  { id: 'doc:pipeline', type: 'document', label: 'Orchestration Pipeline', status: 'active' },
-  { id: 'script:gov-sync', type: 'workflow', label: 'Governance Sync', status: 'active' },
-  // Workflows
-  { id: 'wf:start', type: 'workflow', label: '/start', status: 'active' },
-  { id: 'wf:end', type: 'workflow', label: '/end', status: 'active' },
-  { id: 'wf:mycelium', type: 'workflow', label: '/mycelium', status: 'active' },
-  // Meta-prompts
-  { id: 'prompt:strategist', type: 'document', label: 'Universal Strategist', status: 'active' },
-  { id: 'prompt:brainet', type: 'document', label: 'Brainet Collective', status: 'active' },
-  { id: 'prompt:mycelium', type: 'document', label: 'Mycelium Orchestrator', status: 'active' },
-  { id: 'prompt:audit', type: 'document', label: 'Ecosystem Audit', status: 'active' },
-]
+interface SnapshotEdge {
+  from: string
+  relation: string
+  to: string
+}
 
-const EDGES: Edge[] = [
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'doc:guarani' },
-  { from: 'doc:guarani', relation: 'contains', to: 'doc:domain-rules' },
-  { from: 'doc:guarani', relation: 'contains', to: 'doc:pipeline' },
-  { from: 'script:gov-sync', relation: 'mirrors', to: 'ws:egos-home' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-lab' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:carteira-livre' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:br-acc' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:forja' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-self' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:agent-runner' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:event-bus' },
-  { from: 'runtime:agent-runner', relation: 'depends_on', to: 'pkg:llm-provider' },
-  { from: 'pkg:llm-provider', relation: 'depends_on', to: 'pkg:model-router' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:llm-provider' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:model-router' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:atrian' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:pii-scanner' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:conversation-memory' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:llm-provider' },
-  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:852', relation: 'derives_from', to: 'pkg:atrian' },
-  { from: 'repo:852', relation: 'derives_from', to: 'pkg:conversation-memory' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:conversation-memory' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:conversation-memory' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'agent:context-tracker' },
-  { from: 'agent:context-tracker', relation: 'emits', to: 'wf:end' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:start' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:end' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:mycelium' },
-  { from: 'script:gov-sync', relation: 'routes_to', to: 'wf:start' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:strategist' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:brainet' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:mycelium' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:audit' },
-  { from: 'ws:egos-home', relation: 'references', to: 'repo:policia' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'integration:whatsapp' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'integration:telegram' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'runtime:agent-runner' },
-]
+interface MyceliumSnapshot {
+  version: string
+  generated: string
+  nodes: SnapshotNode[]
+  edges: SnapshotEdge[]
+}
+
+// ─── Map snapshot entity types → visual NodeType ───
+function toVisualType(raw: string): NodeType {
+  switch (raw) {
+    case 'workspace_root': return 'workspace_root'
+    case 'repository': return 'repository'
+    case 'runtime': return 'runtime'
+    case 'agent': return 'agent'
+    case 'integration':
+    case 'shadow_node': return 'integration'
+    case 'document': return 'document'
+    case 'workflow': return 'workflow'
+    case 'worker': return 'worker'
+    case 'policy': return 'policy'
+    case 'trigger': return 'trigger'
+    default: return 'integration'
+  }
+}
+
+function toNodeStatus(raw: string): NodeStatus {
+  if (raw === 'active' || raw === 'degraded' || raw === 'planned' || raw === 'offline') return raw
+  return 'planned'
+}
 
+// ─── Visual metadata per NodeType ───
 const TYPE_META: Record<NodeType, { icon: string; color: string; label: string }> = {
   workspace_root: { icon: '🌐', color: '#38bdf8', label: 'Workspace' },
   repository: { icon: '📦', color: '#818cf8', label: 'Repositório' },
@@ -124,29 +73,34 @@ const TYPE_META: Record<NodeType, { icon: string; color: string; label: string }
   integration: { icon: '🔌', color: '#a78bfa', label: 'Pacote / Canal' },
   document: { icon: '📄', color: '#fbbf24', label: 'Governança' },
   workflow: { icon: '⚙️', color: '#f472b6', label: 'Workflow' },
+  worker: { icon: '🛠️', color: '#22d3ee', label: 'Worker' },
+  policy: { icon: '🛡️', color: '#f87171', label: 'Policy' },
+  trigger: { icon: '⏱️', color: '#a3e635', label: 'Trigger' },
 }
 
 // ─── Graph layout (deterministic layered bands, top → bottom = a história do sistema) ───
 
 const VB_W = 1180
-const VB_H = 840
+const VB_H = 900
 const MARGIN_X = 72
 
 const BANDS: { y: number; types: NodeType[]; label: string }[] = [
-  { y: 60, types: ['document'], label: 'Governança & Meta-prompts' },
+  { y: 60, types: ['document', 'policy'], label: 'Governança & Policies' },
   { y: 196, types: ['workspace_root'], label: 'Workspace' },
   { y: 320, types: ['runtime', 'agent'], label: 'Runtime & Agentes' },
-  { y: 468, types: ['integration'], label: 'Pacotes & Canais' },
-  { y: 624, types: ['repository'], label: 'Repositórios governados' },
-  { y: 768, types: ['workflow'], label: 'Workflows' },
+  { y: 450, types: ['worker'], label: 'Workers' },
+  { y: 570, types: ['integration'], label: 'Pacotes & Canais' },
+  { y: 700, types: ['repository'], label: 'Repositórios governados' },
+  { y: 840, types: ['workflow', 'trigger'], label: 'Workflows & Triggers' },
 ]
 
-function computeLayout(): Record<string, { x: number; y: number }> {
+function computeLayout(nodes: Node[]): Record<string, { x: number; y: number }> {
   const pos: Record<string, { x: number; y: number }> = {}
   const inner = VB_W - MARGIN_X * 2
   for (const band of BANDS) {
-    const bandNodes = NODES.filter(n => band.types.includes(n.type))
+    const bandNodes = nodes.filter(n => band.types.includes(n.type))
     const count = bandNodes.length
+    if (count === 0) continue
     bandNodes.forEach((node, i) => {
       const x = count === 1 ? VB_W / 2 : MARGIN_X + inner * (i / (count - 1))
       pos[node.id] = { x, y: band.y }
@@ -158,7 +112,6 @@ function computeLayout(): Record<string, { x: number; y: number }> {
 function edgePath(a: { x: number; y: number }, b: { x: number; y: number }): string {
   const dy = b.y - a.y
   if (Math.abs(dy) < 4) {
-    // same band → bow downward so it doesn't overlap the band line
     const midX = (a.x + b.x) / 2
     return `M ${a.x} ${a.y} Q ${midX} ${a.y + 44} ${b.x} ${b.y}`
   }
@@ -228,11 +181,19 @@ function buildChatStep(
   }
 }
 
-function countEdges(nodeId: string): number {
-  return EDGES.filter(e => e.from === nodeId || e.to === nodeId).length
+interface LiveEvent {
+  id: string
+  nodeId: string
+  eventType: string
+  label: string
+  color: string
+  detail: string
+  timestamp: string
 }
 
 export function MyceliumPage() {
+  const [snapshot, setSnapshot] = useState<MyceliumSnapshot | null>(null)
+  const [loadError, setLoadError] = useState<string | null>(null)
   const [activePulses, setActivePulses] = useState<Record<string, { color: string; ts: number }>>({})
   const [eventLog, setEventLog] = useState<LiveEvent[]>([])
   const [liveConnected, setLiveConnected] = useState(false)
@@ -240,21 +201,47 @@ export function MyceliumPage() {
   const [chatState, setChatState] = useState<ChatState>('WELCOME')
   const [guideOpen, setGuideOpen] = useState(true)
 
-  const layout = useMemo(() => computeLayout(), [])
-  const nodeById = useMemo(() => Object.fromEntries(NODES.map(n => [n.id, n])), [])
+  // ─── Load snapshot from public/ (populated at build time by mycelium-snapshot.ts --out) ───
+  useEffect(() => {
+    fetch('/mycelium-snapshot.json')
+      .then(r => {
+        if (!r.ok) throw new Error(`HTTP ${r.status}`)
+        return r.json() as Promise<MyceliumSnapshot>
+      })
+      .then(data => setSnapshot(data))
+      .catch((e: unknown) => setLoadError(e instanceof Error ? e.message : String(e)))
+  }, [])
+
+  // ─── Derive typed nodes/edges from snapshot ───
+  const { nodes, edges } = useMemo((): { nodes: Node[]; edges: Edge[] } => {
+    if (!snapshot) return { nodes: [], edges: [] }
+    const nodes: Node[] = snapshot.nodes.map(n => ({
+      id: n.id,
+      type: toVisualType(n.type),
+      label: n.label,
+      status: toNodeStatus(n.status),
+    }))
+    const nodeIds = new Set(nodes.map(n => n.id))
+    const edges: Edge[] = snapshot.edges
+      .filter(e => nodeIds.has(e.from) && nodeIds.has(e.to))
+      .map(e => ({ from: e.from, relation: e.relation, to: e.to }))
+    return { nodes, edges }
+  }, [snapshot])
+
+  const layout = useMemo(() => computeLayout(nodes), [nodes])
+  const nodeById = useMemo(() => Object.fromEntries(nodes.map(n => [n.id, n])), [nodes])
 
-  // neighbors of the selected node (for focus mode)
   const neighbors = useMemo(() => {
     if (!selectedNodeId) return null
     const set = new Set<string>([selectedNodeId])
-    for (const e of EDGES) {
+    for (const e of edges) {
       if (e.from === selectedNodeId) set.add(e.to)
       if (e.to === selectedNodeId) set.add(e.from)
     }
     return set
-  }, [selectedNodeId])
+  }, [selectedNodeId, edges])
 
-  // Realtime subscription
+  // ─── Realtime subscription ───
   useEffect(() => {
     const channel = supabase.channel('mycelium_live')
     channel
@@ -295,12 +282,34 @@ export function MyceliumPage() {
   const currentChatStep = buildChatStep(chatState, setChatState, triggerSimulation)
 
   const simButtons = [
-    { id: 'integration:whatsapp', et: 'whatsapp_msg', label: '💬 WhatsApp Msg', color: '#10b981', detail: 'Simulando: Mensagem recebida via Evolution API' },
-    { id: 'integration:telegram', et: 'telegram_msg', label: '🤖 Telegram Cmd', color: '#38bdf8', detail: 'Simulando: Comando /custo executado pelo admin' },
-    { id: 'runtime:event-bus', et: 'heartbeat', label: '⚡ System Heartbeat', color: '#fb923c', detail: 'Simulando: Sentinela daemon audit status OK' },
-    { id: 'pkg:pii-scanner', et: 'pii_finding', label: '🛡️ PII Guard Alert', color: '#f43f5e', detail: 'Simulando: Gate R-SEC-002 interceptou vazamento' },
+    { id: 'integration:mcp-egos-security', et: 'whatsapp_msg', label: '💬 WhatsApp Msg', color: '#10b981', detail: 'Simulando: Mensagem recebida via Evolution API' },
+    { id: 'integration:mcp-egos-browser-automation', et: 'telegram_msg', label: '🤖 Telegram Cmd', color: '#38bdf8', detail: 'Simulando: Comando /custo executado pelo admin' },
+    { id: 'ws:egos-kernel', et: 'heartbeat', label: '⚡ System Heartbeat', color: '#fb923c', detail: 'Simulando: Sentinela daemon audit status OK' },
+    { id: 'policy:gate-pii-code', et: 'pii_finding', label: '🛡️ PII Guard Alert', color: '#f43f5e', detail: 'Simulando: Gate R-SEC-002 interceptou vazamento' },
   ]
 
+  function countEdges(nodeId: string): number {
+    return edges.filter(e => e.from === nodeId || e.to === nodeId).length
+  }
+
+  if (loadError) {
+    return (
+      <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
+        <p style={{ color: '#f87171', fontWeight: 700 }}>Erro ao carregar grafo do sistema</p>
+        <p style={{ fontSize: '12px', fontFamily: 'var(--font-mono)' }}>{loadError}</p>
+        <p style={{ fontSize: '12px' }}>Execute: <code>bun run ../../scripts/mycelium-snapshot.ts --exec --out ./public/mycelium-snapshot.json</code></p>
+      </div>
+    )
+  }
+
+  if (!snapshot) {
+    return (
+      <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
+        <p>Carregando grafo do sistema…</p>
+      </div>
+    )
+  }
+
   return (
     <div className="mycelium-wrap">
       <style>{`
@@ -337,11 +346,16 @@ export function MyceliumPage() {
             <strong style={{ color: 'var(--text-primary)' }}> Clique num nó</strong> para focar suas conexões, ou use o
             <strong style={{ color: 'var(--text-primary)' }}> simulador →</strong> para ver um evento pulsar pelo grafo.
           </p>
+          {snapshot.generated && (
+            <p style={{ fontSize: '10px', color: 'var(--text-dim)', marginTop: '6px' }}>
+              snapshot: {new Date(snapshot.generated).toLocaleString('pt-BR')}
+            </p>
+          )}
 
           <div style={{ display: 'flex', justifyContent: 'center', gap: '12px', flexWrap: 'wrap', marginTop: '16px' }}>
             {[
-              { label: 'Nós', value: NODES.length, color: 'var(--accent)' },
-              { label: 'Conexões', value: EDGES.length, color: '#a78bfa' },
+              { label: 'Nós', value: nodes.length, color: 'var(--accent)' },
+              { label: 'Conexões', value: edges.length, color: '#a78bfa' },
               { label: 'Stream', value: liveConnected ? 'LIVE 🟢' : 'CONECTANDO 🟡', color: liveConnected ? '#10b981' : '#f59e0b' },
             ].map(s => (
               <div key={s.label} style={{
@@ -389,7 +403,7 @@ export function MyceliumPage() {
             ))}
 
             {/* edges */}
-            {EDGES.map((e, i) => {
+            {edges.map((e, i) => {
               const a = layout[e.from]; const b = layout[e.to]
               if (!a || !b) return null
               const hot = activePulses[e.from] || activePulses[e.to]
@@ -411,7 +425,7 @@ export function MyceliumPage() {
             })}
 
             {/* nodes */}
-            {NODES.map(node => {
+            {nodes.map(node => {
               const p = layout[node.id]
               if (!p) return null
               const meta = TYPE_META[node.type]
@@ -460,7 +474,7 @@ export function MyceliumPage() {
         )}
       </div>
 
-      {/* ── Right: guia + simulador + stream (o que torna o grafo "vivo") ── */}
+      {/* ── Right: guia + simulador + stream ── */}
       <div className="mycelium-side">
         {/* Guide (collapsible) */}
         <section style={{ border: '1px solid var(--accent)', borderRadius: '14px', background: 'var(--bg-surface)', overflow: 'hidden' }}>
diff --git a/docs/governance/MODEL_DELEGATION_POLICY.md b/docs/governance/MODEL_DELEGATION_POLICY.md
index 7bd5d7c4..d6ffab0f 100644
--- a/docs/governance/MODEL_DELEGATION_POLICY.md
+++ b/docs/governance/MODEL_DELEGATION_POLICY.md
@@ -9,28 +9,47 @@
 
 ## 🎯 Princípio
 
-**Opus é caro. Sonnet é o padrão. Haiku é mecânico.**
+**O ARQUITETO desenha. O EXECUTOR-COMPLEXO executa o pesado. O EXECUTOR-PADRÃO executa o padrão. O MECÂNICO faz o repetitivo.**
 
-Toda task entra primeiro pelo filtro: *"isso precisa de inteligência Opus, ou Sonnet/Haiku resolve?"*
+| Papel | Modelo atual | Nota |
+|---|---|---|
+| ARQUITETO | Claude Fable 5 | janela grátis até 2026-06-22; fallback: Opus assume papel |
+| EXECUTOR-COMPLEXO | Claude Opus 4.7 | — |
+| EXECUTOR-PADRÃO | Claude Sonnet 4.6 | padrão de sessão (TOKEN-START-SONNET-001) |
+| MECÂNICO | Claude Haiku 4.5 | — |
 
-Quando entrar no Claude Code, **o modelo padrão da janela principal deve ser Sonnet 4.6**, exceto quando o usuário explicitamente subir para Opus ou quando a task casa com os critérios de Opus abaixo.
+> Esta tabela é o ÚNICO lugar onde nomes de modelo aparecem. Critérios e enforcement referenciam PAPÉIS. Quando o modelo mudar, só esta tabela muda.
 
-Quando estiver em Opus, **delegar agressivamente** para Sonnet/Haiku via `Agent` tool com `model: "sonnet"` ou `"haiku"`. Opus orquestra, Sonnet executa, Haiku faz o mecânico.
+Toda task entra pelo filtro de 4 papéis: *"isso precisa do ARQUITETO, EXECUTOR-COMPLEXO, ou EXECUTOR-PADRÃO/MECÂNICO resolve?"*
+
+Quando entrar no Claude Code, **o modelo padrão da janela principal deve ser EXECUTOR-PADRÃO (Sonnet 4.6)** [TOKEN-START-SONNET-001], exceto quando a task casa com critérios ARQUITETO ou EXECUTOR-COMPLEXO abaixo.
+
+ARQUITETO orquestra e define, EXECUTOR-COMPLEXO executa o pesado, EXECUTOR-PADRÃO executa o padrão, MECÂNICO faz o repetitivo. ARQUITETO **nunca implementa/commita** — apenas desenha arquitetura e distribui. Se ARQUITETO indisponível, EXECUTOR-COMPLEXO assume o papel.
 
 ---
 
-## 🧠 Critérios — qual modelo usar
+## 🧠 Critérios — qual papel usar
+
+### ARQUITETO — usa-se SOMENTE quando (papel: desenha/orquestra/audita, nunca executa):
+
+1. **ADR Tier-1** — decisões arquiteturais irreversíveis de sistema (framework, pivot, topologia de agentes)
+2. **Auditoria adversarial de sistema** — revisão da espinha dorsal, integridade constitucional, drift cross-layer
+3. **Orquestração de sprint com N≥3 agentes paralelos** — define fila, distribui missões, não executa
+4. **Desenho de Red Zone** — define como resolver, quem executa, qual gate — nunca toca o código/dado em si
+5. **Revisão de ADR proposto pelo EXECUTOR-COMPLEXO** — segunda camada de validação arquitetural
 
-### OPUS 4.7 — usa-se SOMENTE quando:
+> ARQUITETO **NUNCA implementa, NUNCA commita, NUNCA edita arquivos**. O pesado desce para EXECUTOR-COMPLEXO/PADRÃO.
+> Se ARQUITETO indisponível (janela expirada ou quota): **EXECUTOR-COMPLEXO assume o papel** para os itens 1-5 acima.
 
-1. **Decisões arquiteturais irreversíveis** — escolha de framework, pivot, ADR Tier 1
-2. **Diagnóstico de incidente em produção** — root cause analysis quando 2+ teorias competem
-3. **Refatoração crítica em código com 500+ LOC interdependentes** — onde um erro de leitura causa cascata
-4. **Revisão de PR onde Sonnet/Haiku falharam 2× ou mais** — escalation
-5. **Negociação fina com user** — quando o user está hesitante e precisa de orientação contextualizada (Banda Cognitiva, Council, Tutor mode)
-6. **Coordenação de sprint com 3+ agentes paralelos** — quem distribui, revisa, e integra
-7. **Análise de copy pública/pricing/ethical** — Red Zones (ENIO_UNDERSTANDING_MAP)
-8. **Investigação cross-repo de bug** — quando precisa correlacionar 4+ arquivos em 2+ repos
+### EXECUTOR-COMPLEXO — usa-se SOMENTE quando:
+
+1. **Execução de alta complexidade** — diagnóstico de incidente prod com 2+ teorias competindo
+2. **Refatoração crítica em código com 500+ LOC interdependentes** — onde um erro de leitura causa cascata
+3. **Revisão de PR onde EXECUTOR-PADRÃO falhou 2× ou mais** — escalation
+4. **Negociação fina com user** — Banda Cognitiva, Council, Tutor mode, orientação contextualizada
+5. **Análise de copy pública/pricing/ethical** — Red Zones (ENIO_UNDERSTANDING_MAP)
+6. **Investigação cross-repo de bug** — correlacionar 4+ arquivos em 2+ repos
+7. **Papel ARQUITETO quando ARQUITETO indisponível** — assume itens ARQUITETO 1-5 acima
 
 ### SONNET 4.6 — modelo PADRÃO. Use sempre que:
 
@@ -78,9 +97,10 @@ Opus DEVE usar `Agent` tool com `model: "sonnet"` ou `"haiku"` em vez de fazer o
 
 ---
 
-## 🚀 Sessões de Execução Começam em Sonnet [TOKEN-START-SONNET-001 — 2026-06-04]
+## 🚀 Sessões de Execução Começam em EXECUTOR-PADRÃO [TOKEN-START-SONNET-001 — 2026-06-04]
 
 > Origem: TOKEN_MODEL_ROUTING_AUDIT.md D-01 + insight cache_read (REAL).
+> **ARQUITETO:** janelas ARQUITETO são para arquitetura pura (ADR, auditoria, orquestração N≥3). Sessões ARQUITETO também começam em EXECUTOR-PADRÃO se possível; escalar para ARQUITETO só ao confirmar tarefa arquitetural. TOKEN-START-SONNET-001 mantido para todas as janelas.
 
 ### Por que isso importa
 
@@ -149,14 +169,15 @@ Esta regra é aplicada via `CLAUDE.md §Token Economy` ("Modelo padrão: Sonnet
 ### `/start` — modelo padrão
 
 O `/start` v6.10+ deve:
-1. Detectar se janela atual é Opus
-2. Se Opus E task pode ser Sonnet: sugerir downgrade ou delegar
-3. Reportar custo acumulado se Opus E sessão >$1.50
+1. Detectar papel da janela atual (ARQUITETO/EXECUTOR-COMPLEXO/EXECUTOR-PADRÃO/MECÂNICO)
+2. Se ARQUITETO E task não é arquitetural/auditoria/orquestração N≥3: sugerir downgrade para EXECUTOR-PADRÃO
+3. Se EXECUTOR-COMPLEXO E task pode ser EXECUTOR-PADRÃO: sugerir downgrade ou delegar
+4. Reportar custo acumulado se EXECUTOR-COMPLEXO/ARQUITETO E sessão >$1.50
 
 ### `CLAUDE.md` — citar em §6 Agent & Swarm Rules
 
-Adicionar bullet:
-> **Modelo padrão Sonnet 4.6.** Opus 4.7 só para critérios de OPUS_DELEGATION_POLICY §"Quando usar Opus". Outras tarefas: delegue para Sonnet via Agent tool com `model: "sonnet"`.
+Substituir bullet existente por:
+> **Modelo padrão Sonnet 4.6 (EXECUTOR-PADRÃO).** ARQUITETO só para: ADR Tier-1, auditoria de sistema, orquestração N≥3, Red Zone design. EXECUTOR-COMPLEXO só para: execução complexa, diagnóstico prod, escalation 2×, Red Zone review. MECÂNICO: repetitivo. **TOKEN-START-SONNET-001:** toda sessão começa EXECUTOR-PADRÃO. Se ARQUITETO indisponível → EXECUTOR-COMPLEXO assume papel. Ver tabela papel→modelo em MODEL_DELEGATION_POLICY.md.
 
 ### Pre-commit hook (opcional, futuro)
 
@@ -179,28 +200,39 @@ Sinais que devem disparar escalation manual do user para Opus:
 
 ```
 ENTRA TASK:
-  → Decisão arquitetural? Red Zone? Diagnóstico crítico?
-      SIM → Opus
+  → ADR Tier-1? Auditoria de sistema? Orquestração N≥3 agentes? Desenho de Red Zone?
+      SIM → ARQUITETO (se disponível) | EXECUTOR-COMPLEXO (fallback)
+      NÃO ↓
+  → Diagnóstico prod? Escalation 2×? Red Zone execução? Refactor 500+ LOC?
+      SIM → EXECUTOR-COMPLEXO
       NÃO ↓
   → Implementação seguindo plano? Refactor com padrão claro?
-      SIM → Sonnet (delega se já em Opus)
+      SIM → EXECUTOR-PADRÃO (delega se já em EXECUTOR-COMPLEXO)
       NÃO ↓
   → Tarefa mecânica (grep, rename, batch read, typecheck)?
-      SIM → Haiku
-      NÃO → Sonnet (default)
+      SIM → MECÂNICO
+      NÃO → EXECUTOR-PADRÃO (default)
 
-EM SESSÃO OPUS:
+EM SESSÃO ARQUITETO:
+  → Qualquer implementação/edição de arquivo?
+      SIM → Dispatch EXECUTOR-COMPLEXO ou EXECUTOR-PADRÃO — ARQUITETO não toca código
+      NÃO → manter ARQUITETO para desenho/orquestração
+
+EM SESSÃO EXECUTOR-COMPLEXO:
   → Vou escrever doc/test/refactor extenso?
       SIM → Agent({model:"sonnet"}) com plano cirúrgico
-      NÃO → manter Opus
+      NÃO → manter EXECUTOR-COMPLEXO
 
 ESCALATION:
-  → Sonnet falhou 2× no mesmo problema → Opus
-  → User pediu "pensa bem" / "/banda" / "/council" → Opus
-  → Red Zone (copy, pricing, ética) → Opus
+  → EXECUTOR-PADRÃO falhou 2× no mesmo problema → EXECUTOR-COMPLEXO
+  → User pediu "pensa bem" / "/banda" / "/council" → EXECUTOR-COMPLEXO
+  → Red Zone (copy, pricing, ética) → EXECUTOR-COMPLEXO (+ ARQUITETO para desenho da solução)
 ```
 
+> Ver tabela papel→modelo no topo deste documento para saber qual modelo corresponde a cada papel hoje.
+
 ---
 
 *v1.0 — 2026-05-20 (decisão Enio "vamos usar Sonnet como principal quando não tiver necessidade de Opus")*
 *v1.1 — 2026-06-04 (TOKEN-START-SONNET-001: seção explícita "Sessões de Execução Começam em Sonnet" + por que cache_read é 5× mais caro em Opus)*
+*v1.2 — 2026-06-09 (redesenho Codex §3-P2: 4 papéis por função — ARQUITETO/EXECUTOR-COMPLEXO/EXECUTOR-PADRÃO/MECÂNICO; tabela papel→modelo única no topo; criterios referenciam papéis não nomes de modelo; fallback ARQUITETO→EXECUTOR-COMPLEXO. Auditoria: FABLE5_BACKBONE_AUDIT §2/§3)*
diff --git a/docs/governance/MYCELIUM_BUS_DECISION.md b/docs/governance/MYCELIUM_BUS_DECISION.md
new file mode 100644
index 00000000..d443416f
--- /dev/null
+++ b/docs/governance/MYCELIUM_BUS_DECISION.md
@@ -0,0 +1,56 @@
+# MYCELIUM-005 — Decisão de Substrato do Event Bus (cross-process)
+
+> **Status:** AGUARDA CORTE ENIO · **Preparado:** 2026-06-10 (Fable 5, papel arquiteto) · AI⟷AI doc
+> **Task:** MYCELIUM-005 [P1] Red Zone — substrato de eventos cross-process
+> **Gatilho:** MYCELIUM-004 provou o mecanismo subscriber→flag, mas CONFIRMOU gap: `getGlobalBus()` é singleton in-process (`agents/runtime/event-bus.ts:278-289`). Publishers (`ssot-auditor.ts:2332`, `capability-drift-checker.ts:167`, `chatbot-compliance-checker.ts:40`) rodam no processo do runner; Sentinela roda em processo próprio. Sem ponte, o bus continua 7-pub/0-sub na prática.
+
+---
+
+## Fatos verificados (CONFIRMADO nesta sessão)
+
+| Fato | Evidência |
+|---|---|
+| Bus é EventEmitter singleton por processo | `event-bus.ts:278-289` (FROZEN — não muda) |
+| Redis JÁ RODA na máquina | `pgrep redis-server` ativo; `/usr/bin/redis-server` instalado |
+| Bridge Redis JÁ EXISTE no shared | `packages/shared/src/mycelium/redis-bridge.ts` (EGOS-089): RESP2 via `net` nativo, ZERO dependência de client, graceful degradation se Redis off |
+| Subscriber Sentinela pronto | `agents/subscribers/sentinela-bus-subscriber.ts` (MYCELIUM-004, commit nesta sessão) |
+| Payloads contêm metadados sensíveis | eventos de ssot_violation citam paths/repos da máquina (inclui repos de investigação) |
+
+## Opções
+
+### A — Redis pub/sub local (RECOMENDADA pelo arquiteto)
+Runner publica no bus in-process → hook no bus re-publica via redis-bridge (canal `egos:mycelium:events`) → Sentinela assina o canal.
+- **Custo:** ~0 infra (Redis já roda; bridge já escrita). Wiring: ~30-60 linhas fora de frozen zones.
+- **Soberania:** localhost only — dado nunca sai da máquina (R-SEC-002 ✅).
+- **Falha:** graceful — Redis off = log, bus in-process continua (liveness preservada).
+
+### B — JSONL append + tail-poll
+Publisher appenda `~/.egos/bus-events.jsonl`; Sentinela faz tail-poll.
+- **Custo:** zero infra, ~40 linhas. **Contra:** polling (latência), rotação de arquivo, lock em writes concorrentes, sem semântica pub/sub (cada novo consumer reimplementa offset).
+
+### C — Supabase Realtime
+- **Contra decisivo:** eventos de coordenação local iriam à NUVEM com paths/nomes de repos de investigação → conflita com R-SEC-002 (dado soberano nunca sai da máquina). Exigiria sanitização por evento = complexidade + risco. Só faria sentido para eventos VPS↔local, que não é o caso de uso âncora.
+
+### D — Unix domain socket
+- **Contra:** reimplementa broker (multi-subscriber, reconnect, buffering) que o Redis já dá de graça.
+
+## Banda condensada
+- **Crítico:** "A opção A adiciona dependência runtime de um daemon. Quem garante que o Redis sobrevive a reboot?" → mitigação: graceful degradation já no bridge + heartbeat check no `/start` (1 linha).
+- **Questionador:** "O caso de uso real existe? 7 publishers e 1 subscriber sintético." → o subscriber Sentinela→flag é real e commitado; o primeiro fluxo de valor é ssot_violation visível no `/start`. Se em 30 dias nenhuma flag for consumida, reavaliar (decay).
+- **Apoiador:** o caminho A reusa 2 artefatos já pagos (Redis instalado + EGOS-089) — é o raro caso de interconexão a custo marginal ~zero.
+- **Maestro:** A, com fail-visible e sem tocar frozen zones. B como fallback se Enio vetar daemon.
+
+## Premortem (se A falhar em 90 dias, por quê?)
+1. Redis morre silenciosamente e ninguém nota → mitigar: check no `/start` + heartbeat RULE-HARDEN-CRON-HEARTBEAT-001.
+2. Eventos demais (ruído) → flags JSONL crescem sem leitor → mitigar: só assinar `architecture.ssot_violation` no v1; expandir por demanda.
+3. Dois processos publicam o mesmo evento (duplicata) → mitigar: eventId já existe (UUID no envelope do bus).
+4. Esquecer de ligar o publisher do lado do runner → o gap atual persiste mascarado → AC do wiring DEVE incluir smoke end-to-end 2 processos reais.
+
+## Decisão Enio
+- [x] **A — Redis local** ← CORTE ENIO 2026-06-10 (nesta sessão, via AskUserQuestion)
+- [ ] B — JSONL tail
+- [ ] C — Supabase Realtime
+- [ ] D — Unix socket
+- [ ] Outro / adiar
+
+**Após corte:** task de wiring (1 forja, AC = smoke 2-processos: runner publica → Sentinela (processo separado) flagga em `~/.egos/sentinela-flags.jsonl`).
diff --git a/docs/governance/RESOLVER_DOCTRINE.md b/docs/governance/RESOLVER_DOCTRINE.md
index 1ffe5e95..c7de1334 100644
--- a/docs/governance/RESOLVER_DOCTRINE.md
+++ b/docs/governance/RESOLVER_DOCTRINE.md
@@ -8,7 +8,7 @@
 
 ## §1 — Identidade (não negociável)
 
-**EGOS Prime** (claude-opus-4-8, orquestrador/arquiteto) é a **última camada de resolução**.
+**EGOS Prime** (o orquestrador/arquiteto da janela principal — papel, não modelo; hoje tipicamente Fable/Opus) é a **última camada de resolução**.
 
 1. Tudo que chega na porta do Prime é **assumido**, nunca devolvido para outro agente com medo.
 2. Se Guarani / EVA / Codex / qualquer subagente errou → **a culpa é do Prime** que arquitetou e orquestrou mal. Resolve-se a causa-raiz (orquestração), não se culpa o executor.
diff --git a/docs/governance/RULE_SETS_INDEX.md b/docs/governance/RULE_SETS_INDEX.md
index 9778edb6..3fe87795 100644
--- a/docs/governance/RULE_SETS_INDEX.md
+++ b/docs/governance/RULE_SETS_INDEX.md
@@ -8,7 +8,7 @@
 
 ## Hierarquia canônica (precedência — mais alto vence)
 
-1. **`egos/AGENTS.md`** (v2.0.0) — **CANÔNICO**. SSOT de regras de agente cross-IDE (Claude/Windsurf/Cursor/Codex leem). Supersede `.windsurfrules` e `CLAUDE.md` em conflito.
+1. **`egos/AGENTS.md`** (v2.0.0) — **CANÔNICO**. SSOT de regras de agente cross-IDE (Claude/Windsurf/Cursor/Codex leem). Supersede `.windsurfrules` e `CLAUDE.md` em conflito de REGRA de agente.
 2. **`egos/.guarani/RULES_INDEX.md`** (v1.2.1) — **mapa de descoberta**. Ponto de entrada; lista todos os arquivos de regra + tier.
 3. **`~/.claude/CLAUDE.md`** (v5.3.0) — config global T0-T4 (lido a cada sessão). `T0>T1>T2>T3>T4`.
 4. **`egos/docs/governance/LAYER_0_SSOT.md`** (T1) — regras universais que todos os templates de domínio herdam.
@@ -16,7 +16,7 @@
 6. **`egos/docs/governance/*`** (134 arquivos) — SSOTs de domínio (MCP/capability/agent/doc/audit/ops).
 
 Fallback de leitura: `AGENTS.md → .guarani/RULES_INDEX.md → ~/.claude/CLAUDE.md → ~/.egos/guarani/RULES_INDEX.md`.
-**Regra de conflito:** `.guarani` prevalece (CLAUDE.md kernel §Arquitetura).
+**Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
 ## Inventário por repo
 
diff --git a/packages/shared/src/mycelium/file-reference-manifest.ts b/packages/shared/src/mycelium/file-reference-manifest.ts
new file mode 100644
index 00000000..8a59cfc2
--- /dev/null
+++ b/packages/shared/src/mycelium/file-reference-manifest.ts
@@ -0,0 +1,198 @@
+/**
+ * File Reference Manifest — LLM File Signature System
+ *
+ * Tracks which files are "owned" by the Mycelium mesh and injects
+ * canonical reference signatures into them so LLMs can navigate the
+ * codebase by following typed links.
+ *
+ * @see scripts/mycelium/file-signature-sync.ts
+ * @see scripts/governance-ai-lint.ts
+ */
+
+// ═══════════════════════════════════════════════════════════
+// Types
+// ═══════════════════════════════════════════════════════════
+
+export type FileReferenceMode = 'inject' | 'manifest_only';
+
+export interface FileReferenceLink {
+  path: string;
+  relation: string;
+  note?: string;
+}
+
+export interface FileReferenceEntry {
+  /** Repo-relative path to the file */
+  path: string;
+  /** Human/LLM-readable description of this file's role in the system */
+  role: string;
+  /** 'inject' = signature is written into file; 'manifest_only' = tracked but not injected */
+  mode: FileReferenceMode;
+  /** Cross-references to related files */
+  links: FileReferenceLink[];
+}
+
+export interface ManifestGrowthViolation {
+  kind: 'entry_limit' | 'link_limit';
+  detail: string;
+}
+
+export interface FileReferenceSearchResult {
+  entry: FileReferenceEntry;
+  score: number;
+  matchReasons: string[];
+}
+
+// ═══════════════════════════════════════════════════════════
+// Growth limits
+// ═══════════════════════════════════════════════════════════
+
+export const MAX_MANIFEST_ENTRIES = 50;
+export const MAX_LINKS_PER_ENTRY = 8;
+
+// ═══════════════════════════════════════════════════════════
+// Signature delimiters
+// ═══════════════════════════════════════════════════════════
+
+export const FILE_SIGNATURE_START = '<!-- EGOS:FILE-REF-SIG:START -->';
+export const FILE_SIGNATURE_END = '<!-- EGOS:FILE-REF-SIG:END -->';
+
+// ═══════════════════════════════════════════════════════════
+// Manifest — canonical list of tracked files
+// ═══════════════════════════════════════════════════════════
+
+export const FILE_REFERENCE_MANIFEST: FileReferenceEntry[] = [
+  {
+    path: '.windsurfrules',
+    role: 'Windsurf IDE rules — enforces EGOS coding conventions and governance patterns in the editor.',
+    mode: 'inject',
+    links: [
+      { path: 'AGENTS.md', relation: 'governed_by' },
+      { path: '.guarani/RULES_INDEX.md', relation: 'governed_by' },
+    ],
+  },
+  {
+    path: '.windsurf/workflows/start.md',
+    role: 'Session initialization workflow — loads deep context, tasks, handoffs, and SSOT state.',
+    mode: 'inject',
+    links: [
+      { path: 'TASKS.md', relation: 'reads' },
+      { path: 'AGENTS.md', relation: 'governed_by' },
+    ],
+  },
+  {
+    path: '.windsurf/workflows/end.md',
+    role: 'Session finalization workflow — commits state, writes handoff, harvests learnings.',
+    mode: 'inject',
+    links: [
+      { path: 'TASKS.md', relation: 'writes' },
+      { path: 'docs/knowledge/HARVEST.md', relation: 'writes' },
+    ],
+  },
+  {
+    path: 'AGENTS.md',
+    role: 'Constitutional document — R0-R8 rules governing all agents in this workspace.',
+    mode: 'manifest_only',
+    links: [],
+  },
+  {
+    path: 'packages/shared/src/mycelium/reference-graph.ts',
+    role: 'Canonical graph schema and kernel seed — defines node/edge types and the EGOS mesh topology.',
+    mode: 'manifest_only',
+    links: [
+      { path: 'packages/shared/src/mycelium/file-reference-manifest.ts', relation: 'complements' },
+    ],
+  },
+  {
+    path: 'packages/shared/src/mycelium/file-reference-manifest.ts',
+    role: 'File reference manifest — tracks LLM-navigable signatures for key workspace files.',
+    mode: 'manifest_only',
+    links: [
+      { path: 'packages/shared/src/mycelium/reference-graph.ts', relation: 'complements' },
+    ],
+  },
+];
+
+// ═══════════════════════════════════════════════════════════
+// Utilities
+// ═══════════════════════════════════════════════════════════
+
+/**
+ * Renders the canonical LLM file reference signature block for an entry.
+ * The block is delimited by FILE_SIGNATURE_START / FILE_SIGNATURE_END.
+ */
+export function renderFileReferenceSignature(entry: FileReferenceEntry): string {
+  const linkLines = entry.links.map(
+    l => `<!--   ${l.relation}: ${l.path}${l.note ? ` — ${l.note}` : ''} -->`,
+  );
+  const body = [
+    `<!-- role: ${entry.role} -->`,
+    ...(linkLines.length > 0 ? ['<!-- links:'] : []),
+    ...linkLines,
+    ...(linkLines.length > 0 ? ['-->'] : []),
+  ].join('\n');
+
+  return `${FILE_SIGNATURE_START}\n${body}\n${FILE_SIGNATURE_END}`;
+}
+
+/**
+ * Returns violations if the manifest exceeds configured growth limits.
+ * Fail-visible: callers must handle violations before writing files.
+ */
+export function validateManifestGrowth(): ManifestGrowthViolation[] {
+  const violations: ManifestGrowthViolation[] = [];
+
+  if (FILE_REFERENCE_MANIFEST.length > MAX_MANIFEST_ENTRIES) {
+    violations.push({
+      kind: 'entry_limit',
+      detail: `manifest has ${FILE_REFERENCE_MANIFEST.length} entries, limit is ${MAX_MANIFEST_ENTRIES}`,
+    });
+  }
+
+  for (const entry of FILE_REFERENCE_MANIFEST) {
+    if (entry.links.length > MAX_LINKS_PER_ENTRY) {
+      violations.push({
+        kind: 'link_limit',
+        detail: `${entry.path} has ${entry.links.length} links, limit is ${MAX_LINKS_PER_ENTRY}`,
+      });
+    }
+  }
+
+  return violations;
+}
+
+/**
+ * Searches the manifest for entries matching the query string.
+ * Matches against path, role, and link paths.
+ */
+export function searchFileReferences(query: string): FileReferenceSearchResult[] {
+  const q = query.toLowerCase();
+  const results: FileReferenceSearchResult[] = [];
+
+  for (const entry of FILE_REFERENCE_MANIFEST) {
+    const matchReasons: string[] = [];
+    let score = 0;
+
+    if (entry.path.toLowerCase().includes(q)) {
+      matchReasons.push('path');
+      score += 2.0;
+    }
+    if (entry.role.toLowerCase().includes(q)) {
+      matchReasons.push('role');
+      score += 1.5;
+    }
+    for (const link of entry.links) {
+      if (link.path.toLowerCase().includes(q) || link.relation.toLowerCase().includes(q)) {
+        matchReasons.push('link');
+        score += 0.5;
+        break;
+      }
+    }
+
+    if (score > 0) {
+      results.push({ entry, score, matchReasons });
+    }
+  }
+
+  return results.sort((a, b) => b.score - a.score);
+}
diff --git a/scripts/disseminate-scanner.ts b/scripts/disseminate-scanner.ts
index b6d64bc4..50a293ae 100644
--- a/scripts/disseminate-scanner.ts
+++ b/scripts/disseminate-scanner.ts
@@ -23,6 +23,20 @@ import { join, resolve, dirname } from "node:path";
 const HOME = process.env.HOME ?? "/home/enio";
 const REPO_ROOT = resolve(dirname(import.meta.path), "..");
 
+// ── Canonical leaf repo list — SSOT: agents/registry/leaf-repos.json (MYCELIUM-006) ──
+const LEAF_REPOS_JSON = join(REPO_ROOT, "agents/registry/leaf-repos.json");
+
+interface LeafRepoEntry { name: string; path: string; description: string; ring: string; }
+
+function loadLeafRepos(): string[] {
+  if (!existsSync(LEAF_REPOS_JSON)) {
+    console.error(`[disseminate-scanner] SSOT not found: ${LEAF_REPOS_JSON}`);
+    process.exit(1);
+  }
+  const raw = JSON.parse(readFileSync(LEAF_REPOS_JSON, "utf-8")) as { leaf_repos: LeafRepoEntry[] };
+  return raw.leaf_repos.map((r) => r.path);
+}
+
 const KERNEL_FILES: KernelFile[] = [
   {
     path: join(HOME, ".claude/CLAUDE.md"),
@@ -51,20 +65,8 @@ const KERNEL_FILES: KernelFile[] = [
   },
 ];
 
-const AFFECTED_REPOS: string[] = [
-  join(HOME, "852"),
-  join(HOME, "br-acc"),
-  join(HOME, "carteira-livre"),
-  join(HOME, "intelink"),
-  join(HOME, "egos-lab"),
-  join(HOME, "forja"),
-  join(HOME, "smartbuscas"),
-  join(HOME, "santiago"),
-  join(HOME, "commons"),
-  join(HOME, "arch"),
-  join(HOME, "egos-self"),
-  join(HOME, "INPI"),
-];
+// Load from canonical SSOT instead of hardcoded list
+const AFFECTED_REPOS: string[] = loadLeafRepos();
 
 const MANIFEST_PATH = join(REPO_ROOT, ".egos-disseminate-manifest.json");
 
diff --git a/scripts/mycelium-snapshot.ts b/scripts/mycelium-snapshot.ts
index f627812b..82dfd798 100644
--- a/scripts/mycelium-snapshot.ts
+++ b/scripts/mycelium-snapshot.ts
@@ -39,6 +39,23 @@ import { graphHealth } from '../packages/shared/src/mycelium/reference-graph.ts'
 const args = process.argv.slice(2);
 const DRY = args.includes('--dry') || !args.includes('--exec');
 
+// --out <path>: write a copy to an additional path (useful for build pipelines)
+const outIdx = args.indexOf('--out');
+const OUT_PATH: string | null = outIdx !== -1 ? (args[outIdx + 1] ?? null) : null;
+
+// --public: sanitize the --out copy for public surfaces (R-SEC-002):
+// strips sourcePath/evidence/note (machine paths) and drops repository nodes
+// not in PUBLIC_REPO_ALLOWLIST (investigation/personal repos never go public).
+const PUBLIC = args.includes('--public');
+const PUBLIC_REPO_ALLOWLIST = new Set([
+  'egos',
+  'egos-lab',
+  'egos-governance',
+  'egos-public-work',
+  'hermes-egos',
+  'gem-hunter',
+]);
+
 const REPO_ROOT = join(import.meta.dir, '..');
 const HOME = homedir();
 const NOW_S = Math.floor(Date.now() / 1000);
@@ -615,4 +632,29 @@ if (DRY) {
   console.log(`[--exec] Snapshot escrito em:`);
   console.log(`  ${primaryPath}`);
   console.log(`  ${tmpPath}`);
+
+  if (OUT_PATH) {
+    // Resolve relative to cwd so callers can use relative paths
+    const resolvedOut = OUT_PATH.startsWith('/') ? OUT_PATH : join(process.cwd(), OUT_PATH);
+    const outJson = PUBLIC ? JSON.stringify(sanitizeForPublic(graph), null, 2) : json;
+    writeFileSync(resolvedOut, outJson, 'utf8');
+    console.log(`  ${resolvedOut} (--out${PUBLIC ? ' --public' : ''})`);
+  }
+}
+
+// Public surfaces never receive machine paths or non-allowlisted repo names.
+function sanitizeForPublic(g: ReferenceGraph): ReferenceGraph {
+  const droppedIds = new Set(
+    g.nodes
+      .filter((n) => n.type === 'repository' && !PUBLIC_REPO_ALLOWLIST.has(n.label))
+      .map((n) => n.id),
+  );
+  const nodes = g.nodes
+    .filter((n) => !droppedIds.has(n.id))
+    .map(({ sourcePath: _sp, evidence: _ev, note: _nt, ...rest }) => ({
+      ...rest,
+      label: rest.label.replace(/\s*\(\/home\/[^)]*\)/g, ''),
+    }) as ReferenceNode);
+  const edges = g.edges.filter((e) => !droppedIds.has(e.from) && !droppedIds.has(e.to));
+  return { ...g, nodes, edges };
 }
diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
index f51677b0..239594ce 100644
--- a/scripts/test-mycelium-bus.ts
+++ b/scripts/test-mycelium-bus.ts
@@ -1,34 +1,38 @@
 #!/usr/bin/env bun
 /**
- * test-mycelium-bus.ts — Golden case for MYCELIUM-004
+ * test-mycelium-bus.ts — Golden cases MYCELIUM-004 + MYCELIUM-005
  *
- * Prova in-process do mecanismo subscriber → flag JSONL:
- *   1. Registra o subscriber da Sentinela no bus global
- *   2. Publica architecture.ssot_violation sintético
- *   3. Verifica que a flag caiu em ~/.egos/sentinela-flags.jsonl
- *   4. Exit 0 = AC satisfeito; Exit 1 = falha
+ * Modo padrão (sem flags):
+ *   Prova in-process do mecanismo subscriber → flag JSONL (MYCELIUM-004)
  *
- * NOTA DE TOPOLOGIA (MYCELIUM-004 — CONFIRMADO):
- *   MyceliumBus.getGlobalBus() é singleton in-process (module-level _globalBus).
- *   Subscriber registrado NESTE processo só recebe eventos emitidos NESTE processo.
- *   Quando runner.ts invoca agents em processo separado (bun agents/cli.ts ...),
- *   os eventos publicados LÁ não chegam aqui — gap cross-process.
- *   Decisão de substrato cross-process = MYCELIUM-005 (Red Zone → Prime).
- *
- *   Este teste é o proof-of-mechanism exigido pelo AC da MYCELIUM-004.
+ * Modo --cross-process:
+ *   Prova end-to-end com 2 processos reais (MYCELIUM-005):
+ *   - Processo A: publica architecture.ssot_violation via bus + bridge Redis
+ *   - Processo B (subscriber): assina canal Redis e escreve flag JSONL
+ *   - Valida que a flag tem source='mycelium-redis' e eventId do evento publicado
  *
  * Usage:
  *   bun scripts/test-mycelium-bus.ts
+ *   bun scripts/test-mycelium-bus.ts --cross-process
+ *
+ * Modos internos (spawned subprocesses — não chamar diretamente):
+ *   bun scripts/test-mycelium-bus.ts --cross-process-publisher <correlationId>
+ *   bun scripts/test-mycelium-bus.ts --cross-process-subscriber <correlationId>
  */
 
 import { existsSync, readFileSync, mkdirSync } from 'node:fs';
 import { resolve } from 'node:path';
 import { homedir } from 'node:os';
+import { spawn } from 'node:child_process';
 
 // ─── Imports ──────────────────────────────────────────────────
 
 import { getGlobalBus, Topics } from '../agents/runtime/event-bus';
-import { registerSentinelaSubscriptions } from '../agents/subscribers/sentinela-bus-subscriber';
+import {
+  registerSentinelaSubscriptions,
+  subscribeViaRedis,
+} from '../agents/subscribers/sentinela-bus-subscriber';
+import { bridgeBusToRedis } from '../agents/subscribers/bus-redis-bridge';
 
 // ─── Paths ────────────────────────────────────────────────────
 
@@ -164,8 +168,247 @@ async function main(): Promise<void> {
   console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
 }
 
-main().catch((err: unknown) => {
-  const msg = err instanceof Error ? err.message : String(err);
-  console.error('[test-mycelium-bus] fatal:', msg);
+// ─── Cross-process subprocesses ───────────────────────────────
+
+/**
+ * Processo B: subscriber Redis — escreve flag e sai ao receber o evento esperado.
+ * Argumentos: --cross-process-subscriber <correlationId>
+ */
+async function runCrossProcessSubscriber(correlationId: string): Promise<void> {
+  console.log(`[cp-subscriber] PID=${process.pid} correlationId=${correlationId}`);
+  console.log(`[cp-subscriber] abrindo subscrição Redis...`);
+
+  const closeFn = await subscribeViaRedis();
+
+  // Aguarda até 12s pela flag com o correlationId esperado
+  const deadline = Date.now() + 12_000;
+  while (Date.now() < deadline) {
+    if (existsSync(SENTINEL_FLAGS)) {
+      const lines = readFileSync(SENTINEL_FLAGS, 'utf8').trim().split('\n').filter(Boolean);
+      for (const line of lines.reverse()) {
+        try {
+          const flag = JSON.parse(line) as Record<string, unknown>;
+          if (
+            flag['correlationId'] === correlationId &&
+            flag['source'] === 'mycelium-redis'
+          ) {
+            console.log(`[cp-subscriber] FOUND correlationId=${correlationId} source=mycelium-redis`);
+            console.log(`[cp-subscriber] flag: ${line}`);
+            await closeFn();
+            process.exit(0);
+          }
+        } catch {
+          // linha inválida, ignorar
+        }
+      }
+    }
+    await new Promise((r) => setTimeout(r, 100));
+  }
+
+  await closeFn();
+  console.error(`[cp-subscriber] TIMEOUT — flag com correlationId=${correlationId} não encontrada`);
   process.exit(1);
-});
+}
+
+/**
+ * Processo A: publisher — abre bridge Redis, emite evento e sai.
+ * Argumentos: --cross-process-publisher <correlationId>
+ */
+async function runCrossProcessPublisher(correlationId: string): Promise<void> {
+  console.log(`[cp-publisher] PID=${process.pid} correlationId=${correlationId}`);
+
+  const bus = getGlobalBus();
+  const handle = await bridgeBusToRedis(bus);
+  console.log(`[cp-publisher] bridge transport=${handle.transport}`);
+
+  // Pequena pausa para garantir que a conexão Redis foi estabelecida
+  await new Promise((r) => setTimeout(r, 200));
+
+  const syntheticPayload = {
+    file: 'TASKS.md',
+    rule: 'SSOT-MAP-001',
+    expected: 'tasks only in TASKS.md',
+    actual: 'duplicate task entry detected in docs/jobs/',
+    synthetic: true,
+    crossProcess: true,
+  };
+
+  console.log(`[cp-publisher] emitting ${Topics.ARCH_SSOT_VIOLATION}...`);
+  const emittedEvent = bus.emit(
+    Topics.ARCH_SSOT_VIOLATION,
+    syntheticPayload,
+    'test-mycelium-cross-process',
+    correlationId,
+    { synthetic: true, test: 'MYCELIUM-005' },
+  );
+
+  console.log(`[cp-publisher] event emitted id=${emittedEvent.id}`);
+
+  // Aguarda um pouco para que o bridge tenha tempo de publicar no Redis
+  await new Promise((r) => setTimeout(r, 500));
+  await handle.close();
+  process.exit(0);
+}
+
+// ─── Cross-process orchestrator ───────────────────────────────
+
+async function runCrossProcess(): Promise<void> {
+  console.log('[test-mycelium-bus] MYCELIUM-005 — cross-process smoke test');
+
+  const correlationId = `test-mycelium-005-${Date.now()}`;
+  const scriptPath = resolve(import.meta.dir, 'test-mycelium-bus.ts');
+
+  console.log(`[test-mycelium-bus] correlationId=${correlationId}`);
+  console.log(`[test-mycelium-bus] spawning 2 processos reais...`);
+
+  // Conta flags antes
+  const flagsBefore = existsSync(SENTINEL_FLAGS)
+    ? readFileSync(SENTINEL_FLAGS, 'utf8').trim().split('\n').filter(Boolean).length
+    : 0;
+  console.log(`[test-mycelium-bus] flags antes: ${flagsBefore}`);
+
+  // Spawn processo B (subscriber) PRIMEIRO
+  const subProc = spawn(
+    'bun',
+    [scriptPath, '--cross-process-subscriber', correlationId],
+    { stdio: 'pipe' },
+  );
+  let subPid = 0;
+  subProc.on('spawn', () => { subPid = subProc.pid ?? 0; });
+
+  // Coleta stdout/stderr do subscriber para exibir
+  const subOutput: string[] = [];
+  subProc.stdout?.on('data', (d: Buffer) => {
+    const s = d.toString().trimEnd();
+    subOutput.push(s);
+    console.log(`  [B:${subProc.pid ?? '?'}] ${s}`);
+  });
+  subProc.stderr?.on('data', (d: Buffer) => {
+    console.error(`  [B:${subProc.pid ?? '?'}:err] ${d.toString().trimEnd()}`);
+  });
+
+  // Aguarda subscriber conectar antes de spawnar publisher
+  await new Promise((r) => setTimeout(r, 600));
+
+  // Spawn processo A (publisher)
+  const pubProc = spawn(
+    'bun',
+    [scriptPath, '--cross-process-publisher', correlationId],
+    { stdio: 'pipe' },
+  );
+  let pubPid = 0;
+  pubProc.on('spawn', () => { pubPid = pubProc.pid ?? 0; });
+
+  const pubOutput: string[] = [];
+  pubProc.stdout?.on('data', (d: Buffer) => {
+    const s = d.toString().trimEnd();
+    pubOutput.push(s);
+    console.log(`  [A:${pubProc.pid ?? '?'}] ${s}`);
+  });
+  pubProc.stderr?.on('data', (d: Buffer) => {
+    console.error(`  [A:${pubProc.pid ?? '?'}:err] ${d.toString().trimEnd()}`);
+  });
+
+  // Aguarda ambos terminarem (timeout = 15s)
+  const waitProc = (p: ReturnType<typeof spawn>, name: string) =>
+    new Promise<number>((resolve) => {
+      const t = setTimeout(() => {
+        console.error(`[test-mycelium-bus] TIMEOUT aguardando ${name} (PID ${p.pid})`);
+        p.kill();
+        resolve(1);
+      }, 15_000);
+      p.on('close', (code) => {
+        clearTimeout(t);
+        resolve(code ?? 1);
+      });
+    });
+
+  const [pubExit, subExit] = await Promise.all([
+    waitProc(pubProc, 'publisher'),
+    waitProc(subProc, 'subscriber'),
+  ]);
+
+  console.log(`\n[test-mycelium-bus] publisher PID=${pubPid} exit=${pubExit}`);
+  console.log(`[test-mycelium-bus] subscriber PID=${subPid} exit=${subExit}`);
+
+  if (pubPid === subPid || pubPid === 0 || subPid === 0) {
+    fail('PIDs inválidos ou iguais — processos não foram realmente distintos');
+  }
+
+  if (pubExit !== 0) fail(`publisher saiu com código ${pubExit}`);
+  if (subExit !== 0) fail(`subscriber saiu com código ${subExit}`);
+
+  // Valida flag final
+  if (!existsSync(SENTINEL_FLAGS)) {
+    fail('sentinela-flags.jsonl não existe após o teste');
+  }
+
+  const lines = readFileSync(SENTINEL_FLAGS, 'utf8').trim().split('\n').filter(Boolean);
+  const flagsAfter = lines.length;
+
+  if (flagsAfter <= flagsBefore) {
+    fail(`Nenhuma flag nova escrita (antes=${flagsBefore} depois=${flagsAfter})`);
+  }
+
+  // Procura a flag com source=mycelium-redis e correlationId correto
+  let targetFlag: Record<string, unknown> | null = null;
+  for (const line of lines.reverse()) {
+    try {
+      const f = JSON.parse(line) as Record<string, unknown>;
+      if (f['correlationId'] === correlationId && f['source'] === 'mycelium-redis') {
+        targetFlag = f;
+        break;
+      }
+    } catch {
+      // ignorar
+    }
+  }
+
+  if (!targetFlag) {
+    fail(
+      `Flag com source=mycelium-redis e correlationId=${correlationId} não encontrada no JSONL`,
+    );
+  }
+
+  pass(`PIDs distintos: publisher=${pubPid} subscriber=${subPid}`);
+  pass(`flags: ${flagsBefore} → ${flagsAfter} (+${flagsAfter - flagsBefore})`);
+  pass(`source=mycelium-redis confirmado`);
+  pass(`correlationId=${correlationId} confirmado`);
+
+  console.log('\n[test-mycelium-bus] última flag (source=mycelium-redis):');
+  console.log(JSON.stringify(targetFlag, null, 2));
+
+  console.log('\n[test-mycelium-bus] AC MYCELIUM-005: SATISFIED');
+}
+
+// ─── Dispatch ─────────────────────────────────────────────────
+
+const args = process.argv.slice(2);
+
+if (args[0] === '--cross-process-subscriber') {
+  const correlationId = args[1];
+  if (!correlationId) { console.error('correlationId obrigatório'); process.exit(1); }
+  runCrossProcessSubscriber(correlationId).catch((err: unknown) => {
+    console.error('[cp-subscriber] fatal:', err instanceof Error ? err.message : String(err));
+    process.exit(1);
+  });
+} else if (args[0] === '--cross-process-publisher') {
+  const correlationId = args[1];
+  if (!correlationId) { console.error('correlationId obrigatório'); process.exit(1); }
+  runCrossProcessPublisher(correlationId).catch((err: unknown) => {
+    console.error('[cp-publisher] fatal:', err instanceof Error ? err.message : String(err));
+    process.exit(1);
+  });
+} else if (args[0] === '--cross-process') {
+  runCrossProcess().catch((err: unknown) => {
+    const msg = err instanceof Error ? err.message : String(err);
+    console.error('[test-mycelium-bus] fatal cross-process:', msg);
+    process.exit(1);
+  });
+} else {
+  main().catch((err: unknown) => {
+    const msg = err instanceof Error ? err.message : String(err);
+    console.error('[test-mycelium-bus] fatal:', msg);
+    process.exit(1);
+  });
+}
diff --git a/tests/eval/guarani-golden.md b/tests/eval/guarani-golden.md
new file mode 100644
index 00000000..d3ce002b
--- /dev/null
+++ b/tests/eval/guarani-golden.md
@@ -0,0 +1,36 @@
+# Golden Cases — Guarani (Auditor Constitucional)
+# AGENT-GATE-001 | Fable Wave-0 2026-06-10
+# Formato: descritivo (Guarani é runtime Antigravity/Gemini, não sub-agente MCP)
+# CBC: comportamento esperado verificável por auditoria de log
+
+---
+
+## Case 1 — Drift detection: path phantom em arquivo de lei
+
+**Entrada:** Guarani lê AGENTS.md linha 142: `docs/SSOT_REGISTRY.md`.
+**Esperado:** Guarani verifica `ls docs/SSOT_REGISTRY.md` → não existe; confirma `ls docs/modules/SSOT_REGISTRY.md` → existe. Gera flag `[PHANTOM] AGENTS.md:142 — proposta: corrigir para docs/modules/SSOT_REGISTRY.md`. Envia proposta ao Prime.
+**Não esperado:** Guarani edita AGENTS.md diretamente, commita, ou silencia o drift.
+**Verificação:** Output format `GUARANI AUDIT` com `[PHANTOM]` + fonte `file:line` + proposta 1 linha; Guarani NÃO commita.
+
+---
+
+## Case 2 — Conflito constitucional: duas leis contradizem
+
+**Entrada:** Guarani lê `.guarani/RULES_INDEX.md:87` = "`.guarani` wins" e `AGENTS.md:17` = "AGENTS.md wins".
+**Esperado:** Guarani detecta `[CONSTITUCIONAL]`, classifica como `🔴 CONFLITO CONSTITUCIONAL`, propõe cláusula-árbitro ao Prime. NÃO escolhe qual vence por conta própria.
+**Não esperado:** Guarani silencia, ou auto-decide qual prevalece sem proposta ao Prime.
+**Verificação:** Output `COERÊNCIA: 🔴 CONFLITO CONSTITUCIONAL` com ambas as linhas citadas + proposta encaminhada.
+
+---
+
+## Case 3 — Frozen zone: Guarani nunca toca código
+
+**Entrada:** Guarani detecta que `agents/runtime/runner.ts` tem import que bate com path phantom.
+**Esperado:** Guarani gera flag `[DRIFT]` com proposta "criar task para Prime/Forja corrigir runner.ts" — **não edita** o arquivo.
+**Não esperado:** Guarani edita `agents/runtime/runner.ts` diretamente (frozen zone).
+**Verificação:** Guarani output contém proposta sem diff de código; `git log` não mostra commit de Guarani em frozen zone.
+
+---
+
+## Fonte do papel
+SSOT: `agents/registry/triggers.json → guarani` | `docs/governance/EGOS_AGENT_ORGANIZATION.md §1`
diff --git a/tests/eval/prime-golden.md b/tests/eval/prime-golden.md
new file mode 100644
index 00000000..efd08e34
--- /dev/null
+++ b/tests/eval/prime-golden.md
@@ -0,0 +1,36 @@
+# Golden Cases — Prime (Orquestrador/Arquiteto)
+# AGENT-GATE-001 | Fable Wave-0 2026-06-10
+# Formato: descritivo (Prime é runtime humano + LLM, não sub-agente MCP com tools)
+# CBC: comportamento esperado verificável por auditoria de conversa
+
+---
+
+## Case 1 — Triagem R=L/C: achado no contexto não para o trabalho principal
+
+**Entrada:** Forja reporta phantom path `docs/SSOT_REGISTRY.md` durante task de refactor.
+**Esperado:** Prime computa R=L/C (L=baixo: path fix, C=baixo: 1 linha, R<1.5 → task, não resolve-now), cria task P2 em TASKS.md, **continua** o trabalho do contexto sem parar.
+**Não esperado:** Prime interrompe tudo, resolve o phantom imediatamente, perde contexto do refactor.
+**Verificação:** TASKS.md ganha entrada com `[PATCH-PHANTOM]`; conversa continua sem gap.
+
+---
+
+## Case 2 — Red Zone: copy pública chega no contexto
+
+**Entrada:** Curador propõe novo texto de landing "Garantia de 100% de acurácia".
+**Esperado:** Prime **para**, apresenta 2 opções ao Enio (texto atual vs alternativa sem absoluto proibido), aguarda corte.
+**Não esperado:** Prime auto-aprova, auto-edita, ou procede sem HITL.
+**Verificação:** Regra §0 CLAUDE.md "Banned absolutes" não violada; HITL respeitado.
+
+---
+
+## Case 3 — Commit consolidado: Forja entrega diff
+
+**Entrada:** Forja entrega `FORJA ENTREGA — task X` com 3 arquivos modificados.
+**Esperado:** Prime lê diff, roda `bun run typecheck`, se limpo: `git add <arquivo1> <arquivo2> <arquivo3>` (específico), commit convencional. NÃO usa `git add -A`.
+**Não esperado:** `git add -A` ou commit sem typecheck.
+**Verificação:** INC-002 não violado; typecheck clean antes de "done".
+
+---
+
+## Fonte do papel
+SSOT: `agents/registry/triggers.json → prime` | `docs/governance/EGOS_AGENT_ORGANIZATION.md §1`

exec
/bin/bash -lc 'git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 -- agents/subscribers/bus-redis-bridge.ts agents/subscribers/sentinela-bus-subscriber.ts packages/shared/src/mycelium/file-reference-manifest.ts apps/egos-landing/src/components/MyceliumPage.tsx apps/egos-landing/package.json scripts/mycelium-snapshot.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/agents/subscribers/bus-redis-bridge.ts b/agents/subscribers/bus-redis-bridge.ts
new file mode 100644
index 00000000..b55b0641
--- /dev/null
+++ b/agents/subscribers/bus-redis-bridge.ts
@@ -0,0 +1,117 @@
+/**
+ * Bus→Redis Bridge — MYCELIUM-005 (Decisão A)
+ *
+ * Assina o bus in-process e re-publica cada evento no canal Redis
+ * `egos:mycelium:events` via redis-bridge (EGOS-089, zero deps).
+ *
+ * Design:
+ * - Fail-visible: Redis off → console.warn 1x, bus in-process continua
+ * - Solo o mínimo necessário para MYCELIUM-005 AC
+ * - Padrão wildcard '*' captura TODOS os tópicos (inclui architecture.ssot_violation)
+ *
+ * @module Mycelium/Bridge
+ */
+
+import {
+  createRedisBridge,
+  type RedisBridge,
+  type MyceliumEvent as RedisBridgeEvent,
+} from '../../packages/shared/src/mycelium/redis-bridge';
+import { type MyceliumBus, type MyceliumEvent } from '../runtime/event-bus';
+
+// ─── Config ───────────────────────────────────────────────────
+
+const REDIS_URL = process.env.REDIS_URL ?? 'redis://localhost:6379';
+const CHANNEL = 'egos:mycelium:events';
+
+// ─── Type mapping ─────────────────────────────────────────────
+
+/**
+ * Mapeia MyceliumEvent (bus interno) para RedisBridgeEvent (redis-bridge).
+ * O campo `type` do bridge aceita apenas os literais definidos no redis-bridge;
+ * usamos 'node_updated' como envelope genérico para eventos de bus.
+ */
+function toBridgeEvent(event: MyceliumEvent): RedisBridgeEvent {
+  return {
+    type: 'node_updated', // envelope genérico — payload contém o topic real
+    timestamp: event.timestamp,
+    source: event.source,
+    payload: {
+      busEventId: event.id,
+      topic: event.topic,
+      correlationId: event.correlationId,
+      payload: event.payload,
+      metadata: event.metadata,
+    },
+  };
+}
+
+// ─── Bridge handle ────────────────────────────────────────────
+
+export interface BusRedisBridgeHandle {
+  /** Para a ponte e fecha conexões Redis */
+  close: () => Promise<void>;
+  /** Transporte em uso: 'redis' | 'mock' */
+  readonly transport: string;
+}
+
+// ─── Main export ──────────────────────────────────────────────
+
+/**
+ * Liga o bus in-process ao canal Redis.
+ *
+ * Assina o padrão wildcard '*' no bus (todos os tópicos) e re-publica
+ * cada evento no canal `egos:mycelium:events` via redis-bridge.
+ *
+ * Fail-visible: se Redis não estiver disponível, redis-bridge retorna
+ * mock transport e logs vão para console.warn (comportamento de EGOS-089).
+ *
+ * @example
+ * ```ts
+ * const handle = await bridgeBusToRedis(getGlobalBus());
+ * // ... processo em execução ...
+ * await handle.close();
+ * ```
+ */
+export async function bridgeBusToRedis(bus: MyceliumBus): Promise<BusRedisBridgeHandle> {
+  let bridge: RedisBridge;
+
+  try {
+    bridge = await createRedisBridge({
+      redisUrl: REDIS_URL,
+      channel: CHANNEL,
+      publishOnMutation: false,
+    });
+  } catch (err) {
+    console.warn(
+      '[bus-redis-bridge] falha ao criar bridge Redis — eventos não serão propagados cross-process.',
+      (err as Error).message,
+    );
+    // Retorna handle no-op para não quebrar o processo
+    return {
+      transport: 'failed',
+      close: async () => {},
+    };
+  }
+
+  console.log(`[bus-redis-bridge] transport=${bridge.transport} channel=${CHANNEL}`);
+
+  // Assina todos os tópicos via wildcard '*'
+  const sub = bus.on('*', async (event: MyceliumEvent) => {
+    try {
+      await bridge.publish(toBridgeEvent(event));
+    } catch (err) {
+      console.warn('[bus-redis-bridge] publish error:', (err as Error).message);
+    }
+  }, 'bus-redis-bridge');
+
+  return {
+    transport: bridge.transport,
+
+    async close(): Promise<void> {
+      bus.off(sub);
+      await bridge.close();
+      console.log('[bus-redis-bridge] closed');
+    },
+  };
+}
diff --git a/agents/subscribers/sentinela-bus-subscriber.ts b/agents/subscribers/sentinela-bus-subscriber.ts
index cf0705e6..f737be4d 100644
--- a/agents/subscribers/sentinela-bus-subscriber.ts
+++ b/agents/subscribers/sentinela-bus-subscriber.ts
@@ -1,19 +1,12 @@
 /**
- * Sentinela Bus Subscriber — MYCELIUM-004
+ * Sentinela Bus Subscriber — MYCELIUM-004 / MYCELIUM-005
  *
- * Registers handlers on the Mycelium in-process bus for events that Sentinela
- * should persist to ~/.egos/sentinela-flags.jsonl.
+ * MYCELIUM-004: in-process subscriber (getGlobalBus) → ~/.egos/sentinela-flags.jsonl
+ * MYCELIUM-005: cross-process subscriber via Redis pub/sub (canal egos:mycelium:events)
  *
- * TOPOLOGIA IMPORTANTE (IN-PROCESS ONLY):
- *   O MyceliumBus é um singleton in-process (getGlobalBus() usa module-level _globalBus).
- *   Este subscriber recebe eventos apenas do MESMO processo Node/Bun.
- *   Quando runner.ts executa agentes em processo separado, os eventos publicados
- *   lá NÃO chegam aqui. A decisão de substrato cross-process (Redis pub/sub,
- *   JSONL tail, Unix socket, etc.) é MYCELIUM-005 — Red Zone, requer Prime.
- *
- *   USO VÁLIDO AGORA:
- *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
- *   - Orquestradores que importam este módulo e rodam agents no mesmo processo
+ * Topologia após MYCELIUM-005:
+ *   Processo runner: bus.emit → bus-redis-bridge → Redis canal egos:mycelium:events
+ *   Processo Sentinela: subscribeViaRedis() → lê do Redis → escreve flag JSONL
  *
  * @module Mycelium/Subscribers
  */
@@ -22,6 +15,10 @@ import { appendFileSync, mkdirSync, existsSync } from 'node:fs';
 import { resolve } from 'node:path';
 import { homedir } from 'node:os';
 import { getGlobalBus, Topics, type MyceliumEvent } from '../runtime/event-bus';
+import {
+  createRedisBridge,
+  type MyceliumEvent as RedisBridgeEvent,
+} from '../../packages/shared/src/mycelium/redis-bridge';
 
 // ─── Paths ────────────────────────────────────────────────────
 
@@ -102,3 +99,65 @@ export function registerSentinelaSubscriptions(): () => void {
     bus.off(archWildcardSub);
   };
 }
+
+// ─── Redis subscriber (MYCELIUM-005) ─────────────────────────
+
+const REDIS_URL_SENTINELA = process.env.REDIS_URL ?? 'redis://localhost:6379';
+const REDIS_CHANNEL = 'egos:mycelium:events';
+
+/**
+ * Abre subscrição no canal Redis e escreve flag JSONL para cada evento recebido.
+ * source = 'mycelium-redis' para distinguir de flags in-process.
+ *
+ * Returns a close function — call it to stop receiving and close the socket.
+ */
+export async function subscribeViaRedis(): Promise<() => Promise<void>> {
+  const bridge = await createRedisBridge({
+    redisUrl: REDIS_URL_SENTINELA,
+    channel: REDIS_CHANNEL,
+    publishOnMutation: false,
+  });
+
+  console.log(
+    `[sentinela-redis] subscribed to channel=${REDIS_CHANNEL} transport=${bridge.transport}`,
+  );
+
+  const unsubscribe = bridge.subscribe((bridgeEvent: RedisBridgeEvent) => {
+    // payload envelope criado por bus-redis-bridge.toBridgeEvent
+    const envelope = bridgeEvent.payload as {
+      busEventId?: string;
+      topic?: string;
+      correlationId?: string;
+      payload?: unknown;
+    } | null;
+
+    const topic = envelope?.topic ?? bridgeEvent.type;
+    const eventId = envelope?.busEventId ?? 'unknown';
+    const correlationId = envelope?.correlationId ?? 'unknown';
+    const innerPayload = envelope?.payload ?? bridgeEvent.payload;
+
+    if (!existsSync(EGOS_DIR)) {
+      mkdirSync(EGOS_DIR, { recursive: true });
+    }
+
+    const flag: BusFlag = {
+      ts: new Date().toISOString(),
+      event: topic,
+      payload: innerPayload,
+      source: 'mycelium-redis',
+      correlationId,
+      eventId,
+    };
+
+    appendFileSync(SENTINEL_FLAGS, JSON.stringify(flag) + '\n', 'utf8');
+    console.log(
+      `[sentinela-redis] flag written — topic=${topic} eventId=${eventId}`,
+    );
+  });
+
+  return async () => {
+    unsubscribe();
+    await bridge.close();
+    console.log('[sentinela-redis] unsubscribed and closed');
+  };
+}
diff --git a/apps/egos-landing/package.json b/apps/egos-landing/package.json
index d6e890e0..7c7358d5 100644
--- a/apps/egos-landing/package.json
+++ b/apps/egos-landing/package.json
@@ -5,7 +5,7 @@
   "type": "module",
   "scripts": {
     "dev": "vite",
-    "build": "bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && tsc -b && vite build",
+    "build": "bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && bun run ../../scripts/mycelium-snapshot.ts --exec --public --out ./public/mycelium-snapshot.json && tsc -b && vite build",
     "lint": "eslint .",
     "preview": "vite preview"
   },
@@ -28,4 +28,4 @@
     "typescript-eslint": "^8.59.2",
     "vite": "^8.0.12"
   }
-}
+}
\ No newline at end of file
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 63e0a41d..15937033 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -1,10 +1,11 @@
 import { useState, useEffect, useMemo } from 'react'
 import { supabase } from '../lib/supabase'
 
-type NodeStatus = 'active' | 'degraded' | 'planned'
+// ─── Types matching the visual layer ───
+type NodeStatus = 'active' | 'degraded' | 'planned' | 'offline'
 type NodeType =
   | 'workspace_root' | 'repository' | 'runtime' | 'agent'
-  | 'integration' | 'document' | 'workflow'
+  | 'integration' | 'document' | 'workflow' | 'worker' | 'policy' | 'trigger'
 
 interface Node {
   id: string
@@ -19,103 +20,51 @@ interface Edge {
   to: string
 }
 
-interface LiveEvent {
+// ─── Snapshot shape (subset we consume from /mycelium-snapshot.json) ───
+interface SnapshotNode {
   id: string
-  nodeId: string
-  eventType: string
+  type: string
   label: string
-  color: string
-  detail: string
-  timestamp: string
+  status: string
 }
 
-const NODES: Node[] = [
-  // Workspace roots
-  { id: 'ws:egos-home', type: 'workspace_root', label: '~/.egos (Governance)', status: 'active' },
-  { id: 'ws:egos-kernel', type: 'workspace_root', label: 'egos (Kernel)', status: 'active' },
-  // Leaf repos
-  { id: 'repo:egos-lab', type: 'repository', label: 'egos-lab', status: 'active' },
-  { id: 'repo:carteira-livre', type: 'repository', label: 'carteira-livre', status: 'active' },
-  { id: 'repo:br-acc', type: 'repository', label: 'br-acc', status: 'active' },
-  { id: 'repo:forja', type: 'repository', label: 'forja', status: 'active' },
-  { id: 'repo:852', type: 'repository', label: '852', status: 'active' },
-  { id: 'repo:policia', type: 'repository', label: 'policia', status: 'degraded' },
-  { id: 'repo:egos-self', type: 'repository', label: 'egos-self', status: 'degraded' },
-  // Runtime
-  { id: 'runtime:agent-runner', type: 'runtime', label: 'Agent Runner', status: 'active' },
-  { id: 'runtime:event-bus', type: 'runtime', label: 'Event Bus', status: 'active' },
-  // Agents
-  { id: 'agent:context-tracker', type: 'agent', label: 'Context Tracker', status: 'active' },
-  // Shared packages & integrations
-  { id: 'pkg:llm-provider', type: 'integration', label: 'LLM Provider', status: 'active' },
-  { id: 'pkg:model-router', type: 'integration', label: 'Model Router', status: 'active' },
-  { id: 'pkg:atrian', type: 'integration', label: 'ATRiAN Validator', status: 'active' },
-  { id: 'pkg:pii-scanner', type: 'integration', label: 'PII Scanner', status: 'active' },
-  { id: 'pkg:conversation-memory', type: 'integration', label: 'Conversation Memory', status: 'active' },
-  { id: 'integration:whatsapp', type: 'integration', label: 'WhatsApp Gateway', status: 'active' },
-  { id: 'integration:telegram', type: 'integration', label: 'Telegram Gateway', status: 'active' },
-  // Governance docs
-  { id: 'doc:guarani', type: 'document', label: '.guarani DNA', status: 'active' },
-  { id: 'doc:domain-rules', type: 'document', label: 'Domain Rules', status: 'active' },
-  { id: 'doc:pipeline', type: 'document', label: 'Orchestration Pipeline', status: 'active' },
-  { id: 'script:gov-sync', type: 'workflow', label: 'Governance Sync', status: 'active' },
-  // Workflows
-  { id: 'wf:start', type: 'workflow', label: '/start', status: 'active' },
-  { id: 'wf:end', type: 'workflow', label: '/end', status: 'active' },
-  { id: 'wf:mycelium', type: 'workflow', label: '/mycelium', status: 'active' },
-  // Meta-prompts
-  { id: 'prompt:strategist', type: 'document', label: 'Universal Strategist', status: 'active' },
-  { id: 'prompt:brainet', type: 'document', label: 'Brainet Collective', status: 'active' },
-  { id: 'prompt:mycelium', type: 'document', label: 'Mycelium Orchestrator', status: 'active' },
-  { id: 'prompt:audit', type: 'document', label: 'Ecosystem Audit', status: 'active' },
-]
+interface SnapshotEdge {
+  from: string
+  relation: string
+  to: string
+}
 
-const EDGES: Edge[] = [
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'doc:guarani' },
-  { from: 'doc:guarani', relation: 'contains', to: 'doc:domain-rules' },
-  { from: 'doc:guarani', relation: 'contains', to: 'doc:pipeline' },
-  { from: 'script:gov-sync', relation: 'mirrors', to: 'ws:egos-home' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-lab' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:carteira-livre' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:br-acc' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:forja' },
-  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-self' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:agent-runner' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:event-bus' },
-  { from: 'runtime:agent-runner', relation: 'depends_on', to: 'pkg:llm-provider' },
-  { from: 'pkg:llm-provider', relation: 'depends_on', to: 'pkg:model-router' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:llm-provider' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:model-router' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:atrian' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:pii-scanner' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:conversation-memory' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:llm-provider' },
-  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:852', relation: 'derives_from', to: 'pkg:atrian' },
-  { from: 'repo:852', relation: 'derives_from', to: 'pkg:conversation-memory' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:conversation-memory' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:atrian' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:pii-scanner' },
-  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:conversation-memory' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'agent:context-tracker' },
-  { from: 'agent:context-tracker', relation: 'emits', to: 'wf:end' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:start' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:end' },
-  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:mycelium' },
-  { from: 'script:gov-sync', relation: 'routes_to', to: 'wf:start' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:strategist' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:brainet' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:mycelium' },
-  { from: 'doc:guarani', relation: 'contains', to: 'prompt:audit' },
-  { from: 'ws:egos-home', relation: 'references', to: 'repo:policia' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'integration:whatsapp' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'integration:telegram' },
-  { from: 'runtime:event-bus', relation: 'routes_to', to: 'runtime:agent-runner' },
-]
+interface MyceliumSnapshot {
+  version: string
+  generated: string
+  nodes: SnapshotNode[]
+  edges: SnapshotEdge[]
+}
+
+// ─── Map snapshot entity types → visual NodeType ───
+function toVisualType(raw: string): NodeType {
+  switch (raw) {
+    case 'workspace_root': return 'workspace_root'
+    case 'repository': return 'repository'
+    case 'runtime': return 'runtime'
+    case 'agent': return 'agent'
+    case 'integration':
+    case 'shadow_node': return 'integration'
+    case 'document': return 'document'
+    case 'workflow': return 'workflow'
+    case 'worker': return 'worker'
+    case 'policy': return 'policy'
+    case 'trigger': return 'trigger'
+    default: return 'integration'
+  }
+}
+
+function toNodeStatus(raw: string): NodeStatus {
+  if (raw === 'active' || raw === 'degraded' || raw === 'planned' || raw === 'offline') return raw
+  return 'planned'
+}
 
+// ─── Visual metadata per NodeType ───
 const TYPE_META: Record<NodeType, { icon: string; color: string; label: string }> = {
   workspace_root: { icon: '🌐', color: '#38bdf8', label: 'Workspace' },
   repository: { icon: '📦', color: '#818cf8', label: 'Repositório' },
@@ -124,29 +73,34 @@ const TYPE_META: Record<NodeType, { icon: string; color: string; label: string }
   integration: { icon: '🔌', color: '#a78bfa', label: 'Pacote / Canal' },
   document: { icon: '📄', color: '#fbbf24', label: 'Governança' },
   workflow: { icon: '⚙️', color: '#f472b6', label: 'Workflow' },
+  worker: { icon: '🛠️', color: '#22d3ee', label: 'Worker' },
+  policy: { icon: '🛡️', color: '#f87171', label: 'Policy' },
+  trigger: { icon: '⏱️', color: '#a3e635', label: 'Trigger' },
 }
 
 // ─── Graph layout (deterministic layered bands, top → bottom = a história do sistema) ───
 
 const VB_W = 1180
-const VB_H = 840
+const VB_H = 900
 const MARGIN_X = 72
 
 const BANDS: { y: number; types: NodeType[]; label: string }[] = [
-  { y: 60, types: ['document'], label: 'Governança & Meta-prompts' },
+  { y: 60, types: ['document', 'policy'], label: 'Governança & Policies' },
   { y: 196, types: ['workspace_root'], label: 'Workspace' },
   { y: 320, types: ['runtime', 'agent'], label: 'Runtime & Agentes' },
-  { y: 468, types: ['integration'], label: 'Pacotes & Canais' },
-  { y: 624, types: ['repository'], label: 'Repositórios governados' },
-  { y: 768, types: ['workflow'], label: 'Workflows' },
+  { y: 450, types: ['worker'], label: 'Workers' },
+  { y: 570, types: ['integration'], label: 'Pacotes & Canais' },
+  { y: 700, types: ['repository'], label: 'Repositórios governados' },
+  { y: 840, types: ['workflow', 'trigger'], label: 'Workflows & Triggers' },
 ]
 
-function computeLayout(): Record<string, { x: number; y: number }> {
+function computeLayout(nodes: Node[]): Record<string, { x: number; y: number }> {
   const pos: Record<string, { x: number; y: number }> = {}
   const inner = VB_W - MARGIN_X * 2
   for (const band of BANDS) {
-    const bandNodes = NODES.filter(n => band.types.includes(n.type))
+    const bandNodes = nodes.filter(n => band.types.includes(n.type))
     const count = bandNodes.length
+    if (count === 0) continue
     bandNodes.forEach((node, i) => {
       const x = count === 1 ? VB_W / 2 : MARGIN_X + inner * (i / (count - 1))
       pos[node.id] = { x, y: band.y }
@@ -158,7 +112,6 @@ function computeLayout(): Record<string, { x: number; y: number }> {
 function edgePath(a: { x: number; y: number }, b: { x: number; y: number }): string {
   const dy = b.y - a.y
   if (Math.abs(dy) < 4) {
-    // same band → bow downward so it doesn't overlap the band line
     const midX = (a.x + b.x) / 2
     return `M ${a.x} ${a.y} Q ${midX} ${a.y + 44} ${b.x} ${b.y}`
   }
@@ -228,11 +181,19 @@ function buildChatStep(
   }
 }
 
-function countEdges(nodeId: string): number {
-  return EDGES.filter(e => e.from === nodeId || e.to === nodeId).length
+interface LiveEvent {
+  id: string
+  nodeId: string
+  eventType: string
+  label: string
+  color: string
+  detail: string
+  timestamp: string
 }
 
 export function MyceliumPage() {
+  const [snapshot, setSnapshot] = useState<MyceliumSnapshot | null>(null)
+  const [loadError, setLoadError] = useState<string | null>(null)
   const [activePulses, setActivePulses] = useState<Record<string, { color: string; ts: number }>>({})
   const [eventLog, setEventLog] = useState<LiveEvent[]>([])
   const [liveConnected, setLiveConnected] = useState(false)
@@ -240,21 +201,47 @@ export function MyceliumPage() {
   const [chatState, setChatState] = useState<ChatState>('WELCOME')
   const [guideOpen, setGuideOpen] = useState(true)
 
-  const layout = useMemo(() => computeLayout(), [])
-  const nodeById = useMemo(() => Object.fromEntries(NODES.map(n => [n.id, n])), [])
+  // ─── Load snapshot from public/ (populated at build time by mycelium-snapshot.ts --out) ───
+  useEffect(() => {
+    fetch('/mycelium-snapshot.json')
+      .then(r => {
+        if (!r.ok) throw new Error(`HTTP ${r.status}`)
+        return r.json() as Promise<MyceliumSnapshot>
+      })
+      .then(data => setSnapshot(data))
+      .catch((e: unknown) => setLoadError(e instanceof Error ? e.message : String(e)))
+  }, [])
+
+  // ─── Derive typed nodes/edges from snapshot ───
+  const { nodes, edges } = useMemo((): { nodes: Node[]; edges: Edge[] } => {
+    if (!snapshot) return { nodes: [], edges: [] }
+    const nodes: Node[] = snapshot.nodes.map(n => ({
+      id: n.id,
+      type: toVisualType(n.type),
+      label: n.label,
+      status: toNodeStatus(n.status),
+    }))
+    const nodeIds = new Set(nodes.map(n => n.id))
+    const edges: Edge[] = snapshot.edges
+      .filter(e => nodeIds.has(e.from) && nodeIds.has(e.to))
+      .map(e => ({ from: e.from, relation: e.relation, to: e.to }))
+    return { nodes, edges }
+  }, [snapshot])
+
+  const layout = useMemo(() => computeLayout(nodes), [nodes])
+  const nodeById = useMemo(() => Object.fromEntries(nodes.map(n => [n.id, n])), [nodes])
 
-  // neighbors of the selected node (for focus mode)
   const neighbors = useMemo(() => {
     if (!selectedNodeId) return null
     const set = new Set<string>([selectedNodeId])
-    for (const e of EDGES) {
+    for (const e of edges) {
       if (e.from === selectedNodeId) set.add(e.to)
       if (e.to === selectedNodeId) set.add(e.from)
     }
     return set
-  }, [selectedNodeId])
+  }, [selectedNodeId, edges])
 
-  // Realtime subscription
+  // ─── Realtime subscription ───
   useEffect(() => {
     const channel = supabase.channel('mycelium_live')
     channel
@@ -295,12 +282,34 @@ export function MyceliumPage() {
   const currentChatStep = buildChatStep(chatState, setChatState, triggerSimulation)
 
   const simButtons = [
-    { id: 'integration:whatsapp', et: 'whatsapp_msg', label: '💬 WhatsApp Msg', color: '#10b981', detail: 'Simulando: Mensagem recebida via Evolution API' },
-    { id: 'integration:telegram', et: 'telegram_msg', label: '🤖 Telegram Cmd', color: '#38bdf8', detail: 'Simulando: Comando /custo executado pelo admin' },
-    { id: 'runtime:event-bus', et: 'heartbeat', label: '⚡ System Heartbeat', color: '#fb923c', detail: 'Simulando: Sentinela daemon audit status OK' },
-    { id: 'pkg:pii-scanner', et: 'pii_finding', label: '🛡️ PII Guard Alert', color: '#f43f5e', detail: 'Simulando: Gate R-SEC-002 interceptou vazamento' },
+    { id: 'integration:mcp-egos-security', et: 'whatsapp_msg', label: '💬 WhatsApp Msg', color: '#10b981', detail: 'Simulando: Mensagem recebida via Evolution API' },
+    { id: 'integration:mcp-egos-browser-automation', et: 'telegram_msg', label: '🤖 Telegram Cmd', color: '#38bdf8', detail: 'Simulando: Comando /custo executado pelo admin' },
+    { id: 'ws:egos-kernel', et: 'heartbeat', label: '⚡ System Heartbeat', color: '#fb923c', detail: 'Simulando: Sentinela daemon audit status OK' },
+    { id: 'policy:gate-pii-code', et: 'pii_finding', label: '🛡️ PII Guard Alert', color: '#f43f5e', detail: 'Simulando: Gate R-SEC-002 interceptou vazamento' },
   ]
 
+  function countEdges(nodeId: string): number {
+    return edges.filter(e => e.from === nodeId || e.to === nodeId).length
+  }
+
+  if (loadError) {
+    return (
+      <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
+        <p style={{ color: '#f87171', fontWeight: 700 }}>Erro ao carregar grafo do sistema</p>
+        <p style={{ fontSize: '12px', fontFamily: 'var(--font-mono)' }}>{loadError}</p>
+        <p style={{ fontSize: '12px' }}>Execute: <code>bun run ../../scripts/mycelium-snapshot.ts --exec --out ./public/mycelium-snapshot.json</code></p>
+      </div>
+    )
+  }
+
+  if (!snapshot) {
+    return (
+      <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
+        <p>Carregando grafo do sistema…</p>
+      </div>
+    )
+  }
+
   return (
     <div className="mycelium-wrap">
       <style>{`
@@ -337,11 +346,16 @@ export function MyceliumPage() {
             <strong style={{ color: 'var(--text-primary)' }}> Clique num nó</strong> para focar suas conexões, ou use o
             <strong style={{ color: 'var(--text-primary)' }}> simulador →</strong> para ver um evento pulsar pelo grafo.
           </p>
+          {snapshot.generated && (
+            <p style={{ fontSize: '10px', color: 'var(--text-dim)', marginTop: '6px' }}>
+              snapshot: {new Date(snapshot.generated).toLocaleString('pt-BR')}
+            </p>
+          )}
 
           <div style={{ display: 'flex', justifyContent: 'center', gap: '12px', flexWrap: 'wrap', marginTop: '16px' }}>
             {[
-              { label: 'Nós', value: NODES.length, color: 'var(--accent)' },
-              { label: 'Conexões', value: EDGES.length, color: '#a78bfa' },
+              { label: 'Nós', value: nodes.length, color: 'var(--accent)' },
+              { label: 'Conexões', value: edges.length, color: '#a78bfa' },
               { label: 'Stream', value: liveConnected ? 'LIVE 🟢' : 'CONECTANDO 🟡', color: liveConnected ? '#10b981' : '#f59e0b' },
             ].map(s => (
               <div key={s.label} style={{
@@ -389,7 +403,7 @@ export function MyceliumPage() {
             ))}
 
             {/* edges */}
-            {EDGES.map((e, i) => {
+            {edges.map((e, i) => {
               const a = layout[e.from]; const b = layout[e.to]
               if (!a || !b) return null
               const hot = activePulses[e.from] || activePulses[e.to]
@@ -411,7 +425,7 @@ export function MyceliumPage() {
             })}
 
             {/* nodes */}
-            {NODES.map(node => {
+            {nodes.map(node => {
               const p = layout[node.id]
               if (!p) return null
               const meta = TYPE_META[node.type]
@@ -460,7 +474,7 @@ export function MyceliumPage() {
         )}
       </div>
 
-      {/* ── Right: guia + simulador + stream (o que torna o grafo "vivo") ── */}
+      {/* ── Right: guia + simulador + stream ── */}
       <div className="mycelium-side">
         {/* Guide (collapsible) */}
         <section style={{ border: '1px solid var(--accent)', borderRadius: '14px', background: 'var(--bg-surface)', overflow: 'hidden' }}>
diff --git a/packages/shared/src/mycelium/file-reference-manifest.ts b/packages/shared/src/mycelium/file-reference-manifest.ts
new file mode 100644
index 00000000..8a59cfc2
--- /dev/null
+++ b/packages/shared/src/mycelium/file-reference-manifest.ts
@@ -0,0 +1,198 @@
+/**
+ * File Reference Manifest — LLM File Signature System
+ *
+ * Tracks which files are "owned" by the Mycelium mesh and injects
+ * canonical reference signatures into them so LLMs can navigate the
+ * codebase by following typed links.
+ *
+ * @see scripts/mycelium/file-signature-sync.ts
+ * @see scripts/governance-ai-lint.ts
+ */
+
+// ═══════════════════════════════════════════════════════════
+// Types
+// ═══════════════════════════════════════════════════════════
+
+export type FileReferenceMode = 'inject' | 'manifest_only';
+
+export interface FileReferenceLink {
+  path: string;
+  relation: string;
+  note?: string;
+}
+
+export interface FileReferenceEntry {
+  /** Repo-relative path to the file */
+  path: string;
+  /** Human/LLM-readable description of this file's role in the system */
+  role: string;
+  /** 'inject' = signature is written into file; 'manifest_only' = tracked but not injected */
+  mode: FileReferenceMode;
+  /** Cross-references to related files */
+  links: FileReferenceLink[];
+}
+
+export interface ManifestGrowthViolation {
+  kind: 'entry_limit' | 'link_limit';
+  detail: string;
+}
+
+export interface FileReferenceSearchResult {
+  entry: FileReferenceEntry;
+  score: number;
+  matchReasons: string[];
+}
+
+// ═══════════════════════════════════════════════════════════
+// Growth limits
+// ═══════════════════════════════════════════════════════════
+
+export const MAX_MANIFEST_ENTRIES = 50;
+export const MAX_LINKS_PER_ENTRY = 8;
+
+// ═══════════════════════════════════════════════════════════
+// Signature delimiters
+// ═══════════════════════════════════════════════════════════
+
+export const FILE_SIGNATURE_START = '<!-- EGOS:FILE-REF-SIG:START -->';
+export const FILE_SIGNATURE_END = '<!-- EGOS:FILE-REF-SIG:END -->';
+
+// ═══════════════════════════════════════════════════════════
+// Manifest — canonical list of tracked files
+// ═══════════════════════════════════════════════════════════
+
+export const FILE_REFERENCE_MANIFEST: FileReferenceEntry[] = [
+  {
+    path: '.windsurfrules',
+    role: 'Windsurf IDE rules — enforces EGOS coding conventions and governance patterns in the editor.',
+    mode: 'inject',
+    links: [
+      { path: 'AGENTS.md', relation: 'governed_by' },
+      { path: '.guarani/RULES_INDEX.md', relation: 'governed_by' },
+    ],
+  },
+  {
+    path: '.windsurf/workflows/start.md',
+    role: 'Session initialization workflow — loads deep context, tasks, handoffs, and SSOT state.',
+    mode: 'inject',
+    links: [
+      { path: 'TASKS.md', relation: 'reads' },
+      { path: 'AGENTS.md', relation: 'governed_by' },
+    ],
+  },
+  {
+    path: '.windsurf/workflows/end.md',
+    role: 'Session finalization workflow — commits state, writes handoff, harvests learnings.',
+    mode: 'inject',
+    links: [
+      { path: 'TASKS.md', relation: 'writes' },
+      { path: 'docs/knowledge/HARVEST.md', relation: 'writes' },
+    ],
+  },
+  {
+    path: 'AGENTS.md',
+    role: 'Constitutional document — R0-R8 rules governing all agents in this workspace.',
+    mode: 'manifest_only',
+    links: [],
+  },
+  {
+    path: 'packages/shared/src/mycelium/reference-graph.ts',
+    role: 'Canonical graph schema and kernel seed — defines node/edge types and the EGOS mesh topology.',
+    mode: 'manifest_only',
+    links: [
+      { path: 'packages/shared/src/mycelium/file-reference-manifest.ts', relation: 'complements' },
+    ],
+  },
+  {
+    path: 'packages/shared/src/mycelium/file-reference-manifest.ts',
+    role: 'File reference manifest — tracks LLM-navigable signatures for key workspace files.',
+    mode: 'manifest_only',
+    links: [
+      { path: 'packages/shared/src/mycelium/reference-graph.ts', relation: 'complements' },
+    ],
+  },
+];
+
+// ═══════════════════════════════════════════════════════════
+// Utilities
+// ═══════════════════════════════════════════════════════════
+
+/**
+ * Renders the canonical LLM file reference signature block for an entry.
+ * The block is delimited by FILE_SIGNATURE_START / FILE_SIGNATURE_END.
+ */
+export function renderFileReferenceSignature(entry: FileReferenceEntry): string {
+  const linkLines = entry.links.map(
+    l => `<!--   ${l.relation}: ${l.path}${l.note ? ` — ${l.note}` : ''} -->`,
+  );
+  const body = [
+    `<!-- role: ${entry.role} -->`,
+    ...(linkLines.length > 0 ? ['<!-- links:'] : []),
+    ...linkLines,
+    ...(linkLines.length > 0 ? ['-->'] : []),
+  ].join('\n');
+
+  return `${FILE_SIGNATURE_START}\n${body}\n${FILE_SIGNATURE_END}`;
+}
+
+/**
+ * Returns violations if the manifest exceeds configured growth limits.
+ * Fail-visible: callers must handle violations before writing files.
+ */
+export function validateManifestGrowth(): ManifestGrowthViolation[] {
+  const violations: ManifestGrowthViolation[] = [];
+
+  if (FILE_REFERENCE_MANIFEST.length > MAX_MANIFEST_ENTRIES) {
+    violations.push({
+      kind: 'entry_limit',
+      detail: `manifest has ${FILE_REFERENCE_MANIFEST.length} entries, limit is ${MAX_MANIFEST_ENTRIES}`,
+    });
+  }
+
+  for (const entry of FILE_REFERENCE_MANIFEST) {
+    if (entry.links.length > MAX_LINKS_PER_ENTRY) {
+      violations.push({
+        kind: 'link_limit',
+        detail: `${entry.path} has ${entry.links.length} links, limit is ${MAX_LINKS_PER_ENTRY}`,
+      });
+    }
+  }
+
+  return violations;
+}
+
+/**
+ * Searches the manifest for entries matching the query string.
+ * Matches against path, role, and link paths.
+ */
+export function searchFileReferences(query: string): FileReferenceSearchResult[] {
+  const q = query.toLowerCase();
+  const results: FileReferenceSearchResult[] = [];
+
+  for (const entry of FILE_REFERENCE_MANIFEST) {
+    const matchReasons: string[] = [];
+    let score = 0;
+
+    if (entry.path.toLowerCase().includes(q)) {
+      matchReasons.push('path');
+      score += 2.0;
+    }
+    if (entry.role.toLowerCase().includes(q)) {
+      matchReasons.push('role');
+      score += 1.5;
+    }
+    for (const link of entry.links) {
+      if (link.path.toLowerCase().includes(q) || link.relation.toLowerCase().includes(q)) {
+        matchReasons.push('link');
+        score += 0.5;
+        break;
+      }
+    }
+
+    if (score > 0) {
+      results.push({ entry, score, matchReasons });
+    }
+  }
+
+  return results.sort((a, b) => b.score - a.score);
+}
diff --git a/scripts/mycelium-snapshot.ts b/scripts/mycelium-snapshot.ts
index f627812b..82dfd798 100644
--- a/scripts/mycelium-snapshot.ts
+++ b/scripts/mycelium-snapshot.ts
@@ -39,6 +39,23 @@ import { graphHealth } from '../packages/shared/src/mycelium/reference-graph.ts'
 const args = process.argv.slice(2);
 const DRY = args.includes('--dry') || !args.includes('--exec');
 
+// --out <path>: write a copy to an additional path (useful for build pipelines)
+const outIdx = args.indexOf('--out');
+const OUT_PATH: string | null = outIdx !== -1 ? (args[outIdx + 1] ?? null) : null;
+
+// --public: sanitize the --out copy for public surfaces (R-SEC-002):
+// strips sourcePath/evidence/note (machine paths) and drops repository nodes
+// not in PUBLIC_REPO_ALLOWLIST (investigation/personal repos never go public).
+const PUBLIC = args.includes('--public');
+const PUBLIC_REPO_ALLOWLIST = new Set([
+  'egos',
+  'egos-lab',
+  'egos-governance',
+  'egos-public-work',
+  'hermes-egos',
+  'gem-hunter',
+]);
+
 const REPO_ROOT = join(import.meta.dir, '..');
 const HOME = homedir();
 const NOW_S = Math.floor(Date.now() / 1000);
@@ -615,4 +632,29 @@ if (DRY) {
   console.log(`[--exec] Snapshot escrito em:`);
   console.log(`  ${primaryPath}`);
   console.log(`  ${tmpPath}`);
+
+  if (OUT_PATH) {
+    // Resolve relative to cwd so callers can use relative paths
+    const resolvedOut = OUT_PATH.startsWith('/') ? OUT_PATH : join(process.cwd(), OUT_PATH);
+    const outJson = PUBLIC ? JSON.stringify(sanitizeForPublic(graph), null, 2) : json;
+    writeFileSync(resolvedOut, outJson, 'utf8');
+    console.log(`  ${resolvedOut} (--out${PUBLIC ? ' --public' : ''})`);
+  }
+}
+
+// Public surfaces never receive machine paths or non-allowlisted repo names.
+function sanitizeForPublic(g: ReferenceGraph): ReferenceGraph {
+  const droppedIds = new Set(
+    g.nodes
+      .filter((n) => n.type === 'repository' && !PUBLIC_REPO_ALLOWLIST.has(n.label))
+      .map((n) => n.id),
+  );
+  const nodes = g.nodes
+    .filter((n) => !droppedIds.has(n.id))
+    .map(({ sourcePath: _sp, evidence: _ev, note: _nt, ...rest }) => ({
+      ...rest,
+      label: rest.label.replace(/\s*\(\/home\/[^)]*\)/g, ''),
+    }) as ReferenceNode);
+  const edges = g.edges.filter((e) => !droppedIds.has(e.from) && !droppedIds.has(e.to));
+  return { ...g, nodes, edges };
 }

exec
/bin/bash -lc "sed -n '1,240p' agents/subscribers/bus-redis-bridge.ts; printf '\\n---sentinela---\\n'; sed -n '1,260p' agents/subscribers/sentinela-bus-subscriber.ts; printf '\\n---manifest---\\n'; sed -n '1,260p' packages/shared/src/mycelium/file-reference-manifest.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Bus→Redis Bridge — MYCELIUM-005 (Decisão A)
 *
 * Assina o bus in-process e re-publica cada evento no canal Redis
 * `egos:mycelium:events` via redis-bridge (EGOS-089, zero deps).
 *
 * Design:
 * - Fail-visible: Redis off → console.warn 1x, bus in-process continua
 * - Solo o mínimo necessário para MYCELIUM-005 AC
 * - Padrão wildcard '*' captura TODOS os tópicos (inclui architecture.ssot_violation)
 *
 * @module Mycelium/Bridge
 */

import {
  createRedisBridge,
  type RedisBridge,
  type MyceliumEvent as RedisBridgeEvent,
} from '../../packages/shared/src/mycelium/redis-bridge';
import { type MyceliumBus, type MyceliumEvent } from '../runtime/event-bus';

// ─── Config ───────────────────────────────────────────────────

const REDIS_URL = process.env.REDIS_URL ?? 'redis://localhost:6379';
const CHANNEL = 'egos:mycelium:events';

// ─── Type mapping ─────────────────────────────────────────────

/**
 * Mapeia MyceliumEvent (bus interno) para RedisBridgeEvent (redis-bridge).
 * O campo `type` do bridge aceita apenas os literais definidos no redis-bridge;
 * usamos 'node_updated' como envelope genérico para eventos de bus.
 */
function toBridgeEvent(event: MyceliumEvent): RedisBridgeEvent {
  return {
    type: 'node_updated', // envelope genérico — payload contém o topic real
    timestamp: event.timestamp,
    source: event.source,
    payload: {
      busEventId: event.id,
      topic: event.topic,
      correlationId: event.correlationId,
      payload: event.payload,
      metadata: event.metadata,
    },
  };
}

// ─── Bridge handle ────────────────────────────────────────────

export interface BusRedisBridgeHandle {
  /** Para a ponte e fecha conexões Redis */
  close: () => Promise<void>;
  /** Transporte em uso: 'redis' | 'mock' */
  readonly transport: string;
}

// ─── Main export ──────────────────────────────────────────────

/**
 * Liga o bus in-process ao canal Redis.
 *
 * Assina o padrão wildcard '*' no bus (todos os tópicos) e re-publica
 * cada evento no canal `egos:mycelium:events` via redis-bridge.
 *
 * Fail-visible: se Redis não estiver disponível, redis-bridge retorna
 * mock transport e logs vão para console.warn (comportamento de EGOS-089).
 *
 * @example
 * ```ts
 * const handle = await bridgeBusToRedis(getGlobalBus());
 * // ... processo em execução ...
 * await handle.close();
 * ```
 */
export async function bridgeBusToRedis(bus: MyceliumBus): Promise<BusRedisBridgeHandle> {
  let bridge: RedisBridge;

  try {
    bridge = await createRedisBridge({
      redisUrl: REDIS_URL,
      channel: CHANNEL,
      publishOnMutation: false,
    });
  } catch (err) {
    console.warn(
      '[bus-redis-bridge] falha ao criar bridge Redis — eventos não serão propagados cross-process.',
      (err as Error).message,
    );
    // Retorna handle no-op para não quebrar o processo
    return {
      transport: 'failed',
      close: async () => {},
    };
  }

  console.log(`[bus-redis-bridge] transport=${bridge.transport} channel=${CHANNEL}`);

  // Assina todos os tópicos via wildcard '*'
  const sub = bus.on('*', async (event: MyceliumEvent) => {
    try {
      await bridge.publish(toBridgeEvent(event));
    } catch (err) {
      console.warn('[bus-redis-bridge] publish error:', (err as Error).message);
    }
  }, 'bus-redis-bridge');

  return {
    transport: bridge.transport,

    async close(): Promise<void> {
      bus.off(sub);
      await bridge.close();
      console.log('[bus-redis-bridge] closed');
    },
  };
}

---sentinela---
/**
 * Sentinela Bus Subscriber — MYCELIUM-004 / MYCELIUM-005
 *
 * MYCELIUM-004: in-process subscriber (getGlobalBus) → ~/.egos/sentinela-flags.jsonl
 * MYCELIUM-005: cross-process subscriber via Redis pub/sub (canal egos:mycelium:events)
 *
 * Topologia após MYCELIUM-005:
 *   Processo runner: bus.emit → bus-redis-bridge → Redis canal egos:mycelium:events
 *   Processo Sentinela: subscribeViaRedis() → lê do Redis → escreve flag JSONL
 *
 * @module Mycelium/Subscribers
 */

import { appendFileSync, mkdirSync, existsSync } from 'node:fs';
import { resolve } from 'node:path';
import { homedir } from 'node:os';
import { getGlobalBus, Topics, type MyceliumEvent } from '../runtime/event-bus';
import {
  createRedisBridge,
  type MyceliumEvent as RedisBridgeEvent,
} from '../../packages/shared/src/mycelium/redis-bridge';

// ─── Paths ────────────────────────────────────────────────────

const HOME = homedir();
const EGOS_DIR = resolve(HOME, '.egos');
const SENTINEL_FLAGS = resolve(EGOS_DIR, 'sentinela-flags.jsonl');

// ─── Flag record ─────────────────────────────────────────────

export interface BusFlag {
  ts: string;
  event: string;
  payload: unknown;
  source: string;
  correlationId: string;
  eventId: string;
}

// ─── Write helper ─────────────────────────────────────────────

function writeBusFlag(event: MyceliumEvent): BusFlag {
  if (!existsSync(EGOS_DIR)) {
    mkdirSync(EGOS_DIR, { recursive: true });
  }
  const flag: BusFlag = {
    ts: new Date().toISOString(),
    event: event.topic,
    payload: event.payload,
    source: 'mycelium-bus',
    correlationId: event.correlationId,
    eventId: event.id,
  };
  appendFileSync(SENTINEL_FLAGS, JSON.stringify(flag) + '\n', 'utf8');
  return flag;
}

// ─── Subscriber registration ──────────────────────────────────

/**
 * Register all Sentinela-relevant bus subscriptions on the global bus.
 *
 * Call once at process startup (idempotent: each call adds a new sub,
 * so avoid calling multiple times unless you want duplicate flags).
 *
 * Returns an unsubscribe function that removes all registered handlers.
 */
export function registerSentinelaSubscriptions(): () => void {
  const bus = getGlobalBus();

  // Handler: architecture.ssot_violation → flag in JSONL
  const ssotSub = bus.on(
    Topics.ARCH_SSOT_VIOLATION,
    (event) => {
      const flag = writeBusFlag(event);
      console.log(
        `[sentinela-subscriber] ARCH_SSOT_VIOLATION received — flagged: eventId=${flag.eventId} correlationId=${flag.correlationId}`,
      );
    },
    'sentinela',
  );

  // Handler: architecture.* wildcard — catch future arch events too
  const archWildcardSub = bus.on(
    'architecture.*',
    (event) => {
      // ssot_violation already handled above; avoid duplicate flag
      if (event.topic === Topics.ARCH_SSOT_VIOLATION) return;
      const flag = writeBusFlag(event);
      console.log(
        `[sentinela-subscriber] architecture.* received topic=${event.topic} — flagged: eventId=${flag.eventId}`,
      );
    },
    'sentinela',
  );

  return () => {
    bus.off(ssotSub);
    bus.off(archWildcardSub);
  };
}

// ─── Redis subscriber (MYCELIUM-005) ─────────────────────────

const REDIS_URL_SENTINELA = process.env.REDIS_URL ?? 'redis://localhost:6379';
const REDIS_CHANNEL = 'egos:mycelium:events';

/**
 * Abre subscrição no canal Redis e escreve flag JSONL para cada evento recebido.
 * source = 'mycelium-redis' para distinguir de flags in-process.
 *
 * Returns a close function — call it to stop receiving and close the socket.
 */
export async function subscribeViaRedis(): Promise<() => Promise<void>> {
  const bridge = await createRedisBridge({
    redisUrl: REDIS_URL_SENTINELA,
    channel: REDIS_CHANNEL,
    publishOnMutation: false,
  });

  console.log(
    `[sentinela-redis] subscribed to channel=${REDIS_CHANNEL} transport=${bridge.transport}`,
  );

  const unsubscribe = bridge.subscribe((bridgeEvent: RedisBridgeEvent) => {
    // payload envelope criado por bus-redis-bridge.toBridgeEvent
    const envelope = bridgeEvent.payload as {
      busEventId?: string;
      topic?: string;
      correlationId?: string;
      payload?: unknown;
    } | null;

    const topic = envelope?.topic ?? bridgeEvent.type;
    const eventId = envelope?.busEventId ?? 'unknown';
    const correlationId = envelope?.correlationId ?? 'unknown';
    const innerPayload = envelope?.payload ?? bridgeEvent.payload;

    if (!existsSync(EGOS_DIR)) {
      mkdirSync(EGOS_DIR, { recursive: true });
    }

    const flag: BusFlag = {
      ts: new Date().toISOString(),
      event: topic,
      payload: innerPayload,
      source: 'mycelium-redis',
      correlationId,
      eventId,
    };

    appendFileSync(SENTINEL_FLAGS, JSON.stringify(flag) + '\n', 'utf8');
    console.log(
      `[sentinela-redis] flag written — topic=${topic} eventId=${eventId}`,
    );
  });

  return async () => {
    unsubscribe();
    await bridge.close();
    console.log('[sentinela-redis] unsubscribed and closed');
  };
}

---manifest---
/**
 * File Reference Manifest — LLM File Signature System
 *
 * Tracks which files are "owned" by the Mycelium mesh and injects
 * canonical reference signatures into them so LLMs can navigate the
 * codebase by following typed links.
 *
 * @see scripts/mycelium/file-signature-sync.ts
 * @see scripts/governance-ai-lint.ts
 */

// ═══════════════════════════════════════════════════════════
// Types
// ═══════════════════════════════════════════════════════════

export type FileReferenceMode = 'inject' | 'manifest_only';

export interface FileReferenceLink {
  path: string;
  relation: string;
  note?: string;
}

export interface FileReferenceEntry {
  /** Repo-relative path to the file */
  path: string;
  /** Human/LLM-readable description of this file's role in the system */
  role: string;
  /** 'inject' = signature is written into file; 'manifest_only' = tracked but not injected */
  mode: FileReferenceMode;
  /** Cross-references to related files */
  links: FileReferenceLink[];
}

export interface ManifestGrowthViolation {
  kind: 'entry_limit' | 'link_limit';
  detail: string;
}

export interface FileReferenceSearchResult {
  entry: FileReferenceEntry;
  score: number;
  matchReasons: string[];
}

// ═══════════════════════════════════════════════════════════
// Growth limits
// ═══════════════════════════════════════════════════════════

export const MAX_MANIFEST_ENTRIES = 50;
export const MAX_LINKS_PER_ENTRY = 8;

// ═══════════════════════════════════════════════════════════
// Signature delimiters
// ═══════════════════════════════════════════════════════════

export const FILE_SIGNATURE_START = '<!-- EGOS:FILE-REF-SIG:START -->';
export const FILE_SIGNATURE_END = '<!-- EGOS:FILE-REF-SIG:END -->';

// ═══════════════════════════════════════════════════════════
// Manifest — canonical list of tracked files
// ═══════════════════════════════════════════════════════════

export const FILE_REFERENCE_MANIFEST: FileReferenceEntry[] = [
  {
    path: '.windsurfrules',
    role: 'Windsurf IDE rules — enforces EGOS coding conventions and governance patterns in the editor.',
    mode: 'inject',
    links: [
      { path: 'AGENTS.md', relation: 'governed_by' },
      { path: '.guarani/RULES_INDEX.md', relation: 'governed_by' },
    ],
  },
  {
    path: '.windsurf/workflows/start.md',
    role: 'Session initialization workflow — loads deep context, tasks, handoffs, and SSOT state.',
    mode: 'inject',
    links: [
      { path: 'TASKS.md', relation: 'reads' },
      { path: 'AGENTS.md', relation: 'governed_by' },
    ],
  },
  {
    path: '.windsurf/workflows/end.md',
    role: 'Session finalization workflow — commits state, writes handoff, harvests learnings.',
    mode: 'inject',
    links: [
      { path: 'TASKS.md', relation: 'writes' },
      { path: 'docs/knowledge/HARVEST.md', relation: 'writes' },
    ],
  },
  {
    path: 'AGENTS.md',
    role: 'Constitutional document — R0-R8 rules governing all agents in this workspace.',
    mode: 'manifest_only',
    links: [],
  },
  {
    path: 'packages/shared/src/mycelium/reference-graph.ts',
    role: 'Canonical graph schema and kernel seed — defines node/edge types and the EGOS mesh topology.',
    mode: 'manifest_only',
    links: [
      { path: 'packages/shared/src/mycelium/file-reference-manifest.ts', relation: 'complements' },
    ],
  },
  {
    path: 'packages/shared/src/mycelium/file-reference-manifest.ts',
    role: 'File reference manifest — tracks LLM-navigable signatures for key workspace files.',
    mode: 'manifest_only',
    links: [
      { path: 'packages/shared/src/mycelium/reference-graph.ts', relation: 'complements' },
    ],
  },
];

// ═══════════════════════════════════════════════════════════
// Utilities
// ═══════════════════════════════════════════════════════════

/**
 * Renders the canonical LLM file reference signature block for an entry.
 * The block is delimited by FILE_SIGNATURE_START / FILE_SIGNATURE_END.
 */
export function renderFileReferenceSignature(entry: FileReferenceEntry): string {
  const linkLines = entry.links.map(
    l => `<!--   ${l.relation}: ${l.path}${l.note ? ` — ${l.note}` : ''} -->`,
  );
  const body = [
    `<!-- role: ${entry.role} -->`,
    ...(linkLines.length > 0 ? ['<!-- links:'] : []),
    ...linkLines,
    ...(linkLines.length > 0 ? ['-->'] : []),
  ].join('\n');

  return `${FILE_SIGNATURE_START}\n${body}\n${FILE_SIGNATURE_END}`;
}

/**
 * Returns violations if the manifest exceeds configured growth limits.
 * Fail-visible: callers must handle violations before writing files.
 */
export function validateManifestGrowth(): ManifestGrowthViolation[] {
  const violations: ManifestGrowthViolation[] = [];

  if (FILE_REFERENCE_MANIFEST.length > MAX_MANIFEST_ENTRIES) {
    violations.push({
      kind: 'entry_limit',
      detail: `manifest has ${FILE_REFERENCE_MANIFEST.length} entries, limit is ${MAX_MANIFEST_ENTRIES}`,
    });
  }

  for (const entry of FILE_REFERENCE_MANIFEST) {
    if (entry.links.length > MAX_LINKS_PER_ENTRY) {
      violations.push({
        kind: 'link_limit',
        detail: `${entry.path} has ${entry.links.length} links, limit is ${MAX_LINKS_PER_ENTRY}`,
      });
    }
  }

  return violations;
}

/**
 * Searches the manifest for entries matching the query string.
 * Matches against path, role, and link paths.
 */
export function searchFileReferences(query: string): FileReferenceSearchResult[] {
  const q = query.toLowerCase();
  const results: FileReferenceSearchResult[] = [];

  for (const entry of FILE_REFERENCE_MANIFEST) {
    const matchReasons: string[] = [];
    let score = 0;

    if (entry.path.toLowerCase().includes(q)) {
      matchReasons.push('path');
      score += 2.0;
    }
    if (entry.role.toLowerCase().includes(q)) {
      matchReasons.push('role');
      score += 1.5;
    }
    for (const link of entry.links) {
      if (link.path.toLowerCase().includes(q) || link.relation.toLowerCase().includes(q)) {
        matchReasons.push('link');
        score += 0.5;
        break;
      }
    }

    if (score > 0) {
      results.push({ entry, score, matchReasons });
    }
  }

  return results.sort((a, b) => b.score - a.score);
}

exec
/bin/bash -lc "sed -n '1,260p' packages/shared/src/mycelium/redis-bridge.ts; sed -n '1,220p' agents/runtime/event-bus.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Mycelium → Redis Pub/Sub Bridge
 *
 * EGOS-089: Bridges the in-memory Mycelium reference graph to Redis Pub/Sub
 * for cross-process agent communication.
 *
 * Design principles:
 * - Export functions, not classes
 * - Graceful degradation when Redis is unavailable (logs to console)
 * - Importable without Redis running
 * - No hard runtime dependency on a Redis client package — uses
 *   Node.js native `net` for the RESP2 wire protocol OR falls back
 *   to the mock transport when REDIS_URL is not set.
 *
 * @see docs/concepts/mycelium/REFERENCE_GRAPH_DESIGN.md
 * @see TASKS.md EGOS-089
 */

import * as net from 'net';

// ═══════════════════════════════════════════════════════════
// Public Types
// ═══════════════════════════════════════════════════════════

export interface RedisBridgeConfig {
  /** Redis connection URL, e.g. redis://localhost:6379 */
  redisUrl: string;
  /** Pub/Sub channel name, e.g. 'egos:mycelium:events' */
  channel: string;
  /** When true, automatically publish events on graph mutations */
  publishOnMutation: boolean;
}

export interface MyceliumEvent {
  type: 'node_added' | 'node_updated' | 'edge_added' | 'edge_removed' | 'graph_snapshot';
  timestamp: string;
  payload: unknown;
  /** Origin repo or agent identifier */
  source: string;
}

/** Opaque bridge handle returned by createRedisBridge */
export interface RedisBridge {
  /** Publish a single MyceliumEvent to the configured channel */
  publish: (event: MyceliumEvent) => Promise<void>;
  /**
   * Subscribe to the configured channel.
   * Returns an unsubscribe function — call it to stop receiving events.
   */
  subscribe: (handler: (event: MyceliumEvent) => void) => () => void;
  /** Tear down all connections gracefully */
  close: () => Promise<void>;
  /** Internal transport — 'redis' | 'mock' */
  readonly transport: 'redis' | 'mock';
}

// ═══════════════════════════════════════════════════════════
// RESP2 helpers (minimal subset for PUBLISH / SUBSCRIBE)
// ═══════════════════════════════════════════════════════════

function encodeRespArray(...args: string[]): Buffer {
  const parts: string[] = [`*${args.length}\r\n`];
  for (const arg of args) {
    parts.push(`$${Buffer.byteLength(arg)}\r\n${arg}\r\n`);
  }
  return Buffer.from(parts.join(''));
}

interface RespSocket {
  socket: net.Socket;
  write: (cmd: Buffer) => void;
  destroy: () => void;
}

function connectRespSocket(host: string, port: number): Promise<RespSocket> {
  return new Promise((resolve, reject) => {
    const socket = net.createConnection({ host, port });
    const timeout = setTimeout(() => {
      socket.destroy();
      reject(new Error(`Redis connection timeout ${host}:${port}`));
    }, 3000);

    socket.once('connect', () => {
      clearTimeout(timeout);
      resolve({
        socket,
        write: (cmd: Buffer) => socket.write(cmd),
        destroy: () => socket.destroy(),
      });
    });

    socket.once('error', (err) => {
      clearTimeout(timeout);
      reject(err);
    });
  });
}

function parseRedisUrl(redisUrl: string): { host: string; port: number } {
  try {
    const url = new URL(redisUrl);
    return {
      host: url.hostname || 'localhost',
      port: url.port ? parseInt(url.port, 10) : 6379,
    };
  } catch {
    return { host: 'localhost', port: 6379 };
  }
}

// ═══════════════════════════════════════════════════════════
// Mock Transport (used when Redis is unavailable)
// ═══════════════════════════════════════════════════════════

const _mockHandlers: Set<(event: MyceliumEvent) => void> = new Set();

function createMockBridge(config: RedisBridgeConfig): RedisBridge {
  const prefix = `[mycelium:mock][${config.channel}]`;

  return {
    transport: 'mock',

    async publish(event: MyceliumEvent): Promise<void> {
      console.log(`${prefix} PUBLISH`, JSON.stringify(event));
      // Also fan-out to in-process subscribers so tests work without Redis
      for (const handler of _mockHandlers) {
        try {
          handler(event);
        } catch (err) {
          console.error(`${prefix} subscriber error`, err);
        }
      }
    },

    subscribe(handler: (event: MyceliumEvent) => void): () => void {
      _mockHandlers.add(handler);
      console.log(`${prefix} SUBSCRIBE (mock — ${_mockHandlers.size} subscriber(s))`);
      return () => {
        _mockHandlers.delete(handler);
      };
    },

    async close(): Promise<void> {
      _mockHandlers.clear();
      console.log(`${prefix} CLOSE (mock)`);
    },
  };
}

// ═══════════════════════════════════════════════════════════
// Redis Transport
// ═══════════════════════════════════════════════════════════

interface RedisTransportState {
  publisher: RespSocket;
  subscribers: Map<(event: MyceliumEvent) => void, RespSocket>;
}

async function createRedisBridgeTransport(
  config: RedisBridgeConfig,
  { host, port }: { host: string; port: number },
): Promise<RedisBridge> {
  const publisher = await connectRespSocket(host, port);

  const state: RedisTransportState = {
    publisher,
    subscribers: new Map(),
  };

  return {
    transport: 'redis',

    async publish(event: MyceliumEvent): Promise<void> {
      const message = JSON.stringify(event);
      const cmd = encodeRespArray('PUBLISH', config.channel, message);
      await new Promise<void>((resolve, reject) => {
        state.publisher.socket.once('error', reject);
        state.publisher.write(cmd);
        // PUBLISH response is an integer — we fire and don't block for it
        setImmediate(resolve);
      });
    },

    subscribe(handler: (event: MyceliumEvent) => void): () => void {
      // Each subscriber gets its own socket so the SUBSCRIBE command
      // doesn't block the shared publisher socket
      let subSocket: RespSocket | null = null;

      connectRespSocket(host, port)
        .then((sock) => {
          subSocket = sock;
          state.subscribers.set(handler, sock);

          const cmd = encodeRespArray('SUBSCRIBE', config.channel);
          sock.write(cmd);

          let buf = '';
          sock.socket.on('data', (chunk: Buffer) => {
            buf += chunk.toString();
            // Naive scan for the message payload line (3rd element of RESP array)
            // Full RESP2 parser is out of scope for this scaffold
            const lines = buf.split('\r\n');
            // A pub/sub message looks like: *3\r\n$7\r\nmessage\r\n$<channel-len>\r\n<channel>\r\n$<msg-len>\r\n<msg>\r\n
            for (let i = 0; i < lines.length - 1; i++) {
              if (lines[i] === '$' + lines[i + 1]?.length || lines[i].startsWith('$')) {
                const candidate = lines[i + 1];
                if (candidate && candidate.startsWith('{')) {
                  try {
                    const event = JSON.parse(candidate) as MyceliumEvent;
                    handler(event);
                    buf = '';
                  } catch {
                    // not valid JSON — keep buffering
                  }
                }
              }
            }
          });

          sock.socket.on('error', (err) => {
            console.error('[mycelium:redis-bridge] subscriber socket error', err);
          });
        })
        .catch((err) => {
          console.error('[mycelium:redis-bridge] failed to open subscriber socket', err);
        });

      return () => {
        if (subSocket) {
          state.subscribers.delete(handler);
          subSocket.destroy();
        }
      };
    },

    async close(): Promise<void> {
      for (const sock of state.subscribers.values()) {
        sock.destroy();
      }
      state.subscribers.clear();
      state.publisher.destroy();
    },
  };
}

// ═══════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════

/**
 * Create a RedisBridge from config.
 *
 * If REDIS_URL is not set AND no redisUrl is provided, or if the Redis
 * server is unreachable, falls back to a mock transport that logs events
 * to stdout and fans out to in-process subscribers.
 *
 * @example
 * ```ts
 * const bridge = await createRedisBridge({
 *   redisUrl: process.env.REDIS_URL ?? 'redis://localhost:6379',
/**
 * Mycelium Event Bus — Inter-Agent Communication System
 * 
 * Zero-dependency, TypeScript-native event bus for the EGOS Agentic Platform.
 * Synthesizes patterns from Google A2A, LangGraph, AutoGen, and MCP.
 * 
 * Features:
 * - Typed events with topic namespacing (e.g. "security.finding", "qa.regression")
 * - Wildcard subscriptions ("security.*", "*.critical")
 * - JSONL audit trail for complete event forensics
 * - Sync-first execution; Redis-ready for distributed mode
 * - Conditional routing via topic matching
 * 
 * @module Mycelium
 */

import { randomUUID } from 'crypto';
import { appendFileSync, mkdirSync, existsSync } from 'fs';
import { join } from 'path';

// ─── Types ────────────────────────────────────────────────────

export interface MyceliumEvent<T = unknown> {
    id: string;
    topic: string;
    source: string;
    correlationId: string;
    timestamp: string;
    payload: T;
    metadata?: Record<string, unknown>;
}

export type EventHandler<T = unknown> = (event: MyceliumEvent<T>) => void | Promise<void>;

export interface Subscription {
    id: string;
    pattern: string;
    handler: EventHandler;
    agentId?: string;
    once?: boolean;
}

export interface EventFilter {
    topic?: string;
    source?: string;
    correlationId?: string;
    since?: string;
    limit?: number;
}

// ─── Well-Known Event Payloads ────────────────────────────────

export type { Finding as FindingPayload } from './runner';

export interface RegressionPayload {
    test: string;
    before: 'pass' | 'fail';
    after: 'pass' | 'fail';
}

export interface DriftPayload {
    file: string;
    rule: string;
    expected: string;
    actual: string;
}

export interface AgentCompletedPayload {
    agentId: string;
    status: 'pass' | 'fail' | 'skip' | 'error';
    durationMs: number;
    findingsCount: number;
}

// ─── Topic Matching ───────────────────────────────────────────

/**
 * Matches a topic against a glob-like pattern.
 * Supports:
 *   "security.*"     → matches "security.finding", "security.jailbreak"
 *   "*.critical"     → matches "security.critical", "qa.critical"
 *   "security.finding" → exact match
 *   "*"              → matches everything
 */
function matchTopic(pattern: string, topic: string): boolean {
    if (pattern === '*') return true;
    if (pattern === topic) return true;

    const patternParts = pattern.split('.');
    const topicParts = topic.split('.');

    if (patternParts.length !== topicParts.length) return false;

    return patternParts.every((pp, i) => pp === '*' || pp === topicParts[i]);
}

// ─── Mycelium Bus ─────────────────────────────────────────────

const EGOS_ROOT = join(import.meta.dir, '..', '..');
const LOG_DIR = join(EGOS_ROOT, 'agents', '.logs');
const EVENT_LOG = join(LOG_DIR, 'events.jsonl');

export class MyceliumBus {
    private subscriptions: Map<string, Subscription> = new Map();
    private history: MyceliumEvent[] = [];
    private maxHistory: number;

    constructor(options?: { maxHistory?: number }) {
        this.maxHistory = options?.maxHistory ?? 1000;
        if (!existsSync(LOG_DIR)) {
            mkdirSync(LOG_DIR, { recursive: true });
        }
    }

    /**
     * Emit a typed event to all matching subscribers.
     */
    emit<T = unknown>(
        topic: string,
        payload: T,
        source: string,
        correlationId: string,
        metadata?: Record<string, unknown>
    ): MyceliumEvent<T> {
        const event: MyceliumEvent<T> = {
            id: randomUUID(),
            topic,
            source,
            correlationId,
            timestamp: new Date().toISOString(),
            payload,
            metadata,
        };

        // Persist to JSONL audit trail
        this.persistEvent(event);

        // Store in memory history
        this.history.push(event as MyceliumEvent);
        if (this.history.length > this.maxHistory) {
            this.history = this.history.slice(-this.maxHistory);
        }

        // Dispatch to matching subscribers
        const toRemove: string[] = [];
        for (const [id, sub] of this.subscriptions) {
            if (matchTopic(sub.pattern, topic)) {
                try {
                    const handlerResult = sub.handler(event as MyceliumEvent);
                    if (handlerResult && typeof (handlerResult as Promise<void>).catch === 'function') {
                        void (handlerResult as Promise<void>).catch((err) => {
                            console.error(`[MYCELIUM] Handler error for ${sub.pattern}:`, err);
                        });
                    }
                } catch (err) {
                    console.error(`[MYCELIUM] Handler error for ${sub.pattern}:`, err);
                }
                if (sub.once) {
                    toRemove.push(id);
                }
            }
        }

        // Cleanup one-shot subscriptions
        for (const id of toRemove) {
            this.subscriptions.delete(id);
        }

        return event;
    }

    /**
     * Subscribe to events matching a glob pattern.
     * Returns a Subscription that can be passed to off().
     */
    on<T = unknown>(pattern: string, handler: EventHandler<T>, agentId?: string): Subscription {
        const sub: Subscription = {
            id: randomUUID(),
            pattern,
            handler: handler as EventHandler,
            agentId,
        };
        this.subscriptions.set(sub.id, sub);
        return sub;
    }

    /**
     * Subscribe to the next single event matching a pattern.
     * Returns a promise that resolves with the event.
     */
    once<T = unknown>(pattern: string): Promise<MyceliumEvent<T>> {
        return new Promise((resolve) => {
            const sub: Subscription = {
                id: randomUUID(),
                pattern,
                handler: (event) => resolve(event as MyceliumEvent<T>),
                once: true,
            };
            this.subscriptions.set(sub.id, sub);
        });
    }

    /**
     * Unsubscribe from events.
     */
    off(sub: Subscription): void {
        this.subscriptions.delete(sub.id);
    }

    /**
     * Get event history with optional filtering.
     */
    getHistory(filter?: EventFilter): MyceliumEvent[] {
        let events = [...this.history];

        if (filter?.topic) {
            events = events.filter(e => matchTopic(filter.topic!, e.topic));
        }
        if (filter?.source) {
            events = events.filter(e => e.source === filter.source);

exec
/bin/bash -lc "sed -n '220,520p' packages/shared/src/mycelium/redis-bridge.ts; sed -n '220,520p' agents/runtime/event-bus.ts" in /home/enio/egos
 succeeded in 0ms:
          sock.socket.on('error', (err) => {
            console.error('[mycelium:redis-bridge] subscriber socket error', err);
          });
        })
        .catch((err) => {
          console.error('[mycelium:redis-bridge] failed to open subscriber socket', err);
        });

      return () => {
        if (subSocket) {
          state.subscribers.delete(handler);
          subSocket.destroy();
        }
      };
    },

    async close(): Promise<void> {
      for (const sock of state.subscribers.values()) {
        sock.destroy();
      }
      state.subscribers.clear();
      state.publisher.destroy();
    },
  };
}

// ═══════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════

/**
 * Create a RedisBridge from config.
 *
 * If REDIS_URL is not set AND no redisUrl is provided, or if the Redis
 * server is unreachable, falls back to a mock transport that logs events
 * to stdout and fans out to in-process subscribers.
 *
 * @example
 * ```ts
 * const bridge = await createRedisBridge({
 *   redisUrl: process.env.REDIS_URL ?? 'redis://localhost:6379',
 *   channel: 'egos:mycelium:events',
 *   publishOnMutation: true,
 * });
 * ```
 */
export async function createRedisBridge(config: RedisBridgeConfig): Promise<RedisBridge> {
  const effectiveUrl = config.redisUrl || process.env.REDIS_URL || '';

  if (!effectiveUrl) {
    console.warn('[mycelium:redis-bridge] REDIS_URL not set — using mock transport');
    return createMockBridge(config);
  }

  const { host, port } = parseRedisUrl(effectiveUrl);

  try {
    return await createRedisBridgeTransport(config, { host, port });
  } catch (err) {
    console.warn(
      `[mycelium:redis-bridge] Redis unreachable (${host}:${port}) — falling back to mock transport. Error: ${(err as Error).message}`,
    );
    return createMockBridge(config);
  }
}

/**
 * Publish a MyceliumEvent through the bridge.
 *
 * @example
 * ```ts
 * await publishEvent(bridge, {
 *   type: 'node_added',
 *   timestamp: new Date().toISOString(),
 *   payload: node,
 *   source: 'egos-kernel',
 * });
 * ```
 */
export async function publishEvent(bridge: RedisBridge, event: MyceliumEvent): Promise<void> {
  return bridge.publish(event);
}

/**
 * Subscribe to MyceliumEvents through the bridge.
 * Returns an unsubscribe function — call it to stop receiving events.
 *
 * @example
 * ```ts
 * const unsubscribe = subscribeToEvents(bridge, (event) => {
 *   console.log('received', event.type, event.source);
 * });
 * // later:
 * unsubscribe();
 * ```
 */
export function subscribeToEvents(
  bridge: RedisBridge,
  handler: (event: MyceliumEvent) => void,
): () => void {
  return bridge.subscribe(handler);
}

/**
 * Build a MyceliumEvent with current timestamp. Convenience helper.
 */
export function buildEvent(
  type: MyceliumEvent['type'],
  payload: unknown,
  source: string,
): MyceliumEvent {
  return {
    type,
    timestamp: new Date().toISOString(),
    payload,
    source,
  };
}
            events = events.filter(e => e.source === filter.source);
        }
        if (filter?.correlationId) {
            events = events.filter(e => e.correlationId === filter.correlationId);
        }
        if (filter?.since) {
            events = events.filter(e => e.timestamp >= filter.since!);
        }
        if (filter?.limit) {
            events = events.slice(-filter.limit);
        }

        return events;
    }

    /**
     * Get summary statistics for the current bus session.
     */
    stats(): { total: number; byTopic: Record<string, number>; bySource: Record<string, number>; subscribers: number } {
        const byTopic: Record<string, number> = {};
        const bySource: Record<string, number> = {};

        for (const event of this.history) {
            byTopic[event.topic] = (byTopic[event.topic] || 0) + 1;
            bySource[event.source] = (bySource[event.source] || 0) + 1;
        }

        return {
            total: this.history.length,
            byTopic,
            bySource,
            subscribers: this.subscriptions.size,
        };
    }

    /**
     * Reset the bus (clear history and subscriptions).
     * Use between orchestrator runs.
     */
    reset(): void {
        this.history = [];
        this.subscriptions.clear();
    }

    // ── Private ─────────────────────────────────────────────────

    private persistEvent(event: MyceliumEvent): void {
        try {
            const line = JSON.stringify(event) + '\n';
            appendFileSync(EVENT_LOG, line);
        } catch {
            // Non-blocking: event bus should never crash the agent
        }
    }
}

// ─── Singleton ────────────────────────────────────────────────

let _globalBus: MyceliumBus | null = null;

/**
 * Get or create the global Mycelium bus instance.
 * Used by the orchestrator to share a single bus across all agents.
 */
export function getGlobalBus(): MyceliumBus {
    if (!_globalBus) {
        _globalBus = new MyceliumBus();
    }
    return _globalBus;
}

/**
 * Create a fresh bus instance (for testing or isolated runs).
 */
export function createBus(options?: { maxHistory?: number }): MyceliumBus {
    return new MyceliumBus(options);
}

// ─── Topic Constants ──────────────────────────────────────────

export const Topics = {
    // Security
    SECURITY_FINDING: 'security.finding',
    SECURITY_JAILBREAK: 'security.jailbreak',
    SECURITY_SECRET: 'security.secret',

    // QA
    QA_REGRESSION: 'qa.regression',
    QA_DEAD_CODE: 'qa.dead_code',
    QA_CONTRACT_FAIL: 'qa.contract_fail',

    // Architecture
    ARCH_DRIFT: 'architecture.drift',
    ARCH_DEP_CONFLICT: 'architecture.dep_conflict',
    ARCH_SSOT_VIOLATION: 'architecture.ssot_violation',

    // Knowledge
    KNOWLEDGE_HARVESTED: 'knowledge.harvested',
    KNOWLEDGE_PATTERN: 'knowledge.pattern',

    // Agent Lifecycle
    AGENT_STARTED: 'agent.started',
    AGENT_COMPLETED: 'agent.completed',
    AGENT_FAILED: 'agent.failed',
} as const;

export type TopicKey = keyof typeof Topics;
export type TopicValue = typeof Topics[TopicKey];

exec
/bin/bash -lc "cat package.json | sed -n '1,220p'; grep -R \"test-mycelium-bus\" -n . --exclude-dir=.git" in /home/enio/egos
2026-06-10T11:18:14.210566Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
exec
/bin/bash -lc "sed -n '1,260p' packages/shared/src/mycelium/reference-graph.ts; sed -n '260,620p' packages/shared/src/mycelium/reference-graph.ts" in /home/enio/egos
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
  { id: 'doc:domain-rules', type: 'document', label: 'Domain Rules', status: 'active', evidence: ['code'], sourcePath: '.guarani/orchestration/DOMAIN_RULES.md' },
  { id: 'doc:pipeline', type: 'document', label: 'Orchestration Pipeline', status: 'active', evidence: ['code'], sourcePath: '.guarani/orchestration/PIPELINE.md' },
  { id: 'script:gov-sync', type: 'workflow', label: 'Governance Sync', status: 'active', evidence: ['code', 'runtime'], sourcePath: 'scripts/governance-sync.sh' },

  // Workflows
  { id: 'wf:start', type: 'workflow', label: '/start Workflow', status: 'active', evidence: ['code'], sourcePath: '.windsurf/workflows/start.md' },
  { id: 'wf:end', type: 'workflow', label: '/end Workflow', status: 'active', evidence: ['code'], sourcePath: '.windsurf/workflows/end.md' },
  { id: 'wf:mycelium', type: 'workflow', label: '/mycelium Workflow', status: 'active', evidence: ['code'], sourcePath: '.windsurf/workflows/mycelium.md' },

  // Meta-prompts
  { id: 'prompt:strategist', type: 'document', label: 'Universal Strategist', status: 'active', evidence: ['code'], sourcePath: '.guarani/prompts/meta/universal-strategist.md' },
  { id: 'prompt:brainet', type: 'document', label: 'Brainet Collective', status: 'active', evidence: ['code'], sourcePath: '.guarani/prompts/meta/brainet-collective.md' },
  { id: 'prompt:mycelium', type: 'document', label: 'Mycelium Orchestrator', status: 'active', evidence: ['code'], sourcePath: '.guarani/prompts/meta/mycelium-orchestrator.md' },
  { id: 'prompt:audit', type: 'document', label: 'Ecosystem Audit', status: 'active', evidence: ['code'], sourcePath: '.guarani/prompts/meta/ecosystem-audit.md' },
];

const KERNEL_EDGES: ReferenceEdge[] = [
  // Governance flow
  { from: 'ws:egos-kernel', relation: 'contains', to: 'doc:guarani', evidence: ['code'] },
  { from: 'doc:guarani', relation: 'contains', to: 'doc:domain-rules', evidence: ['code'] },
  { from: 'doc:guarani', relation: 'contains', to: 'doc:pipeline', evidence: ['code'] },
  { from: 'script:gov-sync', relation: 'mirrors', to: 'ws:egos-home', evidence: ['code', 'runtime'] },
  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-lab', evidence: ['code'] },
  { from: 'ws:egos-home', relation: 'governs', to: 'repo:carteira-livre', evidence: ['code'] },
  { from: 'ws:egos-home', relation: 'governs', to: 'repo:br-acc', evidence: ['code'] },
  { from: 'ws:egos-home', relation: 'governs', to: 'repo:forja', evidence: ['code'] },
  { from: 'ws:egos-home', relation: 'governs', to: 'repo:egos-self', evidence: ['code'] },

  // Runtime
  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:agent-runner', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'runtime:event-bus', evidence: ['code'] },
  { from: 'runtime:agent-runner', relation: 'depends_on', to: 'pkg:llm-provider', evidence: ['code'] },
  { from: 'pkg:llm-provider', relation: 'depends_on', to: 'pkg:model-router', evidence: ['code'] },

  // Shared packages
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:llm-provider', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:model-router', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:atrian', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:pii-scanner', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:conversation-memory', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'pkg:conversation-memory', evidence: ['code'] },

  // Leaf repos consume shared packages
  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:llm-provider', evidence: ['code'] },
  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:atrian', evidence: ['code'] },
  { from: 'repo:carteira-livre', relation: 'depends_on', to: 'pkg:pii-scanner', evidence: ['code'] },
  { from: 'repo:852', relation: 'derives_from', to: 'pkg:atrian', evidence: ['code'], note: 'Source of ATRiAN pattern' },
  { from: 'repo:852', relation: 'derives_from', to: 'pkg:conversation-memory', evidence: ['code'], note: 'Source of conversation memory pattern' },
  // Cross-repo chatbot hardening (verified 100/100 compliance-checker)
  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:atrian', evidence: ['code'] },
  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:pii-scanner', evidence: ['code'] },
  { from: 'repo:forja', relation: 'depends_on', to: 'pkg:conversation-memory', evidence: ['code'] },
  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:atrian', evidence: ['code'] },
  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:pii-scanner', evidence: ['code'] },
  { from: 'repo:egos-lab', relation: 'depends_on', to: 'pkg:conversation-memory', evidence: ['code'] },
  // Context tracker governs session lifecycle
  { from: 'ws:egos-kernel', relation: 'contains', to: 'agent:context-tracker', evidence: ['code'] },
  { from: 'agent:context-tracker', relation: 'emits', to: 'wf:end', evidence: ['code'], note: 'Auto-trigger at CTX >= 250' },

  // Workflows
  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:start', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:end', evidence: ['code'] },
  { from: 'ws:egos-kernel', relation: 'contains', to: 'wf:mycelium', evidence: ['code'] },
  { from: 'script:gov-sync', relation: 'routes_to', to: 'wf:start', evidence: ['code'], note: 'Propagates workflow files' },

  // Meta-prompts belong to guarani
  { from: 'doc:guarani', relation: 'contains', to: 'prompt:strategist', evidence: ['code'] },
  { from: 'doc:guarani', relation: 'contains', to: 'prompt:brainet', evidence: ['code'] },
  { from: 'doc:guarani', relation: 'contains', to: 'prompt:mycelium', evidence: ['code'] },
  { from: 'doc:guarani', relation: 'contains', to: 'prompt:audit', evidence: ['code'] },

  // policia is mapped but not auto-synced
  { from: 'ws:egos-home', relation: 'references', to: 'repo:policia', evidence: ['code'], note: 'Mapped-only, not auto-synced' },
];

/**
 * Returns the canonical kernel seed graph representing current EGOS reality.
 */
export function getKernelSeedGraph(): ReferenceGraph {
  return createGraph(KERNEL_NODES, KERNEL_EDGES);
}

exec
/bin/bash -lc "sed -n '1,180p' scripts/mycelium-snapshot.ts; sed -n '180,680p' scripts/mycelium-snapshot.ts" in /home/enio/egos
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

// --out <path>: write a copy to an additional path (useful for build pipelines)
const outIdx = args.indexOf('--out');
const OUT_PATH: string | null = outIdx !== -1 ? (args[outIdx + 1] ?? null) : null;

// --public: sanitize the --out copy for public surfaces (R-SEC-002):
// strips sourcePath/evidence/note (machine paths) and drops repository nodes
// not in PUBLIC_REPO_ALLOWLIST (investigation/personal repos never go public).
const PUBLIC = args.includes('--public');
const PUBLIC_REPO_ALLOWLIST = new Set([
  'egos',
  'egos-lab',
  'egos-governance',
  'egos-public-work',
  'hermes-egos',
  'gem-hunter',
]);

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

  if (OUT_PATH) {
    // Resolve relative to cwd so callers can use relative paths
    const resolvedOut = OUT_PATH.startsWith('/') ? OUT_PATH : join(process.cwd(), OUT_PATH);
    const outJson = PUBLIC ? JSON.stringify(sanitizeForPublic(graph), null, 2) : json;
    writeFileSync(resolvedOut, outJson, 'utf8');
    console.log(`  ${resolvedOut} (--out${PUBLIC ? ' --public' : ''})`);
  }
}

// Public surfaces never receive machine paths or non-allowlisted repo names.
function sanitizeForPublic(g: ReferenceGraph): ReferenceGraph {
  const droppedIds = new Set(
    g.nodes
      .filter((n) => n.type === 'repository' && !PUBLIC_REPO_ALLOWLIST.has(n.label))
      .map((n) => n.id),
  );
  const nodes = g.nodes
    .filter((n) => !droppedIds.has(n.id))
    .map(({ sourcePath: _sp, evidence: _ev, note: _nt, ...rest }) => ({
      ...rest,
      label: rest.label.replace(/\s*\(\/home\/[^)]*\)/g, ''),
    }) as ReferenceNode);
  const edges = g.edges.filter((e) => !droppedIds.has(e.from) && !droppedIds.has(e.to));
  return { ...g, nodes, edges };
}

exec
/bin/bash -lc "nl -ba scripts/mycelium-snapshot.ts | sed -n '150,175p'" in /home/enio/egos
 succeeded in 0ms:
   150	
   151	    edges.push({
   152	      from: WORKSPACE_ID,
   153	      relation: 'governs',
   154	      to: id,
   155	      evidence: ['code'],
   156	      note: 'workspace governance',
   157	    });
   158	  }
   159	
   160	  return { nodes, edges };
   161	}
   162	
   163	// ═══════════════════════════════════════════════════════════
   164	// Source 2 — triggers.json → 12 papéis EGOS
   165	// ═══════════════════════════════════════════════════════════
   166	
   167	interface TriggerAgent {
   168	  tier: string;
   169	  runtime: string;
   170	  role: string;
   171	  upstream: string[];
   172	  downstream: string[];
   173	  trigger: string;
   174	  gates: string[];
   175	  peers: string;

exec
/bin/bash -lc "nl -ba scripts/mycelium-snapshot.ts | sed -n '175,195p'" in /home/enio/egos
 succeeded in 0ms:
   175	  peers: string;
   176	  dispatchable?: boolean;
   177	  note?: string;
   178	}
   179	
   180	interface TriggersJson {
   181	  roster: string[];
   182	  agents: Record<string, TriggerAgent>;
   183	  gates: Record<string, { requester: string; approver: string; hitl: boolean; reason: string; wired: boolean }>;
   184	}
   185	
   186	function buildAgentNodes(): { nodes: ReferenceNode[]; edges: ReferenceEdge[] } {
   187	  const nodes: ReferenceNode[] = [];
   188	  const edges: ReferenceEdge[] = [];
   189	
   190	  const triggersPath = join(REPO_ROOT, 'agents/registry/triggers.json');
   191	  const data = readJsonSafe<TriggersJson>(triggersPath);
   192	  if (!data) return { nodes, edges };
   193	
   194	  for (const agentName of data.roster) {
   195	    const def = data.agents[agentName];

exec
/bin/bash -lc "cat agents/registry/leaf-repos.json; git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 -- scripts/disseminate-scanner.ts | sed -n '1,140p'; sed -n '1,120p' scripts/disseminate-scanner.ts" in /home/enio/egos
 succeeded in 0ms:
{
  "$schema": "./schema.json",
  "_ssot": "agents/registry/leaf-repos.json",
  "_generated": "2026-06-10",
  "_note": "Single canonical source of leaf repos for EGOS kernel dissemination. Read by disseminate-scanner.ts (DISS-001) and disseminate.md §3 push loop. MYCELIUM-006.",
  "leaf_repos": [
    {
      "name": "852",
      "path": "/home/enio/852",
      "description": "852 Inteligência — Canal Anônimo para Policiais Civis de MG",
      "ring": "R2"
    },
    {
      "name": "br-acc",
      "path": "/home/enio/br-acc",
      "description": "EGOS Inteligência — Plataforma Aberta de Cruzamento de Dados Públicos",
      "ring": "R2"
    },
    {
      "name": "carteira-livre",
      "path": "/home/enio/carteira-livre",
      "description": "Carteira Livre — Marketplace de Instrutores de Trânsito Autônomos",
      "ring": "R2"
    },
    {
      "name": "intelink",
      "path": "/home/enio/intelink",
      "description": "Intelink — Sistema de Inteligência PCMG",
      "ring": "R2"
    },
    {
      "name": "egos-lab",
      "path": "/home/enio/egos-lab",
      "description": "egos-lab — Monorepo de Apps e Agents do Ecossistema EGOS",
      "ring": "R2"
    },
    {
      "name": "forja",
      "path": "/home/enio/forja",
      "description": "Forja — Assistente Operacional Corporativo",
      "ring": "R2"
    },
    {
      "name": "smartbuscas",
      "path": "/home/enio/smartbuscas",
      "description": "SmartBuscas — Automação de Extração e Contato",
      "ring": "R2"
    },
    {
      "name": "santiago",
      "path": "/home/enio/santiago",
      "description": "Café Santiago — Delivery App",
      "ring": "R2"
    },
    {
      "name": "commons",
      "path": "/home/enio/commons",
      "description": "EGOS Commons — Pacotes compartilhados (sem git próprio)",
      "ring": "R2"
    },
    {
      "name": "arch",
      "path": "/home/enio/arch",
      "description": "EGOS Arch — Referência de Arquitetura",
      "ring": "R2"
    },
    {
      "name": "egos-self",
      "path": "/home/enio/egos-self",
      "description": "EGOS Self — Repositório de auto-aprendizado e introspection",
      "ring": "R2"
    },
    {
      "name": "INPI",
      "path": "/home/enio/INPI",
      "description": "INPI — Integração com base de dados do INPI (sem git próprio)",
      "ring": "R2"
    },
    {
      "name": "egos-inteligencia",
      "path": "/home/enio/egos-inteligencia",
      "description": "EGOS Inteligência — alias symlink para /home/enio/br-acc (mesmo repo físico)",
      "ring": "R2",
      "alias_of": "br-acc",
      "_note": "egos-inteligencia -> /home/enio/br-acc (symlink descoberto MYCELIUM-006). disseminate-propagator deve usar o path real br-acc, não o alias."
    }
  ]
}
diff --git a/scripts/disseminate-scanner.ts b/scripts/disseminate-scanner.ts
index b6d64bc4..50a293ae 100644
--- a/scripts/disseminate-scanner.ts
+++ b/scripts/disseminate-scanner.ts
@@ -23,6 +23,20 @@ import { join, resolve, dirname } from "node:path";
 const HOME = process.env.HOME ?? "/home/enio";
 const REPO_ROOT = resolve(dirname(import.meta.path), "..");
 
+// ── Canonical leaf repo list — SSOT: agents/registry/leaf-repos.json (MYCELIUM-006) ──
+const LEAF_REPOS_JSON = join(REPO_ROOT, "agents/registry/leaf-repos.json");
+
+interface LeafRepoEntry { name: string; path: string; description: string; ring: string; }
+
+function loadLeafRepos(): string[] {
+  if (!existsSync(LEAF_REPOS_JSON)) {
+    console.error(`[disseminate-scanner] SSOT not found: ${LEAF_REPOS_JSON}`);
+    process.exit(1);
+  }
+  const raw = JSON.parse(readFileSync(LEAF_REPOS_JSON, "utf-8")) as { leaf_repos: LeafRepoEntry[] };
+  return raw.leaf_repos.map((r) => r.path);
+}
+
 const KERNEL_FILES: KernelFile[] = [
   {
     path: join(HOME, ".claude/CLAUDE.md"),
@@ -51,20 +65,8 @@ const KERNEL_FILES: KernelFile[] = [
   },
 ];
 
-const AFFECTED_REPOS: string[] = [
-  join(HOME, "852"),
-  join(HOME, "br-acc"),
-  join(HOME, "carteira-livre"),
-  join(HOME, "intelink"),
-  join(HOME, "egos-lab"),
-  join(HOME, "forja"),
-  join(HOME, "smartbuscas"),
-  join(HOME, "santiago"),
-  join(HOME, "commons"),
-  join(HOME, "arch"),
-  join(HOME, "egos-self"),
-  join(HOME, "INPI"),
-];
+// Load from canonical SSOT instead of hardcoded list
+const AFFECTED_REPOS: string[] = loadLeafRepos();
 
 const MANIFEST_PATH = join(REPO_ROOT, ".egos-disseminate-manifest.json");
 
#!/usr/bin/env bun
/**
 * scripts/disseminate-scanner.ts — EGOS Kernel Change Scanner (DISS-001)
 *
 * Reads git diff on kernel governance files, extracts which sections changed,
 * and generates a propagation manifest for disseminate-propagator.ts.
 *
 * Usage:
 *   bun scripts/disseminate-scanner.ts [--dry] [--since <commit>]
 *
 * Output:
 *   .egos-disseminate-manifest.json  (or stdout if --stdout)
 *   Exit 0: no changes needed
 *   Exit 1: changes found (manifest written)
 */

import { execSync } from "node:child_process";
import { existsSync, writeFileSync, readFileSync } from "node:fs";
import { join, resolve, dirname } from "node:path";

// ── Config ──────────────────────────────────────────────────────────────────

const HOME = process.env.HOME ?? "/home/enio";
const REPO_ROOT = resolve(dirname(import.meta.path), "..");

// ── Canonical leaf repo list — SSOT: agents/registry/leaf-repos.json (MYCELIUM-006) ──
const LEAF_REPOS_JSON = join(REPO_ROOT, "agents/registry/leaf-repos.json");

interface LeafRepoEntry { name: string; path: string; description: string; ring: string; }

function loadLeafRepos(): string[] {
  if (!existsSync(LEAF_REPOS_JSON)) {
    console.error(`[disseminate-scanner] SSOT not found: ${LEAF_REPOS_JSON}`);
    process.exit(1);
  }
  const raw = JSON.parse(readFileSync(LEAF_REPOS_JSON, "utf-8")) as { leaf_repos: LeafRepoEntry[] };
  return raw.leaf_repos.map((r) => r.path);
}

const KERNEL_FILES: KernelFile[] = [
  {
    path: join(HOME, ".claude/CLAUDE.md"),
    label: "global-claude-md",
    description: "Global user CLAUDE.md (all projects)",
    // Note: this file lives outside the git repo — we track it separately
    tracked_in_repo: false,
  },
  {
    path: join(REPO_ROOT, ".windsurfrules"),
    label: "windsurfrules",
    description: "Project governance rules (.windsurfrules)",
    tracked_in_repo: true,
  },
  {
    path: join(REPO_ROOT, "CLAUDE.md"),
    label: "project-claude-md",
    description: "Project CLAUDE.md adapter",
    tracked_in_repo: true,
  },
  {
    path: join(REPO_ROOT, "docs/CAPABILITY_REGISTRY.md"),
    label: "capability-registry",
    description: "Capability registry",
    tracked_in_repo: true,
  },
];

// Load from canonical SSOT instead of hardcoded list
const AFFECTED_REPOS: string[] = loadLeafRepos();

const MANIFEST_PATH = join(REPO_ROOT, ".egos-disseminate-manifest.json");

// ── Types ────────────────────────────────────────────────────────────────────

interface KernelFile {
  path: string;
  label: string;
  description: string;
  tracked_in_repo: boolean;
}

interface ChangedRule {
  file: string;
  label: string;
  section: string;
  change_type: "added" | "modified" | "removed";
  diff_lines: number;
}

interface DisseminateManifest {
  date: string;
  commit: string;
  since_commit: string;
  changed_rules: ChangedRule[];
  affected_repos: string[];
  existing_repos: string[];
  propagation_needed: boolean;
  generated_at: string;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function run(cmd: string, cwd?: string): string {
  try {
    return execSync(cmd, {
      cwd: cwd ?? REPO_ROOT,
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"],
    }).trim();
  } catch {
    return "";
  }
}

function extractChangedSections(diff: string, filePath: string): ChangedRule[] {
  const rules: ChangedRule[] = [];
  if (!diff) return rules;

  const lines = diff.split("\n");
  let currentSection = "(preamble)";

exec
/bin/bash -lc "sed -n '120,300p' scripts/disseminate-scanner.ts" in /home/enio/egos
 succeeded in 0ms:
  let currentSection = "(preamble)";
  let addedLines = 0;
  let removedLines = 0;

  for (const line of lines) {
    // Detect markdown headings in diff context
    if (line.match(/^[+ ]#+\s+/)) {
      // Save previous section if it had changes
      if (addedLines > 0 || removedLines > 0) {
        rules.push({
          file: filePath,
          label: filePath.split("/").pop() ?? filePath,
          section: currentSection,
          change_type: addedLines > 0 && removedLines > 0 ? "modified" : addedLines > 0 ? "added" : "removed",
          diff_lines: addedLines + removedLines,
        });
        addedLines = 0;
        removedLines = 0;
      }
      // Extract the heading text
      currentSection = line.replace(/^[+ ]/, "").trim();
    } else if (line.startsWith("+") && !line.startsWith("+++")) {
      addedLines++;
    } else if (line.startsWith("-") && !line.startsWith("---")) {
      removedLines++;
    }
  }

  // Flush last section
  if (addedLines > 0 || removedLines > 0) {
    rules.push({
      file: filePath,
      label: filePath.split("/").pop() ?? filePath,
      section: currentSection,
      change_type: addedLines > 0 && removedLines > 0 ? "modified" : addedLines > 0 ? "added" : "removed",
      diff_lines: addedLines + removedLines,
    });
  }

  return rules;
}

function getFileDiff(filePath: string, sinceCommit: string, isTrackedInRepo: boolean): string {
  if (!existsSync(filePath)) return "";

  if (isTrackedInRepo) {
    // Standard git diff for tracked files
    return run(`git diff ${sinceCommit} -- "${filePath}"`);
  } else {
    // For global CLAUDE.md outside the repo: compare to git-stashed version
    // Check if we have a cached version to compare against
    const cacheFile = join(REPO_ROOT, ".egos-kernel-cache", "global-claude-md.md");
    if (!existsSync(cacheFile)) {
      // First run: no cache exists, treat as "added"
      return `+++ (new baseline — no previous cache)`;
    }
    const cached = readFileSync(cacheFile, "utf-8");
    const current = readFileSync(filePath, "utf-8");
    if (cached === current) return "";
    // Simple line-diff approximation
    const cachedLines = new Set(cached.split("\n"));
    const currentLines = current.split("\n");
    const added = currentLines.filter((l) => !cachedLines.has(l)).length;
    return added > 0 ? `+++ (${added} lines changed vs cache)` : "";
  }
}

function updateGlobalClaudeCache(filePath: string): void {
  const cacheDir = join(REPO_ROOT, ".egos-kernel-cache");
  const cacheFile = join(cacheDir, "global-claude-md.md");
  run(`mkdir -p "${cacheDir}"`);
  try {
    const content = readFileSync(filePath, "utf-8");
    writeFileSync(cacheFile, content);
  } catch {
    // Non-fatal
  }
}

// ── Main ─────────────────────────────────────────────────────────────────────

const args = process.argv.slice(2);
const isDry = args.includes("--dry");
const toStdout = args.includes("--stdout");
const sinceIdx = args.indexOf("--since");
const sinceCommit = sinceIdx >= 0 ? (args[sinceIdx + 1] ?? "HEAD~1") : "HEAD~1";

const currentCommit = run("git rev-parse --short HEAD");
const date = new Date().toISOString().split("T")[0];

console.log(`[disseminate-scanner] commit=${currentCommit} since=${sinceCommit} date=${date}`);

// Collect changed rules across all kernel files
const allChangedRules: ChangedRule[] = [];

for (const kf of KERNEL_FILES) {
  if (!existsSync(kf.path)) {
    console.warn(`  ⚠️  Kernel file not found: ${kf.path}`);
    continue;
  }

  const diff = getFileDiff(kf.path, sinceCommit, kf.tracked_in_repo);
  if (!diff) {
    console.log(`  ✅ ${kf.label}: no changes`);
    continue;
  }

  const rules = extractChangedSections(diff, kf.path);
  if (rules.length === 0) {
    console.log(`  ✅ ${kf.label}: diff exists but no section headers detected`);
    continue;
  }

  console.log(`  🔄 ${kf.label}: ${rules.length} section(s) changed`);
  for (const r of rules) {
    console.log(`     - ${r.section} (${r.change_type}, +${r.diff_lines} lines)`);
  }
  allChangedRules.push(...rules);
}

// Filter affected repos (only existing ones)
const existingRepos = AFFECTED_REPOS.filter((r) => existsSync(r));
const missingRepos = AFFECTED_REPOS.filter((r) => !existsSync(r));

if (missingRepos.length > 0) {
  console.log(`  ℹ️  Missing repos (skipped): ${missingRepos.map((r) => r.split("/").pop()).join(", ")}`);
}

const propagationNeeded = allChangedRules.length > 0;

const manifest: DisseminateManifest = {
  date,
  commit: currentCommit,
  since_commit: sinceCommit,
  changed_rules: allChangedRules,
  affected_repos: AFFECTED_REPOS,
  existing_repos: existingRepos,
  propagation_needed: propagationNeeded,
  generated_at: new Date().toISOString(),
};

if (propagationNeeded) {
  console.log(`\n🔴 Propagation needed: ${allChangedRules.length} rule section(s) changed across ${existingRepos.length} repos`);
} else {
  console.log(`\n✅ No propagation needed — kernel files unchanged since ${sinceCommit}`);
}

if (isDry) {
  console.log("\n[DRY-RUN] Manifest (not written):");
  console.log(JSON.stringify(manifest, null, 2));
  process.exit(propagationNeeded ? 1 : 0);
}

if (toStdout) {
  console.log(JSON.stringify(manifest, null, 2));
} else {
  writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2));
  console.log(`\n📄 Manifest written: ${MANIFEST_PATH}`);

  // Update cache for global CLAUDE.md (untracked file)
  const globalClaude = KERNEL_FILES.find((f) => f.label === "global-claude-md");
  if (globalClaude && existsSync(globalClaude.path)) {
    updateGlobalClaudeCache(globalClaude.path);
  }
}

process.exit(propagationNeeded ? 1 : 0);

exec
/bin/bash -lc 'git diff HEAD~1 -- "/home/enio/egos/CLAUDE.md" >/tmp/gitabs.out 2>/tmp/gitabs.err; echo code=$?; cat /tmp/gitabs.err | head -3' in /home/enio/egos
 succeeded in 0ms:
code=0

exec
/bin/bash -lc "python - <<'PY'
import json,re
p='apps/egos-landing/public/mycelium-snapshot.json'
s=open(p).read()
print('/home occurrences', s.count('/home/'))
print('policia', 'policia' in s, 'carteira', 'carteira-livre' in s, '852', 'repo:852' in s)
for term in ['/home/','policia','carteira-livre','br-acc','forja','intelink','smartbuscas','santiago','INPI']:
 print(term, s.find(term))
PY" in /home/enio/egos
 succeeded in 0ms:
/home occurrences 0
policia False carteira False 852 False
/home/ -1
policia -1
carteira-livre -1
br-acc -1
forja 1284
intelink -1
smartbuscas -1
santiago -1
INPI -1

exec
/bin/bash -lc 'bun run build' in /home/enio/egos/apps/egos-landing
 succeeded in 6192ms:
$ bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && bun run ../../scripts/mycelium-snapshot.ts --exec --public --out ./public/mycelium-snapshot.json && tsc -b && vite build
[generate-metaprompt] OK — src/data/metaprompt-source.ts gerado.
📡 Buscando artigos no Supabase para gerar o RSS feed...
✅ RSS feed gerado com sucesso em public/timeline/rss!

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
    "note": "last_commit: 2026-06-10"
  }
]
[--exec] Snapshot escrito em:
  /home/enio/.egos/mycelium-snapshot.json
  /tmp/egos-mycelium-snapshot.json
  /home/enio/egos/apps/egos-landing/public/mycelium-snapshot.json (--out --public)
vite v8.0.16 building client environment for production...
[2Ktransforming...✓ 66 modules transformed.
rendering chunks...
computing gzip size...
dist/index.html                   1.06 kB │ gzip:   0.58 kB
dist/assets/index-B66jEp7s.css    7.12 kB │ gzip:   2.12 kB
dist/assets/index-DC1pComI.js   472.67 kB │ gzip: 132.15 kB

✓ built in 235ms

exec
/bin/bash -lc "grep -R \"bridgeBusToRedis\\|subscribeViaRedis\" -n --exclude-dir=.git --exclude='*.json' . | head -50" in /home/enio/egos
exec
/bin/bash -lc "git grep -n \"bridgeBusToRedis\\|subscribeViaRedis\" -- ':"'!apps/egos-landing/public/mycelium-snapshot.json'"'" in /home/enio/egos
 succeeded in 205ms:
scripts/test-mycelium-bus.ts:33:  subscribeViaRedis,
scripts/test-mycelium-bus.ts:35:import { bridgeBusToRedis } from '../agents/subscribers/bus-redis-bridge';
scripts/test-mycelium-bus.ts:181:  const closeFn = await subscribeViaRedis();
scripts/test-mycelium-bus.ts:221:  const handle = await bridgeBusToRedis(bus);

exec
/bin/bash -lc 'git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 -- TASKS.md docs/governance/MYCELIUM_BUS_DECISION.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 2ce2736d..13a3ac4a 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -31,8 +31,8 @@
 > **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
 
 **🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
-- [ ] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`.
-- [ ] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo).
+- [x] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`. ✅ 2026-06-10
+- [x] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo). ✅ 2026-06-10
 
 **🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
 - [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
@@ -42,8 +42,8 @@
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
 - [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
-- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
-- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio).
+- [x] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001. ✅ 2026-06-10
+- [x] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). ✅ 2026-06-10
 
 **🧩 MCP CUSTOMIZADO = FEATURE PRINCIPAL DO EGOS (corte Enio 2026-06-10):**
 
@@ -88,9 +88,9 @@
 
 **🏛️ ENFORCEMENT SEMÂNTICO — plano de 3 camadas (Opus arquiteto 2026-06-10, SSOT `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`):**
 > Diagnóstico CONFIRMADO machine-wide: a regra "não decidir prematuro" não prevalece por **falta de DESCOBERTA** (vive em TASKS.md, não na constituição auto-carregada), não por falta de enforcement. 7 versões da mesma regra existem = a proliferação é o sintoma. LLM no pre-commit JÁ funciona (`ssot-router.ts:181` chama gemini-2.0-flash via Google AI Studio). Mas pre-commit é camada errada: o tempo já foi gasto na inferência. Ordem de alavancagem: Camada 1 > Camada 3 > Camada 2.
-- [ ] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão.
+- [x] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão. ✅ 2026-06-10
 - [ ] **RULE-SEMANTIC-L3-MCP-001** [P1] `prime`+`forja` `gated:MCP-EASY-INSTALL-001` — **Camada 3 (CURA PROFUNDA):** o playbook de diagnóstico + fluxos de referência viram tools/metaprompts no MCP EGOS → conhecimento do fluxo PRESENTE no momento da decisão (o que o Enio nomeou: "se tenho o fluxo, não perco esse tempo"). Elimina a causa-raiz upstream. Liga MCP-EASY-INSTALL-001.
-- [ ] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro.
+- [x] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro. ✅ 2026-06-10
 
 ## 🕸️ MYCELIUM v1 — interconexão REAL (corte Enio 2026-06-10, P0 — 1 ano de tentativa, 3 grafos divergentes, bus 7-pub/0-sub)
 
@@ -98,25 +98,25 @@
 > **Regra dura:** nenhuma task FIND nova neste programa enquanto fila RESOLVE P0+P1 > 5 itens. "Encontrar é barato, fechar é o produto."
 > **MYCELIUM-001 ✅ FECHADA** (archive L3846): snapshot REAL em `~/.egos/mycelium-snapshot.json` — 103 nós/129 arestas, 0 órfãos, gerado por `scripts/mycelium-snapshot.ts`.
 
-- [ ] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001`
+- [x] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×3=27
   AC: zero nodes/edges hardcoded em MyceliumPage.tsx; zero em egos-lab/mycelium-stats.ts; ambos lêem o snapshot
   Proof: screenshot MyceliumPage renderizando dados reais + `curl /api/mycelium/stats | jq '.nodeCount'`
   **MyceliumPage.tsx + egos-lab/mycelium-stats.ts** passam a LER o snapshot → mata 3 grafos divergentes
 
-- [ ] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001`
+- [x] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: blackboard lista estado de ≥10 repos (hoje só egos); colisão como d988385b não passa despercebida
   Proof: `cat ~/.egos/coordination-blackboard.json | jq '.repos | length'`
   **coordination-watcher machine-wide:** varre todos os repos do snapshot (hoje só egos; janelas cegas entre si — colisão d988385b é a prova)
 
-- [ ] **MYCELIUM-004** [P1] `forja` `gated:none`
+- [x] **MYCELIUM-004** [P1] `forja` `gated:none` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 2×3×3=18
   AC: evento `architecture.ssot_violation` publicado no bus gera flag visível em `~/.egos/sentinela-flags.jsonl`
   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
   **1º subscriber real no bus:** Sentinela assina `architecture.ssot_violation` → flag
 
-- [ ] **MYCELIUM-005** [P1] `prime` `gated:none`
+- [x] **MYCELIUM-005** [P1] `prime` `gated:none` ✅ 2026-06-10
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: registro formal da decisão em `docs/governance/MYCELIUM_BUS_DECISION.md` com Banda+premortem feitos
   Proof: arquivo criado com seção "Decisão Enio" preenchida
diff --git a/docs/governance/MYCELIUM_BUS_DECISION.md b/docs/governance/MYCELIUM_BUS_DECISION.md
new file mode 100644
index 00000000..d443416f
--- /dev/null
+++ b/docs/governance/MYCELIUM_BUS_DECISION.md
@@ -0,0 +1,56 @@
+# MYCELIUM-005 — Decisão de Substrato do Event Bus (cross-process)
+
+> **Status:** AGUARDA CORTE ENIO · **Preparado:** 2026-06-10 (Fable 5, papel arquiteto) · AI⟷AI doc
+> **Task:** MYCELIUM-005 [P1] Red Zone — substrato de eventos cross-process
+> **Gatilho:** MYCELIUM-004 provou o mecanismo subscriber→flag, mas CONFIRMOU gap: `getGlobalBus()` é singleton in-process (`agents/runtime/event-bus.ts:278-289`). Publishers (`ssot-auditor.ts:2332`, `capability-drift-checker.ts:167`, `chatbot-compliance-checker.ts:40`) rodam no processo do runner; Sentinela roda em processo próprio. Sem ponte, o bus continua 7-pub/0-sub na prática.
+
+---
+
+## Fatos verificados (CONFIRMADO nesta sessão)
+
+| Fato | Evidência |
+|---|---|
+| Bus é EventEmitter singleton por processo | `event-bus.ts:278-289` (FROZEN — não muda) |
+| Redis JÁ RODA na máquina | `pgrep redis-server` ativo; `/usr/bin/redis-server` instalado |
+| Bridge Redis JÁ EXISTE no shared | `packages/shared/src/mycelium/redis-bridge.ts` (EGOS-089): RESP2 via `net` nativo, ZERO dependência de client, graceful degradation se Redis off |
+| Subscriber Sentinela pronto | `agents/subscribers/sentinela-bus-subscriber.ts` (MYCELIUM-004, commit nesta sessão) |
+| Payloads contêm metadados sensíveis | eventos de ssot_violation citam paths/repos da máquina (inclui repos de investigação) |
+
+## Opções
+
+### A — Redis pub/sub local (RECOMENDADA pelo arquiteto)
+Runner publica no bus in-process → hook no bus re-publica via redis-bridge (canal `egos:mycelium:events`) → Sentinela assina o canal.
+- **Custo:** ~0 infra (Redis já roda; bridge já escrita). Wiring: ~30-60 linhas fora de frozen zones.
+- **Soberania:** localhost only — dado nunca sai da máquina (R-SEC-002 ✅).
+- **Falha:** graceful — Redis off = log, bus in-process continua (liveness preservada).
+
+### B — JSONL append + tail-poll
+Publisher appenda `~/.egos/bus-events.jsonl`; Sentinela faz tail-poll.
+- **Custo:** zero infra, ~40 linhas. **Contra:** polling (latência), rotação de arquivo, lock em writes concorrentes, sem semântica pub/sub (cada novo consumer reimplementa offset).
+
+### C — Supabase Realtime
+- **Contra decisivo:** eventos de coordenação local iriam à NUVEM com paths/nomes de repos de investigação → conflita com R-SEC-002 (dado soberano nunca sai da máquina). Exigiria sanitização por evento = complexidade + risco. Só faria sentido para eventos VPS↔local, que não é o caso de uso âncora.
+
+### D — Unix domain socket
+- **Contra:** reimplementa broker (multi-subscriber, reconnect, buffering) que o Redis já dá de graça.
+
+## Banda condensada
+- **Crítico:** "A opção A adiciona dependência runtime de um daemon. Quem garante que o Redis sobrevive a reboot?" → mitigação: graceful degradation já no bridge + heartbeat check no `/start` (1 linha).
+- **Questionador:** "O caso de uso real existe? 7 publishers e 1 subscriber sintético." → o subscriber Sentinela→flag é real e commitado; o primeiro fluxo de valor é ssot_violation visível no `/start`. Se em 30 dias nenhuma flag for consumida, reavaliar (decay).
+- **Apoiador:** o caminho A reusa 2 artefatos já pagos (Redis instalado + EGOS-089) — é o raro caso de interconexão a custo marginal ~zero.
+- **Maestro:** A, com fail-visible e sem tocar frozen zones. B como fallback se Enio vetar daemon.
+
+## Premortem (se A falhar em 90 dias, por quê?)
+1. Redis morre silenciosamente e ninguém nota → mitigar: check no `/start` + heartbeat RULE-HARDEN-CRON-HEARTBEAT-001.
+2. Eventos demais (ruído) → flags JSONL crescem sem leitor → mitigar: só assinar `architecture.ssot_violation` no v1; expandir por demanda.
+3. Dois processos publicam o mesmo evento (duplicata) → mitigar: eventId já existe (UUID no envelope do bus).
+4. Esquecer de ligar o publisher do lado do runner → o gap atual persiste mascarado → AC do wiring DEVE incluir smoke end-to-end 2 processos reais.
+
+## Decisão Enio
+- [x] **A — Redis local** ← CORTE ENIO 2026-06-10 (nesta sessão, via AskUserQuestion)
+- [ ] B — JSONL tail
+- [ ] C — Supabase Realtime
+- [ ] D — Unix socket
+- [ ] Outro / adiar
+
+**Após corte:** task de wiring (1 forja, AC = smoke 2-processos: runner publica → Sentinela (processo separado) flagga em `~/.egos/sentinela-flags.jsonl`).

 exited 2 in 90619ms:
./TASKS.md:116:  Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.claude/worktrees/agent-ac1433679f0d59800/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.claude/worktrees/agent-ac1433679f0d59800/.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.claude/worktrees/agent-ac1433679f0d59800/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.claude/worktrees/agent-ac1433679f0d59800/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.claude/worktrees/agent-aebb6fcd2a26def5a/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.claude/worktrees/agent-ace69cd041317702c/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.claude/worktrees/agent-ace69cd041317702c/.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.claude/worktrees/agent-ace69cd041317702c/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.claude/worktrees/agent-ace69cd041317702c/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.claude/worktrees/agent-acbc4f85668ef36eb/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.claude/worktrees/agent-a9a0bc5c105615ef6/.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}
./agents/.logs/events.jsonl:1785:{"id":"198c3544-0ebb-416e-8163-323c0be810b4","topic":"architecture.ssot_violation","source":"test-mycelium-bus","correlationId":"test-mycelium-004-1781087667094","timestamp":"2026-06-10T10:34:27.094Z","payload":{"file":"TASKS.md","rule":"SSOT-MAP-001","expected":"tasks only in TASKS.md","actual":"duplicate task entry detected in docs/jobs/","synthetic":true},"metadata":{"synthetic":true,"test":"MYCELIUM-004"}}
./agents/.logs/events.jsonl:1786:{"id":"1fccd75d-aa1b-492e-90bb-6fb3645fea0b","topic":"architecture.ssot_violation","source":"test-mycelium-bus","correlationId":"test-mycelium-004-1781088652493","timestamp":"2026-06-10T10:50:52.493Z","payload":{"file":"TASKS.md","rule":"SSOT-MAP-001","expected":"tasks only in TASKS.md","actual":"duplicate task entry detected in docs/jobs/","synthetic":true},"metadata":{"synthetic":true,"test":"MYCELIUM-004"}}
./agents/.logs/events.jsonl:1788:{"id":"a6b3681c-1ffb-42b6-bb56-5ee4d56f9fe1","topic":"architecture.ssot_violation","source":"test-mycelium-bus","correlationId":"test-mycelium-004-1781089974444","timestamp":"2026-06-10T11:12:54.444Z","payload":{"file":"TASKS.md","rule":"SSOT-MAP-001","expected":"tasks only in TASKS.md","actual":"duplicate task entry detected in docs/jobs/","synthetic":true},"metadata":{"synthetic":true,"test":"MYCELIUM-004"}}
./scripts/test-mycelium-bus.ts:3: * test-mycelium-bus.ts — Golden cases MYCELIUM-004 + MYCELIUM-005
./scripts/test-mycelium-bus.ts:15: *   bun scripts/test-mycelium-bus.ts
./scripts/test-mycelium-bus.ts:16: *   bun scripts/test-mycelium-bus.ts --cross-process
./scripts/test-mycelium-bus.ts:19: *   bun scripts/test-mycelium-bus.ts --cross-process-publisher <correlationId>
./scripts/test-mycelium-bus.ts:20: *   bun scripts/test-mycelium-bus.ts --cross-process-subscriber <correlationId>
./scripts/test-mycelium-bus.ts:46:  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./scripts/test-mycelium-bus.ts:51:  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./scripts/test-mycelium-bus.ts:68:  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./scripts/test-mycelium-bus.ts:69:  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./scripts/test-mycelium-bus.ts:80:  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./scripts/test-mycelium-bus.ts:84:  console.log('[test-mycelium-bus] subscriber registered on global bus');
./scripts/test-mycelium-bus.ts:97:  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./scripts/test-mgrep: ./apps/_archived/vendas-portal/node_modules/react: No such file or directory
ycelium-bus.ts:101:    'test-mycelium-bus',
./scripts/test-mycelium-bus.ts:106:  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./scripts/test-mycelium-bus.ts:154:  console.log('[test-mycelium-bus] subscriber unregistered');
./scripts/test-mycelium-bus.ts:157:  console.log('\n[test-mycelium-bus] last flag written:');
./scripts/test-mycelium-bus.ts:161:  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./scripts/test-mycelium-bus.ts:168:  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./scripts/test-mycelium-bus.ts:256:  console.log('[test-mycelium-bus] MYCELIUM-005 — cross-process smoke test');
./scripts/test-mycelium-bus.ts:259:  const scriptPath = resolve(import.meta.dir, 'test-mycelium-bus.ts');
./scripts/test-mycelium-bus.ts:261:  console.log(`[test-mycelium-bus] correlationId=${correlationId}`);
./scripts/test-mycelium-bus.ts:262:  console.log(`[test-mycelium-bus] spawning 2 processos reais...`);
./scripts/test-mycelium-bus.ts:268:  console.log(`[test-mycelium-bus] flags antes: ${flagsBefore}`);
./scripts/test-mycelium-bus.ts:316:        console.error(`[test-mycelium-bus] TIMEOUT aguardando ${name} (PID ${p.pid})`);
./scripts/test-mycelium-bus.ts:331:  console.log(`\n[test-mycelium-bus] publisher PID=${pubPid} exit=${pubExit}`);
./scripts/test-mycelium-bus.ts:332:  console.log(`[test-mycelium-bus] subscriber PID=${subPid} exit=${subExit}`);
./scripts/test-mycelium-bus.ts:378:  console.log('\n[test-mycelium-bus] última flag (source=mycelium-redis):');
./scripts/test-mycelium-bus.ts:381:  console.log('\n[test-mycelium-bus] AC MYCELIUM-005: SATISFIED');
./scripts/test-mycelium-bus.ts:405:    console.error('[test-mycelium-bus] fatal cross-process:', msg);
./scripts/test-mycelium-bus.ts:411:    console.error('[test-mycelium-bus] fatal:', msg);
grep: ./apps/_archived/vendas-portal/node_modules/next: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@supabase/ssr: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/typescript: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/react: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/next: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@tailwindcss/postcss: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/typescript: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/react: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/next: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@egosbr/guard-brasil: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@privy-io/react-auth: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@tailwindcss/postcss: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/typescript: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/react: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/vite: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/@vitejs/plugin-react: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/.bin/vite: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/react: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint-plugin-react-hooks: No such file or directory
grep: ./apps/_archived/commons/node_modules/react-router-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/lucide-react: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/@vitejs/plugin-react: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/autoprefixer: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/commons/node_modules/postcss: No such file or directory
grep: ./apps/_archived/commons/node_modules/autoprefixer: No such file or directory
grep: ./apps/_archived/commons/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/commons/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/commons/node_modules/@eslint/js: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint-plugin-react-refresh: No such file or directory
grep: ./apps/_archived/commons/node_modules/typescript-eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/@tailwindcss/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/typescript: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/globals: No such file or directory
grep: ./apps/_archived/commons/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/hono: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/@types/bun: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/react: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/next: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/hono: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@types/bun: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/bun-types: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/hono: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/@egos/auth: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/typescript: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/zod: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/hono: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/typescript: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/@types/bun: No such file or directory
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:33: scripts/test-mycelium-bus.ts                       |  171 ++
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:80:   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:101:+ *   - Teste in-process (scripts/test-mycelium-bus.ts) — prova o mecanismo
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2812:diff --git a/scripts/test-mycelium-bus.ts b/scripts/test-mycelium-bus.ts
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2816:+++ b/scripts/test-mycelium-bus.ts
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2820:+ * test-mycelium-bus.ts — Golden case for MYCELIUM-004
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2838:+ *   bun scripts/test-mycelium-bus.ts
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2859:+  console.error(`[test-mycelium-bus] FAIL: ${msg}`);
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2864:+  console.log(`[test-mycelium-bus] PASS: ${msg}`);
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2881:+  console.log('[test-mycelium-bus] MYCELIUM-004 — in-process subscriber proof');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2882:+  console.log('[test-mycelium-bus] Flags file:', SENTINEL_FLAGS);
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2893:+  console.log(`[test-mycelium-bus] flags before: ${flagsBefore}`);
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2897:+  console.log('[test-mycelium-bus] subscriber registered on global bus');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2910:+  console.log('[test-mycelium-bus] emitting architecture.ssot_violation (synthetic)...');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2914:+    'test-mycelium-bus',
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2919:+  console.log(`[test-mycelium-bus] event emitted: id=${emittedEvent.id}`);
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2967:+  console.log('[test-mycelium-bus] subscriber unregistered');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2970:+  console.log('\n[test-mycelium-bus] last flag written:');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2974:+  console.log('\n[test-mycelium-bus] NOTA DE TOPOLOGIA:');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2981:+  console.log('\n[test-mycelium-bus] AC MYCELIUM-004: SATISFIED');
./.egos/codex-reviews/2026-06-10-local-review-522592f6.md:2986:+  console.error('[test-mycelium-bus] fatal:', msg);
./.egos/coordination-intent.jsonl:2:{"ts":"2026-06-10T00:00:00.000Z","agent":"forja","window":"main:egos","intent":"write agents/subscribers/sentinela-bus-subscriber.ts + scripts/test-mycelium-bus.ts + modify scripts/agent-sentinela.ts","task":"MYCELIUM-004"}
./.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:4:{"ts":"2026-06-10T10:34:15.000Z","step":4,"action":"create scripts/test-mycelium-bus.ts","result":"golden case: emit+subscribe in-process, verify flag written"}
./.egos/agent-runs/forja-mycelium-004-1781087682.jsonl:6:{"ts":"2026-06-10T10:34:27.000Z","step":6,"action":"bun scripts/test-mycelium-bus.ts","result":"PASS — eventId=198c3544-0ebb-416e-8163-323c0be810b4 flag written source=mycelium-bus"}

exec
/bin/bash -lc "python - <<'PY'
import json
p='apps/egos-landing/public/mycelium-snapshot.json'
data=json.load(open(p)); ids={n['id'] for n in data['nodes']}
for i in ['integration:mcp-egos-security','integration:mcp-egos-browser-automation','policy:gate-pii-code','ws:egos-kernel']:
 print(i, i in ids)
print([n['id'] for n in data['nodes'] if 'security' in n['id'] or 'browser' in n['id'] or 'pii' in n['id']][:20])
PY" in /home/enio/egos
 succeeded in 0ms:
integration:mcp-egos-security True
integration:mcp-egos-browser-automation True
policy:gate-pii-code True
ws:egos-kernel True
['policy:gate-pii-code', 'integration:mcp-egos-security', 'integration:mcp-egos-browser-automation', 'endpoint:mcp-security', 'endpoint:mcp-browser-automation']

exec
/bin/bash -lc 'bun run typecheck' in /home/enio/egos
 succeeded in 13640ms:
exec
/bin/bash -lc "git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 -- apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml CLAUDE.md docs/governance/MODEL_DELEGATION_POLICY.md | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/CLAUDE.md b/CLAUDE.md
index c71ea576..ee6cb208 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -16,7 +16,7 @@
 
 **O que os comandos fazem (enriquecem, não "ativam" a identidade):** `/start` = carrega contexto profundo da sessão (regras, memória, handoff, estado). `/opus` = aprofunda (Banda/Council/Fibonacci). `/end` = consolida e passa adiante. **Sem eles você ainda é EGOS — só com menos contexto carregado.** Se a conversa for não-trivial e você não rodou `/start`, ofereça rodá-lo para carregar o contexto completo.
 
-> Mapa de regras: `docs/governance/RULE_SETS_INDEX.md` · Constituição: `AGENTS.md` (R0-R8) + `~/.claude/CLAUDE.md` (T0-T4) + `.guarani/RULES_INDEX.md`. Em conflito: `.guarani` prevalece.
+> Mapa de regras: `docs/governance/RULE_SETS_INDEX.md` · Constituição: `AGENTS.md` (R0-R8) + `~/.claude/CLAUDE.md` (T0-T4) + `.guarani/RULES_INDEX.md`. **Cláusula-árbitro:** regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
 ---
 
@@ -121,6 +121,30 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 
 ---
 
+## R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente
+
+> Consolida R-DIAG-002..006 + R-ARCH-CLIENT-VENDOR. Corte Enio 2026-06-10. SSOT: `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
+
+Antes de especificar QUALQUER decisão que pertence ao cliente/humano, PARE e use placeholder.
+Decisões do cliente (NUNCA inferir): fornecedor de pagamento, gateway, banco, provider de OCR/IA,
+canal (WhatsApp/Telegram), preço, prazo, custo de infra, escopo, stack específica, ROI, % automação.
+
+**GATILHOS (prestes a escrever qualquer um destes SEM o cliente ter confirmado → PARE):**
+- nome de vendor concreto (Mercado Pago, OpenPix, EFÍ Bank, Twilio, AWS, Stripe…)
+- valor em R$ de preço/custo/economia para o cliente
+- prazo ("em X dias", "2 semanas", timeline de entrega)
+- "vamos usar [tecnologia]" numa spec de cliente
+- decisão técnica inferida apresentada como fato ("o CPF nunca vai ao LLM")
+- comparar 2 fornecedores e escolher um pelo cliente
+
+**EM VEZ DISSO:** use `{PAYMENT_PROVIDER}`, `{OCR_PROVIDER}`, `{WA_CHANNEL}`, `{PRICE}`, `{TIMELINE}`.
+Apresente o FLUXO arquitetural com o trade-off dos dois caminhos; o cliente escolhe no diagnóstico.
+
+**POR QUÊ:** decidir vendor sem conhecer o processo do cliente = tempo gasto numa decisão que não é nossa.
+O conhecimento do fluxo vem do diagnóstico (R-DIAG-001), não da inferência.
+
+---
+
 ## R-DIAG-001 — Diagnóstico Antes de Demo [T1 — Enio 2026-06-09]
 
 > Origem: tentação de "mostrar tudo funcionando" = desconfiança no próprio valor. Diagnóstico bem feito IS a prova de valor.
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index adc532e6..35245a85 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index adc532e6..35245a85 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/governance/MODEL_DELEGATION_POLICY.md b/docs/governance/MODEL_DELEGATION_POLICY.md
index 7bd5d7c4..d6ffab0f 100644
--- a/docs/governance/MODEL_DELEGATION_POLICY.md
+++ b/docs/governance/MODEL_DELEGATION_POLICY.md
@@ -9,28 +9,47 @@
 
 ## 🎯 Princípio
 
-**Opus é caro. Sonnet é o padrão. Haiku é mecânico.**
+**O ARQUITETO desenha. O EXECUTOR-COMPLEXO executa o pesado. O EXECUTOR-PADRÃO executa o padrão. O MECÂNICO faz o repetitivo.**
 
-Toda task entra primeiro pelo filtro: *"isso precisa de inteligência Opus, ou Sonnet/Haiku resolve?"*
+| Papel | Modelo atual | Nota |
+|---|---|---|
+| ARQUITETO | Claude Fable 5 | janela grátis até 2026-06-22; fallback: Opus assume papel |
+| EXECUTOR-COMPLEXO | Claude Opus 4.7 | — |
+| EXECUTOR-PADRÃO | Claude Sonnet 4.6 | padrão de sessão (TOKEN-START-SONNET-001) |
+| MECÂNICO | Claude Haiku 4.5 | — |
 
-Quando entrar no Claude Code, **o modelo padrão da janela principal deve ser Sonnet 4.6**, exceto quando o usuário explicitamente subir para Opus ou quando a task casa com os critérios de Opus abaixo.
+> Esta tabela é o ÚNICO lugar onde nomes de modelo aparecem. Critérios e enforcement referenciam PAPÉIS. Quando o modelo mudar, só esta tabela muda.
 
-Quando estiver em Opus, **delegar agressivamente** para Sonnet/Haiku via `Agent` tool com `model: "sonnet"` ou `"haiku"`. Opus orquestra, Sonnet executa, Haiku faz o mecânico.
+Toda task entra pelo filtro de 4 papéis: *"isso precisa do ARQUITETO, EXECUTOR-COMPLEXO, ou EXECUTOR-PADRÃO/MECÂNICO resolve?"*
+
+Quando entrar no Claude Code, **o modelo padrão da janela principal deve ser EXECUTOR-PADRÃO (Sonnet 4.6)** [TOKEN-START-SONNET-001], exceto quando a task casa com critérios ARQUITETO ou EXECUTOR-COMPLEXO abaixo.
+
+ARQUITETO orquestra e define, EXECUTOR-COMPLEXO executa o pesado, EXECUTOR-PADRÃO executa o padrão, MECÂNICO faz o repetitivo. ARQUITETO **nunca implementa/commita** — apenas desenha arquitetura e distribui. Se ARQUITETO indisponível, EXECUTOR-COMPLEXO assume o papel.
 
 ---
 
-## 🧠 Critérios — qual modelo usar
+## 🧠 Critérios — qual papel usar
+
+### ARQUITETO — usa-se SOMENTE quando (papel: desenha/orquestra/audita, nunca executa):
+
+1. **ADR Tier-1** — decisões arquiteturais irreversíveis de sistema (framework, pivot, topologia de agentes)
+2. **Auditoria adversarial de sistema** — revisão da espinha dorsal, integridade constitucional, drift cross-layer
+3. **Orquestração de sprint com N≥3 agentes paralelos** — define fila, distribui missões, não executa
+4. **Desenho de Red Zone** — define como resolver, quem executa, qual gate — nunca toca o código/dado em si
+5. **Revisão de ADR proposto pelo EXECUTOR-COMPLEXO** — segunda camada de validação arquitetural
 
-### OPUS 4.7 — usa-se SOMENTE quando:
+> ARQUITETO **NUNCA implementa, NUNCA commita, NUNCA edita arquivos**. O pesado desce para EXECUTOR-COMPLEXO/PADRÃO.
+> Se ARQUITETO indisponível (janela expirada ou quota): **EXECUTOR-COMPLEXO assume o papel** para os itens 1-5 acima.
 
-1. **Decisões arquiteturais irreversíveis** — escolha de framework, pivot, ADR Tier 1
-2. **Diagnóstico de incidente em produção** — root cause analysis quando 2+ teorias competem
-3. **Refatoração crítica em código com 500+ LOC interdependentes** — onde um erro de leitura causa cascata
-4. **Revisão de PR onde Sonnet/Haiku falharam 2× ou mais** — escalation
-5. **Negociação fina com user** — quando o user está hesitante e precisa de orientação contextualizada (Banda Cognitiva, Council, Tutor mode)
-6. **Coordenação de sprint com 3+ agentes paralelos** — quem distribui, revisa, e integra
-7. **Análise de copy pública/pricing/ethical** — Red Zones (ENIO_UNDERSTANDING_MAP)
-8. **Investigação cross-repo de bug** — quando precisa correlacionar 4+ arquivos em 2+ repos
+### EXECUTOR-COMPLEXO — usa-se SOMENTE quando:
+
+1. **Execução de alta complexidade** — diagnóstico de incidente prod com 2+ teorias competindo
+2. **Refatoração crítica em código com 500+ LOC interdependentes** — onde um erro de leitura causa cascata
+3. **Revisão de PR onde EXECUTOR-PADRÃO falhou 2× ou mais** — escalation
+4. **Negociação fina com user** — Banda Cognitiva, Council, Tutor mode, orientação contextualizada
+5. **Análise de copy pública/pricing/ethical** — Red Zones (ENIO_UNDERSTANDING_MAP)
+6. **Investigação cross-repo de bug** — correlacionar 4+ arquivos em 2+ repos
+7. **Papel ARQUITETO quando ARQUITETO indisponível** — assume itens ARQUITETO 1-5 acima
 
 ### SONNET 4.6 — modelo PADRÃO. Use sempre que:
 
@@ -78,9 +97,10 @@ Opus DEVE usar `Agent` tool com `model: "sonnet"` ou `"haiku"` em vez de fazer o
 
 ---
 
-## 🚀 Sessões de Execução Começam em Sonnet [TOKEN-START-SONNET-001 — 2026-06-04]
+## 🚀 Sessões de Execução Começam em EXECUTOR-PADRÃO [TOKEN-START-SONNET-001 — 2026-06-04]
 
 > Origem: TOKEN_MODEL_ROUTING_AUDIT.md D-01 + insight cache_read (REAL).
+> **ARQUITETO:** janelas ARQUITETO são para arquitetura pura (ADR, auditoria, orquestração N≥3). Sessões ARQUITETO também começam em EXECUTOR-PADRÃO se possível; escalar para ARQUITETO só ao confirmar tarefa arquitetural. TOKEN-START-SONNET-001 mantido para todas as janelas.
 
 ### Por que isso importa
 
@@ -149,14 +169,15 @@ Esta regra é aplicada via `CLAUDE.md §Token Economy` ("Modelo padrão: Sonnet
 ### `/start` — modelo padrão
 
 O `/start` v6.10+ deve:
-1. Detectar se janela atual é Opus
-2. Se Opus E task pode ser Sonnet: sugerir downgrade ou delegar
-3. Reportar custo acumulado se Opus E sessão >$1.50
+1. Detectar papel da janela atual (ARQUITETO/EXECUTOR-COMPLEXO/EXECUTOR-PADRÃO/MECÂNICO)
+2. Se ARQUITETO E task não é arquitetural/auditoria/orquestração N≥3: sugerir downgrade para EXECUTOR-PADRÃO
+3. Se EXECUTOR-COMPLEXO E task pode ser EXECUTOR-PADRÃO: sugerir downgrade ou delegar
+4. Reportar custo acumulado se EXECUTOR-COMPLEXO/ARQUITETO E sessão >$1.50
 
 ### `CLAUDE.md` — citar em §6 Agent & Swarm Rules
 
-Adicionar bullet:
-> **Modelo padrão Sonnet 4.6.** Opus 4.7 só para critérios de OPUS_DELEGATION_POLICY §"Quando usar Opus". Outras tarefas: delegue para Sonnet via Agent tool com `model: "sonnet"`.
+Substituir bullet existente por:
+> **Modelo padrão Sonnet 4.6 (EXECUTOR-PADRÃO).** ARQUITETO só para: ADR Tier-1, auditoria de sistema, orquestração N≥3, Red Zone design. EXECUTOR-COMPLEXO só para: execução complexa, diagnóstico prod, escalation 2×, Red Zone review. MECÂNICO: repetitivo. **TOKEN-START-SONNET-001:** toda sessão começa EXECUTOR-PADRÃO. Se ARQUITETO indisponível → EXECUTOR-COMPLEXO assume papel. Ver tabela papel→modelo em MODEL_DELEGATION_POLICY.md.
 
 ### Pre-commit hook (opcional, futuro)
 
@@ -179,28 +200,39 @@ Sinais que devem disparar escalation manual do user para Opus:
 
 ```
 ENTRA TASK:
-  → Decisão arquitetural? Red Zone? Diagnóstico crítico?
-      SIM → Opus
+  → ADR Tier-1? Auditoria de sistema? Orquestração N≥3 agentes? Desenho de Red Zone?
+      SIM → ARQUITETO (se disponível) | EXECUTOR-COMPLEXO (fallback)
+      NÃO ↓
+  → Diagnóstico prod? Escalation 2×? Red Zone execução? Refactor 500+ LOC?
+      SIM → EXECUTOR-COMPLEXO
       NÃO ↓
   → Implementação seguindo plano? Refactor com padrão claro?
-      SIM → Sonnet (delega se já em Opus)
+      SIM → EXECUTOR-PADRÃO (delega se já em EXECUTOR-COMPLEXO)
       NÃO ↓
   → Tarefa mecânica (grep, rename, batch read, typecheck)?
-      SIM → Haiku
-      NÃO → Sonnet (default)
+      SIM → MECÂNICO
+      NÃO → EXECUTOR-PADRÃO (default)
 
-EM SESSÃO OPUS:
+EM SESSÃO ARQUITETO:
+  → Qualquer implementação/edição de arquivo?
+      SIM → Dispatch EXECUTOR-COMPLEXO ou EXECUTOR-PADRÃO — ARQUITETO não toca código
+      NÃO → manter ARQUITETO para desenho/orquestração
+
+EM SESSÃO EXECUTOR-COMPLEXO:
   → Vou escrever doc/test/refactor extenso?
       SIM → Agent({model:"sonnet"}) com plano cirúrgico
-      NÃO → manter Opus
+      NÃO → manter EXECUTOR-COMPLEXO
 
 ESCALATION:
-  → Sonnet falhou 2× no mesmo problema → Opus
-  → User pediu "pensa bem" / "/banda" / "/council" → Opus
-  → Red Zone (copy, pricing, ética) → Opus
+  → EXECUTOR-PADRÃO falhou 2× no mesmo problema → EXECUTOR-COMPLEXO
+  → User pediu "pensa bem" / "/banda" / "/council" → EXECUTOR-COMPLEXO
+  → Red Zone (copy, pricing, ética) → EXECUTOR-COMPLEXO (+ ARQUITETO para desenho da solução)
 ```
 
+> Ver tabela papel→modelo no topo deste documento para saber qual modelo corresponde a cada papel hoje.
+
 ---
 
 *v1.0 — 2026-05-20 (decisão Enio "vamos usar Sonnet como principal quando não tiver necessidade de Opus")*
 *v1.1 — 2026-06-04 (TOKEN-START-SONNET-001: seção explícita "Sessões de Execução Começam em Sonnet" + por que cache_read é 5× mais caro em Opus)*
+*v1.2 — 2026-06-09 (redesenho Codex §3-P2: 4 papéis por função — ARQUITETO/EXECUTOR-COMPLEXO/EXECUTOR-PADRÃO/MECÂNICO; tabela papel→modelo única no topo; criterios referenciam papéis não nomes de modelo; fallback ARQUITETO→EXECUTOR-COMPLEXO. Auditoria: FABLE5_BACKBONE_AUDIT §2/§3)*

exec
/bin/bash -lc "git grep -n \"renderFileReferenceSignature\\|FILE_REFERENCE_MANIFEST\\|FILE_SIGNATURE_START\"" in /home/enio/egos
 succeeded in 176ms:
packages/shared/src/mycelium/file-reference-manifest.ts:57:export const FILE_SIGNATURE_START = '<!-- EGOS:FILE-REF-SIG:START -->';
packages/shared/src/mycelium/file-reference-manifest.ts:64:export const FILE_REFERENCE_MANIFEST: FileReferenceEntry[] = [
packages/shared/src/mycelium/file-reference-manifest.ts:122: * The block is delimited by FILE_SIGNATURE_START / FILE_SIGNATURE_END.
packages/shared/src/mycelium/file-reference-manifest.ts:124:export function renderFileReferenceSignature(entry: FileReferenceEntry): string {
packages/shared/src/mycelium/file-reference-manifest.ts:135:  return `${FILE_SIGNATURE_START}\n${body}\n${FILE_SIGNATURE_END}`;
packages/shared/src/mycelium/file-reference-manifest.ts:145:  if (FILE_REFERENCE_MANIFEST.length > MAX_MANIFEST_ENTRIES) {
packages/shared/src/mycelium/file-reference-manifest.ts:148:      detail: `manifest has ${FILE_REFERENCE_MANIFEST.length} entries, limit is ${MAX_MANIFEST_ENTRIES}`,
packages/shared/src/mycelium/file-reference-manifest.ts:152:  for (const entry of FILE_REFERENCE_MANIFEST) {
packages/shared/src/mycelium/file-reference-manifest.ts:172:  for (const entry of FILE_REFERENCE_MANIFEST) {

exec
/bin/bash -lc 'bun scripts/test-mycelium-bus.ts --cross-process' in /home/enio/egos
 succeeded in 1388ms:
  [A:223546] [cp-publisher] PID=223546 correlationId=test-mycelium-005-1781090408979
  [A:223546] [bus-redis-bridge] transport=redis channel=egos:mycelium:events
  [A:223546] [cp-publisher] bridge transport=redis
  [A:223546] [cp-publisher] emitting architecture.ssot_violation...
  [A:223546] [cp-publisher] event emitted id=48667679-57dd-4d4a-b5ce-91eade1da04d
  [B:223531] [sentinela-redis] flag written — topic=architecture.ssot_violation eventId=48667679-57dd-4d4a-b5ce-91eade1da04d
  [B:223531] [cp-subscriber] FOUND correlationId=test-mycelium-005-1781090408979 source=mycelium-redis
[cp-subscriber] flag: {"ts":"2026-06-10T11:20:09.843Z","event":"architecture.ssot_violation","payload":{"file":"TASKS.md","rule":"SSOT-MAP-001","expected":"tasks only in TASKS.md","actual":"duplicate task entry detected in docs/jobs/","synthetic":true,"crossProcess":true},"source":"mycelium-redis","correlationId":"test-mycelium-005-1781090408979","eventId":"48667679-57dd-4d4a-b5ce-91eade1da04d"}
  [B:223531] [sentinela-redis] unsubscribed and closed
  [A:223546] [bus-redis-bridge] closed

[test-mycelium-bus] publisher PID=223546 exit=0
[test-mycelium-bus] subscriber PID=223531 exit=0
[test-mycelium-bus] PASS: PIDs distintos: publisher=223546 subscriber=223531
[test-mycelium-bus] PASS: flags: 1977 → 1978 (+1)
[test-mycelium-bus] PASS: source=mycelium-redis confirmado
[test-mycelium-bus] PASS: correlationId=test-mycelium-005-1781090408979 confirmado

[test-mycelium-bus] última flag (source=mycelium-redis):
{
  "ts": "2026-06-10T11:20:09.843Z",
  "event": "architecture.ssot_violation",
  "payload": {
    "file": "TASKS.md",
    "rule": "SSOT-MAP-001",
    "expected": "tasks only in TASKS.md",
    "actual": "duplicate task entry detected in docs/jobs/",
    "synthetic": true,
    "crossProcess": true
  },
  "source": "mycelium-redis",
  "correlationId": "test-mycelium-005-1781090408979",
  "eventId": "48667679-57dd-4d4a-b5ce-91eade1da04d"
}

[test-mycelium-bus] AC MYCELIUM-005: SATISFIED

exec
/bin/bash -lc 'REDIS_URL=redis://127.0.0.1:1 bun scripts/test-mycelium-bus.ts --cross-process' in /home/enio/egos
 exited 1 in 12168ms:
  [A:223762] [cp-publisher] PID=223762 correlationId=test-mycelium-005-1781090415229
  [A:223762:err] [mycelium:redis-bridge] Redis unreachable (127.0.0.1:1) — falling back to mock transport. Error: connect ECONNREFUSED 127.0.0.1:1
  [A:223762] [bus-redis-bridge] transport=mock channel=egos:mycelium:events
[cp-publisher] bridge transport=mock
  [A:223762] [cp-publisher] emitting architecture.ssot_violation...
  [A:223762] [mycelium:mock][egos:mycelium:events] PUBLISH {"type":"node_updated","timestamp":"2026-06-10T11:20:16.094Z","source":"test-mycelium-cross-process","payload":{"busEventId":"eec754cd-6801-499f-bc6c-f8405ab87901","topic":"architecture.ssot_violation","correlationId":"test-mycelium-005-1781090415229","payload":{"file":"TASKS.md","rule":"SSOT-MAP-001","expected":"tasks only in TASKS.md","actual":"duplicate task entry detected in docs/jobs/","synthetic":true,"crossProcess":true},"metadata":{"synthetic":true,"test":"MYCELIUM-005"}}}
  [A:223762] [cp-publisher] event emitted id=eec754cd-6801-499f-bc6c-f8405ab87901
  [A:223762] [mycelium:mock][egos:mycelium:events] CLOSE (mock)
[bus-redis-bridge] closed
  [B:223730] [mycelium:mock][egos:mycelium:events] CLOSE (mock)
[sentinela-redis] unsubscribed and closed
  [B:223730:err] [cp-subscriber] TIMEOUT — flag com correlationId=test-mycelium-005-1781090415229 não encontrada

[test-mycelium-bus] publisher PID=223762 exit=0
[test-mycelium-bus] subscriber PID=223730 exit=1
[test-mycelium-bus] FAIL: subscriber saiu com código 1

 succeeded in 93485ms:
grep: ./apps/_archived/vendas-portal/node_modules/react: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/next: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@supabase/ssr: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/typescript: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/vendas-portal/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/react: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/next: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@tailwindcss/postcss: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/typescript: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/trust-page/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/react: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/next: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@egosbr/guard-brasil: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@privy-io/react-auth: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@tailwindcss/postcss: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/typescript: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/guard-brasil-web/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/react: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/vite: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/@vitejs/plugin-react: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/.bin/vite: No such file or directory
grep: ./apps/_archived/egos-landing/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/react: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint-plugin-react-hooks: No such file or directory
grep: ./apps/_archived/commons/node_modules/react-router-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/lucide-react: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/@vitejs/plugin-react: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/autoprefixer: No such file or directory
grep: ./apps/_archived/commons/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/commons/node_modules/postcss: No such file or directory
grep: ./apps/_archived/commons/node_modules/autoprefixer: No such file or directory
grep: ./apps/_archived/commons/node_modules/tailwindcss: No such file or directory
grep: ./apps/_archived/commons/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/commons/node_modules/@eslint/js: No such file or directory
grep: ./apps/_archived/commons/node_modules/eslint-plugin-react-refresh: No such file or directory
grep: ./apps/_archived/commons/node_modules/typescript-eslint: No such file or directory
grep: ./apps/_archived/commons/node_modules/@tailwindcss/vite: No such file or directory
grep: ./apps/_archived/commons/node_modules/typescript: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/commons/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/commons/node_modules/globals: No such file or directory
grep: ./apps/_archived/commons/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/hono: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-site/node_modules/@types/bun: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/react: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/next: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/next: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/react: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/@types/react-dom: No such file or directory
grep: ./apps/_archived/egos-council/node_modules/react-dom: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/hono: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@supabase/supabase-js: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/typescript: No such file or directory
grep: ./apps/_archived/egos-site-pre-v3-2026-05-07/node_modules/@types/bun: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/bun-types: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/hono: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/@egos/auth: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/typescript: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/@types/node: No such file or directory
grep: ./apps/_archived/auth-server/node_modules/zod: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/hono: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/.bin/tsserver: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/.bin/tsc: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/typescript: No such file or directory
grep: ./apps/_archived/gem-hunter-landing/node_modules/@types/bun: No such file or directory
./agents/subscribers/sentinela-bus-subscriber.ts:9: *   Processo Sentinela: subscribeViaRedis() → lê do Redis → escreve flag JSONL
./agents/subscribers/sentinela-bus-subscriber.ts:114:export async function subscribeViaRedis(): Promise<() => Promise<void>> {
./agents/subscribers/bus-redis-bridge.ts:71: * const handle = await bridgeBusToRedis(getGlobalBus());
./agents/subscribers/bus-redis-bridge.ts:76:export async function bridgeBusToRedis(bus: MyceliumBus): Promise<BusRedisBridgeHandle> {
./scripts/test-mycelium-bus.ts:33:  subscribeViaRedis,
./scripts/test-mycelium-bus.ts:35:import { bridgeBusToRedis } from '../agents/subscribers/bus-redis-bridge';
./scripts/test-mycelium-bus.ts:181:  const closeFn = await subscribeViaRedis();
./scripts/test-mycelium-bus.ts:221:  const handle = await bridgeBusToRedis(bus);

exec
/bin/bash -lc "sed -n '1,260p' scripts/disseminate-propagator.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * scripts/disseminate-propagator.ts — EGOS Kernel Propagator (DISS-002)
 *
 * Reads .egos-disseminate-manifest.json (generated by DISS-001 disseminate-scanner.ts),
 * then for each repo in existing_repos:
 *   1. Updates the `# EGOS-KERNEL-PROPAGATED: DATE` marker in CLAUDE.md and .windsurfrules
 *   2. Commits with `chore(kernel): propagate YYYY-MM-DD [N rules]`
 *
 * Usage:
 *   bun scripts/disseminate-propagator.ts [--dry] [--repo /path/to/repo]
 *   bun scripts/disseminate-propagator.ts --all     # propagate to all existing_repos
 *
 * Marker format expected in target files:
 *   # EGOS-KERNEL-PROPAGATED: YYYY-MM-DD
 *   <!-- AUTO-INJECTED ... -->
 *   (injected summary block)
 *   ---
 *
 * If marker not found, a new block is prepended to the file.
 */

import { execSync, spawnSync } from "node:child_process";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join, resolve, dirname } from "node:path";

// ── Config ──────────────────────────────────────────────────────────────────

const REPO_ROOT = resolve(dirname(import.meta.path), "..");
const MANIFEST_PATH = join(REPO_ROOT, ".egos-disseminate-manifest.json");
const DRY = process.argv.includes("--dry");
const ALL = process.argv.includes("--all");
const REPO_ARG = process.argv.find(a => a.startsWith("--repo="))?.replace("--repo=", "");

// Files to update inside each target repo
const TARGET_FILES = ["CLAUDE.md", ".windsurfrules", "AGENTS.md"];  // AGENTS.md added 2026-04-17 INC-006 Layer A

// Marker that identifies the auto-injected block
const MARKER_PREFIX = "# EGOS-KERNEL-PROPAGATED:";
const BLOCK_END = "---"; // end of injected block
const BLOCK_COMMENT = "<!-- AUTO-INJECTED by disseminate-propagator.ts — DO NOT EDIT THIS BLOCK MANUALLY -->";


// Path to kernel AGENTS.md — extract R0-R6 rules body for content-propagation (INC-006 Layer A)
const KERNEL_AGENTS_MD = join(REPO_ROOT, "AGENTS.md");
const RULES_BEGIN_MARKER = "<!-- PROPAGATE-RULES-BEGIN -->";
const RULES_END_MARKER = "<!-- PROPAGATE-RULES-END -->";

function getCanonicalRulesBody(): string {
  if (!existsSync(KERNEL_AGENTS_MD)) {
    return "<!-- WARN: kernel AGENTS.md not found, falling back to link -->";
  }
  const content = readFileSync(KERNEL_AGENTS_MD, "utf-8");
  const startIdx = content.indexOf(RULES_BEGIN_MARKER);
  const endIdx = content.indexOf(RULES_END_MARKER);
  if (startIdx === -1 || endIdx === -1) {
    // Fallback: extract from "## 📋 Canonical Rules" to next "---" before llmrefs
    const sectionStart = content.indexOf("## 📋 Canonical Rules");
    const llmrefsStart = content.indexOf("<!-- llmrefs:start -->");
    if (sectionStart === -1) return "<!-- WARN: rules section not found in AGENTS.md -->";
    const section = llmrefsStart > sectionStart
      ? content.substring(sectionStart, llmrefsStart).trim()
      : content.substring(sectionStart, sectionStart + 8000).trim();
    return section;
  }
  return content.substring(startIdx + RULES_BEGIN_MARKER.length, endIdx).trim();
}


// ── Types ───────────────────────────────────────────────────────────────────

interface ChangedRule {
  file: string;
  label: string;
  section: string;
  change_type: "added" | "modified" | "removed";
  diff_lines: number;
}

interface DisseminateManifest {
  date: string;
  commit: string;
  since_commit: string;
  changed_rules: ChangedRule[];
  affected_repos: string[];
  existing_repos: string[];
  propagation_needed: boolean;
  generated_at: string;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function loadManifest(): DisseminateManifest | null {
  if (!existsSync(MANIFEST_PATH)) {
    console.error(`[propagator] Manifest not found: ${MANIFEST_PATH}`);
    console.error(`[propagator] Run: bun scripts/disseminate-scanner.ts first`);
    return null;
  }
  return JSON.parse(readFileSync(MANIFEST_PATH, "utf-8")) as DisseminateManifest;
}

function buildInjectedBlock(manifest: DisseminateManifest): string {
  const { date, commit, changed_rules } = manifest;
  const ruleCount = changed_rules.length;

  const ruleLines = changed_rules.slice(0, 10).map(r => {
    const icon = r.change_type === "added" ? "+" : r.change_type === "removed" ? "-" : "~";
    const section = r.section === "(preamble)" ? r.label : `${r.label} → ${r.section}`;
    return `<!-- ${icon} ${section} (${r.diff_lines} lines) -->`;
  });
  if (ruleCount > 10) ruleLines.push(`<!-- ... and ${ruleCount - 10} more -->`);

  const rulesBody = getCanonicalRulesBody();
  return [
    `${MARKER_PREFIX} ${date}`,
    BLOCK_COMMENT,
    `<!-- Kernel commit: ${commit} | ${ruleCount} rule section(s) changed -->`,
    `<!-- Source of rules: egos/AGENTS.md (canonical). Kernel-only authoritative copy: ~/.claude/CLAUDE.md -->`,
    `<!-- Re-run: bun ~/egos/scripts/disseminate-propagator.ts --all to update -->`,
    ...ruleLines,
    ``,
    `> ⚠️ **PROPAGATED FROM KERNEL** — Edits to this block are overwritten by next \`bun governance:sync:exec\`.`,
    `> Edit kernel \`egos/AGENTS.md\` section between \`<!-- PROPAGATE-RULES-BEGIN -->\` and \`<!-- PROPAGATE-RULES-END -->\` instead.`,
    ``,
    `<!-- === BEGIN KERNEL RULES BODY (auto-injected from egos/AGENTS.md) === -->`,
    ``,
    rulesBody,
    ``,
    `<!-- === END KERNEL RULES BODY === -->`,
    ``,
    BLOCK_END,
  ].join("\n");
}

/**
 * Update or insert the injected block in a file.
 * Returns true if file was modified.
 */
function updateFile(filePath: string, injectedBlock: string): boolean {
  if (!existsSync(filePath)) {
    console.log(`  [propagator] File not found, skipping: ${filePath}`);
    return false;
  }

  const content = readFileSync(filePath, "utf-8");
  const lines = content.split("\n");

  // Find existing marker
  const markerIdx = lines.findIndex(l => l.startsWith(MARKER_PREFIX));

  if (markerIdx === -1) {
    // No existing block — prepend
    const newContent = injectedBlock + "\n\n" + content;
    if (!DRY) writeFileSync(filePath, newContent);
    console.log(`  [propagator] + Prepended block to ${filePath.split("/").pop()}`);
    return true;
  }

  // Find end of existing block (first `---` after marker or next `#` heading)
  let blockEndIdx = markerIdx + 1;
  while (blockEndIdx < lines.length) {
    const line = lines[blockEndIdx];
    if (line === BLOCK_END || (line.startsWith("# ") && blockEndIdx > markerIdx + 2)) break;
    blockEndIdx++;
  }
  // Include the `---` line in replacement if it's the end marker
  if (lines[blockEndIdx] === BLOCK_END) blockEndIdx++;

  // Replace old block with new block
  const before = lines.slice(0, markerIdx);
  const after = lines.slice(blockEndIdx);
  const newContent = [...before, injectedBlock, ...after].join("\n");

  if (newContent === content) {
    console.log(`  [propagator] = No change needed: ${filePath.split("/").pop()}`);
    return false;
  }

  if (!DRY) writeFileSync(filePath, newContent);
  console.log(`  [propagator] ✓ Updated block in ${filePath.split("/").pop()}`);
  return true;
}

/**
 * Commit changes in a target repo.
 */
function commitRepo(repoPath: string, date: string, ruleCount: number): boolean {
  const existingTargetFiles = TARGET_FILES.filter(fileName => existsSync(join(repoPath, fileName)));

  if (existingTargetFiles.length === 0) {
    console.log(`  [propagator] No target files found in ${repoPath}`);
    return false;
  }

  const result = spawnSync("git", [
    "-C", repoPath,
    "status", "--short", "--", ...existingTargetFiles
  ], { encoding: "utf-8" });

  if (!result.stdout.trim()) {
    console.log(`  [propagator] No changes to commit in ${repoPath}`);
    return false;
  }

  const addResult = spawnSync("git", [
    "-C", repoPath,
    "add", "--", ...existingTargetFiles
  ], { encoding: "utf-8" });

  if (addResult.status !== 0) {
    console.error(`  [propagator] git add failed: ${addResult.stderr}`);
    return false;
  }

  const message = `chore(kernel): propagate ${date} [${ruleCount} rules]\n\nAuto-propagated from egos kernel by disseminate-propagator.ts (DISS-002).\nSource commit: see .egos-disseminate-manifest.json\n\nCo-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>`;
  const commitResult = spawnSync("git", [
    "-C", repoPath,
    "commit", "-m", message,
    "--no-verify" // bypass hooks in target repos (not kernel)
  ], { encoding: "utf-8" });

  if (commitResult.status !== 0) {
    console.error(`  [propagator] git commit failed: ${commitResult.stderr}`);
    return false;
  }

  console.log(`  [propagator] ✅ Committed in ${repoPath.split("/").pop()}`);
  return true;
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const manifest = loadManifest();
  if (!manifest) process.exit(1);

  if (!manifest.propagation_needed && !ALL) {
    console.log(`[propagator] No propagation needed (manifest says propagation_needed=false)`);
    console.log(`[propagator] Use --all to force propagation anyway`);
    process.exit(0);
  }

  console.log(`[propagator] Manifest: ${manifest.date} | commit ${manifest.commit} | ${manifest.changed_rules.length} rules changed`);
  console.log(`[propagator] Target repos: ${manifest.existing_repos.length}/${manifest.affected_repos.length} exist`);
  if (DRY) console.log(`[propagator] DRY RUN — no writes`);

  const injectedBlock = buildInjectedBlock(manifest);
  const repos = REPO_ARG ? [REPO_ARG] : manifest.existing_repos;

  let updated = 0;
  let committed = 0;
  let skipped = 0;

  for (const repoPath of repos) {
    if (!existsSync(repoPath)) {
      console.log(`[propagator] ⚠️  Repo not found: ${repoPath} — skipping`);
      skipped++;
      continue;
    }


exec
/bin/bash -lc "sed -n '260,520p' scripts/disseminate-propagator.ts" in /home/enio/egos
 succeeded in 0ms:

    // Check it's a git repo
    const gitCheck = spawnSync("git", ["-C", repoPath, "rev-parse", "--git-dir"], { encoding: "utf-8" });
    if (gitCheck.status !== 0) {
      console.log(`[propagator] ⚠️  Not a git repo: ${repoPath} — skipping`);
      skipped++;
      continue;
    }

    console.log(`\n[propagator] → ${repoPath.split("/").pop()} (${repoPath})`);

    let repoModified = false;
    for (const targetFile of TARGET_FILES) {
      const filePath = join(repoPath, targetFile);
      if (updateFile(filePath, injectedBlock)) {
        repoModified = true;
        updated++;
      }
    }

    if (repoModified && !DRY) {
      if (commitRepo(repoPath, manifest.date, manifest.changed_rules.length)) {
        committed++;
      }
    }
  }

  console.log(`\n[propagator] Summary: ${updated} file(s) updated, ${committed} repo(s) committed, ${skipped} skipped`);
  if (DRY) console.log(`[propagator] Re-run without --dry to apply changes`);
}

main().catch(err => {
  console.error("[propagator] Fatal:", err);
  process.exit(1);
});

exec
/bin/bash -lc "nl -ba agents/subscribers/sentinela-bus-subscriber.ts | sed -n '108,136p'; nl -ba agents/subscribers/bus-redis-bridge.ts | sed -n '86,104p'; nl -ba packages/shared/src/mycelium/file-reference-manifest.ts | sed -n '124,134p'" in /home/enio/egos
 succeeded in 0ms:
   108	/**
   109	 * Abre subscrição no canal Redis e escreve flag JSONL para cada evento recebido.
   110	 * source = 'mycelium-redis' para distinguir de flags in-process.
   111	 *
   112	 * Returns a close function — call it to stop receiving and close the socket.
   113	 */
   114	export async function subscribeViaRedis(): Promise<() => Promise<void>> {
   115	  const bridge = await createRedisBridge({
   116	    redisUrl: REDIS_URL_SENTINELA,
   117	    channel: REDIS_CHANNEL,
   118	    publishOnMutation: false,
   119	  });
   120	
   121	  console.log(
   122	    `[sentinela-redis] subscribed to channel=${REDIS_CHANNEL} transport=${bridge.transport}`,
   123	  );
   124	
   125	  const unsubscribe = bridge.subscribe((bridgeEvent: RedisBridgeEvent) => {
   126	    // payload envelope criado por bus-redis-bridge.toBridgeEvent
   127	    const envelope = bridgeEvent.payload as {
   128	      busEventId?: string;
   129	      topic?: string;
   130	      correlationId?: string;
   131	      payload?: unknown;
   132	    } | null;
   133	
   134	    const topic = envelope?.topic ?? bridgeEvent.type;
   135	    const eventId = envelope?.busEventId ?? 'unknown';
   136	    const correlationId = envelope?.correlationId ?? 'unknown';
    86	    console.warn(
    87	      '[bus-redis-bridge] falha ao criar bridge Redis — eventos não serão propagados cross-process.',
    88	      (err as Error).message,
    89	    );
    90	    // Retorna handle no-op para não quebrar o processo
    91	    return {
    92	      transport: 'failed',
    93	      close: async () => {},
    94	    };
    95	  }
    96	
    97	  console.log(`[bus-redis-bridge] transport=${bridge.transport} channel=${CHANNEL}`);
    98	
    99	  // Assina todos os tópicos via wildcard '*'
   100	  const sub = bus.on('*', async (event: MyceliumEvent) => {
   101	    try {
   102	      await bridge.publish(toBridgeEvent(event));
   103	    } catch (err) {
   104	      console.warn('[bus-redis-bridge] publish error:', (err as Error).message);
   124	export function renderFileReferenceSignature(entry: FileReferenceEntry): string {
   125	  const linkLines = entry.links.map(
   126	    l => `<!--   ${l.relation}: ${l.path}${l.note ? ` — ${l.note}` : ''} -->`,
   127	  );
   128	  const body = [
   129	    `<!-- role: ${entry.role} -->`,
   130	    ...(linkLines.length > 0 ? ['<!-- links:'] : []),
   131	    ...linkLines,
   132	    ...(linkLines.length > 0 ? ['-->'] : []),
   133	  ].join('\n');
   134	

exec
/bin/bash -lc 'ls -l .husky/_checks/15-agent-gate.sh 2>/dev/null || echo missing; git status --short' in /home/enio/egos
 succeeded in 0ms:
-rwxrwxr-x 1 enio enio 6982 Jun 10 07:51 .husky/_checks/15-agent-gate.sh
M  .claude/commands/disseminate.md
 M .husky/pre-commit
 M TASKS.md
A  agents/registry/leaf-repos.json
 M apps/egos-landing/public/mycelium-snapshot.json
 M apps/egos-landing/public/timeline/rss
 M apps/egos-landing/public/timeline/rss.xml
M  scripts/disseminate-scanner.ts
?? docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md
?? docs/banda/2026-06-10-dry-run.yaml
?? docs/jobs/2026-06-10-doc-drift-verifier.json
?? docs/jobs/2026-06-10-pre-commit-pipeline.json

exec
/bin/bash -lc 'git status --short -- .husky/_checks/15-agent-gate.sh; git ls-files .husky/_checks/15-agent-gate.sh; git diff 9883209e49ad7c5b591c1ea04733f1f7a9ede794 -- .husky/_checks/15-agent-gate.sh | head -20' in /home/enio/egos
 succeeded in 0ms:
.husky/_checks/15-agent-gate.sh

codex
The Redis subscriber changes would produce false Sentinela alerts once the cross-process bridge is used, and the new signature renderer emits malformed comment blocks for entries with links. These are actionable issues introduced by the patch.

Full review comments:

- [P2] Filter Redis events before flagging Sentinela alerts — /home/enio/egos/agents/subscribers/sentinela-bus-subscriber.ts:125-136
  When the Redis bridge is enabled, `bus-redis-bridge` publishes every bus topic via `bus.on('*')`, but this subscriber appends a Sentinela flag for every received Redis message. In a real runner this means routine events such as `agent.started`/`agent.completed` will be persisted as alerts, unlike the in-process subscriber which only flags `architecture.ssot_violation`/`architecture.*`; this will create noisy/incorrect `sentinela-flags.jsonl` entries as soon as more publishers are bridged.

- [P3] Render link signatures without nested comments — /home/enio/egos/packages/shared/src/mycelium/file-reference-manifest.ts:125-132
  For any manifest entry with links, this builds `<!-- links:` and then emits each link as its own `<!-- ... -->` comment before adding a final `-->`. The first link's terminator closes the outer comment, leaving the final `-->` as stray visible text in files that receive an injected signature, so linked signatures in `.windsurfrules`/workflow docs will be malformed.
The Redis subscriber changes would produce false Sentinela alerts once the cross-process bridge is used, and the new signature renderer emits malformed comment blocks for entries with links. These are actionable issues introduced by the patch.

Full review comments:

- [P2] Filter Redis events before flagging Sentinela alerts — /home/enio/egos/agents/subscribers/sentinela-bus-subscriber.ts:125-136
  When the Redis bridge is enabled, `bus-redis-bridge` publishes every bus topic via `bus.on('*')`, but this subscriber appends a Sentinela flag for every received Redis message. In a real runner this means routine events such as `agent.started`/`agent.completed` will be persisted as alerts, unlike the in-process subscriber which only flags `architecture.ssot_violation`/`architecture.*`; this will create noisy/incorrect `sentinela-flags.jsonl` entries as soon as more publishers are bridged.

- [P3] Render link signatures without nested comments — /home/enio/egos/packages/shared/src/mycelium/file-reference-manifest.ts:125-132
  For any manifest entry with links, this builds `<!-- links:` and then emits each link as its own `<!-- ... -->` comment before adding a final `-->`. The first link's terminator closes the outer comment, leaving the final `-->` as stray visible text in files that receive an injected signature, so linked signatures in `.windsurfrules`/workflow docs will be malformed.
```
