# Codex Local Review — 2026-06-01T13:16:48Z

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
session id: 019e8354-6d00-7711-918d-3b770a4a47f4
--------
user
changes against 'HEAD~3'
2026-06-01T13:16:49.875431Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:16:49.875541Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:16:54.741862Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:16:54.998944Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:16:55.340379Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:16:55.678250Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:16:56.167787Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:16:57.138600Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:16:58.815596Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:17:02.178475Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 6ebe8b2218b41d8a91299f706e80967d8358dc9d' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index a74c6da2..f207eed6 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -508,11 +508,23 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
+## 🎓 CURSOS ↔ FRAMEWORK ↔ GOVERNO — Enio 2026-06-01
+
+> Tese: curso = ponte framework→governo + magistério (vetor seguro PCMG). Princípio "método aberto + dado soberano/local". SSOT `docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md` + memory `project_courses_framework_gov_thesis`. Red Zone: posições/pitch de governo = corte do Enio.
+- [/] **COURSE-MAP-001** [P1] `research` — Sonnet mapeando artefato EGOS → módulo de curso (OVM + Ciber+IA+LGPD-polícia) + outline de módulos + gaps. Não tocar dado real de caso (restrito por natureza).
+- [ ] **COURSE-LGPD-001** [P1] `redzone` — Curso "Ciber+IA+LGPD para polícia": montar a partir do mapa (Guard Brasil → não-comprometer-dados; Mac Studio → modelo próprio; MCPs governados → até-onde-ir). Posições de "até onde ir" + proposta de governo = corte do Enio.
+- [ ] **COURSE-GOV-PITCH-001** [P2] `redzone` — Proposta pro governo (polícia roda modelo próprio local/soberano + framework aberto auditável). Deriva do curso. HITL — nada de pitch público sem corte do Enio.
+
 ### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
 > Ref: https://developers.openai.com/apps-sdk · Conector custom do ChatGPT = Server URL (SSE) + Auth (OAuth / Sem-auth / Mista). `mcp-g-pecas` já rodou HTTPS-live no ChatGPT → caminho provado. Objetivo: validar uso real dos MCPs no ChatGPT.
+> **✅ VALIDADO 2026-06-01:** `eval-runner` conectou no ChatGPT (URL `https://mcp.egos.ia.br/eval-runner/mcp`, sem-auth, Developer Mode). 6 tools carregadas. Dois bugs achados+consertados: (1) bridge stdio sem `\n` → travava (SHA `ae4da0c0`); (2) eval-runner via 0 CBCs no VPS — REPO_ROOT resolvia `/opt/` em vez do repo → adicionado `EGOS_REPO_ROOT` env + dados framework sincronizados p/ `/opt/egos-data` + fix do falso `migration_pct:100%`. Agora vê 79 CBCs reais (`migration_pct:91.9%`). ChatGPT é stateless (re-inicializa cada call) + não tem campo Bearer (só OAuth/sem-auth/mista) — por isso g-pecas falhou no print do Enio.
 - [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
 - [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
-- [ ] **MCP-SEC-001** [P0] `redzone` — **Achado 2026-06-01:** todos os bridges RED (`governance`/`knowledge`/`memory`/`security`/`ops`/`observability`/`browser-automation`) estão roteados em `mcp.egos.ia.br/*` no Caddy SEM auth, e os bridges rodam auth-disabled (dev mode). Hoje só não vazam porque rodavam o código QUEBRADO; o fix `ae4da0c0` está no arquivo compartilhado → **se qualquer RED reiniciar, vaza kernel sem-auth**. NÃO reiniciar os RED. Antes de qualquer deploy: setar `EGOS_MCP_TOKEN` nos RED OU remover rotas Caddy OU basic-auth. Corte do Enio + review Codex (= MCP-BRIDGE-003).
+- [ ] **MCP-SEC-001** [P1] `prime` — **REFRAME transparência radical (Enio 2026-06-01, `feedback_radical_transparency`):** conteúdo do framework é LIVRE → expor sem auth é OK. O gate NÃO é "é do kernel?", é "ajuda a atacar a máquina OU é dado restrito por natureza?". Classificação correta (bridges `mcp.egos.ia.br/*`, hoje auth-disabled):
+  - ✅ **Livres (pode no ChatGPT):** `eval-runner`, `skills-registry`, `governance` (TASKS/registry/SSOT = framework aberto).
+  - 🟡 **Escopar:** `knowledge` — docs do framework livres, MAS bloquear dados intelink/cliente/PII (filtro tenant/namespace).
+  - 🔴 **Proteger (auth/de-route):** `ops`, `observability`, `browser-automation` (atacam a MÁQUINA), `memory` (pessoal/PCMG), `security` (resultados PII).
+  Ação: `EGOS_MCP_TOKEN` só nos 🔴 + escopo tenant no `knowledge`; os ✅ ficam livres. NÃO reiniciar os 🔴 sem auth antes (fix `ae4da0c0` no arquivo compartilhado os exporia).
 
 ---
 
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
diff --git a/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
new file mode 100644
index 00000000..0d84772d
--- /dev/null
+++ b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
@@ -0,0 +1,53 @@
+# Cursos ↔ Framework ↔ Governo — a tese que amarra tudo
+
+> **Status:** síntese 2026-06-01 (Prime) · **Red Zone** (contexto policial + posições de governo + estatuto de servidor ativo → corte do Enio nas POSIÇÕES; estrutura é livre)
+> **Liga:** [[feedback_radical_transparency]], `ENIO_CURRICULUM_POSITIONING.md`, `MAC_STUDIO_LOCAL_AI.md`, `CAREER_FIT_STUDY.md` (F1), [[project_egos_courses_repo]].
+
+---
+
+## A tese em uma frase
+
+**O curso é a ponte legal entre o framework EGOS e o governo** — e o vetor de monetização seguro (magistério) para um policial em atividade. Tudo que construímos no dia a dia é, ao mesmo tempo, **prova** e **material didático**.
+
+## As 3 camadas (e como se conectam)
+
+### 1. FRAMEWORK (o que construímos) = prova + material de aula
+Cada artefato vira um módulo de curso:
+| Artefato EGOS | Vira o módulo |
+|---|---|
+| **Guard Brasil** (detecção PII/LGPD) | "Usar IA **sem comprometer os dados**" |
+| **Mac Studio / modelo local / soberania** | "Rodar o **modelo próprio da polícia**" |
+| **MCPs governados + auditabilidade + transparência radical** | "**Até onde ir** / governança / confiança provada" |
+| **Resolver Doctrine + evidence-first** | Método (caos→clareza, decisão auditável) |
+| **eval-runner / MCP no ChatGPT (validado hoje)** | Demo vivo: o framework funcionando na prática |
+
+### 2. CURSO (magistério — vetor seguro do policial ativo)
+- **OVM** (operacional — `/home/enio/policia/ovm-core`)
+- **Ciber + IA + LGPD para polícia** (o estratégico): como usar IA sem comprometer dados, **até onde ir**, e a opinião do Enio de como deveria ser.
+
+### 3. GOVERNO (o endgame de distribuição)
+O argumento do curso **É** a proposta pro governo: a polícia deve rodar o **próprio modelo** (Mac Studio, local, soberano), usar IA sem mandar dado sensível pra LLM externa, governado por um framework **aberto e auditável**. O curso ensina; a proposta vende como política.
+
+---
+
+## O princípio unificador (a virada da transparência radical de hoje deixa afiado)
+
+> **Método/framework = ABERTO, livre, auditável** (ensina-se em público; transparência constrói confiança).
+> **Dado (policial/pessoal/caso) = SOBERANO, local, nunca sai do prédio** (Mac Studio, modelo próprio).
+
+Isso É a resposta a *"como usar IA sem comprometer os dados"*: **separar o método aberto do dado soberano.** Essa frase é simultaneamente:
+- a espinha do **curso de ciber+IA+LGPD para polícia**,
+- a **recomendação de política** pro governo,
+- e a aplicação direta do corte de 2026-06-01 (proteger só máquina + dado-por-natureza; o resto é livre).
+
+## Autoridade pra ensinar (por que o Enio, e não outro)
+Currículo **investigador-arquiteto** (`ENIO_CURRICULUM_POSITIONING.md`): 16 anos de investigação + constrói a IA governada. Quem ensina LGPD-para-polícia tem que ter os dois lados — investigação real + arquitetura de IA auditável. Esse é o ativo raro (track F1).
+
+## Guardrails (Red Zone — corte do Enio)
+- Posições de "até onde ir" e a proposta de política pro governo = **opinião do Enio**, não auto-gero. Estrutura é livre; conteúdo de posição precisa do corte dele.
+- Estatuto PCMG ativo: curso = magistério (esporádico, consulta Corregedoria); não-comércio, não sócio-gerente. Ver `CAREER_FIT_STUDY §0.1`.
+- Dado real de caso (`/home/enio/policia/casos`, `projetoDHPP`) = restrito por natureza — nunca vira material público nem entra em LLM externa. É o próprio exemplo do que o curso ensina a proteger.
+
+---
+
+*Origem: pergunta do Enio 2026-06-01 ("onde tudo isso entra nos cursos"). Mapa módulo-a-módulo: task COURSE-MAP-001 (Sonnet).*
diff --git a/packages/mcp-eval-runner/src/index.ts b/packages/mcp-eval-runner/src/index.ts
index 8070d856..a0473679 100644
--- a/packages/mcp-eval-runner/src/index.ts
+++ b/packages/mcp-eval-runner/src/index.ts
@@ -35,7 +35,9 @@ import { runSuite, type MCPEvalSuite } from "@egos/eval-runner/mcp-runner";
 
 // ── Paths ──────────────────────────────────────────────────────────────────
 const __dir = dirname(fileURLToPath(import.meta.url));
-const REPO_ROOT = join(__dir, "../../..");
+// EGOS_REPO_ROOT lets the deployed bridge (e.g. /opt/egos-mcp/eval-runner) point at the
+// real framework data dir — "../../.." only resolves to the repo root in the repo layout.
+const REPO_ROOT = process.env.EGOS_REPO_ROOT ?? join(__dir, "../../..");
 const CBC_DIR = join(REPO_ROOT, "docs", "capabilities");
 const CBC_SCHEMA_PATH = join(CBC_DIR, "_SCHEMA.json");
 const EVAL_DIR = join(REPO_ROOT, "tests", "eval", "capabilities");
@@ -393,7 +395,14 @@ server.registerTool(
     return trackMcpTool(MCP_NAME, "audit_drift", async () => {
       const legacyCount = countLegacyNs();
       const cbcCount = listCbcFiles().length;
-      const migrationPct = legacyCount > 0 ? ((cbcCount / legacyCount) * 100).toFixed(1) : "100.0";
+      // No data ≠ migration complete. Distinguish empty registry from a real 100%.
+      const noData = legacyCount === 0 && cbcCount === 0;
+      const migrationPct = legacyCount > 0 ? ((cbcCount / legacyCount) * 100).toFixed(1) : noData ? "n/a" : "100.0";
+      const recommendation = noData
+        ? "No data: 0 legacy sections AND 0 CBC files found. Check EGOS_REPO_ROOT / data path — likely not pointing at the real registry."
+        : cbcCount < legacyCount * 0.5
+          ? "Migration <50% — execute MCP-DECISION-005 (orgânico ou batch)"
+          : "Migration on track";
 
       return {
         content: [
@@ -403,12 +412,9 @@ server.registerTool(
               {
                 legacy_sections: legacyCount,
                 cbc_files: cbcCount,
-                migration_pct: `${migrationPct}%`,
+                migration_pct: noData ? "n/a" : `${migrationPct}%`,
                 drift_report: "docs/capabilities/_drift-report.md",
-                recommendation:
-                  cbcCount < legacyCount * 0.5
-                    ? "Migration <50% — execute MCP-DECISION-005 (orgânico ou batch)"
-                    : "Migration on track",
+                recommendation,
               },
               null,
               2

exec
/bin/bash -lc 'git diff --name-only 6ebe8b2218b41d8a91299f706e80967d8358dc9d' in /home/enio/egos
 succeeded in 0ms:
TASKS.md
agents/agents/article-writer.ts
agents/agents/capability-scanner.ts
agents/agents/chatbot-manifest-aggregator.ts
agents/agents/doc-drift-sentinel.ts
agents/agents/doc-drift-verifier.ts
agents/agents/readme-syncer.ts
agents/agents/wiki-compiler.ts
agents/registry/agents.json
agents/registry/schema.json
agents/registry/validation.json
docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
packages/mcp-eval-runner/src/index.ts

exec
/bin/bash -lc 'jq empty agents/registry/agents.json && echo OK' in /home/enio/egos
 succeeded in 0ms:
OK

exec
/bin/bash -lc "sed -n '760,940p' agents/registry/agents.json" in /home/enio/egos
 succeeded in 0ms:
      "signature": {
        "enabled": false,
        "public_key": null,
        "algorithm": "ed25519",
        "ledger_table": "agent_actions_ledger"
      }
    },
    {
      "id": "readme-syncer",
      "name": "README Syncer",
      "description": "Syncs README claims against .egos-manifest.yaml. Part of Doc-Drift Shield \u2014 keeps README numbers in sync with manifest-verified values.",
      "area": "governance",
      "entrypoint": "agents/agents/readme-syncer.ts",
      "runtime": "bun",
      "status": "active",
      "triggers": [
        "manual",
        "pre_commit"
      ],
      "dry_run_support": true,
      "side_effects": [
        "fs_write"
      ],
      "risk_level": "T1",
      "approval_level": "L0",
      "run_modes": [
        "dry_run",
        "execute"
      ],
      "owner": "enioxt",
      "created_at": "2026-04-07",
      "runtime_proof": "bun agents/agents/readme-syncer.ts --dry",
      "telemetry_source": "stdout",
      "cost_source": "none",
      "last_duration_ms": null,
      "loop_mechanism": "none",
      "migrated_from": "new",
      "signature": {
        "enabled": false,
        "public_key": null,
        "algorithm": "ed25519",
        "ledger_table": "agent_actions_ledger"
      }
    },
    {
      "id": "chatbot-manifest-aggregator",
      "name": "Chatbot Manifest Aggregator",
      "kind": "tool",
      "description": "Aggregates chatbot manifests and populates the AUTO-GEN compliance matrix in CHATBOT_SSOT.md",
      "area": "compliance",
      "entrypoint": "agents/agents/chatbot-manifest-aggregator.ts",
      "run_modes": ["dry_run", "execute"],
      "triggers": ["manual"],
      "tools_allowed": [],
      "risk_level": "T0",
      "status": "active",
      "owner": "enioxt",
      "runtime_proof": "bun agents/agents/chatbot-manifest-aggregator.ts --dry-run",
      "telemetry_source": "stdout",
      "cost_source": "none",
      "side_effects": ["fs_write"],
      "approval_level": "L0",
      "_reconcile_note": "AGENTS-JSON-RECONCILE-001 2026-05-27 — backfilled missing fields (name, entrypoint, kind, area); file existed all along at agents/agents/chatbot-manifest-aggregator.ts"
    },
    {
      "id": "skill-candidate-extractor",
      "name": "Skill Candidate Extractor",
      "kind": "tool",
      "description": "Mines agents/.logs/*.jsonl events ➔ clusters by (topic, source) ➔ generates docs/_drafts/skill-candidates/*.md for HITL approval. EGOS equivalent of Hivemind trace-to-skill pipeline.",
      "area": "intelligence",
      "entrypoint": "scripts/skill-candidate-extractor.ts",
      "run_modes": [
        "dry_run",
        "execute"
      ],
      "triggers": [
        "manual",
        "cron"
      ],
      "tools_allowed": [],
      "risk_level": "T0",
      "status": "active",
      "owner": "enioxt",
      "runtime_proof": "bun scripts/skill-candidate-extractor.ts --dry",
      "telemetry_source": "stdout",
      "cost_source": "local",
      "last_duration_ms": 500,
      "loop_mechanism": "cron",
      "schedule": "0 9 * * 1",
      "side_effects": [
        "fs_write"
      ],
      "approval_level": "L0",
      "signature": {
        "enabled": false,
        "public_key": null,
        "algorithm": "ed25519",
        "ledger_table": "agent_actions_ledger"
      }
    },
    {
      "id": "chatbot-compliance-checker",
      "name": "Chatbot Compliance Checker",
      "kind": "tool",
      "description": "Scans codebase to evaluate compliance against Modular Prompt, ATRiAN, and PII policies inside CHATBOT_SSOT.md",
      "area": "compliance",
      "entrypoint": "agents/agents/chatbot-compliance-checker.ts",
      "run_modes": [
        "dry_run",
        "execute"
      ],
      "triggers": [
        "manual"
      ],
      "tools_allowed": [],
      "risk_level": "T0",
      "status": "active",
      "owner": "enioxt",
      "runtime_proof": "bun agents/agents/chatbot-compliance-checker.ts --dry",
      "telemetry_source": "stdout",
      "cost_source": "none",
      "side_effects": [
        "fs_write"
      ],
      "approval_level": "L0",
      "signature": {
        "enabled": false,
        "public_key": null,
        "algorithm": "ed25519",
        "ledger_table": "agent_actions_ledger"
      }
    },
    {
      "id": "gtm-harvester",
      "name": "GTM Harvester",
      "kind": "tool",
      "description": "Scans public GitHub repositories for market/GTM strategy artifacts and returns a distilled map of reusable business execution signals",
      "area": "intelligence",
      "entrypoint": "agents/agents/gtm-harvester.ts",
      "run_modes": [
        "dry_run",
        "execute"
      ],
      "triggers": [
        "manual"
      ],
      "tools_allowed": [],
      "risk_level": "T0",
      "status": "active",
      "owner": "enioxt",
      "runtime_proof": "bun agents/agents/gtm-harvester.ts --dry",
      "telemetry_source": "stdout",
      "cost_source": "none",
      "side_effects": [],
      "approval_level": "L0",
      "signature": {
        "enabled": false,
        "public_key": null,
        "algorithm": "ed25519",
        "ledger_table": "agent_actions_ledger"
      }
    },
    {
      "id": "capability-scanner",
      "name": "Capability Scanner",
      "kind": "tool",
      "description": "Analyzes commit diffs to classify and extract new capabilities, proposing or applying them to CAPABILITY_REGISTRY.md",
      "area": "governance",
      "entrypoint": "agents/agents/capability-scanner.ts",
      "run_modes": [
        "dry_run",
        "execute"
      ],
      "triggers": [
        "manual",
        "pre_commit"
      ],
      "tools_allowed": [],
      "risk_level": "T1",
      "status": "active",
      "owner": "enioxt",

exec
/bin/bash -lc "sed -n '660,760p' agents/agents/doc-drift-verifier.ts" in /home/enio/egos
 succeeded in 0ms:

if (opts.all) {
  for (const repo of KNOWN_REPOS) {
    const p = join(repo, ".egos-manifest.yaml");
    if (existsSync(p)) manifestPaths.push(p);
  }
  if (manifestPaths.length === 0) {
    console.error("[doc-drift] No manifests found in known repos.");
    process.exit(0);
  }
} else if (opts.repo) {
  const p = join(opts.repo, ".egos-manifest.yaml");
  if (!existsSync(p)) {
    console.error(`[doc-drift] ERROR: No manifest at ${p}`);
    process.exit(2);
  }
  manifestPaths.push(p);
} else if (opts.manifest) {
  if (!existsSync(opts.manifest)) {
    console.error(`[doc-drift] ERROR: Manifest not found: ${opts.manifest}`);
    process.exit(2);
  }
  manifestPaths.push(opts.manifest);
} else {
  // Auto-detect in CWD
  const cwd = process.cwd();
  const p = join(cwd, ".egos-manifest.yaml");
  if (!existsSync(p)) {
    console.error(`[doc-drift] No manifest found in ${cwd}. Use --manifest, --repo, or --all.`);
    process.exit(0);
  }
  manifestPaths.push(p);
}

// Run verifications
const reports: VerificationReport[] = [];
for (const manifestPath of manifestPaths) {
  const report = await verifyManifest(manifestPath, { failOnDrift: opts.failOnDrift });
  reports.push(report);
}

// Output
if (opts.json) {
  const output = reports.length === 1 ? reports[0] : reports;
  process.stdout.write(JSON.stringify(output, null, 2) + "\n");
} else if (opts.markdown) {
  for (const r of reports) {
    process.stdout.write(formatMarkdown(r) + "\n\n---\n\n");
  }
} else {
  for (const r of reports) {
    printHuman(r);
  }
}

// Save report to docs/jobs/
const EGOS_ROOT = join(HOME, "egos");
try {
  const jobsDir = join(EGOS_ROOT, "docs/jobs");
  mkdirSync(jobsDir, { recursive: true });
  const date = new Date().toISOString().slice(0, 10);
  const reportPath = join(jobsDir, `${date}-doc-drift-verifier.json`);
  writeFileSync(reportPath, JSON.stringify(reports.length === 1 ? reports[0] : reports, null, 2));
} catch {
  // Non-fatal: may not have write access to egos root from other repos
}

// HQ-EVENTS-002: log to egos_agent_events for HQ dashboard
try {
  const { logAgentEvent } = await import("../../scripts/lib/agent-event.ts");
  const worstExit = Math.max(...reports.map((r) => r.exit_code));
  await logAgentEvent({
    source: "doc-drift-verifier",
    event_type: worstExit === 0 ? "completed" : "drift_detected",
    severity: worstExit === 0 ? "info" : "warning",
    payload: { reports_count: reports.length, worst_exit: worstExit },
  });
} catch {}

// Exit with appropriate code
const worstExit = Math.max(...reports.map((r) => r.exit_code));
process.exit(worstExit);

exec
/bin/bash -lc "sed -n '1,120p' agents/agents/chatbot-manifest-aggregator.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * chatbot-manifest-aggregator.ts — MSSOT-005 / INC-006 Layer B
 *
 * Reads chatbot-manifest route.ts files from each repo, computes use-case-scoped
 * compliance scores, and regenerates the AUTO-GEN block in CHATBOT_SSOT.md.
 *
 * REQUIRED capabilities (score denominator, unless declared N/A for use case):
 *   atrian_validation, sse_streaming, pii_detection, rate_limiting, telemetry
 * OPTIONAL (not in score):
 *   multi_tenant, tool_calling, guard_brasil_pii
 *
 * N/A detection: capability.note starts with "N/A" → excluded from denominator.
 *
 * Usage:
 *   bun agents/agents/chatbot-manifest-aggregator.ts --dry     # preview table
 *   bun agents/agents/chatbot-manifest-aggregator.ts --write   # patch CHATBOT_SSOT.md
 */

import { execSync } from "node:child_process";
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { resolve, join } from "node:path";
import { tmpdir, homedir } from "node:os";

const REPO_ROOT = resolve(import.meta.dir, "../..");
const HOME = homedir();

const MANIFESTS: { id: string; path: string }[] = [
  {
    id: "852",
    path: join(HOME, "852/src/app/api/_internal/chatbot-manifest/route.ts"),
  },
  {
    id: "forja",
    path: join(HOME, "forja/src/app/api/_internal/chatbot-manifest/route.ts"),
  },
  {
    id: "carteira-livre",
    path: join(HOME, "carteira-livre/app/api/_internal/chatbot-manifest/route.ts"),
  },
  // intelink: chatbot_manifest.py removido na migração para Next.js API routes (2026-05-05)
  // Endpoint equivalente: join(HOME, "intelink/app/api/chat/route.ts")
];

const SSOT_PATH = resolve(REPO_ROOT, "docs/modules/CHATBOT_SSOT.md");
const AUTO_GEN_BEGIN = "<!-- AUTO-GEN-BEGIN:chatbot-compliance -->";
const AUTO_GEN_END = "<!-- AUTO-GEN-END -->";

const REQUIRED_CAPS = [
  "atrian_validation",
  "sse_streaming",
  "pii_detection",
  "rate_limiting",
  "telemetry",
];

interface CapabilityEntry {
  present: boolean;
  evidence: string | null;
  note: string;
}

interface Manifest {
  chatbot_id: string;
  repo: string;
  schema_version: string;
  capabilities: Record<string, CapabilityEntry>;
  compliance: {
    primary_use_case: string;
    last_verified: string;
    verified_by: string;
  };
}

/** Extract MANIFEST object from a TS file using bun eval (bracket-counting). */
function extractManifestFromTS(filePath: string): Manifest | null {
  if (!existsSync(filePath)) return null;
  const src = readFileSync(filePath, "utf-8");

  const markerMatch = src.match(/const MANIFEST\s*=\s*\{/);
  if (!markerMatch || markerMatch.index === undefined) return null;

  const start = markerMatch.index + markerMatch[0].length - 1; // position of opening {
  let depth = 0;
  let end = start;
  for (let i = start; i < src.length; i++) {
    if (src[i] === "{") depth++;
    else if (src[i] === "}") {
      depth--;
      if (depth === 0) { end = i; break; }
    }
  }

  const objLiteral = src.slice(start, end + 1);

  // Run via bun to evaluate the TS object literal
  const tmpFile = `${tmpdir()}/manifest-${Date.now()}.ts`;
  try {
    writeFileSync(tmpFile, `const MANIFEST = ${objLiteral};\nconsole.log(JSON.stringify(MANIFEST));`);
    const out = execSync(`bun ${tmpFile}`, { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] });
    return JSON.parse(out) as Manifest;
  } catch {
    return null;
  } finally {
    try { Bun.file(tmpFile).exists(); /* no-op, just to reference */ } catch { /* ignore */ }
  }
}

/** Extract MANIFEST dict from a Python file (simple regex + JSON conversion). */
function extractManifestFromPython(filePath: string): Manifest | null {
  if (!existsSync(filePath)) return null;
  const src = readFileSync(filePath, "utf-8");

  const markerMatch = src.match(/MANIFEST\s*=\s*\{/);
  if (!markerMatch || markerMatch.index === undefined) return null;

  const start = markerMatch.index + markerMatch[0].length - 1;
  let depth = 0;
  let end = start;
  for (let i = start; i < src.length; i++) {

codex
I did not find any discrete, actionable regressions in the changed code relative to the specified base. The updates are internally consistent and primarily improve path portability and reporting behavior without introducing clear breakage.
I did not find any discrete, actionable regressions in the changed code relative to the specified base. The updates are internally consistent and primarily improve path portability and reporting behavior without introducing clear breakage.
```
