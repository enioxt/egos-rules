# Codex Local Review — 2026-06-01T13:50:20Z

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
session id: 019e8373-2022-72f0-8ce7-eedd2ceab8af
--------
user
changes against 'HEAD~3'
2026-06-01T13:50:21.627142Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:50:21.627816Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:50:26.168939Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:50:26.538800Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:50:26.753053Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:50:26.900595Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:50:27.439234Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:50:28.431616Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:50:30.259838Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:50:33.561574Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 9b7dc0c9f59172e656e52ce5170f94d16de4f99c' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index e4ff239c..109d9bc2 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -86,7 +86,6 @@
 
 ## 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
 > **Causa-raiz:** status duplicado em ≥2 lugares (TASKS.md + audit backlog) com IDs inconsistentes → `task-reconciliation.ts` (só TASKS.md, match `[A-Z]+-\d+`) não pega. C2-C4 e ORG-WAVE-* ficaram phantom-pending.
-- [ ] **DRIFT-PREVENT-002** [P2] `3h` — Completar Doc-Drift Shield Phase 1 (rollout incompleto desde 2026-04-07): `.egos-manifest.yaml` nos 3 pilots + wirar `run-doc-drift-sentinel.sh` (existe, não agendado).
 - [ ] **EGOS-DEV-AGENT-001** [P2] `proposta` — Desenhar template "agente EGOS Developer" reusando skill-discovery + eval-runner + mcp-governance. Escopar antes de construir (anti-overproduction).
 
 ### 🏛️ MULTI-AGENT GOVERNANCE (papéis LLM nomeados + Council/HITL) — 2026-05-30 (Antigravity propôs, Prime corrigiu phantoms)
@@ -528,7 +527,6 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 > **✅ VALIDADO 2026-06-01:** `eval-runner` conectou no ChatGPT (URL `https://mcp.egos.ia.br/eval-runner/mcp`, sem-auth, Developer Mode). 6 tools carregadas. Dois bugs achados+consertados: (1) bridge stdio sem `\n` → travava (SHA `ae4da0c0`); (2) eval-runner via 0 CBCs no VPS — REPO_ROOT resolvia `/opt/` em vez do repo → adicionado `EGOS_REPO_ROOT` env + dados framework sincronizados p/ `/opt/egos-data` + fix do falso `migration_pct:100%`. Agora vê 79 CBCs reais (`migration_pct:91.9%`). ChatGPT é stateless (re-inicializa cada call) + não tem campo Bearer (só OAuth/sem-auth/mista) — por isso g-pecas falhou no print do Enio.
 - [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
 - [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
-- [ ] **MCP-SEC-001** [P1] `prime` — **REFRAME transparência radical (Enio 2026-06-01, `feedback_radical_transparency`):** conteúdo do framework é LIVRE → expor sem auth é OK. O gate NÃO é "é do kernel?", é "ajuda a atacar a máquina OU é dado restrito por natureza?". Classificação correta (bridges `mcp.egos.ia.br/*`, hoje auth-disabled):
   - ✅ **Livres (pode no ChatGPT):** `eval-runner`, `skills-registry`, `governance` (TASKS/registry/SSOT = framework aberto).
   - 🟡 **Escopar:** `knowledge` — docs do framework livres, MAS bloquear dados intelink/cliente/PII (filtro tenant/namespace).
   - 🔴 **Proteger (auth/de-route):** `ops`, `observability`, `browser-automation` (atacam a MÁQUINA), `memory` (pessoal/PCMG), `security` (resultados PII).
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index ba57534d..476eaf2c 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3288,3 +3288,12 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
 - [x] **DRIFT-PREVENT-001** [P1] `2h` — Regra "status SSOT único": audit/checklist docs NÃO carregam `[x]/[ ]` independente — referenciam ID de TASKS.md OU são snapshot arquivado ao fim da sessão. Documentar em `DOC_DRIFT_SHIELD.md` (nova §Status-Drift) + wirar staleness-check de `docs/audits/*BACKLOG*.md` no cron 24/7 `governance-drift.yml` (já existe, não roda reconciliação hoje). Validar + disseminar.
 
+
+## Archived 2026-06-01
+
+### 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
+- [x] **DRIFT-PREVENT-002** [P2] `3h` — Completar Doc-Drift Shield Phase 1 (rollout incompleto desde 2026-04-07): `.egos-manifest.yaml` nos 3 pilots + wirar `run-doc-drift-sentinel.sh` (existe, não agendado).
+
+### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
+- [x] **MCP-SEC-001** [P1] `prime` — **REFRAME transparência radical (Enio 2026-06-01, `feedback_radical_transparency`):** conteúdo do framework é LIVRE → expor sem auth é OK. O gate NÃO é "é do kernel?", é "ajuda a atacar a máquina OU é dado restrito por natureza?". Classificação correta (bridges `mcp.egos.ia.br/*`, hoje auth-disabled): ✅ 2026-06-01
+
diff --git a/apps/egos-site/src/server.ts b/apps/egos-site/src/server.ts
index 720f6680..daf0b1a3 100644
--- a/apps/egos-site/src/server.ts
+++ b/apps/egos-site/src/server.ts
@@ -2036,6 +2036,21 @@ app.get('/status', (c) => {
     </div>
   `).join('\n')
 
+  const fw = (snap.framework as { capabilities?: number; agentsTotal?: number; agentsActive?: number; mcpsLive?: string[] }) ?? null
+  const metric = (n: string | number, label: string) => `
+    <div class="border border-slate-800 rounded-xl p-5 text-center">
+      <div class="text-3xl font-bold text-sky-400">${n}</div>
+      <div class="text-xs text-slate-500 mt-1">${label}</div>
+    </div>`
+  const frameworkBlock = fw ? `
+    <h2 class="text-xl font-semibold text-slate-100 mt-12 mb-4">Framework</h2>
+    <div class="grid gap-3 grid-cols-2 sm:grid-cols-4">
+      ${metric(fw.capabilities ?? 0, 'capabilities')}
+      ${metric(fw.agentsTotal ?? 0, `agents (${fw.agentsActive ?? 0} ativos)`)}
+      ${metric((fw.mcpsLive ?? []).length, 'MCPs livres no ar')}
+      ${metric((fw.mcpsLive ?? []).join(', ') || '—', 'endpoints')}
+    </div>` : ''
+
   const body = `
     <header class="mb-10">
       <div class="flex items-center gap-3 mb-2">
@@ -2045,6 +2060,7 @@ app.get('/status', (c) => {
       <p class="text-slate-400">${allOk ? `Todos os ${services.length}` : `${healthy}/${services.length}`} serviços operacionais · Atualizado: ${new Date(ts).toLocaleString('pt-BR')}</p>
     </header>
     <div class="grid gap-3 sm:grid-cols-2">${cards}</div>
+    ${frameworkBlock}
     <div class="mt-8 pt-6 border-t border-slate-800 flex justify-between text-xs text-slate-600">
       <span>SHA-256: <code>${sha}…</code></span>
       <a href="/status.json" class="text-sky-800 hover:text-sky-600 font-mono">status.json →</a>
diff --git a/scripts/mcp-ecosystem.config.js b/scripts/mcp-ecosystem.config.js
index c1e3a495..9d965e33 100644
--- a/scripts/mcp-ecosystem.config.js
+++ b/scripts/mcp-ecosystem.config.js
@@ -10,9 +10,21 @@
  */
 
 const MCP_DIR = "/opt/egos-mcp";
-const BUN_BIN = "/root/.bun/bin/bun";
+const BUN_BIN = "/usr/bin/bun";
 const ENV_FILE = `${MCP_DIR}/.env`;
 
+// Read the bearer token from .env at config-eval time — pm2 env_file was NOT
+// reliably injecting it (RED bridges stayed no-auth). Inject explicitly instead.
+let MCP_TOKEN = "";
+try {
+  const m = require("fs").readFileSync(ENV_FILE, "utf8").match(/^EGOS_MCP_TOKEN=(.+)$/m);
+  if (m) MCP_TOKEN = m[1].trim();
+} catch (_) { /* no .env → bridges stay open (dev) */ }
+// Bridges that expose the MACHINE/infra or data-restricted-by-nature → require token.
+// (Framework content stays free: eval-runner, skills-registry, governance.)
+const PROTECT = { EGOS_MCP_TOKEN: MCP_TOKEN };
+const FREE = { EGOS_MCP_TOKEN: "" };
+
 // Configuração base de cada MCP
 const mcpBase = (name, port, cmd) => ({
   name: `egos-mcp-${name}`,
@@ -23,7 +35,7 @@ const mcpBase = (name, port, cmd) => ({
   env: {
     MCP_NAME: name,
     MCP_PORT: String(port),
-    MCP_HOST: process.env.MCP_HOST ?? "0.0.0.0",
+    MCP_HOST: "0.0.0.0",
     NODE_ENV: "production",
   },
   // Restart policy
@@ -43,7 +55,7 @@ const mcpBase = (name, port, cmd) => ({
 });
 
 // Bridge mode — cada MCP exposto via mcp-bridge
-const bridgeBase = (name, port, mcpCmd) => ({
+const bridgeBase = (name, port, mcpCmd, extraEnv = {}) => ({
   ...mcpBase(`bridge-${name}`, port, null),
   name: `egos-mcp-${name}`,
   script: `${BUN_BIN}`,
@@ -52,10 +64,11 @@ const bridgeBase = (name, port, mcpCmd) => ({
   env: {
     MCP_NAME: name,
     MCP_PORT: String(port),
-    MCP_HOST: process.env.MCP_HOST ?? "0.0.0.0",
+    MCP_HOST: "0.0.0.0",
     MCP_CMD: mcpCmd,
     NODE_ENV: "production",
     EGOS_TENANT_ID: "kernel",
+    ...extraEnv,
   },
 });
 
@@ -65,47 +78,56 @@ module.exports = {
     bridgeBase(
       "governance",
       7001,
-      `${BUN_BIN} run ${MCP_DIR}/governance/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/governance/src/index.ts`,
+      FREE // framework content (radical transparency)
     ),
     bridgeBase(
       "memory",
       7002,
-      `${BUN_BIN} run ${MCP_DIR}/memory/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/memory/src/index.ts`,
+      PROTECT // personal/PCMG — data restricted by nature
     ),
     bridgeBase(
       "knowledge",
       7003,
-      `${BUN_BIN} run ${MCP_DIR}/knowledge/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/knowledge/src/index.ts`,
+      PROTECT // intelink/client/PII — scope later, protect now
     ),
     bridgeBase(
       "security",
       7004,
-      `${BUN_BIN} run ${MCP_DIR}/security/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/security/src/index.ts`,
+      PROTECT // PII scan results
     ),
     bridgeBase(
       "eval-runner",
       7005,
-      `${BUN_BIN} run ${MCP_DIR}/eval-runner/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/eval-runner/src/index.ts`,
+      { ...FREE, EGOS_REPO_ROOT: "/opt/egos-data" } // FREE + data path (persist fix)
     ),
     bridgeBase(
       "ops",
       7006,
-      `${BUN_BIN} run ${MCP_DIR}/ops/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/ops/src/index.ts`,
+      PROTECT // machine/infra: LLM routing, quota
     ),
     bridgeBase(
       "skills-registry",
       7007,
-      `${BUN_BIN} run ${MCP_DIR}/skills-registry/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/skills-registry/src/index.ts`,
+      FREE // framework content
     ),
     bridgeBase(
       "browser-automation",
       7008,
-      `${BUN_BIN} run ${MCP_DIR}/browser-automation/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/browser-automation/src/index.ts`,
+      PROTECT // machine: headless browser, SSRF vector
     ),
     bridgeBase(
       "observability",
       7009,
-      `${BUN_BIN} run ${MCP_DIR}/observability/src/index.ts`
+      `${BUN_BIN} run ${MCP_DIR}/observability/src/index.ts`,
+      PROTECT // machine/infra: SSH, PM2, topology
     ),
   ],
 };
diff --git a/scripts/run-doc-drift-sentinel.sh b/scripts/run-doc-drift-sentinel.sh
index 2fc2e06e..176b4fd6 100755
--- a/scripts/run-doc-drift-sentinel.sh
+++ b/scripts/run-doc-drift-sentinel.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 # EGOS Doc-Drift Sentinel — cron wrapper
 set -e
-cd /home/enio/egos
+SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
+cd "$SCRIPT_DIR/.."
 exec /usr/bin/bun agents/agents/doc-drift-sentinel.ts "$@"

exec
/bin/bash -lc "grep -R \"\\.bun/bin/bun\\|/usr/bin/bun\" -n scripts | head -n 50" in /home/enio/egos
 succeeded in 4612ms:
scripts/mcp-ecosystem.config.js:13:const BUN_BIN = "/usr/bin/bun";
scripts/run-doc-drift-sentinel.sh:6:exec /usr/bin/bun agents/agents/doc-drift-sentinel.ts "$@"
scripts/deploy-rls-auditor.sh:69:CRON_ENTRY="$VPS_CRON_MIN $VPS_CRON_HOUR * * * cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --alert >> $LOG_FILE 2>&1"
scripts/deploy-rls-auditor.sh:119:ssh "$VPS_USER@$VPS_HOST" "cd $VPS_EGOS_DIR && /usr/bin/bun $SCRIPT_TARGET --check 2>&1 | tail -5"

exec
/bin/bash -lc "nl -ba scripts/mcp-ecosystem.config.js | sed -n '1,70p'" in /home/enio/egos
 succeeded in 0ms:
     1	/**
     2	 * PM2 Ecosystem — EGOS MCP Servers (MCP-F3-003)
     3	 *
     4	 * Deploy: pm2 start scripts/mcp-ecosystem.config.js
     5	 * Requires: MCP_CMD per app + EGOS_MCP_TOKEN em /opt/egos-mcp/.env
     6	 *
     7	 * Portas: 7001-7009 (governance → observability)
     8	 * Caddy: reverse proxy em mcp.egos.ia.br/{name}
     9	 * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md §7 (Streamable HTTP)
    10	 */
    11	
    12	const MCP_DIR = "/opt/egos-mcp";
    13	const BUN_BIN = "/usr/bin/bun";
    14	const ENV_FILE = `${MCP_DIR}/.env`;
    15	
    16	// Read the bearer token from .env at config-eval time — pm2 env_file was NOT
    17	// reliably injecting it (RED bridges stayed no-auth). Inject explicitly instead.
    18	let MCP_TOKEN = "";
    19	try {
    20	  const m = require("fs").readFileSync(ENV_FILE, "utf8").match(/^EGOS_MCP_TOKEN=(.+)$/m);
    21	  if (m) MCP_TOKEN = m[1].trim();
    22	} catch (_) { /* no .env → bridges stay open (dev) */ }
    23	// Bridges that expose the MACHINE/infra or data-restricted-by-nature → require token.
    24	// (Framework content stays free: eval-runner, skills-registry, governance.)
    25	const PROTECT = { EGOS_MCP_TOKEN: MCP_TOKEN };
    26	const FREE = { EGOS_MCP_TOKEN: "" };
    27	
    28	// Configuração base de cada MCP
    29	const mcpBase = (name, port, cmd) => ({
    30	  name: `egos-mcp-${name}`,
    31	  script: `${BUN_BIN}`,
    32	  args: ["run", "src/index.ts"],
    33	  cwd: `${MCP_DIR}/${name}`,
    34	  env_file: ENV_FILE,
    35	  env: {
    36	    MCP_NAME: name,
    37	    MCP_PORT: String(port),
    38	    MCP_HOST: "0.0.0.0",
    39	    NODE_ENV: "production",
    40	  },
    41	  // Restart policy
    42	  restart_delay: 2000,
    43	  max_restarts: 10,
    44	  min_uptime: "5s",
    45	  // Memory limit
    46	  max_memory_restart: "256M",
    47	  // Logging
    48	  out_file: `/var/log/egos-mcp-${name}.log`,
    49	  error_file: `/var/log/egos-mcp-${name}.error.log`,
    50	  log_date_format: "YYYY-MM-DD HH:mm:ss",
    51	  // Kill switch via env
    52	  kill_timeout: 3000,
    53	  // Watch mode OFF (use deploy-mcp.sh for updates)
    54	  watch: false,
    55	});
    56	
    57	// Bridge mode — cada MCP exposto via mcp-bridge
    58	const bridgeBase = (name, port, mcpCmd, extraEnv = {}) => ({
    59	  ...mcpBase(`bridge-${name}`, port, null),
    60	  name: `egos-mcp-${name}`,
    61	  script: `${BUN_BIN}`,
    62	  args: ["run", `${MCP_DIR}/bridge/src/index.ts`],
    63	  cwd: `${MCP_DIR}/bridge`,
    64	  env: {
    65	    MCP_NAME: name,
    66	    MCP_PORT: String(port),
    67	    MCP_HOST: "0.0.0.0",
    68	    MCP_CMD: mcpCmd,
    69	    NODE_ENV: "production",
    70	    EGOS_TENANT_ID: "kernel",

codex
The patch introduces a security-relevant regression path: protected MCP bridges can become unauthenticated if token parsing misses valid `.env` syntax. This should be fixed before considering the change correct.

Review comment:

- [P1] Parse EGOS_MCP_TOKEN with dotenv-safe logic — /home/enio/egos/scripts/mcp-ecosystem.config.js:20-22
  The token extraction uses a strict regex (`/^EGOS_MCP_TOKEN=(.+)$/m`) that fails for common `.env` formats like `export EGOS_MCP_TOKEN=...`, spaces around `=`, or other dotenv variations, and this failure is silently swallowed. In those cases `MCP_TOKEN` stays empty and every `PROTECT` bridge is effectively configured without a token gate, which undermines the new auth split for sensitive MCPs.
The patch introduces a security-relevant regression path: protected MCP bridges can become unauthenticated if token parsing misses valid `.env` syntax. This should be fixed before considering the change correct.

Review comment:

- [P1] Parse EGOS_MCP_TOKEN with dotenv-safe logic — /home/enio/egos/scripts/mcp-ecosystem.config.js:20-22
  The token extraction uses a strict regex (`/^EGOS_MCP_TOKEN=(.+)$/m`) that fails for common `.env` formats like `export EGOS_MCP_TOKEN=...`, spaces around `=`, or other dotenv variations, and this failure is silently swallowed. In those cases `MCP_TOKEN` stays empty and every `PROTECT` bridge is effectively configured without a token gate, which undermines the new auth split for sensitive MCPs.
```
