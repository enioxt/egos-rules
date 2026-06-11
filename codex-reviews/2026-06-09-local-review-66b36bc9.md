# Codex Local Review — 2026-06-09T23:49:38Z

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
session id: 019eaeca-ac79-7a10-9f2a-ff723fab9b4c
--------
user
changes against 'HEAD~3'
2026-06-09T23:49:40.824116Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T23:49:40.824172Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 5768db24e28a2c9044a16cd4c050f1a798d0a5f3 --stat && git diff 5768db24e28a2c9044a16cd4c050f1a798d0a5f3' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                         |   5 +-
 TASKS.md                                      |  23 +-
 TASKS_ARCHIVE.md                              |   6 +
 docs/_current_handoffs/handoff_2026-06-09.md  |  26 ++
 docs/_current_handoffs/handoff_2026-06-09b.md |  84 ++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json  |   8 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json |  40 +++
 docs/tutor/PROVENANCE_4_CAMADAS.html          | 419 ++++++++++++++++++++++++++
 scripts/ai-commit-security.ts                 |   6 +-
 9 files changed, 605 insertions(+), 12 deletions(-)
diff --git a/.claude/settings.json b/.claude/settings.json
index 922bef13..d861b856 100644
--- a/.claude/settings.json
+++ b/.claude/settings.json
@@ -28,7 +28,10 @@
       "Bash(rm -rf /:*)",
       "Bash(rm -rf ~:*)",
       "Bash(dd if=:*)",
-      "Bash(mkfs:*)"
+      "Bash(mkfs:*)",
+      "Bash(*git commit --no-verify*)",
+      "Bash(*git commit -n *)",
+      "Bash(*git commit -n)"
     ],
     "defaultMode": "bypassPermissions",
     "additionalDirectories": [
diff --git a/TASKS.md b/TASKS.md
index 25ae65b7..443263d8 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -14,6 +14,11 @@
 > **Isca de valor** = comunidade + material + vídeo + Hotmart (entrada R$4 + networking), NÃO o diagnóstico. Diagnóstico vem depois, com a pessoa real.
 > **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
 
+**🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
+- [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
+- [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
+- [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
+
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
 - [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
@@ -30,12 +35,13 @@
 
 **Integridade phantom-done (2026-06-09 — buracos achados+corrigidos):**
 - [ ] **PHANTOM-AUDIT-WIRE-001** [P1] `forja` — Wire `scripts/audit-phantom-done.ts` (criado 754bca3b, sobrevive ao --no-verify) em `scripts/agent-sentinela.ts` + Layer de saúde do `/start`. Sem wiring = doc morto (R-CAP-001).
-- [ ] **WATCHER-STALE-ROOTCAUSE-001** [P1] `hermes-ops` — Causa-raiz do uso crônico de --no-verify: coordination-watcher fica stale e bloqueia commits legítimos → todo mundo usa --no-verify → desativa o pre-commit inteiro (incl. phantom-done). Consertar o watcher (não ficar stale / auto-restart) ELIMINA a necessidade de --no-verify. Ver feedback_phantom_done_noverify_hole.
+
+- [ ] **LLM-ROUTING-FIX-404-001** [P1] `curador`+`hermes-ops` — CONFIRMADO (achado via watcher 2026-06-09): `google/gemini-2.0-flash-001` retorna **HTTP 404 "No endpoints found"** no OpenRouter (resíduo da migração Alibaba→OpenRouter, memória `project_llm_routing_decision_2026-06-07`). Quebra a análise do coordination-watcher (agora fail-safe, mas sem enriquecimento) e qualquer outro caller que usa `tier:'fast'`. Fix: corrigir o id do modelo no chain de `packages/shared/src/llm-provider` (Gemini via Google AI Studio direto, conforme corte Enio "só Gemini") + smoke `callHermes` retornando 200. Owner = curador/LLM.
 
 **🛡️ PROGRAMA DE HARDENING DE REGRAS (corte Enio 2026-06-09 — generalizar a correção phantom-done a TODO o sistema):**
-- [ ] **RULE-HARDEN-BRANCHPROTECT-001** [P0] `hermes-ops` — GitHub branch protection server-side no repo `egos`: block force-push, require linear history, secret scanning push protection. Única camada não-bypassável para R0.1/R0.2 — hook local é defesa-em-profundidade, não SSOT.
+- [ ] **RULE-HARDEN-BRANCHPROTECT-001** [P2-DEFERIDA] `hermes-ops` — ⏸️ DEFERIDA (BRANCHPROTECT-PLAN-DECISION-001, corte Enio 2026-06-09): branch protection server-side é 403 no plano GitHub atual (free/private). Camada-4 escolhida = CI fail-closed (RULE-HARDEN-CI-GATES-001), não isto. Revisitar só se `egos` virar público ou GitHub Pro. Mantida como registro do gap.
 - [ ] **RULE-HARDEN-CI-GATES-001** [P0] `hermes-ops` — CI workflow (GitHub Actions) que re-roda os 4 gates críticos (gitleaks fail-closed, PII sweep history-wide, phantom-done exit 1, frozen-zone) independente de `--no-verify`. CI é a lei; hook é conveniência.
-- [ ] **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] `forja` — `ai-commit-security.ts:146` e `scan-hardcoded-sensitive.ts`: remover fail-open silencioso (`main().catch(()=>exit(0))`). Distinguir "scan limpo" de "scan crashou". Crash do scanner = BLOCK. `// scan-ok: mock` exige match de pattern sintético real (`.example.internal` ou hex construído), não auto-declarado.
+- [/] **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] `forja` — `ai-commit-security.ts:146` CORRIGIDO (2026-06-09): `main().catch(()=>exit(0))` → `main().catch((e)=>{ log; exit(1) })` (crash agora bloqueia). `scan-hardcoded-sensitive.ts` já estava correto (sem .catch silencioso). Falta: `// scan-ok: mock` pattern validation (não auto-declarado). 80% feito.
 - [ ] **RULE-HARDEN-PHANTOM-REGEX-001** [P1] `forja` — TIGHTEN regex phantom-done (pre-commit L532 + audit-phantom-done.ts L36): hex≥12 word-boundary estrito OU `evidence_sha:<40hex>` OU `Closes/Fixes #\d` validado via `git cat-file -e`. Remover `commit ` solto (falso-negativo). audit-phantom-done → exit 1 em CI/Sentinela, warn-only local.
 - [ ] **RULE-HARDEN-CAPABILITY-GOLDEN-001** [P1] `forja` — Gate `capability_audit` no pre-commit: entry validada em CAPABILITY_REGISTRY sem ≥3 golden cases (1 que falha em stub) → block. Fecha R7/INC-008 estruturalmente (hoje é regra de vontade, nenhum gate conta golden por capability).
 - [ ] **RULE-HARDEN-OVERRIDE-LEDGER-001** [P1] `forja` — Central override ledger: todo `EGOS_*_OVERRIDE`/`*-OVERRIDE` trailer/`--no-verify` registra em `docs/jobs/override-audit.jsonl` (espelhar hermes-block-control que já loga). `/start` mostra overrides da semana. Override sem registro = invisível hoje (11 gates sem rastro).
@@ -44,13 +50,18 @@
 - [ ] **PRI-L3-LLM-WIRE-001** [P2] `forja` — Incidental finding da validação: `layerThree` em `packages/core/src/guards/pri.ts` usa mock LLM. Injetar `llmEvaluator` real (Gemini via shared/llm-router) p/ escalação L3 ser 100% real. Injeção de dependência, não stub bloqueante.
 
 **🔬 AUDITORIA DE DISSEMINAÇÃO DA INTEGRIDADE (achados machine-wide 2026-06-09 — `/start` desta janela; classificação CONFIRMADO):**
-- [ ] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — CONFIRMADO: `.claude/settings.json` NÃO bloqueia `--no-verify` (grep=0). É o fix mais barato do SSOT §3-P0 (R=L/C altíssimo). Adicionar deny `Bash(git commit --no-verify *)` + `Bash(git commit -n *)` em settings.json + PATH shim `~/bin/git` que intercepta a flag em qualquer posição. Defesa-em-profundidade local complementar ao CI.
+- [/] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — settings.json ATUALIZADO (2026-06-09): deny `Bash(*git commit --no-verify*)` + `Bash(*git commit -n *)` adicionados. Falta: PATH shim `~/bin/git` (defesa extra, não crítico — CI é a camada real). 70% feito.
 - [ ] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — CONFIRMADO: o guard phantom-done do pre-commit + `audit-phantom-done.ts` vivem SÓ no kernel — `grep` em `852/.husky` e `egos-lab/.husky` = 0. A "disseminação" da 2ª metade propagou docs de governança, NÃO o enforcement de integridade aos leaves. Propagar o bloco phantom-done (pre-commit) + script audit via `disseminate-propagator.ts` aos leaves que têm TASKS.md. Prova: re-grep nos leaves após.
 - [ ] **CLAUDE-MD-INDEX-INTEGRITY-001** [P1] `prime` — CONFIRMADO: `INTEGRITY_PROOF_SSOT.md` é [T1] mas o router constitucional NÃO o indexa — `grep` em `.claude/CLAUDE.md` e `egos/CLAUDE.md` = 0 (só `AGENTS.md` cita). SSOT [T1] invisível ao router = enforcement-gap de descoberta. Adicionar 1 linha de índice em ambos os CLAUDE.md (lazy-ref, sem inflar) — liga CLAUDE-MD-SIMPLIFICADO-001.
-- [ ] **BRANCHPROTECT-PLAN-DECISION-001** [P0] `prime` `gated:HITL-Enio` — 🔴 BLOCKER CONFIRMADO: `gh api repos/enioxt/egos/branches/main/protection` → HTTP 403 "Upgrade to GitHub Pro or make this repository public". RULE-HARDEN-BRANCHPROTECT-001 (camada-4 não-bypassável) é IMPOSSÍVEL no plano atual. Decisão do Enio: (a) GitHub Pro pago, (b) tornar `egos` público (Red Zone — varredura PII/soul antes), ou (c) backstop alternativo via CI fail-closed (RULE-HARDEN-CI-GATES-001) como camada-4 de facto. Sem decisão, a camada-4 do INTEGRITY_PROOF_SSOT fica vazia.
+- [ ] **BRANCHPROTECT-PLAN-DECISION-001** [P0] `prime` — ✅ DECIDIDO (corte Enio 2026-06-09): opção **(c) CI fail-closed como camada-4 de facto** (RULE-HARDEN-CI-GATES-001) — não pagar Pro nem expor repo agora. ⏳ Task só fecha quando CI-GATES estiver LIVE (decisão ≠ implementação). Branch protection 403 (free/private) → RULE-HARDEN-BRANCHPROTECT-001 deferida. Registrado em handoff_2026-06-09.md + memória.
+
+**🔀 PRs GITHUB — TRIAGEM 2026-06-09:**
+- [ ] **PR-82-GITLEAKS-SECRET-001** [P1] `hermes-ops` — PR #82 (gitleaks 2→3) falha CI por `GITLEAKS_LICENSE` inacessível a dependabot (secret bloqueado). Fix: adicionar `if: github.actor != 'dependabot[bot]'` no job security-scan OU usar `secrets: inherit` com permissão. Merge após CI verde.
+- [ ] **ZOD-V4-MIGRATION-001** [P1] `forja` — Migrar zod 3→4 auditada: 91 arquivos afetados, APIs mudaram. Fazer pós-CONGELADO (R-DIAG-006). Instalar zod v4 e rodar `bun run typecheck` para listar todos os erros de migração antes de commitar qualquer mudança.
+- [ ] **PR-MAJORS-AUDIT-001** [P1] `prime` — PRs #85 (@simplewebauthn 11→13) #86 (lucide 0.577→1.17) #87 (jose 5→6) #88 (@types/node 20→25) em hold. Testar cada um em branch isolada + `bun run typecheck` antes de merge. jose e simplewebauthn são security-critical — testar autenticação real.
 
 **🖥️ COMUNICAÇÃO HUMANA — HTML (pedido Enio 2026-06-09: "nessa linguagem não consigo explicar pra ninguém"):**
-- [ ] **PROVENANCE-HTML-EXPLAINER-001** [P1] `prime`+`pixel` — Explicar as 4 camadas de provenance (L1 hash · L2 evidence-chain · L3 PRI gate · L4 Merkle + PII guard) em 1 HTML autocontido para humanos (Enio + leigos), com casos de uso concretos por camada (ex: "L1 = um byte muda → hash muda → você sabe que o arquivo foi adulterado"). Seguir HTML_GENERATION_CONSTITUTION (R-HTML-001..008). Incluir a ressalva honesta L3 = mock injetável (4.5/5, não 5/5). Iterar com Enio. Fonte: docs/jobs/2026-06-09-provenance-validation.md.
+- [/] **PROVENANCE-HTML-EXPLAINER-001** [P1] `prime`+`pixel` — HTML ESCRITO `docs/tutor/PROVENANCE_4_CAMADAS.html` (30KB, autocontido, R-HTML-001..008, 4 camadas + casos de uso + ressalva honesta L3 mock + glossário). ⚠️ **VISUAL PROOF PENDENTE — NÃO TESTADO nesta sessão** (screenshot interrompido pelo Enio; visual_proof_gate bloqueia file://; §11.5 → [CONCEPT] até screenshot+console-limpo). Próximo: abrir no navegador OU servir local e capturar screenshot light+dark, validar console, então iterar conteúdo com Enio. NÃO declarar [DONE] sem prova visual.
 - [ ] **HTML-SSOT-ITERATE-001** [P2] `pixel`+`prime` — Loop de melhoria contínua do `HTML_GENERATION_CONSTITUTION.md`: cada HTML novo que o Enio iterar gera ≥1 regra/refinamento de volta ao SSOT (o que funcionou p/ o humano entender vira regra). Manter changelog interno de versão. R-HTML = padrão vivo, não congelado.
 
 **Regras a encodar (R-DIAG-002 a 006) — pendente corte final do Enio:** ver `project_arquiteto_diagnosticador_identity_2026-06-09` na memória. R-DIAG-002 conversa-antes-de-código; R-DIAG-003 cadeia-fecha-no-funcionou; R-DIAG-004 diagnóstico-é-produto; R-DIAG-005 anti-espelho; R-DIAG-006 sistema-sem-pessoa-30d-congela.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 5d0f2f43..efefdf8e 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3814,3 +3814,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [x] **SUPABASE-DISABLE-LEGACY-001** [P1] — ✅ 2026-06-09 VERIFICADO LIVE: Enio desabilitou legacy keys. Incidente INC-KEYROT-001: 5 containers VPS ainda tinham JWT legacy (eu só trocara `.env` LOCAIS, não a VPS) → gateway caiu 502. Corrigidos via VPS .env/env_file + restart: egos-gateway, egos-hq, 852-app, guard-brasil-api (eagle-eye já unhealthy pré-existente). SMOKE 200 em TODAS: gateway/knowledge/stats (539 pgs), chat-web (FAQ real), guard/health, hq.egos.ia.br, 852.egos.ia.br. Gerou regra §10.1.
 
+
+## Archived 2026-06-09
+
+### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+- [x] **WATCHER-STALE-ROOTCAUSE-001** [P1] `hermes-ops` — RESOLVIDO `25ba5d1a`. Causa-raiz REAL achada ao vivo: o coordination-watcher escrevia o heartbeat (timestamp) só como efeito-colateral da análise LLM; modelo `google/gemini-2.0-flash-001` retorna 404 no OpenRouter → catch logava mas NÃO escrevia → timestamp congelava → pre-commit stale → todos no --no-verify. Fix fail-safe: catch escreve blackboard degradado com timestamp fresco + `touchHeartbeat()` incondicional por tick. Prova: restart → AGE=5s → commit passou sem --no-verify. (Liga LLM-ROUTING-FIX-404-001 — o modelo morto persiste.)
+
diff --git a/docs/_current_handoffs/handoff_2026-06-09.md b/docs/_current_handoffs/handoff_2026-06-09.md
index ca1000d5..7f5b7568 100644
--- a/docs/_current_handoffs/handoff_2026-06-09.md
+++ b/docs/_current_handoffs/handoff_2026-06-09.md
@@ -49,3 +49,29 @@ Depois: VALIDATE-PROVENANCE-001 (gravação Enio, desktop), CLAUDE-MD-SIMPLIFICA
 
 ## Marked [CONCEPT]
 - mcp-egos-diagnostic / mcp-egos-public — não existem, build futuro
+- PROVENANCE_4_CAMADAS.html — escrito mas SEM visual proof (screenshot interrompido) → [CONCEPT] até screenshot+console-limpo
+
+---
+
+## 🔬 JANELA TARDE (Prime) — watcher root-cause + HTML + auditoria disseminação
+
+### ✅ Accomplished (com SHAs)
+- `25ba5d1a` `scripts/coordination-watcher.ts` — heartbeat fail-safe (catch grava blackboard degradado c/ timestamp fresco + `touchHeartbeat()` por tick). **Causa-raiz REAL do INC-2026-06-09 achada ao vivo:** o heartbeat dependia da análise LLM; modelo `google/gemini-2.0-flash-001` dá 404 no OpenRouter → timestamp congelava → pre-commit stale → todos no `--no-verify`. Prova: restart → AGE=5s → commit passou sem bypass.
+- Auditoria machine-wide de disseminação da integridade (grep/gh) → veredito PARCIAL (doc ✓, enforcement ✗).
+- Tasks novas: LLM-ROUTING-FIX-404-001, DISSEMINATE-INTEGRITY-002, CLAUDE-MD-INDEX-INTEGRITY-001, BRANCHPROTECT-PLAN-DECISION-001, PROVENANCE-HTML-EXPLAINER-001, HTML-SSOT-ITERATE-001.
+- `docs/tutor/PROVENANCE_4_CAMADAS.html` escrito (30KB, R-HTML-001..008).
+
+### 🔄 In Progress / [CONCEPT]
+- PROVENANCE-HTML-EXPLAINER-001 [/] — HTML escrito, **visual proof PENDENTE** (não declarar done).
+
+### 📌 Decisions Made (cortes Enio)
+- Foco da janela: HTML das 4 camadas (entendimento > produção).
+- Branch protection 403 → opção **(c) CI fail-closed como camada-4 de facto** (RULE-HARDEN-CI-GATES-001). BRANCHPROTECT-001 deferida.
+
+### ⚠️ Multi-janela
+- Outra janela ativa no mesmo repo: editou TASKS.md (PR triage) + implementou settings.json deny --no-verify + ai-commit-security fail-closed (RULE-HARDEN P0s, marcados [/]). Absorvidos no commit de /end.
+
+### 🔗 Next Steps
+1. RULE-HARDEN-CI-GATES-001 [P0] — agora a camada-4 canônica (decisão Enio)
+2. PROVENANCE-HTML visual proof + iterar com Enio
+3. LLM-ROUTING-FIX-404-001 [P1] — modelo morto no OpenRouter
diff --git a/docs/_current_handoffs/handoff_2026-06-09b.md b/docs/_current_handoffs/handoff_2026-06-09b.md
new file mode 100644
index 00000000..40d0cd1d
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-09b.md
@@ -0,0 +1,84 @@
+# Handoff — 2026-06-09 (sessão 2ª parte + /end completo)
+
+## ✅ Accomplished (com SHAs)
+
+- **Identidade arquiteto-diagnosticador encodada** — TASKS.md §FOCO ATUAL reescrito, WIP≤2, auditoria 14 sistemas → 0 cliente_confirmou — `5768db24`
+- **False claim WhatsApp corrigido no HTML Miguel** — `mf-certificados-piloto.html` reescrito: "web em produção · WhatsApp em validação" (honesto) — `5768db24`
+- **WA-AGENT-CONNECT-001 [P0] criado** — task para reconectar WA com número limpo, absorve WAHA-CONNECT-001 — `5768db24`
+- **INTEGRITY_PROOF_SSOT.md [T1]** — 4 camadas de defesa + programa 8 tasks RULE-HARDEN — `eff0b679`
+- **audit-phantom-done.ts** — script autônomo sobrevive a `--no-verify` (2ª camada de segurança) — `754bca3b`
+- **EGOS_ROOT stale corrigido** — audit-phantom-done.ts agora usa `git rev-parse` dinâmico — `d44f9c57`
+- **Watcher heartbeat fail-safe** — não depende mais do LLM para escrever timestamp — `25ba5d1a`
+- **PII runtime gate [T0]** no gateway — mascara antes de enviar ao LLM — `26f8ee3a`
+- **Supabase key rotacionada** + legacy anon desabilitada — `06c4ad17`
+- **MCP Pessoal Enio curadoria** 90 tools → 16 núcleo — `docs/strategy/MCP_PESSOAL_ENIO_CURADORIA.md` — `2def6c69`
+- **3 HTML tutores** (conselho-registro, hitl-curve-principle, processo-arquiteto-diagnosticador) + HTML_GENERATION_CONSTITUTION.md — `b17894a1`
+- **CONSELHO_REGISTRO consolidado** — 4 IAs + Banda + Codex + Guarani + Runtime — `4945ff28`
+- **settings.json: deny `--no-verify`** wired (70%) — RULE-HARDEN-NOVERIFY-DENY-001 em curso
+- **Cursos reclassificados** — prova grátis dormente, NÃO Hotmart agora — memory `project_courses_as_proof_shelf_2026-06-09.md`
+
+## 🔄 In Progress
+
+- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] — 80% — ai-commit-security.ts corrigido (exit 1), falta `// scan-ok: mock` pattern validation
+- **RULE-HARDEN-NOVERIFY-DENY-001** [P0] — 70% — settings.json done, PATH shim `~/bin/git` pendente
+- **FOCUS-ITEMINTAKE-CLOSE-001** [P0] — outreach feito 2026-06-09, aguarda resposta Diesom (Kyte)
+- **GUARD-BRASIL-AUDIT-001** [P1] — agente rodou, falta consolidar achados
+
+## ⏳ Blocked
+
+- **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] — notebook `e869308b` RESTRITO → Enio abre NotebookLM → Share → Anyone with link (2 min)
+- **VALIDATE-PROVENANCE-001** [P0] — exige Enio rodar + gravar no desktop
+- **BRANCHPROTECT-PLAN-DECISION-001** [P0] — decisão Enio: (a) GitHub Pro, (b) egos público, (c) CI fail-closed como camada-4
+- **COURSE-PCMG-GATE-001** [P0] 🔴 — BLOCKS toda comercialização de cursos até verificação formal
+- **TASKS-ARCHIVE-NOW-001** [P0] — TASKS.md ~900L (limit 600) → rodar `bun scripts/tasks-archive.ts --exec`
+
+## 🔗 Next Steps (prioridade)
+
+1. **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] — Enio abre notebook e869308b → Share → Anyone with link (2 min)
+2. **MIGUEL-GOW-SEND-001** [P0] — Enviar HTML + link notebook ao Miguel (após share acima)
+3. **TASKS-ARCHIVE-NOW-001** [P0] — `bun scripts/tasks-archive.ts --exec` (urgente, ~900L)
+4. **WA-AGENT-CONNECT-001** [P0] — Criar instância Evolution limpa → QR em `hq.egos.ia.br/whatsapp-connect.html` → smoke real
+5. **RULES-ENCODE-PENDING-001** [P1] — 8 regras em `~/.egos/rules-pending.jsonl` → `/rules`
+6. **RULE-HARDEN-CI-GATES-001** [P0] — CI fail-closed: gitleaks + PII + phantom-done + frozen-zone
+
+## 🌐 Environment State
+
+- Build: ✅ typecheck OK (sessão anterior)
+- Tests: ⚠️ 88/93 MCP golden, 9/80 CBCs com golden real
+- Deploy: VPS hq.egos.ia.br HTTP 200 ✅
+- Watcher: ✅ heartbeat fail-safe corrigido `25ba5d1a`
+- Supabase: ✅ nova key ativa, legacy desabilitada
+- TASKS.md: 🔴 ~900L (limit 600) — ARCHIVE IMEDIATO NECESSÁRIO
+
+## 📌 Decisions Made
+
+- **Arquiteto-diagnosticador** (Enio 2026-06-09) — prova hipóteses com protótipos pequenos, cobra pela clareza. 733+ commits mas 0 cliente_confirmou=true = evidência do nó de receber, não falta técnica.
+- **Cursos = prova grátis dormente** — 2 cursos REAIS (Ciber+OVM) + KB cyber via NotebookLM só quando surgir lead policial/forense. NÃO Hotmart agora (bloqueado por COURSE-PCMG-GATE-001).
+- **CI fail-closed = camada-4 de facto** — branch protection HTTP 403 (GitHub free + repo privado). Não pagar GitHub Pro por enquanto.
+- **MCP Pessoal = 16 tools** curadas — recon, readiness, guard, metaprompt, memory, capture — pessoal autenticado, não público.
+- **Opção rejeitada (WhatsApp)** — reconectar com número banido → escolhido número limpo + WAHA UI como opção.
+
+## ✅ Todos da sessão (snapshot)
+
+- [x] Corrigir claim falso WhatsApp no HTML Miguel — `5768db24`
+- [x] Criar WA-AGENT-CONNECT-001 [P0] — `5768db24`
+- [x] Identidade arquiteto-diagnosticador em TASKS.md
+- [x] Cursos reclassificados → memory
+- [x] INTEGRITY_PROOF_SSOT.md + 8 tasks RULE-HARDEN — `eff0b679`
+- [x] audit-phantom-done.ts EGOS_ROOT fix — `d44f9c57`
+- [x] Watcher heartbeat fail-safe — `25ba5d1a`
+- [x] MCP Pessoal curadoria 90→16 — `2def6c69`
+- [/] RULE-HARDEN-NOVERIFY-DENY-001 (70% — settings.json ok, PATH shim pendente)
+- [/] RULE-HARDEN-AISECURITY-FAILCLOSED-001 (80% — exit 1 ok, scan-ok pattern pendente)
+- [ ] NOTEBOOKLM-MIGUEL-SHARE-001 (Enio)
+- [ ] WA-AGENT-CONNECT-001 (número limpo)
+- [ ] TASKS-ARCHIVE-NOW-001 (urgente)
+
+## 🚫 Marked [CONCEPT]
+
+- VALIDATE-PROVENANCE-001 — não executado (exige Enio rodar+gravar)
+- MCP-PESSOAL-ENIO-001 endpoint — só curadoria/design feita
+- WA-AGENT-ASYNC-ARCH-001 — design pendente corte Enio
+
+---
+*v6.5 | 2026-06-09 | SHA HEAD: 5768db24*
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index d3c4a3fa..aca23820 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T18:12:56.852Z",
+  "verified_at": "2026-06-09T23:43:27.450Z",
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
+      "current_value": "1327",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index c58568ee..0a4de0bb 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -198,5 +198,45 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=92e674cb",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T20:09:20.405Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=7 sha=25ba5d1a",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T20:11:29.194Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=5768db24",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T23:43:30.144Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=8 sha=86de702d",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T23:44:31.743Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=80bbb6ee",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T23:48:29.509Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=66b36bc9",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/tutor/PROVENANCE_4_CAMADAS.html b/docs/tutor/PROVENANCE_4_CAMADAS.html
new file mode 100644
index 00000000..114a724f
--- /dev/null
+++ b/docs/tutor/PROVENANCE_4_CAMADAS.html
@@ -0,0 +1,419 @@
+<!DOCTYPE html>
+<html lang="pt-BR" data-theme="auto">
+<head>
+  <meta charset="UTF-8">
+  <meta name="viewport" content="width=device-width, initial-scale=1.0">
+  <title>As 4 Camadas de Provenance — como o EGOS prova que algo é verdade | EGOS</title>
+  <style>
+    /* =============================================
+       EGOS HTML TUTOR — herda VISUAL_IDENTITY.md v1.1.0
+       Gerado conforme HTML_GENERATION_CONSTITUTION.md (R-HTML-001..008)
+       ============================================= */
+    :root {
+      --egos-black:#0A0E27; --egos-navy:#1A2F5A; --egos-blue:#2563EB;
+      --egos-green:#10B981; --egos-amber:#F59E0B; --egos-red:#EF4444;
+      --egos-white:#FFFFFF; --egos-gray-50:#F9FAFB; --egos-gray-200:#E5E7EB;
+      --egos-gray-600:#4B5563; --egos-gray-900:#111827;
+      --bg:#FFFFFF; --surface:#F9FAFB; --text-primary:#0A0E27;
+      --text-muted:#4B5563; --border:#E5E7EB; --code-bg:#F1F5F9;
+      --sidebar-w:260px; --header-h:52px; --max-content:880px; --radius:8px; --radius-sm:4px;
+    }
+    body.dark {
+      --bg:#0A0E27; --surface:#1A2F5A; --text-primary:#F1F5F9;
+      --text-muted:#94A3B8; --border:#2D3E5F; --code-bg:#0F172A;
+    }
+    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
+    html { scroll-behavior:smooth; }
+    body {
+      font-family:-apple-system,BlinkMacSystemFont,'Segoe UI','Inter',Roboto,sans-serif;
+      font-size:16px; line-height:1.65; background:var(--bg); color:var(--text-primary);
+      display:flex; flex-direction:column; min-height:100vh; transition:background .2s,color .2s;
+    }
+    .egos-header {
+      position:fixed; top:0; left:0; right:0; height:var(--header-h);
+      background:var(--egos-black); color:#fff; display:flex; align-items:center;
+      gap:12px; padding:0 16px; z-index:200; box-shadow:0 2px 8px rgba(0,0,0,.4);
+    }
+    .header-logo { font-size:18px; font-weight:800; color:var(--egos-blue); letter-spacing:-.5px; flex-shrink:0; }
+    .header-logo span { color:#fff; font-weight:400; font-size:14px; margin-left:6px; opacity:.7; }
+    .header-title { flex:1; font-size:14px; font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; opacity:.9; }
+    .header-actions { display:flex; gap:8px; flex-shrink:0; align-items:center; }
+    .btn-icon { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); color:#fff;
+      border-radius:var(--radius-sm); padding:5px 10px; cursor:pointer; font-size:14px; line-height:1; transition:background .15s; }
+    .btn-icon:hover { background:rgba(255,255,255,.25); }
+    .btn-icon:focus-visible { outline:2px solid var(--egos-blue); outline-offset:2px; }
+    .btn-hamburger { display:none; }
+    .egos-layout { display:flex; margin-top:var(--header-h); flex:1; }
+    .egos-sidebar {
+      position:fixed; top:var(--header-h); left:0; bottom:0; width:var(--sidebar-w);
+      background:var(--surface); border-right:1px solid var(--border); overflow-y:auto;
+      padding:16px 0 32px; z-index:100; transition:transform .25s ease;
+    }
+    .sidebar-section-label { font-size:10px; font-weight:700; text-transform:uppercase;
+      letter-spacing:.1em; color:var(--text-muted); padding:12px 16px 4px; }
+    .sidebar-link { display:block; padding:5px 16px; font-size:13px; color:var(--text-primary);
+      text-decoration:none; border-left:3px solid transparent; transition:all .15s;
+      white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
+    .sidebar-link:hover, .sidebar-link[aria-current="page"] {
+      background:var(--bg); border-left-color:var(--egos-blue); color:var(--egos-blue); }
+    .sidebar-link:focus-visible { outline:2px solid var(--egos-blue); outline-offset:-2px; }
+    .egos-main { margin-left:var(--sidebar-w); flex:1; padding:32px 28px 48px; }
+    .content-wrap { max-width:var(--max-content); }
+    h1 { font-size:2rem; font-weight:700; line-height:1.2; margin-bottom:8px; }
+    h2 { font-size:1.5rem; font-weight:600; line-height:1.25; margin:44px 0 12px; padding-bottom:8px; border-bottom:2px solid var(--border); }
+    h3 { font-size:1.15rem; font-weight:600; margin:24px 0 8px; }
+    h4 { font-size:1rem; font-weight:600; margin:16px 0 6px; color:var(--text-muted); }
+    p { margin-bottom:12px; }
+    ul,ol { padding-left:22px; margin-bottom:12px; }
+    li { margin-bottom:5px; }
+    a { color:var(--egos-blue); text-decoration:none; }
+    a:hover { text-decoration:underline; }
+    strong { font-weight:600; }
+    section { scroll-margin-top:calc(var(--header-h) + 16px); }
+    .doc-meta { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:24px; font-size:13px; color:var(--text-muted); }
+    .doc-meta span { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius-sm); padding:2px 8px; }
+    .callout { border-left:4px solid var(--egos-blue); background:var(--surface);
+      border-radius:0 var(--radius) var(--radius) 0; padding:12px 16px; margin:16px 0; font-size:15px; }
+    .callout.green { border-left-color:var(--egos-green); background:rgba(16,185,129,.07); }
+    .callout.amber { border-left-color:var(--egos-amber); background:rgba(245,158,11,.07); }
+    .callout.red { border-left-color:var(--egos-red); background:rgba(239,68,68,.07); }
+    .callout-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; margin-bottom:4px; opacity:.7; }
+    .badge { display:inline-block; padding:1px 7px; border-radius:12px; font-size:11px; font-weight:700; letter-spacing:.04em; vertical-align:middle; }
+    .badge.real { background:rgba(16,185,129,.15); color:var(--egos-green); }
+    .badge.concept { background:rgba(37,99,235,.12); color:var(--egos-blue); }
+    .badge.phantom { background:rgba(75,85,99,.15); color:var(--text-muted); }
+    .badge.partial { background:rgba(245,158,11,.15); color:var(--egos-amber); }
+    .badge.t1 { background:rgba(245,158,11,.15); color:var(--egos-amber); }
+    code { font-family:'JetBrains Mono','SF Mono',Monaco,Menlo,'Courier New',monospace; font-size:13px;
+      background:var(--code-bg); border:1px solid var(--border); border-radius:var(--radius-sm); padding:1px 5px; }
+    pre { background:var(--egos-gray-900); color:#E2E8F0; border-radius:var(--radius); padding:16px;
+      overflow-x:auto; font-size:13px; line-height:1.6; margin:16px 0; }
+    pre code { background:none; border:none; padding:0; color:inherit; font-size:inherit; }
+    .table-wrap { overflow-x:auto; margin:16px 0; }
+    table { width:100%; border-collapse:collapse; font-size:14px; }
+    th { background:var(--surface); font-weight:600; text-align:left; padding:8px 12px; border-bottom:2px solid var(--border); }
+    td { padding:8px 12px; border-bottom:1px solid var(--border); vertical-align:top; }
+    tr:last-child td { border-bottom:none; }
+    .section-divider { height:1px; background:var(--border); margin:32px 0; }
+    /* Cartão de camada */
+    .layer-card { border:1px solid var(--border); border-radius:var(--radius); padding:18px 20px; margin:18px 0;
+      background:var(--surface); }
+    .layer-card h3 { margin-top:0; display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
+    .layer-num { display:inline-flex; align-items:center; justify-content:center; width:30px; height:30px;
+      border-radius:8px; background:var(--egos-blue); color:#fff; font-weight:800; font-size:14px; flex-shrink:0; }
+    .layer-card .use-case { border-left:3px solid var(--egos-green); padding:8px 14px; margin:12px 0 4px;
+      background:rgba(16,185,129,.06); border-radius:0 6px 6px 0; font-size:14.5px; }
+    .layer-card .use-case b { color:var(--egos-green); }
+    .kv { font-size:13px; color:var(--text-muted); margin-top:8px; }
+    .egos-footer { margin-left:var(--sidebar-w); background:var(--egos-black); color:rgba(255,255,255,.75);
+      padding:16px 28px; font-size:12px; display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:12px; }
+    .footer-brand { font-weight:700; color:var(--egos-blue); font-size:13px; display:block; margin-bottom:2px; }
+    .footer-tagline { opacity:.6; font-size:11px; }
+    .footer-provenance { text-align:right; line-height:1.8; }
+    .footer-provenance code { background:rgba(255,255,255,.08); border:none; color:rgba(255,255,255,.85); font-size:11px; }
+    @media (max-width:768px) {
+      .egos-sidebar { transform:translateX(-100%); width:80vw; max-width:300px; box-shadow:4px 0 20px rgba(0,0,0,.3); }
+      .egos-sidebar.open { transform:translateX(0); }
+      .btn-hamburger { display:flex; }
+      .egos-main { margin-left:0; padding:20px 16px 48px; }
+      .egos-footer { margin-left:0; flex-direction:column; }
+      .footer-provenance { text-align:left; }
+      h1 { font-size:1.5rem; } h2 { font-size:1.25rem; }
+    }
+    .sidebar-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:99; }
+    .sidebar-overlay.active { display:block; }
+    @media (prefers-reduced-motion:reduce) { *,*::before,*::after { transition:none!important; animation:none!important; } html { scroll-behavior:auto; } }
+  </style>
+</head>
+<body>
+
+  <header class="egos-header" role="banner">
+    <button class="btn-icon btn-hamburger" id="btn-menu" aria-label="Abrir menu de navegação" aria-expanded="false" aria-controls="sidebar">☰</button>
+    <div class="header-logo">EGOS<span>/ Provenance</span></div>
+    <div class="header-title" aria-hidden="true">As 4 Camadas de Provenance — como o EGOS prova que algo é verdade</div>
+    <div class="header-actions">
+      <button class="btn-icon" id="btn-theme" aria-label="Alternar modo claro/escuro" title="Alternar tema">☀</button>
+    </div>
+  </header>
+
+  <div class="sidebar-overlay" id="sidebar-overlay" aria-hidden="true"></div>
+
+  <div class="egos-layout">
+    <nav class="egos-sidebar" id="sidebar" aria-label="Índice do documento">
+      <div class="sidebar-section-label">Nesta página</div>
+      <a href="#o-problema" class="sidebar-link">O problema que isto resolve</a>
+      <a href="#visao-geral" class="sidebar-link">Visão geral das 4 camadas</a>
+      <a href="#l1" class="sidebar-link">L1 — Hash (impressão digital)</a>
+      <a href="#l2" class="sidebar-link">L2 — Cadeia de evidência</a>
+      <a href="#l3" class="sidebar-link">L3 — Portão PRI (decisão)</a>
+      <a href="#l4" class="sidebar-link">L4 — Merkle / assinatura</a>
+      <a href="#pii" class="sidebar-link">+ Guard PII</a>
+      <a href="#caso-completo" class="sidebar-link">Um caso, ponta-a-ponta</a>
+      <a href="#honestidade" class="sidebar-link">Por que 4,5 e não 5</a>
+      <a href="#glossario" class="sidebar-link">Glossário</a>
+      <div class="sidebar-section-label" style="margin-top:12px;">Referências</div>
+      <a href="#rodape" class="sidebar-link">Proveniência</a>
+    </nav>
+
+    <main class="egos-main" id="main-content">
+      <div class="content-wrap">
+
+        <h1>As 4 Camadas de Provenance</h1>
+        <p style="font-size:1.05rem; color:var(--text-muted);">Como o EGOS prova que algo é verdade — em vez de só afirmar.</p>
+        <div class="doc-meta">
+          <span>Versão 1.0.0</span>
+          <span>Gerado em 2026-06-09</span>
+          <span class="badge t1">T1</span>
+          <span class="badge real">4 camadas REAIS</span>
+          <span class="badge partial">1 sub-camada PARCIAL (honesta)</span>
+        </div>
+
+        <div class="callout">
+          <div class="callout-label">Para que serve este documento</div>
+          Explicar, em linguagem de gente, o que são as 4 camadas de <em>provenance</em> (proveniência) do EGOS, com um caso de uso concreto para cada uma. <strong>Provenance</strong> = a trilha que mostra <em>de onde uma informação veio, se ela foi alterada, e por que você pode confiar nela</em>. É o coração do EGOS como "arquiteto-diagnosticador": o valor não está em afirmar, está em <strong>provar</strong>.
+        </div>
+
+        <div class="section-divider"></div>
+
+        <section id="o-problema" aria-labelledby="h-problema">
+          <h2 id="h-problema">O problema que isto resolve</h2>
+          <p>Imagine um laudo, um relatório de investigação, ou uma conclusão gerada por IA. Três perguntas sempre ficam no ar:</p>
+          <ul>
+            <li><strong>Esse arquivo foi mexido depois de pronto?</strong> (integridade)</li>
+            <li><strong>De onde veio cada afirmação — é fato, dedução ou chute?</strong> (origem)</li>
+            <li><strong>Posso confiar que ninguém apagou ou trocou um registro antigo?</strong> (histórico)</li>
+          </ul>
+          <p>A maioria dos sistemas responde "confie em mim". O EGOS responde com <strong>prova matemática verificável</strong>. Cada camada abaixo ataca uma dessas perguntas. Juntas, transformam "eu afirmo" em "eu provo, e qualquer um pode checar".</p>
+          <div class="callout amber">
+            <div class="callout-label">A regra-mãe por trás disso</div>
+            "Afirmação sem prova é afirmação inválida." Provar é o último passo obrigatório de toda tarefa — não um opcional. (CLAUDE.md §1 · INTEGRITY_PROOF_SSOT)
+          </div>
+        </section>
+
+        <section id="visao-geral" aria-labelledby="h-visao">
+          <h2 id="h-visao">Visão geral das 4 camadas</h2>
+          <p>Pense numa cadeia: cada camada cuida de uma garantia diferente. Se uma falha, as outras ainda seguram.</p>
+          <div class="table-wrap">
+            <table>
+              <thead><tr><th>Camada</th><th>Garante que…</th><th>Pergunta que responde</th><th>Status</th></tr></thead>
+              <tbody>
+                <tr><td><strong>L1 — Hash</strong></td><td>o arquivo não foi alterado</td><td>"mexeram nisso?"</td><td><span class="badge real">REAL</span></td></tr>
+                <tr><td><strong>L2 — Cadeia de evidência</strong></td><td>toda afirmação tem fonte e nível de certeza</td><td>"de onde veio?"</td><td><span class="badge real">REAL</span></td></tr>
+                <tr><td><strong>L3 — Portão PRI</strong></td><td>cada ação é liberada, bloqueada, adiada ou escalada</td><td>"pode fazer isso?"</td><td><span class="badge real">REAL (gate)</span> <span class="badge partial">escalação LLM = mock</span></td></tr>
+                <tr><td><strong>L4 — Merkle / assinatura</strong></td><td>nenhum registro antigo foi adulterado</td><td>"o histórico é íntegro?"</td><td><span class="badge real">REAL</span></td></tr>
+                <tr><td><strong>+ Guard PII</strong></td><td>dado pessoal não vaza</td><td>"tem CPF aqui?"</td><td><span class="badge real">REAL</span></td></tr>
+              </tbody>
+            </table>
+          </div>
+        </section>
+
+        <div class="section-divider"></div>
+
+        <section id="l1" aria-labelledby="h-l1">
+          <h2 id="h-l1">L1 — Hash: a impressão digital do arquivo</h2>
+          <div class="layer-card">
+            <h3><span class="layer-num">L1</span> Hash <span class="badge real">REAL</span></h3>
+            <p>Um <strong>hash</strong> é uma função que lê qualquer arquivo e cospe um código fixo de 64 caracteres — como uma impressão digital. A mágica: <strong>mude 1 único byte e o código inteiro muda</strong>. É impossível alterar o conteúdo sem alterar a impressão digital.</p>
+            <div class="use-case">
+              <b>Caso de uso:</b> você gera um laudo e guarda o hash dele. Semanas depois, alguém te entrega "o mesmo laudo". Você roda o hash de novo: se bater com o guardado, é idêntico ao original. Se mudou <em>uma vírgula</em>, o hash não bate — e você sabe que foi adulterado. Sem precisar reler o documento inteiro.
+            </div>
+            <p>O EGOS também garante que o hash é <strong>independente da ordem dos campos</strong>: o mesmo dado escrito em ordem diferente dá o mesmo hash — então a prova é sobre o conteúdo, não sobre formatação.</p>
+            <div class="kv">Arquivo: <code>packages/shared/src/provenance.ts</code></div>
+            <pre><code>Prova real (smoke colado):
+Hash do dado original : f960c1da … 99b5
+Mesmo dado, 1 byte mudado : adbb6d7a … f7ce
+→ um byte de diferença = hash completamente diferente ✅</code></pre>
+          </div>
+        </section>
+
+        <section id="l2" aria-labelledby="h-l2">
+          <h2 id="h-l2">L2 — Cadeia de evidência: toda afirmação carrega sua fonte</h2>
+          <div class="layer-card">
+            <h3><span class="layer-num">L2</span> Evidence chain <span class="badge real">REAL</span></h3>
+            <p>Aqui cada afirmação vem grudada com (a) <strong>de onde ela veio</strong> e (b) <strong>o nível de certeza</strong>. O EGOS usa três rótulos:</p>
+            <ul>
+              <li><strong>CONFIRMADO</strong> — provado por uma fonte direta (um extrato, um arquivo, um teste).</li>
+              <li><strong>INFERIDO</strong> — deduzido a partir de fatos, mas não visto diretamente.</li>
+              <li><strong>HIPÓTESE</strong> — possibilidade ainda não provada.</li>
+            </ul>
+            <div class="use-case">
+              <b>Caso de uso:</b> num relatório, a frase "o investigado movimentou R$ 50 mil" não anda sozinha — ela vem com <code>fonte: extrato bancário, linha 412 · CONFIRMADO</code>. Já "o dinheiro veio de fonte ilícita" aparece como <code>HIPÓTESE</code>. Quem lê sabe na hora o que é pedra e o que é areia — e ninguém repete sua conclusão como fato sem ver a base.
+            </div>
+            <p>A cadeia inteira ganha um <strong>hash de auditoria</strong>, então o conjunto de evidências também fica selado contra alteração.</p>
+            <div class="kv">Arquivo: <code>packages/shared/src/evidence-chain.ts</code> · prova: <code>auditHash = ev-698b7574</code></div>
+          </div>
+        </section>
+
+        <section id="l3" aria-labelledby="h-l3">
+          <h2 id="h-l3">L3 — Portão PRI: decide o que pode passar</h2>
+          <div class="layer-card">
+            <h3><span class="layer-num">L3</span> Portão PRI <span class="badge real">REAL (gate)</span> <span class="badge partial">escalação = mock</span></h3>
+            <p>PRI é um <strong>portão de decisão</strong>. Antes de uma ação acontecer, ele dá um de quatro veredictos:</p>
+            <div class="table-wrap">
+              <table>
+                <thead><tr><th>Veredicto</th><th>Significado</th><th>Exemplo</th></tr></thead>
+                <tbody>
+                  <tr><td><strong>ALLOW</strong></td><td>libera</td><td>ação rotineira, sem risco</td></tr>
+                  <tr><td><strong>BLOCK</strong></td><td>bloqueia</td><td>viola uma regra dura</td></tr>
+                  <tr><td><strong>DEFER</strong></td><td>adia / manda pro humano</td><td>toca dado sensível → espera decisão</td></tr>
+                  <tr><td><strong>ESCALATE</strong></td><td>sobe pra análise mais profunda</td><td>caso ambíguo que precisa de julgamento</td></tr>
+                </tbody>
+              </table>
+            </div>
+            <div class="use-case">
+              <b>Caso de uso:</b> uma IA está prestes a publicar um texto que menciona um CPF. O portão PRI intercepta: como toca dado pessoal, o veredicto é <strong>DEFER</strong> — não bloqueia para sempre, mas <em>segura e pede o "ok" de um humano</em>. É o "pare e pense" automático antes de algo irreversível.
+            </div>
+            <div class="callout amber">
+              <div class="callout-label">A ressalva honesta (e por que ela importa)</div>
+              O portão funciona <strong>de ponta a ponta</strong> nos 4 veredictos (testado: <code>4/4 pass</code>). Mas quando o caso precisa <em>escalar para um LLM julgar</em>, essa parte hoje usa um <strong>mock determinístico</strong> — um substituto previsível, não a IA real ainda conectada. É <strong>injeção de dependência</strong> (a peça é trocável por Gemini com uma linha), <strong>não um stub que finge funcionar</strong>. Dizer isto é mais forte que fingir 5/5 perfeito.
+            </div>
+            <div class="kv">Arquivo: <code>packages/core/src/guards/pri.ts</code> · prova: <code>bun test pri.test.ts → 4 pass / 0 fail</code> · wiring real do LLM = task <code>PRI-L3-LLM-WIRE-001</code></div>
+          </div>
+        </section>
+
+        <section id="l4" aria-labelledby="h-l4">
+          <h2 id="h-l4">L4 — Merkle / assinatura: o selo do histórico inteiro</h2>
+          <div class="layer-card">
+            <h3><span class="layer-num">L4</span> Merkle + assinatura Ed25519 <span class="badge real">REAL</span></h3>
+            <p>Se L1 é a impressão digital de <em>um</em> arquivo, L4 é o selo da <strong>pilha inteira de registros</strong>. Os hashes são encadeados numa árvore (estrutura <strong>Merkle</strong>) e o todo é <strong>assinado</strong> com uma chave criptográfica (Ed25519). Resultado: mexer em <em>qualquer</em> registro velho quebra o selo de tudo.</p>
+            <div class="use-case">
+              <b>Caso de uso:</b> um log de decisões de 3 dias atrás. Alguém tenta editar uma linha retroativamente para "consertar a história". A assinatura Merkle denuncia na hora: a verificação volta <code>false</code>. Você prova que o histórico é íntegro — ou prova exatamente que foi adulterado.
+            </div>
+            <div class="kv">Arquivo: <code>packages/shared/src/agent-signature.ts</code></div>
+            <pre><code>Prova real (smoke colado):
+Cadeia INTACTA          : true
+Adulterada (hash)       : false
+Adulterada (tipo de ação): false
+→ qualquer alteração retroativa é detectada ✅</code></pre>
+            <p class="kv">Nota técnica: assinar/verificar funciona 100% offline. Só persistir o registro num banco (ledger) precisa de Supabase — a <em>prova</em> em si não depende de nada externo.</p>
+          </div>
+        </section>
+
+        <section id="pii" aria-labelledby="h-pii">
+          <h2 id="h-pii">+ Guard PII: o dado pessoal não vaza</h2>
+          <div class="layer-card">
+            <h3><span class="layer-num" style="background:var(--egos-green)">PII</span> Guard Brasil <span class="badge real">REAL</span></h3>
+            <p>Antes de qualquer conteúdo sair (publicar, exportar, mandar pra uma IA externa), o Guard varre por dado pessoal brasileiro — CPF, e-mail, placa, número de registro — e <strong>mascara</strong>.</p>
+            <div class="use-case">
+              <b>Caso de uso:</b> um texto contém <!-- scan-ok: cpf-ficticio-didatico --> <code>[CPF-EXEMPLO-FICTÍCIO]</code> (substituído por segurança — o Guard detectaria e mascararia assim). O Guard transforma em <code>[CPF REMOVIDO]</code> antes de qualquer saída, marca a sensibilidade como <code>critical</code> e conta quantos achados mascarou. O dado soberano nunca cruza a fronteira sem passar por aqui.
+            </div>
+            <div class="kv">Arquivos: <code>packages/shared/src/pii-scanner.ts</code> + <code>public-guard.ts</code> · prova: CPF/email/placa/REDS → todos <code>[REMOVIDO]</code>, <code>findings: 4</code></div>
+          </div>
+        </section>
+
+        <div class="section-divider"></div>
+
+        <section id="caso-completo" aria-labelledby="h-caso">
+          <h2 id="h-caso">Um caso, ponta-a-ponta</h2>
+          <p>Veja as camadas trabalhando juntas num único fluxo — um relatório gerado por IA:</p>
+          <ol>
+            <li><strong>L2</strong> grava cada afirmação com sua fonte e rótulo (CONFIRMADO/INFERIDO/HIPÓTESE).</li>
+            <li><strong>Guard PII</strong> varre o texto e mascara qualquer CPF/dado pessoal.</li>
+            <li><strong>L3 (PRI)</strong> decide: o relatório toca dado sensível? → <strong>DEFER</strong> pro humano aprovar.</li>
+            <li><strong>L1</strong> gera o hash do relatório final aprovado — a impressão digital congelada.</li>
+            <li><strong>L4</strong> assina e encadeia esse hash no histórico — selo contra adulteração futura.</li>
+          </ol>
+          <div class="callout green">
+            <div class="callout-label">O resultado</div>
+            Qualquer pessoa, depois, pode verificar: <em>este</em> é o relatório original (L1), <em>estas</em> são as fontes de cada frase (L2), foi <em>aprovado</em> por um humano (L3), o histórico <em>não foi mexido</em> (L4), e <em>nenhum dado pessoal vazou</em> (PII). Isso é proveniência: confiança que se checa, não que se pede.
+          </div>
+        </section>
+
+        <section id="honestidade" aria-labelledby="h-honestidade">
+          <h2 id="h-honestidade">Por que 4,5 e não 5</h2>
+          <p>A validação técnica deu <strong>4,5 de 5 genuinamente REAL</strong>. As camadas L1, L2, L4 e o Guard PII são reais e testadas. O portão L3 é real como gate — o que é "meio ponto" é só a <em>escalação para o LLM</em>, que hoje usa um substituto trocável.</p>
+          <div class="callout">
+            <div class="callout-label">A tese central do EGOS</div>
+            Dizer "4,5/5, com a meia-camada marcada com transparência" é <strong>mais forte</strong> que fingir "5/5 perfeito". A validação honesta — incluindo o que ainda é trabalho-em-progresso — <em>é</em> a prova. Quem esconde o que falta não tem provenance; tem marketing.
+          </div>
+        </section>
+
+        <section id="glossario" aria-labelledby="h-glossario">
+          <h2 id="h-glossario">Glossário rápido</h2>
+          <div class="table-wrap">
+            <table>
+              <thead><tr><th>Termo</th><th>O que é</th></tr></thead>
+              <tbody>
+                <tr><td><strong>Provenance</strong></td><td>Proveniência — a trilha de onde algo veio, se mudou, e por que confiar.</td></tr>
+                <tr><td><strong>Hash</strong></td><td>Código fixo gerado de um arquivo; muda inteiro se 1 byte muda. A "impressão digital".</td></tr>
+                <tr><td><strong>Merkle</strong></td><td>Árvore que encadeia hashes; permite detectar alteração em qualquer ponto do histórico.</td></tr>
+                <tr><td><strong>Ed25519</strong></td><td>Tipo de assinatura criptográfica — rápida e segura.</td></tr>
+                <tr><td><strong>Gate / Portão</strong></td><td>Ponto de controle que decide se uma ação passa ou para.</td></tr>
+                <tr><td><strong>Mock</strong></td><td>Substituto previsível de uma peça real, usado enquanto a real não está conectada.</td></tr>
+                <tr><td><strong>Injeção de dependência</strong></td><td>Padrão onde uma peça (ex: o LLM) é "plugável" — trocável sem reescrever o resto.</td></tr>
+                <tr><td><strong>PII</strong></td><td>Dado pessoal identificável (CPF, e-mail, telefone…).</td></tr>
+                <tr><td><strong>DEFER</strong></td><td>Veredicto do portão: "segura e manda pro humano decidir".</td></tr>
+              </tbody>
+            </table>
+          </div>
+        </section>
+
+      </div>
+    </main>
+  </div>
+
+  <footer class="egos-footer" id="rodape" role="contentinfo">
+    <div>
+      <span class="footer-brand">⬡ EGOS — Governance is Infrastructure</span>
+      <span class="footer-tagline">Documento tutor — camada humana (R-DOC-AUDIENCE-001)</span>
+    </div>
+    <div class="footer-provenance">
+      <span>Fonte: <code>docs/jobs/2026-06-09-provenance-validation.md</code></span><br>
+      <span>SSOT técnico: <code>docs/governance/INTEGRITY_PROOF_SSOT.md</code></span><br>
+      <span>Gerado em: 2026-06-09 · v1.0.0</span><br>
+      <span>Regenerável a partir do .md fonte</span>
+    </div>
+  </footer>
+
+  <script>
+    (function () {
+      'use strict';
+      var THEME_KEY = 'egos-html-theme';
+      var body = document.body;
+      function applyTheme(t) {
+        if (t === 'dark') body.classList.add('dark'); else body.classList.remove('dark');
+        var btn = document.getElementById('btn-theme');
+        if (btn) btn.textContent = (t === 'dark') ? '☀' : '☾';
+      }
+      function getStoredTheme() { try { return localStorage.getItem(THEME_KEY); } catch(e) { return null; } }
+      function storeTheme(t) { try { localStorage.setItem(THEME_KEY, t); } catch(e) {} }
+      var stored = getStoredTheme();
+      if (stored) applyTheme(stored);
+      else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) applyTheme('dark');
+      document.getElementById('btn-theme').addEventListener('click', function () {
+        var next = body.classList.contains('dark') ? 'light' : 'dark';
+        applyTheme(next); storeTheme(next);
+      });
+      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
+        if (!getStoredTheme()) applyTheme(e.matches ? 'dark' : 'light');
+      });
+      var sidebar = document.getElementById('sidebar');
+      var overlay = document.getElementById('sidebar-overlay');
+      var btnMenu = document.getElementById('btn-menu');
+      function openSidebar() { sidebar.classList.add('open'); overlay.classList.add('active');
+        overlay.setAttribute('aria-hidden','false'); btnMenu.setAttribute('aria-expanded','true'); }
+      function closeSidebar() { sidebar.classList.remove('open'); overlay.classList.remove('active');
+        overlay.setAttribute('aria-hidden','true'); btnMenu.setAttribute('aria-expanded','false'); }
+      if (btnMenu) btnMenu.addEventListener('click', function () {
+        sidebar.classList.contains('open') ? closeSidebar() : openSidebar(); });
+      if (overlay) overlay.addEventListener('click', closeSidebar);
+      sidebar.querySelectorAll('.sidebar-link').forEach(function (link) {
+        link.addEventListener('click', function () { if (window.innerWidth <= 768) closeSidebar(); });
+      });
+      var sections = document.querySelectorAll('main section[id]');
+      var links = document.querySelectorAll('.sidebar-link');
+      function onScroll() {
+        var scrollY = window.scrollY;
+        var headerH = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--header-h')) || 52;
+        var current = '';
+        sections.forEach(function (sec) { if (sec.offsetTop - headerH - 24 <= scrollY) current = sec.id; });
+        links.forEach(function (link) {
+          link.setAttribute('aria-current', link.getAttribute('href') === '#' + current ? 'page' : 'false');
+        });
+      }
+      window.addEventListener('scroll', onScroll, { passive: true });
+      onScroll();
+    })();
+  </script>
+</body>
+</html>
diff --git a/scripts/ai-commit-security.ts b/scripts/ai-commit-security.ts
index 62965cd8..c476c9bb 100644
--- a/scripts/ai-commit-security.ts
+++ b/scripts/ai-commit-security.ts
@@ -143,4 +143,8 @@ async function main() {
   process.exit(0)
 }
 
-main().catch(() => process.exit(0))  // always fail-open
+main().catch((e) => {
+  console.error('[ai-security] FATAL: scanner crashed unexpectedly:', e?.message ?? e)
+  console.error('  Commit BLOCKED — fix the scanner or use AI_SECURITY_STRICT=0 to bypass.')
+  process.exit(1)
+})

exec
/bin/bash -lc "sed -n '1,220p' scripts/ai-commit-security.ts && cat .claude/settings.json && cat docs/jobs/2026-06-09-pre-commit-pipeline.json && cat docs/jobs/2026-06-09-doc-drift-verifier.json" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * ai-commit-security.ts — AI-SECURITY-001
 *
 * Inline pre-commit security check via LLM (gemini-2.0-flash-001, <500ms target).
 * Scans STAGED DIFF ONLY for security patterns EGOS static tools miss:
 *   - SQL injection in raw queries
 *   - Auth bypass (missing auth checks in new routes)
 *   - LGPD violations (PII fields without guard_brasil or masking)
 *   - Hardcoded secrets that gitleaks missed (env-var names, not values)
 *   - Insecure direct object references (IDOR)
 *
 * Exit codes:
 *   0 = OK or WARN (warn-only mode)
 *   1 = CRITICAL found (AI_SECURITY_STRICT=1 mode)
 *
 * Usage (called by pre-commit §1.6):
 *   bun scripts/ai-commit-security.ts --staged     # check staged diff
 *   bun scripts/ai-commit-security.ts --dry        # show diff only, no API call
 *   AI_SECURITY_STRICT=1 bun scripts/...           # block on CRITICAL
 */

import { execSync } from 'node:child_process'
import { callHermes } from '../packages/shared/src/llm-providers/llm-router.ts'

const STRICT = process.env.AI_SECURITY_STRICT === '1'
const DRY    = process.argv.includes('--dry')
const MAX_DIFF_CHARS = 4000
const TIMEOUT_MS = 8000  // fail-open if LLM takes >8s

const SECURITY_PROMPT = `You are a security reviewer for a TypeScript/Bun/Next.js SaaS codebase (EGOS).
Review ONLY the staged diff below for PRODUCTION-BREAKING security issues.

Check for:
1. SQL injection in raw queries (string interpolation in SQL)
2. Auth bypass — new API routes without auth middleware check
3. LGPD/PII — storing CPF, RG, phone, name in plain text without guard or masking
4. Hardcoded secrets — API keys, passwords, tokens as literals (not env vars)
5. IDOR — using user-supplied IDs directly in DB queries without ownership check

SEVERITY RULES (strict):
- CRITICAL: confirmed SQL injection, exposed secret value, missing auth on sensitive route
- HIGH: likely vulnerability, needs immediate review
- MEDIUM: potential issue, context needed
- LOW: style concern, best-practice suggestion
- OK: no security issues

Be concise. If OK, say "SEVERITY: OK" and stop.

Format:
SEVERITY: <level>
ISSUES:
- <issue with file:line if visible>
(or "- none" if OK)

STAGED DIFF:`

function getStagedDiff(): string {
  try {
    const diff = execSync('git diff --cached --unified=3', {
      encoding: 'utf8',
      maxBuffer: 100_000,
    })
    if (!diff.trim()) return ''
    // Filter to only changed lines (+/-), skip binary
    const lines = diff.split('\n').filter(l =>
      l.startsWith('+++') || l.startsWith('---') ||
      l.startsWith('@@') || l.startsWith('+') || l.startsWith('-') ||
      l.startsWith('diff --git')
    )
    return lines.join('\n').slice(0, MAX_DIFF_CHARS)
  } catch {
    return ''
  }
}

function parseSeverity(raw: string): string {
  return raw.match(/SEVERITY:\s*(CRITICAL|HIGH|MEDIUM|LOW|OK)/i)?.[1]?.toUpperCase() ?? 'OK'
}

function parseIssues(raw: string): string[] {
  const section = raw.match(/ISSUES:\s*([\s\S]*?)(?:\n\n|$)/i)?.[1] ?? ''
  return section.split('\n')
    .map(l => l.replace(/^-\s*/, '').trim())
    .filter(l => l && l !== 'none' && l.length > 3)
}

async function main() {
  const diff = getStagedDiff()

  if (!diff) {
    process.exit(0)
  }

  if (DRY) {
    console.log('[ai-security] DRY mode — staged diff:')
    console.log(diff.slice(0, 500) + '...')
    process.exit(0)
  }

  // Skip if diff is only docs/config (no TS/JS/SQL risk)
  const hasCode = diff.includes('.ts') || diff.includes('.tsx') ||
                  diff.includes('.js') || diff.includes('.sql') ||
                  diff.includes('route.ts') || diff.includes('server.ts')
  if (!hasCode) {
    process.exit(0)
  }

  let result: { content: string }
  try {
    result = await callHermes(`${SECURITY_PROMPT}\n\n${diff}`, {
      maxTokens: 200,
      timeoutMs: TIMEOUT_MS,
      systemPrompt: 'Security reviewer. Be concise. Use exact format.',
    })
  } catch (e) {
    // Fail-open: LLM unavailable → don't block commit
    console.error('  [ai-security] LLM timeout/error — skipping (non-blocking)')
    process.exit(0)
  }

  const severity = parseSeverity(result.content)
  const issues = parseIssues(result.content)

  if (severity === 'OK' || severity === 'LOW') {
    process.exit(0)
  }

  const icon = severity === 'CRITICAL' ? '❌' : severity === 'HIGH' ? '⚠️' : 'ℹ️'
  console.log(`\n${icon} [ai-security] ${severity} finding(s):`)
  issues.forEach(i => console.log(`   → ${i}`))

  if (severity === 'CRITICAL' && STRICT) {
    console.log('\n❌ BLOCKED: CRITICAL security issue. Fix or add [SECURITY-OVERRIDE: reason] to commit msg.')
    console.log('   Set AI_SECURITY_STRICT=0 to disable blocking.')
    process.exit(1)
  }

  if (severity === 'CRITICAL' || severity === 'HIGH') {
    console.log('   (warn-only — set AI_SECURITY_STRICT=1 to block)')
  }

  process.exit(0)
}

main().catch((e) => {
  console.error('[ai-security] FATAL: scanner crashed unexpectedly:', e?.message ?? e)
  console.error('  Commit BLOCKED — fix the scanner or use AI_SECURITY_STRICT=0 to bypass.')
  process.exit(1)
})
{
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "WebFetch",
      "WebSearch",
      "Agent",
      "Skill",
      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
      "Bash(echo \"EXIT: $?\")",
      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
      "Bash(cat)",
      "Bash(bash scripts/check-skills-drift.sh --fix)",
      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
      "mcp__notebooklm-mcp__studio_delete",
      "mcp__claude_ai_Supabase__execute_sql",
      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
      "mcp__claude_ai_Supabase__list_projects"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(rm -rf ~:*)",
      "Bash(dd if=:*)",
      "Bash(mkfs:*)",
      "Bash(*git commit --no-verify*)",
      "Bash(*git commit -n *)",
      "Bash(*git commit -n)"
    ],
    "defaultMode": "bypassPermissions",
    "additionalDirectories": [
      "/home/enio/egos/.claude/commands"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Grep|Glob|Read|Search",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/cbm-code-discovery-gate"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/pre-edit-safety"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/rm-guard"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/post-write-typecheck"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/tone-honesty-gate"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/budget-guard.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/session-status.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/frustration-detector"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/anti-compaction-guard"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/skill-auto-match"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/context-alarm.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {
    "codex@openai-codex": true
  },
  "extraKnownMarketplaces": {
    "openai-codex": {
      "source": {
        "source": "github",
        "repo": "openai/codex-plugin-cc"
      }
    }
  },
  "alwaysThinkingEnabled": true,
  "effortLevel": "medium",
  "skipDangerousModePermissionPrompt": true
}
[
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T11:00:16.904Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=3 sha=d0f3fa75",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T11:02:58.980Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=2 sha=4529821b",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T12:34:38.629Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=2 sha=8c2dbb5e",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T12:47:59.583Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=0dbcd0c0",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T12:55:50.254Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:docs files=1 sha=547d31a5",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T12:56:45.393Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=2 sha=251ece05",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T13:02:32.504Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=2 sha=dee4da45",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T13:12:46.180Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=3 sha=84130718",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T13:33:25.647Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:fix files=2 sha=21200b24",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T13:40:13.854Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=10 sha=1a2b9415",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T14:17:54.823Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:fix files=3 sha=b9f7c8e4",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T14:22:53.420Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=3d0f899f",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T14:36:02.832Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=2 sha=a6bb400c",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T14:39:37.167Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:docs files=1 sha=e295e6eb",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T14:45:55.903Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=4 sha=ee38e623",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T17:51:42.179Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:docs files=1 sha=4945ff28",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T17:54:17.785Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=4 sha=83748a2e",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:12:58.880Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:feat files=11 sha=26f8ee3a",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:31:18.782Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:fix files=3 sha=afee6fd9",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:38:56.577Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:docs files=5 sha=b17894a1",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:47:03.705Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=76e2a5f9",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:52:58.514Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=ae6ec570",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:54:23.617Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=6dccf0bb",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T18:56:26.125Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:docs files=1 sha=2def6c69",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T20:00:42.395Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=92e674cb",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T20:09:20.405Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:fix files=7 sha=25ba5d1a",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T20:11:29.194Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:fix files=2 sha=5768db24",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T23:43:30.144Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=8 sha=86de702d",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T23:44:31.743Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=1 sha=80bbb6ee",
    "repo": "/home/enio/egos"
  },
  {
    "agent_id": "pre-commit-pipeline",
    "ts": "2026-06-09T23:48:29.509Z",
    "status": "ok",
    "duration_ms": null,
    "event": "commit:chore files=2 sha=66b36bc9",
    "repo": "/home/enio/egos"
  }
]
{
  "manifest": "/home/enio/egos/.egos-manifest.yaml",
  "repo": "egos",
  "verified_at": "2026-06-09T23:43:27.450Z",
  "summary": {
    "total_claims": 17,
    "passed": 17,
    "warned": 0,
    "drifted": 0,
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
      "current_value": "64",
      "tolerance": "±5",
      "drift_abs": 3,
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
      "current_value": "38",
      "tolerance": "±2",
      "drift_abs": 2,
      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
      "severity": "ok"
    },
    {
      "id": "commits_30d_all_repos",
      "description": "Total commits across all active EGOS repos in last 30 days",
      "status": "ok",
      "last_value": "1466",
      "current_value": "1327",
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
      "status": "ok",
      "last_value": "0",
      "current_value": "0\n0",
      "tolerance": "min:0",
      "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
      "severity": "ok"
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
      "current_value": "100",
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
      "current_value": "176",
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
/bin/bash -lc "nl -ba .claude/settings.json | sed -n '24,38p'; nl -ba scripts/ai-commit-security.ts | sed -n '100,155p'" in /home/enio/egos
 succeeded in 0ms:
    24	      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
    25	      "mcp__claude_ai_Supabase__list_projects"
    26	    ],
    27	    "deny": [
    28	      "Bash(rm -rf /:*)",
    29	      "Bash(rm -rf ~:*)",
    30	      "Bash(dd if=:*)",
    31	      "Bash(mkfs:*)",
    32	      "Bash(*git commit --no-verify*)",
    33	      "Bash(*git commit -n *)",
    34	      "Bash(*git commit -n)"
    35	    ],
    36	    "defaultMode": "bypassPermissions",
    37	    "additionalDirectories": [
    38	      "/home/enio/egos/.claude/commands"
   100	
   101	  // Skip if diff is only docs/config (no TS/JS/SQL risk)
   102	  const hasCode = diff.includes('.ts') || diff.includes('.tsx') ||
   103	                  diff.includes('.js') || diff.includes('.sql') ||
   104	                  diff.includes('route.ts') || diff.includes('server.ts')
   105	  if (!hasCode) {
   106	    process.exit(0)
   107	  }
   108	
   109	  let result: { content: string }
   110	  try {
   111	    result = await callHermes(`${SECURITY_PROMPT}\n\n${diff}`, {
   112	      maxTokens: 200,
   113	      timeoutMs: TIMEOUT_MS,
   114	      systemPrompt: 'Security reviewer. Be concise. Use exact format.',
   115	    })
   116	  } catch (e) {
   117	    // Fail-open: LLM unavailable → don't block commit
   118	    console.error('  [ai-security] LLM timeout/error — skipping (non-blocking)')
   119	    process.exit(0)
   120	  }
   121	
   122	  const severity = parseSeverity(result.content)
   123	  const issues = parseIssues(result.content)
   124	
   125	  if (severity === 'OK' || severity === 'LOW') {
   126	    process.exit(0)
   127	  }
   128	
   129	  const icon = severity === 'CRITICAL' ? '❌' : severity === 'HIGH' ? '⚠️' : 'ℹ️'
   130	  console.log(`\n${icon} [ai-security] ${severity} finding(s):`)
   131	  issues.forEach(i => console.log(`   → ${i}`))
   132	
   133	  if (severity === 'CRITICAL' && STRICT) {
   134	    console.log('\n❌ BLOCKED: CRITICAL security issue. Fix or add [SECURITY-OVERRIDE: reason] to commit msg.')
   135	    console.log('   Set AI_SECURITY_STRICT=0 to disable blocking.')
   136	    process.exit(1)
   137	  }
   138	
   139	  if (severity === 'CRITICAL' || severity === 'HIGH') {
   140	    console.log('   (warn-only — set AI_SECURITY_STRICT=1 to block)')
   141	  }
   142	
   143	  process.exit(0)
   144	}
   145	
   146	main().catch((e) => {
   147	  console.error('[ai-security] FATAL: scanner crashed unexpectedly:', e?.message ?? e)
   148	  console.error('  Commit BLOCKED — fix the scanner or use AI_SECURITY_STRICT=0 to bypass.')
   149	  process.exit(1)
   150	})

exec
/bin/bash -lc 'git diff --name-only 5768db24e28a2c9044a16cd4c050f1a798d0a5f3 && git diff --unified=20 5768db24e28a2c9044a16cd4c050f1a798d0a5f3 -- scripts/ai-commit-security.ts .claude/settings.json docs/jobs/2026-06-09-doc-drift-verifier.json' in /home/enio/egos
 succeeded in 0ms:
.claude/settings.json
TASKS.md
TASKS_ARCHIVE.md
docs/_current_handoffs/handoff_2026-06-09.md
docs/_current_handoffs/handoff_2026-06-09b.md
docs/jobs/2026-06-09-doc-drift-verifier.json
docs/jobs/2026-06-09-pre-commit-pipeline.json
docs/tutor/PROVENANCE_4_CAMADAS.html
scripts/ai-commit-security.ts
diff --git a/.claude/settings.json b/.claude/settings.json
index 922bef13..d861b856 100644
--- a/.claude/settings.json
+++ b/.claude/settings.json
@@ -11,41 +11,44 @@
       "WebSearch",
       "Agent",
       "Skill",
       "Bash(bash ~/.claude/hooks/context-alarm.sh)",
       "Bash(echo \"EXIT: $?\")",
       "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
       "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
       "Bash(cat)",
       "Bash(bash scripts/check-skills-drift.sh --fix)",
       "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
       "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
       "mcp__notebooklm-mcp__studio_delete",
       "mcp__claude_ai_Supabase__execute_sql",
       "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
       "mcp__claude_ai_Supabase__list_projects"
     ],
     "deny": [
       "Bash(rm -rf /:*)",
       "Bash(rm -rf ~:*)",
       "Bash(dd if=:*)",
-      "Bash(mkfs:*)"
+      "Bash(mkfs:*)",
+      "Bash(*git commit --no-verify*)",
+      "Bash(*git commit -n *)",
+      "Bash(*git commit -n)"
     ],
     "defaultMode": "bypassPermissions",
     "additionalDirectories": [
       "/home/enio/egos/.claude/commands"
     ]
   },
   "hooks": {
     "PreToolUse": [
       {
         "matcher": "Grep|Glob|Read|Search",
         "hooks": [
           {
             "type": "command",
             "command": "~/.claude/hooks/cbm-code-discovery-gate"
           }
         ]
       },
       {
         "matcher": "Edit",
         "hooks": [
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index d3c4a3fa..aca23820 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,24 +1,24 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T18:12:56.852Z",
+  "verified_at": "2026-06-09T23:43:27.450Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
     "warned": 0,
     "drifted": 0,
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
@@ -33,74 +33,74 @@
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
-      "current_value": "63",
+      "current_value": "64",
       "tolerance": "±5",
-      "drift_abs": 2,
+      "drift_abs": 3,
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
       "current_value": "38",
       "tolerance": "±2",
       "drift_abs": 2,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
     {
       "id": "commits_30d_all_repos",
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1294",
+      "current_value": "1327",
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
       "status": "ok",
       "last_value": "0",
       "current_value": "0\n0",
diff --git a/scripts/ai-commit-security.ts b/scripts/ai-commit-security.ts
index 62965cd8..c476c9bb 100644
--- a/scripts/ai-commit-security.ts
+++ b/scripts/ai-commit-security.ts
@@ -126,21 +126,25 @@ async function main() {
     process.exit(0)
   }
 
   const icon = severity === 'CRITICAL' ? '❌' : severity === 'HIGH' ? '⚠️' : 'ℹ️'
   console.log(`\n${icon} [ai-security] ${severity} finding(s):`)
   issues.forEach(i => console.log(`   → ${i}`))
 
   if (severity === 'CRITICAL' && STRICT) {
     console.log('\n❌ BLOCKED: CRITICAL security issue. Fix or add [SECURITY-OVERRIDE: reason] to commit msg.')
     console.log('   Set AI_SECURITY_STRICT=0 to disable blocking.')
     process.exit(1)
   }
 
   if (severity === 'CRITICAL' || severity === 'HIGH') {
     console.log('   (warn-only — set AI_SECURITY_STRICT=1 to block)')
   }
 
   process.exit(0)
 }
 
-main().catch(() => process.exit(0))  // always fail-open
+main().catch((e) => {
+  console.error('[ai-security] FATAL: scanner crashed unexpectedly:', e?.message ?? e)
+  console.error('  Commit BLOCKED — fix the scanner or use AI_SECURITY_STRICT=0 to bypass.')
+  process.exit(1)
+})

codex
The main functional hardening change in the Claude permissions does not block common `git commit ... --no-verify` forms, leaving the bypass it intends to prevent. Other changes are mostly documentation or logs.

Review comment:

- [P2] Block no-verify when flags follow commit options — /home/enio/egos/.claude/settings.json:32-34
  These deny patterns only match `--no-verify`/`-n` when they appear immediately after `git commit`, so common invocations like `git commit -m "msg" --no-verify`, `git commit -am "msg" -n`, or commands with other commit options still bypass the hook. Since this change is meant to close the local `--no-verify` escape hatch, the pattern needs to match the bypass flag anywhere after `git commit`.
The main functional hardening change in the Claude permissions does not block common `git commit ... --no-verify` forms, leaving the bypass it intends to prevent. Other changes are mostly documentation or logs.

Review comment:

- [P2] Block no-verify when flags follow commit options — /home/enio/egos/.claude/settings.json:32-34
  These deny patterns only match `--no-verify`/`-n` when they appear immediately after `git commit`, so common invocations like `git commit -m "msg" --no-verify`, `git commit -am "msg" -n`, or commands with other commit options still bypass the hook. Since this change is meant to close the local `--no-verify` escape hatch, the pattern needs to match the bypass flag anywhere after `git commit`.
```
