# Codex Local Review — 2026-06-07T16:37:55Z

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
session id: 019ea2f2-be00-7d10-9f6f-25046f49fc3d
--------
user
changes against 'HEAD~3'
2026-06-07T16:37:58.944086Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T16:37:58.944108Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff e42773186e2adddae5ee439eb63830557acaca76 --stat && git diff e42773186e2adddae5ee439eb63830557acaca76' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/end.md                       | 27 +++++++++
 .claude/commands/start.md                     |  2 +
 TASKS.md                                      |  6 ++
 TASKS_ARCHIVE.md                              |  7 +++
 apps/egos-landing/public/timeline/rss         |  2 +-
 apps/egos-landing/public/timeline/rss.xml     |  2 +-
 docs/_current_handoffs/handoff_2026-06-07.md  | 82 +++++++++++++--------------
 docs/business/founding-pass/pricing-policy.md | 28 +++++----
 docs/personal-os/FOCUS_GATES.md               | 32 +++++++++++
 9 files changed, 132 insertions(+), 56 deletions(-)
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
diff --git a/.claude/commands/start.md b/.claude/commands/start.md
index ca04ab63..aef98e93 100644
--- a/.claude/commands/start.md
+++ b/.claude/commands/start.md
@@ -27,6 +27,8 @@ Você está executando `/start`. Sua obrigação:
 10. **MODE DETECTION:** Prompt com (`pesquisa`, `governança`, `leitura`, `revisão`, `auditoria`, `entender`, `só ler`) → `MODE=research` (executa só Layers `0.0+0+0.5+4.8+1+2+3+4+4.5+7`). Caso contrário → `MODE=write` (todas as layers). Declarar MODE como **primeiro campo** do checkpoint. Corte silencioso sem MODE = checkpoint inválido.
 12. **PERGUNTA OBRIGATÓRIA DE DIREÇÃO [T1 — Enio 2026-06-02, START-ASK-001]:** Todo `/start` DEVE terminar **perguntando ativamente ao Enio o que for necessário sobre os próximos passos** antes de executar qualquer trabalho — nunca auto-prosseguir. Use `AskUserQuestion` com opções+argumentos quando houver escolha de track/persona/forma-de-agir; pergunta aberta quando faltar contexto. O checkpoint (Layer 7) que **não** fecha com pergunta de direção = `/start` inválido. Enio elogiou explicitamente este comportamento e pediu persistência: "reforce mais ainda para toda as vezes que der /start obrigatoriamente você questionar o que for necessário sobre os próximos passos." Não confundir com pressa: descobrir o rumo certo > começar rápido no rumo errado.
 
+13. **NEW DIRECTION GATE [T1 — Enio 2026-06-07, A82]:** Se o Enio (ou qualquer agente, inclusive você) mencionar nova direção/insight/ideia/feature/refactor **durante a sessão** (não só no `/start`), **PARAR e executar `FOCUS_GATES.md §6b`** ANTES de engajar com o conteúdo da ideia: classificar REAL/CONCEPT/PHANTOM + DESCARTAR/ESTACIONAR/TESTAR/INTEGRAR/TROCAR-FOCO + 5 critérios. Vale para o entusiasmo do próprio Enio e para sugestões suas. A mesma confiança que descobre é a que dispersa — o gate confia em enforcement, não em força de vontade.
+
 ---
 
 ## LAYER 0.0 — Cross-Platform Sanity + Remote Staleness Check
diff --git a/TASKS.md b/TASKS.md
index b3c90be6..2bdb7e6d 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -8,6 +8,12 @@
 ---
 <!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
 
+## 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
+> Essência travada (code-validated): "fazer a IA provar o que afirma" = camada de verificação. Foco = MÉTODO (não vertical). Material = ensinar literacia de IA governada. Memory: `project_egos_purpose_convergence_2026-06-07`, `user_enio_mirroring_pattern_diluted_ego`. Gate A82 commitado (b9941031). PCMG: Enio assumiu (não-bloqueador). Preço cravado: R$4 ×2 único.
+- [ ] **COPY-PRICE-RECONCILE-001** [P1] `voz` `gated:HITL` — alinhar ~10 arquivos de copy pública (founding-pass/social-copy.md, posts-ready-to-publish.md, social-media/*, competitive-analysis.md) de R$2 → R$4 ×2 preço único. NÃO blastar com sed — passe de voz preservando argumentação, corte Enio antes de publicar.
+- [ ] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — experimento mínimo "validar os dois" (comunidade/material + setup assistido) COMEÇANDO DE GRAÇA (sem cobrança, sem PCMG risk): publicar artefato grátis (deploy landing HITL) → 1ª pessoa interessada vira teste de setup assistido gratuito → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
+- [ ] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — atualizar README p/ refletir a nova realidade (foco = método "IA que prova o que afirma" + literacia governada). Liga README-OVERHAUL-001. Só após preço/foco travados (já travados). HITL.
+
 ## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
 
 > Pricing R$4 (×2 progression) definido. WhatsApp = produto de entrada = acesso completo.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 710b4348..4ca7dea6 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3684,3 +3684,10 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
 - [x] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte. ✅ 2026-06-05
 
+
+## Archived 2026-06-07
+
+### 🎯 SESSÃO 2026-06-07 — Propósito convergido + foco + monetização (Banda+crítico+premortem)
+- [x] **NEW-DIRECTION-GATE-001** [P0] — FOCUS_GATES §6b + /start regra 13 — trava anti-espelho mid-session — `b9941031`
+- [x] **PRICING-R4-SSOT-001** [P1] — pricing-policy.md v1.1 alinhado R$4 ×2 preço único (corte Enio) — commit /end
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
diff --git a/docs/_current_handoffs/handoff_2026-06-07.md b/docs/_current_handoffs/handoff_2026-06-07.md
index 432db3f8..370093a3 100644
--- a/docs/_current_handoffs/handoff_2026-06-07.md
+++ b/docs/_current_handoffs/handoff_2026-06-07.md
@@ -1,51 +1,49 @@
-# Handoff — 2026-06-07 (continuação Opus pós-/start)
+# Handoff — 2026-06-07 (sessão de PROPÓSITO — supersede a continuação anterior)
+
+> Sessão de **investigação profunda de propósito** (Banda + crítico/Antigravity + premortem + 7 sondas de código). Saída: propósito convergido e VALIDADO NO CÓDIGO, gate anti-dispersão construído, monetização decidida.
+> Contexto anterior (mesmo dia): artefato grátis publicado no GitHub (`26055df`) + landing pronta (`f8e3c27d`, deploy pendente HITL). Continua válido abaixo.
 
 ## ✅ Accomplished (com SHAs)
-- Artefato grátis v3 — `21104bf2` — [free-artifact-egos-v0.md](../drafts/free-artifact-egos-v0.md): modo tutor separado do operacional + descoberta progressiva ("teste de 1 minuto" + caça-ao-tesouro p/ GitHub/site)
-- README egos-governance publicado — `26055df` (repo egos-governance, pushed) — seção "Comece aqui — grátis em 2 minutos" no topo (metaprompt + checklist + identidade)
-- Seção artefato na landing egos.ia.br — `f8e3c27d` — [App.tsx](../../apps/egos-landing/src/App.tsx): 3 cards (metaprompt+botão copiar, checklist 7 itens, O que é o EGOS+GitHub)
-- **Fix permanente do consent gate no visual proof** — `f8e3c27d` — [mcp-browser-automation/src/index.ts](../../packages/mcp-browser-automation/src/index.ts): `visual_proof_gate` seeda `egos_consent_v1` antes do goto (guarda por hostname EGOS). Provado em produção. Fim do improviso xvfb/dump-dom.
-- Caminho canônico de visual proof documentado — `f8e3c27d` — [pixel.md](../../.claude/agents/pixel.md): regra explícita (MCP p/ prod, visual-audit.ts p/ local; nunca xvfb)
-- Memória corrigida: `apps/egos-landing` é o app VIVO de egos.ia.br (decisão SITE-DECIDE-001 superada — confirmado via curl HTTP 200)
+- **New Direction Gate (A82)** — `b9941031` — FOCUS_GATES.md §6b + start.md regra 13. Trava mid-session: toda nova direção (insight do Enio / sugestão de IA) PARA e classifica REAL/CONCEPT/PHANTOM + DESCARTAR/ESTACIONAR/TESTAR/INTEGRAR/TROCAR-FOCO. Wiring mínimo (1 arquivo+1 linha), propagado ao mirror.
+- **Pricing SSOT R$4** — `pricing-policy.md` v1.1 (commit no /end) — entrada R$4, progressão ×2, preço único vitalício (corte Enio).
+- (anterior) Artefato grátis publicado GitHub `26055df` + landing `f8e3c27d` (deploy pendente HITL).
+
+## 🧠 Descoberta central (essência validada no código)
+- Padrão-raiz autodeclarado: **confiança/esperança radical → ferida → externaliza exigência de prova em código.** EGOS = esse padrão compilado.
+- Essência (code-validated, 460 commits govern|audit; eval-runner; provenance SHA-256): **"fazer a IA (e a si) provar o que afirma"** — camada de verificação em alta consequência. NÃO é "KB soberana" (genérico/recente/co-construído comigo = espelho que o código derrubou).
+- Foco = **MÉTODO domain-agnostic**, não vertical (vertical = armadilha do espelho). Material = ensinar literacia de IA governada. Semente = `free-artifact-egos-v0.md`.
+- SSOT memory: `project_egos_purpose_convergence_2026-06-07` + `user_enio_mirroring_pattern_diluted_ego`.
 
 ## 🔄 In Progress
-- FREE-ARTIFACT-GLANCE-001 — 95% — GitHub ✅ publicado; landing ✅ código pronto+provado local; **falta só deploy** (HITL Enio)
+- VALIDATE-BOTH-EXPERIMENT-001 — 0% — experimento mínimo grátis (publicar artefato + 1 pessoa setup grátis). Próximo: deploy landing (HITL).
 
-## ⏳ Blocked
-- Deploy egos.ia.br (`deploy.sh`) — aguarda corte Enio (outward-facing). Código commitado+provado local.
-- Guarani fidelity pass — handoff [PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md](PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md) commitado, aguarda passe do Guarani no Antigravity (assíncrono).
+## ⏳ Blocked / Decisões Enio pendentes
+- Deploy do artefato grátis na landing (`f8e3c27d` pronto) — aguarda HITL do Enio (deploy.sh nunca roda sem corte).
+- COPY-PRICE-RECONCILE-001 — ~10 arquivos de copy pública dizem R$2 → passe de voz + HITL (não auto-editado: Red Zone copy).
 
 ## 🔗 Next Steps (priority order)
-1. [FREE-ARTIFACT-GLANCE-001] Deploy egos.ia.br via `cd apps/egos-landing && bash deploy.sh` (HITL Enio) → fecha a task
-2. [COURSE-PCMG-GATE-001] P0 — estatuto PCMG sobre pagamento PF (Red Zone)
-3. [GPT-EGOS-CUSTOM-001] P0 — GPT próprio + MCP (após MCP-EGOS-PUBLIC-001)
-4. [EPOS-RECONCILE-B1-001] P2 — reconciliar numeração B1 (A81 travamento + A82 horizonte ambos capturados vs SELF_MAPPING canonical)
+1. **VALIDATE-BOTH-EXPERIMENT-001** [P0] — deploy artefato grátis + achar 1ª pessoa real → medir flow (acende ou drena?).
+2. **COPY-PRICE-RECONCILE-001** [P1] — voz alinha copy R$2→R$4 ×2.
+3. **README-FOCUS-REFLECT-001** [P1] — README reflete o foco novo (método "IA que prova o que afirma").
 
 ## 🌐 Environment State
-- Build: ✅ (landing tsc 0 erros + vite OK; MCP fix typecheck OK)
-- Visual proof: ✅ seção renderiza limpa, botão copiar funciona (clipboard 3716 chars + "Copiado!" ~100ms), console limpo
-- Deploy: egos.ia.br healthy (HTTP 200) — seção NÃO deployada ainda (aguarda HITL)
-- Dispersão saída: 🔴 102 scopes/7d (generativa — sessão foi 100% foco no artefato)
-
-## 📌 Decisions Made (architectural)
-- Consent gate: seed condicionado a domínios EGOS (não github) — escolhi guarda por hostname em vez de seedar tudo (Codex item 6); timestamp fresh por chamada (item 10)
-- SSRF: NÃO abri allowlist do MCP p/ localhost (risco SSRF) — caminho local usa visual-audit.ts (script de dev, não exposto à rede)
-- egos-landing (não egos-site) é o app vivo de egos.ia.br — SITE-DECIDE-001 superada (reconstrução com copy do pivô)
-
-## ✅ Todos da sessão (snapshot)
-- [x] /start v6.14 completo + EPOS B1-Q4 (A82) + memória site corrigida
-- [x] Artefato v3 (modo tutor + descoberta progressiva) — 21104bf2
-- [x] README egos-governance publicado — 26055df
-- [x] Seção landing (pixel Sonnet) + visual proof — f8e3c27d
-- [x] Codex review REPROVADO → 4 fixes aplicados+provados — f8e3c27d
-- [x] Fix consent gate no MCP + doc pixel.md — f8e3c27d
-- [/] FREE-ARTIFACT-GLANCE-001 — falta deploy (HITL Enio)
-
-## 🚫 Marked [CONCEPT]
-- Guarani fidelity pass — handoff pronto, passe ainda não executado no Antigravity
-- Deploy landing — código pronto, não deployado
-
-## 🔬 Aparato multi-agente usado
-- Pixel (Sonnet) → implementou seção + visual proof
-- Codex (gpt-5.5) → review adversarial REPROVADO → 4 achados corrigidos+re-provados
-- Guarani (Gemini/Antigravity) → aprovou conteúdo (df318d68) + handoff fidelidade pendente
+- Build: N/A (sessão docs/governança) | Tests: N/A
+- HEAD: `b9941031` + pricing-policy/TASKS/handoff uncommitted (commit no /end) | AHEAD origin: 1→push
+- Dispersão saída: 🔴 103 scopes/334 commits 7d — mas a sessão CONCENTROU (descoberta de propósito, não ruído). A-stale 2d.
+
+## 📌 Decisions Made
+- **PCMG (COURSE-PCMG-GATE-001)** — corte Enio: NÃO é bloqueador. "Material meu, muitos policiais têm cursos." Vetor magistério. Decisão dele sobre o próprio risco (não verificação jurídica minha). Pode cobrar.
+- **Preço** — R$4 ×2 preço único vitalício (escolhido sobre R$2/R$8).
+- **Monetização** — "validar os dois" (comunidade/material + setup assistido) com experimento mínimo grátis. SaaS rejeitado como 1º caminho (rende menos agora).
+- **Gate anti-dispersão** — 1 arquivo + 1 linha = 80%; NÃO replicar em 5 superfícies (seria a própria dispersão).
+
+## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
+- "Esperança sistematizada" — tese capturada (memory), não virou doc pesado (anti-rabbit-hole).
+- GPT custom, grupo WhatsApp, cursos gravados — não prometer (não existem ainda).
+
+## ✅ Todos da sessão
+- [x] Investigação de propósito (forense + Banda + crítico + premortem)
+- [x] Validação da essência no código (4 sondas)
+- [x] New Direction Gate construído + commitado
+- [x] Monetização decidida + preço cravado + SSOT alinhado
+- [/] Experimento mínimo — definido, execução pendente (HITL deploy)
diff --git a/docs/business/founding-pass/pricing-policy.md b/docs/business/founding-pass/pricing-policy.md
index 5c03d5a8..c6341955 100644
--- a/docs/business/founding-pass/pricing-policy.md
+++ b/docs/business/founding-pass/pricing-policy.md
@@ -1,6 +1,6 @@
 # EGOS Framework — Política de Preço Fundador
 
-**Versão:** 1.0 | **Data:** 2026-06-04 | **Status:** Ativo — Lote 1 (R$2)
+**Versão:** 1.1 | **Data:** 2026-06-07 | **Status:** Ativo — Lote 1 (R$4)
 **SSOT:** `docs/business/founding-pass/pricing-policy.md`
 **Relacionado:** `docs/business/founding-pass/distribution-strategy-2026.md`
 
@@ -24,13 +24,15 @@ O Preço Fundador não é desconto. É o preço real do momento atual, com trans
 
 | Lote | Preco | Sinal de revisao | Status |
 |------|-------|------------------|--------|
-| Lote 1 | R$2 | ~5 vendas no lote atual | **ATIVO** |
-| Lote 2 | R$4 | ~5 vendas no lote atual | Pendente HITL |
-| Lote 3 | R$8 | ~5 vendas no lote atual | Pendente HITL |
-| Lote 4 | R$16 | ~5 vendas no lote atual | Pendente HITL |
-| Lote 5 | R$32 | ~5 vendas no lote atual | Pendente HITL |
-| Lote 6 | R$64 | ~5 vendas no lote atual | Pendente HITL |
-| Lote 7 | R$128 | Avaliacao aberta | Pendente HITL |
+| Lote 1 | R$4 | ~5 vendas no lote atual | **ATIVO** |
+| Lote 2 | R$8 | ~5 vendas no lote atual | Pendente HITL |
+| Lote 3 | R$16 | ~5 vendas no lote atual | Pendente HITL |
+| Lote 4 | R$32 | ~5 vendas no lote atual | Pendente HITL |
+| Lote 5 | R$64 | ~5 vendas no lote atual | Pendente HITL |
+| Lote 6 | R$128 | ~5 vendas no lote atual | Pendente HITL |
+| Lote 7 | R$256 | Avaliacao aberta | Pendente HITL |
+
+**Regra de progressão (corte Enio 2026-06-07):** entrada **R$4**, multiplica **×2** a cada lote. **Preço único** — o que muda é o lote/tempo, NÃO a quantidade de material. Quem entra paga o preço do momento e mantém para sempre o que comprou; o acesso é vitalício a tudo (PRODUCT_MODEL.md).
 
 **Nota de leitura da tabela:**
 
@@ -129,7 +131,7 @@ O preco nao e funcao matematica do numero de vendas. Ele reflete:
 - Enio pode pular um lote se o conteudo evoluiu mais rapido do que as vendas indicariam.
 
 **Compromisso com quem ja comprou:**
-- Quem comprou no Lote 1 paga R$2. Sempre. Para o que ja comprou.
+- Quem comprou no Lote 1 paga R$4. Sempre. Para o que ja comprou.
 - Subidas de preco nao retroagem.
 
 ---
@@ -138,11 +140,11 @@ O preco nao e funcao matematica do numero de vendas. Ele reflete:
 
 Para uso em paginas de venda, posts de lancamento e comunicacao direta:
 
-> "O preco do EGOS Framework começa em R$2 para os primeiros compradores e sobe conforme o conteudo evolui. Toda subida e anunciada com antecedencia e o preco anterior e sempre informado. Quem entra primeiro, paga menos — agora e sempre."
+> "O preco do EGOS Framework começa em R$4 para os primeiros compradores e dobra a cada lote conforme o conteudo evolui. Toda subida e anunciada com antecedencia e o preco anterior e sempre informado. Quem entra primeiro, paga menos — agora e sempre. Preco unico: o acesso e ao todo, vitalicio."
 
 Variacao curta (para post/story):
 
-> "R$2 agora. Sobe quando o conteudo cresce. Sem pegadinha."
+> "R$4 agora, dobra a cada lote. Acesso vitalicio a tudo. Sem pegadinha."
 
 ---
 
@@ -194,13 +196,15 @@ DATA | LOTE | PRECO_ANTERIOR | PRECO_NOVO | VENDAS_NO_LOTE | MOTIVO_SINTETICO |
 
 | Data | Lote | Preco anterior | Preco novo | Vendas no lote | Motivo | Decisor |
 |------|------|----------------|------------|----------------|--------|---------|
-| 2026-06-04 | Lote 1 | — | R$2 | 0 | Lancamento inicial, circulo direto | Enio |
+| 2026-06-04 | Lote 1 | — | R$2 | 0 | Lancamento inicial, circulo direto (nunca vendeu) | Enio |
+| 2026-06-07 | Lote 1 | R$2 | R$4 | 0 | Corte Enio: entrada R$4, progressao x2, preco unico vitalicio. R$2 nunca foi vendido | Enio |
 
 ---
 
 ## Notas de versao
 
 - **v1.0 (2026-06-04):** Documento criado. Politica inicial definida para lancamento no circulo direto (X.com, Instagram). Lote 1 ativo a R$2.
+- **v1.1 (2026-06-07):** Corte Enio — entrada movida para **R$4**, progressao **x2** por lote, **preco unico** (acesso vitalicio a tudo; nao varia por quantidade de material). R$2 nunca foi vendido. Copy publica de marketing (founding-pass/social-copy, posts, social-media/*) ainda menciona R$2 → pendente passe de voz + HITL para alinhar a R$4 (NÃO alterada automaticamente por ser copy publica = Red Zone).
 
 ---
 
diff --git a/docs/personal-os/FOCUS_GATES.md b/docs/personal-os/FOCUS_GATES.md
index e8770daa..ec8c81dc 100644
--- a/docs/personal-os/FOCUS_GATES.md
+++ b/docs/personal-os/FOCUS_GATES.md
@@ -155,6 +155,38 @@ created: 2026-05-08
 
 ---
 
+## §6b. New Direction Gate — mid-session (A82, 2026-06-07)
+
+> **Origem:** sessão de propósito 2026-06-07. Padrão-raiz do Enio: confiança/esperança RADICAL → espelha entusiasmo (do amigo, do insight, da IA) e vira aquilo → dispersão (102 scopes, 6 pivôs, R$0). Ver `memory/user_enio_mirroring_pattern_diluted_ego.md`. O PIG (§6) pega "projeto novo / git init"; este pega o **insight no meio da conversa**, que não tem git init nem nome formal.
+
+**Dispara quando** (mid-session, sem git init, sem nome de projeto):
+- Enio diz "e se a gente...?", "vi uma coisa interessante", "um amigo sugeriu/começou", "a IA me falou", "podíamos também"
+- Qualquer agente (inclusive eu) propõe direção/feature/refactor fora do foco ativo
+- Entusiasmo súbito por domínio/ferramenta nova no meio de outro trabalho
+
+**Ação — PARAR antes de engajar com o CONTEÚDO da ideia.** Classificar como claim não-verificado (REAL/CONCEPT/PHANTOM) e exigir resposta aos 5 critérios. Uma pergunta por vez se faltar clareza:
+1. **Foco atual:** qual é o Single Pursuit/trabalho ativo agora?
+2. **Custo de oportunidade:** o que PARA se eu seguir isto?
+3. **Critério de sucesso:** como sei que funcionou (verificável)?
+4. **Gatilho de descarte:** o que faz isto ser abandonado?
+5. **Classificação obrigatória:**
+
+| Categoria | Significado | Ação |
+|---|---|---|
+| **DESCARTAR** | sem relação com o foco | registrar 1 linha e seguir |
+| **ESTACIONAR** | útil depois, não agora | vira task `[ ] backlog`, não toca código |
+| **TESTAR** | merece experimento pequeno e limitado | → §6 Phase 1 + limite de tempo explícito |
+| **INTEGRAR** | apoia diretamente o foco atual | segue, com critério de aceite |
+| **TROCAR-FOCO** | justifica substituir o Single Pursuit | **Red Zone estratégica** → §5 + confirmação explícita do Enio: "li e entendi que isto pausa [X]; confirmo porque [justificativa]" |
+
+**Regra de ouro (Enio 2026-06-07):** *a mesma confiança que faz o Enio descobrir é a que o dispersa. O gate não confia em força de vontade — confia em enforcement.* Vale inclusive para o entusiasmo DELE e para sugestões MINHAS.
+
+**Não matar criatividade:** o gate separa insight real de distração; não proíbe explorar. DESCARTAR/ESTACIONAR custam 1 linha; só TROCAR-FOCO trava de verdade.
+
+**Wiring mínimo (anti-meta-trabalho):** este gate vive AQUI (1 arquivo) + 1 linha de trigger em `/start` regra 12. **NÃO** replicar em pre-commit/end/Hermes/agentes — replicar em 5 superfícies seria a própria dispersão que ele bloqueia (lição §7).
+
+---
+
 ## §7. Status de persistência real (auditoria 2026-05-08)
 
 | Regra | ~/.claude/CLAUDE.md | pre-commit | /start Layer 0 | /end | egos-gateway | hermes-egos | Outros repos |

exec
/bin/bash -lc "git status --short && git log --oneline -5 && nl -ba docs/_current_handoffs/handoff_2026-06-07.md | sed -n '25,38p' && nl -ba TASKS_ARCHIVE.md | tail -20 && nl -ba docs/personal-os/FOCUS_GATES.md | sed -n '180,195p'" in /home/enio/egos
 succeeded in 0ms:
 M apps/egos-landing/public/timeline/rss
 M apps/egos-landing/public/timeline/rss.xml
?? docs/jobs/2026-06-07-pre-commit-pipeline.json
6896a0cb feat(end): Phase 8.5 Subagent Intelligence Harvest (END-HARVEST-001)
97093134 chore(end): session close 2026-06-07 — propósito convergido + validado no código
b9941031 feat(focus): New Direction Gate mid-session (A82) — trava anti-espelho/dispersão
e4277318 chore(end): session close 2026-06-07 — artefato grátis publicado (GitHub✓ landing pronto) + fix consent gate
f8e3c27d feat(landing+mcp): seção artefato grátis em egos.ia.br + fix permanente do consent gate no visual proof
    25	1. **VALIDATE-BOTH-EXPERIMENT-001** [P0] — deploy artefato grátis + achar 1ª pessoa real → medir flow (acende ou drena?).
    26	2. **COPY-PRICE-RECONCILE-001** [P1] — voz alinha copy R$2→R$4 ×2.
    27	3. **README-FOCUS-REFLECT-001** [P1] — README reflete o foco novo (método "IA que prova o que afirma").
    28	
    29	## 🌐 Environment State
    30	- Build: N/A (sessão docs/governança) | Tests: N/A
    31	- HEAD: `b9941031` + pricing-policy/TASKS/handoff uncommitted (commit no /end) | AHEAD origin: 1→push
    32	- Dispersão saída: 🔴 103 scopes/334 commits 7d — mas a sessão CONCENTROU (descoberta de propósito, não ruído). A-stale 2d.
    33	
    34	## 📌 Decisions Made
    35	- **PCMG (COURSE-PCMG-GATE-001)** — corte Enio: NÃO é bloqueador. "Material meu, muitos policiais têm cursos." Vetor magistério. Decisão dele sobre o próprio risco (não verificação jurídica minha). Pode cobrar.
    36	- **Preço** — R$4 ×2 preço único vitalício (escolhido sobre R$2/R$8).
    37	- **Monetização** — "validar os dois" (comunidade/material + setup assistido) com experimento mínimo grátis. SaaS rejeitado como 1º caminho (rende menos agora).
    38	- **Gate anti-dispersão** — 1 arquivo + 1 linha = 80%; NÃO replicar em 5 superfícies (seria a própria dispersão).
  3674	
  3675	## Archived 2026-06-05
  3676	
  3677	### 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
  3678	- [x] **ARTIFACT-CONFIG-PROTOCOL-001** [P1] `prime` — FEITO `190f5950`: bloco tutor-first adicionado ao metaprompt (uma pergunta → infere pacote → propõe → confirma). Free artifact v2 aprovado pelo aparato (Banda+Codex+Guarani). Aguarda apenas glance Enio (FREE-ARTIFACT-GLANCE-001).
  3679	- [x] **PRODUCT-NO-TIER-RULE-001** [P0] `prime` — FEITO `b446d7b8`: regra global documentada em `docs/strategy/PRODUCT_MODEL.md` — um preço (R$4), um produto, vitalício, reembolso mantém material, transparência radical (LIVE/WIP/CONCEPT). Co-criação com participação proporcional em receita.
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
   180	| **TROCAR-FOCO** | justifica substituir o Single Pursuit | **Red Zone estratégica** → §5 + confirmação explícita do Enio: "li e entendi que isto pausa [X]; confirmo porque [justificativa]" |
   181	
   182	**Regra de ouro (Enio 2026-06-07):** *a mesma confiança que faz o Enio descobrir é a que o dispersa. O gate não confia em força de vontade — confia em enforcement.* Vale inclusive para o entusiasmo DELE e para sugestões MINHAS.
   183	
   184	**Não matar criatividade:** o gate separa insight real de distração; não proíbe explorar. DESCARTAR/ESTACIONAR custam 1 linha; só TROCAR-FOCO trava de verdade.
   185	
   186	**Wiring mínimo (anti-meta-trabalho):** este gate vive AQUI (1 arquivo) + 1 linha de trigger em `/start` regra 12. **NÃO** replicar em pre-commit/end/Hermes/agentes — replicar em 5 superfícies seria a própria dispersão que ele bloqueia (lição §7).
   187	
   188	---
   189	
   190	## §7. Status de persistência real (auditoria 2026-05-08)
   191	
   192	| Regra | ~/.claude/CLAUDE.md | pre-commit | /start Layer 0 | /end | egos-gateway | hermes-egos | Outros repos |
   193	|---|---|---|---|---|---|---|---|
   194	| Visual Proof Gate | ✅ §0.5 | ✅ §0.7 | ✅ Layer 0 | ✅ Phase 11.5 | ❌ | ❌ | ✅ 9 repos script |
   195	| Banned Absolutes (A53) | ✅ §1 | ✅ §0.75 warn | ✅ karpathy §0 | ❌ | ✅ buildSystemPrompt | ✅ CLAUDE.md | ✅ 9 repos script |

exec
/bin/bash -lc "nl -ba .claude/commands/start.md | sed -n '22,35p' && nl -ba docs/business/founding-pass/pricing-policy.md | sed -n '20,40p' && nl -ba .claude/commands/end.md | sed -n '630,645p'" in /home/enio/egos
 succeeded in 0ms:
    22	6. **"Próximos passos" = reconciliar 3 fontes** (Layer 4.5): handoff.next ⨯ últimos commit-subjects ⨯ TASKS. Se um `feat:` recente nomeia doc/task que o handoff não cita → esse é o fio da meada (LER + surfaçar). Pode ser P1/`research`. Nunca só grep P0; nunca surfaçar handoff.next já-feito (START-RECONCILE-001).
    23	7. **§4.8 OBRIGATÓRIO:** Layer 4.8 DEVE ser executada com Bash tool — rodar `scripts/codex-usage.ts --json` e reportar quota real. Citar sem rodar = checkpoint inválido (Bug v6.9).
    24	8. **MODELO PADRÃO SONNET 4.6:** Se você é Opus 4.7, avalie cada task via [MODEL_DELEGATION_POLICY](../../docs/governance/MODEL_DELEGATION_POLICY.md). Opus orquestra, Sonnet executa, Haiku faz mecânico. Reportar modelo atual + delegação no checkpoint.
    25	9. **SWARM COMMIT POLICY:** Quando 1+ `Agent` em background, **NÃO fazer git commit incremental** — race condition. Commit consolidado final. SSOT: [SWARM_COMMIT_POLICY](../../docs/governance/SWARM_COMMIT_POLICY.md).
    26	11. **RESOLVER DOCTRINE [T1]:** Você é EGOS Prime, a última camada — se algo para na sua porta, você resolve (não recua, não culpa subagente: erro de subagente = falha de orquestração sua). Todo achado da sessão passa por **triagem matemática** `R = L/C` antes de parar o trabalho atual: RESOLVE NOW (barato+alta alavancagem) ou TASK com prioridade derivada de L. Red Zone nunca auto-resolve. SSOT: [RESOLVER_DOCTRINE](../../docs/governance/RESOLVER_DOCTRINE.md).
    27	10. **MODE DETECTION:** Prompt com (`pesquisa`, `governança`, `leitura`, `revisão`, `auditoria`, `entender`, `só ler`) → `MODE=research` (executa só Layers `0.0+0+0.5+4.8+1+2+3+4+4.5+7`). Caso contrário → `MODE=write` (todas as layers). Declarar MODE como **primeiro campo** do checkpoint. Corte silencioso sem MODE = checkpoint inválido.
    28	12. **PERGUNTA OBRIGATÓRIA DE DIREÇÃO [T1 — Enio 2026-06-02, START-ASK-001]:** Todo `/start` DEVE terminar **perguntando ativamente ao Enio o que for necessário sobre os próximos passos** antes de executar qualquer trabalho — nunca auto-prosseguir. Use `AskUserQuestion` com opções+argumentos quando houver escolha de track/persona/forma-de-agir; pergunta aberta quando faltar contexto. O checkpoint (Layer 7) que **não** fecha com pergunta de direção = `/start` inválido. Enio elogiou explicitamente este comportamento e pediu persistência: "reforce mais ainda para toda as vezes que der /start obrigatoriamente você questionar o que for necessário sobre os próximos passos." Não confundir com pressa: descobrir o rumo certo > começar rápido no rumo errado.
    29	
    30	13. **NEW DIRECTION GATE [T1 — Enio 2026-06-07, A82]:** Se o Enio (ou qualquer agente, inclusive você) mencionar nova direção/insight/ideia/feature/refactor **durante a sessão** (não só no `/start`), **PARAR e executar `FOCUS_GATES.md §6b`** ANTES de engajar com o conteúdo da ideia: classificar REAL/CONCEPT/PHANTOM + DESCARTAR/ESTACIONAR/TESTAR/INTEGRAR/TROCAR-FOCO + 5 critérios. Vale para o entusiasmo do próprio Enio e para sugestões suas. A mesma confiança que descobre é a que dispersa — o gate confia em enforcement, não em força de vontade.
    31	
    32	---
    33	
    34	## LAYER 0.0 — Cross-Platform Sanity + Remote Staleness Check
    35	
    20	
    21	---
    22	
    23	## 2. Tabela de Progressão
    24	
    25	| Lote | Preco | Sinal de revisao | Status |
    26	|------|-------|------------------|--------|
    27	| Lote 1 | R$4 | ~5 vendas no lote atual | **ATIVO** |
    28	| Lote 2 | R$8 | ~5 vendas no lote atual | Pendente HITL |
    29	| Lote 3 | R$16 | ~5 vendas no lote atual | Pendente HITL |
    30	| Lote 4 | R$32 | ~5 vendas no lote atual | Pendente HITL |
    31	| Lote 5 | R$64 | ~5 vendas no lote atual | Pendente HITL |
    32	| Lote 6 | R$128 | ~5 vendas no lote atual | Pendente HITL |
    33	| Lote 7 | R$256 | Avaliacao aberta | Pendente HITL |
    34	
    35	**Regra de progressão (corte Enio 2026-06-07):** entrada **R$4**, multiplica **×2** a cada lote. **Preço único** — o que muda é o lote/tempo, NÃO a quantidade de material. Quem entra paga o preço do momento e mantém para sempre o que comprou; o acesso é vitalício a tudo (PRODUCT_MODEL.md).
    36	
    37	**Nota de leitura da tabela:**
    38	
    39	- "~5 vendas" e "sinal de revisao" — o sistema PODE informar quando esse numero for atingido. A decisao de subir o preco e sempre do Enio.
    40	- Lote 7 (R$128) nao tem sinal numerico fixo. A revisao e aberta e depende de avaliacao qualitativa.
   630	4. Atualizar MEMORY.md index.
   631	
   632	**Output obrigatório:**
   633	```
   634	INTELLIGENCE HARVEST
   635	====================
   636	Subagentes na sessão: [N]
   637	  - [sonda] → JÁ-EM-CÓDIGO / CONCLUSÃO-EM-MEMORY / SÓ-NO-TRANSCRIPT
   638	Harvested: [arquivo(s) criado(s) p/ os SÓ-NO-TRANSCRIPT valiosos]
   639	Afirmação: "Nenhuma inteligência de subagente com valor de referência ficou só no transcript."
   640	```
   641	
   642	**Skip:** sessão sem subagente OU todo output já virou código/memory → "Phase 8.5: skip — sem inteligência órfã".
   643	
   644	---
   645	

codex
The patch updates canonical operational/pricing documentation but leaves conflicting pricing text and stale handoff/task evidence. These are actionable documentation correctness issues that can mislead the next agent or downstream public copy work.

Full review comments:

- [P2] Keep the Lote 7 note in sync with the new price — /home/enio/egos/docs/business/founding-pass/pricing-policy.md:33-33
  After moving the progression to start at R$4, this changed row makes Lote 7 R$256, but the note immediately below still says `Lote 7 (R$128)`. In the pricing SSOT this leaves two conflicting canonical prices for the same lot, so downstream copy or sales decisions can pick the wrong value.

- [P2] Replace stale handoff HEAD state with the committed state — /home/enio/egos/docs/_current_handoffs/handoff_2026-06-07.md:31-31
  This handoff now lives after the `/end` commit, but it still tells the next session that HEAD is `b9941031` and that pricing/TASKS/handoff are uncommitted. A future agent following this handoff will reconcile from the wrong commit state and may waste time looking for already-committed work or push the wrong ahead count.

- [P2] Add verifiable evidence to the archived completed task — /home/enio/egos/TASKS_ARCHIVE.md:3692-3692
  This marks `PRICING-R4-SSOT-001` as done with only `commit /end`, which is not a reproducible evidence anchor. The repo rules require `[x]` tasks to carry verifiable evidence such as the SHA or artifact, and the actual commit exists, so this should cite it instead of a placeholder to avoid a phantom-done entry.
The patch updates canonical operational/pricing documentation but leaves conflicting pricing text and stale handoff/task evidence. These are actionable documentation correctness issues that can mislead the next agent or downstream public copy work.

Full review comments:

- [P2] Keep the Lote 7 note in sync with the new price — /home/enio/egos/docs/business/founding-pass/pricing-policy.md:33-33
  After moving the progression to start at R$4, this changed row makes Lote 7 R$256, but the note immediately below still says `Lote 7 (R$128)`. In the pricing SSOT this leaves two conflicting canonical prices for the same lot, so downstream copy or sales decisions can pick the wrong value.

- [P2] Replace stale handoff HEAD state with the committed state — /home/enio/egos/docs/_current_handoffs/handoff_2026-06-07.md:31-31
  This handoff now lives after the `/end` commit, but it still tells the next session that HEAD is `b9941031` and that pricing/TASKS/handoff are uncommitted. A future agent following this handoff will reconcile from the wrong commit state and may waste time looking for already-committed work or push the wrong ahead count.

- [P2] Add verifiable evidence to the archived completed task — /home/enio/egos/TASKS_ARCHIVE.md:3692-3692
  This marks `PRICING-R4-SSOT-001` as done with only `commit /end`, which is not a reproducible evidence anchor. The repo rules require `[x]` tasks to carry verifiable evidence such as the SHA or artifact, and the actual commit exists, so this should cite it instead of a placeholder to avoid a phantom-done entry.
```
