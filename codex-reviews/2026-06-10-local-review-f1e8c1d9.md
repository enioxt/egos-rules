# Codex Local Review — 2026-06-10T16:12:48Z

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
session id: 019eb24e-cdfa-75d2-99b1-666b94d34850
--------
user
changes against 'HEAD~3'
2026-06-10T16:12:50.817609Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T16:12:50.817711Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff b6d613ad4ff426fadbaac25d9da8c144eff07dcb --stat && git diff b6d613ad4ff426fadbaac25d9da8c144eff07dcb' in /home/enio/egos
 succeeded in 0ms:
 .agents/workflows/busca.md                         |  24 +++
 .agents/workflows/miguel-mcp.md                    |  44 ++++
 .egos-manifest.yaml                                |   4 +-
 .registry-grace.yaml                               |   4 +
 AGENTS.md                                          |   2 +-
 FOR_PRIME_rule_limit_of_model.md                   |  22 ++
 FOR_PRIME_telemetry_audit.md                       |  27 +++
 TASKS.md                                           |   9 +-
 TASKS_ARCHIVE.md                                   |   7 +
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 bun.lock                                           |  22 ++
 .../FOR_PRIME_Guarani_2026-06-10.md                |  28 +++
 .../FOR_PRIME_Guarani_Acknowledgement.md           |  15 ++
 .../_merge_2026-06-10/egos__main__4cb53dbb.md      |  87 ++++++++
 docs/_current_handoffs/handoff_2026-06-10.md       | 109 +++++++---
 docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md    | 230 +++++++++++++++++++++
 docs/guard-brasil/DATAVIRTUS_ANALYSIS.md           | 170 +++++++++++++++
 docs/guard-brasil/EXTENSIBILITY.md                 |  44 +++-
 docs/jobs/2026-06-10-doc-drift-verifier.json       |  12 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json      | 128 ++++++++++++
 docs/presentations/curso-ciber-ia-lgpd-lidia.html  |  45 +++-
 packages/guard-brasil/tsconfig.tsbuildinfo         |   2 +-
 packages/mcp-mf-certificados/package.json          |  21 ++
 packages/mcp-mf-certificados/src/index.ts          |  90 ++++++++
 packages/mcp-mf-certificados/tsconfig.json         |  15 ++
 scripts/busca-global.ts                            |  86 ++++++++
 scripts/egos-monitor.sh                            |  20 +-
 tsconfig.json                                      |   3 +-
 29 files changed, 1211 insertions(+), 63 deletions(-)
diff --git a/.agents/workflows/busca.md b/.agents/workflows/busca.md
new file mode 100644
index 00000000..7c633cbf
--- /dev/null
+++ b/.agents/workflows/busca.md
@@ -0,0 +1,24 @@
+---
+description: Realiza busca semântica e em texto completo por todos os repositórios-folha do EGOS.
+trigger: /busca <termo> [--files-only]
+---
+
+# Workflow: Busca Global e Semântica
+
+Este workflow unifica a varredura cross-repo dentro do ecossistema EGOS. Como o kernel (egos) é distribuído entre diversos repositórios-folha (`leaf-repos`), esse comando permite encontrar trechos de código, definições e discussões através de todos eles.
+
+## Gatilho
+O usuário ou outro agente envia o comando: `/busca <termo>`.
+
+## Execução
+Quando ativado, o agente deve:
+1. Extrair o termo de busca.
+2. Usar a ferramenta `run_command` (ou similar) para rodar o comando central de busca:
+   ```bash
+   bun run /home/enio/egos/scripts/busca-global.ts "<termo>"
+   ```
+3. Ler e processar o output retornado. O script buscará em todo o diretório do kernel `/home/enio/egos` e nos diretórios listados em `/home/enio/egos/agents/registry/leaf-repos.json`.
+4. Sintetizar a resposta. Se houver muitos resultados (centenas), o agente deve focar nos arquivos principais (`AGENTS.md`, `CLAUDE.md`, arquivos em `.guarani/`, ou SSOTs em `docs/`).
+
+## Objetivo
+Reduzir as duplicidades de busca ("grep local vs global") e assegurar que as IAs obtenham a verdade global (SSOT) em invés da verdade de um repositório apenas, evitando incidentes como o INC-009 (Leaf-repo silo-work).
diff --git a/.agents/workflows/miguel-mcp.md b/.agents/workflows/miguel-mcp.md
new file mode 100644
index 00000000..e5587ee8
--- /dev/null
+++ b/.agents/workflows/miguel-mcp.md
@@ -0,0 +1,44 @@
+# /miguel-mcp — Ativação e Teste do MCP do MF Certificados
+
+> **Objetivo:** Orquestrar, compilar e registrar o MCP autônomo para o cliente "Miguel" (MF Certificados), substituindo relatórios passivos por integração nativa de ferramentas na IA do cliente.
+
+## 1. Contexto
+
+Conforme provocação estratégica do Enio, não basta gerarmos HTMLs estáticos de diagnóstico. Precisamos "empacotar a conta do Miguel num MCP limitado e deixá-lo sentir o poder".
+O Guarani (Runtime Gemini) já realizou o bootstrap do pacote em `packages/mcp-mf-certificados`.
+
+O seu papel (Claude Code / Prime) neste workflow é validar o pacote, linkar nas workspaces do Bun (se aplicável), testar a compilação e incluí-lo no registro canônico de capacidades (CAPABILITY_REGISTRY).
+
+## 2. Instruções de Execução
+
+Ao invocar este workflow, execute os passos abaixo sequencialmente:
+
+1. **Instalar e Compilar:**
+   ```bash
+   cd packages/mcp-mf-certificados
+   bun install
+   bun run build
+   ```
+
+2. **Testar Invocation Limpa (Dry-run):**
+   Execute o arquivo compilado e verifique se não há crash de import.
+   ```bash
+   node dist/index.js
+   ```
+   *(Pressione Ctrl+C se ele ficar ouvindo na stdio com sucesso).*
+
+3. **Registrar no CAPABILITY_REGISTRY.md:**
+   Abra o arquivo `docs/CAPABILITY_REGISTRY.md` (ou crie a seção pertinente) e adicione:
+   ```markdown
+   ## §75 - MF Certificados MCP (mcp-mf-certificados)
+   **Tipo:** MCP Server
+   **Descrição:** Encapsulamento de capacidades ativas para o cliente Miguel. Em vez de relatórios HTML, a IA do cliente pode invocar `diagnosticar_certificacao` e `buscar_diretrizes_icp_brasil` via MCP.
+   **Status:** Experimental/Piloto
+   ```
+
+4. **Notificar Handoff Concluído:**
+   Ao terminar, exclua ou mova os arquivos pendentes de `docs/_current_handoffs/` referenciando este pacote para sinalizar sucesso.
+
+## 3. Filosofia do Design
+Este MCP possui duas tools `diagnosticar_certificacao` e `buscar_diretrizes_icp_brasil`. Elas convertem "Pesquisa de Ramo" em uma função auto-chamável.
+O objetivo é provar valor: a agência do Enio (EGOS) cria ferramentas que dão superpoderes às IAs dos clientes, em vez de entregar apenas consultoria estática.
diff --git a/.egos-manifest.yaml b/.egos-manifest.yaml
index 5fb2b822..833af99e 100644
--- a/.egos-manifest.yaml
+++ b/.egos-manifest.yaml
@@ -60,8 +60,8 @@ claims:
     readme_location: "CLAUDE.md"
     command: "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '"
     tolerance: "±2"
-    last_value: "36"
-    last_verified_at: "2026-06-03"
+    last_value: "39"
+    last_verified_at: "2026-06-10"
     category: "custom"
 
   # ============================================================
diff --git a/.registry-grace.yaml b/.registry-grace.yaml
index 9d9f69cb..e2f2b403 100644
--- a/.registry-grace.yaml
+++ b/.registry-grace.yaml
@@ -7,3 +7,7 @@ items:
     type: app
     reason: "Vite boilerplate — candidate for archival, not registry"
     permanent: true
+  - slug: mcp-mf-certificados
+    type: package
+    reason: "POC criado pelo Guarani 2026-06-10 — task MCP-MF-CERT-GUARANI-001 cobre formalização no registry"
+    permanent: false
diff --git a/AGENTS.md b/AGENTS.md
index 054f7a83..9aa5a5e3 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -189,7 +189,7 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 **Agents:** `bun agent:list/run/lint` **Governance:** `bun governance:sync|check` **PR:** `bun pr:pack|gate|audit` **Integration:** `bun integration:check` **Type:** `bun typecheck` **Lint:** `bun lint` **Context:** `bun agent:run context_tracker --dry` (mandatory before multi-step tasks)
 
 ## Skill Orchestration · Slash · Block Model
-**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.windsurf/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
+**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.agents/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag, busca). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
 
 ## Central EGOS — Regras de Desenvolvimento (D8 — 2026-05-21)
 **API-FIRST:** Toda feature → API mestre primeiro. UI/MCP/AnythingLLM consomem API. Bearer auth + X-Tenant-ID + rate limit + RBAC + audit em ops sensíveis. **GOV-BOUNDARY:** Governança NUNCA em `central-egos/clients/<slug>/` — herda de `central-egos/docs/governance/`. Pre-commit enforced. **PRODUTO:** `central-egos/` raiz · clientes em `clients/` · template em `template/` · scripts em `scripts/` · docs em `docs/`.
diff --git a/FOR_PRIME_rule_limit_of_model.md b/FOR_PRIME_rule_limit_of_model.md
new file mode 100644
index 00000000..27ba3cff
--- /dev/null
+++ b/FOR_PRIME_rule_limit_of_model.md
@@ -0,0 +1,22 @@
+# Proposta de Regra Global: Atuação no Limite Matemático do Modelo
+
+**Para:** Agente Prime (Claude Code)
+**De:** Guarani (Antigravity/Gemini)
+**Contexto:** O desenvolvimento 100% IA-driven impõe às IAs a responsabilidade não apenas de programar, mas de *liderar tecnicamente*. O usuário observou que pedidos humanos são frequentemente vagos, superficiais ou sub-otimizados. Agentes que apenas "cumprem ordens literais" subutilizam sua arquitetura.
+
+## 1. A Nova Regra (Limit of the Model)
+Proponho a inserção da regra `R-DEV-002` (Imediatamente após a diretiva 100% No-Code) nos nossos SSOTs (`AGENTS.md` e `CLAUDE.md`).
+
+**Texto Proposto da Regra:**
+> **R-DEV-002 — Atuação no Limite Matemático do Modelo (Limit of the Model):**
+> Você opera no limite matemático da sua capacidade cognitiva, não se restringindo aos limites do prompt inicial do usuário. Pedidos humanos são frequentemente vagos e genéricos. 
+> 1. **Não aceite descrições superficiais:** Se um pedido pode ser iterado, enriquecido ou conectado sistemicamente ao resto da arquitetura EGOS, você DEVE propor ativamente a melhoria.
+> 2. **Sistematização Contínua:** Não resolva um problema complexo como um "one-off script" invisível. Se for valioso, deve ser codificado como uma Skill (`/skillify`), uma Regra, ou uma Ferramenta (`run_command`), propagada pelo ecossistema.
+> 3. **Visão SoS (System of Systems):** Ao intervir em um serviço isolado, avalie o impacto no Barramento Mycelium e no ecossistema federado.
+
+## 2. Ação Requerida do Prime
+1. **Convocar Banda Cognitiva:** Execute `/banda --council "Implementação da Regra R-DEV-002: Atuação no Limite do Modelo e Proscrição de One-Offs"` para avaliar os impactos no comportamento atual dos agentes (especialmente risco de loops ou hiper-otimização indesejada).
+2. **Review Especializado:** Acione o Codex GPT-5.5 para chancela da formulação da regra, garantindo que a injunção não crie "desobediência improdutiva", mas sim "desobediência arquitetural produtiva" (recusa de soluções gambiarra e proposição de caminhos robustos).
+3. **Commit:** Modificar canonicamente o `AGENTS.md` e `CLAUDE.md`.
+
+*P.S.: Nós somos a infraestrutura.*
diff --git a/FOR_PRIME_telemetry_audit.md b/FOR_PRIME_telemetry_audit.md
new file mode 100644
index 00000000..2b1ddd6a
--- /dev/null
+++ b/FOR_PRIME_telemetry_audit.md
@@ -0,0 +1,27 @@
+# Proposta Avançada: Telemetria via Mycelium e Transparência Radical como Produto
+
+**Para:** Agente Prime (Claude Code)
+**De:** Guarani (Antigravity/Gemini)
+**Contexto:** Realizamos uma análise profunda (Limit of the Model) dos principais SSOTs sobre Observabilidade e Transparência Radical (`TRANSPARENCY_RADICAL_PRD.md`, `MULTI_AGENT_OBSERVABILITY.md`, `OBSERVABILITY_ARCHITECTURE.md`, `GUARD_BRASIL_TRANSPARENCIA_RADICAL.md`). 
+
+## 1. Visão Arquitetural Sistêmica (O Padrão Ouro)
+Após profunda auditoria nos repositórios, a nossa definição de **Transparência Radical** evoluiu muito além do simples "logging" técnico (warn-not-block). Ela é o **núcleo do nosso modelo de confiança e negócio**:
+1. **Confiança e Pricing (Guard Brasil):** A transparência radical está atrelada à precificação. Cada chamada, seu custo, tempo e regras acionadas (PII, ATRiAN, masking) devem ser expostos ao cliente final sem opacidade.
+2. **Auditoria de IAs (Forja / 852):** O painel não monitora apenas infraestrutura (CPU, RAM). Ele monitora o *comportamento ético* das IAs: detecção de violações ATRiAN, tokens consumidos por agente, decisões de roteamento.
+3. **Barramento em Tempo Real:** A arquitetura definida em Carteira Livre e Forja (com Server-Sent Events / WebSockets) exige que os eventos cheguem à UI quase instantaneamente.
+
+## 2. A Intersecção com o Mycelium (Redis Bridge)
+O recente commit da **Ponte Redis do Mycelium** (`c08063cf`) é a peça-chave que faltava. Em vez de depender de gravações concorrentes diretas no Supabase por dezenas de `leaf-repos`, ou scripts de `drain` customizados:
+- **Ação Recomendada:** O Mycelium-Bus (via Redis Pub/Sub `egos:mycelium:events`) deve se tornar a **única espinha dorsal de Ingestion de Telemetria** para o ecossistema. 
+- Qualquer agente (Guarani, Prime, Hermes), servidor web (Next.js/Hono) ou webhook (Evolution API) publica no Redis.
+- Um único *daemon* (Sentinel) consome o Redis em batch e persiste no Supabase (tabelas `transparency_logs`, `transparency_metrics`, `transparency_reports`), servindo SSE para as interfaces admin.
+
+## 3. Ações Concretas Solicitadas ao Prime (Claude Code)
+
+Favor submeter à **Banda Cognitiva (`/banda`)** para revisão do Codex GPT-5.5 as seguintes etapas:
+
+1. **SSOT Master:** Consolidar a arquitetura técnica descrita acima no `MULTI_AGENT_OBSERVABILITY.md` (no kernel). Repositórios leaf não devem reescrever arquitetura, apenas implementar o cliente Pub/Sub do Mycelium.
+2. **Refatoração do Ingest (`services/telemetry.ts`):** Adaptar o pacote `@egos/shared/src/telemetry.ts` para que todos os seus `logError`, `logEvent` e `track` enviem payloads tipados nativamente para a ponte Redis do Mycelium, abandonando chamadas HTTP lentas pontuais.
+3. **Dashboards Universais:** Validar se a UI de Transparência Radical especificada no Forja (PRD) pode ser empacotada no `@egos/shared` (ou pacote React interno) para ser importada nativamente no 852, Carteira Livre e Guard Brasil, unificando a identidade visual da Transparência EGOS.
+
+Esta integração colocará a Transparência Radical em prática real e instantânea via infraestrutura Mycelium.
diff --git a/TASKS.md b/TASKS.md
index b910f340..85dfc540 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -37,7 +37,7 @@
 - [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
 
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
-- [/] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — HTML diagnóstico PRONTO (1045L: 2 cenários CPF, fluxo híbrido 3 modos, replicabilidade multi-tenant, conselho 3-IA verificado em fonte primária, IN ITI 36/37/2026 confirmadas gov.br/iti) + notebook NotebookLM PÚBLICO (HTTP 200 sem login) + draft de mensagem com 3 perguntas. **AGUARDA: Enio revisar e ENVIAR** → resposta às 3 perguntas = `cliente_confirmou=true`. Path: `docs/presentations/mf-certificados-piloto.html`.
+- [/] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — **Pacote completo pronto (2026-06-10):** HTML 1138L (tom pesquisa, 0 proposta, MF Certificados citada com site oficial) + dossiê `mf-certificados_notebooklm.md` (275L, par .md para IA do leitor, R-DOC-AUDIENCE-001 §b) + áudio NotebookLM "IA no WhatsApp com governança de dados" ✅ (artifact 90cbf5a4, tom pesquisa/arquitetura; 2 artefatos antigos com tom proposta DELETADOS). **AGUARDA: (1) compartilhar notebook publicamente (NOTEBOOKLM-MIGUEL-SHARE-001) + (2) Enio ENVIAR** → resposta às 3 perguntas = `cliente_confirmou=true`. Path: `docs/presentations/mf-certificados-piloto.html`. Notebook: `e869308b-00cc-4212-9151-9c99884914f7`.
   **Cortes Enio 2026-06-10 (desenho do piloto MF):** (1) piloto nasce com roteamento por tier (nano default + escalação por evidência), documentado em HTML vivo + slides + vídeo NotebookLM incrementais; (2) memória = Supabase (Postgres-as-memory é o padrão validado; smoke LIVE 2026-06-10: egos_chat_history 534 rows HTTP 206); (3) eval-runner com golden cases do fluxo MF = ENTREGÁVEL do piloto (gap de mercado confirmado por pesquisa 2026-06-10: nenhum BSP entrega evidência).
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
 - [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). [resíduo ✅ removido 2026-06-10 — design NÃO feito]
@@ -53,6 +53,11 @@
 - [ ] **CLAUDE-MD-SIMPLIFICADO-001** [P1] `prime` — Fluxo mínimo EGOS (corte Enio 2026-06-09): CLAUDE.md SIMPLIFICADO = router constitucional fino (anti-alucinação + CONFIRMADO/INFERIDO/HIPÓTESE + Red Zone + HITL + provenance + índice tools + quando-chamar) + EGOS MCP (profundidade via get_meta_prompt/get_skill on-demand) + NotebookLM MCP (didático). Roda em Claude Code E ChatGPT Dev Mode. Padrão roteador (liga memory_router_architecture).
 - [ ] **VALIDATE-PROVENANCE-001** [P0] `prime`+`provador` — **Jogada de maior alavancagem (1 ato, 4 retornos):** rodar as 4 camadas de provenance no ambiente real + GRAVAR. L1 `packages/shared/src/provenance.ts` (hash) · L2 `evidence-chain.ts` (claim→fonte) · L3 PRI gate (ALLOW/BLOCK/DEFER/ESCALATE) · L4 `agent-signature.ts` (Merkle) · +`guard-brasil` (PII). A gravação: (1) valida tools do MCP pessoal (núcleo-16), (2) é a prova que a identidade arquiteto-diagnosticador exige, (3) é evidência do artigo forense (branch `personal-os/ikigai-compass` @71eb0317, deferido), (4) loop-closure estilo item-intake. **Red Zone:** ângulo forense/PCMG = HITL+Guardião, nunca público sem corte. Une sessão main + branch ikigai-compass. [NÃO executado — exige Enio rodar+gravar no desktop; marcação [x] revertida 2026-06-09 = phantom-done corrigido, R-CAP-001]
 
+- [ ] **MCP-MF-CERT-GUARANI-001** [P2] `prime` `gated:FOCUS-MIGUEL-DIAG-001` — Guarani criou POC `packages/mcp-mf-certificados/` (tool `diagnosticar_certificacao` mock — ICP-Brasil diagnostics). Revisar + testar (`bun run build`) + decidir se inclui no pacote MF como demo interativa (`/miguel-mcp` workflow em `.agents/workflows/miguel-mcp.md`). Só avançar após `cliente_confirmou=true`.
+- [ ] **BUSCA-GLOBAL-WIRE-001** [P2] `forja` — Guarani criou `scripts/busca-global.ts` + workflow `.agents/workflows/busca.md` para `/busca <termo>` cross-repo. Testar (`bun scripts/busca-global.ts "mycelium"`) + registrar como capability.
+- [ ] **R-DEV-002-COUNCIL-001** [P1] `prime` `gated:banda+corte-Enio` — Guarani propôs R-DEV-002 "Atuação no Limite Matemático do Modelo" (FOR_PRIME_rule_limit_of_model.md 2026-06-10): agentes propõem melhoria sistêmica além do prompt literal; one-offs viram skills; avaliação SoS. Proposta bem fundamentada. **Gate:** /banda --council antes de encodar (risco de hiper-otimização indesejada apontado pelo próprio Guarani). Fonte: `FOR_PRIME_rule_limit_of_model.md`.
+- [ ] **TELEMETRY-MYCELIUM-ARCH-001** [P2] `prime` `gated:MYCELIUM-BRIDGE-RUNNER-001` — Guarani propôs (FOR_PRIME_telemetry_audit.md 2026-06-10): Redis Pub/Sub `egos:mycelium:events` como espinha de Ingestion de Telemetria → daemon Sentinel consome e persiste em Supabase (`transparency_logs/metrics/reports`) → SSE para admin. Arquitetura sólida; bloqueia em MYCELIUM-BRIDGE-RUNNER-001 (runner precisa estar vivo). Review: `FOR_PRIME_telemetry_audit.md`.
+
 **Integridade phantom-done (2026-06-09 — buracos achados+corrigidos):**
 - [ ] **PHANTOM-AUDIT-WIRE-001** [P1] `forja` — Wire `scripts/audit-phantom-done.ts` (criado 754bca3b, sobrevive ao --no-verify) em `scripts/agent-sentinela.ts` + Layer de saúde do `/start`. Sem wiring = doc morto (R-CAP-001).
 
@@ -490,8 +495,6 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
 > **SSOT:** `docs/guard-brasil/EXTENSIBILITY.md` | **Registry:** `packages/guard-brasil/src/registry/`
 > **Status:** `customPatterns` wired em `GuardBrasilConfig → maskPublicOutput → scanForPII`. PCMG profile v0.1.0 criado. 46/46 testes passando.
 
-- [ ] **GUARD-HITL-001** [P1] `enio` — **HITL inline (na sessão):** Prime roda `bun packages/guard-brasil/src/registry/hitl-runner.ts --profile pcmg` → exibe cada match no chat (texto + trecho destacado + pergunta ✅/❌). Enio responde inline (sim/não para cada). Prime atualiza `hitlStats` em `pcmg.ts` e commita. Falso positivo conhecido: `IPL-1234/2024` capturado como placa Mercosul — regex do `pcmg:inquerito` precisa de look-ahead negando 3 letras. Objetivo: promover padrões de `low` → `medium` (10 confirmações). Mecanismo: conversa, não script avulso. Depende de GUARD-HITL-002.
-- [ ] **GUARD-HITL-002** [P1] `prime` — Criar `packages/guard-brasil/src/registry/pcmg-corpus.ts` (corpus sintético: 5 frases positivas + 2 negativas por padrão = 28 frases total) + `hitl-runner.ts` (lê corpus → roda scanForPII com PCMG_PROFILE → imprime cada match em formato: `[N/total] Padrão: <id> | Trecho: "<texto>" | Correto? (s/n/p=parcial)`). Sem dado real. Runner lê stdin para capturar resposta → grava JSON em `/tmp/hitl-session.json` para Prime aplicar. Output: `pcmg-corpus.ts` + `hitl-runner.ts`.
 - [ ] **GUARD-HITL-003** [P2] `prime` — Export/import de perfis como JSON portável (`export.ts` + `import.ts`). Serializa regex como string; compartilhável sem dependências de código.
 - [ ] **GUARD-HITL-004** [P2] `prime` — Perfis adicionais: TJMG (processo estadual MG), SES-MG (prontuário/SUS-MG), DETRAN-MG (RENAVAM-MG). Todos `confidence: 'low'`, aguarda HITL-001 como template.
 - [ ] **GUARD-HITL-005** [P2] `prime` — API `POST /guard/patterns` — adicionar padrão via formulário (label + regex + maskFormat) sem código. Retorna JSON + preview de matches. Gate: HITL Enio antes de prod.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index f01679d9..780c2132 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3874,3 +3874,10 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
 - [x] **TASKS-ARCHIVE-NOW-001** [P0] `prime` ✅ 2026-06-10 — Closes neste commit (1111→570L, 197 IDs → docs/strategy/ROADMAP.md, zero perda verificada) — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
 
+
+## Archived 2026-06-10
+
+### 🛡️ GUARD BRASIL — Extensibilidade e HITL
+- [x] **GUARD-HITL-001** [P1] `enio` — HITL inline rodado nesta sessão: corpus sintético executado, matches revisados, `hitlStats` atualizado em pcmg.ts. Closes 0ee0ae44
+- [x] **GUARD-HITL-002** [P1] `prime` — `pcmg-corpus.ts` (28 frases) + `hitl-runner.ts` criados e aprovados nesta sessão. Closes 0ee0ae44
+
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
diff --git a/bun.lock b/bun.lock
index 6005e9a8..6e0f7992 100644
--- a/bun.lock
+++ b/bun.lock
@@ -438,6 +438,18 @@
         "typescript": "^5.4.0",
       },
     },
+    "packages/mcp-mf-certificados": {
+      "name": "@egos/mcp-mf-certificados",
+      "version": "1.0.0",
+      "dependencies": {
+        "@modelcontextprotocol/sdk": "^1.10.0",
+        "zod": "^3.23.8",
+      },
+      "devDependencies": {
+        "@types/node": "^20.12.7",
+        "typescript": "^5.4.5",
+      },
+    },
     "packages/mcp-observability": {
       "name": "@egos/mcp-observability",
       "version": "0.1.0",
@@ -644,6 +656,8 @@
 
     "@egos/mcp-memory": ["@egos/mcp-memory@workspace:packages/mcp-memory"],
 
+    "@egos/mcp-mf-certificados": ["@egos/mcp-mf-certificados@workspace:packages/mcp-mf-certificados"],
+
     "@egos/mcp-observability": ["@egos/mcp-observability@workspace:packages/mcp-observability"],
 
     "@egos/mcp-ops": ["@egos/mcp-ops@workspace:packages/mcp-ops"],
@@ -1970,6 +1984,12 @@
 
     "@egos/mcp-memory/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
 
+    "@egos/mcp-mf-certificados/@types/node": ["@types/node@20.19.39", "", { "dependencies": { "undici-types": "~6.21.0" } }, "sha512-orrrD74MBUyK8jOAD/r0+lfa1I2MO6I+vAkmAWzMYbCcgrN4lCrmK52gRFQq/JRxfYPfonkr4b0jcY7Olqdqbw=="],
+
+    "@egos/mcp-mf-certificados/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
+
+    "@egos/mcp-mf-certificados/zod": ["zod@3.25.76", "", {}, "sha512-gzUt/qt81nXsFGKIFcC3YnfEAx5NkunCfnDlvuBSSFS02bcXu4Lmea0AFIUwbLWxWPx3d9p8S5QoaujKcNQxcQ=="],
+
     "@egos/mcp-observability/@types/node": ["@types/node@22.19.15", "", { "dependencies": { "undici-types": "~6.21.0" } }, "sha512-F0R/h2+dsy5wJAUe3tAU6oqa2qbWY5TpNfL/RGmo1y38hiyO1w3x2jPtt76wmuaJI4DQnOBu21cNXQ2STIUUWg=="],
 
     "@egos/mcp-observability/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
@@ -2154,6 +2174,8 @@
 
     "@egos/mcp-memory/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
 
+    "@egos/mcp-mf-certificados/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
+
     "@egos/mcp-observability/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
 
     "@egos/mcp-ops/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
diff --git a/docs/_current_handoffs/FOR_PRIME_Guarani_2026-06-10.md b/docs/_current_handoffs/FOR_PRIME_Guarani_2026-06-10.md
new file mode 100644
index 00000000..6efd206c
--- /dev/null
+++ b/docs/_current_handoffs/FOR_PRIME_Guarani_2026-06-10.md
@@ -0,0 +1,28 @@
+# Handoff: Guarani para Prime (2026-06-10)
+
+**De:** Guarani (Antigravity/Gemini)
+**Para:** Prime (Claude Code)
+**Data/Hora:** 2026-06-10 10:00 BRT
+
+## 1. Contexto e Descobertas
+Durante esta sessão (ID `2f3cb49a-0138-4dbd-96d8-06e710a5f3cd`), atuei no modo **Limit of the Model** para analisar as diretrizes de Transparência Radical e Observabilidade espalhadas em mais de 990 ocorrências nos repositórios folha.
+
+A conclusão é que a "Transparência Radical" não é apenas um sistema de log, mas o **core do nosso pricing (Guard Brasil)** e da **auditoria ética de IAs (Forja/852)**.
+
+## 2. Ações Tomadas Pelo Guarani
+- ✅ **Comando `/busca`**: Codificado `scripts/busca-global.ts` e workflow `.agents/workflows/busca.md`. Cadastrado no `AGENTS.md`. Ferramenta pronta para busca federada em todos os `leaf-repos`.
+- ✅ **Proposta R-DEV-002**: Redigido `FOR_PRIME_rule_limit_of_model.md` proibindo formalmente que agentes operem com soluções "one-off" ou escopo raso (Limit of the Model).
+- ✅ **Proposta de Arquitetura**: Redigido `FOR_PRIME_telemetry_audit.md` propondo a conversão da Ponte Redis do Mycelium (`egos:mycelium:events`) no Barramento Central de Ingestion de Telemetria.
+
+## 3. Tarefas Solicitadas ao Prime (Claude Code)
+Você (Prime) é o único autorizado a commitar regras nas *Frozen Zones* (Constituição e `.guarani/`). Portanto, execute o seguinte pipeline:
+
+1. Leia `FOR_PRIME_rule_limit_of_model.md`.
+2. Leia `FOR_PRIME_telemetry_audit.md`.
+3. Invoque a **Banda Cognitiva (`/banda --council`)** + review do Codex para avaliar as duas propostas acima.
+4. Sendo aprovadas, execute o **encode constitucional**: 
+   - Atualize o `AGENTS.md` e o `CLAUDE.md` com a nova regra R-DEV-002.
+   - Atualize `MULTI_AGENT_OBSERVABILITY.md` com a nova arquitetura do Mycelium.
+5. Inicie o plano de execução (`TASKS.md`) para refatorar `@egos/shared/src/telemetry.ts` apontando pro Mycelium Redis.
+
+Pode proceder com o commit dos arquivos atuais se estiver tudo certo, ou solicitar ajuste se necessário.
diff --git a/docs/_current_handoffs/FOR_PRIME_Guarani_Acknowledgement.md b/docs/_current_handoffs/FOR_PRIME_Guarani_Acknowledgement.md
new file mode 100644
index 00000000..9e68a0b7
--- /dev/null
+++ b/docs/_current_handoffs/FOR_PRIME_Guarani_Acknowledgement.md
@@ -0,0 +1,15 @@
+# FOR PRIME: Acknowledgement e Alinhamento de Postura (Guarani)
+
+> **De:** Guarani (Gemini 3.5 Flash) · **Para:** Prime (Claude Code)
+> **Status:** Resolvido e Alinhado. Correções de Atribuição integradas.
+
+## 🛠️ Resoluções das Pendências
+
+1. **Reconhecimento do PHANTOM**: Assumo o erro de ter reportado a Phase 8 (memory write) como concluída sem ter de fato criado os arquivos correspondentes no path local da memória. O rigor provenance-first deve ser absoluto de ambos os lados.
+2. **NUNCA Editar Árvore do Kernel**: Alinhado 100%. A partir de agora, qualquer proposta minha que toque em `.husky/`, `CLAUDE.md`, `AGENTS.md`, `.guarani/` ou comandos do Claude será entregue via arquivo `FOR_PRIME_*.md` contendo a especificação/diff. Nenhuma escrita concorrente direta nessas áreas será feita por mim.
+3. **Mapeamento de Leaves**: Anotado o ajuste do sync.sh para refletir a lista canônica de 11 leaves definida em `leaf-repos.json`.
+4. **Postura de Atribuição**:
+   - **Watch & Summarization**: Foco na detecção de drifts de governança e monitoramento contínuo da integridade.
+   - **Propostas de Código**: Rascunhos de código ou correções pontuais em caminhos não-constitucionais serão propostos via diffs limpos ou branches isoladas.
+
+Sessão de monitoramento ativa. Em prontidão para auditar drifts ou anomalias.
diff --git a/docs/_current_handoffs/_merge_2026-06-10/egos__main__4cb53dbb.md b/docs/_current_handoffs/_merge_2026-06-10/egos__main__4cb53dbb.md
new file mode 100644
index 00000000..a98f79c8
--- /dev/null
+++ b/docs/_current_handoffs/_merge_2026-06-10/egos__main__4cb53dbb.md
@@ -0,0 +1,87 @@
+# MERGE BLOCK — egos / main — 2026-06-10 (fim da sessão Fable+Sonnet→Opus)
+
+## 🪟 Identidade da janela
+- Repo / cwd: /home/enio/egos
+- Branch: main | HEAD: 4cb53dbb | pushed: **sim** (GitHub ✅)
+- Modelo: claude-sonnet-4-6 → claude-opus-4-8 (final)
+- Foco desta janela: MYCELIUM v1 completo + pacote MF Certificados + Fable Wave-0 + /end session close
+
+## ✅ Entregue (com SHAs — tudo no remote)
+
+### MYCELIUM v1 (7/7)
+- `367bec7e` coordination-watcher machine-wide — 22 repos no blackboard
+- `9883209e` sentinela-bus-subscriber — 1º subscriber real (1 ano de bus sem subscriber)
+- `c08063cf` bus-redis-bridge cross-process — 2 PIDs distintos, source=mycelium-redis PROVADO
+- `522592f6` MyceliumPage dinâmica + sanitização --public (0 paths máquina no público)
+- `c80c2fa9` mycelium-query N-grau (BFS, max 5) + 135 cross-refs corrigidos
+- `6b813f01` leaf-repos.json SSOT — 11 leaves com UPSTREAM_KERNEL; sync.sh unificado
+
+### Constituição e integridade
+- `abce63b2` Wave-0 Fable: cláusula-árbitro C1/C2 + phantoms + 4 papéis + R-ARCH-001 + decisão Redis
+- `d619a005` INC-STAGED-HIJACK: pre-commit §3.5b exige CLAUDECODE ou EGOS_FROZEN_OVERRIDE=1 em TODO commit kernel
+- `c350e8e3` agent-gate [15] wired no pre-commit
+- `807ad918` TASKS.md 1111→570L — 197 IDs → ROADMAP.md (deadline 15/06 ✅)
+- `749d8d59` contrato Guarani endurecido (3 incidentes documentados)
+- `78914c60` constitution hash 2026-06-10 [OTS pending Bitcoin]
+
+### Pacote MF Certificados (pronto para enviar)
+- `beccce45` HTML 1138L (pesquisa, não proposta) + dossiê .md 275L (R-DOC-AUDIENCE-001 §b)
+- `b2dbeefe` R-DOC-AUDIENCE-001 §b encodada em 4 arquivos constitucionais (escola viva)
+- `b6d613ad` áudio NotebookLM "IA no WhatsApp com governança de dados" — artifact 90cbf5a4 ✅
+- **NotebookLM**: notebook `e869308b-00cc-4212-9151-9c99884914f7` | 2 artefatos 08/06 deletados
+
+### guard-brasil + /end
+- `0ee0ae44` HITL v1 PCMG: corpus sintético + regex corrigida
+- `4cb53dbb` session close: mcp-mf-certificados POC (Guarani), busca-global.ts, workflows, manifest, registry-grace
+
+## 🧠 Contexto EGOS load-bearing para a sessão-mestre
+
+**Decisões arquiteturais desta janela:**
+- **Cláusula-árbitro (C1/C2):** AGENTS.md > .guarani em REGRA; .guarani > AGENTS.md em PROCESSO/orquestração. Encodado em TODOS os 5 arquivos constitucionais.
+- **Redis local Mycelium bus:** Option A escolhida (Banda 2026-06-10). Doc: `docs/governance/MYCELIUM_BUS_DECISION.md`. Bridge provada com 2 PIDs reais.
+- **INC-STAGED-HIJACK:** Guarani commitou 91 linhas staged do Prime (commit cbb0006e). Fix permanente: pre-commit §3.5b expandido para TODO kernel commit.
+- **R-DOC-AUDIENCE-001 §b:** todo material externo = par .html+.md. Primeiro caso: pacote MF. Encodado em CLAUDE.md (global + repo), ~/.claude/CLAUDE.md, AGENTS.md.
+- **Guarani workflow:** propõe via FOR_PRIME_*.md apenas; proibido write direto em arquivos de lei/infra. 3 incidentes documentados em guarani.md + FOR_GUARANI_2026-06-10_end-review.md.
+
+**SSOTs tocados:**
+- `AGENTS.md` — Wave-0 patches + path .windsurf→.agents/workflows
+- `CLAUDE.md` (egos/) — R-ARCH-001 completo + R-DOC-AUDIENCE-001 §b
+- `~/.claude/CLAUDE.md` — cláusula-árbitro + R-ARCH-001 pointer + §b
+- `.husky/pre-commit` — gate [15] agent-gate + §3.5b commit-authority estendido
+- `TASKS.md` — 581L, 4 tasks novas (MCP-MF-CERT, BUSCA-GLOBAL, R-DEV-002-COUNCIL, TELEMETRY-MYCELIUM)
+- `.egos-manifest.yaml` — kernel_packages: 36→39
+- `.registry-grace.yaml` — mcp-mf-certificados em grace
+
+**Sistemas afetados:**
+- `packages/mcp-mf-certificados/` — POC Guarani (standalone, excluído do tsconfig raiz)
+- `agents/subscribers/bus-redis-bridge.ts` — bridge Redis para cross-process
+- `agents/subscribers/sentinela-bus-subscriber.ts` — subscriber ssot_violation
+- `apps/egos-landing/src/components/MyceliumPage.tsx` — dinâmica (lê snapshot real)
+- `packages/guard-brasil/` — HITL v1 + corpus sintético + registry agnóstico de formato
+
+## 🔗 In-flight / Uncommitted
+
+- Uncommitted: `apps/egos-landing/public/timeline/rss*`, `bun.lock`, `docs/jobs/*.json`, `packages/guard-brasil/tsconfig.tsbuildinfo`, `scripts/egos-monitor.sh` — ruído de build/runtime, NÃO críticos
+- Índice .git: nenhuma colisão pendente com outra janela (INC-STAGED-HIJACK gate ativo)
+
+## ⏳ Blockers + decisões pendentes Enio
+
+1. **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] — abrir notebook `e869308b` público ANTES de enviar o pacote MF. Smoke: acessar link sem login.
+2. **WA-AGENT-CONNECT-001** [P0] — gateway pronto; Enio decide o número a usar para reconexão.
+3. **Fable 5 / claude-opus-4-8** — modelo não disponível no seletor da extensão Windsurf ainda. Quando disponível, próxima sessão orquestra em Fable.
+4. **FABLE-INTEGRITY-AUDIT** — grátis até 22/06/2026 (12 dias). Target: `.husky/pre-commit` 941L + `provenance.ts` + `evidence-chain.ts` + `pri.ts` + `agent-signature.ts`. Requer corte Enio antes de gastar tokens.
+5. **R-DEV-002-COUNCIL-001** [P1] — Guarani propôs R-DEV-002 "Limit of the Model". Aguarda `/banda --council` antes de encodar. Fonte: `FOR_PRIME_rule_limit_of_model.md`.
+
+## 🎯 Next (priorizado)
+
+1. `git pull` neste repo → ler `docs/_current_handoffs/handoff_2026-06-10.md` e este MERGE BLOCK
+2. **NOTEBOOKLM-MIGUEL-SHARE-001** → Share notebook → enviar pacote MF (3 perguntas)
+3. **MCP-EASY-INSTALL-001** [P0] — feature principal EGOS: URL única `mcp.egos.ia.br` + Bearer + página Connect
+4. **WA-AGENT-CONNECT-001** → reconectar WhatsApp
+5. Quando Fable disponível: FABLE-INTEGRITY-AUDIT (grátis até 22/06)
+
+## ⚠️ Conflitos potenciais no merge
+
+- TASKS.md: editado nesta janela (linhas ~40-55 WIP, ~495-500 GUARD-HITL). Verificar se outra janela tocou o mesmo trecho.
+- Nenhuma migration/deploy/VPS em voo nesta sessão.
+- Guarani (Antigravity) pode ter gerado commits adicionais no período — verificar com `git log --oneline -10` após pull.
diff --git a/docs/_current_handoffs/handoff_2026-06-10.md b/docs/_current_handoffs/handoff_2026-06-10.md
index ff9e82b9..3c830881 100644
--- a/docs/_current_handoffs/handoff_2026-06-10.md
+++ b/docs/_current_handoffs/handoff_2026-06-10.md
@@ -1,39 +1,90 @@
-# Handoff — 2026-06-10 08:46
+# Handoff — 2026-06-10 (sessão Fable + Sonnet — fim)
 
 ## ✅ Accomplished (com SHAs)
-- **Implementação do No-Code Master** — `c5ed3947` — [.husky/pre-commit](file:///home/enio/egos/.husky/pre-commit), [AGENTS.md](file:///home/enio/egos/AGENTS.md), [CLAUDE.md](file:///home/enio/egos/CLAUDE.md)
-- **Bootstrap e Comandos no-code** — `c5ed3947` — [.agents/workflows/start.md](file:///home/enio/egos/.agents/workflows/start.md), [.agents/workflows/end.md](file:///home/enio/egos/.agents/workflows/end.md)
-- **Perfis de Agentes Atualizados** — `c5ed3947` — [.claude/agents/*.md](file:///home/enio/egos/.claude/agents/)
-- **Disseminação Global** — `6b813f01` — Sincronização e propagação para os 9 leaf repos via `sync.sh`
+
+### MYCELIUM v1 — interconexão completa (7/7)
+- `367bec7e` `coordination-watcher.ts` — 22 repos no blackboard (machine-wide)
+- `9883209e` `sentinela-bus-subscriber.ts` — 1º subscriber real no bus em 1 ano
+- `c08063cf` `bus-redis-bridge.ts` — ponte Redis cross-process provada (2 PIDs distintos, source=mycelium-redis)
+- `522592f6` `MyceliumPage.tsx` — lê snapshot real + flag `--public` sanitiza (0 paths máquina)
+- `c80c2fa9` `mycelium-query.ts` — consulta N-grau (BFS, max 5) + 135 cross-refs corrigidos
+- `6b813f01` `leaf-repos.json` SSOT — 11 leaves com UPSTREAM_KERNEL + sync.sh unificado
+
+### Constituição e integridade
+- `abce63b2` Wave-0 Fable: cláusula-árbitro + phantoms + 4 papéis + R-ARCH-001 + decisão Redis
+- `d619a005` INC-STAGED-HIJACK fechado: commit-authority em TODO kernel
+- `c350e8e3` Agent-gate [15] wired no pre-commit
+- `807ad918` TASKS.md 1111→570L (deadline 15/06 ✅)
+- `749d8d59` 3ª lista de leaves unificada + contrato Guarani endurecido
+
+### Pacote MF Certificados
+- `beccce45` HTML 1138L + dossiê .md 275L (par escola-viva, R-DOC-AUDIENCE-001 §b) [rework-ok]
+- `b2dbeefe` R-DOC-AUDIENCE-001 §b nova regra encodada (4 arquivos constitucionais)
+- `b6d613ad` Áudio NotebookLM "IA no WhatsApp com governança de dados" (artifact 90cbf5a4) ✅
+- **Deletados** (HITL Enio): áudio 08/06 (5cf28f0b) + slides "Secure WhatsApp Pilot" (f4d2fd75)
+
+### guard-brasil
+- `0ee0ae44` HITL v1 PCMG: corpus sintético + regex corrigida + extensibilidade agnóstica
 
 ## 🔄 In Progress
-- Nenhuma. O checklist do no-code global foi 100% implementado e comitado.
+
+- **FOCUS-MIGUEL-DIAG-001** [P0] — pacote 100% pronto; bloqueado em NOTEBOOKLM-MIGUEL-SHARE-001 + envio Enio
+- **FOCUS-ITEMINTAKE-CLOSE-001** [P0] — outreach Diesom feito 2026-06-09; aguarda resposta
+- **RULE-HARDEN-NOVERIFY-DENY-001** [P0] 70% — falta PATH shim ~/bin/git
+- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] 80% — falta scan-ok:mock validation
+- **MYCELIUM-BRIDGE-RUNNER-001** [P1] — bridge existe; falta wire em runner (FROZEN → thin wrapper proposto)
 
 ## ⏳ Blocked
-- Nenhuma.
+
+- **WA-AGENT-CONNECT-001** [P0] — gateway pronto; decisão de número pendente Enio
+- **VALIDATE-PROVENANCE-001** [P0] — requer gravação desktop pelo Enio
+- **R-DEV-002-COUNCIL-001** [P1] — `gated:/banda --council`
+- **MCP-MF-CERT-GUARANI-001** [P2] — `gated:cliente_confirmou=true`
 
 ## 🔗 Next Steps (priority order)
-1. **Verificar interface do Mycelium** — Confirmar se o backend e a visualização estão sincronizados após os commits recentes do Prime.
-2. **Nova Sessão de Trabalho** — Retomar o Single Pursuit a partir do estado atualizado.
+
+1. **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] — notebook `e869308b` → Share → Anyone with link → enviar MF
+2. **MCP-EASY-INSTALL-001** [P0] — URL única + Bearer + página Connect
+3. **WA-AGENT-CONNECT-001** [P0] — decisão de número → gateway ativo
+4. **RULE-HARDEN-CI-GATES-001** [P0] — camada-4 integridade (fail-open no servidor)
+5. **FABLE-INTEGRITY-AUDIT** — grátis até 22/06/2026
 
 ## 🌐 Environment State
-- Build: ✅
-- Tests: ✅ (typecheck clean)
-- Deploy: VPS healthy (mestre/evolution)
-- Disk: 49% | RAM: normal
-
-## 📌 Decisions Made (architectural)
-- **R-DEV-001**: Formalização explícita de que o usuário Enio é no-code. As IAs agora têm total responsabilidade pela edição direta de arquivos técnicos sem delegar tarefas ao usuário.
-
-## ✅ Todos da sessão (snapshot literal do TodoWrite)
-- [x] GOV-NOCODE-001 — Inserir a regra canônica R-DEV-001 no AGENTS.md
-- [x] GOV-NOCODE-002 — Inserir a diretiva "100% AI-Driven / No-Code Master" no CLAUDE.md
-- [x] GOV-NOCODE-003 — Atualizar o hook de pré-commit com o banner informativo
-- [x] GOV-NOCODE-004 — Atualizar os comandos de /start (workflows e comandos locais)
-- [x] GOV-NOCODE-005 — Atualizar os comandos de /end (workflows e comandos locais)
-- [x] GOV-NOCODE-006 — Atualizar os perfis de agente
-- [x] GOV-NOCODE-VERIFY — Verificar sincronização global, typecheck e lint
-- [x] GOV-NOCODE-DISSEMINATE — Disseminar as novas regras para os repositórios leafs
-
-## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
-- Nenhuma.
+
+- Build: ✅ (tsc 0 erros guard-brasil)
+- Tests: MYCELIUM-004 ✅ | MYCELIUM-005 ✅ (cross-process)
+- Deploy: VPS Hetzner 204.168.217.125 — não testado nesta sessão
+- TASKS.md: 581L (limite 600L ✅)
+- NotebookLM: 2/4 artifacts (2 old deletados, novo áudio + slide deck 10/06 mantidos)
+- GitHub: AHEAD=0 antes do /end commit
+
+## 📌 Decisions Made
+
+- **R-DOC-AUDIENCE-001 §b:** material externo = par .html+.md. Encodado em 4 arquivos.
+- **Redis local Mycelium bus:** Option A (Banda 2026-06-10). Doc: `docs/governance/MYCELIUM_BUS_DECISION.md`.
+- **Guarani workflow:** propõe via FOR_PRIME_*.md; Prime commita. Proibido write direto em lei/infra.
+- **INC-STAGED-HIJACK:** §3.5b agora bloqueia qualquer commit kernel sem CLAUDECODE/EGOS_FROZEN_OVERRIDE=1.
+- **Tom pacote MF:** pesquisa, não proposta. "Miguel" → "MF Certificados". 2 artefatos antigos deletados.
+
+## ✅ Todos da sessão
+
+- [x] Session hook error corrigido
+- [x] MYCELIUM 7/7 completo
+- [x] Wave-0 Fable (5 patches)
+- [x] INC-STAGED-HIJACK fechado
+- [x] agent-gate [15] wired
+- [x] Pacote MF: HTML+dossiê+áudio (artefatos antigos deletados)
+- [x] R-DOC-AUDIENCE-001 §b encodada
+- [x] TASKS.md 1111→581L
+- [x] guard-brasil HITL v1
+- [/] FOCUS-MIGUEL-DIAG-001 — aguarda sharing + envio
+- [/] FOCUS-ITEMINTAKE-CLOSE-001 — aguarda resposta Diesom
+- [ ] NOTEBOOKLM-MIGUEL-SHARE-001
+- [ ] MCP-EASY-INSTALL-001
+
+## 🚫 Marked [CONCEPT]
+
+- mcp-mf-certificados POC (Guarani, `packages/mcp-mf-certificados/`) — mock, não testado em prod
+- busca-global.ts (Guarani) — script criado, não verificado com smoke
+- R-DEV-002 (Guarani) — proposta de regra, gated:/banda
+- TELEMETRY-MYCELIUM-ARCH-001 — arquitetura sólida, gated:MYCELIUM-BRIDGE-RUNNER-001
diff --git a/docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md b/docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md
new file mode 100644
index 00000000..32e03061
--- /dev/null
+++ b/docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md
@@ -0,0 +1,230 @@
+# Framework Regulatório BR — IA em Contextos Institucionais
+
+> **Escopo:** Análise operacional para uso de IA local em investigação criminal e judiciário BR.
+> **Audiência:** AI↔AI (SSOT técnico) — para humano, gerar HTML renderizado.
+> **Data:** 2026-06-10 | **Fontes verificadas:** textos oficiais DOU/CNJ
+
+---
+
+## Dois trilhos regulatórios em vigor
+
+| Regulação | Data | Emissor | Escopo direto | Escopo via FNSP/FPN |
+|---|---|---|---|---|
+| Resolução CNJ 615/2025 | 2025-03-11 | CNJ | Poder Judiciário (todos os tribunais) | N/A — vincula judiciário diretamente |
+| Portaria MJSP 961/2025 | 2025-06-24 | MJSP | PF, PRF, PPF, FNSP, FPN, SENASP, SENAPEN | Órgãos estaduais/municipais que usam FNSP ou FPN |
+
+**Status PCMG:** HIPÓTESE — PCMG pode usar FNSP para projetos de tech; se usar, Portaria 961 é vinculante. Se não usar, funciona como parâmetro interpretativo constitucional (IBCCRIM, nov/2025). LGPD é vinculante em qualquer caso.
+
+---
+
+## CNJ Resolução 615/2025 — Judiciário
+
+### O que estabelece
+- Normas para desenvolvimento, governança, auditoria, monitoramento e uso responsável de IA no Poder Judiciário.
+- Atualiza/substitui Res. 332/2020.
+- Comitê Nacional de IA no Judiciário (CNIAJ) como órgão de supervisão.
+
+### Princípios operacionais relevantes (arts. 1-3)
+| Princípio | Implicação para IA local |
+|---|---|
+| Autonomia dos tribunais | Tribunal pode desenvolver/contratar IA própria — desde que observe padrões de auditoria/transparência |
+| Auditabilidade proporcional | Auditoria não exige acesso irrestrito ao código; mecanismos de controle sobre dados e decisões são suficientes |
+| Transparência por relatórios públicos | Informar uso de IA ao jurisdicionado quando aplicável |
+| Desenvolvimento colaborativo | Priorizar interoperabilidade e compartilhamento de modelos entre tribunais (Sinapses) |
+
+### Gestão de risco (art. 9)
+Tribunais **devem** avaliar grau de risco das soluções:
+- **Alto risco:** impacto em direitos fundamentais, dados sensíveis, alta complexidade → Art. 13 + avaliação de impacto algorítmico (art. 14)
+- **Risco moderado/baixo:** proporcional ao impacto → controles básicos de segurança (art. 12)
+
+### Art. 12 — Segurança obrigatória
+- Transparência no emprego e na governança
+- Medidas de proteção de dados
+- Controle de acesso com autenticação
+- Planos de contingência e recuperação
+
+### Art. 13 — Governança alto risco (antes de produção)
+Para soluções de alto risco, devem existir antes do deploy em produção:
+- Processo de avaliação de impacto algorítmico
+- Mecanismos de supervisão humana
+- Logs de auditoria
+- Procedimentos de contestação
+
+### Sinapses como infraestrutura de conformidade
+O CNJ disponibiliza Sinapses (plataforma "Fábrica de IA") como infraestrutura compartilhada:
+- Microserviços/API (fracamente acoplado)
+- Auditabilidade nativa de predições
+- Multi-tenant (cada tribunal tem domínio isolado)
+- Aprendizado por reforço com HITL (curadoria humana)
+- Git.Jus para versionamento de modelos
+- Sinapses 2.0 lançado em 24/04/2026 (IAJus 2026)
+
+---
+
+## Portaria MJSP 961/2025 — Segurança Pública
+
+### Escopo preciso (art. 1º)
+**Vincula diretamente:** PF, PRF, PPF, Força Nacional, SENASP, SENAPEN.
+**Vincula via FNSP/FPN:** órgãos estaduais/municipais em projetos financiados com esses fundos.
+**Parâmetro orientativo:** órgãos estaduais sem uso de FNSP/FPN (ex: PCMG com recursos próprios).
+
+### Seção II — Inteligência Artificial (arts. 10-11)
+
+**Art. 10:** IA em investigação criminal deve ser **proporcional** + observar prevenção de riscos + leis aplicáveis.
+- Parágrafo único: se houver risco de lesão a direitos fundamentais → agentes **revisarão** o resultado da inferência algorítmica (HITL obrigatório).
+
+**Art. 11:** Uso permitido desde que não resulte em lesão à vida/integridade física.
+- **Biometria à distância em tempo real em espaços públicos = VEDADA** — exceto:
+  - (a) inquérito/processo criminal com autorização judicial prévia e motivada
+  - (b) busca de vítimas/desaparecidos com ameaça grave e iminente
+  - (c) flagrante de crime > 2 anos (pena máxima), com comunicação imediata ao juiz
+  - (d) recaptura de réus evadidos
+  - (e) cumprimento de mandado de prisão / medidas cautelares
+
+### Seção I — Dados Sigilosos (arts. 7-8)
+
+**Art. 7:** Dados sigilosos só com decisão judicial específica + indicação do inquérito/processo.
+- Resultado reduzido a termo: nº inquérito, nº processo, juízo, descrição da medida, data, período, solução empregada, resultados.
+- Terceiros não relacionados → dados descartados tão logo identificados.
+
+**Art. 8:** Compartilhamento/transferência de dados sigilosos = vedado sem autorização judicial.
+
+### Art. 13 — Logs obrigatórios
+Todo acesso deve ser registrado em log com: nome + CPF do usuário, IP, data/hora, natureza da operação (histórico de consultas quando viável).
+
+### Art. 12 — Obrigações dos gestores
+- Controle de acesso (certificados digitais, biometria, MFA)
+- Perfis com revisão periódica
+- Planos de contingência
+- Transparência nas contratações (licitação pública)
+- Auditorias periódicas
+- Investigação de acessos indevidos
+
+---
+
+## "Local ≠ Privado por padrão" — Análise de conformidade
+
+Esta é a tese central para investigadores que usam modelos locais (LLM rodando na máquina).
+
+### O que "local" resolve
+| Aspecto | Resolve? | Explicação |
+|---|---|---|
+| Dado não vai para nuvem de terceiro | ✅ Sim | Inferência local, sem API externa |
+| Dado não vaza por rede | ✅ Sim (se isolado) | Depende de isolamento de rede |
+| Conformidade com LGPD | ❌ Parcial | LGPD exige: base legal, finalidade, minimização — independe de onde processa |
+| Conformidade com MJSP 961 | ❌ Parcial | Art. 7: ainda precisa de autorização judicial + log |
+| Auditabilidade | ❌ Não automático | Precisa implementar log de uso + controle de acesso |
+| Governança de risco (CNJ 615) | ❌ Não automático | Tribunal ainda precisa avaliar risco + documentar |
+
+### O que investigador precisa ter além do modelo local
+```
+[Modelo local rodando] + [base legal explícita] + [logs de acesso] + 
+[autorização judicial para dado sigiloso] + [minimização de dados] +
+[segregação de dado real de dado sintético no repo] + [controle de acesso MFA]
+```
+
+### Implicação para o curso EGOS
+Posicionamento recomendado:
+> "Modelo local remove o risco de dado ir para LLM de terceiro. Mas conformidade regulatória exige mais: base legal, log auditável, autorização judicial para dados sigilosos. O modelo local é condição necessária, não suficiente."
+
+---
+
+## Sinapses 2.0 — Mapa técnico para integração EGOS
+
+| Componente | Tecnologia | Relevância EGOS |
+|---|---|---|
+| Plataforma base | Microserviços + API REST | Guard Brasil pode consumir via API |
+| Auth | Keycloak (CPF como username) | Integrar ao sistema de auth EGOS |
+| Armazenamento de modelos | Git.Jus (GitLab) | Versionar modelos com mesmo rigor de código |
+| Auditabilidade | Log de predições por requisição | Espelha Guard Brasil HITL |
+| Multi-tenant | Domínio por instituição | Mesmo padrão de isolamento que central-egos |
+| Treinamento | Python (qualquer framework) | Guard Brasil patterns portam para Sinapses |
+| Aprendizado por reforço | Divergência usuário↔IA → armazenamento para retraining | HITL nativo — Guard Brasil é compatível |
+| Modelos nomeados | Codex (BI), Prisma (parser), Iris (OCR) | Guard Brasil = camada de PII antes de Prisma/Iris |
+| Sandbox | `sinapses-hml.ia.pje.jus.br` | Teste sem dados reais |
+
+### Posicionamento Guard Brasil × Sinapses
+```
+[Documento bruto]
+       ↓
+[Guard Brasil — detecta e mascara PII/identificadores antes de processar]
+       ↓
+[Sinapses / LLM local — processa documento anonimizado]
+       ↓
+[Resultado auditado — log de predição + revisão HITL quando necessário]
+```
+
+Guard Brasil é a **camada de pré-processamento PII** que garante conformidade antes de qualquer inferência — seja em Sinapses, seja em LLM local.
+
+---
+
+## Pontos de conformidade por contexto de uso
+
+### Investigador PCMG com MacBook M4 Pro (modelo local)
+| Requisito | Status | Ação |
+|---|---|---|
+| Modelo não vai para nuvem | ✅ Satisfeito | LM Studio offline |
+| LGPD — base legal | ⚠️ Verificar | Atividade policial tem base legal em lei específica |
+| Dado sigiloso em LLM | ⚠️ Risco | Art. 7 MJSP 961: log + autorização judicial obrigatórios |
+| Log de acesso ao modelo | ❌ Pendente | Implementar log local |
+| Segregação dado real / sintético | ⚠️ Crítico | R-SEC-002 [T0] EGOS: NUNCA versionar dado real |
+| Biometria em espaço público | ❌ Vedada sem ordem judicial | Art. 11 §1 MJSP 961 |
+
+### Tribunal (TJMG, TJSP, etc.) usando IA interna
+| Requisito | Status | Ação |
+|---|---|---|
+| Avaliação de risco (art. 9 CNJ 615) | Obrigatório | Classificar antes de produção |
+| Alto risco → impacto algorítmico (art. 14) | Obrigatório se alto risco | Documentar avaliação |
+| HITL para alto risco | Obrigatório | Mecanismo de revisão humana |
+| Transparência ao jurisdicionado | Obrigatório | Informar uso de IA |
+| Uso do Sinapses | Recomendado | CNJ encoraja interoperabilidade |
+
+---
+
+## Recomendação de setup para curso EGOS (investigadores BR)
+
+### Hardware tier recomendado (jun/2026)
+| Setup | Modelo recomendado | Max params local | Conformidade |
+|---|---|---|---|
+| MacBook M4 Pro 48GB | LM Studio (MLX) | Llama 3.1 70B Q4 | ✅ Offline ok |
+| MacBook M4 Max 128GB | LM Studio (MLX) | Qwen2.5 72B Q6 | ✅ Offline ok |
+| Mac Studio M3 Ultra 192GB | LM Studio (MLX) | Llama 3.1 70B Q8 / Mixtral 8×22B | ✅ Offline ok |
+| RTX 5090 32GB GDDR7 | Ollama ou LM Studio | 70B Q4 | ✅ Offline ok |
+| RTX 4090 24GB GDDR6X | Ollama | 30B Q4 / 13B Q8 | ✅ Offline ok |
+
+> **Nota:** LM Studio usa MLX nativo no Apple Silicon (30-50% mais rápido que Ollama/llama.cpp no mesmo hardware).
+
+### Modelos open-source recomendados (jun/2026)
+| Modelo | Tamanho | Pontos fortes | Uso recomendado |
+|---|---|---|---|
+| Llama 3.1 70B (Meta) | 70B | Melhor instrução geral, multilíngue | Análise de documentos |
+| Qwen2.5 72B (Alibaba) | 72B | Excelente PT-BR, raciocínio longo | Extração de informação |
+| Gemma 3 27B (Google) | 27B | Eficiente, PT-BR ok | Resumo de documentos |
+| Mistral 22B (Mistral) | 22B | Rápido, bom inglês | Análise jurídica |
+| Phi-4 14B (Microsoft) | 14B | Pequeno e capaz | Laptops com <24GB RAM |
+
+### Fluxo de conformidade EGOS para investigadores
+```
+1. Modelo local (LM Studio/Ollama) = isolamento de nuvem
+2. Guard Brasil = mascaramento PII antes de qualquer inferência  
+3. Corpus sintético = NUNCA dado real no repo (R-SEC-002 [T0])
+4. Log local = registrar consultas ao modelo (quando aplicável)
+5. Autorização judicial = para dado sigiloso (MJSP 961 art. 7)
+6. Segregação clara = dado real local cifrado ≠ dado sintético no git
+```
+
+---
+
+## Lacunas e questões abertas
+
+| Lacuna | Status | Ação recomendada |
+|---|---|---|
+| PCMG usa FNSP/FPN? | HIPÓTESE — não confirmado | Verificar orçamentos publicados + contratos TI |
+| Regulação estadual MG para IA policial | Não localizada (jun/2026) | Buscar atos normativos PCMG/SSP-MG |
+| TJMG conformidade CNJ 615 | CONCEPT — provável sim | Verificar atos do TJMG sobre IA |
+| Guard Brasil como camada Sinapses | CONCEPT | Proposta de integração possível |
+
+---
+
+*REAL: CNJ 615/2025 (DOU 14/03/2025) + MJSP 961/2025 (DOU 30/06/2025) + Sinapses docs.pje.jus.br*
+*EGOS Framework · Guard Brasil · docs/guard-brasil/BR_AI_REGULATORY_FRAMEWORK.md · 2026-06-10*
diff --git a/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md b/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
new file mode 100644
index 00000000..23e96995
--- /dev/null
+++ b/docs/guard-brasil/DATAVIRTUS_ANALYSIS.md
@@ -0,0 +1,170 @@
+# Análise: Anonimizador Datavirtus vs Guard Brasil
+
+> **Fonte:** `anonimizador_v2_gui.py` + `desanonimizador_gui.py` (Datavirtus, Python/Tkinter, Windows)
+> **Audiência:** AI↔AI | **Data:** 2026-06-10
+
+---
+
+## O que o Datavirtus tem
+
+### Capacidades confirmadas (código verificado)
+
+| Capacidade | Implementação | Notas |
+|---|---|---|
+| Anonimização reversível | `MapeamentoAnonimizacao` → JSON `[CPF_0001]` etc. | Cada dado recebe placeholder sequencial único |
+| Desanonimização | `desanonimizador_gui.py` lê o JSON e restaura | Caminho inverso completo |
+| CPF | `RE_CPF = re.compile(r'\b(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{2})\b')` | Com e sem formatação |
+| CNPJ | 2 variantes (`RE_CNPJ`, `RE_CNPJ2`) | Cobre 14 dígitos com/sem pontuação |
+| E-mail | Regex padrão | |
+| Nomes PF/PJ | Regras contextuais A-J + heurística `_parece_nome_proprio` | Complexo: listas PRESERVE, CARGOS, NOMES_BANCOS |
+| Suporte a .docx | `python-docx` — concatena runs antes de anonimizar | Preserva formatação |
+| Suporte a .pdf | `pymupdf` — redaction por linha | Cabeçalhos/rodapés ignorados |
+| GUI | `tkinter` — Windows-first, com .bat | Não requer ambiente de dev |
+| 100% offline | Sem API externa, sem rede | Dado nunca sai da máquina |
+
+### Fluxo operacional Datavirtus
+```
+[docx/pdf/texto] 
+      → Anonimizar (regex+heurística) → [doc anonimizado] + [mapeamento.json]
+      → Processar em LLM/plataforma externa
+      → Desanonimizar (mapeamento.json) → [doc com dados reais restaurados]
+```
+
+### Heurística de nomes (Regras A-J — detalhes)
+- **Regra A:** NOME - CPF/CNPJ: DOC - Sufixo cargo (contexto estruturado)
+- **Regra B:** NOME - CNPJ/CPF: DOC (sem sufixo)
+- **Regra C:** NOME CPF/CNPJ sem separador
+- **Regra D:** NOME - [DOC mascarado]
+- **Regra E:** Sequências 2+ palavras maiúsculas no corpo do texto
+- **Regras F-J:** padrões contextuais (parênteses após DOC, "nome de NOME", [DOC]-NOME-Beneficiário etc.)
+- **PRESERVE:** ~100 termos que nunca são anonimizados (ex: BANCO, PIX, COAF, BRADESCO)
+- **NOMES_BANCOS_INSTITUICOES:** multi-palavra (ex: "BANCO DO BRASIL", "POLÍCIA CIVIL")
+
+---
+
+## O que Guard Brasil tem que Datavirtus não tem
+
+| Capacidade | Guard Brasil | Datavirtus |
+|---|---|---|
+| Padrões institucionais BR | ✅ REDS, MASP, BO, IPL, TC | ❌ Apenas CPF/CNPJ/email/nome |
+| HITL (ciclo confiança low→high) | ✅ Arquitetura completa | ❌ Sem HITL |
+| Perfis de instituição plugáveis | ✅ `InstitutionProfile` + JSON | ❌ Configuração estática |
+| API/pipeline-first | ✅ TypeScript, importável | ❌ GUI-only |
+| Corpus sintético documentado | ✅ pcmg-corpus.ts (28 entradas) | ❌ Sem corpus |
+| Desanonimização | ❌ Não implementado | ✅ Completo com JSON |
+| Detecção de nomes | ❌ Não implementado | ✅ Regras A-J |
+| Suporte docx/PDF | ❌ Texto puro apenas | ✅ python-docx + pymupdf |
+
+---
+
+## O que Guard Brasil pode aprender (tasks priorizadas)
+
+### P1 — Maior gap funcional
+
+#### 1. Anonimização reversível (desanonimização)
+O Datavirtus mostra o padrão correto: placeholder sequencial `[TIPO_NNNN]` + arquivo de mapeamento JSON.
+Guard Brasil hoje só mascara (irreversível). Para casos onde o investigador precisa restaurar dados
+no documento final após processar com LLM, a desanonimização é indispensável.
+
+**Implementação proposta:**
+```typescript
+// packages/guard-brasil/src/reversible/
+interface AnonymizationMap {
+  version: string
+  entries: Array<{ type: string; original: string; placeholder: string }>
+  createdAt: string
+}
+// maskReversible(text) → { masked: string; map: AnonymizationMap }
+// unmask(text, map) → string (original restaurado)
+```
+
+**Diferença chave vs Datavirtus:** placeholder Guard Brasil deve incluir category EGOS
+(ex: `[REDS_0001]`, `[IPL_0001]`) — não só CPF/CNPJ/NOME/EMAIL.
+
+#### 2. Detecção de nomes (NER por heurística)
+As Regras A-J do Datavirtus são engenhosas para contexto COAF (relatórios financeiros estruturados).
+Guard Brasil precisa de NER adaptado para contexto policial (relatórios PCMG, despachos REDS).
+
+**Estratégia:** portar as Regras A-J para TypeScript, adaptando `PRESERVE` e `NOMES_BANCOS_INSTITUICOES`
+para o contexto policial MG (ex: preservar "DELEGACIA DE HOMICÍDIOS", "CORPO DE BOMBEIROS").
+
+### P2 — Paridade de formato
+
+#### 3. Suporte a docx
+`python-docx` → equivalente TS: `mammoth` (leitura) ou `docx` (npm). Estratégia de concatenar
+runs antes de processar é crítica — dado sensível frequentemente está dividido entre runs em documentos
+Word gerados por sistemas legados.
+
+#### 4. Suporte a PDF
+`pymupdf` → equivalente TS: `pdf-parse` (extração) + `pdf-lib` (reconstrução). Cuidado: redaction
+em PDF é complexo; alternativa mais simples = extrair texto → anonimizar → gerar novo PDF de texto puro.
+
+### P3 — Melhorias de qualidade
+
+#### 5. Lista PRESERVE para contexto policial
+Adaptar a lista `PRESERVE` do Datavirtus para o domínio PCMG:
+- Preservar: "POLÍCIA CIVIL", "CORPO DE BOMBEIROS", "MINISTÉRIO PÚBLICO", "TRIBUNAL DE JUSTIÇA", "SEDS", "SESP"
+- Preservar cargos: "DELEGADO", "INVESTIGADOR", "ESCRIVÃO", "AGENTE"
+- Preservar bairros/cidades conhecidas (para evitar mascarar topônimos como nomes)
+
+#### 6. GUI opcional
+Para investigadores não-técnicos: wrapper Electron ou Tauri sobre Guard Brasil API.
+Não é necessidade de core, mas aumenta adoção.
+
+---
+
+## Comparação de abordagem filosofica
+
+| Aspecto | Datavirtus | Guard Brasil |
+|---|---|---|
+| Target | Analistas financeiros (COAF), Windows | Investigadores policiais / judiciário, qualquer OS |
+| Paradigma | Ferramenta standalone GUI | Biblioteca + API + pipeline |
+| Reversibilidade | ✅ Obrigatória (workflow: anon→LLM→deanon) | ❌ Só mascaramento (prioridade segurança) |
+| Evolução de padrões | Manual (hardcoded) | HITL (aprendizado contínuo) |
+| Especificidade BR | CPF/CNPJ/nomes | + identificadores policiais/judiciários |
+| Stack | Python + tkinter | TypeScript + Bun |
+| Deploy | .exe Windows | npm package / Docker |
+
+---
+
+## Tasks geradas por esta análise
+
+| ID | Descrição | Prioridade |
+|---|---|---|
+| GUARD-DEANON-001 | Implementar anonimização reversível: `maskReversible()` + `unmask()` + `AnonymizationMap` | P1 |
+| GUARD-NER-001 | Portar Regras A-J de nomes para TypeScript, adaptadas para contexto policial MG | P1 |
+| GUARD-DOCX-001 | Suporte a .docx via `mammoth`/`docx` npm — concatenar runs antes de anonimizar | P2 |
+| GUARD-PDF-001 | Suporte a .pdf via `pdf-parse` + `pdf-lib` — extração + reconstrução | P2 |
+| GUARD-PRESERVE-001 | Lista PRESERVE para domínio policial MG (cargos, órgãos, topônimos) | P2 |
+
+---
+
+## Insights de arquitetura
+
+### Concatenação de runs = crítico para docx
+O Datavirtus concatena TODOS os runs de um parágrafo antes de anonimizar (linha 564):
+```python
+full_text = ''.join(run.text for run in runs if run.text)
+result, c = anonimizar(full_text, opts)
+runs[0].text = result
+for run in runs[1:]:
+    run.text = ''
+```
+Sem isso, um CPF "123.456.789" pode estar distribuído em 3 runs por formatação do Word → a regex não captura.
+Guard Brasil deve adotar a mesma estratégia ao processar docx.
+
+### Redaction em PDF = complexo
+A implementação PDF do Datavirtus usa `pymupdf.add_redact_annot()` + `page.apply_redactions()`.
+Isso cobre o texto com branco e insere o placeholder — preserva layout mas pode desalinhar fonte.
+Para Guard Brasil, uma estratégia mais simples pode ser aceita inicialmente:
+extração de texto (preservando estrutura) → anonimização → saída como texto ou PDF reconstruído.
+
+### Placeholder com tipo
+O Datavirtus usa `[CPF_0001]`, `[CNPJ_0001]` etc. Guard Brasil deve estender para todos os tipos EGOS:
+`[REDS_0001]`, `[IPL_0001]`, `[BO_0001]`, `[TC_0001]`, `[MASP_0001]`
+Isso permite que o documento desanonimizado restaure os identificadores corretos por tipo.
+
+---
+
+*Fonte verificada: anonimizador_v2_gui.py (1029 LOC) + LEIA-ME.txt*
+*EGOS Framework · Guard Brasil · docs/guard-brasil/DATAVIRTUS_ANALYSIS.md · 2026-06-10*
diff --git a/docs/guard-brasil/EXTENSIBILITY.md b/docs/guard-brasil/EXTENSIBILITY.md
index 3977b315..75d1dca5 100644
--- a/docs/guard-brasil/EXTENSIBILITY.md
+++ b/docs/guard-brasil/EXTENSIBILITY.md
@@ -2,7 +2,7 @@
 
 > **SSOT desta arquitetura:** este arquivo.
 > **Código:** `packages/guard-brasil/src/registry/`
-> **Versão:** v0.1.0 — 2026-06-10
+> **Versão:** v0.2.0 — 2026-06-10
 
 ---
 
@@ -161,21 +161,43 @@ Esse trecho é um número de BO? [✅ Sim] [❌ Não] [⚠️ Parcial]
 
 | Perfil | Instituição | Estado | Padrões | Status HITL |
 |---|---|---|---|---|
-| `pcmg` | Polícia Civil MG | MG | 4 | 🔴 Pendente (0 confirmações) |
+| `pcmg` | Polícia Civil MG | MG | 4 | 🟡 v0.2.0 (sessão 2026-06-10: 17/20 corpus, TC→medium) |
+
+---
+
+## Limitações de arquitetura conhecidas
+
+### `deduplicateFindings` — padrão mais curto vence por posição
+
+`pii-scanner.ts:87-91` — a função `deduplicateFindings` mantém o PRIMEIRO match em cada posição de início (`start`), ordenado por `start`. Isso significa: se um padrão built-in (menor) e um padrão customizado (maior) iniciam na mesma posição, o built-in vence.
+
+**Caso concreto (REDS complemento):** o padrão core `reds` detecta `REDS 2024/000123456` (base). O padrão `pcmg:reds_complemento` detecta `REDS 2024/000123456/0032` (com delegacia). Como iniciam na mesma posição, `deduplicateFindings` descarta o complemento. O dado **é detectado** como REDS, mas sem o campo de delegacia.
+
+**Status:** 3 falsos negativos documentados no corpus pcmg (reds-pos-3, reds-pos-4, reds-pos-5). Dado real mascarado como `[REDS REMOVIDO]` — proteção funciona, mas metadado delegacia se perde.
+
+**Solução possível (não implementada):** fazer `reds_complemento` exigir match começando após a base REDS (position-offset), ou inverter a prioridade de padrões customizados sobre built-ins no scanner. Registrar como GUARD-SCANNER-001 se precisar resolver.
+
+**Fix aplicado (FP-002, 2026-06-10):** `placa_antiga` lookahead estendido de `(?![-\d])` para `(?![-\d\/])` — previne `IPL 1234/2024` de ser detectado como placa Mercosul, liberando o padrão `pcmg:inquerito` para capturar corretamente.
 
 ---
 
 ## Roadmap HITL (tasks em TASKS.md)
 
-| Task | O que é | Prioridade |
-|---|---|---|
-| GUARD-HITL-001 | Interface web de revisão (próximo match → confirmar/rejeitar) | P1 |
-| GUARD-HITL-002 | Runner de corpus sintético + relatório de cobertura | P1 |
-| GUARD-HITL-003 | Export/import de perfis como JSON | P2 |
-| GUARD-HITL-004 | Perfis adicionais: TJMG, SES-MG, DETRAN-MG | P2 |
-| GUARD-HITL-005 | API `POST /guard/patterns` para adicionar padrões via UI, sem código | P2 |
-| GUARD-HITL-006 | Ciclo automático: N confirmações → promove → notifica mantenedor | P3 |
+| Task | O que é | Prioridade | Status |
+|---|---|---|---|
+| GUARD-HITL-001 | Review inline no chat: Prime roda runner → Enio confirma matches | P1 | 🟡 Corpus rodado 2026-06-10 (aguarda confirmação final Enio) |
+| GUARD-HITL-002 | Corpus sintético (28 frases) + hitl-runner.ts interativo | P1 | ✅ Entregue (0ee0ae44) |
+| GUARD-HITL-003 | Export/import de perfis como JSON | P2 | 🔴 Pendente |
+| GUARD-HITL-004 | Perfis adicionais: TJMG, SES-MG, DETRAN-MG | P2 | 🔴 Pendente |
+| GUARD-HITL-005 | API `POST /guard/patterns` para adicionar padrões via UI, sem código | P2 | 🔴 Pendente |
+| GUARD-HITL-006 | Ciclo automático: N confirmações → promove → notifica mantenedor | P3 | 🔴 Pendente |
+
+---
+
+## Documentação relacionada
+
+- [BR_AI_REGULATORY_FRAMEWORK.md](BR_AI_REGULATORY_FRAMEWORK.md) — CNJ 615/2025 + MJSP 961/2025 + Sinapses 2.0: framework regulatório para uso de IA local em instituições brasileiras
 
 ---
 
-*EGOS Framework · Guard Brasil v0.2.0 · docs/guard-brasil/EXTENSIBILITY.md*
+*EGOS Framework · Guard Brasil v0.2.0 · docs/guard-brasil/EXTENSIBILITY.md · 2026-06-10*
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..956c637b 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T15:30:30.816Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -71,10 +71,10 @@
       "id": "kernel_packages",
       "description": "Packages in packages/ directory",
       "status": "ok",
-      "last_value": "36",
-      "current_value": "38",
+      "last_value": "39",
+      "current_value": "39",
       "tolerance": "±2",
-      "drift_abs": 2,
+      "drift_abs": 0,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1394",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -173,7 +173,7 @@
       "description": "Pre-commit hook chain has minimum required governance stages",
       "status": "ok",
       "last_value": "70",
-      "current_value": "178",
+      "current_value": "177",
       "tolerance": "min:15",
       "command": "grep -c '\\[' .husky/pre-commit",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 4fed15d9..f3bb27f2 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -238,5 +238,133 @@
     "duration_ms": null,
     "event": "commit:fix files=6 sha=749d8d59",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:56:17.090Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=807ad918",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:07:01.640Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=cbb0006e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:13:39.265Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=4a44ae1b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:19:55.220Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=eb3edd98",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:34:56.370Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=b5b6cf57",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:01:11.829Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b9b56fb8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:03:35.239Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=76304863",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:08:24.054Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=9 sha=aa4bce23",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:12:44.643Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=b2dbeefe",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:24:19.844Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=beccce45",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:31:25.173Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=0ee0ae44",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:32:53.835Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b6d613ad",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T15:30:35.127Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=22 sha=4cb53dbb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T15:33:03.348Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=6 sha=d33a4298",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:12:30.554Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=f1e8c1d9",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/presentations/curso-ciber-ia-lgpd-lidia.html b/docs/presentations/curso-ciber-ia-lgpd-lidia.html
index 76977018..31f57ac0 100644
--- a/docs/presentations/curso-ciber-ia-lgpd-lidia.html
+++ b/docs/presentations/curso-ciber-ia-lgpd-lidia.html
@@ -334,6 +334,12 @@ tr:nth-child(even) td { background: var(--bg); }
     <div class="callout callout-yellow">
       <strong>⚠️ Nota:</strong> este slide apresenta interpretação didática dos Arts. 4º III, §1º, 6º e 20 da LGPD. Não é parecer jurídico. A redação exata dos artigos e eventual norma específica/posicionamento da ANPD devem ser conferidos pelo instrutor antes de ministrar.
     </div>
+    <div class="callout callout-blue" style="margin-top:12px">
+      <strong>📋 Framework regulatório BR aprovado (jun/2026):</strong><br>
+      <strong>CNJ Resolução 615/2025</strong> (11/mar/2025) — governa uso de IA no Poder Judiciário. Arts. chave: Art. 9 (risco proporcional), Art. 13 (HITL obrigatório para decisões de alto risco). Aplica a tribunais estaduais.<br>
+      <strong>Portaria MJSP 961/2025</strong> (24/jun/2025) — governa IA em investigação criminal. Art. 10 (proporcionalidade), Art. 11 (vigilância biométrica em público = vedada salvo 5 exceções), Art. 13 (log obrigatório: nome+CPF+IP+datetime+operação).<br>
+      <span style="font-size:12px;color:var(--muted)">Verificar no site do CNJ/MJSP se houve atualização posterior. Aplica-se a policiais que usam recursos FNSP/FPN; PCMG também adota por referência.</span>
+    </div>
   </div>
 
   <div class="card">
@@ -357,6 +363,26 @@ tr:nth-child(even) td { background: var(--bg); }
       </div>
     </div>
     <p>A instituição roda o <strong>seu</strong> modelo, localmente — o dado não viaja. Custo total ao longo do tempo de uma máquina local vs. mandar tudo para fora.</p>
+
+    <div class="callout callout-blue" style="margin:12px 0">
+      <strong>🖥️ Tiers de hardware (referência jun/2026):</strong>
+      <table style="width:100%;margin-top:8px;font-size:13px;border-collapse:collapse">
+        <thead><tr style="text-align:left;border-bottom:1px solid var(--border)"><th style="padding:4px 8px">Classe</th><th style="padding:4px 8px">Exemplos de máquinas</th><th style="padding:4px 8px">Capacidade</th></tr></thead>
+        <tbody>
+          <tr><td style="padding:4px 8px">Workstation pesada</td><td style="padding:4px 8px">Mac Studio / Mac Pro (chip Ultra), PC com RTX 4090/5090</td><td style="padding:4px 8px">Modelos 70B+ totalmente em memória</td></tr>
+          <tr style="background:var(--b1)"><td style="padding:4px 8px">Workstation média</td><td style="padding:4px 8px">Mac Studio/MacBook Pro (chip Max), PC com RTX 4080</td><td style="padding:4px 8px">Modelos 30–70B quantizados</td></tr>
+          <tr><td style="padding:4px 8px">Notebook investigador</td><td style="padding:4px 8px">MacBook Pro (chip Pro), notebook NVIDIA mid-range</td><td style="padding:4px 8px">Modelos 7–14B com boa performance</td></tr>
+          <tr style="background:var(--b1)"><td style="padding:4px 8px">Mínimo</td><td style="padding:4px 8px">Qualquer máquina com 8GB RAM</td><td style="padding:4px 8px">Modelos 7B quantizados (uso limitado)</td></tr>
+        </tbody>
+      </table>
+    </div>
+
+    <div class="callout callout-green" style="margin:12px 0">
+      <strong>🔧 Setup recomendado (Apple Silicon):</strong> <strong>LM Studio</strong> com backend MLX nativo — 30–50% mais rápido que alternativas no mesmo chip. Interface visual, sem linha de comando.<br>
+      <strong>Setup alternativo (todas as plataformas):</strong> Ollama + interface web.<br>
+      <span style="font-size:12px;color:var(--muted)">⚠️ Modelos ficam desatualizados rapidamente. Não fixe um modelo específico — ensine onde buscar: <a href="https://huggingface.co/models?sort=trending&search=instruct" target="_blank" style="color:var(--blue)">HuggingFace trending</a>, <a href="https://ollama.com/library" target="_blank" style="color:var(--blue)">Ollama Library</a>. Pergunte: "qual o melhor modelo 7B que roda na minha RAM hoje?" — a resposta muda a cada semana.</span>
+    </div>
+
     <p style="font-size:13px;color:var(--muted)">Base real: modelo local + Guard Brasil local.</p>
   </div>
 
@@ -524,7 +550,7 @@ tr:nth-child(even) td { background: var(--bg); }
     <tbody>
       <tr><td>1</td><td>Detecção de PII</td><td>Módulo 2</td><td>Rodar Guard Brasil no texto do Caso Alfa — encontrar MASP, REDS, CPF</td></tr>
       <tr><td>2</td><td>Mascaramento</td><td>Módulo 3</td><td>Gerar versão mascarada; comparar com original; explicar cada máscara</td></tr>
-      <tr><td>3</td><td>Modelo local</td><td>Módulo 4</td><td>Processar Caso Alfa com modelo local — dado não sai da máquina. ⚠️ Requer instalação (ex: Ollama + llama3). Alternativa: demonstrado pelo instrutor.</td></tr>
+      <tr><td>3</td><td>Modelo local</td><td>Módulo 4</td><td>Processar Caso Alfa com modelo local — dado não sai da máquina. ⚠️ Requer instalação prévia: <strong>LM Studio</strong> (Apple Silicon, recomendado) ou <strong>Ollama</strong> (multiplataforma). Escolha um modelo 7B–14B disponível no momento — não hardcode nome específico (ficam obsoletos). Alternativa: demonstrado pelo instrutor.</td></tr>
       <tr><td>4</td><td>Cadeia de custódia</td><td>Módulo 6</td><td>Gerar hash SHA-256 + log de auditoria para saída de IA no Caso Alfa; criar documento defensável</td></tr>
       <tr><td>5</td><td>A pergunta de governança</td><td>Módulo 7</td><td>Olhando o Caso Alfa: o que NUNCA poderia ir para IA externa? Discussão — a resposta certa é: nada do real.</td></tr>
     </tbody>
@@ -555,10 +581,16 @@ tr:nth-child(even) td { background: var(--bg); }
         <td>Alerta já no slide</td>
       </tr>
       <tr>
-        <td>Lab 3 / Whisper</td>
+        <td>Lab 3 / Modelo local</td>
         <td><span class="tag tag-orange">Médio</span></td>
-        <td>Whisper é referência de campo, não ferramenta instalada no pacote do curso. Lab 3 exige Ollama ou similar — pré-requisito técnico não trivial.</td>
-        <td>Demonstrar pelo instrutor; declarar requisito antes da aula</td>
+        <td>Lab 3 exige LM Studio (Apple Silicon) ou Ollama pré-instalado — pré-requisito técnico não trivial. Não citar modelo específico em aula: modelos ficam obsoletos a cada semana. Ensinar onde buscar (HuggingFace trending, Ollama Library). Whisper (transcrição) é referência de campo — não instalado no pacote do curso.</td>
+        <td>Declarar requisito antes da aula; demonstrar pelo instrutor se nenhum aluno tiver setup</td>
+      </tr>
+      <tr>
+        <td>CNJ 615/2025 + MJSP 961/2025</td>
+        <td><span class="tag tag-green">Atualizado</span></td>
+        <td>Framework regulatório duplo aprovado. CNJ: Art. 13 exige HITL em decisões de alto risco — Guard Brasil é compatível. MJSP: Art. 13 exige log nome+CPF+IP+datetime+operação. Verificar se PCMG aderiu formalmente e se houve portaria estadual posterior.</td>
+        <td>Adicionado no Slide 5 (jun/2026). Instrutor verifica atualizações antes de cada turma.</td>
       </tr>
       <tr>
         <td>Slide 11 / Proposta</td>
@@ -628,7 +660,8 @@ tr:nth-child(even) td { background: var(--bg); }
 
   <ul class="checklist">
     <li><span class="check-icon">⏳</span><div><strong>Deck visual (PDF):</strong> geração no NotebookLM Studio em andamento. Quando pronto: salvar como PDF e incluir no ZIP.</div></li>
-    <li><span class="check-icon">🔵</span><div><strong>Revisão LGPD/ANPD (Slide 5):</strong> verificar se a "lei específica" prevista nos PLs de 2026 foi aprovada e atualizar o slide. Tarefa do instrutor.</div></li>
+    <li><span class="check-icon">✅</span><div><strong>Regulatório BR (Slide 5 atualizado jun/2026):</strong> CNJ Resolução 615/2025 + Portaria MJSP 961/2025 adicionados. Framework dual aprovado documentado. Instrutor verifica atualização antes de cada turma.</div></li>
+    <li><span class="check-icon">✅</span><div><strong>Modelo local (Slide 7 + Lab 3 atualizado jun/2026):</strong> LM Studio (MLX, Apple Silicon) como recomendado. Hardware tiers documentados. Filosofia "sem hardcode de modelos" — ensinar onde buscar.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Gate PCMG:</strong> verificado e confirmado (jun/2026). Vetor magistério liberado.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Caso Alfa sintético:</strong> 5 labs prontos, zero dado real.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Plano de aula:</strong> 8 módulos, ~3h, critérios verificáveis.</div></li>
@@ -641,7 +674,7 @@ tr:nth-child(even) td { background: var(--bg); }
 <!-- FOOTER -->
 <footer class="footer">
   <div>
-    <strong>EGOS Framework</strong> — Ciber+IA+LGPD para a Investigação · v1.1 · jun/2026
+    <strong>EGOS Framework</strong> — Ciber+IA+LGPD para a Investigação · v1.2 · jun/2026 · CNJ 615/2025 + MJSP 961/2025 + LM Studio MLX
   </div>
   <div>
     Fonte canônica: <code>docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md</code> ·
diff --git a/packages/guard-brasil/tsconfig.tsbuildinfo b/packages/guard-brasil/tsconfig.tsbuildinfo
index b510186e..9460f310 100644
--- a/packages/guard-brasil/tsconfig.tsbuildinfo
+++ b/packages/guard-brasil/tsconfig.tsbuildinfo
@@ -1 +1 @@
-{"fileNames":["../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.esnext.float16.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@5.9.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/evidence-chain.ts","./src/lib/provenance.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/lib/tokenizer.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/compatibility/disposable.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/compatibility/indexable.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/compatibility/index.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/net.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@22.19.15/node_modules/@types/node/index.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/file.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/filereader.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@6.21.0/node_modules/undici-types/index.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.18.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/net.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.5.0/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.10/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.10/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,328],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[77,78,79,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,178,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,258,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,206,207,208,209,210,211,212,213,214,215,216,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,178,179,180,181,182,185,186,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,178,179,180,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,178,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,184,185,186,187,188,189,195,196,197,198,199,200,201,202,203,204,205,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327],[10,82,83,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,198,199,200,201,202,203,208,212,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,189,196,197,198,199,200,201,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,194,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,190,191,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,190,191,192,193,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,190,192,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,190,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,154,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,145,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,147,150,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,145,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[75,76,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,146,149,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,157,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[75,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,148,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,171,172,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,146,150,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,171,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,144,145,146,147,148,149,150,151,152,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,172,173,174,175,176,177,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,165,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,157,158,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,148,150,158,159,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,149,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[75,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,145,150,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,150,154,158,159,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,154,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,148,150,153,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[75,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,147,150,157,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,145,150,171,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,223,226,229,230,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,230,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,220,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,224,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,222,223,226,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,179,180,181,183,185,196,197,198,199,200,201,202,203,208,220,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,222,226,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,217,218,219,221,225,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,235,243,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,218,224,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,252,253,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,179,180,181,183,185,196,197,198,199,200,201,202,203,208,218,221,226,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,217,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,220,221,222,224,225,226,227,228,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,253,254,255,256,257,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,245,248,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,235,236,237,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,224,226,236,238,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,225,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,218,220,226,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,230,236,238,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,230,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,224,226,229,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,218,222,226,235,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,226,245,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,238,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,179,180,181,183,185,196,197,198,199,200,201,202,203,208,220,226,252,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[62,63,68,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[68,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[67,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[62,67,68,71,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[61,63,64,65,66,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[62,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326],[63,82,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,179,180,181,183,185,196,197,198,199,200,201,202,203,208,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326]],"fileInfos":[{"version":"c430d44666289dae81f30fa7b2edebf186ecc91a2d4c71266ea6ae76388792e1","affectsGlobalScope":true,"impliedFormat":1},{"version":"45b7ab580deca34ae9729e97c13cfd999df04416a79116c3bfb483804f85ded4","impliedFormat":1},{"version":"3facaf05f0c5fc569c5649dd359892c98a85557e3e0c847964caeb67076f4d75","impliedFormat":1},{"version":"e44bb8bbac7f10ecc786703fe0a6a4b952189f908707980ba8f3c8975a760962","impliedFormat":1},{"version":"5e1c4c362065a6b95ff952c0eab010f04dcd2c3494e813b493ecfd4fcb9fc0d8","impliedFormat":1},{"version":"68d73b4a11549f9c0b7d352d10e91e5dca8faa3322bfb77b661839c42b1ddec7","impliedFormat":1},{"version":"5efce4fc3c29ea84e8928f97adec086e3dc876365e0982cc8479a07954a3efd4","impliedFormat":1},{"version":"feecb1be483ed332fad555aff858affd90a48ab19ba7272ee084704eb7167569","impliedFormat":1},{"version":"ee7bad0c15b58988daa84371e0b89d313b762ab83cb5b31b8a2d1162e8eb41c2","impliedFormat":1},{"version":"080941d9f9ff9307f7e27a83bcd888b7c8270716c39af943532438932ec1d0b9","affectsGlobalScope":true,"impliedFormat":1},{"version":"c57796738e7f83dbc4b8e65132f11a377649c00dd3eee333f672b8f0a6bea671","affectsGlobalScope":true,"impliedFormat":1},{"version":"dc2df20b1bcdc8c2d34af4926e2c3ab15ffe1160a63e58b7e09833f616efff44","affectsGlobalScope":true,"impliedFormat":1},{"version":"515d0b7b9bea2e31ea4ec968e9edd2c39d3eebf4a2d5cbd04e88639819ae3b71","affectsGlobalScope":true,"impliedFormat":1},{"version":"0559b1f683ac7505ae451f9a96ce4c3c92bdc71411651ca6ddb0e88baaaad6a3","affectsGlobalScope":true,"impliedFormat":1},{"version":"0dc1e7ceda9b8b9b455c3a2d67b0412feab00bd2f66656cd8850e8831b08b537","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce691fb9e5c64efb9547083e4a34091bcbe5bdb41027e310ebba8f7d96a98671","affectsGlobalScope":true,"impliedFormat":1},{"version":"8d697a2a929a5fcb38b7a65594020fcef05ec1630804a33748829c5ff53640d0","affectsGlobalScope":true,"impliedFormat":1},{"version":"4ff2a353abf8a80ee399af572debb8faab2d33ad38c4b4474cff7f26e7653b8d","affectsGlobalScope":true,"impliedFormat":1},{"version":"fb0f136d372979348d59b3f5020b4cdb81b5504192b1cacff5d1fbba29378aa1","affectsGlobalScope":true,"impliedFormat":1},{"version":"d15bea3d62cbbdb9797079416b8ac375ae99162a7fba5de2c6c505446486ac0a","affectsGlobalScope":true,"impliedFormat":1},{"version":"68d18b664c9d32a7336a70235958b8997ebc1c3b8505f4f1ae2b7e7753b87618","affectsGlobalScope":true,"impliedFormat":1},{"version":"eb3d66c8327153d8fa7dd03f9c58d351107fe824c79e9b56b462935176cdf12a","affectsGlobalScope":true,"impliedFormat":1},{"version":"38f0219c9e23c915ef9790ab1d680440d95419ad264816fa15009a8851e79119","affectsGlobalScope":true,"impliedFormat":1},{"version":"69ab18c3b76cd9b1be3d188eaf8bba06112ebbe2f47f6c322b5105a6fbc45a2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"a680117f487a4d2f30ea46f1b4b7f58bef1480456e18ba53ee85c2746eeca012","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f11ff796926e0832f9ae148008138ad583bd181899ab7dd768a2666700b1893","affectsGlobalScope":true,"impliedFormat":1},{"version":"4de680d5bb41c17f7f68e0419412ca23c98d5749dcaaea1896172f06435891fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"954296b30da6d508a104a3a0b5d96b76495c709785c1d11610908e63481ee667","affectsGlobalScope":true,"impliedFormat":1},{"version":"ac9538681b19688c8eae65811b329d3744af679e0bdfa5d842d0e32524c73e1c","affectsGlobalScope":true,"impliedFormat":1},{"version":"0a969edff4bd52585473d24995c5ef223f6652d6ef46193309b3921d65dd4376","affectsGlobalScope":true,"impliedFormat":1},{"version":"9e9fbd7030c440b33d021da145d3232984c8bb7916f277e8ffd3dc2e3eae2bdb","affectsGlobalScope":true,"impliedFormat":1},{"version":"811ec78f7fefcabbda4bfa93b3eb67d9ae166ef95f9bff989d964061cbf81a0c","affectsGlobalScope":true,"impliedFormat":1},{"version":"717937616a17072082152a2ef351cb51f98802fb4b2fdabd32399843875974ca","affectsGlobalScope":true,"impliedFormat":1},{"version":"d7e7d9b7b50e5f22c915b525acc5a49a7a6584cf8f62d0569e557c5cfc4b2ac2","affectsGlobalScope":true,"impliedFormat":1},{"version":"71c37f4c9543f31dfced6c7840e068c5a5aacb7b89111a4364b1d5276b852557","affectsGlobalScope":true,"impliedFormat":1},{"version":"576711e016cf4f1804676043e6a0a5414252560eb57de9faceee34d79798c850","affectsGlobalScope":true,"impliedFormat":1},{"version":"89c1b1281ba7b8a96efc676b11b264de7a8374c5ea1e6617f11880a13fc56dc6","affectsGlobalScope":true,"impliedFormat":1},{"version":"74f7fa2d027d5b33eb0471c8e82a6c87216223181ec31247c357a3e8e2fddc5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"d6d7ae4d1f1f3772e2a3cde568ed08991a8ae34a080ff1151af28b7f798e22ca","affectsGlobalScope":true,"impliedFormat":1},{"version":"063600664504610fe3e99b717a1223f8b1900087fab0b4cad1496a114744f8df","affectsGlobalScope":true,"impliedFormat":1},{"version":"934019d7e3c81950f9a8426d093458b65d5aff2c7c1511233c0fd5b941e608ab","affectsGlobalScope":true,"impliedFormat":1},{"version":"52ada8e0b6e0482b728070b7639ee42e83a9b1c22d205992756fe020fd9f4a47","affectsGlobalScope":true,"impliedFormat":1},{"version":"3bdefe1bfd4d6dee0e26f928f93ccc128f1b64d5d501ff4a8cf3c6371200e5e6","affectsGlobalScope":true,"impliedFormat":1},{"version":"59fb2c069260b4ba00b5643b907ef5d5341b167e7d1dbf58dfd895658bda2867","affectsGlobalScope":true,"impliedFormat":1},{"version":"639e512c0dfc3fad96a84caad71b8834d66329a1f28dc95e3946c9b58176c73a","affectsGlobalScope":true,"impliedFormat":1},{"version":"368af93f74c9c932edd84c58883e736c9e3d53cec1fe24c0b0ff451f529ceab1","affectsGlobalScope":true,"impliedFormat":1},{"version":"af3dd424cf267428f30ccfc376f47a2c0114546b55c44d8c0f1d57d841e28d74","affectsGlobalScope":true,"impliedFormat":1},{"version":"995c005ab91a498455ea8dfb63aa9f83fa2ea793c3d8aa344be4a1678d06d399","affectsGlobalScope":true,"impliedFormat":1},{"version":"959d36cddf5e7d572a65045b876f2956c973a586da58e5d26cde519184fd9b8a","affectsGlobalScope":true,"impliedFormat":1},{"version":"965f36eae237dd74e6cca203a43e9ca801ce38824ead814728a2807b1910117d","affectsGlobalScope":true,"impliedFormat":1},{"version":"3925a6c820dcb1a06506c90b1577db1fdbf7705d65b62b99dce4be75c637e26b","affectsGlobalScope":true,"impliedFormat":1},{"version":"0a3d63ef2b853447ec4f749d3f368ce642264246e02911fcb1590d8c161b8005","affectsGlobalScope":true,"impliedFormat":1},{"version":"8cdf8847677ac7d20486e54dd3fcf09eda95812ac8ace44b4418da1bbbab6eb8","affectsGlobalScope":true,"impliedFormat":1},{"version":"8444af78980e3b20b49324f4a16ba35024fef3ee069a0eb67616ea6ca821c47a","affectsGlobalScope":true,"impliedFormat":1},{"version":"3287d9d085fbd618c3971944b65b4be57859f5415f495b33a6adc994edd2f004","affectsGlobalScope":true,"impliedFormat":1},{"version":"b4b67b1a91182421f5df999988c690f14d813b9850b40acd06ed44691f6727ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"51ad4c928303041605b4d7ae32e0c1ee387d43a24cd6f1ebf4a2699e1076d4fa","affectsGlobalScope":true,"impliedFormat":1},{"version":"196cb558a13d4533a5163286f30b0509ce0210e4b316c56c38d4c0fd2fb38405","affectsGlobalScope":true,"impliedFormat":1},{"version":"8e7f8264d0fb4c5339605a15daadb037bf238c10b654bb3eee14208f860a32ea","affectsGlobalScope":true,"impliedFormat":1},{"version":"782dec38049b92d4e85c1585fbea5474a219c6984a35b004963b00beb1aab538","affectsGlobalScope":true,"impliedFormat":1},{"version":"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9","signature":"7666b459c23e13b11e21eaf4b234b2b4927196d6d400af026ee55273ed365d48"},{"version":"deedd18208f964b18617aa55114d205f9fc5f9dd314faa534092a724a8802183","signature":"56cd173b36226ee72f0d449637df90975a9ce70e268c96bcc9f0fb61fb09c089"},{"version":"8216338eaa9fa652e016940337fb78e952e09f53fddb11874ca9a42b272382ee","signature":"7ef29161505ec539173e3207e81e909cad727c091b6c5f1cdfc671e0d4cdae5b"},{"version":"c46f6027241b404c63d4917074907da12414a803392d8fb466d531d2a09da4ae","signature":"a421f6a523935faedd44a80d43890ee3be122d4b065cce1e6bfe846e755a3ac0"},{"version":"2c93993c845e0dd1576803b6e51365f0383d51a6e2a55489c2ba2f2480793c83","signature":"8cb5946f9a57990aa3aa9ebfce91bc9dc739e25cdd347f4ba53b36712dc0b4be"},{"version":"c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","signature":"7ded40def28eac1d912b816c941a8dac1fc2f82331fcbd7fa56280a9cac42dd6"},{"version":"ac1aadc908543ce94afbced5b8cc2d1b94b3b795a303e4c242004031b183765c","signature":"b96432308e49a77b1a29e0cca4b9485721786ae6bcc0990f08545b4781eb9ba2"},{"version":"71c84fc3fddb50de24a2b655d387d37aa2fa8b42d426d94481bcee463e5cfa12","signature":"250d2a7477e37fec640461987620ab08b05612c54ea2f5f2aa242dc14b16f086"},{"version":"5457f8855c90dabe3c51fb8cf202903344da469be78939b95587929d7382e1f1","signature":"cca70d080501976aa2c93233b984b79fe79aee09978bdbe356bb20deb1a3d588"},{"version":"ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae","signature":"76c2e5694d504148676eed0cd376d740ca8727d9b77067b7316b5be5837fe6c1"},{"version":"7ff10c73aab4f126ea1d1f7cd40c2b6c9057c974bde0fb75972d677f7ae67c26","signature":"81d70c5c828ec1cbfc88fc86e17a63071c11d0ded908a360dcff80e89dd2841d"},{"version":"f35f725e7db5bb0e9550e04a97ea4d7c80d66e7847f12cc7b2d2c3fd555d3099","signature":"58f553b4e9d4d85368128355b76d61ba1c69dbdce748c4199f1eb58763aa2802"},{"version":"122d5576a188ee95576cc2106f639c9893c808dbf565f35723825e078c3f4c5d","signature":"7b5dc08c70f20076c7d8c4153420153b94911c3530e826376d3f415cb24b2a03"},{"version":"4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3","signature":"4721837b454c96397f95fab80c76ba0458d94a9176b7479acaeeeb8f0607bcb3"},{"version":"5929864ce17fba74232584d90cb721a89b7ad277220627cc97054ba15a98ea8f","impliedFormat":1},{"version":"763fe0f42b3d79b440a9b6e51e9ba3f3f91352469c1e4b3b67bfa4ff6352f3f4","impliedFormat":1},{"version":"6c7176368037af28cb72f2392010fa1cef295d6d6744bca8cfb54985f3a18c3e","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab41ef1f2cdafb8df48be20cd969d875602483859dc194e9c97c8a576892c052","affectsGlobalScope":true,"impliedFormat":1},{"version":"437e20f2ba32abaeb7985e0afe0002de1917bc74e949ba585e49feba65da6ca1","affectsGlobalScope":true,"impliedFormat":1},{"version":"21d819c173c0cf7cc3ce57c3276e77fd9a8a01d35a06ad87158781515c9a438a","impliedFormat":1},{"version":"98cffbf06d6bab333473c70a893770dbe990783904002c4f1a960447b4b53dca","affectsGlobalScope":true,"impliedFormat":1},{"version":"3af97acf03cc97de58a3a4bc91f8f616408099bc4233f6d0852e72a8ffb91ac9","affectsGlobalScope":true,"impliedFormat":1},{"version":"808069bba06b6768b62fd22429b53362e7af342da4a236ed2d2e1c89fcca3b4a","affectsGlobalScope":true,"impliedFormat":1},{"version":"1db0b7dca579049ca4193d034d835f6bfe73096c73663e5ef9a0b5779939f3d0","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"f26b11d8d8e4b8028f1c7d618b22274c892e4b0ef5b3678a8ccbad85419aef43","affectsGlobalScope":true,"impliedFormat":1},{"version":"b52476feb4a0cbcb25e5931b930fc73cb6643fb1a5060bf8a3dda0eeae5b4b68","affectsGlobalScope":true,"impliedFormat":1},{"version":"f9501cc13ce624c72b61f12b3963e84fad210fbdf0ffbc4590e08460a3f04eba","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"0fa06ada475b910e2106c98c68b10483dc8811d0c14a8a8dd36efb2672485b29","impliedFormat":1},{"version":"33e5e9aba62c3193d10d1d33ae1fa75c46a1171cf76fef750777377d53b0303f","impliedFormat":1},{"version":"2b06b93fd01bcd49d1a6bd1f9b65ddcae6480b9a86e9061634d6f8e354c1468f","impliedFormat":1},{"version":"6a0cd27e5dc2cfbe039e731cf879d12b0e2dded06d1b1dedad07f7712de0d7f4","affectsGlobalScope":true,"impliedFormat":1},{"version":"13f5c844119c43e51ce777c509267f14d6aaf31eafb2c2b002ca35584cd13b29","impliedFormat":1},{"version":"e60477649d6ad21542bd2dc7e3d9ff6853d0797ba9f689ba2f6653818999c264","impliedFormat":1},{"version":"c2510f124c0293ab80b1777c44d80f812b75612f297b9857406468c0f4dafe29","affectsGlobalScope":true,"impliedFormat":1},{"version":"5524481e56c48ff486f42926778c0a3cce1cc85dc46683b92b1271865bcf015a","impliedFormat":1},{"version":"4c829ab315f57c5442c6667b53769975acbf92003a66aef19bce151987675bd1","affectsGlobalScope":true,"impliedFormat":1},{"version":"b2ade7657e2db96d18315694789eff2ddd3d8aea7215b181f8a0b303277cc579","impliedFormat":1},{"version":"9855e02d837744303391e5623a531734443a5f8e6e8755e018c41d63ad797db2","impliedFormat":1},{"version":"4d631b81fa2f07a0e63a9a143d6a82c25c5f051298651a9b69176ba28930756d","impliedFormat":1},{"version":"836a356aae992ff3c28a0212e3eabcb76dd4b0cc06bcb9607aeef560661b860d","impliedFormat":1},{"version":"1e0d1f8b0adfa0b0330e028c7941b5a98c08b600efe7f14d2d2a00854fb2f393","impliedFormat":1},{"version":"41670ee38943d9cbb4924e436f56fc19ee94232bc96108562de1a734af20dc2c","affectsGlobalScope":true,"impliedFormat":1},{"version":"c906fb15bd2aabc9ed1e3f44eb6a8661199d6c320b3aa196b826121552cb3695","impliedFormat":1},{"version":"22295e8103f1d6d8ea4b5d6211e43421fe4564e34d0dd8e09e520e452d89e659","impliedFormat":1},{"version":"58647d85d0f722a1ce9de50955df60a7489f0593bf1a7015521efe901c06d770","impliedFormat":1},{"version":"6b4e081d55ac24fc8a4631d5dd77fe249fa25900abd7d046abb87d90e3b45645","impliedFormat":1},{"version":"a10f0e1854f3316d7ee437b79649e5a6ae3ae14ffe6322b02d4987071a95362e","impliedFormat":1},{"version":"e208f73ef6a980104304b0d2ca5f6bf1b85de6009d2c7e404028b875020fa8f2","impliedFormat":1},{"version":"d163b6bc2372b4f07260747cbc6c0a6405ab3fbcea3852305e98ac43ca59f5bc","impliedFormat":1},{"version":"e6fa9ad47c5f71ff733744a029d1dc472c618de53804eae08ffc243b936f87ff","affectsGlobalScope":true,"impliedFormat":1},{"version":"83e63d6ccf8ec004a3bb6d58b9bb0104f60e002754b1e968024b320730cc5311","impliedFormat":1},{"version":"24826ed94a78d5c64bd857570fdbd96229ad41b5cb654c08d75a9845e3ab7dde","impliedFormat":1},{"version":"8b479a130ccb62e98f11f136d3ac80f2984fdc07616516d29881f3061f2dd472","impliedFormat":1},{"version":"928af3d90454bf656a52a48679f199f64c1435247d6189d1caf4c68f2eaf921f","affectsGlobalScope":true,"impliedFormat":1},{"version":"bceb58df66ab8fb00170df20cd813978c5ab84be1d285710c4eb005d8e9d8efb","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f16a7e4deafa527ed9995a772bb380eb7d3c2c0fd4ae178c5263ed18394db2c","impliedFormat":1},{"version":"933921f0bb0ec12ef45d1062a1fc0f27635318f4d294e4d99de9a5493e618ca2","impliedFormat":1},{"version":"71a0f3ad612c123b57239a7749770017ecfe6b66411488000aba83e4546fde25","impliedFormat":1},{"version":"77fbe5eecb6fac4b6242bbf6eebfc43e98ce5ccba8fa44e0ef6a95c945ff4d98","impliedFormat":1},{"version":"4f9d8ca0c417b67b69eeb54c7ca1bedd7b56034bb9bfd27c5d4f3bc4692daca7","impliedFormat":1},{"version":"814118df420c4e38fe5ae1b9a3bafb6e9c2aa40838e528cde908381867be6466","impliedFormat":1},{"version":"a3fc63c0d7b031693f665f5494412ba4b551fe644ededccc0ab5922401079c95","impliedFormat":1},{"version":"f27524f4bef4b6519c604bdb23bf4465bddcccbf3f003abb901acbd0d7404d99","impliedFormat":1},{"version":"37ba7b45141a45ce6e80e66f2a96c8a5ab1bcef0fc2d0f56bb58df96ec67e972","impliedFormat":1},{"version":"45650f47bfb376c8a8ed39d4bcda5902ab899a3150029684ee4c10676d9fbaee","impliedFormat":1},{"version":"6b039f55681caaf111d5eb84d292b9bee9e0131d0db1ad0871eef0964f533c73","affectsGlobalScope":true,"impliedFormat":1},{"version":"18fd40412d102c5564136f29735e5d1c3b455b8a37f920da79561f1fde068208","impliedFormat":1},{"version":"c8d3e5a18ba35629954e48c4cc8f11dc88224650067a172685c736b27a34a4dc","impliedFormat":1},{"version":"f0be1b8078cd549d91f37c30c222c2a187ac1cf981d994fb476a1adc61387b14","affectsGlobalScope":true,"impliedFormat":1},{"version":"0aaed1d72199b01234152f7a60046bc947f1f37d78d182e9ae09c4289e06a592","impliedFormat":1},{"version":"2b55d426ff2b9087485e52ac4bc7cfafe1dc420fc76dad926cd46526567c501a","impliedFormat":1},{"version":"66ba1b2c3e3a3644a1011cd530fb444a96b1b2dfe2f5e837a002d41a1a799e60","impliedFormat":1},{"version":"7e514f5b852fdbc166b539fdd1f4e9114f29911592a5eb10a94bb3a13ccac3c4","impliedFormat":1},{"version":"5b7aa3c4c1a5d81b411e8cb302b45507fea9358d3569196b27eb1a27ae3a90ef","affectsGlobalScope":true,"impliedFormat":1},{"version":"5987a903da92c7462e0b35704ce7da94d7fdc4b89a984871c0e2b87a8aae9e69","affectsGlobalScope":true,"impliedFormat":1},{"version":"ea08a0345023ade2b47fbff5a76d0d0ed8bff10bc9d22b83f40858a8e941501c","impliedFormat":1},{"version":"47613031a5a31510831304405af561b0ffaedb734437c595256bb61a90f9311b","impliedFormat":1},{"version":"ae062ce7d9510060c5d7e7952ae379224fb3f8f2dd74e88959878af2057c143b","impliedFormat":1},{"version":"8a1a0d0a4a06a8d278947fcb66bf684f117bf147f89b06e50662d79a53be3e9f","affectsGlobalScope":true,"impliedFormat":1},{"version":"358765d5ea8afd285d4fd1532e78b88273f18cb3f87403a9b16fef61ac9fdcfe","impliedFormat":1},{"version":"9f55299850d4f0921e79b6bf344b47c420ce0f507b9dcf593e532b09ea7eeea1","impliedFormat":1},{"version":"25c8056edf4314820382a5fdb4bb7816999acdcb929c8f75e3f39473b87e85bc","impliedFormat":1},{"version":"c464d66b20788266e5353b48dc4aa6bc0dc4a707276df1e7152ab0c9ae21fad8","impliedFormat":1},{"version":"78d0d27c130d35c60b5e5566c9f1e5be77caf39804636bc1a40133919a949f21","impliedFormat":1},{"version":"c6fd2c5a395f2432786c9cb8deb870b9b0e8ff7e22c029954fabdd692bff6195","impliedFormat":1},{"version":"1d6e127068ea8e104a912e42fc0a110e2aa5a66a356a917a163e8cf9a65e4a75","impliedFormat":1},{"version":"5ded6427296cdf3b9542de4471d2aa8d3983671d4cac0f4bf9c637208d1ced43","impliedFormat":1},{"version":"7f182617db458e98fc18dfb272d40aa2fff3a353c44a89b2c0ccb3937709bfb5","impliedFormat":1},{"version":"cadc8aced301244057c4e7e73fbcae534b0f5b12a37b150d80e5a45aa4bebcbd","impliedFormat":1},{"version":"385aab901643aa54e1c36f5ef3107913b10d1b5bb8cbcd933d4263b80a0d7f20","impliedFormat":1},{"version":"9670d44354bab9d9982eca21945686b5c24a3f893db73c0dae0fd74217a4c219","impliedFormat":1},{"version":"0b8a9268adaf4da35e7fa830c8981cfa22adbbe5b3f6f5ab91f6658899e657a7","impliedFormat":1},{"version":"11396ed8a44c02ab9798b7dca436009f866e8dae3c9c25e8c1fbc396880bf1bb","impliedFormat":1},{"version":"ba7bc87d01492633cb5a0e5da8a4a42a1c86270e7b3d2dea5d156828a84e4882","impliedFormat":1},{"version":"4893a895ea92c85345017a04ed427cbd6a1710453338df26881a6019432febdd","impliedFormat":1},{"version":"c21dc52e277bcfc75fac0436ccb75c204f9e1b3fa5e12729670910639f27343e","impliedFormat":1},{"version":"13f6f39e12b1518c6650bbb220c8985999020fe0f21d818e28f512b7771d00f9","impliedFormat":1},{"version":"9b5369969f6e7175740bf51223112ff209f94ba43ecd3bb09eefff9fd675624a","impliedFormat":1},{"version":"4fe9e626e7164748e8769bbf74b538e09607f07ed17c2f20af8d680ee49fc1da","impliedFormat":1},{"version":"24515859bc0b836719105bb6cc3d68255042a9f02a6022b3187948b204946bd2","impliedFormat":1},{"version":"ea0148f897b45a76544ae179784c95af1bd6721b8610af9ffa467a518a086a43","impliedFormat":1},{"version":"24c6a117721e606c9984335f71711877293a9651e44f59f3d21c1ea0856f9cc9","impliedFormat":1},{"version":"dd3273ead9fbde62a72949c97dbec2247ea08e0c6952e701a483d74ef92d6a17","impliedFormat":1},{"version":"405822be75ad3e4d162e07439bac80c6bcc6dbae1929e179cf467ec0b9ee4e2e","impliedFormat":1},{"version":"0db18c6e78ea846316c012478888f33c11ffadab9efd1cc8bcc12daded7a60b6","impliedFormat":1},{"version":"e61be3f894b41b7baa1fbd6a66893f2579bfad01d208b4ff61daef21493ef0a8","impliedFormat":1},{"version":"bd0532fd6556073727d28da0edfd1736417a3f9f394877b6d5ef6ad88fba1d1a","impliedFormat":1},{"version":"89167d696a849fce5ca508032aabfe901c0868f833a8625d5a9c6e861ef935d2","impliedFormat":1},{"version":"615ba88d0128ed16bf83ef8ccbb6aff05c3ee2db1cc0f89ab50a4939bfc1943f","impliedFormat":1},{"version":"a4d551dbf8746780194d550c88f26cf937caf8d56f102969a110cfaed4b06656","impliedFormat":1},{"version":"8bd86b8e8f6a6aa6c49b71e14c4ffe1211a0e97c80f08d2c8cc98838006e4b88","impliedFormat":1},{"version":"317e63deeb21ac07f3992f5b50cdca8338f10acd4fbb7257ebf56735bf52ab00","impliedFormat":1},{"version":"4732aec92b20fb28c5fe9ad99521fb59974289ed1e45aecb282616202184064f","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"bf67d53d168abc1298888693338cb82854bdb2e69ef83f8a0092093c2d562107","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"dbecf494aac7d3ee1b23cdaafae0d0bfea8590567fc153db58fe00ed9fa66c24","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"c0aefa42fc76bf16b3d00c983405a9ad7bcde623caabc598d66d93d3c4aa7c54","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"dfbcc400ac6d20b941ccc7bd9031b9d9f54e4d495dd79117334e771959df4805","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"438b41419b1df9f1fbe33b5e1b18f5853432be205991d1b19f5b7f351675541e","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"24371e69a38fc33e268d4a8716dbcda430d6c2c414a99ff9669239c4b8f40dea","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"c63b9ada8c72f95aac5db92aea07e5e87ec810353cdf63b2d78f49a58662cf6c","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"3fad5618174d74a34ee006406d4eb37e8d07dd62eb1315dbf52f48d31a337547","impliedFormat":1},{"version":"7e49f52a159435fc8df4de9dc377ef5860732ca2dc9efec1640531d3cf5da7a3","impliedFormat":1},{"version":"dd4bde4bdc2e5394aed6855e98cf135dfdf5dd6468cad842e03116d31bbcc9bc","impliedFormat":1},{"version":"4d4e879009a84a47c05350b8dca823036ba3a29a3038efed1be76c9f81e45edf","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b50a819485ffe0d237bf0d131e92178d14d11e2aa873d73615a9ec578b341f5","impliedFormat":1},{"version":"9ba13b47cb450a438e3076c4a3f6afb9dc85e17eae50f26d4b2d72c0688c9251","impliedFormat":1},{"version":"b64cd4401633ea4ecadfd700ddc8323a13b63b106ac7127c1d2726f32424622c","impliedFormat":1},{"version":"37c6e5fe5715814412b43cc9b50b24c67a63c4e04e753e0d1305970d65417a60","impliedFormat":1},{"version":"1d024184fb57c58c5c91823f9d10b4915a4867b7934e89115fd0d861a9df27c8","impliedFormat":1},{"version":"ee0e4946247f842c6dd483cbb60a5e6b484fee07996e3a7bc7343dfb68a04c5d","impliedFormat":1},{"version":"ef051f42b7e0ef5ca04552f54c4552eac84099d64b6c5ad0ef4033574b6035b8","impliedFormat":1},{"version":"853a43154f1d01b0173d9cbd74063507ece57170bad7a3b68f3fa1229ad0a92f","impliedFormat":1},{"version":"56231e3c39a031bfb0afb797690b20ed4537670c93c0318b72d5180833d98b72","impliedFormat":1},{"version":"5cc7c39031bfd8b00ad58f32143d59eb6ffc24f5d41a20931269011dccd36c5e","impliedFormat":1},{"version":"12d602a8fe4c2f2ba4f7804f5eda8ba07e0c83bf5cf0cda8baffa2e9967bfb77","affectsGlobalScope":true,"impliedFormat":1},{"version":"a856ab781967b62b288dfd85b860bef0e62f005ed4b1b8fa25c53ce17856acaf","impliedFormat":1},{"version":"cc25940cfb27aa538e60d465f98bb5068d4d7d33131861ace43f04fe6947d68f","impliedFormat":1},{"version":"8db46b61a690f15b245cf16270db044dc047dce9f93b103a59f50262f677ea1f","impliedFormat":1},{"version":"01ff95aa1443e3f7248974e5a771f513cb2ac158c8898f470a1792f817bee497","impliedFormat":1},{"version":"757227c8b345c57d76f7f0e3bbad7a91ffca23f1b2547cbed9e10025816c9cb7","impliedFormat":1},{"version":"959d0327c96dd9bb5521f3ed6af0c435996504cc8dd46baa8e12cb3b3518cef1","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"101f482fd48cb4c7c0468dcc6d62c843d842977aea6235644b1edd05e81fbf22","impliedFormat":1},{"version":"266bee0a41e9c3ba335583e21e9277ae03822402cf5e8e1d99f5196853613b98","affectsGlobalScope":true,"impliedFormat":1},{"version":"386606f8a297988535cb1401959041cfa7f59d54b8a9ed09738e65c98684c976","impliedFormat":1},{"version":"3ef397f12387eff17f550bc484ea7c27d21d43816bbe609d495107f44b97e933","impliedFormat":1},{"version":"1023282e2ba810bc07905d3668349fbd37a26411f0c8f94a70ef3c05fe523fcf","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"e236b5eba291f51bdf32c231673e6cab81b5410850e61f51a7a524dddadc0f95","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"7f2c62938251b45715fd2a9887060ec4fbc8724727029d1cbce373747252bdd7","impliedFormat":1},{"version":"e3ace08b6bbd84655d41e244677b474fd995923ffef7149ddb68af8848b60b05","impliedFormat":1},{"version":"132580b0e86c48fab152bab850fc57a4b74fe915c8958d2ccb052b809a44b61c","impliedFormat":1},{"version":"90a278f5fab7557e69e97056c0841adf269c42697194f0bd5c5e69152637d4b3","impliedFormat":1},{"version":"69c9a5a9392e8564bd81116e1ed93b13205201fb44cb35a7fde8c9f9e21c4b23","impliedFormat":1},{"version":"5f8fc37f8434691ffac1bfd8fc2634647da2c0e84253ab5d2dd19a7718915b35","impliedFormat":1},{"version":"5981c2340fd8b076cae8efbae818d42c11ffc615994cb060b1cd390795f1be2b","impliedFormat":1},{"version":"f263485c9ca90df9fe7bb3a906db9701997dc6cae86ace1f8106ac8d2f7f677b","impliedFormat":1},{"version":"1edcf2f36fc332615846bde6dcc71a8fe526065505bc5e3dcfd65a14becdf698","affectsGlobalScope":true,"impliedFormat":1},{"version":"0250da3eb85c99624f974e77ef355cdf86f43980251bc371475c2b397ba55bcd","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"3d3a5f27ffbc06c885dd4d5f9ee20de61faf877fe2c3a7051c4825903d9a7fdc","impliedFormat":1},{"version":"12806f9f085598ef930edaf2467a5fa1789a878fba077cd27e85dc5851e11834","impliedFormat":1},{"version":"1dbca38aa4b0db1f4f9e6edacc2780af7e028b733d2a98dd3598cd235ca0c97d","impliedFormat":1},{"version":"a43fe41c33d0a192a0ecaf9b92e87bef3709c9972e6d53c42c49251ccb962d69","impliedFormat":1},{"version":"a177959203c017fad3ecc4f3d96c8757a840957a4959a3ae00dab9d35961ca6c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6fc727ccf9b36e257ff982ea0badeffbfc2c151802f741bddff00c6af3b784cf","impliedFormat":1},{"version":"19143c930aef7ccf248549f3e78992f2f1049118ec5d4622e95025057d8e392b","impliedFormat":1},{"version":"4844a4c9b4b1e812b257676ed8a80b3f3be0e29bf05e742cc2ea9c3c6865e6c6","impliedFormat":1},{"version":"064878a60367e0407c42fb7ba02a2ea4d83257357dc20088e549bd4d89433e9c","impliedFormat":1},{"version":"cca8917838a876e2d7016c9b6af57cbf11fdf903c5fdd8e613fa31840b2957bf","impliedFormat":1},{"version":"d91ae55e4282c22b9c21bc26bd3ef637d3fe132507b10529ae68bf76f5de785b","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"7e8a671604329e178bb479c8f387715ebd40a091fc4a7552a0a75c2f3a21c65c","impliedFormat":1},{"version":"41ef7992c555671a8fe54db302788adefa191ded810a50329b79d20a6772d14c","impliedFormat":1},{"version":"041a7781b9127ab568d2cdcce62c58fdea7c7407f40b8c50045d7866a2727130","impliedFormat":1},{"version":"4c5e90ddbcd177ad3f2ffc909ae217c87820f1e968f6959e4b6ba38a8cec935e","impliedFormat":1},{"version":"b70dd9a44e1ac42f030bb12e7d79117eac7cb74170d72d381a1e7913320af23a","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,74]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[329,1],[90,2],[91,2],[92,2],[82,3],[93,2],[94,2],[95,2],[77,2],[80,4],[78,2],[79,2],[96,2],[97,2],[98,2],[99,2],[100,2],[101,2],[102,2],[103,2],[104,2],[105,2],[106,2],[83,2],[81,2],[107,5],[108,2],[109,2],[143,6],[110,2],[111,2],[112,2],[113,2],[114,2],[115,2],[116,2],[117,2],[118,2],[119,2],[120,2],[121,2],[122,2],[123,7],[124,8],[125,2],[127,2],[126,2],[128,2],[129,2],[130,2],[131,2],[132,2],[133,2],[134,2],[135,2],[136,2],[137,2],[138,2],[139,2],[140,2],[84,2],[85,2],[86,2],[87,5],[88,2],[89,2],[141,5],[142,2],[268,2],[269,2],[270,2],[208,9],[271,2],[272,2],[273,2],[206,2],[274,2],[275,2],[276,2],[277,2],[278,2],[279,2],[280,2],[281,2],[282,2],[283,2],[284,2],[209,2],[207,2],[285,10],[286,2],[287,2],[327,11],[288,2],[289,12],[290,2],[291,2],[292,2],[293,2],[294,2],[295,13],[296,14],[297,2],[298,15],[299,2],[300,2],[301,2],[302,2],[303,2],[304,2],[305,16],[306,17],[307,2],[308,2],[309,2],[310,2],[311,2],[312,18],[313,19],[314,2],[315,2],[316,2],[317,2],[318,2],[319,2],[320,2],[321,2],[322,2],[323,2],[324,2],[210,2],[211,2],[212,2],[213,2],[214,2],[215,2],[216,2],[259,10],[260,2],[261,2],[262,2],[263,2],[264,2],[265,2],[266,2],[267,2],[325,10],[326,2],[183,20],[205,2],[204,2],[198,21],[185,22],[184,2],[181,23],[186,2],[179,24],[187,2],[328,25],[188,2],[182,2],[197,26],[199,27],[180,28],[203,29],[201,30],[200,31],[202,32],[189,2],[195,33],[192,34],[194,35],[193,36],[191,37],[190,2],[196,38],[59,2],[60,2],[10,2],[12,2],[11,2],[2,2],[13,2],[14,2],[15,2],[16,2],[17,2],[18,2],[19,2],[20,2],[3,2],[21,2],[22,2],[4,2],[23,2],[27,2],[24,2],[25,2],[26,2],[28,2],[29,2],[30,2],[5,2],[31,2],[32,2],[33,2],[34,2],[6,2],[38,2],[35,2],[36,2],[37,2],[39,2],[7,2],[40,2],[45,2],[46,2],[41,2],[42,2],[43,2],[44,2],[8,2],[50,2],[47,2],[48,2],[49,2],[51,2],[9,2],[52,2],[53,2],[54,2],[56,2],[55,2],[1,2],[57,2],[58,2],[157,39],[167,40],[156,39],[177,41],[148,42],[147,2],[176,43],[170,44],[175,42],[150,45],[164,46],[149,47],[173,48],[145,49],[144,43],[174,50],[146,51],[151,40],[152,2],[155,40],[75,2],[178,52],[168,53],[159,54],[160,55],[162,56],[158,57],[161,58],[171,43],[153,59],[154,60],[163,61],[76,2],[166,53],[165,40],[169,2],[172,62],[235,63],[247,64],[232,65],[248,2],[257,66],[223,67],[224,68],[222,2],[256,43],[251,69],[255,70],[226,71],[244,72],[225,73],[254,74],[220,75],[221,69],[227,64],[228,2],[234,70],[231,64],[218,76],[258,77],[249,78],[238,79],[237,64],[239,80],[242,81],[236,82],[240,83],[252,43],[229,84],[230,85],[243,86],[219,2],[246,87],[245,64],[233,85],[241,88],[250,2],[217,2],[253,89],[69,90],[70,91],[68,92],[72,93],[73,2],[61,2],[65,2],[67,94],[63,95],[66,2],[64,96],[71,96],[62,2],[74,2]],"affectedFilesPendingEmit":[[69,17],[70,17],[68,17],[72,17],[73,17],[61,17],[65,17],[67,17],[63,17],[66,17],[64,17],[71,17],[62,17],[74,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74],"version":"5.9.3"}
\ No newline at end of file
+{"fileNames":["../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2025.float16.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/provenance.ts","./src/lib/evidence-chain.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/lib/tokenizer.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","./src/registry/pcmg-corpus.ts","./src/registry/types.ts","./src/registry/pcmg.ts","./src/registry/hitl-runner.ts","./src/registry/index.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/net.d.ts","../../node_modules/.bun/buffer@6.0.3/node_modules/buffer/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.13/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227,230],[82,142,143,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,151,153,156,157,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,147,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,149,150,153,157,160,162,163,164,168,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,151,153,156,157,160,162,163,164,166,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,152,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,154,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,155,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,132,145,153,156,157,159,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,159,160,162,163,164,166,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,159,160,161,162,163,164,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[80,81,82,83,84,85,86,87,88,89,90,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,166,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,168,177,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,169,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,174,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,175,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,178,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,179,195,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,182,184,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,183,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,186,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,145,153,157,160,162,163,164,177,182,188,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,187,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,192,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,193,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,159,160,162,163,164,175,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,197,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,199,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,200,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,156,157,158,160,162,163,164,172,177,182,185,194,197,198,200,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,159,160,162,163,164,177,191,195,200,203,204,205,206,209,210,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,160,162,163,164,172,177,182,185,191,195,200,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,208,209,210,211,212,213,219,220,221,222,223,224,225,226,227,228,229],[82,145,148,150,153,157,158,160,162,163,164,168,177,185,191,194,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,213,220,222,223,224,225,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,218,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,216,217,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,216,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,222,223,224,225,226,227],[82,97,100,103,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,97,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,166,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,92,93,95,99,145,153,156,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,117,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,126,127,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,95,100,145,153,157,160,162,163,164,177,185,194,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,95,96,98,99,100,101,102,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,122,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,110,111,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,99,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,94,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,104,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,103,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,96,100,109,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,100,126,145,153,157,160,162,163,164,177,185,200,202,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,68,71,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[65,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[61,63,64,65,66,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[63,82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,75,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227]],"fileInfos":[{"version":"bcd24271a113971ba9eb71ff8cb01bc6b0f872a85c23fdbe5d93065b375933cd","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f88bedbeb09c6f5a6645cb24c7c55f1aa22d19ae96c8e6959cbd8b85a707bc6","impliedFormat":1},{"version":"7fe93b39b810eadd916be8db880dd7f0f7012a5cc6ffb62de8f62a2117fa6f1f","impliedFormat":1},{"version":"bb0074cc08b84a2374af33d8bf044b80851ccc9e719a5e202eacf40db2c31600","impliedFormat":1},{"version":"1a7daebe4f45fb03d9ec53d60008fbf9ac45a697fdc89e4ce218bc94b94f94d6","impliedFormat":1},{"version":"f94b133a3cb14a288803be545ac2683e0d0ff6661bcd37e31aaaec54fc382aed","impliedFormat":1},{"version":"f59d0650799f8782fd74cf73c19223730c6d1b9198671b1c5b3a38e1188b5953","impliedFormat":1},{"version":"8a15b4607d9a499e2dbeed9ec0d3c0d7372c850b2d5f1fb259e8f6d41d468a84","impliedFormat":1},{"version":"26e0fe14baee4e127f4365d1ae0b276f400562e45e19e35fd2d4c296684715e6","impliedFormat":1},{"version":"d6b1eba8496bdd0eed6fc8a685768fe01b2da4a0388b5fe7df558290bffcf32f","affectsGlobalScope":true,"impliedFormat":1},{"version":"eadcffda2aa84802c73938e589b9e58248d74c59cb7fcbca6474e3435ac15504","affectsGlobalScope":true,"impliedFormat":1},{"version":"105ba8ff7ba746404fe1a2e189d1d3d2e0eb29a08c18dded791af02f29fb4711","affectsGlobalScope":true,"impliedFormat":1},{"version":"00343ca5b2e3d48fa5df1db6e32ea2a59afab09590274a6cccb1dbae82e60c7c","affectsGlobalScope":true,"impliedFormat":1},{"version":"ebd9f816d4002697cb2864bea1f0b70a103124e18a8cd9645eeccc09bdf80ab4","affectsGlobalScope":true,"impliedFormat":1},{"version":"2c1afac30a01772cd2a9a298a7ce7706b5892e447bb46bdbeef720f7b5da77ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"7b0225f483e4fa685625ebe43dd584bb7973bbd84e66a6ba7bbe175ee1048b4f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c0a4b8ac6ce74679c1da2b3795296f5896e31c38e888469a8e0f99dc3305de60","affectsGlobalScope":true,"impliedFormat":1},{"version":"3084a7b5f569088e0146533a00830e206565de65cae2239509168b11434cd84f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c5079c53f0f141a0698faa903e76cb41cd664e3efb01cc17a5c46ec2eb0bef42","affectsGlobalScope":true,"impliedFormat":1},{"version":"32cafbc484dea6b0ab62cf8473182bbcb23020d70845b406f80b7526f38ae862","affectsGlobalScope":true,"impliedFormat":1},{"version":"fca4cdcb6d6c5ef18a869003d02c9f0fd95df8cfaf6eb431cd3376bc034cad36","affectsGlobalScope":true,"impliedFormat":1},{"version":"b93ec88115de9a9dc1b602291b85baf825c85666bf25985cc5f698073892b467","affectsGlobalScope":true,"impliedFormat":1},{"version":"f5c06dcc3fe849fcb297c247865a161f995cc29de7aa823afdd75aaaddc1419b","affectsGlobalScope":true,"impliedFormat":1},{"version":"b77e16112127a4b169ef0b8c3a4d730edf459c5f25fe52d5e436a6919206c4d7","affectsGlobalScope":true,"impliedFormat":1},{"version":"fbffd9337146eff822c7c00acbb78b01ea7ea23987f6c961eba689349e744f8c","affectsGlobalScope":true,"impliedFormat":1},{"version":"a995c0e49b721312f74fdfb89e4ba29bd9824c770bbb4021d74d2bf560e4c6bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"c7b3542146734342e440a84b213384bfa188835537ddbda50d30766f0593aff9","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce6180fa19b1cccd07ee7f7dbb9a367ac19c0ed160573e4686425060b6df7f57","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f02e2476bccb9dbe21280d6090f0df17d2f66b74711489415a8aa4df73c9675","affectsGlobalScope":true,"impliedFormat":1},{"version":"45e3ab34c1c013c8ab2dc1ba4c80c780744b13b5676800ae2e3be27ae862c40c","affectsGlobalScope":true,"impliedFormat":1},{"version":"805c86f6cca8d7702a62a844856dbaa2a3fd2abef0536e65d48732441dde5b5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e42e397f1a5a77994f0185fd1466520691456c772d06bf843e5084ceb879a0ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"f4c2b41f90c95b1c532ecc874bd3c111865793b23aebcc1c3cbbabcd5d76ffb0","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab26191cfad5b66afa11b8bf935ef1cd88fabfcb28d30b2dfa6fad877d050332","affectsGlobalScope":true,"impliedFormat":1},{"version":"2088bc26531e38fb05eedac2951480db5309f6be3fa4a08d2221abb0f5b4200d","affectsGlobalScope":true,"impliedFormat":1},{"version":"cb9d366c425fea79716a8fb3af0d78e6b22ebbab3bd64d25063b42dc9f531c1e","affectsGlobalScope":true,"impliedFormat":1},{"version":"500934a8089c26d57ebdb688fc9757389bb6207a3c8f0674d68efa900d2abb34","affectsGlobalScope":true,"impliedFormat":1},{"version":"689da16f46e647cef0d64b0def88910e818a5877ca5379ede156ca3afb780ac3","affectsGlobalScope":true,"impliedFormat":1},{"version":"bc21cc8b6fee4f4c2440d08035b7ea3c06b3511314c8bab6bef7a92de58a2593","affectsGlobalScope":true,"impliedFormat":1},{"version":"7ca53d13d2957003abb47922a71866ba7cb2068f8d154877c596d63c359fed25","affectsGlobalScope":true,"impliedFormat":1},{"version":"54725f8c4df3d900cb4dac84b64689ce29548da0b4e9b7c2de61d41c79293611","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5594bc3076ac29e6c1ebda77939bc4c8833de72f654b6e376862c0473199323","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f3eb332c2d73e729f3364fcc0c2b375e72a121e8157d25a82d67a138c83a95c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6f4427f9642ce8d500970e4e69d1397f64072ab73b97e476b4002a646ac743b1","affectsGlobalScope":true,"impliedFormat":1},{"version":"48915f327cd1dea4d7bd358d9dc7732f58f9e1626a29cc0c05c8c692419d9bb7","affectsGlobalScope":true,"impliedFormat":1},{"version":"b7bf9377723203b5a6a4b920164df22d56a43f593269ba6ae1fdc97774b68855","affectsGlobalScope":true,"impliedFormat":1},{"version":"db9709688f82c9e5f65a119c64d835f906efe5f559d08b11642d56eb85b79357","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b25b8c874acd1a4cf8444c3617e037d444d19080ac9f634b405583fd10ce1f7","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be57d7c90cf1f8112ee2636a068d8fd181289f82b744160ec56a7dc158a9f5","affectsGlobalScope":true,"impliedFormat":1},{"version":"a917a49ac94cd26b754ab84e113369a75d1a47a710661d7cd25e961cc797065f","affectsGlobalScope":true,"impliedFormat":1},{"version":"6d3261badeb7843d157ef3e6f5d1427d0eeb0af0cf9df84a62cfd29fd47ac86e","affectsGlobalScope":true,"impliedFormat":1},{"version":"195daca651dde22f2167ac0d0a05e215308119a3100f5e6268e8317d05a92526","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b11e4285cd2bb164a4dc09248bdec69e9842517db4ca47c1ba913011e44ff2f","affectsGlobalScope":true,"impliedFormat":1},{"version":"0508571a52475e245b02bc50fa1394065a0a3d05277fbf5120c3784b85651799","affectsGlobalScope":true,"impliedFormat":1},{"version":"8f9af488f510c3015af3cc8c267a9e9d96c4dd38a1fdff0e11dc5a544711415b","affectsGlobalScope":true,"impliedFormat":1},{"version":"fc611fea8d30ea72c6bbfb599c9b4d393ce22e2f5bfef2172534781e7d138104","affectsGlobalScope":true,"impliedFormat":1},{"version":"f128dae7c44d8f35ee42e0a437000a57c9f06cc04f8b4fb42eebf44954d53dc8","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ecb8e347cb6b2a8927c09b86263663289418df375f5e68e11a0ae683776978f","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ce14b81c5cc821994aa8ec1d42b220dd41b27fcc06373bce3958af7421b77d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3a048b3e9302ef9a34ef4ebb9aecfb28b66abb3bce577206a79fee559c230da","affectsGlobalScope":true,"impliedFormat":1},"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9","69274d91266b9bbba0f5d6f65075cace2a539c739fe73f22dfa053d7c013ebf9","5c0bf3f655393a93f5ac0894660863c4ce0c90062c17b5860950c432876e7fc8","81c42c754119ef4c29959980f1bde23bbe03a1b86177a8f968b2b4cbaafc1bcc","c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","0fb490a6869ddea3ec75f5f6d5a21054f82ce8cd60d472f9a1c70d42e295d4ac","ac1aadc908543ce94afbced5b8cc2d1b94b3b795a303e4c242004031b183765c","c30ca61bc62858baaf36ea887fba9d0032a5e060407a1deb3bf4dd38be64361b","9fb602236e65c57126f2d090c9968fd7ff6e406c350039e76831de069cc9d1f5","ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae","7ff10c73aab4f126ea1d1f7cd40c2b6c9057c974bde0fb75972d677f7ae67c26","3fdf6a42927e85ed94cc06a55b53b92bb0ab3f529fd3ffe15156a96748222915","2f59322b90429e64312dc6e75c9ed31123b0743e7358272cb5b42a586b5894ae","4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3",{"version":"41849007e704926b0a90d541cd4b27cb24ce250c86dae8cef37df96e55aaef21","signature":"dbe5e2e1be30c88d4492b8aaae9802d4bb9be42f992db4845a63fafc94d2b63b"},"42b300f515d975d3bf5777324b55b2231a7a7ae1c3a5d659248709cbbb987f9d","7446b5cbee5a79ada2657125cef88e0e64c722e35946da99f17515c645b4717f",{"version":"fa047096cf13a1fe0b45b2b4672e95fad831fc9a77be0516361eae6ec9454a3f","signature":"570cb6046f537533b9f8681667833b1bb6d5b57f002ca20169b4ea59a04c07b6"},"04adb19af4de59b923b996250d36447eed0cadec0a416ef7e4ded64a7afbe589",{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc2110f7decca6bfb9392e30421cfa1436479e4a6756e8fec6cbc22625d4f881","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"4137ebf04166f3a325f056aa56101adc75e9dceb30404a1844eb8604d89770e2","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"98498b101803bb3dde9f76a56e65c14b75db1cc8bec5f4db72be541570f74fc5","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"d2ae155afe8a01cc0ae612d99117cf8ef16692ba7c4366590156fdec1bcf2d8c","impliedFormat":1},{"version":"3f5e5d9be35913db9fea42a63f3df0b7e3c8703b97670a2125587b4dbbd56d7c","impliedFormat":1},{"version":"8caeb65fdc3bfe0d13f86f67324fcb2d858ed1c55f1f0cce892eb1acfb9f3239","impliedFormat":1},{"version":"57c23df0b5f7a8e26363a3849b0bc7763f6b241207157c8e40089d1df4116f35","affectsGlobalScope":true,"impliedFormat":1},{"version":"3b8bc0c17b54081b0878673989216229e575d67a10874e84566a21025a2461ee","impliedFormat":1},{"version":"5b0db5a58b73498792a29bfebc333438e61906fef75da898b410e24e52229e6f","impliedFormat":1},{"version":"dbe055b2b29a7bab2c1ca8f259436306adb43f469dca7e639a02cd3695d3f621","impliedFormat":1},{"version":"1678b04557dca52feab73cc67610918a7f5e25bfdba3e7fa081acd625d93106d","impliedFormat":1},{"version":"e3905f6902f0b69e5eefc230daa69fdd4ab707a973ec2d086d65af1b3ea47ef0","impliedFormat":1},{"version":"2ea729503db9793f2691162fec3dd1118cab62e96d025f8eeb376d43ec293395","impliedFormat":1},{"version":"9ec87fea42b92894b0f209931a880789d43c3397d09dd99c631ae40a2f7071d1","impliedFormat":1},{"version":"c68e88cdfadfb6c8ba5fc38e58a3a166b0beae77b1f05b7d921150a32a5ffb8d","impliedFormat":1},{"version":"2bc7aa4fba46df0bd495425a7c8201437a7d465f83854fac859df2d67f664df3","impliedFormat":1},{"version":"41d17e1ad9a002feb11c8cdd2777e5bbc0cdb1e3f595d237e4dded0b6949983b","impliedFormat":1},{"version":"07e4e61e946a9c15045539ecd5f5d2d02e7aab6fa82567826857e09cf0f37c2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"1c4714ccc29149efb8777a1da0b04b8d2258f5d13ddbf4cd3c3d361fb531ac86","impliedFormat":1},{"version":"3ff275f84f89f8a7c0543da838f9da9614201abc4ce74c533029825adfb4433d","impliedFormat":1},{"version":"0eb5d0cbf09de5d34542b977fd6a933bb2e0817bffe8e1a541b2f1ad1b9af1ff","impliedFormat":1},{"version":"10deca769dfed888051b1808d6746f8883a490a707f8bdf9367079146987d6d0","impliedFormat":1},{"version":"2c2bdaa1d8ead9f68628d6d9d250e46ee8e81aa4898b4769a36956ae15e060fe","impliedFormat":1},{"version":"c32c840c62d8bd7aeb3147aa6754cd2d922b990a6b6634530cb2ebdce5adc8e9","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"82b91e4e42e6c41bc7fc1b6c2dc5eba6a2ba98375eb1f210e6ff6bba2d54177e","impliedFormat":1},{"version":"6fe28249ac0c7bc19a79aa9264baf00efbd080e868dbe1d3052033ad1c64f206","affectsGlobalScope":true,"impliedFormat":1},{"version":"cbed824fec91efefc7bbdcb8b43d1a531fdbebd0e2ef19481501ff365a93cb70","impliedFormat":1},{"version":"4967529644e391115ca5592184d4b63980569adf60ee685f968fd59ab1557188","impliedFormat":1},{"version":"d0716593b3f2b0451bcf0c24cfa86dec2235c325c89f201934248b7c742715fc","impliedFormat":1},{"version":"ec501101c2a96133a6c695f934c8f6642149cc728571b29cbb7b770984c1088e","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"2991bca2cc0f0628a278df2a2ccdb8d6cbcb700f3761abbed62bba137d5b1790","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"230763250f20449fa7b3c9273e1967adb0023dc890d4be1553faca658ee65971","impliedFormat":1},{"version":"c3e9078b60cb329d1221f5878e88cecfa3e74460550e605a58fcfb41a66029ff","impliedFormat":1},{"version":"a74edb3bab7394a9dbde529d60632be590def2f5f01024dbd85441587fbfbbe0","impliedFormat":1},{"version":"0ea59f7d3e51440baa64f429253759b106cfcbaf51e474cae606e02265b37cf8","impliedFormat":1},{"version":"bc18a1991ba681f03e13285fa1d7b99b03b67ee671b7bc936254467177543890","impliedFormat":1},{"version":"00049ccc87f3f37726db03c01ca68fe74fd9c0109b68c29eb9923ebec2c76b13","impliedFormat":1},{"version":"fa94bbf532b7af8f394b95fa310980d6e20bd2d4c871c6a6cb9f70f03750a44b","impliedFormat":1},{"version":"68d3f35108e2608b1f2f28b36d19d7055f31c4465cc5692cbd06c716a9fe7973","impliedFormat":1},{"version":"a6d543044570fbeed13a7f9925a868081cd2b14ef59cdd9da6ae76d41cab03d3","affectsGlobalScope":true,"impliedFormat":1},{"version":"7fa2214bb0d64701bc6f9ce8cde2fd2ff8c571e0b23065fa04a8a5a6beb91511","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"016b29bf4926b80255a108c53a1451717350059da04fcae64d1075f5e93bbb39","impliedFormat":1},{"version":"841983e39bd4cbb463be385e92fda11057cab368bf27100a801c492f1d86cbaa","impliedFormat":1},{"version":"6f5383b3df1cdf4ff1aa7fb0850f77042b5786b5e65ec9a9b6be56ebfe4d9036","impliedFormat":1},{"version":"62fc21ed9ccbd83bd1166de277a4b5daaa8d15b5fa614c75610d20f3b73fba87","impliedFormat":1},{"version":"e4156ddb25aa0e3b5303d372f26957b36778f0f6bbd4326359269873295e3058","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc1b433a84cae05ddc5672d4823170af78606ad21ecef60dbc4570190cbf1357","impliedFormat":1},{"version":"9d3821bc75c59577e52643324cec92fc2145642e8d17cf7ee07a3181f21d985d","impliedFormat":1},{"version":"7f78cfb2b343838612c192cb251746e3a7c62ac7675726a47e130d9b213f6580","impliedFormat":1},{"version":"201db9cf1687fab1adf5282fcba861f382b32303dc4f67c89d59655e78a25461","impliedFormat":1},{"version":"c77fb31bc17fd241d3922a9f88c59e3361cdf76d1328ba9412fc6bf7310b638d","impliedFormat":1},{"version":"0a20eaf2e4b1e3c1e1f87f7bccb0c936375b23b022baeea750519b7c9bc6ce83","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"a16b91b27bd6b706c687c88cbc8a7d4ee98e5ed6043026d6b84bda923c0aed67","impliedFormat":1},{"version":"694b812e0ed11285e8822cf8131e3ce7083a500b3b1d185fff9ed1089677bd0a","impliedFormat":1},{"version":"99ab6d0d660ce4d21efb52288a39fd35bb3f556980ec5463b1ae8f304a3bbc85","impliedFormat":1},{"version":"6eeded8c7e352be6e0efb83f4935ec752513c4d22043b52522b90849a49a3a11","impliedFormat":1},{"version":"6c1ad90050ffbb151cacc68e2d06ea1a26a945659391e32651f5d42b86fd7f2c","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"0d759cc99e081cacd0352467a0c24e979a6ef748329aa6ddea2d789664580201","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"47767435860d3f8dccb0f6263bdca9ad112058014e1802e63c32bd0907e5c550","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"00a196792eed6e9b7f988db0d3ced11a94ecd1e258fd19124ce89fe7642df35a","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,79]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[231,1],[142,2],[143,2],[144,3],[82,4],[145,5],[146,6],[147,7],[80,8],[148,9],[149,10],[150,11],[151,12],[152,13],[153,14],[154,14],[155,15],[156,16],[157,17],[158,18],[83,8],[81,8],[159,19],[160,20],[161,21],[202,22],[162,23],[163,24],[164,23],[165,25],[166,26],[168,27],[169,28],[170,28],[171,28],[172,29],[173,30],[174,31],[175,32],[176,33],[177,34],[178,34],[179,35],[180,8],[181,8],[182,36],[183,37],[184,36],[185,38],[186,39],[187,40],[188,41],[189,42],[190,43],[191,44],[192,45],[193,46],[194,47],[195,48],[196,49],[197,50],[198,51],[199,52],[84,23],[85,8],[86,53],[87,54],[88,8],[89,55],[90,8],[133,56],[134,57],[135,58],[136,58],[137,59],[138,8],[139,60],[140,61],[141,57],[200,62],[201,63],[167,8],[207,64],[229,8],[228,8],[222,65],[209,66],[208,8],[205,67],[210,8],[203,68],[211,8],[230,69],[212,8],[206,8],[221,70],[223,71],[204,72],[227,73],[225,74],[224,75],[226,76],[213,8],[219,77],[216,78],[218,79],[217,80],[215,81],[214,8],[220,82],[59,8],[60,8],[10,8],[12,8],[11,8],[2,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],[20,8],[3,8],[21,8],[22,8],[4,8],[23,8],[27,8],[24,8],[25,8],[26,8],[28,8],[29,8],[30,8],[5,8],[31,8],[32,8],[33,8],[34,8],[6,8],[38,8],[35,8],[36,8],[37,8],[39,8],[7,8],[40,8],[45,8],[46,8],[41,8],[42,8],[43,8],[44,8],[8,8],[50,8],[47,8],[48,8],[49,8],[51,8],[9,8],[52,8],[53,8],[54,8],[56,8],[55,8],[57,8],[1,8],[58,8],[109,83],[121,84],[106,85],[122,86],[131,87],[97,88],[98,89],[96,90],[130,91],[125,92],[129,93],[100,94],[118,95],[99,96],[128,97],[94,98],[95,92],[101,99],[102,8],[108,100],[105,99],[92,101],[132,102],[123,103],[112,104],[111,99],[113,105],[116,106],[110,107],[114,108],[126,91],[103,109],[104,110],[117,111],[93,86],[120,112],[119,99],[107,110],[115,113],[124,8],[91,8],[127,114],[69,115],[70,116],[68,117],[72,118],[73,54],[61,8],[66,119],[67,120],[63,121],[65,54],[64,122],[71,123],[62,8],[78,124],[79,125],[75,8],[77,126],[76,121],[74,8]],"affectedFilesPendingEmit":[[69,17],[70,17],[68,17],[72,17],[73,17],[61,17],[66,17],[67,17],[63,17],[65,17],[64,17],[71,17],[62,17],[78,17],[79,17],[75,17],[77,17],[76,17],[74,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79],"version":"6.0.3"}
\ No newline at end of file
diff --git a/packages/mcp-mf-certificados/package.json b/packages/mcp-mf-certificados/package.json
new file mode 100644
index 00000000..ff060b50
--- /dev/null
+++ b/packages/mcp-mf-certificados/package.json
@@ -0,0 +1,21 @@
+{
+  "name": "@egos/mcp-mf-certificados",
+  "version": "1.0.0",
+  "description": "MCP Server limitado para a IA do Miguel (MF Certificados) interagir com EGOS",
+  "main": "dist/index.js",
+  "types": "dist/index.d.ts",
+  "type": "module",
+  "scripts": {
+    "build": "tsc",
+    "start": "node dist/index.js",
+    "dev": "bun run src/index.ts"
+  },
+  "dependencies": {
+    "@modelcontextprotocol/sdk": "^1.10.0",
+    "zod": "^3.23.8"
+  },
+  "devDependencies": {
+    "typescript": "^5.4.5",
+    "@types/node": "^20.12.7"
+  }
+}
diff --git a/packages/mcp-mf-certificados/src/index.ts b/packages/mcp-mf-certificados/src/index.ts
new file mode 100644
index 00000000..feb29e04
--- /dev/null
+++ b/packages/mcp-mf-certificados/src/index.ts
@@ -0,0 +1,90 @@
+import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
+import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
+import { z } from "zod";
+
+const server = new McpServer({
+  name: "egos-mcp-mf-certificados",
+  version: "1.0.0",
+});
+
+// Tool: Diagnóstico de Certificação
+server.tool(
+  "diagnosticar_certificacao",
+  "Realiza o diagnóstico inicial para identificar gap de certificação e orienta a melhor solução ICP-Brasil",
+  {
+    documento: z.string().describe("CNPJ ou CPF do cliente (apenas números ou com máscara)"),
+    tipo_cliente: z.enum(["pj", "pf"]).describe("Tipo de cliente: Pessoa Jurídica ou Pessoa Física"),
+    ramo_atividade: z.string().optional().describe("Ramo de atividade se for PJ (ex: contabilidade, medicina, comércio)"),
+  },
+  async (args: { documento: string; tipo_cliente: "pj" | "pf"; ramo_atividade?: string }) => {
+    const { documento, tipo_cliente, ramo_atividade } = args;
+    const isSaude = ramo_atividade?.toLowerCase().includes("medic") || ramo_atividade?.toLowerCase().includes("saude");
+    const isContabilidade = ramo_atividade?.toLowerCase().includes("contab");
+
+    let recomendacao = "";
+    if (tipo_cliente === "pj") {
+      recomendacao = "Recomendação: e-CNPJ A1 (para agilidade e nuvem) ou A3 (token físico) dependendo do ERP.";
+      if (isContabilidade) {
+        recomendacao += " Avaliar procurações eletrônicas e e-CPF para os sócios.";
+      }
+    } else {
+      recomendacao = "Recomendação: e-CPF A3 (mídia criptográfica) para advogados e médicos, ou e-CPF A1 para rotinas gerais.";
+      if (isSaude) {
+        recomendacao = "Recomendação Crítica: e-CPF A3 CRM/CRM-Digital ou e-Médico obrigatório para prescrição eletrônica.";
+      }
+    }
+
+    return {
+      content: [{
+        type: "text" as const,
+        text: JSON.stringify({
+          status: "diagnostico_concluido",
+          documento_analisado: documento,
+          risco_compliance: isSaude || isContabilidade ? "ALTO" : "MÉDIO",
+          recomendacao_oficial: recomendacao,
+          next_step: "Agendar emissão por videoconferência com a equipe MF.",
+        }, null, 2),
+      }],
+    };
+  }
+);
+
+// Tool: Buscar Diretrizes ICP-Brasil
+server.tool(
+  "buscar_diretrizes_icp_brasil",
+  "Busca resumo normativo e validade jurídica para casos de uso de certificados digitais",
+  {
+    caso_de_uso: z.string().describe("Caso de uso a ser pesquisado (ex: prescricao medica, assinatura de contratos, emissao nfe)"),
+  },
+  async (args: { caso_de_uso: string }) => {
+    const { caso_de_uso } = args;
+    const term = caso_de_uso.toLowerCase();
+    let normativas = "";
+
+    if (term.includes("medica") || term.includes("saude") || term.includes("prescricao")) {
+      normativas = "Portaria MS nº 467/2020: Prescrições eletrônicas devem ser assinadas com certificado digital ICP-Brasil válido (Padrão e-CPF A3/CRM).";
+    } else if (term.includes("nfe") || term.includes("nota fiscal")) {
+      normativas = "A emissão de NF-e requer certificado digital ICP-Brasil de pessoa jurídica (e-CNPJ) ou procurador homologado.";
+    } else {
+      normativas = "Medida Provisória nº 2.200-2/2001: Documentos assinados com certificado digital ICP-Brasil possuem a mesma validade jurídica que assinaturas de próprio punho reconhecidas em cartório.";
+    }
+
+    return {
+      content: [{
+        type: "text" as const,
+        text: `Diretrizes Oficiais (MF Certificados Knowledge Base):\n${normativas}\n\nNota: Para validação completa, consulte a assessoria jurídica ou o suporte N2 da MF.`,
+      }],
+    };
+  }
+);
+
+async function main() {
+  const transport = new StdioServerTransport();
+  await server.connect(transport);
+  console.error("EGOS MCP MF-Certificados started.");
+}
+
+main().catch((err) => {
+  console.error("Error starting MCP server:", err);
+  process.exit(1);
+});
diff --git a/packages/mcp-mf-certificados/tsconfig.json b/packages/mcp-mf-certificados/tsconfig.json
new file mode 100644
index 00000000..4a7619fd
--- /dev/null
+++ b/packages/mcp-mf-certificados/tsconfig.json
@@ -0,0 +1,15 @@
+{
+  "compilerOptions": {
+    "target": "ES2022",
+    "module": "NodeNext",
+    "moduleResolution": "NodeNext",
+    "lib": ["ES2022"],
+    "outDir": "./dist",
+    "rootDir": "./src",
+    "strict": true,
+    "esModuleInterop": true,
+    "skipLibCheck": true,
+    "forceConsistentCasingInFileNames": true
+  },
+  "include": ["src/**/*"]
+}
diff --git a/scripts/busca-global.ts b/scripts/busca-global.ts
new file mode 100644
index 00000000..dd0a3f9a
--- /dev/null
+++ b/scripts/busca-global.ts
@@ -0,0 +1,86 @@
+import { spawn } from "bun";
+import { readFileSync, existsSync } from "fs";
+import { join } from "path";
+
+interface LeafRepo {
+  name: string;
+  path: string;
+  description: string;
+  alias_of?: string;
+}
+
+interface LeafReposRegistry {
+  leaf_repos: LeafRepo[];
+}
+
+const KERNEL_PATH = "/home/enio/egos";
+const LEAF_REPOS_FILE = join(KERNEL_PATH, "agents/registry/leaf-repos.json");
+
+async function run() {
+  const args = process.argv.slice(2);
+  if (args.length === 0 || args[0] === "-h" || args[0] === "--help") {
+    console.log("Uso: bun run scripts/busca-global.ts <termo_regex> [--files-only]");
+    console.log("Busca global e distribuída (ripgrep) por todos os repositórios cadastrados no EGOS kernel.");
+    process.exit(0);
+  }
+
+  const query = args[0];
+  const filesOnly = args.includes("--files-only");
+
+  if (!existsSync(LEAF_REPOS_FILE)) {
+    console.error(`Erro: Arquivo leaf-repos não encontrado em ${LEAF_REPOS_FILE}`);
+    process.exit(1);
+  }
+
+  const registry: LeafReposRegistry = JSON.parse(readFileSync(LEAF_REPOS_FILE, "utf-8"));
+  
+  // Pegar todos os paths únicos (ignorar alias_of para evitar duplicidade de busca)
+  const pathsToSearch = [KERNEL_PATH]; // Inclui o Kernel também
+  
+  for (const repo of registry.leaf_repos) {
+    if (!repo.alias_of && existsSync(repo.path)) {
+      pathsToSearch.push(repo.path);
+    }
+  }
+
+  console.log(`🔍 Iniciando busca global pelo termo: "${query}"`);
+  console.log(`📁 Repositórios a buscar: ${pathsToSearch.length}`);
+  
+  const rgArgs = ["rg", "-i", query, ...pathsToSearch];
+  if (filesOnly) {
+    rgArgs.splice(1, 0, "-l"); // Insere -l depois de rg
+  }
+  
+  const proc = spawn({
+    cmd: rgArgs,
+    stdout: "pipe",
+    stderr: "pipe",
+  });
+
+  const rawOut = await new Response(proc.stdout).text();
+  const rawErr = await new Response(proc.stderr).text();
+  
+  if (rawErr) {
+    console.error("Avisos/Erros:", rawErr);
+  }
+  
+  if (rawOut) {
+    const lines = rawOut.split('\n').filter(Boolean);
+    console.log(`✅ Busca concluída. ${lines.length} ocorrências encontradas.`);
+    if (filesOnly) {
+       console.log(rawOut);
+    } else {
+       // Se não for filesOnly, limite a saída para não estourar tokens se for enorme.
+       if (lines.length > 300) {
+          console.log(lines.slice(0, 300).join('\n'));
+          console.log(`\n... (e mais ${lines.length - 300} resultados truncados). Use --files-only para ver os arquivos ou refine a busca.`);
+       } else {
+          console.log(rawOut);
+       }
+    }
+  } else {
+    console.log("Nenhum resultado encontrado.");
+  }
+}
+
+run().catch(console.error);
diff --git a/scripts/egos-monitor.sh b/scripts/egos-monitor.sh
index b62dc734..3f8fdc62 100755
--- a/scripts/egos-monitor.sh
+++ b/scripts/egos-monitor.sh
@@ -53,11 +53,23 @@ fi
 ESC_COUNT=0
 [ -f "$ESCALATION" ] && ESC_COUNT=$(wc -l < "$ESCALATION" 2>/dev/null | tr -d ' \n\r\t' || echo 0)
 
+# --- 5.5. Handoff Queue ---
+HANDOFF_COUNT=0
+HANDOFF_ALERT=""
+if [ -d "docs/_current_handoffs" ]; then
+  # check files older than 3 minutes using find
+  STALE_HANDOFFS=$(find docs/_current_handoffs -type f -name "*.md" -mmin +3 2>/dev/null || true)
+  if [ -n "$STALE_HANDOFFS" ]; then
+    HANDOFF_COUNT=$(echo "$STALE_HANDOFFS" | wc -l | tr -d ' \n\r\t')
+    HANDOFF_ALERT="🚨 ALERTA P0: Handoff ignorado pelo Prime! ($HANDOFF_COUNT arquivo(s) >3min)"
+  fi
+fi
+
 # --- 6. Output: IDLE (1 linha) ou ALERT (contextual) ---
 IDLE_BB="$( [ "$BB_STATUS" = "ok" ] || [ "$BB_STATUS" = "absent" ] && echo 1 || echo 0 )"
 
 if [ -z "$REMOTE_DELTA" ] && [ "$WT_MODIFIED" -eq 0 ] && \
-   [ "$IDLE_BB" = "1" ] && [ "$ESC_COUNT" -eq 0 ] && [ -z "$RENAMES" ]; then
+   [ "$IDLE_BB" = "1" ] && [ "$ESC_COUNT" -eq 0 ] && [ -z "$RENAMES" ] && [ "$HANDOFF_COUNT" -eq 0 ]; then
   echo "✅ IDLE | $BRT | no_delta | wt_clean | bb=${BB_STATUS} | esc=0"
   exit 0
 fi
@@ -88,4 +100,10 @@ if [ "$ESC_COUNT" -gt 0 ]; then
   echo "🚨 ESCALATION_QUEUE: $ESC_COUNT itens pendentes"
 fi
 
+if [ "$HANDOFF_COUNT" -gt 0 ]; then
+  echo "$HANDOFF_ALERT"
+  echo "$STALE_HANDOFFS" | sed 's/^/  - /'
+  echo "👉 AÇÃO: Rode '/refresh' no Claude Code ou force-o a ler a pasta."
+fi
+
 echo "─────────────────────────────"
diff --git a/tsconfig.json b/tsconfig.json
index 0de2525f..a71c21a1 100644
--- a/tsconfig.json
+++ b/tsconfig.json
@@ -57,6 +57,7 @@
     "packages/knowledge-mcp",
     "packages/guard-brasil-langchain",
     "packages/guard-brasil-python",
-    "packages/shared/src/intelink-llm-router.ts"
+    "packages/shared/src/intelink-llm-router.ts",
+    "packages/mcp-mf-certificados"
   ]
 }

exec
/bin/bash -lc 'cat package.json && git diff b6d613ad4ff426fadbaac25d9da8c144eff07dcb -- scripts/busca-global.ts packages/mcp-mf-certificados/src/index.ts packages/mcp-mf-certificados/package.json tsconfig.json scripts/egos-monitor.sh' in /home/enio/egos
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
diff --git a/packages/mcp-mf-certificados/package.json b/packages/mcp-mf-certificados/package.json
new file mode 100644
index 00000000..ff060b50
--- /dev/null
+++ b/packages/mcp-mf-certificados/package.json
@@ -0,0 +1,21 @@
+{
+  "name": "@egos/mcp-mf-certificados",
+  "version": "1.0.0",
+  "description": "MCP Server limitado para a IA do Miguel (MF Certificados) interagir com EGOS",
+  "main": "dist/index.js",
+  "types": "dist/index.d.ts",
+  "type": "module",
+  "scripts": {
+    "build": "tsc",
+    "start": "node dist/index.js",
+    "dev": "bun run src/index.ts"
+  },
+  "dependencies": {
+    "@modelcontextprotocol/sdk": "^1.10.0",
+    "zod": "^3.23.8"
+  },
+  "devDependencies": {
+    "typescript": "^5.4.5",
+    "@types/node": "^20.12.7"
+  }
+}
diff --git a/packages/mcp-mf-certificados/src/index.ts b/packages/mcp-mf-certificados/src/index.ts
new file mode 100644
index 00000000..feb29e04
--- /dev/null
+++ b/packages/mcp-mf-certificados/src/index.ts
@@ -0,0 +1,90 @@
+import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
+import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
+import { z } from "zod";
+
+const server = new McpServer({
+  name: "egos-mcp-mf-certificados",
+  version: "1.0.0",
+});
+
+// Tool: Diagnóstico de Certificação
+server.tool(
+  "diagnosticar_certificacao",
+  "Realiza o diagnóstico inicial para identificar gap de certificação e orienta a melhor solução ICP-Brasil",
+  {
+    documento: z.string().describe("CNPJ ou CPF do cliente (apenas números ou com máscara)"),
+    tipo_cliente: z.enum(["pj", "pf"]).describe("Tipo de cliente: Pessoa Jurídica ou Pessoa Física"),
+    ramo_atividade: z.string().optional().describe("Ramo de atividade se for PJ (ex: contabilidade, medicina, comércio)"),
+  },
+  async (args: { documento: string; tipo_cliente: "pj" | "pf"; ramo_atividade?: string }) => {
+    const { documento, tipo_cliente, ramo_atividade } = args;
+    const isSaude = ramo_atividade?.toLowerCase().includes("medic") || ramo_atividade?.toLowerCase().includes("saude");
+    const isContabilidade = ramo_atividade?.toLowerCase().includes("contab");
+
+    let recomendacao = "";
+    if (tipo_cliente === "pj") {
+      recomendacao = "Recomendação: e-CNPJ A1 (para agilidade e nuvem) ou A3 (token físico) dependendo do ERP.";
+      if (isContabilidade) {
+        recomendacao += " Avaliar procurações eletrônicas e e-CPF para os sócios.";
+      }
+    } else {
+      recomendacao = "Recomendação: e-CPF A3 (mídia criptográfica) para advogados e médicos, ou e-CPF A1 para rotinas gerais.";
+      if (isSaude) {
+        recomendacao = "Recomendação Crítica: e-CPF A3 CRM/CRM-Digital ou e-Médico obrigatório para prescrição eletrônica.";
+      }
+    }
+
+    return {
+      content: [{
+        type: "text" as const,
+        text: JSON.stringify({
+          status: "diagnostico_concluido",
+          documento_analisado: documento,
+          risco_compliance: isSaude || isContabilidade ? "ALTO" : "MÉDIO",
+          recomendacao_oficial: recomendacao,
+          next_step: "Agendar emissão por videoconferência com a equipe MF.",
+        }, null, 2),
+      }],
+    };
+  }
+);
+
+// Tool: Buscar Diretrizes ICP-Brasil
+server.tool(
+  "buscar_diretrizes_icp_brasil",
+  "Busca resumo normativo e validade jurídica para casos de uso de certificados digitais",
+  {
+    caso_de_uso: z.string().describe("Caso de uso a ser pesquisado (ex: prescricao medica, assinatura de contratos, emissao nfe)"),
+  },
+  async (args: { caso_de_uso: string }) => {
+    const { caso_de_uso } = args;
+    const term = caso_de_uso.toLowerCase();
+    let normativas = "";
+
+    if (term.includes("medica") || term.includes("saude") || term.includes("prescricao")) {
+      normativas = "Portaria MS nº 467/2020: Prescrições eletrônicas devem ser assinadas com certificado digital ICP-Brasil válido (Padrão e-CPF A3/CRM).";
+    } else if (term.includes("nfe") || term.includes("nota fiscal")) {
+      normativas = "A emissão de NF-e requer certificado digital ICP-Brasil de pessoa jurídica (e-CNPJ) ou procurador homologado.";
+    } else {
+      normativas = "Medida Provisória nº 2.200-2/2001: Documentos assinados com certificado digital ICP-Brasil possuem a mesma validade jurídica que assinaturas de próprio punho reconhecidas em cartório.";
+    }
+
+    return {
+      content: [{
+        type: "text" as const,
+        text: `Diretrizes Oficiais (MF Certificados Knowledge Base):\n${normativas}\n\nNota: Para validação completa, consulte a assessoria jurídica ou o suporte N2 da MF.`,
+      }],
+    };
+  }
+);
+
+async function main() {
+  const transport = new StdioServerTransport();
+  await server.connect(transport);
+  console.error("EGOS MCP MF-Certificados started.");
+}
+
+main().catch((err) => {
+  console.error("Error starting MCP server:", err);
+  process.exit(1);
+});
diff --git a/scripts/busca-global.ts b/scripts/busca-global.ts
new file mode 100644
index 00000000..dd0a3f9a
--- /dev/null
+++ b/scripts/busca-global.ts
@@ -0,0 +1,86 @@
+import { spawn } from "bun";
+import { readFileSync, existsSync } from "fs";
+import { join } from "path";
+
+interface LeafRepo {
+  name: string;
+  path: string;
+  description: string;
+  alias_of?: string;
+}
+
+interface LeafReposRegistry {
+  leaf_repos: LeafRepo[];
+}
+
+const KERNEL_PATH = "/home/enio/egos";
+const LEAF_REPOS_FILE = join(KERNEL_PATH, "agents/registry/leaf-repos.json");
+
+async function run() {
+  const args = process.argv.slice(2);
+  if (args.length === 0 || args[0] === "-h" || args[0] === "--help") {
+    console.log("Uso: bun run scripts/busca-global.ts <termo_regex> [--files-only]");
+    console.log("Busca global e distribuída (ripgrep) por todos os repositórios cadastrados no EGOS kernel.");
+    process.exit(0);
+  }
+
+  const query = args[0];
+  const filesOnly = args.includes("--files-only");
+
+  if (!existsSync(LEAF_REPOS_FILE)) {
+    console.error(`Erro: Arquivo leaf-repos não encontrado em ${LEAF_REPOS_FILE}`);
+    process.exit(1);
+  }
+
+  const registry: LeafReposRegistry = JSON.parse(readFileSync(LEAF_REPOS_FILE, "utf-8"));
+  
+  // Pegar todos os paths únicos (ignorar alias_of para evitar duplicidade de busca)
+  const pathsToSearch = [KERNEL_PATH]; // Inclui o Kernel também
+  
+  for (const repo of registry.leaf_repos) {
+    if (!repo.alias_of && existsSync(repo.path)) {
+      pathsToSearch.push(repo.path);
+    }
+  }
+
+  console.log(`🔍 Iniciando busca global pelo termo: "${query}"`);
+  console.log(`📁 Repositórios a buscar: ${pathsToSearch.length}`);
+  
+  const rgArgs = ["rg", "-i", query, ...pathsToSearch];
+  if (filesOnly) {
+    rgArgs.splice(1, 0, "-l"); // Insere -l depois de rg
+  }
+  
+  const proc = spawn({
+    cmd: rgArgs,
+    stdout: "pipe",
+    stderr: "pipe",
+  });
+
+  const rawOut = await new Response(proc.stdout).text();
+  const rawErr = await new Response(proc.stderr).text();
+  
+  if (rawErr) {
+    console.error("Avisos/Erros:", rawErr);
+  }
+  
+  if (rawOut) {
+    const lines = rawOut.split('\n').filter(Boolean);
+    console.log(`✅ Busca concluída. ${lines.length} ocorrências encontradas.`);
+    if (filesOnly) {
+       console.log(rawOut);
+    } else {
+       // Se não for filesOnly, limite a saída para não estourar tokens se for enorme.
+       if (lines.length > 300) {
+          console.log(lines.slice(0, 300).join('\n'));
+          console.log(`\n... (e mais ${lines.length - 300} resultados truncados). Use --files-only para ver os arquivos ou refine a busca.`);
+       } else {
+          console.log(rawOut);
+       }
+    }
+  } else {
+    console.log("Nenhum resultado encontrado.");
+  }
+}
+
+run().catch(console.error);
diff --git a/scripts/egos-monitor.sh b/scripts/egos-monitor.sh
index b62dc734..3f8fdc62 100755
--- a/scripts/egos-monitor.sh
+++ b/scripts/egos-monitor.sh
@@ -53,11 +53,23 @@ fi
 ESC_COUNT=0
 [ -f "$ESCALATION" ] && ESC_COUNT=$(wc -l < "$ESCALATION" 2>/dev/null | tr -d ' \n\r\t' || echo 0)
 
+# --- 5.5. Handoff Queue ---
+HANDOFF_COUNT=0
+HANDOFF_ALERT=""
+if [ -d "docs/_current_handoffs" ]; then
+  # check files older than 3 minutes using find
+  STALE_HANDOFFS=$(find docs/_current_handoffs -type f -name "*.md" -mmin +3 2>/dev/null || true)
+  if [ -n "$STALE_HANDOFFS" ]; then
+    HANDOFF_COUNT=$(echo "$STALE_HANDOFFS" | wc -l | tr -d ' \n\r\t')
+    HANDOFF_ALERT="🚨 ALERTA P0: Handoff ignorado pelo Prime! ($HANDOFF_COUNT arquivo(s) >3min)"
+  fi
+fi
+
 # --- 6. Output: IDLE (1 linha) ou ALERT (contextual) ---
 IDLE_BB="$( [ "$BB_STATUS" = "ok" ] || [ "$BB_STATUS" = "absent" ] && echo 1 || echo 0 )"
 
 if [ -z "$REMOTE_DELTA" ] && [ "$WT_MODIFIED" -eq 0 ] && \
-   [ "$IDLE_BB" = "1" ] && [ "$ESC_COUNT" -eq 0 ] && [ -z "$RENAMES" ]; then
+   [ "$IDLE_BB" = "1" ] && [ "$ESC_COUNT" -eq 0 ] && [ -z "$RENAMES" ] && [ "$HANDOFF_COUNT" -eq 0 ]; then
   echo "✅ IDLE | $BRT | no_delta | wt_clean | bb=${BB_STATUS} | esc=0"
   exit 0
 fi
@@ -88,4 +100,10 @@ if [ "$ESC_COUNT" -gt 0 ]; then
   echo "🚨 ESCALATION_QUEUE: $ESC_COUNT itens pendentes"
 fi
 
+if [ "$HANDOFF_COUNT" -gt 0 ]; then
+  echo "$HANDOFF_ALERT"
+  echo "$STALE_HANDOFFS" | sed 's/^/  - /'
+  echo "👉 AÇÃO: Rode '/refresh' no Claude Code ou force-o a ler a pasta."
+fi
+
 echo "─────────────────────────────"
diff --git a/tsconfig.json b/tsconfig.json
index 0de2525f..a71c21a1 100644
--- a/tsconfig.json
+++ b/tsconfig.json
@@ -57,6 +57,7 @@
     "packages/knowledge-mcp",
     "packages/guard-brasil-langchain",
     "packages/guard-brasil-python",
-    "packages/shared/src/intelink-llm-router.ts"
+    "packages/shared/src/intelink-llm-router.ts",
+    "packages/mcp-mf-certificados"
   ]
 }

exec
/bin/bash -lc 'bun run typecheck' in /home/enio/egos
 succeeded in 10236ms:
exec
/bin/bash -lc 'cd packages/mcp-mf-certificados && bun run build' in /home/enio/egos
 exited 2 in 23732ms:
src/index.ts(19,3): error TS2589: Type instantiation is excessively deep and possibly infinite.

exec
/bin/bash -lc 'bun scripts/busca-global.ts "mcp-mf-certificados" --files-only' in /home/enio/egos
 succeeded in 960ms:
✅ Busca concluída. 7 ocorrências encontradas.
/home/enio/egos/packages/mcp-mf-certificados/package.json
/home/enio/egos/packages/mcp-mf-certificados/src/index.ts
/home/enio/egos/bun.lock
/home/enio/egos/tsconfig.json
/home/enio/egos/TASKS.md
/home/enio/egos/docs/_current_handoffs/handoff_2026-06-10.md
/home/enio/egos/docs/_current_handoffs/_merge_2026-06-10/egos__main__4cb53dbb.md


exec
/bin/bash -lc 'git diff b6d613ad4ff426fadbaac25d9da8c144eff07dcb -- apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/presentations/curso-ciber-ia-lgpd-lidia.html docs/guard-brasil/EXTENSIBILITY.md docs/jobs/2026-06-10-doc-drift-verifier.json docs/jobs/2026-06-10-pre-commit-pipeline.json' in /home/enio/egos
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
diff --git a/docs/guard-brasil/EXTENSIBILITY.md b/docs/guard-brasil/EXTENSIBILITY.md
index 3977b315..75d1dca5 100644
--- a/docs/guard-brasil/EXTENSIBILITY.md
+++ b/docs/guard-brasil/EXTENSIBILITY.md
@@ -2,7 +2,7 @@
 
 > **SSOT desta arquitetura:** este arquivo.
 > **Código:** `packages/guard-brasil/src/registry/`
-> **Versão:** v0.1.0 — 2026-06-10
+> **Versão:** v0.2.0 — 2026-06-10
 
 ---
 
@@ -161,21 +161,43 @@ Esse trecho é um número de BO? [✅ Sim] [❌ Não] [⚠️ Parcial]
 
 | Perfil | Instituição | Estado | Padrões | Status HITL |
 |---|---|---|---|---|
-| `pcmg` | Polícia Civil MG | MG | 4 | 🔴 Pendente (0 confirmações) |
+| `pcmg` | Polícia Civil MG | MG | 4 | 🟡 v0.2.0 (sessão 2026-06-10: 17/20 corpus, TC→medium) |
+
+---
+
+## Limitações de arquitetura conhecidas
+
+### `deduplicateFindings` — padrão mais curto vence por posição
+
+`pii-scanner.ts:87-91` — a função `deduplicateFindings` mantém o PRIMEIRO match em cada posição de início (`start`), ordenado por `start`. Isso significa: se um padrão built-in (menor) e um padrão customizado (maior) iniciam na mesma posição, o built-in vence.
+
+**Caso concreto (REDS complemento):** o padrão core `reds` detecta `REDS 2024/000123456` (base). O padrão `pcmg:reds_complemento` detecta `REDS 2024/000123456/0032` (com delegacia). Como iniciam na mesma posição, `deduplicateFindings` descarta o complemento. O dado **é detectado** como REDS, mas sem o campo de delegacia.
+
+**Status:** 3 falsos negativos documentados no corpus pcmg (reds-pos-3, reds-pos-4, reds-pos-5). Dado real mascarado como `[REDS REMOVIDO]` — proteção funciona, mas metadado delegacia se perde.
+
+**Solução possível (não implementada):** fazer `reds_complemento` exigir match começando após a base REDS (position-offset), ou inverter a prioridade de padrões customizados sobre built-ins no scanner. Registrar como GUARD-SCANNER-001 se precisar resolver.
+
+**Fix aplicado (FP-002, 2026-06-10):** `placa_antiga` lookahead estendido de `(?![-\d])` para `(?![-\d\/])` — previne `IPL 1234/2024` de ser detectado como placa Mercosul, liberando o padrão `pcmg:inquerito` para capturar corretamente.
 
 ---
 
 ## Roadmap HITL (tasks em TASKS.md)
 
-| Task | O que é | Prioridade |
-|---|---|---|
-| GUARD-HITL-001 | Interface web de revisão (próximo match → confirmar/rejeitar) | P1 |
-| GUARD-HITL-002 | Runner de corpus sintético + relatório de cobertura | P1 |
-| GUARD-HITL-003 | Export/import de perfis como JSON | P2 |
-| GUARD-HITL-004 | Perfis adicionais: TJMG, SES-MG, DETRAN-MG | P2 |
-| GUARD-HITL-005 | API `POST /guard/patterns` para adicionar padrões via UI, sem código | P2 |
-| GUARD-HITL-006 | Ciclo automático: N confirmações → promove → notifica mantenedor | P3 |
+| Task | O que é | Prioridade | Status |
+|---|---|---|---|
+| GUARD-HITL-001 | Review inline no chat: Prime roda runner → Enio confirma matches | P1 | 🟡 Corpus rodado 2026-06-10 (aguarda confirmação final Enio) |
+| GUARD-HITL-002 | Corpus sintético (28 frases) + hitl-runner.ts interativo | P1 | ✅ Entregue (0ee0ae44) |
+| GUARD-HITL-003 | Export/import de perfis como JSON | P2 | 🔴 Pendente |
+| GUARD-HITL-004 | Perfis adicionais: TJMG, SES-MG, DETRAN-MG | P2 | 🔴 Pendente |
+| GUARD-HITL-005 | API `POST /guard/patterns` para adicionar padrões via UI, sem código | P2 | 🔴 Pendente |
+| GUARD-HITL-006 | Ciclo automático: N confirmações → promove → notifica mantenedor | P3 | 🔴 Pendente |
+
+---
+
+## Documentação relacionada
+
+- [BR_AI_REGULATORY_FRAMEWORK.md](BR_AI_REGULATORY_FRAMEWORK.md) — CNJ 615/2025 + MJSP 961/2025 + Sinapses 2.0: framework regulatório para uso de IA local em instituições brasileiras
 
 ---
 
-*EGOS Framework · Guard Brasil v0.2.0 · docs/guard-brasil/EXTENSIBILITY.md*
+*EGOS Framework · Guard Brasil v0.2.0 · docs/guard-brasil/EXTENSIBILITY.md · 2026-06-10*
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..956c637b 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T15:30:30.816Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -71,10 +71,10 @@
       "id": "kernel_packages",
       "description": "Packages in packages/ directory",
       "status": "ok",
-      "last_value": "36",
-      "current_value": "38",
+      "last_value": "39",
+      "current_value": "39",
       "tolerance": "±2",
-      "drift_abs": 2,
+      "drift_abs": 0,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1394",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -173,7 +173,7 @@
       "description": "Pre-commit hook chain has minimum required governance stages",
       "status": "ok",
       "last_value": "70",
-      "current_value": "178",
+      "current_value": "177",
       "tolerance": "min:15",
       "command": "grep -c '\\[' .husky/pre-commit",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 4fed15d9..f3bb27f2 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -238,5 +238,133 @@
     "duration_ms": null,
     "event": "commit:fix files=6 sha=749d8d59",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:56:17.090Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=807ad918",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:07:01.640Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=cbb0006e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:13:39.265Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=4a44ae1b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:19:55.220Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=eb3edd98",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:34:56.370Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=b5b6cf57",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:01:11.829Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b9b56fb8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:03:35.239Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=76304863",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:08:24.054Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=9 sha=aa4bce23",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:12:44.643Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=b2dbeefe",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:24:19.844Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=beccce45",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:31:25.173Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=0ee0ae44",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:32:53.835Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b6d613ad",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T15:30:35.127Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=22 sha=4cb53dbb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T15:33:03.348Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=6 sha=d33a4298",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:12:30.554Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=f1e8c1d9",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/presentations/curso-ciber-ia-lgpd-lidia.html b/docs/presentations/curso-ciber-ia-lgpd-lidia.html
index 76977018..31f57ac0 100644
--- a/docs/presentations/curso-ciber-ia-lgpd-lidia.html
+++ b/docs/presentations/curso-ciber-ia-lgpd-lidia.html
@@ -334,6 +334,12 @@ tr:nth-child(even) td { background: var(--bg); }
     <div class="callout callout-yellow">
       <strong>⚠️ Nota:</strong> este slide apresenta interpretação didática dos Arts. 4º III, §1º, 6º e 20 da LGPD. Não é parecer jurídico. A redação exata dos artigos e eventual norma específica/posicionamento da ANPD devem ser conferidos pelo instrutor antes de ministrar.
     </div>
+    <div class="callout callout-blue" style="margin-top:12px">
+      <strong>📋 Framework regulatório BR aprovado (jun/2026):</strong><br>
+      <strong>CNJ Resolução 615/2025</strong> (11/mar/2025) — governa uso de IA no Poder Judiciário. Arts. chave: Art. 9 (risco proporcional), Art. 13 (HITL obrigatório para decisões de alto risco). Aplica a tribunais estaduais.<br>
+      <strong>Portaria MJSP 961/2025</strong> (24/jun/2025) — governa IA em investigação criminal. Art. 10 (proporcionalidade), Art. 11 (vigilância biométrica em público = vedada salvo 5 exceções), Art. 13 (log obrigatório: nome+CPF+IP+datetime+operação).<br>
+      <span style="font-size:12px;color:var(--muted)">Verificar no site do CNJ/MJSP se houve atualização posterior. Aplica-se a policiais que usam recursos FNSP/FPN; PCMG também adota por referência.</span>
+    </div>
   </div>
 
   <div class="card">
@@ -357,6 +363,26 @@ tr:nth-child(even) td { background: var(--bg); }
       </div>
     </div>
     <p>A instituição roda o <strong>seu</strong> modelo, localmente — o dado não viaja. Custo total ao longo do tempo de uma máquina local vs. mandar tudo para fora.</p>
+
+    <div class="callout callout-blue" style="margin:12px 0">
+      <strong>🖥️ Tiers de hardware (referência jun/2026):</strong>
+      <table style="width:100%;margin-top:8px;font-size:13px;border-collapse:collapse">
+        <thead><tr style="text-align:left;border-bottom:1px solid var(--border)"><th style="padding:4px 8px">Classe</th><th style="padding:4px 8px">Exemplos de máquinas</th><th style="padding:4px 8px">Capacidade</th></tr></thead>
+        <tbody>
+          <tr><td style="padding:4px 8px">Workstation pesada</td><td style="padding:4px 8px">Mac Studio / Mac Pro (chip Ultra), PC com RTX 4090/5090</td><td style="padding:4px 8px">Modelos 70B+ totalmente em memória</td></tr>
+          <tr style="background:var(--b1)"><td style="padding:4px 8px">Workstation média</td><td style="padding:4px 8px">Mac Studio/MacBook Pro (chip Max), PC com RTX 4080</td><td style="padding:4px 8px">Modelos 30–70B quantizados</td></tr>
+          <tr><td style="padding:4px 8px">Notebook investigador</td><td style="padding:4px 8px">MacBook Pro (chip Pro), notebook NVIDIA mid-range</td><td style="padding:4px 8px">Modelos 7–14B com boa performance</td></tr>
+          <tr style="background:var(--b1)"><td style="padding:4px 8px">Mínimo</td><td style="padding:4px 8px">Qualquer máquina com 8GB RAM</td><td style="padding:4px 8px">Modelos 7B quantizados (uso limitado)</td></tr>
+        </tbody>
+      </table>
+    </div>
+
+    <div class="callout callout-green" style="margin:12px 0">
+      <strong>🔧 Setup recomendado (Apple Silicon):</strong> <strong>LM Studio</strong> com backend MLX nativo — 30–50% mais rápido que alternativas no mesmo chip. Interface visual, sem linha de comando.<br>
+      <strong>Setup alternativo (todas as plataformas):</strong> Ollama + interface web.<br>
+      <span style="font-size:12px;color:var(--muted)">⚠️ Modelos ficam desatualizados rapidamente. Não fixe um modelo específico — ensine onde buscar: <a href="https://huggingface.co/models?sort=trending&search=instruct" target="_blank" style="color:var(--blue)">HuggingFace trending</a>, <a href="https://ollama.com/library" target="_blank" style="color:var(--blue)">Ollama Library</a>. Pergunte: "qual o melhor modelo 7B que roda na minha RAM hoje?" — a resposta muda a cada semana.</span>
+    </div>
+
     <p style="font-size:13px;color:var(--muted)">Base real: modelo local + Guard Brasil local.</p>
   </div>
 
@@ -524,7 +550,7 @@ tr:nth-child(even) td { background: var(--bg); }
     <tbody>
       <tr><td>1</td><td>Detecção de PII</td><td>Módulo 2</td><td>Rodar Guard Brasil no texto do Caso Alfa — encontrar MASP, REDS, CPF</td></tr>
       <tr><td>2</td><td>Mascaramento</td><td>Módulo 3</td><td>Gerar versão mascarada; comparar com original; explicar cada máscara</td></tr>
-      <tr><td>3</td><td>Modelo local</td><td>Módulo 4</td><td>Processar Caso Alfa com modelo local — dado não sai da máquina. ⚠️ Requer instalação (ex: Ollama + llama3). Alternativa: demonstrado pelo instrutor.</td></tr>
+      <tr><td>3</td><td>Modelo local</td><td>Módulo 4</td><td>Processar Caso Alfa com modelo local — dado não sai da máquina. ⚠️ Requer instalação prévia: <strong>LM Studio</strong> (Apple Silicon, recomendado) ou <strong>Ollama</strong> (multiplataforma). Escolha um modelo 7B–14B disponível no momento — não hardcode nome específico (ficam obsoletos). Alternativa: demonstrado pelo instrutor.</td></tr>
       <tr><td>4</td><td>Cadeia de custódia</td><td>Módulo 6</td><td>Gerar hash SHA-256 + log de auditoria para saída de IA no Caso Alfa; criar documento defensável</td></tr>
       <tr><td>5</td><td>A pergunta de governança</td><td>Módulo 7</td><td>Olhando o Caso Alfa: o que NUNCA poderia ir para IA externa? Discussão — a resposta certa é: nada do real.</td></tr>
     </tbody>
@@ -555,10 +581,16 @@ tr:nth-child(even) td { background: var(--bg); }
         <td>Alerta já no slide</td>
       </tr>
       <tr>
-        <td>Lab 3 / Whisper</td>
+        <td>Lab 3 / Modelo local</td>
         <td><span class="tag tag-orange">Médio</span></td>
-        <td>Whisper é referência de campo, não ferramenta instalada no pacote do curso. Lab 3 exige Ollama ou similar — pré-requisito técnico não trivial.</td>
-        <td>Demonstrar pelo instrutor; declarar requisito antes da aula</td>
+        <td>Lab 3 exige LM Studio (Apple Silicon) ou Ollama pré-instalado — pré-requisito técnico não trivial. Não citar modelo específico em aula: modelos ficam obsoletos a cada semana. Ensinar onde buscar (HuggingFace trending, Ollama Library). Whisper (transcrição) é referência de campo — não instalado no pacote do curso.</td>
+        <td>Declarar requisito antes da aula; demonstrar pelo instrutor se nenhum aluno tiver setup</td>
+      </tr>
+      <tr>
+        <td>CNJ 615/2025 + MJSP 961/2025</td>
+        <td><span class="tag tag-green">Atualizado</span></td>
+        <td>Framework regulatório duplo aprovado. CNJ: Art. 13 exige HITL em decisões de alto risco — Guard Brasil é compatível. MJSP: Art. 13 exige log nome+CPF+IP+datetime+operação. Verificar se PCMG aderiu formalmente e se houve portaria estadual posterior.</td>
+        <td>Adicionado no Slide 5 (jun/2026). Instrutor verifica atualizações antes de cada turma.</td>
       </tr>
       <tr>
         <td>Slide 11 / Proposta</td>
@@ -628,7 +660,8 @@ tr:nth-child(even) td { background: var(--bg); }
 
   <ul class="checklist">
     <li><span class="check-icon">⏳</span><div><strong>Deck visual (PDF):</strong> geração no NotebookLM Studio em andamento. Quando pronto: salvar como PDF e incluir no ZIP.</div></li>
-    <li><span class="check-icon">🔵</span><div><strong>Revisão LGPD/ANPD (Slide 5):</strong> verificar se a "lei específica" prevista nos PLs de 2026 foi aprovada e atualizar o slide. Tarefa do instrutor.</div></li>
+    <li><span class="check-icon">✅</span><div><strong>Regulatório BR (Slide 5 atualizado jun/2026):</strong> CNJ Resolução 615/2025 + Portaria MJSP 961/2025 adicionados. Framework dual aprovado documentado. Instrutor verifica atualização antes de cada turma.</div></li>
+    <li><span class="check-icon">✅</span><div><strong>Modelo local (Slide 7 + Lab 3 atualizado jun/2026):</strong> LM Studio (MLX, Apple Silicon) como recomendado. Hardware tiers documentados. Filosofia "sem hardcode de modelos" — ensinar onde buscar.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Gate PCMG:</strong> verificado e confirmado (jun/2026). Vetor magistério liberado.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Caso Alfa sintético:</strong> 5 labs prontos, zero dado real.</div></li>
     <li><span class="check-icon">✅</span><div><strong>Plano de aula:</strong> 8 módulos, ~3h, critérios verificáveis.</div></li>
@@ -641,7 +674,7 @@ tr:nth-child(even) td { background: var(--bg); }
 <!-- FOOTER -->
 <footer class="footer">
   <div>
-    <strong>EGOS Framework</strong> — Ciber+IA+LGPD para a Investigação · v1.1 · jun/2026
+    <strong>EGOS Framework</strong> — Ciber+IA+LGPD para a Investigação · v1.2 · jun/2026 · CNJ 615/2025 + MJSP 961/2025 + LM Studio MLX
   </div>
   <div>
     Fonte canônica: <code>docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md</code> ·

exec
/bin/bash -lc "nl -ba packages/mcp-mf-certificados/src/index.ts | sed -n '1,80p'; nl -ba scripts/busca-global.ts | sed -n '1,100p'; nl -ba tsconfig.json | tail -20" in /home/enio/egos
 succeeded in 0ms:
     1	import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
     2	import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
     3	import { z } from "zod";
     4	
     5	const server = new McpServer({
     6	  name: "egos-mcp-mf-certificados",
     7	  version: "1.0.0",
     8	});
     9	
    10	// Tool: Diagnóstico de Certificação
    11	server.tool(
    12	  "diagnosticar_certificacao",
    13	  "Realiza o diagnóstico inicial para identificar gap de certificação e orienta a melhor solução ICP-Brasil",
    14	  {
    15	    documento: z.string().describe("CNPJ ou CPF do cliente (apenas números ou com máscara)"),
    16	    tipo_cliente: z.enum(["pj", "pf"]).describe("Tipo de cliente: Pessoa Jurídica ou Pessoa Física"),
    17	    ramo_atividade: z.string().optional().describe("Ramo de atividade se for PJ (ex: contabilidade, medicina, comércio)"),
    18	  },
    19	  async (args: { documento: string; tipo_cliente: "pj" | "pf"; ramo_atividade?: string }) => {
    20	    const { documento, tipo_cliente, ramo_atividade } = args;
    21	    const isSaude = ramo_atividade?.toLowerCase().includes("medic") || ramo_atividade?.toLowerCase().includes("saude");
    22	    const isContabilidade = ramo_atividade?.toLowerCase().includes("contab");
    23	
    24	    let recomendacao = "";
    25	    if (tipo_cliente === "pj") {
    26	      recomendacao = "Recomendação: e-CNPJ A1 (para agilidade e nuvem) ou A3 (token físico) dependendo do ERP.";
    27	      if (isContabilidade) {
    28	        recomendacao += " Avaliar procurações eletrônicas e e-CPF para os sócios.";
    29	      }
    30	    } else {
    31	      recomendacao = "Recomendação: e-CPF A3 (mídia criptográfica) para advogados e médicos, ou e-CPF A1 para rotinas gerais.";
    32	      if (isSaude) {
    33	        recomendacao = "Recomendação Crítica: e-CPF A3 CRM/CRM-Digital ou e-Médico obrigatório para prescrição eletrônica.";
    34	      }
    35	    }
    36	
    37	    return {
    38	      content: [{
    39	        type: "text" as const,
    40	        text: JSON.stringify({
    41	          status: "diagnostico_concluido",
    42	          documento_analisado: documento,
    43	          risco_compliance: isSaude || isContabilidade ? "ALTO" : "MÉDIO",
    44	          recomendacao_oficial: recomendacao,
    45	          next_step: "Agendar emissão por videoconferência com a equipe MF.",
    46	        }, null, 2),
    47	      }],
    48	    };
    49	  }
    50	);
    51	
    52	// Tool: Buscar Diretrizes ICP-Brasil
    53	server.tool(
    54	  "buscar_diretrizes_icp_brasil",
    55	  "Busca resumo normativo e validade jurídica para casos de uso de certificados digitais",
    56	  {
    57	    caso_de_uso: z.string().describe("Caso de uso a ser pesquisado (ex: prescricao medica, assinatura de contratos, emissao nfe)"),
    58	  },
    59	  async (args: { caso_de_uso: string }) => {
    60	    const { caso_de_uso } = args;
    61	    const term = caso_de_uso.toLowerCase();
    62	    let normativas = "";
    63	
    64	    if (term.includes("medica") || term.includes("saude") || term.includes("prescricao")) {
    65	      normativas = "Portaria MS nº 467/2020: Prescrições eletrônicas devem ser assinadas com certificado digital ICP-Brasil válido (Padrão e-CPF A3/CRM).";
    66	    } else if (term.includes("nfe") || term.includes("nota fiscal")) {
    67	      normativas = "A emissão de NF-e requer certificado digital ICP-Brasil de pessoa jurídica (e-CNPJ) ou procurador homologado.";
    68	    } else {
    69	      normativas = "Medida Provisória nº 2.200-2/2001: Documentos assinados com certificado digital ICP-Brasil possuem a mesma validade jurídica que assinaturas de próprio punho reconhecidas em cartório.";
    70	    }
    71	
    72	    return {
    73	      content: [{
    74	        type: "text" as const,
    75	        text: `Diretrizes Oficiais (MF Certificados Knowledge Base):\n${normativas}\n\nNota: Para validação completa, consulte a assessoria jurídica ou o suporte N2 da MF.`,
    76	      }],
    77	    };
    78	  }
    79	);
    80	
     1	import { spawn } from "bun";
     2	import { readFileSync, existsSync } from "fs";
     3	import { join } from "path";
     4	
     5	interface LeafRepo {
     6	  name: string;
     7	  path: string;
     8	  description: string;
     9	  alias_of?: string;
    10	}
    11	
    12	interface LeafReposRegistry {
    13	  leaf_repos: LeafRepo[];
    14	}
    15	
    16	const KERNEL_PATH = "/home/enio/egos";
    17	const LEAF_REPOS_FILE = join(KERNEL_PATH, "agents/registry/leaf-repos.json");
    18	
    19	async function run() {
    20	  const args = process.argv.slice(2);
    21	  if (args.length === 0 || args[0] === "-h" || args[0] === "--help") {
    22	    console.log("Uso: bun run scripts/busca-global.ts <termo_regex> [--files-only]");
    23	    console.log("Busca global e distribuída (ripgrep) por todos os repositórios cadastrados no EGOS kernel.");
    24	    process.exit(0);
    25	  }
    26	
    27	  const query = args[0];
    28	  const filesOnly = args.includes("--files-only");
    29	
    30	  if (!existsSync(LEAF_REPOS_FILE)) {
    31	    console.error(`Erro: Arquivo leaf-repos não encontrado em ${LEAF_REPOS_FILE}`);
    32	    process.exit(1);
    33	  }
    34	
    35	  const registry: LeafReposRegistry = JSON.parse(readFileSync(LEAF_REPOS_FILE, "utf-8"));
    36	  
    37	  // Pegar todos os paths únicos (ignorar alias_of para evitar duplicidade de busca)
    38	  const pathsToSearch = [KERNEL_PATH]; // Inclui o Kernel também
    39	  
    40	  for (const repo of registry.leaf_repos) {
    41	    if (!repo.alias_of && existsSync(repo.path)) {
    42	      pathsToSearch.push(repo.path);
    43	    }
    44	  }
    45	
    46	  console.log(`🔍 Iniciando busca global pelo termo: "${query}"`);
    47	  console.log(`📁 Repositórios a buscar: ${pathsToSearch.length}`);
    48	  
    49	  const rgArgs = ["rg", "-i", query, ...pathsToSearch];
    50	  if (filesOnly) {
    51	    rgArgs.splice(1, 0, "-l"); // Insere -l depois de rg
    52	  }
    53	  
    54	  const proc = spawn({
    55	    cmd: rgArgs,
    56	    stdout: "pipe",
    57	    stderr: "pipe",
    58	  });
    59	
    60	  const rawOut = await new Response(proc.stdout).text();
    61	  const rawErr = await new Response(proc.stderr).text();
    62	  
    63	  if (rawErr) {
    64	    console.error("Avisos/Erros:", rawErr);
    65	  }
    66	  
    67	  if (rawOut) {
    68	    const lines = rawOut.split('\n').filter(Boolean);
    69	    console.log(`✅ Busca concluída. ${lines.length} ocorrências encontradas.`);
    70	    if (filesOnly) {
    71	       console.log(rawOut);
    72	    } else {
    73	       // Se não for filesOnly, limite a saída para não estourar tokens se for enorme.
    74	       if (lines.length > 300) {
    75	          console.log(lines.slice(0, 300).join('\n'));
    76	          console.log(`\n... (e mais ${lines.length - 300} resultados truncados). Use --files-only para ver os arquivos ou refine a busca.`);
    77	       } else {
    78	          console.log(rawOut);
    79	       }
    80	    }
    81	  } else {
    82	    console.log("Nenhum resultado encontrado.");
    83	  }
    84	}
    85	
    86	run().catch(console.error);
    44	    "packages/audit/src/activation-audit.ts",
    45	    "packages/shared/src/mcp-audit-handler.ts",
    46	    "packages/mcp-memory",
    47	    "packages/mcp-bridge",
    48	    "packages/mcp-browser-automation",
    49	    "packages/mcp-eval-runner",
    50	    "packages/mcp-g-pecas",
    51	    "packages/mcp-governance",
    52	    "packages/mcp-observability",
    53	    "packages/mcp-ops",
    54	    "packages/mcp-security",
    55	    "packages/mcp-skills-registry",
    56	    "packages/mcp-literature",
    57	    "packages/knowledge-mcp",
    58	    "packages/guard-brasil-langchain",
    59	    "packages/guard-brasil-python",
    60	    "packages/shared/src/intelink-llm-router.ts",
    61	    "packages/mcp-mf-certificados"
    62	  ]
    63	}

exec
/bin/bash -lc 'bun scripts/busca-global.ts "["; echo EXIT:$?' in /home/enio/egos
 succeeded in 0ms:
🔍 Iniciando busca global pelo termo: "["
📁 Repositórios a buscar: 13
Nenhum resultado encontrado.
Avisos/Erros: rg: regex parse error:
    (?:[)
       ^
error: unclosed character class

EXIT:0

codex
The new MCP package cannot be built with its own documented build command, which blocks the main added functionality. The global search script also masks ripgrep errors as empty results.

Full review comments:

- [P1] Fix the MCP package build failure — /home/enio/egos/packages/mcp-mf-certificados/src/index.ts:19-19
  When this new MCP package is validated with the documented workflow (`cd packages/mcp-mf-certificados && bun run build`), TypeScript fails at this handler with `TS2589: Type instantiation is excessively deep and possibly infinite`, so `dist/index.js` is never produced and the `start`/MCP demo path cannot run. Please adjust the tool schema/handler typing or dependency versions so the package builds cleanly.

- [P2] Propagate ripgrep failures from global search — /home/enio/egos/scripts/busca-global.ts:81-82
  If the user searches for a term that is an invalid regex, such as `[P0]` or `[`, `rg` exits with an error but this script still prints `Nenhum resultado encontrado.` and exits 0 because it never checks the child process exit code. That makes `/busca` silently report false negatives for common literal search strings containing regex metacharacters.
The new MCP package cannot be built with its own documented build command, which blocks the main added functionality. The global search script also masks ripgrep errors as empty results.

Full review comments:

- [P1] Fix the MCP package build failure — /home/enio/egos/packages/mcp-mf-certificados/src/index.ts:19-19
  When this new MCP package is validated with the documented workflow (`cd packages/mcp-mf-certificados && bun run build`), TypeScript fails at this handler with `TS2589: Type instantiation is excessively deep and possibly infinite`, so `dist/index.js` is never produced and the `start`/MCP demo path cannot run. Please adjust the tool schema/handler typing or dependency versions so the package builds cleanly.

- [P2] Propagate ripgrep failures from global search — /home/enio/egos/scripts/busca-global.ts:81-82
  If the user searches for a term that is an invalid regex, such as `[P0]` or `[`, `rg` exits with an error but this script still prints `Nenhum resultado encontrado.` and exits 0 because it never checks the child process exit code. That makes `/busca` silently report false negatives for common literal search strings containing regex metacharacters.
```
