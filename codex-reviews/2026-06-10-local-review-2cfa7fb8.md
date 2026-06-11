# Codex Local Review — 2026-06-10T00:33:27Z

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
session id: 019eaef2-cbee-73b3-a6ca-9714c9f51fdf
--------
user
changes against 'HEAD~3'
2026-06-10T00:33:29.083869Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T00:33:29.088943Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 2735131dbf076ca71551b77e47adcc3babbb20c9 --stat && git diff 2735131dbf076ca71551b77e47adcc3babbb20c9' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                     | 58 ++++++++++++++-------
 docs/governance/EGOS_BACKBONE_25.md          | 77 ++++++++++++++++++++++++++++
 docs/jobs/2026-06-09-fable5-mission-brief.md | 60 ++++++++++++++++++++++
 3 files changed, 176 insertions(+), 19 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 443263d8..16a919ea 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -8,12 +8,32 @@
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
 > **Isca de valor** = comunidade + material + vídeo + Hotmart (entrada R$4 + networking), NÃO o diagnóstico. Diagnóstico vem depois, com a pessoa real.
 > **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
 
+**🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
+- [ ] **FABLE-ARCHITECT-REVIEW-001** [P1] `enio`+`fable` — Trocar `/model` → Claude Fable 5 e rodar `docs/jobs/2026-06-09-fable5-mission-brief.md` (papel ARQUITETO/ORQUESTRADOR, não executor). Escopo: `docs/governance/EGOS_BACKBONE_25.md` (25 leis-core + 6 topologia, flexível). Output: mapa de precedência + tabela drift + 3 re-arquiteturas + grafo de interconexão (Mycelium/agentes/MCP/skills/VPS/Hermes, arestas REAL/CONCEPT/PHANTOM) + fila de implementação. Implementação volta pro Opus/forja + HITL.
+- [ ] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — GAP: `MODEL_DELEGATION_POLICY.md` não conhece o Fable 5. Encodar o papel (arquiteto/orquestrador, não executor; safeguard cyber→fallback Opus; caro→usar no que mais importa) após o review do FABLE-ARCHITECT-REVIEW-001 desenhar onde ele entra no fluxo.
+
 **🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
 - [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
 - [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
@@ -81,11 +101,11 @@
 
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
@@ -113,7 +133,7 @@
 - [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
 - [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md. **[Addendum 2026-06-08 — Enio:]** princípio-chave: MCP carrega tools/resources/prompts, mas só **regra-como-tool-verificável** se *impõe* na máquina do outro (prompt remoto pode ser ignorado). Encodar governança como tools pass/fail. Candidato pronto: `egos-curriculum` (envelopar `packages/curriculum-gate` no padrão mcp-bridge) = prova viva do padrão. Docs fortes → expor como `resources`; skills → `prompts`. Split público/interno via gate Guardião. HTML = vitrine humana, MCP = transporte de máquina. Próximo movimento adiado por corte Enio ("parar aqui por enquanto").
 - [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
-- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
+- [ ] **PRICING-FOUNDING-PASS-001** [P0-BLOCKED-MIGUEL] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
 - [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
 - [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
 - [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
@@ -421,7 +441,7 @@
 
 ## 🛡️ AGENT & CHATBOT GUARDRAILS — Padrão único p/ todo agente/chatbot/MCP sob domínio EGOS (2026-05-31)
 > **SSOT:** `docs/governance/AGENT_GUARDRAILS_STANDARD.md` (DRAFT v0.1). **Tese:** nenhum agente nosso deve falar/agir algo falso, danoso ou fora de escopo. Stack 5 camadas (L0 input → L4 audit), manifest por superfície, ≥3 golden cases por guardrail (INC-008). **Owner tags:** `guarani`=propõe/testa local · `prime`=revisa/commita/pusha · `redzone`=corte humano Enio.
-- [ ] **GUARD-STD-001** [P0] `redzone` — Enio roda os 6 meta-prompts (MP-1..MP-6 §5 do standard) em Perplexity/Grok/ChatGPT/Gemini + arxiv/reddit; traz respostas. Prime sintetiza em `docs/knowledge/GUARDRAILS_RESEARCH_SYNTHESIS.md` (tratar como UNVERIFIED INC-005, cross-check ≥2 fontes).
+- [ ] **GUARD-STD-001** [P1] `redzone` — Enio roda os 6 meta-prompts (MP-1..MP-6 §5 do standard) em Perplexity/Grok/ChatGPT/Gemini + arxiv/reddit; traz respostas. Prime sintetiza em `docs/knowledge/GUARDRAILS_RESEARCH_SYNTHESIS.md` (tratar como UNVERIFIED INC-005, cross-check ≥2 fontes).
 - [/] **GUARD-STD-003** [P1] `prime` `gated:001,002` — Definir contrato `guardrails.yaml` (schema) + matriz de conformidade. **PARCIAL 2026-06-02:** schema v0.1 + regras de validação + mínimos por tipo + matriz skeleton em `AGENT_GUARDRAILS_STANDARD.md` §8/§9. Fundações de auditoria A2A (ASI 2026) e JCS RFC 8785 Ed25519 implementadas e expostas no mcp-governance (2026-06-02). FALTA: refinar métodos pós-pesquisa (001/002), preencher matriz por código (evidence-first), corte Enio nos mínimos (parte de 006). <!-- scan-ok: FP-placa -->
 - [/] **GUARD-STD-004** [P1] `prime` `gated:003` — Wirar L0/L2/L3 guards. **L3 LLM-gate FEITO 2026-06-03 (corte Enio: escalação-only):** `pri.ts` ganhou injeção de `llmEvaluator` (default=mock; L3 só roda quando L1/L2 inconclusivos, confidence<60); avaliador real `callHermes` em `packages/shared/src/guards/pri-llm-evaluator.ts` (fail-closed BLOCK). @egos/core continua sem dep de shared. 4/4 testes pri passam. **FALTA:** wirar L0 (injection/scope) + L2 (ATRiAN+PII output) em todos os chatbots + injetar o evaluator nos callers reais.
 - [ ] **GUARD-STD-006** [P1] `redzone` `gated:003` — L3 action guards: auth/token nos MCP endpoints + scope matrix (tool×agente) + HITL p/ escrita. Modelo de auth = Red Zone (corte Enio antes de codar).
@@ -429,7 +449,7 @@
 
 ## 💰 VALUATION & ECV — Avaliação de capacidade/valor do EGOS (2026-05-31) [INICIATIVA SEPARADA de GUARDRAILS]
 > **SSOT:** `docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md` (DRAFT, commit `b625a37e`). **Tese:** medir valor por LOC-Verificado + ECV (não LOC bruto). **Red Zone:** todos os números (R$7.02M, R$25.8M-86M, equity 15-35%, $ETHIK) são CONCEPT/histórico — exigem corte Enio antes de qualquer uso externo. **Owner tags:** iguais ao bloco guardrails. ⚠️ NÃO confundir com GUARD-STD-* — Guarani referenciou GUARD-STD-001/002 no plano de valuation por engano; esses IDs pertencem só a guardrails.
-- [ ] **VAL-004** [P0] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
+- [ ] **VAL-004** [P1] `redzone` — Corte Enio sobre números de valuation/equity/$ETHIK: o que vira narrativa pública vs interno. Nada publicado sem este gate.
 - [ ] **VAL-005** [P2] `redzone` — Enio roda meta-prompt de review Codex (§7 do doc) para estressar metodologia ECV; Prime sintetiza (UNVERIFIED INC-005).
 
 ## 🎯 NAME & PROVE — Campanha de Capacidade (Opus 2026-05-30, pós-3-agentes)
@@ -505,7 +525,7 @@
 > **Diferencial vs SEMrush:** visibilidade em IAs (GEO) — fase 2, SEMrush é cego nisso (Princeton arXiv:2311.09735: 43% páginas sem citação IA).
 
 - [ ] **SEO-MVP-003** [P1] `2h Sonnet` — GSC API (grátis, OAuth) se Gabi/cliente tem site → dados reais de ranking/CTR/posição.
-- [ ] **SEO-MVP-005** [P0] `validação` — Rodar `/keyword-temas` com tema real da Gabi → ela confirma se elimina os "3 dias de trabalho". Gate de decisão para Fase 1 (DataForSEO) e Opção 2 (dashboard).
+- [ ] **SEO-MVP-005** [P2] `validação` — Rodar `/keyword-temas` com tema real da Gabi → ela confirma se elimina os "3 dias de trabalho". Gate de decisão para Fase 1 (DataForSEO) e Opção 2 (dashboard).
 - [ ] **SEO-F1-001** [P1] `gate-humano` — FASE 1 (só após SEO-MVP-005 validar): criar conta DataForSEO + depósito $50 (requer Enio: login+cartão; crédito não expira) + adicionar MCP oficial `dataforseo/mcp-server-typescript` + smoke 1 query real. Registrar em INTEGRATION_REGISTRY + MCP_REGISTRY.
 - [ ] **SEO-GEO-001** [P2] `defer` — FASE 2: visibilidade em IAs (DataForSEO AI Optimization / LLM Mentions API, ~US$100/mo). Diferencial premium; só após MVP validado.
 
@@ -534,9 +554,9 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - **Ativar quando Enio aprovar:** `bun scripts/hermes-task-creator.ts --write` (após arquivar TASKS.md)
 
 ### ⚠️ Gates HITL pendentes (P0)
-- [ ] **HERMES-HITL-TELEGRAM** [P0] `5min` — Aprovar 1ª mensagem real `@EGOSin_bot`
+- [ ] **HERMES-HITL-TELEGRAM** [P1] `5min` — Aprovar 1ª mensagem real `@EGOSin_bot`
   - Recomendação: ativar SÓ depois da apresentação GoW (evita interferência)
-- [ ] **HERMES-HITL-TASKS** [P0] `5min` — Aprovar 1ª escrita auto em TASKS.md
+- [ ] **HERMES-HITL-TASKS** [P1] `5min` — Aprovar 1ª escrita auto em TASKS.md
   - Pré-requisito: arquivar TASKS.md primeiro (`bun scripts/tasks-archive.ts --exec`)
 
 ### 🟡 P1 — Próximas 2 semanas
@@ -566,7 +586,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
 
 ### 🟢 CROSS-REPO MONITORING (NOVO 2026-05-26)
 
-- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P0] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
+- [ ] **CROSS-REPO-STARTSYNC-001** `[DEFER-GATE-A]` [P2] `3h` 🆕 — `/start` verifica TODOS repos GitHub Enio
   - Lista repos via `gh repo list enioxt --limit 100`
   - Para cada TIER 1: `git -C $dir fetch origin` + check drift
   - Output: "N repos drifted · K repos com commits novos · M repos com tasks P0 pendentes"
@@ -589,7 +609,7 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
   - Gera `docs/COORDINATION.md` com snapshot semanal
   - HITL: revisão no `/end` domingo
 
-- [ ] **REPO-INVENTORY-001** [P0] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
+- [ ] **REPO-INVENTORY-001** [P2] `1h` 🆕 — ✅ Em execução (Sonnet S 2026-05-26)
   - Output: `docs/governance/REPO_INVENTORY_2026-05-26.md`
   - Decisão arquitetural: TIER 1/2/3 para Autoresearch + monitoring
 
@@ -651,7 +671,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 - [ ] **MCP-BRIDGE-001** [P1] `1h` — Bridge `mcp-storefront` (baixo risco, vendável, sem segredo de kernel). PM2 + Caddy + smoke `initialize` → Unauthorized.
 - [ ] **MCP-BRIDGE-002** [P1] `1h` — Bridge `mcp-ops` + `mcp-observability` (risco médio: revela topologia). Validar que tools read-only não vazam infra sensível antes de expor.
-- [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
+- [ ] **MCP-BRIDGE-003** [P2-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
 ## 🖥️ FRONTEND-SYNC — frontend/README/GitHub refletindo a realidade (Enio 2026-06-01)
@@ -671,7 +691,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## ⛓️ BLOCKCHAIN/TOKEN — decisão estratégica (Enio 2026-06-01) [RED ZONE]
 
 > Pergunta: token próprio (representa código/framework) vs adotar chain existente (BTC/outra) só pro diferencial. Estatuto PCMG + "framework é livre, não produto financeiro" pesam. Sonnet pesquisando (gem-hunter + fontes 2026 + EAS/attestation/anchoring). **Decisão = corte do Enio, irreversível.**
-- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
+- [ ] **BLOCKCHAIN-002-ETHIK-LEGAL** [P2] `redzone` — **Exposição legal do $ETHIK live (policial ativo):** (1) parecer estatuto PCMG — gerir token tradeable pode violar Art.117 (gerência); (2) classificação CVM/BCB — $ETHIK na Uniswap ≈ valor mobiliário / VASP. **NÃO promover/distribuir até parecer.** Manter "ETHIK símbolo, não venda". Liga VAL-004.
 - [ ] **BLOCKCHAIN-003** [P2] — Experimento $0 sem risco: GitHub Action OpenTimestamps nas tags (ancora hash da constituição no Bitcoin) + 1 schema EAS na Base testnet p/ decisões do Council. "Trust via math" sem token. Alimenta demo F1.
 
 ## 🔀 CROSS-WINDOW — absorção 3 janelas + alarme .guarani (Enio 2026-06-01)
@@ -722,7 +742,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PROOF-NARRATIVE-001** [P2] `redzone` — Artigo/post explicando sem hype. HITL.
 - [ ] **PROOF-PERSONA-001** [P2] — Definir quem usaria/compraria de fato (user/buyer/auditor).
 - [ ] **PROOF-MODULES-001** [P2] — Modularizar (replicável): `egos-proof-{core,bitcoin,eas,registry,ui,policy}`. Só após validação.
-- [ ] **PROOF-VERDICT-001** [P0] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
+- [ ] **PROOF-VERDICT-001** [P2] `redzone` — **Corte do Enio:** vale a energia (skill p/ divulgar) ou pausa e foca currículo/stack? Decidir com base no dossiê + matriz de viabilidade.
 
 ## 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
 
@@ -737,7 +757,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## 📥 HANDOFF GUARANI 2026-06-01 — Sci-Hub + scope gate (Prime consolida)
 
 > Guarani deixou 8 arquivos staged. ⚠️ Sci-Hub = circumvention de paywall — **Red Zone legal/reputacional p/ policial ativo + repo público**. NÃO commito o scraper sem corte do Enio.
-- [ ] **HANDOFF-SCIHUB-001** [P0] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
+- [ ] **HANDOFF-SCIHUB-001** [P2] `redzone` — **Corte do Enio:** Sci-Hub scraper (`test-scihub.ts` + `scihub_skill.py` + `SCIHUB_INTEGRATION_RULE.md`) entra no repo? Circumvention de copyright num repo público de policial ativo = risco real. Opções: (a) não commitar / remover; (b) manter local-only gitignored; (c) trocar por fonte legal (arXiv/OpenAlex/Unpaywall/Crossref). **Recomendo (c)** — mesma função, sem risco.
 - [ ] **HANDOFF-SCOPE-001** [P1] `prime` — Commitar o seguro do handoff: `agent-scope-check.ts` + CBC + migration `api_usage.sql` (corrige llm-usage-notify) + .gitignore. GOV-AGENTS-003: integrar scope-gate no pre-commit (frozen, --no-verify + proof).
 
 ## 🧪 UI FUNCTIONAL TESTING — mapa + critérios + sign-off duplo (Enio 2026-06-01) [T1]
@@ -879,7 +899,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### 🔴 P0 Ativas
 
-- [ ] **CBQ-OBS-FOUNDATION-001** [P0] — Migrations Wave 0 (ver CBQ-OBS-001..003)
+- [ ] **CBQ-OBS-FOUNDATION-001** [P2] — Migrations Wave 0 (ver CBQ-OBS-001..003)
 
 ### 🟧 P1 Ativas
 
@@ -944,8 +964,8 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ## 🔬 INTELINK (work-hours, Frente A)
 
-- [ ] **REPORT-007** [P0] — Relatório investigação DHPP (pendente)
-- [ ] **REPORT-006** [P0] — Relatório suspeitos recorrentes (dep Neo4j estável)
+- [ ] **REPORT-007** [P2] — Relatório investigação DHPP (pendente) [pertence a intelink, não framework]
+- [ ] **REPORT-006** [P2] — Relatório suspeitos recorrentes (dep Neo4j estável) [pertence a intelink, não framework]
 - [ ] **REPORT-005** [P1] — Dashboard analytics Intelink
 - [ ] **REPORT-004** [P1] — Exportar dados BISP para Neo4j (16k pessoas) completo
 
diff --git a/docs/governance/EGOS_BACKBONE_25.md b/docs/governance/EGOS_BACKBONE_25.md
new file mode 100644
index 00000000..517aa864
--- /dev/null
+++ b/docs/governance/EGOS_BACKBONE_25.md
@@ -0,0 +1,77 @@
+# EGOS_BACKBONE_25 — A Espinha Dorsal (25 arquivos que dirigem o sistema)
+
+> **Version:** 1.0.0 | **Criado:** 2026-06-09 (Opus 4.8) | **Status:** CANONICAL
+> **Propósito:** eleição curada dos 25 arquivos que governam TODO o EGOS — leis, doutrinas,
+> EPOS, mapas, MCPs, runtime. É o **escopo de revisão do Claude Fable 5 no papel ARQUITETO/ORQUESTRADOR**
+> (Fable não conserta/executa — Fable arquiteta e orquestra; o pesado volta pro Opus/forja com HITL).
+> **Anti-phantom:** todos os paths abaixo verificados via `ls`/`wc` em 2026-06-09.
+
+---
+
+## Como ler esta lista
+Cada entrada: `path` · papel · camada · por que é espinha · ⚠️ flag de estado (drift/bloat/gap já visível).
+
+---
+
+## CAMADA 1 — LEIS / CONSTITUIÇÃO (rule precedence T0–T4; .guarani prevalece em conflito)
+1. `~/.claude/CLAUDE.md` (16KB) — **T0–T2 global**, auto-carregado em TODA sessão de TODO repo. A lei-raiz.
+2. `egos/CLAUDE.md` (21KB) — adapter do kernel + IDENTIDADE (você já é EGOS) + OPUS MODE + SSOT map. ⚠️ candidato a SIMPLIFICAR (CLAUDE-MD-SIMPLIFICADO-001).
+3. `AGENTS.md` (21KB) — constituição canônica **R0–R8** (Karpathy, DB discipline, etc.).
+4. `.guarani/RULES_INDEX.md` (6KB) — índice de governança Guarani; **em conflito, .guarani vence**.
+5. `docs/governance/RULE_SETS_INDEX.md` (54L) — índice dos conjuntos de regra (kernel + leaf).
+
+## CAMADA 2 — DOUTRINAS [T1] (COMO agir)
+6. `docs/governance/INTEGRITY_PROOF_SSOT.md` (306L) — integridade por prova; defesa-em-camadas; fail-closed.
+7. `docs/governance/RESOLVER_DOCTRINE.md` (165L) — Prime = última camada; triagem `R=L/C`; problema nunca chega 2×.
+8. `docs/governance/PRIME_OPERATING_PROCESS.md` (52L) — o loop/flow do Prime (o método, não só os fatos).
+9. `docs/governance/MODEL_DELEGATION_POLICY.md` (206L) — roteamento Opus/Sonnet/Haiku. ⚠️ **falta encodar Fable 5** (arquiteto/orquestrador) — GAP.
+10. `docs/governance/HITL_CURVE_PRINCIPLE.md` (227L) — curva de maturidade HITL por classe de operação.
+11. `docs/governance/HTML_GENERATION_CONSTITUTION.md` (852L) — camada humana (R-HTML-001..008).
+
+## CAMADA 3 — EPOS / PERSONAL-OS (o eixo Enio↔sistema)
+12. `prompts/personal-os/SELF_MAPPING_INTERVIEW.md` (12KB) — entrevista EPOS (16 perguntas, 5 blocos). Constitucional (não dorme).
+13. `docs/personal-os/ENIO_UNDERSTANDING_MAP.md` (9KB) — mapa do Enio + Red Zones (🔴 onde parar).
+14. `docs/personal-os/FOCUS_GATES.md` (12KB) — gates anti-dispersão (Project Inception, New Direction).
+15. `docs/personal-os/UNDERSTANDING_PROTOCOL.md` (6KB) — Karpathy doctrine (entendimento > produção).
+    - satélites: `data/personal-os/private/interview_state.json` + `enio_profile_atoms.jsonl` (estado vivo, gitignored).
+
+## CAMADA 4 — MAPAS / REGISTRIES (descoberta + orquestração)
+16. `docs/EGOS_BOOTSTRAP.md` (17KB) — canonical "o que importa"; lido por `/start`.
+17. `docs/SYSTEM_MAP.md` (20KB) — mapa do sistema.
+18. `docs/governance/MASTER_INDEX.md` (1024L) — registro SSOT universal. ⚠️ **STALE**: diz "17 repos/19 agents", realidade = 32 repos.
+19. `docs/governance/EGOS_AGENT_MAP.md` (27KB) — 308 caps → 10 domínios → 12 agentes (COM-O-QUÊ).
+20. `docs/CAPABILITY_REGISTRY.md` (200KB!) — capabilities SSOT. ⚠️ **BLOAT** — 200KB num arquivo único é risco de orquestração; candidato a split/index.
+21. `agents/registry/triggers.json` (7.7KB) — triggers/roteamento dos agentes.
+
+## CAMADA 5 — MCP (infra de capacidade — "as ferramentas com lei")
+22. `docs/governance/MCP_INTEGRATION_GUIDE.md` (778L) — constituição dos MCPs + `MCP_REGISTRY.md` (229L).
+    - 10 servers reais: `packages/mcp-governance` `mcp-memory` `mcp-eval-runner` `mcp-skills-registry` `mcp-observability` `mcp-ops` `mcp-bridge` `mcp-browser-automation` `mcp-literature` `mcp-g-pecas`.
+
+## CAMADA 6 — RUNTIME / ENFORCEMENT (executa as leis)
+23. `.husky/pre-commit` (45KB!) — o chain de gates (phantom-done, PII, doc-drift, gitleaks…). ⚠️ **45KB num hook** = complexidade que esconde fail-open (5 buracos já achados).
+24. `agents/runtime/runner.ts` (7KB) + `event-bus.ts` (10KB) — **FROZEN** core de orquestração.
+25. `.claude/commands/start.md` (34KB) + `end.md` (53KB) — os rituais de sessão (os loops que carregam/consolidam contexto). ⚠️ **start+end somam 87KB** — os comandos viraram os maiores arquivos do sistema; risco de over-engineering dos próprios rituais.
+
+## CAMADA 7 — INTEGRAÇÃO / TOPOLOGIA (como TUDO se conecta — escopo flexível, +6)
+> Adicionada 2026-06-09 (corte Enio: "não fique fixo nos 25; verifique interconexões — Mycelium, agentes, VPS, Hermes, skills, tudo integrado"). A espinha não é só arquivos de lei — é o GRAFO vivo de quem-chama-quem.
+26. `docs/governance/AGENT_RUNTIME_TOPOLOGY.md` — topologia do runtime (quem roda onde: local · VPS · Hermes).
+27. `docs/governance/INTEGRATION_REGISTRY.md` — registro de integrações ativas (o que está wired vs CONCEPT).
+28. `docs/concepts/mycelium/MYCELIUM_OVERVIEW.md` + `.claude/commands/mycelium.md` — o grafo vivo (Mycelium) = a visão de interconexão.
+29. `docs/governance/UNIFIED_SKILL_ORCHESTRATION_ARCH.md` (701L) + `ACTIVATION_FLOW.md` (695L) + `KERNEL_MISSION_CONTROL.md` — orquestração skills↔agentes↔comandos.
+30. `docs/governance/HERMES_VPS_SECURITY.md` + `HERMES_EGOS_FORK_DECISION.md` + `VPS_OPERATIONS.md` — o agente Hermes na VPS + segurança + operação.
+31. `docs/CROSS_REPO_CONTEXT_ROUTER.md` + `docs/COORDINATION.md` — roteamento cross-repo (7 de 32 repos mapeados — ⚠️ router incompleto) + coordenação multi-janela.
+    - referência viva: `docs/audits/premortem-agent-interconnection.md` (já analisou colisões de interconexão).
+
+> **Nota de escopo:** o conjunto é **flexível** (25 leis-core + 6 topologia = 31 efetivos). Fable pode propor cortar (consolidar redundantes) ou ampliar (artefato-espinha que faltou). O número não é sagrado; a COERÊNCIA do grafo é.
+
+---
+
+## ⚠️ Drift/bloat já visível (input pro Fable, não exaustivo)
+- **MASTER_INDEX stale** (17→32 repos) — o registro universal não reflete a realidade.
+- **CAPABILITY_REGISTRY 200KB** + **pre-commit 45KB** + **end.md 53KB** — três pontos de bloat onde a complexidade esconde erro.
+- **MODEL_DELEGATION_POLICY sem Fable 5** — a política de roteamento de modelo não conhece o modelo mais novo/poderoso.
+- **TASKS.md 994L** (limit 600) — sprawl não resolvível por archive (0 tasks `[x]`).
+- **CLAUDE.md (egos) candidato a simplificar** (router fino vs. 21KB atual).
+
+---
+*Manifesto da espinha — alvo do Fable 5 (arquiteto). Implementação volta pro Opus/forja + HITL.*
diff --git a/docs/jobs/2026-06-09-fable5-mission-brief.md b/docs/jobs/2026-06-09-fable5-mission-brief.md
new file mode 100644
index 00000000..45db9399
--- /dev/null
+++ b/docs/jobs/2026-06-09-fable5-mission-brief.md
@@ -0,0 +1,60 @@
+# Fable 5 — Mission Brief: ARQUITETO/ORQUESTRADOR da Espinha Dorsal
+
+> Preparado por Opus 4.8 (2026-06-09) para execução sob **Claude Fable 5**.
+> **Papel do Fable: ARQUITETAR e ORQUESTRAR — NÃO consertar, NÃO implementar, NÃO escrever código.**
+> O pesado (implementar mudanças) volta pro Opus/forja com HITL. Fable pensa alto e desenha.
+> Janela: Fable 5 grátis em Pro/Max/Team até 2026-06-22. Token-intensive — usar no que mais importa.
+> Safeguard: Fable bloqueia cyber-ofensivo e cai pro Opus. Este alvo é governança/arquitetura → seguro.
+
+## Escopo (ler isto primeiro)
+`docs/governance/EGOS_BACKBONE_25.md` — a eleição curada dos 25 arquivos que dirigem TODO o EGOS,
+em 6 camadas: Leis → Doutrinas → EPOS → Mapas/Registries → MCP → Runtime/Enforcement.
+Ler os 25 (paths no manifesto). NÃO ler intelink/OSINT/cursos cyber (dispara safeguard + fora de escopo).
+
+## Contexto (1 parágrafo)
+O diferencial do EGOS é "governance is infrastructure": a coerência da constituição (T0–T4) +
+doutrinas + mapas + MCPs + runtime é o produto. O sistema cresceu por acreção (102 scopes, 460 commits)
+e há sinais de drift/bloat: MASTER_INDEX stale (17→32 repos), CAPABILITY_REGISTRY 200KB, pre-commit 45KB,
+end.md 53KB, MODEL_DELEGATION_POLICY sem Fable. A pergunta não é "tem bug?" — é "esta constituição
+está ARQUITETADA da melhor forma para escalar e se manter coerente?".
+
+## Missão (as 5 perguntas de ARQUITETO)
+1. **Coerência da precedência.** Os 25 formam uma hierarquia coerente T0–T4? Onde duas leis se contradizem,
+   se sobrepõem, ou competem por autoridade? (ex: CLAUDE.md global vs egos vs AGENTS vs .guarani — quem vence
+   de verdade em cada classe de decisão?). Desenhe o grafo de precedência ideal.
+2. **Drift entre lei e realidade.** Onde um doc-espinha descreve um sistema que não existe mais (MASTER_INDEX
+   17→32 repos)? Onde a constituição "fala" algo que o runtime não "faz"? Liste os gaps lei↔execução.
+3. **Bloat e fronteira de responsabilidade.** CAPABILITY_REGISTRY (200KB), pre-commit (45KB), end.md (53KB):
+   onde um arquivo acumulou responsabilidades demais? Proponha o split/index/refactor ARQUITETURAL (o quê
+   separar de quê, e por quê) — sem escrever o código, só o desenho.
+4. **Orquestração de modelo + agentes.** MODEL_DELEGATION_POLICY não conhece o Fable 5. Desenhe onde Fable
+   (arquiteto), Opus (decisão/pesado), Sonnet (executor), Haiku (mecânico) entram no fluxo. E os 12 agentes +
+   10 MCPs: o roteamento (triggers.json, EGOS_AGENT_MAP) está arquitetado para não colidir (multi-janela)?
+5. **EPOS como eixo.** A entrevista EPOS + ENIO_UNDERSTANDING_MAP + FOCUS_GATES formam um loop que de fato
+   redireciona o sistema conforme o Enio evolui? Ou é coleta que não fecha em ação? Desenhe o loop ideal
+   EPOS→sistema.
+6. **TOPOLOGIA DE INTEGRAÇÃO (verificar interconexões — corte Enio 2026-06-09).** Não fique nos arquivos de
+   lei: verifique o GRAFO vivo de como tudo se conecta — Camada 7 do manifesto. Especificamente:
+   - **Mycelium** (`MYCELIUM_OVERVIEW.md` + `/mycelium`): o grafo vivo reflete a realidade do sistema, ou é
+     visualização que driftou? O que ele mostra como conectado que NÃO está (CONCEPT/PHANTOM)?
+   - **agentes ↔ MCP ↔ skills ↔ comandos**: os 12 agentes (`EGOS_AGENT_MAP`), 10 MCPs (`MCP_INTEGRATION_GUIDE`),
+     skills (`SKILLS_REGISTRY`/`UNIFIED_SKILL_ORCHESTRATION_ARCH`) e triggers (`triggers.json`) formam um grafo
+     coerente, ou há capacidade órfã (declarada mas não wired — viola R-CAP-001)?
+   - **local ↔ VPS ↔ Hermes** (`AGENT_RUNTIME_TOPOLOGY`, `HERMES_VPS_SECURITY`, `VPS_OPERATIONS`): a fronteira
+     de confiança e o que roda onde está clara? O que está wired vs CONCEPT no `INTEGRATION_REGISTRY`?
+   - **cross-repo** (`CROSS_REPO_CONTEXT_ROUTER` — só 7 de 32 repos mapeados): o roteamento está arquitetado
+     para a frota inteira, ou é um router incompleto que esconde repos órfãos?
+   Desenhe o **grafo de interconexão ideal** (nós = agente/MCP/skill/VPS/serviço; arestas = chama/depende/governa)
+   e marque cada aresta REAL/CONCEPT/PHANTOM. Esse grafo é o output mais valioso desta missão.
+
+## Output esperado (de arquiteto)
+- **Mapa de precedência** dos 25 (grafo: quem governa quem, onde há conflito).
+- **Tabela drift**: `arquivo | lei diz | realidade | severidade | re-arquitetura proposta`.
+- **3 propostas de re-arquitetura** priorizadas (bloat/coerência/orquestração) — desenho, não código.
+- **Roadmap de orquestração**: ordem em que Opus/forja deve implementar as mudanças (Fable orquestra a fila).
+- Classificar cada achado REAL/CONCEPT/PHANTOM. Citar `file:line`. Não inventar.
+
+## Não fazer (fronteira dura)
+- NÃO editar nenhum arquivo. NÃO escrever código de implementação. NÃO rodar comandos destrutivos.
+- Saída = arquitetura + orquestração (desenho + fila priorizada). Implementação = Opus/forja + corte Enio.
+- Mudança em arquivo constitucional (CLAUDE.md/AGENTS.md/.guarani) = Red Zone → só proposta, nunca aplicar.

exec
/bin/bash -lc "python3 - <<'PY'
from pathlib import Path
paths = ['CLAUDE.md','AGENTS.md','.guarani/RULES_INDEX.md','docs/governance/RULE_SETS_INDEX.md','docs/governance/INTEGRITY_PROOF_SSOT.md','docs/governance/RESOLVER_DOCTRINE.md','docs/governance/PRIME_OPERATING_PROCESS.md','docs/governance/MODEL_DELEGATION_POLICY.md','docs/governance/HITL_CURVE_PRINCIPLE.md','docs/governance/HTML_GENERATION_CONSTITUTION.md','prompts/personal-os/SELF_MAPPING_INTERVIEW.md','docs/personal-os/ENIO_UNDERSTANDING_MAP.md','docs/personal-os/FOCUS_GATES.md','docs/personal-os/UNDERSTANDING_PROTOCOL.md','docs/EGOS_BOOTSTRAP.md','docs/SYSTEM_MAP.md','docs/governance/MASTER_INDEX.md','docs/governance/EGOS_AGENT_MAP.md','docs/CAPABILITY_REGISTRY.md','agents/registry/triggers.json','docs/governance/MCP_INTEGRATION_GUIDE.md','docs/governance/MCP_REGISTRY.md','.husky/pre-commit','agents/runtime/runner.ts','agents/runtime/event-bus.ts','.claude/commands/start.md','.claude/commands/end.md','docs/governance/AGENT_RUNTIME_TOPOLOGY.md','docs/governance/INTEGRATION_REGISTRY.md','docs/concepts/mycelium/MYCELIUM_OVERVIEW.md','.claude/commands/mycelium.md','docs/governance/UNIFIED_SKILL_ORCHESTRATION_ARCH.md','docs/governance/ACTIVATION_FLOW.md','docs/governance/KERNEL_MISSION_CONTROL.md','docs/governance/HERMES_VPS_SECURITY.md','docs/governance/HERMES_EGOS_FORK_DECISION.md','docs/governance/VPS_OPERATIONS.md','docs/CROSS_REPO_CONTEXT_ROUTER.md','docs/COORDINATION.md','docs/audits/premortem-agent-interconnection.md']
for p in paths:
    print(('OK' if Path(p).exists() else 'MISS'), p)
PY" in /home/enio/egos
 succeeded in 0ms:
OK CLAUDE.md
OK AGENTS.md
OK .guarani/RULES_INDEX.md
OK docs/governance/RULE_SETS_INDEX.md
OK docs/governance/INTEGRITY_PROOF_SSOT.md
OK docs/governance/RESOLVER_DOCTRINE.md
OK docs/governance/PRIME_OPERATING_PROCESS.md
OK docs/governance/MODEL_DELEGATION_POLICY.md
OK docs/governance/HITL_CURVE_PRINCIPLE.md
OK docs/governance/HTML_GENERATION_CONSTITUTION.md
OK prompts/personal-os/SELF_MAPPING_INTERVIEW.md
OK docs/personal-os/ENIO_UNDERSTANDING_MAP.md
OK docs/personal-os/FOCUS_GATES.md
OK docs/personal-os/UNDERSTANDING_PROTOCOL.md
OK docs/EGOS_BOOTSTRAP.md
OK docs/SYSTEM_MAP.md
OK docs/governance/MASTER_INDEX.md
OK docs/governance/EGOS_AGENT_MAP.md
OK docs/CAPABILITY_REGISTRY.md
OK agents/registry/triggers.json
OK docs/governance/MCP_INTEGRATION_GUIDE.md
OK docs/governance/MCP_REGISTRY.md
OK .husky/pre-commit
OK agents/runtime/runner.ts
OK agents/runtime/event-bus.ts
OK .claude/commands/start.md
OK .claude/commands/end.md
OK docs/governance/AGENT_RUNTIME_TOPOLOGY.md
OK docs/governance/INTEGRATION_REGISTRY.md
OK docs/concepts/mycelium/MYCELIUM_OVERVIEW.md
OK .claude/commands/mycelium.md
OK docs/governance/UNIFIED_SKILL_ORCHESTRATION_ARCH.md
OK docs/governance/ACTIVATION_FLOW.md
OK docs/governance/KERNEL_MISSION_CONTROL.md
OK docs/governance/HERMES_VPS_SECURITY.md
OK docs/governance/HERMES_EGOS_FORK_DECISION.md
OK docs/governance/VPS_OPERATIONS.md
OK docs/CROSS_REPO_CONTEXT_ROUTER.md
OK docs/COORDINATION.md
OK docs/audits/premortem-agent-interconnection.md

exec
/bin/bash -lc 'wc -l TASKS.md; grep -R "TASKS.md" -n .husky/pre-commit scripts | head -50' in /home/enio/egos
 succeeded in 0ms:
998 TASKS.md
.husky/pre-commit:520:# TASKS.md enforcement v2 — auto-archive [x] + size limits
.husky/pre-commit:523:if [ -f "TASKS.md" ]; then
.husky/pre-commit:530:  _new_done=$(git diff --cached -U0 -- TASKS.md 2>/dev/null | grep -E '^\+- \[x\]' || true)
.husky/pre-commit:545:  #    TASKS.md is staged. Closes gap where [x] could persist across commits that
.husky/pre-commit:546:  #    don't touch TASKS.md. Resulting changes are auto-staged into this commit.
.husky/pre-commit:547:  _done_count=$(grep -c '^- \[x\]' TASKS.md 2>/dev/null || true)
.husky/pre-commit:550:    # Skip if working tree has uncommitted TASKS.md changes that aren't staged
.husky/pre-commit:552:    _has_unstaged=$(git diff --name-only TASKS.md 2>/dev/null | wc -l)
.husky/pre-commit:554:      echo "  🗄️  Auto-archiving $_done_count completed task(s) from TASKS.md..."
.husky/pre-commit:557:          git add TASKS.md TASKS_ARCHIVE.md 2>/dev/null && \
.husky/pre-commit:558:          echo "  ✅ Auto-archive done — TASKS.md + TASKS_ARCHIVE.md staged into this commit"
.husky/pre-commit:561:      echo "  ⚠️  TASKS.md has $_done_count [x] but unstaged changes detected — skipping auto-archive (manual: bun scripts/tasks-archive.ts --exec)"
.husky/pre-commit:565:  _tasks_lines=$(wc -l < "TASKS.md")
.husky/pre-commit:576:  _dup_ids=$(grep -oP '(?<=\*\*)[A-Z]+-[0-9]+(?=\s*\[)' TASKS.md 2>/dev/null | sort | uniq -d | head -5 || true)
.husky/pre-commit:578:    echo "  🔴 BLOCKED: Duplicate task IDs in TASKS.md:"
.husky/pre-commit:588:      echo "  🚨 TASKS.md has $_tasks_lines lines (hard-block: 600). Grace until $_policy_grace."
.husky/pre-commit:591:      echo "  🔴 BLOCKED: TASKS.md has $_tasks_lines lines (≥600). Archive or move to ROADMAP.md."
.husky/pre-commit:592:      echo "     bun scripts/tasks-archive.ts --exec && git add TASKS.md TASKS_ARCHIVE.md"
.husky/pre-commit:596:    echo "  🚨 URGENT: TASKS.md has $_tasks_lines lines (archive required at 400). Run: bun scripts/tasks-archive.ts --exec"
.husky/pre-commit:598:    echo "  ⚠️  TASKS.md has $_tasks_lines lines (soft warn at 250). Archive when convenient."
scripts/task-dedup-audit.ts:5: * Detects duplicate task IDs across TASKS.md + TASKS_ARCHIVE.md.
scripts/task-dedup-audit.ts:95:  const tasksFile = `${ROOT}/TASKS.md`;
scripts/task-dedup-audit.ts:113:  console.log(`   Scanned: ${all.length} tasks (TASKS.md + TASKS_ARCHIVE.md)\n`);
scripts/hermes-finding-update.ts:55:const TASKS_MD = join(process.cwd(), "TASKS.md");
scripts/hermes-finding-update.ts:255: * TASKS.md uses "HERMES-FINDING-<8chars>" but queue stores 16-char IDs.
scripts/hermes-finding-update.ts:260:    // queue IDs are 16 chars hex; first 8 chars is the TASKS.md key
scripts/hermes-finding-update.ts:269:    console.error(`[LIFECYCLE ERROR] TASKS.md not found at ${TASKS_MD}`);
scripts/hermes-finding-update.ts:274:  // Extract all HERMES-FINDING-<8chars> references from TASKS.md
scripts/hermes-finding-update.ts:282:  console.log(`[LIFECYCLE] Found ${foundPrefixes.size} HERMES-FINDING-* references in TASKS.md`);
scripts/hermes-finding-update.ts:329:      reason: `${displayId} entry found in TASKS.md`,
scripts/morning-report.ts:218:    if (active.length === 0 && coordToday.length === 0) out.push('🌅 Quiet night — focus on TASKS.md P0 items');
scripts/autores-ingest-incidents.ts:81:    proposed_rule_text: "Background agents: NUNCA usar git add -A, git add ., git checkout ., git restore . Usar git add <specific-file>. Antes de spawnar agentes paralelos: commitar TASKS.md + CLAUDE.md. Read-parallel / Write-sequential: nunca 2+ write agents no mesmo repo.",
scripts/autores-ingest-incidents.ts:92:    description: "Agente adicionou tasks ao TASKS.md que não existiam, marcou como completas sem implementar",
scripts/egos-home/manifest.json:38:    "AGENTS.md", "TASKS.md", ".windsurfrules"
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:72:  - `TASKS.md` — execution priorities and gaps
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:91:  - `TASKS.md` — what capabilities are in-flight or blocked
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:394:> **Plano de extração:** ver `TASKS.md` track `🧬 INTELINK HARVEST`.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:630:| Smart TASKS.md Archive | `scripts/archive-tasks.sh` + `.husky/pre-commit` | A | egos | `governance`, `tasks`, `archiving`, `pre-commit` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:812:| `post-commit` | Parse task IDs from commit subject | Marks `- [ ] TASK-ID` done in TASKS.md |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:837:`auto-disseminate.sh` never exits non-zero. It is a best-effort propagator. If TASKS.md
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1002:→ See TASKS.md NOTION-AGENTS-001..005 for integration roadmap.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1012:- Tasks: KBS-027..039 in TASKS.md
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1240:- **Content Track** (TASKS.md §CONTENT TRACK): Pipeline editorial completo — ART-001..008 + X-001..004 + TL-001..004 + SITE-010..013 + TOP-011..018. Foco: artigos técnicos reais → threads X.com → egos.ia.br/timeline.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:2534:**Task:** ISO42001-001 [P3] em TASKS.md | **Tags:** `governance`, `compliance`, `iso42001`, `lgpd`
scripts/egos-home/sync.sh:364:  for f in AGENTS.md TASKS.md; do
scripts/egos-home/hooks/pre-commit:127:    echo "   Move to docs/_archived_handoffs/ or use TASKS.md/SYSTEM_MAP.md instead:"
scripts/egos-home/hooks/pre-commit:140:_chk "AGENTS.md" 200; _chk "TASKS.md" 500; _chk "docs/SYSTEM_MAP.md" 300
scripts/egos-home/hooks/README.md:20:- lembrete de `TASKS.md`
scripts/task-prioritizer.ts:19:const TASKS_FILE = join(process.cwd(), 'TASKS.md');
scripts/hermes-audit-and-sync.sh:4:# Runs hermes-task-audit.ts locally (has access to TASKS.md)

exec
/bin/bash -lc "nl -ba TASKS.md | sed -n '1,45p'; nl -ba docs/governance/EGOS_BACKBONE_25.md | sed -n '1,35p'; nl -ba docs/jobs/2026-06-09-fable5-mission-brief.md | sed -n '1,35p'" in /home/enio/egos
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
    33	**🔬 FABLE 5 — ARQUITETO DA ESPINHA (jun/2026, grátis até 22/06):**
    34	- [ ] **FABLE-ARCHITECT-REVIEW-001** [P1] `enio`+`fable` — Trocar `/model` → Claude Fable 5 e rodar `docs/jobs/2026-06-09-fable5-mission-brief.md` (papel ARQUITETO/ORQUESTRADOR, não executor). Escopo: `docs/governance/EGOS_BACKBONE_25.md` (25 leis-core + 6 topologia, flexível). Output: mapa de precedência + tabela drift + 3 re-arquiteturas + grafo de interconexão (Mycelium/agentes/MCP/skills/VPS/Hermes, arestas REAL/CONCEPT/PHANTOM) + fila de implementação. Implementação volta pro Opus/forja + HITL.
    35	- [ ] **MODEL-DELEGATION-FABLE-ENCODE-001** [P2] `prime` — GAP: `MODEL_DELEGATION_POLICY.md` não conhece o Fable 5. Encodar o papel (arquiteto/orquestrador, não executor; safeguard cyber→fallback Opus; caro→usar no que mais importa) após o review do FABLE-ARCHITECT-REVIEW-001 desenhar onde ele entra no fluxo.
    36	
    37	**🚨 TAREFAS IMEDIATAS PRÉ-WIP (bloquear antes de qualquer sessão):**
    38	- [ ] **TASKS-ARCHIVE-NOW-001** [P0] `prime` — TASKS.md está ~900L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` AGORA. Sem isso o pre-commit vai bloquear toda a sessão seguinte.
    39	- [ ] **NOTEBOOKLM-MIGUEL-SHARE-001** [P0] `prime` — Notebook `e869308b-00cc-4212-9151-9c99884914f7` (mf-certificados) está RESTRITO. Precisa ser compartilhado publicamente (ou Miguel convidado) ANTES de enviar o HTML. Abrir NotebookLM → Share → Anyone with link. Smoke: acessar o link sem estar logado.
    40	- [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
    41	
    42	**WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
    43	- [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
    44	- [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
    45	- [ ] **WA-AGENT-CONNECT-001** [P0] `prime`+`hermes-ops` — RE-TESTAR conexão do agente LLM por trás do WhatsApp (Evolution API/WAHA). ESTADO REAL (auditado 2026-06-09): código do gateway 100% completo e wired ao LLM (apps/egos-gateway/src/channels/whatsapp.ts), mas a SESSÃO nunca conectou estável — número G Peças 5534997934688 ban 2026-05-13 → quarentena code 401 device_removed → WAHA-CONNECT-001 aberta desde 2026-05-14 (HARVEST.md:5489). Telegram @EGOSin_bot FUNCIONA mas é auth-locked Enio, não canal cliente. G Peças hoje atende pelo storefront web. AÇÃO: (a) reconectar sessão WA (número limpo OU WAHA UI), (b) smoke real msg→agente→tool→resposta com Evidence Footer, (c) validar end-to-end com hash+provenance. Absorve WAHA-CONNECT-001. Liga WA-AGENT-ASYNC-ARCH-001.
     1	# EGOS_BACKBONE_25 — A Espinha Dorsal (25 arquivos que dirigem o sistema)
     2	
     3	> **Version:** 1.0.0 | **Criado:** 2026-06-09 (Opus 4.8) | **Status:** CANONICAL
     4	> **Propósito:** eleição curada dos 25 arquivos que governam TODO o EGOS — leis, doutrinas,
     5	> EPOS, mapas, MCPs, runtime. É o **escopo de revisão do Claude Fable 5 no papel ARQUITETO/ORQUESTRADOR**
     6	> (Fable não conserta/executa — Fable arquiteta e orquestra; o pesado volta pro Opus/forja com HITL).
     7	> **Anti-phantom:** todos os paths abaixo verificados via `ls`/`wc` em 2026-06-09.
     8	
     9	---
    10	
    11	## Como ler esta lista
    12	Cada entrada: `path` · papel · camada · por que é espinha · ⚠️ flag de estado (drift/bloat/gap já visível).
    13	
    14	---
    15	
    16	## CAMADA 1 — LEIS / CONSTITUIÇÃO (rule precedence T0–T4; .guarani prevalece em conflito)
    17	1. `~/.claude/CLAUDE.md` (16KB) — **T0–T2 global**, auto-carregado em TODA sessão de TODO repo. A lei-raiz.
    18	2. `egos/CLAUDE.md` (21KB) — adapter do kernel + IDENTIDADE (você já é EGOS) + OPUS MODE + SSOT map. ⚠️ candidato a SIMPLIFICAR (CLAUDE-MD-SIMPLIFICADO-001).
    19	3. `AGENTS.md` (21KB) — constituição canônica **R0–R8** (Karpathy, DB discipline, etc.).
    20	4. `.guarani/RULES_INDEX.md` (6KB) — índice de governança Guarani; **em conflito, .guarani vence**.
    21	5. `docs/governance/RULE_SETS_INDEX.md` (54L) — índice dos conjuntos de regra (kernel + leaf).
    22	
    23	## CAMADA 2 — DOUTRINAS [T1] (COMO agir)
    24	6. `docs/governance/INTEGRITY_PROOF_SSOT.md` (306L) — integridade por prova; defesa-em-camadas; fail-closed.
    25	7. `docs/governance/RESOLVER_DOCTRINE.md` (165L) — Prime = última camada; triagem `R=L/C`; problema nunca chega 2×.
    26	8. `docs/governance/PRIME_OPERATING_PROCESS.md` (52L) — o loop/flow do Prime (o método, não só os fatos).
    27	9. `docs/governance/MODEL_DELEGATION_POLICY.md` (206L) — roteamento Opus/Sonnet/Haiku. ⚠️ **falta encodar Fable 5** (arquiteto/orquestrador) — GAP.
    28	10. `docs/governance/HITL_CURVE_PRINCIPLE.md` (227L) — curva de maturidade HITL por classe de operação.
    29	11. `docs/governance/HTML_GENERATION_CONSTITUTION.md` (852L) — camada humana (R-HTML-001..008).
    30	
    31	## CAMADA 3 — EPOS / PERSONAL-OS (o eixo Enio↔sistema)
    32	12. `prompts/personal-os/SELF_MAPPING_INTERVIEW.md` (12KB) — entrevista EPOS (16 perguntas, 5 blocos). Constitucional (não dorme).
    33	13. `docs/personal-os/ENIO_UNDERSTANDING_MAP.md` (9KB) — mapa do Enio + Red Zones (🔴 onde parar).
    34	14. `docs/personal-os/FOCUS_GATES.md` (12KB) — gates anti-dispersão (Project Inception, New Direction).
    35	15. `docs/personal-os/UNDERSTANDING_PROTOCOL.md` (6KB) — Karpathy doctrine (entendimento > produção).
     1	# Fable 5 — Mission Brief: ARQUITETO/ORQUESTRADOR da Espinha Dorsal
     2	
     3	> Preparado por Opus 4.8 (2026-06-09) para execução sob **Claude Fable 5**.
     4	> **Papel do Fable: ARQUITETAR e ORQUESTRAR — NÃO consertar, NÃO implementar, NÃO escrever código.**
     5	> O pesado (implementar mudanças) volta pro Opus/forja com HITL. Fable pensa alto e desenha.
     6	> Janela: Fable 5 grátis em Pro/Max/Team até 2026-06-22. Token-intensive — usar no que mais importa.
     7	> Safeguard: Fable bloqueia cyber-ofensivo e cai pro Opus. Este alvo é governança/arquitetura → seguro.
     8	
     9	## Escopo (ler isto primeiro)
    10	`docs/governance/EGOS_BACKBONE_25.md` — a eleição curada dos 25 arquivos que dirigem TODO o EGOS,
    11	em 6 camadas: Leis → Doutrinas → EPOS → Mapas/Registries → MCP → Runtime/Enforcement.
    12	Ler os 25 (paths no manifesto). NÃO ler intelink/OSINT/cursos cyber (dispara safeguard + fora de escopo).
    13	
    14	## Contexto (1 parágrafo)
    15	O diferencial do EGOS é "governance is infrastructure": a coerência da constituição (T0–T4) +
    16	doutrinas + mapas + MCPs + runtime é o produto. O sistema cresceu por acreção (102 scopes, 460 commits)
    17	e há sinais de drift/bloat: MASTER_INDEX stale (17→32 repos), CAPABILITY_REGISTRY 200KB, pre-commit 45KB,
    18	end.md 53KB, MODEL_DELEGATION_POLICY sem Fable. A pergunta não é "tem bug?" — é "esta constituição
    19	está ARQUITETADA da melhor forma para escalar e se manter coerente?".
    20	
    21	## Missão (as 5 perguntas de ARQUITETO)
    22	1. **Coerência da precedência.** Os 25 formam uma hierarquia coerente T0–T4? Onde duas leis se contradizem,
    23	   se sobrepõem, ou competem por autoridade? (ex: CLAUDE.md global vs egos vs AGENTS vs .guarani — quem vence
    24	   de verdade em cada classe de decisão?). Desenhe o grafo de precedência ideal.
    25	2. **Drift entre lei e realidade.** Onde um doc-espinha descreve um sistema que não existe mais (MASTER_INDEX
    26	   17→32 repos)? Onde a constituição "fala" algo que o runtime não "faz"? Liste os gaps lei↔execução.
    27	3. **Bloat e fronteira de responsabilidade.** CAPABILITY_REGISTRY (200KB), pre-commit (45KB), end.md (53KB):
    28	   onde um arquivo acumulou responsabilidades demais? Proponha o split/index/refactor ARQUITETURAL (o quê
    29	   separar de quê, e por quê) — sem escrever o código, só o desenho.
    30	4. **Orquestração de modelo + agentes.** MODEL_DELEGATION_POLICY não conhece o Fable 5. Desenhe onde Fable
    31	   (arquiteto), Opus (decisão/pesado), Sonnet (executor), Haiku (mecânico) entram no fluxo. E os 12 agentes +
    32	   10 MCPs: o roteamento (triggers.json, EGOS_AGENT_MAP) está arquitetado para não colidir (multi-janela)?
    33	5. **EPOS como eixo.** A entrevista EPOS + ENIO_UNDERSTANDING_MAP + FOCUS_GATES formam um loop que de fato
    34	   redireciona o sistema conforme o Enio evolui? Ou é coleta que não fecha em ação? Desenhe o loop ideal
    35	   EPOS→sistema.

exec
/bin/bash -lc 'test -f ~/.claude/CLAUDE.md && echo OK || echo MISS; wc -c ~/.claude/CLAUDE.md 2>/dev/null; wc -c CLAUDE.md docs/CAPABILITY_REGISTRY.md .husky/pre-commit .claude/commands/end.md | tail -1' in /home/enio/egos
 succeeded in 0ms:
OK
16160 /home/enio/.claude/CLAUDE.md
319552 total

exec
/bin/bash -lc 'grep -R "SSOT_REGISTRY" -n .husky scripts | head -20; grep -n "EGOS_BACKBONE" docs/SSOT_REGISTRY.md docs/governance/MASTER_INDEX.md 2>/dev/null || true' in /home/enio/egos
 succeeded in 1348ms:
.husky/pre-commit:467:if echo "$STAGED" | grep -Eq '^\.guarani/|^\.windsurf/workflows/|^docs/SSOT_REGISTRY\.md$|^docs/CAPABILITY_REGISTRY\.md$|^docs/modules/CHATBOT_SSOT\.md$'; then
.husky/pre-commit:604:check_lines "docs/SSOT_REGISTRY.md" 200 || exit 1
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:73:  - `docs/modules/SSOT_REGISTRY.md` — ownership/freshness contracts
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:89:  - `SSOT_REGISTRY.md` — which capabilities are canonical vs local
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:210:| SSOT Registry | `egos/docs/modules/SSOT_REGISTRY.md` | A | egos (canonical) | ALL | `governance`, `ssot`, `registry` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:235:| **SSOT Registry v2** | `docs/modules/SSOT_REGISTRY.md` | A | egos | ALL | `governance`, `ssot`, `cross-repo` |
scripts/health-monitor.ts:169:      "SSOT_REGISTRY.md": {
scripts/egos-autoheal.ts:22: *   8. docs/modules/SSOT_REGISTRY.md       → ~/.egos/docs/modules/...       (lines 273-275 smoke)
scripts/egos-autoheal.ts:291:    "modules/SSOT_REGISTRY.md",
scripts/ssot-claim-check.ts:144:    ["docs/modules/CHATBOT_SSOT.md", "docs/CAPABILITY_REGISTRY.md", "docs/SSOT_REGISTRY.md"].forEach(f => {
scripts/governance-sync.sh:56:CANONICAL_DOCS="CAPABILITY_REGISTRY.md modules/SSOT_REGISTRY.md governance/ECOSYSTEM_CLASSIFICATION_REGISTRY.md modules/CHATBOT_SSOT.md"
scripts/egos-boot.sh:56:    "docs/SSOT_REGISTRY.md" \

codex
The patch is documentation-only, but it introduces maintainability regressions against explicit repository governance: a prohibited timestamped durable doc and additional tasks in an already over-limit TASKS.md file.

Full review comments:

- [P2] Move the timestamped brief out of durable docs — /home/enio/egos/docs/jobs/2026-06-09-fable5-mission-brief.md:1-1
  This adds a durable `docs/jobs/2026-06-09-...` file even though the repo rules explicitly prohibit timestamped docs outside archival locations. If this brief is intended to persist, it should be folded into an existing SSOT/roadmap; if it is only a historical handoff, place it under an archived location to avoid the doc-sprawl rule this patch is trying to manage.

- [P2] Avoid adding new tasks before shrinking TASKS.md — /home/enio/egos/TASKS.md:33-35
  These new Fable tasks are added to `TASKS.md` while the file is already at 998 lines and the same section says the hard limit is 600 with pre-commit blocking after the grace period. Until the archive/triage task is completed, adding more entries here makes the known blocker worse; keep this work in the new brief or roadmap and only add it back after the task file is below the enforced limit.
The patch is documentation-only, but it introduces maintainability regressions against explicit repository governance: a prohibited timestamped durable doc and additional tasks in an already over-limit TASKS.md file.

Full review comments:

- [P2] Move the timestamped brief out of durable docs — /home/enio/egos/docs/jobs/2026-06-09-fable5-mission-brief.md:1-1
  This adds a durable `docs/jobs/2026-06-09-...` file even though the repo rules explicitly prohibit timestamped docs outside archival locations. If this brief is intended to persist, it should be folded into an existing SSOT/roadmap; if it is only a historical handoff, place it under an archived location to avoid the doc-sprawl rule this patch is trying to manage.

- [P2] Avoid adding new tasks before shrinking TASKS.md — /home/enio/egos/TASKS.md:33-35
  These new Fable tasks are added to `TASKS.md` while the file is already at 998 lines and the same section says the hard limit is 600 with pre-commit blocking after the grace period. Until the archive/triage task is completed, adding more entries here makes the known blocker worse; keep this work in the new brief or roadmap and only add it back after the task file is below the enforced limit.
```
