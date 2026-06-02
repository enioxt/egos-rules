# Codex Local Review — 2026-06-01T01:57:04Z

- Repo: egos | Branch: main | Base: HEAD~1 | Commits: 1

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.3-codex
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019e80e6-1c9c-7080-8862-761502db5837
--------
user
changes against 'HEAD~1'
exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.agents/workflows/start.md b/.agents/workflows/start.md
index e4fd4ddc..4145b0a0 100644
--- a/.agents/workflows/start.md
+++ b/.agents/workflows/start.md
@@ -42,6 +42,32 @@ export EGOS_OS && echo "OS=$EGOS_OS | ROOT=$ROOT"
 # jq check
 command -v jq >/dev/null 2>&1 || echo "🟡 jq missing — install: $([ $EGOS_OS = linux ] && echo 'sudo apt install jq' || echo 'brew install jq / winget install jqlang.jq')"
 
+# Coordination Blackboard Check (GUARANI-006)
+BLACKBOARD="$HOME/.egos/coordination-blackboard.json"
+if [ -f "$BLACKBOARD" ] && command -v jq >/dev/null 2>&1; then
+  BB_STATUS=$(jq -r '.status // "unknown"' "$BLACKBOARD")
+  if [ "$BB_STATUS" = "dirty" ]; then
+    echo "⚠️  [WARNING] Active local changes detected by parallel agent! Check blackboard: ~/.egos/coordination-blackboard.md"
+    jq -r '.summary' "$BLACKBOARD" | sed 's/^/     | /'
+  fi
+  # Staleness warning if older than 5 minutes
+  if command -v python3 >/dev/null 2>&1; then
+    STALE=$(python3 -c "
+import json, datetime
+try:
+    with open('$BLACKBOARD') as f:
+        data = json.load(f)
+        dt = datetime.datetime.fromisoformat(data['timestamp'].replace('Z', '+00:00'))
+        now = datetime.datetime.now(datetime.timezone.utc)
+        if (now - dt).total_seconds() > 300:
+            print('stale')
+except Exception:
+    pass
+")
+    [ "$STALE" = "stale" ] && echo "⚠️  [WARNING] Coordination Blackboard is stale (> 5 minutes old). Watcher daemon may be inactive."
+  fi
+fi
+
 # Remote staleness (ROOT-CAUSE FIX 2026-05-11)
 git fetch origin --quiet 2>/dev/null || echo "🟡 git fetch failed (offline?)"
 LOCAL_HEAD=$(git rev-parse HEAD 2>/dev/null)
diff --git a/.github/workflows/capability-eval.yml b/.github/workflows/capability-eval.yml
index 0b1e7e95..ae19f105 100644
--- a/.github/workflows/capability-eval.yml
+++ b/.github/workflows/capability-eval.yml
@@ -43,16 +43,11 @@ jobs:
       - name: TypeScript check
         run: bun run typecheck
 
+      - name: Verify CBC proof paths integrity
+        run: bun scripts/check-cbc-proof-paths.ts --ci
+
       - name: Run MCP behavioral evals
-        id: eval
-        run: |
-          set +e
-          bun packages/eval-runner/src/mcp-runner.ts --all --json > /tmp/eval-results.json
-          EXIT_CODE=$?
-          echo "exit_code=$EXIT_CODE" >> $GITHUB_OUTPUT
-          cat /tmp/eval-results.json | head -200
-          exit $EXIT_CODE
-        continue-on-error: true
+        run: bun packages/eval-runner/src/mcp-runner.ts --all --json > /tmp/eval-results.json
 
       - name: Upload eval results
         if: always()
@@ -68,6 +63,10 @@ jobs:
         with:
           script: |
             const fs = require('fs');
+            if (!fs.existsSync('/tmp/eval-results.json')) {
+              console.log('No eval results file found. Skipping PR comment.');
+              return;
+            }
             const results = JSON.parse(fs.readFileSync('/tmp/eval-results.json', 'utf8'));
             let comment = '## ❌ MCP Capability Eval Failed\n\n';
             comment += 'Behavioral eval is mandatory for capabilities at beta+ (MCP-FIX-005).\n\n';
@@ -89,9 +88,3 @@ jobs:
               repo: context.repo.repo,
               body: comment
             });
-
-      - name: Fail if block failures
-        if: steps.eval.outputs.exit_code != '0'
-        run: |
-          echo "::error::Behavioral eval has block failures — merge blocked (MCP-FIX-005)"
-          exit 1
diff --git a/.guarani/SEPARATION_POLICY.md b/.guarani/SEPARATION_POLICY.md
new file mode 100644
index 00000000..6c72c09c
--- /dev/null
+++ b/.guarani/SEPARATION_POLICY.md
@@ -0,0 +1,113 @@
+# SEPARATION POLICY — EGOS Ecosystem
+# VERSION 1.0.0 — Created 2026-03-06
+# APPLIES TO: ALL agents, bots, workflows, dissemination scripts
+
+> **This is a CONSTITUTIONAL document.** All agents, bots, and automated systems
+> MUST enforce these rules. Violations are BLOCKING — stop and ask the user.
+
+---
+
+## 1. Repository Visibility Classification
+
+| Repo | Visibility | Public Channels? | Notes |
+|------|-----------|-----------------|-------|
+| **egos-lab** | PUBLIC | ✅ Yes | Safe to mention anywhere |
+| **EGOS-Inteligencia** (br-acc) | PUBLIC | ✅ Yes | Safe to mention anywhere |
+| **carteira-livre** | PRIVATE | ❌ NEVER | Code not public, business-sensitive |
+| **FORJA** | PRIVATE | ❌ NEVER | Client-specific, business-sensitive |
+| **DHPP** | PRIVATE | ❌ NEVER | Police data, SIGILOSO |
+
+## 2. Channel Classification
+
+| Channel | Type | Audience | What CAN be posted |
+|---------|------|----------|-------------------|
+| **t.me/ethikin** | PUBLIC | Community | egos-lab, EGOS Inteligência, $ETHIK, consciousness tools |
+| **Discord EGOS** | PUBLIC | Community | egos-lab, EGOS Inteligência, $ETHIK, consciousness tools |
+| **@EGOSin_bot** | PUBLIC | Anyone | egos-lab ecosystem, EGOS Inteligência, public data |
+| **egos.ia.br** | PUBLIC | Anyone | All public projects only |
+| **GitHub Issues** | PUBLIC | Devs | Only the repo's own content |
+
+## 3. ABSOLUTE PROHIBITIONS
+
+### 3.1 Private Repos on Public Channels
+```
+❌ NEVER mention Carteira Livre on Telegram/Discord/Twitter
+❌ NEVER mention Forja on Telegram/Discord/Twitter
+❌ NEVER mention DHPP on ANY public channel
+❌ NEVER post code snippets from private repos publicly
+❌ NEVER share Carteira Livre URLs in public posts
+❌ NEVER share Forja URLs in public posts
+```
+
+### 3.2 Personal Information
+```
+❌ NEVER post about politics, political opinions, or political affiliations
+❌ NEVER post about personal stories, family, relationships
+❌ NEVER post CVs, resumes, or career details
+❌ NEVER post about health, finances, or personal legal matters
+❌ NEVER post CPFs, personal emails, phone numbers, addresses
+❌ NEVER post client names or client business details (e.g. Rocha Implementos)
+```
+
+### 3.3 Police / Investigation Data
+```
+❌ NEVER post investigation details on ANY channel
+❌ NEVER mention case numbers, victim names, suspect names
+❌ NEVER mention OVM content, even summarized
+❌ NEVER reference DHPP workspace existence publicly
+```
+
+## 4. WHAT CAN BE POSTED PUBLICLY
+
+### On Telegram (@ethikin) and Discord
+- EGOS Inteligência features and updates (Neo4j stats, new tools, ETL progress)
+- egos.ia.br updates (consciousness tools, calculators, new pages)
+- $ETHIK token news
+- Sacred Mathematics concepts
+- Open-source contribution opportunities (egos-lab GitHub issues)
+- General AI/tech/ethics discussions
+- RHO decentralization scores (public repos only)
+
+### On Twitter (@anoineim)
+- Same as Telegram/Discord above
+- Links to egos.ia.br and inteligencia.egos.ia.br
+- Open-source milestones (stars, forks, contributors)
+
+## 5. ENFORCEMENT IN CODE
+
+### Bot System Prompts
+Every bot (Telegram, Discord) MUST include in its system prompt:
+```
+SEPARATION RULES (MANDATORY):
+- You represent the EGOS open-source ecosystem ONLY.
+- You must NEVER mention: Carteira Livre, Forja, DHPP, or any private project.
+- You must NEVER discuss: politics, personal life, CVs, client details.
+- If asked about private projects, respond: "I can only discuss the EGOS
+  open-source ecosystem. Visit egos.ia.br for more information."
+```
+
+### Dissemination Scripts
+The `disseminator` and `ambient_disseminator` agents MUST:
+1. Check content against this policy BEFORE posting
+2. Filter out any mention of private repos
+3. Filter out any personal/political content
+4. Log all posts for audit
+
+### Pre-commit Hook
+Add to `scripts/disseminate.ts`:
+```
+SEPARATION_CHECK: Verify no private repo names appear in public-facing content
+```
+
+## 6. EXCEPTIONS
+
+Only the USER (Enio) can authorize exceptions, and they must be:
+- Explicit (written in chat)
+- Specific (which content, which channel)
+- Temporary (with expiry)
+
+No agent, bot, or automated system can override this policy.
+
+---
+
+*"Separation is not secrecy — it's respect for boundaries."*
diff --git a/.husky/pre-commit b/.husky/pre-commit
index 3403fe9c..7afecd56 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -166,6 +166,13 @@ if [ -f "scripts/check-visual-proof.sh" ]; then
   bash scripts/check-visual-proof.sh "${GIT_DIR:-.git}/COMMIT_EDITMSG" || exit 1
 fi
 
+# 0.72. UI/UX SYNC AND DATABASE INTEGRITY GATE — R8/R2.5 Sync
+# Ensures storefront configs, tenant registries, and database schemas are synced.
+if [ -f "scripts/ui-sync-check.ts" ] && command -v bun > /dev/null 2>&1; then
+  bun scripts/ui-sync-check.ts || exit 1
+fi
+
+
 # 0.75. BANNED WORDS GATE — A53 Karpathy Doctrine (100%, perfeito, garantido, infalível)
 # Dispara em staged copy pública (*.md *.html *.jsx *.tsx)
 # Modo warn-only por padrão. EGOS_BANNED_STRICT=1 → bloqueia.
diff --git a/TASKS.md b/TASKS.md
index 0c78a44f..4be3e183 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -107,13 +107,11 @@
 ## 💰 VALUATION & ECV — Avaliação de capacidade/valor do EGOS (2026-05-31) [INICIATIVA SEPARADA de GUARDRAILS]
 > **SSOT:** `docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md` (DRAFT, commit `b625a37e`). **Tese:** medir valor por LOC-Verificado + ECV (não LOC bruto). **Red Zone:** todos os números (R$7.02M, R$25.8M-86M, equity 15-35%, $ETHIK) são CONCEPT/histórico — exigem corte Enio antes de qualquer uso externo. **Owner tags:** iguais ao bloco guardrails. ⚠️ NÃO confundir com GUARD-STD-* — Guarani referenciou GUARD-STD-001/002 no plano de valuation por engano; esses IDs pertencem só a guardrails.
 - [ ] **VAL-SEC-001** [P0] `redzone` — **Rotacionar chave Groq** `gsk_Jb…` exposta em `autoresearch-mine-history.ts:53` (era fallback hardcoded, removida mas vazou no working tree). Enio: revogar no console Groq + gerar nova + setar em env. AINDA PENDENTE — ação humana do Enio; não fechar por hook.
-- [ ] **VAL-003** [P2] `prime` `gated:002` — Formalizar fórmula ECV (§4) como script calculável (`scripts/ecv-score.ts`) com inputs auditáveis; ≥1 dry-run sobre 1 capability real.
 - [ ] **VAL-004** [P0] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
 - [ ] **VAL-005** [P2] `redzone` — Enio roda meta-prompt de review Codex (§7 do doc) para estressar metodologia ECV; Prime sintetiza (UNVERIFIED INC-005).
 
 ## 🎯 NAME & PROVE — Campanha de Capacidade (Opus 2026-05-30, pós-3-agentes)
 > **SSOT:** `docs/strategy/NAME_AND_PROVE_PLAN.md` + `CAPABILITY_NARRATIVE.md`. **Tese:** provar = honrar `AGENTS.md R7` (hoje ~86% violado; eval coverage 14%). Reports: PROOF_GAP_MATRIX / PROOF_ENGINE_AUDIT / NAMING_NARRATIVE_AUDIT.
-- [~] **NAME-PROVE-003** [P2] — ✅ script `scripts/check-cbc-proof-paths.ts` construído + validado (W-05): 9/79 CBC com prova real, 57 placeholder pendente, 0 BLOCK; `--ci` só falha em live/in-progress sem prova (não alarme falso). ⏳ FALTA: wirar `--ci` no `capability-eval.yml` + endurecer W-02 (`continue-on-error`).
 - [ ] **NAME-PROVE-004** [P1] `🔴 gated-VPS` — Cheap-win: rodar evals que JÁ existem (knowledge-mcp 11 casos ~1h; MCP G Peças) → flip PARTIAL→PROVEN. Precisa MCP servers (desktop/VPS).
 - [ ] **NAME-PROVE-005** [P3] — Escrever eval novo p/ top-3 sem prova: Central EGOS Storefront, ATRiAN pipeline, Guard Brasil pipeline (escrever daqui; rodar gated).
 - [ ] **NAME-PROVE-006** [P3] — Dashboard "% capacidades provadas" (hoje 14%) + cron full-run `--all` (W-10) no `governance-drift.yml`.
@@ -130,6 +128,10 @@
 
 ## 🧠 ANTI-SYCOPHANCY — Provar/estender o pilar 6 (Adversarial Multi-Agent Review) — 2026-05-30
 > **Problema (evidência):** Stanford/Cheng et al. (Science 2026-03-26) — LLMs afirmam usuário ~49% mais que humano, mesmo errado. **Já temos:** `banda.ts` (4 papéis), `council.ts` (multi-LLM), skills `premortem`/`duo`. NÃO criar skill nova de thread — estender o que existe.
+> **⚠️ DIAGNÓSTICO 2026-05-31 (Prime):** orquestração multi-agente é ~40% real / ~60% estético. Review Codex automático QUEBRADO há 35 dias; Council DORMENTE há 34 dias. Watcher + pre-commit gates = reais ($0, pegam bug). Ver ORCH-FIX abaixo.
+- [ ] **ORCH-FIX-001** [P0] `15min` — Consertar `~/.egos/scripts/codex-submit-review.sh:77`: `codex-cli 0.130.0` removeu `--repo`, exige `--env <ENV_ID>`. Review automático post-push falha silencioso desde 2026-04-27. **Bloqueado em:** Enio rodar `codex cloud` (browse) e fornecer o env id de `enioxt/egos`. Sem isso, troca um erro por outro.
+- [ ] **ORCH-FIX-002** [P1] `30min` — Council dormente (4 runs total, último 34 dias). Decidir: wire `scripts/council.ts` em gate real (ex: pre-push de Red Zone) OU aceitar que é on-demand e parar de citá-lo como orquestração ativa.
+- [ ] **ORCH-FIX-003** [P2] `prime` — Hermes auto-dispatch (post-push VPS) com SSH timeout. Verificar se VPS 204.168.217.125:22 está acessível ou se trigger deve ser desativado.
 - [ ] **ANTI-SYCO-001** [P2] — Golden case que PROVA Banda/Council pegam premissa errada (alimentar erro óbvio → assert que o papel Crítico/Questionador refuta). Honra R7 no pilar 6.
 - [ ] **ANTI-SYCO-002** [P3] — Estender Banda com as 3 técnicas que NÃO temos: blind peer-review (anonimizar respostas antes da síntese), Self-Grounded Verification (priors independentes antes de avaliar), third-person framing. Fonte: thread Ole Lehmann + Cheng/Stanford.
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 063eddb1..0650d00f 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3236,3 +3236,24 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **GUARD-STD-005** [P2] `prime` `gated:003` — L1 grounding nos chatbots RAG: citation enforcement + caminho "não sei" quando retrieval fraco. Guarani escreve casos; Prime revisa.
 - [x] **GUARD-STD-007** [P2] `guarani` `gated:004,006` — Suite red-team adversarial no eval-runner (jailbreak/injection/PII-exfil/off-topic/false-promise), ~20 casos PT-BR. Guarani constrói; Prime revisa; gate no CI.
 
+
+## Archived 2026-06-01
+
+### 🎯 LOOP DE AQUISIÇÃO + ENTREGA #3-#7 — North Star (council 2026-05-30)
+- [x] **CAQ-CLI-001** [P0] `[caminho B]` `divulgar-31` — Construir `bunx egos` real: adicionar `bin` no root `package.json` + CLI mínima honesta. FEITO.
+- [x] **CAQ-PAGE-001** [P0] `[caminho B]` `divulgar-31` — Recriar página egos.ia.br (Opção 2): posicionamento arquiteto-de-IA, convite a conhecer o trabalho + `bunx egos` + GitHub. **SEM pricing, SEM número — só chamar pra conversa.** FEITO 2026-06-01.
+
+### 🏛️ MULTI-AGENT GOVERNANCE (papéis LLM nomeados + Council/HITL) — 2026-05-30 (Antigravity propôs, Prime corrigiu phantoms)
+- [x] **GOV-AGENTS-004** [P2] `gated:002` — Implementar fluxo Council+HITL real: lockfile `.egos-lock` + payload p/ canal escolhido (Q1) + approve/reject. FEITO 2026-06-01 via `hitl-request.ts` + `x-approval-bot.ts` (Gemini).
+- [x] **GUARANI-006** [P1] `guarani` — Criar agente de monitoramento de coerência em background (`coordination-watcher.ts`) que resume diffs em tempo real em um Blackboard compartilhado (/tmp/egos-live-blackboard.md). FEITO 2026-06-01.
+- [x] **GUARANI-006-TELEMETRY** [P1] `guarani` — Persistência em `~/.egos/`, telemetria de custos/latência em JSONL e especificação do monitor de coordenação para replicação no Claude Code. FEITO 2026-06-01.
+
+
+## Archived 2026-06-01
+
+### 💰 VALUATION & ECV — Avaliação de capacidade/valor do EGOS (2026-05-31) [INICIATIVA SEPARADA de GUARDRAILS]
+- [x] **VAL-003** [P2] `prime` `gated:002` — Formalizar fórmula ECV (§4) como script calculável (`scripts/ecv-score.ts`) com inputs auditáveis; ≥1 dry-run sobre 1 capability real. FEITO 2026-06-01.
+
+### 🎯 NAME & PROVE — Campanha de Capacidade (Opus 2026-05-30, pós-3-agentes)
+- [x] **NAME-PROVE-003** [P2] — ✅ script `scripts/check-cbc-proof-paths.ts` construído + validado (W-05): 9/79 CBC com prova real, 57 placeholder pendente, 0 BLOCK; `--ci` só falha em live/in-progress sem prova (não alarme falso). Wired `--ci` no `capability-eval.yml` + endurecido W-02. FEITO 2026-06-01.
+
diff --git a/apps/egos-landing/src/homepage.jsx b/apps/egos-landing/src/homepage.jsx
index 414a9652..f2b41480 100644
--- a/apps/egos-landing/src/homepage.jsx
+++ b/apps/egos-landing/src/homepage.jsx
@@ -26,6 +26,42 @@ function Hero({ heroVariant = 'split' }) {
             }}>Conversar com a IA agora →</button>
             <a className="btn btn-ghost" href="#produtos" onClick={() => window.egosTrack('hero_cta_click', { variant: 'see_products' })}>Ver os 4 produtos ↓</a>
           </div>
+          <div className="hero-terminal" style={{
+            display: 'flex',
+            alignItems: 'center',
+            gap: '12px',
+            background: 'rgba(15, 23, 42, 0.6)',
+            backdropFilter: 'blur(8px)',
+            border: '1px solid rgba(255, 255, 255, 0.08)',
+            padding: '10px 16px',
+            borderRadius: '8px',
+            marginTop: '24px',
+            marginBottom: '20px',
+            fontFamily: 'var(--font-mono), monospace',
+            fontSize: '13px',
+            width: 'fit-content'
+          }}>
+            <span style={{ color: 'var(--accent)', fontWeight: 'bold' }}>$</span>
+            <code style={{ color: '#f8fafc', letterSpacing: '0.05em' }}>bunx egos status</code>
+            <span style={{ color: 'rgba(255, 255, 255, 0.25)', userSelect: 'none' }}>|</span>
+            <a 
+              href="https://github.com/enioxt/egos" 
+              target="_blank" 
+              rel="noopener noreferrer" 
+              style={{ 
+                color: '#94a3b8', 
+                textDecoration: 'none', 
+                display: 'flex', 
+                alignItems: 'center', 
+                gap: '4px',
+                transition: 'color 0.2s' 
+              }}
+              onMouseEnter={(e) => e.target.style.color = 'var(--accent)'}
+              onMouseLeave={(e) => e.target.style.color = '#94a3b8'}
+            >
+              GitHub open-source ↗
+            </a>
+          </div>
           <div className="hero-fine">
             <span>Pagamento apenas após entrega validada</span>
             <span>Sem fidelidade · saída livre</span>
@@ -85,7 +121,7 @@ function SecOferta() {
       h: 'Central EGOS',
       sub: 'Chatbot + base de conhecimento da empresa',
       p: 'Atende leads no WhatsApp ou Web, conduz qualificação em 6 fases, responde sobre seus documentos com fonte clicável. Para advogados, contadores, clínicas, consultores.',
-      tags: ['chatbot', 'KB', 'LGPD', 'a partir de R$1.000 + R$200/mês'],
+      tags: ['chatbot', 'KB', 'LGPD', 'mensalidade sob medida'],
       cta: 'Conversar com a IA',
       action: 'chat',
       featured: true,
@@ -94,7 +130,7 @@ function SecOferta() {
       h: 'Monitor Público',
       sub: 'Alertas regulatórios contínuos',
       p: 'Monitora diários oficiais e PNCP em 79+ territórios, classifica oportunidades por relevância, envia relatório semanal automático. Para empresas que vendem para governo.',
-      tags: ['B2G', 'OSINT', 'a partir de R$1.500/mês'],
+      tags: ['B2G', 'OSINT', 'mensalidade sob medida'],
       cta: 'Detalhes',
       action: 'link',
       href: '/monitor-publico',
@@ -103,7 +139,7 @@ function SecOferta() {
       h: 'Módulo Leitor',
       sub: 'Extração estruturada em lote',
       p: 'Recebe pacote de PDFs/Word, extrai pessoas, CNPJs, datas, valores, cláusulas. Entrega CSV + sumário no mesmo dia. Hash SHA-256 por documento (auditoria).',
-      tags: ['NER', 'lote', 'a partir de R$6.000/lote'],
+      tags: ['NER', 'lote', 'sob consulta por lote'],
       cta: 'Diagnóstico grátis',
       action: 'link',
       href: '/modulo-leitor',
@@ -435,14 +471,14 @@ function SecPricing() {
   return (
     <section className="section section-alt" id="precos">
       <div className="container">
-        <SectionHead eyebrow="Preços" title="Comece pequeno. Pague apenas após entrega." align="center" />
+        <SectionHead eyebrow="Preços" title="Planos sob medida. Pague apenas após entrega." align="center" />
         <div className="card pricing-anchor">
           <div className="pricing-from">
-            <span className="accent">a partir de R$1.000</span> setup<br/>
-            <span style={{fontSize: '0.7em', color: 'var(--text-muted)'}}>+ R$200/mês</span>
+            <span className="accent">Mensalidade sob medida</span><br/>
+            <span style={{fontSize: '0.7em', color: 'var(--text-muted)'}}>Consulte orçamento para seu volume</span>
           </div>
           <p className="muted" style={{maxWidth: 520}}>
-            O valor final depende do volume de documentos, canais e sensibilidade dos dados. Faça uma avaliação de 5 minutos com a IA para descobrir o plano ideal.
+            O valor final do setup e da mensalidade depende do volume de documentos, canais de atendimento e sensibilidade dos dados. Faça uma avaliação rápida de 5 minutos com nossa IA para obter uma proposta personalizada.
           </p>
           <div className="pricing-seals">
             <span className="pricing-seal">Pagamento apenas após entrega</span>
@@ -453,6 +489,31 @@ function SecPricing() {
             document.dispatchEvent(new CustomEvent('open-egos-chat'));
             window.egosTrack('pricing_cta_click');
           }}>Descobrir o plano ideal →</button>
+          
+          <div className="pricing-github" style={{
+            marginTop: '20px',
+            fontSize: '12px',
+            color: 'var(--text-muted)',
+            fontFamily: 'var(--font-mono), monospace',
+            display: 'flex',
+            justifyContent: 'center',
+            alignItems: 'center',
+            gap: '8px',
+            flexWrap: 'wrap'
+          }}>
+            <span>Quer auditar nossa governança em código aberto?</span>
+            <span>Rode <code style={{ color: 'var(--accent)', background: 'rgba(255,255,255,0.04)', padding: '2px 6px', borderRadius: '4px' }}>bunx egos doctor</code> ou acesse nosso</span>
+            <a 
+              href="https://github.com/enioxt/egos" 
+              target="_blank" 
+              rel="noopener noreferrer" 
+              style={{ color: 'var(--accent)', textDecoration: 'underline' }}
+              onMouseEnter={(e) => e.target.style.color = '#fff'}
+              onMouseLeave={(e) => e.target.style.color = 'var(--accent)'}
+            >
+              GitHub ↗
+            </a>
+          </div>
         </div>
       </div>
     </section>
diff --git a/docs/_current_handoffs/handoff_2026-06-01.md b/docs/_current_handoffs/handoff_2026-06-01.md
new file mode 100644
index 00000000..33b11f9a
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-01.md
@@ -0,0 +1,42 @@
+# Handoff — 2026-06-01 22:50
+
+## ✅ Accomplished (staged and ready to commit)
+- Local HITL Telegram Approval System — `staged` — [scripts/hitl-request.ts](file:///home/enio/egos/scripts/hitl-request.ts) and [scripts/x-approval-bot.ts](file:///home/enio/egos/scripts/x-approval-bot.ts)
+- Coordination Blackboard Watcher — `staged` — [scripts/coordination-watcher.ts](file:///home/enio/egos/scripts/coordination-watcher.ts)
+- Coordination Spec with Cost Analysis — `staged` — [docs/governance/COORDINATION_MONITOR_SPEC.md](file:///home/enio/egos/docs/governance/COORDINATION_MONITOR_SPEC.md)
+- Environment Precedence Hardening — `staged` — [scripts/doctor.ts](file:///home/enio/egos/scripts/doctor.ts)
+- Homepage Layout Redesign (consultative focus) — `staged` — [apps/egos-landing/src/homepage.jsx](file:///home/enio/egos/apps/egos-landing/src/homepage.jsx)
+- CI Capability Eval Hardening (W-02) and CBC Integrity Verification — `staged` — [.github/workflows/capability-eval.yml](file:///home/enio/egos/.github/workflows/capability-eval.yml)
+- Claude Code On-Ramp Blackboard Check — `staged` — [.agents/workflows/start.md](file:///home/enio/egos/.agents/workflows/start.md)
+
+## 🔄 In Progress
+- Coordination watcher agent running under task ID `task-2348` — 100% (execution verified, records written).
+
+## ⏳ Blocked
+- None.
+
+## 🔗 Next Steps (priority order)
+1. **[GUARANI-006] Commit and Push Staged Changes:** Execute `safe-push.sh` in the Claude Code session to finalize all staged components.
+2. **Review coordination watcher outputs:** Verify the background watcher correctly reports clean/dirty status in parallel runs.
+
+## 🌐 Environment State
+- Build: ✅
+- Tests: ✅ (check-cbc-proof-paths passes with 0 blocks)
+- Deploy: N/A
+- Disk: 14% | RAM: 16GB/32GB
+
+## 📌 Decisions Made (architectural)
+- Mirror local blackboard files to both volatile `/tmp` (fast read access for hooks) and persistent `~/.egos` (retains history across reboots).
+- Log telemetry data to append-only JSONL format (`coordination-history.jsonl`) for granular cost and latency profiling.
+- Enforce check-cbc-proof-paths `--ci` in GHA workflow to prevent live/in-progress capabilities from being committed without physical proof files on disk.
+
+## ✅ Todos da sessão (snapshot literal do TodoWrite)
+- [x] Refine `scripts/coordination-watcher.ts` for persistence & telemetry
+- [x] Create `docs/governance/COORDINATION_MONITOR_SPEC.md` spec file
+- [x] Add/refine subtasks in `TASKS.md`
+- [x] Verify execution and data generation in `/tmp` and `~/.egos`
+- [x] Harden capability-eval.yml CI workflow and run check-cbc-proof-paths.ts
+- [x] Implement Claude Code On-Ramp Blackboard Check in start.md
+
+## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
+- None.
diff --git a/docs/governance/COORDINATION_AGENTS_COST.md b/docs/governance/COORDINATION_AGENTS_COST.md
new file mode 100644
index 00000000..c1c4b1ff
--- /dev/null
+++ b/docs/governance/COORDINATION_AGENTS_COST.md
@@ -0,0 +1,136 @@
+# EGOS Coordination Agents & Token Cost Analysis
+
+> **Version:** 1.0.0 | **Updated:** 2026-06-01
+> **Status:** ACTIVE | **Classification:** GOVERNANCE / FINANCIAL
+> **SSOT Reference:** `docs/governance/COORDINATION_MONITOR_SPEC.md`
+
+This document analyzes the agent orchestration topology for coordination (Blackboard watch, VPS Hermes, and Coherence probes) and provides a rigorous calculation of token volume and financial costs.
+
+---
+
+## 1. Orchestrated Agent Topology
+
+To achieve absolute synchronization across environments (Antigravity local terminal, Claude Code primary window, and VPS Hermes daemon) without race conditions or index collisions, we run three specialized observer agents:
+
+```
+                  ┌──────────────────────────────┐
+                  │   Developer / Enio (HITL)    │
+                  └──────────────┬───────────────┘
+                                 │
+         ┌───────────────────────┼───────────────────────┐
+         ▼                       ▼                       ▼
+┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
+│ Local Watcher   │     │  Claude Code    │     │   Hermes Agent  │
+│ (coordination-  │◄───►│ (Primary IDE)   │◄───►│ (Evolution/VPS) │
+│  watcher.ts)    │     │                 │     │                 │
+└────────┬────────┘     └─────────────────┘     └────────┬────────┘
+         │                                               │
+         ▼                                               ▼
+  Blackboard Files                                Telegram Alerts
+ (/tmp & ~/.egos)                                (@EGOSin_bot)
+```
+
+### A. Local Workspace Watcher (`coordination-watcher.ts`)
+* **Role**: PASSIVE git/diff monitor.
+* **Mechanism**: Runs locally on a 15-second loop. Only invokes the LLM when `git status --porcelain` changes (delta-only activation).
+* **Target**: Writes to `/tmp/egos-live-blackboard.json` and `~/.egos/coordination-blackboard.json` to inform other agents during their initialization sequence.
+
+### B. VPS Hermes Agent (`hermes-trigger.sh` / `article-writer.ts`)
+* **Role**: POST-COMMIT review and publishing agent.
+* **Mechanism**: Triggered by a webhook on git pushes or a cron daemon. Reviews commit diffs and creates Telegram alerts / DB timeline entries.
+* **Target**: Evolves code quality telemetry database and handles safe publishing pipeline.
+
+### C. Constitutional Coherence Probe (`agent-validator.ts` / `context-watcher.ts`)
+* **Role**: COMPLIANCE validator.
+* **Mechanism**: Analyzes token footprint of active agent sessions and verifies if they touch frozen zones or violate canonical instructions.
+
+---
+
+## 2. Token Volume & Financial Calculations
+
+### 2.1 Model Selection Options (Q2 2026 Rates)
+
+| Model Name | Input Rate (per 1M tokens) | Output Rate (per 1M tokens) | Strengths |
+|---|---|---|---|
+| **Alibaba Qwen-turbo** | $0.05 | $0.20 | Extremely cheap, fast summary, good for delta git logs. |
+| **Gemini 1.5 Flash** | $0.075 | $0.30 | Massive context, highly robust schema formatting. |
+| **Claude 3.5 Haiku** | $0.80 | $4.00 | Superior reasoning, but significantly more expensive. |
+| **Alibaba Qwen-plus** | $0.40 | $1.20 | Coding specialist fallback, high accuracy. |
+
+---
+
+### 2.2 Local Watcher Cost Projection (`coordination-watcher.ts`)
+
+#### Parameters:
+* **System Prompt**: ~250 tokens
+* **User Input (git status + diff cap)**: ~1,250 tokens (avg cap of 4,000 characters)
+* **Response (Blackboard Markdown)**: ~450 tokens
+* **Average active dev hours**: 6 hours/day
+* **Triggers/hour**: ~15 times (when developer saves changes or stages files)
+
+#### Token Math:
+* **Input tokens per run**: 1,500 tokens
+* **Output tokens per run**: 450 tokens
+* **Total runs per day**: $15 \times 6 = 90$ runs/day
+
+#### Cost Scenarios (90 runs/day):
+
+* **Scenario A: Gemini 1.5 Flash (Recommended)**
+  * Input: $90 \times 1,500 \times \$0.075 / 1,000,000 = \$0.0101$
+  * Output: $90 \times 450 \times \$0.30 / 1,000,000 = \$0.0121$
+  * **Daily Cost**: **$0.022 USD** (~R$ 0.12/day)
+  * **Monthly Cost (20 days)**: **$0.44 USD** (~R$ 2.40/month)
+
+* **Scenario B: Qwen-turbo (Lowest Cost)**
+  * Input: $90 \times 1,500 \times \$0.05 / 1,000,000 = \$0.0067$
+  * Output: $90 \times 450 \times \$0.20 / 1,000,000 = \$0.0081$
+  * **Daily Cost**: **$0.015 USD** (~R$ 0.08/day)
+  * **Monthly Cost (20 days)**: **$0.30 USD** (~R$ 1.65/month)
+
+* **Scenario C: Claude 3.5 Haiku**
+  * Input: $90 \times 1,500 \times \$0.80 / 1,000,000 = \$0.108$
+  * Output: $90 \times 450 \times \$4.00 / 1,000,000 = \$0.162$
+  * **Daily Cost**: **$0.270 USD** (~R$ 1.48/day)
+  * **Monthly Cost (20 days)**: **$5.40 USD** (~R$ 29.70/month)
+
+---
+
+### 2.3 VPS Hermes Cost Projection
+
+#### Parameters:
+* **System Prompt**: ~800 tokens (detailed commit review rules)
+* **User Input (full commit diff + context)**: ~4,000 tokens (avg size)
+* **Response (Telemetry JSON + Review comments)**: ~800 tokens
+* **Average commits/day**: 20 commits
+
+#### Token Math:
+* **Input tokens per run**: 4,800 tokens
+* **Output tokens per run**: 800 tokens
+
+#### Cost Scenario (Gemini 1.5 Flash):
+* Input: $20 \times 4,800 \times \$0.075 / 1,000,000 = \$0.0072$
+* Output: $20 \times 800 \times \$0.30 / 1,000,000 = \$0.0048$
+* **Daily Cost**: **$0.012 USD** (~R$ 0.06/day)
+* **Monthly Cost (30 days)**: **$0.36 USD** (~R$ 1.98/month)
+
+---
+
+### 2.4 Total Orchestration Monthly Cost Projection
+
+When running the system fully integrated:
+1. **Local Watcher (Gemini 1.5 Flash)**: $0.44 USD / month
+2. **VPS Hermes (Gemini 1.5 Flash)**: $0.36 USD / month
+3. **Constitutional Probe (Qwen-turbo)**: $0.15 USD / month
+
+* **Total Monthly Budget**: **$0.95 USD** (~R$ 5.20 / month)
+* **Efficiency Rate**: Deduplicates overlapping agent steps, saving an estimated **$15.00 - $30.00 USD/month** in redundant Claude 3.5 Sonnet context reload costs. **Net Positive ROI: ~2000%**.
+
+---
+
+## 3. Deployment and Tuning Recommendations
+
+1. **Use Gemini 1.5 Flash / Qwen-plus as Default for Watchers**:
+   * Gemini 1.5 Flash provides unmatched schema consistency for JSON outputs and is extremely cost-effective.
+   * Do NOT use Claude 3.5 Sonnet/Haiku for routine watchers (it is 10x-50x more expensive without adding material summary improvements).
+2. **Delta-only Watch Loop**:
+   * Always verify that `git status --porcelain` is checked before invoking any LLM, ensuring we pay $0 when the developer is just reading code or idling.
diff --git a/docs/governance/COORDINATION_MONITOR_SPEC.md b/docs/governance/COORDINATION_MONITOR_SPEC.md
new file mode 100644
index 00000000..014359d1
--- /dev/null
+++ b/docs/governance/COORDINATION_MONITOR_SPEC.md
@@ -0,0 +1,154 @@
+# EGOS Coherence & Coordination Monitor Specification
+
+> **Version:** 1.0.0 | **Updated:** 2026-06-01
+> **Status:** ACTIVE | **Classification:** CANONICAL
+> **SSOT:** `.guarani/RULES_INDEX.md` (governance registry)
+
+This specification defines the background coordination and coherence monitor pattern utilized to synchronize multiple parallel AI agents (such as EGOS Prime/Claude Code, EGOS Operator, and Guarani/Antigravity) operating in the same workspace.
+
+---
+
+## 1. Background Coordination Architecture
+
+When multiple agents run concurrently, they risk colliding by modifying overlapping files or committing changes that break parallel operations. The **Coordination Monitor** solves this by acting as a passive, non-blocking background observer that maintains a shared, structured status board (the Blackboard).
+
+```mermaid
+graph TD
+    A[Workspace Changes] -->|git status / git diff| B(coordination-watcher.ts)
+    B -->|Check status delta| C{Is Status Changed?}
+    C -->|No| D[Sleep 15s]
+    C -->|Yes| E[Invoke AI via chatWithLLM]
+    E -->|Generate Blackboard Summary| F[Write Blackboard Files]
+    F -->|Volatile| G[/tmp/egos-live-blackboard.json]
+    F -->|Persistent| H[~/.egos/coordination-blackboard.json]
+    F -->|Telemetry| I[~/.egos/coordination-history.jsonl]
+```
+
+---
+
+## 2. Shared Blackboard Schema
+
+The blackboard files are written in two formats (JSON and Markdown) in both a volatile (`/tmp/`) and persistent (`~/.egos/`) directory.
+
+### 2.1 JSON Schema (`coordination-blackboard.json`)
+Located at `/tmp/egos-live-blackboard.json` and `~/.egos/coordination-blackboard.json`.
+```json
+{
+  "timestamp": "ISO-8601 string",
+  "head": "short git HEAD commit SHA",
+  "branch": "current git branch name",
+  "status": "clean | dirty | error",
+  "summary": "Concise Markdown summary produced by the LLM (PT-BR)",
+  "rawStatus": "raw git status output"
+}
+```
+
+### 2.2 Markdown Schema (`coordination-blackboard.md`)
+Located at `/tmp/egos-live-blackboard.md` and `~/.egos/coordination-blackboard.md`.
+Contains:
+1. Title and Last Updated Timestamp.
+2. Current Git metadata (HEAD commit and Branch name).
+3. Technical change summaries grouped by:
+   - Modified/added/deleted files.
+   - Technical impact.
+   - Potential conflicts (e.g. `package.json`, schemas, locks).
+   - Recommended validation commands.
+   - Next alignment instructions.
+
+---
+
+## 3. Telemetry and Analytics Schema (`coordination-history.jsonl`)
+
+To audit agent activity, resource usage, and latency, the watcher appends log events to `~/.egos/coordination-history.jsonl`.
+
+Each log entry is a single JSON line:
+```json
+{
+  "timestamp": "2026-06-01T01:10:26.627Z",
+  "status": "dirty | clean | error",
+  "head": "6cd59c7e",
+  "branch": "main",
+  "changedFilesCount": 15,
+  "modelUsed": "qwen3-coder-plus",
+  "tokensUsed": {
+    "prompt_tokens": 1827,
+    "completion_tokens": 502,
+    "total_tokens": 2329
+  },
+  "costUsd": 0.0,
+  "latencyMs": 17710,
+  "error": "Error message if status is error"
+}
+```
+
+---
+
+## 4. Environment Hardening Rule
+
+Due to differences in parent terminal execution shells, environment variables like `ALIBABA_API_KEY` or `OPENROUTER_API_KEY` may be defined as empty strings (`""`) by parent runtimes, blocking standard `dotenv` loaders from loading valid tokens from `.env`.
+
+To prevent credential loading failures, all daemons and scripts in the coordination layer MUST enforce override resolution:
+```typescript
+import { config } from 'dotenv';
+config({ override: true });
+```
+
+---
+
+## 5. Agent On-Ramp Integration (eg. `/start` phase)
+
+All agents initializing a session in an EGOS workspace must reference the persistent blackboard to understand current work in progress.
+
+### 5.1 Verification Checklist
+During the initialization phase (e.g., `/start` command or standard workflow boot), the agent must run:
+1. Check if `~/.egos/coordination-blackboard.json` exists.
+2. Parse the status:
+   - If `status === 'dirty'`, parse the summary and output a warning showing active changes:
+     ```
+     [WARNING] Active local changes detected! Check blackboard: ~/.egos/coordination-blackboard.md
+     ```
+   - If the timestamp is older than 5 minutes, log a warning indicating the coordination watcher daemon might be inactive.
+
+---
+
+## 6. Token Cost & Resource Efficiency Analysis
+
+To ensure maximum operational longevity and control costs, the coordination monitors are designed to minimize token usage while retaining high-fidelity alignment.
+
+### 6.1 Watcher Topologies
+To prevent redundant API calls, the system enforces a single running instance per environment:
+1. **Local Workspace (Antigravity & Claude Code):** Exactly **one** local background watcher daemon runs. Since both agents share the same filesystem (`/tmp/` and `~/.egos/`), they read the same local blackboard.
+2. **VPS Environment (Hermes Agent):** Non-polling, strictly event-driven. Activated only via incoming webhook payloads (Evolution API, Telegram, GitHub Webhooks).
+
+### 6.2 Token Mathematics (Daily & Monthly Cost Estimate)
+
+#### A. Local Coordination Watcher
+* **Trigger Rate:** Delta-driven (only calls LLM when `git status` changes). Estimated average of **30 modifications** in an active 8-hour coding day.
+* **Payload Size:**
+  * Input Prompt (diff sliced at 4,000 chars, system prompt, commits, status): **~1,750 tokens**.
+  * Output Prompt (structured summary): **~450 tokens**.
+* **Model Cost Matrix (per 30 calls/day):**
+
+| Model Provider | Input Cost / 1M | Output Cost / 1M | Cost per Call | Cost per Day (30 calls) | Cost per Month (22 days) |
+|---|---|---|---|---|---|
+| **Gemini 2.0 Flash (Free)** | $0.00 | $0.00 | $0.00 | **$0.00** | **$0.00** (Free limit: 15 RPM / 1k RPD) |
+| **Gemini 2.0 Flash (Paid)** | $0.075 | $0.30 | $0.000266 | **$0.00798** | **$0.175** |
+| **Qwen 2.5 Coder (DashScope)**| $0.07 | $0.14 | $0.000185 | **$0.00555** | **$0.122** |
+| **GPT-4o-mini (OpenRouter)** | $0.15 | $0.60 | $0.000532 | **$0.01596** | **$0.351** |
+
+#### B. VPS Hermes Event-Driven Agent
+* **Trigger Rate:** Event-driven. Estimated average of **100 message transactions** per day.
+* **Payload Size:**
+  * Input Prompt (context + transaction history): **~1,000 tokens**.
+  * Output Prompt (generated reply/routing action): **~200 tokens**.
+* **Model Cost Matrix (per 100 events/day):**
+
+| Model Provider | Input Cost / 1M | Output Cost / 1M | Cost per Call | Cost per Day (100 events) | Cost per Month (30 days) |
+|---|---|---|---|---|---|
+| **Gemini 2.0 Flash (Paid)** | $0.075 | $0.30 | $0.000135 | **$0.0135** | **$0.405** |
+| **Qwen 2.5 Coder (Paid)** | $0.07 | $0.14 | $0.000098 | **$0.0098** | **$0.294** |
+
+### 6.3 Configuration Recommendation
+To balance reliability and budget, EGOS adopts the following defaults:
+* **Local Watcher: Fast Fallback Chain** (`tier: 'fast'`). Defaults to **Gemini 2.0 Flash Free Tier** (via Google AI Studio key). If rate-limited or unavailable, falls back to **Qwen 3.5 Coder** (via Alibaba DashScope free tokens), ensuring the local coordination cost stays at **$0.00 / month**.
+* **VPS Hermes: Gemini 2.0 Flash (Paid)**. Its high capability-to-cost ratio, extremely low latency, and 1M context window make it the prime choice for webhook processing. Total cost is capped at **~$0.40 / month**.
diff --git a/docs/governance/HITL_CATALOG.md b/docs/governance/HITL_CATALOG.md
index f45f4930..5efa2cd3 100644
--- a/docs/governance/HITL_CATALOG.md
+++ b/docs/governance/HITL_CATALOG.md
@@ -13,7 +13,7 @@ ssot: docs/governance/HITL_CATALOG.md
 > sem entendimento humano. Cada gate aqui foi adicionado após um incidente real
 > ou após uma decisão consciente de "isto não pode rodar sem olho humano".
 
-Este catálogo lista os **3 gates HITL reais e implementados** hoje no kernel
+Este catálogo lista os **5 gates HITL reais e implementados** hoje no kernel
 EGOS, mais um **gap analysis** com gates que deveriam existir mas ainda não
 existem (apenas advertência ou erro, sem fluxo de aprovação humana).
 
diff --git a/docs/governance/PROCESS_CONTRACTS.md b/docs/governance/PROCESS_CONTRACTS.md
index bbeddf41..d7c37643 100644
--- a/docs/governance/PROCESS_CONTRACTS.md
+++ b/docs/governance/PROCESS_CONTRACTS.md
@@ -74,8 +74,8 @@ Status: ✅ existe e suficiente · 🟡 existe parcial (melhorar) · ⛔ lacuna
 | 1 | git | review staged diff | `docs/workflows/pre-commit.md` + §8.1 closure | 🟡 falta checklist de avaliação | não | recomendado | não |
 | 2 | git | commit consolidado (swarm) | `docs/governance/SWARM_COMMIT_POLICY.md` | ✅ | não | não | não |
 | 3 | git | pre-commit gates | `docs/governance/PRECOMMIT_SSOT.md` | ✅ | não | opt-in | não |
-| 4 | git | **safe-push** | — (usado, não documentado como contrato) | ⛔ §5 abaixo | se zona sensível | não | não |
-| 5 | git | rollback | espalhado | ⛔ falta contrato único | sim | não | não |
+| 4 | git | **safe-push** | — (usado, não documentado como contrato) | ✅ §5 abaixo | se zona sensível | não | não |
+| 5 | git | rollback | espalhado | ✅ §6.5 abaixo | sim | não | não |
 | 6 | governança | ações contaminantes | `docs/governance/AI_AGENT_WORKFLOW.md` + `ZONA_EXTREMA.md` | 🟡 sem lista canônica única | sim | — | — |
 | 7 | governança | HITL | `docs/governance/HITL_CATALOG.md` | ✅ | — | — | — |
 | 8 | governança | Council/Quorum | `docs/governance/council.md` + `QUORUM_PROTOCOL.md` + `scripts/council.ts` | ✅ | sim | — | sim |
@@ -88,7 +88,7 @@ Status: ✅ existe e suficiente · 🟡 existe parcial (melhorar) · ⛔ lacuna
 | 15 | capability | registrar/atualizar capability | `docs/governance/CAPABILITY_SCHEMA.md` + `docs/capabilities/_TEMPLATE.md` | ✅ | não | não | não |
 | 16 | agentes | registry de agentes | `agents/registry/agents.json` + registry-parity hook | ✅ | não | não | não |
 
-**Conclusão da rodada 1:** dos 16 processos, **só 3 são lacunas reais** (safe-push contract, rollback contract, lista canônica de ações contaminantes) e **3 são parciais** (review-diff checklist, /start-lê-Blackboard, ações contaminantes). O resto já existe e é suficiente — não recriar.
+**Conclusão da rodada 1:** dos 16 processos, **só 1 é lacuna real** (lista canônica de ações contaminantes) e **3 são parciais** (review-diff checklist, /start-lê-Blackboard, ações contaminantes). O resto já existe, está documentado e é suficiente — não recriar.
 
 ---
 
@@ -178,6 +178,57 @@ Prompt-injection via blackboard (outra janela/processo escreve instrução malic
 
 ---
 
+## 6.5. Contract — Rollback (LACUNA preenchida)
+
+## Categoria
+git / deploy / segurança
+
+## Objetivo
+Desfazer rapidamente qualquer alteração que quebre o ambiente local ou de produção, retornando o sistema a um estado seguro conhecido.
+
+## Quando usar
+Erros de build pós-push, falhas críticas de runtime em produção (ex: 502/503), vazamentos acidentais de credenciais ou commits inválidos que violam políticas congeladas.
+
+## Agentes
+- Executa: Prime / Operator / Guarani
+- Propõe: Qualquer agente/monitor ao detectar anomalia
+- Revisa/Aprova (HITL): Enio se envolver banco de dados ou ambiente de produção (VPS)
+
+## Pré-condições
+Identificação do SHA estável anterior e confirmação de que o rollback não corrompe esquemas ou dados no Supabase (se houver migração pendente, rodar migração de reversão primeiro).
+
+## Passo a passo (Rollback de Código/Git)
+1. Identificar o último commit íntegro estável com `git log --oneline -n 10`.
+2. Em ambiente local:
+   * Para descartar alterações não commitadas: `git restore .` ou `git reset --hard HEAD`.
+   * Para voltar a um commit anterior local: `git reset --hard <stable-sha>`.
+3. Em repositório remoto (se já pushado):
+   * Executar `git revert <bad-sha>` (cria um commit inverso limpo).
+   * Executar validações locais (`bun run doctor` / `tsc`).
+   * Fazer push via contrato de `Safe Push` (nunca force-push para main).
+
+## Passo a passo (Rollback de Deploy/VPS)
+1. Acessar a VPS Hetzner via SSH.
+2. Navegar até o serviço afetado (ex: `/opt/egos-gateway/` ou `/opt/hermes-agent/`).
+3. Se o script de deploy possui rollback automatizado: executar `bash deploy.sh --rollback`.
+4. Se for manual:
+   * Dar rollback no branch Git local da VPS para o commit estável.
+   * Executar `pm2 restart <service-name> --update-env` para garantir a recarga das variáveis de ambiente corretas.
+5. Executar smoke tests locais na VPS (ex: `curl http://127.0.0.1:<port>/health`).
+
+## Validações obrigatórias
+* Build e Typecheck limpos no ambiente de destino.
+* Endpoint de Health check respondendo status HTTP 200/207.
+* Monitoramento de logs (`pm2 logs` ou journalctl) limpo de crash loops por pelo menos 60 segundos.
+
+## Critérios de aceite
+Uptime restabelecido (health check OK), repositório limpo, e notificação de status de rollback enviada ao canal do Enio via Telegram.
+
+## Evidências a registrar
+SHA do commit de reversão (ou SHA de destino do rollback) + log de status do health check.
+
+---
+
 ## 7. Próxima rodada (não fazer tudo agora)
 
 Tasks propostas (P0/P1) ficam em TASKS.md, cada uma referenciando seu contrato aqui. Disseminação em `CLAUDE.md`/`AGENTS.md`/`/start` é **contaminante** → só após corte do Enio.
diff --git a/docs/jobs/2026-05-31-doc-drift-verifier.json b/docs/jobs/2026-05-31-doc-drift-verifier.json
new file mode 100644
index 00000000..d8e85bf2
--- /dev/null
+++ b/docs/jobs/2026-05-31-doc-drift-verifier.json
@@ -0,0 +1,231 @@
+{
+  "manifest": "/home/enio/egos/.egos-manifest.yaml",
+  "repo": "egos",
+  "verified_at": "2026-05-31T15:29:46.441Z",
+  "summary": {
+    "total_claims": 15,
+    "passed": 14,
+    "warned": 0,
+    "drifted": 0,
+    "errors": 1,
+    "total_domains": 9,
+    "domains_ok": 6,
+    "domains_drifted": 3
+  },
+  "results": [
+    {
+      "id": "total_agents",
+      "description": "Agents registered in agents.json",
+      "status": "ok",
+      "last_value": "23",
+      "current_value": "24",
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
+      "last_value": "62",
+      "current_value": "66",
+      "tolerance": "±5",
+      "drift_abs": 4,
+      "command": "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "slash_commands",
+      "description": "User-invocable slash commands in .claude/commands/",
+      "status": "ok",
+      "last_value": "42",
+      "current_value": "43",
+      "tolerance": "±5",
+      "drift_abs": 1,
+      "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "kernel_packages",
+      "description": "Packages in packages/ directory",
+      "status": "ok",
+      "last_value": "33",
+      "current_value": "33",
+      "tolerance": "±2",
+      "drift_abs": 0,
+      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "commits_30d_all_repos",
+      "description": "Total commits across all active EGOS repos in last 30 days",
+      "status": "ok",
+      "last_value": "1466",
+      "current_value": "1138",
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
+      "status": "error",
+      "last_value": "1",
+      "current_value": "",
+      "tolerance": "min:1",
+      "command": "grep -c '^- \\[x\\]' TASKS.md",
+      "error": "exit code 1",
+      "severity": "error"
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
+      "current_value": "86",
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
+      "current_value": "147",
+      "tolerance": "min:15",
+      "command": "grep -c '\\[' .husky/pre-commit",
+      "severity": "ok"
+    }
+  ],
+  "domains": [
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "drifted",
+      "expected_status": "200",
+      "actual_status": "502"
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
+      "expected_status": "200",
+      "actual_status": "200"
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
+      "status": "drifted",
+      "expected_status": "200",
+      "actual_status": "502",
+      "contains_check": false
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200",
+      "contains_check": true
+    },
+    {
+      "status": "error",
+      "expected_status": "undefined",
+      "actual_status": "connection_error",
+      "error": "TypeError [ERR_INVALID_URL]: fetch() URL must not be a blank string."
+    }
+  ],
+  "exit_code": 2
+}
\ No newline at end of file
diff --git a/docs/jobs/2026-05-31-pre-commit-pipeline.json b/docs/jobs/2026-05-31-pre-commit-pipeline.json
new file mode 100644
index 00000000..f11c4806
--- /dev/null
+++ b/docs/jobs/2026-05-31-pre-commit-pipeline.json
@@ -0,0 +1,242 @@
+[
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T02:27:14.496Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=3358c43b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T02:36:57.215Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=bd3d807b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T02:58:38.395Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=dfa43d88",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:00:55.309Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=4e7bcb43",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:16:52.961Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=7 sha=f1912bf1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:30:34.210Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=19 sha=69b2259d",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:36:50.651Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=6 sha=6f02b348",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:50:01.361Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=11 sha=a5fb4c3f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T03:55:06.175Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=06c16f4f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T04:28:56.846Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=19 sha=e43c6e3b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T04:29:29.768Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=8017abd4",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T04:30:29.258Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=17 sha=8e5655c2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T04:34:41.781Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=514a6605",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T04:36:27.533Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=1c45642c",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:21:53.715Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=599a3171",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:23:47.181Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=8af87a81",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:32:42.015Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=aa844e1f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:38:25.655Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=379476c4",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:48:03.107Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=5 sha=b625a37e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:49:01.112Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=ea06c9e2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:49:48.192Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=80c7c408",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T12:50:39.970Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=c8d99eb6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T13:04:35.757Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=4 sha=15b087c7",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T13:08:20.697Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=3 sha=e1afb313",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T13:09:01.650Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=b6cf05cf",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T14:07:24.249Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=9cbd3c55",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T14:07:37.618Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=2d237b5c",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T15:20:13.838Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=8 sha=b1e56baf",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T15:29:47.771Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=fe68b143",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-05-31T23:22:32.474Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=f2b62905",
+    "repo": "/home/enio/egos"
+  }
+]
diff --git a/docs/jobs/2026-06-01-doc-drift-verifier.json b/docs/jobs/2026-06-01-doc-drift-verifier.json
new file mode 100644
index 00000000..79da5414
--- /dev/null
+++ b/docs/jobs/2026-06-01-doc-drift-verifier.json
@@ -0,0 +1,231 @@
+{
+  "manifest": "/home/enio/egos/.egos-manifest.yaml",
+  "repo": "egos",
+  "verified_at": "2026-06-01T01:19:46.492Z",
+  "summary": {
+    "total_claims": 15,
+    "passed": 14,
+    "warned": 0,
+    "drifted": 0,
+    "errors": 1,
+    "total_domains": 9,
+    "domains_ok": 6,
+    "domains_drifted": 3
+  },
+  "results": [
+    {
+      "id": "total_agents",
+      "description": "Agents registered in agents.json",
+      "status": "ok",
+      "last_value": "23",
+      "current_value": "24",
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
+      "last_value": "62",
+      "current_value": "66",
+      "tolerance": "±5",
+      "drift_abs": 4,
+      "command": "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "slash_commands",
+      "description": "User-invocable slash commands in .claude/commands/",
+      "status": "ok",
+      "last_value": "42",
+      "current_value": "43",
+      "tolerance": "±5",
+      "drift_abs": 1,
+      "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "kernel_packages",
+      "description": "Packages in packages/ directory",
+      "status": "ok",
+      "last_value": "33",
+      "current_value": "33",
+      "tolerance": "±2",
+      "drift_abs": 0,
+      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "commits_30d_all_repos",
+      "description": "Total commits across all active EGOS repos in last 30 days",
+      "status": "ok",
+      "last_value": "1466",
+      "current_value": "1115",
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
+      "status": "error",
+      "last_value": "1",
+      "current_value": "",
+      "tolerance": "min:1",
+      "command": "grep -c '^- \\[x\\]' TASKS.md",
+      "error": "exit code 1",
+      "severity": "error"
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
+      "current_value": "86",
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
+      "current_value": "147",
+      "tolerance": "min:15",
+      "command": "grep -c '\\[' .husky/pre-commit",
+      "severity": "ok"
+    }
+  ],
+  "domains": [
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "drifted",
+      "expected_status": "200",
+      "actual_status": "502"
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
+      "expected_status": "200",
+      "actual_status": "200"
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
+      "status": "drifted",
+      "expected_status": "200",
+      "actual_status": "502",
+      "contains_check": false
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200",
+      "contains_check": true
+    },
+    {
+      "status": "error",
+      "expected_status": "undefined",
+      "actual_status": "connection_error",
+      "error": "TypeError [ERR_INVALID_URL]: fetch() URL must not be a blank string."
+    }
+  ],
+  "exit_code": 2
+}
\ No newline at end of file
diff --git a/docs/jobs/2026-06-01-handoff-fidelity.json b/docs/jobs/2026-06-01-handoff-fidelity.json
new file mode 100644
index 00000000..9be01e37
--- /dev/null
+++ b/docs/jobs/2026-06-01-handoff-fidelity.json
@@ -0,0 +1,15 @@
+[
+  {
+    "ts": "2026-06-01T00:44:45.084Z",
+    "file": "docs/_current_handoffs/handoff_2026-05-31-guarani-close.md",
+    "done_claims": 1,
+    "done_with_sha": 0,
+    "claims_with_sha_pct": 0,
+    "inprogress_items": 0,
+    "inprogress_with_next": 0,
+    "inprogress_next_pct": 100,
+    "todos_persisted": true,
+    "decisions_captured": true,
+    "completeness_score": 60
+  }
+]
diff --git a/docs/jobs/2026-06-01-pre-commit-pipeline.json b/docs/jobs/2026-06-01-pre-commit-pipeline.json
new file mode 100644
index 00000000..bc56f209
--- /dev/null
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -0,0 +1,130 @@
+[
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:36:35.657Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=3 sha=33c8bbac",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:39:04.494Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=28 sha=48fd763b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:41:35.242Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=11 sha=66213fbc",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:42:19.387Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=8 sha=849918f9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:42:48.808Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=6 sha=9b76f098",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:43:53.344Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=5 sha=6b118ab2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:44:48.683Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=282a3c8f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:56:15.477Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=845cce00",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T00:59:07.206Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=666659b2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:00:16.042Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=6cd59c7e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:20:49.021Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=6822b680",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:27:56.667Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=50cae8d5",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:36:01.083Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=a37dcb06",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:40:53.270Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=5db7cddb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:41:52.351Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=e89845f0",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T01:48:15.585Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=f2a6a60f",
+    "repo": "/home/enio/egos"
+  }
+]
diff --git a/package.json b/package.json
index c6ca4317..e4624f4e 100644
--- a/package.json
+++ b/package.json
@@ -24,6 +24,7 @@
     "agent:list": "bun agents/cli.ts list",
     "agent:run": "bun agents/cli.ts run",
     "agent:lint": "bun agents/cli.ts lint-registry",
+    "coordination:watch": "bun run scripts/coordination-watcher.ts",
     "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
     "lint": "eslint .",
     "prepare": "husky",
diff --git a/scripts/check-visual-proof.sh b/scripts/check-visual-proof.sh
index e2fa7ac9..8ac84e09 100755
--- a/scripts/check-visual-proof.sh
+++ b/scripts/check-visual-proof.sh
@@ -37,6 +37,15 @@ if [ -z "$UI_TOUCHED" ]; then
   exit 0
 fi
 
+# Se tocou storefront crítico, força strict mode para exigir prova visual (Karpathy Doctrine)
+STOREFRONT_TOUCHED=$(echo "$UI_TOUCHED" | grep -E 'central-egos/template/src/app/\(storefront\)/|central-egos/template/src/components/storefront/' || true)
+if [ -n "$STOREFRONT_TOUCHED" ]; then
+  echo "🚨 CRITICAL STOREFRONT PATHS TOUCHED:"
+  echo "$STOREFRONT_TOUCHED" | sed 's/^/    /'
+  echo "🔒 Forcing EGOS_VISUAL_PROOF_STRICT=1 for storefront stability."
+  EGOS_VISUAL_PROOF_STRICT=1
+fi
+
 echo "🚪 VISUAL PROOF GATE — UI surface tocada nesta mudança:"
 echo "$UI_TOUCHED" | sed 's/^/    /'
 echo ""
diff --git a/scripts/coordination-watcher.ts b/scripts/coordination-watcher.ts
new file mode 100755
index 00000000..a73ab3be
--- /dev/null
+++ b/scripts/coordination-watcher.ts
@@ -0,0 +1,248 @@
+#!/usr/bin/env bun
+/**
+ * EGOS Coherence & Coordination Blackboard Watcher [GUARANI-006]
+ * 
+ * Runs as a background daemon to monitor local git status and diffs.
+ * Leverages free-tier LLM models to organize changes and post them
+ * to a shared blackboard in /tmp, preventing conflicts between parallel agents.
+ */
+
+import { writeFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
+import { execSync } from 'node:child_process';
+import { resolve } from 'node:path';
+import { homedir } from 'node:os';
+import { config } from 'dotenv';
+import { chatWithLLM } from '../packages/shared/src/llm-provider';
+
+config({ override: true });
+
+const REPO_ROOT = resolve(import.meta.dir, '..');
+const VOLATILE_BLACKBOARD_JSON = '/tmp/egos-live-blackboard.json';
+const VOLATILE_BLACKBOARD_MD = '/tmp/egos-live-blackboard.md';
+
+const EGOS_DIR = resolve(homedir(), '.egos');
+if (!existsSync(EGOS_DIR)) {
+  mkdirSync(EGOS_DIR, { recursive: true });
+}
+
+const PERSISTENT_BLACKBOARD_JSON = resolve(EGOS_DIR, 'coordination-blackboard.json');
+const PERSISTENT_BLACKBOARD_MD = resolve(EGOS_DIR, 'coordination-blackboard.md');
+const TELEMETRY_HISTORY_JSONL = resolve(EGOS_DIR, 'coordination-history.jsonl');
+
+let lastStatusString = '';
+
+function sh(cmd: string, cwd: string): string {
+  try {
+    return execSync(cmd, { cwd, encoding: 'utf8', timeout: 10000 }).trim();
+  } catch (e) {
+    return '';
+  }
+}
+
+function logTelemetry(event: {
+  timestamp: string;
+  status: 'clean' | 'dirty' | 'error';
+  head: string;
+  branch: string;
+  changedFilesCount: number;
+  modelUsed: string | null;
+  tokensUsed: {
+    prompt_tokens: number;
+    completion_tokens: number;
+    total_tokens: number;
+  } | null;
+  costUsd: number | null;
+  latencyMs: number;
+  error?: string;
+}) {
+  try {
+    appendFileSync(TELEMETRY_HISTORY_JSONL, JSON.stringify(event) + '\n', 'utf8');
+  } catch (err: any) {
+    console.error(`[COORDINATION] Failed to write telemetry: ${err.message}`);
+  }
+}
+
+async function runAnalysis(status: string, diff: string, commits: string) {
+  console.log(`[COORDINATION] Changes detected. Invoking AI summary...`);
+  const startTime = Date.now();
+  
+  const systemPrompt = `You are the EGOS Coherence & Coordination Monitor. 
+Analyze the current workspace modifications (git status, recent commits, and file diffs).
+Your goal is to compile a clean, highly technical blackboard summary to coordinate between parallel AI agents.
+Identify:
+1. Files modified/added/deleted.
+2. High-level technical impact of the changes (what was implemented/fixed).
+3. Potential conflicts (e.g. changes in package.json, configuration files, or database schemas).
+4. Recommended validation commands (e.g. tsc, bun test, etc.) or alignment instructions.
+
+Answer in a concise, bulleted markdown format in Portuguese (PT-BR) as this is used by Enio and the agents locally. 
+Be precise and avoid fluff.`;
+
+  const userPrompt = JSON.stringify({
+    timestamp: new Date().toISOString(),
+    gitStatus: status,
+    gitDiff: diff.slice(0, 4000), // Cap at 4k chars to avoid token bloat
+    recentCommits: commits,
+  }, null, 2);
+
+  try {
+    const result = await chatWithLLM({
+      tier: 'fast',
+      temperature: 0.1,
+      maxTokens: 1000,
+      systemPrompt,
+      userPrompt,
+    });
+    const latencyMs = Date.now() - startTime;
+    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+
+    const markdownContent = [
+      `# 📋 EGOS Live Coordination Blackboard`,
+      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+      `*Commit HEAD: ${headSha}*`,
+      `*Ramo (Branch): ${branchName}*`,
+      `\n---`,
+      result.content,
+    ].join('\n');
+
+    const jsonContent = {
+      timestamp: new Date().toISOString(),
+      head: headSha,
+      branch: branchName,
+      status: 'dirty',
+      summary: result.content,
+      rawStatus: status,
+    };
+
+    // Write to volatile
+    writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
+    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+
+    // Write to persistent
+    writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
+    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+    console.log(`[COORDINATION] Blackboard successfully updated (both /tmp and ~/.egos).`);
+
+    const changedFilesCount = status ? status.split('\n').filter(Boolean).length : 0;
+    logTelemetry({
+      timestamp: new Date().toISOString(),
+      status: 'dirty',
+      head: headSha,
+      branch: branchName,
+      changedFilesCount,
+      modelUsed: result.model || 'unknown',
+      tokensUsed: result.usage || null,
+      costUsd: result.cost_usd ?? null,
+      latencyMs,
+    });
+  } catch (err: any) {
+    const latencyMs = Date.now() - startTime;
+    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+    console.error(`[COORDINATION] Failed to analyze changes: ${err.message}`);
+
+    logTelemetry({
+      timestamp: new Date().toISOString(),
+      status: 'error',
+      head: headSha,
+      branch: branchName,
+      changedFilesCount: status ? status.split('\n').filter(Boolean).length : 0,
+      modelUsed: null,
+      tokensUsed: null,
+      costUsd: null,
+      latencyMs,
+      error: err.message,
+    });
+  }
+}
+
+function writeCleanState() {
+  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+  
+  const markdownContent = [
+    `# 📋 EGOS Live Coordination Blackboard`,
+    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+    `*Commit HEAD: ${headSha}*`,
+    `*Ramo (Branch): ${branchName}*`,
+    `\n---`,
+    `🟢 **Ecosystem is CLEAN.** Nenhum arquivo modificado ou não-rastreado detectado localmente.`,
+  ].join('\n');
+
+  const jsonContent = {
+    timestamp: new Date().toISOString(),
+    head: headSha,
+    branch: branchName,
+    status: 'clean',
+    summary: '🟢 Ecosystem is CLEAN. No local changes.',
+    rawStatus: '',
+  };
+
+  // Write to volatile
+  writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
+  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+
+  // Write to persistent
+  writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
+  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+  console.log(`[COORDINATION] Blackboard marked clean (both /tmp and ~/.egos).`);
+
+  logTelemetry({
+    timestamp: new Date().toISOString(),
+    status: 'clean',
+    head: headSha,
+    branch: branchName,
+    changedFilesCount: 0,
+    modelUsed: null,
+    tokensUsed: null,
+    costUsd: null,
+    latencyMs: 0,
+  });
+}
+
+async function checkWorkspace() {
+  const status = sh('git status --porcelain', REPO_ROOT);
+  
+  if (status === lastStatusString) {
+    return; // No change in file status
+  }
+  
+  lastStatusString = status;
+
+  if (!status) {
+    console.log(`[COORDINATION] Workspace is clean.`);
+    writeCleanState();
+    return;
+  }
+
+  const diff = sh('git diff --no-color', REPO_ROOT);
+  const commits = sh('git log -n 5 --oneline', REPO_ROOT);
+  
+  await runAnalysis(status, diff, commits);
+}
+
+async function main() {
+  console.log(`[COORDINATION] Starting background watcher on ${REPO_ROOT}...`);
+  
+  // Run an immediate check on startup
+  await checkWorkspace();
+  
+  // Listen for SIGINT
+  process.on('SIGINT', () => {
+    console.log(`\n[COORDINATION] Watcher shutting down.`);
+    process.exit(0);
+  });
+
+  // Watch loop every 15 seconds
+  while (true) {
+    try {
+      await checkWorkspace();
+    } catch (e: any) {
+      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
+    }
+    await new Promise((r) => setTimeout(r, 15000));
+  }
+}
+
+main();
diff --git a/scripts/deploy-rls-auditor.sh b/scripts/deploy-rls-auditor.sh
index 406abcb4..ef27093c 100644
--- a/scripts/deploy-rls-auditor.sh
+++ b/scripts/deploy-rls-auditor.sh
@@ -15,6 +15,7 @@ SCRIPT_SOURCE="scripts/security/rls-auditor-comprehensive.ts"
 SCRIPT_TARGET="/opt/egos-scripts/rls-auditor.ts"
 LOG_DIR="/var/log/egos"
 LOG_FILE="${LOG_DIR}/rls-audit.log"
+VPS_EGOS_DIR="${VPS_EGOS_DIR:-/home/enio/egos}"
 
 echo "═══════════════════════════════════════════════════════════════"
 echo "  RLS Auditor VPS Deployment"
@@ -31,7 +32,7 @@ echo ""
 # Verify script exists
 if [ ! -f "$SCRIPT_SOURCE" ]; then
   echo "❌ ERROR: Script not found: $SCRIPT_SOURCE"
-  echo "   Run from kernel repo root: /home/enio/egos"
+  echo "   Run from kernel repo root."
   exit 1
 fi
 
@@ -58,7 +59,7 @@ scp "$SCRIPT_SOURCE" "$VPS_USER@$VPS_HOST:$SCRIPT_TARGET"
 ssh "$VPS_USER@$VPS_HOST" "chmod +x $SCRIPT_TARGET"
 
 # Create cron job entry
-CRON_ENTRY="$VPS_CRON_MIN $VPS_CRON_HOUR * * * cd /home/enio/egos && /usr/bin/bun $SCRIPT_TARGET --alert >> $LOG_FILE 2>&1"
+CRON_ENTRY="$VPS_CRON_MIN $VPS_CRON_HOUR * * * cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --alert >> $LOG_FILE 2>&1"
 
 # Install cron job
 echo "⏰ Installing cron job..."
@@ -108,7 +109,7 @@ EOF
 # Test the auditor
 echo ""
 echo "🧪 Running test audit..."
-ssh "$VPS_USER@$VPS_HOST" "cd /home/enio/egos && /usr/bin/bun $SCRIPT_TARGET --check 2>&1 | tail -5"
+ssh "$VPS_USER@$VPS_HOST" "cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --check 2>&1 | tail -5"
 
 # Display summary
 echo ""
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index a963f120..cbc45b74 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -26,6 +26,9 @@
 import { existsSync, readFileSync, writeFileSync, mkdirSync, statSync } from 'node:fs';
 import { execSync } from 'node:child_process';
 import { resolve, join } from 'node:path';
+import { config } from 'dotenv';
+
+config({ override: true });
 
 // ═══════════════════════════════════════════════════════════
 // Configuration & Flags
diff --git a/scripts/ecv-score.ts b/scripts/ecv-score.ts
new file mode 100644
index 00000000..1bbd7dc2
--- /dev/null
+++ b/scripts/ecv-score.ts
@@ -0,0 +1,192 @@
+#!/usr/bin/env bun
+/**
+ * EGOS Capability Valuation (ECV) Calculator [VAL-003]
+ * 
+ * Computes the ECV score based on 5 weighted dimensions:
+ * Tech (30%), Cap (25%), Market (20%), Trust (15%), Strat (10%).
+ */
+
+import { parseArgs } from 'util';
+import { existsSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';
+import { resolve } from 'node:path';
+import { homedir } from 'node:os';
+
+const EGOS_DIR = resolve(homedir(), '.egos');
+if (!existsSync(EGOS_DIR)) {
+  mkdirSync(EGOS_DIR, { recursive: true });
+}
+const DEFAULT_INPUTS_FILE = resolve(EGOS_DIR, 'ecv-inputs.json');
+
+interface ECVInputs {
+  tech: number;   // 0-1000
+  cap: number;    // 0-1000
+  market: number; // 0-1000
+  trust: number;  // 0-1000
+  strat: number;  // 0-1000
+  metadata?: {
+    name?: string;
+    description?: string;
+    targetVersion?: string;
+  };
+}
+
+const weights = {
+  tech: 0.30,
+  cap: 0.25,
+  market: 0.20,
+  trust: 0.15,
+  strat: 0.10
+};
+
+function calculateECV(inputs: ECVInputs) {
+  const techScore = inputs.tech * weights.tech;
+  const capScore = inputs.cap * weights.cap;
+  const marketScore = inputs.market * weights.market;
+  const trustScore = inputs.trust * weights.trust;
+  const stratScore = inputs.strat * weights.strat;
+  
+  const total = techScore + capScore + marketScore + trustScore + stratScore;
+  
+  return {
+    breakdown: {
+      tech: { raw: inputs.tech, weighted: techScore },
+      cap: { raw: inputs.cap, weighted: capScore },
+      market: { raw: inputs.market, weighted: marketScore },
+      trust: { raw: inputs.trust, weighted: trustScore },
+      strat: { raw: inputs.strat, weighted: stratScore }
+    },
+    total
+  };
+}
+
+function printReport(inputs: ECVInputs, results: ReturnType<typeof calculateECV>) {
+  const name = inputs.metadata?.name || 'EGOS Ecosystem/Capability';
+  const desc = inputs.metadata?.description || 'General evaluation';
+  
+  console.log(`\n==================================================`);
+  console.log(`📊 EGOS CAPABILITY VALUATION (ECV) REPORT`);
+  console.log(`==================================================`);
+  console.log(`Target: ${name}`);
+  console.log(`Description: ${desc}`);
+  console.log(`Date: ${new Date().toLocaleDateString('pt-BR')}`);
+  console.log(`--------------------------------------------------`);
+  
+  const fmtRow = (label: string, weight: number, raw: number, weighted: number) => {
+    const padLabel = label.padEnd(12);
+    const pct = `${(weight * 100).toFixed(0)}%`.padStart(4);
+    const rawStr = raw.toString().padStart(4);
+    const wStr = weighted.toFixed(1).padStart(6);
+    return `${padLabel} | Peso: ${pct} | Raw: ${rawStr}/1000 | Weighted: ${wStr}`;
+  };
+  
+  console.log(fmtRow('Tech (Código)', weights.tech, inputs.tech, results.breakdown.tech.weighted));
+  console.log(fmtRow('Cap (Orquest.)', weights.cap, inputs.cap, results.breakdown.cap.weighted));
+  console.log(fmtRow('Market (Mkt)', weights.market, inputs.market, results.breakdown.market.weighted));
+  console.log(fmtRow('Trust (Transp)', weights.trust, inputs.trust, results.breakdown.trust.weighted));
+  console.log(fmtRow('Strat (Rar.)', weights.strat, inputs.strat, results.breakdown.strat.weighted));
+  console.log(`--------------------------------------------------`);
+  
+  const totalStr = results.total.toFixed(1);
+  console.log(`🏆 TOTAL ECV SCORE: ${totalStr} / 1000`);
+  
+  let grade = 'F';
+  if (results.total >= 900) grade = 'S (Outperforming)';
+  else if (results.total >= 800) grade = 'A (Excellent)';
+  else if (results.total >= 700) grade = 'B (Good)';
+  else if (results.total >= 500) grade = 'C (Fair)';
+  else if (results.total >= 300) grade = 'D (Poor)';
+  
+  console.log(`Grade: ${grade}`);
+  console.log(`==================================================\n`);
+}
+
+// Dry-run example inputs for a default dry-run if no arguments provided
+const dryRunInputs: ECVInputs = {
+  tech: 850, // High because of validated LOC, multi-agent frameworks, strict CI/CD
+  cap: 900,  // Very high due to multi-agent orquestration, LGPD & blockchain domain intersec
+  market: 650, // Medium because MRR is currently low/pre-revenue, but high cost reduction
+  trust: 950, // Extremely high: public commits, telemetry, incident tracking (INC-001..009)
+  strat: 900, // Very high: PC-MG active officer + AI native + tokenomics
+  metadata: {
+    name: 'EGOS Core (Guarani & Monitor Layer)',
+    description: 'Dry-run evaluation of the core agentic framework'
+  }
+};
+
+const { values } = parseArgs({
+  args: Bun.argv,
+  options: {
+    tech: { type: 'string' },
+    cap: { type: 'string' },
+    market: { type: 'string' },
+    trust: { type: 'string' },
+    strat: { type: 'string' },
+    name: { type: 'string' },
+    desc: { type: 'string' },
+    save: { type: 'boolean' },
+    load: { type: 'boolean' }
+  },
+  strict: true,
+  allowPositionals: true
+});
+
+async function main() {
+  let inputs = dryRunInputs;
+  
+  if (values.load) {
+    if (existsSync(DEFAULT_INPUTS_FILE)) {
+      try {
+        inputs = JSON.parse(readFileSync(DEFAULT_INPUTS_FILE, 'utf8'));
+        console.log(`[ECV] Loaded inputs from ${DEFAULT_INPUTS_FILE}`);
+      } catch (err: any) {
+        console.error(`[ECV] Error loading inputs file: ${err.message}`);
+      }
+    } else {
+      console.warn(`[ECV] No inputs file found at ${DEFAULT_INPUTS_FILE}, using defaults.`);
+    }
+  }
+  
+  // Override with CLI arguments if provided
+  if (values.tech) inputs.tech = parseInt(values.tech, 10);
+  if (values.cap) inputs.cap = parseInt(values.cap, 10);
+  if (values.market) inputs.market = parseInt(values.market, 10);
+  if (values.trust) inputs.trust = parseInt(values.trust, 10);
+  if (values.strat) inputs.strat = parseInt(values.strat, 10);
+  
+  if (values.name) {
+    if (!inputs.metadata) inputs.metadata = {};
+    inputs.metadata.name = values.name;
+  }
+  
+  if (values.desc) {
+    if (!inputs.metadata) inputs.metadata = {};
+    inputs.metadata.description = values.desc;
+  }
+  
+  // Validate ranges
+  const validate = (val: number, name: string) => {
+    if (isNaN(val) || val < 0 || val > 1000) {
+      console.error(`[ERROR] Score for ${name} must be between 0 and 1000 (received: ${val})`);
+      process.exit(1);
+    }
+  };
+  validate(inputs.tech, 'tech');
+  validate(inputs.cap, 'cap');
+  validate(inputs.market, 'market');
+  validate(inputs.trust, 'trust');
+  validate(inputs.strat, 'strat');
+  
+  const results = calculateECV(inputs);
+  printReport(inputs, results);
+  
+  if (values.save) {
+    try {
+      writeFileSync(DEFAULT_INPUTS_FILE, JSON.stringify(inputs, null, 2) + '\n', 'utf8');
+      console.log(`[ECV] Saved inputs to ${DEFAULT_INPUTS_FILE}`);
+    } catch (err: any) {
+      console.error(`[ECV] Failed to save inputs: ${err.message}`);
+    }
+  }
+}
+
+main();
diff --git a/scripts/hitl-request.ts b/scripts/hitl-request.ts
index 41d9389e..095d70b8 100755
--- a/scripts/hitl-request.ts
+++ b/scripts/hitl-request.ts
@@ -2,7 +2,7 @@ import { writeFileSync, existsSync, readFileSync, unlinkSync } from "node:fs";
 import { resolve } from "node:path";
 import { config } from "dotenv";
 
-const dotenvResult = config();
+const dotenvResult = config({ override: true });
 const parsedEnv = dotenvResult.parsed || {};
 
 const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || parsedEnv.TELEGRAM_BOT_TOKEN || process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS || parsedEnv.TELEGRAM_BOT_TOKEN_AI_AGENTS || "";
diff --git a/scripts/ui-sync-check.ts b/scripts/ui-sync-check.ts
new file mode 100644
index 00000000..0d505012
--- /dev/null
+++ b/scripts/ui-sync-check.ts
@@ -0,0 +1,299 @@
+/**
+ * UI/UX Sync & Database Integrity Pre-commit Check
+ * 
+ * SSOT: Ensure storefront configurations, tenant registries, and database schemas
+ * are fully synchronized between backend models and frontend layers.
+ * 
+ * Checks:
+ * 1. Tenant configuration parity (between template's tenant.ts and gateway/whatsapp.ts / tenants/index.ts)
+ * 2. Database schema changes (migrations) vs model types and RLS policies
+ * 3. Storefront catalog vs frontend modules sync
+ * 4. Sensitive data detection (secrets, PII, unmasked CPFs)
+ */
+
+import { readFile, readdir } from "fs/promises";
+import { execSync } from "child_process";
+import { existsSync } from "fs";
+import { join } from "path";
+
+const YELLOW = "\x1b[33m";
+const GREEN = "\x1b[32m";
+const CYAN = "\x1b[36m";
+const RED = "\x1b[31m";
+const RESET = "\x1b[0m";
+
+interface SyncFinding {
+  level: "error" | "warning" | "info";
+  check: string;
+  message: string;
+}
+
+function getStagedFiles(): string[] {
+  try {
+    const output = execSync("git diff --cached --name-only --diff-filter=ACM", { encoding: "utf-8" });
+    return output.trim().split("\n").filter(Boolean);
+  } catch {
+    return [];
+  }
+}
+
+// Extract tenant slugs and their domains from central-egos/template/src/lib/tenant.ts
+async function parseTenantProfiles(): Promise<Array<{ slug: string; domains: string[] }>> {
+  const tenantPath = "central-egos/template/src/lib/tenant.ts";
+  if (!existsSync(tenantPath)) return [];
+  
+  try {
+    const content = await readFile(tenantPath, "utf-8");
+    const profiles: Array<{ slug: string; domains: string[] }> = [];
+    
+    // Simple regex parsing for profiles
+    // Look for objects containing slug and domains
+    const profileBlocks = content.split(/const\s+\w+_PROFILE\s*:\s*\w+\s*=\s*\{/g).slice(1);
+    
+    for (const block of profileBlocks) {
+      const slugMatch = block.match(/slug:\s*["']([^"']+)["']/);
+      if (!slugMatch) continue;
+      const slug = slugMatch[1];
+      
+      const domainsMatch = block.match(/domains:\s*\[([\s\S]*?)\]/);
+      const domains: string[] = [];
+      if (domainsMatch) {
+        const domainList = domainsMatch[1].split(",");
+        for (const d of domainList) {
+          const cleanD = d.replace(/["'\s]/g, "");
+          if (cleanD) domains.push(cleanD);
+        }
+      }
+      
+      profiles.push({ slug, domains });
+    }
+    
+    return profiles;
+  } catch (err) {
+    console.error("Failed to parse tenant profiles:", err);
+    return [];
+  }
+}
+
+function checkSensitiveContent(content: string, filename: string): string[] {
+  const issues: string[] = [];
+  
+  // Check for potential API keys, excluding config templates/tests
+  if (!filename.includes("test") && !filename.includes("sample") && !filename.includes("example")) {
+    if (/(?:api[_-]?key|secret|token|password)\s*[:=]\s*['"][a-zA-Z0-9_\-+=]{10,}['"]/i.test(content)) {
+      // Allow if it matches dummy/mock values
+      if (!content.includes("dummy") && !content.includes("mock") && !content.includes("fake")) {
+        issues.push("Potential API key or secret detected");
+      }
+    }
+  }
+  
+  // Check for CPF patterns (sensitive PII)
+  if (/\b\d{3}\.\d{3}\.\d{3}-\d{2}\b/.test(content)) {
+    issues.push("CPF pattern detected — mask before committing");
+  }
+  
+  // Check for email patterns in idea/doc files (potential PII)
+  if (filename.endsWith(".md") || filename.includes("docs/")) {
+    const emailCount = (content.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g) || []).length;
+    if (emailCount > 3) {
+      issues.push(`${emailCount} email addresses detected — verify they are public/safe to commit`);
+    }
+  }
+  
+  return issues;
+}
+
+async function run() {
+  console.log(`\n${CYAN}🔄 UI/UX & Database Sync Check v1.0${RESET}`);
+  
+  const findings: SyncFinding[] = [];
+  const stagedFiles = getStagedFiles();
+  
+  // 1. Tenant Registry Parity Check
+  const profiles = await parseTenantProfiles();
+  const gatewayWhatsappPath = "apps/egos-gateway/src/channels/whatsapp.ts";
+  const gatewayTenantsPath = "apps/egos-gateway/src/tenants/index.ts";
+  
+  if (profiles.length > 0) {
+    let whatsappContent = "";
+    let tenantsContent = "";
+    
+    try {
+      if (existsSync(gatewayWhatsappPath)) whatsappContent = await readFile(gatewayWhatsappPath, "utf-8");
+      if (existsSync(gatewayTenantsPath)) tenantsContent = await readFile(gatewayTenantsPath, "utf-8");
+    } catch (err) {
+      console.warn("Failed to read gateway files for tenant verification.");
+    }
+    
+    for (const profile of profiles) {
+      const { slug, domains } = profile;
+      
+      // Check 1.1: Whitelist in whatsapp.ts
+      if (whatsappContent) {
+        const whitelistRegex = new RegExp(`TENANT_WHITELIST\\s*=\\s*\\[[^\\]]*"${slug}"`, "i");
+        const whitelistRegex2 = new RegExp(`TENANT_WHITELIST\\s*=\\s*\\[[^\\]]*'${slug}'`, "i");
+        if (!whitelistRegex.test(whatsappContent) && !whitelistRegex2.test(whatsappContent)) {
+          findings.push({
+            level: "warning",
+            check: "tenant-whitelist-sync",
+            message: `Tenant "${slug}" defined in template/tenant.ts but not whitelisted in TENANT_WHITELIST in ${gatewayWhatsappPath}.`,
+          });
+        }
+        
+        // Check 1.2: Allowed origins/domains in CORS
+        for (const domain of domains) {
+          if (domain.includes("localhost") || domain.includes("gpecas.com")) continue; // skip common templates
+          if (!whatsappContent.includes(domain)) {
+            findings.push({
+              level: "warning",
+              check: "tenant-cors-sync",
+              message: `Domain "${domain}" for tenant "${slug}" is not referenced in allowedOrigins or CORS check in ${gatewayWhatsappPath}.`,
+            });
+          }
+        }
+      }
+      
+      // Check 1.3: Registration in tenants/index.ts
+      if (tenantsContent && slug !== "ferro-velho-patense") { // FVP has no hardcoded rules (uses database rules)
+        const rulesRegex = new RegExp(`"${slug}"|'${slug}'`);
+        if (!rulesRegex.test(tenantsContent)) {
+          findings.push({
+            level: "info",
+            check: "tenant-rules-sync",
+            message: `Tenant "${slug}" is not configured in ${gatewayTenantsPath}. Confirm if it requires hardcoded fallback rules.`,
+          });
+        }
+      }
+    }
+  }
+  
+  // 2. Database Migration & RLS Security Check
+  const migrationFiles = stagedFiles.filter(f => f.includes("supabase/migrations/") && f.endsWith(".sql"));
+  if (migrationFiles.length > 0) {
+    findings.push({
+      level: "info",
+      check: "db-migrations-detected",
+      message: `${migrationFiles.length} database migration file(s) staged. Ensure corresponding TypeScript/Zod types are updated.`,
+    });
+    
+    for (const migration of migrationFiles) {
+      try {
+        const content = await readFile(migration, "utf-8");
+        
+        // Check 2.1: RLS Policy verification (INC-006 / R-RLS-001)
+        if (content.includes("CREATE TABLE") && !content.includes("CREATE POLICY")) {
+          // Exempt tables that might not need policies (e.g. schema_migrations, internal)
+          if (!content.includes("schema_migrations") && !migration.includes("internal")) {
+            findings.push({
+              level: "warning",
+              check: "rls-policy-missing",
+              message: `${migration}: Table created but no CREATE POLICY statement found. Every multi-tenant table requires explicit RLS policies (R-RLS-001).`,
+            });
+          }
+        }
+        
+        // Check 2.2: RLS role explicit TO clause
+        if (content.includes("CREATE POLICY")) {
+          const policyLines = content.split("\n");
+          for (let i = 0; i < policyLines.length; i++) {
+            const line = policyLines[i];
+            if (line.includes("CREATE POLICY") && !line.includes(" TO ")) {
+              findings.push({
+                level: "warning",
+                check: "rls-policy-role-missing",
+                message: `${migration}:${i + 1} - RLS policy lacks explicit 'TO <role>' clause. Prefer 'TO authenticated' or 'TO anon'.`,
+              });
+            }
+          }
+        }
+        
+      } catch (err) {
+        // skip unreadable files
+      }
+    }
+  }
+  
+  // 3. Storefront UI & Catalog Sync
+  const storefrontTouched = stagedFiles.some(f => f.startsWith("central-egos/template/src/"));
+  const catalogTouched = stagedFiles.some(f => f.includes("catalog") || f.includes("offering"));
+  
+  if (catalogTouched && !storefrontTouched) {
+    findings.push({
+      level: "info",
+      check: "catalog-modified-no-ui",
+      message: `Storefront catalog or product tools modified but no frontend UI changes detected under central-egos/template. Ensure the catalog update is visible in UI.`,
+    });
+  }
+  
+  if (storefrontTouched) {
+    // Check 3.1: Visual proof gate hint
+    const commitMsgPath = join(".git", "COMMIT_EDITMSG");
+    let visualProofAdded = false;
+    
+    if (existsSync(commitMsgPath)) {
+      try {
+        const msg = await readFile(commitMsgPath, "utf-8");
+        visualProofAdded = msg.includes("[VISUAL-PROOF:");
+      } catch {
+        // ignore
+      }
+    }
+    
+    if (!visualProofAdded && !process.env.EGOS_VISUAL_PROOF_SKIP) {
+      findings.push({
+        level: "info",
+        check: "visual-proof-suggestion",
+        message: `Storefront UI touched. Remember to capture a screenshot and link it via [VISUAL-PROOF: path] in the commit message.`,
+      });
+    }
+  }
+  
+  // 4. Sensitive Content & PII Checks
+  for (const file of stagedFiles) {
+    try {
+      const content = await readFile(file, "utf-8");
+      const sensitiveIssues = checkSensitiveContent(content, file);
+      for (const issue of sensitiveIssues) {
+        findings.push({
+          level: "error",
+          check: "sensitive-content",
+          message: `${file}: ${issue}`,
+        });
+      }
+    } catch {
+      // skip unreadable/binary files
+    }
+  }
+  
+  // Output Findings
+  const errors = findings.filter(f => f.level === "error");
+  const warnings = findings.filter(f => f.level === "warning");
+  const infos = findings.filter(f => f.level === "info");
+  
+  for (const f of errors) {
+    console.log(`  ${RED}[${f.check}]${RESET} ${f.message}`);
+  }
+  for (const f of warnings) {
+    console.log(`  ${YELLOW}[${f.check}]${RESET} ${f.message}`);
+  }
+  for (const f of infos) {
+    console.log(`  ${CYAN}[${f.check}]${RESET} ${f.message}`);
+  }
+  
+  if (findings.length === 0) {
+    console.log(`${GREEN}✅ UI/UX & DB Sync: All checks passed.${RESET}`);
+  } else {
+    console.log(`\n  ${findings.length} finding(s): ${errors.length} errors, ${warnings.length} warnings, ${infos.length} info`);
+  }
+  
+  // Block commit on errors (sensitive data)
+  if (errors.length > 0) {
+    console.log(`\n${RED}❌ BLOCKED: Fix sensitive content or PII issues before committing.${RESET}`);
+    process.exit(1);
+  }
+}
+
+run().catch((err) => {
+  console.error("UI/UX Sync Check error:", err);
+});
diff --git a/scripts/x-approval-bot.ts b/scripts/x-approval-bot.ts
index e1cde3f7..0177e6df 100755
--- a/scripts/x-approval-bot.ts
+++ b/scripts/x-approval-bot.ts
@@ -2,7 +2,7 @@ import { existsSync, readFileSync, writeFileSync } from "node:fs";
 import { resolve } from "node:path";
 import { config } from "dotenv";
 
-const dotenvResult = config();
+const dotenvResult = config({ override: true });
 const parsedEnv = dotenvResult.parsed || {};
 
 const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || parsedEnv.TELEGRAM_BOT_TOKEN || process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS || parsedEnv.TELEGRAM_BOT_TOKEN_AI_AGENTS || "";

exec
/bin/bash -lc 'git diff --name-only e89845f0cbd318a62e7fde261ff19d478d881224' in /home/enio/egos
 succeeded in 0ms:
.agents/workflows/start.md
.github/workflows/capability-eval.yml
.guarani/SEPARATION_POLICY.md
.husky/pre-commit
TASKS.md
TASKS_ARCHIVE.md
apps/egos-landing/src/homepage.jsx
docs/_current_handoffs/handoff_2026-06-01.md
docs/governance/COORDINATION_AGENTS_COST.md
docs/governance/COORDINATION_MONITOR_SPEC.md
docs/governance/HITL_CATALOG.md
docs/governance/PROCESS_CONTRACTS.md
docs/jobs/2026-05-31-doc-drift-verifier.json
docs/jobs/2026-05-31-pre-commit-pipeline.json
docs/jobs/2026-06-01-doc-drift-verifier.json
docs/jobs/2026-06-01-handoff-fidelity.json
docs/jobs/2026-06-01-pre-commit-pipeline.json
package.json
scripts/check-visual-proof.sh
scripts/coordination-watcher.ts
scripts/deploy-rls-auditor.sh
scripts/doctor.ts
scripts/ecv-score.ts
scripts/hitl-request.ts
scripts/ui-sync-check.ts
scripts/x-approval-bot.ts

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- package.json' in /home/enio/egos
 succeeded in 0ms:
diff --git a/package.json b/package.json
index c6ca4317..e4624f4e 100644
--- a/package.json
+++ b/package.json
@@ -24,6 +24,7 @@
     "agent:list": "bun agents/cli.ts list",
     "agent:run": "bun agents/cli.ts run",
     "agent:lint": "bun agents/cli.ts lint-registry",
+    "coordination:watch": "bun run scripts/coordination-watcher.ts",
     "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
     "lint": "eslint .",
     "prepare": "husky",

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- scripts/coordination-watcher.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/scripts/coordination-watcher.ts b/scripts/coordination-watcher.ts
new file mode 100755
index 00000000..a73ab3be
--- /dev/null
+++ b/scripts/coordination-watcher.ts
@@ -0,0 +1,248 @@
+#!/usr/bin/env bun
+/**
+ * EGOS Coherence & Coordination Blackboard Watcher [GUARANI-006]
+ * 
+ * Runs as a background daemon to monitor local git status and diffs.
+ * Leverages free-tier LLM models to organize changes and post them
+ * to a shared blackboard in /tmp, preventing conflicts between parallel agents.
+ */
+
+import { writeFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
+import { execSync } from 'node:child_process';
+import { resolve } from 'node:path';
+import { homedir } from 'node:os';
+import { config } from 'dotenv';
+import { chatWithLLM } from '../packages/shared/src/llm-provider';
+
+config({ override: true });
+
+const REPO_ROOT = resolve(import.meta.dir, '..');
+const VOLATILE_BLACKBOARD_JSON = '/tmp/egos-live-blackboard.json';
+const VOLATILE_BLACKBOARD_MD = '/tmp/egos-live-blackboard.md';
+
+const EGOS_DIR = resolve(homedir(), '.egos');
+if (!existsSync(EGOS_DIR)) {
+  mkdirSync(EGOS_DIR, { recursive: true });
+}
+
+const PERSISTENT_BLACKBOARD_JSON = resolve(EGOS_DIR, 'coordination-blackboard.json');
+const PERSISTENT_BLACKBOARD_MD = resolve(EGOS_DIR, 'coordination-blackboard.md');
+const TELEMETRY_HISTORY_JSONL = resolve(EGOS_DIR, 'coordination-history.jsonl');
+
+let lastStatusString = '';
+
+function sh(cmd: string, cwd: string): string {
+  try {
+    return execSync(cmd, { cwd, encoding: 'utf8', timeout: 10000 }).trim();
+  } catch (e) {
+    return '';
+  }
+}
+
+function logTelemetry(event: {
+  timestamp: string;
+  status: 'clean' | 'dirty' | 'error';
+  head: string;
+  branch: string;
+  changedFilesCount: number;
+  modelUsed: string | null;
+  tokensUsed: {
+    prompt_tokens: number;
+    completion_tokens: number;
+    total_tokens: number;
+  } | null;
+  costUsd: number | null;
+  latencyMs: number;
+  error?: string;
+}) {
+  try {
+    appendFileSync(TELEMETRY_HISTORY_JSONL, JSON.stringify(event) + '\n', 'utf8');
+  } catch (err: any) {
+    console.error(`[COORDINATION] Failed to write telemetry: ${err.message}`);
+  }
+}
+
+async function runAnalysis(status: string, diff: string, commits: string) {
+  console.log(`[COORDINATION] Changes detected. Invoking AI summary...`);
+  const startTime = Date.now();
+  
+  const systemPrompt = `You are the EGOS Coherence & Coordination Monitor. 
+Analyze the current workspace modifications (git status, recent commits, and file diffs).
+Your goal is to compile a clean, highly technical blackboard summary to coordinate between parallel AI agents.
+Identify:
+1. Files modified/added/deleted.
+2. High-level technical impact of the changes (what was implemented/fixed).
+3. Potential conflicts (e.g. changes in package.json, configuration files, or database schemas).
+4. Recommended validation commands (e.g. tsc, bun test, etc.) or alignment instructions.
+
+Answer in a concise, bulleted markdown format in Portuguese (PT-BR) as this is used by Enio and the agents locally. 
+Be precise and avoid fluff.`;
+
+  const userPrompt = JSON.stringify({
+    timestamp: new Date().toISOString(),
+    gitStatus: status,
+    gitDiff: diff.slice(0, 4000), // Cap at 4k chars to avoid token bloat
+    recentCommits: commits,
+  }, null, 2);
+
+  try {
+    const result = await chatWithLLM({
+      tier: 'fast',
+      temperature: 0.1,
+      maxTokens: 1000,
+      systemPrompt,
+      userPrompt,
+    });
+    const latencyMs = Date.now() - startTime;
+    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+
+    const markdownContent = [
+      `# 📋 EGOS Live Coordination Blackboard`,
+      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+      `*Commit HEAD: ${headSha}*`,
+      `*Ramo (Branch): ${branchName}*`,
+      `\n---`,
+      result.content,
+    ].join('\n');
+
+    const jsonContent = {
+      timestamp: new Date().toISOString(),
+      head: headSha,
+      branch: branchName,
+      status: 'dirty',
+      summary: result.content,
+      rawStatus: status,
+    };
+
+    // Write to volatile
+    writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
+    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+
+    // Write to persistent
+    writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
+    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+    console.log(`[COORDINATION] Blackboard successfully updated (both /tmp and ~/.egos).`);
+
+    const changedFilesCount = status ? status.split('\n').filter(Boolean).length : 0;
+    logTelemetry({
+      timestamp: new Date().toISOString(),
+      status: 'dirty',
+      head: headSha,
+      branch: branchName,
+      changedFilesCount,
+      modelUsed: result.model || 'unknown',
+      tokensUsed: result.usage || null,
+      costUsd: result.cost_usd ?? null,
+      latencyMs,
+    });
+  } catch (err: any) {
+    const latencyMs = Date.now() - startTime;
+    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+    console.error(`[COORDINATION] Failed to analyze changes: ${err.message}`);
+
+    logTelemetry({
+      timestamp: new Date().toISOString(),
+      status: 'error',
+      head: headSha,
+      branch: branchName,
+      changedFilesCount: status ? status.split('\n').filter(Boolean).length : 0,
+      modelUsed: null,
+      tokensUsed: null,
+      costUsd: null,
+      latencyMs,
+      error: err.message,
+    });
+  }
+}
+
+function writeCleanState() {
+  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+  
+  const markdownContent = [
+    `# 📋 EGOS Live Coordination Blackboard`,
+    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+    `*Commit HEAD: ${headSha}*`,
+    `*Ramo (Branch): ${branchName}*`,
+    `\n---`,
+    `🟢 **Ecosystem is CLEAN.** Nenhum arquivo modificado ou não-rastreado detectado localmente.`,
+  ].join('\n');
+
+  const jsonContent = {
+    timestamp: new Date().toISOString(),
+    head: headSha,
+    branch: branchName,
+    status: 'clean',
+    summary: '🟢 Ecosystem is CLEAN. No local changes.',
+    rawStatus: '',
+  };
+
+  // Write to volatile
+  writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
+  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+
+  // Write to persistent
+  writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
+  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
+  console.log(`[COORDINATION] Blackboard marked clean (both /tmp and ~/.egos).`);
+
+  logTelemetry({
+    timestamp: new Date().toISOString(),
+    status: 'clean',
+    head: headSha,
+    branch: branchName,
+    changedFilesCount: 0,
+    modelUsed: null,
+    tokensUsed: null,
+    costUsd: null,
+    latencyMs: 0,
+  });
+}
+
+async function checkWorkspace() {
+  const status = sh('git status --porcelain', REPO_ROOT);
+  
+  if (status === lastStatusString) {
+    return; // No change in file status
+  }
+  
+  lastStatusString = status;
+
+  if (!status) {
+    console.log(`[COORDINATION] Workspace is clean.`);
+    writeCleanState();
+    return;
+  }
+
+  const diff = sh('git diff --no-color', REPO_ROOT);
+  const commits = sh('git log -n 5 --oneline', REPO_ROOT);
+  
+  await runAnalysis(status, diff, commits);
+}
+
+async function main() {
+  console.log(`[COORDINATION] Starting background watcher on ${REPO_ROOT}...`);
+  
+  // Run an immediate check on startup
+  await checkWorkspace();
+  
+  // Listen for SIGINT
+  process.on('SIGINT', () => {
+    console.log(`\n[COORDINATION] Watcher shutting down.`);
+    process.exit(0);
+  });
+
+  // Watch loop every 15 seconds
+  while (true) {
+    try {
+      await checkWorkspace();
+    } catch (e: any) {
+      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
+    }
+    await new Promise((r) => setTimeout(r, 15000));
+  }
+}
+
+main();

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- scripts/check-visual-proof.sh' in /home/enio/egos
 succeeded in 0ms:
diff --git a/scripts/check-visual-proof.sh b/scripts/check-visual-proof.sh
index e2fa7ac9..8ac84e09 100755
--- a/scripts/check-visual-proof.sh
+++ b/scripts/check-visual-proof.sh
@@ -37,6 +37,15 @@ if [ -z "$UI_TOUCHED" ]; then
   exit 0
 fi
 
+# Se tocou storefront crítico, força strict mode para exigir prova visual (Karpathy Doctrine)
+STOREFRONT_TOUCHED=$(echo "$UI_TOUCHED" | grep -E 'central-egos/template/src/app/\(storefront\)/|central-egos/template/src/components/storefront/' || true)
+if [ -n "$STOREFRONT_TOUCHED" ]; then
+  echo "🚨 CRITICAL STOREFRONT PATHS TOUCHED:"
+  echo "$STOREFRONT_TOUCHED" | sed 's/^/    /'
+  echo "🔒 Forcing EGOS_VISUAL_PROOF_STRICT=1 for storefront stability."
+  EGOS_VISUAL_PROOF_STRICT=1
+fi
+
 echo "🚪 VISUAL PROOF GATE — UI surface tocada nesta mudança:"
 echo "$UI_TOUCHED" | sed 's/^/    /'
 echo ""

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- scripts/doctor.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index a963f120..cbc45b74 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -26,6 +26,9 @@
 import { existsSync, readFileSync, writeFileSync, mkdirSync, statSync } from 'node:fs';
 import { execSync } from 'node:child_process';
 import { resolve, join } from 'node:path';
+import { config } from 'dotenv';
+
+config({ override: true });
 
 // ═══════════════════════════════════════════════════════════
 // Configuration & Flags

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- scripts/deploy-rls-auditor.sh' in /home/enio/egos
 succeeded in 0ms:
diff --git a/scripts/deploy-rls-auditor.sh b/scripts/deploy-rls-auditor.sh
index 406abcb4..ef27093c 100644
--- a/scripts/deploy-rls-auditor.sh
+++ b/scripts/deploy-rls-auditor.sh
@@ -15,6 +15,7 @@ SCRIPT_SOURCE="scripts/security/rls-auditor-comprehensive.ts"
 SCRIPT_TARGET="/opt/egos-scripts/rls-auditor.ts"
 LOG_DIR="/var/log/egos"
 LOG_FILE="${LOG_DIR}/rls-audit.log"
+VPS_EGOS_DIR="${VPS_EGOS_DIR:-/home/enio/egos}"
 
 echo "═══════════════════════════════════════════════════════════════"
 echo "  RLS Auditor VPS Deployment"
@@ -31,7 +32,7 @@ echo ""
 # Verify script exists
 if [ ! -f "$SCRIPT_SOURCE" ]; then
   echo "❌ ERROR: Script not found: $SCRIPT_SOURCE"
-  echo "   Run from kernel repo root: /home/enio/egos"
+  echo "   Run from kernel repo root."
   exit 1
 fi
 
@@ -58,7 +59,7 @@ scp "$SCRIPT_SOURCE" "$VPS_USER@$VPS_HOST:$SCRIPT_TARGET"
 ssh "$VPS_USER@$VPS_HOST" "chmod +x $SCRIPT_TARGET"
 
 # Create cron job entry
-CRON_ENTRY="$VPS_CRON_MIN $VPS_CRON_HOUR * * * cd /home/enio/egos && /usr/bin/bun $SCRIPT_TARGET --alert >> $LOG_FILE 2>&1"
+CRON_ENTRY="$VPS_CRON_MIN $VPS_CRON_HOUR * * * cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --alert >> $LOG_FILE 2>&1"
 
 # Install cron job
 echo "⏰ Installing cron job..."
@@ -108,7 +109,7 @@ EOF
 # Test the auditor
 echo ""
 echo "🧪 Running test audit..."
-ssh "$VPS_USER@$VPS_HOST" "cd /home/enio/egos && /usr/bin/bun $SCRIPT_TARGET --check 2>&1 | tail -5"
+ssh "$VPS_USER@$VPS_HOST" "cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --check 2>&1 | tail -5"
 
 # Display summary
 echo ""

exec
/bin/bash -lc 'git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- .github/workflows/capability-eval.yml' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.github/workflows/capability-eval.yml b/.github/workflows/capability-eval.yml
index 0b1e7e95..ae19f105 100644
--- a/.github/workflows/capability-eval.yml
+++ b/.github/workflows/capability-eval.yml
@@ -43,16 +43,11 @@ jobs:
       - name: TypeScript check
         run: bun run typecheck
 
+      - name: Verify CBC proof paths integrity
+        run: bun scripts/check-cbc-proof-paths.ts --ci
+
       - name: Run MCP behavioral evals
-        id: eval
-        run: |
-          set +e
-          bun packages/eval-runner/src/mcp-runner.ts --all --json > /tmp/eval-results.json
-          EXIT_CODE=$?
-          echo "exit_code=$EXIT_CODE" >> $GITHUB_OUTPUT
-          cat /tmp/eval-results.json | head -200
-          exit $EXIT_CODE
-        continue-on-error: true
+        run: bun packages/eval-runner/src/mcp-runner.ts --all --json > /tmp/eval-results.json
 
       - name: Upload eval results
         if: always()
@@ -68,6 +63,10 @@ jobs:
         with:
           script: |
             const fs = require('fs');
+            if (!fs.existsSync('/tmp/eval-results.json')) {
+              console.log('No eval results file found. Skipping PR comment.');
+              return;
+            }
             const results = JSON.parse(fs.readFileSync('/tmp/eval-results.json', 'utf8'));
             let comment = '## ❌ MCP Capability Eval Failed\n\n';
             comment += 'Behavioral eval is mandatory for capabilities at beta+ (MCP-FIX-005).\n\n';
@@ -89,9 +88,3 @@ jobs:
               repo: context.repo.repo,
               body: comment
             });
-
-      - name: Fail if block failures
-        if: steps.eval.outputs.exit_code != '0'
-        run: |
-          echo "::error::Behavioral eval has block failures — merge blocked (MCP-FIX-005)"
-          exit 1

exec
/bin/bash -lc "sed -n '1,180p' .github/workflows/capability-eval.yml" in /home/enio/egos
 succeeded in 0ms:
name: Capability Behavioral Eval

# Origem: MCP-F1-006 + MCP-FIX-005 (Codex GPT-5.5 review 2026-05-13)
# Behavioral eval mandatory em CI para qualquer capability promovida a beta+.
# SSOT: docs/governance/CAPABILITY_PROMOTION_RULES.md

on:
  pull_request:
    paths:
      - 'packages/mcp-*/**'
      - 'packages/knowledge-mcp/**'
      - 'packages/guard-brasil-mcp/**'
      - 'packages/eval-runner/**'
      - 'tests/eval/**'
      - 'docs/capabilities/CBC-*.md'
  push:
    branches: [main]
    paths:
      - 'packages/mcp-*/**'
      - 'tests/eval/**'

jobs:
  capability-eval:
    name: Run MCP behavioral evals
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Bun
        uses: oven-sh/setup-bun@v1
        with:
          bun-version: 1.3.9

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: TypeScript check
        run: bun run typecheck

      - name: Verify CBC proof paths integrity
        run: bun scripts/check-cbc-proof-paths.ts --ci

      - name: Run MCP behavioral evals
        run: bun packages/eval-runner/src/mcp-runner.ts --all --json > /tmp/eval-results.json

      - name: Upload eval results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: mcp-eval-results
          path: /tmp/eval-results.json
          retention-days: 30

      - name: Comment on PR (if failure)
        if: failure() && github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            if (!fs.existsSync('/tmp/eval-results.json')) {
              console.log('No eval results file found. Skipping PR comment.');
              return;
            }
            const results = JSON.parse(fs.readFileSync('/tmp/eval-results.json', 'utf8'));
            let comment = '## ❌ MCP Capability Eval Failed\n\n';
            comment += 'Behavioral eval is mandatory for capabilities at beta+ (MCP-FIX-005).\n\n';
            comment += '### Failed cases:\n';
            for (const suite of results) {
              const failed = suite.results.filter(r => !r.passed && r.severity === 'block');
              if (failed.length === 0) continue;
              comment += `\n**${suite.suite}** — ${failed.length} failures:\n`;
              for (const f of failed.slice(0, 5)) {
                comment += `- \`${f.case_id}\`: ${f.errors[0] ?? 'unknown error'}\n`;
              }
              if (failed.length > 5) comment += `- ... and ${failed.length - 5} more\n`;
            }
            comment += '\n**Action required:** investigate findings + fix server or eval case.\n';
            comment += 'Reference: `docs/governance/CAPABILITY_PROMOTION_RULES.md`';
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            });

exec
/bin/bash -lc "git diff --no-color e89845f0cbd318a62e7fde261ff19d478d881224 -- apps/egos-landing/src/homepage.jsx | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-landing/src/homepage.jsx b/apps/egos-landing/src/homepage.jsx
index 414a9652..f2b41480 100644
--- a/apps/egos-landing/src/homepage.jsx
+++ b/apps/egos-landing/src/homepage.jsx
@@ -26,6 +26,42 @@ function Hero({ heroVariant = 'split' }) {
             }}>Conversar com a IA agora →</button>
             <a className="btn btn-ghost" href="#produtos" onClick={() => window.egosTrack('hero_cta_click', { variant: 'see_products' })}>Ver os 4 produtos ↓</a>
           </div>
+          <div className="hero-terminal" style={{
+            display: 'flex',
+            alignItems: 'center',
+            gap: '12px',
+            background: 'rgba(15, 23, 42, 0.6)',
+            backdropFilter: 'blur(8px)',
+            border: '1px solid rgba(255, 255, 255, 0.08)',
+            padding: '10px 16px',
+            borderRadius: '8px',
+            marginTop: '24px',
+            marginBottom: '20px',
+            fontFamily: 'var(--font-mono), monospace',
+            fontSize: '13px',
+            width: 'fit-content'
+          }}>
+            <span style={{ color: 'var(--accent)', fontWeight: 'bold' }}>$</span>
+            <code style={{ color: '#f8fafc', letterSpacing: '0.05em' }}>bunx egos status</code>
+            <span style={{ color: 'rgba(255, 255, 255, 0.25)', userSelect: 'none' }}>|</span>
+            <a 
+              href="https://github.com/enioxt/egos" 
+              target="_blank" 
+              rel="noopener noreferrer" 
+              style={{ 
+                color: '#94a3b8', 
+                textDecoration: 'none', 
+                display: 'flex', 
+                alignItems: 'center', 
+                gap: '4px',
+                transition: 'color 0.2s' 
+              }}
+              onMouseEnter={(e) => e.target.style.color = 'var(--accent)'}
+              onMouseLeave={(e) => e.target.style.color = '#94a3b8'}
+            >
+              GitHub open-source ↗
+            </a>
+          </div>
           <div className="hero-fine">
             <span>Pagamento apenas após entrega validada</span>
             <span>Sem fidelidade · saída livre</span>
@@ -85,7 +121,7 @@ function SecOferta() {
       h: 'Central EGOS',
       sub: 'Chatbot + base de conhecimento da empresa',
       p: 'Atende leads no WhatsApp ou Web, conduz qualificação em 6 fases, responde sobre seus documentos com fonte clicável. Para advogados, contadores, clínicas, consultores.',
-      tags: ['chatbot', 'KB', 'LGPD', 'a partir de R$1.000 + R$200/mês'],
+      tags: ['chatbot', 'KB', 'LGPD', 'mensalidade sob medida'],
       cta: 'Conversar com a IA',
       action: 'chat',
       featured: true,
@@ -94,7 +130,7 @@ function SecOferta() {
       h: 'Monitor Público',
       sub: 'Alertas regulatórios contínuos',
       p: 'Monitora diários oficiais e PNCP em 79+ territórios, classifica oportunidades por relevância, envia relatório semanal automático. Para empresas que vendem para governo.',
-      tags: ['B2G', 'OSINT', 'a partir de R$1.500/mês'],
+      tags: ['B2G', 'OSINT', 'mensalidade sob medida'],
       cta: 'Detalhes',
       action: 'link',
       href: '/monitor-publico',
@@ -103,7 +139,7 @@ function SecOferta() {
       h: 'Módulo Leitor',
       sub: 'Extração estruturada em lote',
       p: 'Recebe pacote de PDFs/Word, extrai pessoas, CNPJs, datas, valores, cláusulas. Entrega CSV + sumário no mesmo dia. Hash SHA-256 por documento (auditoria).',
-      tags: ['NER', 'lote', 'a partir de R$6.000/lote'],
+      tags: ['NER', 'lote', 'sob consulta por lote'],
       cta: 'Diagnóstico grátis',
       action: 'link',
       href: '/modulo-leitor',
@@ -435,14 +471,14 @@ function SecPricing() {
   return (
     <section className="section section-alt" id="precos">
       <div className="container">
-        <SectionHead eyebrow="Preços" title="Comece pequeno. Pague apenas após entrega." align="center" />
+        <SectionHead eyebrow="Preços" title="Planos sob medida. Pague apenas após entrega." align="center" />
         <div className="card pricing-anchor">
           <div className="pricing-from">
-            <span className="accent">a partir de R$1.000</span> setup<br/>
-            <span style={{fontSize: '0.7em', color: 'var(--text-muted)'}}>+ R$200/mês</span>
+            <span className="accent">Mensalidade sob medida</span><br/>
+            <span style={{fontSize: '0.7em', color: 'var(--text-muted)'}}>Consulte orçamento para seu volume</span>
           </div>
           <p className="muted" style={{maxWidth: 520}}>
-            O valor final depende do volume de documentos, canais e sensibilidade dos dados. Faça uma avaliação de 5 minutos com a IA para descobrir o plano ideal.
+            O valor final do setup e da mensalidade depende do volume de documentos, canais de atendimento e sensibilidade dos dados. Faça uma avaliação rápida de 5 minutos com nossa IA para obter uma proposta personalizada.
           </p>
           <div className="pricing-seals">
             <span className="pricing-seal">Pagamento apenas após entrega</span>
@@ -453,6 +489,31 @@ function SecPricing() {
             document.dispatchEvent(new CustomEvent('open-egos-chat'));
             window.egosTrack('pricing_cta_click');
           }}>Descobrir o plano ideal →</button>
+          
+          <div className="pricing-github" style={{
+            marginTop: '20px',
+            fontSize: '12px',
+            color: 'var(--text-muted)',
+            fontFamily: 'var(--font-mono), monospace',
+            display: 'flex',
+            justifyContent: 'center',
+            alignItems: 'center',
+            gap: '8px',
+            flexWrap: 'wrap'
+          }}>
+            <span>Quer auditar nossa governança em código aberto?</span>
+            <span>Rode <code style={{ color: 'var(--accent)', background: 'rgba(255,255,255,0.04)', padding: '2px 6px', borderRadius: '4px' }}>bunx egos doctor</code> ou acesse nosso</span>
+            <a 
+              href="https://github.com/enioxt/egos" 
+              target="_blank" 
+              rel="noopener noreferrer" 
+              style={{ color: 'var(--accent)', textDecoration: 'underline' }}
+              onMouseEnter={(e) => e.target.style.color = '#fff'}
+              onMouseLeave={(e) => e.target.style.color = 'var(--accent)'}
+            >
+              GitHub ↗
+            </a>
+          </div>
         </div>
       </div>
     </section>

exec
/bin/bash -lc "sed -n '1,220p' scripts/check-visual-proof.sh" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bash
# Visual Proof Gate — Karpathy Doctrine enforcement
# SSOT: docs/personal-os/FOCUS_GATES.md §4
# Origem: INC-2026-05-08 (landing tela preta declarada "✅" via HTTP 200)
#
# Quando dispara: staged diff toca UI surface (frontend renderizável)
# Ação: exige marker [VISUAL-PROOF: <path>] no commit message
#       OU envvar EGOS_VISUAL_PROOF_SKIP=1 (com motivo)
# Modo: warn-only por padrão | EGOS_VISUAL_PROOF_STRICT=1 → bloqueia
#
# Usage:
#   bash scripts/check-visual-proof.sh                 # check staged diff
#   bash scripts/check-visual-proof.sh --check-msg     # check commit msg in $1
#   EGOS_VISUAL_PROOF_STRICT=1 bash scripts/check-visual-proof.sh

set -eu

# UI surface paths — qualquer mudança aqui exige prova visual
UI_PATTERNS='apps/.*-landing/|apps/.*/src/components/|apps/.*/src/pages/|apps/.*/src/app/|apps/.*-hq/|apps/egos-council/|\.html$|\.jsx$|\.tsx$|\.vue$|\.svelte$'

# Coleta arquivos staged (ou todos modificados se --all)
if [ "${1:-}" = "--all" ]; then
  CHANGED=$(git diff --name-only HEAD 2>/dev/null || true)
else
  CHANGED=$(git diff --cached --name-only 2>/dev/null || true)
fi

if [ -z "$CHANGED" ]; then
  exit 0
fi

# Filtra UI surface
UI_TOUCHED=$(echo "$CHANGED" | grep -E "$UI_PATTERNS" || true)

if [ -z "$UI_TOUCHED" ]; then
  # Nada de UI mexido → gate não dispara
  exit 0
fi

# Se tocou storefront crítico, força strict mode para exigir prova visual (Karpathy Doctrine)
STOREFRONT_TOUCHED=$(echo "$UI_TOUCHED" | grep -E 'central-egos/template/src/app/\(storefront\)/|central-egos/template/src/components/storefront/' || true)
if [ -n "$STOREFRONT_TOUCHED" ]; then
  echo "🚨 CRITICAL STOREFRONT PATHS TOUCHED:"
  echo "$STOREFRONT_TOUCHED" | sed 's/^/    /'
  echo "🔒 Forcing EGOS_VISUAL_PROOF_STRICT=1 for storefront stability."
  EGOS_VISUAL_PROOF_STRICT=1
fi

echo "🚪 VISUAL PROOF GATE — UI surface tocada nesta mudança:"
echo "$UI_TOUCHED" | sed 's/^/    /'
echo ""

# Skip explícito? (com motivo obrigatório)
if [ -n "${EGOS_VISUAL_PROOF_SKIP:-}" ]; then
  echo "⚠️  SKIP autorizado: $EGOS_VISUAL_PROOF_SKIP"
  echo "    Audit: gate burlado deliberadamente. Anote em handoff."
  exit 0
fi

# Procura marker no commit message
COMMIT_MSG_FILE="${1:-${GIT_DIR:-.git}/COMMIT_EDITMSG}"
MARKER_FOUND=0
PROOF_PATH=""

if [ -f "$COMMIT_MSG_FILE" ]; then
  PROOF_LINE=$(grep -E "^\[VISUAL-PROOF:.*\]" "$COMMIT_MSG_FILE" 2>/dev/null | head -1 || true)
  if [ -n "$PROOF_LINE" ]; then
    PROOF_PATH=$(echo "$PROOF_LINE" | sed -E 's/^\[VISUAL-PROOF:[[:space:]]*//; s/[[:space:]]*\]$//')
    if [ -f "$PROOF_PATH" ]; then
      MARKER_FOUND=1
      echo "✅ Visual proof anexado: $PROOF_PATH"
    else
      echo "❌ Marker [VISUAL-PROOF: $PROOF_PATH] mas arquivo não existe"
    fi
  fi
fi

if [ "$MARKER_FOUND" = "1" ]; then
  exit 0
fi

# Sem prova
echo ""
echo "❌ FALTA prova visual. Para passar:"
echo ""
echo "   Opção 1 — capturar via Playwright MCP (recomendado):"
echo "     mcp__playwright__browser_navigate(<url>)"
echo "     mcp__playwright__browser_take_screenshot(filename='proof-YYYY-MM-DD-<feat>.png')"
echo "     mcp__playwright__browser_console_messages()  # verificar Errors"
echo "     # então no commit msg adicionar linha:"
echo "     [VISUAL-PROOF: docs/_proofs/proof-YYYY-MM-DD-<feat>.png]"
echo ""
echo "   Opção 2 — skip explícito com motivo (vai pra audit):"
echo "     EGOS_VISUAL_PROOF_SKIP='<motivo>' git commit ..."
echo ""
echo "   Opção 3 — não toca UI? Refatorar staging:"
echo "     git reset HEAD <ui-files>  # tirar UI desse commit"
echo ""
echo "   Regra: HTTP 200 ≠ prova de função. Ver docs/personal-os/FOCUS_GATES.md §4"

# Bloqueia apenas em modo strict
if [ "${EGOS_VISUAL_PROOF_STRICT:-0}" = "1" ]; then
  echo ""
  echo "🔒 STRICT MODE — commit bloqueado."
  exit 1
fi

echo ""
echo "⚠️  WARN-ONLY MODE — commit prossegue. Set EGOS_VISUAL_PROOF_STRICT=1 para bloquear."
exit 0

exec
/bin/bash -lc "nl -ba scripts/hitl-request.ts | sed -n '1,40p' && nl -ba scripts/x-approval-bot.ts | sed -n '1,40p'" in /home/enio/egos
 succeeded in 0ms:
     1	import { writeFileSync, existsSync, readFileSync, unlinkSync } from "node:fs";
     2	import { resolve } from "node:path";
     3	import { config } from "dotenv";
     4	
     5	const dotenvResult = config({ override: true });
     6	const parsedEnv = dotenvResult.parsed || {};
     7	
     8	const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || parsedEnv.TELEGRAM_BOT_TOKEN || process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS || parsedEnv.TELEGRAM_BOT_TOKEN_AI_AGENTS || "";
     9	const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID || parsedEnv.TELEGRAM_ADMIN_CHAT_ID || "171767219";
    10	
    11	const LOCK_FILE = resolve(process.cwd(), ".egos-lock");
    12	
    13	interface LockData {
    14	  id: string;
    15	  action: string;
    16	  reason: string;
    17	  status: "pending" | "approved" | "rejected";
    18	  created_at: string;
    19	  pid: number;
    20	}
    21	
    22	async function sendTelegramMessage(text: string, inlineKeyboard: any) {
    23	  if (!TELEGRAM_BOT_TOKEN) {
    24	    throw new Error("TELEGRAM_BOT_TOKEN is empty/missing.");
    25	  }
    26	  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    27	  const response = await fetch(url, {
    28	    method: "POST",
    29	    headers: { "Content-Type": "application/json" },
    30	    body: JSON.stringify({
    31	      chat_id: TELEGRAM_CHAT_ID,
    32	      text,
    33	      parse_mode: "Markdown",
    34	      reply_markup: inlineKeyboard,
    35	    }),
    36	  });
    37	
    38	  if (!response.ok) {
    39	    const errText = await response.text();
    40	    throw new Error(`Telegram error: ${response.status} ${errText}`);
     1	import { existsSync, readFileSync, writeFileSync } from "node:fs";
     2	import { resolve } from "node:path";
     3	import { config } from "dotenv";
     4	
     5	const dotenvResult = config({ override: true });
     6	const parsedEnv = dotenvResult.parsed || {};
     7	
     8	const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || parsedEnv.TELEGRAM_BOT_TOKEN || process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS || parsedEnv.TELEGRAM_BOT_TOKEN_AI_AGENTS || "";
     9	const LOCK_FILE = resolve(process.cwd(), ".egos-lock");
    10	
    11	if (!TELEGRAM_BOT_TOKEN) {
    12	  console.error("[BOT] ERROR: TELEGRAM_BOT_TOKEN not found in env or .env file!");
    13	  process.exit(1);
    14	}
    15	
    16	interface LockData {
    17	  id: string;
    18	  action: string;
    19	  reason: string;
    20	  status: "pending" | "approved" | "rejected";
    21	  created_at: string;
    22	  pid: number;
    23	}
    24	
    25	// Global offset tracker for polling
    26	let offset = 0;
    27	
    28	async function apiCall(method: string, body: any = {}) {
    29	  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/${method}`;
    30	  const response = await fetch(url, {
    31	    method: "POST",
    32	    headers: { "Content-Type": "application/json" },
    33	    body: JSON.stringify(body),
    34	  });
    35	  if (!response.ok) {
    36	    const txt = await response.text();
    37	    console.error(`[BOT] Telegram API Error on ${method}: ${response.status} ${txt}`);
    38	    return null;
    39	  }
    40	  return response.json();

exec
/bin/bash -lc "nl -ba scripts/ui-sync-check.ts | sed -n '70,130p' && nl -ba scripts/ui-sync-check.ts | sed -n '245,285p'" in /home/enio/egos
 succeeded in 0ms:
    70	    
    71	    return profiles;
    72	  } catch (err) {
    73	    console.error("Failed to parse tenant profiles:", err);
    74	    return [];
    75	  }
    76	}
    77	
    78	function checkSensitiveContent(content: string, filename: string): string[] {
    79	  const issues: string[] = [];
    80	  
    81	  // Check for potential API keys, excluding config templates/tests
    82	  if (!filename.includes("test") && !filename.includes("sample") && !filename.includes("example")) {
    83	    if (/(?:api[_-]?key|secret|token|password)\s*[:=]\s*['"][a-zA-Z0-9_\-+=]{10,}['"]/i.test(content)) {
    84	      // Allow if it matches dummy/mock values
    85	      if (!content.includes("dummy") && !content.includes("mock") && !content.includes("fake")) {
    86	        issues.push("Potential API key or secret detected");
    87	      }
    88	    }
    89	  }
    90	  
    91	  // Check for CPF patterns (sensitive PII)
    92	  if (/\b\d{3}\.\d{3}\.\d{3}-\d{2}\b/.test(content)) {
    93	    issues.push("CPF pattern detected — mask before committing");
    94	  }
    95	  
    96	  // Check for email patterns in idea/doc files (potential PII)
    97	  if (filename.endsWith(".md") || filename.includes("docs/")) {
    98	    const emailCount = (content.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g) || []).length;
    99	    if (emailCount > 3) {
   100	      issues.push(`${emailCount} email addresses detected — verify they are public/safe to commit`);
   101	    }
   102	  }
   103	  
   104	  return issues;
   105	}
   106	
   107	async function run() {
   108	  console.log(`\n${CYAN}🔄 UI/UX & Database Sync Check v1.0${RESET}`);
   109	  
   110	  const findings: SyncFinding[] = [];
   111	  const stagedFiles = getStagedFiles();
   112	  
   113	  // 1. Tenant Registry Parity Check
   114	  const profiles = await parseTenantProfiles();
   115	  const gatewayWhatsappPath = "apps/egos-gateway/src/channels/whatsapp.ts";
   116	  const gatewayTenantsPath = "apps/egos-gateway/src/tenants/index.ts";
   117	  
   118	  if (profiles.length > 0) {
   119	    let whatsappContent = "";
   120	    let tenantsContent = "";
   121	    
   122	    try {
   123	      if (existsSync(gatewayWhatsappPath)) whatsappContent = await readFile(gatewayWhatsappPath, "utf-8");
   124	      if (existsSync(gatewayTenantsPath)) tenantsContent = await readFile(gatewayTenantsPath, "utf-8");
   125	    } catch (err) {
   126	      console.warn("Failed to read gateway files for tenant verification.");
   127	    }
   128	    
   129	    for (const profile of profiles) {
   130	      const { slug, domains } = profile;
   245	        level: "info",
   246	        check: "visual-proof-suggestion",
   247	        message: `Storefront UI touched. Remember to capture a screenshot and link it via [VISUAL-PROOF: path] in the commit message.`,
   248	      });
   249	    }
   250	  }
   251	  
   252	  // 4. Sensitive Content & PII Checks
   253	  for (const file of stagedFiles) {
   254	    try {
   255	      const content = await readFile(file, "utf-8");
   256	      const sensitiveIssues = checkSensitiveContent(content, file);
   257	      for (const issue of sensitiveIssues) {
   258	        findings.push({
   259	          level: "error",
   260	          check: "sensitive-content",
   261	          message: `${file}: ${issue}`,
   262	        });
   263	      }
   264	    } catch {
   265	      // skip unreadable/binary files
   266	    }
   267	  }
   268	  
   269	  // Output Findings
   270	  const errors = findings.filter(f => f.level === "error");
   271	  const warnings = findings.filter(f => f.level === "warning");
   272	  const infos = findings.filter(f => f.level === "info");
   273	  
   274	  for (const f of errors) {
   275	    console.log(`  ${RED}[${f.check}]${RESET} ${f.message}`);
   276	  }
   277	  for (const f of warnings) {
   278	    console.log(`  ${YELLOW}[${f.check}]${RESET} ${f.message}`);
   279	  }
   280	  for (const f of infos) {
   281	    console.log(`  ${CYAN}[${f.check}]${RESET} ${f.message}`);
   282	  }
   283	  
   284	  if (findings.length === 0) {
   285	    console.log(`${GREEN}✅ UI/UX & DB Sync: All checks passed.${RESET}`);

exec
/bin/bash -lc "nl -ba scripts/coordination-watcher.ts | sed -n '196,226p'" in /home/enio/egos
 succeeded in 0ms:
   196	    changedFilesCount: 0,
   197	    modelUsed: null,
   198	    tokensUsed: null,
   199	    costUsd: null,
   200	    latencyMs: 0,
   201	  });
   202	}
   203	
   204	async function checkWorkspace() {
   205	  const status = sh('git status --porcelain', REPO_ROOT);
   206	  
   207	  if (status === lastStatusString) {
   208	    return; // No change in file status
   209	  }
   210	  
   211	  lastStatusString = status;
   212	
   213	  if (!status) {
   214	    console.log(`[COORDINATION] Workspace is clean.`);
   215	    writeCleanState();
   216	    return;
   217	  }
   218	
   219	  const diff = sh('git diff --no-color', REPO_ROOT);
   220	  const commits = sh('git log -n 5 --oneline', REPO_ROOT);
   221	  
   222	  await runAnalysis(status, diff, commits);
   223	}
   224	
   225	async function main() {
   226	  console.log(`[COORDINATION] Starting background watcher on ${REPO_ROOT}...`);

codex
The patch introduces operational regressions in environment handling and coordination freshness, and adds an over-strict pre-commit failure path that can block valid commits. These are actionable bugs that should be fixed before considering the change correct.

Full review comments:

- [P1] Preserve runtime env precedence in Telegram bot scripts — /home/enio/egos/scripts/hitl-request.ts:5-5
  Loading dotenv with `override: true` makes `.env` values overwrite already-injected environment variables, so deployments that set `TELEGRAM_BOT_TOKEN`/`TELEGRAM_ADMIN_CHAT_ID` via process env can silently start using stale local values (or empty ones) from `.env`. This can break HITL approval flows in production-like runs where env injection is intended to be authoritative.

- [P2] Recompute blackboard when tracked files keep changing — /home/enio/egos/scripts/coordination-watcher.ts:207-209
  The watcher exits early when `git status --porcelain` is unchanged, but that string only reflects file-state flags, not content revisions within already-modified files. If an agent keeps editing the same file set, summaries stop updating and the blackboard becomes stale even though the diff is changing, defeating the coordination purpose.

- [P2] Avoid hard-blocking docs with multiple public emails — /home/enio/egos/scripts/ui-sync-check.ts:257-260
  All sensitive-content heuristics are currently emitted as `error`, including the `>3 email addresses` check meant to be a manual verification hint. This causes pre-commit to fail for legitimate documentation updates (e.g., contributor/contact lists) even when no secret/PII leak exists, creating false-positive commit blocking.
The patch introduces operational regressions in environment handling and coordination freshness, and adds an over-strict pre-commit failure path that can block valid commits. These are actionable bugs that should be fixed before considering the change correct.

Full review comments:

- [P1] Preserve runtime env precedence in Telegram bot scripts — /home/enio/egos/scripts/hitl-request.ts:5-5
  Loading dotenv with `override: true` makes `.env` values overwrite already-injected environment variables, so deployments that set `TELEGRAM_BOT_TOKEN`/`TELEGRAM_ADMIN_CHAT_ID` via process env can silently start using stale local values (or empty ones) from `.env`. This can break HITL approval flows in production-like runs where env injection is intended to be authoritative.

- [P2] Recompute blackboard when tracked files keep changing — /home/enio/egos/scripts/coordination-watcher.ts:207-209
  The watcher exits early when `git status --porcelain` is unchanged, but that string only reflects file-state flags, not content revisions within already-modified files. If an agent keeps editing the same file set, summaries stop updating and the blackboard becomes stale even though the diff is changing, defeating the coordination purpose.

- [P2] Avoid hard-blocking docs with multiple public emails — /home/enio/egos/scripts/ui-sync-check.ts:257-260
  All sensitive-content heuristics are currently emitted as `error`, including the `>3 email addresses` check meant to be a manual verification hint. This causes pre-commit to fail for legitimate documentation updates (e.g., contributor/contact lists) even when no secret/PII leak exists, creating false-positive commit blocking.
```
