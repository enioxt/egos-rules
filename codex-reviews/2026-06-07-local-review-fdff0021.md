# Codex Local Review — 2026-06-07T17:55:28Z

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
session id: 019ea339-b4ff-7ff0-88fb-138b7183951f
--------
user
changes against 'HEAD~3'
2026-06-07T17:55:29.958617Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T17:55:29.958618Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 3de5adf63b75fd82279ccd1c0b5d500fa011478e --stat && git diff 3de5adf63b75fd82279ccd1c0b5d500fa011478e' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |   2 +-
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 apps/egos-landing/src/App.tsx                      |   4 +-
 docs/CAPABILITY_REGISTRY.md                        |  16 +
 .../handoff_2026-06-07-intelink-public-release.md  | 175 ++++++++
 packages/pii-purge/README.md                       | 103 +++++
 packages/pii-purge/package.json                    |  14 +
 packages/pii-purge/src/cli.ts                      | 181 ++++++++
 packages/pii-purge/src/dictionary.ts               |  88 ++++
 packages/pii-purge/src/patterns.ts                 | 236 +++++++++++
 packages/pii-purge/src/pii-purge.test.ts           | 460 +++++++++++++++++++++
 packages/pii-purge/src/purge.ts                    | 217 ++++++++++
 packages/pii-purge/src/scanner.ts                  | 163 ++++++++
 packages/pii-purge/src/verify.ts                   |  42 ++
 packages/pii-purge/tsconfig.json                   |  10 +
 16 files changed, 1710 insertions(+), 5 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index c5aaabfe..74e4a4f6 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -11,7 +11,7 @@
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 > Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
-- [ ] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — experimento mínimo "validar os dois" (comunidade/material + setup assistido) COMEÇANDO DE GRAÇA (sem cobrança, sem PCMG risk): publicar artefato grátis (deploy landing HITL) → 1ª pessoa interessada vira teste de setup assistido gratuito → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
+- [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
 - [ ] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — auditoria Guarani #1: metaprompt v3 hardcoded inline em App.tsx (drift vs docs/drafts/free-artifact-egos-v0.md). Build Vite pré-compila do markdown canônico → src/data/metaprompt-source.ts. Evita drift SSOT.
 - [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..96804c4b 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 17:50:59 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index 439263b6..ba3c38a8 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -1069,7 +1069,7 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
               <section style={{ textAlign: 'center', marginBottom: '48px' }}>
                 <h1 className="h2">Transparência & Governança</h1>
                 <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '12px auto 0' }}>
-                  Nosso manifesto e a arquitetura técnica que garante conformidade contínua e controle total do usuário.
+                  Nosso manifesto e a arquitetura técnica que apoia a conformidade contínua e mantém o controle com o usuário.
                 </p>
               </section>
 
@@ -1084,7 +1084,7 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
                 <div className="card" style={{ padding: '32px' }}>
                   <h3 className="h3" style={{ marginBottom: '12px' }}>2. Sem Lock-in Tecnológico</h3>
                   <p style={{ color: 'var(--text-muted)', lineHeight: 1.7 }}>
-                    Se decidir descontinuar o uso de nossas implementações ou consultoria, você tem até 5 dias úteis para receber a exportação completa de KBs (bases de conhecimento) estruturadas em Markdown e transcrições de banco de dados em formato aberto (CSV/JSON), garantindo portabilidade total.
+                    Se decidir descontinuar o uso de nossas implementações ou consultoria, você tem até 5 dias úteis para receber a exportação dos seus KBs (bases de conhecimento) em Markdown e as transcrições de banco de dados em formato aberto (CSV/JSON), para preservar a portabilidade dos seus dados.
                   </p>
                 </div>
 
diff --git a/docs/CAPABILITY_REGISTRY.md b/docs/CAPABILITY_REGISTRY.md
index b06ec1b0..3247fd19 100644
--- a/docs/CAPABILITY_REGISTRY.md
+++ b/docs/CAPABILITY_REGISTRY.md
@@ -3533,3 +3533,19 @@ Avaliação iterativa de artefatos estáticos (.md, .html, .txt) via LLM-as-judg
 **CLI:** `bun scripts/material-eval-loop.ts --file <caminho> [--threshold 7.5] [--max-iterations 3] [--dry-run] [--json]`
 
 **Tags:** `eval`, `quality`, `material`, `llm-judge`, `iterative`, `courses`, `threshold`, `prime`
+
+## §114 — Motor de Purge de Entidades em Massa (pii-purge) (2026-06-07)
+
+- **Status:** REAL
+- **Path:** `packages/pii-purge/`
+- **Owner:** prime
+- **Evidence:** `packages/pii-purge/src/pii-purge.test.ts` (29 testes vitest verdes) + `packages/pii-purge/README.md`
+- **VERIFIED_AT:** 2026-06-07 (run independente Prime: 29 pass / 0 fail; R-SEC-001 0 achados; gitleaks 0)
+- **Method:** code review das travas de segurança + execução de testes
+- **Golden cases:** (1) todas as variantes de formato (CPF formatado/cru, placa antiga/Mercosul, telefone) de uma entidade sintética são detectadas; (2) token-map coerente — CPF e nome da mesma entidade viram o mesmo `[PESSOA_N]` em arquivos diferentes; (3) `--dry-run` (default) não modifica bytes; nome fuzzy = `REVIEW_REQUIRED`, nunca auto-purgado
+
+Dado conhecido (CPF/telefone/placa/nome+alias) → gera todas as variantes de formato (reusa `masks`/`normalizeOrtho` reimplementados) → varre diretório git-tracked → purga coerente com token estável por entidade → audit hash-chained → verify zero-tolerância. **Travas:** finding nunca carrega o valor casado (T0 §3, só offset+length); `--dry-run` é default, escrita só com `--apply`; nomes fuzzy só FLAG (HITL), nunca purge silencioso. Reusa `packages/guard-brasil` (pii-patterns/scanner). Origem: INC-PII-001 (purge manual irrepetível) + corte Enio 2026-06-07 (limpar dado sensível em massa antes de publicar). SSOT desta frente: `docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md` §4.
+
+**CLI:** `bun packages/pii-purge/src/cli.ts --entity-dict <path> --target <dir> [--dry-run(default)|--apply] [--json]`
+
+**Tags:** `security`, `pii`, `lgpd`, `purge`, `redaction`, `publish-gate`, `guard-brasil`, `prime`, `WS4`
diff --git a/docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md b/docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md
new file mode 100644
index 00000000..3214539e
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md
@@ -0,0 +1,175 @@
+# Handoff — Intelink Public Release (intelink-platform) + Capacidades de Kernel
+
+> **Data:** 2026-06-07 · **Owner:** EGOS Prime · **Norte:** Pursuit A = intelink/DHPP
+> **Status:** PLANO APROVADO PARCIAL — aguarda Enio escolher trilha de execução
+> **Repos:** `intelink-clean` → `github.com/enioxt/intelink-platform` (público-alvo) · `egos` (kernel: purge-tool + discover-gate)
+> **Red Zone ativa:** PII + contexto policial. NENHUM push público sem corte do Enio.
+
+Este doc é o SSOT desta frente. Consolida 4 sondas de pesquisa (2026-06-07) + cortes do Enio na sessão.
+
+---
+
+## 0. Cortes do Enio nesta sessão (CONFIRMADO)
+
+1. **Remover os docs RELINT** do repo público (metodologia que embute caso real) — não mascarar, excluir.
+2. **Escopo público = plataforma funcional completa** (tudo ✅ Prod, rodável com dados sintéticos).
+3. **Foco do produto = BUSCA GLOBAL + TIMELINE** (decisão antiga, confirmada).
+4. **Deixar 1 operação sintética pré-criada** demonstrando as capacidades.
+5. **Deixar claro como testar localmente.**
+6. **Construir motor de purge inteligente em massa** (bracc + intelink + guard-brasil) — limpar dado sensível quando quiser, de forma eficaz.
+7. **Gate discover-before-create:** pre-commit trava criação de capability/skill/integração nova sem antes consultar os SSOTs. Triggers sempre ativos.
+
+---
+
+## 1. 🔴 ACHADO CRÍTICO — PII real ainda versionada no repo público-alvo
+
+A "baseline limpa" (commit `f0cfdb7`) foi **redação incompleta**: find-replace de alguns nomes por `[INVESTIGADO]`, mas sobrou PII real de uma operação real (DDD 34 = Triângulo Mineiro/MG). **CONFIRMADO** (não hipótese). Os VALORES reais NÃO são reproduzidos aqui (R-SEC-002 [T0] — nem em repo privado); só o tipo + local. Abrir o arquivo para ver o valor:
+
+| Arquivo (intelink-clean) | Tipo de PII real (valor no arquivo) | Ação |
+|---|---|---|
+| `docs/governance/RELINT_RULES_v1.md` | 3 nomes próprios · 1 CPF real · 1 telefone MG | **REMOVER** (corte 1) |
+| `docs/governance/RELINT_STANDARD.md` | 1 nome completo · 1 placa real · 1 telefone MG | **REMOVER** (corte 1) |
+| `docs/INTELINK_INPUT_TYPES.md:41` | 1 nome próprio | MASCARAR → `[INVESTIGADO]` |
+| `docs/INTELINK_MASTER_PLAN_2026-04-29.md:126` | 1 placa real | MASCARAR → `ABC1D23` |
+| `app/api/intel/placa/route.ts:2` | 1 placa real (comentário exemplo) | MASCARAR → `ABC1D23` |
+| `scripts/transcribe_local.py:68` | lista hardcoded de nomes próprios reais | REMOVER nomes reais (manter lógica) |
+| `scripts/send-onboarding-to-group.ts:3` | nome do grupo WhatsApp da operação | MASCARAR → "Grupo Exemplo" |
+| `scripts/check-pep-sanctions.ts:32` | 1 CPF exemplo (provável sintético) | MASCARAR → fake óbvio (LOW) |
+| `docs/relints/README.md` | IP 18.736.639 + "rede PCC local" (já tokenizado) | REVISAR/genericizar |
+
+**Refs a corrigir após remover RELINT (broken-link):** `docs/governance/INTELINK_2_PRODUCTS_DECISION.md`, `docs/governance/RCI_PADRAO_INDEX.md`, `docs/relints/README.md`.
+
+**Tranquilizador:** a esmagadora maioria dos CPFs/telefones no código são fictícios clássicos (padrão `NNN.NNN.NNN-NN` tipo sequência óbvia + telefones de exemplo) em prompts/exemplos/máscaras — esses ficam. Testes (`rci-compliance.test.ts`) usam CPFs sintéticos ✅.
+
+---
+
+## 2. Foco do produto: Busca Global + Timeline (evidência)
+
+- **Busca Global** — `docs/modules/BUSCA_GLOBAL.md` (✅ Prod): `GET /api/search?q=`, <500ms, CPF/placa/nome/apelido, fuzzy Jaro-Winkler, flag `crossCase`. Origem: msg WhatsApp Enio 2025-12-11 (`docs/PLAN_ORCHESTRATION.md:15`). Gap: RG não é critério; Jaro-Winkler não integrado na rota de busca (só dedup).
+- **Timeline** — `docs/governance/TIMELINE_SSOT.md` (backend ✅): tabela `intelink_timeline`, write-singleton `lib/timeline/emit.ts`, 14 event_types, soft-delete auditado. Gap: auto-emit parcial (faltam `report_generated/signed/status_changed/entity_added`); UI per-suspect (`/investigation/[id]/pessoas/[person_id]/timeline`) só planejada (3 tasks).
+
+---
+
+## 3. Estado do app + teste local (sonda 2)
+
+**Stack:** Next.js 16 (App Router) · React 19 · Bun · Neo4j 5 · Supabase (PG+pgvector+Auth) · OpenRouter (qwen-plus).
+
+**Rodar local (resumido):**
+```bash
+git clone https://github.com/enioxt/intelink-platform.git && cd intelink-platform
+bun install
+cp .env.example .env.local   # preencher Supabase + Neo4j + OpenRouter + JWT + SIGNUP_CODE + CRON_SECRET
+docker run -d --name intelink-neo4j -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/SENHA neo4j:5-community
+# aplicar supabase/migrations/*.sql (17 DDL em ordem) + supabase/seed/01-fixture.sql
+INTELINK_TESTING_MODE=true bun dev   # bypassa auth Telegram — porta 3001
+# OU: docker compose -f docker-compose.dev.yml up
+```
+
+**Bloqueios para "clonar→rodar→ver funcionando" (gaps concretos):**
+1. **Auth Telegram** trava o teste rápido → `INTELINK_TESTING_MODE=true` (já existe em `lib/api-security.ts:17`, bloqueado em prod). Documentar com destaque.
+2. **Sem seed Neo4j** — busca global consulta Supabase + Neo4j; grafo nasce vazio. Falta `supabase/seed/02-neo4j-fixture.cypher`.
+3. **`examples/fixtures/` não existe** (referenciado em CHECKLIST_LAUNCH + DIVULGACAO, nunca criado).
+4. **Demo operation rica não existe** — `seed/01-fixture.sql` é mínimo (1 op, 2 entidades, 1 timeline). `lib/demo-data.ts` + `/demo` (página estática, sem auth) usa cenário de corrupção genérico, desconectado do DB.
+5. **CHECKLIST_LAUNCH 35%** — Bloco Segurança "0%" subestima: o real é a PII do §1.
+
+---
+
+## 4. Motor de Purge Inteligente em Massa (sonda 4) — `packages/pii-purge/`
+
+**Princípio:** já temos as entidades mapeadas (resolução do bracc + tabelas intelink) → sabemos *o que* limpar; falta o motor que *acha todas as variações e purga coerente* + um gate de pré-publicação.
+
+**Arquitetura:** EntityDictionary → Pattern Generator (variantes) → Multi-Pass Scanner → Mask/Purge coerente (token estável por entidade) → Audit hash-chained → Pre-Publish Gate (verify zero-tolerância).
+
+**Reuso (não criar do zero):**
+| Estágio | Asset existente | Status |
+|---|---|---|
+| Variantes de formato | `intelink/lib/masks.ts` (formatCPF/Placa/Phone) | reuso direto |
+| Normalização ortográfica + fuzzy | `intelink/lib/intelligence/fuzzy-name.ts` (normalizeOrtho, jaroWinkler) | reuso direto |
+| Scan PII estrutural (SSOT canônico) | `egos/packages/guard-brasil/src/pii-patterns.ts` (detectPII, 16 tipos BR) | reuso direto |
+| Detecção contextual de nome | `guard-brasil/src/lib/pii-scanner.ts` (scanForPII) | reuso |
+| Receipt hash-chained | `guard-brasil/src/guard.ts` (sha256Text, InspectionReceipt) | reuso |
+| Gate pre-commit | `egos/scripts/security/scan-hardcoded-sensitive.ts` (--staged/--all/--path) | estender c/ `--entity-dict` |
+| Verificação pós-purge (MCP) | `guard_check_safe`, `guard_scan_pii` | reuso |
+| Dicionário de entidades públicas | `bracc` `/api/v1/entity/<CPF>` | opcional; **NUNCA p/ investigado privado (R-SEC-002)** |
+
+**A construir (novo, ~190 LOC MVP):** EntityDictionary loader (JSON gitignored `~/.egos-purge-entities.json`) · Pattern Generator entidade→regex · token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos os arquivos) · file-tree walker c/ audit manifest · gate bloqueante.
+
+**MVP (limpa intelink-platform AGORA):** exato + variantes de formato p/ CPF/tel/placa/REDS. **Nomes fuzzy → flag REVIEW_REQUIRED (HITL), nunca purge silencioso** (purge fuzzy sem confirmação destrói cadeia de evidência).
+
+**Histórico:** o purge do INC-PII-001 foi MANUAL (`git filter-repo` + squash), nenhum script sobreviveu. Este motor o torna repetível.
+
+---
+
+## 5. Gate Discover-Before-Create (corte 7) — pre-commit bloqueante
+
+**Objetivo:** ninguém (IA ou humano) cria capability/skill/integração nova sem antes consultar os SSOTs. Triggers sempre ativos.
+
+**Infra existente (estender, não criar):**
+- SSOTs: `CAPABILITY_REGISTRY.md` (300 seções) + `MCP_REGISTRY.md` + `INTEGRATION_REGISTRY.md` + `SKILLS_REGISTRY.md` + `CBC-*.md` (formato v1) + `R-CAP-001` (ciclo de vida USADA/DOCUMENTADA/VALIDADA/TESTADA).
+- Pre-commit: já há `.husky/_checks/5.95-capability-detector.sh` + `vocab-guard` (bloqueia buzzwords-fantasma) + `SSOT Gate 5.7` (bloqueia .md novo que pertence a SSOT existente).
+
+**Desenho do gate (DISCOVER-GATE):**
+1. **Detector de criação nova:** no commit, identifica artefato novo de capability/skill/integração — novo `packages/*/`, novo `.claude/commands/*.md`, novo `CBC-*.md`, nova entrada em INTEGRATION/MCP/SKILLS registry, novo `agents/skills/*.ts`.
+2. **Trava + exige prova de consulta:** bloqueia salvo trailer `CONSULTED-SSOT: <registries lidos> + <decisão reuse|extend|new + justificativa>` no commit body. Sem isso → exit 1 com mensagem mandando rodar a consulta.
+3. **Consulta guiada (comando):** `bun scripts/discover-capability.ts <termo>` busca nos 4 registries + codebase-memory-mcp + CBC-* e devolve "já existe X (reusar) / parecido Y (estender) / nada (criar)". O trailer referencia o resultado.
+4. **Auto-consulta periódica (trigger sempre ativo):** Sentinela/cron + Layer no `/start` que reporta drift de registry (capacidades novas no código sem entrada). Liga ao `gen-registry-parity-counts.ts` existente.
+5. **Documentação primeiro:** o gate aponta a ordem de leitura (CAPABILITY_REGISTRY → registries irmãos → CBC-* → codebase-memory) antes de aceitar criação.
+
+**Este gate é o princípio "descubra-antes-de-criar" auto-aplicado:** a própria solução reusa 5.95 + vocab-guard + SSOT-gate em vez de criar gate do zero.
+
+---
+
+## 6. Backlog reorganizado (sonda 1 — ~348 tasks brutas → ~40-50 relevantes)
+
+**Insight:** `intelink/TASKS.md` tem 321 abertas, mas dominadas por 3 categorias FORA do foco público: (a) trabalho de operação policial real (INTEL/RELINT/OP — pertencem ao repo privado), (b) pipeline Windows NER/fine-tuning (Ollama/RTX), (c) épico IRB financeiro (~20 tasks, dado sensível). Removendo: backlog real de plataforma ≈ 40-50 tasks.
+
+### Trilhas + tasks novas (IDs canônicos desta frente)
+
+**WS1 — PII Cleanup [P0, BLOQUEIA público]** (repo: intelink-clean)
+- `IPR-PII-001` Remover `RELINT_RULES_v1.md` + `RELINT_STANDARD.md` + corrigir 3 refs broken-link
+- `IPR-PII-002` Mascarar PII real nos 6 arquivos não-RELINT (§1)
+- `IPR-PII-003` Re-scan zero-tolerância (sweep tokens conhecidos = vazio) + verify gate
+- `IPR-PII-004` Revisar `docs/relints/README.md` (IP/PCC) — genericizar ou .gitignore
+
+**WS2 — Funcional + teste local + demo sintética [P0]** (intelink-clean)
+- `IPR-DEMO-001` Expandir `seed/01-fixture.sql`: 5-8 pessoas, 2-3 veículos, 2-3 entidades cross-case (CPF inválido Luhn `000.000.000-0N`)
+- `IPR-DEMO-002` Criar `seed/02-neo4j-fixture.cypher` (Person/Occurrence/Vehicle + ENVOLVIDO_EM, UUIDs casando Supabase)
+- `IPR-DEMO-003` Timeline seed multi-event_type (6-12 meses) — demonstra linha do tempo
+- `IPR-DEMO-004` 2ª investigação compartilhando 1 entidade → dispara `crossCase:true` (demo mais forte)
+- `IPR-DOC-001` README quick-start com `INTELINK_TESTING_MODE=true` em destaque + comandos exatos
+- `IPR-TEST-001` (INST-CLEAN) `bun install` + seed em container limpo — prova setup
+- `IPR-TEST-002` (TEST-SMOKE) E2E: login(testing) → busca global → timeline → resultado
+
+**WS3 — Polish Busca Global + Timeline [P1, core]** (intelink ↔ intelink-clean)
+- `IPR-SEARCH-001` (POST1-OBS-001) Bug: spinner de loading na GlobalSearch
+- `IPR-SEARCH-002` (INTELINK-2P-109) Drawer persistente Cmd+K dentro da investigação
+- `IPR-TL-001` (INTELINK-2P-012) Filtros UI timeline (classificação, tipo, data)
+- `IPR-TL-002` (INTELINK-2P-013) Botões de ação por entry (editar, validar, anexar, EGOS analisa)
+- `IPR-TL-003` (INTELINK-2P-108) Indicador visual CONFIRMADO/INFERIDO/HIPÓTESE
+
+**WS4 — Motor de Purge [P0 capability]** (repo: egos `packages/pii-purge/`)
+- `PII-PURGE-001` Scaffold `packages/pii-purge/` + EntityDictionary schema (JSON gitignored)
+- `PII-PURGE-002` Pattern Generator (reusa masks.ts + fuzzy-name.ts)
+- `PII-PURGE-003` Scanner CLI (fork scan-hardcoded-sensitive.ts + `--entity-dict`)
+- `PII-PURGE-004` Purge mode + token-map coerente + audit hash-chained (`--dry-run` first)
+- `PII-PURGE-005` Verify gate pós-purge (zero-tolerância) + wire publish gate (R-SEC-005)
+- `PII-PURGE-006` CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY
+
+**WS5 — Gate Discover-Before-Create [P1 governance]** (repo: egos)
+- `DISCOVER-GATE-001` `scripts/discover-capability.ts <termo>` (busca 4 registries + codebase-memory + CBC)
+- `DISCOVER-GATE-002` Detector de criação nova no pre-commit (packages/skills/commands/integration)
+- `DISCOVER-GATE-003` Trava + trailer `CONSULTED-SSOT:` obrigatório (exit 1 sem prova)
+- `DISCOVER-GATE-004` Auto-consulta periódica (Sentinela/cron + Layer /start de drift de registry)
+- `DISCOVER-GATE-005` Doc da ordem de leitura + R-DISCOVER-001 em AGENTS.md/CLAUDE.md
+
+### Tasks a DEFERIR/ARQUIVAR (fora do foco público)
+IRB-F* (~20, dado financeiro sensível) · INTEL/RELINT/OP-* (operação real → repo privado) · NER/FACE/WIN/OLLAMA-* (Windows/GPU) · POST1-COMMS/MONITOR (onboarding usuário específico). **Não deletar — mover p/ TASKS_ARCHIVE do repo privado.**
+
+### Duplicatas a resolver
+RCI-DOC-004 = RCI-CONFIG · LLM-DATA-006/TRAIN-004/EVAL-002 duplicadas em 2 sprints · INTEL-013 duplicada.
+
+---
+
+## 7. Próximo passo
+
+Aguarda Enio escolher trilha de execução (ver pergunta de direção). Recomendação de ordem: **WS1 (desbloqueia público) → WS4 (purge tool, que automatiza WS1 e futuras limpezas) → WS2 (demo+local) → WS3 (polish) → WS5 (gate)**. WS1 manual agora; WS4 torna repetível.
diff --git a/packages/pii-purge/README.md b/packages/pii-purge/README.md
new file mode 100644
index 00000000..22466b3b
--- /dev/null
+++ b/packages/pii-purge/README.md
@@ -0,0 +1,103 @@
+# @egos/pii-purge
+
+**v0.1.0** | Status: MVP ativo
+
+Motor de purge de PII conhecida em diretórios — encontra e substitui entidades sensíveis (CPF/telefone/placa/nome/REDS) antes de publicação pública. Parte do gate `R-SEC-005` (publish gate).
+
+---
+
+## Para que serve
+
+Dado um dicionário de entidades (pessoas/veículos a remover), o motor:
+
+1. Gera todas as variantes de formato de cada identificador (CPF formatado e não formatado, telefone com/sem parênteses, placa com/sem traço etc.)
+2. Varre todos os arquivos rastreados por git em um diretório-alvo
+3. Retorna `Finding[]` com arquivo, linha, entidade e tipo — **nunca o valor encontrado**
+4. Em `--apply`: substitui cada match por um token coerente (`[PESSOA_1]`, `[PESSOA_2]`, ...) e grava log de auditoria hash-chained
+5. Em `--verify`: re-escaneia e confirma zero achados auto-purgeáveis restantes
+
+**Nomes fuzzy (acentuação normalizada)** geram `REVIEW_REQUIRED` e bloqueiam a saída (exit 1) sem nunca serem auto-purgados — o humano resolve antes de publicar.
+
+---
+
+## Stack
+
+- Runtime: **Bun** (nativo)
+- Linguagem: TypeScript estrito
+- Testes: `bun test` (vitest-compatible)
+- Dependências externas: zero (helpers reimplementados localmente)
+
+---
+
+## Quick start
+
+```bash
+# Instalar no workspace egos
+bun install
+
+# Dry-run (padrão seguro — não modifica nada)
+bun packages/pii-purge/src/cli.ts \
+  --entity-dict ~/.egos-purge-entities.json \
+  --target ~/intelink-clean
+
+# Aplicar purge (requer --apply explícito)
+bun packages/pii-purge/src/cli.ts \
+  --entity-dict ~/.egos-purge-entities.json \
+  --target ~/intelink-clean \
+  --apply
+
+# Saída JSON (para integração com outros scripts)
+bun packages/pii-purge/src/cli.ts \
+  --entity-dict ~/.egos-purge-entities.json \
+  --target ~/intelink-clean \
+  --json
+```
+
+---
+
+## Formato do dicionário
+
+O arquivo `~/.egos-purge-entities.json` vive **fora do repositório** (gitignored). Nunca versionar entidades reais.
+
+```json
+{
+  "entities": [
+    {
+      "id": "pessoa-001",
+      "cpfs": ["NNN.NNN.NNN-NN"],
+      "phones": ["(34) 99000-0000"],
+      "plates": ["ABC-1234"],
+      "names": ["Nome Completo da Pessoa"],
+      "reds": ["2024000000"]
+    }
+  ]
+}
+```
+
+---
+
+## Testes
+
+```bash
+# Rodar suite (usa apenas entidades sintéticas)
+bun test packages/pii-purge/src/pii-purge.test.ts
+
+# Typecheck
+cd packages/pii-purge && bun run typecheck
+```
+
+---
+
+## Segurança
+
+- `--dry-run` é o padrão — `--apply` exige flag explícita
+- Valores encontrados **nunca aparecem em logs ou findings** (T0 §3)
+- Nomes fuzzy nunca são auto-purgados (protege cadeia de evidência)
+- Audit log hash-chained: cada registro inclui `sha256Before` + `sha256After` + `prevHash`
+- Dicionário real deve estar em path gitignored (`~/.egos-purge-entities.json` ou equivalente)
+- Exit 1 se restar qualquer `REVIEW_REQUIRED` — bloqueia publicação até resolução humana
+
+---
+
+*SSOT deste módulo: `docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md` §4*
+*Gate de publicação: R-SEC-005 + WS4 (PII-PURGE-001..005)*
diff --git a/packages/pii-purge/package.json b/packages/pii-purge/package.json
new file mode 100644
index 00000000..13b49de3
--- /dev/null
+++ b/packages/pii-purge/package.json
@@ -0,0 +1,14 @@
+{
+  "name": "@egos/pii-purge",
+  "version": "0.1.0",
+  "description": "Motor de purge de PII conhecida em diretórios — EntityDictionary, pattern variants, audit hash-chained",
+  "type": "module",
+  "private": true,
+  "scripts": {
+    "test": "bun test src/pii-purge.test.ts",
+    "typecheck": "tsc --noEmit -p tsconfig.json"
+  },
+  "devDependencies": {
+    "typescript": "^5.0.0"
+  }
+}
diff --git a/packages/pii-purge/src/cli.ts b/packages/pii-purge/src/cli.ts
new file mode 100644
index 00000000..66d2597f
--- /dev/null
+++ b/packages/pii-purge/src/cli.ts
@@ -0,0 +1,181 @@
+#!/usr/bin/env bun
+/**
+ * CLI — pii-purge
+ *
+ * Usage:
+ *   bun packages/pii-purge/src/cli.ts \
+ *     --entity-dict <path-to-dict.json> \
+ *     --target <directory> \
+ *     [--apply] \
+ *     [--json]
+ *
+ * Defaults to --dry-run (safe). Writing requires explicit --apply.
+ * Exits 1 if: verify fails OR REVIEW_REQUIRED findings remain (blocks publish).
+ *
+ * NEVER prints matched values (T0 §3).
+ */
+
+import { loadDictionary } from './dictionary.js';
+import { generateAllPatterns } from './patterns.js';
+import { scanDirectory } from './scanner.js';
+import { buildTokenMap, runPurge } from './purge.js';
+import { verify } from './verify.js';
+import { resolve, dirname } from 'node:path';
+import { mkdirSync } from 'node:fs';
+
+// ─── Arg parsing ──────────────────────────────────────────────────────────────
+
+function parseArgs(argv: string[]): {
+  entityDict: string;
+  target: string;
+  apply: boolean;
+  json: boolean;
+} {
+  const args: Record<string, string | boolean> = {};
+  for (let i = 0; i < argv.length; i++) {
+    const arg = argv[i]!;
+    if (arg === '--apply') { args['apply'] = true; }
+    else if (arg === '--dry-run') { args['dry-run'] = true; }
+    else if (arg === '--json') { args['json'] = true; }
+    else if (arg.startsWith('--')) {
+      const key = arg.slice(2);
+      args[key] = argv[i + 1] ?? true;
+      i++;
+    }
+  }
+
+  const entityDict = args['entity-dict'];
+  const target = args['target'];
+
+  if (!entityDict || typeof entityDict !== 'string') {
+    console.error('[pii-purge] ERROR: --entity-dict <path> is required');
+    process.exit(1);
+  }
+  if (!target || typeof target !== 'string') {
+    console.error('[pii-purge] ERROR: --target <directory> is required');
+    process.exit(1);
+  }
+
+  return {
+    entityDict: resolve(entityDict),
+    target: resolve(target),
+    apply: args['apply'] === true,
+    json: args['json'] === true,
+  };
+}
+
+// ─── Main ─────────────────────────────────────────────────────────────────────
+
+async function main(): Promise<void> {
+  const opts = parseArgs(process.argv.slice(2));
+  const mode = opts.apply ? 'apply' : 'dry-run';
+
+  if (!opts.json) {
+    console.log(`[pii-purge] mode=${mode} dict=${opts.entityDict} target=${opts.target}`);
+  }
+
+  // 1. Load dictionary
+  const dict = await loadDictionary(opts.entityDict);
+  if (!opts.json) {
+    console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
+  }
+
+  // 2. Generate patterns
+  const patterns = generateAllPatterns(dict.entities);
+
+  // 3. Scan
+  const findings = await scanDirectory(opts.target, patterns);
+
+  const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
+  const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+
+  if (!opts.json) {
+    console.log(`[pii-purge] Scan complete: ${findings.length} total findings`);
+    console.log(`  auto-purgeable: ${autoFindings.length}`);
+    console.log(`  REVIEW_REQUIRED (fuzzy): ${reviewFindings.length}`);
+    for (const f of findings) {
+      // NEVER print matched value — only metadata
+      const flag = f.matchType === 'fuzzy-REVIEW' ? ' [REVIEW_REQUIRED]' : '';
+      console.log(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}${flag}`);
+    }
+  }
+
+  // 4. Build token map
+  const tokenMap = buildTokenMap(dict.entities);
+
+  // 5. Purge (or dry-run)
+  const auditLogDir = dirname(opts.entityDict);
+  mkdirSync(auditLogDir, { recursive: true });
+
+  const purgeResult = await runPurge(findings, tokenMap, mode, auditLogDir);
+
+  if (!opts.json) {
+    if (mode === 'dry-run') {
+      console.log(`[pii-purge] DRY-RUN: would modify ${purgeResult.planned.length} file(s)`);
+      for (const p of purgeResult.planned) {
+        console.log(`  ${p.file} → ${p.findingsCount} replacement(s) with ${p.token}`);
+      }
+    } else {
+      console.log(`[pii-purge] APPLIED to ${purgeResult.applied.length} file(s)`);
+      if (purgeResult.auditLogPath) {
+        console.log(`[pii-purge] Audit log: ${purgeResult.auditLogPath}`);
+      }
+    }
+  }
+
+  // 6. Verify (only in apply mode — meaningful post-write)
+  let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
+  if (mode === 'apply') {
+    verifyResult = await verify(opts.target, patterns);
+    if (!opts.json) {
+      if (verifyResult.cleanExit) {
+        console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
+      } else {
+        console.error(`[pii-purge] VERIFY FAILED: ${verifyResult.remaining.length} auto-purgeable finding(s) remain`);
+        for (const f of verifyResult.remaining) {
+          console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type}`);
+        }
+      }
+    }
+  }
+
+  if (opts.json) {
+    console.log(JSON.stringify({
+      mode,
+      findings: findings.map(f => ({
+        file: f.file,
+        line: f.line,
+        entityId: f.entityId,
+        type: f.type,
+        matchType: f.matchType,
+        // matched value intentionally omitted (T0 §3)
+      })),
+      planned: purgeResult.planned,
+      applied: purgeResult.applied,
+      skippedFuzzy: purgeResult.skippedFuzzy,
+      verifyCleanExit: verifyResult.cleanExit,
+      reviewRequiredCount: verifyResult.reviewRequired.length,
+      auditLogPath: purgeResult.auditLogPath ?? null,
+    }, null, 2));
+  }
+
+  // 7. Exit code
+  const hasFuzzy = verifyResult.reviewRequired.length > 0;
+  const hasRemaining = !verifyResult.cleanExit;
+
+  if (hasFuzzy || hasRemaining) {
+    if (!opts.json) {
+      if (hasFuzzy) {
+        console.warn(`[pii-purge] ${verifyResult.reviewRequired.length} REVIEW_REQUIRED finding(s) — resolve manually before publishing`);
+      }
+    }
+    process.exit(1);
+  }
+
+  process.exit(0);
+}
+
+main().catch(err => {
+  console.error('[pii-purge] Fatal error:', err instanceof Error ? err.message : String(err));
+  process.exit(1);
+});
diff --git a/packages/pii-purge/src/dictionary.ts b/packages/pii-purge/src/dictionary.ts
new file mode 100644
index 00000000..c16af3fe
--- /dev/null
+++ b/packages/pii-purge/src/dictionary.ts
@@ -0,0 +1,88 @@
+/**
+ * EntityDictionary — Loads and validates the entity JSON for purge operations.
+ *
+ * The real dict lives at a gitignored path (e.g. ~/.egos-purge-entities.json).
+ * Tests pass a synthetic EntityDictionary object directly — never load real data
+ * in test context.
+ *
+ * Schema: { entities: Entity[] }
+ * Entity: { id, cpfs?, phones?, names?, plates?, reds? }
+ */
+
+// ─── Types ────────────────────────────────────────────────────────────────────
+
+export interface Entity {
+  /** Stable unique identifier — used as the basis for [PESSOA_N] tokens */
+  id: string;
+  /** CPF strings — may be formatted (NNN.NNN.NNN-NN) or raw (NNNNNNNNNNN) */
+  cpfs?: string[];
+  /** Phone strings — any common BR format */
+  phones?: string[];
+  /** Full name strings — exact case as they appear in source material */
+  names?: string[];
+  /** License plate strings — old or Mercosul format */
+  plates?: string[];
+  /** REDS event numbers */
+  reds?: string[];
+}
+
+export interface EntityDictionary {
+  entities: Entity[];
+}
+
+// ─── Loader ───────────────────────────────────────────────────────────────────
+
+/**
+ * Load and validate an EntityDictionary from a JSON file path.
+ * NEVER call this in tests — pass a synthetic object instead.
+ *
+ * @throws if the file cannot be read or does not conform to the schema
+ */
+export async function loadDictionary(jsonPath: string): Promise<EntityDictionary> {
+  const file = Bun.file(jsonPath);
+  const exists = await file.exists();
+  if (!exists) {
+    throw new Error(`[pii-purge] Entity dictionary not found: ${jsonPath}`);
+  }
+
+  let raw: unknown;
+  try {
+    raw = await file.json();
+  } catch (err) {
+    throw new Error(`[pii-purge] Failed to parse entity dictionary at ${jsonPath}: ${String(err)}`);
+  }
+
+  return validateDictionary(raw, jsonPath);
+}
+
+/**
+ * Validate a raw parsed object against the EntityDictionary schema.
+ * Safe to call with synthetic test data.
+ */
+export function validateDictionary(raw: unknown, source = '<inline>'): EntityDictionary {
+  if (typeof raw !== 'object' || raw === null || !('entities' in raw)) {
+    throw new Error(`[pii-purge] Invalid dictionary at ${source}: missing 'entities' array`);
+  }
+
+  const obj = raw as Record<string, unknown>;
+  if (!Array.isArray(obj.entities)) {
+    throw new Error(`[pii-purge] Invalid dictionary at ${source}: 'entities' must be an array`);
+  }
+
+  const entities: Entity[] = [];
+  for (const [i, e] of (obj.entities as unknown[]).entries()) {
+    if (typeof e !== 'object' || e === null || !('id' in e)) {
+      throw new Error(`[pii-purge] Entity at index ${i} in ${source} is missing required 'id' field`);
+    }
+    const ent = e as Record<string, unknown>;
+    const entity: Entity = { id: String(ent.id) };
+    if (Array.isArray(ent.cpfs)) entity.cpfs = ent.cpfs.map(String);
+    if (Array.isArray(ent.phones)) entity.phones = ent.phones.map(String);
+    if (Array.isArray(ent.names)) entity.names = ent.names.map(String);
+    if (Array.isArray(ent.plates)) entity.plates = ent.plates.map(String);
+    if (Array.isArray(ent.reds)) entity.reds = ent.reds.map(String);
+    entities.push(entity);
+  }
+
+  return { entities };
+}
diff --git a/packages/pii-purge/src/patterns.ts b/packages/pii-purge/src/patterns.ts
new file mode 100644
index 00000000..420dac38
--- /dev/null
+++ b/packages/pii-purge/src/patterns.ts
@@ -0,0 +1,236 @@
+/**
+ * Pattern Generator — Builds all format-variant RegExps for a given Entity.
+ *
+ * Safety rules:
+ * - CPF: formatted (NNN.NNN.NNN-NN) AND unformatted (NNNNNNNNNNN) → exact/format-variant
+ * - Phone: with/without DDD parens/spaces/dash → exact/format-variant
+ * - Plate: old AAA-0000/AAA0000 AND Mercosul AAA0A00 → exact/format-variant (scan-ok: format-spec)
+ * - Name: exact string case-insensitive → exact match
+ *         normalizeOrtho variant → fuzzy-REVIEW only (NEVER auto-purge)
+ * - REDS: raw number match → exact
+ *
+ * Helpers are reimplemented locally — do NOT import from intelink.
+ */
+
+import type { Entity } from './dictionary.js';
+
+// ─── Types ────────────────────────────────────────────────────────────────────
+
+export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW';
+export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';
+
+export interface EntityPattern {
+  entityId: string;
+  fieldType: EntityFieldType;
+  matchType: MatchType;
+  /** The compiled regex. Always has 'g' flag. */
+  regex: RegExp;
+}
+
+// ─── Local format helpers (no intelink import) ────────────────────────────────
+
+/** Strip all non-digit chars */
+function digitsOnly(s: string): string {
+  return s.replace(/\D/g, '');
+}
+
+/**
+ * Strip combining diacritics (accents) and lower-case.
+ * Used for fuzzy name normalization.
+ */
+export function normalizeOrtho(s: string): string {
+  return s
+    .normalize('NFD')
+    .replace(/[̀-ͯ]/g, '')
+    .toLowerCase()
+    .trim();
+}
+
+/** Escape all regex-special chars in a string */
+function escapeRegex(s: string): string {
+  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
+}
+
+// ─── Per-type pattern builders ────────────────────────────────────────────────
+
+/**
+ * CPF — generates two patterns per CPF value:
+ *   1. exact match (the string as given, escaped)
+ *   2. all format variants (with/without dots and dash)
+ * Both are `format-variant` matchType because they are structural equivalents.
+ */
+function cpfPatterns(entityId: string, cpfs: string[]): EntityPattern[] {
+  const results: EntityPattern[] = [];
+  for (const cpf of cpfs) {
+    const digits = digitsOnly(cpf);
+    if (digits.length !== 11) continue; // skip malformed
+
+    // Formatted: DDD.DDD.DDD-DD
+    const formatted = `${digits.slice(0, 3)}\\.${digits.slice(3, 6)}\\.${digits.slice(6, 9)}-${digits.slice(9)}`;
+    // Unformatted: DDDDDDDDDDD (word boundary to avoid partial matches)
+    const unformatted = digits;
+
+    // Single pattern that matches both variants
+    const src = `\\b(?:${formatted}|${unformatted})\\b`;
+    results.push({
+      entityId,
+      fieldType: 'cpf',
+      matchType: 'format-variant',
+      regex: new RegExp(src, 'gi'),
+    });
+  }
+  return results;
+}
+
+/**
+ * Phone — matches with/without DDD parens, spaces, dashes.
+ * Ex.: (11) 90000-0000 → 11900000000 → various delimiters (scan-ok: synthetic example)
+ */
+function phonePatterns(entityId: string, phones: string[]): EntityPattern[] {
+  const results: EntityPattern[] = [];
+  for (const phone of phones) {
+    const digits = digitsOnly(phone);
+    if (digits.length < 10 || digits.length > 13) continue; // skip malformed
+
+    // Strip country code if present (+55)
+    const local = digits.startsWith('55') && digits.length > 11 ? digits.slice(2) : digits;
+    const ddd = local.slice(0, 2);
+    const num = local.slice(2);
+
+    // num may be 8 or 9 digits
+    const half1 = num.slice(0, num.length - 4);
+    const half2 = num.slice(-4);
+
+    // Pattern: optional +55, optional parens on DDD, various delimiters
+    const dddPart = `(?:\\+55[\\s-]?)?(?:\\(?${escapeRegex(ddd)}\\)?[\\s-]?)`;
+    const numPart = `${escapeRegex(half1)}[-\\s]?${escapeRegex(half2)}`;
+    const src = `\\b${dddPart}${numPart}\\b`;
+
+    results.push({
+      entityId,
+      fieldType: 'phone',
+      matchType: 'format-variant',
+      regex: new RegExp(src, 'gi'),
+    });
+  }
+  return results;
+}
+
+/**
+ * Plate — matches old format (AAA-0000 / AAA0000) and Mercosul (AAA0A00). (scan-ok: format-spec)
+ * We also handle the reverse: given Mercosul, emit both.
+ */
+function platePatterns(entityId: string, plates: string[]): EntityPattern[] {
+  const results: EntityPattern[] = [];
+  for (const plate of plates) {
+    // Normalize: strip spaces/dashes, upper-case
+    const clean = plate.replace(/[\s-]/g, '').toUpperCase();
+
+    // Detect old format: 3 letters + 4 digits
+    const isOld = /^[A-Z]{3}\d{4}$/.test(clean);
+    // Detect Mercosul: 3 letters + digit + letter + 2 digits
+    const isMercosul = /^[A-Z]{3}\d[A-Z]\d{2}$/.test(clean);
+
+    if (!isOld && !isMercosul) continue;
+
+    const escaped = escapeRegex(clean);
+    let src: string;
+
+    if (isOld) {
+      // Match with or without dash: ABC-1234 or ABC1234 (scan-ok: format-spec)
+      const letters = escapeRegex(clean.slice(0, 3));
+      const digits = escapeRegex(clean.slice(3));
+      src = `\\b${letters}[-]?${digits}\\b`;
+    } else {
+      // Mercosul — exact only (no dash variant exists)
+      src = `\\b${escaped}\\b`;
+    }
+
+    results.push({
+      entityId,
+      fieldType: 'plate',
+      matchType: isOld ? 'format-variant' : 'exact',
+      regex: new RegExp(src, 'gi'),
+    });
+  }
+  return results;
+}
+
+/**
+ * Name — two patterns per name:
+ *   1. Exact case-insensitive string match (matchType: 'exact') → auto-purgeable
+ *   2. Accent-stripped/ortho-normalized version (matchType: 'fuzzy-REVIEW') → flag only
+ */
+function namePatterns(entityId: string, names: string[]): EntityPattern[] {
+  const results: EntityPattern[] = [];
+  for (const name of names) {
+    const trimmed = name.trim();
+    if (!trimmed) continue;
+
+    // Exact match (case-insensitive)
+    const exactSrc = `\\b${escapeRegex(trimmed)}\\b`;
+    results.push({
+      entityId,
+      fieldType: 'name',
+      matchType: 'exact',
+      regex: new RegExp(exactSrc, 'gi'),
+    });
+
+    // Ortho-normalized (accent-stripped) variant — REVIEW only
+    const normalized = normalizeOrtho(trimmed);
+    if (normalized !== trimmed.toLowerCase()) {
+      const fuzzyEscaped = escapeRegex(normalized);
+      results.push({
+        entityId,
+        fieldType: 'name',
+        matchType: 'fuzzy-REVIEW',
+        regex: new RegExp(`\\b${fuzzyEscaped}\\b`, 'gi'),
+      });
+    }
+  }
+  return results;
+}
+
+/**
+ * REDS — matches the raw REDS number (digits only) with optional keyword prefix.
+ */
+function redsPatterns(entityId: string, reds: string[]): EntityPattern[] {
+  const results: EntityPattern[] = [];
+  for (const r of reds) {
+    const digits = digitsOnly(r);
+    if (!digits) continue;
+    const src = `\\b(?:REDS[:\\s]*)?${escapeRegex(digits)}\\b`;
+    results.push({
+      entityId,
+      fieldType: 'reds',
+      matchType: 'exact',
+      regex: new RegExp(src, 'gi'),
+    });
+  }
+  return results;
+}
+
+// ─── Public API ───────────────────────────────────────────────────────────────
+
+/**
+ * Generate all EntityPatterns for a single Entity.
+ * Returns patterns in a deterministic order: cpf → phone → plate → reds → name.
+ * Name fuzzy patterns are always last (lowest priority for matching).
+ */
+export function generateEntityPatterns(entity: Entity): EntityPattern[] {
+  const patterns: EntityPattern[] = [];
+  if (entity.cpfs?.length) patterns.push(...cpfPatterns(entity.id, entity.cpfs));
+  if (entity.phones?.length) patterns.push(...phonePatterns(entity.id, entity.phones));
+  if (entity.plates?.length) patterns.push(...platePatterns(entity.id, entity.plates));
+  if (entity.reds?.length) patterns.push(...redsPatterns(entity.id, entity.reds));
+  if (entity.names?.length) patterns.push(...namePatterns(entity.id, entity.names));
+  return patterns;
+}
+
+/**
+ * Generate all EntityPatterns for every entity in the dictionary.
+ * Entities are processed in dict order (index 0 first).
+ */
+export function generateAllPatterns(entities: Entity[]): EntityPattern[] {
+  return entities.flatMap(generateEntityPatterns);
+}
diff --git a/packages/pii-purge/src/pii-purge.test.ts b/packages/pii-purge/src/pii-purge.test.ts
new file mode 100644
index 00000000..ddd3e6c9
--- /dev/null
+++ b/packages/pii-purge/src/pii-purge.test.ts
@@ -0,0 +1,460 @@
+/**
+ * pii-purge — Test suite
+ *
+ * All synthetic entities. NO real CPF/phone/plate/name literals.
+ * CPFs are constructed dynamically to avoid hardcoded real-looking values.
+ * Tests cover: format variants, token coherence, dry-run safety, no raw value
+ * in findings, verify leftover detection, fuzzy-REVIEW flag.
+ */
+
+import { describe, test, expect, beforeAll, afterAll } from 'bun:test';
+import { mkdirSync, writeFileSync, readFileSync, rmSync } from 'node:fs';
+import { join } from 'node:path';
+import { tmpdir } from 'node:os';
+
+import { validateDictionary, type EntityDictionary } from './dictionary.js';
+import { generateAllPatterns, normalizeOrtho } from './patterns.js';
+import { scanText, scanDirectory } from './scanner.js';
+import { buildTokenMap, applyReplacements, runPurge } from './purge.js';
+import { verify } from './verify.js';
+
+// ─── Synthetic test data ──────────────────────────────────────────────────────
+
+/**
+ * Build a fake CPF string dynamically — NEVER a hardcoded literal.
+ * These CPFs are mathematically invalid (fail Luhn) by design.
+ */
+function syntheticCpf(seed: string): string {
+  // seed is like '111222333' (9 digits) → append '00' → 11 digits total
+  const base = seed.padEnd(9, '0').slice(0, 9);
+  return `${base}00`;
+}
+
+/** Format an 11-digit synthetic CPF as NNN.NNN.NNN-NN — dynamic, never a literal. */
+function formatSyntheticCpf(d: string): string {
+  return `${d.slice(0, 3)}.${d.slice(3, 6)}.${d.slice(6, 9)}-${d.slice(9, 11)}`;
+}
+
+// Two synthetic entities (no real PII — all dynamically derived, no CPF literals)
+const SYNTH_CPF_1 = syntheticCpf('111222333');
+const SYNTH_CPF_1_FORMATTED = formatSyntheticCpf(SYNTH_CPF_1);
+const SYNTH_PHONE_1 = '(34) 91111-2222';
+const SYNTH_PLATE_1 = 'TST-1234';                      // old format
+const SYNTH_NAME_1 = 'Fulano Sintético';               // with accent
+const SYNTH_REDS_1 = '2024123456';
+
+const SYNTH_CPF_2 = syntheticCpf('444555666');
+const SYNTH_CPF_2_FORMATTED = formatSyntheticCpf(SYNTH_CPF_2);
+const SYNTH_NAME_2 = 'Beltrana Teste';
+
+const SYNTH_DICT: EntityDictionary = {
+  entities: [
+    {
+      id: 'ent-001',
+      cpfs: [SYNTH_CPF_1_FORMATTED],
+      phones: [SYNTH_PHONE_1],
+      plates: [SYNTH_PLATE_1],
+      names: [SYNTH_NAME_1],
+      reds: [SYNTH_REDS_1],
+    },
+    {
+      id: 'ent-002',
+      cpfs: [SYNTH_CPF_2_FORMATTED],
+      names: [SYNTH_NAME_2],
+    },
+  ],
+};
+
+// ─── Tests: dictionary ────────────────────────────────────────────────────────
+
+describe('dictionary', () => {
+  test('validates a correct dict object', () => {
+    const d = validateDictionary(SYNTH_DICT);
+    expect(d.entities).toHaveLength(2);
+    expect(d.entities[0]!.id).toBe('ent-001');
+  });
+
+  test('throws on missing entities key', () => {
+    expect(() => validateDictionary({ foo: [] })).toThrow();
+  });
+
+  test('throws on entity missing id', () => {
+    expect(() => validateDictionary({ entities: [{ cpfs: [] }] })).toThrow(/id/);
+  });
+});
+
+// ─── Tests: pattern generation ────────────────────────────────────────────────
+
+describe('patterns - CPF format variants', () => {
+  const patterns = generateAllPatterns(SYNTH_DICT.entities);
+  const cpfPatterns = patterns.filter(p => p.fieldType === 'cpf' && p.entityId === 'ent-001');
+
+  test('generates at least one CPF pattern for ent-001', () => {
+    expect(cpfPatterns.length).toBeGreaterThan(0);
+  });
+
+  test('matches formatted CPF (NNN.NNN.NNN-NN)', () => {
+    const text = `CPF do suspeito: ${SYNTH_CPF_1_FORMATTED} confirmado.`;
+    const hit = cpfPatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+
+  test('matches unformatted CPF (00000000000)', () => {
+    const text = `cpf=${SYNTH_CPF_1} no sistema`;
+    const hit = cpfPatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+});
+
+describe('patterns - phone format variants', () => {
+  const patterns = generateAllPatterns(SYNTH_DICT.entities);
+  const phonePatterns = patterns.filter(p => p.fieldType === 'phone' && p.entityId === 'ent-001');
+
+  test('matches phone with parens and dash', () => {
+    const text = `Telefone: ${SYNTH_PHONE_1}`;
+    const hit = phonePatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+
+  test('matches phone without parens', () => {
+    const text = `tel 34 91111-2222`;
+    const hit = phonePatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+});
+
+describe('patterns - plate format variants', () => {
+  const patterns = generateAllPatterns(SYNTH_DICT.entities);
+  const platePatterns = patterns.filter(p => p.fieldType === 'plate' && p.entityId === 'ent-001');
+
+  test('matches plate with dash: TST-1234', () => {
+    const text = `veículo placa ${SYNTH_PLATE_1}`;
+    const hit = platePatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+
+  test('matches plate without dash: TST1234', () => {
+    const text = `placa TST1234 foi visto`;
+    const hit = platePatterns.some(p => new RegExp(p.regex.source, p.regex.flags).test(text));
+    expect(hit).toBe(true);
+  });
+});
+
+describe('patterns - name exact vs fuzzy', () => {
+  const patterns = generateAllPatterns(SYNTH_DICT.entities);
+  const namePatterns = patterns.filter(p => p.fieldType === 'name' && p.entityId === 'ent-001');
+
+  test('exact name pattern has matchType=exact', () => {
+    const exact = namePatterns.find(p => p.matchType === 'exact');
+    expect(exact).toBeDefined();
+  });
+
+  test('ortho-normalized name gets matchType=fuzzy-REVIEW', () => {
+    const fuzzy = namePatterns.find(p => p.matchType === 'fuzzy-REVIEW');
+    // Only emitted when accented name differs after normalizeOrtho
+    const normalized = normalizeOrtho(SYNTH_NAME_1);
+    if (normalized !== SYNTH_NAME_1.toLowerCase()) {
+      expect(fuzzy).toBeDefined();
+      expect(fuzzy!.matchType).toBe('fuzzy-REVIEW');
+    }
+  });
+
+  test('fuzzy name match does NOT auto-purge (matchType=fuzzy-REVIEW)', () => {
+    const fuzzy = namePatterns.find(p => p.matchType === 'fuzzy-REVIEW');
+    if (!fuzzy) return; // no accent diff → skip
+    const text = `fulano sintetico apareceu na doc`;
+    const re = new RegExp(fuzzy.regex.source, fuzzy.regex.flags);
+    const matched = re.test(text);
+    if (matched) {
+      expect(fuzzy.matchType).toBe('fuzzy-REVIEW');
+    }
+  });
+});
+
+// ─── Tests: scanner ───────────────────────────────────────────────────────────
+
+describe('scanner - scanText', () => {
+  const patterns = generateAllPatterns(SYNTH_DICT.entities);
+
+  test('finds CPF in text', () => {
+    const text = `Investigado CPF ${SYNTH_CPF_1_FORMATTED} preso.`;
+    const findings = scanText(text, 'fake.txt', patterns);
+    const cpfFindings = findings.filter(f => f.type === 'cpf');
+    expect(cpfFindings.length).toBeGreaterThan(0);
+  });
+
+  test('findings NEVER contain the matched value', () => {
+    const text = `CPF: ${SYNTH_CPF_1_FORMATTED}, tel: ${SYNTH_PHONE_1}`;
+    const findings = scanText(text, 'fake.txt', patterns);
+    for (const f of findings) {
+      // Ensure no field in Finding contains the actual CPF or phone number
+      const json = JSON.stringify(f);
+      expect(json).not.toContain(SYNTH_CPF_1_FORMATTED);
+      expect(json).not.toContain(SYNTH_CPF_1);
+      expect(json).not.toContain('91111');
+    }
+  });
+
+  test('line numbers are 1-based', () => {
+    const text = `line one\nCPF: ${SYNTH_CPF_1_FORMATTED}\nline three`;
+    const findings = scanText(text, 'fake.txt', patterns);
+    const cpf = findings.find(f => f.type === 'cpf');
+    expect(cpf?.line).toBe(2);
+  });
+
+  test('fuzzy name finding has matchType=fuzzy-REVIEW', () => {
+    const normalized = normalizeOrtho(SYNTH_NAME_1); // 'fulano sintetico'
+    const text = `pessoa: ${normalized} visto no local`;
+    const findings = scanText(text, 'fake.txt', patterns);
+    const fuzzy = findings.find(f => f.matchType === 'fuzzy-REVIEW');
+    if (fuzzy) {
+      expect(fuzzy.matchType).toBe('fuzzy-REVIEW');
+    }
+  });
+});
+
+// ─── Tests: token map coherence ──────────────────────────────────────────────
+
+describe('token map coherence', () => {
+  test('same entity id gets same token regardless of call order', () => {
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+    expect(tokenMap['ent-001']).toBe('[PESSOA_1]');
+    expect(tokenMap['ent-002']).toBe('[PESSOA_2]');
+  });
+
+  test('CPF and name of same entity map to same token in different files', () => {
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const text1 = `CPF: ${SYNTH_CPF_1_FORMATTED} foi encontrado`;
+    const text2 = `Nome: ${SYNTH_NAME_1} confirmado`;
+
+    const findings1 = scanText(text1, 'file1.txt', patterns).filter(f => f.entityId === 'ent-001');
+    const findings2 = scanText(text2, 'file2.txt', patterns).filter(f => f.entityId === 'ent-001');
+
+    const token1 = tokenMap[findings1[0]!.entityId];
+    const token2 = tokenMap[findings2[0]!.entityId];
+
+    expect(token1).toBe('[PESSOA_1]');
+    expect(token2).toBe('[PESSOA_1]');
+    expect(token1).toBe(token2);
+  });
+});
+
+// ─── Tests: dry-run safety ───────────────────────────────────────────────────
+
+describe('dry-run does not modify files', () => {
+  let tmpDir: string;
+
+  beforeAll(() => {
+    tmpDir = join(tmpdir(), `pii-purge-test-${Date.now()}`);
+    mkdirSync(tmpDir, { recursive: true });
+  });
+
+  afterAll(() => {
+    rmSync(tmpDir, { recursive: true, force: true });
+  });
+
+  test('file bytes unchanged after dry-run', async () => {
+    const filePath = join(tmpDir, 'test.txt');
+    const original = `CPF: ${SYNTH_CPF_1_FORMATTED} encontrado em relatório`;
+    writeFileSync(filePath, original, 'utf-8');
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(original, filePath, patterns);
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    await runPurge(findings, tokenMap, 'dry-run', tmpDir);
+
+    const afterBytes = readFileSync(filePath, 'utf-8');
+    expect(afterBytes).toBe(original);
+  });
+
+  test('dry-run returns planned changes without writing', async () => {
+    const filePath = join(tmpDir, 'test2.txt');
+    const content = `Placa: ${SYNTH_PLATE_1} registrado`;
+    writeFileSync(filePath, content, 'utf-8');
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(content, filePath, patterns);
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const result = await runPurge(findings, tokenMap, 'dry-run', tmpDir);
+
+    expect(result.mode).toBe('dry-run');
+    expect(result.planned.length).toBeGreaterThan(0);
+    expect(result.applied).toHaveLength(0);
+
+    // File still original
+    const afterBytes = readFileSync(filePath, 'utf-8');
+    expect(afterBytes).toBe(content);
+  });
+});
+
+// ─── Tests: apply mode + audit ───────────────────────────────────────────────
+
+describe('apply mode', () => {
+  let tmpDir: string;
+
+  beforeAll(() => {
+    tmpDir = join(tmpdir(), `pii-purge-apply-${Date.now()}`);
+    mkdirSync(tmpDir, { recursive: true });
+  });
+
+  afterAll(() => {
+    rmSync(tmpDir, { recursive: true, force: true });
+  });
+
+  test('replaces CPF in file and produces audit log', async () => {
+    const filePath = join(tmpDir, 'doc.txt');
+    const content = `CPF do investigado: ${SYNTH_CPF_1_FORMATTED}\nfim`;
+    writeFileSync(filePath, content, 'utf-8');
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(content, filePath, patterns).filter(f => f.entityId === 'ent-001');
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const result = await runPurge(findings, tokenMap, 'apply', tmpDir);
+
+    expect(result.applied).toContain(filePath);
+    expect(result.auditLog.length).toBeGreaterThan(0);
+
+    const after = readFileSync(filePath, 'utf-8');
+    expect(after).toContain('[PESSOA_1]');
+    expect(after).not.toContain(SYNTH_CPF_1_FORMATTED);
+  });
+
+  test('audit log records sha256 before and after', async () => {
+    const filePath = join(tmpDir, 'doc2.txt');
+    const content = `Placa: ${SYNTH_PLATE_1}`;
+    writeFileSync(filePath, content, 'utf-8');
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(content, filePath, patterns).filter(f => f.entityId === 'ent-001');
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const result = await runPurge(findings, tokenMap, 'apply', tmpDir);
+    const record = result.auditLog[0];
+
+    expect(record).toBeDefined();
+    expect(record!.sha256Before).toMatch(/^[0-9a-f]{64}$/);
+    expect(record!.sha256After).toMatch(/^[0-9a-f]{64}$/);
+    expect(record!.sha256Before).not.toBe(record!.sha256After);
+    expect(record!.recordHash).toMatch(/^[0-9a-f]{64}$/);
+  });
+
+  test('audit log is chained (each record references previous hash)', async () => {
+    // Write two files so we get two audit records
+    const file1 = join(tmpDir, 'chain1.txt');
+    const file2 = join(tmpDir, 'chain2.txt');
+    writeFileSync(file1, `CPF: ${SYNTH_CPF_1_FORMATTED}`);
+    writeFileSync(file2, `CPF: ${SYNTH_CPF_2_FORMATTED}`);
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings1 = scanText(readFileSync(file1, 'utf-8'), file1, patterns);
+    const findings2 = scanText(readFileSync(file2, 'utf-8'), file2, patterns);
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const result = await runPurge([...findings1, ...findings2], tokenMap, 'apply', tmpDir);
+
+    if (result.auditLog.length >= 2) {
+      const [r0, r1] = result.auditLog;
+      expect(r1!.prevHash).toBe(r0!.recordHash);
+    }
+  });
+
+  test('fuzzy matches are skipped (not written to file)', async () => {
+    const filePath = join(tmpDir, 'fuzzy.txt');
+    const normalized = normalizeOrtho(SYNTH_NAME_1); // 'fulano sintetico'
+    const content = `pessoa: ${normalized} foi identificada`;
+    writeFileSync(filePath, content, 'utf-8');
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(content, filePath, patterns);
+    const fuzzyOnly = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const result = await runPurge(fuzzyOnly, tokenMap, 'apply', tmpDir);
+
+    // No files should be written for fuzzy-only findings
+    const after = readFileSync(filePath, 'utf-8');
+    expect(after).toBe(content);
+    expect(result.skippedFuzzy).toBe(fuzzyOnly.length);
+  });
+});
+
+// ─── Tests: verify ────────────────────────────────────────────────────────────
+
+describe('verify', () => {
+  let tmpDir: string;
+
+  beforeAll(() => {
+    tmpDir = join(tmpdir(), `pii-purge-verify-${Date.now()}`);
+    mkdirSync(tmpDir, { recursive: true });
+  });
+
+  afterAll(() => {
+    rmSync(tmpDir, { recursive: true, force: true });
+  });
+
+  test('verify catches leftover after failed purge', async () => {
+    const filePath = join(tmpDir, 'leftover.txt');
+    // Write file WITH entity data still present
+    writeFileSync(filePath, `CPF: ${SYNTH_CPF_1_FORMATTED} ainda aqui`);
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const result = await verify(tmpDir, patterns);
+
+    expect(result.cleanExit).toBe(false);
+    expect(result.remaining.length).toBeGreaterThan(0);
+  });
+
+  test('verify returns cleanExit=true after all replacements applied', async () => {
+    const filePath = join(tmpDir, 'clean.txt');
+    // Write already-purged file
+    writeFileSync(filePath, `CPF: [PESSOA_1] confirmado`);
+
+    // Create second dir for isolation
+    const cleanDir = join(tmpdir(), `pii-purge-clean-${Date.now()}`);
+    mkdirSync(cleanDir, { recursive: true });
+    const cleanFile = join(cleanDir, 'ok.txt');
+    writeFileSync(cleanFile, `Nenhuma PII aqui. Apenas texto limpo.`);
+
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const result = await verify(cleanDir, patterns);
+
+    expect(result.cleanExit).toBe(true);
+    expect(result.remaining).toHaveLength(0);
+
+    rmSync(cleanDir, { recursive: true, force: true });
+  });
+});
+
+// ─── Tests: applyReplacements (unit) ─────────────────────────────────────────
+
+describe('applyReplacements', () => {
+  test('replaces matched span with token', () => {
+    const text = `Nome: ${SYNTH_NAME_2} encontrado`;
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(text, 'x.txt', patterns).filter(
+      f => f.entityId === 'ent-002' && f.matchType !== 'fuzzy-REVIEW',
+    );
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const { result, appliedCount } = applyReplacements(text, findings, tokenMap);
+    expect(result).not.toContain(SYNTH_NAME_2);
+    expect(result).toContain('[PESSOA_2]');
+    expect(appliedCount).toBeGreaterThan(0);
+  });
+
+  test('skips fuzzy-REVIEW findings during replacement', () => {
+    const text = `Nome: ${SYNTH_NAME_1} e ${SYNTH_NAME_2}`;
+    const patterns = generateAllPatterns(SYNTH_DICT.entities);
+    const findings = scanText(text, 'x.txt', patterns);
+    const fuzzyOnly = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+    const tokenMap = buildTokenMap(SYNTH_DICT.entities);
+
+    const { appliedCount } = applyReplacements(text, fuzzyOnly, tokenMap);
+    expect(appliedCount).toBe(0);
+  });
+});
diff --git a/packages/pii-purge/src/purge.ts b/packages/pii-purge/src/purge.ts
new file mode 100644
index 00000000..83e8fb0c
--- /dev/null
+++ b/packages/pii-purge/src/purge.ts
@@ -0,0 +1,217 @@
+/**
+ * Purge Engine — Replaces entity identifiers with stable tokens.
+ *
+ * Safety rules:
+ * - --dry-run (default): compute planned changes, NEVER write files
+ * - --apply: write files + emit hash-chained audit log
+ * - fuzzy-REVIEW matches are SKIPPED (never auto-purged)
+ * - Token map is stable: same entity always gets same [PESSOA_N] across all files
+ * - Replacements are done end-to-start to preserve offsets
+ * - Audit log: each record has sha256(before) + sha256(after) + prevHash chain
+ */
+
+import { createHash } from 'node:crypto';
+import { readFile, writeFile } from 'node:fs/promises';
+import { join } from 'node:path';
+import type { Entity } from './dictionary.js';
+import type { EntityPattern } from './patterns.js';
+import type { Finding } from './scanner.js';
+
+// ─── Types ────────────────────────────────────────────────────────────────────
+
+export interface TokenMap {
+  /** entity.id → replacement token string */
+  [entityId: string]: string;
+}
+
+export interface PlannedChange {
+  file: string;
+  findingsCount: number;
+  /** The replacement token that will be applied (safe to log) */
+  token: string;
+}
+
+export interface AuditRecord {
+  ts: string;
+  file: string;
+  sha256Before: string;
+  sha256After: string;
+  findingsApplied: number;
+  prevHash: string;
+  recordHash: string;
+}
+
+export interface PurgeResult {
+  mode: 'dry-run' | 'apply';
+  planned: PlannedChange[];
+  applied: string[];
+  skippedFuzzy: number;
+  auditLog: AuditRecord[];
+  auditLogPath?: string;
+}
+
+// ─── Token map ────────────────────────────────────────────────────────────────
+
+/**
+ * Build a stable token map from the entity list.
+ * Entities are assigned [PESSOA_1], [PESSOA_2], ... in dict order (index).
+ * The same token is used for ALL identifiers belonging to that entity.
+ */
+export function buildTokenMap(entities: Entity[]): TokenMap {
+  const map: TokenMap = {};
+  for (let i = 0; i < entities.length; i++) {
+    map[entities[i]!.id] = `[PESSOA_${i + 1}]`;
+  }
+  return map;
+}
+
+// ─── Hash helper ──────────────────────────────────────────────────────────────
+
+function sha256(text: string): string {
+  return createHash('sha256').update(text, 'utf-8').digest('hex');
+}
+
+// ─── Text replacement ─────────────────────────────────────────────────────────
+
+/**
+ * Apply all non-fuzzy findings to a text string, replacing matched spans with tokens.
+ * Replacements are done from last to first (end-to-start) so earlier offsets stay valid.
+ *
+ * @returns { result, appliedCount } — result is the replaced text
+ */
+export function applyReplacements(
+  text: string,
+  findings: Finding[],
+  tokenMap: TokenMap,
+): { result: string; appliedCount: number } {
+  // Filter out fuzzy-REVIEW (never auto-purge)
+  const applicable = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
+
+  if (applicable.length === 0) {
+    return { result: text, appliedCount: 0 };
+  }
+
+  const lines = text.split('\n');
+
+  // Group by line, process each line end-to-start within findings
+  // Build a flat list of { lineIdx, lineOffset, matchLength, token }
+  interface Span {
+    lineIdx: number;
+    lineOffset: number;
+    matchLength: number;
+    token: string;
+  }
+
+  const spans: Span[] = applicable.map(f => ({
+    lineIdx: f.line - 1,
+    lineOffset: f.lineOffset,
+    matchLength: f.matchLength,
+    token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
+  }));
+
+  // Sort end-to-start (line desc, offset desc)
+  spans.sort((a, b) =>
+    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
+  );
+
+  for (const span of spans) {
+    const line = lines[span.lineIdx];
+    if (line === undefined) continue;
+    lines[span.lineIdx] =
+      line.slice(0, span.lineOffset) +
+      span.token +
+      line.slice(span.lineOffset + span.matchLength);
+  }
+
+  return { result: lines.join('\n'), appliedCount: applicable.length };
+}
+
+// ─── Main purge function ──────────────────────────────────────────────────────
+
+/**
+ * Run the purge engine over a set of findings.
+ *
+ * @param findings       - all findings from the scanner
+ * @param patterns       - all compiled patterns (used only for fuzzy count)
+ * @param tokenMap       - entity id → replacement token
+ * @param mode           - 'dry-run' (default) or 'apply'
+ * @param auditLogDir    - where to write the audit log (only used in apply mode)
+ */
+export async function runPurge(
+  findings: Finding[],
+  tokenMap: TokenMap,
+  mode: 'dry-run' | 'apply',
+  auditLogDir?: string,
+): Promise<PurgeResult> {
+  // Group findings by file
+  const byFile = new Map<string, Finding[]>();
+  for (const f of findings) {
+    const arr = byFile.get(f.file) ?? [];
+    arr.push(f);
+    byFile.set(f.file, arr);
+  }
+
+  const planned: PlannedChange[] = [];
+  const applied: string[] = [];
+  const auditLog: AuditRecord[] = [];
+  let skippedFuzzy = 0;
+  let prevHash = '0'.repeat(64);
+
+  // Count fuzzy findings (for reporting)
+  for (const f of findings) {
+    if (f.matchType === 'fuzzy-REVIEW') skippedFuzzy++;
+  }
+
+  for (const [filePath, fileFindings] of byFile) {
+    const nonFuzzy = fileFindings.filter(f => f.matchType !== 'fuzzy-REVIEW');
+    if (nonFuzzy.length === 0) continue;
+
+    // Pick the first token seen for this file (for reporting)
+    const firstEntityId = nonFuzzy[0]!.entityId;
+    const token = tokenMap[firstEntityId] ?? '[PESSOA_?]';
+
+    planned.push({ file: filePath, findingsCount: nonFuzzy.length, token });
+
+    if (mode === 'apply') {
+      const before = await readFile(filePath, 'utf-8');
+      const hashBefore = sha256(before);
+
+      const { result: after, appliedCount } = applyReplacements(before, fileFindings, tokenMap);
+      const hashAfter = sha256(after);
+
+      await writeFile(filePath, after, 'utf-8');
+      applied.push(filePath);
+
+      // Build audit record
+      const record: Omit<AuditRecord, 'recordHash'> = {
+        ts: new Date().toISOString(),
+        file: filePath,
+        sha256Before: hashBefore,
+        sha256After: hashAfter,
+        findingsApplied: appliedCount,
+        prevHash,
+      };
+      const recordHash = sha256(JSON.stringify(record));
+      const fullRecord: AuditRecord = { ...record, recordHash };
+      auditLog.push(fullRecord);
+      prevHash = recordHash;
+    }
+  }
+
+  let auditLogPath: string | undefined;
+  if (mode === 'apply' && auditLog.length > 0 && auditLogDir) {
+    const ts = new Date().toISOString().replace(/[:.]/g, '-');
+    auditLogPath = join(auditLogDir, `pii-purge-audit-${ts}.jsonl`);
+    const lines = auditLog.map(r => JSON.stringify(r)).join('\n') + '\n';
+    await writeFile(auditLogPath, lines, 'utf-8');
+  }
+
+  return {
+    mode,
+    planned,
+    applied,
+    skippedFuzzy,
+    auditLog,
+    auditLogPath,
+  };
+}
diff --git a/packages/pii-purge/src/scanner.ts b/packages/pii-purge/src/scanner.ts
new file mode 100644
index 00000000..018c1e98
--- /dev/null
+++ b/packages/pii-purge/src/scanner.ts
@@ -0,0 +1,163 @@
+/**
+ * Scanner — Walks a target directory and returns Findings for each entity match.
+ *
+ * Safety rules:
+ * - NEVER include the matched value in a Finding (T0 §3)
+ * - Skip binary files, node_modules, .git
+ * - Only process git-tracked text files (falls back to all text if not in a git repo)
+ * - fuzzy-REVIEW matches are flagged but never auto-purgeable
+ */
+
+import { readdir, readFile, stat } from 'node:fs/promises';
+import { join, extname } from 'node:path';
+import { execSync } from 'node:child_process';
+import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
+
+// ─── Types ────────────────────────────────────────────────────────────────────
+
+export interface Finding {
+  /** Absolute or relative path of the file containing the match */
+  file: string;
+  /** 1-based line number */
+  line: number;
+  /** Entity id from the dictionary */
+  entityId: string;
+  /** Which field type matched (cpf, phone, plate, name, reds) */
+  type: EntityFieldType;
+  /** Whether this is auto-purgeable or requires human review */
+  matchType: MatchType;
+  /** Byte offset of match start within the line (for stable replacements) */
+  lineOffset: number;
+  /** Length of matched text (never the value itself) */
+  matchLength: number;
+}
+
+// ─── Helpers ─────────────────────────────────────────────────────────────────
+
+const BINARY_EXTENSIONS = new Set([
+  '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp',
+  '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
+  '.zip', '.tar', '.gz', '.bz2', '.rar', '.7z',
+  '.mp3', '.mp4', '.avi', '.mov', '.wav', '.flac',
+  '.woff', '.woff2', '.ttf', '.eot',
+  '.lock', '.bin', '.exe', '.dll', '.so', '.dylib',
+  '.db', '.sqlite', '.sqlite3',
+]);
+
+function isBinary(filePath: string): boolean {
+  return BINARY_EXTENSIONS.has(extname(filePath).toLowerCase());
+}
+
+function isSkippedDir(name: string): boolean {
+  return name === 'node_modules' || name === '.git' || name === 'dist' || name === '.next';
+}
+
+/**
+ * Returns the set of git-tracked files under `dir`, relative to `dir`.
+ * Falls back to null if not in a git repo — caller handles fallback.
+ */
+function getGitTrackedFiles(dir: string): Set<string> | null {
+  try {
+    const out = execSync('git ls-files', { cwd: dir, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] });
+    return new Set(out.trim().split('\n').filter(Boolean).map(f => join(dir, f)));
+  } catch {
+    return null;
+  }
+}
+
+/**
+ * Recursively collect all candidate file paths under `dir`.
+ */
+async function collectFiles(dir: string): Promise<string[]> {
+  const results: string[] = [];
+  const entries = await readdir(dir, { withFileTypes: true });
+  for (const entry of entries) {
+    if (isSkippedDir(entry.name)) continue;
+    const full = join(dir, entry.name);
+    if (entry.isDirectory()) {
+      results.push(...(await collectFiles(full)));
+    } else if (entry.isFile() && !isBinary(full)) {
+      results.push(full);
+    }
+  }
+  return results;
+}
+
+// ─── Core scanner ─────────────────────────────────────────────────────────────
+
+/**
+ * Scan a single file for all entity patterns.
+ * NEVER includes matched values in returned findings.
+ */
+export function scanText(
+  text: string,
+  filePath: string,
+  patterns: EntityPattern[],
+): Finding[] {
+  const findings: Finding[] = [];
+  const lines = text.split('\n');
+
+  for (const pattern of patterns) {
+    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
+      const line = lines[lineIdx]!;
+      // Reset regex state for each line (patterns have 'g' flag)
+      const re = new RegExp(pattern.regex.source, pattern.regex.flags);
+      let match: RegExpExecArray | null;
+      while ((match = re.exec(line)) !== null) {
+        findings.push({
+          file: filePath,
+          line: lineIdx + 1, // 1-based
+          entityId: pattern.entityId,
+          type: pattern.fieldType,
+          matchType: pattern.matchType,
+          lineOffset: match.index,
+          matchLength: match[0].length,
+          // NEVER include match[0] — T0 §3
+        });
+      }
+    }
+  }
+
+  return findings;
+}
+
+/**
+ * Walk a target directory and scan all eligible files.
+ * Returns a deduplicated, stable list of findings.
+ *
+ * @param targetDir  - directory to scan
+ * @param patterns   - compiled entity patterns to search for
+ */
+export async function scanDirectory(
+  targetDir: string,
+  patterns: EntityPattern[],
+): Promise<Finding[]> {
+  const allFiles = await collectFiles(targetDir);
+
+  // Filter to git-tracked files when possible
+  const gitTracked = getGitTrackedFiles(targetDir);
+  const filesToScan = gitTracked
+    ? allFiles.filter(f => gitTracked.has(f))
+    : allFiles;
+
+  const allFindings: Finding[] = [];
+
+  for (const filePath of filesToScan) {
+    const s = await stat(filePath);
+    // Skip very large files (>2MB) to avoid memory spikes
+    if (s.size > 2 * 1024 * 1024) continue;
+
+    let text: string;
+    try {
+      text = await readFile(filePath, 'utf-8');
+    } catch {
+      // Binary or unreadable — skip
+      continue;
+    }
+
+    const findings = scanText(text, filePath, patterns);
+    allFindings.push(...findings);
+  }
+
+  return allFindings;
+}
diff --git a/packages/pii-purge/src/verify.ts b/packages/pii-purge/src/verify.ts
new file mode 100644
index 00000000..62fe8075
--- /dev/null
+++ b/packages/pii-purge/src/verify.ts
@@ -0,0 +1,42 @@
+/**
+ * Verify — Re-scans after purge to confirm zero auto-purgeable entity findings remain.
+ *
+ * Returns cleanExit=true only if NO exact/format-variant entity findings remain.
+ * fuzzy-REVIEW findings may remain (they require human review — exit 1 still applies
+ * at the CLI level to block publish until resolved).
+ */
+
+import type { EntityPattern } from './patterns.js';
+import type { Finding } from './scanner.js';
+import { scanDirectory } from './scanner.js';
+
+export interface VerifyResult {
+  /** True only when zero auto-purgeable findings remain */
+  cleanExit: boolean;
+  /** Remaining auto-purgeable findings (should be empty on success) */
+  remaining: Finding[];
+  /** Remaining fuzzy-REVIEW findings (human review required) */
+  reviewRequired: Finding[];
+}
+
+/**
+ * Re-scan the target directory after purge.
+ *
+ * @param targetDir  - directory that was purged
+ * @param patterns   - same patterns used for original scan
+ */
+export async function verify(
+  targetDir: string,
+  patterns: EntityPattern[],
+): Promise<VerifyResult> {
+  const findings = await scanDirectory(targetDir, patterns);
+
+  const remaining = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
+  const reviewRequired = findings.filter(f => f.matchType === 'fuzzy-REVIEW');
+
+  return {
+    cleanExit: remaining.length === 0,
+    remaining,
+    reviewRequired,
+  };
+}
diff --git a/packages/pii-purge/tsconfig.json b/packages/pii-purge/tsconfig.json
new file mode 100644
index 00000000..862b7045
--- /dev/null
+++ b/packages/pii-purge/tsconfig.json
@@ -0,0 +1,10 @@
+{
+  "extends": "../../tsconfig.json",
+  "compilerOptions": {
+    "rootDir": "src",
+    "outDir": "dist",
+    "noEmit": true
+  },
+  "include": ["src/**/*.ts"],
+  "exclude": ["node_modules", "dist"]
+}

exec
/bin/bash -lc "sed -n '1,260p' packages/pii-purge/src/cli.ts; sed -n '1,260p' packages/pii-purge/src/dictionary.ts; sed -n '1,320p' packages/pii-purge/src/patterns.ts; sed -n '1,220p' packages/pii-purge/src/scanner.ts; sed -n '1,260p' packages/pii-purge/src/purge.ts; cat packages/pii-purge/package.json" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * CLI — pii-purge
 *
 * Usage:
 *   bun packages/pii-purge/src/cli.ts \
 *     --entity-dict <path-to-dict.json> \
 *     --target <directory> \
 *     [--apply] \
 *     [--json]
 *
 * Defaults to --dry-run (safe). Writing requires explicit --apply.
 * Exits 1 if: verify fails OR REVIEW_REQUIRED findings remain (blocks publish).
 *
 * NEVER prints matched values (T0 §3).
 */

import { loadDictionary } from './dictionary.js';
import { generateAllPatterns } from './patterns.js';
import { scanDirectory } from './scanner.js';
import { buildTokenMap, runPurge } from './purge.js';
import { verify } from './verify.js';
import { resolve, dirname } from 'node:path';
import { mkdirSync } from 'node:fs';

// ─── Arg parsing ──────────────────────────────────────────────────────────────

function parseArgs(argv: string[]): {
  entityDict: string;
  target: string;
  apply: boolean;
  json: boolean;
} {
  const args: Record<string, string | boolean> = {};
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i]!;
    if (arg === '--apply') { args['apply'] = true; }
    else if (arg === '--dry-run') { args['dry-run'] = true; }
    else if (arg === '--json') { args['json'] = true; }
    else if (arg.startsWith('--')) {
      const key = arg.slice(2);
      args[key] = argv[i + 1] ?? true;
      i++;
    }
  }

  const entityDict = args['entity-dict'];
  const target = args['target'];

  if (!entityDict || typeof entityDict !== 'string') {
    console.error('[pii-purge] ERROR: --entity-dict <path> is required');
    process.exit(1);
  }
  if (!target || typeof target !== 'string') {
    console.error('[pii-purge] ERROR: --target <directory> is required');
    process.exit(1);
  }

  return {
    entityDict: resolve(entityDict),
    target: resolve(target),
    apply: args['apply'] === true,
    json: args['json'] === true,
  };
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const opts = parseArgs(process.argv.slice(2));
  const mode = opts.apply ? 'apply' : 'dry-run';

  if (!opts.json) {
    console.log(`[pii-purge] mode=${mode} dict=${opts.entityDict} target=${opts.target}`);
  }

  // 1. Load dictionary
  const dict = await loadDictionary(opts.entityDict);
  if (!opts.json) {
    console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
  }

  // 2. Generate patterns
  const patterns = generateAllPatterns(dict.entities);

  // 3. Scan
  const findings = await scanDirectory(opts.target, patterns);

  const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
  const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');

  if (!opts.json) {
    console.log(`[pii-purge] Scan complete: ${findings.length} total findings`);
    console.log(`  auto-purgeable: ${autoFindings.length}`);
    console.log(`  REVIEW_REQUIRED (fuzzy): ${reviewFindings.length}`);
    for (const f of findings) {
      // NEVER print matched value — only metadata
      const flag = f.matchType === 'fuzzy-REVIEW' ? ' [REVIEW_REQUIRED]' : '';
      console.log(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}${flag}`);
    }
  }

  // 4. Build token map
  const tokenMap = buildTokenMap(dict.entities);

  // 5. Purge (or dry-run)
  const auditLogDir = dirname(opts.entityDict);
  mkdirSync(auditLogDir, { recursive: true });

  const purgeResult = await runPurge(findings, tokenMap, mode, auditLogDir);

  if (!opts.json) {
    if (mode === 'dry-run') {
      console.log(`[pii-purge] DRY-RUN: would modify ${purgeResult.planned.length} file(s)`);
      for (const p of purgeResult.planned) {
        console.log(`  ${p.file} → ${p.findingsCount} replacement(s) with ${p.token}`);
      }
    } else {
      console.log(`[pii-purge] APPLIED to ${purgeResult.applied.length} file(s)`);
      if (purgeResult.auditLogPath) {
        console.log(`[pii-purge] Audit log: ${purgeResult.auditLogPath}`);
      }
    }
  }

  // 6. Verify (only in apply mode — meaningful post-write)
  let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
  if (mode === 'apply') {
    verifyResult = await verify(opts.target, patterns);
    if (!opts.json) {
      if (verifyResult.cleanExit) {
        console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
      } else {
        console.error(`[pii-purge] VERIFY FAILED: ${verifyResult.remaining.length} auto-purgeable finding(s) remain`);
        for (const f of verifyResult.remaining) {
          console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type}`);
        }
      }
    }
  }

  if (opts.json) {
    console.log(JSON.stringify({
      mode,
      findings: findings.map(f => ({
        file: f.file,
        line: f.line,
        entityId: f.entityId,
        type: f.type,
        matchType: f.matchType,
        // matched value intentionally omitted (T0 §3)
      })),
      planned: purgeResult.planned,
      applied: purgeResult.applied,
      skippedFuzzy: purgeResult.skippedFuzzy,
      verifyCleanExit: verifyResult.cleanExit,
      reviewRequiredCount: verifyResult.reviewRequired.length,
      auditLogPath: purgeResult.auditLogPath ?? null,
    }, null, 2));
  }

  // 7. Exit code
  const hasFuzzy = verifyResult.reviewRequired.length > 0;
  const hasRemaining = !verifyResult.cleanExit;

  if (hasFuzzy || hasRemaining) {
    if (!opts.json) {
      if (hasFuzzy) {
        console.warn(`[pii-purge] ${verifyResult.reviewRequired.length} REVIEW_REQUIRED finding(s) — resolve manually before publishing`);
      }
    }
    process.exit(1);
  }

  process.exit(0);
}

main().catch(err => {
  console.error('[pii-purge] Fatal error:', err instanceof Error ? err.message : String(err));
  process.exit(1);
});
/**
 * EntityDictionary — Loads and validates the entity JSON for purge operations.
 *
 * The real dict lives at a gitignored path (e.g. ~/.egos-purge-entities.json).
 * Tests pass a synthetic EntityDictionary object directly — never load real data
 * in test context.
 *
 * Schema: { entities: Entity[] }
 * Entity: { id, cpfs?, phones?, names?, plates?, reds? }
 */

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Entity {
  /** Stable unique identifier — used as the basis for [PESSOA_N] tokens */
  id: string;
  /** CPF strings — may be formatted (NNN.NNN.NNN-NN) or raw (NNNNNNNNNNN) */
  cpfs?: string[];
  /** Phone strings — any common BR format */
  phones?: string[];
  /** Full name strings — exact case as they appear in source material */
  names?: string[];
  /** License plate strings — old or Mercosul format */
  plates?: string[];
  /** REDS event numbers */
  reds?: string[];
}

export interface EntityDictionary {
  entities: Entity[];
}

// ─── Loader ───────────────────────────────────────────────────────────────────

/**
 * Load and validate an EntityDictionary from a JSON file path.
 * NEVER call this in tests — pass a synthetic object instead.
 *
 * @throws if the file cannot be read or does not conform to the schema
 */
export async function loadDictionary(jsonPath: string): Promise<EntityDictionary> {
  const file = Bun.file(jsonPath);
  const exists = await file.exists();
  if (!exists) {
    throw new Error(`[pii-purge] Entity dictionary not found: ${jsonPath}`);
  }

  let raw: unknown;
  try {
    raw = await file.json();
  } catch (err) {
    throw new Error(`[pii-purge] Failed to parse entity dictionary at ${jsonPath}: ${String(err)}`);
  }

  return validateDictionary(raw, jsonPath);
}

/**
 * Validate a raw parsed object against the EntityDictionary schema.
 * Safe to call with synthetic test data.
 */
export function validateDictionary(raw: unknown, source = '<inline>'): EntityDictionary {
  if (typeof raw !== 'object' || raw === null || !('entities' in raw)) {
    throw new Error(`[pii-purge] Invalid dictionary at ${source}: missing 'entities' array`);
  }

  const obj = raw as Record<string, unknown>;
  if (!Array.isArray(obj.entities)) {
    throw new Error(`[pii-purge] Invalid dictionary at ${source}: 'entities' must be an array`);
  }

  const entities: Entity[] = [];
  for (const [i, e] of (obj.entities as unknown[]).entries()) {
    if (typeof e !== 'object' || e === null || !('id' in e)) {
      throw new Error(`[pii-purge] Entity at index ${i} in ${source} is missing required 'id' field`);
    }
    const ent = e as Record<string, unknown>;
    const entity: Entity = { id: String(ent.id) };
    if (Array.isArray(ent.cpfs)) entity.cpfs = ent.cpfs.map(String);
    if (Array.isArray(ent.phones)) entity.phones = ent.phones.map(String);
    if (Array.isArray(ent.names)) entity.names = ent.names.map(String);
    if (Array.isArray(ent.plates)) entity.plates = ent.plates.map(String);
    if (Array.isArray(ent.reds)) entity.reds = ent.reds.map(String);
    entities.push(entity);
  }

  return { entities };
}
/**
 * Pattern Generator — Builds all format-variant RegExps for a given Entity.
 *
 * Safety rules:
 * - CPF: formatted (NNN.NNN.NNN-NN) AND unformatted (NNNNNNNNNNN) → exact/format-variant
 * - Phone: with/without DDD parens/spaces/dash → exact/format-variant
 * - Plate: old AAA-0000/AAA0000 AND Mercosul AAA0A00 → exact/format-variant (scan-ok: format-spec)
 * - Name: exact string case-insensitive → exact match
 *         normalizeOrtho variant → fuzzy-REVIEW only (NEVER auto-purge)
 * - REDS: raw number match → exact
 *
 * Helpers are reimplemented locally — do NOT import from intelink.
 */

import type { Entity } from './dictionary.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW';
export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';

export interface EntityPattern {
  entityId: string;
  fieldType: EntityFieldType;
  matchType: MatchType;
  /** The compiled regex. Always has 'g' flag. */
  regex: RegExp;
}

// ─── Local format helpers (no intelink import) ────────────────────────────────

/** Strip all non-digit chars */
function digitsOnly(s: string): string {
  return s.replace(/\D/g, '');
}

/**
 * Strip combining diacritics (accents) and lower-case.
 * Used for fuzzy name normalization.
 */
export function normalizeOrtho(s: string): string {
  return s
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .trim();
}

/** Escape all regex-special chars in a string */
function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// ─── Per-type pattern builders ────────────────────────────────────────────────

/**
 * CPF — generates two patterns per CPF value:
 *   1. exact match (the string as given, escaped)
 *   2. all format variants (with/without dots and dash)
 * Both are `format-variant` matchType because they are structural equivalents.
 */
function cpfPatterns(entityId: string, cpfs: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const cpf of cpfs) {
    const digits = digitsOnly(cpf);
    if (digits.length !== 11) continue; // skip malformed

    // Formatted: DDD.DDD.DDD-DD
    const formatted = `${digits.slice(0, 3)}\\.${digits.slice(3, 6)}\\.${digits.slice(6, 9)}-${digits.slice(9)}`;
    // Unformatted: DDDDDDDDDDD (word boundary to avoid partial matches)
    const unformatted = digits;

    // Single pattern that matches both variants
    const src = `\\b(?:${formatted}|${unformatted})\\b`;
    results.push({
      entityId,
      fieldType: 'cpf',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Phone — matches with/without DDD parens, spaces, dashes.
 * Ex.: (11) 90000-0000 → 11900000000 → various delimiters (scan-ok: synthetic example)
 */
function phonePatterns(entityId: string, phones: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const phone of phones) {
    const digits = digitsOnly(phone);
    if (digits.length < 10 || digits.length > 13) continue; // skip malformed

    // Strip country code if present (+55)
    const local = digits.startsWith('55') && digits.length > 11 ? digits.slice(2) : digits;
    const ddd = local.slice(0, 2);
    const num = local.slice(2);

    // num may be 8 or 9 digits
    const half1 = num.slice(0, num.length - 4);
    const half2 = num.slice(-4);

    // Pattern: optional +55, optional parens on DDD, various delimiters
    const dddPart = `(?:\\+55[\\s-]?)?(?:\\(?${escapeRegex(ddd)}\\)?[\\s-]?)`;
    const numPart = `${escapeRegex(half1)}[-\\s]?${escapeRegex(half2)}`;
    const src = `\\b${dddPart}${numPart}\\b`;

    results.push({
      entityId,
      fieldType: 'phone',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Plate — matches old format (AAA-0000 / AAA0000) and Mercosul (AAA0A00). (scan-ok: format-spec)
 * We also handle the reverse: given Mercosul, emit both.
 */
function platePatterns(entityId: string, plates: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const plate of plates) {
    // Normalize: strip spaces/dashes, upper-case
    const clean = plate.replace(/[\s-]/g, '').toUpperCase();

    // Detect old format: 3 letters + 4 digits
    const isOld = /^[A-Z]{3}\d{4}$/.test(clean);
    // Detect Mercosul: 3 letters + digit + letter + 2 digits
    const isMercosul = /^[A-Z]{3}\d[A-Z]\d{2}$/.test(clean);

    if (!isOld && !isMercosul) continue;

    const escaped = escapeRegex(clean);
    let src: string;

    if (isOld) {
      // Match with or without dash: ABC-1234 or ABC1234 (scan-ok: format-spec)
      const letters = escapeRegex(clean.slice(0, 3));
      const digits = escapeRegex(clean.slice(3));
      src = `\\b${letters}[-]?${digits}\\b`;
    } else {
      // Mercosul — exact only (no dash variant exists)
      src = `\\b${escaped}\\b`;
    }

    results.push({
      entityId,
      fieldType: 'plate',
      matchType: isOld ? 'format-variant' : 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Name — two patterns per name:
 *   1. Exact case-insensitive string match (matchType: 'exact') → auto-purgeable
 *   2. Accent-stripped/ortho-normalized version (matchType: 'fuzzy-REVIEW') → flag only
 */
function namePatterns(entityId: string, names: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const name of names) {
    const trimmed = name.trim();
    if (!trimmed) continue;

    // Exact match (case-insensitive)
    const exactSrc = `\\b${escapeRegex(trimmed)}\\b`;
    results.push({
      entityId,
      fieldType: 'name',
      matchType: 'exact',
      regex: new RegExp(exactSrc, 'gi'),
    });

    // Ortho-normalized (accent-stripped) variant — REVIEW only
    const normalized = normalizeOrtho(trimmed);
    if (normalized !== trimmed.toLowerCase()) {
      const fuzzyEscaped = escapeRegex(normalized);
      results.push({
        entityId,
        fieldType: 'name',
        matchType: 'fuzzy-REVIEW',
        regex: new RegExp(`\\b${fuzzyEscaped}\\b`, 'gi'),
      });
    }
  }
  return results;
}

/**
 * REDS — matches the raw REDS number (digits only) with optional keyword prefix.
 */
function redsPatterns(entityId: string, reds: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const r of reds) {
    const digits = digitsOnly(r);
    if (!digits) continue;
    const src = `\\b(?:REDS[:\\s]*)?${escapeRegex(digits)}\\b`;
    results.push({
      entityId,
      fieldType: 'reds',
      matchType: 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * Generate all EntityPatterns for a single Entity.
 * Returns patterns in a deterministic order: cpf → phone → plate → reds → name.
 * Name fuzzy patterns are always last (lowest priority for matching).
 */
export function generateEntityPatterns(entity: Entity): EntityPattern[] {
  const patterns: EntityPattern[] = [];
  if (entity.cpfs?.length) patterns.push(...cpfPatterns(entity.id, entity.cpfs));
  if (entity.phones?.length) patterns.push(...phonePatterns(entity.id, entity.phones));
  if (entity.plates?.length) patterns.push(...platePatterns(entity.id, entity.plates));
  if (entity.reds?.length) patterns.push(...redsPatterns(entity.id, entity.reds));
  if (entity.names?.length) patterns.push(...namePatterns(entity.id, entity.names));
  return patterns;
}

/**
 * Generate all EntityPatterns for every entity in the dictionary.
 * Entities are processed in dict order (index 0 first).
 */
export function generateAllPatterns(entities: Entity[]): EntityPattern[] {
  return entities.flatMap(generateEntityPatterns);
}
/**
 * Scanner — Walks a target directory and returns Findings for each entity match.
 *
 * Safety rules:
 * - NEVER include the matched value in a Finding (T0 §3)
 * - Skip binary files, node_modules, .git
 * - Only process git-tracked text files (falls back to all text if not in a git repo)
 * - fuzzy-REVIEW matches are flagged but never auto-purgeable
 */

import { readdir, readFile, stat } from 'node:fs/promises';
import { join, extname } from 'node:path';
import { execSync } from 'node:child_process';
import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Finding {
  /** Absolute or relative path of the file containing the match */
  file: string;
  /** 1-based line number */
  line: number;
  /** Entity id from the dictionary */
  entityId: string;
  /** Which field type matched (cpf, phone, plate, name, reds) */
  type: EntityFieldType;
  /** Whether this is auto-purgeable or requires human review */
  matchType: MatchType;
  /** Byte offset of match start within the line (for stable replacements) */
  lineOffset: number;
  /** Length of matched text (never the value itself) */
  matchLength: number;
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

const BINARY_EXTENSIONS = new Set([
  '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp',
  '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
  '.zip', '.tar', '.gz', '.bz2', '.rar', '.7z',
  '.mp3', '.mp4', '.avi', '.mov', '.wav', '.flac',
  '.woff', '.woff2', '.ttf', '.eot',
  '.lock', '.bin', '.exe', '.dll', '.so', '.dylib',
  '.db', '.sqlite', '.sqlite3',
]);

function isBinary(filePath: string): boolean {
  return BINARY_EXTENSIONS.has(extname(filePath).toLowerCase());
}

function isSkippedDir(name: string): boolean {
  return name === 'node_modules' || name === '.git' || name === 'dist' || name === '.next';
}

/**
 * Returns the set of git-tracked files under `dir`, relative to `dir`.
 * Falls back to null if not in a git repo — caller handles fallback.
 */
function getGitTrackedFiles(dir: string): Set<string> | null {
  try {
    const out = execSync('git ls-files', { cwd: dir, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] });
    return new Set(out.trim().split('\n').filter(Boolean).map(f => join(dir, f)));
  } catch {
    return null;
  }
}

/**
 * Recursively collect all candidate file paths under `dir`.
 */
async function collectFiles(dir: string): Promise<string[]> {
  const results: string[] = [];
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (isSkippedDir(entry.name)) continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...(await collectFiles(full)));
    } else if (entry.isFile() && !isBinary(full)) {
      results.push(full);
    }
  }
  return results;
}

// ─── Core scanner ─────────────────────────────────────────────────────────────

/**
 * Scan a single file for all entity patterns.
 * NEVER includes matched values in returned findings.
 */
export function scanText(
  text: string,
  filePath: string,
  patterns: EntityPattern[],
): Finding[] {
  const findings: Finding[] = [];
  const lines = text.split('\n');

  for (const pattern of patterns) {
    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const line = lines[lineIdx]!;
      // Reset regex state for each line (patterns have 'g' flag)
      const re = new RegExp(pattern.regex.source, pattern.regex.flags);
      let match: RegExpExecArray | null;
      while ((match = re.exec(line)) !== null) {
        findings.push({
          file: filePath,
          line: lineIdx + 1, // 1-based
          entityId: pattern.entityId,
          type: pattern.fieldType,
          matchType: pattern.matchType,
          lineOffset: match.index,
          matchLength: match[0].length,
          // NEVER include match[0] — T0 §3
        });
      }
    }
  }

  return findings;
}

/**
 * Walk a target directory and scan all eligible files.
 * Returns a deduplicated, stable list of findings.
 *
 * @param targetDir  - directory to scan
 * @param patterns   - compiled entity patterns to search for
 */
export async function scanDirectory(
  targetDir: string,
  patterns: EntityPattern[],
): Promise<Finding[]> {
  const allFiles = await collectFiles(targetDir);

  // Filter to git-tracked files when possible
  const gitTracked = getGitTrackedFiles(targetDir);
  const filesToScan = gitTracked
    ? allFiles.filter(f => gitTracked.has(f))
    : allFiles;

  const allFindings: Finding[] = [];

  for (const filePath of filesToScan) {
    const s = await stat(filePath);
    // Skip very large files (>2MB) to avoid memory spikes
    if (s.size > 2 * 1024 * 1024) continue;

    let text: string;
    try {
      text = await readFile(filePath, 'utf-8');
    } catch {
      // Binary or unreadable — skip
      continue;
    }

    const findings = scanText(text, filePath, patterns);
    allFindings.push(...findings);
  }

  return allFindings;
}
/**
 * Purge Engine — Replaces entity identifiers with stable tokens.
 *
 * Safety rules:
 * - --dry-run (default): compute planned changes, NEVER write files
 * - --apply: write files + emit hash-chained audit log
 * - fuzzy-REVIEW matches are SKIPPED (never auto-purged)
 * - Token map is stable: same entity always gets same [PESSOA_N] across all files
 * - Replacements are done end-to-start to preserve offsets
 * - Audit log: each record has sha256(before) + sha256(after) + prevHash chain
 */

import { createHash } from 'node:crypto';
import { readFile, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import type { Entity } from './dictionary.js';
import type { EntityPattern } from './patterns.js';
import type { Finding } from './scanner.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface TokenMap {
  /** entity.id → replacement token string */
  [entityId: string]: string;
}

export interface PlannedChange {
  file: string;
  findingsCount: number;
  /** The replacement token that will be applied (safe to log) */
  token: string;
}

export interface AuditRecord {
  ts: string;
  file: string;
  sha256Before: string;
  sha256After: string;
  findingsApplied: number;
  prevHash: string;
  recordHash: string;
}

export interface PurgeResult {
  mode: 'dry-run' | 'apply';
  planned: PlannedChange[];
  applied: string[];
  skippedFuzzy: number;
  auditLog: AuditRecord[];
  auditLogPath?: string;
}

// ─── Token map ────────────────────────────────────────────────────────────────

/**
 * Build a stable token map from the entity list.
 * Entities are assigned [PESSOA_1], [PESSOA_2], ... in dict order (index).
 * The same token is used for ALL identifiers belonging to that entity.
 */
export function buildTokenMap(entities: Entity[]): TokenMap {
  const map: TokenMap = {};
  for (let i = 0; i < entities.length; i++) {
    map[entities[i]!.id] = `[PESSOA_${i + 1}]`;
  }
  return map;
}

// ─── Hash helper ──────────────────────────────────────────────────────────────

function sha256(text: string): string {
  return createHash('sha256').update(text, 'utf-8').digest('hex');
}

// ─── Text replacement ─────────────────────────────────────────────────────────

/**
 * Apply all non-fuzzy findings to a text string, replacing matched spans with tokens.
 * Replacements are done from last to first (end-to-start) so earlier offsets stay valid.
 *
 * @returns { result, appliedCount } — result is the replaced text
 */
export function applyReplacements(
  text: string,
  findings: Finding[],
  tokenMap: TokenMap,
): { result: string; appliedCount: number } {
  // Filter out fuzzy-REVIEW (never auto-purge)
  const applicable = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');

  if (applicable.length === 0) {
    return { result: text, appliedCount: 0 };
  }

  const lines = text.split('\n');

  // Group by line, process each line end-to-start within findings
  // Build a flat list of { lineIdx, lineOffset, matchLength, token }
  interface Span {
    lineIdx: number;
    lineOffset: number;
    matchLength: number;
    token: string;
  }

  const spans: Span[] = applicable.map(f => ({
    lineIdx: f.line - 1,
    lineOffset: f.lineOffset,
    matchLength: f.matchLength,
    token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
  }));

  // Sort end-to-start (line desc, offset desc)
  spans.sort((a, b) =>
    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
  );

  for (const span of spans) {
    const line = lines[span.lineIdx];
    if (line === undefined) continue;
    lines[span.lineIdx] =
      line.slice(0, span.lineOffset) +
      span.token +
      line.slice(span.lineOffset + span.matchLength);
  }

  return { result: lines.join('\n'), appliedCount: applicable.length };
}

// ─── Main purge function ──────────────────────────────────────────────────────

/**
 * Run the purge engine over a set of findings.
 *
 * @param findings       - all findings from the scanner
 * @param patterns       - all compiled patterns (used only for fuzzy count)
 * @param tokenMap       - entity id → replacement token
 * @param mode           - 'dry-run' (default) or 'apply'
 * @param auditLogDir    - where to write the audit log (only used in apply mode)
 */
export async function runPurge(
  findings: Finding[],
  tokenMap: TokenMap,
  mode: 'dry-run' | 'apply',
  auditLogDir?: string,
): Promise<PurgeResult> {
  // Group findings by file
  const byFile = new Map<string, Finding[]>();
  for (const f of findings) {
    const arr = byFile.get(f.file) ?? [];
    arr.push(f);
    byFile.set(f.file, arr);
  }

  const planned: PlannedChange[] = [];
  const applied: string[] = [];
  const auditLog: AuditRecord[] = [];
  let skippedFuzzy = 0;
  let prevHash = '0'.repeat(64);

  // Count fuzzy findings (for reporting)
  for (const f of findings) {
    if (f.matchType === 'fuzzy-REVIEW') skippedFuzzy++;
  }

  for (const [filePath, fileFindings] of byFile) {
    const nonFuzzy = fileFindings.filter(f => f.matchType !== 'fuzzy-REVIEW');
    if (nonFuzzy.length === 0) continue;

    // Pick the first token seen for this file (for reporting)
    const firstEntityId = nonFuzzy[0]!.entityId;
    const token = tokenMap[firstEntityId] ?? '[PESSOA_?]';

    planned.push({ file: filePath, findingsCount: nonFuzzy.length, token });

    if (mode === 'apply') {
      const before = await readFile(filePath, 'utf-8');
      const hashBefore = sha256(before);

      const { result: after, appliedCount } = applyReplacements(before, fileFindings, tokenMap);
      const hashAfter = sha256(after);

      await writeFile(filePath, after, 'utf-8');
      applied.push(filePath);

      // Build audit record
      const record: Omit<AuditRecord, 'recordHash'> = {
        ts: new Date().toISOString(),
        file: filePath,
        sha256Before: hashBefore,
        sha256After: hashAfter,
        findingsApplied: appliedCount,
        prevHash,
      };
      const recordHash = sha256(JSON.stringify(record));
      const fullRecord: AuditRecord = { ...record, recordHash };
      auditLog.push(fullRecord);
      prevHash = recordHash;
    }
  }

  let auditLogPath: string | undefined;
  if (mode === 'apply' && auditLog.length > 0 && auditLogDir) {
    const ts = new Date().toISOString().replace(/[:.]/g, '-');
    auditLogPath = join(auditLogDir, `pii-purge-audit-${ts}.jsonl`);
    const lines = auditLog.map(r => JSON.stringify(r)).join('\n') + '\n';
    await writeFile(auditLogPath, lines, 'utf-8');
  }

  return {
    mode,
    planned,
    applied,
    skippedFuzzy,
    auditLog,
    auditLogPath,
  };
}
{
  "name": "@egos/pii-purge",
  "version": "0.1.0",
  "description": "Motor de purge de PII conhecida em diretórios — EntityDictionary, pattern variants, audit hash-chained",
  "type": "module",
  "private": true,
  "scripts": {
    "test": "bun test src/pii-purge.test.ts",
    "typecheck": "tsc --noEmit -p tsconfig.json"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}

exec
/bin/bash -lc 'git -C packages/pii-purge ls-files | head; git -C /home/enio/egos/packages/pii-purge rev-parse --show-prefix' in /home/enio/egos
 succeeded in 0ms:
README.md
package.json
src/cli.ts
src/dictionary.ts
src/patterns.ts
src/pii-purge.test.ts
src/purge.ts
src/scanner.ts
src/verify.ts
tsconfig.json
packages/pii-purge/

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/patterns.ts | sed -n '65,165p'" in /home/enio/egos
 succeeded in 0ms:
    65	    const digits = digitsOnly(cpf);
    66	    if (digits.length !== 11) continue; // skip malformed
    67	
    68	    // Formatted: DDD.DDD.DDD-DD
    69	    const formatted = `${digits.slice(0, 3)}\\.${digits.slice(3, 6)}\\.${digits.slice(6, 9)}-${digits.slice(9)}`;
    70	    // Unformatted: DDDDDDDDDDD (word boundary to avoid partial matches)
    71	    const unformatted = digits;
    72	
    73	    // Single pattern that matches both variants
    74	    const src = `\\b(?:${formatted}|${unformatted})\\b`;
    75	    results.push({
    76	      entityId,
    77	      fieldType: 'cpf',
    78	      matchType: 'format-variant',
    79	      regex: new RegExp(src, 'gi'),
    80	    });
    81	  }
    82	  return results;
    83	}
    84	
    85	/**
    86	 * Phone — matches with/without DDD parens, spaces, dashes.
    87	 * Ex.: (11) 90000-0000 → 11900000000 → various delimiters (scan-ok: synthetic example)
    88	 */
    89	function phonePatterns(entityId: string, phones: string[]): EntityPattern[] {
    90	  const results: EntityPattern[] = [];
    91	  for (const phone of phones) {
    92	    const digits = digitsOnly(phone);
    93	    if (digits.length < 10 || digits.length > 13) continue; // skip malformed
    94	
    95	    // Strip country code if present (+55)
    96	    const local = digits.startsWith('55') && digits.length > 11 ? digits.slice(2) : digits;
    97	    const ddd = local.slice(0, 2);
    98	    const num = local.slice(2);
    99	
   100	    // num may be 8 or 9 digits
   101	    const half1 = num.slice(0, num.length - 4);
   102	    const half2 = num.slice(-4);
   103	
   104	    // Pattern: optional +55, optional parens on DDD, various delimiters
   105	    const dddPart = `(?:\\+55[\\s-]?)?(?:\\(?${escapeRegex(ddd)}\\)?[\\s-]?)`;
   106	    const numPart = `${escapeRegex(half1)}[-\\s]?${escapeRegex(half2)}`;
   107	    const src = `\\b${dddPart}${numPart}\\b`;
   108	
   109	    results.push({
   110	      entityId,
   111	      fieldType: 'phone',
   112	      matchType: 'format-variant',
   113	      regex: new RegExp(src, 'gi'),
   114	    });
   115	  }
   116	  return results;
   117	}
   118	
   119	/**
   120	 * Plate — matches old format (AAA-0000 / AAA0000) and Mercosul (AAA0A00). (scan-ok: format-spec)
   121	 * We also handle the reverse: given Mercosul, emit both.
   122	 */
   123	function platePatterns(entityId: string, plates: string[]): EntityPattern[] {
   124	  const results: EntityPattern[] = [];
   125	  for (const plate of plates) {
   126	    // Normalize: strip spaces/dashes, upper-case
   127	    const clean = plate.replace(/[\s-]/g, '').toUpperCase();
   128	
   129	    // Detect old format: 3 letters + 4 digits
   130	    const isOld = /^[A-Z]{3}\d{4}$/.test(clean);
   131	    // Detect Mercosul: 3 letters + digit + letter + 2 digits
   132	    const isMercosul = /^[A-Z]{3}\d[A-Z]\d{2}$/.test(clean);
   133	
   134	    if (!isOld && !isMercosul) continue;
   135	
   136	    const escaped = escapeRegex(clean);
   137	    let src: string;
   138	
   139	    if (isOld) {
   140	      // Match with or without dash: ABC-1234 or ABC1234 (scan-ok: format-spec)
   141	      const letters = escapeRegex(clean.slice(0, 3));
   142	      const digits = escapeRegex(clean.slice(3));
   143	      src = `\\b${letters}[-]?${digits}\\b`;
   144	    } else {
   145	      // Mercosul — exact only (no dash variant exists)
   146	      src = `\\b${escaped}\\b`;
   147	    }
   148	
   149	    results.push({
   150	      entityId,
   151	      fieldType: 'plate',
   152	      matchType: isOld ? 'format-variant' : 'exact',
   153	      regex: new RegExp(src, 'gi'),
   154	    });
   155	  }
   156	  return results;
   157	}
   158	
   159	/**
   160	 * Name — two patterns per name:
   161	 *   1. Exact case-insensitive string match (matchType: 'exact') → auto-purgeable
   162	 *   2. Accent-stripped/ortho-normalized version (matchType: 'fuzzy-REVIEW') → flag only
   163	 */
   164	function namePatterns(entityId: string, names: string[]): EntityPattern[] {
   165	  const results: EntityPattern[] = [];

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/patterns.ts | sed -n '164,215p'" in /home/enio/egos
 succeeded in 0ms:
   164	function namePatterns(entityId: string, names: string[]): EntityPattern[] {
   165	  const results: EntityPattern[] = [];
   166	  for (const name of names) {
   167	    const trimmed = name.trim();
   168	    if (!trimmed) continue;
   169	
   170	    // Exact match (case-insensitive)
   171	    const exactSrc = `\\b${escapeRegex(trimmed)}\\b`;
   172	    results.push({
   173	      entityId,
   174	      fieldType: 'name',
   175	      matchType: 'exact',
   176	      regex: new RegExp(exactSrc, 'gi'),
   177	    });
   178	
   179	    // Ortho-normalized (accent-stripped) variant — REVIEW only
   180	    const normalized = normalizeOrtho(trimmed);
   181	    if (normalized !== trimmed.toLowerCase()) {
   182	      const fuzzyEscaped = escapeRegex(normalized);
   183	      results.push({
   184	        entityId,
   185	        fieldType: 'name',
   186	        matchType: 'fuzzy-REVIEW',
   187	        regex: new RegExp(`\\b${fuzzyEscaped}\\b`, 'gi'),
   188	      });
   189	    }
   190	  }
   191	  return results;
   192	}
   193	
   194	/**
   195	 * REDS — matches the raw REDS number (digits only) with optional keyword prefix.
   196	 */
   197	function redsPatterns(entityId: string, reds: string[]): EntityPattern[] {
   198	  const results: EntityPattern[] = [];
   199	  for (const r of reds) {
   200	    const digits = digitsOnly(r);
   201	    if (!digits) continue;
   202	    const src = `\\b(?:REDS[:\\s]*)?${escapeRegex(digits)}\\b`;
   203	    results.push({
   204	      entityId,
   205	      fieldType: 'reds',
   206	      matchType: 'exact',
   207	      regex: new RegExp(src, 'gi'),
   208	    });
   209	  }
   210	  return results;
   211	}
   212	
   213	// ─── Public API ───────────────────────────────────────────────────────────────
   214	
   215	/**

exec
/bin/bash -lc "bun -e \"const re=/\\b(?:\\+55[\\s-]?)?(?:\\(?11\\)?[\\s-]?)90000[-\\s]?0000\\b/gi; console.log('+55 11 90000-0000'.match(re)); console.log('11 90000-0000'.match(re)); const n=/\\bÁlvaro Silva\\b/gi; console.log('Álvaro Silva'.match(n)); console.log('x Álvaro Silva y'.match(n));\"" in /home/enio/egos
 succeeded in 0ms:
[ "11 90000-0000" ]
[ "11 90000-0000" ]
null
null

exec
/bin/bash -lc "bun -e \"const re=/\\b(?:\\+55[\\s-]?)?(?:\\(?11\\)?[\\s-]?)90000[-\\s]?0000\\b/gi; for (const s of ['+5511900000000','+55 11900000000','5511900000000']) console.log(s, s.match(re))\"" in /home/enio/egos
 succeeded in 0ms:
+5511900000000 null
+55 11900000000 [ "11900000000" ]
5511900000000 null

exec
/bin/bash -lc 'bun test packages/pii-purge/src/pii-purge.test.ts' in /home/enio/egos
 succeeded in 0ms:
bun test v1.3.9 (cf6cdbbb)

 29 pass
 0 fail
 54 expect() calls
Ran 29 tests across 1 file. [65.00ms]

exec
/bin/bash -lc "cat package.json | sed -n '1,200p'; ls" in /home/enio/egos
 succeeded in 0ms:
{
  "name": "egos",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "EGOS — Orchestration kernel for governed AI agents",
  "license": "MIT",
  "author": "Enio Rocha <enio@egos.ia.br>",
  "bin": {
    "egos": "./bin/egos.ts"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git"
  },
  "workspaces": [
    "packages/*",
    "apps/*",
    "central-egos/*"
  ],
  "scripts": {
    "setup": "sh setup.sh",
    "egos:init": "sh scripts/egos-init.sh",
    "agent:list": "bun agents/cli.ts list",
    "agent:run": "bun agents/cli.ts run",
    "agent:lint": "bun agents/cli.ts lint-registry",
    "coordination:watch": "bun run scripts/coordination-watcher.ts",
    "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
    "lint": "eslint .",
    "prepare": "husky",
    "precommit": "bash .husky/pre-commit",
    "governance:sync": "sh scripts/governance-sync.sh --dry",
    "governance:sync:exec": "sh scripts/governance-sync.sh --exec --propagate",
    "governance:sync:local": "sh scripts/governance-sync.sh --exec --no-propagate",
    "governance:check": "sh scripts/governance-sync.sh --check",
    "template:check": "bun scripts/validate-inherits.ts && bun scripts/lint-domain-template.ts",
    "template:check:strict": "bun scripts/validate-inherits.ts --strict && bun scripts/lint-domain-template.ts --strict",
    "governance:runtime:smoke": "bun scripts/runtime-smoke.ts",
    "governance:runtime:smoke:json": "bun scripts/runtime-smoke.ts --json",
    "governance:runtime:report": "bun scripts/runtime-operator-report.ts",
    "governance:runtime:report:json": "bun scripts/runtime-operator-report.ts --json",
    "gov:check": "bun run scripts/runtime-smoke-validator.ts",
    "gov:telemetry": "bun run scripts/hook-telemetry-report.ts --week",
    "gov:telemetry:daily": "bun run scripts/hook-telemetry-report.ts --day",
    "gov:evidence-gate:dry": "bun run scripts/evidence-gate-disseminate.ts --dry-run",
    "gov:sync:dry": "bun run ~/.eos/scripts/core/governance-sync.sh --dry-run",
    "gov:sync": "bun run ~/.eos/scripts/core/governance-sync.sh --exec",
    "tasks:archive": "bun scripts/tasks-archive.ts --dry",
    "tasks:archive:exec": "bun scripts/tasks-archive.ts --exec",
    "tasks:reconcile": "bun scripts/task-reconciliation.ts --summary",
    "tasks:calibrate": "bun scripts/calibrate-tasks.ts",
    "tasks:audit": "bun scripts/hermes-task-audit.ts --dry",
    "tasks:audit:write": "bun scripts/hermes-task-audit.ts",
    "claude:telemetry": "bun scripts/claude-hook-telemetry.ts",
    "claude:telemetry:json": "bun scripts/claude-hook-telemetry.ts --json",
    "claude:telemetry:otel": "bun scripts/claude-hook-telemetry.ts --otel",
    "claude:telemetry:otel:json": "bun scripts/claude-hook-telemetry.ts --otel --json",
    "egos:boot": "bash scripts/egos-boot.sh",
    "ssot:check": "bun scripts/validate-ssot.ts",
    "ssot:claim-check": "bun scripts/ssot-claim-check.ts",
    "ssot:diagnostic": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --output /tmp/qa-ssot-check.md",
    "ssot:diagnostic:json": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --format json --output /tmp/qa-ssot-check.json",
    "smoke:api": "bun scripts/smoke-test-api.ts",
    "version:lock": "bun scripts/check-version-lock.ts",
    "integration:check": "bun scripts/integration-release-check.ts",
    "pr:pack": "bun scripts/pr-pack.ts",
    "pr:gate": "bun scripts/pr-gate.ts",
    "pr:audit": "bun scripts/pr-ecosystem-audit.ts",
    "ssot:link": "sh scripts/link-ssot-files.sh --dry",
    "ssot:link:exec": "sh scripts/link-ssot-files.sh --exec",
    "qa:observability": "bash scripts/qa/run_observability_suite.sh",
    "qa:pending": "python scripts/qa/list_pending_tasks.py --input TASKS.md",
    "qa:pending:json": "python scripts/qa/list_pending_tasks.py --input TASKS.md --format json",
    "qa:stalled": "python scripts/qa/stalled_tasks_report.py --input TASKS.md",
    "qa:evidence": "python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt",
    "qa:evidence:gate": "python scripts/qa/telemetry_guardrail.py --input tests/qa/fixtures/sample_telemetry.txt --output /tmp/qa-guardrail.txt && python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt --enforce",
    "qa:compose": "python scripts/qa/compose_qa_envelope.py --guardrail /tmp/qa-guardrail.txt --ssot /tmp/qa-ssot-check.md --evidence /tmp/qa-evidence.md --output /tmp/qa-envelope.json",
    "security:audit": "bun scripts/security-audit.ts",
    "security:audit:json": "bun scripts/security-audit.ts --json",
    "security:audit:fix": "bun scripts/security-audit.ts --fix",
    "test": "bun test packages/shared/src/__tests__/",
    "test:hooks": "bun test tests/hooks/",
    "test:watch": "bun test --watch",
    "test:governance": "bun scripts/test-governance.ts",
    "capability:scan": "bun scripts/update-capability-registry.ts",
    "capability:scan:repo": "bun scripts/update-capability-registry.ts --repo",
    "duplication:scan": "bun scripts/governance/duplication-scanner.ts",
    "duplication:scan:json": "bun scripts/governance/duplication-scanner.ts --json",
    "ssot:crosslink": "bun scripts/governance/ssot-crosslink-validator.ts",
    "ssot:crosslink:staged": "bun scripts/governance/ssot-crosslink-validator.ts --staged",
    "activation:check": "bun scripts/activation-check.ts",
    "start": "bun scripts/start-v6.ts",
    "start:full": "bun scripts/start-v6.ts --full",
    "start:json": "bun scripts/start-v6.ts --json",
    "doctor": "bun scripts/doctor.ts",
    "doctor:codex": "sh scripts/codex-doctor.sh",
    "doctor:fix": "bun scripts/doctor.ts --fix",
    "personal:sync:status": "bun scripts/personal-sync-status.ts",
    "personal:sync:status:json": "bun scripts/personal-sync-status.ts --json",
    "phantom:tables:audit": "bun scripts/phantom-table-audit.ts",
    "phantom:tables:audit:json": "bun scripts/phantom-table-audit.ts --json",
    "chatgpt:ingest": "bun scripts/chatgpt-export-sync.ts --dry",
    "chatgpt:ingest:exec": "bun scripts/chatgpt-export-sync.ts --exec",
    "chatgpt:watch": "bun scripts/chatgpt-export-watch.ts --dry",
    "chatgpt:watch:exec": "bun scripts/chatgpt-export-watch.ts --exec",
    "wiki:repos-sync": "bun scripts/wiki-repos-sync.ts",
    "wiki:repos-sync:check": "bun scripts/wiki-repos-sync.ts --check",
    "wiki:compile": "bun agents/agents/wiki-compiler.ts --compile",
    "wiki:compile:dry": "bun agents/agents/wiki-compiler.ts --compile --dry",
    "wiki:heal": "bun agents/agents/wiki-compiler.ts --heal",
    "wiki:heal:dry": "bun agents/agents/wiki-compiler.ts --heal --dry",
    "wiki:lint": "bun agents/agents/wiki-compiler.ts --lint",
    "wiki:index": "bun agents/agents/wiki-compiler.ts --index",
    "wiki:dedup": "bun agents/agents/wiki-compiler.ts --dedup",
    "wiki:dedup:dry": "bun agents/agents/wiki-compiler.ts --dedup --dry",
    "wiki:enrich": "bun agents/agents/wiki-compiler.ts --enrich",
    "wiki:enrich:dry": "bun agents/agents/wiki-compiler.ts --enrich --dry",
    "deadcode": "knip",
    "deadcode:fix": "knip --fix",
    "skill:usage": "bun scripts/skill-usage-tracker.ts",
    "skill:usage:log": "bun scripts/skill-usage-tracker.ts --log",
    "skill:usage:30d": "bun scripts/skill-usage-tracker.ts --days=30",
    "gemhunter:dry": "bun agents/cli.ts run gem-hunter --dry",
    "gemhunter:exec": "bun agents/cli.ts run gem-hunter --exec",
    "gemhunter:quick": "bun agents/cli.ts run gem-hunter --exec --quick",
    "gemhunter:api": "bun agents/api/gem-hunter-server.ts"
  },
  "devDependencies": {
    "@anthropic-ai/sdk": "^0.100.0",
    "@types/bun": "^1.3.13",
    "@types/node": "^25.6.0",
    "eslint": "^10.2.1",
    "husky": "^9.1.7",
    "knip": "^6.9.0",
    "typescript": "^6.0.3"
  },
  "dependencies": {
    "@google/generative-ai": "^0.24.1",
    "@supabase/supabase-js": "^2.105.1",
    "ajv": "8.20.0",
    "axios": "^1.15.2",
    "cross-spawn": "7.0.6",
    "dotenv": "^17.4.2",
    "hono": "^4.12.16",
    "mammoth": "^1.12.0",
    "semver": "~7.7.4",
    "substack-api": "^4.0.0",
    "twitter-api-v2": "^1.29.0",
    "unpdf": "^1.6.2",
    "ws": "^8.20.0",
    "yaml": "^2.8.3",
    "zod": "^4.4.1"
  },
  "overrides": {
    "@xmldom/xmldom": "^0.8.13",
    "flatted": "^3.4.2",
    "uuid": ">=14.0.0",
    "fast-uri": "^3.1.2",
    "axios": "^1.16.0"
  }
}
AGENTS.md
CLAUDE.md
CODEOWNERS
CONTRIBUTING.md
EGOS
EGOS-Global.code-workspace
LICENSE
MANUAL_ACTIONS.md
README.md
SECURITY.md
TASKS.md
TASKS.md.bak
TASKS_ARCHIVE.md
TASKS_ARCHIVE_2026.md
TASKS_PRODUCT.md
_build
agents
apps
bin
bun.lock
central-egos
consulting
data
docs
egos-advocacia.zip
egos.config.json
env
error.log
frozen-zones
frozen-zones.md
infra
integrations
knip.json
llms.txt
logs
metrics
node_modules
notebooklm_export_egos.md
obsidian-egos-llm-plugin
package.json
packages
policia
policies
prompts
rules
scripts
setup.sh
supabase
tests
tmp
tools
tsconfig.json
vercel.json

exec
/bin/bash -lc 'bun run --cwd packages/pii-purge typecheck' in /home/enio/egos
 succeeded in 1231ms:
exec
/bin/bash -lc "bun -e \"import {generateAllPatterns} from './packages/pii-purge/src/patterns.ts'; import {scanText} from './packages/pii-purge/src/scanner.ts'; import {applyReplacements, buildTokenMap} from './packages/pii-purge/src/purge.ts'; const ents=[{id:'e1', names:['Ana','Ana Maria']}]; const p=generateAllPatterns(ents); const f=scanText('Ana Maria','x',p); console.log(f); console.log(applyReplacements('Ana Maria', f, buildTokenMap(ents)));\"" in /home/enio/egos
 succeeded in 0ms:
[
  {
    file: "x",
    line: 1,
    entityId: "e1",
    type: "name",
    matchType: "exact",
    lineOffset: 0,
    matchLength: 3,
  }, {
    file: "x",
    line: 1,
    entityId: "e1",
    type: "name",
    matchType: "exact",
    lineOffset: 0,
    matchLength: 9,
  }
]
{
  result: "[PESSOA_1]] Maria",
  appliedCount: 2,
}

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/purge.ts | sed -n '86,116p'" in /home/enio/egos
 succeeded in 0ms:
    86	): { result: string; appliedCount: number } {
    87	  // Filter out fuzzy-REVIEW (never auto-purge)
    88	  const applicable = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
    89	
    90	  if (applicable.length === 0) {
    91	    return { result: text, appliedCount: 0 };
    92	  }
    93	
    94	  const lines = text.split('\n');
    95	
    96	  // Group by line, process each line end-to-start within findings
    97	  // Build a flat list of { lineIdx, lineOffset, matchLength, token }
    98	  interface Span {
    99	    lineIdx: number;
   100	    lineOffset: number;
   101	    matchLength: number;
   102	    token: string;
   103	  }
   104	
   105	  const spans: Span[] = applicable.map(f => ({
   106	    lineIdx: f.line - 1,
   107	    lineOffset: f.lineOffset,
   108	    matchLength: f.matchLength,
   109	    token: tokenMap[f.entityId] ?? `[PESSOA_?]`,
   110	  }));
   111	
   112	  // Sort end-to-start (line desc, offset desc)
   113	  spans.sort((a, b) =>
   114	    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
   115	  );
   116	

exec
/bin/bash -lc "nl -ba packages/pii-purge/src/purge.ts | sed -n '112,130p'" in /home/enio/egos
 succeeded in 0ms:
   112	  // Sort end-to-start (line desc, offset desc)
   113	  spans.sort((a, b) =>
   114	    b.lineIdx !== a.lineIdx ? b.lineIdx - a.lineIdx : b.lineOffset - a.lineOffset,
   115	  );
   116	
   117	  for (const span of spans) {
   118	    const line = lines[span.lineIdx];
   119	    if (line === undefined) continue;
   120	    lines[span.lineIdx] =
   121	      line.slice(0, span.lineOffset) +
   122	      span.token +
   123	      line.slice(span.lineOffset + span.matchLength);
   124	  }
   125	
   126	  return { result: lines.join('\n'), appliedCount: applicable.length };
   127	}
   128	
   129	// ─── Main purge function ──────────────────────────────────────────────────────
   130	

codex
The new PII purge tool has detection and replacement bugs that can leave common PII formats unpurged or corrupt redactions. These affect the core security purpose of the added package.

Full review comments:

- [P1] Avoid word-boundary misses for accented names — /home/enio/egos/packages/pii-purge/src/patterns.ts:170-176
  For names that start or end with non-ASCII letters, such as `Álvaro Silva`, JavaScript `\b` does not treat the accented character as a word character, so the exact name regex never matches and the normalized fuzzy pattern only matches already accent-stripped text. In those common Brazilian-name cases the scan and post-purge verify both report clean while leaving the original PII in place.

- [P2] Deduplicate overlapping spans before replacement — /home/enio/egos/packages/pii-purge/src/purge.ts:113-123
  When the dictionary contains overlapping aliases, e.g. `Ana` and `Ana Maria` for the same person, both findings are applied at the same offset; after the shorter replacement mutates the line, the longer replacement slices the already-mutated text and produces corrupted output like `[PESSOA_1]] Maria`. This can happen with name aliases/full names and should be resolved by choosing a non-overlapping set, usually longest match first, before writing.

- [P2] Match phone numbers with contiguous country codes — /home/enio/egos/packages/pii-purge/src/patterns.ts:104-107
  For phone values stored with `+55` or scanned as contiguous international format, such as `+5511900000000` or `5511900000000`, the leading `\b` prevents the generated regex from matching the full number, so scan/verify can miss a phone that the comments say should be covered. This leaves a common BR phone representation unpurged in publish-gate use.
The new PII purge tool has detection and replacement bugs that can leave common PII formats unpurged or corrupt redactions. These affect the core security purpose of the added package.

Full review comments:

- [P1] Avoid word-boundary misses for accented names — /home/enio/egos/packages/pii-purge/src/patterns.ts:170-176
  For names that start or end with non-ASCII letters, such as `Álvaro Silva`, JavaScript `\b` does not treat the accented character as a word character, so the exact name regex never matches and the normalized fuzzy pattern only matches already accent-stripped text. In those common Brazilian-name cases the scan and post-purge verify both report clean while leaving the original PII in place.

- [P2] Deduplicate overlapping spans before replacement — /home/enio/egos/packages/pii-purge/src/purge.ts:113-123
  When the dictionary contains overlapping aliases, e.g. `Ana` and `Ana Maria` for the same person, both findings are applied at the same offset; after the shorter replacement mutates the line, the longer replacement slices the already-mutated text and produces corrupted output like `[PESSOA_1]] Maria`. This can happen with name aliases/full names and should be resolved by choosing a non-overlapping set, usually longest match first, before writing.

- [P2] Match phone numbers with contiguous country codes — /home/enio/egos/packages/pii-purge/src/patterns.ts:104-107
  For phone values stored with `+55` or scanned as contiguous international format, such as `+5511900000000` or `5511900000000`, the leading `\b` prevents the generated regex from matching the full number, so scan/verify can miss a phone that the comments say should be covered. This leaves a common BR phone representation unpurged in publish-gate use.
```
