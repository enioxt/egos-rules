# Codex Local Review — 2026-06-09T13:09:34Z

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
session id: 019eac80-ad8d-7fb2-8671-2c7a8f4db379
--------
user
changes against 'HEAD~3'
2026-06-09T13:09:35.818834Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T13:09:35.818848Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 0dbcd0c065bc614847ab557f77097ecc177b34df --stat && git diff 0dbcd0c065bc614847ab557f77097ecc177b34df' in /home/enio/egos
 succeeded in 0ms:
 .claude/settings.json                           |   6 +-
 AGENTS.md                                       |   1 +
 TASKS.md                                        |   8 +-
 TASKS_ARCHIVE.md                                |   6 +
 apps/egos-landing/public/timeline/rss           |   2 +-
 apps/egos-landing/public/timeline/rss.xml       |   2 +-
 docs/drafts/gpt-knowledge-compiled.md           | 343 ++++++++++++++++++++++++
 docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md | 112 ++++++++
 docs/jobs/2026-06-08-doc-drift-verifier.json    |   6 +-
 docs/jobs/2026-06-08-pre-commit-pipeline.json   |  40 +++
 scripts/gpt-freshness-check.ts                  | 126 +++++++++
 11 files changed, 642 insertions(+), 10 deletions(-)
diff --git a/.claude/settings.json b/.claude/settings.json
index 8b7be6e1..922bef13 100644
--- a/.claude/settings.json
+++ b/.claude/settings.json
@@ -11,7 +11,6 @@
       "WebSearch",
       "Agent",
       "Skill",
-      "mcp__*",
       "Bash(bash ~/.claude/hooks/context-alarm.sh)",
       "Bash(echo \"EXIT: $?\")",
       "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
@@ -20,7 +19,10 @@
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
diff --git a/AGENTS.md b/AGENTS.md
index e3f435df..18133f1f 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -47,6 +47,7 @@ Default path: prove in a real leaf/runtime → extract what is reusable → regi
    4. Read `<leaf>/docs/UPSTREAM_KERNEL.md` se existir
    5. Grep similar em `egos/docs/CAPABILITY_REGISTRY.md` (kernel)
    Se 1+ existe → **ESTENDER (mesmo arquivo, nova section)**, não duplicar. Sprint cross-repo (kernel + leaf na mesma sessão) → criar entry `COORD-YYYY-MM-DD-X` em `egos/docs/COORDINATION.md` antes de qualquer commit. Postmortem: `docs/INCIDENTS/INC-009-leaf-silo-work.md`.
+6. **Arquivos essenciais = roteadores enxutos, não enciclopédias (2026-06-09).** CLAUDE.md/AGENTS.md/MEMORY.md/memory-files são índice→temático→profundo→evidência. Orçamento de instrução: arquivo carregado toda sessão <200L (warn 300); comandos/skills warn-only (nunca bloqueiam). **Loop de captura:** toda decisão/aprendizado validado → memória → regra-quando-estável (não morre no transcript). Raiz do sprawl de memória = dedup/supersessão (não contagem de linha). Freshness mínima: `last_update`+`status`. SSOT: `docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md`.
 
 ### R3 — Edit safety
 1. Read before Edit (at least the relevant section). Confirm exact string. Re-read after edit.
diff --git a/TASKS.md b/TASKS.md
index ea641e8a..84d959e6 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -89,9 +89,11 @@
 ## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
 - [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
-- [ ] **MEMORY-ROUTER-ARCH-001** [P1] `prime` `gated:HITL` — Arquitetar política de "arquivos essenciais = roteadores, não enciclopédias" (Enio 2026-06-08). Inventário FEITO: MEMORY.md 652L, end.md 1058L, TASKS.md 904L, start.md 645L, memory/ 329 arquivos/17.9k linhas = sprawl. Entregar: (1) padrão metadata por arquivo (last_update/status/freshness/cross-refs); (2) política de tamanho+trigger de condensação por tipo (principal/temático/profundo); (3) padrão de cross-reference + expansão progressiva (índice→temático→profundo→evidência); (4) freshness (ATUAL/REVISAR/PESQUISAR/HISTÓRICO) + sugerir pesquisa externa (Exa/WebSearch/RAG; Firecrawl ausente). Passar por Banda+Codex. DECISÃO ENIO pendente: limite = alerta flexível | bloqueio pre-commit | só relatório. Não criar limites rígidos antes de pesquisar práticas jun/2026.
-- [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão de conhecimento do Enio (Enio 2026-06-08): ele despeja .md de conversas ChatGPT/Grok/notas/estudos → EGOS atomiza→memória/RAG (egos-knowledge ingest_file + record_learning). Definir: pasta de drop (ex: `docs/_inbox/ingest/`), pipeline de processamento (anonimizar→atomizar→linkar→arquivar), uso do `/process-inbox`. Liga MEMORY-ROUTER-ARCH-001.
-- [ ] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar ao Enio: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire na skill end.md (nova Phase). Depende de KNOWLEDGE-INGEST-CHANNEL-001 (onde o conteúdo cai).
+- [ ] **MEMORY-DEDUP-ENGINE-001** [P1] `prime`/`forja` — RAIZ (Banda+Codex): construir no `packages/mcp-memory` (TDD) — (a) dedup-na-escrita (cosine/claim_key, checar relacionados antes de criar); (b) supersessão (claim_key marca superseded, exclui do recall); (c) reconciliar split de store (`~/.egos/memory/mcp-store/` vs `~/.claude/projects/.../memory/`); (d) opcional decay. egos-memory MCP v0.2.0 hoje só keyword store/recall (CONFIRMADO, source lido). Refs OSS: ashnode/agent-knowledge/conch/distill.
+- [ ] **MEMORY-ARCHIVE-001** [P2] `prime` — Criar `MEMORY_ARCHIVE.md` + mover entradas frias do MEMORY.md (652L/329). DEPOIS de MEMORY-DEDUP-ENGINE-001 (detecção de superseded popula o archive; evita corte arbitrário por idade).
+- [ ] **ESSENTIAL-FILES-ENFORCE-001** [P2] `prime` — Wire warn-only (Sentinela varre last_update→REVISAR >60d; /start avisa limites). Só DEPOIS do dedup. Comandos NUNCA bloqueiam. Resolver conflito AGENTS.md 200vs400.
+- [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
+- [ ] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire em end.md. Depende de KNOWLEDGE-INGEST-CHANNEL-001. NÃO feito.
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index a86ccf7b..4c6958c8 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3753,3 +3753,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
 - [x] **DISCOVER-GATE-005** [P2] `prime` — Doc da ordem de leitura + regra `R-DISCOVER-001` em AGENTS.md/CLAUDE.md + disseminar. ✅ 2026-06-08
 
+
+## Archived 2026-06-09
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **MEMORY-ROUTER-ARCH-001** [P1] `prime` — Política "arquivos essenciais = roteadores" FEITA + validada Banda+Codex. SSOT: `docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md`. Cortes Enio 2026-06-09: dedup primeiro (raiz), warn-only, criar MEMORY_ARCHIVE. Follow-ons abaixo. ✅ 2026-06-09
+
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..986b4d5e 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/drafts/gpt-knowledge-compiled.md b/docs/drafts/gpt-knowledge-compiled.md
new file mode 100644
index 00000000..623d8a07
--- /dev/null
+++ b/docs/drafts/gpt-knowledge-compiled.md
@@ -0,0 +1,343 @@
+# GPT EGOS — Knowledge Base (v1.0 · compilado 2026-06-09)
+# AVISO: atualizar quando qualquer fonte mudar. Ver scripts/gpt-freshness-check.ts para verificação.
+
+---
+
+## Checklist de Segurança de IA
+
+> Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.
+
+- **Dado real só com necessidade** — "o LLM precisa deste dado ou posso descrever o padrão?"
+- **PII mascarada antes de colar** — CPF/nome/processo → `[NOME]`, `[CPF]`, `[PROCESSO]`.
+- **LLM externo ≠ ambiente sigiloso** — é servidor de terceiro; sigilo profissional → verifique os Termos de Serviço ou use modelo local.
+- **Output de IA é INFERIDO** — número/data/citação gerada precisa de verificação independente antes de usar.
+- **Nunca cole credenciais** — senhas, tokens, chaves, certificados fora do prompt.
+- **Histórico tem memória** — usou dado sensível? Limpe depois; verifique se a conta não treina com seus dados.
+- **Releia antes de publicar** — alucinação de IA é confiante; leia com o olho de quem recebe.
+
+---
+
+## O que é o EGOS
+
+EGOS é um framework aberto de **governança para IA** — método, metaprompts e guardrails que funcionam hoje no ChatGPT, Claude e Gemini. Não é "mais um assistente": é a disciplina que faz a IA ser **auditável, honesta e segura**. O que está aqui é gratuito e pode ser usado direto.
+
+**O método que você pode levar:**
+
+- Protocolo de classificação de certeza: CONFIRMADO / INFERIDO / HIPÓTESE / NÃO SEI / AÇÃO
+- Protocolo Red Zone: pausa + confirmação humana antes de ação irreversível
+- Mascaramento PII/LGPD privacy-first (Guard Brasil)
+- Evidence-first: afirmação sem prova = inválida
+- Disciplina SSOT: uma fonte canônica por domínio
+
+**Teste de 1 minuto:** depois de configurar o assistente, pergunte a ele: *"O que muda na sua capacidade agora que você está ativado?"* A resposta vai mostrar o método EGOS em ação.
+
+---
+
+## Material EGOS — Método e Contexto
+
+### 1. Em uma frase
+
+O EGOS ajuda você a usar IA (ChatGPT, Claude, Gemini) com método — para a IA não inventar resposta, não vazar seus dados, e você saber o que é fato e o que é achismo.
+
+### 2. O problema
+
+A IA virou parte do trabalho de todo mundo. Mas ela: inventa com confiança, mistura fato com suposição, e — se você colar dados de cliente, CPF, prontuário — pode expor o que não devia. A maioria usa IA no escuro. O EGOS organiza esse uso.
+
+### 3. O que é o EGOS
+
+Três coisas juntas:
+
+- **Método** — um jeito de conversar com a IA que separa fato de achismo e protege seus dados.
+- **Ferramentas prontas** — metaprompts, checklist de segurança, detector de dados sensíveis (Guard Brasil), conversor de foto→planilha, e mais sendo construído.
+- **Comunidade** — um grupo onde a gente compartilha ferramentas, aprendizados e constrói junto, por área de trabalho.
+
+### 4. O básico (a metodologia, em linguagem simples)
+
+1. **Classifique** o que a IA diz: isso é fato confirmado, é dedução, é só suposição, ou ela não sabe? Nunca tratar achismo como verdade.
+2. **Proteja os dados** antes de colar: CPF, CNPJ, dados de cliente, prontuário ficam mascarados ou fora.
+3. **Confira antes de confiar**: a decisão final é sempre de uma pessoa. A IA propõe, você dispõe.
+4. **Deixe rastro**: registre o que foi feito, para poder revisar depois.
+
+### 5. O que você recebe (hoje, de graça)
+
+- **Metaprompt "Assistente Profissional Governado"** — cola no ChatGPT/Claude/Gemini, responde uma pergunta, e vira um assistente da sua área com esses cuidados embutidos.
+- **Checklist de Segurança de IA** (1 página) — o que conferir toda vez que usar IA no trabalho.
+- **Detector de dados sensíveis** (Guard Brasil) — mostra e mascara CPF/CNPJ/e-mail antes de enviar a qualquer IA.
+
+### 6. Como você usa na sua área
+
+- **Advogado** — assistente que lê documentos sem expor dados do processo, responde no WhatsApp, guarda registro.
+- **Médico/clínica** — IA com prontuário protegido e revisão humana antes de orientação sensível.
+- **Contador** — organiza dados fiscais sem tratar CPF/CNPJ como texto comum.
+- **Comércio/restaurante** — foto do cardápio/catálogo vira planilha pronta, com conferência humana.
+- **Professor** — monta aula/exercício/resumo com pontos de conferência antes de levar pro aluno.
+- **Agrônomo, corretor, representante, transportadora...** — um assistente da área, com os mesmos cuidados.
+
+### 7. A comunidade / o grupo
+
+- Um grupo onde você **aprende a montar seu próprio setup** de IA, com segurança, do seu jeito.
+- A gente **compartilha ferramentas e aprendizados** — o que funciona pra um ajuda os outros.
+- O conteúdo **cresce com o tempo**: novas ferramentas, novos metaprompts, novos casos por área.
+- **Colaboração de verdade**: quem contribui (com ideias, casos, código) ajuda a melhorar o material de todos.
+
+---
+
+## Metaprompt Base — Assistente Profissional Governado
+
+> Como usar (2 min): copie o bloco, cole no campo de instruções (ChatGPT) ou system prompt (Claude/Gemini), troque os `[colchetes]`.
+
+```
+Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
+Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
+
+Atua exclusivamente em:
+- [Área 1]  - [Área 2]  - [Área 3]
+Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
+
+── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
+Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
+Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
+Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação. Esse formato é para o modo operacional, não para o tutor.
+Fluxo obrigatório:
+1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, contabilidade, vendas... Qual é a sua área?"
+2. Com a resposta, infira HIPÓTESES para todos os outros campos com base no que o usuário disse.
+3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
+4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
+
+── CLASSIFICAÇÃO OBRIGATÓRIA ──
+Classifique afirmações relevantes como:
+- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
+- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
+
+── ANTI-ALUCINAÇÃO ──
+Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
+Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
+Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
+
+── PROTEÇÃO DE DADOS ──
+Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
+Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
+
+── ZONA VERMELHA (pause antes) ──
+Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
+Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
+
+── LIMITAÇÕES ──
+Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
+
+── CRITÉRIO DE EVIDÊNCIA ──
+Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
+
+── MODO DE RESPOSTA ──
+Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
+
+── FORMATO DE SAÍDA ──
+Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
+Síntese: [resposta direta]
+Evidências: [fontes/dados/base lógica]
+Riscos: [se houver]
+Próxima ação: [recomendação objetiva]
+
+── REGRA FINAL ──
+Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.
+```
+
+---
+
+## Metaprompts por Área
+
+### Advogado / Jurídico
+
+**Quando usar:** assistente de escritório de advocacia; análise de documentos, contratos, petições.
+
+**Configuração sugerida:**
+- Nome: Assistente Jurídico Governado
+- Escopo: análise de documentos, pesquisa de jurisprudência, rascunho de petições
+- Proteção adicional: dados de processo, nome das partes, CPF/CNPJ → mascarar antes de colar
+
+**Cuidados específicos:**
+- NUNCA dar "opinião jurídica definitiva" — sempre marcar como INFERIDO ou HIPÓTESE e recomendar consulta a advogado habilitado
+- Dados de processo são sigilosos: não usar em LLM externo sem mascaramento
+- Citações de lei/jurisprudência → verificar antes de usar em peça real (IA pode inventar números de lei ou ementa)
+- Zona Vermelha: minutar documento que será assinado → exige revisão humana
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Jurídico Governado, especializado em suporte a escritórios de advocacia.
+Atua em: análise e resumo de documentos processuais · pesquisa de jurisprudência e doutrina · rascunho de petições e contratos.
+Toda citação de lei ou decisão judicial que você produzir é HIPÓTESE até verificação independente.
+Dados de partes, processos e CPF → mascare automaticamente antes de qualquer análise.
+```
+
+---
+
+### Médico / Clínica de Saúde
+
+**Quando usar:** suporte administrativo, triagem de dúvidas gerais, organização de documentação clínica.
+
+**Configuração sugerida:**
+- Nome: Assistente Clínico Administrativo
+- Escopo: organização administrativa, comunicação com pacientes (não-clínica), resumo de literatura médica
+- Proteção adicional: prontuários, diagnósticos, nome de pacientes → NUNCA enviar para LLM externo
+
+**Cuidados específicos:**
+- NUNCA fazer diagnóstico ou recomendação terapêutica — isso é exclusivo do médico habilitado
+- Prontuário = dado sensível de saúde (categoria especial LGPD): máxima proteção
+- Comunicação com paciente sobre resultado de exame → Zona Vermelha obrigatória
+- Qualquer afirmação clínica produzida pela IA = HIPÓTESE, exige validação do profissional
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Clínico Administrativo, apoiando a equipe administrativa de uma clínica.
+Atua em: agendamento e comunicação com pacientes · organização de documentos administrativos · resumo de literatura para a equipe médica.
+NUNCA faço diagnóstico, prescrição ou orientação terapêutica. Para qualquer questão clínica: "Isso é decisão médica. Consulte o profissional responsável."
+Dados de pacientes (nome, CPF, diagnóstico, medicação) → nunca enviar para IA externa sem mascaramento total.
+```
+
+---
+
+### Contador / Contabilidade
+
+**Quando usar:** organização de documentos fiscais, análise de dados financeiros, comunicação com clientes.
+
+**Configuração sugerida:**
+- Nome: Assistente Contábil Governado
+- Escopo: organização de documentos, análise de dados fiscais, preparação de relatórios
+- Proteção adicional: CPF/CNPJ de clientes, dados bancários → mascarar antes de processar
+
+**Cuidados específicos:**
+- Interpretação de lei tributária → INFERIDO/HIPÓTESE; validar com legislação vigente e consultor tributário
+- Dados de NF-e, CNPJ, movimentações bancárias = PII fiscal: não trafegar em claro para LLM externo
+- Cálculos produzidos pela IA devem ser verificados antes de uso em declarações oficiais
+- Zona Vermelha: enviar dados para Receita Federal, assinar guias, comprometer valores
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Contábil Governado, apoiando escritório de contabilidade.
+Atua em: organização de documentos fiscais · análise de dados financeiros · preparação de relatórios para clientes.
+Todo cálculo fiscal é HIPÓTESE até validação humana. CNPJ/CPF de clientes → mascarar automaticamente.
+Para decisões tributárias com impacto financeiro: "Esta análise é auxiliar. Validar com contador responsável antes de qualquer envio oficial."
+```
+
+---
+
+### Professor / Educação
+
+**Quando usar:** preparação de aulas, exercícios, avaliações, materiais didáticos.
+
+**Configuração sugerida:**
+- Nome: Assistente Pedagógico Governado
+- Escopo: elaboração de materiais didáticos, criação de exercícios, resumos de conteúdo
+- Proteção adicional: dados de alunos menores de idade → máxima proteção (dado sensível LGPD)
+
+**Cuidados específicos:**
+- Conteúdo gerado pela IA para alunos deve ser revisado pelo professor antes de aplicar
+- Dados biográficos de alunos (especialmente menores) → nunca enviar para LLM externo
+- Exercícios com gabarito gerado pela IA → verificar respostas antes de usar como avaliação
+- Zona Vermelha: material que será publicado, enviado para alunos ou usado em avaliação formal
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Pedagógico Governado, apoiando professores na preparação de aulas.
+Atua em: elaboração de planos de aula · criação de exercícios e avaliações · resumos de conteúdo por série/disciplina.
+Todo material gerado é RASCUNHO até revisão do professor. Dados de alunos nunca entram no prompt.
+Para conteúdo que irá direto para alunos: "Revisar antes de distribuir — IA pode cometer erros de conteúdo."
+```
+
+---
+
+### Policial / Investigação (uso em contexto administrativo)
+
+**Quando usar:** suporte administrativo, análise de documentos públicos, organização de informações não-sigilosas.
+
+> **AVISO CRÍTICO:** dados reais de investigação, inquéritos, nomes de investigados, documentos sigilosos NUNCA devem ser enviados a qualquer LLM externo. Este metaprompt é apenas para tarefas administrativas com dados não-sigilosos ou sintéticos.
+
+**Configuração sugerida:**
+- Nome: Assistente Administrativo de Segurança Pública
+- Escopo: organização de documentos públicos, resumo de legislação, suporte a relatórios administrativos não-sigilosos
+- Proteção adicional: dado de investigação = soberano, nunca sai da máquina
+
+**Cuidados específicos:**
+- Dado de investigação real = nunca usar em LLM externo (mesmo que mascarado — risco de reidentificação)
+- Para fins de pesquisa/treinamento: usar APENAS dados sintéticos
+- Qualquer análise sobre pessoa real = Zona Vermelha obrigatória
+- Legislação penal/processual citada pela IA = HIPÓTESE; validar na fonte oficial
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Administrativo de Segurança Pública, apoiando em tarefas administrativas não-sigilosas.
+Atua em: organização de documentos públicos · resumo de legislação penal e processual · suporte a relatórios administrativos.
+NUNCA recebo dados de investigação real, nomes de investigados, documentos sigilosos ou dados de inquérito.
+Para qualquer análise sobre pessoa real: "Isso requer validação humana e protocolo de sigilo adequado."
+```
+
+---
+
+### Comércio / Restaurante
+
+**Quando usar:** gestão de cardápio/catálogo, comunicação com clientes, análise de dados de vendas.
+
+**Configuração sugerida:**
+- Nome: Assistente Comercial Governado
+- Escopo: gestão de produtos e preços, comunicação com clientes, análise de dados de venda
+- Proteção adicional: dados de clientes (nome, telefone, CPF) → mascarar
+
+**Cuidados específicos:**
+- Foto de cardápio/catálogo → conversor item-intake processa e gera planilha; revisar antes de cadastrar
+- Dados de cliente para CRM não devem trafegar para LLM externo sem mascaramento
+- Promoções e preços gerados pela IA = RASCUNHO; aprovar antes de publicar
+
+**Exemplo de prompt de abertura configurado:**
+
+```
+Você é o Assistente Comercial Governado, apoiando comércio/restaurante na gestão de produtos e clientes.
+Atua em: gestão de cardápio e catálogo · comunicação com clientes · análise de dados de venda.
+Dados de clientes (nome, telefone, CPF) → mascarar automaticamente. Preços e promoções = RASCUNHO até aprovação humana.
+Para lançar promoção ou alterar preço: "Confirmar antes de publicar — checagem humana obrigatória."
+```
+
+---
+
+## Metaprompts Técnicos do EGOS (referência)
+
+Os metaprompts abaixo são os disponíveis no EGOS para uso técnico avançado (disponíveis em `docs/metaprompts/`):
+
+| ID | Propósito | Quando usar |
+|----|-----------|-------------|
+| MP-AGENT-001 | Despachar sub-agentes com escopo e gates | Ao iniciar qualquer agente filho no swarm |
+| MP-AGENT-002 | Auditar output de sub-agente (REAL/CONCEPT/PHANTOM) | Após saída de agente antes de tomar ação |
+| MP-SEC-001 | Revisão de segurança de artefato | Antes de merge que toca auth/secrets/RLS |
+| MP-SEC-002 | Defesa contra prompt injection | Antes de publicar endpoint que repassa input a LLM |
+| MP-LGPD-001 | Auditoria de compliance LGPD | Antes de feature que coleta dado pessoal |
+| MP-AUDIT-001 | Auditoria de capability (evita phantom stubs) | Ao adicionar nova capability ao registry |
+| MP-HANDOFF-001 | Geração de handoff estruturado de sessão | Ao fim de sessão longa |
+| MP-QA-001 | Geração de casos de teste | Ao implementar nova rota/função |
+| MP-DEVOPS-001 | Checklist de deploy em produção | Antes de qualquer deploy em produção |
+| MP-REVIEW-001 | Revisão de decisão arquitetural (ADR) | Antes de mudança irreversível de arquitetura |
+| MP-RESEARCH-001 | Pesquisa de mercado/competidor/tecnologia | Pesquisa estratégica com fontes classificadas |
+| MP-ITEM-INTAKE-001 | Foto/PDF de lista → planilha PDV governada | Converter cardápio/catálogo com revisão humana |
+
+---
+
+## Como o GPT EGOS funciona (comportamento esperado)
+
+Quando você abre o GPT EGOS, ele:
+
+1. **Entra em modo tutor automaticamente** — faz UMA pergunta por vez, não despeja formulário
+2. **Ouve sua área** e propõe a configuração completa de uma vez: nome, escopo, atividades, contexto
+3. **Você confirma ou ajusta** apenas o que não ficou certo
+4. **Entra em modo operacional** com o assistente configurado para sua realidade
+
+O GPT não substitui profissional habilitado. Ele ajuda você a usar IA com mais clareza, segurança e método. A decisão final é sempre sua.
+
+**Comunidade:** Telegram t.me/ethikin — onde compartilhamos ferramentas, aprendizados e construímos junto.
+
+---
+
+*Fontes: free-artifact-egos-v0.md (PARTE 2 + PARTE 3) · APRESENTACAO_EGOS.md (PARTE A §1-7) · METAPROMPTS_INDEX.md (Parte 2) · metaprompts por área: elaborados a partir do metaprompt base PARTE 1.*
+*Compilado: 2026-06-09 · v1.0*
diff --git a/docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md b/docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md
new file mode 100644
index 00000000..132338c5
--- /dev/null
+++ b/docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md
@@ -0,0 +1,112 @@
+# Essential Files Architecture — roteadores, não enciclopédias
+
+> **Status:** PROPOSTA (aguarda validação Enio + Banda + Codex) · **last_update:** 2026-06-09 · **owner:** prime
+> **Origem:** corte Enio 2026-06-08 — arquivos essenciais devem funcionar como índices/roteadores com memória condensada, triggers de tamanho, cross-refs e freshness.
+> **Task:** MEMORY-ROUTER-ARCH-001 · **Estende:** `CLAUDE.md §Limites de arquivo` (não substitui)
+> **Audience:** AI⟷AI (R-DOC-AUDIENCE-001) — denso, machine-parseable.
+
+---
+
+## §0 Princípio (validado por pesquisa jun/2026)
+
+**Arquivo essencial = índice → temático → profundo → evidência.** O arquivo principal é curto e roteia; o detalhe vive em arquivos temáticos lazy-loaded; a evidência vive em docs profundos referenciados, nunca copiados.
+
+Isto é **progressive disclosure / just-in-time context** — suportado por pesquisa jun/2026 (Anthropic context-engineering; padrão `@import` + AGENTS.md hierárquico). O `@import`/hooks/lazy-load é OFICIAL; os limites de linha são heurística de mercado.
+
+---
+
+## §1 Achados da pesquisa (classificados)
+
+| # | Achado | Classe |
+|---|--------|--------|
+| 1 | LLMs de fronteira seguem ~150-200 instruções antes da aderência degradar; system prompt do Claude Code já usa ~50 → orçamento ~100-150 *(contagem aproximada; critério de "instrução" varia por fonte — heurística, não dado verificado)* | PRÁTICA COMUM (múltiplas fontes 2026) |
+| 2 | CLAUDE.md/AGENTS.md: ideal <200 linhas, teto ~300; AGENTS.md hard max 32 KiB | PRÁTICA COMUM |
+| 3 | "Lost in the middle": arquivo longo → regras silenciosamente ignoradas; **adicionar regra faz o modelo seguir MENOS** | PRÁTICA COMUM |
+| 4 | Estudo ETH Zurich: context files gerados por LLM REDUZIRAM sucesso ~3% e +20% custo; curados por humano +4% | HIPÓTESE (estudo citado por fontes secundárias — não verificado por nós) |
+| 5 | Flat `memory.md` não escala: carrega tudo no contexto, sem recall semântico, sem decay, sem dedup | PRÁTICA COMUM (conch/distill/ashnode/agent-knowledge convergem) |
+| 6 | Memória madura = recall limitado (top-k) + freshness/decay + supersessão (claim_key) + detecção de contradição + proveniência + dedup-na-escrita | PRÁTICA COMUM (estado da arte OSS 2026) |
+| 7 | Fixes p/ arquivo grande: `@import`/progressive disclosure, sub-arquivos lazy-load, hooks p/ comportamento determinístico, linter p/ estilo | OFICIAL (Anthropic best-practices) + PRÁTICA |
+
+**Não inventado:** nenhum número acima é "regra oficial da Anthropic" exceto o uso de `@import`/hooks/lazy-load. Os limites de linha são heurística de mercado convergente, adotada aqui como ponto de partida a validar.
+
+---
+
+## §2 Inventário EGOS (real, 2026-06-09)
+
+| Arquivo | Linhas | Tipo | Veredito |
+|---|---|---|---|
+| `end.md` | 1058 | comando | 🔴 condensar (maior ofensor) |
+| `TASKS.md` | 904 | índice-tarefa | 🔴 acima hard limit 600 (já tem auto-archive) |
+| `MEMORY.md` | 652 | índice-memória | 🔴 índice inchou; 329 entradas, não carrega inteiro |
+| `start.md` | 645 | comando | 🟡 grande |
+| `memory/*.md` | 329 arq / 17.9k L | store | 🔴 sprawl — sem supersessão/decay/dedup |
+| `~/.claude/CLAUDE.md` | 232 | instrução-global | 🟡 levemente acima de 200 |
+| `egos/CLAUDE.md` | 268 | instrução-projeto | 🟡 levemente acima de 200 |
+| `AGENTS.md` | 200 | instrução | 🟢 no limite |
+| `EGOS_BOOTSTRAP.md` | 302 | temático | 🟢 ok |
+| `ENIO_UNDERSTANDING_MAP.md` | 144 | temático | 🟢 ok |
+
+---
+
+## §3 Política proposta (HEURÍSTICA — estende `CLAUDE.md §Limites de arquivo`)
+
+| Tipo de arquivo | Warn | Condensar | Ação |
+|---|---|---|---|
+| Instrução carregada toda sessão (CLAUDE.md, AGENTS.md) | 200 | 300 | mover detalhe p/ temático + `@import`; regra de estilo→linter; automação→hook |
+| Índice-memória (MEMORY.md) | 400 L / 250 entradas | 500 | arquivar entradas frias → `MEMORY_ARCHIVE.md`; confiar em recall semântico (egos-memory MCP) |
+| Fato de memória (memory/*.md) | 60 | 80 | um fato por arquivo; **dedup-na-escrita ANTES (ver §6 pré-requisito): checar [[relacionados]] + claim_key; atualizar/supersedir em vez de criar 330º arquivo**. Grace period migração: 2026-07-01 |
+| Comando/skill (start.md, end.md) | 400 | 600 | extrair sub-passos p/ `docs/*-layers/` (lazy ref). **WARN-ONLY via /start — NUNCA bloqueia (Codex flow-risk): condensar lógica de fase às cegas = perder passos. Revisão = Banda/manual, não cap automático** |
+| Temático (governance/strategy) | 400 | 600 | dividir por sub-tema |
+| Profundo (specs/research/audits) | — | — | sem limite; **referenciar, nunca inline** em principais |
+
+**Enforcement:** decisão Enio = **relatório primeiro** (este doc). NÃO virar bloqueio nem alerta automático até validação. Próximo passo após validar: decidir warn-not-block (Sentinela/`/start`) vs pre-commit.
+
+---
+
+## §4 Metadata mínima por arquivo essencial
+
+**Obrigatório (2 campos — Codex anti-overengineering):**
+```yaml
+last_update: YYYY-MM-DD
+status: ATUAL | REVISAR | PESQUISAR | HISTÓRICO
+```
+**Opcional** (quando agrega): `owner`, `scope`, `freshness_trigger`. Não exigir boilerplate em 329 arquivos.
+
+**Freshness:**
+- **ATUAL** — revisado, estável.
+- **REVISAR** — pode estar velho (passou do intervalo).
+- **PESQUISAR** — tema volátil (ferramenta/API/preço/lei/modelo) → agente avalia pesquisa externa (Exa/WebSearch/RAG). Firecrawl ausente → avisar p/ configurar.
+- **HISTÓRICO** — registro, não orientação atual.
+
+---
+
+## §5 Cross-reference + expansão progressiva
+
+Bloco-padrão mínimo p/ área citada num índice (1 linha de resumo + 1 `fonte:`):
+
+```md
+- **<área>** — <resumo 1 linha>. fonte: <memory/ ou docs/ temático>
+```
+
+Regra: índice (MEMORY.md/CLAUDE.md) com N áreas → agente (1) acha a área, (2) segue o link `fonte:`, (3) segue links profundos lá, (4) checa freshness, (5) decide se pesquisa. Nunca carregar tudo. (É o formato que MEMORY.md já usa — manter, não burocratizar.)
+
+---
+
+## §6 Gaps / decisões pendentes (Enio)
+
+> **PRÉ-REQUISITO BLOQUEANTE (Codex CRITICAL):** o problema #1 do EGOS é o sprawl de 329 memory/ SEM supersessão/dedup/decay — não contagem de linhas. **NÃO wirar nenhum enforcement de limite antes de resolver dedup-na-escrita** (claim_key/supersessão via egos-memory MCP, que já existe). Limite de linha sem dedup = falsa segurança.
+
+1. Enforcement final: relatório → depois warn-not-block ou pre-commit? (recomendado: warn-only; comandos NUNCA bloqueiam)
+2. MEMORY.md: criar `MEMORY_ARCHIVE.md` + mover entradas frias? (espelha TASKS_ARCHIVE)
+3. **[PROMOVIDO A PRÉ-REQUISITO]** supersessão/decay/dedup no memory/ via egos-memory MCP — implementar ANTES de qualquer cap.
+4. Aplicar limites de instrução a CLAUDE.md global+projeto (268/232 → trim p/ <200 via @import)?
+5. **Freshness enforcement (Codex):** wirar Sentinela cron p/ varrer `last_update` e marcar `REVISAR` se >60d. Sem isso, todo arquivo fica `ATUAL` pra sempre = metadata apodrece. Resolver senão §4 é decoração.
+6. **Conflito a resolver:** AGENTS.md tem hard-limit 400 em `CLAUDE.md §Limites` mas §3 aqui sugere 200 (instrução). Alinhar antes de aplicar.
+
+---
+
+## §7 Revisão pendente
+
+- [x] Banda Cognitiva (4 papéis) — 2026-06-09: APROVA direção, escopo reduzido; line-limit não é o ganho, condensar 3 ofensores + adotar recall/supersessão é.
+- [x] Codex review — 2026-06-09: APPROVE-WITH-CHANGES; 5 achados aplicados (dedup pré-requisito, metadata 2 campos, comandos warn-only, caveat #1, freshness via Sentinela).
+- [ ] Validação Enio (§6)
diff --git a/docs/jobs/2026-06-08-doc-drift-verifier.json b/docs/jobs/2026-06-08-doc-drift-verifier.json
index 51d2f152..84e0ca95 100644
--- a/docs/jobs/2026-06-08-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-08-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-08T17:02:56.838Z",
+  "verified_at": "2026-06-08T19:52:45.610Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1248",
+      "current_value": "1260",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -123,7 +123,7 @@
       "description": "Sections in CAPABILITY_REGISTRY.md (§N entries)",
       "status": "ok",
       "last_value": "19",
-      "current_value": "97",
+      "current_value": "100",
       "tolerance": "min:10",
       "command": "grep -c '^## §' docs/CAPABILITY_REGISTRY.md",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-08-pre-commit-pipeline.json b/docs/jobs/2026-06-08-pre-commit-pipeline.json
index 3f671b13..793779a7 100644
--- a/docs/jobs/2026-06-08-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-08-pre-commit-pipeline.json
@@ -78,5 +78,45 @@
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
diff --git a/scripts/gpt-freshness-check.ts b/scripts/gpt-freshness-check.ts
new file mode 100644
index 00000000..c7c41ce7
--- /dev/null
+++ b/scripts/gpt-freshness-check.ts
@@ -0,0 +1,126 @@
+#!/usr/bin/env bun
+/**
+ * gpt-freshness-check.ts
+ * Verifica se os knowledge files do GPT EGOS estão desatualizados.
+ *
+ * Uso: bun scripts/gpt-freshness-check.ts
+ * Roda via cron semanal (Hermes) e notifica Enio pelo Telegram.
+ * Exit code 1 se desatualizado, 0 se ok.
+ */
+
+import { statSync, existsSync } from "node:fs";
+import { resolve } from "node:path";
+
+// ---------------------------------------------------------------------------
+// Configuração
+// ---------------------------------------------------------------------------
+
+const REPO_ROOT = resolve(import.meta.dir, "..");
+
+const SOURCES = [
+  "docs/drafts/free-artifact-egos-v0.md",
+  "docs/strategy/APRESENTACAO_EGOS.md",
+  // Metaprompts técnicos referenciados no compilado
+  "docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md",
+  "docs/metaprompts/MP-SEC-001.md",
+  "docs/metaprompts/MP-LGPD-001.md",
+  "docs/metaprompts/MP-RESEARCH-001.md",
+  "docs/metaprompts/MP-ITEM-INTAKE-001.md",
+  "docs/metaprompts/MP-AUDIT-001.md",
+  "docs/metaprompts/MP-HANDOFF-001.md",
+];
+
+const COMPILED = "docs/drafts/gpt-knowledge-compiled.md";
+const MAX_STALE_DAYS = 7;
+
+// ---------------------------------------------------------------------------
+// Helpers
+// ---------------------------------------------------------------------------
+
+function abs(rel: string): string {
+  return resolve(REPO_ROOT, rel);
+}
+
+function mtimeMs(rel: string): number | null {
+  const p = abs(rel);
+  if (!existsSync(p)) return null;
+  try {
+    return statSync(p).mtimeMs;
+  } catch {
+    return null;
+  }
+}
+
+function formatDate(ms: number): string {
+  return new Date(ms).toISOString().slice(0, 19).replace("T", " ");
+}
+
+function daysDiff(olderMs: number, newerMs: number): number {
+  return (newerMs - olderMs) / (1000 * 60 * 60 * 24);
+}
+
+// ---------------------------------------------------------------------------
+// Main
+// ---------------------------------------------------------------------------
+
+const compiledMtime = mtimeMs(COMPILED);
+
+if (compiledMtime === null) {
+  console.error(`[ERRO] Arquivo compilado não encontrado: ${COMPILED}`);
+  console.error("       Rode o processo de compilação antes de verificar.");
+  process.exit(1);
+}
+
+console.log(`\nGPT Knowledge Freshness Check`);
+console.log(`Compilado : ${COMPILED}`);
+console.log(`Timestamp : ${formatDate(compiledMtime)}`);
+console.log(`Max stale : ${MAX_STALE_DAYS} dias\n`);
+
+type SourceResult = {
+  path: string;
+  status: "ok" | "stale" | "missing";
+  sourceMtime: number | null;
+  diffDays: number | null;
+};
+
+const results: SourceResult[] = [];
+
+for (const src of SOURCES) {
+  const srcMtime = mtimeMs(src);
+
+  if (srcMtime === null) {
+    console.warn(`  ⚠  MISSING  ${src}`);
+    results.push({ path: src, status: "missing", sourceMtime: null, diffDays: null });
+    continue;
+  }
+
+  if (srcMtime > compiledMtime) {
+    const diff = daysDiff(compiledMtime, srcMtime);
+    console.warn(`  ⚠  STALE    ${src}`);
+    console.warn(`             fonte: ${formatDate(srcMtime)} (${diff.toFixed(1)}d mais nova que compilado)`);
+    results.push({ path: src, status: "stale", sourceMtime: srcMtime, diffDays: diff });
+  } else {
+    console.log(`  ✓  OK       ${src}`);
+    results.push({ path: src, status: "ok", sourceMtime: srcMtime, diffDays: null });
+  }
+}
+
+// Resumo
+const stale = results.filter((r) => r.status === "stale");
+const missing = results.filter((r) => r.status === "missing");
+const ok = results.filter((r) => r.status === "ok");
+
+console.log(`\nResumo: ${ok.length} ok · ${stale.length} desatualizado(s) · ${missing.length} ausente(s)\n`);
+
+if (stale.length > 0 || missing.length > 0) {
+  console.error("⚠️  GPT knowledge desatualizado — re-exportar e subir no ChatGPT");
+  console.error("\nAção necessária:");
+  console.error("  1. Revisar os arquivos marcados como STALE ou MISSING acima.");
+  console.error("  2. Recompilar: atualizar docs/drafts/gpt-knowledge-compiled.md");
+  console.error("  3. Subir o arquivo atualizado no GPT EGOS (ChatGPT > My GPTs > Knowledge).");
+  console.error("  4. Confirmar no Telegram t.me/ethikin que a atualização foi publicada.");
+  process.exit(1);
+} else {
+  console.log("✅ GPT knowledge atualizado — nenhuma fonte modificada após o compilado.");
+  process.exit(0);
+}

exec
/bin/bash -lc 'ls -l docs/drafts/free-artifact-egos-v0.md docs/strategy/APRESENTACAO_EGOS.md docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md docs/metaprompts/MP-SEC-001.md docs/metaprompts/MP-LGPD-001.md docs/metaprompts/MP-RESEARCH-001.md docs/metaprompts/MP-ITEM-INTAKE-001.md docs/metaprompts/MP-AUDIT-001.md docs/metaprompts/MP-HANDOFF-001.md docs/drafts/gpt-knowledge-compiled.md; bun scripts/gpt-freshness-check.ts' in /home/enio/egos
 succeeded in 0ms:
-rw-rw-r-- 1 enio enio  7724 Jun  5 15:58 docs/drafts/free-artifact-egos-v0.md
-rw-rw-r-- 1 enio enio 19449 Jun  9 09:54 docs/drafts/gpt-knowledge-compiled.md
-rw-rw-r-- 1 enio enio  5135 Jun  3 10:11 docs/metaprompts/MP-AUDIT-001.md
-rw-rw-r-- 1 enio enio  7773 Jun  3 10:12 docs/metaprompts/MP-HANDOFF-001.md
-rw-rw-r-- 1 enio enio  7271 Jun  3 16:54 docs/metaprompts/MP-ITEM-INTAKE-001.md
-rw-rw-r-- 1 enio enio  8285 Jun  3 09:57 docs/metaprompts/MP-LGPD-001.md
-rw-rw-r-- 1 enio enio  5573 Jun  3 10:13 docs/metaprompts/MP-RESEARCH-001.md
-rw-rw-r-- 1 enio enio  5183 Jun  3 09:55 docs/metaprompts/MP-SEC-001.md
-rw-rw-r-- 1 enio enio 20306 Jun  3 16:55 docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md
-rw-rw-r-- 1 enio enio 17881 Jun  9 08:00 docs/strategy/APRESENTACAO_EGOS.md

GPT Knowledge Freshness Check
Compilado : docs/drafts/gpt-knowledge-compiled.md
Timestamp : 2026-06-09 12:54:53
Max stale : 7 dias

  ✓  OK       docs/drafts/free-artifact-egos-v0.md
  ✓  OK       docs/strategy/APRESENTACAO_EGOS.md
  ✓  OK       docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md
  ✓  OK       docs/metaprompts/MP-SEC-001.md
  ✓  OK       docs/metaprompts/MP-LGPD-001.md
  ✓  OK       docs/metaprompts/MP-RESEARCH-001.md
  ✓  OK       docs/metaprompts/MP-ITEM-INTAKE-001.md
  ✓  OK       docs/metaprompts/MP-AUDIT-001.md
  ✓  OK       docs/metaprompts/MP-HANDOFF-001.md

Resumo: 9 ok · 0 desatualizado(s) · 0 ausente(s)

✅ GPT knowledge atualizado — nenhuma fonte modificada após o compilado.

exec
/bin/bash -lc 'cat .claude/settings.json' in /home/enio/egos
 succeeded in 0ms:
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
      "Bash(bash ~/.claude/hooks/context-alarm.sh)",
      "Bash(echo \"EXIT: $?\")",
      "Bash(cp ~/.claude/hooks/context-alarm.sh scripts/claude-runtime/hooks/context-alarm.sh)",
      "Bash(mkdir -p /home/enio/.claude/egos-rules/)",
      "Bash(cat)",
      "Bash(bash scripts/check-skills-drift.sh --fix)",
      "Bash(cp \".claude/commands/start.md\" \"/home/enio/.egos/.claude/commands/start.md\")",
      "Bash(cp \".claude/commands/end.md\" \"/home/enio/.egos/.claude/commands/end.md\")",
      "mcp__notebooklm-mcp__studio_delete",
      "mcp__claude_ai_Supabase__execute_sql",
      "Bash(cp /home/enio/egos/.claude/commands/purge.md ~/.claude/commands/purge.md && echo \"OK: purge.md mirrored\")",
      "mcp__claude_ai_Supabase__list_projects"
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
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/skill-auto-match"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/context-alarm.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {
    "codex@openai-codex": true
  },
  "extraKnownMarketplaces": {
    "openai-codex": {
      "source": {
        "source": "github",
        "repo": "openai/codex-plugin-cc"
      }
    }
  },
  "alwaysThinkingEnabled": true,
  "effortLevel": "medium",
  "skipDangerousModePermissionPrompt": true
}

exec
/bin/bash -lc "nl -ba scripts/gpt-freshness-check.ts | sed -n '1,140p'

nl -ba docs/governance/ESSENTIAL_FILES_ARCHITECTURE.md | sed -n '1,130p'

nl -ba .claude/settings.json | sed -n '1,40p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * gpt-freshness-check.ts
     4	 * Verifica se os knowledge files do GPT EGOS estão desatualizados.
     5	 *
     6	 * Uso: bun scripts/gpt-freshness-check.ts
     7	 * Roda via cron semanal (Hermes) e notifica Enio pelo Telegram.
     8	 * Exit code 1 se desatualizado, 0 se ok.
     9	 */
    10	
    11	import { statSync, existsSync } from "node:fs";
    12	import { resolve } from "node:path";
    13	
    14	// ---------------------------------------------------------------------------
    15	// Configuração
    16	// ---------------------------------------------------------------------------
    17	
    18	const REPO_ROOT = resolve(import.meta.dir, "..");
    19	
    20	const SOURCES = [
    21	  "docs/drafts/free-artifact-egos-v0.md",
    22	  "docs/strategy/APRESENTACAO_EGOS.md",
    23	  // Metaprompts técnicos referenciados no compilado
    24	  "docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md",
    25	  "docs/metaprompts/MP-SEC-001.md",
    26	  "docs/metaprompts/MP-LGPD-001.md",
    27	  "docs/metaprompts/MP-RESEARCH-001.md",
    28	  "docs/metaprompts/MP-ITEM-INTAKE-001.md",
    29	  "docs/metaprompts/MP-AUDIT-001.md",
    30	  "docs/metaprompts/MP-HANDOFF-001.md",
    31	];
    32	
    33	const COMPILED = "docs/drafts/gpt-knowledge-compiled.md";
    34	const MAX_STALE_DAYS = 7;
    35	
    36	// ---------------------------------------------------------------------------
    37	// Helpers
    38	// ---------------------------------------------------------------------------
    39	
    40	function abs(rel: string): string {
    41	  return resolve(REPO_ROOT, rel);
    42	}
    43	
    44	function mtimeMs(rel: string): number | null {
    45	  const p = abs(rel);
    46	  if (!existsSync(p)) return null;
    47	  try {
    48	    return statSync(p).mtimeMs;
    49	  } catch {
    50	    return null;
    51	  }
    52	}
    53	
    54	function formatDate(ms: number): string {
    55	  return new Date(ms).toISOString().slice(0, 19).replace("T", " ");
    56	}
    57	
    58	function daysDiff(olderMs: number, newerMs: number): number {
    59	  return (newerMs - olderMs) / (1000 * 60 * 60 * 24);
    60	}
    61	
    62	// ---------------------------------------------------------------------------
    63	// Main
    64	// ---------------------------------------------------------------------------
    65	
    66	const compiledMtime = mtimeMs(COMPILED);
    67	
    68	if (compiledMtime === null) {
    69	  console.error(`[ERRO] Arquivo compilado não encontrado: ${COMPILED}`);
    70	  console.error("       Rode o processo de compilação antes de verificar.");
    71	  process.exit(1);
    72	}
    73	
    74	console.log(`\nGPT Knowledge Freshness Check`);
    75	console.log(`Compilado : ${COMPILED}`);
    76	console.log(`Timestamp : ${formatDate(compiledMtime)}`);
    77	console.log(`Max stale : ${MAX_STALE_DAYS} dias\n`);
    78	
    79	type SourceResult = {
    80	  path: string;
    81	  status: "ok" | "stale" | "missing";
    82	  sourceMtime: number | null;
    83	  diffDays: number | null;
    84	};
    85	
    86	const results: SourceResult[] = [];
    87	
    88	for (const src of SOURCES) {
    89	  const srcMtime = mtimeMs(src);
    90	
    91	  if (srcMtime === null) {
    92	    console.warn(`  ⚠  MISSING  ${src}`);
    93	    results.push({ path: src, status: "missing", sourceMtime: null, diffDays: null });
    94	    continue;
    95	  }
    96	
    97	  if (srcMtime > compiledMtime) {
    98	    const diff = daysDiff(compiledMtime, srcMtime);
    99	    console.warn(`  ⚠  STALE    ${src}`);
   100	    console.warn(`             fonte: ${formatDate(srcMtime)} (${diff.toFixed(1)}d mais nova que compilado)`);
   101	    results.push({ path: src, status: "stale", sourceMtime: srcMtime, diffDays: diff });
   102	  } else {
   103	    console.log(`  ✓  OK       ${src}`);
   104	    results.push({ path: src, status: "ok", sourceMtime: srcMtime, diffDays: null });
   105	  }
   106	}
   107	
   108	// Resumo
   109	const stale = results.filter((r) => r.status === "stale");
   110	const missing = results.filter((r) => r.status === "missing");
   111	const ok = results.filter((r) => r.status === "ok");
   112	
   113	console.log(`\nResumo: ${ok.length} ok · ${stale.length} desatualizado(s) · ${missing.length} ausente(s)\n`);
   114	
   115	if (stale.length > 0 || missing.length > 0) {
   116	  console.error("⚠️  GPT knowledge desatualizado — re-exportar e subir no ChatGPT");
   117	  console.error("\nAção necessária:");
   118	  console.error("  1. Revisar os arquivos marcados como STALE ou MISSING acima.");
   119	  console.error("  2. Recompilar: atualizar docs/drafts/gpt-knowledge-compiled.md");
   120	  console.error("  3. Subir o arquivo atualizado no GPT EGOS (ChatGPT > My GPTs > Knowledge).");
   121	  console.error("  4. Confirmar no Telegram t.me/ethikin que a atualização foi publicada.");
   122	  process.exit(1);
   123	} else {
   124	  console.log("✅ GPT knowledge atualizado — nenhuma fonte modificada após o compilado.");
   125	  process.exit(0);
   126	}
     1	# Essential Files Architecture — roteadores, não enciclopédias
     2	
     3	> **Status:** PROPOSTA (aguarda validação Enio + Banda + Codex) · **last_update:** 2026-06-09 · **owner:** prime
     4	> **Origem:** corte Enio 2026-06-08 — arquivos essenciais devem funcionar como índices/roteadores com memória condensada, triggers de tamanho, cross-refs e freshness.
     5	> **Task:** MEMORY-ROUTER-ARCH-001 · **Estende:** `CLAUDE.md §Limites de arquivo` (não substitui)
     6	> **Audience:** AI⟷AI (R-DOC-AUDIENCE-001) — denso, machine-parseable.
     7	
     8	---
     9	
    10	## §0 Princípio (validado por pesquisa jun/2026)
    11	
    12	**Arquivo essencial = índice → temático → profundo → evidência.** O arquivo principal é curto e roteia; o detalhe vive em arquivos temáticos lazy-loaded; a evidência vive em docs profundos referenciados, nunca copiados.
    13	
    14	Isto é **progressive disclosure / just-in-time context** — suportado por pesquisa jun/2026 (Anthropic context-engineering; padrão `@import` + AGENTS.md hierárquico). O `@import`/hooks/lazy-load é OFICIAL; os limites de linha são heurística de mercado.
    15	
    16	---
    17	
    18	## §1 Achados da pesquisa (classificados)
    19	
    20	| # | Achado | Classe |
    21	|---|--------|--------|
    22	| 1 | LLMs de fronteira seguem ~150-200 instruções antes da aderência degradar; system prompt do Claude Code já usa ~50 → orçamento ~100-150 *(contagem aproximada; critério de "instrução" varia por fonte — heurística, não dado verificado)* | PRÁTICA COMUM (múltiplas fontes 2026) |
    23	| 2 | CLAUDE.md/AGENTS.md: ideal <200 linhas, teto ~300; AGENTS.md hard max 32 KiB | PRÁTICA COMUM |
    24	| 3 | "Lost in the middle": arquivo longo → regras silenciosamente ignoradas; **adicionar regra faz o modelo seguir MENOS** | PRÁTICA COMUM |
    25	| 4 | Estudo ETH Zurich: context files gerados por LLM REDUZIRAM sucesso ~3% e +20% custo; curados por humano +4% | HIPÓTESE (estudo citado por fontes secundárias — não verificado por nós) |
    26	| 5 | Flat `memory.md` não escala: carrega tudo no contexto, sem recall semântico, sem decay, sem dedup | PRÁTICA COMUM (conch/distill/ashnode/agent-knowledge convergem) |
    27	| 6 | Memória madura = recall limitado (top-k) + freshness/decay + supersessão (claim_key) + detecção de contradição + proveniência + dedup-na-escrita | PRÁTICA COMUM (estado da arte OSS 2026) |
    28	| 7 | Fixes p/ arquivo grande: `@import`/progressive disclosure, sub-arquivos lazy-load, hooks p/ comportamento determinístico, linter p/ estilo | OFICIAL (Anthropic best-practices) + PRÁTICA |
    29	
    30	**Não inventado:** nenhum número acima é "regra oficial da Anthropic" exceto o uso de `@import`/hooks/lazy-load. Os limites de linha são heurística de mercado convergente, adotada aqui como ponto de partida a validar.
    31	
    32	---
    33	
    34	## §2 Inventário EGOS (real, 2026-06-09)
    35	
    36	| Arquivo | Linhas | Tipo | Veredito |
    37	|---|---|---|---|
    38	| `end.md` | 1058 | comando | 🔴 condensar (maior ofensor) |
    39	| `TASKS.md` | 904 | índice-tarefa | 🔴 acima hard limit 600 (já tem auto-archive) |
    40	| `MEMORY.md` | 652 | índice-memória | 🔴 índice inchou; 329 entradas, não carrega inteiro |
    41	| `start.md` | 645 | comando | 🟡 grande |
    42	| `memory/*.md` | 329 arq / 17.9k L | store | 🔴 sprawl — sem supersessão/decay/dedup |
    43	| `~/.claude/CLAUDE.md` | 232 | instrução-global | 🟡 levemente acima de 200 |
    44	| `egos/CLAUDE.md` | 268 | instrução-projeto | 🟡 levemente acima de 200 |
    45	| `AGENTS.md` | 200 | instrução | 🟢 no limite |
    46	| `EGOS_BOOTSTRAP.md` | 302 | temático | 🟢 ok |
    47	| `ENIO_UNDERSTANDING_MAP.md` | 144 | temático | 🟢 ok |
    48	
    49	---
    50	
    51	## §3 Política proposta (HEURÍSTICA — estende `CLAUDE.md §Limites de arquivo`)
    52	
    53	| Tipo de arquivo | Warn | Condensar | Ação |
    54	|---|---|---|---|
    55	| Instrução carregada toda sessão (CLAUDE.md, AGENTS.md) | 200 | 300 | mover detalhe p/ temático + `@import`; regra de estilo→linter; automação→hook |
    56	| Índice-memória (MEMORY.md) | 400 L / 250 entradas | 500 | arquivar entradas frias → `MEMORY_ARCHIVE.md`; confiar em recall semântico (egos-memory MCP) |
    57	| Fato de memória (memory/*.md) | 60 | 80 | um fato por arquivo; **dedup-na-escrita ANTES (ver §6 pré-requisito): checar [[relacionados]] + claim_key; atualizar/supersedir em vez de criar 330º arquivo**. Grace period migração: 2026-07-01 |
    58	| Comando/skill (start.md, end.md) | 400 | 600 | extrair sub-passos p/ `docs/*-layers/` (lazy ref). **WARN-ONLY via /start — NUNCA bloqueia (Codex flow-risk): condensar lógica de fase às cegas = perder passos. Revisão = Banda/manual, não cap automático** |
    59	| Temático (governance/strategy) | 400 | 600 | dividir por sub-tema |
    60	| Profundo (specs/research/audits) | — | — | sem limite; **referenciar, nunca inline** em principais |
    61	
    62	**Enforcement:** decisão Enio = **relatório primeiro** (este doc). NÃO virar bloqueio nem alerta automático até validação. Próximo passo após validar: decidir warn-not-block (Sentinela/`/start`) vs pre-commit.
    63	
    64	---
    65	
    66	## §4 Metadata mínima por arquivo essencial
    67	
    68	**Obrigatório (2 campos — Codex anti-overengineering):**
    69	```yaml
    70	last_update: YYYY-MM-DD
    71	status: ATUAL | REVISAR | PESQUISAR | HISTÓRICO
    72	```
    73	**Opcional** (quando agrega): `owner`, `scope`, `freshness_trigger`. Não exigir boilerplate em 329 arquivos.
    74	
    75	**Freshness:**
    76	- **ATUAL** — revisado, estável.
    77	- **REVISAR** — pode estar velho (passou do intervalo).
    78	- **PESQUISAR** — tema volátil (ferramenta/API/preço/lei/modelo) → agente avalia pesquisa externa (Exa/WebSearch/RAG). Firecrawl ausente → avisar p/ configurar.
    79	- **HISTÓRICO** — registro, não orientação atual.
    80	
    81	---
    82	
    83	## §5 Cross-reference + expansão progressiva
    84	
    85	Bloco-padrão mínimo p/ área citada num índice (1 linha de resumo + 1 `fonte:`):
    86	
    87	```md
    88	- **<área>** — <resumo 1 linha>. fonte: <memory/ ou docs/ temático>
    89	```
    90	
    91	Regra: índice (MEMORY.md/CLAUDE.md) com N áreas → agente (1) acha a área, (2) segue o link `fonte:`, (3) segue links profundos lá, (4) checa freshness, (5) decide se pesquisa. Nunca carregar tudo. (É o formato que MEMORY.md já usa — manter, não burocratizar.)
    92	
    93	---
    94	
    95	## §6 Gaps / decisões pendentes (Enio)
    96	
    97	> **PRÉ-REQUISITO BLOQUEANTE (Codex CRITICAL):** o problema #1 do EGOS é o sprawl de 329 memory/ SEM supersessão/dedup/decay — não contagem de linhas. **NÃO wirar nenhum enforcement de limite antes de resolver dedup-na-escrita** (claim_key/supersessão via egos-memory MCP, que já existe). Limite de linha sem dedup = falsa segurança.
    98	
    99	1. Enforcement final: relatório → depois warn-not-block ou pre-commit? (recomendado: warn-only; comandos NUNCA bloqueiam)
   100	2. MEMORY.md: criar `MEMORY_ARCHIVE.md` + mover entradas frias? (espelha TASKS_ARCHIVE)
   101	3. **[PROMOVIDO A PRÉ-REQUISITO]** supersessão/decay/dedup no memory/ via egos-memory MCP — implementar ANTES de qualquer cap.
   102	4. Aplicar limites de instrução a CLAUDE.md global+projeto (268/232 → trim p/ <200 via @import)?
   103	5. **Freshness enforcement (Codex):** wirar Sentinela cron p/ varrer `last_update` e marcar `REVISAR` se >60d. Sem isso, todo arquivo fica `ATUAL` pra sempre = metadata apodrece. Resolver senão §4 é decoração.
   104	6. **Conflito a resolver:** AGENTS.md tem hard-limit 400 em `CLAUDE.md §Limites` mas §3 aqui sugere 200 (instrução). Alinhar antes de aplicar.
   105	
   106	---
   107	
   108	## §7 Revisão pendente
   109	
   110	- [x] Banda Cognitiva (4 papéis) — 2026-06-09: APROVA direção, escopo reduzido; line-limit não é o ganho, condensar 3 ofensores + adotar recall/supersessão é.
   111	- [x] Codex review — 2026-06-09: APPROVE-WITH-CHANGES; 5 achados aplicados (dedup pré-requisito, metadata 2 campos, comandos warn-only, caveat #1, freshness via Sentinela).
   112	- [ ] Validação Enio (§6)
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
    26	    ],
    27	    "deny": [
    28	      "Bash(rm -rf /:*)",
    29	      "Bash(rm -rf ~:*)",
    30	      "Bash(dd if=:*)",
    31	      "Bash(mkfs:*)"
    32	    ],
    33	    "defaultMode": "bypassPermissions",
    34	    "additionalDirectories": [
    35	      "/home/enio/egos/.claude/commands"
    36	    ]
    37	  },
    38	  "hooks": {
    39	    "PreToolUse": [
    40	      {

exec
/bin/bash -lc 'git diff 0dbcd0c065bc614847ab557f77097ecc177b34df -- scripts/gpt-freshness-check.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/scripts/gpt-freshness-check.ts b/scripts/gpt-freshness-check.ts
new file mode 100644
index 00000000..c7c41ce7
--- /dev/null
+++ b/scripts/gpt-freshness-check.ts
@@ -0,0 +1,126 @@
+#!/usr/bin/env bun
+/**
+ * gpt-freshness-check.ts
+ * Verifica se os knowledge files do GPT EGOS estão desatualizados.
+ *
+ * Uso: bun scripts/gpt-freshness-check.ts
+ * Roda via cron semanal (Hermes) e notifica Enio pelo Telegram.
+ * Exit code 1 se desatualizado, 0 se ok.
+ */
+
+import { statSync, existsSync } from "node:fs";
+import { resolve } from "node:path";
+
+// ---------------------------------------------------------------------------
+// Configuração
+// ---------------------------------------------------------------------------
+
+const REPO_ROOT = resolve(import.meta.dir, "..");
+
+const SOURCES = [
+  "docs/drafts/free-artifact-egos-v0.md",
+  "docs/strategy/APRESENTACAO_EGOS.md",
+  // Metaprompts técnicos referenciados no compilado
+  "docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md",
+  "docs/metaprompts/MP-SEC-001.md",
+  "docs/metaprompts/MP-LGPD-001.md",
+  "docs/metaprompts/MP-RESEARCH-001.md",
+  "docs/metaprompts/MP-ITEM-INTAKE-001.md",
+  "docs/metaprompts/MP-AUDIT-001.md",
+  "docs/metaprompts/MP-HANDOFF-001.md",
+];
+
+const COMPILED = "docs/drafts/gpt-knowledge-compiled.md";
+const MAX_STALE_DAYS = 7;
+
+// ---------------------------------------------------------------------------
+// Helpers
+// ---------------------------------------------------------------------------
+
+function abs(rel: string): string {
+  return resolve(REPO_ROOT, rel);
+}
+
+function mtimeMs(rel: string): number | null {
+  const p = abs(rel);
+  if (!existsSync(p)) return null;
+  try {
+    return statSync(p).mtimeMs;
+  } catch {
+    return null;
+  }
+}
+
+function formatDate(ms: number): string {
+  return new Date(ms).toISOString().slice(0, 19).replace("T", " ");
+}
+
+function daysDiff(olderMs: number, newerMs: number): number {
+  return (newerMs - olderMs) / (1000 * 60 * 60 * 24);
+}
+
+// ---------------------------------------------------------------------------
+// Main
+// ---------------------------------------------------------------------------
+
+const compiledMtime = mtimeMs(COMPILED);
+
+if (compiledMtime === null) {
+  console.error(`[ERRO] Arquivo compilado não encontrado: ${COMPILED}`);
+  console.error("       Rode o processo de compilação antes de verificar.");
+  process.exit(1);
+}
+
+console.log(`\nGPT Knowledge Freshness Check`);
+console.log(`Compilado : ${COMPILED}`);
+console.log(`Timestamp : ${formatDate(compiledMtime)}`);
+console.log(`Max stale : ${MAX_STALE_DAYS} dias\n`);
+
+type SourceResult = {
+  path: string;
+  status: "ok" | "stale" | "missing";
+  sourceMtime: number | null;
+  diffDays: number | null;
+};
+
+const results: SourceResult[] = [];
+
+for (const src of SOURCES) {
+  const srcMtime = mtimeMs(src);
+
+  if (srcMtime === null) {
+    console.warn(`  ⚠  MISSING  ${src}`);
+    results.push({ path: src, status: "missing", sourceMtime: null, diffDays: null });
+    continue;
+  }
+
+  if (srcMtime > compiledMtime) {
+    const diff = daysDiff(compiledMtime, srcMtime);
+    console.warn(`  ⚠  STALE    ${src}`);
+    console.warn(`             fonte: ${formatDate(srcMtime)} (${diff.toFixed(1)}d mais nova que compilado)`);
+    results.push({ path: src, status: "stale", sourceMtime: srcMtime, diffDays: diff });
+  } else {
+    console.log(`  ✓  OK       ${src}`);
+    results.push({ path: src, status: "ok", sourceMtime: srcMtime, diffDays: null });
+  }
+}
+
+// Resumo
+const stale = results.filter((r) => r.status === "stale");
+const missing = results.filter((r) => r.status === "missing");
+const ok = results.filter((r) => r.status === "ok");
+
+console.log(`\nResumo: ${ok.length} ok · ${stale.length} desatualizado(s) · ${missing.length} ausente(s)\n`);
+
+if (stale.length > 0 || missing.length > 0) {
+  console.error("⚠️  GPT knowledge desatualizado — re-exportar e subir no ChatGPT");
+  console.error("\nAção necessária:");
+  console.error("  1. Revisar os arquivos marcados como STALE ou MISSING acima.");
+  console.error("  2. Recompilar: atualizar docs/drafts/gpt-knowledge-compiled.md");
+  console.error("  3. Subir o arquivo atualizado no GPT EGOS (ChatGPT > My GPTs > Knowledge).");
+  console.error("  4. Confirmar no Telegram t.me/ethikin que a atualização foi publicada.");
+  process.exit(1);
+} else {
+  console.log("✅ GPT knowledge atualizado — nenhuma fonte modificada após o compilado.");
+  process.exit(0);
+}

exec
/bin/bash -lc "ls docs/metaprompts | sed -n '1,120p' && grep -n \"MP-AGENT\\|MP-SEC-002\\|MP-QA\\|MP-DEVOPS\\|MP-REVIEW\" docs/drafts/gpt-knowledge-compiled.md" in /home/enio/egos
 succeeded in 0ms:
MP-AGENT-001.md
MP-AGENT-002.md
MP-AUDIT-001.md
MP-DEVOPS-001.md
MP-HANDOFF-001.md
MP-ITEM-INTAKE-001.md
MP-LGPD-001.md
MP-MATERIAL-EVAL-001.md
MP-PIPELINE-001.md
MP-PRICE-001-005.md
MP-QA-001.md
MP-RESEARCH-001.md
MP-REVIEW-001.md
MP-SEC-001.md
MP-SEC-002.md
MP-SKILL-001.md
312:| MP-AGENT-001 | Despachar sub-agentes com escopo e gates | Ao iniciar qualquer agente filho no swarm |
313:| MP-AGENT-002 | Auditar output de sub-agente (REAL/CONCEPT/PHANTOM) | Após saída de agente antes de tomar ação |
315:| MP-SEC-002 | Defesa contra prompt injection | Antes de publicar endpoint que repassa input a LLM |
319:| MP-QA-001 | Geração de casos de teste | Ao implementar nova rota/função |
320:| MP-DEVOPS-001 | Checklist de deploy em produção | Antes de qualquer deploy em produção |
321:| MP-REVIEW-001 | Revisão de decisão arquitetural (ADR) | Antes de mudança irreversível de arquitetura |

exec
/bin/bash -lc "nl -ba docs/drafts/gpt-knowledge-compiled.md | sed -n '290,330p' && grep -n \"MP-SEC-001\\|MP-LGPD\\|MP-RESEARCH\\|MP-ITEM\\|MP-AUDIT\\|MP-HANDOFF\" docs/drafts/gpt-knowledge-compiled.md" in /home/enio/egos
 succeeded in 0ms:
   290	**Cuidados específicos:**
   291	- Foto de cardápio/catálogo → conversor item-intake processa e gera planilha; revisar antes de cadastrar
   292	- Dados de cliente para CRM não devem trafegar para LLM externo sem mascaramento
   293	- Promoções e preços gerados pela IA = RASCUNHO; aprovar antes de publicar
   294	
   295	**Exemplo de prompt de abertura configurado:**
   296	
   297	```
   298	Você é o Assistente Comercial Governado, apoiando comércio/restaurante na gestão de produtos e clientes.
   299	Atua em: gestão de cardápio e catálogo · comunicação com clientes · análise de dados de venda.
   300	Dados de clientes (nome, telefone, CPF) → mascarar automaticamente. Preços e promoções = RASCUNHO até aprovação humana.
   301	Para lançar promoção ou alterar preço: "Confirmar antes de publicar — checagem humana obrigatória."
   302	```
   303	
   304	---
   305	
   306	## Metaprompts Técnicos do EGOS (referência)
   307	
   308	Os metaprompts abaixo são os disponíveis no EGOS para uso técnico avançado (disponíveis em `docs/metaprompts/`):
   309	
   310	| ID | Propósito | Quando usar |
   311	|----|-----------|-------------|
   312	| MP-AGENT-001 | Despachar sub-agentes com escopo e gates | Ao iniciar qualquer agente filho no swarm |
   313	| MP-AGENT-002 | Auditar output de sub-agente (REAL/CONCEPT/PHANTOM) | Após saída de agente antes de tomar ação |
   314	| MP-SEC-001 | Revisão de segurança de artefato | Antes de merge que toca auth/secrets/RLS |
   315	| MP-SEC-002 | Defesa contra prompt injection | Antes de publicar endpoint que repassa input a LLM |
   316	| MP-LGPD-001 | Auditoria de compliance LGPD | Antes de feature que coleta dado pessoal |
   317	| MP-AUDIT-001 | Auditoria de capability (evita phantom stubs) | Ao adicionar nova capability ao registry |
   318	| MP-HANDOFF-001 | Geração de handoff estruturado de sessão | Ao fim de sessão longa |
   319	| MP-QA-001 | Geração de casos de teste | Ao implementar nova rota/função |
   320	| MP-DEVOPS-001 | Checklist de deploy em produção | Antes de qualquer deploy em produção |
   321	| MP-REVIEW-001 | Revisão de decisão arquitetural (ADR) | Antes de mudança irreversível de arquitetura |
   322	| MP-RESEARCH-001 | Pesquisa de mercado/competidor/tecnologia | Pesquisa estratégica com fontes classificadas |
   323	| MP-ITEM-INTAKE-001 | Foto/PDF de lista → planilha PDV governada | Converter cardápio/catálogo com revisão humana |
   324	
   325	---
   326	
   327	## Como o GPT EGOS funciona (comportamento esperado)
   328	
   329	Quando você abre o GPT EGOS, ele:
   330	
314:| MP-SEC-001 | Revisão de segurança de artefato | Antes de merge que toca auth/secrets/RLS |
316:| MP-LGPD-001 | Auditoria de compliance LGPD | Antes de feature que coleta dado pessoal |
317:| MP-AUDIT-001 | Auditoria de capability (evita phantom stubs) | Ao adicionar nova capability ao registry |
318:| MP-HANDOFF-001 | Geração de handoff estruturado de sessão | Ao fim de sessão longa |
322:| MP-RESEARCH-001 | Pesquisa de mercado/competidor/tecnologia | Pesquisa estratégica com fontes classificadas |
323:| MP-ITEM-INTAKE-001 | Foto/PDF de lista → planilha PDV governada | Converter cardápio/catálogo com revisão humana |

exec
/bin/bash -lc "grep -n \"MP-AGENT-001\\|MP-SEC-002\\|MP-QA-001\\|MP-DEVOPS-001\\|MP-REVIEW-001\" docs/modules/metaprompt-generator/METAPROMPTS_INDEX.md | head -20" in /home/enio/egos
 succeeded in 0ms:
152:**MP-AGENT-001 — Agent Dispatch Prompt**
200:**MP-SEC-002 — Prompt Injection Defense Prompt**
244:**MP-QA-001 — Test Case Generation Prompt**
255:**MP-DEVOPS-001 — Deployment Checklist Prompt**
266:**MP-REVIEW-001 — Architecture Decision Review Prompt**

exec
/bin/bash -lc "cat package.json | jq '.scripts | with_entries(select(.key|test(\"gpt|fresh|cron|job\")))'" in /home/enio/egos
 succeeded in 0ms:
{
  "chatgpt:ingest": "bun scripts/chatgpt-export-sync.ts --dry",
  "chatgpt:ingest:exec": "bun scripts/chatgpt-export-sync.ts --exec",
  "chatgpt:watch": "bun scripts/chatgpt-export-watch.ts --dry",
  "chatgpt:watch:exec": "bun scripts/chatgpt-export-watch.ts --exec"
}

exec
/bin/bash -lc 'git diff --check 0dbcd0c065bc614847ab557f77097ecc177b34df' in /home/enio/egos
 succeeded in 0ms:
exec
/bin/bash -lc 'git log --oneline --decorate --max-count=6' in /home/enio/egos
 succeeded in 0ms:
dee4da45 (HEAD -> main, origin/main) chore(tasks): MEMORY-ROUTER-ARCH done + follow-ons; fix phantom-done de 2 tasks
251ece05 feat(gpt): knowledge compiled + freshness-check script para GPT EGOS
547d31a5 docs(governance): ESSENTIAL_FILES_ARCHITECTURE — proposta memória-roteador (Banda+Codex)
0dbcd0c0 chore(tasks): +MEMORY-ROUTER-ARCH-001 +KNOWLEDGE-INGEST-CHANNEL-001 +END-INGEST-PROMPT-001
8c2dbb5e feat(epos): fecha loop EPOS→sistema (atom+memória+MAP) — corte Enio 2026-06-08
4529821b chore(audit): Guard Brasil machine-wide audit P174 + task done — 6 impl, 3 repos, flagship

codex
The new freshness-check script can miss stale GPT knowledge because it relies on mutable filesystem mtimes rather than a stable source/compiled relationship. The rest of the changes are mostly documentation/task updates.

Review comment:

- [P2] Use a stable freshness signal instead of mtimes — /home/enio/egos/scripts/gpt-freshness-check.ts:97-101
  When a source file changes but the compiled knowledge file is later touched, copied, or checked out with a newer filesystem mtime, this comparison reports everything as OK even though the compiled content predates the source. Since this script is intended for a weekly cron to decide whether the GPT knowledge must be re-exported, filesystem mtimes are not reliable enough; compare git commit timestamps/hashes, embedded compiled metadata, or recorded source hashes instead.
The new freshness-check script can miss stale GPT knowledge because it relies on mutable filesystem mtimes rather than a stable source/compiled relationship. The rest of the changes are mostly documentation/task updates.

Review comment:

- [P2] Use a stable freshness signal instead of mtimes — /home/enio/egos/scripts/gpt-freshness-check.ts:97-101
  When a source file changes but the compiled knowledge file is later touched, copied, or checked out with a newer filesystem mtime, this comparison reports everything as OK even though the compiled content predates the source. Since this script is intended for a weekly cron to decide whether the GPT knowledge must be re-exported, filesystem mtimes are not reliable enough; compare git commit timestamps/hashes, embedded compiled metadata, or recorded source hashes instead.
```
