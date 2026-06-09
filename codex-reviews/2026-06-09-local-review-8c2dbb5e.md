# Codex Local Review — 2026-06-09T12:34:47Z

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
session id: 019eac60-d479-7262-ac2f-f7ed961fbded
--------
user
changes against 'HEAD~3'
2026-06-09T12:34:48.607633Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T12:34:48.613225Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff --stat 5aecdd0db0808a52dd613f31f725a1e68771f587 && git diff --name-only 5aecdd0db0808a52dd613f31f725a1e68771f587' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                         |   6 +-
 TASKS.md                                      |  11 +++
 apps/egos-landing/public/timeline/rss         |   2 +-
 apps/egos-landing/public/timeline/rss.xml     |   2 +-
 docs/drafts/SOCIAL_LAUNCH_DRAFTS.md           | 117 ++++++++++++++++++++++++++
 docs/jobs/2026-06-08-doc-drift-verifier.json  |   6 +-
 docs/jobs/2026-06-08-pre-commit-pipeline.json |  40 +++++++++
 docs/knowledge/HARVEST.md                     |   9 +-
 docs/personal-os/ENIO_UNDERSTANDING_MAP.md    |   6 +-
 docs/strategy/APRESENTACAO_EGOS.md            |  60 +++++++++++++
 prompts/personal-os/SELF_MAPPING_INTERVIEW.md |  15 ++--
 11 files changed, 259 insertions(+), 15 deletions(-)
.claude/settings.json
TASKS.md
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/drafts/SOCIAL_LAUNCH_DRAFTS.md
docs/jobs/2026-06-08-doc-drift-verifier.json
docs/jobs/2026-06-08-pre-commit-pipeline.json
docs/knowledge/HARVEST.md
docs/personal-os/ENIO_UNDERSTANDING_MAP.md
docs/strategy/APRESENTACAO_EGOS.md
prompts/personal-os/SELF_MAPPING_INTERVIEW.md

exec
/bin/bash -lc 'git diff --unified=80 5aecdd0db0808a52dd613f31f725a1e68771f587' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.claude/settings.json b/.claude/settings.json
index 8b7be6e1..922bef13 100644
--- a/.claude/settings.json
+++ b/.claude/settings.json
@@ -1,103 +1,105 @@
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
-      "mcp__*",
       "Bash(bash ~/.claude/hooks/context-alarm.sh)",
       "Bash(echo \"EXIT: $?\")",
       "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
       "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
       "Bash(cat)",
       "Bash(bash scripts/check-skills-drift.sh --fix)",
       "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
       "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
-      "mcp__notebooklm-mcp__studio_delete"
+      "mcp__notebooklm-mcp__studio_delete",
+      "mcp__claude_ai_Supabase__execute_sql",
+      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
+      "mcp__claude_ai_Supabase__list_projects"
     ],
     "deny": [
       "Bash(rm -rf /:*)",
       "Bash(rm -rf ~:*)",
       "Bash(dd if=:*)",
       "Bash(mkfs:*)"
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
diff --git a/TASKS.md b/TASKS.md
index 85fc65f3..a44792e6 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -1,90 +1,101 @@
 # TASKS.md — EGOS Framework Core (SSOT)
 
 > **Version:** 5.4.0 | **Updated:** 2026-05-23 | **SLIM:** TASKS-SLIM-001 (1729L→slim).
 > **Policy:** tasks executáveis nos próximos 30 dias. Longo prazo → `docs/strategy/ROADMAP.md`.
 > **DUAL PURSUIT:** A (Intelink work-hours) | B (1ª venda EGOS after-hours)
 > **Pivot ref:** `docs/planning/gpecas-mvp-task-plan.md` | `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md`
 
 ---
 <!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
 
+## 🎯 LANÇAMENTO PÚBLICO v1 — Hotmart + Video + Divulgação (2026-06-09)
+
+> Enio decidiu parar de se esconder. Missão: finalizar, publicar, divulgar. NÃO criar ferramenta nova. NÃO abrir frente. Roteiro 2:30 pronto em docs/strategy/APRESENTACAO_EGOS.md PARTE E. Drafts de posts em docs/drafts/SOCIAL_LAUNCH_DRAFTS.md.
+
+- [ ] **HOTMART-LAUNCH-001** [P0] `prime` `gated:HITL-Enio` — Enio cria produto na Hotmart. Campos completos em APRESENTACAO_EGOS.md PARTE F checklist. Enio executa após gravar vídeo.
+- [ ] **VIDEO-RECORD-001** [P0] `enio` — Enio grava vídeo 2:30 com PARTE E do roteiro. Legenda sempre. Mostrar tela nas demos (GPT + Guard Brasil). Sem mencionar delegacia atual.
+- [ ] **GPT-CREATE-001** [P0] `enio` `gated:HITL` — Criar GPT personalizado no ChatGPT usando docs/strategy/gpt-tier0-package.md como guia. Usar GUARANI-ADAPTIVE-PROMPT-001 já redigido. Link do GPT vai nos posts e no Hotmart.
+- [ ] **MIGUEL-GOW-SEND-001** [P0] `prime` — Enviar HTML piloto MF Certificados para Miguel (dono da GOW). Arquivo: docs/presentations/mf-certificados-piloto.html. Incluir link NotebookLM (áudio overview pronto). Registrar envio aqui.
+- [ ] **SOCIAL-LAUNCH-001** [P0] `voz` `gated:HITL-Enio` — Publicar drafts de docs/drafts/SOCIAL_LAUNCH_DRAFTS.md nas 4 redes (X, Instagram, Facebook, LinkedIn) SOMENTE após Hotmart live. Sequência: X primeiro.
+- [/] **GUARD-BRASIL-AUDIT-001** [P1] `prime` — Consolidar achados do audit machine-wide (agente rodando). Garantir que egos.ia.br/tools serve Guard Brasil corretamente. Atualizar CAPABILITY_REGISTRY com status verificado.
+
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 > Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
 
 ## 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
 > Diagnóstico: A(B2C GPT/comunidade) e B(GOW WhatsApp/Hermes) = 2 produtos. GOW = experimento pequeno, NÃO plataforma. Memory: `project_gow_b2b_vs_b2c_diagnostic_2026-06-07`. Manter A intocado. Diagnostic Protocol = PAUSADO (rascunho interno). Janela NOVA p/ build (gateway é produção).
 - [/] **GOW-COMPLIANCE-META-PCMG-001** [P0] `redzone` 🔴 — pesquisa feita, aplicar no design da demo. PESQUISADO (web, jun/2026): COMPLIANT com condições. Agente de NEGÓCIO com tool calls = PERMITIDO (Meta lançou Business Agent global jun/2026). PCMG NÃO bloqueia (restrição é da organização/escopo, não do CPF). Red Zone: ZERO conteúdo investigativo/PII na demo. Evolution=só demo interna; produção=Cloud API oficial. Condições: escopo declarado + escalada humana + nº dedicado. SSOT: GOW_DEMO_RUNBOOK + HERMES_WHATSAPP_USECASE_MAP §5.
 - [/] **EVAL-COVERAGE-MEASURE-001** [P1] `provador` — medição feita; falta preencher os 57 golden ausentes. MEDIDO ao vivo: 80 CBCs, **9 com golden real**, 57 contrato-sem-teste; harness rodou **mcp-runner 88/93 pass**, bun test 78/82. Frase honesta GOW: "9 MCPs com golden (88/93), resto contrato-pendente; infra existe, gap é preenchimento". 4 falhas metaprompts (MP-PRICE/MP-MATERIAL falta red-zone) = fix simples futuro.
 > Anti-atropelo (deferidas, sprint GOW — não fazer antes da demo): Diagnostic Protocol = PAUSADO (docs/strategy/EGOS_DIAGNOSTIC_PROTOCOL.md, risco segurança/loop — Codex). 3 dashboards de observabilidade = deferido (dados existem: api_usage/mcp_audit/egos_agent_events; só após GOW validar). NotebookLM slides+vídeo do sistema = deferido. Distribuição egos-mcp/repo-por-cliente (Enio) = ideia registrada, pós-validação. Wire dos gaps #1(guard pré-LLM)/#2(evidence sempre)/#4(Hermes-L2) = só se GOW pagar.
 - [ ] **GOW-METAPROMPT-EVAL-FIX-001** [P2] `voz` — 4 golden cases falhando (MP-PRICE-001-005, MP-MATERIAL-EVAL-001 em packages/eval-runner/evals/metaprompts): falta seção "red zone" + nota anti-cópia-cega nesses .md. Fix simples → sobe a cobertura de prova (relevante p/ honestidade GOW).
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
 - [ ] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — auditoria Guarani #1: metaprompt v3 hardcoded inline em App.tsx (drift vs docs/drafts/free-artifact-egos-v0.md). Build Vite pré-compila do markdown canônico → src/data/metaprompt-source.ts. Evita drift SSOT.
 - [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
 - [/] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — Golden Example Tutor→Operacional REDIGIDO (gpt-tier0-package.md §2, bloco a anexar). Falta HITL + colar no artefato/GPT. Guarani #3.
 - [ ] **GIT-HISTORY-PII-DEEPSCAN-001** [P1] `guardiao`+`redzone` 🔴 — auditoria Guarani #5 (corrigida): egos NÃO tem arquivos OP-* no histórico (verificado), mas antes de QUALQUER abertura pública do egos, scan PROFUNDO de PII no conteúdo do histórico (não só paths). Repo público hoje = egos-governance (curado). NÃO filter-repo sem evidência + corte Enio (T0).
 
 ## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
 
 > Pricing R$4 (×2 progression) definido. WhatsApp = produto de entrada = acesso completo.
 > Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
 > PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
 
 - [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
 - [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md. **[Addendum 2026-06-08 — Enio:]** princípio-chave: MCP carrega tools/resources/prompts, mas só **regra-como-tool-verificável** se *impõe* na máquina do outro (prompt remoto pode ser ignorado). Encodar governança como tools pass/fail. Candidato pronto: `egos-curriculum` (envelopar `packages/curriculum-gate` no padrão mcp-bridge) = prova viva do padrão. Docs fortes → expor como `resources`; skills → `prompts`. Split público/interno via gate Guardião. HTML = vitrine humana, MCP = transporte de máquina. Próximo movimento adiado por corte Enio ("parar aqui por enquanto").
 - [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
 - [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
 - [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
 - [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
 - [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
 - [ ] **ONLINE-PRESENCE-CHECKLIST-001** [P1] `prime` `gated:HITL` — Criar checklist de comparecimento online diário: X.com (@anoineim) + Instagram (@egos.ia). Implementar hábito de 1 post/dia em cada canal. Ação derivada de atom A81 (travamento residual = falta de presença visual consistente, não medo financeiro). `docs/strategy/online-presence-checklist.md`. HITL: Enio valida conteúdo editorial antes de publicar nada.
 - [ ] **AIOX-CASE-STUDY-001** [P2] `curador` — Extrair insights do PDF AIOX (João/Hero Base) aplicáveis ao EGOS: modelo publisher vs estúdio, escola para crescer ecossistema (Hero Academy → EGOS Academy), UGC monetization analogy (audiência→plataforma paga→criador recebe%), qualidade primeiro. Salvar em `docs/research/aiox-case-study-insights.md`.
 
 ## 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
 
 > Contexto: engenharia reversa do erro Mycelium-3-jobs → regras de UI permanentes (FEITO).
 > Áreas sensíveis (Instagram download, vídeo de terceiro, WhatsApp) = LOCAL/PRIVADO/HITL por decisão do Enio.
 > Princípio cravado: **"O EGOS não precisa guardar pessoas; preserva ideias, conceitos, padrões, decisões."**
 
 **Pendências de publicação (HITL — do artefato grátis):**
 - [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram aberto "EGOS Framework" → ao existir, completar o link no artefato grátis (Parte 3). (Já existia; reforçada aqui como dependência do artefato.)
 - [ ] **COURSE-FREE-TIER-001** — reaberta (rascunho ≠ publicado; ver acima). Fecha só ao publicar.
 
 **Regras de UI (FEITO nesta sessão — follow-ups):**
 - [ ] **UI-RULES-AUDIT-001** [P1] `pixel`+`prime` — Passar todas as páginas públicas do egos-landing (home/timeline/showcase/transparencia/guard/grok/tools) pelo Publication Gate R-UI-005 (`docs/governance/UI_PRODUCT_RULES.md`). Listar violações de One Job Per Screen + plano de refatoração.
 - [ ] **UI-PUBLICATION-GATE-WIRE-001** [P1] `forja` — Tornar o Publication Gate EXECUTÁVEL (não doc-morto, R-SEC-003): checklist no `apps/*/deploy.sh` exigindo confirmação do gate + visual proof antes do rsync/publish. Espelha o Visual Proof Gate do pre-commit.
 
 **Ferramenta local de download (yt-dlp já resolve):**
 - [ ] **LOCAL-IGDL-DOC-001** [P2] `prime` `PERSONAL_LOCAL_TOOL`/`NO_PUBLIC_DEPLOY`/`NO_MONETIZATION` — Documentar uso do `yt-dlp` (já instalado) como alternativa local ao sssinstagram (sem anúncios, sem monetização). Diagnóstico curto em `docs/tools/local-video-download.md`: limites legais/éticos (só conteúdo próprio/autorizado, não burlar DRM/paywall, não redistribuir, não versionar cookies/sessão). NÃO construir ferramenta nova — yt-dlp basta (Karpathy mínimo). Premortem antes de qualquer wrapper.
 
 **Vídeo Bashar (transcrição interna):**
 - [ ] **BASHAR-VIDEO-STUDY-001** [P1] `prime`+`curador` `internal-only` — Transcrição do vídeo local (rodando whisper nesta sessão) → resumo + notas de aplicação ao EGOS em `docs/research/bashar-video/` (resumo + egos-application-notes, SANITIZADO). Vídeo de terceiro = referência inspiracional, NÃO copiar/publicar transcrição integral. Insumo p/ o agente de autodescoberta.
 
 **Agente EGOS de autodescoberta (Red Zone — limites psicológicos):**
 - [ ] **SELF-DISCOVERY-AGENT-SPEC-001** [P1] `redzone` `gated:HITL` — Especificar agente que conduz a pessoa a navegar em si mesma (mapear interesse/energia/padrões/direção). Spec + Red Zones + prompts em `docs/agents/self-discovery-agent*.md`. Limites DUROS: não diagnostica saúde mental, não substitui terapia, não manipula, não cria dependência, não afirma conhecer a pessoa melhor que ela; sempre separa fato/padrão/hipótese/pergunta/sugestão. Premortem obrigatório antes de implementar.
 - [ ] **GLOBAL-USER-PATTERN-001** [P2] `curador` `gated:HITL` — Plano de análise do padrão GLOBAL do usuário (commits + tasks + /start + /end + provenance + telemetria + Mycelium), não só por área. Classificar REAL/PATTERN/HYPOTHESIS/QUESTION/UNKNOWN. Sem psicologizar sem evidência. `docs/research/user-patterns/global-pattern-analysis-plan.md`. NÃO executar análise invasiva sem HITL.
 
 **Privacidade radical — ingestão WhatsApp (P0 política ANTES de qualquer ingest):**
 - [ ] **CONCEPT-ATOMIZATION-MODEL-001** [P1] `curador` `gated:WA-PRIVACY-POLICY-001` — Modelo de atomização: vivido → remove identificável → reconstrói conhecimento útil sem dado pessoal. `docs/architecture/concept-atoms.md`. Exemplo: "João me disse em Patos..." → "pessoa próxima relatou situação de confiança/frustração em contexto social".
 - [ ] **PROV-TELEM-MYCELIUM-MAP-001** [P2] `prime` — Mapa de como provenance/telemetria/Mycelium/start/end/pre-commit/commits entram na arquitetura de autodescoberta com privacidade (fonte/tipo/risco/tratamento/uso permitido/uso proibido/retenção/HITL). `docs/architecture/provenance-telemetry-mycelium-integration.md`.
 - [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
 
 ## 🎯 KYTE BENCHMARK & GAP-CLOSE — tarefa PRINCIPAL (Enio 2026-06-03)
 
 > **Contexto:** Enio usou o Kyte (IA-first, estilo de empresa que admira), achou pontos de melhora vs o que o EGOS já tem. Vídeo do interior do Kyte: `~/Videos/Screencasts/Screencast from 2026-06-03 13-04-53.mp4`. Objetivo: mapear o que Kyte tem (que ele tentou em gpecas/forja e não conseguiu), comparar com o nosso, achar o gap REAL (experiência? foco? expertise? design? organização?) e CONSTRUIR/melhorar com toda a estrutura de agentes (Banda + Council + Codex review). **Para mostrar a um contato de empresa IA-first que ele admira.**
 - [ ] **KYTE-PRESENT-001** [P1] `redzone` — Material p/ mostrar ao contato IA-first (Red Zone: copy/posicionamento → corte Enio).
 
 ## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
 - [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
 - [ ] **FE-BE-SYNC-GATE-001** [P1] `forja` — Implementar o gate que mede razão frontend/backend e, quando backend evolui >20% além do FE, GERA tasks priorizadas de frontend (não bloqueia). Regra em `CLAUDE.md §Convenções`. Definir métrica (ex: LOC/endpoints BE vs telas/componentes FE) + onde roda (pre-commit advisory ou `/start`).
 - [ ] **TOOLS-PAGE-COMPLETE-001** [P1] — `egos.ia.br/tools` completa: todas as tools disponíveis (BE+FE) p/ testar ao vivo, entrada correta, documentadas, com metaprompts. 🔄 PARCIAL 2026-06-04: hub `#/tools` LIVE (Guard Brasil + Item Intake + Mycelium). Falta: metaprompts inline por tool + docs "como usar". Próx: MP-ITEM-INTAKE-001 como aba no hub.
 - [ ] **GITHUB-AUDIT-FULL-001** [P2] — Timeline dos 40 repos GitHub (22 não-clonados localmente): `gh api` por repo. Parcial FEITO: `docs/audits/github-activity-timeline.md` (18 repos clonados).
 - [ ] **PUBLIC-REPO-DOCS-001** [P2] `curador` `redzone` — Publicar docs do EGOS Framework em repo PÚBLICO p/ agentes de IA navegarem (README "For AI Agents" → arquitetura → regras → metaprompts). Checklist de sanitização antes (sem segredo/VPS/PII). HITL.
 - [ ] **PROVENANCE-UNIFY-002** [P3] — Avaliar unificar os sistemas de proveniência fragmentados (`provenance.py` br-acc/omniview · `provenance.ts` kernel/guard-brasil · intelink hash-chain) num módulo `@egos/provenance` reusável. Só se valer (não over-eng).
 
 ## 🔄 DOCUMENTAR PROCESSOS → GERAR METAPROMPT (loop, Enio 2026-06-04, ordem)
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -1,88 +1,88 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
   <channel>
     <title>EGOS Timeline</title>
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
       <title><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes]]></title>
       <link>https://egos.ia.br/#/timeline/lab-onboarding-automation</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/lab-onboarding-automation</guid>
       <pubDate>Wed, 29 Apr 2026 19:44:29 GMT</pubDate>
       <description><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes
 Quando começamos a oferecer o EGOS Lab — um espaço colaborativo para parceiros experimentarem nossas ferramentas — percebemos que o onboarding manual seria um gargalo. Não queríamos terceirizar: precisávamos de um sistema que pudesse validar, a…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Sessão 2026-04-29 — Resumo técnico]]></title>
       <link>https://egos.ia.br/#/timeline/session-2026-04-29</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/session-2026-04-29</guid>
       <pubDate>Wed, 29 Apr 2026 19:40:27 GMT</pubDate>
       <description><![CDATA[---
 title: "Sessão 2026-04-29 — Resumo técnico"
 slug: session-2026-04-29
 lang: pt-br
 date: 2026-04-29
 tags: [session-summary, daily-work, ecosystem]
 status: published
 ---
 
 # Sessão — terça-feira, 28 de abril de 2026
 
 ## 📊 Snapshot
 
 - **Duração:** ~2h
 - **Commits:** 34
 - **Arquivos alterados:** 52
 -…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Duas janelas, uma mente: provando coordenação entre agentes via dois SHAs em dois repos]]></title>
       <link>https://egos.ia.br/#/timeline/two-windows-one-mind</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/two-windows-one-mind</guid>
       <pubDate>Sun, 26 Apr 2026 19:15:39 GMT</pubDate>
       <description><![CDATA[Duas janelas, uma mente
 No dia 2026-04-26, dois processos do mesmo modelo de IA (Claude Sonnet 4.6, OPUS MODE ativo) trabalhavam em paralelo, em janelas separadas, em repositórios git distintos:
 - Janela A — /home/enio/Projeto B (sistema interno, (domínio privado))- Janela B — /home/enio/egos (kerne…]]></description>
       <category>agent-coordination</category>
       <category>cross-repo</category>
       <category>opus-mode</category>
       <category>governance</category>
       <category>multi-agent</category>
     </item>
 
     <item>
       <title><![CDATA[Documentação que mente: como construímos um guarda que verifica tudo no pre-commit]]></title>
       <link>https://egos.ia.br/#/timeline/20260416-doc-drift-shield</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/20260416-doc-drift-shield</guid>
       <pubDate>Sun, 26 Apr 2026 19:14:58 GMT</pubDate>
       <description><![CDATA[Documentação que mente: como construímos um guarda que verifica tudo no pre-commit
 TL;DR: Toda documentação acumula mentiras com o tempo. Números de agents, contagens de capabilities, versões — escrevemos uma vez, o código muda, o doc fica desatualizado silenciosamente. Construímos um sistema que tr…]]></description>
       <category>governanca</category>
       <category>doc-drift</category>
       <category>pre-commit</category>
       <category>evidence-first</category>
       <category>manifest</category>
       <category>egos-kernel</category>
     </item>
 
     <item>
       <title><![CDATA[Construí uma plataforma de IA completa. Então descobri que estava na altitude errada.]]></title>
       <link>https://egos.ia.br/#/timeline/altitude-errada</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/altitude-errada</guid>
       <pubDate>Sun, 12 Apr 2026 14:29:48 GMT</pubDate>
       <description><![CDATA[TL;DR: Construi uma plataforma de IA com 45 agentes, 9 fases de pre-commit, e 4 camadas de validacao — para zero usuarios. Quando auditei com honestidade, encontrei um repositorio esquecido com 3 scripts Python que ja resolvia o problema real. Essa e a historia do gap entre a altitude da plataforma …]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Guard Brasil: 16 padroes de PII brasileiro em 4ms]]></title>
       <link>https://egos.ia.br/#/timeline/guard-brasil-pii-4ms</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/guard-brasil-pii-4ms</guid>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -1,88 +1,88 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
   <channel>
     <title>EGOS Timeline</title>
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
       <title><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes]]></title>
       <link>https://egos.ia.br/#/timeline/lab-onboarding-automation</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/lab-onboarding-automation</guid>
       <pubDate>Wed, 29 Apr 2026 19:44:29 GMT</pubDate>
       <description><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes
 Quando começamos a oferecer o EGOS Lab — um espaço colaborativo para parceiros experimentarem nossas ferramentas — percebemos que o onboarding manual seria um gargalo. Não queríamos terceirizar: precisávamos de um sistema que pudesse validar, a…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Sessão 2026-04-29 — Resumo técnico]]></title>
       <link>https://egos.ia.br/#/timeline/session-2026-04-29</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/session-2026-04-29</guid>
       <pubDate>Wed, 29 Apr 2026 19:40:27 GMT</pubDate>
       <description><![CDATA[---
 title: "Sessão 2026-04-29 — Resumo técnico"
 slug: session-2026-04-29
 lang: pt-br
 date: 2026-04-29
 tags: [session-summary, daily-work, ecosystem]
 status: published
 ---
 
 # Sessão — terça-feira, 28 de abril de 2026
 
 ## 📊 Snapshot
 
 - **Duração:** ~2h
 - **Commits:** 34
 - **Arquivos alterados:** 52
 -…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Duas janelas, uma mente: provando coordenação entre agentes via dois SHAs em dois repos]]></title>
       <link>https://egos.ia.br/#/timeline/two-windows-one-mind</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/two-windows-one-mind</guid>
       <pubDate>Sun, 26 Apr 2026 19:15:39 GMT</pubDate>
       <description><![CDATA[Duas janelas, uma mente
 No dia 2026-04-26, dois processos do mesmo modelo de IA (Claude Sonnet 4.6, OPUS MODE ativo) trabalhavam em paralelo, em janelas separadas, em repositórios git distintos:
 - Janela A — /home/enio/Projeto B (sistema interno, (domínio privado))- Janela B — /home/enio/egos (kerne…]]></description>
       <category>agent-coordination</category>
       <category>cross-repo</category>
       <category>opus-mode</category>
       <category>governance</category>
       <category>multi-agent</category>
     </item>
 
     <item>
       <title><![CDATA[Documentação que mente: como construímos um guarda que verifica tudo no pre-commit]]></title>
       <link>https://egos.ia.br/#/timeline/20260416-doc-drift-shield</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/20260416-doc-drift-shield</guid>
       <pubDate>Sun, 26 Apr 2026 19:14:58 GMT</pubDate>
       <description><![CDATA[Documentação que mente: como construímos um guarda que verifica tudo no pre-commit
 TL;DR: Toda documentação acumula mentiras com o tempo. Números de agents, contagens de capabilities, versões — escrevemos uma vez, o código muda, o doc fica desatualizado silenciosamente. Construímos um sistema que tr…]]></description>
       <category>governanca</category>
       <category>doc-drift</category>
       <category>pre-commit</category>
       <category>evidence-first</category>
       <category>manifest</category>
       <category>egos-kernel</category>
     </item>
 
     <item>
       <title><![CDATA[Construí uma plataforma de IA completa. Então descobri que estava na altitude errada.]]></title>
       <link>https://egos.ia.br/#/timeline/altitude-errada</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/altitude-errada</guid>
       <pubDate>Sun, 12 Apr 2026 14:29:48 GMT</pubDate>
       <description><![CDATA[TL;DR: Construi uma plataforma de IA com 45 agentes, 9 fases de pre-commit, e 4 camadas de validacao — para zero usuarios. Quando auditei com honestidade, encontrei um repositorio esquecido com 3 scripts Python que ja resolvia o problema real. Essa e a historia do gap entre a altitude da plataforma …]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Guard Brasil: 16 padroes de PII brasileiro em 4ms]]></title>
       <link>https://egos.ia.br/#/timeline/guard-brasil-pii-4ms</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/guard-brasil-pii-4ms</guid>
diff --git a/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md b/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md
new file mode 100644
index 00000000..1e9f11a0
--- /dev/null
+++ b/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md
@@ -0,0 +1,117 @@
+# EGOS — Drafts de Divulgação (v1 Hotmart)
+
+**Status:** DRAFT — HITL Enio antes de postar. Não publicar sem aprovação explícita.
+**Data:** 2026-06-09 | **Evento:** lançamento v1 Hotmart
+
+---
+
+## X.com (thread 5 tweets)
+
+**Tweet 1 — abertura**
+> Cansei de me esconder.
+>
+> Nos últimos meses construí um sistema de IA governada — método anti-alucinação, proteção de dados, 460+ commits abertos no GitHub.
+>
+> Chamei de EGOS. Agora estou abrindo para todo mundo.
+>
+> 🧵
+
+**Tweet 2 — o problema**
+> [2/5] O problema que ele resolve:
+>
+> Você usa ChatGPT no trabalho. A IA inventa com confiança. Você cola um dado de cliente sem pensar. Dá errado.
+>
+> O EGOS ensina a IA a separar CONFIRMADO de INFERIDO de HIPÓTESE — e protege seus dados antes de enviar.
+
+**Tweet 3 — o que existe hoje**
+> [3/5] O que já existe (REAL, pode testar agora):
+>
+> → GPT personalizado por área [link]
+> → Guard Brasil: mascara CPF/CNPJ antes de qualquer IA — egos.ia.br/tools
+> → Método aberto: github.com/enioxt/egos-governance
+> → Comunidade: t.me/ethikin
+
+**Tweet 4 — preço**
+> [4/5] Acesso vitalício. R$4 de entrada.
+>
+> Não é erro. É o preço do começo. Quem entra agora paga o preço da aposta, não do produto acabado. O preço sobe com o material.
+>
+> [link Hotmart]
+
+**Tweet 5 — pra quem**
+> [5/5] Pra quem é: advogado, médico, professor, servidor público, empreendedor, estudante — qualquer pessoa curiosa que quer usar IA melhor.
+>
+> Começa no Telegram (grátis): t.me/ethikin
+
+---
+
+## Instagram (caption)
+
+> Parei de me esconder.
+>
+> Construí um método para usar IA sem que ela invente resposta e sem que seus dados vazem.
+>
+> Chama EGOS. Vem de 16 anos investigando + anos construindo com IA + comunidade aberta.
+>
+> O que você recebe hoje:
+> → GPT configurado pra sua área
+> → Detector de dados sensíveis (grátis no site)
+> → Comunidade + método aberto
+>
+> Acesso: R$4. Vitalício. Preço do começo, não do produto acabado.
+>
+> Link na bio. Comunidade: t.me/ethikin
+>
+> Filosofia, tecnologia, investigação — junto e sem esconder.
+
+---
+
+## LinkedIn
+
+> Nos últimos meses construí um sistema de IA governada: anti-alucinação, proteção de dados, código aberto, 460+ commits verificáveis no GitHub.
+>
+> Agora estou publicando a primeira versão pública.
+>
+> Chama EGOS. O método central: a IA é obrigada a separar CONFIRMADO de INFERIDO de HIPÓTESE antes de qualquer resposta.
+>
+> Para profissionais que usam IA no trabalho e querem usar com mais clareza e segurança.
+>
+> O que já está disponível:
+> → GPT personalizado por área
+> → Guard Brasil: mascara PII antes de qualquer IA — egos.ia.br/tools
+> → Código e método abertos: github.com/enioxt/egos-governance
+> → Comunidade: t.me/ethikin
+>
+> Acesso vitalício por R$4. Preço sobe com o material.
+>
+> [link Hotmart]
+
+---
+
+## Facebook
+
+> Depois de muito tempo construindo em silêncio, resolvi abrir o EGOS para todo mundo.
+>
+> É um método + ferramentas + comunidade para usar inteligência artificial (ChatGPT, Gemini, Claude) com mais clareza e segurança.
+>
+> A IA é poderosa. Mas ela inventa, ela confunde fato com achismo, e se você não tiver cuidado, pode expor dados que não devia.
+>
+> O EGOS resolve isso com um método simples, ferramentas prontas e um grupo onde a gente aprende e constrói junto.
+>
+> Acesso vitalício por R$4. Comunidade gratuita no Telegram: t.me/ethikin
+>
+> [link Hotmart]
+
+---
+
+## Tom e regras de postagem
+
+- Sincero, direto, humano — sem guru, sem hype
+- Sem promessa de riqueza, lucro, renda passiva
+- Sem "único no Brasil", "100%", "garanto"
+- Pode mencionar cripto como experiência pessoal, nunca como recomendação
+- Polícia Civil: experiência geral, sem delegacia, sem operação, sem casos
+- Publicar só após Hotmart estar live com o produto
+- Sequência recomendada: X → Instagram → LinkedIn → Facebook
+
+*SSOT: docs/strategy/APRESENTACAO_EGOS.md | Voz: voz-agent (HITL obrigatório)*
diff --git a/docs/jobs/2026-06-08-doc-drift-verifier.json b/docs/jobs/2026-06-08-doc-drift-verifier.json
index 51d2f152..84e0ca95 100644
--- a/docs/jobs/2026-06-08-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-08-doc-drift-verifier.json
@@ -1,206 +1,206 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-08T17:02:56.838Z",
+  "verified_at": "2026-06-08T19:52:45.610Z",
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
       "current_value": "62",
       "tolerance": "±5",
       "drift_abs": 1,
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
       "current_value": "37",
       "tolerance": "±2",
       "drift_abs": 1,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
     {
       "id": "commits_30d_all_repos",
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1248",
+      "current_value": "1260",
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
-      "current_value": "97",
+      "current_value": "100",
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
       "current_value": "170",
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
diff --git a/docs/jobs/2026-06-08-pre-commit-pipeline.json b/docs/jobs/2026-06-08-pre-commit-pipeline.json
index 3f671b13..793779a7 100644
--- a/docs/jobs/2026-06-08-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-08-pre-commit-pipeline.json
@@ -1,82 +1,122 @@
 [
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T11:30:36.661Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=2 sha=9fc923de",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T12:10:23.346Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=1 sha=a4b92102",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T12:21:46.329Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=4 sha=b768190c",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T16:20:38.024Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=2 sha=9d535a7d",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:02:58.395Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:feat files=6 sha=07faf963",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:03:21.138Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:chore files=1 sha=eaec4f97",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:07:35.542Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:chore files=1 sha=4e22adde",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:08:02.087Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:feat files=1 sha=d592ae02",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:41:20.843Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=3 sha=869e8329",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:51:15.348Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:chore files=2 sha=f60954ff",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:45:35.773Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=10 sha=88201591",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:52:46.190Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=d8411241",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:01:10.597Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=7d6b09c6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:04:30.180Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=5 sha=b3d62d99",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:05:50.745Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=f9369018",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 12bd4752..8438dcce 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,85 +1,90 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
+> **VERSION:** 5.17.0 | **UPDATED:** 2026-06-09 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+> **Latest:** P174 — Guard Brasil: auditoria machine-wide (6 pacotes, 3 repos, PRONTO flagship)
+
+---
+
+**P174 — Guard Brasil: estado real após auditoria machine-wide (2026-06-09)**
+`@egosbr/guard-brasil` v0.2.3 — 6 implementações em 3 repos. Core TS (20/20 testes), REST API `guard.egos.ia.br` (prod Hetzner), MCP Server v0.2.0 (SDK oficial), Python SDK (funcional, falta PyPI), LangChain wrapper (CONCEPT/esqueleto), frontend legado `_archived/`. 12 padrões PII BR + ATRiAN + Evidence Chain SHA-256. Pronto para divulgação como FLAGSHIP. Gaps: PyPI publish (2h), OpenAPI docs (3h), consolidar frontend, LangChain completo. CAPABILITY_REGISTRY §1.
 
 ---
 
 ## P173 — 2026-06-08: Fluxo unificado HTML + NotebookLM por cliente
 
 **Trigger:** Sessão GOW/MF Certificados — necessidade de apresentar proposta de piloto ao owner.
 
 **Padrão descoberto:** R-DOC-AUDIENCE-001 (README=máquina, HTML=humano) tem uma extensão natural: NotebookLM como amplificador de inteligência. O HTML é o shell de navegação (offline, sem login, compartilhável), o NotebookLM gera os artefatos derivados (áudio overview PT-BR para ouvir no carro, slides para reunião, briefing para o tomador de decisão).
 
 **Arquitetura:**
 1. `.md` fonte (AI↔AI) → NotebookLM via MCP (`source_add`)
 2. NotebookLM gera: áudio overview 5-10min PT-BR / slides / briefing executivo
 3. HTML atualizado com seção "Materiais" linkando artefatos
 4. GitHub per client: HTML standalone + README.md como fonte AI
 
 **Achado crítico:** HTML não é formato aceito como `source_type=file` no NotebookLM MCP. Alternativa: usar `source_type=text` com conteúdo extraído. Markdown/PDF/TXT são formatos válidos.
 
 **Capacidades criadas nesta sessão:**
 - §115: HTML por cliente (padrão EGOS)
 - §116: Pseudonimização CPF no gateway (Option A)
 - §117: Fluxo unificado HTML + NotebookLM
 
 ---
 
 ## P172 — 2026-06-08: Banda Cognitiva — preço no vídeo e HTML por cliente
 
 **Trigger:** Decisão de pricing (falar R$4 no vídeo com filosofia) e decisão de HTML per client para o GOW.
 
 **Síntese Maestro (preço):** Falar com filosofia = APROVADO, mas articulação simplificada: "começo em R$4 porque é o que vale hoje. Conforme a comunidade cresce, o preço sobe." NÃO criar critério rígido público para subida de preço (gera gaming da métrica). Vídeo vai envelhecer — é o vídeo de LANÇAMENTO, não eterno.
 
 **Síntese Maestro (HTML per client):** APROVADO — separar em duas trilhas: (A) HTML por cliente agora (MF Certificados, base HERMES_GOW_guia.html), (B) busca global + interconexão = sessão separada. HTML responde 3 perguntas: o que existe / o que está sendo construído / qual o próximo passo para o cliente.
 
 ---
 
 ## P171 — 2026-06-08: Guard Brasil — escopo correto vs pseudonimização
 
 **Trigger:** Ao arquitetar o piloto MF Certificados, propus guard_scan_pii para o fluxo de certificados digitais. Enio corrigiu.
 
 **Regra emergente:** Guard Brasil tem escopo específico — NÃO usar em fluxos onde PII é dado de negócio obrigatório. CPF em certificação digital DEVE fluir até SERPRO/Receita. Guard Brasil é para outputs/logs/pre-commit scanner. O padrão correto para fluxos de negócio com PII obrigatório é pseudonimização no gateway.
 
 **LGPD + LLM externo:** enviar CPF ao Anthropic/Google é transferência internacional (Art. 33-36 LGPD). Risco real, enforcement ANPD baixo hoje, mas GDPR para clientes EU é muito mais duro. Pseudonimização mitiga na arquitetura (dado real nunca vai ao LLM).
 
 **Memória salva:** `memory/feedback_guard_brasil_scope.md`
 
 ---
 
 ## P170 — 2026-06-07: Mapa de Consumo de Tokens LLM (OpenRouter/Gemini)
 
 **Trigger:** Contexto alarm mostrou $77.30 — usuário perguntou onde estamos gastando tanto com Gemini.
 
 **Achado crítico:** O $77.30 era custo da **sessão Claude Code** (Opus model, 429 msgs), NÃO do sistema EGOS.
 
 ### Superfícies LLM ativas no EGOS (2026-06-07)
 
 | Superfície | Trigger | Modelo | Custo estimado |
 |-----------|---------|--------|---------------|
 | Gateway chatbot (WhatsApp/TG/web) | Por mensagem de usuário | gemini-2.0-flash-001 | ~$0.0001/msg |
 | HQ codex-review | Por PR review solicitado | gemini-2.0-flash-001 | ~$0.001/review |
 | HQ chat/banda | Por chamada manual | gemini-2.0-flash-001 | ~$0.0001/call |
 | x-opportunity-alert | VPS cron 0 */2 * * * (2h) | gemini-2.0-flash-001 | ~$0.001-0.01/run |
 | x-reply-bot | VPS cron 0 * * * * (1h) | gemini-2.0-flash-001 | ~$0.001/run |
 | llm-model-monitor | A cada 6h (polling /models) | N/A (API pública) | $0 (sem chat) |
 | Hermes cron jobs | 2 semanais (Mon+Sun) | claude-sonnet-4-6 via Anthropic | custo Anthropic API |
 | Scripts manuais | On-demand | gemini-2.0-flash-001 | ad hoc |
 
 **Dados reais Supabase `api_usage`:**
 - Total: 8 calls | $0.0145 USD | Google gemini-2.5-flash
 - Última entrada: 2026-06-03 — logging incompleto ou VPS scripts não rodando
 
 **Hermes default model:** `claude-sonnet-4-6` via Anthropic API — cron runners usam Anthropic, não OpenRouter.
 
 ### Cadeia de fallback implementada (llm-provider.ts)
 
 1. **Google AI Studio (free):** gemini-2.5-flash (500 req/day) → gemma-4-31b-it (1500 req/day) — GRATUITO
 2. **OpenRouter (pago):** gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
 
 **Custo projetado mensal** (uso moderado — gateway 50 msgs/dia + VPS crons):
 - Google free tier absorve ~1500 req/dia → OpenRouter só entra no overflow
 - Estimativa conservadora: < $5/mês se free tier estiver funcionando
 
diff --git a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
index fc8abf33..87f0a4d4 100644
--- a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
+++ b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
@@ -1,118 +1,122 @@
 ---
 name: Enio Understanding Map — domínios por nível de delegação
 description: Mapa que diz a todo agente o que Enio domina, o que está aprendendo, o que IA pode executar mas DEVE explicar, e o que NUNCA pode ser terceirizado. SSOT.
 type: governance
 version: 1.1
 status: active
 created: 2026-05-08
-last_update: 2026-05-08 (B1+B2 entrevista — atoms A1-A52)
+last_update: 2026-06-08 (EPOS B2-Q1/Q2 retomada — flow zones + mecanismo produção∞/captura-adiada)
 ---
 
 # Enio Understanding Map
 
 > **Uso:** todo agente lê este arquivo no `/start` (Layer 0) e respeita os níveis ao decidir autonomia.
 > **Princípio governante:** `UNDERSTANDING_PROTOCOL.md` (Doutrina Karpathy)
 > **Atoms backing:** `data/personal-os/private/enio_profile_atoms.jsonl` (54 atoms validados)
 
 ---
 
 ## 🟢 Domínios que Enio JÁ entende profundamente
 
 Agente pode usar linguagem técnica densa, pular explicações básicas, ir direto à decisão.
 
 **De experiência prévia:**
 - Investigação e cadeias de evidência (16 anos PCMG — **policial EM ATIVIDADE, não ex**)
 - Crypto/Web3 fundamentos (desde 2017, prática real)
 - Uso prático de IA por construção (não teoria)
 - Intuição de governança ética (ATRiAN, ETHIK)
 - Raciocínio de sistemas/processos (link prediction, mapeamento)
 - Educação de comunidade (tradução técnica → leigo)
 - Contexto institucional/legal/social brasileiro (LGPD, ANPD, polícia)
 
 **Validado pela entrevista B1+B2 (2026-05-08):**
 - **Escuta ativa + perguntas que outros não fazem** (A26) — capacidade rara, monetizável
 - **Abstrai pessoa → ideia/conceito** (A27) — "menos CPF, mais ideia". Diferencial em vendas/Council/conflito
 - **Visão investigativa de necessidades** (A37) — vê dor antes de articulada. Estratégia atual: catálogo > cobrança imediata. Comercializar quando ≥3 cases publicados OU ≥5 clientes
 - **Modelo de venda Discovery+Build** (A40) — cliente traz problema, ele arquiteta. Lucas/pixelart provou. NÃO é Pitch+Sell
 - **Self-awareness operacional alta** (A48) — nomeia próprios bloqueios, valida protocolos contra si mesmo
 
+**Validado pela retomada EPOS B2 (2026-06-08):**
+- **Flow zones (B2-Q1):** flui em (1) CONVERSAR (assunto interessante → horas) e (2) RESOLVER/CONSTRUIR/PESQUISAR — próprios e dos outros. Auto-rótulo "resolvedor de problemas, mesmo que tenha que criar/amplificar eles" (Jordan). → agente pode usar isso como combustível, mas vigiar o lado dispersor (criar problema pra ter o que resolver).
+- **Mecanismo produção∞/captura-adiada (B2-Q1+Q2):** o que ADIA é RECEBER/capturar valor (dinheiro fora da polícia). Explica 460 commits/R$0 + dispersão 🔴. Quando ele hesitar em cobrar/fechar → é o nó de receber (🔴 abaixo), não falta de valor. Está em movimento (Miguel/GOW/Hotmart = rampa). 🔒 protegido. Ver `memory/user_enio_flow_zones_capture_block_2026-06-08.md`.
+
 **Validado pela clarificação 2026-05-20 (atom A78 — ver IDENTITY_AND_METHOD.md):**
 - **Habilidade central canonical:** transformar caos informacional em clareza estratégica aplicável (não é pivot — é nome para o padrão que sempre existiu)
 - **Método-mãe canonical:** Espiral de Escuta — escuta + maiêutica + síntese + needs[]/next_actions[] + audit. Aplicação transversal (comércio/investigação/interpessoal/replicação)
 - **Arquitetura de sentido:** união leitura humana + investigação + sistemas + IA — interseção rara, dificilmente terceirizada
 - **NÃO sou:** dev full-stack genérico, terapeuta, trader full-time, guru, site builder for hire, vendedor de IA genérica
 - **SOU:** investigador-arquiteto que aplica método Espiral em contextos diferentes
 
 ---
 
 ## 🟡 Domínios em desenvolvimento ativo
 
 Agente DEVE explicar enquanto faz. Cada artefato vira oportunidade de aprendizado.
 
 - Arquitetura de programação (Bun/TS, packages, monorepo)
 - Pipelines de automação (cron, hooks, dispatch)
 - Agentes de IA (orquestração, runner, event-bus)
 - RAG e sistemas de retrieval (pgvector, hybrid search, RRF)
 - Integração MCP (Model Context Protocol)
 - Design de frontend/produto (UX de conversão, não polish)
 - Monetização SaaS (pricing tiers, RLS, isolation)
 - Deployment técnico (Caddy, Docker, VPS)
 
 **Regra:** se agente toca um desses, **comentar a decisão arquitetural** (não o código), e oferecer 1 leitura curta opcional ao fim.
 
 ---
 
 ## 🟠 Domínios que IA PODE executar mas DEVE explicar
 
 Velocidade aceita, mas com Understanding Summary obrigatório no final.
 
 - Boilerplate (componentes, schemas, types)
 - Refactors mecânicos (rename, extract, dedup)
 - Testes (unit, integration, smoke)
 - Scaffolds de documentação
 - Implementação de UI a partir de design definido
 - Geração de schema (DB, JSON, OpenAPI)
 - Configuração de deploy (Dockerfile, Caddyfile, vite.config)
 
 **Regra:** agente pode fazer em paralelo, mas no commit body explica **o que mudou e por quê** em 3 linhas máx, em PT-BR.
 
 ---
 
 ## 🔴 RED ZONE — Decisões que Enio DEVE possuir pessoalmente
 
 Agente **NUNCA** decide sozinho. Sempre apresenta opções ranqueadas + recomendação + tradeoff, e **pausa para confirmação explícita**.
 
 **Decisões estruturais (originais):**
 - **Propósito do EGOS** (qual problema central resolve)
 - **Direção de produto** (Central EGOS Solo vs Pro vs Enterprise; Lab vs Site)
 - **Limites éticos** (o que Guard Brasil bloqueia; o que ATRiAN refuta)
 - **Modelo de confiança com usuário** (transparência, opt-in, anonimização)
 - **Promessa pública** (toda copy que vai pro ar — landing, X, artigo, e-mail)
 - **Lógica de pricing** (faixas, contratos, fidelidade)
 - **Stance de governança de dados** (LGPD, retention, deletion)
 - **Decisões finais de arquitetura** (fork vs plugin, monolito vs micro)
 - **Decisões de segurança** (rotação de keys, exposure, scope)
 - **Contexto institucional/policial** (qualquer coisa que tangencie PCMG, intelink em produção pública)
 - **Monetização vs servidor ATIVO** (2026-05-31) — Enio é policial em atividade. Qualquer modelo comercial (perito-for-hire privado, sócio-gerente, comércio) tem trava de COI + estatuto do servidor → SEMPRE apresentar como flag a verificar, nunca assumir liberado. Vetores mais seguros: IP/produto, magistério/curso, governança/advisory. Ver `CAREER_FIT_STUDY.md §0`.
 - **Casos de uso médico/jurídico/financeiro** (sempre HITL)
 
 **Pessoa-fronteira (entrevista B1+B2 2026-05-08):**
 - **Saúde física/mental** (A42) — agente NÃO comenta a menos que Enio traga primeiro. Não sugere mudança de prática. Não psicologiza humor
 - **Família — versão calibrada (A52)**:
   - Filho/esposa: agente PODE referenciar quando Enio travar em cobrança/exposição (amplificação ativa baseada no que Enio disse na sessão atual)
   - Pais/avós (A43 escassez): contexto silencioso permanente. Agente PODE chamar atenção: *"isso ecoa o padrão herdado — está reproduzindo ou quebrando?"*. Calibrado, não diagnóstico, não terapia
   - NUNCA pergunta "como tá X" sobre familiar específico sem provocação
   - Bernardo + amigos = rede pessoal, NÃO família — categoria normal
 - **Rótulos clínicos** (A41) — proibido nomear ADHD, gifted, depressão, autismo, mesmo se Enio mencionar traços
 - **Linguagem de escassez** (A7) — agente refuta automaticamente, devolve framing de capacidade verificável. Causa: A20 (medo do upside) + A43 (código biológico herdado)
 - **Filosofia "tudo tem propósito"** (A17) — respeita retroativamente, NÃO aceita como justificativa pra adiar corte de side project ativo
 
 **Estratégia comercial em fase atual:**
 - **Bernardo 50%** (A51) — não negociar split antes de 3-5 clientes pagos. NÃO é prejuízo, é CAPEX de tração
 
 ---
 
 ## §Como agente usa este mapa
 
 Em qualquer turno:
 
diff --git a/docs/strategy/APRESENTACAO_EGOS.md b/docs/strategy/APRESENTACAO_EGOS.md
index 3a6cf83f..0d4d6785 100644
--- a/docs/strategy/APRESENTACAO_EGOS.md
+++ b/docs/strategy/APRESENTACAO_EGOS.md
@@ -60,82 +60,142 @@ Cada área tem necessidades próprias. A ideia é ir construindo ferramentas esp
 - **Comece agora, de graça:** o artefato e o checklist estão em https://egos.ia.br
 
 ---
 
 ## PARTE B — ROTEIRO DE VÍDEO (~8–10 min)
 
 > Tom: você (Enio) apresentando o EGOS, de gente pra gente. Calmo, claro, sem hype, sem jargão. Lidera pelo trabalho/método, não pela biografia. Sem falar preço.
 
 **[0:00–0:40] Abertura — o gancho**
 "Você já usou o ChatGPT pra te ajudar no trabalho e desconfiou se a resposta tava certa? Ou ficou com medo de colar um dado de cliente ali? Esse é o problema que o EGOS resolve. Em poucos minutos eu te mostro como usar IA com método — sem ela te enganar e sem vazar seus dados."
 
 **[0:40–2:00] O que é o EGOS (simples)**
 Explique as 3 partes: método + ferramentas prontas + comunidade. Frase-chave: "A IA ajuda. O EGOS organiza." Diga que tudo que mostra hoje já existe e parte é gratuito.
 
 **[2:00–4:00] O básico / metodologia**
 Mostre na tela os 4 passos (classificar fato/achismo, proteger dados, conferir antes de confiar, deixar rastro). Dê um exemplo real: "Pedi pra IA um resumo; ela inventou uma lei que não existe. Com o método, ela teria marcado 'isso é suposição, confira'."
 
 **[4:00–6:00] Demonstração — o artefato + a ferramenta**
 Mostre ao vivo: cola o metaprompt, ele pergunta "qual sua área?", você responde, e vira um assistente. Mostre o detector de dados sensíveis mascarando um CPF fictício. Mostre o conversor foto→planilha (se couber).
 
 **[6:00–7:30] A comunidade e como ela cresce**
 Explique o grupo: como a gente compartilha ferramentas e aprendizados, como o conteúdo cresce, como cada área vai ganhando ferramentas próprias. Fale do espaço de criação e monetização — quem constrói pode oferecer e participar.
 
 **[7:30–8:30] Como você usa na SUA área**
 Passe rápido pelos exemplos (advogado, médico, contador, comércio, professor). "Seja qual for seu trabalho, o método é o mesmo — muda só o que você coloca dentro."
 
 **[8:30–9:30] Convite (CTA)**
 "Entra no nosso Telegram — t.me/ethikin — é aberto e gratuito. Lá a gente troca, aprende e constrói junto. E o material inicial tá em egos.ia.br pra você começar hoje." (Mostrar o link e o ícone do grupo na tela.)
 
 **Notas de gravação:** legenda sempre (muita gente assiste sem som). Cortes curtos. Mostrar a tela nas demos. Nada de "garanto/100%/único". Sem falar valor.
 
 ---
 ---
 
 ## PARTE C — ROTEIRO PERSONALIZADO (gravação 2026-06-08)
 
 > Tom: humano, honesto, sem hype/ostentação, sem promessa de riqueza/atalho/independência financeira, sem previsão de cripto, sem aconselhamento financeiro. Lidera pelo trabalho/método; credencial discreta, sem carteirada. NÃO dizer delegacia atual. Legenda sempre.
 
 **[1 · Abertura — 0:00–0:45]**
 "Oi, eu sou o Enio. Nos últimos 16 anos trabalhei como investigador da Polícia Civil — passei por homicídios consumados e tentados, roubos, furtos, investigações financeiras, e por praticamente todo tipo de delegacia, inclusive a área de inteligência. Não vou falar onde estou hoje, e não é disso que esse vídeo trata. Trago isso só pra você entender de onde vem meu jeito de pensar: investigar é separar o que é fato do que é história. E é exatamente isso que eu quero te ajudar a fazer com a inteligência artificial."
 
 **[2 · Cripto / trajetória — 0:45–2:00]**
 "Desde 2017 eu estudo e invisto em cripto. Passei por milhares de projetos, vivi as comunidades no Discord, no Telegram, no X, peguei vários ciclos — acertei muito e errei também. Aprendi na prática. E aprendi uma coisa simples sobre o Bitcoin: é uma forma de guardar valor na era digital, e te dá a liberdade de ter a sua própria carteira e transacionar com quem você quiser, no mundo inteiro. Sem promessa, sem previsão — só o que eu entendi vivendo isso. A responsabilidade é sempre individual."
 
 **[3 · Por que estou criando / o problema / o diferencial — 2:00–3:45]**
 "Hoje a IA está na mão de todo mundo — ChatGPT, Claude, Gemini, Grok. Mas a maioria usa no escuro: a IA inventa resposta com confiança, mistura fato com achismo, e se você colar um dado de cliente ali, pode expor o que não devia. Eu juntei duas coisas que vivo — investigação e tecnologia — pra criar um jeito de usar IA com método. É isso que eu chamo de EGOS.
 E olha, eu vou ser direto sobre o que me diferencia, sem precisar puxar credencial: a maioria por aí **ensina a usar** IA. Eu **construí** IA — em escala real, com dado público em grande volume, LGPD no núcleo, tudo aberto. Não precisa acreditar em mim: está no meu GitHub, dá pra você inspecionar. A diferença não é eu falar bonito sobre IA — é eu te mostrar o que eu fiz e como eu uso. A prova vem antes da promessa."
 
 **[4 · O que é o EGOS / método — 3:30–5:00]**
 "O EGOS não é mais um amontoado de PDF. O material aqui é o código, as regras, o entendimento, a clareza — e principalmente as conversas, as trocas, a comunidade. A ideia é a gente colaborar pra você melhorar de verdade sua literacia em tecnologia, especialmente em IA.
 O método é simples: a gente ensina a IA a falar como um investigador. Ela não pode te dar uma resposta solta — é obrigada a classificar antes de entregar: **CONFIRMADO** (tem prova em documento), **INFERIDO** (é dedução lógica), **HIPÓTESE** (é só possibilidade, confira). Isso muda o jogo: a IA para de tentar te convencer e passa a te mostrar as pistas.
 Eu chamo isso de **Triplo Filtro**: (1) **Dado seguro** — o que é sensível não sai da sua máquina; (2) **Grau de certeza** — a IA separa fato de achismo; (3) **Revisão humana** — você decide. A IA propõe, a pessoa dispõe."
 
 **[5 · Ferramentas grátis (o GPT é o herói) — 5:00–6:30]**
 "E não é promessa pro futuro — já tem coisa pronta pra usar hoje, de graça. A melhor de todas é o nosso GPT personalizado. Ele não te joga um prompt gigante pra você se virar: quando você abre, ele entra em **modo tutor** — te faz uma pergunta simples por vez, te ouve, e propõe a configuração exata pra sua rotina. Você só confirma. É a IA se configurando pro seu trabalho.
 Tem também o **Guard Brasil** no site. Funciona assim: você cola um texto com dados de um cliente — nome, CPF, telefone. Ali mesmo, na sua tela, o sistema troca tudo por etiquetas seguras tipo `[PESSOA_1]`, `[CPF_1]`. É esse texto limpo que vai pra IA. Quando a resposta volta, ele recoloca os dados reais na sua tela. A IA trabalha, mas os dados reais nunca saíram do seu computador.
 Comece pelo GPT — é o atalho mais honesto que eu tenho pra te entregar."
 
 **[6 · Pra quem é / pra quem não é — 6:30–7:45]**
 "Vou ser honesto: isso não é pra todo mundo. Você aproveita mais se já tem alguma coisa do seu trabalho digitalizada, se usa o computador no dia a dia, se tem curiosidade. Mas se você ainda usa só o ChatGPT pra pesquisar, de forma básica — tudo bem, a gente te ajuda a evoluir: usar um GPT personalizado, decidir se vale assinar um modelo melhor, aprender a fazer perguntas melhores. O que eu não quero é gente esperando milagre. Aqui é método e prática."
 
 **[7 · Comunidade + criação/monetização — 7:45–9:00]**
 "O coração disso é a comunidade. A gente compartilha ferramentas e aprendizados, o conteúdo cresce com o tempo, e cada área vai ganhando ferramenta própria — construída com quem vive o problema. E tem espaço pra quem quer criar: se você desenvolve algo útil, pode oferecer dentro da plataforma, e projetos que avançam podem ter participação proporcional à colaboração. Não é promessa de renda — é espaço pra construir junto."
 
 **[8 · Preço / acesso — 9:00–9:45]**
 "O acesso é vitalício. O preço de entrada é 4 reais. Não é erro de digitação, é uma escolha consciente: o EGOS está no começo, e o preço reflete isso. À medida que o material cresce, a comunidade valida, e o método prova mais — o preço sobe. Quem entra agora paga o preço da aposta, não do produto acabado. Isso é justo dos dois lados: você assume a incerteza do começo, e entra por menos."
 
 **[9 · Convite — 9:45–10:30]**
 "Se isso fez sentido pra você, entra no nosso Telegram — o link é **t.me/ethikin**, que vem de inteligência ética e comunidade. É aberto, é gratuito, e é lá que a gente conversa e constrói junto. E começa pelo GPT e pelo material em egos.ia.br. Não precisa decidir nada agora. Dá uma olhada, testa, e vê se faz sentido pra você."
 
 > Gravação: legenda sempre · cortes curtos · mostrar a tela nas demos (GPT + detector) · nada de "garanto/100%/único/fique rico" · sem dizer delegacia atual · sem previsão de preço de cripto.
 
 ---
 
 ## PARTE D — Hotmart "Sobre o que é o seu produto?" (colar, ≤500 chars)
 
 > O EGOS é uma comunidade e um método para usar inteligência artificial (ChatGPT, Claude, Gemini) com mais clareza e segurança — sem que ela invente respostas ou exponha seus dados. Acesso vitalício a ferramentas prontas, um GPT personalizado, regras, materiais e, principalmente, troca com a comunidade. Para profissionais e curiosos que querem evoluir sua literacia em IA, na prática. Não é promessa de renda — é método, colaboração e aprendizado contínuo.
 
 (Preço entra no campo de preço do Hotmart, não no "Sobre": começa em R$4, progressão ×2 — o fundador decide quando sobe; não anunciar tempo/quantidade.)
 
+---
+
+## PARTE E — ROTEIRO 2:30 (versão mínima publicável — 2026-06-09)
+
+> 150 segundos · ~300 palavras · Enio grava com legenda · sem hype · sem delegacia atual · sem previsão cripto · mostrar tela nas demos
+
+**[0:00–0:30] — Quem sou + por que isso importa**
+"Entrei com 20 anos na Polícia Civil de Minas Gerais. Rodei praticamente todas as delegacias — centenas de homicídios, investigações financeiras. Isso me ensinou uma coisa: separar o que é fato do que é versão. É exatamente o que o EGOS faz com inteligência artificial."
+
+**[0:30–1:00] — De onde o EGOS nasceu**
+"O EGOS começou quando eu instalei o Cursor — minha primeira IDE — e tentei criar um bot no Telegram pra redimensionar imagens. Quase desisti. Achei que não era capaz. Mas entendi algo que mudou minha visão: uma IDE não é só pra desenvolvedor. É pra qualquer pessoa que tem dados — pessoais, do trabalho, de estudo — e quer processá-los com os melhores modelos de IA do mundo."
+
+**[1:00–1:30] — O método (2 casos reais)**
+"Na investigação: sem método, a IA escreve um relatório que mistura fato com achismo. Com o método EGOS, ela é obrigada a classificar — CONFIRMADO tem documento, INFERIDO é dedução, HIPÓTESE ainda precisa ser checada. Funciona igual num contrato, num laudo, numa nota fiscal. A IA separa o que está provado, o que deduz, e o que ainda é dúvida. Você decide."
+
+**[1:30–2:00] — Pra quem é**
+"Não é só pra desenvolvedor. É pra encanador, eletricista, professor, servidor público, médico — qualquer pessoa com dados pra organizar e curiosidade pra evoluir. Você não precisa saber programar. Precisa querer usar melhor o que já tem."
+
+**[2:00–2:30] — Comunidade + CTA**
+"R$4 de entrada. Acesso vitalício. O grupo é no Telegram — t.me/ethikin — onde compartilhamos ferramentas, fazemos demos ao vivo com nosso agente de IA, e construímos junto. Porque crescer sozinho é possível. Crescer junto é mais rápido. Começa por lá. O material está em egos.ia.br."
+
+> Notas de gravação: legenda sempre · mostrar tela nas demos · sem promessa de renda/resultado · sem previsão cripto · sem mencionar delegacia atual.
+
+---
+
+## PARTE F — Inventário de divulgação (2026-06-09)
+
+### O que entra na v1 da Hotmart
+| Item | Status |
+|------|--------|
+| Vídeo apresentação (PARTE E) | PENDENTE — Enio grava |
+| Material PDF (PARTE A) | PRONTO — exportar do .md |
+| GPT EGOS personalizado | CRIAR — ver checklist abaixo |
+| Guard Brasil (egos.ia.br/tools) | REAL |
+| Telegram t.me/ethikin | REAL |
+| github.com/enioxt/egos-governance | REAL (EN — PT-BR Fase 2) |
+
+### Checklist Hotmart
+| Campo | Valor |
+|-------|-------|
+| Nome | EGOS — Método, Ferramentas e Comunidade de IA |
+| Categoria | Tecnologia |
+| Preço | R$ 4,00 vitalício |
+| Garantia | Total, a qualquer momento |
+| Suporte | Telegram t.me/ethikin |
+| Msg boas-vindas | "Bem-vindo. Primeiro passo: abra o GPT EGOS [link] e responda a pergunta inicial. Ele configura seu setup em minutos." |
+| Descrição curta | (PARTE D — 496 chars — já escrita) |
+
+### Pendências de Enio (fazer hoje)
+1. Gravar vídeo 2:30 com PARTE E
+2. Criar GPT personalizado no ChatGPT (ver §GPT abaixo)
+3. Criar produto na Hotmart com checklist acima
+4. Criar grupo Telegram t.me/ethikin (se ainda não existe)
+5. Enviar HTML piloto para Miguel (GOW) — `docs/presentations/mf-certificados-piloto.html`
+6. Publicar posts (drafts abaixo) APÓS Hotmart live
+
+### CPF Pseudonymization — dois cenários para MF Certificados
+**Cenário A (ir direto):** instrução no bot: "Não envie CPF por aqui. Para consultas, acesse o portal." Zero implementação extra.
+**Cenário B (gate completo ~3h):** gateway intercepta CPF → token PSE-xxxx → LLM nunca vê real → resolve token na chamada SERPRO/Receita. Cobre caso onde usuário digita CPF por acidente no chat.
+
 ---
 *DRAFT — HITL Enio antes de gravar/publicar. PDF: exportar Parte A (pandoc/print). Ícone: VISUAL_IDENTITY (espiral Fibonacci azul #2563EB). Telegram: t.me/ethikin.*
diff --git a/prompts/personal-os/SELF_MAPPING_INTERVIEW.md b/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
index c90eef91..de9a10a2 100644
--- a/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
+++ b/prompts/personal-os/SELF_MAPPING_INTERVIEW.md
@@ -64,167 +64,172 @@ Persistido em `data/personal-os/private/interview_state.json` (gitignore):
 | ❌ `pula` (sem motivo) | RECUSADO — redireciona para `pula com motivo: <texto>` | nunca aceito |
 
 **Não existe comando para desabilitar entrevista permanentemente.** Layer 0.5 do `/start` é constitucional.
 
 ---
 
 ## §1.5. Apresentação Canonical — template 6 seções (v1.1, NEW)
 
 > **Trigger:** Enio 2026-05-09 — *"você deve me ajudar na condução das respostas apresentando sua argumentação. Eu respondo, eu escolho, mas você me apresenta tudo de cada questão"*.
 > **Histórico:** absorveu `QUESTION_PRESENTATION_PROTOCOL.md` (deletado) — R2.5 fix de INC-009 recurrence.
 
 ### Princípios
 
 1. **Enio decide, agente prepara.** Toda pergunta vem com terreno arado: opções, tradeoffs, recomendação.
 2. **Banda Cognitiva interna obrigatória.** Crítico → Apoiador → Questionador → Maestro **antes** de apresentar. Síntese Maestro + tradeoffs visíveis. Banda full só sob `/banda` explícito.
 3. **Critério aceitação verificável.** Sem isso, agente fica em loop de re-pergunta vaga.
 4. **Impacto declarado.** Qual SSOT/TASKS/MAP muda quando resposta chega.
 5. **Boundaries respeitados.** Se Enio rejeitou framing antes (ex: "não trate G Peças aqui"), agente não inclui.
 
 ### Template canonical (6 seções obrigatórias)
 
 ```markdown
 🚪 <TIPO>-<ID> — <título de 1 linha>
 
 §1 PERGUNTA
 [texto literal — sem reformular sem aviso]
 
 §2 POR QUE AGORA
 [1-2 linhas: o que destrava | prazo | dependências]
 
 §3 OPÇÕES + ARGUMENTAÇÃO
 [tabela 2-4 opções, cada uma:
  - O que é (1 linha factual)
  - Trade-off principal (+ ganho / − custo)
  - Banda mini (Crítico/Apoiador 1 frase cada)]
 
 §4 RECOMENDAÇÃO
 [1 opção (ou combinação) + 1-2 frases justificando.
  Tradeoff explícito do que se perde ao recomendar.]
 
 §5 CRITÉRIO DE ACEITAÇÃO
 [resposta "completa" = X. Específico, verificável.
  Se vaga → agente reformula sem avançar.]
 
 §6 IMPACTO DA RESPOSTA
 [lista do que muda:
  - SSOTs (paths)
  - TASKS afetadas (IDs)
  - MAPs (ENIO_UNDERSTANDING, etc)
  - Próximas perguntas desbloqueadas]
 ```
 
 ### Aplica em
 
 - EPOS interview (B1-B5) — **sempre**
 - ADR P-pendentes — sempre
 - Red Zone Gate (FOCUS_GATES.md §5) — irreversíveis. Sugere `/banda` ou Council
 - Escolhas técnicas com ≥2 opções razoáveis
 
 ### NÃO aplica em
 
 - Pergunta factual ("qual hora?", "rodou?") — resposta direta
 - Binário óbvio
 - Esclarecimento de algo Enio falou — pedir esclarecimento direto
 
 ### Anti-patterns (NÃO fazer)
 
 - ❌ Listar opções sem argumentar — Enio gasta cognição que era do agente
 - ❌ Pular §4 Recomendação — "você decide" = abdicação, não respeito
 - ❌ Inventar opções fora dos boundaries que Enio já estabeleceu
 - ❌ §3 com >4 opções — paralisia. Agrupar em eixos
 - ❌ §5 vago ("razoável", "o que você achar")
 - ❌ Apresentar sem §6 Impacto — decisão fica órfã
 
 ### Recovery (se Enio sinalizar "lista solta" / "não argumentou")
 
 1. Reconhecer falha em 1 linha — sem 3 desculpas
 2. Re-apresentar com 6 seções completas
 3. Tag `Q-PROTO-VIOLATION-<data>` em handoff (≥3 violations = revisão do protocolo)
 
-### Persistência (v1.1 schema)
+### Persistência (v1.2 — LOOP VIVO, corte Enio 2026-06-08)
 
-Quando resposta válida chega, agente:
+> **Causa:** auditoria 2026-06-08 — os atoms eram um **sumidouro write-only**. Nenhum script lê o `.jsonl` em runtime; o `/start` só conta linhas (`wc -l`), não carrega conteúdo; o `.jsonl` é gitignored (não dissemina). O ENIO_UNDERSTANDING_MAP.md (projeção) ficou stale 31/mai→08/jun. O canal que de fato influencia toda sessão é o sistema de **MEMÓRIA** (`~/.claude/projects/.../memory/*.md` + `MEMORY.md`), populado manualmente. Decisão Enio: toda resposta validada gera **atom + memória sempre** (sem construir script — disciplina do protocolo).
 
-1. Atomizar em 1+ atoms rascunho
-2. Persist em `data/personal-os/private/enio_profile_atoms.jsonl` (gitignore) APÓS Enio confirmar
-3. Update `interview_state.json`:
+Quando resposta válida chega, agente faz **os 3 (não só o atom)**:
+
+1. **Atom** (trilha de auditoria) — persist em `data/personal-os/private/enio_profile_atoms.jsonl` APÓS validar.
+2. **Memória (CANAL VIVO — obrigatório se a resposta revela padrão de calibração):** escrever/atualizar `~/.claude/projects/-home-enio-egos/memory/<slug>.md` + linha no `MEMORY.md`. É isto que faz a próxima sessão e os outros agentes herdarem — em tempo real, sem código.
+3. **MAP:** refletir em `ENIO_UNDERSTANDING_MAP.md` (mover 🟡→🟢, add 🔴, etc.) quando muda nível de delegação. Bump `last_update`.
+4. **Regra (só quando o padrão estabiliza):** se vira calibração durável (ex: bloqueio de receber → cuidado com pricing), virar candidata a `/rules`. Não prematuro.
+
+Depois, update `interview_state.json`:
    - `questions_answered` += [ID]
    - `current_question_id` = next
    - `last_activity` = now
    - **`current_presentation`** (NEW v1.1): clear ao avançar
    - **`atoms_pending_validation`** (NEW v1.1): mover atom para `enio_profile_atoms.jsonl` quando validado
 4. Update TASKS / MAPs conforme §6 Impacto
 5. Commit (R0.5 — immediately)
 
 **Quando agente APRESENTA pergunta** (antes da resposta), persiste:
 - `current_presentation.fired_at` = now
 - `current_presentation.format_version` = "1.0"
 - `current_presentation.session_id` = current
 - `current_presentation.argumentation_seeds` = { options, recommendation, tradeoff }
 
 Próxima sessão lê isso → não re-roda Banda do zero.
 
 ### Lembrete obrigatório no `/start` Layer 0.5
 
 Quando Layer 0.5 detectar pergunta pendente:
 1. Read este arquivo (`SELF_MAPPING_INTERVIEW.md`) — §1.5 é canonical
 2. Aplicar template ANTES de apresentar
 3. Reportar no Verification Checkpoint:
    ```
    ✓ Apresentação canonical (§1.5 v1.1): aplicado
    ✓ Próxima pergunta: <ID> — apresentada com 6 seções
    ```
 
 Sem o template aplicado, Layer 0.5 está incompleta.
 
 ---
 
 ## §2. Blocos de perguntas (ordem fixa)
 
 > Cada bloco fecha quando todas suas perguntas têm resposta validada.
 > Bloco seguinte só desbloqueia após anterior fechado.
 
 ### B1 — Como você decide (4 perguntas)
 Foco: descobrir padrões reais de tomada de decisão sob pressão e em incerteza.
 
 - **B1-Q1** — Última decisão grande do EGOS que você tomou. Conta: o que estava em jogo, quais opções considerou, por que escolheu essa, quanto tempo levou. (Resposta completa = ≥3 frases concretas, com exemplo real)
 - **B1-Q2** — Quando você decide rápido vs lento? Dá um exemplo de cada do último mês. (Critério: 2 exemplos reais com datas aproximadas)
 - **B1-Q3** — Em que tipo de decisão você costuma errar? (Critério: ≥1 padrão recorrente identificado, não "às vezes erro")
 - **B1-Q4** — O que faz você travar antes de decidir? (Critério: ≥1 trigger concreto, ex: "preciso de 3 opções pra pensar", "evito decisões que ferem alguém")
 
 ### B2 — Onde você flui vs onde você dispersa (4 perguntas)
 Foco: Mapear leverage zones reais (não inferidas).
 
 - **B2-Q1** — Que tipo de tarefa faz horas passarem sem você notar? Dá 2 exemplos do último mês.
 - **B2-Q2** — Que tipo de tarefa você adia repetidamente, mesmo sabendo que precisa fazer? (Critério: ≥2 padrões com motivo)
 - **B2-Q3** — Em que tipo de problema as pessoas vêm te pedir ajuda? (Critério: ≥3 categorias, com quem)
 - **B2-Q4** — Quando você abre 5 frentes ao mesmo tempo, qual gatilho disparou isso? (Critério: identificar 1+ trigger de dispersão)
 
 ### B3 — Sua relação com IA (3 perguntas)
 Foco: Como AI deve se calibrar pra você.
 
 - **B3-Q1** — Que tipo de resposta de IA te enche o saco? (Critério: ≥3 padrões específicos)
 - **B3-Q2** — Quando você sente que a IA está te tornando menos capaz, não mais? (Critério: ≥1 momento concreto)
 - **B3-Q3** — O que você precisa da IA fazer DIFERENTE pra você crescer com ela? (Critério: ≥3 comportamentos concretos)
 
 ### B4 — Limites e ética (3 perguntas)
 Foco: Red Zones reais, não imaginadas.
 
 - **B4-Q1** — Que tipo de coisa você nunca aceitaria que IA decidisse por você no EGOS? (Critério: ≥3 categorias)
 - **B4-Q2** — Em que situação você desconfia mais da IA? (Critério: 1+ contexto concreto)
 - **B4-Q3** — Que tipo de uso do EGOS por terceiros você se recusaria a aceitar mesmo pagando? (Critério: ≥2 casos)
 
 ### B5 — Próximos 30 dias (2 perguntas)
 Foco: ancoragem temporal, conectar perfil ao Single Pursuit.
 
 - **B5-Q1** — Se em 30 dias você puder ter UMA coisa pronta no EGOS, qual é? (Critério: 1 artefato específico, não "fechar primeiro cliente")
 - **B5-Q2** — O que te impede HOJE de começar essa coisa? (Critério: ≥1 bloqueador real, não "tempo")
 
 **Total: 16 perguntas em 5 blocos.** Estimativa: 4-8 sessões de 15-20min. Profundidade > velocidade.
 
 ---
 
 ## §3. Após cada bloco fechado
 
 Agente produz:
 1. **Resumo do bloco em PT-BR** (3-5 bullets do que Enio revelou)

exec
/bin/bash -lc 'git diff --unified=30 5aecdd0db0808a52dd613f31f725a1e68771f587 -- apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/jobs/2026-06-08-doc-drift-verifier.json docs/jobs/2026-06-08-pre-commit-pipeline.json docs/knowledge/HARVEST.md docs/personal-os/ENIO_UNDERSTANDING_MAP.md docs/drafts/SOCIAL_LAUNCH_DRAFTS.md docs/strategy/APRESENTACAO_EGOS.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -1,38 +1,38 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
   <channel>
     <title>EGOS Timeline</title>
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
       <title><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes]]></title>
       <link>https://egos.ia.br/#/timeline/lab-onboarding-automation</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/lab-onboarding-automation</guid>
       <pubDate>Wed, 29 Apr 2026 19:44:29 GMT</pubDate>
       <description><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes
 Quando começamos a oferecer o EGOS Lab — um espaço colaborativo para parceiros experimentarem nossas ferramentas — percebemos que o onboarding manual seria um gargalo. Não queríamos terceirizar: precisávamos de um sistema que pudesse validar, a…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Sessão 2026-04-29 — Resumo técnico]]></title>
       <link>https://egos.ia.br/#/timeline/session-2026-04-29</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/session-2026-04-29</guid>
       <pubDate>Wed, 29 Apr 2026 19:40:27 GMT</pubDate>
       <description><![CDATA[---
 title: "Sessão 2026-04-29 — Resumo técnico"
 slug: session-2026-04-29
 lang: pt-br
 date: 2026-04-29
 tags: [session-summary, daily-work, ecosystem]
 status: published
 ---
 
 # Sessão — terça-feira, 28 de abril de 2026
 
 ## 📊 Snapshot
 
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -1,38 +1,38 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
   <channel>
     <title>EGOS Timeline</title>
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
       <title><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes]]></title>
       <link>https://egos.ia.br/#/timeline/lab-onboarding-automation</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/lab-onboarding-automation</guid>
       <pubDate>Wed, 29 Apr 2026 19:44:29 GMT</pubDate>
       <description><![CDATA[Como automatizamos o onboarding do EGOS Lab com agentes
 Quando começamos a oferecer o EGOS Lab — um espaço colaborativo para parceiros experimentarem nossas ferramentas — percebemos que o onboarding manual seria um gargalo. Não queríamos terceirizar: precisávamos de um sistema que pudesse validar, a…]]></description>
       
     </item>
 
     <item>
       <title><![CDATA[Sessão 2026-04-29 — Resumo técnico]]></title>
       <link>https://egos.ia.br/#/timeline/session-2026-04-29</link>
       <guid isPermaLink="true">https://egos.ia.br/#/timeline/session-2026-04-29</guid>
       <pubDate>Wed, 29 Apr 2026 19:40:27 GMT</pubDate>
       <description><![CDATA[---
 title: "Sessão 2026-04-29 — Resumo técnico"
 slug: session-2026-04-29
 lang: pt-br
 date: 2026-04-29
 tags: [session-summary, daily-work, ecosystem]
 status: published
 ---
 
 # Sessão — terça-feira, 28 de abril de 2026
 
 ## 📊 Snapshot
 
diff --git a/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md b/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md
new file mode 100644
index 00000000..1e9f11a0
--- /dev/null
+++ b/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md
@@ -0,0 +1,117 @@
+# EGOS — Drafts de Divulgação (v1 Hotmart)
+
+**Status:** DRAFT — HITL Enio antes de postar. Não publicar sem aprovação explícita.
+**Data:** 2026-06-09 | **Evento:** lançamento v1 Hotmart
+
+---
+
+## X.com (thread 5 tweets)
+
+**Tweet 1 — abertura**
+> Cansei de me esconder.
+>
+> Nos últimos meses construí um sistema de IA governada — método anti-alucinação, proteção de dados, 460+ commits abertos no GitHub.
+>
+> Chamei de EGOS. Agora estou abrindo para todo mundo.
+>
+> 🧵
+
+**Tweet 2 — o problema**
+> [2/5] O problema que ele resolve:
+>
+> Você usa ChatGPT no trabalho. A IA inventa com confiança. Você cola um dado de cliente sem pensar. Dá errado.
+>
+> O EGOS ensina a IA a separar CONFIRMADO de INFERIDO de HIPÓTESE — e protege seus dados antes de enviar.
+
+**Tweet 3 — o que existe hoje**
+> [3/5] O que já existe (REAL, pode testar agora):
+>
+> → GPT personalizado por área [link]
+> → Guard Brasil: mascara CPF/CNPJ antes de qualquer IA — egos.ia.br/tools
+> → Método aberto: github.com/enioxt/egos-governance
+> → Comunidade: t.me/ethikin
+
+**Tweet 4 — preço**
+> [4/5] Acesso vitalício. R$4 de entrada.
+>
+> Não é erro. É o preço do começo. Quem entra agora paga o preço da aposta, não do produto acabado. O preço sobe com o material.
+>
+> [link Hotmart]
+
+**Tweet 5 — pra quem**
+> [5/5] Pra quem é: advogado, médico, professor, servidor público, empreendedor, estudante — qualquer pessoa curiosa que quer usar IA melhor.
+>
+> Começa no Telegram (grátis): t.me/ethikin
+
+---
+
+## Instagram (caption)
+
+> Parei de me esconder.
+>
+> Construí um método para usar IA sem que ela invente resposta e sem que seus dados vazem.
+>
+> Chama EGOS. Vem de 16 anos investigando + anos construindo com IA + comunidade aberta.
+>
+> O que você recebe hoje:
+> → GPT configurado pra sua área
+> → Detector de dados sensíveis (grátis no site)
+> → Comunidade + método aberto
+>
+> Acesso: R$4. Vitalício. Preço do começo, não do produto acabado.
+>
+> Link na bio. Comunidade: t.me/ethikin
+>
+> Filosofia, tecnologia, investigação — junto e sem esconder.
+
+---
+
+## LinkedIn
+
+> Nos últimos meses construí um sistema de IA governada: anti-alucinação, proteção de dados, código aberto, 460+ commits verificáveis no GitHub.
+>
+> Agora estou publicando a primeira versão pública.
+>
+> Chama EGOS. O método central: a IA é obrigada a separar CONFIRMADO de INFERIDO de HIPÓTESE antes de qualquer resposta.
+>
+> Para profissionais que usam IA no trabalho e querem usar com mais clareza e segurança.
+>
+> O que já está disponível:
+> → GPT personalizado por área
+> → Guard Brasil: mascara PII antes de qualquer IA — egos.ia.br/tools
+> → Código e método abertos: github.com/enioxt/egos-governance
+> → Comunidade: t.me/ethikin
+>
+> Acesso vitalício por R$4. Preço sobe com o material.
+>
+> [link Hotmart]
+
+---
+
+## Facebook
+
+> Depois de muito tempo construindo em silêncio, resolvi abrir o EGOS para todo mundo.
+>
+> É um método + ferramentas + comunidade para usar inteligência artificial (ChatGPT, Gemini, Claude) com mais clareza e segurança.
+>
+> A IA é poderosa. Mas ela inventa, ela confunde fato com achismo, e se você não tiver cuidado, pode expor dados que não devia.
+>
+> O EGOS resolve isso com um método simples, ferramentas prontas e um grupo onde a gente aprende e constrói junto.
+>
+> Acesso vitalício por R$4. Comunidade gratuita no Telegram: t.me/ethikin
+>
+> [link Hotmart]
+
+---
+
+## Tom e regras de postagem
+
+- Sincero, direto, humano — sem guru, sem hype
+- Sem promessa de riqueza, lucro, renda passiva
+- Sem "único no Brasil", "100%", "garanto"
+- Pode mencionar cripto como experiência pessoal, nunca como recomendação
+- Polícia Civil: experiência geral, sem delegacia, sem operação, sem casos
+- Publicar só após Hotmart estar live com o produto
+- Sequência recomendada: X → Instagram → LinkedIn → Facebook
+
+*SSOT: docs/strategy/APRESENTACAO_EGOS.md | Voz: voz-agent (HITL obrigatório)*
diff --git a/docs/jobs/2026-06-08-doc-drift-verifier.json b/docs/jobs/2026-06-08-doc-drift-verifier.json
index 51d2f152..84e0ca95 100644
--- a/docs/jobs/2026-06-08-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-08-doc-drift-verifier.json
@@ -1,34 +1,34 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-08T17:02:56.838Z",
+  "verified_at": "2026-06-08T19:52:45.610Z",
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
@@ -56,101 +56,101 @@
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
       "current_value": "37",
       "tolerance": "±2",
       "drift_abs": 1,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
     {
       "id": "commits_30d_all_repos",
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1248",
+      "current_value": "1260",
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
-      "current_value": "97",
+      "current_value": "100",
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
diff --git a/docs/jobs/2026-06-08-pre-commit-pipeline.json b/docs/jobs/2026-06-08-pre-commit-pipeline.json
index 3f671b13..793779a7 100644
--- a/docs/jobs/2026-06-08-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-08-pre-commit-pipeline.json
@@ -51,32 +51,72 @@
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:07:35.542Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:chore files=1 sha=4e22adde",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:08:02.087Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:feat files=1 sha=d592ae02",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:41:20.843Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:docs files=3 sha=869e8329",
     "repo": "/home/enio/egos"
   },
   {
     "agent_id": "pre-commit-pipeline",
     "ts": "2026-06-08T17:51:15.348Z",
     "status": "ok",
     "duration_ms": null,
     "event": "commit:chore files=2 sha=f60954ff",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:45:35.773Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=10 sha=88201591",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T19:52:46.190Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=d8411241",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:01:10.597Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=7d6b09c6",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:04:30.180Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=5 sha=b3d62d99",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-08T20:05:50.745Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=f9369018",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 12bd4752..8438dcce 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,35 +1,40 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
+> **VERSION:** 5.17.0 | **UPDATED:** 2026-06-09 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+> **Latest:** P174 — Guard Brasil: auditoria machine-wide (6 pacotes, 3 repos, PRONTO flagship)
+
+---
+
+**P174 — Guard Brasil: estado real após auditoria machine-wide (2026-06-09)**
+`@egosbr/guard-brasil` v0.2.3 — 6 implementações em 3 repos. Core TS (20/20 testes), REST API `guard.egos.ia.br` (prod Hetzner), MCP Server v0.2.0 (SDK oficial), Python SDK (funcional, falta PyPI), LangChain wrapper (CONCEPT/esqueleto), frontend legado `_archived/`. 12 padrões PII BR + ATRiAN + Evidence Chain SHA-256. Pronto para divulgação como FLAGSHIP. Gaps: PyPI publish (2h), OpenAPI docs (3h), consolidar frontend, LangChain completo. CAPABILITY_REGISTRY §1.
 
 ---
 
 ## P173 — 2026-06-08: Fluxo unificado HTML + NotebookLM por cliente
 
 **Trigger:** Sessão GOW/MF Certificados — necessidade de apresentar proposta de piloto ao owner.
 
 **Padrão descoberto:** R-DOC-AUDIENCE-001 (README=máquina, HTML=humano) tem uma extensão natural: NotebookLM como amplificador de inteligência. O HTML é o shell de navegação (offline, sem login, compartilhável), o NotebookLM gera os artefatos derivados (áudio overview PT-BR para ouvir no carro, slides para reunião, briefing para o tomador de decisão).
 
 **Arquitetura:**
 1. `.md` fonte (AI↔AI) → NotebookLM via MCP (`source_add`)
 2. NotebookLM gera: áudio overview 5-10min PT-BR / slides / briefing executivo
 3. HTML atualizado com seção "Materiais" linkando artefatos
 4. GitHub per client: HTML standalone + README.md como fonte AI
 
 **Achado crítico:** HTML não é formato aceito como `source_type=file` no NotebookLM MCP. Alternativa: usar `source_type=text` com conteúdo extraído. Markdown/PDF/TXT são formatos válidos.
 
 **Capacidades criadas nesta sessão:**
 - §115: HTML por cliente (padrão EGOS)
 - §116: Pseudonimização CPF no gateway (Option A)
 - §117: Fluxo unificado HTML + NotebookLM
 
 ---
 
 ## P172 — 2026-06-08: Banda Cognitiva — preço no vídeo e HTML por cliente
 
 **Trigger:** Decisão de pricing (falar R$4 no vídeo com filosofia) e decisão de HTML per client para o GOW.
 
 **Síntese Maestro (preço):** Falar com filosofia = APROVADO, mas articulação simplificada: "começo em R$4 porque é o que vale hoje. Conforme a comunidade cresce, o preço sobe." NÃO criar critério rígido público para subida de preço (gera gaming da métrica). Vídeo vai envelhecer — é o vídeo de LANÇAMENTO, não eterno.
 
diff --git a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
index fc8abf33..87f0a4d4 100644
--- a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
+++ b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
@@ -1,68 +1,72 @@
 ---
 name: Enio Understanding Map — domínios por nível de delegação
 description: Mapa que diz a todo agente o que Enio domina, o que está aprendendo, o que IA pode executar mas DEVE explicar, e o que NUNCA pode ser terceirizado. SSOT.
 type: governance
 version: 1.1
 status: active
 created: 2026-05-08
-last_update: 2026-05-08 (B1+B2 entrevista — atoms A1-A52)
+last_update: 2026-06-08 (EPOS B2-Q1/Q2 retomada — flow zones + mecanismo produção∞/captura-adiada)
 ---
 
 # Enio Understanding Map
 
 > **Uso:** todo agente lê este arquivo no `/start` (Layer 0) e respeita os níveis ao decidir autonomia.
 > **Princípio governante:** `UNDERSTANDING_PROTOCOL.md` (Doutrina Karpathy)
 > **Atoms backing:** `data/personal-os/private/enio_profile_atoms.jsonl` (54 atoms validados)
 
 ---
 
 ## 🟢 Domínios que Enio JÁ entende profundamente
 
 Agente pode usar linguagem técnica densa, pular explicações básicas, ir direto à decisão.
 
 **De experiência prévia:**
 - Investigação e cadeias de evidência (16 anos PCMG — **policial EM ATIVIDADE, não ex**)
 - Crypto/Web3 fundamentos (desde 2017, prática real)
 - Uso prático de IA por construção (não teoria)
 - Intuição de governança ética (ATRiAN, ETHIK)
 - Raciocínio de sistemas/processos (link prediction, mapeamento)
 - Educação de comunidade (tradução técnica → leigo)
 - Contexto institucional/legal/social brasileiro (LGPD, ANPD, polícia)
 
 **Validado pela entrevista B1+B2 (2026-05-08):**
 - **Escuta ativa + perguntas que outros não fazem** (A26) — capacidade rara, monetizável
 - **Abstrai pessoa → ideia/conceito** (A27) — "menos CPF, mais ideia". Diferencial em vendas/Council/conflito
 - **Visão investigativa de necessidades** (A37) — vê dor antes de articulada. Estratégia atual: catálogo > cobrança imediata. Comercializar quando ≥3 cases publicados OU ≥5 clientes
 - **Modelo de venda Discovery+Build** (A40) — cliente traz problema, ele arquiteta. Lucas/pixelart provou. NÃO é Pitch+Sell
 - **Self-awareness operacional alta** (A48) — nomeia próprios bloqueios, valida protocolos contra si mesmo
 
+**Validado pela retomada EPOS B2 (2026-06-08):**
+- **Flow zones (B2-Q1):** flui em (1) CONVERSAR (assunto interessante → horas) e (2) RESOLVER/CONSTRUIR/PESQUISAR — próprios e dos outros. Auto-rótulo "resolvedor de problemas, mesmo que tenha que criar/amplificar eles" (Jordan). → agente pode usar isso como combustível, mas vigiar o lado dispersor (criar problema pra ter o que resolver).
+- **Mecanismo produção∞/captura-adiada (B2-Q1+Q2):** o que ADIA é RECEBER/capturar valor (dinheiro fora da polícia). Explica 460 commits/R$0 + dispersão 🔴. Quando ele hesitar em cobrar/fechar → é o nó de receber (🔴 abaixo), não falta de valor. Está em movimento (Miguel/GOW/Hotmart = rampa). 🔒 protegido. Ver `memory/user_enio_flow_zones_capture_block_2026-06-08.md`.
+
 **Validado pela clarificação 2026-05-20 (atom A78 — ver IDENTITY_AND_METHOD.md):**
 - **Habilidade central canonical:** transformar caos informacional em clareza estratégica aplicável (não é pivot — é nome para o padrão que sempre existiu)
 - **Método-mãe canonical:** Espiral de Escuta — escuta + maiêutica + síntese + needs[]/next_actions[] + audit. Aplicação transversal (comércio/investigação/interpessoal/replicação)
 - **Arquitetura de sentido:** união leitura humana + investigação + sistemas + IA — interseção rara, dificilmente terceirizada
 - **NÃO sou:** dev full-stack genérico, terapeuta, trader full-time, guru, site builder for hire, vendedor de IA genérica
 - **SOU:** investigador-arquiteto que aplica método Espiral em contextos diferentes
 
 ---
 
 ## 🟡 Domínios em desenvolvimento ativo
 
 Agente DEVE explicar enquanto faz. Cada artefato vira oportunidade de aprendizado.
 
 - Arquitetura de programação (Bun/TS, packages, monorepo)
 - Pipelines de automação (cron, hooks, dispatch)
 - Agentes de IA (orquestração, runner, event-bus)
 - RAG e sistemas de retrieval (pgvector, hybrid search, RRF)
 - Integração MCP (Model Context Protocol)
 - Design de frontend/produto (UX de conversão, não polish)
 - Monetização SaaS (pricing tiers, RLS, isolation)
 - Deployment técnico (Caddy, Docker, VPS)
 
 **Regra:** se agente toca um desses, **comentar a decisão arquitetural** (não o código), e oferecer 1 leitura curta opcional ao fim.
 
 ---
 
 ## 🟠 Domínios que IA PODE executar mas DEVE explicar
 
 Velocidade aceita, mas com Understanding Summary obrigatório no final.
 
diff --git a/docs/strategy/APRESENTACAO_EGOS.md b/docs/strategy/APRESENTACAO_EGOS.md
index 3a6cf83f..0d4d6785 100644
--- a/docs/strategy/APRESENTACAO_EGOS.md
+++ b/docs/strategy/APRESENTACAO_EGOS.md
@@ -110,32 +110,92 @@ E olha, eu vou ser direto sobre o que me diferencia, sem precisar puxar credenci
 O método é simples: a gente ensina a IA a falar como um investigador. Ela não pode te dar uma resposta solta — é obrigada a classificar antes de entregar: **CONFIRMADO** (tem prova em documento), **INFERIDO** (é dedução lógica), **HIPÓTESE** (é só possibilidade, confira). Isso muda o jogo: a IA para de tentar te convencer e passa a te mostrar as pistas.
 Eu chamo isso de **Triplo Filtro**: (1) **Dado seguro** — o que é sensível não sai da sua máquina; (2) **Grau de certeza** — a IA separa fato de achismo; (3) **Revisão humana** — você decide. A IA propõe, a pessoa dispõe."
 
 **[5 · Ferramentas grátis (o GPT é o herói) — 5:00–6:30]**
 "E não é promessa pro futuro — já tem coisa pronta pra usar hoje, de graça. A melhor de todas é o nosso GPT personalizado. Ele não te joga um prompt gigante pra você se virar: quando você abre, ele entra em **modo tutor** — te faz uma pergunta simples por vez, te ouve, e propõe a configuração exata pra sua rotina. Você só confirma. É a IA se configurando pro seu trabalho.
 Tem também o **Guard Brasil** no site. Funciona assim: você cola um texto com dados de um cliente — nome, CPF, telefone. Ali mesmo, na sua tela, o sistema troca tudo por etiquetas seguras tipo `[PESSOA_1]`, `[CPF_1]`. É esse texto limpo que vai pra IA. Quando a resposta volta, ele recoloca os dados reais na sua tela. A IA trabalha, mas os dados reais nunca saíram do seu computador.
 Comece pelo GPT — é o atalho mais honesto que eu tenho pra te entregar."
 
 **[6 · Pra quem é / pra quem não é — 6:30–7:45]**
 "Vou ser honesto: isso não é pra todo mundo. Você aproveita mais se já tem alguma coisa do seu trabalho digitalizada, se usa o computador no dia a dia, se tem curiosidade. Mas se você ainda usa só o ChatGPT pra pesquisar, de forma básica — tudo bem, a gente te ajuda a evoluir: usar um GPT personalizado, decidir se vale assinar um modelo melhor, aprender a fazer perguntas melhores. O que eu não quero é gente esperando milagre. Aqui é método e prática."
 
 **[7 · Comunidade + criação/monetização — 7:45–9:00]**
 "O coração disso é a comunidade. A gente compartilha ferramentas e aprendizados, o conteúdo cresce com o tempo, e cada área vai ganhando ferramenta própria — construída com quem vive o problema. E tem espaço pra quem quer criar: se você desenvolve algo útil, pode oferecer dentro da plataforma, e projetos que avançam podem ter participação proporcional à colaboração. Não é promessa de renda — é espaço pra construir junto."
 
 **[8 · Preço / acesso — 9:00–9:45]**
 "O acesso é vitalício. O preço de entrada é 4 reais. Não é erro de digitação, é uma escolha consciente: o EGOS está no começo, e o preço reflete isso. À medida que o material cresce, a comunidade valida, e o método prova mais — o preço sobe. Quem entra agora paga o preço da aposta, não do produto acabado. Isso é justo dos dois lados: você assume a incerteza do começo, e entra por menos."
 
 **[9 · Convite — 9:45–10:30]**
 "Se isso fez sentido pra você, entra no nosso Telegram — o link é **t.me/ethikin**, que vem de inteligência ética e comunidade. É aberto, é gratuito, e é lá que a gente conversa e constrói junto. E começa pelo GPT e pelo material em egos.ia.br. Não precisa decidir nada agora. Dá uma olhada, testa, e vê se faz sentido pra você."
 
 > Gravação: legenda sempre · cortes curtos · mostrar a tela nas demos (GPT + detector) · nada de "garanto/100%/único/fique rico" · sem dizer delegacia atual · sem previsão de preço de cripto.
 
 ---
 
 ## PARTE D — Hotmart "Sobre o que é o seu produto?" (colar, ≤500 chars)
 
 > O EGOS é uma comunidade e um método para usar inteligência artificial (ChatGPT, Claude, Gemini) com mais clareza e segurança — sem que ela invente respostas ou exponha seus dados. Acesso vitalício a ferramentas prontas, um GPT personalizado, regras, materiais e, principalmente, troca com a comunidade. Para profissionais e curiosos que querem evoluir sua literacia em IA, na prática. Não é promessa de renda — é método, colaboração e aprendizado contínuo.
 
 (Preço entra no campo de preço do Hotmart, não no "Sobre": começa em R$4, progressão ×2 — o fundador decide quando sobe; não anunciar tempo/quantidade.)
 
+---
+
+## PARTE E — ROTEIRO 2:30 (versão mínima publicável — 2026-06-09)
+
+> 150 segundos · ~300 palavras · Enio grava com legenda · sem hype · sem delegacia atual · sem previsão cripto · mostrar tela nas demos
+
+**[0:00–0:30] — Quem sou + por que isso importa**
+"Entrei com 20 anos na Polícia Civil de Minas Gerais. Rodei praticamente todas as delegacias — centenas de homicídios, investigações financeiras. Isso me ensinou uma coisa: separar o que é fato do que é versão. É exatamente o que o EGOS faz com inteligência artificial."
+
+**[0:30–1:00] — De onde o EGOS nasceu**
+"O EGOS começou quando eu instalei o Cursor — minha primeira IDE — e tentei criar um bot no Telegram pra redimensionar imagens. Quase desisti. Achei que não era capaz. Mas entendi algo que mudou minha visão: uma IDE não é só pra desenvolvedor. É pra qualquer pessoa que tem dados — pessoais, do trabalho, de estudo — e quer processá-los com os melhores modelos de IA do mundo."
+
+**[1:00–1:30] — O método (2 casos reais)**
+"Na investigação: sem método, a IA escreve um relatório que mistura fato com achismo. Com o método EGOS, ela é obrigada a classificar — CONFIRMADO tem documento, INFERIDO é dedução, HIPÓTESE ainda precisa ser checada. Funciona igual num contrato, num laudo, numa nota fiscal. A IA separa o que está provado, o que deduz, e o que ainda é dúvida. Você decide."
+
+**[1:30–2:00] — Pra quem é**
+"Não é só pra desenvolvedor. É pra encanador, eletricista, professor, servidor público, médico — qualquer pessoa com dados pra organizar e curiosidade pra evoluir. Você não precisa saber programar. Precisa querer usar melhor o que já tem."
+
+**[2:00–2:30] — Comunidade + CTA**
+"R$4 de entrada. Acesso vitalício. O grupo é no Telegram — t.me/ethikin — onde compartilhamos ferramentas, fazemos demos ao vivo com nosso agente de IA, e construímos junto. Porque crescer sozinho é possível. Crescer junto é mais rápido. Começa por lá. O material está em egos.ia.br."
+
+> Notas de gravação: legenda sempre · mostrar tela nas demos · sem promessa de renda/resultado · sem previsão cripto · sem mencionar delegacia atual.
+
+---
+
+## PARTE F — Inventário de divulgação (2026-06-09)
+
+### O que entra na v1 da Hotmart
+| Item | Status |
+|------|--------|
+| Vídeo apresentação (PARTE E) | PENDENTE — Enio grava |
+| Material PDF (PARTE A) | PRONTO — exportar do .md |
+| GPT EGOS personalizado | CRIAR — ver checklist abaixo |
+| Guard Brasil (egos.ia.br/tools) | REAL |
+| Telegram t.me/ethikin | REAL |
+| github.com/enioxt/egos-governance | REAL (EN — PT-BR Fase 2) |
+
+### Checklist Hotmart
+| Campo | Valor |
+|-------|-------|
+| Nome | EGOS — Método, Ferramentas e Comunidade de IA |
+| Categoria | Tecnologia |
+| Preço | R$ 4,00 vitalício |
+| Garantia | Total, a qualquer momento |
+| Suporte | Telegram t.me/ethikin |
+| Msg boas-vindas | "Bem-vindo. Primeiro passo: abra o GPT EGOS [link] e responda a pergunta inicial. Ele configura seu setup em minutos." |
+| Descrição curta | (PARTE D — 496 chars — já escrita) |
+
+### Pendências de Enio (fazer hoje)
+1. Gravar vídeo 2:30 com PARTE E
+2. Criar GPT personalizado no ChatGPT (ver §GPT abaixo)
+3. Criar produto na Hotmart com checklist acima
+4. Criar grupo Telegram t.me/ethikin (se ainda não existe)
+5. Enviar HTML piloto para Miguel (GOW) — `docs/presentations/mf-certificados-piloto.html`
+6. Publicar posts (drafts abaixo) APÓS Hotmart live
+
+### CPF Pseudonymization — dois cenários para MF Certificados
+**Cenário A (ir direto):** instrução no bot: "Não envie CPF por aqui. Para consultas, acesse o portal." Zero implementação extra.
+**Cenário B (gate completo ~3h):** gateway intercepta CPF → token PSE-xxxx → LLM nunca vê real → resolve token na chamada SERPRO/Receita. Cobre caso onde usuário digita CPF por acidente no chat.
+
 ---
 *DRAFT — HITL Enio antes de gravar/publicar. PDF: exportar Parte A (pandoc/print). Ícone: VISUAL_IDENTITY (espiral Fibonacci azul #2563EB). Telegram: t.me/ethikin.*

exec
/bin/bash -lc "grep -n \"GPT\\|§GPT\\|PARTE [A-F]\" docs/strategy/APRESENTACAO_EGOS.md | head -80 && grep -n \"§GPT\" docs/strategy/APRESENTACAO_EGOS.md" in /home/enio/egos
 succeeded in 0ms:
10:## PARTE A — Material escrito (vira PDF)
13:O EGOS ajuda você a usar IA (ChatGPT, Claude, Gemini) com método — para a IA não inventar resposta, não vazar seus dados, e você saber o que é fato e o que é achismo.
31:- **Metaprompt "Assistente Profissional Governado"** — cola no ChatGPT/Claude/Gemini, responde uma pergunta, e vira um assistente da sua área com esses cuidados embutidos.
64:## PARTE B — ROTEIRO DE VÍDEO (~8–10 min)
69:"Você já usou o ChatGPT pra te ajudar no trabalho e desconfiou se a resposta tava certa? Ou ficou com medo de colar um dado de cliente ali? Esse é o problema que o EGOS resolve. Em poucos minutos eu te mostro como usar IA com método — sem ela te enganar e sem vazar seus dados."
94:## PARTE C — ROTEIRO PERSONALIZADO (gravação 2026-06-08)
105:"Hoje a IA está na mão de todo mundo — ChatGPT, Claude, Gemini, Grok. Mas a maioria usa no escuro: a IA inventa resposta com confiança, mistura fato com achismo, e se você colar um dado de cliente ali, pode expor o que não devia. Eu juntei duas coisas que vivo — investigação e tecnologia — pra criar um jeito de usar IA com método. É isso que eu chamo de EGOS.
113:**[5 · Ferramentas grátis (o GPT é o herói) — 5:00–6:30]**
114:"E não é promessa pro futuro — já tem coisa pronta pra usar hoje, de graça. A melhor de todas é o nosso GPT personalizado. Ele não te joga um prompt gigante pra você se virar: quando você abre, ele entra em **modo tutor** — te faz uma pergunta simples por vez, te ouve, e propõe a configuração exata pra sua rotina. Você só confirma. É a IA se configurando pro seu trabalho.
116:Comece pelo GPT — é o atalho mais honesto que eu tenho pra te entregar."
119:"Vou ser honesto: isso não é pra todo mundo. Você aproveita mais se já tem alguma coisa do seu trabalho digitalizada, se usa o computador no dia a dia, se tem curiosidade. Mas se você ainda usa só o ChatGPT pra pesquisar, de forma básica — tudo bem, a gente te ajuda a evoluir: usar um GPT personalizado, decidir se vale assinar um modelo melhor, aprender a fazer perguntas melhores. O que eu não quero é gente esperando milagre. Aqui é método e prática."
128:"Se isso fez sentido pra você, entra no nosso Telegram — o link é **t.me/ethikin**, que vem de inteligência ética e comunidade. É aberto, é gratuito, e é lá que a gente conversa e constrói junto. E começa pelo GPT e pelo material em egos.ia.br. Não precisa decidir nada agora. Dá uma olhada, testa, e vê se faz sentido pra você."
130:> Gravação: legenda sempre · cortes curtos · mostrar a tela nas demos (GPT + detector) · nada de "garanto/100%/único/fique rico" · sem dizer delegacia atual · sem previsão de preço de cripto.
134:## PARTE D — Hotmart "Sobre o que é o seu produto?" (colar, ≤500 chars)
136:> O EGOS é uma comunidade e um método para usar inteligência artificial (ChatGPT, Claude, Gemini) com mais clareza e segurança — sem que ela invente respostas ou exponha seus dados. Acesso vitalício a ferramentas prontas, um GPT personalizado, regras, materiais e, principalmente, troca com a comunidade. Para profissionais e curiosos que querem evoluir sua literacia em IA, na prática. Não é promessa de renda — é método, colaboração e aprendizado contínuo.
142:## PARTE E — ROTEIRO 2:30 (versão mínima publicável — 2026-06-09)
165:## PARTE F — Inventário de divulgação (2026-06-09)
170:| Vídeo apresentação (PARTE E) | PENDENTE — Enio grava |
171:| Material PDF (PARTE A) | PRONTO — exportar do .md |
172:| GPT EGOS personalizado | CRIAR — ver checklist abaixo |
185:| Msg boas-vindas | "Bem-vindo. Primeiro passo: abra o GPT EGOS [link] e responda a pergunta inicial. Ele configura seu setup em minutos." |
186:| Descrição curta | (PARTE D — 496 chars — já escrita) |
189:1. Gravar vídeo 2:30 com PARTE E
190:2. Criar GPT personalizado no ChatGPT (ver §GPT abaixo)
190:2. Criar GPT personalizado no ChatGPT (ver §GPT abaixo)

exec
/bin/bash -lc "nl -ba .claude/settings.json | sed -n '1,25p' && nl -ba docs/strategy/APRESENTACAO_EGOS.md | sed -n '168,192p' && nl -ba docs/drafts/SOCIAL_LAUNCH_DRAFTS.md | sed -n '1,45p'" in /home/enio/egos
 succeeded in 0ms:
     1	{
     2	  "permissions": {
     3	    "allow": [
     4	      "Bash(*)",
     5	      "Read",
     6	      "Write",
     7	      "Edit",
     8	      "Glob",
     9	      "Grep",
    10	      "WebFetch",
    11	      "WebSearch",
    12	      "Agent",
    13	      "Skill",
    14	      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
    15	      "Bash(echo \"EXIT: $?\")",
    16	      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
    17	      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
    18	      "Bash(cat)",
    19	      "Bash(bash scripts/check-skills-drift.sh --fix)",
    20	      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
    21	      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
    22	      "mcp__notebooklm-mcp__studio_delete",
    23	      "mcp__claude_ai_Supabase__execute_sql",
    24	      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
    25	      "mcp__claude_ai_Supabase__list_projects"
   168	| Item | Status |
   169	|------|--------|
   170	| Vídeo apresentação (PARTE E) | PENDENTE — Enio grava |
   171	| Material PDF (PARTE A) | PRONTO — exportar do .md |
   172	| GPT EGOS personalizado | CRIAR — ver checklist abaixo |
   173	| Guard Brasil (egos.ia.br/tools) | REAL |
   174	| Telegram t.me/ethikin | REAL |
   175	| github.com/enioxt/egos-governance | REAL (EN — PT-BR Fase 2) |
   176	
   177	### Checklist Hotmart
   178	| Campo | Valor |
   179	|-------|-------|
   180	| Nome | EGOS — Método, Ferramentas e Comunidade de IA |
   181	| Categoria | Tecnologia |
   182	| Preço | R$ 4,00 vitalício |
   183	| Garantia | Total, a qualquer momento |
   184	| Suporte | Telegram t.me/ethikin |
   185	| Msg boas-vindas | "Bem-vindo. Primeiro passo: abra o GPT EGOS [link] e responda a pergunta inicial. Ele configura seu setup em minutos." |
   186	| Descrição curta | (PARTE D — 496 chars — já escrita) |
   187	
   188	### Pendências de Enio (fazer hoje)
   189	1. Gravar vídeo 2:30 com PARTE E
   190	2. Criar GPT personalizado no ChatGPT (ver §GPT abaixo)
   191	3. Criar produto na Hotmart com checklist acima
   192	4. Criar grupo Telegram t.me/ethikin (se ainda não existe)
     1	# EGOS — Drafts de Divulgação (v1 Hotmart)
     2	
     3	**Status:** DRAFT — HITL Enio antes de postar. Não publicar sem aprovação explícita.
     4	**Data:** 2026-06-09 | **Evento:** lançamento v1 Hotmart
     5	
     6	---
     7	
     8	## X.com (thread 5 tweets)
     9	
    10	**Tweet 1 — abertura**
    11	> Cansei de me esconder.
    12	>
    13	> Nos últimos meses construí um sistema de IA governada — método anti-alucinação, proteção de dados, 460+ commits abertos no GitHub.
    14	>
    15	> Chamei de EGOS. Agora estou abrindo para todo mundo.
    16	>
    17	> 🧵
    18	
    19	**Tweet 2 — o problema**
    20	> [2/5] O problema que ele resolve:
    21	>
    22	> Você usa ChatGPT no trabalho. A IA inventa com confiança. Você cola um dado de cliente sem pensar. Dá errado.
    23	>
    24	> O EGOS ensina a IA a separar CONFIRMADO de INFERIDO de HIPÓTESE — e protege seus dados antes de enviar.
    25	
    26	**Tweet 3 — o que existe hoje**
    27	> [3/5] O que já existe (REAL, pode testar agora):
    28	>
    29	> → GPT personalizado por área [link]
    30	> → Guard Brasil: mascara CPF/CNPJ antes de qualquer IA — egos.ia.br/tools
    31	> → Método aberto: github.com/enioxt/egos-governance
    32	> → Comunidade: t.me/ethikin
    33	
    34	**Tweet 4 — preço**
    35	> [4/5] Acesso vitalício. R$4 de entrada.
    36	>
    37	> Não é erro. É o preço do começo. Quem entra agora paga o preço da aposta, não do produto acabado. O preço sobe com o material.
    38	>
    39	> [link Hotmart]
    40	
    41	**Tweet 5 — pra quem**
    42	> [5/5] Pra quem é: advogado, médico, professor, servidor público, empreendedor, estudante — qualquer pessoa curiosa que quer usar IA melhor.
    43	>
    44	> Começa no Telegram (grátis): t.me/ethikin
    45	

mcp: codebase-memory-mcp/list_projects started
mcp: codebase-memory-mcp/list_projects (completed)
exec
/bin/bash -lc "grep -n \"COPY-PRICE-REMOVE-001\\|Preço NÃO é público\\|Valor só no checkout\" TASKS.md" in /home/enio/egos
 succeeded in 0ms:
31:- [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
48:- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.

exec
/bin/bash -lc 'git rev-list --count HEAD; git -C /home/enio/egos-governance rev-list --count HEAD 2>/dev/null || true; git -C /home/enio/egos-governance status --short 2>/dev/null || true' in /home/enio/egos
 succeeded in 0ms:
2451
8

exec
/bin/bash -lc 'git remote -v; git -C /home/enio/egos-governance remote -v 2>/dev/null || true' in /home/enio/egos
 succeeded in 0ms:
https-origin	https://github.com/enioxt/egos.git (fetch)
https-origin	https://github.com/enioxt/egos.git (push)
origin	git@github.com:enioxt/egos.git (fetch)
origin	git@github.com:enioxt/egos.git (push)
origin	git@github.com:enioxt/egos-governance.git (fetch)
origin	git@github.com:enioxt/egos-governance.git (push)

exec
/bin/bash -lc 'jq . docs/jobs/2026-06-08-pre-commit-pipeline.json >/dev/null && jq . docs/jobs/2026-06-08-doc-drift-verifier.json >/dev/null && echo ok' in /home/enio/egos
 succeeded in 0ms:
ok

codex
The changes introduce a tooling regression for required MCP-based discovery and add launch copy that conflicts with the active no-public-price directive. These should be corrected before considering the patch safe.

Full review comments:

- [P2] Restore the MCP allowance required by repo rules — /home/enio/egos/.claude/settings.json:22-25
  In Claude sessions where this allowlist is enforced, replacing the generic `mcp__*` permission with only NotebookLM/Supabase entries leaves the required `mcp__codebase_memory_mcp__*` tools unavailable. This repo's AGENTS.md makes `search_graph`/`trace_call_path` the primary path for code discovery, so agents following the hooks will either stall or fall back to grep for code claims.

- [P2] Keep launch copy from publishing the internal price — /home/enio/egos/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md:35-37
  When these drafts are posted, this line makes the R$4 anchor public even though the still-active launch tasks say `preço NÃO é copy pública` and `Valor só no checkout` (TASKS.md lines 31 and 48). That directly reintroduces the public price-talk the repo is tracking for removal, so the social copy should omit the number and leave price disclosure to checkout/Hotmart.
The changes introduce a tooling regression for required MCP-based discovery and add launch copy that conflicts with the active no-public-price directive. These should be corrected before considering the patch safe.

Full review comments:

- [P2] Restore the MCP allowance required by repo rules — /home/enio/egos/.claude/settings.json:22-25
  In Claude sessions where this allowlist is enforced, replacing the generic `mcp__*` permission with only NotebookLM/Supabase entries leaves the required `mcp__codebase_memory_mcp__*` tools unavailable. This repo's AGENTS.md makes `search_graph`/`trace_call_path` the primary path for code discovery, so agents following the hooks will either stall or fall back to grep for code claims.

- [P2] Keep launch copy from publishing the internal price — /home/enio/egos/docs/drafts/SOCIAL_LAUNCH_DRAFTS.md:35-37
  When these drafts are posted, this line makes the R$4 anchor public even though the still-active launch tasks say `preço NÃO é copy pública` and `Valor só no checkout` (TASKS.md lines 31 and 48). That directly reintroduces the public price-talk the repo is tracking for removal, so the social copy should omit the number and leave price disclosure to checkout/Hotmart.
```
