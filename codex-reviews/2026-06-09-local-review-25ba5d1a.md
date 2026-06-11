# Codex Local Review — 2026-06-09T20:09:36Z

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
session id: 019eae01-3ce7-7f20-8fac-608ab25a8464
--------
user
changes against 'HEAD~3'
2026-06-09T20:09:38.161293Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T20:09:38.164256Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff eff0b679108adc329d1f5e45e875ae54b5b01123 --stat && git diff eff0b679108adc329d1f5e45e875ae54b5b01123' in /home/enio/egos
 succeeded in 0ms:
 .github/workflows/capability-eval.yml          |  7 ++-
 .github/workflows/ci.yml                       |  7 ++-
 .github/workflows/pr-review.yml                |  1 +
 .github/workflows/security.yml                 |  7 ++-
 TASKS.md                                       | 19 +++++---
 TASKS_ARCHIVE.md                               | 12 +++++
 docs/_current_handoffs/handoff_2026-06-09.md   | 14 ++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json   |  8 ++--
 docs/jobs/2026-06-09-pre-commit-pipeline.json  | 16 +++++++
 docs/presentations/mf-certificados-piloto.html |  6 +--
 scripts/audit-phantom-done.ts                  |  5 +-
 scripts/coordination-watcher.ts                | 63 +++++++++++++++++++++++++-
 12 files changed, 147 insertions(+), 18 deletions(-)
diff --git a/.github/workflows/capability-eval.yml b/.github/workflows/capability-eval.yml
index ae19f105..a26c4ffc 100644
--- a/.github/workflows/capability-eval.yml
+++ b/.github/workflows/capability-eval.yml
@@ -38,7 +38,12 @@ jobs:
           bun-version: 1.3.9
 
       - name: Install dependencies
-        run: bun install --frozen-lockfile
+        run: |
+          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
+            bun install
+          else
+            bun install --frozen-lockfile
+          fi
 
       - name: TypeScript check
         run: bun run typecheck
diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 8837e7d0..607ecaa8 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -22,7 +22,12 @@ jobs:
           python-version: '3.11'
 
       - name: Install dependencies
-        run: bun install --frozen-lockfile
+        run: |
+          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
+            bun install
+          else
+            bun install --frozen-lockfile
+          fi
 
       - name: Session health check (/start v6.0)
         run: |
diff --git a/.github/workflows/pr-review.yml b/.github/workflows/pr-review.yml
index ab8a73c8..2e77d588 100644
--- a/.github/workflows/pr-review.yml
+++ b/.github/workflows/pr-review.yml
@@ -7,6 +7,7 @@ on:
 jobs:
   review:
     runs-on: ubuntu-latest
+    if: github.actor != 'dependabot[bot]'
     permissions:
       contents: read
       pull-requests: write
diff --git a/.github/workflows/security.yml b/.github/workflows/security.yml
index 63fb5f71..654502e7 100644
--- a/.github/workflows/security.yml
+++ b/.github/workflows/security.yml
@@ -24,7 +24,12 @@ jobs:
           bun-version: latest
 
       - name: Install dependencies
-        run: bun install --frozen-lockfile
+        run: |
+          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
+            bun install
+          else
+            bun install --frozen-lockfile
+          fi
 
       # Secret scanning with Gitleaks
       - name: Secret Detection (Gitleaks)
diff --git a/TASKS.md b/TASKS.md
index bbeb8f32..758f4748 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -16,7 +16,9 @@
 
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
 - [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
-- [ ] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Fechar o item-intake: 1 contato ao Diesom (Kyte) — "abriu a planilha? subiu no Kyte? o que faltou?". Registrar a resposta. É o `cliente_confirmou=true` mais barato do portfólio (não precisa de código).
+- [x] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — ✅ 2026-06-09: Enio enviou a mensagem ao Diesom (Kyte). Aguardando resposta do cliente; loop de contato fechado do lado EGOS.
+- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
+- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio).
 
 **MCP PESSOAL DO ENIO (em qualquer lugar, incl. ChatGPT Dev Mode) — corte Enio 2026-06-09:**
 - [ ] **MCP-PESSOAL-ENIO-001** [P1] `prime`+`forja` — Consolidar núcleo curado de tools (10-20→30) num MCP autenticado (Bearer pessoal) bridgeado p/ ChatGPT Dev Mode. Núcleo: recon, readiness, guard_scan_pii, get_metaprompt, knowledge_search, memory_store/recall + egos_capture. Curadoria em andamento (workflow `wi5x1e8ue` → docs/strategy/MCP_PESSOAL_ENIO_CURADORIA.md). NÃO é público — é pessoal autenticado.
@@ -29,11 +31,8 @@
 **Integridade phantom-done (2026-06-09 — buracos achados+corrigidos):**
 - [ ] **PHANTOM-AUDIT-WIRE-001** [P1] `forja` — Wire `scripts/audit-phantom-done.ts` (criado 754bca3b, sobrevive ao --no-verify) em `scripts/agent-sentinela.ts` + Layer de saúde do `/start`. Sem wiring = doc morto (R-CAP-001).
 - [ ] **WATCHER-STALE-ROOTCAUSE-001** [P1] `hermes-ops` — Causa-raiz do uso crônico de --no-verify: coordination-watcher fica stale e bloqueia commits legítimos → todo mundo usa --no-verify → desativa o pre-commit inteiro (incl. phantom-done). Consertar o watcher (não ficar stale / auto-restart) ELIMINA a necessidade de --no-verify. Ver feedback_phantom_done_noverify_hole.
-- [x] **SUPABASE-DISABLE-LEGACY-RECONCILE-001** [P2] — ✅ 2026-06-09: reconciliado. A task ERA real (não phantom) — executada e VERIFICADA LIVE nesta sessão (smoke 200 em 5 superfícies). Evidência completa adicionada na L138. Liga regra §10.1 (prova live = último passo obrigatório).
 
 **🛡️ PROGRAMA DE HARDENING DE REGRAS (corte Enio 2026-06-09 — generalizar a correção phantom-done a TODO o sistema):**
-- [x] **RULE-INTEGRITY-SSOT-001** [P1] `prime` — ✅ 2026-06-09: SSOT escrito em `docs/governance/INTEGRITY_PROOF_SSOT.md` (workflow wkmuupq6c). Generaliza phantom-done em sistema completo de integridade-por-prova (classe SLSA/in-toto/defense-in-depth + 17 escape-hatches mapeados + modelo fail-closed + trust boundary).
-- [x] **RULE-HARDENING-AUDIT-001** [P1] `prime` — ✅ 2026-06-09: Auditoria completa em `docs/jobs/2026-06-09-rule-hardening-audit.md` (workflow wkmuupq6c). 14 gates auditados, achado-raiz: 17 escape-hatches + 28× `|| true` fail-open + client-side only. Tasks RULE-HARDEN-001..008 priorizadas abaixo.
 - [ ] **RULE-HARDEN-BRANCHPROTECT-001** [P0] `hermes-ops` — GitHub branch protection server-side no repo `egos`: block force-push, require linear history, secret scanning push protection. Única camada não-bypassável para R0.1/R0.2 — hook local é defesa-em-profundidade, não SSOT.
 - [ ] **RULE-HARDEN-CI-GATES-001** [P0] `hermes-ops` — CI workflow (GitHub Actions) que re-roda os 4 gates críticos (gitleaks fail-closed, PII sweep history-wide, phantom-done exit 1, frozen-zone) independente de `--no-verify`. CI é a lei; hook é conveniência.
 - [ ] **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] `forja` — `ai-commit-security.ts:146` e `scan-hardcoded-sensitive.ts`: remover fail-open silencioso (`main().catch(()=>exit(0))`). Distinguir "scan limpo" de "scan crashou". Crash do scanner = BLOCK. `// scan-ok: mock` exige match de pattern sintético real (`.example.internal` ou hex construído), não auto-declarado.
@@ -42,9 +41,18 @@
 - [ ] **RULE-HARDEN-OVERRIDE-LEDGER-001** [P1] `forja` — Central override ledger: todo `EGOS_*_OVERRIDE`/`*-OVERRIDE` trailer/`--no-verify` registra em `docs/jobs/override-audit.jsonl` (espelhar hermes-block-control que já loga). `/start` mostra overrides da semana. Override sem registro = invisível hoje (11 gates sem rastro).
 - [ ] **RULE-HARDEN-DB-SMOKE-001** [P1] `forja` — Gate R-DB-002: migration/seed staged sem bloco `SELECT count … anon` final → block. Fecha INC-DB-001 (32 produtos invisíveis 12h por `is_active` silencioso) estruturalmente.
 - [ ] **RULE-HARDEN-CRON-HEARTBEAT-001** [P1] `hermes-ops` — Heartbeat para auditores cron (RLS auditor VPS, Sentinela): cron escreve `~/.egos/heartbeat/<job>.json`; ausência > 26h alerta fail-loud em pre-commit + `/start`. Fecha classe "cron morto silencioso" (root-cause INC-CTX-001 watcher stale generalizado).
-- [x] **VALIDATE-PROVENANCE-TECH-001** [P0] `provador` — Validação TÉCNICA: **4.5/5 REAL** (L1 hash, L2 evidence-chain, L4 Merkle, +PII guard = REAL; L3 PRI gate REAL com sub-camada LLM = mock injetável). Evidência: docs/jobs/2026-06-09-provenance-validation.md + telemetria ~/.egos/agent-runs/. (VALIDATE-PROVENANCE-001 segue [ ] — falta a GRAVAÇÃO do Enio.)
 - [ ] **PRI-L3-LLM-WIRE-001** [P2] `forja` — Incidental finding da validação: `layerThree` em `packages/core/src/guards/pri.ts` usa mock LLM. Injetar `llmEvaluator` real (Gemini via shared/llm-router) p/ escalação L3 ser 100% real. Injeção de dependência, não stub bloqueante.
 
+**🔬 AUDITORIA DE DISSEMINAÇÃO DA INTEGRIDADE (achados machine-wide 2026-06-09 — `/start` desta janela; classificação CONFIRMADO):**
+- [ ] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — CONFIRMADO: `.claude/settings.json` NÃO bloqueia `--no-verify` (grep=0). É o fix mais barato do SSOT §3-P0 (R=L/C altíssimo). Adicionar deny `Bash(git commit --no-verify *)` + `Bash(git commit -n *)` em settings.json + PATH shim `~/bin/git` que intercepta a flag em qualquer posição. Defesa-em-profundidade local complementar ao CI.
+- [ ] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — CONFIRMADO: o guard phantom-done do pre-commit + `audit-phantom-done.ts` vivem SÓ no kernel — `grep` em `852/.husky` e `egos-lab/.husky` = 0. A "disseminação" da 2ª metade propagou docs de governança, NÃO o enforcement de integridade aos leaves. Propagar o bloco phantom-done (pre-commit) + script audit via `disseminate-propagator.ts` aos leaves que têm TASKS.md. Prova: re-grep nos leaves após.
+- [ ] **CLAUDE-MD-INDEX-INTEGRITY-001** [P1] `prime` — CONFIRMADO: `INTEGRITY_PROOF_SSOT.md` é [T1] mas o router constitucional NÃO o indexa — `grep` em `.claude/CLAUDE.md` e `egos/CLAUDE.md` = 0 (só `AGENTS.md` cita). SSOT [T1] invisível ao router = enforcement-gap de descoberta. Adicionar 1 linha de índice em ambos os CLAUDE.md (lazy-ref, sem inflar) — liga CLAUDE-MD-SIMPLIFICADO-001.
+- [ ] **BRANCHPROTECT-PLAN-DECISION-001** [P0] `prime` `gated:HITL-Enio` — 🔴 BLOCKER CONFIRMADO: `gh api repos/enioxt/egos/branches/main/protection` → HTTP 403 "Upgrade to GitHub Pro or make this repository public". RULE-HARDEN-BRANCHPROTECT-001 (camada-4 não-bypassável) é IMPOSSÍVEL no plano atual. Decisão do Enio: (a) GitHub Pro pago, (b) tornar `egos` público (Red Zone — varredura PII/soul antes), ou (c) backstop alternativo via CI fail-closed (RULE-HARDEN-CI-GATES-001) como camada-4 de facto. Sem decisão, a camada-4 do INTEGRITY_PROOF_SSOT fica vazia.
+
+**🖥️ COMUNICAÇÃO HUMANA — HTML (pedido Enio 2026-06-09: "nessa linguagem não consigo explicar pra ninguém"):**
+- [ ] **PROVENANCE-HTML-EXPLAINER-001** [P1] `prime`+`pixel` — Explicar as 4 camadas de provenance (L1 hash · L2 evidence-chain · L3 PRI gate · L4 Merkle + PII guard) em 1 HTML autocontido para humanos (Enio + leigos), com casos de uso concretos por camada (ex: "L1 = um byte muda → hash muda → você sabe que o arquivo foi adulterado"). Seguir HTML_GENERATION_CONSTITUTION (R-HTML-001..008). Incluir a ressalva honesta L3 = mock injetável (4.5/5, não 5/5). Iterar com Enio. Fonte: docs/jobs/2026-06-09-provenance-validation.md.
+- [ ] **HTML-SSOT-ITERATE-001** [P2] `pixel`+`prime` — Loop de melhoria contínua do `HTML_GENERATION_CONSTITUTION.md`: cada HTML novo que o Enio iterar gera ≥1 regra/refinamento de volta ao SSOT (o que funcionou p/ o humano entender vira regra). Manter changelog interno de versão. R-HTML = padrão vivo, não congelado.
+
 **Regras a encodar (R-DIAG-002 a 006) — pendente corte final do Enio:** ver `project_arquiteto_diagnosticador_identity_2026-06-09` na memória. R-DIAG-002 conversa-antes-de-código; R-DIAG-003 cadeia-fecha-no-funcionou; R-DIAG-004 diagnóstico-é-produto; R-DIAG-005 anti-espelho; R-DIAG-006 sistema-sem-pessoa-30d-congela.
 
 ## 🧊 CONGELADO (R-DIAG-006 — sem feature nova até ter pessoa real do outro lado)
@@ -144,7 +152,6 @@
 - [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
 - [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
 - [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
-- [x] **SUPABASE-DISABLE-LEGACY-001** [P1] — ✅ 2026-06-09 VERIFICADO LIVE: Enio desabilitou legacy keys. Incidente INC-KEYROT-001: 5 containers VPS ainda tinham JWT legacy (eu só trocara `.env` LOCAIS, não a VPS) → gateway caiu 502. Corrigidos via VPS .env/env_file + restart: egos-gateway, egos-hq, 852-app, guard-brasil-api (eagle-eye já unhealthy pré-existente). SMOKE 200 em TODAS: gateway/knowledge/stats (539 pgs), chat-web (FAQ real), guard/health, hq.egos.ia.br, 852.egos.ia.br. Gerou regra §10.1.
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index e02d883e..5d0f2f43 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3802,3 +3802,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [x] **SECRET-ROTATION-SERVICE-ROLE-001** [P0-T0] — ✅ 2026-06-09: Enio migrou p/ novas API keys (sb_secret_/sb_publishable_). Prime trocou em 12 `.env` do projeto `lhscgsqhiooyatkebose` (anon→sb_publishable_, service_role→sb_secret_); pulou .env de OUTROS projetos (carteira-x/agent-commander/egos-.env.local). 2 scripts tracked de-hardcoded → env (9696683 + 573d3fe). JWTs legacy redacted de docs/workflow (1bfbdcc). Pre-commit hooks com prefixo eyJ = detectores (não tocar). ⚠️ FALTA PASSO MANUAL → SUPABASE-DISABLE-LEGACY-001.
 
+
+## Archived 2026-06-09
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **SUPABASE-DISABLE-LEGACY-RECONCILE-001** [P2] — ✅ 2026-06-09: reconciliado. A task ERA real (não phantom) — executada e VERIFICADA LIVE nesta sessão (smoke 200 em 5 superfícies). Evidência completa adicionada na L138. Liga regra §10.1 (prova live = último passo obrigatório).
+- [x] **RULE-INTEGRITY-SSOT-001** [P1] `prime` — ✅ 2026-06-09: SSOT escrito em `docs/governance/INTEGRITY_PROOF_SSOT.md` (workflow wkmuupq6c). Generaliza phantom-done em sistema completo de integridade-por-prova (classe SLSA/in-toto/defense-in-depth + 17 escape-hatches mapeados + modelo fail-closed + trust boundary).
+- [x] **RULE-HARDENING-AUDIT-001** [P1] `prime` — ✅ 2026-06-09: Auditoria completa em `docs/jobs/2026-06-09-rule-hardening-audit.md` (workflow wkmuupq6c). 14 gates auditados, achado-raiz: 17 escape-hatches + 28× `|| true` fail-open + client-side only. Tasks RULE-HARDEN-001..008 priorizadas abaixo.
+- [x] **VALIDATE-PROVENANCE-TECH-001** [P0] `provador` — Validação TÉCNICA: **4.5/5 REAL** (L1 hash, L2 evidence-chain, L4 Merkle, +PII guard = REAL; L3 PRI gate REAL com sub-camada LLM = mock injetável). Evidência: docs/jobs/2026-06-09-provenance-validation.md + telemetria ~/.egos/agent-runs/. (VALIDATE-PROVENANCE-001 segue [ ] — falta a GRAVAÇÃO do Enio.)
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **SUPABASE-DISABLE-LEGACY-001** [P1] — ✅ 2026-06-09 VERIFICADO LIVE: Enio desabilitou legacy keys. Incidente INC-KEYROT-001: 5 containers VPS ainda tinham JWT legacy (eu só trocara `.env` LOCAIS, não a VPS) → gateway caiu 502. Corrigidos via VPS .env/env_file + restart: egos-gateway, egos-hq, 852-app, guard-brasil-api (eagle-eye já unhealthy pré-existente). SMOKE 200 em TODAS: gateway/knowledge/stats (539 pgs), chat-web (FAQ real), guard/health, hq.egos.ia.br, 852.egos.ia.br. Gerou regra §10.1.
+
diff --git a/docs/_current_handoffs/handoff_2026-06-09.md b/docs/_current_handoffs/handoff_2026-06-09.md
index 3430b34b..ca1000d5 100644
--- a/docs/_current_handoffs/handoff_2026-06-09.md
+++ b/docs/_current_handoffs/handoff_2026-06-09.md
@@ -28,6 +28,20 @@
 ## Decisions Made (architectural)
 - Identidade = arquiteto-diagnosticador (não para de construir; constrói só a PROVA, escala por parceria/indicação)
 - NAO enterprise — começar pequeno (GPT gratuito pequenos diagnósticos esquenta lead)
+
+## 🛡️ 2ª METADE — Disseminação + Hardening de Integridade (SHAs)
+- /disseminate: governança propagada a 8 leaves + mirrors (drift=0). santiago/egos-self = repos local-only sem GitHub (não falha)
+- Phantom-done pego: VALIDATE-PROVENANCE-001 marcada [x] sem execução → revertida `9af9c0d4`
+- Gate phantom-done: 2 buracos corrigidos (--no-verify pula tudo / regex contava .ts como prova) — `754bca3b` + audit-phantom-done.ts (2ª camada)
+- Fix do próprio audit (EGOS_ROOT stale → fail-open) — `d44f9c57`
+- Validação provenance 4.5/5 REAL — `230f8f29` (docs/jobs/2026-06-09-provenance-validation.md)
+- INTEGRITY_PROOF_SSOT [T1] + auditoria 17 escape-hatches/28 fail-open + 8 RULE-HARDEN — `eff0b679`
+
+### Next (próxima janela) — 3 P0 do hardening = contra-veneno ao --no-verify:
+1. RULE-HARDEN-BRANCHPROTECT-001 — GitHub branch protection server-side
+2. RULE-HARDEN-CI-GATES-001 — CI re-roda gates críticos (não-bypassável)
+3. RULE-HARDEN-AISECURITY-FAILCLOSED-001 — ai-security fail-open removido
+Depois: VALIDATE-PROVENANCE-001 (gravação Enio, desktop), CLAUDE-MD-SIMPLIFICADO-001, MCP-PESSOAL-ENIO-001 build.
 - Princípio da Ponte Simples: complexo=laboratório, simples=ponte
 - GPT por link = Actions (não MCP); MCP customizado fica backend pro Enio. Actions+Bearer PROVADO (g-pecas)
 - MCP pessoal: 1 endpoint consolidado, egos_capture fora-do-repo (_pending), web_fetch allowlist+SSRF+sessão
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index d3c4a3fa..bfd34df5 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T18:12:56.852Z",
+  "verified_at": "2026-06-09T20:09:18.791Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -50,9 +50,9 @@
       "description": "User-invocable slash commands in .claude/commands/",
       "status": "ok",
       "last_value": "61",
-      "current_value": "63",
+      "current_value": "64",
       "tolerance": "±5",
-      "drift_abs": 2,
+      "drift_abs": 3,
       "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1294",
+      "current_value": "1325",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index 322aa933..6dc3bf68 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -190,5 +190,21 @@
     "duration_ms": null,
     "event": "commit:docs files=1 sha=2def6c69",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T20:00:42.395Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=92e674cb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T20:09:20.405Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=7 sha=25ba5d1a",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index 14c74dd5..8f660506 100644
--- a/docs/presentations/mf-certificados-piloto.html
+++ b/docs/presentations/mf-certificados-piloto.html
@@ -293,14 +293,14 @@ tr:hover td { background: var(--bg); }
     <span class="badge badge-green">REAL</span>
   </div>
   <div class="card-body">
-    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Tudo abaixo funciona hoje no cliente G Peças. Para a MF Certificados, configuramos um novo tenant — sem reescrever código.</p>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">A arquitetura abaixo está em produção hoje atendendo o cliente G Peças pelo <strong>storefront web</strong> (gpecas.egos.ia.br). A mesma base serve novos canais por configuração — para a MF Certificados, configuramos um novo tenant sem reescrever código.</p>
 
     <div class="timeline">
       <div class="tl-item">
         <div class="tl-dot tl-dot-green">✓</div>
         <div class="tl-label">Infraestrutura</div>
-        <div class="tl-title">Gateway WhatsApp (Evolution API + EGOS)</div>
-        <div class="tl-desc">Recebe mensagens, processa em fila ordenada, responde com formatação adequada. Suporta texto, áudio e documentos.</div>
+        <div class="tl-title">Gateway de atendimento (web em produção · WhatsApp em validação)</div>
+        <div class="tl-desc">O agente atende hoje pelo canal web do G Peças. O canal WhatsApp (Evolution API) está construído na mesma base — multi-tenant, fila ordenada, texto/áudio/documentos — e a conexão da sessão é uma etapa de implantação, não código novo.</div>
       </div>
 
       <div class="tl-item">
diff --git a/scripts/audit-phantom-done.ts b/scripts/audit-phantom-done.ts
index 81693d05..bf9bc8a0 100644
--- a/scripts/audit-phantom-done.ts
+++ b/scripts/audit-phantom-done.ts
@@ -19,7 +19,10 @@ import { join } from "path";
 
 // --- Config ------------------------------------------------------------------
 
-const REPO_ROOT = process.env.EGOS_ROOT ?? join(import.meta.dir, "..");
+// O script vive em <repo>/scripts/ → import.meta.dir/.. é SEMPRE o repo correto.
+// NÃO usar process.env.EGOS_ROOT como primário: pode estar stale (apontava /home/enio/EGOSv2)
+// e fazia o audit silenciosamente não rodar (fail-open na própria rede de segurança).
+const REPO_ROOT = join(import.meta.dir, "..");
 
 function resolveTasksPath(): string {
   const argIdx = process.argv.indexOf("--tasks");
diff --git a/scripts/coordination-watcher.ts b/scripts/coordination-watcher.ts
index a73ab3be..1ec6a4b7 100755
--- a/scripts/coordination-watcher.ts
+++ b/scripts/coordination-watcher.ts
@@ -7,7 +7,7 @@
  * to a shared blackboard in /tmp, preventing conflicts between parallel agents.
  */
 
-import { writeFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
+import { writeFileSync, readFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
 import { execSync } from 'node:child_process';
 import { resolve } from 'node:path';
 import { homedir } from 'node:os';
@@ -142,6 +142,39 @@ Be precise and avoid fluff.`;
     const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
     console.error(`[COORDINATION] Failed to analyze changes: ${err.message}`);
 
+    // WATCHER-STALE-ROOTCAUSE-001: o batimento (timestamp) NÃO pode depender do LLM.
+    // Se a análise LLM falha (ex: modelo 404), ainda escrevemos um blackboard degradado
+    // com timestamp fresco — senão o watcher parece morto, o pre-commit bloqueia e todos
+    // caem no --no-verify (a doença-raiz do INC-2026-06-09). Análise é enriquecimento; o
+    // heartbeat é crítico. Fail-safe, não fail-open.
+    const degradedJson = {
+      timestamp: new Date().toISOString(),
+      head: headSha,
+      branch: branchName,
+      status: 'dirty',
+      summary: `⚠️ Watcher VIVO; análise LLM indisponível (${err.message?.slice(0, 120)}). Heartbeat mantido.`,
+      rawStatus: status,
+      analysisDegraded: true,
+    };
+    const degradedMd = [
+      `# 📋 EGOS Live Coordination Blackboard`,
+      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+      `*Commit HEAD: ${headSha}*`,
+      `*Ramo (Branch): ${branchName}*`,
+      `\n---`,
+      `🟡 **Watcher VIVO — análise LLM indisponível.** Heartbeat preservado (commits não serão bloqueados por stale).`,
+      `\nErro: ${err.message}`,
+    ].join('\n');
+    try {
+      writeFileSync(VOLATILE_BLACKBOARD_MD, degradedMd, 'utf8');
+      writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
+      writeFileSync(PERSISTENT_BLACKBOARD_MD, degradedMd, 'utf8');
+      writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
+      console.log(`[COORDINATION] Blackboard mantido em modo degradado (heartbeat fresco).`);
+    } catch (writeErr: any) {
+      console.error(`[COORDINATION] Falha ao escrever heartbeat degradado: ${writeErr.message}`);
+    }
+
     logTelemetry({
       timestamp: new Date().toISOString(),
       status: 'error',
@@ -201,6 +234,29 @@ function writeCleanState() {
   });
 }
 
+/**
+ * Heartbeat incondicional (WATCHER-STALE-ROOTCAUSE-001). Refresca apenas o timestamp do
+ * blackboard persistente — preservando o último summary — para que um daemon VIVO num
+ * workspace quieto nunca apareça stale ao pre-commit. Barato (read+write 1 JSON pequeno).
+ */
+function touchHeartbeat() {
+  try {
+    let json: Record<string, any> = {};
+    if (existsSync(PERSISTENT_BLACKBOARD_JSON)) {
+      try { json = JSON.parse(readFileSync(PERSISTENT_BLACKBOARD_JSON, 'utf8')); } catch { json = {}; }
+    }
+    json.timestamp = new Date().toISOString();
+    if (!json.head) json.head = sh('git rev-parse --short HEAD', REPO_ROOT);
+    if (!json.branch) json.branch = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+    if (!json.status) json.status = 'clean';
+    if (!json.summary) json.summary = '🟢 Heartbeat (sem mudanças).';
+    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
+    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
+  } catch (e: any) {
+    console.error(`[COORDINATION] touchHeartbeat falhou: ${e.message}`);
+  }
+}
+
 async function checkWorkspace() {
   const status = sh('git status --porcelain', REPO_ROOT);
   
@@ -241,6 +297,11 @@ async function main() {
     } catch (e: any) {
       console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
     }
+    // WATCHER-STALE-ROOTCAUSE-001: heartbeat incondicional. checkWorkspace() faz early-return
+    // quando o status não muda (e writeCleanState/runAnalysis só escrevem em mudança), então um
+    // workspace quieto deixaria o timestamp envelhecer >120s → pre-commit bloqueia falsamente.
+    // O batimento de vida do daemon precisa ser independente de mudança de arquivos e de LLM.
+    touchHeartbeat();
     await new Promise((r) => setTimeout(r, 15000));
   }
 }

exec
/bin/bash -lc "sed -n '1,340p' scripts/coordination-watcher.ts && echo '--- audit ---' && sed -n '1,220p' scripts/audit-phantom-done.ts && echo '--- workflows ---' && sed -n '1,120p' .github/workflows/security.yml && sed -n '1,80p' .github/workflows/ci.yml" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * EGOS Coherence & Coordination Blackboard Watcher [GUARANI-006]
 * 
 * Runs as a background daemon to monitor local git status and diffs.
 * Leverages free-tier LLM models to organize changes and post them
 * to a shared blackboard in /tmp, preventing conflicts between parallel agents.
 */

import { writeFileSync, readFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
import { execSync } from 'node:child_process';
import { resolve } from 'node:path';
import { homedir } from 'node:os';
import { config } from 'dotenv';
import { chatWithLLM } from '../packages/shared/src/llm-provider';

config({ override: true });

const REPO_ROOT = resolve(import.meta.dir, '..');
const VOLATILE_BLACKBOARD_JSON = '/tmp/egos-live-blackboard.json';
const VOLATILE_BLACKBOARD_MD = '/tmp/egos-live-blackboard.md';

const EGOS_DIR = resolve(homedir(), '.egos');
if (!existsSync(EGOS_DIR)) {
  mkdirSync(EGOS_DIR, { recursive: true });
}

const PERSISTENT_BLACKBOARD_JSON = resolve(EGOS_DIR, 'coordination-blackboard.json');
const PERSISTENT_BLACKBOARD_MD = resolve(EGOS_DIR, 'coordination-blackboard.md');
const TELEMETRY_HISTORY_JSONL = resolve(EGOS_DIR, 'coordination-history.jsonl');

let lastStatusString = '';

function sh(cmd: string, cwd: string): string {
  try {
    return execSync(cmd, { cwd, encoding: 'utf8', timeout: 10000 }).trim();
  } catch (e) {
    return '';
  }
}

function logTelemetry(event: {
  timestamp: string;
  status: 'clean' | 'dirty' | 'error';
  head: string;
  branch: string;
  changedFilesCount: number;
  modelUsed: string | null;
  tokensUsed: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  } | null;
  costUsd: number | null;
  latencyMs: number;
  error?: string;
}) {
  try {
    appendFileSync(TELEMETRY_HISTORY_JSONL, JSON.stringify(event) + '\n', 'utf8');
  } catch (err: any) {
    console.error(`[COORDINATION] Failed to write telemetry: ${err.message}`);
  }
}

async function runAnalysis(status: string, diff: string, commits: string) {
  console.log(`[COORDINATION] Changes detected. Invoking AI summary...`);
  const startTime = Date.now();
  
  const systemPrompt = `You are the EGOS Coherence & Coordination Monitor. 
Analyze the current workspace modifications (git status, recent commits, and file diffs).
Your goal is to compile a clean, highly technical blackboard summary to coordinate between parallel AI agents.
Identify:
1. Files modified/added/deleted.
2. High-level technical impact of the changes (what was implemented/fixed).
3. Potential conflicts (e.g. changes in package.json, configuration files, or database schemas).
4. Recommended validation commands (e.g. tsc, bun test, etc.) or alignment instructions.

Answer in a concise, bulleted markdown format in Portuguese (PT-BR) as this is used by Enio and the agents locally. 
Be precise and avoid fluff.`;

  const userPrompt = JSON.stringify({
    timestamp: new Date().toISOString(),
    gitStatus: status,
    gitDiff: diff.slice(0, 4000), // Cap at 4k chars to avoid token bloat
    recentCommits: commits,
  }, null, 2);

  try {
    const result = await chatWithLLM({
      tier: 'fast',
      temperature: 0.1,
      maxTokens: 1000,
      systemPrompt,
      userPrompt,
    });
    const latencyMs = Date.now() - startTime;
    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);

    const markdownContent = [
      `# 📋 EGOS Live Coordination Blackboard`,
      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
      `*Commit HEAD: ${headSha}*`,
      `*Ramo (Branch): ${branchName}*`,
      `\n---`,
      result.content,
    ].join('\n');

    const jsonContent = {
      timestamp: new Date().toISOString(),
      head: headSha,
      branch: branchName,
      status: 'dirty',
      summary: result.content,
      rawStatus: status,
    };

    // Write to volatile
    writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');

    // Write to persistent
    writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
    console.log(`[COORDINATION] Blackboard successfully updated (both /tmp and ~/.egos).`);

    const changedFilesCount = status ? status.split('\n').filter(Boolean).length : 0;
    logTelemetry({
      timestamp: new Date().toISOString(),
      status: 'dirty',
      head: headSha,
      branch: branchName,
      changedFilesCount,
      modelUsed: result.model || 'unknown',
      tokensUsed: result.usage || null,
      costUsd: result.cost_usd ?? null,
      latencyMs,
    });
  } catch (err: any) {
    const latencyMs = Date.now() - startTime;
    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
    console.error(`[COORDINATION] Failed to analyze changes: ${err.message}`);

    // WATCHER-STALE-ROOTCAUSE-001: o batimento (timestamp) NÃO pode depender do LLM.
    // Se a análise LLM falha (ex: modelo 404), ainda escrevemos um blackboard degradado
    // com timestamp fresco — senão o watcher parece morto, o pre-commit bloqueia e todos
    // caem no --no-verify (a doença-raiz do INC-2026-06-09). Análise é enriquecimento; o
    // heartbeat é crítico. Fail-safe, não fail-open.
    const degradedJson = {
      timestamp: new Date().toISOString(),
      head: headSha,
      branch: branchName,
      status: 'dirty',
      summary: `⚠️ Watcher VIVO; análise LLM indisponível (${err.message?.slice(0, 120)}). Heartbeat mantido.`,
      rawStatus: status,
      analysisDegraded: true,
    };
    const degradedMd = [
      `# 📋 EGOS Live Coordination Blackboard`,
      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
      `*Commit HEAD: ${headSha}*`,
      `*Ramo (Branch): ${branchName}*`,
      `\n---`,
      `🟡 **Watcher VIVO — análise LLM indisponível.** Heartbeat preservado (commits não serão bloqueados por stale).`,
      `\nErro: ${err.message}`,
    ].join('\n');
    try {
      writeFileSync(VOLATILE_BLACKBOARD_MD, degradedMd, 'utf8');
      writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
      writeFileSync(PERSISTENT_BLACKBOARD_MD, degradedMd, 'utf8');
      writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
      console.log(`[COORDINATION] Blackboard mantido em modo degradado (heartbeat fresco).`);
    } catch (writeErr: any) {
      console.error(`[COORDINATION] Falha ao escrever heartbeat degradado: ${writeErr.message}`);
    }

    logTelemetry({
      timestamp: new Date().toISOString(),
      status: 'error',
      head: headSha,
      branch: branchName,
      changedFilesCount: status ? status.split('\n').filter(Boolean).length : 0,
      modelUsed: null,
      tokensUsed: null,
      costUsd: null,
      latencyMs,
      error: err.message,
    });
  }
}

function writeCleanState() {
  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
  
  const markdownContent = [
    `# 📋 EGOS Live Coordination Blackboard`,
    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
    `*Commit HEAD: ${headSha}*`,
    `*Ramo (Branch): ${branchName}*`,
    `\n---`,
    `🟢 **Ecosystem is CLEAN.** Nenhum arquivo modificado ou não-rastreado detectado localmente.`,
  ].join('\n');

  const jsonContent = {
    timestamp: new Date().toISOString(),
    head: headSha,
    branch: branchName,
    status: 'clean',
    summary: '🟢 Ecosystem is CLEAN. No local changes.',
    rawStatus: '',
  };

  // Write to volatile
  writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');

  // Write to persistent
  writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
  console.log(`[COORDINATION] Blackboard marked clean (both /tmp and ~/.egos).`);

  logTelemetry({
    timestamp: new Date().toISOString(),
    status: 'clean',
    head: headSha,
    branch: branchName,
    changedFilesCount: 0,
    modelUsed: null,
    tokensUsed: null,
    costUsd: null,
    latencyMs: 0,
  });
}

/**
 * Heartbeat incondicional (WATCHER-STALE-ROOTCAUSE-001). Refresca apenas o timestamp do
 * blackboard persistente — preservando o último summary — para que um daemon VIVO num
 * workspace quieto nunca apareça stale ao pre-commit. Barato (read+write 1 JSON pequeno).
 */
function touchHeartbeat() {
  try {
    let json: Record<string, any> = {};
    if (existsSync(PERSISTENT_BLACKBOARD_JSON)) {
      try { json = JSON.parse(readFileSync(PERSISTENT_BLACKBOARD_JSON, 'utf8')); } catch { json = {}; }
    }
    json.timestamp = new Date().toISOString();
    if (!json.head) json.head = sh('git rev-parse --short HEAD', REPO_ROOT);
    if (!json.branch) json.branch = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
    if (!json.status) json.status = 'clean';
    if (!json.summary) json.summary = '🟢 Heartbeat (sem mudanças).';
    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
  } catch (e: any) {
    console.error(`[COORDINATION] touchHeartbeat falhou: ${e.message}`);
  }
}

async function checkWorkspace() {
  const status = sh('git status --porcelain', REPO_ROOT);
  
  if (status === lastStatusString) {
    return; // No change in file status
  }
  
  lastStatusString = status;

  if (!status) {
    console.log(`[COORDINATION] Workspace is clean.`);
    writeCleanState();
    return;
  }

  const diff = sh('git diff --no-color', REPO_ROOT);
  const commits = sh('git log -n 5 --oneline', REPO_ROOT);
  
  await runAnalysis(status, diff, commits);
}

async function main() {
  console.log(`[COORDINATION] Starting background watcher on ${REPO_ROOT}...`);
  
  // Run an immediate check on startup
  await checkWorkspace();
  
  // Listen for SIGINT
  process.on('SIGINT', () => {
    console.log(`\n[COORDINATION] Watcher shutting down.`);
    process.exit(0);
  });

  // Watch loop every 15 seconds
  while (true) {
    try {
      await checkWorkspace();
    } catch (e: any) {
      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
    }
    // WATCHER-STALE-ROOTCAUSE-001: heartbeat incondicional. checkWorkspace() faz early-return
    // quando o status não muda (e writeCleanState/runAnalysis só escrevem em mudança), então um
    // workspace quieto deixaria o timestamp envelhecer >120s → pre-commit bloqueia falsamente.
    // O batimento de vida do daemon precisa ser independente de mudança de arquivos e de LLM.
    touchHeartbeat();
    await new Promise((r) => setTimeout(r, 15000));
  }
}

main();
--- audit ---
#!/usr/bin/env bun
/**
 * audit-phantom-done.ts — Segunda camada de detecção de phantom-done
 *
 * Sobrevive a `git commit --no-verify` porque roda DEPOIS, independente do commit.
 * Varre TASKS.md (working-tree, não só staged) procurando linhas `- [x]` sem
 * evidência verificável: SHA hex (7-40 chars), Closes/Fixes/Resolves, PR #, ou URL.
 *
 * Exit 0 sempre (warn-only — NÃO bloqueia).
 * Saída: "0 phantom-done" ou lista das linhas suspeitas.
 *
 * wire: adicionar a scripts/agent-sentinela.ts e ao /start Layer de saúde
 *
 * Uso: bun scripts/audit-phantom-done.ts [--tasks <caminho>]
 */

import { readFileSync, existsSync } from "fs";
import { join } from "path";

// --- Config ------------------------------------------------------------------

// O script vive em <repo>/scripts/ → import.meta.dir/.. é SEMPRE o repo correto.
// NÃO usar process.env.EGOS_ROOT como primário: pode estar stale (apontava /home/enio/EGOSv2)
// e fazia o audit silenciosamente não rodar (fail-open na própria rede de segurança).
const REPO_ROOT = join(import.meta.dir, "..");

function resolveTasksPath(): string {
  const argIdx = process.argv.indexOf("--tasks");
  if (argIdx !== -1 && process.argv[argIdx + 1]) {
    return process.argv[argIdx + 1];
  }
  return join(REPO_ROOT, "TASKS.md");
}

// Regex de evidência (espelha o gate do pre-commit pós-fix BURACO-2):
//   - SHA hex 7-40 chars (word-boundary para não pegar hashes em nomes de arquivos parciais)
//   - Closes / Fixes / Resolves (conventional commit trailers)
//   - PR # (pull-request reference)
//   - URL (http:// ou https://)
//   - palavra "commit" seguida de espaço (ex: "commit abc1234")
const EVIDENCE_RE =
  /\b[0-9a-f]{7,40}\b|Closes|Fixes|Resolves|PR #|https?:\/\/|commit /;

// --- Main --------------------------------------------------------------------

function main(): void {
  const tasksPath = resolveTasksPath();

  if (!existsSync(tasksPath)) {
    console.log(`audit-phantom-done: TASKS.md não encontrado em ${tasksPath}`);
    process.exit(0);
  }

  const lines = readFileSync(tasksPath, "utf-8").split("\n");
  const phantoms: Array<{ lineNo: number; text: string; reason: string }> = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (!line.startsWith("- [x]")) continue;

    if (!EVIDENCE_RE.test(line)) {
      phantoms.push({
        lineNo: i + 1,
        text: line.slice(0, 120),
        reason: "sem SHA hex, Closes/Fixes/Resolves, PR #, URL ou 'commit <sha>'",
      });
    }
  }

  if (phantoms.length === 0) {
    console.log("audit-phantom-done: 0 phantom-done(s) encontrado(s) em TASKS.md");
    process.exit(0);
  }

  console.log(
    `audit-phantom-done: ${phantoms.length} phantom-done(s) encontrado(s) em TASKS.md`
  );
  console.log(
    "  Uma task [x] precisa de: SHA hex (7-40 chars), Closes/Fixes/Resolves, PR #, URL ou 'commit <sha>'"
  );
  console.log("");

  for (const p of phantoms) {
    console.log(`  L${p.lineNo}: ${p.text}`);
    console.log(`         ^ ${p.reason}`);
    console.log("");
  }

  console.log(
    "  Acao: adicione evidencia na linha OU reabra [ ] se nao foi executada."
  );
  console.log(
    "  wire: adicionar a scripts/agent-sentinela.ts e ao /start Layer de saude"
  );
  // Exit 0 — warn-only, nunca bloqueia
  process.exit(0);
}

main();
--- workflows ---
name: Security Audit

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    # Daily security scan at 06:00 BRT
    - cron: '0 9 * * *'

jobs:
  security-scan:
    name: Security Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for secret scanning

      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - name: Install dependencies
        run: |
          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
            bun install
          else
            bun install --frozen-lockfile
          fi

      # Secret scanning with Gitleaks
      - name: Secret Detection (Gitleaks)
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # required since gitleaks-action v2 breaking change 2026-05
          GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }}
        with:
          config-path: .gitleaks.toml

      # Dependency vulnerability check
      - name: Dependency Audit
        run: |
          echo "🔍 Checking for known vulnerabilities..."
          # Bun doesn't have native audit, check for overrides
          if grep -q "overrides" package.json 2>/dev/null; then
            echo "⚠️  Security overrides detected in package.json"
            cat package.json | grep -A 10 '"overrides"'
          fi
          
          # Check for known vulnerable patterns in lockfile
          echo "📋 Checking lockfile for suspicious versions..."
          
          # axios: check for CVE-2023-45857, CVE-2024-39353
          if grep -q '"axios@1.1[0-6]\.' bun.lock 2>/dev/null; then
            echo "❌ CRITICAL: axios version vulnerable to XSS/CSRF detected"
            echo "   Fix: bun update axios@latest"
            exit 1
          fi
          
          # cross-spawn: check for CVE-2024-21538
          if grep -q '"cross-spawn@7\.0\.[0-5]"' bun.lock 2>/dev/null; then
            echo "❌ HIGH: cross-spawn vulnerable to prototype pollution"
            echo "   Fix: bun update cross-spawn@latest"
            exit 1
          fi
          
          # semver: check for ReDoS vulnerabilities
          if grep -q '"semver@6\.[0-2]\.' bun.lock 2>/dev/null || \
             grep -q '"semver@7\.[0-4]\.' bun.lock 2>/dev/null; then
            echo "⚠️  MODERATE: semver may have ReDoS vulnerability"
            echo "   Fix: bun update semver@latest"
          fi
          
          echo "✅ Dependency security check complete"

      # TypeScript type safety check
      - name: Type Safety Check
        run: |
          echo "🔍 Checking for implicit 'any' types..."
          ANY_COUNT=$(bun run typecheck 2>&1 | grep -c "implicitly has an 'any'" || echo "0")
          echo "Implicit any count: $ANY_COUNT"
          if [ "$ANY_COUNT" -gt 150 ]; then
            echo "⚠️  Warning: High number of implicit any types ($ANY_COUNT > 150)"
          fi

      # Check for security-related TODOs
      - name: Security TODO Audit
        run: |
          echo "🔍 Checking for security-related TODOs..."
          SEC_TODOS=$(grep -r "TODO.*security\|FIXME.*security\|TODO.*CVE\|FIXME.*vuln" --include="*.ts" --include="*.js" . 2>/dev/null | wc -l)
          echo "Security TODOs found: $SEC_TODOS"
          if [ "$SEC_TODOS" -gt 0 ]; then
            echo "⚠️  Security-related TODOs detected:"
            grep -r "TODO.*security\|FIXME.*security\|TODO.*CVE\|FIXME.*vuln" --include="*.ts" --include="*.js" . 2>/dev/null || true
          fi

      # SSOT validation
      - name: SSOT Security Validation
        run: |
          echo "🔍 Validating SSOT consistency..."
          bun run ssot:check

  dependabot-sync:
    name: Dependabot Alert Check
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'
    steps:
      - uses: actions/checkout@v4

      - name: Check Dependabot Alerts
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          echo "🔍 Checking open Dependabot alerts..."
          
          # Query GitHub API for open Dependabot alerts
          ALERTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
name: EGOS CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    name: Validate
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - uses: actions/setup-python@v6
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
            bun install
          else
            bun install --frozen-lockfile
          fi

      - name: Session health check (/start v6.0)
        run: |
          HEALTH=$(bun scripts/start-v6.ts --json)
          echo "$HEALTH" | jq '.'
          GATES_PASS=$(echo "$HEALTH" | jq -r '.validation.gates_pass')
          if [ "$GATES_PASS" != "true" ]; then
            echo "❌ Health gates failed:"
            echo "$HEALTH" | jq '.blockers'
            exit 1
          fi
          echo "✅ System health validated"

      - name: TypeScript check
        run: bun run typecheck

      - name: Cross-tenant security tests (GUARD-CROSS-TENANT-001)
        if: env.SUPABASE_URL != '' && env.SUPABASE_SERVICE_ROLE_KEY != ''
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
        run: |
          echo "Running cross-tenant isolation tests..."
          bun test tests/security/cross-tenant.test.ts --timeout=30000 || {
            echo "⚠️  Cross-tenant tests failed or skipped (vars may be absent)"
            exit 0
          }

      - name: Karpathy Gate K1 — Banned Absolutes check
        run: |
          echo "Checking for banned absolute claims in copy files..."
          # Scan all staged-like files (full repo scan in CI)
          BANNED_PATTERN='100%|perfeito|garantido|infalível|infalivel|único no Brasil|unico no Brasil|primeiro do Brasil|sem erros'
          FOUND=$(grep -rniE "$BANNED_PATTERN" \
            --include="*.md" --include="*.html" --include="*.jsx" --include="*.tsx" \
            --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=_archived \
            --exclude-dir=dist --exclude-dir=.next \
            . 2>/dev/null | grep -v "EGOS_BANNED_SKIP\|check-banned-words\|BANNED_PATTERN\|GATES.md\|HARVEST.md\|CLAUDE.md\|karpathy-principles" || true)
          if [ -n "$FOUND" ]; then
            echo "⚠️  WARN — Banned absolute claims detected (Karpathy Doctrine A53):"
            echo "$FOUND" | head -20
            echo "See .guarani/orchestration/GATES.md K1 for remediation."
            # Warn only in CI (strict enforced locally via pre-commit)
          else
            echo "✅ No banned absolutes detected."
          fi

      - name: Karpathy Gate K5 — CAP-MODULAR check
        run: |

exec
/bin/bash -lc "grep -R \"coordination-blackboard\\|egos-live-blackboard\\|BLACKBOARD\\|stale\" -n .husky scripts | head -80" in /home/enio/egos
 succeeded in 138ms:
exec
/bin/bash -lc "sed -n '75,135p' .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:
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

exec
/bin/bash -lc "nl -ba scripts/coordination-watcher.ts | sed -n '236,258p'" in /home/enio/egos
 succeeded in 0ms:
   236	
   237	/**
   238	 * Heartbeat incondicional (WATCHER-STALE-ROOTCAUSE-001). Refresca apenas o timestamp do
   239	 * blackboard persistente — preservando o último summary — para que um daemon VIVO num
   240	 * workspace quieto nunca apareça stale ao pre-commit. Barato (read+write 1 JSON pequeno).
   241	 */
   242	function touchHeartbeat() {
   243	  try {
   244	    let json: Record<string, any> = {};
   245	    if (existsSync(PERSISTENT_BLACKBOARD_JSON)) {
   246	      try { json = JSON.parse(readFileSync(PERSISTENT_BLACKBOARD_JSON, 'utf8')); } catch { json = {}; }
   247	    }
   248	    json.timestamp = new Date().toISOString();
   249	    if (!json.head) json.head = sh('git rev-parse --short HEAD', REPO_ROOT);
   250	    if (!json.branch) json.branch = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
   251	    if (!json.status) json.status = 'clean';
   252	    if (!json.summary) json.summary = '🟢 Heartbeat (sem mudanças).';
   253	    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
   254	    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
   255	  } catch (e: any) {
   256	    console.error(`[COORDINATION] touchHeartbeat falhou: ${e.message}`);
   257	  }
   258	}

exec
/bin/bash -lc "nl -ba scripts/coordination-watcher.ts | sed -n '286,304p'" in /home/enio/egos
 succeeded in 0ms:
   286	  
   287	  // Listen for SIGINT
   288	  process.on('SIGINT', () => {
   289	    console.log(`\n[COORDINATION] Watcher shutting down.`);
   290	    process.exit(0);
   291	  });
   292	
   293	  // Watch loop every 15 seconds
   294	  while (true) {
   295	    try {
   296	      await checkWorkspace();
   297	    } catch (e: any) {
   298	      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
   299	    }
   300	    // WATCHER-STALE-ROOTCAUSE-001: heartbeat incondicional. checkWorkspace() faz early-return
   301	    // quando o status não muda (e writeCleanState/runAnalysis só escrevem em mudança), então um
   302	    // workspace quieto deixaria o timestamp envelhecer >120s → pre-commit bloqueia falsamente.
   303	    // O batimento de vida do daemon precisa ser independente de mudança de arquivos e de LLM.
   304	    touchHeartbeat();

exec
/bin/bash -lc "nl -ba .github/workflows/ci.yml | sed -n '18,30p'; nl -ba .github/workflows/capability-eval.yml | sed -n '34,46p'; nl -ba .github/workflows/security.yml | sed -n '20,32p'" in /home/enio/egos
 succeeded in 0ms:
    18	          bun-version: latest
    19	
    20	      - uses: actions/setup-python@v6
    21	        with:
    22	          python-version: '3.11'
    23	
    24	      - name: Install dependencies
    25	        run: |
    26	          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
    27	            bun install
    28	          else
    29	            bun install --frozen-lockfile
    30	          fi
    34	
    35	      - name: Setup Bun
    36	        uses: oven-sh/setup-bun@v1
    37	        with:
    38	          bun-version: 1.3.9
    39	
    40	      - name: Install dependencies
    41	        run: |
    42	          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
    43	            bun install
    44	          else
    45	            bun install --frozen-lockfile
    46	          fi
    20	
    21	      - name: Setup Bun
    22	        uses: oven-sh/setup-bun@v2
    23	        with:
    24	          bun-version: latest
    25	
    26	      - name: Install dependencies
    27	        run: |
    28	          if [ "${{ github.actor }}" = "dependabot[bot]" ]; then
    29	            bun install
    30	          else
    31	            bun install --frozen-lockfile
    32	          fi

codex
The patch introduces CI behavior that can validate Dependabot PRs against uncommitted lockfile changes, and the watcher heartbeat can mask stale blackboard content as fresh. These are actionable regressions in correctness of validation/coordination.

Full review comments:

- [P2] Keep lockfile checks for Dependabot installs — /home/enio/egos/.github/workflows/ci.yml:26-29
  For Dependabot-triggered PRs, this runs plain `bun install`, which can regenerate or otherwise accept a lockfile that is not committed in the PR. In the common case where Dependabot changes `package.json` but `bun.lock` is stale or missing an update, all required checks can pass against an ephemeral lockfile, while the repository still contains the old lockfile and later non-Dependabot installs with `--frozen-lockfile` fail or test a different dependency graph. Prefer keeping `--frozen-lockfile` in CI and fixing Dependabot's lockfile update path separately.

- [P2] Recompute blackboard before refreshing heartbeat — /home/enio/egos/scripts/coordination-watcher.ts:248-253
  When the workspace status string is unchanged, or when the watcher starts while the repo is clean and an old `~/.egos/coordination-blackboard.json` already exists, this only refreshes the timestamp while preserving the previous `head`, `status`, and `summary`. Because the pre-commit gate only checks timestamp age, a stale/degraded/cross-repo blackboard is now treated as healthy indefinitely, masking the same coordination-stale state this change is meant to fix. The heartbeat should be written with freshly computed repo state, or only after `checkWorkspace()` has produced a current blackboard.
The patch introduces CI behavior that can validate Dependabot PRs against uncommitted lockfile changes, and the watcher heartbeat can mask stale blackboard content as fresh. These are actionable regressions in correctness of validation/coordination.

Full review comments:

- [P2] Keep lockfile checks for Dependabot installs — /home/enio/egos/.github/workflows/ci.yml:26-29
  For Dependabot-triggered PRs, this runs plain `bun install`, which can regenerate or otherwise accept a lockfile that is not committed in the PR. In the common case where Dependabot changes `package.json` but `bun.lock` is stale or missing an update, all required checks can pass against an ephemeral lockfile, while the repository still contains the old lockfile and later non-Dependabot installs with `--frozen-lockfile` fail or test a different dependency graph. Prefer keeping `--frozen-lockfile` in CI and fixing Dependabot's lockfile update path separately.

- [P2] Recompute blackboard before refreshing heartbeat — /home/enio/egos/scripts/coordination-watcher.ts:248-253
  When the workspace status string is unchanged, or when the watcher starts while the repo is clean and an old `~/.egos/coordination-blackboard.json` already exists, this only refreshes the timestamp while preserving the previous `head`, `status`, and `summary`. Because the pre-commit gate only checks timestamp age, a stale/degraded/cross-repo blackboard is now treated as healthy indefinitely, masking the same coordination-stale state this change is meant to fix. The heartbeat should be written with freshly computed repo state, or only after `checkWorkspace()` has produced a current blackboard.
```
