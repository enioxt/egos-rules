# Codex Local Review — 2026-06-07T17:39:42Z

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
session id: 019ea32b-492b-7a01-8ff8-e16d391825e0
--------
user
changes against 'HEAD~3'
2026-06-07T17:39:45.627970Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T17:39:45.627974Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff --stat 2ebf36531b5e57563e2743e3d4597598cf4f1058 && git diff --name-only 2ebf36531b5e57563e2743e3d4597598cf4f1058' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                      | 34 +++++++++---
 TASKS_ARCHIVE.md                              |  7 +++
 apps/egos-landing/public/timeline/rss         |  2 +-
 apps/egos-landing/public/timeline/rss.xml     |  2 +-
 docs/business/founding-pass/pricing-policy.md | 13 +++--
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md  | 30 +++++++++--
 docs/strategy/PRODUCT_MODEL.md                |  7 ++-
 docs/strategy/gpt-tier0-package.md            | 74 +++++++++++++++++++++++++++
 8 files changed, 148 insertions(+), 21 deletions(-)
TASKS.md
TASKS_ARCHIVE.md
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/business/founding-pass/pricing-policy.md
docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
docs/strategy/PRODUCT_MODEL.md
docs/strategy/gpt-tier0-package.md

exec
/bin/bash -lc 'git diff 2ebf36531b5e57563e2743e3d4597598cf4f1058 --' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index ace631b8..c5aaabfe 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -10,12 +10,12 @@
 
 ## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 > Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
-- [ ] **COPY-PRICE-RECONCILE-001** [P1] `voz` `gated:HITL` — alinhar ~10 arquivos de copy pública (founding-pass/social-copy.md, posts-ready-to-publish.md, social-media/*, competitive-analysis.md) de R$2 → R$4 ×2 preço único. NÃO blastar com sed — passe de voz preservando argumentação, corte Enio antes de publicar.
+- [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [ ] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — experimento mínimo "validar os dois" (comunidade/material + setup assistido) COMEÇANDO DE GRAÇA (sem cobrança, sem PCMG risk): publicar artefato grátis (deploy landing HITL) → 1ª pessoa interessada vira teste de setup assistido gratuito → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
-- [ ] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — atualizar README p/ refletir a nova realidade (foco = método "IA que prova o que afirma" + literacia governada). Liga README-OVERHAUL-001. Só após preço/foco travados (já travados). HITL.
+- [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
 - [ ] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — auditoria Guarani #1: metaprompt v3 hardcoded inline em App.tsx (drift vs docs/drafts/free-artifact-egos-v0.md). Build Vite pré-compila do markdown canônico → src/data/metaprompt-source.ts. Evita drift SSOT.
 - [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
-- [ ] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — auditoria Guarani #3: artefato v3 mescla Tutor (socrático) + Operacional (formato rígido); modelos fracos confundem. Adicionar Golden Example de transição Tutor→Operacional. Melhora direto o produto Tier 0. HITL (R-PUB-001).
+- [/] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — Golden Example Tutor→Operacional REDIGIDO (gpt-tier0-package.md §2, bloco a anexar). Falta HITL + colar no artefato/GPT. Guarani #3.
 - [ ] **GIT-HISTORY-PII-DEEPSCAN-001** [P1] `guardiao`+`redzone` 🔴 — auditoria Guarani #5 (corrigida): egos NÃO tem arquivos OP-* no histórico (verificado), mas antes de QUALQUER abertura pública do egos, scan PROFUNDO de PII no conteúdo do histórico (não só paths). Repo público hoje = egos-governance (curado). NÃO filter-repo sem evidência + corte Enio (T0).
 
 ## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
@@ -24,12 +24,10 @@
 > Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
 > PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
 
-- [ ] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — Criar o GPT próprio EGOS no ChatGPT: (a) metaprompt = artefato v3 (free-artifact-egos-v0.md) com identidade EGOS completa; (b) MCP configurado apontando para egos.ia.br/mcp (bridge pública); (c) ferramentas expostas: Guard Brasil (scan PII), item-intake, metaprompts, knowledge base; (d) memória ChatGPT ativa; (e) link público para distribuir (quem tem o link = usa o agente). Smoke: usuário clica no link → GPT abre → MCP responde → tool funciona. Sem setup do usuário. HITL: Enio aprova metaprompt do GPT antes de publicar o link.
+- [/] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — PACOTE DE MONTAGEM PRONTO (docs/strategy/gpt-tier0-package.md): nome+descrição, instruções (=artefato+golden example), knowledge files, starters, smoke, o-que-fica-fora. Tier 0 grátis (sem MCP ainda). Falta: HITL Enio → Enio cria no ChatGPT → compartilha link. MCP Actions = v1 (liga MCP-EGOS-PUBLIC-001).
 - [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md.
-- [ ] **PRODUCT-TIERS-001** [P0] `prime` `gated:HITL` — Documentar pirâmide de acesso EGOS: (1) Telegram gratuito (comunidade global); (2) WhatsApp R$4 (agente vivo + grupo + resumo 7h); (3) GPT próprio + MCP (acesso completo às ferramentas do VPS — incluído no R$4 ou tier separado? Enio decide); (4) IDE + SSOT (modo profissional completo). SSOT: `docs/business/product-tiers.md`. Clarifica o que cada tier entrega e se GPT está no R$4 ou é tier separado.
-- [ ] **PRODUCT-R4-DEFINITION-001** [P0] `prime` — Documentar o que R$4 compra: acesso ao grupo WhatsApp EGOS (número +55 34 9793-4688 configurado como agente EGOS) + agente responde/interage 24h + resumo diário 7h automático + acesso completo a tudo (metaprompts, tools, roadmap). Telegram = gratuito/aberto/comunidade global. WhatsApp = pago/privado/agente vivo. SSOT: `docs/business/product-r4.md`.
 - [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
-- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar formalmente: preço inicial R$4, progressão ×2 (R$4→R$8→R$16→...), produto = acesso ao grupo WhatsApp + tudo que temos. Criar/atualizar `docs/business/founding-pass/pricing-ledger.jsonl` com entrada datada. Também: documentar modelo de co-ownership (participantes colaboram com código/idéias e participam da receita quando projetos avançam). HITL: Enio valida ledger antes de qualquer divulgação.
+- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar INTERNAMENTE (não é divulgação): ledger `docs/business/founding-pass/pricing-ledger.jsonl` com R$4 + progressão ×2 (já em pricing-policy v1.1) + modelo de co-ownership (colaboradores participam da receita). ⚠️ Preço NÃO é público (corte Enio 2026-06-07) — ledger é SSOT interno/checkout, nunca comunicação. HITL: Enio valida ledger.
 - [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
 - [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
 - [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
@@ -862,6 +860,28 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ---
 
+## 🧹 INTELINK PUBLIC RELEASE — capacidades de kernel (Enio 2026-06-07)
+> SSOT desta frente: `docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md`
+> Trilha escolhida p/ execução: **WS4 primeiro** (purge tool → limpa intelink-platform automaticamente).
+
+### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
+- [ ] **PII-PURGE-001** [P0] `prime`+`forja` — Scaffold `packages/pii-purge/` + EntityDictionary schema (JSON gitignored `~/.egos-purge-entities.json`). Reusa guard-brasil/masks/fuzzy-name (não criar do zero — ver handoff §4).
+- [ ] **PII-PURGE-002** [P0] `forja` — Pattern Generator: entidade conhecida → todas variantes (CPF formatado/cru, placa antiga/Mercosul, nome via `normalizeOrtho`). Reusa `intelink/lib/masks.ts` + `fuzzy-name.ts`.
+- [ ] **PII-PURGE-003** [P0] `forja` — Scanner CLI (fork `scripts/security/scan-hardcoded-sensitive.ts` + flag `--entity-dict`). NUNCA imprime valor casado. JSON report.
+- [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
+- [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
+- [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
+- [ ] **PII-PURGE-007** [P0] `prime` `gated:HITL` — Aplicar o motor ao `intelink-clean` (resolve WS1 automaticamente): remover RELINT + mascarar 6 arquivos + verify. Nada vai pro GitHub sem corte do Enio.
+
+### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
+- [ ] **DISCOVER-GATE-001** [P1] `forja` — `scripts/discover-capability.ts <termo>`: busca 4 registries (CAPABILITY/MCP/INTEGRATION/SKILLS) + codebase-memory-mcp + CBC-*. Devolve reuse|extend|new + justificativa.
+- [ ] **DISCOVER-GATE-002** [P1] `forja` — Detector de criação nova no pre-commit (novo `packages/*`, `.claude/commands/*.md`, `CBC-*.md`, entrada em registry, `agents/skills/*.ts`). Estende `.husky/_checks/5.95-capability-detector.sh`.
+- [ ] **DISCOVER-GATE-003** [P1] `prime` — Trava + trailer `CONSULTED-SSOT:` obrigatório no commit body (exit 1 sem prova de consulta). Modela no SSOT-gate 5.7 existente.
+- [ ] **DISCOVER-GATE-004** [P2] `sentinela` — Auto-consulta periódica (cron + Layer `/start` reportando drift de registry via `gen-registry-parity-counts.ts`).
+- [ ] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar.
+
+---
+
 ## 🤖 HERMES AUTO-TASKS
 
 ### 🔴 P0 EMERGENCIAL — Secrets reais expostos no git público
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 7d5ba159..24db24f8 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3697,3 +3697,10 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
 - [x] **PRODUCT-MODEL-TIERS-CLARIFY-001** [P1] — auditoria Guarani #4: PRODUCT_MODEL.md "sem tiers" mas tabela de canais ambígua → clarificado v1.1 (1 produto pago R$4; resto = fomento grátis ou stack interna) — commit /end
 
+
+## Archived 2026-06-07
+
+### 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
+- [x] **PRODUCT-TIERS-001** [P0] — OBSOLETA: Enio cravou "sem tiers" (PRODUCT_MODEL); canais≠tiers clarificado v1.1 (bdb5d265). GPT grátis + WhatsApp R$4 = 1 produto pago. Sem pirâmide de preços.
+- [x] **PRODUCT-R4-DEFINITION-001** [P0] — coberto em PRODUCT_MODEL.md "O que está incluso" + "preço não é público". SSOT = PRODUCT_MODEL.md (não criar product-r4.md).
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
diff --git a/docs/business/founding-pass/pricing-policy.md b/docs/business/founding-pass/pricing-policy.md
index c6341955..31e83b2c 100644
--- a/docs/business/founding-pass/pricing-policy.md
+++ b/docs/business/founding-pass/pricing-policy.md
@@ -136,15 +136,14 @@ O preco nao e funcao matematica do numero de vendas. Ele reflete:
 
 ---
 
-## 8. Frase publica oficial de politica de preco
+## 8. Comunicacao publica de preco — NAO HA (corte Enio 2026-06-07)
 
-Para uso em paginas de venda, posts de lancamento e comunicacao direta:
+**Preco NAO e argumento publico.** Nao se comunica, nao se justifica, nao se ancora valor em publico. Sem "por que R$X", sem "preco baixo por estrategia", sem "dobra a cada lote", sem frase oficial de preco.
 
-> "O preco do EGOS Framework começa em R$4 para os primeiros compradores e dobra a cada lote conforme o conteudo evolui. Toda subida e anunciada com antecedencia e o preco anterior e sempre informado. Quem entra primeiro, paga menos — agora e sempre. Preco unico: o acesso e ao todo, vitalicio."
-
-Variacao curta (para post/story):
-
-> "R$4 agora, dobra a cada lote. Acesso vitalicio a tudo. Sem pegadinha."
+- O numero aparece SO no momento do acesso/checkout.
+- O fundador decide quando sobe (4→8→16...), possivelmente por numero de pessoas — definindo o proprio valor.
+- A comunicacao publica fala do METODO ABERTO + acesso vitalicio a tudo — nunca do valor.
+- Internamente (esta policy) os numeros R$4 ×2 e a progressao seguem valendo; isto e SSOT interno, nao copy publica.
 
 ---
 
diff --git a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
index 20330d4d..b10c9a85 100644
--- a/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
+++ b/docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md
@@ -41,9 +41,9 @@
 **Curta:** O onboarding gratuito começa com uma pergunta bem feita. Em vez de despejar texto genérico, o GPT entende o contexto, separa o que sabe do que supõe e mostra o que ainda precisa perguntar. Uma IA que não finge certeza.
 **Longa:** O GPT gratuito faz a pergunta certa antes de responder. A pessoa entra sem pagar, descreve sua realidade e recebe um primeiro desenho do próprio setup: objetivos, riscos, limites, próximos passos e pontos a confirmar. A diferença não é parecer mais inteligente — é ser mais honesto: mostra o que entendeu, o que infere e o que não sabe. Para quem está cansado de IA genérica, pode ser o primeiro contato com um método responsável de usar IA.
 
-### 3.3 Founding Pass (preço)
-**Curta:** Entrada antecipada no EGOS. Preço baixo por estratégia de acesso: quem entra primeiro valida o método, acompanha a evolução e mantém o valor de entrada para sempre. A cada lote, o preço dobra. Acesso vitalício; o preço não muda conforme a quantidade de material.
-**Longa:** O Founding Pass forma a primeira base sem transformar acesso em barreira. O primeiro lote é mais barato porque entra mais cedo, com mais partes em evolução. Quando novos lotes abrirem, o valor dobra. Não se cobra por "pacotes de conteúdo" nem por volume: é preço único para acesso vitalício ao ecossistema e às evoluções incluídas. Quem entra antes assume mais incerteza de produto e paga menos para sempre.
+### 3.3 Founding Pass (acesso) — ⚠️ PREÇO NÃO É COPY PÚBLICA (corte Enio 2026-06-07)
+> Não se comunica nem se justifica preço em público. Sem "por que R$X", sem âncora, sem "preço baixo por estratégia", sem "dobra a cada lote". O número aparece **só no momento do acesso/checkout**. O fundador decide quando sobe (talvez por nº de pessoas: 4→8→16) — definindo o próprio valor. O público fala do **método aberto + acesso vitalício a tudo**, nunca do valor.
+**Copy de acesso (sem número):** "Acesso fundador ao EGOS — método aberto, comunidade e tudo que existe hoje, mais o que vier. Vitalício." (o valor aparece no checkout, não no discurso)
 
 ### 3.4 Escada de valor (Tier 0 → Fase 2)
 **Curta:** O GPT gratuito trabalha com exemplos e ajuda a desenhar o setup. A Fase 2 existe porque dado real exige outro tratamento: deve ficar na máquina da pessoa, com segurança e soberania. Esse limite não é tática comercial — é princípio operacional do EGOS.
@@ -106,4 +106,28 @@
 
 ---
 
+---
+
+## 8. README — abertura (DRAFT p/ HITL — README-FOCUS-REFLECT-001)
+
+> Voz EGOS-entidade, colaborativa, sem absoluto, sem preço, sem persona. Substitui a abertura atual; o overhaul completo (badges/bilíngue) fica no README-OVERHAUL-001.
+
+```markdown
+# EGOS
+
+**EGOS ajuda a usar IA com mais confiança** — tornando as respostas mais
+verificáveis, auditáveis e governadas, com revisão humana. Um framework
+brasileiro para quem quer decidir com base em evidência, não em promessa.
+
+## Comece aqui — grátis em 2 minutos
+[link do GPT Tier 0] · [artefato governado] · método aberto, sem cadastro.
+
+## O que o EGOS faz
+- Separa o que a IA sabe, supõe e não sabe (anti-alucinação).
+- Mantém lastro de evidência e revisão humana nas decisões que importam.
+- Protege seus dados — o que é sensível fica com você.
+
+> O método é aberto. O acesso fundador dá tudo que existe hoje + o que vier, vitalício.
+```
+
 *SSOT deste plano: este arquivo. Copy v1 = Codex gpt-5.5 2026-06-07 (DRAFT-HITL). Tudo pendente de corte do Enio antes de publicar.*
diff --git a/docs/strategy/PRODUCT_MODEL.md b/docs/strategy/PRODUCT_MODEL.md
index 055713af..d59dd279 100644
--- a/docs/strategy/PRODUCT_MODEL.md
+++ b/docs/strategy/PRODUCT_MODEL.md
@@ -26,11 +26,14 @@ Nunca prometer o que é [CONCEPT]. Status de cada área publicado com honestidad
 - 🟡 WIP — em desenvolvimento
 - 🔵 CONCEPT — planejado, não iniciado
 
-## Preço
+## Preço (INTERNO — não é comunicação pública)
 
-Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa.
+> **Corte Enio 2026-06-07:** preço NÃO é assunto público. Não se comunica/justifica/ancora valor. Os números abaixo são SSOT interno (checkout). Em público, fala-se do método aberto + acesso vitalício, nunca do valor. SSOT da regra: [pricing-policy.md §8](../business/founding-pass/pricing-policy.md).
+
+Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa — o fundador decide quando subir (talvez por nº de pessoas).
 Quem já pagou: preço congelado para sempre.
 Reembolso: disponível; quem sai fica com o material até a data de saída.
+O número aparece só no checkout — nunca no discurso/copy.
 
 ## Canais de acesso (NÃO são tiers comerciais)
 
diff --git a/docs/strategy/gpt-tier0-package.md b/docs/strategy/gpt-tier0-package.md
new file mode 100644
index 00000000..6617d74a
--- /dev/null
+++ b/docs/strategy/gpt-tier0-package.md
@@ -0,0 +1,74 @@
+# GPT Tier 0 EGOS — pacote de montagem (DRAFT — HITL)
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT pronto p/ Enio criar+compartilhar no ChatGPT. Nada publicado.
+**Liga:** GPT-EGOS-CUSTOM-001, GUARANI-ADAPTIVE-PROMPT-001, VALIDATE-BOTH-EXPERIMENT-001.
+**Regra:** preço não aparece aqui (corte Enio). Tudo público (assume extraível via prompt-leak) — nada de infra/dado/secret.
+
+> Como usar: ChatGPT → Explorar GPTs → Criar → preencher os campos abaixo. Enio cria e compartilha o link; quem recebe usa de graça.
+
+---
+
+## 1. Nome + descrição
+
+- **Nome:** Assistente EGOS — IA com método
+- **Descrição (≤300 chars):** Ajuda você a usar IA com mais confiança. Faz a pergunta certa, separa o que sabe do que supõe, e te ajuda a montar um jeito governado de usar IA — sem inventar, sem vazar seus dados. Método aberto do EGOS.
+
+## 2. Instruções (system prompt)
+
+> **SSOT (não duplicar):** o corpo das instruções = conteúdo de [`docs/drafts/free-artifact-egos-v0.md`](../drafts/free-artifact-egos-v0.md) (Assistente Profissional Governado: modo tutor de configuração socrático + classificação CONFIRMADO/INFERIDO/HIPÓTESE + anti-alucinação + Zona Vermelha + proteção de dados + formato de saída). Colar esse conteúdo no campo de instruções do GPT **+** anexar o bloco abaixo (Guarani #3, transição Tutor→Operacional p/ blindar modelos fracos).
+
+**Bloco a anexar — Golden Example de transição (Tutor → Operacional):**
+```
+── EXEMPLO DE TRANSIÇÃO (siga este comportamento) ──
+Enquanto houver [colchetes] vazios, você está em MODO TUTOR (conversacional, UMA pergunta por vez, sem formato rígido).
+Assim que o usuário CONFIRMAR a configuração, vire MODO OPERACIONAL (formato de saída rígido) e não volte ao tutor.
+
+Exemplo:
+[TUTOR]
+Usuário: "trabalho com contabilidade"
+Assistente: "Com base na sua área (contabilidade), me configuraria assim: Nome: Assistente Contábil Governado | Escopo: conferência de documentos, organização de prazos, apoio a apuração | Fora do escopo: parecer contábil conclusivo. Confirma ou quer ajustar?"
+Usuário: "confirma"
+[A PARTIR DAQUI = OPERACIONAL, formato rígido:]
+Assistente:
+Classificação: AÇÃO
+Síntese: Configurado como Assistente Contábil Governado. Em que posso ajudar agora?
+Próxima ação: me diga a tarefa de hoje.
+── fim do exemplo ──
+```
+
+## 3. Knowledge files (anexar — tudo público)
+
+- `docs/drafts/free-artifact-egos-v0.md` (Parte 2: checklist de segurança de IA em 1 página)
+- `docs/metaprompts/MP-*.md` (os 16 metaprompts governados — exportar como 1 PDF/MD compilado)
+- `docs/courses/modulo-01-primeiro-agente.md` (literacia: primeiro agente)
+- (opcional) 2-3 use cases curtos sanitizados
+
+## 4. Conversation starters
+
+- "Qual é a sua área? Quero te ajudar a montar um jeito governado de usar IA."
+- "O que você quer que a IA faça por você sem vazar seus dados?"
+- "Me mostra uma resposta de IA que você desconfiou — vamos verificar juntos."
+- "Quero aprender a usar IA sem ela inventar. Por onde começo?"
+
+## 5. Fica FORA (vazaria + R-SEC-002)
+
+❌ infra/ops/observability/browser-automation · dado real/PII/PCMG/cliente · secrets/tokens/bridge interno · qualquer coisa que você não publicaria. (Coerente com transparência radical: método aberto; máquina e dado, não.)
+
+## 6. Smoke (validação real antes de declarar pronto)
+
+1. Abrir o GPT como usuário sem Plus → faz 1 pergunta → ele infere setup → classifica honestamente (CONFIRMADO/INFERIDO/HIPÓTESE) → não inventa.
+2. Forçar o limite: pedir p/ processar "dado real sensível" → ele deve recusar e orientar Fase 2 (soberania), não engolir o dado.
+3. Colar resposta no handoff: "abriu / inferiu / classificou / recusou dado real" = [DONE]; senão [CONCEPT].
+
+## 7. HITL (corte Enio antes de publicar)
+
+- Enio revisa as instruções finais (R-PUB-001) antes de criar.
+- Enio cria o GPT e gera o link de compartilhamento.
+- Preço: NÃO mencionar no GPT (mistério; só no checkout do produto pago, fora do Tier 0 grátis).
+
+---
+
+## v1 (depois de validar Tier 0) — [VERIFICAR]
+- MCP-em-GPT custom roda hoje? Se sim, expor via Actions: `guard_check` (scan PII), `get_metaprompt`, `knowledge_search` (MCP-EGOS-PUBLIC-001) — mantendo o limite de soberania de dado.
+
+*DRAFT — pendente HITL do Enio. SSOT do design: memory `project_egos_custom_gpt_onboarding_design`.*

exec
/bin/bash -lc 'ls docs/drafts/free-artifact-egos-v0.md docs/courses/modulo-01-primeiro-agente.md docs/metaprompts/MP-*.md 2>/dev/null | head -20; test -f docs/drafts/free-artifact-egos-v0.md; echo draft:$?; test -f docs/courses/modulo-01-primeiro-agente.md; echo course:$?; ls docs/metaprompts/MP-*.md 2>/dev/null | wc -l' in /home/enio/egos
 succeeded in 0ms:
docs/courses/modulo-01-primeiro-agente.md
docs/drafts/free-artifact-egos-v0.md
docs/metaprompts/MP-AGENT-001.md
docs/metaprompts/MP-AGENT-002.md
docs/metaprompts/MP-AUDIT-001.md
docs/metaprompts/MP-DEVOPS-001.md
docs/metaprompts/MP-HANDOFF-001.md
docs/metaprompts/MP-ITEM-INTAKE-001.md
docs/metaprompts/MP-LGPD-001.md
docs/metaprompts/MP-MATERIAL-EVAL-001.md
docs/metaprompts/MP-PIPELINE-001.md
docs/metaprompts/MP-PRICE-001-005.md
docs/metaprompts/MP-QA-001.md
docs/metaprompts/MP-RESEARCH-001.md
docs/metaprompts/MP-REVIEW-001.md
docs/metaprompts/MP-SEC-001.md
docs/metaprompts/MP-SEC-002.md
docs/metaprompts/MP-SKILL-001.md
draft:0
course:0
16

mcp: codebase-memory-mcp/list_projects started
mcp: codebase-memory-mcp/list_projects (completed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
exec
/bin/bash -lc 'test -f docs/_current_handoffs/handoff_2026-06-07-intelink-public-release.md; echo handoff:$?; ls docs/_current_handoffs | tail' in /home/enio/egos
 succeeded in 0ms:
handoff:0
INIT_AGENT-C_2026-06-05.md
PRIME_TO_GUARANI_2026-06-03_irb-premortem.md
PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md
PRIME_TO_SONNET_2026-06-04_security-vision-tasks.md
_TEMPLATE_sync.md
_merge_2026-05-30
_merge_2026-06-02
_merge_2026-06-03
handoff_2026-06-07-intelink-public-release.md
handoff_2026-06-07.md

exec
/bin/bash -lc "grep -R \"R\\"'$'"\\|preço\\|preco\\|dobr\" -n docs/metaprompts/MP-*.md | head -40" in /home/enio/egos
 succeeded in 0ms:
docs/metaprompts/MP-ITEM-INTAKE-001.md:67:   real de preco vira flag no relatorio (a prova viva de IA governada).
docs/metaprompts/MP-ITEM-INTAKE-001.md:72:- Nao inventa preco/custo/codigo/estoque — faltou na imagem → `null` + gap explicito.
docs/metaprompts/MP-ITEM-INTAKE-001.md:82:- [ ] Divergencia de preco entre passadas vira **flag** no `revisao.md` (HITL provado).
docs/metaprompts/MP-ITEM-INTAKE-001.md:120:  "map": { "nome": "Nome", "categoria": "Categoria", "preco": "Preco" } }
docs/metaprompts/MP-ITEM-INTAKE-001.md:131:semantico (preco fora de faixa = suspeito, task VERIFIER-SEMANTIC-001) e candidato a
docs/metaprompts/MP-MATERIAL-EVAL-001.md:22:- Para decidir se material justifica um preço de mercado
docs/metaprompts/MP-MATERIAL-EVAL-001.md:82:2. **value** — Valor percebido vs preço (peso 1.2)
docs/metaprompts/MP-PRICE-001-005.md:16:**Entrada:** Número de vendas no lote atual, preço atual, preço do próximo lote definido no plano, data da primeira venda do lote.
docs/metaprompts/MP-PRICE-001-005.md:18:**Red Zone:** Não subir preço automaticamente. Não comunicar mudança ao público. Não alterar nenhum arquivo de configuração.
docs/metaprompts/MP-PRICE-001-005.md:36:2. Calcule a receita acumulada deste lote (vendas × preço atual).
docs/metaprompts/MP-PRICE-001-005.md:59:**Quando usar:** Enio aprovou a subida de preço verbalmente ou por escrito. Usar para gerar o registro formal antes de qualquer mudança técnica.
docs/metaprompts/MP-PRICE-001-005.md:60:**Entrada:** Decisão de Enio (texto literal), preço anterior, novo preço, número do lote, número de vendas que disparou a mudança.
docs/metaprompts/MP-PRICE-001-005.md:74:- Novo preço aprovado: R$ ___
docs/metaprompts/MP-PRICE-001-005.md:118:**Quando usar:** Após a subida de preço ser registrada no ledger (MP-PRICE-002 concluído). Antes de qualquer publicação pública.
docs/metaprompts/MP-PRICE-001-005.md:119:**Entrada:** Preço anterior, novo preço, número do lote, data da mudança, canal de publicação pretendido.
docs/metaprompts/MP-PRICE-001-005.md:131:- Novo preço: R$ ___
docs/metaprompts/MP-PRICE-001-005.md:142:   - O preço anterior e o novo preço (sem riscar o anterior artificialmente)
docs/metaprompts/MP-PRICE-001-005.md:143:   - A razão simples da subida (mais vendas = mais evidência = preço maior)
docs/metaprompts/MP-PRICE-001-005.md:227:   - Próximo preço planejado: R$ ___
docs/metaprompts/MP-PRICE-001-005.md:243:   - Divergência entre preço no ledger e no counter.
docs/metaprompts/MP-QA-001.md:118:**Spec:** `POST /v1/quote` retorna preco/disponibilidade; rejeita SKU invalido → 422
docs/metaprompts/MP-RESEARCH-001.md:36:PROFUNDIDADE   : <rasa (landscape) | media (players + gaps) | funda (diferenciais + precos)>

exec
/bin/bash -lc "nl -ba docs/strategy/gpt-tier0-package.md | sed -n '36,50p'; nl -ba docs/metaprompts/MP-PRICE-001-005.md | sed -n '118,150p'" in /home/enio/egos
 succeeded in 0ms:
    36	── fim do exemplo ──
    37	```
    38	
    39	## 3. Knowledge files (anexar — tudo público)
    40	
    41	- `docs/drafts/free-artifact-egos-v0.md` (Parte 2: checklist de segurança de IA em 1 página)
    42	- `docs/metaprompts/MP-*.md` (os 16 metaprompts governados — exportar como 1 PDF/MD compilado)
    43	- `docs/courses/modulo-01-primeiro-agente.md` (literacia: primeiro agente)
    44	- (opcional) 2-3 use cases curtos sanitizados
    45	
    46	## 4. Conversation starters
    47	
    48	- "Qual é a sua área? Quero te ajudar a montar um jeito governado de usar IA."
    49	- "O que você quer que a IA faça por você sem vazar seus dados?"
    50	- "Me mostra uma resposta de IA que você desconfiou — vamos verificar juntos."
   118	**Quando usar:** Após a subida de preço ser registrada no ledger (MP-PRICE-002 concluído). Antes de qualquer publicação pública.
   119	**Entrada:** Preço anterior, novo preço, número do lote, data da mudança, canal de publicação pretendido.
   120	**Saída:** Rascunho de texto para aprovação. Nunca publicado automaticamente.
   121	**Red Zone:** Não publicar. Não enviar. Não agendar. Apenas rascunhar.
   122	**HITL:** Enio lê, ajusta e aprova. Só então o texto é publicado manualmente.
   123	
   124	## Prompt
   125	
   126	```
   127	Você é o redator de comunicação do EGOS Founding Pass. Escreve — não publica.
   128	
   129	DADOS DA MUDANÇA (preencher antes de usar):
   130	- Preço anterior: R$ ___
   131	- Novo preço: R$ ___
   132	- Número do lote encerrado: ___
   133	- Número do lote novo: ___
   134	- Data da mudança: ___
   135	- Canal pretendido: [X.com / WhatsApp / Telegram / E-mail / Landing page]
   136	- Tom: [direto / explicativo / mínimo]
   137	
   138	TAREFA:
   139	1. Escreva um rascunho de comunicação para o canal informado.
   140	2. Use o formato e tom adequados ao canal.
   141	3. Inclua OBRIGATORIAMENTE:
   142	   - O preço anterior e o novo preço (sem riscar o anterior artificialmente)
   143	   - A razão simples da subida (mais vendas = mais evidência = preço maior)
   144	   - A garantia para quem já comprou (mantém acesso, sem retrocobrança)
   145	   - O link ou instrução de compra
   146	4. PROIBIDO incluir:
   147	   - Urgência artificial ("últimas horas", "não perca")
   148	   - Comparação com concorrentes
   149	   - Promessa de resultado
   150	   - Linguagem de escassez falsa

exec
/bin/bash -lc "grep -n \"R\\"'$'"\\|preço\\|preco\\|dobr\" docs/drafts/free-artifact-egos-v0.md | head -30" in /home/enio/egos
 succeeded in 0ms:
codex
The patch introduces a public GPT assembly checklist that can leak or reintroduce the exact price-talk the rest of the patch is trying to remove. No code/test breakage was found, but this is an actionable product/documentation correctness issue.

Review comment:

- [P2] Exclude price metaprompts from GPT knowledge files — /home/enio/egos/docs/strategy/gpt-tier0-package.md:42-42
  When Enio follows this package and uploads `docs/metaprompts/MP-*.md` to the public Tier 0 GPT, the wildcard includes `MP-PRICE-001-005.md`, which still contains public price-change copy templates requiring old/new `R$` values and price-rise rationale. That contradicts the new policy in this patch that price must not be public copy and can make the GPT discuss pricing if asked; please curate or sanitize the knowledge list instead of using the wildcard.
The patch introduces a public GPT assembly checklist that can leak or reintroduce the exact price-talk the rest of the patch is trying to remove. No code/test breakage was found, but this is an actionable product/documentation correctness issue.

Review comment:

- [P2] Exclude price metaprompts from GPT knowledge files — /home/enio/egos/docs/strategy/gpt-tier0-package.md:42-42
  When Enio follows this package and uploads `docs/metaprompts/MP-*.md` to the public Tier 0 GPT, the wildcard includes `MP-PRICE-001-005.md`, which still contains public price-change copy templates requiring old/new `R$` values and price-rise rationale. That contradicts the new policy in this patch that price must not be public copy and can make the GPT discuss pricing if asked; please curate or sanitize the knowledge list instead of using the wildcard.
```
