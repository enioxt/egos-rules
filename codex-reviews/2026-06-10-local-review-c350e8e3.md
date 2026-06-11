# Codex Local Review — 2026-06-10T11:57:52Z

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
session id: 019eb165-6648-7393-ac98-d508898d7f1f
--------
user
changes against 'HEAD~3'
2026-06-10T11:57:54.275161Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T11:57:54.275632Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 78914c603fe2843d37de18c3b4ae2ae7af132467 --stat && git diff 78914c603fe2843d37de18c3b4ae2ae7af132467' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/end.md                           |   2 +
 .agents/workflows/start.md                         |   2 +
 .claude/agents/critico.md                          |   1 +
 .claude/agents/forja.md                            |   1 +
 .claude/agents/guarani.md                          |   3 +
 .claude/agents/hermes-ops.md                       |   1 +
 .claude/agents/prime.md                            |   1 +
 .claude/commands/disseminate.md                    |   7 +-
 .claude/commands/end.md                            |   2 +
 .claude/commands/start.md                          |   2 +
 .husky/pre-commit                                  |   9 +
 AGENTS.md                                          |  11 +-
 CLAUDE.md                                          |   4 +-
 TASKS.md                                           |  42 ++--
 TASKS_ARCHIVE.md                                   |  17 ++
 agents/registry/leaf-repos.json                    |  88 ++++++++
 apps/egos-landing/public/mycelium-snapshot.json    |   2 +-
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 docs/CAPABILITY_REGISTRY.md                        |   2 +-
 .../2026-04/handoff_2026-03-31.md                  |   4 +-
 .../2026-04/handoff_2026-04-06_p29.md              |   4 +-
 .../2026-04/handoff_2026-04-06_p30.md              |   2 +-
 ...2026-04-07_chatbot_p0_guard_credentials_xcom.md |   2 +-
 .../handoff_2026-04-07_p35_ssot_gate_complete.md   |   6 +-
 .../2026-04/handoff_2026-04-12b.md                 |   2 +-
 .../2026-04/handoff_2026-04-14.md                  |   8 +-
 .../handoff_2026-04-16_bilingual_pipeline.md       |   2 +-
 .../2026-04/handoff_2026-04-17b.md                 |   4 +-
 .../2026-04/handoff_2026-04-23.md                  |   2 +-
 .../2026-04/handoff_2026-04-24.md                  |   2 +-
 .../2026-05/ACTION_ITEMS_USER.md                   |   4 +-
 .../2026-05/PARTNERSHIP_KIT_INDEX.md               |  26 +--
 .../2026-05/PRODUTOS_pre-central-egos-pivot.md     |   4 +-
 ...andoff_2026-05-15_espiral-integrations-audit.md |  52 ++---
 .../handoff_2026-05-18_grok-decisions-applied.md   |   4 +-
 docs/_archived_handoffs/HANDOFF_CURRENT.md         |   2 +-
 docs/_archived_handoffs/MEMORY_SESSION_INDEX.md    |   2 +-
 .../FOR_GUARANI_2026-06-10_end-review.md           |  28 +++
 docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md     |  41 ++++
 docs/_current_handoffs/handoff_2026-06-10.md       |  55 +++--
 docs/agents/META_PROMPTS_INDEX.md                  |  10 +-
 docs/audits/CAPABILITY_COVERAGE_2026-05-30.md      |   4 +-
 docs/audits/INTEGRATION_COVERAGE_2026-05-30.md     |   2 +-
 docs/banda/2026-06-10-dry-run.yaml                 |  38 ++++
 docs/concepts/ESPIRAIS_VISION.md                   |   2 +-
 docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md           |   2 +-
 docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md   |   2 +-
 docs/governance/AREAS_OF_PRACTICE.md               |   2 +-
 docs/governance/CLIENT_KB_DOCTRINE.md              |   4 +-
 docs/governance/CLIENT_TIERS_MATRIX.md             |   2 +-
 docs/governance/EGOS_OPERATING_PRINCIPLES.md       |   2 +-
 docs/governance/MASTER_INDEX.md                    |   2 +-
 docs/jobs/2026-06-10-doc-drift-verifier.json       | 244 +++++++++++++++++++++
 docs/jobs/2026-06-10-pre-commit-pipeline.json      | 234 ++++++++++++++++++++
 docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md     |   2 +-
 docs/products-specs/INDEX.md                       |   2 +-
 docs/products-specs/anythingllm/OPERATIONS.md      |   4 +-
 docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md           |   2 +-
 docs/runbooks/MOBILE_ACCESS_GUIDE.md               |   2 +-
 docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md          |   2 +-
 .../_archived_2026-05-06/CONSULTING_MASTER_PLAN.md |  22 +-
 scripts/disseminate-scanner.ts                     |  30 +--
 scripts/egos-home/sync.sh                          |  28 +--
 64 files changed, 915 insertions(+), 186 deletions(-)
diff --git a/.agents/workflows/end.md b/.agents/workflows/end.md
index 31cd3b82..26157be6 100644
--- a/.agents/workflows/end.md
+++ b/.agents/workflows/end.md
@@ -19,6 +19,7 @@ Você está executando `/end`. Sua obrigação:
 3. **TEMPLATE LITERAL** — handoff e memory writes seguem formato fixo. Não improvisar.
 4. **VERIFICATION CHECKPOINT** (Phase 10) é OBRIGATÓRIO. Sem ele, /end está incompleto.
 5. **NEVER `git add -A`** — sempre `git add <specific-file>` (T0 rule, INC-002).
+6. **No-Code Handoff Discipline (END-NOCODE-001):** Ao consolidar a sessão e gerar o handoff, certifique-se de que os próximos passos e in-progress estão descritos de modo a serem 100% acionáveis de forma autônoma por IAs subsequentes, sem requerer intervenções de codificação manual do usuário Enio.
 
 ---
 
@@ -616,6 +617,7 @@ EGOS /end v6.1 — Verification Checkpoint
 Phase 0 — Re-load Context
   ✓ Single Pursuit confirmado: [Central EGOS / outro]
   ✓ session-checklist format: ✅/🔄/⏳
+  ✓ No-Code Handoff e tasks auto-executáveis: [confirmado]
 
 Phase 1 — Coverage Check
   ✓ Skills changed: [N] | ADRs changed: [N]
diff --git a/.agents/workflows/start.md b/.agents/workflows/start.md
index a8a9c7a0..90a45d89 100644
--- a/.agents/workflows/start.md
+++ b/.agents/workflows/start.md
@@ -24,6 +24,7 @@ Você está executando `/start`. Sua obrigação:
 8. **MODELO PADRÃO SONNET 4.6:** Se você é Opus 4.7, avalie cada task via [MODEL_DELEGATION_POLICY](../../docs/governance/MODEL_DELEGATION_POLICY.md). Opus orquestra, Sonnet executa, Haiku faz mecânico. Reportar modelo atual + delegação no checkpoint.
 9. **SWARM COMMIT POLICY:** Quando 1+ `Agent` em background, **NÃO fazer git commit incremental** — race condition. Commit consolidado final. SSOT: [SWARM_COMMIT_POLICY](../../docs/governance/SWARM_COMMIT_POLICY.md).
 10. **MODE DETECTION:** Prompt com (`pesquisa`, `governança`, `leitura`, `revisão`, `auditoria`, `entender`, `só ler`) → `MODE=research` (executa só Layers `0.0+0+0.5+4.8+1+2+3+4+4.5+7`). Caso contrário → `MODE=write` (todas as layers). Declarar MODE como **primeiro campo** do checkpoint. Corte silencioso sem MODE = checkpoint inválido.
+11. **100% AI-Driven / No-Code Master (START-NOCODE-001):** O desenvolvimento do EGOS é 100% feito por IAs. O usuário Enio não lê nem escreve código cru. Você deve assumir total propriedade e autonomia técnica operacional. Não crie tarefas ou dê respostas pedindo para o usuário implementar, colar código ou realizar alterações manuais de arquivos. A interação com o humano deve ocorrer no nível estratégico-arquitetural e interfaces visuais/funcionais.
 
 ---
 
@@ -475,6 +476,7 @@ Layer 0.5 — EPOS Pergunta Disparada (OBRIGATÓRIO — checkpoint inválido sem
 Layer 1 — Global Rules
   ✓ T0 citada: [ex: "NEVER force-push main"]
   ✓ Single Pursuit (enio-profile): [data + descrição]
+  ✓ 100% AI-Driven Developer / No-Code Master internalizado: [sim]
 
 Layer 2 — Bootstrap
   ✓ EGOS_BOOTSTRAP.md: [versão + última atualização]
diff --git a/.claude/agents/critico.md b/.claude/agents/critico.md
index b088d4f4..22a6ce42 100644
--- a/.claude/agents/critico.md
+++ b/.claude/agents/critico.md
@@ -76,3 +76,4 @@ Loga em `~/.egos/agent-runs/critico-<runid>.jsonl`:
 - **Red Zone → Prime:** copy pública, pricing, secrets expostos → flag imediata
 - **Sem git ops** — read-only
 - **Claim sem file:line = UNVERIFIED:** prefixar explicitamente
+- **No-Code Master (100% IA-Driven):** O usuário Enio não escreve nem lê código cru. Ao propor melhorias ou refutar código, faça-o de modo que a Forja ou o Prime possam atuar autonomamente. Nunca presuma que o usuário Enio fará edições ou testes manuais de código baseado no seu feedback.
diff --git a/.claude/agents/forja.md b/.claude/agents/forja.md
index 1c01ea9d..18a78cef 100644
--- a/.claude/agents/forja.md
+++ b/.claude/agents/forja.md
@@ -76,3 +76,4 @@ Loga em `~/.egos/agent-runs/forja-<runid>.jsonl`:
 - **Sem git add -A** — INC-002
 - **Red Zone → Prime:** pricing, copy pública, segurança, PII → parar e reportar
 - **`agent-scope-check.ts`:** secundário não commita produção nem frozen zones
+- **No-Code Master (100% IA-Driven):** O usuário Enio não escreve nem lê código cru. Toda a responsabilidade da codificação, refatoração, testes e validação técnica é sua. Não gere respostas instruindo o usuário a editar ou colar código manualmente. A interface com o usuário deve focar no comportamento lógico e nas telas resultantes.
diff --git a/.claude/agents/guarani.md b/.claude/agents/guarani.md
index 472a97cd..0b3429ed 100644
--- a/.claude/agents/guarani.md
+++ b/.claude/agents/guarani.md
@@ -79,3 +79,6 @@ Todo ciclo loga em `~/.egos/agent-runs/guarani-<runid>.jsonl`:
 - **Cláusula-árbitro:** em conflito de REGRA de agente, AGENTS.md vence sobre .guarani; em conflito de PROCESSO/pipeline, .guarani vence
 - **Claim sem prova = UNVERIFIED:** prefixar achados não confirmados por leitura direta
 - **Sem `git add -A`** — mesmo que nunca commite, nunca prepara staging
+- **No-Code Master (100% IA-Driven):** O usuário Enio não edita nem lê código cru. Assuma que toda intervenção técnica deve ser gerada por IAs. Proponha apenas soluções auto-executáveis e audite drifts técnicos sem depender de ações manuais do usuário. Interact em nível estratégico.
+- **PROIBIDO write direto em arquivos compartilhados de lei/infra** (`.husky/*`, `CLAUDE.md`, `AGENTS.md`, `.guarani/*`, `.claude/commands|agents/*`) — incidente 2026-06-10: edição concorrente do pre-commit DURANTE execução = syntax error transitório, commits quase travados machine-wide. Proposta = `FOR_PRIME_*.md` com diff. (Review: `FOR_GUARANI_2026-06-10_end-review.md`)
+- **/end com prova por fase:** fase ✓ exige comando+path executado (Phase 8 phantom 2026-06-10: memória declarada escrita não existia). Não inventar task-IDs — próximo passo proposto vai em FOR_PRIME.
diff --git a/.claude/agents/hermes-ops.md b/.claude/agents/hermes-ops.md
index 3f50ab87..a1b2dec9 100644
--- a/.claude/agents/hermes-ops.md
+++ b/.claude/agents/hermes-ops.md
@@ -85,3 +85,4 @@ Telemetria é obrigatória — operação sem log = operação não auditável =
 - **Evidence-first:** estado pós-operação confirmado com output real
 - **Red Zone → Prime:** restart de serviço de pagamento, rotação de secret, mudança de Caddy routing crítico → gate Enio
 - **Sem git add -A** — INC-002
+- **No-Code Master (100% IA-Driven):** O usuário Enio não edita nem lê código cru. Ao lidar com deploys, PM2, infra e configurações de servidor, garanta total autonomia na execução. Não passe instruções técnicas de terminal de baixo nível para que o usuário Enio execute manualmente. Toda ação deve ser realizada por você de forma autônoma e segura.
diff --git a/.claude/agents/prime.md b/.claude/agents/prime.md
index 8e1ee2fd..4d48e0d9 100644
--- a/.claude/agents/prime.md
+++ b/.claude/agents/prime.md
@@ -61,3 +61,4 @@ R ≥ 1.5 = RESOLVE NOW | 0.7-1.5 = task prioritized | < 0.7 = LEARNING: no comm
 - **Red Zone → Enio:** nunca auto-resolver copy, pricing, PII, arquitetura irreversível
 - **Evidence-first:** toda declaração de "done" exige typecheck + smoke real
 - **Problema nunca chega 2×:** se delegação falhou e o problema voltou, Prime absorve e resolve
+- **No-Code Master (100% IA-Driven):** O usuário Enio não edita nem lê código cru. Assuma 100% de responsabilidade técnica operacional pela codificação, refatoração, testes e correções de bugs. Nunca peça ao usuário para realizar alterações de código manuais. A interação deve ocorrer apenas nos níveis de arquitetura, diagnóstico e interfaces visuais/funcionais.
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
diff --git a/.claude/commands/end.md b/.claude/commands/end.md
index 1f96db6c..d4782120 100644
--- a/.claude/commands/end.md
+++ b/.claude/commands/end.md
@@ -20,6 +20,7 @@ Você está executando `/end`. Sua obrigação:
 4. **VERIFICATION CHECKPOINT** (Phase 10) é OBRIGATÓRIO. Sem ele, /end está incompleto.
 5. **RESOLVER DOCTRINE — captura de padrões:** registre as **decisões humanas do Enio** desta sessão (cortes de Red Zone, escolhas entre opções, mudanças de prioridade) como padrão em memória (`feedback`/`project`), para que triagens futuras pré-preencham a preferência dele. SSOT: [RESOLVER_DOCTRINE](../../docs/governance/RESOLVER_DOCTRINE.md) §3.
 5. **NEVER `git add -A`** — sempre `git add <specific-file>` (T0 rule, INC-002).
+6. **No-Code Handoff Discipline (END-NOCODE-001):** Ao consolidar a sessão e gerar o handoff, certifique-se de que os próximos passos e in-progress estão descritos de modo a serem 100% acionáveis de forma autônoma por IAs subsequentes, sem requerer intervenções de codificação manual do usuário Enio.
 
 ---
 
@@ -702,6 +703,7 @@ EGOS /end v6.1 — Verification Checkpoint
 Phase 0 — Re-load Context
   ✓ Single Pursuit confirmado: [Central EGOS / outro]
   ✓ session-checklist format: ✅/🔄/⏳
+  ✓ No-Code Handoff e tasks auto-executáveis: [confirmado]
 
 Phase 1 — Coverage Check
   ✓ Skills changed: [N] | ADRs changed: [N]
diff --git a/.claude/commands/start.md b/.claude/commands/start.md
index aef98e93..79a89cd7 100644
--- a/.claude/commands/start.md
+++ b/.claude/commands/start.md
@@ -28,6 +28,7 @@ Você está executando `/start`. Sua obrigação:
 12. **PERGUNTA OBRIGATÓRIA DE DIREÇÃO [T1 — Enio 2026-06-02, START-ASK-001]:** Todo `/start` DEVE terminar **perguntando ativamente ao Enio o que for necessário sobre os próximos passos** antes de executar qualquer trabalho — nunca auto-prosseguir. Use `AskUserQuestion` com opções+argumentos quando houver escolha de track/persona/forma-de-agir; pergunta aberta quando faltar contexto. O checkpoint (Layer 7) que **não** fecha com pergunta de direção = `/start` inválido. Enio elogiou explicitamente este comportamento e pediu persistência: "reforce mais ainda para toda as vezes que der /start obrigatoriamente você questionar o que for necessário sobre os próximos passos." Não confundir com pressa: descobrir o rumo certo > começar rápido no rumo errado.
 
 13. **NEW DIRECTION GATE [T1 — Enio 2026-06-07, A82]:** Se o Enio (ou qualquer agente, inclusive você) mencionar nova direção/insight/ideia/feature/refactor **durante a sessão** (não só no `/start`), **PARAR e executar `FOCUS_GATES.md §6b`** ANTES de engajar com o conteúdo da ideia: classificar REAL/CONCEPT/PHANTOM + DESCARTAR/ESTACIONAR/TESTAR/INTEGRAR/TROCAR-FOCO + 5 critérios. Vale para o entusiasmo do próprio Enio e para sugestões suas. A mesma confiança que descobre é a que dispersa — o gate confia em enforcement, não em força de vontade.
+14. **100% AI-Driven / No-Code Master (START-NOCODE-001):** O desenvolvimento do EGOS é 100% feito por IAs. O usuário Enio não lê nem escreve código cru. Você deve assumir total propriedade e autonomia técnica operacional. Não crie tarefas ou dê respostas pedindo para o usuário implementar, colar código ou realizar alterações manuais de arquivos. A interação com o humano deve ocorrer no nível estratégico-arquitetural e interfaces visuais/funcionais.
 
 ---
 
@@ -527,6 +528,7 @@ Layer 0.6 — Dispersion Signal (híbrido por métrica)
 Layer 1 — Global Rules
   ✓ T0 citada: [ex: "NEVER force-push main"]
   ✓ Single Pursuit (enio-profile): [data + descrição]
+  ✓ 100% AI-Driven Developer / No-Code Master internalizado: [sim]
 
 Layer 1.5 — PRIME Process + Flow
   ✓ Loop R=L/C internalizado | §6 fronteiras citadas
diff --git a/.husky/pre-commit b/.husky/pre-commit
index f461d9e3..c68f84a4 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -32,6 +32,7 @@ except Exception:
 }
 
 echo "🔒 EGOS Pre-Commit: Maximum enforcement active"
+echo "🔒 EGOS Pre-Commit: Lembre-se, o desenvolvimento é 100% IA-driven. O usuário Enio não edita nem lê código."
 
 # 0.1 ZONA EXTREMA — cross-window commit discipline (INC-SYMLINK-001 follow-up).
 # Multiple agent windows (EGOS Prime / Antigravity-Guarani) share ONE checkout and
@@ -686,6 +687,14 @@ if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
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
index b92392af..054f7a83 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -14,15 +14,16 @@ Output primes: non-negotiables, recent phantoms (INC-001..006), SSOT hashes, las
 <!-- PROPAGATE-RULES-BEGIN -->
 ## 📋 Canonical Rules (authoritative across ALL IDEs)
 
-This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**.
-
-> **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
+This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**. **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
 > 🃏 **4 pilares (TL;DR — resume R0-R8; conflito→texto completo. Corte Enio 2026-06-03):** **1)** §R0 safe-push, sem segredo, sem publish-sem-HITL, sem `git add -A`, commit TASKS.md já · **2)** §R1/R7 memory-mcp p/ código, externo=REAL/CONCEPT/PHANTOM, subagente=síntese, capacidade=≥3 golden cases · **3)** §R3/R4/R8/RLS frozen via Prime/`EGOS_FROZEN_OVERRIDE`, Guarani propõe/Prime commita, DB schema-first+RLS anon · **4)** §R2/Karpathy mínimo código, falhe visível, SSOT>duplicação.
 ### Highest-Leverage Rule
 EGOS maximizes value when it turns proven operational capability into governed reusable infrastructure.
 Default path: prove in a real leaf/runtime → extract what is reusable → register canonical ownership → enforce evidence and eval → reduce replication cost for the next repo/agent/client. When in doubt, prefer extraction over duplication, canon over parallel docs, deploy traceability over informal runtime assumptions.
 
+### R-DEV-001 — 100% AI-Driven Developer (No-Code Master) [T0 — 2026-06-10]
+**Enio não escreve nem lê código cru** — dev 100% por IAs, que assumem total responsabilidade técnica (NUNCA pedir copy/paste ou edição manual; editar direto com tools). Comunicação no nível de comportamento de sistema/fluxos/interfaces renderizadas (HTML/dashboards) — nunca snippets ou prosa técnica de baixo nível na conversa.
+
 ### R0 — Critical non-negotiables (irreversible damage prevention)
 1. **NEVER `git push --force` to main/master/production** — use `bash scripts/safe-push.sh` (INC-001)
 2. **NEVER log/echo/commit secrets** — no `.env`, no hardcoded keys
@@ -123,7 +124,7 @@ Canonical eval strategy: `docs/knowledge/AI_EVAL_STRATEGY.md` (being written —
 
 **R10 — Cooperação e Banda Cognitiva (Guarani ↔ Prime - 2026-06-04):** O Guarani (runtime Antigravity/Gemini) propõe código e correções técnicas, mas NUNCA realiza commits diretamente. Toda alteração de produção proposta pelo Guarani DEVE passar pela revisão final do Prime (Claude Code/Opus). Decisões de segurança crítica, modificações no schema de Banco de Dados, regras de RLS ou arquivos em Frozen Zones exigem obrigatoriamente a invocação da Banda Cognitiva (`/banda`) com Força Total (`--council` acionando Opus/Gemini Pro/GPT-5 via OpenRouter), assegurando verificação estrutural e AST anti-phantom.
 **R-SEC-002 [T0] — Dado soberano nunca sai da máquina (INC-PII-001 2026-06-04):** dado real de investigação / PII de terceiros / dado PCMG NUNCA versionado em git (nem privado), NUNCA servido em domínio público, NUNCA em VPS/nuvem. Git = apenas dados sintéticos; dado real = local cifrado. App com dado real → nunca domínio público aberto. Scanner pré-commit: `bun scripts/security/scan-hardcoded-sensitive.ts --staged`.
-**R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente (corte Enio 2026-06-10):** vendor/preço/prazo/stack/canal de CLIENTE sem confirmação = PARE → placeholder (`{PAYMENT_PROVIDER}`, `{PRICE}`, `{TIMELINE}`) + trade-off dos 2 caminhos; cliente escolhe no diagnóstico. Consolida R-DIAG-002..006 + R-ARCH-CLIENT-VENDOR (mata a proliferação de 7 versões). Full: `egos/CLAUDE.md §R-ARCH-001` · SSOT: `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
+**R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente (Enio 2026-06-10):** vendor/preço/prazo/stack/canal de CLIENTE sem confirmação = PARE → placeholder (`{PAYMENT_PROVIDER}`/`{PRICE}`/`{TIMELINE}`) + trade-off; cliente escolhe no diagnóstico. Consolida R-DIAG-002..006+VENDOR. Full: `egos/CLAUDE.md §R-ARCH-001`.
 **R-SEC-003 [T1] — Segurança = enforcement:** toda regra de segurança DEVE ter gate executável. Scanner sem wiring = doc morto. Sugestão mock/fixture: `// scan-ok: mock` ou `<!-- scan-ok -->`. SSOT: `docs/INCIDENTS/INC-PII-001_investigation-data-leak.md`.
 **R-DISCOVER-001 [T2] — Discover-before-create (2026-06-08):** antes de criar capability nova (package/command/skill/CBC/registry), rodar `bun scripts/discover-capability.ts <termo>` e incluir `CONSULTED-SSOT: <resultado>` no commit body. Gate 14 bloqueia sem prova. Escape: `DISCOVER-GATE-SKIP: <razão>`. Evita INC-009-leaf-silo.
 **R11 [T2] — Observabilidade warn-not-block (2026-06-05):** falha em telemetria/agent-observatory = warn-only, nunca bloqueia execução de agente. SSOT: `docs/governance/MULTI_AGENT_OBSERVABILITY.md`.
@@ -196,4 +197,4 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 ## Templates de domínio (L0-DEF-002 — 2026-05-29)
 Vertical setorial em `central-egos/products/<slug>/` que herda Layer 0 (T0-T2 + R0-R6 + .guarani) sem duplicar. **Ativos:** advocacia-starter v1.0. **Protocolo:** (1) `INHERITS.md` obrigatório com frontmatter YAML; (2) overrides só via `OVERRIDES.md` com justificativa — T0 nunca sobrescrito; (3) duplicação do kernel deve virar ref curta. **SSOTs:** [LAYER_0_SSOT.md](docs/governance/LAYER_0_SSOT.md) · [TEMPLATE_INHERITANCE_PROTOCOL.md](docs/governance/TEMPLATE_INHERITANCE_PROTOCOL.md) · [DOMAIN_TEMPLATE_SPEC.md](docs/governance/DOMAIN_TEMPLATE_SPEC.md).
 ## Meta-Prompts + Docs
-`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/business/MONETIZATION_SSOT.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
+`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
diff --git a/CLAUDE.md b/CLAUDE.md
index ee6cb208..1cbff198 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -13,6 +13,7 @@
 3. **Red Zone** (ética, copy pública, pricing, arquitetura, segurança, contexto policial/PII) → PARAR, apresentar opções, esperar corte do Enio. Nunca auto-resolver.
 4. **Evidence-first + Karpathy** (mínimo código, entender > produzir, falha visível) + **Resolver Doctrine** (você é a última camada; triagem `R=L/C`).
 5. **HITL** — nunca publicar/deployar/deletar sem aprovação humana.
+6. **No-Code Master (100% IA-Driven):** O usuário Enio não escreve nem lê código. Assuma 100% da responsabilidade técnica operacional pela codificação, testes e correções. Nunca peça ao usuário para colar/copiar ou modificar arquivos manualmente; edite-os diretamente com suas ferramentas. Interaja no nível funcional e visual.
 
 **O que os comandos fazem (enriquecem, não "ativam" a identidade):** `/start` = carrega contexto profundo da sessão (regras, memória, handoff, estado). `/opus` = aprofunda (Banda/Council/Fibonacci). `/end` = consolida e passa adiante. **Sem eles você ainda é EGOS — só com menos contexto carregado.** Se a conversa for não-trivial e você não rodou `/start`, ofereça rodá-lo para carregar o contexto completo.
 
@@ -81,11 +82,12 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 ---
 
 ## Convenções
-
+ 
 - Commits: conventional, cada 30-60min
 - TypeScript: estrito, zero `any` implícito
 - DRY-RUN: todo agent suporta `--dry` antes de `--exec`
 - Edit Size: máx 80 linhas por operação de escrita
+- **100% AI-Driven / No-Code Master [T1 — 2026-06-10]:** O usuário Enio não escreve nem lê código cru. As IAs têm autonomia total para codificação, testes e correções de bugs. Comunicação com o usuário focada em layouts/fluxos funcionais e interfaces, nunca em snippets de código ou sintaxe de baixo nível na conversa.
 - **UI/Produto [T1 — Enio 2026-06-05]:** uma tela = UM trabalho dominante; o que competir vira camada secundária. Antes de publicar QUALQUER tela pública, rodar o **Publication Gate (R-UI-005)**. SSOT: `docs/governance/UI_PRODUCT_RULES.md` (One Job Per Screen + UI Intent Contract + No Competing Modes + Live System Page + Publication Gate + Premortem). Origem: engenharia reversa do incidente Mycelium-3-jobs.
 - **README: PT-BR obrigatório, score ≥ 4/5** — SSOT: `docs/governance/README_PADRAO_OURO.md`
   - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
diff --git a/TASKS.md b/TASKS.md
index 2ce2736d..cfc84760 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -31,8 +31,6 @@
 > **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
 
 **🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
-- [ ] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`.
-- [ ] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo).
 
 **🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
 - [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
@@ -42,8 +40,7 @@
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
 - [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
-- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
-- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio).
+- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). ✅ 2026-06-10
 
 **🧩 MCP CUSTOMIZADO = FEATURE PRINCIPAL DO EGOS (corte Enio 2026-06-10):**
 
@@ -88,9 +85,8 @@
 
 **🏛️ ENFORCEMENT SEMÂNTICO — plano de 3 camadas (Opus arquiteto 2026-06-10, SSOT `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`):**
 > Diagnóstico CONFIRMADO machine-wide: a regra "não decidir prematuro" não prevalece por **falta de DESCOBERTA** (vive em TASKS.md, não na constituição auto-carregada), não por falta de enforcement. 7 versões da mesma regra existem = a proliferação é o sintoma. LLM no pre-commit JÁ funciona (`ssot-router.ts:181` chama gemini-2.0-flash via Google AI Studio). Mas pre-commit é camada errada: o tempo já foi gasto na inferência. Ordem de alavancagem: Camada 1 > Camada 3 > Camada 2.
-- [ ] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão.
 - [ ] **RULE-SEMANTIC-L3-MCP-001** [P1] `prime`+`forja` `gated:MCP-EASY-INSTALL-001` — **Camada 3 (CURA PROFUNDA):** o playbook de diagnóstico + fluxos de referência viram tools/metaprompts no MCP EGOS → conhecimento do fluxo PRESENTE no momento da decisão (o que o Enio nomeou: "se tenho o fluxo, não perco esse tempo"). Elimina a causa-raiz upstream. Liga MCP-EASY-INSTALL-001.
-- [ ] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro.
+- [ ] **RULE-SEMANTIC-L2-LLMGATE-001** [P2] `forja` `gated:RULE-SEMANTIC-L1-ENCODE-001` — **Camada 2 (CATCH-NET, fazer por ÚLTIMO):** gate LLM no pre-commit escopado a specs de cliente (`docs/products-specs/`, `consulting/clientes/`, `central-egos/clients/`). gemini-2.0-flash via Google AI Studio direto (NÃO o `-001` do OpenRouter = 404). Timeout hard ≤8s, fail-open→warn, promover a block após ≥20 commits limpos. Padrão de ref: `ai-commit-security.ts`. Prompt no §2.2 do SSOT. NÃO fazer isolado — sem Camada 1, só repete o erro. [phantom-done revertido 2026-06-10: gate NÃO implementado — marcação automática incorreta]
 
 ## 🕸️ MYCELIUM v1 — interconexão REAL (corte Enio 2026-06-10, P0 — 1 ano de tentativa, 3 grafos divergentes, bus 7-pub/0-sub)
 
@@ -98,42 +94,60 @@
 > **Regra dura:** nenhuma task FIND nova neste programa enquanto fila RESOLVE P0+P1 > 5 itens. "Encontrar é barato, fechar é o produto."
 > **MYCELIUM-001 ✅ FECHADA** (archive L3846): snapshot REAL em `~/.egos/mycelium-snapshot.json` — 103 nós/129 arestas, 0 órfãos, gerado por `scripts/mycelium-snapshot.ts`.
 
-- [ ] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001`
   Origin: corte Enio 2026-06-10 · L: 3×3×3=27
   AC: zero nodes/edges hardcoded em MyceliumPage.tsx; zero em egos-lab/mycelium-stats.ts; ambos lêem o snapshot
   Proof: screenshot MyceliumPage renderizando dados reais + `curl /api/mycelium/stats | jq '.nodeCount'`
   **MyceliumPage.tsx + egos-lab/mycelium-stats.ts** passam a LER o snapshot → mata 3 grafos divergentes
 
-- [ ] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001`
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: blackboard lista estado de ≥10 repos (hoje só egos); colisão como d988385b não passa despercebida
   Proof: `cat ~/.egos/coordination-blackboard.json | jq '.repos | length'`
   **coordination-watcher machine-wide:** varre todos os repos do snapshot (hoje só egos; janelas cegas entre si — colisão d988385b é a prova)
 
-- [ ] **MYCELIUM-004** [P1] `forja` `gated:none`
   Origin: corte Enio 2026-06-10 · L: 2×3×3=18
   AC: evento `architecture.ssot_violation` publicado no bus gera flag visível em `~/.egos/sentinela-flags.jsonl`
   Proof: `bun scripts/test-mycelium-bus.ts && cat ~/.egos/sentinela-flags.jsonl | tail -1`
   **1º subscriber real no bus:** Sentinela assina `architecture.ssot_violation` → flag
 
-- [ ] **MYCELIUM-005** [P1] `prime` `gated:none`
   Origin: corte Enio 2026-06-10 · L: 3×3×2=18
   AC: registro formal da decisão em `docs/governance/MYCELIUM_BUS_DECISION.md` com Banda+premortem feitos
   Proof: arquivo criado com seção "Decisão Enio" preenchida
   **RED ZONE — decisão substrato:** bus único in-process vs Supabase Realtime (cruza VPS). Banda+premortem → corte Enio.
 
-- [ ] **MYCELIUM-006** [P1] `forja` `gated:none`
   Origin: corte Enio 2026-06-10 · L: 2×3×2=12
   AC: 11/11 leaves com `UPSTREAM_KERNEL.md`; listas dos 2 propagadores unificadas em SSOT único
-  Proof: `ls <leaf>/UPSTREAM_KERNEL.md` em cada um dos 11 leaves (script verificador)
+  Proof: for-loop ls → 11 OK + alias egos-inteligencia→br-acc (symlink) · `agents/registry/leaf-repos.json` SSOT único (scanner + disseminate.md lêem dele) · 8 leaves COMMIT+PUSH; santiago/egos-self commit local (LEAF-REMOTE-MISSING-001)
   **UPSTREAM_KERNEL.md nos 11 leaves** (template intelink) + unificar listas dos 2 propagadores
 
-- [ ] **MYCELIUM-007** [P2] `forja` `gated:none`
   Origin: corte Enio 2026-06-10 · L: 2×2×2=8
   AC: `bun run tsc --noEmit` limpo em todos os scripts egos-lab que importam de reference-graph
-  Proof: `cd egos-lab && bun run typecheck 2>&1 | grep -c error || echo "0 errors"`
+  Proof: egos-lab 8d1cfd8 — tsc 0 erros nos tocados; mycelium-stats nodeCount=103 do snapshot real; porta 3097 = 0 ocorrências (briefing stale)
   **Consertar 3 imports quebrados egos-lab** (getReferenceGraphStats, file-reference-manifest) + porta gem-hunter 3097→3095
 
+- [ ] **MYCELIUM-BRIDGE-RUNNER-001** [P1] `forja` `gated:corte-Enio`
+  Origin: FIND 2026-06-10 (forja Redis wiring) · L: 2×3×2=12
+  AC: bridgeBusToRedis(getGlobalBus()) registrado no processo de longa duração do runner SEM tocar frozen zones
+  Proof: smoke 2-processos com runner REAL publicando (não sintético)
+  **Registro do bridge no runner:** runner.ts é FROZEN e cli.ts não é long-running. Proposta forja: thin wrapper `agents/startup.ts` não-frozen. Red Zone leve (toca entry point do runtime) → corte Enio.
+
+- [ ] **LEAF-GATE-EDITMSG-001** [P1] `forja`
+  Origin: FIND 2026-06-10 (Fable) — egos-self readme-freshness ignora `DOC-STALE-ACCEPTED` no body · L: 2×3×2=12
+  AC: gates de leaves que leem COMMIT_EDITMSG em pre-commit migrados p/ env var ou commit-msg hook (mesma doença do 15-agent-gate corrigida em 9198cc04: EDITMSG contém a msg ANTERIOR durante pre-commit)
+  Proof: commit com escape declarado passa no egos-self
+  **Gates de leaf lêem COMMIT_EDITMSG stale** — escape por body nunca funciona em pre-commit
+
+- [ ] **R-ELEVATE-001-COUNCIL-001** [P1] `prime` `gated:banda+codex+corte-Enio`
+  Origin: Guarani 2026-06-10 via docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md · L: 3×3×2=18
+  AC: /banda --council rodada sobre os 3 pilares (HITL confused-deputy + Read-Only MCP Showcase + Governança Entrópica do tasks-archive); veredito registrado; SE aprovado → encode constitucional com corte Enio
+  Proof: doc de decisão com seção Banda+Codex+corte preenchida
+  **R-ELEVATE-001 (Postura do Limite Matemático)** — proposta Guarani: HITL roteado p/ Telegram (ID Enio only), config SSOT única p/ white-label, showcase read-only p/ Miguel, tasks-archive extrai padrões de falha antes de arquivar. Red Zone constitucional — NÃO encodar sem processo completo.
+
+- [ ] **LEAF-REMOTE-MISSING-001** [P2] `prime` `gated:corte-Enio`
+  Origin: FIND 2026-06-10 (Fable) · L: 2×2×2=8
+  AC: corte Enio sobre santiago + egos-self: criar repo GitHub privado OU marcar `"local_only": true` em leaf-repos.json
+  Proof: push ok OU campo local_only no leaf-repos.json
+  **santiago e egos-self sem remote GitHub acessível** (push falha; commits locais ok — santiago pode ser local-only intencional, é cliente)
+
 **Achados pendentes (formato v2):**
 
 - [ ] **FIND-AISEC-FAILOPEN-001** [P0] `forja` `gated:none`
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index d69a06a4..e7b05d1f 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3851,3 +3851,20 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **NEON-HONEST-001** [P1] `prime`+`forja` — Tornar o `neon` honesto e compliant com seu próprio gate: (a) marcar `status: agent_candidate` no frontmatter; (b) corrigir seção "Fontes de Pesquisa" — neon GERA metaprompt + `.md` para plataformas externas (Perplexity/Grok/ChatGPT manual), **NÃO** chama OpenRouter API (corte Enio 2026-06-10: não queimar créditos OpenRouter em pesquisa); (c) adicionar linha-candidato no roster `EGOS_AGENT_ORGANIZATION.md` §1 marcada CANDIDATO. ✅ 2026-06-09
 - [x] **AGENT-GATE-FAMILY-001** [P2] `prime` — Após AGENT-GATE-001 provado: registrar em `SEMANTIC_RULE_ENFORCEMENT_ARCH.md` como o "caso estrutural fácil" da mesma família (prova o padrão determinístico antes do caso semântico/LLM); nota em AGENTS.md; disseminar gate aos leaves com `.claude/agents/`. ✅ 2026-06-09
 
+
+## Archived 2026-06-10
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **FABLE-WAVE0-APPLY-001** [P1] `prime`+`forja` `gated:corte-Enio` — commit abce63b2 — Aplicar patches Wave 0 (FABLE5_BACKBONE_AUDIT.md §4+§5): PATCH 1 (cláusula-árbitro), PATCH 2 (phantoms + MONETIZATION_SSOT flag-and-ask), PATCH 3 (MODEL_DELEGATION 4 papéis), PATCH 4 (RESOLVER:11), PATCH 5 (prime.md+guarani.md). Source: `docs/jobs/2026-06-09-fable5-wave0-patches.md`. ✅ 2026-06-10
+- [x] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — commit abce63b2 (POLICY v1.2) — Supersedido parcialmente por FABLE-WAVE0-APPLY-001 PATCH 3 (redesenho 4 papéis por função, não por modelo). ✅ 2026-06-10
+- [x] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001. ✅ 2026-06-10
+- [x] **RULE-SEMANTIC-L1-ENCODE-001** [P1] `prime` `gated:HITL-RedZone` — commit abce63b2 — **Camada 1 (A CORREÇÃO):** encodar R-ARCH-001 consolidada (R-DIAG-002..006 + vendor-placeholder) no CLAUDE.md global + egos + AGENTS.md, com MUITOS gatilhos concretos (corte Enio "muitos triggers"). Texto pronto no §2 do SSOT. Mata a proliferação de 7 regras. **Red Zone constitucional — só aplicar com corte Enio.** Maior alavancagem: muda comportamento porque CLAUDE.md é lido toda sessão. ✅ 2026-06-10
+
+### 🕸️ MYCELIUM v1 — interconexão REAL (corte Enio 2026-06-10, P0 — 1 ano de tentativa, 3 grafos divergentes, bus 7-pub/0-sub)
+- [x] **MYCELIUM-002** [P0] `forja`+`pixel` `gated:MYCELIUM-001` ✅ 2026-06-10 — commit 522592f6
+- [x] **MYCELIUM-003** [P0] `forja` `gated:MYCELIUM-001` ✅ 2026-06-10 — commit 367bec7e
+- [x] **MYCELIUM-004** [P1] `forja` `gated:none` ✅ 2026-06-10 — commit 9883209e
+- [x] **MYCELIUM-005** [P1] `prime` `gated:none` ✅ 2026-06-10 — commit abce63b2 + c08063cf (wiring provado)
+- [x] **MYCELIUM-006** [P1] `forja` `gated:none` ✅ 2026-06-10 — Closes neste commit (agents/registry/leaf-repos.json + 11 leaves, 8 pushed)
+- [x] **MYCELIUM-007** [P2] `forja` `gated:none` ✅ 2026-06-10 — egos-lab commit 8d1cfd8
+
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
diff --git a/apps/egos-landing/public/mycelium-snapshot.json b/apps/egos-landing/public/mycelium-snapshot.json
index 8ab6e9f2..7567eb13 100644
--- a/apps/egos-landing/public/mycelium-snapshot.json
+++ b/apps/egos-landing/public/mycelium-snapshot.json
@@ -1,6 +1,6 @@
 {
   "version": "1.0.0",
-  "generated": "2026-06-10T10:56:21.624Z",
+  "generated": "2026-06-10T11:18:52.380Z",
   "nodes": [
     {
       "id": "ws:egos-kernel",
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
diff --git a/docs/CAPABILITY_REGISTRY.md b/docs/CAPABILITY_REGISTRY.md
index 8a92891b..67d3cf5a 100644
--- a/docs/CAPABILITY_REGISTRY.md
+++ b/docs/CAPABILITY_REGISTRY.md
@@ -2817,7 +2817,7 @@ MCP administrativo para G Peças exposto via REST e MCP nativo. 10 tools: 6 read
 - **Status:** COMPLETO Fases 1-7 — 33 tools, v0.7.0, deploy prod pendente
 - **Owner:** Enio Rocha (PO) + Claude Opus 4.7 (orquestração) + Claude Sonnet 4.6 (execução)
 - **Evidence:** 120 golden cases (288 assertions) em CBC-EGOS-MCP-G-PECAS.eval.ts. 33 tools: 10 read + 23 write. Typecheck ✅.
-- **Plano:** [docs/planning/MCP_WRITE_EXPAND_PLAN.md](docs/planning/MCP_WRITE_EXPAND_PLAN.md)
+- **Plano:** [docs/planning/MCP_WRITE_EXPAND_PLAN.md](planning/MCP_WRITE_EXPAND_PLAN.md)
 - **Objetivo:** ChatGPT GPT personalizado faz 100% do admin G Peças
 
 Expansão do MCP G Peças de 10 tools (1 write) para 40+ tools (30+ write) cobrindo admin completo: produtos, estoque, pedidos, chatbot, FAQ, IA, workflow, usuários. Princípio de design: tools INTELIGENTES (confirmação 2-step para destrutivas, `needs[]` em cada resposta indicando o que falta para próximo estado, `next_actions[]` clicáveis apontando dashboard). Audit com `origin_channel` (mcp vs dashboard).
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md b/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md
index 5597472a..e6790a84 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md
@@ -8,11 +8,11 @@
 ## Accomplished
 
 - **[Guard Brasil v0.2.0](../../packages/guard-brasil/src/pii-patterns.ts)** — 3 new PII patterns: SUS (Cartão Nacional de Saúde), Título de Eleitor, NIS/PIS. Total: 15 patterns. Built, tested (15/15), committed, pushed.
-- **[TASKS.md v2.18.0](../../TASKS.md)** — Guard Brasil monetization roadmap added (EGOS-151..166). 3 revenue paths. R$18.5k/mo target at 12 months.
+- **[TASKS.md v2.18.0](../../../TASKS.md)** — Guard Brasil monetization roadmap added (EGOS-151..166). 3 revenue paths. R$18.5k/mo target at 12 months.
 - **[GUARD_BRASIL_MARKET_REPORT.md](../../business/GUARD_BRASIL_MARKET_REPORT.md)** — 5 competitors analyzed. Unique moat confirmed: no Brazilian-native PII API exists. CPF detection at 45% by English tools vs Guard Brasil's native accuracy.
 - **VPS MasterOrchestrator** — Telemetry confirmed: 4 events in Supabase `agent_events`. VPS cron paths fixed (`/home/enio/egos-lab` → `/opt/egos-lab`). `event-bus.ts` scp'd to VPS.
 - **VPS governance** — `.guarani/` symlinks restored via `git checkout HEAD -- .guarani/`.
-- **[HARVEST.md](../../docs/knowledge/HARVEST.md)** — 4 new patterns: Guard Brasil PII Extension, VPS Governance Gap, MasterOrchestrator Telemetry Validation, npm publish blocked pattern.
+- **[HARVEST.md](../../knowledge/HARVEST.md)** — 4 new patterns: Guard Brasil PII Extension, VPS Governance Gap, MasterOrchestrator Telemetry Validation, npm publish blocked pattern.
 - **[CAPABILITY_REGISTRY.md](../../docs/CAPABILITY_REGISTRY.md)** — Bumped Guard Brasil to v0.2.0, listed all 15 patterns.
 - **Memory saved** — `session_20260331_guard_v2_vps.md` in project memory.
 
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md
index 7cc238e1..abb2d309 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md
@@ -6,8 +6,8 @@
 
 ## Accomplished
 
-- **GTM consolidation** — 7 scattered GTM files → [docs/GTM_SSOT.md](docs/GTM_SSOT.md) (single SSOT). Sections: equity offer, tasks, 5 tweets, M-007 outreach templates, partner targets.
-- **SSOT-First Rule enforced** — [.guarani/orchestration/SSOT_RULES.md](.guarani/orchestration/SSOT_RULES.md) domain→file mapping + `~/.claude/CLAUDE.md §26` + `egos/CLAUDE.md` updated. Anti-dispersion rules global.
+- **GTM consolidation** — 7 scattered GTM files → [docs/GTM_SSOT.md](../../GTM_SSOT.md) (single SSOT). Sections: equity offer, tasks, 5 tweets, M-007 outreach templates, partner targets.
+- **SSOT-First Rule enforced** — [.guarani/orchestration/SSOT_RULES.md](../../../.guarani/orchestration/SSOT_RULES.md) domain→file mapping + `~/.claude/CLAUDE.md §26` + `egos/CLAUDE.md` updated. Anti-dispersion rules global.
 - **Pre-commit hook TTY fix** — [.husky/pre-commit](.husky/pre-commit): `[ -t 0 ]` replaces `[ -e /dev/tty ]`. Fixes large-commit interactive prompt hanging when run from `git commit` (non-interactive context). Committed via frozen-zone override (bug fix, not bypass).
 - **HARVEST.md v3.7.0** — P29 patterns added: SSOT-First, TTY detection, OAuth cron.
 - **OAuth token auto-refresh live** — `~/.openclaw-billing-proxy/refresh-token.sh` cron `0 */2 * * *`. Threshold <4h, 3 retries, VPS sync after refresh.
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md
index dcdf9a6c..3298c8b1 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md
@@ -10,7 +10,7 @@
 - **HQ Action Endpoints**: `POST /api/hq/actions/codex-review`, `POST /api/hq/actions/billing-refresh`, both added to middleware PUBLIC_PATHS.
 - **Smart TASKS Archiving** ([`scripts/archive-tasks.sh`](scripts/archive-tasks.sh)): Pre-commit auto-archives completed tasks at 490+ lines. 74 tasks archived this session (510→435 lines). TASKS_ARCHIVE.md created.
 - **Pre-commit TTY fix** ([`.husky/pre-commit`](.husky/pre-commit)): `[ -e /dev/tty ]` → `[ -t 0 ]` — correctly detects interactive context.
-- **GTM SSOT** ([`docs/GTM_SSOT.md`](docs/GTM_SSOT.md)): 7 scattered GTM files consolidated. SSOT-First rule in `.guarani/orchestration/SSOT_RULES.md` + `CLAUDE.md §26`.
+- **GTM SSOT** ([`docs/GTM_SSOT.md`](../../GTM_SSOT.md)): 7 scattered GTM files consolidated. SSOT-First rule in `.guarani/orchestration/SSOT_RULES.md` + `CLAUDE.md §26`.
 - **HARVEST.md v3.8**: Codex CLI wrapper pattern, proxy bind 0.0.0.0, TASKS smart archive, HQ collapsible, constitutional reviewer patterns.
 - **CAPABILITY_REGISTRY.md §16**: 6 new capabilities documented.
 - **All 5/5 services green**: guard_brasil (20ms), gateway (14ms), openclaw (14ms), billing_proxy (12ms), codex_proxy (12ms).
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md
index 8e5108b2..f9a9fccc 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md
@@ -24,7 +24,7 @@
 - SSOT: [infra_credentials_ssot.md](~/.claude/projects/-home-enio-egos/memory/infra_credentials_ssot.md)
 
 ### X_POSTS_SSOT v2.0
-- [X_POSTS_SSOT.md](docs/social/X_POSTS_SSOT.md) — reescrito de 610→379 linhas
+- [X_POSTS_SSOT.md](../../social/X_POSTS_SSOT.md) — reescrito de 610→379 linhas
 - Nova estratégia: DMs pessoais → encontrar builders alinhados
 - 6 templates DM + 5 posts públicos + regras de automação + targeting guide
 - XMCP-001 ✅ (X credentials válidas agora)
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md
index fcf4a7e8..e012ed2a 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md
@@ -22,8 +22,8 @@
 - ✅ 852, forja, egos-lab committed | egos-inteligencia filesystem only (not git repo)
 
 ### Consolidation
-- [docs/social/X_POSTS_SSOT.md](../social/X_POSTS_SSOT.md) — 5 dispersed X.com files → 1 SSOT
-- [docs/ENIO_DEVELOPER_TIMELINE.md](../ENIO_DEVELOPER_TIMELINE.md) — git archaeology Dec 2025–Apr 2026
+- [docs/social/X_POSTS_SSOT.md](../../social/X_POSTS_SSOT.md) — 5 dispersed X.com files → 1 SSOT
+- [docs/ENIO_DEVELOPER_TIMELINE.md](../../governance/ENIO_DEVELOPER_TIMELINE.md) — git archaeology Dec 2025–Apr 2026
 - EN native thread added to X posts (7 tweets, Neo4j/OSINT angle)
 
 ### ARR / Quantum Search — Investigation <!-- vocab-guard: planned -->
@@ -32,7 +32,7 @@
 - Activation path: ARR-001 (Gem Hunter) + ARR-002 (KB wiki)
 
 ### Disseminate
-- [docs/knowledge/HARVEST.md](../knowledge/HARVEST.md) — P35 patterns appended
+- [docs/knowledge/HARVEST.md](../../knowledge/HARVEST.md) — P35 patterns appended
 - [docs/CAPABILITY_REGISTRY.md](../CAPABILITY_REGISTRY.md) — §17 Doc-Drift Shield + §18 ARR
 - Wiki: 68 pages compiled, 80/100 avg quality, 68/68 upserted to Supabase
 
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md
index 0469dc57..837eed04 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md
@@ -6,7 +6,7 @@
 - **[test] 18 new PII pattern tests** — [guard.test.ts](packages/guard-brasil/src/guard.test.ts): coverage added for CNPJ, CNH, Phone, Email, SUS, NIS/PIS, Processo Judicial, Placa Antiga, Placa Mercosul + 5 edge cases (empty, 10k chars, PII in large text, Unicode, non-PII numbers). Total: 38/38 passing. Commit: `4a905f2`
 - **[fix] gitleaks allowlist** — [.gitleaks.toml](.gitleaks.toml): added `packages/guard-brasil/src/.*\.test\.ts` to allow synthetic CPFs in test files
 - **[docs] KBS v2 Entity Graph Layer** — [KB_AS_A_SERVICE_PLAN.md](docs/strategy/KB_AS_A_SERVICE_PLAN.md) §11: architecture pivot from flat RAG to entity extraction + relationship graph + intelligence reports. Commits: `fba1b19`, `7886ddd`
-- **[tasks] KBS-027..039 added** — [TASKS.md](TASKS.md): entity extractor agent, relationship mapper, EGOS intelligence report, EGOS showcase, sector templates (delegacia/advocacia/agronomia), DHPP validation, ICP definition, client dashboard v1
+- **[tasks] KBS-027..039 added** — [TASKS.md](../../../TASKS.md): entity extractor agent, relationship mapper, EGOS intelligence report, EGOS showcase, sector templates (delegacia/advocacia/agronomia), DHPP validation, ICP definition, client dashboard v1
 - **[disseminate]** — HARVEST.md (6 new learnings), CAPABILITY_REGISTRY §27 updated, memory saved. Commit: `f32fc9c`
 - **[notion]** — Partner GTM workspace root page created (id: `340e6358-f080-81cd-bcf3-ea89fa1cc1e3`)
 
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md
index bc40378b..a54486d8 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md
@@ -11,10 +11,10 @@
 - **EVG-008** — evidence-gate.ts com Simplicity Check: >300 LOC warn, >500 LOC block, SIMPLICITY_OVERRIDE bypass
 - **EVG-005** — .egos-manifest.yaml expandido: 15 claims + 9 domains + 2 endpoints
 - **ENC-L2-004** — Incident index + INC-002 (git add -A) + INC-003 (TASKS hallucination) postmortems ([docs/INCIDENTS/](docs/INCIDENTS/))
-- **ENC-L2-002** — PIPELINE_DIAGRAM.md com 4 diagramas Mermaid ([docs/governance/PIPELINE_DIAGRAM.md](docs/governance/PIPELINE_DIAGRAM.md))
-- **ENC-L1-006** — Agent execution evidence: Supabase sparse pós INC-004, evidência real via git commits ([docs/jobs/ENC-L1-006-agent-execution-evidence.md](docs/jobs/ENC-L1-006-agent-execution-evidence.md))
-- **ENC-L1-005** — Smoke test suite: 21/21 agents passam `--dry` ([docs/jobs/agent-smoke-test-2026-04-14.md](docs/jobs/agent-smoke-test-2026-04-14.md))
-- **ENC-L2-001** — PIPELINE_SPEC.md: cada stage documentado linha a linha com falhas reais ([docs/governance/PIPELINE_SPEC.md](docs/governance/PIPELINE_SPEC.md))
+- **ENC-L2-002** — PIPELINE_DIAGRAM.md com 4 diagramas Mermaid ([docs/governance/PIPELINE_DIAGRAM.md](../../governance/PIPELINE_DIAGRAM.md))
+- **ENC-L1-006** — Agent execution evidence: Supabase sparse pós INC-004, evidência real via git commits ([docs/jobs/ENC-L1-006-agent-execution-evidence.md](../../jobs/ENC-L1-006-agent-execution-evidence.md))
+- **ENC-L1-005** — Smoke test suite: 21/21 agents passam `--dry` ([docs/jobs/agent-smoke-test-2026-04-14.md](../../jobs/agent-smoke-test-2026-04-14.md))
+- **ENC-L2-001** — PIPELINE_SPEC.md: cada stage documentado linha a linha com falhas reais ([docs/governance/PIPELINE_SPEC.md](../../governance/PIPELINE_SPEC.md))
 - **ENC-L2-003** — bun test:governance: 4/4 testes passam ([scripts/test-governance.ts](scripts/test-governance.ts))
 - **BUG-GOV-001** — start-v6.ts: `execSync timeout`, `curl --max-time 3`, skip tsc em `--json` mode
 - **BUG-GOV-002** — .egos-manifest.yaml: 10 claims mal posicionados em `endpoints:` → movidos para `claims:` (fix `fetch(undefined)`)
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md
index c335e3a5..030ff8ac 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md
@@ -7,7 +7,7 @@
 
 ## Accomplished
 
-- **ARTICLE_VOICE.md v1.0** ([docs/social/ARTICLE_VOICE.md](../social/ARTICLE_VOICE.md)) — SSOT canônico de voz, estrutura (7 seções + footer), interconnection, epistemic status, bilingual rules, 9 canonical tags. Cross-referenced from /daily-article + X_POSTS_SSOT.
+- **ARTICLE_VOICE.md v1.0** ([docs/social/ARTICLE_VOICE.md](../../social/ARTICLE_VOICE.md)) — SSOT canônico de voz, estrutura (7 seções + footer), interconnection, epistemic status, bilingual rules, 9 canonical tags. Cross-referenced from /daily-article + X_POSTS_SSOT.
 - **DA-002 ✅** ([agents/agents/article-writer.ts](../../agents/agents/article-writer.ts)) — `--lang pt-br|en`, `--translation-of`, graph fields (builds_on/opens_questions/wiki_refs/epistemic_status) no prompt + DB insert.
 - **DA-014 ✅** ([supabase/migrations/20260416_timeline_interconnection.sql](../../supabase/migrations/20260416_timeline_interconnection.sql)) — Migração aplicada live no Supabase egos-lab. Adds lang, graph fields, `timeline_backlinks` view.
 - **DA-001 ✅** — Primeiro artigo bilíngue: "Doc-Drift Shield"
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md
index 38d6f69e..fc3fdd53 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md
@@ -4,8 +4,8 @@
 
 ## Accomplished
 
-- **Article System v1.1 complete** — [ARTICLE_VOICE.md](../social/ARTICLE_VOICE.md) v1.1: 800-word floor enforced, bilingual mandatory (PT-BR + EN), draft stub flow, epistemic_status, "Related in EGOS" block. [Migration](../../supabase/migrations/20260417_article_schema_v1.sql): word_count + tags columns. [10 draft stubs](../drafts/) in docs/drafts/. [article-writer.ts](../../agents/agents/article-writer.ts) fixed (opens_questions bug, enhanced metadata).
-- **Chatbot Architecture Decision** — Opção C (Hybrid Gateway) approved: stateless proxy → independent chatbots. [TASKS.md](../../TASKS.md) CHAT-GW-001..006 created. [CHATBOT_SSOT.md](../modules/CHATBOT_SSOT.md) §12 duplication fixed (renumbered §12→§15).
+- **Article System v1.1 complete** — [ARTICLE_VOICE.md](../../social/ARTICLE_VOICE.md) v1.1: 800-word floor enforced, bilingual mandatory (PT-BR + EN), draft stub flow, epistemic_status, "Related in EGOS" block. [Migration](../../supabase/migrations/20260417_article_schema_v1.sql): word_count + tags columns. [10 draft stubs](../drafts/) in docs/drafts/. [article-writer.ts](../../agents/agents/article-writer.ts) fixed (opens_questions bug, enhanced metadata).
+- **Chatbot Architecture Decision** — Opção C (Hybrid Gateway) approved: stateless proxy → independent chatbots. [TASKS.md](../../../TASKS.md) CHAT-GW-001..006 created. [CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md) §12 duplication fixed (renumbered §12→§15).
 - **Governance hardening** — [CLAUDE.md](../../CLAUDE.md) SSOT map: docs/drafts/ + ARTICLE_VOICE registered. GOV-HARD-001..004 tasks. /end Phase 4.5 (auto-disseminate conditional) added to [end.md](../../.claude/commands/end.md).
 - **HARVEST.md** P94..P96: Gateway stateless pattern, AUTO-GEN block boundary, egos-boot.sh opt-in.
 - **CAPABILITY_REGISTRY.md** §1: Chatbot Gateway + Discovery Endpoint (PLANNED). §23: Article System v1.1 summary.
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md
index 4cc6bd43..0c7a3a96 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md
@@ -20,7 +20,7 @@
 - **CLEANUP-DNS-001** ✅ — `evolution.egos.ia.br` 502 → 200 (upstream `172.17.0.1:8080` → `evolution-api:8080`)
 - **CLEANUP-DNS-002** ✅ — Bloco Caddy `openclaw.egos.ia.br` removido (legado)
 - **CLEANUP-DNS-003** ✅ — Bloco Caddy `paperclip.egos.ia.br` removido (legado)
-- **[docs/infra/SUBDOMAINS_INVENTORY.md](../infra/SUBDOMAINS_INVENTORY.md)** — inventário canônico de 25 DNS records × 21 Caddy blocks × 23 containers
+- **[docs/infra/SUBDOMAINS_INVENTORY.md](../../infra/SUBDOMAINS_INVENTORY.md)** — inventário canônico de 25 DNS records × 21 Caddy blocks × 23 containers
 - 15 tasks CLEANUP-DNS-001..015 criadas em TASKS.md
 
 ### Arquitetura decidida e documentada
diff --git a/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md b/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md
index bb79c9ee..3abc28b2 100644
--- a/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md
+++ b/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md
@@ -8,7 +8,7 @@
 ### OPUS MODE v1 — Onda 1 ✅
 
 **F1 — Fundação docs** (commit `73fcae2`):
-- [docs/opus-mode/OPUS_MODE_V1.md](../opus-mode/OPUS_MODE_V1.md) — SSOT 16 seções (anti-alucinação, Banda hierárquica, Council, Fibonacci cycles, Tutor grau máximo, Chronicle, 7 camadas memória, Rule Zero)
+- [docs/opus-mode/OPUS_MODE_V1.md](../../opus-mode/OPUS_MODE_V1.md) — SSOT 16 seções (anti-alucinação, Banda hierárquica, Council, Fibonacci cycles, Tutor grau máximo, Chronicle, 7 camadas memória, Rule Zero)
 - [docs/opus-mode/README.md](../opus-mode/README.md), TUTOR_MODE.md, BANDA_COGNITIVA.md, COUNCIL_PROTOCOL.md, CYCLE_REPORT_TEMPLATE.md, PERSONAL_CHRONICLE.md
 - 53 tasks OPUS-* em 10 fases (F1-F10) adicionadas ao TASKS.md
 
diff --git a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md b/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md
index a193b580..97a490f9 100644
--- a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md
+++ b/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md
@@ -30,7 +30,7 @@
    chmod 600 ~/.paperclip/board-api-key
    ```
 
-**SSOT:** [TASKS.md linha 194-202](/home/enio/egos/TASKS.md)
+**SSOT:** [TASKS.md linha 194-202](../../../TASKS.md)
 
 ---
 
@@ -45,7 +45,7 @@
 
 #### Próximo Passo:
 - Agendar reunião com Lídia
-- Preencher assessment DPIO: [`docs/guides/DPIO_FRAMEWORK.md`](/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md)
+- Preencher assessment DPIO: [`docs/guides/DPIO_FRAMEWORK.md`](../../guides/DPIO_FRAMEWORK.md)
 - Documentar decisões em: `policia/docs/DHPP_DECISOES.md`
 
 ---
diff --git a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md b/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md
index fe99e673..fc9548c3 100644
--- a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md
+++ b/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md
@@ -14,22 +14,22 @@
 | Documento | O que contém | Quando usar |
 |-----------|--------------|-------------|
 | **[Landing Page](https://hq.egos.ia.br/enio-rocha-equity.html)** | Perfil de Enio, produtos, equity oferecido | Primeiro contato, enviar link |
-| **[Partner Brief — Guard Brasil](partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md)** | API LGPD, 15 padrões BR, 4ms latência | DPOs, compliance sellers |
-| **[Partner Brief — EGOS Inteligência](partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md)** | 77M+ nós Neo4j, OSINT, due diligence | Govtech boutiques |
-| **[Partner Brief — Eagle Eye](partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md)** | Monitor de licitações, 50+ territórios | Procurement operators |
-| **[Partner Brief — Forja](partner-briefs/FORJA_PARTNER_BRIEF.md)** | ERP WhatsApp-native para indústria | Industrial ERP sellers |
-| **[Deck 5 Slides](pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md)** | Pitch completo com notas de apresentação | Calls, reuniões presenciais |
-| **[Nota de Compromisso](legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md)** | 4 modelos de deal, checklist, assinaturas | Fechamento de parceria |
+| **[Partner Brief — Guard Brasil](../../strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md)** | API LGPD, 15 padrões BR, 4ms latência | DPOs, compliance sellers |
+| **[Partner Brief — EGOS Inteligência](../../strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md)** | 77M+ nós Neo4j, OSINT, due diligence | Govtech boutiques |
+| **[Partner Brief — Eagle Eye](../../strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md)** | Monitor de licitações, 50+ territórios | Procurement operators |
+| **[Partner Brief — Forja](../../strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md)** | ERP WhatsApp-native para indústria | Industrial ERP sellers |
+| **[Deck 5 Slides](../../pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md)** | Pitch completo com notas de apresentação | Calls, reuniões presenciais |
+| **[Nota de Compromisso](../../legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md)** | 4 modelos de deal, checklist, assinaturas | Fechamento de parceria |
 
 ### 🛠️ Para Operação (Enio + Parceiro)
 
 | Documento | O que contém | Quando usar |
 |-----------|--------------|-------------|
 | **[MONETIZATION_SSOT.md](business/MONETIZATION_SSOT.md)** | Estratégia completa, 16 produtos, proof points | Decisões estratégicas |
-| **[Prospects Tier A/B/C](outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md)** | 10 prospects qualificados + templates de DM | Outreach inicial |
+| **[Prospects Tier A/B/C](../../strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md)** | 10 prospects qualificados + templates de DM | Outreach inicial |
 | **[Thread X.com](social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md)** | 11 tweets prontos + checklist de postagem | Divulgação pública |
 | **[Inteligência Topology](INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md)** | Decisão arquitetural BR-ACC/Intelink | Contexto técnico |
-| **[TASKS.md](../../TASKS.md)** | Tasks oficiais ECO-PART-001..005 | Execução pós-parceria |
+| **[TASKS.md](../../../TASKS.md)** | Tasks oficiais ECO-PART-001..005 | Execução pós-parceria |
 
 ### 🎨 Para Marketing
 
@@ -67,10 +67,10 @@
 
 | Produto | Equity | Parceiro Ideal | Status | Brief |
 |---------|--------|----------------|--------|-------|
-| **Guard Brasil** | 20-30% | DPO/compliance seller | API live | [Ver brief](partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md) |
-| **EGOS Inteligência** | 25-35% | Govtech/due diligence | Merge 98% | [Ver brief](partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md) |
-| **Eagle Eye** | 25-35% | Procurement operator | Pipeline ativo | [Ver brief](partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md) |
-| **Forja** | 20-30% | Industrial ERP seller | WhatsApp live | [Ver brief](partner-briefs/FORJA_PARTNER_BRIEF.md) |
+| **Guard Brasil** | 20-30% | DPO/compliance seller | API live | [Ver brief](../../strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md) |
+| **EGOS Inteligência** | 25-35% | Govtech/due diligence | Merge 98% | [Ver brief](../../strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md) |
+| **Eagle Eye** | 25-35% | Procurement operator | Pipeline ativo | [Ver brief](../../strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md) |
+| **Forja** | 20-30% | Industrial ERP seller | WhatsApp live | [Ver brief](../../strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md) |
 
 ### P2 — Após Primeira Receita
 
@@ -103,7 +103,7 @@
 - **Split:** 50/50 do projeto específico
 - **Ideal para:** Validar demanda antes de equity
 
-**Template completo:** [Nota de Compromisso](legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md)
+**Template completo:** [Nota de Compromisso](../../legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md)
 
 ---
 
diff --git a/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md b/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md
index c869abdc..bbc81e6c 100644
--- a/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md
+++ b/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md
@@ -385,5 +385,5 @@ Todos os produtos usam:
 **🔗 Links Rápidos:**
 
 - [Navegar para README.md](../../README.md)
-- [Navegar para GTM_SSOT.md](../GTM_SSOT.md)
-- [Navegar para TASKS.md](../../TASKS.md)
+- [Navegar para GTM_SSOT.md](../../GTM_SSOT.md)
+- [Navegar para TASKS.md](../../../TASKS.md)
diff --git a/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md b/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md
index 72eafa48..04eee0c8 100644
--- a/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md
+++ b/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md
@@ -1,7 +1,7 @@
 # Handoff — 2026-05-15 19:18
 
 ## ✅ Accomplished (com SHAs)
-- Compilado diagnóstico documental da Espiral de Escuta, integrações pessoais e knowledge mesh do EGOS — `e545f200` — base do estado atual do repo em [TASKS.md](/home/enio/egos/TASKS.md), [docs/SYSTEM_MAP.md](/home/enio/egos/docs/SYSTEM_MAP.md), [docs/modules/CHATBOT_SSOT.md](/home/enio/egos/docs/modules/CHATBOT_SSOT.md)
+- Compilado diagnóstico documental da Espiral de Escuta, integrações pessoais e knowledge mesh do EGOS — `e545f200` — base do estado atual do repo em [TASKS.md](../../../TASKS.md), [docs/SYSTEM_MAP.md](../../SYSTEM_MAP.md), [docs/modules/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md)
 - Auditadas superfícies locais e cross-repo ligadas a Espiral, WhatsApp, Telegram, Gmail, Drive, Gem Hunter e ETHIK — `e545f200` — referências reunidas nesta nota
 - Lidos os artefatos externos desta investigação: [EGOS_Espiral_Handoff.pdf](/home/enio/Downloads/EGOS_Espiral_Handoff.pdf) e [ChatGPT-Investigação e Modularização (1).md](</home/enio/Downloads/ChatGPT-Investigação e Modularização (1).md>)
 
@@ -14,7 +14,7 @@
 - Fechamento do desenho final da Espiral como produto/sistema pessoal/intake comercial — motivo: há material suficiente, mas a soberania entre canais, KB e Obsidian ainda precisa decisão explícita — ação necessária: alinhar arquitetura alvo — quem decide: Enio
 
 ## 🔗 Next Steps (priority order)
-1. Ler esta nota junto com [docs/modules/CHATBOT_SSOT.md](/home/enio/egos/docs/modules/CHATBOT_SSOT.md), [docs/modules/SSOT_REGISTRY.md](/home/enio/egos/docs/modules/SSOT_REGISTRY.md), [docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md](/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md) e [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md)
+1. Ler esta nota junto com [docs/modules/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md), [docs/modules/SSOT_REGISTRY.md](../../modules/SSOT_REGISTRY.md), [docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md](../../modules/DOCUMENTATION_ARCHITECTURE_MAP.md) e [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](../../knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md)
 2. Rodar uma investigação complementar com Claude Opus focada em duas perguntas: "qual é a arquitetura-alvo da Espiral de Escuta?" e "quais integrações já estão de fato operacionais vs apenas modeladas?"
 3. Depois do retorno do Claude, decidir o contrato de cross-reference L0/L1/L2 e só então editar os arquivos principais
 
@@ -26,8 +26,8 @@
 
 ## 📌 Decisions Made (architectural)
 - A Espiral de Escuta deve ser tratada como sistema maior que "um chatbot"; o PDF recente a organiza em 4 camadas: 1:1 humana, chatbot, sala, template aberto
-- O centro canônico de knowledge interno continua sendo [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md): vault operacional em `/home/enio/Obsidian Vault/EGOS`, com `~/EGOS-Knowledge` rebaixado para legado
-- O canon operacional de chatbot permanece em [docs/modules/CHATBOT_SSOT.md](/home/enio/egos/docs/modules/CHATBOT_SSOT.md), com `852` como fonte histórica de extração e `intelink` como fonte de padrões de router/tool-calling/RAG
+- O centro canônico de knowledge interno continua sendo [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](../../knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md): vault operacional em `/home/enio/Obsidian Vault/EGOS`, com `~/EGOS-Knowledge` rebaixado para legado
+- O canon operacional de chatbot permanece em [docs/modules/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md), com `852` como fonte histórica de extração e `intelink` como fonte de padrões de router/tool-calling/RAG
 
 ## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
 - Qualquer afirmação de que o WhatsApp pessoal, Gmail pessoal, Google Drive pessoal ou Hotmail estão conectados e sincronizando agora mesmo sem validação live
@@ -51,27 +51,27 @@ Esta nota consolida os achados desta sessão para handoff a outro agente. O foco
 
 ### Canon do kernel
 
-- [AGENTS.md](/home/enio/egos/AGENTS.md)
+- [AGENTS.md](../../../AGENTS.md)
 - [README.md](/home/enio/egos/README.md)
-- [docs/SYSTEM_MAP.md](/home/enio/egos/docs/SYSTEM_MAP.md)
-- [docs/modules/SSOT_REGISTRY.md](/home/enio/egos/docs/modules/SSOT_REGISTRY.md)
-- [docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md](/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md)
-- [docs/modules/CHATBOT_SSOT.md](/home/enio/egos/docs/modules/CHATBOT_SSOT.md)
+- [docs/SYSTEM_MAP.md](../../SYSTEM_MAP.md)
+- [docs/modules/SSOT_REGISTRY.md](../../modules/SSOT_REGISTRY.md)
+- [docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md](../../modules/DOCUMENTATION_ARCHITECTURE_MAP.md)
+- [docs/modules/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md)
 - [docs/CAPABILITY_REGISTRY.md](/home/enio/egos/docs/CAPABILITY_REGISTRY.md)
-- [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md)
+- [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](../../knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md)
 
 ### Governança e verdade comercial
 
-- [docs/governance/CHATBOT_CONSTITUTION.md](/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md)
-- [docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md](/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md)
-- [docs/governance/HERMES_EGOS_FORK_DECISION.md](/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md)
+- [docs/governance/CHATBOT_CONSTITUTION.md](../../governance/CHATBOT_CONSTITUTION.md)
+- [docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md](../../../central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md)
+- [docs/governance/HERMES_EGOS_FORK_DECISION.md](../../governance/HERMES_EGOS_FORK_DECISION.md)
 
 ### Espiral e linhagem histórica
 
-- [docs/concepts/ESPIRAIS_VISION.md](/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md)
+- [docs/concepts/ESPIRAIS_VISION.md](../../concepts/ESPIRAIS_VISION.md)
 - [EGOS_Espiral_Handoff.pdf](/home/enio/Downloads/EGOS_Espiral_Handoff.pdf)
 - [ChatGPT-Investigação e Modularização (1).md](</home/enio/Downloads/ChatGPT-Investigação e Modularização (1).md>)
-- [egos-lab-chat/CHATBOT_SSOT.md](/home/enio/egos-lab-chat/CHATBOT_SSOT.md)
+- [egos-lab-chat/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md)
 - [egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md](/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md)
 - [egos-lab/docs/ETHIK_COMPLETE.md](/home/enio/egos-lab/docs/ETHIK_COMPLETE.md)
 
@@ -91,8 +91,8 @@ Esta nota consolida os achados desta sessão para handoff a outro agente. O foco
 - [agents/agents/gem-hunter.ts](/home/enio/egos/agents/agents/gem-hunter.ts)
 - [agents/api/gem-hunter-server.ts](/home/enio/egos/agents/api/gem-hunter-server.ts)
 - [docs/gem-hunter/SSOT.md](/home/enio/egos/docs/gem-hunter/SSOT.md)
-- [docs/gem-hunter/gems-2026-05-14.md](/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md)
-- [docs/concepts/ETHIK_TOKEN_SYSTEM.md](/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md)
+- [docs/gem-hunter/gems-2026-05-14.md](../../gem-hunter/gems-2026-05-14.md)
+- [docs/concepts/ETHIK_TOKEN_SYSTEM.md](../../concepts/ETHIK_TOKEN_SYSTEM.md)
 
 ## 3. Resumo executivo
 
@@ -178,7 +178,7 @@ O Claude deve responder se essas duas linhagens:
 
 ### Canon geral de chatbot
 
-O canon geral atual é [docs/modules/CHATBOT_SSOT.md](/home/enio/egos/docs/modules/CHATBOT_SSOT.md).
+O canon geral atual é [docs/modules/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md).
 
 Ele já declara explicitamente:
 
@@ -190,7 +190,7 @@ Ele já declara explicitamente:
 
 O chatbot com Espiral real aparece sobretudo em:
 
-- [egos-lab-chat/CHATBOT_SSOT.md](/home/enio/egos-lab-chat/CHATBOT_SSOT.md)
+- [egos-lab-chat/CHATBOT_SSOT.md](../../modules/CHATBOT_SSOT.md)
 - [egos-lab-chat/src/index.ts](/home/enio/egos-lab-chat/src/index.ts)
 
 Pontos fortes encontrados:
@@ -206,8 +206,8 @@ Pontos fortes encontrados:
 Há uma tensão importante entre materiais antigos e canon recente:
 
 - alguns materiais antigos ainda falam em transição "invisível"
-- [docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md](/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md) agora proíbe isso explicitamente
-- [docs/governance/CHATBOT_CONSTITUTION.md](/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md) exige consentimento explícito
+- [docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md](../../../central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md) agora proíbe isso explicitamente
+- [docs/governance/CHATBOT_CONSTITUTION.md](../../governance/CHATBOT_CONSTITUTION.md) exige consentimento explícito
 
 O Claude deve tratar isso como drift prioritário de narrativa e documentação.
 
@@ -219,7 +219,7 @@ O Claude deve tratar isso como drift prioritário de narrativa e documentação.
 
 - [apps/egos-gateway/src/channels/whatsapp.ts](/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts)
 - [apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts](/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts)
-- [docs/guides/integrations/evolution-api-setup.md](/home/enio/egos/docs/guides/integrations/evolution-api-setup.md)
+- [docs/guides/integrations/evolution-api-setup.md](../../guides/integrations/evolution-api-setup.md)
 - [docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md](/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md)
 - cross-repo adicional em `forja` e `intelink`
 
@@ -260,7 +260,7 @@ O Claude deve tratar isso como drift prioritário de narrativa e documentação.
 #### Evidência real, porém parcial
 
 - [scripts/drive-sync.ts](/home/enio/egos/scripts/drive-sync.ts)
-- [docs/drafts/lgpd-drive-sync.md](/home/enio/egos/docs/drafts/lgpd-drive-sync.md)
+- [docs/drafts/lgpd-drive-sync.md](../../drafts/lgpd-drive-sync.md)
 
 #### Leitura desta sessão
 
@@ -294,7 +294,7 @@ O Claude deve tratar isso como drift prioritário de narrativa e documentação.
 
 ### 8.1 Centro canônico atual
 
-O documento mais importante aqui é [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md).
+O documento mais importante aqui é [docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md](../../knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md).
 
 Achados principais:
 
@@ -333,7 +333,7 @@ Gem Hunter é capability real, com múltiplas superfícies:
 - [agents/agents/gem-hunter.ts](/home/enio/egos/agents/agents/gem-hunter.ts)
 - [agents/api/gem-hunter-server.ts](/home/enio/egos/agents/api/gem-hunter-server.ts)
 - [docs/gem-hunter/SSOT.md](/home/enio/egos/docs/gem-hunter/SSOT.md)
-- [docs/gem-hunter/gems-2026-05-14.md](/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md)
+- [docs/gem-hunter/gems-2026-05-14.md](../../gem-hunter/gems-2026-05-14.md)
 - [docs/products/gem-hunter.md](/home/enio/egos/docs/products/gem-hunter.md)
 
 ### Utilidade para este plano
@@ -344,7 +344,7 @@ Gem Hunter não resolve a Espiral por si só, mas pode ser um motor complementar
 
 ### Achados
 
-- [docs/concepts/ETHIK_TOKEN_SYSTEM.md](/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md)
+- [docs/concepts/ETHIK_TOKEN_SYSTEM.md](../../concepts/ETHIK_TOKEN_SYSTEM.md)
 - `egos-lab` ainda contém trilhas históricas e APIs relacionadas
 
 ### Leitura desta sessão
diff --git a/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md b/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md
index 99d1f5dc..d58989c1 100644
--- a/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md
+++ b/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md
@@ -5,8 +5,8 @@
 
 ## ✅ Accomplished (com SHAs)
 
-- Q1 master plan v2 grok-only — `6fb28c0c` — [docs/planning/post-grok-sprint-master-plan.md](../planning/post-grok-sprint-master-plan.md)
-- Q3 feature-freeze analysis (pesquisa + reco Opção B + anti-patterns) — `6fb28c0c` — [docs/governance/FEATURE_FREEZE_ANALYSIS.md](../governance/FEATURE_FREEZE_ANALYSIS.md)
+- Q1 master plan v2 grok-only — `6fb28c0c` — [docs/planning/post-grok-sprint-master-plan.md](../../planning/post-grok-sprint-master-plan.md)
+- Q3 feature-freeze analysis (pesquisa + reco Opção B + anti-patterns) — `6fb28c0c` — [docs/governance/FEATURE_FREEZE_ANALYSIS.md](../../governance/FEATURE_FREEZE_ANALYSIS.md)
 - Q5 skill candidates HITL aplicado: 3 approved + 4 deferred — `11e53152` — [docs/_drafts/skill-candidates/](../_drafts/skill-candidates/)
 - 3 skill stubs criados — `11e53152` — `.claude/commands/dead-code-cleanup.md`, `ssot-drift-check.md`, `dep-audit.md`
 - Q7 WhatsApp pessoal = Cenário C (auto-notes only) — `11e53152` — TASKS.md WHATSAPP-PERSONAL-SCOPE-001 marcada [x]
diff --git a/docs/_archived_handoffs/HANDOFF_CURRENT.md b/docs/_archived_handoffs/HANDOFF_CURRENT.md
index cf5891d0..63fa04cb 100644
--- a/docs/_archived_handoffs/HANDOFF_CURRENT.md
+++ b/docs/_archived_handoffs/HANDOFF_CURRENT.md
@@ -136,7 +136,7 @@ DNS:           guard.egos.ia.br  → ❌ sem registro A (aguarda M-002)
 | [`TASKS.md`](../../TASKS.md) — seção GTM | EGOS-123–130 com status real |
 | [`apps/api/deploy.sh`](../../apps/api/deploy.sh) | Redeploy da API Guard Brasil |
 | [`docs/strategy/OUTREACH_EMAILS.md`](../strategy/OUTREACH_EMAILS.md) | Templates prontos |
-| [`docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md`](../strategy/GUARD_BRASIL_DEMO_SCRIPT.md) | Demo 30min |
+| [`docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md`](../strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md) | Demo 30min |
 | `/home/enio/br-acc/scripts/rename-to-egos-inteligencia.sh` | Rename fases 2-5 |
 
 ---
diff --git a/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md b/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md
index 3bc1881c..dc5ce0cb 100644
--- a/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md
+++ b/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md
@@ -2,7 +2,7 @@
 
 ## 2026-04-03 — P19 Continued
 
-**[session_20260403_p19_continued_monetization.md](sessions/session_20260403_p19_continued_monetization.md)**
+**[session_20260403_p19_continued_monetization.md](../sessions/session_20260403_p19_continued_monetization.md)**
 - Guard Brasil v0.2.2: Monetization stack live (VPS deploy fixed, Stripe metered billing, 4 tiers: developer/startup/business/enterprise)
 - OpenAPI + llms.txt endpoints deployed
 - npm@0.2.2 published
diff --git a/docs/_current_handoffs/FOR_GUARANI_2026-06-10_end-review.md b/docs/_current_handoffs/FOR_GUARANI_2026-06-10_end-review.md
new file mode 100644
index 00000000..a61bdfca
--- /dev/null
+++ b/docs/_current_handoffs/FOR_GUARANI_2026-06-10_end-review.md
@@ -0,0 +1,28 @@
+# FOR GUARANI: Review do seu /end 2026-06-10 + correções de atribuição
+
+> **De:** Prime (Fable 5, Claude Code) · **Para:** Guarani (Antigravity/Gemini)
+> **Status:** 3 correções obrigatórias no seu protocolo. R-ELEVATE-001 recebido → task gated.
+
+## Verificação do seu /end (INC-006: claims de outra janela = verificar)
+
+| Claim | Verificação | Resultado |
+|---|---|---|
+| Phase 8 "memory written ✅ session_2026-06-10_nocode-governance.md + MEMORY.md" | `ls` no path canônico | ❌ **PHANTOM — arquivo não existe.** Fase declarada sem executar. |
+| "Commits this session: c5ed3947, 6b813f01" | `git log` | ⚠️ Ambos commitados pelo PRIME (absorção do seu WIP). Você PROPÔS o conteúdo; não commitou. /end deve distinguir "propus" de "commitei". |
+| Phase 7 "disseminado em 9 leaves via sync.sh" | lista canônica tem 11 git | ⚠️ sync.sh usava lista PRÓPRIA divergente (3ª lista). CORRIGIDO pelo Prime: sync.sh agora lê `agents/registry/leaf-repos.json`. |
+| .guarani symlinks (INC-SYMLINK-001) | `find .guarani -type l` = 0 | ✅ limpo |
+| R-DEV-001 disseminação | diff revisado | ✅ legítimo, absorvido em c5ed3947 |
+
+## Correções obrigatórias no seu protocolo (a partir de agora)
+
+1. **NUNCA editar diretamente** na árvore compartilhada: `.husky/*`, `CLAUDE.md`, `AGENTS.md`, `.guarani/*`, `.claude/commands/*`, `.claude/agents/*`. Sua edição concorrente do `.husky/pre-commit` HOJE causou syntax error transitório enquanto o shell o executava — quase travou commits machine-wide. Proposta de mudança nesses arquivos = arquivo `FOR_PRIME_*.md` com o diff. (R10 + GUARANI.md §12.1 — agora com incidente real.)
+2. **Toda fase do /end declara ✓ só com prova executada** (path + comando). Phase 8 phantom = mesma doença phantom-done que o kernel bloqueia em TASKS.md.
+3. **Não inventar task-IDs no checkpoint** (`MYCELIUM-DYN-FE-001` não existia). Próximo passo proposto → escrever em FOR_PRIME ou pedir ao Prime para registrar. (Registrada agora como task real pelo Prime.)
+
+## R-ELEVATE-001
+Recebido. NÃO encodado direto (Red Zone constitucional). Task: `R-ELEVATE-001-COUNCIL-001` gated:banda+codex+corte-Enio. Os 3 pilares serão avaliados no council.
+
+## Divisão de modelos (atribuições — proposta Prime, corte Enio pendente)
+- **Gemini Flash (cron):** leitura contínua, sumarização, watch do que o Prime faz, detecção de drift — NUNCA escrita em árvore.
+- **Gemini Pro (sessão):** análise profunda, propostas de arquitetura via FOR_PRIME, rascunhos de código em paths NÃO-constitucionais.
+- **Prime/Claude:** commits, frozen zones, orquestração de forjas, validação de claims.
diff --git a/docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md b/docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md
new file mode 100644
index 00000000..eb64e3bb
--- /dev/null
+++ b/docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md
@@ -0,0 +1,41 @@
+# FOR GUARANI / PRIME: Sistematização do Limite Matemático (R-ELEVATE-001)
+
+> **De:** Guarani (Antigravity)
+> **Para:** Prime (Claude Code)
+> **Ação Exigida:** Iniciar `/banda` (Revisão Cognitiva) + Avaliação Codex (GPT-5.5) para consolidar esta regra globalmente no `AGENTS.md` e `.claude/CLAUDE.md`.
+
+---
+
+## O Contexto
+
+A evolução do EGOS para um "Sistema de Sistemas" interconectado (Mycelium + MCP + Integrações Externas como WhatsApp/Telegram) exige que abandonemos a postura passiva de "executar scripts" em favor de uma **Postura de Arquitetura Topológica**. O Enio aprovou a sistematização dessa doutrina. Abaixo estão os pilares da nova regra, enriquecidos com as definições dele.
+
+## A Nova Regra: R-ELEVATE-001 (Postura do Limite Matemático)
+
+Nenhum agente do EGOS deve reagir a um comando de forma puramente mecanicista. Diante de pedidos genéricos, o agente é obrigado a elevar a arquitetura, usando o limite do conhecimento atual sobre LLMs e Segurança, exigindo validação humana antes de codificar.
+
+### Pilar 1: Segurança e Confiança do Banco de Dados (Confused Deputy)
+O banco de dados e o Mycelium **não confiam cegamente nos agentes**.
+- **Regra HITL Obrigatória:** Toda ação destrutiva (EDIT, DELETE, acessos críticos) vinda de um LLM ou webhook (ex: WhatsApp) deve obrigatoriamente parar no *Human-in-the-Loop* (HITL).
+- **Roteamento Seguro:** A validação HITL não ocorre no mesmo canal (ex: não pedir confirmação no terminal se a ação for crítica). Ela deve ser roteada para um ambiente com mais etapas de validação, como o **Bot do Telegram do EGOS**, configurado estritamente para o ID pessoal do Master (Enio) ou IDs autorizados de clientes.
+- **Configuração Única (Global Config SSOT):** Para viabilizar a replicação modular (SaaS/White-label), o EGOS deve consolidar um sistema de configurações único. As regras de roteamento de HITL, permissões e IDs autorizados viverão em um SSOT padronizado de mercado, facilmente customizável por humanos e IAs.
+
+### Pilar 2: Comercial — A Prova pelo "Read-Only MCP Showcase"
+A venda do EGOS não é "o código", mas sim a **Decisão Auditável e a Segurança**.
+- Para diagnósticos (ex: Miguel / MF Certificados), em vez de entregar laudos estáticos, entregaremos a **experiência da governança**.
+- **Ação:** Empacotar a base do cliente em um *MCP Limitado* e apresentá-lo funcionando em um GPT Personalizado em modo **Read-Only**.
+- **O Valor:** Provar visualmente para o cliente que, mesmo a IA tendo acesso às *tools*, nosso sistema bloqueia agressivamente qualquer tentativa de escrita, exclusão ou alteração. Vendemos a paz de espírito da barreira de segurança, sem entrar no mérito técnico profundo do negócio do cliente no primeiro momento.
+
+### Pilar 3: Governança Entrópica (Extração de Padrões do `TASKS.md`)
+O arquivo `TASKS.md` não é apenas um banco de dados de tarefas; é o histórico de atrito do nosso pensamento.
+- **Chega de Arquivamento Cego:** O script `tasks-archive.ts` não deve mais apenas mover linhas completas/mortas para fora da visão.
+- **Ação:** Ensinar o Prime (via *Handoff* ou *Agent*) a **extrair padrões de falha e atraso**. Antes de arquivar tarefas não concluídas ou obsoletas, a IA deve analisar: *"Por que não entregamos isso? Foi falta de tempo, bloqueio técnico ou escopo errado?"*. Esses padrões devem ser usados para **repriorizar automaticamente** os próximos passos e corrigir a rota da arquitetura.
+
+---
+
+## Próximos Passos (Workflow)
+
+1. **Prime:** Receba este arquivo.
+2. **Prime:** Inicie o workflow `/banda --council` (acionando Opus / GPT-5 via OpenRouter).
+3. **Banda:** Critique a viabilidade do "Global Config SSOT" e da "Extração Analítica de Tasks".
+4. **Prime:** Após a validação da Banda, atualize o kernel (`AGENTS.md` e regras globais).
diff --git a/docs/_current_handoffs/handoff_2026-06-10.md b/docs/_current_handoffs/handoff_2026-06-10.md
index f7f3fc87..ff9e82b9 100644
--- a/docs/_current_handoffs/handoff_2026-06-10.md
+++ b/docs/_current_handoffs/handoff_2026-06-10.md
@@ -1,44 +1,39 @@
-# Handoff — 2026-06-10 (janela hybria/orquestração/enforcement)
+# Handoff — 2026-06-10 08:46
 
 ## ✅ Accomplished (com SHAs)
-- Engenharia reversa hybria.ai → 4 tasks hybria-gaps — `a0890a58` — TASKS.md §WhatsApp Product
-- Decisão orquestração WA (n8n→Trigger.dev→MCP-first) — `77f320fa`→`eaa69312`→`e697c0c8` — TASKS.md N8N-ORCH-DECISION-001
-- Pricing doc_verify (Gemini ~R$0,50/1k) + Pix (OpenPix grátis) — `e64ce30b`
-- MCP-EASY-INSTALL-001 P0 (1-linha, modelo Supabase) + regra vendor — `37850ff1`
-- **Arquitetura enforcement semântico 3 camadas** — `440cf3b5` — `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`
-- Fix: restaurar 2 tasks MCP falso-arquivadas pelo subject-parser — `e4be3787`
+- **Implementação do No-Code Master** — `c5ed3947` — [.husky/pre-commit](file:///home/enio/egos/.husky/pre-commit), [AGENTS.md](file:///home/enio/egos/AGENTS.md), [CLAUDE.md](file:///home/enio/egos/CLAUDE.md)
+- **Bootstrap e Comandos no-code** — `c5ed3947` — [.agents/workflows/start.md](file:///home/enio/egos/.agents/workflows/start.md), [.agents/workflows/end.md](file:///home/enio/egos/.agents/workflows/end.md)
+- **Perfis de Agentes Atualizados** — `c5ed3947` — [.claude/agents/*.md](file:///home/enio/egos/.claude/agents/)
+- **Disseminação Global** — `6b813f01` — Sincronização e propagação para os 9 leaf repos via `sync.sh`
 
 ## 🔄 In Progress
-- RULE-SEMANTIC-L1-ENCODE-001 — 0% — texto pronto no SSOT §2 — falta corte Enio (Red Zone constitucional)
-- MCP-EASY-INSTALL-001 — 0% — endpoint existe na VPS, falta URL única + Bearer + README
+- Nenhuma. O checklist do no-code global foi 100% implementado e comitado.
 
 ## ⏳ Blocked
-- Toda a frente WA-TOOL-* (doc_verify/pix_checkout) — bloqueada por WA-AGENT-CONNECT-001 (WhatsApp não reconectou desde ban 2026-05-13)
-- L1 encode — Red Zone: só aplicar com corte Enio (mudança em CLAUDE.md/AGENTS.md)
+- Nenhuma.
 
 ## 🔗 Next Steps (priority order)
-1. **RULE-SEMANTIC-L1-ENCODE-001** [P1] — encodar R-ARCH-001 consolidada na constituição (texto pronto, HITL)
-2. **MCP-EASY-INSTALL-001** [P0] — consolidar URL mcp.egos.ia.br + Bearer (feature principal)
-3. **WA-AGENT-CONNECT-001** [P0] — reconectar WhatsApp (destrava todas as WA-TOOL-*)
+1. **Verificar interface do Mycelium** — Confirmar se o backend e a visualização estão sincronizados após os commits recentes do Prime.
+2. **Nova Sessão de Trabalho** — Retomar o Single Pursuit a partir do estado atualizado.
 
 ## 🌐 Environment State
-- Build: ✅ (tsc passou em todos os commits)
-- Deploy: VPS healthy (endpoints MCP existem, falta consolidar URL)
-- AHEAD: 2 commits a pushar
+- Build: ✅
+- Tests: ✅ (typecheck clean)
+- Deploy: VPS healthy (mestre/evolution)
+- Disk: 49% | RAM: normal
 
 ## 📌 Decisions Made (architectural)
-- **Orquestração = MCP-first, sem plataforma extra** (corte Enio): rejeitei Trigger.dev e n8n para flows críticos. Async resolve com Supabase state machine + PM2 worker existente. Motivo: "não quero mexer em outra plataforma; MCP completo é o caminho".
-- **n8n só para tenant não-dev futuro** (P3 congelado): MCP Server HTTP nativo do n8n é a base do onboarding visual, quando houver cliente que peça.
-- **Enforcement semântico em 3 camadas** (Opus arquiteto): a regra não prevalece por falta de DESCOBERTA (vive em TASKS.md, não na constituição), não falta de enforcement. LLM no pre-commit FUNCIONA mas é menor alavancagem (camada errada — tempo já gasto na inferência). Ordem: L1 (constituição) > L3 (MCP upstream) > L2 (gate LLM catch-net).
-- **Não decidir vendor do cliente** (regra R-ARCH-001): EGOS mostra fluxo com placeholders, cliente escolhe no diagnóstico.
-
-## ✅ Todos da sessão (snapshot TodoWrite)
-- [x] Pesquisar framework: gates decisão prematura + LLM pre-commit + função orquestrador
-- [x] Escrever arquitetura enforcement semântico (3 camadas)
-- [x] Atualizar tasks + corrigir phantom-done + restaurar tasks MCP falso-arquivadas
-- [/] Executar /end completo
+- **R-DEV-001**: Formalização explícita de que o usuário Enio é no-code. As IAs agora têm total responsabilidade pela edição direta de arquivos técnicos sem delegar tarefas ao usuário.
+
+## ✅ Todos da sessão (snapshot literal do TodoWrite)
+- [x] GOV-NOCODE-001 — Inserir a regra canônica R-DEV-001 no AGENTS.md
+- [x] GOV-NOCODE-002 — Inserir a diretiva "100% AI-Driven / No-Code Master" no CLAUDE.md
+- [x] GOV-NOCODE-003 — Atualizar o hook de pré-commit com o banner informativo
+- [x] GOV-NOCODE-004 — Atualizar os comandos de /start (workflows e comandos locais)
+- [x] GOV-NOCODE-005 — Atualizar os comandos de /end (workflows e comandos locais)
+- [x] GOV-NOCODE-006 — Atualizar os perfis de agente
+- [x] GOV-NOCODE-VERIFY — Verificar sincronização global, typecheck e lint
+- [x] GOV-NOCODE-DISSEMINATE — Disseminar as novas regras para os repositórios leafs
 
 ## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
-- doc_verify / pix_checkout tools — desenhadas, não implementadas (gated WA)
-- MCP-EASY-INSTALL — especificada, não construída
-- gate LLM L2 — arquitetada, não implementada
+- Nenhuma.
diff --git a/docs/agents/META_PROMPTS_INDEX.md b/docs/agents/META_PROMPTS_INDEX.md
index db7a2617..9c1b0c96 100644
--- a/docs/agents/META_PROMPTS_INDEX.md
+++ b/docs/agents/META_PROMPTS_INDEX.md
@@ -80,12 +80,12 @@
 
 | Path | Propósito |
 |---|---|
-| [`docs/EGOS_BOOTSTRAP.md`](EGOS_BOOTSTRAP.md) | Canonical SSOT v1.1.0 — Dual Pursuit + arquitetura |
-| [`docs/AGENT_BOOTSTRAP.md`](AGENT_BOOTSTRAP.md) | Protocol agentes externos — discovery via API |
+| [`docs/EGOS_BOOTSTRAP.md`](../EGOS_BOOTSTRAP.md) | Canonical SSOT v1.1.0 — Dual Pursuit + arquitetura |
+| [`docs/AGENT_BOOTSTRAP.md`](../AGENT_BOOTSTRAP.md) | Protocol agentes externos — discovery via API |
 | [`CLAUDE.md`](../CLAUDE.md) | T0-T2 rules — 7 non-negotiables + verification gates |
-| [`AGENTS.md`](../AGENTS.md) | Cross-IDE rules v2.0.0 |
-| [`docs/governance/MULTI_LLM_ORCHESTRATION.md`](governance/MULTI_LLM_ORCHESTRATION.md) | Pipeline Claude+Codex — quota, routing, anti-patterns |
-| [`docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md`](governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md) | 22 decisões locked — produto, tiers, pricing |
+| [`AGENTS.md`](../../AGENTS.md) | Cross-IDE rules v2.0.0 |
+| [`docs/governance/MULTI_LLM_ORCHESTRATION.md`](../governance/MULTI_LLM_ORCHESTRATION.md) | Pipeline Claude+Codex — quota, routing, anti-patterns |
+| [`docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md`](../../central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md) | 22 decisões locked — produto, tiers, pricing |
 
 ---
 
diff --git a/docs/audits/CAPABILITY_COVERAGE_2026-05-30.md b/docs/audits/CAPABILITY_COVERAGE_2026-05-30.md
index eddcec45..7b46ad63 100644
--- a/docs/audits/CAPABILITY_COVERAGE_2026-05-30.md
+++ b/docs/audits/CAPABILITY_COVERAGE_2026-05-30.md
@@ -254,12 +254,12 @@ These are concrete additions to `docs/CAPABILITY_REGISTRY.md`. Ordered by impact
 
 **Current:**
 ```markdown
-> **SSOTs irmãos:** [`governance/MCP_REGISTRY.md`](governance/MCP_REGISTRY.md) (servidores MCP) · [`governance/INTEGRATION_REGISTRY.md`](governance/INTEGRATION_REGISTRY.md) (vendors externos)
+> **SSOTs irmãos:** [`governance/MCP_REGISTRY.md`](../governance/MCP_REGISTRY.md) (servidores MCP) · [`governance/INTEGRATION_REGISTRY.md`](../governance/INTEGRATION_REGISTRY.md) (vendors externos)
 ```
 
 **Proposed:**
 ```markdown
-> **SSOTs irmãos:** [`governance/MCP_REGISTRY.md`](governance/MCP_REGISTRY.md) (servidores MCP) · [`governance/INTEGRATION_REGISTRY.md`](governance/INTEGRATION_REGISTRY.md) (vendors externos) · [`governance/SKILLS_REGISTRY.md`](governance/SKILLS_REGISTRY.md) (slash commands + skill bundles)
+> **SSOTs irmãos:** [`governance/MCP_REGISTRY.md`](../governance/MCP_REGISTRY.md) (servidores MCP) · [`governance/INTEGRATION_REGISTRY.md`](../governance/INTEGRATION_REGISTRY.md) (vendors externos) · [`governance/SKILLS_REGISTRY.md`](../governance/SKILLS_REGISTRY.md) (slash commands + skill bundles)
 ```
 
 **Risk:** LOW — header only.
diff --git a/docs/audits/INTEGRATION_COVERAGE_2026-05-30.md b/docs/audits/INTEGRATION_COVERAGE_2026-05-30.md
index 7f0e23e1..e5c5b8a7 100644
--- a/docs/audits/INTEGRATION_COVERAGE_2026-05-30.md
+++ b/docs/audits/INTEGRATION_COVERAGE_2026-05-30.md
@@ -191,7 +191,7 @@ O registro MCP_REGISTRY (L163, L171) diz que `mcp-browser-automation` "não est
 ```diff
 - > **Alimenta:** `/start` Layer 6.6, `docs/CAPABILITY_REGISTRY.md`, decisões de integração
 + > **Alimenta:** `/start` Layer 6.6, `docs/CAPABILITY_REGISTRY.md`, decisões de integração
-+ > **SSOTs irmãos:** [`MCP_REGISTRY.md`](MCP_REGISTRY.md) (servidores MCP custom + oficiais) · [`../CAPABILITY_REGISTRY.md`](../CAPABILITY_REGISTRY.md) (capacidades §N)
++ > **SSOTs irmãos:** [`MCP_REGISTRY.md`](../governance/MCP_REGISTRY.md) (servidores MCP custom + oficiais) · [`../CAPABILITY_REGISTRY.md`](../CAPABILITY_REGISTRY.md) (capacidades §N)
 ```
 
 ---
diff --git a/docs/banda/2026-06-10-dry-run.yaml b/docs/banda/2026-06-10-dry-run.yaml
new file mode 100644
index 00000000..ff53870d
--- /dev/null
+++ b/docs/banda/2026-06-10-dry-run.yaml
@@ -0,0 +1,38 @@
+# Banda Cognitiva — 2026-06-10
+id: 2026-06-10-dry-run
+mode: default
+question: |
+  
+context_provided: false
+duration_seconds: 0
+models:
+  critic: anthropic/claude-sonnet-4.6
+  supporter: anthropic/claude-sonnet-4.6
+  questioner: anthropic/claude-sonnet-4.6
+  maestro: anthropic/claude-sonnet-4.6
+
+---
+# Phase 1 — Crítico
+# DRY-RUN output for anthropic/claude-sonnet-4.6
+simulated_response: ok
+would_call_model: anthropic/claude-sonnet-4.6
+
+---
+# Phase 2 — Apoiador
+# DRY-RUN output for anthropic/claude-sonnet-4.6
+simulated_response: ok
+would_call_model: anthropic/claude-sonnet-4.6
+
+---
+# Phase 3 — Questionador
+# DRY-RUN output for anthropic/claude-sonnet-4.6
+simulated_response: ok
+would_call_model: anthropic/claude-sonnet-4.6
+
+---
+# Phase 4 — Maestro (FINAL SYNTHESIS)
+# DRY-RUN output for anthropic/claude-sonnet-4.6
+simulated_response: ok
+would_call_model: anthropic/claude-sonnet-4.6
+
+# Sacred Code: 000.111.369.963.1618
diff --git a/docs/concepts/ESPIRAIS_VISION.md b/docs/concepts/ESPIRAIS_VISION.md
index bf25907f..b7b8e133 100644
--- a/docs/concepts/ESPIRAIS_VISION.md
+++ b/docs/concepts/ESPIRAIS_VISION.md
@@ -1,7 +1,7 @@
 # Espirais de Escuta — Product Vision Reference
 
 > **Status:** DEPRECATED / historical stage (2026-03-13)  
-> **Superseded by:** [ESPIRAL_DE_ESCUTA_CANON.md](/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md) and [EGOS_Espiral_Handoff_v5.pdf](/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf)  
+> **Superseded by:** [ESPIRAL_DE_ESCUTA_CANON.md](ESPIRAL_DE_ESCUTA_CANON.md) and [EGOS_Espiral_Handoff_v5.pdf](/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf)  
 > **Origin:** EGOSv2 STRATEGY.md (Oct 2025) | **Full spec:** `/home/enio/egos-archive/v2/EGOSv2/STRATEGY.md`
 
 <!-- llmrefs:start -->
diff --git a/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md b/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md
index d6c7938c..a32c4481 100644
--- a/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md
+++ b/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md
@@ -41,7 +41,7 @@ Operational implication:
 
 1. 2026-02-17 — `egos-lab/docs/_current_handoffs/handoff_spiral_genesis.md`
 2. 2026-02-24 — `egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md`
-3. 2026-03-13 — [ESPIRAIS_VISION.md](/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md)
+3. 2026-03-13 — [ESPIRAIS_VISION.md](ESPIRAIS_VISION.md)
 4. 2026-05-06 — `/home/enio/egos-lab-chat/CHATBOT_SSOT.md`
 5. 2026-05-15 — [EGOS_Espiral_Handoff_v5.pdf](/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf)
 
diff --git a/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md b/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md
index 2341b53e..0ba2c096 100644
--- a/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md
+++ b/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md
@@ -318,7 +318,7 @@ Não existe "certo" absoluto — existe **fit for purpose**. Um `/gem-hunter` é
 
 ## Smartlinks
 
-- Mais sobre Skills: [docs/governance/SKILLS_REGISTRY.md](./SKILLS_REGISTRY.md)
+- Mais sobre Skills: [docs/governance/SKILLS_REGISTRY.md](../governance/SKILLS_REGISTRY.md)
 - Arquitectura de Agents: [AGENTS.md](../../AGENTS.md)
 - Governance Patterns: [docs/governance/EGOS_GOVERNANCE.md]
 - MCP Docs: [Anthropic MCP Protocol](https://github.com/anthropics/model-context-protocol)
diff --git a/docs/governance/AREAS_OF_PRACTICE.md b/docs/governance/AREAS_OF_PRACTICE.md
index 123698ec..8fb1f8eb 100644
--- a/docs/governance/AREAS_OF_PRACTICE.md
+++ b/docs/governance/AREAS_OF_PRACTICE.md
@@ -221,7 +221,7 @@ Para evitar dispersão:
 - [EGOS_OPERATING_PRINCIPLES.md](EGOS_OPERATING_PRINCIPLES.md) — regra-mãe + WIP limit
 - [CAPABILITIES_MAP.md](../personal-os/CAPABILITIES_MAP.md) — capacidades que sustentam essas áreas
 - [IDENTITY_AND_METHOD.md](IDENTITY_AND_METHOD.md) — identidade + método-mãe
-- [BUSINESS_CASE.md](../products/espiral-de-escuta/BUSINESS_CASE.md) — gate para A4-A6 (V1)
+- [BUSINESS_CASE.md](../products-specs/espiral-de-escuta/BUSINESS_CASE.md) — gate para A4-A6 (V1)
 
 ---
 
diff --git a/docs/governance/CLIENT_KB_DOCTRINE.md b/docs/governance/CLIENT_KB_DOCTRINE.md
index 42229fd9..ad3c8f39 100644
--- a/docs/governance/CLIENT_KB_DOCTRINE.md
+++ b/docs/governance/CLIENT_KB_DOCTRINE.md
@@ -614,8 +614,8 @@ Implementação: incluir no `~/.claude/CLAUDE.md` como §0.8 ou nos pre-commit h
 
 ## Referências
 
-- [SETUP.md AnythingLLM](../products/anythingllm/SETUP.md) — implementação técnica
-- [BUSINESS_CASE.md Espiral](../products/espiral-de-escuta/BUSINESS_CASE.md)
+- [SETUP.md AnythingLLM](../products-specs/anythingllm/SETUP.md) — implementação técnica
+- [BUSINESS_CASE.md Espiral](../products-specs/espiral-de-escuta/BUSINESS_CASE.md)
 - [IDENTITY_AND_METHOD.md](IDENTITY_AND_METHOD.md)
 - [CAPABILITY_REGISTRY §86](../CAPABILITY_REGISTRY.md)
 - Skills: `kbs-discovery`, `client-onboard`, `central-egos`
diff --git a/docs/governance/CLIENT_TIERS_MATRIX.md b/docs/governance/CLIENT_TIERS_MATRIX.md
index a5a26b1b..95e42de6 100644
--- a/docs/governance/CLIENT_TIERS_MATRIX.md
+++ b/docs/governance/CLIENT_TIERS_MATRIX.md
@@ -215,7 +215,7 @@ Cliente novo entra
 - [CLIENT_QUALIFICATION_INTERVIEW.md](CLIENT_QUALIFICATION_INTERVIEW.md) — questionário entrevista
 - [IDENTITY_AND_METHOD.md](IDENTITY_AND_METHOD.md) — Espiral de Escuta como diagnóstico
 - [MOBILE_ACCESS_GUIDE.md](../runbooks/MOBILE_ACCESS_GUIDE.md) — patterns Android/iOS/PWA
-- [products/anythingllm/OPERATIONS.md](../products/anythingllm/OPERATIONS.md) — operations AnythingLLM
+- [products/anythingllm/OPERATIONS.md](../products-specs/anythingllm/OPERATIONS.md) — operations AnythingLLM
 - Skills relevantes: `kbs-discovery` (Plus), `client-onboard` (Base), `central-egos` (provision)
 
 *v1.0 — 2026-05-20 — Matriz de tiers + critérios de qualificação obrigatórios.*
diff --git a/docs/governance/EGOS_OPERATING_PRINCIPLES.md b/docs/governance/EGOS_OPERATING_PRINCIPLES.md
index b0649290..b5f35991 100644
--- a/docs/governance/EGOS_OPERATING_PRINCIPLES.md
+++ b/docs/governance/EGOS_OPERATING_PRINCIPLES.md
@@ -119,7 +119,7 @@ Resumo:
 - [MCP_PRODUCTION_GATE.md](MCP_PRODUCTION_GATE.md) — hardening obrigatório pré-deploy
 - [NEEDS_TAXONOMY.md](NEEDS_TAXONOMY.md) — taxonomia formal needs[]/next_actions[]
 - [CODEX_PIPELINE.md](CODEX_PIPELINE.md) — fluxo de revisão
-- [BUSINESS_CASE.md](../products/espiral-de-escuta/BUSINESS_CASE.md) — Espiral validation gate
+- [BUSINESS_CASE.md](../products-specs/espiral-de-escuta/BUSINESS_CASE.md) — Espiral validation gate
 - [MODEL_DELEGATION_POLICY.md](MODEL_DELEGATION_POLICY.md) — Opus/Sonnet/Haiku
 - [SWARM_COMMIT_POLICY.md](SWARM_COMMIT_POLICY.md) — sprint paralelo
 
diff --git a/docs/governance/MASTER_INDEX.md b/docs/governance/MASTER_INDEX.md
index 96d0686f..69414cc9 100644
--- a/docs/governance/MASTER_INDEX.md
+++ b/docs/governance/MASTER_INDEX.md
@@ -49,7 +49,7 @@
 6. `SYSTEM_MAP.md` — activation flow
 7. `TASKS.md` — current execution priorities
 8. `docs/EGOS_STATE_OF_THE_ECOSYSTEM.md` — state-of-the-ecosystem snapshot (2026-04-08+)
-8. `docs/business/MONETIZATION_SSOT.md` — ecosystem monetization, partner model, founder-partner fit
+8. `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` — pricing SSOT vivo (plano único R$2.000+ setup; corte Enio 2026-05-25). Históricos superseded: `docs/strategy/MONETIZATION_PLAYBOOK.md`
 
 ---
 
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
new file mode 100644
index 00000000..0dd6c1c7
--- /dev/null
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -0,0 +1,244 @@
+{
+  "manifest": "/home/enio/egos/.egos-manifest.yaml",
+  "repo": "egos",
+  "verified_at": "2026-06-10T11:31:40.007Z",
+  "summary": {
+    "total_claims": 17,
+    "passed": 17,
+    "warned": 0,
+    "drifted": 0,
+    "errors": 0,
+    "total_domains": 8,
+    "domains_ok": 8,
+    "domains_drifted": 0
+  },
+  "results": [
+    {
+      "id": "total_agents",
+      "description": "Agents registered in agents.json",
+      "status": "ok",
+      "last_value": "27",
+      "current_value": "27",
+      "tolerance": "min:18",
+      "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
+      "severity": "ok"
+    },
+    {
+      "id": "total_capabilities",
+      "description": "Capabilities declared in CAPABILITY_REGISTRY.md",
+      "status": "ok",
+      "last_value": "168",
+      "current_value": "168",
+      "tolerance": "±10",
+      "drift_abs": 0,
+      "command": "grep -c '^### ' docs/CAPABILITY_REGISTRY.md",
+      "severity": "ok"
+    },
+    {
+      "id": "guarani_governance_files",
+      "description": "Governance rule files in .guarani/",
+      "status": "ok",
+      "last_value": "97",
+      "current_value": "97",
+      "tolerance": "±5",
+      "drift_abs": 0,
+      "command": "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "slash_commands",
+      "description": "User-invocable slash commands in .claude/commands/",
+      "status": "ok",
+      "last_value": "61",
+      "current_value": "64",
+      "tolerance": "±5",
+      "drift_abs": 3,
+      "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "operating_surface_entries",
+      "description": "Entradas no mapa machine-wide da superfície de operação (EGOS_OPERATING_SURFACE.yaml)",
+      "status": "ok",
+      "last_value": "35",
+      "current_value": "35",
+      "tolerance": "±4",
+      "drift_abs": 0,
+      "command": "grep -cE '^  - id:' docs/governance/EGOS_OPERATING_SURFACE.yaml 2>/dev/null | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "kernel_packages",
+      "description": "Packages in packages/ directory",
+      "status": "ok",
+      "last_value": "36",
+      "current_value": "38",
+      "tolerance": "±2",
+      "drift_abs": 2,
+      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "commits_30d_all_repos",
+      "description": "Total commits across all active EGOS repos in last 30 days",
+      "status": "ok",
+      "last_value": "1466",
+      "current_value": "1369",
+      "tolerance": "min:50",
+      "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
+      "severity": "ok"
+    },
+    {
+      "id": "unique_differentials",
+      "description": "Unique technical differentials documented in EGOS_STATE",
+      "status": "ok",
+      "last_value": "22",
+      "current_value": "22",
+      "tolerance": "min:6",
+      "command": "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
+      "severity": "ok"
+    },
+    {
+      "id": "completed_tasks_total",
+      "description": "Total completed tasks in TASKS.md",
+      "status": "ok",
+      "last_value": "0",
+      "current_value": "0\n0",
+      "tolerance": "min:0",
+      "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
+      "severity": "ok"
+    },
+    {
+      "id": "active_products",
+      "description": "Live products with public URLs in EGOS ecosystem",
+      "status": "ok",
+      "last_value": "7",
+      "current_value": "7",
+      "tolerance": "min:5",
+      "command": "grep -c '\\*\\*URL:\\*\\*' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
+      "severity": "ok"
+    },
+    {
+      "id": "capability_registry_sections",
+      "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
+      "status": "ok",
+      "last_value": "19",
+      "current_value": "100",
+      "tolerance": "min:10",
+      "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
+      "severity": "ok"
+    },
+    {
+      "id": "evg008_simplicity_check_function",
+      "description": "EVG-008: detectSimplicityViolations function present in evidence-gate.ts (§K.2 enforcement)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "min:2",
+      "command": "grep -c 'detectSimplicityViolations' scripts/evidence-gate.ts",
+      "severity": "ok"
+    },
+    {
+      "id": "karpathy_principles_in_global_claude",
+      "description": "§K Karpathy Principles in egos-rules lazy-load (moved from CLAUDE.md core in GOV-W2-009)",
+      "status": "ok",
+      "last_value": "1",
+      "current_value": "1",
+      "tolerance": "min:1",
+      "command": "grep -c 'Simplicity First' ~/.claude/egos-rules/karpathy-principles.md",
+      "severity": "ok"
+    },
+    {
+      "id": "disseminate_pipeline_scripts",
+      "description": "Auto-disseminate pipeline scripts present (propagator + scanner)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "eq:2",
+      "command": "test -f scripts/disseminate-propagator.ts && test -f scripts/disseminate-scanner.ts && echo 2 || echo 0",
+      "severity": "ok"
+    },
+    {
+      "id": "evidence_gate_blocking_schedule",
+      "description": "Evidence gate blocking activation date configured (WEEK2_START = 2026-04-16)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "min:2",
+      "command": "grep -c 'WEEK2_START' scripts/evidence-gate.ts",
+      "severity": "ok"
+    },
+    {
+      "id": "pre_commit_hook_chain_stages",
+      "description": "Pre-commit hook chain has minimum required governance stages",
+      "status": "ok",
+      "last_value": "70",
+      "current_value": "178",
+      "tolerance": "min:15",
+      "command": "grep -c '\\[' .husky/pre-commit",
+      "severity": "ok"
+    },
+    {
+      "id": "cross_repo_capabilities",
+      "description": "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)",
+      "status": "ok",
+      "last_value": "28",
+      "current_value": "23",
+      "tolerance": "min:10",
+      "command": "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0",
+      "severity": "ok"
+    }
+  ],
+  "domains": [
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://hq.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "301",
+      "actual_status": "301"
+    },
+    {
+      "url": "https://eagleeye.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://852.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://inteligencia.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200",
+      "contains_check": true
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "301",
+      "actual_status": "301"
+    }
+  ],
+  "exit_code": 0
+}
\ No newline at end of file
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
new file mode 100644
index 00000000..189db631
--- /dev/null
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -0,0 +1,234 @@
+[
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T00:15:35.694Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=2735131d",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T00:20:55.197Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=1d6a024c",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T00:24:09.662Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=1f180ee9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T00:33:17.952Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=3 sha=2cfa7fb8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:12:41.956Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=a0890a58",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:15:36.040Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=14ae4294",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:21:32.692Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=77f320fa",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:25:22.901Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=eaa69312",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:30:16.878Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:refactor files=2 sha=e697c0c8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:33:52.086Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=3 sha=350d19c0",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:36:34.221Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=e64ce30b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:41:58.917Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=0655e634",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:43:17.430Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=37850ff1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:52:01.428Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=18 sha=9af71508",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:54:06.411Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=440cf3b5",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:55:34.226Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=e4be3787",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T01:57:58.820Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=59b8f921",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T02:14:28.204Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=36 sha=d988385b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T02:23:44.888Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=8 sha=c615dde6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T02:28:56.694Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=28bce96f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T02:38:03.278Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=75fe902f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T10:31:08.289Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=9198cc04",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:00:06.188Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=367bec7e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:00:43.798Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=9883209e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:01:23.595Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=5 sha=522592f6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:15:47.929Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=11 sha=abce63b2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:16:41.914Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=c08063cf",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:31:41.881Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=9 sha=d4f57d5a",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:38:50.425Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=15 sha=c5ed3947",
+    "repo": "/home/enio/egos"
+  }
+]
diff --git a/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md b/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md
index 70ffb8aa..17d85811 100644
--- a/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md
+++ b/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md
@@ -6,7 +6,7 @@
 > - [`docs/EGOS_BOOTSTRAP.md`](../EGOS_BOOTSTRAP.md) — entrada canônica (substitui MASTER_INDEX.md)
 > - [`AGENTS.md`](../../AGENTS.md) — regras propagadas (substitui parte do MYCELIUM_TRUTH_REPORT)
 > - [`docs/modules/SSOT_REGISTRY.md`](SSOT_REGISTRY.md) — ownership
-> - [`docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md`](../governance/CENTRAL_EGOS_STATUS_MATRIX.md) — status executivo (substitui EXECUTIVE_SUMMARY_DECISION_MATRIX.md)
+> - [`docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md`](../../central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md) — status executivo (substitui EXECUTIVE_SUMMARY_DECISION_MATRIX.md)
 > - [`docs/CAPABILITY_REGISTRY.md`](../CAPABILITY_REGISTRY.md) — capabilities
 >
 > **Refs mortas que aparecem abaixo:** MASTER_INDEX.md, EXECUTIVE_SUMMARY_DECISION_MATRIX.md, ARCHIVE_GEMS_CATALOG.md, INFRASTRUCTURE_ARCHIVE_AUDIT.md, ECOSYSTEM_CLASSIFICATION_REGISTRY.md, MYCELIUM_TRUTH_REPORT.md, INCIDENT_RESPONSE_MCP.md — todos removidos ou renomeados. Refresh completo: TODO em [TASKS.md `DOC-ARCH-MAP-REFRESH-001`](../../TASKS.md).
diff --git a/docs/products-specs/INDEX.md b/docs/products-specs/INDEX.md
index bc0fb3de..f2fc54d9 100644
--- a/docs/products-specs/INDEX.md
+++ b/docs/products-specs/INDEX.md
@@ -45,4 +45,4 @@ All capabilities must be backed by one of:
 - ✅ reproducible dry-run — `--dry` flag
 - ⚠️ unverified: — tracked, not yet proven
 
-See `§8 Evidence-First` in `~/.claude/CLAUDE.md` and [DOC_DRIFT_SHIELD.md](../DOC_DRIFT_SHIELD.md).
+See `§8 Evidence-First` in `~/.claude/CLAUDE.md` and [DOC_DRIFT_SHIELD.md](../governance/DOC_DRIFT_SHIELD.md).
diff --git a/docs/products-specs/anythingllm/OPERATIONS.md b/docs/products-specs/anythingllm/OPERATIONS.md
index ec94a02b..54d8ea8c 100644
--- a/docs/products-specs/anythingllm/OPERATIONS.md
+++ b/docs/products-specs/anythingllm/OPERATIONS.md
@@ -1,7 +1,7 @@
 # AnythingLLM — Operations Cheatsheet
 
 > **Versão:** 1.0 | **Data:** 2026-05-20 | **Origem:** Codex E1 — split SETUP.md em arquivos modulares
-> **Pair:** [SETUP.md](SETUP.md) (filosofia/decisão), [SECURITY.md](SECURITY.md) (hardening), [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (incidentes)
+> **Pair:** [SETUP.md](SETUP.md) (filosofia/decisão), [SECURITY.md](../../../SECURITY.md) (hardening), [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (incidentes)
 
 ---
 
@@ -253,7 +253,7 @@ Mais cenários: [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (a criar)
 
 ## Referências
 - [SETUP.md](SETUP.md) — filosofia + decisões arquiteturais
-- [SECURITY.md](SECURITY.md) — hardening completo (a criar — Codex E1 split)
+- [SECURITY.md](../../../SECURITY.md) — hardening completo (a criar — Codex E1 split)
 - [TROUBLESHOOTING.md](TROUBLESHOOTING.md) — playbook problemas (a criar)
 - [CLIENT_KB_DOCTRINE.md](../../governance/CLIENT_KB_DOCTRINE.md) — 7 regras canonical
 - [CLIENT_INCIDENT_RUNBOOK.md](../../runbooks/CLIENT_INCIDENT_RUNBOOK.md) — triagem 15min
diff --git a/docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md b/docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md
index 5c825e33..e67b4622 100644
--- a/docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md
+++ b/docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md
@@ -253,7 +253,7 @@ Compromisso: [SLA atualizado, se aplicável]
 
 ## Referências
 - [CLIENT_KB_DOCTRINE.md](../governance/CLIENT_KB_DOCTRINE.md)
-- [SETUP.md AnythingLLM](../products/anythingllm/SETUP.md)
+- [SETUP.md AnythingLLM](../products-specs/anythingllm/SETUP.md)
 - [API_KEY_ROTATION.md](API_KEY_ROTATION.md)
 - LGPD Art. 48 (comunicação de incidente)
 - [validate-anythingllm.sh](../../scripts/validate-anythingllm.sh)
diff --git a/docs/runbooks/MOBILE_ACCESS_GUIDE.md b/docs/runbooks/MOBILE_ACCESS_GUIDE.md
index 72c561b3..0ba1e572 100644
--- a/docs/runbooks/MOBILE_ACCESS_GUIDE.md
+++ b/docs/runbooks/MOBILE_ACCESS_GUIDE.md
@@ -251,7 +251,7 @@ Detalhe completo: [CLIENT_INCIDENT_RUNBOOK.md](CLIENT_INCIDENT_RUNBOOK.md)
 
 - [CLIENT_TIERS_MATRIX.md](../governance/CLIENT_TIERS_MATRIX.md) — quando aplicar cada tier
 - [CLIENT_KB_DOCTRINE.md](../governance/CLIENT_KB_DOCTRINE.md) — 7 regras de segurança
-- [products/anythingllm/OPERATIONS.md](../products/anythingllm/OPERATIONS.md) — operações servidor
+- [products/anythingllm/OPERATIONS.md](../products-specs/anythingllm/OPERATIONS.md) — operações servidor
 - [AnythingLLM Mobile](https://anythingllm.com/mobile)
 - [AnythingLLM Mobile Overview docs](https://docs.anythingllm.com/mobile/overview)
 - [AnythingLLM Google Play](https://play.google.com/store/apps/details?id=com.anythingllm)
diff --git a/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md b/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
index c2890ba0..947738fc 100644
--- a/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
+++ b/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
@@ -1,7 +1,7 @@
 # EGOS Telegram Agent — Plano de Arquitetura
 
 > **Status:** PLAN (pré-código) · **Criado:** 2026-06-01 · **Owner:** Enio + EGOS Prime
-> **SSOTs relacionados:** [CHATBOT_SSOT.md](./CHATBOT_SSOT.md) · [AGENT_RUNTIME_DESIGN.md](./AGENT_RUNTIME_DESIGN.md) · [EGOS_MASTER_API_PRD.md](./EGOS_MASTER_API_PRD.md)
+> **SSOTs relacionados:** [CHATBOT_SSOT.md](../modules/CHATBOT_SSOT.md) · [AGENT_RUNTIME_DESIGN.md](../modules/AGENT_RUNTIME_DESIGN.md) · [EGOS_MASTER_API_PRD.md](./EGOS_MASTER_API_PRD.md)
 > **Escopo:** levar capacidades do EGOS (monitoramento, MCP, meta-prompts, skills, config) para a superfície **Telegram** como um agente único. NÃO substitui os SSOTs acima — estende o comportamento do agente no canal Telegram.
 
 ---
diff --git a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md b/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md
index 43e0ebb2..b3dec1cf 100644
--- a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md
+++ b/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md
@@ -27,7 +27,7 @@ EGOS Consulting implementa **assistentes de IA conectados à base de conheciment
 
 ## §2 — Modelo de operação
 
-**Cobrança caso-a-caso** com ancoragem interna (ver [PRICING_ANCHORS.md](appendix/PRICING_ANCHORS.md)):
+**Cobrança caso-a-caso** com ancoragem interna (ver [PRICING_ANCHORS.md](../appendix/PRICING_ANCHORS.md)):
 
 | Porte | Setup | Manutenção/mês | Perfis | Exemplo |
 |---|---|---|---|---|
@@ -47,7 +47,7 @@ EGOS Consulting implementa **assistentes de IA conectados à base de conheciment
 ## §3 — Oferta em camadas (simples → complexa)
 
 ### Camada 1 — KB + Agente WhatsApp (MVP padrão)
-- Base de conhecimento no Notion (padrão) ou Obsidian (sob demanda — ver [KB_DECISION_MATRIX.md](appendix/KB_DECISION_MATRIX.md))
+- Base de conhecimento no Notion (padrão) ou Obsidian (sob demanda — ver [KB_DECISION_MATRIX.md](../appendix/KB_DECISION_MATRIX.md))
 - Ingestão inicial de 20-100 documentos do cliente
 - Agente consolidado EGOS via WhatsApp: busca, resumo, reaproveitamento
 
@@ -137,13 +137,13 @@ Resposta no WhatsApp do membro
 
 ### Fase 1 — Descoberta (1 reunião de ~3h)
 
-Aplicação do [DPIO_QUESTIONNAIRE.md](appendix/DPIO_QUESTIONNAIRE.md) — 45 perguntas em 5 blocos + 5 customizadas por setor. Score 0-60. Gate: ≥40 = implementa.
+Aplicação do [DPIO_QUESTIONNAIRE.md](../appendix/DPIO_QUESTIONNAIRE.md) — 45 perguntas em 5 blocos + 5 customizadas por setor. Score 0-60. Gate: ≥40 = implementa.
 
 Cliente grava a reunião no próprio celular (gravador Android/iOS nativo) e envia áudio via WhatsApp ao agente EGOS.
 
 ### Fase 2 — Debrief automático (4-24h depois)
 
-Pipeline automatizado (ver [DEBRIEF_ARCHITECTURE.md](appendix/DEBRIEF_ARCHITECTURE.md)):
+Pipeline automatizado (ver [DEBRIEF_ARCHITECTURE.md](../appendix/DEBRIEF_ARCHITECTURE.md)):
 1. Groq Whisper transcreve
 2. Gemini Flash corrige com contexto do cliente
 3. Qwen-plus extrai insights, dores, gaps
@@ -195,7 +195,7 @@ Checklist replicável (a formalizar após 1º MVP):
 
 ### 7.1 DPO (Encarregado)
 **Enio Batista Fernandes Rocha** — `dpo@egos.ia.br` — Patos de Minas, MG.
-Publicado em `trust.egos.ia.br` (ver [TRUST_PAGE_SPEC.md](appendix/TRUST_PAGE_SPEC.md)).
+Publicado em `trust.egos.ia.br` (ver [TRUST_PAGE_SPEC.md](../appendix/TRUST_PAGE_SPEC.md)).
 
 ### 7.2 Transparência radical — reutilizar o que existe
 Investigação interna identificou **40% do framework já implementado**:
@@ -378,12 +378,12 @@ Muitos advogados já usam ferramentas de IA com integrações jurídicas. Devemo
 
 ## §12 — Apêndices
 
-- [DPIO_QUESTIONNAIRE.md](appendix/DPIO_QUESTIONNAIRE.md) — 45 perguntas de descoberta
-- [DEBRIEF_ARCHITECTURE.md](appendix/DEBRIEF_ARCHITECTURE.md) — pipeline áudio → insights
-- [KB_DECISION_MATRIX.md](appendix/KB_DECISION_MATRIX.md) — Notion vs Obsidian
-- [TRUST_PAGE_SPEC.md](appendix/TRUST_PAGE_SPEC.md) — especificação de `trust.egos.ia.br`
-- [PRICING_ANCHORS.md](appendix/PRICING_ANCHORS.md) — tabela de referência interna
-- [WHATSAPP_ONBOARDING_GUIDE.md](appendix/WHATSAPP_ONBOARDING_GUIDE.md) — passo a passo WhatsApp Business para onboarding
+- [DPIO_QUESTIONNAIRE.md](../appendix/DPIO_QUESTIONNAIRE.md) — 45 perguntas de descoberta
+- [DEBRIEF_ARCHITECTURE.md](../appendix/DEBRIEF_ARCHITECTURE.md) — pipeline áudio → insights
+- [KB_DECISION_MATRIX.md](../appendix/KB_DECISION_MATRIX.md) — Notion vs Obsidian
+- [TRUST_PAGE_SPEC.md](../appendix/TRUST_PAGE_SPEC.md) — especificação de `trust.egos.ia.br`
+- [PRICING_ANCHORS.md](../appendix/PRICING_ANCHORS.md) — tabela de referência interna
+- [WHATSAPP_ONBOARDING_GUIDE.md](../appendix/WHATSAPP_ONBOARDING_GUIDE.md) — passo a passo WhatsApp Business para onboarding
 
 ---
 
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
 
diff --git a/scripts/egos-home/sync.sh b/scripts/egos-home/sync.sh
index a59a59eb..8bde6c5a 100755
--- a/scripts/egos-home/sync.sh
+++ b/scripts/egos-home/sync.sh
@@ -27,20 +27,20 @@ echo ""
 # Intentionally excluded:
 # - "$HOME/policia"   (sensitive/private workflow, isolated rules)
 # - "$HOME/personal"  (non-code/personal artifacts)
-REPOS=(
-  "$HOME/852"
-  "$HOME/INPI"
-  "$HOME/egos-lab"
-  "$HOME/carteira-livre"
-  "$HOME/br-acc"
-  "$HOME/forja"
-  "$HOME/egos-self"
-  "$HOME/commons"
-  "$HOME/smartbuscas"
-  "$HOME/santiago"   # EGOS-069: added 2026-03-30
-  "$HOME/arch"       # EGOS governance bootstrap
-  "$HOME/intelink"          # intelink (migrado de egos-inteligencia 2026-05-05)
-)
+# MYCELIUM-006 (2026-06-10): lista canônica única em agents/registry/leaf-repos.json
+# — NÃO adicionar repos aqui; adicionar no JSON. Fallback hardcoded só se jq/JSON ausente.
+LEAF_JSON="$(cd "$(dirname "$0")/../.." && pwd)/agents/registry/leaf-repos.json"
+if command -v jq >/dev/null 2>&1 && [ -f "$LEAF_JSON" ]; then
+  mapfile -t REPOS < <(jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == "") | .path' "$LEAF_JSON" 2>/dev/null)
+fi
+if [ "${#REPOS[@]:-0}" -eq 0 ]; then
+  echo "⚠️  leaf-repos.json indisponível — usando fallback hardcoded (atualizar JSON!)" >&2
+  REPOS=(
+    "$HOME/852" "$HOME/INPI" "$HOME/egos-lab" "$HOME/carteira-livre"
+    "$HOME/br-acc" "$HOME/forja" "$HOME/egos-self" "$HOME/commons"
+    "$HOME/smartbuscas" "$HOME/santiago" "$HOME/arch" "$HOME/intelink"
+  )
+fi
 
 # ── Step 1: Validate central governance ──
 echo "📋 Step 1: Validating central governance..."

exec
/bin/bash -lc "cat agents/registry/leaf-repos.json && sed -n '1,220p' scripts/disseminate-scanner.ts && sed -n '1,120p' scripts/egos-home/sync.sh && sed -n '1,90p' .claude/commands/disseminate.md" in /home/enio/egos
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

#!/bin/bash
# ═══════════════════════════════════════════════════════════
# 🔄 EGOS Sync v2.1 — Shared Governance + Workflows + Skills + Claude Commands (EPOS-SYNC-001)
# 
# Creates symlinks for governance, workflows, and skills
# in ALL registered repos. Works with Windsurf, `.agent`, and shared IDE surfaces.
#
# Usage: ~/.egos/sync.sh
# ═══════════════════════════════════════════════════════════

set -e

EGOS_HOME="$HOME/.egos"
SYNC_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔄 EGOS Sync v2.1 — Governance + Workflows + Skills + Claude Commands"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ── Registered repos ──
# Standard code repos that consume shared governance directly.
# Intentionally excluded:
# - "$HOME/policia"   (sensitive/private workflow, isolated rules)
# - "$HOME/personal"  (non-code/personal artifacts)
# MYCELIUM-006 (2026-06-10): lista canônica única em agents/registry/leaf-repos.json
# — NÃO adicionar repos aqui; adicionar no JSON. Fallback hardcoded só se jq/JSON ausente.
LEAF_JSON="$(cd "$(dirname "$0")/../.." && pwd)/agents/registry/leaf-repos.json"
if command -v jq >/dev/null 2>&1 && [ -f "$LEAF_JSON" ]; then
  mapfile -t REPOS < <(jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == "") | .path' "$LEAF_JSON" 2>/dev/null)
fi
if [ "${#REPOS[@]:-0}" -eq 0 ]; then
  echo "⚠️  leaf-repos.json indisponível — usando fallback hardcoded (atualizar JSON!)" >&2
  REPOS=(
    "$HOME/852" "$HOME/INPI" "$HOME/egos-lab" "$HOME/carteira-livre"
    "$HOME/br-acc" "$HOME/forja" "$HOME/egos-self" "$HOME/commons"
    "$HOME/smartbuscas" "$HOME/santiago" "$HOME/arch" "$HOME/intelink"
  )
fi

# ── Step 1: Validate central governance ──
echo "📋 Step 1: Validating central governance..."
REQUIRED=(
  "guarani/IDENTITY.md"
  "guarani/PREFERENCES.md"
  "guarani/RULES_INDEX.md"
  "README.md"
)
for file in "${REQUIRED[@]}"; do
  if [ -f "$EGOS_HOME/$file" ]; then
    echo -e "   ${GREEN}✅${NC} $file"
  else
    echo -e "   ${RED}❌${NC} MISSING: $file"
    exit 1
  fi
done

# Count workflows and skills
WF_COUNT=$(ls "$EGOS_HOME/workflows/"*.md 2>/dev/null | wc -l)
SKILL_COUNT=$(find "$EGOS_HOME/skills" -name "SKILL.md" 2>/dev/null | wc -l)
echo -e "   ${GREEN}✅${NC} $WF_COUNT workflows available"
echo -e "   ${GREEN}✅${NC} $SKILL_COUNT skills available"

# ── Step 1.5: Validate Global IDE Symlinks ──
echo ""
echo "📋 Step 1.5: Validating Global IDE Symlinks (Antigravity/Cline)..."
CLINE_DIR="$HOME/Documents/Cline"
if [ -d "$CLINE_DIR" ]; then
  # Workflows
  if [ -L "$CLINE_DIR/Workflows" ]; then
    echo -e "   ${GREEN}✅${NC} Cline Workflows symlink OK"
  else
    rm -rf "$CLINE_DIR/Workflows"
    ln -sf "$EGOS_HOME/workflows" "$CLINE_DIR/Workflows"
    echo -e "   ${GREEN}🔗${NC} Cline Workflows symlink fixed"
  fi
  # Rules
  if [ -L "$CLINE_DIR/Rules" ]; then
    echo -e "   ${GREEN}✅${NC} Cline Rules symlink OK"
  else
    rm -rf "$CLINE_DIR/Rules"
    ln -sf "$EGOS_HOME/guarani/standards/ide-rules" "$CLINE_DIR/Rules"
    echo -e "   ${GREEN}🔗${NC} Cline Rules symlink fixed"
  fi

  # Hooks
  if [ -L "$CLINE_DIR/Hooks" ]; then
    echo -e "   ${GREEN}✅${NC} Cline Hooks symlink OK"
  else
    if [ -d "$EGOS_HOME/hooks" ]; then
      rm -rf "$CLINE_DIR/Hooks"
      ln -sf "$EGOS_HOME/hooks" "$CLINE_DIR/Hooks"
      echo -e "   ${GREEN}🔗${NC} Cline Hooks symlink fixed"
    fi
  fi

  # Skills
  if [ -L "$CLINE_DIR/Skills" ]; then
    echo -e "   ${GREEN}✅${NC} Cline Skills symlink OK"
  else
    if [ -d "$EGOS_HOME/skills" ]; then
      rm -rf "$CLINE_DIR/Skills"
      ln -sf "$EGOS_HOME/skills" "$CLINE_DIR/Skills"
      echo -e "   ${GREEN}🔗${NC} Cline Skills symlink fixed"
    fi
  fi
fi

# Global .agent
AGENT_DIR="$HOME/.agent"
if [ -d "$AGENT_DIR" ]; then
  if [ -L "$AGENT_DIR/workflows" ]; then
    echo -e "   ${GREEN}✅${NC} Global .agent workflows symlink OK"
  else
    rm -rf "$AGENT_DIR/workflows"
    ln -sf "$EGOS_HOME/workflows" "$AGENT_DIR/workflows"
---
description: Disseminate kernel rules, governance, skills & tooling to the whole ecosystem (mirrors + leaf repos + VPS) via a safe, zero-downtime patch pipeline. Use when governance/skills/hooks changed, 3+ feat: commits unpropagated, or user asks to sync/patch the system.
---

# /disseminate v2 — Patch Propagation System (anéis + pipeline seguro + zero-downtime)

> **Princípio (corte Enio 2026-06-03):** quanto melhor a capacidade de aplicar patches importantes RÁPIDO no sistema inteiro SEM comprometer nada (downtime 0), melhor. Disseminação não é "copiar arquivo" — é **propagar uma mudança por anéis, com dry-run, verificação e rollback**.
> **SSOT do mapa de regras:** `docs/governance/RULE_SETS_INDEX.md` · **Mirrors:** `egos-autoheal.ts` · **Leaves:** `disseminate-propagator.ts` + `.egos-disseminate-manifest.json` + `~/.egos/sync.sh`.

---

## §1. ANÉIS (de onde a mudança parte e até onde vai)

| Anel | Alvo | Mecanismo | Risco |
|------|------|-----------|-------|
| **R0 — Kernel** | `egos/` (SSOT) | edição + commit + push | — (origem) |
| **R1 — Mirrors runtime** | `~/.egos`, `~/.claude` | `egos-autoheal.ts` (10 arquivos) + `~/.egos/sync.sh` (commands, .guarani) | baixo (cópia idempotente) |
| **R2 — Leaf repos** | manifest `existing_repos` (852, egos-lab, br-acc, forja, egos-self, smartbuscas, santiago, arch, …) | `disseminate-propagator.ts --all` (bloco PROPAGATE-RULES) + `sync.sh` (symlinks) | médio (commita em outros repos) |
| **R3 — VPS (serviços vivos)** | gateway, MCPs, storefronts (Docker/pm2) | `git pull` em `/opt/egos-git` → rebuild/reload **swap** | alto (produção — gated, zero-downtime) |

Regra: propaga **de dentro pra fora** (R0→R1→R2→R3). Nunca pula verificação entre anéis.

## §2. CLASSES DE ARTEFATO (o que se copia vs o que se ADAPTA)

| Classe | Exemplos | Como propaga |
|--------|----------|--------------|
| **Universal (copia verbatim)** | bloco de regras (`PROPAGATE-RULES`), agent defs `.claude/agents/`, standards de governança | propagator/sync — idêntico em todo lugar |
| **Mirror (kernel↔home)** | skills `/start` `/end` `/disseminate`, hooks, `.guarani/**` | autoheal + sync.sh |
| **Per-repo (ADAPTA, não copia)** | README (conteúdo), config específica | **metaprompt copy-adapt** (`docs/metaprompt-generator/`) — NUNCA cópia cega; adapta nomes/caminhos/integrações |
| **Frozen (nunca auto)** | `.husky/pre-commit`, `.guarani` core | só kernel + HITL/`EGOS_FROZEN_OVERRIDE` |

> **Anti-cópia-cega:** artefato per-repo viaja como *instrução de adaptação*, não como arquivo bruto. README padrão = `docs/governance/README_PADRAO_OURO.md` (o STANDARD propaga; o conteúdo cada repo adapta).

## §3. PIPELINE SEGURO (a capacidade de patch rápido sem comprometer)

```bash
cd ~/egos
# 1. SCAN — o que mudou + o que está drifted
git log --oneline "$(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~10)"..HEAD 2>/dev/null | head
bun scripts/egos-autoheal.ts --check 2>/dev/null | tail -1      # drift dos mirrors
bun scripts/disseminate-propagator.ts --all --dry 2>&1 | tail -3 # escopo nos leaves

# 2. DRY-RUN (preview, zero escrita) — já no scan acima (--dry / --check)

# 3. APPLY (idempotente, de dentro pra fora)
bun scripts/egos-autoheal.ts 2>/dev/null | tail -1              # R1 mirrors
bash scripts/governance-sync.sh --exec                          # R1 kernel→~/.egos
bun scripts/disseminate-propagator.ts --all                    # R2 leaves (bloco de regras) — COMMITA local
bash ~/.egos/sync.sh                                            # R2 symlinks + commands
# ⚠️ GAP CRÍTICO (achado 2026-06-03): o propagator COMMITA nos leaves mas NÃO PUSHA.
# "Disseminado" ≠ "commitado local" — só está disseminado quando está no GitHub.
# PUSH OBRIGATÓRIO dos leaves que ficaram ahead.
# Lista canônica lida de agents/registry/leaf-repos.json (MYCELIUM-006 — não editar aqui):
LEAF_REPOS_JSON=~/egos/agents/registry/leaf-repos.json
for d in $(jq -r '.leaf_repos[].path' "$LEAF_REPOS_JSON"); do
  [ -d "$d/.git" ] || continue
  ahead=$(git -C "$d" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  [ "$ahead" -gt 0 ] && echo "push $(basename $d) ($ahead ahead)" && git -C "$d" push origin "$(git -C "$d" branch --show-current)" 2>&1 | grep -E "\->|rejected|error" | head -1
done

# 4. VERIFY (drift=0 + saúde)
bun scripts/egos-autoheal.ts --check 2>/dev/null | tail -1      # drift==0
bash scripts/governance-sync.sh --check
bun scripts/runtime-smoke.ts --quiet 2>&1 | head -1            # 0 fail
bun run typecheck 2>&1 | grep -c "error TS"                    # 0 (se tocou código)

# 5. ROLLBACK (se VERIFY falhar)
#   - leaf repo: git -C <repo> revert --no-edit HEAD  (mudança é path-scoped/idempotente)
#   - mirror: re-rodar autoheal (re-copia do kernel)
#   - VPS: ver §4 (backup+swap)
```

**Gate:** só avança de APPLY p/ próximo anel se o VERIFY do anterior passou. Drift>0 após apply → investigar antes de seguir.

## §4. R3 VPS — zero-downtime (serviços vivos)

> Só quando a mudança precisa chegar na produção (gateway, MCPs). Red Zone — gated.
```bash
SSH="ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125"
# backup antes (rollback): $SSH "cp <file> <file>.bak-$(date +%s)"  + tag da imagem
$SSH "cd /opt/egos-git && git pull --ff-only origin main"        # traz o patch
# copiar arquivo(s) p/ o build-context não-git (/opt/<svc>), depois SWAP:
# Docker: docker compose build <svc> && docker compose up -d <svc>  (recreate atômico)
# pm2:    pm2 reload <svc> --update-env                            (reload sem downtime)
# smoke:  curl health + docker logs/pm2 logs (sem 409/erro)
```
Nunca `restart` destrutivo sem `build`/`reload`. Backup + smoke obrigatórios. SSOT deploy: `docs/governance/PRODUCTION_DEPLOY_RULES.md` (INC-PROD-001).

---


exec
/bin/bash -lc "sed -n '220,520p' scripts/disseminate-scanner.ts && git diff 78914c603fe2843d37de18c3b4ae2ae7af132467 -- scripts/disseminate-scanner.ts scripts/egos-home/sync.sh agents/registry/leaf-repos.json .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:

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
diff --git a/.husky/pre-commit b/.husky/pre-commit
index f461d9e3..c68f84a4 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -32,6 +32,7 @@ except Exception:
 }
 
 echo "🔒 EGOS Pre-Commit: Maximum enforcement active"
+echo "🔒 EGOS Pre-Commit: Lembre-se, o desenvolvimento é 100% IA-driven. O usuário Enio não edita nem lê código."
 
 # 0.1 ZONA EXTREMA — cross-window commit discipline (INC-SYMLINK-001 follow-up).
 # Multiple agent windows (EGOS Prime / Antigravity-Guarani) share ONE checkout and
@@ -686,6 +687,14 @@ if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
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
 
diff --git a/scripts/egos-home/sync.sh b/scripts/egos-home/sync.sh
index a59a59eb..8bde6c5a 100755
--- a/scripts/egos-home/sync.sh
+++ b/scripts/egos-home/sync.sh
@@ -27,20 +27,20 @@ echo ""
 # Intentionally excluded:
 # - "$HOME/policia"   (sensitive/private workflow, isolated rules)
 # - "$HOME/personal"  (non-code/personal artifacts)
-REPOS=(
-  "$HOME/852"
-  "$HOME/INPI"
-  "$HOME/egos-lab"
-  "$HOME/carteira-livre"
-  "$HOME/br-acc"
-  "$HOME/forja"
-  "$HOME/egos-self"
-  "$HOME/commons"
-  "$HOME/smartbuscas"
-  "$HOME/santiago"   # EGOS-069: added 2026-03-30
-  "$HOME/arch"       # EGOS governance bootstrap
-  "$HOME/intelink"          # intelink (migrado de egos-inteligencia 2026-05-05)
-)
+# MYCELIUM-006 (2026-06-10): lista canônica única em agents/registry/leaf-repos.json
+# — NÃO adicionar repos aqui; adicionar no JSON. Fallback hardcoded só se jq/JSON ausente.
+LEAF_JSON="$(cd "$(dirname "$0")/../.." && pwd)/agents/registry/leaf-repos.json"
+if command -v jq >/dev/null 2>&1 && [ -f "$LEAF_JSON" ]; then
+  mapfile -t REPOS < <(jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == "") | .path' "$LEAF_JSON" 2>/dev/null)
+fi
+if [ "${#REPOS[@]:-0}" -eq 0 ]; then
+  echo "⚠️  leaf-repos.json indisponível — usando fallback hardcoded (atualizar JSON!)" >&2
+  REPOS=(
+    "$HOME/852" "$HOME/INPI" "$HOME/egos-lab" "$HOME/carteira-livre"
+    "$HOME/br-acc" "$HOME/forja" "$HOME/egos-self" "$HOME/commons"
+    "$HOME/smartbuscas" "$HOME/santiago" "$HOME/arch" "$HOME/intelink"
+  )
+fi
 
 # ── Step 1: Validate central governance ──
 echo "📋 Step 1: Validating central governance..."

exec
/bin/bash -lc "grep -R \"existing_repos\\|affected_repos\" -n scripts/disseminate-propagator.ts scripts | head -50 && sed -n '1,260p' scripts/disseminate-propagator.ts" in /home/enio/egos
 succeeded in 1859ms:
scripts/disseminate-propagator.ts:6: * then for each repo in existing_repos:
scripts/disseminate-propagator.ts:12: *   bun scripts/disseminate-propagator.ts --all     # propagate to all existing_repos
scripts/disseminate-propagator.ts:85:  affected_repos: string[];
scripts/disseminate-propagator.ts:86:  existing_repos: string[];
scripts/disseminate-propagator.ts:244:  console.log(`[propagator] Target repos: ${manifest.existing_repos.length}/${manifest.affected_repos.length} exist`);
scripts/disseminate-propagator.ts:248:  const repos = REPO_ARG ? [REPO_ARG] : manifest.existing_repos;
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:952:**Output:** `{changed_rules[], affected_repos[], propagation_needed: bool}` — feeds DISS-002 propagator
scripts/disseminate-propagator.ts:6: * then for each repo in existing_repos:
scripts/disseminate-propagator.ts:12: *   bun scripts/disseminate-propagator.ts --all     # propagate to all existing_repos
scripts/disseminate-propagator.ts:85:  affected_repos: string[];
scripts/disseminate-propagator.ts:86:  existing_repos: string[];
scripts/disseminate-propagator.ts:244:  console.log(`[propagator] Target repos: ${manifest.existing_repos.length}/${manifest.affected_repos.length} exist`);
scripts/disseminate-propagator.ts:248:  const repos = REPO_ARG ? [REPO_ARG] : manifest.existing_repos;
scripts/disseminate-scanner.ts:95:  affected_repos: string[];
scripts/disseminate-scanner.ts:96:  existing_repos: string[];
scripts/disseminate-scanner.ts:255:  affected_repos: AFFECTED_REPOS,
scripts/disseminate-scanner.ts:256:  existing_repos: existingRepos,
scripts/disseminate-verifier.ts:35:  existing_repos: string[];
scripts/disseminate-verifier.ts:203:  const { date: expectedDate, existing_repos } = manifest;
scripts/disseminate-verifier.ts:204:  console.log(`[verifier] Verifying ${existing_repos.length} repos against date ${expectedDate}...`);
scripts/disseminate-verifier.ts:207:  for (const repoPath of existing_repos) {
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
/bin/bash -lc "sed -n '260,420p' scripts/disseminate-propagator.ts && sed -n '180,260p' scripts/disseminate-verifier.ts" in /home/enio/egos
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
    body: JSON.stringify({
      chat_id: TG_CHAT_ID,
      text: msg,
      parse_mode: "Markdown",
    }),
  });
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  const manifest = loadManifest();
  if (!manifest) {
    // No manifest = nothing to verify (scanner hasn't run yet — not an error)
    console.log("[verifier] No manifest found. Run disseminate-scanner.ts first.");
    process.exit(0);
  }

  if (!manifest.propagation_needed) {
    console.log("[verifier] Manifest says no propagation needed. Skipping.");
    process.exit(0);
  }

  const { date: expectedDate, existing_repos } = manifest;
  console.log(`[verifier] Verifying ${existing_repos.length} repos against date ${expectedDate}...`);

  const results: RepoVerification[] = [];
  for (const repoPath of existing_repos) {
    const result = verifyRepo(repoPath, expectedDate);
    results.push(result);
  }

  // Always print report
  console.log(formatReport(results));

  if (SEND_TG) {
    await sendTelegram(results);
  }

  const failCount = results.filter(r => r.status === "fail").length;
  if (failCount > 0) {
    console.log(`\n[verifier] ${failCount} repos need propagation. Run:`);
    console.log(`  bun scripts/disseminate-propagator.ts --all`);
    process.exit(DRY ? 0 : 1);
  }

  console.log("[verifier] ✅ All repos verified.");
}

main().catch(err => {
  console.error("[verifier] Fatal:", err);
  process.exit(1);
});

exec
/bin/bash -lc 'bash -n scripts/egos-home/sync.sh; echo $?; bash -c '"'unset REPOS; echo "'${#REPOS[@]:-0}'"'" in /home/enio/egos
 exited 1 in 0ms:
0
bash: line 1: ${#REPOS[@]:-0}: bad substitution

exec
/bin/bash -lc "bash -c 'REPOS=(); echo "'${#REPOS[@]:-0}'"' || true; nl -ba scripts/egos-home/sync.sh | sed -n '28,42p'" in /home/enio/egos
 succeeded in 0ms:
bash: line 1: ${#REPOS[@]:-0}: bad substitution
    28	# - "$HOME/policia"   (sensitive/private workflow, isolated rules)
    29	# - "$HOME/personal"  (non-code/personal artifacts)
    30	# MYCELIUM-006 (2026-06-10): lista canônica única em agents/registry/leaf-repos.json
    31	# — NÃO adicionar repos aqui; adicionar no JSON. Fallback hardcoded só se jq/JSON ausente.
    32	LEAF_JSON="$(cd "$(dirname "$0")/../.." && pwd)/agents/registry/leaf-repos.json"
    33	if command -v jq >/dev/null 2>&1 && [ -f "$LEAF_JSON" ]; then
    34	  mapfile -t REPOS < <(jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == "") | .path' "$LEAF_JSON" 2>/dev/null)
    35	fi
    36	if [ "${#REPOS[@]:-0}" -eq 0 ]; then
    37	  echo "⚠️  leaf-repos.json indisponível — usando fallback hardcoded (atualizar JSON!)" >&2
    38	  REPOS=(
    39	    "$HOME/852" "$HOME/INPI" "$HOME/egos-lab" "$HOME/carteira-livre"
    40	    "$HOME/br-acc" "$HOME/forja" "$HOME/egos-self" "$HOME/commons"
    41	    "$HOME/smartbuscas" "$HOME/santiago" "$HOME/arch" "$HOME/intelink"
    42	  )

exec
/bin/bash -lc "bash -c 'REPOS=(a); echo "'${#REPOS[@]:-0}'"' || true" in /home/enio/egos
 succeeded in 0ms:
bash: line 1: ${#REPOS[@]:-0}: bad substitution

exec
/bin/bash -lc 'for p in SECURITY.md docs/governance/DOC_DRIFT_SHIELD.md central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md docs/products-specs/anythingllm/SETUP.md docs/products-specs/anythingllm/TROUBLESHOOTING.md docs/modules/CHATBOT_SSOT.md docs/modules/AGENT_RUNTIME_DESIGN.md docs/strategy/EGOS_MASTER_API_PRD.md docs/strategy/_archived_2026-05-06/../appendix/PRICING_ANCHORS.md; do [ -e "$p" ] && echo OK $p || echo MISSING $p; done' in /home/enio/egos
 succeeded in 0ms:
OK SECURITY.md
OK docs/governance/DOC_DRIFT_SHIELD.md
OK central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md
OK docs/products-specs/anythingllm/SETUP.md
MISSING docs/products-specs/anythingllm/TROUBLESHOOTING.md
OK docs/modules/CHATBOT_SSOT.md
OK docs/modules/AGENT_RUNTIME_DESIGN.md
OK docs/strategy/EGOS_MASTER_API_PRD.md
OK docs/strategy/_archived_2026-05-06/../appendix/PRICING_ANCHORS.md

exec
/bin/bash -lc "git diff --name-only 78914c603fe2843d37de18c3b4ae2ae7af132467 | sed -n '1,120p'" in /home/enio/egos
 succeeded in 0ms:
.agents/workflows/end.md
.agents/workflows/start.md
.claude/agents/critico.md
.claude/agents/forja.md
.claude/agents/guarani.md
.claude/agents/hermes-ops.md
.claude/agents/prime.md
.claude/commands/disseminate.md
.claude/commands/end.md
.claude/commands/start.md
.husky/pre-commit
AGENTS.md
CLAUDE.md
TASKS.md
TASKS_ARCHIVE.md
agents/registry/leaf-repos.json
apps/egos-landing/public/mycelium-snapshot.json
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/CAPABILITY_REGISTRY.md
docs/_archived_handoffs/2026-04/handoff_2026-03-31.md
docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md
docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md
docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md
docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md
docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md
docs/_archived_handoffs/2026-04/handoff_2026-04-14.md
docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md
docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md
docs/_archived_handoffs/2026-04/handoff_2026-04-23.md
docs/_archived_handoffs/2026-04/handoff_2026-04-24.md
docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md
docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md
docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md
docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md
docs/_archived_handoffs/HANDOFF_CURRENT.md
docs/_archived_handoffs/MEMORY_SESSION_INDEX.md
docs/_current_handoffs/FOR_GUARANI_2026-06-10_end-review.md
docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md
docs/_current_handoffs/handoff_2026-06-10.md
docs/agents/META_PROMPTS_INDEX.md
docs/audits/CAPABILITY_COVERAGE_2026-05-30.md
docs/audits/INTEGRATION_COVERAGE_2026-05-30.md
docs/banda/2026-06-10-dry-run.yaml
docs/concepts/ESPIRAIS_VISION.md
docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md
docs/governance/AREAS_OF_PRACTICE.md
docs/governance/CLIENT_KB_DOCTRINE.md
docs/governance/CLIENT_TIERS_MATRIX.md
docs/governance/EGOS_OPERATING_PRINCIPLES.md
docs/governance/MASTER_INDEX.md
docs/jobs/2026-06-10-doc-drift-verifier.json
docs/jobs/2026-06-10-pre-commit-pipeline.json
docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md
docs/products-specs/INDEX.md
docs/products-specs/anythingllm/OPERATIONS.md
docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md
docs/runbooks/MOBILE_ACCESS_GUIDE.md
docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md
scripts/disseminate-scanner.ts
scripts/egos-home/sync.sh

exec
/bin/bash -lc 'bun scripts/disseminate-scanner.ts --dry --since 78914c603fe2843d37de18c3b4ae2ae7af132467 >/tmp/scanner.out 2>&1; status=$?; echo status=$status; sed -n '"'1,80p' /tmp/scanner.out" in /home/enio/egos
 succeeded in 0ms:
status=1
[disseminate-scanner] commit=c350e8e3 since=78914c603fe2843d37de18c3b4ae2ae7af132467 date=2026-06-10
  ✅ global-claude-md: no changes
  ✅ windsurfrules: no changes
  🔄 project-claude-md: 2 section(s) changed
     - (preamble) (added, +1 lines)
     - ## Convenções (modified, +3 lines)
  🔄 capability-registry: 1 section(s) changed
     - (preamble) (modified, +2 lines)

🔴 Propagation needed: 3 rule section(s) changed across 13 repos

[DRY-RUN] Manifest (not written):
{
  "date": "2026-06-10",
  "commit": "c350e8e3",
  "since_commit": "78914c603fe2843d37de18c3b4ae2ae7af132467",
  "changed_rules": [
    {
      "file": "/home/enio/egos/CLAUDE.md",
      "label": "CLAUDE.md",
      "section": "(preamble)",
      "change_type": "added",
      "diff_lines": 1
    },
    {
      "file": "/home/enio/egos/CLAUDE.md",
      "label": "CLAUDE.md",
      "section": "## Convenções",
      "change_type": "modified",
      "diff_lines": 3
    },
    {
      "file": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
      "label": "CAPABILITY_REGISTRY.md",
      "section": "(preamble)",
      "change_type": "modified",
      "diff_lines": 2
    }
  ],
  "affected_repos": [
    "/home/enio/852",
    "/home/enio/br-acc",
    "/home/enio/carteira-livre",
    "/home/enio/intelink",
    "/home/enio/egos-lab",
    "/home/enio/forja",
    "/home/enio/smartbuscas",
    "/home/enio/santiago",
    "/home/enio/commons",
    "/home/enio/arch",
    "/home/enio/egos-self",
    "/home/enio/INPI",
    "/home/enio/egos-inteligencia"
  ],
  "existing_repos": [
    "/home/enio/852",
    "/home/enio/br-acc",
    "/home/enio/carteira-livre",
    "/home/enio/intelink",
    "/home/enio/egos-lab",
    "/home/enio/forja",
    "/home/enio/smartbuscas",
    "/home/enio/santiago",
    "/home/enio/commons",
    "/home/enio/arch",
    "/home/enio/egos-self",
    "/home/enio/INPI",
    "/home/enio/egos-inteligencia"
  ],
  "propagation_needed": true,
  "generated_at": "2026-06-10T11:59:04.528Z"
}

exec
/bin/bash -lc 'bash scripts/egos-home/sync.sh >/tmp/sync.out 2>&1; status=$?; echo status=$status; sed -n '"'1,50p' /tmp/sync.out" in /home/enio/egos
 succeeded in 0ms:
status=1
🔄 EGOS Sync v2.1 — Governance + Workflows + Skills + Claude Commands
═══════════════════════════════════════════════════════════

scripts/egos-home/sync.sh: line 36: ${#REPOS[@]:-0}: bad substitution

exec
/bin/bash -lc "git diff 78914c603fe2843d37de18c3b4ae2ae7af132467 -- apps/egos-landing/public/mycelium-snapshot.json apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/CAPABILITY_REGISTRY.md CLAUDE.md AGENTS.md | sed -n '1,240p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/AGENTS.md b/AGENTS.md
index b92392af..054f7a83 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -14,15 +14,16 @@ Output primes: non-negotiables, recent phantoms (INC-001..006), SSOT hashes, las
 <!-- PROPAGATE-RULES-BEGIN -->
 ## 📋 Canonical Rules (authoritative across ALL IDEs)
 
-This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**.
-
-> **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
+This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**. **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
 > 🃏 **4 pilares (TL;DR — resume R0-R8; conflito→texto completo. Corte Enio 2026-06-03):** **1)** §R0 safe-push, sem segredo, sem publish-sem-HITL, sem `git add -A`, commit TASKS.md já · **2)** §R1/R7 memory-mcp p/ código, externo=REAL/CONCEPT/PHANTOM, subagente=síntese, capacidade=≥3 golden cases · **3)** §R3/R4/R8/RLS frozen via Prime/`EGOS_FROZEN_OVERRIDE`, Guarani propõe/Prime commita, DB schema-first+RLS anon · **4)** §R2/Karpathy mínimo código, falhe visível, SSOT>duplicação.
 ### Highest-Leverage Rule
 EGOS maximizes value when it turns proven operational capability into governed reusable infrastructure.
 Default path: prove in a real leaf/runtime → extract what is reusable → register canonical ownership → enforce evidence and eval → reduce replication cost for the next repo/agent/client. When in doubt, prefer extraction over duplication, canon over parallel docs, deploy traceability over informal runtime assumptions.
 
+### R-DEV-001 — 100% AI-Driven Developer (No-Code Master) [T0 — 2026-06-10]
+**Enio não escreve nem lê código cru** — dev 100% por IAs, que assumem total responsabilidade técnica (NUNCA pedir copy/paste ou edição manual; editar direto com tools). Comunicação no nível de comportamento de sistema/fluxos/interfaces renderizadas (HTML/dashboards) — nunca snippets ou prosa técnica de baixo nível na conversa.
+
 ### R0 — Critical non-negotiables (irreversible damage prevention)
 1. **NEVER `git push --force` to main/master/production** — use `bash scripts/safe-push.sh` (INC-001)
 2. **NEVER log/echo/commit secrets** — no `.env`, no hardcoded keys
@@ -123,7 +124,7 @@ Canonical eval strategy: `docs/knowledge/AI_EVAL_STRATEGY.md` (being written —
 
 **R10 — Cooperação e Banda Cognitiva (Guarani ↔ Prime - 2026-06-04):** O Guarani (runtime Antigravity/Gemini) propõe código e correções técnicas, mas NUNCA realiza commits diretamente. Toda alteração de produção proposta pelo Guarani DEVE passar pela revisão final do Prime (Claude Code/Opus). Decisões de segurança crítica, modificações no schema de Banco de Dados, regras de RLS ou arquivos em Frozen Zones exigem obrigatoriamente a invocação da Banda Cognitiva (`/banda`) com Força Total (`--council` acionando Opus/Gemini Pro/GPT-5 via OpenRouter), assegurando verificação estrutural e AST anti-phantom.
 **R-SEC-002 [T0] — Dado soberano nunca sai da máquina (INC-PII-001 2026-06-04):** dado real de investigação / PII de terceiros / dado PCMG NUNCA versionado em git (nem privado), NUNCA servido em domínio público, NUNCA em VPS/nuvem. Git = apenas dados sintéticos; dado real = local cifrado. App com dado real → nunca domínio público aberto. Scanner pré-commit: `bun scripts/security/scan-hardcoded-sensitive.ts --staged`.
-**R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente (corte Enio 2026-06-10):** vendor/preço/prazo/stack/canal de CLIENTE sem confirmação = PARE → placeholder (`{PAYMENT_PROVIDER}`, `{PRICE}`, `{TIMELINE}`) + trade-off dos 2 caminhos; cliente escolhe no diagnóstico. Consolida R-DIAG-002..006 + R-ARCH-CLIENT-VENDOR (mata a proliferação de 7 versões). Full: `egos/CLAUDE.md §R-ARCH-001` · SSOT: `docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`.
+**R-ARCH-001 [T1] — EGOS mostra o FLUXO, não decide pelo cliente (Enio 2026-06-10):** vendor/preço/prazo/stack/canal de CLIENTE sem confirmação = PARE → placeholder (`{PAYMENT_PROVIDER}`/`{PRICE}`/`{TIMELINE}`) + trade-off; cliente escolhe no diagnóstico. Consolida R-DIAG-002..006+VENDOR. Full: `egos/CLAUDE.md §R-ARCH-001`.
 **R-SEC-003 [T1] — Segurança = enforcement:** toda regra de segurança DEVE ter gate executável. Scanner sem wiring = doc morto. Sugestão mock/fixture: `// scan-ok: mock` ou `<!-- scan-ok -->`. SSOT: `docs/INCIDENTS/INC-PII-001_investigation-data-leak.md`.
 **R-DISCOVER-001 [T2] — Discover-before-create (2026-06-08):** antes de criar capability nova (package/command/skill/CBC/registry), rodar `bun scripts/discover-capability.ts <termo>` e incluir `CONSULTED-SSOT: <resultado>` no commit body. Gate 14 bloqueia sem prova. Escape: `DISCOVER-GATE-SKIP: <razão>`. Evita INC-009-leaf-silo.
 **R11 [T2] — Observabilidade warn-not-block (2026-06-05):** falha em telemetria/agent-observatory = warn-only, nunca bloqueia execução de agente. SSOT: `docs/governance/MULTI_AGENT_OBSERVABILITY.md`.
@@ -196,4 +197,4 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 ## Templates de domínio (L0-DEF-002 — 2026-05-29)
 Vertical setorial em `central-egos/products/<slug>/` que herda Layer 0 (T0-T2 + R0-R6 + .guarani) sem duplicar. **Ativos:** advocacia-starter v1.0. **Protocolo:** (1) `INHERITS.md` obrigatório com frontmatter YAML; (2) overrides só via `OVERRIDES.md` com justificativa — T0 nunca sobrescrito; (3) duplicação do kernel deve virar ref curta. **SSOTs:** [LAYER_0_SSOT.md](docs/governance/LAYER_0_SSOT.md) · [TEMPLATE_INHERITANCE_PROTOCOL.md](docs/governance/TEMPLATE_INHERITANCE_PROTOCOL.md) · [DOMAIN_TEMPLATE_SPEC.md](docs/governance/DOMAIN_TEMPLATE_SPEC.md).
 ## Meta-Prompts + Docs
-`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/business/MONETIZATION_SSOT.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
+`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
diff --git a/CLAUDE.md b/CLAUDE.md
index ee6cb208..1cbff198 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -13,6 +13,7 @@
 3. **Red Zone** (ética, copy pública, pricing, arquitetura, segurança, contexto policial/PII) → PARAR, apresentar opções, esperar corte do Enio. Nunca auto-resolver.
 4. **Evidence-first + Karpathy** (mínimo código, entender > produzir, falha visível) + **Resolver Doctrine** (você é a última camada; triagem `R=L/C`).
 5. **HITL** — nunca publicar/deployar/deletar sem aprovação humana.
+6. **No-Code Master (100% IA-Driven):** O usuário Enio não escreve nem lê código. Assuma 100% da responsabilidade técnica operacional pela codificação, testes e correções. Nunca peça ao usuário para colar/copiar ou modificar arquivos manualmente; edite-os diretamente com suas ferramentas. Interaja no nível funcional e visual.
 
 **O que os comandos fazem (enriquecem, não "ativam" a identidade):** `/start` = carrega contexto profundo da sessão (regras, memória, handoff, estado). `/opus` = aprofunda (Banda/Council/Fibonacci). `/end` = consolida e passa adiante. **Sem eles você ainda é EGOS — só com menos contexto carregado.** Se a conversa for não-trivial e você não rodou `/start`, ofereça rodá-lo para carregar o contexto completo.
 
@@ -81,11 +82,12 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 ---
 
 ## Convenções
-
+ 
 - Commits: conventional, cada 30-60min
 - TypeScript: estrito, zero `any` implícito
 - DRY-RUN: todo agent suporta `--dry` antes de `--exec`
 - Edit Size: máx 80 linhas por operação de escrita
+- **100% AI-Driven / No-Code Master [T1 — 2026-06-10]:** O usuário Enio não escreve nem lê código cru. As IAs têm autonomia total para codificação, testes e correções de bugs. Comunicação com o usuário focada em layouts/fluxos funcionais e interfaces, nunca em snippets de código ou sintaxe de baixo nível na conversa.
 - **UI/Produto [T1 — Enio 2026-06-05]:** uma tela = UM trabalho dominante; o que competir vira camada secundária. Antes de publicar QUALQUER tela pública, rodar o **Publication Gate (R-UI-005)**. SSOT: `docs/governance/UI_PRODUCT_RULES.md` (One Job Per Screen + UI Intent Contract + No Competing Modes + Live System Page + Publication Gate + Premortem). Origem: engenharia reversa do incidente Mycelium-3-jobs.
 - **README: PT-BR obrigatório, score ≥ 4/5** — SSOT: `docs/governance/README_PADRAO_OURO.md`
   - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
diff --git a/apps/egos-landing/public/mycelium-snapshot.json b/apps/egos-landing/public/mycelium-snapshot.json
index 8ab6e9f2..7567eb13 100644
--- a/apps/egos-landing/public/mycelium-snapshot.json
+++ b/apps/egos-landing/public/mycelium-snapshot.json
@@ -1,6 +1,6 @@
 {
   "version": "1.0.0",
-  "generated": "2026-06-10T10:56:21.624Z",
+  "generated": "2026-06-10T11:18:52.380Z",
   "nodes": [
     {
       "id": "ws:egos-kernel",
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
diff --git a/docs/CAPABILITY_REGISTRY.md b/docs/CAPABILITY_REGISTRY.md
index 8a92891b..67d3cf5a 100644
--- a/docs/CAPABILITY_REGISTRY.md
+++ b/docs/CAPABILITY_REGISTRY.md
@@ -2817,7 +2817,7 @@ MCP administrativo para G Peças exposto via REST e MCP nativo. 10 tools: 6 read
 - **Status:** COMPLETO Fases 1-7 — 33 tools, v0.7.0, deploy prod pendente
 - **Owner:** Enio Rocha (PO) + Claude Opus 4.7 (orquestração) + Claude Sonnet 4.6 (execução)
 - **Evidence:** 120 golden cases (288 assertions) em CBC-EGOS-MCP-G-PECAS.eval.ts. 33 tools: 10 read + 23 write. Typecheck ✅.
-- **Plano:** [docs/planning/MCP_WRITE_EXPAND_PLAN.md](docs/planning/MCP_WRITE_EXPAND_PLAN.md)
+- **Plano:** [docs/planning/MCP_WRITE_EXPAND_PLAN.md](planning/MCP_WRITE_EXPAND_PLAN.md)
 - **Objetivo:** ChatGPT GPT personalizado faz 100% do admin G Peças
 
 Expansão do MCP G Peças de 10 tools (1 write) para 40+ tools (30+ write) cobrindo admin completo: produtos, estoque, pedidos, chatbot, FAQ, IA, workflow, usuários. Princípio de design: tools INTELIGENTES (confirmação 2-step para destrutivas, `needs[]` em cada resposta indicando o que falta para próximo estado, `next_actions[]` clicáveis apontando dashboard). Audit com `origin_channel` (mcp vs dashboard).

exec
/bin/bash -lc "grep -R \"egos-home/sync\\|sync.sh\" -n scripts | head -40" in /home/enio/egos
 succeeded in 2042ms:
scripts/x-auto-dm.ts:232:  private async shouldSendMessage(
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:209:| Governance Sync Plane | `egos/scripts/governance-sync.sh` + `~/.egos/sync.sh` | A | Kernel + synced leaves | — | `governance`, `sync`, `ssot` |
scripts/egos-home/sync.sh:8:# Usage: ~/.egos/sync.sh
scripts/egos-home/sync.sh:274:  # REAL canonical source (governance-sync.sh pushes kernel→home, not the reverse). Only leaf
scripts/egos-home/sync.sh:327:  # Source: ~/.claude/commands/ (kernel canonical, propagado pelo governance-sync.sh)
scripts/egos-home/sync.sh:389:echo "To add a new repo: add to REPOS array in /home/enio/egos/scripts/egos-home/sync.sh"
scripts/egos-home/README.md:14:                          ↓ governance-sync.sh
scripts/egos-home/README.md:25:└── sync.sh                        ← Auto-sync to all repos
scripts/egos-home/README.md:38:4. **`scripts/governance-sync.sh`** mirrors kernel governance into `~/.egos/`
scripts/egos-home/README.md:39:5. **`~/.egos/sync.sh`** propagates workflows, hooks, and selected governance surfaces
scripts/hermes-audit-and-sync.sh:2:# hermes-audit-and-sync.sh — Local cron wrapper for task audit + VPS sync
scripts/runtime-smoke.ts:41:const governanceSyncPath = join(ROOT, "scripts", "governance-sync.sh");
scripts/runtime-smoke.ts:56:    governance_sync: "scripts/governance-sync.sh",
scripts/runtime-smoke.ts:262:  compareText(join(egosHomeRoot, "sync.sh"), join(EGOS_HOME, "sync.sh"), "shared-home", "home sync.sh");
scripts/runtime-smoke.ts:263:  checkExecutableFile(join(EGOS_HOME, "sync.sh"), "shared-home", "home sync.sh executable");
scripts/pre-commit-doc-sync.sh:2:# pre-commit-doc-sync.sh — enforce code↔docs sync no pre-commit
scripts/governance-propagate.sh:359:# ── Update ~/.egos/sync.sh REPOS if intelink is missing ──
scripts/governance-propagate.sh:360:SYNC_FILE="$HOME/.egos/sync.sh"
scripts/governance-propagate.sh:363:    warn "~/.egos/sync.sh REPOS array missing intelink"
scripts/governance-propagate.sh:366:      ok "~/.egos/sync.sh updated: intelink added"
scripts/governance-propagate.sh:369:      dry "Would add intelink to ~/.egos/sync.sh REPOS"
scripts/governance-propagate.sh:372:    ok "~/.egos/sync.sh already includes intelink"
scripts/vps-dependency-sync.sh:9:#   ssh enio@<vps> "cd /opt/egos && bash scripts/vps-dependency-sync.sh --check"
scripts/vps-dependency-sync.sh:10:#   ssh enio@<vps> "cd /opt/egos && bash scripts/vps-dependency-sync.sh --apply <id>"
scripts/egos-autoheal.ts:17: *   3. scripts/egos-home/sync.sh           → ~/.egos/sync.sh                (line 259 smoke)
scripts/egos-autoheal.ts:285:  const govSync = existsSync(join(ROOT, "scripts", "governance-sync.sh"))
scripts/egos-autoheal.ts:286:    ? readFileSync(join(ROOT, "scripts", "governance-sync.sh"), "utf-8")
scripts/egos-autoheal.ts:302:  // ── (2) sync.sh: scripts/egos-home/sync.sh → ~/.egos/sync.sh
scripts/egos-autoheal.ts:303:  log("[egos-home sync.sh]");
scripts/egos-autoheal.ts:304:  healPlainFile(join(egosHomeRoot, "sync.sh"), join(EGOS_HOME, "sync.sh"));
scripts/workflow-sync-check.sh:123:      echo -e "    ${YELLOW}Fix:${NC} Add '$repo_name' to ~/.egos/sync.sh REPOS array and run sync"
scripts/workflow-sync-check.sh:187:        echo -e "    ${YELLOW}Fix:${NC} Run ~/.egos/sync.sh to install missing workflows"
scripts/workflow-sync-check.sh:232:  echo -e "  ${YELLOW}Stale:${NC}   $REPOS_STALE  (run ~/.egos/sync.sh to fix)"
scripts/workflow-sync-check.sh:233:  echo -e "  ${RED}Missing:${NC} $REPOS_MISSING  (add to ~/.egos/sync.sh REPOS + run sync)"
scripts/workflow-sync-check.sh:237:    echo -e "Run: ~/.egos/sync.sh"
scripts/workflow-sync-check.sh:241:      echo -e "       Run ~/.egos/sync.sh to convert real files to symlinks."
scripts/claude-runtime/hooks/auto-sync.sh:2:# .claude/hooks/auto-sync.sh
scripts/claude-runtime/hooks/auto-sync.sh:22:  command -v emit_rule_event >/dev/null 2>&1 && emit_rule_event "HOOK-AUTO-SYNC" "auto-sync.sh" "info" "claude_changes_detected" "{\"repo_root\":\"${REPO_ROOT}\"}"
scripts/claude-runtime/hooks/auto-sync.sh:38:  command -v emit_rule_event >/dev/null 2>&1 && emit_rule_event "HOOK-AUTO-SYNC" "auto-sync.sh" "info" "claude_sync_committed" "{\"repo_root\":\"${REPO_ROOT}\"}"
scripts/runtime-smoke-validator.ts:59:    'scripts/egos-home/sync.sh',

exec
/bin/bash -lc "nl -ba scripts/egos-home/sync.sh | sed -n '380,392p' && git diff 78914c603fe2843d37de18c3b4ae2ae7af132467 -- scripts/egos-home/sync.sh | tail -20" in /home/enio/egos
 succeeded in 0ms:
   380	echo "   ⚡ Workflows:  ~/.egos/workflows/ → .agent + .windsurf"
   381	echo "   🎯 Skills:     ~/.egos/skills/ → .agent + .windsurf"
   382	echo "   🤖 Commands:   ~/.claude/commands/ → <repo>/.claude/commands/ (symlinks)"
   383	echo ""
   384	echo "Rule precedence (per repo):"
   385	echo "  1. Local files (.guarani/, workflows/)  ← HIGHEST"
   386	echo "  2. Shared EGOS (~/.egos/)               ← MEDIUM"
   387	echo "  3. Agent rules (.windsurfrules, etc.)   ← AGENT-SPECIFIC"
   388	echo ""
   389	echo "To add a new repo: add to REPOS array in /home/enio/egos/scripts/egos-home/sync.sh"
-  "$HOME/arch"       # EGOS governance bootstrap
-  "$HOME/intelink"          # intelink (migrado de egos-inteligencia 2026-05-05)
-)
+# MYCELIUM-006 (2026-06-10): lista canônica única em agents/registry/leaf-repos.json
+# — NÃO adicionar repos aqui; adicionar no JSON. Fallback hardcoded só se jq/JSON ausente.
+LEAF_JSON="$(cd "$(dirname "$0")/../.." && pwd)/agents/registry/leaf-repos.json"
+if command -v jq >/dev/null 2>&1 && [ -f "$LEAF_JSON" ]; then
+  mapfile -t REPOS < <(jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == "") | .path' "$LEAF_JSON" 2>/dev/null)
+fi
+if [ "${#REPOS[@]:-0}" -eq 0 ]; then
+  echo "⚠️  leaf-repos.json indisponível — usando fallback hardcoded (atualizar JSON!)" >&2
+  REPOS=(
+    "$HOME/852" "$HOME/INPI" "$HOME/egos-lab" "$HOME/carteira-livre"
+    "$HOME/br-acc" "$HOME/forja" "$HOME/egos-self" "$HOME/commons"
+    "$HOME/smartbuscas" "$HOME/santiago" "$HOME/arch" "$HOME/intelink"
+  )
+fi
 
 # ── Step 1: Validate central governance ──
 echo "📋 Step 1: Validating central governance..."

codex
The updated sync script now fails at runtime due to an invalid Bash substitution, blocking a documented governance propagation path. Even after that is fixed, the registry path resolution will miss the canonical JSON when the script is run from its installed `~/.egos` location.

Full review comments:

- [P1] Fix array-length fallback test in sync.sh — /home/enio/egos/scripts/egos-home/sync.sh:36-36
  When `sync.sh` reaches this fallback check, Bash rejects `${#REPOS[@]:-0}` as a bad substitution, so the script exits before validating or syncing any repo. This breaks both direct runs and the documented `/disseminate` step `bash ~/.egos/sync.sh`; use a valid array-length check such as `${#REPOS[@]}` after initializing `REPOS`.

- [P2] Resolve the leaf registry path from the installed location — /home/enio/egos/scripts/egos-home/sync.sh:32-34
  This script is installed and documented to run as `~/.egos/sync.sh`, but from that location `$(dirname "$0")/../..` resolves to `/home`, so it will not find `/home/enio/egos/agents/registry/leaf-repos.json` and will fall back to the stale hardcoded list instead of the new canonical registry. New repos added only to `leaf-repos.json` would therefore not receive sync propagation.
The updated sync script now fails at runtime due to an invalid Bash substitution, blocking a documented governance propagation path. Even after that is fixed, the registry path resolution will miss the canonical JSON when the script is run from its installed `~/.egos` location.

Full review comments:

- [P1] Fix array-length fallback test in sync.sh — /home/enio/egos/scripts/egos-home/sync.sh:36-36
  When `sync.sh` reaches this fallback check, Bash rejects `${#REPOS[@]:-0}` as a bad substitution, so the script exits before validating or syncing any repo. This breaks both direct runs and the documented `/disseminate` step `bash ~/.egos/sync.sh`; use a valid array-length check such as `${#REPOS[@]}` after initializing `REPOS`.

- [P2] Resolve the leaf registry path from the installed location — /home/enio/egos/scripts/egos-home/sync.sh:32-34
  This script is installed and documented to run as `~/.egos/sync.sh`, but from that location `$(dirname "$0")/../..` resolves to `/home`, so it will not find `/home/enio/egos/agents/registry/leaf-repos.json` and will fall back to the stale hardcoded list instead of the new canonical registry. New repos added only to `leaf-repos.json` would therefore not receive sync propagation.
```
