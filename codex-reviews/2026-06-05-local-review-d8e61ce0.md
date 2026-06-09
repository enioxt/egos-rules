# Codex Local Review — 2026-06-05T15:37:55Z

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
session id: 019e986f-11ad-7462-975b-73a3bceff78d
--------
user
changes against 'HEAD~3'
2026-06-05T15:37:57.823399Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-05T15:37:58.063434Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 4f6b7f3e7afc981a51b389570319bdcc651957eb --stat && git diff 4f6b7f3e7afc981a51b389570319bdcc651957eb' in /home/enio/egos
 succeeded in 113ms:
 TASKS.md                                           |  12 ++
 docs/_current_handoffs/INIT_AGENT-C_2026-06-05.md  |  68 ++++++++++
 .../handoff_2026-06-05-ui-observability.md         |  69 +++++++++++
 docs/governance/MULTI_AGENT_OBSERVABILITY.md       |  59 +++++++++
 scripts/agent-observatory.ts                       | 137 +++++++++++++++++++++
 5 files changed, 345 insertions(+)
diff --git a/TASKS.md b/TASKS.md
index 853403c8..a5fad40f 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -8,6 +8,18 @@
 ---
 <!-- SSOT validation priority sections: **P0 —** **P1 —** **P2 —** -->
 
+## 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
+
+> Pricing R$4 (×2 progression) definido. WhatsApp = produto de entrada = acesso completo.
+> Modelo de grupo: co-criação, colaboradores participam de receita quando projetos avançam.
+> PDF AIOX lido: João/Hero Base→Level 8→Hero Academy = referência de modelo comunidade→escola→publisher.
+
+- [ ] **PRICING-FOUNDING-PASS-001** [P0] `prime` `gated:HITL` — Registrar formalmente: preço inicial R$4, progressão ×2 (R$4→R$8→R$16→...), produto = acesso ao grupo WhatsApp + tudo que temos. Criar/atualizar `docs/business/founding-pass/pricing-ledger.jsonl` com entrada datada. Também: documentar modelo de co-ownership (participantes colaboram com código/idéias e participam da receita quando projetos avançam). HITL: Enio valida ledger antes de qualquer divulgação.
+- [ ] **OBSERVATORY-WIRE-001** [P1] `prime` — Wire `scripts/agent-observatory.ts --record` no `.husky/post-commit` (não bloqueia, exit 0). Smoke: commitar algo e verificar entry em `~/.egos/agent-actions.jsonl`. Adicionar `--monitor` ao alias de /start para listar status dos agentes.
+- [ ] **KNOWLEDGE-CATALOG-001** [P1] `curador`+`prime` — Catalogar TUDO que o EGOS tem hoje: tools (Guard Brasil, item-intake, mycelium, observatory, metaprompts, skills), capabilities (CAPABILITY_REGISTRY.md), processos documentados, integrations (Telegram, WhatsApp, Hermes, Supabase, MCPs). Output: `docs/catalog/egos-full-catalog-2026-06-05.md` com status (LIVE/CONCEPT/WIP) por item. Base para definir o primeiro material do grupo.
+- [ ] **GROUP-MODEL-SPEC-001** [P1] `prime` `gated:HITL` — Especificar formalmente o modelo do grupo EGOS: (a) entry = R$4, progressão ×2; (b) o que está incluso (acesso completo a tudo); (c) como funciona co-criação (código/idéias = participação proporcional em receita quando projeto avança); (d) status honesto de cada área (LIVE/WIP/CONCEPT); (e) regras de convivência. SSOT: `docs/business/group-model.md`. HITL antes de divulgar.
+- [ ] **AIOX-CASE-STUDY-001** [P2] `curador` — Extrair insights do PDF AIOX (João/Hero Base) aplicáveis ao EGOS: modelo publisher vs estúdio, escola para crescer ecossistema (Hero Academy → EGOS Academy), UGC monetization analogy (audiência→plataforma paga→criador recebe%), qualidade primeiro. Salvar em `docs/research/aiox-case-study-insights.md`.
+
 ## 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
 
 > Contexto: engenharia reversa do erro Mycelium-3-jobs → regras de UI permanentes (FEITO).
diff --git a/docs/_current_handoffs/INIT_AGENT-C_2026-06-05.md b/docs/_current_handoffs/INIT_AGENT-C_2026-06-05.md
new file mode 100644
index 00000000..c59c5301
--- /dev/null
+++ b/docs/_current_handoffs/INIT_AGENT-C_2026-06-05.md
@@ -0,0 +1,68 @@
+# 🤖 INICIALIZAÇÃO — Novo Agente EGOS (Agent-C) · 2026-06-05
+
+> **Cole esta mensagem inteira numa janela fresca do Claude Code (ou Antigravity).**
+> Você é um **agente EGOS**. O `CLAUDE.md` global + do projeto já auto-carregam sua identidade, regras T0-T4, anti-alucinação, Red Zone e HITL. Esta mensagem te dá o CONTEXTO da sessão e a SUA lane — para acelerarmos em paralelo sem colisão.
+
+---
+
+## 1. Quem é quem (3 escritores no MESMO checkout `/home/enio/egos`)
+
+| Agente | Runtime | Papel | Escreve em |
+|---|---|---|---|
+| **Prime** | Claude Code / Opus 4.8 | orquestra, commita, governança | `docs/governance/`, `docs/drafts/`, `TASKS.md` (dono único), handoffs |
+| **Guarani** | Antigravity / Gemini | aconselha, revisa (R10: propõe, não commita) | análise (brain dir dele) + revisa artefato |
+| **VOCÊ (Agent-C)** | janela nova | executa SUA lane | **só** os arquivos da sua lane (abaixo) |
+
+**REGRA DE OURO ANTI-COLISÃO (INC-002):**
+- `git add <arquivo-específico>` — **NUNCA** `git add -A` / `git add .` / `git restore .`.
+- **NÃO toque** em `TASKS.md` (só o Prime edita — me peça por handoff se precisar criar/fechar task).
+- **NÃO toque** em `apps/egos-landing/` (o Guarani mexeu no Mycelium ali) nem em `docs/governance/` (Prime).
+- Commit path-scoped. Pre-commit com watcher stale → `EGOS_WATCHER_OVERRIDE=1 git commit ...` (override documentado; janela única na sua lane).
+- Arquivo constitucional (CLAUDE.md/AGENTS.md/.guarani) → **não toque**; se precisar, handoff pro Prime.
+
+---
+
+## 2. SUA LANE (Agent-C): Vision + Design da "Escola Viva" EGOS
+
+**Objetivo (corte Enio 2026-06-05):** *"como seria o site para representar o que o EGOS É e FAZ — uma escola viva, representação de tudo que temos, todos os capítulos da história, todas as ferramentas, condensadas de forma que qualquer pessoa consiga configurar a si mesma nessa base."*
+
+**Sua entrega = DOCUMENTO de visão+design (NÃO código, NÃO deploy, NÃO publicar):**
+- Crie **só** `docs/design/living-school-vision.md` (arquivo novo, lane sua, zero colisão).
+- Sintetize a pesquisa já feita (Karpathy + integração humano-IA) — está resumida na seção 4 abaixo. Use-a.
+- Desenhe: (a) o que o site mostra (identidade, voz, capítulos da história, ferramentas, método); (b) como uma pessoa "se configura na mesma base"; (c) o que separa MÉTODO compartilhável de PESSOAL/interno; (d) seções + fluxo (aplicando **R-UI-001 One Job Per Screen** e **R-PUB-001** de `docs/governance/UI_PRODUCT_RULES.md` — LEIA antes).
+- **Red Zone:** é visão/design público → NÃO finalize copy pública sozinho; marque `🔴 CORTE ENIO` onde precisar. NÃO construa o site. NÃO publique.
+- Ao terminar: escreva `docs/_current_handoffs/AGENT-C_TO_PRIME_2026-06-05.md` com resumo + o que precisa de corte. Prime integra e decide build (que passará por R-PUB-001).
+
+---
+
+## 3. Contexto da sessão (o que JÁ foi feito — não refaça)
+
+SHAs desta sessão (verificáveis em `git log`):
+- `c26573f7` Mycelium = grafo SVG vivo (deploy live egos.ia.br) — **não mexer**
+- `e05c…`→v2 Artefato gratuito (metaprompt+checklist+identidade) — Prime/Guarani donos
+- `b94e86d4` Regras UI (R-UI-001..006) + `R-PUB-001` Flagship Gate — **LEIA, não edite**
+- `666cf955` Estudo vídeo Bashar (framework autodescoberta, secular)
+- Codex CONSERTADO → `gpt-5.5` (era model inexistente). Council = agente-based (não OpenRouter).
+
+**DEFERIDO (consenso Guarani+Banda+Codex — NÃO construa):** `/compass` (agente autodescoberta) + ingestão WhatsApp. Só depois da esteira comercial no ar.
+
+**Princípio constitucional:** EGOS preserva **conceitos, não pessoas**. Nada de PII/nome/lugar/biografia em artefato.
+
+---
+
+## 4. Pesquisa pronta pra você usar (Karpathy + integração humano-IA)
+
+- **Karpathy "Software 3.0"**: LLM é um novo computador programado em inglês. "You can outsource your thinking but you cannot outsource your understanding" → o gap do mercado é ENTENDIMENTO, não informação. ([karpathy.bearblog.dev/year-in-review-2025])
+- **"Iron Man suit, não Iron Man robot"**: autonomia parcial, humano no loop, maximizar o ciclo Geração-Verificação. → a escola ensina a gerar (prompt/metacognição) E verificar (evidence-first, CONFIRMADO/INFERIDO/HIPÓTESE).
+- **Arquitetura convergente**: local-first + estado compartilhado (file-system como verdade, LLM em cima). EGOS já tem (SOUL.md, TASKS.md, .guarani). A escola EXPÕE isso como currículo.
+- **O que falta no mercado** (Rewind morto/Meta, Second Brain só organiza, Personal.ai só lembra): ninguém deixa você **configurar-se na mesma base / forkar o método**. EGOS (`.guarani`, skills, Banda, AGENTS) é um SO forkável de pensamento estruturado. **Esse é o diferencial.**
+- **EVITAR**: "total recall"/gravar tudo (trap de privacidade — R-SEC-002), IA-terapeuta, IA que diz quem você é (algorithmic echo chamber), demo de autonomia total. A escola CONSTRÓI capacidade, não dá respostas.
+
+---
+
+## 5. Como reportar
+- Commits path-scoped só em `docs/design/living-school-vision.md`.
+- Handoff final: `docs/_current_handoffs/AGENT-C_TO_PRIME_2026-06-05.md`.
+- Dúvida de escopo / Red Zone → PARE e escreva no handoff (não auto-resolva copy pública).
+
+Bem-vindo, Agent-C. Foco: a visão da escola viva. Uma lane, arquivos disjuntos, sem medo de mostrar o que o EGOS é.
diff --git a/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md b/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md
new file mode 100644
index 00000000..dc0cdbb5
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md
@@ -0,0 +1,69 @@
+# Handoff — 2026-06-05 12:40 (UI Rules + Observatory + Propósito)
+
+## ✅ Accomplished (com SHAs)
+
+- **Mycelium SVG graph** — `c26573f7` — grafo SVG real com arestas desenhadas + pulsos + click-to-focus + mobile responsivo. Eliminou problema "3 trabalhos competindo numa tela".
+- **UI/Product Rules SSOT** — `b94e86d4` — R-UI-001..006 + R-PUB-001 Flagship Gate em docs/governance/UI_PRODUCT_RULES.md.
+- **CLAUDE.md UI rule** — `b94e86d4` — "UI/Produto [T1]" adicionada a Convenções.
+- **Artefato gratuito v2** — `4f6b7f3e` — Banda+Codex iterated. Aguarda Guarani + HITL Enio.
+- **Bootstrap Agent-C** — `114571c7` — lane escola-viva, pronto para despachar em janela nova.
+- **Estudo Bashar** — `666cf955` — framework secular (excitamento→espelho→premortem).
+- **agent-observatory.ts** — `4b2110e9` — observabilidade multi-agente warn-not-block. LANES + RED_ZONE + error budget. exit 0 sempre.
+- **MULTI_AGENT_OBSERVABILITY.md** — `4b2110e9` — SSOT da política.
+- **Codex model corrigido** — fora de repo — `~/.codex/config.toml`: `gpt-5.3-codex` → `gpt-5.5`. Verificado OK.
+
+## 🔄 In Progress
+
+- **FREE-ARTIFACT-GLANCE-001** — 90% — aguarda Guarani (handoff enviado) + HITL Enio → publicar.
+- **Agent-C dispatch** — bootstrap pronto, execução pendente — colar INIT_AGENT-C em janela nova.
+- **Propósito + Grupo + Pricing** — definidos verbalmente nesta sessão, ainda não commitados em ledger/spec.
+
+## ⏳ Blocked
+
+- **COURSE-PCMG-GATE-001** [P0] — estatuto PCMG sobre pagamentos PF — verificar antes de cobrar.
+- **WA-PRIVACY-POLICY-001** [P0] — política antes de qualquer ingestão WhatsApp.
+- **Pricing R$4** — verbalizado, não registrado — PRICING-FOUNDING-PASS-001 criada.
+
+## 🔗 Next Steps (priority order)
+
+1. [P0] PRICING-FOUNDING-PASS-001 — registrar R$4 (×2) + modelo de grupo em ledger
+2. [P0] FREE-ARTIFACT-GLANCE-001 — Enio glance em docs/drafts/free-artifact-egos-v0.md
+3. [P0] COURSE-PCMG-GATE-001 — verificar estatuto antes de cobrar
+4. [P1] Agent-C dispatch — colar INIT_AGENT-C em janela nova
+5. [P1] OBSERVATORY-WIRE-001 — wire observatory no .husky/post-commit
+6. [P1] KNOWLEDGE-CATALOG-001 — catalogar tudo para definir primeiro material do grupo
+
+## 🌐 Environment State
+
+- Build: ✅ | Tests: N/A | Deploy: egos.ia.br Mycelium live
+- Dispersão: 🔴 (416 commits/7d, 112 scopes — generativa mas alta)
+- TASKS.md: 842L (grace até 2026-06-15)
+
+## 📌 Decisions Made
+
+- Council = diversidade de AGENTE (Opus+Codex+Guarani), não modelo pago via OpenRouter.
+- Warn-not-block: observabilidade nunca trava, só registra e escala.
+- /compass DEFERIDO: consenso aparato — "cura não pode ter a forma da doença".
+- Pricing: R$4 entrada → ×2 progressão. WhatsApp = produto de entrada = acesso completo.
+- Grupo = co-criação: quem está dentro colabora e participa de receita quando projetos avançam.
+- PDF AIOX (João/Hero Base): modelo aplicável — Hero Base→Level 8→Hero Academy = comunidade→escola→publisher.
+
+## ✅ Todos (snapshot)
+
+- [x] Mycelium SVG (`c26573f7`)
+- [x] Regras UI (`b94e86d4`)
+- [x] Artefato v2 (`4f6b7f3e`)
+- [x] Codex corrigido
+- [x] Bootstrap Agent-C (`114571c7`)
+- [x] agent-observatory commitado (`4b2110e9`)
+- [/] FREE-ARTIFACT-GLANCE-001 — aguarda Guarani + HITL
+- [ ] Agent-C dispatchar
+- [ ] OBSERVATORY-WIRE-001
+- [ ] PRICING-FOUNDING-PASS-001
+- [ ] KNOWLEDGE-CATALOG-001
+
+## 🚫 Marked [CONCEPT]
+
+- Pricing ledger R$4 — verbalizado, não commitado
+- Group co-ownership model — descrito verbalmente, não documentado
+- AIOX PDF insights → tasks — lido, ainda não convertido em ações
diff --git a/docs/governance/MULTI_AGENT_OBSERVABILITY.md b/docs/governance/MULTI_AGENT_OBSERVABILITY.md
new file mode 100644
index 00000000..a6fb282c
--- /dev/null
+++ b/docs/governance/MULTI_AGENT_OBSERVABILITY.md
@@ -0,0 +1,59 @@
+# Multi-Agent Observability — Política warn-not-block
+
+> **Tier:** T1 · **SSOT único** desta família de regras.  
+> **Origem:** sessão 2026-06-05 — 3 agentes (Prime/Opus, Guarani/Gemini, Agent-C) no mesmo checkout.  
+> **Princípio (corte Enio):** "warn-not-block — a trava acompanha o desenvolvimento, não bloqueia."
+
+---
+
+## Arquitetura
+
+```
+scripts/agent-observatory.ts    ← implementação (always exit 0)
+~/.egos/agent-actions.jsonl     ← log unificado (todos veem todos)
+~/.egos/agent-lane-flags.jsonl  ← flags de violação (warn/escalate)
+```
+
+## Lanes (caminhos autorizados por agente)
+
+| Agente | Lane | Notas |
+|--------|------|-------|
+| `prime` | `docs/governance/`, `docs/drafts/`, `docs/_current_handoffs/`, `docs/research/`, `TASKS.md`, `scripts/agent-observatory` | orquestrador |
+| `agent-c` | `docs/design/living-school-vision.md`, `docs/_current_handoffs/AGENT-C_TO_PRIME` | executa task pontual |
+| `guarani` | `[]` | R10: advise-only, commit direto = violação |
+| `pre-commit-pipeline` | `*` | automação |
+| `system` | `*` | scripts de infra |
+
+## Red Zone Paths (escala imediatamente, mas ainda não bloqueia)
+
+`.husky/pre-commit` · `.guarani/` · `CLAUDE.md` · `AGENTS.md` · `.env` · `agents/runtime/runner.ts` · `agents/runtime/event-bus.ts`
+
+## Error Budget (janela 24h)
+
+- `🟢 OK`: 0 lane-violations
+- `🟡 WARN`: 1–3 violations (stderr, não bloqueia)
+- `🔴 ESCALATE`: ≥4 violations OU qualquer Red Zone touch
+
+## Uso
+
+```bash
+# post-commit (não bloqueia):
+bun scripts/agent-observatory.ts --record --agent=prime --sha=$(git rev-parse HEAD)
+
+# monitor unificado:
+bun scripts/agent-observatory.ts --monitor
+
+# pre-commit check (opcional):
+bun scripts/agent-observatory.ts --check --agent=agent-c --files="docs/design/x.md"
+```
+
+## Wiring (pendente — OBSERVATORY-WIRE-001)
+
+Wire no `.husky/post-commit`:
+```bash
+bun scripts/agent-observatory.ts --record --agent="${EGOS_AGENT:-prime}" --sha="$(git rev-parse HEAD)" || true
+```
+
+---
+
+*v1 — 2026-06-05 · warn-not-block. TASKS: OBSERVATORY-WIRE-001.*
diff --git a/scripts/agent-observatory.ts b/scripts/agent-observatory.ts
new file mode 100644
index 00000000..2d9f9089
--- /dev/null
+++ b/scripts/agent-observatory.ts
@@ -0,0 +1,137 @@
+#!/usr/bin/env bun
+/**
+ * agent-observatory.ts — Multi-agent observability (warn-not-block guardrail)
+ *
+ * Por quê: 3+ agentes (Prime/Opus, Guarani/Gemini, Agent-C, ...) escrevem o MESMO
+ * checkout. Precisamos de telemetria POR AGENTE + guardrail de lane que AVISA mas
+ * NÃO TRAVA (a trava acompanha o desenvolvimento — corte Enio 2026-06-05).
+ *
+ * NÃO duplica infra: reusa o post-commit (agent-execution-logger) e os ~/.egos/*.jsonl.
+ * Adiciona a camada que faltava: IDENTIDADE por agente + lane-check + monitor unificado.
+ *
+ * Uso:
+ *   bun scripts/agent-observatory.ts --record --agent=prime --sha=abc123   # post-commit
+ *   bun scripts/agent-observatory.ts --monitor                              # "todos veem todos"
+ *   bun scripts/agent-observatory.ts --check --agent=agent-c --files="a.ts,b.md"
+ *
+ * Garantia: SEMPRE exit 0 (nunca bloqueia commit). Só registra + avisa + escala (loud).
+ * SSOT da política: docs/governance/MULTI_AGENT_OBSERVABILITY.md
+ */
+import { appendFileSync, readFileSync, existsSync } from 'node:fs'
+import { execSync } from 'node:child_process'
+import { resolve } from 'node:path'
+import { homedir } from 'node:os'
+
+const EGOS_DIR = resolve(homedir(), '.egos')
+const ACTIONS_LOG = resolve(EGOS_DIR, 'agent-actions.jsonl')   // unified "all monitor all"
+const FLAGS_LOG = resolve(EGOS_DIR, 'agent-lane-flags.jsonl')
+
+// ── Lanes: caminhos permitidos por agente (prefixo). SSOT na doc de governança. ──
+const LANES: Record<string, string[]> = {
+  prime:      ['docs/governance/', 'docs/drafts/', 'docs/_current_handoffs/', 'docs/research/',
+               'docs/_archived_handoffs/', 'TASKS.md', 'TASKS_ARCHIVE.md', 'scripts/agent-observatory'],
+  'agent-c':  ['docs/design/living-school-vision.md', 'docs/_current_handoffs/AGENT-C_TO_PRIME'],
+  guarani:    [],  // advise-only (R10): commit direto = violação a flaggar
+  'pre-commit-pipeline': ['*'], // automação
+  system:     ['*'],
+}
+// Toque por QUALQUER agente nesses paths = escala (Red Zone), mas ainda não trava.
+const RED_ZONE_PATHS = ['.husky/pre-commit', '.guarani/', 'CLAUDE.md', 'AGENTS.md', '.env',
+                        'agents/runtime/runner.ts', 'agents/runtime/event-bus.ts']
+
+const ERROR_BUDGET = { warn: 1, escalate: 4 }  // <warn=ok · 1-3=🟡warn · ≥4=🔴escalate (24h window)
+
+const args = Object.fromEntries(process.argv.slice(2).filter(a => a.startsWith('--'))
+  .map(a => { const [k, ...v] = a.slice(2).split('='); return [k, v.join('=') || 'true'] }))
+
+function inLane(file: string, agent: string): boolean {
+  const lanes = LANES[agent]
+  if (!lanes) return false            // agente desconhecido → tudo é violação (flag)
+  if (lanes.includes('*')) return true
+  return lanes.some(p => file.startsWith(p))
+}
+function isRedZone(file: string): boolean {
+  return RED_ZONE_PATHS.some(p => file === p || file.startsWith(p))
+}
+function commitFiles(sha: string): string[] {
+  try {
+    return execSync(`git diff --name-only ${sha}~1 ${sha} 2>/dev/null`, { encoding: 'utf8' })
+      .split('\n').map(s => s.trim()).filter(Boolean)
+  } catch { return [] }
+}
+
+function record(agent: string, sha: string) {
+  const files = commitFiles(sha)
+  const violations = files.filter(f => !inLane(f, agent))
+  const redzone = files.filter(isRedZone)
+  const entry = {
+    ts: new Date().toISOString(), agent, sha,
+    files: files.length, files_list: files.slice(0, 40),
+    lane_violations: violations, redzone_touch: redzone,
+  }
+  try { appendFileSync(ACTIONS_LOG, JSON.stringify(entry) + '\n') } catch {}
+
+  if (violations.length || redzone.length) {
+    const flag = {
+      ts: entry.ts, agent, sha,
+      severity: redzone.length ? 'escalate' : 'warn',
+      detail: redzone.length
+        ? `🔴 RED ZONE tocada por '${agent}': ${redzone.join(', ')}`
+        : `🟡 fora da lane de '${agent}': ${violations.slice(0, 6).join(', ')}`,
+    }
+    try { appendFileSync(FLAGS_LOG, JSON.stringify(flag) + '\n') } catch {}
+    console.error(`[observatory] ${flag.detail} (warn-only, commit não bloqueado)`)
+  }
+}
+
+function recentFlags(hours = 24): any[] {
+  if (!existsSync(FLAGS_LOG)) return []
+  const cutoff = Date.now() - hours * 3600_000
+  return readFileSync(FLAGS_LOG, 'utf8').split('\n').filter(Boolean)
+    .map(l => { try { return JSON.parse(l) } catch { return null } }).filter(Boolean)
+    .filter(f => new Date(f.ts).getTime() >= cutoff)
+}
+
+function monitor() {
+  const actions = existsSync(ACTIONS_LOG)
+    ? readFileSync(ACTIONS_LOG, 'utf8').split('\n').filter(Boolean)
+        .map(l => { try { return JSON.parse(l) } catch { return null } }).filter(Boolean)
+    : []
+  const last24 = actions.filter((a: any) => Date.now() - new Date(a.ts).getTime() < 24 * 3600_000)
+  const perAgent: Record<string, { commits: number; viol: number; rz: number }> = {}
+  for (const a of last24 as any[]) {
+    const k = a.agent || 'unknown'
+    perAgent[k] ??= { commits: 0, viol: 0, rz: 0 }
+    perAgent[k].commits++
+    perAgent[k].viol += (a.lane_violations?.length || 0)
+    perAgent[k].rz += (a.redzone_touch?.length || 0)
+  }
+  console.log('🔭 AGENT OBSERVATORY — últimas 24h (todos veem todos)')
+  console.log('─'.repeat(58))
+  if (!Object.keys(perAgent).length) { console.log('  (sem ações registradas)') }
+  for (const [agent, s] of Object.entries(perAgent)) {
+    const budget = s.rz ? '🔴 ESCALATE' : s.viol >= ERROR_BUDGET.escalate ? '🔴 ESCALATE'
+      : s.viol >= ERROR_BUDGET.warn ? '🟡 WARN' : '🟢 OK'
+    console.log(`  ${budget}  ${agent.padEnd(12)} commits=${s.commits} lane-violations=${s.viol} redzone=${s.rz}`)
+  }
+  const flags = recentFlags(24)
+  if (flags.length) {
+    console.log('─'.repeat(58))
+    console.log(`⚠️  FLAGS (${flags.length}) — últimas:`)
+    for (const f of flags.slice(-6)) console.log(`   ${f.detail}`)
+  }
+  console.log('─'.repeat(58))
+  console.log('Política: warn-not-block. SSOT: docs/governance/MULTI_AGENT_OBSERVABILITY.md')
+}
+
+function check(agent: string, files: string[]) {
+  const violations = files.filter(f => !inLane(f, agent))
+  if (violations.length) console.error(`[observatory] 🟡 '${agent}' fora da lane: ${violations.join(', ')} (warn)`)
+  else console.log(`[observatory] 🟢 '${agent}' dentro da lane`)
+}
+
+if (args.record) record(args.agent || 'unknown', args.sha || 'HEAD')
+else if (args.monitor) monitor()
+else if (args.check) check(args.agent || 'unknown', (args.files || '').split(',').map(s => s.trim()).filter(Boolean))
+else { console.log('uso: --record --agent= --sha=  |  --monitor  |  --check --agent= --files='); }
+process.exit(0) // NUNCA bloqueia

exec
/bin/bash -lc "nl -ba scripts/agent-observatory.ts | sed -n '1,180p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * agent-observatory.ts — Multi-agent observability (warn-not-block guardrail)
     4	 *
     5	 * Por quê: 3+ agentes (Prime/Opus, Guarani/Gemini, Agent-C, ...) escrevem o MESMO
     6	 * checkout. Precisamos de telemetria POR AGENTE + guardrail de lane que AVISA mas
     7	 * NÃO TRAVA (a trava acompanha o desenvolvimento — corte Enio 2026-06-05).
     8	 *
     9	 * NÃO duplica infra: reusa o post-commit (agent-execution-logger) e os ~/.egos/*.jsonl.
    10	 * Adiciona a camada que faltava: IDENTIDADE por agente + lane-check + monitor unificado.
    11	 *
    12	 * Uso:
    13	 *   bun scripts/agent-observatory.ts --record --agent=prime --sha=abc123   # post-commit
    14	 *   bun scripts/agent-observatory.ts --monitor                              # "todos veem todos"
    15	 *   bun scripts/agent-observatory.ts --check --agent=agent-c --files="a.ts,b.md"
    16	 *
    17	 * Garantia: SEMPRE exit 0 (nunca bloqueia commit). Só registra + avisa + escala (loud).
    18	 * SSOT da política: docs/governance/MULTI_AGENT_OBSERVABILITY.md
    19	 */
    20	import { appendFileSync, readFileSync, existsSync } from 'node:fs'
    21	import { execSync } from 'node:child_process'
    22	import { resolve } from 'node:path'
    23	import { homedir } from 'node:os'
    24	
    25	const EGOS_DIR = resolve(homedir(), '.egos')
    26	const ACTIONS_LOG = resolve(EGOS_DIR, 'agent-actions.jsonl')   // unified "all monitor all"
    27	const FLAGS_LOG = resolve(EGOS_DIR, 'agent-lane-flags.jsonl')
    28	
    29	// ── Lanes: caminhos permitidos por agente (prefixo). SSOT na doc de governança. ──
    30	const LANES: Record<string, string[]> = {
    31	  prime:      ['docs/governance/', 'docs/drafts/', 'docs/_current_handoffs/', 'docs/research/',
    32	               'docs/_archived_handoffs/', 'TASKS.md', 'TASKS_ARCHIVE.md', 'scripts/agent-observatory'],
    33	  'agent-c':  ['docs/design/living-school-vision.md', 'docs/_current_handoffs/AGENT-C_TO_PRIME'],
    34	  guarani:    [],  // advise-only (R10): commit direto = violação a flaggar
    35	  'pre-commit-pipeline': ['*'], // automação
    36	  system:     ['*'],
    37	}
    38	// Toque por QUALQUER agente nesses paths = escala (Red Zone), mas ainda não trava.
    39	const RED_ZONE_PATHS = ['.husky/pre-commit', '.guarani/', 'CLAUDE.md', 'AGENTS.md', '.env',
    40	                        'agents/runtime/runner.ts', 'agents/runtime/event-bus.ts']
    41	
    42	const ERROR_BUDGET = { warn: 1, escalate: 4 }  // <warn=ok · 1-3=🟡warn · ≥4=🔴escalate (24h window)
    43	
    44	const args = Object.fromEntries(process.argv.slice(2).filter(a => a.startsWith('--'))
    45	  .map(a => { const [k, ...v] = a.slice(2).split('='); return [k, v.join('=') || 'true'] }))
    46	
    47	function inLane(file: string, agent: string): boolean {
    48	  const lanes = LANES[agent]
    49	  if (!lanes) return false            // agente desconhecido → tudo é violação (flag)
    50	  if (lanes.includes('*')) return true
    51	  return lanes.some(p => file.startsWith(p))
    52	}
    53	function isRedZone(file: string): boolean {
    54	  return RED_ZONE_PATHS.some(p => file === p || file.startsWith(p))
    55	}
    56	function commitFiles(sha: string): string[] {
    57	  try {
    58	    return execSync(`git diff --name-only ${sha}~1 ${sha} 2>/dev/null`, { encoding: 'utf8' })
    59	      .split('\n').map(s => s.trim()).filter(Boolean)
    60	  } catch { return [] }
    61	}
    62	
    63	function record(agent: string, sha: string) {
    64	  const files = commitFiles(sha)
    65	  const violations = files.filter(f => !inLane(f, agent))
    66	  const redzone = files.filter(isRedZone)
    67	  const entry = {
    68	    ts: new Date().toISOString(), agent, sha,
    69	    files: files.length, files_list: files.slice(0, 40),
    70	    lane_violations: violations, redzone_touch: redzone,
    71	  }
    72	  try { appendFileSync(ACTIONS_LOG, JSON.stringify(entry) + '\n') } catch {}
    73	
    74	  if (violations.length || redzone.length) {
    75	    const flag = {
    76	      ts: entry.ts, agent, sha,
    77	      severity: redzone.length ? 'escalate' : 'warn',
    78	      detail: redzone.length
    79	        ? `🔴 RED ZONE tocada por '${agent}': ${redzone.join(', ')}`
    80	        : `🟡 fora da lane de '${agent}': ${violations.slice(0, 6).join(', ')}`,
    81	    }
    82	    try { appendFileSync(FLAGS_LOG, JSON.stringify(flag) + '\n') } catch {}
    83	    console.error(`[observatory] ${flag.detail} (warn-only, commit não bloqueado)`)
    84	  }
    85	}
    86	
    87	function recentFlags(hours = 24): any[] {
    88	  if (!existsSync(FLAGS_LOG)) return []
    89	  const cutoff = Date.now() - hours * 3600_000
    90	  return readFileSync(FLAGS_LOG, 'utf8').split('\n').filter(Boolean)
    91	    .map(l => { try { return JSON.parse(l) } catch { return null } }).filter(Boolean)
    92	    .filter(f => new Date(f.ts).getTime() >= cutoff)
    93	}
    94	
    95	function monitor() {
    96	  const actions = existsSync(ACTIONS_LOG)
    97	    ? readFileSync(ACTIONS_LOG, 'utf8').split('\n').filter(Boolean)
    98	        .map(l => { try { return JSON.parse(l) } catch { return null } }).filter(Boolean)
    99	    : []
   100	  const last24 = actions.filter((a: any) => Date.now() - new Date(a.ts).getTime() < 24 * 3600_000)
   101	  const perAgent: Record<string, { commits: number; viol: number; rz: number }> = {}
   102	  for (const a of last24 as any[]) {
   103	    const k = a.agent || 'unknown'
   104	    perAgent[k] ??= { commits: 0, viol: 0, rz: 0 }
   105	    perAgent[k].commits++
   106	    perAgent[k].viol += (a.lane_violations?.length || 0)
   107	    perAgent[k].rz += (a.redzone_touch?.length || 0)
   108	  }
   109	  console.log('🔭 AGENT OBSERVATORY — últimas 24h (todos veem todos)')
   110	  console.log('─'.repeat(58))
   111	  if (!Object.keys(perAgent).length) { console.log('  (sem ações registradas)') }
   112	  for (const [agent, s] of Object.entries(perAgent)) {
   113	    const budget = s.rz ? '🔴 ESCALATE' : s.viol >= ERROR_BUDGET.escalate ? '🔴 ESCALATE'
   114	      : s.viol >= ERROR_BUDGET.warn ? '🟡 WARN' : '🟢 OK'
   115	    console.log(`  ${budget}  ${agent.padEnd(12)} commits=${s.commits} lane-violations=${s.viol} redzone=${s.rz}`)
   116	  }
   117	  const flags = recentFlags(24)
   118	  if (flags.length) {
   119	    console.log('─'.repeat(58))
   120	    console.log(`⚠️  FLAGS (${flags.length}) — últimas:`)
   121	    for (const f of flags.slice(-6)) console.log(`   ${f.detail}`)
   122	  }
   123	  console.log('─'.repeat(58))
   124	  console.log('Política: warn-not-block. SSOT: docs/governance/MULTI_AGENT_OBSERVABILITY.md')
   125	}
   126	
   127	function check(agent: string, files: string[]) {
   128	  const violations = files.filter(f => !inLane(f, agent))
   129	  if (violations.length) console.error(`[observatory] 🟡 '${agent}' fora da lane: ${violations.join(', ')} (warn)`)
   130	  else console.log(`[observatory] 🟢 '${agent}' dentro da lane`)
   131	}
   132	
   133	if (args.record) record(args.agent || 'unknown', args.sha || 'HEAD')
   134	else if (args.monitor) monitor()
   135	else if (args.check) check(args.agent || 'unknown', (args.files || '').split(',').map(s => s.trim()).filter(Boolean))
   136	else { console.log('uso: --record --agent= --sha=  |  --monitor  |  --check --agent= --files='); }
   137	process.exit(0) // NUNCA bloqueia

exec
/bin/bash -lc "grep -R \"agent-actions\\|agent-execution-logger\\|\\.egos\" -n .husky scripts package.json 2>/dev/null | head -80" in /home/enio/egos
 succeeded in 109ms:
.husky/post-commit:29:  bun scripts/agent-execution-logger.ts \
.husky/focus-enforcement:77:  "lab.egos" "CAPABILITY_REGISTRY" "CAPABILITY_CLASSIFICATION"
.husky/pre-push:39:# Bloqueia push se finding CRITICAL pendente criou .egos/hermes-push-block.lock.
.husky/pre-push:40:# Override: HERMES_BLOCK_OVERRIDE=1 git push (auditado em ~/.egos/hermes-overrides.jsonl)
.husky/pre-push:41:HERMES_LOCK="$(git rev-parse --show-toplevel 2>/dev/null)/.egos/hermes-push-block.lock"
.husky/pre-push:64:      mkdir -p "$HOME/.egos" 2>/dev/null
.husky/pre-push:65:      echo "{\"override_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"finding_id\":\"$FINDING\",\"reason\":\"$REASON\",\"branch\":\"$_CURRENT_BRANCH\"}" >> "$HOME/.egos/hermes-overrides.jsonl"
.husky/pre-commit:45:  # batch writes .egos-commit-lock (gitignored): "owner|pid|epoch|reason". The OTHER
.husky/pre-commit:47:  ZE_LOCK="$(git rev-parse --show-toplevel 2>/dev/null)/.egos-commit-lock"
.husky/pre-commit:84:BLACKBOARD="$HOME/.egos/coordination-blackboard.json"
.husky/pre-commit:140:       grep -qE '["'"'"'`=]\s*/home/enio/egos|["'"'"'`=]\s*C:\\\\Users\\\\Usuario\\\\.egos'; then
.husky/pre-commit:190:if [ -f "$HOME/.egos/review-queue.jsonl" ]; then
.husky/pre-commit:192:  CRITICAL_COUNT_FILE="$HOME/.egos/review-queue.jsonl.critical-count"
.husky/pre-commit:197:    CRITICAL_COUNT=$(grep -c '"severity":"CRITICAL"' "$HOME/.egos/review-queue.jsonl" 2>/dev/null || echo 0)
.husky/pre-commit:202:    echo "   Run: cat ~/.egos/review-queue.jsonl | grep CRITICAL to see details."
.husky/pre-commit:380:# ~/.egos/sync.sh converts kernel .guarani/ into symlinks to ~/.egos/guarani/. The kernel
.husky/pre-commit:388:    echo "   Cause: governance:sync:exec / ~/.egos/sync.sh converted kernel .guarani/ to symlinks."
.husky/pre-commit:449:# 4. Governance propagation — canonical kernel files must be synced to ~/.egos
.husky/pre-commit:451:  echo "  [3/5] governance sync: checking kernel -> ~/.egos drift..."
.husky/pre-commit:453:    echo "❌ BLOCKED: Governance drift detected between kernel and ~/.egos."
.husky/pre-commit:476:# 4.2. Skills drift — warn if egos/ copy diverges from .egos/ SSOT (non-blocking)
.husky/pre-commit:598:echo "  [5.5/8] doc-drift: verifying .egos-manifest.yaml claims..."
.husky/pre-commit:732:if [ -f "$HOME/.egos/hooks/readme-freshness.sh" ]; then
.husky/pre-commit:733:  bash "$HOME/.egos/hooks/readme-freshness.sh" "${1:-}" || exit 1
.husky/pre-commit:735:  echo "  [readme-freshness] hook not installed in ~/.egos/hooks — skipping (CROSS_PLATFORM_RULES §3)"
.husky/pre-commit:763:SIGNALS_FILE="$HOME/.egos/context-signals.jsonl"
.husky/pre-commit:841:    echo "          em gpecas.egos.ia.br. Cada deploy DEVE usar script com R1-R8."
.husky/post-push:3:# Installed via: ~/.egos/crcdm/crcdm-install-hooks.sh
.husky/post-push:7:# Reviews are stored in ~/.egos/codex-reviews/ and read at /start + /end.
.husky/post-push:27:  if bash ~/.egos/scripts/codex-submit-review.sh "${REPO_PATH}" 3 >> ~/.egos/codex-reviews/submit.log 2>&1; then
.husky/post-push:40:    DISPATCH_LOG="${HOME}/.egos/codex-reviews/hermes-dispatch.log"
.husky/doc-drift-check.sh:3:# Blocks commits whose code changes drift from declared .egos-manifest.yaml claims
.husky/doc-drift-check.sh:7:# Schema: .egos-manifest.yaml
.husky/doc-drift-check.sh:13:MANIFEST="$REPO_ROOT/.egos-manifest.yaml"
.husky/doc-drift-check.sh:17:  echo "  [doc-drift] no manifest in $REPO_ROOT — skipping (add .egos-manifest.yaml to opt in)"
.husky/doc-drift-check.sh:77:  echo "  2. Update .egos-manifest.yaml last_value + last_verified_at + re-stage"
.husky/_checks/08-skills-health.sh:4:# Depende de: ~/.egos/skill-index.db (criado por packages/skill-discovery)
.husky/_checks/08-skills-health.sh:6:DB="$HOME/.egos/skill-index.db"
.husky/_checks/09-hermes-upstream.sh:6:SYNC_MARKER="${EGOS_HERMES_SYNC_MARKER:-$HERMES_DIR/.egos-last-upstream-check}"
scripts/validate-anythingllm.sh:7:#   ALLM_URL=https://kb.gpecas.egos.ia.br bash $0            # validação remota
scripts/validate-anythingllm.sh:8:#   ALLM_URL=... KEY_FILE=~/.egos/clients/gpecas/.api-key bash $0
scripts/coordination-watcher.ts:23:const EGOS_DIR = resolve(homedir(), '.egos');
scripts/coordination-watcher.ts:125:    console.log(`[COORDINATION] Blackboard successfully updated (both /tmp and ~/.egos).`);
scripts/coordination-watcher.ts:189:  console.log(`[COORDINATION] Blackboard marked clean (both /tmp and ~/.egos).`);
scripts/vps-api.ts:4: * Caddy may proxy external access (for example hq.egos.ia.br/api/vps/* → 127.0.0.1:3103).
scripts/notebook-sync-detect.ts:16: * Op-ledger: ~/.egos/notebook-sync-ledger.jsonl (append-only JSONL)
scripts/notebook-sync-detect.ts:43:const EGOS_DIR = `${HOME}/.egos`;
scripts/hermes-finding-update.ts:53:const EVENTS_LOG = join(homedir(), ".egos", "hermes-finding-events.jsonl");
scripts/hermes-finding-update.ts:54:const REVIEW_QUEUE = join(homedir(), ".egos", "review-queue.jsonl");
scripts/hermes-finding-update.ts:432:Events log: ~/.egos/hermes-finding-events.jsonl
scripts/morning-report.ts:48:    { name: 'hq.egos.ia.br', url: 'https://hq.egos.ia.br' },
scripts/morning-report.ts:49:    { name: 'guard',         url: 'https://guard.egos.ia.br/health' },
scripts/autores-ingest-incidents.ts:6: * Cada INC vira uma linha em ~/.egos/incidents-as-rules.jsonl
scripts/autores-ingest-incidents.ts:27:const HARVEST_SEED_PATH = "/home/enio/.egos/harvest-seed.jsonl";
scripts/autores-ingest-incidents.ts:28:const OUTPUT_PATH = "/home/enio/.egos/incidents-as-rules.jsonl";
scripts/autores-ingest-incidents.ts:360:> **Output JSONL:** ~/.egos/incidents-as-rules.jsonl
scripts/autores-ingest-incidents.ts:387:> Para aceitar uma regra: editar \`~/.egos/incidents-as-rules.jsonl\`, mudar state draft→proposed,
scripts/install-codex-hooks.ts:13:const HOOK_SOURCE = join(homedir(), '.egos', 'hooks', 'post-push-codex.sh');
scripts/health-check-vps.sh:3:# Saída: ~/.egos/last-health-check.json (timestamp + findings)
scripts/health-check-vps.sh:8:HEALTH_FILE="$HOME/.egos/last-health-check.json"
scripts/health-check-vps.sh:9:mkdir -p "$HOME/.egos"
scripts/sprint-review.ts:21:const REVIEW_QUEUE_PATH = "/home/enio/.egos/review-queue.jsonl";
scripts/sprint-review.ts:22:const HISTORICAL_PATTERNS_PATH = "/home/enio/.egos/historical-patterns.jsonl";
scripts/sprint-review.ts:23:const INCIDENTS_AS_RULES_PATH = "/home/enio/.egos/incidents-as-rules.jsonl";
scripts/egos-home/manifest.json:3:  "description": "EGOS Governance Mirror — declarative sync manifest for ~/.egos distribution",
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:208:| Governance Symlink Converter (legacy) | `~/.egos/governance-symlink.sh` | C | Manual cleanup only | — | `governance`, `symlink`, `legacy` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:209:| Governance Sync Plane | `egos/scripts/governance-sync.sh` + `~/.egos/sync.sh` | A | Kernel + synced leaves | — | `governance`, `sync`, `ssot` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:212:| CRCDM Universal Hook | `scripts/hooks/crcdm-pre-commit.sh` → `~/.egos/hooks/pre-commit` | A | ALL (symlink) | — | `governance`, `security`, `crcdm`, `hooks` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:270:| **Guard Brasil REST API** | `egos/apps/api/src/server.ts` + `apps/api/deploy.sh` | A | egos (LIVE: guard.egos.ia.br) | — | `deploy`, `docker`, `guard-brasil`, `api` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:417:> **Live:** lab.egos.ia.br · **Stack:** Bun + Hono + Supabase + OpenRouter
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:447:| **EGOS HQ Dashboard** | `egos/apps/egos-hq/` (hq.egos.ia.br:3060) | A | egos (LIVE) | — | `hq`, `dashboard`, `mission-control` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:591:| EGOS HQ Dashboard | `apps/egos-hq/` → hq.egos.ia.br | A | egos | `dashboard`, `mission-control`, `private`, `jwt-auth` |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:599:- Dashboard: https://hq.egos.ia.br (private, requires DASHBOARD_MASTER_SECRET)
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:653:| L1 | `.egos-manifest.yaml` per repo | Manual + generator | claim contracts |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:950:- `scripts/disseminate-scanner.ts` — diffs 4 kernel files (`~/.claude/CLAUDE.md`, `.windsurfrules`, `CLAUDE.md`, `CAPABILITY_REGISTRY.md`), extracts changed sections by markdown heading, writes `.egos-disseminate-manifest.json`
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1065:**Skill:** `/usage-report` at `~/.egos/.claude/commands/usage-report.md`
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1173:**URL:** [video.egos.ia.br](https://video.egos.ia.br) | **Serving:** nginx no VPS Hetzner
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1201:**URLs:** `trust.egos.ia.br` (trust page), `api.egos.ia.br/api/lgpd/*` (LGPD API)
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1506:- **Evidence:** Quality A declared; commits a4b3597, 255bf1e; chatbot.egos.ia.br live (Phase 0)
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1511:Portal `chatbot.egos.ia.br` com 5 agentes (Labs/Pixel/Tira-Voz/Forja/Arch) + lead capture com funil `agent_clicked`.

exec
/bin/bash -lc "sed -n '1,80p' .husky/post-commit && nl -ba scripts/agent-execution-logger.ts | sed -n '1,130p'" in /home/enio/egos
 succeeded in 102ms:
     1	#!/usr/bin/env bun
     2	/**
     3	 * agent-execution-logger.ts — SKILL-UNIF-001c
     4	 *
     5	 * Logs agent execution to:
     6	 *   1. agents/registry/agents.json → updates last_run_date + last_duration_ms per agent
     7	 *   2. docs/jobs/YYYY-MM-DD-<agent-id>.json → append-only run log
     8	 *   3. Supabase egos_agent_events → real-time HQ visibility (HERMES-HQ-001)
     9	 *
    10	 * Usage:
    11	 *   bun scripts/agent-execution-logger.ts --agent=ssot-auditor --duration=4200 --status=ok
    12	 *   bun scripts/agent-execution-logger.ts --agent=hermes-autothink --status=ok --event="Dreamer generated 3 ideas"
    13	 *   bun scripts/agent-execution-logger.ts --list     # show last run per agent
    14	 */
    15	
    16	import { readFileSync, writeFileSync, appendFileSync, mkdirSync, existsSync } from 'node:fs'
    17	import { resolve } from 'node:path'
    18	
    19	const ROOT     = resolve(import.meta.dir, '..')
    20	const REGISTRY = resolve(ROOT, 'agents/registry/agents.json')
    21	const JOBS_DIR = resolve(ROOT, 'docs/jobs')
    22	
    23	const args = Object.fromEntries(
    24	  process.argv.slice(2)
    25	    .filter(a => a.startsWith('--'))
    26	    .map(a => {
    27	      const [k, ...v] = a.slice(2).split('=')
    28	      return [k, v.join('=') || 'true']
    29	    })
    30	)
    31	
    32	interface AgentEntry {
    33	  id: string
    34	  name: string
    35	  last_run_date?: string
    36	  last_duration_ms?: number
    37	  last_status?: 'ok' | 'error' | 'partial'
    38	  run_count?: number
    39	  [key: string]: unknown
    40	}
    41	
    42	interface Registry {
    43	  version: string
    44	  updated: string
    45	  agents: AgentEntry[]
    46	  [key: string]: unknown
    47	}
    48	
    49	interface RunLog {
    50	  agent_id: string
    51	  ts: string
    52	  status: string
    53	  duration_ms: number | null
    54	  event: string
    55	  repo: string
    56	}
    57	
    58	function loadRegistry(): Registry {
    59	  return JSON.parse(readFileSync(REGISTRY, 'utf8')) as Registry
    60	}
    61	
    62	function saveRegistry(reg: Registry) {
    63	  reg.updated = new Date().toISOString().slice(0, 10)
    64	  writeFileSync(REGISTRY, JSON.stringify(reg, null, 2) + '\n')
    65	}
    66	
    67	function writeJobLog(agentId: string, log: RunLog) {
    68	  mkdirSync(JOBS_DIR, { recursive: true })
    69	  const date = new Date().toISOString().slice(0, 10)
    70	  const file = resolve(JOBS_DIR, `${date}-${agentId}.json`)
    71	  const lines = existsSync(file)
    72	    ? JSON.parse(readFileSync(file, 'utf8')) as RunLog[]
    73	    : []
    74	  lines.push(log)
    75	  writeFileSync(file, JSON.stringify(lines, null, 2) + '\n')
    76	}
    77	
    78	async function logToSupabase(log: RunLog) {
    79	  const url = process.env.SUPABASE_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL ?? ''
    80	  const key = process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_ANON_KEY ?? ''
    81	  if (!url || !key) return
    82	
    83	  try {
    84	    await fetch(`${url}/rest/v1/egos_agent_events`, {
    85	      method: 'POST',
    86	      headers: {
    87	        'apikey': key,
    88	        'Authorization': `Bearer ${key}`,
    89	        'Content-Type': 'application/json',
    90	        'Prefer': 'return=minimal',
    91	      },
    92	      body: JSON.stringify({
    93	        source: log.agent_id,
    94	        event_type: log.event || 'execution',
    95	        severity: log.status === 'error' ? 'error' : 'info',
    96	        created_at: log.ts,
    97	        payload: {
    98	          duration_ms: log.duration_ms,
    99	          status: log.status,
   100	          repo: log.repo,
   101	          event: log.event,
   102	        },
   103	      }),
   104	    })
   105	  } catch { /* non-blocking */ }
   106	}
   107	
   108	async function main() {
   109	  // --list: show last run per agent
   110	  if (args['list']) {
   111	    const reg = loadRegistry()
   112	    console.log('\nAgent execution log:')
   113	    for (const a of reg.agents) {
   114	      const last = a.last_run_date ?? 'never'
   115	      const dur = a.last_duration_ms ? `${a.last_duration_ms}ms` : '—'
   116	      const status = a.last_status ?? '—'
   117	      const count = a.run_count ?? 0
   118	      console.log(`  ${a.id.padEnd(30)} last=${last.padEnd(12)} dur=${dur.padEnd(8)} status=${status} runs=${count}`)
   119	    }
   120	    return
   121	  }
   122	
   123	  const agentId  = args['agent']
   124	  const status   = (args['status'] ?? 'ok') as 'ok' | 'error' | 'partial'
   125	  const duration = args['duration'] ? parseInt(args['duration']) : null
   126	  const event    = args['event'] ?? 'execution'
   127	
   128	  if (!agentId) {
   129	    console.error('Usage: bun scripts/agent-execution-logger.ts --agent=<id> [--status=ok] [--duration=4200] [--event="..."]')
   130	    process.exit(1)

exec
/bin/bash -lc "nl -ba scripts/agent-execution-logger.ts | sed -n '130,260p'" in /home/enio/egos
 succeeded in 102ms:
   130	    process.exit(1)
   131	  }
   132	
   133	  const now = new Date().toISOString()
   134	  const log: RunLog = {
   135	    agent_id: agentId,
   136	    ts: now,
   137	    status,
   138	    duration_ms: duration,
   139	    event,
   140	    repo: ROOT,
   141	  }
   142	
   143	  // 1. Update agents.json
   144	  const reg = loadRegistry()
   145	  const agent = reg.agents.find(a => a.id === agentId)
   146	  if (agent) {
   147	    agent.last_run_date = now.slice(0, 10)
   148	    if (duration !== null) agent.last_duration_ms = duration
   149	    agent.last_status = status
   150	    agent.run_count = (agent.run_count ?? 0) + 1
   151	    saveRegistry(reg)
   152	    console.log(`[logger] Updated ${agentId}: last_run_date=${agent.last_run_date} status=${status}`)
   153	  } else {
   154	    console.warn(`[logger] Agent '${agentId}' not found in registry — job log only`)
   155	  }
   156	
   157	  // 2. Append to docs/jobs/
   158	  writeJobLog(agentId, log)
   159	  console.log(`[logger] Job log: docs/jobs/${now.slice(0, 10)}-${agentId}.json`)
   160	
   161	  // 3. Supabase egos_agent_events (non-blocking)
   162	  await logToSupabase(log)
   163	  console.log(`[logger] Supabase event logged (source=${agentId})`)
   164	}
   165	
   166	main().catch(console.error)

exec
/bin/bash -lc 'bun --version && bun scripts/agent-observatory.ts --check --agent=agent-c --files=docs/design/x.md; echo exit:$?' in /home/enio/egos
 succeeded in 123ms:
[observatory] 🟡 'agent-c' fora da lane: docs/design/x.md (warn)
exit:0

exec
/bin/bash -lc 'tmp=$(mktemp -d); HOME="$tmp" bun scripts/agent-observatory.ts --record --agent=prime --sha=$(git rev-parse --short HEAD); echo "files:"; find "$tmp" -maxdepth 2 -type f -print; rm -rf "$tmp"' in /home/enio/egos
 succeeded in 135ms:
files:

codex
The new observatory can silently fail to record anything on environments without an existing ~/.egos directory, defeating the main functionality while still exiting successfully.

Review comment:

- [P2] Create the observatory log directory before appending — /home/enio/egos/scripts/agent-observatory.ts:72-72
  When `~/.egos` has not already been created on a machine or CI/user account, `appendFileSync(ACTIONS_LOG, ...)` throws `ENOENT` and the catch swallows it, so `--record` exits 0 without writing any action or flag logs; `--monitor` then reports no activity even though commits were recorded. Since this script is meant to be wired into post-commit for observability, it should ensure `EGOS_DIR` exists before appending.
The new observatory can silently fail to record anything on environments without an existing ~/.egos directory, defeating the main functionality while still exiting successfully.

Review comment:

- [P2] Create the observatory log directory before appending — /home/enio/egos/scripts/agent-observatory.ts:72-72
  When `~/.egos` has not already been created on a machine or CI/user account, `appendFileSync(ACTIONS_LOG, ...)` throws `ENOENT` and the catch swallows it, so `--record` exits 0 without writing any action or flag logs; `--monitor` then reports no activity even though commits were recorded. Since this script is meant to be wired into post-commit for observability, it should ensure `EGOS_DIR` exists before appending.
```
