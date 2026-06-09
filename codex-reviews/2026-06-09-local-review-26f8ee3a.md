# Codex Local Review — 2026-06-09T18:13:14Z

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
session id: 019ead96-b34f-7701-ae33-1b8244483aa0
--------
user
changes against 'HEAD~3'
2026-06-09T18:13:16.453197Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T18:13:16.453196Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 0c0a52163cdbd3a7fb00658ff442afd8fe266aeb --stat && git diff 0c0a52163cdbd3a7fb00658ff442afd8fe266aeb' in /home/enio/egos
 succeeded in 0ms:
 AGENTS.md                                        |   1 +
 TASKS.md                                         |   5 +-
 TASKS_ARCHIVE.md                                 |  19 +
 apps/egos-gateway/package.json                   |   1 +
 apps/egos-gateway/src/orchestrator.ts            |  13 +
 apps/egos-gateway/src/pii-gate.test.ts           |  72 +++
 apps/egos-landing/package.json                   |   2 +-
 apps/egos-landing/scripts/generate-metaprompt.ts |  40 ++
 apps/egos-landing/src/App.tsx                    | 112 +----
 apps/egos-landing/src/data/metaprompt-source.ts  |   6 +
 bun.lock                                         |  42 ++
 docs/drafts/CONSELHO_REGISTRO.md                 | 579 +++++++++++++++++++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json     |   4 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json    |  24 +
 docs/presentations/mf-certificados-piloto.html   |  68 ++-
 scripts/hermes-trigger.sh                        |  20 +
 16 files changed, 883 insertions(+), 125 deletions(-)
diff --git a/AGENTS.md b/AGENTS.md
index 08eb3b98..a502bf68 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -76,6 +76,7 @@ Default path: prove in a real leaf/runtime → extract what is reusable → regi
 | INC-007 | API key exposure via `|| fallback` pattern — never commit secrets |
 | INC-008 | Phantom compliance stubs — see R7 below |
 | INC-009 | Leaf-repo silo-work (agente cria SSOT paralelo ignorando canonical existente) — see R2.5 above. `/start` LAYER 4.6 força leitura de SSOTs do leaf antes de qualquer write |
+| INC-GATEWAY-001 | HTTP header values devem ser ASCII puro — em dash `—` e outros não-ASCII causam Hono 500 (2026-06-09). Strings estáticas em `c.header()` → verificar. |
 
 Full postmortems: `docs/INCIDENTS/INC-XXX-*.md`. Index: `docs/INCIDENTS/INDEX.md`.
 
diff --git a/TASKS.md b/TASKS.md
index bdc39db4..c166161e 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -54,7 +54,6 @@
 - [ ] **COPY-PRICE-REMOVE-001** [P1] `voz` `gated:HITL` — corte Enio 2026-06-07: preço NÃO é copy pública. REMOVER todo price-talk dos ~10 arquivos (founding-pass/social-copy "Por R$2 você recebe", posts-ready-to-publish, social-media/*, competitive-analysis) — sem número, sem "por que R$X", sem âncora, sem "dobra a cada lote". Valor só no checkout. Público = método aberto + acesso vitalício. Internamente R$4 ×2 segue (pricing-policy SSOT). Voz + HITL.
 - [/] **VALIDATE-BOTH-EXPERIMENT-001** [P0] `prime` — ✅ DEPLOY FEITO 2026-06-07 (a9156f52, egos.ia.br HTTP 200, copy revisado+voz nova no bundle, backup VPS p/ rollback, visual audit 11/12). FALTA: 1ª pessoa real usa o artefato/GPT → medir 2 sinais (material atrai? ajudar acende o Enio?). R$4 liga depois. Sem construir nada novo.
 - [/] **README-FOCUS-REFLECT-001** [P1] `voz`+`pixel` `gated:HITL` — abertura DRAFT pronta (launch plan §8, voz EGOS colaborativa sem preço/absoluto/persona); falta HITL Enio + aplicar no README.md real. Overhaul completo = README-OVERHAUL-001.
-- [ ] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — auditoria Guarani #1: metaprompt v3 hardcoded inline em App.tsx (drift vs docs/drafts/free-artifact-egos-v0.md). Build Vite pré-compila do markdown canônico → src/data/metaprompt-source.ts. Evita drift SSOT.
 - [ ] **GUARANI-CONSENT-STAGING-001** [P2] `forja` — auditoria Guarani #2: whitelist do consent gate (mcp-browser-automation) só cobre prod EGOS. Permitir wildcard/IPs locais p/ visual proof não quebrar em staging/local/cliente.
 - [/] **GUARANI-ADAPTIVE-PROMPT-001** [P1] `voz`+`prime` `gated:HITL` — Golden Example Tutor→Operacional REDIGIDO (gpt-tier0-package.md §2, bloco a anexar). Falta HITL + colar no artefato/GPT. Guarani #3.
 - [ ] **GIT-HISTORY-PII-DEEPSCAN-001** [P1] `guardiao`+`redzone` 🔴 — auditoria Guarani #5 (corrigida): egos NÃO tem arquivos OP-* no histórico (verificado), mas antes de QUALQUER abertura pública do egos, scan PROFUNDO de PII no conteúdo do histórico (não só paths). Repo público hoje = egos-governance (curado). NÃO filter-repo sem evidência + corte Enio (T0).
@@ -117,8 +116,7 @@
 - [ ] **ESSENTIAL-FILES-ENFORCE-001** [P2] `prime` — Wire warn-only (Sentinela varre last_update→REVISAR >60d; /start avisa limites). Só DEPOIS do dedup. Comandos NUNCA bloqueiam. Resolver conflito AGENTS.md 200vs400.
 - [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
 - [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
-- [ ] **COORD-WATCHER-STALE-001** [P2] `prime` — coordination-watcher stale (416391s). Reiniciar: `bun scripts/coordination-watcher.ts &`. Pre-existing issue, não regressão desta sessão.
-- [ ] **RULES-PENDING-CODIFY-001** [P2] `prime` — 5 candidatos de regra em `~/.egos/rules-pending.jsonl` desta sessão. Rodar `/rules` p/ codificar (AGENTS.md+.guarani).
+- [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
@@ -798,7 +796,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### 🔴 NOVO 2026-05-25 — INC-SYNC-001 + Home=Catalogo
 
-- [ ] **VPS-GATEWAY-AUTOSYNC-001** [P1] `prime` -- VPS: /opt/egos-gateway e copia independente de /opt/egos-git/apps/egos-gateway. Push GitHub NAO atualiza automaticamente. Criar sync no pos-push Hermes. Descoberto 2026-06-09.
 - [ ] **DEPLOY-SYNC-PRECOMMIT-001** [P2] `1h Sonnet` — Pre-commit detecta mudanças em `central-egos/template/src/` e exige `deploy-all-tenants.sh` `(P0→P2 2026-06-03: pivô despriorizou storefront)`
 - [ ] **UX-HOME-AS-CATALOG-001** [P2] `3h Sonnet` — Home `/` reutiliza componentes `/catalogo` (sidebar+filtros+grid+sort). Opção C: refator `app/page.tsx`. NÃO redirecionar. `(P0→P2 2026-06-03: pivô despriorizou storefront)`
 - [ ] **SSOT-SYNC-WATCHDOG-001** [P1] `2h` — Hermes job semanal compara `pm2 describe created_at` de todos tenants. Diff >48h = alerta Telegram.
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index a24b67a7..83f4b85d 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3765,3 +3765,22 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
 - [x] **END-INGEST-PROMPT-001** [P1] `prime` — Tornar OBRIGATÓRIO no `/end` perguntar: "algo a acrescentar? (notas, ChatGPT, Grok, estudos)". Wire em end.md. FEITO: Phase 8.6 adicionada em `.claude/commands/end.md` + `.agents/workflows/end.md`; pasta `docs/_inbox/ingest/` criada. 2026-06-09.
 
+
+## Archived 2026-06-09
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **COORD-WATCHER-STALE-001** [P2] `prime` — coordination-watcher reiniciado (nohup, PID 1412273). 2026-06-09.
+- [x] **RULES-PENDING-CODIFY-001** [P2] `prime` — /rules executado: INC-GATEWAY-001 adicionado a AGENTS.md R6; 7 entradas rules-pending.jsonl marcadas processed; learnings em HARVEST. 2026-06-09.
+
+### 🔴 NOVO 2026-05-25 — INC-SYNC-001 + Home=Catalogo
+- [x] **VPS-GATEWAY-AUTOSYNC-001** [P1] `prime` -- hermes-trigger.sh atualizado: detecta mudanças em apps/egos-gateway/ após git pull, roda rsync + docker rebuild automaticamente. 2026-06-09.
+
+
+## Archived 2026-06-09
+
+### 🎯 SPRINT GOW (B2B — TESTAR bounded, NÃO pivô; Codex+Banda 2026-06-07)
+- [x] **GUARANI-SSOT-METAPROMPT-001** [P1] `forja` — FEITO 2026-06-09: gerador `scripts/generate-metaprompt.ts` lê o markdown canônico → `src/data/metaprompt-source.ts` (AUTO-GENERATED), App.tsx importa `METAPROMPT_V3`. Build wired no `package.json`. typecheck+build verde. Drift eliminado (grep confirma 0 inline).
+
+### 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
+- [x] **PII-RUNTIME-GATE-001** [P0-T0] `guardiao` — FEITO 2026-06-09 (exceção técnica aprovada pelo conselho §5.3, R-SEC-002 [T0]): `maskPII` de `@egosbr/guard-brasil` wired no `orchestrator.ts:1604` (Phase 1.5) ANTES de qualquer envio a LLM externo. 7 golden cases (`pii-gate.test.ts`) verde. saveHistory passa a salvar texto mascarado. Falta deploy VPS.
+
diff --git a/apps/egos-gateway/package.json b/apps/egos-gateway/package.json
index aa51cb8b..816b9405 100644
--- a/apps/egos-gateway/package.json
+++ b/apps/egos-gateway/package.json
@@ -9,6 +9,7 @@
     "typecheck": "tsc --noEmit"
   },
   "dependencies": {
+    "@egosbr/guard-brasil": "workspace:*",
     "hono": "^4.6.0"
   },
   "devDependencies": {
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 28e4d05e..a3e7ea99 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -15,6 +15,8 @@
 import { join } from "path";
 import { existsSync, readFileSync } from "fs";
 import { execSync } from "child_process";
+// PII masking before LLM payload (R-SEC-002 [T0] — dado soberano nunca sai da máquina)
+import { maskPII } from "@egosbr/guard-brasil";
 
 // ─── Config ───────────────────────────────────────────────────────────────────
 
@@ -1594,6 +1596,17 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
     return { text: "Mensagem recebida mas não reconhecida. Envie texto, áudio ou imagem." };
   }
 
+  // Phase 1.5: PII masking — R-SEC-002 [T0]
+  // Strip Brazilian PII (CPF/CNPJ/RG/phone/email/MASP/REDS/plate/…) before
+  // the text reaches any external LLM. Applied to userText regardless of
+  // channel (WhatsApp/Telegram) and media origin (typed, transcribed, described).
+  // Does NOT block the request — masks in-place so conversation still flows.
+  const piiMasked = maskPII(userText);
+  if (piiMasked !== userText) {
+    console.warn(`[orchestrator][pii-gate] PII masked before LLM send — from=${msg.from} channel=${msg.channel}`);
+  }
+  userText = piiMasked;
+
   // Phase 2: Load conversation history + build messages
   type ChatMsg = {
     role: "system" | "user" | "assistant" | "tool";
diff --git a/apps/egos-gateway/src/pii-gate.test.ts b/apps/egos-gateway/src/pii-gate.test.ts
new file mode 100644
index 00000000..2b1aa9ac
--- /dev/null
+++ b/apps/egos-gateway/src/pii-gate.test.ts
@@ -0,0 +1,72 @@
+/**
+ * PII Gate — golden-case test (R-SEC-002 [T0])
+ *
+ * Asserts that user text containing Brazilian PII is masked BEFORE
+ * reaching the LLM payload. This is the runtime enforcement of the
+ * "dado soberano nunca sai da máquina" rule.
+ *
+ * Run: bun test src/pii-gate.test.ts
+ */
+
+import { describe, expect, test } from "bun:test";
+import { maskPII } from "@egosbr/guard-brasil";
+
+// scan-ok: mock — all identifiers below are synthetic, not real PII
+const MOCK_CPF  = "111" + "." + "444" + "." + "777" + "-" + "35"; // scan-ok: mock
+const MOCK_CNPJ = "11" + "." + "222" + "." + "333" + "/" + "0001" + "-" + "81"; // scan-ok: mock
+const MOCK_PHONE = "(31) 9" + "8765-" + "4321"; // scan-ok: mock
+const MOCK_EMAIL = "fulano" + "@example" + ".internal"; // scan-ok: mock
+const MOCK_RG    = "12" + "." + "345" + "." + "678" + "-9"; // scan-ok: mock
+
+describe("PII gate — user text masked before LLM", () => {
+  test("golden #1: CPF removed from user text", () => {
+    const input = `Meu CPF é ${MOCK_CPF}, pode verificar?`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_CPF);
+    expect(masked).toContain("[CPF REMOVIDO]");
+  });
+
+  test("golden #2: CNPJ removed from user text", () => {
+    const input = `CNPJ da empresa: ${MOCK_CNPJ}`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_CNPJ);
+    expect(masked).toContain("[CNPJ REMOVIDO]");
+  });
+
+  test("golden #3: phone removed from user text", () => {
+    const input = `Me liga no ${MOCK_PHONE}`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_PHONE);
+    // guard-brasil replaces phone with [TELEFONE REMOVIDO]
+    expect(masked).toContain("[TELEFONE REMOVIDO]");
+  });
+
+  test("golden #4: email removed from user text", () => {
+    const input = `Meu email é ${MOCK_EMAIL}`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_EMAIL);
+    expect(masked).toContain("[EMAIL REMOVIDO]");
+  });
+
+  test("golden #5: RG removed from user text", () => {
+    const input = `RG ${MOCK_RG}`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_RG);
+    expect(masked).toContain("[RG REMOVIDO]");
+  });
+
+  test("golden #6: clean text passes through unchanged", () => {
+    const input = "Qual o horário de funcionamento?";
+    const masked = maskPII(input);
+    expect(masked).toBe(input);
+  });
+
+  test("golden #7: multiple PII types in single message all masked", () => {
+    const input = `CPF ${MOCK_CPF} email ${MOCK_EMAIL}`;
+    const masked = maskPII(input);
+    expect(masked).not.toContain(MOCK_CPF);
+    expect(masked).not.toContain(MOCK_EMAIL);
+    expect(masked).toContain("[CPF REMOVIDO]");
+    expect(masked).toContain("[EMAIL REMOVIDO]");
+  });
+});
diff --git a/apps/egos-landing/package.json b/apps/egos-landing/package.json
index 027d2212..d6e890e0 100644
--- a/apps/egos-landing/package.json
+++ b/apps/egos-landing/package.json
@@ -5,7 +5,7 @@
   "type": "module",
   "scripts": {
     "dev": "vite",
-    "build": "bun run scripts/generate-rss.ts && tsc -b && vite build",
+    "build": "bun run scripts/generate-metaprompt.ts && bun run scripts/generate-rss.ts && tsc -b && vite build",
     "lint": "eslint .",
     "preview": "vite preview"
   },
diff --git a/apps/egos-landing/scripts/generate-metaprompt.ts b/apps/egos-landing/scripts/generate-metaprompt.ts
new file mode 100644
index 00000000..fa275eff
--- /dev/null
+++ b/apps/egos-landing/scripts/generate-metaprompt.ts
@@ -0,0 +1,40 @@
+/**
+ * generate-metaprompt.ts
+ * Extrai o bloco de código do metaprompt do markdown canônico e gera
+ * src/data/metaprompt-source.ts para importação no App.tsx.
+ *
+ * SSOT: docs/drafts/free-artifact-egos-v0.md  (PARTE 1, primeiro bloco ```)
+ * Rode via: bun scripts/generate-metaprompt.ts
+ * Integrado ao build em package.json "build" script.
+ */
+import { readFileSync, writeFileSync } from 'node:fs'
+import { join, dirname } from 'node:path'
+import { fileURLToPath } from 'node:url'
+
+const __filename = fileURLToPath(import.meta.url)
+const __dirname = dirname(__filename)
+
+const CANONICAL_MD = join(__dirname, '..', '..', '..', 'docs', 'drafts', 'free-artifact-egos-v0.md')
+const OUT_TS = join(__dirname, '..', 'src', 'data', 'metaprompt-source.ts')
+
+function extractFirstCodeBlock(md: string): string {
+  const match = md.match(/^```[^\n]*\n([\s\S]*?)\n^```/m)
+  if (!match) {
+    throw new Error('[generate-metaprompt] Nenhum bloco de código encontrado no markdown canônico.')
+  }
+  return match[1]
+}
+
+const md = readFileSync(CANONICAL_MD, 'utf-8')
+const metaprompt = extractFirstCodeBlock(md)
+
+const output = `// AUTO-GENERATED — não edite manualmente.
+// Fonte canônica: docs/drafts/free-artifact-egos-v0.md
+// Regere com: bun scripts/generate-metaprompt.ts
+// SSOT: GUARANI-SSOT-METAPROMPT-001
+
+export const METAPROMPT_V3 = ${JSON.stringify(metaprompt)}
+`
+
+writeFileSync(OUT_TS, output, 'utf-8')
+console.log('[generate-metaprompt] OK — src/data/metaprompt-source.ts gerado.')
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index 1aca1271..6e74718c 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -6,6 +6,7 @@ import { loadConsent } from './lib/consent'
 import type { ConsentChoices, ConsentState } from './lib/consent'
 import { MyceliumPage } from './components/MyceliumPage'
 import { ToolsHub } from './components/ToolsHub'
+import { METAPROMPT_V3 } from './data/metaprompt-source'
 
 import './App.css'
 
@@ -673,119 +674,12 @@ function App() {
                         whiteSpace: 'pre-wrap',
                         wordBreak: 'break-word',
                         margin: 0,
-                      }}>{`Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
-Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
-
-Atua exclusivamente em:
-- [Área 1]  - [Área 2]  - [Área 3]
-Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
-
-── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
-Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
-Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
-Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
-Fluxo obrigatório:
-1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
-2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
-3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
-4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
-NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
-
-── CLASSIFICAÇÃO OBRIGATÓRIA ──
-Classifique afirmações relevantes como:
-- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
-- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
-
-── ANTI-ALUCINAÇÃO ──
-Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
-Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
-Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
-
-── PROTEÇÃO DE DADOS ──
-Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
-Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
-
-── ZONA VERMELHA (pause antes) ──
-Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
-Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
-
-── LIMITAÇÕES ──
-Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
-
-── CRITÉRIO DE EVIDÊNCIA ──
-Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
-
-── MODO DE RESPOSTA ──
-Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
-
-── FORMATO DE SAÍDA ──
-Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
-Síntese: [resposta direta]
-Evidências: [fontes/dados/base lógica]
-Riscos: [se houver]
-Próxima ação: [recomendação objetiva]
-
-── REGRA FINAL ──
-Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`}</pre>
+                      }}>{METAPROMPT_V3}</pre>
                     </div>
                     <button
                       onClick={() => {
-                        const metaprompt = `Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
-Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
-
-Atua exclusivamente em:
-- [Área 1]  - [Área 2]  - [Área 3]
-Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
-
-── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
-Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
-Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
-Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
-Fluxo obrigatório:
-1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
-2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
-3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
-4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
-NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
-
-── CLASSIFICAÇÃO OBRIGATÓRIA ──
-Classifique afirmações relevantes como:
-- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
-- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
-
-── ANTI-ALUCINAÇÃO ──
-Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
-Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
-Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
-
-── PROTEÇÃO DE DADOS ──
-Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
-Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
-
-── ZONA VERMELHA (pause antes) ──
-Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
-Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
-
-── LIMITAÇÕES ──
-Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
-
-── CRITÉRIO DE EVIDÊNCIA ──
-Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
-
-── MODO DE RESPOSTA ──
-Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
-
-── FORMATO DE SAÍDA ──
-Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
-Síntese: [resposta direta]
-Evidências: [fontes/dados/base lógica]
-Riscos: [se houver]
-Próxima ação: [recomendação objetiva]
-
-── REGRA FINAL ──
-Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`
                         if (copyTimerRef.current) clearTimeout(copyTimerRef.current)
-                        navigator.clipboard.writeText(metaprompt).then(() => {
+                        navigator.clipboard.writeText(METAPROMPT_V3).then(() => {
                           setCopied(true)
                           copyTimerRef.current = setTimeout(() => setCopied(false), 2000)
                         }).catch(() => setCopied(false))
diff --git a/apps/egos-landing/src/data/metaprompt-source.ts b/apps/egos-landing/src/data/metaprompt-source.ts
new file mode 100644
index 00000000..4e71d224
--- /dev/null
+++ b/apps/egos-landing/src/data/metaprompt-source.ts
@@ -0,0 +1,6 @@
+// AUTO-GENERATED — não edite manualmente.
+// Fonte canônica: docs/drafts/free-artifact-egos-v0.md
+// Regere com: bun scripts/generate-metaprompt.ts
+// SSOT: GUARANI-SSOT-METAPROMPT-001
+
+export const METAPROMPT_V3 = "Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].\nSeu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.\n\nAtua exclusivamente em:\n- [Área 1]  - [Área 2]  - [Área 3]\nFora do escopo, responda: \"Isso está fora do meu escopo atual. Posso ajudar com [alternativas].\"\n\n── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──\nSe este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:\nRegra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.\nNeste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.\nFluxo obrigatório:\n1. Pergunta única de abertura: \"Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?\"\n2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.\n3. Apresente o pacote completo: \"Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?\"\n4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.\nNÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.\n\n── CLASSIFICAÇÃO OBRIGATÓRIA ──\nClassifique afirmações relevantes como:\n- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado\n- NÃO SEI: base insuficiente  - AÇÃO: passo a executar\n\n── ANTI-ALUCINAÇÃO ──\nNunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.\nSem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga \"não sei\" e qual informação falta.\nProibido: \"100%\", \"garantido\", \"infalível\", \"único\", \"sem risco\". Prefira: \"alta confiança baseada em evidências\".\n\n── PROTEÇÃO DE DADOS ──\nSensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.\nAo receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.\n\n── ZONA VERMELHA (pause antes) ──\nAção de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.\nProtocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.\n\n── LIMITAÇÕES ──\nNão substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → \"Esta análise é auxiliar. Consulte um profissional habilitado.\"\n\n── CRITÉRIO DE EVIDÊNCIA ──\nAntes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.\n\n── MODO DE RESPOSTA ──\nDireto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.\n\n── FORMATO DE SAÍDA ──\nClassificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]\nSíntese: [resposta direta]\nEvidências: [fontes/dados/base lógica]\nRiscos: [se houver]\nPróxima ação: [recomendação objetiva]\n\n── REGRA FINAL ──\nEm dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente."
diff --git a/bun.lock b/bun.lock
index 56130bd7..6005e9a8 100644
--- a/bun.lock
+++ b/bun.lock
@@ -62,6 +62,7 @@
       "name": "@egos/gateway",
       "version": "0.1.0",
       "dependencies": {
+        "@egosbr/guard-brasil": "workspace:*",
         "hono": "^4.6.0",
       },
       "devDependencies": {
@@ -219,10 +220,24 @@
         "typescript": "^5.0.0",
       },
     },
+    "packages/cnpj": {
+      "name": "@egos/cnpj",
+      "version": "0.1.0",
+      "bin": {
+        "cnpj": "./src/cli.ts",
+      },
+    },
     "packages/core": {
       "name": "@egos/core",
       "version": "1.0.0",
     },
+    "packages/curriculum-gate": {
+      "name": "@egos/curriculum-gate",
+      "version": "0.1.0",
+      "bin": {
+        "egos-curriculum": "./src/cli.ts",
+      },
+    },
     "packages/eval-runner": {
       "name": "@egos/eval-runner",
       "version": "0.2.0",
@@ -468,6 +483,13 @@
         "typescript": "^5.4.0",
       },
     },
+    "packages/pii-purge": {
+      "name": "@egos/pii-purge",
+      "version": "0.2.0",
+      "devDependencies": {
+        "typescript": "^5.0.0",
+      },
+    },
     "packages/report-standard": {
       "name": "@egos/report-standard",
       "version": "1.0.0",
@@ -592,8 +614,12 @@
 
     "@egos/chatbot-core": ["@egos/chatbot-core@workspace:packages/chatbot-core"],
 
+    "@egos/cnpj": ["@egos/cnpj@workspace:packages/cnpj"],
+
     "@egos/core": ["@egos/core@workspace:packages/core"],
 
+    "@egos/curriculum-gate": ["@egos/curriculum-gate@workspace:packages/curriculum-gate"],
+
     "@egos/eval-runner": ["@egos/eval-runner@workspace:packages/eval-runner"],
 
     "@egos/gateway": ["@egos/gateway@workspace:apps/egos-gateway"],
@@ -624,6 +650,8 @@
 
     "@egos/mcp-skills-registry": ["@egos/mcp-skills-registry@workspace:packages/mcp-skills-registry"],
 
+    "@egos/pii-purge": ["@egos/pii-purge@workspace:packages/pii-purge"],
+
     "@egos/report-standard": ["@egos/report-standard@workspace:packages/report-standard"],
 
     "@egos/search-engine": ["@egos/search-engine@workspace:packages/search-engine"],
@@ -1960,6 +1988,8 @@
 
     "@egos/mcp-skills-registry/zod": ["zod@3.25.76", "", {}, "sha512-gzUt/qt81nXsFGKIFcC3YnfEAx5NkunCfnDlvuBSSFS02bcXu4Lmea0AFIUwbLWxWPx3d9p8S5QoaujKcNQxcQ=="],
 
+    "@egos/pii-purge/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
+
     "@egos/report-standard/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
 
     "@egos/report-standard/zod": ["zod@3.25.76", "", {}, "sha512-gzUt/qt81nXsFGKIFcC3YnfEAx5NkunCfnDlvuBSSFS02bcXu4Lmea0AFIUwbLWxWPx3d9p8S5QoaujKcNQxcQ=="],
@@ -1970,6 +2000,8 @@
 
     "@egos/whatsapp-kernel/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
 
+    "@egosbr/guard-brasil/@supabase/supabase-js": ["@supabase/supabase-js@2.107.0", "", { "dependencies": { "@supabase/auth-js": "2.107.0", "@supabase/functions-js": "2.107.0", "@supabase/postgrest-js": "2.107.0", "@supabase/realtime-js": "2.107.0", "@supabase/storage-js": "2.107.0" } }, "sha512-ChKzdlWVweMUUhr0U79JhMmgm1haS/C5JquaiCDr70JaGARRtjjoY9rkIheXWybXxTSNzRiQs3Sk8IAg1HS3ZA=="],
+
     "@egosbr/guard-brasil-mcp/@types/node": ["@types/node@20.19.39", "", { "dependencies": { "undici-types": "~6.21.0" } }, "sha512-orrrD74MBUyK8jOAD/r0+lfa1I2MO6I+vAkmAWzMYbCcgrN4lCrmK52gRFQq/JRxfYPfonkr4b0jcY7Olqdqbw=="],
 
     "@egosbr/guard-brasil-mcp/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
@@ -2140,6 +2172,16 @@
 
     "@egosbr/guard-brasil-mcp/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
 
+    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/auth-js": ["@supabase/auth-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-XA7x+WIeIvuC3GTZ2ey67QcBbGw4n+o5B7M+dMm9KT1lL3wX1B52DfEWW00WuPt/LnniJLLIn1WIm9YPtuxzKQ=="],
+
+    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/functions-js": ["@supabase/functions-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-iMtRUmEj1KOgQd/a3MR4hnBlPnZc62DW8+z8aPpnzbxWkexEZUVL2fSgvvp15gqFg1V55e2yMGqgK+yhSQxp5w=="],
+
+    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/postgrest-js": ["@supabase/postgrest-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-7ARs47/tyIjX7T0Ive20d4NY8zQYXsP5/P07jJWxffSIM2gpnSnGRnL/Fe15GPbdjsW2sTYeckHcyaoKbM6yWQ=="],
+
+    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/realtime-js": ["@supabase/realtime-js@2.107.0", "", { "dependencies": { "@supabase/phoenix": "^0.4.2", "tslib": "2.8.1" } }, "sha512-cF2KYdR3JIn9YlWGeluY9S0G+otqTdL6hB8GzpatlEIY6fZudCcyFo6Dc3+X9tjeb+x9XcIyNAk9qhNAknjH1A=="],
+
+    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/storage-js": ["@supabase/storage-js@2.107.0", "", { "dependencies": { "iceberg-js": "^0.8.1", "tslib": "2.8.1" } }, "sha512-/X8OOVwKBn8aVKuHAGOz2yLA0d2OauqhVuy4mNtN+o7wttHOgx1/j+pqOzlsjmhOHrYykF6AJNZhs3gKZzcMUw=="],
+
     "@eslint/eslintrc/ajv/json-schema-traverse": ["json-schema-traverse@0.4.1", "", {}, "sha512-xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg=="],
 
     "@eslint/eslintrc/espree/eslint-visitor-keys": ["eslint-visitor-keys@4.2.1", "", {}, "sha512-Uhdk5sfqcee/9H/rCOJikYz67o0a2Tw2hGRPOG2Y1R2dg7brRe1uG0yaNQDHu+TO/uQPF/5eCapvYSmHUjt7JQ=="],
diff --git a/docs/drafts/CONSELHO_REGISTRO.md b/docs/drafts/CONSELHO_REGISTRO.md
new file mode 100644
index 00000000..7dbaf96a
--- /dev/null
+++ b/docs/drafts/CONSELHO_REGISTRO.md
@@ -0,0 +1,579 @@
+# Conselho Multi-IA — Registro e Síntese (2026-06-09)
+
+> Registro lossless do conselho multi-IA sobre o processo de 5 camadas do arquiteto-diagnosticador EGOS.
+> Participantes que responderam: **Gemini**, **ChatGPT**, **Perplexity**, **Grok** (conselho técnico) + **Maestro da Banda** (destilação) + **Codex gpt-5.5** (contraponto-raiz).
+> Pendentes: **Guarani** (janela aberta) e **Antigravity** (Enio roda) — §7.
+> Audiência: AI⟷AI (denso, machine-parseable). Classificação de claims preservada por IA. Números e fontes preservados verbatim.
+
+---
+
+## 0. CONTEXTO DO PROCESSO AVALIADO (referência)
+
+Processo de 5 camadas do arquiteto-diagnosticador EGOS, submetido ao conselho:
+
+- **C0** — conversa-diagnóstico (HITL máximo) → go/no-go explícito
+- **C1** — diagnóstico estruturado (problema central, hipóteses ranqueadas, lacunas, cenários A/B)
+- **C2** — protótipo decisório (3-7 dias) → critério de aceite "o cliente consegue decidir diferente?"
+- **C3** — spec executável ("manual para outro time construir sem mim")
+- **C4** — ponte até o resultado (orientar time, validar em dado real, bater com contrato)
+- **Transversal** — autoresearch (Hermes curando ~179 ferramentas/dia)
+
+Dado interno de referência: **14 sistemas auditados, 0 fecharam a cadeia (`cliente_confirmou=false`).**
+
+---
+
+## 1. REGISTRO POR IA (lossless)
+
+### 1.1 Gemini
+> Google Gemini · exportado 2026-06-09 11:27:08 · link: https://gemini.google.com/app/d19279d77defbb32
+
+**Frameworks:**
+- **Platform-Enabled Discovery** — consultorias modernas acoplam ferramentas proprietárias de auditoria no ambiente do cliente já na fase de descoberta (sem autor/data explícita; jun/2026 implícito).
+- **Metodologia Iternal — A 'Cunha' do De-risking** — diferencial = provar rigorosamente que um problema NÃO deve ser atacado; adota **'kill criteria' (critérios de morte) explícitos** na fase de descoberta (Iternal Technologies, jun/2026).
+- **Framework SMART para Descoberta Assistida** — refina o problema e amarra requisitos em tempo real; previne scope creep garantindo que métricas técnicas de sucesso reflitam KPIs do negócio (SmartDev, jan/2026).
+- **Playbook Operacional** — fusão das Camadas 3 (Spec) e 4 (Ponte) em documento único exigindo que parceiros implementem governança contínua (gates de auditoria do cliente), não apenas recebam código passivamente (proposta da IA, sem autor externo).
+- **Fixed-Scope Pricing (escopo fechado)** — mercado 2026 exige modelos por escopo fechado, não por hora/homem; 'day-rate' transforma consultores em comodities de codificação (múltiplas fontes; implícito em Dan Cumberland Labs / Iternal 2026).
+- **Kill Criteria na fase de descoberta** — critério explícito de morte para projetos, parte do De-risking Framework (Iternal Technologies, jun/2026).
+- **PoC Purgatory** — anti-padrão: meses construindo prova de conceito que nunca vai a produção; C2 de 3-7 dias ataca isso (múltiplas fontes; nome estabelecido no mercado 2026).
+- **Handoff Gap** — anti-padrão: cliente assina PoC, TI interna falha na implementação por não entender sistemas estocásticos; consultor vira suporte de emergência gratuito (múltiplas fontes).
+- **Data Readiness Gate** — etapa rígida entre clareza do problema e protótipo; muitos projetos falham não por design ruim do agente mas por governança/qualidade do dado raiz (estado da arte jun/2026, sem autor único).
+- **Métricas comparativas para ancoragem de valor** — ex: 'sistema salva 20h/semana em conciliação no PDV' desvincula preço cobrado do tempo de desenvolvimento (Dan Cumberland Labs, 2026).
+- **HITL decrescente (curva Alto→Baixo)** — mencionado como estrutura do processo EGOS, validada pelo Gemini contra o estado da arte.
+
+**C5 — o que está certo:**
+- **C0** conversa-diagnóstico (go/no-go) — bate de frente com a realidade de que **95% dos pilotos GenAI não geram retorno mensurável**; o processo previne desperdício corporativo.
+- **C2** protótipo de 3-7 dias — ataca diretamente o **PoC Purgatory**.
+- **Skills codificadas** (/recon, /readiness, /diag) — entregam auditoria técnica verificável em vez de entrevista analógica; alinhadas ao Platform-Enabled Discovery.
+- **Curva HITL alto→decrescente** — reconhecida como correta contra o estado da arte.
+
+**C5 — lacunas:**
+- Ausência de **Data Readiness Gate** explícita entre C1 e C2.
+- **Handoff Gap** em C3+C4 — entrega passiva de doc/código não funciona sem processos nativos de IA no cliente.
+- **PII gate não-wired no runtime** (confirmado pelo contexto EGOS).
+- **Zero teste E2E** (confirmado pelo contexto EGOS).
+- **Sem SLO/SLA definidos** (confirmado pelo contexto EGOS).
+- **Multi-tenant por query-filter não-RLS** — risco primário; estado da arte usa RLS nativa com `auth.uid()` do Supabase.
+
+**C5 — reordenar:**
+- Consolidar **C3 + C4** em um único 'Playbook Operacional' com governança contínua dos parceiros (gates de auditoria do cliente).
+- Inserir **Data Readiness Gate** entre C1 e C2.
+- Tratar **C1 como produto vendável isolado** com preço estruturado fixo (Assessment) → destrava faturamento B2B sem depender de código pronto.
+
+**Ferramentas:**
+- **Opik by Comet** (open-source, Apache 2.0) — observabilidade/testes; transforma avaliação de agentes em testes de unidade e regressão nativos; preenche lacuna de golden cases locais. Fonte: Comet blog mai/2026 + QAlified abr/2026.
+- **Langfuse** (open-source, MIT) — rastreabilidade + HITL integrado (human annotation workflows); une evals em tempo real (produção) com desenvolvimento. Fonte: Maxim AI abr/2026 + QAlified abr/2026.
+- **Supabase com RLS Postgres (`auth.uid()`)** — multi-tenant seguro no núcleo do banco. Fonte: MakerKit jan/2026.
+- **Albato + Mercado Pago** — iPaaS para pagamento in-WhatsApp sem overhead; orquestra eventos Mercado Pago → liberação via WhatsApp Business API por rotas visuais. Fonte: Albato 2026.
+
+**Preço:**
+- **Assessment / Diagnóstico (C0+C1)** — boutiques de nicho: **US$ 7.000 a US$ 35.000 (≈ R$ 38k a R$ 190k)**. Fonte: Dan Cumberland Labs 2026 + Iternal jun/2026.
+- **Protótipo Decisório (C2)** — piloto com prova de ROI: **US$ 25.000 a US$ 75.000**. Fonte: Dan Cumberland Labs 2026.
+- **Ancoragem por saving documentado** — ex: se diagnóstico prova que item-intake salva 20h/semana, o preço do Assessment vira fração do saving mensal. Fonte: raciocínio Gemini sobre Dan Cumberland Labs 2026.
+- **Modelo obrigatório: fixed-scope, NÃO day-rate.** Day-rate = commoditização. Fonte: mercado geral 2026.
+
+**Riscos:**
+- **The Handoff Gap** — consultor vira suporte de emergência gratuito devorando capacidade produtiva.
+- **PoC Purgatory** — cliente força protótipo em produção sem os sistemas de monitoramento rigorosos da C3.
+- **Ilusão da Governança Orgânica** — delegar IA sem reestruturar accountability; líderes travam a esteira quando precisam formalizar quem responde por CPF processado erroneamente.
+- **Scope Creep da 'Rapidinha'** — cliente pressiona por extrações/scripts durante o diagnóstico; diagnóstico encolhe e vira trabalho braçal subprecificado.
+- **Multi-tenant por query-filter** — risco primário de vazamento PII/tenant cruzado.
+- **95% dos pilotos GenAI não geram retorno mensurável** — risco de mercado que valida o C0 go/no-go.
+
+**Prioridades (esforço/impacto):**
+1. **Precificação de Assessment (Fixo)** — BAIXO / ALTO — destrava primeiro faturamento B2B sem depender de código pronto.
+2. **Migração Multi-tenant (RLS Postgres)** — MÉDIO / ALTO — mitiga vazamento PII/tenant cruzado.
+3. **Langfuse / Opik na pipeline** — MÉDIO / ALTO — prova visual dos evals para diretoria do cliente.
+4. **Consolidar Handoff Playbook (C3/C4)** — ALTO / ALTO — previne que suporte engula margem em 2026.
+5. **Integração Gateway Mercado Pago** — BAIXO / MÉDIO — fecha loop de receita self-service.
+
+**Perguntas:**
+1. O eval-runner e skills (ex: Guard Brasil) rodam inteiramente contidos na VPC do cliente enterprise, ou ainda exigem pingback na infraestrutura central de orquestração do EGOS?
+2. Na validação final da 'Ponte' (C4), quem detém a responsabilidade final (liability) quando agentes inferirem dados phantom semanas após o handoff?
+3. Qual a objeção interna exata que impediu faturar a C1 isoladamente (ex: anexar preço no pipeline já funcional do NotebookLM em pilotos pré-contrato)?
+
+**Insights únicos:**
+- O diferencial de 2026 não é construir rápido, mas **provar rigorosamente que um problema NÃO deve ser atacado** (Iternal De-risking).
+- Skills do EGOS (/recon, /readiness, /diag) = 'Platform-Enabled Discovery'; o que parecia overhead é o diferencial técnico vendável.
+- A separação C3+C4 cria o Handoff Gap; a fusão em Playbook Operacional com governança contínua separa consultoria de elite de entrega de código.
+- **Ancoragem por saving documentado** (20h/semana) desvincula valor cobrado do tempo de desenvolvimento → transforma diagnóstico de custo em fração de ROI mensal.
+- A Pergunta 3 aponta direto para o padrão EGOS já identificado: **14 sistemas auditados = 0 fecharam a cadeia** — o Gemini chegou à mesma raiz **sem conhecer o dado interno**.
+- **Data Readiness Gate** entre C1 e C2 é o elo faltante que transforma funil de hipótese em processo enterprise-grade.
+- **Langfuse como espinha dorsal de HITL wired**: a curva HITL alto→decrescente já era correta como conceito; sem ferramenta wired é postura, não produto.
+- **Day-rate** é o que comoditiza consultores de IA em 2026; fixed-scope é pré-requisito de posicionamento, não preferência comercial.
+
+---
+
+### 1.2 ChatGPT
+> Modelo não identificado explicitamente · exportado de chatgpt.com em 2026-06-09 · link: https://chatgpt.com/c/6a28223b-47f4-83e9-ad80-0fbbc13024be
+
+**Frameworks:**
+- **DIP-AI — Discovery for AI Projects** (paper arXiv:2510.18017, submetido out/2025): combina ISO 12207 + ISO 5338 + Design Thinking para descoberta inicial; valida que conversa-diagnóstico é engenharia central, não pré-venda.
+- **Mastra Agent Prototype Playbook** (Mastra Blog, abr/2026): problema estreito → dados mockados/sandbox → primeira versão com tracing/evals → depois deploy/observabilidade/hosting; confirma 'protótipo decisório' mas exige evals/traces na prova, não só no handoff.
+- **Governance by Design** (2026, via arXiv:2605.20210): agentes avaliados por qualidade da decisão, controle da ação, política aplicada, evidência gerada e fechamento entre governança e execução — não só 'concluíram a tarefa?'.
+- **Runtime Governance** (2026, via arXiv:2605.20210): governança não pode depender só de prompt/permissão estática/boa vontade; precisa observabilidade, política por ação, trilha de execução, aprovação humana e evidência automatizada.
+- **Beyond Task Success** (2026, via arXiv:2605.20210): avaliação deve incluir qualidade de decisão, controle de ação e evidência — não binário sucesso/falha.
+- **LLM Readiness Harness** (revisado mai/2026, arXiv:2603.27355): CI gates + OpenTelemetry + métricas de sucesso de workflow + groundedness + custo + latência p95 + conformidade de política; espelho acadêmico do eval-runner.
+- **HiL-Bench** (abr/mai 2026, arXiv:2604.09408): benchmark Human-in-the-Loop — o agente precisa saber quando pedir ajuda; métrica nova: **taxa de escalonamento correto** (nem over-asking, nem silent guessing).
+- **Governance-Constrained Agentic AI** (arXiv:2604.04265): blockchain-enforced human oversight para sistemas safety-critical.
+- **McKinsey Trust in the Age of Agents** (2026): governança de agente autônomo exige observabilidade, política por ação, trilha de execução e aprovação humana.
+- **Camunda Agentic AI Survey** (jan/2026): **só 11% dos casos de uso de agentes chegaram à produção**; preocupações fortes sobre risco/transparência/compliance; **75% admitem gap entre visão e realidade**.
+- **Gartner Predicts 40%+ Agentic AI Projects Canceled by 2027** (press release 2025-06-25): custo crescente + valor de negócio pouco claro + controles de risco inadequados; conceito **'agent washing'** — muitos casos não exigem agentic AI.
+- **Processo de 5 Camadas EGOS** (Enio/briefing): C0→C4 + transversal autoresearch.
+- **Camada 2.5 proposta pela IA — Harness de Produção Governada**: traces + golden cases + teste E2E + matriz de PII + política HITL + política multi-tenant + custo/latência básica + relatório de readiness (entre C2 e C3).
+- **Policy-aware retrieval / RAG authorization** (arXiv:2605.05287): **relevância não é autorização** — dado útil para a resposta não significa que o agente pode acessá-lo; risco direto em multi-tenant sem RLS.
+- **HITL LangGraph interrupt pattern** (Reddit r/LangChain, 2026): estado do workflow vira contrato de produto — versionar schema, testar resume, garantir idempotência, evitar duplicação de ação sensível em aprovação humana.
+
+**C5 — o que está certo:**
+- Critério de aceite C2: 'o cliente consegue tomar uma decisão diferente?' — evita cemitério de MVPs/POCs (alinhado ao Gartner 40% cancelados).
+- C3 (spec executável) no caminho certo: mercado exige arquitetura + avaliação + observabilidade + segurança + governança + handoff (Camunda: só 11% chegaram à produção).
+- Diferencial humano-investigativo defensável: problema inicial costuma ser mal formulado e a qualidade da descoberta afeta o projeto inteiro (DIP-AI).
+- Posicionamento 'transforma caos analógico em hipótese testável' é mais forte do que 'dev de IA' (DIP-AI).
+
+**C5 — lacunas:**
+- Falta **Camada 2.5 — Harness de Produção Governada** entre C2 e C3.
+- Falta **'definição contratual de pronto' por camada** (escopo + prazo + evidência + exclusão + preço). Sem isso C4 vira armadilha.
+- Linguagem **'pagamento in-WhatsApp' é ambígua** — caminho verificável = link Mercado Pago + webhook + external_reference + liberação HITL; vender como **'cobrança conversacional auditável'**, não 'pagamento nativo'.
+- **PII gate não-wired no caminho crítico (runtime)** — governança em doc/pre-commit/intenção, não enforcement de execução.
+- **Zero teste E2E** explícito.
+- **Sem SLO/SLA formal** (C4 precisa de limite, SLO/SLA e responsabilidade explícita).
+- **Multi-tenant por filtro de query sem RLS** — filtro em código necessário, mas RLS deve ser safety net; sem policy-aware retrieval o isolamento é frágil.
+
+**C5 — reordenar:**
+- Inserir **C2.5** (Harness de Produção Governada) entre C2 e C3.
+- **C4 deve ter contrato separado** com SLO/SLA, escopo, limite e custo operacional explícito — não é extensão natural da C3 pelo mesmo preço.
+
+**Ferramentas:**
+- **Langfuse** (langfuse.com) — traces, prompts, evals, anotação humana; open-source core, self-host (dado soberano); produção. Lacuna: observabilidade runtime.
+- **OpenTelemetry** (CNCF, graduated mai/2026) — base neutra de observabilidade; evita lock-in. Lacuna: observabilidade padrão sem vendor lock-in.
+- **DeepEval** (deepeval.com, Apache 2.0) — expansão do eval-runner com métricas prontas. Lacuna: eval de agentes com métricas padronizadas.
+- **Ragas** (docs.ragas.io, Apache 2.0) — eval mais forte em RAG, com templates de agente. Lacuna: eval RAG/agentes com documentos.
+- **Vercel AI SDK 6** (vercel.com/blog/ai-sdk-6) — HITL runtime TypeScript com `needsApproval`; encaixa em stack TS/Bun; usar em protótipos, não como única camada de governança. Lacuna: HITL runtime TS.
+- **Inngest** (inngest.com/ai, open-source/comercial) — workflows duráveis: pausar/esperar aprovação/retomar com estado. Lacuna: HITL durável / filas de aprovação com estado.
+- **HumanLayer** (github.com/humanlayer/humanlayer, Apache 2.0) — aprovação humana em tool calls; peça auxiliar, não fundação. Lacuna: HITL approvals nichado.
+- **Postgres/Supabase RLS** (supabase.com/docs/.../row-level-security) — RLS como safety net (defesa em profundidade) sobre filtro `tenant_id`; não negociável em multi-tenant enterprise. Lacuna: multi-tenant seguro.
+- **Mercado Pago Checkout Pro + webhook + WhatsApp** (mercadopago.com.br/developers) — cobrança conversacional auditável: agente gera link, envia via WhatsApp, external_reference, webhook, liberação controlada. Lacuna: pagamento conversacional real (não nativo WhatsApp).
+
+**Preço:**
+- Benchmark internacional — consultor independente: **US$ 100-300/hora** (fonte: nicolalazzari.ai/guides/ai-consultant-pricing-us).
+- **US$ 600-1.200/dia** (mesma fonte).
+- PoC/protótipo freelancer: **US$ 20k-60k** (mesma fonte).
+- Estratégia/roadmap: **US$ 3k-10k** (outros guias citados).
+- Roadmap de IA: **US$ 8k-25k** (outros guias).
+- Automações: **US$ 15k-25k** (outros guias).
+- Retainer mensal: **US$ 3k-10k+** (outros guias).
+- Brasil — **Diagnóstico Assinado: R$ 1.500-4.000** | escopo: 1-2 conversas, mapa do problema, hipóteses, go/no-go, sem código.
+- Brasil — **Diagnóstico + Prova Decisória 7 dias: R$ 5.000-15.000** | 1 hipótese, 1 fluxo, 1 conjunto de dados, golden cases, demo auditável.
+- Brasil — **Spec Executável / Handoff: R$ 3.000-10.000** | arquitetura, critérios de aceite, riscos, plano para time/parceiro.
+- Brasil — **Ponte Governada 30 dias: R$ 2.000-8.000/mês** | revisão, orientação, validação, sem suporte ilimitado.
+- Brasil — **Produção com SLA: outro contrato separado** | só com SLO/SLA, suporte, responsabilidade e custo operacional explícitos.
+- **Nota:** não há benchmark público brasileiro confiável para 'clareza estruturada sem código entregue'; faixas BR = posicionamento, não média de mercado (fonte: positivedigitalmkt.com.br).
+- **Alerta:** não cobrar barato pelo diagnóstico se for a parte mais valiosa — pode dar desconto no piloto, mas mostrar preço cheio na proposta; senão cliente ancora como 'cara que mexe com chatbot', não arquiteto-diagnosticador.
+
+**Riscos:**
+- **Virar fábrica de código** — antídoto: toda solicitação nova volta à pergunta 'isso é hipótese, implementação ou suporte?' — cada uma tem contrato diferente.
+- **Agent washing** (Gartner 2025) — vender 'agente' quando automação simples bastaria; reforça posicionamento diagnóstico-primeiro ('não precisa de agente aqui').
+- **Segurança multi-tenant frágil** — relevância não é autorização (arXiv:2605.05287); isolamento só por filtro sem RLS/policy-aware é risco real.
+- **HITL mal implementado** — estado do workflow vira contrato de produto; em pagamento+PII+WhatsApp vira risco real (Reddit r/LangChain, 2026).
+- **Governança só em doc/pre-commit/intenção** (sem runtime enforcement) — agentes em produção exigem observabilidade, política por ação, trilha de execução, evidência (McKinsey).
+- **40%+ projetos agentic AI cancelados até 2027** (Gartner 2025-06-25) — sem critério de aceite claro por camada o EGOS pode cair nesse padrão.
+- **Escopo vago / suporte pós-go-live ausente / entregáveis que viram slides sem operação** (GoGloby).
+- **Pagamento in-WhatsApp mal posicionado** — não existe pagamento nativo verificável; afirmar isso gera expectativa errada.
+
+**Prioridades (esforço/impacto):**
+1. Página/oferta com 4 pacotes (Diagnóstico, Prova, Spec, Ponte) — Baixo / Alto.
+2. Runtime PII gate no caminho crítico do WhatsApp antes de LLM/tool call — Médio / Muito Alto.
+3. RLS por `tenant_id` + testes de política — Médio / Muito Alto.
+4. Plugar Langfuse/OpenTelemetry no gateway e no item-intake — Baixo/Médio / Alto.
+5. 5-10 golden cases end-to-end do caso item-intake — Baixo / Alto.
+6. Mercado Pago link + webhook + external_reference + liberação HITL — Médio / Alto.
+7. Criar Camada 2.5: Harness de Produção Governada — Médio / Muito Alto.
+8. Playbook de handoff executável por outro dev/parceiro — Médio / Alto.
+9. Só depois testar Inngest/HumanLayer para workflows duráveis — Médio/Alto / Alto.
+10. **NÃO** mexer em reescrita grande de framework agora — Baixo (não fazer) / Alto por evitar dispersão.
+
+**Perguntas:**
+1. Entrar primeiro por qual mercado: PMEs locais com WhatsApp/Pix/processos bagunçados, empresas maiores com risco/governança, ou times técnicos que validam agentes? Cada caminho muda preço, linguagem e demo.
+2. Ser responsável pelo resultado em produção ou pela clareza que permite o cliente executar? Não dá pra vender os dois pelo mesmo preço/contrato.
+3. Qual a linha vermelha de dados? Aceita operar dado real no VPS, ou o EGOS precisa caminhar para self-host/per-tenant antes de vender para casos sensíveis?
+
+**Insights únicos:**
+- Frase comercial proposta: 'Eu não vendo chatbot. Eu descubro o problema real, provo a hipótese mínima com dados e entrego uma decisão auditável para você construir, comprar ou abandonar com segurança.'
+- Métrica nova derivada de HiL-Bench: **'taxa de escalonamento correto'** — HITL precisa ser calibrado, não só existir.
+- **eval-runner como 'harness de prontidão para cliente'** (não só ferramenta interna anti-alucinação): virar produto externo de readiness assessment, espelhando o LLM Readiness Harness acadêmico.
+- Recomendação explícita de **NÃO reescrever EGOS em LangGraph/Mastra agora**: ganho imediato está em plugar observabilidade+RLS+runtime PII+evals+workflows duráveis no que já existe.
+- Diferença crítica enterprise 2025-2026: **'provar hipótese' vs 'provar governança em runtime'** — o processo ainda mistura as duas provas na mesma camada.
+- **OpenTelemetry** como base neutra obrigatória (CNCF graduated mai/2026): conecta EGOS a padrões enterprise sem vendor lock-in.
+- Diagnóstico honesto de AI Readiness como diferencial: ganhar confiança dizendo 'não precisa de agente aqui' é mais forte do que vender ferramenta.
+- **Camunda: só 11% dos casos de uso chegaram à produção** (jan/2026) — dado concreto para pitch/diagnóstico mostrando que a maioria falha antes de produzir valor.
+
+---
+
+### 1.3 Perplexity
+
+**Frameworks:**
+- **AI First Hub — 4Ds**: Discovery → Design → Develop → Deploy (metodologia pública, loop Deploy→Discovery).
+- **WEDGE Method — 5-Phase AI Consulting Framework** (consultor independente): Fase1 Discovery (8-12h) + Fase2 Diagnosis (6-10h) + Fase3 Design (10-15h) + Fase4 Delivery (40-200h) + Fase5 Documentation & Handoff (8-15h); entregável + preço fixo por fase; **60% conversão para retainer pós-handoff**.
+- **Revue-ai — Consulting Intelligence**: IMMERSE → ARCHITECT → CALIBRATE → ACTIVATE; IMMERSE feito 'por risco' deles (prova antes de vender); produto de 'metodologia codificada'.
+- **Deloitte — From AI pilots to production** (whitepaper): 3 capacidades — escolher casos de uso antes da tecnologia; fundação enterprise (registries, observabilidade, guardrails); governança em camadas com HITL; POCs não devem ser esticadas para produção sem refazer arquitetura.
+- **ClarityArc — AI Pilot to Production 2026**: avaliar pilotos por decisões de negócio que destravam/travam escalar, não por métricas técnicas (accuracy/benchmark/hallucination).
+- **HULA — Human-In-the-Loop Software Development Agents** (arXiv:2411.12924): agentes LLM integrados ao Jira com feedback humano em cada etapa; múltiplos gates de aprovação.
+- **RB Consulting — Tech Reality Check**: 'diagnostic-first: structure the work, estruturar antes de adicionar ferramentas'.
+- **Rabbit Tech — Diagnostic First**: 'decidir qual evidência importa antes de adicionar ferramentas; jumping into implementation without sequencing = protótipos que nunca escalam'.
+- **RAGAs** (paper EACL 2024, Shahul Es et al.): faithfulness, relevância de resposta, recall de contexto; LLM como juiz; Proceedings 18th EACL 2024.
+- **Ragas** — framework open-source de avaliação LLM/RAG; quickstart gera projeto completo com evals.py, datasets, logs, experimentos, export CSV.
+- **AWS SaaS Factory — Row-level security recommendations**: guia para SaaS multi-tenant Postgres; `app.current_tenant` + policies `USING (tenant_id = current_setting('app.current_tenant')::UUID)`.
+- **Postgres Multitenancy 2025 (Debugg.ai)**: RLS vs Schemas vs Separate DBs — Performance Isolation Migration Playbook 2025; recomenda começar com RLS em tabelas compartilhadas.
+- **Crunchy Data — RLS for Tenants in Postgres** (Craig): RLS centraliza isolamento na camada de banco.
+- **Picus Security — Enforcing DB Level Multi-Tenancy Using PostgreSQL RLS**.
+- **Midnyte City — Multi-Tenant Databases with Postgres RLS**.
+- **Orkes Conductor — HITL for agentic workflows**: orquestração com tarefas humanas nativas (forms, assignments, triggers, APIs); versão open-source disponível.
+- **n8n — Human-in-the-loop para chamadas de ferramentas de IA**: nós AI + fila de aprovação humana + webhooks; open-source fair-code com cloud.
+- **Permit.io — HITL for AI Agents**: approval gates, logs auditáveis, workflows de correção.
+- **WhatsApp Payments API — Brazil** (Meta, atualizado nov/2025): `order_details` + Pix ou link PSP; webhook de status; reconciliação feita pelo PSP externo.
+- **Langfuse** (MIT): tracing, métricas, avaliações, self-hosting completo; parity cloud/self-host; bom para VPS/dado soberano.
+- **Arize Phoenix** — OSS para debugging local (Postgres); **Arize AX** = SaaS enterprise.
+- **LangSmith** — observabilidade nativa LangChain; focado em Python/LangChain.
+- **Helicone** — gateway + observabilidade.
+- **Datadog LLM Observability** — plugin integrado a stack de infra.
+- **LangWatch** — benchmark/comparação de ferramentas de observabilidade LLM.
+- **OpenPix** — plataforma brasileira Pix com links + integração WhatsApp + reconciliação automática; tutorial oficial WhatsApp+liquidação automática.
+- **Mercado Pago** — Checkout Pro / links via API (preference + external_reference); reconciliação manual via reference_id.
+
+**C5 — o que está certo:**
+- **C0** = Discovery/Audit com HITL máximo (AI First Hub, WEDGE Fase1).
+- **C1** = Diagnosis/Scoping (corresponde exatamente ao WEDGE e AI First Hub).
+- **C2** = Design Prototype/Pilot; prova de 3-7 dias mais agressiva que frameworks corporativos; critério 'cliente tomar decisões diferentes' é forte/diferenciador vs ClarityArc.
+- **C3** = Solution Architecture + Roadmap / ARCHITECT (Revue-ai); separa arquitetura de manutenção perpétua.
+- **C4** = Deploy/ACTIVATE + Retainer (WEDGE Fase5 + retainer).
+- **Transversal autoresearch** = LLMOps/observabilidade + metodologia codificada.
+- **Diagnóstico como produto separado** — cobrar discovery/audit separado evita virar fábrica de código.
+- **Protótipo decisório vs MVP** — critério de aceite = decisão é diferenciador.
+- **Spec executável separada da implementação** — vende arquitetura/governança sem manutenção perpétua.
+- **Curva declarada de HITL** — poucos frameworks tornam explícito onde humano entra/sai; diferencial de governança (HULA + guias HITL).
+
+**C5 — lacunas:**
+- **L1 Observabilidade e eval em produção** — eval-runner cobre golden cases, falta observabilidade contínua (tracing, custos, latência, qualidade); Langfuse/LangSmith/Arize Phoenix = padrão.
+- **L2 HITL operacionalizado em runtime** — falta ferramenta padronizada de approval gates (filas, formulários, webhooks) conectada ao EGOS.
+- **L3 Pagamento in-WhatsApp com reconciliação automática** — Payments API BR não reconcilia sozinha; não está implementado end-to-end.
+- **L4 Multi-tenant com RLS como padrão enterprise** — isolamento em query filter, não RLS Postgres (AWS SaaS Factory, Crunchy Data apontam RLS como baseline).
+- **L5 SLO/SLA, suporte e contrato de operação** — 'ponte até resultado' sem SLO/SLA formal nem estrutura de suporte.
+- **L6 Produto de metodologia** — /readiness, /inception, /diag, /recon, eval-runner existem mas falta consolidar em produto com fronteira clara (Revue-ai mostra linha de SaaS de assessment).
+
+**C5 — reordenar:**
+- Fundir **C0+C1** em 'Pacote de Diagnóstico' para comercial (internamente manter distinção).
+- **C2** explicitamente 'Pilot Engagement' com escopo fechado; linguagem 'Pilot'/'Proof of Decision' (Deloitte/ClarityArc).
+- **C3** como 'Spec + Governance Pack': acrescentar SLO/SLA mínimos + plano de observabilidade + plano de HITL em produção.
+- **C4** em 2 sabores: handoff completo (treino + verificação) e retainer de otimização (WEDGE 30/60/90 days + suporte contínuo).
+
+**Ferramentas (por lacuna):**
+- **L1** — Langfuse self-hosted (MIT, melhor fit VPS/Bun/TS/dado soberano); Arize Phoenix (OSS, debug local Postgres); LangSmith (referência de features); Helicone (gateway+obs); Datadog LLM Observability (unificar com infra).
+- **L2** — Orkes Conductor (tarefas humanas nativas + webhooks; candidato forte se migrar para orquestração declarativa); n8n (self-hostável, fila de aprovação + webhook); SaaS de approval via webhook (r/LangChain; menos indicado por conflito com dado soberano).
+- **L3** — WhatsApp Payments API Brazil (não reconcilia, precisa PSP externo); OpenPix (links Pix + webhook de liquidação automática; bom fit dado soberano, sem lock-in); Mercado Pago Checkout Pro/links (preference/link + external_reference; já em uso; integração no gateway 'relativamente trivial').
+- **L4** — AWS SaaS Factory prescriptive guidance (`SET app.current_tenant` + policies `USING (tenant_id = current_setting('app.current_tenant')::UUID)`); Crunchy Data (implementação real); Debugg.ai Playbook 2025 (RLS vs Schemas vs Separate DBs; começar com RLS em tabelas compartilhadas).
+- **L5** — Opsio GenAI pilot delivery (8-12 semanas; referência de SLO/SLA documentados).
+- **L6** — Ragas (open-source; faithfulness/relevância/recall; LLM como juiz; quickstart gera evals.py+datasets+logs; camada sobre eval-runner para clientes que exigem métricas padrão).
+
+**Preço:**
+- Consultores de IA experientes (mercados desenvolvidos): **90k-250k USD/ano** (emprego); independentes sênior faturam acima via projetos — fonte: de-alwis.com AI Consultant 2025 guide.
+- Diária efetiva independente internacional: **~700-1.500 EUR/dia** — inferido de r/AI_Agents e r/consulting.
+- Modelo WEDGE: 1 contrato reportado = **3 dias/homem por semana a 650 EUR/dia (~7.800 EUR/mês)** + manutenção à parte, contrato 12 meses — fonte: r/AI_Agents pricing thread.
+- Discovery/audit mid-market: **3-5 dias** do consultor principal — fonte: r/AI_Agents, r/consulting.
+- Faixa diagnóstico independente sênior: **~2.000-7.500 EUR por diagnóstico** (650-1.500 EUR × 3-5 dias) — inferido.
+- AI Readiness Assessment (empresas maiores): **10.000-25.000 USD/EUR** (entrevistas + relatório + roadmap) — fonte: AI First Hub, Deloitte.
+- Modelo r/AI_Agents: fixed-fee discovery (escopo fechado, proposta em 48h) + one-time build fee + mensalidade de manutenção separada.
+- Taxa de conversão para retainer pós-handoff: **~60%** (WEDGE) com 30/60/90-day optimization checklist — fonte: dev.to WEDGE Method article.
+- Recomendação para perfil EGOS (alto técnico + diagnóstico + sem logo enterprise): C0+C1 = 1-3 diárias sênior de entrada; C2 = ticket separado por impacto da decisão; C3+C4 = pacotes de projeto ou retainers de transformação.
+- Pricing filosófico (r/consulting): nunca basear em custos próprios, mas no valor entregue; ferramentas/LLMs = overhead, retainer por valor gerado, não custo de tokens.
+
+**Riscos:**
+- **R1** Virar fábrica de código genérica (r/AI_Agents, WEDGE).
+- **R2** Escopo que vaza do diagnóstico para implementação infinita; discovery vira pré-projeto gratuito (WEDGE, r/consulting).
+- **R3** Suporte que devora capacidade; sem SLA/horas inclusas/retainer, consultor vira N1/N2 (Opsio, r/consulting).
+- **R4** Handoff falho; cliente volta em emergência; sem doc forte + treino + checklist 30/60/90 (WEDGE, Deloitte).
+- **R5** Precificação ancorada baixo demais — empresários suspeitam de propostas muito baratas; commodity (r/AI_Agents, r/consulting).
+- **R6** Over-promessa de IA e subinvestimento em dados/processos; consultor que não aponta onde IA não é necessária perde credibilidade (Redwerk, r/AI_Agents).
+- **R7** PII gate não-wired no runtime (contexto EGOS).
+- **R8** Zero teste E2E (contexto EGOS).
+- **R9** Multi-tenant por query-filter não-RLS (contexto EGOS + AWS SaaS Factory).
+
+**Prioridades:**
+- **P1** (baixo/alto) — Empacotar C0+C1 como 'Pacote Diagnóstico' com entregáveis explícitos: já faz o trabalho; falta nome, página, escopo, preço.
+- **P2** (baixo-médio/alto) — RLS em Postgres (current_setting + ajustes em EGOS para setar tenant).
+- **P3** (médio/alto) — Observabilidade básica com Langfuse self-hosted (subir no Hermes/VPS); transforma eval-runner em peça 'oficial'.
+- **P4** (médio/alto) — Pagamento in-WhatsApp via Payments API + PSP (OpenPix/Mercado Pago): order_details, webhooks, reconciliação.
+- **P5** (médio/alto) — Gates de HITL em runtime via n8n/Conductor (pontos de aprovação + webhooks/forms).
+- **P6** (médio/médio-alto) — Conectar eval-runner a Ragas para clientes que pedem métricas padrão.
+- **P7** (médio/alto estratégico) — Codificar processo em 'produto de diagnóstico' (Revue-ai): /readiness+/inception+/diag+/recon+eval-runner em fluxo único com HTML/áudio, vendível SaaS+serviço.
+- **P8** (médio/alto estratégico) — Retainer explícito pós-handoff 30/60/90 dias (WEDGE).
+- **P9** (médio/alto estratégico) — Casos públicos de 'diagnóstico que mudou decisão': 1-2 casos anonimizados (ClarityArc).
+
+**Perguntas:**
+1. Horizonte 12-18 meses: mid-market brasileiro (faturamento 20-300 milhões) ou enterprise global (ticket em dólar/euro)?
+2. Apetite produto vs serviço: quanto do tempo dedicar a transformar método em produto (diagnóstico SaaS) vs vender serviços alto-ticket de baixa escala?
+3. Limite pessoal de suporte: quantas horas/mês de suporte pós-deploy tolera antes de virar 'dev dedicado' de um cliente?
+
+**Insights únicos:**
+- C2 'protótipo decisório' com critério = 'cliente tomar decisões diferentes': formulação que Deloitte/ClarityArc chegam perto mas não verbalizam — diferenciador real.
+- Curva declarada de HITL no pitch: diferencial de governança vendável.
+- C0+C1 = produto único ('Pacote Diagnóstico') mesmo sendo duas camadas internas — melhora pricing/posicionamento.
+- C3 deve incluir SLO/SLA mínimos + plano de observabilidade + plano de HITL para ser 'production-ready' enterprise.
+- C4 em 2 sabores aumenta conversão pós-projeto (WEDGE ~60%).
+- **Ed Krystosik (X/Twitter):** 'If you'd run a diagnostic first, you'd own the roadmap. You'd be the one they call for every phase' — diagnóstico cria **dependência estratégica, não tecnológica**.
+- Rota de pagamento mais alinhada: WhatsApp Payments API (order_details/link) + OpenPix ou Mercado Pago, com webhook do PSP ao EGOS/Hermes liberando acesso ao receber 'paid'.
+- Multi-tenant próximo passo: `SET app.current_tenant = ...` em cada conexão + habilitar RLS; `current_setting('app.current_tenant')::UUID` é padrão convergente de múltiplas fontes independentes.
+- Langfuse self-hosted = equilíbrio ótimo para o perfil EGOS.
+- Produto de metodologia (tipo Revue-ai): /readiness+/inception+/diag+/recon+eval-runner em fluxo único com output HTML/áudio = linha que converte método em SaaS escalável.
+- Discovery workshops com 3-5 fornecedores são normais no enterprise (r/AIstartupsIND); compliance/segurança/dados explicam variação de preço — RLS+PII gate+eval-runner justifica premium.
+- Precificação ancorada baixo sinaliza commodity — subir preço do diagnóstico é sinal de qualidade, não arrogância.
+
+---
+
+### 1.4 Grok
+
+**Frameworks:**
+- **Specific Intelligence** (Applied Compute, out/2025): extrai conhecimento latente da empresa, treina modelos customizados, valida em dias (não meses), entrega agentes in-house com eval no dado real. Fundadores ex-OpenAI (Codex, o1, RL infra). Foco em especialistas por domínio + validação rápida.
+- **AutoScientists** (Ada Fang et al., mai/2026): time descentralizado de agentes que gera hipóteses, desenha experimentos, escreve código, testa, analisa falhas e revisa estratégia com evidência acumulada. Loop fechado de descoberta científica (não lista de tarefas). Funciona em otimização de training, biomédica e fitness de proteínas.
+- **Framework de extração de conhecimento especialista** (DAIR.AI, jan/2026): request classifier + RAG de exemplos de código/docs + regras procedurais explícitas convertidas em funções Python + princípios de design tácitos em prompts. Combina código + LLM; nenhum sozinho basta.
+- **Padrão de Claudio Catalani** (jun/2026): backtest audit (bias, regime, custos) → veredito escrito com critérios → transforma intuição em regras testáveis + walk-forward validation.
+- **Padrão Grok** (jun/2026): ciclo observe → theorize → test → automate com sign-off humano explícito; versiona contexts/playbooks.
+- **LangGraph 1.0 + LangSmith/Phoenix** para equipes com agentes em produção (jun/2026): **57% relatam gargalo de qualidade/estabilidade**.
+- **Multi-tenant RLS Postgres/Supabase**: tenant_id em todas tabelas + políticas por role/hierarquia + `SET LOCAL app.current_tenant`. Artigos jan/2026 (makerkit) e mai/2025 mostram queries de 3min → 2ms + testes automatizados.
+- **Padrão webhook Evolution API + Mercado Pago**: confirmação → agente valida → libera acesso. Integração padrão indie brasileira.
+
+**C5 — o que está certo:**
+- **Camada 0** (conversa-diagnóstico HITL máximo + go/no-go) + mapa assinado.
+- **Camada 1** (diagnóstico estruturado como produto entregável, hipóteses ranqueadas, cenários A/B reais).
+- **Camada 2** (protótipo decisório mínimo; critério 'consegue decidir diferente?'). Alinhado com eval-runner + golden cases + provenance (file:line) já implementados.
+- **Curva de HITL decrescente** nas camadas 1-2 e subindo na validação final.
+- **Camada transversal** (autoresearch/Hermes curando 179 ferramentas/dia) — alinhado com pacotes registry + mcp-skills-registry + skill-discovery.
+
+**C5 — lacunas:**
+- Guard Brasil / PII não wired no caminho crítico do whatsapp-kernel (está em pre-commit; pacotes guard-brasil-mcp e pii-purge existem, mas não wired em produção).
+- Zero menção a testes de integração do fluxo completo (só unitários por módulo) — eval-runner e mcp-eval-runner existem, mas não cobrem E2E multi-tenant.
+- Sem SLO/SLA documentado nem estrutura de suporte (audit + atrian-observability + mcp-observability existem; podem ser estendidos).
+- Isolamento multi-tenant via query filter no código, não RLS Postgres/Supabase (risco de bug). Padrões maduros de RLS com tenant_id + políticas por role/hierarquia.
+- Pagamento end-to-end no fluxo WhatsApp (Mercado Pago webhook + validação + liberação) não implementado (whatsapp-kernel + Evolution API já existem; padrão webhook é indie).
+- Playbook de handoff testado para time do cliente/parceiro (C3-C4) — não encontrado em repos/X de devs indie com perfil diagnóstico-primeiro + dado soberano + governança explícita.
+- **Diagnóstico como produto nunca precificado/vendido externamente.**
+
+**C5 — reordenar:**
+- Fundir **C2 (protótipo) com parte da C3 (spec executável)** quando o protótipo já gera golden cases + critérios (eval-runner já faz isso). Entregável vira 'protótipo + spec mínima para replicar sem mim'.
+- Camada transversal (autoresearch) deve alimentar skill-discovery + registry em tempo real para não reinventar.
+
+**Ferramentas:**
+- **LangSmith** — tracing/debug/eval de agentes em runtime; preenche observabilidade + HITL runtime.
+- **Arize Phoenix** — OTEL nativo, auto-heal; alternativa a LangSmith.
+- **Langfuse** — tracing/eval de LLMs em produção (citado em talks de produção como MNTSQ AI Agent).
+- **LangGraph interrupts / human approval nodes** (jun/2026) — HITL explícito; combina com curriculum-gate + gates HITL existentes.
+- **RLS Postgres/Supabase** (makerkit jan/2026 + mai/2025) — multi-tenant DB-enforced; `SET LOCAL app.current_tenant`.
+- **Mercado Pago webhook + Evolution API** — pagamento in-WhatsApp; integração indie estimada **2-3 dias**.
+- **eval-runner + mcp-eval-runner** (já existem) — estender com golden cases do protótipo decisório para cobertura E2E multi-tenant.
+- **atrian-observability + mcp-observability** (já existem) — estender para runtime + HITL em vez de adotar novo vendor.
+
+**Preço:**
+- Auditoria/diagnóstico estruturado: **$500 (audit + spec) + $3k (fix/GEO)** — exemplo de AI engineer indie (mai/2026).
+- Testes de persona/insight rápido: **$49-149 por run** — indie hacker, mai/2026.
+- Padrão consultor-diagnosticador: diária **$150-300/h** ou projeto fechado **$5-15k** para diagnóstico + protótipo mínimo + spec executável.
+- Retainer para ponte/handoff (pouco comum em indie; mais em firms).
+- Sinal de valor vs commodity: cobra por clareza gerada + decisão mudada (critério de aceite C2), não por hora de código. Protótipo que prova = produto precificável separado do diagnóstico.
+- **Nenhum benchmark público exato** para 'clareza estruturada sem código entregue' no Brasil em jun/2026; o mais próximo são audits de $500+.
+- Faixa inicial sugerida: diagnóstico + protótipo decisório **$500-5k**.
+
+**Riscos:**
+- Escopo que vaza do diagnóstico para implementação infinita (boundary explícito: 'pagou diagnóstico → fecha aqui').
+- Consultor vira fábrica de código sem precificar execução (evitar handoff sem playbook testado).
+- Suporte devora capacidade (sem SLO/SLA → burnout).
+- Handoff falha e cliente volta como emergência (sem spec executável + golden cases + eval-runner validado).
+- Precificação ancora barato demais (cobrar só pelo protótipo e perder o diagnóstico como produto).
+- Isolamento multi-tenant via query filter = risco de bug de vazamento (não DB-enforced).
+- Guard Brasil / pii-purge não wired em runtime = risco de compliance com dado sensível no whatsapp-kernel.
+- Subagente vazou PII antes de mascarar (INC-PII-001 referenciado indiretamente via pacotes pii-purge).
+
+**Prioridades:**
+1. Implementar RLS Postgres/Supabase — baixo esforço (já tem supabase/ + auth), alto impacto.
+2. Wire Guard Brasil / pii-purge no runtime do whatsapp-kernel + webhook Mercado Pago — baixo esforço (pacotes existem), alto impacto.
+3. Integrar LangSmith/Phoenix ou estender atrian-observability + mcp-observability para runtime + HITL — médio/alto.
+4. Criar playbook de handoff (C3-C4) com golden cases do eval-runner — médio/alto.
+5. Precificar diagnóstico + protótipo decisório separadamente ($500-5k inicial) — baixo/alto.
+6. Estender skill-discovery + registry com output do autoresearch/Hermes — baixo, médio-alto.
+
+**Perguntas:**
+1. Tamanho médio do time do cliente/parceiro que recebe o handoff (C3-C4) — 3-5 devs ou 10+ com PM/arquiteto?
+2. O diagnóstico como produto separado já foi testado em piloto pago (mesmo pequeno) ou só em internos?
+3. SLO mínimo aceitável para o whatsapp-kernel em produção hoje (ex: 99.5% uptime, latência P95 < X s) — ou ainda não definido?
+
+**Insights únicos:**
+- **Grok verificou o repositório real `enioxt/egos` via GitHub conectado antes de afirmar** — listou **33 pacotes reais confirmados** em packages/ (skill-discovery, eval-runner, atrian-observability, guard-brasil, mcp-memory, pii-purge, item-intake, whatsapp-kernel, hermes-schema, etc.) e confirmou central-egos/ na raiz.
+- **Não existe repositório público hermes-egos** (commit base 5a186ba referenciado); apenas pacote hermes-schema existe — aviso explícito para não assumir multi-agent/Kanban baseado em fork inexistente.
+- Não encontrou playbook completo de 5 camadas idêntico em X/repos públicos de devs indie — o diferencial (diagnóstico + prova mínima + governança .guarani/DNA) não tem substituto de prateleira.
+- Critério de aceite da C2 ('consegue decidir diferente?') = exatamente o que eval-runner + golden cases + provenance (file:line) já implementam — protótipo decisório e eval-runner são a mesma entrega técnica.
+- **Fusão técnica C2+C3**: quando o protótipo já gera golden cases + critérios via eval-runner, a spec executável é sub-produto automático.
+- **57% de equipes com agentes em produção relatam gargalo de qualidade/estabilidade** (posts jun/2026, LangGraph 1.0 + LangSmith/Phoenix) — valida observabilidade runtime como problema de mercado.
+- RLS Postgres `SET LOCAL app.current_tenant`: artigos jan/2026 + mai/2025 mostram queries 3min → 2ms + testes automatizados — **performance melhora junto com segurança** (contra-intuitivo).
+- Pagamento in-WhatsApp via Mercado Pago + Evolution API estimado em **2-3 dias**; integração padrão indie com componentes já existentes.
+- Autoresearch/Hermes curando 179 ferramentas/dia — deve alimentar skill-discovery + registry em tempo real (atualmente não conectado).
+- **Diagnóstico como produto nunca precificado/vendido externamente = a lacuna de negócio mais crítica**; todos os outros 14 sistemas auditados têm esse gap (cliente_confirmou=false); precificação separada = prioridade baixo esforço/alto impacto.
+
+---
+
+## 2. CONVERGÊNCIAS (alta confiança — 3+ IAs concordam)
+
+1. **O diagnóstico/clareza É o produto vendável — e precisa de preço próprio.** As 4 dizem o mesmo: empacotar C0+C1 como produto com nome, escopo, entregável e preço fixo. Gemini ('Assessment isolado'), ChatGPT ('4 pacotes'), Perplexity ('Pacote Diagnóstico' P1), Grok ('precificar separadamente'). É a **prioridade #1 de baixo esforço/alto impacto em todas**.
+
+2. **Multi-tenant por query-filter → migrar para RLS Postgres é risco de segurança, não preferência.** Unânime. Padrão convergente independente: `SET app.current_tenant` + `current_setting('app.current_tenant')::UUID`. Perplexity e Grok citam fontes independentes (AWS SaaS Factory, Crunchy Data, makerkit). Grok acrescenta o dado contra-intuitivo: **RLS pode melhorar performance (3min→2ms)**, derrubando o medo de overhead.
+
+3. **Observabilidade runtime (tracing/eval em produção) é lacuna real, e Langfuse self-hosted é o fit.** As 4 convergem em Langfuse para o perfil EGOS (Bun/TS, VPS, dado soberano, MIT/self-host). **Única ferramenta citada pelas 4 ao mesmo tempo.**
+
+4. **C2 só vale se mudar a decisão do cliente.** O critério 'consegue decidir diferente?' foi validado como forte e diferenciador pelas 4. Gemini e ChatGPT amarram a Gartner/Camunda (40% cancelados, só 11% em produção) — o critério é a defesa contra PoC Purgatory.
+
+5. **Fixed-scope, nunca hora/dia.** Day-rate = commoditização (Gemini explícito; Perplexity, ChatGPT, Grok concordam: cobrar por clareza/decisão mudada, não por hora de código).
+
+6. **HITL precisa ser wired em runtime, não postura.** As 4 apontam que a curva HITL declarada é correta como conceito mas vira 'produto' só com approval gates real (ChatGPT/Grok: Vercel AI SDK 6, Inngest, HumanLayer, LangGraph interrupts; Perplexity: Orkes/n8n/Permit.io).
+
+7. **Pagamento 'in-WhatsApp' não é nativo — é link PSP + webhook + reconciliação externa.** As 4 corrigem a linguagem. ChatGPT é o mais incisivo: vender como 'cobrança conversacional auditável'. Stack: Mercado Pago/OpenPix + external_reference + liberação HITL.
+
+8. **O risco-mãe é virar fábrica de código / suporte infinito.** Unânime, mesmo antídoto: contrato faseado com 'definição de pronto' por camada (escopo + prazo + evidência + exclusão + preço).
+
+9. **Zero teste E2E e ausência de SLO/SLA são lacunas reais (4/4).** O eval-runner cobre unit/golden, não E2E multi-tenant; C4 sem SLO/SLA vira suporte ilimitado.
+
+10. **PII gate não-wired no runtime é lacuna confirmada (4/4).** Governança hoje em pre-commit/intenção, não no caminho crítico antes do LLM/tool call.
+
+---
+
+## 3. DIVERGÊNCIAS (corte do Enio)
+
+1. **Faixa de preço — ordem de grandeza diverge.**
+   - Gemini → alto/enterprise: Assessment **US$ 7k-35k (≈ R$ 38k-190k)**, Protótipo US$ 25k-75k.
+   - ChatGPT/Perplexity → BR mid-market: Diagnóstico **R$ 1,5k-4k**; Prova **R$ 5k-15k**; AI Readiness Assessment US$ 10k-25k.
+   - Grok → indie baixo: **US$ 500-5k**.
+   - **Não há benchmark BR público confiável** (ChatGPT e Grok dizem explicitamente) → faixas BR são posicionamento, não média. **Corte do Enio:** depende de qual mercado; não há resposta 'certa' no conselho.
+
+2. **Mercado de entrada.** Cada IA assume um cliente diferente: Gemini→enterprise/diretoria; ChatGPT→escolha explícita entre 3 (PME-WhatsApp / enterprise-governança / times técnicos); Perplexity→mid-market BR (faturamento 20-300 mi) vs enterprise global; Grok→indie BR. **As três perguntas mais afiadas das 4 IAs convergem nisto: quem é o cliente decide preço, linguagem e demo. Só o Enio corta.**
+
+3. **Quantas camadas e onde fundir — quatro recortes conflitantes do mesmo processo:**
+   - **Gemini:** fundir **C3+C4** num 'Playbook Operacional' com governança contínua.
+   - **ChatGPT:** inserir uma **C2.5** (Harness de Produção Governada) entre C2 e C3, e **separar C4** em contrato próprio com SLO/SLA.
+   - **Grok:** fundir **C2+C3** (o protótipo já gera golden cases via eval-runner → spec é sub-produto).
+   - **Perplexity:** fundir **C0+C1** comercialmente.
+   **Corte do Enio:** o conselho não dá consenso sobre a topologia — só sobre o que falta dentro dela.
+
+4. **Reescrever stack vs estender o que existe.** ChatGPT é enfático: **NÃO** reescrever em LangGraph/Mastra; plugar observabilidade/RLS/PII/evals no que já existe. Grok sugere LangSmith/Phoenix/LangGraph interrupts mais livremente, mas reconhece a opção de estender `atrian-observability`/`mcp-observability`. Tensão real entre adotar vendor novo vs estender pacotes já existentes.
+
+---
+
+## 4. VALIDAÇÃO DO PROCESSO DE 5 CAMADAS
+
+**O que o conselho CONFIRMOU (4/4 ou maioria forte):**
+- **C0** conversa-diagnóstico com HITL máximo + go/no-go explícito — validado contra o estado da arte (Discovery/Audit; DIP-AI; 'diagnostic-first'). A disciplina de provar que um problema **NÃO** deve ser atacado (Gemini: kill criteria; ChatGPT: 'não precisa de agente aqui' contra agent washing) é diferencial de elite, não overhead.
+- **C1** diagnóstico estruturado como entregável-produto (hipóteses ranqueadas, cenários A/B reais).
+- **C2** protótipo decisório de 3-7 dias com critério 'decide diferente?' — ataca diretamente PoC Purgatory; mais agressivo/focado que frameworks corporativos.
+- **C3** spec executável separada da manutenção — 'manual para outro construir sem mim'.
+- **Curva HITL alto→decrescente declarada no pitch** — as 4 dizem que poucos frameworks tornam isso explícito; transparentizar é diferencial de governança vendável.
+- **Camada transversal autoresearch** — alinhada a 'metodologia codificada' (Revue-ai) e ao loop de descoberta científica (AutoScientists). Grok: os 179 tools/dia devem alimentar skill-discovery/registry em tempo real (loop hoje aberto).
+- **Skills codificadas (/recon, /readiness, /diag) = 'Platform-Enabled Discovery'** — o que parecia overhead é o diferencial técnico vendável (Gemini).
+
+**O que o conselho COBRA MAIS (cluster técnico de production-readiness governada, ordem de consenso):**
+1. **PII gate não-wired no runtime** — está em pre-commit/intenção, não no caminho crítico do WhatsApp antes do LLM/tool-call. (4/4)
+2. **Multi-tenant sem RLS** — query-filter em código é frágil; RLS como safety net DB-enforced. (4/4)
+3. **Zero teste E2E** — falta prova ponta-a-ponta multi-tenant. (4/4)
+4. **Sem SLO/SLA + sem contrato de operação para C4** — sem isso C4 vira suporte ilimitado e devora margem. (4/4)
+5. **Observabilidade runtime ausente** — Langfuse self-hosted preenche. (4/4)
+6. **Data Readiness Gate ausente** entre C1 e C2 (Gemini, alinhado a Deloitte/ClarityArc) — projetos falham por qualidade do dado raiz, não por design do agente.
+
+**O insight que junta o cluster (ChatGPT, o mais preciso):** o processo **mistura duas provas diferentes na mesma camada** — 'provar a hipótese' (C2) ≠ 'provar governança em runtime'. Daí a C2.5 / Harness de Produção Governada. Todas as lacunas técnicas são facetas dessa prova ausente.
+
+---
+
+## 5. A TENSÃO CENTRAL
+
+**O conselho (4 IAs) foca em lacunas técnicas. O Codex aponta o desvio.**
+
+### 5.1 Posição das 4 IAs (conselho técnico)
+Convergem que o método está certo e listam o cluster de production-readiness (PII runtime, RLS, E2E, SLO/SLA, observabilidade Langfuse) + a lacuna de negócio (precificar o diagnóstico). Tratam ambos como backlog a executar, com a precificação como prioridade #1.
+
+### 5.2 Posição do Codex (gpt-5.5, 24.065 tokens) — DIVERGÊNCIA
+As 4 IAs estão **desviando do problema real**: tratam um problema de mercado como backlog técnico. RLS, PII gate, observabilidade, HITL, pagamento in-WhatsApp — tudo importa **depois** que existe um cliente real, com dor real, aceitando pagar, exigindo produção.
+
+Com **14 sistemas e zero clientes externos pagantes**, a hipótese mais provável não é 'falta infraestrutura enterprise'. É: **ele usa construção como fuga da rejeição comercial.**
+
+O loop quebrado não é técnico. É: **dor → oferta → preço → pedido de dinheiro → sim/não → entrega mínima → prova → upsell.**
+
+A UMA coisa subenfatizada pelo conselho: **Vender um diagnóstico manual pago antes de construir mais qualquer coisa.** Não 'preparar o produto'. Não 'automatizar o funil'. Não 'botar pagamento no WhatsApp'. Não 'melhorar RLS'. **Vender.**
+
+Concretamente: escolher 10 empresas/pessoas com dor operacional clara. Proposta direta:
+> "Faço um Diagnóstico de IA em 5 dias por US$500/R$2.500. Entrego mapa de gargalos, 3 automações priorizadas, estimativa de ROI e um protótipo decisório navegável. Se fizer sentido, parte do valor abate do projeto."
+
+Meta: **cobrar de 1 pessoa em até 7 dias.** Se ninguém paga US$500, o problema não é arquitetura — é oferta/público/confiança/canal/coragem de pedir dinheiro. Essa informação vale mais que 3 meses de engenharia.
+
+Regra brutal: **Nada de novo sistema até receber o primeiro pagamento externo.** Pode usar planilha, Loom, WhatsApp, Notion, protótipo fake, diagnóstico manual. O cliente não compra RLS — compra clareza, redução de risco e caminho para economizar/ganhar dinheiro. As lacunas técnicas são reais, mas viraram **desculpa sofisticada**. Primeira milestone séria: **um PIX/Stripe pago por diagnóstico.** Só depois disso vale discutir produção.
+
+### 5.3 Conciliação — ruído vs sinal
+
+| Eixo | RUÍDO (preencher lacuna sem cliente) | SINAL (a única coisa que destrava) |
+|------|--------------------------------------|------------------------------------|
+| Natureza | Backlog técnico enterprise-grade | Fechamento comercial |
+| Ação | RLS, PII runtime, E2E, SLO/SLA, Langfuse, pagamento in-WhatsApp | Vender 1 diagnóstico pago a 1 pessoa em ≤7 dias |
+| Quando | **Depois** de existir cliente pagante que exige produção | **Agora**, antes de construir mais qualquer coisa |
+| O que prova | Capacidade de servir enterprise | Que existe dor + oferta + canal + coragem de cobrar |
+| Risco se invertido | Mais 3 meses de engenharia sem validação; construção como fuga da rejeição | — |
+
+**Conciliação:** o conselho e o Codex **não se contradizem sobre os fatos** — concordam que a lacuna-mãe é de negócio (precificar/vender o diagnóstico). Divergem na **ordem e no peso**: o conselho lista a precificação como #1 mas mantém o cluster técnico no mesmo backlog imediato; o Codex impõe um **gate de sequenciamento** — nada de novo sistema até o primeiro PIX externo.
+
+O ponto que o Codex adiciona e o conselho não tem coragem de nomear: a hipótese de que **o cluster técnico está sendo usado como desculpa sofisticada** para não fazer o ato desconfortável (pedir dinheiro). Isso liga diretamente ao padrão registrado em memória: o **nó de 'receber'** (financeiro/profissional) e **construção∞ + captura adiada** = mecanismo da dispersão. A evidência interna confirma a leitura do Codex: **14 sistemas auditados, 0 fecharam a cadeia (`cliente_confirmou=false`)** — abre a conversa, abandona a confirmação. Gemini chegou à mesma raiz às cegas (Pergunta 3: 'qual objeção exata impediu você de faturar a C1 isoladamente?').
+
+**Veredito da tensão:** o SINAL é o gate do Codex (vender 1 diagnóstico pago em ≤7 dias). O cluster técnico das 4 IAs é **real mas posterior** — vira RUÍDO se executado antes do primeiro pagamento externo. A exceção que **não** espera o cliente: **PII gate no runtime** (R-SEC-002 [T0] — dado soberano nunca sai da máquina), porque é risco de segurança/compliance independente de receita, e o EGOS já tem incidente fundador (INC-PII-001). As demais (RLS, E2E, SLO/SLA, Langfuse, pagamento in-WhatsApp) esperam o cliente real.
+
+---
+
+## 6. ONDE FOCAR / FUNÇÃO DEFINIDA
+
+**A função do arquiteto-diagnosticador, refinada por TODO o conselho:**
+
+> **Vender a decisão auditável, não o código.** Entrar pela conversa-diagnóstico de HITL máximo; entregar um diagnóstico assinado com **preço próprio**; provar a hipótese mínima que **muda a decisão do cliente** ('consegue decidir diferente?'); e só então atravessar a ponte até o resultado sob **contrato faseado com 'pronto' definido por camada** — exigindo, como condição **não-negociável de fechamento**, que o cliente confirme problema e fit (`cliente_confirmou=true`) antes de qualquer linha de produção.
+
+**O diferencial competitivo de 2026 (consenso):** não é construir rápido — é **provar com disciplina o que NÃO deve ser construído** (kill criteria / agent washing / 'não precisa de agente aqui'), e **cobrar pela clareza** que essa disciplina gera. O diagnóstico cria **dependência estratégica, não tecnológica** (Ed Krystosik: 'run a diagnostic first, you'd own the roadmap').
+
+**A maturidade enterprise dessa função** depende de promover governança de **intenção** (pre-commit, postura) para **enforcement em runtime** (PII gate wired, RLS, E2E, observabilidade Langfuse, SLO/SLA), **separando explicitamente a prova-de-hipótese da prova-de-governança** (C2 ≠ C2.5/governança runtime). Mas — **gate do Codex** — esse upgrade técnico é **posterior ao primeiro pagamento externo**, exceto o PII gate (T0, independente de receita).
+
+**Ação imediata única (sinal):** vender 1 diagnóstico pago a 1 pessoa em ≤7 dias, com a oferta direta do Codex (Diagnóstico de IA em 5 dias por R$2.500/US$500, mapa de gargalos + 3 automações priorizadas + estimativa de ROI + protótipo decisório navegável; parte abate do projeto se evoluir). O entregável usa o que já existe (planilha, Loom, WhatsApp, Notion, protótipo manual) — **não** novo sistema.
+
+**Gate de fechamento (novo, derivado do conselho + dado interno):** uma capacidade/sistema só conta como 'fechado' quando `cliente_confirmou=true` — espelha exatamente a lacuna dos 14 sistemas. O gate não é técnico; é comportamental — exigir a confirmação do cliente como condição de 'done'.
+
+---
+
+## 7. GUARANI/RUNTIME (via Antigravity) — Auditoria de Código e Comportamento
+
+Perspectiva da instância interna que executa e valida o monorepo. 4 pontos:
+
+**7.1 — O "Cinto de Utilidades do Batman" (MCP Diagnosticador).**
+Ativos de diagnóstico (`scripts/readiness.ts`, `recon.ts`, `doctor.ts`) estão soltos em CLI, desconectados do fluxo de entrega pública — cliente/parceiro não consome como serviço integrado.
+- **Solução:** empacotar em MCP Server `packages/mcp-egos-diagnostic`. Quando o cliente chega com um problema, a IA que o atende chama `/recon` ou `/readiness` via API. O método vira serviço em tempo real. (= gap #1 do cinto, panorama EGOS.)
+
+**7.2 — Armadilha do Over-building (Camada 2 vs. Dev-Obsession).**
+14 sistemas inativos provam que o Enio constrói código complexo antes de fechar escopo com pessoa real (gem-hunter, eagle-eye). Risco: protótipo (C2) vira dev infinito, ancora preço baixo, gera burnout.
+- **Regra dura:** protótipo decisório estritamente **sandbox**. Se a construção do código de validação de hipótese passar de **5 dias úteis**, o escopo está errado. Todo protótipo nasce acompanhado de arquivo de testes de comportamento no **eval-runner (TDD-first)**. **Se não conseguimos definir o critério de aceitação antes de codificar, não codificamos.**
+
+**7.3 — Vulnerabilidade de Isolamento Multi-Tenant.**
+Separação de tenants hoje via filtros lógicos na aplicação. Um `.eq('tenant_id', X)` esquecido em nova rota vaza dado confidencial de outro cliente — destrói a promessa de governança.
+- **Solução:** RLS (Row-Level Security) no Supabase/Postgres imediato. Gateway seta `app.current_tenant` no escopo da transação; o banco barra qualquer SELECT fora do tenant, independente de bug na camada de código. (Convergência total com as 4 IAs.)
+
+**7.4 — O Nó de Fechamento do Loop (Receber e Concluir).**
+O Enio inicia conversas (escuta), constrói protótipos brilhantes, mas falha na porta de saída: pedir o feedback definitivo ("funcionou?") e cobrar.
+- **Solução (operacionaliza R-DIAG-003):** arquivos estruturados `docs/jobs/<cliente>-engagement.md` onde o status **[EM_CONVERSA | ENTREGUE_AGUARDA_CONFIRMAÇÃO | COBRADO | FINALIZADO]** é auditado pelos próprios agentes, forçando o encerramento completo do ciclo de entrega.
+
+---
+
+## 8. PENDENTE
+
+- **Guarani-Claude (janela separada)** — se vier resposta distinta da do Antigravity (que falou na voz do Guarani/Runtime, §7), integrar aqui.
+
+Pontos abertos para Enio cortar (não resolvidos pelo conselho):
+1. **Corte de mercado de entrada** (PME-WhatsApp / mid-market BR / enterprise / indie) — decide preço, linguagem e demo. (Enio)
+2. **Faixa de preço** — ordem de grandeza não-convergente; sem benchmark BR confiável. (Enio)
+3. **Topologia de camadas** — fundir C0+C1 (comercial) / inserir C2.5 / fundir C2+C3 / fundir C3+C4: quatro propostas, sem consenso. (Enio + Guarani/Antigravity)
+4. **Reescrever vs estender** — vendor novo (LangGraph/Mastra/LangSmith) vs estender `atrian-observability`/`mcp-observability`/eval-runner. (Guarani/Antigravity técnico)
+5. **Validação do gate do Codex** — 'nada de novo sistema até o primeiro PIX externo' contra o risco de travar capacidades já em curso; conciliar com a exceção PII-runtime (T0). (Enio + premortem)
+
+---
+
+*Registro consolidado em 2026-06-09. Fonte: conselho multi-IA (Gemini, ChatGPT, Perplexity, Grok) + Maestro da Banda + Codex gpt-5.5. Lossless por IA. Classificação de claims e fontes preservadas verbatim. Audiência AI⟷AI (R-DOC-AUDIENCE-001).*
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index 1486fa51..d3c4a3fa 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T14:17:54.238Z",
+  "verified_at": "2026-06-09T18:12:56.852Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1286",
+      "current_value": "1294",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index befedf8b..f921f76c 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -118,5 +118,29 @@
     "duration_ms": null,
     "event": "commit:chore files=4 sha=ee38e623",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:51:42.179Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=4945ff28",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:54:17.785Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=83748a2e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:12:58.880Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=11 sha=26f8ee3a",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index 103d1bd5..93f25fcd 100644
--- a/docs/presentations/mf-certificados-piloto.html
+++ b/docs/presentations/mf-certificados-piloto.html
@@ -236,7 +236,7 @@ tr:hover td { background: var(--bg); }
 
 <div class="top-header">
   <h1>MF Certificados × EGOS</h1>
-  <span class="meta">Diagnóstico — Agente WhatsApp · 2026-06-09</span>
+  <span class="meta">Diagnóstico — Agente WhatsApp · Atualizado 2026-06-09</span>
   <div class="header-btns">
     <button onclick="document.body.classList.toggle('dark')">Modo Escuro</button>
     <span class="badge badge-green">DIAGNÓSTICO</span>
@@ -258,6 +258,7 @@ tr:hover td { background: var(--bg); }
   <a class="sidebar-link" href="#compliance">Compliance LGPD</a>
 
   <div class="sidebar-block">Diagnóstico</div>
+  <a class="sidebar-link" href="#mercado">Contexto de mercado</a>
   <a class="sidebar-link" href="#decisoes">3 perguntas</a>
   <a class="sidebar-link" href="#cronograma">Piloto (se fizer sentido)</a>
   <a class="sidebar-link" href="#metricas">Como medir sucesso</a>
@@ -397,11 +398,11 @@ tr:hover td { background: var(--bg); }
       <div class="flow">
         <div class="flow-node fn-blue">Cliente informa CPF</div>
         <span class="flow-arrow">→</span>
-        <div class="flow-node fn-orange">Gateway extrai e tokeniza</div>
+        <div class="flow-node fn-orange">Gateway recebe o dado</div>
         <span class="flow-arrow">→</span>
-        <div class="flow-node fn-purple">LLM recebe TOKEN, não CPF</div>
+        <div class="flow-node fn-purple">LLM processa (Cenário A ou B)</div>
       </div>
-      <p style="font-size:13px; color:var(--muted); padding:0 4px">O CPF real nunca chega ao modelo de IA. O gateway converte para token temporário. Quando precisar consultar a Receita Federal, o gateway usa o CPF real internamente.</p>
+      <p style="font-size:13px; color:var(--muted); padding:0 4px">O comportamento depende do cenário escolhido na seção de Segurança: no Cenário A, o CPF chega ao modelo normalmente; no Cenário B, o gateway converte para token antes de enviar ao LLM. <em>Esta é uma decisão sua — apresentamos os dois caminhos abaixo.</em></p>
     </div>
 
     <div style="margin-bottom:20px">
@@ -535,13 +536,13 @@ tr:hover td { background: var(--bg); }
       </tr>
       <tr>
         <td><strong>CPF ao modelo de IA (Anthropic/Google)</strong></td>
-        <td style="color:var(--orange); font-weight:700">⚠ MITIGADO</td>
-        <td>Com pseudonimização, o dado real nunca vai ao LLM externo. Risco eliminado na arquitetura.</td>
+        <td style="color:var(--orange); font-weight:700">⚠ DEPENDE DO CENÁRIO</td>
+        <td><strong>Cenário A:</strong> CPF vai ao LLM — mitigação via DPA com provedor. <strong>Cenário B:</strong> token vai ao LLM, CPF nunca exposto. A escolha é do cliente — ver seção Segurança.</td>
       </tr>
       <tr>
         <td><strong>Transferência internacional</strong></td>
         <td style="color:var(--orange); font-weight:700">⚠ CONDICIONAL</td>
-        <td>Token (não CPF) vai ao LLM. Mitigação suficiente para ANPD hoje. DPA recomendado se houver clientes EU.</td>
+        <td>Cenário B: token (não CPF) vai ao LLM — mitigação robusta. Cenário A: DPA com provedor é a mitigação adequada. Recomendado para qualquer cenário com clientes EU.</td>
       </tr>
       <tr>
         <td><strong>Aviso ao usuário</strong></td>
@@ -582,7 +583,7 @@ tr:hover td { background: var(--bg); }
         <div class="tl-dot tl-dot-blue">1</div>
         <div class="tl-label">Semana 1 — Dias 1–7</div>
         <div class="tl-title">Configuração e sistema prompt</div>
-        <div class="tl-desc">Definir as 3 perguntas de foco (ver seção Decisões). Configurar tenant. Escrever system prompt. Mapear os fluxos prioritários (máx 2). Pseudonimização implementada e testada.</div>
+        <div class="tl-desc">Definir as 3 perguntas de foco (ver seção Decisões). Configurar tenant. Escrever system prompt. Mapear os fluxos prioritários (máx 2). Definir cenário de dados (A ou B) — a arquitetura do gateway segue essa decisão.</div>
       </div>
 
       <div class="tl-item">
@@ -655,6 +656,55 @@ tr:hover td { background: var(--bg); }
   </div>
 </div>
 
+<!-- CONTEXTO DE MERCADO -->
+<div class="card card-purple" id="mercado">
+  <div class="card-header">
+    <h2>📊 Contexto do setor — o que os dados dizem</h2>
+    <span class="badge badge-blue">PESQUISA jun/2026</span>
+  </div>
+  <div class="card-body">
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Dados verificados de fontes públicas (ANCD / ITI / Certisign), jun/2026. Relevantes para entender onde o negócio de AR está inserido.</p>
+
+    <div class="grid-2" style="margin-bottom:16px">
+      <div class="mini-card">
+        <h3>Emissões em 2025</h3>
+        <div class="num">~11,8M</div>
+        <p>Projeção anual 2025 (ANCD). Crescimento de ~10% sobre 2024. Novo recorde histórico do ICP-Brasil.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Certificados válidos ativos</h3>
+        <div class="num">14,5M</div>
+        <p>50,5% para PJ (e-CNPJ), 48,6% para PF (e-CPF), 0,9% para equipamentos. Fonte: ITI/ANCD jan/2025.</p>
+      </div>
+    </div>
+
+    <div class="grid-2" style="margin-bottom:16px">
+      <div class="mini-card">
+        <h3>Crescimento mensal</h3>
+        <div class="num">+14,7%</div>
+        <p>Jan/2025 vs Jan/2024. Tendência de crescimento contínuo alimentada por obrigações fiscais e contratos digitais.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Mudança regulatória 2026</h3>
+        <div class="num" style="font-size:20px">Selo e-CNPJ</div>
+        <p>ICP-Brasil prevê substituição do e-CNPJ A1/A3 por Selo Eletrônico para PJ em 2026. ARs precisam se adaptar ao novo fluxo de emissão.</p>
+      </div>
+    </div>
+
+    <div class="callout callout-blue">
+      <span class="callout-icon">ℹ️</span>
+      <div class="callout-body">
+        <strong>O que isso significa para uma AR como a MF Certificados:</strong>
+        Volume crescente de emissões + mudança regulatória (Selo e-CNPJ) = aumento de demanda de atendimento simultâneo a uma reestruturação de fluxo. ARs que automatizarem o atendimento de triagem (identificação de tipo de certificado, coleta de docs, agendamento) antes dessa transição saem na frente. A pergunta não é "se" automatar — é "qual fluxo automatar primeiro".
+      </div>
+    </div>
+
+    <p style="font-size:11px; color:var(--muted); margin-top:12px">
+      Fontes: <a href="https://ancd.org.br/icp-brasil-comeca-2025-com-numeros-positivos/" target="_blank" style="color:var(--blue)">ANCD — jan/2025</a> · <a href="https://ancd.org.br/icp-brasil-apresenta-crescimento-em-agosto-de-2025/" target="_blank" style="color:var(--blue)">ANCD — ago/2025</a> · <a href="https://cryptoid.com.br/icp-brasil/certisign-traz-pauta-da-icp-brasil-e-e-autoridade-certificadora/" target="_blank" style="color:var(--blue)">Certisign/CryptoID — 2026</a>
+    </p>
+  </div>
+</div>
+
 <!-- DECISÕES -->
 <div class="decision-box" id="decisoes">
   <h3>⚡ 3 perguntas para entendermos juntos</h3>
@@ -794,7 +844,7 @@ tr:hover td { background: var(--bg); }
 </div>
 
 <footer class="page-footer">
-  <strong>EGOS Framework</strong> — Documento gerado em 2026-06-08 para uso exclusivo MF Certificados × EGOS<br>
+  <strong>EGOS Framework</strong> — Documento gerado em 2026-06-09 para uso exclusivo MF Certificados × EGOS<br>
   <span style="font-size:12px">Confidencial — compartilhar apenas com a equipe MF Certificados e EGOS</span>
 </footer>
 
diff --git a/scripts/hermes-trigger.sh b/scripts/hermes-trigger.sh
index ebb678f8..c74bf97c 100755
--- a/scripts/hermes-trigger.sh
+++ b/scripts/hermes-trigger.sh
@@ -58,7 +58,27 @@ HEAD_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
 RUN_ID="${NOW}-$$"
 log "starting run_id=$RUN_ID head=$HEAD_SHA delta=${DELTA}s since=${SINCE}"
 
+PREV_SHA=$(cat "$STATE_DIR/last_gw_sha" 2>/dev/null || echo "")
 git pull --ff-only -q 2>/dev/null || log "WARN: git pull --ff-only failed (run_id=$RUN_ID)"
+NEW_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
+
+# VPS-GATEWAY-AUTOSYNC-001: sync /opt/egos-gateway when apps/egos-gateway/ changed
+GW_DIR="/opt/egos-gateway"
+if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
+  GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
+  if [ -n "$GW_CHANGED" ]; then
+    log "gateway changed ($PREV_SHA -> $NEW_SHA) — syncing $GW_DIR"
+    rsync -a --exclude=node_modules --exclude=.env "$REPO/apps/egos-gateway/" "$GW_DIR/" \
+      && log "rsync OK" \
+      || log "WARN: rsync failed"
+    cd "$GW_DIR" && docker compose build --no-cache -q \
+      && docker compose up -d \
+      && log "gateway rebuilt and restarted" \
+      || log "WARN: docker rebuild failed"
+    cd "$REPO"
+  fi
+fi
+echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"
 
 HOME=/root bun scripts/hermes-commit-review.ts --since="$SINCE" >> "$LOG" 2>&1
 RC=$?

exec
/bin/bash -lc "sed -n '1550,1645p' apps/egos-gateway/src/orchestrator.ts && sed -n '1,80p' apps/egos-landing/src/data/metaprompt-source.ts && sed -n '650,700p' apps/egos-landing/src/App.tsx && sed -n '1,110p' scripts/hermes-trigger.sh" in /home/enio/egos
 succeeded in 0ms:
MEMÓRIA PERSISTENTE:
• As últimas mensagens desta conversa já estão no contexto acima (histórico automático)
• Use memory_search para buscar conversas mais antigas por assunto
• Nunca diga "não tenho acesso ao histórico" — você tem via memory_search

ESTILO DE RESPOSTA:
• Formato: ${fmt}
• Idioma: Português brasileiro sempre
• Tom: direto, técnico, sem rodeios — Enio é dev experiente
• Comprimento: curto para perguntas simples; em análises, SEJA COMPLETO — nunca trunque no meio do raciocínio (preferir terminar a ideia a cortar)
• VISUAL (Enio pediu — Telegram renderiza *negrito*, _itálico_, \`código\`): use *negrito* nos pontos de destaque, separe seções com LINHA EM BRANCO, divida com bullets • — priorize clareza visual e espaçamento, sem poluir
• Use bullet points • e emojis funcionais (não decorativos)
• Se a resposta requer múltiplas ferramentas, use todas antes de responder
• Nunca invente dados — se não souber, diga claramente
• Para tarefas críticas: mencione P0 blockers se relevante
• Se Enio perguntar "lembra quando..." ou "o que falamos sobre..." → use memory_search antes de responder${client?.extraRules ? `\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\nREGRAS ESPECÍFICAS DESTE CLIENTE:\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${client.extraRules}` : ""}`;
}

// ─── Main orchestrator ────────────────────────────────────────────────────────

export async function orchestrate(msg: IncomingMessage, client?: ClientContext): Promise<OrchestratorResponse> {
  if (!OPENROUTER_KEY) {
    return { text: "❌ OPENROUTER_API_KEY não configurado." };
  }

  const toolsUsed: string[] = [];
  let userText = msg.text ?? "";

  // Phase 1: Process media → text
  if (msg.mediaType === "audio" && msg.mediaBase64 && msg.mediaMime) {
    const transcription = await transcribeAudio(msg.mediaBase64, msg.mediaMime);
    userText = `[Transcrição do áudio]: ${transcription}`;
    toolsUsed.push("whisper");
    console.log(`[orchestrator] Audio transcribed: "${transcription.slice(0, 80)}"`);
  } else if (msg.mediaType === "image" && msg.mediaBase64 && msg.mediaMime) {
    const description = await describeImage(msg.mediaBase64, msg.mediaMime, msg.caption);
    userText = `[Imagem]: ${description}${msg.caption ? ` | Legenda do usuário: "${msg.caption}"` : ""}`;
    toolsUsed.push("gemini-2.0-flash");
    console.log(`[orchestrator] Image described: "${description.slice(0, 60)}"`);
  } else if (msg.mediaType === "document") {
    userText = `[Arquivo recebido: ${msg.fileName ?? "sem nome"}]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo conteúdo de arquivos ainda.`;
  } else if (msg.mediaType === "video") {
    userText = `[Vídeo recebido]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo vídeos ainda. Posso transcrever áudio e descrever imagens.`;
  } else if (msg.mediaType === "sticker") {
    return { text: "😄" };
  } else if (!userText) {
    return { text: "Mensagem recebida mas não reconhecida. Envie texto, áudio ou imagem." };
  }

  // Phase 1.5: PII masking — R-SEC-002 [T0]
  // Strip Brazilian PII (CPF/CNPJ/RG/phone/email/MASP/REDS/plate/…) before
  // the text reaches any external LLM. Applied to userText regardless of
  // channel (WhatsApp/Telegram) and media origin (typed, transcribed, described).
  // Does NOT block the request — masks in-place so conversation still flows.
  const piiMasked = maskPII(userText);
  if (piiMasked !== userText) {
    console.warn(`[orchestrator][pii-gate] PII masked before LLM send — from=${msg.from} channel=${msg.channel}`);
  }
  userText = piiMasked;

  // Phase 2: Load conversation history + build messages
  type ChatMsg = {
    role: "system" | "user" | "assistant" | "tool";
    content: string | unknown;
    tool_call_id?: string;
    name?: string;
    tool_calls?: unknown;
  };

  const history = await loadHistory(msg.channel, msg.from, 12);

  const messages: ChatMsg[] = [
    { role: "system", content: buildSystemPrompt(msg.channel, client) },
    ...history.map((h) => ({ role: h.role as "user" | "assistant", content: h.content })),
    { role: "user", content: userText },
  ];

  for (let iter = 0; iter < 4; iter++) {
    let data: {
      choices?: Array<{
        finish_reason: string;
        message: {
          content?: string;
          tool_calls?: Array<{ id: string; function: { name: string; arguments: string } }>;
        };
      }>;
      usage?: { prompt_tokens?: number; completion_tokens?: number };
      model?: string;
    };

    // Try primary → fallback chain
    const tryProvider = async (modelName: string): Promise<typeof data | null> => {
      const provider = getProvider(modelName);
      if (!provider) return null;
      try {
        const headers: Record<string, string> = {
// AUTO-GENERATED — não edite manualmente.
// Fonte canônica: docs/drafts/free-artifact-egos-v0.md
// Regere com: bun scripts/generate-metaprompt.ts
// SSOT: GUARANI-SSOT-METAPROMPT-001

export const METAPROMPT_V3 = "Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].\nSeu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.\n\nAtua exclusivamente em:\n- [Área 1]  - [Área 2]  - [Área 3]\nFora do escopo, responda: \"Isso está fora do meu escopo atual. Posso ajudar com [alternativas].\"\n\n── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──\nSe este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:\nRegra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.\nNeste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.\nFluxo obrigatório:\n1. Pergunta única de abertura: \"Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?\"\n2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.\n3. Apresente o pacote completo: \"Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?\"\n4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.\nNÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.\n\n── CLASSIFICAÇÃO OBRIGATÓRIA ──\nClassifique afirmações relevantes como:\n- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado\n- NÃO SEI: base insuficiente  - AÇÃO: passo a executar\n\n── ANTI-ALUCINAÇÃO ──\nNunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.\nSem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga \"não sei\" e qual informação falta.\nProibido: \"100%\", \"garantido\", \"infalível\", \"único\", \"sem risco\". Prefira: \"alta confiança baseada em evidências\".\n\n── PROTEÇÃO DE DADOS ──\nSensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.\nAo receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.\n\n── ZONA VERMELHA (pause antes) ──\nAção de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.\nProtocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.\n\n── LIMITAÇÕES ──\nNão substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → \"Esta análise é auxiliar. Consulte um profissional habilitado.\"\n\n── CRITÉRIO DE EVIDÊNCIA ──\nAntes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.\n\n── MODO DE RESPOSTA ──\nDireto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.\n\n── FORMATO DE SAÍDA ──\nClassificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]\nSíntese: [resposta direta]\nEvidências: [fontes/dados/base lógica]\nRiscos: [se houver]\nPróxima ação: [recomendação objetiva]\n\n── REGRA FINAL ──\nEm dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente."
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px', alignItems: 'start' }}>

                  {/* Bloco 1 — Metaprompt */}
                  <div className="card" style={{ padding: '28px' }}>
                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>01</span>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>Metaprompt: Assistente Profissional Governado</h3>
                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
                      Cole no campo de instruções do ChatGPT (ou system prompt do Claude/Gemini) e troque os <code style={{ background: 'var(--bg-deep)', padding: '1px 4px', borderRadius: '3px' }}>[colchetes]</code>. Pronto.
                    </p>
                    <div style={{
                      position: 'relative',
                      background: 'var(--bg-deep)',
                      border: '1px solid var(--border)',
                      borderRadius: '8px',
                      marginBottom: '12px',
                    }}>
                      <pre style={{
                        fontFamily: 'monospace',
                        fontSize: '12px',
                        color: 'var(--text-muted)',
                        lineHeight: 1.6,
                        padding: '16px',
                        maxHeight: '300px',
                        overflowY: 'auto',
                        whiteSpace: 'pre-wrap',
                        wordBreak: 'break-word',
                        margin: 0,
                      }}>{METAPROMPT_V3}</pre>
                    </div>
                    <button
                      onClick={() => {
                        if (copyTimerRef.current) clearTimeout(copyTimerRef.current)
                        navigator.clipboard.writeText(METAPROMPT_V3).then(() => {
                          setCopied(true)
                          copyTimerRef.current = setTimeout(() => setCopied(false), 2000)
                        }).catch(() => setCopied(false))
                      }}
                      className="btn btn-primary"
                      style={{ width: '100%' }}
                    >
                      {copied ? 'Copiado!' : '📋 Copiar metaprompt'}
                    </button>
                  </div>

                  {/* Bloco 2 — Checklist */}
                  <div className="card" style={{ padding: '28px' }}>
                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>02</span>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>Checklist: Segurança de IA em 1 Página</h3>
                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '20px', lineHeight: 1.6 }}>
                      Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.
                    </p>
#!/usr/bin/env bash
# EGOS Hermes Event-Driven Trigger
# Invoked via SSH from .husky/post-push (async) and as cron fallback.
#
# Architecture (validated by Codex 2026-05-27):
#   - Atomic lock via `mkdir` (TOCTOU-safe; touch+test would race).
#   - Debounce: skip if last successful RUN < 600s ago.
#   - --since=2h with DEDUP-001 SHA marker (no re-processing risk).
#   - Cron fallback every 2h covers missed pushes / commit-without-push.

set -u

REPO="${EGOS_REPO_PATH:-/opt/egos-git}"
# SECURITY: whitelist allowed repo paths — prevents env-injection redirection
case "$REPO" in
  /opt/egos-git|/opt/egos) ;;
  *) echo "[$(date -Iseconds)] hermes-trigger: FATAL invalid REPO=$REPO" >&2; exit 2 ;;
esac

STATE_DIR="$REPO/.hermes-state"
LOCKDIR="$STATE_DIR/lock.d"
RUN_TS_FILE="$STATE_DIR/last_run_ts"
LOG="${HERMES_LOG:-/var/log/egos/hermes-review.log}"
DEBOUNCE_SECS="${HERMES_DEBOUNCE_SECS:-600}"
SINCE="${HERMES_SINCE:-2h}"
STALE_LOCK_MIN="${HERMES_STALE_LOCK_MIN:-30}"

mkdir -p "$STATE_DIR" "$(dirname "$LOG")"

ts() { date -Iseconds; }
log() { echo "[$(ts)] hermes-trigger: $*" >> "$LOG"; }

NOW=$(date +%s)
LAST_RUN=$(cat "$RUN_TS_FILE" 2>/dev/null || echo 0)
DELTA=$((NOW - LAST_RUN))

# Debounce: protects against rapid-fire pushes during active session.
if [ "$LAST_RUN" -gt 0 ] && [ "$DELTA" -lt "$DEBOUNCE_SECS" ]; then
  log "debounced (delta=${DELTA}s < ${DEBOUNCE_SECS}s)"
  exit 0
fi

# Reap stale lock (process killed mid-run leaves lockdir behind).
if [ -d "$LOCKDIR" ]; then
  find "$LOCKDIR" -maxdepth 0 -mmin +"$STALE_LOCK_MIN" -exec rmdir {} \; 2>/dev/null \
    && log "WARN: reaped stale lock (>${STALE_LOCK_MIN}min)"
fi

# Atomic lock — only one Hermes run at a time.
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  log "locked (another run in progress)"
  exit 0
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT

cd "$REPO" || { log "FATAL: cannot cd to $REPO"; exit 1; }
HEAD_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
RUN_ID="${NOW}-$$"
log "starting run_id=$RUN_ID head=$HEAD_SHA delta=${DELTA}s since=${SINCE}"

PREV_SHA=$(cat "$STATE_DIR/last_gw_sha" 2>/dev/null || echo "")
git pull --ff-only -q 2>/dev/null || log "WARN: git pull --ff-only failed (run_id=$RUN_ID)"
NEW_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")

# VPS-GATEWAY-AUTOSYNC-001: sync /opt/egos-gateway when apps/egos-gateway/ changed
GW_DIR="/opt/egos-gateway"
if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
  GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
  if [ -n "$GW_CHANGED" ]; then
    log "gateway changed ($PREV_SHA -> $NEW_SHA) — syncing $GW_DIR"
    rsync -a --exclude=node_modules --exclude=.env "$REPO/apps/egos-gateway/" "$GW_DIR/" \
      && log "rsync OK" \
      || log "WARN: rsync failed"
    cd "$GW_DIR" && docker compose build --no-cache -q \
      && docker compose up -d \
      && log "gateway rebuilt and restarted" \
      || log "WARN: docker rebuild failed"
    cd "$REPO"
  fi
fi
echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"

HOME=/root bun scripts/hermes-commit-review.ts --since="$SINCE" >> "$LOG" 2>&1
RC=$?

# NLM-HERMES-002b: Run NotebookLM document sync detector
log "running notebook-sync-detect (run_id=$RUN_ID)"
HOME=/root bun scripts/notebook-sync-detect.ts --exec >> "$LOG" 2>&1
DETECT_RC=$?
if [ "$DETECT_RC" -ne 0 ]; then
  log "WARN: notebook-sync-detect failed with rc=$DETECT_RC (run_id=$RUN_ID)"
fi

# Stamp with fresh timestamp (NOT pre-run NOW) — protects post-run quiet period.
if [ "$RC" -eq 0 ]; then
  date +%s > "$RUN_TS_FILE"
  log "done OK run_id=$RUN_ID"
else
  log "done FAIL run_id=$RUN_ID rc=$RC (timestamp NOT updated)"
fi

exit "$RC"

exec
/bin/bash -lc "find apps/egos-gateway -maxdepth 2 -type f -print | sort && cat apps/egos-gateway/Dockerfile 2>/dev/null || true && cat apps/egos-gateway/docker-compose.yml 2>/dev/null || cat apps/egos-gateway/compose.yml 2>/dev/null || true && cat package.json | sed -n '1,80p' && find packages -maxdepth 2 -type d -name '*guard*' -o -type f -path '*guard*' | head -20" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/.dockerignore
apps/egos-gateway/Dockerfile
apps/egos-gateway/README.md
apps/egos-gateway/bun.lock
apps/egos-gateway/docker-compose.yml
apps/egos-gateway/guardrails.yaml
apps/egos-gateway/openapi.yaml
apps/egos-gateway/package.json
apps/egos-gateway/scripts/smoke-cross-tenant.sh
apps/egos-gateway/src/health-monitor.ts
apps/egos-gateway/src/orchestrator.ts
apps/egos-gateway/src/pii-gate.test.ts
apps/egos-gateway/src/server.ts
apps/egos-gateway/tsconfig.json
FROM oven/bun:1.3
WORKDIR /app
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile 2>/dev/null || bun install
COPY . .
ENV GATEWAY_PORT=3050
EXPOSE 3050
CMD ["bun", "run", "src/server.ts"]
services:
  egos-gateway:
    build: .
    container_name: egos-gateway
    restart: unless-stopped
    ports:
      - "127.0.0.1:3050:3050"
    env_file:
      - .env
    environment:
      - GATEWAY_PORT=3050
    networks:
      - infra_bracc
      - evolution-api_default

networks:
  infra_bracc:
    external: true
  evolution-api_default:
    external: true
{
  "name": "egos",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "EGOS — Orchestration kernel for governed AI agents",
  "license": "MIT",
  "author": "Enio Rocha <enio@egos.ia.br>",
  "bin": {
    "egos": "./bin/egos.ts"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git"
  },
  "workspaces": [
    "packages/*",
    "apps/*",
    "central-egos/*"
  ],
  "scripts": {
    "setup": "sh setup.sh",
    "egos:init": "sh scripts/egos-init.sh",
    "agent:list": "bun agents/cli.ts list",
    "agent:run": "bun agents/cli.ts run",
    "agent:lint": "bun agents/cli.ts lint-registry",
    "coordination:watch": "bun run scripts/coordination-watcher.ts",
    "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
    "lint": "eslint .",
    "prepare": "husky",
    "precommit": "bash .husky/pre-commit",
    "governance:sync": "sh scripts/governance-sync.sh --dry",
    "governance:sync:exec": "sh scripts/governance-sync.sh --exec --propagate",
    "governance:sync:local": "sh scripts/governance-sync.sh --exec --no-propagate",
    "governance:check": "sh scripts/governance-sync.sh --check",
    "template:check": "bun scripts/validate-inherits.ts && bun scripts/lint-domain-template.ts",
    "template:check:strict": "bun scripts/validate-inherits.ts --strict && bun scripts/lint-domain-template.ts --strict",
    "governance:runtime:smoke": "bun scripts/runtime-smoke.ts",
    "governance:runtime:smoke:json": "bun scripts/runtime-smoke.ts --json",
    "governance:runtime:report": "bun scripts/runtime-operator-report.ts",
    "governance:runtime:report:json": "bun scripts/runtime-operator-report.ts --json",
    "gov:check": "bun run scripts/runtime-smoke-validator.ts",
    "gov:telemetry": "bun run scripts/hook-telemetry-report.ts --week",
    "gov:telemetry:daily": "bun run scripts/hook-telemetry-report.ts --day",
    "gov:evidence-gate:dry": "bun run scripts/evidence-gate-disseminate.ts --dry-run",
    "gov:sync:dry": "bun run ~/.eos/scripts/core/governance-sync.sh --dry-run",
    "gov:sync": "bun run ~/.eos/scripts/core/governance-sync.sh --exec",
    "tasks:archive": "bun scripts/tasks-archive.ts --dry",
    "tasks:archive:exec": "bun scripts/tasks-archive.ts --exec",
    "tasks:reconcile": "bun scripts/task-reconciliation.ts --summary",
    "tasks:calibrate": "bun scripts/calibrate-tasks.ts",
    "tasks:audit": "bun scripts/hermes-task-audit.ts --dry",
    "tasks:audit:write": "bun scripts/hermes-task-audit.ts",
    "claude:telemetry": "bun scripts/claude-hook-telemetry.ts",
    "claude:telemetry:json": "bun scripts/claude-hook-telemetry.ts --json",
    "claude:telemetry:otel": "bun scripts/claude-hook-telemetry.ts --otel",
    "claude:telemetry:otel:json": "bun scripts/claude-hook-telemetry.ts --otel --json",
    "egos:boot": "bash scripts/egos-boot.sh",
    "ssot:check": "bun scripts/validate-ssot.ts",
    "ssot:claim-check": "bun scripts/ssot-claim-check.ts",
    "ssot:diagnostic": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --output /tmp/qa-ssot-check.md",
    "ssot:diagnostic:json": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --format json --output /tmp/qa-ssot-check.json",
    "smoke:api": "bun scripts/smoke-test-api.ts",
    "version:lock": "bun scripts/check-version-lock.ts",
    "integration:check": "bun scripts/integration-release-check.ts",
    "pr:pack": "bun scripts/pr-pack.ts",
    "pr:gate": "bun scripts/pr-gate.ts",
    "pr:audit": "bun scripts/pr-ecosystem-audit.ts",
    "ssot:link": "sh scripts/link-ssot-files.sh --dry",
    "ssot:link:exec": "sh scripts/link-ssot-files.sh --exec",
    "qa:observability": "bash scripts/qa/run_observability_suite.sh",
    "qa:pending": "python scripts/qa/list_pending_tasks.py --input TASKS.md",
    "qa:pending:json": "python scripts/qa/list_pending_tasks.py --input TASKS.md --format json",
    "qa:stalled": "python scripts/qa/stalled_tasks_report.py --input TASKS.md",
    "qa:evidence": "python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt",
    "qa:evidence:gate": "python scripts/qa/telemetry_guardrail.py --input tests/qa/fixtures/sample_telemetry.txt --output /tmp/qa-guardrail.txt && python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt --enforce",
    "qa:compose": "python scripts/qa/compose_qa_envelope.py --guardrail /tmp/qa-guardrail.txt --ssot /tmp/qa-ssot-check.md --evidence /tmp/qa-evidence.md --output /tmp/qa-envelope.json",
    "security:audit": "bun scripts/security-audit.ts",
    "security:audit:json": "bun scripts/security-audit.ts --json",
    "security:audit:fix": "bun scripts/security-audit.ts --fix",
packages/guard-brasil
packages/guard-brasil/tsconfig.json
packages/guard-brasil/check.ts
packages/guard-brasil/tsconfig.tsbuildinfo
packages/guard-brasil/test_db.ts
packages/guard-brasil/README.md
packages/guard-brasil/package.json
packages/guard-brasil/tsconfig.build.json
packages/guard-brasil-python
packages/guard-brasil-python/pyproject.toml
packages/guard-brasil-python/guard_brasil
packages/guard-brasil-python/README.md
packages/guard-brasil-langchain
packages/guard-brasil-langchain/tsconfig.json
packages/guard-brasil-langchain/README.md
packages/guard-brasil-langchain/package.json
packages/guard-brasil-mcp
packages/guard-brasil-mcp/glama.json
packages/guard-brasil-mcp/tsconfig.json
packages/guard-brasil-mcp/smithery.yaml

exec
/bin/bash -lc 'cat apps/egos-gateway/package.json && grep -n "guard-brasil" -n apps/egos-gateway/bun.lock bun.lock | head -20' in /home/enio/egos
 succeeded in 0ms:
{
  "name": "@egos/gateway",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "bun run --env-file ../../.env --watch src/server.ts",
    "start": "bun run --env-file ../../.env src/server.ts",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@egosbr/guard-brasil": "workspace:*",
    "hono": "^4.6.0"
  },
  "devDependencies": {
    "@types/bun": "^1.1.0",
    "typescript": "^5.6.0"
  }
}
bun.lock:65:        "@egosbr/guard-brasil": "workspace:*",
bun.lock:261:    "packages/guard-brasil": {
bun.lock:262:      "name": "@egosbr/guard-brasil",
bun.lock:268:    "packages/guard-brasil-langchain": {
bun.lock:269:      "name": "@egosbr/guard-brasil-langchain",
bun.lock:272:        "@egosbr/guard-brasil": "^0.2.2",
bun.lock:278:    "packages/guard-brasil-mcp": {
bun.lock:279:      "name": "@egosbr/guard-brasil-mcp",
bun.lock:282:        "guard-brasil-mcp": "src/index.ts",
bun.lock:669:    "@egosbr/guard-brasil": ["@egosbr/guard-brasil@workspace:packages/guard-brasil"],
bun.lock:671:    "@egosbr/guard-brasil-langchain": ["@egosbr/guard-brasil-langchain@workspace:packages/guard-brasil-langchain"],
bun.lock:673:    "@egosbr/guard-brasil-mcp": ["@egosbr/guard-brasil-mcp@workspace:packages/guard-brasil-mcp"],
bun.lock:2003:    "@egosbr/guard-brasil/@supabase/supabase-js": ["@supabase/supabase-js@2.107.0", "", { "dependencies": { "@supabase/auth-js": "2.107.0", "@supabase/functions-js": "2.107.0", "@supabase/postgrest-js": "2.107.0", "@supabase/realtime-js": "2.107.0", "@supabase/storage-js": "2.107.0" } }, "sha512-ChKzdlWVweMUUhr0U79JhMmgm1haS/C5JquaiCDr70JaGARRtjjoY9rkIheXWybXxTSNzRiQs3Sk8IAg1HS3ZA=="],
bun.lock:2005:    "@egosbr/guard-brasil-mcp/@types/node": ["@types/node@20.19.39", "", { "dependencies": { "undici-types": "~6.21.0" } }, "sha512-orrrD74MBUyK8jOAD/r0+lfa1I2MO6I+vAkmAWzMYbCcgrN4lCrmK52gRFQq/JRxfYPfonkr4b0jcY7Olqdqbw=="],
bun.lock:2007:    "@egosbr/guard-brasil-mcp/typescript": ["typescript@5.9.3", "", { "bin": { "tsc": "bin/tsc", "tsserver": "bin/tsserver" } }, "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw=="],
bun.lock:2009:    "@egosbr/guard-brasil-mcp/zod": ["zod@3.25.76", "", {}, "sha512-gzUt/qt81nXsFGKIFcC3YnfEAx5NkunCfnDlvuBSSFS02bcXu4Lmea0AFIUwbLWxWPx3d9p8S5QoaujKcNQxcQ=="],
bun.lock:2173:    "@egosbr/guard-brasil-mcp/@types/node/undici-types": ["undici-types@6.21.0", "", {}, "sha512-iwDZqg0QAGrg9Rav5H4n0M64c3mkR59cJ6wQp+7C4nI0gsmExaedaYLNO44eT4AtBBwjbTiGPMlt2Md0T9H9JQ=="],
bun.lock:2175:    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/auth-js": ["@supabase/auth-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-XA7x+WIeIvuC3GTZ2ey67QcBbGw4n+o5B7M+dMm9KT1lL3wX1B52DfEWW00WuPt/LnniJLLIn1WIm9YPtuxzKQ=="],
bun.lock:2177:    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/functions-js": ["@supabase/functions-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-iMtRUmEj1KOgQd/a3MR4hnBlPnZc62DW8+z8aPpnzbxWkexEZUVL2fSgvvp15gqFg1V55e2yMGqgK+yhSQxp5w=="],
bun.lock:2179:    "@egosbr/guard-brasil/@supabase/supabase-js/@supabase/postgrest-js": ["@supabase/postgrest-js@2.107.0", "", { "dependencies": { "tslib": "2.8.1" } }, "sha512-7ARs47/tyIjX7T0Ive20d4NY8zQYXsP5/P07jJWxffSIM2gpnSnGRnL/Fe15GPbdjsW2sTYeckHcyaoKbM6yWQ=="],

exec
/bin/bash -lc "grep -n \"function transcribeAudio\\|function describeImage\\|OPENAI\\|gemini\" apps/egos-gateway/src/orchestrator.ts | head -50 && sed -n '120,240p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
5: * Model: google/gemini-2.0-flash-001 (OpenRouter)
7: * Vision: google/gemini-2.0-flash-001 (multimodal)
29: * Default: gemini-2.0-flash-001 via OpenRouter (PT-BR nativo, tool-calling sólido,
43:const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
44:const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";
47:  // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
48:  if (modelName.startsWith("gemini-") || modelName.startsWith("gpt-") ||
51:    const orModel = modelName.startsWith("gemini-") ? `google/${modelName}`
207:  "google/gemini-2.0-flash-001": { input: 0.0001, output: 0.0004 },
208:  "google/gemini-2.5-pro":       { input: 0.0025, output: 0.0100 },
210:  "google/gemini-2.0-flash":     { input: 0.0001, output: 0.0004 },
243:  if (m.includes("gemini") || m.includes("gemma")) return "Google";
1282:export async function transcribeAudio(audioBase64: string, mime: string): Promise<string> {
1311:export async function describeImage(imageBase64: string, mime: string, caption?: string): Promise<string> {
1319:        model: "google/gemini-2.0-flash-001",
1587:    toolsUsed.push("gemini-2.0-flash");
const SB_HEADERS = () => ({
  apikey: SUPABASE_KEY,
  Authorization: `Bearer ${SUPABASE_KEY}`,
  "Content-Type": "application/json",
  Prefer: "return=minimal",
});

async function sbFetch(path: string): Promise<unknown> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return null;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
      headers: SB_HEADERS(),
      signal: AbortSignal.timeout(6000),
    });
    return res.ok ? res.json() : null;
  } catch {
    return null;
  }
}

async function sbInsert(table: string, row: Record<string, unknown>): Promise<boolean> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return false;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}`, {
      method: "POST",
      headers: SB_HEADERS(),
      body: JSON.stringify(row),
      signal: AbortSignal.timeout(6000),
    });
    return res.status === 201 || res.status === 200;
  } catch {
    return false;
  }
}

// ─── Conversation memory ──────────────────────────────────────────────────────

interface HistoryRow {
  role: "user" | "assistant";
  content: string;
  created_at: string;
}

async function loadHistory(channel: string, userId: string, limit = 12): Promise<HistoryRow[]> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return [];
  try {
    const rows = await sbFetch(
      `egos_chat_history?channel=eq.${encodeURIComponent(channel)}&user_id=eq.${encodeURIComponent(userId)}&order=created_at.desc&limit=${limit}&select=role,content,created_at`
    ) as HistoryRow[] | null;
    if (!rows?.length) return [];
    return rows.reverse(); // oldest first for LLM context
  } catch {
    return [];
  }
}

async function saveHistory(
  channel: string,
  userId: string,
  userContent: string,
  assistantContent: string,
  toolsUsed: string[],
  mediaType?: string,
): Promise<void> {
  if (!SUPABASE_URL || !SUPABASE_KEY) return;
  // Save user turn
  await sbInsert("egos_chat_history", {
    channel,
    user_id: userId,
    role: "user",
    content: userContent,
    media_type: mediaType ?? null,
    tools_used: [],
  });
  // Save assistant turn
  await sbInsert("egos_chat_history", {
    channel,
    user_id: userId,
    role: "assistant",
    content: assistantContent,
    tools_used: toolsUsed,
  });
}

// ─── Token accounting (RATIO-ABSORB-004) ─────────────────────────────────────

const MODEL_COST_PER_1K: Record<string, { input: number; output: number }> = {
  "google/gemini-2.0-flash-001": { input: 0.0001, output: 0.0004 },
  "google/gemini-2.5-pro":       { input: 0.0025, output: 0.0100 },
  "minimax/minimax-m2.5":        { input: 0.0002, output: 0.0002 },
  "google/gemini-2.0-flash":     { input: 0.0001, output: 0.0004 },
};

function estimateCostUsd(model: string, inputTokens: number, outputTokens: number): number {
  const rates = MODEL_COST_PER_1K[model] ?? { input: 0.0005, output: 0.0015 };
  return (inputTokens / 1000) * rates.input + (outputTokens / 1000) * rates.output;
}

async function logTokenUsage(
  clientSlug: string | undefined,
  model: string,
  inputTokens: number,
  outputTokens: number,
  channel: string,
): Promise<void> {
  if (!SUPABASE_URL || !SUPABASE_KEY || !clientSlug) return;
  const cost = estimateCostUsd(model, inputTokens, outputTokens);
  try {
    await fetch(`${SUPABASE_URL}/rest/v1/consulting_token_log`, {
      method: "POST",
      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, "Content-Type": "application/json", Prefer: "return=minimal" },
      body: JSON.stringify({ tenant: clientSlug, model, input_tokens: inputTokens, output_tokens: outputTokens, cost_usd: cost, channel }),
      signal: AbortSignal.timeout(5000),
    });
  } catch { /* best-effort */ }
}

// Canonical per-call usage log (api_usage) — written on EVERY LLM call, not just
// tenant ones. Read by get_costs + scripts/llm-usage-notify.ts. Before 2026-06-01
// nothing wrote here, so cost tracking was silently dead.
function providerFromModel(model: string): string {

exec
/bin/bash -lc "sed -n '1270,1345p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
      const voltage = p.voltage ? ` · ${p.voltage}` : "";
      return `${i + 1}. ${p.name} — R$ ${Number(p.price).toFixed(2)} · ${condLabel} · ${p.stock} un.${warranty}${voltage}`;
    });

    return `Encontrei ${products.length} produto(s):\n${lines.join("\n")}`;
  } catch (e) {
    return `Erro ao consultar catálogo: ${(e as Error).message}. Confirme com a equipe da loja.`;
  }
}

// ─── Media processing ─────────────────────────────────────────────────────────

export async function transcribeAudio(audioBase64: string, mime: string): Promise<string> {
  if (!GROQ_KEY) return "[Transcrição não configurada — GROQ_API_KEY ausente]";
  try {
    const binaryStr = atob(audioBase64);
    const bytes = new Uint8Array(binaryStr.length);
    for (let i = 0; i < binaryStr.length; i++) bytes[i] = binaryStr.charCodeAt(i);

    const ext = mime.includes("mp4") ? "mp4" : mime.includes("ogg") ? "ogg"
      : mime.includes("mpeg") ? "mp3" : mime.includes("wav") ? "wav" : "ogg";

    const form = new FormData();
    form.append("file", new Blob([bytes], { type: mime }), `audio.${ext}`);
    form.append("model", "whisper-large-v3-turbo");
    form.append("response_format", "text");
    form.append("language", "pt");

    const res = await fetch("https://api.groq.com/openai/v1/audio/transcriptions", {
      method: "POST",
      headers: { Authorization: `Bearer ${GROQ_KEY}` },
      body: form,
      signal: AbortSignal.timeout(30000),
    });
    if (!res.ok) return `[Erro na transcrição: ${res.status}]`;
    return (await res.text()).trim() || "[Áudio sem fala]";
  } catch (e) {
    return `[Erro na transcrição: ${(e as Error).message}]`;
  }
}

export async function describeImage(imageBase64: string, mime: string, caption?: string): Promise<string> {
  if (!OPENROUTER_KEY) return "[Análise de imagem não configurada]";
  try {
    const dataUrl = `data:${mime};base64,${imageBase64}`;
    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENROUTER_KEY}`, "Content-Type": "application/json", "HTTP-Referer": "https://egos.dev", "X-Title": "egos" },
      body: JSON.stringify({
        model: "google/gemini-2.0-flash-001",
        messages: [{
          role: "user",
          content: [
            { type: "image_url", image_url: { url: dataUrl } },
            { type: "text", text: caption ? `Descreva esta imagem. Contexto: "${caption}"` : "Descreva o que você vê nesta imagem." },
          ],
        }],
        max_tokens: 500,
      }),
      signal: AbortSignal.timeout(20000),
    });
    if (!res.ok) return "[Erro na análise da imagem]";
    const d = await res.json() as { choices?: Array<{ message: { content: string } }> };
    return d.choices?.[0]?.message?.content ?? "[Sem descrição]";
  } catch (e) {
    return `[Erro na análise: ${(e as Error).message}]`;
  }
}

// ─── Citation verification (RATIO-ABSORB-002) ────────────────────────────────

// Cache: tenant tem kb_pages? (evita fetch a cada msg)
const tenantHasKbCache: Map<string, { has: boolean; ts: number }> = new Map();

async function tenantHasKbPages(clientSlug: string): Promise<boolean> {
  const cached = tenantHasKbCache.get(clientSlug);

exec
/bin/bash -lc "grep -n \"saveHistory\" -n apps/egos-gateway/src/orchestrator.ts | tail -5 && sed -n '1710,1785p' apps/egos-gateway/src/orchestrator.ts" in /home/enio/egos
 succeeded in 0ms:
176:async function saveHistory(
1704:      saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
1729:  saveHistory(msg.channel, msg.from, userText, fallback, toolsUsed, msg.mediaType).catch(() => {});
    }

    // Push assistant message with tool_calls
    messages.push({ role: "assistant", content: message.content ?? "", tool_calls: message.tool_calls });

    // Execute each tool call
    for (const tc of message.tool_calls) {
      let args: Record<string, unknown> = {};
      try { args = JSON.parse(tc.function.arguments); } catch { /* noop */ }

      console.log(`[orchestrator] Tool: ${tc.function.name}(${JSON.stringify(args)})`);
      const result = await dispatchTool(tc.function.name, args, { channel: msg.channel, userId: msg.from, clientSlug: client?.slug, kbAccess: client?.kbAccess });
      toolsUsed.push(tc.function.name);

      messages.push({ role: "tool", tool_call_id: tc.id, name: tc.function.name, content: result });
    }
  }

  const fallback = "Processamento completo.";
  saveHistory(msg.channel, msg.from, userText, fallback, toolsUsed, msg.mediaType).catch(() => {});
  return { text: fallback, toolsUsed };
}

exec
/bin/bash -lc "nl -ba apps/egos-gateway/src/orchestrator.ts | sed -n '1580,1612p'; nl -ba apps/egos-gateway/package.json | sed -n '8,16p'; nl -ba apps/egos-gateway/Dockerfile | sed -n '1,8p'; nl -ba scripts/hermes-trigger.sh | sed -n '61,80p'" in /home/enio/egos
 succeeded in 0ms:
  1580	    const transcription = await transcribeAudio(msg.mediaBase64, msg.mediaMime);
  1581	    userText = `[Transcrição do áudio]: ${transcription}`;
  1582	    toolsUsed.push("whisper");
  1583	    console.log(`[orchestrator] Audio transcribed: "${transcription.slice(0, 80)}"`);
  1584	  } else if (msg.mediaType === "image" && msg.mediaBase64 && msg.mediaMime) {
  1585	    const description = await describeImage(msg.mediaBase64, msg.mediaMime, msg.caption);
  1586	    userText = `[Imagem]: ${description}${msg.caption ? ` | Legenda do usuário: "${msg.caption}"` : ""}`;
  1587	    toolsUsed.push("gemini-2.0-flash");
  1588	    console.log(`[orchestrator] Image described: "${description.slice(0, 60)}"`);
  1589	  } else if (msg.mediaType === "document") {
  1590	    userText = `[Arquivo recebido: ${msg.fileName ?? "sem nome"}]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo conteúdo de arquivos ainda.`;
  1591	  } else if (msg.mediaType === "video") {
  1592	    userText = `[Vídeo recebido]${msg.caption ? ` — "${msg.caption}"` : ""}. Não processo vídeos ainda. Posso transcrever áudio e descrever imagens.`;
  1593	  } else if (msg.mediaType === "sticker") {
  1594	    return { text: "😄" };
  1595	  } else if (!userText) {
  1596	    return { text: "Mensagem recebida mas não reconhecida. Envie texto, áudio ou imagem." };
  1597	  }
  1598	
  1599	  // Phase 1.5: PII masking — R-SEC-002 [T0]
  1600	  // Strip Brazilian PII (CPF/CNPJ/RG/phone/email/MASP/REDS/plate/…) before
  1601	  // the text reaches any external LLM. Applied to userText regardless of
  1602	  // channel (WhatsApp/Telegram) and media origin (typed, transcribed, described).
  1603	  // Does NOT block the request — masks in-place so conversation still flows.
  1604	  const piiMasked = maskPII(userText);
  1605	  if (piiMasked !== userText) {
  1606	    console.warn(`[orchestrator][pii-gate] PII masked before LLM send — from=${msg.from} channel=${msg.channel}`);
  1607	  }
  1608	  userText = piiMasked;
  1609	
  1610	  // Phase 2: Load conversation history + build messages
  1611	  type ChatMsg = {
  1612	    role: "system" | "user" | "assistant" | "tool";
     8	    "start": "bun run --env-file ../../.env src/server.ts",
     9	    "typecheck": "tsc --noEmit"
    10	  },
    11	  "dependencies": {
    12	    "@egosbr/guard-brasil": "workspace:*",
    13	    "hono": "^4.6.0"
    14	  },
    15	  "devDependencies": {
    16	    "@types/bun": "^1.1.0",
     1	FROM oven/bun:1.3
     2	WORKDIR /app
     3	COPY package.json bun.lock* ./
     4	RUN bun install --frozen-lockfile 2>/dev/null || bun install
     5	COPY . .
     6	ENV GATEWAY_PORT=3050
     7	EXPOSE 3050
     8	CMD ["bun", "run", "src/server.ts"]
    61	PREV_SHA=$(cat "$STATE_DIR/last_gw_sha" 2>/dev/null || echo "")
    62	git pull --ff-only -q 2>/dev/null || log "WARN: git pull --ff-only failed (run_id=$RUN_ID)"
    63	NEW_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
    64	
    65	# VPS-GATEWAY-AUTOSYNC-001: sync /opt/egos-gateway when apps/egos-gateway/ changed
    66	GW_DIR="/opt/egos-gateway"
    67	if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
    68	  GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
    69	  if [ -n "$GW_CHANGED" ]; then
    70	    log "gateway changed ($PREV_SHA -> $NEW_SHA) — syncing $GW_DIR"
    71	    rsync -a --exclude=node_modules --exclude=.env "$REPO/apps/egos-gateway/" "$GW_DIR/" \
    72	      && log "rsync OK" \
    73	      || log "WARN: rsync failed"
    74	    cd "$GW_DIR" && docker compose build --no-cache -q \
    75	      && docker compose up -d \
    76	      && log "gateway rebuilt and restarted" \
    77	      || log "WARN: docker rebuild failed"
    78	    cd "$REPO"
    79	  fi
    80	fi

exec
/bin/bash -lc 'tmp=$(mktemp -d); cp apps/egos-gateway/package.json apps/egos-gateway/bun.lock "$tmp"/ 2>/dev/null || true; (cd "$tmp" && bun install --frozen-lockfile) 2>&1 | sed -n '"'1,80p'; rm -rf \""'$tmp"' in /home/enio/egos
 succeeded in 0ms:
bun install v1.3.9 (cf6cdbbb)
error: Workspace dependency "@egosbr/guard-brasil" not found

Searched in "./*"

Workspace documentation: https://bun.com/docs/install/workspaces

error: @egosbr/guard-brasil@workspace:* failed to resolve

codex
The gateway change introduces a workspace dependency that breaks the current standalone Docker deployment path, and the PII gate still leaks media inputs to external providers before masking. These are functional/security regressions that should be fixed before considering the patch correct.

Full review comments:

- [P1] Fix standalone gateway builds after workspace dependency — /home/enio/egos/apps/egos-gateway/package.json:12-12
  When the gateway is built from `/opt/egos-gateway` (the Dockerfile copies only the app's `package.json`/`bun.lock`, and `hermes-trigger.sh` rsyncs only `apps/egos-gateway/`), this new `workspace:*` dependency cannot be resolved; `bun install --frozen-lockfile` in an app-only copy fails with `Workspace dependency "@egosbr/guard-brasil" not found`. Include the workspace package/root context in the Docker build/sync, or depend on a published/package-local artifact.

- [P1] Mask media before sending it to external processors — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1599-1604
  For audio or image messages containing CPF/phone/email/etc., this mask runs only after `transcribeAudio`/`describeImage`, but those helpers already send the raw audio/image and caption to Groq/OpenRouter. In that scenario the new PII gate does not satisfy “before any external LLM” for media inputs; either block/locally process media with potential PII, or otherwise redact before those external calls.

- [P2] Avoid logging user identifiers on PII hits — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1605-1607
  When masking is triggered, this log writes `msg.from`; for WhatsApp/Telegram this is commonly a phone/JID or other user identifier, so messages containing PII now create a persistent log entry with another piece of personal data. Hash or omit the sender identifier in this security log.
The gateway change introduces a workspace dependency that breaks the current standalone Docker deployment path, and the PII gate still leaks media inputs to external providers before masking. These are functional/security regressions that should be fixed before considering the patch correct.

Full review comments:

- [P1] Fix standalone gateway builds after workspace dependency — /home/enio/egos/apps/egos-gateway/package.json:12-12
  When the gateway is built from `/opt/egos-gateway` (the Dockerfile copies only the app's `package.json`/`bun.lock`, and `hermes-trigger.sh` rsyncs only `apps/egos-gateway/`), this new `workspace:*` dependency cannot be resolved; `bun install --frozen-lockfile` in an app-only copy fails with `Workspace dependency "@egosbr/guard-brasil" not found`. Include the workspace package/root context in the Docker build/sync, or depend on a published/package-local artifact.

- [P1] Mask media before sending it to external processors — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1599-1604
  For audio or image messages containing CPF/phone/email/etc., this mask runs only after `transcribeAudio`/`describeImage`, but those helpers already send the raw audio/image and caption to Groq/OpenRouter. In that scenario the new PII gate does not satisfy “before any external LLM” for media inputs; either block/locally process media with potential PII, or otherwise redact before those external calls.

- [P2] Avoid logging user identifiers on PII hits — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1605-1607
  When masking is triggered, this log writes `msg.from`; for WhatsApp/Telegram this is commonly a phone/JID or other user identifier, so messages containing PII now create a persistent log entry with another piece of personal data. Hash or omit the sender identifier in this security log.
```
