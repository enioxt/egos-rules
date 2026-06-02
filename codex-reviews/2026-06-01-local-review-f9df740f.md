# Codex Local Review — 2026-06-01T11:01:56Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.3-codex
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019e82d8-f232-7da3-aa79-d1be1dc848e5
--------
user
changes against 'HEAD~3'
exec
/bin/bash -lc 'git diff e639ee8fc19ac4a05e725f6d009335217694eaf1' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 7eeb466e..deb2ae33 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -170,6 +170,11 @@
 - [/] **ARTICLE-002** [P1] `redzone` — Escrever artigo #2 no tom investigador-arquiteto: explicar+mostrar+validar EGOS. Evidence-first (citar só o que existe no repo). HITL antes de publicar. (Sonnet redigindo draft; Opus revisa Red Zone.)
 - [ ] **ARTICLE-MULTIMEDIA-001** [P1] — Multimídia do artigo via NotebookLM MCP (integração já existe): slides (assinatura visual obrigatória — VISUAL_IDENTITY.md), vídeo, áudio, imagens. HITL para deleção/publicação (NotebookLM §4). Pensar imagens junto do texto.
 
+## 📊 CAREER-GAP — Capacidade em % vs topo do mercado (evidência > credencial) — Enio 2026-06-01
+
+> Tese: pular cursos/certificados e PROVAR capacidade com número, código, arquitetura, testes, health, uptime. Mirar o MELHOR currículo (topo), depois descer tiers. Liga a CURRICULUM-001 + CAREER_FIT_STUDY §2. Red Zone (posicionamento) → corte do Enio.
+- [/] **CAREER-GAP-001** [P1] `redzone` `research` — Matriz % de cobertura de capacidade vs requisitos do role top (F1: forense on-chain + arquitetura/segurança IA): cada requisito → % coberto → evidência real (artefato/número do repo) → se exige cert, provar que evidência substitui. + overall % por tier + tese credential-skip evidenciada + gaps honestos (ex: uptime não medido → construir status page público). (Sonnet pesquisando; Opus sintetiza/corta.)
+
 ---
 
 ## 🔍 SEO ENGINE (Gabi) — 2026-05-29 (Frente B / consultoria)
diff --git a/docs/drafts/ARTICLE_investigador-arquiteto_DRAFT.md b/docs/drafts/ARTICLE_investigador-arquiteto_DRAFT.md
new file mode 100644
index 00000000..c55f9eb3
--- /dev/null
+++ b/docs/drafts/ARTICLE_investigador-arquiteto_DRAFT.md
@@ -0,0 +1,99 @@
+<!-- ⚠️ BLOQUEADOR PRÉ-PUBLICAÇÃO (Prime 2026-06-01):
+     Este draft (Sonnet) cita 5 arquivos como "clone e verifique": .guarani/RULES_INDEX.md,
+     .husky/pre-commit, packages/guard-brasil/src/pii-patterns.ts, agents/registry/agents.json,
+     docs/governance/RESOLVER_DOCTRINE.md — TODOS estão no repo PRIVADO (enioxt/egos), NÃO no
+     público (enioxt/egos-governance). Os links dariam 404 e quebrariam o argumento de confiança.
+     ANTES DE PUBLICAR (decisão Red Zone do Enio):
+       (A) re-ancorar as citações no que É público: README/STRATEGY/VOCABULARY.md, docs/{standards,
+           patterns,practices,incidents}, packages/{mcp-governance,mcp-eval-runner,mcp-skills-registry},
+           .gitleaks.toml + .trufflehog.yaml (prova de scan de secrets), starter/; OU
+       (B) tornar públicos os arquivos citados (exige security review — corte do Enio).
+     Trocar TODA ocorrência de github.com/enioxt/egos → github.com/enioxt/egos-governance.
+     Status: draft-v1, tom aprovado em conceito, pendente re-ancoragem + corte final. Task ARTICLE-002.
+-->
+
+# DRAFT v1 — Artigo "investigador-arquiteto" (PT-BR)
+
+## Frontmatter (sugerido)
+
+```yaml
+title: "16 anos investigando crimes. Então descobri que a IA que eu mesmo construí precisava ser investigada."
+slug: "investigando-a-ia-que-construi"
+author: "Enio Rocha"
+status: draft
+version: draft-v1
+created: 2026-06-01
+publish_target: egos.ia.br/timeline
+estimated_read_min: 7
+epistemic_status: seedling
+tags: ["governance", "evidence-first", "karpathy-principles", "agent-architecture", "open-source"]
+```
+
+---
+
+**TL;DR:** Passei 16 anos construindo cadeias de evidência que precisam sobreviver a escrutínio judicial. Quando comecei a construir sistemas de IA, percebi que o mesmo problema aparece de outro lado: como você prova que um agente fez o que deveria — e não fez o que não deveria? EGOS é minha tentativa de responder isso com código verificável, não com promessa.
+
+### O arquivo que ninguém pergunta para ler
+
+Quando alguém contrata um sistema de IA para atender clientes, analisar dados, ou automatizar decisões, raramente a primeira pergunta é: "posso ver o que está escrito nos prompts?" Raramente a segunda também.
+
+Existe uma presunção de caixa preta que virou padrão na indústria. O sistema funciona (mais ou menos), a taxa de acerto parece razoável, e os detalhes ou são propriedade protegida ou simplesmente não documentados.
+
+Trabalhei 16 anos na investigação criminal (PCMG, em atividade). Ali a presunção inversa é absoluta: toda evidência precisa de cadeia de custódia. Cada decisão precisa ser rastreável. Diante de um juiz, a pergunta não é "você confia nesse resultado?" — é "me mostre como chegou aqui, passo a passo, e eu decido."
+
+Quando comecei a construir sistemas de IA, essa dissonância me incomodou. Eu usava ferramentas que tomavam decisões sobre dados, e nenhuma me dizia exatamente como. Então comecei a construir o EGOS do jeito que eu construiria uma investigação: tudo documentado, versionado, verificável.
+
+### O que é o EGOS — sem o jargão
+
+Não é um framework de LLM, nem um wrapper de API. É um kernel de orquestração para agentes de IA com governança desde o zero: o conjunto de regras, verificações e estruturas que determinam *como* os agentes operam — o que podem acessar, o que precisam registrar, o que está bloqueado, e o que acontece quando algo dá errado.
+
+A constituição do sistema vive em arquivos de texto que qualquer pessoa pode ler. Não é documentação depois do fato — é o que o agente (e eu) lemos antes de qualquer trabalho. O pre-commit aplica verificações antes de qualquer código entrar no repositório: scan de secrets, TypeScript estrito, bloqueio de proliferação de docs, verificação de drift entre o que a doc afirma e o que o código faz.
+
+Nada disso garante que o sistema nunca vai errar. Garante que, quando errar, existe um rastro de decisões auditável.
+
+### Guard Brasil: o mesmo problema com PII
+
+Nasceu de uma pergunta concreta: se processo texto de usuários brasileiros num chatbot, o que acontece com os dados pessoais nas mensagens? CPF, CNPJ, RG, CNH, placa, telefone, email — e também padrões de infraestrutura: tokens AWS, GitHub, chaves Stripe, strings de conexão.
+
+O resultado é um detector em TypeScript, código aberto. A lógica é legível: o padrão de CPF é um regex documentado com testes; o de placa tem comentário explicando um falso positivo achado em produção. O oposto de uma caixa preta — você lê, entende os tradeoffs, e discorda se achar errado.
+
+### A Resolver Doctrine: quando o agente acha um problema no meio do trabalho
+
+Um padrão que custou tempo pra formular: o que o orquestrador faz ao encontrar um problema no meio de outro trabalho? Parar tudo costuma ser errado; ignorar também. A doutrina formalizou isso como triagem: `Leverage = Impact × StrategicFit × Urgency`, `Custo = Effort × ContextSwitch`, `R = L/C`. Se R é alto e barato → resolve agora. Se não → vira task com prioridade. Se é Red Zone (copy pública, pricing, segurança, contexto policial) → nunca auto-resolve, para e apresenta opções pra decisão humana. Não é mágica: é heurística documentada que evita os dois extremos disfuncionais.
+
+### Prompts abertos: o argumento de confiança que ainda não terminou
+
+A maioria dos sistemas que você usa tem prompts proprietários que você nunca vai ver. No EGOS os prompts estão no repositório. Isso não garante que o sistema nunca se comporte de forma inesperada — é uma afirmação mais modesta e mais verificável: *o comportamento especificado está visível, e você pode checar se a implementação é consistente com a especificação.*
+
+A direção de longo prazo é mais ambiciosa: formular comportamento de agente como invariantes verificáveis — propriedades checáveis formalmente, não apenas lidas e confiadas. Ainda não chegamos lá. É pesquisa em andamento, não uma feature de hoje. Mas a aposta é que transparência estrutural como alicerce de confiança — não como marketing — é a única que escala quando agentes autônomos tomam decisões com consequências reais.
+
+### Por que isso importa para quem usa Claude Code ou Windsurf
+
+Se você usa Claude Code ou Windsurf no dia a dia, já tem intuição do que é um bom sistema de IA: explica o que faz, não engole erros em silêncio, tem comportamento previsível. O EGOS tenta aplicar isso em escala — não para uma ferramenta, mas para um ecossistema de agentes com objetivos, dependências e efeitos colaterais. Nada disso é perfeito. Tudo é verificável.
+
+### O que não funcionou (e ainda não funciona)
+
+- A cobertura de testes não é o que deveria. O pre-commit bloqueia muito, não tudo.
+- O drift entre documentação e código é problema constante. O Doc-Drift Shield mitiga, não elimina.
+- Prova formal de comportamento ainda é pesquisa. "Auditável" hoje = "você pode ler e conferir manualmente."
+- Complexidade tem custo. Há momentos onde governança parece burocracia; o equilíbrio ainda está sendo calibrado.
+
+### Próximas perguntas
+
+- É possível formular comportamento de agente como invariantes verificáveis, sem leitura manual?
+- Como a governança muda quando o agente passa de "auxilia decisões humanas" para "decide autonomamente com efeitos irreversíveis"?
+- O que separa um pre-commit que aumenta qualidade de um que os devs aprendem a contornar?
+
+---
+*Construindo em público. (Links de repo + chamada final pendentes de re-ancoragem — ver bloqueador no topo.)*
+
+---
+
+## Edições propostas pras regras (ARTICLE_VOICE.md / ARTICLE_TEMPLATE.md) — ARTICLE-RULES-001
+
+(Resumo; aplicar após corte do Enio.)
+1. **VOICE §1.0 novo — Dual audience:** expert (Claude Code/Windsurf, quer código+evidência) + curioso (quer o "por quê" antes do "como"). Regra: toda seção técnica = 1 parágrafo de contexto legível + 1 bloco reproduzível.
+2. **VOICE §1.1 +2 marcas:** (7) abertura "investigador chegando à cena", não manual; (8) auditabilidade como argumento de confiança, não feature.
+3. **VOICE §1.2 +2 anti-marcas:** sem framing perito-for-hire (usar IP/magistério/advisory); sem número sem fonte (`[VERIFY]` no draft).
+4. **VOICE §1.4 novo — Trust framing:** "você não precisa confiar em nós, pode conferir"; prova matemática = direção de pesquisa, nunca garantia concluída.
+5. **TEMPLATE:** bloco "Abertura de investigação" + seção "Por que confiar nesta afirmação" (claim → arquivo público → comando de verificação) + 4 itens de checklist.
diff --git a/docs/gem-hunter/auto-queue.json b/docs/gem-hunter/auto-queue.json
index 1acfc4a3..e4a6df7b 100644
--- a/docs/gem-hunter/auto-queue.json
+++ b/docs/gem-hunter/auto-queue.json
@@ -1,6 +1,16 @@
 {
   "version": "1.0.0",
   "queue": [
+    {
+      "name": "logseq/logseq",
+      "url": "https://github.com/logseq/logseq",
+      "score": 100,
+      "category": "early-warning",
+      "structureBonus": 12,
+      "discoveredAt": "2026-06-01T10:59:36.654Z",
+      "status": "queued",
+      "branchSuggestion": "gem/adopt-logseq-logseq-2026-06-01"
+    },
     {
       "name": "mizcausevic-dev/mcp-sentinel",
       "url": "https://github.com/mizcausevic-dev/mcp-sentinel",
diff --git a/docs/gem-hunter/gems-2026-06-01.md b/docs/gem-hunter/gems-2026-06-01.md
new file mode 100644
index 00000000..51e678fb
--- /dev/null
+++ b/docs/gem-hunter/gems-2026-06-01.md
@@ -0,0 +1,274 @@
+# Gem Hunter Report — 2026-06-01
+
+> Auto-generated by AGENT-027 Gem Hunter v6.1
+> Sources: GitHub + HuggingFace Models + HF Spaces + Exa + arXiv + HackerNews + NPM + Zenodo + X API + X Public + Reddit + StackOverflow + ProductHunt + GitHub Code
+> Total gems: 173
+
+---
+
+## 🧠 AI Executive Synthesis
+
+> AI synthesis failed or timed out.
+
+---
+
+## Early Warning — Researcher Launches (Day 0)
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [logseq/logseq](https://github.com/logseq/logseq) | github | 43172 | 100 | 📋 Create Task | A privacy-first, open-source platform for knowledge management and collaboration. Download link:  http://github.com/logs |
+| 2 | [release-it/release-it](https://github.com/release-it/release-it) | github | 8966 | 100 | 📋 Create Task | 🚀 Automate versioning and package publishing |
+| 3 | [softprops/action-gh-release](https://github.com/softprops/action-gh-release) | github | 5648 | 100 | 📋 Create Task | 📦 :octocat: GitHub Action for creating GitHub Releases |
+| 4 | [json-c/json-c](https://github.com/json-c/json-c) | github | 3273 | 100 | 📋 Create Task | https://github.com/json-c/json-c is the official code repository for json-c.  See the wiki for release tarballs for down |
+| 5 | [garrytan/gstack](https://github.com/garrytan/gstack) | github | 105367 | 100 | 📋 Create Task | Use Garry Tan's exact Claude Code setup: 23 opinionated tools that serve as CEO, Designer, Eng Manager, Release Manager, |
+| 6 | [lm-sys/FastChat](https://github.com/lm-sys/FastChat) | github | 39481 | 100 | 📋 Create Task | An open platform for training, serving, and evaluating large language models. Release repo for Vicuna and Chatbot Arena. |
+| 7 | [semantic-release/semantic-release](https://github.com/semantic-release/semantic-release) | github | 23732 | 100 | 📋 Create Task | :package::rocket: Fully automated version management and package publishing |
+| 8 | [VoltAgent/awesome-ai-agent-papers](https://github.com/VoltAgent/awesome-ai-agent-papers) | github | 1068 | 100 | 📋 Create Task | A curated collection of AI agent research papers released in 2026, covering agent engineering, memory, evaluation, workf |
+| 9 | [docmirror/dev-sidecar](https://github.com/docmirror/dev-sidecar) | github | 22516 | 99 | 📋 Create Task | 开发者边车，github打不开，github加速，git clone加速，git release下载加速，stackoverflow加速 |
+| 10 | [OpenHub-Store/GitHub-Store](https://github.com/OpenHub-Store/GitHub-Store) | github | 14248 | 99 | 📋 Create Task | 🩵 A free, open-source app store for GitHub releases — browse, discover, and install apps with one click. Powered by Kot |
+| 11 | [VSCodium/vscodium](https://github.com/VSCodium/vscodium) | github | 31685 | 99 | 📋 Create Task | binary releases of VS Code without MS branding/telemetry/licensing |
+| 12 | [rofl0r/proxychains-ng](https://github.com/rofl0r/proxychains-ng) | github | 10612 | 98 | 📋 Create Task | proxychains ng (new generation) - a preloader which hooks calls to sockets in dynamically linked programs and redirects  |
+| 13 | [onestardao/WFGY](https://github.com/onestardao/WFGY) | github | 1752 | 98 | 📋 Create Task | WFGY is heading toward WFGY 5.0 Polaris Protocol, a major open-source release for AI reasoning, RAG, agents, and real-wo |
+| 14 | [testsigmahq/testsigma](https://github.com/testsigmahq/testsigma) | github | 1194 | 86 | 📋 Create Task | Testsigma is an agentic test automation platform powered by AI-coworkers that work alongside QA teams to simplify testin |
+| 15 | [PicoTrex/Awesome-Nano-Banana-images](https://github.com/PicoTrex/Awesome-Nano-Banana-images) | github | 22923 | 84 | 📋 Create Task | A curated collection of fun and creative examples generated with Nano Banana & Nano Banana Pro🍌, Gemini-2.5-flash-image |
+| 16 | [datawhalechina/leedl-tutorial](https://github.com/datawhalechina/leedl-tutorial) | github | 16596 | 75 | 📋 Create Task | 《李宏毅深度学习教程》（李宏毅老师推荐👍，苹果书🍎），PDF下载地址：https://github.com/datawhalechina/leedl-tutorial/releases |
+| 17 | [hunshcn/gh-proxy](https://github.com/hunshcn/gh-proxy) | github | 8786 | 75 | 📋 Create Task | github release、archive以及项目文件的加速项目 |
+| 18 | [xai-org/grok-1](https://github.com/xai-org/grok-1) | github | 51690 | 75 | 📋 Create Task | Grok open release |
+| 19 | [alibaba/fastjson](https://github.com/alibaba/fastjson) | github | 25642 | 75 | 📋 Create Task | FASTJSON 2.0.x has been released, faster and more secure, recommend you upgrade. |
+| 20 | [gege-circle/.github](https://github.com/gege-circle/.github) | github | 1900 | 75 | 📋 Create Task | 这里是GitHub的草场，也是戈戈圈爱好者的交流地，主要讨论动漫、游戏、科技、人文、生活等所有话题，欢迎各位小伙伴们在此讨论趣事。This is GitHub grassland, and the community place for G |
+| 21 | [AgriciDaniel/claude-blog](https://github.com/AgriciDaniel/claude-blog) | github | 922 | 67 | 📋 Create Task | Claude Code blog skill suite: 30 sub-skills, 5 agents, 5-gate v1.9.0 Blog Delivery Contract, dual-optimized for Google r |
+| 22 | [NVlabs/sage](https://github.com/NVlabs/sage) | github | 308 | 58 | 📝 Document | Official Code Release of SAGE: Scalable Agentic 3D Scene Generation for Embodied AI |
+
+---
+
+## Strategic MCP Servers / Governance
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [@playwright/mcp](https://www.npmjs.com/package/@playwright/mcp) | npm | — | 95 | 📋 Create Task | Playwright Tools for MCP |
+| 2 | [@mcp-ui/client](https://www.npmjs.com/package/@mcp-ui/client) | npm | — | 85 | 📋 Create Task | mcp-ui Client SDK |
+| 3 | [mcp-proxy](https://www.npmjs.com/package/mcp-proxy) | npm | — | 85 | 📋 Create Task | A TypeScript SSE proxy for MCP servers that use stdio transport. |
+| 4 | [@maintainabilityai/redqueen-mcp](https://www.npmjs.com/package/@maintainabilityai/redqueen-mcp) | npm | — | 85 | 📋 Create Task | Red Queen Governance MCP Server — AI coding agent governance via CALM architecture |
+| 5 | [@modelcontextprotocol/sdk](https://www.npmjs.com/package/@modelcontextprotocol/sdk) | npm | — | 79 | 📋 Create Task | Model Context Protocol implementation for TypeScript |
+| 6 | [@modelcontextprotocol/inspector](https://www.npmjs.com/package/@modelcontextprotocol/inspector) | npm | — | 79 | 📋 Create Task | Model Context Protocol inspector |
+| 7 | [Show HN: Forge – 3MB Rust binary that coordinates multi-AI coding agents via MCP](https://github.com/nxtg-ai/forge-orchestrator) | hackernews | 1 | 78 | 📋 Create Task | HN score: 1 \| Comments: 1 |
+| 8 | [Show HN: Bring enterprise-grade governance (AuthN/Z, Audit) to MCP (Open Source)](https://github.com/ithena-one/mcp-governance-sdk) | hackernews | 2 | 75 | 📋 Create Task | HN score: 2 \| Comments: 0 |
+| 9 | [@mcp-ui/server](https://www.npmjs.com/package/@mcp-ui/server) | npm | — | 75 | 📋 Create Task | mcp-ui Server SDK |
+| 10 | [jagmarques/asqav-mcp](https://github.com/jagmarques/asqav-mcp) | github | 5 | 72 | 📋 Create Task | MCP server for AI agent governance - quantum-safe audit trails, policy enforcement, threat detection. Works with Claude  |
+| 11 | [@pulumi/compliance-policy-manager](https://www.npmjs.com/package/@pulumi/compliance-policy-manager) | npm | — | 71 | 📋 Create Task | This repository contains a growing set of Compliance Policies to validate your infrastructure using Pulumi's Crossguard  |
+| 12 | [@pulumi/aws-compliance-policies](https://www.npmjs.com/package/@pulumi/aws-compliance-policies) | npm | — | 71 | 📋 Create Task | This repository contains a growing set of Compliance Policies to validate your infrastructure using Pulumi's Crossguard  |
+| 13 | [@open-policy-agent/opa-wasm](https://www.npmjs.com/package/@open-policy-agent/opa-wasm) | npm | — | 71 | 📋 Create Task | Open Policy Agent WebAssembly SDK |
+| 14 | [@pulumi/compliance-policies-unit-test-helpers](https://www.npmjs.com/package/@pulumi/compliance-policies-unit-test-helpers) | npm | — | 71 | 📋 Create Task | This repository contains a growing set of Compliance Policies to validate your infrastructure using Pulumi's Crossguard  |
+| 15 | [mizcausevic-dev/mcp-sentinel](https://github.com/mizcausevic-dev/mcp-sentinel) | github | 0 | 67 | 📋 Create Task | Observability, security audit, and governance layer for Model Context Protocol (MCP) servers. Validates registrations, s |
+| 16 | [Ask HN: Separating Foundational Models and Governance Layers](https://news.ycombinator.com/item?id=42914867) | hackernews | 1 | 62 | 📋 Create Task | HN score: 1 \| Comments: 0 |
+| 17 | [Show HN: I built an MCP server to connect AI agents to your DWH](https://news.ycombinator.com/item?id=46060191) | hackernews | 1 | 62 | 📋 Create Task | HN score: 1 \| Comments: 1 |
+| 18 | [Show HN: Orloj – agent infrastructure as code (YAML and GitOps)](https://github.com/OrlojHQ/orloj) | hackernews | 20 | 60 | 📋 Create Task | HN score: 20 \| Comments: 12 |
+| 19 | [crazyrabbitLTC/mpc-tally-api-server](https://github.com/crazyrabbitLTC/mpc-tally-api-server) | github | 7 | 58 | 📝 Document | A Model Context Protocol (MCP) server that enables AI agents to interact with the Tally API, providing access to DAO gov |
+| 20 | [docs/getting-started.md at main · ithena-one/mcp-governance-sdk](https://github.com/ithena-one/mcp-governance-sdk/blob/main/docs/getting-started.md) | exa | — | 58 | 📝 Document | docs/getting-started.md at main · ithena-one/mcp-governance-sdk |
+| 21 | [server | MCP TypeScript SDK](https://ts.sdk.modelcontextprotocol.io/documents/server.html) | exa | — | 58 | 📝 Document | server \| MCP TypeScript SDK |
+| 22 | [The official TypeScript SDK for Model Context Protocol ... - GitHub](https://github.com/modelcontextprotocol/typescript-sdk) | exa | — | 58 | 📝 Document | The official TypeScript SDK for Model Context Protocol ... - GitHub |
+| 23 | [Server | MCP TypeScript SDK](https://ts.sdk.modelcontextprotocol.io/classes/server.Server.html) | exa | — | 58 | 📝 Document | Server \| MCP TypeScript SDK |
+| 24 | [GlassTape/agent-policy-builder-mcp](https://github.com/glasstape/agent-policy-builder-mcp) | exa | — | 58 | 📝 Document | GlassTape/agent-policy-builder-mcp |
+| 25 | [techdeveloper-org/mcp-policy-enforcement](https://github.com/techdeveloper-org/mcp-policy-enforcement) | exa | — | 58 | 📝 Document | techdeveloper-org/mcp-policy-enforcement |
+| 26 | [Ansvar-Systems/Open-source-license-mcp](https://github.com/Ansvar-Systems/Open-source-license-mcp) | exa | — | 58 | 📝 Document | Ansvar-Systems/Open-source-license-mcp |
+| 27 | [williamzujkowski/mcp-standards-server](https://github.com/williamzujkowski/mcp-standards-server) | exa | — | 58 | 📝 Document | williamzujkowski/mcp-standards-server |
+| 28 | [CSOAI-ORG/eu-ai-act-compliance-mcp](https://github.com/csoai-org/eu-ai-act-compliance-mcp) | exa | — | 58 | 📝 Document | CSOAI-ORG/eu-ai-act-compliance-mcp |
+| 29 | [techwithhuz/mcp-security-governance](https://github.com/techwithhuz/mcp-security-governance) | exa | — | 58 | 📝 Document | techwithhuz/mcp-security-governance |
+| 30 | [Samrajtheailyceum/ai-governance-mcp](https://github.com/Samrajtheailyceum/ai-governance-mcp) | exa | — | 58 | 📝 Document | Samrajtheailyceum/ai-governance-mcp |
+| 31 | [jason21wc/ai-governance-mcp](https://github.com/jason21wc/ai-governance-mcp) | exa | — | 58 | 📝 Document | jason21wc/ai-governance-mcp |
+| 32 | [BicameralAI/bicameral-mcp](https://github.com/BicameralAI/bicameral-mcp) | exa | — | 58 | 📝 Document | BicameralAI/bicameral-mcp |
+| 33 | [@asamuzakjp/dom-selector](https://www.npmjs.com/package/@asamuzakjp/dom-selector) | npm | — | 57 | 📝 Document | A CSS selector engine. |
+| 34 | [firebase-tools](https://www.npmjs.com/package/firebase-tools) | npm | — | 57 | 📝 Document | Command-Line Interface for Firebase |
+| 35 | [Show HN: Cq – Stack Overflow for AI coding agents](https://blog.mozilla.ai/cq-stack-overflow-for-agents/) | hackernews | 225 | 54 | 📝 Document | HN score: 225 \| Comments: 103 |
+| 36 | [@apollo/protobufjs](https://www.npmjs.com/package/@apollo/protobufjs) | npm | — | 51 | 📝 Document | Protocol Buffers for JavaScript (& TypeScript). |
+| 37 | [unstructured-client](https://www.npmjs.com/package/unstructured-client) | npm | — | 47 | 📝 Document | <h3 align="center">   <img     src="https://raw.githubusercontent.com/Unstructured-IO/unstructured/main/img/unstructured |
+| 38 | [MCP governance strategy - AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/mcp-strategies/mcp-governance-strategy.html) | exa | — | 42 | 🔍 Evaluate | MCP governance strategy - AWS Prescriptive Guidance |
+| 39 | [api-evangelist/cycloid](https://github.com/api-evangelist/cycloid) | github | 0 | 39 | 🔍 Evaluate | Cycloid is a unified Internal Developer Portal & Platform combining self-service Service Catalogs (Stacks and StackForms |
+| 40 | [Kong-Grajesh-SE/bring-your-own-agent](https://github.com/Kong-Grajesh-SE/bring-your-own-agent) | github | 0 | 39 | 🔍 Evaluate | This bootcamp teaches partners how to use **Kong AI Gateway** as a universal control plane for AI agents — without chang |
+| 41 | [Show HN: I built an open-source Rust/TS AI agent runtime with a Next.js-style DX](https://docs.trysoma.ai) | hackernews | 5 | 37 | 🔍 Evaluate | HN score: 5 \| Comments: 0 |
+| 42 | [DDSE Foundation Announces Agentic Contract Model (ACM) Framework v0.5.0](https://news.ycombinator.com/item?id=45543919) | hackernews | 1 | 34 | 🔍 Evaluate | HN score: 1 \| Comments: 0 |
+| 43 | [docs/server.md at HEAD · modelcontextprotocol/typescript-sdk](https://github.com/modelcontextprotocol/typescript-sdk/blob/HEAD/docs/server.md) | exa | — | 30 | 🔍 Evaluate | docs/server.md at HEAD · modelcontextprotocol/typescript-sdk |
+
+---
+
+## A2A Agent Cards / Interoperability
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [Show HN: Mingle – find and connect with people, like LinkedIn but in your chat](https://github.com/aeoess/mingle-mcp) | hackernews | 1 | 82 | 📋 Create Task | HN score: 1 \| Comments: 0 |
+| 2 | [Show HN: A2A Protocol – Infrastructure for an Agent-to-Agent Economy](https://news.ycombinator.com/item?id=46932327) | hackernews | 4 | 68 | 📋 Create Task | HN score: 4 \| Comments: 2 |
+| 3 | [mizcausevic-dev/agent-card-fleet-summary](https://github.com/mizcausevic-dev/agent-card-fleet-summary) | github | 0 | 67 | 📋 Create Task | Fleet-analyze a directory of A2A AgentCard documents. Counts by autonomy_level / memory_persistence, flags autonomous-wi |
+| 4 | [mizcausevic-dev/agent-card-tool-coverage](https://github.com/mizcausevic-dev/agent-card-tool-coverage) | github | 0 | 67 | 📋 Create Task | Conformance check between an A2A AgentCard's declared tools and an MCP server's tools/list. Reports missing (declared bu |
+| 5 | [mizcausevic-dev/agent-card-diff](https://github.com/mizcausevic-dev/agent-card-diff) | github | 0 | 67 | 📋 Create Task | Diff two A2A AgentCard documents — classify changes (autonomy escalation, memory escalation, tool/model removal, inciden |
+| 6 | [mizcausevic-dev/agent-card-diff-action](https://github.com/mizcausevic-dev/agent-card-diff-action) | github | 0 | 67 | 📋 Create Task | PR gate for A2A AgentCard breaking changes — diffs HEAD vs base.sha via agent-card-diff, posts PR comment, fails on brea |
+| 7 | [mizcausevic-dev/agent-card-fleet-summary-action](https://github.com/mizcausevic-dev/agent-card-fleet-summary-action) | github | 0 | 67 | 📋 Create Task | GitHub Action wrapping agent-card-fleet-summary. Walks a dir of AgentCards, surfaces governance gaps (autonomous-without |
+| 8 | [README.md at main · a2aproject/a2a-js](https://github.com/a2aproject/a2a-js/blob/main/README.md) | exa | — | 58 | 📝 Document | README.md at main · a2aproject/a2a-js |
+| 9 | [a2aproject/a2a-js](https://github.com/google-a2a/a2a-js) | exa | — | 58 | 📝 Document | a2aproject/a2a-js |
+| 10 | [GoPlausible/a2a-js](https://github.com/GoPlausible/a2a-js) | exa | — | 58 | 📝 Document | GoPlausible/a2a-js |
+| 11 | [a2aproject/A2A](https://github.com/google/A2A?tab=readme-ov-file) | exa | — | 58 | 📝 Document | a2aproject/A2A |
+| 12 | [docs/specification.md at main · a2aproject/A2A](https://github.com/google/A2A/blob/main/docs/specification.md) | exa | — | 58 | 📝 Document | docs/specification.md at main · a2aproject/A2A |
+| 13 | [docs/specification.md at main · a2aproject/A2A](https://github.com/a2aproject/A2A/blob/main/docs/specification.md) | exa | — | 58 | 📝 Document | docs/specification.md at main · a2aproject/A2A |
+| 14 | [a2aproject/a2a-js](https://github.com/a2aproject/a2a-js/) | exa | — | 58 | 📝 Document | a2aproject/a2a-js |
+| 15 | [safety-quotient-lab/a2a-governance](https://github.com/safety-quotient-lab/a2a-governance) | exa | — | 58 | 📝 Document | safety-quotient-lab/a2a-governance |
+| 16 | [Proposal: compliance extensions to Agent Cards and task semantics · Issue #1603 · a2aproject/A2A](https://github.com/a2aproject/A2A/issues/1603) | exa | — | 58 | 📝 Document | Proposal: compliance extensions to Agent Cards and task semantics · Issue #1603 · a2aproject/A2A |
+| 17 | [opena2a-standards/agent-governance-spec](https://github.com/opena2a-org/agent-governance-spec) | exa | — | 58 | 📝 Document | opena2a-standards/agent-governance-spec |
+| 18 | [[Feat]: Add Resource Access Manifest (RAM) to AgentCard · Issue #1426 · a2aproject/A2A](https://github.com/a2aproject/A2A/issues/1426) | exa | — | 58 | 📝 Document | [Feat]: Add Resource Access Manifest (RAM) to AgentCard · Issue #1426 · a2aproject/A2A |
+| 19 | [Show HN: My AI agents bully each other to prevent context drift](https://wuphf.team) | hackernews | 9 | 52 | 📝 Document | HN score: 9 \| Comments: 0 |
+| 20 | [Show HN: Trust Protocols for Anthropic/OpenAI/Gemini](https://www.mnemom.ai) | hackernews | 40 | 46 | 📝 Document | HN score: 40 \| Comments: 33 |
+| 21 | [A2A TypeScript SDK: Server and Client Examples | StackA2A](https://stacka2a.dev/blog/a2a-typescript-sdk-guide) | exa | — | 42 | 🔍 Evaluate | A2A TypeScript SDK: Server and Client Examples \| StackA2A |
+| 22 | [Agent-to-Agent Protocol (A2A)](https://iii-hq-agentos.mintlify.app/advanced/a2a-protocol) | exa | — | 42 | 🔍 Evaluate | Agent-to-Agent Protocol (A2A) |
+| 23 | [A2A - Asqav Docs](https://www.asqav.com/docs/a2a) | exa | — | 42 | 🔍 Evaluate | A2A - Asqav Docs |
+| 24 | [Show HN: Nightmarket – API marketplace where AI agents pay per call in USDC](https://www.nightmarket.ai/) | hackernews | 2 | 39 | 🔍 Evaluate | HN score: 2 \| Comments: 0 |
+| 25 | [Twin Algebras: Condensable Algebras beyond Anyons](http://arxiv.org/abs/2605.31602v1) | arxiv | — | 38 | 🔍 Evaluate | Condensable algebras in 2+1d non-chiral topological orders characterize gapped boundary conditions and interfaces. Appli |
+| 26 | [Linear Scaling Video VLMs for Long Video Understanding](http://arxiv.org/abs/2605.31598v1) | arxiv | — | 38 | 🔍 Evaluate | Video vision-language models (VLMs) are increasingly used in long-horizon and streaming settings, yet most video encoder |
+| 27 | [A Tight Theory of Error Feedback Algorithms in Distributed Optimization](http://arxiv.org/abs/2605.31594v1) | arxiv | — | 38 | 🔍 Evaluate | Communication costs are a major bottleneck in distributed learning and first-order optimization. A common approach to al |
+| 28 | [Stateful Online Monitoring Catches Distributed Agent Attacks](http://arxiv.org/abs/2605.31593v1) | arxiv | — | 38 | 🔍 Evaluate | Language models can find thousands of severe software vulnerabilities, and agents are increasingly being misused for cyb |
+| 29 | [Two roles of Alexander in two Kashaev phases](http://arxiv.org/abs/2605.31588v1) | arxiv | — | 38 | 🔍 Evaluate | The crucial feature of resurgence theory is the ambiguity of non-perturbative behavior, reflected either in the differen |
+| 30 | [Stability and instability of torus-symmetric Einstein spacetimes with square-integrable connection](http://arxiv.org/abs/2605.31585v1) | arxiv | — | 38 | 🔍 Evaluate | We study the global evolution problem for the Einstein equations under T2 symmetry on T3, allowing vacuum, scalar-field, |
+| 31 | [LongTraceRL: Learning Long-Context Reasoning from Search Agent Trajectories with Rubric Rewards](http://arxiv.org/abs/2605.31584v1) | arxiv | — | 38 | 🔍 Evaluate | Long-context reasoning remains a central challenge for large language models, which often fail to locate and integrate k |
+| 32 | [Choosing the Lens: Strategic Perspective Activation in Context-Dependent Argumentation](http://arxiv.org/abs/2605.31581v1) | arxiv | — | 38 | 🔍 Evaluate | The same arguments often need to be evaluated under different external regimes. An agent with influence over the regime  |
+| 33 | [kwailapt/AgentCard](https://github.com/kwailapt/AgentCard) | exa | — | 30 | 🔍 Evaluate | kwailapt/AgentCard |
+
+---
+
+## Agent Adapter / Polyglot Wrappers
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [pi-mcp-adapter](https://www.npmjs.com/package/pi-mcp-adapter) | npm | — | 85 | 📋 Create Task | MCP (Model Context Protocol) adapter extension for Pi coding agent |
+| 2 | [react-native-css-interop](https://www.npmjs.com/package/react-native-css-interop) | npm | — | 85 | 📋 Create Task | Provides a layer of interoperability between React Native and CSS stylesheets allowing to use CSS as a styling language  |
+| 3 | [hermes-paperclip-adapter](https://www.npmjs.com/package/hermes-paperclip-adapter) | npm | — | 79 | 📋 Create Task | Paperclip adapter for Hermes Agent — run Hermes as a managed employee in a Paperclip company |
+| 4 | [@jitsi/sdp-interop](https://www.npmjs.com/package/@jitsi/sdp-interop) | npm | — | 71 | 📋 Create Task | A simple SDP interoperability layer for Unified Plan/Plan B |
+| 5 | [GitHub - poly-mcp/PolyMCP: Polymcp provides a simple and efficient way to interact with MCP servers using custom agents · GitHub](https://github.com/poly-mcp/PolyMCP) | exa | — | 58 | 📝 Document | GitHub - poly-mcp/PolyMCP: Polymcp provides a simple and efficient way to interact with MCP servers using custom agents  |
+| 6 | [grll/mcpadapt](https://github.com/grll/mcpadapt) | exa | — | 58 | 📝 Document | grll/mcpadapt |
+| 7 | [grupa-ai/agent-mcp](https://github.com/grupa-ai/agent-mcp) | exa | — | 58 | 📝 Document | grupa-ai/agent-mcp |
+| 8 | [docs/architecture/adapter-layer.md at main · JianyuZhan/crossfire](https://github.com/JianyuZhan/crossfire/blob/main/docs/architecture/adapter-layer.md) | exa | — | 58 | 📝 Document | docs/architecture/adapter-layer.md at main · JianyuZhan/crossfire |
+| 9 | [InHarness/agent-adapters](https://github.com/inharness/agent-adapters) | exa | — | 58 | 📝 Document | InHarness/agent-adapters |
+| 10 | [open-voice-interoperability/openfloor-js](https://github.com/open-voice-interoperability/openfloor-js) | exa | — | 58 | 📝 Document | open-voice-interoperability/openfloor-js |
+| 11 | [@zed-industries/codex-acp](https://www.npmjs.com/package/@zed-industries/codex-acp) | npm | — | 57 | 📝 Document | An ACP-compatible coding agent powered by Codex |
+| 12 | [@agentclientprotocol/claude-agent-acp](https://www.npmjs.com/package/@agentclientprotocol/claude-agent-acp) | npm | — | 57 | 📝 Document | An ACP-compatible coding agent powered by the Claude Agent SDK (TypeScript) |
+| 13 | [@anthropic-ai/claude-agent-sdk](https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk) | npm | — | 57 | 📝 Document | SDK for building AI agents with Claude Code's capabilities. Programmatically interact with Claude to build autonomous ag |
+| 14 | [@mastra/core](https://www.npmjs.com/package/@mastra/core) | npm | — | 57 | 📝 Document | Mastra is a framework for building AI-powered applications and agents with a modern TypeScript stack. |
+| 15 | [cacheable](https://www.npmjs.com/package/cacheable) | npm | — | 57 | 📝 Document | High Performance Layer 1 / Layer 2 Caching with Keyv Storage |
+| 16 | [agent-base](https://www.npmjs.com/package/agent-base) | npm | — | 51 | 📝 Document | Turn a function into an `http.Agent` instance |
+| 17 | [telecom-mas-agent](https://www.npmjs.com/package/telecom-mas-agent) | npm | — | 47 | 📝 Document | A conversational AI-driven telecom multi-agent system for managing call balances, push notifications, marketing, targeti |
+| 18 | [Nephrolytics-ai/polyglot-llm](https://github.com/Nephrolytics-ai/polyglot-llm) | exa | — | 30 | 🔍 Evaluate | Nephrolytics-ai/polyglot-llm |
+| 19 | [quanhua92/polyglot-agent-labs](https://github.com/quanhua92/polyglot-agent-labs) | exa | — | 30 | 🔍 Evaluate | quanhua92/polyglot-agent-labs |
+| 20 | [agentrpc/agentrpc](https://github.com/agentrpc/agentrpc) | exa | — | 30 | 🔍 Evaluate | agentrpc/agentrpc |
+| 21 | [zosmaai/dhara](https://github.com/zosmaai/dhara) | exa | — | 30 | 🔍 Evaluate | zosmaai/dhara |
+| 22 | [Parcha-ai/ati](https://github.com/Parcha-ai/ati) | exa | — | 30 | 🔍 Evaluate | Parcha-ai/ati |
+| 23 | [PhilipAD/Unified-Agents-SDK](https://github.com/PhilipAD/Unified-Agent-Gateway) | exa | — | 30 | 🔍 Evaluate | PhilipAD/Unified-Agents-SDK |
+| 24 | [kwstx/engram_translator](https://github.com/kwstx/engram_translator) | exa | — | 30 | 🔍 Evaluate | kwstx/engram_translator |
+| 25 | [vahapogut/nexarion](https://github.com/vahapogut/nexarion) | exa | — | 30 | 🔍 Evaluate | vahapogut/nexarion |
+| 26 | [deosha/semantic-translation-framework](https://github.com/deosha/semantic-translation-framework) | exa | — | 30 | 🔍 Evaluate | deosha/semantic-translation-framework |
+
+---
+
+## Agent Marketplaces / Registries / Tool Routers
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [add-mcp](https://www.npmjs.com/package/add-mcp) | npm | — | 85 | 📋 Create Task | Add MCP servers to your favorite coding agents with a single command. |
+| 2 | [Show HN: Amber, a capability-based runtime/compiler for agent benchmarks](https://github.com/RDI-Foundation/amber/) | hackernews | 1 | 81 | 📋 Create Task | HN score: 1 \| Comments: 0 |
+| 3 | [registry-auth-token](https://www.npmjs.com/package/registry-auth-token) | npm | — | 75 | 📋 Create Task | Get the auth token set for an npm registry (if any) |
+| 4 | [Douglas88/openclaw-plugins](https://github.com/Douglas88/openclaw-plugins) | github | 0 | 67 | 📋 Create Task | OpenClaw Plugin Marketplace — 8 Community Skills + MCP Registry |
+| 5 | [pleme-io/openclaw-skill-store](https://github.com/pleme-io/openclaw-skill-store) | github | 0 | 67 | 📋 Create Task | Attested skill registry and marketplace API for OpenClaw agents |
+| 6 | [moux1024/openclaw-skill-hub](https://github.com/moux1024/openclaw-skill-hub) | github | 0 | 61 | 📋 Create Task | OpenClaw Skill Hub - Community skills registry and marketplace |
+| 7 | [modelcontextprotocol/registry](https://github.com/modelcontextprotocol/registry/) | exa | — | 58 | 📝 Document | modelcontextprotocol/registry |
+| 8 | [agentregistry-dev/agentregistry](https://github.com/solo-io/agentregistry) | exa | — | 58 | 📝 Document | agentregistry-dev/agentregistry |
+| 9 | [agentoperations/agent-registry](https://github.com/agentoperations/agent-registry) | exa | — | 58 | 📝 Document | agentoperations/agent-registry |
+| 10 | [modelcontextprotocol/registry](https://github.com/modelcontextprotocol/registry?tab=readme-ov-file) | exa | — | 58 | 📝 Document | modelcontextprotocol/registry |
+| 11 | [Tool Router | Composio](https://docs.composio.dev/reference/api-reference/tool-router) | exa | — | 58 | 📝 Document | Tool Router \| Composio |
+| 12 | [Create a new tool router session | Composio](https://docs.composio.dev/reference/api-reference/tool-router/postToolRouterSession?explorer=true) | exa | — | 58 | 📝 Document | Create a new tool router session \| Composio |
+| 13 | [Native Tools vs MCP | Composio](https://docs.composio.dev/docs/native-tools-vs-mcp) | exa | — | 58 | 📝 Document | Native Tools vs MCP \| Composio |
+| 14 | [@biomejs/biome](https://www.npmjs.com/package/@biomejs/biome) | npm | — | 57 | 📝 Document | Biome is a toolchain for the web: formatter, linter and more |
+| 15 | [@earendil-works/pi-coding-agent](https://www.npmjs.com/package/@earendil-works/pi-coding-agent) | npm | — | 57 | 📝 Document | Coding agent CLI with read, bash, edit, write tools and session management |
+| 16 | [@opendirectory.dev/skills](https://www.npmjs.com/package/@opendirectory.dev/skills) | npm | — | 57 | 📝 Document | **Agent skills for founders who hate marketing.** |
+| 17 | [knip](https://www.npmjs.com/package/knip) | npm | — | 57 | 📝 Document | Find and fix unused dependencies, exports and files in your TypeScript and JavaScript projects |
+| 18 | [create-mercato-app](https://www.npmjs.com/package/create-mercato-app) | npm | — | 57 | 📝 Document | Create a new Open Mercato application |
+| 19 | [@composio/core](https://www.npmjs.com/package/@composio/core) | npm | — | 57 | 📝 Document | ![Composio Banner](https://github.com/user-attachments/assets/9ba0e9c1-85a4-4b51-ae60-f9fe7992e819) |
+| 20 | [@composio/mastra](https://www.npmjs.com/package/@composio/mastra) | npm | — | 57 | 📝 Document | Agentic Provider for mastra in Composio SDK |
+| 21 | [@composio/client](https://www.npmjs.com/package/@composio/client) | npm | — | 57 | 📝 Document | The official TypeScript library for the Composio API |
+| 22 | [@composio/vercel](https://www.npmjs.com/package/@composio/vercel) | npm | — | 57 | 📝 Document | The Vercel AI SDK provider for Composio SDK, providing seamless integration with Vercel's AI SDK and tools. |
+| 23 | [@composio/claude-agent-sdk](https://www.npmjs.com/package/@composio/claude-agent-sdk) | npm | — | 57 | 📝 Document | Composio provider for Claude Agent SDK |
+| 24 | [https-proxy-agent](https://www.npmjs.com/package/https-proxy-agent) | npm | — | 51 | 📝 Document | An HTTP(s) proxy `http.Agent` implementation for HTTPS |
+| 25 | [skillflag](https://www.npmjs.com/package/skillflag) | npm | — | 47 | 📝 Document | Skillflag producer CLI reference implementation. |
+| 26 | [agentregistry — Build. Deploy. Discover.](https://aregistry.ai/) | exa | — | 42 | 🔍 Evaluate | agentregistry — Build. Deploy. Discover. |
+| 27 | [Show HN: Give Your AI the Ability to Find, Install, and Use Skill Autonomously](https://news.ycombinator.com/item?id=46942091) | hackernews | 2 | 39 | 🔍 Evaluate | HN score: 2 \| Comments: 0 |
+| 28 | [ClawHub - OpenClaw](https://docs.openclaw.ai/clawhub/) | exa | — | 30 | 🔍 Evaluate | ClawHub - OpenClaw |
+| 29 | [openclaw/clawhub](https://github.com/openclaw/clawhub/) | exa | — | 30 | 🔍 Evaluate | openclaw/clawhub |
+| 30 | [ClawHub - OpenClaw](https://documentation.openclaw.ai/clawhub) | exa | — | 30 | 🔍 Evaluate | ClawHub - OpenClaw |
+| 31 | [ClawHub](https://docs2.openclaw.ai/clawhub) | exa | — | 30 | 🔍 Evaluate | ClawHub |
+| 32 | [ClawHub – OpenClaw - Open Source AI Coding Assistant](https://openclawlab.com/en/docs/tools/clawhub/) | exa | — | 30 | 🔍 Evaluate | ClawHub – OpenClaw - Open Source AI Coding Assistant |
+| 33 | [ts/docs/api/tool-router.md at next · ComposioHQ/composio](https://github.com/ComposioHQ/composio/blob/next/ts/docs/api/tool-router.md) | exa | — | 30 | 🔍 Evaluate | ts/docs/api/tool-router.md at next · ComposioHQ/composio |
+| 34 | [python/docs/tool-router.md at next · ComposioHQ/composio](https://github.com/ComposioHQ/composio/blob/next/python/docs/tool-router.md) | exa | — | 30 | 🔍 Evaluate | python/docs/tool-router.md at next · ComposioHQ/composio |
+
+---
+
+## Strategic Signals / MCP + A2A + OpenClaw
+
+| # | Name | Source | Stars | Score | Decision | Description |
+|---|------|--------|-------|-------|----------|-------------|
+| 1 | [freema/openclaw-a2a](https://github.com/freema/openclaw-a2a) | exa | — | 58 | 📝 Document | freema/openclaw-a2a |
+| 2 | [1.0.2](https://github.com/freema/openclaw-mcp/releases/tag/1.0.2) | exa | — | 58 | 📝 Document | 1.0.2 |
+| 3 | [GitHub - win4r/openclaw-a2a-gateway at b278ef370626f2751b7135139d3e63aba319928f · GitHub](https://github.com/win4r/openclaw-a2a-gateway/tree/b278ef370626f2751b7135139d3e63aba319928f) | exa | — | 58 | 📝 Document | GitHub - win4r/openclaw-a2a-gateway at b278ef370626f2751b7135139d3e63aba319928f · GitHub |
+| 4 | [freema/openclaw-mcp](https://github.com/freema/openclaw-mcp) | exa | — | 58 | 📝 Document | freema/openclaw-mcp |
+| 5 | [openclaw-a2a - npm](https://www.npmjs.com/package/openclaw-a2a) | exa | — | 58 | 📝 Document | openclaw-a2a - npm |
+| 6 | [v1.5.0](https://github.com/modelcontextprotocol/registry/releases/tag/v1.5.0) | exa | — | 58 | 📝 Document | v1.5.0 |
+| 7 | [v3.2.0 — E2E Encryption, Wire Protocol, Registry, Relay](https://github.com/microsoft/agent-governance-toolkit/releases/tag/v3.2.0) | exa | — | 58 | 📝 Document | v3.2.0 — E2E Encryption, Wire Protocol, Registry, Relay |
+| 8 | [v3.7.0](https://github.com/microsoft/agent-governance-toolkit/releases/tag/v3.7.0) | exa | — | 58 | 📝 Document | v3.7.0 |
+| 9 | [v3.1.0 - Unified CLI, Governance Dashboard, Quantum-Safe Crypto](https://github.com/microsoft/agent-governance-toolkit/releases/tag/v3.1.0) | exa | — | 58 | 📝 Document | v3.1.0 - Unified CLI, Governance Dashboard, Quantum-Safe Crypto |
+| 10 | [v3.6.0](https://github.com/microsoft/agent-governance-toolkit/releases/tag/v3.6.0) | exa | — | 58 | 📝 Document | v3.6.0 |
+| 11 | [Introducing Agent Registry, MCP Server, and LLM artifact support](https://www.apicur.io/blog/2026/02/05/apicurio-registry-ai-natural-evolution) | exa | — | 42 | 🔍 Evaluate | Introducing Agent Registry, MCP Server, and LLM artifact support |
+| 12 | [Changelog - Composio Docs](https://docs.composio.dev/reference/changelog) | exa | — | 30 | 🔍 Evaluate | Changelog - Composio Docs |
+| 13 | [docs/content/changelog/09-26-25.mdx at next · ComposioHQ/composio](https://github.com/ComposioHQ/composio/blob/next/docs/content/changelog/09-26-25.mdx) | exa | — | 30 | 🔍 Evaluate | docs/content/changelog/09-26-25.mdx at next · ComposioHQ/composio |
+| 14 | [Add agent discovery metadata for docs · Pull Request #3249 · ComposioHQ/composio](https://github.com/ComposioHQ/composio/pull/3249) | exa | — | 30 | 🔍 Evaluate | Add agent discovery metadata for docs · Pull Request #3249 · ComposioHQ/composio |
+| 15 | [cunardai/agp-protocol](https://github.com/cunardai/agp-protocol) | exa | — | 30 | 🔍 Evaluate | cunardai/agp-protocol |
+
+---
+
+## 🧬 Evolution Insights (Self-Improving Keywords)
+
+> These keywords were extracted from today's results to improve future searches.
+> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
+
+### Trending Terms Detected
+
+- **a2aproject** (appeared 16x)
+- **docs** (appeared 11x)
+- **main** (appeared 11x)
+- **score** (appeared 11x)
+- **comments** (appeared 11x)
+- **show** (appeared 10x)
+- **tools** (appeared 8x)
+- **coding** (appeared 8x)
+- **a2a-js** (appeared 8x)
+- **json-c** (appeared 7x)
+- **http** (appeared 6x)
+- **releases** (appeared 6x)
+- **https** (appeared 6x)
+- **mizcausevic-dev** (appeared 6x)
+- **modelcontextprotocol** (appeared 6x)
+- **pulumi** (appeared 6x)
+- **agentcard** (appeared 6x)
+- **logseq** (appeared 5x)
+- **official** (appeared 5x)
+- **servers** (appeared 5x)
+
+### Suggested New Search Topics
+
+- 🎯 **Emerging: a2aproject + docs + main**: a2aproject docs main, docs main score, main score comments
+- 🎯 **Next-Gen: score + comments + show**: score comments show, show tools coding
+
+### Action Summary
+
+| Action | Count |
+|--------|-------|
+| 📋 Create Task | 56 |
+| 📝 Document | 75 |
+| 🔍 Evaluate | 42 |
+
+---
+
+> 🔄 **Next run will automatically incorporate the evolved keywords above.**
+> 🎯 **Prioritize `⚡ Implement` and `📋 Create Task` items first, then document or discard the rest.**
diff --git a/docs/gem-hunter/history.db b/docs/gem-hunter/history.db
index d59077d3..cafa44fe 100644
Binary files a/docs/gem-hunter/history.db and b/docs/gem-hunter/history.db differ
diff --git a/docs/gem-hunter/latest-run.json b/docs/gem-hunter/latest-run.json
index 6d064dc9..ab88a176 100644
--- a/docs/gem-hunter/latest-run.json
+++ b/docs/gem-hunter/latest-run.json
@@ -1,19 +1,28 @@
 {
-  "generatedAt": "2026-05-31T12:58:38.012Z",
+  "generatedAt": "2026-06-01T10:59:36.663Z",
   "scoreModel": "v2-bounded",
-  "reportPath": "/home/enio/egos/docs/gem-hunter/gems-2026-05-31.md",
-  "totalGems": 19,
-  "quick": true,
-  "topicFilter": "mcp-governance-servers",
+  "reportPath": "/home/runner/work/egos/egos/docs/gem-hunter/gems-2026-06-01.md",
+  "totalGems": 173,
+  "quick": false,
+  "topicFilter": null,
   "tracks": [
+    "x-signals-public",
+    "early-warning",
     "governance-plugplay"
   ],
   "byCategory": {
-    "mcp-governance-servers": 19
+    "early-warning": 22,
+    "mcp-governance-servers": 43,
+    "a2a-agent-cards": 33,
+    "agent-adapters": 26,
+    "agent-marketplaces": 34,
+    "strategic-signals": 15
   },
   "bySource": {
-    "github": 5,
-    "hackernews": 5,
-    "npm": 9
+    "github": 35,
+    "exa": 75,
+    "hackernews": 15,
+    "npm": 40,
+    "arxiv": 8
   }
 }
\ No newline at end of file
diff --git a/docs/gem-hunter/next-queries.json b/docs/gem-hunter/next-queries.json
index ddc83a0e..c6b3a187 100644
--- a/docs/gem-hunter/next-queries.json
+++ b/docs/gem-hunter/next-queries.json
@@ -1,16 +1,108 @@
 {
-  "generatedAt": "2026-05-31T12:58:37.997Z",
+  "generatedAt": "2026-06-01T10:59:36.646Z",
   "trendingTerms": [
+    [
+      "a2aproject",
+      16
+    ],
+    [
+      "docs",
+      11
+    ],
+    [
+      "main",
+      11
+    ],
     [
       "score",
-      5
+      11
     ],
     [
       "comments",
-      5
+      11
     ],
     [
       "show",
+      10
+    ],
+    [
+      "tools",
+      8
+    ],
+    [
+      "coding",
+      8
+    ],
+    [
+      "a2a-js",
+      8
+    ],
+    [
+      "json-c",
+      7
+    ],
+    [
+      "http",
+      6
+    ],
+    [
+      "releases",
+      6
+    ],
+    [
+      "https",
+      6
+    ],
+    [
+      "mizcausevic-dev",
+      6
+    ],
+    [
+      "modelcontextprotocol",
+      6
+    ],
+    [
+      "pulumi",
+      6
+    ],
+    [
+      "agentcard",
+      6
+    ],
+    [
+      "logseq",
+      5
+    ],
+    [
+      "official",
+      5
+    ],
+    [
+      "servers",
+      5
+    ],
+    [
+      "client",
+      5
+    ],
+    [
+      "native",
+      5
+    ],
+    [
+      "powered",
+      4
+    ],
+    [
+      "repository",
+      4
+    ],
+    [
+      "wfgy",
+      4
+    ],
+    [
+      "interact",
       4
     ],
     [
@@ -18,35 +110,39 @@
       4
     ],
     [
-      "pulumi",
+      "ai-governance-mcp",
+      4
+    ],
+    [
+      "issue",
       4
     ],
     [
-      "audit",
-      3
+      "polymcp",
+      4
     ]
   ],
   "suggestedQueries": [
     {
-      "topic": "Emerging: score + comments + show",
+      "topic": "Emerging: a2aproject + docs + main",
       "keywords": [
-        "score comments show",
-        "comments show mcp-ui",
-        "show mcp-ui pulumi"
+        "a2aproject docs main",
+        "docs main score",
+        "main score comments"
       ]
     },
     {
-      "topic": "Next-Gen: mcp-ui + pulumi + audit",
+      "topic": "Next-Gen: score + comments + show",
       "keywords": [
-        "mcp-ui pulumi audit",
-        "audit"
+        "score comments show",
+        "show tools coding"
       ]
     }
   ],
-  "totalGemsAnalyzed": 19,
+  "totalGemsAnalyzed": 173,
   "actionBreakdown": {
-    "📋 Create Task": 15,
-    "🔍 Evaluate": 1,
-    "📝 Document": 3
+    "📋 Create Task": 56,
+    "📝 Document": 75,
+    "🔍 Evaluate": 42
   }
 }
\ No newline at end of file
diff --git a/docs/gem-hunter/signals.json b/docs/gem-hunter/signals.json
index cf34f467..115768cd 100644
--- a/docs/gem-hunter/signals.json
+++ b/docs/gem-hunter/signals.json
@@ -1,6 +1,56 @@
 {
   "version": "1.0.0",
   "signals": [
+    {
+      "type": "gem_discovery",
+      "name": "garrytan/gstack",
+      "url": "https://github.com/garrytan/gstack",
+      "score": 100,
+      "category": "early-warning",
+      "date": "2026-06-01T10:59:36.653Z",
+      "ts": "2026-06-01T10:59:36.653Z",
+      "headline": "garrytan/gstack — Use Garry Tan's exact Claude Code setup: 23 opinionated tools that serve as CEO, Designer, Eng Manag"
+    },
+    {
+      "type": "gem_discovery",
+      "name": "json-c/json-c",
+      "url": "https://github.com/json-c/json-c",
+      "score": 100,
+      "category": "early-warning",
+      "date": "2026-06-01T10:59:36.653Z",
+      "ts": "2026-06-01T10:59:36.653Z",
+      "headline": "json-c/json-c — https://github.com/json-c/json-c is the official code repository for json-c.  See the wiki for relea"
+    },
+    {
+      "type": "gem_discovery",
+      "name": "softprops/action-gh-release",
+      "url": "https://github.com/softprops/action-gh-release",
+      "score": 100,
+      "category": "early-warning",
+      "date": "2026-06-01T10:59:36.652Z",
+      "ts": "2026-06-01T10:59:36.652Z",
+      "headline": "softprops/action-gh-release — 📦 :octocat: GitHub Action for creating GitHub Releases"
+    },
+    {
+      "type": "gem_discovery",
+      "name": "release-it/release-it",
+      "url": "https://github.com/release-it/release-it",
+      "score": 100,
+      "category": "early-warning",
+      "date": "2026-06-01T10:59:36.652Z",
+      "ts": "2026-06-01T10:59:36.652Z",
+      "headline": "release-it/release-it — 🚀 Automate versioning and package publishing"
+    },
+    {
+      "type": "gem_discovery",
+      "name": "logseq/logseq",
+      "url": "https://github.com/logseq/logseq",
+      "score": 100,
+      "category": "early-warning",
+      "date": "2026-06-01T10:59:36.652Z",
+      "ts": "2026-06-01T10:59:36.652Z",
+      "headline": "logseq/logseq — A privacy-first, open-source platform for knowledge management and collaboration. Download link:  ht"
+    },
     {
       "type": "gem_discovery",
       "name": "mcp-proxy",

exec
/bin/bash -lc 'git diff --name-status e639ee8fc19ac4a05e725f6d009335217694eaf1' in /home/enio/egos
 succeeded in 0ms:
M	TASKS.md
A	docs/drafts/ARTICLE_investigador-arquiteto_DRAFT.md
M	docs/gem-hunter/auto-queue.json
A	docs/gem-hunter/gems-2026-06-01.md
M	docs/gem-hunter/history.db
M	docs/gem-hunter/latest-run.json
M	docs/gem-hunter/next-queries.json
M	docs/gem-hunter/signals.json

exec
/bin/bash -lc "rg \"latest-run.json|reportPath\" -n docs/gem-hunter scripts -g'*.ts' -g'*.js' -g'*.mjs'" in /home/enio/egos
 succeeded in 0ms:
scripts/gem-hunter-secops.ts:22:  const reportPath = path.join(process.cwd(), 'docs', 'gem-hunter', `secops-${today}.md`);
scripts/gem-hunter-secops.ts:49:    fs.mkdirSync(path.dirname(reportPath), { recursive: true });
scripts/gem-hunter-secops.ts:50:    fs.writeFileSync(reportPath, reportContent);
scripts/gem-hunter-secops.ts:51:    console.log(`📄 Relatório crítico gerado em: ${reportPath}`);
scripts/sprint-review.ts:142:  const reportPath = join(SPRINTS_DIR, `${sprint}-review.md`);
scripts/sprint-review.ts:147:    writeFileSync(reportPath, outputLines.join("\n"), "utf8");
scripts/sprint-review.ts:148:    console.log(`Sprint review document generated: ${reportPath}`);
scripts/sprint-review.ts:150:    console.log(`[DRY RUN] Review doc would be written to: ${reportPath}`);
scripts/evidence-gate-disseminate.ts:123:  const reportPath = join(EGOS_HOME, `docs/jobs/evidence-gate-disseminate-${new Date().toISOString().split('T')[0]}.json`);
scripts/evidence-gate-disseminate.ts:130:    Bun.write(reportPath, JSON.stringify(report, null, 2));
scripts/evidence-gate-disseminate.ts:131:    console.log(`📄 Report: ${reportPath}`);
scripts/health-monitor.ts:34:  private reportPath: string;
scripts/health-monitor.ts:36:  constructor(reportPath = "./logs/health-report.json") {
scripts/health-monitor.ts:37:    this.reportPath = reportPath;
scripts/health-monitor.ts:221:      writeFileSync(this.reportPath, JSON.stringify(report, null, 2));
scripts/health-monitor.ts:222:      console.log(`📄 Report saved to ${this.reportPath}`);
scripts/scoring-feedback-reader.ts:286:    const reportPath = join(JOBS_DIR, `scoring-feedback-${today}.md`);
scripts/scoring-feedback-reader.ts:287:    writeFileSync(reportPath, report);
scripts/scoring-feedback-reader.ts:288:    console.log(`[FeedbackReader] Report written: ${reportPath}`);
scripts/bench-providers.ts:70:  const reportPath = join(reportDir, `${date}-llm-benchmark.md`);
scripts/bench-providers.ts:80:  writeFileSync(reportPath, md);
scripts/bench-providers.ts:81:  console.error(`📄 Report saved: ${reportPath}`);
scripts/obs-central.ts:678:      const reportPath = join(jobsDir, `obs-${date}.md`);
scripts/obs-central.ts:679:      writeFileSync(reportPath, md);
scripts/obs-central.ts:680:      console.error("📄 Report saved to:", reportPath);
scripts/start-audit.ts:15:const reportPath = join(generatedDir, 'start-audit-latest.json')
scripts/start-audit.ts:68:writeFileSync(reportPath, JSON.stringify(summary, null, 2))
scripts/start-audit.ts:83:  console.log(`Snapshot: ${reportPath}`)

exec
/bin/bash -lc "rg \"docs/gem-hunter/latest-run.json|latest-run|gem-hunter\" -n --glob '*.{ts,tsx,js,mjs,json,md}'" in /home/enio/egos
 succeeded in 0ms:
scripts/calibrate-tasks.ts:35:  return ['egos','intelink','852','forja','carteira-livre','egos-lab','br-acc','gem-hunter']
packages/shared/src/cost-tracker.ts:3: * LLM cost budgeting module for the EGOS gem-hunter pipeline.
scripts/x-post-approval-bot.ts:343:        else if (tags.some((t: string) => t.includes("gem"))) articleCategory = "gem-hunter";
scripts/gem-hunter-secops.ts:22:  const reportPath = path.join(process.cwd(), 'docs', 'gem-hunter', `secops-${today}.md`);
TASKS_ARCHIVE.md:33:- [x] GH-067: gem-hunter-server deployed to VPS port 3095, systemd, Caddy ready ✅ 2026-04-05 — [BLOCKER] DNS A record gemhunter.egos.ia.br → 204.168.217.125 needed
TASKS_ARCHIVE.md:42:- [x] GH-062: packages/gem-hunter/ — @egosbr/gem-hunter v6.0.0 ✅ 2026-04-02
TASKS_ARCHIVE.md:44:- [x] GH-066*: Gateway /gem-hunter channel — sector filter, topics, product pricing, trending ✅ 2026-04-04 (NOTE: renamed from Paper→Code)
TASKS_ARCHIVE.md:56:- [x] INTEL-005: Signal ingestion — Gem Hunter scores > 80 → auto-append to world model signals (= GH-050) ✅ 2026-04-06 — gem-hunter.ts appends type:gem_discovery, capped at 50
TASKS_ARCHIVE.md:283:| **PRODUCTION** | guard-brasil, forja, 852, gem-hunter, egos-gateway | Live com usuários ou pilot | `/home/enio/{forja,852}` + `/home/enio/egos/{apps/egos-gateway,packages/gem-hunter}` |
TASKS_ARCHIVE.md:295:4. **gem-hunter está dentro do egos kernel** mas precisa virar standalone (P0, ver GH-STANDALONE-* abaixo). Enio identifica-se como gem hunter — produto-âncora.
TASKS_ARCHIVE.md:711:- [x] GH-STANDALONE-008: gem-hunter-skill GitHub repo — API client + discovery interface ✅ 2026-04-29
TASKS_ARCHIVE.md:1225:- [x] **README-001 [P0]**: Reescrever `gem-hunter/README.md` (score 1.5→5, PT-BR completo) | ✅ 2026-05-03
TASKS_ARCHIVE.md:1248:### gem-hunter GitHub
TASKS_ARCHIVE.md:1249:- [x] **GEM-GH-001 [P1]**: github.com/enioxt/gem-hunter criado + pushed ✅ 2026-05-04
TASKS_ARCHIVE.md:3208:- [x] **GUARD-STD-002** [P1] `guarani` — Rodar gem-hunter com as 8 queries do §5 (`gemhunter:exec`) + arxiv/reddit; entregar shortlist de frameworks/libs (NeMo, Guardrails AI, Llama Guard, Presidio, Rebuff, garak/PyRIT) com licença+stack-fit Bun/TS+PT-BR. Deixa staged + handoff. ✅ 2026-05-31
scripts/_archived/obsidian-stack-retired-2026-05-29/obsidian-export.ts:25:  { name: 'gem-hunter',      path: '/home/enio/gem-hunter',      group: 'PRODUCTION',  priority: 'P0' },
packages/gem-hunter/bin/gem-hunter.ts:3: * @egosbr/gem-hunter CLI
packages/gem-hunter/bin/gem-hunter.ts:6: *   npx @egosbr/gem-hunter                    # show findings
packages/gem-hunter/bin/gem-hunter.ts:7: *   npx @egosbr/gem-hunter hunt               # trigger a run
packages/gem-hunter/bin/gem-hunter.ts:8: *   npx @egosbr/gem-hunter hunt --quick       # quick run
packages/gem-hunter/bin/gem-hunter.ts:9: *   npx @egosbr/gem-hunter papers             # list scaffolded papers
packages/gem-hunter/bin/gem-hunter.ts:10: *   npx @egosbr/gem-hunter signals            # show world-model signals
packages/gem-hunter/bin/gem-hunter.ts:11: *   npx @egosbr/gem-hunter wait <jobId>       # wait for a job to finish
packages/gem-hunter/bin/gem-hunter.ts:39:      console.log(`\nRun: gem-hunter wait ${job.jobId}  — to wait for completion`);
packages/gem-hunter/bin/gem-hunter.ts:45:      if (!jobId) { console.error("Usage: gem-hunter wait <jobId>"); process.exit(1); }
packages/gem-hunter/package.json:2:  "name": "@egosbr/gem-hunter",
packages/gem-hunter/package.json:7:    "gem-hunter": "./bin/gem-hunter.js"
packages/gem-hunter/package.json:17:    "build:bin": "bun build bin/gem-hunter.ts --outfile bin/gem-hunter.js --target node",
packages/gem-hunter/package.json:21:    "ai", "gem-hunter", "research", "papers", "discovery", "egos", "brazil"
TASKS_PRODUCT.md:42:- [ ] **IHV-DISS-003 [P2]**: Disseminar **Pramana** para `gem-hunter` — cada finding de gem tem nível (Fact para teste que passa, Inference para heurística, Disputed para signals conflitantes). | 2d
TASKS_PRODUCT.md:341:- [ ] **HQV2-003**: `/api/hq/gems` — gem-hunter API → top gems, last run, sector breakdown
TASKS_PRODUCT.md:406:**CCR:** seg+qui 2h37 BRT | **Standalone API:** port 3097 | **npm:** @egosbr/gem-hunter v6.0.0
TASKS_PRODUCT.md:407:**Done (GH-001..066):** /study+/study-end skills, pair studies (Continue 71/100, Aider 74/100, Cline 72.8/100), PWC pipeline, Papers Without Code, KOL discovery, Telegram+Discord alerts, BRAID GRD, X-reply-bot (VPS hourly cron), ArchitectureSelector, cost-tracker, world-model signals, gem-hunter-server API, pricing.ts, Gateway /gem-hunter channel.
TASKS_PRODUCT.md:433:**Gem Hunter v5.1+v6.0 DONE (GH-043..065):** PWC pipeline, low-star scoring, ArchitectureSelector adapter, structural validation, auto-queue, signals ingestion, Papers Without Code, KOL discovery, evolution engine, multi-LLM fallback, Telegram alerts, multi-stage paper pipeline, cost budgeting, standalone API, MONETIZATION_SSOT, pricing.ts, gem-hunter npm v6.0.0. Details: git log.
TASKS_PRODUCT.md:437:- [ ] GH-067: Deploy gem-hunter-server to VPS (gemhunter.egos.ia.br) + Caddy routing → P0 revenue
TASKS_PRODUCT.md:438:- [ ] GH-070: Chatbot orchestrator — WhatsApp channel NLP intent → tool calls → gem-hunter → curated reply
TASKS_PRODUCT.md:441:- SSOT: docs/gem-hunter/GEM_HUNTER_PRODUCT.md
TASKS_PRODUCT.md:628:- [ ] **EVAL-G1 [P2]**: Mesmo `@egos/eval-runner` reutilizado para gem-hunter. Golden cases: (a) "busque gemas web3 memecoins" deve retornar lista scored; (b) "mais como essa" deve refinar baseado em previous; (c) "descarta essa" deve excluir do próximo batch; (d) recência — query 2026 não pode retornar repos abandonados 2023. | 6h
TASKS_PRODUCT.md:654:**SSOT:** `docs/modules/CHATBOT_SSOT.md` §14 (novo) | **Sequência:** Phase 0 → 1 (intelink) → 2 (gem-hunter) | **Decisão parceiro:** focar em intelink + gem-hunter; carteira-livre adia (P3)
TASKS_PRODUCT.md:666:- [ ] **CHATBOT-EVO-GH-001 [P1]**: Refatorar `agents/agents/gem-hunter.ts` (2537 LOC) — extrair source adapters (GitHub, ArXiv, HF, npm, Reddit, X) como tools do `@egos/agent-runtime`. Preservar scoring algebra + content guards + evolution loop. | 2d
TASKS_PRODUCT.md:667:- [ ] **CHATBOT-EVO-GH-002 [P1]**: Frontend conversacional — "busque gemas sobre web3 memecoins 2026" → agent decide fontes, retorna scored list citada. Decidir: novo app `apps/gem-hunter-chat` OU integrar em `apps/egos-site`? | 1d
TASKS_PRODUCT.md:669:- [ ] **CHATBOT-EVO-GH-004 [P2]**: Deploy + rota `gem-hunter.egos.ia.br` OU `chatbot.egos.ia.br` com `use_case: "gem-discovery"`. | 2h
TASKS_PRODUCT.md:670:- [ ] **CHATBOT-EVO-GH-005 [P2]**: Expandir fontes: Hugging Face papers daily, Exa.ai semantic search, Firecrawl trending blogs. Inspirado nas 14+ do gem-hunter atual. | 2d
TASKS_PRODUCT.md:754:- [ ] **DA-006 [P1]**: Gem Hunter research integrated: article-writer calls `gem-hunter --query <topic>` before draft, injects "similar projects" section | 3h
TASKS_PRODUCT.md:858:| **A: Distribution** | GH-074 | gem-hunter-digest.ts — top 3-5 repos/week, markdown+Telegram (cron Thu 02:00 UTC) | ✅ Done |
TASKS_PRODUCT.md:865:| **C: Distribution** | GH-081 | Slack bot: /gem-hunter trending [lang] | [ ] |
TASKS_PRODUCT.md:870:| **E: MCP + Multi-Domain** | GH-086 | `@egosbr/gem-hunter-mcp` — MCP server (tools: search/trending/by_domain) for Claude Code/Windsurf/Cursor/Copilot, install by repo URL | [ ] |
TASKS_PRODUCT.md:871:| | GH-087 | Multi-domain sources: medical (PubMed/arXiv-bio), engineering (IEEE/papers-with-code), veterinary, finance/traders (QuantConnect/QuantStack), web3 (Awesome lists, Etherscan dev tools) — adapter pattern in `agents/gem-hunter/sources/` | [ ] |
TASKS_PRODUCT.md:873:| **Fixes 2026-04-08** | GH-FIX-1 | Caddyfile: gemhunter upstream `egos-site:3070` → `gem-hunter-landing:3070` (was 502) | [x] |
packages/gem-hunter/README.md:1:# @egos/gem-hunter — Gem Hunter Engine
packages/gem-hunter/README.md:12:- Digests semanais via `scripts/gem-hunter-digest.ts`
packages/gem-hunter/README.md:14:Relacionado: `apps/egos-gateway/src/channels/gem-hunter.ts` (API)
packages/shared/src/billing/pricing.ts:39:export type Product = "gem-hunter" | "guard-brasil" | "eagle-eye";
packages/shared/src/billing/pricing.ts:75:    product: "gem-hunter",
packages/shared/src/billing/pricing.ts:137: *   const url = buildStripeCheckoutUrl('gem-hunter', 'starter', 'user@example.com');
scripts/obs-central.ts:97:  cronLogPatterns: ["egos-", "gem-hunter", "wiki", "ocr"],
scripts/obs-central.ts:100:    { name: "gem-hunter-api", url: "http://localhost:3095/health", port: 3095 },
packages/gem-hunter/src/index.ts:2: * @egosbr/gem-hunter — Public API
packages/gem-hunter/src/index.ts:6: *   import { GemHunter, type GemResult, type HuntOptions } from '@egosbr/gem-hunter';
packages/shared/src/agent-signature.test.ts:16:    const kp = generateAgentKeyPair('gem-hunter');
packages/shared/src/agent-signature.test.ts:18:      agentId: 'gem-hunter',
packages/shared/src/agent-signature.test.ts:29:    const kp = generateAgentKeyPair('gem-hunter');
packages/shared/src/agent-signature.test.ts:31:      agentId: 'gem-hunter',
packages/shared/src/agent-signature.test.ts:50:    const kp = generateAgentKeyPair('gem-hunter');
packages/shared/src/agent-signature.test.ts:52:      agentId: 'gem-hunter',
packages/shared/src/agent-signature.test.ts:64:    const kp = generateAgentKeyPair('gem-hunter');
packages/shared/src/agent-signature.test.ts:66:      agentId: 'gem-hunter',
packages/shared/src/agent-signature.test.ts:74:      agentId: 'gem-hunter',
packages/shared/src/gem-signals.ts:4: * Writes high-value gem discoveries to docs/gem-hunter/signals.json
packages/shared/src/gem-signals.ts:29:const SIGNALS_PATH = join(process.cwd(), "docs/gem-hunter/signals.json");
packages/shared/src/__tests__/knowledge-reuse.test.ts:24:      gemName: 'gem-hunter-pattern',
packages/shared/src/__tests__/knowledge-reuse.test.ts:70:      expect(results[0].discovery.gemName).toBe('gem-hunter-pattern');
packages/shared/src/world-model.ts:49:  source: "gem-hunter" | "governance-drift" | "security-audit";
packages/shared/src/world-model.ts:200:        source: f.includes("governance") ? "governance-drift" : f.includes("security") ? "security-audit" : "gem-hunter",
packages/shared/src/world-model.ts:210:    const gemFile = execSync(`ls -t ${ROOT}/docs/gem-hunter/*.md 2>/dev/null | grep -v SSOT | head -1`, { encoding: "utf8" }).trim();
packages/shared/src/world-model.ts:216:        source: "gem-hunter",
packages/shared/src/world-model.ts:226:    const signalsPath = join(ROOT, 'docs/gem-hunter/signals.json');
packages/shared/src/world-model.ts:231:          source: 'gem-hunter',
TASKS_ARCHIVE_2026.md:33:- [x] **GH-089 [P1]**: Extrair scoring prompts hardcoded do `gem-hunter.ts:2274` → `docs/gem-hunter/prompts/scoring-v1.md` (versionado, editável sem deploy). | 2h ✅ 2026-04-08
TASKS_ARCHIVE_2026.md:39:- [x] **GH-095 [P1]**: `docs/gem-hunter/preferences.md` — SSOT de preferências co-editado Enio+AI: categorias valorizadas, red-flags, exemplos curados dos 8 posts analisados. | 2h ✅ 2026-04-08 ✅ 2026-04-08
apps/gem-hunter-landing/package.json:2:  "name": "@egos/gem-hunter-landing",
packages/shared/src/__tests__/integration.test.ts:213:// scoreGem is not exported, but we can validate its behavior by running gem-hunter
packages/shared/src/__tests__/integration.test.ts:352:  it("gem-hunter --dry exits 0 and prints version", () => {
packages/shared/src/__tests__/integration.test.ts:355:      ["run", "agent:run", "gem-hunter", "--dry"],
packages/shared/src/social/ai-engine.ts:2: * ai-engine.ts — Shim for gem-hunter and other discord-style agents.
apps/gem-hunter-landing/README.md:1:# gem-hunter-landing — Landing do Gem Hunter
apps/gem-hunter-landing/README.md:13:- `packages/gem-hunter/` — engine de descoberta
apps/gem-hunter-landing/README.md:14:- `apps/egos-gateway/src/channels/gem-hunter.ts` — API
apps/gem-hunter-landing/README.md:15:- `scripts/gem-hunter-digest.ts` — cron diário
apps/gem-hunter-landing/src/server.ts:112:app.get('/api/health', (c) => c.json({ ok: true, service: 'gem-hunter', port: PORT }))
docs/drafts/citation-verify-llms.md:41:<!-- FILL: checklist de verificação no article-writer.ts (commit sha, files), evidence-gate.ts para claims numéricas, gem-hunter para claims de originalidade. -->
docs/drafts/council1.md:1319:`agent-runtime`, `atomizer`, `atrian-observability`, `audit`, `auth`, `chatbot-core`, `core`, `eval-runner`, `gem-hunter`, `guard-brasil`, `knowledge-mcp`, `mcp-governance`, `mcp-memory`, `registry`, `report-standard`, `search-engine`, `shared`, `skill-discovery`, `types`.  
scripts/gem-feedback-bot.ts:10: * Callback data format (set by sendGemTelegramAlert in gem-hunter.ts):
docs/drafts/SKILL_X_001_skills_vs_agents_pt.md:53:3 padrões de implementação + exemplos reais (gem-hunter, guard-brasil, opus-mode).
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:20:| 3 | **5 repos ignorados** (Forja, Carteira-Livre, blueprint-egos, gem-hunter, 852) | Você listou no prompt da auditoria | Dashboard padrão proposto sem saber que Carteira-Livre tem 40 admin pages maduras |
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:86:| **gem-hunter** (discovery autônomo IA/Web3) | Bun + Hono + OpenRouter | v1.0 | **ALPHA** | ❌ Isolado |
docs/drafts/EGOS_MASTER_PLAN_MCP_SSOT_AI_ADMIN_TEMP.md:111:5. **`@egos/discovery-framework`** — extrair de gem-hunter. Multi-source + IA-scoring + async. Custo: ~20h. Vale como MCP futuro.
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:16:4. Exemplos reais (gem-hunter, guard-brasil, opus-mode)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:29:- `/gem-hunter` — dispara descoberta de oportunidades
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:45:# /gem-hunter
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:196:Component: /gem-hunter (slash command)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:198:Skill: gem-hunter-skill (reutilizável)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:200:Agent: gem-hunter-discovery (background)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:206:1. User digita `/gem-hunter crypto-pumped` (Slash Command)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:207:2. Ativa `gem-hunter-skill` (Skill)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:208:3. Que dispara o `gem-hunter-discovery` agent (Agent)
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:254:// 1. Define /gem-hunter in .claude/commands/gem-hunter.md
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:255:// 2. Implements logic in packages/skills/gem-hunter-skill/
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:256:// 3. Wraps agent in scripts/gem-hunter-agent.ts
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:258:// .claude/commands/gem-hunter.md
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:260:# /gem-hunter
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:268:// packages/skills/gem-hunter-skill/index.ts
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:276:// scripts/gem-hunter-agent.ts
docs/drafts/SKILL_ART_001_skills_vs_agents_pt.md:313:Não existe "certo" absoluto — existe **fit for purpose**. Um `/gem-hunter` é slash command, skill _e_ agent, tudo junto. O importante é reconhecer quando você está misturando responsabilidades e refatorar.
docs/opus-mode/OPUS_MODE_V1.md:183:Ao ativar Gem Hunter (existente em `agents/agents/gem-hunter.ts`, agora com 10 alvos):
docs/opus-mode/OPUS_MODE_V1.md:209:Saída em `docs/jobs/gem-hunter/YYYY-MM-DD-<slug>.md` ou row em `kb_pages` category `meta/gems`.
docs/opus-mode/OPUS_MODE_V1.md:456:| `/gem-hunter [scope]` | Ativa Gem Hunter nas 10 dimensões |
docs/drafts/SKILL_X_002_skills_vs_agents_en.md:55:3 implementation patterns + real examples (gem-hunter, guard-brasil, opus-mode).
docs/opus-mode/CYCLE_REPORT_TEMPLATE.md:174:- `agents/agents/gem-hunter.ts` — extensibilidade confirmada
docs/architecture/GPECAS_EGOS_GROWTH_ARCHITECTURE.md:133:| Gem Hunter por produtos | `@egos/gem-hunter` | Monitorar lançamentos fabricantes (Consul, Brastemp) |
docs/architecture/GPECAS_EGOS_GROWTH_ARCHITECTURE.md:230:| `gem-hunter` | Fase 4 (monitor fabricantes) |
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:16:4. Real examples (gem-hunter, guard-brasil, opus-mode)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:29:- `/gem-hunter` — triggers opportunity discovery
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:45:# /gem-hunter
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:196:Component: /gem-hunter (slash command)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:198:Skill: gem-hunter-skill (reusable)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:200:Agent: gem-hunter-discovery (background)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:206:1. User types `/gem-hunter crypto-pumped` (Slash Command)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:207:2. Activates `gem-hunter-skill` (Skill)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:208:3. Which triggers the `gem-hunter-discovery` agent (Agent)
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:254:// 1. Define /gem-hunter in .claude/commands/gem-hunter.md
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:255:// 2. Implement logic in packages/skills/gem-hunter-skill/
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:256:// 3. Wrap agent in scripts/gem-hunter-agent.ts
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:258:// .claude/commands/gem-hunter.md
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:260:# /gem-hunter
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:268:// packages/skills/gem-hunter-skill/index.ts
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:276:// scripts/gem-hunter-agent.ts
docs/drafts/SKILL_ART_002_skills_vs_agents_en.md:313:There is no absolute "right" — there is **fit for purpose**. A `/gem-hunter` is slash command, skill _and_ agent, all together. What matters is recognizing when you're mixing responsibilities and refactoring.
docs/_investigations/DISCONNECTED_SYSTEMS_ANALYSIS.md:137:- Gem Hunter está no registry (`gem-hunter` e `gem-hunter-api`)
scripts/gem-hunter-weekly-email.ts:134:  const filename = `gem-hunter-weekly-${slug}.md`
scripts/gem-hunter-weekly-email.ts:157:  const docsDir = join(import.meta.dir, '../docs/gem-hunter')
scripts/gem-hunter-weekly-email.ts:161:  console.log(`✅ Draft saved: docs/gem-hunter/${filename}`)
apps/_archived/egos-site-pre-v3-2026-05-07/src/content/posts/egos-showcase.md:164:- `curl https://gateway.egos.ia.br/gem-hunter/latest` → verify
apps/_archived/egos-site-pre-v3-2026-05-07/src/content/posts/egos-showcase.md:301:| `gem-hunter` | Descoberta de repos emergentes de IA | Scheduled |
docs/CROSS_REPO_CONTEXT_ROUTER.md:180:| [gem-hunter](https://github.com/enioxt/gem-hunter) | Descoberta de gems AI/Web3 | Público | — |
docs/CROSS_REPO_CONTEXT_ROUTER.md:181:| [gem-hunter-skill](https://github.com/enioxt/gem-hunter-skill) | Skill Claude Code para Gem Hunter | Público | — |
docs/_current_handoffs/handoff_2026-05-31-guarani-close.md:200:Nesta sessão, atualizamos os scripts do `package.json`, refinamos as queries de DeFi em `gem-hunter.ts` e executamos um live quick-run completo (`bun run gemhunter:quick`):
docs/_current_handoffs/handoff_2026-05-31-guarani-close.md:201:- **Resultado**: 206 gemas únicas encontradas e salvas em [`docs/gem-hunter/gems-2026-05-31.md`](../gem-hunter/gems-2026-05-31.md).
docs/_current_handoffs/handoff_2026-05-31-guarani-close.md:202:- **Histórico**: Banco de dados SQLite atualizado em [`docs/gem-hunter/history.db`](../gem-hunter/history.db).
docs/_current_handoffs/handoff_2026-05-31-eva-rename.md:35:- Working tree: SUJO — `.guarani/` symlink churn (não-meu-commit) + parallel: gem-hunter.ts, business/ renames, package.json, jobs/*.json, presentations slide (held-back)
docs/_current_handoffs/handoff_2026-05-27-action-plan.md:30:- **CI:** 17 workflows (auto-gen-guard, capability-eval, ci, codebase-miner-weekly, deploy-hq, gem-hunter-adaptive, governance-drift, health-check, portfolio-sync-daily, pr-review, publish-npm, publish-sdks, push-audit, security, spec-pipeline, vps-deploy-guard-brasil, weekly-health-check)
docs/_archived/2026-04/MONETIZATION_SSOT.md:139:- `docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md` — pricing section
docs/_archived/2026-04/MONETIZATION_SSOT.md:239:| **Gem Hunter** | MVP with API and 288 gems, good proof surface | Engine/research owner | Audience growth, developer distribution, API packaging, paid plan conversion | DevRel operator, technical creator, community builder | Devtools media/community or AI research membership business | Rev-share on subscriptions/API usage | **P1** | `agents/agents/gem-hunter.ts`, `docs/business/MONETIZATION_SSOT.md` |
apps/egos-gateway/README.md:5:Ponto de entrada central para todos os canais externos (WhatsApp, Telegram, web chat). Roteia mensagens para o orquestrador AI e expõe APIs de knowledge + gem-hunter.
apps/egos-gateway/README.md:15:| Gem Hunter API | `GET /gem-hunter/*` | ✅ prod |
apps/egos-gateway/README.md:62:│   ├── gem-hunter.ts  — Discovery engine API
docs/_current_handoffs/sync_2026-05-31_prime-to-guarani.md:9:- `8e5655c2` — consolidação outputs gem-hunter (sua janela).
docs/_current_handoffs/sync_2026-05-31_prime-to-guarani.md:23:| `guarani` | propõe diff, prototipa, roda evals/gem-hunter local, escreve casos de teste — deixa staged + handoff, **nunca commita** | GUARD-STD-002/007, casos red-team |
docs/_current_handoffs/sync_2026-05-31_prime-to-guarani.md:29:- GUARD-STD-002 — gem-hunter 8 queries (§5 do standard) + arxiv/reddit → shortlist frameworks (licença + fit Bun/TS + PT-BR).
docs/infra/VPS_RESTART_PLAYBOOK.md:37:| gem-hunter-landing | Up 3w | 3070 | Gem Hunter landing |
docs/infra/VPS_CONTAINER_ARCHITECTURE.md:75:| **gem-hunter-landing** | node:20 | 3w | 3070 | Gem Hunter landing page | ✅ HEALTHY |
docs/infra/VPS_CONTAINER_ARCHITECTURE.md:106:├── /gem → gem-hunter-landing:3070 (discovery)
docs/infra/VPS_CONTAINER_ARCHITECTURE.md:199:| (standalone GH) | gem-hunter-landing | Gem Hunter is frontend-only on VPS; logic in `packages/gem-hunter/` |
docs/infra/SUBDOMAINS_INVENTORY.md:38:| 9 | **gemhunter.egos.ia.br** | 200 | `gem-hunter-landing` | ✅ L79 | 3070 | Landing page do Gem Hunter | ✅ ATIVO | manter |
docs/infra/SUBDOMAINS_INVENTORY.md:90:| `gem-hunter-landing` | 3070 | gemhunter.egos.ia.br | `egos/apps/gem-hunter-landing` |
apps/egos-gateway/src/channels/telegram.ts:185:      // Trigger gem hunt via gem-hunter server — fire-and-forget
apps/egos-gateway/src/channels/ui.ts:321:ui.get("/gem-hunter", async (c) => {
docs/_archived/root-2026-03-blueprints/CODEX_MASTERY_GUIDE_2026-04-03.md:218:- Links back to gem-hunter.egos.ia.br dashboard
docs/_archived/root-2026-03-blueprints/CODEX_MASTERY_GUIDE_2026-04-03.md:255:Target: gem-hunter.egos.ia.br live with 3 example repos"
notebooklm_export_egos.md:212:  gem-hunter-secops.ts
notebooklm_export_egos.md:303:## File: scripts/gem-hunter-secops.ts
notebooklm_export_egos.md:326:  const reportPath = path.join(process.cwd(), 'docs', 'gem-hunter', `secops-${today}.md`);
notebooklm_export_egos.md:3314:- gem-hunter agent "device-bridge" search track (removed)
notebooklm_export_egos.md:3333:- `agents/agents/gem-hunter.ts` — device-bridge track removed
notebooklm_export_egos.md:7913:| 25 | `gem_hunter` | Gem Hunter | knowledge | 2026-03-06 | `e0f2d7a` | agents/agents/gem-hunter.ts | active | 4 | kernel |
notebooklm_export_egos.md:8393:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
notebooklm_export_egos.md:8394:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
notebooklm_export_egos.md:8421:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
notebooklm_export_egos.md:8422:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
notebooklm_export_egos.md:11428:        "agents/agents/gem-hunter.ts"
notebooklm_export_egos.md:11635:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
notebooklm_export_egos.md:11646:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
notebooklm_export_egos.md:11695:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
notebooklm_export_egos.md:11757:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
notebooklm_export_egos.md:11779:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
notebooklm_export_egos.md:11830:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
notebooklm_export_egos.md:11990:        "scripts/gem-hunter-freshness.ts"
notebooklm_export_egos.md:12410:      "entrypoint": "agents/agents/gem-hunter.ts"
notebooklm_export_egos.md:12747:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
notebooklm_export_egos.md:12758:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
notebooklm_export_egos.md:13834:| **Substantial (>200 lines, real I/O)** | 12 | ssot-auditor (3075!), gem-hunter (967), security-scanner (626) |
notebooklm_export_egos.md:13841:`gem-hunter`, `orchestrator`, `report-generator`, `social-media` — these have `runner:0`, meaning they bypass the agent runtime entirely. They're legacy scripts wearing agent costumes.
notebooklm_export_egos.md:13854:| **Leave in egos-lab** | ~7 | App-specific (gem-hunter, orchestrator, report-generator) |
notebooklm_export_egos.md:13946:> Primary evidence: `gem-hunter` focused run + GitHub/Exa research
notebooklm_export_egos.md:13952:A focused `gem-hunter` track was added in `egos-lab` for:
notebooklm_export_egos.md:13971:- `/home/enio/egos-lab/docs/gem-hunter/gems-2026-03-14.md`
notebooklm_export_egos.md:18897:**Task:** Consolidar gem-hunter dailies (LAB-ARCHIVE-001)
notebooklm_export_egos.md:23416:| egos-lab | mycelium.md | 98 lines (custom) | 46 lines | LEGITIMATE — lab has session:guard, gem-hunter, worker surfaces |
notebooklm_export_egos.md:23433:4. Repo-role-aware session:guard/gem-hunter/report-generator
notebooklm_export_egos.md:23786:| App-specific agents | `gem-hunter`, `report-generator` |
notebooklm_export_egos.md:25031:> **Repo-role:** Check `egos.config.json` for `role` and `surfaces`. If absent, assume `leaf` and skip surfaces like gem-hunter, report-generator, session:guard, and activation:check.
notebooklm_export_egos.md:25124:| Gem Hunter SecOps | `ls -t docs/gem-hunter/secops-*.md 2>/dev/null \| xargs grep -l UNMITIGATED` | YES (BLOCKING) | Must mitigate CVEs first |
notebooklm_export_egos.md:25129:| Gem Hunter | `ls -t docs/gem-hunter/gems-*.md 2>/dev/null \| head -1` | Research sessions in repos that ship Gem Hunter | Suggest if > 7 days old |
notebooklm_export_egos.md:25134:- **[NEW] SecOps Gate**: If a critical zero-day is found in `docs/gem-hunter/secops-*.md`, the agent MUST abort the start and instruct the user to mitigate the CVE immediately.
notebooklm_export_egos.md:25139:- Kernel repos may not expose `session:guard`, `docs/gem-hunter`, or `docs/reports`; treat them as optional surfaces, not activation blockers
notebooklm_export_egos.md:25153:- **Research:** Latest gem-hunter/report state or `N/A` for kernel repos without those surfaces
notebooklm_export_egos.md:26031:The agent MUST run a vulnerability scan / check `package.json` logic or `grep UNMITIGATED docs/gem-hunter/secops-*.md`.
notebooklm_export_egos.md:26652:- [x] EGOS-041: Align `/start` with core repo reality — remove or gate stale checks for `docs/SYSTEM_MAP.md`, `session:guard`, `docs/gem-hunter`, and `docs/reports`
docs/_archived/root-2026-03-blueprints/STRATEGIC_FOCUS_PLAN_2026-04-03.md:132:- **Landing:** gem-hunter.egos.ia.br (beautiful dashboard)
docs/_archived/root-2026-03-blueprints/STRATEGIC_FOCUS_PLAN_2026-04-03.md:158:- [ ] Deploy Gem Hunter landing (gem-hunter-website GitHub → Vercel)
docs/_archived/root-2026-03-blueprints/STRATEGIC_FOCUS_PLAN_2026-04-03.md:174:- [ ] Deploy first version to gem-hunter.egos.ia.br
docs/_archived/root-2026-03-blueprints/STRATEGIC_FOCUS_PLAN_2026-04-03.md:249:   - Link to gem-hunter.egos.ia.br dashboard
apps/egos-gateway/src/channels/gem-hunter-api.ts:5: * Backed by pre-computed reports (latest-run.json, SQLite history).
apps/egos-gateway/src/channels/gem-hunter-api.ts:8: *   GET  /gem-hunter/topics        — list all search topic categories
apps/egos-gateway/src/channels/gem-hunter-api.ts:9: *   GET  /gem-hunter/latest        — latest run: top gems by score
apps/egos-gateway/src/channels/gem-hunter-api.ts:10: *   GET  /gem-hunter/reports       — list available report files
apps/egos-gateway/src/channels/gem-hunter-api.ts:11: *   GET  /gem-hunter/sector/:name  — filter latest results by sector keyword
apps/egos-gateway/src/channels/gem-hunter-api.ts:12: *   GET  /gem-hunter/trending      — trending from SQLite history (multi-run)
apps/egos-gateway/src/channels/gem-hunter-api.ts:13: *   GET  /gem-hunter/health        — API health + last run info
apps/egos-gateway/src/channels/gem-hunter-api.ts:32:const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
apps/egos-gateway/src/channels/gem-hunter-api.ts:33:const LATEST_RUN_PATH = join(REPORTS_DIR, "latest-run.json");
apps/egos-gateway/src/channels/gem-hunter-api.ts:236:// ── Static topic definitions (mirrors gem-hunter.ts DEFAULT_QUERIES categories) ──
apps/egos-gateway/src/channels/gem-hunter-api.ts:278:      upgrade: "https://gateway.egos.ia.br/gem-hunter/product",
apps/egos-gateway/src/channels/gem-hunter-api.ts:301:    service: "gem-hunter-api",
apps/egos-gateway/src/channels/gem-hunter-api.ts:308:    docs: "/gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:335:  if (!run) return c.json({ error: "No latest run found. Run: bun agent:run gem-hunter --exec" }, 404);
apps/egos-gateway/src/channels/gem-hunter-api.ts:414:    return c.json({ message: "No history database yet — run gem-hunter a few times to build trends", trending: [] });
apps/egos-gateway/src/channels/gem-hunter-api.ts:466:      topics: "GET /gem-hunter/topics",
apps/egos-gateway/src/channels/gem-hunter-api.ts:467:      latest: "GET /gem-hunter/latest?sector=ai&limit=20",
apps/egos-gateway/src/channels/gem-hunter-api.ts:468:      sector: "GET /gem-hunter/sector/{ai|crypto|systems|agents|governance|research}",
apps/egos-gateway/src/channels/gem-hunter-api.ts:469:      trending: "GET /gem-hunter/trending",
apps/egos-gateway/src/channels/gem-hunter-api.ts:470:      reports: "GET /gem-hunter/reports",
scripts/governance/ssot-crosslink-validator.ts:42:  "docs/gem-hunter",
apps/egos-gateway/src/orchestrator.ts:266:    const res = await fetch(`${GW}/gem-hunter/health`, { signal: AbortSignal.timeout(3000) });
apps/egos-gateway/src/orchestrator.ts:338:      ? `${GW}/gem-hunter/sector/${sector}`
apps/egos-gateway/src/orchestrator.ts:339:      : `${GW}/gem-hunter/latest?limit=5`;
apps/egos-gateway/src/orchestrator.ts:341:    if (!res.ok) return "💎 Gem Hunter sem dados. Rode: bun agent:run gem-hunter --exec";
apps/egos-gateway/src/orchestrator.ts:357:    const res = await fetch(`${GW}/gem-hunter/trending`, { signal: AbortSignal.timeout(5000) });
apps/egos-gateway/src/orchestrator.ts:361:    if (!gems.length) return "Sem trending (precisa de 2+ runs do gem-hunter).";
apps/egos-gateway/src/server.ts:11: *   GET  /gem-hunter/*          — Gem Hunter API (discovery engine)
apps/egos-gateway/src/server.ts:25:import { gemHunter } from "./channels/gem-hunter-api.js";
apps/egos-gateway/src/server.ts:48:    channels: ["whatsapp", "telegram", "knowledge", "gem-hunter", "guard-brasil-x402", "api-mestra-v1"],
apps/egos-gateway/src/server.ts:55:      "gem-hunter": "/gem-hunter/product",
apps/egos-gateway/src/server.ts:66:app.route("/gem-hunter", gemHunter);
apps/egos-gateway/src/server.ts:99:console.log(`[egos-gateway] Gem Hunter:  http://localhost:${PORT}/gem-hunter/health`);
apps/egos-gateway/src/health-monitor.ts:69:    pingUrl(`${GW_INTERNAL}/gem-hunter/health`).then(r => ({ name: "Gem Hunter", ...r })),
docs/CAPABILITY_REGISTRY.md:118:| **PRODUCTION: gem-hunter** | AI Discovery Layer, GitHub/HF/npm scanning, Gem Hunter API tiers | §2, §11 |
docs/CAPABILITY_REGISTRY.md:365:| **Gem Hunter Partner Track** | `docs/gem-hunter/SSOT.md` → partner/community track | C | egos (planned) | — | `gtm`, `gem-hunter`, `discovery` |
docs/CAPABILITY_REGISTRY.md:378:| **Pramana Confidence System** (Fact/Inference/Disputed/Unknown) | `egos-inteligencia/frontend/src/lib/intelligence/confidence-system.ts` | A | egos-inteligencia | egos (rule global), guard-brasil, gem-hunter, 852 | `epistemology`, `trust`, `ui`, `evidence`, `pramana` |
docs/CAPABILITY_REGISTRY.md:379:| **Sacred Math Scoring** (razão áurea φ para confidence) | `egos-inteligencia/api/src/egos_inteligencia/services/patterns/pattern_detector.py` | A | egos-inteligencia | egos (extract to package), gem-hunter | `scoring`, `pattern-detection`, `phi`, `fibonacci` |
docs/CAPABILITY_REGISTRY.md:436:| **Auditable Live Sandbox** | `docs/patterns/AUDITABLE_SANDBOX_PATTERN.md` | A | guard-brasil-web (LIVE) | gem-hunter-web, eagle-eye-web, kb-api | `sandbox`, `ux`, `pattern`, `trust` |
docs/CAPABILITY_REGISTRY.md:439:| **Session Audit Trail Export** | `sandbox-client.tsx:exportAudit()` | A | guard-brasil-web | eagle-eye, gem-hunter | `audit`, `compliance`, `export` |
docs/CAPABILITY_REGISTRY.md:452:| **Gem Hunter deps-watch** | `agents/agents/gem-hunter.ts` → SearchTrack deps-watch | B | egos (manual) | — | `dx`, `deps`, `monitoring` |
docs/CAPABILITY_REGISTRY.md:607:| Gem Hunter API Key Auth | `egos-gateway/src/channels/gem-hunter-api.ts` | A | egos | `auth`, `sha256`, `supabase`, `middleware` |
docs/CAPABILITY_REGISTRY.md:608:| Gem Hunter Rate Limiting | `gem-hunter-api.ts#checkAndIncrementUsage` | A | egos | `rate-limit`, `tier`, `usage-tracking` |
docs/CAPABILITY_REGISTRY.md:610:| Telegram /hunt /sector /trending | `egos-gateway/src/channels/telegram.ts` | A | egos | `telegram`, `slash-commands`, `gem-hunter` |
docs/CAPABILITY_REGISTRY.md:612:| Gem Hunter Dashboard (inline SSR) | `agents/api/gem-hunter-server.ts` | A | egos | `dashboard`, `bun`, `ssr`, `gem-hunter` |
docs/CAPABILITY_REGISTRY.md:615:| Gem Signal Auto-append | `agents/agents/gem-hunter.ts` + `gem-signals.ts` | A | egos | `signals`, `world-model`, `gem-hunter`, `intel` |
docs/CAPABILITY_REGISTRY.md:725:1. **ARR-001**: `import { AtomizerCore } from '@egos/atomizer'` in gem-hunter pipeline
docs/CAPABILITY_REGISTRY.md:960:  agentId: 'gem-hunter',
docs/CAPABILITY_REGISTRY.md:3193:## §99 — gem-hunter-landing — Landing gem.egos.ia.br (2026-05-27 cataloged)
docs/CAPABILITY_REGISTRY.md:3196:> **Path:** `apps/gem-hunter-landing/`
docs/CAPABILITY_REGISTRY.md:3198:> **Evidence:** `apps/gem-hunter-landing/README.md` (Status ✅ Ativo, URL gem.egos.ia.br) + `apps/gem-hunter-landing/package.json` (`@egos/gem-hunter-landing` v0.1.0) + `apps/gem-hunter-landing/Dockerfile`
docs/CAPABILITY_REGISTRY.md:3203:Landing page do Gem Hunter — sistema de descoberta de ferramentas/repos relevantes para o EGOS. HTML estático servido por Bun. Deploy via Caddy. Complementa `packages/gem-hunter/` (engine) + `apps/egos-gateway/src/channels/gem-hunter.ts` (API) + `scripts/gem-hunter-digest.ts` (cron diário).
docs/CAPABILITY_REGISTRY.md:3206:- Code: `apps/gem-hunter-landing/src/`
docs/CAPABILITY_REGISTRY.md:3208:- Docs: `apps/gem-hunter-landing/README.md`
docs/CAPABILITY_REGISTRY.md:3213:**Tags:** `landing`, `gem-hunter`, `bun`, `caddy`, `discovery`
docs/_archived/root-2026-03-blueprints/BLUEPRINT_EXECUTION_PLAN.md:218:  - ✅ Agent: `agents/agents/mastra-gem-hunter.ts`
docs/_archived/root-2026-03-blueprints/BLUEPRINT_EXECUTION_PLAN.md:230:  - File: `agents/agents/mastra-gem-hunter.ts` (executable)
docs/_archived/root-2026-03-blueprints/BLUEPRINT_EXECUTION_PLAN.md:732:│   ├── mastra-gem-hunter.ts ✅
docs/_archived/root-2026-03-blueprints/WEEK_ONE_EXECUTION_2026-04-03.md:81:- Link to gem-hunter.egos.ia.br dashboard
docs/_archived/root-2026-03-blueprints/WEEK_ONE_EXECUTION_2026-04-03.md:115:**Deliverable:** gem-hunter.egos.ia.br live with 3 example repos
docs/_archived/root-2026-03-blueprints/WEEK_ONE_EXECUTION_2026-04-03.md:120:"Create Gem Hunter dashboard at gem-hunter.egos.ia.br:
docs/_archived/root-2026-03-blueprints/WEEK_ONE_EXECUTION_2026-04-03.md:195:gem-hunter.egos.ia.br (free analysis)
docs/jobs/2026-05-04-code-security.md:43:| `apps/egos-gateway/src/channels/gem-hunter-api.ts` | 535 | API client integration |
docs/jobs/2026-05-04-code-security.md:72:- `agents/agents/gem-hunter.ts:2375` — Skeleton generation prompt
scripts/scoring-feedback-reader.ts:212:      `- [ ] **GH-AUTO-${today.replace(/-/g, "")}A [P1]**: Fix false positive pattern — ${names} scored high but got 👎. Review scoring-v1.md heuristics. File: \`agents/agents/gem-hunter.ts:1778\`.`
scripts/scoring-feedback-reader.ts:220:      `- [ ] **GH-AUTO-${today.replace(/-/g, "")}B [P1]**: Fix hidden gem undervaluation — ${names} got 👍 despite low score. Consider +bonus in scoreGem(). File: \`docs/gem-hunter/prompts/scoring-v1.md\`.`
scripts/scoring-feedback-reader.ts:227:      `- [ ] **GH-AUTO-${today.replace(/-/g, "")}C [P0]**: Gem quality degraded — approval rate ${analysis.approvalRate}% (below 40%). Review isXSignalRelevant() and scoring thresholds. File: \`agents/agents/gem-hunter.ts\`.`
docs/_archived/root-2026-03-blueprints/COMPLETE_REPO_INVENTORY_2026-04-03.md:34:- **Location:** docs/gem-hunter/ + scripts/
docs/jobs/2026-05-15-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-15-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
scripts/kol-discovery.ts:4: * scores signal quality, and outputs docs/gem-hunter/kol-list.json.
scripts/kol-discovery.ts:281:  const outPath = join(process.cwd(), 'docs', 'gem-hunter', 'kol-list.json');
docs/jobs/2026-05-05-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-05-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
scripts/obs-central.test.ts:68:xyz789         gem-hunter  0.05%     28MiB / 1GiB          2.73%     800B / 600B     0B / 0B     8`;
scripts/obs-central.test.ts:76:      expect(result[1].name).toBe("gem-hunter");
docs/jobs/obs-2026-04-15.md:21:| 🟢 gem-hunter-api | running | 1.2% | 120MB / 256MB |
docs/jobs/obs-2026-04-15.md:31:| 🟢 gem-hunter-api | up | 1024ms |
docs/jobs/obs-2026-04-15.md:47:[08:30] gem-hunter-cron.sh — Discovery completed (12 gems found)
docs/jobs/2026-06-01-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-06-01-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/world-model/current.json:147:        "text": "- [ ] GH-067: Deploy gem-hunter-server to VPS (gemhunter.egos.ia.br) + Caddy routing → P0 revenue",
docs/world-model/current.json:154:        "text": "- [ ] GH-070: Chatbot orchestrator — WhatsApp channel NLP intent → tool calls → gem-hunter → curated reply",
docs/world-model/current.json:277:        "id": "gem-hunter",
docs/world-model/current.json:287:        "id": "gem-hunter-api",
docs/world-model/current.json:289:        "description": "Standalone REST API for gem-hunter (Phase 1 product). Endpoints: GET /v1/finding"
docs/world-model/current.json:299:        "description": "Compiles raw sources (handoffs, job reports, gem-hunter, strategy docs) into str"
docs/world-model/current.json:448:      "source": "gem-hunter",
docs/world-model/current.json:454:      "source": "gem-hunter",
docs/world-model/current.json:460:      "source": "gem-hunter",
docs/world-model/current.json:466:      "source": "gem-hunter",
docs/world-model/current.json:472:      "source": "gem-hunter",
docs/world-model/current.json:478:      "source": "gem-hunter",
docs/world-model/current.json:484:      "source": "gem-hunter",
docs/world-model/current.json:490:      "source": "gem-hunter",
docs/world-model/current.json:496:      "source": "gem-hunter",
docs/world-model/current.json:502:      "source": "gem-hunter",
docs/world-model/current.json:508:      "source": "gem-hunter",
docs/world-model/current.json:514:      "source": "gem-hunter",
docs/world-model/current.json:520:      "source": "gem-hunter",
docs/world-model/current.json:526:      "source": "gem-hunter",
docs/world-model/current.json:532:      "source": "gem-hunter",
docs/world-model/current.json:538:      "source": "gem-hunter",
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:18:gem-hunter
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:71:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:105:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:139:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:189:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:266:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:332:Pacotes reais confirmados (histórico de verificação branch 3cc179ac2207522f164760bcada8d15d2d2fec47): agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:391:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:451:Pacotes reais confirmados em verificações anteriores (branch referência 3cc179ac2207522f164760bcada8d15d2d2fec47): agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/grokchat_draft-excerpt.md:502:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived/superseded-2026-05-30/TASKS_ARCHIVE_2026_BACKUP.md:119:- [x] EGOS-138: aiox-gem-hunter — **KILLED** (too niche, single-repo scanner for SynkraAI)
docs/_archived/superseded-2026-05-30/TASKS_ARCHIVE_2026_BACKUP.md:121:- [x] EGOS-140: mastra-gem-hunter — **KILLED** (too niche, single-repo scanner for mastra-ai)
docs/_archived/superseded-2026-05-30/TASKS_ARCHIVE_2026_BACKUP.md:149:- [x] agents.json updated for gem-hunter v3.2
docs/discovery/RETAIL_CAPABILITIES.md:142:- **Capacidade:** 20+ agent skills .ts em produção (gem-hunter, article-writer, daily-knowledge-sync, drive-sync, gmail-sync, calendar-sync, etc)
docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:91:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:122:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/public/STATUS_PAGE.md:110:2026-04-11 09:17 | Guard Brasil | 23 min | Root cause: VPS CPU spike from gem-hunter scan
scripts/gem-hunter-digest.ts:13://   bun run scripts/gem-hunter-digest.ts              # last 7 days, live
scripts/gem-hunter-digest.ts:14://   bun run scripts/gem-hunter-digest.ts --dry-run    # generate only, no save/send
scripts/gem-hunter-digest.ts:15://   bun run scripts/gem-hunter-digest.ts --days 14    # look back 14 days
scripts/gem-hunter-digest.ts:44:const DIGEST_DIR = "/home/enio/egos/docs/gem-hunter";
scripts/gem-hunter-digest.ts:247:  lines.push(`*Generated at ${new Date().toISOString()} by gem-hunter-digest.ts (GH-074)*`);
scripts/status-snapshot.ts:149:    const res = await fetch(`${GATEWAY_URL}/gem-hunter/health`, {
docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:91:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:122:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
scripts/lib/agent-event.ts:21:  source: string;          // e.g. 'morning-report', 'gem-hunter', 'doc-drift'
docs/jobs/_archived/2026-04/2026-04-08-doc-drift-verifier.json:91:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-08-doc-drift-verifier.json:122:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/agents/agent-registry.md:42:| **gem-hunter** | Gem Hunter v6.0 | Intelligence | `bun agent:run gem-hunter --dry` | ✅ Active |
docs/agents/gem-hunter.md:2:> **ID:** `gem-hunter` | **Status:** active | **Area:** intelligence | **Risk:** T1  
docs/agents/gem-hunter.md:3:> **Entrypoint:** `agents/agents/gem-hunter.ts`  
docs/agents/gem-hunter.md:11:bun agents/agents/gem-hunter.ts --dry
docs/jobs/_archived/2026-04/2026-04-23-code-security.md:16:| `agents/agents/gem-hunter.ts` | 2,537 | Agent | **HIGH** — break into skill + runner |
docs/jobs/_archived/2026-04/2026-04-23-code-security.md:27:| `apps/egos-gateway/src/channels/gem-hunter-api.ts` | 535 | Channel | **MEDIUM** — endpoint consolidation |
docs/jobs/_archived/2026-04/2026-04-23-code-security.md:30:**Recommendation:** `ssot-auditor.ts` and `gem-hunter.ts` should be decomposed. Refactor by extracting skill modules and reducing class complexity. No blocker for shipping.
docs/jobs/_archived/2026-04/2026-04-23-code-security.md:42:- `agents/agents/gem-hunter.ts`: 1 (research skeleton generation)
docs/jobs/_archived/2026-04/2026-04-23-code-security.md:186:- `gem-hunter.ts` (2,537 LOC) imports 20+ modules
docs/agents/inception.md:77:| 8. Gem-hunter | `bun agents/agents/gem-hunter.ts --query "<domain>"` | Ferramentas/repos descobertos |
docs/jobs/_archived/2026-04/2026-04-25-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-25-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/research/plugplay-governance-landscape-2026-03-14.md:5:> Primary evidence: `gem-hunter` focused run + GitHub/Exa research
docs/research/plugplay-governance-landscape-2026-03-14.md:11:A focused `gem-hunter` track was added in `egos-lab` for:
docs/research/plugplay-governance-landscape-2026-03-14.md:30:- `/home/enio/egos-lab/docs/gem-hunter/gems-2026-03-14.md`
docs/jobs/2026-05-01-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-01-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-07-doc-drift-verifier.json:91:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-07-doc-drift-verifier.json:122:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/agents/wiki-compiler.md:7:Compiles raw sources (handoffs, job reports, gem-hunter, strategy docs) into structured wiki pages in Supabase. Karpathy LLM Wiki pattern: ingest → compile → lint. Also records learnings for data flywheel.
docs/jobs/codebase-mining-2026-04-09.md:135:**`agents/agents/gem-hunter.ts`** (1)
docs/jobs/codebase-mining-2026-04-09.md:193:**`docs/gem-hunter/SSOT.md`** (1)
docs/jobs/_archived/2026-04/2026-04-29-vps-health-audit.md:35:- gem-hunter-landing (Up 3w)
docs/jobs/_archived/2026-04/2026-04-29-vps-health-audit.md:112:  - NodeJS: egos-gateway, 852-app, gem-hunter-landing
docs/jobs/2026-05-07-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-07-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-17-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-17-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/agents/end.md:352:bun agents/agents/gem-hunter.ts --query "<topic>" --dry 2>/dev/null | tail -10
docs/jobs/_archived/2026-04/2026-04-22-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-22-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/ORGANIZATION_BACKLOG_2026-05-30.md:34:- [~] **ORG-B4** Out-of-scope **Intelink/OSINT** — DECISÃO: holding. ⚠️ BLOQUEADO: NÃO órfão — `docs/strategy/ROADMAP.md` referencia OSINT_BRASIL_TOOLKIT, partner-brief referencia INTELIGENCIA_TOPOLOGY, gem-hunter referencia INTELINK_LLM_PLAN. Mover quebraria links ativos. Precisa: atualizar refs OU manter. Decidir junto. (Sweep agent reportou "no refs" — incorreto.)
docs/jobs/ENC-L1-006-agent-execution-evidence.md:28:| 2026-04-09 | Gem Hunter Adaptive | `6bf9616` | `chore(gem-hunter): adaptive scan 2026-04-09 + LangGraph pair study (score 83/100)` |
scripts/rapid-response.ts:178:      { name: "gem-hunter", url: "https://gemhunter.egos.ia.br", desc: "AI tool discovery dashboard" },
docs/jobs/_archived/2026-04/2026-04-18-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-18-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/agents/INDEX.md:19:| [gem-hunter](gem-hunter.md) | Gem Hunter v6.0 | ✅ active | intelligence | 2537 | `bun agents/agents/gem-hunter.ts --dry` |
docs/agents/INDEX.md:21:| [gem-hunter-api](gem-hunter-api.md) | Gem Hunter API | ✅ active | intelligence | 428 | `bun agents/api/gem-hunter-server.ts` |
docs/audits/KERNEL_AUDIT.md:95:| `safe-push.sh` for automation | **PROVEN** | All cron scripts use it (verified in gem-hunter-adaptive.yml) |
docs/jobs/2026-05-21-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-21-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-26-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-26-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/agents/gem-hunter-api.md:2:> **ID:** `gem-hunter-api` | **Status:** active | **Area:** intelligence | **Risk:** T1  
docs/agents/gem-hunter-api.md:3:> **Entrypoint:** `agents/api/gem-hunter-server.ts`  
docs/agents/gem-hunter-api.md:7:Standalone REST API for gem-hunter (Phase 1 product). Endpoints: GET /v1/findings, /v1/papers, /v1/signals, /v1/kols; POST /v1/hunt. Port 3097.
docs/agents/gem-hunter-api.md:11:bun agents/api/gem-hunter-server.ts
docs/jobs/_archived/2026-04/2026-04-16-code-security.md:32:| `apps/egos-gateway/src/channels/gem-hunter-api.ts` | 535 | ✅ | Channel adapter — single responsibility |
docs/jobs/_archived/2026-04/2026-04-16-code-security.md:56:- ✅ **3 in gem-hunter.ts** reference: "generate skeleton with TODO comments" — design pattern, not debt.
docs/jobs/2026-05-25-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-25-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-30-code-security-audit.md:21:| apps/egos-gateway/src/channels/gem-hunter-api.ts | 535 | Integration |
docs/jobs/_archived/2026-04/2026-04-30-code-security-audit.md:36:- `agents/agents/gem-hunter.ts` — 1 (skeleton generation)
docs/jobs/2026-05-06-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-06-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-26-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-26-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-28-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-28-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-09-code-security.md:22:3. **apps/egos-gateway/src/channels/gem-hunter-api.ts** (535 LOC) — Gem Hunter channel
docs/jobs/_archived/2026-04/2026-04-27-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-27-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-09-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-09-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/fantom-skills-2026-05-21.md:130:- **Dependências externas:** `agents/agents/article-writer.ts` (EXISTE), `agents/agents/gem-hunter.ts` (EXISTE), Supabase `timeline_drafts`, Guard Brasil scan.
docs/audits/fantom-skills-2026-05-21.md:166:- **Dependências externas:** `docs/personal-os/ENIO_UNDERSTANDING_MAP.md`, `mcp__exa__web_search_exa`, `agents/agents/gem-hunter.ts`, `docs/inception_reports/`.
docs/jobs/_archived/2026-04/2026-04-24-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-24-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-30-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-30-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-15-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-15-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
scripts/paperclip-register-agents.ts:37:  { id: "gem-hunter", title: "Gem Hunter", role: "Director", reports_to: "egos-kernel" },
docs/jobs/_archived/2026-04/2026-04-09-doc-drift-verifier.json:91:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-09-doc-drift-verifier.json:122:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/CROSS_REPO_AUDIT_2026-05-30.md:10:**Ativos EGOS-leaf:** egos (este), egos-lab, egos-governance, egos-cortex, egos-self, egos-lab-chat, egos-rules, intelink, intelink-platform, intelink-agente, 852, FORJA, DHPP, carteira-livre, gem-hunter, omniview, pixelart, santiago, smartbuscas, ARCH, BLUEPRINT-EGOS, guard-brasil-skill, gem-hunter-skill, egos-governance-skill, awesome-gems.
docs/jobs/_archived/2026-04/2026-04-27-code-security.md:21:| agents/agents/gem-hunter.ts | 2,537 | Agent | ML paper analysis — feature-rich |
docs/jobs/_archived/2026-04/2026-04-27-code-security.md:41:| agents/agents/gem-hunter.ts | 2375 | TODO in generated prompt (meta-TODO) |
docs/audits/2026-05-29-provenance-inventory.md:142:- Skills auto-research (e.g. `/research`, `gem-hunter`, `recon`) passam a emitir `source_fingerprint` no output.
docs/jobs/_archived/2026-04/2026-04-14-doc-drift-verifier.json:191:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-14-doc-drift-verifier.json:222:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-23-doc-drift-verifier.json:192:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-23-doc-drift-verifier.json:223:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/ROADMAP.md:315:- [ ] **DOCS-GH-001 [P2]**: gem-hunter README + CLAUDE.md (faltam) | 1h
docs/audits/SYSTEM_MAP_AUDIT_2026-05-30.md:48:| `apps/gem-hunter-landing/` | Active |
docs/jobs/_archived/2026-04/2026-04-29-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-29-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/premortem-gem-hunter-refound.md:1:# Premortem — gem-hunter refundação + integração total
docs/audits/premortem-gem-hunter-refound.md:3:> Gerado via `/premortem` 2026-05-30. Decisão: refundar o score do gem-hunter e integrá-lo no EGOS.
docs/audits/premortem-gem-hunter-refound.md:20:| F1 | Desvio de foco: gem-hunter (não-Single-Pursuit) consome semanas do Central EGOS; R$10k MRR escorrega | A | A | TASKS.md enche de GH-* P0; commits Central EGOS param |
docs/audits/premortem-gem-hunter-refound.md:25:| F6 | "Integrar em tudo" = acoplamento: skills/buscas do kernel dependem do gem-hunter; ele cai e leva Central EGOS junto | M | A | imports de gem-hunter em código do kernel não relacionado |
docs/audits/premortem-gem-hunter-refound.md:30:- **F1** → fatias independentes <1 sessão Sonnet; gem-hunter continua P2; nenhuma fatia abre P0 competindo com Central EGOS. Sentinela: /start flag se GH-* P0 > 0 com Central EGOS P0 aberto. Rollback: parar após fatia 1.
docs/audits/premortem-gem-hunter-refound.md:35:- **F6** → integração SÓ via interface estável (MCP tool/API), nunca import direto de gem-hunter.ts no kernel; gem-hunter é consumido, não embutido; falha dele = degradação graciosa. Sentinela: grep `from ...gem-hunter` em packages/apps.
docs/audits/premortem-gem-hunter-refound.md:56:**Regra de ouro:** gem-hunter é consumido via interface, nunca embutido no kernel; continua P2 atrás do Central EGOS; deploy de rede e "integrar em tudo" exigem corte explícito do Enio.
docs/audits/premortem-gem-hunter-refound.md:65:- `scoreGem()` **já é limitado 0-100** — `agents/agents/gem-hunter.ts:1934` retorna `Math.min(100, Math.max(0, Math.round(score)))`; `SCORE_MODEL_VERSION="v2-bounded"` (`:1847`). NÃO é "aditivo ilimitado".
docs/audits/premortem-gem-hunter-refound.md:66:- `docs/gem-hunter/weights.yaml` (cabeçalho, scope clarificado 2026-05-30) documenta **explicitamente** que os dois modelos são estágios DIFERENTes e intencionalmente separados: `scoreGem` = triagem rápida sobre centenas (L1 discovery); `weights.yaml` = rubrica humana ao estudar 1 repo shortlisted. Texto literal: *"Do not treat the two as one model."*
docs/audits/premortem-gem-hunter-refound.md:70:- `grep "3097"` em `/home/enio/gem-hunter` e no kernel → **zero ocorrências**. Não há artefato build na porta 3097 visível. Confirma o adiamento da slice #6 e reforça F5: não existe API pronta — existe a *ideia* de uma. Marcar `[CONCEPT]`, não `[DONE]`.
docs/audits/premortem-gem-hunter-refound.md:73:- A maioria dos matches de `gem-hunter` são **git worktrees** (`.windsurf/worktrees/`, `.claude/worktrees/`) — checkouts transientes do mesmo repo, NÃO drift independente. Não consolidar worktrees; eles somem com a sessão.
docs/audits/premortem-gem-hunter-refound.md:74:- Cópias reais distintas (tamanho real `du -sh`): standalone `/home/enio/gem-hunter` **424K** (plano dizia 15K); `egos/docs/gem-hunter` **772K** (plano dizia 105K canonical); `egos-lab/docs/gem-hunter` **1.3M** — *maior* que o kernel, não "stale 61K"; `852/docs/gem-hunter` 8K.
docs/audits/SECURITY_BASELINE.md:39:| **gem-hunter-landing** | 3 ALTAS | Idem as gateway | ✅ FIXED | Hono ^4.12.16 | 2026-04-30 |
docs/audits/SECURITY_BASELINE.md:78:- Upgraded Hono ^4.6.0 → ^4.12.16 in egos-gateway, gem-hunter-landing
docs/jobs/_archived/2026-04/2026-04-30-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/_archived/2026-04/2026-04-30-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/ECOSYSTEM_AUDIT.md:23:| **Publicado (npm `egosbr`)** | `@egosbr/*` | SIM | `@egosbr/guard-brasil`, `@egosbr/knowledge-mcp`, `@egosbr/gem-hunter`, `@egosbr/guard-brasil-mcp`, `@egosbr/guard-brasil-langchain` |
docs/jobs/2026-05-17-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-17-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/instagram/INSTAGRAM_PLAYBOOK_MASTER.md:71:| 2 | **Gem Hunter** — radar open-source | `agents/agents/gem-hunter.ts` | PROD | "Descubra padrões IA 48h antes do mercado" |
docs/strategy/instagram/PLANO_COMPLETO_INSTAGRAM_V2.md:31:| **gem-hunter** | 8 | Mirror gem-hunter (fora de egos) | ARQUIVADO | Baixo |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:86:- `docs/strategy/ARCHIVE_GEMS_CATALOG.md` — catalog from gem-hunter runs; belongs in `docs/gem-hunter/`.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:178:**Purpose:** Agent spec files (meta-prompts for specific agent roles like doc-drift-analyzer, gem-hunter, readme-syncer, etc.) plus INDEX and CYCLE docs.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:192:- `docs/agents/gem-hunter-api.md` — API spec for gem-hunter; belongs in `docs/gem-hunter/` or `docs/products-specs/gem-hunter.md`.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:239:**Purpose:** Per CLAUDE.md SSOT map, "Specs descritivas de produto" canonical location. Contains specs for guard-brasil, egos-gateway, forja, gem-hunter, knowledge-mcp, anythingllm, skills.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:292:### 13. `docs/gem-hunter/` — 24 files (includes non-MD: auto-queue.json, history.db, latest-run.json, next-queries.json, registry.yaml, signals.json, weights.yaml)
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:299:- `docs/gem-hunter/history.db` — SQLite database file in docs/; should be in `data/` or runtime dir, not docs.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:300:- `docs/gem-hunter/auto-queue.json`, `next-queries.json`, `signals.json`, `weights.yaml` — runtime state files; belong with the gem-hunter agent code, not in docs.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:301:- `docs/gem-hunter/pairs/` and `docs/gem-hunter/prompts/` subdirs — operational agent artifacts.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:304:- `docs/gem-hunter/2026-04-02-adaptive.md` through `2026-04-16-adaptive.md` — April adaptive scans, > 60 days old.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:305:- `docs/gem-hunter/gems-2026-04-06.md`, `gems-2026-04-09.md`, `gems-2026-04-13.md` — April gem results.
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:318:| `docs/analysis/` | 1 | Single file `GEM_HUNTER_ARR_ANALYSIS.md`; belongs in `docs/gem-hunter/` or `docs/strategy/`. | MOVE |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:387:| `agents/` | 30 | ~4 (kol-discovery, framework-benchmarker, wiki-compiler, spec-router) | 2 (drift-sentinel near-dupe) | 3 (gem-hunter-api, start.md, end.md) | REVIEW (prune unused agents) |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:393:| `gem-hunter/` | ~10 | 5+ (runtime files: .db, .json, .yaml) | ~6 (April adaptive/gems) | ~5 (runtime data in docs/) | ARCHIVE-BATCH April + MOVE runtime files |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:453:| 11 | **MOVE** runtime data from gem-hunter | `docs/gem-hunter/history.db`, `auto-queue.json`, `next-queries.json`, `signals.json`, `weights.yaml` → gem-hunter agent source | Binary/state files in docs/ | XS |
docs/audits/DOCS_FOLDER_SWEEP_2026-05-30.md:455:| 13 | **ARCHIVE-BATCH** April gem-hunter runs | `docs/gem-hunter/2026-04-*-adaptive.md` (4) + `gems-2026-04-*.md` (3) → `docs/_archived/` | > 60 days old run results | S |
docs/jobs/2026-05-08-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-08-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/audits/premortem-egos-current-scope.md:4:> Cobre as 3 frentes ativas simultâneas + a refundação/integração do gem-hunter.
docs/audits/premortem-egos-current-scope.md:8:- **O que:** tocar em paralelo três iniciativas — (A) Padrão de Guardrails para todo agente/chatbot/MCP, (B) Metodologia de Valuation/ECV (documento interno), (C) refundação e integração do gem-hunter no EGOS inteiro.
docs/audits/premortem-egos-current-scope.md:9:- **Por que agora:** mais superfícies expostas a usuários reais; necessidade de medir/comunicar valor; gem-hunter com 4 cópias em drift e capacidades órfãs.
docs/audits/premortem-egos-current-scope.md:10:- **Sucesso em 6 meses sem incidente:** guardrails contratados por código (não só system-prompt) nas superfícies públicas; ECV usada só internamente como faixa honesta (nunca número público inflado); gem-hunter num único modelo de score calibrado, exposto como MCP, sem cópias stale.
docs/audits/premortem-egos-current-scope.md:25:| F6 | 4 cópias do gem-hunter continuam divergindo — fix no kernel não propaga, alguém roda a cópia stale (egos-lab 61K) | A | M | edição em `agents/agents/gem-hunter.ts` sem deletar/redirecionar as outras 3 |
docs/audits/premortem-egos-current-scope.md:27:| F8 | Expor gem-hunter como MCP (porta 3097) sem auth → tool de discovery abusada / rate-abuse | M | M | rota MCP sem bearer/scope; deploy antes de GUARD-STD-006 |
docs/audits/premortem-egos-current-scope.md:28:| F9 | Três frentes ao mesmo tempo dispersam o Single Pursuit (Central EGOS) → nenhuma fecha, R$10k MRR (2026-06-30) não chega | A | A | commits espalhados sem fechar P0; valuation/gem-hunter consumindo tempo de storefront/chatbot |
docs/audits/premortem-egos-current-scope.md:51:**F5 (M×M) — unificação de score gem-hunter**
docs/audits/premortem-egos-current-scope.md:58:- Sentinela: `find` por `gem-hunter.ts` retornando >1 cópia ativa.
docs/audits/premortem-egos-current-scope.md:66:- Preventiva: gate GUARD-STD-006 (auth/scope/HITL) ANTES de deploy do gem-hunter MCP na 3097. Red Zone (corte Enio no modelo de auth).
docs/audits/premortem-egos-current-scope.md:70:- Preventiva: valuation e gem-hunter são **documentação/preparação**, não substituem o foco em Central EGOS/storefront/chatbot. Manter WIP≤2. Frentes B/C avançam por handoff de Guarani, não consomem o turno principal do Prime.
docs/audits/premortem-egos-current-scope.md:71:- Sentinela: P0 de storefront/chatbot parados >1 sessão enquanto VAL/gem-hunter avançam.
docs/audits/premortem-egos-current-scope.md:80:- [ ] **F5/F6 — unificação gem-hunter + dedup das 4 cópias: NÃO iniciar sem o modelo de score único definido + backup history.db. RED ZONE (arquitetura) → corte Enio.**
docs/audits/premortem-egos-current-scope.md:81:- [ ] **F8 — MCP gem-hunter: deploy gated em GUARD-STD-006 (auth).**
docs/audits/premortem-egos-current-scope.md:82:- [ ] **F9 — confirmar com Enio que B (valuation) e C (gem-hunter) não devem ultrapassar o Single Pursuit Central EGOS antes de 2026-06-30.**
docs/audits/premortem-egos-current-scope.md:84:> **Veredito:** A (guardrails) pode avançar — schema/enforcement já desenham o gate. B (valuation) está contido como doc interno; nada a publicar. C (gem-hunter refundação) é o de maior risco arquitetural irreversível (F5/F6/F8) e **exige corte do Enio antes de codar** — não iniciar a unificação de score nem o deploy MCP sem decisão explícita.
docs/jobs/2026-05-29-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-29-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/WORLD_MODEL_SSOT.md:264:│    └── External (X.com, news, gem-hunter signals)      │
docs/jobs/2026-05-13-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-13-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:17:Nos últimos anos juntei as duas coisas: virei builder de sistemas de IA governados. O intelink (investigação), o gem-hunter, os MCPs, e o EGOS — o kernel que orquestra tudo com LGPD e auditabilidade desde o dia zero. Cada decisão do sistema tem fonte; cada afirmação tem prova; cada prompt é aberto e verificável.
docs/strategy/ENIO_CURRICULUM_POSITIONING.md:27:| Build de sistemas (TS / agents / RAG / MCP) | intelink, gem-hunter, EGOS, MCPs |
docs/jobs/2026-05-07-code-security.md:45:| `apps/egos-gateway/src/channels/gem-hunter-api.ts` | 535 | 🟡 MEDIUM | API client integration |
docs/jobs/2026-05-07-code-security.md:59:- `agents/agents/gem-hunter.ts` — TypeScript skeleton generation prompt
docs/strategy/EGOS_DISTRIBUTION_STRATEGY_REVIEW.md:35:- Pacotes `@egos/*` todos `"private": true`. Só `gem-hunter` publica no npm.
docs/strategy/EGOS_DISTRIBUTION_STRATEGY_REVIEW.md:83:- É exatamente o modo de falha **F1** do premortem do gem-hunter (desvio de foco do Single Pursuit = Central EGOS) numa nova roupa.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:93:| **PRODUCTION: gem-hunter** | AI Discovery Layer, GitHub/HF/npm scanning, Gem Hunter API tiers | §2, §11 |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:340:| **Gem Hunter Partner Track** | `docs/gem-hunter/SSOT.md` → partner/community track | C | egos (planned) | — | `gtm`, `gem-hunter`, `discovery` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:352:| **Pramana Confidence System** (Fact/Inference/Disputed/Unknown) | `egos-inteligencia/frontend/src/lib/intelligence/confidence-system.ts` | A | egos-inteligencia | egos (rule global), guard-brasil, gem-hunter, 852 | `epistemology`, `trust`, `ui`, `evidence`, `pramana` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:353:| **Sacred Math Scoring** (razão áurea φ para confidence) | `egos-inteligencia/api/src/egos_inteligencia/services/patterns/pattern_detector.py` | A | egos-inteligencia | egos (extract to package), gem-hunter | `scoring`, `pattern-detection`, `phi`, `fibonacci` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:410:| **Auditable Live Sandbox** | `docs/patterns/AUDITABLE_SANDBOX_PATTERN.md` | A | guard-brasil-web (LIVE) | gem-hunter-web, eagle-eye-web, kb-api | `sandbox`, `ux`, `pattern`, `trust` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:413:| **Session Audit Trail Export** | `sandbox-client.tsx:exportAudit()` | A | guard-brasil-web | eagle-eye, gem-hunter | `audit`, `compliance`, `export` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:426:| **Gem Hunter deps-watch** | `agents/agents/gem-hunter.ts` → SearchTrack deps-watch | B | egos (manual) | — | `dx`, `deps`, `monitoring` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:581:| Gem Hunter API Key Auth | `egos-gateway/src/channels/gem-hunter-api.ts` | A | egos | `auth`, `sha256`, `supabase`, `middleware` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:582:| Gem Hunter Rate Limiting | `gem-hunter-api.ts#checkAndIncrementUsage` | A | egos | `rate-limit`, `tier`, `usage-tracking` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:584:| Telegram /hunt /sector /trending | `egos-gateway/src/channels/telegram.ts` | A | egos | `telegram`, `slash-commands`, `gem-hunter` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:586:| Gem Hunter Dashboard (inline SSR) | `agents/api/gem-hunter-server.ts` | A | egos | `dashboard`, `bun`, `ssr`, `gem-hunter` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:589:| Gem Signal Auto-append | `agents/agents/gem-hunter.ts` + `gem-signals.ts` | A | egos | `signals`, `world-model`, `gem-hunter`, `intel` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:699:1. **ARR-001**: `import { AtomizerCore } from '@egos/atomizer'` in gem-hunter pipeline
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:902:  agentId: 'gem-hunter',
docs/jobs/2026-05-19-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-19-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:20:Packages relevantes: `skill-discovery`, `mcp-memory`, `knowledge-mcp`, `atrian-observability`, `agent-runtime`, `gem-hunter`
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:121:- Overlap com: `gem-hunter` + `skill-discovery` registry
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:122:- O que falta no nosso gem-hunter: catálogo navegável externo de skills validadas pela comunidade
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:125:- Usar como **fonte de scanning** para o gem-hunter (nova categoria: "hermes-community-skills")
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:127:- Criar equivalente EGOS: `docs/generated/awesome-egos.md` (gerado pelo gem-hunter)
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:131:- Adicionar `awesome-hermes-agent` como fonte de scanning no gem-hunter
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:134:**Effort:** 1h (adicionar fonte no gem-hunter)
docs/strategy/HERMES_COMMUNITY_EVALUATION.md:147:| awesome-hermes | 🟡 Fonte para gem-hunter | P2 | 1h | dev |
docs/gem-hunter/SSOT.md:5:> **Master Plan:** `docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md`
docs/gem-hunter/SSOT.md:19:| **Core Engine v5.0** | `egos-lab/agents/agents/gem-hunter.ts` | 1528 | ACTIVE — runs via CCR scheduled job |
docs/gem-hunter/SSOT.md:20:| **Standalone API** | `egos/agents/api/gem-hunter-server.ts` | 180 | ACTIVE — port 3097, VPS deployed |
docs/gem-hunter/SSOT.md:27:| **API Server** | `gem-hunter-standalone/src/server.ts` | `egos/agents/api/gem-hunter-server.ts` | ✅ Migrated |
docs/gem-hunter/SSOT.md:28:| **AI Engine** | `gem-hunter-standalone/src/llm/multi-router.ts` | `egos/packages/shared/src/social/ai-engine.ts` | ✅ Copied |
docs/gem-hunter/SSOT.md:29:| **Core Agent** | `gem-hunter-standalone/src/agent/gem-hunter.ts` | `egos-lab/agents/agents/gem-hunter.ts` | ⏳ Pending |
docs/gem-hunter/SSOT.md:30:| **npm Package** | `@egosbr/gem-hunter-core` | — | ⏳ Pending publish |
docs/gem-hunter/SSOT.md:36:| **SecOps Scanner** | `egos/scripts/gem-hunter-secops.ts` | 58 | ACTIVE — security-focused variant |
docs/gem-hunter/SSOT.md:37:| **Freshness Checker** | `egos-lab/scripts/gem-hunter-freshness.ts` | 60 | ACTIVE — validates repo freshness |
docs/gem-hunter/SSOT.md:38:| **Gratitude Tracker** | `~/.egos/bin/gem-hunter-gratitude.ts` | 93 | ACTIVE — tracks open-source attribution |
docs/gem-hunter/SSOT.md:39:| **ARCH Model Config** | `arch/src/lib/model-gem-hunter.ts` | 291 | ACTIVE — ARCH-specific, stays in arch |
docs/gem-hunter/SSOT.md:45:| **Discovery reports** | `egos-lab/docs/gem-hunter/gems-YYYY-MM-DD.md` |
docs/gem-hunter/SSOT.md:46:| **Latest run state** | `egos-lab/docs/gem-hunter/latest-run.json` |
docs/gem-hunter/SSOT.md:47:| **Assets (SSOT blocks)** | `egos-lab/docs/gem-hunter/assets/` |
docs/gem-hunter/SSOT.md:53:| **Registry (all repos)** | `egos/docs/gem-hunter/registry.yaml` |
docs/gem-hunter/SSOT.md:54:| **Scoring weights** | `egos/docs/gem-hunter/weights.yaml` |
docs/gem-hunter/SSOT.md:55:| **Pair analysis reports** | `egos/docs/gem-hunter/pairs/egos__<repo>/` |
docs/gem-hunter/SSOT.md:56:| **Session records** | `egos/docs/gem-hunter/sessions/` |
docs/gem-hunter/SSOT.md:77:**deps-watch purpose:** Automatically monitors repos and tools EGOS depends on. When significant updates detected, Gem Hunter creates TASK entries (e.g., `DEPS-001: Upgrade Bun to v2.1.3`). Run: `bun agent:run gem-hunter --exec --track=deps-watch`
docs/gem-hunter/SSOT.md:90:| ~~aiox-gem-hunter.ts~~ | `egos/agents/agents/` | Dead code, never called |
docs/gem-hunter/SSOT.md:91:| ~~mastra-gem-hunter.ts~~ | `egos/agents/agents/` | Dead code, never called |
docs/gem-hunter/SSOT.md:93:| ~~gem-hunter-secops.ts~~ | `852/scripts/` | Duplicate of egos/ version |
docs/gem-hunter/SSOT.md:94:| ~~gem-hunter-daily.yml~~ | `egos-lab/.github/workflows/` | Replaced by CCR job |
docs/gem-hunter/SSOT.md:127:Phase 3 (Month 2):  NPM package (@egosbr/gem-hunter)
docs/gem-hunter/SSOT.md:138:| `docs/gem-hunter/prompts/scoring-v1.md` | Scoring prompts SSOT — extracted 2026-04-08. Version-controlled. |
docs/gem-hunter/SSOT.md:139:| `docs/gem-hunter/GEM_HUNTER_PRODUCT.md` | Product roadmap |
docs/gem-hunter/SSOT.md:145:3. **Read-only reference repos**: External repos cloned to `/tmp/gem-hunter-study/` are never modified.
docs/jobs/2026-05-22-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-22-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/gem-hunter/gems-2026-05-21.md:220:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/jobs/2026-05-11-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-11-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
scripts/morning-report.ts:39:    { name: 'gem-hunter',    path: `${HOME}/gem-hunter`,    role: 'leaf-app' },
docs/strategy/HQ_EGOS_PRESENTATION_PLAN.md:202:     - Code: gem-hunter.ts
docs/jobs/agent-smoke-test-2026-04-14.md:39:| gem-hunter | 0 | Exa API ✅, GitHub ✅, X API ✅ |
docs/jobs/agent-smoke-test-2026-04-14.md:58:`gemhunter.egos.ia.br/gem-hunter/topics` appears twice — once passing, once failing.
docs/strategy/EGOS_OFFERING_CATALOG.md:146:- Agents especializados: wiki-compiler, drift-sentinel, article-writer, gem-hunter, dead-code-detector
docs/jobs/2026-05-04-doc-drift-verifier.json:185:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-04-doc-drift-verifier.json:216:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/AGENT_TAXONOMY.md:55:| aiox-gem-hunter | 197 | **CLI Tool** (research) | Não | fetch, FS write | Sim | Manter |
docs/strategy/AGENT_TAXONOMY.md:59:| mastra-gem-hunter | 101 | **CLI Tool** (research) | Não | fetch | Sim | Manter |
docs/strategy/AGENT_TAXONOMY.md:204:- **11 Tools**: ssot-auditor, ssot-fixer, dep-auditor, dead-code-detector, capability-drift-checker, context-tracker, archaeology-digger, aiox-gem-hunter, gtm-harvester, framework-benchmarker, mastra-gem-hunter, chatbot-compliance-checker
docs/jobs/2026-05-12-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-12-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-31-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-31-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/EGOS_PROJECT_ATLAS.md:22:| **gemhunter.egos.ia.br** | 200 | Gem Hunter — Autonomous Repository Discovery | gem-hunter | ✅ live |
docs/strategy/EGOS_PROJECT_ATLAS.md:64:| **gem-hunter** | 7 | 5h atrás | ✅ standalone | público |
docs/jobs/2026-05-27-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-27-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/gem-hunter/pairs/egos__openai-agents/session_close.md:172:- [ ] `docs/gem-hunter/pairs/egos__openai-agents/` directory exists
docs/capabilities/001-knowledge-base-rag.md:231:1. **Ativar ARR (ARR-001/ARR-002):** wiring do `InMemorySearchEngine` no `gem-hunter` e no `wiki-compiler.ts` — aumenta precisão para documentos curtos e queries técnicas.
docs/jobs/2026-05-14-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-14-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/strategy/API_DISTRIBUTION_READINESS.md:212:- Gem Hunter: `docs/products/gem-hunter.md`
docs/jobs/2026-05-18-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-18-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/INCIDENTS/INC-001-force-push.md:24:The replacement tip was `5ed6706 chore(gem-hunter): adaptive run [2026-04-06]` (Gem Hunter Bot), with parent `00d7b8a feat(gem-hunter): pair study EGOS vs OpenHands — score 79/100` (author `Claude <noreply@anthropic.com>`).
docs/INCIDENTS/INC-001-force-push.md:34:The **Gem Hunter Adaptive** GitHub Action (`gem-hunter-adaptive.yml`) is a contributing factor: its `git push` step did not fetch+rebase before pushing, so once main moved underneath it, retries would either fail or (without protection) corrupt history.
docs/INCIDENTS/INC-001-force-push.md:40:3. Conflicts only in 4 auto-generated `docs/gem-hunter/` files → resolved with `--theirs`
docs/INCIDENTS/INC-001-force-push.md:52:| 3 | CI | `gem-hunter-adaptive.yml` rewritten with fetch+rebase retry loop (3 attempts) | `.github/workflows/gem-hunter-adaptive.yml` |
docs/jobs/2026-05-20-doc-drift-verifier.json:186:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/jobs/2026-05-20-doc-drift-verifier.json:217:      "url": "https://gemhunter.egos.ia.br/gem-hunter/topics",
docs/gem-hunter/pairs/egos__cline/session_close.md:144:- **Pair Analysis:** `docs/gem-hunter/pairs/egos__cline/pair_diagnosis.md`
docs/gem-hunter/pairs/egos__cline/session_close.md:157:  pair_report: "docs/gem-hunter/pairs/egos__cline/"
apps/egos-hq/README.md:94:- Canais do gateway (whatsapp, telegram, knowledge, gem-hunter, guard-brasil-x402)
docs/gem-hunter/pairs/egos__cline/pair_diagnosis.md:105:Using `docs/gem-hunter/weights.yaml`:
docs/gem-hunter/pairs/egos__litellm/session_close.md:174:| Pair Diagnosis | `docs/gem-hunter/pairs/egos__litellm/pair_diagnosis.md` | ✅ Complete |
docs/gem-hunter/pairs/egos__litellm/session_close.md:175:| Session Close | `docs/gem-hunter/pairs/egos__litellm/session_close.md` | ✅ Complete |
docs/gem-hunter/pairs/egos__litellm/session_close.md:177:| Adaptive Report | `docs/gem-hunter/2026-05-04-adaptive.md` | ✅ Complete |
docs/morning_reports/2026-05-06.json:154:      "name": "gem-hunter",
docs/strategy/outreach/EVIDENCES_INDEX_PROOFS_ONLY.md:78:| Fontes | 14 | `agents/agents/gem-hunter.ts` SOURCES array |
docs/morning_reports/2026-05-06.md:102:### gem-hunter (leaf-app) — 1 commit(s)
apps/egos-hq/public/agents-registry.json:385:      "id": "gem-hunter",
apps/egos-hq/public/agents-registry.json:390:      "entrypoint": "agents/agents/gem-hunter.ts",
apps/egos-hq/public/agents-registry.json:404:      "runtime_proof": "bun agents/agents/gem-hunter.ts --dry",
apps/egos-hq/public/agents-registry.json:459:      "id": "gem-hunter-api",
apps/egos-hq/public/agents-registry.json:462:      "description": "Standalone REST API for gem-hunter (Phase 1 product). Endpoints: GET /v1/findings, /v1/papers, /v1/signals, /v1/kols; POST /v1/hunt. Port 3097.",
apps/egos-hq/public/agents-registry.json:464:      "entrypoint": "agents/api/gem-hunter-server.ts",
apps/egos-hq/public/agents-registry.json:477:      "runtime_proof": "bun agents/api/gem-hunter-server.ts",
apps/egos-hq/public/agents-registry.json:535:      "description": "Compiles raw sources (handoffs, job reports, gem-hunter, strategy docs) into structured wiki pages in Supabase. Karpathy LLM Wiki pattern: ingest → compile → lint. Also records learnings for data flywheel.",
docs/gem-hunter/pairs/egos__langgraph/pair_diagnosis.md:218:3. **Commit** — docs/gem-hunter/pairs/egos__langgraph/* + registry.yaml update
docs/strategy/KERNEL_CONSOLIDATION_PLAN.md:127:| `gem-hunter` | `agents/agents/gem-hunter.ts` | `tool` / `keep_in_lab` | Lab code discovery, not generic enough for kernel |
docs/morning_reports/2026-04-26.json:99:      "name": "gem-hunter",
apps/egos-hq/lib/showcase-data.ts:134:    codeLink: 'packages/gem-hunter/src',
apps/egos-hq/lib/showcase-data.ts:135:    liveDemo: '/implementations#gem-hunter',
docs/gem-hunter/gems-2026-04-09.md:228:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
apps/egos-site/src/content/posts/egos-showcase.md:164:- `curl https://gateway.egos.ia.br/gem-hunter/latest` → verify
apps/egos-site/src/content/posts/egos-showcase.md:301:| `gem-hunter` | Descoberta de repos emergentes de IA | Scheduled |
docs/morning_reports/2026-04-30.json:145:      "name": "gem-hunter",
docs/capabilities/003-agentes-autonomos.md:99:- `gem-hunter` — busca oportunidades de negócio (integrado com Eagle Eye)
docs/capabilities/003-agentes-autonomos.md:101:- `gem-hunter-api` — API do gem-hunter
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:11:3. **AI Agents** — Orchestrator behind the chatbot, tool-calling gem-hunter
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:41:                               gem-hunter             wiki-compiler
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:54:3. Call `GET /gem-hunter/sector/{sector}` or trigger `POST /v1/hunt`
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:84:- [ ] **GH-066**: Deploy gem-hunter-server to VPS (gemhunter.egos.ia.br, port 3097)
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:95:  - Tech: Next.js in `apps/gem-hunter-web/` OR extend guard-brasil-web
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:101:  - Tool dispatch → gem-hunter-server API
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:111:- [ ] **GH-074**: NPM package `@egosbr/gem-hunter` public release with API client
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:120:| gem-hunter.ts v6.1 | ✅ Running | 2249 lines, 20+ topics, 12 sources |
docs/gem-hunter/GEM_HUNTER_PRODUCT.md:122:| Gateway API (/gem-hunter) | ✅ Built | Sector filtering, product pricing |
docs/strategy/_archived_2026-05-06/KB_AS_A_SERVICE_PLAN.md:170:- **P2 CARRYOVER:** PAP-002, LS-002, GH-086 (gem-hunter-mcp segue plano Sprint 1)
docs/gem-hunter/gems-2026-06-01.md:233:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/strategy/kbs/KBS_ENTITY_SCHEMA_EGOS.md:30:| `id` | string | `gem-hunter` | `agents/registry/agents.json` |
docs/strategy/kbs/KBS_ENTITY_SCHEMA_EGOS.md:34:| `entrypoint` | string | `agents/agents/gem-hunter.ts` | agents.json |
docs/strategy/kbs/KBS_ENTITY_SCHEMA_EGOS.md:39:| `proof_command` | string | `bun agents/agents/gem-hunter.ts --dry` | docs/agents/*.md |
docs/gem-hunter/gems-2026-05-14.md:225:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/gem-hunter/2026-04-02-adaptive.md:24:**Focus Keywords:** `pii-detection`, `lgpd-compliance`, `codebase-memory`, `code-intelligence`, `gem-hunter`, `agent-runtime`, `governance`, `osint`, `ai-agent`
docs/gem-hunter/2026-04-02-adaptive.md:159:**Full Details:** See `docs/gem-hunter/pairs/egos__cline/pair_diagnosis.md` + `session_close.md`
docs/gem-hunter/2026-04-02-adaptive.md:234:**Artifacts:** `docs/gem-hunter/2026-04-02-adaptive.md` (this file) + `pairs/egos__cline/`
docs/gem-hunter/gems-2026-05-31.md:38:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:12:Gem Hunter está embedded no EGOS kernel (`agents/agents/gem-hunter.ts`, 2538 LOC). Precisa ser extraído para repo standalone e npm package `@egosbr/gem-hunter-core`.
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:25:| Core agent | `agents/agents/gem-hunter.ts` | Funcional | 2538 LOC |
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:26:| API server | `agents/api/gem-hunter-server.ts` | **Já isolado** | 428 LOC |
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:27:| npm package | `packages/gem-hunter/` | v6.0.0 publicado | ~200 LOC |
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:28:| Landing page | `apps/gem-hunter-landing/` | Bun/Hono | ~300 LOC |
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:36:gem-hunter-standalone/
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:39:│   │   └── discovery.ts       # Lógica principal (de gem-hunter.ts)
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:43:│   │   └── server.ts          # Mover de agents/api/gem-hunter-server.ts
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:47:│   ├── web/                   # Landing (migrar de gem-hunter-landing/)
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:50:│   └── gem-hunter-core/       # npm package já existe v6.0.0
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:65:# Target: packages/gem-hunter/src/llm/multi-router.ts
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:80:**GH-STANDALONE-003:** Verificar `gem-hunter-server.ts` roda standalone
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:85:bun agents/api/gem-hunter-server.ts
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:105:- [ ] GH-067: Deploy gem-hunter-server.ts
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:115:- npm install @egosbr/gem-hunter-core
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:119:**GH-STANDALONE-006:** Criar `/home/enio/gem-hunter` clone
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:123:/home/enio/gem-hunter/
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:140:| `gem-hunter.ts` | `callAI()` de `ai-engine.ts` | Usar novo multi-router.ts local |
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:147:- [ ] **GH-STANDALONE-002:** Copiar `ai-engine.ts` → `packages/gem-hunter/src/llm/multi-router.ts`
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:148:- [ ] **GH-STANDALONE-003:** Verificar `gem-hunter-server.ts` roda standalone
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:149:- [ ] **GH-STANDALONE-004:** GH-067 — Deploy gem-hunter-server.ts para VPS
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:150:- [ ] **GH-STANDALONE-005:** Atualizar `docs/gem-hunter/SSOT.md`
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:151:- [ ] **GH-STANDALONE-006:** Criar repo `/home/enio/gem-hunter` (P1)
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:153:- [ ] **GH-STANDALONE-008:** Publicar `@egosbr/gem-hunter-core` v7.0.0 (P1)
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:159:- **GH-067:** Deploy gem-hunter-server.ts para VPS
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:167:1. `bun agents/api/gem-hunter-server.ts` roda sem kernel imports
docs/gem-hunter/STANDALONE_MIGRATION_PLAN.md:169:3. npm package `@egosbr/gem-hunter-core` instala sem `egos` peer dependency
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:6:> **SSOT Ref:** `docs/gem-hunter/SSOT.md`
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:177:│   docs/gem-hunter/papers/<paper-id>/                     │
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:193:│ Output: docs/gem-hunter/papers/daily-digest.md           │
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:206:│ Output: docs/gem-hunter/trends/YYYY-MM-DD.md             │
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:243:@egosbr/gem-hunter
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:244:  CLI: npx gem-hunter --track=papers --topic=agents
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:245:  Library: import { hunt, score } from '@egosbr/gem-hunter'
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:246:  Config: .gem-hunter.yaml (custom sources, weights, filters)
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:338:| 1 | GH-062 | NPM package (@egosbr/gem-hunter CLI) | 1 week |
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:373:- **SSOT:** `docs/gem-hunter/SSOT.md`
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:374:- **Weights:** `docs/gem-hunter/weights.yaml`
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:375:- **Registry:** `docs/gem-hunter/registry.yaml`
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:376:- **Engine:** `agents/agents/gem-hunter.ts` (v5.1, 1618 LOC)
docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md:377:- **Integration Map:** `docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md` (this file)
docs/capabilities/CBC-EGOS-ATLAS-001.md:73:- 8 projetos: egos, intelink, pixelart, 852, gem-hunter, carteira-livre, egos-lab, br-acc
docs/strategy/EGOS_MASTER_API_PRD.md:196:| `gems` | Latest gem-hunter findings | Top 5 gems |
docs/gem-hunter/prompts/scoring-v1.md:2:# SSOT: extracted from gem-hunter.ts 2026-04-08
docs/gem-hunter/prompts/scoring-v1.md:3:# Version: 1.0.0 | Edit this file → redeploy gem-hunter to apply
docs/gem-hunter/prompts/scoring-v1.md:8:## 1. Executive Synthesis Prompt (gem-hunter.ts:1642)
docs/gem-hunter/prompts/scoring-v1.md:26:## 2. Paper Abstract Triage Prompt (gem-hunter.ts:2274 — GH-056)
docs/gem-hunter/prompts/scoring-v1.md:41:## 3. scoreGem() Heuristic Logic (gem-hunter.ts:1778 — NOT LLM-based)
docs/gem-hunter/prompts/scoring-v1.md:86:// gem-hunter.ts:1895 (GH-091, implemented 2026-04-09)
docs/gem-hunter/prompts/scoring-v1.md:156:Index file: `docs/gem-hunter/.gem-alert-index.json`
docs/gem-hunter/prompts/scoring-v1.md:164:| v1.0 | 2026-04-08 | Extracted from gem-hunter.ts — baseline documentation |
docs/strategy/EGOS_LAB_CONSOLIDATION_DIAGNOSTIC.md:38:| `gem-hunter` | `keep_in_lab` | Lab-specific code discovery agent | Stay in egos-lab |
docs/strategy/EGOS_LAB_CONSOLIDATION_DIAGNOSTIC.md:72:| `gem-hunter` scripts | `keep_in_lab` | Lab-specific | Stay |
docs/strategy/EGOS_LAB_CONSOLIDATION_DIAGNOSTIC.md:129:├── agents/agents/            ← Lab-specific agents (gem-hunter, report_generator)
docs/gem-hunter/gems-2026-04-13.md:224:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/gem-hunter/latest-run.json:4:  "reportPath": "/home/runner/work/egos/egos/docs/gem-hunter/gems-2026-06-01.md",
docs/gem-hunter/gems-2026-05-18.md:227:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/gem-hunter/gems-2026-04-06.md:239:> They are saved to `docs/gem-hunter/next-queries.json` for the next run.
docs/modules/SSOT_REGISTRY.md:45:| GitHub Actions (egos-lab) | `egos-lab/.github/workflows/` | enioxt | Lab-specific: eagle-eye-scan, gem-hunter-daily, ssot-drift-check, scorecard | 2026-03-30 |
docs/modules/HERMES_SSOT.md:35:- This is what application code (HQ actions, x-opportunity-alert, gem-hunter, etc.) actually imports
docs/_archived_research/2026-05-17-grokchat1-raw.md:18:gem-hunter
docs/_archived_research/2026-05-17-grokchat1-raw.md:71:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:105:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:139:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:189:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:266:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:332:Pacotes reais confirmados (histórico de verificação branch 3cc179ac2207522f164760bcada8d15d2d2fec47): agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:391:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:451:Pacotes reais confirmados em verificações anteriores (branch referência 3cc179ac2207522f164760bcada8d15d2d2fec47): agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:502:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:563:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:591:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:616:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:652:gem-hunter-api.md
docs/_archived_research/2026-05-17-grokchat1-raw.md:653:gem-hunter.md
docs/_archived_research/2026-05-17-grokchat1-raw.md:1106:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1172:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1217:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1234:Custom skill no EGOS (via skill-discovery): Usar agent-runtime + gem-hunter para prompt → Liquid generation + Shopify CLI via guard-brasil-python (execução local). Custo: zero extra.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1264:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1287:3. Trending Workflows Radar	search-engine + gem-hunter + knowledge-mcp	Web search + knowledge ingest existem	Radar 24h velocity + ranking (noise filter) não verificado
docs/_archived_research/2026-05-17-grokchat1-raw.md:1297:Research Vault / Evidence Layer (knowledge-mcp + citation-verifier.ts + subconscious-agent.ts): workflows 3, 6 e 9 podem usar search-engine + gem-hunter para ingestão.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1331:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1338:20 prompts especializados (audits, strategies, spreadsheets)	skill-discovery + gem-hunter + eval-runner + report-standard	Skill creation + web-research + reporting existem	Converter cada prompt em skill YAML/Markdown no skills/ do hermes-egos (self-evolving via trajectory_compressor.py)
docs/_archived_research/2026-05-17-grokchat1-raw.md:1339:Integração com ferramentas externas (SEMrush, Ahrefs, GSC, Chrome)	search-engine + guard-brasil-mcp + guard-brasil-python	Pesquisa web + MCP gateway existem	Adaptar via gem-hunter + MCP para automação de audits (sem Chrome manual)
docs/_archived_research/2026-05-17-grokchat1-raw.md:1348:gem-hunter + search-engine: substituir navegação manual no Chrome por automação via MCP.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1367:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types, whatsapp-kernel.
docs/_archived_research/2026-05-17-grokchat1-raw.md:1384:12. SEO local (Claude Cowork)	20 prompts SEO (GBP, website, backlinks, entity optimisation)	skill-discovery + gem-hunter + report-standard + knowledge-mcp	Nenhum skill “seo-context-loader” ou audit automático
docs/modules/AGENT_RUNTIME_DESIGN.md:4:> **Scope:** Shared runtime for all EGOS chatbots — intelink (via protocol), gem-hunter, 852 (future)
docs/modules/AGENT_RUNTIME_DESIGN.md:13:- gem-hunter: batch/cron only — no conversational interface
docs/modules/AGENT_RUNTIME_DESIGN.md:101:| gem-hunter | `user_id` | `session_id` | thread (each search session isolated) |
docs/modules/AGENT_RUNTIME_DESIGN.md:134:TS (gem-hunter, 852) use `@egos/agent-runtime` natively.
docs/modules/AGENT_RUNTIME_DESIGN.md:141:From `agents/agents/gem-hunter.ts` (2537 LOC):
docs/modules/AGENT_RUNTIME_DESIGN.md:151:New conversational interface reads `GATEWAY_REGISTRY` and routes `use_case: "gem-discovery"` to gem-hunter agent.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:113:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil (e subpacotes: guard-brasil-langchain, guard-brasil-mcp, guard-brasil-python), knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1398:agent-runtime, atomizer, atrian-observability, audit, auth, chatbot-core, core, eval-runner, gem-hunter, guard-brasil, knowledge-mcp, mcp-governance, mcp-memory, registry, report-standard, search-engine, shared, skill-discovery, types.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1664:Packages reais existentes: gem-hunter (listado), skill-discovery, atrian-observability, knowledge-mcp, mcp-memory, eval-runner, guard-brasil, agent-runtime, atomizer, core, chatbot-core, shared, types.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1666:Nenhum diretório docs/personal-os ou arquivos de Gem Hunter fora do package gem-hunter foi encontrado publicamente (browse falhou em detalhes internos; repo pode ter partes privadas). Gem Hunter é o pacote interno para descoberta de gems/trends em AI (alinhado com foco técnico atual de skill-discovery + context discipline).
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1689:Conta dedicada a daily gem hunting de GitHub: trends de AI, Agent, open-source tools, contratos audit, etc. Faz exatamente o que o package gem-hunter faz internamente no EGOS: descobrir, resumir e destacar projetos explosivos com breakdown técnico. É um “curador automático” de gems – sem hype, foco em stars diários + utilidade prática.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1692:gem-hunter é o módulo interno de descoberta de gems/trends em AI (parte do ecossistema EGOS/hermes-egos). Alinha com skill-discovery (pruning on-demand) + knowledge-mcp (Evidence Layer). Não tem detalhes públicos completos de README (acesso limitado), mas executa funções de scan/trending + ingestão para inspiração de skills/infra.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1713:gem-hunter passa a rodar daily scan + build de knowledge graph criptografado (Guard Brasil + mcp-memory).
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1737:Packages reais existentes: gem-hunter, skill-discovery, atrian-observability, knowledge-mcp, mcp-memory, mcp-governance, agent-runtime, atomizer, core, chatbot-core, shared, types, guard-brasil, eval-runner.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1769:Gem Hunter + EGOS interno	Análise do package gem-hunter, propostas de ingestão automática de trends	Direto (foco técnico atual)	P1	Adicionar daily scan + pruning on-demand no gem-hunter usando skill-discovery.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1827:awesome-hermes-agent	gem-hunter + skill-discovery	Catálogo comunitário + navegação de skills (pode virar nosso “Awesome EGOS”)	P1
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1835:Hermes Community Extensions	Todos os posts do GitTrend (Noustiny, hermesclaw, hermes-webui, super-hermes, awesome-hermes etc.)	Fork hermes-egos + atrian-observability + gem-hunter	P0
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1836:Gem Hunting / Trending	GitTrend + nosso gem-hunter	Descoberta automática de skills relevantes	P1
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1885:# 5. Teste gem-hunter + trending (conceito GitTrend)
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1886:hermes run "Use gem-hunter: liste 1 gem recente de agent infra que complemente nosso skill-discovery (SKILL.md ou 4-tier memory). Explique por que vale a pena e qual o próximo passo seguro."
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1902:Gem Hunting	GitTrend + nosso gem-hunter	Descoberta automática de skills	P1
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:1983:Auto-capture de highlights/podcasts → pode ser estendido via gem-hunter + skill-discovery (não copiar Readwise).
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2027:Verificação direta: package gem-hunter existe em enioxt/egos/packages/gem-hunter.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2030:Integra com skill-discovery, gem-hunter + atrian-observability para ingestão + validação.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2037:Research agent (tracking AI news)	Parcial (gem-hunter + skill-discovery)	Loop 24/7 automático	Gemini Flash (~R$0,001/1k tokens)
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2038:Dreamer (gera ideias de build)	Não tem (só gem-hunter passivo)	Sim	Mesmo modelo barato
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2047:Adicionar “Dreamer” leve no gem-hunter
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2048:Novo job: gem-hunter + skill-discovery roda daily → gera 1-3 ideias de build + evidências.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2050:Benefício: transforma nosso gem-hunter de “descobridor passivo” em “Auto-think” ativo.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2056:Usar o mesmo pipeline do gem-hunter atual.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2065:hermes run "Use gem-hunter + Understanding Gate: analise o diagrama Auto-Think + Auto-Build do post. Sugira 1 melhoria concreta e barata (Gemini Flash via OpenRouter) para nosso skill-discovery + mcp-memory."
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2066:Se quiser, gero o diff exato para adicionar o Dreamer leve no gem-hunter.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2119:Research agent	✅ Parcial	gem-hunter + skill-discovery
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2140:Criar Dreamer leve no gem-hunter
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2141:Job diário: gem-hunter + skill-discovery → gera candidate idea contracts.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2158:Benefício: transforma nosso gem-hunter de “descobridor passivo” em Auto-think real, com receipts e separação de papéis, sem custo extra de modelo.
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2167:hermes run "Use gem-hunter + Understanding Gate: analise o guia completo de Auto-think + Auto-build. Sugira 1 melhoria concreta e barata (Gemini Flash) para nosso skill-discovery + mcp-memory. Entregue apenas o próximo passo executável."
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2236:Não criar novo marketplace ou LlamaHub (mantém skill-discovery + gem-hunter).
docs/_archived_research/2026-05-11-chatgrok-commercial-epos-gstack.md:2244:hermes run "Use Understanding Gate + gem-hunter: analise o LlamaIndex. Sugira 1 melhoria concreta e barata (Gemini Flash) para nosso knowledge-mcp ou mcp-memory. Entregue apenas o próximo passo executável."
docs/modules/CHATBOT_SSOT.md:689:  slug: string              // Identificador único (intelink, 852, gem-hunter)
docs/modules/CHATBOT_SSOT.md:770:| **gem-hunter** | `/home/enio/egos/agents/agents/gem-hunter.ts` | Not yet exposed (CHATBOT-EVO-GH-004) | — | — |
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:91:- [agents/agents/gem-hunter.ts](/home/enio/egos/agents/agents/gem-hunter.ts)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:92:- [agents/api/gem-hunter-server.ts](/home/enio/egos/agents/api/gem-hunter-server.ts)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:93:- [docs/gem-hunter/SSOT.md](/home/enio/egos/docs/gem-hunter/SSOT.md)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:94:- [docs/gem-hunter/gems-2026-05-14.md](/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:333:- [agents/agents/gem-hunter.ts](/home/enio/egos/agents/agents/gem-hunter.ts)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:334:- [agents/api/gem-hunter-server.ts](/home/enio/egos/agents/api/gem-hunter-server.ts)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:335:- [docs/gem-hunter/SSOT.md](/home/enio/egos/docs/gem-hunter/SSOT.md)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:336:- [docs/gem-hunter/gems-2026-05-14.md](/home/enio/egos/docs/gem-hunter/gems-2026-05-14.md)
docs/_archived_handoffs/2026-05/handoff_2026-05-15_espiral-integrations-audit.md:337:- [docs/products/gem-hunter.md](/home/enio/egos/docs/products/gem-hunter.md)
docs/governance/agent_scopes_and_governance.md:23:> **🔗 Reconciliação com `agents/registry/agents.json` (v2.5.0):** os agentes nomeados acima (Prime/Operator/EVA/Guarani/?!?-Codex/Gemini/Hermes) são **papéis de orquestração LLM** — não têm `entrypoint` de script e NÃO entram em `agents.json` (cujo schema exige executável). `agents.json` é SSOT dos **agentes-ferramenta** (ssot-auditor, drift-sentinel, gem-hunter, etc.). Este documento é SSOT dos **papéis LLM**. Não duplicar: papel LLM → aqui; script executável → `agents.json`.
docs/_archived_handoffs/2026-05/GPT54_INVESTIGATION_PROMPT.md:21:- 10 containers Docker catalogados (gem-hunter, guard-brasil, gateway, hq, evolution-api, 852-app, openclaw-sandbox, bracc-neo4j, caddy, redis)
docs/governance/CHATBOT_CONSTITUTION.md:113:**Adapter pattern, não core obrigatório.** Bots existentes (intelink, gem-hunter, br-acc, 852, forja, carteira-livre, egos-lab-chat) NÃO são forçados a adotar esta constituição agora.
docs/governance/SIGNAL_MESH.md:2:**Version:** 1.0.0 | **Last updated:** 2026-04-02 | **Owner:** gem-hunter + world-model agents
docs/governance/SIGNAL_MESH.md:29:| X API (Bearer) | Social | 500K tokens/mo (Basic) | ~$0.30 | ★★★★★ | gem-hunter, kol-discovery | signals.json |
docs/governance/SIGNAL_MESH.md:31:| Telegram channels | Social | bot API: unlimited read | free | ★★★★☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:32:| arXiv API | Academic | 3 req/s, no auth | free | ★★★★★ | gem-hunter (PWC pipeline) | papers.json |
docs/governance/SIGNAL_MESH.md:33:| Papers With Code | Academic | no official limit | free | ★★★★★ | gem-hunter | papers.json |
docs/governance/SIGNAL_MESH.md:34:| GitHub Trending | Dev | 5K req/hr (auth) | free | ★★★★☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:35:| GitHub API (stars/forks) | Dev | 5K req/hr | free | ★★★★☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:37:| Reddit (r/crypto, r/MachineLearning) | Social | 100 req/min (OAuth) | free | ★★★☆☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:39:| HuggingFace trending | ML | no rate limit | free | ★★★★☆ | gem-hunter | papers.json |
docs/governance/SIGNAL_MESH.md:40:| CoinGecko API | Markets | 30 req/min (free) | free | ★★★☆☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:41:| DeFiLlama | Markets | public, no limit stated | free | ★★★★☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:42:| Dune Analytics | On-chain | 10 req/s (free tier) | free | ★★★★☆ | gem-hunter | signals.json |
docs/governance/SIGNAL_MESH.md:43:| DashScope (Alibaba) | LLM | quota per key | ~$0.50 | ★★★★☆ | gem-hunter (inference) | — |
docs/governance/SIGNAL_MESH.md:74:  - Run: `bun scripts/kol-discovery.ts` → `docs/gem-hunter/kol-list.json`
docs/governance/SIGNAL_MESH.md:118:- Exa budget: reserve 200 queries/month for gem-hunter, 300 for kol-discovery, 500 for world-model
docs/governance/SIGNAL_MESH.md:126:| `gem-hunter` | arXiv, PWC, GitHub Trending, CoinGecko, DeFiLlama | X API, Reddit, Telegram | signals.json, papers.json |
docs/governance/SIGNAL_MESH.md:157:- [ ] Wire Telegram bot listener to `gem-hunter` signal ingestion pipeline
docs/_archived_handoffs/2026-05/MEMORY_INTEGRATION_SELECTIVE_EXTRACTION.md:87:│  ├── 852            ├── gem-hunter        ├── discoveries       │
docs/knowledge/TELEGRAM_ALERTS_INVENTORY.md:39:| `/hunt` | Executar gem-hunter | ✅ Funcionando |
docs/knowledge/TELEGRAM_ALERTS_INVENTORY.md:112:**Arquivo:** `agents/agents/gem-hunter.ts`
docs/knowledge/TELEGRAM_ALERTS_INVENTORY.md:147:**Última ação:** Removido falsos positivos (kol-discovery, gem-hunter-api)
docs/knowledge/OBSIDIAN_SETUP_GUIDE.md:54:ln -s ~/github/gem-hunter ./Gem-Hunter-Repo
docs/knowledge/VALUATION_RESEARCH_SYNTHESIS.md:84:| **Gem Hunter** | Ferramenta / AI | [gem-hunter.ts:1](file:///home/enio/egos/agents/agents/gem-hunter.ts) | `bun agent:run gem-hunter --dry` (em `/home/enio/egos`) | **Live** (MVP) | Discovery de novas tecnologias | Médio (288+ catalogados) |
docs/_archived_handoffs/2026-05/handoff_2026-05-03_atlas-to-sonnet.md:109:| omniview · video-editor · pixelart · gem-hunter | active | público | live |
docs/_archived_handoffs/2026-05/handoff_2026-05-03_atlas-to-sonnet.md:157:✅ gem-hunter → main 66cf27a
docs/governance/SSOT_LOCATION_POLICY.md:13:Leaf-repos (852, forja, carteira-livre, intelink, hermes-egos, gem-hunter, blueprint-egos) **não podem** declarar nada como "canonical" ou "SSOT". Devem **apontar** para o canonical no kernel via `UPSTREAM_KERNEL.md`.
docs/_archived_handoffs/2026-05/CROSS_WINDOW_TASKS_2026-05-06.md:160:- `GEM-GH-*` — gem-hunter github
docs/knowledge/HARVEST.md:1345:**2 false positives (`kol-discovery` and `gem-hunter-api` were alive in `scripts/` and `agents/api/`), 2 true positives (actually dead agents).**
docs/knowledge/HARVEST.md:1392:- `agents/registry/agents.json` — cleaned 2 dead agents (aiox-gem-hunter, mastra-gem-hunter)
docs/knowledge/HARVEST.md:1427:6-stage pipeline: S1 Discovery (arXiv no_code + PWC no_implementations) → S2 Abstract Triage (free LLM scores 0-100) → S3 Deep Reading (Gemini Flash, targeted sections) → S4 Scaffold Generation (.ts stubs + .md spec) → S5 Scoring + World Model → S6 Trend Evolution. Output: docs/gem-hunter/papers/<paper-id>/ with REPORT.md, architecture.ts, stubs.ts, spec.test.ts.
docs/knowledge/HARVEST.md:1463:Result: 3 killed (gtm-harvester, aiox-gem-hunter, mastra-gem-hunter), 5 kept with evidence.
docs/knowledge/HARVEST.md:1466:Any agent that can't complete `--dry` in 30s is broken. Single-repo scanners are redundant when gem-hunter v3.2 covers 13 sources.
docs/knowledge/HARVEST.md:1477:- gem-hunter: `gem_hunter_gems` + `gem_hunter_runs` tables
docs/knowledge/HARVEST.md:2478:**gem-hunter specific:** Added `early-warning` track for monitoring day-0 AI releases (e.g., HKUDS/OpenHarness by @huang_chao4969). Track type union extended: `"early-warning"` added to `SearchTrack`.
docs/knowledge/HARVEST.md:2955:**`127.0.0.1:3050:3050` (gateway), `127.0.0.1:3095:3095` (gem-hunter-server)**
docs/knowledge/HARVEST.md:2993:  const gems = readGemsFromFile(); // reads latest-run.json
docs/knowledge/HARVEST.md:3013:**`gem-hunter.ts` generates `{generatedAt, byCategory, bySource}` but dashboard expects `{date, gems:[{name,url,score,...}]}`.**
docs/knowledge/HARVEST.md:3190:- Ativação mínima: `import { AtomizerCore } from '@egos/atomizer'` no gem-hunter pipeline + `InMemorySearch.search()`
docs/knowledge/HARVEST.md:3597:- x-reply-bot uses min_likes threshold only (no Qwen scoring for relevance). Qwen in gem-hunter only scores papers (runPaperPipeline). Low-star gems from big-tech engineers require explicit bypass rules.
docs/knowledge/HARVEST.md:4546:**APIs live:** DashScope (Alibaba) in article-writer + wiki-compiler; OpenRouter in gem-hunter.
docs/knowledge/HARVEST.md:4607:- gem-hunter API server is already standalone (0 kernel imports). Core agent (2538 LOC) still embedded — needs Phase 3 migration before npm publish.
docs/knowledge/HARVEST.md:5053:3. Product evidence (gem-hunter, guard-brasil, opus-mode)
docs/knowledge/HARVEST.md:5088:IDEIA: [EGOS-INTEL-013] Importar Sacred Math Scoring (φ áureo) para gem-hunter + 852
docs/knowledge/HARVEST.md:5103:IDEIA: [INFRA-PC-007] Adicionar pre-commit em gem-hunter, blueprint-egos (minimal) | 30min
docs/knowledge/HARVEST.md:5121:| Pramana Confidence System | br-acc/frontend/.../confidence-system.ts | egos rule global, gem-hunter |
docs/knowledge/HARVEST.md:5122:| Sacred Math Scoring (φ) | br-acc/api/.../bracc/services/ | egos, gem-hunter |
docs/_archived_handoffs/2026-05/PAPERCLIP_ORG.md:20:  └── gem-hunter adaptive CCR
docs/_archived_handoffs/2026-05/PAPERCLIP_ORG.md:49:| `gem-hunter` | Gem Hunter | Director | custom/egos | egos-kernel |
docs/_archived_handoffs/2026-05/MIGRATION_MATRIX.md:42:| App-specific agents | `gem-hunter`, `report-generator` |
docs/governance/README_AUDIT.md:27:| **gem-hunter** | product-beta | 167L | PT-BR | 4/5 | 4/5 | Bom | — | NADA |
docs/governance/README_AUDIT.md:106:| OK | intelink, 852, egos-lab, pixelart, gem-hunter, carteira-livre | Manter |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:30:**Local:** `agents/agents/gem-hunter.ts` (v6.1, 2250 linhas)
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:67:**GitHub Actions:** `.github/workflows/gem-hunter-adaptive.yml`
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:73:bun agent:run gem-hunter --exec                    # Full run
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:74:bun agent:run gem-hunter --exec --quick            # Top 3 per keyword
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:75:bun agent:run gem-hunter --exec --analyze          # AI synthesis
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:76:bun agent:run gem-hunter --history                 # SQLite trends
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:158:| X API | Social | gem-hunter, kol-discovery | signals.json |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:159:| arXiv | Academic | gem-hunter | papers.json |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:160:| GitHub Trending | Dev | gem-hunter | signals.json |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:161:| GitHub API | Dev | gem-hunter | signals.json |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:163:| Reddit | Social | gem-hunter | signals.json |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:288:| **Gem Hunter** | Fork Hunter é módulo novo do gem-hunter.ts ou agent separado |
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:304:- Persistir: `docs/gem-hunter/forks.json`
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:309:- Persistir: `docs/gem-hunter/fork-diffs/{owner}.json`
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:433:- `agents/agents/gem-hunter.ts` — v6.1 source
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:434:- `docs/gem-hunter/SSOT.md` — Gem Hunter canonical
docs/analysis/GEM_HUNTER_ARR_ANALYSIS.md:435:- `docs/gem-hunter/GEM_HUNTER_v6_MASTER_PLAN.md` — Master plan
docs/_archived_handoffs/2026-05/ACTION_ITEMS_USER.md:72:   - **Platform:** Kernel EGOS (gem-hunter, wiki-compiler)
docs/_archived_handoffs/2026-05/handoff_2026-05-04_pixelart-egos-session.md:5:repos_touched: egos, pixelart, 852, carteira-livre, egos-lab, gem-hunter
docs/_archived_handoffs/2026-05/handoff_2026-05-04_pixelart-egos-session.md:79:- **gem-hunter** `d557c19`: README 1.5→5/5 PT-BR
docs/_archived_handoffs/2026-05/handoff_2026-05-04_pixelart-egos-session.md:252:- ✅ 5 READMEs atualizados para score 5/5 PT-BR (gem-hunter, 852, carteira-livre, egos-lab, pixelart)
docs/knowledge/CAPABILITY_CROSS_INDEX.md:68:## gem-hunter
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:9:head_gem-hunter: d557c19 (github.com/enioxt/gem-hunter ✅ novo)
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:49:gem-hunter        d557c19 ← NOVO github.com/enioxt/gem-hunter
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:66:### gem-hunter
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:68:  - `egos/packages/gem-hunter/` → `@egosbr/gem-hunter` (lib CLI no kernel)
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:69:  - `/home/enio/gem-hunter/` → servidor standalone (gemhunter.egos.ia.br)
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:70:- GitHub repo criado: `github.com/enioxt/gem-hunter` + pushed ✅
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:130:- `egos/packages/gem-hunter/` = lib/CLI para uso interno dos agentes
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:131:- `gem-hunter/` standalone = servidor HTTP com endpoints REST (já deployado)
docs/_archived_handoffs/2026-05/handoff_2026-05-04_final.md:182:- Repos GitHub novos: gem-hunter
docs/archaeology/AGENT_LINEAGE_MATRIX.md:37:| 25 | `gem_hunter` | Gem Hunter | knowledge | 2026-03-06 | `e0f2d7a` | agents/agents/gem-hunter.ts | active | 4 | kernel |
docs/reports/workflow-override-audit.md:15:| egos-lab | mycelium.md | 98 lines (custom) | 46 lines | LEGITIMATE — lab has session:guard, gem-hunter, worker surfaces |
docs/reports/workflow-override-audit.md:32:4. Repo-role-aware session:guard/gem-hunter/report-generator
docs/archaeology/LINEAGE_REPORT.md:160:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
docs/archaeology/LINEAGE_REPORT.md:161:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
docs/archaeology/LINEAGE_REPORT.md:188:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
docs/archaeology/LINEAGE_REPORT.md:189:- **2026-03-07** feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats
docs/reports/critical-maturity-assessment-2026-03-13.md:84:| **Substantial (>200 lines, real I/O)** | 12 | ssot-auditor (3075!), gem-hunter (967), security-scanner (626) |
docs/reports/critical-maturity-assessment-2026-03-13.md:91:`gem-hunter`, `orchestrator`, `report-generator`, `social-media` — these have `runner:0`, meaning they bypass the agent runtime entirely. They're legacy scripts wearing agent costumes.
docs/reports/critical-maturity-assessment-2026-03-13.md:104:| **Leave in egos-lab** | ~7 | App-specific (gem-hunter, orchestrator, report-generator) |
docs/products-specs/gem-hunter.md:5:> **Repo:** `/home/enio/egos` (packages/gem-hunter + agents/agents/) | **Production URL:** embedded in EGOS Gateway
docs/products-specs/gem-hunter.md:13:Results are ranked by relevance score, categorized, and stored in Supabase. A daily job runs to keep findings fresh. The public package `@egosbr/gem-hunter` provides programmatic access.
docs/products-specs/gem-hunter.md:21:| Runner | Bun agent (`wiki-compiler.ts` gem-hunter mode) | Integrated with wiki compilation pipeline |
docs/products-specs/gem-hunter.md:24:| Public API | `@egosbr/gem-hunter` npm package | Programmatic access |
docs/products-specs/gem-hunter.md:42:[Public: @egosbr/gem-hunter SDK / Gateway REST]
docs/products-specs/gem-hunter.md:45:**Pending:** Gem Hunter should be migrated to a standalone repo (`gem-hunter`) separate from the kernel. It's currently embedded in the wiki-compiler agent — migration is tracked in TASKS.md.
docs/products-specs/gem-hunter.md:56:| Public SDK: `@egosbr/gem-hunter` | ✅ published npm | `npm view @egosbr/gem-hunter version` |
docs/products-specs/gem-hunter.md:57:| GemHunter.hunt() + findLatest() | ✅ typed API | `packages/gem-hunter/src/index.ts` |
docs/products-specs/gem-hunter.md:74:import { GemHunter } from '@egosbr/gem-hunter';
docs/_archived_handoffs/2026-05/OPENCLAW_SSOT.md:218:| Latest gem research | `docs/gem-hunter/gems-2026-04-06.md` | Market intelligence, OpenClaw ecosystem |
docs/products-specs/egos-gateway.md:15:- **Gem Hunter** — discovery engine results API (`/gem-hunter/*`), tier-based access
docs/products-specs/egos-gateway.md:45:    ├── /gem-hunter/*     → gem-hunter-api channel → reports/SQLite
docs/products-specs/egos-gateway.md:67:| Gem Hunter API (tiered: free/starter/pro) | ✅ production code | `curl https://gateway.egos.ia.br/gem-hunter/latest` |
docs/products-specs/egos-gateway.md:68:| Gem Hunter auth + rate limiting | ✅ code (GH-068/069) | `src/channels/gem-hunter-api.ts` — Supabase gem_hunter_api_keys |
docs/products-specs/egos-gateway.md:91:| GET | `/gem-hunter/latest` | Latest gems by score | Bearer (tier-based) |
docs/products-specs/egos-gateway.md:92:| GET | `/gem-hunter/sector/:name` | Filter gems by sector | Bearer (tier-based) |
docs/products-specs/egos-gateway.md:93:| GET | `/gem-hunter/trending` | Trending across multiple runs | Bearer (Pro) |
docs/products-specs/egos-gateway.md:130:| `apps/egos-gateway/src/channels/gem-hunter-api.ts` | Gem Hunter tiered API + auth |
docs/archaeology/lineage-data.json:2951:        "agents/agents/gem-hunter.ts"
docs/archaeology/lineage-data.json:3158:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
docs/archaeology/lineage-data.json:3169:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
docs/archaeology/lineage-data.json:3218:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
docs/archaeology/lineage-data.json:3280:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
docs/archaeology/lineage-data.json:3302:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
docs/archaeology/lineage-data.json:3353:      "message": "feat: gem-hunter v2 auto-exec + AI landscape research + orchestrator fixes",
docs/archaeology/lineage-data.json:3513:        "scripts/gem-hunter-freshness.ts"
docs/archaeology/lineage-data.json:3933:      "entrypoint": "agents/agents/gem-hunter.ts"
docs/archaeology/lineage-data.json:4270:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
docs/archaeology/lineage-data.json:4281:      "message": "feat: mycelium orchestrator + workflow /mycelium + GitHub OAuth fix + gem-hunter tracks + honest stats",
docs/governance/LLM_FALLBACK_CHAIN.md:60:| `gem-hunter-digest.ts` | Modelo padrão | `callWithFallback` | $5-10 |
docs/governance/LLM_FALLBACK_CHAIN.md:75:4. ⏳ Migrar gem-hunter-digest + x-reply-bot
docs/_archived_handoffs/2026-05/TRANSPARENCY_COUNCIL_HANDOFF.md:31:{ session_id: "anon-abc123", agent: "gem-hunter", tools_called: 7, cost_usd: 0.003, duration_ms: 4200, status: "ok", date: "2026-04-27" }
docs/_archived_handoffs/2026-05/TRANSPARENCY_COUNCIL_HANDOFF.md:124:✅ 2 agents wired a `egos_agent_events` (começando com morning-report + gem-hunter)
docs/social/ARTICLE_VOICE.md:211:   - `bun agents/agents/gem-hunter.ts --query "<topic>"`
docs/personal-os/CAREER_FIT_STUDY.md:89:| Build de sistemas (TS/agents/RAG/MCP) | plus (moat) | ✔ core | ✔ core | plus | 🟡→🟢 (intelink, gem-hunter, MCPs) |
docs/personal-os/CAREER_FIT_STUDY.md:141:| EGOS/IP leverage (reusa o que ele construiu) | 0.15 | não joga fora intelink/gem-hunter/guard |
docs/governance/PRECOMMIT_SSOT.md:49:| **minimal** | Repos arquivados, gem-hunter, blueprint-egos | `01-secrets` |
docs/governance/PRECOMMIT_SSOT.md:65:bash scripts/install-precommit.sh /home/enio/gem-hunter minimal
docs/governance/PRECOMMIT_SSOT.md:110:| gem-hunter | nenhum | minimal | 🔴 instalar |
docs/products-specs/INDEX.md:14:| **Gem Hunter** | 🔄 Migrating to standalone | `/home/enio/egos` (embedded) | `gem-hunter.md` — TODO |
docs/personal-os/FOCUS_GATES.md:143:4. Phase 3 (3-5min) — recon paralelo em 8 sources (codebase, HARVEST, exa, GitHub, arxiv, reddit, X, gem-hunter)
docs/_archived_handoffs/2026-05/handoff_2026-05-11_session-2-vps-cet-capabilities.md:52:- Telegram: já ativo via egos-gateway (channels: whatsapp, telegram, knowledge, gem-hunter)
docs/governance/AI_COVERAGE_MAP.md:109:| `agents/gem-hunter.ts` | Gem Hunter | Qwen Plus / Gemini Flash | Multi-track discovery (early-warning added 2026-04-01) |
docs/SYSTEM_MAP.md:169:- Core agents: `ssot-auditor`, `drift-sentinel`, `dep-auditor`, `context-tracker`, `mcp-router`, `spec-router`, `gem-hunter`, `wiki-compiler`
docs/SYSTEM_MAP.md:203:| `apps/gem-hunter-landing/` | Gem Hunter landing | ✅ Active |
docs/SYSTEM_MAP.md:242:| `packages/gem-hunter/` | Gem Hunter logic |
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:55:**SSOT:** `agents/agents/gem-hunter.ts` (2350 linhas) | `docs/gem-hunter/SSOT.md`
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:66:**Scoring prompts SSOT:** `docs/gem-hunter/prompts/scoring-v1.md` (versionado 2026-04-08)
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:194:| Gem Hunter API | gem-hunter | 3070 | ✅ |
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:428:| `docs/gem-hunter/SSOT.md` | Gem Hunter canonical |
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:429:| `docs/gem-hunter/prompts/scoring-v1.md` | Prompts de scoring versionados |
docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md:435:| `agents/agents/gem-hunter.ts` | Gem Hunter runtime (2350 linhas) |
docs/governance/TASKS_HUMAN_VALIDATION_REQUIRED.md:124:**Task:** Consolidar gem-hunter dailies (LAB-ARCHIVE-001)
docs/governance/SKILLS_REGISTRY.md:31:- **Skill:** A reusable capability exposed via `/command` (e.g., `/start`, `/audit`, `/gem-hunter`)
docs/governance/SKILLS_REGISTRY.md:74:| **gem-hunter** | intelligence | discovery | T0 | ~2026-04-14 | Active (120s runs) |
docs/governance/SKILLS_REGISTRY.md:89:| **gem-hunter-api** | intelligence | API wrapper for gem-hunter discovery | Planned (nullms ETA) |
docs/governance/SKILLS_REGISTRY.md:215:| **/gem-hunter** | Extracted ✅ | enioxt/gem-hunter-skill | Awaiting release (MIT+README) |
docs/governance/SKILLS_REGISTRY.md:271:                  gem-hunter, kol-discovery
docs/governance/SKILLS_REGISTRY.md:328:   → ex: ssot-auditor, security-scanner, gem-hunter, morning-report
docs/governance/SKILLS_REGISTRY.md:360:| VPS cron | Agents (morning-report, gem-hunter) | Programada |
docs/governance/SKILLS_REGISTRY.md:399:0  9 * * 1   bun /home/enio/egos/scripts/gem-hunter.ts
docs/governance/EXECUTIVE_SUMMARY_DECISION_MATRIX.md:126:│ gem-hunter-server  │ 3095   │ ✅ Up   │ Gem Hunter API              │
docs/governance/EXECUTIVE_SUMMARY_DECISION_MATRIX.md:144:| Gem Hunter Refresh | Segunda 6:00 | `/opt/bracc/scripts/gem-hunter-refresh.sh` | VPS Agent |
docs/_archived_handoffs/2026-05/TASK_EXECUTION_ROADMAP.md:132:  - Standalone Docker image: `enioxt/gem-hunter:latest`
apps/egos-hq/app/api/hq/gems/route.ts:3:// HQV2-003 — proxy to gem-hunter API via gateway
apps/egos-hq/app/api/hq/gems/route.ts:7:    const res = await fetch(`${gatewayBase}/gem-hunter/product`, {
docs/governance/REGISTRY_PARITY_DECISION.md:16:  `auth-server`, `catalogo-ia`, `egos-council`, `egos-landing`, `gem-hunter-landing`,
docs/_archived_handoffs/2026-05/TRANSPARENCY_SYSTEM_ARCH.md:28:**Products without transparency pages:** HQ, egos-site, gem-hunter-landing, video-editor, ratio
docs/_archived_handoffs/2026-05/TRANSPARENCY_SYSTEM_ARCH.md:29:**Agents not logging events:** gem-hunter.ts, doc-drift.ts, ssot-auditor.ts, morning-report.ts
docs/_archived_handoffs/2026-05/TRANSPARENCY_SYSTEM_ARCH.md:49:- Guard Brasil, egos-site, gem-hunter add link in footer
docs/_archived_handoffs/2026-05/TRANSPARENCY_SYSTEM_ARCH.md:100:- [ ] `TRANS-L2-001`: Wire `morning-report.ts` + `gem-hunter.ts` to write to `egos_agent_events` — 1h
docs/governance/VPS_OPERATIONS.md:42:| gem-hunter-landing | Up | :3070 | `/home/enio/gem-hunter/` |
docs/governance/VPS_OPERATIONS.md:92:| gemhunter.egos.ia.br | gem-hunter-landing:3070 |
docs/governance/AGENT_GUARDRAILS_STANDARD.md:134:### Gem-hunter queries (run `bun agents/cli.ts run gem-hunter --exec` or `gemhunter:exec`)
docs/governance/AGENT_GUARDRAILS_STANDARD.md:156:| **Guarani-local** (no commit) | Antigravity/Gemini: local inspection, prototyping diffs, running evals locally, writing test cases, drafting docs — leaves work staged + handoff | build adversarial eval cases (P5), run gem-hunter, local typecheck, draft 1-pagers |
docs/governance/REPO_MAP.md:37:| **product-beta** | gem-hunter | `/home/enio/gem-hunter` | 5 | 4/5 PT-BR | NOTHING |
docs/governance/REPO_MAP.md:96:**gem-hunter** (`/home/enio/gem-hunter`) — 424K | 5 commits reais
docs/governance/MASTER_INDEX.md:107:| 12 | gem-hunter | `agents/agents/gem-hunter.ts` | ✅ | 2026-04-06 |
docs/governance/MASTER_INDEX.md:109:| 14 | gem-hunter-api | `agents/api/gem-hunter-server.ts` | ✅ | 2026-04-06 |
docs/governance/MASTER_INDEX.md:188:| **Path** | `egos/agents/agents/gem-hunter.ts` |
docs/governance/MASTER_INDEX.md:218:- API: `agents/api/gem-hunter-server.ts`
docs/governance/MASTER_INDEX.md:465:| **Gem Hunter** | `agents/agents/gem-hunter.ts` | v6.0, dashboard live |
docs/governance/MASTER_INDEX.md:491:| `feat(gem-hunter)` | 3 | Discovery engine upgrades |
docs/governance/MASTER_INDEX.md:790:| **gem-hunter.ts** | `agents/agents/gem-hunter.ts` | GH-001..071 | Discovery engine |
docs/governance/MASTER_INDEX.md:921:| `@egos/atomizer` | wiki-compiler, gem-hunter | Semantic atomization |
docs/governance/MASTER_INDEX.md:971:  "https://gemhunter.egos.ia.br/gem-hunter/topics" \
docs/governance/README_PADRAO_OURO.md:185:| gem-hunter | 1.5/5 | 🔴 P0 urgente | Reescrever do zero |
docs/_archived_handoffs/2026-05/GEM_HUNTER_MARKET_DOMINATION_ROADMAP.md:68:- [ ] Create `scripts/gem-hunter-digest.ts` — aggregates top 3-5 repos/week by score
docs/_archived_handoffs/2026-05/GEM_HUNTER_MARKET_DOMINATION_ROADMAP.md:80:- [ ] Caddy routing: gemhunter.egos.ia.br → egos-site:3070/gem-hunter
docs/_archived_handoffs/2026-05/GEM_HUNTER_MARKET_DOMINATION_ROADMAP.md:135:- [ ] Slash command: `/gem-hunter trending [language]`
docs/_archived_handoffs/2026-05/GEM_HUNTER_MARKET_DOMINATION_ROADMAP.md:275:1. [ ] `scripts/gem-hunter-digest.ts` — read last 7 days of gems, select top 3-5
docs/governance/MASTER_INDEX_APPENDIX.md:21:| **gem-hunter.ts** | `agents/agents/gem-hunter.ts` | GH-001..071 | Discovery engine |
apps/egos-hq/app/api/hq/events/public/route.ts:13:  'gem-hunter',
apps/egos-hq/app/api/hq/events/agents/route.ts:19:  'gem-hunter',
docs/skills/SKILLS_USAGE_TRACKING.md:236:- Produto C (Eagle Eye): 1 cron run (gem-hunter)
docs/_archived_handoffs/2026-04/handoff_2026-04-28.md:80:| GH-STANDALONE-008 | Publicar `@egosbr/gem-hunter-core` no npm | sem bloqueio |
apps/egos-hq/app/api/tasks/route.ts:34:  { slug: 'gem-hunter',     color: '#f97316' },
docs/_archived_handoffs/2026-04/handoff_2026-04-29-skills-sprint.md:20:- 3 GitHub skill repos created: guard-brasil-skill, egos-governance-skill, gem-hunter-skill
docs/_archived_handoffs/2026-04/handoff_2026-04-29-skills-sprint.md:34:**GH-STANDALONE-008** — Push gem-hunter-skill content
docs/_archived_handoffs/2026-04/handoff_2026-04-29-skills-sprint.md:35:- Repo created at `enioxt/gem-hunter-skill`
docs/_archived_handoffs/2026-04/handoff_2026-04-29-skills-sprint.md:36:- Source at `packages/gem-hunter/src/index.ts` (API client + types)
docs/_archived_handoffs/2026-04/handoff_2026-04-29-skills-sprint.md:69:- `enioxt/gem-hunter-skill` — ⏳ content pending (source ready, README needed)
docs/_archived_handoffs/2026-04/handoff_2026-04-14.md:22:- **BUG-GOV-004** — gem-hunter endpoint: `expected_contains: "sectors"` → `"Gem Hunter"` (URL retorna HTML)
docs/_archived_handoffs/2026-04/handoff_2026-04-07_p35_ssot_gate_complete.md:63:4. **ARR-001** — `import { AtomizerCore }` no gem-hunter, primeiro consumer real do AAR
docs/_archived_handoffs/2026-04/handoff_2026-04-08.md:17:- **CORAL-001/002** — gem_discoveries table + gem-hunter dedup cache (30-50% API savings).
docs/_archived_handoffs/2026-04/handoff_2026-04-08.md:39:2. **GH-086** — @egosbr/gem-hunter-mcp MCP server package
docs/_archived_handoffs/2026-04/handoff_2026-04-02.md:30:### Gem Hunter v5.1 (EGOS repo — `agents/agents/gem-hunter.ts`)
docs/_archived_handoffs/2026-04/handoff_2026-04-02.md:128:- [ ] Sync gem-hunter.ts v5.1 from egos → egos-lab
docs/_archived_handoffs/2026-04/handoff_2026-04-02.md:134:- [ ] gem-hunter.ts v5.1 sync to egos-lab
docs/_archived_handoffs/2026-04/handoff_2026-04-02.md:142:3. **GH-048**: Structural validation in gem-hunter — enables GH-049/050
docs/_archived_handoffs/2026-04/handoff_2026-04-15_tarde.md:51:- **GH-STANDALONE-003** — `gem-hunter-server.ts` standalone: aguarda teste real (depende de `ai-engine.ts`)
docs/_archived_handoffs/2026-04/handoff_2026-04-15_tarde.md:61:4. **GH-STANDALONE-005/006** — gem-hunter standalone: atualizar SSOT.md + criar repo separado
docs/_archived_handoffs/2026-04/handoff_2026-04-23.md:95:- **Security:** `grep UNMITIGATED docs/gem-hunter/secops-*.md` returned no active unmitigated findings.
apps/egos-hq/app/api/internal/discover/route.ts:22:    'agent-events',       // egos_agent_events (5 agents wired: morning-report, doc-drift, ssot-auditor, article-writer, gem-hunter)
docs/_archived_handoffs/2026-04/handoff_2026-04-26b.md:88:**Fix necessário:** Verificar se os agentes (wiki-compiler, gem-hunter, etc.) estão de fato escrevendo em `egos_agent_events`. Se não, ou reconectar o pipeline de eventos, ou usar uma tabela diferente como fonte.
docs/_archived_handoffs/2026-04/handoff_2026-04-03_agent_registry.md:19:| aiox-gem-hunter | [KILLED 2026-03-31] | morto | ✅ Removido do registry |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_agent_registry.md:20:| mastra-gem-hunter | [KILLED 2026-03-31] | morto | ✅ Removido do registry |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_agent_registry.md:22:| gem-hunter-api | ✅ VIVO | `agents/api/gem-hunter-server.ts` | ✅ Falso positivo |
docs/_archived_handoffs/2026-04/handoff_2026-04-17.md:25:- **OBS-CENTRAL-008**: Anomaly detector + hourly cron. Fix mem_pct parseInt bug. Fix gem-hunter port 3097→3095.
docs/_archived_handoffs/2026-04/handoff_2026-04-05.md:39:- **Uncommitted**: 4 untracked files (`.claude/worktrees/`, `business/DPONET_PRIVACYTOOLS_DEEP_RESEARCH.md`, gem-hunter output files — intentionally not committed)
docs/_archived_handoffs/2026-04/handoff_2026-04-08-telegram-audit.md:19:| Gem Hunter | `agents/agents/gem-hunter.ts` | ✅ Ativo | Rich format |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_p17_complete.md:20:| aiox-gem-hunter | [KILLED 2026-03-31] | morto | ✅ Removido do registry |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_p17_complete.md:21:| mastra-gem-hunter | [KILLED 2026-03-31] | morto | ✅ Removido do registry |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_p17_complete.md:23:| gem-hunter-api | ✅ VIVO | `agents/api/gem-hunter-server.ts` | ✅ Falso positivo |
docs/_archived_handoffs/2026-04/handoff_2026-04-03_p17_complete.md:123:1. **Manter kol-discovery/gem-hunter-api no registry?** ✅ SIM — entrypoints válidos em paths não-padrão
docs/_archived_handoffs/2026-04/handoff_2026-04-03_p17_complete.md:124:2. **Remover agentes KILLED?** ✅ SIM — aiox-gem-hunter e mastra-gem-hunter removidos
docs/_archived_handoffs/2026-04/handoff_2026-04-06_p30.md:39:5. **GH-067**: Deploy gem-hunter-server to VPS (gemhunter.egos.ia.br) — next revenue vector
docs/_archived_handoffs/2026-04/handoff_2026-04-01.md:35:- All Haiku model, reports to docs/jobs/ + docs/gem-hunter/
docs/_archived_handoffs/2026-04/handoff_2026-04-29-wave1-final.md:27:  - Same evidence base (real products: gem-hunter, guard-brasil, opus-mode)
docs/_archived_handoffs/2026-04/handoff_2026-04-29-wave1-final.md:118:- **Evidence anchor:** Real EGOS components (trigger-evals.ts, resolver-v3.ts) + shipped products (gem-hunter, guard-brasil, opus-mode)
package.json:123:    "gemhunter:dry": "bun agents/cli.ts run gem-hunter --dry",
package.json:124:    "gemhunter:exec": "bun agents/cli.ts run gem-hunter --exec",
package.json:125:    "gemhunter:quick": "bun agents/cli.ts run gem-hunter --exec --quick",
package.json:126:    "gemhunter:api": "bun agents/api/gem-hunter-server.ts"
agents/runtime/heartbeat.ts:11: *     agentId: 'gem-hunter',
agents/api/gem-hunter-server.ts:8: *   GET  /v1/papers           — scaffolded papers (docs/gem-hunter/scaffolds/)
agents/api/gem-hunter-server.ts:25:const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
agents/api/gem-hunter-server.ts:68:  const latestPath = join(REPORTS_DIR, "latest-run.json");
agents/api/gem-hunter-server.ts:342:  const latestPath = join(REPORTS_DIR, "latest-run.json");
agents/api/gem-hunter-server.ts:385:  const args = ["agent:run", "gem-hunter", "--exec"];
agents/agents/capability-scanner.ts:53:  { name: 'gem-hunter',   path: '/home/enio/gem-hunter' },
agents/agents/wiki-compiler.ts:5: * Reads raw sources (handoffs, job reports, gem-hunter findings, session memory)
agents/agents/wiki-compiler.ts:58:  { path: join(ROOT, "docs/gem-hunter"), category: "synthesis" as const, prefix: "gem", repo: "egos" },
agents/agents/wiki-compiler.ts:222:    "gem-hunter": /gem.?hunter|discovery|trending/i,
agents/agents/wiki-compiler.ts:253:    "gem-hunter-v60-master-plan": /gem.?hunter\s+(v6|master|plan)/i,
agents/agents/wiki-compiler.ts:692:      source_files: ["docs/jobs/", "docs/gem-hunter/signals.json"],
agents/agents/gem-hunter.ts:19: *   - SQLite historical tracking (bun:sqlite, docs/gem-hunter/history.db)
agents/agents/gem-hunter.ts:35: *   bun agent:run gem-hunter --dry                           # Preview search plan
agents/agents/gem-hunter.ts:36: *   bun agent:run gem-hunter --exec                          # Execute all searches
agents/agents/gem-hunter.ts:37: *   bun agent:run gem-hunter --exec --topic=agents           # Single category
agents/agents/gem-hunter.ts:38: *   bun agent:run gem-hunter --exec --quick                  # Top 3 per keyword
agents/agents/gem-hunter.ts:39: *   bun agent:run gem-hunter --exec --lang=python --min-stars=500  # Filtered
agents/agents/gem-hunter.ts:40: *   bun agent:run gem-hunter --exec --preferences            # Load from file
agents/agents/gem-hunter.ts:41: *   bun agent:run gem-hunter --exec --analyze                # Generate AI synthesis
agents/agents/gem-hunter.ts:42: *   bun agent:run gem-hunter --exec --track=x-signals-public --x-limit=10  # Read daily X signals + draft posts
agents/agents/gem-hunter.ts:43: *   bun agent:run gem-hunter --exec --track=community-signals  # Reddit + StackOverflow + ProductHunt
agents/agents/gem-hunter.ts:44: *   bun agent:run gem-hunter --history                       # Show multi-run trending gems from SQLite
agents/agents/gem-hunter.ts:54:const REPORTS_DIR = join(ROOT, "docs/gem-hunter");
agents/agents/gem-hunter.ts:55:const LATEST_RUN_PATH = join(REPORTS_DIR, "latest-run.json");
agents/agents/gem-hunter.ts:1009:    const res = await fetch(url, { headers: { "User-Agent": "egos-gem-hunter/3.2 (bot)" } });
agents/agents/gem-hunter.ts:1082:    const headers: Record<string, string> = { "User-Agent": "egos-gem-hunter/6.0" };
agents/agents/gem-hunter.ts:1116:      headers: { "User-Agent": "egos-gem-hunter/6.0", Accept: "application/json" },
agents/agents/gem-hunter.ts:1143:      headers: { "User-Agent": "egos-gem-hunter/6.0", Accept: "application/json" },
agents/agents/gem-hunter.ts:1353:        discovered_by: "gem-hunter",
agents/agents/gem-hunter.ts:1698:        channelId: "gem-hunter",
agents/agents/gem-hunter.ts:1699:        userId: "gem-hunter",
agents/agents/gem-hunter.ts:1845:// now bounded to 0-100. `docs/gem-hunter/weights.yaml` is a SEPARATE /study
agents/agents/gem-hunter.ts:2024:        channelId: "gem-hunter",
agents/agents/gem-hunter.ts:2025:        userId: "gem-hunter",
agents/agents/gem-hunter.ts:2125:  md += `> They are saved to \`docs/gem-hunter/next-queries.json\` for the next run.\n\n`;
agents/agents/gem-hunter.ts:2270:        headers: { "User-Agent": "egos-gem-hunter/6.0" },
agents/agents/gem-hunter.ts:2289:    const headers: Record<string, string> = { "User-Agent": "egos-gem-hunter/6.0" };
agents/agents/gem-hunter.ts:2364:      const res = await callAI({ userMessage: prompt, channelId: "gem-hunter", userId: "gem-hunter", userName: "GemHunter", platform: "discord", openrouterApiKey: OPENROUTER_API_KEY });
agents/agents/gem-hunter.ts:2390:      const res = await callAI({ userMessage: prompt, channelId: "gem-hunter", userId: "gem-hunter", userName: "GemHunter", platform: "discord", openrouterApiKey: OPENROUTER_API_KEY });
agents/agents/gem-hunter.ts:2556:    // HQ-EVENTS-002: log gem-hunter run to egos_agent_events
agents/agents/gem-hunter.ts:2560:        source: 'gem-hunter',
agents/skills/observability-agent.ts:22:    { name: "gem-hunter-api", url: "https://gemhunter.egos.ia.br/health" },
agents/skills/observability-agent.ts:75:      { name: "gem-hunter-api", status: "running", cpu: "1.2%", memory: "120MB / 256MB" },
agents/skills/observability-agent.ts:222:  md += `[08:30] gem-hunter-cron.sh — Discovery completed (12 gems found)\n`;
agents/registry/agents.json:388:      "id": "gem-hunter",
agents/registry/agents.json:393:      "entrypoint": "agents/agents/gem-hunter.ts",
agents/registry/agents.json:407:      "runtime_proof": "bun agents/agents/gem-hunter.ts --dry",
agents/registry/agents.json:462:      "id": "gem-hunter-api",
agents/registry/agents.json:465:      "description": "Standalone REST API for gem-hunter (Phase 1 product). Endpoints: GET /v1/findings, /v1/papers, /v1/signals, /v1/kols; POST /v1/hunt. Port 3097.",
agents/registry/agents.json:467:      "entrypoint": "agents/api/gem-hunter-server.ts",
agents/registry/agents.json:480:      "runtime_proof": "bun agents/api/gem-hunter-server.ts",
agents/registry/agents.json:538:      "description": "Compiles raw sources (handoffs, job reports, gem-hunter, strategy docs) into structured wiki pages in Supabase. Karpathy LLM Wiki pattern: ingest \u2192 compile \u2192 lint. Also records learnings for data flywheel.",
agents/registry/validation.json:114:      "id": "gem-hunter",
agents/registry/validation.json:115:      "entrypoint": "agents/agents/gem-hunter.ts",
agents/registry/validation.json:130:      "id": "gem-hunter-api",
agents/registry/validation.json:131:      "entrypoint": "agents/api/gem-hunter-server.ts",
agents/registry/ECOSYSTEM_REGISTRY.md:60:| `aiox_gem_hunter` | knowledge | Scan SynkraAI/aiox-core para orchestration gems | 197 | `bun agents/agents/aiox-gem-hunter.ts --dry-run` | ✅ active |
agents/registry/ECOSYSTEM_REGISTRY.md:62:| `mastra_gem_hunter` | knowledge | Scan mastra-ai/mastra para workflow/eval/MCP patterns | 101 | `bun agents/agents/mastra-gem-hunter.ts --dry-run` | ✅ active |
agents/registry/ECOSYSTEM_REGISTRY.md:98:| `gem-hunter` | knowledge | GitHub/HuggingFace/EXA/X — busca tools, models, papers e sinais diários | 1047 | ✅ active |

exec
/bin/bash -lc "sed -n '40,120p' agents/api/gem-hunter-server.ts" in /home/enio/egos
 succeeded in 0ms:
};

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: { "Content-Type": "application/json", ...CORS },
  });
}

function scoreColor(s: number): string {
  if (s >= 80) return "#22c55e";
  if (s >= 60) return "#f59e0b";
  return "#ef4444";
}

function sourceIcon(src: string): string {
  const m: Record<string, string> = { github: "GH", huggingface: "HF", arxiv: "arXiv", reddit: "↑", producthunt: "PH", npm: "npm", exa: "Exa" };
  return m[src.toLowerCase()] ?? src.slice(0, 3).toUpperCase();
}

function sourceColor(src: string): string {
  const m: Record<string, string> = { github: "#e5e5e5", huggingface: "#f59e0b", arxiv: "#3b82f6", reddit: "#ff6314", producthunt: "#da552f", npm: "#cb3837", exa: "#8b5cf6" };
  return m[src.toLowerCase()] ?? "#737373";
}

// ── Dashboard HTML (GH-061) ────────────────────────────────────────────────────

function dashboardHTML(): Response {
  const latestPath = join(REPORTS_DIR, "latest-run.json");
  const hasData = existsSync(latestPath);
  let inlineGems = "[]";
  let inlineDate = "";

  if (hasData) {
    try {
      const run = JSON.parse(readFileSync(latestPath, "utf-8"));
      const gems = (run.gems ?? []).sort((a: {score?: number}, b: {score?: number}) => (b.score ?? 0) - (a.score ?? 0));
      inlineGems = JSON.stringify(gems);
      inlineDate = run.date ?? "";
    } catch { /* ignore */ }
  }

  const signalsPath = join(REPORTS_DIR, "signals.json");
  let inlineSignals = "[]";
  if (existsSync(signalsPath)) {
    try {
      const s = JSON.parse(readFileSync(signalsPath, "utf-8"));
      inlineSignals = JSON.stringify(s.signals ?? []);
    } catch { /* ignore */ }
  }

  const html = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gem Hunter — EGOS Discovery Engine</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
  body { font-family: 'Inter', system-ui, sans-serif; }
  .mono { font-family: 'JetBrains Mono', 'Fira Code', monospace; }
  .gem-card { transition: all 0.15s ease; }
  .gem-card:hover { border-color: #22c55e44; transform: translateY(-1px); box-shadow: 0 4px 20px rgba(34,197,94,0.05); }
  @keyframes pulse-dot { 0%,100%{opacity:1} 50%{opacity:0.3} }
  .pulse-dot { animation: pulse-dot 2s infinite; }
  .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
</style>
</head>
<body class="bg-[#0a0a0a] text-[#e5e5e5] min-h-screen">

<header class="border-b border-[#1a1a1a] px-6 py-4 flex items-center justify-between sticky top-0 bg-[#0a0a0a]/95 backdrop-blur z-10">
  <div class="flex items-center gap-3">
    <div class="w-8 h-8 rounded-lg bg-[#111] border border-[#22c55e22] flex items-center justify-center text-[#22c55e]">◈</div>
    <div>
      <div class="text-sm font-semibold">Gem Hunter</div>
      <div class="text-[10px] text-[#555] mono">EGOS Discovery Engine v${VERSION}</div>
    </div>
  </div>
  <div class="flex items-center gap-3">
    <div id="hunt-status" class="hidden items-center gap-2 text-xs text-[#f59e0b]">
      <div class="w-2 h-2 rounded-full bg-[#f59e0b] pulse-dot"></div>

exec
/bin/bash -lc 'rg "LATEST_RUN_PATH|reportPath|generatedAt" -n agents/agents/gem-hunter.ts' in /home/enio/egos
 succeeded in 0ms:
55:const LATEST_RUN_PATH = join(REPORTS_DIR, "latest-run.json");
137:  generatedAt: string;
139:  reportPath: string;
1682:  const reportPath = join(REPORTS_DIR, `gems-${timestamp}.md`);
1737:  writeFileSync(reportPath, report);
1738:  console.log(`📝 Report saved: ${reportPath}`);
1791:    generatedAt: new Date().toISOString(),
1793:    reportPath,
2049:  writeFileSync(LATEST_RUN_PATH, JSON.stringify(manifest, null, 2));
2050:  console.log(`🧭 Latest run manifest saved: ${LATEST_RUN_PATH}`);
2244:    generatedAt: new Date().toISOString(),

exec
/bin/bash -lc "sed -n '1760,1815p' agents/agents/gem-hunter.ts" in /home/enio/egos
 succeeded in 0ms:
    const ts = new Date().toISOString();
    appendGemSignal({
      type: "gem_discovery",
      name: gem.name,
      url: gem.url,
      score,
      category: gem.category,
      date: ts,
      ts,
      headline: `${gem.name} — ${gem.description.slice(0, 100)}`,
    });
  }
  if (hotGems.length > 0) {
    console.log(`\n🔥 ${hotGems.length} hot gem(s) scored ≥80 this run`);
    await sendGemTelegramAlert(hotGems);
    await sendGemDiscordAlert(hotGems); // GH-064
  }

  // GH-049: HITL adoption-review queue for elite gems (score ≥85 + validated structure).
  // This NEVER auto-integrates external code (supply-chain risk) — it shortlists
  // candidates into auto-queue.json for a human to review and adopt deliberately.
  const reviewQueueCandidates = hotGems.filter(({ gem, score }) =>
    score >= 85 && (gem.structureBonus ?? 0) >= 5
  );
  if (reviewQueueCandidates.length > 0) {
    await queueForAutoIntegration(reviewQueueCandidates, timestamp);
  }

  saveGemsToHistory(unique, timestamp);
  syncGemsToSupabase(unique, timestamp).catch(() => {});
  saveLatestRun({
    generatedAt: new Date().toISOString(),
    scoreModel: SCORE_MODEL_VERSION,
    reportPath,
    totalGems: unique.length,
    quick: isQuick,
    topicFilter: queryFilter || null,
    tracks: activeTracks,
    byCategory,
    bySource,
  });

  console.log("\n📈 By category:");
  for (const [cat, count] of Object.entries(byCategory)) console.log(`   ${cat}: ${count}`);
}

function daysSince(lastUpdated?: string): number | null {
  if (!lastUpdated) return null;
  const diffMs = Date.now() - new Date(lastUpdated).getTime();
  if (!Number.isFinite(diffMs)) return null;
  return Math.floor(diffMs / (1000 * 60 * 60 * 24));
}

function isWebExtractionRelevant(gem: GemResult): boolean {
  const text = `${gem.name} ${gem.description}`.toLowerCase();
  const strongSignals = /playwright|crawlee|crawl4ai|firecrawl|puppeteer|browser-use|scraper|crawler|extraction|rendered|headless|markdown/;

exec
/bin/bash -lc 'rg "reportPath" -n agents packages apps docs | head -n 50' in /home/enio/egos
 succeeded in 0ms:
agents/skills/trigger-evals.ts:356:  const reportPath = join(EVALS_DIR, 'skills-eval-latest.json');
agents/skills/trigger-evals.ts:357:  writeFileSync(reportPath, JSON.stringify({ timestamp: new Date().toISOString(), overallPassRate, reports }, null, 2));
agents/skills/trigger-evals.ts:358:  console.log(`\n💾 Report: ${reportPath}`);
agents/agents/dead-code-detector.ts:192:    const reportPath = join(reportDir, 'dead-code.md');
agents/agents/dead-code-detector.ts:222:    writeFileSync(reportPath, lines.join('\n'));
agents/agents/dep-auditor.ts:213:    const reportPath = join(reportDir, 'dep-audit.md');
agents/agents/dep-auditor.ts:232:    writeFileSync(reportPath, lines.join('\n'));
agents/agents/doc-drift-sentinel.ts:538:  const reportPath = join(reportDir, `${date}-doc-drift-sentinel.md`);
agents/agents/doc-drift-sentinel.ts:565:    writeFileSync(reportPath, lines);
agents/agents/doc-drift-sentinel.ts:566:    console.log(`\n📄 Report: ${reportPath}`);
agents/agents/gem-hunter.ts:139:  reportPath: string;
agents/agents/gem-hunter.ts:1682:  const reportPath = join(REPORTS_DIR, `gems-${timestamp}.md`);
agents/agents/gem-hunter.ts:1737:  writeFileSync(reportPath, report);
agents/agents/gem-hunter.ts:1738:  console.log(`📝 Report saved: ${reportPath}`);
agents/agents/gem-hunter.ts:1793:    reportPath,
agents/agents/ssot-fixer.ts:123:  const reportPath = join(repoRoot, 'docs', 'agentic', 'reports', 'ssot-audit.json');
agents/agents/ssot-fixer.ts:125:  if (!existsSync(reportPath)) {
agents/agents/ssot-fixer.ts:134:  const report: AuditReport = JSON.parse(readFileSync(reportPath, 'utf-8'));
agents/agents/doc-drift-verifier.ts:719:  const reportPath = join(jobsDir, `${date}-doc-drift-verifier.json`);
agents/agents/doc-drift-verifier.ts:720:  writeFileSync(reportPath, JSON.stringify(reports.length === 1 ? reports[0] : reports, null, 2));
docs/gem-hunter/latest-run.json:4:  "reportPath": "/home/runner/work/egos/egos/docs/gem-hunter/gems-2026-06-01.md",

exec
/bin/bash -lc "rg \"latest-run|reportPath|readFileSync\\(run\\.reportPath|gems-\" -n agents/api/gem-hunter-server.ts" in /home/enio/egos
 succeeded in 0ms:
68:  const latestPath = join(REPORTS_DIR, "latest-run.json");
147:  <div id="tab-gems-content">
163:    <div id="gems-grid" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3"></div>
164:    <div id="gems-empty" class="hidden text-center py-24">
232:  const grid = document.getElementById('gems-grid');
233:  const empty = document.getElementById('gems-empty');
342:  const latestPath = join(REPORTS_DIR, "latest-run.json");

exec
/bin/bash -lc "sed -n '320,390p' agents/api/gem-hunter-server.ts" in /home/enio/egos
 succeeded in 0ms:
  } catch(e) { btn.disabled = false; btn.textContent = '▶ Run Hunt'; }
}

// Init
renderGems(allGems);
renderSignals(allSignals);
</script>
</body>
</html>`;

  return new Response(html, {
    headers: { "Content-Type": "text/html; charset=utf-8", ...CORS },
  });
}

// ── API handlers ───────────────────────────────────────────────────────────────

function handleHealth(): Response {
  return json({ status: "ok", version: VERSION, reportsDir: existsSync(REPORTS_DIR), activeJobs: jobs.size, ts: new Date().toISOString() });
}

function handleFindings(): Response {
  const latestPath = join(REPORTS_DIR, "latest-run.json");
  if (!existsSync(latestPath)) return json({ error: "No runs yet — POST /v1/hunt first" }, 404);
  const latest = JSON.parse(readFileSync(latestPath, "utf-8"));
  const signalsPath = join(REPORTS_DIR, "signals.json");
  const signals = existsSync(signalsPath) ? JSON.parse(readFileSync(signalsPath, "utf-8")).signals?.slice(0, 10) ?? [] : [];
  return json({ latest, topSignals: signals });
}

function handlePapers(): Response {
  const scaffoldsDir = join(REPORTS_DIR, "scaffolds");
  if (!existsSync(scaffoldsDir)) return json({ papers: [] });
  const files = readdirSync(scaffoldsDir)
    .filter(f => f.endsWith(".md"))
    .map(f => {
      const content = readFileSync(join(scaffoldsDir, f), "utf-8");
      const title = content.match(/^# (.+)/m)?.[1] ?? f;
      const score = content.match(/Score:\s*(\d+)\/100/)?.[1];
      return { file: f, title, score: score ? Number(score) : null };
    })
    .sort((a, b) => (b.score ?? 0) - (a.score ?? 0));
  return json({ count: files.length, papers: files });
}

function handleSignals(): Response {
  const signalsPath = join(REPORTS_DIR, "signals.json");
  if (!existsSync(signalsPath)) return json({ version: "1.0.0", signals: [] });
  return json(JSON.parse(readFileSync(signalsPath, "utf-8")));
}

function handleKOLs(): Response {
  const kolPath = join(REPORTS_DIR, "kol-list.json");
  if (!existsSync(kolPath)) return json({ error: "KOL list not generated yet" }, 404);
  return json(JSON.parse(readFileSync(kolPath, "utf-8")));
}

async function handleHunt(req: Request): Promise<Response> {
  const body = await req.json().catch(() => ({})) as Record<string, unknown>;
  const track = typeof body.track === "string" ? body.track : "";
  const quick = body.quick !== false;

  const jobId = `hunt-${Date.now()}`;
  jobs.set(jobId, { status: "running", startedAt: new Date().toISOString() });

  const args = ["agent:run", "gem-hunter", "--exec"];
  if (quick) args.push("--quick");
  if (track) args.push(`--track=${track}`);

  const child = spawn("bun", args, { cwd: ROOT, detached: true, stdio: "ignore" });
  jobs.get(jobId)!.pid = child.pid;

codex
The diff only updates task/docs and generated gem-hunter artifacts; no functional code paths were modified. I did not find a discrete, actionable defect that would break runtime behavior or existing tests.
The diff only updates task/docs and generated gem-hunter artifacts; no functional code paths were modified. I did not find a discrete, actionable defect that would break runtime behavior or existing tests.
```
