# Codex Local Review — 2026-06-01T12:47:12Z

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
session id: 019e8339-5520-77e0-ab88-c78caa3bf258
--------
user
changes against 'HEAD~3'
2026-06-01T12:47:14.260196Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:47:14.263496Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:47:16.291117Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:47:16.480669Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:47:16.854146Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:47:17.194074Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T12:47:17.771351Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T12:47:18.695645Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T12:47:20.313561Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T12:47:23.687504Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 6b270f45db98f77b62d1feb34603594655273819' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index deb2ae33..17249086 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -508,6 +508,12 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
+### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
+> Ref: https://developers.openai.com/apps-sdk · Conector custom do ChatGPT = Server URL (SSE) + Auth (OAuth / Sem-auth / Mista). `mcp-g-pecas` já rodou HTTPS-live no ChatGPT → caminho provado. Objetivo: validar uso real dos MCPs no ChatGPT.
+- [ ] **MCP-CHATGPT-001** [P1] `prime` — Validar `mcp-eval-runner` (GREEN: read-only, sem segredo) no conector ChatGPT. **Receita validada (Sonnet 2026-06-01):** ChatGPT exige **Streamable HTTP** em endpoint `/mcp` (auth=Bearer estático basta; OAuth exige auth-server+`/.well-known`). `mcp-bridge` já faz tudo (CORS/Origin/bearer/sessão). Passos: (1) PM2 `MCP_NAME=eval-runner MCP_CMD="bun packages/mcp-eval-runner/src/index.ts" MCP_PORT=7005 bun packages/mcp-bridge/src/index.ts`; (2) Caddy `handle /eval-runner* { uri strip_prefix /eval-runner; reverse_proxy localhost:7005 }` no bloco `mcp.egos.ia.br`; (3) token em `/etc/egos/eval-runner.env`; (4) probe `curl POST https://mcp.egos.ia.br/eval-runner/mcp` initialize; (5) colar URL no diálogo do ChatGPT, auth=Bearer. ~1h. **Toca prod+Caddy → go do Enio + review Codex antes.**
+- [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
+- [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
+
 ---
 
 ## 🔬 INV-* TASKS 2026-05-21
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
/bin/bash -lc "sed -n '1,320p' packages/mcp-bridge/src/index.ts" in /home/enio/egos
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

codex
The bridge now correctly fixes newline framing, but it introduces a protocol handling gap: client-sent JSON-RPC responses are not recognized as no-reply frames and are incorrectly proxied as request/response calls, causing deterministic timeouts.

Review comment:

- [P1] Handle JSON-RPC responses without waiting for downstream reply — /home/enio/egos/packages/mcp-bridge/src/index.ts:121-128
  The new early-return path is meant to cover "notifications/responses", but `isNotification` only matches messages without `id`; JSON-RPC **responses** include `id` and usually no `method`, so they fall through to `proxyRequest()` and the bridge waits 30s for a subprocess reply that will never come. In practice, any client POSTing a response frame (e.g., completion of a server-initiated request) now gets a timeout/500 instead of immediate ack, which can break Streamable HTTP session flow.
The bridge now correctly fixes newline framing, but it introduces a protocol handling gap: client-sent JSON-RPC responses are not recognized as no-reply frames and are incorrectly proxied as request/response calls, causing deterministic timeouts.

Review comment:

- [P1] Handle JSON-RPC responses without waiting for downstream reply — /home/enio/egos/packages/mcp-bridge/src/index.ts:121-128
  The new early-return path is meant to cover "notifications/responses", but `isNotification` only matches messages without `id`; JSON-RPC **responses** include `id` and usually no `method`, so they fall through to `proxyRequest()` and the bridge waits 30s for a subprocess reply that will never come. In practice, any client POSTing a response frame (e.g., completion of a server-initiated request) now gets a timeout/500 instead of immediate ack, which can break Streamable HTTP session flow.
```
