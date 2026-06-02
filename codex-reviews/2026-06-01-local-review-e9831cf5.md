# Codex Local Review — 2026-06-01T13:24:52Z

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
session id: 019e835b-cfd9-73c0-8689-564fc1d6c9eb
--------
user
changes against 'HEAD~3'
2026-06-01T13:24:54.296048Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:24:54.296080Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:24:56.160396Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:24:56.533153Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:24:56.957864Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:24:57.509063Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:24:58.492576Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:24:58.945430Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:25:00.281163Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:25:03.665428Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff 33292d04ce60dfa6967911ecbbc0f8897e96e979' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index ac70458b..f207eed6 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -508,6 +508,13 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
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
 > **✅ VALIDADO 2026-06-01:** `eval-runner` conectou no ChatGPT (URL `https://mcp.egos.ia.br/eval-runner/mcp`, sem-auth, Developer Mode). 6 tools carregadas. Dois bugs achados+consertados: (1) bridge stdio sem `\n` → travava (SHA `ae4da0c0`); (2) eval-runner via 0 CBCs no VPS — REPO_ROOT resolvia `/opt/` em vez do repo → adicionado `EGOS_REPO_ROOT` env + dados framework sincronizados p/ `/opt/egos-data` + fix do falso `migration_pct:100%`. Agora vê 79 CBCs reais (`migration_pct:91.9%`). ChatGPT é stateless (re-inicializa cada call) + não tem campo Bearer (só OAuth/sem-auth/mista) — por isso g-pecas falhou no print do Enio.
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
 
diff --git a/docs/jobs/2026-06-01-doc-drift-verifier.json b/docs/jobs/2026-06-01-doc-drift-verifier.json
index 79da5414..9fd8e7e0 100644
--- a/docs/jobs/2026-06-01-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-01-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-01T01:19:46.492Z",
+  "verified_at": "2026-06-01T13:24:35.657Z",
   "summary": {
     "total_claims": 15,
     "passed": 14,
@@ -18,7 +18,7 @@
       "description": "Agents registered in agents.json",
       "status": "ok",
       "last_value": "23",
-      "current_value": "24",
+      "current_value": "27",
       "tolerance": "min:18",
       "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
       "severity": "ok"
@@ -72,7 +72,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1115",
+      "current_value": "1146",
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
index 55d5822b..d963cc83 100644
--- a/docs/jobs/2026-06-01-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -142,5 +142,13 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=bcf19847",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T13:24:36.920Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=5 sha=e9831cf5",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
new file mode 100644
index 00000000..be53b058
--- /dev/null
+++ b/docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md
@@ -0,0 +1,72 @@
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
/bin/bash -lc "sed -n '1,220p' scripts/manifest-generator.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * manifest-generator.ts — DRIFT-011
 *
 * Auto-generates or updates .egos-manifest.yaml from a repo's README.md
 * using LLM extraction (Gemini Flash → Alibaba Qwen → regex fallback).
 *
 * Extracts quantitative claims like:
 *   - "83.7M nodes" → claim: neo4j_nodes
 *   - "15 PII patterns" → claim: pii_patterns
 *   - "4ms latency" → claim: latency_ms
 *
 * Usage:
 *   bun scripts/manifest-generator.ts --repo /home/enio/852
 *   bun scripts/manifest-generator.ts --repo /home/enio/852 --dry
 *   bun scripts/manifest-generator.ts --all     # all KNOWN_REPOS
 *
 * Part of: docs/DOC_DRIFT_SHIELD.md (Layer 1 bootstrapping)
 */

import { existsSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

// ─── Config ───────────────────────────────────────────────────────────────────

const KNOWN_REPOS = [
  "/home/enio/egos",
  "/home/enio/carteira-livre",
  "/home/enio/br-acc",
  "/home/enio/852",
  "/home/enio/forja",
  "/home/enio/egos-lab",
  "/home/enio/intelink",
];

const GEMINI_KEY =
  process.env.GOOGLE_AI_STUDIO_API_KEY ||
  process.env.GEMINI_API_KEY ||
  ""; // hardcoded key removed (SEC) — set GOOGLE_AI_STUDIO_API_KEY or GEMINI_API_KEY

const DASHSCOPE_KEY = process.env.ALIBABA_DASHSCOPE_API_KEY ?? "";

// ─── Types ────────────────────────────────────────────────────────────────────

interface ExtractedClaim {
  id: string;
  description: string;
  value: string;
  unit: string;
  raw: string; // original text snippet
}

interface GeneratedManifest {
  repo: string;
  last_full_verification: string;
  claims: Array<{
    id: string;
    description: string;
    command: string;
    tolerance: string;
    last_value: string;
    last_verified_at: string;
    note?: string;
  }>;
}

// ─── Regex-based fallback extraction ─────────────────────────────────────────

const CLAIM_PATTERNS: Array<{
  regex: RegExp;
  id: (m: RegExpMatchArray) => string;
  description: (m: RegExpMatchArray) => string;
  value: (m: RegExpMatchArray) => string;
}> = [
  {
    regex: /(\d[\d.,]+)\s*[Mm]illion?\s*(?:nodes?|nós|entidades|entities)/i,
    id: () => "neo4j_nodes",
    description: () => "Neo4j graph node count",
    value: (m) => String(Math.round(parseFloat(m[1].replace(/,/g, ".")) * 1_000_000)),
  },
  {
    regex: /(\d[\d.,]+[Mm]?)\s*(?:nodes?|nós|entidades)\s/i,
    id: () => "neo4j_nodes",
    description: () => "Neo4j graph node count",
    value: (m) => {
      const raw = m[1].replace(/,/g, "").replace(/M/i, "000000");
      return String(parseInt(raw, 10));
    },
  },
  {
    regex: /(\d+)\s*(?:PII\s+)?padrões?|patterns?(?:\s+PII|\s+brasileiros?)?/i,
    id: () => "pii_patterns",
    description: () => "PII detection patterns",
    value: (m) => m[1],
  },
  {
    regex: /(\d+)ms\s*(?:de\s*)?(?:latência|latency)/i,
    id: () => "latency_ms",
    description: () => "API response latency in ms",
    value: (m) => m[1],
  },
  {
    regex: /F1\s*(?:score)?\s*[:=]?\s*([\d.]+)%/i,
    id: () => "f1_score_pct",
    description: () => "F1 score percentage",
    value: (m) => m[1],
  },
  {
    regex: /(\d+)\s*(?:Docker\s*)?containers?/i,
    id: () => "docker_containers",
    description: () => "Docker containers in production",
    value: (m) => m[1],
  },
  {
    regex: /(\d+)\s*(?:ETL\s+)?pipelines?/i,
    id: () => "etl_pipelines",
    description: () => "ETL pipeline count",
    value: (m) => m[1],
  },
  {
    regex: /(\d[\d.,]+)\s*(?:commits?)/i,
    id: () => "total_commits",
    description: () => "Total git commits",
    value: (m) => m[1].replace(/,/g, ""),
  },
  {
    regex: /(\d+)\s*(?:agents?|agentes?)\s/i,
    id: () => "registered_agents",
    description: () => "Registered agents",
    value: (m) => m[1],
  },
  {
    regex: /(\d+)\s*(?:tools?|ferramentas?)\b/i,
    id: () => "tool_count",
    description: () => "Tool count",
    value: (m) => m[1],
  },
  {
    regex: /(\d+)\s*territórios?|territories/i,
    id: () => "territories",
    description: () => "Monitored territories",
    value: (m) => m[1],
  },
];

function regexExtract(readmeContent: string): ExtractedClaim[] {
  const seen = new Set<string>();
  const claims: ExtractedClaim[] = [];

  for (const pattern of CLAIM_PATTERNS) {
    const match = readmeContent.match(pattern.regex);
    if (match) {
      const id = pattern.id(match);
      if (seen.has(id)) continue;
      seen.add(id);
      claims.push({
        id,
        description: pattern.description(match),
        value: pattern.value(match),
        unit: "",
        raw: match[0],
      });
    }
  }

  return claims;
}

// ─── LLM extraction via Gemini Flash ─────────────────────────────────────────

async function llmExtractGemini(
  repoName: string,
  readmeContent: string
): Promise<ExtractedClaim[]> {
  if (!GEMINI_KEY) return [];

  const prompt = `Extract ALL quantitative claims from this README. Return a JSON array only.

README (first 2000 chars):
${readmeContent.slice(0, 2000)}

For each claim, return:
{"id": "snake_case_unique_id", "description": "what it measures", "value": "numeric value as string", "unit": "unit (nodes, ms, %, count, etc.)", "raw": "original text snippet"}

Examples of claims to find:
- "83.7M nodes" → id: "neo4j_nodes", value: "83700000"
- "15 PII patterns" → id: "pii_patterns", value: "15"
- "4ms latency" → id: "latency_ms", value: "4"
- "F1 85.3%" → id: "f1_score_pct", value: "85.3"
- "1690 commits" → id: "total_commits", value: "1690"

Return [] if no quantitative claims found. JSON array only, no markdown.`;

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 12000);

    const resp = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_KEY}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: { temperature: 0, maxOutputTokens: 1000 },
        }),
        signal: controller.signal,
      }
    );
    clearTimeout(timeout);

    if (!resp.ok) return [];
    const data = await resp.json() as any;
    const text = data?.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
    const jsonMatch = text.match(/\[[\s\S]*\]/);
    if (!jsonMatch) return [];

    return JSON.parse(jsonMatch[0]) as ExtractedClaim[];
  } catch {

exec
/bin/bash -lc 'grep -R "DASHSCOPE_BASE_URL" -n packages/chatbot-core/src | head' in /home/enio/egos
 succeeded in 0ms:
packages/chatbot-core/src/model-router.ts:22:export const DASHSCOPE_BASE_URL = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';
packages/chatbot-core/src/model-router.ts:33:    baseUrl: DASHSCOPE_BASE_URL,
packages/chatbot-core/src/model-router.ts:40:    baseUrl: DASHSCOPE_BASE_URL,
packages/chatbot-core/src/index.ts:27:  DASHSCOPE_BASE_URL,

codex
I did not find any introduced code defects in the diff against the provided merge base. The functional changes (DashScope endpoint migration, provider key probe hardening, and secret removal) appear internally consistent and actionable without obvious breakage.
I did not find any introduced code defects in the diff against the provided merge base. The functional changes (DashScope endpoint migration, provider key probe hardening, and secret removal) appear internally consistent and actionable without obvious breakage.
```
