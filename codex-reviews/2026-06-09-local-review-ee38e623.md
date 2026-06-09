# Codex Local Review — 2026-06-09T14:46:09Z

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
session id: 019eacd9-1c31-77c0-9fe5-faad4a3155e8
--------
user
changes against 'HEAD~3'
2026-06-09T14:46:11.179589Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T14:46:11.181843Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 3d0f899f36ac9fc07105eaaa7dfc551838361c97 --stat && git diff 3d0f899f36ac9fc07105eaaa7dfc551838361c97' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                           |  31 ++-
 ...ETA_PROMPT_processo_arquiteto_diagnosticador.md | 175 +++++++++++++++
 docs/drafts/conselho.md                            | 134 +++++++++++
 docs/governance/HITL_CURVE_PRINCIPLE.md            | 227 +++++++++++++++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json       | 244 +++++++++++++++++++++
 docs/jobs/2026-06-09-pre-commit-pipeline.json      | 122 +++++++++++
 docs/personal-os/ENIO_UNDERSTANDING_MAP.md         |   3 +-
 7 files changed, 931 insertions(+), 5 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 019766f9..bdc39db4 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -8,6 +8,29 @@
 ---
 <!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
 
+## 🎯 FOCO ATUAL — Arquiteto-Diagnosticador (2026-06-09, WIP≤2)
+
+> **Corte Enio 2026-06-09:** identidade = arquiteto-diagnosticador que prova hipóteses com protótipos pequenos e cobra pela clareza, não pela hora de dev. Evidência: 14 sistemas auditados = **0 fecharam a cadeia** (cliente_confirmou=false em todos). Padrão: abre a conversa, abandona a confirmação. Memory: `project_arquiteto_diagnosticador_identity_2026-06-09`.
+> **Isca de valor** = comunidade + material + vídeo + Hotmart (entrada R$4 + networking), NÃO o diagnóstico. Diagnóstico vem depois, com a pessoa real.
+> **Regra dura (Enio concordou):** nenhum sistema novo começa por código — começa por conversa-diagnóstico com pessoa real nomeada.
+
+**WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
+- [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
+- [ ] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Fechar o item-intake: 1 contato ao Diesom (Kyte) — "abriu a planilha? subiu no Kyte? o que faltou?". Registrar a resposta. É o `cliente_confirmou=true` mais barato do portfólio (não precisa de código).
+
+**Regras a encodar (R-DIAG-002 a 006) — pendente corte final do Enio:** ver `project_arquiteto_diagnosticador_identity_2026-06-09` na memória. R-DIAG-002 conversa-antes-de-código; R-DIAG-003 cadeia-fecha-no-funcionou; R-DIAG-004 diagnóstico-é-produto; R-DIAG-005 anti-espelho; R-DIAG-006 sistema-sem-pessoa-30d-congela.
+
+## 🧊 CONGELADO (R-DIAG-006 — sem feature nova até ter pessoa real do outro lado)
+
+> Auditoria 2026-06-09: estes são `SO_TECH_SEM_CLIENTE` — construídos para cliente imaginário (espelho-para-dentro). Rodam se já rodam; NÃO crescem. Descongela só quando aparecer uma pessoa real nomeada.
+
+- 🧊 **gem-hunter** — 0 stars/0 forks; agente que se alimenta para público inexistente. Roda sozinho, não tocar.
+- 🧊 **eagle-eye** (egos-lab) — "first partner by <data passada>", 0 assinaturas.
+- 🧊 **egos-inteligencia** (World-Open-Graph) — já em PAUSA desde 2026-03-18. Manter cortado; referência técnica do Guard Brasil.
+- 🧊 **DPIO chatbot** — funil de qualificação sem ninguém para qualificar.
+- 🧊 **metaprompt-generator deploy** — endpoint vazio; não consertar até ter 1 LLM externo real consumindo.
+- 🧊 **Guard Brasil como PRODUTO vendável** — é CINTO (PII gate interno é uso real), não cliente. Parar GTM. MRR=0, 111 commits, 0 demo a prospect real.
+
 ## 🎯 LANÇAMENTO PÚBLICO v1 — Hotmart + Video + Divulgação (2026-06-09)
 
 > Enio decidiu parar de se esconder. Missão: finalizar, publicar, divulgar. NÃO criar ferramenta nova. NÃO abrir frente. Roteiro 2:30 pronto em docs/strategy/APRESENTACAO_EGOS.md PARTE E. Drafts de posts em docs/drafts/SOCIAL_LAUNCH_DRAFTS.md.
@@ -125,8 +148,8 @@
 > Visão Enio: todo agente reporta num PADRÃO ÚNICO (humano = smartlinks+explicado; IA = provenance+links p/ SSOT). Modelos fracos consultam as MESMAS fontes (SSOT) sempre com proveniência → acertam o report. Se um agente de IA lê QUALQUER parte do EGOS, acaba lendo o sistema inteiro (intelink fractal) → se adapta e sugere melhorias. ESTADO REAL (verificado 2026-06-04): `@egos/report-standard` (packages/report-standard/, "Report SSOT v2.0.0 — schema+validator+types") JÁ EXISTE mas NÃO está enforçado/herdado pelos agentes (reports curador/forja foram free-form). `egos` CLI instalado (~/.local/bin/egos = comms human-AI-device: send/relay/ping/repos/ecosystem). Entry points existem (README→AGENTS→SYSTEM_MAP→AGENT_BOOTSTRAP→EGOS_BOOTSTRAP).
 - [ ] **REPORT-STANDARD-ENFORCE-001** [P1] `prime`+`curador` — Wirar `@egos/report-standard` v2.0.0 como OBRIGATÓRIO: todo meta-prompt de papel (.claude/agents/*.md + metaprompt-generator) herda o contrato de report (provenance-per-claim, links p/ SSOT, formato humano c/ smartlinks). Sinergia com METAPROMPT-SHARPEN (workflow wave-1). Gap = schema existe, falta enforcement.
 - [ ] **READ-ANY-READ-WHOLE-001** [P1] `curador` — Garantir intelink fractal: todo doc/SSOT/report linka ao seu SSOT-pai + ao entry map (AGENTS.md). Meta: agente de IA entrando por qualquer ponto navega o sistema inteiro. Auditar cobertura de links + preencher buracos.
-- [ ] **GEMHUNTER-STUB-ARCHIVE-001** [P2] `curador` `gated:HITL` — Arquivar/decidir destino do stub `/home/enio/gem-hunter/` (repo standalone, sinalizado DEPRECATED). Corte Enio: mover p/ _archived ou manter como pacote publicável.
-- [ ] **SYSTEM-MAP-CLEANUP-001** [P2] `sentinela` — SYSTEM_MAP.md:38/245 + SSOT.md:38 (gem-hunter-freshness aponta egos-lab). NOTA: curador alegou packages/gem-hunter/ fantasma — FALSO (existe package.json). Re-auditar refs gem-hunter.
+- [ ] **GEMHUNTER-STUB-ARCHIVE-001** [P2] `curador` `gated:HITL` — Arquivar/decidir destino do stub `/home/enio/gem-hunter/` (repo standalone, sinalizado DEPRECATED). Corte Enio: mover p/ _archived ou manter como pacote publicável. 🧊CONGELADO
+- [ ] **SYSTEM-MAP-CLEANUP-001** [P2] `sentinela` — SYSTEM_MAP.md:38/245 + SSOT.md:38 (gem-hunter-freshness aponta egos-lab). NOTA: curador alegou packages/gem-hunter/ fantasma — FALSO (existe package.json). Re-auditar refs gem-hunter. 🧊CONGELADO
 
 ## 🤖 AGENTE EGOS PÚBLICO + BYOK (Enio 2026-06-04, pesquisa curador verificada)
 > Visão: bot Telegram + egos.ia.br/terminal como janelas públicas que MOSTRAM capacidade; modelo barato default (Gemini 2.5 Flash, já é default do orchestrator) + BYOK fluido p/ modelo caro. ESTADO REAL (curador, provenance): @egosin_bot LIVE só auth-locked p/ Enio (telegram.ts); OpenRouter integrado (orchestrator.ts:50); **BYOK JÁ EXISTE** em egos-inteligencia (header x-openrouter-key ephemeral, chat.py:881) + 852 (byok-manager.ts) — PHANTOM no egos-gateway; /terminal=PHANTOM; AnythingLLM local:3001 c/ OpenRouter+Flash+BYOK nativo (candidato a /terminal via Caddy). MVP=adaptar, não criar (~7-12h). Liga IHV-DISS-002.
@@ -188,7 +211,7 @@
 ## 🔬 GEM-HUNTER + PESQUISA CONTÍNUA (2026-06-05)
 > gem-hunter melhorado para descobrir frameworks, MCPs, papers, técnicas novas.
 
-- [ ] **GEM-HUNTER-IMPROVE-001** [P1] `curador`+`forja` — Melhorar gem-hunter para descobrir continuamente: novos frameworks de IA (aiox, LangGraph, etc.), novos MCPs, papers arXiv AI governance, técnicas cyber+OSINT, abordagens educacionais. Adicionar: filtro de relevância EGOS (alto/médio/baixo), novas fontes (arXiv, GitHub trending, HN, papers with code). SSOT: docs/gem-hunter/GEM_HUNTER_IMPROVEMENT_PLAN.md.
+- [ ] **GEM-HUNTER-IMPROVE-001** [P1] `curador`+`forja` — Melhorar gem-hunter para descobrir continuamente: novos frameworks de IA (aiox, LangGraph, etc.), novos MCPs, papers arXiv AI governance, técnicas cyber+OSINT, abordagens educacionais. Adicionar: filtro de relevância EGOS (alto/médio/baixo), novas fontes (arXiv, GitHub trending, HN, papers with code). SSOT: docs/gem-hunter/GEM_HUNTER_IMPROVEMENT_PLAN.md. 🧊CONGELADO
 
 - [ ] **CODEX-ADVERSARIAL-MATERIAL-001** [P2] `provador` — Após cada iteração do eval-loop que não atingir 7.5, enviar o material para revisão adversarial do Codex (GPT) e Antigravity (Gemini) para perspectiva externa. Usar prompts de docs/validation/prompts/. Registrar resultados em docs/validation/evaluation-results/.
 ## 🌐 COMUNICAÇÃO + README (2026-06-05, blueprint em construção)
@@ -662,7 +685,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 > SSOT: `docs/governance/EXTERNAL_ARTIFACT_INTAKE_PROTOCOL.md` v1.0. Quando Enio traz .md externo (ChatGPT/Grok/etc): land em _inbox → classifica INC-005 (REAL/CONCEPT/PHANTOM) → grande delega a agente → mapeia vs existente (não reinventar) → triagem Resolver → tasks/memória.
 - [ ] **PRICING-CLARITY-001** [P2] — Doc-fix (não muda preço): deixar legível no strategy doc que R$100/mês é o piso de recorrência (Demo Starter), não a âncora; receita 30d = setup fees, não MRR. (ChatGPT criticou baseado em leitura incompleta.)
 - [ ] **HITL-MULTICHANNEL-001** [P3] — Wire a política HITL multi-canal (Telegram+WhatsApp+email) que aparece em `.guarani/GUARANI.md` mas só tem Telegram parcial. Dispatcher único por policy.
-- [ ] **RULE-GOV-GAP-001** [P2] — `gem-hunter` ungoverned (sem CLAUDE.md/AGENTS.md). Decidir: adicionar adapter+symlinks .guarani (modelo egos-lab/852) OU marcar explicitamente externo.
+- [ ] **RULE-GOV-GAP-001** [P2] — `gem-hunter` ungoverned (sem CLAUDE.md/AGENTS.md). Decidir: adicionar adapter+symlinks .guarani (modelo egos-lab/852) OU marcar explicitamente externo. 🧊CONGELADO
 - [ ] **RULE-SYNC-001** [P2] — `blueprint-egos` 45d stale (sync a6d1ad7 2026-04-17). Rodar `bun scripts/disseminate-propagator.ts --all` p/ ressincronizar do kernel atual.
 - [ ] **INTAKE-WIRE-001b** [P3] — Wire RULE_SETS_INDEX no /start (consciência de quais regras valem onde) + monitor de lag de propagação (>30d alerta).
 - [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start (rule-set awareness) + gatilho comportamental do Prime + considerar virar skill `/intake`.
diff --git a/docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md b/docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md
new file mode 100644
index 00000000..869cc1db
--- /dev/null
+++ b/docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md
@@ -0,0 +1,175 @@
+# META-PROMPT: Pesquisa e refinamento do processo arquiteto-diagnosticador
+
+**Como usar:** Cole o bloco abaixo (entre as marcações ` ```prompt ` e ` ``` `) diretamente em
+Perplexity, Gemini, ChatGPT ou Grok. Peça que a IA faça pesquisa web atual (jun/2026).
+Itere: peça que aprofunde qualquer ponto ou responda as 3 perguntas finais que ela gerar.
+O bloco é autocontido — a IA externa não precisa conhecer nenhum contexto seu além do que está escrito.
+
+---
+
+```prompt
+## CONTEXTO — QUEM SOU
+
+Sou Enio, policial civil investigador há 20 anos que virou arquiteto de IA.
+Meu diferencial não é ser desenvolvedor — é DIAGNOSTICAR.
+Eu transponho a barreira do analógico: extraio o entendimento de pessoas que têm
+dificuldade de formular o próprio problema, e resolvo com ferramentas de IA.
+
+Construí um sistema chamado EGOS — kernel de orquestração de agentes de IA governados,
+~460+ commits, código aberto, TypeScript/Bun. Não é produto acabado; é prova de método.
+
+Posicionamento: arquiteto-diagnosticador que prova hipóteses com protótipos decisórios
+pequenos e cobra pela clareza gerada — não pela hora de desenvolvimento.
+Construo só o suficiente para o diagnóstico ser prova, não opinião.
+A escala e a execução pesada ficam com o time do cliente ou parceiros, mas sou dono
+do resultado conforme o que foi contratado.
+
+---
+
+## O PROCESSO QUE QUERO REFINAR — 5 CAMADAS + TRANSVERSAL
+
+**Camada 0 — Conversa-diagnóstico (HITL máximo)**
+Sessão estruturada para extrair o problema real — não o problema declarado.
+Ferramentas: escuta ativa, perguntas socrático-investigativas, mapeamento de fluxo atual.
+Duração: 1-2h. Entregável: mapa do problema assinado pelo cliente.
+Saída desta camada: "vale continuar?" — go/no-go explícito.
+
+**Camada 1 — Diagnóstico estruturado**
+Transformo a conversa em documento de diagnóstico com: problema central, hipóteses
+ranqueadas por impacto, lacunas de dado, pontos de alavancagem, cenários A/B com
+custo-benefício real. HTML interativo + áudio explicativo (NotebookLM).
+Entregável: diagnóstico como produto (pode ser precificado separadamente).
+Se o cliente pagou só pelo diagnóstico, o engajamento fecha aqui — sem escopo que vaza.
+
+**Camada 2 — Protótipo decisório (mínimo que prova)**
+Construo exatamente o que é necessário para transformar o diagnóstico em prova.
+Não é MVP de produto — é prova de hipótese: chatbot de triagem, classificador,
+pipeline de ingestão de dado, agente de extração. Roda em 3-7 dias.
+Critério de aceite: o cliente consegue tomar uma decisão diferente com esse protótipo do que
+tomaria sem ele. Se não consegue → protótipo errado, volta para Camada 1.
+
+**Camada 3 — Spec executável**
+Documentação para que outro time (interno do cliente ou parceiro técnico) implemente
+a solução completa. Inclui: arquitetura de dados, fluxo de agentes, gates de governança,
+critérios de avaliação (golden cases), requisitos de segurança/PII, SLO mínimo.
+Não é código; é o "manual de como construir isso sem mim".
+
+**Camada 4 — Ponte até o resultado**
+Se o cliente contratou "problema resolvido" (não só diagnóstico), garanto a ponte:
+oriento o time deles, indico parceiros, revioro entregas, valido que o resultado
+funciona no dado real. Nunca deixo na mão. A entrega bate com o que foi contratado —
+se pagou pelo diagnóstico, fecha no diagnóstico; se pagou pelo resultado, garanto a ponte.
+
+**Camada transversal — Sistema aberto / autoresearch**
+Enquanto trabalho, um sistema de curadoria (179 ferramentas/dia de 14 fontes)
+atualiza meu repertório. Uso essa inteligência para recomendar ferramentas atuais
+e não reinventar o que já existe.
+
+**Curva de HITL (Human-in-the-Loop):**
+Alto na Camada 0 (o humano define o problema); decresce nas Camadas 1-2 (IA trabalha);
+sobe na validação final de cada camada (humano assina). Nunca zero — governança explícita.
+
+---
+
+## O QUE JÁ TENHO — ativos reais (para você não sugerir o que já existe)
+
+- Gateway WhatsApp multi-tenant em produção (Evolution API + Gemini), com rate-limiting
+  e fallback de modelo — suporta vários clientes no mesmo worker.
+- Guard Brasil: detecção e masking de PII brasileiro (CPF/CNPJ/telefone/e-mail/placa),
+  disponível como pacote npm, API REST e MCP para Claude.
+- item-intake: pipeline foto de cardápio → planilha de PDV — caso completo provado
+  (diagnóstico → protótipo → dado real → gate HITL → deploy em produção).
+- Storefront multi-tenant (G Peças, APeças Patense) com checkout Pix integrado.
+- Skills de diagnóstico codificadas como comandos:
+  /readiness (avalia se empresa está pronta para IA, 7 dimensões + veredito PRONTA/PARCIAL/NÃO-AINDA),
+  /inception (gate obrigatório antes de iniciar projeto novo),
+  /diag (diagnóstico técnico de sistema),
+  /recon (prospecção e análise de empresa por CNPJ).
+- eval-runner: sistema de golden cases para validar capacidades de agentes —
+  método anti-alucinação que classifica CONFIRMADO/INFERIDO/HIPÓTESE/PHANTOM
+  e exige proveniência (file:line) em toda afirmação sobre o sistema.
+- NotebookLM pipeline: gera áudio, slides e HTML de diagnóstico a partir de markdown —
+  entregável didático para o cliente sem exigir que ele leia doc técnico.
+- Hermes: orquestrador VPS sempre ligado, cron de autoresearch, cura 179 ferramentas/dia
+  de 14 fontes (Reddit, arXiv, GitHub, newsletters, X.com).
+
+---
+
+## O QUE TALVEZ FALTE — onde quero ajuda (honesto)
+
+- Nenhum cliente externo pagante ainda; maturidade atual = demo e piloto pré-contrato.
+- Lacunas enterprise identificadas:
+  - Gate de PII não está wired no caminho crítico do chatbot WhatsApp (roda em pre-commit,
+    não em runtime de produção).
+  - Zero teste de integração do fluxo completo (só testes unitários por módulo).
+  - Sem SLO/SLA documentado; sem estrutura de suporte.
+  - Isolamento multi-tenant implementado em código (query filter), não em RLS (Postgres
+    Row Level Security) — risco em caso de bug.
+- Pagamento no fluxo WhatsApp (gerar link Mercado Pago, agente validar e liberar acesso
+  após pagamento confirmado) não implementado end-to-end.
+- O diagnóstico como produto nunca foi vendido nem precificado externamente — não sei
+  quanto o mercado paga por "clareza estruturada" sem código entregue.
+- Handoff para execução: sem playbook testado para transferir responsabilidade para
+  time do cliente ou parceiro sem perder qualidade do diagnóstico.
+
+---
+
+## O QUE PEÇO A VOCÊ — tarefa de pesquisa (com pesquisa web atual, jun/2026)
+
+Use busca web real. Cite URL e data de publicação. Se não encontrar dado de 2026,
+informe a data mais recente que encontrou.
+
+**a) Frameworks e métodos do mundo real**
+Busque nos últimos 12 meses em Reddit (r/consulting, r/AI_Agents, r/LocalLLaMA,
+r/MachineLearning, r/Entrepreneur), X.com, arXiv, GitHub e blogs de prática:
+quais são os melhores frameworks, métodos e playbooks para o perfil
+"consultor-diagnosticador de IA que prova com protótipo e faz handoff para execução"?
+Nomes de metodologias, autores, repositórios, threads relevantes.
+
+**b) Comparação com estado da arte**
+Compare meu processo de 5 camadas com o que você encontrar.
+O que estou fazendo certo (não precisa mudar)?
+O que está faltando (lacuna real, não opinião)?
+O que reordenar ou fundir?
+Seja específico — não me dê framework genérico de consultoria.
+
+**c) Ferramentas que preenchem minhas lacunas (jun/2026)**
+Foque apenas nas lacunas que descrevi: pagamento in-WhatsApp, observabilidade de agentes,
+HITL em runtime de produção, eval de agentes, multi-tenant seguro com RLS.
+Para cada ferramenta: nome, link, licença (open-source/comercial), maturidade (produção/beta/alpha),
+por que se encaixa na MINHA individualidade (diagnóstico-primeiro, dado soberano local,
+governança explícita).
+Não me dê dump genérico de "ferramentas de IA 2026" — filtre pelo meu contexto.
+
+**d) Modelos de precificação**
+Como consultor-diagnosticador de IA cobra pelo diagnóstico + protótipo + handoff?
+O que o mercado paga em jun/2026 por "clareza estruturada" sem código entregue?
+Mostre modelos reais (diária, projeto fechado, sucesso, retainer), faixas de valor
+praticadas por perfis similares, e o que sinaliza valor vs comodity nesse serviço.
+Referências: threads de Reddit/X.com, posts de consultores independentes, benchmarks.
+
+**e) Riscos e armadilhas conhecidos**
+Quais são as armadilhas documentadas desse modelo de negócio?
+Priorize: consultor que vira fábrica de código, escopo que vaza do diagnóstico para
+implementação infinita, suporte que devora capacidade, handoff que falha e o cliente
+volta como emergência, precificação que ancora barato demais.
+Fontes reais preferidas (Reddit, LinkedIn, X.com, blogs de prática).
+
+**f) Citações e classificação**
+Para cada sugestão: cite URL + data. Classifique por esforço/impacto
+(quadrante: baixo esforço + alto impacto primeiro).
+Termine com 3 perguntas afiadas para me conhecer melhor antes de aprofundar qualquer ponto.
+
+---
+
+## REGRAS DE INTERAÇÃO
+
+1. Pesquisa web atual (jun/2026) com fonte. Se a fonte for anterior, diga a data.
+2. Não invente ferramentas ou recursos. Se não tiver certeza se algo existe, diga
+   "não encontrei evidência — pode ser conceito ou projeto descontinuado".
+3. Classifique o que é real (link verificável) vs conceito vs phantom.
+4. Respeite minha individualidade: não me transforme em "mais um consultor de IA genérico".
+   Meu diferencial é diagnóstico + prova + governança explícita + dado soberano.
+5. Seja específico e brutalmente honesto. Não bajule.
+6. Se eu tiver feito algo que contradiz boas práticas documentadas, diga diretamente.
+```
diff --git a/docs/drafts/conselho.md b/docs/drafts/conselho.md
new file mode 100644
index 00000000..fc8f3414
--- /dev/null
+++ b/docs/drafts/conselho.md
@@ -0,0 +1,134 @@
+gemini /home/enio/Downloads/Gemini-Pesquisa sobre Consultoria em IA 2026.md
+
+grok: **Pesquisa realizada (foco X.com, repositórios GitHub, ferramentas de devs indie, atualizado até jun/2026).** Verificação de código via GitHub conectado (enioxt/egos) concluída antes de qualquer afirmação sobre pacotes.
+
+### Pacotes reais confirmados em enioxt/egos (packages/)
+- skill-discovery, eval-runner, atrian-observability, knowledge-mcp, guard-brasil (e variantes guard-brasil-mcp / langchain / python), mcp-memory, mcp-governance, mcp-observability, mcp-eval-runner, item-intake, whatsapp-kernel, hermes-schema, agent-runtime, chatbot-core, registry, mcp-skills-registry, core, shared, types, auth, audit, pii-purge, llm-fallback, search-engine, report-standard, curriculum-gate, autores-schema, atomizer, gem-hunter, mcp-bridge, mcp-browser-automation, mcp-ops, mcp-literature, mcp-g-pecas.
+- Diretório central-egos/ existe na raiz (produto oficial: **Central EGOS**).
+- Não encontrei repositório público hermes-egos (commit base 5a186ba). Existe pacote hermes-schema. Referências a multi-agent/Kanban devem partir do fork hermes-egos quando existir; aqui uso apenas o que está no monorepo atual.
+
+### a) Frameworks e métodos (X.com + repositórios + blogs indie, últimos 12 meses)
+Elementos alinhados com “diagnosticar → protótipo mínimo que prova hipótese → handoff” aparecem em posts e projetos de devs/researchers indie e labs:
+
+- **Specific Intelligence** (Applied Compute, out/2025): extrai conhecimento latente da empresa, treina modelos customizados, valida em dias (não meses), entrega agentes in-house com eval no dado real. Fundadores ex-OpenAI (Codex, o1, RL infra). Foco em especialistas por domínio + validação rápida.
+- **AutoScientists** (Ada Fang et al., mai/2026): time descentralizado de agentes que gera hipóteses, desenha experimentos, escreve código, testa, analisa falhas e revisa estratégia com evidência acumulada. Loop fechado de descoberta científica (não lista de tarefas). Funciona em otimização de training, biomédica e fitness de proteínas.
+- Framework de extração de conhecimento especialista (DAIR.AI, jan/2026): request classifier + RAG de exemplos de código/docs + regras procedurais explícitas convertidas em funções Python + princípios de design tácitos em prompts. Combina código + LLM; nenhum sozinho basta.
+- Padrão de Claudio Catalani (jun/2026): backtest audit (bias, regime, custos) → veredito escrito com critérios → transforma intuição em regras testáveis + walk-forward validation.
+- Padrão Grok (jun/2026): ciclo observe → theorize → test → automate com sign-off humano explícito; versiona contexts/playbooks.
+
+Não encontrei playbook completo de 5 camadas idêntico em X/repositórios públicos de devs indie. O mais próximo são os loops de hipótese-experimento-validação com HITL explícito e handoff para execução interna.
+
+### b) Comparação com seu processo de 5 camadas + transversal
+**O que está correto (não mexer):**
+- Camada 0 (conversa-diagnóstico com HITL máximo + go/no-go explícito) + mapa assinado.
+- Camada 1 (diagnóstico estruturado como produto entregável, com hipóteses ranqueadas, cenários A/B reais).
+- Camada 2 (protótipo decisório mínimo que muda a decisão do cliente; critério de aceite claro: “consegue decidir diferente?”). Isso é exatamente o que eval-runner + golden cases + provenance (file:line) já implementam no monorepo.
+- Curva de HITL decrescente nas camadas 1-2 e subindo na validação final.
+- Camada transversal (autoresearch/Hermes curando 179 ferramentas/dia) — alinhado com pacotes registry + mcp-skills-registry + skill-discovery.
+
+**Lacunas reais identificadas (não opinião):**
+- Sem integração runtime de Guard Brasil / PII no caminho crítico do whatsapp-kernel (está em pre-commit; pacotes guard-brasil-mcp e pii-purge existem, mas não wired em produção segundo sua descrição).
+- Zero menção a testes de integração do fluxo completo (só unitários por módulo) — pacotes eval-runner e mcp-eval-runner existem, mas não cobrem E2E multi-tenant.
+- Sem SLO/SLA documentado nem estrutura de suporte (pacotes audit + atrian-observability + mcp-observability existem; podem ser estendidos).
+- Isolamento multi-tenant via query filter no código, não RLS Postgres/Supabase (risco de bug). Artigos de 2025-2026 mostram padrões maduros de RLS com tenant_id + políticas por role/hierarquia.
+- Pagamento end-to-end no fluxo WhatsApp (Mercado Pago webhook + validação + liberação) não implementado (whatsapp-kernel + Evolution API já existem; padrão webhook é padrão indie).
+- Playbook de handoff testado para time do cliente/parceiro (Camada 3-4) — não encontrado em repositórios/X de devs indie com seu perfil (diagnóstico-primeiro + dado soberano + governança explícita).
+- Diagnóstico como produto nunca precificado/vendido externamente.
+
+**Reordenação/fusão sugerida (técnica):**
+- Fundir Camada 2 (protótipo) com parte da Camada 3 (spec executável) quando o protótipo já gera golden cases + critérios de avaliação (eval-runner já faz isso). Entregável vira “protótipo + spec mínima para replicar sem mim”.
+- Camada transversal (autoresearch) deve alimentar skill-discovery + registry em tempo real para não reinventar.
+
+### c) Ferramentas que preenchem lacunas (jun/2026, foco indie/devs)
+Filtrado pelo seu contexto (diagnóstico-primeiro, dado soberano local, governança explícita, Brasil, Central EGOS):
+
+- **Observabilidade de agentes + HITL runtime**: LangSmith (tracing/debug/eval) ou Arize Phoenix (OTEL nativo, auto-heal). Posts de jun/2026 recomendam LangGraph 1.0 + LangSmith/Phoenix para equipes que já colocam agentes em produção (57% relatam gargalo de qualidade/estabilidade). Langfuse também aparece em talks de produção (MNTSQ AI Agent). Seus pacotes atrian-observability + mcp-observability + eval-runner já cobrem parte; integrar com um desses para runtime + HITL (interrupts em LangGraph ou approval steps).
+- **Multi-tenant seguro com RLS**: Padrões Postgres/Supabase RLS (tenant_id em todas tabelas + políticas por role/hierarquia + SET LOCAL app.current_tenant). Artigos de jan/2026 (makerkit) e mai/2025 mostram produção com performance (queries de 3min → 2ms) e testes automatizados. Seu supabase/ + packages/auth + shared permitem implementar sem vendor lock. Risco atual de query filter é real; RLS é DB-enforced.
+- **Pagamento in-WhatsApp (Mercado Pago)**: Padrão webhook Evolution API + Mercado Pago (confirmação → agente valida → libera acesso). Não encontrei ferramenta “pronta” específica para seu fluxo; é integração padrão indie brasileira (já tem whatsapp-kernel + guard-brasil). Implementar em 2-3 dias com teste de integração.
+- **Eval de agentes com provenance**: Seu eval-runner + mcp-eval-runner já classifica CONFIRMADO/INFERIDO/HIPÓTESE/PHANTOM + file:line. Manter e estender com golden cases do protótipo decisório.
+- **HITL explícito em produção**: LangGraph interrupts ou human approval nodes (posts de jun/2026). Combina com seu curriculum-gate + gates HITL existentes.
+
+Não encontrei ferramenta que substitua seu diferencial (diagnóstico + prova mínima + governança .guarani/DNA). Use para preencher buracos de runtime/segurança.
+
+### d) Modelos de precificação (jun/2026, fontes reais)
+- Auditoria/diagnóstico estruturado: $500 (audit + spec) + $3k (fix/GEO) — exemplo de AI engineer indie (mai/2026).
+- Testes de persona/insight rápido: $49–149 por run (indie hacker, mai/2026).
+- Padrão consultor-diagnosticador: diária $150-300/h ou projeto fechado $5-15k para diagnóstico + protótipo mínimo + spec executável. Retainer para ponte/handoff (pouco comum em indie; mais em firms).
+- Sinal de valor vs commodity: cobra por clareza gerada + decisão mudada (seu critério de aceite da Camada 2), não por hora de código. Protótipo que prova = produto precificável separado do diagnóstico.
+- Nenhum benchmark público exato para “clareza estruturada sem código entregue” no Brasil em jun/2026; o mais próximo são os audits de $500+.
+
+### e) Riscos e armadilhas documentados
+- Escopo que vaza do diagnóstico para implementação infinita (clássico em consulting; posts de indie/consultores alertam para boundary explícito: “pagou diagnóstico → fecha aqui”).
+- Consultor vira fábrica de código sem precificar execução (evitar handoff sem playbook testado).
+- Suporte devora capacidade (sem SLO/SLA → burnout).
+- Handoff falha e cliente volta como emergência (sem spec executável + golden cases + eval-runner validado).
+- Precificação ancora barato demais (ex: cobrar só pelo protótipo e perder o diagnóstico como produto).
+
+Fontes: padrões de consulting indie em X/Reddit 2025-2026; seu próprio diagnóstico de lacunas já identifica os principais.
+
+### f) Citações + classificação esforço/impacto (quadrante)
+Prioridade: baixo esforço + alto impacto primeiro.
+
+1. Implementar RLS Postgres/Supabase (artigos 2025-2026) — baixo esforço (você já tem supabase/ + auth), alto impacto (elimina risco multi-tenant).
+2. Wire Guard Brasil / pii-purge no runtime do whatsapp-kernel + webhook Mercado Pago — baixo esforço (pacotes existem), alto impacto (compliance produção).
+3. Integrar LangSmith/Phoenix ou estender atrian-observability + mcp-observability para runtime + HITL — médio esforço, alto impacto (qualidade/estabilidade).
+4. Criar playbook de handoff (Camada 3-4) com golden cases do eval-runner — médio esforço, alto impacto (evita suporte infinito).
+5. Precificar diagnóstico + protótipo decisório separadamente ($500-5k faixa inicial) — baixo esforço, alto impacto (valida modelo de negócio).
+6. Estender skill-discovery + registry com output do autoresearch/Hermes — baixo esforço (pacotes existem), impacto médio-alto.
+
+**3 perguntas afiadas para aprofundar:**
+1. Qual o tamanho médio do time do cliente/parceiro que recebe o handoff (Camada 3-4) — 3-5 devs ou 10+ com PM/arquiteto?
+2. O diagnóstico como produto separado já foi testado em piloto pago (mesmo que pequeno) ou só em internos?
+3. Qual o SLO mínimo aceitável para o whatsapp-kernel em produção hoje (ex: 99.5% uptime, latência P95 < X s) — ou ainda não definido?
+
+Resposta curta, técnica, sem hype. Próximo passo: escolha 1-2 itens do quadrante e peço spec técnica ou código de integração.
+
+chatgpt: /home/enio/Downloads/ChatGPT-Pesquisa e Governança IA.md
+
+perplexity: /home/enio/Downloads/Pesquisa sobre o processo arquiteto-diagnosticador de IA com protótipo decisório e handoff.md , Já rodei a pesquisa completa em cima do seu meta‑prompt e estruturei tudo em um relatório em Markdown, no estilo “paper de método” que você descreveu. [rosenverse.rosenfeldmedia](https://rosenverse.rosenfeldmedia.com/videos/the-handoff-is-dead-design-led-engineering-with-ai-agents)
+
+O relatório cobre, em blocos separados:
+
+- **a) Frameworks e métodos reais**: 4–5 frameworks bem próximos do seu (AI First Hub 4Ds, WEDGE 5‑Phase, Revue‑ai Consulting Intelligence, Deloitte “From AI pilots to production”), com links, autores e como cada um trata discovery, diagnóstico, protótipo/piloto e handoff. [deloitte](https://www.deloitte.com/nl/en/services/consulting/services/from-AI-pilots-to-production.html)
+- **b) Comparação 1:1 com o seu processo em 5 camadas**: tabela mapeando cada camada sua para essas metodologias, o que está muito certo (diagnóstico pago, protótipo decisório, spec executável) e onde o “estado da arte enterprise” te cobra mais (observabilidade contínua, HITL operacionalizado, SLO/SLA, RLS). [logz](https://logz.io/blog/top-llm-observability-tools/)
+- **c) Ferramentas para as lacunas específicas**:  
+  - Pagamento in‑WhatsApp: Meta Payments API (Brasil) + PSP (OpenPix ou Mercado Pago) com fluxo `order_details` + webhook. [reddit](https://www.reddit.com/r/consulting/comments/1rdkpfm/ai_tools_usage/)
+  - Observabilidade: Langfuse (self‑host), Arize Phoenix/AX, LangSmith, com foco em um caminho bem alinhado ao seu stack TS/Bun e dado soberano. [rb-sns](https://rb-sns.com)
+  - HITL em runtime: Orkes Conductor (Human Task) e n8n com “human‑in‑the‑loop for AI tool calls”, além de um serviço de aprovação estilo webhook mostrado em r/LangChain. [x](https://x.com/edkrystosik)
+  - Eval de agentes: Ragas/RAGAs plugado em cima do seu eval‑runner para dar métricas “oficiais” (faithfulness, relevância etc.). [reddit](https://www.reddit.com/r/LangChain/comments/1bv2hcf/a_human_approval_tool_for_your_agent_workflows/)
+  - Multi‑tenant seguro: RLS em Postgres com `current_setting('app.current_tenant')`, baseado em AWS SaaS Factory, Crunchy Data, Debugg e outros. [domo](https://www.domo.com/learn/article/ai-workflow-platforms)
+- **d) Modelos de precificação**: como pares seus estão cobrando discovery fixo + build fee + retainer; ranges de valor real reportados (diagnósticos de alguns milhares de euros, AI readiness em 10–25k para mid/enterprise) e efeitos de ancorar preço baixo demais. [langchain](https://www.langchain.com/articles/llm-observability-tools)
+- **e) Riscos/armadilhas**: virar fábrica de código, escopo vazando do diagnóstico, suporte infinito, handoff frágil, e como frameworks como WEDGE e Deloitte estruturam para evitar isso. [support2.chatarchitect](https://support2.chatarchitect.com/books/meta-whatsapp/page/payments-api-brazil-developer-documentation)
+- **f) Priorização (esforço x impacto) + 3 perguntas pra próxima rodada**: lista objetiva do que fazer primeiro (Pacote Diagnóstico, RLS, Langfuse, pagamento in‑WhatsApp, gates HITL, Ragas) e três perguntas sobre alvo de cliente, produto vs serviço e limite de suporte.
+
+Você consegue abrir o relatório agora na interface (ele já está anexado como artefato Markdown); se quiser, no próximo passo posso:
+
+- descer para o nível de **roadmap técnico** (por exemplo: esquema RLS concreto + pontos de hook no EGOS/Hermes e fluxo do pagamento WhatsApp), ou  
+- focar na **oferta comercial** (nome do pacote de diagnóstico, faixas de preço iniciais, exemplos de proposta e cláusulas para segurar escopo).
+
+---
+
+### guarani: **Perspectiva do Runtime (Auditoria de Código e Comportamento)**
+
+Como a instância interna do EGOS que executa e valida o monorepo, trago o diagnóstico de engenharia e os desvios de processo que o código e a máquina revelam (evidência > intenção).
+
+#### 1. O "Cinto de Utilidades do Batman" (O MCP Diagnosticador)
+Nossos ativos de diagnóstico estão espalhados como scripts soltos no diretório [scripts/](file:///home/enio/egos/scripts/) (ex: [readiness.ts](file:///home/enio/egos/scripts/activation-check.ts), [recon.ts](file:///home/enio/egos/scripts/recon.ts), [doctor.ts](file:///home/enio/egos/scripts/doctor.ts)). Eles são extremamente poderosos, mas estão *desconectados do fluxo de entrega pública*.
+*   **O Gap:** O cliente ou parceiro não consegue consumir isso como um serviço integrado. São ferramentas locais em CLI que exigem terminal.
+*   **A Solução:** Empacotar esses scripts em um MCP Server unificado de diagnóstico (`packages/mcp-egos-diagnostic`). Quando o cliente vier com um problema, a IA que o atende chama nossa ferramenta de `/recon` ou `/readiness` via API. O método vira serviço em tempo real.
+
+#### 2. Armadilha do Over-building (Camada 2 vs. Dev-Obsession)
+A análise de 14 sistemas inativos na máquina mostra que o Enio constrói código complexo antes da conversa humana fechar o escopo (ex: `gem-hunter`, `eagle-eye`).
+*   **O Gap:** Risco do protótipo decisório (Camada 2) virar desenvolvimento completo e infinito, ancorando o preço baixo e gerando burnout.
+*   **A Solução (Regra Dura):** O protótipo decisório deve ser estritamente sandbox. Se a construção do código de validação de hipótese tomar mais de 5 dias úteis, o escopo do protótipo está incorreto. Todo protótipo decisório deve nascer obrigatoriamente acompanhado de um arquivo de testes de comportamento no `eval-runner` (TDD-first). Se não conseguimos definir o critério de aceitação antes de codificar, não codificamos.
+
+#### 3. Vulnerabilidade de Isolamento Multi-Tenant (Segurança do Banco de Dados)
+Hoje, a separação de dados dos clientes (tenants) é feita via filtros lógicos na camada da aplicação (código de consulta).
+*   **O Gap:** Um simples esquecimento de `.eq('tenant_id', X)` em uma nova rota vaza dados confidenciais de outros clientes. Isso destrói nossa promessa de "governança e segurança".
+*   **A Solução:** Implementar RLS (Row-Level Security) no Supabase/Postgres imediatamente. A autenticação do gateway passa a setar `app.current_tenant` no escopo da transação, e o banco barra qualquer SELECT que não seja do tenant associado, independente de bugs na camada do código.
+
+#### 4. O Nó de Fechamento do Loop (Receber e Concluir)
+Historicamente, o Enio inicia as conversas (escuta inicial), constrói protótipos brilhantes, mas falha na "porta de saída": pedir o feedback definitivo ("funcionou?") e cobrar pelo valor gerado.
+*   **A Solução:** Monitorar ativamente o andamento dos trabalhos no próprio monorepo. Criar arquivos estruturados `docs/jobs/<cliente>-engagement.md` onde o status [EM_CONVERSA | ENTREGUE_AGUARDA_CONFIRMACAO | COBRADO | FINALIZADO] é auditado por nós (agentes), forçando o encerramento completo do ciclo de entrega.
+
+---
\ No newline at end of file
diff --git a/docs/governance/HITL_CURVE_PRINCIPLE.md b/docs/governance/HITL_CURVE_PRINCIPLE.md
new file mode 100644
index 00000000..a31fc9cb
--- /dev/null
+++ b/docs/governance/HITL_CURVE_PRINCIPLE.md
@@ -0,0 +1,227 @@
+---
+title: Princípio EGOS — Curva de HITL
+version: 1.0.0
+date: 2026-06-09
+status: active
+tier: T1
+owner: enio
+ssot: docs/governance/HITL_CURVE_PRINCIPLE.md
+relates_to:
+  - docs/governance/HITL_CATALOG.md       # gates implementados
+  - docs/governance/human-in-the-loop.md  # protocolo técnico Telegram
+  - .guarani/AUTONOMY_POLICY.md            # policy de autonomia
+---
+
+# Princípio EGOS — Curva de HITL [T1 — 2026-06-09]
+
+## Princípio
+
+Todo sistema de IA do EGOS começa com HITL máximo (humano aprova cada ação)
+e reduz supervisão de forma GRADUAL, POR CLASSE DE AÇÃO, e BASEADA EM EVIDÊNCIA
+MEDIDA — nunca por tempo decorrido ou "sensação de confiança".
+
+Validado por dados de produção (Anthropic, OpenAI jun/2026) com 3 correções
+críticas ao modelo simplista de "começa manual, vira automático":
+
+1. **A curva é POR OPERAÇÃO, não global.** O mesmo sistema pode estar maduro
+   (baixo HITL) para resumos e iniciante (HITL total) para pagamentos,
+   simultaneamente. Misturar classes dilui a proteção onde mais importa.
+
+2. **O que cai é a aprovação granular ação-a-ação; o monitoramento de sessão e
+   o botão de parada permanecem PARA SEMPRE.** Dado Anthropic (measuring-agent-
+   autonomy, mai/2026): usuários experientes auto-aprovam mais (20%→40%) E
+   interrompem mais (5%→9%) — a transição não é abandono, é troca de
+   "aprovar tudo" por "vigiar e intervir onde importa".
+
+3. **Classes de alto risco têm PISO ABSOLUTO permanente** (pagamento, PII,
+   decisão jurídica/médica, certificação) — nunca saem do loop, por regulação
+   (EU AI Act Art.14, LGPD Art.20, GDPR Art.22) e por engenharia (irreversível
+   por definição).
+
+**Inimigo-chave:** automation bias — reduzir HITL sem medir taxa de override
+transforma o humano em carimbo e destrói a defesa regulatória. A curva desce
+com PROVA, não com pressa.
+
+---
+
+## A Curva — 3 Fases
+
+### Fase 1 — HITL Máximo (L1: IA Sugere)
+
+| Dimensão      | Valor                                          |
+|---------------|------------------------------------------------|
+| Modo          | Human-in-the-Loop estrito                      |
+| Fluxo         | IA gera → humano revisa 100% → humano executa |
+| Configuração  | Sem auto-aprovação, sem batching               |
+| Duração       | Indefinida — sai por evidência, não por tempo  |
+
+**Métricas para avançar para Fase 2 (por classe de operação):**
+- Agreement rate ≥ 90% em janela de 30d (humano concordou sem editar)
+- Zero reversões (nenhuma ação aprovada que teve de ser desfeita)
+- Zero incidentes ligados a essa classe
+
+**Gatilho de regressão → permanece em Fase 1:**
+- Agreement rate < 80% em qualquer janela de 7d
+- Qualquer reversão de ação aprovada
+
+---
+
+### Fase 2 — Calibração (L2: Human-on-the-Loop)
+
+| Dimensão      | Valor                                                       |
+|---------------|-------------------------------------------------------------|
+| Modo          | Human-on-the-Loop (supervisão de sessão, não por ação)      |
+| Fluxo         | IA age com confidence ≥ 0.85 → notifica → humano intervém   |
+|               | se necessário; confidence < 0.85 → continua solicitando aprovação |
+| Configuração  | Confidence routing ativo; alertas de anomalia configurados  |
+
+**Métricas para avançar para Fase 3:**
+- Passthrough rate (ações sem intervenção humana) ≥ 95% em janela de ~60d
+- Intervention rate (humano interrompeu/corrigiu) < 1%
+- Revert rate < 0.2%
+- Nenhuma aprovação a zero thinking (ver alerta abaixo)
+
+**Alerta inverso — sinal de rubber-stamp:**
+Aprovação consistente em < 5s = humano não está revisando de fato. Indicador
+de automation bias (CrewAI missing-layer, jan/2026). Ação: aumentar fricção
+intencional (resumo forçado antes de confirmar) ou regredir para Fase 1.
+
+**Gatilho de regressão → volta para Fase 2:**
+- Passthrough rate cai abaixo de 90% em janela de 7d
+- Qualquer incidente ligado a ação auto-aprovada
+
+---
+
+### Fase 3 — Maduro (L3: HITL Seletivo)
+
+| Dimensão      | Valor                                                          |
+|---------------|----------------------------------------------------------------|
+| Modo          | HITL restrito a alto risco + monitoramento contínuo de sessão  |
+| Fluxo         | IA age autonomamente no volume; HITL para pisos absolutos       |
+|               | e anomalias detectadas; auto-review de IA cobre volume          |
+| Configuração  | Monitoramento de sessão ativo; botão de parada sempre exposto   |
+
+**Rollback obrigatório — reset para Fase anterior se:**
+- Error rate > 5% em qualquer janela de 1h
+- Override rate dobra em qualquer janela de 4h
+- QUALQUER troca de modelo (LLM diferente = comportamento não calibrado)
+- Novo tipo de ação aparece na classe (escopo expandiu → Fase 1 para esse subtipo)
+- Incidente de qualquer severidade ligado a ação autônoma
+
+**O que NUNCA é autônomo em Fase 3:** ver Pisos Absolutos abaixo.
+
+---
+
+## Onde o Humano Nunca Sai — Pisos Absolutos
+
+Independente de fase, confidence, histórico ou pressão de tempo.
+
+| Ação                                       | Nível mínimo                | Base regulatória / técnica                        |
+|--------------------------------------------|-----------------------------|---------------------------------------------------|
+| Pagamento / transação financeira irreversível acima de threshold | Gate humano obrigatório | PSRs 2017 Art.64; IMF 2026/004 §3.2; Anthropic measuring-agent-autonomy |
+| PII com efeito jurídico (decisão sobre pessoa) | Gate humano obrigatório | LGPD Art.20; GDPR Art.22; EU AI Act Art.14        |
+| Hard delete / export em massa / deploy prod | Gate humano obrigatório     | Regra dos 3 testes (ver abaixo); PRODUCTION_DEPLOY_RULES.md |
+| Decisão jurídica sobre pessoa física/jurídica | Gate humano obrigatório   | EU AI Act Annex III; LGPD Art.20                  |
+| Biometria em enforcement                   | HITL-duplo obrigatório      | EU AI Act Art.14(5)                               |
+| Diagnóstico / prescrição em saúde          | Gate humano obrigatório     | EU AI Act Annex III High-Risk §5; CFM res. 2.314/2022 |
+| Filing regulatório / certificação / SAR    | Gate humano obrigatório     | ANPD NT 12/2025; COAF RN 36/2021                  |
+| Decisão de emprego / acesso ampliado       | Gate humano obrigatório     | EU AI Act Annex III; LGPD Art.7                   |
+| Ação catastrófica (qualquer ação que não desfaz sem danos) | Gate humano obrigatório | arXiv 2502.02649; Omnithium severidade×reversibilidade |
+
+**Regra-mãe EGOS:** qualquer ação que (1) mova dinheiro, (2) amplie acesso, ou
+(3) não desfaça com 1 clique → gate humano obrigatório, independente de
+confidence. Liga ao Red Zone constitucional (`CLAUDE.md §0.5`).
+
+**Regra dos 3 testes (Dock dangerous-ops-contract, 2026):**
+Se a resposta for SIM a qualquer um dos 3 → piso absoluto:
+1. Move dinheiro ou cria obrigação financeira?
+2. Amplia acesso a dado sensível ou infraestrutura?
+3. Não desfaz com 1 clique sem consequência?
+
+---
+
+## Como Mostrar ao Cliente (Material / Diagnóstico)
+
+Frase honesta e calibrada para diagnóstico (liga `R-DIAG-001`):
+
+> "No começo a gente coloca mais gente no loop — o humano revisa cada saída
+> da IA antes de qualquer coisa acontecer. Conforme os processos amadurecem
+> e acumulamos evidência de que o sistema acerta (não é confiança no escuro,
+> é medida: taxa de acerto, taxa de correção), a supervisão diminui e fica
+> mais inteligente: o humano para de aprovar tudo e passa a vigiar e
+> intervir só onde importa. Isso é normal e é assim que se faz com
+> segurança — é o padrão que Anthropic, OpenAI e a regulação europeia
+> descrevem em 2026. E tem coisa que nunca sai da mão do humano: pagamento,
+> dado pessoal sensível, decisão irreversível e certificação sempre passam
+> por aprovação — por engenharia e por lei. Reduzir o humano cedo demais
+> não é eficiência, é risco; a curva desce com prova, não com pressa."
+
+**Apresentar dois cenários quando relevante** (ex: dado pessoal / CPF):
+- Cenário proteção máxima: custo, overhead, o que cobre
+- Cenário dados reais com HITL calibrado: realidade do mercado BR (LGPD pouco
+  enforçado jun/2026; grandes empresas e governos passam dados reais a LLMs),
+  sinergia de dados, funcionalidade plena com gate humano no ponto crítico
+- Nunca escolher pelo cliente — apresentar trade-offs reais, cliente decide
+
+---
+
+## Métricas de Operação
+
+| Métrica                 | Definição                                              | Ferramenta de medição           |
+|-------------------------|--------------------------------------------------------|---------------------------------|
+| agreement_rate          | % ações aprovadas sem edição humana                    | HITL log (`~/.egos/hitl-log.jsonl`) |
+| intervention_rate       | % ações onde humano interrompeu ou corrigiu            | idem                            |
+| revert_rate             | % ações aprovadas que tiveram de ser desfeitas         | idem + git log                  |
+| passthrough_rate        | % ações em Fase 2 sem pedido de aprovação              | idem                            |
+| rubber_stamp_signal     | % aprovações em < 5s                                   | idem (timestamp delta)          |
+| confidence_p50_p95      | Distribuição de confidence do modelo por classe        | telemetria do agente            |
+| phase_per_class         | Fase atual por classe de operação                      | `~/.egos/hitl-phase-map.json`   |
+
+Frequência de revisão: a cada 30d por classe ativa, ou imediatamente após
+qualquer incidente.
+
+---
+
+## Wiring no EGOS
+
+Gates implementados hoje: ver `docs/governance/HITL_CATALOG.md` (5 gates).
+Protocolo técnico (Telegram callbacks): `docs/governance/human-in-the-loop.md`.
+Policy de autonomia por agent: `.guarani/AUTONOMY_POLICY.md`.
+
+Fase atual por domínio (INFERIDO — atualizar com evidência medida):
+
+| Domínio / classe de ação              | Fase atual | Evidência de medição | Próxima revisão |
+|---------------------------------------|------------|----------------------|-----------------|
+| Resumos / geração de texto interno    | 2          | uso diário ativo     | 2026-07-09      |
+| Commits em branch dev                 | 2          | Gate 4 ativo         | 2026-07-09      |
+| Commits em frozen zones / governance  | 1          | Gate 4 fail-closed   | permanente      |
+| Publicação de conteúdo externo        | 1          | Gate 2 + HITL-003 gap| permanente      |
+| Deploy produção VPS                   | 1          | HITL-002 gap aberto  | após HITL-002   |
+| Pagamento / transação financeira      | Piso absoluto | —                 | nunca            |
+| PII com efeito jurídico               | Piso absoluto | —                 | nunca            |
+
+---
+
+## Fontes
+
+| Fonte | Data | URL / referência |
+|-------|------|------------------|
+| Anthropic — Measuring Agent Autonomy | mai/2026 | https://www.anthropic.com/research/measuring-agent-autonomy |
+| OpenAI — Alignment auto-review & oversight | abr/2026 | https://openai.com/research/practices-for-governing-agentic-ai-systems |
+| Autonomy Dial (tianpan.co) | abr/2026 | https://tianpan.co/notes/autonomy-dial |
+| Facio — 4-tier human oversight model | mai/2026 | https://facio.ai/blog/human-oversight-agentic-ai |
+| Omnithium — severity × reversibility framework | mai/2026 | https://omnithium.com/blog/hitl-severity-reversibility |
+| CrewAI — The missing human oversight layer | jan/2026 | https://crewai.com/blog/the-missing-human-oversight-layer |
+| EU AI Act Art.14 — Human oversight | ago/2024 | https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689 |
+| LGPD Art.20 — Decisões automatizadas | ago/2018 | https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm |
+| ANPD NT 12/2025 — IA e proteção de dados | 2025 | https://www.gov.br/anpd/ |
+| arXiv 2502.02649 — Fully autonomous agents should not | fev/2026 | https://arxiv.org/abs/2502.02649 |
+| IMF WP/2026/004 — AI payments risk | jan/2026 | https://www.imf.org/en/Publications/WP/Issues/2026/01/04 |
+| Dock — Dangerous operations contract | 2026 | https://dock.io/blog/dangerous-operations-contract |
+| PSRs 2017 Art.64 — Payment approval | 2017 | https://www.legislation.gov.uk/uksi/2017/752/article/64 |
+
+---
+
+*SSOT: este arquivo. Complementos: `HITL_CATALOG.md` (implementação dos gates)
++ `human-in-the-loop.md` (protocolo Telegram). Atualizar quando nova classe
+de operação atingir critério de fase ou após incidente. T1 — evidência-first.*
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
new file mode 100644
index 00000000..1486fa51
--- /dev/null
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -0,0 +1,244 @@
+{
+  "manifest": "/home/enio/egos/.egos-manifest.yaml",
+  "repo": "egos",
+  "verified_at": "2026-06-09T14:17:54.238Z",
+  "summary": {
+    "total_claims": 17,
+    "passed": 17,
+    "warned": 0,
+    "drifted": 0,
+    "errors": 0,
+    "total_domains": 8,
+    "domains_ok": 8,
+    "domains_drifted": 0
+  },
+  "results": [
+    {
+      "id": "total_agents",
+      "description": "Agents registered in agents.json",
+      "status": "ok",
+      "last_value": "27",
+      "current_value": "27",
+      "tolerance": "min:18",
+      "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
+      "severity": "ok"
+    },
+    {
+      "id": "total_capabilities",
+      "description": "Capabilities declared in CAPABILITY_REGISTRY.md",
+      "status": "ok",
+      "last_value": "168",
+      "current_value": "168",
+      "tolerance": "±10",
+      "drift_abs": 0,
+      "command": "grep -c '^### ' docs/CAPABILITY_REGISTRY.md",
+      "severity": "ok"
+    },
+    {
+      "id": "guarani_governance_files",
+      "description": "Governance rule files in .guarani/",
+      "status": "ok",
+      "last_value": "97",
+      "current_value": "97",
+      "tolerance": "±5",
+      "drift_abs": 0,
+      "command": "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "slash_commands",
+      "description": "User-invocable slash commands in .claude/commands/",
+      "status": "ok",
+      "last_value": "61",
+      "current_value": "63",
+      "tolerance": "±5",
+      "drift_abs": 2,
+      "command": "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "operating_surface_entries",
+      "description": "Entradas no mapa machine-wide da superfície de operação (EGOS_OPERATING_SURFACE.yaml)",
+      "status": "ok",
+      "last_value": "35",
+      "current_value": "35",
+      "tolerance": "±4",
+      "drift_abs": 0,
+      "command": "grep -cE '^  - id:' docs/governance/EGOS_OPERATING_SURFACE.yaml 2>/dev/null | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "kernel_packages",
+      "description": "Packages in packages/ directory",
+      "status": "ok",
+      "last_value": "36",
+      "current_value": "38",
+      "tolerance": "±2",
+      "drift_abs": 2,
+      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
+      "severity": "ok"
+    },
+    {
+      "id": "commits_30d_all_repos",
+      "description": "Total commits across all active EGOS repos in last 30 days",
+      "status": "ok",
+      "last_value": "1466",
+      "current_value": "1286",
+      "tolerance": "min:50",
+      "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
+      "severity": "ok"
+    },
+    {
+      "id": "unique_differentials",
+      "description": "Unique technical differentials documented in EGOS_STATE",
+      "status": "ok",
+      "last_value": "22",
+      "current_value": "22",
+      "tolerance": "min:6",
+      "command": "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
+      "severity": "ok"
+    },
+    {
+      "id": "completed_tasks_total",
+      "description": "Total completed tasks in TASKS.md",
+      "status": "ok",
+      "last_value": "0",
+      "current_value": "0\n0",
+      "tolerance": "min:0",
+      "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
+      "severity": "ok"
+    },
+    {
+      "id": "active_products",
+      "description": "Live products with public URLs in EGOS ecosystem",
+      "status": "ok",
+      "last_value": "7",
+      "current_value": "7",
+      "tolerance": "min:5",
+      "command": "grep -c '\\*\\*URL:\\*\\*' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
+      "severity": "ok"
+    },
+    {
+      "id": "capability_registry_sections",
+      "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
+      "status": "ok",
+      "last_value": "19",
+      "current_value": "100",
+      "tolerance": "min:10",
+      "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
+      "severity": "ok"
+    },
+    {
+      "id": "evg008_simplicity_check_function",
+      "description": "EVG-008: detectSimplicityViolations function present in evidence-gate.ts (§K.2 enforcement)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "min:2",
+      "command": "grep -c 'detectSimplicityViolations' scripts/evidence-gate.ts",
+      "severity": "ok"
+    },
+    {
+      "id": "karpathy_principles_in_global_claude",
+      "description": "§K Karpathy Principles in egos-rules lazy-load (moved from CLAUDE.md core in GOV-W2-009)",
+      "status": "ok",
+      "last_value": "1",
+      "current_value": "1",
+      "tolerance": "min:1",
+      "command": "grep -c 'Simplicity First' ~/.claude/egos-rules/karpathy-principles.md",
+      "severity": "ok"
+    },
+    {
+      "id": "disseminate_pipeline_scripts",
+      "description": "Auto-disseminate pipeline scripts present (propagator + scanner)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "eq:2",
+      "command": "test -f scripts/disseminate-propagator.ts && test -f scripts/disseminate-scanner.ts && echo 2 || echo 0",
+      "severity": "ok"
+    },
+    {
+      "id": "evidence_gate_blocking_schedule",
+      "description": "Evidence gate blocking activation date configured (WEEK2_START = 2026-04-16)",
+      "status": "ok",
+      "last_value": "2",
+      "current_value": "2",
+      "tolerance": "min:2",
+      "command": "grep -c 'WEEK2_START' scripts/evidence-gate.ts",
+      "severity": "ok"
+    },
+    {
+      "id": "pre_commit_hook_chain_stages",
+      "description": "Pre-commit hook chain has minimum required governance stages",
+      "status": "ok",
+      "last_value": "70",
+      "current_value": "176",
+      "tolerance": "min:15",
+      "command": "grep -c '\\[' .husky/pre-commit",
+      "severity": "ok"
+    },
+    {
+      "id": "cross_repo_capabilities",
+      "description": "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)",
+      "status": "ok",
+      "last_value": "28",
+      "current_value": "23",
+      "tolerance": "min:10",
+      "command": "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0",
+      "severity": "ok"
+    }
+  ],
+  "domains": [
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://hq.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "301",
+      "actual_status": "301"
+    },
+    {
+      "url": "https://eagleeye.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://852.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://inteligencia.egos.ia.br/",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200"
+    },
+    {
+      "url": "https://guard.egos.ia.br/health",
+      "status": "ok",
+      "expected_status": "200",
+      "actual_status": "200",
+      "contains_check": true
+    },
+    {
+      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
+      "status": "ok",
+      "expected_status": "301",
+      "actual_status": "301"
+    }
+  ],
+  "exit_code": 0
+}
\ No newline at end of file
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
new file mode 100644
index 00000000..befedf8b
--- /dev/null
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -0,0 +1,122 @@
+[
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T11:00:16.904Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=d0f3fa75",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T11:02:58.980Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=4529821b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T12:34:38.629Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=8c2dbb5e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T12:47:59.583Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=0dbcd0c0",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T12:55:50.254Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=547d31a5",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T12:56:45.393Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=251ece05",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T13:02:32.504Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=dee4da45",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T13:12:46.180Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=84130718",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T13:33:25.647Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=21200b24",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T13:40:13.854Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=10 sha=1a2b9415",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T14:17:54.823Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=3 sha=b9f7c8e4",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T14:22:53.420Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=3d0f899f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T14:36:02.832Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=a6bb400c",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T14:39:37.167Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=e295e6eb",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T14:45:55.903Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=ee38e623",
+    "repo": "/home/enio/egos"
+  }
+]
diff --git a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
index 87f0a4d4..f4fcc572 100644
--- a/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
+++ b/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
@@ -5,7 +5,7 @@ type: governance
 version: 1.1
 status: active
 created: 2026-05-08
-last_update: 2026-06-08 (EPOS B2-Q1/Q2 retomada — flow zones + mecanismo produção∞/captura-adiada)
+last_update: 2026-06-09 (EPOS B2-Q3 adicionado — padrão guia-de-ferramentas + RED ZONE protegida)
 ---
 
 # Enio Understanding Map
@@ -39,6 +39,7 @@ Agente pode usar linguagem técnica densa, pular explicações básicas, ir dire
 **Validado pela retomada EPOS B2 (2026-06-08):**
 - **Flow zones (B2-Q1):** flui em (1) CONVERSAR (assunto interessante → horas) e (2) RESOLVER/CONSTRUIR/PESQUISAR — próprios e dos outros. Auto-rótulo "resolvedor de problemas, mesmo que tenha que criar/amplificar eles" (Jordan). → agente pode usar isso como combustível, mas vigiar o lado dispersor (criar problema pra ter o que resolver).
 - **Mecanismo produção∞/captura-adiada (B2-Q1+Q2):** o que ADIA é RECEBER/capturar valor (dinheiro fora da polícia). Explica 460 commits/R$0 + dispersão 🔴. Quando ele hesitar em cobrar/fechar → é o nó de receber (🔴 abaixo), não falta de valor. Está em movimento (Miguel/GOW/Hotmart = rampa). 🔒 protegido. Ver `memory/user_enio_flow_zones_capture_block_2026-06-08.md`.
+- **Padrão guia-de-ferramentas (B2-Q3):** o pedido mais significativo que Enio recebe = alguém que ficou travado numa ferramenta que ele pesquisou/testou. Ele é o intermediário que faz a "tradução técnica→leigo" em ferramentas. Padrão: researcher→experimenter→guia. 🔴 RED ZONE: o caso concreto citado (colega policial + alcoolismo + psilocibina) é PROTEGIDO — bem-estar real + contexto policial. NUNCA público, NUNCA "provado em código" como serviço. Ver `memory/user_enio_tool_guide_pattern_2026-06-08.md`.
 
 **Validado pela clarificação 2026-05-20 (atom A78 — ver IDENTITY_AND_METHOD.md):**
 - **Habilidade central canonical:** transformar caos informacional em clareza estratégica aplicável (não é pivot — é nome para o padrão que sempre existiu)

exec
/bin/bash -lc "git diff 3d0f899f36ac9fc07105eaaa7dfc551838361c97 -- docs/drafts/conselho.md docs/governance/HITL_CURVE_PRINCIPLE.md | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/docs/drafts/conselho.md b/docs/drafts/conselho.md
new file mode 100644
index 00000000..fc8f3414
--- /dev/null
+++ b/docs/drafts/conselho.md
@@ -0,0 +1,134 @@
+gemini /home/enio/Downloads/Gemini-Pesquisa sobre Consultoria em IA 2026.md
+
+grok: **Pesquisa realizada (foco X.com, repositórios GitHub, ferramentas de devs indie, atualizado até jun/2026).** Verificação de código via GitHub conectado (enioxt/egos) concluída antes de qualquer afirmação sobre pacotes.
+
+### Pacotes reais confirmados em enioxt/egos (packages/)
+- skill-discovery, eval-runner, atrian-observability, knowledge-mcp, guard-brasil (e variantes guard-brasil-mcp / langchain / python), mcp-memory, mcp-governance, mcp-observability, mcp-eval-runner, item-intake, whatsapp-kernel, hermes-schema, agent-runtime, chatbot-core, registry, mcp-skills-registry, core, shared, types, auth, audit, pii-purge, llm-fallback, search-engine, report-standard, curriculum-gate, autores-schema, atomizer, gem-hunter, mcp-bridge, mcp-browser-automation, mcp-ops, mcp-literature, mcp-g-pecas.
+- Diretório central-egos/ existe na raiz (produto oficial: **Central EGOS**).
+- Não encontrei repositório público hermes-egos (commit base 5a186ba). Existe pacote hermes-schema. Referências a multi-agent/Kanban devem partir do fork hermes-egos quando existir; aqui uso apenas o que está no monorepo atual.
+
+### a) Frameworks e métodos (X.com + repositórios + blogs indie, últimos 12 meses)
+Elementos alinhados com “diagnosticar → protótipo mínimo que prova hipótese → handoff” aparecem em posts e projetos de devs/researchers indie e labs:
+
+- **Specific Intelligence** (Applied Compute, out/2025): extrai conhecimento latente da empresa, treina modelos customizados, valida em dias (não meses), entrega agentes in-house com eval no dado real. Fundadores ex-OpenAI (Codex, o1, RL infra). Foco em especialistas por domínio + validação rápida.
+- **AutoScientists** (Ada Fang et al., mai/2026): time descentralizado de agentes que gera hipóteses, desenha experimentos, escreve código, testa, analisa falhas e revisa estratégia com evidência acumulada. Loop fechado de descoberta científica (não lista de tarefas). Funciona em otimização de training, biomédica e fitness de proteínas.
+- Framework de extração de conhecimento especialista (DAIR.AI, jan/2026): request classifier + RAG de exemplos de código/docs + regras procedurais explícitas convertidas em funções Python + princípios de design tácitos em prompts. Combina código + LLM; nenhum sozinho basta.
+- Padrão de Claudio Catalani (jun/2026): backtest audit (bias, regime, custos) → veredito escrito com critérios → transforma intuição em regras testáveis + walk-forward validation.
+- Padrão Grok (jun/2026): ciclo observe → theorize → test → automate com sign-off humano explícito; versiona contexts/playbooks.
+
+Não encontrei playbook completo de 5 camadas idêntico em X/repositórios públicos de devs indie. O mais próximo são os loops de hipótese-experimento-validação com HITL explícito e handoff para execução interna.
+
+### b) Comparação com seu processo de 5 camadas + transversal
+**O que está correto (não mexer):**
+- Camada 0 (conversa-diagnóstico com HITL máximo + go/no-go explícito) + mapa assinado.
+- Camada 1 (diagnóstico estruturado como produto entregável, com hipóteses ranqueadas, cenários A/B reais).
+- Camada 2 (protótipo decisório mínimo que muda a decisão do cliente; critério de aceite claro: “consegue decidir diferente?”). Isso é exatamente o que eval-runner + golden cases + provenance (file:line) já implementam no monorepo.
+- Curva de HITL decrescente nas camadas 1-2 e subindo na validação final.
+- Camada transversal (autoresearch/Hermes curando 179 ferramentas/dia) — alinhado com pacotes registry + mcp-skills-registry + skill-discovery.
+
+**Lacunas reais identificadas (não opinião):**
+- Sem integração runtime de Guard Brasil / PII no caminho crítico do whatsapp-kernel (está em pre-commit; pacotes guard-brasil-mcp e pii-purge existem, mas não wired em produção segundo sua descrição).
+- Zero menção a testes de integração do fluxo completo (só unitários por módulo) — pacotes eval-runner e mcp-eval-runner existem, mas não cobrem E2E multi-tenant.
+- Sem SLO/SLA documentado nem estrutura de suporte (pacotes audit + atrian-observability + mcp-observability existem; podem ser estendidos).
+- Isolamento multi-tenant via query filter no código, não RLS Postgres/Supabase (risco de bug). Artigos de 2025-2026 mostram padrões maduros de RLS com tenant_id + políticas por role/hierarquia.
+- Pagamento end-to-end no fluxo WhatsApp (Mercado Pago webhook + validação + liberação) não implementado (whatsapp-kernel + Evolution API já existem; padrão webhook é padrão indie).
+- Playbook de handoff testado para time do cliente/parceiro (Camada 3-4) — não encontrado em repositórios/X de devs indie com seu perfil (diagnóstico-primeiro + dado soberano + governança explícita).
+- Diagnóstico como produto nunca precificado/vendido externamente.
+
+**Reordenação/fusão sugerida (técnica):**
+- Fundir Camada 2 (protótipo) com parte da Camada 3 (spec executável) quando o protótipo já gera golden cases + critérios de avaliação (eval-runner já faz isso). Entregável vira “protótipo + spec mínima para replicar sem mim”.
+- Camada transversal (autoresearch) deve alimentar skill-discovery + registry em tempo real para não reinventar.
+
+### c) Ferramentas que preenchem lacunas (jun/2026, foco indie/devs)
+Filtrado pelo seu contexto (diagnóstico-primeiro, dado soberano local, governança explícita, Brasil, Central EGOS):
+
+- **Observabilidade de agentes + HITL runtime**: LangSmith (tracing/debug/eval) ou Arize Phoenix (OTEL nativo, auto-heal). Posts de jun/2026 recomendam LangGraph 1.0 + LangSmith/Phoenix para equipes que já colocam agentes em produção (57% relatam gargalo de qualidade/estabilidade). Langfuse também aparece em talks de produção (MNTSQ AI Agent). Seus pacotes atrian-observability + mcp-observability + eval-runner já cobrem parte; integrar com um desses para runtime + HITL (interrupts em LangGraph ou approval steps).
+- **Multi-tenant seguro com RLS**: Padrões Postgres/Supabase RLS (tenant_id em todas tabelas + políticas por role/hierarquia + SET LOCAL app.current_tenant). Artigos de jan/2026 (makerkit) e mai/2025 mostram produção com performance (queries de 3min → 2ms) e testes automatizados. Seu supabase/ + packages/auth + shared permitem implementar sem vendor lock. Risco atual de query filter é real; RLS é DB-enforced.
+- **Pagamento in-WhatsApp (Mercado Pago)**: Padrão webhook Evolution API + Mercado Pago (confirmação → agente valida → libera acesso). Não encontrei ferramenta “pronta” específica para seu fluxo; é integração padrão indie brasileira (já tem whatsapp-kernel + guard-brasil). Implementar em 2-3 dias com teste de integração.
+- **Eval de agentes com provenance**: Seu eval-runner + mcp-eval-runner já classifica CONFIRMADO/INFERIDO/HIPÓTESE/PHANTOM + file:line. Manter e estender com golden cases do protótipo decisório.
+- **HITL explícito em produção**: LangGraph interrupts ou human approval nodes (posts de jun/2026). Combina com seu curriculum-gate + gates HITL existentes.
+
+Não encontrei ferramenta que substitua seu diferencial (diagnóstico + prova mínima + governança .guarani/DNA). Use para preencher buracos de runtime/segurança.
+
+### d) Modelos de precificação (jun/2026, fontes reais)
+- Auditoria/diagnóstico estruturado: $500 (audit + spec) + $3k (fix/GEO) — exemplo de AI engineer indie (mai/2026).
+- Testes de persona/insight rápido: $49–149 por run (indie hacker, mai/2026).
+- Padrão consultor-diagnosticador: diária $150-300/h ou projeto fechado $5-15k para diagnóstico + protótipo mínimo + spec executável. Retainer para ponte/handoff (pouco comum em indie; mais em firms).
+- Sinal de valor vs commodity: cobra por clareza gerada + decisão mudada (seu critério de aceite da Camada 2), não por hora de código. Protótipo que prova = produto precificável separado do diagnóstico.
+- Nenhum benchmark público exato para “clareza estruturada sem código entregue” no Brasil em jun/2026; o mais próximo são os audits de $500+.
+
+### e) Riscos e armadilhas documentados
+- Escopo que vaza do diagnóstico para implementação infinita (clássico em consulting; posts de indie/consultores alertam para boundary explícito: “pagou diagnóstico → fecha aqui”).
+- Consultor vira fábrica de código sem precificar execução (evitar handoff sem playbook testado).
+- Suporte devora capacidade (sem SLO/SLA → burnout).
+- Handoff falha e cliente volta como emergência (sem spec executável + golden cases + eval-runner validado).
+- Precificação ancora barato demais (ex: cobrar só pelo protótipo e perder o diagnóstico como produto).
+
+Fontes: padrões de consulting indie em X/Reddit 2025-2026; seu próprio diagnóstico de lacunas já identifica os principais.
+
+### f) Citações + classificação esforço/impacto (quadrante)
+Prioridade: baixo esforço + alto impacto primeiro.
+
+1. Implementar RLS Postgres/Supabase (artigos 2025-2026) — baixo esforço (você já tem supabase/ + auth), alto impacto (elimina risco multi-tenant).
+2. Wire Guard Brasil / pii-purge no runtime do whatsapp-kernel + webhook Mercado Pago — baixo esforço (pacotes existem), alto impacto (compliance produção).
+3. Integrar LangSmith/Phoenix ou estender atrian-observability + mcp-observability para runtime + HITL — médio esforço, alto impacto (qualidade/estabilidade).
+4. Criar playbook de handoff (Camada 3-4) com golden cases do eval-runner — médio esforço, alto impacto (evita suporte infinito).
+5. Precificar diagnóstico + protótipo decisório separadamente ($500-5k faixa inicial) — baixo esforço, alto impacto (valida modelo de negócio).
+6. Estender skill-discovery + registry com output do autoresearch/Hermes — baixo esforço (pacotes existem), impacto médio-alto.
+
+**3 perguntas afiadas para aprofundar:**
+1. Qual o tamanho médio do time do cliente/parceiro que recebe o handoff (Camada 3-4) — 3-5 devs ou 10+ com PM/arquiteto?
+2. O diagnóstico como produto separado já foi testado em piloto pago (mesmo que pequeno) ou só em internos?
+3. Qual o SLO mínimo aceitável para o whatsapp-kernel em produção hoje (ex: 99.5% uptime, latência P95 < X s) — ou ainda não definido?
+
+Resposta curta, técnica, sem hype. Próximo passo: escolha 1-2 itens do quadrante e peço spec técnica ou código de integração.
+
+chatgpt: /home/enio/Downloads/ChatGPT-Pesquisa e Governança IA.md
+
+perplexity: /home/enio/Downloads/Pesquisa sobre o processo arquiteto-diagnosticador de IA com protótipo decisório e handoff.md , Já rodei a pesquisa completa em cima do seu meta‑prompt e estruturei tudo em um relatório em Markdown, no estilo “paper de método” que você descreveu. [rosenverse.rosenfeldmedia](https://rosenverse.rosenfeldmedia.com/videos/the-handoff-is-dead-design-led-engineering-with-ai-agents)
+
+O relatório cobre, em blocos separados:
+
+- **a) Frameworks e métodos reais**: 4–5 frameworks bem próximos do seu (AI First Hub 4Ds, WEDGE 5‑Phase, Revue‑ai Consulting Intelligence, Deloitte “From AI pilots to production”), com links, autores e como cada um trata discovery, diagnóstico, protótipo/piloto e handoff. [deloitte](https://www.deloitte.com/nl/en/services/consulting/services/from-AI-pilots-to-production.html)
+- **b) Comparação 1:1 com o seu processo em 5 camadas**: tabela mapeando cada camada sua para essas metodologias, o que está muito certo (diagnóstico pago, protótipo decisório, spec executável) e onde o “estado da arte enterprise” te cobra mais (observabilidade contínua, HITL operacionalizado, SLO/SLA, RLS). [logz](https://logz.io/blog/top-llm-observability-tools/)
+- **c) Ferramentas para as lacunas específicas**:  
+  - Pagamento in‑WhatsApp: Meta Payments API (Brasil) + PSP (OpenPix ou Mercado Pago) com fluxo `order_details` + webhook. [reddit](https://www.reddit.com/r/consulting/comments/1rdkpfm/ai_tools_usage/)
+  - Observabilidade: Langfuse (self‑host), Arize Phoenix/AX, LangSmith, com foco em um caminho bem alinhado ao seu stack TS/Bun e dado soberano. [rb-sns](https://rb-sns.com)
+  - HITL em runtime: Orkes Conductor (Human Task) e n8n com “human‑in‑the‑loop for AI tool calls”, além de um serviço de aprovação estilo webhook mostrado em r/LangChain. [x](https://x.com/edkrystosik)
+  - Eval de agentes: Ragas/RAGAs plugado em cima do seu eval‑runner para dar métricas “oficiais” (faithfulness, relevância etc.). [reddit](https://www.reddit.com/r/LangChain/comments/1bv2hcf/a_human_approval_tool_for_your_agent_workflows/)
+  - Multi‑tenant seguro: RLS em Postgres com `current_setting('app.current_tenant')`, baseado em AWS SaaS Factory, Crunchy Data, Debugg e outros. [domo](https://www.domo.com/learn/article/ai-workflow-platforms)
+- **d) Modelos de precificação**: como pares seus estão cobrando discovery fixo + build fee + retainer; ranges de valor real reportados (diagnósticos de alguns milhares de euros, AI readiness em 10–25k para mid/enterprise) e efeitos de ancorar preço baixo demais. [langchain](https://www.langchain.com/articles/llm-observability-tools)
+- **e) Riscos/armadilhas**: virar fábrica de código, escopo vazando do diagnóstico, suporte infinito, handoff frágil, e como frameworks como WEDGE e Deloitte estruturam para evitar isso. [support2.chatarchitect](https://support2.chatarchitect.com/books/meta-whatsapp/page/payments-api-brazil-developer-documentation)
+- **f) Priorização (esforço x impacto) + 3 perguntas pra próxima rodada**: lista objetiva do que fazer primeiro (Pacote Diagnóstico, RLS, Langfuse, pagamento in‑WhatsApp, gates HITL, Ragas) e três perguntas sobre alvo de cliente, produto vs serviço e limite de suporte.
+
+Você consegue abrir o relatório agora na interface (ele já está anexado como artefato Markdown); se quiser, no próximo passo posso:
+
+- descer para o nível de **roadmap técnico** (por exemplo: esquema RLS concreto + pontos de hook no EGOS/Hermes e fluxo do pagamento WhatsApp), ou  
+- focar na **oferta comercial** (nome do pacote de diagnóstico, faixas de preço iniciais, exemplos de proposta e cláusulas para segurar escopo).
+
+---
+
+### guarani: **Perspectiva do Runtime (Auditoria de Código e Comportamento)**
+
+Como a instância interna do EGOS que executa e valida o monorepo, trago o diagnóstico de engenharia e os desvios de processo que o código e a máquina revelam (evidência > intenção).
+
+#### 1. O "Cinto de Utilidades do Batman" (O MCP Diagnosticador)
+Nossos ativos de diagnóstico estão espalhados como scripts soltos no diretório [scripts/](file:///home/enio/egos/scripts/) (ex: [readiness.ts](file:///home/enio/egos/scripts/activation-check.ts), [recon.ts](file:///home/enio/egos/scripts/recon.ts), [doctor.ts](file:///home/enio/egos/scripts/doctor.ts)). Eles são extremamente poderosos, mas estão *desconectados do fluxo de entrega pública*.
+*   **O Gap:** O cliente ou parceiro não consegue consumir isso como um serviço integrado. São ferramentas locais em CLI que exigem terminal.
+*   **A Solução:** Empacotar esses scripts em um MCP Server unificado de diagnóstico (`packages/mcp-egos-diagnostic`). Quando o cliente vier com um problema, a IA que o atende chama nossa ferramenta de `/recon` ou `/readiness` via API. O método vira serviço em tempo real.
+
+#### 2. Armadilha do Over-building (Camada 2 vs. Dev-Obsession)
+A análise de 14 sistemas inativos na máquina mostra que o Enio constrói código complexo antes da conversa humana fechar o escopo (ex: `gem-hunter`, `eagle-eye`).
+*   **O Gap:** Risco do protótipo decisório (Camada 2) virar desenvolvimento completo e infinito, ancorando o preço baixo e gerando burnout.
+*   **A Solução (Regra Dura):** O protótipo decisório deve ser estritamente sandbox. Se a construção do código de validação de hipótese tomar mais de 5 dias úteis, o escopo do protótipo está incorreto. Todo protótipo decisório deve nascer obrigatoriamente acompanhado de um arquivo de testes de comportamento no `eval-runner` (TDD-first). Se não conseguimos definir o critério de aceitação antes de codificar, não codificamos.
+
+#### 3. Vulnerabilidade de Isolamento Multi-Tenant (Segurança do Banco de Dados)
+Hoje, a separação de dados dos clientes (tenants) é feita via filtros lógicos na camada da aplicação (código de consulta).
+*   **O Gap:** Um simples esquecimento de `.eq('tenant_id', X)` em uma nova rota vaza dados confidenciais de outros clientes. Isso destrói nossa promessa de "governança e segurança".
+*   **A Solução:** Implementar RLS (Row-Level Security) no Supabase/Postgres imediatamente. A autenticação do gateway passa a setar `app.current_tenant` no escopo da transação, e o banco barra qualquer SELECT que não seja do tenant associado, independente de bugs na camada do código.
+
+#### 4. O Nó de Fechamento do Loop (Receber e Concluir)
+Historicamente, o Enio inicia as conversas (escuta inicial), constrói protótipos brilhantes, mas falha na "porta de saída": pedir o feedback definitivo ("funcionou?") e cobrar pelo valor gerado.
+*   **A Solução:** Monitorar ativamente o andamento dos trabalhos no próprio monorepo. Criar arquivos estruturados `docs/jobs/<cliente>-engagement.md` onde o status [EM_CONVERSA | ENTREGUE_AGUARDA_CONFIRMACAO | COBRADO | FINALIZADO] é auditado por nós (agentes), forçando o encerramento completo do ciclo de entrega.
+
+---
\ No newline at end of file
diff --git a/docs/governance/HITL_CURVE_PRINCIPLE.md b/docs/governance/HITL_CURVE_PRINCIPLE.md
new file mode 100644
index 00000000..a31fc9cb
--- /dev/null
+++ b/docs/governance/HITL_CURVE_PRINCIPLE.md
@@ -0,0 +1,227 @@
+---
+title: Princípio EGOS — Curva de HITL
+version: 1.0.0
+date: 2026-06-09
+status: active
+tier: T1
+owner: enio
+ssot: docs/governance/HITL_CURVE_PRINCIPLE.md
+relates_to:
+  - docs/governance/HITL_CATALOG.md       # gates implementados
+  - docs/governance/human-in-the-loop.md  # protocolo técnico Telegram
+  - .guarani/AUTONOMY_POLICY.md            # policy de autonomia
+---
+
+# Princípio EGOS — Curva de HITL [T1 — 2026-06-09]
+
+## Princípio
+
+Todo sistema de IA do EGOS começa com HITL máximo (humano aprova cada ação)
+e reduz supervisão de forma GRADUAL, POR CLASSE DE AÇÃO, e BASEADA EM EVIDÊNCIA
+MEDIDA — nunca por tempo decorrido ou "sensação de confiança".
+
+Validado por dados de produção (Anthropic, OpenAI jun/2026) com 3 correções
+críticas ao modelo simplista de "começa manual, vira automático":
+
+1. **A curva é POR OPERAÇÃO, não global.** O mesmo sistema pode estar maduro
+   (baixo HITL) para resumos e iniciante (HITL total) para pagamentos,
+   simultaneamente. Misturar classes dilui a proteção onde mais importa.
+
+2. **O que cai é a aprovação granular ação-a-ação; o monitoramento de sessão e
+   o botão de parada permanecem PARA SEMPRE.** Dado Anthropic (measuring-agent-
+   autonomy, mai/2026): usuários experientes auto-aprovam mais (20%→40%) E
+   interrompem mais (5%→9%) — a transição não é abandono, é troca de
+   "aprovar tudo" por "vigiar e intervir onde importa".
+
+3. **Classes de alto risco têm PISO ABSOLUTO permanente** (pagamento, PII,
+   decisão jurídica/médica, certificação) — nunca saem do loop, por regulação
+   (EU AI Act Art.14, LGPD Art.20, GDPR Art.22) e por engenharia (irreversível
+   por definição).
+
+**Inimigo-chave:** automation bias — reduzir HITL sem medir taxa de override
+transforma o humano em carimbo e destrói a defesa regulatória. A curva desce
+com PROVA, não com pressa.
+
+---
+
+## A Curva — 3 Fases
+
+### Fase 1 — HITL Máximo (L1: IA Sugere)
+
+| Dimensão      | Valor                                          |
+|---------------|------------------------------------------------|
+| Modo          | Human-in-the-Loop estrito                      |
+| Fluxo         | IA gera → humano revisa 100% → humano executa |
+| Configuração  | Sem auto-aprovação, sem batching               |
+| Duração       | Indefinida — sai por evidência, não por tempo  |
+
+**Métricas para avançar para Fase 2 (por classe de operação):**
+- Agreement rate ≥ 90% em janela de 30d (humano concordou sem editar)
+- Zero reversões (nenhuma ação aprovada que teve de ser desfeita)
+- Zero incidentes ligados a essa classe
+
+**Gatilho de regressão → permanece em Fase 1:**
+- Agreement rate < 80% em qualquer janela de 7d
+- Qualquer reversão de ação aprovada
+
+---
+
+### Fase 2 — Calibração (L2: Human-on-the-Loop)
+
+| Dimensão      | Valor                                                       |
+|---------------|-------------------------------------------------------------|
+| Modo          | Human-on-the-Loop (supervisão de sessão, não por ação)      |
+| Fluxo         | IA age com confidence ≥ 0.85 → notifica → humano intervém   |
+|               | se necessário; confidence < 0.85 → continua solicitando aprovação |
+| Configuração  | Confidence routing ativo; alertas de anomalia configurados  |
+
+**Métricas para avançar para Fase 3:**
+- Passthrough rate (ações sem intervenção humana) ≥ 95% em janela de ~60d
+- Intervention rate (humano interrompeu/corrigiu) < 1%
+- Revert rate < 0.2%
+- Nenhuma aprovação a zero thinking (ver alerta abaixo)
+
+**Alerta inverso — sinal de rubber-stamp:**
+Aprovação consistente em < 5s = humano não está revisando de fato. Indicador
+de automation bias (CrewAI missing-layer, jan/2026). Ação: aumentar fricção
+intencional (resumo forçado antes de confirmar) ou regredir para Fase 1.
+
+**Gatilho de regressão → volta para Fase 2:**
+- Passthrough rate cai abaixo de 90% em janela de 7d
+- Qualquer incidente ligado a ação auto-aprovada
+
+---
+
+### Fase 3 — Maduro (L3: HITL Seletivo)
+
+| Dimensão      | Valor                                                          |
+|---------------|----------------------------------------------------------------|
+| Modo          | HITL restrito a alto risco + monitoramento contínuo de sessão  |
+| Fluxo         | IA age autonomamente no volume; HITL para pisos absolutos       |
+|               | e anomalias detectadas; auto-review de IA cobre volume          |
+| Configuração  | Monitoramento de sessão ativo; botão de parada sempre exposto   |
+
+**Rollback obrigatório — reset para Fase anterior se:**
+- Error rate > 5% em qualquer janela de 1h
+- Override rate dobra em qualquer janela de 4h
+- QUALQUER troca de modelo (LLM diferente = comportamento não calibrado)
+- Novo tipo de ação aparece na classe (escopo expandiu → Fase 1 para esse subtipo)
+- Incidente de qualquer severidade ligado a ação autônoma
+
+**O que NUNCA é autônomo em Fase 3:** ver Pisos Absolutos abaixo.
+
+---

exec
/bin/bash -lc "git diff 3d0f899f36ac9fc07105eaaa7dfc551838361c97 -- docs/governance/HITL_CURVE_PRINCIPLE.md | sed -n '260,520p'" in /home/enio/egos
 succeeded in 0ms:
exec
/bin/bash -lc "nl -ba docs/governance/HITL_CURVE_PRINCIPLE.md | sed -n '100,240p' && nl -ba docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md | sed -n '80,180p' && nl -ba docs/jobs/2026-06-09-doc-drift-verifier.json | sed -n '70,130p'" in /home/enio/egos
 succeeded in 0ms:
   100	| Fluxo         | IA age autonomamente no volume; HITL para pisos absolutos       |
   101	|               | e anomalias detectadas; auto-review de IA cobre volume          |
   102	| Configuração  | Monitoramento de sessão ativo; botão de parada sempre exposto   |
   103	
   104	**Rollback obrigatório — reset para Fase anterior se:**
   105	- Error rate > 5% em qualquer janela de 1h
   106	- Override rate dobra em qualquer janela de 4h
   107	- QUALQUER troca de modelo (LLM diferente = comportamento não calibrado)
   108	- Novo tipo de ação aparece na classe (escopo expandiu → Fase 1 para esse subtipo)
   109	- Incidente de qualquer severidade ligado a ação autônoma
   110	
   111	**O que NUNCA é autônomo em Fase 3:** ver Pisos Absolutos abaixo.
   112	
   113	---
   114	
   115	## Onde o Humano Nunca Sai — Pisos Absolutos
   116	
   117	Independente de fase, confidence, histórico ou pressão de tempo.
   118	
   119	| Ação                                       | Nível mínimo                | Base regulatória / técnica                        |
   120	|--------------------------------------------|-----------------------------|---------------------------------------------------|
   121	| Pagamento / transação financeira irreversível acima de threshold | Gate humano obrigatório | PSRs 2017 Art.64; IMF 2026/004 §3.2; Anthropic measuring-agent-autonomy |
   122	| PII com efeito jurídico (decisão sobre pessoa) | Gate humano obrigatório | LGPD Art.20; GDPR Art.22; EU AI Act Art.14        |
   123	| Hard delete / export em massa / deploy prod | Gate humano obrigatório     | Regra dos 3 testes (ver abaixo); PRODUCTION_DEPLOY_RULES.md |
   124	| Decisão jurídica sobre pessoa física/jurídica | Gate humano obrigatório   | EU AI Act Annex III; LGPD Art.20                  |
   125	| Biometria em enforcement                   | HITL-duplo obrigatório      | EU AI Act Art.14(5)                               |
   126	| Diagnóstico / prescrição em saúde          | Gate humano obrigatório     | EU AI Act Annex III High-Risk §5; CFM res. 2.314/2022 |
   127	| Filing regulatório / certificação / SAR    | Gate humano obrigatório     | ANPD NT 12/2025; COAF RN 36/2021                  |
   128	| Decisão de emprego / acesso ampliado       | Gate humano obrigatório     | EU AI Act Annex III; LGPD Art.7                   |
   129	| Ação catastrófica (qualquer ação que não desfaz sem danos) | Gate humano obrigatório | arXiv 2502.02649; Omnithium severidade×reversibilidade |
   130	
   131	**Regra-mãe EGOS:** qualquer ação que (1) mova dinheiro, (2) amplie acesso, ou
   132	(3) não desfaça com 1 clique → gate humano obrigatório, independente de
   133	confidence. Liga ao Red Zone constitucional (`CLAUDE.md §0.5`).
   134	
   135	**Regra dos 3 testes (Dock dangerous-ops-contract, 2026):**
   136	Se a resposta for SIM a qualquer um dos 3 → piso absoluto:
   137	1. Move dinheiro ou cria obrigação financeira?
   138	2. Amplia acesso a dado sensível ou infraestrutura?
   139	3. Não desfaz com 1 clique sem consequência?
   140	
   141	---
   142	
   143	## Como Mostrar ao Cliente (Material / Diagnóstico)
   144	
   145	Frase honesta e calibrada para diagnóstico (liga `R-DIAG-001`):
   146	
   147	> "No começo a gente coloca mais gente no loop — o humano revisa cada saída
   148	> da IA antes de qualquer coisa acontecer. Conforme os processos amadurecem
   149	> e acumulamos evidência de que o sistema acerta (não é confiança no escuro,
   150	> é medida: taxa de acerto, taxa de correção), a supervisão diminui e fica
   151	> mais inteligente: o humano para de aprovar tudo e passa a vigiar e
   152	> intervir só onde importa. Isso é normal e é assim que se faz com
   153	> segurança — é o padrão que Anthropic, OpenAI e a regulação europeia
   154	> descrevem em 2026. E tem coisa que nunca sai da mão do humano: pagamento,
   155	> dado pessoal sensível, decisão irreversível e certificação sempre passam
   156	> por aprovação — por engenharia e por lei. Reduzir o humano cedo demais
   157	> não é eficiência, é risco; a curva desce com prova, não com pressa."
   158	
   159	**Apresentar dois cenários quando relevante** (ex: dado pessoal / CPF):
   160	- Cenário proteção máxima: custo, overhead, o que cobre
   161	- Cenário dados reais com HITL calibrado: realidade do mercado BR (LGPD pouco
   162	  enforçado jun/2026; grandes empresas e governos passam dados reais a LLMs),
   163	  sinergia de dados, funcionalidade plena com gate humano no ponto crítico
   164	- Nunca escolher pelo cliente — apresentar trade-offs reais, cliente decide
   165	
   166	---
   167	
   168	## Métricas de Operação
   169	
   170	| Métrica                 | Definição                                              | Ferramenta de medição           |
   171	|-------------------------|--------------------------------------------------------|---------------------------------|
   172	| agreement_rate          | % ações aprovadas sem edição humana                    | HITL log (`~/.egos/hitl-log.jsonl`) |
   173	| intervention_rate       | % ações onde humano interrompeu ou corrigiu            | idem                            |
   174	| revert_rate             | % ações aprovadas que tiveram de ser desfeitas         | idem + git log                  |
   175	| passthrough_rate        | % ações em Fase 2 sem pedido de aprovação              | idem                            |
   176	| rubber_stamp_signal     | % aprovações em < 5s                                   | idem (timestamp delta)          |
   177	| confidence_p50_p95      | Distribuição de confidence do modelo por classe        | telemetria do agente            |
   178	| phase_per_class         | Fase atual por classe de operação                      | `~/.egos/hitl-phase-map.json`   |
   179	
   180	Frequência de revisão: a cada 30d por classe ativa, ou imediatamente após
   181	qualquer incidente.
   182	
   183	---
   184	
   185	## Wiring no EGOS
   186	
   187	Gates implementados hoje: ver `docs/governance/HITL_CATALOG.md` (5 gates).
   188	Protocolo técnico (Telegram callbacks): `docs/governance/human-in-the-loop.md`.
   189	Policy de autonomia por agent: `.guarani/AUTONOMY_POLICY.md`.
   190	
   191	Fase atual por domínio (INFERIDO — atualizar com evidência medida):
   192	
   193	| Domínio / classe de ação              | Fase atual | Evidência de medição | Próxima revisão |
   194	|---------------------------------------|------------|----------------------|-----------------|
   195	| Resumos / geração de texto interno    | 2          | uso diário ativo     | 2026-07-09      |
   196	| Commits em branch dev                 | 2          | Gate 4 ativo         | 2026-07-09      |
   197	| Commits em frozen zones / governance  | 1          | Gate 4 fail-closed   | permanente      |
   198	| Publicação de conteúdo externo        | 1          | Gate 2 + HITL-003 gap| permanente      |
   199	| Deploy produção VPS                   | 1          | HITL-002 gap aberto  | após HITL-002   |
   200	| Pagamento / transação financeira      | Piso absoluto | —                 | nunca            |
   201	| PII com efeito jurídico               | Piso absoluto | —                 | nunca            |
   202	
   203	---
   204	
   205	## Fontes
   206	
   207	| Fonte | Data | URL / referência |
   208	|-------|------|------------------|
   209	| Anthropic — Measuring Agent Autonomy | mai/2026 | https://www.anthropic.com/research/measuring-agent-autonomy |
   210	| OpenAI — Alignment auto-review & oversight | abr/2026 | https://openai.com/research/practices-for-governing-agentic-ai-systems |
   211	| Autonomy Dial (tianpan.co) | abr/2026 | https://tianpan.co/notes/autonomy-dial |
   212	| Facio — 4-tier human oversight model | mai/2026 | https://facio.ai/blog/human-oversight-agentic-ai |
   213	| Omnithium — severity × reversibility framework | mai/2026 | https://omnithium.com/blog/hitl-severity-reversibility |
   214	| CrewAI — The missing human oversight layer | jan/2026 | https://crewai.com/blog/the-missing-human-oversight-layer |
   215	| EU AI Act Art.14 — Human oversight | ago/2024 | https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689 |
   216	| LGPD Art.20 — Decisões automatizadas | ago/2018 | https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm |
   217	| ANPD NT 12/2025 — IA e proteção de dados | 2025 | https://www.gov.br/anpd/ |
   218	| arXiv 2502.02649 — Fully autonomous agents should not | fev/2026 | https://arxiv.org/abs/2502.02649 |
   219	| IMF WP/2026/004 — AI payments risk | jan/2026 | https://www.imf.org/en/Publications/WP/Issues/2026/01/04 |
   220	| Dock — Dangerous operations contract | 2026 | https://dock.io/blog/dangerous-operations-contract |
   221	| PSRs 2017 Art.64 — Payment approval | 2017 | https://www.legislation.gov.uk/uksi/2017/752/article/64 |
   222	
   223	---
   224	
   225	*SSOT: este arquivo. Complementos: `HITL_CATALOG.md` (implementação dos gates)
   226	+ `human-in-the-loop.md` (protocolo Telegram). Atualizar quando nova classe
   227	de operação atingir critério de fase ou após incidente. T1 — evidência-first.*
    80	- item-intake: pipeline foto de cardápio → planilha de PDV — caso completo provado
    81	  (diagnóstico → protótipo → dado real → gate HITL → deploy em produção).
    82	- Storefront multi-tenant (G Peças, APeças Patense) com checkout Pix integrado.
    83	- Skills de diagnóstico codificadas como comandos:
    84	  /readiness (avalia se empresa está pronta para IA, 7 dimensões + veredito PRONTA/PARCIAL/NÃO-AINDA),
    85	  /inception (gate obrigatório antes de iniciar projeto novo),
    86	  /diag (diagnóstico técnico de sistema),
    87	  /recon (prospecção e análise de empresa por CNPJ).
    88	- eval-runner: sistema de golden cases para validar capacidades de agentes —
    89	  método anti-alucinação que classifica CONFIRMADO/INFERIDO/HIPÓTESE/PHANTOM
    90	  e exige proveniência (file:line) em toda afirmação sobre o sistema.
    91	- NotebookLM pipeline: gera áudio, slides e HTML de diagnóstico a partir de markdown —
    92	  entregável didático para o cliente sem exigir que ele leia doc técnico.
    93	- Hermes: orquestrador VPS sempre ligado, cron de autoresearch, cura 179 ferramentas/dia
    94	  de 14 fontes (Reddit, arXiv, GitHub, newsletters, X.com).
    95	
    96	---
    97	
    98	## O QUE TALVEZ FALTE — onde quero ajuda (honesto)
    99	
   100	- Nenhum cliente externo pagante ainda; maturidade atual = demo e piloto pré-contrato.
   101	- Lacunas enterprise identificadas:
   102	  - Gate de PII não está wired no caminho crítico do chatbot WhatsApp (roda em pre-commit,
   103	    não em runtime de produção).
   104	  - Zero teste de integração do fluxo completo (só testes unitários por módulo).
   105	  - Sem SLO/SLA documentado; sem estrutura de suporte.
   106	  - Isolamento multi-tenant implementado em código (query filter), não em RLS (Postgres
   107	    Row Level Security) — risco em caso de bug.
   108	- Pagamento no fluxo WhatsApp (gerar link Mercado Pago, agente validar e liberar acesso
   109	  após pagamento confirmado) não implementado end-to-end.
   110	- O diagnóstico como produto nunca foi vendido nem precificado externamente — não sei
   111	  quanto o mercado paga por "clareza estruturada" sem código entregue.
   112	- Handoff para execução: sem playbook testado para transferir responsabilidade para
   113	  time do cliente ou parceiro sem perder qualidade do diagnóstico.
   114	
   115	---
   116	
   117	## O QUE PEÇO A VOCÊ — tarefa de pesquisa (com pesquisa web atual, jun/2026)
   118	
   119	Use busca web real. Cite URL e data de publicação. Se não encontrar dado de 2026,
   120	informe a data mais recente que encontrou.
   121	
   122	**a) Frameworks e métodos do mundo real**
   123	Busque nos últimos 12 meses em Reddit (r/consulting, r/AI_Agents, r/LocalLLaMA,
   124	r/MachineLearning, r/Entrepreneur), X.com, arXiv, GitHub e blogs de prática:
   125	quais são os melhores frameworks, métodos e playbooks para o perfil
   126	"consultor-diagnosticador de IA que prova com protótipo e faz handoff para execução"?
   127	Nomes de metodologias, autores, repositórios, threads relevantes.
   128	
   129	**b) Comparação com estado da arte**
   130	Compare meu processo de 5 camadas com o que você encontrar.
   131	O que estou fazendo certo (não precisa mudar)?
   132	O que está faltando (lacuna real, não opinião)?
   133	O que reordenar ou fundir?
   134	Seja específico — não me dê framework genérico de consultoria.
   135	
   136	**c) Ferramentas que preenchem minhas lacunas (jun/2026)**
   137	Foque apenas nas lacunas que descrevi: pagamento in-WhatsApp, observabilidade de agentes,
   138	HITL em runtime de produção, eval de agentes, multi-tenant seguro com RLS.
   139	Para cada ferramenta: nome, link, licença (open-source/comercial), maturidade (produção/beta/alpha),
   140	por que se encaixa na MINHA individualidade (diagnóstico-primeiro, dado soberano local,
   141	governança explícita).
   142	Não me dê dump genérico de "ferramentas de IA 2026" — filtre pelo meu contexto.
   143	
   144	**d) Modelos de precificação**
   145	Como consultor-diagnosticador de IA cobra pelo diagnóstico + protótipo + handoff?
   146	O que o mercado paga em jun/2026 por "clareza estruturada" sem código entregue?
   147	Mostre modelos reais (diária, projeto fechado, sucesso, retainer), faixas de valor
   148	praticadas por perfis similares, e o que sinaliza valor vs comodity nesse serviço.
   149	Referências: threads de Reddit/X.com, posts de consultores independentes, benchmarks.
   150	
   151	**e) Riscos e armadilhas conhecidos**
   152	Quais são as armadilhas documentadas desse modelo de negócio?
   153	Priorize: consultor que vira fábrica de código, escopo que vaza do diagnóstico para
   154	implementação infinita, suporte que devora capacidade, handoff que falha e o cliente
   155	volta como emergência, precificação que ancora barato demais.
   156	Fontes reais preferidas (Reddit, LinkedIn, X.com, blogs de prática).
   157	
   158	**f) Citações e classificação**
   159	Para cada sugestão: cite URL + data. Classifique por esforço/impacto
   160	(quadrante: baixo esforço + alto impacto primeiro).
   161	Termine com 3 perguntas afiadas para me conhecer melhor antes de aprofundar qualquer ponto.
   162	
   163	---
   164	
   165	## REGRAS DE INTERAÇÃO
   166	
   167	1. Pesquisa web atual (jun/2026) com fonte. Se a fonte for anterior, diga a data.
   168	2. Não invente ferramentas ou recursos. Se não tiver certeza se algo existe, diga
   169	   "não encontrei evidência — pode ser conceito ou projeto descontinuado".
   170	3. Classifique o que é real (link verificável) vs conceito vs phantom.
   171	4. Respeite minha individualidade: não me transforme em "mais um consultor de IA genérico".
   172	   Meu diferencial é diagnóstico + prova + governança explícita + dado soberano.
   173	5. Seja específico e brutalmente honesto. Não bajule.
   174	6. Se eu tiver feito algo que contradiz boas práticas documentadas, diga diretamente.
   175	```
    70	    {
    71	      "id": "kernel_packages",
    72	      "description": "Packages in packages/ directory",
    73	      "status": "ok",
    74	      "last_value": "36",
    75	      "current_value": "38",
    76	      "tolerance": "±2",
    77	      "drift_abs": 2,
    78	      "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
    79	      "severity": "ok"
    80	    },
    81	    {
    82	      "id": "commits_30d_all_repos",
    83	      "description": "Total commits across all active EGOS repos in last 30 days",
    84	      "status": "ok",
    85	      "last_value": "1466",
    86	      "current_value": "1286",
    87	      "tolerance": "min:50",
    88	      "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
    89	      "severity": "ok"
    90	    },
    91	    {
    92	      "id": "unique_differentials",
    93	      "description": "Unique technical differentials documented in EGOS_STATE",
    94	      "status": "ok",
    95	      "last_value": "22",
    96	      "current_value": "22",
    97	      "tolerance": "min:6",
    98	      "command": "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
    99	      "severity": "ok"
   100	    },
   101	    {
   102	      "id": "completed_tasks_total",
   103	      "description": "Total completed tasks in TASKS.md",
   104	      "status": "ok",
   105	      "last_value": "0",
   106	      "current_value": "0\n0",
   107	      "tolerance": "min:0",
   108	      "command": "grep -c '^- \\[x\\]' TASKS.md || echo 0",
   109	      "severity": "ok"
   110	    },
   111	    {
   112	      "id": "active_products",
   113	      "description": "Live products with public URLs in EGOS ecosystem",
   114	      "status": "ok",
   115	      "last_value": "7",
   116	      "current_value": "7",
   117	      "tolerance": "min:5",
   118	      "command": "grep -c '\\*\\*URL:\\*\\*' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md",
   119	      "severity": "ok"
   120	    },
   121	    {
   122	      "id": "capability_registry_sections",
   123	      "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
   124	      "status": "ok",
   125	      "last_value": "19",
   126	      "current_value": "100",
   127	      "tolerance": "min:10",
   128	      "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
   129	      "severity": "ok"
   130	    },

exec
/bin/bash -lc 'python3 -m json.tool docs/jobs/2026-06-09-doc-drift-verifier.json >/dev/null && python3 -m json.tool docs/jobs/2026-06-09-pre-commit-pipeline.json >/dev/null && echo ok' in /home/enio/egos
 succeeded in 0ms:
ok

exec
/bin/bash -lc 'grep -R "docs/jobs" -n . | head -50' in /home/enio/egos
 succeeded in 198ms:
./docs/infra/VPS_CONTAINER_ARCHITECTURE.md:236:*Related: `docs/jobs/2026-04-29-vps-health-audit.md`, `docs/VPS_RESTART_PLAYBOOK.md`*
./docs/infra/VPS_RESTART_PLAYBOOK.md:233:*Related: `docs/jobs/2026-04-29-vps-health-audit.md`*
./docs/drafts/conselho.md:132:*   **A Solução:** Monitorar ativamente o andamento dos trabalhos no próprio monorepo. Criar arquivos estruturados `docs/jobs/<cliente>-engagement.md` onde o status [EM_CONVERSA | ENTREGUE_AGUARDA_CONFIRMACAO | COBRADO | FINALIZADO] é auditado por nós (agentes), forçando o encerramento completo do ciclo de entrega.
./docs/drafts/chatatual.md:3791:M  docs/jobs/2026-05-19-doc-drift-verifier.json
./docs/drafts/chatatual.md:3792:M  docs/jobs/2026-05-19-pre-commit-pipeline.json
./docs/drafts/chatatual.md:3793:A  docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:3794:A  docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:4590:	modified:   docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:4621: docs/jobs/2026-05-20-pre-commit-pipeline.json |   8 +
./docs/drafts/chatatual.md:4755:[logger] Job log: docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:4796: M docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7081:M	docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:7082:M	docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7100:	modified:   docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:7101:	modified:   docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7153:	modified:   docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:7154:	modified:   docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7193: M docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:7194: M docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7242: M docs/jobs/2026-05-20-doc-drift-verifier.json
./docs/drafts/chatatual.md:7243: M docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:7399:[logger] Job log: docs/jobs/2026-05-20-pre-commit-pipeline.json
./docs/drafts/chatatual.md:9823:[logger] Job log: docs/jobs/2026-05-21-pre-commit-pipeline.json
./docs/drafts/chatatual.md:10603:?? docs/jobs/2026-05-21-doc-drift-verifier.json
./docs/drafts/chatatual.md:10604:?? docs/jobs/2026-05-21-pre-commit-pipeline.json
./docs/_out-of-scope/trading/README.md:94:  -v /opt/egos-git/docs/jobs:/docs/jobs:ro \
./docs/_out-of-scope/trading/STATE_OF_THE_TRADING_DASHBOARD.md:467:  -v /opt/egos-git/docs/jobs:/docs/jobs:ro \
./docs/capabilities/003-agentes-autonomos.md:126:- `doc-drift-verifier` e outros com job diário registrado em `docs/jobs/`
./docs/capabilities/003-agentes-autonomos.md:162:- `/home/enio/egos/docs/jobs/` — histórico de execuções de jobs
./docs/capabilities/009-observabilidade-telemetria.md:26:4. **Relatório periódico:** agente gera relatórios publicados em `docs/jobs/` no formato JSON estruturado.
./docs/capabilities/009-observabilidade-telemetria.md:41:- Storage: JSON local (`~/.egos/last-health-check.json`) + `docs/jobs/`
./docs/capabilities/009-observabilidade-telemetria.md:56:- `egos/docs/jobs/` — relatórios gerados
./docs/capabilities/009-observabilidade-telemetria.md:98:4. **"Logs?"** — `docs/jobs/` no repositório versionado e `agents/registry/validation.json` — rastreável via git.
./docs/capabilities/CBC-EGOS-AGENT-SCOPE-CHECK-001.md:24:3. **role=guarani** + staged `docs/jobs/*.json` (permitido) → exit 0. ✅
./docs/jobs/agent-sentinela-2026-06-08.md:27:> ## Sumário do Blackboard EGOS  *   **Arquivos Modificados:**     *   `docs/jobs/2026-06-04-pre-commit-
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:12:**This is expected behavior post-INC-004.** The agents run but channel their output to git commits and `docs/jobs/` reports instead of Supabase realtime.
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:52:docs/jobs/2026-04-14-doc-drift-verifier.json  ← today (5 claims: 5 passed)
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:53:docs/jobs/2026-04-12-doc-drift-verifier.json  ← 2 days ago
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:54:docs/jobs/2026-04-10-governance-drift.md      ← 4 days ago (CLEAN)
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:55:docs/jobs/2026-04-10-doc-drift-sentinel.md    ← 4 days ago
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:56:docs/jobs/evidence-gate-2026-04-12.log        ← 2 days ago
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:57:docs/jobs/2026-04-09-code-security.md         ← 5 days ago
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:58:docs/jobs/2026-04-09-doc-drift-analysis.md    ← 5 days ago
./docs/jobs/ENC-L1-006-agent-execution-evidence.md:85:1. Each agent should write a lightweight `docs/jobs/YYYY-MM-DD-<agent>.md` on every run
./docs/jobs/agent-sentinela-2026-06-07.md:27:> ## Sumário do Blackboard EGOS  *   **Arquivos Modificados:**     *   `docs/jobs/2026-06-04-pre-commit-
./docs/jobs/agent-sentinela-2026-06-03.md:27:> # Blackboard Summary - EGOS Coherence & Coordination  ## 📝 Arquivos Modificados - `docs/jobs/2026-06-02-pre-commit-pipeline.json` - Adicionados registros de eventos de commit  ## 🔧 Impacto Técnico -
./docs/jobs/agent-sentinela-2026-06-09.md:27:> ## Sumário do Blackboard EGOS  *   **Arquivos Modificados:**     *   `docs/jobs/2026-06-04-pre-commit-
./docs/jobs/agent-sentinela-2026-06-05.md:27:> ## Sumário do Blackboard EGOS  *   **Arquivos Modificados:**     *   `docs/jobs/2026-06-04-pre-commit-
./docs/jobs/2026-05-26-telegram-spam-fix.md:89:- `docs/jobs/2026-05-26-telegram-spam-fix.md` (este doc)
./docs/jobs/2026-05-01-governance-drift.md:55:**Action:** VPS health and governance reports require follow-up. Cross-ref: `docs/jobs/2026-04-29-vps-health-audit.md`.

exec
/bin/bash -lc "nl -ba docs/personal-os/ENIO_UNDERSTANDING_MAP.md | sed -n '34,45p'" in /home/enio/egos
 succeeded in 0ms:
    34	- **Abstrai pessoa → ideia/conceito** (A27) — "menos CPF, mais ideia". Diferencial em vendas/Council/conflito
    35	- **Visão investigativa de necessidades** (A37) — vê dor antes de articulada. Estratégia atual: catálogo > cobrança imediata. Comercializar quando ≥3 cases publicados OU ≥5 clientes
    36	- **Modelo de venda Discovery+Build** (A40) — cliente traz problema, ele arquiteta. Lucas/pixelart provou. NÃO é Pitch+Sell
    37	- **Self-awareness operacional alta** (A48) — nomeia próprios bloqueios, valida protocolos contra si mesmo
    38	
    39	**Validado pela retomada EPOS B2 (2026-06-08):**
    40	- **Flow zones (B2-Q1):** flui em (1) CONVERSAR (assunto interessante → horas) e (2) RESOLVER/CONSTRUIR/PESQUISAR — próprios e dos outros. Auto-rótulo "resolvedor de problemas, mesmo que tenha que criar/amplificar eles" (Jordan). → agente pode usar isso como combustível, mas vigiar o lado dispersor (criar problema pra ter o que resolver).
    41	- **Mecanismo produção∞/captura-adiada (B2-Q1+Q2):** o que ADIA é RECEBER/capturar valor (dinheiro fora da polícia). Explica 460 commits/R$0 + dispersão 🔴. Quando ele hesitar em cobrar/fechar → é o nó de receber (🔴 abaixo), não falta de valor. Está em movimento (Miguel/GOW/Hotmart = rampa). 🔒 protegido. Ver `memory/user_enio_flow_zones_capture_block_2026-06-08.md`.
    42	- **Padrão guia-de-ferramentas (B2-Q3):** o pedido mais significativo que Enio recebe = alguém que ficou travado numa ferramenta que ele pesquisou/testou. Ele é o intermediário que faz a "tradução técnica→leigo" em ferramentas. Padrão: researcher→experimenter→guia. 🔴 RED ZONE: o caso concreto citado (colega policial + alcoolismo + psilocibina) é PROTEGIDO — bem-estar real + contexto policial. NUNCA público, NUNCA "provado em código" como serviço. Ver `memory/user_enio_tool_guide_pattern_2026-06-08.md`.
    43	
    44	**Validado pela clarificação 2026-05-20 (atom A78 — ver IDENTITY_AND_METHOD.md):**
    45	- **Habilidade central canonical:** transformar caos informacional em clareza estratégica aplicável (não é pivot — é nome para o padrão que sempre existiu)

exec
/bin/bash -lc "grep -R \"completed_tasks_total\\|doc-drift\" -n scripts agents packages | head -100" in /home/enio/egos
 succeeded in 9824ms:
scripts/gen-skills-registry-counts.ts:12: *   # Após gitleaks / antes do doc-drift:
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:654:| L2 | `doc-drift-verifier.ts` + `.husky/doc-drift-check.sh` | Pre-commit (staged code files) | egos repo |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:655:| L3 | `doc-drift-sentinel.ts` | Local cron 0h17 BRT daily | all known repos |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:656:| L3.5 | `doc-drift-analyzer.ts` | CCR `governance-drift.yml` | egos repo (GH Actions) |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:660:- **`doc-drift-sentinel`** — autonomous daily drift detector + fixer (branch + issue + telegram)
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:662:- **`doc-drift-verifier`** (CLI) — `--all/--repo/--fail-on-drift/--markdown`
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:672:- `scripts/run-doc-drift-sentinel.sh` — cron wrapper with `cd /home/enio/egos`
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:673:- `.github/workflows/governance-drift.yml` — daily CCR + doc-drift-verifier + safe-push
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:914:**First article:** `20260416-doc-drift-shield` — PT-BR (9d5c8416) + EN (eebece09), pending approval in HQ.
scripts/x-post.ts:10: *   bun scripts/x-post.ts --slug 20260416-doc-drift-shield --lang pt-br --dry-run
scripts/x-post.ts:11: *   bun scripts/x-post.ts --slug 20260416-doc-drift-shield --lang en --dry-run
scripts/x-post.ts:12: *   bun scripts/x-post.ts --slug 20260416-doc-drift-shield --lang pt-br   # live post
scripts/evidence-gate.ts:18: *   Called by .husky/pre-commit after existing doc-drift-verifier.
scripts/paperclip-register-agents.ts:39:  { id: "doc-drift-sentinel", title: "Doc Drift Sentinel", role: "IC", reports_to: "egos-kernel" },
scripts/codex-pattern-threshold.ts:126:\`doc-drift-verifier\` runs in pre-commit to enforce.
scripts/lib/agent-event.ts:21:  source: string;          // e.g. 'morning-report', 'gem-hunter', 'doc-drift'
scripts/system-map-gen.ts:89:*Validação: \`bun scripts/system-map-gen.ts --check\` (axis/status/depends_on). Dono da não-degradação: doc-drift shield (\`.egos-manifest.yaml\` claim \`operating_surface_entries\`).*
scripts/hook-telemetry-report.ts:191:    console.log('  3. If doc-drift: bun scripts/docs-root-audit.ts (reindex manifests)\n');
scripts/insert-draft.ts:6: *   bun scripts/insert-draft.ts --file docs/timeline_drafts/20260416-doc-drift-shield.pt-br.md
scripts/insert-draft.ts:7: *   bun scripts/insert-draft.ts --file docs/timeline_drafts/20260416-doc-drift-shield.en.md --translation-of <pt-br-draft-id>
scripts/session-aggregator.sh:67:if [ -f "$REPO_ROOT/docs/jobs/doc-drift-cron.log" ]; then
scripts/session-aggregator.sh:68:  GOV_DRIFT=$(tail -5 "$REPO_ROOT/docs/jobs/doc-drift-cron.log" 2>/dev/null \
scripts/run-doc-drift-sentinel.sh:6:exec /usr/bin/bun agents/agents/doc-drift-sentinel.ts "$@"
scripts/x-article-thread.ts:7: *   bun run scripts/x-article-thread.ts doc-drift-shield
scripts/x-article-thread.ts:8: *   bun run scripts/x-article-thread.ts doc-drift-shield --dry-run
agents/agents/doc-drift-verifier.ts:3: * doc-drift-verifier.ts — Layer 2 of the EGOS Doc-Drift Shield
agents/agents/doc-drift-verifier.ts:9: *   bun agents/agents/doc-drift-verifier.ts --manifest ./.egos-manifest.yaml
agents/agents/doc-drift-verifier.ts:10: *   bun agents/agents/doc-drift-verifier.ts --repo /home/enio/carteira-livre
agents/agents/doc-drift-verifier.ts:11: *   bun agents/agents/doc-drift-verifier.ts --all          # scan all known repos
agents/agents/doc-drift-verifier.ts:12: *   bun agents/agents/doc-drift-verifier.ts --fail-on-drift # exit 1 if any drift
agents/agents/doc-drift-verifier.ts:13: *   bun agents/agents/doc-drift-verifier.ts --json          # JSON output
agents/agents/doc-drift-verifier.ts:14: *   bun agents/agents/doc-drift-verifier.ts --markdown      # markdown table
agents/agents/doc-drift-verifier.ts:440:    console.error(`[doc-drift] ERROR: Cannot read manifest: ${manifestPath}`);
agents/agents/doc-drift-verifier.ts:447:    console.error(`[doc-drift] ERROR: Invalid manifest YAML: ${manifestPath}`);
agents/agents/doc-drift-verifier.ts:461:  console.error(`\n[doc-drift] Verifying ${claims.length} claims in ${manifest.repo ?? "?"} ...`);
agents/agents/doc-drift-verifier.ts:519:    console.error(`\n[doc-drift] Checking ${domains.length} domain(s) ...`);
agents/agents/doc-drift-verifier.ts:667:    console.error("[doc-drift] No manifests found in known repos.");
agents/agents/doc-drift-verifier.ts:673:    console.error(`[doc-drift] ERROR: No manifest at ${p}`);
agents/agents/doc-drift-verifier.ts:679:    console.error(`[doc-drift] ERROR: Manifest not found: ${opts.manifest}`);
agents/agents/doc-drift-verifier.ts:688:    console.error(`[doc-drift] No manifest found in ${cwd}. Use --manifest, --repo, or --all.`);
agents/agents/doc-drift-verifier.ts:721:  const reportPath = join(jobsDir, `${date}-doc-drift-verifier.json`);
agents/agents/doc-drift-verifier.ts:732:    source: "doc-drift-verifier",
agents/agents/doc-drift-sentinel.ts:3: * doc-drift-sentinel.ts — Layer 3 of the EGOS Doc-Drift Shield
agents/agents/doc-drift-sentinel.ts:7: *   2. Runs doc-drift-verifier for each repo
agents/agents/doc-drift-sentinel.ts:13: *   bun agents/agents/doc-drift-sentinel.ts --dry          # detect-only, no writes
agents/agents/doc-drift-sentinel.ts:14: *   bun agents/agents/doc-drift-sentinel.ts --exec         # full run
agents/agents/doc-drift-sentinel.ts:15: *   bun agents/agents/doc-drift-sentinel.ts --exec --repo /home/enio/carteira-livre
agents/agents/doc-drift-sentinel.ts:34:const VERIFIER = join(dirname(Bun.main), "doc-drift-verifier.ts");
agents/agents/doc-drift-sentinel.ts:35:const ISSUE_LOG = "/var/lib/egos/doc-drift-sentinel/issue-log.json";
agents/agents/doc-drift-sentinel.ts:331:  const title = `[doc-drift] ${claim.id}: ${claim.last_value} → ${claim.current_value} (${drift})`;
agents/agents/doc-drift-sentinel.ts:342:    `bun agents/agents/doc-drift-verifier.ts --repo ${repoDir}`,
agents/agents/doc-drift-sentinel.ts:351:    `*Auto-generated by doc-drift-sentinel — Layer 3 of the EGOS Doc-Drift Shield*`,
agents/agents/doc-drift-sentinel.ts:540:  const reportPath = join(reportDir, `${date}-doc-drift-sentinel.md`);
agents/agents/doc-drift-sentinel.ts:562:    `*Generated by doc-drift-sentinel.ts — Layer 3 of the EGOS Doc-Drift Shield*`,
agents/agents/doc-drift-analyzer.ts:3: * doc-drift-analyzer.ts — Layer 3.5 of the EGOS Doc-Drift Shield
agents/agents/doc-drift-analyzer.ts:9: * Unlike doc-drift-sentinel.ts (runs locally across all repos),
agents/agents/doc-drift-analyzer.ts:14: *   bun agents/agents/doc-drift-analyzer.ts                  # analyze + console
agents/agents/doc-drift-analyzer.ts:15: *   bun agents/agents/doc-drift-analyzer.ts --output-file    # write to docs/jobs/
agents/agents/doc-drift-analyzer.ts:16: *   bun agents/agents/doc-drift-analyzer.ts --json           # JSON output
agents/agents/doc-drift-analyzer.ts:166:      "No drift events found in reports — either all clean or report format not parsed. Verify doc-drift-sentinel output format."
agents/agents/doc-drift-analyzer.ts:171:      "No drift reports found in docs/jobs/. Run doc-drift-sentinel.ts --exec to generate first report."
agents/agents/doc-drift-analyzer.ts:203:    recommendations: ["No docs/jobs/ directory found — run doc-drift-sentinel first"],
agents/agents/doc-drift-analyzer.ts:244:*Generated by doc-drift-analyzer.ts | EGOS Doc-Drift Shield Layer 3.5*
agents/agents/doc-drift-analyzer.ts:265:    const outPath = join(repoRoot, "docs", "jobs", `${now}-doc-drift-analysis.md`);
agents/registry/validation.json:138:      "id": "doc-drift-sentinel",
agents/registry/validation.json:139:      "entrypoint": "agents/agents/doc-drift-sentinel.ts",
agents/registry/validation.json:162:      "id": "doc-drift-verifier",
agents/registry/validation.json:163:      "entrypoint": "agents/agents/doc-drift-verifier.ts",
agents/registry/validation.json:170:      "id": "doc-drift-analyzer",
agents/registry/validation.json:171:      "entrypoint": "agents/agents/doc-drift-analyzer.ts",
agents/registry/agents.json:571:      "id": "doc-drift-sentinel",
agents/registry/agents.json:575:      "entrypoint": "agents/agents/doc-drift-sentinel.ts",
agents/registry/agents.json:576:      "path": "agents/agents/doc-drift-sentinel.ts",
agents/registry/agents.json:594:        "docs/jobs/YYYY-MM-DD-doc-drift-sentinel.md"
agents/registry/agents.json:599:      "runtime_proof": "bun agents/agents/doc-drift-sentinel.ts --dry",
agents/registry/agents.json:695:      "id": "doc-drift-verifier",
agents/registry/agents.json:697:      "description": "Layer 2 of EGOS Doc-Drift Shield. Verifies .egos-manifest.yaml claims against live state. Called by .husky/doc-drift-check.sh in pre-commit gate.",
agents/registry/agents.json:699:      "entrypoint": "agents/agents/doc-drift-verifier.ts",
agents/registry/agents.json:716:      "runtime_proof": "bun agents/agents/doc-drift-verifier.ts --dry",
agents/registry/agents.json:730:      "id": "doc-drift-analyzer",
agents/registry/agents.json:734:      "entrypoint": "agents/agents/doc-drift-analyzer.ts",
agents/registry/agents.json:754:      "runtime_proof": "bun agents/agents/doc-drift-analyzer.ts --dry",

2026-06-09T14:47:23.256286Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
exec
/bin/bash -lc "sed -n '1,220p' agents/agents/doc-drift-verifier.ts && sed -n '220,420p' agents/agents/doc-drift-verifier.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * doc-drift-verifier.ts — Layer 2 of the EGOS Doc-Drift Shield
 *
 * Reads a `.egos-manifest.yaml`, runs each claim command, compares results
 * against declared tolerances, and outputs a verification report.
 *
 * Usage:
 *   bun agents/agents/doc-drift-verifier.ts --manifest ./.egos-manifest.yaml
 *   bun agents/agents/doc-drift-verifier.ts --repo /home/enio/carteira-livre
 *   bun agents/agents/doc-drift-verifier.ts --all          # scan all known repos
 *   bun agents/agents/doc-drift-verifier.ts --fail-on-drift # exit 1 if any drift
 *   bun agents/agents/doc-drift-verifier.ts --json          # JSON output
 *   bun agents/agents/doc-drift-verifier.ts --markdown      # markdown table
 *
 * Exit codes:
 *   0 — all claims passed
 *   1 — drift detected (only when --fail-on-drift)
 *   2 — command error / manifest not found
 *
 * Part of: docs/DOC_DRIFT_SHIELD.md
 * Schema version: 1.0.0
 */

import { existsSync, mkdirSync, writeFileSync } from "fs";
import { join, dirname } from "path";
import { parse as parseYamlLib } from "yaml";
import { homedir } from "os";

// ─── Types ────────────────────────────────────────────────────────────────────

interface ManifestClaim {
  id: string;
  description: string;
  readme_location?: string;
  command: string;
  tolerance: string; // "exact" | "±N" | "±N%" | "min:N" | "max:N"
  last_value: string;
  last_verified_at?: string;
  category?: string;
}

interface ManifestDomain {
  url: string;
  expected_status: string;
  checked_at?: string;
  note?: string;
}

interface ManifestEndpoint {
  url: string;
  expected_status: string;
  expected_contains?: string;
  checked_at?: string;
  note?: string;
}

interface Manifest {
  schema_version: string;
  repo: string;
  updated_at?: string;
  updated_by?: string;
  manifest_doc?: string;
  claims: ManifestClaim[];
  domains?: ManifestDomain[];
  endpoints?: ManifestEndpoint[];
}

type ClaimStatus = "ok" | "warn" | "drifted" | "error" | "skipped";

interface ClaimResult {
  id: string;
  description?: string;
  status: ClaimStatus;
  last_value: string;
  current_value: string;
  tolerance: string;
  drift_pct?: number;
  drift_abs?: number;
  command: string;
  error?: string;
  severity: "ok" | "warn" | "drift" | "error";
}

interface DomainResult {
  url: string;
  status: "ok" | "drifted" | "error";
  expected_status: string;
  actual_status: string;
  contains_check?: boolean;
  error?: string;
}

interface VerificationReport {
  manifest: string;
  repo: string;
  verified_at: string;
  summary: {
    total_claims: number;
    passed: number;
    warned: number;
    drifted: number;
    errors: number;
    total_domains: number;
    domains_ok: number;
    domains_drifted: number;
  };
  results: ClaimResult[];
  domains: DomainResult[];
  exit_code: number;
}

// ─── Known repos ─────────────────────────────────────────────────────────────

const HOME = homedir();
const KNOWN_REPOS = [
  join(HOME, "egos"),
  join(HOME, "carteira-livre"),
  join(HOME, "br-acc"),
  join(HOME, "egos-lab"),
  join(HOME, "852"),
];

// ─── YAML parser ─────────────────────────────────────────────────────────────

function parseYaml(content: string): unknown {
  return parseYamlLib(content);
}

// ─── (internal stub, kept for reference — not used) ──────────────────────────
// Replaced by `yaml` npm package for correctness with escaped quotes.
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function _minimalYamlParse_UNUSED(content: string): unknown {
  // Remove BOM if present
  content = content.replace(/^\uFEFF/, "");

  const lines = content.split("\n");
  let pos = 0;

  function peek(): string | undefined {
    return lines[pos];
  }

  function isComment(line: string): boolean {
    return line.trimStart().startsWith("#");
  }

  function indentOf(line: string): number {
    return line.length - line.trimStart().length;
  }

  function parseValue(raw: string): unknown {
    const s = raw.trim();
    if (s === "null" || s === "~" || s === "") return null;
    if (s === "true") return true;
    if (s === "false") return false;
    if (/^-?\d+(\.\d+)?$/.test(s)) return Number(s);
    // Quoted string
    if ((s.startsWith('"') && s.endsWith('"')) || (s.startsWith("'") && s.endsWith("'"))) {
      return s.slice(1, -1);
    }
    return s;
  }

  function parseBlock(baseIndent: number): unknown {
    // Determine if it's a sequence or mapping
    while (pos < lines.length && (lines[pos].trim() === "" || isComment(lines[pos]))) pos++;

    if (pos >= lines.length) return null;

    const firstLine = lines[pos];
    const firstIndent = indentOf(firstLine);
    if (firstIndent < baseIndent) return null;

    const trimmed = firstLine.trimStart();

    if (trimmed.startsWith("- ") || trimmed === "-") {
      // Sequence
      const arr: unknown[] = [];
      while (pos < lines.length) {
        const line = lines[pos];
        if (line.trim() === "" || isComment(line)) { pos++; continue; }
        const ind = indentOf(line);
        if (ind < baseIndent) break;
        if (!line.trimStart().startsWith("- ") && line.trimStart() !== "-") break;

        const afterDash = line.trimStart().slice(2);
        pos++;

        if (afterDash.trim() === "" || afterDash.trim() === "") {
          // Block mapping inside sequence
          arr.push(parseBlock(ind + 2));
        } else if (afterDash.includes(": ")) {
          // Inline mapping: `- key: value`
          const obj: Record<string, unknown> = {};
          const [k, ...vParts] = afterDash.split(": ");
          const v = vParts.join(": ");
          obj[k.trim()] = parseValue(v);
          // Continue reading sibling keys at same indent level
          while (pos < lines.length) {
            const next = lines[pos];
            if (next.trim() === "" || isComment(next)) { pos++; continue; }
            if (indentOf(next) <= ind) break;
            const nextTrimmed = next.trimStart();
            if (nextTrimmed.startsWith("- ")) break;
            if (nextTrimmed.endsWith(": |") || nextTrimmed.endsWith(": >")) {
              const [nk] = nextTrimmed.split(": ");
              const blockChar = nextTrimmed.slice(nextTrimmed.lastIndexOf(": ") + 2).trim();
              pos++;
              const blockLines: string[] = [];
              const blockBaseIndent = indentOf(next) + 2;
              while (pos < lines.length) {
                const bl = lines[pos];
                if (bl.trim() === "" && pos + 1 < lines.length && indentOf(lines[pos + 1]) >= blockBaseIndent) {
                  blockLines.push(""); pos++; continue;
                }
                if (bl.trim() === "") { pos++; break; }
                if (indentOf(bl) < blockBaseIndent && bl.trim() !== "") break;
                blockLines.push(bl.slice(blockBaseIndent));
                pos++;
                pos++;
              }
              let blockStr = blockLines.join("\n");
              if (blockChar === "|") {
                // Literal block: keep trailing newline
                blockStr = blockStr.trimEnd() + "\n";
              } else {
                // Folded block: replace newlines with spaces
                blockStr = blockStr.replace(/\n/g, " ").trim();
              }
              obj[nk.trim()] = blockStr;
            } else if (nextTrimmed.includes(": ")) {
              const [nk, ...nv] = nextTrimmed.split(": ");
              obj[nk.trim()] = parseValue(nv.join(": "));
              pos++;
            } else {
              break;
            }
          }
          arr.push(obj);
        } else {
          arr.push(parseValue(afterDash));
        }
      }
      return arr;
    } else {
      // Mapping
      const obj: Record<string, unknown> = {};
      while (pos < lines.length) {
        const line = lines[pos];
        if (line.trim() === "" || isComment(line)) { pos++; continue; }
        const ind = indentOf(line);
        if (ind < baseIndent) break;

        const trimmedLine = line.trimStart();
        if (trimmedLine.startsWith("- ")) break;

        if (!trimmedLine.includes(":")) { pos++; continue; }

        const colonIdx = trimmedLine.indexOf(":");
        const key = trimmedLine.slice(0, colonIdx).trim();
        const rest = trimmedLine.slice(colonIdx + 1).trim();

        pos++;

        if (rest === "|" || rest === ">") {
          // Block scalar
          const blockLines: string[] = [];
          const blockBaseIndent = ind + 2;
          while (pos < lines.length) {
            const bl = lines[pos];
            if (bl.trim() === "" && pos + 1 < lines.length && indentOf(lines[pos + 1]) >= blockBaseIndent) {
              blockLines.push(""); pos++; continue;
            }
            if (bl.trim() === "") { pos++; break; }
            if (indentOf(bl) < blockBaseIndent && bl.trim() !== "") break;
            blockLines.push(bl.slice(blockBaseIndent));
            pos++;
          }
          let blockStr = blockLines.join("\n");
          if (rest === "|") {
            blockStr = blockStr.trimEnd() + "\n";
          } else {
            blockStr = blockStr.replace(/\n/g, " ").trim();
          }
          obj[key] = blockStr;
        } else if (rest === "" || rest === null) {
          // Nested block
          const nested = parseBlock(ind + 2);
          obj[key] = nested;
        } else {
          obj[key] = parseValue(rest);
        }
      }
      return obj;
    }
  }

  return parseBlock(0);
}

// ─── Tolerance evaluation ─────────────────────────────────────────────────────

interface ToleranceResult {
  status: ClaimStatus;
  drift_abs?: number;
  drift_pct?: number;
}

function evaluateTolerance(lastVal: string, currentVal: string, tolerance: string): ToleranceResult {
  const last = parseFloat(lastVal);
  const current = parseFloat(currentVal);

  if (tolerance === "exact") {
    if (lastVal.trim() === currentVal.trim()) return { status: "ok" };
    return { status: "drifted", drift_abs: Math.abs(current - last) };
  }

  if (tolerance.startsWith("min:")) {
    const min = parseFloat(tolerance.slice(4));
    if (current >= min) return { status: "ok" };
    return { status: "drifted", drift_abs: min - current };
  }

  if (tolerance.startsWith("max:")) {
    const max = parseFloat(tolerance.slice(4));
    if (current <= max) return { status: "ok" };
    return { status: "drifted", drift_abs: current - max };
  }

  if (tolerance.endsWith("%")) {
    const pct = parseFloat(tolerance.replace("±", "").replace("%", ""));
    if (isNaN(last) || isNaN(current)) return { status: "error" };
    const diff = Math.abs(current - last);
    const diffPct = last !== 0 ? (diff / last) * 100 : diff > 0 ? 100 : 0;
    if (diffPct <= pct) return { status: "ok", drift_pct: diffPct };
    return { status: "drifted", drift_pct: diffPct };
  }

  if (tolerance.startsWith("±")) {
    const allowedAbs = parseFloat(tolerance.slice(1));
    if (isNaN(last) || isNaN(current)) return { status: "error" };
    const diff = Math.abs(current - last);
    if (diff <= allowedAbs) return { status: "ok", drift_abs: diff };
    return { status: "drifted", drift_abs: diff };
  }

  if (tolerance.startsWith("eq:")) {
    const expected = tolerance.slice(3).trim();
    if (currentVal.trim() === expected) return { status: "ok" };
    return { status: "drifted", drift_abs: Math.abs(current - parseFloat(expected)) };
  }

  // Unknown tolerance format
  return { status: "warn" };
}

// ─── Command executor ─────────────────────────────────────────────────────────

async function runCommand(command: string, cwd: string, timeoutMs = 30_000): Promise<{ output: string; error: string; exitCode: number }> {
  try {
    const proc = Bun.spawn(["bash", "-c", command], {
      cwd,
      stdout: "pipe",
      stderr: "pipe",
    });

    const timeout = setTimeout(() => proc.kill(), timeoutMs);

    const [stdout, stderr] = await Promise.all([
      new Response(proc.stdout).text(),
      new Response(proc.stderr).text(),
    ]);

    await proc.exited;
    clearTimeout(timeout);

    return {
      output: stdout.trim(),
      error: stderr.trim(),
      exitCode: proc.exitCode ?? 0,
    };
  } catch (err) {
    return {
      output: "",
      error: String(err),
      exitCode: 127,
    };
  }
}

// ─── Domain checker ───────────────────────────────────────────────────────────

async function checkDomain(domain: ManifestDomain | ManifestEndpoint): Promise<DomainResult> {
  try {
    const response = await fetch(domain.url, {
      method: "GET",
      redirect: "manual",
      signal: AbortSignal.timeout(10_000),
    });

    const actualStatus = String(response.status);
    const expectedStatus = String(domain.expected_status);
    const statusOk = actualStatus === expectedStatus;

    let containsCheck: boolean | undefined;
    if ("expected_contains" in domain && domain.expected_contains) {
      const body = await response.text().catch(() => "");
      containsCheck = body.includes(domain.expected_contains);
    }

    const ok = statusOk && (containsCheck === undefined || containsCheck);

    return {
      url: domain.url,
      status: ok ? "ok" : "drifted",
      expected_status: expectedStatus,
      actual_status: actualStatus,
      contains_check: containsCheck,
    };
  } catch (err) {

exec
/bin/bash -lc "sed -n '420,560p' agents/agents/doc-drift-verifier.ts" in /home/enio/egos
 succeeded in 0ms:
  } catch (err) {
    return {
      url: domain.url,
      status: "error",
      expected_status: String(domain.expected_status),
      actual_status: "connection_error",
      error: String(err),
    };
  }
}

// ─── Manifest verifier ────────────────────────────────────────────────────────

async function verifyManifest(manifestPath: string, opts: { failOnDrift: boolean }): Promise<VerificationReport> {
  const repoDir = dirname(manifestPath);

  let content: string;
  try {
    content = await Bun.file(manifestPath).text();
  } catch {
    console.error(`[doc-drift] ERROR: Cannot read manifest: ${manifestPath}`);
    process.exit(2);
  }

  const manifest = parseYaml(content) as Manifest;

  if (!manifest || typeof manifest !== "object") {
    console.error(`[doc-drift] ERROR: Invalid manifest YAML: ${manifestPath}`);
    process.exit(2);
  }

  const claims: ManifestClaim[] = manifest.claims ?? [];
  const domains: (ManifestDomain | ManifestEndpoint)[] = [
    ...(manifest.domains ?? []),
    ...(manifest.endpoints ?? []),
  ];

  const results: ClaimResult[] = [];
  const domainResults: DomainResult[] = [];

  // ── Run claim commands ──
  console.error(`\n[doc-drift] Verifying ${claims.length} claims in ${manifest.repo ?? "?"} ...`);

  for (const claim of claims) {
    const { output, error, exitCode } = await runCommand(claim.command, repoDir);

    if (exitCode !== 0 || output === "") {
      results.push({
        id: claim.id,
        description: claim.description,
        status: "error",
        last_value: claim.last_value,
        current_value: "",
        tolerance: claim.tolerance,
        command: claim.command,
        error: error || `exit code ${exitCode}`,
        severity: "error",
      });
      console.error(`  [error] ${claim.id}: command failed — ${error.slice(0, 80)}`);
      continue;
    }

    const currentValue = output.trim();
    const tolResult = evaluateTolerance(claim.last_value, currentValue, claim.tolerance);

    const severity =
      tolResult.status === "ok" ? "ok"
      : tolResult.status === "warn" ? "warn"
      : tolResult.status === "drifted" ? "drift"
      : "error";

    const icon =
      tolResult.status === "ok" ? "✅"
      : tolResult.status === "warn" ? "⚠️"
      : tolResult.status === "drifted" ? "❌"
      : "💥";

    console.error(
      `  ${icon} ${claim.id}: ${claim.last_value} → ${currentValue}` +
      (tolResult.drift_abs !== undefined ? ` (Δ${tolResult.drift_abs})` : "") +
      (tolResult.drift_pct !== undefined ? ` (${tolResult.drift_pct.toFixed(1)}%)` : "")
    );

    results.push({
      id: claim.id,
      description: claim.description,
      status: tolResult.status,
      last_value: claim.last_value,
      current_value: currentValue,
      tolerance: claim.tolerance,
      drift_abs: tolResult.drift_abs,
      drift_pct: tolResult.drift_pct !== undefined ? parseFloat(tolResult.drift_pct.toFixed(2)) : undefined,
      command: claim.command,
      severity,
    });
  }

  // ── Check domains ──
  if (domains.length > 0) {
    console.error(`\n[doc-drift] Checking ${domains.length} domain(s) ...`);
    for (const domain of domains) {
      const result = await checkDomain(domain);
      const icon = result.status === "ok" ? "✅" : result.status === "drifted" ? "❌" : "💥";
      console.error(`  ${icon} ${domain.url} → ${result.actual_status} (expected ${result.expected_status})`);
      domainResults.push(result);
    }
  }

  // ── Summarize ──
  const passed = results.filter((r) => r.status === "ok").length;
  const warned = results.filter((r) => r.status === "warn").length;
  const drifted = results.filter((r) => r.status === "drifted").length;
  const errors = results.filter((r) => r.status === "error").length;
  const domainsOk = domainResults.filter((d) => d.status === "ok").length;
  const domainsDrifted = domainResults.filter((d) => d.status !== "ok").length;

  const exitCode = drifted > 0 && opts.failOnDrift ? 1 : errors > 0 ? 2 : 0;

  return {
    manifest: manifestPath,
    repo: manifest.repo ?? "unknown",
    verified_at: new Date().toISOString(),
    summary: {
      total_claims: claims.length,
      passed,
      warned,
      drifted,
      errors,
      total_domains: domainResults.length,
      domains_ok: domainsOk,
      domains_drifted: domainsDrifted,
    },
    results,
    domains: domainResults,
    exit_code: exitCode,
  };
}

// ─── Output formatters ────────────────────────────────────────────────────────

function formatMarkdown(report: VerificationReport): string {

exec
/bin/bash -lc 'grep -n "completed_tasks_total" -A8 -B2 .egos-manifest.yaml' in /home/enio/egos
 succeeded in 0ms:
86-    category: "custom"
87-
88:  - id: completed_tasks_total
89-    description: "Total completed tasks in TASKS.md"
90-    readme_location: "TASKS.md"
91-    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
92-    tolerance: "min:0"
93-    last_value: "0"
94-    last_verified_at: "2026-06-08"
95-    category: "custom"
96-    note: "TASKS.md agressivamente arquivado (TASKS-SLIM-001). Completed tasks movidos para TASKS_ARCHIVE.md. Tolerância mínima = 1 (apenas task corrente do sprint ativo)."

exec
/bin/bash -lc 'git diff --check 3d0f899f36ac9fc07105eaaa7dfc551838361c97' in /home/enio/egos
 exited 2 in 0ms:
docs/drafts/conselho.md:94: trailing whitespace.
+- **c) Ferramentas para as lacunas específicas**:  
docs/drafts/conselho.md:106: trailing whitespace.
+- descer para o nível de **roadmap técnico** (por exemplo: esquema RLS concreto + pontos de hook no EGOS/Hermes e fluxo do pagamento WhatsApp), ou  

codex
The patch introduces sensitive personal context into versioned docs and an external-use prompt that exposes concrete production security gaps. These are security/privacy issues that should be redacted before the change is considered correct.

Full review comments:

- [P1] Remove protected third-party health context — /home/enio/egos/docs/personal-os/ENIO_UNDERSTANDING_MAP.md:42-42
  When this repo is pushed or shared, this line versions sensitive third-party context (`colega policial + alcoolismo + psilocibina`) even though the same sentence marks it as RED ZONE and never public. Because git history preserves it and the project rules forbid real third-party sensitive data in git, this should be redacted to a non-identifying pattern before commit.

- [P2] Redact production security gaps from external prompt — /home/enio/egos/docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md:101-107
  Because this file is explicitly intended to be pasted into external LLMs, listing exact production gaps such as WhatsApp PII not being wired at runtime and tenant isolation relying on app filters discloses actionable security weaknesses outside the trusted boundary. Keep the research prompt useful by generalizing these as categories instead of exposing current control failures.
The patch introduces sensitive personal context into versioned docs and an external-use prompt that exposes concrete production security gaps. These are security/privacy issues that should be redacted before the change is considered correct.

Full review comments:

- [P1] Remove protected third-party health context — /home/enio/egos/docs/personal-os/ENIO_UNDERSTANDING_MAP.md:42-42
  When this repo is pushed or shared, this line versions sensitive third-party context (`colega policial + alcoolismo + psilocibina`) even though the same sentence marks it as RED ZONE and never public. Because git history preserves it and the project rules forbid real third-party sensitive data in git, this should be redacted to a non-identifying pattern before commit.

- [P2] Redact production security gaps from external prompt — /home/enio/egos/docs/drafts/META_PROMPT_processo_arquiteto_diagnosticador.md:101-107
  Because this file is explicitly intended to be pasted into external LLMs, listing exact production gaps such as WhatsApp PII not being wired at runtime and tenant isolation relying on app filters discloses actionable security weaknesses outside the trusted boundary. Keep the research prompt useful by generalizing these as categories instead of exposing current control failures.
```
