# Codex Local Review — 2026-06-01T13:29:46Z

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
session id: 019e8360-4abc-78d2-badd-2b775e1ac48e
--------
user
changes against 'HEAD~3'
2026-06-01T13:29:47.316994Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:29:47.322166Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:29:49.191382Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:29:52.934321Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:29:53.313064Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:29:53.642996Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:29:54.175976Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:29:55.116941Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:29:57.039792Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:30:00.067560Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff --name-only aea826b5f2afcbbc827c63801a57475fe19ad765 && git diff --stat aea826b5f2afcbbc827c63801a57475fe19ad765' in /home/enio/egos
 succeeded in 0ms:
.egos-manifest.yaml
docs/CAPABILITY_REGISTRY.md
docs/jobs/snapshot.json
docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
packages/chatbot-core/src/model-router.ts
scripts/doctor.ts
scripts/manifest-generator.ts
scripts/ssot-router.ts
scripts/status-snapshot.ts
 .egos-manifest.yaml                           |  4 +--
 docs/CAPABILITY_REGISTRY.md                   |  7 ++--
 docs/jobs/snapshot.json                       | 28 ++++++++++------
 docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md | 21 +++++++++++-
 packages/chatbot-core/src/model-router.ts     |  3 +-
 scripts/doctor.ts                             | 46 ++++++++++++++++++++++-----
 scripts/manifest-generator.ts                 |  4 +--
 scripts/ssot-router.ts                        |  2 +-
 scripts/status-snapshot.ts                    | 43 ++++++++++++++++++++++++-
 9 files changed, 129 insertions(+), 29 deletions(-)

exec
/bin/bash -lc 'git diff aea826b5f2afcbbc827c63801a57475fe19ad765' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.egos-manifest.yaml b/.egos-manifest.yaml
index 4f5eeec5..ad93fef7 100644
--- a/.egos-manifest.yaml
+++ b/.egos-manifest.yaml
@@ -14,8 +14,8 @@ claims:
     readme_location: "CLAUDE.md / AGENTS.md"
     command: "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\""
     tolerance: "min:18"
-    last_value: "23"
-    last_verified_at: "2026-04-29"
+    last_value: "27"
+    last_verified_at: "2026-06-01"
     category: "integrations"
 
   - id: total_capabilities
diff --git a/docs/CAPABILITY_REGISTRY.md b/docs/CAPABILITY_REGISTRY.md
index afb25e12..b4798e66 100644
--- a/docs/CAPABILITY_REGISTRY.md
+++ b/docs/CAPABILITY_REGISTRY.md
@@ -638,9 +638,10 @@ L5: Agent Registry + Skills    — Auto-discovery, hot-reload, marketplace patte
 3. OpenRouter `qwen/qwen3-coder:free` — optional 3rd slot
 
 **Hermes gateway (VPS):**
-- Service: `systemctl status hermes-gateway` → port 18800, 142MB RAM
-- Config: `/root/.hermes/config.yaml` (provider: alibaba_dashscope, model: qwen-plus)
-- .env: `/root/.hermes/.env` (DashScope key + OpenRouter key)
+- Service: `systemctl restart hermes-gateway.service hermes-worker.service` (systemd; worker is Type=oneshot)
+- Config: `/root/.hermes/config.yaml` → **`provider: alibaba`** (NOT `alibaba_dashscope` — that id is unknown to hermes' models.dev catalog and silently falls back to OpenRouter), `model: qwen-plus`
+- .env: `/root/.hermes/.env` → hermes' `alibaba` provider reads **`DASHSCOPE_API_KEY`** (register the pooled cred with `hermes auth add alibaba --type api-key --api-key env:DASHSCOPE_API_KEY`). TS scripts read `ALIBABA_DASHSCOPE_API_KEY` — keep both in sync.
+- Health: `bun scripts/doctor.ts` now does an **authenticated** probe (401 = dead key, fails loud) — added after 2026-06-01 silent-fallback incident.
 
 ## 17. DOC-DRIFT SHIELD — 4-LAYER DOCUMENTATION INTEGRITY (2026-04-07)
 
diff --git a/docs/jobs/snapshot.json b/docs/jobs/snapshot.json
index 416c4b14..fe7a956a 100644
--- a/docs/jobs/snapshot.json
+++ b/docs/jobs/snapshot.json
@@ -1,23 +1,22 @@
 {
-  "generatedAt": "2026-04-15T18:00:39.211Z",
+  "generatedAt": "2026-06-01T13:28:51.689Z",
   "version": "1.0.0",
   "services": [
     {
       "name": "guard-brasil",
       "url": "https://guard.egos.ia.br/health",
-      "healthy": true,
-      "latencyMs": 731,
-      "version": "0.2.3"
+      "healthy": false,
+      "latencyMs": 2613
     },
     {
       "name": "egos-gateway",
       "url": "https://gateway.egos.ia.br/health",
       "healthy": true,
-      "latencyMs": 734,
-      "version": "0.3.0",
+      "latencyMs": 1605,
+      "version": "0.4.0",
       "details": {
-        "uptimeSeconds": 623127,
-        "channels": 4
+        "uptimeSeconds": 438298,
+        "channels": 6
       }
     }
   ],
@@ -32,9 +31,18 @@
   },
   "guardBrasil": {
     "patternsActive": 0,
-    "guardVersion": "0.2.3"
+    "guardVersion": "unknown"
+  },
+  "framework": {
+    "capabilities": 79,
+    "agentsTotal": 27,
+    "agentsActive": 24,
+    "mcpsLive": [
+      "eval-runner",
+      "skills-registry"
+    ]
   },
   "incidentWindow": [],
   "auditPassed": true,
-  "sha256": "ce3599dbfbd6bac0741fa22409a7c2274664e58bdb66ecb81766fde29346d957"
+  "sha256": "d4c2fe0ef882ec1b8900501f3baca378515c0088ccf3880e95ffdfb2dc7ed334"
 }
\ No newline at end of file
diff --git a/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
index 0d84772d..be53b058 100644
--- a/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
+++ b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
@@ -50,4 +50,23 @@ Currículo **investigador-arquiteto** (`ENIO_CURRICULUM_POSITIONING.md`): 16 ano
 
 ---
 
-*Origem: pergunta do Enio 2026-06-01 ("onde tudo isso entra nos cursos"). Mapa módulo-a-módulo: task COURSE-MAP-001 (Sonnet).*
+---
+
+## Outline — Curso "Ciber + IA + LGPD para polícia" (COURSE-MAP-001, Sonnet 2026-06-01, ancorado no repo)
+
+> Títulos = estrutura (livre). Posições/recomendações específicas = Red Zone (corte do Enio).
+
+1. **O problema: IA no serviço público sem governo** — demo: Guard Brasil pega MASP/REDS/CPF em texto sintético. (`pii-patterns.ts`)
+2. **LGPD para investigadores** — Lei 13.709 aplicada à operação policial. ⚠️ gap: conteúdo legal ainda não está no repo.
+3. **Anatomia do dado policial: o que vaza e por quê** — MASP, REDS, nº processo, oitiva sigilosa; por que scanner genérico não pega. (`pii-patterns.ts` — diferencial real)
+4. **Guard Brasil: proteção prática (lab)** — `@egosbr/guard-brasil` em texto sintético + ATRiAN + evidence-chain (hash+fonte). (`guard.ts`, MCP live)
+5. **Como usar IA no trabalho policial (OVM)** — workflow 3 fases (Cartório→Investigação→Delegacia), transcrição Whisper local, regras de sigilo. (`ovm.md`)
+6. **Soberania de dados: rodar o modelo próprio** — economia Mac Studio (TCO 3 anos), Ollama+LLaMA/Qwen local, Guard Brasil local. (`MAC_STUDIO_LOCAL_AI.md`)
+7. **Até onde ir: governança e validação** — verificar IA antes de confiar (eval-runner, golden cases ≥85%), Resolver Doctrine R=L/C. ⚠️ "até onde ir" = posição do Enio.
+8. **Da prática ao documento: auditabilidade + cadeia de custódia digital** — evidence-chain, disclosure LGPD, audit log. (`evidence-chain.ts`, `GUARD_BRASIL_TRANSPARENCIA_RADICAL.md`)
+
+**OVM (já existe como workflow `ovm.md`):** 3 fases viram 3 módulos + 1 de sigilo/segurança (ponte pro curso Ciber).
+
+**Gaps p/ virar ensinável:** (1) **"Caso Alfa" sintético** — `casos/` é restrito; precisa exemplo fake p/ os labs. (2) **camada pedagógica** (objetivos/exercícios — hoje tudo é doc de eng). (3) **conteúdo legal LGPD** (além dos patterns). (4) **repo de cursos greenfield** ainda não existe ([[project_egos_courses_repo]]). (5) compat **Windows/PCMG** nos labs.
+
+*Origem: pergunta do Enio 2026-06-01. Mapa completo no transcript de COURSE-MAP-001.*
diff --git a/packages/chatbot-core/src/model-router.ts b/packages/chatbot-core/src/model-router.ts
index c5899e7c..9b8e605f 100644
--- a/packages/chatbot-core/src/model-router.ts
+++ b/packages/chatbot-core/src/model-router.ts
@@ -18,7 +18,8 @@ import type { ModelTier, ModelConfig } from './types.js';
 // Docs: https://help.aliyun.com/zh/model-studio/
 // ---------------------------------------------------------------------------
 
-export const DASHSCOPE_BASE_URL = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';
+// INTL endpoint — international API keys (sk-ws-*) 401 on the CN host (dashscope.aliyuncs.com).
+export const DASHSCOPE_BASE_URL = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';
 export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completions';
 
 /**
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index cbc45b74..7cad9738 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -208,14 +208,44 @@ async function checkProviderReadiness() {
       continue;
     }
 
-    // Check API reachability
-    const isReachable = await checkApiHealth(provider.url);
-    results.push({
-      category: 'provider',
-      item: provider.name,
-      status: isReachable ? 'ok' : 'warn',
-      detail: isReachable ? 'reachable' : 'unreachable (may be offline)',
-    });
+    // Authenticated probe — send the real key. A reachable endpoint that returns
+    // 401/403 means the key is DEAD. This is exactly how the Alibaba key silently
+    // expired and every caller fell back to OpenRouter (2026-06-01 incident):
+    // the old check only tested reachability, so a 401 read as "ok".
+    if (mode.noNetwork) {
+      results.push({ category: 'provider', item: provider.name, status: 'ok', detail: 'skipped (offline mode)' });
+      continue;
+    }
+    const apiKey = process.env[provider.envKey]!.trim();
+    let httpStatus = 0;
+    try {
+      const controller = new AbortController();
+      const timeoutId = setTimeout(() => controller.abort(), 8000);
+      const r = await fetch(provider.url, {
+        method: 'GET',
+        headers: { Authorization: `Bearer ${apiKey}` },
+        signal: controller.signal,
+      });
+      clearTimeout(timeoutId);
+      httpStatus = r.status;
+    } catch {
+      httpStatus = 0; // network error
+    }
+
+    if (httpStatus === 200) {
+      results.push({ category: 'provider', item: provider.name, status: 'ok', detail: 'key valid (HTTP 200)' });
+    } else if (httpStatus === 401 || httpStatus === 403) {
+      results.push({
+        category: 'provider',
+        item: provider.name,
+        status: 'fail',
+        detail: `API KEY DEAD (HTTP ${httpStatus}) — rotate ${provider.envKey}. Callers are silently falling back.`,
+      });
+    } else if (httpStatus === 0) {
+      results.push({ category: 'provider', item: provider.name, status: 'warn', detail: 'unreachable (may be offline)' });
+    } else {
+      results.push({ category: 'provider', item: provider.name, status: 'warn', detail: `unexpected HTTP ${httpStatus}` });
+    }
   }
 }
 
diff --git a/scripts/manifest-generator.ts b/scripts/manifest-generator.ts
index ba739edf..efcef679 100644
--- a/scripts/manifest-generator.ts
+++ b/scripts/manifest-generator.ts
@@ -37,7 +37,7 @@ const KNOWN_REPOS = [
 const GEMINI_KEY =
   process.env.GOOGLE_AI_STUDIO_API_KEY ||
   process.env.GEMINI_API_KEY ||
-  "AIzaSyBrM3iLF8TmXXgIoUVdDq06y_ka2qbHzMg";
+  ""; // hardcoded key removed (SEC) — set GOOGLE_AI_STUDIO_API_KEY or GEMINI_API_KEY
 
 const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";
 
@@ -237,7 +237,7 @@ README: ${readmeContent.slice(0, 1000)}`;
     const controller = new AbortController();
     const timeout = setTimeout(() => controller.abort(), 8000);
 
-    const resp = await fetch("https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions", {
+    const resp = await fetch("https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions", {
       method: "POST",
       headers: {
         "Authorization": `Bearer ${DASHSCOPE_KEY}`,
diff --git a/scripts/ssot-router.ts b/scripts/ssot-router.ts
index 0f72473a..b18d7bc2 100644
--- a/scripts/ssot-router.ts
+++ b/scripts/ssot-router.ts
@@ -236,7 +236,7 @@ async function llmRouteAlibaba(
     const controller = new AbortController();
     const timeout = setTimeout(() => controller.abort(), 8000);
 
-    const resp = await fetch("https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions", {
+    const resp = await fetch("https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions", {
       method: "POST",
       headers: {
         "Authorization": `Bearer ${apiKey}`,
diff --git a/scripts/status-snapshot.ts b/scripts/status-snapshot.ts
index d21b6d2f..5e047369 100644
--- a/scripts/status-snapshot.ts
+++ b/scripts/status-snapshot.ts
@@ -18,7 +18,7 @@
  * Cron: every 5 minutes via VPS (ENC-L6-004)
  */
 
-import { writeFileSync, readFileSync, existsSync } from "fs";
+import { writeFileSync, readFileSync, existsSync, readdirSync } from "fs";
 import { join, dirname } from "path";
 import { fileURLToPath } from "url";
 import { createClient } from "@supabase/supabase-js";
@@ -67,6 +67,12 @@ export interface StatusSnapshot {
     guardVersion: string;
     tenantsCount?: number; // only shown to authenticated community tier
   };
+  framework: {
+    capabilities: number;   // CBC files in docs/capabilities
+    agentsTotal: number;    // agents/registry/agents.json
+    agentsActive: number;
+    mcpsLive: string[];     // public MCP endpoints responding (mcp.egos.ia.br/*)
+  };
   incidentWindow: Array<{
     detectedAt: string;
     resolvedAt: string | null;
@@ -235,6 +241,38 @@ async function main() {
     process.exit(allHealthy ? 0 : 1);
   }
 
+// ── Framework stats (local fs counts + live MCP probes) ─────────────────────
+async function getFrameworkStats(): Promise<StatusSnapshot["framework"]> {
+  let capabilities = 0;
+  let agentsTotal = 0;
+  let agentsActive = 0;
+  try {
+    const cbcDir = join(ROOT, "docs", "capabilities");
+    if (existsSync(cbcDir)) {
+      capabilities = readdirSync(cbcDir).filter((f) => f.startsWith("CBC-") && f.endsWith(".md")).length;
+    }
+  } catch { /* leave 0 */ }
+  try {
+    const reg = JSON.parse(readFileSync(join(ROOT, "agents", "registry", "agents.json"), "utf-8"));
+    const agents = Array.isArray(reg) ? reg : (reg.agents ?? []);
+    agentsTotal = agents.length;
+    agentsActive = agents.filter((a: { status?: string }) => a.status === "active").length;
+  } catch { /* leave 0 */ }
+
+  // Probe only the public/free MCP endpoints (radical transparency: framework = free).
+  const freeMcps = ["eval-runner", "skills-registry"];
+  const mcpsLive: string[] = [];
+  await Promise.all(
+    freeMcps.map(async (name) => {
+      try {
+        const res = await fetch(`https://mcp.egos.ia.br/${name}/healthz`, { signal: AbortSignal.timeout(5000) });
+        if (res.ok) mcpsLive.push(name);
+      } catch { /* not live */ }
+    })
+  );
+  return { capabilities, agentsTotal, agentsActive, mcpsLive };
+}
+
   console.log("[status-snapshot] collecting metrics...");
 
   const [
@@ -243,12 +281,14 @@ async function main() {
     knowledge,
     gemHunter,
     guardMeta,
+    framework,
   ] = await Promise.all([
     checkService("guard-brasil", `${GUARD_URL}/health`),
     checkService("egos-gateway", `${GATEWAY_URL}/health`),
     getKnowledgeStats(),
     getGemHunterStats(),
     getGuardBrasilMeta(),
+    getFrameworkStats(),
   ]);
 
   const generatedAt = new Date().toISOString();
@@ -260,6 +300,7 @@ async function main() {
     knowledge,
     gemHunter,
     guardBrasil: guardMeta,
+    framework,
     incidentWindow: [], // populated from incident log (future ENC-L6-003)
     auditPassed: false, // updated below
     sha256: "", // updated below

exec
/bin/bash -lc "sed -n '1,280p' scripts/doctor.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * doctor — Comprehensive environment and project health check
 *
 * Performs full validation of:
 * - Environment variables (API keys, LLM providers)
 * - File freshness (AGENTS.md, TASKS.md, .windsurfrules within 7 days)
 * - Provider readiness (API health checks for Alibaba, Codex, OpenRouter)
 * - Pre-commit hooks status
 * - Workspace integrity (git status, uncommitted, untracked files)
 * - Governance drift detection
 *
 * Usage:
 *   bun scripts/doctor.ts                    # dry-run (report only)
 *   bun scripts/doctor.ts --doctor-skip      # skip doctor, allow execution
 *   bun scripts/doctor.ts --fix              # attempt auto-fixes for common issues
 *   bun scripts/doctor.ts --json             # output JSON report
 *   bun scripts/doctor.ts --no-network       # skip network checks (offline mode)
 *
 * Exit codes:
 *   0 = all checks passed
 *   1 = warnings only (non-blocking)
 *   2 = failures detected (blocking)
 */

import { existsSync, readFileSync, writeFileSync, mkdirSync, statSync } from 'node:fs';
import { execSync } from 'node:child_process';
import { resolve, join } from 'node:path';
import { config } from 'dotenv';

config({ override: true });

// ═══════════════════════════════════════════════════════════
// Configuration & Flags
// ═══════════════════════════════════════════════════════════

const args = process.argv.slice(2);
const mode = {
  skip: args.includes('--doctor-skip'),
  fix: args.includes('--fix'),
  json: args.includes('--json'),
  noNetwork: args.includes('--no-network'),
  verbose: args.includes('--verbose'),
};

const ROOT = resolve(import.meta.dir, '..');
const DOCS_DIR = join(ROOT, 'docs');
const REPORT_DIR = join(DOCS_DIR, '_generated');
const REPORT_PATH = join(REPORT_DIR, 'doctor-report.json');

// ═══════════════════════════════════════════════════════════
// Types
// ═══════════════════════════════════════════════════════════

interface CheckResult {
  category: 'env' | 'file' | 'provider' | 'hooks' | 'workspace' | 'governance';
  item: string;
  status: 'ok' | 'warn' | 'fail';
  detail?: string;
  fixable?: boolean;
}

interface DoctorReport {
  timestamp: string;
  duration: number;
  environment: string;
  repoPath: string;
  results: CheckResult[];
  summary: {
    total: number;
    ok: number;
    warn: number;
    fail: number;
    score: number;
  };
  recommendations: string[];
}

// ═══════════════════════════════════════════════════════════
// Utility Functions
// ═══════════════════════════════════════════════════════════

function sh(cmd: string, cwd = ROOT): string {
  try {
    return execSync(cmd, { cwd, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'ignore'], timeout: 10000 }).trim();
  } catch {
    return '';
  }
}

function shWithStatus(cmd: string, cwd = ROOT): { stdout: string; exitCode: number } {
  try {
    const stdout = execSync(cmd, { cwd, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'ignore'], timeout: 10000 }).trim();
    return { stdout, exitCode: 0 };
  } catch (e: any) {
    return { stdout: '', exitCode: e.status || 1 };
  }
}

function getFileAge(filePath: string): number {
  if (!existsSync(filePath)) return -1;
  const stat = statSync(filePath);
  return Math.floor((Date.now() - stat.mtimeMs) / (1000 * 60 * 60 * 24)); // days
}

async function checkApiHealth(url: string, timeout = 5000): Promise<boolean> {
  if (mode.noNetwork) return true; // Assume OK in offline mode
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);
    const response = await fetch(url, { method: 'GET', signal: controller.signal });
    clearTimeout(timeoutId);
    return response.status >= 200 && response.status < 500;
  } catch {
    return false;
  }
}

// ═══════════════════════════════════════════════════════════
// Checks Implementation
// ═══════════════════════════════════════════════════════════

const results: CheckResult[] = [];

// ─── 1. Environment Variables ───
function checkEnvironmentVariables() {
  const required = ['ALIBABA_DASHSCOPE_API_KEY', 'OPENROUTER_API_KEY'];
  const optional = [
    'OPENAI_API_KEY',
    'GROQ_API_KEY',
    'SERPER_API_KEY',
    'BRAVE_API',
    'EXA_API_KEY',
    'GITHUB_TOKEN',
    'STITCH_API_KEY',
    'GITHUB_PERSONAL_ACCESS_TOKEN',
  ];

  for (const key of required) {
    if (process.env[key]?.trim()) {
      results.push({ category: 'env', item: key, status: 'ok' });
    } else {
      results.push({ category: 'env', item: key, status: 'fail', detail: 'required but not set' });
    }
  }

  for (const key of optional) {
    if (process.env[key]?.trim()) {
      results.push({ category: 'env', item: key, status: 'ok' });
    } else {
      results.push({ category: 'env', item: key, status: 'warn', detail: 'optional, not configured' });
    }
  }
}

// ─── 2. File Freshness ───
function checkFileFreshness() {
  const files = [
    { path: 'AGENTS.md', label: 'Agents registry' },
    { path: 'TASKS.md', label: 'Tasks registry' },
    { path: '.windsurfrules', label: 'Governance rules' },
    { path: 'docs/SYSTEM_MAP.md', label: 'System map' },
  ];

  const freshnessThreshold = 7; // days

  for (const file of files) {
    const fullPath = resolve(ROOT, file.path);
    if (!existsSync(fullPath)) {
      results.push({ category: 'file', item: file.label, status: 'fail', detail: `${file.path} missing` });
      continue;
    }

    const age = getFileAge(fullPath);
    if (age <= freshnessThreshold) {
      results.push({ category: 'file', item: file.label, status: 'ok', detail: `${age} days old` });
    } else {
      results.push({
        category: 'file',
        item: file.label,
        status: 'warn',
        detail: `${age} days old (stale, > ${freshnessThreshold} days)`,
        fixable: true,
      });
    }
  }
}

// ─── 3. Provider Readiness ───
async function checkProviderReadiness() {
  const providers = [
    { name: 'Alibaba DashScope', url: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/models', envKey: 'ALIBABA_DASHSCOPE_API_KEY' },
    { name: 'OpenRouter', url: 'https://openrouter.ai/api/v1/models', envKey: 'OPENROUTER_API_KEY' },
    { name: 'OpenAI', url: 'https://api.openai.com/v1/models', envKey: 'OPENAI_API_KEY', optional: true },
  ];

  for (const provider of providers) {
    // Check env first
    const hasEnv = !!process.env[provider.envKey]?.trim();
    if (!hasEnv) {
      const status = provider.optional ? 'warn' : 'fail';
      results.push({
        category: 'provider',
        item: provider.name,
        status,
        detail: 'API key not configured',
      });
      continue;
    }

    // Authenticated probe — send the real key. A reachable endpoint that returns
    // 401/403 means the key is DEAD. This is exactly how the Alibaba key silently
    // expired and every caller fell back to OpenRouter (2026-06-01 incident):
    // the old check only tested reachability, so a 401 read as "ok".
    if (mode.noNetwork) {
      results.push({ category: 'provider', item: provider.name, status: 'ok', detail: 'skipped (offline mode)' });
      continue;
    }
    const apiKey = process.env[provider.envKey]!.trim();
    let httpStatus = 0;
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 8000);
      const r = await fetch(provider.url, {
        method: 'GET',
        headers: { Authorization: `Bearer ${apiKey}` },
        signal: controller.signal,
      });
      clearTimeout(timeoutId);
      httpStatus = r.status;
    } catch {
      httpStatus = 0; // network error
    }

    if (httpStatus === 200) {
      results.push({ category: 'provider', item: provider.name, status: 'ok', detail: 'key valid (HTTP 200)' });
    } else if (httpStatus === 401 || httpStatus === 403) {
      results.push({
        category: 'provider',
        item: provider.name,
        status: 'fail',
        detail: `API KEY DEAD (HTTP ${httpStatus}) — rotate ${provider.envKey}. Callers are silently falling back.`,
      });
    } else if (httpStatus === 0) {
      results.push({ category: 'provider', item: provider.name, status: 'warn', detail: 'unreachable (may be offline)' });
    } else {
      results.push({ category: 'provider', item: provider.name, status: 'warn', detail: `unexpected HTTP ${httpStatus}` });
    }
  }
}

// ─── 4. Pre-commit Hooks ───
function checkPrecommitHooks() {
  const hooksPath = resolve(ROOT, '.husky');
  const precommitPath = resolve(hooksPath, 'pre-commit');

  if (!existsSync(hooksPath)) {
    results.push({ category: 'hooks', item: 'Husky directory', status: 'fail', detail: '.husky/ missing' });
    return;
  }

  results.push({ category: 'hooks', item: 'Husky directory', status: 'ok' });

  if (!existsSync(precommitPath)) {
    results.push({
      category: 'hooks',
      item: 'Pre-commit hook',
      status: 'warn',
      detail: 'pre-commit hook not installed',
      fixable: true,
    });
  } else {
    results.push({ category: 'hooks', item: 'Pre-commit hook', status: 'ok' });
  }
}

// ─── 5. Workspace Integrity ───
function checkWorkspaceIntegrity() {
  // Check git status
  const gitStatus = sh('git status --porcelain');

exec
/bin/bash -lc "sed -n '200,360p' scripts/status-snapshot.ts" in /home/enio/egos
 succeeded in 0ms:
      },
      body: JSON.stringify({ text, context: "status_page_output" }),
      signal: AbortSignal.timeout(8000),
    });
    if (!res.ok) return true; // if guard is down, skip (don't block snapshot)
    const result = await res.json();
    if (!result.safe) {
      console.error("[status-snapshot] Guard Brasil: unsafe content detected in snapshot");
      console.error("[status-snapshot] Findings:", result.masking?.findingCount);
      return false;
    }
    return true;
  } catch {
    return true; // network error — don't block
  }
}

// ── SHA-256 hash ──────────────────────────────────────────────────────────────

async function sha256(text: string): Promise<string> {
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// ── Main ──────────────────────────────────────────────────────────────────────

async function main() {
  if (CHECK) {
    if (!existsSync(SNAPSHOT_PATH)) {
      console.error("❌ snapshot.json not found at", SNAPSHOT_PATH);
      process.exit(1);
    }
    const snap = JSON.parse(readFileSync(SNAPSHOT_PATH, "utf-8")) as StatusSnapshot;
    const age = Date.now() - new Date(snap.generatedAt).getTime();
    const ageMin = Math.round(age / 60000);
    const allHealthy = snap.services.every((s) => s.healthy);
    console.log(`✅ snapshot.json: ${snap.services.length} services, age ${ageMin}min`);
    console.log(`   services: ${snap.services.map((s) => (s.healthy ? "🟢" : "🔴") + s.name).join(" ")}`);
    if (!snap.auditPassed) console.warn("⚠️  Last Guard Brasil audit failed");
    process.exit(allHealthy ? 0 : 1);
  }

// ── Framework stats (local fs counts + live MCP probes) ─────────────────────
async function getFrameworkStats(): Promise<StatusSnapshot["framework"]> {
  let capabilities = 0;
  let agentsTotal = 0;
  let agentsActive = 0;
  try {
    const cbcDir = join(ROOT, "docs", "capabilities");
    if (existsSync(cbcDir)) {
      capabilities = readdirSync(cbcDir).filter((f) => f.startsWith("CBC-") && f.endsWith(".md")).length;
    }
  } catch { /* leave 0 */ }
  try {
    const reg = JSON.parse(readFileSync(join(ROOT, "agents", "registry", "agents.json"), "utf-8"));
    const agents = Array.isArray(reg) ? reg : (reg.agents ?? []);
    agentsTotal = agents.length;
    agentsActive = agents.filter((a: { status?: string }) => a.status === "active").length;
  } catch { /* leave 0 */ }

  // Probe only the public/free MCP endpoints (radical transparency: framework = free).
  const freeMcps = ["eval-runner", "skills-registry"];
  const mcpsLive: string[] = [];
  await Promise.all(
    freeMcps.map(async (name) => {
      try {
        const res = await fetch(`https://mcp.egos.ia.br/${name}/healthz`, { signal: AbortSignal.timeout(5000) });
        if (res.ok) mcpsLive.push(name);
      } catch { /* not live */ }
    })
  );
  return { capabilities, agentsTotal, agentsActive, mcpsLive };
}

  console.log("[status-snapshot] collecting metrics...");

  const [
    guardHealth,
    gatewayHealth,
    knowledge,
    gemHunter,
    guardMeta,
    framework,
  ] = await Promise.all([
    checkService("guard-brasil", `${GUARD_URL}/health`),
    checkService("egos-gateway", `${GATEWAY_URL}/health`),
    getKnowledgeStats(),
    getGemHunterStats(),
    getGuardBrasilMeta(),
    getFrameworkStats(),
  ]);

  const generatedAt = new Date().toISOString();

  const snapshot: StatusSnapshot = {
    generatedAt,
    version: "1.0.0",
    services: [guardHealth, gatewayHealth],
    knowledge,
    gemHunter,
    guardBrasil: guardMeta,
    framework,
    incidentWindow: [], // populated from incident log (future ENC-L6-003)
    auditPassed: false, // updated below
    sha256: "", // updated below
  };

  // Guard Brasil audit on snapshot output
  const snapshotText = JSON.stringify(snapshot);
  const auditPassed = await auditSnapshot(snapshotText);
  snapshot.auditPassed = auditPassed;

  // Content hash for integrity verification
  snapshot.sha256 = await sha256(snapshotText);

  const output = JSON.stringify(snapshot, null, 2);

  if (DRY) {
    console.log(output);
    const healthCount = snapshot.services.filter((s) => s.healthy).length;
    console.error(
      `\n[status-snapshot] ${healthCount}/${snapshot.services.length} services healthy | audit: ${auditPassed ? "✅" : "❌"}`
    );
    return;
  }

  writeFileSync(SNAPSHOT_PATH, output, "utf-8");
  const healthCount = snapshot.services.filter((s) => s.healthy).length;
  console.log(
    `[status-snapshot] written to ${SNAPSHOT_PATH} | ${healthCount}/${snapshot.services.length} healthy | audit: ${auditPassed ? "✅" : "❌"}`
  );

  await logAgentEvent({
    source: 'status-snapshot',
    event_type: 'completed',
    severity: 'info',
    payload: {
      services_count: snapshot.services.length,
      healthy_count: healthCount,
      kb_page_count: snapshot.knowledge.pageCount,
    },
  });
}

if (import.meta.main) {
  main().catch(async (e) => {
    console.error("[status-snapshot] fatal:", e);
    await logAgentEvent({
      source: 'status-snapshot',
      event_type: 'error',
      severity: 'error',
      payload: { error: String(e) },
    });
    process.exit(1);
  });
}

codex
I did not find any introduced defects that are clearly actionable and likely to be fixed by the author. The code changes are coherent with the documented intent (security hardening, endpoint migration, and richer status reporting) and do not show obvious correctness regressions.
I did not find any introduced defects that are clearly actionable and likely to be fixed by the author. The code changes are coherent with the documented intent (security hardening, endpoint migration, and richer status reporting) and do not show obvious correctness regressions.
```
