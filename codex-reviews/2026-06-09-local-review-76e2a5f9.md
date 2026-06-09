# Codex Local Review — 2026-06-09T18:47:12Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.5
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019eadb5-cb40-79f3-9719-a53320a30cfa
--------
user
changes against 'HEAD~3'
2026-06-09T18:47:13.860748Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-09T18:47:13.861685Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'bun run egos:boot 2>/dev/null || cat docs/INCIDENTS/INDEX.md' in /home/enio/egos
 succeeded in 0ms:
════════════════════════════════════════════════════════════════
  EGOS BOOT — Session Priming (IDE-agnostic)
  Run by: enio @ enioxt | 2026-06-09T18:47:21Z
  Repo: egos | Branch: main | SHA: 76e2a5f9
════════════════════════════════════════════════════════════════

▲ CRITICAL NON-NEGOTIABLES (if you violate these, work stops):
  1. NEVER 'git push --force' to main. Use: bash scripts/safe-push.sh
  2. NEVER log/echo/commit secrets. Never hardcode API keys.
  3. NEVER 'git add -A' in background agents. Use: git add <specific-file>
  4. NEVER publish externally (articles, X posts, outreach) without human approval.
  5. COMMIT TASKS.md immediately after edit (parallel agents lose uncommitted state).

▲ RECENT PHANTOM INCIDENTS (last 30 days — load the one that matches your situation):
  | [INC-005](INC-005-external-llm-narrative.md) | P1 | External LLM output treated as fact | Mitigated — vocab-guard + rule #24 | External LLM text = unverified. Classify REAL/CONCEPT/PHANTOM. Verify with `git log --grep` + `Glob` before accepting any named artifact |
  | [INC-006](INC-006-kimi-windsurf-phantom.md) | P1 | Kimi/Windsurf wrote phantom scores + Explore subagent produced phantom audit | Reversed + rules #25-27 added — Layer A/B/C pending | Subagent audits = unverified. Scored SSOT tables need AUTO-GEN or per-row evidence. Use-case scoped scoring required |
  | [INC-007](INC-007-api-key-exposure.md) | **P0** | **OpenRouter API key exposed in benchmark scripts** | **RESOLVED** — key revoked, fixes committed | NEVER commit secrets. No fallback patterns. ALWAYS validate env vars. |
  | [INC-008](INC-008-phantom-compliance-stubs.md) | **P0** | **Phantom compliance stubs — PII/ATRiAN no-ops in intelink production** | **RESOLVED** — stubs wired to real impls + golden eval regression test | Any claimed capability MUST have a behavioral eval (AGENTS.md R7). Stubs in compliance code = FORBIDDEN in main. |
  | [INC-009](INC-009-leaf-silo-work.md) | P1 | **Leaf-repo silo-work — agente cria SSOT paralelo ignorando canonical existente** | RESOLVED — rule R2.5 (reuse-first) + `/start` LAYER 4.6 (force-read leaf SSOTs) | Antes de criar `<leaf>/docs/governance/X.md`: glob `lib/prompts/`, `lib/config/`, AGENTS.md (full), UPSTREAM_KERNEL.md. Se 1+ existe → ESTENDER, não duplicar. Sprint cross-repo exige COORD entry. |

▲ SSOT FILE HASHES (if you're about to edit one, verify the hash first):
  AGENTS.md                            sha:73cd39e195a7  lines:196  last-mod:2026-06-09
  TASKS.md                             sha:bced17cd2278  lines:933  last-mod:2026-06-09
  docs/modules/CHATBOT_SSOT.md         sha:6f3a7a9b6b70  lines:1201  last-mod:2026-05-21
  docs/CAPABILITY_REGISTRY.md          sha:f03087f2fd16  lines:3596  last-mod:2026-06-08
  .windsurfrules                       sha:145e4b5931c8  lines:169  last-mod:2026-05-11

▲ VERIFICATION PROTOCOL (applies to any claim about code or scored tables):
  - Code claims (function exists, caller count, import): use codebase-memory-mcp
    search_graph / get_code_snippet / trace_call_path — FIRST. Read/Grep = fallback.
  - External LLM paste: every named feature = UNVERIFIED. Classify REAL/CONCEPT/PHANTOM
    via 'git log --grep' + 'Glob'. See INC-005.
  - Subagent audit: outputs are SYNTHESIS, not evidence. Re-verify top 3 claims
    via codebase-memory-mcp before citing. See INC-006.
  - Scored SSOT tables (Compliance/Score/%/Coverage columns): must be AUTO-GEN
    block OR per-row VERIFIED_AT + method + evidence anchor. See INC-006 + R2.1.
  - Use-case scoped scoring: cannot apply uniform rubric across heterogeneous
    products. Declare use case first. See INC-006 + R2.2.

▲ CURRENT STATE: health=?%  P0 blockers=0

════════════════════════════════════════════════════════════════
  BOOT COMPLETE. Read full rules: AGENTS.md R0-R6. Full incidents: docs/INCIDENTS/
════════════════════════════════════════════════════════════════

exec
/bin/bash -lc 'git diff --stat 26f8ee3a659082a9799e6aa677f99f735c0d4af1 && git diff --name-only 26f8ee3a659082a9799e6aa677f99f735c0d4af1' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/pesquisa.md                      |  271 +++++
 TASKS.md                                          |    1 +
 apps/egos-gateway/Dockerfile                      |   12 +-
 apps/egos-gateway/package.json                    |    1 +
 apps/egos-landing/public/timeline/rss             |    2 +-
 apps/egos-landing/public/timeline/rss.xml         |    2 +-
 docs/governance/HTML_GENERATION_CONSTITUTION.md   |  852 ++++++++++++++
 docs/jobs/2026-06-09-doc-drift-verifier.json      |    4 +-
 docs/jobs/2026-06-09-pre-commit-pipeline.json     |   48 +
 docs/tutor/conselho-registro.html                 | 1278 +++++++++++++++++++++
 docs/tutor/hitl-curve-principle.html              | 1269 ++++++++++++++++++++
 docs/tutor/processo-arquiteto-diagnosticador.html | 1070 +++++++++++++++++
 scripts/hermes-trigger.sh                         |   26 +-
 13 files changed, 4821 insertions(+), 15 deletions(-)
.claude/commands/pesquisa.md
TASKS.md
apps/egos-gateway/Dockerfile
apps/egos-gateway/package.json
apps/egos-landing/public/timeline/rss
apps/egos-landing/public/timeline/rss.xml
docs/governance/HTML_GENERATION_CONSTITUTION.md
docs/jobs/2026-06-09-doc-drift-verifier.json
docs/jobs/2026-06-09-pre-commit-pipeline.json
docs/tutor/conselho-registro.html
docs/tutor/hitl-curve-principle.html
docs/tutor/processo-arquiteto-diagnosticador.html
scripts/hermes-trigger.sh

exec
/bin/bash -lc 'git diff 26f8ee3a659082a9799e6aa677f99f735c0d4af1 -- apps/egos-gateway/Dockerfile apps/egos-gateway/package.json scripts/hermes-trigger.sh docs/jobs/2026-06-09-pre-commit-pipeline.json docs/jobs/2026-06-09-doc-drift-verifier.json apps/egos-landing/public/timeline/rss apps/egos-landing/public/timeline/rss.xml TASKS.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index c166161e..87675a74 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -117,6 +117,7 @@
 - [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
 - [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
 - [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
+- [x] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — 2026-06-09: GitHub Push Protection pegou secrets REAIS em artefatos `~/.egos/codex-reviews/*.md` (review notes citaram chaves de diffs). Scrubei do push (redact + amend, push limpo bc2aad3). MAS os VALORES podem estar vivos → **Enio decide rotação**: (1) Supabase `SUPABASE_ACCESS_TOKEN=sbp_…` + PGPASSWORD `***REVOKED***` (PROVÁVEL VIVO — rotar); (2) Google `AIzaSyBrM3…` (provável morto, estava em diff de rotação); (3) Alibaba `sk-d2c…` (morto, Alibaba OFF). Causa-raiz: codex-review captura settings.json/diffs com secrets inline → adicionar scrub de PII/secret no gerador de codex-review (hermes-commit-review.ts). ✅ 2026-06-09
 
 ## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
 > Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
diff --git a/apps/egos-gateway/Dockerfile b/apps/egos-gateway/Dockerfile
index 536a994e..6a21a4c3 100644
--- a/apps/egos-gateway/Dockerfile
+++ b/apps/egos-gateway/Dockerfile
@@ -1,8 +1,14 @@
+# EGOS Gateway — bundle-runtime (VPS-GATEWAY-AUTOSYNC-001, 2026-06-09)
+# O gateway é deployado como cópia standalone em /opt/egos-gateway, onde
+# `workspace:*` deps (@egosbr/guard-brasil) NÃO resolvem via bun install.
+# Solução: o deploy bundla src/server.ts → dist/server.js (maskPII inlined,
+# self-contained) NO MONOREPO, e o container só RODA o bundle — sem install.
+# Dev local roda via `bun run src/server.ts` (não usa este Dockerfile).
 FROM oven/bun:1.3
 WORKDIR /app
-COPY package.json bun.lock* ./
-RUN bun install --frozen-lockfile 2>/dev/null || bun install
 COPY . .
 ENV GATEWAY_PORT=3050
 EXPOSE 3050
-CMD ["bun", "run", "src/server.ts"]
+# dist/server.js é buildado pelo deploy (scripts/hermes-trigger.sh autosync ou
+# `bun run build`) ANTES do docker build. Sem bun install: bundle é autossuficiente.
+CMD ["bun", "dist/server.js"]
diff --git a/apps/egos-gateway/package.json b/apps/egos-gateway/package.json
index 816b9405..c665c5f4 100644
--- a/apps/egos-gateway/package.json
+++ b/apps/egos-gateway/package.json
@@ -6,6 +6,7 @@
   "scripts": {
     "dev": "bun run --env-file ../../.env --watch src/server.ts",
     "start": "bun run --env-file ../../.env src/server.ts",
+    "build": "bun build src/server.ts --target bun --outfile dist/server.js",
     "typecheck": "tsc --noEmit"
   },
   "dependencies": {
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 986b4d5e..adc532e6 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
+    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 986b4d5e..adc532e6 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Mon, 08 Jun 2026 00:41:14 GMT</lastBuildDate>
+    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/jobs/2026-06-09-doc-drift-verifier.json b/docs/jobs/2026-06-09-doc-drift-verifier.json
index 1486fa51..d3c4a3fa 100644
--- a/docs/jobs/2026-06-09-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-09-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-09T14:17:54.238Z",
+  "verified_at": "2026-06-09T18:12:56.852Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1286",
+      "current_value": "1294",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-09-pre-commit-pipeline.json b/docs/jobs/2026-06-09-pre-commit-pipeline.json
index befedf8b..b2a0cba8 100644
--- a/docs/jobs/2026-06-09-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-09-pre-commit-pipeline.json
@@ -118,5 +118,53 @@
     "duration_ms": null,
     "event": "commit:chore files=4 sha=ee38e623",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:51:42.179Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=4945ff28",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T17:54:17.785Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=4 sha=83748a2e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:12:58.880Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=11 sha=26f8ee3a",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:31:18.782Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=3 sha=afee6fd9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:38:56.577Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=5 sha=b17894a1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-09T18:47:03.705Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=76e2a5f9",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/scripts/hermes-trigger.sh b/scripts/hermes-trigger.sh
index c74bf97c..771bd96d 100755
--- a/scripts/hermes-trigger.sh
+++ b/scripts/hermes-trigger.sh
@@ -67,14 +67,24 @@ GW_DIR="/opt/egos-gateway"
 if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
   GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
   if [ -n "$GW_CHANGED" ]; then
-    log "gateway changed ($PREV_SHA -> $NEW_SHA) — syncing $GW_DIR"
-    rsync -a --exclude=node_modules --exclude=.env "$REPO/apps/egos-gateway/" "$GW_DIR/" \
-      && log "rsync OK" \
-      || log "WARN: rsync failed"
-    cd "$GW_DIR" && docker compose build --no-cache -q \
-      && docker compose up -d \
-      && log "gateway rebuilt and restarted" \
-      || log "WARN: docker rebuild failed"
+    log "gateway changed ($PREV_SHA -> $NEW_SHA) — building bundle + syncing $GW_DIR"
+    # 1. build guard-brasil dist (tsc emite mesmo com type-errors pré-existentes)
+    ( cd "$REPO/packages/guard-brasil" && bun run build >/dev/null 2>&1 ) || log "WARN: guard-brasil build non-zero (dist provavelmente emitido)"
+    # 2. garante symlink workspace p/ o bundler resolver @egosbr/guard-brasil
+    mkdir -p "$REPO/node_modules/@egosbr" && ln -sfn ../../packages/guard-brasil "$REPO/node_modules/@egosbr/guard-brasil"
+    # 3. rsync fonte (exclui dist — será buildado direto no destino)
+    rsync -a --exclude=node_modules --exclude=.env --exclude=dist "$REPO/apps/egos-gateway/" "$GW_DIR/" \
+      && log "rsync OK" || log "WARN: rsync failed"
+    # 4. bundle self-contained (maskPII inlined) direto no destino
+    mkdir -p "$GW_DIR/dist"
+    ( cd "$REPO" && bun build apps/egos-gateway/src/server.ts --target bun --outfile "$GW_DIR/dist/server.js" ) \
+      && log "bundle built ($(grep -c REMOVIDO "$GW_DIR/dist/server.js" 2>/dev/null) PII refs)" \
+      || { log "ERROR: bundle build failed — abortando deploy (gateway atual preservado)"; cd "$REPO"; echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"; }
+    # 5. rebuild container só roda o bundle (Dockerfile sem install)
+    if [ -f "$GW_DIR/dist/server.js" ]; then
+      cd "$GW_DIR" && docker compose build --no-cache -q && docker compose up -d \
+        && log "gateway rebuilt and restarted" || log "WARN: docker rebuild failed"
+    fi
     cd "$REPO"
   fi
 fi

exec
/bin/bash -lc "nl -ba scripts/hermes-trigger.sh | sed -n '1,130p'
nl -ba TASKS.md | sed -n '110,125p'
nl -ba apps/egos-gateway/Dockerfile | sed -n '1,80p'" in /home/enio/egos
 succeeded in 0ms:
     1	#!/usr/bin/env bash
     2	# EGOS Hermes Event-Driven Trigger
     3	# Invoked via SSH from .husky/post-push (async) and as cron fallback.
     4	#
     5	# Architecture (validated by Codex 2026-05-27):
     6	#   - Atomic lock via `mkdir` (TOCTOU-safe; touch+test would race).
     7	#   - Debounce: skip if last successful RUN < 600s ago.
     8	#   - --since=2h with DEDUP-001 SHA marker (no re-processing risk).
     9	#   - Cron fallback every 2h covers missed pushes / commit-without-push.
    10	
    11	set -u
    12	
    13	REPO="${EGOS_REPO_PATH:-/opt/egos-git}"
    14	# SECURITY: whitelist allowed repo paths — prevents env-injection redirection
    15	case "$REPO" in
    16	  /opt/egos-git|/opt/egos) ;;
    17	  *) echo "[$(date -Iseconds)] hermes-trigger: FATAL invalid REPO=$REPO" >&2; exit 2 ;;
    18	esac
    19	
    20	STATE_DIR="$REPO/.hermes-state"
    21	LOCKDIR="$STATE_DIR/lock.d"
    22	RUN_TS_FILE="$STATE_DIR/last_run_ts"
    23	LOG="${HERMES_LOG:-/var/log/egos/hermes-review.log}"
    24	DEBOUNCE_SECS="${HERMES_DEBOUNCE_SECS:-600}"
    25	SINCE="${HERMES_SINCE:-2h}"
    26	STALE_LOCK_MIN="${HERMES_STALE_LOCK_MIN:-30}"
    27	
    28	mkdir -p "$STATE_DIR" "$(dirname "$LOG")"
    29	
    30	ts() { date -Iseconds; }
    31	log() { echo "[$(ts)] hermes-trigger: $*" >> "$LOG"; }
    32	
    33	NOW=$(date +%s)
    34	LAST_RUN=$(cat "$RUN_TS_FILE" 2>/dev/null || echo 0)
    35	DELTA=$((NOW - LAST_RUN))
    36	
    37	# Debounce: protects against rapid-fire pushes during active session.
    38	if [ "$LAST_RUN" -gt 0 ] && [ "$DELTA" -lt "$DEBOUNCE_SECS" ]; then
    39	  log "debounced (delta=${DELTA}s < ${DEBOUNCE_SECS}s)"
    40	  exit 0
    41	fi
    42	
    43	# Reap stale lock (process killed mid-run leaves lockdir behind).
    44	if [ -d "$LOCKDIR" ]; then
    45	  find "$LOCKDIR" -maxdepth 0 -mmin +"$STALE_LOCK_MIN" -exec rmdir {} \; 2>/dev/null \
    46	    && log "WARN: reaped stale lock (>${STALE_LOCK_MIN}min)"
    47	fi
    48	
    49	# Atomic lock — only one Hermes run at a time.
    50	if ! mkdir "$LOCKDIR" 2>/dev/null; then
    51	  log "locked (another run in progress)"
    52	  exit 0
    53	fi
    54	trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT
    55	
    56	cd "$REPO" || { log "FATAL: cannot cd to $REPO"; exit 1; }
    57	HEAD_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
    58	RUN_ID="${NOW}-$$"
    59	log "starting run_id=$RUN_ID head=$HEAD_SHA delta=${DELTA}s since=${SINCE}"
    60	
    61	PREV_SHA=$(cat "$STATE_DIR/last_gw_sha" 2>/dev/null || echo "")
    62	git pull --ff-only -q 2>/dev/null || log "WARN: git pull --ff-only failed (run_id=$RUN_ID)"
    63	NEW_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
    64	
    65	# VPS-GATEWAY-AUTOSYNC-001: sync /opt/egos-gateway when apps/egos-gateway/ changed
    66	GW_DIR="/opt/egos-gateway"
    67	if [ -d "$GW_DIR" ] && [ "$PREV_SHA" != "$NEW_SHA" ]; then
    68	  GW_CHANGED=$(git diff --name-only "$PREV_SHA" "$NEW_SHA" 2>/dev/null | grep "^apps/egos-gateway/" || true)
    69	  if [ -n "$GW_CHANGED" ]; then
    70	    log "gateway changed ($PREV_SHA -> $NEW_SHA) — building bundle + syncing $GW_DIR"
    71	    # 1. build guard-brasil dist (tsc emite mesmo com type-errors pré-existentes)
    72	    ( cd "$REPO/packages/guard-brasil" && bun run build >/dev/null 2>&1 ) || log "WARN: guard-brasil build non-zero (dist provavelmente emitido)"
    73	    # 2. garante symlink workspace p/ o bundler resolver @egosbr/guard-brasil
    74	    mkdir -p "$REPO/node_modules/@egosbr" && ln -sfn ../../packages/guard-brasil "$REPO/node_modules/@egosbr/guard-brasil"
    75	    # 3. rsync fonte (exclui dist — será buildado direto no destino)
    76	    rsync -a --exclude=node_modules --exclude=.env --exclude=dist "$REPO/apps/egos-gateway/" "$GW_DIR/" \
    77	      && log "rsync OK" || log "WARN: rsync failed"
    78	    # 4. bundle self-contained (maskPII inlined) direto no destino
    79	    mkdir -p "$GW_DIR/dist"
    80	    ( cd "$REPO" && bun build apps/egos-gateway/src/server.ts --target bun --outfile "$GW_DIR/dist/server.js" ) \
    81	      && log "bundle built ($(grep -c REMOVIDO "$GW_DIR/dist/server.js" 2>/dev/null) PII refs)" \
    82	      || { log "ERROR: bundle build failed — abortando deploy (gateway atual preservado)"; cd "$REPO"; echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"; }
    83	    # 5. rebuild container só roda o bundle (Dockerfile sem install)
    84	    if [ -f "$GW_DIR/dist/server.js" ]; then
    85	      cd "$GW_DIR" && docker compose build --no-cache -q && docker compose up -d \
    86	        && log "gateway rebuilt and restarted" || log "WARN: docker rebuild failed"
    87	    fi
    88	    cd "$REPO"
    89	  fi
    90	fi
    91	echo "$NEW_SHA" > "$STATE_DIR/last_gw_sha"
    92	
    93	HOME=/root bun scripts/hermes-commit-review.ts --since="$SINCE" >> "$LOG" 2>&1
    94	RC=$?
    95	
    96	# NLM-HERMES-002b: Run NotebookLM document sync detector
    97	log "running notebook-sync-detect (run_id=$RUN_ID)"
    98	HOME=/root bun scripts/notebook-sync-detect.ts --exec >> "$LOG" 2>&1
    99	DETECT_RC=$?
   100	if [ "$DETECT_RC" -ne 0 ]; then
   101	  log "WARN: notebook-sync-detect failed with rc=$DETECT_RC (run_id=$RUN_ID)"
   102	fi
   103	
   104	# Stamp with fresh timestamp (NOT pre-run NOW) — protects post-run quiet period.
   105	if [ "$RC" -eq 0 ]; then
   106	  date +%s > "$RUN_TS_FILE"
   107	  log "done OK run_id=$RUN_ID"
   108	else
   109	  log "done FAIL run_id=$RUN_ID rc=$RC (timestamp NOT updated)"
   110	fi
   111	
   112	exit "$RC"
   110	
   111	## 🛡️ GOVERNANÇA & DISSEMINAÇÃO — follow-ups (Enio 2026-06-03)
   112	- [ ] **FRAMEWORK-DISSEMINATE-ALL-001** [P1] `prime` — Garantir que o conhecimento do framework EGOS está disseminado em TODOS os ambientes (Claude Code ✓ · Antigravity/Gemini · Hermes VPS · Windows/Android futuros). Cada ambiente carrega identidade+regras no boot.
   113	- [ ] **DEPLOY-PROVENANCE-001** [P2] — `apps/api/deploy.sh` precisa provenance (sourceRepo/sourceBranch/sourceSha/remotePath/deployedAt) p/ commitar (CPF-exemplo já mascarado no working tree).
   114	- [ ] **MEMORY-DEDUP-ENGINE-001** [P1] `prime`/`forja` — RAIZ (Banda+Codex): construir no `packages/mcp-memory` (TDD) — (a) dedup-na-escrita (cosine/claim_key, checar relacionados antes de criar); (b) supersessão (claim_key marca superseded, exclui do recall); (c) reconciliar split de store (`~/.egos/memory/mcp-store/` vs `~/.claude/projects/.../memory/`); (d) opcional decay. egos-memory MCP v0.2.0 hoje só keyword store/recall (CONFIRMADO, source lido). Refs OSS: ashnode/agent-knowledge/conch/distill.
   115	- [ ] **MEMORY-ARCHIVE-001** [P2] `prime` — Criar `MEMORY_ARCHIVE.md` + mover entradas frias do MEMORY.md (652L/329). DEPOIS de MEMORY-DEDUP-ENGINE-001 (detecção de superseded popula o archive; evita corte arbitrário por idade).
   116	- [ ] **ESSENTIAL-FILES-ENFORCE-001** [P2] `prime` — Wire warn-only (Sentinela varre last_update→REVISAR >60d; /start avisa limites). Só DEPOIS do dedup. Comandos NUNCA bloqueiam. Resolver conflito AGENTS.md 200vs400.
   117	- [ ] **KNOWLEDGE-INGEST-CHANNEL-001** [P1] `prime`+`curador` — Canal de ingestão do Enio (Enio 2026-06-08, APROVADO construir): ele dropa .md de ChatGPT/Grok/notas/estudos → atomiza→memória/RAG. Criar `docs/_inbox/ingest/` + pipeline (anonimizar→atomizar→linkar→arquivar) + `/process-inbox`. NÃO feito (registrado só).
   118	- [ ] **TASKS-OVERFLOW-001** [P0] `prime` — TASKS.md em 909L (hard limit 600, grace 2026-06-15). Rodar `bun scripts/tasks-archive.ts --exec` imediatamente para mover tasks concluídas para TASKS_ARCHIVE.md.
   119	- [ ] **PII-GATE-HISTORY-001** [P1] `guardiao` `gated:HITL` — gap residual: `loadHistory` carrega turnos pré-gate do Supabase `egos_chat_history` que podem conter PII crua (anterior ao gate). Decidir (corte Enio): (a) scan/mask no loadHistory também, ou (b) aceitar histórico pré-gate. Novo histórico já é mascarado (saveHistory pós-gate).
   120	- [x] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — 2026-06-09: GitHub Push Protection pegou secrets REAIS em artefatos `~/.egos/codex-reviews/*.md` (review notes citaram chaves de diffs). Scrubei do push (redact + amend, push limpo bc2aad3). MAS os VALORES podem estar vivos → **Enio decide rotação**: (1) Supabase `SUPABASE_ACCESS_TOKEN=sbp_…` + PGPASSWORD `***REVOKED***` (PROVÁVEL VIVO — rotar); (2) Google `AIzaSyBrM3…` (provável morto, estava em diff de rotação); (3) Alibaba `sk-d2c…` (morto, Alibaba OFF). Causa-raiz: codex-review captura settings.json/diffs com secrets inline → adicionar scrub de PII/secret no gerador de codex-review (hermes-commit-review.ts). ✅ 2026-06-09
   121	
   122	## 🌐 POSICIONAMENTO PÚBLICO & FRONTEND (Enio 2026-06-04 — ChatGPT brief + cortes)
   123	> Contexto: regras gravadas nesta sessão (proveniência-por-ação no `~/.claude/CLAUDE.md` §1; sync FE/BE no `CLAUDE.md`). Diagnóstico interno FEITO (`docs/strategy/EGOS_ECOSYSTEM_DIAGNOSIS.md`). Copy pública = Red Zone (HITL+Guardião).
   124	- [ ] **FE-BE-SYNC-GATE-001** [P1] `forja` — Implementar o gate que mede razão frontend/backend e, quando backend evolui >20% além do FE, GERA tasks priorizadas de frontend (não bloqueia). Regra em `CLAUDE.md §Convenções`. Definir métrica (ex: LOC/endpoints BE vs telas/componentes FE) + onde roda (pre-commit advisory ou `/start`).
   125	- [ ] **TOOLS-PAGE-COMPLETE-001** [P1] — `egos.ia.br/tools` completa: todas as tools disponíveis (BE+FE) p/ testar ao vivo, entrada correta, documentadas, com metaprompts. 🔄 PARCIAL 2026-06-04: hub `#/tools` LIVE (Guard Brasil + Item Intake + Mycelium). Falta: metaprompts inline por tool + docs "como usar". Próx: MP-ITEM-INTAKE-001 como aba no hub.
     1	# EGOS Gateway — bundle-runtime (VPS-GATEWAY-AUTOSYNC-001, 2026-06-09)
     2	# O gateway é deployado como cópia standalone em /opt/egos-gateway, onde
     3	# `workspace:*` deps (@egosbr/guard-brasil) NÃO resolvem via bun install.
     4	# Solução: o deploy bundla src/server.ts → dist/server.js (maskPII inlined,
     5	# self-contained) NO MONOREPO, e o container só RODA o bundle — sem install.
     6	# Dev local roda via `bun run src/server.ts` (não usa este Dockerfile).
     7	FROM oven/bun:1.3
     8	WORKDIR /app
     9	COPY . .
    10	ENV GATEWAY_PORT=3050
    11	EXPOSE 3050
    12	# dist/server.js é buildado pelo deploy (scripts/hermes-trigger.sh autosync ou
    13	# `bun run build`) ANTES do docker build. Sem bun install: bundle é autossuficiente.
    14	CMD ["bun", "dist/server.js"]

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "find apps/egos-gateway -maxdepth 3 -type f -not -path '*/node_modules/*' -print | sort && cat apps/egos-gateway/package.json && sed -n '1,240p' apps/egos-gateway/src/server.ts && [ -f apps/egos-gateway/docker-compose.yml ] && cat apps/egos-gateway/docker-compose.yml || true" in /home/enio/egos
 succeeded in 0ms:
apps/egos-gateway/.dockerignore
apps/egos-gateway/Dockerfile
apps/egos-gateway/README.md
apps/egos-gateway/bun.lock
apps/egos-gateway/dist/server.js
apps/egos-gateway/docker-compose.yml
apps/egos-gateway/guardrails.yaml
apps/egos-gateway/openapi.yaml
apps/egos-gateway/package.json
apps/egos-gateway/scripts/smoke-cross-tenant.sh
apps/egos-gateway/src/channels/chat.ts
apps/egos-gateway/src/channels/discover.ts
apps/egos-gateway/src/channels/gem-hunter-api.ts
apps/egos-gateway/src/channels/guard-brasil.ts
apps/egos-gateway/src/channels/knowledge.ts
apps/egos-gateway/src/channels/lgpd.ts
apps/egos-gateway/src/channels/telegram.ts
apps/egos-gateway/src/channels/ui.ts
apps/egos-gateway/src/channels/v1.ts
apps/egos-gateway/src/channels/whatsapp.ts
apps/egos-gateway/src/health-monitor.ts
apps/egos-gateway/src/orchestrator.ts
apps/egos-gateway/src/pii-gate.test.ts
apps/egos-gateway/src/server.ts
apps/egos-gateway/src/tenants/index.ts
apps/egos-gateway/supabase/migrations/001_g_pecas_demo.sql
apps/egos-gateway/tsconfig.json
{
  "name": "@egos/gateway",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "bun run --env-file ../../.env --watch src/server.ts",
    "start": "bun run --env-file ../../.env src/server.ts",
    "build": "bun build src/server.ts --target bun --outfile dist/server.js",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@egosbr/guard-brasil": "workspace:*",
    "hono": "^4.6.0"
  },
  "devDependencies": {
    "@types/bun": "^1.1.0",
    "typescript": "^5.6.0"
  }
}
/**
 * EGOS Gateway — Main Server v0.3.0
 *
 * Central ingress for external channel webhooks and chatbot interactions.
 * Runs on Hono + Bun.
 *
 * Routes:
 *   GET  /health                — gateway health
 *   GET  /ui                    — Knowledge System visual dashboard
 *   GET  /knowledge/*           — Knowledge API (wiki pages + learnings)
 *   GET  /gem-hunter/*          — Gem Hunter API (discovery engine)
 *   POST /channels/whatsapp/*   — Evolution API webhooks → AI Orchestrator
 *   POST /telegram/webhook      — Telegram bot webhook (egosin_bot)
 *   GET  /telegram/health       — Telegram channel health
 *   POST /telegram/setup-webhook — Register Telegram webhook URL
 *   GET  /guard-brasil/health   — x402 channel health (free)
 *   POST /guard-brasil/inspect  — PII inspection ($0.001 USDC via x402)
 */

import { Hono } from "hono";
import { logger } from "hono/logger";
import { whatsapp } from "./channels/whatsapp.js";
import { knowledge } from "./channels/knowledge.js";
import { ui } from "./channels/ui.js";
import { gemHunter } from "./channels/gem-hunter-api.js";
import { telegram, startTelegramPolling } from "./channels/telegram.js";
import { guardBrasil } from "./channels/guard-brasil.js";
import { lgpd } from "./channels/lgpd.js";
import { chat } from "./channels/chat.js";
import { discover } from "./channels/discover.js";
import { startHealthMonitor, startBudgetMonitor } from "./health-monitor.js";
import { v1 } from "./channels/v1.js";

const app = new Hono();
const PORT = Number(process.env.GATEWAY_PORT ?? 3000);

// ─── Middleware ────────────────────────────────────────────────────────────────

app.use("*", logger());

// ─── Routes ───────────────────────────────────────────────────────────────────

app.get("/health", (c) => {
  return c.json({
    service: "egos-gateway",
    version: "0.4.0",
    uptime: process.uptime(),
    channels: ["whatsapp", "telegram", "knowledge", "gem-hunter", "guard-brasil-x402", "api-mestra-v1"],
    ui: "/ui",
    openapi: "/openapi.yaml",
    docs: {
      whatsapp: "/channels/whatsapp/health",
      telegram: "/telegram/health",
      knowledge: "/knowledge/stats",
      "gem-hunter": "/gem-hunter/product",
      "guard-brasil": "/guard-brasil/health",
      "api-mestra": "/v1/",
    },
  });
});

app.route("/ui", ui);
app.route("/channels/whatsapp", whatsapp);
app.route("/telegram", telegram);
app.route("/knowledge", knowledge);
app.route("/gem-hunter", gemHunter);
app.route("/guard-brasil", guardBrasil);
app.route("/api/lgpd", lgpd);
app.route("/api/chat", chat);
app.route("/api/chatbots", discover);
app.route("/v1", v1);

// Serve OpenAPI spec (API-009)
app.get("/openapi.yaml", async (c) => {
  const { readFileSync } = await import("fs");
  const { join, dirname } = await import("path");
  const { fileURLToPath } = await import("url");
  const dir = dirname(fileURLToPath(import.meta.url));
  const spec = readFileSync(join(dir, "../../openapi.yaml"), "utf-8");
  return c.text(spec, 200, { "Content-Type": "application/yaml" });
});

app.get("/openapi.json", async (c) => {
  const { readFileSync } = await import("fs");
  const { join, dirname } = await import("path");
  const { fileURLToPath } = await import("url");
  const dir = dirname(fileURLToPath(import.meta.url));
  const spec = readFileSync(join(dir, "../../openapi.yaml"), "utf-8");
  // Return YAML as-is with correct content type for tools that prefer JSON
  return c.text(spec, 200, { "Content-Type": "application/yaml", "X-Format": "yaml" });
});

// ─── Start ────────────────────────────────────────────────────────────────────

console.log(`[egos-gateway] v0.4.0 — starting on port ${PORT}`);
console.log(`[egos-gateway] UI:          http://localhost:${PORT}/ui`);
console.log(`[egos-gateway] WhatsApp:    http://localhost:${PORT}/channels/whatsapp/health`);
console.log(`[egos-gateway] Telegram:    http://localhost:${PORT}/telegram/health`);
console.log(`[egos-gateway] Gem Hunter:  http://localhost:${PORT}/gem-hunter/health`);

// Start Telegram long-polling (runs in background)
// Switch to webhook when gateway is deployed to VPS:
//   curl -X POST http://localhost:3000/telegram/setup-webhook -d '{"webhookUrl":"https://gateway.egos.ia.br"}'
startTelegramPolling().catch(console.error);

// Start health monitor — alerts via Telegram when system health < 40% (START-009)
startHealthMonitor();

// Start budget monitor — alerts via WhatsApp when client API spend > 80% (ROUTER-003)
startBudgetMonitor();

export default {
  port: PORT,
  fetch: app.fetch,
};
services:
  egos-gateway:
    build: .
    container_name: egos-gateway
    restart: unless-stopped
    ports:
      - "127.0.0.1:3050:3050"
    env_file:
      - .env
    environment:
      - GATEWAY_PORT=3050
    networks:
      - infra_bracc
      - evolution-api_default

networks:
  infra_bracc:
    external: true
  evolution-api_default:
    external: true

exec
/bin/bash -lc 'cat apps/egos-gateway/.dockerignore && git diff --name-status 26f8ee3a659082a9799e6aa677f99f735c0d4af1 -- apps/egos-gateway' in /home/enio/egos
 succeeded in 0ms:
node_modules
.env
.env.local
*.log
.git
M	apps/egos-gateway/Dockerfile
M	apps/egos-gateway/package.json

exec
/bin/bash -lc "git diff 26f8ee3a659082a9799e6aa677f99f735c0d4af1 -- .claude/commands/pesquisa.md docs/governance/HTML_GENERATION_CONSTITUTION.md | sed -n '1,260p'" in /home/enio/egos
 succeeded in 0ms:
diff --git a/.claude/commands/pesquisa.md b/.claude/commands/pesquisa.md
new file mode 100644
index 00000000..76d88f93
--- /dev/null
+++ b/.claude/commands/pesquisa.md
@@ -0,0 +1,271 @@
+---
+description: /pesquisa <tema> — Protocolo de pesquisa rigorosa multi-modal do EGOS. DATE-FIRST + fontes obrigatórias (arXiv/GitHub/X/Reddit/web/docs) + classificação REAL/CONCEPT/PHANTOM + tabela de achados + síntese + lacunas + 3 perguntas afiadas.
+---
+
+# /pesquisa — Protocolo de Pesquisa Rigorosa EGOS
+
+> **Composável com:** `/deep-research` (para relatório longo com fan-out) | **Escopo:** pesquisa curta a média, invocável inline | **Idioma de saída:** PT-BR
+
+---
+
+## REGRA DE OURO — DATE-FIRST [OBRIGATÓRIO, sem exceção]
+
+**ANTES de qualquer busca:**
+
+```bash
+date +%F   # usar a data real do sistema, não a data de treinamento do modelo
+```
+
+Se `date` não estiver acessível, usar a data fornecida no contexto da sessão (campo `currentDate` no system prompt ou memória). Hoje é **2026-06-09** (âncora desta versão).
+
+**Por que isso importa:** modelos de linguagem têm cutoff de treinamento. Pesquisa sobre tecnologia, papers e mercado de 2024/2025 é frequentemente desconhecida. Toda busca usa a data atual como âncora de recência: descarta fontes sem data ou com data >18 meses sem avisar explicitamente.
+
+---
+
+## Fase 0 — Briefing da pesquisa (30 segundos)
+
+Antes de buscar, articular em voz alta:
+
+```
+TEMA: <o que exatamente estou pesquisando>
+DECISÃO DEPENDENTE: <que decisão ou ação depende desta pesquisa>
+PROFUNDIDADE: surface (5min) | standard (15min) | deep (composar com /deep-research)
+DATA ÂNCORA: <data de hoje obtida acima>
+```
+
+Se o tema for ambíguo (ex: "pesquisa IA para mim"), fazer **2-3 perguntas de escopo** antes de executar — não adivinhar.
+
+---
+
+## Fase 1 — Fontes obrigatórias multi-modais
+
+Executar as buscas **em paralelo** quando possível (Agent tool ou múltiplas chamadas simultâneas).
+
+### 1a. arXiv — Papers acadêmicos
+
+**Ferramenta:** `mcp__claude_ai_Hugging_Face__paper_search` (se disponível) OU WebSearch com operador `site:arxiv.org`
+
+```
+Query pattern: "<tema> arxiv <ano_atual> OR <ano_anterior>"
+Fallback query: "site:arxiv.org <tema> 2025 OR 2026"
+```
+
+Extrair: título, autores, data de submissão, abstract, link. Descartar papers >2 anos sem contexto histórico explícito.
+
+### 1b. GitHub — Repos, issues, trending
+
+**Ferramenta:** WebSearch ou `mcp__claude_ai_Exa__web_search_exa`
+
+```
+Query pattern: "site:github.com <tema> stars:>100"
+Query pattern: "github <tema> trending 2025 OR 2026"
+```
+
+Extrair: repo, stars, última atualização, linguagem, README summary. Repos sem commit nos últimos 6 meses = STALE (avisar).
+
+### 1c. X.com — Opinião de praticantes e novidades
+
+**Ferramenta:** WebSearch
+
+```
+Query pattern: "site:x.com OR site:twitter.com <tema> since:<ano-mes-atual>"
+Query pattern: "<tema> x.com 2025 OR 2026"
+```
+
+Extrair: handle do autor, data do post, claim principal. Classificar como PRÁTICA-COMUM ou HEURÍSTICA (X raramente = OFICIAL).
+
+### 1d. Reddit — Discussão de comunidade e casos reais
+
+**Ferramenta:** WebSearch ou `mcp__claude_ai_Exa__web_search_exa`
+
+```
+Query pattern: "site:reddit.com/r/<subreddit_relevante> <tema>"
+Subreddits de fallback: r/MachineLearning, r/LocalLLaMA, r/programming, r/devops
+```
+
+Extrair: subreddit, upvotes (se visível), data, claim principal, consenso da thread.
+
+### 1e. Web geral — Notícias, blogs técnicos, benchmarks
+
+**Ferramenta:** WebSearch + `mcp__claude_ai_Exa__web_fetch_exa` para páginas completas
+
+```
+Query pattern: "<tema> 2026 OR 2025 site:techcrunch.com OR site:huggingface.co OR site:openai.com"
+Query pattern: "<tema> benchmark results 2025"
+```
+
+Prioridade de fontes confiáveis: documentação oficial > paper peer-reviewed > blog técnico com dados > blog opinião.
+
+### 1f. Documentação oficial
+
+**Ferramenta:** `mcp__claude_ai_Context7__resolve-library-id` + `mcp__claude_ai_Context7__query-docs` (se for biblioteca/SDK/framework)
+
+```
+Quando usar: usuário menciona ferramenta específica (React, LangChain, etc.)
+Sempre preferir sobre memória de treinamento — docs podem ter mudado
+```
+
+---
+
+## Fase 2 — Rigor e classificação
+
+Para **cada claim coletado**, aplicar dupla classificação:
+
+### Classificação A — Existência/Verificação
+
+| Label | Critério |
+|-------|----------|
+| `REAL` | Verificado via fonte primária (paper, doc oficial, repo com código rodando) |
+| `CONCEPT` | Proposto/publicado mas sem implementação verificada ou produção |
+| `PHANTOM` | Mencionado por modelo de linguagem ou source não-verificável; pode não existir |
+
+### Classificação B — Tipo de fonte
+
+| Label | Critério |
+|-------|----------|
+| `OFICIAL` | Doc oficial, paper peer-reviewed, anúncio do maintainer |
+| `PRÁTICA-COMUM` | Amplamente adotado pela comunidade com evidência (repos, threads, casos) |
+| `HEURÍSTICA` | Opinião de praticante, regra de polegar sem validação formal |
+
+**Anti-alucinação obrigatório:**
+- Nunca inventar nome de ferramenta, paper, repo ou API
+- Se não encontrou via busca real: declarar `[BUSCA SEM RESULTADO]` — nunca preencher com memória de treinamento como se fosse achado atual
+- Data de publicação da fonte é obrigatória — fonte sem data = `[DATA DESCONHECIDA]`
+
+---
+
+## Fase 3 — Verificação de lacunas de acesso
+
+Após as buscas, verificar quais fontes não foram acessadas e por quê:
+
+```
+[ ] arXiv — OK / FALHOU (motivo: ___)
+[ ] GitHub — OK / FALHOU
+[ ] X.com — OK / FALHOU
+[ ] Reddit — OK / FALHOU
+[ ] Web geral — OK / FALHOU
+[ ] Docs oficiais — OK / N/A
+[ ] Exa MCP — DISPONÍVEL / INDISPONÍVEL
+[ ] HuggingFace MCP — DISPONÍVEL / INDISPONÍVEL
+```
+
+**Se Exa não disponível:** avisar o usuário com instrução de configuração:
+```
+⚠️ Exa MCP não disponível. Para habilitar:
+   1. Obter API key em exa.ai
+   2. Adicionar ao MCP config: { "mcp__claude_ai_Exa": { "apiKey": "..." } }
+   Alternativa: WebSearch padrão cobre a maioria dos casos.
+```
+
+**Se HuggingFace MCP não disponível:** usar `site:arxiv.org` e `site:huggingface.co` via WebSearch como fallback.
+
+---
+
+## Fase 4 — Tabela de achados (formato AI→AI)
+
+```markdown
+## Achados — <TEMA> | Data pesquisa: <DATA>
+
+| # | Fonte | URL | Data pub. | Claim | Existência | Tipo fonte |
+|---|-------|-----|-----------|-------|------------|------------|
+| 1 | arXiv | https://... | 2026-05-XX | <claim em 1 frase> | REAL | OFICIAL |
+| 2 | GitHub | https://... | 2026-04-XX | <claim> | REAL | PRÁTICA-COMUM |
+| 3 | Reddit r/ML | https://... | 2026-03-XX | <claim> | CONCEPT | HEURÍSTICA |
+| 4 | Blog | https://... | [DATA DESCONHECIDA] | <claim> | PHANTOM | HEURÍSTICA |
+```
+
+Regras da tabela:
+- Mínimo 5 linhas para `standard`, 10 para `deep`
+- Ordenar por data decrescente (mais recente primeiro)
+- Claims PHANTOM aparecem na tabela mas marcados — nunca omitir, nunca promover
+
+---
+
+## Fase 5 — Síntese executiva
+
+Formato denso AI→AI (sem prosa, máximo 10 linhas):
+
+```markdown
+## Síntese — <TEMA>
+
+**Estado atual (DATA):** <1 frase do estado da arte>
+**Achado principal:** <claim mais robusto com fonte>
+**Consenso:** <há ou não consenso na comunidade — com evidência>
+**Tendência:** <direção observada nos últimos 6 meses>
+**Conflito/debate:** <onde há discordância entre fontes>
+**Relevância para EGOS:** <implicação direta para o sistema/decisão>
+```
+
+---
+
+## Fase 6 — Lacunas identificadas
+
+```markdown
+## Lacunas
+
+- **Não encontrado:** <o que foi buscado e não achou — NÃO INVENTAR>
+- **Fonte ausente:** <fonte que existiria mas não foi acessada — ex: paywall, login>
+- **Dado desatualizado:** <o que existe mas é velho demais para confiar>
+- **Busca limitada por:** <restrição técnica, rate limit, MCP indisponível>
+```
+
+---
+
+## Fase 7 — 3 Perguntas afiadas
+
+Gerar 3 perguntas que o usuário deveria se fazer a partir dos achados. Critérios:
+- Cada pergunta aponta para uma **decisão ou ação concreta**
+- Não são perguntas retóricas — têm resposta buscável
+- Ordenadas por impacto (maior primeiro)
+
+```markdown
+## 3 Perguntas afiadas
+
+1. **[IMPACTO ALTO]** <pergunta concreta que o achado levanta>
+2. **[IMPACTO MÉDIO]** <pergunta de aprofundamento>
+3. **[VALIDA PREMISSA]** <pergunta que testa a premissa central da pesquisa>
+```
+
+---
+
+## Fluxo completo (resumo operacional)
+
+```
+1. DATE-FIRST — obter data real do sistema
+2. Briefing — articular tema + decisão dependente + profundidade
+3. Buscas paralelas — 1a-1f (arXiv + GitHub + X + Reddit + web + docs)
+4. Classificar — REAL/CONCEPT/PHANTOM + OFICIAL/PRÁTICA-COMUM/HEURÍSTICA
+5. Verificar lacunas de acesso — avisar sobre MCPs indisponíveis
+6. Tabela de achados — mínimo 5 linhas com URL + data + claim + classificação
+7. Síntese — 10 linhas densas
+8. Lacunas — o que não foi encontrado (honesto, sem inventar)
+9. 3 Perguntas afiadas — apontam para decisão/ação
+```
+
+---
+
+## Integração com deep-research
+
+`/pesquisa` = protocolo curto (surface a standard). Para relatório longo com fan-out adversarial de múltiplas fontes:
+
+```
+/pesquisa <tema>           → 5-20 min, tabela + síntese + perguntas
+/deep-research <tema>      → 30-60 min, relatório completo com citações em profundidade
+```

exec
/bin/bash -lc 'cd apps/egos-gateway && rm -rf /tmp/egos-gw-build-test && mkdir -p /tmp/egos-gw-build-test && bun build src/server.ts --target bun --outfile /tmp/egos-gw-build-test/server.js >/tmp/build.out 2>&1; rc=$?; echo rc=$rc; cat /tmp/build.out; grep -E "from ['"'\\\"]@egosbr|require\\(['\\\"]@egosbr|node_modules\" -n /tmp/egos-gw-build-test/server.js | head -20 || true; ls -lh /tmp/egos-gw-build-test/server.js 2>/dev/null || true" in /home/enio/egos
 succeeded in 0ms:
rc=0
Bundled 93 modules in 22ms

  server.js  0.67 MB  (entry point)

21:// ../../node_modules/.bun/tslib@2.8.1/node_modules/tslib/tslib.js
626:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/compose.js
670:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/request/constants.js
673:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/utils/body.js
744:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/utils/url.js
944:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/request.js
1055:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/utils/html.js
1093:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/context.js
1260:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router.js
1268:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/utils/constants.js
1271:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/hono-base.js
1490:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/reg-exp-router/matcher.js
1511:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/reg-exp-router/node.js
1615:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/reg-exp-router/trie.js
1671:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/reg-exp-router/router.js
1836:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/reg-exp-router/prepared-router.js
1908:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/smart-router/router.js
1963:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/trie-router/node.js
2132:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/router/trie-router/router.js
2154:// ../../node_modules/.bun/hono@4.12.18/node_modules/hono/dist/hono.js
-rw-r--r-- 1 enio enio 656K Jun  9 15:48 /tmp/egos-gw-build-test/server.js

exec
/bin/bash -lc "git diff 26f8ee3a659082a9799e6aa677f99f735c0d4af1 | grep -nE 'sbp_|AIza|sk-[A-Za-z0-9]|PGPASSWORD|password|SECRET|TOKEN' | head -50" in /home/enio/egos
 succeeded in 0ms:
286:+- [x] **SECRET-ROTATION-CODEXREVIEW-001** [P0-T0] `guardiao` `gated:HITL-Enio` — 2026-06-09: GitHub Push Protection pegou secrets REAIS em artefatos `~/.egos/codex-reviews/*.md` (review notes citaram chaves de diffs). Scrubei do push (redact + amend, push limpo bc2aad3). MAS os VALORES podem estar vivos → **Enio decide rotação**: (1) Supabase `SUPABASE_ACCESS_TOKEN=sbp_…` + PGPASSWORD `***REVOKED***` (PROVÁVEL VIVO — rotar); (2) Google `AIzaSyBrM3…` (provável morto, estava em diff de rotação); (3) Alibaba `sk-d2c…` (morto, Alibaba OFF). Causa-raiz: codex-review captura settings.json/diffs com secrets inline → adicionar scrub de PII/secret no gerador de codex-review (hermes-commit-review.ts). ✅ 2026-06-09

codex
The patch introduces secret material into a tracked file and has a deployment-state bug that can permanently skip a failed gateway bundle update. These should be fixed before considering the change correct.

Full review comments:

- [P0] Remove live credentials from TASKS — /home/enio/egos/TASKS.md:120-120
  This line commits a real database password and recognizable token prefixes while explicitly saying the values may still be live. If this branch is pushed, mirrored, or included in review artifacts, those credentials need to be treated as exposed; redact the values from git history and track rotation without storing the secrets themselves.

- [P2] Do not mark failed gateway bundles as deployed — /home/enio/egos/scripts/hermes-trigger.sh:80-82
  When `bun build` fails, this error branch still records `NEW_SHA` as `last_gw_sha` here, so later runs see `PREV_SHA == NEW_SHA` and skip the gateway diff even though the new bundle was never deployed. If the build failure is transient or fixed outside a new `apps/egos-gateway` commit, the gateway remains on the old bundle and autosync will not retry.
The patch introduces secret material into a tracked file and has a deployment-state bug that can permanently skip a failed gateway bundle update. These should be fixed before considering the change correct.

Full review comments:

- [P0] Remove live credentials from TASKS — /home/enio/egos/TASKS.md:120-120
  This line commits a real database password and recognizable token prefixes while explicitly saying the values may still be live. If this branch is pushed, mirrored, or included in review artifacts, those credentials need to be treated as exposed; redact the values from git history and track rotation without storing the secrets themselves.

- [P2] Do not mark failed gateway bundles as deployed — /home/enio/egos/scripts/hermes-trigger.sh:80-82
  When `bun build` fails, this error branch still records `NEW_SHA` as `last_gw_sha` here, so later runs see `PREV_SHA == NEW_SHA` and skip the gateway diff even though the new bundle was never deployed. If the build failure is transient or fixed outside a new `apps/egos-gateway` commit, the gateway remains on the old bundle and autosync will not retry.
```
