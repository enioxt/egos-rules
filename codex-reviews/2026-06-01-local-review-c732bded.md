# Codex Local Review — 2026-06-01T12:57:43Z

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
session id: 019e8342-f3b6-7ee0-a329-feba005669ac
--------
user
changes against 'HEAD~3'
2026-06-01T12:57:44.438970Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:57:44.439500Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:57:49.558491Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:57:49.931794Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:57:50.290738Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T12:57:50.922394Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T12:57:51.178105Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:57:51.940126Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T12:57:53.648215Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T12:57:57.178724Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff c19ce556c514ea738c0c027610147f85d612dc72' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 17249086..a74c6da2 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -510,9 +510,9 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 
 ### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
 > Ref: https://developers.openai.com/apps-sdk · Conector custom do ChatGPT = Server URL (SSE) + Auth (OAuth / Sem-auth / Mista). `mcp-g-pecas` já rodou HTTPS-live no ChatGPT → caminho provado. Objetivo: validar uso real dos MCPs no ChatGPT.
-- [ ] **MCP-CHATGPT-001** [P1] `prime` — Validar `mcp-eval-runner` (GREEN: read-only, sem segredo) no conector ChatGPT. **Receita validada (Sonnet 2026-06-01):** ChatGPT exige **Streamable HTTP** em endpoint `/mcp` (auth=Bearer estático basta; OAuth exige auth-server+`/.well-known`). `mcp-bridge` já faz tudo (CORS/Origin/bearer/sessão). Passos: (1) PM2 `MCP_NAME=eval-runner MCP_CMD="bun packages/mcp-eval-runner/src/index.ts" MCP_PORT=7005 bun packages/mcp-bridge/src/index.ts`; (2) Caddy `handle /eval-runner* { uri strip_prefix /eval-runner; reverse_proxy localhost:7005 }` no bloco `mcp.egos.ia.br`; (3) token em `/etc/egos/eval-runner.env`; (4) probe `curl POST https://mcp.egos.ia.br/eval-runner/mcp` initialize; (5) colar URL no diálogo do ChatGPT, auth=Bearer. ~1h. **Toca prod+Caddy → go do Enio + review Codex antes.**
 - [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
 - [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
+- [ ] **MCP-SEC-001** [P0] `redzone` — **Achado 2026-06-01:** todos os bridges RED (`governance`/`knowledge`/`memory`/`security`/`ops`/`observability`/`browser-automation`) estão roteados em `mcp.egos.ia.br/*` no Caddy SEM auth, e os bridges rodam auth-disabled (dev mode). Hoje só não vazam porque rodavam o código QUEBRADO; o fix `ae4da0c0` está no arquivo compartilhado → **se qualquer RED reiniciar, vaza kernel sem-auth**. NÃO reiniciar os RED. Antes de qualquer deploy: setar `EGOS_MCP_TOKEN` nos RED OU remover rotas Caddy OU basic-auth. Corte do Enio + review Codex (= MCP-BRIDGE-003).
 
 ---
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 5fb6e0f8..f7d82a5e 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3269,3 +3269,10 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 🛡️ RESOLVER DOCTRINE — Prime como última camada + triagem matemática (2026-06-01)
 - [x] **RESOLVER-001** — Authored RESOLVER_DOCTRINE.md + wired CLAUDE.md/start/end + memory.
 
+
+## Archived 2026-06-01
+
+### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
+- [x] **MCP-CHATGPT-001** [P1] `prime` — Validar `mcp-eval-runner` (GREEN: read-only, sem segredo) no conector ChatGPT. **Receita validada (Sonnet 2026-06-01):** ChatGPT exige **Streamable HTTP** em endpoint `/mcp` (auth=Bearer estático basta; OAuth exige auth-server+`/.well-known`). `mcp-bridge` já faz tudo (CORS/Origin/bearer/sessão). Passos: (1) PM2 `MCP_NAME=eval-runner MCP_CMD="bun packages/mcp-eval-runner/src/index.ts" MCP_PORT=7005 bun packages/mcp-bridge/src/index.ts`; (2) Caddy `handle /eval-runner* { uri strip_prefix /eval-runner; reverse_proxy localhost:7005 }` no bloco `mcp.egos.ia.br`; (3) token em `/etc/egos/eval-runner.env`; (4) probe `curl POST https://mcp.egos.ia.br/eval-runner/mcp` initialize; (5) colar URL no diálogo do ChatGPT, auth=Bearer. ~1h. **Toca prod+Caddy → go do Enio + review Codex antes.** ✅ 2026-06-01
+- [x] **MCP-CHATGPT-FIX-001** — Bridge stdio framing bug consertado (newline stdin + line-buffer + notification 202). `eval-runner` validado ponta-a-ponta via Caddy. SHA `ae4da0c0`.
+
diff --git a/agents/agents/article-writer.ts b/agents/agents/article-writer.ts
index 2590d4ed..9bb8f178 100644
--- a/agents/agents/article-writer.ts
+++ b/agents/agents/article-writer.ts
@@ -14,6 +14,9 @@
 
 import { execSync } from "child_process";
 import { readFileSync, existsSync } from "fs";
+import { resolve, join } from "path";
+
+const REPO_ROOT = resolve(import.meta.dir, "..", "..");
 
 // ── CLI Args ───────────────────────────────────────────────────────────────
 
@@ -104,7 +107,7 @@ interface CommitInfo {
 
 function resolveCommit(ref: string): string {
   try {
-    return execSync(`git -C /home/enio/egos rev-parse --short ${ref}`, {
+    return execSync(`git -C ${REPO_ROOT} rev-parse --short ${ref}`, {
       encoding: "utf8",
       stdio: ["pipe", "pipe", "pipe"],
     }).trim();
@@ -117,23 +120,23 @@ function getCommitInfo(commitHash: string): CommitInfo {
   const shortHash = resolveCommit(commitHash);
 
   const subject = execSync(
-    `git -C /home/enio/egos log -1 --format="%s" ${shortHash}`,
+    `git -C ${REPO_ROOT} log -1 --format="%s" ${shortHash}`,
     { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] }
   ).trim();
 
   const author = execSync(
-    `git -C /home/enio/egos log -1 --format="%an" ${shortHash}`,
+    `git -C ${REPO_ROOT} log -1 --format="%an" ${shortHash}`,
     { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] }
   ).trim();
 
   const date = execSync(
-    `git -C /home/enio/egos log -1 --format="%ci" ${shortHash}`,
+    `git -C ${REPO_ROOT} log -1 --format="%ci" ${shortHash}`,
     { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] }
   ).trim();
 
   // stat: changed files summary
   const stat = execSync(
-    `git -C /home/enio/egos show ${shortHash} --stat --no-color`,
+    `git -C ${REPO_ROOT} show ${shortHash} --stat --no-color`,
     { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] }
   ).trim();
 
@@ -141,7 +144,7 @@ function getCommitInfo(commitHash: string): CommitInfo {
   let diff = "";
   try {
     diff = execSync(
-      `git -C /home/enio/egos diff ${shortHash}~1 ${shortHash} --no-color`,
+      `git -C ${REPO_ROOT} diff ${shortHash}~1 ${shortHash} --no-color`,
       { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"], maxBuffer: 1024 * 1024 }
     ).trim();
     if (diff.length > 4000) diff = diff.slice(0, 4000) + "\n... [diff truncated]";
@@ -151,7 +154,7 @@ function getCommitInfo(commitHash: string): CommitInfo {
 
   // list of changed files
   const files = execSync(
-    `git -C /home/enio/egos diff --name-only ${shortHash}~1 ${shortHash}`,
+    `git -C ${REPO_ROOT} diff --name-only ${shortHash}~1 ${shortHash}`,
     { encoding: "utf8", stdio: ["pipe", "pipe", "pipe"] }
   )
     .trim()
@@ -173,7 +176,7 @@ function readRelatedDocs(files: string[]): string {
     .slice(0, 5); // max 5 files for context
 
   for (const file of filesToRead) {
-    const fullPath = `/home/enio/egos/${file}`;
+    const fullPath = join(REPO_ROOT, file);
     if (!existsSync(fullPath)) continue;
     try {
       const content = readFileSync(fullPath, "utf8").slice(0, 1500);
@@ -184,7 +187,7 @@ function readRelatedDocs(files: string[]): string {
   }
 
   // Always include X_POSTS_SSOT.md for tone reference (sections 1-2, ~1500 chars)
-  const ssotPath = "/home/enio/egos/docs/social/X_POSTS_SSOT.md";
+  const ssotPath = join(REPO_ROOT, "docs/social/X_POSTS_SSOT.md");
   if (existsSync(ssotPath)) {
     try {
       const toneRef = readFileSync(ssotPath, "utf8").slice(0, 1500);
@@ -194,7 +197,7 @@ function readRelatedDocs(files: string[]): string {
     }
   } else {
     // Fallback: try old path
-    const oldPath = "/home/enio/egos/docs/X_POSTS_SSOT.md";
+    const oldPath = join(REPO_ROOT, "docs/X_POSTS_SSOT.md");
     if (existsSync(oldPath)) {
       try {
         const toneRef = readFileSync(oldPath, "utf8").slice(0, 1500);
diff --git a/agents/agents/capability-scanner.ts b/agents/agents/capability-scanner.ts
index d73fb3f6..84fb4c40 100644
--- a/agents/agents/capability-scanner.ts
+++ b/agents/agents/capability-scanner.ts
@@ -39,19 +39,22 @@
 import { execSync } from 'child_process';
 import { readFileSync, writeFileSync, existsSync } from 'fs';
 import { join } from 'path';
+import { homedir } from 'os';
 
 // ── Config ─────────────────────────────────────────────────────────────────
 
-const REGISTRY_PATH = join(import.meta.dir, '../../docs/CAPABILITY_REGISTRY.md');
-const CROSS_INDEX_PATH = join(import.meta.dir, '../../docs/knowledge/CAPABILITY_CROSS_INDEX.md');
+const REPO_ROOT = join(import.meta.dir, '../..');
+const REGISTRY_PATH = join(REPO_ROOT, 'docs/CAPABILITY_REGISTRY.md');
+const CROSS_INDEX_PATH = join(REPO_ROOT, 'docs/knowledge/CAPABILITY_CROSS_INDEX.md');
 
+const HOME = homedir();
 const KNOWN_REPOS = [
-  { name: 'egos',         path: '/home/enio/egos' },
-  { name: 'carteira-livre', path: '/home/enio/carteira-livre' },
-  { name: 'intelink',     path: '/home/enio/intelink' },
-  { name: '852',          path: '/home/enio/852' },
-  { name: 'gem-hunter',   path: '/home/enio/gem-hunter' },
-  { name: 'egos-lab',     path: '/home/enio/egos-lab' },
+  { name: 'egos',         path: join(HOME, 'egos') },
+  { name: 'carteira-livre', path: join(HOME, 'carteira-livre') },
+  { name: 'intelink',     path: join(HOME, 'intelink') },
+  { name: '852',          path: join(HOME, '852') },
+  { name: 'gem-hunter',   path: join(HOME, 'gem-hunter') },
+  { name: 'egos-lab',     path: join(HOME, 'egos-lab') },
 ];
 
 // ── LLM Call ───────────────────────────────────────────────────────────────
@@ -128,13 +131,13 @@ Respond ONLY with valid JSON (no markdown, no explanation):
 
 function getStagedDiff(): string {
   try {
-    return execSync('git diff --staged --stat --no-color', { encoding: 'utf-8', cwd: '/home/enio/egos' });
+    return execSync('git diff --staged --stat --no-color', { encoding: 'utf-8', cwd: REPO_ROOT });
   } catch { return ''; }
 }
 
 function getCommitDiff(ref: string): string {
   try {
-    return execSync(`git show --stat --no-color ${ref}`, { encoding: 'utf-8', cwd: '/home/enio/egos' });
+    return execSync(`git show --stat --no-color ${ref}`, { encoding: 'utf-8', cwd: REPO_ROOT });
   } catch { return ''; }
 }
 
diff --git a/agents/agents/chatbot-manifest-aggregator.ts b/agents/agents/chatbot-manifest-aggregator.ts
index a7427b0c..f2a807c6 100644
--- a/agents/agents/chatbot-manifest-aggregator.ts
+++ b/agents/agents/chatbot-manifest-aggregator.ts
@@ -19,26 +19,27 @@
 
 import { execSync } from "node:child_process";
 import { readFileSync, writeFileSync, existsSync } from "node:fs";
-import { resolve } from "node:path";
-import { tmpdir } from "node:os";
+import { resolve, join } from "node:path";
+import { tmpdir, homedir } from "node:os";
 
 const REPO_ROOT = resolve(import.meta.dir, "../..");
+const HOME = homedir();
 
 const MANIFESTS: { id: string; path: string }[] = [
   {
     id: "852",
-    path: "/home/enio/852/src/app/api/_internal/chatbot-manifest/route.ts",
+    path: join(HOME, "852/src/app/api/_internal/chatbot-manifest/route.ts"),
   },
   {
     id: "forja",
-    path: "/home/enio/forja/src/app/api/_internal/chatbot-manifest/route.ts",
+    path: join(HOME, "forja/src/app/api/_internal/chatbot-manifest/route.ts"),
   },
   {
     id: "carteira-livre",
-    path: "/home/enio/carteira-livre/app/api/_internal/chatbot-manifest/route.ts",
+    path: join(HOME, "carteira-livre/app/api/_internal/chatbot-manifest/route.ts"),
   },
   // intelink: chatbot_manifest.py removido na migração para Next.js API routes (2026-05-05)
-  // Endpoint equivalente: /home/enio/intelink/app/api/chat/route.ts
+  // Endpoint equivalente: join(HOME, "intelink/app/api/chat/route.ts")
 ];
 
 const SSOT_PATH = resolve(REPO_ROOT, "docs/modules/CHATBOT_SSOT.md");
diff --git a/agents/agents/doc-drift-sentinel.ts b/agents/agents/doc-drift-sentinel.ts
index 222b82c1..f67c1dc4 100644
--- a/agents/agents/doc-drift-sentinel.ts
+++ b/agents/agents/doc-drift-sentinel.ts
@@ -26,13 +26,15 @@
 import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
 import { join, dirname } from "path";
 import { parse as parseYaml, stringify as stringifyYaml } from "yaml";
+import { homedir } from "os";
 
 // ─── Constants ────────────────────────────────────────────────────────────────
 
+const REPO_ROOT = join(import.meta.dir, "../..");
 const VERIFIER = join(dirname(Bun.main), "doc-drift-verifier.ts");
 const ISSUE_LOG = "/var/lib/egos/doc-drift-sentinel/issue-log.json";
 const ISSUE_COOLDOWN_DAYS = 7;
-const REPOS_ROOT = "/home/enio";
+const REPOS_ROOT = homedir();
 const REPO_GITHUB_MAP: Record<string, string> = {
   "egos": "enioxt/egos",
   "carteira-livre": "enioxt/carteira-livre",
@@ -534,7 +536,7 @@ async function runSentinel(mode: "dry" | "exec", singleRepo?: string): Promise<S
 
 function writeReport(run: SentinelRun): void {
   const date = new Date().toISOString().slice(0, 10);
-  const reportDir = "/home/enio/egos/docs/jobs";
+  const reportDir = join(REPO_ROOT, "docs/jobs");
   const reportPath = join(reportDir, `${date}-doc-drift-sentinel.md`);
 
   const lines = [
diff --git a/agents/agents/doc-drift-verifier.ts b/agents/agents/doc-drift-verifier.ts
index 26dd6354..2e1f9e1d 100644
--- a/agents/agents/doc-drift-verifier.ts
+++ b/agents/agents/doc-drift-verifier.ts
@@ -25,6 +25,7 @@
 import { existsSync, mkdirSync, writeFileSync } from "fs";
 import { join, dirname } from "path";
 import { parse as parseYamlLib } from "yaml";
+import { homedir } from "os";
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -111,12 +112,13 @@ interface VerificationReport {
 
 // ─── Known repos ─────────────────────────────────────────────────────────────
 
+const HOME = homedir();
 const KNOWN_REPOS = [
-  "/home/enio/egos",
-  "/home/enio/carteira-livre",
-  "/home/enio/br-acc",
-  "/home/enio/egos-lab",
-  "/home/enio/852",
+  join(HOME, "egos"),
+  join(HOME, "carteira-livre"),
+  join(HOME, "br-acc"),
+  join(HOME, "egos-lab"),
+  join(HOME, "852"),
 ];
 
 // ─── YAML parser ─────────────────────────────────────────────────────────────
@@ -711,7 +713,7 @@ if (opts.json) {
 }
 
 // Save report to docs/jobs/
-const EGOS_ROOT = "/home/enio/egos";
+const EGOS_ROOT = join(HOME, "egos");
 try {
   const jobsDir = join(EGOS_ROOT, "docs/jobs");
   mkdirSync(jobsDir, { recursive: true });
diff --git a/agents/agents/readme-syncer.ts b/agents/agents/readme-syncer.ts
index ea5809ce..2db3126d 100644
--- a/agents/agents/readme-syncer.ts
+++ b/agents/agents/readme-syncer.ts
@@ -29,6 +29,7 @@
 import { existsSync, readFileSync, writeFileSync } from "fs";
 import { join, dirname } from "path";
 import { parse as parseYaml } from "yaml";
+import { homedir } from "os";
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -44,10 +45,11 @@ interface Manifest {
 
 // ─── Known repos ─────────────────────────────────────────────────────────────
 
+const HOME = homedir();
 const KNOWN_REPOS = [
-  "/home/enio/egos",
-  "/home/enio/carteira-livre",
-  "/home/enio/br-acc",
+  join(HOME, "egos"),
+  join(HOME, "carteira-livre"),
+  join(HOME, "br-acc"),
 ];
 
 // ─── Patterns ────────────────────────────────────────────────────────────────
diff --git a/agents/agents/wiki-compiler.ts b/agents/agents/wiki-compiler.ts
index 1a4e1726..4f652521 100644
--- a/agents/agents/wiki-compiler.ts
+++ b/agents/agents/wiki-compiler.ts
@@ -25,11 +25,12 @@
 
 import { readFileSync, readdirSync, existsSync, statSync } from "fs";
 import { join, basename } from "path";
+import { homedir } from "os";
 
 // ── Config ────────────────────────────────────────────────────────────
 
-const ROOT = "/home/enio/egos";
-const REPOS_BASE = "/home/enio";
+const ROOT = join(import.meta.dir, "../..");
+const REPOS_BASE = homedir();
 const DRY_RUN = process.argv.includes("--dry");
 const TENANT = process.argv.find(a => a.startsWith("--tenant="))?.replace("--tenant=", "") ?? "";
 const EFFECTIVE_TENANT = TENANT || "egos";
@@ -94,12 +95,12 @@ const RAW_SOURCES = [...KERNEL_SOURCES, ...CROSS_REPO_SOURCES];
 // Tenant-specific source directories (added when --tenant=<id> is set)
 const TENANT_SOURCES: Record<string, typeof RAW_SOURCES> = {
   forja: [
-    { path: "/home/enio/forja/docs/kb-pilot", category: "synthesis" as const, prefix: "forja", repo: "forja" },
-    { path: "/home/enio/forja/docs/strategy", category: "decision" as const, prefix: "forja-strategy", repo: "forja" },
-    { path: "/home/enio/forja/docs/knowledge", category: "pattern" as const, prefix: "forja-kb", repo: "forja" },
+    { path: join(REPOS_BASE, "forja/docs/kb-pilot"), category: "synthesis" as const, prefix: "forja", repo: "forja" },
+    { path: join(REPOS_BASE, "forja/docs/strategy"), category: "decision" as const, prefix: "forja-strategy", repo: "forja" },
+    { path: join(REPOS_BASE, "forja/docs/knowledge"), category: "pattern" as const, prefix: "forja-kb", repo: "forja" },
   ],
   "egos-consulting": [
-    { path: "/home/enio/egos/docs/kb-vps", category: "synthesis" as const, prefix: "consulting", repo: "egos" },
+    { path: join(ROOT, "docs/kb-vps"), category: "synthesis" as const, prefix: "consulting", repo: "egos" },
   ],
 };
 
diff --git a/agents/registry/agents.json b/agents/registry/agents.json
index da119f59..f2f29ebd 100644
--- a/agents/registry/agents.json
+++ b/agents/registry/agents.json
@@ -825,7 +825,7 @@
       "id": "skill-candidate-extractor",
       "name": "Skill Candidate Extractor",
       "kind": "tool",
-      "description": "Mines agents/.logs/*.jsonl events \u2192 clusters by (topic, source) \u2192 generates docs/_drafts/skill-candidates/*.md for HITL approval. EGOS equivalent of Hivemind trace-to-skill pipeline.",
+      "description": "Mines agents/.logs/*.jsonl events ➔ clusters by (topic, source) ➔ generates docs/_drafts/skill-candidates/*.md for HITL approval. EGOS equivalent of Hivemind trace-to-skill pipeline.",
       "area": "intelligence",
       "entrypoint": "scripts/skill-candidate-extractor.ts",
       "run_modes": [
@@ -856,6 +856,101 @@
         "algorithm": "ed25519",
         "ledger_table": "agent_actions_ledger"
       }
+    },
+    {
+      "id": "chatbot-compliance-checker",
+      "name": "Chatbot Compliance Checker",
+      "kind": "tool",
+      "description": "Scans codebase to evaluate compliance against Modular Prompt, ATRiAN, and PII policies inside CHATBOT_SSOT.md",
+      "area": "compliance",
+      "entrypoint": "agents/agents/chatbot-compliance-checker.ts",
+      "run_modes": [
+        "dry_run",
+        "execute"
+      ],
+      "triggers": [
+        "manual"
+      ],
+      "tools_allowed": [],
+      "risk_level": "T0",
+      "status": "active",
+      "owner": "enioxt",
+      "runtime_proof": "bun agents/agents/chatbot-compliance-checker.ts --dry",
+      "telemetry_source": "stdout",
+      "cost_source": "none",
+      "side_effects": [
+        "fs_write"
+      ],
+      "approval_level": "L0",
+      "signature": {
+        "enabled": false,
+        "public_key": null,
+        "algorithm": "ed25519",
+        "ledger_table": "agent_actions_ledger"
+      }
+    },
+    {
+      "id": "gtm-harvester",
+      "name": "GTM Harvester",
+      "kind": "tool",
+      "description": "Scans public GitHub repositories for market/GTM strategy artifacts and returns a distilled map of reusable business execution signals",
+      "area": "intelligence",
+      "entrypoint": "agents/agents/gtm-harvester.ts",
+      "run_modes": [
+        "dry_run",
+        "execute"
+      ],
+      "triggers": [
+        "manual"
+      ],
+      "tools_allowed": [],
+      "risk_level": "T0",
+      "status": "active",
+      "owner": "enioxt",
+      "runtime_proof": "bun agents/agents/gtm-harvester.ts --dry",
+      "telemetry_source": "stdout",
+      "cost_source": "none",
+      "side_effects": [],
+      "approval_level": "L0",
+      "signature": {
+        "enabled": false,
+        "public_key": null,
+        "algorithm": "ed25519",
+        "ledger_table": "agent_actions_ledger"
+      }
+    },
+    {
+      "id": "capability-scanner",
+      "name": "Capability Scanner",
+      "kind": "tool",
+      "description": "Analyzes commit diffs to classify and extract new capabilities, proposing or applying them to CAPABILITY_REGISTRY.md",
+      "area": "governance",
+      "entrypoint": "agents/agents/capability-scanner.ts",
+      "run_modes": [
+        "dry_run",
+        "execute"
+      ],
+      "triggers": [
+        "manual",
+        "pre_commit"
+      ],
+      "tools_allowed": [],
+      "risk_level": "T1",
+      "status": "active",
+      "owner": "enioxt",
+      "runtime_proof": "bun agents/agents/capability-scanner.ts --dry",
+      "telemetry_source": "stdout",
+      "cost_source": "openrouter",
+      "side_effects": [
+        "fs_write"
+      ],
+      "approval_level": "L1",
+      "signature": {
+        "enabled": false,
+        "public_key": null,
+        "algorithm": "ed25519",
+        "ledger_table": "agent_actions_ledger"
+      }
     }
   ]
 }
\ No newline at end of file
diff --git a/agents/registry/schema.json b/agents/registry/schema.json
index 2b4686bd..e19799fd 100644
--- a/agents/registry/schema.json
+++ b/agents/registry/schema.json
@@ -19,20 +19,20 @@
         "properties": {
           "id": {
             "type": "string",
-            "pattern": "^[a-z][a-z0-9_]*$"
+            "pattern": "^[a-z][a-z0-9_-]*$"
           },
           "name": { "type": "string" },
           "kind": {
             "type": "string",
             "description": "Honest classification: verified_agent (continuous loop + side effects), agent_candidate (has potential but not verified), workflow (multi-step orchestration), tool (single-purpose CLI), dormant (exists but broken/stub)",
-            "enum": ["verified_agent", "online_agent", "agent_candidate", "workflow", "tool", "dormant"]
+            "enum": ["verified_agent", "online_agent", "agent_candidate", "workflow", "tool", "dormant", "discovery", "service"]
           },
           "area": {
             "type": "string",
             "enum": [
               "security", "knowledge", "observability", "qa",
               "architecture", "design", "auth", "orchestration",
-              "governance", "infrastructure", "product"
+              "governance", "infrastructure", "product", "compliance", "intelligence"
             ]
           },
           "description": { "type": "string" },
diff --git a/agents/registry/validation.json b/agents/registry/validation.json
index a1015091..e28fb773 100644
--- a/agents/registry/validation.json
+++ b/agents/registry/validation.json
@@ -1,7 +1,7 @@
 {
   "version": "1.0.0",
   "description": "EGOS Agent Registry Validation Cache — Lightweight provenance for agent existence checks",
-  "lastValidated": "2026-04-14T11:58:32.817Z",
+  "lastValidated": "2026-06-01T12:29:51.500Z",
   "validator": "agent-validator",
   "validationSource": "/home/enio/egos/agents/registry/agents.json",
   "validationMethod": "4-point-check",
@@ -11,7 +11,7 @@
       "entrypoint": "agents/agents/ssot-auditor.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.812Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:c71a31e8835f208a"
     },
     {
@@ -19,7 +19,7 @@
       "entrypoint": "agents/agents/ssot-fixer.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.812Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:488ff353d749da35"
     },
     {
@@ -27,7 +27,7 @@
       "entrypoint": "agents/agents/drift-sentinel.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.812Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:9770892ade71a498"
     },
     {
@@ -35,7 +35,7 @@
       "entrypoint": "agents/agents/dep-auditor.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.812Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:083dd762de9abadd"
     },
     {
@@ -43,23 +43,15 @@
       "entrypoint": "agents/agents/archaeology-digger.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.812Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:d696b376c5309cf0"
     },
-    {
-      "id": "chatbot-compliance-checker",
-      "entrypoint": "agents/agents/chatbot-compliance-checker.ts",
-      "status": "dead",
-      "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.813Z",
-      "validationHash": "sha256:7189af2cdd3a52d0"
-    },
     {
       "id": "dead-code-detector",
       "entrypoint": "agents/agents/dead-code-detector.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.813Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:4ec409ab6413cfad"
     },
     {
@@ -67,7 +59,7 @@
       "entrypoint": "agents/agents/capability-drift-checker.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.813Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:e1c25035372bd585"
     },
     {
@@ -75,23 +67,15 @@
       "entrypoint": "agents/agents/context-tracker.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.813Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:71e7fe61db9396f2"
     },
-    {
-      "id": "gtm-harvester",
-      "entrypoint": "agents/agents/gtm-harvester.ts",
-      "status": "dead",
-      "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.814Z",
-      "validationHash": "sha256:a47ee8595ce2f968"
-    },
     {
       "id": "framework-benchmarker",
       "entrypoint": "agents/agents/framework-benchmarker.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.814Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:2d9144e7f73a33cb"
     },
     {
@@ -99,7 +83,7 @@
       "entrypoint": "agents/agents/mcp-router.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.814Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:92bacbb9f4eabb74"
     },
     {
@@ -107,7 +91,7 @@
       "entrypoint": "agents/agents/spec-router.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.814Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:45142120b298b8e4"
     },
     {
@@ -115,23 +99,23 @@
       "entrypoint": "agents/agents/gem-hunter.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.815Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:b0e34eebc697f7e5"
     },
     {
       "id": "kol-discovery",
       "entrypoint": "scripts/kol-discovery.ts",
-      "status": "active",
+      "status": "planned",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.815Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:a619408ee98f4412"
     },
     {
       "id": "gem-hunter-api",
       "entrypoint": "agents/api/gem-hunter-server.ts",
-      "status": "active",
+      "status": "planned",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.815Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:76fa584db9b165f4"
     },
     {
@@ -139,7 +123,7 @@
       "entrypoint": "agents/agents/agent-validator.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.815Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:d1d72515d5420673"
     },
     {
@@ -147,7 +131,7 @@
       "entrypoint": "agents/agents/wiki-compiler.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.815Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:fe4c85a0c3e5ea1d"
     },
     {
@@ -155,15 +139,15 @@
       "entrypoint": "agents/agents/doc-drift-sentinel.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.816Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:16679be56b645b37"
     },
     {
       "id": "egos-pr",
       "entrypoint": "scripts/create-pr.sh",
-      "status": "active",
+      "status": "planned",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.816Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:6ffb8b971ad235b2"
     },
     {
@@ -171,7 +155,7 @@
       "entrypoint": "agents/agents/article-writer.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.816Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:f00ffa358a213dac"
     },
     {
@@ -179,7 +163,7 @@
       "entrypoint": "agents/agents/doc-drift-verifier.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.817Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:a3e1c400ad53c70d"
     },
     {
@@ -187,7 +171,7 @@
       "entrypoint": "agents/agents/doc-drift-analyzer.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.817Z",
+      "verifiedAt": "2026-06-01T12:29:51.499Z",
       "validationHash": "sha256:466bd79da683b054"
     },
     {
@@ -195,16 +179,56 @@
       "entrypoint": "agents/agents/readme-syncer.ts",
       "status": "active",
       "exists": true,
-      "verifiedAt": "2026-04-14T11:58:32.817Z",
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
       "validationHash": "sha256:cfd373188c74f92f"
+    },
+    {
+      "id": "chatbot-manifest-aggregator",
+      "entrypoint": "agents/agents/chatbot-manifest-aggregator.ts",
+      "status": "active",
+      "exists": true,
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
+      "validationHash": "sha256:c4015fcc5bf469e7"
+    },
+    {
+      "id": "skill-candidate-extractor",
+      "entrypoint": "scripts/skill-candidate-extractor.ts",
+      "status": "active",
+      "exists": true,
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
+      "validationHash": "sha256:8bf291f4e75eb76b"
+    },
+    {
+      "id": "chatbot-compliance-checker",
+      "entrypoint": "agents/agents/chatbot-compliance-checker.ts",
+      "status": "active",
+      "exists": true,
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
+      "validationHash": "sha256:7189af2cdd3a52d0"
+    },
+    {
+      "id": "gtm-harvester",
+      "entrypoint": "agents/agents/gtm-harvester.ts",
+      "status": "active",
+      "exists": true,
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
+      "validationHash": "sha256:a47ee8595ce2f968"
+    },
+    {
+      "id": "capability-scanner",
+      "entrypoint": "agents/agents/capability-scanner.ts",
+      "status": "active",
+      "exists": true,
+      "verifiedAt": "2026-06-01T12:29:51.500Z",
+      "validationHash": "sha256:47da69bce68e6f92"
     }
   ],
   "stats": {
-    "total": 24,
-    "verified": 24,
+    "total": 27,
+    "verified": 27,
     "ghosts": 0,
-    "dead": 2,
+    "dead": 0,
     "orphanFiles": 0
   },
-  "globalHash": "sha256:67fc063b92783d4d"
+  "globalHash": "sha256:8fedc9a2b279c050"
 }
\ No newline at end of file
diff --git a/packages/mcp-bridge/src/index.ts b/packages/mcp-bridge/src/index.ts
index ad927aaa..fe985366 100644
--- a/packages/mcp-bridge/src/index.ts
+++ b/packages/mcp-bridge/src/index.ts
@@ -50,8 +50,9 @@ if (!MCP_CMD) {
 interface Session {
   id: string;
   proc: ChildProcess;
-  buf: Buffer[];
-  pending: Array<{ resolve: (data: Buffer) => void }>;
+  acc: string;                                    // partial-line accumulator (stdio is newline-delimited JSON)
+  ready: string[];                                // complete response lines awaiting a consumer
+  pending: Array<{ resolve: (data: string) => void }>;
   createdAt: number;
 }
 const sessions = new Map<string, Session>();
@@ -63,15 +64,20 @@ function spawnMcp(sessionId: string): Session {
     stdio: ["pipe", "pipe", "inherit"],
     env: { ...process.env },
   });
-  const session: Session = { id: sessionId, proc, buf: [], pending: [], createdAt: Date.now() };
+  const session: Session = { id: sessionId, proc, acc: "", ready: [], pending: [], createdAt: Date.now() };
   sessions.set(sessionId, session);
 
+  // stdio MCP transport is newline-delimited JSON — buffer by line, never by raw chunk
   proc.stdout?.on("data", (chunk: Buffer) => {
-    if (session.pending.length > 0) {
-      const { resolve } = session.pending.shift()!;
-      resolve(chunk);
-    } else {
-      session.buf.push(chunk);
+    session.acc += chunk.toString("utf8");
+    let nl: number;
+    while ((nl = session.acc.indexOf("\n")) >= 0) {
+      const line = session.acc.slice(0, nl).trim();
+      session.acc = session.acc.slice(nl + 1);
+      if (!line) continue;
+      const waiter = session.pending.shift();
+      if (waiter) waiter.resolve(line);
+      else session.ready.push(line);
     }
   });
 
@@ -86,17 +92,42 @@ function getOrCreate(sessionId: string): Session {
   return spawnMcp(sessionId);
 }
 
-async function proxyRequest(session: Session, body: Buffer): Promise<Buffer> {
-  return new Promise((resolve) => {
-    if (session.buf.length > 0) {
-      resolve(session.buf.shift()!);
-      return;
+// Forward a JSON-RPC request line to the subprocess and await its response line.
+// stdio MCP is newline-delimited — the body MUST be terminated with "\n" or the
+// child's line reader never completes (this was the silent-hang bug).
+async function proxyRequest(session: Session, body: Buffer): Promise<string> {
+  return new Promise((resolve, reject) => {
+    const ready = session.ready.shift();
+    const payload = body.toString("utf8").trim();
+    if (ready) {
+      // A buffered response was already waiting (shouldn't normally happen for
+      // a fresh request, but drain it rather than deadlock).
+      resolve(ready);
+    } else {
+      const timer = setTimeout(() => {
+        const i = session.pending.findIndex((p) => p.resolve === wrapped);
+        if (i >= 0) session.pending.splice(i, 1);
+        reject(new Error("MCP subprocess response timeout"));
+      }, 30000);
+      const wrapped = (line: string) => { clearTimeout(timer); resolve(line); };
+      session.pending.push({ resolve: wrapped });
     }
-    session.pending.push({ resolve });
-    session.proc.stdin?.write(body);
+    session.proc.stdin?.write(payload + "\n");
   });
 }
 
+// JSON-RPC notifications (no "id") and responses get no reply from the server —
+// ChatGPT POSTs notifications/initialized; we must ack 202 and not wait.
+function isNotification(body: Buffer): boolean {
+  try {
+    const msg = JSON.parse(body.toString("utf8"));
+    if (Array.isArray(msg)) return msg.every((m) => m && m.id === undefined);
+    return msg && typeof msg === "object" && msg.id === undefined && typeof msg.method === "string";
+  } catch {
+    return false;
+  }
+}
+
 // ── Auth ────────────────────────────────────────────────────────────────────
 function validateAuth(req: IncomingMessage): boolean {
   if (!TOKEN) return true; // dev mode — no auth
@@ -183,6 +214,16 @@ const server = createServer(async (req: IncomingMessage, res: ServerResponse) =>
     const session = getOrCreate(sessionId);
     res.setHeader("Mcp-Session-Id", sessionId);
 
+    // Notifications/responses expect no reply (ChatGPT sends notifications/initialized).
+    // Forward to the child so it updates state, then ack 202 without awaiting output.
+    if (isNotification(body)) {
+      session.proc.stdin?.write(body.toString("utf8").trim() + "\n");
+      res.writeHead(202);
+      res.end();
+      await audit({ method: req.method ?? "?", status: 202, session_id: sessionId });
+      return;
+    }
+
     if (wantStream) {
       // SSE stream (legacy compat)
       res.writeHead(200, {

exec
/bin/bash -lc "sed -n '1,280p' packages/mcp-bridge/src/index.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * @egos/mcp-bridge v0.1.0 (MCP-F3-001)
 *
 * HTTP Bridge para MCPs EGOS — expõe servers stdio via Streamable HTTP (MCP spec 2025-03-26).
 *
 * Uso:
 *   MCP_NAME=governance MCP_CMD="bun packages/mcp-governance/src/index.ts" bun packages/mcp-bridge/src/index.ts
 *
 * Variáveis de ambiente:
 *   MCP_NAME        — nome do MCP (ex: governance, memory, ops)
 *   MCP_CMD         — comando para iniciar o MCP server stdio
 *   MCP_PORT        — porta HTTP (default: 7001)
 *   MCP_HOST        — host (default: localhost — atenção: produção usa Caddy)
 *   EGOS_MCP_TOKEN  — bearer token para auth (production)
 *   EGOS_TENANT_ID  — tenant ID para audit log
 *
 * Arquitetura (MCP spec 2025-03-26 Streamable HTTP):
 *   Caddy → HTTPS → mcp-bridge → subprocess stdio → MCP server
 *
 * Security:
 *   - Bearer token validation (EGOS_MCP_TOKEN obrigatório em produção)
 *   - Origin header validation (DNS rebinding mitigation)
 *   - Rate limit: 100 req/min/IP via Caddy (não aqui)
 *   - Audit log via Supabase (EGOS_SUPABASE_URL + EGOS_SUPABASE_KEY se configurados)
 *
 * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md §1 + §3 + docs/governance/MCP_RISKS.md
 */

import { spawn, type ChildProcess } from "child_process";
import { createServer, type IncomingMessage, type ServerResponse } from "http";

const MCP_NAME = process.env.MCP_NAME ?? "unknown";
const MCP_CMD = process.env.MCP_CMD;
const PORT = parseInt(process.env.MCP_PORT ?? "7001");
const HOST = process.env.MCP_HOST ?? "localhost";
const TOKEN = process.env.EGOS_MCP_TOKEN;
const TENANT_ID = process.env.EGOS_TENANT_ID ?? "kernel";
const ALLOWED_ORIGINS = (process.env.EGOS_MCP_ALLOWED_ORIGINS ?? "")
  .split(",")
  .map((o) => o.trim())
  .filter(Boolean);

if (!MCP_CMD) {
  console.error("MCP_CMD not set. Example: MCP_CMD='bun packages/mcp-governance/src/index.ts'");
  process.exit(1);
}

// ── Subprocess pool (one per session) ──────────────────────────────────────
interface Session {
  id: string;
  proc: ChildProcess;
  acc: string;                                    // partial-line accumulator (stdio is newline-delimited JSON)
  ready: string[];                                // complete response lines awaiting a consumer
  pending: Array<{ resolve: (data: string) => void }>;
  createdAt: number;
}
const sessions = new Map<string, Session>();
const SESSION_TTL_MS = 30 * 60 * 1000; // 30min

function spawnMcp(sessionId: string): Session {
  const [cmd, ...args] = MCP_CMD!.split(" ");
  const proc = spawn(cmd, args, {
    stdio: ["pipe", "pipe", "inherit"],
    env: { ...process.env },
  });
  const session: Session = { id: sessionId, proc, acc: "", ready: [], pending: [], createdAt: Date.now() };
  sessions.set(sessionId, session);

  // stdio MCP transport is newline-delimited JSON — buffer by line, never by raw chunk
  proc.stdout?.on("data", (chunk: Buffer) => {
    session.acc += chunk.toString("utf8");
    let nl: number;
    while ((nl = session.acc.indexOf("\n")) >= 0) {
      const line = session.acc.slice(0, nl).trim();
      session.acc = session.acc.slice(nl + 1);
      if (!line) continue;
      const waiter = session.pending.shift();
      if (waiter) waiter.resolve(line);
      else session.ready.push(line);
    }
  });

  proc.on("exit", () => sessions.delete(sessionId));
  return session;
}

function getOrCreate(sessionId: string): Session {
  const existing = sessions.get(sessionId);
  if (existing && Date.now() - existing.createdAt < SESSION_TTL_MS) return existing;
  existing?.proc.kill();
  return spawnMcp(sessionId);
}

// Forward a JSON-RPC request line to the subprocess and await its response line.
// stdio MCP is newline-delimited — the body MUST be terminated with "\n" or the
// child's line reader never completes (this was the silent-hang bug).
async function proxyRequest(session: Session, body: Buffer): Promise<string> {
  return new Promise((resolve, reject) => {
    const ready = session.ready.shift();
    const payload = body.toString("utf8").trim();
    if (ready) {
      // A buffered response was already waiting (shouldn't normally happen for
      // a fresh request, but drain it rather than deadlock).
      resolve(ready);
    } else {
      const timer = setTimeout(() => {
        const i = session.pending.findIndex((p) => p.resolve === wrapped);
        if (i >= 0) session.pending.splice(i, 1);
        reject(new Error("MCP subprocess response timeout"));
      }, 30000);
      const wrapped = (line: string) => { clearTimeout(timer); resolve(line); };
      session.pending.push({ resolve: wrapped });
    }
    session.proc.stdin?.write(payload + "\n");
  });
}

// JSON-RPC notifications (no "id") and responses get no reply from the server —
// ChatGPT POSTs notifications/initialized; we must ack 202 and not wait.
function isNotification(body: Buffer): boolean {
  try {
    const msg = JSON.parse(body.toString("utf8"));
    if (Array.isArray(msg)) return msg.every((m) => m && m.id === undefined);
    return msg && typeof msg === "object" && msg.id === undefined && typeof msg.method === "string";
  } catch {
    return false;
  }
}

// ── Auth ────────────────────────────────────────────────────────────────────
function validateAuth(req: IncomingMessage): boolean {
  if (!TOKEN) return true; // dev mode — no auth
  const authHeader = req.headers["authorization"] ?? "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : "";
  return token === TOKEN;
}

function validateOrigin(req: IncomingMessage): boolean {
  if (ALLOWED_ORIGINS.length === 0) return true;
  const origin = req.headers["origin"] ?? "";
  return ALLOWED_ORIGINS.some((o) => origin === o || origin.endsWith(o));
}

// ── Audit log (lightweight — Supabase optional) ────────────────────────────
async function audit(event: { method: string; status: number; session_id: string }) {
  const supaUrl = process.env.EGOS_SUPABASE_URL;
  const supaKey = process.env.EGOS_SUPABASE_KEY;
  if (!supaUrl || !supaKey) return;
  try {
    await fetch(`${supaUrl}/rest/v1/mcp_audit_events`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "apikey": supaKey, "Authorization": `Bearer ${supaKey}` },
      body: JSON.stringify({
        ts: new Date().toISOString(),
        mcp_name: MCP_NAME,
        tenant_id: TENANT_ID,
        session_id: event.session_id,
        method: event.method,
        result: event.status < 400 ? "success" : "error",
      }),
      signal: AbortSignal.timeout(3000),
    });
  } catch {} // non-blocking
}

// ── HTTP Server (Streamable HTTP MCP 2025-03-26) ───────────────────────────
const server = createServer(async (req: IncomingMessage, res: ServerResponse) => {
  // Origin validation (DNS rebinding — MCP_RISKS §R3)
  if (!validateOrigin(req)) {
    res.writeHead(403, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: "Origin not allowed" }));
    return;
  }

  // Auth
  if (!validateAuth(req)) {
    res.writeHead(401, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: "Unauthorized — missing or invalid Bearer token" }));
    return;
  }

  // CORS headers
  res.setHeader("Access-Control-Allow-Origin", req.headers["origin"] ?? "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type, Mcp-Session-Id");

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
    return;
  }

  // Session ID (MCP 2025-03-26 spec)
  const sessionId = (req.headers["mcp-session-id"] as string) ?? `${MCP_NAME}-${Date.now()}`;

  // Health check (Caddy readyz probe)
  if (req.url === "/healthz" || req.url === "/readyz") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true, mcp: MCP_NAME, sessions: sessions.size }));
    return;
  }

  // Streamable HTTP: accept JSON or event-stream
  const accept = req.headers["accept"] ?? "";
  const wantStream = accept.includes("text/event-stream");

  // Read request body
  const chunks: Buffer[] = [];
  for await (const chunk of req) chunks.push(chunk);
  const body = Buffer.concat(chunks);

  try {
    const session = getOrCreate(sessionId);
    res.setHeader("Mcp-Session-Id", sessionId);

    // Notifications/responses expect no reply (ChatGPT sends notifications/initialized).
    // Forward to the child so it updates state, then ack 202 without awaiting output.
    if (isNotification(body)) {
      session.proc.stdin?.write(body.toString("utf8").trim() + "\n");
      res.writeHead(202);
      res.end();
      await audit({ method: req.method ?? "?", status: 202, session_id: sessionId });
      return;
    }

    if (wantStream) {
      // SSE stream (legacy compat)
      res.writeHead(200, {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
      });
      const response = await proxyRequest(session, body);
      res.write(`data: ${response.toString()}\n\n`);
      res.end();
    } else {
      // JSON response (Streamable HTTP default)
      const response = await proxyRequest(session, body);
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(response);
    }
    await audit({ method: req.method ?? "?", status: 200, session_id: sessionId });
  } catch (err) {
    res.writeHead(500, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: (err as Error).message }));
    await audit({ method: req.method ?? "?", status: 500, session_id: sessionId });
  }
});

// ── Cleanup expired sessions ────────────────────────────────────────────────
setInterval(() => {
  const now = Date.now();
  for (const [id, session] of sessions) {
    if (now - session.createdAt > SESSION_TTL_MS) {
      session.proc.kill();
      sessions.delete(id);
    }
  }
}, 5 * 60 * 1000);

// ── Kill-switch (EGOS_MCP_GLOBAL_PAUSE) ────────────────────────────────────
// MCP-F3-007 — export a global pause via env var check on each request
// Already handled: if EGOS_MCP_GLOBAL_PAUSE=1, pm2 should stop this process
// The pm2 ecosystem.config.js will check this env on restart.

server.listen(PORT, HOST, () => {
  console.error(`[mcp-bridge] ${MCP_NAME} listening on http://${HOST}:${PORT} (Streamable HTTP)`);
  console.error(`[mcp-bridge] subprocess: ${MCP_CMD}`);
  console.error(`[mcp-bridge] auth: ${TOKEN ? "bearer token enabled" : "disabled (dev mode)"}`);
  console.error(`[mcp-bridge] tenant: ${TENANT_ID}`);
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.error("[mcp-bridge] SIGTERM — cleaning up sessions");
  for (const session of sessions.values()) session.proc.kill();
  server.close(() => process.exit(0));
});

exec
/bin/bash -lc "node -e \"const j=require('./agents/registry/agents.json');const ids=j.agents.map(a=>a.id);const d=ids.filter((x,i)=>ids.indexOf(x)"'!==i);console.log('"'dups',d);\"" in /home/enio/egos
 succeeded in 0ms:
dups []

exec
/bin/bash -lc "nl -ba packages/mcp-bridge/src/index.ts | sed -n '95,135p'" in /home/enio/egos
 succeeded in 0ms:
    95	// Forward a JSON-RPC request line to the subprocess and await its response line.
    96	// stdio MCP is newline-delimited — the body MUST be terminated with "\n" or the
    97	// child's line reader never completes (this was the silent-hang bug).
    98	async function proxyRequest(session: Session, body: Buffer): Promise<string> {
    99	  return new Promise((resolve, reject) => {
   100	    const ready = session.ready.shift();
   101	    const payload = body.toString("utf8").trim();
   102	    if (ready) {
   103	      // A buffered response was already waiting (shouldn't normally happen for
   104	      // a fresh request, but drain it rather than deadlock).
   105	      resolve(ready);
   106	    } else {
   107	      const timer = setTimeout(() => {
   108	        const i = session.pending.findIndex((p) => p.resolve === wrapped);
   109	        if (i >= 0) session.pending.splice(i, 1);
   110	        reject(new Error("MCP subprocess response timeout"));
   111	      }, 30000);
   112	      const wrapped = (line: string) => { clearTimeout(timer); resolve(line); };
   113	      session.pending.push({ resolve: wrapped });
   114	    }
   115	    session.proc.stdin?.write(payload + "\n");
   116	  });
   117	}
   118	
   119	// JSON-RPC notifications (no "id") and responses get no reply from the server —
   120	// ChatGPT POSTs notifications/initialized; we must ack 202 and not wait.
   121	function isNotification(body: Buffer): boolean {
   122	  try {
   123	    const msg = JSON.parse(body.toString("utf8"));
   124	    if (Array.isArray(msg)) return msg.every((m) => m && m.id === undefined);
   125	    return msg && typeof msg === "object" && msg.id === undefined && typeof msg.method === "string";
   126	  } catch {
   127	    return false;
   128	  }
   129	}
   130	
   131	// ── Auth ────────────────────────────────────────────────────────────────────
   132	function validateAuth(req: IncomingMessage): boolean {
   133	  if (!TOKEN) return true; // dev mode — no auth
   134	  const authHeader = req.headers["authorization"] ?? "";
   135	  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : "";

codex
The mcp-bridge change introduces a response correlation bug in `proxyRequest` that can return stale output while dispatching a new request, breaking JSON-RPC correctness under buffered-output conditions.

Review comment:

- [P1] Wait for current request response even when buffer is non-empty — /home/enio/egos/packages/mcp-bridge/src/index.ts:102-106
  If `session.ready` already contains a line, `proxyRequest` resolves immediately with that stale line but still writes the new request to stdin, which shifts request/response pairing by one and can return the wrong JSON-RPC payload to the caller. This occurs whenever any unsolicited or previously buffered line exists (for example after timing or ordering anomalies), and then every subsequent request can be mismatched until buffers realign.
The mcp-bridge change introduces a response correlation bug in `proxyRequest` that can return stale output while dispatching a new request, breaking JSON-RPC correctness under buffered-output conditions.

Review comment:

- [P1] Wait for current request response even when buffer is non-empty — /home/enio/egos/packages/mcp-bridge/src/index.ts:102-106
  If `session.ready` already contains a line, `proxyRequest` resolves immediately with that stale line but still writes the new request to stdin, which shifts request/response pairing by one and can return the wrong JSON-RPC payload to the caller. This occurs whenever any unsolicited or previously buffered line exists (for example after timing or ordering anomalies), and then every subsequent request can be mismatched until buffers realign.
```
