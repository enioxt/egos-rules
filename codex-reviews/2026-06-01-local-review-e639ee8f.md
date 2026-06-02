# Codex Local Review — 2026-06-01T10:50:42Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

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
session id: 019e82ce-b4d6-7031-a2f4-12fead0bd316
--------
user
changes against 'HEAD~3'
exec
/bin/bash -lc 'git diff 3de78826baad6d5745c12b0613ac34f4454410c8' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.github/workflows/governance-drift.yml b/.github/workflows/governance-drift.yml
index 816345aa..ee0a2adf 100644
--- a/.github/workflows/governance-drift.yml
+++ b/.github/workflows/governance-drift.yml
@@ -45,8 +45,9 @@ jobs:
       - name: Task Reconciliation Summary (report-only)
         run: bun scripts/task-reconciliation.ts --summary
 
-      - name: Backlog Status & Staleness Check (report-only)
-        run: bun scripts/check-backlog-status.ts
+      - name: Backlog Status & Staleness Check
+        run: |
+          bun scripts/check-backlog-status.ts --fail-on-drift >> /tmp/drift-verify.md 2>&1 || echo "DRIFT_DETECTED=true" >> $GITHUB_ENV
 
       - name: Doc-Drift Pattern Analysis
         if: ${{ github.event.inputs.mode != 'verify-only' }}
diff --git a/TASKS.md b/TASKS.md
index 4b4934c6..7eeb466e 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -151,7 +151,24 @@
 - [ ] **SITE-I18N-001** [P1] `prime` — Implementar i18n PT(default)/EN/ZH-Simplified. **Recomendação (Sonnet research):** Paraglide JS (inlang) + MT via próprio `packages/shared/llm-router` (Gemini 2.5 Flash — 2.0 desliga 2026-06-01). Soberania total (traduções in-repo, chaves próprias), ~$0, bundle mínimo. Fallback: Tolgee self-hosted se precisar UI p/ revisor humano.
 - [ ] **SITE-I18N-ZH-GATE-001** [P1] `redzone` — Gate de revisão humana p/ Chinês: glossário (EGOS, soberania, vocabulário forense/policial) + nunca auto-publicar ZH sem revisão (LLM-MT erra terminologia). Honra Red Zone.
 - [ ] **SITE-OBJECTIONS-001** [P2] — Resolver as 10 objeções de `LANDING_OBJECTIONS.md` (P0 interno: demo diferencial vs ChatGPT; DPO nomeado; garantia de export; case com números auditados). Depende de SITE-DECIDE-001.
-- [ ] **SITE-X-POST-001** [P2] `redzone` — Post no X.com divulgando o GitHub. Draft → HITL (NUNCA publicar sem aprovação do Enio — T0). Avaliar se vai junto com landing nova ou antes (GitHub-only).
+- [ ] **SITE-X-POST-001** [P2] `redzone` — Post no X.com divulgando o GitHub. **Decisão Enio: agora, GitHub-only.** URL = `github.com/enioxt/egos-governance` (egos é privado). Draft 2 desta sessão teve tom rejeitado → refazer após SITE-VOICE-001. HITL antes de publicar (T0).
+
+## 🎨 SITE — Essência, voz, 3 opções de design, EGOS interativo (corte Enio 2026-06-01)
+
+> SSOT essência: memory `project_egos_brand_essence_site.md`. EGOS = equilibrar o ego (não vencer), nomear/posicionar. Público = users Claude Code/Windsurf (literatos) + novatos curiosos. Site canônico = `apps/egos-site/src/server.ts` (já tem EN parcial). Tom do 1º draft REJEITADO. Tudo aqui é Red Zone (copy/design pública) → corte do Enio.
+- [ ] **SITE-VOICE-001** [P1] `redzone` `research` — Reler as maiores referências de design/landing/copy do mundo (best + mais inovadoras) e definir a VOZ EGOS: explicativa o suficiente p/ atrair novatos, intrigante+confiável p/ experts. Ancorar na essência ego-balance. Output: guia de voz + 2-3 refs anotadas. Pré-requisito de SITE-COPY-001 e SITE-X-POST-001.
+- [ ] **SITE-DESIGN-3OPT-001** [P1] `redzone` — Produzir 3 opções de homepage: 2 tradicionais (baseadas nas melhores/mais inovadoras/bonitas páginas do mundo, adaptadas à essência EGOS) + 1 novidade (EGOS-interativo-first). Design comigo em código (não Figma). Apresentar p/ corte do Enio.
+- [ ] **SITE-EGOS-WIDGET-001** [P1] — Widget "arquiteto EGOS" interativo: termos marcados no texto → hover abre suavemente caixinha com EGOS respondendo, com conhecimento do framework inteiro + constituição + regras. Embeddable/distribuível em vários lugares. Tela inicial já permite interação rápida. Depende de LLM-BENCH-001.
+- [ ] **SITE-TRUST-MATH-001** [P1] `redzone` — Mecanismo de confiança "provada com matemática": prompts públicos auditáveis + verificação (hash/transparência formal) que mostra que não há nada malicioso. Definir o que "prova matemática" significa aqui e como exibir na UI.
+- [ ] **LLM-BENCH-001** [P1] `research` — Benchmark de qual LLM segue FIELMENTE a constituição/regras EGOS pelo melhor custo: deepseek, kimi, claude, gpt, gemini. Alimenta o widget (SITE-EGOS-WIDGET-001). Output: tabela custo×fidelidade com golden cases (INC-008: ≥3 casos reais).
+- [/] **CURRICULUM-001** [P1] `redzone` — Currículo/posicionamento do Enio. **Substância aprovada Enio 2026-06-01**, SSOT persistido `docs/strategy/ENIO_CURRICULUM_POSITIONING.md` (identidade "investigador-arquiteto"; frase "não vendo hora de perito" CORTADA). Pendente: corte final da versão expandida + aterrissagem na seção "Sobre". Respeita estatuto PCMG (IP/magistério/advisory).
+
+## 📝 ARTIGOS / TIMELINE — melhorar módulo + escrever artigo no tom investigador-arquiteto (Enio 2026-06-01)
+
+> Módulo = Timeline AI Publishing System. Rota `egos.ia.br/timeline` (PT+EN). Hoje só 1 artigo. Standard: `docs/social/ARTICLE_VOICE.md` + `ARTICLE_TEMPLATE.md` + `docs/modules/TIMELINE_AI_PUBLISHING_ARCHITECTURE.md`. Tudo Red Zone (público) → corte do Enio antes de publicar.
+- [/] **ARTICLE-RULES-001** [P1] — Melhorar regras de geração de artigo (VOICE+TEMPLATE) p/ público Claude Code/Windsurf + novatos curiosos; tom explicativo+confiável; confiança via matemática/auditabilidade. (Sonnet propondo edições; Opus revisa.)
+- [/] **ARTICLE-002** [P1] `redzone` — Escrever artigo #2 no tom investigador-arquiteto: explicar+mostrar+validar EGOS. Evidence-first (citar só o que existe no repo). HITL antes de publicar. (Sonnet redigindo draft; Opus revisa Red Zone.)
+- [ ] **ARTICLE-MULTIMEDIA-001** [P1] — Multimídia do artigo via NotebookLM MCP (integração já existe): slides (assinatura visual obrigatória — VISUAL_IDENTITY.md), vídeo, áudio, imagens. HITL para deleção/publicação (NotebookLM §4). Pensar imagens junto do texto.
 
 ---
 
@@ -221,9 +238,9 @@
 
 ### Codex adversarial review 2026-05-28 — registry parity + codex-doctor (post Fase 1-2)
 
-- [ ] **REG-PARITY-SCAFFOLD-Q1a-001** [P2] `2h` — packages/`<x>`/ scaffold sem package.json bypassa gate. Design: detectar nova dir `packages/<x>/` mesmo sem pkg.json (precisa decisão: trigger imediato vs lazy até primeiro commit com pkg.json?).
-- [ ] **REG-PARITY-REGEX-Q1c-001** [P2] `1h` — `is_in_registry()` regex loose causa false-negatives em slugs curtos (`api`, `core` matcheiam em prose qualquer). Fix: ancorar match a contextos `## §N — <slug>` ou `Path: packages/<slug>/`.
-- [ ] **CODEX-DOCTOR-STRUCT-Q5a-001** [P2] `1h` — Doctor não detecta mudanças estruturais no plugin (single quotes, key rename). Fix: validar checksum esperado por versão do plugin antes de patch.
+- [ ] **REG-PARITY-SCAFFOLD-Q1A-001** [P2] `2h` — packages/`<x>`/ scaffold sem package.json bypassa gate. Design: detectar nova dir `packages/<x>/` mesmo sem pkg.json (precisa decisão: trigger imediato vs lazy até primeiro commit com pkg.json?).
+- [ ] **REG-PARITY-REGEX-Q1C-001** [P2] `1h` — `is_in_registry()` regex loose causa false-negatives em slugs curtos (`api`, `core` matcheiam em prose qualquer). Fix: ancorar match a contextos `## §N — <slug>` ou `Path: packages/<slug>/`.
+- [ ] **CODEX-DOCTOR-STRUCT-Q5A-001** [P2] `1h` — Doctor não detecta mudanças estruturais no plugin (single quotes, key rename). Fix: validar checksum esperado por versão do plugin antes de patch.
 - [ ] **GOLDEN-CASES-FILL-001** `[DEFER-GATE-C]` [P1] `1d Sonnet` — Após DESIGN-001: escrever 27 golden cases (3×9 MCPs) usando templates. Bloqueado por DESIGN-001.
 
 > **Revisão escopo:** `REG-VERIFIED-AT-BACKFILL-001` movido de [P0 6h] → [P0 2-3 dias] (Codex Q8: muitas entries referenciam paths que não existem, requer discovery real, não só preenchimento mecânico).
@@ -402,7 +419,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - Lista repos via `gh repo list enioxt --limit 100`
   - Para cada TIER 1: `git -C $dir fetch origin` + check drift
   - Output: "N repos drifted · K repos com commits novos · M repos com tasks P0 pendentes"
-  - **Dep:** REPO_INVENTORY define quem é TIER 1
+  - **Dep:** REPO-INVENTORY-001 define quem é TIER 1
 
   - 14 repos TIER 1+2 auditados; audit em `docs/governance/README_AUDIT_2026-05-26.md`
   - 3 drafts P0 criados: `docs/drafts/README-omniview-v2-*.md`, `README-forja-v2-*.md`, `README-marizanotto-videos-v2-*.md`
@@ -421,7 +438,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - Gera `docs/COORDINATION.md` com snapshot semanal
   - HITL: revisão no `/end` domingo
 
-- [ ] **REPO_INVENTORY** [P0] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
+- [ ] **REPO-INVENTORY-001** [P0] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
   - Output: `docs/governance/REPO_INVENTORY_2026-05-26.md`
   - Decisão arquitetural: TIER 1/2/3 para Autoresearch + monitoring
 
diff --git a/docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md b/docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md
index 45c39dbb..ff9ea4b2 100644
--- a/docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md
+++ b/docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md
@@ -29,11 +29,11 @@
 
 ## 🟡 ONDA B — Decidir junto (impacto médio/alto)
 - [x] **ORG-B1** ✅ DONE 2026-05-30 — consolidado em `docs/infra/` (operations/ + ops/ → infra/, 5 arquivos, 0 refs quebradas). NOTA: fragmentação VPS maior (runbooks/kb-vps/monitoring) fica p/ onda futura.
-- [ ] **ORG-B2** WHATSAPP_SSOT duplicado divergente: `docs/guides/` (v2.0) vs `docs/knowledge/` (v1.0) — qual é canônico? merge?
+- [~] **ORG-B2** WHATSAPP_SSOT duplicado divergente: `docs/guides/` (v2.0) vs `docs/knowledge/` (v1.0) — qual é canônico? merge?
 - [~] **ORG-B3** Out-of-scope **Trading** — DECISÃO: holding p/ migrar. ✅ `docs/trading/` (2) → `docs/_out-of-scope/trading/`. ⏳ PENDENTE: 13 CBC-EGOS-TRADING-* em `docs/capabilities/` — NÃO movidos (risco de quebrar parity-check de capabilities; avaliar `check-registry-parity.sh` antes).
 - [~] **ORG-B4** Out-of-scope **Intelink/OSINT** — DECISÃO: holding. ⚠️ BLOQUEADO: NÃO órfão — `docs/strategy/ROADMAP.md` referencia OSINT_BRASIL_TOOLKIT, partner-brief referencia INTELIGENCIA_TOPOLOGY, gem-hunter referencia INTELINK_LLM_PLAN. Mover quebraria links ativos. Precisa: atualizar refs OU manter. Decidir junto. (Sweep agent reportou "no refs" — incorreto.)
 - [~] **ORG-B5** Governance bloat — ✅ `BRACC_OVERVIEW.md` (0 refs, conteúdo br-acc) → `docs/_out-of-scope/`. ⚠️ RESTO ENTRELAÇADO (sweep super-flaggou): `prompt.md` (ref script+SYSTEM_MAP), `WAVE1_INVENTORY` (ref `check-crossrefs.ts` — mover quebra pre-commit), `ENIO_DEVELOPER_TIMELINE` (ref TASKS_ARCHIVE), WAVE1 cluster inter-referenciado. Não mover sem tratar refs/script. Decidir junto.
-- [ ] **ORG-B6** ~49 orphans + ~67 stale do DOCS_FOLDER_SWEEP — triagem em lote (ARCHIVE vs KEEP)
+- [~] **ORG-B6** ~49 orphans + ~67 stale do DOCS_FOLDER_SWEEP — triagem em lote (ARCHIVE vs KEEP)
 
 ## 🔴 ONDA C — Sensível (aprovação explícita Enio)
 - [x] **ORG-C1** ✅ DECISÃO: central-egos/clients/. Movidos: g-pecas-2026-05 (7 docs) → `central-egos/clients/g-pecas/_discovery/`; ferro-velho-patense → `central-egos/clients/ferro-velho-patense/_discovery/`. Ref BOOTSTRAP corrigida. ⚠️ NOTA: dados HIGH-sensitive (CNPJ/pricing/contrato) seguem commitados em git — exposição é questão à parte (ver ORG-C2 / git history scrub).
@@ -43,7 +43,7 @@
 
 ## 📋 ONDA D — População de registros (registry coverage)
 - [x] **ORG-D1** ✅ DONE 2026-05-30 (branch claude/egos-mobile-startup-9Z1Ab) — §101 (13 skill bundles), §102 (4 new commands), §103 (20 agents/skills) appended to CAPABILITY_REGISTRY. 3 new ## §N sections added (83→86). Auto-gen parity update incremental (run `bun scripts/gen-registry-parity-counts.ts --write`).
-- [ ] **ORG-D2** CAPABILITY_REGISTRY: back-link incremental dos 65 CBC-*.md sem âncora §N (noted in §103 as D1-REMAINING; 65 CBC back-links intentionally deferred — incremental work)
+- [~] **ORG-D2** CAPABILITY_REGISTRY: back-link incremental dos 65 CBC-*.md sem âncora §N (noted in §103 as D1-REMAINING; 65 CBC back-links intentionally deferred — incremental work)
 - [x] **ORG-D3** ✅ DONE 2026-05-30 — 4 integrações adicionadas (Gemini, Anthropic, Stripe, Notion) ao INTEGRATION_REGISTRY v1.0.2.
 - [x] **ORG-D4** ✅ DONE 2026-05-30 — SYSTEM_MAP v4.2.0: 13 apps + 33 packages + seção Central EGOS; Guard Brasil status reconciliado (divergente, flag).
 - [x] **ORG-D5** ✅ DONE 2026-05-30 — ROUTER v1.4.0: inventário dos 32 repos. ⚠️ `br-acc` NÃO aparece na busca MCP — confirmar nome/visibilidade com Enio (pode ter sido renomeado).
@@ -59,7 +59,7 @@
 - [x] **ORG-F4 (P4)** ✅ DONE 2026-05-30 — `docs/_inbox/README.md` criado (regras triagem) + `docs/_out-of-scope/` + 2 linhas no SSOT-map CLAUDE.md.
 - [~] **ORG-F5 (P5)** ✅ DECISÃO: MIRROR no repo. ⏳ BLOQUEADO: precisa do conteúdo de `~/.claude/CLAUDE.md` (ausente neste container) — Enio cola no notebook → criar `docs/governance/GLOBAL_RULES_MIRROR.md` + atualizar LAYER_0_SSOT §2 (resolve F2 junto).
 - [x] **ORG-F6** ✅ DONE 2026-05-30 — seção "Quando usar MCP" em MCP_REGISTRY.md (5 regras: local→nativo, externo→MCP, fallback gracioso, escopo GitHub, auditoria) + row no RULES_INDEX.
-- [ ] **ORG-F7** 🔴 DECISÃO ENIO (dado pessoal): `data/personal-os/private/` (EPOS atoms + interview_state — base da Layer 0.5, citado em 5 docs) é **gitignored** → single-point-of-failure no notebook. Repo `egos` é privado, então privacidade não justifica. Opções: (a) commitar no repo privado (backup+versão), (b) manter ignored + backup externo garantido, (c) encriptar+commitar. Mesma classe de risco do ~/.claude/CLAUDE.md (F5).
+- [~] **ORG-F7** 🔴 DECISÃO ENIO (dado pessoal): `data/personal-os/private/` (EPOS atoms + interview_state — base da Layer 0.5, citado em 5 docs) é **gitignored** → single-point-of-failure no notebook. Repo `egos` é privado, então privacidade não justifica. Opções: (a) commitar no repo privado (backup+versão), (b) manter ignored + backup externo garantido, (c) encriptar+commitar. Mesma classe de risco do ~/.claude/CLAUDE.md (F5).
 
 ---
 *Atualizar este arquivo a cada item fechado. Marcar [x] + commit que fechou.*
diff --git a/docs/jobs/2026-06-01-doc-drift-analysis.md b/docs/jobs/2026-06-01-doc-drift-analysis.md
new file mode 100644
index 00000000..9d673bbd
--- /dev/null
+++ b/docs/jobs/2026-06-01-doc-drift-analysis.md
@@ -0,0 +1,21 @@
+# Doc-Drift Pattern Analysis — 2026-06-01
+
+**Period:** 2026-05-01 → 2026-05-26
+**Reports analyzed:** 13
+**Total drift events:** 0
+**Health score:** ✅ 100/100
+**Trend:** ➡️ stable
+
+## Top Drifting Claims
+
+| Claim ID | Drift Count | Repos | Last Drift |
+|----------|-------------|-------|------------|
+| — | 0 | — | — |
+
+## Recommendations
+
+- No drift events found in reports — either all clean or report format not parsed. Verify doc-drift-sentinel output format.
+
+---
+*Generated by doc-drift-analyzer.ts | EGOS Doc-Drift Shield Layer 3.5*
+*Repo: /home/runner/work/egos/egos*
diff --git a/docs/strategy/ENIO_CURRICULUM_POSITIONING.md b/docs/strategy/ENIO_CURRICULUM_POSITIONING.md
new file mode 100644
index 00000000..7f304390
--- /dev/null
+++ b/docs/strategy/ENIO_CURRICULUM_POSITIONING.md
@@ -0,0 +1,46 @@
+# Enio — Currículo & Posicionamento (SSOT público)
+
+> **Status:** substância aprovada pelo Enio 2026-06-01 · pendente corte final da versão expandida · **Red Zone** (identidade pública + estatuto PCMG)
+> **Alimenta:** seção "Sobre" do site, `SITE-VOICE-001`, artigos do timeline, narrativa de parcerias.
+> **Guardrails:** estatuto PCMG ativo — ver `user_enio_active_police` (memory) + `docs/personal-os/CAREER_FIT_STUDY.md` §0.1.
+
+---
+
+## Identidade-núcleo
+
+**Investigador-arquiteto** — 16 anos investigando crime de verdade, agora construindo os sistemas de IA que tornam a investigação **auditável, governada e reproduzível**.
+
+## Narrativa
+
+Passei 16 anos na investigação criminal (PCMG, **em atividade**) aprendendo a transformar caos em clareza e a sustentar cadeia de evidência sob escrutínio. Desde 2017 estou em cripto/Web3 — não como espectador, mas rastreando, entendendo fluxos, lendo o que a blockchain registra.
+
+Nos últimos anos juntei as duas coisas: virei builder de sistemas de IA governados. O intelink (investigação), o gem-hunter, os MCPs, e o EGOS — o kernel que orquestra tudo com LGPD e auditabilidade desde o dia zero. Cada decisão do sistema tem fonte; cada afirmação tem prova; cada prompt é aberto e verificável.
+
+O que me torna raro não é saber investigar **ou** saber construir IA — é fazer os dois ao mesmo tempo, com o rigor de quem já teve que sustentar uma evidência diante de um juiz.
+
+## Currículo estruturado
+
+| Pilar | Evidência real |
+|---|---|
+| Metodologia de investigação / cadeia de evidência | 16 anos PCMG (em atividade) |
+| Cripto/Web3 fundamentos | desde 2017 |
+| Build de sistemas (TS / agents / RAG / MCP) | intelink, gem-hunter, EGOS, MCPs |
+| Governança / ética de IA | Guard Brasil, constituição EGOS |
+| Superpower | caos → clareza |
+
+## Oferta — só pelos vetores seguros (estatuto PCMG ativo)
+
+- ✅ **IP / produto** — possuir o EGOS como obra/software (royalty de autor é o vetor mais defensável)
+- ✅ **Magistério / curso** — esporádico, **sob consulta à Corregedoria** (habitualidade é o gatilho do problema, não o tipo de atividade)
+- ✅ **Governança / advisory** — treinamento, política, auditoria
+- 🚫 **Vedado a servidor ativo:** perito-for-hire, comércio, sócio-gerente/administrador
+
+## Aterrissagem no site
+
+- Seção **"Sobre / Quem constrói"** → a narrativa acima.
+- **F1** (forense cripto: rastreio on-chain + laudo, reusando o intelink) vira **demo de prova** — "veja o sistema funcionando", não "contrate o perito".
+- **Parcerias** enquadrado como construir junto / licenciar IP / formar — nunca serviço pericial avulso.
+
+---
+
+*Origem: CURRICULUM-001 (TASKS.md). Estudo base: `docs/personal-os/CAREER_FIT_STUDY.md` (F1 venceu, 83.4).*
diff --git a/scripts/check-backlog-status.ts b/scripts/check-backlog-status.ts
index 4cccedaa..288829f5 100644
--- a/scripts/check-backlog-status.ts
+++ b/scripts/check-backlog-status.ts
@@ -5,9 +5,13 @@
  * Scans docs/audits/*BACKLOG*.md for:
  * 1. Independent unchecked boxes [ ] without a valid Task ID (prohibited).
  * 2. Status mismatch: tasks marked completed [x] in TASKS.md but still pending [ ] in backlog.
+ * 3. Untracked tasks: tasks pending [ ] in backlog that do not exist in TASKS.md.
+ *
+ * Also scans TASKS.md for:
+ * 4. Task ID format consistency (must be uppercase, dashed, e.g. ABC-123).
  */
 
-import { readFileSync, readdirSync } from "fs";
+import { readFileSync, readdirSync, existsSync } from "fs";
 import { join } from "path";
 import { execSync } from "child_process";
 
@@ -21,11 +25,13 @@ const ROOT = (() => {
 
 const TASKS_PATH = join(ROOT, "TASKS.md");
 const AUDITS_DIR = join(ROOT, "docs", "audits");
+const FAIL_ON_DRIFT = process.argv.includes("--fail-on-drift");
 
 // 1. Parse completed tasks in TASKS.md
 function getCompletedTasks(filePath: string): Set<string> {
   const completed = new Set<string>();
   try {
+    if (!existsSync(filePath)) return completed;
     const content = readFileSync(filePath, "utf8");
     const lines = content.split("\n");
     for (const line of lines) {
@@ -41,18 +47,73 @@ function getCompletedTasks(filePath: string): Set<string> {
   return completed;
 }
 
-// 2. Scan backlog files in docs/audits/
+// 2. Parse pending/in-progress/deferred tasks in TASKS.md
+function getActiveTasks(filePath: string): Set<string> {
+  const active = new Set<string>();
+  try {
+    if (!existsSync(filePath)) return active;
+    const content = readFileSync(filePath, "utf8");
+    const lines = content.split("\n");
+    for (const line of lines) {
+      // Matches [ ] or [/] or [~] tasks
+      const match = line.match(/^\s*-\s+\[([ \/~])\]\s+(?:\*\*|`)?([A-Z][A-Z0-9_]+(?:-[A-Z0-9_]+)+)/);
+      if (match) {
+        active.add(match[2]);
+      }
+    }
+  } catch (err) {
+    console.error(`❌ Failed to read TASKS.md at ${filePath}:`, err);
+  }
+  return active;
+}
+
+// 3. Scan TASKS.md for malformed task IDs
 interface Anomaly {
   file: string;
   line: number;
   content: string;
-  reason: "no_task_id" | "status_mismatch";
+  reason: "no_task_id" | "status_mismatch" | "untracked_task_id" | "invalid_id_format";
   taskId?: string;
 }
 
-function scanBacklogs(dirPath: string, completedTasks: Set<string>): Anomaly[] {
+function checkTaskIdFormats(filePath: string): Anomaly[] {
   const anomalies: Anomaly[] = [];
   try {
+    if (!existsSync(filePath)) return anomalies;
+    const content = readFileSync(filePath, "utf8");
+    const lines = content.split("\n");
+    for (let i = 0; i < lines.length; i++) {
+      const line = lines[i];
+      // Matches any task line in TASKS.md
+      if (/^\s*-\s+\[[ xX~\/]\]/.test(line)) {
+        // Extract first token after the checkbox, stripping markdown bold/code delimiters
+        const tokenMatch = line.match(/^\s*-\s+\[([ xX~\/])\]\s+(?:\*\*|`)?([a-zA-Z0-9_#-]+)/);
+        if (tokenMatch) {
+          const id = tokenMatch[2];
+          const isCanonical = /^[A-Z][A-Z0-9_]+(?:-[A-Z0-9_]+)+$/.test(id);
+          if (!isCanonical) {
+            anomalies.push({
+              file: "TASKS.md",
+              line: i + 1,
+              content: line.trim(),
+              reason: "invalid_id_format",
+              taskId: id
+            });
+          }
+        }
+      }
+    }
+  } catch (err) {
+    console.error(`❌ Failed to read TASKS.md at ${filePath}:`, err);
+  }
+  return anomalies;
+}
+
+// 4. Scan backlog files in docs/audits/
+function scanBacklogs(dirPath: string, completedTasks: Set<string>, activeTasks: Set<string>): Anomaly[] {
+  const anomalies: Anomaly[] = [];
+  try {
+    if (!existsSync(dirPath)) return anomalies;
     const files = readdirSync(dirPath);
     const backlogFiles = files.filter(f => f.toUpperCase().includes("BACKLOG") && f.endsWith(".md"));
 
@@ -66,8 +127,8 @@ function scanBacklogs(dirPath: string, completedTasks: Set<string>): Anomaly[] {
         // Matches any pending task marker "- [ ]"
         const isPending = /^\s*-\s+\[\s*\]/.test(line);
         if (isPending) {
-          // Look for a Task ID like SH-001, ORG-B2, DRIFT-PREVENT-001
-          const idMatch = line.match(/\b([A-Z][A-Z0-9_]+(?:-[A-Z0-9_]+)+)\b/);
+          // Look for a Task ID
+          const idMatch = line.match(/\b([a-zA-Z0-9_#-]+)\b/);
           if (!idMatch) {
             anomalies.push({
               file,
@@ -77,7 +138,17 @@ function scanBacklogs(dirPath: string, completedTasks: Set<string>): Anomaly[] {
             });
           } else {
             const taskId = idMatch[1];
-            if (completedTasks.has(taskId)) {
+            // Validate uppercase, dashed format
+            const isCanonical = /^[A-Z][A-Z0-9_]+(?:-[A-Z0-9_]+)+$/.test(taskId);
+            if (!isCanonical) {
+              anomalies.push({
+                file,
+                line: i + 1,
+                content: line.trim(),
+                reason: "invalid_id_format",
+                taskId
+              });
+            } else if (completedTasks.has(taskId)) {
               anomalies.push({
                 file,
                 line: i + 1,
@@ -85,6 +156,14 @@ function scanBacklogs(dirPath: string, completedTasks: Set<string>): Anomaly[] {
                 reason: "status_mismatch",
                 taskId
               });
+            } else if (!activeTasks.has(taskId)) {
+              anomalies.push({
+                file,
+                line: i + 1,
+                content: line.trim(),
+                reason: "untracked_task_id",
+                taskId
+              });
             }
           }
         }
@@ -98,21 +177,37 @@ function scanBacklogs(dirPath: string, completedTasks: Set<string>): Anomaly[] {
 
 function main() {
   console.log("🔍 Running Status-Drift & Backlog Staleness Check...");
+  
+  // Validate TASKS.md format first
+  const formatAnomalies = checkTaskIdFormats(TASKS_PATH);
+  
   const completedTasks = getCompletedTasks(TASKS_PATH);
-  console.log(`   Found ${completedTasks.size} completed tasks in TASKS.md`);
+  const activeTasks = getActiveTasks(TASKS_PATH);
+  console.log(`   Found ${completedTasks.size} completed tasks and ${activeTasks.size} active tasks in TASKS.md`);
 
-  const anomalies = scanBacklogs(AUDITS_DIR, completedTasks);
+  const backlogAnomalies = scanBacklogs(AUDITS_DIR, completedTasks, activeTasks);
+  const anomalies = [...formatAnomalies, ...backlogAnomalies];
 
   if (anomalies.length === 0) {
-    console.log("✅ Backlog check passed! No status drift or independent checkboxes found.");
+    console.log("✅ Backlog check passed! No status drift, untracked tasks, or ID format violations found.");
     process.exit(0);
   }
 
-  console.log(`\n🔴 Found ${anomalies.length} status-drift anomalies:\n`);
+  console.log(`\n🔴 Found ${anomalies.length} anomalies:\n`);
   
+  const formatViolations = anomalies.filter(a => a.reason === "invalid_id_format");
   const mismatches = anomalies.filter(a => a.reason === "status_mismatch");
+  const untracked = anomalies.filter(a => a.reason === "untracked_task_id");
   const noIds = anomalies.filter(a => a.reason === "no_task_id");
 
+  if (formatViolations.length > 0) {
+    console.log("🚫 ID Format Violations (Task IDs must be fully uppercase and use dash separators, e.g. ABC-123):");
+    for (const a of formatViolations) {
+      console.log(`   [${a.file}:${a.line}] Malformed Task ID "${a.taskId}": "${a.content}"`);
+    }
+    console.log();
+  }
+
   if (mismatches.length > 0) {
     console.log("⚠️  Status Mismatches (Marked [x] in TASKS.md but pending [ ] in backlog):");
     for (const a of mismatches) {
@@ -121,6 +216,14 @@ function main() {
     console.log();
   }
 
+  if (untracked.length > 0) {
+    console.log("❗ Untracked Tasks (Pending [ ] in backlog but does not exist as an active task in TASKS.md):");
+    for (const a of untracked) {
+      console.log(`   [${a.file}:${a.line}] ${a.taskId} is missing from TASKS.md: "${a.content}"`);
+    }
+    console.log();
+  }
+
   if (noIds.length > 0) {
     console.log("🚫 Independent Checkboxes (Pending [ ] without associated Task ID):");
     for (const a of noIds) {
@@ -130,11 +233,17 @@ function main() {
   }
 
   console.log("💡 Fixes:");
+  console.log("   - For format violations: Rename the task ID to uppercase dashed convention.");
   console.log("   - For mismatches: Update the backlog file checkbox to [x] or reference tasks correctly.");
+  console.log("   - For untracked tasks: Add the task definition to TASKS.md first.");
   console.log("   - For independent checkboxes: Associate them with a Task ID or archive the snapshot.");
 
-  // We exit with 0 as this is report-only, but let the logs flag it
-  process.exit(0);
+  if (FAIL_ON_DRIFT) {
+    console.log("\n❌ Failing check due to --fail-on-drift flag.");
+    process.exit(1);
+  } else {
+    process.exit(0);
+  }
 }
 
 main();

codex
The backlog drift checker introduces a regression in task-ID detection semantics, causing independent unchecked items to be misidentified and reducing report accuracy. Because this script now gates CI behavior through `--fail-on-drift`, the regression is operationally significant.

Review comment:

- [P1] Preserve no-task-ID detection for backlog checkboxes — /home/enio/egos/scripts/check-backlog-status.ts:131-136
  The new backlog parser now matches any word token on pending lines (`\b([a-zA-Z0-9_#-]+)\b`), so checkboxes without a real task ID are no longer classified as `no_task_id`; they get misclassified as `invalid_id_format` based on arbitrary prose. This breaks the script’s stated contract to detect independent checkboxes and can produce misleading drift reports when backlog items omit IDs.
The backlog drift checker introduces a regression in task-ID detection semantics, causing independent unchecked items to be misidentified and reducing report accuracy. Because this script now gates CI behavior through `--fail-on-drift`, the regression is operationally significant.

Review comment:

- [P1] Preserve no-task-ID detection for backlog checkboxes — /home/enio/egos/scripts/check-backlog-status.ts:131-136
  The new backlog parser now matches any word token on pending lines (`\b([a-zA-Z0-9_#-]+)\b`), so checkboxes without a real task ID are no longer classified as `no_task_id`; they get misclassified as `invalid_id_format` based on arbitrary prose. This breaks the script’s stated contract to detect independent checkboxes and can produce misleading drift reports when backlog items omit IDs.
```
