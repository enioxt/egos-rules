# Codex Local Review — 2026-06-10T11:38:59Z

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
session id: 019eb154-1c7b-7543-9006-e2c9d58a0f55
--------
user
changes against 'HEAD~3'
2026-06-10T11:39:01.335863Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T11:39:01.336196Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff c08063cf514ae0fcb725ff32673236996e54c232 --stat && git diff c08063cf514ae0fcb725ff32673236996e54c232' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/end.md                           |   2 +
 .agents/workflows/start.md                         |   2 +
 .claude/agents/critico.md                          |   1 +
 .claude/agents/forja.md                            |   1 +
 .claude/agents/guarani.md                          |   1 +
 .claude/agents/hermes-ops.md                       |   1 +
 .claude/agents/prime.md                            |   1 +
 .claude/commands/disseminate.md                    |   7 +-
 .claude/commands/end.md                            |   2 +
 .claude/commands/start.md                          |   2 +
 .husky/pre-commit                                  |   9 +
 AGENTS.md                                          |   9 +-
 CLAUDE.md                                          |   4 +-
 TASKS.md                                           |  42 ++--
 TASKS_ARCHIVE.md                                   |  17 ++
 agents/registry/leaf-repos.json                    |  88 ++++++++
 apps/egos-landing/public/mycelium-snapshot.json    |   2 +-
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md     |  41 ++++
 docs/banda/2026-06-10-dry-run.yaml                 |  38 ++++
 .../constitution-hashes/2026-06-10.sha256          |  17 ++
 .../constitution-hashes/2026-06-10.sha256.ots      | Bin 0 -> 630 bytes
 docs/jobs/2026-06-10-doc-drift-verifier.json       | 244 +++++++++++++++++++++
 docs/jobs/2026-06-10-pre-commit-pipeline.json      | 234 ++++++++++++++++++++
 scripts/disseminate-scanner.ts                     |  30 +--
 26 files changed, 760 insertions(+), 39 deletions(-)
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
index 472a97cd..33366e0a 100644
--- a/.claude/agents/guarani.md
+++ b/.claude/agents/guarani.md
@@ -79,3 +79,4 @@ Todo ciclo loga em `~/.egos/agent-runs/guarani-<runid>.jsonl`:
 - **Cláusula-árbitro:** em conflito de REGRA de agente, AGENTS.md vence sobre .guarani; em conflito de PROCESSO/pipeline, .guarani vence
 - **Claim sem prova = UNVERIFIED:** prefixar achados não confirmados por leitura direta
 - **Sem `git add -A`** — mesmo que nunca commite, nunca prepara staging
+- **No-Code Master (100% IA-Driven):** O usuário Enio não edita nem lê código cru. Assuma que toda intervenção técnica deve ser gerada por IAs. Proponha apenas soluções auto-executáveis e audite drifts técnicos sem depender de ações manuais do usuário. Interact em nível estratégico.
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
index b92392af..7a7bbd06 100644
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
index 2ce2736d..5a5dcec2 100644
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
+- [x] **R-ELEVATE-001-COUNCIL-001** [P1] `prime` `gated:banda+codex+corte-Enio` ✅ 2026-06-10
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
diff --git a/docs/governance/constitution-hashes/2026-06-10.sha256 b/docs/governance/constitution-hashes/2026-06-10.sha256
new file mode 100644
index 00000000..fa500dfd
--- /dev/null
+++ b/docs/governance/constitution-hashes/2026-06-10.sha256
@@ -0,0 +1,17 @@
+# EGOS Constitution Hash — 2026-06-10
+# Generated by: .github/workflows/constitution-anchor.yml
+# Trigger: push — c08063cf514ae0fcb725ff32673236996e54c232
+# Algorithm: SHA-256 canonical digest
+#
+# Files anchored:
+#   .guarani/RULES_INDEX.md
+#   scripts/claude-runtime/manifest.json
+#
+# To verify: scripts/proof-verify.sh docs/governance/constitution-hashes/2026-06-10.sha256 docs/governance/constitution-hashes/2026-06-10.sha256.ots
+
+RULES_INDEX:5f6b2035a74f80ac65b198024ad356a347ea065bb23a87db4a2b8e08e4106b95
+MANIFEST:a58f10a1e00a05914819e391916cf2950a5ab6f76cf46d9aa4c9f0c83b213383
+COMBINED:b18d3febd772c7aef6cb6d58921cfd1ddcbac014356030a3df1ea710db92c005
+
+# COMBINED = SHA-256 of "RULES_INDEX:<hash>\nMANIFEST:<hash>\n"
+# This is the exact value submitted to Bitcoin via OpenTimestamps.
diff --git a/docs/governance/constitution-hashes/2026-06-10.sha256.ots b/docs/governance/constitution-hashes/2026-06-10.sha256.ots
new file mode 100644
index 00000000..731b9772
Binary files /dev/null and b/docs/governance/constitution-hashes/2026-06-10.sha256.ots differ
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
 

exec
/bin/bash -lc "sed -n '1,180p' agents/registry/leaf-repos.json && sed -n '1,220p' scripts/disseminate-scanner.ts && sed -n '1,100p' .claude/commands/disseminate.md && nl -ba .husky/pre-commit | sed -n '660,705p'" in /home/enio/egos
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

## §5. Conhecimento + estado (fases de fechamento — preserva v1)

- **HARVEST.md** — novo pattern/gotcha/decisão da sessão (formato Problem/Solution/Rule).
- **CAPABILITY_REGISTRY** — nova capability (Status+Evidence+Owner; R-CAP-001 ciclo de vida).
- **TASKS.md** — marcar [x], adicionar descobertas, manter < limite.
- **Memory** — `~/.claude/projects/-home-enio-egos/memory/` + índice.
- **NotebookLM** — doc canônico mudou → re-sync ADD-only (HITL deleção).
- **Social** (só milestone): Telegram @ethikin · X @anoineim.

## §6. Checklist de saída
   660	fi
   661	
   662	# 5.85. SSOT Claim Check — Warn on scored tables without evidence (INC-006 SHIM-004, non-blocking)
   663	echo "  [5.85/8] ssot claim-check: scanning for phantom-prone scored tables..."
   664	bun scripts/ssot-claim-check.ts --all 2>/dev/null | head -6 || true
   665	
   666	# 5.9. Evidence Gate — §33 Evidence-First Principle (warning-only until 2026-04-16)
   667	echo "  [5.9/8] evidence-gate: checking claim backing in staged docs..."
   668	bun scripts/evidence-gate.ts --staged-only 2>/dev/null || {
   669	  echo "⚠️  evidence-gate: script error (non-blocking). Run: bun scripts/evidence-gate.ts --staged-only"
   670	}
   671	
   672	# 5.95. Capability Detector — validate new capabilities have CBC + eval (MCP-F4-001)
   673	# Ativado via EGOS_CAPABILITY_VALIDATE=1 (warn) ou EGOS_CAPABILITY_STRICT=1 (block)
   674	bash .husky/_checks/5.95-capability-detector.sh 2>/dev/null || true
   675	
   676	# 13. Registry Parity — hard-fail on NEW packages/apps/agents missing §-entry (REG-PARITY-001)
   677	# Escape: `REGISTRY-PARITY-SKIP: <reason>` in commit body, or EGOS_REGISTRY_PARITY_SKIP=<reason>
   678	# SSOT: docs/governance/REGISTRY_PARITY_DECISION.md
   679	echo "  [13/N] registry-parity: scanning staged adds for missing registry entries..."
   680	bash .husky/_checks/13-registry-parity.sh || exit 1
   681	
   682	# 14. Discover Gate — exige CONSULTED-SSOT: no body ao criar nova capability (DISCOVER-GATE-003)
   683	# Escape: `DISCOVER-GATE-SKIP: <razão>` no commit body ou DISCOVER_GATE_SKIP=<razão> no env
   684	# SSOT: scripts/discover-capability.ts | R-DISCOVER-001
   685	if [ -x ".husky/_checks/14-discover-gate.sh" ]; then
   686	  echo "  [14/N] discover-gate: verificando prova de consulta para nova capability..."
   687	  bash .husky/_checks/14-discover-gate.sh || exit 1
   688	fi
   689	
   690	# 15. Agent Gate — exige roster + triggers.json + golden case ao criar persona LLM (AGENT-GATE-001)
   691	# Escape: status: agent_candidate no frontmatter | AGENT-GATE-SKIP: <razão> no commit body
   692	# SSOT: docs/governance/EGOS_AGENT_ORGANIZATION.md §1
   693	if [ -x ".husky/_checks/15-agent-gate.sh" ]; then
   694	  echo "  [15/N] agent-gate: verificando obrigações de nova persona LLM..."
   695	  bash .husky/_checks/15-agent-gate.sh || exit 1
   696	fi
   697	
   698	# 6. File Intelligence — Classification + Compliance + PII scan
   699	echo "  [5/5] file intelligence: classifying and checking staged files..."
   700	bash scripts/file-intelligence.sh 2>/dev/null || {
   701	  echo "❌ BLOCKED: File intelligence found critical violations."
   702	  echo "   Run: bash scripts/file-intelligence.sh for details"
   703	  exit 1
   704	}
   705	

exec
/bin/bash -lc "sed -n '220,520p' scripts/disseminate-scanner.ts && git diff c08063cf514ae0fcb725ff32673236996e54c232 -- scripts/disseminate-scanner.ts agents/registry/leaf-repos.json .claude/commands/disseminate.md .husky/pre-commit CLAUDE.md TASKS.md" in /home/enio/egos
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
index 2ce2736d..5a5dcec2 100644
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
+- [x] **R-ELEVATE-001-COUNCIL-001** [P1] `prime` `gated:banda+codex+corte-Enio` ✅ 2026-06-10
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
/bin/bash -lc 'ls -l .husky/_checks/15-agent-gate.sh 2>/dev/null || true; git ls-files .husky/_checks | tail -20' in /home/enio/egos
 succeeded in 0ms:
-rwxrwxr-x 1 enio enio 6982 Jun 10 07:51 .husky/_checks/15-agent-gate.sh
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

exec
/bin/bash -lc "sed -n '1,220p' .husky/_checks/15-agent-gate.sh" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bash
# 15-agent-gate.sh — AGENT-GATE-001
# Exige roster + triggers.json + golden case ao criar nova persona LLM em .claude/agents/
# Escape: status: agent_candidate no frontmatter | AGENT_GATE_SKIP=<razão> no env
# NOTA: escape via commit body é IMPOSSÍVEL em pre-commit — COMMIT_EDITMSG ainda
# contém a mensagem do commit ANTERIOR neste momento (fail-open detectado 2026-06-09:
# 28bce96f documentava a string do escape e pulava o gate dos commits seguintes).
# SSOT: docs/governance/EGOS_AGENT_ORGANIZATION.md §1

set -euo pipefail

# ── Skip explícito via env ────────────────────────────────────────────────────
if [ -n "${AGENT_GATE_SKIP:-}" ]; then
  echo "  [15] agent-gate SKIP via env: $AGENT_GATE_SKIP"
  exit 0
fi

STAGED=$(git diff --cached --name-only 2>/dev/null || true)
[ -z "$STAGED" ] && exit 0

# ── Detectar arquivos novos de persona em .claude/agents/ ────────────────────
# --diff-filter=A = apenas arquivos adicionados (novos)
NEW_AGENTS=$(git diff --cached --name-only --diff-filter=A 2>/dev/null \
  | grep -E "^\.claude/agents/[^/]+\.md$" \
  | grep -vE "\-brief\.md$" \
  | grep -vE "\-template\.md$" \
  || true)

[ -z "$NEW_AGENTS" ] && exit 0

echo "  [15] agent-gate ativado: novos agentes detectados"

# ── Processar cada arquivo de agente novo ─────────────────────────────────────
GATE_FAILED=0

while IFS= read -r AGENT_FILE; do
  echo "  [15] verificando: $AGENT_FILE"

  # Extrair as primeiras 10 linhas do arquivo staged
  FRONTMATTER=$(git show ":$AGENT_FILE" 2>/dev/null | head -10 || true)

  # Extrair name: e model: do frontmatter
  HAS_NAME=$(echo "$FRONTMATTER" | grep -cE "^name: *[^[:space:]]+" || true)
  HAS_MODEL=$(echo "$FRONTMATTER" | grep -cE "^model: *[^[:space:]]+" || true)

  # ── Discriminação: fragmento vs persona ──────────────────────────────────
  if [ "$HAS_NAME" -eq 0 ] || [ "$HAS_MODEL" -eq 0 ]; then
    echo ""
    echo "  [15] ⚠️  AVISO: frontmatter incompleto em $AGENT_FILE"
    echo "  [15]    complete frontmatter com name: + model: ou renomeie para *-brief.md"
    echo ""
    # Warn apenas, não bloqueia
    continue
  fi

  # Extrair o nome do agente
  NAME=$(echo "$FRONTMATTER" | grep -oE "^name: *[^[:space:]]+" | head -1 | sed 's/^name: *//')

  echo "  [15] persona detectada: '$NAME'"

  # ── Verificar escape: status: agent_candidate ─────────────────────────────
  IS_CANDIDATE=$(echo "$FRONTMATTER" | grep -cE "^status: *agent_candidate" || true)
  if [ "$IS_CANDIDATE" -gt 0 ]; then
    echo "  [15] ⚠️  CANDIDATO: '$NAME' — obrigações pendentes (ver AGENT-GATE-001)"
    echo "  [15]    status: agent_candidate detectado — checagens puladas"
    continue
  fi

  # ── Obrigação 1: NAME em EGOS_AGENT_ORGANIZATION.md ──────────────────────
  ROSTER_FILE="docs/governance/EGOS_AGENT_ORGANIZATION.md"
  if [ ! -f "$ROSTER_FILE" ]; then
    echo ""
    echo "  [15] ❌ AGENT-GATE: $ROSTER_FILE não encontrado"
    GATE_FAILED=1
    continue
  fi

  if ! grep -qi "$NAME" "$ROSTER_FILE" 2>/dev/null; then
    echo ""
    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' não está no roster $ROSTER_FILE §1"
    echo "  [15]    Resolução: adicione '$NAME' em $ROSTER_FILE §1"
    GATE_FAILED=1
  else
    echo "  [15] ✅ roster OK: '$NAME' encontrado em $ROSTER_FILE"
  fi

  # ── Obrigação 2: NAME em agents/registry/triggers.json ───────────────────
  TRIGGERS_FILE="agents/registry/triggers.json"
  if [ ! -f "$TRIGGERS_FILE" ]; then
    echo ""
    echo "  [15] ❌ AGENT-GATE: $TRIGGERS_FILE não encontrado"
    GATE_FAILED=1
  elif ! grep -q "$NAME" "$TRIGGERS_FILE" 2>/dev/null; then
    echo ""
    echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem entrada em agents/registry/triggers.json"
    echo "  [15]    Resolução: adicione '$NAME' em agents/registry/triggers.json"
    GATE_FAILED=1
  else
    echo "  [15] ✅ triggers OK: '$NAME' encontrado em $TRIGGERS_FILE"
  fi

  # ── Obrigação 3: golden case em tests/eval/ ───────────────────────────────
  EVAL_DIR="tests/eval"
  if [ ! -d "$EVAL_DIR" ]; then
    echo ""
    echo "  [15] ❌ AGENT-GATE: diretório $EVAL_DIR não encontrado"
    GATE_FAILED=1
  else
    GOLDEN_COUNT=$(find "$EVAL_DIR" -name "*${NAME}*" 2>/dev/null | wc -l || echo 0)
    if [ "$GOLDEN_COUNT" -eq 0 ]; then
      echo ""
      echo "  [15] ❌ AGENT-GATE: Agent '$NAME' sem golden case em tests/eval/ (R7 — ≥1 obrigatório)"
      echo "  [15]    Resolução: crie tests/eval/${NAME}-golden.md"
      GATE_FAILED=1
    else
      echo "  [15] ✅ golden OK: $GOLDEN_COUNT arquivo(s) em $EVAL_DIR para '$NAME'"
    fi
  fi

done <<< "$NEW_AGENTS"

# ── Bloqueio se alguma obrigação falhou ───────────────────────────────────────
if [ "$GATE_FAILED" -ne 0 ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  [15] ❌ AGENT-GATE-001: persona LLM sem obrigações cumpridas"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  Para cada nova persona em .claude/agents/<name>.md, você precisa:"
  echo ""
  echo "  1. Registrar no roster:"
  echo "       docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
  echo ""
  echo "  2. Registrar nos triggers:"
  echo "       agents/registry/triggers.json"
  echo ""
  echo "  3. Criar ao menos 1 golden case:"
  echo "       tests/eval/<name>-golden.md"
  echo ""
  echo "  ── ESCAPES ──────────────────────────────────────────────────────"
  echo "  • Frontmatter do agente:  status: agent_candidate"
  echo "    (warn apenas; obrigações ficam pendentes para commit futuro)"
  echo ""
  echo "  • Env var:      AGENT_GATE_SKIP=<razão> git commit ..."
  echo ""
  echo "  SSOT: AGENT-GATE-001 | docs/governance/EGOS_AGENT_ORGANIZATION.md §1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  exit 1
fi

exit 0

exec
/bin/bash -lc 'bun scripts/disseminate-scanner.ts --dry --since c08063cf514ae0fcb725ff32673236996e54c232; echo exit:$?' in /home/enio/egos
 succeeded in 0ms:
[disseminate-scanner] commit=c5ed3947 since=c08063cf514ae0fcb725ff32673236996e54c232 date=2026-06-10
  ✅ global-claude-md: no changes
  ✅ windsurfrules: no changes
  🔄 project-claude-md: 2 section(s) changed
     - (preamble) (added, +1 lines)
     - ## Convenções (modified, +3 lines)
  ✅ capability-registry: no changes

🔴 Propagation needed: 2 rule section(s) changed across 13 repos

[DRY-RUN] Manifest (not written):
{
  "date": "2026-06-10",
  "commit": "c5ed3947",
  "since_commit": "c08063cf514ae0fcb725ff32673236996e54c232",
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
  "generated_at": "2026-06-10T11:39:49.452Z"
}
exit:1

exec
/bin/bash -lc "git diff c08063cf514ae0fcb725ff32673236996e54c232 -- apps/egos-landing/public/mycelium-snapshot.json apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml AGENTS.md | sed -n '1,240p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/AGENTS.md b/AGENTS.md
index b92392af..7a7bbd06 100644
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

exec
/bin/bash -lc 'git log --oneline --decorate --max-count=5 && git diff --name-only c08063cf514ae0fcb725ff32673236996e54c232' in /home/enio/egos
 succeeded in 0ms:
c5ed3947 (HEAD -> main, origin/main) chore(governance): absorve WIP Guarani — R-DEV-001 No-Code Master disseminado + R-ELEVATE-001 vira task
6b813f01 feat(disseminate): leaf-repos.json SSOT + UPSTREAM_KERNEL 11 leaves + TASKS estado real MYCELIUM
78914c60 chore(anchor): constitution hash 2026-06-10 [OTS pending Bitcoin]
c08063cf feat(mycelium): ponte Redis cross-process — bus sai de 0 subscribers reais [rework-ok]
abce63b2 feat(governance): Fable wave-0 (cláusula-árbitro, phantoms, 4 papéis) + R-ARCH-001 na constituição + decisão bus Redis
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
docs/_current_handoffs/FOR_PRIME_MATH_LIMIT.md
docs/banda/2026-06-10-dry-run.yaml
docs/governance/constitution-hashes/2026-06-10.sha256
docs/governance/constitution-hashes/2026-06-10.sha256.ots
docs/jobs/2026-06-10-doc-drift-verifier.json
docs/jobs/2026-06-10-pre-commit-pipeline.json
scripts/disseminate-scanner.ts

codex
The main functional change centralizes leaf repository discovery, but the new SSOT freezes machine-specific absolute paths and regresses the previous HOME-based behavior for any non-/home/enio environment. Other changes are mostly documentation or guarded hooks.

Review comment:

- [P2] Keep leaf repo paths home-relative — /home/enio/egos/agents/registry/leaf-repos.json:8-8
  When this registry is used outside `/home/enio` (for example another developer/CI checkout with leaf repos under its own `$HOME`), `disseminate-scanner.ts` now reads these literal paths and reports all real leaf repos as missing, whereas the previous hardcoded list was built with `HOME`. That prevents the dissemination manifest and `/disseminate` push loop from targeting the actual local ecosystem unless every machine uses the same absolute path; store paths as names/home-relative values or expand `$HOME` when loading them.
The main functional change centralizes leaf repository discovery, but the new SSOT freezes machine-specific absolute paths and regresses the previous HOME-based behavior for any non-/home/enio environment. Other changes are mostly documentation or guarded hooks.

Review comment:

- [P2] Keep leaf repo paths home-relative — /home/enio/egos/agents/registry/leaf-repos.json:8-8
  When this registry is used outside `/home/enio` (for example another developer/CI checkout with leaf repos under its own `$HOME`), `disseminate-scanner.ts` now reads these literal paths and reports all real leaf repos as missing, whereas the previous hardcoded list was built with `HOME`. That prevents the dissemination manifest and `/disseminate` push loop from targeting the actual local ecosystem unless every machine uses the same absolute path; store paths as names/home-relative values or expand `$HOME` when loading them.
```
