# Codex Local Review — 2026-06-01T14:31:40Z

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
session id: 019e8398-f888-7d53-82a2-e72df887f202
--------
user
changes against 'HEAD~3'
2026-06-01T14:31:42.014599Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:31:42.029519Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:31:47.494321Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:31:47.883099Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff d9178f9fa161b43ed7464e1c703cc724cc811d96' in /home/enio/egos
 succeeded in 0ms:
diff --git a/apps/egos-gateway/src/orchestrator.ts b/apps/egos-gateway/src/orchestrator.ts
index 5f2c9d9e..15d0eeb1 100644
--- a/apps/egos-gateway/src/orchestrator.ts
+++ b/apps/egos-gateway/src/orchestrator.ts
@@ -1652,6 +1652,12 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
       return { text: "❌ Erro no AI. Tente novamente.", toolsUsed };
     }
 
+    // Codex #2: log usage for EVERY model round-trip (tool-call turns consume
+    // tokens too) — not just the final stop turn. Defaults to 0 if absent.
+    if (data.usage) {
+      logApiUsage(data.model ?? "qwen-plus", data.usage.prompt_tokens ?? 0, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
+    }
+
     const choice = data.choices?.[0];
     if (!choice) break;
 
@@ -1664,9 +1670,8 @@ export async function orchestrate(msg: IncomingMessage, client?: ClientContext):
       // Persist conversation turn + token log (non-blocking)
       saveHistory(msg.channel, msg.from, userText, raw, toolsUsed, msg.mediaType).catch(() => {});
       if (data.usage?.prompt_tokens) {
-        const usedModel = data.model ?? "qwen-plus";
-        logTokenUsage(client?.slug, usedModel, data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
-        logApiUsage(usedModel, data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
+        // logApiUsage moved above (logs every round-trip); keep tenant billing here.
+        logTokenUsage(client?.slug, data.model ?? "qwen-plus", data.usage.prompt_tokens, data.usage.completion_tokens ?? 0, msg.channel).catch(() => {});
       }
       return { text: formatted, toolsUsed };
     }
diff --git a/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md b/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md
new file mode 100644
index 00000000..722c7aff
--- /dev/null
+++ b/docs/_current_handoffs/handoff_2026-06-01_alibaba-telegram-f1.md
@@ -0,0 +1,46 @@
+# Handoff — 2026-06-01 — Alibaba incident + EGOS-Telegram F1
+
+## ✅ Accomplished (com SHAs)
+- **Alibaba investigation** — chave morta (401) nas 3 superfícies; VPS root cause `provider: alibaba_dashscope`→`alibaba` (+`DASHSCOPE_API_KEY`); rotacionada + validada e2e (qwen-plus PONG). Não commitado (ops VPS + rotação de secret).
+- **Part A** — `e9831cf5` — `scripts/doctor.ts` probe autenticado (401=FAIL), 3 callers CN→intl (`ssot-router`/`manifest-generator`/`chatbot-core/model-router`), chave Gemini hardcoded removida, PAT `gho_` tirado do `.git/config`, `CAPABILITY_REGISTRY §16`.
+- **Part B** — `fb24141d` — `docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md` (4 fases + decisão de runtime com evidência: egos-gateway TS dono do Telegram).
+- **F1a** — `e667d423` — `scripts/llm-usage-notify.ts` (saúde+usage→Telegram).
+- **F1b** — `70994fee` (folded por sessão paralela — atribuição errada, conteúdo ok) — migration `api_usage` + RLS (aplicada egos-lab), `logApiUsage()` no orchestrator, notifier com leitor .env robusto.
+- **Crons** — local (diário 08:00 + alert-only 0/6/12/18) + VPS (alert-only 3/9/15/21) → cobertura ≤3h 24/7.
+
+## 🔄 In Progress
+- (nenhum) — F1 entregue até o limite do que não exige redeploy.
+
+## ⏳ Blocked
+- **Usage $ real** — bloqueado em redeploy do gateway (logApiUsage só popula api_usage após deploy do container). Enio escolheu "depois — sem pressa".
+- **Codex review** — auto-dispatch via post-push (3x) NÃO retornou resultado local; não incorporado.
+
+## 🔗 Next Steps (priority order)
+1. **Revogar** token `gho_` (GitHub) + chave **OpenAI** morta (401) — ação Enio.
+2. **Redeploy gateway** (INC-PROD-001) → ativa logApiUsage → usage $ real no relatório.
+3. **F2** — MCP read-only (observability/ops/governance) + meta-prompts como tools do agente.
+4. (opcional) corrigir atribuição do `70994fee` / rotacionar token bot exposto.
+
+## 🌐 Environment State
+- Build/typecheck: ✅ (notifier + orchestrator limpos)
+- Tests: notifier verificado e2e (--dry + envio real ao @EGOSin_bot ✅); api_usage smoke ✅
+- Deploy: gateway NÃO redeployado (logApiUsage dormindo); bot live (long-polling healthy)
+- Git: HEAD d9178f9f, sync com origin
+
+## 📌 Decisions Made (architectural)
+- Runtime dono do Telegram = **egos-gateway TS** (hermes = WhatsApp; dividem por canal) — evidência via getWebhookInfo + hermes config.
+- `api_usage` = tabela canônica service-role-only (RLS), populada por logApiUsage em TODA chamada.
+- Crons "os dois" (local + VPS) por decisão Enio.
+- F3 (controle/escrita via Telegram) ADIADO por Enio.
+
+## ✅ Todos da sessão (snapshot)
+- [x] Alibaba investigation + rotação + validação e2e
+- [x] Part A (doctor autenticado + CN→intl + secrets) — e9831cf5
+- [x] Part B plano SSOT — fb24141d
+- [x] F1b api_usage + gateway logging + notifier — 70994fee
+- [x] Crons local + VPS + envio real
+- [ ] Redeploy gateway (Enio: depois)
+- [ ] Codex review incorporado (não retornou)
+
+## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
+- "Usage $ por provider funcionando" — [CONCEPT até redeploy]: tabela+logging prontos mas gateway não redeployado, então api_usage não recebe dados reais ainda.
diff --git a/docs/jobs/2026-06-01-doc-drift-verifier.json b/docs/jobs/2026-06-01-doc-drift-verifier.json
index 79da5414..a235d2d0 100644
--- a/docs/jobs/2026-06-01-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-01-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-01T01:19:46.492Z",
+  "verified_at": "2026-06-01T14:31:10.113Z",
   "summary": {
     "total_claims": 15,
     "passed": 14,
@@ -17,8 +17,8 @@
       "id": "total_agents",
       "description": "Agents registered in agents.json",
       "status": "ok",
-      "last_value": "23",
-      "current_value": "24",
+      "last_value": "27",
+      "current_value": "27",
       "tolerance": "min:18",
       "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
       "severity": "ok"
@@ -72,7 +72,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1115",
+      "current_value": "1169",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -163,7 +163,7 @@
       "description": "Pre-commit hook chain has minimum required governance stages",
       "status": "ok",
       "last_value": "70",
-      "current_value": "147",
+      "current_value": "148",
       "tolerance": "min:15",
       "command": "grep -c '\\[' .husky/pre-commit",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-01-pre-commit-pipeline.json b/docs/jobs/2026-06-01-pre-commit-pipeline.json
index 55d5822b..8e908528 100644
--- a/docs/jobs/2026-06-01-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -142,5 +142,21 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=bcf19847",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:29:27.473Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=0 sha=8e123152",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:31:10.653Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=1bd668d8",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/scripts/doctor.ts b/scripts/doctor.ts
index 7cad9738..4bb91330 100755
--- a/scripts/doctor.ts
+++ b/scripts/doctor.ts
@@ -218,18 +218,19 @@ async function checkProviderReadiness() {
     }
     const apiKey = process.env[provider.envKey]!.trim();
     let httpStatus = 0;
+    const controller = new AbortController();
+    const timeoutId = setTimeout(() => controller.abort(), 8000);
     try {
-      const controller = new AbortController();
-      const timeoutId = setTimeout(() => controller.abort(), 8000);
       const r = await fetch(provider.url, {
         method: 'GET',
         headers: { Authorization: `Bearer ${apiKey}` },
         signal: controller.signal,
       });
-      clearTimeout(timeoutId);
       httpStatus = r.status;
     } catch {
       httpStatus = 0; // network error
+    } finally {
+      clearTimeout(timeoutId); // Codex #1: avoid timer leak on throw
     }
 
     if (httpStatus === 200) {
diff --git a/scripts/open-access-fetch.ts b/scripts/open-access-fetch.ts
new file mode 100644
index 00000000..e38306a3
--- /dev/null
+++ b/scripts/open-access-fetch.ts
@@ -0,0 +1,154 @@
+/**
+ * open-access-fetch.ts — Legal open-access literature fetcher
+ *
+ * DOI / arXiv id / title → best LEGAL open-access PDF + metadata, via primary sources:
+ *   1. Unpaywall   — legal OA version of paywalled papers (api.unpaywall.org)
+ *   2. OpenAlex    — 250M+ works, OA location + metadata (api.openalex.org)
+ *   3. arXiv       — preprints (export.arxiv.org)
+ *   4. Crossref    — DOI metadata fallback (api.crossref.org)
+ *
+ * No API keys. Unpaywall uses a "polite pool" email (EGOS_CONTACT_EMAIL).
+ * Zero copyright risk: only returns links the publisher/author made openly available.
+ *
+ * SSOT rule: docs/governance/OPEN_ACCESS_SOURCING_RULE.md
+ * Capability: §105 in docs/CAPABILITY_REGISTRY.md
+ * CLI:  bun scripts/open-access-fetch.ts <doi|arxiv|"title words"> [--download out.pdf] [--json]
+ * Lib:  import { resolveOpenAccess } from "./scripts/open-access-fetch.ts"
+ */
+
+const EMAIL = process.env.EGOS_CONTACT_EMAIL ?? "research@egos.ia.br";
+const UA = `EGOS-open-access-fetch/1.0 (mailto:${EMAIL})`;
+
+export interface OAResult {
+  found: boolean;
+  query: string;
+  doi?: string;
+  title?: string;
+  year?: number;
+  isOA?: boolean;
+  pdfUrl?: string;       // direct PDF when available
+  landingUrl?: string;   // OA landing page
+  license?: string;
+  source?: "unpaywall" | "openalex" | "arxiv" | "crossref" | "none";
+  note?: string;
+}
+
+async function j(url: string): Promise<any | null> {
+  try {
+    const r = await fetch(url, { headers: { "User-Agent": UA, Accept: "application/json" }, signal: AbortSignal.timeout(15000) });
+    if (!r.ok) return null;
+    return await r.json();
+  } catch { return null; }
+}
+
+const isDoi = (s: string) => /^10\.\d{4,9}\/\S+$/.test(s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, ""));
+const normDoi = (s: string) => s.trim().replace(/^https?:\/\/(dx\.)?doi\.org\//, "");
+const isArxiv = (s: string) => /^(arxiv:)?\d{4}\.\d{4,5}(v\d+)?$/i.test(s.trim());
+
+// ── Unpaywall: the canonical "is there a legal open version" source ──────────
+async function viaUnpaywall(doi: string): Promise<OAResult | null> {
+  const d = await j(`https://api.unpaywall.org/v2/${encodeURIComponent(doi)}?email=${encodeURIComponent(EMAIL)}`);
+  if (!d) return null;
+  const loc = d.best_oa_location;
+  return {
+    found: true, query: doi, doi, title: d.title, year: d.year,
+    isOA: !!d.is_oa,
+    pdfUrl: loc?.url_for_pdf ?? undefined,
+    landingUrl: loc?.url_for_landing_page ?? loc?.url ?? undefined,
+    license: loc?.license ?? undefined,
+    source: "unpaywall",
+    note: d.is_oa ? `OA via ${loc?.host_type ?? "?"}` : "No legal OA version found (try author/library/institutional access).",
+  };
+}
+
+// ── OpenAlex: metadata + OA url; also title search ──────────────────────────
+async function viaOpenAlexDoi(doi: string): Promise<OAResult | null> {
+  const d = await j(`https://api.openalex.org/works/doi:${encodeURIComponent(doi)}?mailto=${encodeURIComponent(EMAIL)}`);
+  if (!d?.id) return null;
+  return {
+    found: true, query: doi, doi, title: d.title, year: d.publication_year,
+    isOA: !!d.open_access?.is_oa,
+    pdfUrl: d.best_oa_location?.pdf_url ?? d.open_access?.oa_url ?? undefined,
+    landingUrl: d.best_oa_location?.landing_page_url ?? d.open_access?.oa_url ?? undefined,
+    license: d.best_oa_location?.license ?? undefined,
+    source: "openalex",
+    note: d.open_access?.is_oa ? `OA status: ${d.open_access?.oa_status}` : "Closed in OpenAlex.",
+  };
+}
+
+async function viaOpenAlexSearch(title: string): Promise<OAResult | null> {
+  const d = await j(`https://api.openalex.org/works?search=${encodeURIComponent(title)}&per_page=1&mailto=${encodeURIComponent(EMAIL)}`);
+  const w = d?.results?.[0];
+  if (!w) return null;
+  return {
+    found: true, query: title, doi: w.doi?.replace("https://doi.org/", ""), title: w.title, year: w.publication_year,
+    isOA: !!w.open_access?.is_oa,
+    pdfUrl: w.best_oa_location?.pdf_url ?? w.open_access?.oa_url ?? undefined,
+    landingUrl: w.best_oa_location?.landing_page_url ?? w.open_access?.oa_url ?? undefined,
+    license: w.best_oa_location?.license ?? undefined,
+    source: "openalex",
+    note: `matched "${w.title}"`,
+  };
+}
+
+// ── arXiv preprints ──────────────────────────────────────────────────────────
+async function viaArxiv(id: string): Promise<OAResult | null> {
+  const aid = id.replace(/^arxiv:/i, "");
+  try {
+    const r = await fetch(`http://export.arxiv.org/api/query?id_list=${encodeURIComponent(aid)}`, { headers: { "User-Agent": UA }, signal: AbortSignal.timeout(15000) });
+    if (!r.ok) return null;
+    const xml = await r.text();
+    const title = xml.match(/<title>([\s\S]*?)<\/title>/g)?.[1]?.replace(/<\/?title>/g, "").trim();
+    if (!title) return null;
+    return { found: true, query: id, title, isOA: true, pdfUrl: `https://arxiv.org/pdf/${aid}`, landingUrl: `https://arxiv.org/abs/${aid}`, license: "arXiv", source: "arxiv", note: "preprint" };
+  } catch { return null; }
+}
+
+/** Resolve any query (DOI / arXiv id / title) to the best legal open-access result. */
+export async function resolveOpenAccess(query: string): Promise<OAResult> {
+  const q = query.trim();
+  if (isArxiv(q)) {
+    const a = await viaArxiv(q);
+    if (a) return a;
+  }
+  if (isDoi(q)) {
+    const doi = normDoi(q);
+    // Unpaywall first (best OA signal), then OpenAlex, then mark closed.
+    const u = await viaUnpaywall(doi);
+    if (u?.pdfUrl || u?.landingUrl) return u;
+    const o = await viaOpenAlexDoi(doi);
+    if (o?.pdfUrl || o?.landingUrl) return o;
+    return u ?? o ?? { found: false, query: q, source: "none", note: "DOI not found in OA sources." };
+  }
+  // Title search
+  const s = await viaOpenAlexSearch(q);
+  if (s) return s;
+  return { found: false, query: q, source: "none", note: "No match. Pass a DOI, arXiv id, or exact title." };
+}
+
+// ── CLI ───────────────────────────────────────────────────────────────────────
+if (import.meta.main) {
+  const args = (Bun.argv ?? process.argv).slice(2);
+  const json = args.includes("--json");
+  const dlIdx = args.indexOf("--download");
+  const downloadPath = dlIdx >= 0 ? args[dlIdx + 1] : null;
+  const skipIdx = dlIdx >= 0 ? dlIdx + 1 : -1; // bug: dlIdx+1=0 dropped the query when no --download
+  const query = args.filter((a, i) => !a.startsWith("--") && i !== skipIdx).join(" ");
+  if (!query) { console.error("Usage: bun scripts/open-access-fetch.ts <doi|arxiv|title> [--download out.pdf] [--json]"); process.exit(1); }
+
+  const res = await resolveOpenAccess(query);
+  if (json) { console.log(JSON.stringify(res, null, 2)); }
+  else {
+    console.log(`\n${res.found ? "✅" : "❌"} ${res.title ?? res.query}`);
+    console.log(`   source: ${res.source} | OA: ${res.isOA ?? "?"} | year: ${res.year ?? "?"} | license: ${res.license ?? "?"}`);
+    if (res.pdfUrl) console.log(`   PDF: ${res.pdfUrl}`);
+    if (res.landingUrl) console.log(`   landing: ${res.landingUrl}`);
+    if (res.note) console.log(`   note: ${res.note}`);
+  }
+
+  if (downloadPath && res.pdfUrl) {
+    const r = await fetch(res.pdfUrl, { headers: { "User-Agent": UA }, signal: AbortSignal.timeout(60000) });
+    if (r.ok) { await Bun.write(downloadPath, await r.arrayBuffer()); console.error(`[downloaded] ${downloadPath}`); }
+    else console.error(`[download failed] HTTP ${r.status}`);
+  }
+}

codex
Most changes are safe, but the new arXiv parsing logic is fragile and can return incorrect titles for valid results, which impacts the correctness of this new capability.

Review comment:

- [P1] Extract arXiv entry title instead of feed title — /home/enio/egos/scripts/open-access-fetch.ts:105-106
  The arXiv resolver currently parses XML with `xml.match(/<title>([\s\S]*?)<\/title>/g)?.[1]`, which depends on the second `<title>` tag being the paper title. In arXiv Atom responses, this is brittle and can return the feed title (`arXiv Query Results`) or break if structure/order changes, causing incorrect metadata for valid arXiv IDs. Parsing the `<entry><title>` field explicitly (or using an XML parser) avoids returning wrong titles.
Most changes are safe, but the new arXiv parsing logic is fragile and can return incorrect titles for valid results, which impacts the correctness of this new capability.

Review comment:

- [P1] Extract arXiv entry title instead of feed title — /home/enio/egos/scripts/open-access-fetch.ts:105-106
  The arXiv resolver currently parses XML with `xml.match(/<title>([\s\S]*?)<\/title>/g)?.[1]`, which depends on the second `<title>` tag being the paper title. In arXiv Atom responses, this is brittle and can return the feed title (`arXiv Query Results`) or break if structure/order changes, causing incorrect metadata for valid arXiv IDs. Parsing the `<entry><title>` field explicitly (or using an XML parser) avoids returning wrong titles.
```
