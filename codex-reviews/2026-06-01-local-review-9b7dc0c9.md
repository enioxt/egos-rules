# Codex Local Review — 2026-06-01T13:46:50Z

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
session id: 019e836f-eb45-7da2-b852-3327973ab908
--------
user
changes against 'HEAD~3'
2026-06-01T13:46:51.489087Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:46:51.494057Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:46:58.327447Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:46:58.746901Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:46:59.302404Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:46:59.625736Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:47:00.142557Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:47:01.136892Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:47:02.945498Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:47:06.081249Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 4b3de4b137ef5e614d58266cb0134b2d4a461485' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 6c2dd977..e4ff239c 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -24,7 +24,6 @@
 - [ ] **CAQ-MEASURE-001** [P0] — Medir uso real dos 2 storefronts: acessos, leads, mensagens, pedidos, produtos vistos, conversões, origem do tráfego. Sem métrica não há venda baseada em prova.
 - [ ] **CAQ-PROOF-001** [P0] — Criar prova comercial: 1 página com prints reais + números reais (do CAQ-MEASURE-001) + proposta (setup, mensalidade, prazo). _(Gemini sugere também: 40s de áudio/depoimento do dono como prova humana.)_
 - [ ] **CAQ-SALES-001** [P1] — Preparar os 3 vendedores externos: script WhatsApp, pitch 60s, demo guiada, objeções, comissão padronizada.
-- [ ] **CAQ-PORTABILITY-001** [P1] `[caminho C]` — Padronizar implantação de cliente novo em ≤1 dia: remover ~4 paths hardcoded `/home/enio` (`egos-repo-health.sh`, `install-context-persistence.sh`, `claude-code-init.sh`, `deploy-rls-auditor.sh`) + env template + seed/demo + bootstrap privado + checklist + doc mínima.
 - [ ] **CAQ-RESEARCHER-001** [P1] `nova-frente` — Estruturar proposta "pesquisador por resultado" p/ o contato: definir KPIs avaliáveis, período de avaliação, modelo de ganho por melhoria entregue, NDA. Coerente com troca-justa [[enio-fair-value-receive]]. Aguarda Enio nomear o contato/contexto.
 - [ ] **CAQ-WEEKLY-001** [P2] `ritmo` — Reunião semanal: revisar leads, objeções, fechamentos, uso e receita.
 
@@ -87,7 +86,6 @@
 
 ## 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
 > **Causa-raiz:** status duplicado em ≥2 lugares (TASKS.md + audit backlog) com IDs inconsistentes → `task-reconciliation.ts` (só TASKS.md, match `[A-Z]+-\d+`) não pega. C2-C4 e ORG-WAVE-* ficaram phantom-pending.
-- [ ] **DRIFT-PREVENT-001** [P1] `2h` — Regra "status SSOT único": audit/checklist docs NÃO carregam `[x]/[ ]` independente — referenciam ID de TASKS.md OU são snapshot arquivado ao fim da sessão. Documentar em `DOC_DRIFT_SHIELD.md` (nova §Status-Drift) + wirar staleness-check de `docs/audits/*BACKLOG*.md` no cron 24/7 `governance-drift.yml` (já existe, não roda reconciliação hoje). Validar + disseminar.
 - [ ] **DRIFT-PREVENT-002** [P2] `3h` — Completar Doc-Drift Shield Phase 1 (rollout incompleto desde 2026-04-07): `.egos-manifest.yaml` nos 3 pilots + wirar `run-doc-drift-sentinel.sh` (existe, não agendado).
 - [ ] **EGOS-DEV-AGENT-001** [P2] `proposta` — Desenhar template "agente EGOS Developer" reusando skill-discovery + eval-runner + mcp-governance. Escopar antes de construir (anti-overproduction).
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index f7d82a5e..ba57534d 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3276,3 +3276,15 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **MCP-CHATGPT-001** [P1] `prime` — Validar `mcp-eval-runner` (GREEN: read-only, sem segredo) no conector ChatGPT. **Receita validada (Sonnet 2026-06-01):** ChatGPT exige **Streamable HTTP** em endpoint `/mcp` (auth=Bearer estático basta; OAuth exige auth-server+`/.well-known`). `mcp-bridge` já faz tudo (CORS/Origin/bearer/sessão). Passos: (1) PM2 `MCP_NAME=eval-runner MCP_CMD="bun packages/mcp-eval-runner/src/index.ts" MCP_PORT=7005 bun packages/mcp-bridge/src/index.ts`; (2) Caddy `handle /eval-runner* { uri strip_prefix /eval-runner; reverse_proxy localhost:7005 }` no bloco `mcp.egos.ia.br`; (3) token em `/etc/egos/eval-runner.env`; (4) probe `curl POST https://mcp.egos.ia.br/eval-runner/mcp` initialize; (5) colar URL no diálogo do ChatGPT, auth=Bearer. ~1h. **Toca prod+Caddy → go do Enio + review Codex antes.** ✅ 2026-06-01
 - [x] **MCP-CHATGPT-FIX-001** — Bridge stdio framing bug consertado (newline stdin + line-buffer + notification 202). `eval-runner` validado ponta-a-ponta via Caddy. SHA `ae4da0c0`.
 
+
+## Archived 2026-06-01
+
+### 🎯 LOOP DE AQUISIÇÃO + ENTREGA #3-#7 — North Star (council 2026-05-30)
+- [x] **CAQ-PORTABILITY-001** [P1] `[caminho C]` — Padronizar implantação de cliente novo em ≤1 dia: remover ~4 paths hardcoded `/home/enio` (`egos-repo-health.sh`, `install-context-persistence.sh`, `claude-code-init.sh`, `deploy-rls-auditor.sh`) + env template + seed/demo + bootstrap privado + checklist + doc mínima.
+
+
+## Archived 2026-06-01
+
+### 🛡️ DRIFT PREVENTION + ERA AGENTIC — 2026-05-30 (Opus, pós-incidente C2-C4 phantom)
+- [x] **DRIFT-PREVENT-001** [P1] `2h` — Regra "status SSOT único": audit/checklist docs NÃO carregam `[x]/[ ]` independente — referenciam ID de TASKS.md OU são snapshot arquivado ao fim da sessão. Documentar em `DOC_DRIFT_SHIELD.md` (nova §Status-Drift) + wirar staleness-check de `docs/audits/*BACKLOG*.md` no cron 24/7 `governance-drift.yml` (já existe, não roda reconciliação hoje). Validar + disseminar.
+
diff --git a/scripts/llm-usage-notify.ts b/scripts/llm-usage-notify.ts
new file mode 100644
index 00000000..e66696a8
--- /dev/null
+++ b/scripts/llm-usage-notify.ts
@@ -0,0 +1,191 @@
+#!/usr/bin/env bun
+/**
+ * llm-usage-notify.ts — F1 of EGOS_TELEGRAM_AGENT_PLAN.md
+ *
+ * Pushes a daily LLM usage + provider-key-health report to Telegram.
+ * Closes the loop on the 2026-06-01 incident (a dead Alibaba key fell back
+ * to OpenRouter silently for an unknown period — nobody was alerted).
+ *
+ * Two signals, one message:
+ *   1. KEY HEALTH — runs `doctor.ts --json` (authenticated probe). A provider
+ *      whose key returns 401/403 = DEAD → loud 🔴 alert to rotate.
+ *   2. USAGE/COST — Supabase `api_usage` (model, tokens_in/out, cost_usd, date)
+ *      aggregated by provider for the window.
+ *
+ * Usage:
+ *   bun scripts/llm-usage-notify.ts            # today, send to Telegram
+ *   bun scripts/llm-usage-notify.ts --dry      # print, don't send
+ *   bun scripts/llm-usage-notify.ts --days 7   # last 7 days usage
+ *   bun scripts/llm-usage-notify.ts --alert-only  # send ONLY if a key is dead
+ *                                                  # (for frequent crons)
+ *
+ * Env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, TELEGRAM_BOT_TOKEN,
+ *      TELEGRAM_ADMIN_CHAT_ID (default 171767219), + provider keys for doctor.
+ */
+
+export {};
+
+import { spawnSync } from "child_process";
+import { readFileSync } from "fs";
+import { join } from "path";
+
+// ── Args ──────────────────────────────────────────────────────────────────────
+const args = process.argv.slice(2);
+const DRY = args.includes("--dry");
+const ALERT_ONLY = args.includes("--alert-only");
+const daysIdx = args.indexOf("--days");
+const DAYS = daysIdx >= 0 ? Math.max(1, parseInt(args[daysIdx + 1] ?? "1", 10)) : 1;
+
+const ROOT = process.cwd();
+const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
+const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
+const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN ?? process.env.TELEGRAM_BOT_TOKEN_AI_AGENTS ?? "";
+const TELEGRAM_CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID ?? "171767219";
+
+// ── Model → provider mapping ────────────────────────────────────────────────
+function providerOf(model: string): string {
+  const m = model.toLowerCase();
+  if (m.includes("qwen") || m.includes("qwq")) return "Alibaba DashScope";
+  if (m.startsWith("gpt") || m.startsWith("o1") || m.startsWith("o3") || m.includes("openai")) return "OpenAI";
+  if (m.includes("gemini") || m.includes("gemma")) return "Google";
+  if (m.includes("claude")) return "Anthropic";
+  if (m.includes("deepseek") || m.includes(":free") || m.includes("/")) return "OpenRouter";
+  return "Other";
+}
+
+// ── 1. Key health via doctor.ts --json ───────────────────────────────────────
+interface ProviderHealth { item: string; status: string; detail?: string }
+
+function getKeyHealth(): ProviderHealth[] {
+  // Run doctor (writes docs/_generated/doctor-report.json). Prefer the file it
+  // writes; fall back to stdout JSON.
+  const r = spawnSync("bun", ["scripts/doctor.ts", "--json"], {
+    cwd: ROOT, encoding: "utf-8", timeout: 60000,
+  });
+  let report: any = null;
+  try {
+    report = JSON.parse(readFileSync(join(ROOT, "docs/_generated/doctor-report.json"), "utf-8"));
+  } catch {
+    try { report = JSON.parse(r.stdout ?? "{}"); } catch { report = null; }
+  }
+  if (!report?.results) return [];
+  return report.results
+    .filter((x: any) => x.category === "provider")
+    .map((x: any) => ({ item: x.item, status: x.status, detail: x.detail }));
+}
+
+// ── 2. Usage from Supabase api_usage ─────────────────────────────────────────
+interface UsageRow { model?: string; tokens_in?: number; tokens_out?: number; cost_usd?: number }
+
+async function getUsage(): Promise<UsageRow[]> {
+  if (!SUPABASE_URL || !SUPABASE_KEY) return [];
+  const since = new Date();
+  since.setUTCDate(since.getUTCDate() - (DAYS - 1));
+  const sinceStr = since.toISOString().slice(0, 10);
+  const url = `${SUPABASE_URL}/rest/v1/api_usage?select=model,tokens_in,tokens_out,cost_usd&date=gte.${sinceStr}`;
+  try {
+    const res = await fetch(url, {
+      headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}` },
+      signal: AbortSignal.timeout(15000),
+    });
+    if (!res.ok) return [];
+    return (await res.json()) as UsageRow[];
+  } catch {
+    return [];
+  }
+}
+
+// ── Compose message ───────────────────────────────────────────────────────────
+function compose(health: ProviderHealth[], usage: UsageRow[]): { text: string; hasDeadKey: boolean } {
+  const dead = health.filter((h) => h.status === "fail");
+  const hasDeadKey = dead.length > 0;
+
+  const lines: string[] = [];
+  lines.push(`🤖 *EGOS — LLM Usage & Health* (${DAYS === 1 ? "hoje" : `${DAYS}d`})`);
+
+  // Key health
+  lines.push("");
+  lines.push("*Chaves de provider:*");
+  if (!health.length) {
+    lines.push("⚪ doctor.ts indisponível (sem dados de saúde)");
+  } else {
+    for (const h of health) {
+      const icon = h.status === "ok" ? "✅" : h.status === "fail" ? "🔴" : "🟡";
+      lines.push(`${icon} ${h.item}${h.detail ? ` — ${h.detail}` : ""}`);
+    }
+  }
+
+  // Usage by provider
+  const byProvider = new Map<string, { cost: number; tin: number; tout: number }>();
+  let total = 0;
+  for (const r of usage) {
+    const p = providerOf(r.model ?? "?");
+    const cur = byProvider.get(p) ?? { cost: 0, tin: 0, tout: 0 };
+    cur.cost += r.cost_usd ?? 0;
+    cur.tin += r.tokens_in ?? 0;
+    cur.tout += r.tokens_out ?? 0;
+    byProvider.set(p, cur);
+    total += r.cost_usd ?? 0;
+  }
+  lines.push("");
+  lines.push("*Usage por provider:*");
+  if (!byProvider.size) {
+    lines.push("⚪ Sem dados em api_usage (Supabase vazio ou não configurado)");
+  } else {
+    for (const [p, v] of [...byProvider.entries()].sort((a, b) => b[1].cost - a[1].cost)) {
+      lines.push(`• ${p}: $${v.cost.toFixed(4)} (${v.tin}in/${v.tout}out)`);
+    }
+    lines.push(`\n*Total: $${total.toFixed(4)}*`);
+  }
+
+  if (hasDeadKey) {
+    lines.push("");
+    lines.push(`⚠️ *AÇÃO:* ${dead.length} chave(s) MORTA(s) — rotacionar. Callers estão caindo em fallback silencioso.`);
+  }
+
+  return { text: lines.join("\n"), hasDeadKey };
+}
+
+// ── Telegram send ─────────────────────────────────────────────────────────────
+async function sendTelegram(text: string): Promise<boolean> {
+  if (!TELEGRAM_BOT_TOKEN) {
+    console.log("[llm-usage-notify] No TELEGRAM_BOT_TOKEN — skipping send.");
+    return false;
+  }
+  // Escape Telegram MarkdownV1 special chars in dynamic content is risky; send
+  // plain on failure (same fallback the gateway uses).
+  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
+  const body = (md: boolean) => JSON.stringify({
+    chat_id: TELEGRAM_CHAT_ID, text, ...(md ? { parse_mode: "Markdown" } : {}),
+  });
+  try {
+    let res = await fetch(url, { method: "POST", headers: { "Content-Type": "application/json" }, body: body(true), signal: AbortSignal.timeout(10000) });
+    if (!res.ok) {
+      res = await fetch(url, { method: "POST", headers: { "Content-Type": "application/json" }, body: body(false), signal: AbortSignal.timeout(10000) });
+    }
+    return res.ok;
+  } catch (e) {
+    console.error("[llm-usage-notify] send error:", e);
+    return false;
+  }
+}
+
+// ── Main ──────────────────────────────────────────────────────────────────────
+const health = getKeyHealth();
+const usage = await getUsage();
+const { text, hasDeadKey } = compose(health, usage);
+
+if (ALERT_ONLY && !hasDeadKey) {
+  console.log("[llm-usage-notify] --alert-only: no dead keys, nothing to send.");
+  process.exit(0);
+}
+
+console.log(text);
+if (DRY) {
+  console.log("\n[llm-usage-notify] --dry: not sending.");
+} else {
+  const ok = await sendTelegram(text);
+  console.log(ok ? "[llm-usage-notify] ✅ sent to Telegram." : "[llm-usage-notify] ⚠️ not sent.");
+}
+// Non-zero exit on dead key so cron logs/monitors can flag it.
+process.exit(hasDeadKey ? 2 : 0);
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

codex
The patch introduces a security regression by allowing protected MCP bridges to run unauthenticated when token loading fails, and a CLI parsing bug that can crash the new notifier script on invalid `--days` input.

Full review comments:

- [P1] Fail closed when MCP token cannot be loaded — /home/enio/egos/scripts/mcp-ecosystem.config.js:20-27
  When `EGOS_MCP_TOKEN` is missing or fails to parse from `.env`, `PROTECT` becomes an empty token and all protected bridges are started without auth. This creates a silent security downgrade in production (sensitive MCPs become publicly callable) instead of failing startup. For protected services, this path should fail fast rather than defaulting to open access.

- [P2] Validate `--days` argument before computing date range — /home/enio/egos/scripts/llm-usage-notify.ts:35-36
  The `--days` parser accepts non-numeric or missing values, which yields `NaN` and later makes `since.toISOString()` throw `RangeError: Invalid time value`. This breaks the script for common CLI mistakes like `--days` without a value; it should reject invalid input and fall back safely.
The patch introduces a security regression by allowing protected MCP bridges to run unauthenticated when token loading fails, and a CLI parsing bug that can crash the new notifier script on invalid `--days` input.

Full review comments:

- [P1] Fail closed when MCP token cannot be loaded — /home/enio/egos/scripts/mcp-ecosystem.config.js:20-27
  When `EGOS_MCP_TOKEN` is missing or fails to parse from `.env`, `PROTECT` becomes an empty token and all protected bridges are started without auth. This creates a silent security downgrade in production (sensitive MCPs become publicly callable) instead of failing startup. For protected services, this path should fail fast rather than defaulting to open access.

- [P2] Validate `--days` argument before computing date range — /home/enio/egos/scripts/llm-usage-notify.ts:35-36
  The `--days` parser accepts non-numeric or missing values, which yields `NaN` and later makes `since.toISOString()` throw `RangeError: Invalid time value`. This breaks the script for common CLI mistakes like `--days` without a value; it should reject invalid input and fall back safely.
```
