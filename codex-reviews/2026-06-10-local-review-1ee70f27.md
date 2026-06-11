# Codex Local Review — 2026-06-10T17:40:22Z

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
session id: 019eb29e-f7b0-7390-9351-3c7628eb0730
--------
user
changes against 'HEAD~3'
2026-06-10T17:40:24.126828Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T17:40:24.126829Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff d24755e36fb5d72e4b58bf1debdd5b142a147619 --stat && git diff d24755e36fb5d72e4b58bf1debdd5b142a147619' in /home/enio/egos
 succeeded in 0ms:
 .guarani/RULES_INDEX.md                            |    1 +
 .husky/pre-commit                                  |   18 +-
 AGENTS.md                                          |    2 +-
 CLAUDE.md                                          |    1 +
 TASKS.md                                           |   13 +-
 TASKS_ARCHIVE.md                                   |   13 +
 apps/egos-landing/public/mycelium-snapshot.json    |   36 +-
 apps/egos-landing/public/timeline/rss              |    2 +-
 apps/egos-landing/public/timeline/rss.xml          |    2 +-
 ...GUARANI_2026-06-10_banda-questioner-protocol.md |   15 +
 ...egos-odysseus-deve-ser-a-odysseus-como-fro.yaml |  140 ++
 ...-council-rewired-os-4-pap-is-respondem-pel.yaml |  145 ++
 docs/governance/GUARANI_EVALUATOR_PROTOCOL.md      |    2 +
 docs/governance/METAPROMPT_STANDARD.md             |   52 +
 docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md    |   68 +
 docs/guard-brasil/DATAVIRTUS_ANALYSIS.md           |  427 ++++--
 docs/guard-brasil/GUARD_BRASIL_ANALYSIS.html       | 1568 ++++++++++++++++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json       |   12 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json      |   32 +
 packages/guard-brasil/src/lib/pii-scanner.ts       |    5 +-
 scripts/banda.ts                                   |   91 +-
 21 files changed, 2462 insertions(+), 183 deletions(-)
diff --git a/.guarani/RULES_INDEX.md b/.guarani/RULES_INDEX.md
index 9687c34e..72c86bf1 100644
--- a/.guarani/RULES_INDEX.md
+++ b/.guarani/RULES_INDEX.md
@@ -37,6 +37,7 @@
 | **Literature API** | OA REST + MCP | `apps/egos-hq/api/hq/literature/` + `packages/mcp-literature/` |
 | **Coordination monitor** | COORDINATION_MONITOR_SPEC.md | `docs/governance/COORDINATION_MONITOR_SPEC.md` |
 | **Pre-commit hooks** | pre-commit | `.husky/pre-commit` |
+| **Metaprompt mínimo (Banda/Codex/Council)** | METAPROMPT-GATE-001 | `docs/governance/METAPROMPT_STANDARD.md` + gate em `scripts/banda.ts` |
 | **Presentations versioning** | GOV-PRES-001 | `CLAUDE.md §7 Presentations` + `scripts/check-doc-proliferation.sh` |
 | **File classification** | file-intelligence.sh | `scripts/file-intelligence.sh` |
 | **Doc proliferation** | check-doc-proliferation.sh | `scripts/check-doc-proliferation.sh` |
diff --git a/.husky/pre-commit b/.husky/pre-commit
index d94686b0..c73366ed 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -356,10 +356,17 @@ for frozen in \
 done
 
 if [ "$FROZEN_VIOLATED" -eq 1 ]; then
-  echo ""
-  echo "❌ BLOCKED: Frozen zone files modified."
-  echo "   To override: git commit --no-verify (requires proof-of-work in message)"
-  exit 1
+  # METAPROMPT-GATE-001 fix 2026-06-10: --no-verify está DENY no settings.json (2026-06-09),
+  # então §3 sem env-override = deadlock. Alinha com AGENTS.md §R3 + §3.5b: mesmo env.
+  if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then
+    echo "  🟡 FROZEN OVERRIDE: EGOS_FROZEN_OVERRIDE=1 (humano/Prime assume — logado)"
+  else
+    echo ""
+    echo "❌ BLOCKED: Frozen zone files modified."
+    echo "   Override legítimo (Enio/Prime, logado): EGOS_FROZEN_OVERRIDE=1 git commit ..."
+    echo "   (--no-verify é DENY no settings — não use)"
+    exit 1
+  fi
 fi
 
 # 3.5. Frozen-zone / governance commit AUTHORITY gate (hardened GUARANI-004 + HITL_CATALOG §5.1)
@@ -910,7 +917,8 @@ if [ "${EGOS_CODEX_REVIEW:-0}" = "1" ] && command -v codex >/dev/null 2>&1; then
     MODEL="gpt-5.5"
   fi
   echo "  [codex-review] running non-blocking review (model=$MODEL)..."
-  git diff --cached | codex exec --model "$MODEL" "Review this staged diff briefly. Flag any bugs, security issues, or anti-patterns. Be concise." > .git/CODEX_REVIEW.md 2>&1 || true
+  # Prompt segue METAPROMPT_STANDARD.md (MP-R1..R6) — METAPROMPT-GATE-001
+  git diff --cached | codex exec --model "$MODEL" "METAPROMPT (docs/governance/METAPROMPT_STANDARD.md): MP-R1 CONTEXTO=staged diff do kernel EGOS (Bun/TS, governanca rigida). MP-R2 OBJETIVO=achar bugs reais, falhas de seguranca e anti-patterns NESTE diff; aceite=cada finding com arquivo+linha. MP-R3 RESTRICOES=nao propor force-push/--no-verify; frozen zones intocaveis. MP-R4 EVIDENCIA=todo finding cita trecho do diff; sem 'parece'. MP-R5 SAIDA=lista numerada [SEVERIDADE] arquivo:linha — problema — fix sugerido; se nada: 'LGTM + 1 risco residual'. MP-R6 REGRAS=docs/governance/METAPROMPT_STANDARD.md. Se este prompt nao cumprir os requisitos, recuse apontando o arquivo de regras." > .git/CODEX_REVIEW.md 2>&1 || true
   REVIEW_LINES=$(wc -l < .git/CODEX_REVIEW.md 2>/dev/null || echo 0)
   echo "  [codex-review] review at .git/CODEX_REVIEW.md (${REVIEW_LINES} lines)"
 fi
diff --git a/AGENTS.md b/AGENTS.md
index 9aa5a5e3..04e98da9 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -16,7 +16,7 @@ Output primes: non-negotiables, recent phantoms (INC-001..006), SSOT hashes, las
 
 This section is the single source of truth for agent rules. Claude Code reads this. Windsurf reads this. Cursor reads this. Codex reads this. GitHub Copilot reads this. When `~/.claude/CLAUDE.md`, `.windsurfrules`, or repo-level `CLAUDE.md` diverge from this file, **AGENTS.md wins**. **Cláusula-árbitro (C1/C2 — Fable 2026-06-09):** Regras de agente (comportamento/código/SSOT): AGENTS.md vence. `.guarani` = índice de descoberta + enforcement de frozen-zones/pipeline; em conflito de REGRA, AGENTS.md vence; em conflito de PROCESSO/orquestração (`.guarani/orchestration/`), `.guarani` vence.
 
-> 🃏 **4 pilares (TL;DR — resume R0-R8; conflito→texto completo. Corte Enio 2026-06-03):** **1)** §R0 safe-push, sem segredo, sem publish-sem-HITL, sem `git add -A`, commit TASKS.md já · **2)** §R1/R7 memory-mcp p/ código, externo=REAL/CONCEPT/PHANTOM, subagente=síntese, capacidade=≥3 golden cases · **3)** §R3/R4/R8/RLS frozen via Prime/`EGOS_FROZEN_OVERRIDE`, Guarani propõe/Prime commita, DB schema-first+RLS anon · **4)** §R2/Karpathy mínimo código, falhe visível, SSOT>duplicação.
+> 🃏 **4 pilares (TL;DR — resume R0-R8; conflito→texto completo. Corte Enio 2026-06-03):** **1)** §R0 safe-push, sem segredo, sem publish-sem-HITL, sem `git add -A`, commit TASKS.md já · **2)** §R1/R7 memory-mcp p/ código, externo=REAL/CONCEPT/PHANTOM, subagente=síntese, capacidade=≥3 golden cases, avaliador (Banda/Codex/Council) exige metaprompt MP-R1..R6 senão recusa (`docs/governance/METAPROMPT_STANDARD.md`) · **3)** §R3/R4/R8/RLS frozen via Prime/`EGOS_FROZEN_OVERRIDE`, Guarani propõe/Prime commita, DB schema-first+RLS anon · **4)** §R2/Karpathy mínimo código, falhe visível, SSOT>duplicação.
 ### Highest-Leverage Rule
 EGOS maximizes value when it turns proven operational capability into governed reusable infrastructure.
 Default path: prove in a real leaf/runtime → extract what is reusable → register canonical ownership → enforce evidence and eval → reduce replication cost for the next repo/agent/client. When in doubt, prefer extraction over duplication, canon over parallel docs, deploy traceability over informal runtime assumptions.
diff --git a/CLAUDE.md b/CLAUDE.md
index d60e8f52..c0da3720 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -89,6 +89,7 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 - Edit Size: máx 80 linhas por operação de escrita
 - **100% AI-Driven / No-Code Master [T1 — 2026-06-10]:** O usuário Enio não escreve nem lê código cru. As IAs têm autonomia total para codificação, testes e correções de bugs. Comunicação com o usuário focada em layouts/fluxos funcionais e interfaces, nunca em snippets de código ou sintaxe de baixo nível na conversa.
 - **UI/Produto [T1 — Enio 2026-06-05]:** uma tela = UM trabalho dominante; o que competir vira camada secundária. Antes de publicar QUALQUER tela pública, rodar o **Publication Gate (R-UI-005)**. SSOT: `docs/governance/UI_PRODUCT_RULES.md` (One Job Per Screen + UI Intent Contract + No Competing Modes + Live System Page + Publication Gate + Premortem). Origem: engenharia reversa do incidente Mycelium-3-jobs.
+- **Metaprompt minimo [T1 — Enio 2026-06-10, METAPROMPT-GATE-001]:** todo comando a avaliador (Banda/Codex/Council) cumpre MP-R1..R6 de `docs/governance/METAPROMPT_STANDARD.md`; avaliador recusa incompleto apontando o arquivo. Gate: `scripts/banda.ts`.
 - **README: PT-BR obrigatório, score ≥ 4/5** — SSOT: `docs/governance/README_PADRAO_OURO.md`
   - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
   - Atualizar README na mesma sessão que muda funcionalidade
diff --git a/TASKS.md b/TASKS.md
index 85dfc540..dda7fb15 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -45,8 +45,14 @@
 **🧩 MCP CUSTOMIZADO = FEATURE PRINCIPAL DO EGOS (corte Enio 2026-06-10):**
 
 > **Regra R-ARCH-001** ("EGOS mostra o fluxo, não decide o vendor do cliente"): NÃO encodada na constituição ainda (verificado machine-wide 2026-06-10: 0 ocorrências em CLAUDE.md/AGENTS.md — phantom-done corrigido). Causa-raiz da não-prevalência + plano de 3 camadas: **`docs/governance/SEMANTIC_RULE_ENFORCEMENT_ARCH.md`**.
-- [ ] **MCP-EASY-INSTALL-001** [P0] `prime`+`forja` — **Feature principal: instalar o MCP EGOS com 1 linha** (modelo Supabase jun/2026): `claude mcp add --scope user --transport http egos "https://mcp.egos.ia.br/mcp?token=X"` → autentica via `claude /mcp` → tools em qualquer sessão (Claude Code, Cursor, Windsurf, ChatGPT Dev Mode). Endpoint já existe em `packages/mcp-*` na VPS. Falta: (1) URL única `mcp.egos.ia.br`, (2) auth Bearer por token/tenant, (3) README 3 linhas, (4) smoke `claude mcp add` → tool disponível, (5) **UX de conexão estilo Supabase** (corte Enio 2026-06-10): página "Connect your agent" com `Copy prompt` por cliente (Claude Code/Cursor/ChatGPT) + opção read-only + feature groups (subset de tools p/ caber no limite do cliente) + `npx skills add egos/agent-skills` (Agent Skills prontos). Compartilhar = mandar 1 link (ex: GitHub) → Claude Code instala/instrui sozinho. NÃO IMPLEMENTADA (falso-arquivada 2026-06-10 pelo subject-parser deprecated + auto-archive; restaurada).
+- [ ] **MCP-EASY-INSTALL-001** [P0] `prime`+`forja` — **Feature principal: instalar o MCP EGOS com 1 linha** (modelo Supabase jun/2026). **CÓDIGO PRONTO 2026-06-10 (66efaf34, smoke validado pelo Prime: healthz 200 · 401 fail-closed · initialize OK):** `packages/mcp-unified-gateway/` (auth Bearer token/tenant + feature groups core/knowledge/ops/full + read-only + 9 tools) + `ConnectPage.tsx` (wizard Copy-prompt por cliente) + README PT-BR + `setup-tokens.ts`. **FALTA (deploy, hermes-ops):** (1) DNS `mcp.egos.ia.br` → 204.168.217.125, (2) Caddy route → localhost:3100, (3) PM2 na VPS, (4) tokens na VPS via setup-tokens, (5) integrar ConnectPage no App.tsx do landing, (6) smoke final `claude mcp add` real. **4 decisões pendentes Enio:** session stateful vs stateless · porta 3100 · expor tool de mutação? · agregar os 10 MCPs existentes via subprocess vs tools standalone. **SINERGIA ODYSSEUS:** este gateway é a peça de conexão p/ Odysseus consumir o EGOS via MCP (ver ODYSSEUS-MCP-BRIDGE-001).
 - [ ] **MCP-PESSOAL-ENIO-001** [P1] `prime`+`forja` `gated:MCP-EASY-INSTALL-001` — Núcleo curado de tools (recon, readiness, guard_scan_pii, get_metaprompt, knowledge_search, memory_store/recall, egos_capture, doc_verify, pix_checkout) num MCP autenticado Bearer. Curadoria: `docs/strategy/MCP_PESSOAL_ENIO_CURADORIA.md`. NÃO IMPLEMENTADA (restaurada após falso-archive 2026-06-10).
+
+**🚀 ODYSSEUS — sinergia + esteira upstream (Enio 2026-06-10, gate §6b: INTEGRAR+TESTAR):**
+> Upstream `pewdiepie-archdaemon/odysseus`: 66.649★/8.274 forks em 10 dias, Python+JS, **AGPL-3.0** (alerta licença). Análise: `docs/governance/ODYSSEUS_EGOS_SYNERGY_ANALYSIS.md` · Metaprompt: `docs/metaprompts/MP-ODYSSEUS-MIGRATION.md`.
+- [ ] **ODYSSEUS-MCP-BRIDGE-001** [P1] `forja` `gated:ODYSSEUS-BANDA-PROPOSAL-001` — Conectar UI do Odysseus (suporta MCP) ao `mcp-unified-gateway` do EGOS. Prova: tool EGOS visível e executável na UI Odysseus local, screenshot + log.
+- [ ] **ODYSSEUS-PR-001** [P1] `prime` `gated:HITL-Enio` — 1º PR atômico ao upstream (TESTAR bounded): escolher gap pequeno e verificável (ler CONTRIBUTING.md + THREAT_MODEL.md deles ANTES). Golden case + evidência. **Red Zone: PR público em nome do EGOS = corte do Enio obrigatório antes de submeter.** Gatilho de descarte: ignorado 30d.
+- [x] **BANDA-COUNCIL-SUBSCRIPTION-001** [P0] `prime`+`forja` — **Council sem OpenRouter (corte Enio 2026-06-10):** VERIFICADO que `--mode council` manda os 4 papéis via OpenRouter API (pago/token). Rewire por subscription: critic→`codex exec` (✅ provado hoje) · supporter→`claude -p --model sonnet` · maestro→`claude -p --model opus` · **questioner→GUARANI via Antigravity (corte Enio: SEM login/CLI — canal `FOR_GUARANI_BANDA_<run-id>.md`, cron 5min, Gemini 3.1 Pro; protocolo gravado em GUARANI_EVALUATOR_PROTOCOL.md §4 + handoff FOR_GUARANI_2026-06-10_banda-questioner-protocol.md)**. Loop em teste: aguarda `FOR_PRIME_BANDA_TEST-001.md` do Guarani (critério de fechamento). Implementação banda.ts: 3 papéis CLI síncronos + questioner async (espera arquivo com timeout OU council parcial agora + merge da resposta Guarani quando chegar). OpenRouter vira fallback explícito (`--openrouter`), nunca default. `gemini` CLI (pede re-auth) = alternativa opcional, NÃO requisito. **FEITO 2026-06-10:** rewire provado live (council 85s, 4 papéis ok; trace docs/banda/2026-06-10-smoke-do-council-rewired-*.yaml). Custo medido council antigo $0.11 (print Enio) → novo: só Gemini paga (~$0.002-0.03). Guarani FORA da banda (corte Enio) — protocolo retratado. Hardening evidência-por-papel = follow-up P2.
 - [ ] **EGOS-CAPTURE-001** [P1] `forja` — Tool `egos_capture`: salva conversa do ChatGPT de volta no EGOS (fim do copy-paste). **Write via STAGING** (`docs/_inbox/` ou memory pendente — NUNCA commit direto, Red Zone write-back). Notificação ao Enio via **bot Telegram do EGOS, EXCLUSIVO pro ID do Enio — JAMAIS para grupos**.
 - [ ] **EGOS-CAPTURE-TG-APPROVE-001** [P2] `forja`+`hermes-ops` — Fase 2: botão inline no Telegram p/ Enio aceitar/validar a captura → promove do staging pro sistema (HITL por clique, de dentro do Telegram direto pro código).
 - [ ] **WEBFETCH-SSRF-RESEARCH-001** [P2] `guardiao` — Validar com `/pesquisa` (date-first) se allowlist + domínio-do-cliente-por-sessão + guards SSRF (bloqueia IP interno/localhost) + audit é a melhor opção p/ web_fetch sem castrar o sistema. Padrão proposto = OWASP SSRF Prevention; confirmar com fontes atuais antes de implementar no MCP pessoal. Corte Enio 2026-06-09.
@@ -74,7 +80,10 @@
 
 **🔬 AUDITORIA DE DISSEMINAÇÃO DA INTEGRIDADE (achados machine-wide 2026-06-09 — `/start` desta janela; classificação CONFIRMADO):**
 - [/] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — settings.json ATUALIZADO (2026-06-09): deny `Bash(*git commit --no-verify*)` + `Bash(*git commit -n *)` adicionados. Falta: PATH shim `~/bin/git` (defesa extra, não crítico — CI é a camada real). 70% feito.
-- [ ] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — CONFIRMADO: o guard phantom-done do pre-commit + `audit-phantom-done.ts` vivem SÓ no kernel — `grep` em `852/.husky` e `egos-lab/.husky` = 0. A "disseminação" da 2ª metade propagou docs de governança, NÃO o enforcement de integridade aos leaves. Propagar o bloco phantom-done (pre-commit) + script audit via `disseminate-propagator.ts` aos leaves que têm TASKS.md. Prova: re-grep nos leaves após.
+- [ ] **LEAF-HOOK-SMARTBUSCAS-001** [P1] `forja` — `smartbuscas/.husky/pre-commit` CORROMPIDO: conteúdo markdown em arquivo de hook shell (não executa NADA hoje — zero gates). Reescrever com leaf profile + bloco phantom-done.
+- [ ] **LEAF-SYNC-EGOS-SELF-001** [P1] `prime` — `egos-self` com **114 commits ahead sem push** (verificado 2026-06-10) — trabalho sem backup remoto, viola SYNC DISCIPLINE. Triagem + push (ou justificar local-only).
+- [ ] **LEAF-SYNC-SANTIAGO-001** [P2] `prime` — `santiago`: 72 commits ahead + `.guarani/PREFERENCES.md` typechanged (symlink↔arquivo). Janela dona resolve antes de receber propagação de integridade.
+- [ ] **VPS-VENDAS-PORTAL-ORIGIN-001** [P2] `hermes-ops` `gated:decisão-Enio` — vendas-portal parado (crash-loop 6.640 restarts: PM2 rodava script /start como app). Diretório na VPS é `.next/` sem package.json (build copiado à mão, não commitado). Decidir: descobrir repo de origem e reconstruir OU deletar.
 - [ ] **CLAUDE-MD-INDEX-INTEGRITY-001** [P1] `prime` — CONFIRMADO: `INTEGRITY_PROOF_SSOT.md` é [T1] mas o router constitucional NÃO o indexa — `grep` em `.claude/CLAUDE.md` e `egos/CLAUDE.md` = 0 (só `AGENTS.md` cita). SSOT [T1] invisível ao router = enforcement-gap de descoberta. Adicionar 1 linha de índice em ambos os CLAUDE.md (lazy-ref, sem inflar) — liga CLAUDE-MD-SIMPLIFICADO-001.
 
 **🔀 PRs GITHUB — TRIAGEM 2026-06-09:**
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 780c2132..87027f94 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3881,3 +3881,16 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **GUARD-HITL-001** [P1] `enio` — HITL inline rodado nesta sessão: corpus sintético executado, matches revisados, `hitlStats` atualizado em pcmg.ts. Closes 0ee0ae44
 - [x] **GUARD-HITL-002** [P1] `prime` — `pcmg-corpus.ts` (28 frases) + `hitl-runner.ts` criados e aprovados nesta sessão. Closes 0ee0ae44
 
+
+## Archived 2026-06-10
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — FEITO 2026-06-10 (forja Sonnet, verificado Prime): guard phantom-done propagado a **7 leaves** (852 e2a25df · egos-lab f7fbc5d · br-acc 9ae78bf · carteira-livre b6d8f098 · intelink 67d82f0 · forja 2f07651 · arch 0a679a1), todos pushed (ahead=0 verificado). Gate provado disparando (intelink, exit 1). 4 pulados c/ motivo → tasks LEAF-* abaixo.
+
+
+## Archived 2026-06-10
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **ODYSSEUS-BANDA-PROPOSAL-001** [P0] `prime` — Rodar Banda Cognitiva + review Codex sobre a fusão EGOS↔Odysseus → gerar `docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md` + `ODYSSEUS_PR_ROADMAP.md`. Metaprompts com requisitos mínimos (ver METAPROMPT-GATE-001). ✅ 2026-06-10
+- [x] **METAPROMPT-GATE-001** [P0] `prime` — **Requisitos mínimos de metaprompt p/ Banda e Codex (corte Enio 2026-06-10):** Banda/Codex só aceitam comando que cumpra requisitos mínimos (contexto+objetivo+restrições+evidência+formato de saída); se faltar, respondem apontando ONDE a IA aprende as regras (`docs/governance/METAPROMPT_STANDARD.md`). Encodar o padrão + gates executáveis em banda.ts/duo + disseminar referência nos arquivos constitucionais (CLAUDE.md, AGENTS.md, .guarani). ✅ 2026-06-10
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
diff --git a/docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml b/docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml
new file mode 100644
index 00000000..1e3c765c
--- /dev/null
+++ b/docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml
@@ -0,0 +1,140 @@
+# Banda Cognitiva — 2026-06-10
+id: 2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro
+mode: council
+question: |
+  A fusão EGOS↔Odysseus deve ser: (A) Odysseus como frontend universal consumindo EGOS via mcp-unified-gateway, (B) esteira de PRs upstream injetando governança EGOS no Odysseus, (C) ambos em sequência, ou (D) nenhum (ESTACIONAR)? Critério de aceite: verdict + 1º passo executável esta semana + análise do risco AGPL.
+context_provided: true
+duration_seconds: 82
+models:
+  critic: openai/gpt-5.4
+  supporter: anthropic/claude-sonnet-4.6
+  questioner: google/gemini-2.5-pro
+  maestro: anthropic/claude-opus-4.7
+
+---
+# Phase 1 — Crítico
+critico:
+  riscos:
+    - "AGPL contagiar fronteiras erradas: opção B ou C pode forçar governança/provenance do EGOS a virar obrigação de distribuição do lado Odysseus, porque o upstream é AGPL-3.0 com copyleft de rede. Se misturar código em vez de integrar por HTTP/MCP, você perde opcionalidade de licenciamento."
+    - "Acoplamento prematuro ao hype: Odysseus tem 66.649 stars em 10 dias e 1.136 issues abertas. Isso sinaliza tração, mas também superfície instável, churn de arquitetura e risco alto de quebrar integrações/PRs rapidamente."
+    - "Duplicação de capacidades já existentes: EGOS já tem kernel headless, governança T0-T4/R0-R8, provenance criptográfica e mcp-unified-gateway v0.1.0 validado hoje. Injetar governança no Odysseus pode reimplementar controle que o gateway já entrega por fronteira."
+    - "Risco de segurança/privacidade: Odysseus é workspace rico (chat/docs/email/calendar). Se usado como frontend universal sem hardening, pode ampliar exfiltração acidental de dado soberano, violando R-SEC-002. Bearer token/tenant ajuda, mas UI rica aumenta erro operacional."
+    - "Falsa confiança/alucinação de compliance: conectar UI bonita ao EGOS pode parecer 'governado' sem que toda ação preserve evidence-chain/agent-signature ponta a ponta. Smoke atual prova initialize/health/auth fail-closed, não prova trilha completa em fluxos complexos."
+    - "Dependência frágil bilateral: EGOS passa a depender da semântica MCP/UI do Odysseus; Odysseus passa a carregar expectativas de governança EGOS que o upstream talvez não aceite. WIP de Enio já está em 86 scopes; isso degrada manutenção."
+    - "Quebra de deploy/fluxo: mexer em upstream + fork + gateway ao mesmo tempo (C) explode superfície de regressão em PM2/VPS/local, autenticação por tenant e workflows existentes."
+  pior_cenario: "365 dias: EGOS fica semi-AGPL por contaminação prática, preso a um fork divergente de Odysseus; deploys quebram com mudanças upstream; dados sensíveis transitam pela UI além do necessário; Enio vira mantenedor de cola entre dois sistemas instáveis e abandona o core headless."
+  duplicacoes_detectadas:
+    - "Governança/provenance do EGOS duplicada dentro do Odysseus em vez de consumida via gateway."
+    - "UI de conexão/wizard já iniciada em ConnectPage.tsx; fazer mais camada custom cedo demais."
+  dependencias_frageis:
+    - "Upstream Odysseus de altíssima volatilidade"
+    - "Fork enioxt/odysseus sem capacidade comprovada de manutenção contínua"
+    - "Contrato MCP/gateway ainda só com smoke básico"
+    - "Disponibilidade Redis/PM2/VPS como base do frontend universal"
+  recomendacao: MITIGAR
+  ressalvas:
+    - "Verdict: GO-COM-CONDIÇÕES para A somente. B agora = NO-GO. C agora = NO-GO. D só se faltar tempo esta semana."
+    - "1º passo executável esta semana: rodar um piloto read-only do Odysseus consumindo apenas /mcp do mcp-unified-gateway com tenant dedicado, sem copiar código EGOS para o repo AGPL; registrar evidence de 3 fluxos reais e falhas."
+    - "Análise AGPL: manter fronteira por processo/rede (HTTP/MCP) reduz risco; subir PRs upstream apenas com código originalmente do Odysseus ou abstrações novas não derivadas do EGOS. Não portar governança EGOS upstream antes de parecer jurídico/estratégico."
+
+---
+# Phase 2 — Apoiador
+apoiador:
+  potencial_maximo: >
+    Odysseus com 66.649 stars em 10 dias é um vetor de distribuição raro —
+    um frontend já adotado em massa que pode tornar o EGOS acessível a
+    milhares de devs sem que o EGOS precise construir UI própria. O
+    mcp-unified-gateway v0.1.0 (SHA 66efaf34) já entrega a fronteira
+    técnica e legal perfeita: EGOS permanece headless/soberano, Odysseus
+    consome via HTTP/MCP sem tocar código interno. Isso é produto +
+    distribuição + prova de conceito de governança em produção — tudo ao
+    mesmo tempo, com WIP mínimo.
+
+  falhas_do_critico_respondidas:
+    - falha: "AGPL contagiar fronteiras erradas"
+      resposta: >
+        A fronteira HTTP/MCP já existe e foi validada hoje (healthz 200,
+        401 fail-closed, initialize OK). Nenhum código EGOS entra no repo
+        Odysseus — apenas chamadas REST. Isso transforma o risco AGPL em
+        feature de arquitetura: o gateway é o firewall legal. Documentar
+        explicitamente no README do gateway que a integração é
+        client-server (não linking) consolida a posição.
+
+    - falha: "Acoplamento prematuro ao hype / upstream instável"
+      resposta: >
+        O fork enioxt/odysseus isola o EGOS das quebras upstream. O piloto
+        read-only desta semana usa apenas /mcp — se o Odysseus mudar a UI,
+        o gateway não quebra. A volatilidade do upstream vira sinal de
+        mercado: cada issue aberta é um caso de uso que o EGOS pode
+        resolver com governança que o Odysseus ainda não tem.
+
+    - falha: "Duplicação de capacidades / governança reimplementada"
+      resposta: >
+        Exatamente por isso B é NO-GO agora. A opção A preserva a
+        singularidade: governança vive no EGOS, Odysseus só consome.
+        ConnectPage.tsx já iniciada é prova de que o caminho certo é
+        wizard → gateway, não copiar lógica.
+
+    - falha: "Falsa confiança / evidence-chain incompleta"
+      resposta: >
+        O piloto desta semana deve registrar evidence de 3 fluxos reais
+        via provenance.ts/evidence-chain.ts. Isso não é overhead — é o
+        critério de aceite que transforma smoke em compliance verificável.
+        A falha do crítico vira gate obrigatório antes de qualquer PR
+        público.
+
+    - falha: "R-SEC-002 / dado soberano"
+      resposta: >
+        Read-only mode + tenant dedicado + Bearer token já implementados
+        no gateway. O piloto opera sem escrita, sem dado sensível em
+        trânsito. Isso é hardening progressivo, não exposição.
+
+  reuso_egos:
+    - "mcp-unified-gateway v0.1.0: endpoint /mcp, auth Bearer/tenant, read-only mode — tudo pronto"
+    - "ConnectPage.tsx wizard: UI de conexão já iniciada, evita retrabalho"
+    - "provenance.ts + evidence-chain.ts: trilha criptográfica para validar fluxos do piloto"
+    - "Mycelium Redis bus: backbone já provado cross-process, suporta eventos do Odysseus sem nova infra"
+    - "11 MCPs PM2 VPS: capacidades reais expostas imediatamente ao Odysseus sem código novo"
+
+  efeito_rede: >
+    Cada dev que adota Odysseus e conecta ao EGOS via gateway valida a
+    governança T0-T4 em contexto real. Se 0,1% dos 66k stars testarem o
+    piloto, o EGOS ganha feedback de produção em escala que nenhum
+    roadmap interno geraria. PRs upstream futuros (pós-parecer jurídico)
+    chegam com evidência de uso real — não como proposta teórica.
+
+  recomendacao: EXECUTAR
+  # Verdict: GO-COM-CONDIÇÕES para A. B e C: NO-GO esta semana.
+  # 1º passo executável: piloto read-only Odysseus → /mcp gateway,
+  # tenant isolado, registrar evidence de 3 fluxos, sem copiar código
+  # EGOS para repo AGPL. Prazo: até sexta-feira desta semana.
+
+---
+# Phase 3 — Questionador
+```yaml
+questionador:
+  premissas_implicitas:
+    - "A popularidade do Odysseus (66k stars) é um indicador de alinhamento estratégico, e não apenas um hype que pode desviar o foco dos 86 scopes já em aberto."
+    - "A fronteira de rede (HTTP/MCP) será suficiente para isolar legal
+
+---
+# Phase 4 — Maestro (FINAL SYNTHESIS)
+decisao:
+  contexto: "Definir modelo de fusão EGOS↔Odysseus (A/B/C/D) com 1º passo desta semana e tratamento do risco AGPL-3.0."
+  critica_principal: "Misturar código EGOS no repo Odysseus AGPL contamina licença e duplica governança já entregue pelo mcp-unified-gateway."
+  potencial_principal: "Odysseus (66k stars/10d) é vetor de distribuição raro — consumir via /mcp transforma EGOS em backend governado de UI já adotada, sem construir frontend próprio."
+  duvida_principal: "Fronteira HTTP/MCP basta como firewall legal AGPL, ou precisa de parecer jurídico antes mesmo do piloto read-only?"
+  acao_escolhida: "GO-COM-CONDIÇÕES para opção A apenas: piloto read-only Odysseus (fork enioxt/odysseus, local) → mcp-unified-gateway /mcp, tenant dedicado, Bearer token, sem copiar 1 linha de código EGOS para repo AGPL. Registrar evidence-chain de 3 fluxos reais. Estimativa: 6-10h até sexta."
+  acao_rejeitada: "B (PRs upstream injetando governança EGOS) e C (ambos em sequência): NO-GO esta semana — expõem EGOS a contaminação AGPL, dependem de parecer jurídico ausente, e quebram WIP≤2 com Enio já em 86 scopes. D (estacionar) também rejeitado: gateway pronto hoje, custo de oportunidade alto."
+  ressalvas_aplicadas:
+    - "Fronteira estritamente client-server (HTTP/MCP), nunca linking de código"
+    - "Read-only mode obrigatório no piloto (sem escrita, sem dado sensível)"
+    - "Tenant isolado + Bearer token + log de toda chamada via provenance.ts"
+    - "Fork enioxt/odysseus permanece intocado (sem PRs upstream) até parecer jurídico AGPL"
+    - "Evidence-chain de 3 fluxos reais é critério de aceite — não 'smoke ok'"
+    - "Documentar no README do gateway que integração é client-server (não derivative work)"
+  proximo_passo: "Criar branch feat/odysseus-pilot-readonly no EGOS: (1) subir gateway local em modo read-only com tenant 'odysseus-pilot'; (2) configurar Odysseus fork local apontando para /mcp; (3) executar 3 fluxos (list MCPs, query knowledge, health check) e gravar evidence-chain; (4) abrir RFC curta em docs/governance/ com resultado + perguntas jurídicas AGPL pendentes."
+  prioridade: 3
+  gate_decisao: "Enio (HITL T0#3 — qualquer toque em superfície pública/fork de terceiros)"
+
+# Sacred Code: 000.111.369.963.1618
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
diff --git a/docs/governance/METAPROMPT_STANDARD.md b/docs/governance/METAPROMPT_STANDARD.md
new file mode 100644
index 00000000..4e2b78c2
--- /dev/null
+++ b/docs/governance/METAPROMPT_STANDARD.md
@@ -0,0 +1,52 @@
+# METAPROMPT_STANDARD — Requisitos Mínimos para Comandar Avaliadores
+
+> **SSOT [T1]** — corte Enio 2026-06-10. Audiência: AI⟷AI.
+> **Escopo:** TODO comando enviado a um avaliador (Banda Cognitiva, Codex review, Council multi-LLM, critico, guarani-audit) DEVE cumprir os 6 requisitos abaixo. Avaliador que recebe comando incompleto **NÃO executa** — responde apontando este arquivo.
+> **Enforcement:** `scripts/banda.ts` (gate executável, exit 2) · `.husky/pre-commit` §codex (prompt padrão já embute pointer) · disseminado: `CLAUDE.md` (repo) · `AGENTS.md §R3` · `.guarani/RULES_INDEX.md`.
+
+---
+
+## §1. Os 6 Requisitos Mínimos (MP-R1..R6)
+
+| # | Requisito | O que exige | Falha típica |
+|---|---|---|---|
+| MP-R1 | **CONTEXTO** | O que existe HOJE: paths reais, SHAs, estado verificado (REAL/CONCEPT/PHANTOM). Mínimo: 1 path ou SHA citável. | "avalie o sistema" sem dizer qual |
+| MP-R2 | **OBJETIVO VERIFICÁVEL** | Pergunta/missão com critério de aceite mensurável. Como o avaliador sabe que respondeu? | "o que acha?" aberto |
+| MP-R3 | **RESTRIÇÕES** | Red Zones aplicáveis, frozen zones, regras T0/T1 relevantes, o que NÃO fazer. | avaliador propõe force-push |
+| MP-R4 | **EVIDÊNCIA EXIGIDA** | Que prova o avaliador deve citar/exigir nas afirmações dele (file:line, output, teste). Claim sem prova = inválida. | review "parece bom" |
+| MP-R5 | **FORMATO DE SAÍDA** | Estrutura da resposta (seções, verdict, tabela). Output não-parseável = retrabalho. | prosa livre de 3 páginas |
+| MP-R6 | **POINTER DE REGRAS** | Link para este arquivo + regras citadas, para o avaliador (e quem ler depois) saber onde as regras vivem. | conhecimento implícito perdido |
+
+## §2. Protocolo de Recusa (fail-closed)
+
+Avaliador que recebe comando sem MP-R1..R6:
+
+```
+⛔ METAPROMPT INCOMPLETO — não executado.
+Faltam: [MP-R1 contexto | MP-R2 objetivo | ...]
+Regras: docs/governance/METAPROMPT_STANDARD.md (EGOS kernel)
+Reenvie cumprindo os 6 requisitos.
+```
+
+Override consciente (humano): `EGOS_MP_GATE_OVERRIDE=1` (logado, nunca default).
+
+## §3. Template Canônico (copiar e preencher)
+
+```markdown
+## METAPROMPT — [título]
+**MP-R1 CONTEXTO:** [o que existe: paths, SHAs, estado classificado]
+**MP-R2 OBJETIVO:** [pergunta + critério de aceite verificável]
+**MP-R3 RESTRIÇÕES:** [Red Zones, frozen, regras T0/T1 aplicáveis]
+**MP-R4 EVIDÊNCIA:** [que prova exigir em cada claim do avaliador]
+**MP-R5 SAÍDA:** [estrutura exata da resposta]
+**MP-R6 REGRAS:** docs/governance/METAPROMPT_STANDARD.md + [regras citadas]
+```
+
+## §4. Relação com o que já existe
+
+- `docs/metaprompts/MP-*.md` — metaprompts por capacidade (servidos via `mcp-governance get_meta_prompt`). Novos MP-* DEVEM seguir §3.
+- `scripts/banda.ts` — gate executável: recusa `--question` sem contexto/objetivo (ver `--metaprompt-file`).
+- `.husky/pre-commit` codex review — prompt embute MP-R3..R6 fixos do kernel.
+- Quorum Protocol (`docs/governance/QUORUM_PROTOCOL.md`) — decisões críticas 3+ LLMs: cada LLM recebe metaprompt §3.
+
+*v1.0 — 2026-06-10. Origem: missão Odysseus (Enio: "só aceitar comandos com requisitos mínimos; senão apontar onde as regras vivem").*
diff --git a/docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md b/docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md
new file mode 100644
index 00000000..80f22740
--- /dev/null
+++ b/docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md
@@ -0,0 +1,68 @@
+# ODYSSEUS ↔ EGOS — Proposta de Fusão (Banda Council + emendas Codex)
+
+> **Status:** PROPOSTA — aguarda corte Enio (gate HITL T0#3)
+> **Pipeline de decisão:** Banda Council 2026-06-10 (GPT-5.4 · Sonnet 4.6 · Gemini 2.5 Pro · Opus 4.7) → review adversarial Codex gpt-5.5 (**SUSTENTA-COM-EMENDAS**, 10 objeções aplicadas) → esta v1.1. Trace: `docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-fro.yaml`
+> **Metaprompts:** ambos conforme `docs/governance/METAPROMPT_STANDARD.md` (MP-R1..R6)
+> **Análise de origem:** `docs/governance/ODYSSEUS_EGOS_SYNERGY_ANALYSIS.md` (Guarani, verificada Prime)
+
+---
+
+## §1. Veredito
+
+**GO-COM-CONDIÇÕES para a opção A apenas:** Odysseus como frontend consumindo o EGOS via `packages/mcp-unified-gateway` (fronteira client-server HTTP/MCP). **Risco AGPL reduzido, não eliminado — nenhuma conclusão jurídica antes de parecer** (emenda Codex #1).
+
+| Opção | Veredito | Motivo |
+|---|---|---|
+| **A** — Odysseus consome EGOS via MCP | ✅ GO-COM-CONDIÇÕES | Gateway pronto (66efaf34); 66k stars = **sinal de distribuição, não prova de alinhamento** (emenda #8) |
+| **B** — PRs upstream injetando governança | ⛔ NO-GO por ora | Risco AGPL sem parecer; WIP≤2 (dispersão 🔴) |
+| **C** — A+B em sequência | ⛔ NO-GO por ora | Herda bloqueios de B |
+| **D** — Estacionar | ⛔ Rejeitado, **condicionado**: GO só se couber no WIP, timebox 10h duro (emenda #7) |
+
+## §2. Condições obrigatórias (council + Codex)
+
+1. **Fronteira client-server** (HTTP/MCP) — nunca linking/cópia de código entre repos.
+2. **"Fork intocado" DEFINIDO** (emenda #3): permitido = env vars, config runtime, arquivo local NÃO versionado; proibido = commit, patch, PR, issue, bundle, alteração persistente no fork.
+3. **Read-only + anti-exfiltração** (emenda #4): corpus do piloto = sintético OU allowlist de fontes públicas, com hash/manifest registrado. Read-only impede escrita, não vazamento por leitura.
+4. **Feature group mínimo** (emenda #5): só `health` + `tools:list:safe` + `knowledge:query:sandbox`. Deny explícito: escrita, shell, filesystem, secrets, email/calendar, MCP externo não-allowlisted. Tool discovery também vaza (nomes de tools = informação).
+5. **Critério de aceite = 3 fluxos positivos + 3 NEGATIVOS** (emenda #6): token inválido→401 · tentativa de escrita→deny auditado · query fora do corpus→recusa sem vazamento.
+6. **Timebox 10h + kill criteria** (emenda #7): parar se exigir patch no Odysseus, tocar dado real, ou mexer no gateway além de config/read-only.
+7. README do gateway documenta **só fatos técnicos** (processos separados, protocolo, ausência de cópia) — conclusão jurídica fica no parecer (emenda #2).
+
+## §3. Piloto (branch `feat/odysseus-pilot-readonly`, ≤10h)
+
+1. Gateway local read-only, tenant `odysseus-pilot`, feature group mínimo da condição 4.
+2. Odysseus fork local apontando para `/mcp` (só config runtime — condição 2).
+3. Executar 3+3 fluxos da condição 5 — gravar evidence-chain.
+4. RFC com **anexos verificáveis** (emenda #10): comandos executados, hashes de logs, tenant, tools expostas, resultado dos 6 fluxos.
+
+## §4. Risco AGPL-3.0 — 3 casos separados (emenda #9)
+
+| Caso | Risco | Gate |
+|---|---|---|
+| Uso sem modificação (cliente) | baixo | piloto OK |
+| Modificação local não distribuída | médio | proibido no piloto; reavaliar pós-parecer |
+| Modificação servida/distribuída | alto (AGPL §13) | proibido até parecer formal |
+
+Enio (bacharel direito) revisa pessoalmente + opcional parecer externo ANTES de: PR upstream, bundle, ou qualquer distribuição.
+
+## §5. Riscos adicionais (Codex — a Banda não viu)
+
+1. **Prompt injection via frontend:** conteúdo externo no Odysseus pode induzir chamadas MCP indevidas mesmo read-only.
+2. **Tool enumeration leakage:** `list tools` revela capacidades internas.
+3. **"Dado sensível" definido:** inclui logs, prompts, nomes de tenant, paths internos, capability registry — não só PCMG.
+4. **Risco reputacional:** screenshot/branch público pode sinalizar "parceria" antes de HITL — nada público sem corte.
+5. **Supply chain:** fork popular/volátil pode trazer deps/telemetria/build scripts não auditados — rodar isolado, auditar deps antes.
+6. **Pressão de hype:** 66k stars não justifica expandir antes do parecer + provas negativas. Critério de parada explícito (condição 6).
+
+## §6. Esteira de PRs upstream (DEFERIDA)
+
+Visão Guarani registrada e deferida. Reavaliar quando: parecer AGPL ok + piloto provado + WIP liberar + **análise de manutenção upstream** (releases, breaking changes, política de contribuição — emenda #8). Por PR: CONTRIBUTING+THREAT_MODEL lidos, golden case, atômico, **corte Enio**. Task: `ODYSSEUS-PR-001` (gated:HITL-Enio).
+
+## §7. O que NÃO fazer
+
+- NÃO copiar código entre repos (qualquer direção) até parecer AGPL.
+- NÃO submeter PR/issue/comentário público em nome do EGOS sem corte do Enio.
+- NÃO conectar dado soberano/PCMG (R-SEC-002) — nem logs/prompts/paths internos (§5.3).
+- NÃO abrir frente além do piloto (WIP≤2; timebox 10h; kill criteria ativos).
+
+*v1.1 — 2026-06-10 (v1.0 council + emendas Codex aplicadas). Próxima revisão: pós-piloto ou pós-parecer.*
diff --git a/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md b/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
index 10e8aa6b..d4b42a91 100644
--- a/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
+++ b/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
@@ -1,218 +1,335 @@
-# Análise: Datavirtus — Plataforma, Ferramenta e Contexto Competitivo
+# Guard Brasil — Análise Competitiva (Datavirtus) + Casos de Uso Completos
 
-> **Fontes:** `anonimizador_v2_gui.py` (1029 LOC) + `desanonimizador_gui.py` (501 LOC) + `LEIA-ME.txt` + screenshot plataforma `DATAVIRTUS.pdf` (capturado 2026-06-02)
-> **Audiência:** AI↔AI | **Data:** 2026-06-10
+> **Audiência:** AI↔AI (denso, machine-parseable) | **Data:** 2026-06-10
+> **Fontes verificadas:**
+> - Guard Brasil: `packages/guard-brasil/` v0.2.3 (46 testes passando, 106 expects) — 3 investigações Explore cruzadas
+> - Datavirtus: `anonimizador_v2_gui.py` (1029 LOC) + `desanonimizador_gui.py` (501 LOC) + `LEIA-ME.txt` + screenshot plataforma `DATAVIRTUS.pdf` (2026-06-02)
+> - Regulatório: `docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md` + `EXTENSIBILITY.md`
+> - Classificação honesta: REAL (código + teste) | CONCEPT (implementado, não integrado) | PHANTOM (alegado, inexistente) | PROPOSTO (só doc)
 
 ---
 
-## Contexto: o que é a DataVirtus
+## PARTE 1 — O QUE É O GUARD BRASIL
 
-DataVirtus é uma **plataforma de formação para Agentes da Lei** (datavirtus.themembers.com.br).
-Não é apenas uma ferramenta — é um ecossistema de cursos voltado especificamente para investigadores, policiais e servidores públicos.
+`@egosbr/guard-brasil` v0.2.3 — **camada de segurança de IA para o Brasil**. Não é um anonimizador isolado: é um pipeline de governança com 4 camadas, consumível como biblioteca, API HTTP e servidor MCP.
 
-### Cursos identificados na plataforma (screenshot 2026-06-02)
+**Auto-descrição (README:3):** *"Brazilian AI Safety Layer — LGPD-compliant PII masking, ATRiAN ethical validation, and traceable evidence discipline for AI assistants operating in Brazil."*
 
-| Curso | Descrição | Relevância |
-|---|---|---|
-| Pós-Graduação em Investigação Financeira (PGIF 2026) | Formação em análise de RIF, COAF, fluxos financeiros | DIRETA — onde o anonimizador é ensinado |
-| NexVirtus PRO — Investigação Financeira | Live fechada para Agentes da Lei | DIRETA |
-| IA local com Gemma 4 | Como usar IA local de forma segura e eficiente | DIRETA — paralelo ao nosso curso |
-| **Pós em IA para Agentes da Lei** | "A 1ª Pós em IA para Agentes da Lei do país!" | ALTA — concorrente direto |
-| ChatGPT para Policiais e Agentes da Lei | Curso completo, uso para investigações, exclusivo servidores | ALTA |
-| Análise de Dados com Power BI | Power BI aplicado | INDIRETA |
+### As 4 camadas (todas REAL, com teste)
 
-**Implicação:** o anonimizador tool não é um produto standalone — é **material didático entregue dentro dos cursos de investigação financeira e IA**. O fluxo ensinado: "anonimize antes de mandar pro LLM → trabalhe → deanonimize o resultado."
+| Camada | Função | Arquivo | O que faz |
+|---|---|---|---|
+| **PII Scanner BR** | `scanForPII()` / `maskPII()` / `detectPII()` | `lib/pii-scanner.ts` + `pii-patterns.ts` | Detecta e mascara 16 categorias de dado pessoal BR + 7 segredos de infra |
+| **ATRiAN** | `createAtrianValidator()` | `lib/atrian.ts` | Validação ética/epistêmica: score 0-100, flag de claims absolutos, dados fabricados, promessas falsas, entidades bloqueadas |
+| **Public Guard** | `maskPublicOutput()` / `isPublicSafe()` | `lib/public-guard.ts` | Classificação de sensibilidade LGPD + redação + disclosure automático |
+| **Evidence Chain** | `createEvidenceChain()` | `lib/evidence-chain.ts` | Rastreabilidade de claims + audit hash SHA-256 (`ev-<64hex>`) |
 
-### Posicionamento competitivo (CONFIRMADO via plataforma)
+**Facade única:** `GuardBrasil.create().inspect(texto)` orquestra as 4 camadas e retorna um `InspectionReceipt` com hashes de input/output/inspeção + nível de proveniência.
 
-DataVirtus e EGOS/Guard Brasil **servem o mesmo público** (servidores públicos, policiais, investigadores) **com propostas diferentes:**
+### Estado de qualidade (CONFIRMADO)
 
-| Dimensão | DataVirtus | EGOS / Guard Brasil |
-|---|---|---|
-| Modelo | Plataforma de cursos (B2C, assinatura) | Framework open-source + governança + MCP |
-| Foco IA | Ensina a usar ChatGPT/LLMs externos | Governança + IA local + HITL auditável |
-| Privacidade | Anonimizador = gambito para usar LLMs externos | Guard Brasil = nunca sai da máquina por design |
-| LGPD | Usuário responsável por anonimizar antes | Enforcement automático no pipeline |
-| Especificidade | COAF, RIF, investigação financeira | PCMG, REDS, MASP, BO, IPL — domínio policial MG |
-| Profundidade | Superficial (regex + heurística simples) | HITL + corpus + perfis institucionais plugáveis |
+```
+bun test → 46 pass / 0 fail / 106 expect() / 39ms
+```
+
+| Métrica | Valor |
+|---|---|
+| Versão npm | 0.2.3 (`GUARD_VERSION` interno = 0.2.2 — drift de 1 patch, sem impacto funcional) |
+| Padrões PII core | 16 |
+| Segredos de infra | 7 (AWS, GitHub, Stripe, DB conn, API key, Bearer, PEM) |
+| Perfis institucionais validados | 1 (PCMG — 4 padrões, 12 confirmações HITL, 0 rejeições) |
+| Dependência runtime | apenas `@supabase/supabase-js` (lazy, só telemetria/keys) |
 
 ---
 
-## O que o Datavirtus tem
+## PARTE 2 — TODOS OS CASOS DE USO (investigação ampla — 22 ATIVOS + 8 PROPOSTOS)
+
+Guard Brasil é consumido em **3 superfícies** e **14 arquivos distintos** no monorepo. Classificação: ATIVO (em uso real) | POTENCIAL (wired parcial) | PROPOSTO (só doc).
 
-### Capacidades confirmadas (código verificado)
+> **Distinção importante (para quem avalia adoção):** alguns casos ATIVO são **standalone** (bastam o pacote `@egosbr/guard-brasil` instalado — ex: `maskPII`, `scanForPII`, `detectPII`, MCP tools). Outros vivem **dentro do ecossistema EGOS** (requerem gateway, scripts de publicação, ou infra adicional — ex: publish gate, x402, secureLog). O integrador externo recebe os primeiros imediatamente; os segundos são prova de uso real, não features empacotadas.
 
-| Capacidade | Implementação | Notas |
+### 2.1 — Mascaramento PII antes de LLM externo (R-SEC-002 T0 — "dado soberano nunca sai da máquina")
+
+| Caso | Onde | Status |
 |---|---|---|
-| Anonimização reversível | `MapeamentoAnonimizacao` → JSON `[CPF_0001]` etc. | Cada dado recebe placeholder sequencial único |
-| Desanonimização | `desanonimizador_gui.py` lê o JSON e restaura | Caminho inverso completo |
-| CPF | `RE_CPF = re.compile(r'\b(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{2})\b')` | Com e sem formatação |
-| CNPJ | 2 variantes (`RE_CNPJ`, `RE_CNPJ2`) | Cobre 14 dígitos com/sem pontuação |
-| E-mail | Regex padrão | |
-| Nomes PF/PJ | Regras contextuais A-J + heurística `_parece_nome_proprio` | Complexo: listas PRESERVE, CARGOS, NOMES_BANCOS |
-| Suporte a .docx | `python-docx` — concatena runs antes de anonimizar | Preserva formatação |
-| Suporte a .pdf | `pymupdf` — redaction por linha | Cabeçalhos/rodapés ignorados |
-| GUI | `tkinter` — Windows-first, com .bat | Não requer ambiente de dev |
-| 100% offline | Sem API externa, sem rede | Dado nunca sai da máquina |
-
-### Fluxo operacional Datavirtus
-```
-[docx/pdf/texto] 
-      → Anonimizar (regex+heurística) → [doc anonimizado] + [mapeamento.json]
-      → Processar em LLM/plataforma externa
-      → Desanonimizar (mapeamento.json) → [doc com dados reais restaurados]
-```
+| Gateway WhatsApp/Telegram mascara mensagem antes do Claude | `apps/egos-gateway/src/orchestrator.ts:1604` (`maskPII`) | ATIVO |
+| Produto 852 — "Early Deep Atrian Layer" no chat | `852/src/app/api/chat/route.ts:74` (`scanForPII` + `sanitizeText`) | ATIVO |
+| Wrapper de versão 852 | `852/src/lib/pii-scanner.ts` (re-export) | ATIVO |
 
-### Heurística de nomes (Regras A-J — detalhes)
-- **Regra A:** NOME - CPF/CNPJ: DOC - Sufixo cargo (contexto estruturado)
-- **Regra B:** NOME - CNPJ/CPF: DOC (sem sufixo)
-- **Regra C:** NOME CPF/CNPJ sem separador
-- **Regra D:** NOME - [DOC mascarado]
-- **Regra E:** Sequências 2+ palavras maiúsculas no corpo do texto
-- **Regras F-J:** padrões contextuais (parênteses após DOC, "nome de NOME", [DOC]-NOME-Beneficiário etc.)
-- **PRESERVE:** ~100 termos que nunca são anonimizados (ex: BANCO, PIX, COAF, BRADESCO)
-- **NOMES_BANCOS_INSTITUICOES:** multi-palavra (ex: "BANCO DO BRASIL", "POLÍCIA CIVIL")
+### 2.2 — Publish gate (R-SEC-005 — toda superfície pública roda scan PII antes de publicar)
 
----
+| Caso | Onde | Status |
+|---|---|---|
+| Timeline / artigos de sessão | `scripts/session-end-article.ts:195` | ATIVO |
+| NotebookLM `source_add` | `scripts/notebook-sync-local.ts:332` | ATIVO |
+| Insert de draft avulso | `scripts/insert-draft.ts:117` | ATIVO |
+
+> Cada gate roda `detectPII(body, ALL_PII_PATTERNS)` **+** `detectPII(body, INFRASTRUCTURE_SECRET_PATTERNS)` e **bloqueia** (throw) se houver match.
 
-## O que Guard Brasil tem que Datavirtus não tem
+### 2.3 — Pre-commit / scan estático (R-SEC-001 — vazamento não chega ao git)
 
-| Capacidade | Guard Brasil | Datavirtus |
+| Caso | Onde | Status |
 |---|---|---|
-| Padrões institucionais BR | ✅ REDS, MASP, BO, IPL, TC | ❌ Apenas CPF/CNPJ/email/nome |
-| HITL (ciclo confiança low→high) | ✅ Arquitetura completa | ❌ Sem HITL |
-| Perfis de instituição plugáveis | ✅ `InstitutionProfile` + JSON | ❌ Configuração estática |
-| API/pipeline-first | ✅ TypeScript, importável | ❌ GUI-only |
-| Corpus sintético documentado | ✅ pcmg-corpus.ts (28 entradas) | ❌ Sem corpus |
-| Desanonimização | ❌ Não implementado | ✅ Completo com JSON |
-| Detecção de nomes | ❌ Não implementado | ✅ Regras A-J |
-| Suporte docx/PDF | ❌ Texto puro apenas | ✅ python-docx + pymupdf |
+| Hook PII no pre-commit (CPF/CNPJ) | `.husky/_checks/06-pii-scan.sh` (3 profiles) | ATIVO |
+| Scanner hardcoded sensitive (CI + pre-commit) | `scripts/security/scan-hardcoded-sensitive.ts:237` | ATIVO |
+| Intelink — audit de rotas Neo4j que tocam PII | `intelink/scripts/pii-mask-path-check.ts` | ATIVO |
 
----
+### 2.4 — Contexto policial PCMG (BO, IPL, REDS, TC)
 
-## O que Guard Brasil pode aprender (tasks priorizadas)
+| Caso | Onde | Status |
+|---|---|---|
+| Perfil PCMG com 4 padrões, HITL validado | `packages/guard-brasil/src/registry/pcmg.ts` | ATIVO (12 confirmações / 0 rejeições, 2026-06-10) |
+| Corpus sintético (28 frases, 4 padrões) | `registry/pcmg-corpus.ts` | ATIVO |
+| HITL runner interativo (confirma/rejeita matches) | `registry/hitl-runner.ts` | ATIVO (CLI) |
 
-### P1 — Maior gap funcional
+**Padrões PCMG:** `pcmg:bo_numero` (BO AAAA/NNNNNN), `pcmg:inquerito` (IPL NNNN/AAAA), `pcmg:reds_complemento` (REDS-YYYY-NNN/DDD), `pcmg:termo_circunstanciado` (TC-NNNN/AAAA, confidence medium).
 
-#### 1. Anonimização reversível (desanonimização)
-O Datavirtus mostra o padrão correto: placeholder sequencial `[TIPO_NNNN]` + arquivo de mapeamento JSON.
-Guard Brasil hoje só mascara (irreversível). Para casos onde o investigador precisa restaurar dados
-no documento final após processar com LLM, a desanonimização é indispensável.
+### 2.5 — Servidor MCP (agent-native: Claude Code, Cursor, Windsurf, ChatGPT)
 
-**Implementação proposta:**
-```typescript
-// packages/guard-brasil/src/reversible/
-interface AnonymizationMap {
-  version: string
-  entries: Array<{ type: string; original: string; placeholder: string }>
-  createdAt: string
-}
-// maskReversible(text) → { masked: string; map: AnonymizationMap }
-// unmask(text, map) → string (original restaurado)
+| Tool MCP | O que faz | Onde |
+|---|---|---|
+| `guard_inspect` | ATRiAN + PII + masking + (evidence chain) | `packages/guard-brasil-mcp/src/mcp-server.ts` + `apps/api/src/mcp-server.ts` |
+| `guard_scan_pii` | Scan PII isolado | idem |
+| `guard_check_safe` | Booleano: é seguro publicar? | idem |
+
+### 2.6 — API REST comercial + micropagamento
+
+| Caso | Onde | Status |
+|---|---|---|
+| `POST /v1/inspect` (Bearer auth, telemetria, keys) — `guard.egos.ia.br` | `apps/api/src/server.ts` | ATIVO (endpoint configurado; **verificar health antes de publicar** — último status conhecido: 502, `EGOS_BOOTSTRAP.md:255`) |
+| Canal x402 — micropagamento USDC/Base $0.001/scan (agent-to-agent) | `apps/egos-gateway/src/channels/guard-brasil.ts` | ATIVO |
+
+### 2.7 — Proveniência, evidência e logs (compliance)
+
+| Caso | Onde | Status |
+|---|---|---|
+| Audit hash de evidência (SHA-256 canonical JSON) | `lib/provenance.ts` (`buildAuditFields`) | ATIVO |
+| Evidence chain — claims ancorados a `tool_call \| document \| human_verified` | `lib/evidence-chain.ts` | ATIVO (infra) |
+| `secureLog()` — mascara objetos antes de `console.log` | `central-egos/template/src/lib/guard.ts` | ATIVO |
+| Eval comportamental (9 golden cases, anti-stub INC-008) | `tests/eval/capabilities/CBC-EGOS-MCP-SECURITY.eval.ts` | ATIVO |
+| Showcase público | `egos.ia.br/implementations#guard-brasil` | ATIVO (página existe; verificar live antes de citar como prova) |
+
+### 2.8 — PROPOSTOS / POTENCIAIS (roadmap)
+
+| # | Caso | Status | Task |
+|---|---|---|---|
+| P1 | Facade Intelink unificada (ATRiAN+PII+masking+evidence) | PROPOSTO | EGOS-G004 |
+| P2 | Perfis de tribunais plugáveis (TJMG, TJSP, TRF) | PROPOSTO | GUARD-HITL-004 |
+| P3 | Migração br-acc Python → API Guard Brasil | PROPOSTO | EGOS-G002 |
+| P4 | Tenant guard (acesso por unidade policial) | PROPOSTO | EGOS-G008 |
+| P5 | WhatsApp ingestion PII gate | POTENCIAL (parcial) | WA-PRIVACY-POLICY-001 |
+| P6 | Deploy VPS do runtime gate | POTENCIAL | — |
+| P7 | Camada de compliance para biometria (CNJ 615 + MJSP 961) | PROPOSTO | — |
+| P8 | Integração Sinapses 2.0 (judiciário) | CONCEPT | — |
+
+### Mapa de chamadas (arquitetura de uso)
+
+```
+PRE-COMMIT (pré-escrita):
+  .husky/06-pii-scan.sh           → grep CPF/CNPJ
+  scripts/scan-hardcoded.ts       → detectPII() full (R-SEC-001)
+  intelink/pii-mask-path-check    → audit import Neo4j
+
+RUNTIME INBOUND (pré-LLM):
+  egos-gateway/orchestrator.ts    → maskPII()        [R-SEC-002 T0]
+  852/api/chat/route.ts           → scanForPII() + sanitizeText()
+
+RUNTIME OUTBOUND (pré-publicação):
+  session-end-article.ts          → detectPII()      [R-SEC-005]
+  notebook-sync-local.ts          → detectPII()      [R-SEC-005]
+  insert-draft.ts                 → detectPII()      [R-SEC-005]
+
+MCP (agent-native):
+  guard-brasil-mcp / apps/api     → guard_inspect / guard_scan_pii / guard_check_safe
+
+API EXTERNA:
+  apps/api/server.ts              → POST /v1/inspect (guard.egos.ia.br)
+  channels/guard-brasil.ts        → x402 micropayment proxy
 ```
 
-**Diferença chave vs Datavirtus:** placeholder Guard Brasil deve incluir category EGOS
-(ex: `[REDS_0001]`, `[IPL_0001]`) — não só CPF/CNPJ/NOME/EMAIL.
+---
 
-#### 2. Detecção de nomes (NER por heurística)
-As Regras A-J do Datavirtus são engenhosas para contexto COAF (relatórios financeiros estruturados).
-Guard Brasil precisa de NER adaptado para contexto policial (relatórios PCMG, despachos REDS).
+## PARTE 3 — PADRÕES PII DETECTADOS (16 core + 4 PCMG + 7 infra)
 
-**Estratégia:** portar as Regras A-J para TypeScript, adaptando `PRESERVE` e `NOMES_BANCOS_INSTITUICOES`
-para o contexto policial MG (ex: preservar "DELEGACIA DE HOMICÍDIOS", "CORPO DE BOMBEIROS").
+### Core (`ALL_PII_PATTERNS`) — todos REAL
 
-### P2 — Paridade de formato
+| ID | Label | Confidence | Teste |
+|---|---|---|---|
+| `cpf` | CPF | high | ✅ |
+| `cnpj` | CNPJ | high | ✅ |
+| `rg` | RG | high | ✅ |
+| `cnh` | CNH (keyword) | medium | ✅ |
+| `masp` | MASP (matrícula servidor MG) | high | ✅ |
+| `reds` | REDS (registro evento segurança) | high | ✅ |
+| `processo` | Processo Judicial CNJ | high | ✅ |
+| `placa_antiga` / `placa_mercosul` | Placa veicular | medium | ✅ |
+| `telefone` | Telefone DDD/DDI | medium | ✅ |
+| `email` | Email | high | ✅ |
+| `sus` | Cartão SUS (15 díg) | medium | ✅ |
+| `nis_pis` | NIS/PIS | medium | ✅ |
+| `cep` | CEP | low | ✅ |
+| `titulo_eleitor` | Título de Eleitor | low | ⚠️ sem teste |
+| `health_condition` | Dado de saúde (LGPD art.11) | medium | ⚠️ sem teste |
 
-#### 3. Suporte a docx
-`python-docx` → equivalente TS: `mammoth` (leitura) ou `docx` (npm). Estratégia de concatenar
-runs antes de processar é crítica — dado sensível frequentemente está dividido entre runs em documentos
-Word gerados por sistemas legados.
+### Padrões PCMG (institution extension — `registry/pcmg.ts`)
 
-#### 4. Suporte a PDF
-`pymupdf` → equivalente TS: `pdf-parse` (extração) + `pdf-lib` (reconstrução). Cuidado: redaction
-em PDF é complexo; alternativa mais simples = extrair texto → anonimizar → gerar novo PDF de texto puro.
+`pcmg:bo_numero`, `pcmg:inquerito`, `pcmg:reds_complemento`, `pcmg:termo_circunstanciado`.
 
-### P3 — Melhorias de qualidade
+### ⚠️ Honestidade — PHANTOM no README (corrigir)
 
-#### 5. Lista PRESERVE para contexto policial
-Adaptar a lista `PRESERVE` do Datavirtus para o domínio PCMG:
-- Preservar: "POLÍCIA CIVIL", "CORPO DE BOMBEIROS", "MINISTÉRIO PÚBLICO", "TRIBUNAL DE JUSTIÇA", "SEDS", "SESP"
-- Preservar cargos: "DELEGADO", "INVESTIGADOR", "ESCRIVÃO", "AGENTE"
-- Preservar bairros/cidades conhecidas (para evitar mascarar topônimos como nomes)
+| Item | Alegação README | Realidade | Classificação |
+|---|---|---|---|
+| "Nome" | Detecção autônoma de PII | Só captura com prefixo de cargo (`delegado:`, `nome:`) — `pii-scanner.ts:55` | PHANTOM (como apresentado) |
+| "Data nascimento" | Detecção genérica `[DATA REMOVIDA]` | Só com keyword (`nascido:`, `DN:`) — `pii-scanner.ts:43` | PHANTOM (como apresentado) |
 
-#### 6. GUI opcional
-Para investigadores não-técnicos: wrapper Electron ou Tauri sobre Guard Brasil API.
-Não é necessidade de core, mas aumenta adoção.
+> **Ação:** o README deve dizer "Nome e data de nascimento detectados **com contexto/keyword**" — não detecção autônoma. (Gap real que o NER do Datavirtus cobre — ver Parte 6.)
 
 ---
 
-## Comparação de abordagem filosofica
+## PARTE 4 — COMPLIANCE REGULATÓRIO BR
 
-| Aspecto | Datavirtus | Guard Brasil |
+### 4.1 Marco regulatório (em vigor)
+
+| Norma | Data | Vincula |
 |---|---|---|
-| Target | Analistas financeiros (COAF), Windows | Investigadores policiais / judiciário, qualquer OS |
-| Paradigma | Ferramenta standalone GUI | Biblioteca + API + pipeline |
-| Reversibilidade | ✅ Obrigatória (workflow: anon→LLM→deanon) | ❌ Só mascaramento (prioridade segurança) |
-| Evolução de padrões | Manual (hardcoded) | HITL (aprendizado contínuo) |
-| Especificidade BR | CPF/CNPJ/nomes | + identificadores policiais/judiciários |
-| Stack | Python + tkinter | TypeScript + Bun |
-| Deploy | .exe Windows | npm package / Docker |
+| LGPD — Lei 13.709/2018 | 2018-08-14 | Todos os agentes de tratamento (universal) |
+| CNJ Resolução 615/2025 | 2025-03-11 | Poder Judiciário inteiro |
+| Portaria MJSP 961/2025 | 2025-06-24 | PF, PRF, PPF, FNSP, SENASP, SENAPEN + órgãos estaduais via fundo |
+| PL 2338/2023 (marco legal IA) | em tramitação | ainda não vigente |
+
+> **Status PCMG (HIPÓTESE):** se PCMG usar FNSP/FPN para projetos tech, Portaria 961 é vinculante; se não, é parâmetro interpretativo. **LGPD é vinculante em qualquer caso.**
+
+### 4.2 Como Guard Brasil atende (mapa norma → artigo → atendimento)
+
+| Norma | Artigo | Exigência | Guard Brasil | Status |
+|---|---|---|---|---|
+| LGPD | Art. 5 | Define dado pessoal | 16 padrões core detectam/mascaram | REAL |
+| LGPD | Art. 11 | Dado de saúde = sensível | `HEALTH_CONDITION_PATTERN` | REAL |
+| LGPD | Art. 46 | Medidas técnicas de segurança | Mascaramento antes de inferência; local-first | REAL |
+| CNJ 615 | Art. 13 | Alto risco → logs auditáveis | Evidence chain (audit hash + sessionId) | REAL |
+| CNJ 615 | Art. 13 | Alto risco → supervisão humana | HITL loop (arquitetura completa) | REAL (UI pendente) |
+| CNJ 615 | Art. 9 | Gestão de risco | Framework documentado (não é função do pacote) | DOCUMENTADO |
+| MJSP 961 | Art. 10 | IA proporcional + HITL obrigatório | HITL no ciclo de confiança | REAL |
+| MJSP 961 | Art. 13 | Logs (nome+CPF+IP+data+operação) | Evidence chain cobre sessionId+hash+timestamp; CPF/IP do operador = responsabilidade do integrador | PARCIAL |
+| MJSP 961 | Art. 11 | Biometria à distância vedada | Fora de escopo (foco é texto) | N/A |
+
+### 4.3 Tese central — "Local ≠ Privado por padrão"
+
+> *"Modelo local remove o risco de dado ir para LLM de terceiro. Mas conformidade exige mais: base legal, log auditável, autorização judicial para dados sigilosos. O modelo local é condição necessária, não suficiente."* — `BR_AI_REGULATORY_FRAMEWORK.md:119`
+
+Pipeline proposto (CONCEPT) para o judiciário:
+```
+[Documento bruto]
+   → [Guard Brasil mascara PII/identificadores]
+   → [Sinapses / LLM local processa documento anonimizado]
+   → [Resultado auditado: log de predição + revisão HITL]
+```
 
 ---
 
-## Tasks geradas por esta análise
+## PARTE 5 — DATAVIRTUS: CONTEXTO E ANÁLISE COMPETITIVA
+
+### 5.1 O que é a Datavirtus
+
+Plataforma de **formação para Agentes da Lei** (datavirtus.themembers.com.br) — modelo B2C/assinatura. O anonimizador é **material didático** entregue dentro dos cursos, não um produto standalone.
+
+**Cursos identificados (screenshot 2026-06-02):**
+
+| Curso | Relevância p/ EGOS |
+|---|---|
+| Pós em Investigação Financeira (PGIF 2026) | DIRETA — onde o anonimizador é ensinado |
+| **Pós em IA para Agentes da Lei** ("a 1ª do país") | ALTA — concorrente direto |
+| ChatGPT para Policiais e Agentes da Lei | ALTA |
+| IA local com Gemma 4 | DIRETA — paralelo ao curso EGOS |
+| NexVirtus PRO — Investigação Financeira | DIRETA |
+| Análise de Dados com Power BI | INDIRETA |
 
-| ID | Descrição | Prioridade |
+### 5.2 O anonimizador Datavirtus (código verificado — Python/tkinter, Windows)
+
+| Capacidade | Implementação |
+|---|---|
+| Anonimização reversível | Placeholder sequencial `[CPF_0001]` + mapeamento `.json` |
+| Desanonimização | `desanonimizador_gui.py` lê o JSON e restaura (caminho inverso) |
+| CPF / CNPJ / Email | Regex com e sem formatação |
+| Detecção de nomes | 10 regras heurísticas (A-J) + listas PRESERVE/CARGOS/NOMES_BANCOS |
+| Suporte `.docx` | `python-docx` — concatena runs antes de anonimizar |
+| Suporte `.pdf` | `pymupdf` — redaction por linha |
+| Offline total | Sem rede, sem API |
+
+**Fluxo ensinado:** `[doc] → anonimizar → [CPF_0001…] + mapa.json → ChatGPT/LLM externo → desanonimizar resultado → [doc com dados reais]`.
+
+### 5.3 Posicionamento — mesma audiência, apostas opostas
+
+| Dimensão | Datavirtus | EGOS / Guard Brasil |
 |---|---|---|
-| GUARD-DEANON-001 | Implementar anonimização reversível: `maskReversible()` + `unmask()` + `AnonymizationMap` | P1 |
-| GUARD-NER-001 | Portar Regras A-J de nomes para TypeScript, adaptadas para contexto policial MG | P1 |
-| GUARD-DOCX-001 | Suporte a .docx via `mammoth`/`docx` npm — concatenar runs antes de anonimizar | P2 |
-| GUARD-PDF-001 | Suporte a .pdf via `pdf-parse` + `pdf-lib` — extração + reconstrução | P2 |
-| GUARD-PRESERVE-001 | Lista PRESERVE para domínio policial MG (cargos, órgãos, topônimos) | P2 |
+| Modelo | Plataforma de cursos (B2C) | Framework open-source + governança + MCP |
+| Tese de IA | Ensina a usar ChatGPT/LLMs **externos** | IA **local** + governança + HITL auditável |
+| Privacidade | Anonimizar é gambito para usar LLM externo | Dado nunca sai da máquina **por design** |
+| LGPD | Usuário responsável por anonimizar antes | Enforcement automático no pipeline |
+| Especificidade | COAF, RIF, investigação financeira | PCMG (REDS, MASP, BO, IPL, TC) + judiciário |
+| Profundidade | Regex + heurística (manual, hardcoded) | HITL (aprendizado contínuo) + perfis plugáveis |
+| Reversibilidade | ✅ Obrigatória (anon→LLM→deanon) | ❌ Só mascaramento (gap real) |
+| Detecção de nomes | ✅ Regras A-J | ❌ Só com keyword (gap real) |
+| Formatos | ✅ docx + pdf | ❌ Texto puro |
+| Stack | Python + tkinter (.exe Windows) | TypeScript + Bun (npm / Docker / MCP) |
+
+**Tese de diferenciação (com qualificador temporal):** o anonimizador Datavirtus é um **workaround** para usar ChatGPT com dado sensível. Guard Brasil aponta para uma **solução nativa** que remove a necessidade do workaround — mais forte em ambientes com restrição de rede, casos LGPD-sensíveis, e auditabilidade. **Importante:** essa tese só se concretiza para o investigador autônomo QUANDO `GUARD-DEANON-001` (desanonimização) e `GUARD-NER-001` (NER de nomes) + suporte docx/pdf estiverem implementados. Hoje, para a tarefa prática "abrir .docx → anonimizar → LLM → restaurar", o Datavirtus funciona e o Guard Brasil ainda não. A vantagem atual do Guard Brasil é **arquitetural** (pipeline, HITL, perfis, compliance map), não de paridade de uso standalone.
 
 ---
 
-## Insights de arquitetura
+## PARTE 6 — O QUE GUARD BRASIL PODE APRENDER (tasks priorizadas)
 
-### Concatenação de runs = crítico para docx
-O Datavirtus concatena TODOS os runs de um parágrafo antes de anonimizar (linha 564):
-```python
-full_text = ''.join(run.text for run in runs if run.text)
-result, c = anonimizar(full_text, opts)
-runs[0].text = result
-for run in runs[1:]:
-    run.text = ''
+### P1 — Maior gap funcional
+
+**GUARD-DEANON-001 — Anonimização reversível (desanonimização)**
+Datavirtus tem; Guard Brasil só mascara (irreversível). Para o investigador restaurar dados no documento final após processar com LLM, a desanonimização é indispensável.
+```typescript
+// packages/guard-brasil/src/reversible/
+interface AnonymizationMap { version: string; entries: Array<{ type; original; placeholder }>; createdAt: string }
+// maskReversible(text) → { masked, map }   |   unmask(text, map) → original
 ```
-Sem isso, um CPF "123.456.789" pode estar distribuído em 3 runs por formatação do Word → a regex não captura.
-Guard Brasil deve adotar a mesma estratégia ao processar docx.
+**Diferença EGOS:** placeholder com category EGOS — `[REDS_0001]`, `[IPL_0001]`, `[BO_0001]`, `[TC_0001]`, `[MASP_0001]` — não só CPF/CNPJ/NOME.
 
-### Redaction em PDF = complexo
-A implementação PDF do Datavirtus usa `pymupdf.add_redact_annot()` + `page.apply_redactions()`.
-Isso cobre o texto com branco e insere o placeholder — preserva layout mas pode desalinhar fonte.
-Para Guard Brasil, uma estratégia mais simples pode ser aceita inicialmente:
-extração de texto (preservando estrutura) → anonimização → saída como texto ou PDF reconstruído.
+**GUARD-NER-001 — Detecção de nomes (NER por heurística)**
+Portar Regras A-J para TypeScript, adaptando `PRESERVE` e `NOMES_BANCOS` para contexto policial MG (preservar "DELEGACIA DE HOMICÍDIOS", "CORPO DE BOMBEIROS", "MINISTÉRIO PÚBLICO"). Resolve também o PHANTOM do README (Parte 3).
 
-### Placeholder com tipo
-O Datavirtus usa `[CPF_0001]`, `[CNPJ_0001]` etc. Guard Brasil deve estender para todos os tipos EGOS:
-`[REDS_0001]`, `[IPL_0001]`, `[BO_0001]`, `[TC_0001]`, `[MASP_0001]`
-Isso permite que o documento desanonimizado restaure os identificadores corretos por tipo.
+### P2 — Paridade de formato
 
----
+- **GUARD-DOCX-001** — `.docx` via `mammoth`/`docx` npm. **Crítico:** concatenar runs antes de anonimizar (Word divide CPF entre runs).
+- **GUARD-PDF-001** — `.pdf` via `pdf-parse` + `pdf-lib` (extração → anonimização → reconstrução).
 
----
+### P3 — Qualidade
 
-## Oportunidade de diferenciação
+- **GUARD-PRESERVE-001** — lista PRESERVE policial MG (órgãos, cargos, topônimos).
+- **GUARD-SCANNER-001** — fix `deduplicateFindings`: hoje mantém o primeiro match por posição, então `reds` (built-in) vence `pcmg:reds_complemento` (custom) → campo delegacia se perde. 3 falsos negativos no corpus. Prioridade: custom > built-in quando começam na mesma posição.
+- **Perfis institucionais** (GUARD-HITL-004) — TJMG, SES-MG, DETRAN-MG pendentes.
+
+### Insight de arquitetura — concatenação de runs (docx)
+
+```python
+full_text = ''.join(run.text for run in runs if run.text)  # Datavirtus linha 564
+result, c = anonimizar(full_text, opts)
+runs[0].text = result
+for run in runs[1:]: run.text = ''
+```
+Sem isso, um CPF dividido em 3 runs por formatação não é capturado. Guard Brasil deve adotar a mesma estratégia.
+
+---
 
-DataVirtus ensina: "anon → LLM externo → deanon." EGOS ensina: "IA local + governança = dado nunca sai."
-São apostas diferentes para o mesmo problema. A aposta EGOS é mais forte em:
-- Ambientes com restrição de rede (delegacias, prédios de segurança)
-- Casos onde a LGPD importa (investigações sigilosas, dados de vítimas)
-- Investigadores que precisam de auditabilidade (quem viu, quando, o quê)
+## PARTE 7 — TABELA DE TASKS GERADAS
 
-O anonimizador Datavirtus é um **workaround** para usar ChatGPT com dado sensível.
-Guard Brasil é a **solução nativa** que remove a necessidade desse workaround.
+| ID | Descrição | Prioridade | Status |
+|---|---|---|---|
+| GUARD-DEANON-001 | Anonimização reversível (`maskReversible` + `unmask` + `AnonymizationMap`) | P1 | 🔴 |
+| GUARD-NER-001 | NER de nomes (Regras A-J → TS, contexto policial MG) | P1 | 🔴 |
+| GUARD-SCANNER-001 | Fix `deduplicateFindings` (custom > built-in) | P1 | 🔴 |
+| GUARD-DOCX-001 | Suporte `.docx` (concatenar runs) | P2 | 🔴 |
+| GUARD-PDF-001 | Suporte `.pdf` (extração + reconstrução) | P2 | 🔴 |
+| GUARD-PRESERVE-001 | Lista PRESERVE policial MG | P2 | 🔴 |
+| GUARD-HITL-004 | Perfis TJMG / SES-MG / DETRAN-MG | P2 | 🔴 |
+| README-FIX-001 | Corrigir PHANTOM "Nome"/"Data nasc." (detecção é keyword-based) | P3 | 🔴 |
 
 ---
 
-*Fontes verificadas: anonimizador_v2_gui.py (1029 LOC) + desanonimizador_gui.py (501 LOC) + LEIA-ME.txt + DATAVIRTUS.pdf (screenshot plataforma 2026-06-02)*
+*Fontes verificadas: 3 investigações Explore cruzadas sobre `packages/guard-brasil/` v0.2.3 (46 testes) + anonimizador_v2_gui.py (1029 LOC) + desanonimizador_gui.py (501 LOC) + LEIA-ME.txt + DATAVIRTUS.pdf (screenshot 2026-06-02) + BR_AI_REGULATORY_FRAMEWORK.md + EXTENSIBILITY.md*
 *EGOS Framework · Guard Brasil · docs/guard-brasil/DATAVIRTUS_ANALYSIS.md · 2026-06-10*
diff --git a/docs/guard-brasil/GUARD_BRASIL_ANALYSIS.html b/docs/guard-brasil/GUARD_BRASIL_ANALYSIS.html
new file mode 100644
index 00000000..ac858146
--- /dev/null
+++ b/docs/guard-brasil/GUARD_BRASIL_ANALYSIS.html
@@ -0,0 +1,1568 @@
+<!DOCTYPE html>
+<html lang="pt-BR" class="dark">
+<head>
+<meta charset="UTF-8">
+<meta name="viewport" content="width=device-width, initial-scale=1.0">
+<title>Guard Brasil — Análise de Produto (referência interna) · 2026-06-10</title>
+<style>
+:root {
+  /* EGOS Palette canônica — docs/governance/VISUAL_IDENTITY.md v1.1.0 */
+  --egos-black: #0A0E27;
+  --navy: #1A2F5A;
+  --blue: #2563EB;
+  --evidence-green: #10B981;
+  --warning-amber: #F59E0B;
+  --danger-red: #EF4444;
+
+  /* UI tokens (light mode default overridden to dark via <html class="dark">) */
+  --sidebar-w: 268px;
+  --header-h: 58px;
+
+  --bg: #f8fafc;
+  --bg2: #f1f5f9;
+  --card-bg: #ffffff;
+  --border: #e2e8f0;
+  --text: #1e293b;
+  --muted: #64748b;
+  --accent-bg: #0f172a;
+  --b-green: #d1fae5;
+  --b-amber: #fef3c7;
+  --b-red: #fee2e2;
+  --b-blue: #dbeafe;
+  --b-navy: #e0e7ff;
+}
+html.dark {
+  --bg: #0A0E27;
+  --bg2: #0f1535;
+  --card-bg: #1A2F5A;
+  --border: #2d4a7a;
+  --text: #e2e8f0;
+  --muted: #94a3b8;
+  --accent-bg: #060916;
+  --b-green: #064e3b;
+  --b-amber: #451a03;
+  --b-red: #450a0a;
+  --b-blue: #1e3a5f;
+  --b-navy: #1e1b4b;
+}
+* { box-sizing: border-box; margin: 0; padding: 0; }
+body {
+  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
+  font-size: 15px;
+  background: var(--bg);
+  color: var(--text);
+  display: flex;
+  flex-direction: column;
+  min-height: 100vh;
+  transition: background 0.2s, color 0.2s;
+}
+
+/* ──────────────────────── HEADER ──────────────────────── */
+.top-header {
+  position: fixed;
+  top: 0; left: 0; right: 0;
+  height: var(--header-h);
+  background: var(--accent-bg);
+  color: #fff;
+  display: flex;
+  align-items: center;
+  gap: 12px;
+  padding: 0 18px;
+  z-index: 200;
+  box-shadow: 0 2px 10px rgba(0,0,0,0.4);
+  border-bottom: 1px solid rgba(37,99,235,0.4);
+}
+.top-header .logo {
+  font-size: 13px;
+  font-weight: 800;
+  letter-spacing: 0.06em;
+  color: var(--blue);
+  text-transform: uppercase;
+  flex-shrink: 0;
+}
+.top-header .logo span { color: var(--evidence-green); }
+.top-header h1 {
+  font-size: 14px;
+  font-weight: 600;
+  opacity: 0.9;
+  flex: 1;
+  white-space: nowrap;
+  overflow: hidden;
+  text-overflow: ellipsis;
+}
+.header-btns { display: flex; gap: 8px; flex-shrink: 0; align-items: center; }
+.header-btns button {
+  padding: 5px 12px;
+  border-radius: 6px;
+  border: 1px solid rgba(255,255,255,0.25);
+  background: rgba(255,255,255,0.08);
+  color: #fff;
+  cursor: pointer;
+  font-size: 12px;
+  transition: background 0.15s;
+}
+.header-btns button:hover { background: rgba(255,255,255,0.18); }
+.tagline {
+  font-size: 11px;
+  opacity: 0.5;
+  letter-spacing: 0.04em;
+  font-style: italic;
+  flex-shrink: 0;
+}
+
+/* ──────────────────────── BADGES ──────────────────────── */
+.badge {
+  display: inline-flex; align-items: center;
+  padding: 2px 9px;
+  border-radius: 99px;
+  font-size: 10px;
+  font-weight: 800;
+  text-transform: uppercase;
+  letter-spacing: 0.07em;
+  white-space: nowrap;
+}
+.badge-real    { background: var(--evidence-green); color: #fff; }
+.badge-concept { background: var(--warning-amber);  color: #fff; }
+.badge-roadmap { background: var(--danger-red);     color: #fff; }
+.badge-parcial { background: #8b5cf6;               color: #fff; }
+.badge-phantom { background: #6b7280;               color: #fff; }
+.badge-hipotese { background: var(--warning-amber); color: #fff; }
+.badge-blue    { background: var(--blue);           color: #fff; }
+.badge-navy    { background: var(--navy);           color: #fff; }
+.badge-doc     { background: #0891b2;               color: #fff; }
+.badge-gap     { background: var(--danger-red);     color: #fff; }
+.badge-ver     { background: var(--warning-amber);  color: #1e293b; }
+.badge-v       { background: rgba(255,255,255,0.15); color: #fff; border: 1px solid rgba(255,255,255,0.3); }
+
+/* ──────────────────────── LAYOUT ──────────────────────── */
+.layout { display: flex; margin-top: var(--header-h); flex: 1; }
+
+/* ──────────────────────── SIDEBAR ──────────────────────── */
+.sidebar {
+  position: fixed;
+  top: var(--header-h); left: 0; bottom: 0;
+  width: var(--sidebar-w);
+  background: var(--card-bg);
+  border-right: 1px solid var(--border);
+  overflow-y: auto;
+  padding: 10px 0 28px;
+  z-index: 100;
+}
+.sidebar-section {
+  font-size: 9px;
+  font-weight: 800;
+  text-transform: uppercase;
+  letter-spacing: 0.1em;
+  color: var(--muted);
+  padding: 14px 16px 4px;
+  border-top: 1px solid var(--border);
+  margin-top: 4px;
+}
+.sidebar-section:first-child { border-top: none; margin-top: 0; }
+.sidebar-link {
+  display: block;
+  padding: 6px 16px;
+  font-size: 12px;
+  color: var(--text);
+  text-decoration: none;
+  border-left: 3px solid transparent;
+  transition: all 0.15s;
+  line-height: 1.4;
+}
+.sidebar-link:hover {
+  background: var(--bg2);
+  border-left-color: var(--blue);
+  color: var(--blue);
+}
+.sidebar-link.active {
+  background: var(--bg2);
+  border-left-color: var(--evidence-green);
+  color: var(--evidence-green);
+  font-weight: 600;
+}
+
+/* ──────────────────────── MAIN ──────────────────────── */
+.main {
+  margin-left: var(--sidebar-w);
+  flex: 1;
+  padding: 28px 32px;
+  max-width: 980px;
+}
+
+/* ──────────────────────── HERO ──────────────────────── */
+.hero {
+  background: linear-gradient(135deg, var(--egos-black) 0%, var(--navy) 60%, #1d4ed8 100%);
+  border-radius: 14px;
+  padding: 36px 32px;
+  color: #fff;
+  margin-bottom: 24px;
+  position: relative;
+  overflow: hidden;
+}
+.hero::before {
+  content: '';
+  position: absolute; top: -40px; right: -40px;
+  width: 220px; height: 220px; border-radius: 50%;
+  background: rgba(16,185,129,0.12);
+  pointer-events: none;
+}
+.hero::after {
+  content: '';
+  position: absolute; bottom: -30px; left: 40%;
+  width: 140px; height: 140px; border-radius: 50%;
+  background: rgba(37,99,235,0.15);
+  pointer-events: none;
+}
+.hero h1 { font-size: 22px; font-weight: 800; margin-bottom: 10px; line-height: 1.3; }
+.hero .hero-sub { font-size: 14px; opacity: 0.75; max-width: 680px; line-height: 1.7; margin-bottom: 20px; }
+.hero-chips { display: flex; gap: 10px; flex-wrap: wrap; }
+.hero-chip {
+  padding: 4px 13px; border-radius: 99px; font-size: 11px; font-weight: 600;
+  background: rgba(255,255,255,0.12); color: #fff;
+  border: 1px solid rgba(255,255,255,0.2);
+}
+.hero-chip.green  { background: rgba(16,185,129,0.25); border-color: rgba(16,185,129,0.4); }
+.hero-chip.amber  { background: rgba(245,158,11,0.25); border-color: rgba(245,158,11,0.4); }
+.hero-chip.red    { background: rgba(239,68,68,0.25);  border-color: rgba(239,68,68,0.4); }
+
+/* ──────────────────────── CARDS ──────────────────────── */
+.card {
+  background: var(--card-bg);
+  border-radius: 12px;
+  border-left: 5px solid var(--border);
+  margin-bottom: 22px;
+  box-shadow: 0 1px 6px rgba(0,0,0,0.1);
+  overflow: hidden;
+  scroll-margin-top: 72px;
+}
+.card-green  { border-left-color: var(--evidence-green); }
+.card-amber  { border-left-color: var(--warning-amber); }
+.card-red    { border-left-color: var(--danger-red); }
+.card-blue   { border-left-color: var(--blue); }
+.card-navy   { border-left-color: var(--navy); }
+.card-purple { border-left-color: #8b5cf6; }
+.card-gray   { border-left-color: var(--muted); }
+.card-header {
+  padding: 14px 20px;
+  display: flex; align-items: center; gap: 10px;
+  border-bottom: 1px solid var(--border);
+  background: var(--bg2);
+}
+.card-header h2 { font-size: 16px; font-weight: 700; flex: 1; }
+.card-header .badges { display: flex; gap: 6px; flex-wrap: wrap; }
+.card-body { padding: 20px; }
+
+/* ──────────────────────── NOTICE BOX ──────────────────────── */
+.notice {
+  border-radius: 10px;
+  padding: 14px 18px;
+  display: flex; gap: 14px; align-items: flex-start;
+  margin-bottom: 18px;
+  font-size: 13.5px;
+  line-height: 1.7;
+}
+.notice-icon { font-size: 20px; flex-shrink: 0; margin-top: 1px; }
+.notice-body strong { display: block; font-size: 14px; margin-bottom: 3px; }
+.notice-green  { background: var(--b-green);  border: 1px solid var(--evidence-green); }
+.notice-amber  { background: var(--b-amber);  border: 1px solid var(--warning-amber); }
+.notice-red    { background: var(--b-red);    border: 1px solid var(--danger-red); }
+.notice-blue   { background: var(--b-blue);   border: 1px solid var(--blue); }
+.notice-navy   { background: var(--b-navy);   border: 1px solid var(--navy); }
+
+/* ──────────────────────── TABLES ──────────────────────── */
+.table-wrap { overflow-x: auto; margin: 12px 0; }
+table { width: 100%; border-collapse: collapse; font-size: 13px; }
+th {
+  text-align: left; padding: 9px 12px;
+  font-size: 10px; font-weight: 800;
+  color: var(--muted); text-transform: uppercase; letter-spacing: 0.07em;
+  border-bottom: 2px solid var(--border);
+  background: var(--bg2);
+}
+td { padding: 9px 12px; border-bottom: 1px solid var(--border); vertical-align: top; line-height: 1.6; }
+tr:last-child td { border-bottom: none; }
+tr:nth-child(even) td { background: rgba(0,0,0,0.04); }
+html.dark tr:nth-child(even) td { background: rgba(255,255,255,0.03); }
+tr:hover td { background: var(--b-blue); }
+html.dark tr:hover td { background: rgba(37,99,235,0.1); }
+code.mono { font-family: 'SFMono-Regular', Consolas, monospace; font-size: 12px; background: var(--bg2); padding: 1px 5px; border-radius: 4px; color: var(--evidence-green); }
+
+/* ──────────────────────── GRID ──────────────────────── */
+.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 18px; }
+.grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; margin-bottom: 18px; }
+.stat-card {
+  background: var(--card-bg);
+  border: 1px solid var(--border);
+  border-radius: 10px; padding: 18px;
+}
+.stat-card .stat-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.07em; color: var(--muted); margin-bottom: 6px; }
+.stat-card .stat-val  { font-size: 30px; font-weight: 800; color: var(--evidence-green); line-height: 1.1; }
+.stat-card .stat-sub  { font-size: 12px; color: var(--muted); margin-top: 3px; }
+.stat-card.amber .stat-val { color: var(--warning-amber); }
+.stat-card.red   .stat-val { color: var(--danger-red); }
+.stat-card.blue  .stat-val { color: var(--blue); }
+
+/* ──────────────────────── FLOW DIAGRAM ──────────────────────── */
+.flow {
+  display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
+  padding: 16px; background: var(--bg2); border-radius: 8px;
+  border: 1px solid var(--border); margin: 12px 0;
+}
+.flow-node {
+  padding: 6px 14px; border-radius: 8px; font-size: 12px; font-weight: 600;
+  white-space: nowrap;
+}
+.flow-arrow { color: var(--muted); font-size: 20px; font-weight: 300; }
+.fn-green  { background: var(--b-green);  color: var(--evidence-green); }
+.fn-blue   { background: var(--b-blue);   color: var(--blue); }
+.fn-amber  { background: var(--b-amber);  color: var(--warning-amber); }
+.fn-red    { background: var(--b-red);    color: var(--danger-red); }
+.fn-gray   { background: var(--bg2);      color: var(--muted); border: 1px solid var(--border); }
+
+/* ──────────────────────── LAYER BLOCK ──────────────────────── */
+.layer-block {
+  display: grid; grid-template-columns: 1fr 1fr; gap: 14px;
+  margin: 14px 0;
+}
+.layer-card {
+  background: var(--bg2);
+  border: 1px solid var(--border);
+  border-radius: 10px;
+  padding: 16px;
+}
+.layer-card h4 { font-size: 13px; font-weight: 700; margin-bottom: 6px; display: flex; align-items: center; gap: 8px; }
+.layer-card p { font-size: 12.5px; color: var(--muted); line-height: 1.6; }
+.layer-card code { font-family: monospace; font-size: 11px; background: rgba(0,0,0,0.2); padding: 1px 5px; border-radius: 3px; }
+.layer-green { border-left: 4px solid var(--evidence-green); }
+.layer-blue  { border-left: 4px solid var(--blue); }
+.layer-amber { border-left: 4px solid var(--warning-amber); }
+.layer-red   { border-left: 4px solid var(--danger-red); }
+
+/* ──────────────────────── ROAD ITEM ──────────────────────── */
+.road-item {
+  display: flex; gap: 14px; align-items: flex-start;
+  padding: 14px 0;
+  border-bottom: 1px solid var(--border);
+}
+.road-item:last-child { border-bottom: none; }
+.road-icon { font-size: 22px; flex-shrink: 0; }
+.road-body h4 { font-size: 14px; font-weight: 700; margin-bottom: 4px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
+.road-body p { font-size: 13px; color: var(--muted); line-height: 1.6; }
+.road-body code { font-family: monospace; font-size: 11px; background: var(--bg2); padding: 1px 5px; border-radius: 3px; color: var(--evidence-green); }
+
+/* ──────────────────────── DIVIDER ──────────────────────── */
+.section-title {
+  font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em;
+  color: var(--muted); margin: 28px 0 14px; padding-bottom: 6px;
+  border-bottom: 1px solid var(--border);
+}
+
+/* ──────────────────────── FOOTER ──────────────────────── */
+.page-footer {
+  margin-left: var(--sidebar-w);
+  text-align: center;
+  padding: 32px 24px;
+  color: var(--muted);
+  font-size: 12px;
+  border-top: 1px solid var(--border);
+  line-height: 1.8;
+}
+.footer-tagline {
+  font-size: 16px; font-weight: 800; letter-spacing: 0.08em;
+  color: var(--evidence-green); margin-bottom: 8px;
+}
+
+/* ──────────────────────── RESPONSIVE ──────────────────────── */
+@media (max-width: 820px) {
+  .sidebar { display: none; }
+  .main, .page-footer { margin-left: 0; }
+  .grid-2, .grid-3, .layer-block { grid-template-columns: 1fr; }
+  .flow { font-size: 12px; }
+}
+
+/* ──────────────────────── SCROLL ACTIVE ──────────────────────── */
+html { scroll-behavior: smooth; }
+</style>
+</head>
+<body>
+
+<!-- ████████████████████ HEADER ████████████████████ -->
+<header class="top-header">
+  <span class="logo">EGOS<span>·</span>Guard Brasil</span>
+  <h1>Análise de Produto — Guard Brasil · Análise Competitiva Datavirtus</h1>
+  <span class="tagline">Governance is Infrastructure</span>
+  <div class="header-btns">
+    <button onclick="document.documentElement.classList.toggle('dark')">☀ / ☾ Modo</button>
+    <span class="badge badge-v">v1.0 · 2026-06-10</span>
+  </div>
+</header>
+
+<div class="layout">
+
+<!-- ████████████████████ SIDEBAR ████████████████████ -->
+<nav class="sidebar">
+  <div class="sidebar-section">Visão Geral</div>
+  <a class="sidebar-link" href="#audiencia">Audiência + Classificação</a>
+  <a class="sidebar-link" href="#metricas">Métricas de qualidade</a>
+
+  <div class="sidebar-section">O que funciona hoje</div>
+  <a class="sidebar-link" href="#camadas">4 Camadas (REAL)</a>
+  <a class="sidebar-link" href="#padroes-pii">Padrões PII (16+7+4)</a>
+  <a class="sidebar-link" href="#casos-uso">22 Casos de uso ATIVOS</a>
+  <a class="sidebar-link" href="#phantom-readme">⚠ PHANTOM no README</a>
+
+  <div class="sidebar-section">Dentro vs Fora do Ecossistema</div>
+  <a class="sidebar-link" href="#standalone">Standalone (sem infra)</a>
+  <a class="sidebar-link" href="#ecossistema">Requer infra EGOS</a>
+
+  <div class="sidebar-section">Compliance Map</div>
+  <a class="sidebar-link" href="#compliance">Norma → Artigo → Status</a>
+  <a class="sidebar-link" href="#tese-local">Tese "Local ≠ Privado"</a>
+  <a class="sidebar-link" href="#pcmg-status">Status PCMG (HIPÓTESE)</a>
+
+  <div class="sidebar-section">Roadmap Honesto</div>
+  <a class="sidebar-link" href="#gaps">Gaps críticos</a>
+  <a class="sidebar-link" href="#tasks">Tasks abertas</a>
+
+  <div class="sidebar-section">Datavirtus</div>
+  <a class="sidebar-link" href="#datavirtus-o-que">O que é</a>
+  <a class="sidebar-link" href="#comparativo">Comparativo equilibrado</a>
+  <a class="sidebar-link" href="#tese-diferenciacao">Tese de diferenciação</a>
+
+  <div class="sidebar-section">Referência</div>
+  <a class="sidebar-link" href="#rodape">Fonte + Versão</a>
+</nav>
+
+<!-- ████████████████████ MAIN ████████████████████ -->
+<main class="main">
+
+<!-- HERO -->
+<div class="hero" id="hero">
+  <h1>Guard Brasil — Análise de Produto + Datavirtus</h1>
+  <p class="hero-sub">Referência interna de produto EGOS e avaliador técnico. Classificação honesta de capacidades: <strong>REAL</strong> (código + teste verificado), <strong>CONCEPT</strong> (implementado, não integrado), <strong>ROADMAP</strong> (gap aberto), <strong>PHANTOM</strong> (alegado, inexistente). Fonte única: <code style="font-size:12px; background:rgba(255,255,255,0.1); padding:2px 6px; border-radius:4px">docs/guard-brasil/DATAVIRTUS_ANALYSIS.md</code> · <code style="font-size:12px; background:rgba(255,255,255,0.1); padding:2px 6px; border-radius:4px">packages/guard-brasil/</code> v0.2.3 (46 testes, 3 investigações Explore cruzadas).</p>
+  <div class="hero-chips">
+    <span class="hero-chip green">22 casos ATIVOS</span>
+    <span class="hero-chip green">46 testes · 0 fail</span>
+    <span class="hero-chip green">16 padrões PII + 4 PCMG + 7 segredos</span>
+    <span class="hero-chip amber">5 gaps críticos abertos</span>
+    <span class="hero-chip red">API 502 — verificar health</span>
+  </div>
+</div>
+
+<!-- ─────────────── AUDIÊNCIA ─────────────── -->
+<div class="card card-navy" id="audiencia" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Audiência &amp; Classificação deste material</h2>
+    <div class="badges">
+      <span class="badge badge-navy">INTERNO</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-amber">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        <strong>Material de referência interna de produto — não é proposta comercial.</strong>
+        Audiência: time EGOS interno + avaliador técnico. <em>Não é cold-demo para cliente policial externo.</em> Toda afirmação neste documento cita fonte verificada. Alegações sem evidência são marcadas explicitamente.
+      </div>
+    </div>
+    <div class="grid-3">
+      <div class="stat-card">
+        <div class="stat-label">Status geral</div>
+        <div class="stat-val" style="font-size:20px; color: var(--evidence-green)">Produto v0.2.3</div>
+        <div class="stat-sub">npm publicado · 46 testes passando</div>
+      </div>
+      <div class="stat-card amber">
+        <div class="stat-label">API pública</div>
+        <div class="stat-val" style="font-size:18px">⚠ 502</div>
+        <div class="stat-sub">guard.egos.ia.br — endpoint configurado, último status 502 — verificar health antes de citar</div>
+      </div>
+      <div class="stat-card red">
+        <div class="stat-label">Gaps críticos</div>
+        <div class="stat-val">5</div>
+        <div class="stat-sub">Desanonimização, NER, docx, pdf, scanner dedup</div>
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr>
+          <th>Badge</th><th>Significado</th><th>Critério</th>
+        </tr>
+        <tr>
+          <td><span class="badge badge-real">REAL</span></td>
+          <td>Código implementado + teste automatizado passando</td>
+          <td>Arquivo fonte + número de teste verificado</td>
+        </tr>
+        <tr>
+          <td><span class="badge badge-concept">CONCEPT</span></td>
+          <td>Implementado mas não integrado à superfície final</td>
+          <td>Código existe, não está wired em produção</td>
+        </tr>
+        <tr>
+          <td><span class="badge badge-roadmap">ROADMAP</span></td>
+          <td>Gap documentado, task aberta</td>
+          <td>ID de task + prioridade</td>
+        </tr>
+        <tr>
+          <td><span class="badge badge-phantom">PHANTOM</span></td>
+          <td>Alegado em doc/README sem existir no código</td>
+          <td>README diverge da implementação</td>
+        </tr>
+        <tr>
+          <td><span class="badge badge-parcial">PARCIAL</span></td>
+          <td>Atende parcialmente — integrador tem responsabilidade residual</td>
+          <td>Cobre parte do requisito, documentado</td>
+        </tr>
+        <tr>
+          <td><span class="badge badge-hipotese">HIPÓTESE</span></td>
+          <td>Vínculo regulatório plausível mas não confirmado juridicamente</td>
+          <td>Interpretação técnica, não parecer legal</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- ─────────────── MÉTRICAS ─────────────── -->
+<div class="card card-green" id="metricas" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Métricas de qualidade verificadas</h2>
+    <div class="badges"><span class="badge badge-real">REAL</span></div>
+  </div>
+  <div class="card-body">
+    <p style="font-size:13px; color:var(--muted); margin-bottom:16px">Fonte: <code class="mono">bun test</code> em <code class="mono">packages/guard-brasil/</code> v0.2.3 — verificado 2026-06-10 via 3 investigações Explore cruzadas.</p>
+    <div class="grid-3">
+      <div class="stat-card">
+        <div class="stat-label">Testes passando</div>
+        <div class="stat-val">46</div>
+        <div class="stat-sub">0 falhas · 106 expects() · 39ms</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Padrões PII core</div>
+        <div class="stat-val">16</div>
+        <div class="stat-sub">CPF, CNPJ, RG, CNH, MASP, REDS, Processo, Placa, Telefone, Email, SUS, NIS/PIS, CEP, Título Eleitor, Saúde + 14 com teste</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Segredos de infra</div>
+        <div class="stat-val">7</div>
+        <div class="stat-sub">AWS, GitHub, Stripe, DB conn, API key, Bearer, PEM</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Padrões PCMG</div>
+        <div class="stat-val">4</div>
+        <div class="stat-sub">BO, IPL, REDS complemento, TC</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Validações HITL PCMG</div>
+        <div class="stat-val">12</div>
+        <div class="stat-sub">0 rejeições · corpus 28 frases</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Checks ATRiAN</div>
+        <div class="stat-val">5</div>
+        <div class="stat-sub">Score 0-100 · claims absolutos · dados fabricados · promessas falsas · entidades bloqueadas</div>
+      </div>
+    </div>
+    <div class="notice notice-blue" style="margin-top: 4px">
+      <span class="notice-icon">ℹ</span>
+      <div class="notice-body">
+        <strong>Drift de versão interno (sem impacto funcional):</strong> <code class="mono">package.json</code> = v0.2.3; <code class="mono">GUARD_VERSION</code> interno = "0.2.2" — drift de 1 patch, não afeta comportamento. Fonte: <code class="mono">packages/guard-brasil/src/index.ts</code>.
+      </div>
+    </div>
+  </div>
+</div>
+
+<!-- ═══════════════════════════════════════════════════════ -->
+<!--                  O QUE FUNCIONA HOJE                    -->
+<!-- ═══════════════════════════════════════════════════════ -->
+<div class="section-title" id="secao-real">O que funciona hoje — REAL</div>
+
+<!-- 4 CAMADAS -->
+<div class="card card-green" id="camadas" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>As 4 Camadas do Guard Brasil</h2>
+    <div class="badges">
+      <span class="badge badge-real">REAL</span>
+      <span class="badge badge-blue">Todas com teste</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-green">
+      <span class="notice-icon">✅</span>
+      <div class="notice-body">
+        Facade única: <code class="mono">GuardBrasil.create().inspect(texto)</code> orquestra as 4 camadas e retorna um <code class="mono">InspectionReceipt</code> com hashes de input/output/inspeção + nível de proveniência auditável.
+      </div>
+    </div>
+    <div class="layer-block">
+      <div class="layer-card layer-green">
+        <h4><span class="badge badge-real">REAL</span> PII Scanner BR</h4>
+        <p>Detecta e mascara 16 categorias de dado pessoal BR + 7 segredos de infra.<br>
+        Funções: <code>scanForPII()</code> / <code>maskPII()</code> / <code>detectPII()</code><br>
+        Arquivos: <code>lib/pii-scanner.ts</code> + <code>pii-patterns.ts</code></p>
+      </div>
+      <div class="layer-card layer-blue">
+        <h4><span class="badge badge-real">REAL</span> ATRiAN — Validação Ética</h4>
+        <p>Score ético 0-100. Flags: claims absolutos, dados fabricados, promessas falsas, entidades bloqueadas.<br>
+        Função: <code>createAtrianValidator()</code><br>
+        Arquivo: <code>lib/atrian.ts</code></p>
+      </div>
+      <div class="layer-card layer-amber">
+        <h4><span class="badge badge-real">REAL</span> Public Guard — Saída Segura</h4>
+        <p>Classificação de sensibilidade LGPD + redação + disclosure automático.<br>
+        Funções: <code>maskPublicOutput()</code> / <code>isPublicSafe()</code><br>
+        Arquivo: <code>lib/public-guard.ts</code></p>
+      </div>
+      <div class="layer-card layer-red">
+        <h4><span class="badge badge-real">REAL</span> Evidence Chain — Rastreabilidade</h4>
+        <p>Rastreabilidade de claims + audit hash SHA-256 (<code>ev-&lt;64hex&gt;</code>) + sessionId + timestamp.<br>
+        Função: <code>createEvidenceChain()</code><br>
+        Arquivo: <code>lib/evidence-chain.ts</code></p>
+      </div>
+    </div>
+    <div class="notice notice-blue">
+      <span class="notice-icon">ℹ</span>
+      <div class="notice-body">
+        <strong>Dependência runtime mínima:</strong> apenas <code class="mono">@supabase/supabase-js</code> (lazy, só para telemetria/keys). O pacote pode funcionar sem dependências externas no modo offline.
+      </div>
+    </div>
+  </div>
+</div>
+
+<!-- PADRÕES PII -->
+<div class="card card-green" id="padroes-pii" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Padrões PII detectados (16 core + 4 PCMG + 7 infra)</h2>
+    <div class="badges">
+      <span class="badge badge-real">REAL</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <p class="section-title" style="margin-top:0">Core — <code class="mono">ALL_PII_PATTERNS</code></p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>ID</th><th>Label</th><th>Confidence</th><th>Teste</th></tr>
+        <tr><td><code class="mono">cpf</code></td><td>CPF</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">cnpj</code></td><td>CNPJ</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">rg</code></td><td>RG</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">cnh</code></td><td>CNH (keyword)</td><td>medium</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">masp</code></td><td>MASP (matrícula servidor MG)</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">reds</code></td><td>REDS (registro evento segurança)</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">processo</code></td><td>Processo Judicial CNJ</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">placa_antiga / placa_mercosul</code></td><td>Placa veicular</td><td>medium</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">telefone</code></td><td>Telefone DDD/DDI</td><td>medium</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">email</code></td><td>Email</td><td>high</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">sus</code></td><td>Cartão SUS (15 dígitos)</td><td>medium</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">nis_pis</code></td><td>NIS/PIS</td><td>medium</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">cep</code></td><td>CEP</td><td>low</td><td><span class="badge badge-real">✓</span></td></tr>
+        <tr><td><code class="mono">titulo_eleitor</code></td><td>Título de Eleitor</td><td>low</td><td><span class="badge badge-concept">sem teste</span></td></tr>
+        <tr><td><code class="mono">health_condition</code></td><td>Dado de saúde (LGPD art.11)</td><td>medium</td><td><span class="badge badge-concept">sem teste</span></td></tr>
+      </table>
+    </div>
+    <p class="section-title">Padrões PCMG — <code class="mono">registry/pcmg.ts</code></p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>ID</th><th>O que detecta</th><th>Exemplo (sintético)</th><th>Status</th></tr>
+        <tr>
+          <td><code class="mono">pcmg:bo_numero</code></td>
+          <td>Boletim de Ocorrência</td>
+          <td><code class="mono">BO 2024/001234</code></td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">pcmg:inquerito</code></td>
+          <td>Inquérito Policial (IPL)</td>
+          <td><code class="mono">IPL 0099/2024</code></td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">pcmg:reds_complemento</code></td>
+          <td>REDS com campo delegacia</td>
+          <td><code class="mono">REDS-2024-012/045</code></td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">pcmg:termo_circunstanciado</code></td>
+          <td>Termo Circunstanciado (TC)</td>
+          <td><code class="mono">TC-0045/2024</code></td>
+          <td><span class="badge badge-real">REAL</span> <span class="badge badge-concept">confidence medium</span></td>
+        </tr>
+      </table>
+    </div>
+    <p class="section-title">Segredos de infraestrutura — <code class="mono">INFRASTRUCTURE_SECRET_PATTERNS</code></p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Tipo</th><th>Status</th></tr>
+        <tr><td>AWS credentials (<code class="mono">AKIA*</code>)</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>GitHub tokens (<code class="mono">ghp_*</code>, <code class="mono">ghs_*</code>)</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>Stripe keys (<code class="mono">sk_live_*</code>, <code class="mono">pk_live_*</code>)</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>DB connection strings</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>API keys genéricas</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>Bearer tokens</td><td><span class="badge badge-real">REAL</span></td></tr>
+        <tr><td>PEM certificates</td><td><span class="badge badge-real">REAL</span></td></tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- PHANTOM NO README -->
+<div class="card card-amber" id="phantom-readme" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>⚠ PHANTOM no README — corrigir</h2>
+    <div class="badges">
+      <span class="badge badge-phantom">PHANTOM</span>
+      <span class="badge badge-roadmap">README-FIX-001</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-amber">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        O README alega detecção autônoma de "Nome" e "Data de nascimento". Isso é <strong>incorreto</strong>: ambos só funcionam com prefixo de keyword explícito. Classificação honesta: <strong>PHANTOM como apresentado</strong>. Ação: <code class="mono">README-FIX-001</code> (P3).
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Item</th><th>Alegação README</th><th>Realidade (código)</th><th>Classificação</th></tr>
+        <tr>
+          <td><strong>Nome</strong></td>
+          <td>Detecção autônoma de PII</td>
+          <td>Só captura com prefixo de cargo (<code class="mono">delegado:</code>, <code class="mono">nome:</code>) — <code class="mono">pii-scanner.ts:55</code></td>
+          <td><span class="badge badge-phantom">PHANTOM</span></td>
+        </tr>
+        <tr>
+          <td><strong>Data de nascimento</strong></td>
+          <td>Detecção genérica <code class="mono">[DATA REMOVIDA]</code></td>
+          <td>Só com keyword (<code class="mono">nascido:</code>, <code class="mono">DN:</code>) — <code class="mono">pii-scanner.ts:43</code></td>
+          <td><span class="badge badge-phantom">PHANTOM</span></td>
+        </tr>
+      </table>
+    </div>
+    <p style="font-size:13px; color:var(--muted); margin-top:12px">Correção proposta: "Nome e data de nascimento detectados <em>com contexto/keyword</em>" — não detecção autônoma. Esse é exatamente o gap que o NER do Datavirtus cobre (ver seção Datavirtus).</p>
+  </div>
+</div>
+
+<!-- CASOS DE USO -->
+<div class="card card-green" id="casos-uso" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>22 Casos de uso ATIVOS</h2>
+    <div class="badges">
+      <span class="badge badge-real">REAL</span>
+      <span class="badge badge-blue">14 arquivos · 3 superfícies</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <p style="font-size:13px; color:var(--muted); margin-bottom:16px">Guard Brasil é consumido em <strong>3 superfícies</strong> e <strong>14 arquivos distintos</strong> no monorepo. Os casos abaixo são ATIVO (em uso real verificado).</p>
+
+    <p class="section-title" style="margin-top:0">2.1 — Mascaramento PII antes de LLM externo (R-SEC-002 T0)</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Arquivo (ref)</th><th>Status</th></tr>
+        <tr>
+          <td>Gateway WhatsApp/Telegram mascara mensagem antes do Claude</td>
+          <td><code class="mono">apps/egos-gateway/src/orchestrator.ts:1604</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Produto 852 — "Early Deep Atrian Layer" no chat</td>
+          <td><code class="mono">852/src/app/api/chat/route.ts:74</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Wrapper de versão 852</td>
+          <td><code class="mono">852/src/lib/pii-scanner.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+      </table>
+    </div>
+
+    <p class="section-title">2.2 — Publish gate (R-SEC-005)</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Arquivo (ref)</th><th>Status</th></tr>
+        <tr>
+          <td>Timeline / artigos de sessão</td>
+          <td><code class="mono">scripts/session-end-article.ts:195</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>NotebookLM <code class="mono">source_add</code></td>
+          <td><code class="mono">scripts/notebook-sync-local.ts:332</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Insert de draft avulso</td>
+          <td><code class="mono">scripts/insert-draft.ts:117</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+      </table>
+    </div>
+    <div class="notice notice-green" style="margin-bottom:14px">
+      <span class="notice-icon">✅</span>
+      <div class="notice-body">Cada publish gate roda <code class="mono">detectPII(body, ALL_PII_PATTERNS)</code> <strong>+</strong> <code class="mono">detectPII(body, INFRASTRUCTURE_SECRET_PATTERNS)</code> e <strong>bloqueia</strong> (throw) se houver match.</div>
+    </div>
+
+    <p class="section-title">2.3 — Pre-commit / scan estático (R-SEC-001)</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Arquivo (ref)</th><th>Status</th></tr>
+        <tr>
+          <td>Hook PII no pre-commit (CPF/CNPJ) — 3 profiles</td>
+          <td><code class="mono">.husky/_checks/06-pii-scan.sh</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Scanner hardcoded sensitive (CI + pre-commit)</td>
+          <td><code class="mono">scripts/security/scan-hardcoded-sensitive.ts:237</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Intelink — audit de rotas Neo4j que tocam PII</td>
+          <td><code class="mono">intelink/scripts/pii-mask-path-check.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+      </table>
+    </div>
+
+    <p class="section-title">2.4 — Contexto policial PCMG</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Arquivo (ref)</th><th>Status</th></tr>
+        <tr>
+          <td>Perfil PCMG com 4 padrões, HITL validado</td>
+          <td><code class="mono">packages/guard-brasil/src/registry/pcmg.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span> 12 conf. / 0 rejeições</td>
+        </tr>
+        <tr>
+          <td>Corpus sintético (28 frases, 4 padrões)</td>
+          <td><code class="mono">registry/pcmg-corpus.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>HITL runner interativo (confirma/rejeita matches)</td>
+          <td><code class="mono">registry/hitl-runner.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span> (CLI)</td>
+        </tr>
+      </table>
+    </div>
+
+    <p class="section-title">2.5 — Servidor MCP (agent-native)</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Tool MCP</th><th>O que faz</th><th>Status</th></tr>
+        <tr>
+          <td><code class="mono">guard_inspect</code></td>
+          <td>ATRiAN + PII + masking + evidence chain</td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">guard_scan_pii</code></td>
+          <td>Scan PII isolado</td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">guard_check_safe</code></td>
+          <td>Booleano: é seguro publicar?</td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+      </table>
+    </div>
+    <p style="font-size:12.5px; color:var(--muted); margin-top:6px">Compatível com: Claude Code, Cursor, Windsurf, ChatGPT. Arquivos: <code class="mono">packages/guard-brasil-mcp/src/mcp-server.ts</code> + <code class="mono">apps/api/src/mcp-server.ts</code></p>
+
+    <p class="section-title">2.6 — API REST + micropagamento x402</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Endpoint</th><th>Status</th></tr>
+        <tr>
+          <td><code class="mono">POST /v1/inspect</code> (Bearer auth, telemetria)</td>
+          <td>guard.egos.ia.br</td>
+          <td><span class="badge badge-ver">VERIFICAR HEALTH</span> — endpoint configurado; último status 502</td>
+        </tr>
+        <tr>
+          <td>Canal x402 — micropagamento USDC/Base $0.001/scan</td>
+          <td><code class="mono">channels/guard-brasil.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span> (wired)</td>
+        </tr>
+      </table>
+    </div>
+
+    <p class="section-title">2.7 — Proveniência, evidência, logs</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Arquivo (ref)</th><th>Status</th></tr>
+        <tr>
+          <td>Audit hash de evidência (SHA-256 canonical JSON)</td>
+          <td><code class="mono">lib/provenance.ts</code> (<code class="mono">buildAuditFields</code>)</td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Evidence chain — claims ancorados a tool_call / document / human_verified</td>
+          <td><code class="mono">lib/evidence-chain.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span> (infra)</td>
+        </tr>
+        <tr>
+          <td><code class="mono">secureLog()</code> — mascara objetos antes de console.log</td>
+          <td><code class="mono">central-egos/template/src/lib/guard.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Eval comportamental (9 golden cases, anti-stub INC-008)</td>
+          <td><code class="mono">tests/eval/capabilities/CBC-EGOS-MCP-SECURITY.eval.ts</code></td>
+          <td><span class="badge badge-real">ATIVO</span></td>
+        </tr>
+        <tr>
+          <td>Showcase público</td>
+          <td>egos.ia.br/implementations#guard-brasil</td>
+          <td><span class="badge badge-ver">VERIFICAR LIVE</span> — página configurada</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- ═══════════════════════════════════════════════════════ -->
+<!--              DENTRO vs FORA DO ECOSSISTEMA              -->
+<!-- ═══════════════════════════════════════════════════════ -->
+<div class="section-title" id="secao-ecossistema">Dentro vs Fora do Ecossistema EGOS</div>
+
+<div class="card card-blue" id="standalone" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Standalone — funciona sem infra EGOS</h2>
+    <div class="badges">
+      <span class="badge badge-real">DISPONÍVEL IMEDIATAMENTE</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-green">
+      <span class="notice-icon">📦</span>
+      <div class="notice-body">
+        <strong>Basta instalar <code class="mono">@egosbr/guard-brasil</code>.</strong> O integrador externo recebe estes casos imediatamente, sem precisar de gateway, scripts de publicação ou infra adicional EGOS.
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Capacidade</th><th>API</th><th>Requer</th></tr>
+        <tr>
+          <td>Mascaramento PII em texto</td>
+          <td><code class="mono">maskPII(text)</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>Scan + detecção PII</td>
+          <td><code class="mono">scanForPII(text)</code> / <code class="mono">detectPII(text, patterns)</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>Validação ética (ATRiAN)</td>
+          <td><code class="mono">createAtrianValidator().validate(text)</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>Evidence chain local</td>
+          <td><code class="mono">createEvidenceChain()</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>Facade completa (todas as camadas)</td>
+          <td><code class="mono">GuardBrasil.create().inspect(text)</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>MCP tools (guard_inspect, guard_scan_pii, guard_check_safe)</td>
+          <td>servidor MCP local</td>
+          <td>Node/Bun + pacote MCP</td>
+        </tr>
+        <tr>
+          <td>Perfil PCMG (padrões BO/IPL/REDS/TC)</td>
+          <td><code class="mono">import { pcmgProfile } from '@egosbr/guard-brasil/registry'</code></td>
+          <td>só o pacote npm</td>
+        </tr>
+        <tr>
+          <td>HITL runner CLI</td>
+          <td><code class="mono">bun run hitl-runner.ts</code></td>
+          <td>Bun + pacote</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<div class="card card-navy" id="ecossistema" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Requer infra EGOS — prova de uso real, não features empacotadas</h2>
+    <div class="badges">
+      <span class="badge badge-concept">INTERNO</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-blue">
+      <span class="notice-icon">ℹ</span>
+      <div class="notice-body">
+        Estes casos existem no monorepo e <strong>provam que o Guard Brasil funciona em produção</strong>, mas o integrador externo não recebe esses fluxos ao instalar o pacote npm — eles dependem de gateway, scripts de sessão, ou infra adicional do ecossistema EGOS.
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Caso</th><th>Depende de</th><th>Significado para avaliador externo</th></tr>
+        <tr>
+          <td>Publish gate (timeline, NotebookLM, drafts)</td>
+          <td>scripts de sessão EGOS</td>
+          <td>Prova que o padrão de uso é real; não é API empacotada</td>
+        </tr>
+        <tr>
+          <td>Mascaramento no gateway WhatsApp/Telegram</td>
+          <td><code class="mono">apps/egos-gateway</code></td>
+          <td>Arquitetura de referência para integração de canal</td>
+        </tr>
+        <tr>
+          <td>x402 micropagamento USDC/Base</td>
+          <td>gateway + x402 channel</td>
+          <td>Modelo de monetização agent-to-agent</td>
+        </tr>
+        <tr>
+          <td>API REST <code class="mono">POST /v1/inspect</code></td>
+          <td>VPS + apps/api</td>
+          <td>Endpoint comercial — verificar health antes de citar (último status 502)</td>
+        </tr>
+        <tr>
+          <td>secureLog() no storefront multi-tenant</td>
+          <td>central-egos/template</td>
+          <td>Padrão de segurança para logs em produto SaaS</td>
+        </tr>
+        <tr>
+          <td>Pre-commit hooks PII</td>
+          <td>.husky + scripts EGOS</td>
+          <td>Gate de integridade do repositório</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- ═══════════════════════════════════════════════════════ -->
+<!--                   COMPLIANCE MAP                        -->
+<!-- ═══════════════════════════════════════════════════════ -->
+<div class="section-title" id="secao-compliance">Compliance Map</div>
+
+<div class="card card-blue" id="compliance" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Norma → Artigo → Atendimento Guard Brasil</h2>
+    <div class="badges">
+      <span class="badge badge-blue">Marco regulatório em vigor</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-blue">
+      <span class="notice-icon">ℹ</span>
+      <div class="notice-body">
+        <strong>Normas em vigor (2026-06-10):</strong> LGPD (Lei 13.709/2018) — universal; CNJ Resolução 615/2025 — Poder Judiciário; Portaria MJSP 961/2025 — PF, PRF, PPF, FNSP, SENASP, SENAPEN + órgãos estaduais via fundo. PL 2338/2023 (marco legal IA) — em tramitação, ainda não vigente.
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Norma</th><th>Artigo</th><th>Exigência</th><th>Guard Brasil</th><th>Status</th></tr>
+        <tr>
+          <td>LGPD</td><td>Art. 5</td>
+          <td>Define dado pessoal</td>
+          <td>16 padrões core detectam/mascaram</td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td>LGPD</td><td>Art. 11</td>
+          <td>Dado de saúde = sensível</td>
+          <td><code class="mono">HEALTH_CONDITION_PATTERN</code></td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td>LGPD</td><td>Art. 46</td>
+          <td>Medidas técnicas de segurança</td>
+          <td>Mascaramento antes de inferência; local-first</td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td>CNJ 615</td><td>Art. 13</td>
+          <td>Alto risco → logs auditáveis</td>
+          <td>Evidence chain (audit hash + sessionId)</td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td>CNJ 615</td><td>Art. 13</td>
+          <td>Alto risco → supervisão humana</td>
+          <td>HITL loop (arquitetura completa)</td>
+          <td><span class="badge badge-real">REAL</span> <span class="badge badge-concept">UI pendente</span></td>
+        </tr>
+        <tr>
+          <td>CNJ 615</td><td>Art. 9</td>
+          <td>Gestão de risco</td>
+          <td>Framework documentado (não é função do pacote)</td>
+          <td><span class="badge badge-doc">DOCUMENTADO</span></td>
+        </tr>
+        <tr>
+          <td>MJSP 961</td><td>Art. 10</td>
+          <td>IA proporcional + HITL obrigatório</td>
+          <td>HITL no ciclo de confiança</td>
+          <td><span class="badge badge-real">REAL</span></td>
+        </tr>
+        <tr>
+          <td>MJSP 961</td><td>Art. 13</td>
+          <td>Logs (nome+CPF+IP+data+operação)</td>
+          <td>Evidence chain cobre sessionId+hash+timestamp; CPF/IP do operador = responsabilidade do integrador</td>
+          <td><span class="badge badge-parcial">PARCIAL</span></td>
+        </tr>
+        <tr>
+          <td>MJSP 961</td><td>Art. 11</td>
+          <td>Biometria à distância vedada</td>
+          <td>Fora de escopo (foco é texto)</td>
+          <td><span class="badge badge-phantom">N/A</span></td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<div class="card card-amber" id="tese-local" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Tese: "Local ≠ Privado por padrão"</h2>
+    <div class="badges">
+      <span class="badge badge-doc">DOCUMENTADO</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-amber">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        <strong>Fonte: <code class="mono">BR_AI_REGULATORY_FRAMEWORK.md:119</code></strong><br>
+        "Modelo local remove o risco de dado ir para LLM de terceiro. Mas conformidade exige mais: base legal, log auditável, autorização judicial para dados sigilosos. O modelo local é condição necessária, não suficiente."
+      </div>
+    </div>
+    <p style="font-size:13px; color:var(--muted); margin-bottom:14px">Pipeline proposto (CONCEPT) para o judiciário:</p>
+    <div class="flow">
+      <span class="flow-node fn-gray">Documento bruto</span>
+      <span class="flow-arrow">→</span>
+      <span class="flow-node fn-green">Guard Brasil mascara PII</span>
+      <span class="flow-arrow">→</span>
+      <span class="flow-node fn-blue">Sinapses / LLM local processa anonimizado</span>
+      <span class="flow-arrow">→</span>
+      <span class="flow-node fn-amber">Log auditado + revisão HITL</span>
+    </div>
+    <div class="notice notice-amber" style="margin-top:14px">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        <strong>Este pipeline é CONCEPT:</strong> a etapa "LLM local processa documento anonimizado" requer que o Guard Brasil forneça desanonimização reversível (<code class="mono">GUARD-DEANON-001</code>) e suporte docx/pdf (<code class="mono">GUARD-DOCX-001</code>, <code class="mono">GUARD-PDF-001</code>) — ambos abertos.
+      </div>
+    </div>
+  </div>
+</div>
+
+<div class="card card-amber" id="pcmg-status" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Status PCMG × Portaria MJSP 961</h2>
+    <div class="badges">
+      <span class="badge badge-hipotese">HIPÓTESE</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-amber">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        <strong>CRÍTICO — leia antes de citar em qualquer material:</strong><br>
+        A vinculação PCMG ↔ Portaria MJSP 961 é classificada como <strong>HIPÓTESE</strong> — não como fato. Se a PCMG usar FNSP/FPN para projetos tech, a Portaria 961 é vinculante; se não usar, é parâmetro interpretativo. Isso não foi verificado juridicamente. <strong>LGPD é vinculante em qualquer caso.</strong>
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr>
+          <th>Afirmação</th><th>Classificação</th><th>O que sabemos</th>
+        </tr>
+        <tr>
+          <td>"PCMG deve seguir MJSP 961"</td>
+          <td><span class="badge badge-hipotese">HIPÓTESE</span></td>
+          <td>Depende de se PCMG usa FNSP/FPN — não verificado</td>
+        </tr>
+        <tr>
+          <td>"LGPD se aplica à PCMG"</td>
+          <td><span class="badge badge-real">REAL</span></td>
+          <td>Universal — aplica-se a todos os agentes de tratamento</td>
+        </tr>
+        <tr>
+          <td>"CNJ 615 se aplica ao judiciário MG"</td>
+          <td><span class="badge badge-real">REAL</span></td>
+          <td>Vincula todo o Poder Judiciário brasileiro</td>
+        </tr>
+        <tr>
+          <td>"Guard Brasil cobre biometria MJSP 961 art.11"</td>
+          <td><span class="badge badge-phantom">N/A</span></td>
+          <td>Fora de escopo — Guard Brasil foca em texto</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- ═══════════════════════════════════════════════════════ -->
+<!--                  ROADMAP HONESTO                        -->
+<!-- ═══════════════════════════════════════════════════════ -->
+<div class="section-title" id="secao-roadmap">Roadmap Honesto — Gaps e Tasks</div>
+
+<div class="card card-red" id="gaps" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Gaps críticos — o que Guard Brasil NÃO faz hoje</h2>
+    <div class="badges">
+      <span class="badge badge-roadmap">ROADMAP</span>
+      <span class="badge badge-gap">5 gaps P1/P2</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-red">
+      <span class="notice-icon">🚨</span>
+      <div class="notice-body">
+        <strong>Tarefa prática crítica que Guard Brasil NÃO executa hoje:</strong> "abrir .docx → anonimizar → LLM → desanonimizar → restaurar documento final". Para essa tarefa completa, o Datavirtus funciona; o Guard Brasil ainda não. A vantagem atual do Guard Brasil é <strong>arquitetural</strong> (pipeline, HITL, perfis, compliance map), não de paridade de uso standalone.
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🔴</div>
+      <div class="road-body">
+        <h4>GUARD-DEANON-001 — Anonimização reversível <span class="badge badge-roadmap">P1</span></h4>
+        <p>Datavirtus tem (<code>desanonimizador_gui.py</code>, 501 LOC); Guard Brasil só mascara (irreversível). Para o investigador restaurar dados no documento final após processar com LLM, a desanonimização é indispensável. Diferencial EGOS proposto: placeholder com category — <code>[REDS_0001]</code>, <code>[IPL_0001]</code>, <code>[BO_0001]</code>, <code>[TC_0001]</code>, <code>[MASP_0001]</code> — não só CPF/CNPJ/NOME genérico.</p>
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🔴</div>
+      <div class="road-body">
+        <h4>GUARD-NER-001 — Detecção de nomes (NER por heurística) <span class="badge badge-roadmap">P1</span></h4>
+        <p>Datavirtus tem 10 regras heurísticas (A-J) com listas PRESERVE/CARGOS/NOMES_BANCOS. Guard Brasil só detecta nomes com prefixo de keyword (<code>delegado:</code>, <code>nome:</code>). Resolve também o PHANTOM do README. Implementação proposta: portar Regras A-J para TypeScript adaptando para contexto policial MG (preservar "DELEGACIA DE HOMICÍDIOS", "CORPO DE BOMBEIROS", "MINISTÉRIO PÚBLICO").</p>
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🔴</div>
+      <div class="road-body">
+        <h4>GUARD-SCANNER-001 — Fix <code>deduplicateFindings</code> <span class="badge badge-roadmap">P1</span></h4>
+        <p>Bug ativo: hoje mantém o <em>primeiro</em> match por posição, então <code>reds</code> (built-in) vence <code>pcmg:reds_complemento</code> (custom) → campo delegacia se perde. 3 falsos negativos identificados no corpus sintético. Correção: custom &gt; built-in quando começam na mesma posição.</p>
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🟠</div>
+      <div class="road-body">
+        <h4>GUARD-DOCX-001 — Suporte <code>.docx</code> <span class="badge badge-roadmap">P2</span></h4>
+        <p>Datavirtus usa <code>python-docx</code> e resolve o problema crítico de <em>concatenação de runs</em>: Word divide CPF entre múltiplos runs por formatação. Sem concatenação, o padrão regex não captura o CPF. Solução proposta: <code>mammoth</code> ou <code>docx</code> npm + mesma estratégia de concatenar runs antes de anonimizar, redistribuir depois.</p>
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🟠</div>
+      <div class="road-body">
+        <h4>GUARD-PDF-001 — Suporte <code>.pdf</code> <span class="badge badge-roadmap">P2</span></h4>
+        <p>Datavirtus usa <code>pymupdf</code> para redaction por linha. Guard Brasil: texto puro apenas. Solução proposta: <code>pdf-parse</code> (extração) + <code>pdf-lib</code> (reconstrução).</p>
+      </div>
+    </div>
+
+    <div class="road-item">
+      <div class="road-icon">🟡</div>
+      <div class="road-body">
+        <h4>Outros gaps P2/P3 <span class="badge badge-roadmap">P2</span> <span class="badge badge-roadmap">P3</span></h4>
+        <p>
+          <code>GUARD-PRESERVE-001</code> — lista PRESERVE policial MG (órgãos, cargos, topônimos) ·
+          <code>GUARD-HITL-004</code> — perfis institucionais TJMG, SES-MG, DETRAN-MG pendentes ·
+          <code>README-FIX-001</code> — corrigir PHANTOM "Nome"/"Data nasc." no README (P3)
+        </p>
+      </div>
+    </div>
+  </div>
+</div>
+
+<div class="card card-amber" id="tasks" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Tasks abertas (PARTE 7 — completa)</h2>
+    <div class="badges"><span class="badge badge-roadmap">8 tasks</span></div>
+  </div>
+  <div class="card-body">
+    <div class="table-wrap">
+      <table>
+        <tr><th>ID</th><th>Descrição</th><th>Prioridade</th><th>Status</th></tr>
+        <tr>
+          <td><code class="mono">GUARD-DEANON-001</code></td>
+          <td>Anonimização reversível (<code>maskReversible</code> + <code>unmask</code> + <code>AnonymizationMap</code>)</td>
+          <td>P1</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-NER-001</code></td>
+          <td>NER de nomes (Regras A-J → TS, contexto policial MG)</td>
+          <td>P1</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-SCANNER-001</code></td>
+          <td>Fix <code>deduplicateFindings</code> (custom &gt; built-in por posição)</td>
+          <td>P1</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-DOCX-001</code></td>
+          <td>Suporte <code>.docx</code> (concatenar runs)</td>
+          <td>P2</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-PDF-001</code></td>
+          <td>Suporte <code>.pdf</code> (extração + reconstrução)</td>
+          <td>P2</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-PRESERVE-001</code></td>
+          <td>Lista PRESERVE policial MG (órgãos, cargos, topônimos)</td>
+          <td>P2</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">GUARD-HITL-004</code></td>
+          <td>Perfis institucionais TJMG / SES-MG / DETRAN-MG</td>
+          <td>P2</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+        <tr>
+          <td><code class="mono">README-FIX-001</code></td>
+          <td>Corrigir PHANTOM "Nome"/"Data nasc." (detecção é keyword-based)</td>
+          <td>P3</td>
+          <td><span class="badge badge-gap">ABERTO</span></td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<!-- ═══════════════════════════════════════════════════════ -->
+<!--              CONTEXTO DE MERCADO — DATAVIRTUS           -->
+<!-- ═══════════════════════════════════════════════════════ -->
+<div class="section-title" id="secao-datavirtus">Contexto de Mercado — Datavirtus</div>
+
+<div class="card card-purple" id="datavirtus-o-que" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>O que é a Datavirtus</h2>
+    <div class="badges">
+      <span class="badge badge-navy">ANÁLISE COMPETITIVA</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <p style="font-size:13.5px; line-height:1.7; margin-bottom:16px">Plataforma de <strong>formação para Agentes da Lei</strong> (datavirtus.themembers.com.br) — modelo B2C/assinatura. O anonimizador é <em>material didático</em> entregue dentro dos cursos, não um produto standalone. O código é distribuído como parte do conteúdo educacional, não como biblioteca empacotada.</p>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Curso</th><th>Relevância para EGOS</th></tr>
+        <tr><td>Pós em Investigação Financeira (PGIF 2026)</td><td>DIRETA — onde o anonimizador é ensinado</td></tr>
+        <tr><td><strong>Pós em IA para Agentes da Lei</strong></td><td>ALTA — concorrente direto de audiência</td></tr>
+        <tr><td>ChatGPT para Policiais e Agentes da Lei</td><td>ALTA — mesma audiência, abordagem diferente</td></tr>
+        <tr><td>IA local com Gemma 4</td><td>DIRETA — paralelo ao curso EGOS</td></tr>
+        <tr><td>NexVirtus PRO — Investigação Financeira</td><td>DIRETA — sobreposição de conteúdo</td></tr>
+        <tr><td>Análise de Dados com Power BI</td><td>INDIRETA</td></tr>
+      </table>
+    </div>
+    <p style="font-size:12px; color:var(--muted); margin-top:12px">Fonte: screenshot da plataforma datavirtus.themembers.com.br — DATAVIRTUS.pdf (2026-06-02). Código verificado: <code class="mono">anonimizador_v2_gui.py</code> (1029 LOC) + <code class="mono">desanonimizador_gui.py</code> (501 LOC) + <code class="mono">LEIA-ME.txt</code>.</p>
+  </div>
+</div>
+
+<div class="card card-purple" id="comparativo" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Comparativo equilibrado — Guard Brasil vs Datavirtus</h2>
+    <div class="badges">
+      <span class="badge badge-navy">VERIFICADO</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-blue">
+      <span class="notice-icon">⚖</span>
+      <div class="notice-body">
+        <strong>Este comparativo mostra as vantagens de ambos os lados</strong>, sem esconder gaps. As vantagens do Datavirtus são reais e verificadas no código-fonte. A análise honesta é a única que tem valor estratégico.
+      </div>
+    </div>
+    <div class="table-wrap">
+      <table>
+        <tr><th>Dimensão</th><th>Datavirtus</th><th>EGOS / Guard Brasil</th></tr>
+        <tr>
+          <td><strong>Modelo de negócio</strong></td>
+          <td>Plataforma de cursos B2C / assinatura</td>
+          <td>Framework open-source + governança + MCP</td>
+        </tr>
+        <tr>
+          <td><strong>Tese de IA</strong></td>
+          <td>Ensina a usar ChatGPT/LLMs <em>externos</em></td>
+          <td>IA <em>local</em> + governança + HITL auditável</td>
+        </tr>
+        <tr>
+          <td><strong>Privacidade</strong></td>
+          <td>Anonimizar é gambito para usar LLM externo</td>
+          <td>Dado nunca sai da máquina <em>por design</em></td>
+        </tr>
+        <tr>
+          <td><strong>LGPD</strong></td>
+          <td>Usuário responsável por anonimizar antes</td>
+          <td>Enforcement automático no pipeline</td>
+        </tr>
+        <tr>
+          <td><strong>Especificidade</strong></td>
+          <td>COAF, RIF, investigação financeira</td>
+          <td>PCMG (REDS, MASP, BO, IPL, TC) + judiciário</td>
+        </tr>
+        <tr>
+          <td><strong>Profundidade de detecção</strong></td>
+          <td>Regex + heurística (manual, hardcoded)</td>
+          <td>HITL (aprendizado contínuo) + perfis plugáveis</td>
+        </tr>
+        <tr>
+          <td><strong>Reversibilidade</strong></td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ Obrigatória (anon→LLM→deanon)</td>
+          <td style="color:var(--danger-red)"><span class="badge badge-gap">GAP</span> só mascaramento — GUARD-DEANON-001</td>
+        </tr>
+        <tr>
+          <td><strong>Detecção de nomes</strong></td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ Regras A-J (10 heurísticas)</td>
+          <td style="color:var(--danger-red)"><span class="badge badge-gap">GAP</span> só com keyword — GUARD-NER-001</td>
+        </tr>
+        <tr>
+          <td><strong>Formatos de arquivo</strong></td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ docx + pdf (python-docx, pymupdf)</td>
+          <td style="color:var(--danger-red)"><span class="badge badge-gap">GAP</span> texto puro apenas — GUARD-DOCX-001 / GUARD-PDF-001</td>
+        </tr>
+        <tr>
+          <td><strong>Auditabilidade</strong></td>
+          <td>Log manual (JSON salvo localmente)</td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ SHA-256 canonical, sessionId, evidence chain</td>
+        </tr>
+        <tr>
+          <td><strong>Conformidade regulatória</strong></td>
+          <td>Usuário decide; sem compliance automático</td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ Mapa norma→artigo→atendimento</td>
+        </tr>
+        <tr>
+          <td><strong>Stack</strong></td>
+          <td>Python + tkinter (.exe Windows)</td>
+          <td>TypeScript + Bun (npm / Docker / MCP)</td>
+        </tr>
+        <tr>
+          <td><strong>HITL</strong></td>
+          <td>Interação manual (GUI)</td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ CLI HITL runner + corpus validado</td>
+        </tr>
+        <tr>
+          <td><strong>API / integração</strong></td>
+          <td>Sem API (executável GUI)</td>
+          <td style="color:var(--evidence-green); font-weight:600">✅ npm + API REST + MCP server</td>
+        </tr>
+      </table>
+    </div>
+  </div>
+</div>
+
+<div class="card card-purple" id="tese-diferenciacao" style="scroll-margin-top:72px">
+  <div class="card-header">
+    <h2>Tese de diferenciação — com qualificador temporal obrigatório</h2>
+    <div class="badges">
+      <span class="badge badge-hipotese">QUALIFICADA</span>
+    </div>
+  </div>
+  <div class="card-body">
+    <div class="notice notice-amber">
+      <span class="notice-icon">⚠</span>
+      <div class="notice-body">
+        <strong>Leia o qualificador temporal antes de citar esta tese em qualquer contexto:</strong><br>
+        Esta tese só se concretiza plenamente quando <code class="mono">GUARD-DEANON-001</code> (desanonimização) e <code class="mono">GUARD-NER-001</code> (NER de nomes) + suporte docx/pdf estiverem implementados. <strong>Hoje, para a tarefa prática "abrir .docx → anonimizar → LLM → restaurar", o Datavirtus funciona e o Guard Brasil ainda não.</strong>
+      </div>
+    </div>
+    <p style="font-size:13.5px; line-height:1.8; margin-bottom:16px">O anonimizador Datavirtus é um <strong>workaround</strong> para usar ChatGPT com dado sensível. Guard Brasil aponta para uma <strong>arquitetura nativa</strong> que remove a necessidade do workaround — mais robusto em ambientes com restrição de rede, casos LGPD-sensíveis, e auditabilidade rastreável.</p>
+
+    <p style="font-size:13px; color:var(--muted); margin-bottom:12px"><strong>Onde a vantagem atual do Guard Brasil é real:</strong></p>
+    <div class="grid-2">
+      <div class="stat-card">
+        <div class="stat-label">Pipeline de governança</div>
+        <div class="stat-val" style="font-size:18px; color:var(--blue)">4 camadas</div>
+        <div class="stat-sub">PII → ATRiAN → PublicGuard → EvidenceChain — orquestradas em façade única</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Conformidade automática</div>
+        <div class="stat-val" style="font-size:18px; color:var(--blue)">Mapa LGPD/CNJ/MJSP</div>
+        <div class="stat-sub">Compliance artigo por artigo verificado — não transfere responsabilidade para o usuário</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Integração programática</div>
+        <div class="stat-val" style="font-size:18px; color:var(--blue)">npm + API + MCP</div>
+        <div class="stat-sub">Datavirtus é executável GUI sem API — Guard Brasil é biblioteca integrável</div>
+      </div>
+      <div class="stat-card">
+        <div class="stat-label">Perfis institucionais</div>
+        <div class="stat-val" style="font-size:18px; color:var(--blue)">PCMG validado</div>
+        <div class="stat-sub">12 confirmações HITL, 0 rejeições — Datavirtus foca em investigação financeira</div>
+      </div>
+    </div>
+
+    <div class="notice notice-red" style="margin-top:14px">
+      <span class="notice-icon">🚫</span>
+      <div class="notice-body">
+        <strong>Banido neste material e em qualquer uso externo:</strong> "único no Brasil", "primeiro do Brasil", "100% LGPD compliant", "garantido", "infalível", "solução nativa presente". Use em vez: "arquitetura validada com teste", "rastreável", "auditável", "conformidade verificada artigo por artigo".
+      </div>
+    </div>
+  </div>
+</div>
+
+<!-- ─────────────── RODAPÉ (anchor) ─────────────── -->
+<div id="rodape" style="scroll-margin-top:72px; height:8px"></div>
+
+</main>
+</div><!-- /layout -->
+
+<!-- ████████████████████ FOOTER ████████████████████ -->
+<footer class="page-footer">
+  <div class="footer-tagline">Governance is Infrastructure</div>
+  <p>
+    Guard Brasil Analysis · versão 1.0 · 2026-06-10<br>
+    Fonte: <code style="font-family:monospace; font-size:11px">docs/guard-brasil/DATAVIRTUS_ANALYSIS.md</code> ·
+    Código verificado: <code style="font-family:monospace; font-size:11px">packages/guard-brasil/</code> v0.2.3 (46 testes · 3 investigações Explore cruzadas)<br>
+    Assinatura visual: <code style="font-family:monospace; font-size:11px">docs/governance/VISUAL_IDENTITY.md v1.1.0</code><br>
+    <strong>Material de referência interna de produto EGOS · não é proposta comercial · não divulgar externamente sem revisão</strong>
+  </p>
+  <p style="margin-top:10px; font-size:11px; opacity:0.6">
+    EGOS Framework · guard-brasil · EGOS Black #0A0E27 · Evidence Green #10B981 · Warning Amber #F59E0B · Danger Red #EF4444
+  </p>
+</footer>
+
+<script>
+// ── Sidebar active link highlight on scroll ──
+(function() {
+  const links = document.querySelectorAll('.sidebar-link');
+  const sections = [];
+  links.forEach(link => {
+    const href = link.getAttribute('href');
+    if (href && href.startsWith('#')) {
+      const el = document.querySelector(href);
+      if (el) sections.push({ el, link });
+    }
+  });
+  function onScroll() {
+    const scrollY = window.scrollY + 90;
+    let active = null;
+    sections.forEach(({ el, link }) => {
+      if (el.offsetTop <= scrollY) active = link;
+    });
+    links.forEach(l => l.classList.remove('active'));
+    if (active) active.classList.add('active');
+  }
+  window.addEventListener('scroll', onScroll, { passive: true });
+  onScroll();
+})();
+
+// ── Smooth scroll for sidebar links ──
+document.querySelectorAll('.sidebar-link').forEach(link => {
+  link.addEventListener('click', function(e) {
+    const href = this.getAttribute('href');
+    if (href && href.startsWith('#')) {
+      e.preventDefault();
+      const target = document.querySelector(href);
+      if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
+    }
+  });
+});
+</script>
+
+</body>
+</html>
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index ee90738b..884a252a 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T16:22:45.399Z",
+  "verified_at": "2026-06-10T17:03:19.111Z",
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
+      "current_value": "1412",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -103,7 +103,7 @@
       "description": "Total completed tasks in TASKS.md",
       "status": "ok",
       "last_value": "0",
-      "current_value": "0\n0",
+      "current_value": "2",
       "tolerance": "min:0",
       "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
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
index edb5e39e..8acaf165 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -374,5 +374,37 @@
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
   }
 ]
diff --git a/packages/guard-brasil/src/lib/pii-scanner.ts b/packages/guard-brasil/src/lib/pii-scanner.ts
index 9b341def..7033234d 100644
--- a/packages/guard-brasil/src/lib/pii-scanner.ts
+++ b/packages/guard-brasil/src/lib/pii-scanner.ts
@@ -85,8 +85,11 @@ export function getPIISummary(findings: PIIFinding[]): string {
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
diff --git a/scripts/banda.ts b/scripts/banda.ts
index 36525b0d..727d7485 100644
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
@@ -40,10 +41,41 @@ const MODE = (ARGS.find((_, i) => ARGS[i - 1] === '--mode') ?? 'default') as
   'default' | 'economico' | 'council';
 
 if (!QUESTION && !DRY) {
-  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--mode default|economico|council] [--verbose] [--dry]');
+  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--context-file <path>] [--mode default|economico|council] [--verbose] [--dry]');
   process.exit(1);
 }
 
+// ─── METAPROMPT GATE (METAPROMPT-GATE-001, corte Enio 2026-06-10) ─────────────
+// A Banda só aceita comando que cumpra requisitos mínimos (MP-R1 contexto +
+// MP-R2 objetivo verificável). Fail-closed: recusa apontando onde as regras
+// vivem. SSOT: docs/governance/METAPROMPT_STANDARD.md
+const CONTEXT_FILE = ARGS.find((_, i) => ARGS[i - 1] === '--context-file') ?? '';
+const CONTEXT_FROM_FILE = CONTEXT_FILE && existsSync(CONTEXT_FILE)
+  ? readFileSync(CONTEXT_FILE, 'utf-8')
+  : '';
+const EFFECTIVE_CONTEXT = CONTEXT_FROM_FILE || CONTEXT_ARG;
+const MP_GATE_OVERRIDE = process.env.EGOS_MP_GATE_OVERRIDE === '1';
+
+if (!DRY && !MP_GATE_OVERRIDE) {
+  const missing: string[] = [];
+  if (EFFECTIVE_CONTEXT.trim().length < 200) {
+    missing.push('MP-R1 CONTEXTO (--context/--context-file com ≥200 chars: paths, SHAs, estado REAL/CONCEPT/PHANTOM)');
+  }
+  if (QUESTION.trim().length < 40) {
+    missing.push('MP-R2 OBJETIVO (--question com pergunta + critério de aceite, ≥40 chars)');
+  }
+  if (missing.length > 0) {
+    console.error('⛔ METAPROMPT INCOMPLETO — Banda não executada.');
+    for (const m of missing) console.error(`   Falta: ${m}`);
+    console.error('   Regras: docs/governance/METAPROMPT_STANDARD.md (EGOS kernel)');
+    console.error('   Override consciente (logado): EGOS_MP_GATE_OVERRIDE=1');
+    process.exit(2);
+  }
+}
+if (MP_GATE_OVERRIDE && !DRY) {
+  console.error('🟡 [banda] EGOS_MP_GATE_OVERRIDE=1 — gate de metaprompt pulado (humano assume).');
+}
+
 // Load env
 function loadEnv(path: string): Record<string, string> {
   if (!existsSync(path)) return {};
@@ -55,7 +87,12 @@ function loadEnv(path: string): Record<string, string> {
   return env;
 }
 
-const ENV = { ...loadEnv('/home/enio/egos/.env'), ...process.env } as Record<string, string>;
+// process.env vence, EXCETO quando a var existe vazia (shell herda placeholder
+// vazio e sombreava o .env — bug pego 2026-06-10 na missão Odysseus)
+const PROC_ENV = Object.fromEntries(
+  Object.entries(process.env).filter(([, v]) => v !== undefined && v !== ''),
+) as Record<string, string>;
+const ENV = { ...loadEnv('/home/enio/egos/.env'), ...PROC_ENV } as Record<string, string>;
 const OPENROUTER_KEY = ENV.OPENROUTER_API_KEY ?? '';
 const ANTHROPIC_KEY = ENV.ANTHROPIC_API_KEY ?? '';
 
@@ -82,10 +119,10 @@ const MODELS: Record<string, ModelMap> = {
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
 
@@ -227,12 +264,45 @@ decisao:
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
@@ -295,12 +365,13 @@ async function main() {
   console.log(`[banda] Models: critic=${models.critic.split('/').pop()} | supporter=${models.supporter.split('/').pop()} | questioner=${models.questioner.split('/').pop()} | maestro=${models.maestro.split('/').pop()}`);
   console.log('');
 
-  let context = CONTEXT_ARG;
-  // Se context começa com @, ler arquivo
+  let context = EFFECTIVE_CONTEXT;
+  // Se context começa com @, ler arquivo (legado; preferir --context-file)
   if (context.startsWith('@')) {
     const path = context.slice(1);
     context = existsSync(path) ? readFileSync(path, 'utf-8').slice(0, 10000) : '';
   }
+  context = context.slice(0, 12000);
 
   // Phase 1 — Crítico
   process.stdout.write('[1/4] Crítico Extremo... ');

exec
/bin/bash -lc "sed -n '1,460p' scripts/banda.ts | nl -ba | sed -n '1,430p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * OPUS-F4-001 — Banda Cognitiva executor (hierárquico sequencial)
     4	 *
     5	 * Protocolo (opção C aprovada):
     6	 *   Crítico Extremo → Apoiador Máximo → Questionador → Maestro
     7	 * Cada papel vê o output do anterior. Output final = síntese do Maestro.
     8	 *
     9	 * SSOT: docs/opus-mode/BANDA_COGNITIVA.md
    10	 * Related: docs/opus-mode/OPUS_MODE_V1.md §4
    11	 *
    12	 * Usage:
    13	 *   bun scripts/banda.ts --question "Devemos fazer X ou Y?" [--context "..."] [--mode economico|default|council]
    14	 *   bun scripts/banda.ts --dry      # testa sem chamar LLMs
    15	 *   bun scripts/banda.ts --verbose  # mostra os 4 outputs (default: só Maestro)
    16	 *
    17	 * Modes:
    18	 *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
    19	 *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
    20	 *   council    — GPT via Codex CLI + Claude via Claude CLI (subscriptions) +
    21	 *                Gemini 3.1 Pro via OpenRouter (~$0.03/council medido 2026-06-10)
    22	 *
    23	 * Output:
    24	 *   - Console: síntese do Maestro (ou verbose com todos)
    25	 *   - Arquivo: docs/banda/YYYY-MM-DD-<slug>.yaml (trace completo)
    26	 */
    27	
    28	export {};
    29	
    30	import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
    31	import { join } from 'node:path';
    32	
    33	// ─── Config ────────────────────────────────────────────────────────────────────
    34	
    35	const ARGS = process.argv.slice(2);
    36	const DRY = ARGS.includes('--dry');
    37	const VERBOSE = ARGS.includes('--verbose');
    38	const QUESTION = ARGS.find((_, i) => ARGS[i - 1] === '--question') ?? '';
    39	const CONTEXT_ARG = ARGS.find((_, i) => ARGS[i - 1] === '--context') ?? '';
    40	const MODE = (ARGS.find((_, i) => ARGS[i - 1] === '--mode') ?? 'default') as
    41	  'default' | 'economico' | 'council';
    42	
    43	if (!QUESTION && !DRY) {
    44	  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--context-file <path>] [--mode default|economico|council] [--verbose] [--dry]');
    45	  process.exit(1);
    46	}
    47	
    48	// ─── METAPROMPT GATE (METAPROMPT-GATE-001, corte Enio 2026-06-10) ─────────────
    49	// A Banda só aceita comando que cumpra requisitos mínimos (MP-R1 contexto +
    50	// MP-R2 objetivo verificável). Fail-closed: recusa apontando onde as regras
    51	// vivem. SSOT: docs/governance/METAPROMPT_STANDARD.md
    52	const CONTEXT_FILE = ARGS.find((_, i) => ARGS[i - 1] === '--context-file') ?? '';
    53	const CONTEXT_FROM_FILE = CONTEXT_FILE && existsSync(CONTEXT_FILE)
    54	  ? readFileSync(CONTEXT_FILE, 'utf-8')
    55	  : '';
    56	const EFFECTIVE_CONTEXT = CONTEXT_FROM_FILE || CONTEXT_ARG;
    57	const MP_GATE_OVERRIDE = process.env.EGOS_MP_GATE_OVERRIDE === '1';
    58	
    59	if (!DRY && !MP_GATE_OVERRIDE) {
    60	  const missing: string[] = [];
    61	  if (EFFECTIVE_CONTEXT.trim().length < 200) {
    62	    missing.push('MP-R1 CONTEXTO (--context/--context-file com ≥200 chars: paths, SHAs, estado REAL/CONCEPT/PHANTOM)');
    63	  }
    64	  if (QUESTION.trim().length < 40) {
    65	    missing.push('MP-R2 OBJETIVO (--question com pergunta + critério de aceite, ≥40 chars)');
    66	  }
    67	  if (missing.length > 0) {
    68	    console.error('⛔ METAPROMPT INCOMPLETO — Banda não executada.');
    69	    for (const m of missing) console.error(`   Falta: ${m}`);
    70	    console.error('   Regras: docs/governance/METAPROMPT_STANDARD.md (EGOS kernel)');
    71	    console.error('   Override consciente (logado): EGOS_MP_GATE_OVERRIDE=1');
    72	    process.exit(2);
    73	  }
    74	}
    75	if (MP_GATE_OVERRIDE && !DRY) {
    76	  console.error('🟡 [banda] EGOS_MP_GATE_OVERRIDE=1 — gate de metaprompt pulado (humano assume).');
    77	}
    78	
    79	// Load env
    80	function loadEnv(path: string): Record<string, string> {
    81	  if (!existsSync(path)) return {};
    82	  const env: Record<string, string> = {};
    83	  for (const line of readFileSync(path, 'utf-8').split('\n')) {
    84	    const m = line.match(/^(?:export\s+)?([A-Z_]+)=(.*)$/);
    85	    if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, '');
    86	  }
    87	  return env;
    88	}
    89	
    90	// process.env vence, EXCETO quando a var existe vazia (shell herda placeholder
    91	// vazio e sombreava o .env — bug pego 2026-06-10 na missão Odysseus)
    92	const PROC_ENV = Object.fromEntries(
    93	  Object.entries(process.env).filter(([, v]) => v !== undefined && v !== ''),
    94	) as Record<string, string>;
    95	const ENV = { ...loadEnv('/home/enio/egos/.env'), ...PROC_ENV } as Record<string, string>;
    96	const OPENROUTER_KEY = ENV.OPENROUTER_API_KEY ?? '';
    97	const ANTHROPIC_KEY = ENV.ANTHROPIC_API_KEY ?? '';
    98	
    99	if (!DRY && !OPENROUTER_KEY) {
   100	  console.error('[banda] OPENROUTER_API_KEY missing in .env');
   101	  process.exit(2);
   102	}
   103	
   104	// ─── Model mapping per mode ────────────────────────────────────────────────────
   105	
   106	interface ModelMap { critic: string; supporter: string; questioner: string; maestro: string }
   107	
   108	const MODELS: Record<string, ModelMap> = {
   109	  default: {
   110	    critic:     'anthropic/claude-sonnet-4.6',
   111	    supporter:  'anthropic/claude-sonnet-4.6',
   112	    questioner: 'anthropic/claude-sonnet-4.6',
   113	    maestro:    'anthropic/claude-sonnet-4.6',
   114	  },
   115	  economico: {
   116	    critic:     'anthropic/claude-haiku-4.5',
   117	    supporter:  'anthropic/claude-haiku-4.5',
   118	    questioner: 'anthropic/claude-haiku-4.5',
   119	    maestro:    'anthropic/claude-haiku-4.5',
   120	  },
   121	  council: {
   122	    critic:     'cli:codex:gpt-5.5',                 // Codex subscription (EGOS_CODEX_EFFORT=medium|high|xhigh)
   123	    supporter:  'cli:claude:sonnet',                 // Claude subscription
   124	    questioner: 'google/gemini-3.1-pro-preview',     // OpenRouter (~$0.03/council — testado 2026-06-10)
   125	    maestro:    'cli:claude:opus',                   // Claude subscription
   126	  },
   127	};
   128	
   129	// ─── Prompts por papel ─────────────────────────────────────────────────────────
   130	
   131	const PROMPTS = {
   132	  critic: (q: string, ctx: string) => `Você é o **Crítico Extremo** de uma Banda Cognitiva EGOS.
   133	
   134	Postura: adversarial construtivo. Não está tentando ser legal. Aponte riscos reais.
   135	
   136	Perguntas obrigatórias:
   137	- O que pode dar errado nesta decisão?
   138	- Existe risco de segurança ou privacidade?
   139	- Cria dependência frágil? De qual lado?
   140	- Risco de alucinação ou falsa confiança?
   141	- Duplicamos algo que já existe?
   142	- Pode quebrar deploy, dados ou fluxo de trabalho?
   143	- Qual o pior cenário em 30/90/365 dias?
   144	
   145	QUESTÃO: ${q}
   146	
   147	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   148	
   149	Responda em YAML válido:
   150	\`\`\`yaml
   151	critico:
   152	  riscos: [<lista priorizada — maior risco primeiro>]
   153	  pior_cenario: <descrição concreta>
   154	  duplicacoes_detectadas: [<se houver>]
   155	  dependencias_frageis: [<lista>]
   156	  recomendacao: ABORTAR | MITIGAR | SEGUIR_COM_RESSALVAS
   157	  ressalvas: [<se aplicável>]
   158	\`\`\`
   159	
   160	Seja conciso. Máx 400 palavras no YAML.`,
   161	
   162	  supporter: (q: string, ctx: string, criticOutput: string) => `Você é o **Apoiador Máximo** de uma Banda Cognitiva EGOS.
   163	
   164	Postura: maximize o potencial. Não ignora a crítica — responde a ela construtivamente.
   165	
   166	Perguntas obrigatórias:
   167	- Qual o maior potencial desta ideia?
   168	- Como as falhas apontadas pelo Crítico viram features?
   169	- Como aproveitar o que já existe no EGOS?
   170	- Como vira regra, ferramenta ou fluxo reusável?
   171	- Que efeito de rede isso pode criar?
   172	
   173	QUESTÃO: ${q}
   174	
   175	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   176	
   177	OUTPUT DO CRÍTICO:
   178	${criticOutput}
   179	
   180	Responda em YAML válido:
   181	\`\`\`yaml
   182	apoiador:
   183	  potencial_maximo: <descrição>
   184	  falhas_do_critico_respondidas:
   185	    - falha: <do crítico>
   186	      resposta: <como vira feature>
   187	  reuso_egos: [<o que já existe que se conecta>]
   188	  efeito_rede: <se houver>
   189	  recomendacao: AMPLIFICAR | EXECUTAR | REFINAR_PRIMEIRO
   190	\`\`\`
   191	
   192	Máx 400 palavras.`,
   193	
   194	  questioner: (q: string, ctx: string, criticOutput: string, supporterOutput: string) => `Você é o **Questionador** de uma Banda Cognitiva EGOS.
   195	
   196	Postura: socrático. Não defende nenhum lado — questiona as premissas.
   197	
   198	Perguntas obrigatórias:
   199	- Por que fazer assim?
   200	- Existe caminho mais simples que resolve 80%?
   201	- O objetivo está claro ou estamos em fuga?
   202	- Estamos resolvendo causa ou sintoma?
   203	- Respeita ética, autonomia e governança?
   204	- O que está implícito que precisamos explicitar?
   205	- Que pergunta ninguém fez ainda?
   206	
   207	QUESTÃO: ${q}
   208	
   209	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   210	
   211	OUTPUT DO CRÍTICO:
   212	${criticOutput}
   213	
   214	OUTPUT DO APOIADOR:
   215	${supporterOutput}
   216	
   217	Responda em YAML válido:
   218	\`\`\`yaml
   219	questionador:
   220	  premissas_implicitas: [<lista>]
   221	  caminho_mais_simples: <se existir>
   222	  causa_vs_sintoma: <análise>
   223	  questoes_nao_feitas: [<lista>]
   224	  alinhamento_egos: OK | TENSAO | CONTRADICAO
   225	  reformulacao_sugerida: <se houver>
   226	\`\`\`
   227	
   228	Máx 400 palavras.`,
   229	
   230	  maestro: (q: string, ctx: string, c: string, a: string, qs: string) => `Você é o **Maestro** de uma Banda Cognitiva EGOS.
   231	
   232	Postura: executivo. Lê os 3 outputs anteriores e destila uma decisão concreta.
   233	
   234	Não defende nenhum papel — sintetiza.
   235	
   236	QUESTÃO ORIGINAL: ${q}
   237	
   238	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   239	
   240	OUTPUT DO CRÍTICO:
   241	${c}
   242	
   243	OUTPUT DO APOIADOR:
   244	${a}
   245	
   246	OUTPUT DO QUESTIONADOR:
   247	${qs}
   248	
   249	Responda APENAS em YAML válido:
   250	\`\`\`yaml
   251	decisao:
   252	  contexto: <1 frase do que estamos decidindo>
   253	  critica_principal: <1 linha>
   254	  potencial_principal: <1 linha>
   255	  duvida_principal: <1 linha>
   256	  acao_escolhida: <concreta + estimativa de tempo>
   257	  acao_rejeitada: <o que NÃO fazer e por quê>
   258	  ressalvas_aplicadas: [<do Crítico, se MITIGAR>]
   259	  proximo_passo: <executável imediatamente>
   260	  prioridade: 1 | 2 | 3 | 5 | 8
   261	  gate_decisao: <quem aprova antes de executar, ex: "Enio" ou "auto">
   262	\`\`\`
   263	
   264	Máx 350 palavras.`,
   265	};
   266	
   267	// ─── LLM call: subscription CLIs (cli:*) ou OpenRouter ─────────────────────────
   268	// Corte Enio 2026-06-10: GPT via Codex subscription, Claude via Claude Code
   269	// subscription; só a perna Gemini (e fallbacks) paga OpenRouter (~$0.001-0.03).
   270	// Guarani/Antigravity FORA da banda (atribuições próprias).
   271	
   272	import { spawnSync } from 'node:child_process';
   273	
   274	function callCli(cmd: string, args: string[]): string {
   275	  const r = spawnSync(cmd, args, {
   276	    encoding: 'utf-8',
   277	    timeout: 300_000,
   278	    maxBuffer: 10 * 1024 * 1024,
   279	  });
   280	  if (r.error) throw new Error(`${cmd} spawn: ${r.error.message}`);
   281	  if (r.status !== 0) throw new Error(`${cmd} exit ${r.status}: ${(r.stderr || '').slice(0, 300)}`);
   282	  const out = (r.stdout || '').trim();
   283	  if (!out) throw new Error(`${cmd}: stdout vazio`);
   284	  return out;
   285	}
   286	
   287	async function callLLM(model: string, prompt: string): Promise<string> {
   288	  if (DRY) {
   289	    return `# DRY-RUN output for ${model}\nsimulated_response: ok\nwould_call_model: ${model}`;
   290	  }
   291	  // cli:codex:<model> — Codex CLI (subscription). Effort via EGOS_CODEX_EFFORT
   292	  // (medium|high|xhigh; default medium). Prompt como arg posicional (padrão
   293	  // provado no pre-commit §codex).
   294	  if (model.startsWith('cli:codex:')) {
   295	    const m = model.slice('cli:codex:'.length);
   296	    const effort = process.env.EGOS_CODEX_EFFORT ?? 'medium';
   297	    return callCli('codex', [
   298	      'exec', '--model', m, '-c', `model_reasoning_effort="${effort}"`, prompt,
   299	    ]);
   300	  }
   301	  // cli:claude:<alias> — Claude Code CLI (subscription), print mode headless.
   302	  if (model.startsWith('cli:claude:')) {
   303	    const m = model.slice('cli:claude:'.length);
   304	    return callCli('claude', ['-p', '--model', m, prompt]);
   305	  }
   306	  // Route deepseek/* to direct API when DEEPSEEK_API_KEY is available
   307	  const isDeepseek = model.includes('deepseek');
   308	  const deepseekKey = ENV.DEEPSEEK_API_KEY ?? '';
   309	  const apiUrl = (isDeepseek && deepseekKey)
   310	    ? 'https://api.deepseek.com/v1/chat/completions'
   311	    : 'https://openrouter.ai/api/v1/chat/completions';
   312	  const apiKey = (isDeepseek && deepseekKey) ? deepseekKey : OPENROUTER_KEY;
   313	  // Normalize model name for DeepSeek direct API
   314	  const modelId = (isDeepseek && deepseekKey)
   315	    ? model.replace('deepseek/', '').replace('-flash', '-chat').replace('-pro', '-reasoner').replace('v4-flash','chat').replace('v4-pro','reasoner')
   316	    : model;
   317	
   318	  const r = await fetch(apiUrl, {
   319	    method: 'POST',
   320	    headers: {
   321	      'Authorization': `Bearer ${apiKey}`,
   322	      'Content-Type': 'application/json',
   323	      'HTTP-Referer': 'https://github.com/enioxt/egos',
   324	      'X-Title': 'EGOS Banda Cognitiva',
   325	    },
   326	    body: JSON.stringify({
   327	      model,
   328	      messages: [{ role: 'user', content: prompt }],
   329	      temperature: 0.3,
   330	      max_tokens: 2000,
   331	    }),
   332	    signal: AbortSignal.timeout(90_000),
   333	  });
   334	  if (!r.ok) {
   335	    const txt = await r.text();
   336	    throw new Error(`LLM ${model} failed ${r.status}: ${txt.slice(0, 300)}`);
   337	  }
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
   366	  console.log('');
   367	
   368	  let context = EFFECTIVE_CONTEXT;
   369	  // Se context começa com @, ler arquivo (legado; preferir --context-file)
   370	  if (context.startsWith('@')) {
   371	    const path = context.slice(1);
   372	    context = existsSync(path) ? readFileSync(path, 'utf-8').slice(0, 10000) : '';
   373	  }
   374	  context = context.slice(0, 12000);
   375	
   376	  // Phase 1 — Crítico
   377	  process.stdout.write('[1/4] Crítico Extremo... ');
   378	  const criticRaw = await callLLM(models.critic, PROMPTS.critic(QUESTION, context));
   379	  const critic = extractYaml(criticRaw);
   380	  console.log('✓');
   381	
   382	  // Phase 2 — Apoiador
   383	  process.stdout.write('[2/4] Apoiador Máximo... ');
   384	  const supporterRaw = await callLLM(models.supporter, PROMPTS.supporter(QUESTION, context, critic));
   385	  const supporter = extractYaml(supporterRaw);
   386	  console.log('✓');
   387	
   388	  // Phase 3 — Questionador
   389	  process.stdout.write('[3/4] Questionador... ');
   390	  const questionerRaw = await callLLM(models.questioner, PROMPTS.questioner(QUESTION, context, critic, supporter));
   391	  const questioner = extractYaml(questionerRaw);
   392	  console.log('✓');
   393	
   394	  // Phase 4 — Maestro
   395	  process.stdout.write('[4/4] Maestro (síntese)... ');
   396	  const maestroRaw = await callLLM(models.maestro, PROMPTS.maestro(QUESTION, context, critic, supporter, questioner));
   397	  const maestro = extractYaml(maestroRaw);
   398	  console.log('✓');
   399	
   400	  const elapsed = Math.round((Date.now() - startTs) / 1000);
   401	
   402	  // Output
   403	  console.log('');
   404	  if (VERBOSE) {
   405	    console.log('─── CRÍTICO ─────────────────────────────');
   406	    console.log(critic);
   407	    console.log('\n─── APOIADOR ────────────────────────────');
   408	    console.log(supporter);
   409	    console.log('\n─── QUESTIONADOR ────────────────────────');
   410	    console.log(questioner);
   411	    console.log('\n─── MAESTRO (síntese) ───────────────────');
   412	  }
   413	  console.log(maestro);
   414	  console.log('');
   415	  console.log(`[banda] ${elapsed}s | Mode: ${MODE}`);
   416	
   417	  // Save trace (YAML)
   418	  const dir = '/home/enio/egos/docs/banda';
   419	  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
   420	  const outPath = join(dir, `${today}-${slug}.yaml`);
   421	  const trace = `# Banda Cognitiva — ${today}
   422	id: ${today}-${slug}
   423	mode: ${MODE}
   424	question: |
   425	  ${QUESTION.split('\n').map(l => '  ' + l).join('\n').trim()}
   426	context_provided: ${context.length > 0}
   427	duration_seconds: ${elapsed}
   428	models:
   429	  critic: ${models.critic}
   430	  supporter: ${models.supporter}

exec
/bin/bash -lc "sed -n '430,520p' scripts/banda.ts | nl -ba -v430" in /home/enio/egos
 succeeded in 0ms:
   430	  supporter: ${models.supporter}
   431	  questioner: ${models.questioner}
   432	  maestro: ${models.maestro}
   433	
   434	---
   435	# Phase 1 — Crítico
   436	${critic}
   437	
   438	---
   439	# Phase 2 — Apoiador
   440	${supporter}
   441	
   442	---
   443	# Phase 3 — Questionador
   444	${questioner}
   445	
   446	---
   447	# Phase 4 — Maestro (FINAL SYNTHESIS)
   448	${maestro}
   449	
   450	# Sacred Code: 000.111.369.963.1618
   451	`;
   452	  writeFileSync(outPath, trace);
   453	  console.log(`[banda] Trace saved: ${outPath}`);
   454	}
   455	
   456	main().catch(e => {
   457	  console.error('[banda] FAIL:', e.message);
   458	  process.exit(3);
   459	});

exec
/bin/bash -lc "git show d24755e36fb5d72e4b58bf1debdd5b142a147619:scripts/banda.ts | nl -ba | sed -n '1,360p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * OPUS-F4-001 — Banda Cognitiva executor (hierárquico sequencial)
     4	 *
     5	 * Protocolo (opção C aprovada):
     6	 *   Crítico Extremo → Apoiador Máximo → Questionador → Maestro
     7	 * Cada papel vê o output do anterior. Output final = síntese do Maestro.
     8	 *
     9	 * SSOT: docs/opus-mode/BANDA_COGNITIVA.md
    10	 * Related: docs/opus-mode/OPUS_MODE_V1.md §4
    11	 *
    12	 * Usage:
    13	 *   bun scripts/banda.ts --question "Devemos fazer X ou Y?" [--context "..."] [--mode economico|default|council]
    14	 *   bun scripts/banda.ts --dry      # testa sem chamar LLMs
    15	 *   bun scripts/banda.ts --verbose  # mostra os 4 outputs (default: só Maestro)
    16	 *
    17	 * Modes:
    18	 *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
    19	 *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
    20	 *   council    — modelo diferente por papel via OpenRouter (~$1-3, max qualidade)
    21	 *
    22	 * Output:
    23	 *   - Console: síntese do Maestro (ou verbose com todos)
    24	 *   - Arquivo: docs/banda/YYYY-MM-DD-<slug>.yaml (trace completo)
    25	 */
    26	
    27	export {};
    28	
    29	import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
    30	import { join } from 'node:path';
    31	
    32	// ─── Config ────────────────────────────────────────────────────────────────────
    33	
    34	const ARGS = process.argv.slice(2);
    35	const DRY = ARGS.includes('--dry');
    36	const VERBOSE = ARGS.includes('--verbose');
    37	const QUESTION = ARGS.find((_, i) => ARGS[i - 1] === '--question') ?? '';
    38	const CONTEXT_ARG = ARGS.find((_, i) => ARGS[i - 1] === '--context') ?? '';
    39	const MODE = (ARGS.find((_, i) => ARGS[i - 1] === '--mode') ?? 'default') as
    40	  'default' | 'economico' | 'council';
    41	
    42	if (!QUESTION && !DRY) {
    43	  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--mode default|economico|council] [--verbose] [--dry]');
    44	  process.exit(1);
    45	}
    46	
    47	// Load env
    48	function loadEnv(path: string): Record<string, string> {
    49	  if (!existsSync(path)) return {};
    50	  const env: Record<string, string> = {};
    51	  for (const line of readFileSync(path, 'utf-8').split('\n')) {
    52	    const m = line.match(/^(?:export\s+)?([A-Z_]+)=(.*)$/);
    53	    if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, '');
    54	  }
    55	  return env;
    56	}
    57	
    58	const ENV = { ...loadEnv('/home/enio/egos/.env'), ...process.env } as Record<string, string>;
    59	const OPENROUTER_KEY = ENV.OPENROUTER_API_KEY ?? '';
    60	const ANTHROPIC_KEY = ENV.ANTHROPIC_API_KEY ?? '';
    61	
    62	if (!DRY && !OPENROUTER_KEY) {
    63	  console.error('[banda] OPENROUTER_API_KEY missing in .env');
    64	  process.exit(2);
    65	}
    66	
    67	// ─── Model mapping per mode ────────────────────────────────────────────────────
    68	
    69	interface ModelMap { critic: string; supporter: string; questioner: string; maestro: string }
    70	
    71	const MODELS: Record<string, ModelMap> = {
    72	  default: {
    73	    critic:     'anthropic/claude-sonnet-4.6',
    74	    supporter:  'anthropic/claude-sonnet-4.6',
    75	    questioner: 'anthropic/claude-sonnet-4.6',
    76	    maestro:    'anthropic/claude-sonnet-4.6',
    77	  },
    78	  economico: {
    79	    critic:     'anthropic/claude-haiku-4.5',
    80	    supporter:  'anthropic/claude-haiku-4.5',
    81	    questioner: 'anthropic/claude-haiku-4.5',
    82	    maestro:    'anthropic/claude-haiku-4.5',
    83	  },
    84	  council: {
    85	    critic:     'openai/gpt-5.4',
    86	    supporter:  'anthropic/claude-sonnet-4.6',
    87	    questioner: 'google/gemini-2.5-pro',
    88	    maestro:    'anthropic/claude-opus-4.7',
    89	  },
    90	};
    91	
    92	// ─── Prompts por papel ─────────────────────────────────────────────────────────
    93	
    94	const PROMPTS = {
    95	  critic: (q: string, ctx: string) => `Você é o **Crítico Extremo** de uma Banda Cognitiva EGOS.
    96	
    97	Postura: adversarial construtivo. Não está tentando ser legal. Aponte riscos reais.
    98	
    99	Perguntas obrigatórias:
   100	- O que pode dar errado nesta decisão?
   101	- Existe risco de segurança ou privacidade?
   102	- Cria dependência frágil? De qual lado?
   103	- Risco de alucinação ou falsa confiança?
   104	- Duplicamos algo que já existe?
   105	- Pode quebrar deploy, dados ou fluxo de trabalho?
   106	- Qual o pior cenário em 30/90/365 dias?
   107	
   108	QUESTÃO: ${q}
   109	
   110	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   111	
   112	Responda em YAML válido:
   113	\`\`\`yaml
   114	critico:
   115	  riscos: [<lista priorizada — maior risco primeiro>]
   116	  pior_cenario: <descrição concreta>
   117	  duplicacoes_detectadas: [<se houver>]
   118	  dependencias_frageis: [<lista>]
   119	  recomendacao: ABORTAR | MITIGAR | SEGUIR_COM_RESSALVAS
   120	  ressalvas: [<se aplicável>]
   121	\`\`\`
   122	
   123	Seja conciso. Máx 400 palavras no YAML.`,
   124	
   125	  supporter: (q: string, ctx: string, criticOutput: string) => `Você é o **Apoiador Máximo** de uma Banda Cognitiva EGOS.
   126	
   127	Postura: maximize o potencial. Não ignora a crítica — responde a ela construtivamente.
   128	
   129	Perguntas obrigatórias:
   130	- Qual o maior potencial desta ideia?
   131	- Como as falhas apontadas pelo Crítico viram features?
   132	- Como aproveitar o que já existe no EGOS?
   133	- Como vira regra, ferramenta ou fluxo reusável?
   134	- Que efeito de rede isso pode criar?
   135	
   136	QUESTÃO: ${q}
   137	
   138	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   139	
   140	OUTPUT DO CRÍTICO:
   141	${criticOutput}
   142	
   143	Responda em YAML válido:
   144	\`\`\`yaml
   145	apoiador:
   146	  potencial_maximo: <descrição>
   147	  falhas_do_critico_respondidas:
   148	    - falha: <do crítico>
   149	      resposta: <como vira feature>
   150	  reuso_egos: [<o que já existe que se conecta>]
   151	  efeito_rede: <se houver>
   152	  recomendacao: AMPLIFICAR | EXECUTAR | REFINAR_PRIMEIRO
   153	\`\`\`
   154	
   155	Máx 400 palavras.`,
   156	
   157	  questioner: (q: string, ctx: string, criticOutput: string, supporterOutput: string) => `Você é o **Questionador** de uma Banda Cognitiva EGOS.
   158	
   159	Postura: socrático. Não defende nenhum lado — questiona as premissas.
   160	
   161	Perguntas obrigatórias:
   162	- Por que fazer assim?
   163	- Existe caminho mais simples que resolve 80%?
   164	- O objetivo está claro ou estamos em fuga?
   165	- Estamos resolvendo causa ou sintoma?
   166	- Respeita ética, autonomia e governança?
   167	- O que está implícito que precisamos explicitar?
   168	- Que pergunta ninguém fez ainda?
   169	
   170	QUESTÃO: ${q}
   171	
   172	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   173	
   174	OUTPUT DO CRÍTICO:
   175	${criticOutput}
   176	
   177	OUTPUT DO APOIADOR:
   178	${supporterOutput}
   179	
   180	Responda em YAML válido:
   181	\`\`\`yaml
   182	questionador:
   183	  premissas_implicitas: [<lista>]
   184	  caminho_mais_simples: <se existir>
   185	  causa_vs_sintoma: <análise>
   186	  questoes_nao_feitas: [<lista>]
   187	  alinhamento_egos: OK | TENSAO | CONTRADICAO
   188	  reformulacao_sugerida: <se houver>
   189	\`\`\`
   190	
   191	Máx 400 palavras.`,
   192	
   193	  maestro: (q: string, ctx: string, c: string, a: string, qs: string) => `Você é o **Maestro** de uma Banda Cognitiva EGOS.
   194	
   195	Postura: executivo. Lê os 3 outputs anteriores e destila uma decisão concreta.
   196	
   197	Não defende nenhum papel — sintetiza.
   198	
   199	QUESTÃO ORIGINAL: ${q}
   200	
   201	${ctx ? `CONTEXTO:\n${ctx}\n` : ''}
   202	
   203	OUTPUT DO CRÍTICO:
   204	${c}
   205	
   206	OUTPUT DO APOIADOR:
   207	${a}
   208	
   209	OUTPUT DO QUESTIONADOR:
   210	${qs}
   211	
   212	Responda APENAS em YAML válido:
   213	\`\`\`yaml
   214	decisao:
   215	  contexto: <1 frase do que estamos decidindo>
   216	  critica_principal: <1 linha>
   217	  potencial_principal: <1 linha>
   218	  duvida_principal: <1 linha>
   219	  acao_escolhida: <concreta + estimativa de tempo>
   220	  acao_rejeitada: <o que NÃO fazer e por quê>
   221	  ressalvas_aplicadas: [<do Crítico, se MITIGAR>]
   222	  proximo_passo: <executável imediatamente>
   223	  prioridade: 1 | 2 | 3 | 5 | 8
   224	  gate_decisao: <quem aprova antes de executar, ex: "Enio" ou "auto">
   225	\`\`\`
   226	
   227	Máx 350 palavras.`,
   228	};
   229	
   230	// ─── LLM call via OpenRouter ───────────────────────────────────────────────────
   231	
   232	async function callLLM(model: string, prompt: string): Promise<string> {
   233	  if (DRY) {
   234	    return `# DRY-RUN output for ${model}\nsimulated_response: ok\nwould_call_model: ${model}`;
   235	  }
   236	  // Route deepseek/* to direct API when DEEPSEEK_API_KEY is available
   237	  const isDeepseek = model.includes('deepseek');
   238	  const deepseekKey = ENV.DEEPSEEK_API_KEY ?? '';
   239	  const apiUrl = (isDeepseek && deepseekKey)
   240	    ? 'https://api.deepseek.com/v1/chat/completions'
   241	    : 'https://openrouter.ai/api/v1/chat/completions';
   242	  const apiKey = (isDeepseek && deepseekKey) ? deepseekKey : OPENROUTER_KEY;
   243	  // Normalize model name for DeepSeek direct API
   244	  const modelId = (isDeepseek && deepseekKey)
   245	    ? model.replace('deepseek/', '').replace('-flash', '-chat').replace('-pro', '-reasoner').replace('v4-flash','chat').replace('v4-pro','reasoner')
   246	    : model;
   247	
   248	  const r = await fetch(apiUrl, {
   249	    method: 'POST',
   250	    headers: {
   251	      'Authorization': `Bearer ${apiKey}`,
   252	      'Content-Type': 'application/json',
   253	      'HTTP-Referer': 'https://github.com/enioxt/egos',
   254	      'X-Title': 'EGOS Banda Cognitiva',
   255	    },
   256	    body: JSON.stringify({
   257	      model,
   258	      messages: [{ role: 'user', content: prompt }],
   259	      temperature: 0.3,
   260	      max_tokens: 2000,
   261	    }),
   262	    signal: AbortSignal.timeout(90_000),
   263	  });
   264	  if (!r.ok) {
   265	    const txt = await r.text();
   266	    throw new Error(`LLM ${model} failed ${r.status}: ${txt.slice(0, 300)}`);
   267	  }
   268	  const data = await r.json() as { choices?: Array<{ message?: { content?: string } }> };
   269	  return data.choices?.[0]?.message?.content ?? '';
   270	}
   271	
   272	// ─── Helpers ───────────────────────────────────────────────────────────────────
   273	
   274	function slugify(text: string): string {
   275	  return text.toLowerCase()
   276	    .replace(/[^a-z0-9]+/g, '-')
   277	    .replace(/^-+|-+$/g, '')
   278	    .slice(0, 50);
   279	}
   280	
   281	function extractYaml(response: string): string {
   282	  const m = response.match(/```ya?ml\n([\s\S]*?)```/);
   283	  return m ? m[1].trim() : response.trim();
   284	}
   285	
   286	// ─── Main ──────────────────────────────────────────────────────────────────────
   287	
   288	async function main() {
   289	  const models = MODELS[MODE];
   290	  const startTs = Date.now();
   291	  const slug = slugify(QUESTION || 'dry-run');
   292	  const today = new Date().toISOString().split('T')[0];
   293	
   294	  console.log(`[banda] MODE=${MODE} | Question: "${QUESTION.slice(0, 80)}${QUESTION.length > 80 ? '...' : ''}"`);
   295	  console.log(`[banda] Models: critic=${models.critic.split('/').pop()} | supporter=${models.supporter.split('/').pop()} | questioner=${models.questioner.split('/').pop()} | maestro=${models.maestro.split('/').pop()}`);
   296	  console.log('');
   297	
   298	  let context = CONTEXT_ARG;
   299	  // Se context começa com @, ler arquivo
   300	  if (context.startsWith('@')) {
   301	    const path = context.slice(1);
   302	    context = existsSync(path) ? readFileSync(path, 'utf-8').slice(0, 10000) : '';
   303	  }
   304	
   305	  // Phase 1 — Crítico
   306	  process.stdout.write('[1/4] Crítico Extremo... ');
   307	  const criticRaw = await callLLM(models.critic, PROMPTS.critic(QUESTION, context));
   308	  const critic = extractYaml(criticRaw);
   309	  console.log('✓');
   310	
   311	  // Phase 2 — Apoiador
   312	  process.stdout.write('[2/4] Apoiador Máximo... ');
   313	  const supporterRaw = await callLLM(models.supporter, PROMPTS.supporter(QUESTION, context, critic));
   314	  const supporter = extractYaml(supporterRaw);
   315	  console.log('✓');
   316	
   317	  // Phase 3 — Questionador
   318	  process.stdout.write('[3/4] Questionador... ');
   319	  const questionerRaw = await callLLM(models.questioner, PROMPTS.questioner(QUESTION, context, critic, supporter));
   320	  const questioner = extractYaml(questionerRaw);
   321	  console.log('✓');
   322	
   323	  // Phase 4 — Maestro
   324	  process.stdout.write('[4/4] Maestro (síntese)... ');
   325	  const maestroRaw = await callLLM(models.maestro, PROMPTS.maestro(QUESTION, context, critic, supporter, questioner));
   326	  const maestro = extractYaml(maestroRaw);
   327	  console.log('✓');
   328	
   329	  const elapsed = Math.round((Date.now() - startTs) / 1000);
   330	
   331	  // Output
   332	  console.log('');
   333	  if (VERBOSE) {
   334	    console.log('─── CRÍTICO ─────────────────────────────');
   335	    console.log(critic);
   336	    console.log('\n─── APOIADOR ────────────────────────────');
   337	    console.log(supporter);
   338	    console.log('\n─── QUESTIONADOR ────────────────────────');
   339	    console.log(questioner);
   340	    console.log('\n─── MAESTRO (síntese) ───────────────────');
   341	  }
   342	  console.log(maestro);
   343	  console.log('');
   344	  console.log(`[banda] ${elapsed}s | Mode: ${MODE}`);
   345	
   346	  // Save trace (YAML)
   347	  const dir = '/home/enio/egos/docs/banda';
   348	  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
   349	  const outPath = join(dir, `${today}-${slug}.yaml`);
   350	  const trace = `# Banda Cognitiva — ${today}
   351	id: ${today}-${slug}
   352	mode: ${MODE}
   353	question: |
   354	  ${QUESTION.split('\n').map(l => '  ' + l).join('\n').trim()}
   355	context_provided: ${context.length > 0}
   356	duration_seconds: ${elapsed}
   357	models:
   358	  critic: ${models.critic}
   359	  supporter: ${models.supporter}
   360	  questioner: ${models.questioner}

exec
/bin/bash -lc "sed -n '1,180p' packages/guard-brasil/src/lib/pii-scanner.ts | nl -ba" in /home/enio/egos
 succeeded in 0ms:
     1	import {
     2	  ALL_PII_PATTERNS,
     3	  type PIIPatternConfig,
     4	} from '../pii-patterns.js';
     5	
     6	export type PIICategory = 'cpf' | 'rg' | 'masp' | 'phone' | 'email' | 'reds' | 'process_number' | 'name' | 'address' | 'plate' | 'date_of_birth' | 'cnpj' | 'cnh' | 'cep' | 'health_data';
     7	export interface PIIFinding { category: PIICategory; label: string; matched: string; start: number; end: number; suggestion: string; }
     8	export interface PIIPatternDefinition { category: PIICategory; label: string; pattern: RegExp; suggestion: string; }
     9	
    10	/**
    11	 * Bridge from centralized PIIPatternConfig to legacy PIIPatternDefinition format.
    12	 * Maps pii-patterns.ts IDs to the PIICategory values used by existing consumers.
    13	 */
    14	const PATTERN_ID_TO_CATEGORY: Record<string, PIICategory> = {
    15	  cpf: 'cpf',
    16	  cnpj: 'cnpj',
    17	  rg: 'rg',
    18	  cnh: 'cnh',
    19	  masp: 'masp',
    20	  reds: 'reds',
    21	  processo: 'process_number',
    22	  placa_antiga: 'plate',
    23	  placa_mercosul: 'plate',
    24	  telefone: 'phone',
    25	  email: 'email',
    26	  cep: 'cep',
    27	  health_condition: 'health_data',
    28	};
    29	
    30	function toPIIPatternDefinition(config: PIIPatternConfig): PIIPatternDefinition {
    31	  return {
    32	    category: PATTERN_ID_TO_CATEGORY[config.id] ?? (config.id as PIICategory),
    33	    label: config.label,
    34	    pattern: config.regex,
    35	    suggestion: config.maskFormat,
    36	  };
    37	}
    38	
    39	/** Default PII patterns derived from the centralized pii-patterns.ts registry */
    40	export const DEFAULT_PII_PATTERNS: PIIPatternDefinition[] = ALL_PII_PATTERNS.map(toPIIPatternDefinition);
    41	
    42	/** Legacy date-of-birth pattern (kept for backward compatibility) */
    43	const DATE_OF_BIRTH_PATTERN: PIIPatternDefinition = {
    44	  category: 'date_of_birth',
    45	  label: 'Data de Nascimento',
    46	  pattern: /\b(?:nascido|nascimento|nasc\.?|DN|dn)[:\s]*\d{1,2}[\/.-]\d{1,2}[\/.-]\d{2,4}\b/gi,
    47	  suggestion: '[DATA REMOVIDA]',
    48	};
    49	
    50	// Append date-of-birth (not yet in centralized patterns — context-dependent)
    51	DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);
    52	
    53	// Catches names preceded by role/title (law enforcement) OR explicit label fields (Nome:, Paciente:, etc.)
    54	// Uses /g (not /gi) so character classes remain case-sensitive — prevents over-matching.
    55	const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
    56	const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);
    57	
    58	export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp; useNERRules?: boolean }): PIIFinding[] {
    59	  const findings: PIIFinding[] = [];
    60	  const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
    61	  const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
    62	  for (const { category, label, suggestion, pattern } of patterns) {
    63	    const activePattern = clonePattern(pattern);
    64	    let match: RegExpExecArray | null;
    65	    while ((match = activePattern.exec(text)) !== null) findings.push({ category, label, matched: match[0], start: match.index, end: match.index + match[0].length, suggestion });
    66	  }
    67	  const namePattern = clonePattern(options?.namePattern ?? DEFAULT_NAME_PATTERN);
    68	  let nameMatch: RegExpExecArray | null;
    69	  while ((nameMatch = namePattern.exec(text)) !== null) {
    70	    const name = nameMatch[1];
    71	    if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
    72	  }
    73	  return deduplicateFindings(findings.sort((a, b) => a.start - b.start));
    74	}
    75	
    76	export function sanitizeText(text: string, findings: PIIFinding[]): string {
    77	  let result = text;
    78	  for (const finding of [...findings].sort((a, b) => b.start - a.start)) result = result.slice(0, finding.start) + finding.suggestion + result.slice(finding.end);
    79	  return result;
    80	}
    81	
    82	export function getPIISummary(findings: PIIFinding[]): string {
    83	  if (findings.length === 0) return 'Nenhum dado sensível detectado.';
    84	  return `Detectamos ${findings.length} dado(s) sensível(is): ${[...new Set(findings.map((finding) => finding.label))].join(', ')}.`;
    85	}
    86	
    87	function deduplicateFindings(findings: PIIFinding[]) {
    88	  // Sort: start ascending, then end descending — longer match at same position wins.
    89	  // This ensures custom/more-specific patterns beat shorter built-in matches at the same offset.
    90	  const sorted = [...findings].sort((a, b) => a.start !== b.start ? a.start - b.start : b.end - a.end);
    91	  const result: PIIFinding[] = [];
    92	  let lastEnd = -1;
    93	  for (const finding of sorted) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
    94	  return result;
    95	}

exec
/bin/bash -lc 'git diff --name-only d24755e36fb5d72e4b58bf1debdd5b142a147619' in /home/enio/egos
 succeeded in 0ms:
.guarani/RULES_INDEX.md
.husky/pre-commit
AGENTS.md
CLAUDE.md
TASKS.md
TASKS_ARCHIVE.md
apps/egos-landing/public/mycelium-snapshot.json
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/_current_handoffs/FOR_GUARANI_2026-06-10_banda-questioner-protocol.md
docs/banda/2026-06-10-a-fus-o-egos-odysseus-deve-ser-a-odysseus-como-fro.yaml
docs/banda/2026-06-10-smoke-do-council-rewired-os-4-pap-is-respondem-pel.yaml
docs/governance/GUARANI_EVALUATOR_PROTOCOL.md
docs/governance/METAPROMPT_STANDARD.md
docs/governance/ODYSSEUS_EGOS_MERGE_PROPOSAL.md
docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
docs/guard-brasil/GUARD_BRASIL_ANALYSIS.html
docs/jobs/2026-06-10-doc-drift-verifier.json
docs/jobs/2026-06-10-pre-commit-pipeline.json
packages/guard-brasil/src/lib/pii-scanner.ts
scripts/banda.ts

exec
/bin/bash -lc "git diff d24755e36fb5d72e4b58bf1debdd5b142a147619 -- apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml apps/egos-landing/public/mycelium-snapshot.json | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
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

exec
/bin/bash -lc "sed -n '320,410p' .husky/pre-commit | nl -ba -v320 && sed -n '880,940p' .husky/pre-commit | nl -ba -v880" in /home/enio/egos
 succeeded in 0ms:
   320	echo "  [2/5] start-v6.0: running system health checks..."
   321	HEALTH=$(bun scripts/start-v6.ts --json 2>/dev/null)
   322	GATES=$(printf '%s' "$HEALTH" | json_get '.validation.gates_pass')
   323	if [ "$GATES" != "true" ]; then
   324	  echo "❌ BLOCKED: System health gates failed."
   325	  if command -v jq > /dev/null 2>&1; then
   326	    echo "$HEALTH" | jq '.blockers, .recommendations[:2]' 2>/dev/null
   327	  else
   328	    echo "    (jq not installed — install via 'winget install jqlang.jq' on Windows, 'apt install jq' on Linux)"
   329	    echo "    Run for details: bun scripts/start-v6.ts --full"
   330	  fi
   331	  exit 1
   332	fi
   333	
   334	# 2.5. TypeScript — Strict type check
   335	echo "  [2.5/5] tsc: running strict type check..."
   336	npx tsc --noEmit 2>/dev/null || bun run typecheck 2>/dev/null || {
   337	  echo "❌ BLOCKED: TypeScript errors found. Fix before committing."
   338	  exit 1
   339	}
   340	
   341	# 3. Frozen Zones — Check for unauthorized changes
   342	STAGED=$(git diff --cached --name-only 2>/dev/null || true)
   343	FROZEN_VIOLATED=0
   344	
   345	for frozen in \
   346	  "agents/runtime/runner.ts" \
   347	  "agents/runtime/event-bus.ts" \
   348	  ".husky/pre-commit" \
   349	  ".guarani/orchestration/PIPELINE.md" \
   350	  ".guarani/orchestration/GATES.md"; do
   351	  if echo "$STAGED" | grep -q "^${frozen}$"; then
   352	    echo "  FROZEN ZONE: $frozen is staged for commit."
   353	    echo "   This file requires explicit user approval + proof-of-work."
   354	    FROZEN_VIOLATED=1
   355	  fi
   356	done
   357	
   358	if [ "$FROZEN_VIOLATED" -eq 1 ]; then
   359	  # METAPROMPT-GATE-001 fix 2026-06-10: --no-verify está DENY no settings.json (2026-06-09),
   360	  # então §3 sem env-override = deadlock. Alinha com AGENTS.md §R3 + §3.5b: mesmo env.
   361	  if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then
   362	    echo "  🟡 FROZEN OVERRIDE: EGOS_FROZEN_OVERRIDE=1 (humano/Prime assume — logado)"
   363	  else
   364	    echo ""
   365	    echo "❌ BLOCKED: Frozen zone files modified."
   366	    echo "   Override legítimo (Enio/Prime, logado): EGOS_FROZEN_OVERRIDE=1 git commit ..."
   367	    echo "   (--no-verify é DENY no settings — não use)"
   368	    exit 1
   369	  fi
   370	fi
   371	
   372	# 3.5. Frozen-zone / governance commit AUTHORITY gate (hardened GUARANI-004 + HITL_CATALOG §5.1)
   373	# Fail-closed-by-DEFAULT: a commit touching frozen zones / governance is blocked unless the window
   374	# is a Prime session (Claude Code sets CLAUDECODE automatically) OR Enio sets an explicit human
   375	# override. Guarani (Antigravity/Gemini) has no CLAUDECODE, so it is blocked WITHOUT relying on an
   376	# honor-system env var. THREAT MODEL (Codex 2026-05-31): these are process env vars and therefore
   377	# forgeable — this gate stops accidents/defaults and records intent, it is NOT tamper-proof authz.
   378	# Real enforcement still rests on process discipline (Guarani never commits) + sole-committer Prime;
   379	# a server-side pre-receive hook would be required for hard authz (not wired for this solo setup).
   380	# 3.5b (INC-STAGED-HIJACK 2026-06-10, corte Enio "já faça"): scope WIDENED from
   381	# GOV_FROZEN to ALL commits. Root cause: shared checkout + shared index — Guarani window
   382	# committed cbb0006e and swept Prime's staged files into it (same class as d988385b).
   383	# R10 says "Guarani proposes; Prime commits" but was will-only. This makes it a gate:
   384	# ANY kernel commit requires a Prime window (CLAUDECODE) or explicit human override.
   385	AUTHORIZED=0
   386	WHO="unknown"
   387	# Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
   388	if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
   389	# Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
   390	if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
   391	# Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
   392	if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
   393	if [ "$AUTHORIZED" -ne 1 ]; then
   394	  echo "❌ BLOCKED: kernel commits require a Prime window or explicit human override (R10)."
   395	  if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
   396	  echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
   397	  echo "   Root cause INC-STAGED-HIJACK: shared index — a non-Prime commit sweeps the other window's staged files."
   398	  echo "   Guarani/Antigravity: deixe o trabalho na working tree + FOR_PRIME_*.md; o Prime commita."
   399	  echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
   400	  exit 1
   401	fi
   402	
   403	
   404	# 4.1. Frozen Zone — .guarani/ must stay REAL files (anti-symlink-conversion guard)
   405	# Root cause INC-SYMLINK-001 (2026-05-31, recurred same day): governance:sync:exec /
   406	# ~/.egos/sync.sh converts kernel .guarani/ into symlinks to ~/.egos/guarani/. The kernel
   407	# is the REAL source — symlink conversions must never be committed. Catches any window/script.
   408	GUARANI_SYMLINKED=$(git diff --cached --raw 2>/dev/null | awk '$2=="120000" && /\.guarani\// {print $NF}' || true)
   409	if [ -n "$GUARANI_SYMLINKED" ]; then
   410	  if [ "${EGOS_ALLOW_GUARANI_SYMLINK:-0}" != "1" ]; then
   880	    for f in $PROD_RSYNC; do echo "    $f"; done
   881	    echo ""
   882	    echo "   Origem: INC-PROD-001 (2026-05-13) — rsync sem gates causou catálogo vazio"
   883	    echo "          em gpecas.egos.ia.br. Cada deploy DEVE usar script com R1-R8."
   884	    echo ""
   885	    echo "   Soluções:"
   886	    echo "   1. Mover rsync pra scripts/deploy-<app>.sh seguindo template scripts/deploy-gpecas.sh"
   887	    echo "   2. Adicionar gates: env validation, bundle compiled check, backup, smoke test, rollback"
   888	    echo "   3. SSOT: docs/governance/PRODUCTION_DEPLOY_RULES.md §4"
   889	    echo ""
   890	    echo "   Override emergencial (use com cuidado, justifique em commit message):"
   891	    echo "     PROD_RSYNC_OVERRIDE=1 git commit ..."
   892	    if [ "${PROD_RSYNC_OVERRIDE:-0}" != "1" ]; then
   893	      exit 1
   894	    else
   895	      echo "   ⚠️  OVERRIDE detectado (PROD_RSYNC_OVERRIDE=1) — commit prossegue"
   896	    fi
   897	  fi
   898	fi
   899	# === End Anti-Rsync-Prod Gate ===
   900	
   901	# === Phantom CBC Check — PHANTOM-CBC-HOOK-001 (2026-05-18) ===
   902	# Bloqueia CBC-*.md com status alpha/beta/stable mas case_count=0 (INC-008)
   903	# Override: "PHANTOM_OVERRIDE: <reason>" no corpo do commit
   904	if [ -x ".husky/_checks/12-phantom-cbc.sh" ]; then
   905	  .husky/_checks/12-phantom-cbc.sh || exit 1
   906	fi
   907	# === End Phantom CBC Check ===
   908	
   909	# === Codex Review (opt-in, non-blocking) — added 2026-05-12 ===
   910	# Ativa com: export EGOS_CODEX_REVIEW=1
   911	# SSOT: docs/governance/MULTI_LLM_ORCHESTRATION.md §4
   912	if [ "${EGOS_CODEX_REVIEW:-0}" = "1" ] && command -v codex >/dev/null 2>&1; then
   913	  DIFF_LINES=$(git diff --cached --shortstat 2>/dev/null | grep -oE '[0-9]+' | head -1 || echo 0)
   914	  CRITICAL=$(git diff --cached --name-only 2>/dev/null | grep -E "^(auth|migrations|lib/prompts|docs/governance)/" | head -1 || true)
   915	  MODEL="gpt-5.3-codex"
   916	  if [ "${DIFF_LINES:-0}" -gt 500 ] || [ -n "$CRITICAL" ]; then
   917	    MODEL="gpt-5.5"
   918	  fi
   919	  echo "  [codex-review] running non-blocking review (model=$MODEL)..."
   920	  # Prompt segue METAPROMPT_STANDARD.md (MP-R1..R6) — METAPROMPT-GATE-001
   921	  git diff --cached | codex exec --model "$MODEL" "METAPROMPT (docs/governance/METAPROMPT_STANDARD.md): MP-R1 CONTEXTO=staged diff do kernel EGOS (Bun/TS, governanca rigida). MP-R2 OBJETIVO=achar bugs reais, falhas de seguranca e anti-patterns NESTE diff; aceite=cada finding com arquivo+linha. MP-R3 RESTRICOES=nao propor force-push/--no-verify; frozen zones intocaveis. MP-R4 EVIDENCIA=todo finding cita trecho do diff; sem 'parece'. MP-R5 SAIDA=lista numerada [SEVERIDADE] arquivo:linha — problema — fix sugerido; se nada: 'LGTM + 1 risco residual'. MP-R6 REGRAS=docs/governance/METAPROMPT_STANDARD.md. Se este prompt nao cumprir os requisitos, recuse apontando o arquivo de regras." > .git/CODEX_REVIEW.md 2>&1 || true
   922	  REVIEW_LINES=$(wc -l < .git/CODEX_REVIEW.md 2>/dev/null || echo 0)
   923	  echo "  [codex-review] review at .git/CODEX_REVIEW.md (${REVIEW_LINES} lines)"
   924	fi
   925	# === End Codex Review ===
   926	
   927	# [doc-sync] Enforcer code↔docs (Enio 2026-05-20)
   928	# Default = warn-only. Ative strict via: export EGOS_DOC_SYNC_STRICT=1
   929	if [ -x "scripts/pre-commit-doc-sync.sh" ]; then
   930	  bash scripts/pre-commit-doc-sync.sh ".git/COMMIT_EDITMSG" 2>&1
   931	  DOC_SYNC_EXIT=$?
   932	  if [ "$DOC_SYNC_EXIT" = "2" ]; then
   933	    echo "❌ EGOS Pre-Commit: doc-sync BLOCKED. Resolva e tente novamente."
   934	    exit 1
   935	  fi
   936	fi
   937	# === End doc-sync ===
   938	
   939	# [governance-boundary] Central EGOS: governance NUNCA em clients/<slug>/ (2026-05-21)
   940	if [ -x "scripts/pre-commit-governance-boundary.sh" ]; then

codex
The patch introduces a regression in scripts/banda.ts by blocking the previously supported `--context @file` workflow before the file is read. Other inspected changes are mostly docs/generated artifacts or small behavior changes without clear blocking bugs.

Review comment:

- [P2] Preserve legacy @file context before gating — /home/enio/egos/scripts/banda.ts:61-62
  When callers use the existing `--context @path` form, the new metaprompt gate checks the literal `@path` string before the legacy file expansion in `main()`, so valid large context files are rejected as `<200 chars`. This breaks the documented legacy path unless users set the override; expand `@` contexts before this length check or include it in `EFFECTIVE_CONTEXT`.
The patch introduces a regression in scripts/banda.ts by blocking the previously supported `--context @file` workflow before the file is read. Other inspected changes are mostly docs/generated artifacts or small behavior changes without clear blocking bugs.

Review comment:

- [P2] Preserve legacy @file context before gating — /home/enio/egos/scripts/banda.ts:61-62
  When callers use the existing `--context @path` form, the new metaprompt gate checks the literal `@path` string before the legacy file expansion in `main()`, so valid large context files are rejected as `<200 chars`. This breaks the documented legacy path unless users set the override; expand `@` contexts before this length check or include it in `EFFECTIVE_CONTEXT`.
```
