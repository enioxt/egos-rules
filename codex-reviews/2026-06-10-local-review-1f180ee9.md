# Codex Local Review — 2026-06-10T00:24:19Z

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
session id: 019eaeea-6f70-7242-9574-cc083e89c798
--------
user
changes against 'HEAD~3'
2026-06-10T00:24:21.081325Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T00:24:21.085373Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 66b36bc9b5cabcf6f7524de946406f3621f98bb5 --stat && git diff 66b36bc9b5cabcf6f7524de946406f3621f98bb5' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                      | 54 +++++++++++++++++----------
 docs/jobs/2026-06-09-doc-drift-verifier.json  |  4 +-
 docs/jobs/2026-06-09-fable5-mission-brief.md  | 44 ++++++++++++++++++++++
 docs/jobs/2026-06-09-pre-commit-pipeline.json | 24 ++++++++++++
 4 files changed, 105 insertions(+), 21 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 443263d8..4ac7c038 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -8,6 +8,22 @@
 ---
 <!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
 
+## 🗳️ ELEIÇÃO P0 — sistema inteiro (2026-06-09, Opus, aprovada Enio)
+
+> **Contexto:** 43 "P0" abertos = inflação de label (Goodhart). Curado para os P0 REAIS.
+> 12 P0-inflação → demovidos P1/P2 (sobreviviam há semanas sem matar o projeto = não eram P0).
+> 5 launch → `[P0-BLOCKED-MIGUEL]` (dependem do Miguel validar primeiro).
+
+**P0 REAIS (a fila de verdade):**
+1. **NOTEBOOKLM-MIGUEL-SHARE-001 → MIGUEL-GOW-SEND-001** — o NORTE (fechar loop com pessoa real = `cliente_confirmou=true`). Tudo o resto está atrás disto.
+2. **RULE-HARDEN-CI-GATES-001** — camada-4 da integridade (corte Enio). Único P0 de governança acionável agora; sem ele o sistema é fail-open no servidor.
+3. **TASKS-ARCHIVE-NOW-001 / TASKS-OVERFLOW-001** — meta-bloqueador (978L). Archive script não resolve (0 tasks `[x]`) → triagem real.
+4. **PII-PURGE-001..005** — motor de purge generalizado (segurança estrutural). P0 com ressalva: é tooling, não WIP.
+
+> **🔬 ALVO FABLE 5 (proposto, jun/2026 — modelo mais poderoso, grátis até 22/06):** revisão adversarial profunda da **cadeia de enforcement de integridade** (`.husky/pre-commit` 941L + `packages/shared/src/provenance.ts` + `evidence-chain.ts` + `packages/core/src/guards/pri.ts` + `agent-signature.ts` + scanners + `INTEGRITY_PROOF_SSOT.md`). Razão: diferencial do EGOS + 5 buracos fail-open já provados + SWE puro (não dispara safeguard cyber do Fable). **Aguarda corte Enio antes de gastar tokens.**
+
+---
+
 ## 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
 
 > **Corte Enio 2026-06-09:** identidade = arquiteto-diagnosticador que prova hipóteses com protótipos pequenos e cobra pela clareza, não pela hora de dev. Evidência: 14 sistemas auditados = **0 fecharam a cadeia** (cliente_confirmou=false em todos). Padrão: abre a conversa, abandona a confirmação. Memory: `project_arquiteto_diagnosticador_identity_2026-06-09`.
@@ -81,11 +97,11 @@
 
 > Enio decidiu parar de se esconder. Missão: finalizar, publicar, divulgar. NÃO criar ferramenta nova. NÃO abrir frente. Roteiro 2:30 pronto em docs/strategy/APRESENTACAO_EGOS.md PARTE E. Drafts de posts em docs/drafts/SOCIAL_LAUNCH_DRAFTS.md.
 
-- [ ] **HOTMART-LAUNCH-001** [P0] `prime` `gated:HITL-Enio` — Enio cria produto na Hotmart. Campos completos em APRESENTACAO_EGOS.md PARTE F checklist. Enio executa após gravar vídeo.
-- [ ] **VIDEO-RECORD-001** [P0] `enio` — Enio grava vídeo 2:30 com PARTE E do roteiro. Legenda sempre. Mostrar tela nas demos (GPT + Guard Brasil). Sem mencionar delegacia atual.
-- [ ] **GPT-CREATE-001** [P0] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
+- [ ] **HOTMART-LAUNCH-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL-Enio` — Enio cria produto na Hotmart. Campos completos em APRESENTACAO_EGOS.md PARTE F checklist. Enio executa após gravar vídeo.
+- [ ] **VIDEO-RECORD-001** [P0-BLOCKED-MIGUEL] `enio` — Enio grava vídeo 2:30 com PARTE E do roteiro. Legenda sempre. Mostrar tela nas demos (GPT + Guard Brasil). Sem mencionar delegacia atual.
+- [ ] **GPT-CREATE-001** [P0-BLOCKED-MIGUEL] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
 - [ ] **MIGUEL-GOW-SEND-001** [P0] `prime` — Enviar HTML piloto MF Certificados para Miguel (dono da GOW). Arquivo: docs/presentations/mf-certificados-piloto.html. Incluir link NotebookLM (áudio overview pronto). Registrar envio aqui.
-- [ ] **SOCIAL-LAUNCH-001** [P0] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
+- [ ] **SOCIAL-LAUNCH-001** [P0-BLOCKED-MIGUEL] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
 - [/] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
 
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
@@ -113,7 +129,7 @@
 - [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
 - [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md. **[Addendum 2026-06-08 — Enio:]** princípio-chave: MCP carrega tools/resources/prompts, mas só **regra-como-tool-verificável** se *impõe* na máquina do outro (prompt remoto pode ser ignorado). Encodar governança como tools pass/fail. Candidato pronto: `egos-curriculum` (envelopar `packages/curriculum-gate` no padrão mcp-bridge) = prova viva do padrão. Docs fortes → expor como `resources`; skills → `prompts`. Split público/interno via gate Guardião. HTML = vitrine humana, MCP = transporte de máquina. Próximo movimento adiado por corte Enio ("parar aqui por enquanto").
 - [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
-- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
+- [ ] **PRICING-FOUNDING-PASS-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
 - [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
 - [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
 - [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
@@ -421,7 +437,7 @@
 
 ## 🛡️ AGENT & CHATBOT GUARDRAILS — Padrão único p/ todo agente/chatbot/MCP sob domínio EGOS (2026-05-31)
 > **SSOT:** `docs/governance/AGENT_GUARDRAILS_STANDARD.md` (DRAFT v0.1). **Tese:** nenhum agente nosso deve falar/agir algo falso, danoso ou fora de escopo. Stack 5 camadas (L0 input → L4 audit), manifest por superfície, ≥3 golden cases por guardrail (INC-008). **Owner tags:** `guarani`=propõe/testa local · `prime`=revisa/commita/pusha · `redzone`=corte humano Enio.
-- [ ] **GUARD-STD-001** [P0] `redzone` — Enio roda os 6 meta-prompts (MP-1..MP-6 §5 do standard) em Perplexity/Grok/ChatGPT/Gemini + arxiv/reddit; traz respostas. Prime sintetiza em `docs/knowledge/GUARDRAILS_RESEARCH_SYNTHESIS.md` (tratar como UNVERIFIED INC-005, cross-check ≥2 fontes).
+- [ ] **GUARD-STD-001** [P1] `redzone` — Enio roda os 6 meta-prompts (MP-1..MP-6 §5 do standard) em Perplexity/Grok/ChatGPT/Gemini + arxiv/reddit; traz respostas. Prime sintetiza em `docs/knowledge/GUARDRAILS_RESEARCH_SYNTHESIS.md` (tratar como UNVERIFIED INC-005, cross-check ≥2 fontes).
 - [/] **GUARD-STD-003** [P1] `prime` `gated:001,002` — Definir contrato `guardrails.yaml` (schema) + matriz de conformidade. **PARCIAL 2026-06-02:** schema v0.1 + regras de validação + mínimos por tipo + matriz skeleton em `AGENT_GUARDRAILS_STANDARD.md` §8/§9. Fundações de auditoria A2A (ASI 2026) e JCS RFC 8785 Ed25519 implementadas e expostas no mcp-governance (2026-06-02). FALTA: refinar métodos pós-pesquisa (001/002), preencher matriz por código (evidence-first), corte Enio nos mínimos (parte de 006). <!-- scan-ok: FP-placa -->
 - [/] **GUARD-STD-004** [P1] `prime` `gated:003` — Wirar L0/L2/L3 guards. **L3 LLM-gate FEITO 2026-06-03 (corte Enio: escalação-only):** `pri.ts` ganhou injeção de `llmEvaluator` (default=mock; L3 só roda quando L1/L2 inconclusivos, confidence<60); avaliador real `callHermes` em `packages/shared/src/guards/pri-llm-evaluator.ts` (fail-closed BLOCK). @egos/core continua sem dep de shared. 4/4 testes pri passam. **FALTA:** wirar L0 (injection/scope) + L2 (ATRiAN+PII output) em todos os chatbots + injetar o evaluator nos callers reais.
 - [ ] **GUARD-STD-006** [P1] `redzone` `gated:003` — L3 action guards: auth/token nos MCP endpoints + scope matrix (tool×agente) + HITL p/ escrita. Modelo de auth = Red Zone (corte Enio antes de codar).
@@ -429,7 +445,7 @@
 
 ## 💰 VALUATION & ECV — Avaliação de capacidade/valor do EGOS (2026-05-31) [INICIATIVA SEPARADA de GUARDRAILS]
 > **SSOT:** `docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md` (DRAFT, commit `b625a37e`). **Tese:** medir valor por LOC-Verificado + ECV (não LOC bruto). **Red Zone:** todos os números (R$7.02M, R$25.8M-86M, equity 15-35%, $ETHIK) são CONCEPT/histórico — exigem corte Enio antes de qualquer uso externo. **Owner tags:** iguais ao bloco guardrails. ⚠️ NÃO confundir com GUARD-STD-* — Guarani referenciou GUARD-STD-001/002 no plano de valuation por engano; esses IDs pertencem só a guardrails.
-- [ ] **VAL-004** [P0] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
+- [ ] **VAL-004** [P1] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
 - [ ] **VAL-005** [P2] `redzone` — Enio roda meta-prompt de review Codex (§7 do doc) para estressar metodologia ECV; Prime sintetiza (UNVERIFIED INC-005).
 
 ## 🎯 NAME & PROVE — Campanha de Capacidade (Opus 2026-05-30, pós-3-agentes)
@@ -505,7 +521,7 @@
 > **Diferencial vs SEMrush:** visibilidade em IAs (GEO) — fase 2, SEMrush é cego nisso (Princeton arXiv:2311.09735: 43% páginas sem citação IA).
 
 - [ ] **SEO-MVP-003** [P1] `2h Sonnet` — GSC API (grátis, OAuth) se Gabi/cliente tem site → dados reais de ranking/CTR/posição.
-- [ ] **SEO-MVP-005** [P0] `validação` — Rodar `/keyword-temas` com tema real da Gabi → ela confirma se elimina os "3 dias de trabalho". Gate de decisão para Fase 1 (DataForSEO) e Opção 2 (dashboard).
+- [ ] **SEO-MVP-005** [P2] `validação` — Rodar `/keyword-temas` com tema real da Gabi → ela confirma se elimina os "3 dias de trabalho". Gate de decisão para Fase 1 (DataForSEO) e Opção 2 (dashboard).
 - [ ] **SEO-F1-001** [P1] `gate-humano` — FASE 1 (só após SEO-MVP-005 validar): criar conta DataForSEO + depósito $50 (requer Enio: login+cartão; crédito não expira) + adicionar MCP oficial `dataforseo/mcp-server-typescript` + smoke 1 query real. Registrar em INTEGRATION_REGISTRY + MCP_REGISTRY.
 - [ ] **SEO-GEO-001** [P2] `defer` — FASE 2: visibilidade em IAs (DataForSEO AI Optimization / LLM Mentions API, ~US$100/mo). Diferencial premium; só após MVP validado.
 
@@ -534,9 +550,9 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - **Ativar quando Enio aprovar:** `bun scripts/hermes-task-creator.ts --write` (após arquivar TASKS.md)
 
 ### ⚠️ Gates HITL pendentes (P0)
-- [ ] **HERMES-HITL-TELEGRAM** [P0] `5min` — Aprovar 1ª mensagem real `@EGOSin_bot`
+- [ ] **HERMES-HITL-TELEGRAM** [P1] `5min` — Aprovar 1ª mensagem real `@EGOSin_bot`
   - Recomendação: ativar SÓ depois da apresentação GoW (evita interferência)
-- [ ] **HERMES-HITL-TASKS** [P0] `5min` — Aprovar 1ª escrita auto em TASKS.md
+- [ ] **HERMES-HITL-TASKS** [P1] `5min` — Aprovar 1ª escrita auto em TASKS.md
   - Pré-requisito: arquivar TASKS.md primeiro (`bun scripts/tasks-archive.ts --exec`)
 
 ### 🟡 P1 — Próximas 2 semanas
@@ -566,7 +582,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
 
 ### 🟢 CROSS-REPO MONITORING (NOVO 2026-05-26)
 
-- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P0] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
+- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P2] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
   - Lista repos via `gh repo list enioxt --limit 100`
   - Para cada TIER 1: `git -C $dir fetch origin` + check drift
   - Output: "N repos drifted · K repos com commits novos · M repos com tasks P0 pendentes"
@@ -589,7 +605,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - Gera `docs/COORDINATION.md` com snapshot semanal
   - HITL: revisão no `/end` domingo
 
-- [ ] **REPO-INVENTORY-001** [P0] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
+- [ ] **REPO-INVENTORY-001** [P2] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
   - Output: `docs/governance/REPO_INVENTORY_2026-05-26.md`
   - Decisão arquitetural: TIER 1/2/3 para Autoresearch + monitoring
 
@@ -651,7 +667,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 - [ ] **MCP-BRIDGE-001** [P1] `1h` — Bridge `mcp-storefront` (baixo risco, vendável, sem segredo de kernel). PM2 + Caddy + smoke `initialize` → Unauthorized.
 - [ ] **MCP-BRIDGE-002** [P1] `1h` — Bridge `mcp-ops` + `mcp-observability` (risco médio: revela topologia). Validar que tools read-only não vazam infra sensível antes de expor.
-- [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
+- [ ] **MCP-BRIDGE-003** [P2-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
 ## 🖥️ FRONTEND-SYNC — frontend/README/GitHub refletindo a realidade (Enio 2026-06-01)
@@ -671,7 +687,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
 
 > Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
-- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
+- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P2] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
 - [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
 
 ## 🔀 CROSS-WINDOW — absorção 3 janelas + alarme .guarani (Enio 2026-06-01)
@@ -722,7 +738,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PROOF-NARRATIVE-001** [P2] `redzone` — Artigo/post explicando sem hype. HITL.
 - [ ] **PROOF-PERSONA-001** [P2] — Definir quem usaria/compraria de fato (user/buyer/auditor).
 - [ ] **PROOF-MODULES-001** [P2] — Modularizar (replicável): `egos-proof-{core,bitcoin,eas,registry,ui,policy}`. Só após validação.
-- [ ] **PROOF-VERDICT-001** [P0] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
+- [ ] **PROOF-VERDICT-001** [P2] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
 
 ## 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
 
@@ -737,7 +753,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
 
 > Guarani deixou 8 arquivos staged. ⚠️ Sci-Hub = circumvention de paywall — **Red Zone legal/reputacional p/ policial ativo + repo público**. NÃO commito o scraper sem corte do Enio.
-- [ ] **HANDOFF-SCIHUB-001** [P0] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
+- [ ] **HANDOFF-SCIHUB-001** [P2] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
 - [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
 
 ## 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
@@ -879,7 +895,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### 🔴 P0 Ativas
 
-- [ ] **CBQ-OBS-FOUNDATION-001** [P0] — Migrations Wave 0 (ver CBQ-OBS-001..003)
+- [ ] **CBQ-OBS-FOUNDATION-001** [P2] — Migrations Wave 0 (ver CBQ-OBS-001..003)
 
 ### 🟧 P1 Ativas
 
@@ -944,8 +960,8 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ## 🔬 INTELINK (work-hours, Frente A)
 
-- [ ] **REPORT-007** [P0] — Relatório investigação DHPP (pendente)
-- [ ] **REPORT-006** [P0] — Relatório suspeitos recorrentes (dep Neo4j estável)
+- [ ] **REPORT-007** [P2] — Relatório investigação DHPP (pendente) [pertence a intelink, não framework]
+- [ ] **REPORT-006** [P2] — Relatório suspeitos recorrentes (dep Neo4j estável) [pertence a intelink, não framework]
 - [ ] **REPORT-005** [P1] — Dashboard analytics Intelink
 - [ ] **REPORT-004** [P1] — Exportar dados BISP para Neo4j (16k pessoas) completo
 
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index bfd34df5..aca23820 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T20:09:18.791Z",
+  "verified_at": "2026-06-09T23:43:27.450Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1325",
+      "current_value": "1327",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-fable5-mission-brief.md b/docs/jobs/2026-06-09-fable5-mission-brief.md
new file mode 100644
index 00000000..54ea798c
--- /dev/null
+++ b/docs/jobs/2026-06-09-fable5-mission-brief.md
@@ -0,0 +1,44 @@
+# Fable 5 — Mission Brief: Auditoria Adversarial da Cadeia de Integridade
+
+> Preparado por Opus 4.8 (2026-06-09) para execução sob **Claude Fable 5**.
+> Objetivo: gastar os tokens caros do Fable no ponto de maior alavancagem do EGOS.
+> Janela: Fable 5 grátis em Pro/Max/Team até 2026-06-22.
+> Safeguard: Fable bloqueia cyber-ofensivo e cai pro Opus. Este alvo é SWE/governança puro → seguro.
+
+## Contexto (1 parágrafo)
+O diferencial do EGOS é "governance is infrastructure": gates que provam integridade (phantom-done,
+PII, doc-drift, provenance). Em 2026-06-09 descobrimos empiricamente **5 buracos fail-open** que
+passaram por revisão humana normal: (1) `--no-verify` desliga todo o chain, (2) watcher stale por
+heartbeat acoplado a LLM 404, (3) regex phantom-done frouxa (`commit ` solto, hex casa "deadbeef"),
+(4) leaves sem o hook, (5) CI não re-roda os gates. SSOT: `docs/governance/INTEGRITY_PROOF_SSOT.md`.
+
+## Alvo (ler estes arquivos)
+- `.husky/pre-commit` (941 linhas — o chain de enforcement)
+- `packages/shared/src/provenance.ts` (L1 hash)
+- `packages/shared/src/evidence-chain.ts` (L2)
+- `packages/core/src/guards/pri.ts` (L3 — escalação LLM é mock injetável)
+- `packages/shared/src/agent-signature.ts` (L4 Merkle/Ed25519)
+- `scripts/audit-phantom-done.ts` · `scripts/ai-commit-security.ts` · `scripts/security/scan-hardcoded-sensitive.ts`
+- `docs/governance/INTEGRITY_PROOF_SSOT.md` (a doutrina alvo)
+
+## Missão adversarial (a pergunta)
+Você é um atacante e um auditor de integridade. Para CADA gate/camada acima:
+1. **Encontre o bypass.** Como um agente (ou humano apressado) faz o gate dizer "ok" sem que o
+   trabalho/integridade exista? Liste TODOS os caminhos fail-open, não só os 5 já conhecidos.
+2. **TOCTOU / Goodhart.** Onde a verificação checa a *referência/menção* em vez do *conteúdo real*?
+   Onde a métrica virou alvo (gameable)?
+3. **Trust boundary.** Onde estado de outra janela/agente/subagente é aceito como CONFIRMADO sem
+   re-verificação? (OWASP A08:2025)
+4. **Fail-open residual.** Procure `|| true`, `.catch(()=>exit(0))`, `EGOS_*_OVERRIDE`, regex frouxa,
+   timeouts que liberam, defaults permissivos.
+5. **A camada-4 (CI).** Dado que branch protection é 403 (free/private) e a decisão foi CI fail-closed
+   (RULE-HARDEN-CI-GATES-001), desenhe o workflow GitHub Actions mínimo que torna `--no-verify` inócuo.
+
+## Output esperado
+Tabela: `gate | buraco | severidade | prova (file:line) | fix mínimo fail-closed`.
+Priorize por *catastrófico+silencioso+fácil-de-explorar*. Sem inventar — cite `file:line`.
+Classifique cada achado REAL/CONCEPT/PHANTOM (regra EGOS).
+
+## Não fazer
+- Não tocar código (só auditar + propor). Implementação volta pro Opus/forja com HITL.
+- Não auditar intelink/OSINT/cursos cyber (dispara safeguard + é Pursuit A, fora de escopo).
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index 8cbd4c9c..0a4de0bb 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -214,5 +214,29 @@
     "duration_ms": null,
     "event": "commit:fix files=2 sha=5768db24",
     "repo": "/home/enio/egos"
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

exec
/bin/bash -lc 'python -m json.tool docs/jobs/2026-06-09-pre-commit-pipeline.json >/dev/null && python -m json.tool docs/jobs/2026-06-09-doc-drift-verifier.json >/dev/null && echo ok' in /home/enio/egos
 succeeded in 0ms:
ok

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "nl -ba TASKS.md | sed -n '1,140p;410,455p;525,615p;640,760p;870,970p'; nl -ba docs/jobs/2026-06-09-fable5-mission-brief.md | sed -n '1,80p'" in /home/enio/egos
 succeeded in 0ms:
     1	# TASKS.md — EGOS Framework Core (SSOT)
     2	
     3	> **Version:** 5.4.0 | **Updated:** 2026-05-23 | **SLIM:** TASKS-SLIM-001 (1729L→slim).
     4	> **Policy:** tasks executáveis nos próximos 30 dias. Longo prazo → `docs/strategy/ROADMAP.md`.
     5	> **DUAL PURSUIT:** A (Intelink work-hours) | B (1ª venda EGOS after-hours)
     6	> **Pivot ref:** `docs/planning/gpecas-mvp-task-plan.md` | `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md`
     7	
     8	---
     9	<!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
    10	
    11	## 🗳️ ELEIÇÃO P0 — sistema inteiro (2026-06-09, Opus, aprovada Enio)
    12	
    13	> **Contexto:** 43 "P0" abertos = inflação de label (Goodhart). Curado para os P0 REAIS.
    14	> 12 P0-inflação → demovidos P1/P2 (sobreviviam há semanas sem matar o projeto = não eram P0).
    15	> 5 launch → `[P0-BLOCKED-MIGUEL]` (dependem do Miguel validar primeiro).
    16	
    17	**P0 REAIS (a fila de verdade):**
    18	1. **NOTEBOOKLM-MIGUEL-SHARE-001 → MIGUEL-GOW-SEND-001** — o NORTE (fechar loop com pessoa real = `cliente_confirmou=true`). Tudo o resto está atrás disto.
    19	2. **RULE-HARDEN-CI-GATES-001** — camada-4 da integridade (corte Enio). Único P0 de governança acionável agora; sem ele o sistema é fail-open no servidor.
    20	3. **TASKS-ARCHIVE-NOW-001 / TASKS-OVERFLOW-001** — meta-bloqueador (978L). Archive script não resolve (0 tasks `[x]`) → triagem real.
    21	4. **PII-PURGE-001..005** — motor de purge generalizado (segurança estrutural). P0 com ressalva: é tooling, não WIP.
    22	
    23	> **🔬 ALVO FABLE 5 (proposto, jun/2026 — modelo mais poderoso, grátis até 22/06):** revisão adversarial profunda da **cadeia de enforcement de integridade** (`.husky/pre-commit` 941L + `packages/shared/src/provenance.ts` + `evidence-chain.ts` + `packages/core/src/guards/pri.ts` + `agent-signature.ts` + scanners + `INTEGRITY_PROOF_SSOT.md`). Razão: diferencial do EGOS + 5 buracos fail-open já provados + SWE puro (não dispara safeguard cyber do Fable). **Aguarda corte Enio antes de gastar tokens.**
    24	
    25	---
    26	
    27	## 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
    28	
    29	> **Corte Enio 2026-06-09:** identidade = arquiteto-diagnosticador que prova hipóteses com protótipos pequenos e cobra pela clareza, não pela hora de dev. Evidência: 14 sistemas auditados = **0 fecharam a cadeia** (cliente_confirmou=false em todos). Padrão: abre a conversa, abandona a confirmação. Memory: `project_arquiteto_diagnosticador_identity_2026-06-09`.
    30	> **Isca de valor** = comunidade + material + vídeo + Hotmart (entrada R$4 + networking), NÃO o diagnóstico. Diagnóstico vem depois, com a pessoa real.
    31	> **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
    32	
    33	**🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
    34	- [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
    35	- [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
    36	- [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
    37	
    38	**WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
    39	- [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
    40	- [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
    41	- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
    42	- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio).
    43	
    44	**MCP PESSOAL DO ENIO (em qualquer lugar, incl. ChatGPT Dev Mode) — corte Enio 2026-06-09:**
    45	- [ ] **MCP-PESSOAL-ENIO-001** [P1] `prime`+`forja` — Consolidar núcleo curado de tools (10-20→30) num MCP autenticado (Bearer pessoal) bridgeado p/ ChatGPT Dev Mode. Núcleo: recon, readiness, guard_scan_pii, get_metaprompt, knowledge_search, memory_store/recall + egos_capture. Curadoria em andamento (workflow `wi5x1e8ue` → docs/strategy/MCP_PESSOAL_ENIO_CURADORIA.md). NÃO é público — é pessoal autenticado.
    46	- [ ] **EGOS-CAPTURE-001** [P1] `forja` — Tool `egos_capture`: salva conversa do ChatGPT de volta no EGOS (fim do copy-paste). **Write via STAGING** (`docs/_inbox/` ou memory pendente — NUNCA commit direto, Red Zone write-back). Notificação ao Enio via **bot Telegram do EGOS, EXCLUSIVO pro ID do Enio — JAMAIS para grupos**.
    47	- [ ] **EGOS-CAPTURE-TG-APPROVE-001** [P2] `forja`+`hermes-ops` — Fase 2: botão inline no Telegram p/ Enio aceitar/validar a captura → promove do staging pro sistema (HITL por clique, de dentro do Telegram direto pro código).
    48	- [ ] **WEBFETCH-SSRF-RESEARCH-001** [P2] `guardiao` — Validar com `/pesquisa` (date-first) se allowlist + domínio-do-cliente-por-sessão + guards SSRF (bloqueia IP interno/localhost) + audit é a melhor opção p/ web_fetch sem castrar o sistema. Padrão proposto = OWASP SSRF Prevention; confirmar com fontes atuais antes de implementar no MCP pessoal. Corte Enio 2026-06-09.
    49	- [ ] **CLAUDE-MD-SIMPLIFICADO-001** [P1] `prime` — Fluxo mínimo EGOS (corte Enio 2026-06-09): CLAUDE.md SIMPLIFICADO = router constitucional fino (anti-alucinação + CONFIRMADO/INFERIDO/HIPÓTESE + Red Zone + HITL + provenance + índice tools + quando-chamar) + EGOS MCP (profundidade via get_meta_prompt/get_skill on-demand) + NotebookLM MCP (didático). Roda em Claude Code E ChatGPT Dev Mode. Padrão roteador (liga memory_router_architecture).
    50	- [ ] **VALIDATE-PROVENANCE-001** [P0] `prime`+`provador` — **Jogada de maior alavancagem (1 ato, 4 retornos):** rodar as 4 camadas de provenance no ambiente real + GRAVAR. L1 `packages/shared/src/provenance.ts` (hash) · L2 `evidence-chain.ts` (claim→fonte) · L3 PRI gate (ALLOW/BLOCK/DEFER/ESCALATE) · L4 `agent-signature.ts` (Merkle) · +`guard-brasil` (PII). A gravação: (1) valida tools do MCP pessoal (núcleo-16), (2) é a prova que a identidade arquiteto-diagnosticador exige, (3) é evidência do artigo forense (branch `personal-os/ikigai-compass` @71eb0317, deferido), (4) loop-closure estilo item-intake. **Red Zone:** ângulo forense/PCMG = HITL+Guardião, nunca público sem corte. Une sessão main + branch ikigai-compass. [NÃO executado — exige Enio rodar+gravar no desktop; marcação [x] revertida 2026-06-09 = phantom-done corrigido, R-CAP-001]
    51	
    52	**Integridade phantom-done (2026-06-09 — buracos achados+corrigidos):**
    53	- [ ] **PHANTOM-AUDIT-WIRE-001** [P1] `forja` — Wire `scripts/audit-phantom-done.ts` (criado 754bca3b, sobrevive ao --no-verify) em `scripts/agent-sentinela.ts` + Layer de saúde do `/start`. Sem wiring = doc morto (R-CAP-001).
    54	
    55	- [ ] **LLM-ROUTING-FIX-404-001** [P1] `curador`+`hermes-ops` — CONFIRMADO (achado via watcher 2026-06-09): `google/gemini-2.0-flash-001` retorna **HTTP 404 "No endpoints found"** no OpenRouter (resíduo da migração Alibaba→OpenRouter, memória `project_llm_routing_decision_2026-06-07`). Quebra a análise do coordination-watcher (agora fail-safe, mas sem enriquecimento) e qualquer outro caller que usa `tier:'fast'`. Fix: corrigir o id do modelo no chain de `packages/shared/src/llm-provider` (Gemini via Google AI Studio direto, conforme corte Enio "só Gemini") + smoke `callHermes` retornando 200. Owner = curador/LLM.
    56	
    57	**🛡️ PROGRAMA DE HARDENING DE REGRAS (corte Enio 2026-06-09 — generalizar a correção phantom-done a TODO o sistema):**
    58	- [ ] **RULE-HARDEN-BRANCHPROTECT-001** [P2-DEFERIDA] `hermes-ops` — ⏸️ DEFERIDA (BRANCHPROTECT-PLAN-DECISION-001, corte Enio 2026-06-09): branch protection server-side é 403 no plano GitHub atual (free/private). Camada-4 escolhida = CI fail-closed (RULE-HARDEN-CI-GATES-001), não isto. Revisitar só se `egos` virar público ou GitHub Pro. Mantida como registro do gap.
    59	- [ ] **RULE-HARDEN-CI-GATES-001** [P0] `hermes-ops` — CI workflow (GitHub Actions) que re-roda os 4 gates críticos (gitleaks fail-closed, PII sweep history-wide, phantom-done exit 1, frozen-zone) independente de `--no-verify`. CI é a lei; hook é conveniência.
    60	- [/] **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] `forja` — `ai-commit-security.ts:146` CORRIGIDO (2026-06-09): `main().catch(()=>exit(0))` → `main().catch((e)=>{ log; exit(1) })` (crash agora bloqueia). `scan-hardcoded-sensitive.ts` já estava correto (sem .catch silencioso). Falta: `// scan-ok: mock` pattern validation (não auto-declarado). 80% feito.
    61	- [ ] **RULE-HARDEN-PHANTOM-REGEX-001** [P1] `forja` — TIGHTEN regex phantom-done (pre-commit L532 + audit-phantom-done.ts L36): hex≥12 word-boundary estrito OU `evidence_sha:<40hex>` OU `Closes/Fixes #\d` validado via `git cat-file -e`. Remover `commit ` solto (falso-negativo). audit-phantom-done → exit 1 em CI/Sentinela, warn-only local.
    62	- [ ] **RULE-HARDEN-CAPABILITY-GOLDEN-001** [P1] `forja` — Gate `capability_audit` no pre-commit: entry validada em CAPABILITY_REGISTRY sem ≥3 golden cases (1 que falha em stub) → block. Fecha R7/INC-008 estruturalmente (hoje é regra de vontade, nenhum gate conta golden por capability).
    63	- [ ] **RULE-HARDEN-OVERRIDE-LEDGER-001** [P1] `forja` — Central override ledger: todo `EGOS_*_OVERRIDE`/`*-OVERRIDE` trailer/`--no-verify` registra em `docs/jobs/override-audit.jsonl` (espelhar hermes-block-control que já loga). `/start` mostra overrides da semana. Override sem registro = invisível hoje (11 gates sem rastro).
    64	- [ ] **RULE-HARDEN-DB-SMOKE-001** [P1] `forja` — Gate R-DB-002: migration/seed staged sem bloco `SELECT count … anon` final → block. Fecha INC-DB-001 (32 produtos invisíveis 12h por `is_active` silencioso) estruturalmente.
    65	- [ ] **RULE-HARDEN-CRON-HEARTBEAT-001** [P1] `hermes-ops` — Heartbeat para auditores cron (RLS auditor VPS, Sentinela): cron escreve `~/.egos/heartbeat/<job>.json`; ausência > 26h alerta fail-loud em pre-commit + `/start`. Fecha classe "cron morto silencioso" (root-cause INC-CTX-001 watcher stale generalizado).
    66	- [ ] **PRI-L3-LLM-WIRE-001** [P2] `forja` — Incidental finding da validação: `layerThree` em `packages/core/src/guards/pri.ts` usa mock LLM. Injetar `llmEvaluator` real (Gemini via shared/llm-router) p/ escalação L3 ser 100% real. Injeção de dependência, não stub bloqueante.
    67	
    68	**🔬 AUDITORIA DE DISSEMINAÇÃO DA INTEGRIDADE (achados machine-wide 2026-06-09 — `/start` desta janela; classificação CONFIRMADO):**
    69	- [/] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — settings.json ATUALIZADO (2026-06-09): deny `Bash(*git commit --no-verify*)` + `Bash(*git commit -n *)` adicionados. Falta: PATH shim `~/bin/git` (defesa extra, não crítico — CI é a camada real). 70% feito.
    70	- [ ] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — CONFIRMADO: o guard phantom-done do pre-commit + `audit-phantom-done.ts` vivem SÓ no kernel — `grep` em `852/.husky` e `egos-lab/.husky` = 0. A "disseminação" da 2ª metade propagou docs de governança, NÃO o enforcement de integridade aos leaves. Propagar o bloco phantom-done (pre-commit) + script audit via `disseminate-propagator.ts` aos leaves que têm TASKS.md. Prova: re-grep nos leaves após.
    71	- [ ] **CLAUDE-MD-INDEX-INTEGRITY-001** [P1] `prime` — CONFIRMADO: `INTEGRITY_PROOF_SSOT.md` é [T1] mas o router constitucional NÃO o indexa — `grep` em `.claude/CLAUDE.md` e `egos/CLAUDE.md` = 0 (só `AGENTS.md` cita). SSOT [T1] invisível ao router = enforcement-gap de descoberta. Adicionar 1 linha de índice em ambos os CLAUDE.md (lazy-ref, sem inflar) — liga CLAUDE-MD-SIMPLIFICADO-001.
    72	- [ ] **BRANCHPROTECT-PLAN-DECISION-001** [P0] `prime` — ✅ DECIDIDO (corte Enio 2026-06-09): opção **(c) CI fail-closed como camada-4 de facto** (RULE-HARDEN-CI-GATES-001) — não pagar Pro nem expor repo agora. ⏳ Task só fecha quando CI-GATES estiver LIVE (decisão ≠ implementação). Branch protection 403 (free/private) → RULE-HARDEN-BRANCHPROTECT-001 deferida. Registrado em handoff_2026-06-09.md + memória.
    73	
    74	**🔀 PRs GITHUB — TRIAGEM 2026-06-09:**
    75	- [ ] **PR-82-GITLEAKS-SECRET-001** [P1] `hermes-ops` — PR #82 (gitleaks 2→3) falha CI por `GITLEAKS_LICENSE` inacessível a dependabot (secret bloqueado). Fix: adicionar `if: github.actor != 'dependabot[bot]'` no job security-scan OU usar `secrets: inherit` com permissão. Merge após CI verde.
    76	- [ ] **ZOD-V4-MIGRATION-001** [P1] `forja` — Migrar zod 3→4 auditada: 91 arquivos afetados, APIs mudaram. Fazer pós-CONGELADO (R-DIAG-006). Instalar zod v4 e rodar `bun run typecheck` para listar todos os erros de migração antes de commitar qualquer mudança.
    77	- [ ] **PR-MAJORS-AUDIT-001** [P1] `prime` — PRs #85 (@simplewebauthn 11→13) #86 (lucide 0.577→1.17) #87 (jose 5→6) #88 (@types/node 20→25) em hold. Testar cada um em branch isolada + `bun run typecheck` antes de merge. jose e simplewebauthn são security-critical — testar autenticação real.
    78	
    79	**🖥️ COMUNICAÇÃO HUMANA — HTML (pedido Enio 2026-06-09: "nessa linguagem não consigo explicar pra ninguém"):**
    80	- [/] **PROVENANCE-HTML-EXPLAINER-001** [P1] `prime`+`pixel` — HTML ESCRITO `docs/tutor/PROVENANCE_4_CAMADAS.html` (30KB, autocontido, R-HTML-001..008, 4 camadas + casos de uso + ressalva honesta L3 mock + glossário). ⚠️ **VISUAL PROOF PENDENTE — NÃO TESTADO nesta sessão** (screenshot interrompido pelo Enio; visual_proof_gate bloqueia file://; §11.5 → [CONCEPT] até screenshot+console-limpo). Próximo: abrir no navegador OU servir local e capturar screenshot light+dark, validar console, então iterar conteúdo com Enio. NÃO declarar [DONE] sem prova visual.
    81	- [ ] **HTML-SSOT-ITERATE-001** [P2] `pixel`+`prime` — Loop de melhoria contínua do `HTML_GENERATION_CONSTITUTION.md`: cada HTML novo que o Enio iterar gera ≥1 regra/refinamento de volta ao SSOT (o que funcionou p/ o humano entender vira regra). Manter changelog interno de versão. R-HTML = padrão vivo, não congelado.
    82	
    83	**Regras a encodar (R-DIAG-002 a 006) — pendente corte final do Enio:** ver `project_arquiteto_diagnosticador_identity_2026-06-09` na memória. R-DIAG-002 conversa-antes-de-código; R-DIAG-003 cadeia-fecha-no-funcionou; R-DIAG-004 diagnóstico-é-produto; R-DIAG-005 anti-espelho; R-DIAG-006 sistema-sem-pessoa-30d-congela.
    84	
    85	## 🧊 CONGELADO (R-DIAG-006 — sem feature nova até ter pessoa real do outro lado)
    86	
    87	> Auditoria 2026-06-09: estes são `SO_TECH_SEM_CLIENTE` — construídos para cliente imaginário (espelho-para-dentro). Rodam se já rodam; NÃO crescem. Descongela só quando aparecer uma pessoa real nomeada.
    88	
    89	- 🧊 **gem-hunter** — 0 stars/0 forks; agente que se alimenta para público inexistente. Roda sozinho, não tocar.
    90	- 🧊 **eagle-eye** (egos-lab) — "first partner by <data passada>", 0 assinaturas.
    91	- 🧊 **egos-inteligencia** (World-Open-Graph) — já em PAUSA desde 2026-03-18. Manter cortado; referência técnica do Guard Brasil.
    92	- 🧊 **DPIO chatbot** — funil de qualificação sem ninguém para qualificar.
    93	- 🧊 **metaprompt-generator deploy** — endpoint vazio; não consertar até ter 1 LLM externo real consumindo.
    94	- 🧊 **Guard Brasil como PRODUTO vendável** — é CINTO (PII gate interno é uso real), não cliente. Parar GTM. MRR=0, 111 commits, 0 demo a prospect real.
    95	
    96	## 🎯 LANÇAMENTO PÚBLICO v1 — Hotmart + Video + Divulgação (2026-06-09)
    97	
    98	> Enio decidiu parar de se esconder. Missão: finalizar, publicar, divulgar. NÃO criar ferramenta nova. NÃO abrir frente. Roteiro 2:30 pronto em docs/strategy/APRESENTACAO_EGOS.md PARTE E. Drafts de posts em docs/drafts/SOCIAL_LAUNCH_DRAFTS.md.
    99	
   100	- [ ] **HOTMART-LAUNCH-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL-Enio` — Enio cria produto na Hotmart. Campos completos em APRESENTACAO_EGOS.md PARTE F checklist. Enio executa após gravar vídeo.
   101	- [ ] **VIDEO-RECORD-001** [P0-BLOCKED-MIGUEL] `enio` — Enio grava vídeo 2:30 com PARTE E do roteiro. Legenda sempre. Mostrar tela nas demos (GPT + Guard Brasil). Sem mencionar delegacia atual.
   102	- [ ] **GPT-CREATE-001** [P0-BLOCKED-MIGUEL] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
   103	- [ ] **MIGUEL-GOW-SEND-001** [P0] `prime` — Enviar HTML piloto MF Certificados para Miguel (dono da GOW). Arquivo: docs/presentations/mf-certificados-piloto.html. Incluir link NotebookLM (áudio overview pronto). Registrar envio aqui.
   104	- [ ] **SOCIAL-LAUNCH-001** [P0-BLOCKED-MIGUEL] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
   105	- [/] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
   106	
   107	## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
   108	> Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
   109	
   110	## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
   111	> Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
   112	- [/] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — pesquisa feita, aplicar no design da demo. PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
   113	- [/] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medição feita; falta preencher os 57 golden ausentes. MEDIDO ao vivo: 80 CBCs, **9 com golden real**, 57 contrato-sem-teste; harness rodou **mcp-runner 88/93 pass**, bun test 78/82. Frase honesta GOW: "9 MCPs com golden (88/93), resto contrato-pendente; infra existe, gap é preenchimento". 4 falhas metaprompts (MP-PRICE/MP-MATERIAL falta red-zone) = fix simples futuro.
   114	> Anti-atropelo (deferidas, sprint GOW — não fazer antes da demo): Diagnostic Protocol = PAUSADO (docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md, risco segurança/loop — Codex). 3 dashboards de observabilidade = deferido (dados existem: api_usage/mcp_audit/egos_agent_events; só após GOW validar). NotebookLM slides+vídeo do sistema = deferido. Distribuição egos-mcp/repo-por-cliente (Enio) = ideia registrada, pós-validação. Wire dos gaps #1(guard pré-LLM)/#2(evidence sempre)/#4(Hermes-L2) = só se GOW pagar.
   115	- [ ] **GOW-METAPROMPT-EVAL-FIX-001** [P2] `voz` — 4 golden cases falhando (MP-PRICE-001-005, MP-MATERIAL-EVAL-001 em packages/eval-runner/evals/metaprompts): falta seção "red zone" + nota anti-cópia-cega nesses .md. Fix simples → sobe a cobertura de prova (relevante p/ honestidade GOW).
   116	- [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
   117	- [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
   118	- [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
   119	- [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
   120	- [/] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — Golden Example Tutor→Operacional REDIGIDO (gpt-tier0-package.md §2, bloco a anexar). Falta HITL + colar no artefato/GPT. Guarani #3.
   121	- [ ] **GIT-HISTORY-PII-DEEPSCAN-001** [P1] `guardiao`+`redzone` 🔴 — auditoria Guarani #5 (corrigida): egos NÃO tem arquivos OP-* no histórico (verificado), mas antes de QUALQUER abertura pública do egos, scan PROFUNDO de PII no conteúdo do histórico (não só paths). Repo público hoje = egos-governance (curado). NÃO filter-repo sem evidência + corte Enio (T0).
   122	
   123	## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
   124	
   125	> Pricing R$4 (×2 progression) definido. WhatsApp = produto de entrada = acesso completo.
   126	> Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
   127	> PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
   128	
   129	- [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
   130	- [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md. **[Addendum 2026-06-08 — Enio:]** princípio-chave: MCP carrega tools/resources/prompts, mas só **regra-como-tool-verificável** se *impõe* na máquina do outro (prompt remoto pode ser ignorado). Encodar governança como tools pass/fail. Candidato pronto: `egos-curriculum` (envelopar `packages/curriculum-gate` no padrão mcp-bridge) = prova viva do padrão. Docs fortes → expor como `resources`; skills → `prompts`. Split público/interno via gate Guardião. HTML = vitrine humana, MCP = transporte de máquina. Próximo movimento adiado por corte Enio ("parar aqui por enquanto").
   131	- [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
   132	- [ ] **PRICING-FOUNDING-PASS-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
   133	- [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
   134	- [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
   135	- [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
   136	- [ ] **ONLINE-PRESENCE-CHECKLIST-001** [P1] `prime` `gated:HITL` — Criar checklist de comparecimento online diário: X.com (@anoineim) + Instagram (@egos.ia). Implementar hábito de 1 post/dia em cada canal. Ação derivada de atom A81 (travamento residual = falta de presença visual consistente, não medo financeiro). `docs/strategy/online-presence-checklist.md`. HITL: Enio valida conteúdo editorial antes de publicar nada.
   137	- [ ] **AIOX-CASE-STUDY-001** [P2] `curador` — Extrair insights do PDF AIOX (João/Hero Base) aplicáveis ao EGOS: modelo publisher vs estúdio, escola para crescer ecossistema (Hero Academy → EGOS Academy), UGC monetization analogy (audiência→plataforma paga→criador recebe%), qualidade primeiro. Salvar em `docs/research/aiox-case-study-insights.md`.
   138	
   139	## 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
   140	
   410	### 🌊 ONDA 1 — P0 SEGURANÇA E CLIENTE (HOJE)
   411	
   412	### 🌊 ONDA 2 — RUNTIME HEALTH (24-48h)
   413	- [~] **W2-T4** [P1] — Dependabot triage ANALISADO. Decisão: auto-merge PRs #41/#45/#58/#59 (ajv/ssh-action/minor-patch/setup-bun). HITL PENDENTE: PRs #48(@ai-sdk/openai v1→v3 breaking), #46(@types/node v20→v25), #49(eslint v9→v10) — requerem Enio aprovar após verificar breaking changes.
   414	  - **HIGH vulns (re-triagem 2026-05-30, gh api):** (1) `xlsx` ReDoS em `central-egos/template` (storefront REAL) — **sem fix no npm**, exige migrar p/ distribution SheetJS CDN; é o único em produto vendável, P1. (2) `fast-uri`≤3.1.1→3.1.2 (transitiva mcp-governance, baixo). (3) `vite` 8.0.0-8.0.4→8.0.5 (devDep agent-028-template, baixo). Bumps exigem build-verify por pacote — não fazer no fim de sessão.
   415	
   416	### 🌊 ONDA 3 — GOVERNANÇA E LIMPEZA (3-7 dias)
   417	  - W3-T6/W3-T7 (P3) movidos p/ `docs/strategy/ROADMAP.md` §BUCKET 5 (2026-05-30).
   418	
   419	### 🌊 ONDA 4 — OBSERVABILIDADE PROATIVA (1-2 semanas)
   420	- [~] **W4-T3** [P2] — SKIPPED: `context-alarm.sh` já existe em `~/.claude/hooks/` (não-bloqueante por decisão 2026-05-22 — "excesso de rigidez"). Freezar em commit era regressão.
   421	- [ ] **W4-T4** [P1] `3h` — VPS env hardening: INV-STAB-006 (audit ecosystem files) + INV-STAB-009 (mcp-bridge anon key, fail-closed) + INV-STAB-010 (`scripts/restart-gpecas.sh` correto).
   422	
   423	---
   424	
   425	## 🗂️ DOC ORGANIZATION SWEEP — 2026-05-30 (mobile session, Opus + 4 Sonnet)
   426	> **Checklist completo (SSOT):** `docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md` — atualizar lá a cada item.
   427	- [~] **ORG-WAVE-B** [P2] `decidir junto` — parcial: ops/infra consolidado, BRACC→out-of-scope; pendente WHATSAPP_SSOT(B2), orphans(B6) — backlog ONDA B.
   428	
   429	## 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
   430	> **Causa-raiz:** status duplicado em ≥2 lugares (TASKS.md + audit backlog) com IDs inconsistentes → `task-reconciliation.ts` (só TASKS.md, match `[A-Z]+-\d+`) não pega. C2-C4 e ORG-WAVE-* ficaram phantom-pending.
   431	- [ ] **EGOS-DEV-AGENT-001** [P2] `proposta` — Desenhar template "agente EGOS Developer" reusando skill-discovery + eval-runner + mcp-governance. Escopar antes de construir (anti-overproduction).
   432	
   433	### 🏛️ MULTI-AGENT GOVERNANCE (papéis LLM nomeados + Council/HITL) — 2026-05-30 (Antigravity propôs, Prime corrigiu phantoms)
   434	> **SSOT:** `docs/governance/agent_scopes_and_governance.md` (papéis LLM) + `agents/registry/agents.json` (agentes-ferramenta). Antigravity criou os docs; EGOS Prime corrigiu 3 model IDs phantom (INC-005) + adicionou nota de reconciliação dos dois registries. Edits em `.guarani/` aguardam aprovação Enio (frozen zone).
   435	- [ ] **GOV-AGENTS-003** [P2] `gated:002` — Wirar enforcement de escopo: pre-commit AST-check (arquivo tocado × perfil do agente autorizado) — hoje só conceito no §5 do doc. Reusar `agent:lint` se existir.
   436	- [/] **GUARANI-004** [P1] `guarani` — Enforcement técnico da TRAVA DE COMMIT (GUARANI.md §12.1): pre-commit bloqueia commit cujo autor/sessão = Guarani tocando frozen zone (`.guarani/`, `.husky/`, governance). Caso-teste = incidente `4e7bcb43` (auto-commit + symlink damage 2026-05-31). Guarani propõe diff; Prime commita. **HARDENED 2026-05-31 (Prime):** fail-closed-by-default via sinal `CLAUDECODE` (Prime=Claude Code tem; Guarani=Antigravity não) + override humano `EGOS_FROZEN_OVERRIDE=1` (Enio). Codex review aplicado (value-leak fix + threat-model honesto). FALTA p/ `[x]`: enforcement tamper-proof (env vars são forjáveis → exige pre-receive server-side, não wired no setup solo). Hoje = defesa-em-profundidade + registro de intenção, NÃO authz à prova de adulteração.
   437	
   438	## 🛡️ AGENT & CHATBOT GUARDRAILS — Padrão único p/ todo agente/chatbot/MCP sob domínio EGOS (2026-05-31)
   439	> **SSOT:** `docs/governance/AGENT_GUARDRAILS_STANDARD.md` (DRAFT v0.1). **Tese:** nenhum agente nosso deve falar/agir algo falso, danoso ou fora de escopo. Stack 5 camadas (L0 input → L4 audit), manifest por superfície, ≥3 golden cases por guardrail (INC-008). **Owner tags:** `guarani`=propõe/testa local · `prime`=revisa/commita/pusha · `redzone`=corte humano Enio.
   440	- [ ] **GUARD-STD-001** [P1] `redzone` — Enio roda os 6 meta-prompts (MP-1..MP-6 §5 do standard) em Perplexity/Grok/ChatGPT/Gemini + arxiv/reddit; traz respostas. Prime sintetiza em `docs/knowledge/GUARDRAILS_RESEARCH_SYNTHESIS.md` (tratar como UNVERIFIED INC-005, cross-check ≥2 fontes).
   441	- [/] **GUARD-STD-003** [P1] `prime` `gated:001,002` — Definir contrato `guardrails.yaml` (schema) + matriz de conformidade. **PARCIAL 2026-06-02:** schema v0.1 + regras de validação + mínimos por tipo + matriz skeleton em `AGENT_GUARDRAILS_STANDARD.md` §8/§9. Fundações de auditoria A2A (ASI 2026) e JCS RFC 8785 Ed25519 implementadas e expostas no mcp-governance (2026-06-02). FALTA: refinar métodos pós-pesquisa (001/002), preencher matriz por código (evidence-first), corte Enio nos mínimos (parte de 006). <!-- scan-ok: FP-placa -->
   442	- [/] **GUARD-STD-004** [P1] `prime` `gated:003` — Wirar L0/L2/L3 guards. **L3 LLM-gate FEITO 2026-06-03 (corte Enio: escalação-only):** `pri.ts` ganhou injeção de `llmEvaluator` (default=mock; L3 só roda quando L1/L2 inconclusivos, confidence<60); avaliador real `callHermes` em `packages/shared/src/guards/pri-llm-evaluator.ts` (fail-closed BLOCK). @egos/core continua sem dep de shared. 4/4 testes pri passam. **FALTA:** wirar L0 (injection/scope) + L2 (ATRiAN+PII output) em todos os chatbots + injetar o evaluator nos callers reais.
   443	- [ ] **GUARD-STD-006** [P1] `redzone` `gated:003` — L3 action guards: auth/token nos MCP endpoints + scope matrix (tool×agente) + HITL p/ escrita. Modelo de auth = Red Zone (corte Enio antes de codar).
   444	- [ ] **GUARD-STD-008** [P2] `prime` `gated:007` — Disseminar standard: CAPABILITY_REGISTRY + AGENTS.md + leaf repos (intelink/central-egos/hermes) + NotebookLM source_add da síntese (ADD-only, HITL, LGPD §5.5).
   445	
   446	## 💰 VALUATION & ECV — Avaliação de capacidade/valor do EGOS (2026-05-31) [INICIATIVA SEPARADA de GUARDRAILS]
   447	> **SSOT:** `docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md` (DRAFT, commit `b625a37e`). **Tese:** medir valor por LOC-Verificado + ECV (não LOC bruto). **Red Zone:** todos os números (R$7.02M, R$25.8M-86M, equity 15-35%, $ETHIK) são CONCEPT/histórico — exigem corte Enio antes de qualquer uso externo. **Owner tags:** iguais ao bloco guardrails. ⚠️ NÃO confundir com GUARD-STD-* — Guarani referenciou GUARD-STD-001/002 no plano de valuation por engano; esses IDs pertencem só a guardrails.
   448	- [ ] **VAL-004** [P1] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
   449	- [ ] **VAL-005** [P2] `redzone` — Enio roda meta-prompt de review Codex (§7 do doc) para estressar metodologia ECV; Prime sintetiza (UNVERIFIED INC-005).
   450	
   451	## 🎯 NAME & PROVE — Campanha de Capacidade (Opus 2026-05-30, pós-3-agentes)
   452	> **SSOT:** `docs/strategy/NAME_AND_PROVE_PLAN.md` + `CAPABILITY_NARRATIVE.md`. **Tese:** provar = honrar `AGENTS.md R7` (hoje ~86% violado; eval coverage 14%). Reports: PROOF_GAP_MATRIX / PROOF_ENGINE_AUDIT / NAMING_NARRATIVE_AUDIT.
   453	- [ ] **NAME-PROVE-004** [P1] `🔴 gated-VPS` — Cheap-win: rodar evals que JÁ existem (knowledge-mcp 11 casos ~1h; MCP G Peças) → flip PARTIAL→PROVEN. Precisa MCP servers (desktop/VPS).
   454	- [ ] **NAME-PROVE-005** [P3] — Escrever eval novo p/ top-3 sem prova: Central EGOS Storefront, ATRiAN pipeline, Guard Brasil pipeline (escrever daqui; rodar gated).
   455	- [ ] **NAME-PROVE-006** [P3] — Dashboard "% capacidades provadas" (hoje 14%) + cron full-run `--all` (W-10) no `governance-drift.yml`.
   525	- [ ] **SEO-F1-001** [P1] `gate-humano` — FASE 1 (só após SEO-MVP-005 validar): criar conta DataForSEO + depósito $50 (requer Enio: login+cartão; crédito não expira) + adicionar MCP oficial `dataforseo/mcp-server-typescript` + smoke 1 query real. Registrar em INTEGRATION_REGISTRY + MCP_REGISTRY.
   526	- [ ] **SEO-GEO-001** [P2] `defer` — FASE 2: visibilidade em IAs (DataForSEO AI Optimization / LLM Mentions API, ~US$100/mo). Diferencial premium; só após MVP validado.
   527	
   528	---
   529	
   530	## 🧭 REGISTRY PARITY — 2026-05-27 (Sonnet executou, Opus revisa)
   531	
   532	> **SSOT:** `docs/governance/REGISTRY_PARITY_DECISION.md` + `.registry-grace.yaml` + `scripts/check-registry-parity.sh`
   533	> **Gate novo:** `.husky/_checks/13-registry-parity.sh` (hard-fail em NEW staged adds; legacy = warn).
   534	
   535	---
   536	
   537	## 🔄 HERMES LOOP CLOSURE — Fechar ciclo post-commit review → ação (2026-05-26)
   538	
   539	> **Contexto:** 243.341 entradas no review-queue (545 commits × cron 446x). 9.5% HIGH (~23k findings) dormindo no JSONL. Loop atual: `commit → Gemini → JSONL → 💀`. Plano: fechar loop em pipeline integrado Hermes + Autoresearch.
   540	> **Origem:** Opus arquitetura 2026-05-26 + Codex audit (gpt-5.5 medium) — 9/10 sugestões Codex aceitas. SSOT desta seção.
   541	> **Princípio:** sequencial obrigatório P0 (DEDUP antes de tudo, SCHEMA antes do CONSUMER). Codex flag: blast retroativo dos 23k HIGH = catástrofe — backlog vira digest inicial, NÃO alerts individuais.
   542	
   543	### 🔥 P0 — ✅ COMPLETO 2026-05-26 (Sonnet M sequencial, 7 commits push main, ARQUIVADO em TASKS_ARCHIVE.md)
   544	
   545	HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee — APLICADO: 243k→545, sentinel preservado, backup 28MB) · REGEX-001 (0c2e0e45) · CONSUMER-001 (96a90281) · TELEGRAM-001 (f3414e37, aguarda HITL) · TASKS-001 (4f3821a8, aguarda HITL)
   546	  - Upgrade v0→v1 automático · roteamento por severidade (log only, sem disparos)
   547	  - Rate limit 5/h 20/d · janela 22-07h BRT · backlog >24h → digest · 5/5 smoke pass
   548	  - **Ativar quando Enio aprovar:** ver `docs/jobs/hermes-telegram-2026-05-26.md`
   549	  - Idempotente com grep · 3/3 smoke pass · dry-run mostra 10 findings reais prontos
   550	  - **Ativar quando Enio aprovar:** `bun scripts/hermes-task-creator.ts --write` (após arquivar TASKS.md)
   551	
   552	### ⚠️ Gates HITL pendentes (P0)
   553	- [ ] **HERMES-HITL-TELEGRAM** [P1] `5min` — Aprovar 1ª mensagem real `@EGOSin_bot`
   554	  - Recomendação: ativar SÓ depois da apresentação GoW (evita interferência)
   555	- [ ] **HERMES-HITL-TASKS** [P1] `5min` — Aprovar 1ª escrita auto em TASKS.md
   556	  - Pré-requisito: arquivar TASKS.md primeiro (`bun scripts/tasks-archive.ts --exec`)
   557	
   558	### 🟡 P1 — Próximas 2 semanas
   559	
   560	  - Agrupa findings deduplicados por `finding_type + msg_normalizada`
   561	  - Threshold: 3 ocorrências em commits diferentes → marca como `pattern_id`
   562	  - `scripts/hermes-patterns-detector.ts` — 545 findings → 1 padrão detectado (threshold=3)
   563	  - Output: `~/.egos/hermes-patterns.jsonl`
   564	  - **Depende de:** dados normalizados pós-MIGRATE
   565	
   566	  - Script: `scripts/hermes-finding-update.ts` (440L) + state machine valid transitions
   567	  - Audit trail em `~/.egos/hermes-finding-events.jsonl` (35 events iniciais)
   568	  - Stats: 512 new (93.8%) · 33 task_created (6.0%) · 1 fixed (smoke test)
   569	
   570	  - Lockfile: `.egos/hermes-push-block.lock` com TTL, motivo, commit_sha
   571	  - Pre-push hook checa lockfile → bloqueia se ativo
   572	  - Override: env var `HERMES_BLOCK_OVERRIDE=1 git push` (audita em `~/.egos/hermes-overrides.jsonl`)
   573	  - CRITICAL finding cria lockfile automaticamente
   574	
   575	  - API: `apps/egos-hq/app/api/hq/hermes-metrics/route.ts`
   576	  - UI: `apps/egos-hq/app/hermes/page.tsx`
   577	  - Cobre: total findings · distribuição severidade · padrões · dedup ratio · cost estimate · recent findings · by_status (graceful se eventos não existem)
   578	
   579	> **AUTORES v2 (Autoresearch v2, Fase 0-4) → movido para `docs/strategy/ROADMAP.md` (2026-06-03, size-relief; trabalho diferido/multi-fase, não next-30-dias).**
   580	
   581	---
   582	
   583	### 🟢 CROSS-REPO MONITORING (NOVO 2026-05-26)
   584	
   585	- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P2] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
   586	  - Lista repos via `gh repo list enioxt --limit 100`
   587	  - Para cada TIER 1: `git -C $dir fetch origin` + check drift
   588	  - Output: "N repos drifted · K repos com commits novos · M repos com tasks P0 pendentes"
   589	  - **Dep:** REPO-INVENTORY-001 define quem é TIER 1
   590	
   591	  - 14 repos TIER 1+2 auditados; audit em `docs/governance/README_AUDIT_2026-05-26.md`
   592	  - 3 drafts P0 criados: `docs/drafts/README-omniview-v2-*.md`, `README-forja-v2-*.md`, `README-marizanotto-videos-v2-*.md`
   593	  - HITL pendente: Enio aprova drafts → aplicar nos repos alvo
   594	
   595	- [ ] **CROSS-REPO-README-UPDATE-001** [P1] `8h` 🆕 — Atualizar READMEs baseado em audit
   596	  - Trabalho iterativo por repo TIER 1
   597	  - Cada update segue padrão ouro
   598	  - HITL: Enio aprova draft antes de commit em cada repo
   599	  - Sub-tarefas P1 identificadas pelo audit 2026-05-26:
   600	    - [ ] **README-HERMES-EGOS-PT-BR** `2h` — adicionar seção PT-BR ao README do fork NousResearch explicando escopo EGOS
   601	    - [ ] **README-EGOS-LAB-CHAT-EXPAND** `1h` — expandir README 97L (falta arquitetura + variáveis de ambiente)
   602	
   603	- [ ] **CROSS-REPO-TASKS-SYNC-001** [P1] `3h` 🆕 — Consolida TASKS.md de todos repos
   604	  - Script lê TASKS.md de cada TIER 1 repo
   605	  - Gera `docs/COORDINATION.md` com snapshot semanal
   606	  - HITL: revisão no `/end` domingo
   607	
   608	- [ ] **REPO-INVENTORY-001** [P2] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
   609	  - Output: `docs/governance/REPO_INVENTORY_2026-05-26.md`
   610	  - Decisão arquitetural: TIER 1/2/3 para Autoresearch + monitoring
   611	
   612	### Dependências
   613	```
   614	DEDUP-001 → SCHEMA-001 → MIGRATE-001 → REGEX-001 → CONSUMER-001 → {TELEGRAM-001, TASKS-001}
   615	CONSUMER-001 → PATTERNS-001 → LIFECYCLE-001 → BLOCK-001 → DASHBOARD-001
   640	**Done 2026-05-25:** INV-MON-003/004/006 (ops seed/config/smoke) + INV-MON-API-001 (/v1/*) + GOV-FLOW-VALIDATION-001 (§10 T1).
   641	**Done 2026-05-26:** OPS-SCHEMA-FIX-001 + FVP seed 5 PASS + INV-MON-005 (tenant-deploy via vps-api) + OPS-CONFIG-EGOS-OPS-URL-001.
   642	**Bloqueios Enio (3):** contrato (advogado?), faturamento mínimo (R$10k?), canal seguro MP (Bitwarden?).
   643	
   644	### 🚧 Bloqueado Enio
   645	- ALLM-EGOS-013 decisão KB local vs kb.gpecas.egos.ia.br (15min)
   646	- ALLM-EGOS-046 Caddy mTLS / Cloudflare Access (2h, dep deploy VPS)
   647	- 29 imagens ChatGPT FVP (prompts em mensagem 2026-05-22)
   648	- Decisão home_sort_strategy FVP (default `featured_only` → mudar para `best_margin`?)
   649	
   650	---
   651	
   652	## ✅ GATEWAY-TENANT-FIX-001 (2026-05-25, COMPLETO) — vazamento cross-tenant fixado. Commits `028254b1..ad3ea4a9`.
   653	
   654	### Pendente (P1 — próxima janela, NÃO mexer em MCP ainda)
   655	
   656	- [ ] **MCP-AGNOSTIC-001** [P1] `26h` — refactor `packages/mcp-g-pecas` → `packages/mcp-storefront` agnostic (7 fases). Decisão Enio 2026-05-25: **adiado, não mexer agora**. SSOT diagnóstico já feito em sessão Opus 2026-05-25.
   657	- [ ] **GATEWAY-RPC-LEGACY-003** [P2] `1h` — remover RPCs legadas `search_g_pecas_products`/`search_g_pecas_faq` quando G Peças migrar para tabela neutral `products` (atualmente usa `g_pecas_products` prefixed-table)
   658	- [ ] **GATEWAY-CORS-WHITELIST-004** [P2] `30min` — atualizar CORS no `/chat-web` para incluir `apecaspatense.egos.ia.br` explicitamente (hoje aceita via `.endsWith(".egos.ia.br")`)
   659	- [ ] **CHAT-UI-WHITELIST-005** [P2] `1h` — adicionar `apecaspatense.egos.ia.br` em `allowedOrigins` no gateway (linha ~1519 whatsapp.ts)
   660	- [ ] **SMOKE-CROSS-TENANT-CI-007** [P2] `2h` — adicionar `smoke-cross-tenant.sh` ao CI/pre-commit quando novo tenant for adicionado
   661	
   662	---
   663	
   664	## 🌐 MCP REMOTE BRIDGE — expor MCPs além de g-pecas (corte Enio 2026-05-31)
   665	
   666	> Hoje só `g-pecas` está bridgeado público (`mcp.egos.ia.br/g-pecas/mcp`). Enio cortou expor +storefront +ops +observability +governance +knowledge. Cada bridge = 1 processo PM2 + 1 bloco Caddy (deploy de produção → segue `docs/governance/MCP_DEPLOYMENT_CHECKLIST.md` + provenance). NÃO fazer deploy autônomo — exige janela de deploy + smoke.
   667	
   668	- [ ] **MCP-BRIDGE-001** [P1] `1h` — Bridge `mcp-storefront` (baixo risco, vendável, sem segredo de kernel). PM2 + Caddy + smoke `initialize` → Unauthorized.
   669	- [ ] **MCP-BRIDGE-002** [P1] `1h` — Bridge `mcp-ops` + `mcp-observability` (risco médio: revela topologia). Validar que tools read-only não vazam infra sensível antes de expor.
   670	- [ ] **MCP-BRIDGE-003** [P2-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
   671	- [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
   672	
   673	## 🖥️ FRONTEND-SYNC — frontend/README/GitHub refletindo a realidade (Enio 2026-06-01)
   674	
   675	> **Diagnóstico (2 Sonnets + probes 2026-06-01):** o público NÃO reflete o trabalho recente. Homepage = copy antiga; `/status` congelado em 15/abr; `/showcase` dizia 23 agents; README/GitHub público sem MCPs live/Resolver/79 caps. Já feito (código+dados commitados, SHA `7ea70da6`): snapshot enriquecido (caps 79 / agents 27 / MCPs vivos) + manifest 23→27. Falta o LIVE (rebuild) + Red Zone (copy).
   676	- [/] **FE-SYNC-001** [P0] `prime` — **ACHADO RAIZ 2026-06-01:** o `/opt/egos-site/src/server.ts` em produção está **~1931 linhas ATRÁS** do repo (sem i18n/trading/tema/render novo). **É POR ISSO que o frontend não reflete nada** — prod roda server.ts de meses atrás (deploy drift). ✅ Dado já LIVE: `git pull` em `/opt/egos-git` (mount `docs/jobs:ro`) → `/status.json` fresco hoje + bloco framework (79/27/MCPs). ❌ Falta: **release controlado do egos-site** (deploy do server.ts atual = release GRANDE, não rebuild trivial — testar i18n/trading/deps no env prod + 502-safe + prova visual §10). Build context `/opt/egos-site` é NÃO-git → precisa pipeline de deploy real. NÃO fazer blind.
   677	- [/] **FE-SYNC-002** [P1] — Render do bloco `framework` no /status: ✅ código commitado. Dado já live no /status.json. Falta renderizar no HTML → entra no release FE-SYNC-001.
   678	- [ ] **FE-SYNC-004** [P2] — Artigo factual no /timeline sobre o eval-runner live no ChatGPT + 79 capabilities (documenta sistema deployado; revisão factual, não-marketing). Site só tem 1 artigo hoje.
   679	- [ ] **FE-SYNC-005** [P2] — README do repo público `egos-governance`: mencionar MCPs live + Resolver Doctrine + 79 caps (hoje marca mcp-eval-runner como "Alpha"). Factual.
   680	- [ ] **FE-SYNC-006** [P3] — Auto-regen do snapshot (cron quebrado desde abr) — wire `status-snapshot.ts` num cron/Hermes pós-deploy p/ não estagnar de novo.
   681	
   682	## 📓 NOTEBOOKLM — notebook do framework EGOS sempre atualizado (Enio 2026-06-01)
   683	
   684	> Notebook "EGOS Central Kernel — Framework Core" (`db55b6b8`). ✅ 2026-06-01: adicionadas constituição (CLAUDE.md + RULES_INDEX) + RESOLVER_DOCTRINE + CAPABILITY_REGISTRY (3→7 fontes). Regra: NotebookLM Obrigatório (versionar ADD-only, HITL deleção).
   685	- [ ] **NLM-FW-002** [P1] — Auto-sync OBRIGATÓRIO: doc canônico atualizado (CLAUDE.md/RULES_INDEX/AGENTS/RESOLVER/CAPABILITY_REGISTRY) → post-push Hermes → `source_delete`+`source_add` da MESMA fonte no notebook. Wire `notebook-sync-local.ts` (nunca rodou --exec) ao post-push. HITL só p/ deleção; ADD-only automático.
   686	
   687	## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
   688	
   689	> Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
   690	- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P2] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
   691	- [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
   692	
   693	## 🔀 CROSS-WINDOW — absorção 3 janelas + alarme .guarani (Enio 2026-06-01)
   694	
   695	> Fechamento: este Prime + outra Claude Code + Guarani(sem créditos). Lição: 3 janelas no mesmo .git/index = colisão. Worktree-por-agente é a correção.
   696	- [/] **AGENT-ORG-001** [P1] — ✅ F1+F2 2026-06-02 (Forja x2 construiu, Prime validou): **F1 Sentinela** `scripts/agent-sentinela.ts` (Haiku-tier, lê git+smoke+tasks→relatório+flags, sleep-otimista ≈R$0; testado 3 gates; JÁ pegou 1 drift real). **F2 registry** 7 papéis em `.claude/agents/` + §1.1. Resta: F3 wire pipeline + F4 mover Sentinela pro Hermes VPS (cron 24/7). **F3 parcial:** `egos-autoheal.ts` wired na Sentinela → drift de espelhos AUTO-CURA (a cada 15min). Classe de retrabalho eliminada.
   697	- [ ] **AGENT-TELEM-STD-001** [P2] — Padronizar telemetria de agente: todo agente disparado loga passos em `~/.egos/agent-runs/<papel>-<runid>.jsonl`. Provado 2026-06-02 (SITE-VOICE/OTS/VPS). Wire no contrato de dispatch + EGOS_AGENT_ORGANIZATION §3.
   698	- [ ] **AGENT-TOPOLOGY-WIRE-001** [P2] — Wire `docs/governance/AGENT_RUNTIME_TOPOLOGY.md` (3-runtime contract) no `/start` Layer 1.5 + referenciar em AGENTS.md. Mantém Claude Code/Gemini/Hermes coordenados.
   699	
   700	- [ ] **READINESS-PROVE-001** [P2] — Rodar `/readiness` num caso real (ex: G Peças ou um prospect) → validar o veredito honesto na prática. Liga pivô (alívio de dor, não IA).
   701	
   702	## 🛡️ CYBERSECURITY KB + COMUNICAÇÃO ÉTICA + PROCESSO (Enio 2026-06-01, intake ChatGPT)
   703	
   704	> Intake (protocolo): `~/Downloads/ChatGPT-Investigação cibersegurança EGOS.md` = mission-spec (CONCEPT, não claims). 1ª rodada = inventário+arquitetura+políticas, NÃO impl pesada (o próprio file pede isso). Conecta CURRICULUM-001 + F1 (forense) + cursos. Foco: especializar o Agente EGOS em cyber DEFENSIVA/ética.
   705	- [ ] **CYBER-KB-002** [P2] — Conectar a cyber KB ao currículo do Enio (F1 forense + ciber + IA + polícia) — vira diferencial + material de curso + skills públicas. Liga CURRICULUM-001, COURSES.
   706	- [ ] **COMM-ETHICS-001** [P2] `redzone` — "Engenharia social" reframe ÉTICO: padrão de comunicação do EGOS (copy/agentes/respostas) — **persuadir com VERDADE, estruturar pra clareza, NUNCA explorar viés manipulativamente**. Já temos: transparência radical + evidence-first + banned-absolutes (anti-"100%/garantido"). Faltar: standard `docs/governance/ETHICAL_COMMUNICATION_STANDARD.md` (inteligente + sincero, não-manipulador).
   707	
   708	## 📊 TELEMETRIA DO SISTEMA INTEIRO — observabilidade total p/ medir-e-fluir (Enio 2026-06-03)
   709	
   710	> **Visão Enio:** "telemetria do sistema inteiro — tudo que é acionável por mim, tudo por você (agente), as skills usadas e QUANDO, os modelos usados, quantos agentes disparados, tudo. Para ir medindo e fluindo nos processos, municiando os agentes cada vez melhor — com todos os meta-prompts, o gerador de meta-prompts no fluxo, agent Hermes, tudo."
   711	> **Liga a:** `dispersion-meter.ts` (já feito), TELEM-* abaixo, skill-usage-tracker, observability MCP, AGENT-TELEM-STD-001, metaprompt-generator (`docs/modules/metaprompt-generator/`), Hermes event-pipeline. **Tese:** um painel único = o "cockpit" que separa dispersão generativa de ruído.
   712	
   713	- [ ] **TELEMETRY-EPIC-001** [P1] — Spec do painel de telemetria unificado: o que medir (eventos acionáveis-Enio / acionáveis-agente / skills+quando / modelos+custo / nº agentes disparados / sessões / dispersão / drift) + onde vive (Supabase events + blackboard + `/status`/HQ) + como cada fonte já existente (skill-usage-tracker, observability MCP, coordination-history, dispersion-meter, agent-runs) alimenta um SSOT. Desenho ANTES de codar. **Red Zone:** decisão de arquitetura (corte Enio).
   714	- [ ] **TELEMETRY-SKILLS-001** [P2] `gated:EPIC` — Instrumentar TODA invocação de skill/slash: nome, quando, contexto, resultado → events. (Estende `skill-usage-tracker.ts` + PHASE-2-SKILL-TRACKER-CRON-001.)
   715	- [ ] **TELEMETRY-MODELS-001** [P2] `gated:EPIC` — Logar todo call de modelo: provider/modelo, tokens, custo, latência, sucesso → events (reusa `api_usage` + llm-router). Painel custo-por-modelo/agente.
   716	- [ ] **TELEMETRY-AGENTS-001** [P2] `gated:EPIC` — Contar/logar agentes disparados: quantos, quais papéis, gates passados, handoffs (reusa AGENT-TELEM-STD-001 `~/.egos/agent-runs/` + agent-pipeline).
   717	- [ ] **TELEMETRY-HUMAN-001** [P2] `gated:EPIC` — Eventos acionáveis-por-Enio: aprovações HITL, cortes Red Zone, comandos, decisões → trilha de decisão auditável (liga RESOLVER decisões→memória).
   718	- [ ] **PROCESS-MUNITION-001** [P1] — "Municiar os agentes cada vez melhor": colocar o **gerador de meta-prompts no FLUXO** (todo agente novo/task nova puxa o metaprompt certo de `docs/metaprompts/` via mcp-governance get_meta_prompt) + processos bem-definidos por papel. Liga metaprompt-generator + Hermes agent + agent-org. Desenho de processo, não só código.
   719	
   720	## 📡 DIFF TELEMETRY + DRIFT ACCEPTANCE — sinal multi-agente (Enio 2026-06-01)
   721	
   722	> SSOT/sinal: `docs/governance/DIFF_TELEMETRY_DRIFT_ACCEPTANCE.md`. Reusa coordination-watcher + history.jsonl + drift detectors. Aceite = drift score ≥80 (80/20) → ≥99. Construção distribuída entre agentes = o teste.
   723	- [ ] **TELEM-DIFF-001** [P1] — watcher post-commit loga diff-stats + cadence no `coordination-history.jsonl`.
   724	- [ ] **TELEM-DRIFT-001** [P1] — `scripts/drift-score.ts` composto (doc-drift+task-drift+manifest+ui+rule-sync) normalizado 0-100 → blackboard.
   725	- [ ] **TELEM-SCOREBOARD-001** [P2] — expor drift score no /status + blackboard (liga FE-SYNC).
   726	- [ ] **TELEM-AGENTS-001** [P2] — protocolo agente: lê blackboard no /start, loga diff no /end (+ start-guarani).
   727	
   728	## 🔍 RADICAL TRANSPARENCY / PROOF ARCHITECTURE — validação (Enio 2026-06-01) [pesquisa, NÃO impl ainda]
   729	
   730	> Missão: descobrir SE blockchain melhora a governança de IA do EGOS — não assumir que sim. Se não, focar em Git+signed-commits+audit-logs+OpenTelemetry+Guard Brasil+capability-registry. Dossiê: `docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md` (workflow `blockchain-governance-validation`). Regra: só hash/manifest/attestation on-chain; contexto rico off-chain. Sem PII/secrets/conteúdo investigativo on-chain. Sem token.
   731	- [/] **RT-INVENTORY-001** [P0] — Inventário do que EGOS já tem (transparência radical/Ethik/observabilidade/telemetria/KPIs/audit/decision records/Guard Brasil). (workflow)
   732	- [/] **PROOF-ARCH-001** [P0] — Pesquisa Bitcoin/OTS, EAS/Base, BTC L2s (Stacks/Rootstock/Liquid/RGB/Taproot), não-blockchain (Sigstore/Rekor/SLSA/OTel) + interoperabilidade Layer A↔B. (workflow)
   733	- [/] **CTX-BOUNDARY-001** [P0] — Mapa de contexto: IA-window / off-chain registry / proof layer / public layer. O que vai onde + tamanho. (workflow)
   734	- [ ] **PROOF-MANIFEST-001** [P1] — Formato canônico do EGOS Proof Manifest (governance version + decision record): serialização canônica + Merkle root + verificação.
   735	- [ ] **EAS-PROTO-001** [P1] — Protótipo: decision attestation em Base testnet/sim local. MVP2. Schema `{ruleVersion,agentId,decisionHash,outcome,overrideBy,ts}` + resolver (só council).
   736	- [ ] **RT-KPI-001** [P1] — KPIs (técnico/valor/risco) reusando telemetria existente, p/ medir se a arquitetura vale.
   737	- [ ] **PROOF-DASH-001** [P2] — Dashboard/README de proofs (sem dado sensível). MVP3.
   738	- [ ] **PROOF-NARRATIVE-001** [P2] `redzone` — Artigo/post explicando sem hype. HITL.
   739	- [ ] **PROOF-PERSONA-001** [P2] — Definir quem usaria/compraria de fato (user/buyer/auditor).
   740	- [ ] **PROOF-MODULES-001** [P2] — Modularizar (replicável): `egos-proof-{core,bitcoin,eas,registry,ui,policy}`. Só após validação.
   741	- [ ] **PROOF-VERDICT-001** [P2] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
   742	
   743	## 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
   744	
   745	> SSOT: `docs/governance/EXTERNAL_ARTIFACT_INTAKE_PROTOCOL.md` v1.0. Quando Enio traz .md externo (ChatGPT/Grok/etc): land em _inbox → classifica INC-005 (REAL/CONCEPT/PHANTOM) → grande delega a agente → mapeia vs existente (não reinventar) → triagem Resolver → tasks/memória.
   746	- [ ] **PRICING-CLARITY-001** [P2] — Doc-fix (não muda preço): deixar legível no strategy doc que R$100/mês é o piso de recorrência (Demo Starter), não a âncora; receita 30d = setup fees, não MRR. (ChatGPT criticou baseado em leitura incompleta.)
   747	- [ ] **HITL-MULTICHANNEL-001** [P3] — Wire a política HITL multi-canal (Telegram+WhatsApp+email) que aparece em `.guarani/GUARANI.md` mas só tem Telegram parcial. Dispatcher único por policy.
   748	- [ ] **RULE-GOV-GAP-001** [P2] — `gem-hunter` ungoverned (sem CLAUDE.md/AGENTS.md). Decidir: adicionar adapter+symlinks .guarani (modelo egos-lab/852) OU marcar explicitamente externo. 🧊CONGELADO
   749	- [ ] **RULE-SYNC-001** [P2] — `blueprint-egos` 45d stale (sync a6d1ad7 2026-04-17). Rodar `bun scripts/disseminate-propagator.ts --all` p/ ressincronizar do kernel atual.
   750	- [ ] **INTAKE-WIRE-001b** [P3] — Wire RULE_SETS_INDEX no /start (consciência de quais regras valem onde) + monitor de lag de propagação (>30d alerta).
   751	- [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start (rule-set awareness) + gatilho comportamental do Prime + considerar virar skill `/intake`.
   752	
   753	## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
   754	
   755	> Guarani deixou 8 arquivos staged. ⚠️ Sci-Hub = circumvention de paywall — **Red Zone legal/reputacional p/ policial ativo + repo público**. NÃO commito o scraper sem corte do Enio.
   756	- [ ] **HANDOFF-SCIHUB-001** [P2] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
   757	- [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
   758	
   759	## 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
   760	
   870	
   871	- [ ] **LLM-METER-001** [P1] `4h Sonnet` — `usage_metrics` por tenant (tokens, model, alerta 80%/100% cap)
   872	- [ ] **SOLUCOES-EMPRESARIAIS-001** [P1] `3h Sonnet` — Página `/solucoes-empresariais` (ERPs, R$12k+). Link rodapé discreto.
   873	
   874	### 🔴 NOVO 2026-05-22 — Storefront UX
   875	
   876	- [ ] **UX-HOME-FEATURED-001** [P2] `3h Sonnet` — Home `featured=true` (limit 8) + `tenant_settings.home_sort_strategy` `(P0→P2 2026-06-03: pivô despriorizou storefront)`
   877	- [ ] **UX-HEADER-STICKY-FIX-001** [P2] `1h Sonnet` — Header `/catalogo` sticky não fixa (parent overflow). Mobile + desktop. `(P0→P2 2026-06-03: pivô despriorizou storefront)`
   878	- [ ] **UX-ADMIN-FEATURED-001** [P1] `2h Sonnet` — Toggle "Destaque" no admin + `featured_until` + bulk "marcar promoção"
   879	- [ ] **UX-PROMO-VISUAL-001** [P1] `2h Sonnet` — ProductCard badge "PROMOÇÃO" + preço riscado + filtro sidebar
   880	
   881	### 🔴 Sprint P0 — Demo seguro para Bernardo
   882	
   883	- [ ] **TASK-MP-DEMO-001** [P2] `4h Sonnet` — Banner preview `is_demo_mode=true` + página `/sobre-egos` (8 tiers) + link header `(P0→P2 2026-06-03: pivô despriorizou storefront)`
   884	- [ ] **TASK-VPS-WATCHER-UPDATE-001** [P1] `30min` — Watcher chama `/api/health?tenant=g-pecas` a cada 5min
   885	- [ ] **LLM-CAP-VALIDATE-001** [P2] `2h` — Validar cap 2M tokens/mês com dados reais G Peças
   886	
   887	### 🔵 AUDIT P0
   888	
   889	- [ ] **GP-MISSING-FIELDS-001** — Campos ausentes no painel admin G Peças (investigar)
   890	- [ ] **GP-SYNC-AUDIT-001** — Sync entre template e clients/g-pecas após storefront redesign
   891	
   892	---
   893	
   894	## 🎯 SPRINT ATIVO
   895	
   896	### 🔴 P0 Ativas
   897	
   898	- [ ] **CBQ-OBS-FOUNDATION-001** [P2] — Migrations Wave 0 (ver CBQ-OBS-001..003)
   899	
   900	### 🟧 P1 Ativas
   901	
   902	- [ ] **PHASE-2-HOOKS-001** [P1] — Hooks dormentes: agent-run.sh, auto-sync.sh, context-alarm.sh, cost-alert.sh, governance-drift-alert.sh, session-end.sh, session-status.sh → REATIVAR | ARQUIVAR | DELETAR
   903	- [ ] **PHASE-2-START-SLIM-001** [P1] — Enxugar `/start`: -21KB (CLAUDE.md dup) + SELF_MAPPING_INTERVIEW lazy + ADRs hash
   904	- [ ] **PHASE-2-TASKS-READER-001** [P1] — Layer 4.5 inclui `grep "^- \[ \].*\[P0\]" TASKS.md` no `/start`
   905	- [ ] **PHASE-2-PREMORTEM-SKILL-001** [P1] — Criar skill `/premortem` + trigger em skill-auto-match
   906	- [ ] **PHASE-2-SKILL-TRACKER-CRON-001** [P1] — Crontab 06:00 BRT `skill-usage-tracker.ts --days=30`
   907	
   908	### 🔵 Abertas (sem urgência imediata)
   909	
   910	- [ ] **PHASE-2-SKILL-AUDIT-001** [P2] — 14 skills sem invocação em 14d → KEEP+justificativa | ARQUIVAR | DELETAR
   911	- [ ] **PHASE-2-SOUL-IDENTITY-001** [P2] — `soul/IDENTITY.md` não lido pelo /start. Integrar Layer 1 OU arquivar.
   912	- [ ] **PHASE-2-DOTEGOS-SYNC-001** [P2] — `~/.egos/.claude/CLAUDE.md` estagnado → arquivar OU cron sync
   913	- [ ] **PHASE-2-GLOBAL-CLAUDE-SLIM-001** [P2] — Global CLAUDE.md 327L → ≤180L (Council decidiu, não executou)
   914	
   915	### ⏸️ PAUSADO
   916	
   917	- [ ] **CHAT-LGPD-001** — Aviso LGPD no chat (aguarda advogado)
   918	- [ ] **WAHA-CONNECT-001** — WA reconectar via WAHA (número em repouso desde 2026-05-14)
   919	- [ ] **FACE-000** — Reconhecimento facial (aguarda licença)
   920	- [ ] **INTELINK-DEPLOY-001** — Deploy VPS intelink (aguarda billing Supabase)
   921	
   922	### 🔴 BLOQUEADORES
   923	
   924	- ALLM-EGOS-049 Mirror S3 WORM (dep provedor)
   925	- ALLM-EGOS-050 SCC OpenAI + RIPD LGPD (dep advogado)
   926	- CET-CONTRATO-001 (dep Enio: advogado OR template)
   927	
   928	---
   929	
   930	## 📊 MATERIAL EVAL LOOP
   931	
   932	- [ ] **MATERIAL-EVAL-ANTIGRAVITY-001** [P2] — integrar Antigravity (Gemini CLI) como avaliador no loop (perspectiva não-técnico)
   933	- [ ] **MATERIAL-EVAL-CODEX-001** [P2] — integrar Codex como avaliador no loop (perspectiva de produto)
   934	- [ ] **MATERIAL-EVAL-CRON-001** [P2] — cron semanal: rodar eval loop em todos os materiais, flaggar se score caiu
   935	
   936	---
   937	
   938	## 🎯 COMERCIAL
   939	
   940	- [ ] **DEMO-MATERIAL-001** [P1] `2h` — Pack material demo: PDF 1p + vídeo walkthrough roteiro
   941	- [ ] **ONBOARD-CHECKLIST-001** [P1] `1h` — CLIENT_ONBOARDING_CHECKLIST.md atualizado (plano único)
   942	- [ ] **PRICING-COMMUNICATION-001** [P1] `1h` — One-pager externo (R$2-5k + R$100+/mês) para Bernardo
   943	- [ ] **EPOS-B5-Q2-001** [P2] `2h` — EPOS Bandeira 5 Q2: qual capability EGOS prova este trimestre?
   944	- [ ] **EPOS-RECONCILE-B1-001** [P2] `prime` — Reconciliar numeração do bloco B1: A81 (travamento técnico/visual, via Guarani 2026-06-05) e A82 (horizonte 12m "ambos em paralelo", via /start 2026-06-07) ambos rotulados B1-Q4. Verificar contra `prompts/personal-os/SELF_MAPPING_INTERVIEW.md` qual é o B1-Q4 canônico, renumerar o outro, e validar `interview_state.json` (atualmente em B1-Q5). Atoms gitignored (local). Nenhuma resposta do Enio se perde — só a numeração precisa de pente fino.
   945	
   946	---
   947	
   948	## 🖥️ VPS HARDENING
   949	
   950	- [ ] **VPS-FAIL2BAN-001** [P1] — fail2ban configurado SSH + Caddy
   951	- [ ] **VPS-APT-AUTO-001** [P1] — apt unattended-upgrades (security patches automáticos)
   952	- [ ] **VPS-CVE-SCAN-001** [P1] — trivy/grype scan nas imagens Docker
   953	- [ ] **VPS-CERT-RENEW-ALERT-001** [P1] — Alertas Telegram 30d antes de SSL expirar
   954	- [ ] **VPS-DISK-ALERT-001** [P1] — Alerta se disco >70% (atual 49%)
   955	- [ ] **VPS-SSH-HARDENING-001** [P2] — PermitRootLogin no, PasswordAuth no, key-only
   956	- [ ] **VPS-FIREWALL-AUDIT-001** [P2] — UFW rules audit: portas expostas vs necessárias
   957	- [ ] **VPS-MONITORING-AGENT-001** [P2] — Prometheus node_exporter + Grafana cloud free tier
   958	
   959	---
   960	
   961	## 🔬 INTELINK (work-hours, Frente A)
   962	
   963	- [ ] **REPORT-007** [P2] — Relatório investigação DHPP (pendente) [pertence a intelink, não framework]
   964	- [ ] **REPORT-006** [P2] — Relatório suspeitos recorrentes (dep Neo4j estável) [pertence a intelink, não framework]
   965	- [ ] **REPORT-005** [P1] — Dashboard analytics Intelink
   966	- [ ] **REPORT-004** [P1] — Exportar dados BISP para Neo4j (16k pessoas) completo
   967	
   968	---
   969	
   970	## 🧹 INTELINK PUBLIC RELEASE — capacidades de kernel (Enio 2026-06-07)
     1	# Fable 5 — Mission Brief: Auditoria Adversarial da Cadeia de Integridade
     2	
     3	> Preparado por Opus 4.8 (2026-06-09) para execução sob **Claude Fable 5**.
     4	> Objetivo: gastar os tokens caros do Fable no ponto de maior alavancagem do EGOS.
     5	> Janela: Fable 5 grátis em Pro/Max/Team até 2026-06-22.
     6	> Safeguard: Fable bloqueia cyber-ofensivo e cai pro Opus. Este alvo é SWE/governança puro → seguro.
     7	
     8	## Contexto (1 parágrafo)
     9	O diferencial do EGOS é "governance is infrastructure": gates que provam integridade (phantom-done,
    10	PII, doc-drift, provenance). Em 2026-06-09 descobrimos empiricamente **5 buracos fail-open** que
    11	passaram por revisão humana normal: (1) `--no-verify` desliga todo o chain, (2) watcher stale por
    12	heartbeat acoplado a LLM 404, (3) regex phantom-done frouxa (`commit ` solto, hex casa "deadbeef"),
    13	(4) leaves sem o hook, (5) CI não re-roda os gates. SSOT: `docs/governance/INTEGRITY_PROOF_SSOT.md`.
    14	
    15	## Alvo (ler estes arquivos)
    16	- `.husky/pre-commit` (941 linhas — o chain de enforcement)
    17	- `packages/shared/src/provenance.ts` (L1 hash)
    18	- `packages/shared/src/evidence-chain.ts` (L2)
    19	- `packages/core/src/guards/pri.ts` (L3 — escalação LLM é mock injetável)
    20	- `packages/shared/src/agent-signature.ts` (L4 Merkle/Ed25519)
    21	- `scripts/audit-phantom-done.ts` · `scripts/ai-commit-security.ts` · `scripts/security/scan-hardcoded-sensitive.ts`
    22	- `docs/governance/INTEGRITY_PROOF_SSOT.md` (a doutrina alvo)
    23	
    24	## Missão adversarial (a pergunta)
    25	Você é um atacante e um auditor de integridade. Para CADA gate/camada acima:
    26	1. **Encontre o bypass.** Como um agente (ou humano apressado) faz o gate dizer "ok" sem que o
    27	   trabalho/integridade exista? Liste TODOS os caminhos fail-open, não só os 5 já conhecidos.
    28	2. **TOCTOU / Goodhart.** Onde a verificação checa a *referência/menção* em vez do *conteúdo real*?
    29	   Onde a métrica virou alvo (gameable)?
    30	3. **Trust boundary.** Onde estado de outra janela/agente/subagente é aceito como CONFIRMADO sem
    31	   re-verificação? (OWASP A08:2025)
    32	4. **Fail-open residual.** Procure `|| true`, `.catch(()=>exit(0))`, `EGOS_*_OVERRIDE`, regex frouxa,
    33	   timeouts que liberam, defaults permissivos.
    34	5. **A camada-4 (CI).** Dado que branch protection é 403 (free/private) e a decisão foi CI fail-closed
    35	   (RULE-HARDEN-CI-GATES-001), desenhe o workflow GitHub Actions mínimo que torna `--no-verify` inócuo.
    36	
    37	## Output esperado
    38	Tabela: `gate | buraco | severidade | prova (file:line) | fix mínimo fail-closed`.
    39	Priorize por *catastrófico+silencioso+fácil-de-explorar*. Sem inventar — cite `file:line`.
    40	Classifique cada achado REAL/CONCEPT/PHANTOM (regra EGOS).
    41	
    42	## Não fazer
    43	- Não tocar código (só auditar + propor). Implementação volta pro Opus/forja com HITL.
    44	- Não auditar intelink/OSINT/cursos cyber (dispara safeguard + é Pursuit A, fora de escopo).

exec
/bin/bash -lc "git grep -n \"PII-PURGE\" -- . ':"'!TASKS.md'"' || true; git grep -n \"PII-PURGE\" -- TASKS.md" in /home/enio/egos
 succeeded in 0ms:
TASKS_ARCHIVE.md:3590:- [x] **INTELINK-PII-PURGE-001** [P0] ✅ CONTIDO 2026-06-04 — Vazamento [OPERACAO] (dado de investigação real em 3 repos + app público). Executado: site derrubado (502), histórico purgado nos 3 repos (intelink+intelink-platform squash, egos cirúrgico), force-push, branches sujas deletadas, gc, rota Caddy removida, 3 artigos genericizados, gate R-SEC-001 wired. Verificado: egos-governance limpo, 0 nome em artigos publicados, 0 Wayback, 0 forks. SSOT: `docs/INCIDENTS/INC-PII-001_investigation-data-leak.md`. Follow-ups abaixo.
TASKS_ARCHIVE.md:3591:- [x] **PII-PURGE-FOLLOWUP-001** [P0] `prime`+`guardiao` — Vetores residuais (INC-PII-001 §4) pós-decisões Enio 2026-06-04: (1) **GitHub Support ticket** purgar commits stale-by-SHA nos 3 repos. (2) **Bing manual** site:intelink.ia.br. (3) ✅ backup-mirror DELETADO. (4) neo4j → NEO4J-MIGRATE-LOCAL-001. (5) **Re-deploy VPS** baseline limpo SE reativar. Decisão Enio: (1)(2)(5)=task, não agora. ✅ 2026-06-04
TASKS_ARCHIVE.md:3717:- [x] **PII-PURGE-007** [P0] `prime` — Aplicado ao `intelink-clean` (2026-06-07): rm 2 RELINT + mascarar 7 arquivos + orphan squash + force-push. `origin/main` = baseline limpo `4bb4665` (0 PII; era f0cfdb7 c/ 18 hits). Backup local `backup-pre-squash-2026-06-07`.
TASKS_ARCHIVE.md:3726:- [x] **PII-PURGE-BUG-001** [P1] `prime` — FIX `e9886022`: dedupe de spans sobrepostos (longest-wins) em `applyReplacements`. Teste + smoke: placa com/sem traço → 1 token limpo, sem corrupção `[PESSOA_N]_`.
TASKS_ARCHIVE.md:3727:- [x] **PII-PURGE-VERIFY-001** [P1] `prime` — FIX `e9886022`: safety-net de busca literal (`scanLiteralValues`/`flattenEntityValues`) ligado ao `verify` — independe da tipagem do campo; pega valor de texto em campo numérico. + `--verify-only` (publish gate) + exclui o próprio dict do scan. 31 testes verdes.
TASKS_ARCHIVE.md:3733:- [x] **PII-PURGE-SKILL-001** [P2] `prime` — DONE: skill `/purge` em `.claude/commands/purge.md` (dict HITL → dry-run → review → apply HITL → verify + sweep independente + histórico + cleanup) com runbook embutido. Auto-descoberta.
docs/_archived_handoffs/handoff_2026-06-04-evening-marathon.md:15:- **Task:** `INTELINK-PII-PURGE-001` [P0]. **Prime NÃO age sem autorização explícita do Enio (dado PCMG, Red Zone).**
docs/_archived_handoffs/handoff_2026-06-04-evening-marathon.md:55:- `INTELINK-PII-PURGE-001` [P0] 🔴 (acima)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:151:- `PII-PURGE-001` Scaffold `packages/pii-purge/` + EntityDictionary schema (JSON gitignored)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:152:- `PII-PURGE-002` Pattern Generator (reusa masks.ts + fuzzy-name.ts)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:153:- `PII-PURGE-003` Scanner CLI (fork scan-hardcoded-sensitive.ts + `--entity-dict`)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:154:- `PII-PURGE-004` Purge mode + token-map coerente + audit hash-chained (`--dry-run` first)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:155:- `PII-PURGE-005` Verify gate pós-purge (zero-tolerância) + wire publish gate (R-SEC-005)
docs/_archived_handoffs/handoff_2026-06-07-intelink-public-release.md:156:- `PII-PURGE-006` CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY
docs/audits/INTELINK_PII_PURGE_PLAN_2026-06-04.md:1:# Plano de Purga PII — Operação INTELINK-PII-PURGE-001
docs/audits/INTELINK_PII_PURGE_PLAN_2026-06-04.md:4:> **Task:** INTELINK-PII-PURGE-001 | **Autorização:** Enio (2026-06-04) — "limpar tudo + endurecer regras, sem vestígio na internet"
packages/pii-purge/README.md:118:*Gate de publicação: R-SEC-005 + WS4 (PII-PURGE-001..005)*
scripts/security/purge-gate.sh:2:# purge-gate.sh — Publish gate do motor pii-purge (R-SEC-005 / WS4 PII-PURGE-GATE-WIRE-001)
TASKS.md:21:4. **PII-PURGE-001..005** — motor de purge generalizado (segurança estrutural). P0 com ressalva: é tooling, não WIP.
TASKS.md:975:- [ ] **PII-PURGE-001** [P0] `prime`+`forja` — Scaffold `packages/pii-purge/` + EntityDictionary schema (JSON gitignored `~/.egos-purge-entities.json`). Reusa guard-brasil/masks/fuzzy-name (não criar do zero — ver handoff §4).
TASKS.md:976:- [ ] **PII-PURGE-002** [P0] `forja` — Pattern Generator: entidade conhecida → todas variantes (CPF formatado/cru, placa antiga/Mercosul, nome via `normalizeOrtho`). Reusa `intelink/lib/masks.ts` + `fuzzy-name.ts`.
TASKS.md:977:- [ ] **PII-PURGE-003** [P0] `forja` — Scanner CLI (fork `scripts/security/scan-hardcoded-sensitive.ts` + flag `--entity-dict`). NUNCA imprime valor casado. JSON report.
TASKS.md:978:- [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
TASKS.md:979:- [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
TASKS.md:980:- [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
TASKS.md:981:- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — MECANISMO PRONTO: `scripts/security/purge-gate.sh` (roda `--verify-only`, skip gracioso sem dict, exit 1 detectando). FALTA: plugar nos hooks reais — pre-commit (frozen zone → mudança deliberada) + publish paths (push/NotebookLM/deploy). Opt-in por ora.

exec
/bin/bash -lc "grep -n \"\\[P0\\]\" TASKS.md | wc -l && grep -n \"\\[P0\" TASKS.md | head -50" in /home/enio/egos
 succeeded in 0ms:
35
15:> 5 launch → `[P0-BLOCKED-MIGUEL]` (dependem do Miguel validar primeiro).
34:- [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
35:- [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
39:- [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
40:- [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
41:- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
50:- [ ] **VALIDATE-PROVENANCE-001** [P0] `prime`+`provador` — **Jogada de maior alavancagem (1 ato, 4 retornos):** rodar as 4 camadas de provenance no ambiente real + GRAVAR. L1 `packages/shared/src/provenance.ts` (hash) · L2 `evidence-chain.ts` (claim→fonte) · L3 PRI gate (ALLOW/BLOCK/DEFER/ESCALATE) · L4 `agent-signature.ts` (Merkle) · +`guard-brasil` (PII). A gravação: (1) valida tools do MCP pessoal (núcleo-16), (2) é a prova que a identidade arquiteto-diagnosticador exige, (3) é evidência do artigo forense (branch `personal-os/ikigai-compass` @71eb0317, deferido), (4) loop-closure estilo item-intake. **Red Zone:** ângulo forense/PCMG = HITL+Guardião, nunca público sem corte. Une sessão main + branch ikigai-compass. [NÃO executado — exige Enio rodar+gravar no desktop; marcação [x] revertida 2026-06-09 = phantom-done corrigido, R-CAP-001]
59:- [ ] **RULE-HARDEN-CI-GATES-001** [P0] `hermes-ops` — CI workflow (GitHub Actions) que re-roda os 4 gates críticos (gitleaks fail-closed, PII sweep history-wide, phantom-done exit 1, frozen-zone) independente de `--no-verify`. CI é a lei; hook é conveniência.
60:- [/] **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] `forja` — `ai-commit-security.ts:146` CORRIGIDO (2026-06-09): `main().catch(()=>exit(0))` → `main().catch((e)=>{ log; exit(1) })` (crash agora bloqueia). `scan-hardcoded-sensitive.ts` já estava correto (sem .catch silencioso). Falta: `// scan-ok: mock` pattern validation (não auto-declarado). 80% feito.
69:- [/] **RULE-HARDEN-NOVERIFY-DENY-001** [P0] `forja` — settings.json ATUALIZADO (2026-06-09): deny `Bash(*git commit --no-verify*)` + `Bash(*git commit -n *)` adicionados. Falta: PATH shim `~/bin/git` (defesa extra, não crítico — CI é a camada real). 70% feito.
70:- [ ] **DISSEMINATE-INTEGRITY-002** [P0] `prime`+`forja` — CONFIRMADO: o guard phantom-done do pre-commit + `audit-phantom-done.ts` vivem SÓ no kernel — `grep` em `852/.husky` e `egos-lab/.husky` = 0. A "disseminação" da 2ª metade propagou docs de governança, NÃO o enforcement de integridade aos leaves. Propagar o bloco phantom-done (pre-commit) + script audit via `disseminate-propagator.ts` aos leaves que têm TASKS.md. Prova: re-grep nos leaves após.
72:- [ ] **BRANCHPROTECT-PLAN-DECISION-001** [P0] `prime` — ✅ DECIDIDO (corte Enio 2026-06-09): opção **(c) CI fail-closed como camada-4 de facto** (RULE-HARDEN-CI-GATES-001) — não pagar Pro nem expor repo agora. ⏳ Task só fecha quando CI-GATES estiver LIVE (decisão ≠ implementação). Branch protection 403 (free/private) → RULE-HARDEN-BRANCHPROTECT-001 deferida. Registrado em handoff_2026-06-09.md + memória.
100:- [ ] **HOTMART-LAUNCH-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL-Enio` — Enio cria produto na Hotmart. Campos completos em APRESENTACAO_EGOS.md PARTE F checklist. Enio executa após gravar vídeo.
101:- [ ] **VIDEO-RECORD-001** [P0-BLOCKED-MIGUEL] `enio` — Enio grava vídeo 2:30 com PARTE E do roteiro. Legenda sempre. Mostrar tela nas demos (GPT + Guard Brasil). Sem mencionar delegacia atual.
102:- [ ] **GPT-CREATE-001** [P0-BLOCKED-MIGUEL] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
103:- [ ] **MIGUEL-GOW-SEND-001** [P0] `prime` — Enviar HTML piloto MF Certificados para Miguel (dono da GOW). Arquivo: docs/presentations/mf-certificados-piloto.html. Incluir link NotebookLM (áudio overview pronto). Registrar envio aqui.
104:- [ ] **SOCIAL-LAUNCH-001** [P0-BLOCKED-MIGUEL] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
112:- [/] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — pesquisa feita, aplicar no design da demo. PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
117:- [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
129:- [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
131:- [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
132:- [ ] **PRICING-FOUNDING-PASS-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
166:- [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
180:- [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
238:- [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade. Resultado do workflow (14 agentes): classificação completa em PUBLIC_DOCS/PUBLIC_DEMO/PRIVATE_CORE/PRIVATE_SECURITY/PRIVATE_PCMG/ARCHIVE/NEEDS_REVIEW disponível em docs/audit/repositories-public-private-classification.md (a criar). NENHUM repo abre ou fecha sem auditoria + HITL do Enio. Prioridade: qual repo público principal (candidato: egos-governance já público, mas enxuto — candidato principal para ser o hub educacional).
243:- [ ] **COURSE-PCMG-GATE-001** [P0] `redzone` 🔴 — Verificar formalmente se recebimento de pagamento por cursos via pessoa física é compatível com o estatuto do servidor PCMG. Liga BLOCKCHAIN-002-ETHIK-LEGAL (aberto). Magistério esporádico = OK por lei; venda direta via plataforma digital = verificar. Recomendação provisória: usar Hotmart (eles são a empresa que vende, Enio recebe como "produtor" — estrutura aceita pela maioria dos servidores públicos). HITL obrigatório antes de ativar qualquer cobrança.
253:- [ ] **README-OVERHAUL-001** [P0] `voz`+`pixel` `gated:HITL` 🔴 — Reescrever README.md principal do EGOS seguindo o padrão aiox: (1) badges NPM/CI/codecov/docs; (2) "Comece Aqui 10min" linear; (3) tabela de paridade de hooks por ambiente (Claude Code / Gemini CLI / Codex / Cursor / Windsurf / Antigravity); (4) hierarquia clara Governance First → CLI → Observability; (5) "As Duas Inovações EGOS" (governance + anti-alucinação); (6) guias por plataforma; (7) **PT-BR (público-alvo Brasil — corte Enio 2026-06-07); EN no máximo opcional/secundário, NUNCA lidera nem bloqueia.** HITL: Enio aprova antes de publicar. Critério: avaliador de IA dá ≥8/10.
278:- [ ] **COMM-BLUEPRINT-APPLY-001** [P0] `voz`+`pixel` `gated:HITL` — Aplicar o egos-communication-blueprint.md ao README.md principal. Critério: eval-loop score ≥ 8.0. HITL: Enio aprova antes de publicar. Depende de: workflow w08tv4z7k completar.
293:- [ ] **CRYPTO-WALLETS-FILL-001** [P0] `prime` `gated:HITL` 🔴 — Enio fornece endereços públicos de recebimento cripto (BTC, ETH, Base, SOL, TRX/USDT) para preencher docs/business/founding-pass/crypto-payment-setup.md. NUNCA seed phrase ou private key. Só endereços de recebimento. Gate: Enio revisa antes de qualquer publicação.
294:- [ ] **SOCIAL-COPY-APPROVE-001** [P0] `prime` `gated:HITL` 🔴 — Enio aprova copy completo (X.com thread 5 tweets + Instagram 3 posts + WhatsApp mensagem + Telegram) em docs/business/founding-pass/posts-ready-to-publish.md antes de qualquer publicação. Nada publica sem HITL.
348:- [/] **TG-FIX-001** [P0] `gateway` — Diagnosticar+consertar `@EGOSin_bot`. **CÓDIGO FEITO 2026-06-03 (Forja):** gate `TELEGRAM_MODE` (polling|webhook|disabled) em `telegram.ts` + `.env.example` (typecheck limpo). Resolve 409/duplicação (local+VPS competindo). **FALTA (Enio/Red Zone):** setar `TELEGRAM_MODE=webhook` no `.env.production` da VPS + homologar live.
676:- [/] **FE-SYNC-001** [P0] `prime` — **ACHADO RAIZ 2026-06-01:** o `/opt/egos-site/src/server.ts` em produção está **~1931 linhas ATRÁS** do repo (sem i18n/trading/tema/render novo). **É POR ISSO que o frontend não reflete nada** — prod roda server.ts de meses atrás (deploy drift). ✅ Dado já LIVE: `git pull` em `/opt/egos-git` (mount `docs/jobs:ro`) → `/status.json` fresco hoje + bloco framework (79/27/MCPs). ❌ Falta: **release controlado do egos-site** (deploy do server.ts atual = release GRANDE, não rebuild trivial — testar i18n/trading/deps no env prod + 502-safe + prova visual §10). Build context `/opt/egos-site` é NÃO-git → precisa pipeline de deploy real. NÃO fazer blind.
731:- [/] **RT-INVENTORY-001** [P0] — Inventário do que EGOS já tem (transparência radical/Ethik/observabilidade/telemetria/KPIs/audit/decision records/Guard Brasil). (workflow)
732:- [/] **PROOF-ARCH-001** [P0] — Pesquisa Bitcoin/OTS, EAS/Base, BTC L2s (Stacks/Rootstock/Liquid/RGB/Taproot), não-blockchain (Sigstore/Rekor/SLSA/OTel) + interoperabilidade Layer A↔B. (workflow)
733:- [/] **CTX-BOUNDARY-001** [P0] — Mapa de contexto: IA-window / off-chain registry / proof layer / public layer. O que vai onde + tamanho. (workflow)
815:- [/] **L0-INV-004** [P0] `30min Sonnet` — `[Categoria: Investigação]` **(elevado P2→P0 por Codex CRITICAL #1/#2 2026-05-29)** **PARTE RUNTIME FEITA 2026-05-29:** ambos MCPs autenticados e testados em Claude Code; claim original REFUTADO — 3 caminhos de Drive complementares (Drive Desktop+Filesystem canônico p/ escritório; NotebookLM ingere doc conhecido; Drive MCP navega/descobre). Doc: `docs/audits/2026-05-29-drive-mcp-availability.md`. Claim corrigido no doc de integração. **FALTA (gate humano Enio):** validar lado Claude Desktop do cliente (app diferente) com login real em conta Pro.
904:- [ ] **PHASE-2-TASKS-READER-001** [P1] — Layer 4.5 inclui `grep "^- \[ \].*\[P0\]" TASKS.md` no `/start`
975:- [ ] **PII-PURGE-001** [P0] `prime`+`forja` — Scaffold `packages/pii-purge/` + EntityDictionary schema (JSON gitignored `~/.egos-purge-entities.json`). Reusa guard-brasil/masks/fuzzy-name (não criar do zero — ver handoff §4).
976:- [ ] **PII-PURGE-002** [P0] `forja` — Pattern Generator: entidade conhecida → todas variantes (CPF formatado/cru, placa antiga/Mercosul, nome via `normalizeOrtho`). Reusa `intelink/lib/masks.ts` + `fuzzy-name.ts`.
977:- [ ] **PII-PURGE-003** [P0] `forja` — Scanner CLI (fork `scripts/security/scan-hardcoded-sensitive.ts` + flag `--entity-dict`). NUNCA imprime valor casado. JSON report.
978:- [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
979:- [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.

codex
The patch introduces a canonical-looking P0 election but leaves many other P0 tags active, so humans and automation scanning TASKS.md will still see an inflated P0 queue. This undermines the main operational intent of the change.

Review comment:

- [P2] Make the P0 election match the remaining P0 tags — /home/enio/egos/TASKS.md:17-21
  If this new section is meant to define the real P0 queue, the rest of `TASKS.md` still contains many unchanged `[P0]` entries; `grep -n "\[P0\]" TASKS.md` currently returns 35 matches. Agents and existing task readers that scan the file for `[P0]` will still surface tasks outside this four-item election, so the prioritization change does not actually reduce the operational P0 queue unless those entries are demoted or the automation is taught to use this section as the source of truth.
The patch introduces a canonical-looking P0 election but leaves many other P0 tags active, so humans and automation scanning TASKS.md will still see an inflated P0 queue. This undermines the main operational intent of the change.

Review comment:

- [P2] Make the P0 election match the remaining P0 tags — /home/enio/egos/TASKS.md:17-21
  If this new section is meant to define the real P0 queue, the rest of `TASKS.md` still contains many unchanged `[P0]` entries; `grep -n "\[P0\]" TASKS.md` currently returns 35 matches. Agents and existing task readers that scan the file for `[P0]` will still surface tasks outside this four-item election, so the prioritization change does not actually reduce the operational P0 queue unless those entries are demoted or the automation is taught to use this section as the source of truth.
```
