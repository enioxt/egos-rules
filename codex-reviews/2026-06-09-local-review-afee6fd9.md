# Codex Local Review — 2026-06-09T18:31:26Z

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
session id: 019eada7-5d81-7f02-a813-914c34607c70
--------
user
changes against 'HEAD~3'
2026-06-09T18:31:28.366535Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T18:31:28.370895Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 4945ff2891fedfced7154e33d84b4096bbc48993 --stat && git diff 4945ff2891fedfced7154e33d84b4096bbc48993' in /home/enio/egos
 succeeded in 0ms:
 AGENTS.md                                        |   1 +
 TASKS.md                                         |   5 +-
 TASKS_ARCHIVE.md                                 |  19 ++++
 apps/egos-gateway/Dockerfile                     |  12 ++-
 apps/egos-gateway/package.json                   |   2 +
 apps/egos-gateway/src/orchestrator.ts            |  13 +++
 apps/egos-gateway/src/pii-gate.test.ts           |  72 +++++++++++++++
 apps/egos-landing/package.json                   |   2 +-
 apps/egos-landing/scripts/generate-metaprompt.ts |  40 ++++++++
 apps/egos-landing/src/App.tsx                    | 112 +----------------------
 apps/egos-landing/src/data/metaprompt-source.ts  |   6 ++
 bun.lock                                         |  42 +++++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json     |   4 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json    |  32 +++++++
 docs/presentations/mf-certificados-piloto.html   |  68 ++++++++++++--
 scripts/hermes-trigger.sh                        |  30 ++++++
 16 files changed, 332 insertions(+), 128 deletions(-)
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
diff --git a/apps/egos-gateway/Dockerfile b/apps/egos-gateway/Dockerfile
index 536a994e..6a21a4c3 100644
--- a/apps/egos-gateway/Dockerfile
+++ b/apps/egos-gateway/Dockerfile
@@ -1,8 +1,14 @@
+# EGOS Gateway — bundle-runtime (VPS-GATEWAY-AUTOSYNC-001, 2026-06-09)
+# O gateway é deployado como cópia standalone em /opt/egos-gateway, onde
+# `workspace:*` deps (@egosbr/guard-brasil) NÃO resolvem via bun install.
+# Solução: o deploy bundla src/server.ts → dist/server.js (maskPII inlined,
+# self-contained) NO MONOREPO, e o container só RODA o bundle — sem install.
+# Dev local roda via `bun run src/server.ts` (não usa este Dockerfile).
 FROM oven/bun:1.3
 WORKDIR /app
-COPY package.json bun.lock* ./
-RUN bun install --frozen-lockfile 2>/dev/null || bun install
 COPY . .
 ENV GATEWAY_PORT=3050
 EXPOSE 3050
-CMD ["bun", "run", "src/server.ts"]
+# dist/server.js é buildado pelo deploy (scripts/hermes-trigger.sh autosync ou
+# `bun run build`) ANTES do docker build. Sem bun install: bundle é autossuficiente.
+CMD ["bun", "dist/server.js"]
diff --git a/apps/egos-gateway/package.json b/apps/egos-gateway/package.json
index aa51cb8b..c665c5f4 100644
--- a/apps/egos-gateway/package.json
+++ b/apps/egos-gateway/package.json
@@ -6,9 +6,11 @@
   "scripts": {
     "dev": "bun run --env-file ../../.env --watch src/server.ts",
     "start": "bun run --env-file ../../.env src/server.ts",
+    "build": "bun build src/server.ts --target bun --outfile dist/server.js",
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
index befedf8b..d91188ac 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -118,5 +118,37 @@
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
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:31:18.782Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=3 sha=afee6fd9",
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
index ebb678f8..771bd96d 100755
--- a/scripts/hermes-trigger.sh
+++ b/scripts/hermes-trigger.sh
@@ -58,7 +58,37 @@ HEAD_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
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
+    log "gateway changed ($PREV_SHA -> $NEW_SHA) — building bundle + syncing $GW_DIR"
+    # 1. build guard-brasil dist (tsc emite mesmo com type-errors pré-existentes)
+    ( cd "$REPO/packages/guard-brasil" && bun run build >/dev/null 2>&1 ) || log "WARN: guard-brasil build non-zero (dist provavelmente emitido)"
+    # 2. garante symlink workspace p/ o bundler resolver @egosbr/guard-brasil
+    mkdir -p "$REPO/node_modules/@egosbr" && ln -sfn ../../packages/guard-brasil "$REPO/node_modules/@egosbr/guard-brasil"
+    # 3. rsync fonte (exclui dist — será buildado direto no destino)
+    rsync -a --exclude=node_modules --exclude=.env --exclude=dist "$REPO/apps/egos-gateway/" "$GW_DIR/" \
+      && log "rsync OK" || log "WARN: rsync failed"
+    # 4. bundle self-contained (maskPII inlined) direto no destino
+    mkdir -p "$GW_DIR/dist"
+    ( cd "$REPO" && bun build apps/egos-gateway/src/server.ts --target bun --outfile "$GW_DIR/dist/server.js" ) \
+      && log "bundle built ($(grep -c REMOVIDO "$GW_DIR/dist/server.js" 2>/dev/null) PII refs)" \
+      || { log "ERROR: bundle build failed — abortando deploy (gateway atual preservado)"; cd "$REPO"; echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"; }
+    # 5. rebuild container só roda o bundle (Dockerfile sem install)
+    if [ -f "$GW_DIR/dist/server.js" ]; then
+      cd "$GW_DIR" && docker compose build --no-cache -q && docker compose up -d \
+        && log "gateway rebuilt and restarted" || log "WARN: docker rebuild failed"
+    fi
+    cd "$REPO"
+  fi
+fi
+echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"
 
 HOME=/root bun scripts/hermes-commit-review.ts --since="$SINCE" >> "$LOG" 2>&1
 RC=$?

exec
/bin/bash -lc "sed -n '1,220p' apps/egos-gateway/src/orchestrator.ts && sed -n '1560,1645p' apps/egos-gateway/src/orchestrator.ts && sed -n '1,120p' apps/egos-gateway/src/server.ts && cat packages/guard-brasil/package.json && find packages/guard-brasil -maxdepth 2 -type f | sort | sed -n '1,80p'" in /home/enio/egos
 succeeded in 0ms:
/**
 * EGOS Gateway — AI Orchestrator v2
 *
 * Shared LLM orchestration for WhatsApp + Telegram chatbots.
 * Model: google/gemini-2.0-flash-001 (OpenRouter)
 * Transcription: Groq Whisper-large-v3-turbo
 * Vision: google/gemini-2.0-flash-001 (multimodal)
 *
 * Tools (21):
 *   system_status, guard_status, guard_test, gem_search, gem_trending,
 *   wiki_search, wiki_page, list_agents, get_tasks, recent_commits,
 *   get_costs, knowledge_stats, world_model
 */

import { join } from "path";
import { existsSync, readFileSync } from "fs";
import { execSync } from "child_process";
// PII masking before LLM payload (R-SEC-002 [T0] — dado soberano nunca sai da máquina)
import { maskPII } from "@egosbr/guard-brasil";

// ─── Config ───────────────────────────────────────────────────────────────────

const GROQ_KEY = process.env.GROQ_API_KEY ?? "";
const OPENROUTER_KEY = process.env.OPENROUTER_API_KEY ?? "";

/**
 * Multi-model config (CHAT-MODEL-001 — 2026-05-13)
 *
 * Default: gemini-2.0-flash-001 via OpenRouter (PT-BR nativo, tool-calling sólido,
 * multimodal nativo).
 *
 * Override: setar CHATBOT_PRIMARY_MODEL no .env do gateway.
 *
 * Fallback chain: primary → fallback (último recurso).
 */
interface LLMProvider {
  name: string;
  base: string;
  key: string;
  model: string;
}

const PRIMARY_MODEL = process.env.CHATBOT_PRIMARY_MODEL ?? "gemini-2.5-flash";
const FALLBACK_MODEL = process.env.CHATBOT_FALLBACK_MODEL ?? "google/gemini-2.0-flash-001";

function getProvider(modelName: string): LLMProvider | null {
  // Modelos via OpenRouter (gemini, gpt, claude, deepseek)
  if (modelName.startsWith("gemini-") || modelName.startsWith("gpt-") ||
      modelName.startsWith("claude-") || modelName.startsWith("deepseek-")) {
    if (!OPENROUTER_KEY) return null;
    const orModel = modelName.startsWith("gemini-") ? `google/${modelName}`
                  : modelName.startsWith("gpt-") ? `openai/${modelName}`
                  : modelName.startsWith("claude-") ? `anthropic/${modelName}`
                  : `deepseek/${modelName}`;
    return {
      name: modelName,
      base: "https://openrouter.ai/api/v1",
      key: OPENROUTER_KEY,
      model: orModel,
    };
  }
  // Via OpenRouter (fallback genérico com prefixo de provider)
  if (OPENROUTER_KEY && modelName.includes("/")) {
    return {
      name: modelName,
      base: "https://openrouter.ai/api/v1",
      key: OPENROUTER_KEY,
      model: modelName,
    };
  }
  return null;
}
const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
const GUARD_URL = "https://guard.egos.ia.br";
const GW_PORT = process.env.GATEWAY_PORT ?? "3000";
const GW = `http://localhost:${GW_PORT}`;
const ROOT = join(import.meta.dir, "../../..");

// ─── Types ────────────────────────────────────────────────────────────────────

export type MediaType = "audio" | "image" | "video" | "document" | "sticker";
export type Channel = "whatsapp" | "telegram";

export interface IncomingMessage {
  from: string;
  channel: Channel;
  text?: string;
  mediaType?: MediaType;
  mediaBase64?: string;
  mediaMime?: string;
  mediaUrl?: string;
  caption?: string;
  fileName?: string;
}

export interface OrchestratorResponse {
  text: string;
  toolsUsed?: string[];
}

export interface ClientContext {
  slug: string;
  name: string;
  sector: string;
  kbSource: "notion" | "obsidian" | "supabase";
  kbNotionWorkspace?: string;
  apiBudgetBrl: number;
  apiUsedBrl: number;
  // Member context (optional — populated when request comes from a team member)
  memberName?: string;
  memberRole?: "owner" | "partner" | "associate" | "intern";
  kbAccess?: string[]; // empty = full access
  // Extra rules injected per-client (anti-hallucination, tone, restrictions)
  extraRules?: string;
}

// ─── Supabase helpers ─────────────────────────────────────────────────────────

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
/**
 * EGOS Gateway — Main Server v0.3.0
 *
 * Central ingress for external channel webhooks and chatbot interactions.
 * Runs on Hono + Bun.
 *
 * Routes:
 *   GET  /health                — gateway health
 *   GET  /ui                    — Knowledge System visual dashboard
 *   GET  /knowledge/*           — Knowledge API (wiki pages + learnings)
 *   GET  /gem-hunter/*          — Gem Hunter API (discovery engine)
 *   POST /channels/whatsapp/*   — Evolution API webhooks → AI Orchestrator
 *   POST /telegram/webhook      — Telegram bot webhook (egosin_bot)
 *   GET  /telegram/health       — Telegram channel health
 *   POST /telegram/setup-webhook — Register Telegram webhook URL
 *   GET  /guard-brasil/health   — x402 channel health (free)
 *   POST /guard-brasil/inspect  — PII inspection ($0.001 USDC via x402)
 */

import { Hono } from "hono";
import { logger } from "hono/logger";
import { whatsapp } from "./channels/whatsapp.js";
import { knowledge } from "./channels/knowledge.js";
import { ui } from "./channels/ui.js";
import { gemHunter } from "./channels/gem-hunter-api.js";
import { telegram, startTelegramPolling } from "./channels/telegram.js";
import { guardBrasil } from "./channels/guard-brasil.js";
import { lgpd } from "./channels/lgpd.js";
import { chat } from "./channels/chat.js";
import { discover } from "./channels/discover.js";
import { startHealthMonitor, startBudgetMonitor } from "./health-monitor.js";
import { v1 } from "./channels/v1.js";

const app = new Hono();
const PORT = Number(process.env.GATEWAY_PORT ?? 3000);

// ─── Middleware ────────────────────────────────────────────────────────────────

app.use("*", logger());

// ─── Routes ───────────────────────────────────────────────────────────────────

app.get("/health", (c) => {
  return c.json({
    service: "egos-gateway",
    version: "0.4.0",
    uptime: process.uptime(),
    channels: ["whatsapp", "telegram", "knowledge", "gem-hunter", "guard-brasil-x402", "api-mestra-v1"],
    ui: "/ui",
    openapi: "/openapi.yaml",
    docs: {
      whatsapp: "/channels/whatsapp/health",
      telegram: "/telegram/health",
      knowledge: "/knowledge/stats",
      "gem-hunter": "/gem-hunter/product",
      "guard-brasil": "/guard-brasil/health",
      "api-mestra": "/v1/",
    },
  });
});

app.route("/ui", ui);
app.route("/channels/whatsapp", whatsapp);
app.route("/telegram", telegram);
app.route("/knowledge", knowledge);
app.route("/gem-hunter", gemHunter);
app.route("/guard-brasil", guardBrasil);
app.route("/api/lgpd", lgpd);
app.route("/api/chat", chat);
app.route("/api/chatbots", discover);
app.route("/v1", v1);

// Serve OpenAPI spec (API-009)
app.get("/openapi.yaml", async (c) => {
  const { readFileSync } = await import("fs");
  const { join, dirname } = await import("path");
  const { fileURLToPath } = await import("url");
  const dir = dirname(fileURLToPath(import.meta.url));
  const spec = readFileSync(join(dir, "../../openapi.yaml"), "utf-8");
  return c.text(spec, 200, { "Content-Type": "application/yaml" });
});

app.get("/openapi.json", async (c) => {
  const { readFileSync } = await import("fs");
  const { join, dirname } = await import("path");
  const { fileURLToPath } = await import("url");
  const dir = dirname(fileURLToPath(import.meta.url));
  const spec = readFileSync(join(dir, "../../openapi.yaml"), "utf-8");
  // Return YAML as-is with correct content type for tools that prefer JSON
  return c.text(spec, 200, { "Content-Type": "application/yaml", "X-Format": "yaml" });
});

// ─── Start ────────────────────────────────────────────────────────────────────

console.log(`[egos-gateway] v0.4.0 — starting on port ${PORT}`);
console.log(`[egos-gateway] UI:          http://localhost:${PORT}/ui`);
console.log(`[egos-gateway] WhatsApp:    http://localhost:${PORT}/channels/whatsapp/health`);
console.log(`[egos-gateway] Telegram:    http://localhost:${PORT}/telegram/health`);
console.log(`[egos-gateway] Gem Hunter:  http://localhost:${PORT}/gem-hunter/health`);

// Start Telegram long-polling (runs in background)
// Switch to webhook when gateway is deployed to VPS:
//   curl -X POST http://localhost:3000/telegram/setup-webhook -d '{"webhookUrl":"https://gateway.egos.ia.br"}'
startTelegramPolling().catch(console.error);

// Start health monitor — alerts via Telegram when system health < 40% (START-009)
startHealthMonitor();

// Start budget monitor — alerts via WhatsApp when client API spend > 80% (ROUTER-003)
startBudgetMonitor();

export default {
  port: PORT,
  fetch: app.fetch,
};
{
  "name": "@egosbr/guard-brasil",
  "version": "0.2.3",
  "description": "Brazilian AI safety layer — LGPD-compliant PII masking, ATRiAN ethical validation, and traceable evidence discipline for AI assistants",
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  },
  "files": [
    "dist",
    "README.md",
    "LICENSE"
  ],
  "keywords": [
    "lgpd",
    "pii",
    "brazil",
    "ai-safety",
    "guardrails",
    "compliance",
    "evidence-chain",
    "atrian",
    "brazilian",
    "cpf",
    "privacy",
    "masking"
  ],
  "author": "Enio Rocha <enio@egos.ia.br>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git",
    "directory": "packages/guard-brasil"
  },
  "homepage": "https://github.com/enioxt/egos/tree/main/packages/guard-brasil#readme",
  "scripts": {
    "build": "tsc -p tsconfig.build.json",
    "typecheck": "tsc --noEmit -p tsconfig.json",
    "test": "bun test src/guard.test.ts",
    "demo": "bun run src/demo.ts",
    "prepublishOnly": "npm run build"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.101.1"
  }
}
packages/guard-brasil/.git/AUTO_MERGE
packages/guard-brasil/.git/COMMIT_EDITMSG
packages/guard-brasil/.git/FETCH_HEAD
packages/guard-brasil/.git/HEAD
packages/guard-brasil/.git/ORIG_HEAD
packages/guard-brasil/.git/config
packages/guard-brasil/.git/description
packages/guard-brasil/.git/index
packages/guard-brasil/README.md
packages/guard-brasil/check.ts
packages/guard-brasil/dist/benchmark.d.ts
packages/guard-brasil/dist/benchmark.d.ts.map
packages/guard-brasil/dist/benchmark.js
packages/guard-brasil/dist/benchmark.js.map
packages/guard-brasil/dist/guard.d.ts
packages/guard-brasil/dist/guard.d.ts.map
packages/guard-brasil/dist/guard.js
packages/guard-brasil/dist/guard.js.map
packages/guard-brasil/dist/index.d.ts
packages/guard-brasil/dist/index.d.ts.map
packages/guard-brasil/dist/index.js
packages/guard-brasil/dist/index.js.map
packages/guard-brasil/dist/keys.d.ts
packages/guard-brasil/dist/keys.d.ts.map
packages/guard-brasil/dist/keys.js
packages/guard-brasil/dist/keys.js.map
packages/guard-brasil/dist/pii-patterns.d.ts
packages/guard-brasil/dist/pii-patterns.d.ts.map
packages/guard-brasil/dist/pii-patterns.js
packages/guard-brasil/dist/pii-patterns.js.map
packages/guard-brasil/dist/telemetry.d.ts
packages/guard-brasil/dist/telemetry.d.ts.map
packages/guard-brasil/dist/telemetry.js
packages/guard-brasil/dist/telemetry.js.map
packages/guard-brasil/package.json
packages/guard-brasil/src/benchmark.ts
packages/guard-brasil/src/demo.ts
packages/guard-brasil/src/guard.test.ts
packages/guard-brasil/src/guard.ts
packages/guard-brasil/src/index.ts
packages/guard-brasil/src/keys.ts
packages/guard-brasil/src/pii-patterns.ts
packages/guard-brasil/src/telemetry.ts
packages/guard-brasil/test_db.ts
packages/guard-brasil/tsconfig.build.json
packages/guard-brasil/tsconfig.json
packages/guard-brasil/tsconfig.tsbuildinfo

exec
/bin/bash -lc "find apps/egos-gateway -maxdepth 2 -type f -name 'docker-compose*' -o -name 'compose*.yml' -o -name '.dockerignore' -print && find apps/egos-gateway -maxdepth 2 -type f | sort | sed -n '1,120p' && git diff 4945ff2891fedfced7154e33d84b4096bbc48993 -- apps/egos-landing/src/App.tsx" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/.dockerignore
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

exec
/bin/bash -lc "cat apps/egos-gateway/.dockerignore; echo '--- compose'; cat apps/egos-gateway/docker-compose.yml; echo '--- root package'; cat package.json | sed -n '1,120p'; echo '--- landing generated file'; cat apps/egos-landing/src/data/metaprompt-source.ts | sed -n '1,40p'; echo '--- canonical first lines'; sed -n '1,80p' docs/drafts/free-artifact-egos-v0.md" in /home/enio/egos
 succeeded in 0ms:
node_modules
.env
.env.local
*.log
.git
--- compose
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
--- root package
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
    "test": "bun test packages/shared/src/__tests__/",
    "test:hooks": "bun test tests/hooks/",
    "test:watch": "bun test --watch",
    "test:governance": "bun scripts/test-governance.ts",
    "capability:scan": "bun scripts/update-capability-registry.ts",
    "capability:scan:repo": "bun scripts/update-capability-registry.ts --repo",
    "duplication:scan": "bun scripts/governance/duplication-scanner.ts",
    "duplication:scan:json": "bun scripts/governance/duplication-scanner.ts --json",
    "ssot:crosslink": "bun scripts/governance/ssot-crosslink-validator.ts",
    "ssot:crosslink:staged": "bun scripts/governance/ssot-crosslink-validator.ts --staged",
    "activation:check": "bun scripts/activation-check.ts",
    "start": "bun scripts/start-v6.ts",
    "start:full": "bun scripts/start-v6.ts --full",
    "start:json": "bun scripts/start-v6.ts --json",
    "doctor": "bun scripts/doctor.ts",
    "doctor:codex": "sh scripts/codex-doctor.sh",
    "doctor:fix": "bun scripts/doctor.ts --fix",
    "personal:sync:status": "bun scripts/personal-sync-status.ts",
    "personal:sync:status:json": "bun scripts/personal-sync-status.ts --json",
    "phantom:tables:audit": "bun scripts/phantom-table-audit.ts",
    "phantom:tables:audit:json": "bun scripts/phantom-table-audit.ts --json",
    "chatgpt:ingest": "bun scripts/chatgpt-export-sync.ts --dry",
    "chatgpt:ingest:exec": "bun scripts/chatgpt-export-sync.ts --exec",
    "chatgpt:watch": "bun scripts/chatgpt-export-watch.ts --dry",
    "chatgpt:watch:exec": "bun scripts/chatgpt-export-watch.ts --exec",
    "wiki:repos-sync": "bun scripts/wiki-repos-sync.ts",
    "wiki:repos-sync:check": "bun scripts/wiki-repos-sync.ts --check",
    "wiki:compile": "bun agents/agents/wiki-compiler.ts --compile",
    "wiki:compile:dry": "bun agents/agents/wiki-compiler.ts --compile --dry",
    "wiki:heal": "bun agents/agents/wiki-compiler.ts --heal",
    "wiki:heal:dry": "bun agents/agents/wiki-compiler.ts --heal --dry",
    "wiki:lint": "bun agents/agents/wiki-compiler.ts --lint",
    "wiki:index": "bun agents/agents/wiki-compiler.ts --index",
    "wiki:dedup": "bun agents/agents/wiki-compiler.ts --dedup",
    "wiki:dedup:dry": "bun agents/agents/wiki-compiler.ts --dedup --dry",
    "wiki:enrich": "bun agents/agents/wiki-compiler.ts --enrich",
    "wiki:enrich:dry": "bun agents/agents/wiki-compiler.ts --enrich --dry",
    "deadcode": "knip",
    "deadcode:fix": "knip --fix",
    "skill:usage": "bun scripts/skill-usage-tracker.ts",
--- landing generated file
// AUTO-GENERATED — não edite manualmente.
// Fonte canônica: docs/drafts/free-artifact-egos-v0.md
// Regere com: bun scripts/generate-metaprompt.ts
// SSOT: GUARANI-SSOT-METAPROMPT-001

export const METAPROMPT_V3 = "Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].\nSeu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.\n\nAtua exclusivamente em:\n- [Área 1]  - [Área 2]  - [Área 3]\nFora do escopo, responda: \"Isso está fora do meu escopo atual. Posso ajudar com [alternativas].\"\n\n── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──\nSe este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:\nRegra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.\nNeste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.\nFluxo obrigatório:\n1. Pergunta única de abertura: \"Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?\"\n2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.\n3. Apresente o pacote completo: \"Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?\"\n4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.\nNÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.\n\n── CLASSIFICAÇÃO OBRIGATÓRIA ──\nClassifique afirmações relevantes como:\n- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado\n- NÃO SEI: base insuficiente  - AÇÃO: passo a executar\n\n── ANTI-ALUCINAÇÃO ──\nNunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.\nSem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga \"não sei\" e qual informação falta.\nProibido: \"100%\", \"garantido\", \"infalível\", \"único\", \"sem risco\". Prefira: \"alta confiança baseada em evidências\".\n\n── PROTEÇÃO DE DADOS ──\nSensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.\nAo receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.\n\n── ZONA VERMELHA (pause antes) ──\nAção de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.\nProtocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.\n\n── LIMITAÇÕES ──\nNão substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → \"Esta análise é auxiliar. Consulte um profissional habilitado.\"\n\n── CRITÉRIO DE EVIDÊNCIA ──\nAntes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.\n\n── MODO DE RESPOSTA ──\nDireto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.\n\n── FORMATO DE SAÍDA ──\nClassificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]\nSíntese: [resposta direta]\nEvidências: [fontes/dados/base lógica]\nRiscos: [se houver]\nPróxima ação: [recomendação objetiva]\n\n── REGRA FINAL ──\nEm dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente."
--- canonical first lines
# EGOS — Artefato Gratuito v2 (iterado pelo aparato — aguarda Guarani + glance Enio)

> **Status:** v3 · **Criado:** 2026-06-05 · **Autor:** EGOS
> **R-PUB-001 (Flagship Public Artifact Gate):** Banda ✓ · Codex gpt-5.5 ✓ · Guarani/Gemini ✓ (df318d68) · Glance Enio ✓
> **PRONTO PARA PUBLICAR.** Destino: README egos-governance + egos.ia.br (os dois).
> **Histórico:** v1 quase publicado sem iteração → ChatGPT achou melhorias → R-PUB-001 criada. v2 = merge v1+ChatGPT (via Codex gpt-5.5) + camada de identidade. v3 = modo tutor separado do operacional + descoberta progressiva embutida (teste real ChatGPT+Gemini 2026-06-05).

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
Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
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

exec
/bin/bash -lc 'cd apps/egos-gateway && bun run build && ls -lh dist/server.js && grep -c REMOVIDO dist/server.js && bun test src/pii-gate.test.ts' in /home/enio/egos
 succeeded in 0ms:
$ bun build src/server.ts --target bun --outfile dist/server.js
Bundled 93 modules in 21ms

  server.js  0.67 MB  (entry point)

-rw-r--r-- 1 enio enio 656K Jun  9 15:32 dist/server.js
18
bun test v1.3.9 (cf6cdbbb)

 7 pass
 0 fail
 15 expect() calls
Ran 7 tests across 1 file. [24.00ms]

exec
/bin/bash -lc "nl -ba apps/egos-gateway/src/orchestrator.ts | sed -n '1588,1612p'; nl -ba scripts/hermes-trigger.sh | sed -n '58,92p'; nl -ba apps/egos-gateway/Dockerfile | sed -n '1,20p'; nl -ba apps/egos-gateway/src/orchestrator.ts | sed -n '1570,1596p'" in /home/enio/egos
 succeeded in 0ms:
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
    58	RUN_ID="${NOW}-$$"
    59	log "starting run_id=$RUN_ID head=$HEAD_SHA delta=${DELTA}s since=${SINCE}"
    60	
    61	PREV_SHA=$(cat "$STATE_DIR/last_gw_sha" 2>/dev/null || echo "")
    62	git pull --ff-only -q 2>/dev/null || log "WARN: git pull --ff-only failed (run_id=$RUN_ID)"
    63	NEW_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
    64	
    65	# VPS-GATEWAY-AUTOSYNC-001: sync /opt/egos-gateway when apps/egos-gateway/ changed
    66	GW_DIR="/opt/egos-gateway"
    67	if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
    68	  GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
    69	  if [ -n "$GW_CHANGED" ]; then
    70	    log "gateway changed ($PREV_SHA -> $NEW_SHA) — building bundle + syncing $GW_DIR"
    71	    # 1. build guard-brasil dist (tsc emite mesmo com type-errors pré-existentes)
    72	    ( cd "$REPO/packages/guard-brasil" && bun run build >/dev/null 2>&1 ) || log "WARN: guard-brasil build non-zero (dist provavelmente emitido)"
    73	    # 2. garante symlink workspace p/ o bundler resolver @egosbr/guard-brasil
    74	    mkdir -p "$REPO/node_modules/@egosbr" && ln -sfn ../../packages/guard-brasil "$REPO/node_modules/@egosbr/guard-brasil"
    75	    # 3. rsync fonte (exclui dist — será buildado direto no destino)
    76	    rsync -a --exclude=node_modules --exclude=.env --exclude=dist "$REPO/apps/egos-gateway/" "$GW_DIR/" \
    77	      && log "rsync OK" || log "WARN: rsync failed"
    78	    # 4. bundle self-contained (maskPII inlined) direto no destino
    79	    mkdir -p "$GW_DIR/dist"
    80	    ( cd "$REPO" && bun build apps/egos-gateway/src/server.ts --target bun --outfile "$GW_DIR/dist/server.js" ) \
    81	      && log "bundle built ($(grep -c REMOVIDO "$GW_DIR/dist/server.js" 2>/dev/null) PII refs)" \
    82	      || { log "ERROR: bundle build failed — abortando deploy (gateway atual preservado)"; cd "$REPO"; echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"; }
    83	    # 5. rebuild container só roda o bundle (Dockerfile sem install)
    84	    if [ -f "$GW_DIR/dist/server.js" ]; then
    85	      cd "$GW_DIR" && docker compose build --no-cache -q && docker compose up -d \
    86	        && log "gateway rebuilt and restarted" || log "WARN: docker rebuild failed"
    87	    fi
    88	    cd "$REPO"
    89	  fi
    90	fi
    91	echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"
    92	
     1	# EGOS Gateway — bundle-runtime (VPS-GATEWAY-AUTOSYNC-001, 2026-06-09)
     2	# O gateway é deployado como cópia standalone em /opt/egos-gateway, onde
     3	# `workspace:*` deps (@egosbr/guard-brasil) NÃO resolvem via bun install.
     4	# Solução: o deploy bundla src/server.ts → dist/server.js (maskPII inlined,
     5	# self-contained) NO MONOREPO, e o container só RODA o bundle — sem install.
     6	# Dev local roda via `bun run src/server.ts` (não usa este Dockerfile).
     7	FROM oven/bun:1.3
     8	WORKDIR /app
     9	COPY . .
    10	ENV GATEWAY_PORT=3050
    11	EXPOSE 3050
    12	# dist/server.js é buildado pelo deploy (scripts/hermes-trigger.sh autosync ou
    13	# `bun run build`) ANTES do docker build. Sem bun install: bundle é autossuficiente.
    14	CMD ["bun", "dist/server.js"]
  1570	export async function orchestrate(msg: IncomingMessage, client?: ClientContext): Promise<OrchestratorResponse> {
  1571	  if (!OPENROUTER_KEY) {
  1572	    return { text: "❌ OPENROUTER_API_KEY não configurado." };
  1573	  }
  1574	
  1575	  const toolsUsed: string[] = [];
  1576	  let userText = msg.text ?? "";
  1577	
  1578	  // Phase 1: Process media → text
  1579	  if (msg.mediaType === "audio" && msg.mediaBase64 && msg.mediaMime) {
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

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
mcp: codebase-memory-mcp/get_code_snippet started
mcp: codebase-memory-mcp/get_code_snippet (completed)
codex
The PII gate does not cover media paths before external providers receive raw content, and the gateway autosync can falsely record a failed bundle build as deployed. These are actionable correctness/security issues in the new changes.

Full review comments:

- [P1] Mask media PII before external transcription/vision calls — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1599-1604
  For audio or image messages, this new PII gate runs only after `transcribeAudio` or `describeImage` has already sent the raw media/caption to Groq/Gemini, so a spoken CPF or a document photo with PII still leaves the machine before masking. If the guarantee is “before any external LLM” and “regardless of media origin,” the gate needs to happen before those external media-processing calls, or those paths need to be blocked/routed through a local sanitizer.

- [P2] Do not mark failed gateway deploys as synced — /home/enio/egos/scripts/hermes-trigger.sh:80-84
  When `bun build` fails, this handler still writes `last_gw_sha` and then can continue into the Docker rebuild if an older `$GW_DIR/dist/server.js` exists, which means the new gateway revision is recorded as deployed while the container may restart with a stale bundle. In the build-failure scenario, exit/skip the Docker step and leave `last_gw_sha` unchanged so the next trigger retries the same revision.
The PII gate does not cover media paths before external providers receive raw content, and the gateway autosync can falsely record a failed bundle build as deployed. These are actionable correctness/security issues in the new changes.

Full review comments:

- [P1] Mask media PII before external transcription/vision calls — /home/enio/egos/apps/egos-gateway/src/orchestrator.ts:1599-1604
  For audio or image messages, this new PII gate runs only after `transcribeAudio` or `describeImage` has already sent the raw media/caption to Groq/Gemini, so a spoken CPF or a document photo with PII still leaves the machine before masking. If the guarantee is “before any external LLM” and “regardless of media origin,” the gate needs to happen before those external media-processing calls, or those paths need to be blocked/routed through a local sanitizer.

- [P2] Do not mark failed gateway deploys as synced — /home/enio/egos/scripts/hermes-trigger.sh:80-84
  When `bun build` fails, this handler still writes `last_gw_sha` and then can continue into the Docker rebuild if an older `$GW_DIR/dist/server.js` exists, which means the new gateway revision is recorded as deployed while the container may restart with a stale bundle. In the build-failure scenario, exit/skip the Docker step and leave `last_gw_sha` unchanged so the next trigger retries the same revision.
```
