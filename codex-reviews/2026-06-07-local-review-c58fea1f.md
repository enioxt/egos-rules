# Codex Local Review — 2026-06-07T17:00:38Z

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
session id: 019ea307-80cf-7210-966b-262a85cb2b42
--------
user
changes against 'HEAD~3'
2026-06-07T17:00:42.333281Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T17:00:42.333288Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff b9941031c60f8a6391a65729daa05256d6e8aef7 --stat && git diff b9941031c60f8a6391a65729daa05256d6e8aef7' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/end.md                       |  27 +++++++
 TASKS.md                                      |   6 ++
 TASKS_ARCHIVE.md                              |   7 ++
 apps/egos-landing/public/timeline/rss         |   2 +-
 apps/egos-landing/public/timeline/rss.xml     |   2 +-
 docs/_current_handoffs/handoff_2026-06-07.md  |  82 ++++++++++----------
 docs/business/founding-pass/pricing-policy.md |  28 ++++---
 docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md  | 107 ++++++++++++++++++++++++++
 8 files changed, 205 insertions(+), 56 deletions(-)
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

exec
/bin/bash -lc 'ls docs/strategy; test -f docs/strategy/PRODUCT_MODEL.md; echo product_strategy=$?; test -f docs/PRODUCT_MODEL.md; echo product_docs=$?; test -f docs/GTM_SSOT.md; echo gtm_docs=$?; test -f docs/strategy/GTM_SSOT.md; echo gtm_strategy=$?; find docs -maxdepth 3 -name '"'PRODUCT_MODEL.md' -o -name 'GTM_SSOT.md'" in /home/enio/egos
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
product_strategy=0
product_docs=1
gtm_docs=0
gtm_strategy=1
docs/strategy/PRODUCT_MODEL.md
docs/GTM_SSOT.md

exec
/bin/bash -lc "ls -ld memory MEMORY.md 2>/dev/null || true; find . -maxdepth 2 -name MEMORY.md -o -type d -name memory | sed 's#"'^./##'"' | head -20" in /home/enio/egos
 succeeded in 0ms:
exec
/bin/bash -lc "grep -n \"MEMORY\\|memory/\" -n .claude/commands/end.md | head -40" in /home/enio/egos
 succeeded in 0ms:
584:**Crie `~/.claude/projects/-home-enio-egos/memory/session_YYYY-MM-DD_[topic].md`:**
608:**Update MEMORY.md index** (linha única <200 chars):
628:2. Para cada um, triar: **JÁ-EM-CÓDIGO** (virou commit → ok) · **CONCLUSÃO-JÁ-EM-MEMORY** (a decisão está salva, mas e a evidência?) · **SÓ-NO-TRANSCRIPT** (perde no próximo chat).
629:3. Para os **SÓ-NO-TRANSCRIPT** com valor de referência → **condensar** (não colar inteiro — anti-bloat) num arquivo `type: reference` em `memory/session_YYYY-MM-DD_intelligence-*.md` (tabelas-chave + números + paths) OU, se >20K e operacional, `docs/jobs/YYYY-MM-DD-*.md`. Linkar `[[conclusão]]`.
630:4. Atualizar MEMORY.md index.
637:  - [sonda] → JÁ-EM-CÓDIGO / CONCLUSÃO-EM-MEMORY / SÓ-NO-TRANSCRIPT
733:  ✓ MEMORY.md index updated: ✅

exec
/bin/bash -lc "nl -ba .claude/commands/end.md | sed -n '572,635p'" in /home/enio/egos
 succeeded in 0ms:
   572	  -d '{"domain":"<dom>","outcome":"<out>","description":"<learning>","session_id":"'$(date +%Y%m%d)'"}'
   573	```
   574	
   575	### 8.2 — (REMOVIDO 2026-05-29) Obsidian/wiki-compile retirado
   576	
   577	> Camada Obsidian vault aposentada (Opção B — 2026-05-29). Vault local estava morto
   578	> (0 edições em 7d, cron `daily-knowledge-sync` falhando há semanas com `bun: command not found`).
   579	> Conhecimento vive em: Supabase `kb_pages` (via Phase 8.1 `record_learning`) + NotebookLM (síntese sob demanda).
   580	> `wiki-compiler.ts` permanece como ferramenta manual do Supabase (`bun run wiki:compile`), apenas não é mais auto-invocado.
   581	
   582	### 8.3 — Memory write OBRIGATÓRIO
   583	
   584	**Crie `~/.claude/projects/-home-enio-egos/memory/session_YYYY-MM-DD_[topic].md`:**
   585	
   586	```markdown
   587	---
   588	name: [Título curto da sessão]
   589	description: [1 linha — usada para decidir relevância em sessões futuras]
   590	type: project
   591	originSessionId: [hash atual]
   592	---
   593	[Topic principal] — 1-2 linhas
   594	
   595	**Real changes (com SHAs):**
   596	- [SHA] [arquivo] — [o que mudou e por quê]
   597	
   598	**Decisões arquiteturais:**
   599	- [decisão] — [motivo]
   600	
   601	**Blockers ativos:**
   602	- [blocker] — [próximo agente faz X]
   603	
   604	**Próxima sessão:**
   605	- [P0/P1 task com ID]
   606	```
   607	
   608	**Update MEMORY.md index** (linha única <200 chars):
   609	```
   610	- [session_YYYY-MM-DD_topic.md](file.md) — 1-line hook do conteúdo
   611	```
   612	
   613	### 8.4 — Update feedback memory (se houver)
   614	
   615	Se o usuário corrigiu approach OU validou approach não-óbvio durante a sessão:
   616	- Update `feedback_*.md` existente OU criar novo
   617	- Formato: rule + **Why:** + **How to apply:**
   618	
   619	### 8.5 — Subagent/Research Intelligence Harvest (NOVO 2026-06-07 — END-HARVEST-001)
   620	
   621	> **Origem:** sessão de propósito 2026-06-07 — o /end salvou as CONCLUSÕES mas deixou a INTELIGÊNCIA das sondas (7 relatórios: mapa forense, correlação traço↔arquitetura, inventário de monetização) viver só no transcript. Enio teve que pedir "verifique de novo, não percamos algo precioso" para o gap ser pego. Causa-raiz: subagent output tratado como andaime descartável após síntese. Ironia: numa sessão sobre "preserve a evidência", a evidência foi descartada.
   622	> **Princípio:** numa sessão com `Agent`/`Explore`/`Workflow`, o subagente produz ANÁLISE/EVIDÊNCIA cara de re-derivar. A conclusão vai pra Phase 8; a EVIDÊNCIA que a sustenta NÃO PODE morrer no tool-result. Re-derivar custa tokens+tempo; o raciocínio é load-bearing.
   623	
   624	**Dispara quando:** a sessão chamou ≥1 `Agent`/`Explore`/`Workflow`/sonda que retornou análise NÃO-commitada como código (inventário, mapa, tabela, comparação, refutação, forense, correlação).
   625	
   626	**Ação (executar, não declarar):**
   627	1. Listar os relatórios de subagente da sessão (o que cada sonda produziu).
   628	2. Para cada um, triar: **JÁ-EM-CÓDIGO** (virou commit → ok) · **CONCLUSÃO-JÁ-EM-MEMORY** (a decisão está salva, mas e a evidência?) · **SÓ-NO-TRANSCRIPT** (perde no próximo chat).
   629	3. Para os **SÓ-NO-TRANSCRIPT** com valor de referência → **condensar** (não colar inteiro — anti-bloat) num arquivo `type: reference` em `memory/session_YYYY-MM-DD_intelligence-*.md` (tabelas-chave + números + paths) OU, se >20K e operacional, `docs/jobs/YYYY-MM-DD-*.md`. Linkar `[[conclusão]]`.
   630	4. Atualizar MEMORY.md index.
   631	
   632	**Output obrigatório:**
   633	```
   634	INTELLIGENCE HARVEST
   635	====================

exec
/bin/bash -lc 'test -d docs/jobs; echo jobs=$?; ls docs/jobs | head 2 2>/dev/null' in /home/enio/egos
 exited 1 in 0ms:
jobs=0

exec
/bin/bash -lc "nl -ba TASKS_ARCHIVE.md | tail -20; nl -ba docs/strategy/EGOS_ONBOARDING_LAUNCH_PLAN.md | sed -n '1,12p'" in /home/enio/egos
 succeeded in 0ms:
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

exec
/bin/bash -lc "date -u -d '2026-06-07 13:02:17' '+%a, %d %b %Y %H:%M:%S GMT'" in /home/enio/egos
 succeeded in 0ms:
Sun, 07 Jun 2026 13:02:17 GMT

codex
The documentation changes are mostly consistent, but the new /end harvest workflow points harvested memory at a different path than the existing canonical memory workflow, so it can silently fail to preserve the intended evidence.

Review comment:

- [P2] Use the canonical memory path for harvested intelligence — /home/enio/egos/.claude/commands/end.md:629-630
  When Phase 8.5 runs after a session with subagents, this writes harvested reports to a relative `memory/...` path, but Phase 8.3 defines the project memory location as `~/.claude/projects/-home-enio-egos/memory/...`. That split means the new intelligence files can be created outside the memory store/index that future sessions read, recreating the evidence-loss problem this phase is meant to prevent.
The documentation changes are mostly consistent, but the new /end harvest workflow points harvested memory at a different path than the existing canonical memory workflow, so it can silently fail to preserve the intended evidence.

Review comment:

- [P2] Use the canonical memory path for harvested intelligence — /home/enio/egos/.claude/commands/end.md:629-630
  When Phase 8.5 runs after a session with subagents, this writes harvested reports to a relative `memory/...` path, but Phase 8.3 defines the project memory location as `~/.claude/projects/-home-enio-egos/memory/...`. That split means the new intelligence files can be created outside the memory store/index that future sessions read, recreating the evidence-loss problem this phase is meant to prevent.
```
