# Codex Local Review — 2026-06-01T14:32:37Z

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
session id: 019e8399-d583-7e22-b509-bff100745a80
--------
user
changes against 'HEAD~3'
2026-06-01T14:32:37.942499Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:32:38.094417Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T14:32:40.000439Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:32:46.573947Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:32:47.009410Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T14:32:47.355970Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T14:32:47.885470Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T14:32:48.869610Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T14:32:50.497610Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T14:32:53.555950Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff c87d498b8f573b8459683ed1dd15eb819f0b958c' in /home/enio/egos
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
I did not find any discrete, actionable regressions in the diff against the specified merge base. The changes appear behaviorally sound: usage logging is expanded intentionally, timeout cleanup is improved, and the new open-access fetch script is internally consistent.
I did not find any discrete, actionable regressions in the diff against the specified merge base. The changes appear behaviorally sound: usage logging is expanded intentionally, timeout cleanup is improved, and the new open-access fetch script is internally consistent.
```
