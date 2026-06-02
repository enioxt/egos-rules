# Codex Local Review — 2026-06-01T13:19:05Z

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
session id: 019e8356-8578-75f0-8cef-a61587eeca5f
--------
user
changes against 'HEAD~3'
2026-06-01T13:19:06.949696Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:19:06.956358Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T13:19:11.488846Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:19:11.785974Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:19:11.933885Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T13:19:12.265257Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T13:19:12.892978Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T13:19:13.885015Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T13:19:15.600271Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T13:19:19.225861Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff c732bded38e9995ad495233c09cddbfb8e963322' in /home/enio/egos
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
/bin/bash -lc "sed -n '1,220p' packages/chatbot-core/src/model-router.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * @egos/chatbot-core — 3-tier model router
 *
 * Selects the best available model tier for a request.
 * Tier priority: primary → fallback → fast (emergency)
 *
 * Failure triggers:
 *   - HTTP 429 (rate limit) → next tier
 *   - HTTP 5xx (server error) → next tier after 1 retry
 *   - Timeout (>30s) → next tier
 *   - No API key configured → skip tier
 */

import type { ModelTier, ModelConfig } from './types.js';

// ---------------------------------------------------------------------------
// DashScope preset (ALIBABA cloud — primary for EGOS projects)
// Docs: https://help.aliyun.com/zh/model-studio/
// ---------------------------------------------------------------------------

// INTL endpoint — international API keys (sk-ws-*) 401 on the CN host (dashscope.aliyuncs.com).
export const DASHSCOPE_BASE_URL = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions';
export const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1/chat/completions';

/**
 * Canonical 3-tier model chain for EGOS projects (April 2026 pricing).
 * Override individual tiers in ChatbotConfig.models to customize.
 */
export const EGOS_DEFAULT_MODELS: ModelConfig = {
  primary: {
    modelId: 'qwen-plus',
    providerEnvKey: 'DASHSCOPE_API_KEY',
    baseUrl: DASHSCOPE_BASE_URL,
    inputCostPerMillion: 0.40,
    outputCostPerMillion: 1.20,
  },
  fallback: {
    modelId: 'deepseek-chat-v3-0324',
    providerEnvKey: 'DASHSCOPE_API_KEY',
    baseUrl: DASHSCOPE_BASE_URL,
    inputCostPerMillion: 0.20,
    outputCostPerMillion: 0.77,
  },
  fast: {
    // Emergency tier — OpenRouter hosted, no DashScope required
    modelId: 'meta-llama/llama-4-maverick:free',
    providerEnvKey: 'OPENROUTER_API_KEY',
    baseUrl: OPENROUTER_BASE_URL,
    inputCostPerMillion: 0,
    outputCostPerMillion: 0,
  },
};

// ---------------------------------------------------------------------------
// Tier resolution
// ---------------------------------------------------------------------------

export interface ResolvedTier {
  tier: ModelTier;
  tierName: 'primary' | 'fallback' | 'fast';
  apiKey: string;
}

/**
 * Resolve which tier to use based on available API keys.
 * Returns tiers in priority order (primary first).
 */
export function resolveTiers(models: ModelConfig): ResolvedTier[] {
  const candidates: Array<{ tier: ModelTier; tierName: 'primary' | 'fallback' | 'fast' }> = [
    { tier: models.primary, tierName: 'primary' },
    ...(models.fallback ? [{ tier: models.fallback, tierName: 'fallback' as const }] : []),
    ...(models.fast ? [{ tier: models.fast, tierName: 'fast' as const }] : []),
  ];

  return candidates
    .map(({ tier, tierName }) => {
      const apiKey = process.env[tier.providerEnvKey] ?? '';
      return apiKey ? { tier, tierName, apiKey } : null;
    })
    .filter((t): t is ResolvedTier => t !== null);
}

// ---------------------------------------------------------------------------
// Retryable fetch with tier failover
// ---------------------------------------------------------------------------

export interface FetchResult {
  data: Record<string, unknown>;
  tierUsed: ResolvedTier;
}

const RETRYABLE_STATUSES = new Set([429, 500, 502, 503, 504]);

/**
 * POST to LLM API with automatic tier failover.
 *
 * - Tries primary tier first
 * - On 429 / 5xx / timeout → moves to next tier
 * - Throws if all tiers exhausted
 */
export async function fetchWithFailover(
  payload: Record<string, unknown>,
  models: ModelConfig,
  customHeaders: Record<string, string> = {},
): Promise<FetchResult> {
  const tiers = resolveTiers(models);

  if (tiers.length === 0) {
    throw new Error('No API key configured for any model tier');
  }

  let lastError: Error | null = null;

  for (const resolved of tiers) {
    const { tier, apiKey } = resolved;
    const baseUrl = tier.baseUrl ?? OPENROUTER_BASE_URL;
    const body = { ...payload, model: tier.modelId };

    for (let attempt = 0; attempt < 2; attempt++) {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 30_000);

        const resp = await fetch(baseUrl, {
          method: 'POST',
          signal: controller.signal,
          headers: {
            Authorization: `Bearer ${apiKey}`,
            'Content-Type': 'application/json',
            'HTTP-Referer': 'https://egos.ia.br',
            'X-Title': 'EGOS Chatbot',
            ...customHeaders,
          },
          body: JSON.stringify(body),
        });

        clearTimeout(timeoutId);

        if (RETRYABLE_STATUSES.has(resp.status)) {
          lastError = new Error(`HTTP ${resp.status} from ${tier.modelId}`);
          break; // break inner retry loop → try next tier
        }

        if (!resp.ok) {
          throw new Error(`HTTP ${resp.status}: ${await resp.text().catch(() => '')}`);
        }

        const data = (await resp.json()) as Record<string, unknown>;
        return { data, tierUsed: resolved };
      } catch (err) {
        lastError = err instanceof Error ? err : new Error(String(err));
        if (lastError.name === 'AbortError') {
          lastError = new Error(`Timeout on ${tier.modelId}`);
          break; // timeout → next tier
        }
        // Other errors: retry once within same tier
      }
    }
  }

  throw lastError ?? new Error('All model tiers failed');
}

codex
The code changes appear internally consistent and address concrete runtime issues (DashScope international endpoint compatibility and eval-runner path/drift reporting correctness) without introducing obvious regressions in the touched logic.
The code changes appear internally consistent and address concrete runtime issues (DashScope international endpoint compatibility and eval-runner path/drift reporting correctness) without introducing obvious regressions in the touched logic.
```
