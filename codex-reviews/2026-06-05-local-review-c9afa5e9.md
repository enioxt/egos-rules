# Codex Local Review — 2026-06-05T12:39:57Z

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
session id: 019e97cc-2473-7bd3-b9a7-5d839fe2d7f4
--------
user
changes against 'HEAD~3'
2026-06-05T12:39:59.772410Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-05T12:39:59.774730Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff e05c45193eb01f36d83210dee1187b98ffcf4bec --stat && git diff e05c45193eb01f36d83210dee1187b98ffcf4bec' in /home/enio/egos
 succeeded in 137ms:
 CLAUDE.md                                          |   1 +
 TASKS.md                                           |  33 +++++-
 TASKS_ARCHIVE.md                                   |   6 +
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 ...OR_GUARANI_2026-06-05_compass-self-discovery.md |  24 ++++
 ...RANI_TO_PRIME_2026-06-04_mycelium_governance.md |  44 +++++++
 docs/governance/UI_PRODUCT_RULES.md                | 129 +++++++++++++++++++++
 docs/jobs/2026-06-05-doc-drift-verifier.json       |   6 +-
 docs/jobs/2026-06-05-handoff-fidelity.json         |  13 +++
 docs/jobs/2026-06-05-pre-commit-pipeline.json      |  72 ++++++++++++
 docs/research/bashar-video-study.md                |  62 ++++++++++
 12 files changed, 388 insertions(+), 6 deletions(-)
diff --git a/CLAUDE.md b/CLAUDE.md
index 792d1057..d3c6845e 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -86,6 +86,7 @@ EGOS = kernel de orquestração para agents de IA governados. Repos-chave:
 - TypeScript: estrito, zero `any` implícito
 - DRY-RUN: todo agent suporta `--dry` antes de `--exec`
 - Edit Size: máx 80 linhas por operação de escrita
+- **UI/Produto [T1 — Enio 2026-06-05]:** uma tela = UM trabalho dominante; o que competir vira camada secundária. Antes de publicar QUALQUER tela pública, rodar o **Publication Gate (R-UI-005)**. SSOT: `docs/governance/UI_PRODUCT_RULES.md` (One Job Per Screen + UI Intent Contract + No Competing Modes + Live System Page + Publication Gate + Premortem). Origem: engenharia reversa do incidente Mycelium-3-jobs.
 - **README: PT-BR obrigatório, score ≥ 4/5** — SSOT: `docs/governance/README_PADRAO_OURO.md`
   - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
   - Atualizar README na mesma sessão que muda funcionalidade
diff --git a/TASKS.md b/TASKS.md
index dc411f68..853403c8 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -6,6 +6,38 @@
 > **Pivot ref:** `docs/planning/gpecas-mvp-task-plan.md` | `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md`
 
 ---
+<!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
+
+## 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
+
+> Contexto: engenharia reversa do erro Mycelium-3-jobs → regras de UI permanentes (FEITO).
+> Áreas sensíveis (Instagram download, vídeo de terceiro, WhatsApp) = LOCAL/PRIVADO/HITL por decisão do Enio.
+> Princípio cravado: **"O EGOS não precisa guardar pessoas; preserva ideias, conceitos, padrões, decisões."**
+
+**Pendências de publicação (HITL — do artefato grátis):**
+- [ ] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte.
+- [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram aberto "EGOS Framework" → ao existir, completar o link no artefato grátis (Parte 3). (Já existia; reforçada aqui como dependência do artefato.)
+- [ ] **COURSE-FREE-TIER-001** — reaberta (rascunho ≠ publicado; ver acima). Fecha só ao publicar.
+
+**Regras de UI (FEITO nesta sessão — follow-ups):**
+- [ ] **UI-RULES-AUDIT-001** [P1] `pixel`+`prime` — Passar todas as páginas públicas do egos-landing (home/timeline/showcase/transparencia/guard/grok/tools) pelo Publication Gate R-UI-005 (`docs/governance/UI_PRODUCT_RULES.md`). Listar violações de One Job Per Screen + plano de refatoração.
+- [ ] **UI-PUBLICATION-GATE-WIRE-001** [P1] `forja` — Tornar o Publication Gate EXECUTÁVEL (não doc-morto, R-SEC-003): checklist no `apps/*/deploy.sh` exigindo confirmação do gate + visual proof antes do rsync/publish. Espelha o Visual Proof Gate do pre-commit.
+
+**Ferramenta local de download (yt-dlp já resolve):**
+- [ ] **LOCAL-IGDL-DOC-001** [P2] `prime` `PERSONAL_LOCAL_TOOL`/`NO_PUBLIC_DEPLOY`/`NO_MONETIZATION` — Documentar uso do `yt-dlp` (já instalado) como alternativa local ao sssinstagram (sem anúncios, sem monetização). Diagnóstico curto em `docs/tools/local-video-download.md`: limites legais/éticos (só conteúdo próprio/autorizado, não burlar DRM/paywall, não redistribuir, não versionar cookies/sessão). NÃO construir ferramenta nova — yt-dlp basta (Karpathy mínimo). Premortem antes de qualquer wrapper.
+
+**Vídeo Bashar (transcrição interna):**
+- [ ] **BASHAR-VIDEO-STUDY-001** [P1] `prime`+`curador` `internal-only` — Transcrição do vídeo local (rodando whisper nesta sessão) → resumo + notas de aplicação ao EGOS em `docs/research/bashar-video/` (resumo + egos-application-notes, SANITIZADO). Vídeo de terceiro = referência inspiracional, NÃO copiar/publicar transcrição integral. Insumo p/ o agente de autodescoberta.
+
+**Agente EGOS de autodescoberta (Red Zone — limites psicológicos):**
+- [ ] **SELF-DISCOVERY-AGENT-SPEC-001** [P1] `redzone` `gated:HITL` — Especificar agente que conduz a pessoa a navegar em si mesma (mapear interesse/energia/padrões/direção). Spec + Red Zones + prompts em `docs/agents/self-discovery-agent*.md`. Limites DUROS: não diagnostica saúde mental, não substitui terapia, não manipula, não cria dependência, não afirma conhecer a pessoa melhor que ela; sempre separa fato/padrão/hipótese/pergunta/sugestão. Premortem obrigatório antes de implementar.
+- [ ] **GLOBAL-USER-PATTERN-001** [P2] `curador` `gated:HITL` — Plano de análise do padrão GLOBAL do usuário (commits + tasks + /start + /end + provenance + telemetria + Mycelium), não só por área. Classificar REAL/PATTERN/HYPOTHESIS/QUESTION/UNKNOWN. Sem psicologizar sem evidência. `docs/research/user-patterns/global-pattern-analysis-plan.md`. NÃO executar análise invasiva sem HITL.
+
+**Privacidade radical — ingestão WhatsApp (P0 política ANTES de qualquer ingest):**
+- [ ] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio.
+- [ ] **CONCEPT-ATOMIZATION-MODEL-001** [P1] `curador` `gated:WA-PRIVACY-POLICY-001` — Modelo de atomização: vivido → remove identificável → reconstrói conhecimento útil sem dado pessoal. `docs/architecture/concept-atoms.md`. Exemplo: "João me disse em Patos..." → "pessoa próxima relatou situação de confiança/frustração em contexto social".
+- [ ] **PROV-TELEM-MYCELIUM-MAP-001** [P2] `prime` — Mapa de como provenance/telemetria/Mycelium/start/end/pre-commit/commits entram na arquitetura de autodescoberta com privacidade (fonte/tipo/risco/tratamento/uso permitido/uso proibido/retenção/HITL). `docs/architecture/provenance-telemetry-mycelium-integration.md`.
+- [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
 
 ## 🎯 KYTE BENCHMARK & GAP-CLOSE — tarefa PRINCIPAL (Enio 2026-06-03)
 
@@ -72,7 +104,6 @@
 - [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram público "EGOS Framework" (aberto, gratuito, qualquer pessoa): (a) descrição do grupo; (b) regras de convivência; (c) link fixo para divulgação; (d) bot de boas-vindas automático (opcional). Tópicos: uso de IA com método, agentes, metaprompts, workflows, governança, segurança, automação, prompt engineering, AI-First, casos de uso, dúvidas do framework.
 - [ ] **COURSE-WHATSAPP-PRIVATE-001** [P1] `prime` `gated:HITL` — Configurar grupo WhatsApp privado "EGOS" (só quem pagou): (a) nome do grupo: "EGOS"; (b) escopo: discussão do EGOS Framework, metaprompts, agentes, workflows, casos de uso, dúvidas, roadmap, conteúdo em evolução — sempre com método, sem hype; (c) regras: sem vazamento de dados pessoais, sem casos reais sensíveis, uso ético; (d) mecanismo de adicionar pós-compra (webhook Hotmart → adicionar número via Evolution API ou manual). Gate: Enio aprova regras antes de criar.
 - [ ] **COURSE-PAYMENT-EASY-001** [P1] `prime` — Configurar pagamento com poucos cliques: (a) Hotmart checkout com Pix em destaque (instantâneo, sem taxa para comprador); (b) link direto para o produto (curto, fácil de copiar); (c) testar fluxo completo: clicar → pagar → receber acesso (deve ser < 3 cliques); (d) testar no celular (maioria vai comprar pelo WhatsApp/Telegram). Smoketeste obrigatório antes de divulgar.
-- [ ] **COURSE-FREE-TIER-001** [P1] `voz`+`prime` `gated:HITL` — Definir e publicar conteúdo gratuito útil que atrai para o curso: (a) qual o "útil já na parte gratuita" — proposta: 1 metaprompt pronto para download, 1 checklist de segurança de IA, 1 vídeo curto de 5min "o que é o EGOS Framework"; (b) onde fica: egos.ia.br + Telegram aberto + README do repo público; (c) o gratuito deve ser genuinamente útil — não teaser vazio. 🔄 2026-06-05: RASCUNHO pronto em `docs/drafts/free-artifact-egos-v0.md` (metaprompt + checklist + 3 opções de tom). PENDENTE corte Enio (5 pontos 🔴) + publicação HITL — NÃO fechar até publicar.
 - [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade. Resultado do workflow (14 agentes): classificação completa em PUBLIC_DOCS/PUBLIC_DEMO/PRIVATE_CORE/PRIVATE_SECURITY/PRIVATE_PCMG/ARCHIVE/NEEDS_REVIEW disponível em docs/audit/repositories-public-private-classification.md (a criar). NENHUM repo abre ou fecha sem auditoria + HITL do Enio. Prioridade: qual repo público principal (candidato: egos-governance já público, mas enxuto — candidato principal para ser o hub educacional).
 - [ ] **COURSE-OWN-PLATFORM-001** [P2] `pixel`+`prime` — Pesquisar e configurar venda direta via egos.ia.br: (a) é possível aceitar Pix direto na plataforma própria? (Asaas PF: sim, taxa ~2.99% Pix); (b) criar página de produto em egos.ia.br/founders; (c) checkout simples (gera link de pagamento Asaas → paga → acesso automático); (d) vantagem: sem taxa de plataforma (vs Hotmart ~9.9%); desvantagem: sem audiência da plataforma. Recomendação esperada: Hotmart principal + egos.ia.br como opção direta.
 - [ ] **COURSE-CRYPTO-WALLETS-001** [P2] `prime` `gated:HITL` 🔴 — Configurar recebimento em cripto (BTC, ETH, Base, SOL, TRX). REGRA: NUNCA seed/private key em git ou qualquer doc versionado. Enio fornece os endereços públicos. Publicar APENAS endereços públicos na página de venda. Avisar: (a) volatilidade de preço; (b) confirmações necessárias antes de liberar acesso; (c) política de reembolso em cripto (recomendação: não reembolsar em cripto, converter para BRL equivalente); (d) tributação BR: declarar como renda (magistério/IP); (e) custódia própria é OK, exchange também — decisão do Enio. Gate: Enio aprova endereços antes de publicar.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index ffcc3918..9654f3f4 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3665,3 +3665,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 📊 MATERIAL EVAL LOOP
 - [x] **MATERIAL-EVAL-LOOP-001** — capacidade implementada, testada, SSOT criado (`docs/capabilities/MATERIAL_EVAL_LOOP_SSOT.md`, §113)
 
+
+## Archived 2026-06-05
+
+### 🎓 EGOS FOUNDERS COURSE — produto educacional público (Enio 2026-06-04, "paguei minha dívida, agora prospero")
+- [x] **COURSE-FREE-TIER-001** [P1] `voz`+`prime` `gated:HITL` — Definir e publicar conteúdo gratuito útil que atrai para o curso: (a) qual o "útil já na parte gratuita" — proposta: 1 metaprompt pronto para download, 1 checklist de segurança de IA, 1 vídeo curto de 5min "o que é o EGOS Framework"; (b) onde fica: egos.ia.br + Telegram aberto + README do repo público; (c) o gratuito deve ser genuinamente útil — não teaser vazio. 🔄 2026-06-05: RASCUNHO pronto em `docs/drafts/free-artifact-egos-v0.md` (metaprompt + checklist + 3 opções de tom). PENDENTE corte Enio (5 pontos 🔴) + publicação HITL — NÃO fechar até publicar. ✅ 2026-06-05
+
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..91f02aa9 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Fri, 05 Jun 2026 12:24:30 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..91f02aa9 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Fri, 05 Jun 2026 12:24:30 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/_current_handoffs/FOR_GUARANI_2026-06-05_compass-self-discovery.md b/docs/_current_handoffs/FOR_GUARANI_2026-06-05_compass-self-discovery.md
new file mode 100644
index 00000000..6f5a06b5
--- /dev/null
+++ b/docs/_current_handoffs/FOR_GUARANI_2026-06-05_compass-self-discovery.md
@@ -0,0 +1,24 @@
+# FOR GUARANI — 2026-06-05 · Desenho do /compass (agente de autodescoberta)
+
+> Prime (Claude Code) pede a perspectiva do Guarani (Antigravity/Gemini) — async, na sua janela.
+> Contexto: Enio quer um agente que o ajude a FOCAR, lendo o rastro real do próprio trabalho.
+> Council multi-LLM está FORA (OPENROUTER_API_KEY ausente) — por isso peço a sua leitura aqui.
+
+## O que é o /compass (consenso até agora: Prime + Codex + Banda)
+
+O **menor espelho possível**: lê o histórico real de commits/tasks do Enio e devolve o *padrão de excitação* dele (onde a energia fluiu, o que levou longe vs largou) + UMA pergunta reflexiva. Para curar dispersão (422 commits/sem, 115 frentes) — não impondo Norte, mas REVELANDO qual excitação está mais viva.
+
+Base: framework Bashar (seguir a maior excitação + debugar a crença escondida), SEM metafísica (secular). Estudo: `docs/research/bashar-video-study.md`.
+
+## Decisões já travadas
+1. v1 **algorítmico, SEM LLM no output** (Codex): senão alucina padrão. Cada frase rastreável a uma linha de git log / TASKS.md.
+2. Agente **espelha, nunca decide** — Enio escolhe (HITL). Nunca "você É X", só "observei padrão X — o que sustenta?".
+3. **Privacidade radical**: conceitos, não pessoas. Só dado já na máquina (commits/tasks/telemetria). WhatsApp só depois de WA-PRIVACY-POLICY-001 + premortem.
+4. Guardrail anti-ironia: read-only, sem estado, e avisa se for rodado >3×/semana ("isto está virando o trabalho?").
+
+## Onde quero a SUA leitura (Guarani)
+- (a) O viés de "commit = excitação" — Codex propôs 4 correções (excluir META_SCOPES, cross-ref alive-blocked via TASKS, profundidade via shortstat, decay exponencial). Falta alguma?
+- (b) Você (Gemini/Antigravity) vê risco de governança/segurança que o Prime não viu no espelho ler o trabalho do Enio?
+- (c) Como o /compass conversa com o Mycelium (você refatorou ele) — o espelho de autodescoberta deveria VISUALIZAR no grafo vivo? ou são coisas separadas (One Job Per Screen)?
+
+Responda via `GUARANI_TO_PRIME_2026-06-05_*.md` quando puder. Sem pressa — Enio decide o build com o Prime.
diff --git a/docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md b/docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md
new file mode 100644
index 00000000..5e3317b9
--- /dev/null
+++ b/docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md
@@ -0,0 +1,44 @@
+# Sync GUARANI → PRIME — 2026-06-04
+
+> Para colar na janela destino. Se compartilham checkout `/home/enio/egos` + `.git/index`, leia antes de mexer no working tree (Zona Extrema ativa).
+> Score deste handoff: rode `bun scripts/handoff-fidelity.ts --file=docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md` (alvo ≥80/100).
+
+## O que GUARANI fez nesta sessão (com SHA — verificável)
+- `eaad7367` — Refatorou o Mycelium [MyceliumPage.tsx](file:///home/enio/egos/apps/egos-landing/src/components/MyceliumPage.tsx) de estático para o simulador conversacional inteligente com o Chatbot Tutor.
+- `d9dabe59` — Corrigiu o bug TDZ (`ReferenceError: Cannot access 'triggerSimulation' before initialization`) movendo a declaração de `triggerSimulation` para cima do `currentChatStep`.
+- `local_wip` — Adicionou a regra **R10** em [AGENTS.md](file:///home/enio/egos/AGENTS.md) e no [agent_scopes_and_governance.md](file:///home/enio/egos/docs/governance/agent_scopes_and_governance.md) regulamentando o fluxo de revisão do Prime, e o Council (Força Total) para segurança, DB e RLS.
+
+## Validação da última mensagem da outra janela
+- **Análise: CORRETA** — O Prime concluiu com excelência a implementação da tarefa `MYCELIUM-DYN-FE-001` e gerou a página de vendas, posts prontos e setup do HITL do Telegram.
+- **Correções:** O Prime corrigiu o bug TDZ no `MyceliumPage.tsx` reposicionando a declaração da função para sofrer hoisting adequado no React.
+
+## Decisões + opções rejeitadas
+- **Máquina de Estados Local:** Decidimos modelar o Chatbot Tutor com respostas ricas e simulações mockadas baseadas em states React no front-end, eliminando chamadas de LLM ativas na rede pública da landing page (evita custos indesejados e abuso de tokens).
+- **Isolamento de PII (R-SEC-002 [T0]):** As customizações e nomes que o usuário digita na conversa do Mycelium vivem unicamente na memória do componente React, sem gravação de log ou banco de dados no Supabase, mantendo a conformidade absoluta.
+
+## Snapshot dos todos de sessão (B)
+- [x] **MYCELIUM-LIVE-FE-001** — Implement Supabase Broadcast em `MyceliumPage.tsx` (concluído)
+- [x] **MYCELIUM-LIVE-FE-002** — Criar simulador interativo na landing page (concluído)
+- [x] **MYCELIUM-LIVE-BE-001** — Sanitizar e transmitir metadados nos webhooks e controllers de Whatsapp/Telegram (concluído)
+- [x] **MYCELIUM-LIVE-VERIFY-001** — Validar build do Vite e conexões de broadcast localmente (concluído)
+- [x] **GOV-COOP-001** — Codificar regra `R10` em `AGENTS.md` e sincronizar matriz de permissões (concluído)
+
+## Próximas tasks SEM conflito (divisão por janela)
+**Da janela destino (propõe diff, não commita):**
+- **MYCELIUM-DYN-FE-002** — Expandir templates de nicho do chatbot (ex: Escola, E-commerce).
+
+**Da janela origem (commita+pusha):**
+- Commit e push das regras locais de governança (`R10`).
+
+**Do Enio (Red Zone, não executar):**
+- Fornecer endereços de carteira cripto no `crypto-payment-setup.md`.
+- Aprovar posts de lançamento via Telegram HITL.
+
+## Estado retido / pendências
+- Commits locais não pushados: nenhum.
+- Frozen zones tocadas: `AGENTS.md` (regras canônicas R10) e `agent_scopes_and_governance.md` (permissões de agentes).
+
+## Regras de convivência (Zona Extrema)
+- Não acumular: commita/pusha antes de ≥5 commits ou ≥25 arquivos sujos.
+- Modelo de propriedade: destino **propõe**, origem **commita**. Red Zone = corte do Enio.
+- Nunca `governance:sync:exec` cegamente (INC-SYMLINK-001 — bloqueado nas pontas).
diff --git a/docs/governance/UI_PRODUCT_RULES.md b/docs/governance/UI_PRODUCT_RULES.md
new file mode 100644
index 00000000..5145c3db
--- /dev/null
+++ b/docs/governance/UI_PRODUCT_RULES.md
@@ -0,0 +1,129 @@
+# UI & Product Rules — One Job Per Screen + Publication Gate
+
+> **Tier:** T1 (integridade de produto/UX) · **SSOT único** desta família de regras.
+> **Origem (engenharia reversa de erro real):** página Mycelium ficou ~1 mês confusa porque
+> tentava ser 3 coisas na mesma tela — (a) mapa de topologia, (b) stream de eventos ao vivo,
+> (c) chatbot de vendas que renomeia nós. Nem o próprio Enio entendia. Codex + Banda Cognitiva
+> convergiram na causa-raiz. Corte Enio 2026-06-05: "vira regra pra não errarmos assim de novo,
+> e pra avaliarmos ANTES de publicar, sempre." Conserto que validou a regra: `c26573f7`.
+> **Liga:** [README_PADRAO_OURO](README_PADRAO_OURO.md) · CLAUDE.md §0.5 (Visual Proof) · §10 (Flow Validation).
+
+---
+
+## A regra-mãe
+
+```
+Uma tela principal tem UM trabalho dominante.
+Tudo que competir com esse trabalho vira camada secundária:
+painel lateral, aba, modo avançado, modal discreto ou página separada.
+```
+
+Se você não consegue dizer o trabalho da tela em **uma frase**, a tela está errada — divida.
+
+---
+
+## R-UI-001 — One Job Per Screen [T1]
+
+Cada tela/página/demo declara **um** trabalho dominante. Se houver dois trabalhos principais que disputam o centro visual → a tela DEVE ser dividida.
+
+**Teste de 5 segundos:** um estranho olha a tela por 5s e diz o que ela faz. Se ele lista 3 coisas ou hesita → falhou R-UI-001.
+
+**Sinais de violação (os 3 do incidente Mycelium):**
+- Mapa/visualização **e** chat de vendas na mesma área.
+- Visualização **e** modo-edição pesado competindo pelo foco.
+- Stream textual dominando uma tela cujo trabalho era visual.
+
+---
+
+## R-UI-002 — UI Intent Contract [T1, antes de implementar]
+
+Antes de escrever JSX/HTML de uma tela nova ou refatorar uma existente, declarar (no PR/handoff/commit body):
+
+```
+TELA: <nome>
+TRABALHO PRINCIPAL: <uma frase>
+USUÁRIO-ALVO: <quem>
+AÇÃO PRINCIPAL: <o que a pessoa faz>
+ESTADO INICIAL: <o que vê ao abrir, antes de qualquer ação>
+ESTADO DE SUCESSO: <como sei que a tela cumpriu o trabalho>
+NÃO FAZ: <o que esta tela explicitamente NÃO tenta fazer>
+```
+
+Sem o contrato declarado → não implementar. O campo **NÃO FAZ** é o que mata o "feature creep" na origem.
+
+---
+
+## R-UI-003 — No Competing Modes [T1]
+
+Não misturar, sem hierarquia explícita, na mesma área visual: **mapa · chat · stream · vendas · onboarding · edição pesada.**
+
+Convivência permitida só com hierarquia clara:
+- O trabalho principal ocupa o centro/maior área.
+- O resto vai para: `painel lateral` · `aba` · `modo avançado` · `modal discreto` · `página separada` · `fluxo posterior`.
+
+---
+
+## R-UI-004 — Live System Page Rule [T1]
+
+Se o trabalho da tela é **mostrar o sistema vivo**, o centro prioriza, nesta ordem:
+
+1. topologia (o que existe)
+2. conexões **desenhadas** (quem fala com quem — não contador, **linha**)
+3. nós + estado (ativo/degradado)
+4. pulsos animando a atividade real
+5. leitura visual rápida
+
+Chat, vendas, logs brutos e detalhes = **secundários**, em camada separada.
+
+> Regra nasceu porque a v0 do Mycelium dizia "Grafo" mas renderizava cards com contador
+> "N edges" — o fluxo era invisível. "Mostrar conexão" significa **desenhar a aresta**.
+
+---
+
+## R-UI-005 — Publication Gate [T1 — SEMPRE antes de publicar/deployar UI pública]
+
+Toda tela pública (landing, demo, página de produto) passa por este gate **antes** de deploy/publicação. Responder por escrito (handoff/commit/PR):
+
+```
+[ ] Qual é o trabalho PRINCIPAL desta tela? (uma frase)
+[ ] O que está competindo com esse trabalho? (e foi movido p/ camada secundária?)
+[ ] O usuário entende em 5 segundos o que está vendo?
+[ ] A tela impressiona SEM precisar de explicação longa?
+[ ] Ela PROVA o valor do EGOS ou CONFUNDE?
+[ ] Visual Proof real anexado (screenshot desktop + mobile, console limpo)? (liga CLAUDE.md §0.5)
+[ ] Mobile testado (não só desktop)?
+```
+
+Qualquer resposta negativa em 1-5 → **não publica**, refatora primeiro. Visual Proof ausente → §0.5/§10: é [CONCEPT], não pronto.
+
+---
+
+## R-UI-006 — Premortem de Tela Pública [T1 — antes de publicar]
+
+Antes de tornar uma tela pública, responder (o que aparecer vira ajuste antes do deploy):
+
+- Como essa tela pode ser **mal interpretada**?
+- O que parece **promessa vazia** / hype?
+- O que parece **confuso**?
+- O que é **bonito mas não funcional**?
+- O que está tentando **fazer coisas demais** (viola R-UI-001)?
+
+---
+
+## Aplicação retroativa
+
+| Tela | Status | Nota |
+|---|---|---|
+| Mycelium (`/mycelium`) | ✅ Conforme (pós `c26573f7`) | Trabalho único = sistema vivo. Grafo desenhado + pulsos. Chat demovido a guia colável. Mobile responsivo. |
+| Outras páginas do egos-landing | ⏳ Auditar | Task `UI-RULES-AUDIT-001`: passar home/timeline/showcase/transparencia/guard/grok/tools pelo gate R-UI-005. |
+
+---
+
+## Como vira ENFORCEMENT (não doc-morto — R-SEC-003)
+
+- **Manual hoje:** o gate R-UI-005 roda no review antes de `deploy.sh` de qualquer app de UI.
+- **A wirear (task `UI-PUBLICATION-GATE-WIRE-001`):** checklist executável no `apps/*/deploy.sh` que exige confirmação do gate + visual proof antes do rsync/publish. Espelha o Visual Proof Gate já existente no pre-commit.
+
+---
+
+*v1 — 2026-06-05 · Engenharia reversa do incidente Mycelium-3-jobs. SSOT desta família de regras de UI/produto.*
diff --git a/docs/jobs/2026-06-05-doc-drift-verifier.json b/docs/jobs/2026-06-05-doc-drift-verifier.json
index 7d7e9644..2f3b8f49 100644
--- a/docs/jobs/2026-06-05-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-05-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-05T00:45:48.823Z",
+  "verified_at": "2026-06-05T11:46:23.762Z",
   "summary": {
     "total_claims": 16,
     "passed": 15,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1332",
+      "current_value": "1340",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -124,7 +124,7 @@
       "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
       "status": "ok",
       "last_value": "19",
-      "current_value": "95",
+      "current_value": "96",
       "tolerance": "min:10",
       "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-05-handoff-fidelity.json b/docs/jobs/2026-06-05-handoff-fidelity.json
index 035e8334..9c46669c 100644
--- a/docs/jobs/2026-06-05-handoff-fidelity.json
+++ b/docs/jobs/2026-06-05-handoff-fidelity.json
@@ -11,5 +11,18 @@
     "todos_persisted": false,
     "decisions_captured": true,
     "completeness_score": 40
+  },
+  {
+    "ts": "2026-06-05T01:35:35.127Z",
+    "file": "docs/_current_handoffs/GUARANI_TO_PRIME_2026-06-04_mycelium_governance.md",
+    "done_claims": 8,
+    "done_with_sha": 2,
+    "claims_with_sha_pct": 25,
+    "inprogress_items": 0,
+    "inprogress_with_next": 0,
+    "inprogress_next_pct": 100,
+    "todos_persisted": true,
+    "decisions_captured": true,
+    "completeness_score": 70
   }
 ]
diff --git a/docs/jobs/2026-06-05-pre-commit-pipeline.json b/docs/jobs/2026-06-05-pre-commit-pipeline.json
index b4a04019..640e49c8 100644
--- a/docs/jobs/2026-06-05-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-05-pre-commit-pipeline.json
@@ -230,5 +230,77 @@
     "duration_ms": null,
     "event": "commit:docs files=2 sha=977c8e86",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T01:34:59.206Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=a390e0b9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T01:36:58.113Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=1e641765",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T11:46:24.265Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=c26573f7",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T11:58:49.620Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=2ec64505",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T11:59:52.524Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=4f809111",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:04:11.755Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=e05c4519",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:11:06.156Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=b94e86d4",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:15:17.008Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=666cf955",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:36:32.990Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=c9afa5e9",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/research/bashar-video-study.md b/docs/research/bashar-video-study.md
new file mode 100644
index 00000000..622e3d71
--- /dev/null
+++ b/docs/research/bashar-video-study.md
@@ -0,0 +1,62 @@
+# Estudo interno — Vídeo "Highest Excitement" (referência de terceiro)
+
+> **Status:** material INTERNO de estudo · **Criado:** 2026-06-05
+> ⚠️ **Conteúdo de terceiro (ensinamento atribuído a "Bashar").** Referência **inspiracional**, NÃO republicar a transcrição integral. Aqui só para extrair o *framework conceitual* aplicável ao EGOS.
+> **Fonte local:** `~/Downloads/WhatsApp Video 2026-06-05 at 08.50.24.mp4` (3:21, transcrito com whisper).
+> **Task:** BASHAR-VIDEO-STUDY-001. **Liga:** SELF-DISCOVERY-AGENT-SPEC-001, [[project_egos_preserves_concepts_not_people]].
+
+---
+
+## O framework (o conceito, não a metafísica)
+
+O EGOS aproveita a **estrutura operacional**, não a moldura espiritual. Secular, sem autoridade espiritual.
+
+**Fórmula de 3 partes:**
+1. **Aja na sua maior excitação** — entre as opções disponíveis em cada momento, escolha a que contém mais entusiasmo (ainda que só um pouco mais).
+2. **Até onde der** — leve à melhor da sua capacidade, até não poder mais.
+3. **Sem insistir no resultado** — sem exigir como/quando/qual forma o desfecho deve ter.
+
+**Mecanismo de crenças:**
+- Suas crenças/definições geram seus sentimentos → pensamentos → comportamentos.
+- Comportamento que você não prefere → rastreie de volta até uma crença que você assume verdadeira sem perceber.
+- Identificada a crença desalinhada, ela fica "ilógica" e cai sozinha. Se você não muda, ainda não achou a crença mais profunda — continue cavando.
+- "Viver mais no presente → você sabe o que precisa saber quando precisa saber."
+
+---
+
+## Por que isto importa para o EGOS (a ponte real)
+
+O agente de autodescoberta que o Enio quer É exatamente isto, operacionalizado sobre os dados que o EGOS **já coleta**. Mapeamento direto:
+
+| Bashar (conceito) | Mecanismo EGOS que já existe |
+|---|---|
+| "Maior excitação" = onde a energia flui | **Dispersion meter** + histórico de commits/scopes. Os 115 scopes/7d não são só "ruído" — são o **rastro de excitação** do Enio. O agente lê onde a energia foi, não onde "deveria" ir. |
+| "Até onde der" | Velocidade de commit por thread: o que foi levado longe vs abandonado no passo N. |
+| "Sem insistir no resultado" | Não forçar um Norte predeterminado. Observar o fluxo real (anti-viés de planejamento). |
+| "Espelho reflexivo revela crença desalinhada" | **Provenance + telemetria** = o espelho. O agente devolve padrões: "você começa X com energia alta e para no passo Y — que crença trava?" |
+| "Rastrear comportamento → crença" | Análise de padrão GLOBAL (GLOBAL-USER-PATTERN-001): ex. "capacidade construída repetidamente em vez de enviar" → qual crença? |
+| "Saber o que precisa quando precisa" | Just-in-time, /start carregando contexto sob demanda. |
+
+**Insight de design:** o EGOS não precisa de questionário psicológico — ele já tem o *rastro comportamental real* (commits, tasks, /start, /end, telemetria, Mycelium). O agente de autodescoberta lê esse rastro e devolve à pessoa **o espelho** dos próprios padrões de excitação e bloqueio — sem diagnosticar, sem prescrever.
+
+---
+
+## Limites DUROS (Red Zone — vão para a spec)
+
+- **Secular, não espiritual.** Usar o framework excitação/crença, NUNCA a moldura "entidade canalizada" nem autoridade espiritual.
+- Não diagnostica saúde mental · não substitui terapia · não dá conselho médico.
+- Não manipula emocionalmente · não cria dependência · não afirma conhecer a pessoa melhor que ela.
+- Sempre separa: **fato · padrão observado · hipótese · pergunta · sugestão.**
+- Inferência ≠ verdade. "Observei o padrão X" nunca vira "você é Y".
+
+---
+
+## Próximo (em SELF-DISCOVERY-AGENT-SPEC-001, com premortem)
+
+1. Spec do agente lendo o rastro real (commits/telemetria) como "mapa de excitação".
+2. Loop de reflexão: padrão observado → pergunta ("que crença sustenta isso?") → a pessoa responde → atomiza (sem PII, [[project_egos_preserves_concepts_not_people]]).
+3. Premortem obrigatório (dependência emocional, diagnóstico indevido, privacidade).
+
+---
+
+*Estudo interno · não republicar transcrição de terceiro · framework conceitual para uso EGOS.*

exec
/bin/bash -lc "nl -ba TASKS_ARCHIVE.md | tail -n 20 && nl -ba TASKS.md | sed -n '15,110p' && nl -ba docs/governance/UI_PRODUCT_RULES.md | sed -n '1,140p'" in /home/enio/egos
 succeeded in 139ms:
  3654	- [x] **README-COURSES-001** [P1] `curador` — Criar/atualizar README.md em docs/courses/ explicando a estrutura educacional: módulos, tom, como navegar, status (REAL/PARTIAL/ROADMAP).
  3655	
  3656	
  3657	## Archived 2026-06-05
  3658	
  3659	### 🎬 MODO GRAVAÇÃO + TUTOR MODULAR (Enio 2026-06-05)
  3660	- [x] **AUTORESEARCH-CRON-WIRE-001** [P1] `hermes-ops` — Wiring do autoresearch.ts no cron do VPS (último relatório: 2026-05-27, 10 dias atrás). Instalar: `0 7 * * 1 cd /opt/egos-git && bun scripts/autoresearch.ts --exec`. Verificar queries.json atualizado com temas de 2026: cursos de IA, x402, LGPD, cybersecurity, intelink.
  3661	
  3662	### 🔬 GEM-HUNTER + PESQUISA CONTÍNUA (2026-06-05)
  3663	- [x] **AIOX-RULES-INTEGRATE-001** [P2] `curador` — Revisar comparação aiox-rules vs EGOS-rules (docs/competitive-analysis/aiox-rules-vs-egos-rules.md) e identificar o que importar: Authority Model → Red Zone? Story-Driven → TASKS structure? Squad Marketplace → Skills marketplace?
  3664	
  3665	### 📊 MATERIAL EVAL LOOP
  3666	- [x] **MATERIAL-EVAL-LOOP-001** — capacidade implementada, testada, SSOT criado (`docs/capabilities/MATERIAL_EVAL_LOOP_SSOT.md`, §113)
  3667	
  3668	
  3669	## Archived 2026-06-05
  3670	
  3671	### 🎓 EGOS FOUNDERS COURSE — produto educacional público (Enio 2026-06-04, "paguei minha dívida, agora prospero")
  3672	- [x] **COURSE-FREE-TIER-001** [P1] `voz`+`prime` `gated:HITL` — Definir e publicar conteúdo gratuito útil que atrai para o curso: (a) qual o "útil já na parte gratuita" — proposta: 1 metaprompt pronto para download, 1 checklist de segurança de IA, 1 vídeo curto de 5min "o que é o EGOS Framework"; (b) onde fica: egos.ia.br + Telegram aberto + README do repo público; (c) o gratuito deve ser genuinamente útil — não teaser vazio. 🔄 2026-06-05: RASCUNHO pronto em `docs/drafts/free-artifact-egos-v0.md` (metaprompt + checklist + 3 opções de tom). PENDENTE corte Enio (5 pontos 🔴) + publicação HITL — NÃO fechar até publicar. ✅ 2026-06-05
  3673	
    15	> Princípio cravado: **"O EGOS não precisa guardar pessoas; preserva ideias, conceitos, padrões, decisões."**
    16	
    17	**Pendências de publicação (HITL — do artefato grátis):**
    18	- [ ] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte.
    19	- [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram aberto "EGOS Framework" → ao existir, completar o link no artefato grátis (Parte 3). (Já existia; reforçada aqui como dependência do artefato.)
    20	- [ ] **COURSE-FREE-TIER-001** — reaberta (rascunho ≠ publicado; ver acima). Fecha só ao publicar.
    21	
    22	**Regras de UI (FEITO nesta sessão — follow-ups):**
    23	- [ ] **UI-RULES-AUDIT-001** [P1] `pixel`+`prime` — Passar todas as páginas públicas do egos-landing (home/timeline/showcase/transparencia/guard/grok/tools) pelo Publication Gate R-UI-005 (`docs/governance/UI_PRODUCT_RULES.md`). Listar violações de One Job Per Screen + plano de refatoração.
    24	- [ ] **UI-PUBLICATION-GATE-WIRE-001** [P1] `forja` — Tornar o Publication Gate EXECUTÁVEL (não doc-morto, R-SEC-003): checklist no `apps/*/deploy.sh` exigindo confirmação do gate + visual proof antes do rsync/publish. Espelha o Visual Proof Gate do pre-commit.
    25	
    26	**Ferramenta local de download (yt-dlp já resolve):**
    27	- [ ] **LOCAL-IGDL-DOC-001** [P2] `prime` `PERSONAL_LOCAL_TOOL`/`NO_PUBLIC_DEPLOY`/`NO_MONETIZATION` — Documentar uso do `yt-dlp` (já instalado) como alternativa local ao sssinstagram (sem anúncios, sem monetização). Diagnóstico curto em `docs/tools/local-video-download.md`: limites legais/éticos (só conteúdo próprio/autorizado, não burlar DRM/paywall, não redistribuir, não versionar cookies/sessão). NÃO construir ferramenta nova — yt-dlp basta (Karpathy mínimo). Premortem antes de qualquer wrapper.
    28	
    29	**Vídeo Bashar (transcrição interna):**
    30	- [ ] **BASHAR-VIDEO-STUDY-001** [P1] `prime`+`curador` `internal-only` — Transcrição do vídeo local (rodando whisper nesta sessão) → resumo + notas de aplicação ao EGOS em `docs/research/bashar-video/` (resumo + egos-application-notes, SANITIZADO). Vídeo de terceiro = referência inspiracional, NÃO copiar/publicar transcrição integral. Insumo p/ o agente de autodescoberta.
    31	
    32	**Agente EGOS de autodescoberta (Red Zone — limites psicológicos):**
    33	- [ ] **SELF-DISCOVERY-AGENT-SPEC-001** [P1] `redzone` `gated:HITL` — Especificar agente que conduz a pessoa a navegar em si mesma (mapear interesse/energia/padrões/direção). Spec + Red Zones + prompts em `docs/agents/self-discovery-agent*.md`. Limites DUROS: não diagnostica saúde mental, não substitui terapia, não manipula, não cria dependência, não afirma conhecer a pessoa melhor que ela; sempre separa fato/padrão/hipótese/pergunta/sugestão. Premortem obrigatório antes de implementar.
    34	- [ ] **GLOBAL-USER-PATTERN-001** [P2] `curador` `gated:HITL` — Plano de análise do padrão GLOBAL do usuário (commits + tasks + /start + /end + provenance + telemetria + Mycelium), não só por área. Classificar REAL/PATTERN/HYPOTHESIS/QUESTION/UNKNOWN. Sem psicologizar sem evidência. `docs/research/user-patterns/global-pattern-analysis-plan.md`. NÃO executar análise invasiva sem HITL.
    35	
    36	**Privacidade radical — ingestão WhatsApp (P0 política ANTES de qualquer ingest):**
    37	- [ ] **WA-PRIVACY-POLICY-001** [P0] `guardiao`+`redzone` `gated:HITL` — Política "no raw messages": mensagem bruta NUNCA vai pro computador/VPS/GitHub com nome/telefone/lugar/situação específica. Camada de tratamento NA FONTE: remoção de PII → generalização → atomização → conceito → armazenamento. SSOT `docs/privacy/whatsapp-ingestion-privacy-model.md` + `no-raw-messages-policy.md`. Classes: IDEA/CONCEPT/PATTERN/QUESTION/DECISION/EMOTION_SIGNAL/TASK_SIGNAL/RELATIONSHIP_PATTERN/PROJECT_SIGNAL. Liga R-SEC-002 [T0]. Premortem obrigatório. NENHUMA ingestão real antes desta política + corte Enio.
    38	- [ ] **CONCEPT-ATOMIZATION-MODEL-001** [P1] `curador` `gated:WA-PRIVACY-POLICY-001` — Modelo de atomização: vivido → remove identificável → reconstrói conhecimento útil sem dado pessoal. `docs/architecture/concept-atoms.md`. Exemplo: "João me disse em Patos..." → "pessoa próxima relatou situação de confiança/frustração em contexto social".
    39	- [ ] **PROV-TELEM-MYCELIUM-MAP-001** [P2] `prime` — Mapa de como provenance/telemetria/Mycelium/start/end/pre-commit/commits entram na arquitetura de autodescoberta com privacidade (fonte/tipo/risco/tratamento/uso permitido/uso proibido/retenção/HITL). `docs/architecture/provenance-telemetry-mycelium-integration.md`.
    40	- [ ] **PREMORTEM-SELF-DISCOVERY-001** [P0] `redzone` — Rodar `/premortem` antes de QUALQUER implementação de ingestão WhatsApp / ferramenta local / agente autodescoberta: o que pode vazar? expor terceiros? virar diagnóstico indevido? gerar dependência emocional? violar direitos/ToS? ir pro GitHub por acidente? `docs/audit/premortem-self-discovery-and-ingestion.md`.
    41	
    42	## 🎯 KYTE BENCHMARK & GAP-CLOSE — tarefa PRINCIPAL (Enio 2026-06-03)
    43	
    44	> **Contexto:** Enio usou o Kyte (IA-first, estilo de empresa que admira), achou pontos de melhora vs o que o EGOS já tem. Vídeo do interior do Kyte: `~/Videos/Screencasts/Screencast from 2026-06-03 13-04-53.mp4`. Objetivo: mapear o que Kyte tem (que ele tentou em gpecas/forja e não conseguiu), comparar com o nosso, achar o gap REAL (experiência? foco? expertise? design? organização?) e CONSTRUIR/melhorar com toda a estrutura de agentes (Banda + Council + Codex review). **Para mostrar a um contato de empresa IA-first que ele admira.**
    45	- [ ] **KYTE-PRESENT-001** [P1] `redzone` — Material p/ mostrar ao contato IA-first (Red Zone: copy/posicionamento → corte Enio).
    46	
    47	## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
    48	- [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
    49	- [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
    50	
    51	## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
    52	> Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
    53	- [ ] **FE-BE-SYNC-GATE-001** [P1] `forja` — Implementar o gate que mede razão frontend/backend e, quando backend evolui >20% além do FE, GERA tasks priorizadas de frontend (não bloqueia). Regra em `CLAUDE.md §Convenções`. Definir métrica (ex: LOC/endpoints BE vs telas/componentes FE) + onde roda (pre-commit advisory ou `/start`).
    54	- [ ] **TOOLS-PAGE-COMPLETE-001** [P1] — `egos.ia.br/tools` completa: todas as tools disponíveis (BE+FE) p/ testar ao vivo, entrada correta, documentadas, com metaprompts. 🔄 PARCIAL 2026-06-04: hub `#/tools` LIVE (Guard Brasil + Item Intake + Mycelium). Falta: metaprompts inline por tool + docs "como usar". Próx: MP-ITEM-INTAKE-001 como aba no hub.
    55	- [ ] **GITHUB-AUDIT-FULL-001** [P2] — Timeline dos 40 repos GitHub (22 não-clonados localmente): `gh api` por repo. Parcial FEITO: `docs/audits/github-activity-timeline.md` (18 repos clonados).
    56	- [ ] **PUBLIC-REPO-DOCS-001** [P2] `curador` `redzone` — Publicar docs do EGOS Framework em repo PÚBLICO p/ agentes de IA navegarem (README "For AI Agents" → arquitetura → regras → metaprompts). Checklist de sanitização antes (sem segredo/VPS/PII). HITL.
    57	- [ ] **PROVENANCE-UNIFY-002** [P3] — Avaliar unificar os sistemas de proveniência fragmentados (`provenance.py` br-acc/omniview · `provenance.ts` kernel/guard-brasil · intelink hash-chain) num módulo `@egos/provenance` reusável. Só se valer (não over-eng).
    58	
    59	## 🔄 DOCUMENTAR PROCESSOS → GERAR METAPROMPT (loop, Enio 2026-06-04, ordem)
    60	> Já temos: `docs/governance/PROCESS_CONTRACTS.md` (meta-formato que INDEXA processos) + gerador (`apps/api/src/routes/meta-prompts.ts`, 6 templates) + `docs/metaprompts/` (14 saídas). O loop "processo documentado → metaprompt gerado pelo gerador" NÃO está wirado. Princípio: documentar enquanto trabalhamos (document-as-we-go), refinando o processo.
    61	- [ ] **PROCESS-DOC-INVENTORY-001** [P1] `curador` — Auditar cobertura de Process Contracts: quais ações recorrentes já têm contrato em `PROCESS_CONTRACTS.md` vs lacunas (ex: deploy, /start, /end, disseminate, operating-surface-gen, item-intake). Saída = índice + lista de processos sem contrato, priorizada.
    62	- [ ] **PROCESS-METAPROMPT-LOOP-001** [P1] `forja` — Wirar o loop: Process Contract → gerador de metaprompts → metaprompt em `docs/metaprompts/` → eval golden. Avaliar add template `process` no gerador (`meta-prompts.ts`) que consome um contrato e emite o metaprompt. Implementar o drift-guard CONCEPT do `GENERATOR_CONTRACT.md` (validar template_ids vs `Object.keys(TEMPLATES)` no pre-commit).
    63	- [ ] **PROCESS-DOC-REFINE-ONGOING** [P2] `prime` — Regra de fluxo: toda ação recorrente nova/refinada nesta e nas próximas sessões ganha (a) Process Contract e (b) metaprompt gerado. Document-as-we-go. Liga proveniência-por-ação (§1).
    64	
    65	## 📱 WHATSAPP READ+TRANSCRIBE (Enio AUTORIZOU + assumiu responsabilidade 2026-06-04)
    66	> Enio autorizou explicitamente ler a conversa com o contato **Vitor Timóteo / One Life Media** ([TELEFONE-REDACTED]), transcrever os áudios e entender. Gate ético = liberado por HITL.
    67	> CAUSA-RAIZ do "blocker" anterior (corrigida 2026-06-04): a conversa SEMPRE esteve acessível na instância `enio-personal` (5534992374363, Evolution, conectada). As buscas por NÚMERO falhavam porque o WhatsApp usa JID opaco `@lid` (`158003659542642@lid`), não o telefone. Achei pelo HORÁRIO no Postgres do Evolution. Lição: buscar por timestamp+tipo quando número não bate (JID @lid). <!-- scan-ok: id-de-instância-não-é-cartão-sus -->
    68	- [ ] **BIZ-OFFER-INHOUSE-001** [P1] `redzone` 🆕 — Executar in-house o que o Vitor venderia (oferta produtizada + funil simples + posicionamento), mas ENTITY-FIRST (EGOS é a face, não marca-pessoal-do-Enio; trava policial-ativo) e alinhado às decisões já cravadas (`feedback_tone_work_first_no_badge`, `project_egos_definition_and_provenance_rule`, `ENIO_CURRICULUM_POSITIONING`). ESTENDER `docs/strategy/EGOS_OFFERING_CATALOG.md` (não duplicar). Janela focada/Sonnet. Draft → corte Enio → só então público (HITL T0).
    69	- [ ] **BIZ-VITOR-FOLLOWUP-001** [P2] `voz` 🆕 — Enviar a resposta ao Vitor (rascunho v2 aprovado: troca-justa, paga piso cheio quando ganhar, EGOS-entidade, porta aberta). HITL: Enio envia.
    70	
    71	## 💸 TOKEN/MODELO/ROTEAMENTO — auditoria (Enio 2026-06-04) → SSOT `docs/governance/TOKEN_MODEL_ROUTING_AUDIT.md`
    72	> Achados REAIS: Opus = 87,6% do custo ($21.570 hist.); cache_read em sessão longa = 5× vs Sonnet; `check-model-usage.ts` MISSING (maior alavanca); `context-alarm.sh` perdeu os dentes (2026-05-22); gem-hunter SSOT.md aponta errado (egos-lab vs kernel v6.1); session-start.sh não reseta pós-compact apesar de §5.1 afirmar.
    73	- [ ] **TOKEN-DELEGATE-HAIKU-001** [P2] `prime` — Rotear fan-out mecânico (batch, extração, classificação) p/ Haiku/Sonnet via OpenRouter (Haiku hoje = 0,3% do uso; 10-20× mais barato/task) (E-03).
    74	
    75	## 🧩 PADRÃO DE REPORT + READ-ANY→READ-WHOLE (Enio 2026-06-04, modelo orquestrador)
    76	> Visão Enio: todo agente reporta num PADRÃO ÚNICO (humano = smartlinks+explicado; IA = provenance+links p/ SSOT). Modelos fracos consultam as MESMAS fontes (SSOT) sempre com proveniência → acertam o report. Se um agente de IA lê QUALQUER parte do EGOS, acaba lendo o sistema inteiro (intelink fractal) → se adapta e sugere melhorias. ESTADO REAL (verificado 2026-06-04): `@egos/report-standard` (packages/report-standard/, "Report SSOT v2.0.0 — schema+validator+types") JÁ EXISTE mas NÃO está enforçado/herdado pelos agentes (reports curador/forja foram free-form). `egos` CLI instalado (~/.local/bin/egos = comms human-AI-device: send/relay/ping/repos/ecosystem). Entry points existem (README→AGENTS→SYSTEM_MAP→AGENT_BOOTSTRAP→EGOS_BOOTSTRAP).
    77	- [ ] **REPORT-STANDARD-ENFORCE-001** [P1] `prime`+`curador` — Wirar `@egos/report-standard` v2.0.0 como OBRIGATÓRIO: todo meta-prompt de papel (.claude/agents/*.md + metaprompt-generator) herda o contrato de report (provenance-per-claim, links p/ SSOT, formato humano c/ smartlinks). Sinergia com METAPROMPT-SHARPEN (workflow wave-1). Gap = schema existe, falta enforcement.
    78	- [ ] **READ-ANY-READ-WHOLE-001** [P1] `curador` — Garantir intelink fractal: todo doc/SSOT/report linka ao seu SSOT-pai + ao entry map (AGENTS.md). Meta: agente de IA entrando por qualquer ponto navega o sistema inteiro. Auditar cobertura de links + preencher buracos.
    79	- [ ] **GEMHUNTER-STUB-ARCHIVE-001** [P2] `curador` `gated:HITL` — Arquivar/decidir destino do stub `/home/enio/gem-hunter/` (repo standalone, sinalizado DEPRECATED). Corte Enio: mover p/ _archived ou manter como pacote publicável.
    80	- [ ] **SYSTEM-MAP-CLEANUP-001** [P2] `sentinela` — SYSTEM_MAP.md:38/245 + SSOT.md:38 (gem-hunter-freshness aponta egos-lab). NOTA: curador alegou packages/gem-hunter/ fantasma — FALSO (existe package.json). Re-auditar refs gem-hunter.
    81	
    82	## 🤖 AGENTE EGOS PÚBLICO + BYOK (Enio 2026-06-04, pesquisa curador verificada)
    83	> Visão: bot Telegram + egos.ia.br/terminal como janelas públicas que MOSTRAM capacidade; modelo barato default (Gemini 2.5 Flash, já é default do orchestrator) + BYOK fluido p/ modelo caro. ESTADO REAL (curador, provenance): @egosin_bot LIVE só auth-locked p/ Enio (telegram.ts); OpenRouter integrado (orchestrator.ts:50); **BYOK JÁ EXISTE** em egos-inteligencia (header x-openrouter-key ephemeral, chat.py:881) + 852 (byok-manager.ts) — PHANTOM no egos-gateway; /terminal=PHANTOM; AnythingLLM local:3001 c/ OpenRouter+Flash+BYOK nativo (candidato a /terminal via Caddy). MVP=adaptar, não criar (~7-12h). Liga IHV-DISS-002.
    84	
    85	## 🔗 INTELINK DEMO PÚBLICA AGENTIC (Enio 2026-06-04)
    86	> Missão: build NOVO isolado (intelink.egos.ia.br) — dados 100% SINTÉTICOS (IDs SYN-*), Busca Global + Timeline núcleo, agentic (9 agentes), transparência radical segura. TRAVA GUARDIÃO: Intelink real = PCMG/PII (Enio policial ativo) → NUNCA tocar/anonimizar dado real (sintético na origem); deploy/público = HITL. Workflow wf_c3ce671f-9f6 produz planos (não publica).
    87	- [ ] **BLOCKCHAIN-PROV-001** [P2] `guardiao` — Documentar proveniência via blockchain (Sigstore-first) p/ auditabilidade de dado/consentimento, nível paranoico. Liga BLOCKCHAIN-002-ETHIK-LEGAL (Red Zone $ETHIK).
    88	
    89	## 🍄 MYCELIUM — egos.ia.br/mycelium (sistema vivo, Enio já pediu antes)
    90	> Página que mostra o EGOS trabalhando AO VIVO. Ocioso → batimento Hermes (always-on) + tiles de serviço; ativo → cada call/agente/workflow/commit pulsa. Arquitetura 3 camadas: SINK (tabela mycelium_events Supabase, eventos sanitizados {type,source,status,ts}, NUNCA payload/secret/PII) → READ (SSE no Hermes/gateway, público=agregado sanitizado, auth=detalhe) → FRONTEND (egos-site, reusa apps/_archived/commons/src/lib/mycelium.ts). Honest: público mostra camada always-on (VPS/MCP/serviços via egos-observability pm2_status); sessões Claude Code precisam de bridge ~/.egos/*.jsonl→sink (decisão Enio: a=só-VPS b=bridge). Liga /mycelium skill (Kernel Reality Check).
    91	- [ ] **CONTEXT-ALARM-RESTORE-001** [P2] `hermes-ops` `redzone` — Restaurar dente do `context-alarm.sh` (threshold/freeze removidos 2026-05-22) + consolidar 3 hooks de custo sobrepostos (context-alarm/session-status/budget-guard) (L-02, L-06 — corte Enio: bloqueante ou aviso?).
    92	- [ ] **SESSION-START-RESET-001** [P2] `forja` — Consertar divergência doc/código: `session-start.sh` não reseta contadores pós-compact apesar de CLAUDE.md §5.1 afirmar (proveniência-por-ação).
    93	- [ ] **GEMHUNTER-QUEUE-BUG-001** [P3] `forja` — Verificar `queueForAutoIntegration()` no gem-hunter v6.1 (órfã suspeita no premortem 2026-05-30): bug ativo ou dead-code? (L-05).
    94	- [ ] **CONTEXT-AUDIT-RERUN-001** [P3] — Re-rodar `context-audit.ts` (última ~2026-05-06; skills cresceram) p/ atualizar math 49k vs 275k overhead (E-05).
    95	
    96	## 🎓 EGOS FOUNDERS COURSE — produto educacional público (Enio 2026-06-04, "paguei minha dívida, agora prospero")
    97	> **Banda:** Crítico=RESSALVAS · Apoiador=RESSALVAS · Questionador=RECUSAR programa completo · **Maestro=APROVADO MVP mínimo**
    98	> **MVP lote R$8:** (1) aula inaugural 45-60min — demo Guard Brasil ao vivo; (2) PDF "método EGOS em uma página"; (3) acesso ao WhatsApp privado "EGOS" (lifetime); (4) acesso antecipado módulos futuros.
    99	> **Nome recomendado:** "EGOS: Governança de IA para Investigadores" · **Gate:** corte Enio no texto + verificação estatuto PCMG antes de qualquer cobrança.
   100	> **Produto:** lifetime access · Telegram aberto (gratuito, qualquer pessoa) · WhatsApp "EGOS" privado (pago) · Hotmart principal + multi-plataforma possível + egos.ia.br · unidades limitadas por plataforma · preço pode mudar a qualquer momento.
   101	
   102	- [ ] **COURSE-MVP-CONTENT-001** [P1] `voz`+`prime` `gated:HITL` 🔴 — Produzir conteúdo do MVP lote R$8: (1) roteiro da aula inaugural ("Por que GOVERNAR IA? O custo de confiar cego." — demo Guard Brasil pii-patterns.ts ao vivo, 45-60min); (2) PDF "O método EGOS em uma página" (extraído de AGENTS.md + RESOLVER_DOCTRINE.md + CLAUDE.md §0.5 — sem produção nova); (3) descrição do que o comprador recebe hoje vs roadmap. HITL: corte Enio no texto antes de publicar. NUNCA prometer o que é concept.
   103	- [ ] **COURSE-HOTMART-SETUP-001** [P1] `prime` `gated:HITL` — Configurar produto no Hotmart: (a) conta PF (verificar: Hotmart aceita sem CNPJ? sim, via CPF); (b) produto tipo "curso evolving" ou "produto digital"; (c) preço R$8 com label "Lote Fundador — pode subir a qualquer momento"; (d) Pix + boleto + cartão ativos; (e) lifetime access configurado; (f) webhook de pós-compra para adicionar ao WhatsApp privado. HITL: Enio valida a configuração antes de ativar.
   104	- [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram público "EGOS Framework" (aberto, gratuito, qualquer pessoa): (a) descrição do grupo; (b) regras de convivência; (c) link fixo para divulgação; (d) bot de boas-vindas automático (opcional). Tópicos: uso de IA com método, agentes, metaprompts, workflows, governança, segurança, automação, prompt engineering, AI-First, casos de uso, dúvidas do framework.
   105	- [ ] **COURSE-WHATSAPP-PRIVATE-001** [P1] `prime` `gated:HITL` — Configurar grupo WhatsApp privado "EGOS" (só quem pagou): (a) nome do grupo: "EGOS"; (b) escopo: discussão do EGOS Framework, metaprompts, agentes, workflows, casos de uso, dúvidas, roadmap, conteúdo em evolução — sempre com método, sem hype; (c) regras: sem vazamento de dados pessoais, sem casos reais sensíveis, uso ético; (d) mecanismo de adicionar pós-compra (webhook Hotmart → adicionar número via Evolution API ou manual). Gate: Enio aprova regras antes de criar.
   106	- [ ] **COURSE-PAYMENT-EASY-001** [P1] `prime` — Configurar pagamento com poucos cliques: (a) Hotmart checkout com Pix em destaque (instantâneo, sem taxa para comprador); (b) link direto para o produto (curto, fácil de copiar); (c) testar fluxo completo: clicar → pagar → receber acesso (deve ser < 3 cliques); (d) testar no celular (maioria vai comprar pelo WhatsApp/Telegram). Smoketeste obrigatório antes de divulgar.
   107	- [ ] **COURSE-REPOS-AUDIT-001** [P0] `guardiao`+`prime` `gated:HITL` — Auditar TODOS os repositórios antes de qualquer mudança de visibilidade. Resultado do workflow (14 agentes): classificação completa em PUBLIC_DOCS/PUBLIC_DEMO/PRIVATE_CORE/PRIVATE_SECURITY/PRIVATE_PCMG/ARCHIVE/NEEDS_REVIEW disponível em docs/audit/repositories-public-private-classification.md (a criar). NENHUM repo abre ou fecha sem auditoria + HITL do Enio. Prioridade: qual repo público principal (candidato: egos-governance já público, mas enxuto — candidato principal para ser o hub educacional).
   108	- [ ] **COURSE-OWN-PLATFORM-001** [P2] `pixel`+`prime` — Pesquisar e configurar venda direta via egos.ia.br: (a) é possível aceitar Pix direto na plataforma própria? (Asaas PF: sim, taxa ~2.99% Pix); (b) criar página de produto em egos.ia.br/founders; (c) checkout simples (gera link de pagamento Asaas → paga → acesso automático); (d) vantagem: sem taxa de plataforma (vs Hotmart ~9.9%); desvantagem: sem audiência da plataforma. Recomendação esperada: Hotmart principal + egos.ia.br como opção direta.
   109	- [ ] **COURSE-CRYPTO-WALLETS-001** [P2] `prime` `gated:HITL` 🔴 — Configurar recebimento em cripto (BTC, ETH, Base, SOL, TRX). REGRA: NUNCA seed/private key em git ou qualquer doc versionado. Enio fornece os endereços públicos. Publicar APENAS endereços públicos na página de venda. Avisar: (a) volatilidade de preço; (b) confirmações necessárias antes de liberar acesso; (c) política de reembolso em cripto (recomendação: não reembolsar em cripto, converter para BRL equivalente); (d) tributação BR: declarar como renda (magistério/IP); (e) custódia própria é OK, exchange também — decisão do Enio. Gate: Enio aprova endereços antes de publicar.
   110	- [ ] **COURSE-SALES-PAGE-001** [P1] `voz` `gated:HITL` — Criar página de venda inicial em docs/business/founders-course-sales-page.md (gerado pelo workflow — revisar e finalizar). Critérios obrigatórios: (a) promessa honesta — sem "único no Brasil", "garantido", "transformação"; (b) o que recebe HOJE vs roadmap são claramente separados; (c) label "Preço pode mudar a qualquer momento — não há lotes fixos"; (d) lifetime access explícito; (e) FAQ com "O que acontece se o preço subir? Você já pagou — acesso garantido para sempre."; (f) formas de pagamento listadas; (g) corte do Enio antes de publicar.
     1	# UI & Product Rules — One Job Per Screen + Publication Gate
     2	
     3	> **Tier:** T1 (integridade de produto/UX) · **SSOT único** desta família de regras.
     4	> **Origem (engenharia reversa de erro real):** página Mycelium ficou ~1 mês confusa porque
     5	> tentava ser 3 coisas na mesma tela — (a) mapa de topologia, (b) stream de eventos ao vivo,
     6	> (c) chatbot de vendas que renomeia nós. Nem o próprio Enio entendia. Codex + Banda Cognitiva
     7	> convergiram na causa-raiz. Corte Enio 2026-06-05: "vira regra pra não errarmos assim de novo,
     8	> e pra avaliarmos ANTES de publicar, sempre." Conserto que validou a regra: `c26573f7`.
     9	> **Liga:** [README_PADRAO_OURO](README_PADRAO_OURO.md) · CLAUDE.md §0.5 (Visual Proof) · §10 (Flow Validation).
    10	
    11	---
    12	
    13	## A regra-mãe
    14	
    15	```
    16	Uma tela principal tem UM trabalho dominante.
    17	Tudo que competir com esse trabalho vira camada secundária:
    18	painel lateral, aba, modo avançado, modal discreto ou página separada.
    19	```
    20	
    21	Se você não consegue dizer o trabalho da tela em **uma frase**, a tela está errada — divida.
    22	
    23	---
    24	
    25	## R-UI-001 — One Job Per Screen [T1]
    26	
    27	Cada tela/página/demo declara **um** trabalho dominante. Se houver dois trabalhos principais que disputam o centro visual → a tela DEVE ser dividida.
    28	
    29	**Teste de 5 segundos:** um estranho olha a tela por 5s e diz o que ela faz. Se ele lista 3 coisas ou hesita → falhou R-UI-001.
    30	
    31	**Sinais de violação (os 3 do incidente Mycelium):**
    32	- Mapa/visualização **e** chat de vendas na mesma área.
    33	- Visualização **e** modo-edição pesado competindo pelo foco.
    34	- Stream textual dominando uma tela cujo trabalho era visual.
    35	
    36	---
    37	
    38	## R-UI-002 — UI Intent Contract [T1, antes de implementar]
    39	
    40	Antes de escrever JSX/HTML de uma tela nova ou refatorar uma existente, declarar (no PR/handoff/commit body):
    41	
    42	```
    43	TELA: <nome>
    44	TRABALHO PRINCIPAL: <uma frase>
    45	USUÁRIO-ALVO: <quem>
    46	AÇÃO PRINCIPAL: <o que a pessoa faz>
    47	ESTADO INICIAL: <o que vê ao abrir, antes de qualquer ação>
    48	ESTADO DE SUCESSO: <como sei que a tela cumpriu o trabalho>
    49	NÃO FAZ: <o que esta tela explicitamente NÃO tenta fazer>
    50	```
    51	
    52	Sem o contrato declarado → não implementar. O campo **NÃO FAZ** é o que mata o "feature creep" na origem.
    53	
    54	---
    55	
    56	## R-UI-003 — No Competing Modes [T1]
    57	
    58	Não misturar, sem hierarquia explícita, na mesma área visual: **mapa · chat · stream · vendas · onboarding · edição pesada.**
    59	
    60	Convivência permitida só com hierarquia clara:
    61	- O trabalho principal ocupa o centro/maior área.
    62	- O resto vai para: `painel lateral` · `aba` · `modo avançado` · `modal discreto` · `página separada` · `fluxo posterior`.
    63	
    64	---
    65	
    66	## R-UI-004 — Live System Page Rule [T1]
    67	
    68	Se o trabalho da tela é **mostrar o sistema vivo**, o centro prioriza, nesta ordem:
    69	
    70	1. topologia (o que existe)
    71	2. conexões **desenhadas** (quem fala com quem — não contador, **linha**)
    72	3. nós + estado (ativo/degradado)
    73	4. pulsos animando a atividade real
    74	5. leitura visual rápida
    75	
    76	Chat, vendas, logs brutos e detalhes = **secundários**, em camada separada.
    77	
    78	> Regra nasceu porque a v0 do Mycelium dizia "Grafo" mas renderizava cards com contador
    79	> "N edges" — o fluxo era invisível. "Mostrar conexão" significa **desenhar a aresta**.
    80	
    81	---
    82	
    83	## R-UI-005 — Publication Gate [T1 — SEMPRE antes de publicar/deployar UI pública]
    84	
    85	Toda tela pública (landing, demo, página de produto) passa por este gate **antes** de deploy/publicação. Responder por escrito (handoff/commit/PR):
    86	
    87	```
    88	[ ] Qual é o trabalho PRINCIPAL desta tela? (uma frase)
    89	[ ] O que está competindo com esse trabalho? (e foi movido p/ camada secundária?)
    90	[ ] O usuário entende em 5 segundos o que está vendo?
    91	[ ] A tela impressiona SEM precisar de explicação longa?
    92	[ ] Ela PROVA o valor do EGOS ou CONFUNDE?
    93	[ ] Visual Proof real anexado (screenshot desktop + mobile, console limpo)? (liga CLAUDE.md §0.5)
    94	[ ] Mobile testado (não só desktop)?
    95	```
    96	
    97	Qualquer resposta negativa em 1-5 → **não publica**, refatora primeiro. Visual Proof ausente → §0.5/§10: é [CONCEPT], não pronto.
    98	
    99	---
   100	
   101	## R-UI-006 — Premortem de Tela Pública [T1 — antes de publicar]
   102	
   103	Antes de tornar uma tela pública, responder (o que aparecer vira ajuste antes do deploy):
   104	
   105	- Como essa tela pode ser **mal interpretada**?
   106	- O que parece **promessa vazia** / hype?
   107	- O que parece **confuso**?
   108	- O que é **bonito mas não funcional**?
   109	- O que está tentando **fazer coisas demais** (viola R-UI-001)?
   110	
   111	---
   112	
   113	## Aplicação retroativa
   114	
   115	| Tela | Status | Nota |
   116	|---|---|---|
   117	| Mycelium (`/mycelium`) | ✅ Conforme (pós `c26573f7`) | Trabalho único = sistema vivo. Grafo desenhado + pulsos. Chat demovido a guia colável. Mobile responsivo. |
   118	| Outras páginas do egos-landing | ⏳ Auditar | Task `UI-RULES-AUDIT-001`: passar home/timeline/showcase/transparencia/guard/grok/tools pelo gate R-UI-005. |
   119	
   120	---
   121	
   122	## Como vira ENFORCEMENT (não doc-morto — R-SEC-003)
   123	
   124	- **Manual hoje:** o gate R-UI-005 roda no review antes de `deploy.sh` de qualquer app de UI.
   125	- **A wirear (task `UI-PUBLICATION-GATE-WIRE-001`):** checklist executável no `apps/*/deploy.sh` que exige confirmação do gate + visual proof antes do rsync/publish. Espelha o Visual Proof Gate já existente no pre-commit.
   126	
   127	---
   128	
   129	*v1 — 2026-06-05 · Engenharia reversa do incidente Mycelium-3-jobs. SSOT desta família de regras de UI/produto.*

exec
/bin/bash -lc "date -u -d '2026-06-05 12:24:30' '+%a, %d %b %Y %H:%M:%S GMT'" in /home/enio/egos
 succeeded in 101ms:
Fri, 05 Jun 2026 12:24:30 GMT

exec
/bin/bash -lc 'git log --oneline --decorate e05c45193eb01f36d83210dee1187b98ffcf4bec..HEAD' in /home/enio/egos
 succeeded in 146ms:
c9afa5e9 (HEAD -> main, origin/main) chore(sync): tasks 2026-06-05 + handoffs Guarani↔Prime (compass design + mycelium gov)
666cf955 docs(research): estudo interno do vídeo 'highest excitement' (framework Bashar) → ponte p/ agente de autodescoberta
b94e86d4 feat(governance): regras de UI/produto (One Job Per Screen + Publication Gate) — engenharia reversa do erro Mycelium

exec
/bin/bash -lc "nl -ba CLAUDE.md | sed -n '78,92p'" in /home/enio/egos
 succeeded in 100ms:
    78	- **Frozen Zones:** `agents/runtime/runner.ts`, `agents/runtime/event-bus.ts`, `.husky/pre-commit`, `.guarani/orchestration/PIPELINE.md`
    79	- **Conflict rule:** em conflito com `.guarani`, **`.guarani` prevalece**
    80	
    81	---
    82	
    83	## Convenções
    84	
    85	- Commits: conventional, cada 30-60min
    86	- TypeScript: estrito, zero `any` implícito
    87	- DRY-RUN: todo agent suporta `--dry` antes de `--exec`
    88	- Edit Size: máx 80 linhas por operação de escrita
    89	- **UI/Produto [T1 — Enio 2026-06-05]:** uma tela = UM trabalho dominante; o que competir vira camada secundária. Antes de publicar QUALQUER tela pública, rodar o **Publication Gate (R-UI-005)**. SSOT: `docs/governance/UI_PRODUCT_RULES.md` (One Job Per Screen + UI Intent Contract + No Competing Modes + Live System Page + Publication Gate + Premortem). Origem: engenharia reversa do incidente Mycelium-3-jobs.
    90	- **README: PT-BR obrigatório, score ≥ 4/5** — SSOT: `docs/governance/README_PADRAO_OURO.md`
    91	  - Seções obrigatórias: versão+status, para que serve, stack, quick start, deploy
    92	  - Atualizar README na mesma sessão que muda funcionalidade

codex
The patch is mostly documentation, but it introduces conflicting task state and places a mandatory cross-agent UI rule outside the canonical rule source, both of which can mislead automation and future agents.

Full review comments:

- [P2] Sync the UI gate into the canonical agent rules — /home/enio/egos/CLAUDE.md:89-89
  This makes R-UI-005 mandatory only in `CLAUDE.md`, but the repo rules state that `AGENTS.md` is the canonical cross-IDE source and wins when it diverges from Claude-specific instructions. In practice, agents that load `AGENTS.md` but not `CLAUDE.md` will miss the new Publication Gate, so the rule won't be enforced consistently across the intended surfaces; add the same reference to the canonical `AGENTS.md` block or run the documented sync path.

- [P2] Keep the reopened task out of the completed archive — /home/enio/egos/TASKS_ARCHIVE.md:3672-3672
  This archives `COURSE-FREE-TIER-001` as `[x]`/completed while `TASKS.md` reopens the same task because the artifact is still only a draft and publication is pending HITL. Any task scanner or agent using the archive as completion evidence can now treat the free-tier publication as done and skip the remaining approval/publish work; remove this completed archive entry until the publication is actually finished.
The patch is mostly documentation, but it introduces conflicting task state and places a mandatory cross-agent UI rule outside the canonical rule source, both of which can mislead automation and future agents.

Full review comments:

- [P2] Sync the UI gate into the canonical agent rules — /home/enio/egos/CLAUDE.md:89-89
  This makes R-UI-005 mandatory only in `CLAUDE.md`, but the repo rules state that `AGENTS.md` is the canonical cross-IDE source and wins when it diverges from Claude-specific instructions. In practice, agents that load `AGENTS.md` but not `CLAUDE.md` will miss the new Publication Gate, so the rule won't be enforced consistently across the intended surfaces; add the same reference to the canonical `AGENTS.md` block or run the documented sync path.

- [P2] Keep the reopened task out of the completed archive — /home/enio/egos/TASKS_ARCHIVE.md:3672-3672
  This archives `COURSE-FREE-TIER-001` as `[x]`/completed while `TASKS.md` reopens the same task because the artifact is still only a draft and publication is pending HITL. Any task scanner or agent using the archive as completion evidence can now treat the free-tier publication as done and skip the remaining approval/publish work; remove this completed archive entry until the publication is actually finished.
```
