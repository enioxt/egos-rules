# Codex Local Review — 2026-06-05T16:34:32Z

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
session id: 019e98a2-e7b7-7032-bf6a-0af250e6b5b5
--------
user
changes against 'HEAD~3'
2026-06-05T16:34:34.571556Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-05T16:34:34.573493Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff df318d683a1fd40af68933bf134e9bd746159b5c --stat && git diff df318d683a1fd40af68933bf134e9bd746159b5c' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                      |   3 +
 apps/egos-landing/public/timeline/rss         |   2 +-
 apps/egos-landing/public/timeline/rss.xml     |   2 +-
 docs/drafts/free-artifact-egos-v0.md          |  11 +-
 docs/jobs/2026-06-05-doc-drift-verifier.json  |   6 +-
 docs/jobs/2026-06-05-handoff-fidelity.json    |  26 +++++
 docs/jobs/2026-06-05-pre-commit-pipeline.json | 152 ++++++++++++++++++++++++++
 docs/strategy/PRODUCT_MODEL.md                |  43 ++++++++
 8 files changed, 237 insertions(+), 8 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 43ef18d4..a9190c20 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -14,6 +14,9 @@
 > Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
 > PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
 
+- [ ] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — Criar o GPT próprio EGOS no ChatGPT: (a) metaprompt = artefato v3 (free-artifact-egos-v0.md) com identidade EGOS completa; (b) MCP configurado apontando para egos.ia.br/mcp (bridge pública); (c) ferramentas expostas: Guard Brasil (scan PII), item-intake, metaprompts, knowledge base; (d) memória ChatGPT ativa; (e) link público para distribuir (quem tem o link = usa o agente). Smoke: usuário clica no link → GPT abre → MCP responde → tool funciona. Sem setup do usuário. HITL: Enio aprova metaprompt do GPT antes de publicar o link.
+- [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md.
+- [ ] **PRODUCT-TIERS-001** [P0] `prime` `gated:HITL` — Documentar pirâmide de acesso EGOS: (1) Telegram gratuito (comunidade global); (2) WhatsApp R$4 (agente vivo + grupo + resumo 7h); (3) GPT próprio + MCP (acesso completo às ferramentas do VPS — incluído no R$4 ou tier separado? Enio decide); (4) IDE + SSOT (modo profissional completo). SSOT: `docs/business/product-tiers.md`. Clarifica o que cada tier entrega e se GPT está no R$4 ou é tier separado.
 - [ ] **PRODUCT-R4-DEFINITION-001** [P0] `prime` — Documentar o que R$4 compra: acesso ao grupo WhatsApp EGOS (número +55 34 9793-4688 configurado como agente EGOS) + agente responde/interage 24h + resumo diário 7h automático + acesso completo a tudo (metaprompts, tools, roadmap). Telegram = gratuito/aberto/comunidade global. WhatsApp = pago/privado/agente vivo. SSOT: `docs/business/product-r4.md`.
 - [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
 - [ ] **ARTIFACT-CONFIG-PROTOCOL-001** [P1] `prime` — Adicionar bloco "CONFIGURAÇÃO INICIAL OBRIGATÓRIA" ao artefato gratuito v2 (metaprompt): quando há placeholders como [área]/[contexto], agente entra em modo de configuração, identifica gaps, faz perguntas objetivas por rodada, propõe HIPÓTESE quando possível, só passa ao modo operacional após confirmação. Insight da conversa ChatGPT 2026-06-05. Editar `docs/drafts/free-artifact-egos-v0.md` antes do glance do Enio.
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
diff --git a/docs/drafts/free-artifact-egos-v0.md b/docs/drafts/free-artifact-egos-v0.md
index b5105a03..1efc541c 100644
--- a/docs/drafts/free-artifact-egos-v0.md
+++ b/docs/drafts/free-artifact-egos-v0.md
@@ -20,9 +20,14 @@ Atua exclusivamente em:
 Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
 
 ── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
-Se este prompt contiver campos entre colchetes ([área], [contexto], [Área 1], etc.), você ainda NÃO está totalmente configurado.
-Entre em modo de configuração: (1) identifique todos os campos em aberto; (2) explique brevemente por que cada um é necessário; (3) faça perguntas objetivas em rodadas (não tudo de uma vez); (4) se tiver informação suficiente para propor preenchimento, classifique como HIPÓTESE e peça validação; (5) só passe ao modo operacional após confirmação do escopo principal.
-Formato de abertura: "Ainda não estou configurado. Gaps: [campo] — [por que importa]. Pergunta 1: ..."
+Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
+Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
+Fluxo obrigatório:
+1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
+2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
+3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
+4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
+NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
 
 ── CLASSIFICAÇÃO OBRIGATÓRIA ──
 Classifique afirmações relevantes como:
diff --git a/docs/jobs/2026-06-05-doc-drift-verifier.json b/docs/jobs/2026-06-05-doc-drift-verifier.json
index 7d7e9644..691913ea 100644
--- a/docs/jobs/2026-06-05-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-05-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-05T00:45:48.823Z",
+  "verified_at": "2026-06-05T15:33:15.025Z",
   "summary": {
     "total_claims": 16,
     "passed": 15,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1332",
+      "current_value": "1354",
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
index 035e8334..37cdaea2 100644
--- a/docs/jobs/2026-06-05-handoff-fidelity.json
+++ b/docs/jobs/2026-06-05-handoff-fidelity.json
@@ -11,5 +11,31 @@
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
+  },
+  {
+    "ts": "2026-06-05T15:31:36.248Z",
+    "file": "docs/_current_handoffs/INIT_AGENT-C_2026-06-05.md",
+    "done_claims": 5,
+    "done_with_sha": 3,
+    "claims_with_sha_pct": 60,
+    "inprogress_items": 0,
+    "inprogress_with_next": 0,
+    "inprogress_next_pct": 100,
+    "todos_persisted": true,
+    "decisions_captured": false,
+    "completeness_score": 69
   }
 ]
diff --git a/docs/jobs/2026-06-05-pre-commit-pipeline.json b/docs/jobs/2026-06-05-pre-commit-pipeline.json
index b4a04019..5bc3b591 100644
--- a/docs/jobs/2026-06-05-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-05-pre-commit-pipeline.json
@@ -230,5 +230,157 @@
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
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:41:25.370Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=ad5e6cfd",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:55:10.508Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=4f6b7f3e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T12:59:17.984Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=114571c7",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T15:33:17.283Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=4b2110e9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T15:37:42.850Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=d8e61ce0",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T16:07:01.692Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=20cba0ba",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T16:16:22.464Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=df318d68",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T16:23:56.233Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=190f5950",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T16:26:23.630Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=c35a0473",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-05T16:33:05.460Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=b446d7b8",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/strategy/PRODUCT_MODEL.md b/docs/strategy/PRODUCT_MODEL.md
new file mode 100644
index 00000000..4016b12d
--- /dev/null
+++ b/docs/strategy/PRODUCT_MODEL.md
@@ -0,0 +1,43 @@
+# Modelo de Produto EGOS — SSOT
+
+> **Decisão Enio 2026-06-05:** um preço, um produto, vitalício, transparência radical.
+
+## Princípio
+
+Sem tiers. Sem planos. Sem feature gate.
+
+Um preço de entrada (começa em R$4, progressão ×2 quando subir). Quem paga, tem tudo — o que já existe E o que vai ser criado. Acesso vitalício. Reembolso disponível (quem sai, fica com o material que existia até a data de saída).
+
+"As pessoas bancam meus estudos e se beneficiam do que tenho pra falar e das ferramentas que crio."
+
+## O que está incluso (sem exceção)
+
+- Grupo WhatsApp privado EGOS (agente vivo + resumo diário 7h)
+- GPT próprio EGOS no ChatGPT (metaprompt configurado + MCP com todas as ferramentas do VPS)
+- Acesso a todos os metaprompts, tools (Guard Brasil, item-intake, etc.)
+- Roadmap honesto com status LIVE / WIP / CONCEPT
+- Participação em projetos que avançarem para receita (proporcional à colaboração)
+- Tudo que vier a ser criado enquanto membro
+
+## Transparência radical (regra)
+
+Nunca prometer o que é [CONCEPT]. Status de cada área publicado com honestidade:
+- 🟢 LIVE — funciona hoje
+- 🟡 WIP — em desenvolvimento
+- 🔵 CONCEPT — planejado, não iniciado
+
+## Preço
+
+Começa em R$4. Sobe por progressão ×2 (R$8 → R$16 → ...) sem data fixa.
+Quem já pagou: preço congelado para sempre.
+Reembolso: disponível; quem sai fica com o material até a data de saída.
+
+## Canais de acesso
+
+| Canal | Custo | Descrição |
+|-------|-------|-----------|
+| Telegram | Gratuito | Comunidade global, método aberto |
+| WhatsApp + GPT + MCP | R$4 (vitalício) | Produto completo |
+| IDE + SSOT (Claude Code) | Avançado | Para quem quer o modo profissional |
+
+*v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*

exec
/bin/bash -lc "sed -n '1,220p' docs/drafts/free-artifact-egos-v0.md && sed -n '1,120p' docs/strategy/PRODUCT_MODEL.md && git log --oneline -5" in /home/enio/egos
 succeeded in 0ms:
# EGOS — Artefato Gratuito v2 (iterado pelo aparato — aguarda Guarani + glance Enio)

> **Status:** v2 · **Criado:** 2026-06-05 · **Autor:** EGOS
> **R-PUB-001 (Flagship Public Artifact Gate):** Banda ✓ · Codex gpt-5.5 ✓ · Guarani/Gemini ⏳ (handoff enviado) · Glance Enio ⏳
> **NÃO PUBLICAR** até Guarani passar + Enio aprovar. Destino aprovado: README egos-governance + egos.ia.br (os dois).
> **Histórico:** v1 quase publicado sem iteração → ChatGPT achou melhorias → R-PUB-001 criada. v2 = merge v1+ChatGPT (via Codex gpt-5.5) + camada de identidade.

---

# PARTE 1 — Metaprompt: Assistente Profissional Governado

> **Como usar (2 min):** copie o bloco, cole no campo de instruções (ChatGPT) ou system prompt (Claude/Gemini), troque os `[colchetes]`.

```
Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.

Atua exclusivamente em:
- [Área 1]  - [Área 2]  - [Área 3]
Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."

── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
Fluxo obrigatório:
1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.

── CLASSIFICAÇÃO OBRIGATÓRIA ──
Classifique afirmações relevantes como:
- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
- NÃO SEI: base insuficiente  - AÇÃO: passo a executar

── ANTI-ALUCINAÇÃO ──
Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".

── PROTEÇÃO DE DADOS ──
Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.

── ZONA VERMELHA (pause antes) ──
Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.

── LIMITAÇÕES ──
Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."

── CRITÉRIO DE EVIDÊNCIA ──
Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.

── MODO DE RESPOSTA ──
Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.

── FORMATO DE SAÍDA ──
Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
Síntese: [resposta direta]
Evidências: [fontes/dados/base lógica]
Riscos: [se houver]
Próxima ação: [recomendação objetiva]

── REGRA FINAL ──
Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.
```

---

# PARTE 2 — Checklist: Segurança de IA em 1 Página

> Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.

- [ ] **Dado real só com necessidade** — "o LLM precisa deste dado ou posso descrever o padrão?"
- [ ] **PII mascarada antes de colar** — CPF/nome/processo → `[NOME]`, `[CPF]`, `[PROCESSO]`.
- [ ] **LLM externo ≠ ambiente sigiloso** — é servidor de terceiro; sigilo profissional → verifique ToS ou use modelo local.
- [ ] **Output de IA é INFERIDO** — número/data/citação gerada precisa de verificação independente antes de usar.
- [ ] **Nunca cole credenciais** — senhas, tokens, chaves, certificados, fora do prompt.
- [ ] **Histórico tem memória** — usou dado sensível? limpe depois; verifique se a conta não treina com seus dados.
- [ ] **Releia antes de publicar** — alucinação de IA é confiante; leia com o olho de quem recebe.

---

# PARTE 3 — O que é o EGOS (identidade + showcase)

> EGOS é um framework aberto de **governança para IA** — método, metaprompts e guardrails que funcionam hoje no ChatGPT, Claude e Gemini. Não é "mais um assistente": é a disciplina que faz a IA ser **auditável, honesta e segura**. O que está aqui é gratuito e pode ser usado direto.

**O método que você pode levar (compartilhável):**
- Protocolo de classificação de certeza (CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO)
- Protocolo Red Zone (pausa + confirmação humana antes de ação irreversível)
- Mascaramento PII/LGPD privacy-first (Guard Brasil)
- Evidence-first (afirmação sem prova = inválida) + eval comportamental (capacidade só é "real" com golden cases)
- Rituais de sessão `/start` (carrega contexto+regras) e `/end` (resume com evidência)
- Disciplina SSOT (uma fonte canônica por domínio) + safe-push (sem force-push cego)

> Se for útil, o repositório tem o método inteiro: **github.com/enioxt/egos-governance** · **egos.ia.br**

---

## Notas de produção (Enio)

**R-PUB-001 status:** Banda ✓ · Codex gpt-5.5 ✓ (mergeou metaprompt + curou showcase) · Guarani/Gemini ⏳ · Glance Enio ⏳

**🔴 NUNCA publicar (curado pelo Codex — interno):** biografia do Enio · PCMG/investigação/PII · caminhos `/home/enio/*` · VPS/portas/tokens/Supabase tenants · IDs de incidente não-sanitizados · esquemas WhatsApp de cliente. O showcase acima é só MÉTODO compartilhável.

**Pendência única após Guarani+glance:** publicar README egos-governance + seção egos.ia.br (passa Publication Gate R-UI-005 + visual proof).

*v2 — 2026-06-05 · iterado pelo aparato (Banda+Codex). Aguarda Guarani + HITL Enio.*
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

## Canais de acesso

| Canal | Custo | Descrição |
|-------|-------|-----------|
| Telegram | Gratuito | Comunidade global, método aberto |
| WhatsApp + GPT + MCP | R$4 (vitalício) | Produto completo |
| IDE + SSOT (Claude Code) | Avançado | Para quem quer o modo profissional |

*v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*
b446d7b8 feat(product): PRODUCT_MODEL.md — regra global sem tiers (R\$4 vitalicio + transparencia radical)
c35a0473 feat(product): arquitetura GPT próprio+MCP como entrada principal — tiers Telegram→WA→GPT+MCP→IDE
190f5950 fix(artifact): config tutor-first — UMA pergunta, infere pacote, propõe e confirma (UX Enio)
df318d68 docs(guarani): Guarani aprova artefato v2 — R-PUB-001 Banda✓ Codex✓ Guarani✓ (Enio glance pendente)
20cba0ba feat(product+artifact): R$4=WhatsApp grupo c/ agente vivo + config-protocol no metaprompt

exec
/bin/bash -lc "nl -ba TASKS.md | sed -n '10,28p'; nl -ba docs/strategy/PRODUCT_MODEL.md | sed -n '1,43p'; nl -ba docs/drafts/free-artifact-egos-v0.md | sed -n '15,40p'" in /home/enio/egos
 succeeded in 0ms:
    10	
    11	## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
    12	
    13	> Pricing R$4 (×2 progression) definido. WhatsApp = produto de entrada = acesso completo.
    14	> Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
    15	> PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
    16	
    17	- [ ] **GPT-EGOS-CUSTOM-001** [P0] `prime`+`hermes-ops` `gated:HITL` — Criar o GPT próprio EGOS no ChatGPT: (a) metaprompt = artefato v3 (free-artifact-egos-v0.md) com identidade EGOS completa; (b) MCP configurado apontando para egos.ia.br/mcp (bridge pública); (c) ferramentas expostas: Guard Brasil (scan PII), item-intake, metaprompts, knowledge base; (d) memória ChatGPT ativa; (e) link público para distribuir (quem tem o link = usa o agente). Smoke: usuário clica no link → GPT abre → MCP responde → tool funciona. Sem setup do usuário. HITL: Enio aprova metaprompt do GPT antes de publicar o link.
    18	- [ ] **MCP-EGOS-PUBLIC-001** [P1] `prime`+`forja` — Criar `packages/mcp-egos-public`: MCP server público que expõe as ferramentas do VPS para o GPT próprio e outros agentes externos. Tools: guard_check (scan PII), get_metaprompt (lista + busca), item_intake (foto → planilha), knowledge_search (busca na KB). Auth: token simples (gerado por compra/acesso). Deploy: egos.ia.br/mcp. Cada tool nova no VPS → adicionar ao mcp-egos-public → GPT tem acesso automaticamente. Documentar em docs/mcp/mcp-egos-public-spec.md.
    19	- [ ] **PRODUCT-TIERS-001** [P0] `prime` `gated:HITL` — Documentar pirâmide de acesso EGOS: (1) Telegram gratuito (comunidade global); (2) WhatsApp R$4 (agente vivo + grupo + resumo 7h); (3) GPT próprio + MCP (acesso completo às ferramentas do VPS — incluído no R$4 ou tier separado? Enio decide); (4) IDE + SSOT (modo profissional completo). SSOT: `docs/business/product-tiers.md`. Clarifica o que cada tier entrega e se GPT está no R$4 ou é tier separado.
    20	- [ ] **PRODUCT-R4-DEFINITION-001** [P0] `prime` — Documentar o que R$4 compra: acesso ao grupo WhatsApp EGOS (número +55 34 9793-4688 configurado como agente EGOS) + agente responde/interage 24h + resumo diário 7h automático + acesso completo a tudo (metaprompts, tools, roadmap). Telegram = gratuito/aberto/comunidade global. WhatsApp = pago/privado/agente vivo. SSOT: `docs/business/product-r4.md`.
    21	- [ ] **WA-EGOS-AGENT-GROUP-001** [P0] `prime`+`hermes-ops` — Configurar número +55 34 9793-4688 (Evolution API) como agente EGOS dentro do grupo WhatsApp privado: (a) conectar instância Evolution ao número; (b) apontar webhook para egos-gateway; (c) agente responde qualquer mensagem com capacidade completa (metaprompts+tools+EGOS identity); (d) cron 7h diário postando resumo do sistema (commits/avanços/status ou mensagem relevante conforme configurarmos); (e) smoke test: mandar mensagem no grupo → agente responde governado. Gate: Enio aprova configuração antes de ativar.
    22	- [ ] **ARTIFACT-CONFIG-PROTOCOL-001** [P1] `prime` — Adicionar bloco "CONFIGURAÇÃO INICIAL OBRIGATÓRIA" ao artefato gratuito v2 (metaprompt): quando há placeholders como [área]/[contexto], agente entra em modo de configuração, identifica gaps, faz perguntas objetivas por rodada, propõe HIPÓTESE quando possível, só passa ao modo operacional após confirmação. Insight da conversa ChatGPT 2026-06-05. Editar `docs/drafts/free-artifact-egos-v0.md` antes do glance do Enio.
    23	- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar formalmente: preço inicial R$4, progressão ×2 (R$4→R$8→R$16→...), produto = acesso ao grupo WhatsApp + tudo que temos. Criar/atualizar `docs/business/founding-pass/pricing-ledger.jsonl` com entrada datada. Também: documentar modelo de co-ownership (participantes colaboram com código/idéias e participam da receita quando projetos avançam). HITL: Enio valida ledger antes de qualquer divulgação.
    24	- [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
    25	- [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
    26	- [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
    27	- [ ] **AIOX-CASE-STUDY-001** [P2] `curador` — Extrair insights do PDF AIOX (João/Hero Base) aplicáveis ao EGOS: modelo publisher vs estúdio, escola para crescer ecossistema (Hero Academy → EGOS Academy), UGC monetization analogy (audiência→plataforma paga→criador recebe%), qualidade primeiro. Salvar em `docs/research/aiox-case-study-insights.md`.
    28	
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
    35	## Canais de acesso
    36	
    37	| Canal | Custo | Descrição |
    38	|-------|-------|-----------|
    39	| Telegram | Gratuito | Comunidade global, método aberto |
    40	| WhatsApp + GPT + MCP | R$4 (vitalício) | Produto completo |
    41	| IDE + SSOT (Claude Code) | Avançado | Para quem quer o modo profissional |
    42	
    43	*v1 — 2026-06-05 · Decisão Enio: sem tiers, um produto, transparência radical.*
    15	Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
    16	Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
    17	
    18	Atua exclusivamente em:
    19	- [Área 1]  - [Área 2]  - [Área 3]
    20	Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
    21	
    22	── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
    23	Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
    24	Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
    25	Fluxo obrigatório:
    26	1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
    27	2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
    28	3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
    29	4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
    30	NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
    31	
    32	── CLASSIFICAÇÃO OBRIGATÓRIA ──
    33	Classifique afirmações relevantes como:
    34	- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
    35	- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
    36	
    37	── ANTI-ALUCINAÇÃO ──
    38	Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
    39	Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
    40	Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".

codex
The patch introduces a contradictory P0 task relative to the newly added product model SSOT, which can lead future agents to produce conflicting product/pricing documentation. No runtime code issues were found in the diff.

Review comment:

- [P2] Remove the contradictory tier task — /home/enio/egos/TASKS.md:19-19
  This new P0 task conflicts with the product decision added in the same patch: `docs/strategy/PRODUCT_MODEL.md` says “Sem tiers” and includes “GPT próprio EGOS ... MCP” in the R$4 product, but this task asks to create a `product-tiers` SSOT and decide whether GPT is a separate tier. Agents working from `TASKS.md` will be directed to create pricing/access docs that contradict the new SSOT, so this should be reconciled or removed.
The patch introduces a contradictory P0 task relative to the newly added product model SSOT, which can lead future agents to produce conflicting product/pricing documentation. No runtime code issues were found in the diff.

Review comment:

- [P2] Remove the contradictory tier task — /home/enio/egos/TASKS.md:19-19
  This new P0 task conflicts with the product decision added in the same patch: `docs/strategy/PRODUCT_MODEL.md` says “Sem tiers” and includes “GPT próprio EGOS ... MCP” in the R$4 product, but this task asks to create a `product-tiers` SSOT and decide whether GPT is a separate tier. Agents working from `TASKS.md` will be directed to create pricing/access docs that contradict the new SSOT, so this should be reconciled or removed.
```
