# Codex Local Review — 2026-06-10T00:21:05Z

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
session id: 019eaee7-7f53-7893-b4b1-a586bee08abf
--------
user
changes against 'HEAD~3'
2026-06-10T00:21:10.196926Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T00:21:18.173284Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 80bbb6ee1dc8670162ffab73c340f70c6172a90a --stat && git diff 80bbb6ee1dc8670162ffab73c340f70c6172a90a' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                      |  54 ++--
 docs/_current_handoffs/handoff_2026-06-09b.md | 109 ++++---
 docs/jobs/2026-06-09-doc-drift-verifier.json  |   4 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json |  24 ++
 docs/tutor/PROVENANCE_4_CAMADAS.html          | 419 ++++++++++++++++++++++++++
 5 files changed, 551 insertions(+), 59 deletions(-)
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
 
diff --git a/docs/_current_handoffs/handoff_2026-06-09b.md b/docs/_current_handoffs/handoff_2026-06-09b.md
index acb75821..40d0cd1d 100644
--- a/docs/_current_handoffs/handoff_2026-06-09b.md
+++ b/docs/_current_handoffs/handoff_2026-06-09b.md
@@ -1,51 +1,84 @@
-# Handoff — 2026-06-09 (sessão PRs + hardening)
+# Handoff — 2026-06-09 (sessão 2ª parte + /end completo)
 
 ## ✅ Accomplished (com SHAs)
-- CI-DEPENDABOT-BUNLOCK-001 [DONE] — `25ba5d1a` — pr-review.yml/ci.yml/capability-eval.yml/security.yml adaptados para dependabot (skip --frozen-lockfile + skip claude-code-action para bots)
-- PRs fechados via gh cli: #92 (zod 3→4 disfarçado de minor) + #83 (archived dead code)
-- Dependabot rebase triggerado em #82, #85, #86, #87, #88
-- RULE-HARDEN-AISECURITY-FAILCLOSED-001 [80%] — `scripts/ai-commit-security.ts:146` crash agora bloqueia (sem SHA ainda — uncommitted → Phase 12)
-- RULE-HARDEN-NOVERIFY-DENY-001 [70%] — `.claude/settings.json` deny rules adicionadas (sem SHA ainda → Phase 12)
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
 
 ## 🔄 In Progress
-- **PR-82-GITLEAKS-SECRET-001** — 0% — CI falha por `GITLEAKS_LICENSE` inacessível a dependabot. Fix: `if: github.actor != 'dependabot[bot]'` no security-scan job.
-- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** — 80% — falta `// scan-ok: mock` pattern validation
-- **RULE-HARDEN-NOVERIFY-DENY-001** — 70% — falta PATH shim ~/bin/git (não crítico)
+
+- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] — 80% — ai-commit-security.ts corrigido (exit 1), falta `// scan-ok: mock` pattern validation
+- **RULE-HARDEN-NOVERIFY-DENY-001** [P0] — 70% — settings.json done, PATH shim `~/bin/git` pendente
+- **FOCUS-ITEMINTAKE-CLOSE-001** [P0] — outreach feito 2026-06-09, aguarda resposta Diesom (Kyte)
+- **GUARD-BRASIL-AUDIT-001** [P1] — agente rodou, falta consolidar achados
 
 ## ⏳ Blocked
-- **BRANCHPROTECT-PLAN-DECISION-001** [P0 HITL] — GitHub Pro ou repo público necessário. Decisão do Enio.
-- **PR-MAJORS-AUDIT-001** — #85-88 em hold aguardando teste manual em branch isolada
 
-## 🔗 Next Steps (priority order)
-1. **PR-82-GITLEAKS-SECRET-001** [P1] — fix security.yml + merge #82 (gitleaks 2→3 safe bump)
-2. **DISSEMINATE-INTEGRITY-002** [P0] — propagar phantom-done guard para leaves (852/.husky, egos-lab/.husky)
-3. **RULE-HARDEN-CI-GATES-001** [P0] — CI workflow com 4 gates críticos independente de --no-verify
-4. **TASKS-OVERFLOW-001** [P0] — TASKS.md em ~970L, grace até 2026-06-15 → `bun scripts/tasks-archive.ts --exec`
-5. **FOCUS-MIGUEL-DIAG-001** [P0] — enviar HTML piloto para Miguel (arquivo pronto: docs/presentations/mf-certificados-piloto.html)
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
 
 ## 🌐 Environment State
-- Build: ✅ (typecheck passa, bundle-runtime ativo)
-- Tests: ✅ (pii-gate.test.ts 7/7 pass)
-- Deploy: VPS healthy (gateway/guard-brasil/hq/852 todos 200, Supabase sb_ keys ativas)
-- PRs abertos: 7 (#82 aguardando CI, #85-88 on hold, #89/#91 outra sessão)
-- AHEAD of origin/main: 1 commit (5768db24)
+
+- Build: ✅ typecheck OK (sessão anterior)
+- Tests: ⚠️ 88/93 MCP golden, 9/80 CBCs com golden real
+- Deploy: VPS hq.egos.ia.br HTTP 200 ✅
+- Watcher: ✅ heartbeat fail-safe corrigido `25ba5d1a`
+- Supabase: ✅ nova key ativa, legacy desabilitada
+- TASKS.md: 🔴 ~900L (limit 600) — ARCHIVE IMEDIATO NECESSÁRIO
 
 ## 📌 Decisions Made
-- PR #92 fechado: zod 3→4 em 15 package.json sem breaking test coverage = risco, não merge automático
-- PR #83 fechado: apps/_archived é código morto, deps sem valor
-- Dependabot PRs: usar `@dependabot rebase` para re-trigger CI após fix de workflow
-- GITLEAKS em dependabot PRs: secret bloqueado por design do GitHub → solução = skip job para dependabot
-
-## 📌 PRs status resumo
-| PR | Título | Estado |
-|----|--------|--------|
-| #82 | gitleaks 2→3 | CI falha (secret issue) — fix pendente |
-| #85 | simplewebauthn 11→13 | Hold — security-critical, testar |
-| #86 | lucide 0.577→1.17 | Hold — UI, provavelmente safe |
-| #87 | jose 5→6 | Hold — JWT breaking change |
-| #88 | @types/node 20→25 | Hold — types only, provavelmente safe |
-| #89 | financial-intel | Outra sessão — Red Zone |
-| #91 | curriculum-gate | Outra sessão — HITL |
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
 
 ## 🚫 Marked [CONCEPT]
-- PATH shim ~/bin/git para interceptar --no-verify em qualquer posição (deferido — CI é a camada real)
+
+- VALIDATE-PROVENANCE-001 — não executado (exige Enio rodar+gravar)
+- MCP-PESSOAL-ENIO-001 endpoint — só curadoria/design feita
+- WA-AGENT-ASYNC-ARCH-001 — design pendente corte Enio
+
+---
+*v6.5 | 2026-06-09 | SHA HEAD: 5768db24*
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

exec
/bin/bash -lc "git diff --name-only 80bbb6ee1dc8670162ffab73c340f70c6172a90a && sed -n '1,220p' docs/tutor/PROVENANCE_4_CAMADAS.html && echo '--- JSONs' && cat docs/jobs/2026-06-09-pre-commit-pipeline.json && echo && cat docs/jobs/2026-06-09-doc-drift-verifier.json" in /home/enio/egos
 succeeded in 0ms:
TASKS.md
docs/_current_handoffs/handoff_2026-06-09b.md
docs/jobs/2026-06-09-doc-drift-verifier.json
docs/jobs/2026-06-09-pre-commit-pipeline.json
docs/tutor/PROVENANCE_4_CAMADAS.html
<!DOCTYPE html>
<html lang="pt-BR" data-theme="auto">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>As 4 Camadas de Provenance — como o EGOS prova que algo é verdade | EGOS</title>
  <style>
    /* =============================================
       EGOS HTML TUTOR — herda VISUAL_IDENTITY.md v1.1.0
       Gerado conforme HTML_GENERATION_CONSTITUTION.md (R-HTML-001..008)
       ============================================= */
    :root {
      --egos-black:#0A0E27; --egos-navy:#1A2F5A; --egos-blue:#2563EB;
      --egos-green:#10B981; --egos-amber:#F59E0B; --egos-red:#EF4444;
      --egos-white:#FFFFFF; --egos-gray-50:#F9FAFB; --egos-gray-200:#E5E7EB;
      --egos-gray-600:#4B5563; --egos-gray-900:#111827;
      --bg:#FFFFFF; --surface:#F9FAFB; --text-primary:#0A0E27;
      --text-muted:#4B5563; --border:#E5E7EB; --code-bg:#F1F5F9;
      --sidebar-w:260px; --header-h:52px; --max-content:880px; --radius:8px; --radius-sm:4px;
    }
    body.dark {
      --bg:#0A0E27; --surface:#1A2F5A; --text-primary:#F1F5F9;
      --text-muted:#94A3B8; --border:#2D3E5F; --code-bg:#0F172A;
    }
    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
    html { scroll-behavior:smooth; }
    body {
      font-family:-apple-system,BlinkMacSystemFont,'Segoe UI','Inter',Roboto,sans-serif;
      font-size:16px; line-height:1.65; background:var(--bg); color:var(--text-primary);
      display:flex; flex-direction:column; min-height:100vh; transition:background .2s,color .2s;
    }
    .egos-header {
      position:fixed; top:0; left:0; right:0; height:var(--header-h);
      background:var(--egos-black); color:#fff; display:flex; align-items:center;
      gap:12px; padding:0 16px; z-index:200; box-shadow:0 2px 8px rgba(0,0,0,.4);
    }
    .header-logo { font-size:18px; font-weight:800; color:var(--egos-blue); letter-spacing:-.5px; flex-shrink:0; }
    .header-logo span { color:#fff; font-weight:400; font-size:14px; margin-left:6px; opacity:.7; }
    .header-title { flex:1; font-size:14px; font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; opacity:.9; }
    .header-actions { display:flex; gap:8px; flex-shrink:0; align-items:center; }
    .btn-icon { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); color:#fff;
      border-radius:var(--radius-sm); padding:5px 10px; cursor:pointer; font-size:14px; line-height:1; transition:background .15s; }
    .btn-icon:hover { background:rgba(255,255,255,.25); }
    .btn-icon:focus-visible { outline:2px solid var(--egos-blue); outline-offset:2px; }
    .btn-hamburger { display:none; }
    .egos-layout { display:flex; margin-top:var(--header-h); flex:1; }
    .egos-sidebar {
      position:fixed; top:var(--header-h); left:0; bottom:0; width:var(--sidebar-w);
      background:var(--surface); border-right:1px solid var(--border); overflow-y:auto;
      padding:16px 0 32px; z-index:100; transition:transform .25s ease;
    }
    .sidebar-section-label { font-size:10px; font-weight:700; text-transform:uppercase;
      letter-spacing:.1em; color:var(--text-muted); padding:12px 16px 4px; }
    .sidebar-link { display:block; padding:5px 16px; font-size:13px; color:var(--text-primary);
      text-decoration:none; border-left:3px solid transparent; transition:all .15s;
      white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .sidebar-link:hover, .sidebar-link[aria-current="page"] {
      background:var(--bg); border-left-color:var(--egos-blue); color:var(--egos-blue); }
    .sidebar-link:focus-visible { outline:2px solid var(--egos-blue); outline-offset:-2px; }
    .egos-main { margin-left:var(--sidebar-w); flex:1; padding:32px 28px 48px; }
    .content-wrap { max-width:var(--max-content); }
    h1 { font-size:2rem; font-weight:700; line-height:1.2; margin-bottom:8px; }
    h2 { font-size:1.5rem; font-weight:600; line-height:1.25; margin:44px 0 12px; padding-bottom:8px; border-bottom:2px solid var(--border); }
    h3 { font-size:1.15rem; font-weight:600; margin:24px 0 8px; }
    h4 { font-size:1rem; font-weight:600; margin:16px 0 6px; color:var(--text-muted); }
    p { margin-bottom:12px; }
    ul,ol { padding-left:22px; margin-bottom:12px; }
    li { margin-bottom:5px; }
    a { color:var(--egos-blue); text-decoration:none; }
    a:hover { text-decoration:underline; }
    strong { font-weight:600; }
    section { scroll-margin-top:calc(var(--header-h) + 16px); }
    .doc-meta { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:24px; font-size:13px; color:var(--text-muted); }
    .doc-meta span { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius-sm); padding:2px 8px; }
    .callout { border-left:4px solid var(--egos-blue); background:var(--surface);
      border-radius:0 var(--radius) var(--radius) 0; padding:12px 16px; margin:16px 0; font-size:15px; }
    .callout.green { border-left-color:var(--egos-green); background:rgba(16,185,129,.07); }
    .callout.amber { border-left-color:var(--egos-amber); background:rgba(245,158,11,.07); }
    .callout.red { border-left-color:var(--egos-red); background:rgba(239,68,68,.07); }
    .callout-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; margin-bottom:4px; opacity:.7; }
    .badge { display:inline-block; padding:1px 7px; border-radius:12px; font-size:11px; font-weight:700; letter-spacing:.04em; vertical-align:middle; }
    .badge.real { background:rgba(16,185,129,.15); color:var(--egos-green); }
    .badge.concept { background:rgba(37,99,235,.12); color:var(--egos-blue); }
    .badge.phantom { background:rgba(75,85,99,.15); color:var(--text-muted); }
    .badge.partial { background:rgba(245,158,11,.15); color:var(--egos-amber); }
    .badge.t1 { background:rgba(245,158,11,.15); color:var(--egos-amber); }
    code { font-family:'JetBrains Mono','SF Mono',Monaco,Menlo,'Courier New',monospace; font-size:13px;
      background:var(--code-bg); border:1px solid var(--border); border-radius:var(--radius-sm); padding:1px 5px; }
    pre { background:var(--egos-gray-900); color:#E2E8F0; border-radius:var(--radius); padding:16px;
      overflow-x:auto; font-size:13px; line-height:1.6; margin:16px 0; }
    pre code { background:none; border:none; padding:0; color:inherit; font-size:inherit; }
    .table-wrap { overflow-x:auto; margin:16px 0; }
    table { width:100%; border-collapse:collapse; font-size:14px; }
    th { background:var(--surface); font-weight:600; text-align:left; padding:8px 12px; border-bottom:2px solid var(--border); }
    td { padding:8px 12px; border-bottom:1px solid var(--border); vertical-align:top; }
    tr:last-child td { border-bottom:none; }
    .section-divider { height:1px; background:var(--border); margin:32px 0; }
    /* Cartão de camada */
    .layer-card { border:1px solid var(--border); border-radius:var(--radius); padding:18px 20px; margin:18px 0;
      background:var(--surface); }
    .layer-card h3 { margin-top:0; display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
    .layer-num { display:inline-flex; align-items:center; justify-content:center; width:30px; height:30px;
      border-radius:8px; background:var(--egos-blue); color:#fff; font-weight:800; font-size:14px; flex-shrink:0; }
    .layer-card .use-case { border-left:3px solid var(--egos-green); padding:8px 14px; margin:12px 0 4px;
      background:rgba(16,185,129,.06); border-radius:0 6px 6px 0; font-size:14.5px; }
    .layer-card .use-case b { color:var(--egos-green); }
    .kv { font-size:13px; color:var(--text-muted); margin-top:8px; }
    .egos-footer { margin-left:var(--sidebar-w); background:var(--egos-black); color:rgba(255,255,255,.75);
      padding:16px 28px; font-size:12px; display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:12px; }
    .footer-brand { font-weight:700; color:var(--egos-blue); font-size:13px; display:block; margin-bottom:2px; }
    .footer-tagline { opacity:.6; font-size:11px; }
    .footer-provenance { text-align:right; line-height:1.8; }
    .footer-provenance code { background:rgba(255,255,255,.08); border:none; color:rgba(255,255,255,.85); font-size:11px; }
    @media (max-width:768px) {
      .egos-sidebar { transform:translateX(-100%); width:80vw; max-width:300px; box-shadow:4px 0 20px rgba(0,0,0,.3); }
      .egos-sidebar.open { transform:translateX(0); }
      .btn-hamburger { display:flex; }
      .egos-main { margin-left:0; padding:20px 16px 48px; }
      .egos-footer { margin-left:0; flex-direction:column; }
      .footer-provenance { text-align:left; }
      h1 { font-size:1.5rem; } h2 { font-size:1.25rem; }
    }
    .sidebar-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:99; }
    .sidebar-overlay.active { display:block; }
    @media (prefers-reduced-motion:reduce) { *,*::before,*::after { transition:none!important; animation:none!important; } html { scroll-behavior:auto; } }
  </style>
</head>
<body>

  <header class="egos-header" role="banner">
    <button class="btn-icon btn-hamburger" id="btn-menu" aria-label="Abrir menu de navegação" aria-expanded="false" aria-controls="sidebar">☰</button>
    <div class="header-logo">EGOS<span>/ Provenance</span></div>
    <div class="header-title" aria-hidden="true">As 4 Camadas de Provenance — como o EGOS prova que algo é verdade</div>
    <div class="header-actions">
      <button class="btn-icon" id="btn-theme" aria-label="Alternar modo claro/escuro" title="Alternar tema">☀</button>
    </div>
  </header>

  <div class="sidebar-overlay" id="sidebar-overlay" aria-hidden="true"></div>

  <div class="egos-layout">
    <nav class="egos-sidebar" id="sidebar" aria-label="Índice do documento">
      <div class="sidebar-section-label">Nesta página</div>
      <a href="#o-problema" class="sidebar-link">O problema que isto resolve</a>
      <a href="#visao-geral" class="sidebar-link">Visão geral das 4 camadas</a>
      <a href="#l1" class="sidebar-link">L1 — Hash (impressão digital)</a>
      <a href="#l2" class="sidebar-link">L2 — Cadeia de evidência</a>
      <a href="#l3" class="sidebar-link">L3 — Portão PRI (decisão)</a>
      <a href="#l4" class="sidebar-link">L4 — Merkle / assinatura</a>
      <a href="#pii" class="sidebar-link">+ Guard PII</a>
      <a href="#caso-completo" class="sidebar-link">Um caso, ponta-a-ponta</a>
      <a href="#honestidade" class="sidebar-link">Por que 4,5 e não 5</a>
      <a href="#glossario" class="sidebar-link">Glossário</a>
      <div class="sidebar-section-label" style="margin-top:12px;">Referências</div>
      <a href="#rodape" class="sidebar-link">Proveniência</a>
    </nav>

    <main class="egos-main" id="main-content">
      <div class="content-wrap">

        <h1>As 4 Camadas de Provenance</h1>
        <p style="font-size:1.05rem; color:var(--text-muted);">Como o EGOS prova que algo é verdade — em vez de só afirmar.</p>
        <div class="doc-meta">
          <span>Versão 1.0.0</span>
          <span>Gerado em 2026-06-09</span>
          <span class="badge t1">T1</span>
          <span class="badge real">4 camadas REAIS</span>
          <span class="badge partial">1 sub-camada PARCIAL (honesta)</span>
        </div>

        <div class="callout">
          <div class="callout-label">Para que serve este documento</div>
          Explicar, em linguagem de gente, o que são as 4 camadas de <em>provenance</em> (proveniência) do EGOS, com um caso de uso concreto para cada uma. <strong>Provenance</strong> = a trilha que mostra <em>de onde uma informação veio, se ela foi alterada, e por que você pode confiar nela</em>. É o coração do EGOS como "arquiteto-diagnosticador": o valor não está em afirmar, está em <strong>provar</strong>.
        </div>

        <div class="section-divider"></div>

        <section id="o-problema" aria-labelledby="h-problema">
          <h2 id="h-problema">O problema que isto resolve</h2>
          <p>Imagine um laudo, um relatório de investigação, ou uma conclusão gerada por IA. Três perguntas sempre ficam no ar:</p>
          <ul>
            <li><strong>Esse arquivo foi mexido depois de pronto?</strong> (integridade)</li>
            <li><strong>De onde veio cada afirmação — é fato, dedução ou chute?</strong> (origem)</li>
            <li><strong>Posso confiar que ninguém apagou ou trocou um registro antigo?</strong> (histórico)</li>
          </ul>
          <p>A maioria dos sistemas responde "confie em mim". O EGOS responde com <strong>prova matemática verificável</strong>. Cada camada abaixo ataca uma dessas perguntas. Juntas, transformam "eu afirmo" em "eu provo, e qualquer um pode checar".</p>
          <div class="callout amber">
            <div class="callout-label">A regra-mãe por trás disso</div>
            "Afirmação sem prova é afirmação inválida." Provar é o último passo obrigatório de toda tarefa — não um opcional. (CLAUDE.md §1 · INTEGRITY_PROOF_SSOT)
          </div>
        </section>

        <section id="visao-geral" aria-labelledby="h-visao">
          <h2 id="h-visao">Visão geral das 4 camadas</h2>
          <p>Pense numa cadeia: cada camada cuida de uma garantia diferente. Se uma falha, as outras ainda seguram.</p>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Camada</th><th>Garante que…</th><th>Pergunta que responde</th><th>Status</th></tr></thead>
              <tbody>
                <tr><td><strong>L1 — Hash</strong></td><td>o arquivo não foi alterado</td><td>"mexeram nisso?"</td><td><span class="badge real">REAL</span></td></tr>
                <tr><td><strong>L2 — Cadeia de evidência</strong></td><td>toda afirmação tem fonte e nível de certeza</td><td>"de onde veio?"</td><td><span class="badge real">REAL</span></td></tr>
                <tr><td><strong>L3 — Portão PRI</strong></td><td>cada ação é liberada, bloqueada, adiada ou escalada</td><td>"pode fazer isso?"</td><td><span class="badge real">REAL (gate)</span> <span class="badge partial">escalação LLM = mock</span></td></tr>
                <tr><td><strong>L4 — Merkle / assinatura</strong></td><td>nenhum registro antigo foi adulterado</td><td>"o histórico é íntegro?"</td><td><span class="badge real">REAL</span></td></tr>
                <tr><td><strong>+ Guard PII</strong></td><td>dado pessoal não vaza</td><td>"tem CPF aqui?"</td><td><span class="badge real">REAL</span></td></tr>
              </tbody>
            </table>
          </div>
        </section>

        <div class="section-divider"></div>

        <section id="l1" aria-labelledby="h-l1">
          <h2 id="h-l1">L1 — Hash: a impressão digital do arquivo</h2>
          <div class="layer-card">
            <h3><span class="layer-num">L1</span> Hash <span class="badge real">REAL</span></h3>
            <p>Um <strong>hash</strong> é uma função que lê qualquer arquivo e cospe um código fixo de 64 caracteres — como uma impressão digital. A mágica: <strong>mude 1 único byte e o código inteiro muda</strong>. É impossível alterar o conteúdo sem alterar a impressão digital.</p>
            <div class="use-case">
              <b>Caso de uso:</b> você gera um laudo e guarda o hash dele. Semanas depois, alguém te entrega "o mesmo laudo". Você roda o hash de novo: se bater com o guardado, é idêntico ao original. Se mudou <em>uma vírgula</em>, o hash não bate — e você sabe que foi adulterado. Sem precisar reler o documento inteiro.
            </div>
            <p>O EGOS também garante que o hash é <strong>independente da ordem dos campos</strong>: o mesmo dado escrito em ordem diferente dá o mesmo hash — então a prova é sobre o conteúdo, não sobre formatação.</p>
--- JSONs
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
/bin/bash -lc "git diff 80bbb6ee1dc8670162ffab73c340f70c6172a90a -- docs/jobs/2026-06-09-doc-drift-verifier.json docs/_current_handoffs/handoff_2026-06-09b.md | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/docs/_current_handoffs/handoff_2026-06-09b.md b/docs/_current_handoffs/handoff_2026-06-09b.md
index acb75821..40d0cd1d 100644
--- a/docs/_current_handoffs/handoff_2026-06-09b.md
+++ b/docs/_current_handoffs/handoff_2026-06-09b.md
@@ -1,51 +1,84 @@
-# Handoff — 2026-06-09 (sessão PRs + hardening)
+# Handoff — 2026-06-09 (sessão 2ª parte + /end completo)
 
 ## ✅ Accomplished (com SHAs)
-- CI-DEPENDABOT-BUNLOCK-001 [DONE] — `25ba5d1a` — pr-review.yml/ci.yml/capability-eval.yml/security.yml adaptados para dependabot (skip --frozen-lockfile + skip claude-code-action para bots)
-- PRs fechados via gh cli: #92 (zod 3→4 disfarçado de minor) + #83 (archived dead code)
-- Dependabot rebase triggerado em #82, #85, #86, #87, #88
-- RULE-HARDEN-AISECURITY-FAILCLOSED-001 [80%] — `scripts/ai-commit-security.ts:146` crash agora bloqueia (sem SHA ainda — uncommitted → Phase 12)
-- RULE-HARDEN-NOVERIFY-DENY-001 [70%] — `.claude/settings.json` deny rules adicionadas (sem SHA ainda → Phase 12)
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
 
 ## 🔄 In Progress
-- **PR-82-GITLEAKS-SECRET-001** — 0% — CI falha por `GITLEAKS_LICENSE` inacessível a dependabot. Fix: `if: github.actor != 'dependabot[bot]'` no security-scan job.
-- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** — 80% — falta `// scan-ok: mock` pattern validation
-- **RULE-HARDEN-NOVERIFY-DENY-001** — 70% — falta PATH shim ~/bin/git (não crítico)
+
+- **RULE-HARDEN-AISECURITY-FAILCLOSED-001** [P0] — 80% — ai-commit-security.ts corrigido (exit 1), falta `// scan-ok: mock` pattern validation
+- **RULE-HARDEN-NOVERIFY-DENY-001** [P0] — 70% — settings.json done, PATH shim `~/bin/git` pendente
+- **FOCUS-ITEMINTAKE-CLOSE-001** [P0] — outreach feito 2026-06-09, aguarda resposta Diesom (Kyte)
+- **GUARD-BRASIL-AUDIT-001** [P1] — agente rodou, falta consolidar achados
 
 ## ⏳ Blocked
-- **BRANCHPROTECT-PLAN-DECISION-001** [P0 HITL] — GitHub Pro ou repo público necessário. Decisão do Enio.
-- **PR-MAJORS-AUDIT-001** — #85-88 em hold aguardando teste manual em branch isolada
 
-## 🔗 Next Steps (priority order)
-1. **PR-82-GITLEAKS-SECRET-001** [P1] — fix security.yml + merge #82 (gitleaks 2→3 safe bump)
-2. **DISSEMINATE-INTEGRITY-002** [P0] — propagar phantom-done guard para leaves (852/.husky, egos-lab/.husky)
-3. **RULE-HARDEN-CI-GATES-001** [P0] — CI workflow com 4 gates críticos independente de --no-verify
-4. **TASKS-OVERFLOW-001** [P0] — TASKS.md em ~970L, grace até 2026-06-15 → `bun scripts/tasks-archive.ts --exec`
-5. **FOCUS-MIGUEL-DIAG-001** [P0] — enviar HTML piloto para Miguel (arquivo pronto: docs/presentations/mf-certificados-piloto.html)
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
 
 ## 🌐 Environment State
-- Build: ✅ (typecheck passa, bundle-runtime ativo)
-- Tests: ✅ (pii-gate.test.ts 7/7 pass)
-- Deploy: VPS healthy (gateway/guard-brasil/hq/852 todos 200, Supabase sb_ keys ativas)
-- PRs abertos: 7 (#82 aguardando CI, #85-88 on hold, #89/#91 outra sessão)
-- AHEAD of origin/main: 1 commit (5768db24)
+
+- Build: ✅ typecheck OK (sessão anterior)
+- Tests: ⚠️ 88/93 MCP golden, 9/80 CBCs com golden real
+- Deploy: VPS hq.egos.ia.br HTTP 200 ✅
+- Watcher: ✅ heartbeat fail-safe corrigido `25ba5d1a`
+- Supabase: ✅ nova key ativa, legacy desabilitada
+- TASKS.md: 🔴 ~900L (limit 600) — ARCHIVE IMEDIATO NECESSÁRIO
 
 ## 📌 Decisions Made
-- PR #92 fechado: zod 3→4 em 15 package.json sem breaking test coverage = risco, não merge automático
-- PR #83 fechado: apps/_archived é código morto, deps sem valor
-- Dependabot PRs: usar `@dependabot rebase` para re-trigger CI após fix de workflow
-- GITLEAKS em dependabot PRs: secret bloqueado por design do GitHub → solução = skip job para dependabot
-
-## 📌 PRs status resumo
-| PR | Título | Estado |
-|----|--------|--------|
-| #82 | gitleaks 2→3 | CI falha (secret issue) — fix pendente |
-| #85 | simplewebauthn 11→13 | Hold — security-critical, testar |
-| #86 | lucide 0.577→1.17 | Hold — UI, provavelmente safe |
-| #87 | jose 5→6 | Hold — JWT breaking change |
-| #88 | @types/node 20→25 | Hold — types only, provavelmente safe |
-| #89 | financial-intel | Outra sessão — Red Zone |
-| #91 | curriculum-gate | Outra sessão — HITL |
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
 
 ## 🚫 Marked [CONCEPT]
-- PATH shim ~/bin/git para interceptar --no-verify em qualquer posição (deferido — CI é a camada real)
+
+- VALIDATE-PROVENANCE-001 — não executado (exige Enio rodar+gravar)
+- MCP-PESSOAL-ENIO-001 endpoint — só curadoria/design feita
+- WA-AGENT-ASYNC-ARCH-001 — design pendente corte Enio
+
+---
+*v6.5 | 2026-06-09 | SHA HEAD: 5768db24*
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

exec
/bin/bash -lc "git rev-parse HEAD && git log --oneline -5 --decorate && nl -ba docs/_current_handoffs/handoff_2026-06-09b.md | tail -20 && nl -ba docs/tutor/PROVENANCE_4_CAMADAS.html | sed -n '180,430p'" in /home/enio/egos
 succeeded in 0ms:
1d6a024c46c328bd32ea111799d05ae0b6e77e76
1d6a024c (HEAD -> main, origin/main) chore(tasks): eleicao P0 sistema-inteiro + alvo Fable 5 (corte Enio 2026-06-09)
2735131d chore(logs): job logs auto-gerados (estado limpo pré-eleição P0)
66b36bc9 chore(end): /end completo 2026-06-09 — handoff + PROVENANCE_4_CAMADAS HTML
80bbb6ee chore(end): watcher root-cause fix + HTML provenance + auditoria disseminacao integridade
86de702d chore(end): session close 2026-06-09b — PRs triados + CI hardening parcial
    65	- [x] Identidade arquiteto-diagnosticador em TASKS.md
    66	- [x] Cursos reclassificados → memory
    67	- [x] INTEGRITY_PROOF_SSOT.md + 8 tasks RULE-HARDEN — `eff0b679`
    68	- [x] audit-phantom-done.ts EGOS_ROOT fix — `d44f9c57`
    69	- [x] Watcher heartbeat fail-safe — `25ba5d1a`
    70	- [x] MCP Pessoal curadoria 90→16 — `2def6c69`
    71	- [/] RULE-HARDEN-NOVERIFY-DENY-001 (70% — settings.json ok, PATH shim pendente)
    72	- [/] RULE-HARDEN-AISECURITY-FAILCLOSED-001 (80% — exit 1 ok, scan-ok pattern pendente)
    73	- [ ] NOTEBOOKLM-MIGUEL-SHARE-001 (Enio)
    74	- [ ] WA-AGENT-CONNECT-001 (número limpo)
    75	- [ ] TASKS-ARCHIVE-NOW-001 (urgente)
    76	
    77	## 🚫 Marked [CONCEPT]
    78	
    79	- VALIDATE-PROVENANCE-001 — não executado (exige Enio rodar+gravar)
    80	- MCP-PESSOAL-ENIO-001 endpoint — só curadoria/design feita
    81	- WA-AGENT-ASYNC-ARCH-001 — design pendente corte Enio
    82	
    83	---
    84	*v6.5 | 2026-06-09 | SHA HEAD: 5768db24*
   180	          <p>Imagine um laudo, um relatório de investigação, ou uma conclusão gerada por IA. Três perguntas sempre ficam no ar:</p>
   181	          <ul>
   182	            <li><strong>Esse arquivo foi mexido depois de pronto?</strong> (integridade)</li>
   183	            <li><strong>De onde veio cada afirmação — é fato, dedução ou chute?</strong> (origem)</li>
   184	            <li><strong>Posso confiar que ninguém apagou ou trocou um registro antigo?</strong> (histórico)</li>
   185	          </ul>
   186	          <p>A maioria dos sistemas responde "confie em mim". O EGOS responde com <strong>prova matemática verificável</strong>. Cada camada abaixo ataca uma dessas perguntas. Juntas, transformam "eu afirmo" em "eu provo, e qualquer um pode checar".</p>
   187	          <div class="callout amber">
   188	            <div class="callout-label">A regra-mãe por trás disso</div>
   189	            "Afirmação sem prova é afirmação inválida." Provar é o último passo obrigatório de toda tarefa — não um opcional. (CLAUDE.md §1 · INTEGRITY_PROOF_SSOT)
   190	          </div>
   191	        </section>
   192	
   193	        <section id="visao-geral" aria-labelledby="h-visao">
   194	          <h2 id="h-visao">Visão geral das 4 camadas</h2>
   195	          <p>Pense numa cadeia: cada camada cuida de uma garantia diferente. Se uma falha, as outras ainda seguram.</p>
   196	          <div class="table-wrap">
   197	            <table>
   198	              <thead><tr><th>Camada</th><th>Garante que…</th><th>Pergunta que responde</th><th>Status</th></tr></thead>
   199	              <tbody>
   200	                <tr><td><strong>L1 — Hash</strong></td><td>o arquivo não foi alterado</td><td>"mexeram nisso?"</td><td><span class="badge real">REAL</span></td></tr>
   201	                <tr><td><strong>L2 — Cadeia de evidência</strong></td><td>toda afirmação tem fonte e nível de certeza</td><td>"de onde veio?"</td><td><span class="badge real">REAL</span></td></tr>
   202	                <tr><td><strong>L3 — Portão PRI</strong></td><td>cada ação é liberada, bloqueada, adiada ou escalada</td><td>"pode fazer isso?"</td><td><span class="badge real">REAL (gate)</span> <span class="badge partial">escalação LLM = mock</span></td></tr>
   203	                <tr><td><strong>L4 — Merkle / assinatura</strong></td><td>nenhum registro antigo foi adulterado</td><td>"o histórico é íntegro?"</td><td><span class="badge real">REAL</span></td></tr>
   204	                <tr><td><strong>+ Guard PII</strong></td><td>dado pessoal não vaza</td><td>"tem CPF aqui?"</td><td><span class="badge real">REAL</span></td></tr>
   205	              </tbody>
   206	            </table>
   207	          </div>
   208	        </section>
   209	
   210	        <div class="section-divider"></div>
   211	
   212	        <section id="l1" aria-labelledby="h-l1">
   213	          <h2 id="h-l1">L1 — Hash: a impressão digital do arquivo</h2>
   214	          <div class="layer-card">
   215	            <h3><span class="layer-num">L1</span> Hash <span class="badge real">REAL</span></h3>
   216	            <p>Um <strong>hash</strong> é uma função que lê qualquer arquivo e cospe um código fixo de 64 caracteres — como uma impressão digital. A mágica: <strong>mude 1 único byte e o código inteiro muda</strong>. É impossível alterar o conteúdo sem alterar a impressão digital.</p>
   217	            <div class="use-case">
   218	              <b>Caso de uso:</b> você gera um laudo e guarda o hash dele. Semanas depois, alguém te entrega "o mesmo laudo". Você roda o hash de novo: se bater com o guardado, é idêntico ao original. Se mudou <em>uma vírgula</em>, o hash não bate — e você sabe que foi adulterado. Sem precisar reler o documento inteiro.
   219	            </div>
   220	            <p>O EGOS também garante que o hash é <strong>independente da ordem dos campos</strong>: o mesmo dado escrito em ordem diferente dá o mesmo hash — então a prova é sobre o conteúdo, não sobre formatação.</p>
   221	            <div class="kv">Arquivo: <code>packages/shared/src/provenance.ts</code></div>
   222	            <pre><code>Prova real (smoke colado):
   223	Hash do dado original : f960c1da … 99b5
   224	Mesmo dado, 1 byte mudado : adbb6d7a … f7ce
   225	→ um byte de diferença = hash completamente diferente ✅</code></pre>
   226	          </div>
   227	        </section>
   228	
   229	        <section id="l2" aria-labelledby="h-l2">
   230	          <h2 id="h-l2">L2 — Cadeia de evidência: toda afirmação carrega sua fonte</h2>
   231	          <div class="layer-card">
   232	            <h3><span class="layer-num">L2</span> Evidence chain <span class="badge real">REAL</span></h3>
   233	            <p>Aqui cada afirmação vem grudada com (a) <strong>de onde ela veio</strong> e (b) <strong>o nível de certeza</strong>. O EGOS usa três rótulos:</p>
   234	            <ul>
   235	              <li><strong>CONFIRMADO</strong> — provado por uma fonte direta (um extrato, um arquivo, um teste).</li>
   236	              <li><strong>INFERIDO</strong> — deduzido a partir de fatos, mas não visto diretamente.</li>
   237	              <li><strong>HIPÓTESE</strong> — possibilidade ainda não provada.</li>
   238	            </ul>
   239	            <div class="use-case">
   240	              <b>Caso de uso:</b> num relatório, a frase "o investigado movimentou R$ 50 mil" não anda sozinha — ela vem com <code>fonte: extrato bancário, linha 412 · CONFIRMADO</code>. Já "o dinheiro veio de fonte ilícita" aparece como <code>HIPÓTESE</code>. Quem lê sabe na hora o que é pedra e o que é areia — e ninguém repete sua conclusão como fato sem ver a base.
   241	            </div>
   242	            <p>A cadeia inteira ganha um <strong>hash de auditoria</strong>, então o conjunto de evidências também fica selado contra alteração.</p>
   243	            <div class="kv">Arquivo: <code>packages/shared/src/evidence-chain.ts</code> · prova: <code>auditHash = ev-698b7574</code></div>
   244	          </div>
   245	        </section>
   246	
   247	        <section id="l3" aria-labelledby="h-l3">
   248	          <h2 id="h-l3">L3 — Portão PRI: decide o que pode passar</h2>
   249	          <div class="layer-card">
   250	            <h3><span class="layer-num">L3</span> Portão PRI <span class="badge real">REAL (gate)</span> <span class="badge partial">escalação = mock</span></h3>
   251	            <p>PRI é um <strong>portão de decisão</strong>. Antes de uma ação acontecer, ele dá um de quatro veredictos:</p>
   252	            <div class="table-wrap">
   253	              <table>
   254	                <thead><tr><th>Veredicto</th><th>Significado</th><th>Exemplo</th></tr></thead>
   255	                <tbody>
   256	                  <tr><td><strong>ALLOW</strong></td><td>libera</td><td>ação rotineira, sem risco</td></tr>
   257	                  <tr><td><strong>BLOCK</strong></td><td>bloqueia</td><td>viola uma regra dura</td></tr>
   258	                  <tr><td><strong>DEFER</strong></td><td>adia / manda pro humano</td><td>toca dado sensível → espera decisão</td></tr>
   259	                  <tr><td><strong>ESCALATE</strong></td><td>sobe pra análise mais profunda</td><td>caso ambíguo que precisa de julgamento</td></tr>
   260	                </tbody>
   261	              </table>
   262	            </div>
   263	            <div class="use-case">
   264	              <b>Caso de uso:</b> uma IA está prestes a publicar um texto que menciona um CPF. O portão PRI intercepta: como toca dado pessoal, o veredicto é <strong>DEFER</strong> — não bloqueia para sempre, mas <em>segura e pede o "ok" de um humano</em>. É o "pare e pense" automático antes de algo irreversível.
   265	            </div>
   266	            <div class="callout amber">
   267	              <div class="callout-label">A ressalva honesta (e por que ela importa)</div>
   268	              O portão funciona <strong>de ponta a ponta</strong> nos 4 veredictos (testado: <code>4/4 pass</code>). Mas quando o caso precisa <em>escalar para um LLM julgar</em>, essa parte hoje usa um <strong>mock determinístico</strong> — um substituto previsível, não a IA real ainda conectada. É <strong>injeção de dependência</strong> (a peça é trocável por Gemini com uma linha), <strong>não um stub que finge funcionar</strong>. Dizer isto é mais forte que fingir 5/5 perfeito.
   269	            </div>
   270	            <div class="kv">Arquivo: <code>packages/core/src/guards/pri.ts</code> · prova: <code>bun test pri.test.ts → 4 pass / 0 fail</code> · wiring real do LLM = task <code>PRI-L3-LLM-WIRE-001</code></div>
   271	          </div>
   272	        </section>
   273	
   274	        <section id="l4" aria-labelledby="h-l4">
   275	          <h2 id="h-l4">L4 — Merkle / assinatura: o selo do histórico inteiro</h2>
   276	          <div class="layer-card">
   277	            <h3><span class="layer-num">L4</span> Merkle + assinatura Ed25519 <span class="badge real">REAL</span></h3>
   278	            <p>Se L1 é a impressão digital de <em>um</em> arquivo, L4 é o selo da <strong>pilha inteira de registros</strong>. Os hashes são encadeados numa árvore (estrutura <strong>Merkle</strong>) e o todo é <strong>assinado</strong> com uma chave criptográfica (Ed25519). Resultado: mexer em <em>qualquer</em> registro velho quebra o selo de tudo.</p>
   279	            <div class="use-case">
   280	              <b>Caso de uso:</b> um log de decisões de 3 dias atrás. Alguém tenta editar uma linha retroativamente para "consertar a história". A assinatura Merkle denuncia na hora: a verificação volta <code>false</code>. Você prova que o histórico é íntegro — ou prova exatamente que foi adulterado.
   281	            </div>
   282	            <div class="kv">Arquivo: <code>packages/shared/src/agent-signature.ts</code></div>
   283	            <pre><code>Prova real (smoke colado):
   284	Cadeia INTACTA          : true
   285	Adulterada (hash)       : false
   286	Adulterada (tipo de ação): false
   287	→ qualquer alteração retroativa é detectada ✅</code></pre>
   288	            <p class="kv">Nota técnica: assinar/verificar funciona 100% offline. Só persistir o registro num banco (ledger) precisa de Supabase — a <em>prova</em> em si não depende de nada externo.</p>
   289	          </div>
   290	        </section>
   291	
   292	        <section id="pii" aria-labelledby="h-pii">
   293	          <h2 id="h-pii">+ Guard PII: o dado pessoal não vaza</h2>
   294	          <div class="layer-card">
   295	            <h3><span class="layer-num" style="background:var(--egos-green)">PII</span> Guard Brasil <span class="badge real">REAL</span></h3>
   296	            <p>Antes de qualquer conteúdo sair (publicar, exportar, mandar pra uma IA externa), o Guard varre por dado pessoal brasileiro — CPF, e-mail, placa, número de registro — e <strong>mascara</strong>.</p>
   297	            <div class="use-case">
   298	              <b>Caso de uso:</b> um texto contém <!-- scan-ok: cpf-ficticio-didatico --> <code>[CPF-EXEMPLO-FICTÍCIO]</code> (substituído por segurança — o Guard detectaria e mascararia assim). O Guard transforma em <code>[CPF REMOVIDO]</code> antes de qualquer saída, marca a sensibilidade como <code>critical</code> e conta quantos achados mascarou. O dado soberano nunca cruza a fronteira sem passar por aqui.
   299	            </div>
   300	            <div class="kv">Arquivos: <code>packages/shared/src/pii-scanner.ts</code> + <code>public-guard.ts</code> · prova: CPF/email/placa/REDS → todos <code>[REMOVIDO]</code>, <code>findings: 4</code></div>
   301	          </div>
   302	        </section>
   303	
   304	        <div class="section-divider"></div>
   305	
   306	        <section id="caso-completo" aria-labelledby="h-caso">
   307	          <h2 id="h-caso">Um caso, ponta-a-ponta</h2>
   308	          <p>Veja as camadas trabalhando juntas num único fluxo — um relatório gerado por IA:</p>
   309	          <ol>
   310	            <li><strong>L2</strong> grava cada afirmação com sua fonte e rótulo (CONFIRMADO/INFERIDO/HIPÓTESE).</li>
   311	            <li><strong>Guard PII</strong> varre o texto e mascara qualquer CPF/dado pessoal.</li>
   312	            <li><strong>L3 (PRI)</strong> decide: o relatório toca dado sensível? → <strong>DEFER</strong> pro humano aprovar.</li>
   313	            <li><strong>L1</strong> gera o hash do relatório final aprovado — a impressão digital congelada.</li>
   314	            <li><strong>L4</strong> assina e encadeia esse hash no histórico — selo contra adulteração futura.</li>
   315	          </ol>
   316	          <div class="callout green">
   317	            <div class="callout-label">O resultado</div>
   318	            Qualquer pessoa, depois, pode verificar: <em>este</em> é o relatório original (L1), <em>estas</em> são as fontes de cada frase (L2), foi <em>aprovado</em> por um humano (L3), o histórico <em>não foi mexido</em> (L4), e <em>nenhum dado pessoal vazou</em> (PII). Isso é proveniência: confiança que se checa, não que se pede.
   319	          </div>
   320	        </section>
   321	
   322	        <section id="honestidade" aria-labelledby="h-honestidade">
   323	          <h2 id="h-honestidade">Por que 4,5 e não 5</h2>
   324	          <p>A validação técnica deu <strong>4,5 de 5 genuinamente REAL</strong>. As camadas L1, L2, L4 e o Guard PII são reais e testadas. O portão L3 é real como gate — o que é "meio ponto" é só a <em>escalação para o LLM</em>, que hoje usa um substituto trocável.</p>
   325	          <div class="callout">
   326	            <div class="callout-label">A tese central do EGOS</div>
   327	            Dizer "4,5/5, com a meia-camada marcada com transparência" é <strong>mais forte</strong> que fingir "5/5 perfeito". A validação honesta — incluindo o que ainda é trabalho-em-progresso — <em>é</em> a prova. Quem esconde o que falta não tem provenance; tem marketing.
   328	          </div>
   329	        </section>
   330	
   331	        <section id="glossario" aria-labelledby="h-glossario">
   332	          <h2 id="h-glossario">Glossário rápido</h2>
   333	          <div class="table-wrap">
   334	            <table>
   335	              <thead><tr><th>Termo</th><th>O que é</th></tr></thead>
   336	              <tbody>
   337	                <tr><td><strong>Provenance</strong></td><td>Proveniência — a trilha de onde algo veio, se mudou, e por que confiar.</td></tr>
   338	                <tr><td><strong>Hash</strong></td><td>Código fixo gerado de um arquivo; muda inteiro se 1 byte muda. A "impressão digital".</td></tr>
   339	                <tr><td><strong>Merkle</strong></td><td>Árvore que encadeia hashes; permite detectar alteração em qualquer ponto do histórico.</td></tr>
   340	                <tr><td><strong>Ed25519</strong></td><td>Tipo de assinatura criptográfica — rápida e segura.</td></tr>
   341	                <tr><td><strong>Gate / Portão</strong></td><td>Ponto de controle que decide se uma ação passa ou para.</td></tr>
   342	                <tr><td><strong>Mock</strong></td><td>Substituto previsível de uma peça real, usado enquanto a real não está conectada.</td></tr>
   343	                <tr><td><strong>Injeção de dependência</strong></td><td>Padrão onde uma peça (ex: o LLM) é "plugável" — trocável sem reescrever o resto.</td></tr>
   344	                <tr><td><strong>PII</strong></td><td>Dado pessoal identificável (CPF, e-mail, telefone…).</td></tr>
   345	                <tr><td><strong>DEFER</strong></td><td>Veredicto do portão: "segura e manda pro humano decidir".</td></tr>
   346	              </tbody>
   347	            </table>
   348	          </div>
   349	        </section>
   350	
   351	      </div>
   352	    </main>
   353	  </div>
   354	
   355	  <footer class="egos-footer" id="rodape" role="contentinfo">
   356	    <div>
   357	      <span class="footer-brand">⬡ EGOS — Governance is Infrastructure</span>
   358	      <span class="footer-tagline">Documento tutor — camada humana (R-DOC-AUDIENCE-001)</span>
   359	    </div>
   360	    <div class="footer-provenance">
   361	      <span>Fonte: <code>docs/jobs/2026-06-09-provenance-validation.md</code></span><br>
   362	      <span>SSOT técnico: <code>docs/governance/INTEGRITY_PROOF_SSOT.md</code></span><br>
   363	      <span>Gerado em: 2026-06-09 · v1.0.0</span><br>
   364	      <span>Regenerável a partir do .md fonte</span>
   365	    </div>
   366	  </footer>
   367	
   368	  <script>
   369	    (function () {
   370	      'use strict';
   371	      var THEME_KEY = 'egos-html-theme';
   372	      var body = document.body;
   373	      function applyTheme(t) {
   374	        if (t === 'dark') body.classList.add('dark'); else body.classList.remove('dark');
   375	        var btn = document.getElementById('btn-theme');
   376	        if (btn) btn.textContent = (t === 'dark') ? '☀' : '☾';
   377	      }
   378	      function getStoredTheme() { try { return localStorage.getItem(THEME_KEY); } catch(e) { return null; } }
   379	      function storeTheme(t) { try { localStorage.setItem(THEME_KEY, t); } catch(e) {} }
   380	      var stored = getStoredTheme();
   381	      if (stored) applyTheme(stored);
   382	      else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) applyTheme('dark');
   383	      document.getElementById('btn-theme').addEventListener('click', function () {
   384	        var next = body.classList.contains('dark') ? 'light' : 'dark';
   385	        applyTheme(next); storeTheme(next);
   386	      });
   387	      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
   388	        if (!getStoredTheme()) applyTheme(e.matches ? 'dark' : 'light');
   389	      });
   390	      var sidebar = document.getElementById('sidebar');
   391	      var overlay = document.getElementById('sidebar-overlay');
   392	      var btnMenu = document.getElementById('btn-menu');
   393	      function openSidebar() { sidebar.classList.add('open'); overlay.classList.add('active');
   394	        overlay.setAttribute('aria-hidden','false'); btnMenu.setAttribute('aria-expanded','true'); }
   395	      function closeSidebar() { sidebar.classList.remove('open'); overlay.classList.remove('active');
   396	        overlay.setAttribute('aria-hidden','true'); btnMenu.setAttribute('aria-expanded','false'); }
   397	      if (btnMenu) btnMenu.addEventListener('click', function () {
   398	        sidebar.classList.contains('open') ? closeSidebar() : openSidebar(); });
   399	      if (overlay) overlay.addEventListener('click', closeSidebar);
   400	      sidebar.querySelectorAll('.sidebar-link').forEach(function (link) {
   401	        link.addEventListener('click', function () { if (window.innerWidth <= 768) closeSidebar(); });
   402	      });
   403	      var sections = document.querySelectorAll('main section[id]');
   404	      var links = document.querySelectorAll('.sidebar-link');
   405	      function onScroll() {
   406	        var scrollY = window.scrollY;
   407	        var headerH = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--header-h')) || 52;
   408	        var current = '';
   409	        sections.forEach(function (sec) { if (sec.offsetTop - headerH - 24 <= scrollY) current = sec.id; });
   410	        links.forEach(function (link) {
   411	          link.setAttribute('aria-current', link.getAttribute('href') === '#' + current ? 'page' : 'false');
   412	        });
   413	      }
   414	      window.addEventListener('scroll', onScroll, { passive: true });
   415	      onScroll();
   416	    })();
   417	  </script>
   418	</body>
   419	</html>

exec
/bin/bash -lc 'test -f docs/jobs/2026-06-09-provenance-validation.md; echo $?; ls docs/jobs | grep provenance || true; git ls-files docs/jobs/2026-06-09-provenance-validation.md docs/governance/INTEGRITY_PROOF_SSOT.md packages/shared/src/evidence-chain.ts packages/shared/src/agent-signature.ts packages/shared/src/provenance.ts packages/shared/src/pii-scanner.ts packages/shared/src/public-guard.ts packages/core/src/guards/pri.ts' in /home/enio/egos
 succeeded in 0ms:
0
2026-06-09-provenance-validation.md
docs/governance/INTEGRITY_PROOF_SSOT.md
docs/jobs/2026-06-09-provenance-validation.md
packages/core/src/guards/pri.ts
packages/shared/src/agent-signature.ts
packages/shared/src/evidence-chain.ts
packages/shared/src/pii-scanner.ts
packages/shared/src/provenance.ts
packages/shared/src/public-guard.ts

exec
/bin/bash -lc "sed -n '1,220p' packages/shared/src/provenance.ts && sed -n '1,220p' packages/shared/src/evidence-chain.ts && sed -n '1,220p' packages/core/src/guards/pri.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Provenance — non-repudiation metadata for ETL pipelines.
 * Ported from br-acc/etl/src/bracc_etl/provenance.py (BRACC-001).
 *
 * Provides SHA-256 based proof-of-research hashes for data rows
 * and deterministic source fingerprints.
 */

import { createHash } from "crypto";

type JsonPrimitive = string | number | boolean | null;
type JsonValue = JsonPrimitive | JsonObject | JsonArray;
type JsonObject = { [key: string]: JsonValue };
type JsonArray = JsonValue[];

/** Normalize a value into a deterministic JSON-serializable structure. */
function normalize(value: unknown): JsonValue {
  if (value === null || value === undefined) return null;
  if (value instanceof Date) {
    return value.toISOString().replace("+00:00", "Z");
  }
  if (Array.isArray(value)) {
    return value.map(normalize);
  }
  if (typeof value === "object") {
    const obj = value as Record<string, unknown>;
    return Object.fromEntries(
      Object.entries(obj)
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([k, v]) => [k, normalize(v)])
    );
  }
  return value as JsonPrimitive;
}

/** Return stable JSON representation for hashing raw rows. */
export function canonicalRowJson(row: Record<string, unknown>): string {
  return JSON.stringify(normalize(row), null, 0);
}

/** Return hex SHA-256 for a text value. */
export function sha256Text(value: string): string {
  return createHash("sha256").update(value, "utf8").digest("hex");
}

/** Compute a non-repudiation hash for a raw row payload. */
export function rawRowHash(row: Record<string, unknown>): string {
  return sha256Text(canonicalRowJson(row));
}

/** Compute deterministic fingerprint for a data source snapshot. */
export function sourceFingerprint(sourceUrl: string, method: string, collectedAt: string): string {
  const payload = `${sourceUrl.trim()}|${method.trim()}|${collectedAt.trim()}`;
  return sha256Text(payload);
}

export interface AuditFields {
  raw_line_hash: string;
  source_url: string;
  source_method: string;
  verified_at: string;
  audit_status: "verified";
  source_fingerprint: string;
}

/**
 * Build audit metadata to attach to transformed nodes/relationships.
 * Drop-in compatible with the Python version's output shape.
 */
export function buildAuditFields(params: {
  rawRow: Record<string, unknown>;
  sourceUrl: string;
  method: string;
  collectedAt?: string;
}): AuditFields {
  const verifiedAt =
    params.collectedAt ?? new Date().toISOString().replace(/\.\d{3}Z$/, "Z");
  return {
    raw_line_hash: rawRowHash(params.rawRow),
    source_url: params.sourceUrl.trim(),
    source_method: params.method.trim() || "unknown",
    verified_at: verifiedAt,
    audit_status: "verified",
    source_fingerprint: sourceFingerprint(params.sourceUrl, params.method, verifiedAt),
  };
}
/**
 * Evidence Chain — Traceable response discipline for AI systems
 *
 * Attaches structured provenance to AI-generated responses,
 * ensuring every claim can be traced back to a source, tool call,
 * or human-verified fact. Core component of EGOS Guard Brasil.
 */

export type EvidenceType = 'tool_call' | 'document' | 'calculation' | 'human_verified' | 'inference' | 'external_api';
export type ConfidenceLevel = 'certain' | 'high' | 'medium' | 'low' | 'speculative';

export interface EvidenceItem {
  id: string;
  type: EvidenceType;
  source: string;
  content: string;
  confidence: ConfidenceLevel;
  timestamp: string;
  metadata?: Record<string, unknown>;
}

export interface EvidenceChain {
  responseId: string;
  sessionId?: string;
  createdAt: string;
  claims: ClaimWithEvidence[];
  overallConfidence: ConfidenceLevel;
  auditHash: string;
}

export interface ClaimWithEvidence {
  claim: string;
  evidence: EvidenceItem[];
  confidence: ConfidenceLevel;
  verifiable: boolean;
}

export interface EvidenceChainOptions {
  sessionId?: string;
  requireEvidence?: boolean;
  minConfidence?: ConfidenceLevel;
}

const CONFIDENCE_RANK: Record<ConfidenceLevel, number> = {
  certain: 5,
  high: 4,
  medium: 3,
  low: 2,
  speculative: 1,
};

function lowestConfidence(levels: ConfidenceLevel[]): ConfidenceLevel {
  if (levels.length === 0) return 'speculative';
  return levels.reduce((min, cur) =>
    CONFIDENCE_RANK[cur] < CONFIDENCE_RANK[min] ? cur : min
  );
}

function computeAuditHash(chain: Omit<EvidenceChain, 'auditHash'>): string {
  const payload = JSON.stringify({
    responseId: chain.responseId,
    createdAt: chain.createdAt,
    claims: chain.claims.map(c => ({ claim: c.claim, confidence: c.confidence })),
  });
  // Deterministic simple hash (not cryptographic — for audit trail only)
  let hash = 0;
  for (let i = 0; i < payload.length; i++) {
    hash = (hash << 5) - hash + payload.charCodeAt(i);
    hash |= 0;
  }
  return `ev-${Math.abs(hash).toString(16).padStart(8, '0')}`;
}

let _responseCounter = 0;

/**
 * Creates a new evidence chain for an AI response.
 */
export function createEvidenceChain(options: EvidenceChainOptions = {}): EvidenceChainBuilder {
  return new EvidenceChainBuilder(options);
}

export class EvidenceChainBuilder {
  private claims: ClaimWithEvidence[] = [];
  private sessionId?: string;
  private responseId: string;
  private createdAt: string;

  constructor(options: EvidenceChainOptions) {
    this.sessionId = options.sessionId;
    this.responseId = `resp-${Date.now()}-${++_responseCounter}`;
    this.createdAt = new Date().toISOString();
  }

  /**
   * Adds a claim backed by evidence items.
   */
  addClaim(claim: string, evidence: EvidenceItem[], confidence?: ConfidenceLevel): this {
    const derivedConfidence = confidence ?? lowestConfidence(evidence.map(e => e.confidence));
    this.claims.push({
      claim,
      evidence,
      confidence: derivedConfidence,
      verifiable: evidence.some(e => e.type !== 'inference'),
    });
    return this;
  }

  /**
   * Convenience: add a tool-call backed claim.
   */
  addToolCallClaim(claim: string, toolName: string, result: string, confidence: ConfidenceLevel = 'high'): this {
    const ev: EvidenceItem = {
      id: `ev-${Date.now()}`,
      type: 'tool_call',
      source: toolName,
      content: result,
      confidence,
      timestamp: new Date().toISOString(),
    };
    return this.addClaim(claim, [ev], confidence);
  }

  /**
   * Convenience: add a document-backed claim.
   */
  addDocumentClaim(claim: string, docRef: string, excerpt: string, confidence: ConfidenceLevel = 'high'): this {
    const ev: EvidenceItem = {
      id: `ev-${Date.now()}`,
      type: 'document',
      source: docRef,
      content: excerpt,
      confidence,
      timestamp: new Date().toISOString(),
    };
    return this.addClaim(claim, [ev], confidence);
  }

  /**
   * Builds and seals the evidence chain.
   */
  build(): EvidenceChain {
    const overallConfidence = lowestConfidence(this.claims.map(c => c.confidence));
    const partial = {
      responseId: this.responseId,
      sessionId: this.sessionId,
      createdAt: this.createdAt,
      claims: this.claims,
      overallConfidence,
    };
    return { ...partial, auditHash: computeAuditHash(partial) };
  }
}

/**
 * Formats an evidence chain into a human-readable citation block.
 */
export function formatEvidenceBlock(chain: EvidenceChain): string {
  const lines = [`[Evidências — ${chain.responseId}]`];
  for (const { claim, evidence, confidence } of chain.claims) {
    lines.push(`• ${claim} (confiança: ${confidence})`);
    for (const ev of evidence) {
      lines.push(`  ↳ [${ev.type}] ${ev.source}: "${ev.content.slice(0, 120)}..."`);
    }
  }
  lines.push(`Audit hash: ${chain.auditHash}`);
  return lines.join('\n');
}

/**
 * Validates that a chain meets minimum confidence requirements.
 */
export function validateChain(chain: EvidenceChain, minConfidence: ConfidenceLevel = 'low'): boolean {
  return CONFIDENCE_RANK[chain.overallConfidence] >= CONFIDENCE_RANK[minConfidence];
}
/**
 * PRI — Protocolo de Recuo por Ignorância (Protocol of Retreat by Ignorance)
 * Safety gate for Guard Brasil API
 *
 * Core: "Ignorância não é permissão. Ignorância é gatilho de pausa."
 * When confidence is low, escalate. Never default to ALLOW on uncertainty.
 */

import { createHash } from 'crypto';

// ── Types ──────────────────────────────────────────────────────

export type PRIOutput = 'ALLOW' | 'BLOCK' | 'DEFER' | 'ESCALATE' | 'STUDY';

export type PRIStrategy = 'paranoid' | 'balanced' | 'permissive';

/**
 * L3 LLM evaluator (injeção de dependência — GUARD-STD-004, corte Enio 2026-06-03).
 * Mantém @egos/core SEM dependência de shared/llm-router. O avaliador real
 * (callHermes) vive em @egos/shared e é INJETADO; default = mock determinístico.
 * Chamado SÓ como escalação (quando L1/L2 ficam inconclusivos). Fail-closed: erro → BLOCK.
 */
export type PRILlmEvaluator = (
  text: string,
  pii_types: string[],
) => Promise<{ output: string; confidence: number; reasoning: string }>;

export interface PRIDecision {
  output: PRIOutput;
  confidence: number; // 0-100
  reasoning: string;
  missing_signals: string[];
  classifiers_consulted: string[];
  timestamp: string;
  audit_hash: string;
}

export interface PRIRequest {
  text: string;
  pii_types?: string[];
  atrian_validation?: boolean;
  strategy?: PRIStrategy;
  context?: {
    impacts_fundamental_rights?: boolean;
    is_admin_action?: boolean;
    user_id?: string;
  };
}

export interface PRIAuditEvent {
  event_id: string;
  timestamp: string;
  request_hash: string;
  decision: PRIDecision;
  classifiers: {
    name: string;
    result: string;
    confidence: number;
    latency_ms: number;
  }[];
  user_id?: string;
  cost_usd: number;
  signature?: string;
}

// ── Configuration by Strategy ──────────────────────────────────

const THRESHOLDS: Record<PRIStrategy, Record<PRIOutput, number>> = {
  paranoid: {
    ALLOW: 95,
    BLOCK: 90,
    DEFER: 60,
    ESCALATE: 40,
    STUDY: 0,
  },
  balanced: {
    ALLOW: 90,
    BLOCK: 85,
    DEFER: 60,
    ESCALATE: 40,
    STUDY: 0,
  },
  permissive: {
    ALLOW: 80,
    BLOCK: 70,
    DEFER: 50,
    ESCALATE: 30,
    STUDY: 0,
  },
};

// ── Layer 1: Fast Path (Regex + Pattern Matching) ──────────────

const PII_PATTERNS: Record<string, RegExp> = {
  cpf: /\d{3}\.\d{3}\.\d{3}-\d{2}/,
  rg: /\d{1,2}\.?\d{3}\.?\d{3}[-/]?\d{1,2}/,
  masp: /\d{7}[-/]\d{1}/,
  placa: /[A-Z]{3}-?\d{4}|[A-Z]{3}\d{1}[A-Z]{1}\d{2}/,
  email: /\S+@\S+\.\S+/,
  phone: /\(?\d{2}\)?[\s-]?\d{4,5}[-\s]?\d{4}/,
  processo: /\d{7}-?\d{2}\.?\d{4}\.?\d{1}\.?\d{2}/,
  pix_key: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/,
};

function layerOne(text: string, pii_types: string[]): { output: PRIOutput; confidence: number; reasoning: string; classifiers: string[] } {
  const classifiers: string[] = [];

  for (const pii_type of pii_types) {
    const pattern = PII_PATTERNS[pii_type];
    if (!pattern) {
      classifiers.push(`unknown_pattern:${pii_type}`);
      continue;
    }
    if (pattern.test(text)) {
      classifiers.push(`regex:${pii_type}:match`);
      return {
        output: 'ALLOW',
        confidence: 95,
        reasoning: `Explicit ${pii_type} pattern matched`,
        classifiers,
      };
    }
    classifiers.push(`regex:${pii_type}:nomatch`);
  }

  // No regex match → continue to layer 2
  return {
    output: 'DEFER', // will be updated by layer 2
    confidence: 0,
    reasoning: 'No regex match found for requested PII types',
    classifiers,
  };
}

// ── Layer 2: Semantic Check (Heuristics + Context) ──────────────

const BIAS_SIGNALS = [
  'favela',
  'periférico',
  'comunidade',
  'criminalidade',
  'risco social',
  'raça',
  'gênero',
  'orientação sexual',
  'deficiência',
  'religião',
];

const FALSE_POSITIVE_PATTERNS = [
  /^test|^demo|^example/i, // test data
];

function layerTwo(text: string, context?: any): { output: PRIOutput; confidence: number; reasoning: string; classifiers: string[] } {
  const classifiers: string[] = [];

  // Check for false positive patterns
  for (const pattern of FALSE_POSITIVE_PATTERNS) {
    if (pattern.test(text)) {
      classifiers.push('false_positive_pattern');
      return {
        output: 'BLOCK',
        confidence: 85,
        reasoning: 'Matches test/demo pattern, likely not real PII',
        classifiers,
      };
    }
  }

  // Check for bias signals (LGPD compliance)
  if (context?.impacts_fundamental_rights) {
    const hasBiasSignal = BIAS_SIGNALS.some((signal) => text.toLowerCase().includes(signal));
    if (hasBiasSignal) {
      classifiers.push('bias_signal_detected');
      return {
        output: 'ESCALATE',
        confidence: 85,
        reasoning: 'Text contains protected characteristic — human review required (LGPD Art. 9)',
        classifiers,
      };
    }
  }

  // Ambiguous: pure numbers without context
  if (/^\d+$/.test(text.trim())) {
    classifiers.push('ambiguous_number');
    return {
      output: 'DEFER',
      confidence: 45,
      reasoning: 'Numeric sequence — could be CPF, phone, ID. Need more context.',
      classifiers,
    };
  }

  // No heuristic match → continue to layer 3
  return {
    output: 'DEFER',
    confidence: 0,
    reasoning: 'No heuristic decision',
    classifiers,
  };
}

// ── Layer 3: LLM Evaluation (Qwen-plus) ──────────────────────────

// Mock implementation (would call actual LLM in production)
async function layerThree(text: string, pii_types: string[]): Promise<{ output: PRIOutput; confidence: number; reasoning: string; classifiers: string[] }> {
  // In production: call Qwen API or Gemini
  // For now: simple heuristic as placeholder

  const classifiers: string[] = ['llm_mock'];

  // If text contains common PII prefixes
  if (/cpf|rg|masp|placa|email|phone|processo/i.test(text)) {
    return {
      output: 'ALLOW',
      confidence: 90,
      reasoning: 'LLM confirmed PII context',
      classifiers,
    };

exec
/bin/bash -lc "sed -n '220,520p' packages/core/src/guards/pri.ts && sed -n '1,240p' packages/shared/src/agent-signature.ts" in /home/enio/egos
 succeeded in 0ms:
    };
  }

  // Suspicious patterns
  if (/SELECT|INSERT|DELETE|DROP/i.test(text)) {
    return {
      output: 'BLOCK',
      confidence: 90,
      reasoning: 'SQL injection pattern detected',
      classifiers,
    };
  }

  // Default: cannot determine
  return {
    output: 'STUDY',
    confidence: 30,
    reasoning: 'LLM could not classify pattern',
    classifiers,
  };
}

// ── Layer 4: Admin Override ────────────────────────────────────

function layerFour(context?: any): { output: PRIOutput; confidence: number; reasoning: string } | null {
  if (context?.is_admin_action) {
    // In production: verify signature, audit log
    return {
      output: 'ALLOW',
      confidence: 100,
      reasoning: 'Admin override with audit log',
    };
  }
  return null;
}

// ── Main PRI Evaluator ─────────────────────────────────────────

export class PRIGate {
  private strategy: PRIStrategy = 'balanced';
  private auditLog: PRIAuditEvent[] = [];
  private llmEvaluator?: PRILlmEvaluator;

  constructor(strategy?: PRIStrategy, llmEvaluator?: PRILlmEvaluator) {
    if (strategy) this.strategy = strategy;
    this.llmEvaluator = llmEvaluator;
  }

  async evaluate(request: PRIRequest): Promise<PRIDecision> {
    const startTime = Date.now();
    const pii_types = request.pii_types || [];
    const strategy = request.strategy || this.strategy;

    try {
      // Layer 4: Admin override (instant, no other layers)
      const adminResult = layerFour(request.context);
      if (adminResult) {
        return this.finalizeDecision(adminResult, [], 'admin_override', Date.now() - startTime);
      }

      // Layer 1: Fast path (regex + patterns)
      const l1_result = layerOne(request.text, pii_types);
      if (l1_result.output !== 'DEFER') {
        return this.finalizeDecision(l1_result, l1_result.classifiers, 'layer_1', Date.now() - startTime);
      }

      // Layer 2: Semantic check (heuristics)
      const l2_result = layerTwo(request.text, request.context);
      if (l2_result.output !== 'DEFER' || l2_result.confidence > 0) {
        return this.finalizeDecision(l2_result, l2_result.classifiers, 'layer_2', Date.now() - startTime);
      }

      // Layer 3: LLM evaluation (SÓ como escalação — L1/L2 inconclusivos).
      // Usa o avaliador LLM injetado se houver; senão o mock determinístico.
      // Fail-closed (PRI): qualquer erro/schema inválido → BLOCK (ignorância = gatilho de pausa).
      if (l2_result.confidence < 60) {
        if (this.llmEvaluator) {
          const VALID: PRIOutput[] = ['ALLOW', 'BLOCK', 'DEFER', 'ESCALATE', 'STUDY'];
          let l3_result: { output: PRIOutput; confidence: number; reasoning: string; classifiers: string[] };
          try {
            const raw = await this.llmEvaluator(request.text, pii_types);
            if (VALID.includes(raw.output as PRIOutput) && typeof raw.confidence === 'number') {
              l3_result = { output: raw.output as PRIOutput, confidence: raw.confidence, reasoning: raw.reasoning, classifiers: ['llm:real'] };
            } else {
              l3_result = { output: 'BLOCK', confidence: 50, reasoning: 'LLM violou o schema de saída — recuo por ignorância (PRI)', classifiers: ['llm:invalid_schema'] };
            }
          } catch (err) {
            l3_result = { output: 'BLOCK', confidence: 50, reasoning: `Erro no avaliador LLM: ${(err as Error).message} — recuo por ignorância (PRI)`, classifiers: ['llm:error'] };
          }
          return this.finalizeDecision(l3_result, l3_result.classifiers, 'layer_3', Date.now() - startTime);
        }
        const l3_result = await layerThree(request.text, pii_types);
        return this.finalizeDecision(l3_result, l3_result.classifiers, 'layer_3', Date.now() - startTime);
      }

      // Default: Cannot determine, use strategy thresholds
      const thresholds = THRESHOLDS[strategy];
      const conf = l2_result.confidence;
      let output: PRIOutput = 'STUDY';

      if (conf >= thresholds.ALLOW) output = 'ALLOW';
      else if (conf >= thresholds.BLOCK) output = 'BLOCK';
      else if (conf >= thresholds.DEFER) output = 'DEFER';
      else if (conf >= thresholds.ESCALATE) output = 'ESCALATE';

      return this.finalizeDecision(
        { output, confidence: conf, reasoning: 'Strategy-based fallback' },
        l2_result.classifiers,
        'strategy_fallback',
        Date.now() - startTime,
      );
    } catch (error) {
      // System error: conservative default
      const context = request.context;
      const fallbackOutput = context?.impacts_fundamental_rights ? 'ESCALATE' : 'BLOCK';

      return this.finalizeDecision(
        {
          output: fallbackOutput,
          confidence: 0,
          reasoning: `System error: ${(error as any).message} — safe default applied`,
        },
        ['system_error'],
        'error_handler',
        Date.now() - startTime,
      );
    }
  }

  private finalizeDecision(
    decision: { output: PRIOutput; confidence: number; reasoning: string },
    classifiers: string[],
    source: string,
    duration_ms: number,
  ): PRIDecision {
    const timestamp = new Date().toISOString();
    const request_hash = createHash('sha256').update(Math.random().toString()).digest('hex').slice(0, 8);
    const audit_hash = createHash('sha256')
      .update(`${timestamp}:${decision.output}:${request_hash}`)
      .digest('hex');

    const result: PRIDecision = {
      output: decision.output,
      confidence: decision.confidence,
      reasoning: decision.reasoning,
      missing_signals:
        decision.output === 'DEFER' ? ['more_context', 'semantic_clarity'] : decision.output === 'STUDY' ? ['pattern_definition', 'training_data'] : [],
      classifiers_consulted: classifiers,
      timestamp,
      audit_hash,
    };

    // Log audit event
    this.auditLog.push({
      event_id: `pri-${Date.now()}-${Math.random().toString(36).slice(2, 9)}`,
      timestamp,
      request_hash,
      decision: result,
      classifiers: classifiers.map((c) => ({
        name: c,
        result: decision.output,
        confidence: decision.confidence,
        latency_ms: duration_ms,
      })),
      cost_usd: 0.00001, // placeholder
    });

    return result;
  }

  getAuditLog(filter?: { output?: PRIOutput; since?: Date }): PRIAuditEvent[] {
    return this.auditLog.filter((event) => {
      if (filter?.output && event.decision.output !== filter.output) return false;
      if (filter?.since && new Date(event.timestamp) < filter.since) return false;
      return true;
    });
  }

  getMetrics() {
    const total = this.auditLog.length;
    if (total === 0) return { total: 0, distribution: {}, avg_confidence: 0 };

    const distribution: Record<PRIOutput, number> = {
      ALLOW: 0,
      BLOCK: 0,
      DEFER: 0,
      ESCALATE: 0,
      STUDY: 0,
    };

    let totalConfidence = 0;

    for (const event of this.auditLog) {
      distribution[event.decision.output]++;
      totalConfidence += event.decision.confidence;
    }

    return {
      total,
      distribution,
      avg_confidence: Math.round(totalConfidence / total),
      percentages: {
        ALLOW: Math.round((distribution.ALLOW / total) * 100),
        BLOCK: Math.round((distribution.BLOCK / total) * 100),
        DEFER: Math.round((distribution.DEFER / total) * 100),
        ESCALATE: Math.round((distribution.ESCALATE / total) * 100),
        STUDY: Math.round((distribution.STUDY / total) * 100),
      },
    };
  }
}

// ── Singleton Instance ─────────────────────────────────────────

let priInstance: PRIGate | null = null;

export function getPRIGate(strategy?: PRIStrategy, llmEvaluator?: PRILlmEvaluator): PRIGate {
  if (!priInstance) {
    priInstance = new PRIGate(strategy, llmEvaluator);
  }
  return priInstance;
}

// ── Export for testing ─────────────────────────────────────────

export { layerOne, layerTwo, layerThree, layerFour };
/**
 * Agent Signature & Action Ledger — INC-001 mitigation
 *
 * Cryptographically signs every meaningful action an agent takes and
 * appends it to a tamper-evident Merkle chain stored in Supabase.
 *
 * This is the action-provenance layer that complements:
 *   - provenance.ts        → data provenance (raw_line_hash, source_*)
 *   - evidence-chain.ts    → claim provenance (AI claims + tool calls)
 *   - PRI (pri.md)         → decision gates (ALLOW/BLOCK/DEFER/ESCALATE/STUDY)
 *
 * Design (born from INC-001 — 2026-04-06 force-push by parallel agent):
 *
 * 1. Each agent has an Ed25519 keypair. Public key stored in
 *    `agent_keys` table; private key stored in Supabase Vault.
 *
 * 2. Every meaningful action (commit, push, merge, deploy, release,
 *    config_change, message_send, etc.) goes through `signAndAppend()`
 *    which:
 *      a) builds br-acc-style audit fields via provenance.ts
 *      b) computes prev_hash → hash chain link
 *      c) signs `hash` with the agent's private key
 *      d) inserts into `agent_actions_ledger`
 *      e) returns the row including the signature
 *
 * 3. Each action declares an `approval_level`:
 *      L0 = autonomous (just log)
 *      L1 = notify (log + ping a human channel)
 *      L2 = approval (don't execute until a human marks `approved_by`)
 *
 * 4. Verifying chain integrity is a single SELECT on the
 *    `agent_ledger_integrity` view (returns broken links).
 *
 * 5. Verifying any individual action: anyone can fetch the agent's
 *    public key + the action row, recompute the hash from the chain,
 *    and verify the Ed25519 signature. No central trust.
 */

import { createSign, createVerify, generateKeyPairSync, createPublicKey, sign as edSign, verify as edVerify } from 'node:crypto';
import { buildAuditFields, sha256Text, type AuditFields } from './provenance.ts';

export type ApprovalLevel = 'L0' | 'L1' | 'L2';

export type ActionType =
  | 'commit' | 'push' | 'merge' | 'release' | 'deploy' | 'config_change'
  | 'message_send' | 'task_create' | 'task_update' | 'file_write' | 'file_delete'
  | 'api_call' | 'tool_use' | 'merge_pr' | 'merge_branch' | 'rebase'
  | 'schedule_run' | 'governance_check' | 'audit_run'
  | 'fetch_source' | 'parse_response' | 'enrich_node' | 'graph_write'
  | 'other';

/**
 * Default approval levels per action type. Risky actions default to L2
 * so they wait for human approval. Safe read-only actions default to L0.
 *
 * Override per call via `signAndAppend({ approvalLevel: ... })`.
 */
export const DEFAULT_APPROVAL_LEVELS: Record<ActionType, ApprovalLevel> = {
  // L2 — risky, requires human approval before execution
  push: 'L2',
  merge: 'L2',
  merge_pr: 'L2',
  merge_branch: 'L2',
  release: 'L2',
  deploy: 'L2',
  config_change: 'L2',
  rebase: 'L2',
  file_delete: 'L2',

  // L1 — notify a human, then proceed
  commit: 'L1',
  message_send: 'L1',
  task_create: 'L1',
  task_update: 'L1',
  file_write: 'L1',

  // L0 — autonomous, just log
  api_call: 'L0',
  tool_use: 'L0',
  schedule_run: 'L0',
  governance_check: 'L0',
  audit_run: 'L0',
  fetch_source: 'L0',
  parse_response: 'L0',
  enrich_node: 'L0',
  graph_write: 'L0',
  other: 'L0',
};

export interface AgentKeyPair {
  agentId: string;
  publicKeyBase64Url: string;
  privateKeyPem: string; // PKCS#8 PEM (store in Supabase Vault, NOT git)
}

export interface SignedAction extends AuditFields {
  id?: string;
  ts: string;
  agent_id: string;
  action_type: ActionType;
  approval_level: ApprovalLevel;
  payload: Record<string, unknown>;
  prev_hash: string | null;
  hash: string;
  signature: string;
  signing_key_id?: string;
  approved_by?: string | null;
  approval_evidence?: Record<string, unknown> | null;
  correlation_id?: string;
}

export interface SignAndAppendOptions {
  agentId: string;
  privateKeyPem: string;
  actionType: ActionType;
  payload: Record<string, unknown>;
  sourceUrl: string;     // file://, https://, ccr://, gha://, local://...
  sourceMethod: string;  // 'git_commit', 'http_get', 'ccr_scheduled', etc.
  approvalLevel?: ApprovalLevel;
  prevHash?: string | null;
  correlationId?: string;
  ts?: string;
}

// ─── key management ─────────────────────────────────────────────────────

/**
 * Generate a new Ed25519 keypair for an agent. Call this ONCE per agent
 * and store the private key in Supabase Vault. The public key goes into
 * the `agent_keys` table.
 */
export function generateAgentKeyPair(agentId: string): AgentKeyPair {
  const { publicKey, privateKey } = generateKeyPairSync('ed25519');
  const pubRaw = publicKey.export({ format: 'der', type: 'spki' });
  // SPKI Ed25519 has a fixed 12-byte prefix; the actual key is the last 32 bytes
  const pubBytes = pubRaw.subarray(pubRaw.length - 32);
  return {
    agentId,
    publicKeyBase64Url: bufToBase64Url(pubBytes),
    privateKeyPem: privateKey.export({ format: 'pem', type: 'pkcs8' }) as string,
  };
}

// ─── canonical action serialization ─────────────────────────────────────

/**
 * Compute the deterministic hash for an action row. This is what gets
 * signed. Including prev_hash makes the chain Merkle-linked: rewriting
 * any past row breaks all subsequent hashes.
 */
export function computeActionHash(args: {
  prevHash: string | null;
  ts: string;
  agentId: string;
  actionType: ActionType;
  rawLineHash: string;
  sourceFingerprint: string;
}): string {
  const parts = [
    args.prevHash ?? '',
    args.ts,
    args.agentId,
    args.actionType,
    args.rawLineHash,
    args.sourceFingerprint,
  ];
  return sha256Text(parts.join('|'));
}

// ─── signing + verification ─────────────────────────────────────────────

export function signHash(hashHex: string, privateKeyPem: string): string {
  // Ed25519 signs raw bytes (no pre-hash). We sign the hex string directly
  // so that verifiers only need the hex hash (which is in the row).
  const sig = edSign(null, Buffer.from(hashHex, 'utf8'), privateKeyPem);
  return bufToBase64Url(sig);
}

export function verifySignature(
  hashHex: string,
  signatureBase64Url: string,
  publicKeyBase64Url: string,
): boolean {
  const sigBytes = base64UrlToBuf(signatureBase64Url);
  const pubBytes = base64UrlToBuf(publicKeyBase64Url);
  // Reconstruct an Ed25519 SPKI key from raw 32-byte public key
  const spkiPrefix = Buffer.from([
    0x30, 0x2a, 0x30, 0x05, 0x06, 0x03, 0x2b, 0x65,
    0x70, 0x03, 0x21, 0x00,
  ]);
  const spki = Buffer.concat([spkiPrefix, pubBytes]);
  const pubKey = createPublicKey({
    key: spki,
    format: 'der',
    type: 'spki',
  });
  return edVerify(null, Buffer.from(hashHex, 'utf8'), pubKey, sigBytes);
}

// ─── high-level helper ──────────────────────────────────────────────────

/**
 * Build a fully signed SignedAction row, ready to insert into
 * `agent_actions_ledger`. Does NOT do the insert (to keep this lib
 * Supabase-agnostic). Caller wraps with their own DB client.
 *
 * Approval level defaults to DEFAULT_APPROVAL_LEVELS[actionType] but
 * can be overridden. L2 actions return with `approved_by: null` —
 * they should be inserted but treated as PROPOSED, not executed,
 * until a human sets approved_by.
 */
export function buildSignedAction(opts: SignAndAppendOptions): SignedAction {
  const ts = opts.ts ?? new Date().toISOString().replace(/\.\d{3}Z$/, 'Z');
  const audit = buildAuditFields({
    rawRow: opts.payload,
    sourceUrl: opts.sourceUrl,
    method: opts.sourceMethod,
    collectedAt: ts,
  });
  const hash = computeActionHash({
    prevHash: opts.prevHash ?? null,
    ts,
    agentId: opts.agentId,
    actionType: opts.actionType,
    rawLineHash: audit.raw_line_hash,
    sourceFingerprint: audit.source_fingerprint,
  });
  const signature = signHash(hash, opts.privateKeyPem);
  const approvalLevel = opts.approvalLevel ?? DEFAULT_APPROVAL_LEVELS[opts.actionType];
  return {
    ...audit,
    ts,
    agent_id: opts.agentId,
    action_type: opts.actionType,
    approval_level: approvalLevel,
    payload: opts.payload,
    prev_hash: opts.prevHash ?? null,
    hash,
    signature,
    approved_by: approvalLevel === 'L2' ? null : opts.agentId,

exec
/bin/bash -lc "sed -n '240,520p' packages/shared/src/agent-signature.ts" in /home/enio/egos
 succeeded in 0ms:
    approved_by: approvalLevel === 'L2' ? null : opts.agentId,
    correlation_id: opts.correlationId,
  };
}

/**
 * Verify a SignedAction's hash chain link AND signature.
 *
 * - Recomputes the hash from the row's fields and the supplied prev_hash
 * - Verifies the Ed25519 signature against the agent's public key
 *
 * Returns true only if BOTH check out.
 */
export function verifySignedAction(
  action: SignedAction,
  publicKeyBase64Url: string,
): boolean {
  const expectedHash = computeActionHash({
    prevHash: action.prev_hash,
    ts: action.ts,
    agentId: action.agent_id,
    actionType: action.action_type,
    rawLineHash: action.raw_line_hash,
    sourceFingerprint: action.source_fingerprint,
  });
  if (expectedHash !== action.hash) return false;
  return verifySignature(action.hash, action.signature, publicKeyBase64Url);
}

// ─── helpers ────────────────────────────────────────────────────────────

function bufToBase64Url(buf: Buffer | Uint8Array): string {
  return Buffer.from(buf)
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}

function base64UrlToBuf(s: string): Buffer {
  const pad = s.length % 4 === 0 ? '' : '='.repeat(4 - (s.length % 4));
  return Buffer.from(s.replace(/-/g, '+').replace(/_/g, '/') + pad, 'base64');
}

// silence unused-import warning if a consumer doesn't tree-shake
export { createSign, createVerify };

exec
/bin/bash -lc "sed -n '1,260p' docs/jobs/2026-06-09-provenance-validation.md && grep -R \"requireEvidence\" -n . --exclude-dir=node_modules --exclude-dir=.git | head -20" in /home/enio/egos
 succeeded in 7802ms:
./.claude/worktrees/agent-ac1433679f0d59800/packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./.claude/worktrees/agent-ac1433679f0d59800/packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./.claude/worktrees/agent-aebb6fcd2a26def5a/packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;
./.claude/worktrees/agent-ace69cd041317702c/packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./.claude/worktrees/agent-ace69cd041317702c/packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./.claude/worktrees/agent-acbc4f85668ef36eb/packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./.claude/worktrees/agent-a9a0bc5c105615ef6/packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;
./packages/guard-brasil/dist/lib/evidence-chain.d.ts:35:    requireEvidence?: boolean;
./packages/guard-brasil/src/lib/evidence-chain.ts:42:  requireEvidence?: boolean;
./packages/shared/src/evidence-chain.ts:40:  requireEvidence?: boolean;

exec
/bin/bash -lc "grep -R \"new PRIGate\\|getPRIGate\\|pii_types.*cpf\\|ALLOW\" -n packages/core packages/shared packages/guard-brasil tests 2>/dev/null | head -80" in /home/enio/egos
 succeeded in 0ms:
packages/core/src/guards/pri.test.ts:6:    const gate = new PRIGate('balanced');
packages/core/src/guards/pri.test.ts:7:    const result = await gate.evaluate({ text: 'CPF 123.456.789-00', pii_types: ['cpf'] });
packages/core/src/guards/pri.test.ts:8:    expect(result.output).toBe('ALLOW');
packages/core/src/guards/pri.test.ts:13:    const gate = new PRIGate('balanced');
packages/core/src/guards/pri.test.ts:14:    const result = await gate.evaluate({ text: '123456789', pii_types: ['cpf'] });
packages/core/src/guards/pri.test.ts:20:    const gate = new PRIGate('balanced');
packages/core/src/guards/pri.test.ts:30:    const gate = new PRIGate('balanced');
packages/core/src/guards/pri.test.ts:31:    const result = await gate.evaluate({ text: 'DROP TABLE users;', pii_types: ['cpf'] });
packages/core/src/guards/pri.ts:6: * When confidence is low, escalate. Never default to ALLOW on uncertainty.
packages/core/src/guards/pri.ts:13:export type PRIOutput = 'ALLOW' | 'BLOCK' | 'DEFER' | 'ESCALATE' | 'STUDY';
packages/core/src/guards/pri.ts:70:    ALLOW: 95,
packages/core/src/guards/pri.ts:77:    ALLOW: 90,
packages/core/src/guards/pri.ts:84:    ALLOW: 80,
packages/core/src/guards/pri.ts:117:        output: 'ALLOW',
packages/core/src/guards/pri.ts:216:      output: 'ALLOW',
packages/core/src/guards/pri.ts:248:      output: 'ALLOW',
packages/core/src/guards/pri.ts:297:          const VALID: PRIOutput[] = ['ALLOW', 'BLOCK', 'DEFER', 'ESCALATE', 'STUDY'];
packages/core/src/guards/pri.ts:320:      if (conf >= thresholds.ALLOW) output = 'ALLOW';
packages/core/src/guards/pri.ts:403:      ALLOW: 0,
packages/core/src/guards/pri.ts:422:        ALLOW: Math.round((distribution.ALLOW / total) * 100),
packages/core/src/guards/pri.ts:436:export function getPRIGate(strategy?: PRIStrategy, llmEvaluator?: PRILlmEvaluator): PRIGate {
packages/core/src/guards/pri.ts:438:    priInstance = new PRIGate(strategy, llmEvaluator);
packages/core/src/protocols/pri.md:6:When insufficient information exists to make a decision confidently, the system does NOT default to ALLOW. Instead, it:
packages/core/src/protocols/pri.md:34:| **ALLOW** | High confidence, proceed | Regex match: "CPF 123.456.789-00" | Execute operation |
packages/core/src/protocols/pri.md:48:  output: 'ALLOW' | 'BLOCK' | 'DEFER' | 'ESCALATE' | 'STUDY';
packages/core/src/protocols/pri.md:59:- ALLOW: `confidence >= 90`
packages/core/src/protocols/pri.md:73:  - CPF pattern: `\d{3}\.\d{3}\.\d{3}-\d{2}` → ALLOW masking
packages/core/src/protocols/pri.md:74:  - Email pattern: `\S+@\S+` → ALLOW masking
packages/core/src/protocols/pri.md:110:│  ├─ YES → ALLOW (confidence: 95)
packages/core/src/protocols/pri.md:117:   ├─ Clear PII? → ALLOW (confidence: 90)
packages/core/src/protocols/pri.md:128:│  ├─ Admin override + audit log? → ALLOW (confidence: 100)
packages/core/src/protocols/pri.md:135:   ├─ Score >= 80? → ALLOW (confidence: 85)
packages/core/src/protocols/pri.md:151:  "pii_types": ["cpf", "rg"],
packages/core/src/protocols/pri.md:161:    "output": "ALLOW",
packages/core/src/protocols/pri.md:170:      "output": "ALLOW",
packages/core/src/protocols/pri.md:184:- Thresholds: ALLOW at 95+, BLOCK at 90+, rest ESCALATE
packages/core/src/protocols/pri.md:188:- Thresholds: ALLOW at 90+, BLOCK at 85+, DEFER at 60+
packages/core/src/protocols/pri.md:192:- Thresholds: ALLOW at 80+, BLOCK at 70+, DEFER at 50+
packages/core/src/protocols/pri.md:206:    "output": "ALLOW",
packages/core/src/protocols/pri.md:253:**Rule:** When in doubt, escalate or block. Never default to ALLOW after an error.
packages/core/src/protocols/pri.md:260:- **Distribution:** % ALLOW vs BLOCK vs DEFER vs ESCALATE vs STUDY (should be ~70% ALLOW, <5% BLOCK)
packages/core/src/protocols/pri.md:269:│  ├─ ALLOW: 94% (avg confidence: 92)
packages/core/src/protocols/pri.md:275:│  ├─ ALLOW (fast): 3ms
packages/core/src/protocols/pri.md:281:   └─ 0.8% (1 BLOCK that should have been ALLOW in last 7 days)
packages/core/src/protocols/pri.md:291:test('regex PII should ALLOW with 95+ confidence', () => {
packages/core/src/protocols/pri.md:294:    pii_types: ['cpf']
packages/core/src/protocols/pri.md:296:  expect(result.output).toBe('ALLOW');
packages/core/src/protocols/pri.md:303:    pii_types: ['cpf']
packages/core/src/protocols/pri.md:310:test('system error should ESCALATE, not ALLOW', () => {
packages/core/src/index.ts:20:export { PRIGate, getPRIGate } from './guards/pri';
packages/core/README.md:27:const gate = getPRIGate()
packages/shared/src/guards/pri-llm-evaluator.ts:10: * esgotada → BLOCK com confidence 50. Ignorância = gatilho de pausa, nunca ALLOW.
packages/shared/src/guards/pri-llm-evaluator.ts:13: *   import { getPRIGate } from '@egos/core';
packages/shared/src/guards/pri-llm-evaluator.ts:15: *   const gate = getPRIGate('balanced', createHermesLlmEvaluator());
packages/shared/src/guards/pri-llm-evaluator.ts:24:  output: string; // 'ALLOW' | 'BLOCK' | 'DEFER' | 'ESCALATE' | 'STUDY' — validado pelo PRIGate
packages/shared/src/guards/pri-llm-evaluator.ts:44:{ "output": "ALLOW" | "BLOCK" | "DEFER" | "ESCALATE" | "STUDY", "confidence": number, "reasoning": "explicação concisa em português" }
packages/shared/src/guards/pri-llm-evaluator.ts:48:- Menção semântica óbvia das PIIs pedidas -> output = "ALLOW" (o gate avalia se a PII existe antes de mascarar), confidence = 90+
packages/shared/src/agent-signature.ts:10: *   - PRI (pri.md)         → decision gates (ALLOW/BLOCK/DEFER/ESCALATE/STUDY)
packages/shared/src/store/products/validation.ts:29:export const ALLOWED_PRODUCT_FIELDS = new Set([
packages/shared/src/store/products/validation.ts:88:    if (ALLOWED_PRODUCT_FIELDS.has(k)) clean[k] = v;
packages/shared/src/store/index.ts:37:  ALLOWED_PRODUCT_FIELDS,
packages/shared/node_modules/@egosbr/audit/src/activation-audit.ts:106:      console.log('[AUDIT-ALLOWED]', JSON.stringify(logEntry, null, 2));
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:6:    const gate = new PRIGate('balanced');
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:7:    const result = await gate.evaluate({ text: 'CPF 123.456.789-00', pii_types: ['cpf'] });
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:8:    expect(result.output).toBe('ALLOW');
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:13:    const gate = new PRIGate('balanced');
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:14:    const result = await gate.evaluate({ text: '123456789', pii_types: ['cpf'] });
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:20:    const gate = new PRIGate('balanced');
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:30:    const gate = new PRIGate('balanced');
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.test.ts:31:    const result = await gate.evaluate({ text: 'DROP TABLE users;', pii_types: ['cpf'] });
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:6: * When confidence is low, escalate. Never default to ALLOW on uncertainty.
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:13:export type PRIOutput = 'ALLOW' | 'BLOCK' | 'DEFER' | 'ESCALATE' | 'STUDY';
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:70:    ALLOW: 95,
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:77:    ALLOW: 90,
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:84:    ALLOW: 80,
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:117:        output: 'ALLOW',
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:216:      output: 'ALLOW',
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:248:      output: 'ALLOW',
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:297:          const VALID: PRIOutput[] = ['ALLOW', 'BLOCK', 'DEFER', 'ESCALATE', 'STUDY'];
packages/shared/node_modules/@egosbr/audit/node_modules/@egos/core/src/guards/pri.ts:320:      if (conf >= thresholds.ALLOW) output = 'ALLOW';

exec
/bin/bash -lc "nl -ba docs/tutor/PROVENANCE_4_CAMADAS.html | sed -n '229,245p'" in /home/enio/egos
 succeeded in 0ms:
   229	        <section id="l2" aria-labelledby="h-l2">
   230	          <h2 id="h-l2">L2 — Cadeia de evidência: toda afirmação carrega sua fonte</h2>
   231	          <div class="layer-card">
   232	            <h3><span class="layer-num">L2</span> Evidence chain <span class="badge real">REAL</span></h3>
   233	            <p>Aqui cada afirmação vem grudada com (a) <strong>de onde ela veio</strong> e (b) <strong>o nível de certeza</strong>. O EGOS usa três rótulos:</p>
   234	            <ul>
   235	              <li><strong>CONFIRMADO</strong> — provado por uma fonte direta (um extrato, um arquivo, um teste).</li>
   236	              <li><strong>INFERIDO</strong> — deduzido a partir de fatos, mas não visto diretamente.</li>
   237	              <li><strong>HIPÓTESE</strong> — possibilidade ainda não provada.</li>
   238	            </ul>
   239	            <div class="use-case">
   240	              <b>Caso de uso:</b> num relatório, a frase "o investigado movimentou R$ 50 mil" não anda sozinha — ela vem com <code>fonte: extrato bancário, linha 412 · CONFIRMADO</code>. Já "o dinheiro veio de fonte ilícita" aparece como <code>HIPÓTESE</code>. Quem lê sabe na hora o que é pedra e o que é areia — e ninguém repete sua conclusão como fato sem ver a base.
   241	            </div>
   242	            <p>A cadeia inteira ganha um <strong>hash de auditoria</strong>, então o conjunto de evidências também fica selado contra alteração.</p>
   243	            <div class="kv">Arquivo: <code>packages/shared/src/evidence-chain.ts</code> · prova: <code>auditHash = ev-698b7574</code></div>
   244	          </div>
   245	        </section>

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
codex
The patch adds a tutor document that makes safety/provenance guarantees which do not match the current PRI and evidence-chain behavior. These are actionable documentation defects because they can mislead users about when PII is held for HITL and whether claims are forcibly sourced.

Full review comments:

- [P2] Do not claim PRI defers CPF publication — /home/enio/egos/docs/tutor/PROVENANCE_4_CAMADAS.html:263-264
  In the documented CPF-publication scenario, the existing PRI implementation does not send a matched CPF to `DEFER`: `layerOne()` returns `ALLOW` with 95 confidence for requested regex PII, and `pri.test.ts` explicitly expects `ALLOW` for `CPF 123.456.789-00`. This tutor would tell readers that sensitive output is held for human approval when the gate actually allows the masking path, so either document the real ALLOW/masking behavior or change the gate before making this claim.

- [P2] Avoid claiming every evidence claim is sourced — /home/enio/egos/docs/tutor/PROVENANCE_4_CAMADAS.html:230-233
  This describes L2 as if every claim necessarily carries a source and certainty label, but `EvidenceChainBuilder.addClaim()` accepts any `EvidenceItem[]` including an empty array and `build()` still emits the chain with `verifiable: false`; the `requireEvidence` option is not enforced. For consumers that add unsourced claims, this doc overstates a runtime guarantee, so the wording should be softened to “can carry” evidence or the builder should reject unsourced claims when that guarantee is advertised.
The patch adds a tutor document that makes safety/provenance guarantees which do not match the current PRI and evidence-chain behavior. These are actionable documentation defects because they can mislead users about when PII is held for HITL and whether claims are forcibly sourced.

Full review comments:

- [P2] Do not claim PRI defers CPF publication — /home/enio/egos/docs/tutor/PROVENANCE_4_CAMADAS.html:263-264
  In the documented CPF-publication scenario, the existing PRI implementation does not send a matched CPF to `DEFER`: `layerOne()` returns `ALLOW` with 95 confidence for requested regex PII, and `pri.test.ts` explicitly expects `ALLOW` for `CPF 123.456.789-00`. This tutor would tell readers that sensitive output is held for human approval when the gate actually allows the masking path, so either document the real ALLOW/masking behavior or change the gate before making this claim.

- [P2] Avoid claiming every evidence claim is sourced — /home/enio/egos/docs/tutor/PROVENANCE_4_CAMADAS.html:230-233
  This describes L2 as if every claim necessarily carries a source and certainty label, but `EvidenceChainBuilder.addClaim()` accepts any `EvidenceItem[]` including an empty array and `build()` still emits the chain with `verifiable: false`; the `requireEvidence` option is not enforced. For consumers that add unsourced claims, this doc overstates a runtime guarantee, so the wording should be softened to “can carry” evidence or the builder should reject unsourced claims when that guarantee is advertised.
```
