# Codex Local Review — 2026-06-01T13:32:22Z

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
session id: 019e8362-ae22-7e70-b7b6-0c0502d68f7a
--------
user
changes against 'HEAD~3'
2026-06-01T13:32:23.543016Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:32:23.643446Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:32:28.753966Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:32:29.167662Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:32:29.232100Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:32:29.587983Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:32:30.105434Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:32:31.013691Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:32:32.707932Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:32:35.971386Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff e9831cf55067c77cb634090a815be4ada8a3f37d' in /home/enio/egos
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
diff --git a/TASKS.md b/TASKS.md
index f207eed6..0996f062 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -508,6 +508,16 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
+## 🖥️ FRONTEND-SYNC — frontend/README/GitHub refletindo a realidade (Enio 2026-06-01)
+
+> **Diagnóstico (2 Sonnets + probes 2026-06-01):** o público NÃO reflete o trabalho recente. Homepage = copy antiga; `/status` congelado em 15/abr; `/showcase` dizia 23 agents; README/GitHub público sem MCPs live/Resolver/79 caps. Já feito (código+dados commitados, SHA `7ea70da6`): snapshot enriquecido (caps 79 / agents 27 / MCPs vivos) + manifest 23→27. Falta o LIVE (rebuild) + Red Zone (copy).
+- [ ] **FE-SYNC-001** [P1] `prime` — Rebuild egos-site (Docker, container `egos-site`@3071, snapshot/manifest são baked na imagem) p/ refletir snapshot fresco + manifest 27. Usar runbook `site-reliability`. **Prova visual §10 obrigatória** (screenshot /status + /showcase). 502-safe.
+- [ ] **FE-SYNC-002** [P1] — Renderizar o bloco `framework` (capabilities/agents/MCPs vivos) na página `/status` (server.ts) — hoje o snapshot já tem o dado, falta o render. Vai junto do rebuild FE-SYNC-001.
+- [ ] **FE-SYNC-003** [P1] `redzone` — Homepage copy refletir o foco atual (MCPs live, governança, transparência). **Depende de SITE-VOICE-001 + corte do Enio** (copy pública = Red Zone). NÃO editar sem o guia de voz.
+- [ ] **FE-SYNC-004** [P2] — Artigo factual no /timeline sobre o eval-runner live no ChatGPT + 79 capabilities (documenta sistema deployado; revisão factual, não-marketing). Site só tem 1 artigo hoje.
+- [ ] **FE-SYNC-005** [P2] — README do repo público `egos-governance`: mencionar MCPs live + Resolver Doctrine + 79 caps (hoje marca mcp-eval-runner como "Alpha"). Factual.
+- [ ] **FE-SYNC-006** [P3] — Auto-regen do snapshot (cron quebrado desde abr) — wire `status-snapshot.ts` num cron/Hermes pós-deploy p/ não estagnar de novo.
+
 ## 🎓 CURSOS ↔ FRAMEWORK ↔ GOVERNO — Enio 2026-06-01
 
 > Tese: curso = ponte framework→governo + magistério (vetor seguro PCMG). Princípio "método aberto + dado soberano/local". SSOT `docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md` + memory `project_courses_framework_gov_thesis`. Red Zone: posições/pitch de governo = corte do Enio.
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
diff --git a/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md b/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
new file mode 100644
index 00000000..c2890ba0
--- /dev/null
+++ b/docs/strategy/EGOS_TELEGRAM_AGENT_PLAN.md
@@ -0,0 +1,109 @@
+# EGOS Telegram Agent — Plano de Arquitetura
+
+> **Status:** PLAN (pré-código) · **Criado:** 2026-06-01 · **Owner:** Enio + EGOS Prime
+> **SSOTs relacionados:** [CHATBOT_SSOT.md](./CHATBOT_SSOT.md) · [AGENT_RUNTIME_DESIGN.md](./AGENT_RUNTIME_DESIGN.md) · [EGOS_MASTER_API_PRD.md](./EGOS_MASTER_API_PRD.md)
+> **Escopo:** levar capacidades do EGOS (monitoramento, MCP, meta-prompts, skills, config) para a superfície **Telegram** como um agente único. NÃO substitui os SSOTs acima — estende o comportamento do agente no canal Telegram.
+
+---
+
+## 1. Decisão de runtime (com evidência — 2026-06-01)
+
+**O `@EGOSin_bot` (Telegram) é servido pelo `egos-gateway` (TS), não pelo hermes.**
+
+Evidência coletada no VPS (`root@204.168.217.125`):
+- `getWebhookInfo` do `@EGOSin_bot` → **long-polling ativo, 0 pending, sem erro**. O processo que consome updates é o `egos-gateway` TS (`bun run src/server.ts`, container Docker `/app`).
+- `hermes-gateway.service` (Python, fork Nous) → **não tem canal Telegram** (config sem `telegram`). É o brain do **WhatsApp** (`forja-notifications`) + commit-review + LLM `qwen-plus`.
+
+**Conclusão:** os dois runtimes **dividem por canal**, não competem. → O dono de "EGOS no Telegram" é o **egos-gateway TS** (código nosso, já live, function-calling). hermes permanece como brain WhatsApp/LLM. **Regra anti-retrabalho:** skills/MCP/meta-prompts vão para UM lugar (orchestrator do egos-gateway); hermes só consome via API se precisar.
+
+---
+
+## 2. Estado atual (o que JÁ existe — não reconstruir)
+
+| Camada | Arquivo | Estado |
+|---|---|---|
+| Canal Telegram | `apps/egos-gateway/src/channels/telegram.ts` | ✅ multimodal (texto/voz+Whisper/foto+Qwen-VL/áudio/doc), auth-locked a `TELEGRAM_AUTHORIZED_USER_ID`, webhook + long-polling |
+| Comandos | idem | ✅ `/start /status /gems /wiki /agents /costs /hunt /trending /sector /help` |
+| Cérebro | `apps/egos-gateway/src/orchestrator.ts` (1665L) | ✅ function-calling qwen-plus, **12 tools** read-mostly: system_status, guard_status/test, gem_search/trending, wiki_search/page, list_agents, get_tasks, recent_commits, get_costs, knowledge_stats, world_model |
+| System prompt | `orchestrator.ts:buildSystemPrompt` | ✅ deriva de `~/.claude/CLAUDE.md §1` + FOCUS_GATES |
+| Monitoramento→Telegram | `apps/egos-gateway/src/health-monitor.ts` | ✅ alerta saúde <40% (START-009) + budget-monitor; pinga Guard/Gateway/Gem-Hunter |
+| Notify scripts | `scripts/*` (~20) | ✅ cost-alert, gemini-quota, mcp-silence, vps-health, task-drift-digest, hitl-request… |
+| Provider healthcheck | `scripts/doctor.ts` | ✅ probe **autenticado** (401=FALHA) — adicionado 2026-06-01 pós-incidente |
+
+## 3. Gap (o que falta para "EGOS inteiro")
+
+- ❌ **MCP** — os ~15 servers (governance, observability, ops, security, skills-registry, knowledge, eval-runner…) não estão wired no orchestrator.
+- ❌ **Meta-prompts** — `egos-governance` MCP `get_meta_prompt` não exposto.
+- ❌ **Skills** — as 24+ não acessíveis; limitação real: skills são instruções para um **agente de código** (file/bash); o qwen no Telegram não tem essas "mãos".
+- ❌ **Comandos de controle/escrita** (restart, run script, deploy) — hoje só leitura.
+- ⚠️ **Usage de LLM por provider** — parcial (custo/quota Gemini); base nova = `doctor.ts`.
+
+## 4. Limitações do Telegram (honestas)
+
+| Dá pra fazer bem | Limita / não dá |
+|---|---|
+| Chat multimodal, comandos, **inline keyboards** (botões HITL aprovar/rejeitar), alertas push, arquivos ≤20MB (download bot) / ≤50MB (upload) | Mensagem **≤4096 chars** → relatórios longos paginar ou mandar como arquivo |
+| Agente function-calling → tools/MCP | Sem dashboard rico (gráfico só como imagem gerada) |
+| HITL real (aprovar deploy via botão) | Skills **executáveis** precisam delegar a um worker (hermes/Codex/Claude Code) no VPS |
+| Controle de ops com allowlist | Comando de escrita via chat = **Red Zone** (allowlist + confirmação obrigatórios) |
+
+## 5. Arquitetura-alvo
+
+```
+Telegram (@EGOSin_bot)
+   │  (long-polling, auth-locked a Enio)
+   ▼
+egos-gateway/orchestrator.ts  ──function-calling (qwen-plus)──┐
+   │                                                          │
+   ├─ tools nativas (12 atuais)                               │
+   ├─ MCP bridge  ──► egos-observability / ops / governance / security / knowledge ...
+   ├─ meta-prompts ──► egos-governance.get_meta_prompt
+   ├─ skills      ──► egos-skills-registry (list/get)  +  delegação p/ worker (exec)
+   └─ control     ──► allowlist + inline-keyboard HITL  (F3, Red Zone)
+```
+
+**MCP bridge:** o orchestrator vira **cliente MCP** e expõe tools dos servers como function-calls. NÃO é "rodar MCP dentro do Telegram" — é o ponte Telegram↔MCP. Read-only primeiro.
+
+**Skills:** informacionais (triggers, conhecimento) o agente lê e aplica; executáveis (build/deploy/refactor) o agente **delega** para um runtime de código no VPS e devolve o resultado no chat.
+
+---
+
+## 6. Fases
+
+### F1 — Usage & Health → Telegram (baixo risco, alto valor) ⭐ primeiro
+- Cron no VPS chamando `bun scripts/doctor.ts` (provider health autenticado) → push Telegram em FALHA (chave morta/401) + resumo diário.
+- Agregador de **usage/custo de LLM por provider** (DashScope/OpenRouter/Gemini/Anthropic) → relatório diário + alerta de anomalia.
+- Fecha o loop do incidente 2026-06-01 (chave morta invisível).
+- **Critério de aceite:** chave morta em qualquer provider gera alerta Telegram em <24h; relatório diário de usage chega no bot.
+
+### F2 — MCP read-only + meta-prompts
+- Orchestrator como cliente MCP: wire `egos-observability` (pm2/system_metrics/audit), `egos-ops` (health/quota/services), `egos-governance` (repo_health/ssot_drift/list_tasks/**get_meta_prompt**).
+- Tool `meta_prompt` no agente.
+- **Critério de aceite:** `/status` e perguntas livres usam dados reais dos MCPs; agente recupera um meta-prompt sob demanda.
+
+### F3 — Controle/escrita (Red Zone — DECISÃO ADIADA)
+- Allowlist explícita de comandos (restart serviço, rodar script seguro, disparar agente).
+- Cada comando exige confirmação via **inline keyboard** (HITL, 2 toques). Nada destrutivo sem confirmação.
+- **Bloqueado até Enio cortar** (decisão adiada em 2026-06-01).
+
+### F4 — Skills
+- Tool `egos-skills-registry` (list/get) — skills informacionais funcionam direto.
+- Skills executáveis → delegação a worker de código no VPS (hermes/Codex), resultado devolvido no chat.
+- **Critério de aceite:** agente lista skills relevantes e aplica ao menos as informacionais; executáveis delegam com retorno auditável.
+
+---
+
+## 7. Riscos / Red Zone
+- **Controle via chat (F3):** qualquer escrita exige allowlist + HITL. Sem isso, não construir.
+- **Token do bot:** `TELEGRAM_BOT_TOKEN_AI_AGENTS` — nunca logar; rotacionar se exposto.
+- **Skills executáveis:** delegar com sandbox/escopo (Karpathy: minimum code; sem `git add -A` em agente).
+- **Custo:** function-calling em cada mensagem = chamadas qwen-plus; F1 deve incluir teto de custo.
+
+## 8. Decisões em aberto
+1. F3 (controle/escrita) — adiada; revisitar após F1/F2 no ar.
+2. Skills executáveis (F4) — qual runtime de delegação (hermes vs Codex vs Claude Code headless).
+3. Notificações: cadência (diário vs evento) e canal (mesmo @EGOSin_bot vs canal dedicado de alertas).
+
+---
+
+*Próximo passo aprovado por Enio (2026-06-01): plano escrito (este doc) → depois F1. Runtime dono = egos-gateway TS (decisão com evidência §1).*
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
/bin/bash -lc "sed -n '1,380p' scripts/status-snapshot.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * status-snapshot.ts — EGOS Public Status Snapshot
 *
 * Generates a sanitized, public-safe JSON snapshot of EGOS service health.
 * Runs every 5 minutes via VPS cron. Output consumed by apps/status-site/.
 *
 * Unlike obs-central.ts (internal, VPS-only), this:
 * - Runs Guard Brasil audit on its own output before writing
 * - Exposes only public-safe metrics (no internal IPs, no log content)
 * - Writes to docs/jobs/snapshot.json (served by status site)
 *
 * Usage:
 *   bun scripts/status-snapshot.ts              # write snapshot.json
 *   bun scripts/status-snapshot.ts --dry        # print to stdout
 *   bun scripts/status-snapshot.ts --check      # verify snapshot format
 *
 * Cron: every 5 minutes via VPS (ENC-L6-004)
 */

import { writeFileSync, readFileSync, existsSync, readdirSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { createClient } from "@supabase/supabase-js";
import { logAgentEvent } from './lib/agent-event.ts';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const SNAPSHOT_PATH = join(ROOT, "docs/jobs/snapshot.json");
const DRY = process.argv.includes("--dry");
const CHECK = process.argv.includes("--check");

const GUARD_API_KEY = process.env.GUARD_BRASIL_API_KEY ?? "";
const GUARD_URL = "https://guard.egos.ia.br";
const GATEWAY_URL = "https://gateway.egos.ia.br";

const SUPABASE_URL = process.env.SUPABASE_URL ?? "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_ANON_KEY ?? "";
const supabase = SUPABASE_URL && SUPABASE_KEY ? createClient(SUPABASE_URL, SUPABASE_KEY) : null;

// ── Types ─────────────────────────────────────────────────────────────────────

interface ServiceStatus {
  name: string;
  url: string;
  healthy: boolean;
  latencyMs: number | null;
  version?: string;
  details?: Record<string, string | number | boolean>;
  error?: string;
}

export interface StatusSnapshot {
  generatedAt: string;
  version: string;
  services: ServiceStatus[];
  knowledge: {
    pageCount: number;
    lastLearning: string | null;
    lastUpdated: string | null;
  };
  gemHunter: {
    totalGems: number;
    lastRun: string | null;
  };
  guardBrasil: {
    patternsActive: number;
    guardVersion: string;
    tenantsCount?: number; // only shown to authenticated community tier
  };
  framework: {
    capabilities: number;   // CBC files in docs/capabilities
    agentsTotal: number;    // agents/registry/agents.json
    agentsActive: number;
    mcpsLive: string[];     // public MCP endpoints responding (mcp.egos.ia.br/*)
  };
  incidentWindow: Array<{
    detectedAt: string;
    resolvedAt: string | null;
    service: string;
    summary: string;
    durationMinutes: number | null;
  }>;
  auditPassed: boolean;
  sha256: string;
}

// ── Health Checks ─────────────────────────────────────────────────────────────

async function checkService(
  name: string,
  url: string,
  timeoutMs = 5000
): Promise<ServiceStatus> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  const t0 = Date.now();

  try {
    const res = await fetch(url, { signal: controller.signal });
    const latencyMs = Date.now() - t0;
    clearTimeout(timer);

    let details: Record<string, string | number | boolean> = {};
    let version: string | undefined;

    if (res.ok) {
      const body = await res.json().catch(() => ({}));
      version = body.version ?? body.service_version ?? undefined;
      // Extract safe public fields only
      if (body.patterns !== undefined) details.patterns = body.patterns;
      if (body.uptime !== undefined) details.uptimeSeconds = Math.round(body.uptime);
      if (body.channels !== undefined) details.channels = (body.channels as string[]).length;
    }

    return {
      name,
      url,
      healthy: res.ok,
      latencyMs,
      version,
      details: Object.keys(details).length > 0 ? details : undefined,
    };
  } catch (e: unknown) {
    clearTimeout(timer);
    return {
      name,
      url,
      healthy: false,
      latencyMs: null,
      error: e instanceof Error ? e.message.split(" ").slice(0, 5).join(" ") : "unknown",
    };
  }
}

// ── Knowledge stats ───────────────────────────────────────────────────────────

async function getKnowledgeStats(): Promise<StatusSnapshot["knowledge"]> {
  let kbPageCount = 0;
  try {
    if (supabase) {
      const { count } = await supabase
        .from('kb_pages')
        .select('*', { count: 'exact', head: true })
        .eq('tenant', 'enio');
      kbPageCount = count ?? 0;
    }
  } catch { /* non-blocking */ }
  return { pageCount: kbPageCount, lastLearning: null, lastUpdated: null };
}

// ── Gem Hunter stats ──────────────────────────────────────────────────────────

async function getGemHunterStats(): Promise<StatusSnapshot["gemHunter"]> {
  try {
    const res = await fetch(`${GATEWAY_URL}/gem-hunter/health`, {
      signal: AbortSignal.timeout(8000),
    });
    if (!res.ok) return { totalGems: 0, lastRun: null };
    const data = await res.json();
    return {
      totalGems: data.total_gems ?? data.totalGems ?? 0,
      lastRun: data.last_run ?? data.lastRun ?? null,
    };
  } catch {
    return { totalGems: 0, lastRun: null };
  }
}

// ── Guard Brasil meta ─────────────────────────────────────────────────────────

async function getGuardBrasilMeta(): Promise<StatusSnapshot["guardBrasil"]> {
  try {
    const [healthRes, metaRes] = await Promise.all([
      fetch(`${GUARD_URL}/health`, { signal: AbortSignal.timeout(5000) }),
      fetch(`${GUARD_URL}/v1/meta`, { signal: AbortSignal.timeout(5000) }),
    ]);

    const health = healthRes.ok ? await healthRes.json() : {};
    const meta = metaRes.ok ? await metaRes.json() : {};

    return {
      patternsActive: health.patterns ?? 0,
      guardVersion: health.version ?? "unknown",
    };
  } catch {
    return { patternsActive: 0, guardVersion: "unknown" };
  }
}

// ── Guard Brasil audit on snapshot ───────────────────────────────────────────

async function auditSnapshot(text: string): Promise<boolean> {
  if (!GUARD_API_KEY) return true; // skip audit if no key
  try {
    const res = await fetch(`${GUARD_URL}/v1/inspect`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${GUARD_API_KEY}`,
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

exec
/bin/bash -lc "git show e9831cf55067c77cb634090a815be4ada8a3f37d:scripts/status-snapshot.ts | sed -n '210,340p'" in /home/enio/egos
 succeeded in 0ms:

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

  console.log("[status-snapshot] collecting metrics...");

  const [
    guardHealth,
    gatewayHealth,
    knowledge,
    gemHunter,
    guardMeta,
  ] = await Promise.all([
    checkService("guard-brasil", `${GUARD_URL}/health`),
    checkService("egos-gateway", `${GATEWAY_URL}/health`),
    getKnowledgeStats(),
    getGemHunterStats(),
    getGuardBrasilMeta(),
  ]);

  const generatedAt = new Date().toISOString();

  const snapshot: StatusSnapshot = {
    generatedAt,
    version: "1.0.0",
    services: [guardHealth, gatewayHealth],
    knowledge,
    gemHunter,
    guardBrasil: guardMeta,
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

exec
/bin/bash -lc 'ls docs/capabilities | head -n 20' in /home/enio/egos
 succeeded in 0ms:
001-knowledge-base-rag.md
002-chatbot-com-memoria.md
003-agentes-autonomos.md
004-funil-qualificacao-leads.md
005-grafo-neo4j-relacoes.md
006-pagamentos-split-asaas.md
007-ocr-reconhecimento-facial.md
008-guard-brasil-lgpd.md
009-observabilidade-telemetria.md
010-osint-eagle-eye.md
011-trading-dashboard-bots.md
012-app-mobile-capacitor.md
013-erp-conversacional-forja.md
014-ner-extracao-entidades.md
015-templates-setoriais-notebookllm.md
016-saas-multi-tenant.md
017-ia-local-mac-studio.md
018-agentes-por-colaborador-claude-code.md
019-producao-video-ia.md
020-publicacao-conteudo-governanca.md

exec
/bin/bash -lc "python3 - <<'PY'
import os,glob
files=os.listdir('docs/capabilities')
print('total',len(files))
print('cbc',sum(1 for f in files if f.startswith('CBC-') and f.endswith('.md')))
PY" in /home/enio/egos
 succeeded in 0ms:
total 114
cbc 79

exec
/bin/bash -lc "python3 - <<'PY'
import json,hashlib
p='docs/jobs/snapshot.json'
with open(p) as f: data=json.load(f)
sha=data['sha256']
# emulate intended maybe hash of snapshot with sha256 empty? and audit as current
import copy
x=copy.deepcopy(data)
# hash of full content pretty?
full=hashlib.sha256(json.dumps(data,separators=(',',':')).encode()).hexdigest()
# hash of before sha field set maybe empty
x['sha256']=''
pre=hashlib.sha256(json.dumps(x,separators=(',',':')).encode()).hexdigest()
print('stored',sha)
print('full',full)
print('pre',pre)
PY" in /home/enio/egos
 succeeded in 0ms:
stored d4c2fe0ef882ec1b8900501f3baca378515c0088ccf3880e95ffdfb2dc7ed334
full 617bf70ffe1165b7a18a03f611158a66689c46d3cad22f4caf6d3b479ca3ebc8
pre a2a3f9eb27777787d1d1f50736f422f70a15402698b00ba60373575aaafffced

exec
/bin/bash -lc "python3 - <<'PY'
import json,hashlib,copy
with open('docs/jobs/snapshot.json') as f:data=json.load(f)
x=copy.deepcopy(data)
x['auditPassed']=False
x['sha256']=''
print(hashlib.sha256(json.dumps(x,separators=(',',':')).encode()).hexdigest())
PY" in /home/enio/egos
 succeeded in 0ms:
d4c2fe0ef882ec1b8900501f3baca378515c0088ccf3880e95ffdfb2dc7ed334

exec
/bin/bash -lc "git show e9831cf55067c77cb634090a815be4ada8a3f37d:docs/jobs/snapshot.json > /tmp/base_snapshot.json && python3 - <<'PY'
import json,hashlib,copy
with open('/tmp/base_snapshot.json') as f:data=json.load(f)
sha=data['sha256']
full=hashlib.sha256(json.dumps(data,separators=(',',':')).encode()).hexdigest()
x=copy.deepcopy(data);x['sha256']='';print('stored',sha);print('full',full);print('pre',hashlib.sha256(json.dumps(x,separators=(',',':')).encode()).hexdigest());x['auditPassed']=False;print('auditfalse',hashlib.sha256(json.dumps(x,separators=(',',':')).encode()).hexdigest())
PY" in /home/enio/egos
 succeeded in 0ms:
stored ce3599dbfbd6bac0741fa22409a7c2274664e58bdb66ecb81766fde29346d957
full ddb7f2beea6acd0ad92e03613ff6d2d8f649c9352e8afba93a50a49614fa1249
pre 42ee61a942a98baf47ce442e7bdebb2d500c8f401592e3d10dea841992128afc
auditfalse ce3599dbfbd6bac0741fa22409a7c2274664e58bdb66ecb81766fde29346d957

codex
I did not find any discrete, introduced defects in the changed code that would clearly break behavior, correctness, or maintainability relative to the base commit.
I did not find any discrete, introduced defects in the changed code that would clearly break behavior, correctness, or maintainability relative to the base commit.
```
