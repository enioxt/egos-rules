# Codex Local Review — 2026-06-07T17:17:17Z

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
session id: 019ea316-c615-7352-ba19-5f1074eacaf5
--------
user
changes against 'HEAD~3'
2026-06-07T17:17:20.771530Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T17:17:20.771625Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff --stat 6896a0cb3738292d9c31952638a1e1e0a97291c9 && git diff --name-only 6896a0cb3738292d9c31952638a1e1e0a97291c9' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                     |   4 +
 TASKS_ARCHIVE.md                             |   6 ++
 apps/egos-landing/public/timeline/rss        |   2 +-
 apps/egos-landing/public/timeline/rss.xml    |   2 +-
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md | 109 +++++++++++++++++++++++++++
 docs/strategy/PRODUCT_MODEL.md               |  16 ++--
 6 files changed, 131 insertions(+), 8 deletions(-)
TASKS.md
TASKS_ARCHIVE.md
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
docs/strategy/PRODUCT_MODEL.md

exec
/bin/bash -lc 'git diff 6896a0cb3738292d9c31952638a1e1e0a97291c9 -- TASKS.md TASKS_ARCHIVE.md apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md docs/strategy/PRODUCT_MODEL.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 2bdb7e6d..ace631b8 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -13,6 +13,10 @@
 - [ ] **COPY-PRICE-RECONCILE-001** [P1] `voz` `gated:HITL` — alinhar ~10 arquivos de copy pública (founding-pass/social-copy.md, posts-ready-to-publish.md, social-media/*, competitive-analysis.md) de R$2 → R$4 ×2 preço único. NÃO blastar com sed — passe de voz preservando argumentação, corte Enio antes de publicar.
 - [ ] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — experimento mínimo "validar os dois" (comunidade/material + setup assistido) COMEÇANDO DE GRAÇA (sem cobrança, sem PCMG risk): publicar artefato grátis (deploy landing HITL) → 1ª pessoa interessada vira teste de setup assistido gratuito → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [ ] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — atualizar README p/ refletir a nova realidade (foco = método "IA que prova o que afirma" + literacia governada). Liga README-OVERHAUL-001. Só após preço/foco travados (já travados). HITL.
+- [ ] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — auditoria Guarani #1: metaprompt v3 hardcoded inline em App.tsx (drift vs docs/drafts/free-artifact-egos-v0.md). Build Vite pré-compila do markdown canônico → src/data/metaprompt-source.ts. Evita drift SSOT.
+- [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
+- [ ] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — auditoria Guarani #3: artefato v3 mescla Tutor (socrático) + Operacional (formato rígido); modelos fracos confundem. Adicionar Golden Example de transição Tutor→Operacional. Melhora direto o produto Tier 0. HITL (R-PUB-001).
+- [ ] **GIT-HISTORY-PII-DEEPSCAN-001** [P1] `guardiao`+`redzone` 🔴 — auditoria Guarani #5 (corrigida): egos NÃO tem arquivos OP-* no histórico (verificado), mas antes de QUALQUER abertura pública do egos, scan PROFUNDO de PII no conteúdo do histórico (não só paths). Repo público hoje = egos-governance (curado). NÃO filter-repo sem evidência + corte Enio (T0).
 
 ## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 4ca7dea6..7d5ba159 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3691,3 +3691,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **NEW-DIRECTION-GATE-001** [P0] — FOCUS_GATES §6b + /start regra 13 — trava anti-espelho mid-session — `b9941031`
 - [x] **PRICING-R4-SSOT-001** [P1] — pricing-policy.md v1.1 alinhado R$4 ×2 preço único (corte Enio) — commit /end
 
+
+## Archived 2026-06-07
+
+### 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
+- [x] **PRODUCT-MODEL-TIERS-CLARIFY-001** [P1] — auditoria Guarani #4: PRODUCT_MODEL.md "sem tiers" mas tabela de canais ambígua → clarificado v1.1 (1 produto pago R$4; resto = fomento grátis ou stack interna) — commit /end
+
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..99d056af 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 13:02:17 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..99d056af 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Sun, 07 Jun 2026 13:02:17 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
new file mode 100644
index 00000000..20330d4d
--- /dev/null
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -0,0 +1,109 @@
+# EGOS — Plano de Onboarding & Lançamento (SSOT)
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT — HITL (nada publicado)
+**Origem:** sessão de propósito 2026-06-07 (Banda + crítico + premortem + Codex gpt-5.5).
+**Liga:** [PRODUCT_MODEL.md](PRODUCT_MODEL.md) · [GTM_SSOT.md](../GTM_SSOT.md) · [pricing-policy.md](../business/founding-pass/pricing-policy.md) · memory `project_egos_purpose_convergence_2026-06-07`, `project_egos_custom_gpt_onboarding_design`.
+
+> **Regra:** tudo aqui é DRAFT. Copy pública só vai ao ar com corte do Enio (R-PUB-001). Dado/infra não entra em superfície pública (R-SEC-002).
+
+---
+
+## 1. Norte (essência travada, validada no código)
+
+**EGOS ajuda a tornar o uso de IA mais verificável, auditável e governado** — para decisões apoiadas em evidência, com revisão humana. O foco é o **MÉTODO** (domain-agnostic), não um vertical. O material ensina **literacia de IA governada**. A honestidade (classificar o que se sabe/supõe/não-sabe) é o diferencial.
+
+> **Voz (corte Enio 2026-06-07):** tudo em nome do **EGOS (a entidade resolve)**, nunca 1ª pessoa do Enio, nunca persona-investigador. Verbos COLABORATIVOS (ajuda, torna mais, colabora) — **nunca** "faz provar/garante/100%/único". "Fazer a IA provar o que afirma" é **tese técnica interna**, jamais slogan público.
+
+---
+
+## 2. A escada de tiers (cada degrau usa só o que já existe)
+
+| Tier | O quê | Preço | Fecha a lacuna | Limite (próximo degrau) |
+|---|---|---|---|---|
+| **0 — GPT grátis** | GPT personalizado compartilhado (Enio cria, pessoa não paga) | Grátis | clareza + método + desenho de setup (dado genérico) | dado real não pode entrar (R-SEC-002) |
+| **1 — Founding Pass** | acesso vitalício a material + comunidade + metaprompts | **R$4 ×2/lote, preço único** | aprende a montar o próprio setup governado | execução no dado real dela |
+| **2 — Setup assistido / soberano** | montar na máquina dela, dado real, local | a definir | o sistema real dela rodando governado | escala/manutenção |
+| **3 — Framework/IDE** | EGOS completo (gates, eval, governança) | a definir | governança contínua do uso de IA | — |
+
+**O limite Tier 0 → Fase 2 é forçado por PRINCÍPIO (R-SEC-002), não por venda:** dado real não vai pro GPT/nuvem. Isso é o diferencial de honestidade, não um funil.
+
+---
+
+## 3. Copy oficial v1 (Codex gpt-5.5, 2026-06-07 — DRAFT-HITL)
+
+> Voz EGOS: 3ª pessoa, sóbrio, sem absolutos banidos, sem promessa de renda/resultado, anti-manipulação.
+
+### 3.1 Tese pública
+**Curta:** EGOS é um framework brasileiro que ajuda a usar IA com mais confiança — tornando as respostas mais verificáveis e auditáveis: o que a IA sabe, de onde veio, o que é suposição, o que falta confirmar e qual evidência apoia cada decisão.
+**Longa:** EGOS é um framework de governança e verificação de IA criado para uma pergunta simples: "como saber se a IA está certa?" Em vez de tratar uma resposta bonita como verdade, organiza o uso da IA como processo auditável — separar fato/inferência/desconhecimento, apontar evidências, assumir limites, permitir revisão humana antes de decisões importantes. Não substitui julgamento profissional; torna o uso da IA mais claro, recuperável e responsável.
+
+### 3.2 Onboarding grátis (GPT)
+**Curta:** O onboarding gratuito começa com uma pergunta bem feita. Em vez de despejar texto genérico, o GPT entende o contexto, separa o que sabe do que supõe e mostra o que ainda precisa perguntar. Uma IA que não finge certeza.
+**Longa:** O GPT gratuito faz a pergunta certa antes de responder. A pessoa entra sem pagar, descreve sua realidade e recebe um primeiro desenho do próprio setup: objetivos, riscos, limites, próximos passos e pontos a confirmar. A diferença não é parecer mais inteligente — é ser mais honesto: mostra o que entendeu, o que infere e o que não sabe. Para quem está cansado de IA genérica, pode ser o primeiro contato com um método responsável de usar IA.
+
+### 3.3 Founding Pass (preço)
+**Curta:** Entrada antecipada no EGOS. Preço baixo por estratégia de acesso: quem entra primeiro valida o método, acompanha a evolução e mantém o valor de entrada para sempre. A cada lote, o preço dobra. Acesso vitalício; o preço não muda conforme a quantidade de material.
+**Longa:** O Founding Pass forma a primeira base sem transformar acesso em barreira. O primeiro lote é mais barato porque entra mais cedo, com mais partes em evolução. Quando novos lotes abrirem, o valor dobra. Não se cobra por "pacotes de conteúdo" nem por volume: é preço único para acesso vitalício ao ecossistema e às evoluções incluídas. Quem entra antes assume mais incerteza de produto e paga menos para sempre.
+
+### 3.4 Escada de valor (Tier 0 → Fase 2)
+**Curta:** O GPT gratuito trabalha com exemplos e ajuda a desenhar o setup. A Fase 2 existe porque dado real exige outro tratamento: deve ficar na máquina da pessoa, com segurança e soberania. Esse limite não é tática comercial — é princípio operacional do EGOS.
+**Longa:** A primeira etapa é gratuita e dá clareza (dados de exemplo ou não-sensíveis). A segunda é diferente: quando entra dado real — profissional, institucional, financeiro, jurídico, médico ou pessoal — o EGOS não orienta jogar isso em GPT/nuvem pública. A montagem acontece na máquina da pessoa ou ambiente controlado, com soberania, segurança e revisão. O limite do gratuito não esconde valor para vender depois: é não tratar dado real como descartável.
+
+### 3.5 Esperança sistematizada
+**Curta:** EGOS trata esperança como método. Ajudar mais brasileiros a usar IA com critério: perguntar melhor, verificar respostas, proteger dados e aprender em comunidade. Não é renda fácil — é literacia prática.
+**Longa:** Mais pessoas podem usar IA com segurança se tiverem método, linguagem clara e comunidade — profissionais liberais, pequenos negócios, servidores, estudantes, iniciantes. [EXEMPLO HIPOTÉTICO — VALIDAR] alguém com um celular aprende a organizar um atendimento, revisar uma decisão, preparar uma pergunta melhor ou checar se uma resposta tem evidência. Não automatiza a vida nem garante resultado: dá repertório para não depender de respostas bonitas sem prova. A esperança aqui é arquitetura: acesso inicial, método verificável, dados protegidos, revisão humana, evolução coletiva.
+
+> ⚠️ Esta copy ainda diz/assume coisas a alinhar: a copy pública atual em founding-pass/* ainda menciona R$2 (task COPY-PRICE-RECONCILE-001). Peça 3.5 tem exemplo hipotético a validar. Codex flag: "quem entra antes assume incerteza" é honesto mas avaliar efeito na conversão.
+
+---
+
+## 4. GPT Tier 0 — pacote de montagem (pronto p/ Enio criar no ChatGPT, HITL)
+
+**Instruções (system):** o artefato governado `docs/drafts/free-artifact-egos-v0.md` (modo socrático "uma pergunta → infere setup" + regras anti-alucinação/classificação CONFIRMADO-INFERIDO-HIPÓTESE/Red Zone/proteção de dados). [REAL]
+**Knowledge files (tudo público — assume extraível via prompt-leak):**
+- 16 metaprompts `docs/metaprompts/MP-*.md` [REAL]
+- checklist de segurança de IA (Parte 2 do artefato) [REAL]
+- módulo-1 de literacia `docs/courses/modulo-01-primeiro-agente.md` [REAL]
+- use cases / exemplos [REAL]
+**Conversation starters:** aberturas socráticas ("qual é a sua área?", "o que você quer que a IA faça por você sem vazar seus dados?").
+**FORA (vazaria + viola R-SEC-002):** infra/ops/observability/browser-automation, dado real/PII/PCMG/cliente, secrets/bridge. Coerente com transparência radical.
+**Smoke:** pessoa abre o GPT → faz 1 pergunta → infere setup → classifica honestamente. Mede: acendeu? (flow do Enio + interesse da pessoa).
+**[VERIFICAR p/ v1 com MCP]:** MCP roda dentro de GPT custom hoje? Se sim, Guard Brasil scan PII + KB entram como Actions — mantendo o limite da soberania de dado.
+
+---
+
+## 5. Sequência de lançamento (fases + ações + gates)
+
+**Fase 0 — agora (zero/baixa construção):**
+1. Deploy do artefato grátis na landing (`f8e3c27d` pronto) — **HITL Enio** (deploy.sh).
+2. Montar GPT Tier 0 (§4) — Enio cria no ChatGPT + compartilha link. HITL nas instruções.
+3. Reconciliar copy de preço R$2→R$4 (COPY-PRICE-RECONCILE-001, voz+HITL).
+
+**Fase 1 — validar (experimento mínimo):**
+4. Publicar/compartilhar GPT + artefato → 1ª pessoa real → medir 2 sinais (material atrai? ajudar acende o Enio?). VALIDATE-BOTH-EXPERIMENT-001.
+5. Founding Pass R$4 ligado (PCMG: corte Enio assumido) — link de pagamento + grupo.
+
+**Fase 2 — só se Fase 1 acender:**
+6. Setup assistido com dado real (soberano, local) — advocacia-starter como modelo.
+7. Comunidade/material crescendo + colaboradores melhoram conteúdo.
+
+**Gate entre fases:** New Direction Gate (FOCUS_GATES §6b) + dispersion-meter. Não pular pra Fase 2 sem o sinal da Fase 1.
+
+---
+
+## 6. Recursos EGOS usados (REAL) vs o que falta
+
+**REAL (já existe, reusar):** artefato governado · 16 metaprompts · metaprompt-generator · eval-runner (golden cases) · guard-brasil (PII/LGPD) · skills advocacia-onboard/kbs-discovery/recon/readiness/novodemo · pricing-policy v1.1 · módulo-1 · sales page+launch copy (founding-pass) · landing egos.ia.br.
+**CONCEPT (montar quando a fase chegar):** GPT Tier 0 (pacote §4, montagem) · grupo Telegram/WhatsApp · link de pagamento · MCP-em-GPT (v1).
+**PHANTOM (não prometer):** receita storefront · cursos gravados · automação que "vende dormindo".
+
+---
+
+## 7. Métricas honestas
+
+- Fase 1 acende? = (a) ≥1 pessoa real usa o GPT e volta; (b) Enio sente flow ao ajudar (não drenado); (c) ≥1 conversão R$4 orgânica.
+- NÃO medir vaidade (views). Medir: pergunta certa feita? pessoa sentiu honestidade? Enio quis continuar?
+
+---
+
+*SSOT deste plano: este arquivo. Copy v1 = Codex gpt-5.5 2026-06-07 (DRAFT-HITL). Tudo pendente de corte do Enio antes de publicar.*
diff --git a/docs/strategy/PRODUCT_MODEL.md b/docs/strategy/PRODUCT_MODEL.md
index 4016b12d..055713af 100644
--- a/docs/strategy/PRODUCT_MODEL.md
+++ b/docs/strategy/PRODUCT_MODEL.md
@@ -32,12 +32,16 @@ Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa.
 Quem já pagou: preço congelado para sempre.
 Reembolso: disponível; quem sai fica com o material até a data de saída.
 
-## Canais de acesso
+## Canais de acesso (NÃO são tiers comerciais)
 
-| Canal | Custo | Descrição |
-|-------|-------|-----------|
-| Telegram | Gratuito | Comunidade global, método aberto |
-| WhatsApp + GPT + MCP | R$4 (vitalício) | Produto completo |
-| IDE + SSOT (Claude Code) | Avançado | Para quem quer o modo profissional |
+> Esclarecimento (2026-06-07, auditoria Guarani): há **um único produto comercial** — R$4 vitalício. Os "canais" abaixo não são planos com preços diferentes; são **onde** o EGOS aparece. Só um deles é a venda.
 
+| Canal | Natureza | O que é |
+|-------|----------|---------|
+| Telegram | Gratuito (fomento) | Comunidade aberta, método público — porta de entrada, não produto pago |
+| GPT personalizado | Gratuito (onboarding) | Enio cria e compartilha; pessoa não paga — clareza + método (dado genérico) |
+| **WhatsApp + GPT + MCP** | **R$4 vitalício (ÚNICO produto pago)** | O produto comercial: agente vivo + acesso a tudo + evoluções |
+| IDE + SSOT (Claude Code) | Stack interna dos criadores | Ferramenta de desenvolvimento do EGOS, NÃO um tier de prateleira |
+
+*v1.1 — 2026-06-07 · Removida ambiguidade de tiers (auditoria Guarani #4): 1 produto pago (R$4), o resto é fomento gratuito ou stack interna.*
 *v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*

exec
/bin/bash -lc "ls docs | sed -n '1,120p'; test -f docs/GTM_SSOT.md; echo GTM:"'$?; test -f docs/business/founding-pass/pricing-policy.md; echo pricing:$?; test -f docs/drafts/free-artifact-egos-v0.md; echo artifact:$?; ls docs/metaprompts/MP-*.md 2>/dev/null | wc -l; test -f docs/courses/modulo-01-primeiro-agente.md; echo course:$?' in /home/enio/egos
 succeeded in 0ms:
AGENT_BOOTSTRAP.md
CAPABILITY_REGISTRY.md
COORDINATION.md
COORDINATION_PATTERN.md
CROSS_REPO_CONTEXT_ROUTER.md
EGOS_BOOTSTRAP.md
GTM_SSOT.md
INCIDENTS
ROUTING_DECISION_TREE.txt
SPRINT_PROTOCOL.md
SYSTEM_MAP.md
_archived
_archived_handoffs
_archived_research
_context_snapshots
_current_handoffs
_drafts
_examples
_generated
_inbox
_investigations
_out-of-scope
_proofs
agents
ai-architecture
analysis
archaeology
architecture
assets
audits
autoresearch
banda
business
capabilities
central-egos
community
competitive-analysis
concepts
consulting
courses
cybersecurity
data
diagnostics
discovery
drafts
evolution-tree.html
examples
exports
gem-hunter
governance
gpecas
gpts
guides
inception_reports
infra
intelink
jobs
kb-vps
knowledge
labs
legal
mcp
metaprompts
modules
monitoring
morning_reports
notebooklm
opus-mode
patterns
personal-os
pitch
planning
presentations
products-specs
projects
public
qa
quorum
reports
research
roadmap
runbooks
security
seo-reports
sessions
showcase
skills
social
soul
specs
sprints
stack
standards
start-layers
strategy
teaching
test-data
timeline
timeline_drafts
validation
workflows
world-model
GTM:0
pricing:0
artifact:0
16
course:0

exec
/bin/bash -lc 'head -40 apps/egos-landing/public/timeline/rss && file apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml && cmp -s apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml; echo cmp:$?' in /home/enio/egos
 succeeded in 0ms:
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>EGOS Timeline</title>
    <link>https://egos.ia.br/#/timeline</link>
    <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
    <language>pt-BR</language>
    <lastBuildDate>Sun, 07 Jun 2026 13:02:17 GMT</lastBuildDate>
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
apps/egos-landing/public/timeline/rss:     XML 1.0 document, Unicode text, UTF-8 text, with very long lines (346)
apps/egos-landing/public/timeline/rss.xml: XML 1.0 document, Unicode text, UTF-8 text, with very long lines (346)
cmp:0

exec
/bin/bash -lc "python - <<'PY'
import xml.etree.ElementTree as ET
for f in ['apps/egos-landing/public/timeline/rss','apps/egos-landing/public/timeline/rss.xml']:
    ET.parse(f)
    print(f,'ok')
PY" in /home/enio/egos
 succeeded in 0ms:
apps/egos-landing/public/timeline/rss ok
apps/egos-landing/public/timeline/rss.xml ok

mcp: codebase-memory-mcp/list_projects started
mcp: codebase-memory-mcp/list_projects (completed)
exec
/bin/bash -lc "sed -n '1,140p' docs/strategy/PRODUCT_MODEL.md" in /home/enio/egos
 succeeded in 0ms:
# Modelo de Produto EGOS — SSOT

> **Decisão Enio 2026-06-05:** um preço, um produto, vitalício, transparência radical.

## Princípio

Sem tiers. Sem planos. Sem feature gate.

Um preço de entrada (começa em R$4, progressão ×2 quando subir). Quem paga, tem tudo — o que já existe E o que vai ser criado. Acesso vitalício. Reembolso disponível (quem sai, fica com o material que existia até a data de saída).

"As pessoas bancam meus estudos e se beneficiam do que tenho pra falar e das ferramentas que crio."

## O que está incluso (sem exceção)

- Grupo WhatsApp privado EGOS (agente vivo + resumo diário 7h)
- GPT próprio EGOS no ChatGPT (metaprompt configurado + MCP com todas as ferramentas do VPS)
- Acesso a todos os metaprompts, tools (Guard Brasil, item-intake, etc.)
- Roadmap honesto com status LIVE / WIP / CONCEPT
- Participação em projetos que avançarem para receita (proporcional à colaboração)
- Tudo que vier a ser criado enquanto membro

## Transparência radical (regra)

Nunca prometer o que é [CONCEPT]. Status de cada área publicado com honestidade:
- 🟢 LIVE — funciona hoje
- 🟡 WIP — em desenvolvimento
- 🔵 CONCEPT — planejado, não iniciado

## Preço

Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa.
Quem já pagou: preço congelado para sempre.
Reembolso: disponível; quem sai fica com o material até a data de saída.

## Canais de acesso (NÃO são tiers comerciais)

> Esclarecimento (2026-06-07, auditoria Guarani): há **um único produto comercial** — R$4 vitalício. Os "canais" abaixo não são planos com preços diferentes; são **onde** o EGOS aparece. Só um deles é a venda.

| Canal | Natureza | O que é |
|-------|----------|---------|
| Telegram | Gratuito (fomento) | Comunidade aberta, método público — porta de entrada, não produto pago |
| GPT personalizado | Gratuito (onboarding) | Enio cria e compartilha; pessoa não paga — clareza + método (dado genérico) |
| **WhatsApp + GPT + MCP** | **R$4 vitalício (ÚNICO produto pago)** | O produto comercial: agente vivo + acesso a tudo + evoluções |
| IDE + SSOT (Claude Code) | Stack interna dos criadores | Ferramenta de desenvolvimento do EGOS, NÃO um tier de prateleira |

*v1.1 — 2026-06-07 · Removida ambiguidade de tiers (auditoria Guarani #4): 1 produto pago (R$4), o resto é fomento gratuito ou stack interna.*
*v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*

exec
/bin/bash -lc "nl -ba docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md | sed -n '18,34p'" in /home/enio/egos
 succeeded in 0ms:
    18	
    19	## 2. A escada de tiers (cada degrau usa só o que já existe)
    20	
    21	| Tier | O quê | Preço | Fecha a lacuna | Limite (próximo degrau) |
    22	|---|---|---|---|---|
    23	| **0 — GPT grátis** | GPT personalizado compartilhado (Enio cria, pessoa não paga) | Grátis | clareza + método + desenho de setup (dado genérico) | dado real não pode entrar (R-SEC-002) |
    24	| **1 — Founding Pass** | acesso vitalício a material + comunidade + metaprompts | **R$4 ×2/lote, preço único** | aprende a montar o próprio setup governado | execução no dado real dela |
    25	| **2 — Setup assistido / soberano** | montar na máquina dela, dado real, local | a definir | o sistema real dela rodando governado | escala/manutenção |
    26	| **3 — Framework/IDE** | EGOS completo (gates, eval, governança) | a definir | governança contínua do uso de IA | — |
    27	
    28	**O limite Tier 0 → Fase 2 é forçado por PRINCÍPIO (R-SEC-002), não por venda:** dado real não vai pro GPT/nuvem. Isso é o diferencial de honestidade, não um funil.
    29	
    30	---
    31	
    32	## 3. Copy oficial v1 (Codex gpt-5.5, 2026-06-07 — DRAFT-HITL)
    33	
    34	> Voz EGOS: 3ª pessoa, sóbrio, sem absolutos banidos, sem promessa de renda/resultado, anti-manipulação.

exec
/bin/bash -lc 'nl -ba TASKS_ARCHIVE.md | tail -20' in /home/enio/egos
 succeeded in 0ms:
  3680	
  3681	
  3682	## Archived 2026-06-07
  3683	
  3684	### 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
  3685	- [x] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte. ✅ 2026-06-05
  3686	
  3687	
  3688	## Archived 2026-06-07
  3689	
  3690	### 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
  3691	- [x] **NEW-DIRECTION-GATE-001** [P0] — FOCUS_GATES §6b + /start regra 13 — trava anti-espelho mid-session — `b9941031`
  3692	- [x] **PRICING-R4-SSOT-001** [P1] — pricing-policy.md v1.1 alinhado R$4 ×2 preço único (corte Enio) — commit /end
  3693	
  3694	
  3695	## Archived 2026-06-07
  3696	
  3697	### 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
  3698	- [x] **PRODUCT-MODEL-TIERS-CLARIFY-001** [P1] — auditoria Guarani #4: PRODUCT_MODEL.md "sem tiers" mas tabela de canais ambígua → clarificado v1.1 (1 produto pago R$4; resto = fomento grátis ou stack interna) — commit /end
  3699	

codex
The patch introduces a new SSOT section that conflicts with the product-model clarification made in the same change. This can mislead downstream launch and pricing copy, so it should be corrected before accepting the patch.

Review comment:

- [P2] Keep launch plan aligned with no-tier product SSOT — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:19-26
  This new onboarding SSOT reintroduces a tier ladder with Tier 2/3 prices “a definir”, while the same patch updates `PRODUCT_MODEL.md` to clarify there is exactly one commercial product and that channels are not tiers. Because this file links `PRODUCT_MODEL.md` as a source, launch/copy work can now follow the contradictory tier model and recreate the ambiguity the patch is trying to remove; rename this section to phases/capabilities or explicitly keep only the R$4 product as commercial.
The patch introduces a new SSOT section that conflicts with the product-model clarification made in the same change. This can mislead downstream launch and pricing copy, so it should be corrected before accepting the patch.

Review comment:

- [P2] Keep launch plan aligned with no-tier product SSOT — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:19-26
  This new onboarding SSOT reintroduces a tier ladder with Tier 2/3 prices “a definir”, while the same patch updates `PRODUCT_MODEL.md` to clarify there is exactly one commercial product and that channels are not tiers. Because this file links `PRODUCT_MODEL.md` as a source, launch/copy work can now follow the contradictory tier model and recreate the ambiguity the patch is trying to remove; rename this section to phases/capabilities or explicitly keep only the R$4 product as commercial.
```
