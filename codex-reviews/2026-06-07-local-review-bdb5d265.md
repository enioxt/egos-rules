# Codex Local Review — 2026-06-07T17:07:20Z

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
session id: 019ea30d-a6f4-76b3-8c9f-971a2b7b329a
--------
user
changes against 'HEAD~3'
2026-06-07T17:07:24.657574Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T17:07:24.661788Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 9709313413d3186ff91ade43214ef4165f240c17 --stat && git diff 9709313413d3186ff91ade43214ef4165f240c17' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/end.md                      |  27 +++++++
 TASKS.md                                     |   4 +
 TASKS_ARCHIVE.md                             |   6 ++
 apps/egos-landing/public/timeline/rss        |   2 +-
 apps/egos-landing/public/timeline/rss.xml    |   2 +-
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md | 107 +++++++++++++++++++++++++++
 docs/strategy/PRODUCT_MODEL.md               |  16 ++--
 7 files changed, 156 insertions(+), 8 deletions(-)
diff --git a/.claude/commands/end.md b/.claude/commands/end.md
index 57feade8..b98681c6 100644
--- a/.claude/commands/end.md
+++ b/.claude/commands/end.md
@@ -616,6 +616,31 @@ Se o usuário corrigiu approach OU validou approach não-óbvio durante a sessã
 - Update `feedback_*.md` existente OU criar novo
 - Formato: rule + **Why:** + **How to apply:**
 
+### 8.5 — Subagent/Research Intelligence Harvest (NOVO 2026-06-07 — END-HARVEST-001)
+
+> **Origem:** sessão de propósito 2026-06-07 — o /end salvou as CONCLUSÕES mas deixou a INTELIGÊNCIA das sondas (7 relatórios: mapa forense, correlação traço↔arquitetura, inventário de monetização) viver só no transcript. Enio teve que pedir "verifique de novo, não percamos algo precioso" para o gap ser pego. Causa-raiz: subagent output tratado como andaime descartável após síntese. Ironia: numa sessão sobre "preserve a evidência", a evidência foi descartada.
+> **Princípio:** numa sessão com `Agent`/`Explore`/`Workflow`, o subagente produz ANÁLISE/EVIDÊNCIA cara de re-derivar. A conclusão vai pra Phase 8; a EVIDÊNCIA que a sustenta NÃO PODE morrer no tool-result. Re-derivar custa tokens+tempo; o raciocínio é load-bearing.
+
+**Dispara quando:** a sessão chamou ≥1 `Agent`/`Explore`/`Workflow`/sonda que retornou análise NÃO-commitada como código (inventário, mapa, tabela, comparação, refutação, forense, correlação).
+
+**Ação (executar, não declarar):**
+1. Listar os relatórios de subagente da sessão (o que cada sonda produziu).
+2. Para cada um, triar: **JÁ-EM-CÓDIGO** (virou commit → ok) · **CONCLUSÃO-JÁ-EM-MEMORY** (a decisão está salva, mas e a evidência?) · **SÓ-NO-TRANSCRIPT** (perde no próximo chat).
+3. Para os **SÓ-NO-TRANSCRIPT** com valor de referência → **condensar** (não colar inteiro — anti-bloat) num arquivo `type: reference` em `memory/session_YYYY-MM-DD_intelligence-*.md` (tabelas-chave + números + paths) OU, se >20K e operacional, `docs/jobs/YYYY-MM-DD-*.md`. Linkar `[[conclusão]]`.
+4. Atualizar MEMORY.md index.
+
+**Output obrigatório:**
+```
+INTELLIGENCE HARVEST
+====================
+Subagentes na sessão: [N]
+  - [sonda] → JÁ-EM-CÓDIGO / CONCLUSÃO-EM-MEMORY / SÓ-NO-TRANSCRIPT
+Harvested: [arquivo(s) criado(s) p/ os SÓ-NO-TRANSCRIPT valiosos]
+Afirmação: "Nenhuma inteligência de subagente com valor de referência ficou só no transcript."
+```
+
+**Skip:** sessão sem subagente OU todo output já virou código/memory → "Phase 8.5: skip — sem inteligência órfã".
+
 ---
 
 ## PHASE 9 — Daily Article (CONDITIONAL)
@@ -998,6 +1023,7 @@ Ao final, imprimir para o usuário (copiável para a janela-mestre):
 | 3.6 | NUNCA (exceto read-only zero-commit) | "Phase 3.6: skip — read-only" |
 | 7.2 | Zero commits OU só mudanças em docs/jobs+audits | "Phase 7.2: skip — sem impacto L0/templates" |
 | 8 | NUNCA — memory write obrigatório | — |
+| 8.5 | Sessão sem subagente OU output já em código/memory | "Phase 8.5: skip — sem inteligência órfã" |
 | 9 | Sessão zero commits OU só infra/chore | "Phase 9: skip — [reason]" |
 | 10 | NUNCA — checkpoint é a prova | — |
 | 11.5 | NUNCA — Understanding Verification é Karpathy gate | — |
@@ -1021,6 +1047,7 @@ Ao final, imprimir para o usuário (copiável para a janela-mestre):
 
 ---
 
+*v6.7 — 2026-06-07 | Phase 8.5 Subagent/Research Intelligence Harvest (END-HARVEST-001, pedido Enio "por que errou no /end"): força colher a EVIDÊNCIA das sondas (Agent/Explore/Workflow) que vive só no transcript, condensada em memory `reference` ou docs/jobs. Causa-raiz: subagent output tratado como andaime descartável após síntese — /end salvava conclusão, perdia a análise que a sustenta. Pego só porque Enio mandou "verifique de novo, não percamos algo precioso".*
 *v6.6 — 2026-06-03 | Phase 3.6 Varredura Anti-Atropelo (END-ANTIATROPELO-001, pedido Enio): relê a sessão INTEIRA por gatilhos linguísticos+estruturais e força cada idéia/conceito/decisão a virar task (ou nota deferida com motivo) antes do handoff/commit. Não-skipável (exceto read-only). Origem: sessão item-intake onde idéias boas (KYTE-API, DEDUP, GENERIC, TOOLS-INVENTORY…) foram ditas de passagem e só viraram task numa varredura manual pós-/end.*
 *v6.5.1 — 2026-05-30 | Phase 14 cross-repo fix (INC-MERGE-001): inbox de merge SEMPRE no kernel egos (a mestre só pulla lá). Janela em leaf-repo escreve o block no kernel referenciando os SHAs do leaf; commit/push do block a partir do kernel. Descoberto no merge de 3 janelas onde a janela intelink-platform teve que improvisar o destino.*
 *v6.5 — 2026-05-30 | Adiciona Phase 14 Cross-Session Merge Handoff — MERGE BLOCK auto-suficiente por janela quando N sessões Claude Code são fundidas numa sessão-mestre única (index .git compartilhado, INC-002).*
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
index 00000000..d932e4f4
--- /dev/null
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -0,0 +1,107 @@
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
+**EGOS faz a IA (e o usuário) provar o que afirma** — transforma decisão de IA opaca em processo verificável com lastro de evidência. O foco é o **MÉTODO** (domain-agnostic), não um vertical. O material ensina **literacia de IA governada**. A honestidade (classificar o que se sabe/supõe/não-sabe) é o diferencial e a marca.
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
+**Curta:** EGOS é um framework brasileiro para fazer a IA provar o que afirma. Transforma respostas opacas em processos verificáveis: o que a IA sabe, de onde veio, o que é suposição, o que falta confirmar e qual evidência sustenta cada decisão.
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
/bin/bash -lc "ls docs/strategy && find docs -maxdepth 2 -iname '*launch*' -o -iname '*onboarding*' -o -iname '*gtm*' -o -iname '*product*'" in /home/enio/egos
 succeeded in 0ms:
AGENT_TAXONOMY.md
API_DISTRIBUTION_READINESS.md
ARCHIVE_GEMS_CATALOG.md
BLOCKCHAIN_GOVERNANCE_VALIDATION.md
CAPABILITY_ARCHAEOLOGY_PROGRAM.md
CAPABILITY_NARRATIVE.md
CAPABILITY_SERVICE_AUDIT.md
CATALOGO_IA_PLAN.md
CHATGROK_INTEGRATION_PLAN.md
CHECKLIST_GPECAS_DESIGN_IMPLEMENTATION.md
CLAUDE_AI_PROJECTS_SETUP.md
CONSENT_UX_SPEC.md
COURSES_FRAMEWORK_GOV_THESIS.md
COURSE_MARKET_RESEARCH_RULESET.md
COURSE_PROGRAM_DESIGN.md
DREAM_CYCLE_SSOT.md
ECOSYSTEM_PRODUCT_VERDICT_2026-03.md
EGOS_DISTRIBUTION_STRATEGY_REVIEW.md
EGOS_ECOSYSTEM_DIAGNOSIS.md
EGOS_LAB_CONSOLIDATION_DIAGNOSTIC.md
EGOS_LAYER_MODEL_STUDY.md
EGOS_MASTER_API_PRD.md
EGOS_OFFERING_CATALOG.md
EGOS_ONBOARDING_LAUNCH_PLAN.md
EGOS_PROJECT_ATLAS.md
EGOS_PUBLIC_PLAN.md
EGOS_TELEGRAM_AGENT_PLAN.md
EGOS_VOICE_GUIDE.md
ENIO_CURRICULUM_POSITIONING.md
ERP_REPLACEMENT_NARRATIVE.md
EXECUTION_CHECKLIST_G_PECAS.md
FLAGSHIP_BRIEF.md
FREE_VS_PAID_SURFACE.md
GO_TO_MARKET_RESEARCH.md
HERMES_COMMUNITY_EVALUATION.md
HQ_EGOS_PRESENTATION_PLAN.md
ITEM_INTAKE_CAPABILITIES_VALUE.md
KERNEL_CONSOLIDATION_PLAN.md
KYTE_BENCHMARK_GAP.md
LANDING_OBJECTIONS.md
LEADS.md
MAC_STUDIO_LOCAL_AI.md
MARKET_READY_FEATURES.md
MASTER_CHECKLIST.md
MCP_VPS_BENCHMARKS.md
MIGRATION_PLAN.md
MONETIZATION_PLAYBOOK.md
MULTI_MODEL_PLANNING.md
NAME_AND_PROVE_PLAN.md
NOTEBOOKLM_CENTRAL_EGOS_INTEGRATION.md
OUTREACH_EMAILS.md
PARTNERSHIPS_PROGRAM.md
PARTNER_COMMISSIONS.md
PARTNER_PLAYBOOK.md
PLAN_v4.md
PRODUCT_MODEL.md
ROADMAP.md
RUNBOOK_WHATSAPP_INCIDENTE.md
SEO_ENGINE_PROPOSAL.md
TOOLS_INVENTORY.md
WORLD_MODEL_SSOT.md
_archived_2026-05-06
appendix
benchmarks
egos-site-copy-filosofia-empresa.md
guard-brasil
instagram
kbs
onboarding
outreach
sales-templates
docs/drafts/2026-04-29-lab-onboarding-automation-pt.md
docs/drafts/2026-04-29-lab-onboarding-automation-en.md
docs/drafts/GTM-X-001-thread-xcom.md
docs/drafts/GTM-LI-001-rascunho-linkedin.md
docs/guides/KBS_ONBOARDING_PT_BR.md
docs/capabilities/PRODUCT_NAMING_DECISION.md
docs/strategy/PRODUCT_MODEL.md
docs/strategy/onboarding
docs/strategy/ECOSYSTEM_PRODUCT_VERDICT_2026-03.md
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
docs/agents/gtm-harvester.md
docs/products-specs
docs/legal/NOTA_COMPROMISSO_EQUITY_GTM_TEMPLATE.md
docs/governance/MCP_PRODUCTION_GATE.md
docs/governance/ONBOARDING.md
docs/governance/PRODUCTION_DEPLOY_RULES.md
docs/governance/UI_PRODUCT_RULES.md
docs/governance/CLIENT_ONBOARDING_CHECKLIST.md
docs/_archived_handoffs/handoff_guardbrasil_gtm.md
docs/_archived_handoffs/ROADMAP_3WEEKS_GUARD_BRASIL_GTM.md
docs/_archived_handoffs/DIAGNOSTIC_2026-03-30_GTM_PATH.md
docs/_archived_handoffs/handoff_20260330_guard_brasil_gtm.md
docs/_archived_handoffs/GUARDBRASIL_GTM_EXECUTIONPLAN.md
docs/gem-hunter/GEM_HUNTER_PRODUCT.md
docs/timeline/2026-04-30-lab-onboarding-automation-pt.md
docs/timeline/2026-04-30-lab-onboarding-automation-en.md
docs/kb-vps/08-onboarding-cliente.md
docs/GTM_SSOT.md

exec
/bin/bash -lc 'test -f docs/business/founding-pass/pricing-policy.md && echo yes || echo no; test -f docs/drafts/free-artifact-egos-v0.md && echo artifact yes; test -f docs/courses/modulo-01-primeiro-agente.md && echo course yes; ls docs/metaprompts/MP-*.md 2>/dev/null | wc -l' in /home/enio/egos
 succeeded in 0ms:
yes
artifact yes
course yes
16

exec
/bin/bash -lc "sed -n '1,120p' docs/strategy/PRODUCT_MODEL.md && sed -n '1,80p' docs/GTM_SSOT.md" in /home/enio/egos
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
# GTM_SSOT — ARCHIVED

> **STATUS:** ARCHIVED 2026-05-22 (GOV-GTM-OBSOLETO-001)
> **Razão:** v2.0 (2026-04-16) declarou "SaaS GTM descontinuado" mas Central EGOS atual É SaaS multi-tenant (G Peças + APeças Patense live). Documento estagnado contradizia estado real.
>
> **SSOTs vigentes (substituem este):**
> - **Pricing:** [`docs/_archived/pricing-superseded-2026-05-25/PRICING_SSOT_v3.md`](templates/PRICING_SSOT.md) v3.2
> - **Onboarding cliente:** [`docs/governance/CLIENT_ONBOARDING_CHECKLIST.md`](governance/CLIENT_ONBOARDING_CHECKLIST.md)
> - **Playbook monetização:** [`docs/strategy/MONETIZATION_PLAYBOOK.md`](strategy/MONETIZATION_PLAYBOOK.md)
> - **Decisões estratégicas:** [`docs/governance/HERMES_DECISION.md`](governance/HERMES_DECISION.md), [`docs/governance/FANTOM_SKILLS_DECISION.md`](governance/FANTOM_SKILLS_DECISION.md)
> - **Sales kit (artigos/X.com/timeline):** ainda válido — ver [`docs/capabilities/pkg-central-egos/08-vendas-gtm.md`](capabilities/pkg-central-egos/08-vendas-gtm.md)
>
> **Conteúdo original v2.0:** [`docs/_archived/2026-04/GTM_SSOT_v2.0.md`](_archived/2026-04/GTM_SSOT_v2.0.md)

exec
/bin/bash -lc "nl -ba docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md | sed -n '1,20p;60,90p'; nl -ba docs/strategy/PRODUCT_MODEL.md | sed -n '1,60p'" in /home/enio/egos
 succeeded in 0ms:
     1	# EGOS — Plano de Onboarding & Lançamento (SSOT)
     2	
     3	**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT — HITL (nada publicado)
     4	**Origem:** sessão de propósito 2026-06-07 (Banda + crítico + premortem + Codex gpt-5.5).
     5	**Liga:** [PRODUCT_MODEL.md](PRODUCT_MODEL.md) · [GTM_SSOT.md](../GTM_SSOT.md) · [pricing-policy.md](../business/founding-pass/pricing-policy.md) · memory `project_egos_purpose_convergence_2026-06-07`, `project_egos_custom_gpt_onboarding_design`.
     6	
     7	> **Regra:** tudo aqui é DRAFT. Copy pública só vai ao ar com corte do Enio (R-PUB-001). Dado/infra não entra em superfície pública (R-SEC-002).
     8	
     9	---
    10	
    11	## 1. Norte (essência travada, validada no código)
    12	
    13	**EGOS faz a IA (e o usuário) provar o que afirma** — transforma decisão de IA opaca em processo verificável com lastro de evidência. O foco é o **MÉTODO** (domain-agnostic), não um vertical. O material ensina **literacia de IA governada**. A honestidade (classificar o que se sabe/supõe/não-sabe) é o diferencial e a marca.
    14	
    15	---
    16	
    17	## 2. A escada de tiers (cada degrau usa só o que já existe)
    18	
    19	| Tier | O quê | Preço | Fecha a lacuna | Limite (próximo degrau) |
    20	|---|---|---|---|---|
    60	**Instruções (system):** o artefato governado `docs/drafts/free-artifact-egos-v0.md` (modo socrático "uma pergunta → infere setup" + regras anti-alucinação/classificação CONFIRMADO-INFERIDO-HIPÓTESE/Red Zone/proteção de dados). [REAL]
    61	**Knowledge files (tudo público — assume extraível via prompt-leak):**
    62	- 16 metaprompts `docs/metaprompts/MP-*.md` [REAL]
    63	- checklist de segurança de IA (Parte 2 do artefato) [REAL]
    64	- módulo-1 de literacia `docs/courses/modulo-01-primeiro-agente.md` [REAL]
    65	- use cases / exemplos [REAL]
    66	**Conversation starters:** aberturas socráticas ("qual é a sua área?", "o que você quer que a IA faça por você sem vazar seus dados?").
    67	**FORA (vazaria + viola R-SEC-002):** infra/ops/observability/browser-automation, dado real/PII/PCMG/cliente, secrets/bridge. Coerente com transparência radical.
    68	**Smoke:** pessoa abre o GPT → faz 1 pergunta → infere setup → classifica honestamente. Mede: acendeu? (flow do Enio + interesse da pessoa).
    69	**[VERIFICAR p/ v1 com MCP]:** MCP roda dentro de GPT custom hoje? Se sim, Guard Brasil scan PII + KB entram como Actions — mantendo o limite da soberania de dado.
    70	
    71	---
    72	
    73	## 5. Sequência de lançamento (fases + ações + gates)
    74	
    75	**Fase 0 — agora (zero/baixa construção):**
    76	1. Deploy do artefato grátis na landing (`f8e3c27d` pronto) — **HITL Enio** (deploy.sh).
    77	2. Montar GPT Tier 0 (§4) — Enio cria no ChatGPT + compartilha link. HITL nas instruções.
    78	3. Reconciliar copy de preço R$2→R$4 (COPY-PRICE-RECONCILE-001, voz+HITL).
    79	
    80	**Fase 1 — validar (experimento mínimo):**
    81	4. Publicar/compartilhar GPT + artefato → 1ª pessoa real → medir 2 sinais (material atrai? ajudar acende o Enio?). VALIDATE-BOTH-EXPERIMENT-001.
    82	5. Founding Pass R$4 ligado (PCMG: corte Enio assumido) — link de pagamento + grupo.
    83	
    84	**Fase 2 — só se Fase 1 acender:**
    85	6. Setup assistido com dado real (soberano, local) — advocacia-starter como modelo.
    86	7. Comunidade/material crescendo + colaboradores melhoram conteúdo.
    87	
    88	**Gate entre fases:** New Direction Gate (FOCUS_GATES §6b) + dispersion-meter. Não pular pra Fase 2 sem o sinal da Fase 1.
    89	
    90	---
     1	# Modelo de Produto EGOS — SSOT
     2	
     3	> **Decisão Enio 2026-06-05:** um preço, um produto, vitalício, transparência radical.
     4	
     5	## Princípio
     6	
     7	Sem tiers. Sem planos. Sem feature gate.
     8	
     9	Um preço de entrada (começa em R$4, progressão ×2 quando subir). Quem paga, tem tudo — o que já existe E o que vai ser criado. Acesso vitalício. Reembolso disponível (quem sai, fica com o material que existia até a data de saída).
    10	
    11	"As pessoas bancam meus estudos e se beneficiam do que tenho pra falar e das ferramentas que crio."
    12	
    13	## O que está incluso (sem exceção)
    14	
    15	- Grupo WhatsApp privado EGOS (agente vivo + resumo diário 7h)
    16	- GPT próprio EGOS no ChatGPT (metaprompt configurado + MCP com todas as ferramentas do VPS)
    17	- Acesso a todos os metaprompts, tools (Guard Brasil, item-intake, etc.)
    18	- Roadmap honesto com status LIVE / WIP / CONCEPT
    19	- Participação em projetos que avançarem para receita (proporcional à colaboração)
    20	- Tudo que vier a ser criado enquanto membro
    21	
    22	## Transparência radical (regra)
    23	
    24	Nunca prometer o que é [CONCEPT]. Status de cada área publicado com honestidade:
    25	- 🟢 LIVE — funciona hoje
    26	- 🟡 WIP — em desenvolvimento
    27	- 🔵 CONCEPT — planejado, não iniciado
    28	
    29	## Preço
    30	
    31	Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa.
    32	Quem já pagou: preço congelado para sempre.
    33	Reembolso: disponível; quem sai fica com o material até a data de saída.
    34	
    35	## Canais de acesso (NÃO são tiers comerciais)
    36	
    37	> Esclarecimento (2026-06-07, auditoria Guarani): há **um único produto comercial** — R$4 vitalício. Os "canais" abaixo não são planos com preços diferentes; são **onde** o EGOS aparece. Só um deles é a venda.
    38	
    39	| Canal | Natureza | O que é |
    40	|-------|----------|---------|
    41	| Telegram | Gratuito (fomento) | Comunidade aberta, método público — porta de entrada, não produto pago |
    42	| GPT personalizado | Gratuito (onboarding) | Enio cria e compartilha; pessoa não paga — clareza + método (dado genérico) |
    43	| **WhatsApp + GPT + MCP** | **R$4 vitalício (ÚNICO produto pago)** | O produto comercial: agente vivo + acesso a tudo + evoluções |
    44	| IDE + SSOT (Claude Code) | Stack interna dos criadores | Ferramenta de desenvolvimento do EGOS, NÃO um tier de prateleira |
    45	
    46	*v1.1 — 2026-06-07 · Removida ambiguidade de tiers (auditoria Guarani #4): 1 produto pago (R$4), o resto é fomento gratuito ou stack interna.*
    47	*v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*

codex
The patch introduces documentation inconsistencies in a newly labeled SSOT, including a contradiction of the one-product model and a dependency on an archived GTM SSOT. These should be fixed before treating the launch plan as authoritative.

Full review comments:

- [P2] Avoid reintroducing commercial tiers — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:17-24
  This new SSOT describes an “escada de tiers” with Tier 2/3 prices “a definir”, which contradicts the same patch’s PRODUCT_MODEL clarification that EGOS has exactly one commercial product at R$4 and the rest are free/onboarding or internal stack. Because this file is marked as an SSOT and intended to drive launch copy, downstream docs or public messaging can treat setup/IDE as commercial tiers again; please reframe these as phases/channels or explicitly mark non-product internal/future experiments.

- [P2] Link to the active GTM source instead — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:5-5
  This launch plan links `../GTM_SSOT.md` as a related source, but that file is explicitly `STATUS: ARCHIVED` and points readers to replacement SSOTs. Since this new file is meant to guide onboarding/launch execution, following the archived GTM doc can reintroduce obsolete strategy; link the active replacement docs directly or remove the archived GTM dependency.
The patch introduces documentation inconsistencies in a newly labeled SSOT, including a contradiction of the one-product model and a dependency on an archived GTM SSOT. These should be fixed before treating the launch plan as authoritative.

Full review comments:

- [P2] Avoid reintroducing commercial tiers — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:17-24
  This new SSOT describes an “escada de tiers” with Tier 2/3 prices “a definir”, which contradicts the same patch’s PRODUCT_MODEL clarification that EGOS has exactly one commercial product at R$4 and the rest are free/onboarding or internal stack. Because this file is marked as an SSOT and intended to drive launch copy, downstream docs or public messaging can treat setup/IDE as commercial tiers again; please reframe these as phases/channels or explicitly mark non-product internal/future experiments.

- [P2] Link to the active GTM source instead — /home/enio/egos/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md:5-5
  This launch plan links `../GTM_SSOT.md` as a related source, but that file is explicitly `STATUS: ARCHIVED` and points readers to replacement SSOTs. Since this new file is meant to guide onboarding/launch execution, following the archived GTM doc can reintroduce obsolete strategy; link the active replacement docs directly or remove the archived GTM dependency.
```
