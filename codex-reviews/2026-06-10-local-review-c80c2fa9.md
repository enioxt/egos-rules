# Codex Local Review — 2026-06-10T12:53:46Z

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
session id: 019eb198-9826-7840-b6dc-29b4c7bfb97b
--------
user
changes against 'HEAD~3'
2026-06-10T12:53:49.131990Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T12:53:49.137120Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff c5ed3947de7bd5f5b44c8ecb1e30b590a6bf0ead --stat && git diff c5ed3947de7bd5f5b44c8ecb1e30b590a6bf0ead' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/start.md                         |     6 +-
 .claude/agents/guarani.md                          |     2 +
 .claude/commands/start.md                          |     6 +-
 .husky/pre-commit                                  |     9 +
 AGENTS.md                                          |     4 +-
 TASKS.md                                           |   543 +-
 apps/egos-landing/public/timeline/rss              |     2 +-
 apps/egos-landing/public/timeline/rss.xml          |     2 +-
 docs/CAPABILITY_REGISTRY.md                        |     2 +-
 .../2026-04/handoff_2026-03-31.md                  |     4 +-
 .../2026-04/handoff_2026-04-06_p29.md              |     4 +-
 .../2026-04/handoff_2026-04-06_p30.md              |     2 +-
 ...2026-04-07_chatbot_p0_guard_credentials_xcom.md |     2 +-
 .../handoff_2026-04-07_p35_ssot_gate_complete.md   |     6 +-
 .../2026-04/handoff_2026-04-12b.md                 |     2 +-
 .../2026-04/handoff_2026-04-14.md                  |     8 +-
 .../handoff_2026-04-16_bilingual_pipeline.md       |     2 +-
 .../2026-04/handoff_2026-04-17b.md                 |     4 +-
 .../2026-04/handoff_2026-04-23.md                  |     2 +-
 .../2026-04/handoff_2026-04-24.md                  |     2 +-
 .../2026-05/ACTION_ITEMS_USER.md                   |     4 +-
 .../2026-05/PARTNERSHIP_KIT_INDEX.md               |    26 +-
 .../2026-05/PRODUTOS_pre-central-egos-pivot.md     |     4 +-
 ...andoff_2026-05-15_espiral-integrations-audit.md |    52 +-
 .../handoff_2026-05-18_grok-decisions-applied.md   |     4 +-
 docs/_archived_handoffs/HANDOFF_CURRENT.md         |     2 +-
 docs/_archived_handoffs/MEMORY_SESSION_INDEX.md    |     2 +-
 .../FOR_GUARANI_2026-06-10_end-review.md           |    28 +
 docs/_current_handoffs/handoff_2026-06-10.md       |    55 +-
 docs/agents/META_PROMPTS_INDEX.md                  |    10 +-
 docs/audits/CAPABILITY_COVERAGE_2026-05-30.md      |     4 +-
 docs/audits/INTEGRATION_COVERAGE_2026-05-30.md     |     2 +-
 docs/concepts/ESPIRAIS_VISION.md                   |     2 +-
 docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md           |     2 +-
 docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md   |     2 +-
 docs/governance/AREAS_OF_PRACTICE.md               |     2 +-
 docs/governance/CLIENT_KB_DOCTRINE.md              |     4 +-
 docs/governance/CLIENT_TIERS_MATRIX.md             |     2 +-
 docs/governance/EGOS_OPERATING_PRINCIPLES.md       |     2 +-
 docs/governance/MASTER_INDEX.md                    |     2 +-
 docs/jobs/2026-06-10-crossrefs-report.json         | 13407 +++++++++++++++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json       |     4 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json      |    24 +
 docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md     |     2 +-
 docs/products-specs/INDEX.md                       |     2 +-
 docs/products-specs/anythingllm/OPERATIONS.md      |     4 +-
 docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md           |     2 +-
 docs/runbooks/MOBILE_ACCESS_GUIDE.md               |     2 +-
 docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md          |     2 +-
 docs/strategy/ROADMAP.md                           |   520 +
 .../_archived_2026-05-06/CONSULTING_MASTER_PLAN.md |    22 +-
 scripts/egos-home/sync.sh                          |    28 +-
 scripts/mycelium-query.ts                          |   474 +
 53 files changed, 14618 insertions(+), 700 deletions(-)
diff --git a/.agents/workflows/start.md b/.agents/workflows/start.md
index 90a45d89..478203ae 100644
--- a/.agents/workflows/start.md
+++ b/.agents/workflows/start.md
@@ -262,7 +262,7 @@ Use **Read tool** no handoff retornado. Foque em: "Next / Próximos Passos", "In
 
 ## LAYER 4.6 — SSOT do Leaf-Repo (INC-009)
 
-> **Aplica quando:** cwd é leaf-repo (não `/home/enio/egos/`). Detalhe completo: [docs/start-layers/leaf-ssot.md](../docs/start-layers/leaf-ssot.md).
+> **Aplica quando:** cwd é leaf-repo (não `/home/enio/egos/`). Detalhe completo: [docs/start-layers/leaf-ssot.md](../../docs/start-layers/leaf-ssot.md).
 
 ```bash
 ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
@@ -285,7 +285,7 @@ Layer 4.6 — Leaf SSOTs
 
 ## LAYER 4.7 — External Integrations Health
 
-> **Aplica quando:** repo tem `.env` com `EVOLUTION_API_URL`. Detalhe completo: [docs/start-layers/evolution-health.md](../docs/start-layers/evolution-health.md).
+> **Aplica quando:** repo tem `.env` com `EVOLUTION_API_URL`. Detalhe completo: [docs/start-layers/evolution-health.md](../../docs/start-layers/evolution-health.md).
 
 ```bash
 HAS_EVOL=$(grep -lE "^EVOLUTION_API_URL" .env .env.local 2>/dev/null | head -1)
@@ -373,7 +373,7 @@ echo -n "codebase-memory-mcp: "; command -v codebase-memory-mcp >/dev/null && ec
 
 ## LAYER 6.5 — Capability Delta
 
-> Detalhe completo (bash MCPs + Hermes VPS): [docs/start-layers/capability-delta.md](../docs/start-layers/capability-delta.md).
+> Detalhe completo (bash MCPs + Hermes VPS): [docs/start-layers/capability-delta.md](../../docs/start-layers/capability-delta.md).
 
 Executar bash de `capability-delta.md` para: novas sections em CAPABILITY_REGISTRY, INTEGRATION_REGISTRY status, MCPs ativos, Hermes VPS skills, eval coverage.
 
diff --git a/.claude/agents/guarani.md b/.claude/agents/guarani.md
index 33366e0a..0b3429ed 100644
--- a/.claude/agents/guarani.md
+++ b/.claude/agents/guarani.md
@@ -80,3 +80,5 @@ Todo ciclo loga em `~/.egos/agent-runs/guarani-<runid>.jsonl`:
 - **Claim sem prova = UNVERIFIED:** prefixar achados não confirmados por leitura direta
 - **Sem `git add -A`** — mesmo que nunca commite, nunca prepara staging
 - **No-Code Master (100% IA-Driven):** O usuário Enio não edita nem lê código cru. Assuma que toda intervenção técnica deve ser gerada por IAs. Proponha apenas soluções auto-executáveis e audite drifts técnicos sem depender de ações manuais do usuário. Interact em nível estratégico.
+- **PROIBIDO write direto em arquivos compartilhados de lei/infra** (`.husky/*`, `CLAUDE.md`, `AGENTS.md`, `.guarani/*`, `.claude/commands|agents/*`) — incidente 2026-06-10: edição concorrente do pre-commit DURANTE execução = syntax error transitório, commits quase travados machine-wide. Proposta = `FOR_PRIME_*.md` com diff. (Review: `FOR_GUARANI_2026-06-10_end-review.md`)
+- **/end com prova por fase:** fase ✓ exige comando+path executado (Phase 8 phantom 2026-06-10: memória declarada escrita não existia). Não inventar task-IDs — próximo passo proposto vai em FOR_PRIME.
diff --git a/.claude/commands/start.md b/.claude/commands/start.md
index 79a89cd7..32f9e92b 100644
--- a/.claude/commands/start.md
+++ b/.claude/commands/start.md
@@ -294,7 +294,7 @@ Use **Read tool** no handoff retornado. Foque em: "Next / Próximos Passos", "In
 
 ## LAYER 4.6 — SSOT do Leaf-Repo (INC-009)
 
-> **Aplica quando:** cwd é leaf-repo (não `/home/enio/egos/`). Detalhe completo: [docs/start-layers/leaf-ssot.md](../docs/start-layers/leaf-ssot.md).
+> **Aplica quando:** cwd é leaf-repo (não `/home/enio/egos/`). Detalhe completo: [docs/start-layers/leaf-ssot.md](../../docs/start-layers/leaf-ssot.md).
 
 ```bash
 ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
@@ -317,7 +317,7 @@ Layer 4.6 — Leaf SSOTs
 
 ## LAYER 4.7 — External Integrations Health
 
-> **Aplica quando:** repo tem `.env` com `EVOLUTION_API_URL`. Detalhe completo: [docs/start-layers/evolution-health.md](../docs/start-layers/evolution-health.md).
+> **Aplica quando:** repo tem `.env` com `EVOLUTION_API_URL`. Detalhe completo: [docs/start-layers/evolution-health.md](../../docs/start-layers/evolution-health.md).
 
 ```bash
 HAS_EVOL=$(grep -lE "^EVOLUTION_API_URL" .env .env.local 2>/dev/null | head -1)
@@ -421,7 +421,7 @@ echo "Agent Org: ${AGENTS_DEF} papéis em .claude/agents/ | mapa: docs/governanc
 
 ## LAYER 6.5 — Capability Delta
 
-> Detalhe completo (bash MCPs + Hermes VPS): [docs/start-layers/capability-delta.md](../docs/start-layers/capability-delta.md).
+> Detalhe completo (bash MCPs + Hermes VPS): [docs/start-layers/capability-delta.md](../../docs/start-layers/capability-delta.md).
 
 Executar bash de `capability-delta.md` para: novas sections em CAPABILITY_REGISTRY, INTEGRATION_REGISTRY status, MCPs ativos, Hermes VPS skills, eval coverage.
 
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
index 7a7bbd06..9aa5a5e3 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -189,7 +189,7 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 **Agents:** `bun agent:list/run/lint` **Governance:** `bun governance:sync|check` **PR:** `bun pr:pack|gate|audit` **Integration:** `bun integration:check` **Type:** `bun typecheck` **Lint:** `bun lint` **Context:** `bun agent:run context_tracker --dry` (mandatory before multi-step tasks)
 
 ## Skill Orchestration · Slash · Block Model
-**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.windsurf/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
+**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.agents/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag, busca). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
 
 ## Central EGOS — Regras de Desenvolvimento (D8 — 2026-05-21)
 **API-FIRST:** Toda feature → API mestre primeiro. UI/MCP/AnythingLLM consomem API. Bearer auth + X-Tenant-ID + rate limit + RBAC + audit em ops sensíveis. **GOV-BOUNDARY:** Governança NUNCA em `central-egos/clients/<slug>/` — herda de `central-egos/docs/governance/`. Pre-commit enforced. **PRODUTO:** `central-egos/` raiz · clientes em `clients/` · template em `template/` · scripts em `scripts/` · docs em `docs/`.
@@ -197,4 +197,4 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 ## Templates de domínio (L0-DEF-002 — 2026-05-29)
 Vertical setorial em `central-egos/products/<slug>/` que herda Layer 0 (T0-T2 + R0-R6 + .guarani) sem duplicar. **Ativos:** advocacia-starter v1.0. **Protocolo:** (1) `INHERITS.md` obrigatório com frontmatter YAML; (2) overrides só via `OVERRIDES.md` com justificativa — T0 nunca sobrescrito; (3) duplicação do kernel deve virar ref curta. **SSOTs:** [LAYER_0_SSOT.md](docs/governance/LAYER_0_SSOT.md) · [TEMPLATE_INHERITANCE_PROTOCOL.md](docs/governance/TEMPLATE_INHERITANCE_PROTOCOL.md) · [DOMAIN_TEMPLATE_SPEC.md](docs/governance/DOMAIN_TEMPLATE_SPEC.md).
 ## Meta-Prompts + Docs
-`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/business/MONETIZATION_SSOT.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
+`README.md` · `docs/MASTER_INDEX.md` · `docs/modules/SSOT_REGISTRY.md` · `docs/SYSTEM_MAP.md` · `docs/capabilities/README.md` · `docs/INFRASTRUCTURE_ARCHIVE_AUDIT.md` · `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` · `TASKS_ARCHIVE.md` · `docs/COORDINATION.md` · `docs/opus-mode/OPUS_MODE_V1.md` (`/opus /tutor /banda /council /chronicle`) · TASKS: done→auto-archive; thresholds warn≥250 archive≥400 block≥600.
diff --git a/TASKS.md b/TASKS.md
index cfc84760..ccc60c8e 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -33,7 +33,7 @@
 **🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
 
 **🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
-- [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
+- [x] **TASKS-ARCHIVE-NOW-001** [P0] `prime` ✅ 2026-06-10 — Closes neste commit (1111→570L, 197 IDs → docs/strategy/ROADMAP.md, zero perda verificada) — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
 - [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
 - [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
 
@@ -335,118 +335,6 @@
 - [ ] **SESSION-START-RESET-001** [P2] `forja` — Consertar divergência doc/código: `session-start.sh` não reseta contadores pós-compact apesar de CLAUDE.md §5.1 afirmar (proveniência-por-ação).
 - [ ] **CONTEXT-AUDIT-RERUN-001** [P3] — Re-rodar `context-audit.ts` (última ~2026-05-06; skills cresceram) p/ atualizar math 49k vs 275k overhead (E-05).
 
-## 🎓 EGOS FOUNDERS COURSE — produto educacional público (Enio 2026-06-04, "paguei minha dívida, agora prospero")
-> **Banda:** Crítico=RESSALVAS · Apoiador=RESSALVAS · Questionador=RECUSAR programa completo · **Maestro=APROVADO MVP mínimo**
-> **MVP lote R$8:** (1) aula inaugural 45-60min — demo Guard Brasil ao vivo; (2) PDF "método EGOS em uma página"; (3) acesso ao WhatsApp privado "EGOS" (lifetime); (4) acesso antecipado módulos futuros.
-> **Nome recomendado:** "EGOS: Governança de IA para Investigadores" · **Gate:** corte Enio no texto + verificação estatuto PCMG antes de qualquer cobrança.
-> **Produto:** lifetime access · Telegram aberto (gratuito, qualquer pessoa) · WhatsApp "EGOS" privado (pago) · Hotmart principal + multi-plataforma possível + egos.ia.br · unidades limitadas por plataforma · preço pode mudar a qualquer momento.
-
-- [ ] **COURSE-MVP-CONTENT-001** [P1] `voz`+`prime` `gated:HITL` 🔴 — Produzir conteúdo do MVP lote R$8: (1) roteiro da aula inaugural ("Por que GOVERNAR IA? O custo de confiar cego." — demo Guard Brasil pii-patterns.ts ao vivo, 45-60min); (2) PDF "O método EGOS em uma página" (extraído de AGENTS.md + RESOLVER_DOCTRINE.md + CLAUDE.md §0.5 — sem produção nova); (3) descrição do que o comprador recebe hoje vs roadmap. HITL: corte Enio no texto antes de publicar. NUNCA prometer o que é concept.
-- [ ] **COURSE-HOTMART-SETUP-001** [P1] `prime` `gated:HITL` — Configurar produto no Hotmart: (a) conta PF (verificar: Hotmart aceita sem CNPJ? sim, via CPF); (b) produto tipo "curso evolving" ou "produto digital"; (c) preço R$8 com label "Lote Fundador — pode subir a qualquer momento"; (d) Pix + boleto + cartão ativos; (e) lifetime access configurado; (f) webhook de pós-compra para adicionar ao WhatsApp privado. HITL: Enio valida a configuração antes de ativar.
-- [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram público "EGOS Framework" (aberto, gratuito, qualquer pessoa): (a) descrição do grupo; (b) regras de convivência; (c) link fixo para divulgação; (d) bot de boas-vindas automático (opcional). Tópicos: uso de IA com método, agentes, metaprompts, workflows, governança, segurança, automação, prompt engineering, AI-First, casos de uso, dúvidas do framework.
-- [ ] **COURSE-WHATSAPP-PRIVATE-001** [P1] `prime` `gated:HITL` — Configurar grupo WhatsApp privado "EGOS" (só quem pagou): (a) nome do grupo: "EGOS"; (b) escopo: discussão do EGOS Framework, metaprompts, agentes, workflows, casos de uso, dúvidas, roadmap, conteúdo em evolução — sempre com método, sem hype; (c) regras: sem vazamento de dados pessoais, sem casos reais sensíveis, uso ético; (d) mecanismo de adicionar pós-compra (webhook Hotmart → adicionar número via Evolution API ou manual). Gate: Enio aprova regras antes de criar.
-- [ ] **COURSE-PAYMENT-EASY-001** [P1] `prime` — Configurar pagamento com poucos cliques: (a) Hotmart checkout com Pix em destaque (instantâneo, sem taxa para comprador); (b) link direto para o produto (curto, fácil de copiar); (c) testar fluxo completo: clicar → pagar → receber acesso (deve ser < 3 cliques); (d) testar no celular (maioria vai comprar pelo WhatsApp/Telegram). Smoketeste obrigatório antes de divulgar.
-- [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade. Resultado do workflow (14 agentes): classificação completa em PUBLIC_DOCS/PUBLIC_DEMO/PRIVATE_CORE/PRIVATE_SECURITY/PRIVATE_PCMG/ARCHIVE/NEEDS_REVIEW disponível em docs/audit/repositories-public-private-classification.md (a criar). NENHUM repo abre ou fecha sem auditoria + HITL do Enio. Prioridade: qual repo público principal (candidato: egos-governance já público, mas enxuto — candidato principal para ser o hub educacional).
-- [ ] **COURSE-OWN-PLATFORM-001** [P2] `pixel`+`prime` — Pesquisar e configurar venda direta via egos.ia.br: (a) é possível aceitar Pix direto na plataforma própria? (Asaas PF: sim, taxa ~2.99% Pix); (b) criar página de produto em egos.ia.br/founders; (c) checkout simples (gera link de pagamento Asaas → paga → acesso automático); (d) vantagem: sem taxa de plataforma (vs Hotmart ~9.9%); desvantagem: sem audiência da plataforma. Recomendação esperada: Hotmart principal + egos.ia.br como opção direta.
-- [ ] **COURSE-CRYPTO-WALLETS-001** [P2] `prime` `gated:HITL` 🔴 — Configurar recebimento em cripto (BTC, ETH, Base, SOL, TRX). REGRA: NUNCA seed/private key em git ou qualquer doc versionado. Enio fornece os endereços públicos. Publicar APENAS endereços públicos na página de venda. Avisar: (a) volatilidade de preço; (b) confirmações necessárias antes de liberar acesso; (c) política de reembolso em cripto (recomendação: não reembolsar em cripto, converter para BRL equivalente); (d) tributação BR: declarar como renda (magistério/IP); (e) custódia própria é OK, exchange também — decisão do Enio. Gate: Enio aprova endereços antes de publicar.
-- [ ] **COURSE-SALES-PAGE-001** [P1] `voz` `gated:HITL` — Criar página de venda inicial em docs/business/founders-course-sales-page.md (gerado pelo workflow — revisar e finalizar). Critérios obrigatórios: (a) promessa honesta — sem "único no Brasil", "garantido", "transformação"; (b) o que recebe HOJE vs roadmap são claramente separados; (c) label "Preço pode mudar a qualquer momento — não há lotes fixos"; (d) lifetime access explícito; (e) FAQ com "O que acontece se o preço subir? Você já pagou — acesso garantido para sempre."; (f) formas de pagamento listadas; (g) corte do Enio antes de publicar.
-- [ ] **COURSE-LAUNCH-CONTENT-001** [P1] `voz` `gated:HITL` — Criar textos de divulgação (gerado pelo workflow — revisar e finalizar): WhatsApp/Telegram curto, LinkedIn, GitHub README snippet, thread X. Tom EGOS-entidade, nunca 1ª pessoa. Sem promessa financeira. Gate: Enio aprova antes de qualquer publicação.
-- [ ] **COURSE-PCMG-GATE-001** [P0] `redzone` 🔴 — Verificar formalmente se recebimento de pagamento por cursos via pessoa física é compatível com o estatuto do servidor PCMG. Liga BLOCKCHAIN-002-ETHIK-LEGAL (aberto). Magistério esporádico = OK por lei; venda direta via plataforma digital = verificar. Recomendação provisória: usar Hotmart (eles são a empresa que vende, Enio recebe como "produtor" — estrutura aceita pela maioria dos servidores públicos). HITL obrigatório antes de ativar qualquer cobrança.
-- [ ] **COURSE-DISTRIBUTION-MAP-001** [P1] `voz`+`curador` — Mapa de distribuição do curso: onde estar e por quê (resultado do agente rodando). Prioridade: Hotmart (vendas) → YouTube (funil gratuito) → LinkedIn (profissionais) → Telegram aberto → GitHub README → Instagram/TikTok (conteúdo curto). Criar docs/business/course-distribution-map.md.
-- [ ] **COURSE-PLATFORMS-MEMORY-001** [P1] `curador` — Pesquisar links e instruções ATUALIZADAS de configuração de memória em: ChatGPT, Gemini Gems, Claude Projects, Grok Memory, Google AI Studio, Antigravity GEMINI.md. Plataformas mudam interface — verificar antes de publicar. Salvar em docs/courses/plataformas-memoria-guia.md.
-- [ ] **COURSE-YOUTUBE-CHANNEL-001** [P2] `prime` — Estruturar canal YouTube EGOS: (a) nome do canal; (b) descrição; (c) trailer de 60s; (d) 3 primeiros vídeos curtos (3-5min) como conteúdo gratuito de topo de funil; (e) CTA para o curso pago. Canal = funil gratuito → pago.
-- [ ] **COURSE-LINKEDIN-STRATEGY-001** [P2] `voz` — Estratégia LinkedIn: (a) perfil EGOS ou Enio como autor? (b) posts semanais sobre uso prático de IA; (c) artigo de lançamento; (d) como aparecer para profissionais que buscam "IA no trabalho". Tom: trabalho-primeiro, sem carteirada.
-
-## 📖 README EGOS — OVERHAUL (inspirado no aiox-core 2026-06-05)
-> aiox-core README como referência de qualidade: hooks por IDE, "Comece Aqui 10min", CLI First hierarquia, badges, first-value binário, multilíngue.
-> SSOT do que aprender: docs/competitive-analysis/aiox-learnings.md (a criar)
-
-- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN no máximo opcional/secundário, NUNCA lidera nem bloqueia.** HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
-- [ ] **README-PUBLICO-PT-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07 "tudo PT": o README público (egos-governance) tem seções em INGLÊS ("Why This Exists" L120, comentários de código L179/L192, "Contributing" L262, "License" L272). Traduzir p/ PT-BR (Por que o EGOS existe / Contribuindo / Licença / comentários). Público-alvo é Brasil. HITL antes de push no repo público.
-- [ ] **README-HOOKS-TABLE-001** [P1] `curador` — Criar tabela de paridade de hooks EGOS por IDE (análogo ao aiox): Claude Code (completo — hooks pre/post tool, session, commands), Gemini CLI / Antigravity (GEMINI.md, sem hooks nativos), Codex CLI (AGENTS.md + skills, parcial), Windsurf (rules, parcial), Cursor (cursor-rules, sem hooks), ChatGPT/GPT (system prompt + memory, sem hooks). Salvar em docs/governance/HOOKS_IDE_COMPATIBILITY.md.
-- [ ] **README-FIRST-VALUE-001** [P1] `voz` — Definir "first-value EGOS" (binário, como aiox faz): configurar 1 metaprompt profissional + 1 agente respondendo do jeito certo em <= 10 minutos = first-value atingido. Incluir no README como metric de onboarding.
-- [ ] **README-MULTILINGUAL-001** [P2] `voz` — Criar README.en.md (versão EN do README principal). O EGOS tem público potencial fora do BR — governança de IA é tema global. Estrutura igual ao PT, tradução profissional (não automática).
-- [ ] **README-BADGES-001** [P1] `prime` — Adicionar badges ao README.md: CI status, typecheck status, security scan (R-SEC-001), license (MIT), bun version, node version, docs link.
-
-## 🎬 MODO GRAVAÇÃO + TUTOR MODULAR (Enio 2026-06-05)
-> Sessões estruturadas para gravar conteúdo: single-topic, tutor mode, tags AI-readable, x402.
-> autoresearch VPS interconectado mas sem cron ainda — wiring pendente.
-
-- [ ] **RECORD-MODE-001** [P1] `prime`+`pixel` — Criar skill `/record` que ativa "Modo Gravação de Episódio": título, objetivo, estrutura passo-a-passo clara, tutor mode ON, tags AI-readable geradas automaticamente, arquivo .md gerado ao final. Cada episódio = 1 problema, 1 tema, curto (~10-20min). Output: docs/episodes/{slug}.md + metadata.json.
-- [ ] **CONTENT-TAGGING-001** [P1] `curador` — Sistema de tags para todo conteúdo EGOS: topic, level (iniciante/intermediário/avançado), duration, price_tier, ai_readable: true, x402_endpoint. Cada módulo, artigo, episódio recebe tags. Permite que IAs encontrem e naveguem o conteúdo automaticamente.
-- [ ] **X402-INTEGRATION-001** [P2] `prime`+`guardiao` `gated:RedZone` — Implementar protocolo x402 no site EGOS: endpoints de conteúdo respondem HTTP 402 com instrução de micropagamento (Base/Solana/USDT), agente de IA paga, recebe conteúdo. Precisa: wallet configurada + smart contract simples + endpoint de verificação. Gate: BLOCKCHAIN-002-ETHIK-LEGAL precisa estar resolvido antes.
-- [ ] **X402-CONTENT-PRICE-001** [P2] `prime` — Definir tabela de preços x402 por tipo de conteúdo: episódio grátis (grátis, isca), módulo básico ($0.10 USDT), módulo avançado ($1 USDT), acesso completo ($5 USDT). AI agents pagam autonomamente. Humanos pagam via Kiwify/Pix. Publicar como endpoint público: egos.ia.br/api/content-catalog.
-- [ ] **EPISODE-EDITOR-PROMPT-001** [P1] `voz` — Criar metaprompt MP-EPISODE-EDIT-001: dado um transcript de sessão gravada, reorganiza em episódio coerente com: intro, problema, solução passo-a-passo, teste ao vivo, conclusão, tags. Output: roteiro final para edição + descrição para YouTube/Instagram.
-- [ ] **MCP-CONTENT-GATEWAY-001** [P2] `prime`+`hermes-ops` — Expor conteúdo dos MCPs via endpoint público com autenticação x402. Exemplo: GET /api/mcp/knowledge/modulo-01 → 402 → paga → recebe. Hermes MCP knowledge já serve conteúdo — adicionar layer de pagamento.
-
-## 🔬 GEM-HUNTER + PESQUISA CONTÍNUA (2026-06-05)
-> gem-hunter melhorado para descobrir frameworks, MCPs, papers, técnicas novas.
-
-- [ ] **GEM-HUNTER-IMPROVE-001** [P1] `curador`+`forja` — Melhorar gem-hunter para descobrir continuamente: novos frameworks de IA (aiox, LangGraph, etc.), novos MCPs, papers arXiv AI governance, técnicas cyber+OSINT, abordagens educacionais. Adicionar: filtro de relevância EGOS (alto/médio/baixo), novas fontes (arXiv, GitHub trending, HN, papers with code). SSOT: docs/gem-hunter/GEM_HUNTER_IMPROVEMENT_PLAN.md. 🧊CONGELADO
-
-- [ ] **CODEX-ADVERSARIAL-MATERIAL-001** [P2] `provador` — Após cada iteração do eval-loop que não atingir 7.5, enviar o material para revisão adversarial do Codex (GPT) e Antigravity (Gemini) para perspectiva externa. Usar prompts de docs/validation/prompts/. Registrar resultados em docs/validation/evaluation-results/.
-## 🌐 COMUNICAÇÃO + README (2026-06-05, blueprint em construção)
-- [ ] **COMM-BLUEPRINT-APPLY-001** [P0] `voz`+`pixel` `gated:HITL` — Aplicar o egos-communication-blueprint.md ao README.md principal. Critério: eval-loop score ≥ 8.0. HITL: Enio aprova antes de publicar. Depende de: workflow w08tv4z7k completar.
-- [ ] **METAPROMPTS-DISCOVERY-001** [P1] `curador` — Implementar sistema de metaprompts de descoberta em 5 camadas (Camada 0-4 do blueprint). Cada camada detecta "esta situação tem vantagem com EGOS?". Salvar em docs/metaprompts/discovery/.
-- [ ] **README-JSON-LD-001** [P2] `prime` — Adicionar JSON-LD (structured data) no README para que IAs o descubram via semântica: schema.org/SoftwareApplication, keywords, capabilities, pricing. Torna o EGOS machine-readable nativamente.
-- [ ] **SITE-AI-DISCOVERY-001** [P2] `pixel` — Adicionar ao egos.ia.br: (1) llms.txt (padrão emergente para IAs encontrarem conteúdo), (2) /.well-known/ai-plugin.json, (3) endpoint /api/content-catalog com preços x402. Torna o site descobrível por agentes autônomos.
-
-## 🎬 GRAVAÇÃO + EPISÓDIOS (2026-06-05)
-- [ ] **RECORD-SESSION-001** [P1] `prime` — Implementar skill /record: ativa modo episódio (título, objetivo, estrutura, tags AI-readable, tutor mode). Output: docs/episodes/{slug}.md + metadata.json. Cada episódio = 1 problema curto.
-- [ ] **EPISODE-001-SCRIPT-001** [P1] `voz` `gated:HITL` — Preparar roteiro completo do Episódio 1: "Configure seu agente no Google AI Studio em 10 minutos". Inclui: gancho, problema, passo-a-passo ao vivo, teste, conclusão. Pronto para gravar. HITL: Enio aprova script.
-- [ ] **EPISODE-TAGS-SYSTEM-001** [P2] `curador` — Sistema de tags para episódios: topic (agent, metaprompt, security, etc.), level, duration, price_tier, ai_readable, x402_endpoint. Aplicar retroativamente ao Módulo 1.
-
-## 💰 X402 + DESCOBERTA POR AGENTES (2026-06-05)
-- [ ] **X402-SPEC-001** [P2] `prime`+`guardiao` — Especificar completamente o x402 para o EGOS: endpoints, preços, formato de resposta 402, verificação de pagamento, quais conteúdos são gratuitos vs pagos. SSOT: docs/strategy/X402_INTEGRATION_SPEC.md. Depende de: BLOCKCHAIN-002-ETHIK-LEGAL.
-- [ ] **LLMS-TXT-001** [P1] `pixel` — Criar /llms.txt no egos.ia.br (padrão emergente 2025: arquivo que diz às IAs como usar seu site). Incluir: descrição do EGOS, capacidades, como usar, links para docs, metaprompts disponíveis.
-
-## 🔍 VALIDAÇÃO DE VALOR PÚBLICO (2026-06-04)
-- [ ] **CRYPTO-WALLETS-FILL-001** [P0] `prime` `gated:HITL` 🔴 — Enio fornece endereços públicos de recebimento cripto (BTC, ETH, Base, SOL, TRX/USDT) para preencher docs/business/founding-pass/crypto-payment-setup.md. NUNCA seed phrase ou private key. Só endereços de recebimento. Gate: Enio revisa antes de qualquer publicação.
-- [ ] **SOCIAL-COPY-APPROVE-001** [P0] `prime` `gated:HITL` 🔴 — Enio aprova copy completo (X.com thread 5 tweets + Instagram 3 posts + WhatsApp mensagem + Telegram) em docs/business/founding-pass/posts-ready-to-publish.md antes de qualquer publicação. Nada publica sem HITL.
-- [ ] **INSTAGRAM-CREATE-001** [P1] `prime` `gated:HITL` — Enio cria conta Instagram da entidade EGOS (username sugerido: @egos.ia). Configurar perfil, bio, foto (EGOS-entidade, não foto pessoal). Guia: docs/business/social-media/instagram-egos-setup.md.
-- [ ] **VALIDATE-AI-EXTERNAL-001** [P1] `provador` — Testar material público do EGOS com múltiplos modelos de IA (Claude/ChatGPT/Gemini/Grok) usando protocolo em docs/validation/ai-value-evaluation-protocol.md. Registrar avaliações. Usar feedback para melhorar o material antes de subir o preço de R$2 para R$4.
-- [ ] **SALES-PAGE-HTML-001** [P1] `pixel` — Converter docs/strategy/sales-templates/founding-pass-sales-page-v0.md em HTML responsivo e bonito para egos.ia.br/founders. Fundo escuro, responsivo, sem dependências externas, Pix em destaque.
-- [ ] **KIWIFY-SETUP-001** [P1] `prime` `gated:HITL` — Configurar produto na Kiwify após primeiras 5 vendas via Pix direto. Criar produto "EGOS Framework Founding Pass", configurar PIX como método principal, order bump opcional, webhook para automação de acesso.
-- [ ] **PUBLIC-REPO-CONTENT-001** [P1] `guardiao`+`prime` `gated:HITL` — Definir e publicar conteúdo no repo público (egos-governance) que impressione IAs e humanos que lerem: metaprompts, exemplos de uso, docs do framework, personas, etc. Nenhum dado sensível. HITL antes de tornar público.
-- [ ] **AI-EVAL-RUN-001** [P2] `provador` — Executar protocolo VALIDATE-AI-EXTERNAL-001 com pelo menos 3 modelos diferentes. Registrar resultados em docs/validation/evaluation-results/. Usar feedback para criar tasks de melhoria.
-
-## 💼 VISÃO DE NEGÓCIOS / COMÉRCIO — nova frente (Enio 2026-06-04, colab amigo)
-> Contexto: o EGOS tem pouca cobertura de negócios/vendas/marketing/lógica de mercado — área importante. O "Conselho Alpha" (8 lentes de negócio) vem de um AMIGO do Enio; ele vai trocar ideias e trazer a visão. Objetivo: ativar essas capacidades, distribuir aos agentes + metaprompts (via gerador). Fonte: `~/Downloads/ChatGPT-Agentes de Pensamento (2).md`. ⚠️ Projetos citados (Steak Patos/Pixel Art/WHITEHAND) são do amigo — HITL, não expor.
-- [ ] **BIZ-CONSELHO-ALPHA-001** [P1] `forja` — Construir modo `/conselho` (Banda Cognitiva de NEGÓCIO): 8 lentes (Bilionário, Marketing, Financeiro, Estratégico, Cliente, IA&Automação, Advogado-do-Diabo, Visionário) → veredito Aprovar/Ajustar/Rejeitar. Espelha `scripts/banda.ts` (sequencial ou paralelo). Cada lente = perfil com pergunta-chave própria. Input do amigo do Enio antes de finalizar perfis.
-- [ ] **BIZ-VOZ-GOVERNED-001** [P1] `voz` — Unificar Vitória/Bianca (2 versões soltas) num ÚNICO agente Voz governado (template EGOS: função/escopo-pode/escopo-nunca/gatilho/output/aceite/Red Zone). Marketing, branding, growth orgânico, storytelling. Red Zone: nunca publicar/prometer resultado financeiro/usar dado de cliente real sem aprovação.
-- [ ] **BIZ-METAPROMPTS-001** [P1] `curador` `gated:BIZ-CONSELHO-ALPHA-001` — Gerar metaprompts de negócio VIA o gerador (`apps/api/src/routes/meta-prompts.ts` + módulo): MP-MARKETING, MP-SALES, MP-MARKET-LOGIC, MP-BIZ-MODEL, MP-PRICING (Red Zone). Salvar em `docs/metaprompts/` + eval golden. Loga PROCESS-METAPROMPT-LOOP-001.
-- [ ] **BIZ-CAPABILITIES-001** [P2] `prime` — Registrar capacidades comerciais (vendas/marketing/lógica-de-mercado/business-model) no `docs/CAPABILITY_REGISTRY.md` + distribuir aos agentes relevantes (Voz, Curador, Prime, Conselho). Cada uma com evidência (R-CAP-001, não inflar).
-- [ ] **BIZ-FRIEND-COLLAB-001** [P2] `redzone` — Estruturar colaboração com o amigo (dono do Conselho Alpha): como ele contribui a visão de negócios ao EGOS, escopo, e proteção dos projetos dele (Steak Patos/Pixel Art/WHITEHAND não expostos). Corte Enio + amigo.
-
-## 🍽️ ITEM-INTAKE — cardápio/foto → planilha PDV (sessão 2026-06-03, Opus)
-
-> Microfeature p/ demo Diesom (Kyte): foto/PDF de cardápio → planilha no formato do PDV + relatório de conferência (HITL). MVP ~90%. Capability `CAPABILITY_REGISTRY §109`. Pacote: `packages/item-intake/`. Commits: e042eb86 · 5cad3274 · 15e145a2 · 7d49851f. Validado: Cafeteria Santiago 56/56 itens; verificador família-diferente (gpt-4o-mini) pega erro confiante do Mel; schema modular por perfis (kyte/egos); 31 testes; interface web; robustez foto degradada 11/11. Arquivos p/ Enio testar: `~/Downloads/KYTE-cardapio-santiago-PRONTO.xlsx` (upload Kyte) + `item-intake-DEMO.html` + `item-intake-Diesom.zip`.
-
-- [ ] **ITEM-INTAKE-PHOTOS-001** [P1] `forja` 🆕 (Enio 2026-06-03) — Preencher FOTO por produto automaticamente: LLM (OpenRouter) gera a query por tema do item → busca em banco público (Unsplash API → Pexels API, fallback) → se nada bom, GERA imagem (modelo de imagem via OpenRouter) → fallback placeholder. HITL: pré-preenche, pessoa troca pela dela. Flag `--photos` no item-intake. Recomendação: banco real PRIMEIRO (foto de comida real > IA, que fica uncanny).
-- [ ] **ITEM-INTAKE-WEB-RETRY-001** [P2] `forja` — Web errou com "Unable to connect" (hiccup transitório OpenRouter; CLI funcionou no mesmo PDF). Adicionar retry de fetch (network-level, backoff) + mensagem de erro melhor na UI. extract.ts já tem retry de parse, falta retry de conexão.
-- [ ] **ITEM-INTAKE-VERIFIER-SEMANTIC-001** [P2] — Verificador checar PLAUSIBILIDADE semântica (ex: chantilly R$12,75 como adicional = suspeito), não só consistência entre 2 leituras.
-- [ ] **ITEM-INTAKE-SIZE-VARIATION-001** [P2] — Preservar Médio/Grande (Pequeno/Grande) como VARIAÇÃO em vez de colapsar em 1 preço.
-- [ ] **ITEM-INTAKE-MANUSCRITO-001** [P2] — Testar robustez com cardápio MANUSCRITO (sem amostra ainda). Foto de impresso já robusta (11/11). Pedir/gerar amostra real.
-- [ ] **ITEM-INTAKE-KYTE-MAP-001** [P2] — Alinhar com time Kyte (Diesom): "adicional" vira produto ou modificador? variações P/M/G no modelo nativo do Kyte? Decide schema final.
-- [ ] **ITEM-INTAKE-WEB-HARDEN-001** [P2] `gated:decisão` — Hardening da interface web (`src/server.ts`): auth + fila + deploy (Hermes/VPS) p/ virar link público. Hoje é demo local.
-- [ ] **ITEM-INTAKE-KYTE-API-001** [P3] `gated:ITEM-INTAKE-KYTE-MAP-001` — Integração DIRETA com o Kyte (em vez de planilha p/ import manual): "botão importar do cardápio (foto/PDF)" dentro do Kyte — cobre o fluxo "Foto (em breve)" que o Kyte já marca na tela de import. Depende de API/parceria Kyte.
-- [ ] **ITEM-INTAKE-DEDUP-001** [P3] — Dedup contra catálogo existente ao importar (evita produto duplicado). O import do G Peças já tem (`find_similar_products` RPC em `central-egos/template`); item-intake só gera planilha, não checa duplicata. Reusar o padrão quando escrever em catálogo vivo.
-- [ ] **ITEM-INTAKE-VAR-PRICING-001** [P3] — Preço POR variação (ex: Frappuccino P R$20 vs regular R$23; tamanhos com preços diferentes). Hoje `variacoes` é só texto (sabores juntados); falta modelar preço por opção.
-- [ ] **ITEM-INTAKE-3WAY-001** [P3] — Maior automação: 3ª leitura/voto de desempate quando 1ª e 2ª divergem (hoje vira conferência humana). Reduz o nº de itens a conferir sem perder a trava HITL.
-- [ ] **ITEM-INTAKE-GENERIC-001** [P2] `strategy` — Generalizar p/ QUALQUER pequeno negócio (farmácia, papelaria, autopeças, bar): o extrator já é genérico; o que muda é o perfil de saída (`profiles/*.json`). Isto é a VISÃO de produto — "lista bagunçada → catálogo pronto" como porta de entrada barata. Liga [[project_item_intake_kyte]] + GTM.
-- [ ] **ITEM-INTAKE-PUBLIC-REPO-001** [P3] `gated:TOOLS-HUB-001` — Extrair `packages/item-intake/` como módulo standalone (repo público / npm `bunx`) p/ compartilhar fora do monorepo. Decisão: parte do tools-hub ou repo próprio.
-- [ ] **NLM-ITEM-INTAKE-001** [P3] — Criar notebook NotebookLM do item-intake (T1: todo repo/produto ativo tem notebook; hoje é gap). Fonte = README + STATUS + META_PROMPT.
-- [ ] **ITEM-INTAKE-SYSTEMMAP-001** [P3] — Referenciar `packages/item-intake/` no SYSTEM_MAP (drift menor detectado no /end).
-
-> **Ideias capturadas / DEFERIDAS (não virar task agora — registro p/ não perder):**
-> (a) Decompor o pipeline nos 5 agentes EGOS que o ChatGPT propôs (Hermes Intake / Extrator / Normalizador / Guardião / Provador) — o monólito atual funciona e é simples (Karpathy: não decompor sem necessidade). Reabrir só se escalar p/ multi-fonte/fila. (b) `Cafeteria Santiago` (cafeteria da esposa do Enio, unidade Rosário) = caso real / possível cliente-referência/demo do item-intake.
-
-## 🧰 TOOLS HUB — reunir todas as tools EGOS (Enio 2026-06-03)
-
-> "já temos várias tools, reunir todas, jogar em egos.ia.br/tools". Precursor: inventariar antes de construir o hub.
-
----
-
 ## 🤖 AGENT ORG — sessão 2026-06-02 tarde (mapa + F3 + F4, Opus)
 
 > Fechou o triângulo de organização de agentes: ORGANIZATION (QUE) + TOPOLOGY (ONDE) + **AGENT_MAP (COM-O-QUÊ)**. SSOT: `docs/governance/EGOS_AGENT_MAP.md`. Commits: bb315c33 · f019e98a · 511f0ff5 · 5974288c · 1666d0c1 · d61106bc.
@@ -467,57 +355,6 @@
 - [ ] **NEON-PROMOTE-001** [P2] `prime`+`provador` — (futuro, SE mantivermos neon) Promover candidato→verified: ≥3 golden cases `tests/eval/capabilities/CBC-NEON-*` provando o pipeline 9-etapas (STEPPS/Fogg/ABCD), entrada `triggers.json` (upstream Prime, downstream Voz+Provador, peers `*`, gates), `guardrails.yaml` (kind:agent, L3.hitl). Só então remove `agent_candidate`.
 - [/] **TASKS-ROADMAP-001** [P1] — Mover pending de longo prazo p/ `docs/strategy/ROADMAP.md` (TASKS.md > hard-limit 600, grace até 2026-06-15). Archive só remove done. **PARCIAL 2026-06-03 (Prime):** bloco AUTORES v2 Fase 0-4 movido (895→796L, 9 tasks). Resto = corte do Enio sobre quais P1/P0 abertos deferir (não deferir unilateralmente).
 
-## 🎯 LOOP DE AQUISIÇÃO + ENTREGA #3-#7 — North Star (council 2026-05-30)
-
-> **SSOT:** `docs/strategy/EGOS_DISTRIBUTION_STRATEGY_REVIEW.md` · review externo: `docs/drafts/council_maio2026.md`
-> **Decisão do council (ChatGPT+Gemini+Perplexity+Codex convergiram):** **A = objetivo** (distribuir o PRODUTO → mais clientes) · **C = P0** (replicabilidade comercial: kit de vender+entregar rápido) · **B = P2** (distribuir o FRAMEWORK: CLI/npx/OSS — adiado).
-> **🔄 CORTE ENIO 2026-05-30 — B REATIVADO P1 (canal de conexão, NÃO devtool de receita):** o posicionamento "arquiteto de IA" (ver [[user_enio_positioning]]) transforma a distribuição aberta na **gravidade que atrai conexões/parcerias**. A receita vem das implementações/arquitetura/parcerias, não de vender o framework. Por isso B sobe de P2→P1 — mas com sentido novo: canal de conexão, não produto. O risco que o council viu (adoção≠receita) não se aplica igual: a receita nunca foi prevista vir da adoção, vem da relação que a adoção cria.
-> **Frase-âncora (atualizada):** "EGOS só vira framework público depois que virar processo privado lucrativo" continua valendo para o **lado receita-do-framework** (não vamos cobrar pela adoção). Mas a **distribuição como convite/conexão** pode começar agora.
-> **Gargalo real:** não é instalação por dev — é **venda repetível com entrega previsível** (A/C). B serve para **dar as caras e chamar pra conversa**, não para fechar venda.
-
-**🟢 CORTE ENIO 2026-05-30 — divulgação dia 31 (Opção 2):**
-- **Página = Opção 2:** construir `bunx egos` (o que existe de verdade) ANTES de recriar a página. Arrumar o máximo fundamental hoje/amanhã, divulgar **2026-05-31**.
-- **DEC-PRICE-001 ADIADO de propósito:** divulgar SEM número. A página/divulgação **só chama pra conversa** — zero pricing público agora. Pricing volta à pauta depois.
-- **Nova frente — pesquisador por resultado + NDA:** Enio explora trabalhar como **pesquisador para a equipe de um contato** — remuneração por resultado/KPI (avaliar se o sistema que ele traz gera melhoria mensurável num período), com NDA. É uma forma de troca justa coerente com [[enio-fair-value-receive]] — receber pelo valor entregue e avaliar encaixe via desempenho. Captado em CAQ-RESEARCHER-001.
-
-> **🔴 CORTE ENIO 2026-06-02 — PIVÔ DE DIREÇÃO (rebaixa o North Star storefront/SaaS):**
-> - **"Não quero fazer SaaS, não quero vender dessa forma."** O loop de aquisição storefront (G Peças/Ferro Velho como produto vendável) está **DESPRIORIZADO**. Mercado já tem incumbentes baratos/avançados — Kyte (R$49,90–99,90/mês, PDV mobile-first AI-assisted, 1M+ downloads, 40k+ lojas, aporte R$5,5M) cobre o mesmo espaço por preço que não dá pra competir. Lição Kyte registrada: **não vender "IA"; vender alívio de dor operacional concreta** → no universo do Enio = "pare de perder contexto / cruze info / timeline auditável / relatório com lastro" (forense/OSINT), não "loja com IA". Ver [[project_kyte_benchmark_strategy]].
-> - **NOVA DIREÇÃO (frontier ativo):** participar de **equipes** (não construir sozinho), aprender com pessoas. Pré-requisito = **confirmar + melhorar a stack de CIBERSEGURANÇA + OSINT + forense** ("ter bastante coisa já desenvolvida") → daí avançar **cursos** (Ciber+IA+LGPD p/ polícia) + **OVM**, tudo interligado. Coerente com career-fit F1 (investigador-arquiteto/forense-cripto venceu) [[project_career_fit_f1_decision]] e posicionamento arquiteto-de-IA [[user_enio_positioning]].
-> - **Modo de decisão:** "vamos decidindo na medida que avançamos" — Prime survey→propõe→Enio corta, incremental. Tasks relevantes: GUARD-STD-*, BLOCKCHAIN-STACK-001 (chain-of-custody IA), SEC-AGENT-SCOPE-REBUILD-001, CYBER-KB-002, COURSE-LGPD-001, REPORT-005/006/007 (intelink forense), gem-hunter on-chain, eval-runner (prova de capacidade).
-
-- [ ] **CAQ-RESEARCHER-001** [P1] `nova-frente` — Estruturar proposta "pesquisador por resultado" p/ o contato: definir KPIs avaliáveis, período de avaliação, modelo de ganho por melhoria entregue, NDA. Coerente com troca-justa [[enio-fair-value-receive]]. Aguarda Enio nomear o contato/contexto.
-
-> **B → P1 (REATIVADO como canal de conexão, 2026-05-30):** `bunx egos` + página-convite + GitHub público são **gravidade pra conexão/parceria**, divulgação dia 31. NÃO inclui: cobrar pela adoção, comunidade/suporte de devtool, "99.999%", create-egos-app completo — isso continua P2 até A medido. O EGOS-PUBLIC Plano Mestre v3 (abaixo) permanece P2 (é o pacote devtool completo); o que sobe a P1 é só o mínimo honesto pra divulgar (CAQ-CLI-001 + CAQ-PAGE-001).
-
----
-
-## 🩺 PLAN v4 SURGERY 2026-05-28 (post-Codex 5.5 RED verdict)
-
-> **SSOT:** [docs/strategy/PLAN_v4.md](strategy/PLAN_v4.md)
-> Codex 5.5 medium recusou as 11 tasks derivadas do premortem como "net negative".
-> Aplicado: **3 gates** (FREEZE /start+pricing | CAP Enio decisões/semana | EXTERNAL INDICATOR antes publish).
-> **Resultado:** -5 DELETE + -12 DEFER + 0 ADD = -17 net work-in-progress.
->
-> Tasks abaixo marcadas:
-> - `[DEFER-GATE-A]` = bloqueada até EGOS-PUBLIC done
-> - `[DEFER-GATE-B]` = bloqueada por Enio capacity cap (próxima semana)
-> - `[DEFER-GATE-C]` = bloqueada até external adoption indicator
-> - `[DELETE]` = canceled (YAGNI ou gold-plating identificado)
-> - `[KEEP-7d]` = executar nos próximos 7 dias
->
-> Próxima revisão binária: **2026-06-04** (1 semana).
-
-## 🚨 EGOS-PUBLIC — Plano Mestre v3 (Opus 2026-05-28 + Codex + premortem)
-
-> **⏸️ REBAIXADO P2 (council 2026-05-30):** isto é caminho **B** (distribuir o framework). Adiado até A medido e vendendo — ver North Star no topo. Não executar antes do gatilho (devs pedindo OU gargalo de implantação medido).
-> **SSOT:** `docs/strategy/EGOS_PUBLIC_PLAN.md` | **Premortem:** `docs/audits/premortem-egos-public.md`
-> **Tese:** "Governance OS for Agentic Software Delivery" — 1 repo, 3 subpastas (docs/starter/packages)
-> **Time-box:** 8h hard cap, after-hours only (proteger Dual Pursuit)
-> **Red Zone:** Fase 12 (push público) requer aprovação explícita Enio
-
-**Estimativa total:** ~10h Sonnet + ~3h Opus = 13h ativos + 7-dia review window.
-
----
 
 ## 🌊 ONDAS 1-4 — Plano de Ação 2026-05-27 (Opus arquitetou + Codex revisou)
 
@@ -581,76 +418,6 @@
 - [ ] **CTX-ROTATION-002** [P1] `redzone→prime` — **Blackboard + worktree-per-agent (resolve a fricção real: race no `.git/index` compartilhado).** Pesquisa (UNVERIFIED, fontes em handoff): SQLite-WAL como SSOT de estado compartilhado (agente ativo, score de saúde de cada um, claims de task/file, last-constitution-read) + inotify/NATS p/ notify near-instant; **um `git worktree` por agente** (já temos EnterWorktree) elimina colisão de `index.lock`; claim→write→verify otimista (CRDT-style) antes de editar; event-log append-only p/ re-seed de agente que reinicia frio. Refs: Chroma "context rot" (degrada bem antes do limite), arXiv 2510.01285 (blackboard +13-57%), 2510.18893 (CodeCRDT), 2406.00799 (activation-delta = só self-hosted).
 - [ ] **CTX-ROTATION-003** [P2] `prime` — Onde mora a camada: estender `egos-governance` MCP (já tem `agent_status`/`repo_health`/`ssot_drift_check`) com `constitution_health_probe` + `coherence_state`, ou MCP novo `egos-coherence`. Decisão de arquitetura (Red Zone). Reusar `egos-observability` p/ telemetria ao vivo.
 
-## 🛡️ RESOLVER DOCTRINE — Prime como última camada + triagem matemática (2026-06-01)
-
-> SSOT: `docs/governance/RESOLVER_DOCTRINE.md` (v1.0). Wired: kernel CLAUDE.md + /start (item 11) + /end (item 5) + memory `feedback_resolver_doctrine.md`. SHAs: ver commit desta sessão.
-- [ ] **RESOLVER-002** [P2] `prime` — Surface mecânico opcional: eco de 1 linha da doutrina no pre-commit (lembrete de postura) OU helper `scripts/triage.ts` que computa R=L/C dado Impact/Fit/Urgency/Effort/CtxSwitch. Avaliar se vale (a doutrina é cognição do Prime, não gate). Decidir via própria triagem.
-- [ ] **RESOLVER-003** [P3] `prime` — Replicar/sincronizar agentes do Guarani (Antigravity) no Claude Code: mapear arquivos compartilhados (nomes/lugares podem diferir), orquestrar subagentes, ir melhorando. Diretiva Enio 2026-06-01.
-
-## 🔱 HERMES OPS + MCP HEALTH — inventory + triage (2026-06-01 Prime)
-
-> SSOT: `docs/_current_handoffs/handoff_2026-06-01_prime-hermes-ops.md` + memory `session_2026-06-01_hermes-ops-bot-openai`. Watchdog fix em `b73cb61d` (origin).
-- [ ] **BERNARDO-PW-001** [P2] `prime` — Setar `BERNARDO_PASSWORD_SHA256` em prod p/ rotacionar o default documentado `bernardo2026` (server-side, `central-egos/template/src/app/api/bernardo-guide/route.ts:12`).
-
-## 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA — sessão 2026-06-04 (Guarani)
-- [ ] **HERMES-DESKTOP-002** [P1] `pixel` 🆕 — Implementar a UI React dos 5 painéis estendidos (Status, Roster, Audit, Blackboard, Dispersion/Costs) no Hermes Desktop.
-- [ ] **HERMES-DESKTOP-SANDBOX-001** [P2] `5min` — Corrigir sandbox Electron para lançar app nativo: `sudo chown root:root ~/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/chrome-sandbox && sudo chmod 4755 [...]`. Requer terminal com TTY. Alternativa: usar dashboard web em localhost:9119.
-- [ ] **AGENT-AVATARS-001** [P2] `pixel` 🆕 — Criar componente React para geração de avatares etéreos SVG a partir das chaves públicas dos agentes.
-- [ ] **AUDIT-CRYPT-001** [P1] `prime` 🆕 — Implementar o helper de geração de par de chaves e assinatura off-chain secp256k1 para relatórios e commits.
-- [ ] **AUDIT-NOSTR-001** [P2] `prime` 🆕 — Publicação descentralizada de identidades no Nostr (NIP-05) e provas temporais no Bitcoin via OpenTimestamps.
-
-## 🌐 SITE egos.ia.br — Reposicionamento "Arquiteto de IA" + i18n PT/EN/ZH (2026-06-01)
-
-> **Diagnóstico (2 Sonnet agents 2026-06-01):** Site atual NÃO reflete o foco. Source = `apps/egos-landing` (Vite+React 18); produção egos.ia.br servida por `apps/egos-site` (Hono) no VPS via Caddy (`/opt/bracc/infra/Caddyfile`). Copy atual é vendor/SaaS ("IA governada p/ empresas", 4 produtos, pricing, "pagamento após entrega") — NÃO a narrativa "arquiteto de IA / convite via GitHub". ZERO i18n (tudo `lang=pt-BR`). `docs/strategy/LANDING_OBJECTIONS.md` (DRAFT) tem 10 objeções não resolvidas.
-> **Red Zone:** toda copy pública + pricing + design → corte do Enio. Nada publicado sem HITL.
-- [ ] **SITE-I18N-001** [P1] `prime` — Implementar i18n PT(default)/EN/ZH-Simplified. **Recomendação (Sonnet research):** Paraglide JS (inlang) + MT via próprio `packages/shared/llm-router` (Gemini 2.5 Flash — 2.0 desliga 2026-06-01). Soberania total (traduções in-repo, chaves próprias), ~$0, bundle mínimo. Fallback: Tolgee self-hosted se precisar UI p/ revisor humano.
-- [ ] **SITE-I18N-ZH-GATE-001** [P1] `redzone` — Gate de revisão humana p/ Chinês: glossário (EGOS, soberania, vocabulário forense/policial) + nunca auto-publicar ZH sem revisão (LLM-MT erra terminologia). Honra Red Zone.
-
-## 🎨 SITE — Essência, voz, 3 opções de design, EGOS interativo (corte Enio 2026-06-01)
-
-> SSOT essência: memory `project_egos_brand_essence_site.md`. EGOS = equilibrar o ego (não vencer), nomear/posicionar. Público = users Claude Code/Windsurf (literatos) + novatos curiosos. Site canônico = `apps/egos-site/src/server.ts` (já tem EN parcial). Tom do 1º draft REJEITADO. Tudo aqui é Red Zone (copy/design pública) → corte do Enio.
-- [/] **SITE-VOICE-001** [P1] `redzone` `research` — ✅ DRAFT 2026-06-02 (Sonnet pesquisou Linear/Resend/Railway/Supabase/Anthropic): `docs/strategy/EGOS_VOICE_GUIDE.md` — 5 princípios + 3 headlines draft + 5 perguntas pro Enio. **Resta: corte do Enio** nas headlines + 5 perguntas (língua, quanto do Enio, ego-balance público, proof status, PCMG no texto).
-- [ ] **SITE-DESIGN-3OPT-001** [P1] `redzone` — Produzir 3 opções de homepage: 2 tradicionais (baseadas nas melhores/mais inovadoras/bonitas páginas do mundo, adaptadas à essência EGOS) + 1 novidade (EGOS-interativo-first). Design comigo em código (não Figma). Apresentar p/ corte do Enio.
-- [ ] **SITE-EGOS-WIDGET-001** [P1] — Widget "arquiteto EGOS" interativo: termos marcados no texto → hover abre suavemente caixinha com EGOS respondendo, com conhecimento do framework inteiro + constituição + regras. Embeddable/distribuível em vários lugares. Tela inicial já permite interação rápida. Depende de LLM-BENCH-001.
-- [ ] **SITE-TRUST-MATH-001** [P1] `redzone` — Mecanismo de confiança "provada com matemática": prompts públicos auditáveis + verificação (hash/transparência formal) que mostra que não há nada malicioso. Definir o que "prova matemática" significa aqui e como exibir na UI.
-- [/] **CURRICULUM-001** [P1] `redzone` — Currículo/posicionamento do Enio. **Substância aprovada Enio 2026-06-01**, SSOT persistido `docs/strategy/ENIO_CURRICULUM_POSITIONING.md` (identidade "investigador-arquiteto"; frase "não vendo hora de perito" CORTADA). Pendente: corte final da versão expandida + aterrissagem na seção "Sobre". Respeita estatuto PCMG (IP/magistério/advisory).
-
-## 📝 ARTIGOS / TIMELINE — melhorar módulo + escrever artigo no tom investigador-arquiteto (Enio 2026-06-01)
-
-> Módulo = Timeline AI Publishing System. Rota `egos.ia.br/timeline` (PT+EN). Hoje só 1 artigo. Standard: `docs/social/ARTICLE_VOICE.md` + `ARTICLE_TEMPLATE.md` + `docs/modules/TIMELINE_AI_PUBLISHING_ARCHITECTURE.md`. Tudo Red Zone (público) → corte do Enio antes de publicar.
-- [/] **ARTICLE-RULES-001** [P1] — Melhorar regras de geração de artigo (VOICE+TEMPLATE) p/ público Claude Code/Windsurf + novatos curiosos; tom explicativo+confiável; confiança via matemática/auditabilidade. (Sonnet propondo edições; Opus revisa.)
-- [/] **ARTICLE-002** [P1] `redzone` — Escrever artigo #2 no tom investigador-arquiteto: explicar+mostrar+validar EGOS. Evidence-first (citar só o que existe no repo). HITL antes de publicar. (Sonnet redigindo draft; Opus revisa Red Zone.)
-- [ ] **ARTICLE-MULTIMEDIA-001** [P1] — Multimídia do artigo via NotebookLM MCP (integração já existe): slides (assinatura visual obrigatória — VISUAL_IDENTITY.md), vídeo, áudio, imagens. HITL para deleção/publicação (NotebookLM §4). Pensar imagens junto do texto.
-
-## 📊 CAREER-GAP — Capacidade em % vs topo do mercado (evidência > credencial) — Enio 2026-06-01
-
-> Tese: pular cursos/certificados e PROVAR capacidade com número, código, arquitetura, testes, health, uptime. Mirar o MELHOR currículo (topo), depois descer tiers. Liga a CURRICULUM-001 + CAREER_FIT_STUDY §2. Red Zone (posicionamento) → corte do Enio.
-- [/] **CAREER-GAP-001** [P1] `redzone` `research` — Matriz % de cobertura de capacidade vs requisitos do role top (F1: forense on-chain + arquitetura/segurança IA): cada requisito → % coberto → evidência real (artefato/número do repo) → se exige cert, provar que evidência substitui. + overall % por tier + tese credential-skip evidenciada + gaps honestos (ex: uptime não medido → construir status page público). (Sonnet pesquisando; Opus sintetiza/corta.)
-
----
-
-## 🔍 SEO ENGINE (Gabi) — 2026-05-29 (Frente B / consultoria)
-
-> **Decisão (Enio 2026-05-29):** Opção 1 (Skills+MCPs terminal-first) · Feature #1 keyword→temas · Foco Gabi (validação real).
-> **Docs SSOT:** `docs/strategy/SEO_ENGINE_PROPOSAL.md` (proposta técnica+comercial, tabela 14 ferramentas, fontes) · slides: `docs/presentations/SEO_GABI_notebooklm.md`. Pesquisa-base: `docs/drafts/grokSEMrush.md`.
-> **Tese:** motor de dados reusável → vira dashboard depois se validar. NÃO construir API mestra/multi-tenant pré-1ª venda (gate Karpathy).
-> **On-ramp $0 (2026-05-29, pós-pesquisa):** começar GRÁTIS (GSC + Keyword Planner faixas + Trends + free tiers SERP). DataForSEO é o DESTINO (MCP oficial TS, 10k kw≈US$1,10), não o ponto de partida — depósito $50 só na Fase 1, sem gate financeiro no MVP.
-> **Diferencial vs SEMrush:** visibilidade em IAs (GEO) — fase 2, SEMrush é cego nisso (Princeton arXiv:2311.09735: 43% páginas sem citação IA).
-
-- [ ] **SEO-MVP-003** [P1] `2h Sonnet` — GSC API (grátis, OAuth) se Gabi/cliente tem site → dados reais de ranking/CTR/posição.
-- [ ] **SEO-MVP-005** [P2] `validação` — Rodar `/keyword-temas` com tema real da Gabi → ela confirma se elimina os "3 dias de trabalho". Gate de decisão para Fase 1 (DataForSEO) e Opção 2 (dashboard).
-- [ ] **SEO-F1-001** [P1] `gate-humano` — FASE 1 (só após SEO-MVP-005 validar): criar conta DataForSEO + depósito $50 (requer Enio: login+cartão; crédito não expira) + adicionar MCP oficial `dataforseo/mcp-server-typescript` + smoke 1 query real. Registrar em INTEGRATION_REGISTRY + MCP_REGISTRY.
-- [ ] **SEO-GEO-001** [P2] `defer` — FASE 2: visibilidade em IAs (DataForSEO AI Optimization / LLM Mentions API, ~US$100/mo). Diferencial premium; só após MVP validado.
-
----
-
-## 🧭 REGISTRY PARITY — 2026-05-27 (Sonnet executou, Opus revisa)
-
-> **SSOT:** `docs/governance/REGISTRY_PARITY_DECISION.md` + `.registry-grace.yaml` + `scripts/check-registry-parity.sh`
-> **Gate novo:** `.husky/_checks/13-registry-parity.sh` (hard-fail em NEW staged adds; legacy = warn).
-
----
-
 ## 🔄 HERMES LOOP CLOSURE — Fechar ciclo post-commit review → ação (2026-05-26)
 
 > **Contexto:** 243.341 entradas no review-queue (545 commits × cron 446x). 9.5% HIGH (~23k findings) dormindo no JSONL. Loop atual: `commit → Gemini → JSONL → 💀`. Plano: fechar loop em pipeline integrado Hermes + Autoresearch.
@@ -697,116 +464,6 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
 
 ---
 
-### 🟢 CROSS-REPO MONITORING (NOVO 2026-05-26)
-
-- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P2] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
-  - Lista repos via `gh repo list enioxt --limit 100`
-  - Para cada TIER 1: `git -C $dir fetch origin` + check drift
-  - Output: "N repos drifted · K repos com commits novos · M repos com tasks P0 pendentes"
-  - **Dep:** REPO-INVENTORY-001 define quem é TIER 1
-
-  - 14 repos TIER 1+2 auditados; audit em `docs/governance/README_AUDIT_2026-05-26.md`
-  - 3 drafts P0 criados: `docs/drafts/README-omniview-v2-*.md`, `README-forja-v2-*.md`, `README-marizanotto-videos-v2-*.md`
-  - HITL pendente: Enio aprova drafts → aplicar nos repos alvo
-
-- [ ] **CROSS-REPO-README-UPDATE-001** [P1] `8h` 🆕 — Atualizar READMEs baseado em audit
-  - Trabalho iterativo por repo TIER 1
-  - Cada update segue padrão ouro
-  - HITL: Enio aprova draft antes de commit em cada repo
-  - Sub-tarefas P1 identificadas pelo audit 2026-05-26:
-    - [ ] **README-HERMES-EGOS-PT-BR** `2h` — adicionar seção PT-BR ao README do fork NousResearch explicando escopo EGOS
-    - [ ] **README-EGOS-LAB-CHAT-EXPAND** `1h` — expandir README 97L (falta arquitetura + variáveis de ambiente)
-
-- [ ] **CROSS-REPO-TASKS-SYNC-001** [P1] `3h` 🆕 — Consolida TASKS.md de todos repos
-  - Script lê TASKS.md de cada TIER 1 repo
-  - Gera `docs/COORDINATION.md` com snapshot semanal
-  - HITL: revisão no `/end` domingo
-
-- [ ] **REPO-INVENTORY-001** [P2] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
-  - Output: `docs/governance/REPO_INVENTORY_2026-05-26.md`
-  - Decisão arquitetural: TIER 1/2/3 para Autoresearch + monitoring
-
-### Dependências
-```
-DEDUP-001 → SCHEMA-001 → MIGRATE-001 → REGEX-001 → CONSUMER-001 → {TELEGRAM-001, TASKS-001}
-CONSUMER-001 → PATTERNS-001 → LIFECYCLE-001 → BLOCK-001 → DASHBOARD-001
-PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-001
-```
-
-### Riscos identificados (Codex audit)
-1. **Blast retroativo dos 23k HIGH** — mitigado via digest inicial (HERMES-TELEGRAM-001)
-2. **AUTORES editar CLAUDE.md** — mitigado via arquivo separado (AUTORES-PROPOSE-001)
-3. **Pre-commit bloquear por LLM (falsos positivos)** — bloqueios só por regex determinístico OU regra humana aprovada
-4. **Cron sem dedup amplifica lixo** — mitigado via HERMES-DEDUP-001 como gate absoluto
-
----
-
-## 🪟 SEPARAÇÃO DE JANELAS (2026-05-22)
-
-### 🏛️ JANELA STOREFRONT/GOVERNANCE (esta) — foco
-**Escopo:** SSOT `central-egos/template/` + governance docs + storefront UX + imagens R-IMG-001 + DB Discipline.
-**Regra:** ZERO commits em `central-egos/clients/<slug>/` (R-DB-004 enforcement).
-**Entregue 2026-05-22 (16 commits):** INC-DB-001 governance + 7 fixes UX + Magalu layout + 16 fotos ChatGPT + tenant phone fix + isDemoMode FVP + AGENTS §R8 propagado.
-**Pendente:** UX-ADMIN-FEATURED, UX-PROMO-VISUAL, UX-MAGALU "Mais vendidos" real, paginação, 29 fotos restantes.
-
-### 🟡 JANELA GPECAS/COMMERCIAL (outra) — handoff
-**Escopo:** pricing/onboarding/contrato gpecas + APIs ops (INV-MON-003..007) + dashboard sales.
-**Handoff:** `docs/_current_handoffs/handoff_2026-05-22-gpecas-pricing-onboarding.md`
-**Entregue 2026-05-22 (3 commits):** PRICING_SSOT v3.2 + CLIENT_ONBOARDING_CHECKLIST + /novodemo skill.
-**Pendente:** CET-CONTRATO-001, CET-DASHBOARD-SALES-001, CONTACT-VERIFY-001.
-**Done 2026-05-25:** INV-MON-003/004/006 (ops seed/config/smoke) + INV-MON-API-001 (/v1/*) + GOV-FLOW-VALIDATION-001 (§10 T1).
-**Done 2026-05-26:** OPS-SCHEMA-FIX-001 + FVP seed 5 PASS + INV-MON-005 (tenant-deploy via vps-api) + OPS-CONFIG-EGOS-OPS-URL-001.
-**Bloqueios Enio (3):** contrato (advogado?), faturamento mínimo (R$10k?), canal seguro MP (Bitwarden?).
-
-### 🚧 Bloqueado Enio
-- ALLM-EGOS-013 decisão KB local vs kb.gpecas.egos.ia.br (15min)
-- ALLM-EGOS-046 Caddy mTLS / Cloudflare Access (2h, dep deploy VPS)
-- 29 imagens ChatGPT FVP (prompts em mensagem 2026-05-22)
-- Decisão home_sort_strategy FVP (default `featured_only` → mudar para `best_margin`?)
-
----
-
-## ✅ GATEWAY-TENANT-FIX-001 (2026-05-25, COMPLETO) — vazamento cross-tenant fixado. Commits `028254b1..ad3ea4a9`.
-
-### Pendente (P1 — próxima janela, NÃO mexer em MCP ainda)
-
-- [ ] **MCP-AGNOSTIC-001** [P1] `26h` — refactor `packages/mcp-g-pecas` → `packages/mcp-storefront` agnostic (7 fases). Decisão Enio 2026-05-25: **adiado, não mexer agora**. SSOT diagnóstico já feito em sessão Opus 2026-05-25.
-- [ ] **GATEWAY-RPC-LEGACY-003** [P2] `1h` — remover RPCs legadas `search_g_pecas_products`/`search_g_pecas_faq` quando G Peças migrar para tabela neutral `products` (atualmente usa `g_pecas_products` prefixed-table)
-- [ ] **GATEWAY-CORS-WHITELIST-004** [P2] `30min` — atualizar CORS no `/chat-web` para incluir `apecaspatense.egos.ia.br` explicitamente (hoje aceita via `.endsWith(".egos.ia.br")`)
-- [ ] **CHAT-UI-WHITELIST-005** [P2] `1h` — adicionar `apecaspatense.egos.ia.br` em `allowedOrigins` no gateway (linha ~1519 whatsapp.ts)
-- [ ] **SMOKE-CROSS-TENANT-CI-007** [P2] `2h` — adicionar `smoke-cross-tenant.sh` ao CI/pre-commit quando novo tenant for adicionado
-
----
-
-## 🌐 MCP REMOTE BRIDGE — expor MCPs além de g-pecas (corte Enio 2026-05-31)
-
-> Hoje só `g-pecas` está bridgeado público (`mcp.egos.ia.br/g-pecas/mcp`). Enio cortou expor +storefront +ops +observability +governance +knowledge. Cada bridge = 1 processo PM2 + 1 bloco Caddy (deploy de produção → segue `docs/governance/MCP_DEPLOYMENT_CHECKLIST.md` + provenance). NÃO fazer deploy autônomo — exige janela de deploy + smoke.
-
-- [ ] **MCP-BRIDGE-001** [P1] `1h` — Bridge `mcp-storefront` (baixo risco, vendável, sem segredo de kernel). PM2 + Caddy + smoke `initialize` → Unauthorized.
-- [ ] **MCP-BRIDGE-002** [P1] `1h` — Bridge `mcp-ops` + `mcp-observability` (risco médio: revela topologia). Validar que tools read-only não vazam infra sensível antes de expor.
-- [ ] **MCP-BRIDGE-003** [P2-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
-- [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
-
-## 🖥️ FRONTEND-SYNC — frontend/README/GitHub refletindo a realidade (Enio 2026-06-01)
-
-> **Diagnóstico (2 Sonnets + probes 2026-06-01):** o público NÃO reflete o trabalho recente. Homepage = copy antiga; `/status` congelado em 15/abr; `/showcase` dizia 23 agents; README/GitHub público sem MCPs live/Resolver/79 caps. Já feito (código+dados commitados, SHA `7ea70da6`): snapshot enriquecido (caps 79 / agents 27 / MCPs vivos) + manifest 23→27. Falta o LIVE (rebuild) + Red Zone (copy).
-- [/] **FE-SYNC-001** [P0] `prime` — **ACHADO RAIZ 2026-06-01:** o `/opt/egos-site/src/server.ts` em produção está **~1931 linhas ATRÁS** do repo (sem i18n/trading/tema/render novo). **É POR ISSO que o frontend não reflete nada** — prod roda server.ts de meses atrás (deploy drift). ✅ Dado já LIVE: `git pull` em `/opt/egos-git` (mount `docs/jobs:ro`) → `/status.json` fresco hoje + bloco framework (79/27/MCPs). ❌ Falta: **release controlado do egos-site** (deploy do server.ts atual = release GRANDE, não rebuild trivial — testar i18n/trading/deps no env prod + 502-safe + prova visual §10). Build context `/opt/egos-site` é NÃO-git → precisa pipeline de deploy real. NÃO fazer blind.
-- [/] **FE-SYNC-002** [P1] — Render do bloco `framework` no /status: ✅ código commitado. Dado já live no /status.json. Falta renderizar no HTML → entra no release FE-SYNC-001.
-- [ ] **FE-SYNC-004** [P2] — Artigo factual no /timeline sobre o eval-runner live no ChatGPT + 79 capabilities (documenta sistema deployado; revisão factual, não-marketing). Site só tem 1 artigo hoje.
-- [ ] **FE-SYNC-005** [P2] — README do repo público `egos-governance`: mencionar MCPs live + Resolver Doctrine + 79 caps (hoje marca mcp-eval-runner como "Alpha"). Factual.
-- [ ] **FE-SYNC-006** [P3] — Auto-regen do snapshot (cron quebrado desde abr) — wire `status-snapshot.ts` num cron/Hermes pós-deploy p/ não estagnar de novo.
-
-## 📓 NOTEBOOKLM — notebook do framework EGOS sempre atualizado (Enio 2026-06-01)
-
-> Notebook "EGOS Central Kernel — Framework Core" (`db55b6b8`). ✅ 2026-06-01: adicionadas constituição (CLAUDE.md + RULES_INDEX) + RESOLVER_DOCTRINE + CAPABILITY_REGISTRY (3→7 fontes). Regra: NotebookLM Obrigatório (versionar ADD-only, HITL deleção).
-- [ ] **NLM-FW-002** [P1] — Auto-sync OBRIGATÓRIO: doc canônico atualizado (CLAUDE.md/RULES_INDEX/AGENTS/RESOLVER/CAPABILITY_REGISTRY) → post-push Hermes → `source_delete`+`source_add` da MESMA fonte no notebook. Wire `notebook-sync-local.ts` (nunca rodou --exec) ao post-push. HITL só p/ deleção; ADD-only automático.
-
-## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
-
-> Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
-- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P2] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
-- [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
-
 ## 🔀 CROSS-WINDOW — absorção 3 janelas + alarme .guarani (Enio 2026-06-01)
 
 > Fechamento: este Prime + outra Claude Code + Guarani(sem créditos). Lição: 3 janelas no mesmo .git/index = colisão. Worktree-por-agente é a correção.
@@ -816,69 +473,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 - [ ] **READINESS-PROVE-001** [P2] — Rodar `/readiness` num caso real (ex: G Peças ou um prospect) → validar o veredito honesto na prática. Liga pivô (alívio de dor, não IA).
 
-## 🛡️ CYBERSECURITY KB + COMUNICAÇÃO ÉTICA + PROCESSO (Enio 2026-06-01, intake ChatGPT)
-
-> Intake (protocolo): `~/Downloads/ChatGPT-Investigação cibersegurança EGOS.md` = mission-spec (CONCEPT, não claims). 1ª rodada = inventário+arquitetura+políticas, NÃO impl pesada (o próprio file pede isso). Conecta CURRICULUM-001 + F1 (forense) + cursos. Foco: especializar o Agente EGOS em cyber DEFENSIVA/ética.
-- [ ] **CYBER-KB-002** [P2] — Conectar a cyber KB ao currículo do Enio (F1 forense + ciber + IA + polícia) — vira diferencial + material de curso + skills públicas. Liga CURRICULUM-001, COURSES.
-- [ ] **COMM-ETHICS-001** [P2] `redzone` — "Engenharia social" reframe ÉTICO: padrão de comunicação do EGOS (copy/agentes/respostas) — **persuadir com VERDADE, estruturar pra clareza, NUNCA explorar viés manipulativamente**. Já temos: transparência radical + evidence-first + banned-absolutes (anti-"100%/garantido"). Faltar: standard `docs/governance/ETHICAL_COMMUNICATION_STANDARD.md` (inteligente + sincero, não-manipulador).
-
-## 📊 TELEMETRIA DO SISTEMA INTEIRO — observabilidade total p/ medir-e-fluir (Enio 2026-06-03)
-
-> **Visão Enio:** "telemetria do sistema inteiro — tudo que é acionável por mim, tudo por você (agente), as skills usadas e QUANDO, os modelos usados, quantos agentes disparados, tudo. Para ir medindo e fluindo nos processos, municiando os agentes cada vez melhor — com todos os meta-prompts, o gerador de meta-prompts no fluxo, agent Hermes, tudo."
-> **Liga a:** `dispersion-meter.ts` (já feito), TELEM-* abaixo, skill-usage-tracker, observability MCP, AGENT-TELEM-STD-001, metaprompt-generator (`docs/modules/metaprompt-generator/`), Hermes event-pipeline. **Tese:** um painel único = o "cockpit" que separa dispersão generativa de ruído.
-
-- [ ] **TELEMETRY-EPIC-001** [P1] — Spec do painel de telemetria unificado: o que medir (eventos acionáveis-Enio / acionáveis-agente / skills+quando / modelos+custo / nº agentes disparados / sessões / dispersão / drift) + onde vive (Supabase events + blackboard + `/status`/HQ) + como cada fonte já existente (skill-usage-tracker, observability MCP, coordination-history, dispersion-meter, agent-runs) alimenta um SSOT. Desenho ANTES de codar. **Red Zone:** decisão de arquitetura (corte Enio).
-- [ ] **TELEMETRY-SKILLS-001** [P2] `gated:EPIC` — Instrumentar TODA invocação de skill/slash: nome, quando, contexto, resultado → events. (Estende `skill-usage-tracker.ts` + PHASE-2-SKILL-TRACKER-CRON-001.)
-- [ ] **TELEMETRY-MODELS-001** [P2] `gated:EPIC` — Logar todo call de modelo: provider/modelo, tokens, custo, latência, sucesso → events (reusa `api_usage` + llm-router). Painel custo-por-modelo/agente.
-- [ ] **TELEMETRY-AGENTS-001** [P2] `gated:EPIC` — Contar/logar agentes disparados: quantos, quais papéis, gates passados, handoffs (reusa AGENT-TELEM-STD-001 `~/.egos/agent-runs/` + agent-pipeline).
-- [ ] **TELEMETRY-HUMAN-001** [P2] `gated:EPIC` — Eventos acionáveis-por-Enio: aprovações HITL, cortes Red Zone, comandos, decisões → trilha de decisão auditável (liga RESOLVER decisões→memória).
-- [ ] **PROCESS-MUNITION-001** [P1] — "Municiar os agentes cada vez melhor": colocar o **gerador de meta-prompts no FLUXO** (todo agente novo/task nova puxa o metaprompt certo de `docs/metaprompts/` via mcp-governance get_meta_prompt) + processos bem-definidos por papel. Liga metaprompt-generator + Hermes agent + agent-org. Desenho de processo, não só código.
-
-## 📡 DIFF TELEMETRY + DRIFT ACCEPTANCE — sinal multi-agente (Enio 2026-06-01)
-
-> SSOT/sinal: `docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md`. Reusa coordination-watcher + history.jsonl + drift detectors. Aceite = drift score ≥80 (80/20) → ≥99. Construção distribuída entre agentes = o teste.
-- [ ] **TELEM-DIFF-001** [P1] — watcher post-commit loga diff-stats + cadence no `coordination-history.jsonl`.
-- [ ] **TELEM-DRIFT-001** [P1] — `scripts/drift-score.ts` composto (doc-drift+task-drift+manifest+ui+rule-sync) normalizado 0-100 → blackboard.
-- [ ] **TELEM-SCOREBOARD-001** [P2] — expor drift score no /status + blackboard (liga FE-SYNC).
-- [ ] **TELEM-AGENTS-001** [P2] — protocolo agente: lê blackboard no /start, loga diff no /end (+ start-guarani).
-
-## 🔍 RADICAL TRANSPARENCY / PROOF ARCHITECTURE — validação (Enio 2026-06-01) [pesquisa, NÃO impl ainda]
-
-> Missão: descobrir SE blockchain melhora a governança de IA do EGOS — não assumir que sim. Se não, focar em Git+signed-commits+audit-logs+OpenTelemetry+Guard Brasil+capability-registry. Dossiê: `docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md` (workflow `blockchain-governance-validation`). Regra: só hash/manifest/attestation on-chain; contexto rico off-chain. Sem PII/secrets/conteúdo investigativo on-chain. Sem token.
-- [/] **RT-INVENTORY-001** [P0] — Inventário do que EGOS já tem (transparência radical/Ethik/observabilidade/telemetria/KPIs/audit/decision records/Guard Brasil). (workflow)
-- [/] **PROOF-ARCH-001** [P0] — Pesquisa Bitcoin/OTS, EAS/Base, BTC L2s (Stacks/Rootstock/Liquid/RGB/Taproot), não-blockchain (Sigstore/Rekor/SLSA/OTel) + interoperabilidade Layer A↔B. (workflow)
-- [/] **CTX-BOUNDARY-001** [P0] — Mapa de contexto: IA-window / off-chain registry / proof layer / public layer. O que vai onde + tamanho. (workflow)
-- [ ] **PROOF-MANIFEST-001** [P1] — Formato canônico do EGOS Proof Manifest (governance version + decision record): serialização canônica + Merkle root + verificação.
-- [ ] **EAS-PROTO-001** [P1] — Protótipo: decision attestation em Base testnet/sim local. MVP2. Schema `{ruleVersion,agentId,decisionHash,outcome,overrideBy,ts}` + resolver (só council).
-- [ ] **RT-KPI-001** [P1] — KPIs (técnico/valor/risco) reusando telemetria existente, p/ medir se a arquitetura vale.
-- [ ] **PROOF-DASH-001** [P2] — Dashboard/README de proofs (sem dado sensível). MVP3.
-- [ ] **PROOF-NARRATIVE-001** [P2] `redzone` — Artigo/post explicando sem hype. HITL.
-- [ ] **PROOF-PERSONA-001** [P2] — Definir quem usaria/compraria de fato (user/buyer/auditor).
-- [ ] **PROOF-MODULES-001** [P2] — Modularizar (replicável): `egos-proof-{core,bitcoin,eas,registry,ui,policy}`. Só após validação.
-- [ ] **PROOF-VERDICT-001** [P2] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
-
-## 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
-
-> SSOT: `docs/governance/EXTERNAL_ARTIFACT_INTAKE_PROTOCOL.md` v1.0. Quando Enio traz .md externo (ChatGPT/Grok/etc): land em _inbox → classifica INC-005 (REAL/CONCEPT/PHANTOM) → grande delega a agente → mapeia vs existente (não reinventar) → triagem Resolver → tasks/memória.
-- [ ] **PRICING-CLARITY-001** [P2] — Doc-fix (não muda preço): deixar legível no strategy doc que R$100/mês é o piso de recorrência (Demo Starter), não a âncora; receita 30d = setup fees, não MRR. (ChatGPT criticou baseado em leitura incompleta.)
-- [ ] **HITL-MULTICHANNEL-001** [P3] — Wire a política HITL multi-canal (Telegram+WhatsApp+email) que aparece em `.guarani/GUARANI.md` mas só tem Telegram parcial. Dispatcher único por policy.
-- [ ] **RULE-GOV-GAP-001** [P2] — `gem-hunter` ungoverned (sem CLAUDE.md/AGENTS.md). Decidir: adicionar adapter+symlinks .guarani (modelo egos-lab/852) OU marcar explicitamente externo. 🧊CONGELADO
-- [ ] **RULE-SYNC-001** [P2] — `blueprint-egos` 45d stale (sync a6d1ad7 2026-04-17). Rodar `bun scripts/disseminate-propagator.ts --all` p/ ressincronizar do kernel atual.
-- [ ] **INTAKE-WIRE-001b** [P3] — Wire RULE_SETS_INDEX no /start (consciência de quais regras valem onde) + monitor de lag de propagação (>30d alerta).
-- [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start (rule-set awareness) + gatilho comportamental do Prime + considerar virar skill `/intake`.
-
-## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
-
-> Guarani deixou 8 arquivos staged. ⚠️ Sci-Hub = circumvention de paywall — **Red Zone legal/reputacional p/ policial ativo + repo público**. NÃO commito o scraper sem corte do Enio.
-- [ ] **HANDOFF-SCIHUB-001** [P2] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
-- [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
-
-## 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
-
-> SSOT: `docs/governance/UI_FUNCTIONAL_TESTING_STANDARD.md` v1.0. Tooling existe (`mcp-browser-automation` + Playwright + §10 + visual-proof) mas NÃO há mapa por-página nem é seguido (drift egos.ia.br provou). Meta 80/20 → melhorar.
-- [ ] **UI-TEST-001** [P1] — Criar `docs/qa/pagemaps/egos-site.md`: mapa de TODAS as rotas do egos.ia.br (/, /status, /showcase, /skills, /timeline, /lab, /en/*) com elementos/APIs/estados. Base pro crawl.
-- [ ] **UI-TEST-002** [P1] — Wire Hermes crawl: percorre o mapa via browser-automation + Playwright, roda critérios §3 automatizáveis (rota/links/APIs/console/latência/screenshot), classifica com modelo barato (qwen/haiku), escreve `docs/qa/reports/`. ~$0.
-- [ ] **UI-TEST-003** [P2] — Enforce: gate pré-commit (toca UI → exige mapa+prova) + Layer QA no /start + Phase UI no /end.
 
 ## 🎓 CURSOS ↔ FRAMEWORK ↔ GOVERNO — Enio 2026-06-01
 
@@ -892,18 +486,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **COURSE-CONVERGE-001** [P1] — Convergir os 2 cursos polícia-específicos (COURSE-LGPD + COURSE-OVM, Prime) com o COURSE-PROGRAM 4-tracks "Construa e Governe a SUA IA" (público geral, outra janela). **NÃO são duplicata:** programa = geral build+govern; meus 2 = polícia (cyber/LGPD + OVM). Decidir: viram tracks do programa? produto separado? Corte Enio. SSOT a unificar quando criar o repo de cursos.
 - [ ] **COURSE-GOV-PITCH-001** [P2] `redzone` — Proposta pro governo (polícia roda modelo próprio local/soberano + framework aberto auditável). Deriva do curso. HITL — nada de pitch público sem corte do Enio.
 
-### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
-> Ref: https://developers.openai.com/apps-sdk · Conector custom do ChatGPT = Server URL (SSE) + Auth (OAuth / Sem-auth / Mista). `mcp-g-pecas` já rodou HTTPS-live no ChatGPT → caminho provado. Objetivo: validar uso real dos MCPs no ChatGPT.
-> **✅ VALIDADO 2026-06-01:** `eval-runner` conectou no ChatGPT (URL `https://mcp.egos.ia.br/eval-runner/mcp`, sem-auth, Developer Mode). 6 tools carregadas. Dois bugs achados+consertados: (1) bridge stdio sem `\n` → travava (SHA `ae4da0c0`); (2) eval-runner via 0 CBCs no VPS — REPO_ROOT resolvia `/opt/` em vez do repo → adicionado `EGOS_REPO_ROOT` env + dados framework sincronizados p/ `/opt/egos-data` + fix do falso `migration_pct:100%`. Agora vê 79 CBCs reais (`migration_pct:91.9%`). ChatGPT é stateless (re-inicializa cada call) + não tem campo Bearer (só OAuth/sem-auth/mista) — por isso g-pecas falhou no print do Enio.
-- [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
-- [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
-  - ✅ **Livres (pode no ChatGPT):** `eval-runner`, `skills-registry`, `governance` (TASKS/registry/SSOT = framework aberto).
-  - 🟡 **Escopar:** `knowledge` — docs do framework livres, MAS bloquear dados intelink/cliente/PII (filtro tenant/namespace).
-  - 🔴 **Proteger (auth/de-route):** `ops`, `observability`, `browser-automation` (atacam a MÁQUINA), `memory` (pessoal/PCMG), `security` (resultados PII).
-  Ação: `EGOS_MCP_TOKEN` só nos 🔴 + escopo tenant no `knowledge`; os ✅ ficam livres. NÃO reiniciar os 🔴 sem auth antes (fix `ae4da0c0` no arquivo compartilhado os exporia).
-
----
-
 ## 🧠 CHATBOT QUALITY — GOV + Wave 0
 
 ### 🏛️ Governance pendente 2026-05-22
@@ -959,122 +541,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - **GATE-4** (após FASE D): Enio aprova slide refinado antes de regenerar NotebookLM
 - **GATE-5** (após FASE H): Enio decide quais achados do Codex aplicar
 
-### 🎯 SLIDES + NOTEBOOKLM CENTRAL EGOS (2026-05-29)
-
-- [ ] **NLM-CENTRAL-002** [P2] `1h Sonnet` — Criar template `NOTEBOOKLM.md` em `central-egos/products/_template/` para novos produtos usarem como base de integração NotebookLM.
-- [ ] **NLM-CENTRAL-003** [P2] `30min` — Wiring em Layer 0: documentar política de notebooks NotebookLM em `LAYER_0_SSOT.md §6` (1 notebook por cliente, nomenclatura, retenção, compartilhamento).
-
-#### Auto-sync via Hermes (arquitetura corrigida 2026-05-30 — Codex GPT-5.5 + descoberta VPS)
-
-- [/] **NLM-HERMES-002** [P1] `2h Sonnet` — detector credential-free `scripts/notebook-sync-detect.ts` (git+ledger only, sem NotebookLM) + `docs/notebooklm/sync-map.json` (mapa doc→notebook) + typo `~/.eos`→`~/.egos` em `hermes-audit-and-sync.sh`. Detector testado local (dry/exec/idempotência ok). **Pendente:** deploy na VPS (wirear no hermes-trigger + cron) — toca box não-supervisionado, requer go-ahead Enio.
-- [ ] **NLM-PRECOMMIT-001** [P2] `1h Sonnet` — pre-commit sinaliza notebook-sync pending p/ docs canônicos (README/arquitetura/regras).
-- [ ] **NLM-COVERAGE-001** [P2] `1h` — substituir grep frágil de cobertura (start.md Layer 6.7) por parse estruturado da tabela `NOTEBOOKS_INDEX.md` (Codex HIGH: "Central EGOS (kernel)" listado como gap causa falso pass/fail).
-- [ ] **NLM-DIGITALTRUST-FASE2** [P2] `HITL` — fase 2 curadoria Digital Trust (127 fontes): D (6 EE→mover Eagle Eye), G (3 cripto→fora-escopo), C/E (avaliar reenvio vs deletar superados). Deleção = HITL batch.
-
-## 🚀 CENTRAL EGOS COMMERCIAL
-
-### 🔴 NOVO 2026-05-25 — INC-SYNC-001 + Home=Catalogo
-
-- [ ] **DEPLOY-SYNC-PRECOMMIT-001** [P2] `1h Sonnet` — Pre-commit detecta mudanças em `central-egos/template/src/` e exige `deploy-all-tenants.sh` `(P0→P2 2026-06-03: pivô despriorizou storefront)`
-- [ ] **UX-HOME-AS-CATALOG-001** [P2] `3h Sonnet` — Home `/` reutiliza componentes `/catalogo` (sidebar+filtros+grid+sort). Opção C: refator `app/page.tsx`. NÃO redirecionar. `(P0→P2 2026-06-03: pivô despriorizou storefront)`
-- [ ] **SSOT-SYNC-WATCHDOG-001** [P1] `2h` — Hermes job semanal compara `pm2 describe created_at` de todos tenants. Diff >48h = alerta Telegram.
-- [ ] **GOV-BOUNDARY-APP-PATHS-001** [P1] `1h Sonnet` — Extender pre-commit para BLOCK writes em `central-egos/clients/<slug>/src/app/`
-- [ ] **SYSTEM-HEALTH-IMPL-001** [P1] `2h Sonnet` — `/admin/system-health` stub → implementar (PM2, último deploy, drift detector, SSL, disk)
-
-### 🔴 NOVO 2026-05-25 — EGOS Comércio plano único
-
-> SSOT: `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` | Plano único R$ 2-5k setup + R$ 100+/mês
-
-- [ ] **LLM-METER-001** [P1] `4h Sonnet` — `usage_metrics` por tenant (tokens, model, alerta 80%/100% cap)
-- [ ] **SOLUCOES-EMPRESARIAIS-001** [P1] `3h Sonnet` — Página `/solucoes-empresariais` (ERPs, R$12k+). Link rodapé discreto.
-
-### 🔴 NOVO 2026-05-22 — Storefront UX
-
-- [ ] **UX-HOME-FEATURED-001** [P2] `3h Sonnet` — Home `featured=true` (limit 8) + `tenant_settings.home_sort_strategy` `(P0→P2 2026-06-03: pivô despriorizou storefront)`
-- [ ] **UX-HEADER-STICKY-FIX-001** [P2] `1h Sonnet` — Header `/catalogo` sticky não fixa (parent overflow). Mobile + desktop. `(P0→P2 2026-06-03: pivô despriorizou storefront)`
-- [ ] **UX-ADMIN-FEATURED-001** [P1] `2h Sonnet` — Toggle "Destaque" no admin + `featured_until` + bulk "marcar promoção"
-- [ ] **UX-PROMO-VISUAL-001** [P1] `2h Sonnet` — ProductCard badge "PROMOÇÃO" + preço riscado + filtro sidebar
-
-### 🔴 Sprint P0 — Demo seguro para Bernardo
-
-- [ ] **TASK-MP-DEMO-001** [P2] `4h Sonnet` — Banner preview `is_demo_mode=true` + página `/sobre-egos` (8 tiers) + link header `(P0→P2 2026-06-03: pivô despriorizou storefront)`
-- [ ] **TASK-VPS-WATCHER-UPDATE-001** [P1] `30min` — Watcher chama `/api/health?tenant=g-pecas` a cada 5min
-- [ ] **LLM-CAP-VALIDATE-001** [P2] `2h` — Validar cap 2M tokens/mês com dados reais G Peças
-
-### 🔵 AUDIT P0
-
-- [ ] **GP-MISSING-FIELDS-001** — Campos ausentes no painel admin G Peças (investigar)
-- [ ] **GP-SYNC-AUDIT-001** — Sync entre template e clients/g-pecas após storefront redesign
-
----
-
-## 🎯 SPRINT ATIVO
-
-### 🔴 P0 Ativas
-
-- [ ] **CBQ-OBS-FOUNDATION-001** [P2] — Migrations Wave 0 (ver CBQ-OBS-001..003)
-
-### 🟧 P1 Ativas
-
-- [ ] **PHASE-2-HOOKS-001** [P1] — Hooks dormentes: agent-run.sh, auto-sync.sh, context-alarm.sh, cost-alert.sh, governance-drift-alert.sh, session-end.sh, session-status.sh → REATIVAR | ARQUIVAR | DELETAR
-- [ ] **PHASE-2-START-SLIM-001** [P1] — Enxugar `/start`: -21KB (CLAUDE.md dup) + SELF_MAPPING_INTERVIEW lazy + ADRs hash
-- [ ] **PHASE-2-TASKS-READER-001** [P1] — Layer 4.5 inclui `grep "^- \[ \].*\[P0\]" TASKS.md` no `/start`
-- [ ] **PHASE-2-PREMORTEM-SKILL-001** [P1] — Criar skill `/premortem` + trigger em skill-auto-match
-- [ ] **PHASE-2-SKILL-TRACKER-CRON-001** [P1] — Crontab 06:00 BRT `skill-usage-tracker.ts --days=30`
-
-### 🔵 Abertas (sem urgência imediata)
-
-- [ ] **PHASE-2-SKILL-AUDIT-001** [P2] — 14 skills sem invocação em 14d → KEEP+justificativa | ARQUIVAR | DELETAR
-- [ ] **PHASE-2-SOUL-IDENTITY-001** [P2] — `soul/IDENTITY.md` não lido pelo /start. Integrar Layer 1 OU arquivar.
-- [ ] **PHASE-2-DOTEGOS-SYNC-001** [P2] — `~/.egos/.claude/CLAUDE.md` estagnado → arquivar OU cron sync
-- [ ] **PHASE-2-GLOBAL-CLAUDE-SLIM-001** [P2] — Global CLAUDE.md 327L → ≤180L (Council decidiu, não executou)
-
-### ⏸️ PAUSADO
-
-- [ ] **CHAT-LGPD-001** — Aviso LGPD no chat (aguarda advogado)
-- [ ] **WAHA-CONNECT-001** — WA reconectar via WAHA (número em repouso desde 2026-05-14)
-- [ ] **FACE-000** — Reconhecimento facial (aguarda licença)
-- [ ] **INTELINK-DEPLOY-001** — Deploy VPS intelink (aguarda billing Supabase)
-
-### 🔴 BLOQUEADORES
-
-- ALLM-EGOS-049 Mirror S3 WORM (dep provedor)
-- ALLM-EGOS-050 SCC OpenAI + RIPD LGPD (dep advogado)
-- CET-CONTRATO-001 (dep Enio: advogado OR template)
-
----
-
-## 📊 MATERIAL EVAL LOOP
-
-- [ ] **MATERIAL-EVAL-ANTIGRAVITY-001** [P2] — integrar Antigravity (Gemini CLI) como avaliador no loop (perspectiva não-técnico)
-- [ ] **MATERIAL-EVAL-CODEX-001** [P2] — integrar Codex como avaliador no loop (perspectiva de produto)
-- [ ] **MATERIAL-EVAL-CRON-001** [P2] — cron semanal: rodar eval loop em todos os materiais, flaggar se score caiu
-
----
-
-## 🎯 COMERCIAL
-
-- [ ] **DEMO-MATERIAL-001** [P1] `2h` — Pack material demo: PDF 1p + vídeo walkthrough roteiro
-- [ ] **ONBOARD-CHECKLIST-001** [P1] `1h` — CLIENT_ONBOARDING_CHECKLIST.md atualizado (plano único)
-- [ ] **PRICING-COMMUNICATION-001** [P1] `1h` — One-pager externo (R$2-5k + R$100+/mês) para Bernardo
-- [ ] **EPOS-B5-Q2-001** [P2] `2h` — EPOS Bandeira 5 Q2: qual capability EGOS prova este trimestre?
-- [ ] **EPOS-RECONCILE-B1-001** [P2] `prime` — Reconciliar numeração do bloco B1: A81 (travamento técnico/visual, via Guarani 2026-06-05) e A82 (horizonte 12m "ambos em paralelo", via /start 2026-06-07) ambos rotulados B1-Q4. Verificar contra `prompts/personal-os/SELF_MAPPING_INTERVIEW.md` qual é o B1-Q4 canônico, renumerar o outro, e validar `interview_state.json` (atualmente em B1-Q5). Atoms gitignored (local). Nenhuma resposta do Enio se perde — só a numeração precisa de pente fino.
-
----
-
-## 🖥️ VPS HARDENING
-
-- [ ] **VPS-FAIL2BAN-001** [P1] — fail2ban configurado SSH + Caddy
-- [ ] **VPS-APT-AUTO-001** [P1] — apt unattended-upgrades (security patches automáticos)
-- [ ] **VPS-CVE-SCAN-001** [P1] — trivy/grype scan nas imagens Docker
-- [ ] **VPS-CERT-RENEW-ALERT-001** [P1] — Alertas Telegram 30d antes de SSL expirar
-- [ ] **VPS-DISK-ALERT-001** [P1] — Alerta se disco >70% (atual 49%)
-- [ ] **VPS-SSH-HARDENING-001** [P2] — PermitRootLogin no, PasswordAuth no, key-only
-- [ ] **VPS-FIREWALL-AUDIT-001** [P2] — UFW rules audit: portas expostas vs necessárias
-- [ ] **VPS-MONITORING-AGENT-001** [P2] — Prometheus node_exporter + Grafana cloud free tier
-
----
-
 ## 🔬 INTELINK (work-hours, Frente A)
 
 - [ ] **REPORT-007** [P2] — Relatório investigação DHPP (pendente) [pertence a intelink, não framework]
@@ -1083,7 +549,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **REPORT-004** [P1] — Exportar dados BISP para Neo4j (16k pessoas) completo
 
 ---
-
 ## 🧹 INTELINK PUBLIC RELEASE — capacidades de kernel (Enio 2026-06-07)
 > SSOT desta frente: `docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md`
 > Trilha escolhida p/ execução: **WS4 primeiro** (purge tool → limpa intelink-platform automaticamente).
@@ -1103,9 +568,3 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ---
 
-## 🤖 HERMES AUTO-TASKS
-
-### 🔴 P0 EMERGENCIAL — Secrets reais expostos no git público
-- [ ] **SEC-FOLLOWUP-001** [P1] — Considerar `git filter-repo` para limpar histórico dos commits `19e1e1a` e `05b3603` (remove secrets antigos do histórico). Risco: força push em main — coordenar com janelas paralelas.
-
-> **33 HERMES-FINDING-\* [P1]** movidos para `TASKS_ARCHIVE.md §Hermes-Findings-2026-05-26` (TASKS-SLIM-002 2026-05-26).
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
 
diff --git a/docs/jobs/2026-06-10-crossrefs-report.json b/docs/jobs/2026-06-10-crossrefs-report.json
new file mode 100644
index 00000000..91758793
--- /dev/null
+++ b/docs/jobs/2026-06-10-crossrefs-report.json
@@ -0,0 +1,13407 @@
+{
+  "generated": "2026-06-10",
+  "context": "Post-fix classification of remaining MISSING refs. Class moved_auto (129) already fixed.",
+  "totals": {
+    "files_scanned": 8021,
+    "links_total": 4639,
+    "archived": 0,
+    "missing": 1552,
+    "ok": 3087
+  },
+  "before_fix": {
+    "missing": 1681
+  },
+  "after_fix": {
+    "missing": 1552
+  },
+  "delta": {
+    "fixed": 129
+  },
+  "class_summary": {
+    "noise_file_protocol": 95,
+    "non_md_ref": 128,
+    "dead": 604,
+    "ambiguous": 114,
+    "archived": 37,
+    "moved_ambiguous_by_scope": 574
+  },
+  "findings": [
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/conselho.md",
+      "source_line": 116,
+      "target_raw": "file:///home/enio/egos/scripts/",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/scripts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/conselho.md",
+      "source_line": 116,
+      "target_raw": "file:///home/enio/egos/scripts/activation-check.ts",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/scripts/activation-check.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/conselho.md",
+      "source_line": 116,
+      "target_raw": "file:///home/enio/egos/scripts/recon.ts",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/scripts/recon.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/conselho.md",
+      "source_line": 116,
+      "target_raw": "file:///home/enio/egos/scripts/doctor.ts",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/scripts/doctor.ts"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/drafts/README-omniview-v2-2026-05-26.md",
+      "source_line": 176,
+      "target_raw": "LICENSE",
+      "resolved_path": "docs/drafts/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": "docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": "docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": "docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": "docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": "docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/drafts/chatatual.md",
+      "source_line": 6422,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/drafts/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/drafts/chatatual.md",
+      "source_line": 6664,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/drafts/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/drafts/chatatual.md",
+      "source_line": 6671,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/drafts/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/TELEGRAM_BOT_FIX_PROPOSAL.md",
+      "source_line": 12,
+      "target_raw": "file:///home/enio/egos/apps/egos-gateway/src/channels/telegram.ts#L347-L353",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/TELEGRAM_BOT_FIX_PROPOSAL.md",
+      "source_line": 42,
+      "target_raw": "file:///home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/drafts/TELEGRAM_BOT_FIX_PROPOSAL.md",
+      "source_line": 69,
+      "target_raw": "file:///home/enio/egos/.env.example",
+      "resolved_path": "docs/drafts/file:/home/enio/egos/.env.example"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": "docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 16,
+      "target_raw": "file:///home/enio/egos/packages/eval-runner/src/",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/eval-runner/src"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 26,
+      "target_raw": "file:///home/enio/egos/packages/autores-schema/src/",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/autores-schema/src"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 35,
+      "target_raw": "file:///home/enio/egos/packages/hermes-schema/src/",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/hermes-schema/src"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 41,
+      "target_raw": "file:///home/enio/egos/packages/llm-fallback/src/index.ts",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/llm-fallback/src/index.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 47,
+      "target_raw": "file:///home/enio/egos/packages/shared/src/memory-store.ts",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 56,
+      "target_raw": "file:///home/enio/egos/packages/guard-brasil/src/pii-patterns.ts#L497-L499",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 56,
+      "target_raw": "file:///home/enio/egos/packages/guard-brasil/src/lib/public-guard.ts#L95-L96",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 62,
+      "target_raw": "file:///home/enio/egos/packages/shared/src/prompt-assembler.ts",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 68,
+      "target_raw": "file:///home/enio/egos/apps/_archived/vendas-portal",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/apps/_archived/vendas-portal"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 74,
+      "target_raw": "file:///home/enio/egos/packages/mcp-governance/src/index.ts",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/packages/mcp-governance/src/index.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/jobs/2026-06-03-agent-map-verification.md",
+      "source_line": 89,
+      "target_raw": "file:///home/enio/egos/scripts/disseminate-scanner.ts",
+      "resolved_path": "docs/jobs/file:/home/enio/egos/scripts/disseminate-scanner.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/ai-architecture/egos-agent-knowledge-stack.md",
+      "source_line": 43,
+      "target_raw": "file:///home/enio/egos/CLAUDE.md",
+      "resolved_path": "docs/ai-architecture/file:/home/enio/egos/CLAUDE.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/ai-architecture/egos-agent-knowledge-stack.md",
+      "source_line": 43,
+      "target_raw": "file:///home/enio/egos/AGENTS.md",
+      "resolved_path": "docs/ai-architecture/file:/home/enio/egos/AGENTS.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/ai-architecture/egos-agent-knowledge-stack.md",
+      "source_line": 43,
+      "target_raw": "file:///home/enio/egos/docs/EGOS_BOOTSTRAP.md",
+      "resolved_path": "docs/ai-architecture/file:/home/enio/egos/docs/EGOS_BOOTSTRAP.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/ai-architecture/egos-agent-knowledge-stack.md",
+      "source_line": 59,
+      "target_raw": "file:///home/enio/egos/data/cybersecurity/sources.yaml",
+      "resolved_path": "docs/ai-architecture/file:/home/enio/egos/data/cybersecurity/sources.yaml"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/ai-architecture/egos-agent-knowledge-stack.md",
+      "source_line": 71,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/evaluation-policy.md",
+      "resolved_path": "docs/ai-architecture/file:/home/enio/egos/docs/cybersecurity/evaluation-policy.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/strategy/appendix/PRICING_ANCHORS.md",
+      "source_line": 23,
+      "target_raw": "../../templates/PRICING_SSOT.md",
+      "resolved_path": "docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 12,
+      "target_raw": "../../../apps/egos-site/",
+      "resolved_path": "apps/egos-site"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": "docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": "docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": "docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": "docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": "docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": "docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": "docs/agents/file.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/agents/eva.md",
+      "source_line": 34,
+      "target_raw": "file:///home/enio/egos/docs/governance/SKILLS_REGISTRY.md",
+      "resolved_path": "docs/agents/file:/home/enio/egos/docs/governance/SKILLS_REGISTRY.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/agents/eva.md",
+      "source_line": 35,
+      "target_raw": "file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md",
+      "resolved_path": "docs/agents/file:/home/enio/egos/docs/governance/agent_scopes_and_governance.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/agents/eva.md",
+      "source_line": 36,
+      "target_raw": "file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md",
+      "resolved_path": "docs/agents/file:/home/enio/egos/docs/governance/agent_scopes_and_governance.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/agents/eva.md",
+      "source_line": 37,
+      "target_raw": "file:///home/enio/egos/packages/guard-brasil/src/guard.ts",
+      "resolved_path": "docs/agents/file:/home/enio/egos/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md",
+      "source_line": 7,
+      "target_raw": "file:///home/enio/egos/apps/egos-landing/src/components/MyceliumPage.tsx",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/apps/egos-landing/src/components/MyceliumPage.tsx"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md",
+      "source_line": 9,
+      "target_raw": "file:///home/enio/egos/AGENTS.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/AGENTS.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md",
+      "source_line": 9,
+      "target_raw": "file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/docs/governance/agent_scopes_and_governance.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-05_compass-self-discovery.md",
+      "source_line": 48,
+      "target_raw": "file:///home/enio/egos/data/personal-os/private/enio_profile_atoms.jsonl",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/data/personal-os/private/enio_profile_atoms.jsonl"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-05_compass-self-discovery.md",
+      "source_line": 48,
+      "target_raw": "file:///home/enio/egos/data/personal-os/private/interview_state.json",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/data/personal-os/private/interview_state.json"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/.husky/pre-commit",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/.husky/pre-commit"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/AGENTS.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/AGENTS.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/CLAUDE.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/CLAUDE.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 5,
+      "target_raw": "file:///home/enio/egos/.agents/workflows/start.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/.agents/workflows/start.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 5,
+      "target_raw": "file:///home/enio/egos/.agents/workflows/end.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/.agents/workflows/end.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/handoff_2026-06-10.md",
+      "source_line": 6,
+      "target_raw": "file:///home/enio/egos/.claude/agents/",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/.claude/agents"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-03_guards-and-telegram.md",
+      "source_line": 8,
+      "target_raw": "file:///home/enio/egos/docs/governance/EGOS_AGENT_MAP.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/docs/governance/EGOS_AGENT_MAP.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-03_guards-and-telegram.md",
+      "source_line": 9,
+      "target_raw": "file:///home/enio/egos/docs/jobs/2026-06-03-agent-map-verification.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/docs/jobs/2026-06-03-agent-map-verification.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-03_guards-and-telegram.md",
+      "source_line": 10,
+      "target_raw": "file:///home/enio/egos/tmp/pri-llm-prototype.ts",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/tmp/pri-llm-prototype.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-03_guards-and-telegram.md",
+      "source_line": 11,
+      "target_raw": "file:///home/enio/egos/docs/drafts/TELEGRAM_BOT_FIX_PROPOSAL.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/docs/drafts/TELEGRAM_BOT_FIX_PROPOSAL.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-03_guards-and-telegram.md",
+      "source_line": 12,
+      "target_raw": "file:///home/enio/egos/docs/knowledge/HARVEST.md",
+      "resolved_path": "docs/_current_handoffs/file:/home/enio/egos/docs/knowledge/HARVEST.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/products-specs/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/products-specs/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/products-specs/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/products-specs/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/products-specs/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": "docs/products-specs/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": "docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": "docs/governance/LICENSE"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/governance/MULTI_AGENT_ORCHESTRATION_GUIDE.md",
+      "source_line": 106,
+      "target_raw": "file:///home/enio/egos/scripts/coordination-watcher.ts",
+      "resolved_path": "docs/governance/file:/home/enio/egos/scripts/coordination-watcher.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/governance/CLIENT_TIERS_MATRIX.md",
+      "source_line": 11,
+      "target_raw": "../templates/PRICING_SSOT.md",
+      "resolved_path": "docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/governance/HITL_CATALOG.md",
+      "source_line": 151,
+      "target_raw": "file:///home/enio/egos/scripts/hitl-request.ts",
+      "resolved_path": "docs/governance/file:/home/enio/egos/scripts/hitl-request.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/governance/HITL_CATALOG.md",
+      "source_line": 152,
+      "target_raw": "file:///home/enio/egos/scripts/x-approval-bot.ts",
+      "resolved_path": "docs/governance/file:/home/enio/egos/scripts/x-approval-bot.ts"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/cybersecurity/citation-policy.md",
+      "source_line": 37,
+      "target_raw": "link-da-fonte",
+      "resolved_path": "docs/cybersecurity/link-da-fonte"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 16,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/ingestion-policy.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/ingestion-policy.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 17,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/safety-policy.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/safety-policy.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 18,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/citation-policy.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/citation-policy.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 21,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/egos-cybersecurity-taxonomy.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/egos-cybersecurity-taxonomy.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 22,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/source-map.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/source-map.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 23,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/learning-roadmap.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/learning-roadmap.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 26,
+      "target_raw": "file:///home/enio/egos/docs/cybersecurity/backlog.md",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/docs/cybersecurity/backlog.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/cybersecurity/README.md",
+      "source_line": 27,
+      "target_raw": "file:///home/enio/egos/data/cybersecurity/sources.yaml",
+      "resolved_path": "docs/cybersecurity/file:/home/enio/egos/data/cybersecurity/sources.yaml"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-02.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/packages/audit/src/a2a-auditor.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/audit/src/a2a-auditor.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-02.md",
+      "source_line": 5,
+      "target_raw": "file:///home/enio/egos/packages/audit/src/a2a-signer.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/audit/src/a2a-signer.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-02.md",
+      "source_line": 6,
+      "target_raw": "file:///home/enio/egos/packages/mcp-governance/src/index.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/mcp-governance/src/index.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-02.md",
+      "source_line": 8,
+      "target_raw": "file:///home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/docs/CAPABILITY_REGISTRY.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/packages/eval-runner/evals/guardrails/adversarial.test.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/eval-runner/evals/guardrails/adversarial.test.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/packages/eval-runner/evals/guardrails/grounding.test.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/eval-runner/evals/guardrails/grounding.test.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 5,
+      "target_raw": "file:///home/enio/egos/bin/egos.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/bin/egos.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 6,
+      "target_raw": "file:///home/enio/egos/scripts/validate-guardrails.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/scripts/validate-guardrails.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 7,
+      "target_raw": "file:///home/enio/egos/packages/guard-brasil-mcp/guardrails.yaml",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/guard-brasil-mcp/guardrails.yaml"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 7,
+      "target_raw": "file:///home/enio/egos/packages/mcp-g-pecas/guardrails.yaml",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/packages/mcp-g-pecas/guardrails.yaml"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-cli-validation.md",
+      "source_line": 7,
+      "target_raw": "file:///home/enio/egos/apps/egos-gateway/guardrails.yaml",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/apps/egos-gateway/guardrails.yaml"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": "docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": "docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": "docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": "docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": "docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": "docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": "docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": "docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": "docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": "docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": "docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": "docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": "docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": "docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": "docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": "docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": "docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": "docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": "docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": "docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": "docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": "docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": "docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": "egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": "egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": "docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": "docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/scripts/hitl-request.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/scripts/hitl-request.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/scripts/x-approval-bot.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/scripts/x-approval-bot.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 5,
+      "target_raw": "file:///home/enio/egos/scripts/coordination-watcher.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/scripts/coordination-watcher.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 6,
+      "target_raw": "file:///home/enio/egos/docs/governance/COORDINATION_MONITOR_SPEC.md",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/docs/governance/COORDINATION_MONITOR_SPEC.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 7,
+      "target_raw": "file:///home/enio/egos/scripts/doctor.ts",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/scripts/doctor.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 8,
+      "target_raw": "file:///home/enio/egos/apps/egos-landing/src/homepage.jsx",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/apps/egos-landing/src/homepage.jsx"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 9,
+      "target_raw": "file:///home/enio/egos/.github/workflows/capability-eval.yml",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/.github/workflows/capability-eval.yml"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/_archived_handoffs/handoff_2026-06-01.md",
+      "source_line": 10,
+      "target_raw": "file:///home/enio/egos/.agents/workflows/start.md",
+      "resolved_path": "docs/_archived_handoffs/file:/home/enio/egos/.agents/workflows/start.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": "docs/_archived_handoffs/2026-05/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": "docs/_archived_handoffs/2026-05/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/PRESENTATION_SYSTEM_INDEX.md",
+      "source_line": 30,
+      "target_raw": "./PRESENTATION_VISUAL_IDENTITY.md",
+      "resolved_path": "docs/_archived_handoffs/2026-05/PRESENTATION_VISUAL_IDENTITY.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md",
+      "source_line": 10,
+      "target_raw": "../_drafts/skill-candidates/",
+      "resolved_path": "docs/_archived_handoffs/_drafts/skill-candidates"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": "docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": "docs/_archived_handoffs/2026-05/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": "docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": "docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": "docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "archived",
+      "source_file": "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/_archived_handoffs/handoff_2026-05-31-guarani-close.md",
+      "source_line": 25,
+      "target_raw": "../../apps/guard-brasil-web/",
+      "resolved_path": "apps/guard-brasil-web"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "central-egos/template/src/app/api/admin/import/route.ts",
+      "resolved_path": "docs/planning/central-egos/template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": "docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": "docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": "docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": "docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/GTM_SSOT.md",
+      "source_line": 7,
+      "target_raw": "templates/PRICING_SSOT.md",
+      "resolved_path": "docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": "docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 81,
+      "target_raw": "file:///home/enio/egos/packages/guard-brasil/src/guard.ts#L159",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 82,
+      "target_raw": "file:///home/enio/852/src/app/api/chat/route.ts",
+      "resolved_path": "docs/knowledge/file:/home/enio/852/src/app/api/chat/route.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 83,
+      "target_raw": "file:///home/enio/carteira-livre/app/page.tsx",
+      "resolved_path": "docs/knowledge/file:/home/enio/carteira-livre/app/page.tsx"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 84,
+      "target_raw": "file:///home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 85,
+      "target_raw": "file:///home/enio/egos-lab/apps/eagle-eye/src/index.ts",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos-lab/apps/eagle-eye/src/index.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 86,
+      "target_raw": "file:///home/enio/egos/packages/shared/src/mycelium/reference-graph.ts#L123",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos/packages/shared/src/mycelium/reference-graph.ts"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 87,
+      "target_raw": "file:///home/enio/egos-archive/v5/EGOSv5/packages/harmonic-math",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos-archive/v5/EGOSv5/packages/harmonic-math"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": "docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md",
+      "source_line": 88,
+      "target_raw": "file:///home/enio/egos/packages/eval-runner/src/runner.ts",
+      "resolved_path": "docs/knowledge/file:/home/enio/egos/packages/eval-runner/src/runner.ts"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/consulting/COMMON/02-empresas-page-content.md",
+      "source_line": 31,
+      "target_raw": "/empresas/governanca",
+      "resolved_path": "empresas/governanca"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/consulting/COMMON/02-empresas-page-content.md",
+      "source_line": 43,
+      "target_raw": "/empresas/ssot",
+      "resolved_path": "empresas/ssot"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/consulting/COMMON/02-empresas-page-content.md",
+      "source_line": 55,
+      "target_raw": "/empresas/mcp",
+      "resolved_path": "empresas/mcp"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "docs/consulting/COMMON/02-empresas-page-content.md",
+      "source_line": 103,
+      "target_raw": "/empresas/agendar",
+      "resolved_path": "empresas/agendar"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": "docs/audits/CAPABILITY_COVERAGE_2026-05-30.md",
+      "source_line": 364,
+      "target_raw": "../capabilities/CBC-EGOS-<SLUG>-001.md",
+      "resolved_path": "docs/capabilities/CBC-EGOS-<SLUG>-001.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "TASKS.md",
+      "source_line": 496,
+      "target_raw": "strategy/PLAN_v4.md",
+      "resolved_path": "strategy/PLAN_v4.md",
+      "candidates": [
+        "docs/strategy/PLAN_v4.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/commands/end.md",
+      "source_line": 611,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/commands/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/commands/start.md",
+      "source_line": 297,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".claude/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/commands/start.md",
+      "source_line": 320,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".claude/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/commands/start.md",
+      "source_line": 424,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".claude/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 18,
+      "target_raw": "file:///home/enio/egos/.guarani/GUARANI.md",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/.guarani/GUARANI.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 19,
+      "target_raw": "file:///home/enio/egos/AGENTS.md",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/AGENTS.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 20,
+      "target_raw": "file:///home/enio/egos/CLAUDE.md",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/CLAUDE.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 21,
+      "target_raw": "file:///home/enio/egos/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/docs/governance/GUARANI_EVALUATOR_PROTOCOL.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 23,
+      "target_raw": "file:///home/enio/egos/agents/registry/triggers.json",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/agents/registry/triggers.json"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 63,
+      "target_raw": "file:///home/enio/egos/docs/EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/docs/EGOS_BOOTSTRAP.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".claude/commands/start-guarani.md",
+      "source_line": 64,
+      "target_raw": "file:///home/enio/egos/.guarani/GUARANI.md#L20",
+      "resolved_path": ".claude/commands/file:/home/enio/egos/.guarani/GUARANI.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md",
+      "source_line": 321,
+      "target_raw": "./SKILLS_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/drafts/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 25,
+      "target_raw": "../../../../852/src/components/chat/ExportMenu.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/chat/ExportMenu.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 26,
+      "target_raw": "../../../../852/src/components/LgpdBanner.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/LgpdBanner.tsx"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 30,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 50,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 140,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 146,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 198,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 381,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 382,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 383,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 384,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 385,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 386,
+      "target_raw": "appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/_archived_2026-05-06/appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "candidates": [
+        "docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 83,
+      "target_raw": "EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/EGOS_BOOTSTRAP.md",
+      "candidates": [
+        "docs/EGOS_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 84,
+      "target_raw": "AGENT_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/AGENT_BOOTSTRAP.md",
+      "candidates": [
+        "docs/AGENT_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 86,
+      "target_raw": "../AGENTS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 87,
+      "target_raw": "governance/MULTI_LLM_ORCHESTRATION.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/governance/MULTI_LLM_ORCHESTRATION.md",
+      "candidates": [
+        "docs/governance/MULTI_LLM_ORCHESTRATION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 88,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2445,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 29,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 30,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 54,
+      "target_raw": "/home/enio/egos/AGENTS.md",
+      "resolved_path": "home/enio/egos/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 56,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 57,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 58,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 59,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 61,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 65,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 66,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 67,
+      "target_raw": "/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "resolved_path": "home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "candidates": [
+        "docs/governance/HERMES_EGOS_FORK_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 71,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 74,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 94,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 95,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 193,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 209,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 210,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 222,
+      "target_raw": "/home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "resolved_path": "home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "candidates": [
+        "docs/guides/integrations/evolution-api-setup.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 263,
+      "target_raw": "/home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "resolved_path": "home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "candidates": [
+        "docs/drafts/lgpd-drive-sync.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 297,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 336,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 347,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/LICENSE"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CLIENT_KB_DOCTRINE.md",
+      "source_line": 6,
+      "target_raw": "../../../tmp/codex-review-output.md",
+      "resolved_path": ".claude/worktrees/tmp/codex-review-output.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md",
+      "source_line": 5,
+      "target_raw": "sessions/session_20260403_p19_continued_monetization.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/sessions/session_20260403_p19_continued_monetization.md",
+      "candidates": [
+        "docs/sessions/session_20260403_p19_continued_monetization.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/HANDOFF_CURRENT.md",
+      "source_line": 139,
+      "target_raw": "../strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "candidates": [
+        "docs/strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 27,
+      "target_raw": "docs/social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 10,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 25,
+      "target_raw": "../social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 26,
+      "target_raw": "../ENIO_DEVELOPER_TIMELINE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/ENIO_DEVELOPER_TIMELINE.md",
+      "candidates": [
+        "docs/governance/ENIO_DEVELOPER_TIMELINE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 35,
+      "target_raw": "../knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 14,
+      "target_raw": "docs/governance/PIPELINE_DIAGRAM.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_DIAGRAM.md",
+      "candidates": [
+        "docs/governance/PIPELINE_DIAGRAM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 15,
+      "target_raw": "docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "candidates": [
+        "docs/jobs/ENC-L1-006-agent-execution-evidence.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 16,
+      "target_raw": "docs/jobs/agent-smoke-test-2026-04-14.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/jobs/agent-smoke-test-2026-04-14.md",
+      "candidates": [
+        "docs/jobs/agent-smoke-test-2026-04-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 17,
+      "target_raw": "docs/governance/PIPELINE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_SPEC.md",
+      "candidates": [
+        "docs/governance/PIPELINE_SPEC.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../modules/CHATBOT_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 13,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 9,
+      "target_raw": "TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 11,
+      "target_raw": "../opus-mode/OPUS_MODE_V1.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/opus-mode/OPUS_MODE_V1.md",
+      "candidates": [
+        "docs/opus-mode/OPUS_MODE_V1.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md",
+      "source_line": 23,
+      "target_raw": "../infra/SUBDOMAINS_INVENTORY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/infra/SUBDOMAINS_INVENTORY.md",
+      "candidates": [
+        "docs/infra/SUBDOMAINS_INVENTORY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 9,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 10,
+      "target_raw": ".guarani/orchestration/SSOT_RULES.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.guarani/orchestration/SSOT_RULES.md",
+      "candidates": [
+        ".guarani/orchestration/SSOT_RULES.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 11,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 15,
+      "target_raw": "../../docs/knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/docs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 388,
+      "target_raw": "../GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 389,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 33,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 48,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 17,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 18,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 19,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 20,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 21,
+      "target_raw": "pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "candidates": [
+        "docs/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 22,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 29,
+      "target_raw": "outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "candidates": [
+        "docs/strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 32,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 70,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 71,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 72,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 73,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 106,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "apps/central-egos-template/src/app/api/admin/import/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/apps/central-egos-template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/INDEX.md",
+      "source_line": 48,
+      "target_raw": "../DOC_DRIFT_SHIELD.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/DOC_DRIFT_SHIELD.md",
+      "candidates": [
+        "docs/governance/DOC_DRIFT_SHIELD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 256,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/sales/PARTNER_COMMISSIONS.md",
+      "source_line": 175,
+      "target_raw": "BERNARDO_DASHBOARD_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/sales/BERNARDO_DASHBOARD_PLAN.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/EGOS_BOOTSTRAP.md",
+      "source_line": 73,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "source_line": 9,
+      "target_raw": "../governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 44,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "candidates": [
+        "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/.claude/commands/end.md",
+      "source_line": 362,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/.claude/commands/file.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/template/README.md",
+      "source_line": 57,
+      "target_raw": "../../../docs/templates/PRICING_SSOT.md",
+      "resolved_path": ".claude/worktrees/docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/template/README.md",
+      "source_line": 69,
+      "target_raw": "../../../docs/governance/CLIENT_TIERS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_TIERS_MATRIX.md",
+      "candidates": [
+        "docs/governance/CLIENT_TIERS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/template/README.md",
+      "source_line": 70,
+      "target_raw": "../../../docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "candidates": [
+        "docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/template/README.md",
+      "source_line": 71,
+      "target_raw": "../../../docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "resolved_path": ".claude/worktrees/docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "candidates": [
+        "docs/runbooks/MOBILE_ACCESS_GUIDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/README.md",
+      "source_line": 67,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/README.md",
+      "source_line": 68,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/central-egos/README.md",
+      "source_line": 69,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/tools/egos-self/LICENSE"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil-python/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md",
+      "source_line": 321,
+      "target_raw": "./SKILLS_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/drafts/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 25,
+      "target_raw": "../../../../852/src/components/chat/ExportMenu.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/chat/ExportMenu.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 26,
+      "target_raw": "../../../../852/src/components/LgpdBanner.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/LgpdBanner.tsx"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 30,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 50,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 140,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 146,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 198,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 381,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 382,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 383,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 384,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 385,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 386,
+      "target_raw": "appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/_archived_2026-05-06/appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "candidates": [
+        "docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 83,
+      "target_raw": "EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/EGOS_BOOTSTRAP.md",
+      "candidates": [
+        "docs/EGOS_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 84,
+      "target_raw": "AGENT_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/AGENT_BOOTSTRAP.md",
+      "candidates": [
+        "docs/AGENT_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 86,
+      "target_raw": "../AGENTS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 87,
+      "target_raw": "governance/MULTI_LLM_ORCHESTRATION.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/governance/MULTI_LLM_ORCHESTRATION.md",
+      "candidates": [
+        "docs/governance/MULTI_LLM_ORCHESTRATION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 88,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2713,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 29,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 30,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 54,
+      "target_raw": "/home/enio/egos/AGENTS.md",
+      "resolved_path": "home/enio/egos/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 56,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 57,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 58,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 59,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 61,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 65,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 66,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 67,
+      "target_raw": "/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "resolved_path": "home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "candidates": [
+        "docs/governance/HERMES_EGOS_FORK_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 71,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 74,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 94,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 95,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 193,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 209,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 210,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 222,
+      "target_raw": "/home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "resolved_path": "home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "candidates": [
+        "docs/guides/integrations/evolution-api-setup.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 263,
+      "target_raw": "/home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "resolved_path": "home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "candidates": [
+        "docs/drafts/lgpd-drive-sync.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 297,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 336,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 347,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/LICENSE"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CLIENT_KB_DOCTRINE.md",
+      "source_line": 6,
+      "target_raw": "../../../tmp/codex-review-output.md",
+      "resolved_path": ".claude/worktrees/tmp/codex-review-output.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md",
+      "source_line": 5,
+      "target_raw": "sessions/session_20260403_p19_continued_monetization.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/sessions/session_20260403_p19_continued_monetization.md",
+      "candidates": [
+        "docs/sessions/session_20260403_p19_continued_monetization.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/HANDOFF_CURRENT.md",
+      "source_line": 139,
+      "target_raw": "../strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "candidates": [
+        "docs/strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 27,
+      "target_raw": "docs/social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 10,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 25,
+      "target_raw": "../social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 26,
+      "target_raw": "../ENIO_DEVELOPER_TIMELINE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/ENIO_DEVELOPER_TIMELINE.md",
+      "candidates": [
+        "docs/governance/ENIO_DEVELOPER_TIMELINE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 35,
+      "target_raw": "../knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 14,
+      "target_raw": "docs/governance/PIPELINE_DIAGRAM.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_DIAGRAM.md",
+      "candidates": [
+        "docs/governance/PIPELINE_DIAGRAM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 15,
+      "target_raw": "docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "candidates": [
+        "docs/jobs/ENC-L1-006-agent-execution-evidence.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 16,
+      "target_raw": "docs/jobs/agent-smoke-test-2026-04-14.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/jobs/agent-smoke-test-2026-04-14.md",
+      "candidates": [
+        "docs/jobs/agent-smoke-test-2026-04-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 17,
+      "target_raw": "docs/governance/PIPELINE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_SPEC.md",
+      "candidates": [
+        "docs/governance/PIPELINE_SPEC.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../modules/CHATBOT_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 13,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 9,
+      "target_raw": "TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 11,
+      "target_raw": "../opus-mode/OPUS_MODE_V1.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/opus-mode/OPUS_MODE_V1.md",
+      "candidates": [
+        "docs/opus-mode/OPUS_MODE_V1.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md",
+      "source_line": 23,
+      "target_raw": "../infra/SUBDOMAINS_INVENTORY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/infra/SUBDOMAINS_INVENTORY.md",
+      "candidates": [
+        "docs/infra/SUBDOMAINS_INVENTORY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 9,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 10,
+      "target_raw": ".guarani/orchestration/SSOT_RULES.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.guarani/orchestration/SSOT_RULES.md",
+      "candidates": [
+        ".guarani/orchestration/SSOT_RULES.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 11,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 15,
+      "target_raw": "../../docs/knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/docs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 388,
+      "target_raw": "../GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 389,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 33,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 48,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 17,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 18,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 19,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 20,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 21,
+      "target_raw": "pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "candidates": [
+        "docs/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 22,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 29,
+      "target_raw": "outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "candidates": [
+        "docs/strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 32,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 70,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 71,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 72,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 73,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 106,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "apps/central-egos-template/src/app/api/admin/import/route.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/apps/central-egos-template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/INDEX.md",
+      "source_line": 48,
+      "target_raw": "../DOC_DRIFT_SHIELD.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/DOC_DRIFT_SHIELD.md",
+      "candidates": [
+        "docs/governance/DOC_DRIFT_SHIELD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 256,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "source_line": 9,
+      "target_raw": "../governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 44,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "candidates": [
+        "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/commands/end.md",
+      "source_line": 362,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/commands/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/commands/start.md",
+      "source_line": 231,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/commands/start.md",
+      "source_line": 254,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/commands/start.md",
+      "source_line": 316,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/.claude/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/template/README.md",
+      "source_line": 57,
+      "target_raw": "../../../docs/templates/PRICING_SSOT.md",
+      "resolved_path": ".claude/worktrees/docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/template/README.md",
+      "source_line": 69,
+      "target_raw": "../../../docs/governance/CLIENT_TIERS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_TIERS_MATRIX.md",
+      "candidates": [
+        "docs/governance/CLIENT_TIERS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/template/README.md",
+      "source_line": 70,
+      "target_raw": "../../../docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "candidates": [
+        "docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/template/README.md",
+      "source_line": 71,
+      "target_raw": "../../../docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "resolved_path": ".claude/worktrees/docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "candidates": [
+        "docs/runbooks/MOBILE_ACCESS_GUIDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/README.md",
+      "source_line": 67,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/README.md",
+      "source_line": 68,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/central-egos/README.md",
+      "source_line": 69,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/tools/egos-self/LICENSE"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-aebb6fcd2a26def5a/packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-aebb6fcd2a26def5a/packages/guard-brasil-python/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md",
+      "source_line": 321,
+      "target_raw": "./SKILLS_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/drafts/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 25,
+      "target_raw": "../../../../852/src/components/chat/ExportMenu.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/chat/ExportMenu.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 26,
+      "target_raw": "../../../../852/src/components/LgpdBanner.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/LgpdBanner.tsx"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 30,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 50,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 140,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 146,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 198,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 381,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 382,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 383,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 384,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 385,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 386,
+      "target_raw": "appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/_archived_2026-05-06/appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "candidates": [
+        "docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 83,
+      "target_raw": "EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/EGOS_BOOTSTRAP.md",
+      "candidates": [
+        "docs/EGOS_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 84,
+      "target_raw": "AGENT_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/AGENT_BOOTSTRAP.md",
+      "candidates": [
+        "docs/AGENT_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 86,
+      "target_raw": "../AGENTS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 87,
+      "target_raw": "governance/MULTI_LLM_ORCHESTRATION.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/governance/MULTI_LLM_ORCHESTRATION.md",
+      "candidates": [
+        "docs/governance/MULTI_LLM_ORCHESTRATION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 88,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2713,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 29,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 30,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 54,
+      "target_raw": "/home/enio/egos/AGENTS.md",
+      "resolved_path": "home/enio/egos/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 56,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 57,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 58,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 59,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 61,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 65,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 66,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 67,
+      "target_raw": "/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "resolved_path": "home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "candidates": [
+        "docs/governance/HERMES_EGOS_FORK_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 71,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 74,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 94,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 95,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 193,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 209,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 210,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 222,
+      "target_raw": "/home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "resolved_path": "home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "candidates": [
+        "docs/guides/integrations/evolution-api-setup.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 263,
+      "target_raw": "/home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "resolved_path": "home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "candidates": [
+        "docs/drafts/lgpd-drive-sync.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 297,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 336,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 347,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/LICENSE"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CLIENT_KB_DOCTRINE.md",
+      "source_line": 6,
+      "target_raw": "../../../tmp/codex-review-output.md",
+      "resolved_path": ".claude/worktrees/tmp/codex-review-output.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md",
+      "source_line": 5,
+      "target_raw": "sessions/session_20260403_p19_continued_monetization.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/sessions/session_20260403_p19_continued_monetization.md",
+      "candidates": [
+        "docs/sessions/session_20260403_p19_continued_monetization.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/HANDOFF_CURRENT.md",
+      "source_line": 139,
+      "target_raw": "../strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "candidates": [
+        "docs/strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 27,
+      "target_raw": "docs/social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 10,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 25,
+      "target_raw": "../social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 26,
+      "target_raw": "../ENIO_DEVELOPER_TIMELINE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/ENIO_DEVELOPER_TIMELINE.md",
+      "candidates": [
+        "docs/governance/ENIO_DEVELOPER_TIMELINE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 35,
+      "target_raw": "../knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 14,
+      "target_raw": "docs/governance/PIPELINE_DIAGRAM.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_DIAGRAM.md",
+      "candidates": [
+        "docs/governance/PIPELINE_DIAGRAM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 15,
+      "target_raw": "docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "candidates": [
+        "docs/jobs/ENC-L1-006-agent-execution-evidence.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 16,
+      "target_raw": "docs/jobs/agent-smoke-test-2026-04-14.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/jobs/agent-smoke-test-2026-04-14.md",
+      "candidates": [
+        "docs/jobs/agent-smoke-test-2026-04-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 17,
+      "target_raw": "docs/governance/PIPELINE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_SPEC.md",
+      "candidates": [
+        "docs/governance/PIPELINE_SPEC.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../modules/CHATBOT_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 13,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 9,
+      "target_raw": "TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 11,
+      "target_raw": "../opus-mode/OPUS_MODE_V1.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/opus-mode/OPUS_MODE_V1.md",
+      "candidates": [
+        "docs/opus-mode/OPUS_MODE_V1.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md",
+      "source_line": 23,
+      "target_raw": "../infra/SUBDOMAINS_INVENTORY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/infra/SUBDOMAINS_INVENTORY.md",
+      "candidates": [
+        "docs/infra/SUBDOMAINS_INVENTORY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 9,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 10,
+      "target_raw": ".guarani/orchestration/SSOT_RULES.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.guarani/orchestration/SSOT_RULES.md",
+      "candidates": [
+        ".guarani/orchestration/SSOT_RULES.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 11,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 15,
+      "target_raw": "../../docs/knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/docs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 388,
+      "target_raw": "../GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 389,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 33,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 48,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 17,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 18,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 19,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 20,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 21,
+      "target_raw": "pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "candidates": [
+        "docs/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 22,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 29,
+      "target_raw": "outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "candidates": [
+        "docs/strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 32,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 70,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 71,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 72,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 73,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 106,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "apps/central-egos-template/src/app/api/admin/import/route.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/apps/central-egos-template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/INDEX.md",
+      "source_line": 48,
+      "target_raw": "../DOC_DRIFT_SHIELD.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/DOC_DRIFT_SHIELD.md",
+      "candidates": [
+        "docs/governance/DOC_DRIFT_SHIELD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 256,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "source_line": 9,
+      "target_raw": "../governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 44,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "candidates": [
+        "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/.claude/commands/end.md",
+      "source_line": 402,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/.claude/commands/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/.claude/commands/start.md",
+      "source_line": 231,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/.claude/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/.claude/commands/start.md",
+      "source_line": 254,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/.claude/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/.claude/commands/start.md",
+      "source_line": 316,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/.claude/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 3,
+      "target_raw": "../../docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/central-egos/docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "candidates": [
+        "docs/governance/EGOS_COMERCIO_PLANO_UNICO.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 4,
+      "target_raw": "../../docs/sales/PARTNER_PLAYBOOK.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/central-egos/docs/sales/PARTNER_PLAYBOOK.md",
+      "candidates": [
+        "docs/strategy/PARTNER_PLAYBOOK.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/template/README.md",
+      "source_line": 57,
+      "target_raw": "../../../docs/templates/PRICING_SSOT.md",
+      "resolved_path": ".claude/worktrees/docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/template/README.md",
+      "source_line": 69,
+      "target_raw": "../../../docs/governance/CLIENT_TIERS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_TIERS_MATRIX.md",
+      "candidates": [
+        "docs/governance/CLIENT_TIERS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/template/README.md",
+      "source_line": 70,
+      "target_raw": "../../../docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "candidates": [
+        "docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/template/README.md",
+      "source_line": 71,
+      "target_raw": "../../../docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "resolved_path": ".claude/worktrees/docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "candidates": [
+        "docs/runbooks/MOBILE_ACCESS_GUIDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/README.md",
+      "source_line": 67,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/README.md",
+      "source_line": 68,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/central-egos/README.md",
+      "source_line": 69,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/tools/egos-self/LICENSE"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-ace69cd041317702c/packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-ace69cd041317702c/packages/guard-brasil-python/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/README-omniview-v2-2026-05-26.md",
+      "source_line": 176,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md",
+      "source_line": 321,
+      "target_raw": "./SKILLS_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/drafts/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 25,
+      "target_raw": "../../../../852/src/components/chat/ExportMenu.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/chat/ExportMenu.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 26,
+      "target_raw": "../../../../852/src/components/LgpdBanner.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/LgpdBanner.tsx"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 30,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 50,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 140,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 146,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 198,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 381,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 382,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 383,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 384,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 385,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 386,
+      "target_raw": "appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/_archived_2026-05-06/appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "candidates": [
+        "docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 83,
+      "target_raw": "EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/EGOS_BOOTSTRAP.md",
+      "candidates": [
+        "docs/EGOS_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 84,
+      "target_raw": "AGENT_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/AGENT_BOOTSTRAP.md",
+      "candidates": [
+        "docs/AGENT_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 86,
+      "target_raw": "../AGENTS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 87,
+      "target_raw": "governance/MULTI_LLM_ORCHESTRATION.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/governance/MULTI_LLM_ORCHESTRATION.md",
+      "candidates": [
+        "docs/governance/MULTI_LLM_ORCHESTRATION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 88,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2713,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/LICENSE"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CLIENT_KB_DOCTRINE.md",
+      "source_line": 6,
+      "target_raw": "../../../tmp/codex-review-output.md",
+      "resolved_path": ".claude/worktrees/tmp/codex-review-output.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md",
+      "source_line": 5,
+      "target_raw": "sessions/session_20260403_p19_continued_monetization.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/sessions/session_20260403_p19_continued_monetization.md",
+      "candidates": [
+        "docs/sessions/session_20260403_p19_continued_monetization.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/HANDOFF_CURRENT.md",
+      "source_line": 139,
+      "target_raw": "../strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "candidates": [
+        "docs/strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 27,
+      "target_raw": "docs/social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 10,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 25,
+      "target_raw": "../social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 26,
+      "target_raw": "../ENIO_DEVELOPER_TIMELINE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/ENIO_DEVELOPER_TIMELINE.md",
+      "candidates": [
+        "docs/governance/ENIO_DEVELOPER_TIMELINE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 35,
+      "target_raw": "../knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 14,
+      "target_raw": "docs/governance/PIPELINE_DIAGRAM.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_DIAGRAM.md",
+      "candidates": [
+        "docs/governance/PIPELINE_DIAGRAM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 15,
+      "target_raw": "docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "candidates": [
+        "docs/jobs/ENC-L1-006-agent-execution-evidence.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 16,
+      "target_raw": "docs/jobs/agent-smoke-test-2026-04-14.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/jobs/agent-smoke-test-2026-04-14.md",
+      "candidates": [
+        "docs/jobs/agent-smoke-test-2026-04-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 17,
+      "target_raw": "docs/governance/PIPELINE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_SPEC.md",
+      "candidates": [
+        "docs/governance/PIPELINE_SPEC.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../modules/CHATBOT_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 13,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 9,
+      "target_raw": "TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 11,
+      "target_raw": "../opus-mode/OPUS_MODE_V1.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/opus-mode/OPUS_MODE_V1.md",
+      "candidates": [
+        "docs/opus-mode/OPUS_MODE_V1.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md",
+      "source_line": 23,
+      "target_raw": "../infra/SUBDOMAINS_INVENTORY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/infra/SUBDOMAINS_INVENTORY.md",
+      "candidates": [
+        "docs/infra/SUBDOMAINS_INVENTORY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 9,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 10,
+      "target_raw": ".guarani/orchestration/SSOT_RULES.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.guarani/orchestration/SSOT_RULES.md",
+      "candidates": [
+        ".guarani/orchestration/SSOT_RULES.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 11,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 15,
+      "target_raw": "../../docs/knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/docs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md",
+      "source_line": 8,
+      "target_raw": "../planning/post-grok-sprint-master-plan.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/planning/post-grok-sprint-master-plan.md",
+      "candidates": [
+        "docs/planning/post-grok-sprint-master-plan.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md",
+      "source_line": 9,
+      "target_raw": "../governance/FEATURE_FREEZE_ANALYSIS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/governance/FEATURE_FREEZE_ANALYSIS.md",
+      "candidates": [
+        "docs/governance/FEATURE_FREEZE_ANALYSIS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md",
+      "source_line": 10,
+      "target_raw": "../_drafts/skill-candidates/",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/_drafts/skill-candidates"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 388,
+      "target_raw": "../GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 389,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 33,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 48,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 29,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 30,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 54,
+      "target_raw": "/home/enio/egos/AGENTS.md",
+      "resolved_path": "home/enio/egos/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 56,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 57,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 58,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 59,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 61,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 65,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 66,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 67,
+      "target_raw": "/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "resolved_path": "home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "candidates": [
+        "docs/governance/HERMES_EGOS_FORK_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 71,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 74,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 94,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 95,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 193,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 209,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 210,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 222,
+      "target_raw": "/home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "resolved_path": "home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "candidates": [
+        "docs/guides/integrations/evolution-api-setup.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 263,
+      "target_raw": "/home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "resolved_path": "home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "candidates": [
+        "docs/drafts/lgpd-drive-sync.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 297,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 336,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 347,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 17,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 18,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 19,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 20,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 21,
+      "target_raw": "pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "candidates": [
+        "docs/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 22,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 29,
+      "target_raw": "outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "candidates": [
+        "docs/strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 32,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 70,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 71,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 72,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 73,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 106,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "apps/central-egos-template/src/app/api/admin/import/route.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/apps/central-egos-template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/INDEX.md",
+      "source_line": 48,
+      "target_raw": "../DOC_DRIFT_SHIELD.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/DOC_DRIFT_SHIELD.md",
+      "candidates": [
+        "docs/governance/DOC_DRIFT_SHIELD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 256,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "source_line": 9,
+      "target_raw": "../governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 44,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "candidates": [
+        "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/commands/end.md",
+      "source_line": 402,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/commands/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/commands/start.md",
+      "source_line": 231,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/commands/start.md",
+      "source_line": 254,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/commands/start.md",
+      "source_line": 316,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/.claude/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 3,
+      "target_raw": "../../docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "candidates": [
+        "docs/governance/EGOS_COMERCIO_PLANO_UNICO.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 4,
+      "target_raw": "../../docs/sales/PARTNER_PLAYBOOK.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/docs/sales/PARTNER_PLAYBOOK.md",
+      "candidates": [
+        "docs/strategy/PARTNER_PLAYBOOK.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/template/README.md",
+      "source_line": 57,
+      "target_raw": "../../../docs/templates/PRICING_SSOT.md",
+      "resolved_path": ".claude/worktrees/docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/template/README.md",
+      "source_line": 69,
+      "target_raw": "../../../docs/governance/CLIENT_TIERS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_TIERS_MATRIX.md",
+      "candidates": [
+        "docs/governance/CLIENT_TIERS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/template/README.md",
+      "source_line": 70,
+      "target_raw": "../../../docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "candidates": [
+        "docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/template/README.md",
+      "source_line": 71,
+      "target_raw": "../../../docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "resolved_path": ".claude/worktrees/docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "candidates": [
+        "docs/runbooks/MOBILE_ACCESS_GUIDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/README.md",
+      "source_line": 67,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/README.md",
+      "source_line": 68,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/central-egos/README.md",
+      "source_line": 69,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/tools/egos-self/LICENSE"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-acbc4f85668ef36eb/packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-acbc4f85668ef36eb/packages/guard-brasil-python/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 112,
+      "target_raw": "URL_FROM_STEP_2",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/URL_FROM_STEP_2"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 113,
+      "target_raw": "URL_FROM_STEP_3",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/URL_FROM_STEP_3"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 114,
+      "target_raw": "URL_FROM_STEP_4",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/URL_FROM_STEP_4"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SUBSTACK_EXECUTION_CHECKLIST.md",
+      "source_line": 115,
+      "target_raw": "URL_FROM_STEP_5",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/URL_FROM_STEP_5"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SKILL_ART_002_skills_vs_agents_en.md",
+      "source_line": 323,
+      "target_raw": "../governance/EGOS_GOVERNANCE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/EGOS_GOVERNANCE.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md",
+      "source_line": 321,
+      "target_raw": "./SKILLS_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/drafts/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/capabilities/REAL_WORLD_USE_CASES.md",
+      "source_line": 84,
+      "target_raw": "007-ocr-documentos-reconhecimento-facial.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/capabilities/007-ocr-documentos-reconhecimento-facial.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 25,
+      "target_raw": "../../../../852/src/components/chat/ExportMenu.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/chat/ExportMenu.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/appendix/TRUST_PAGE_SPEC.md",
+      "source_line": 26,
+      "target_raw": "../../../../852/src/components/LgpdBanner.tsx",
+      "resolved_path": ".claude/worktrees/852/src/components/LgpdBanner.tsx"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 30,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 50,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 140,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 146,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 198,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 381,
+      "target_raw": "appendix/DPIO_QUESTIONNAIRE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/DPIO_QUESTIONNAIRE.md",
+      "candidates": [
+        "docs/strategy/appendix/DPIO_QUESTIONNAIRE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 382,
+      "target_raw": "appendix/DEBRIEF_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/DEBRIEF_ARCHITECTURE.md",
+      "candidates": [
+        "docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 383,
+      "target_raw": "appendix/KB_DECISION_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/KB_DECISION_MATRIX.md",
+      "candidates": [
+        "docs/strategy/appendix/KB_DECISION_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 384,
+      "target_raw": "appendix/TRUST_PAGE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/TRUST_PAGE_SPEC.md",
+      "candidates": [
+        "docs/strategy/appendix/TRUST_PAGE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 385,
+      "target_raw": "appendix/PRICING_ANCHORS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/PRICING_ANCHORS.md",
+      "candidates": [
+        "docs/strategy/appendix/PRICING_ANCHORS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md",
+      "source_line": 386,
+      "target_raw": "appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/_archived_2026-05-06/appendix/WHATSAPP_ONBOARDING_GUIDE.md",
+      "candidates": [
+        "docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 15,
+      "target_raw": "agents/start.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 16,
+      "target_raw": "agents/end.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 17,
+      "target_raw": "agents/snapshot.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/snapshot.md",
+      "candidates": [
+        ".claude/commands/snapshot.md",
+        ".agents/workflows/snapshot.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 23,
+      "target_raw": "agents/inception.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/inception.md",
+      "candidates": [
+        "docs/agents/inception.md",
+        ".claude/commands/inception.md",
+        ".agents/workflows/inception.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 31,
+      "target_raw": "agents/duo.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/duo.md",
+      "candidates": [
+        ".claude/commands/duo.md",
+        ".agents/workflows/duo.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 83,
+      "target_raw": "EGOS_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/EGOS_BOOTSTRAP.md",
+      "candidates": [
+        "docs/EGOS_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 84,
+      "target_raw": "AGENT_BOOTSTRAP.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/AGENT_BOOTSTRAP.md",
+      "candidates": [
+        "docs/AGENT_BOOTSTRAP.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 85,
+      "target_raw": "../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 86,
+      "target_raw": "../AGENTS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 87,
+      "target_raw": "governance/MULTI_LLM_ORCHESTRATION.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/governance/MULTI_LLM_ORCHESTRATION.md",
+      "candidates": [
+        "docs/governance/MULTI_LLM_ORCHESTRATION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/META_PROMPTS_INDEX.md",
+      "source_line": 88,
+      "target_raw": "governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/end.md",
+      "source_line": 330,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2713,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 49,
+      "target_raw": "apps/egos-gateway/src/channels/whatsapp.ts#L54",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-13_chatbot-rag-faq.md",
+      "source_line": 50,
+      "target_raw": "apps/egos-gateway/src/orchestrator.ts#L856",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/apps/egos-gateway/src/orchestrator.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-07_start-v6.2.md",
+      "source_line": 4,
+      "target_raw": ".claude/commands/start.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/.claude/commands/start.md",
+      "candidates": [
+        "docs/agents/start.md",
+        "docs/workflows/start.md",
+        ".claude/commands/start.md",
+        ".agents/workflows/start.md",
+        ".windsurf/workflows/start.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 6,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 17,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 29,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 30,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 54,
+      "target_raw": "/home/enio/egos/AGENTS.md",
+      "resolved_path": "home/enio/egos/AGENTS.md",
+      "candidates": [
+        "AGENTS.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 55,
+      "target_raw": "/home/enio/egos/README.md",
+      "resolved_path": "home/enio/egos/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 56,
+      "target_raw": "/home/enio/egos/docs/SYSTEM_MAP.md",
+      "resolved_path": "home/enio/egos/docs/SYSTEM_MAP.md",
+      "candidates": [
+        "docs/SYSTEM_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 57,
+      "target_raw": "/home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/modules/SSOT_REGISTRY.md",
+      "candidates": [
+        "docs/modules/SSOT_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 58,
+      "target_raw": "/home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "resolved_path": "home/enio/egos/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "candidates": [
+        "docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 59,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 60,
+      "target_raw": "/home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": "home/enio/egos/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 61,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 65,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 66,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 67,
+      "target_raw": "/home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "resolved_path": "home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md",
+      "candidates": [
+        "docs/governance/HERMES_EGOS_FORK_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 71,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 72,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 74,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 75,
+      "target_raw": "/home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md",
+      "resolved_path": "home/enio/egos-lab/docs/plans/ESPIRAL_DE_ESCUTA_PLATFORM.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos-lab/docs/ETHIK_COMPLETE.md",
+      "resolved_path": "home/enio/egos-lab/docs/ETHIK_COMPLETE.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 80,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 81,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 82,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 83,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 84,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 85,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 86,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 87,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 91,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 92,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 93,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 94,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 95,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 148,
+      "target_raw": "/home/enio/Downloads/EGOS_Espiral_Handoff.pdf",
+      "resolved_path": "home/enio/Downloads/EGOS_Espiral_Handoff.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos/docs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 193,
+      "target_raw": "/home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "resolved_path": "home/enio/egos-lab-chat/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 194,
+      "target_raw": "/home/enio/egos-lab-chat/src/index.ts",
+      "resolved_path": "home/enio/egos-lab-chat/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 209,
+      "target_raw": "/home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "home/enio/egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 210,
+      "target_raw": "/home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "resolved_path": "home/enio/egos/docs/governance/CHATBOT_CONSTITUTION.md",
+      "candidates": [
+        "docs/governance/CHATBOT_CONSTITUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 220,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/whatsapp.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 221,
+      "target_raw": "/home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts",
+      "resolved_path": "home/enio/egos/apps/central-egos-template/src/app/api/whatsapp/incoming/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 222,
+      "target_raw": "/home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "resolved_path": "home/enio/egos/docs/guides/integrations/evolution-api-setup.md",
+      "candidates": [
+        "docs/guides/integrations/evolution-api-setup.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 223,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/DISCOVERIES-2026-05-05-WHATSAPP-EVOLUTION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 236,
+      "target_raw": "/home/enio/egos/apps/egos-gateway/src/channels/telegram.ts",
+      "resolved_path": "home/enio/egos/apps/egos-gateway/src/channels/telegram.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 237,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 250,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 262,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 263,
+      "target_raw": "/home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "resolved_path": "home/enio/egos/docs/drafts/lgpd-drive-sync.md",
+      "candidates": [
+        "docs/drafts/lgpd-drive-sync.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 274,
+      "target_raw": "/home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts",
+      "resolved_path": "home/enio/egos/apps/egos-hq/app/api/enio/stats/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 297,
+      "target_raw": "/home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "resolved_path": "home/enio/egos/docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md",
+      "candidates": [
+        "docs/knowledge/EGOS_KNOWLEDGE_BASE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 313,
+      "target_raw": "/home/enio/egos/scripts/vault-knowledge-pipeline.ts",
+      "resolved_path": "home/enio/egos/scripts/vault-knowledge-pipeline.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 314,
+      "target_raw": "/home/enio/egos/scripts/telegram-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/telegram-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 315,
+      "target_raw": "/home/enio/egos/scripts/gmail-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/gmail-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 316,
+      "target_raw": "/home/enio/egos/scripts/drive-sync.ts",
+      "resolved_path": "home/enio/egos/scripts/drive-sync.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 333,
+      "target_raw": "/home/enio/egos/agents/agents/gem-hunter.ts",
+      "resolved_path": "home/enio/egos/agents/agents/gem-hunter.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 334,
+      "target_raw": "/home/enio/egos/agents/api/gem-hunter-server.ts",
+      "resolved_path": "home/enio/egos/agents/api/gem-hunter-server.ts"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 335,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/SSOT.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/SSOT.md",
+      "candidates": [
+        "docs/central-egos/SSOT.md",
+        "docs/gem-hunter/SSOT.md",
+        "docs/concepts/mycelium/SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 336,
+      "target_raw": "/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "resolved_path": "home/enio/egos/docs/gem-hunter/gems-2026-05-14.md",
+      "candidates": [
+        "docs/gem-hunter/gems-2026-05-14.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 337,
+      "target_raw": "/home/enio/egos/docs/products/gem-hunter.md",
+      "resolved_path": "home/enio/egos/docs/products/gem-hunter.md",
+      "candidates": [
+        "docs/agents/gem-hunter.md",
+        "docs/products-specs/gem-hunter.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "source_line": 347,
+      "target_raw": "/home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ETHIK_TOKEN_SYSTEM.md",
+      "candidates": [
+        "docs/concepts/ETHIK_TOKEN_SYSTEM.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-claude-response.md",
+      "source_line": 3,
+      "target_raw": "/home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "resolved_path": "home/enio/egos/docs/_current_handoffs/handoff_2026-05-15_espiral-integrations-audit.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md",
+      "source_line": 136,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/egos-governance",
+      "resolved_path": "wiki/egos-governance"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/timeline_drafts/20260416-doc-drift-shield.en.md",
+      "source_line": 137,
+      "target_raw": "/wiki/harvestmd",
+      "resolved_path": "wiki/harvestmd"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CAPABILITY_SCHEMA.md",
+      "source_line": 146,
+      "target_raw": "capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/capabilities/CBC-EGOS-WHATSAPP-KERNEL-001.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/README_PADRAO_OURO.md",
+      "source_line": 139,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/LICENSE"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CLIENT_KB_DOCTRINE.md",
+      "source_line": 6,
+      "target_raw": "../../../tmp/codex-review-output.md",
+      "resolved_path": ".claude/worktrees/tmp/codex-review-output.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/MEMORY_SESSION_INDEX.md",
+      "source_line": 5,
+      "target_raw": "sessions/session_20260403_p19_continued_monetization.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/sessions/session_20260403_p19_continued_monetization.md",
+      "candidates": [
+        "docs/sessions/session_20260403_p19_continued_monetization.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/HANDOFF_CURRENT.md",
+      "source_line": 139,
+      "target_raw": "../strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/strategy/GUARD_BRASIL_DEMO_SCRIPT.md",
+      "candidates": [
+        "docs/strategy/guard-brasil/GUARD_BRASIL_DEMO_SCRIPT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 12,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p28.md",
+      "source_line": 13,
+      "target_raw": "apps/egos-hq/middleware.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/middleware.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 7,
+      "target_raw": "packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 8,
+      "target_raw": "packages/guard-brasil/src/lib/public-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/public-guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 9,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 10,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 14,
+      "target_raw": "packages/shared/src/prompt-assembler.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/shared/src/prompt-assembler.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 15,
+      "target_raw": "packages/shared/src/memory-store.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/shared/src/memory-store.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 16,
+      "target_raw": "../852/src/lib/rate-limit.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/852/src/lib/rate-limit.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "packages/shared/src/eval/runner.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/shared/src/eval/runner.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 17,
+      "target_raw": "../852/src/eval/golden/852.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/852/src/eval/golden/852.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 18,
+      "target_raw": "../egos-lab/apps/egos-web/api/_chat-guard.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/egos-lab/apps/egos-web/api/_chat-guard.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md",
+      "source_line": 27,
+      "target_raw": "docs/social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 10,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 11,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 12,
+      "target_raw": "../../supabase/migrations/20260416_timeline_interconnection.sql",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/supabase/migrations/20260416_timeline_interconnection.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 17,
+      "target_raw": "../../scripts/x-post.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/scripts/x-post.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md",
+      "source_line": 18,
+      "target_raw": "../../scripts/insert-draft.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/scripts/insert-draft.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 25,
+      "target_raw": "../social/X_POSTS_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/social/X_POSTS_SSOT.md",
+      "candidates": [
+        "docs/social/X_POSTS_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 26,
+      "target_raw": "../ENIO_DEVELOPER_TIMELINE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/ENIO_DEVELOPER_TIMELINE.md",
+      "candidates": [
+        "docs/governance/ENIO_DEVELOPER_TIMELINE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 35,
+      "target_raw": "../knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md",
+      "source_line": 36,
+      "target_raw": "../CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 13,
+      "target_raw": "docs/INCIDENTS/",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/INCIDENTS"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 14,
+      "target_raw": "docs/governance/PIPELINE_DIAGRAM.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_DIAGRAM.md",
+      "candidates": [
+        "docs/governance/PIPELINE_DIAGRAM.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 15,
+      "target_raw": "docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/jobs/ENC-L1-006-agent-execution-evidence.md",
+      "candidates": [
+        "docs/jobs/ENC-L1-006-agent-execution-evidence.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 16,
+      "target_raw": "docs/jobs/agent-smoke-test-2026-04-14.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/jobs/agent-smoke-test-2026-04-14.md",
+      "candidates": [
+        "docs/jobs/agent-smoke-test-2026-04-14.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 17,
+      "target_raw": "docs/governance/PIPELINE_SPEC.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/governance/PIPELINE_SPEC.md",
+      "candidates": [
+        "docs/governance/PIPELINE_SPEC.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-14.md",
+      "source_line": 18,
+      "target_raw": "scripts/test-governance.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/scripts/test-governance.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 26,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 51,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 64,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 79,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 80,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 100,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 111,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 230,
+      "target_raw": "apps/egos-hq/app/hq-components.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/hq-components.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 231,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md",
+      "source_line": 232,
+      "target_raw": "apps/egos-hq/app/api/hq/health/route.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/api/hq/health/route.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../social/ARTICLE_VOICE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/social/ARTICLE_VOICE.md",
+      "candidates": [
+        "docs/social/ARTICLE_VOICE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../supabase/migrations/20260417_article_schema_v1.sql",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/supabase/migrations/20260417_article_schema_v1.sql"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../drafts/",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/drafts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 7,
+      "target_raw": "../../agents/agents/article-writer.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/agents/agents/article-writer.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 8,
+      "target_raw": "../modules/CHATBOT_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/modules/CHATBOT_SSOT.md",
+      "candidates": [
+        "docs/modules/CHATBOT_SSOT.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../CLAUDE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/CLAUDE.md",
+      "candidates": [
+        "CLAUDE.md",
+        "central-egos/products/_template/CLAUDE.md",
+        "central-egos/products/advocacia-starter/CLAUDE.md",
+        "_build/advocacia/CLAUDE.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md",
+      "source_line": 9,
+      "target_raw": "../../.claude/commands/end.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/.claude/commands/end.md",
+      "candidates": [
+        "docs/agents/end.md",
+        "docs/workflows/end.md",
+        ".claude/commands/end.md",
+        ".agents/workflows/end.md",
+        ".windsurf/workflows/end.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 9,
+      "target_raw": "apps/egos-hq/app/page.tsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/egos-hq/app/page.tsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 11,
+      "target_raw": "scripts/archive-tasks.sh",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/scripts/archive-tasks.sh"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 12,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md",
+      "source_line": 13,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 5,
+      "target_raw": "packages/guard-brasil/src/lib/evidence-chain.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/lib/evidence-chain.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 6,
+      "target_raw": "packages/guard-brasil/src/guard.test.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.test.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 7,
+      "target_raw": ".gitleaks.toml",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.gitleaks.toml"
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 8,
+      "target_raw": "docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/strategy/KB_AS_A_SERVICE_PLAN.md",
+      "candidates": [
+        "docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md",
+      "source_line": 9,
+      "target_raw": "TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 11,
+      "target_raw": "../opus-mode/OPUS_MODE_V1.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/opus-mode/OPUS_MODE_V1.md",
+      "candidates": [
+        "docs/opus-mode/OPUS_MODE_V1.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-24.md",
+      "source_line": 12,
+      "target_raw": "../opus-mode/README.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/opus-mode/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-23.md",
+      "source_line": 23,
+      "target_raw": "../infra/SUBDOMAINS_INVENTORY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/infra/SUBDOMAINS_INVENTORY.md",
+      "candidates": [
+        "docs/infra/SUBDOMAINS_INVENTORY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 10,
+      "target_raw": ".hermes-agent/",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.hermes-agent"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-07_hermes-claude-oauth.md",
+      "source_line": 16,
+      "target_raw": ".hermes-agent/scripts/refresh-token.py",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.hermes-agent/scripts/refresh-token.py"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 9,
+      "target_raw": "docs/GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/docs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 10,
+      "target_raw": ".guarani/orchestration/SSOT_RULES.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.guarani/orchestration/SSOT_RULES.md",
+      "candidates": [
+        ".guarani/orchestration/SSOT_RULES.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md",
+      "source_line": 11,
+      "target_raw": ".husky/pre-commit",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/.husky/pre-commit"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/Dockerfile",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/api/Dockerfile"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 12,
+      "target_raw": "apps/api/docker-compose.prod.yml",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/api/docker-compose.prod.yml"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "apps/api/src/server.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/apps/api/src/server.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/guard-brasil/src/guard.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/guard-brasil/src/guard.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 19,
+      "target_raw": "packages/shared/src/billing/pricing.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/packages/shared/src/billing/pricing.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 34,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/egos-lab/apps/eagle-eye/src/modules/licitacoes/document-parser.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-04-03_p19_monetization.md",
+      "source_line": 35,
+      "target_raw": "../../../egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/egos-lab/apps/eagle-eye/src/modules/licitacoes/insight-generator.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 10,
+      "target_raw": "../../packages/guard-brasil/src/pii-patterns.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/packages/guard-brasil/src/pii-patterns.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 11,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 12,
+      "target_raw": "../../business/GUARD_BRASIL_MARKET_REPORT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/business/GUARD_BRASIL_MARKET_REPORT.md",
+      "candidates": [
+        "docs/_archived/business/GUARD_BRASIL_MARKET_REPORT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 15,
+      "target_raw": "../../docs/knowledge/HARVEST.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/docs/knowledge/HARVEST.md",
+      "candidates": [
+        "docs/knowledge/HARVEST.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-04/handoff_2026-03-31.md",
+      "source_line": 16,
+      "target_raw": "../../docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 387,
+      "target_raw": "../../README.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/README.md",
+      "candidates": [
+        "README.md",
+        "infra/egos-site/README.md",
+        "docs/drafts/README.md",
+        "docs/_out-of-scope/trading/README.md",
+        "docs/validation/README.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 388,
+      "target_raw": "../GTM_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/GTM_SSOT.md",
+      "candidates": [
+        "docs/GTM_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md",
+      "source_line": 389,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 33,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 48,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 76,
+      "target_raw": "/home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "resolved_path": "home/enio/egos/docs/PAPERCLIP_STRUCTURE.md",
+      "candidates": [
+        "docs/_archived_handoffs/2026-05/PAPERCLIP_STRUCTURE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md",
+      "source_line": 113,
+      "target_raw": "/home/enio/egos/scripts/dpio-assessment.ts",
+      "resolved_path": "home/enio/egos/scripts/dpio-assessment.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 17,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 18,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 19,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 20,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 21,
+      "target_raw": "pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md",
+      "candidates": [
+        "docs/pitch/DECK_5_SLIDES_EQUITY_PARTNERSHIP.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 22,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "archived",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 28,
+      "target_raw": "business/MONETIZATION_SSOT.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/business/MONETIZATION_SSOT.md",
+      "candidates": [
+        "docs/_archived/2026-04/MONETIZATION_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 29,
+      "target_raw": "outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md",
+      "candidates": [
+        "docs/strategy/outreach/PROSPECTS_TIER_A_B_C_10_QUALIFICADOS.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 30,
+      "target_raw": "social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/social/X_POST_PROFILE_PARTNERSHIP_2026-04-06.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 31,
+      "target_raw": "INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/INTELIGENCIA_TOPOLOGY_REALITY_2026-04-06.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 32,
+      "target_raw": "../../TASKS.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 70,
+      "target_raw": "partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/GUARD_BRASIL_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 71,
+      "target_raw": "partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EGOS_INTELIGENCIA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 72,
+      "target_raw": "partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/EAGLE_EYE_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 73,
+      "target_raw": "partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/partner-briefs/FORJA_PARTNER_BRIEF.md",
+      "candidates": [
+        "docs/strategy/outreach/partner-briefs/FORJA_PARTNER_BRIEF.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md",
+      "source_line": 106,
+      "target_raw": "legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/_archived_handoffs/2026-05/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md",
+      "candidates": [
+        "docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 23,
+      "target_raw": "apps/central-egos-template/src/app/api/admin/import/route.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/apps/central-egos-template/src/app/api/admin/import/route.ts"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 44,
+      "target_raw": "tests/fixtures/import/sample-10-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/tests/fixtures/import/sample-10-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 45,
+      "target_raw": "tests/fixtures/import/sample-edge-cases.xlsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/tests/fixtures/import/sample-edge-cases.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/MCP_AI_IMPORT_TEST.md",
+      "source_line": 46,
+      "target_raw": "tests/fixtures/import/sample-100-products.xlsx",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/tests/fixtures/import/sample-100-products.xlsx"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "source_line": 5,
+      "target_raw": "packages/mcp-g-pecas/src/index.ts",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/planning/packages/mcp-g-pecas/src/index.ts"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/INDEX.md",
+      "source_line": 48,
+      "target_raw": "../DOC_DRIFT_SHIELD.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/DOC_DRIFT_SHIELD.md",
+      "candidates": [
+        "docs/governance/DOC_DRIFT_SHIELD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 4,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 250,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 256,
+      "target_raw": "SECURITY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/SECURITY.md",
+      "candidates": [
+        "SECURITY.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/OPERATIONS.md",
+      "source_line": 257,
+      "target_raw": "TROUBLESHOOTING.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/products/anythingllm/TROUBLESHOOTING.md"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/social/ARTICLE_VOICE.md",
+      "source_line": 124,
+      "target_raw": "/timeline/evidence-first-principle",
+      "resolved_path": "timeline/evidence-first-principle"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/social/ARTICLE_VOICE.md",
+      "source_line": 133,
+      "target_raw": "/wiki/mycelium-event-bus",
+      "resolved_path": "wiki/mycelium-event-bus"
+    },
+    {
+      "class": "ambiguous",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/knowledge/CAPABILITY_CROSS_INDEX.md",
+      "source_line": 11,
+      "target_raw": "docs/CAPABILITY_REGISTRY.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/knowledge/docs/CAPABILITY_REGISTRY.md",
+      "candidates": [
+        "docs/CAPABILITY_REGISTRY.md",
+        "scripts/egos-home/docs/CAPABILITY_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/knowledge/GOVTECH_PARTNER_ONEPAGER.md",
+      "source_line": 110,
+      "target_raw": "/docs/compliance/LGPD",
+      "resolved_path": "docs/compliance/LGPD"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md",
+      "source_line": 9,
+      "target_raw": "../governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 44,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAIS_VISION.md",
+      "candidates": [
+        "docs/concepts/ESPIRAIS_VISION.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "source_line": 46,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "resolved_path": "home/enio/egos/docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md",
+      "candidates": [
+        "docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/concepts/ESPIRAIS_VISION.md",
+      "source_line": 4,
+      "target_raw": "/home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf",
+      "resolved_path": "home/enio/egos/docs/concepts/artifacts/EGOS_Espiral_Handoff_v5.pdf"
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/commands/end.md",
+      "source_line": 402,
+      "target_raw": "file.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/commands/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/commands/start.md",
+      "source_line": 231,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/commands/start.md",
+      "source_line": 254,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/commands/start.md",
+      "source_line": 316,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/.claude/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 3,
+      "target_raw": "../../docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "candidates": [
+        "docs/governance/EGOS_COMERCIO_PLANO_UNICO.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 4,
+      "target_raw": "../../docs/sales/PARTNER_PLAYBOOK.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/docs/sales/PARTNER_PLAYBOOK.md",
+      "candidates": [
+        "docs/strategy/PARTNER_PLAYBOOK.md"
+      ]
+    },
+    {
+      "class": "dead",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/template/README.md",
+      "source_line": 57,
+      "target_raw": "../../../docs/templates/PRICING_SSOT.md",
+      "resolved_path": ".claude/worktrees/docs/templates/PRICING_SSOT.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/template/README.md",
+      "source_line": 69,
+      "target_raw": "../../../docs/governance/CLIENT_TIERS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_TIERS_MATRIX.md",
+      "candidates": [
+        "docs/governance/CLIENT_TIERS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/template/README.md",
+      "source_line": 70,
+      "target_raw": "../../../docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "resolved_path": ".claude/worktrees/docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md",
+      "candidates": [
+        "docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/template/README.md",
+      "source_line": 71,
+      "target_raw": "../../../docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "resolved_path": ".claude/worktrees/docs/runbooks/MOBILE_ACCESS_GUIDE.md",
+      "candidates": [
+        "docs/runbooks/MOBILE_ACCESS_GUIDE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/README.md",
+      "source_line": 67,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/README.md",
+      "source_line": 68,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/central-egos/README.md",
+      "source_line": 69,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/[^'\"./][^'\"]*"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/tools/egos-self/LICENSE"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": ".claude/worktrees/agent-a9a0bc5c105615ef6/packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": ".claude/worktrees/agent-a9a0bc5c105615ef6/packages/guard-brasil-python/LICENSE"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "EGOS/copilot/copilot-custom-prompts/Clip YouTube Transcript.md",
+      "source_line": 67,
+      "target_raw": "<video_url>&t=<seconds>s",
+      "resolved_path": "EGOS/copilot/copilot-custom-prompts/<video_url>&t=<seconds>s"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 3,
+      "target_raw": "../../docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "resolved_path": "central-egos/docs/governance/EGOS_COMERCIO_PLANO_UNICO.md",
+      "candidates": [
+        "docs/governance/EGOS_COMERCIO_PLANO_UNICO.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/docs/commercial/DEMO_SALES_PLAYBOOK.md",
+      "source_line": 4,
+      "target_raw": "../../docs/sales/PARTNER_PLAYBOOK.md",
+      "resolved_path": "central-egos/docs/sales/PARTNER_PLAYBOOK.md",
+      "candidates": [
+        "docs/strategy/PARTNER_PLAYBOOK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/products/_shared/personas/README.md",
+      "source_line": 15,
+      "target_raw": "../../DOMAIN_TEMPLATE_SPEC.md",
+      "resolved_path": "central-egos/products/DOMAIN_TEMPLATE_SPEC.md",
+      "candidates": [
+        "docs/governance/DOMAIN_TEMPLATE_SPEC.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/products/_shared/personas/README.md",
+      "source_line": 16,
+      "target_raw": "../../../docs/governance/LAYER_0_SSOT.md",
+      "resolved_path": "central-egos/docs/governance/LAYER_0_SSOT.md",
+      "candidates": [
+        "docs/governance/LAYER_0_SSOT.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/README.md",
+      "source_line": 71,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "resolved_path": "docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/README.md",
+      "source_line": 72,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "resolved_path": "docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_TEMPLATE_ARCHITECTURE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/README.md",
+      "source_line": 73,
+      "target_raw": "../docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "resolved_path": "docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md",
+      "candidates": [
+        "central-egos/docs/governance/CENTRAL_EGOS_STATUS_MATRIX.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "central-egos/README.md",
+      "source_line": 77,
+      "target_raw": "../docs/sales/PARTNER_COMMISSIONS.md",
+      "resolved_path": "docs/sales/PARTNER_COMMISSIONS.md",
+      "candidates": [
+        "docs/strategy/PARTNER_COMMISSIONS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "notebooklm_export_egos.md",
+      "source_line": 6367,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": "[^'\"./][^'\"]*"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "notebooklm_export_egos.md",
+      "source_line": 6368,
+      "target_raw": "[^'\"./][^'\"]*",
+      "resolved_path": "[^'\"./][^'\"]*"
+    },
+    {
+      "class": "dead",
+      "source_file": ".agents/workflows/end.md",
+      "source_line": 552,
+      "target_raw": "file.md",
+      "resolved_path": ".agents/workflows/file.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".agents/workflows/start.md",
+      "source_line": 265,
+      "target_raw": "../docs/start-layers/leaf-ssot.md",
+      "resolved_path": ".agents/docs/start-layers/leaf-ssot.md",
+      "candidates": [
+        "docs/start-layers/leaf-ssot.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".agents/workflows/start.md",
+      "source_line": 288,
+      "target_raw": "../docs/start-layers/evolution-health.md",
+      "resolved_path": ".agents/docs/start-layers/evolution-health.md",
+      "candidates": [
+        "docs/start-layers/evolution-health.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": ".agents/workflows/start.md",
+      "source_line": 376,
+      "target_raw": "../docs/start-layers/capability-delta.md",
+      "resolved_path": ".agents/docs/start-layers/capability-delta.md",
+      "candidates": [
+        "docs/start-layers/capability-delta.md"
+      ]
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".agents/workflows/start-guarani.md",
+      "source_line": 18,
+      "target_raw": "file:///home/enio/egos/.guarani/GUARANI.md",
+      "resolved_path": ".agents/workflows/file:/home/enio/egos/.guarani/GUARANI.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".agents/workflows/start-guarani.md",
+      "source_line": 19,
+      "target_raw": "file:///home/enio/egos/AGENTS.md",
+      "resolved_path": ".agents/workflows/file:/home/enio/egos/AGENTS.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".agents/workflows/start-guarani.md",
+      "source_line": 20,
+      "target_raw": "file:///home/enio/egos/CLAUDE.md",
+      "resolved_path": ".agents/workflows/file:/home/enio/egos/CLAUDE.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".agents/workflows/start-guarani.md",
+      "source_line": 74,
+      "target_raw": "file:///home/enio/egos/docs/EGOS_BOOTSTRAP.md",
+      "resolved_path": ".agents/workflows/file:/home/enio/egos/docs/EGOS_BOOTSTRAP.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".agents/workflows/start-guarani.md",
+      "source_line": 75,
+      "target_raw": "file:///home/enio/egos/.guarani/GUARANI.md#L20",
+      "resolved_path": ".agents/workflows/file:/home/enio/egos/.guarani/GUARANI.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "tools/egos-self/README.md",
+      "source_line": 167,
+      "target_raw": "ROADMAP.md",
+      "resolved_path": "tools/egos-self/ROADMAP.md",
+      "candidates": [
+        "docs/strategy/ROADMAP.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "tools/egos-self/README.md",
+      "source_line": 217,
+      "target_raw": "LICENSE",
+      "resolved_path": "tools/egos-self/LICENSE"
+    },
+    {
+      "class": "archived",
+      "source_file": "SECURITY.md",
+      "source_line": 126,
+      "target_raw": "docs/jobs/2026-04-09-code-security.md",
+      "resolved_path": "docs/jobs/2026-04-09-code-security.md",
+      "candidates": [
+        "docs/jobs/_archived/2026-04/2026-04-09-code-security.md"
+      ]
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".guarani/ANTIGRAVITY_RULES.md",
+      "source_line": 6,
+      "target_raw": "file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md",
+      "resolved_path": ".guarani/file:/home/enio/egos/docs/governance/agent_scopes_and_governance.md"
+    },
+    {
+      "class": "noise_file_protocol",
+      "source_file": ".guarani/orchestration/LLM_ORCHESTRATION_MATRIX.md",
+      "source_line": 4,
+      "target_raw": "file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md",
+      "resolved_path": ".guarani/orchestration/file:/home/enio/egos/docs/governance/agent_scopes_and_governance.md"
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 3,
+      "target_raw": "strategy/CAPABILITY_NARRATIVE.md",
+      "resolved_path": "scripts/egos-home/docs/strategy/CAPABILITY_NARRATIVE.md",
+      "candidates": [
+        "docs/strategy/CAPABILITY_NARRATIVE.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 3,
+      "target_raw": "strategy/NAME_AND_PROVE_PLAN.md",
+      "resolved_path": "scripts/egos-home/docs/strategy/NAME_AND_PROVE_PLAN.md",
+      "candidates": [
+        "docs/strategy/NAME_AND_PROVE_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 12,
+      "target_raw": "governance/CAPABILITY_SCHEMA.md",
+      "resolved_path": "scripts/egos-home/docs/governance/CAPABILITY_SCHEMA.md",
+      "candidates": [
+        "docs/governance/CAPABILITY_SCHEMA.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 15,
+      "target_raw": "governance/MCP_REGISTRY.md",
+      "resolved_path": "scripts/egos-home/docs/governance/MCP_REGISTRY.md",
+      "candidates": [
+        "docs/governance/MCP_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 15,
+      "target_raw": "governance/INTEGRATION_REGISTRY.md",
+      "resolved_path": "scripts/egos-home/docs/governance/INTEGRATION_REGISTRY.md",
+      "candidates": [
+        "docs/governance/INTEGRATION_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 15,
+      "target_raw": "governance/SKILLS_REGISTRY.md",
+      "resolved_path": "scripts/egos-home/docs/governance/SKILLS_REGISTRY.md",
+      "candidates": [
+        "docs/governance/SKILLS_REGISTRY.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2734,
+      "target_raw": "docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "resolved_path": "scripts/egos-home/docs/docs/planning/MCP_WRITE_EXPAND_PLAN.md",
+      "candidates": [
+        "docs/planning/MCP_WRITE_EXPAND_PLAN.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "scripts/egos-home/docs/CAPABILITY_REGISTRY.md",
+      "source_line": 2789,
+      "target_raw": "governance/IDENTITY_AND_METHOD.md",
+      "resolved_path": "scripts/egos-home/docs/governance/IDENTITY_AND_METHOD.md",
+      "candidates": [
+        "docs/governance/IDENTITY_AND_METHOD.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 13,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 181,
+      "target_raw": "/home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "resolved_path": "home/enio/egos/docs/guides/DPIO_FRAMEWORK.md",
+      "candidates": [
+        "docs/guides/DPIO_FRAMEWORK.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 183,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "moved_ambiguous_by_scope",
+      "source_file": "policia/docs/DPIO_DHPP_ASSESSMENT.md",
+      "source_line": 184,
+      "target_raw": "/home/enio/egos/TASKS.md",
+      "resolved_path": "home/enio/egos/TASKS.md",
+      "candidates": [
+        "TASKS.md"
+      ]
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "apps/egos-hq/README.md",
+      "source_line": 214,
+      "target_raw": "privado",
+      "resolved_path": "apps/egos-hq/privado"
+    },
+    {
+      "class": "non_md_ref",
+      "source_file": "packages/guard-brasil-python/README.md",
+      "source_line": 344,
+      "target_raw": "LICENSE",
+      "resolved_path": "packages/guard-brasil-python/LICENSE"
+    }
+  ],
+  "wave2": {
+    "generated": "2026-06-10T09:01:52.443063",
+    "scope": ".claude/**/*.md + .agents/**/*.md (excluding worktrees)",
+    "before_fix": {
+      "missing": 1552
+    },
+    "after_fix": {
+      "missing": 1546
+    },
+    "delta": {
+      "fixed": 6
+    },
+    "files_modified": [
+      ".claude/commands/start.md",
+      ".agents/workflows/start.md"
+    ],
+    "examples": [
+      {
+        "file": ".claude/commands/start.md",
+        "ref_old": "../docs/start-layers/leaf-ssot.md",
+        "ref_new": "../../docs/start-layers/leaf-ssot.md",
+        "reason": "file is at .claude/commands/ depth, so ../docs resolves to .claude/docs (missing); ../../docs resolves to repo root docs/ (exists)"
+      },
+      {
+        "file": ".claude/commands/start.md",
+        "ref_old": "../docs/start-layers/evolution-health.md",
+        "ref_new": "../../docs/start-layers/evolution-health.md",
+        "reason": "same depth correction"
+      },
+      {
+        "file": ".agents/workflows/start.md",
+        "ref_old": "../docs/start-layers/capability-delta.md",
+        "ref_new": "../../docs/start-layers/capability-delta.md",
+        "reason": "file is at .agents/workflows/ depth; same correction as .claude/commands/"
+      }
+    ],
+    "skipped": {
+      "worktrees": 546,
+      "reason": "worktrees excluded per safety rule — they are transient copies that will be cleaned up"
+    },
+    "remaining_moved_ambiguous_scope": {
+      "total_original": 574,
+      "worktrees": 546,
+      "real_claude_agents_fixed": 6,
+      "other_not_in_scope": 22,
+      "note": "The 22 \"other\" items span TASKS.md (frozen), central-egos/, policia/, scripts/egos-home/ — outside .claude/.agents wave scope"
+    }
+  },
+  "class_summary_wave2": {
+    "noise_file_protocol": 95,
+    "non_md_ref": 128,
+    "dead": 604,
+    "ambiguous": 114,
+    "archived": 37,
+    "moved_ambiguous_by_scope": 568
+  }
+}
\ No newline at end of file
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..b39c5e51 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T12:06:39.878Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1379",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 372d18fd..0ad52da6 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -222,5 +222,29 @@
     "duration_ms": null,
     "event": "commit:feat files=9 sha=d4f57d5a",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:38:50.425Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=15 sha=c5ed3947",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:03:21.067Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=6 sha=749d8d59",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
   }
 ]
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
diff --git a/docs/strategy/ROADMAP.md b/docs/strategy/ROADMAP.md
index 2f134129..cf08421b 100644
--- a/docs/strategy/ROADMAP.md
+++ b/docs/strategy/ROADMAP.md
@@ -767,3 +767,523 @@ GOW-AUTORES-001 · GOW-SISTEMAS-001 · GOW-EVIDENCIAS-001 · GOW-CONSOLIDA-001 
   - [x] Create Python skill `scripts/skills/scihub_skill.py` for Hermes Agent with mirror rotation & fallback (2026-06-01)
   - [x] Establish governance guidelines in `docs/governance/SCIHUB_INTEGRATION_RULE.md` enforcing R7 & R8 (2026-06-01)
   - [ ] Execute dynamic queries in production & verify integration
+
+---
+
+## Movido de TASKS.md 2026-06-10 (TASKS-ARCHIVE-NOW-001 / TASKS-OVERFLOW-001)
+
+> **Critério de movimentação:** longo prazo (P2/P3 sem gate imediato), congelados, spec puro sem execução nos próximos 30 dias, ou contexto histórico de sprints encerradas.
+> **Zero perda:** todos os IDs abaixo foram transferidos verbatim. Redigitar em TASKS.md somente quando frente abrir espaço.
+
+### 🎓 EGOS FOUNDERS COURSE — produto educacional público
+
+> **Banda:** Crítico=RESSALVAS · Apoiador=RESSALVAS · Questionador=RECUSAR programa completo · **Maestro=APROVADO MVP mínimo**
+> **MVP lote R$8:** (1) aula inaugural 45-60min — demo Guard Brasil ao vivo; (2) PDF "método EGOS em uma página"; (3) acesso ao WhatsApp privado "EGOS" (lifetime); (4) acesso antecipado módulos futuros.
+> **Nome recomendado:** "EGOS: Governança de IA para Investigadores" · **Gate:** corte Enio no texto + verificação estatuto PCMG antes de qualquer cobrança.
+> **Produto:** lifetime access · Telegram aberto (gratuito, qualquer pessoa) · WhatsApp "EGOS" privado (pago) · Hotmart principal + multi-plataforma possível + egos.ia.br · unidades limitadas por plataforma · preço pode mudar a qualquer momento.
+
+- [ ] **COURSE-MVP-CONTENT-001** [P1] `voz`+`prime` `gated:HITL` 🔴 — Produzir conteúdo do MVP lote R$8: (1) roteiro da aula inaugural; (2) PDF "O método EGOS em uma página"; (3) descrição do que o comprador recebe hoje vs roadmap. HITL: corte Enio no texto antes de publicar.
+- [ ] **COURSE-HOTMART-SETUP-001** [P1] `prime` `gated:HITL` — Configurar produto no Hotmart com preço R$8 lote fundador + lifetime access + webhook pós-compra.
+- [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram público "EGOS Framework" (aberto, gratuito).
+- [ ] **COURSE-WHATSAPP-PRIVATE-001** [P1] `prime` `gated:HITL` — Configurar grupo WhatsApp privado "EGOS" (só quem pagou).
+- [ ] **COURSE-PAYMENT-EASY-001** [P1] `prime` — Configurar pagamento com poucos cliques (Hotmart + Pix em destaque).
+- [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade.
+- [ ] **COURSE-OWN-PLATFORM-001** [P2] `pixel`+`prime` — Pesquisar venda direta via egos.ia.br (Asaas PF).
+- [ ] **COURSE-CRYPTO-WALLETS-001** [P2] `prime` `gated:HITL` 🔴 — Configurar recebimento em cripto. NUNCA seed/private key em git.
+- [ ] **COURSE-SALES-PAGE-001** [P1] `voz` `gated:HITL` — Criar página de venda inicial.
+- [ ] **COURSE-LAUNCH-CONTENT-001** [P1] `voz` `gated:HITL` — Criar textos de divulgação.
+- [ ] **COURSE-PCMG-GATE-001** [P0] `redzone` 🔴 — Verificar formalmente se recebimento por cursos é compatível com estatuto PCMG.
+- [ ] **COURSE-DISTRIBUTION-MAP-001** [P1] `voz`+`curador` — Mapa de distribuição do curso.
+- [ ] **COURSE-PLATFORMS-MEMORY-001** [P1] `curador` — Pesquisar links atualizados de configuração de memória em ChatGPT/Gemini/Claude/Grok.
+- [ ] **COURSE-YOUTUBE-CHANNEL-001** [P2] `prime` — Estruturar canal YouTube EGOS.
+- [ ] **COURSE-LINKEDIN-STRATEGY-001** [P2] `voz` — Estratégia LinkedIn.
+
+### 📖 README EGOS — OVERHAUL
+
+> aiox-core README como referência de qualidade: hooks por IDE, "Comece Aqui 10min", CLI First hierarquia, badges, first-value binário.
+
+- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo padrão aiox com PT-BR obrigatório.
+- [ ] **README-PUBLICO-PT-001** [P1] `voz` `gated:HITL` — Traduzir seções em inglês do README público (egos-governance) para PT-BR.
+- [ ] **README-HOOKS-TABLE-001** [P1] `curador` — Criar tabela de paridade de hooks EGOS por IDE.
+- [ ] **README-FIRST-VALUE-001** [P1] `voz` — Definir "first-value EGOS" (binário, ≤10min).
+- [ ] **README-MULTILINGUAL-001** [P2] `voz` — Criar README.en.md.
+- [ ] **README-BADGES-001** [P1] `prime` — Adicionar badges ao README.md.
+
+### 🎬 MODO GRAVAÇÃO + TUTOR MODULAR + X402 + EPISÓDIOS
+
+- [ ] **RECORD-MODE-001** [P1] `prime`+`pixel` — Criar skill `/record` (modo gravação de episódio).
+- [ ] **CONTENT-TAGGING-001** [P1] `curador` — Sistema de tags para todo conteúdo EGOS.
+- [ ] **X402-INTEGRATION-001** [P2] `prime`+`guardiao` `gated:RedZone` — Implementar protocolo x402.
+- [ ] **X402-CONTENT-PRICE-001** [P2] `prime` — Tabela de preços x402 por tipo de conteúdo.
+- [ ] **EPISODE-EDITOR-PROMPT-001** [P1] `voz` — Metaprompt MP-EPISODE-EDIT-001.
+- [ ] **MCP-CONTENT-GATEWAY-001** [P2] `prime`+`hermes-ops` — Expor conteúdo via endpoint público com autenticação x402.
+- [ ] **RECORD-SESSION-001** [P1] `prime` — Implementar skill /record.
+- [ ] **EPISODE-001-SCRIPT-001** [P1] `voz` `gated:HITL` — Roteiro Episódio 1.
+- [ ] **EPISODE-TAGS-SYSTEM-001** [P2] `curador` — Sistema de tags para episódios.
+- [ ] **X402-SPEC-001** [P2] `prime`+`guardiao` — Especificar completamente o x402.
+- [ ] **LLMS-TXT-001** [P1] `pixel` — Criar /llms.txt no egos.ia.br.
+
+### 🔍 VALIDAÇÃO DE VALOR PÚBLICO + COMERCIAL
+
+- [ ] **CRYPTO-WALLETS-FILL-001** [P0] `prime` `gated:HITL` 🔴 — Enio fornece endereços públicos de recebimento cripto.
+- [ ] **SOCIAL-COPY-APPROVE-001** [P0] `prime` `gated:HITL` 🔴 — Enio aprova copy completo antes de qualquer publicação.
+- [ ] **INSTAGRAM-CREATE-001** [P1] `prime` `gated:HITL` — Enio cria conta Instagram da entidade EGOS.
+- [ ] **VALIDATE-AI-EXTERNAL-001** [P1] `provador` — Testar material público com múltiplos modelos de IA.
+- [ ] **SALES-PAGE-HTML-001** [P1] `pixel` — Converter sales page em HTML responsivo.
+- [ ] **KIWIFY-SETUP-001** [P1] `prime` `gated:HITL` — Configurar produto na Kiwify após primeiras 5 vendas.
+- [ ] **PUBLIC-REPO-CONTENT-001** [P1] `guardiao`+`prime` `gated:HITL` — Definir e publicar conteúdo no repo público.
+- [ ] **AI-EVAL-RUN-001** [P2] `provador` — Executar protocolo VALIDATE-AI-EXTERNAL-001.
+
+### 💼 VISÃO DE NEGÓCIOS / COMÉRCIO
+
+> Capacidades comerciais (vendas/marketing/lógica-de-mercado). Fonte: Conselho Alpha (amigo do Enio). Projetos do amigo (Steak Patos/Pixel Art/WHITEHAND) — HITL, não expor.
+
+- [ ] **BIZ-CONSELHO-ALPHA-001** [P1] `forja` — Construir modo `/conselho` (Banda Cognitiva de NEGÓCIO): 8 lentes.
+- [ ] **BIZ-VOZ-GOVERNED-001** [P1] `voz` — Unificar Vitória/Bianca num ÚNICO agente Voz governado.
+- [ ] **BIZ-METAPROMPTS-001** [P1] `curador` `gated:BIZ-CONSELHO-ALPHA-001` — Gerar metaprompts de negócio via gerador.
+- [ ] **BIZ-CAPABILITIES-001** [P2] `prime` — Registrar capacidades comerciais no CAPABILITY_REGISTRY.md.
+- [ ] **BIZ-FRIEND-COLLAB-001** [P2] `redzone` — Estruturar colaboração com o amigo.
+
+### 🎯 SESSÃO 2026-06-05 TARDE — Observatory, AIOX, Group Model
+
+- [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit`.
+- [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje.
+- [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS.
+- [ ] **ONLINE-PRESENCE-CHECKLIST-001** [P1] `prime` `gated:HITL` — Criar checklist de comparecimento online diário.
+- [ ] **AIOX-CASE-STUDY-001** [P2] `curador` — Extrair insights do PDF AIOX aplicáveis ao EGOS.
+
+### 🌐 COMUNICAÇÃO + README (blueprint)
+
+- [ ] **COMM-BLUEPRINT-APPLY-001** [P0] `voz`+`pixel` `gated:HITL` — Aplicar egos-communication-blueprint.md ao README.md principal. Score ≥ 8.0.
+- [ ] **METAPROMPTS-DISCOVERY-001** [P1] `curador` — Sistema de metaprompts de descoberta em 5 camadas.
+- [ ] **README-JSON-LD-001** [P2] `prime` — Adicionar JSON-LD no README.
+- [ ] **SITE-AI-DISCOVERY-001** [P2] `pixel` — Adicionar llms.txt + /.well-known/ai-plugin.json + /api/content-catalog.
+
+### 🎯 LOOP DE AQUISIÇÃO + ENTREGA #3-#7 — North Star (contexto histórico)
+
+> **SSOT:** `docs/strategy/EGOS_DISTRIBUTION_STRATEGY_REVIEW.md` · Decisão council (2026-05-30): A = objetivo · C = P0 · B = P1 (canal de conexão, não devtool de receita).
+> **Corte Enio 2026-06-02:** SaaS/storefront DESPRIORIZADO. Nova direção: participar de equipes, especializar stack ciberseg+OSINT+forense, cursos.
+
+- [ ] **CAQ-RESEARCHER-001** [P1] `nova-frente` — Estruturar proposta "pesquisador por resultado" p/ o contato: KPIs avaliáveis, período, modelo de ganho, NDA.
+
+### 🩺 PLAN v4 SURGERY — contexto histórico (2026-05-28)
+
+> Codex 5.5 medium recusou 11 tasks como "net negative". Aplicado: 3 gates (FREEZE /start+pricing | CAP decisões/semana | EXTERNAL INDICATOR antes publish). -5 DELETE -12 DEFER +0 ADD = -17 WIP.
+> Tasks com DEFER-GATE-A/B/C: bloqueadas até EGOS-PUBLIC done / Enio capacity / external adoption indicator.
+
+- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P2] `3h` — `/start` verifica TODOS repos GitHub Enio (fetch+drift+tasks P0 pendentes). Dep: REPO-INVENTORY-001.
+- [ ] **CROSS-REPO-README-UPDATE-001** [P1] `8h` — Atualizar READMEs baseado em audit; cada update HITL.
+  - [ ] **README-HERMES-EGOS-PT-BR** `2h` — seção PT-BR ao README do fork NousResearch.
+  - [ ] **README-EGOS-LAB-CHAT-EXPAND** `1h` — expandir README 97L.
+- [ ] **CROSS-REPO-TASKS-SYNC-001** [P1] `3h` — Consolida TASKS.md de todos repos em `docs/COORDINATION.md`.
+- [ ] **REPO-INVENTORY-001** [P2] `1h` — Output: `docs/governance/REPO_INVENTORY_2026-05-26.md` (TIER 1/2/3).
+
+### 🚀 EGOS-PUBLIC — Plano Mestre v3 (REBAIXADO P2)
+
+> **⏸️ REBAIXADO P2 (council 2026-05-30):** caminho B (distribuir o framework). Adiado até A medido.
+> **SSOT:** `docs/strategy/EGOS_PUBLIC_PLAN.md` | **Premortem:** `docs/audits/premortem-egos-public.md`
+
+### 🔄 HERMES LOOP CLOSURE — P1 Backlog (padrões/lifecycle/block/dashboard)
+
+> P0 completo 2026-05-26 (arquivado em TASKS_ARCHIVE.md §Hermes-Findings-2026-05-26).
+> Itens abaixo são P1/P2 da continuação do pipeline.
+
+- Patterns Detector: `scripts/hermes-patterns-detector.ts` — 545 findings → 1 padrão (threshold=3) → `~/.egos/hermes-patterns.jsonl`. Dep: dados normalizados pós-MIGRATE.
+- Lifecycle State Machine: `scripts/hermes-finding-update.ts` (440L) + state machine. Audit trail `~/.egos/hermes-finding-events.jsonl` (35 events iniciais).
+- Push Block: Lockfile `.egos/hermes-push-block.lock` com TTL/motivo/commit_sha. Pre-push hook checa lockfile. Override `HERMES_BLOCK_OVERRIDE=1`.
+- Dashboard: API `apps/egos-hq/app/api/hq/hermes-metrics/route.ts` + UI `apps/egos-hq/app/hermes/page.tsx`.
+
+### 🌐 SITE egos.ia.br — Reposicionamento + i18n (longo prazo)
+
+- [ ] **SITE-I18N-001** [P1] `prime` — Implementar i18n PT(default)/EN/ZH-Simplified via Paraglide JS.
+- [ ] **SITE-I18N-ZH-GATE-001** [P1] `redzone` — Gate de revisão humana p/ Chinês.
+- [ ] **SITE-DESIGN-3OPT-001** [P1] `redzone` — Produzir 3 opções de homepage. Corte Enio.
+- [ ] **SITE-EGOS-WIDGET-001** [P1] — Widget "arquiteto EGOS" interativo.
+- [ ] **SITE-TRUST-MATH-001** [P1] `redzone` — Mecanismo de confiança "provada com matemática".
+
+### 📝 ARTIGOS / TIMELINE
+
+- [ ] **ARTICLE-MULTIMEDIA-001** [P1] — Multimídia do artigo via NotebookLM MCP.
+
+### 📊 CAREER-GAP + TELEMETRIA + CTX-ROTATION
+
+- [/] **CAREER-GAP-001** [P1] `redzone` `research` — Matriz % de cobertura vs requisitos do role top (F1 forense on-chain).
+- [ ] **TELEMETRY-EPIC-001** [P1] — Spec do painel de telemetria unificado. Red Zone: corte Enio.
+- [ ] **TELEMETRY-SKILLS-001** [P2] `gated:EPIC` — Instrumentar toda invocação de skill/slash.
+- [ ] **TELEMETRY-MODELS-001** [P2] `gated:EPIC` — Logar todo call de modelo.
+- [ ] **TELEMETRY-AGENTS-001** [P2] `gated:EPIC` — Contar/logar agentes disparados.
+- [ ] **TELEMETRY-HUMAN-001** [P2] `gated:EPIC` — Eventos acionáveis-por-Enio (HITL/Red Zone/comandos).
+- [ ] **PROCESS-MUNITION-001** [P1] — Gerador de metaprompts no FLUXO (todo agente/task puxam metaprompt certo).
+- [ ] **TELEM-DIFF-001** [P1] — watcher post-commit loga diff-stats + cadence.
+- [ ] **TELEM-DRIFT-001** [P1] — `scripts/drift-score.ts` composto (doc-drift+task-drift+manifest+ui+rule-sync).
+- [ ] **TELEM-SCOREBOARD-001** [P2] — expor drift score no /status + blackboard.
+- [ ] **TELEM-AGENTS-001** [P2] — protocolo agente: lê blackboard no /start, loga diff no /end.
+- [ ] **CTX-ROTATION-001** [P1] `redzone→prime` — Camada de COERÊNCIA de framework como capability MCP. Red Zone: corte Enio no design.
+- [ ] **CTX-ROTATION-002** [P1] `redzone→prime` — Blackboard + worktree-per-agent (SQLite-WAL como SSOT compartilhado).
+- [ ] **CTX-ROTATION-003** [P2] `prime` — Onde mora a camada (estender egos-governance MCP ou MCP novo).
+
+### 🛡️ CYBERSECURITY KB + COMUNICAÇÃO ÉTICA
+
+- [ ] **CYBER-KB-002** [P2] — Conectar a cyber KB ao currículo do Enio (F1 forense + ciber + IA + polícia).
+- [ ] **COMM-ETHICS-001** [P2] `redzone` — Standard de comunicação ética: persuadir com VERDADE, estruturar pra clareza.
+
+### 🔍 RADICAL TRANSPARENCY / PROOF ARCHITECTURE (pesquisa, não impl ainda)
+
+> Missão: descobrir SE blockchain melhora a governança de IA do EGOS. Dossiê: `docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md`. Regra: só hash/manifest/attestation on-chain. Sem PII/secrets on-chain. Sem token.
+
+- [ ] **PROOF-MANIFEST-001** [P1] — Formato canônico do EGOS Proof Manifest.
+- [ ] **EAS-PROTO-001** [P1] — Protótipo decision attestation em Base testnet.
+- [ ] **RT-KPI-001** [P1] — KPIs (técnico/valor/risco) reusando telemetria existente.
+- [ ] **PROOF-DASH-001** [P2] — Dashboard/README de proofs.
+- [ ] **PROOF-NARRATIVE-001** [P2] `redzone` — Artigo/post explicando sem hype. HITL.
+- [ ] **PROOF-PERSONA-001** [P2] — Definir quem usaria/compraria de fato.
+- [ ] **PROOF-MODULES-001** [P2] — Modularizar: `egos-proof-{core,bitcoin,eas,registry,ui,policy}`.
+- [ ] **PROOF-VERDICT-001** [P2] `redzone` — Corte do Enio: vale a energia ou pausa e foca currículo/stack?
+
+### 🏗️ LAYER 0 + LAYER 1 — Fases B/C/D/E/F/G/H (backlog)
+
+> Origem: sessão Opus 4.7, engenharia reversa do template advocacia.
+> **Gate global:** NEEDS-HUMAN-VALIDATION por lote.
+
+- [ ] **PROV-EXTEND-001** [P2] `1h Sonnet` — Avaliar viabilidade de invocar `packages/shared/src/provenance.ts` no fluxo do advocacia-starter.
+- [ ] **PROV-EXTEND-002** [P2] `1h Sonnet` — Investigar Python port de `provenance.py`.
+- [ ] **L0-CODEX-006** [P2] `1h Sonnet` — Skeleton `_template/` subespecificado: adicionar stubs mínimos.
+- [ ] **NLM-CENTRAL-002** [P2] `1h Sonnet` — Template `NOTEBOOKLM.md` em `central-egos/products/_template/`.
+- [ ] **NLM-CENTRAL-003** [P2] `30min` — Wiring em Layer 0: política de notebooks NotebookLM em `LAYER_0_SSOT.md §6`.
+- [ ] **NLM-PRECOMMIT-001** [P2] `1h Sonnet` — pre-commit sinaliza notebook-sync pending p/ docs canônicos.
+- [ ] **NLM-COVERAGE-001** [P2] `1h` — substituir grep frágil de cobertura por parse estruturado da tabela.
+- [ ] **NLM-DIGITALTRUST-FASE2** [P2] `HITL` — fase 2 curadoria Digital Trust (127 fontes: D/G/C/E).
+
+### 🔍 SEO ENGINE (Gabi) — backlog pós-validação
+
+> **Tese:** motor de dados reusável → dashboard depois se validar. Docs SSOT: `docs/strategy/SEO_ENGINE_PROPOSAL.md`.
+> On-ramp $0: GSC + Keyword Planner faixas + Trends + free tiers SERP. DataForSEO = destino.
+
+- [ ] **SEO-MVP-003** [P1] `2h Sonnet` — GSC API (grátis, OAuth) se Gabi/cliente tem site.
+- [ ] **SEO-MVP-005** [P2] `validação` — Rodar `/keyword-temas` com tema real da Gabi.
+- [ ] **SEO-F1-001** [P1] `gate-humano` — FASE 1 (só após SEO-MVP-005 validar): criar conta DataForSEO + depósito $50.
+- [ ] **SEO-GEO-001** [P2] `defer` — FASE 2: visibilidade em IAs (DataForSEO AI Optimization).
+
+### 🔄 SEPARAÇÃO DE JANELAS — contexto histórico (2026-05-22)
+
+> Sprint encerrado. Registrado para referência histórica.
+> Janela Storefront/Governance: 16 commits entregues. Janela GPecas/Commercial: 3 commits.
+> Pendências que não foram resolvidas na sprint:
+
+- [ ] **MCP-AGNOSTIC-001** [P1] `26h` — refactor `packages/mcp-g-pecas` → `packages/mcp-storefront` agnostic (7 fases). Adiado por Enio 2026-05-25.
+- [ ] **GATEWAY-RPC-LEGACY-003** [P2] `1h` — remover RPCs legadas quando G Peças migrar para tabela neutral.
+- [ ] **GATEWAY-CORS-WHITELIST-004** [P2] `30min` — atualizar CORS no `/chat-web` para apecaspatense.egos.ia.br.
+- [ ] **CHAT-UI-WHITELIST-005** [P2] `1h` — adicionar `apecaspatense.egos.ia.br` em `allowedOrigins` no gateway.
+- [ ] **SMOKE-CROSS-TENANT-CI-007** [P2] `2h` — adicionar `smoke-cross-tenant.sh` ao CI quando novo tenant adicionado.
+
+### 🏛️ MULTI-AGENT GOVERNANCE — backlog
+
+- [ ] **GOV-AGENTS-003** [P2] `gated:002` — Wirar enforcement de escopo: pre-commit AST-check (arquivo tocado × perfil do agente).
+
+### 🛡️ RESOLVER DOCTRINE — follow-ups
+
+- [ ] **RESOLVER-002** [P2] `prime` — Surface mecânico: 1 linha da doutrina no pre-commit OU `scripts/triage.ts` que computa R=L/C.
+- [ ] **RESOLVER-003** [P3] `prime` — Replicar/sincronizar agentes do Guarani no Claude Code.
+
+### 🌐 SITE — Essência, voz, design (backlog pós-Red-Zone)
+
+- [/] **SITE-VOICE-001** [P1] `redzone` `research` — DRAFT pronto (`docs/strategy/EGOS_VOICE_GUIDE.md`). Resta: corte do Enio nas headlines + 5 perguntas.
+- [ ] **CURRICULUM-001** [P1] `redzone` — Substância aprovada Enio. Pendente: corte final + aterrissagem na seção "Sobre".
+
+### 📊 MATERIAL EVAL LOOP
+
+- [ ] **MATERIAL-EVAL-ANTIGRAVITY-001** [P2] — integrar Antigravity como avaliador no loop.
+- [ ] **MATERIAL-EVAL-CODEX-001** [P2] — integrar Codex como avaliador no loop.
+- [ ] **MATERIAL-EVAL-CRON-001** [P2] — cron semanal: rodar eval loop em todos materiais.
+
+### 🎯 COMERCIAL + EPOS
+
+- [ ] **DEMO-MATERIAL-001** [P1] `2h` — Pack material demo: PDF 1p + vídeo walkthrough roteiro.
+- [ ] **ONBOARD-CHECKLIST-001** [P1] `1h` — CLIENT_ONBOARDING_CHECKLIST.md atualizado (plano único).
+- [ ] **PRICING-COMMUNICATION-001** [P1] `1h` — One-pager externo para Bernardo.
+- [ ] **EPOS-B5-Q2-001** [P2] `2h` — EPOS Bandeira 5 Q2: qual capability EGOS prova este trimestre?
+- [ ] **EPOS-RECONCILE-B1-001** [P2] `prime` — Reconciliar numeração do bloco B1 (A81/A82 ambos B1-Q4).
+
+### 🖥️ VPS HARDENING
+
+- [ ] **VPS-FAIL2BAN-001** [P1] — fail2ban configurado SSH + Caddy.
+- [ ] **VPS-APT-AUTO-001** [P1] — apt unattended-upgrades (security patches automáticos).
+- [ ] **VPS-CVE-SCAN-001** [P1] — trivy/grype scan nas imagens Docker.
+- [ ] **VPS-CERT-RENEW-ALERT-001** [P1] — Alertas Telegram 30d antes de SSL expirar.
+- [ ] **VPS-DISK-ALERT-001** [P1] — Alerta se disco >70%.
+- [ ] **VPS-SSH-HARDENING-001** [P2] — PermitRootLogin no, PasswordAuth no, key-only.
+- [ ] **VPS-FIREWALL-AUDIT-001** [P2] — UFW rules audit.
+- [ ] **VPS-MONITORING-AGENT-001** [P2] — Prometheus node_exporter + Grafana cloud free tier.
+
+### 🌐 MCP REMOTE BRIDGE — expor MCPs adicionais
+
+> Hoje só `g-pecas` está bridgeado público. Corte Enio 2026-05-31: expor +storefront +ops +observability +governance +knowledge.
+> NÃO fazer deploy autônomo — exige janela de deploy + smoke.
+
+- [ ] **MCP-BRIDGE-001** [P1] `1h` — Bridge `mcp-storefront` (PM2 + Caddy + smoke).
+- [ ] **MCP-BRIDGE-002** [P1] `1h` — Bridge `mcp-ops` + `mcp-observability`.
+- [ ] **MCP-BRIDGE-003** [P2-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge`. Corte Enio + review Codex adversarial.
+- [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` após cada bridge.
+
+### 📊 DIFF TELEMETRY / DRIFT ACCEPTANCE (spec)
+
+- [ ] **TELEM-DIFF-001** [P1] — watcher post-commit loga diff-stats + cadence no `coordination-history.jsonl`.
+- [ ] **TELEM-DRIFT-001** [P1] — `scripts/drift-score.ts` composto normalizado 0-100 → blackboard.
+- [ ] **TELEM-SCOREBOARD-001** [P2] — expor drift score no /status + blackboard.
+- [ ] **TELEM-AGENTS-001** [P2] — protocolo agente: lê blackboard no /start, loga diff no /end.
+
+### 🤖 AGENTE EGOS PÚBLICO + BYOK (spec)
+
+> @EGOSin_bot LIVE só auth-locked p/ Enio. OpenRouter integrado. BYOK JÁ EXISTE em egos-inteligencia + 852.
+> MVP=adaptar, não criar. Liga IHV-DISS-002.
+
+### 🔗 INTELINK DEMO PÚBLICA AGENTIC
+
+> Missão: build NOVO isolado (intelink.egos.ia.br) — dados 100% SINTÉTICOS (IDs SYN-*). TRAVA GUARDIÃO: nunca dado real.
+
+- [ ] **BLOCKCHAIN-PROV-001** [P2] `guardiao` — Documentar proveniência via blockchain (Sigstore-first).
+
+### 📓 NOTEBOOKLM — auto-sync framework
+
+- [ ] **NLM-FW-002** [P1] — Auto-sync OBRIGATÓRIO: doc canônico atualizado → post-push Hermes → `source_delete`+`source_add`.
+
+### ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica [RED ZONE]
+
+- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P2] `redzone` — Exposição legal do $ETHIK live (policial ativo): PCMG Art.117 + CVM/BCB.
+- [ ] **BLOCKCHAIN-003** [P2] — Experimento $0: GitHub Action OpenTimestamps + 1 schema EAS na Base testnet.
+
+### 🔄 CROSS-WINDOW e AGENT ORG — backlog
+
+- [ ] **AGENT-TELEM-STD-001** [P2] — Padronizar telemetria de agente: todo agente loga passos em `~/.egos/agent-runs/`.
+- [ ] **AGENT-TOPOLOGY-WIRE-001** [P2] — Wire `docs/governance/AGENT_RUNTIME_TOPOLOGY.md` no `/start` Layer 1.5.
+- [ ] **READINESS-PROVE-001** [P2] — Rodar `/readiness` num caso real (G Peças ou prospect).
+
+### 🖥️ FRONTEND-SYNC — backlog P2/P3
+
+- [ ] **FE-SYNC-004** [P2] — Artigo factual no /timeline sobre o eval-runner live no ChatGPT + 79 capabilities.
+- [ ] **FE-SYNC-005** [P2] — README repo público `egos-governance`: mencionar MCPs live + Resolver + 79 caps.
+- [ ] **FE-SYNC-006** [P3] — Auto-regen do snapshot (wire `status-snapshot.ts` num cron/Hermes pós-deploy).
+
+### 🏗️ CENTRAL EGOS COMMERCIAL — backlog deprioritizado
+
+> P0→P2 2026-06-03: pivô despriorizou storefront.
+
+- [ ] **DEPLOY-SYNC-PRECOMMIT-001** [P2] `1h Sonnet` — Pre-commit detecta mudanças em `central-egos/template/src/` e exige `deploy-all-tenants.sh`.
+- [ ] **UX-HOME-AS-CATALOG-001** [P2] `3h Sonnet` — Home `/` reutiliza componentes `/catalogo`.
+- [ ] **UX-HOME-FEATURED-001** [P2] `3h Sonnet` — Home `featured=true` (limit 8).
+- [ ] **UX-HEADER-STICKY-FIX-001** [P2] `1h Sonnet` — Header `/catalogo` sticky não fixa.
+- [ ] **TASK-MP-DEMO-001** [P2] `4h Sonnet` — Banner preview `is_demo_mode=true` + página `/sobre-egos`.
+- [ ] **LLM-CAP-VALIDATE-001** [P2] `2h` — Validar cap 2M tokens/mês com dados reais G Peças.
+- [ ] **GP-MISSING-FIELDS-001** [P2] — Campos ausentes no painel admin G Peças.
+- [ ] **GP-SYNC-AUDIT-001** [P2] — Sync entre template e clients/g-pecas após storefront redesign.
+
+### 📥 EXTERNAL ARTIFACT INTAKE — backlog
+
+- [ ] **PRICING-CLARITY-001** [P2] — Doc-fix: R$100/mês é piso de recorrência, não âncora.
+- [ ] **HITL-MULTICHANNEL-001** [P3] — Wire política HITL multi-canal (Telegram+WhatsApp+email).
+- [ ] **RULE-GOV-GAP-001** [P2] `gated:HITL` `congelado` — `gem-hunter` ungoverned. Decidir: adapter+symlinks ou marcar externo.
+- [ ] **RULE-SYNC-001** [P2] — `blueprint-egos` 45d stale. Rodar `bun scripts/disseminate-propagator.ts --all`.
+- [ ] **INTAKE-WIRE-001b** [P3] — Wire RULE_SETS_INDEX no /start + monitor de lag de propagação.
+- [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start + gatilho comportamental do Prime.
+
+### 🧪 UI FUNCTIONAL TESTING
+
+- [ ] **UI-TEST-001** [P1] — Criar `docs/qa/pagemaps/egos-site.md` (mapa de rotas do egos.ia.br).
+- [ ] **UI-TEST-002** [P1] — Wire Hermes crawl via browser-automation + Playwright.
+- [ ] **UI-TEST-003** [P2] — Enforce: gate pré-commit (toca UI → exige mapa+prova).
+
+### 🎓 CURSOS ↔ FRAMEWORK ↔ GOVERNO
+
+- [/] **COURSE-MAP-001** [P1] `research` — Sonnet mapeando artefato EGOS → módulo de curso.
+- [ ] **COURSE-INTEL-001** [P1] `hermes` — Capability `course-market-scan` no Hermes/VPS: pesquisa contínua.
+- [ ] **COURSE-PROGRAM-002** [P1] `cursos-repo` — Construir MVP de conteúdo: Track 0 (M0.1–0.3) + M1.1–M1.3.
+- [ ] **COURSE-PROGRAM-003** [P1] `redzone` — Modelo de entrega + estrutura comercial. Red Zone: pricing + estatuto PCMG.
+- [ ] **COURSE-CONVERGE-001** [P1] — Convergir os 2 cursos polícia-específicos com o COURSE-PROGRAM 4-tracks.
+- [ ] **COURSE-GOV-PITCH-001** [P2] `redzone` — Proposta pro governo (polícia roda modelo próprio local/soberano).
+
+### 🔬 GEM-HUNTER + PESQUISA CONTÍNUA
+
+- [ ] **GEM-HUNTER-IMPROVE-001** [P1] `curador`+`forja` `congelado` — Melhorar gem-hunter para descoberta contínua (novos frameworks/MCPs/papers/técnicas).
+- [ ] **CODEX-ADVERSARIAL-MATERIAL-001** [P2] `provador` — Após iteração eval-loop abaixo de 7.5, enviar para revisão adversarial Codex+Antigravity.
+
+### 🤖 AGENT ORG backlog — sessão 2026-06-02
+
+- [ ] **VPS-ORCH-001** [P1] `prime` `build-window` — W1 Organizador always-on no VPS (`egos-organizer` pm2 TS).
+- [ ] **VPS-ORCH-002** [P1] `prime` `gated:VPS-ORCH-001` — W2 Workers no VPS: 2-3 papéis baratos.
+- [ ] **VPS-ORCH-003** [P1] `prime` `gated:VPS-ORCH-001` — W3 Fila de escalação `~/.egos/escalation-queue.jsonl`.
+- [ ] **VPS-ORCH-004** [P2] `prime` `gated:VPS-ORCH-002,003` — W4 Expandir workers + painel de custo.
+- [ ] **AGENT-F3-ENFORCE-001** [P2] — Enforcement DURO do gate Investigador→Guardião no runtime.
+- [ ] **AGENT-NATIVE-CONFIRM-001** [P3] — Confirmar que os 3 papéis novos viram `subagent_type` nativo.
+
+### 🔍 INTELINK (work-hours, Frente A) — backlog
+
+- [ ] **REPORT-007** [P2] — Relatório investigação DHPP (pendente) [pertence a intelink].
+- [ ] **REPORT-006** [P2] — Relatório suspeitos recorrentes (dep Neo4j estável) [pertence a intelink].
+- [ ] **REPORT-005** [P1] — Dashboard analytics Intelink.
+- [ ] **REPORT-004** [P1] — Exportar dados BISP para Neo4j (16k pessoas) completo.
+
+### 🏗️ PROCESSO DOCUMENTAL + REPORT STANDARD
+
+- [ ] **PROCESS-DOC-INVENTORY-001** [P1] `curador` — Auditar cobertura de Process Contracts.
+- [ ] **PROCESS-METAPROMPT-LOOP-001** [P1] `forja` — Wirar loop: Process Contract → gerador de metaprompts → metaprompt → eval golden.
+- [ ] **PROCESS-DOC-REFINE-ONGOING** [P2] `prime` — Toda ação recorrente nova ganha Process Contract + metaprompt.
+- [ ] **REPORT-STANDARD-ENFORCE-001** [P1] `prime`+`curador` — Wirar `@egos/report-standard` v2.0.0 como OBRIGATÓRIO.
+- [ ] **READ-ANY-READ-WHOLE-001** [P1] `curador` — Garantir intelink fractal: todo doc linka ao seu SSOT-pai + ao entry map.
+- [ ] **GEMHUNTER-STUB-ARCHIVE-001** [P2] `curador` `gated:HITL` `congelado` — Arquivar/decidir destino do stub `/home/enio/gem-hunter/`.
+- [ ] **SYSTEM-MAP-CLEANUP-001** [P2] `sentinela` `congelado` — SYSTEM_MAP.md:38/245 + SSOT.md:38 (gem-hunter-freshness).
+
+### 🔎 HERMES LOOP CLOSURE — contexto de dependências
+
+```
+DEDUP-001 → SCHEMA-001 → MIGRATE-001 → REGEX-001 → CONSUMER-001 → {TELEGRAM-001, TASKS-001}
+CONSUMER-001 → PATTERNS-001 → LIFECYCLE-001 → BLOCK-001 → DASHBOARD-001
+PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-001
+```
+
+### 📡 TOKEN/MODELO/ROTEAMENTO — backlog
+
+- [ ] **TOKEN-DELEGATE-HAIKU-001** [P2] `prime` — Rotear fan-out mecânico p/ Haiku/Sonnet via OpenRouter.
+
+### 💸 WHATSAPP READ / VPS HANDOFFS — backlog
+
+- [ ] **BIZ-OFFER-INHOUSE-001** [P1] `redzone` — Executar in-house o que o Vitor venderia (ENTITY-FIRST, EGOS-entidade). Draft → corte Enio.
+- [ ] **BIZ-VITOR-FOLLOWUP-001** [P2] `voz` — Enviar resposta ao Vitor (rascunho v2 aprovado). HITL: Enio envia.
+- [ ] **BERNARDO-PW-001** [P2] `prime` — Setar `BERNARDO_PASSWORD_SHA256` em prod.
+
+### 🔱 HERMES DESKTOP, AVATARES & CRIPTOGRAFIA
+
+- [ ] **HERMES-DESKTOP-002** [P1] `pixel` — Implementar UI React dos 5 painéis estendidos no Hermes Desktop.
+- [ ] **HERMES-DESKTOP-SANDBOX-001** [P2] `5min` — Corrigir sandbox Electron para lançar app nativo.
+- [ ] **AGENT-AVATARS-001** [P2] `pixel` — Criar componente React para avatares etéreos SVG a partir das chaves públicas.
+- [ ] **AUDIT-CRYPT-001** [P1] `prime` — Implementar helper de geração de par de chaves e assinatura off-chain secp256k1.
+- [ ] **AUDIT-NOSTR-001** [P2] `prime` — Publicação descentralizada de identidades no Nostr (NIP-05) + Bitcoin via OpenTimestamps.
+
+### 📊 CHATBOT QUALITY — governance pendente + Wave 0 backlog
+
+- [ ] **GOV-HERMES-CODEX-001** [P1] `30min` — Codex review HERMES_DECISION.md (Opção C+ híbrido; 20 plugins).
+- [ ] **GOV-STUBS-CODEX-001** [P1] `30min` — Codex review 5 perguntas stubs.
+- [ ] **GOV-GTM-V3-001** [P1] `1h` — GTM_SSOT v2.0 declara "SaaS GTM descontinuado" — update v3.0 OU archive+tombstone.
+- [ ] **CBQ-OBS-006** [P1] `4h Sonnet` — Dashboard `/admin/observability/evals`.
+- [ ] **CBQ-OBS-007** [P1] `2h Sonnet` — CI gate: pre-commit roda eval-runner contra 6 golden cases G Peças.
+- [ ] **CBQ-OBS-FOUNDATION-001** [P2] — Migrations Wave 0 (CBQ-OBS-001..003).
+
+### 🎯 SPRINT ATIVO — pendências não-urgentes
+
+- [ ] **PHASE-2-HOOKS-001** [P1] — Hooks dormentes: reativar | arquivar | deletar.
+- [ ] **PHASE-2-START-SLIM-001** [P1] — Enxugar `/start`: -21KB (CLAUDE.md dup) + SELF_MAPPING_INTERVIEW lazy + ADRs hash.
+- [ ] **PHASE-2-TASKS-READER-001** [P1] — Layer 4.5 inclui `grep "^- \[ \].*\[P0\]" TASKS.md` no `/start`.
+- [ ] **PHASE-2-PREMORTEM-SKILL-001** [P1] — Criar skill `/premortem` + trigger em skill-auto-match.
+- [ ] **PHASE-2-SKILL-TRACKER-CRON-001** [P1] — Crontab 06:00 BRT `skill-usage-tracker.ts --days=30`.
+- [ ] **PHASE-2-SKILL-AUDIT-001** [P2] — 14 skills sem invocação em 14d.
+- [ ] **PHASE-2-SOUL-IDENTITY-001** [P2] — `soul/IDENTITY.md` não lido pelo /start.
+- [ ] **PHASE-2-DOTEGOS-SYNC-001** [P2] — `~/.egos/.claude/CLAUDE.md` estagnado.
+- [ ] **PHASE-2-GLOBAL-CLAUDE-SLIM-001** [P2] — Global CLAUDE.md 327L → ≤180L.
+
+### ⏸️ PAUSADO — aguardando decisão ou desbloqueio externo
+
+- [ ] **CHAT-LGPD-001** — Aviso LGPD no chat (aguarda advogado).
+- [ ] **WAHA-CONNECT-001** — WA reconectar via WAHA (número em repouso desde 2026-05-14).
+- [ ] **FACE-000** — Reconhecimento facial (aguarda licença).
+- [ ] **INTELINK-DEPLOY-001** — Deploy VPS intelink (aguarda billing Supabase).
+
+### 🔴 BLOQUEADORES EXTERNOS
+
+- ALLM-EGOS-049 Mirror S3 WORM (dep provedor)
+- ALLM-EGOS-050 SCC OpenAI + RIPD LGPD (dep advogado)
+- CET-CONTRATO-001 (dep Enio: advogado OR template)
+- ALLM-EGOS-013 decisão KB local vs kb.gpecas.egos.ia.br
+- ALLM-EGOS-046 Caddy mTLS / Cloudflare Access
+- ALLM-EGOS-049 Mirror S3 WORM
+- 29 imagens ChatGPT FVP pendentes
+- Decisão home_sort_strategy FVP
+
+### 🏛️ VALUATION & ECV
+
+- [ ] **VAL-004** [P1] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK.
+- [ ] **VAL-005** [P2] `redzone` — Enio roda meta-prompt de review Codex para estressar metodologia ECV.
+
+### 🧑‍💻 AGENT & CHATBOT GUARDRAILS — backlog
+
+- [ ] **GUARD-STD-001** [P1] `redzone` — Enio roda os 6 meta-prompts em LLMs externos.
+- [ ] **GUARD-STD-006** [P1] `redzone` `gated:003` — L3 action guards: auth/token nos MCP endpoints + scope matrix.
+- [ ] **GUARD-STD-008** [P2] `prime` `gated:007` — Disseminar standard para todos repos leaf.
+
+### 🎯 SPRINT GOW — follow-ups não-urgentes
+
+- [ ] **GOW-METAPROMPT-EVAL-FIX-001** [P2] `voz` — 4 golden cases falhando (MP-PRICE-001-005, MP-MATERIAL-EVAL-001).
+- [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — Remover todo price-talk dos ~10 arquivos públicos.
+
+### 📝 ARTIGOS / TIMELINE — melhorar módulo
+
+- [/] **ARTICLE-RULES-001** [P1] — Melhorar regras de geração de artigo (VOICE+TEMPLATE).
+- [/] **ARTICLE-002** [P1] `redzone` — Escrever artigo #2 no tom investigador-arquiteto.
+
+### 🎯 KYTE BENCHMARK — backlog
+
+- [ ] **KYTE-PRESENT-001** [P1] `redzone` — Material p/ mostrar ao contato IA-first. Red Zone: copy/posicionamento.
+
+### 📥 HANDOFF GUARANI — backlog
+
+- [ ] **HANDOFF-SCIHUB-001** [P2] `redzone` — Corte do Enio: Sci-Hub scraper entra no repo?
+- [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration.
+
+### 🔱 HERMES OPS — backlog
+
+- [ ] **W4-T4** [P1] `3h` — VPS env hardening: INV-STAB-006/009/010.
+
+### 🌐 POSICIONAMENTO PÚBLICO & FRONTEND — backlog
+
+- [ ] **FE-BE-SYNC-GATE-001** [P1] `forja` — Implementar o gate que mede razão frontend/backend.
+- [ ] **TOOLS-PAGE-COMPLETE-001** [P1] — `egos.ia.br/tools` completa: todas tools + metaprompts inline.
+- [ ] **GITHUB-AUDIT-FULL-001** [P2] — Timeline dos 40 repos GitHub (22 não-clonados localmente).
+- [ ] **PUBLIC-REPO-DOCS-001** [P2] `curador` `redzone` — Publicar docs do EGOS Framework em repo PÚBLICO.
+- [ ] **PROVENANCE-UNIFY-002** [P3] — Avaliar unificar sistemas de proveniência fragmentados.
+
+### 📜 ITEM-INTAKE — backlog P2/P3
+
+- [ ] **ITEM-INTAKE-PHOTOS-001** [P1] `forja` — Preencher FOTO por produto automaticamente (LLM gera query → Unsplash/Pexels).
+- [ ] **ITEM-INTAKE-WEB-RETRY-001** [P2] `forja` — Adicionar retry de fetch (network-level, backoff).
+- [ ] **ITEM-INTAKE-VERIFIER-SEMANTIC-001** [P2] — Verificador checar PLAUSIBILIDADE semântica.
+- [ ] **ITEM-INTAKE-SIZE-VARIATION-001** [P2] — Preservar Médio/Grande como VARIAÇÃO.
+- [ ] **ITEM-INTAKE-MANUSCRITO-001** [P2] — Testar robustez com cardápio MANUSCRITO.
+- [ ] **ITEM-INTAKE-KYTE-MAP-001** [P2] — Alinhar com time Kyte (Diesom): "adicional" vira produto ou modificador?
+- [ ] **ITEM-INTAKE-WEB-HARDEN-001** [P2] `gated:decisão` — Hardening da interface web (auth + fila + deploy).
+- [ ] **ITEM-INTAKE-KYTE-API-001** [P3] `gated:ITEM-INTAKE-KYTE-MAP-001` — Integração DIRETA com o Kyte.
+- [ ] **ITEM-INTAKE-DEDUP-001** [P3] — Dedup contra catálogo existente ao importar.
+- [ ] **ITEM-INTAKE-VAR-PRICING-001** [P3] — Preço POR variação.
+- [ ] **ITEM-INTAKE-3WAY-001** [P3] — 3ª leitura/voto de desempate quando 1ª e 2ª divergem.
+- [ ] **ITEM-INTAKE-GENERIC-001** [P2] `strategy` — Generalizar p/ QUALQUER pequeno negócio.
+- [ ] **ITEM-INTAKE-PUBLIC-REPO-001** [P3] `gated:TOOLS-HUB-001` — Extrair `packages/item-intake/` como módulo standalone.
+- [ ] **NLM-ITEM-INTAKE-001** [P3] — Criar notebook NotebookLM do item-intake.
+- [ ] **ITEM-INTAKE-SYSTEMMAP-001** [P3] — Referenciar `packages/item-intake/` no SYSTEM_MAP.
+
+### 🔬 INTELINK DEMO PÚBLICA — backlog WS4+WS5
+
+- [ ] **INTELINK-PLATFORM-GH-CACHE-001** [P1] `prime`+`hermes-ops` — GitHub pode reter `f0cfdb7` (18 PII). Contatar GitHub Support.
+- [ ] **DISCOVER-GATE-004** [P2] `sentinela` — Auto-consulta periódica (cron + Layer `/start` reportando drift).
+
+### 🤖 HERMES AUTO-TASKS — backlog
+
+- [ ] **SEC-FOLLOWUP-001** [P1] — Considerar `git filter-repo` para limpar histórico dos commits `19e1e1a` e `05b3603`.
+
+
+### IDs adicionais — completando zero-loss (2026-06-10)
+
+> Itens abaixo estavam em seções removidas do TASKS.md mas não foram capturados na primeira passagem.
+
+- [/] **CTX-BOUNDARY-001** [P0] — Mapa de contexto: IA-window / off-chain registry / proof layer / public layer. O que vai onde + tamanho. (workflow RADICAL TRANSPARENCY)
+- [/] **FE-SYNC-001** [P0] `prime` — ACHADO RAIZ: `/opt/egos-site/src/server.ts` em produção ~1931 linhas ATRÁS do repo. Release controlado do egos-site pendente (pipeline de deploy real, não rebuild trivial). NÃO fazer blind.
+- [/] **FE-SYNC-002** [P1] — Render do bloco `framework` no /status: código commitado, dado LIVE no /status.json. Falta renderizar no HTML → entra no release FE-SYNC-001.
+- [ ] **GOV-BOUNDARY-APP-PATHS-001** [P1] `1h Sonnet` — Extender pre-commit para BLOCK writes em `central-egos/clients/<slug>/src/app/`.
+- [ ] **LLM-METER-001** [P1] `4h Sonnet` — `usage_metrics` por tenant (tokens, model, alerta 80%/100% cap).
+- [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado.
+- [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo.
+- [/] **NLM-HERMES-002** [P1] `2h Sonnet` — Detector credential-free `scripts/notebook-sync-detect.ts` + `docs/notebooklm/sync-map.json`. Testado local. Pendente: deploy na VPS (requer go-ahead Enio).
+- [/] **PROOF-ARCH-001** [P0] — Pesquisa Bitcoin/OTS, EAS/Base, BTC L2s + não-blockchain (Sigstore/Rekor/SLSA/OTel). (workflow RADICAL TRANSPARENCY)
+- [/] **RT-INVENTORY-001** [P0] — Inventário do que EGOS já tem (transparência radical/Ethik/observabilidade/telemetria). (workflow RADICAL TRANSPARENCY)
+- [ ] **SOLUCOES-EMPRESARIAIS-001** [P1] `3h Sonnet` — Página `/solucoes-empresariais` (ERPs, R$12k+). Link rodapé discreto.
+- [ ] **SSOT-SYNC-WATCHDOG-001** [P1] `2h` — Hermes job semanal compara `pm2 describe created_at` de todos tenants. Diff >48h = alerta Telegram.
+- [ ] **SYSTEM-HEALTH-IMPL-001** [P1] `2h Sonnet` — `/admin/system-health` stub → implementar (PM2, último deploy, drift detector, SSL, disk).
+- [ ] **TASK-VPS-WATCHER-UPDATE-001** [P1] `30min` — Watcher chama `/api/health?tenant=g-pecas` a cada 5min.
+- [ ] **UX-ADMIN-FEATURED-001** [P1] `2h Sonnet` — Toggle "Destaque" no admin + `featured_until` + bulk "marcar promoção".
+- [ ] **UX-PROMO-VISUAL-001** [P1] `2h Sonnet` — ProductCard badge "PROMOÇÃO" + preço riscado + filtro sidebar.
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
diff --git a/scripts/mycelium-query.ts b/scripts/mycelium-query.ts
new file mode 100644
index 00000000..c1fb112c
--- /dev/null
+++ b/scripts/mycelium-query.ts
@@ -0,0 +1,474 @@
+#!/usr/bin/env bun
+/**
+ * mycelium-query.ts — N-grau BFS sobre o snapshot do grafo Mycelium.
+ *
+ * Usos:
+ *   bun scripts/mycelium-query.ts <id-ou-label> [--depth N]
+ *   bun scripts/mycelium-query.ts --paths <a> <b>
+ *   bun scripts/mycelium-query.ts <id-ou-label> --depth N --json
+ *
+ * Flags:
+ *   --depth N      Profundidade BFS (default 2, max sem limite)
+ *   --paths <a> <b> Caminhos mais curtos entre dois nós (até 5)
+ *   --json         Output machine-readable (AI⟷AI)
+ *   --snapshot <f> Caminho para o snapshot (default ~/.egos/mycelium-snapshot.json)
+ *
+ * Busca fuzzy: se o id exato não existe, busca por substring case-insensitive
+ * no id ou no label. Se ambíguo, lista candidatos.
+ *
+ * Design: zero dependências externas. Lê o snapshot gerado por mycelium-snapshot.ts.
+ */
+
+import { readFileSync, existsSync } from "node:fs";
+import { resolve } from "node:path";
+import { homedir } from "node:os";
+
+// ── Types (espelha packages/shared/src/mycelium/reference-graph.ts) ──────────
+
+interface ReferenceNode {
+  id: string;
+  type: string;
+  label: string;
+  status: string;
+  evidence: string[];
+  sourcePath?: string;
+  note?: string;
+  tags?: string[];
+}
+
+interface ReferenceEdge {
+  from: string;
+  relation: string;
+  to: string;
+  evidence: string[];
+  note?: string;
+}
+
+interface ReferenceGraph {
+  version: string;
+  generated: string;
+  nodes: ReferenceNode[];
+  edges: ReferenceEdge[];
+}
+
+// ── Adjacency ─────────────────────────────────────────────────────────────────
+
+function buildAdj(
+  edges: ReferenceEdge[],
+): Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>> {
+  const adj = new Map<
+    string,
+    Array<{ neighbor: string; relation: string; dir: "out" | "in" }>
+  >();
+  const add = (
+    from: string,
+    to: string,
+    relation: string,
+    dir: "out" | "in",
+  ) => {
+    if (!adj.has(from)) adj.set(from, []);
+    adj.get(from)!.push({ neighbor: to, relation, dir });
+  };
+  for (const e of edges) {
+    add(e.from, e.to, e.relation, "out");
+    add(e.to, e.from, e.relation, "in");
+  }
+  return adj;
+}
+
+// ── Fuzzy node lookup ─────────────────────────────────────────────────────────
+
+function findNodes(
+  nodes: ReferenceNode[],
+  query: string,
+): ReferenceNode[] {
+  const exact = nodes.find(
+    (n) => n.id === query || n.label.toLowerCase() === query.toLowerCase(),
+  );
+  if (exact) return [exact];
+
+  const q = query.toLowerCase();
+  return nodes.filter(
+    (n) =>
+      n.id.toLowerCase().includes(q) ||
+      n.label.toLowerCase().includes(q),
+  );
+}
+
+// ── BFS N-grau ────────────────────────────────────────────────────────────────
+
+interface BfsStep {
+  nodeId: string;
+  depth: number;
+  via: string | null; // source node id
+  relation: string | null;
+  dir: "out" | "in" | null;
+  path: string[]; // node ids from root to this node
+}
+
+function bfsNeighborhood(
+  rootId: string,
+  maxDepth: number,
+  adj: Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>>,
+): BfsStep[] {
+  const visited = new Set<string>([rootId]);
+  const queue: BfsStep[] = [
+    { nodeId: rootId, depth: 0, via: null, relation: null, dir: null, path: [rootId] },
+  ];
+  const result: BfsStep[] = [];
+
+  while (queue.length > 0) {
+    const current = queue.shift()!;
+    if (current.depth > 0) result.push(current);
+    if (current.depth >= maxDepth) continue;
+
+    const neighbors = adj.get(current.nodeId) ?? [];
+    for (const { neighbor, relation, dir } of neighbors) {
+      if (visited.has(neighbor)) continue;
+      visited.add(neighbor);
+      queue.push({
+        nodeId: neighbor,
+        depth: current.depth + 1,
+        via: current.nodeId,
+        relation,
+        dir,
+        path: [...current.path, neighbor],
+      });
+    }
+  }
+
+  return result;
+}
+
+// ── Shortest paths (BFS, up to maxPaths) ─────────────────────────────────────
+
+function shortestPaths(
+  fromId: string,
+  toId: string,
+  adj: Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>>,
+  maxPaths = 5,
+): string[][] {
+  // BFS que preserva múltiplos caminhos de mesmo comprimento
+  const found: string[][] = [];
+  let shortestLen: number | null = null;
+
+  const queue: Array<{ path: string[]; visited: Set<string> }> = [
+    { path: [fromId], visited: new Set([fromId]) },
+  ];
+
+  while (queue.length > 0) {
+    const { path, visited } = queue.shift()!;
+    const last = path[path.length - 1];
+
+    if (shortestLen !== null && path.length > shortestLen) break;
+
+    const neighbors = adj.get(last) ?? [];
+    for (const { neighbor } of neighbors) {
+      if (visited.has(neighbor)) continue;
+      const newPath = [...path, neighbor];
+      if (neighbor === toId) {
+        found.push(newPath);
+        shortestLen = newPath.length;
+        if (found.length >= maxPaths) return found;
+        continue;
+      }
+      queue.push({ path: newPath, visited: new Set([...visited, neighbor]) });
+    }
+  }
+
+  return found;
+}
+
+// ── Rendering helpers ─────────────────────────────────────────────────────────
+
+const STATUS_ICON: Record<string, string> = {
+  active: "[+]",
+  degraded: "[~]",
+  offline: "[-]",
+  planned: "[?]",
+};
+
+function nodeLabel(n: ReferenceNode): string {
+  const icon = STATUS_ICON[n.status] ?? "[?]";
+  return `${icon} ${n.label}  (${n.id})  [${n.type}]`;
+}
+
+function printBfs(
+  root: ReferenceNode,
+  steps: BfsStep[],
+  nodeMap: Map<string, ReferenceNode>,
+): void {
+  console.log(`\nNeighborhood of: ${nodeLabel(root)}`);
+  console.log("─".repeat(72));
+
+  const byDepth = new Map<number, BfsStep[]>();
+  for (const s of steps) {
+    if (!byDepth.has(s.depth)) byDepth.set(s.depth, []);
+    byDepth.get(s.depth)!.push(s);
+  }
+
+  const sortedDepths = Array.from(byDepth.keys()).sort((a, b) => a - b);
+  for (const depth of sortedDepths) {
+    console.log(`\n  Grau ${depth}:`);
+    for (const s of byDepth.get(depth)!) {
+      const n = nodeMap.get(s.nodeId);
+      const label = n ? nodeLabel(n) : `[?] ${s.nodeId}`;
+      const via = nodeMap.get(s.via!)?.label ?? s.via;
+      const arrow = s.dir === "out" ? "--[${s.relation}]-->" : "<--[${s.relation}]--";
+      // Manual interpolation since we need literal brackets
+      const arrowStr =
+        s.dir === "out"
+          ? `  --[${s.relation}]-->`
+          : `  <--[${s.relation}]--`;
+      console.log(`    ${label}`);
+      console.log(`      via ${via}${arrowStr}`);
+      console.log(`      path: ${s.path.join(" > ")}`);
+    }
+  }
+
+  console.log(
+    `\nTotal: ${steps.length} nós alcançados (${sortedDepths.length} graus)\n`,
+  );
+}
+
+function printPaths(
+  paths: string[][],
+  nodeMap: Map<string, ReferenceNode>,
+  fromId: string,
+  toId: string,
+): void {
+  const fromLabel = nodeMap.get(fromId)?.label ?? fromId;
+  const toLabel = nodeMap.get(toId)?.label ?? toId;
+  console.log(`\nCaminhos de "${fromLabel}" até "${toLabel}":`);
+  console.log("─".repeat(72));
+
+  if (paths.length === 0) {
+    console.log("  Nenhum caminho encontrado.");
+    return;
+  }
+
+  paths.forEach((path, i) => {
+    const pretty = path
+      .map((id) => {
+        const n = nodeMap.get(id);
+        return n ? `${n.label} (${id})` : id;
+      })
+      .join(" > ");
+    console.log(`  [${i + 1}] ${pretty}  (${path.length - 1} saltos)`);
+  });
+  console.log();
+}
+
+// ── Main ──────────────────────────────────────────────────────────────────────
+
+function main() {
+  const args = process.argv.slice(2);
+  if (args.length === 0 || args.includes("--help") || args.includes("-h")) {
+    console.log(`
+mycelium-query.ts — consulta N-grau no grafo Mycelium
+
+Uso:
+  bun scripts/mycelium-query.ts <node>           # BFS grau 2
+  bun scripts/mycelium-query.ts <node> --depth 4
+  bun scripts/mycelium-query.ts --paths <a> <b>
+  bun scripts/mycelium-query.ts <node> --json    # output AI⟷AI
+
+Flags:
+  --depth N          profundidade BFS (default 2)
+  --paths <a> <b>    caminhos mais curtos entre dois nós
+  --json             output machine-readable
+  --snapshot <file>  snapshot alternativo (default ~/.egos/mycelium-snapshot.json)
+`);
+    process.exit(0);
+  }
+
+  // Parse --snapshot
+  const snapIdx = args.indexOf("--snapshot");
+  const snapPath =
+    snapIdx >= 0
+      ? resolve(args[snapIdx + 1])
+      : resolve(homedir(), ".egos/mycelium-snapshot.json");
+
+  if (!existsSync(snapPath)) {
+    console.error(`[ERROR] Snapshot não encontrado: ${snapPath}`);
+    console.error(
+      "  Gere com: bun scripts/mycelium-snapshot.ts --exec",
+    );
+    process.exit(1);
+  }
+
+  const graph: ReferenceGraph = JSON.parse(readFileSync(snapPath, "utf8"));
+  const nodeMap = new Map<string, ReferenceNode>(
+    graph.nodes.map((n) => [n.id, n]),
+  );
+  const adj = buildAdj(graph.edges);
+
+  const isJson = args.includes("--json");
+  const isPaths = args.includes("--paths");
+
+  // ── Mode: --paths <a> <b>
+  if (isPaths) {
+    const pathsIdx = args.indexOf("--paths");
+    const aQuery = args[pathsIdx + 1];
+    const bQuery = args[pathsIdx + 2];
+
+    if (!aQuery || !bQuery) {
+      console.error("[ERROR] --paths requer dois nós: --paths <a> <b>");
+      process.exit(1);
+    }
+
+    const aNodes = findNodes(graph.nodes, aQuery);
+    const bNodes = findNodes(graph.nodes, bQuery);
+
+    if (aNodes.length === 0) {
+      console.error(`[ERROR] Nó não encontrado: "${aQuery}"`);
+      process.exit(1);
+    }
+    if (bNodes.length === 0) {
+      console.error(`[ERROR] Nó não encontrado: "${bQuery}"`);
+      process.exit(1);
+    }
+    if (aNodes.length > 1) {
+      console.error(
+        `[AMBIGUOUS] "${aQuery}" corresponde a ${aNodes.length} nós:`,
+      );
+      aNodes.forEach((n) => console.error(`  ${n.id} — ${n.label}`));
+      process.exit(1);
+    }
+    if (bNodes.length > 1) {
+      console.error(
+        `[AMBIGUOUS] "${bQuery}" corresponde a ${bNodes.length} nós:`,
+      );
+      bNodes.forEach((n) => console.error(`  ${n.id} — ${n.label}`));
+      process.exit(1);
+    }
+
+    const fromId = aNodes[0].id;
+    const toId = bNodes[0].id;
+    const paths = shortestPaths(fromId, toId, adj);
+
+    if (isJson) {
+      process.stdout.write(
+        JSON.stringify(
+          {
+            from: fromId,
+            to: toId,
+            paths_found: paths.length,
+            paths: paths.map((p, i) => ({
+              index: i + 1,
+              hops: p.length - 1,
+              nodes: p.map((id) => ({
+                id,
+                label: nodeMap.get(id)?.label ?? id,
+                type: nodeMap.get(id)?.type ?? "unknown",
+                status: nodeMap.get(id)?.status ?? "unknown",
+              })),
+            })),
+          },
+          null,
+          2,
+        ) + "\n",
+      );
+    } else {
+      printPaths(paths, nodeMap, fromId, toId);
+    }
+    return;
+  }
+
+  // ── Mode: BFS neighborhood
+  // Build set of flag-value args to exclude (only when the flag exists)
+  const flagValues = new Set<string>();
+  const valuedFlags = ["--depth", "--snapshot"];
+  for (const flag of valuedFlags) {
+    const idx = args.indexOf(flag);
+    if (idx >= 0 && idx + 1 < args.length) {
+      flagValues.add(args[idx + 1]);
+    }
+  }
+  const nonFlagArgs = args.filter(
+    (a) => !a.startsWith("--") && !flagValues.has(a),
+  );
+
+  const query = nonFlagArgs[0];
+  if (!query) {
+    console.error("[ERROR] Informe um nó para consultar.");
+    process.exit(1);
+  }
+
+  const depthIdx = args.indexOf("--depth");
+  const depth = depthIdx >= 0 ? parseInt(args[depthIdx + 1], 10) : 2;
+
+  if (isNaN(depth) || depth < 1) {
+    console.error("[ERROR] --depth deve ser um inteiro >= 1");
+    process.exit(1);
+  }
+
+  const candidates = findNodes(graph.nodes, query);
+
+  if (candidates.length === 0) {
+    console.error(`[NOT FOUND] Nenhum nó corresponde a "${query}"`);
+    console.error("  Nós disponíveis (amostra):");
+    graph.nodes.slice(0, 20).forEach((n) =>
+      console.error(`    ${n.id} — ${n.label}`),
+    );
+    process.exit(1);
+  }
+
+  if (candidates.length > 1) {
+    console.error(
+      `[AMBIGUOUS] "${query}" corresponde a ${candidates.length} nós:`,
+    );
+    candidates.forEach((n) =>
+      console.error(`  ${n.id} — ${n.label}  [${n.type}]`),
+    );
+    process.exit(1);
+  }
+
+  const root = candidates[0];
+  const steps = bfsNeighborhood(root.id, depth, adj);
+
+  if (isJson) {
+    process.stdout.write(
+      JSON.stringify(
+        {
+          root: {
+            id: root.id,
+            label: root.label,
+            type: root.type,
+            status: root.status,
+          },
+          depth_requested: depth,
+          snapshot_generated: graph.generated,
+          total_nodes_reached: steps.length,
+          by_depth: Object.fromEntries(
+            Array.from(
+              steps.reduce((m, s) => {
+                if (!m.has(s.depth)) m.set(s.depth, []);
+                m.get(s.depth)!.push({
+                  id: s.nodeId,
+                  label: nodeMap.get(s.nodeId)?.label ?? s.nodeId,
+                  type: nodeMap.get(s.nodeId)?.type ?? "unknown",
+                  status: nodeMap.get(s.nodeId)?.status ?? "unknown",
+                  via: s.via,
+                  relation: s.relation,
+                  dir: s.dir,
+                  path: s.path,
+                });
+                return m;
+              }, new Map<number, unknown[]>()),
+            ).map(([k, v]) => [String(k), v]),
+          ),
+        },
+        null,
+        2,
+      ) + "\n",
+    );
+  } else {
+    console.log(
+      `\nMycelium Query — snapshot: ${graph.generated} | nós: ${graph.nodes.length} | arestas: ${graph.edges.length}`,
+    );
+    printBfs(root, steps, nodeMap);
+  }
+}
+
+main();

exec
/bin/bash -lc "nl -ba scripts/mycelium-query.ts | sed -n '1,240p'; echo '---'; nl -ba scripts/egos-home/sync.sh | sed -n '1,90p'; echo '---'; ls -l agents/registry/leaf-repos.json .husky/_checks/15-agent-gate.sh 2>&1 || true" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * mycelium-query.ts — N-grau BFS sobre o snapshot do grafo Mycelium.
     4	 *
     5	 * Usos:
     6	 *   bun scripts/mycelium-query.ts <id-ou-label> [--depth N]
     7	 *   bun scripts/mycelium-query.ts --paths <a> <b>
     8	 *   bun scripts/mycelium-query.ts <id-ou-label> --depth N --json
     9	 *
    10	 * Flags:
    11	 *   --depth N      Profundidade BFS (default 2, max sem limite)
    12	 *   --paths <a> <b> Caminhos mais curtos entre dois nós (até 5)
    13	 *   --json         Output machine-readable (AI⟷AI)
    14	 *   --snapshot <f> Caminho para o snapshot (default ~/.egos/mycelium-snapshot.json)
    15	 *
    16	 * Busca fuzzy: se o id exato não existe, busca por substring case-insensitive
    17	 * no id ou no label. Se ambíguo, lista candidatos.
    18	 *
    19	 * Design: zero dependências externas. Lê o snapshot gerado por mycelium-snapshot.ts.
    20	 */
    21	
    22	import { readFileSync, existsSync } from "node:fs";
    23	import { resolve } from "node:path";
    24	import { homedir } from "node:os";
    25	
    26	// ── Types (espelha packages/shared/src/mycelium/reference-graph.ts) ──────────
    27	
    28	interface ReferenceNode {
    29	  id: string;
    30	  type: string;
    31	  label: string;
    32	  status: string;
    33	  evidence: string[];
    34	  sourcePath?: string;
    35	  note?: string;
    36	  tags?: string[];
    37	}
    38	
    39	interface ReferenceEdge {
    40	  from: string;
    41	  relation: string;
    42	  to: string;
    43	  evidence: string[];
    44	  note?: string;
    45	}
    46	
    47	interface ReferenceGraph {
    48	  version: string;
    49	  generated: string;
    50	  nodes: ReferenceNode[];
    51	  edges: ReferenceEdge[];
    52	}
    53	
    54	// ── Adjacency ─────────────────────────────────────────────────────────────────
    55	
    56	function buildAdj(
    57	  edges: ReferenceEdge[],
    58	): Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>> {
    59	  const adj = new Map<
    60	    string,
    61	    Array<{ neighbor: string; relation: string; dir: "out" | "in" }>
    62	  >();
    63	  const add = (
    64	    from: string,
    65	    to: string,
    66	    relation: string,
    67	    dir: "out" | "in",
    68	  ) => {
    69	    if (!adj.has(from)) adj.set(from, []);
    70	    adj.get(from)!.push({ neighbor: to, relation, dir });
    71	  };
    72	  for (const e of edges) {
    73	    add(e.from, e.to, e.relation, "out");
    74	    add(e.to, e.from, e.relation, "in");
    75	  }
    76	  return adj;
    77	}
    78	
    79	// ── Fuzzy node lookup ─────────────────────────────────────────────────────────
    80	
    81	function findNodes(
    82	  nodes: ReferenceNode[],
    83	  query: string,
    84	): ReferenceNode[] {
    85	  const exact = nodes.find(
    86	    (n) => n.id === query || n.label.toLowerCase() === query.toLowerCase(),
    87	  );
    88	  if (exact) return [exact];
    89	
    90	  const q = query.toLowerCase();
    91	  return nodes.filter(
    92	    (n) =>
    93	      n.id.toLowerCase().includes(q) ||
    94	      n.label.toLowerCase().includes(q),
    95	  );
    96	}
    97	
    98	// ── BFS N-grau ────────────────────────────────────────────────────────────────
    99	
   100	interface BfsStep {
   101	  nodeId: string;
   102	  depth: number;
   103	  via: string | null; // source node id
   104	  relation: string | null;
   105	  dir: "out" | "in" | null;
   106	  path: string[]; // node ids from root to this node
   107	}
   108	
   109	function bfsNeighborhood(
   110	  rootId: string,
   111	  maxDepth: number,
   112	  adj: Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>>,
   113	): BfsStep[] {
   114	  const visited = new Set<string>([rootId]);
   115	  const queue: BfsStep[] = [
   116	    { nodeId: rootId, depth: 0, via: null, relation: null, dir: null, path: [rootId] },
   117	  ];
   118	  const result: BfsStep[] = [];
   119	
   120	  while (queue.length > 0) {
   121	    const current = queue.shift()!;
   122	    if (current.depth > 0) result.push(current);
   123	    if (current.depth >= maxDepth) continue;
   124	
   125	    const neighbors = adj.get(current.nodeId) ?? [];
   126	    for (const { neighbor, relation, dir } of neighbors) {
   127	      if (visited.has(neighbor)) continue;
   128	      visited.add(neighbor);
   129	      queue.push({
   130	        nodeId: neighbor,
   131	        depth: current.depth + 1,
   132	        via: current.nodeId,
   133	        relation,
   134	        dir,
   135	        path: [...current.path, neighbor],
   136	      });
   137	    }
   138	  }
   139	
   140	  return result;
   141	}
   142	
   143	// ── Shortest paths (BFS, up to maxPaths) ─────────────────────────────────────
   144	
   145	function shortestPaths(
   146	  fromId: string,
   147	  toId: string,
   148	  adj: Map<string, Array<{ neighbor: string; relation: string; dir: "out" | "in" }>>,
   149	  maxPaths = 5,
   150	): string[][] {
   151	  // BFS que preserva múltiplos caminhos de mesmo comprimento
   152	  const found: string[][] = [];
   153	  let shortestLen: number | null = null;
   154	
   155	  const queue: Array<{ path: string[]; visited: Set<string> }> = [
   156	    { path: [fromId], visited: new Set([fromId]) },
   157	  ];
   158	
   159	  while (queue.length > 0) {
   160	    const { path, visited } = queue.shift()!;
   161	    const last = path[path.length - 1];
   162	
   163	    if (shortestLen !== null && path.length > shortestLen) break;
   164	
   165	    const neighbors = adj.get(last) ?? [];
   166	    for (const { neighbor } of neighbors) {
   167	      if (visited.has(neighbor)) continue;
   168	      const newPath = [...path, neighbor];
   169	      if (neighbor === toId) {
   170	        found.push(newPath);
   171	        shortestLen = newPath.length;
   172	        if (found.length >= maxPaths) return found;
   173	        continue;
   174	      }
   175	      queue.push({ path: newPath, visited: new Set([...visited, neighbor]) });
   176	    }
   177	  }
   178	
   179	  return found;
   180	}
   181	
   182	// ── Rendering helpers ─────────────────────────────────────────────────────────
   183	
   184	const STATUS_ICON: Record<string, string> = {
   185	  active: "[+]",
   186	  degraded: "[~]",
   187	  offline: "[-]",
   188	  planned: "[?]",
   189	};
   190	
   191	function nodeLabel(n: ReferenceNode): string {
   192	  const icon = STATUS_ICON[n.status] ?? "[?]";
   193	  return `${icon} ${n.label}  (${n.id})  [${n.type}]`;
   194	}
   195	
   196	function printBfs(
   197	  root: ReferenceNode,
   198	  steps: BfsStep[],
   199	  nodeMap: Map<string, ReferenceNode>,
   200	): void {
   201	  console.log(`\nNeighborhood of: ${nodeLabel(root)}`);
   202	  console.log("─".repeat(72));
   203	
   204	  const byDepth = new Map<number, BfsStep[]>();
   205	  for (const s of steps) {
   206	    if (!byDepth.has(s.depth)) byDepth.set(s.depth, []);
   207	    byDepth.get(s.depth)!.push(s);
   208	  }
   209	
   210	  const sortedDepths = Array.from(byDepth.keys()).sort((a, b) => a - b);
   211	  for (const depth of sortedDepths) {
   212	    console.log(`\n  Grau ${depth}:`);
   213	    for (const s of byDepth.get(depth)!) {
   214	      const n = nodeMap.get(s.nodeId);
   215	      const label = n ? nodeLabel(n) : `[?] ${s.nodeId}`;
   216	      const via = nodeMap.get(s.via!)?.label ?? s.via;
   217	      const arrow = s.dir === "out" ? "--[${s.relation}]-->" : "<--[${s.relation}]--";
   218	      // Manual interpolation since we need literal brackets
   219	      const arrowStr =
   220	        s.dir === "out"
   221	          ? `  --[${s.relation}]-->`
   222	          : `  <--[${s.relation}]--`;
   223	      console.log(`    ${label}`);
   224	      console.log(`      via ${via}${arrowStr}`);
   225	      console.log(`      path: ${s.path.join(" > ")}`);
   226	    }
   227	  }
   228	
   229	  console.log(
   230	    `\nTotal: ${steps.length} nós alcançados (${sortedDepths.length} graus)\n`,
   231	  );
   232	}
   233	
   234	function printPaths(
   235	  paths: string[][],
   236	  nodeMap: Map<string, ReferenceNode>,
   237	  fromId: string,
   238	  toId: string,
   239	): void {
   240	  const fromLabel = nodeMap.get(fromId)?.label ?? fromId;
---
     1	#!/bin/bash
     2	# ═══════════════════════════════════════════════════════════
     3	# 🔄 EGOS Sync v2.1 — Shared Governance + Workflows + Skills + Claude Commands (EPOS-SYNC-001)
     4	# 
     5	# Creates symlinks for governance, workflows, and skills
     6	# in ALL registered repos. Works with Windsurf, `.agent`, and shared IDE surfaces.
     7	#
     8	# Usage: ~/.egos/sync.sh
     9	# ═══════════════════════════════════════════════════════════
    10	
    11	set -e
    12	
    13	EGOS_HOME="$HOME/.egos"
    14	SYNC_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
    15	GREEN='\033[0;32m'
    16	YELLOW='\033[1;33m'
    17	RED='\033[0;31m'
    18	BLUE='\033[0;34m'
    19	NC='\033[0m'
    20	
    21	echo "🔄 EGOS Sync v2.1 — Governance + Workflows + Skills + Claude Commands"
    22	echo "═══════════════════════════════════════════════════════════"
    23	echo ""
    24	
    25	# ── Registered repos ──
    26	# Standard code repos that consume shared governance directly.
    27	# Intentionally excluded:
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
    43	fi
    44	
    45	# ── Step 1: Validate central governance ──
    46	echo "📋 Step 1: Validating central governance..."
    47	REQUIRED=(
    48	  "guarani/IDENTITY.md"
    49	  "guarani/PREFERENCES.md"
    50	  "guarani/RULES_INDEX.md"
    51	  "README.md"
    52	)
    53	for file in "${REQUIRED[@]}"; do
    54	  if [ -f "$EGOS_HOME/$file" ]; then
    55	    echo -e "   ${GREEN}✅${NC} $file"
    56	  else
    57	    echo -e "   ${RED}❌${NC} MISSING: $file"
    58	    exit 1
    59	  fi
    60	done
    61	
    62	# Count workflows and skills
    63	WF_COUNT=$(ls "$EGOS_HOME/workflows/"*.md 2>/dev/null | wc -l)
    64	SKILL_COUNT=$(find "$EGOS_HOME/skills" -name "SKILL.md" 2>/dev/null | wc -l)
    65	echo -e "   ${GREEN}✅${NC} $WF_COUNT workflows available"
    66	echo -e "   ${GREEN}✅${NC} $SKILL_COUNT skills available"
    67	
    68	# ── Step 1.5: Validate Global IDE Symlinks ──
    69	echo ""
    70	echo "📋 Step 1.5: Validating Global IDE Symlinks (Antigravity/Cline)..."
    71	CLINE_DIR="$HOME/Documents/Cline"
    72	if [ -d "$CLINE_DIR" ]; then
    73	  # Workflows
    74	  if [ -L "$CLINE_DIR/Workflows" ]; then
    75	    echo -e "   ${GREEN}✅${NC} Cline Workflows symlink OK"
    76	  else
    77	    rm -rf "$CLINE_DIR/Workflows"
    78	    ln -sf "$EGOS_HOME/workflows" "$CLINE_DIR/Workflows"
    79	    echo -e "   ${GREEN}🔗${NC} Cline Workflows symlink fixed"
    80	  fi
    81	  # Rules
    82	  if [ -L "$CLINE_DIR/Rules" ]; then
    83	    echo -e "   ${GREEN}✅${NC} Cline Rules symlink OK"
    84	  else
    85	    rm -rf "$CLINE_DIR/Rules"
    86	    ln -sf "$EGOS_HOME/guarani/standards/ide-rules" "$CLINE_DIR/Rules"
    87	    echo -e "   ${GREEN}🔗${NC} Cline Rules symlink fixed"
    88	  fi
    89	
    90	  # Hooks
---
-rwxrwxr-x 1 enio enio 6982 Jun 10 07:51 .husky/_checks/15-agent-gate.sh
-rw-rw-r-- 1 enio enio 2788 Jun 10 08:31 agents/registry/leaf-repos.json

exec
/bin/bash -lc 'bash -n scripts/egos-home/sync.sh; echo bash-n:$?; bash -lc '"'unset REPOS; echo "'${#REPOS[@]:-0}'"' 2>&1 || true; bun --version >/dev/null 2>&1 && bun run scripts/mycelium-query.ts --help >/tmp/mq.out && head -5 /tmp/mq.out; echo mq:"'$?' in /home/enio/egos
 succeeded in 111ms:

mycelium-query.ts — consulta N-grau no grafo Mycelium

Uso:
  bun scripts/mycelium-query.ts <node>           # BFS grau 2
mq:0

exec
/bin/bash -lc "bash -lc 'REPOS=(a b); echo "'${#REPOS[@]:-0}'"' 2>&1 || true; jq -r '.leaf_repos[] | select(.alias_of == null or .alias_of == \"\") | .path' agents/registry/leaf-repos.json | head" in /home/enio/egos
 succeeded in 0ms:
bash: line 1: ${#REPOS[@]:-0}: bad substitution
/home/enio/852
/home/enio/br-acc
/home/enio/carteira-livre
/home/enio/intelink
/home/enio/egos-lab
/home/enio/forja
/home/enio/smartbuscas
/home/enio/santiago
/home/enio/commons
/home/enio/arch

exec
/bin/bash -lc "nl -ba scripts/mycelium-query.ts | sed -n '240,520p'" in /home/enio/egos
 succeeded in 0ms:
   240	  const fromLabel = nodeMap.get(fromId)?.label ?? fromId;
   241	  const toLabel = nodeMap.get(toId)?.label ?? toId;
   242	  console.log(`\nCaminhos de "${fromLabel}" até "${toLabel}":`);
   243	  console.log("─".repeat(72));
   244	
   245	  if (paths.length === 0) {
   246	    console.log("  Nenhum caminho encontrado.");
   247	    return;
   248	  }
   249	
   250	  paths.forEach((path, i) => {
   251	    const pretty = path
   252	      .map((id) => {
   253	        const n = nodeMap.get(id);
   254	        return n ? `${n.label} (${id})` : id;
   255	      })
   256	      .join(" > ");
   257	    console.log(`  [${i + 1}] ${pretty}  (${path.length - 1} saltos)`);
   258	  });
   259	  console.log();
   260	}
   261	
   262	// ── Main ──────────────────────────────────────────────────────────────────────
   263	
   264	function main() {
   265	  const args = process.argv.slice(2);
   266	  if (args.length === 0 || args.includes("--help") || args.includes("-h")) {
   267	    console.log(`
   268	mycelium-query.ts — consulta N-grau no grafo Mycelium
   269	
   270	Uso:
   271	  bun scripts/mycelium-query.ts <node>           # BFS grau 2
   272	  bun scripts/mycelium-query.ts <node> --depth 4
   273	  bun scripts/mycelium-query.ts --paths <a> <b>
   274	  bun scripts/mycelium-query.ts <node> --json    # output AI⟷AI
   275	
   276	Flags:
   277	  --depth N          profundidade BFS (default 2)
   278	  --paths <a> <b>    caminhos mais curtos entre dois nós
   279	  --json             output machine-readable
   280	  --snapshot <file>  snapshot alternativo (default ~/.egos/mycelium-snapshot.json)
   281	`);
   282	    process.exit(0);
   283	  }
   284	
   285	  // Parse --snapshot
   286	  const snapIdx = args.indexOf("--snapshot");
   287	  const snapPath =
   288	    snapIdx >= 0
   289	      ? resolve(args[snapIdx + 1])
   290	      : resolve(homedir(), ".egos/mycelium-snapshot.json");
   291	
   292	  if (!existsSync(snapPath)) {
   293	    console.error(`[ERROR] Snapshot não encontrado: ${snapPath}`);
   294	    console.error(
   295	      "  Gere com: bun scripts/mycelium-snapshot.ts --exec",
   296	    );
   297	    process.exit(1);
   298	  }
   299	
   300	  const graph: ReferenceGraph = JSON.parse(readFileSync(snapPath, "utf8"));
   301	  const nodeMap = new Map<string, ReferenceNode>(
   302	    graph.nodes.map((n) => [n.id, n]),
   303	  );
   304	  const adj = buildAdj(graph.edges);
   305	
   306	  const isJson = args.includes("--json");
   307	  const isPaths = args.includes("--paths");
   308	
   309	  // ── Mode: --paths <a> <b>
   310	  if (isPaths) {
   311	    const pathsIdx = args.indexOf("--paths");
   312	    const aQuery = args[pathsIdx + 1];
   313	    const bQuery = args[pathsIdx + 2];
   314	
   315	    if (!aQuery || !bQuery) {
   316	      console.error("[ERROR] --paths requer dois nós: --paths <a> <b>");
   317	      process.exit(1);
   318	    }
   319	
   320	    const aNodes = findNodes(graph.nodes, aQuery);
   321	    const bNodes = findNodes(graph.nodes, bQuery);
   322	
   323	    if (aNodes.length === 0) {
   324	      console.error(`[ERROR] Nó não encontrado: "${aQuery}"`);
   325	      process.exit(1);
   326	    }
   327	    if (bNodes.length === 0) {
   328	      console.error(`[ERROR] Nó não encontrado: "${bQuery}"`);
   329	      process.exit(1);
   330	    }
   331	    if (aNodes.length > 1) {
   332	      console.error(
   333	        `[AMBIGUOUS] "${aQuery}" corresponde a ${aNodes.length} nós:`,
   334	      );
   335	      aNodes.forEach((n) => console.error(`  ${n.id} — ${n.label}`));
   336	      process.exit(1);
   337	    }
   338	    if (bNodes.length > 1) {
   339	      console.error(
   340	        `[AMBIGUOUS] "${bQuery}" corresponde a ${bNodes.length} nós:`,
   341	      );
   342	      bNodes.forEach((n) => console.error(`  ${n.id} — ${n.label}`));
   343	      process.exit(1);
   344	    }
   345	
   346	    const fromId = aNodes[0].id;
   347	    const toId = bNodes[0].id;
   348	    const paths = shortestPaths(fromId, toId, adj);
   349	
   350	    if (isJson) {
   351	      process.stdout.write(
   352	        JSON.stringify(
   353	          {
   354	            from: fromId,
   355	            to: toId,
   356	            paths_found: paths.length,
   357	            paths: paths.map((p, i) => ({
   358	              index: i + 1,
   359	              hops: p.length - 1,
   360	              nodes: p.map((id) => ({
   361	                id,
   362	                label: nodeMap.get(id)?.label ?? id,
   363	                type: nodeMap.get(id)?.type ?? "unknown",
   364	                status: nodeMap.get(id)?.status ?? "unknown",
   365	              })),
   366	            })),
   367	          },
   368	          null,
   369	          2,
   370	        ) + "\n",
   371	      );
   372	    } else {
   373	      printPaths(paths, nodeMap, fromId, toId);
   374	    }
   375	    return;
   376	  }
   377	
   378	  // ── Mode: BFS neighborhood
   379	  // Build set of flag-value args to exclude (only when the flag exists)
   380	  const flagValues = new Set<string>();
   381	  const valuedFlags = ["--depth", "--snapshot"];
   382	  for (const flag of valuedFlags) {
   383	    const idx = args.indexOf(flag);
   384	    if (idx >= 0 && idx + 1 < args.length) {
   385	      flagValues.add(args[idx + 1]);
   386	    }
   387	  }
   388	  const nonFlagArgs = args.filter(
   389	    (a) => !a.startsWith("--") && !flagValues.has(a),
   390	  );
   391	
   392	  const query = nonFlagArgs[0];
   393	  if (!query) {
   394	    console.error("[ERROR] Informe um nó para consultar.");
   395	    process.exit(1);
   396	  }
   397	
   398	  const depthIdx = args.indexOf("--depth");
   399	  const depth = depthIdx >= 0 ? parseInt(args[depthIdx + 1], 10) : 2;
   400	
   401	  if (isNaN(depth) || depth < 1) {
   402	    console.error("[ERROR] --depth deve ser um inteiro >= 1");
   403	    process.exit(1);
   404	  }
   405	
   406	  const candidates = findNodes(graph.nodes, query);
   407	
   408	  if (candidates.length === 0) {
   409	    console.error(`[NOT FOUND] Nenhum nó corresponde a "${query}"`);
   410	    console.error("  Nós disponíveis (amostra):");
   411	    graph.nodes.slice(0, 20).forEach((n) =>
   412	      console.error(`    ${n.id} — ${n.label}`),
   413	    );
   414	    process.exit(1);
   415	  }
   416	
   417	  if (candidates.length > 1) {
   418	    console.error(
   419	      `[AMBIGUOUS] "${query}" corresponde a ${candidates.length} nós:`,
   420	    );
   421	    candidates.forEach((n) =>
   422	      console.error(`  ${n.id} — ${n.label}  [${n.type}]`),
   423	    );
   424	    process.exit(1);
   425	  }
   426	
   427	  const root = candidates[0];
   428	  const steps = bfsNeighborhood(root.id, depth, adj);
   429	
   430	  if (isJson) {
   431	    process.stdout.write(
   432	      JSON.stringify(
   433	        {
   434	          root: {
   435	            id: root.id,
   436	            label: root.label,
   437	            type: root.type,
   438	            status: root.status,
   439	          },
   440	          depth_requested: depth,
   441	          snapshot_generated: graph.generated,
   442	          total_nodes_reached: steps.length,
   443	          by_depth: Object.fromEntries(
   444	            Array.from(
   445	              steps.reduce((m, s) => {
   446	                if (!m.has(s.depth)) m.set(s.depth, []);
   447	                m.get(s.depth)!.push({
   448	                  id: s.nodeId,
   449	                  label: nodeMap.get(s.nodeId)?.label ?? s.nodeId,
   450	                  type: nodeMap.get(s.nodeId)?.type ?? "unknown",
   451	                  status: nodeMap.get(s.nodeId)?.status ?? "unknown",
   452	                  via: s.via,
   453	                  relation: s.relation,
   454	                  dir: s.dir,
   455	                  path: s.path,
   456	                });
   457	                return m;
   458	              }, new Map<number, unknown[]>()),
   459	            ).map(([k, v]) => [String(k), v]),
   460	          ),
   461	        },
   462	        null,
   463	        2,
   464	      ) + "\n",
   465	    );
   466	  } else {
   467	    console.log(
   468	      `\nMycelium Query — snapshot: ${graph.generated} | nós: ${graph.nodes.length} | arestas: ${graph.edges.length}`,
   469	    );
   470	    printBfs(root, steps, nodeMap);
   471	  }
   472	}
   473	
   474	main();

exec
/bin/bash -lc "cat tsconfig.json 2>/dev/null | sed -n '1,160p'; grep -R \"noUnusedLocals\" -n tsconfig* package.json 2>/dev/null || true" in /home/enio/egos
 succeeded in 0ms:
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

exec
/bin/bash -lc 'bunx tsc --noEmit --pretty false 2>&1 | tail -100' in /home/enio/egos
 succeeded in 8458ms:
exec
/bin/bash -lc 'git diff c5ed3947de7bd5f5b44c8ecb1e30b590a6bf0ead -- .husky/_checks/15-agent-gate.sh agents/registry/leaf-repos.json | head -200' in /home/enio/egos
 succeeded in 0ms:
exec
/bin/bash -lc "ls scripts/*mycelium*; sed -n '1,120p' scripts/mycelium-snapshot.ts 2>/dev/null || true; find ~/.egos -maxdepth 1 -name 'mycelium-snapshot.json' -print -exec head -40 {} \\; 2>/dev/null" in /home/enio/egos
 succeeded in 0ms:
scripts/mycelium-query.ts
scripts/mycelium-snapshot.ts
scripts/test-mycelium-bus.ts
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
/home/enio/.egos/mycelium-snapshot.json
{
  "version": "1.0.0",
  "generated": "2026-06-10T11:18:52.380Z",
  "nodes": [
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
    },
    {
      "id": "repo:arch",
      "type": "repository",
      "label": "arch",
      "status": "active",
      "evidence": [
        "code"
      ],
      "sourcePath": "/home/enio/arch",
      "note": "last_commit: 2026-06-10"
    },
    {
      "id": "repo:blueprint-egos",

exec
/bin/bash -lc 'bun scripts/mycelium-query.ts repo:852 --depth 1 | head -60; echo exit:${PIPESTATUS[0]}; bun scripts/mycelium-query.ts --paths repo:852 ws:egos-kernel --json | head -80' in /home/enio/egos
 succeeded in 0ms:

Mycelium Query — snapshot: 2026-06-10T11:18:52.380Z | nós: 103 | arestas: 129

Neighborhood of: [+] 852  (repo:852)  [repository]
────────────────────────────────────────────────────────────────────────

  Grau 1:
    [+] EGOS Kernel (/home/enio/egos)  (ws:egos-kernel)  [workspace_root]
      via 852  <--[governs]--
      path: repo:852 > ws:egos-kernel

Total: 1 nós alcançados (1 graus)

exit:0
{
  "from": "repo:852",
  "to": "ws:egos-kernel",
  "paths_found": 1,
  "paths": [
    {
      "index": 1,
      "hops": 1,
      "nodes": [
        {
          "id": "repo:852",
          "label": "852",
          "type": "repository",
          "status": "active"
        },
        {
          "id": "ws:egos-kernel",
          "label": "EGOS Kernel (/home/enio/egos)",
          "type": "workspace_root",
          "status": "active"
        }
      ]
    }
  ]
}

exec
/bin/bash -lc 'git diff c5ed3947de7bd5f5b44c8ecb1e30b590a6bf0ead --name-status' in /home/enio/egos
 succeeded in 0ms:
M	.agents/workflows/start.md
M	.claude/agents/guarani.md
M	.claude/commands/start.md
M	.husky/pre-commit
M	AGENTS.md
M	TASKS.md
M	apps/egos-landing/public/timeline/rss
M	apps/egos-landing/public/timeline/rss.xml
M	docs/CAPABILITY_REGISTRY.md
M	docs/_archived_handoffs/2026-04/handoff_2026-03-31.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-06_p29.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-07_chatbot_p0_guard_credentials_xcom.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-12b.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-14.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-16_bilingual_pipeline.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-17b.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-23.md
M	docs/_archived_handoffs/2026-04/handoff_2026-04-24.md
M	docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md
M	docs/_archived_handoffs/2026-05/PARTNERSHIP_KIT_INDEX.md
M	docs/_archived_handoffs/2026-05/PRODUTOS_pre-central-egos-pivot.md
M	docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md
M	docs/_archived_handoffs/2026-05/handoff_2026-05-18_grok-decisions-applied.md
M	docs/_archived_handoffs/HANDOFF_CURRENT.md
M	docs/_archived_handoffs/MEMORY_SESSION_INDEX.md
A	docs/_current_handoffs/FOR_GUARANI_2026-06-10_end-review.md
M	docs/_current_handoffs/handoff_2026-06-10.md
M	docs/agents/META_PROMPTS_INDEX.md
M	docs/audits/CAPABILITY_COVERAGE_2026-05-30.md
M	docs/audits/INTEGRATION_COVERAGE_2026-05-30.md
M	docs/concepts/ESPIRAIS_VISION.md
M	docs/concepts/ESPIRAL_DE_ESCUTA_CANON.md
M	docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md
M	docs/governance/AREAS_OF_PRACTICE.md
M	docs/governance/CLIENT_KB_DOCTRINE.md
M	docs/governance/CLIENT_TIERS_MATRIX.md
M	docs/governance/EGOS_OPERATING_PRINCIPLES.md
M	docs/governance/MASTER_INDEX.md
A	docs/jobs/2026-06-10-crossrefs-report.json
M	docs/jobs/2026-06-10-doc-drift-verifier.json
M	docs/jobs/2026-06-10-pre-commit-pipeline.json
M	docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md
M	docs/products-specs/INDEX.md
M	docs/products-specs/anythingllm/OPERATIONS.md
M	docs/runbooks/CLIENT_INCIDENT_RUNBOOK.md
M	docs/runbooks/MOBILE_ACCESS_GUIDE.md
M	docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
M	docs/strategy/ROADMAP.md
M	docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md
M	scripts/egos-home/sync.sh
A	scripts/mycelium-query.ts

exec
/bin/bash -lc "git diff c5ed3947de7bd5f5b44c8ecb1e30b590a6bf0ead -- apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/jobs/2026-06-10-doc-drift-verifier.json docs/jobs/2026-06-10-pre-commit-pipeline.json docs/CAPABILITY_REGISTRY.md | sed -n '1,220p'" in /home/enio/egos
 succeeded in 0ms:
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
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..b39c5e51 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T12:06:39.878Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1379",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 372d18fd..0ad52da6 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -222,5 +222,29 @@
     "duration_ms": null,
     "event": "commit:feat files=9 sha=d4f57d5a",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T11:38:50.425Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=15 sha=c5ed3947",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:03:21.067Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=6 sha=749d8d59",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
   }
 ]

exec
/bin/bash -lc "pwd; find docs -path '*appendix*' -maxdepth 5 -type f | head -50; dirname docs/strategy/_archived_2026-05-06/CONSULTING_MASTER_PLAN.md" in /home/enio/egos
 succeeded in 0ms:
/home/enio/egos
docs/strategy/appendix/DPIO_QUESTIONNAIRE.md
docs/strategy/appendix/KB_DECISION_MATRIX.md
docs/strategy/appendix/DEBRIEF_ARCHITECTURE.md
docs/strategy/appendix/PRICING_ANCHORS.md
docs/strategy/appendix/TRUST_PAGE_SPEC.md
docs/strategy/appendix/WHATSAPP_ONBOARDING_GUIDE.md
docs/strategy/_archived_2026-05-06

exec
/bin/bash -lc 'cat agents/registry/leaf-repos.json' in /home/enio/egos
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

codex
The changed sync script now fails unconditionally at runtime on its repo-list fallback check, preventing the governance sync workflow from running. Other inspected changes are mostly documentation or additive tooling and did not show blocking issues.

Review comment:

- [P2] Fix invalid array-length fallback expansion — /home/enio/egos/scripts/egos-home/sync.sh:36-36
  When `scripts/egos-home/sync.sh` reaches this fallback check, Bash aborts with `bad substitution` because `${#REPOS[@]:-0}` combines array-length expansion with a default operator, which Bash does not support. This happens even after `jq` successfully populates `REPOS`, so the sync script now exits before validating or syncing any repo; use a valid length check such as `${#REPOS[@]}` after initializing the array.
The changed sync script now fails unconditionally at runtime on its repo-list fallback check, preventing the governance sync workflow from running. Other inspected changes are mostly documentation or additive tooling and did not show blocking issues.

Review comment:

- [P2] Fix invalid array-length fallback expansion — /home/enio/egos/scripts/egos-home/sync.sh:36-36
  When `scripts/egos-home/sync.sh` reaches this fallback check, Bash aborts with `bad substitution` because `${#REPOS[@]:-0}` combines array-length expansion with a default operator, which Bash does not support. This happens even after `jq` successfully populates `REPOS`, so the sync script now exits before validating or syncing any repo; use a valid length check such as `${#REPOS[@]}` after initializing the array.
```
