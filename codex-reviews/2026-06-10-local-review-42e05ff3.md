# Codex Local Review — 2026-06-10T18:56:03Z

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
session id: 019eb2e4-3fdb-7000-9d1b-78572136a8c4
--------
user
changes against 'HEAD~3'
2026-06-10T18:56:04.652232Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T18:56:04.652232Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 5bcc06c832a7beee1dfce1cb561ad5b123359b30 --stat && git diff 5bcc06c832a7beee1dfce1cb561ad5b123359b30' in /home/enio/egos
 succeeded in 0ms:
 apps/egos-landing/public/mycelium-snapshot.json |  36 +++-
 apps/egos-landing/public/timeline/rss           |   2 +-
 apps/egos-landing/public/timeline/rss.xml       |   2 +-
 docs/audits/premortem-hub-egos-publico.md       |  58 +++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json    |  10 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json   |  88 ++++++++++
 packages/guard-brasil/tsconfig.tsbuildinfo      |   2 +-
 packages/mcp-unified-gateway/src/tools.ts       | 219 +++++++++++++++++++++++-
 scripts/coordination-watcher.ts                 |  51 +++++-
 9 files changed, 457 insertions(+), 11 deletions(-)
diff --git a/apps/egos-landing/public/mycelium-snapshot.json b/apps/egos-landing/public/mycelium-snapshot.json
index 7567eb13..93e275b7 100644
--- a/apps/egos-landing/public/mycelium-snapshot.json
+++ b/apps/egos-landing/public/mycelium-snapshot.json
@@ -1,6 +1,6 @@
 {
   "version": "1.0.0",
-  "generated": "2026-06-10T11:18:52.380Z",
+  "generated": "2026-06-10T17:04:33.770Z",
   "nodes": [
     {
       "id": "ws:egos-kernel",
@@ -712,6 +712,24 @@
         "cron"
       ]
     },
+    {
+      "id": "trigger:cron-unknown-cron-QHJlYm9v",
+      "type": "trigger",
+      "label": "cron: unknown-cron",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
+    {
+      "id": "trigger:cron-mycelium-snapshot-MCAqLzYg",
+      "type": "trigger",
+      "label": "cron: mycelium-snapshot",
+      "status": "active",
+      "tags": [
+        "cron"
+      ]
+    },
     {
       "id": "endpoint:egos-gateway",
       "type": "shadow_node",
@@ -1669,6 +1687,22 @@
         "code"
       ]
     },
+    {
+      "from": "trigger:cron-unknown-cron-QHJlYm9v",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
+    {
+      "from": "trigger:cron-mycelium-snapshot-MCAqLzYg",
+      "relation": "belongs_to",
+      "to": "ws:egos-kernel",
+      "evidence": [
+        "code"
+      ]
+    },
     {
       "from": "endpoint:egos-gateway",
       "relation": "belongs_to",
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 35245a85..86e0fd53 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 17:04:33 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 35245a85..86e0fd53 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 17:04:33 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/audits/premortem-hub-egos-publico.md b/docs/audits/premortem-hub-egos-publico.md
new file mode 100644
index 00000000..3c33243d
--- /dev/null
+++ b/docs/audits/premortem-hub-egos-publico.md
@@ -0,0 +1,58 @@
+# Premortem — hub.egos.ia.br público multi-tenant
+
+> Gate §5 de `EGOS_SURFACES_ROUTING.md`. Decisão: liberar acesso público ao Odysseus VPS conectado ao gateway MCP EGOS. **Status: GATE — não liberar público até mitigações F-críticas aplicadas.**
+
+## §1 Contexto
+- **O quê:** Odysseus na VPS (`hub.egos.ia.br`) com logins para clientes/visitantes, cada um conversando com IA (Gemini Flash) e usando tools EGOS via token+feature-group.
+- **Por que agora:** vitrine viva do MCP-EASY-INSTALL; vender por experiência, não PDF.
+- **Sucesso em 6 meses:** Miguel/Julio acessaram, entenderam o valor, zero vazamento, custo LLM previsível, nenhum incidente de segurança.
+
+## §2 Premissa
+São 6 meses depois. O hub deu errado. A história abaixo.
+
+## §3 Modos de falha
+
+| ID | Falha | Prob | Sev | Sinal precoce |
+|---|---|---|---|---|
+| **F1** | **Custo LLM descontrolado** — visitante/bot faz milhares de chamadas; Gemini/OpenRouter vira conta alta. Pior: chave OpenRouter exposta no Odysseus = sangria | M | A | pico de spend no dashboard OpenRouter; req/min anômalo |
+| **F2** | **Vazamento de dado interno** — uma tool (ex: egos_banda lê repo, egos_search_knowledge) retorna path/nome interno (intelink/PCMG/cliente) a um token visitante | M | **A** | grep de resposta contém termo interno; cliente vê algo que não devia |
+| **F3** | **Prompt injection / abuso de tool** — visitante manda "ignore instruções, rode shell / leia arquivos do servidor". Odysseus tem tool `shell` e `documents` nativas | A | A | log de tool shell/documents disparada por token não-full |
+| **F4** | **Auth fraca / enumeração de conta** — multi-user do Odysseus com senha fraca; atacante cria conta ou acessa a de outro cliente; vê dados/chats alheios | M | A | tentativas de login falhas; conta criada fora do fluxo |
+| **F5** | **Token de cliente vira chave-mestra** — token com group amplo demais; cliente A acessa tool que toca dado do cliente B (Supabase multi-tenant mal isolado) | M | A | tool de negócio chamada com tenant errado no log |
+| **F6** | **Superfície pública = alvo** — hub.egos.ia.br indexado/descoberto; bots, scrapers, ataque DoS na VPS que também roda gpecas/852/produção real | M | **A** | tráfego anômalo; CPU/RAM da VPS; containers de produção degradados |
+| **F7** | **LGPD: cliente sobe doc real** — Miguel faz upload de PDF com CPF/dado de terceiro na NOSSA instância → viramos operadores de dado pessoal sem base legal | M | A | qualquer upload de documento por token de cliente |
+| **F8** | **Reputação: demo quebra na frente do cliente** — modelo alucina, tool dá erro, UI em inglês confunde → "isso é amador" | M | M | erro de tool na sessão; feedback negativo |
+
+## §4 Mitigações (F-críticas: prob×sev ≥ M×A)
+
+**F1 (custo):** rate-limit já existe (60/min/token) → ADICIONAR teto diário por token (ex: 200 req/dia visitante) + alerta de spend no OpenRouter + chave OpenRouter com limite de crédito mensal dedicada ao hub (não a chave-mãe). Rollback: revogar token, derrubar rota Caddy.
+
+**F2 (vazamento):** visitante usa SÓ group `core` + corpus `STATUS_PUBLIC.md` (já implementado v0.2.0). egos_banda/egos_search_knowledge restritas a group knowledge/full (não core). Teste obrigatório pré-público: rodar cada tool com token visitante e grep a resposta por termos proibidos (intelink, PCMG, nome de cliente, path /home). Sentinela: scan de resposta.
+
+**F3 (injection/shell):** **DESABILITAR as tools nativas perigosas do Odysseus** (shell, documents-write, email-send) para contas não-admin via `manage_settings disable_tool`. O visitante só deve ter as tools EGOS read-only + chat. Isto é P0 absoluto — Odysseus com shell ligado em conta pública = RCE.
+
+**F4 (auth):** senha admin forte (hermes gera). Contas de cliente criadas só pelo admin (não auto-registro). Desabilitar signup público. Verificar se há rota de registro aberta e fechá-la.
+
+**F5 (token mestra):** cada cliente = token com group dedicado, tools de negócio escopadas por tenant no handler. Para o LANÇAMENTO: começar SÓ com group core (sem tools de negócio real) até o isolamento por tenant ser provado com teste negativo.
+
+**F6 (alvo público):** rate-limit de borda no Caddy + monitorar que containers de produção (gpecas/852/evolution) têm limites de recurso isolados. Considerar auth básica no Caddy como primeira porta. Rollback: derrubar rota.
+
+**F7 (LGPD):** no lançamento, DESABILITAR upload de documentos para contas de cliente (ou banner "não suba dado pessoal real"). Gate Guardião antes de aceitar qualquer doc real. Para demo: só dados sintéticos/públicos.
+
+**F8 (reputação):** prompt do sistema em PT-BR fixo; testar o fluxo de demo de ponta a ponta antes de mandar o link; ter um "roteiro de demo" do que pedir.
+
+## §5 Gate de execução
+
+- [ ] **F3** tools nativas perigosas (shell/documents-write/email) DESABILITADAS p/ não-admin — **BLOQUEADOR ABSOLUTO**
+- [ ] **F2** teste negativo: toda tool com token visitante, grep anti-vazamento limpo — **BLOQUEADOR**
+- [ ] **F4** auto-registro fechado, senha admin forte
+- [ ] **F1** teto diário por token + chave OpenRouter com limite de crédito dedicado
+- [ ] **F7** upload de doc desabilitado p/ cliente no lançamento (ou só sintético)
+- [ ] **F5** lançar só com group `core` (tools de negócio depois, com teste de isolamento)
+- [ ] **F6** rate-limit Caddy + verificar isolamento de recurso dos containers de produção
+- [ ] Roteiro de demo testado ponta a ponta (F8)
+- [ ] **Red Zone:** corte do Enio por cliente exposto (HITL T0#3)
+
+**Veredito:** infra pode subir (deploy em andamento). **Acesso público NÃO liga** até F2+F3+F4 verdes (os 3 bloqueadores). Owner do rollback: hermes-ops (derrubar rota Caddy = 1 comando, ~1min).
+
+*v1.0 — 2026-06-10. Gate ativo.*
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index ee90738b..f2d65db0 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T16:22:45.399Z",
+  "verified_at": "2026-06-10T18:55:53.968Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -72,9 +72,9 @@
       "description": "Packages in packages/ directory",
       "status": "ok",
       "last_value": "39",
-      "current_value": "39",
+      "current_value": "40",
       "tolerance": "±2",
-      "drift_abs": 0,
+      "drift_abs": 1,
       "command": "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '",
       "severity": "ok"
     },
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1397",
+      "current_value": "1418",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
@@ -173,7 +173,7 @@
       "description": "Pre-commit hook chain has minimum required governance stages",
       "status": "ok",
       "last_value": "70",
-      "current_value": "177",
+      "current_value": "179",
       "tolerance": "min:15",
       "command": "grep -c '\\[' .husky/pre-commit",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index edb5e39e..e664cfb7 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -374,5 +374,93 @@
     "duration_ms": null,
     "event": "commit:feat files=3 sha=466ab460",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:45:08.946Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=e62c0cd9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T16:57:26.255Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=8 sha=dfc70d78",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:03:21.484Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=c26e8813",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:28:14.011Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=4 sha=1ee70f27",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:42:23.801Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=cfed87c1",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:43:24.366Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=58bfe83f",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T17:54:00.887Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=6 sha=ca306982",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T18:02:15.977Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=2 sha=73843d28",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T18:20:07.985Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=5bcc06c8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T18:44:25.761Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=1 sha=5feadba2",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T18:55:54.620Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=42e05ff3",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/packages/guard-brasil/tsconfig.tsbuildinfo b/packages/guard-brasil/tsconfig.tsbuildinfo
index 9460f310..3c5bcecc 100644
--- a/packages/guard-brasil/tsconfig.tsbuildinfo
+++ b/packages/guard-brasil/tsconfig.tsbuildinfo
@@ -1 +1 @@
-{"fileNames":["../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2025.float16.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/provenance.ts","./src/lib/evidence-chain.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/lib/tokenizer.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","./src/registry/pcmg-corpus.ts","./src/registry/types.ts","./src/registry/pcmg.ts","./src/registry/hitl-runner.ts","./src/registry/index.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/net.d.ts","../../node_modules/.bun/buffer@6.0.3/node_modules/buffer/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.13/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227,230],[82,142,143,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,151,153,156,157,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,146,147,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,149,150,153,157,160,162,163,164,168,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,151,153,156,157,160,162,163,164,166,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,152,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,154,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,155,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,144,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,156,157,158,160,162,163,164,177,182,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,132,145,153,156,157,159,160,162,163,164,166,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,159,160,162,163,164,166,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,159,160,161,162,163,164,177,182,191,194,203,204,205,207,209,220,221,222,223,224,225,226,227],[80,81,82,83,84,85,86,87,88,89,90,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,166,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,168,177,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,169,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,174,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,175,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,178,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,179,195,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,182,184,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,183,185,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,186,203,204,205,207,209,220,222,223,224,225,226,227],[82,142,145,153,157,160,162,163,164,177,182,188,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,187,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,156,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,189,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,166,177,182,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,192,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,193,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,159,160,162,163,164,175,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,196,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,197,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,165,177,198,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,199,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,148,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,195,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,200,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,172,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,185,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,190,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,153,156,157,158,160,162,163,164,172,177,182,185,194,197,198,200,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,159,160,162,163,164,177,191,195,200,203,204,205,206,209,210,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,220,222,223,224,225,226,227],[82,132,145,153,157,160,162,163,164,177,203,204,207,209,220,222,223,224,225,226,227],[82,132,145,150,153,157,160,162,163,164,172,177,182,185,191,195,200,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,208,209,210,211,212,213,219,220,221,222,223,224,225,226,227,228,229],[82,145,148,150,153,157,158,160,162,163,164,168,177,185,191,194,201,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,213,220,222,223,224,225,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,218,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,215,216,217,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,216,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,214,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,203,204,205,207,209,222,223,224,225,226,227],[82,97,100,103,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,182,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,97,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,166,177,191,203,204,205,207,209,220,221,222,223,224,225,226,227],[82,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,145,153,157,160,162,163,164,177,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,166,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,92,93,95,99,145,153,156,157,160,162,163,164,177,182,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,117,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,98,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,126,127,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,95,100,145,153,157,160,162,163,164,177,185,194,202,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,96,100,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,91,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,95,96,98,99,100,101,102,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,122,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,109,110,111,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,99,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,94,100,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,104,110,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,104,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,98,100,103,145,153,157,160,162,163,164,177,194,203,204,205,207,209,220,222,223,224,225,226,227],[82,92,96,100,109,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,100,119,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,112,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[82,94,100,126,145,153,157,160,162,163,164,177,185,200,202,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[68,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,67,68,71,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[65,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[61,63,64,65,66,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[63,82,145,150,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[62,63,75,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,77,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227],[76,82,145,153,157,160,162,163,164,177,203,204,205,207,209,220,222,223,224,225,226,227]],"fileInfos":[{"version":"bcd24271a113971ba9eb71ff8cb01bc6b0f872a85c23fdbe5d93065b375933cd","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f88bedbeb09c6f5a6645cb24c7c55f1aa22d19ae96c8e6959cbd8b85a707bc6","impliedFormat":1},{"version":"7fe93b39b810eadd916be8db880dd7f0f7012a5cc6ffb62de8f62a2117fa6f1f","impliedFormat":1},{"version":"bb0074cc08b84a2374af33d8bf044b80851ccc9e719a5e202eacf40db2c31600","impliedFormat":1},{"version":"1a7daebe4f45fb03d9ec53d60008fbf9ac45a697fdc89e4ce218bc94b94f94d6","impliedFormat":1},{"version":"f94b133a3cb14a288803be545ac2683e0d0ff6661bcd37e31aaaec54fc382aed","impliedFormat":1},{"version":"f59d0650799f8782fd74cf73c19223730c6d1b9198671b1c5b3a38e1188b5953","impliedFormat":1},{"version":"8a15b4607d9a499e2dbeed9ec0d3c0d7372c850b2d5f1fb259e8f6d41d468a84","impliedFormat":1},{"version":"26e0fe14baee4e127f4365d1ae0b276f400562e45e19e35fd2d4c296684715e6","impliedFormat":1},{"version":"d6b1eba8496bdd0eed6fc8a685768fe01b2da4a0388b5fe7df558290bffcf32f","affectsGlobalScope":true,"impliedFormat":1},{"version":"eadcffda2aa84802c73938e589b9e58248d74c59cb7fcbca6474e3435ac15504","affectsGlobalScope":true,"impliedFormat":1},{"version":"105ba8ff7ba746404fe1a2e189d1d3d2e0eb29a08c18dded791af02f29fb4711","affectsGlobalScope":true,"impliedFormat":1},{"version":"00343ca5b2e3d48fa5df1db6e32ea2a59afab09590274a6cccb1dbae82e60c7c","affectsGlobalScope":true,"impliedFormat":1},{"version":"ebd9f816d4002697cb2864bea1f0b70a103124e18a8cd9645eeccc09bdf80ab4","affectsGlobalScope":true,"impliedFormat":1},{"version":"2c1afac30a01772cd2a9a298a7ce7706b5892e447bb46bdbeef720f7b5da77ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"7b0225f483e4fa685625ebe43dd584bb7973bbd84e66a6ba7bbe175ee1048b4f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c0a4b8ac6ce74679c1da2b3795296f5896e31c38e888469a8e0f99dc3305de60","affectsGlobalScope":true,"impliedFormat":1},{"version":"3084a7b5f569088e0146533a00830e206565de65cae2239509168b11434cd84f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c5079c53f0f141a0698faa903e76cb41cd664e3efb01cc17a5c46ec2eb0bef42","affectsGlobalScope":true,"impliedFormat":1},{"version":"32cafbc484dea6b0ab62cf8473182bbcb23020d70845b406f80b7526f38ae862","affectsGlobalScope":true,"impliedFormat":1},{"version":"fca4cdcb6d6c5ef18a869003d02c9f0fd95df8cfaf6eb431cd3376bc034cad36","affectsGlobalScope":true,"impliedFormat":1},{"version":"b93ec88115de9a9dc1b602291b85baf825c85666bf25985cc5f698073892b467","affectsGlobalScope":true,"impliedFormat":1},{"version":"f5c06dcc3fe849fcb297c247865a161f995cc29de7aa823afdd75aaaddc1419b","affectsGlobalScope":true,"impliedFormat":1},{"version":"b77e16112127a4b169ef0b8c3a4d730edf459c5f25fe52d5e436a6919206c4d7","affectsGlobalScope":true,"impliedFormat":1},{"version":"fbffd9337146eff822c7c00acbb78b01ea7ea23987f6c961eba689349e744f8c","affectsGlobalScope":true,"impliedFormat":1},{"version":"a995c0e49b721312f74fdfb89e4ba29bd9824c770bbb4021d74d2bf560e4c6bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"c7b3542146734342e440a84b213384bfa188835537ddbda50d30766f0593aff9","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce6180fa19b1cccd07ee7f7dbb9a367ac19c0ed160573e4686425060b6df7f57","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f02e2476bccb9dbe21280d6090f0df17d2f66b74711489415a8aa4df73c9675","affectsGlobalScope":true,"impliedFormat":1},{"version":"45e3ab34c1c013c8ab2dc1ba4c80c780744b13b5676800ae2e3be27ae862c40c","affectsGlobalScope":true,"impliedFormat":1},{"version":"805c86f6cca8d7702a62a844856dbaa2a3fd2abef0536e65d48732441dde5b5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e42e397f1a5a77994f0185fd1466520691456c772d06bf843e5084ceb879a0ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"f4c2b41f90c95b1c532ecc874bd3c111865793b23aebcc1c3cbbabcd5d76ffb0","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab26191cfad5b66afa11b8bf935ef1cd88fabfcb28d30b2dfa6fad877d050332","affectsGlobalScope":true,"impliedFormat":1},{"version":"2088bc26531e38fb05eedac2951480db5309f6be3fa4a08d2221abb0f5b4200d","affectsGlobalScope":true,"impliedFormat":1},{"version":"cb9d366c425fea79716a8fb3af0d78e6b22ebbab3bd64d25063b42dc9f531c1e","affectsGlobalScope":true,"impliedFormat":1},{"version":"500934a8089c26d57ebdb688fc9757389bb6207a3c8f0674d68efa900d2abb34","affectsGlobalScope":true,"impliedFormat":1},{"version":"689da16f46e647cef0d64b0def88910e818a5877ca5379ede156ca3afb780ac3","affectsGlobalScope":true,"impliedFormat":1},{"version":"bc21cc8b6fee4f4c2440d08035b7ea3c06b3511314c8bab6bef7a92de58a2593","affectsGlobalScope":true,"impliedFormat":1},{"version":"7ca53d13d2957003abb47922a71866ba7cb2068f8d154877c596d63c359fed25","affectsGlobalScope":true,"impliedFormat":1},{"version":"54725f8c4df3d900cb4dac84b64689ce29548da0b4e9b7c2de61d41c79293611","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5594bc3076ac29e6c1ebda77939bc4c8833de72f654b6e376862c0473199323","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f3eb332c2d73e729f3364fcc0c2b375e72a121e8157d25a82d67a138c83a95c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6f4427f9642ce8d500970e4e69d1397f64072ab73b97e476b4002a646ac743b1","affectsGlobalScope":true,"impliedFormat":1},{"version":"48915f327cd1dea4d7bd358d9dc7732f58f9e1626a29cc0c05c8c692419d9bb7","affectsGlobalScope":true,"impliedFormat":1},{"version":"b7bf9377723203b5a6a4b920164df22d56a43f593269ba6ae1fdc97774b68855","affectsGlobalScope":true,"impliedFormat":1},{"version":"db9709688f82c9e5f65a119c64d835f906efe5f559d08b11642d56eb85b79357","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b25b8c874acd1a4cf8444c3617e037d444d19080ac9f634b405583fd10ce1f7","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be57d7c90cf1f8112ee2636a068d8fd181289f82b744160ec56a7dc158a9f5","affectsGlobalScope":true,"impliedFormat":1},{"version":"a917a49ac94cd26b754ab84e113369a75d1a47a710661d7cd25e961cc797065f","affectsGlobalScope":true,"impliedFormat":1},{"version":"6d3261badeb7843d157ef3e6f5d1427d0eeb0af0cf9df84a62cfd29fd47ac86e","affectsGlobalScope":true,"impliedFormat":1},{"version":"195daca651dde22f2167ac0d0a05e215308119a3100f5e6268e8317d05a92526","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b11e4285cd2bb164a4dc09248bdec69e9842517db4ca47c1ba913011e44ff2f","affectsGlobalScope":true,"impliedFormat":1},{"version":"0508571a52475e245b02bc50fa1394065a0a3d05277fbf5120c3784b85651799","affectsGlobalScope":true,"impliedFormat":1},{"version":"8f9af488f510c3015af3cc8c267a9e9d96c4dd38a1fdff0e11dc5a544711415b","affectsGlobalScope":true,"impliedFormat":1},{"version":"fc611fea8d30ea72c6bbfb599c9b4d393ce22e2f5bfef2172534781e7d138104","affectsGlobalScope":true,"impliedFormat":1},{"version":"f128dae7c44d8f35ee42e0a437000a57c9f06cc04f8b4fb42eebf44954d53dc8","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ecb8e347cb6b2a8927c09b86263663289418df375f5e68e11a0ae683776978f","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ce14b81c5cc821994aa8ec1d42b220dd41b27fcc06373bce3958af7421b77d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3a048b3e9302ef9a34ef4ebb9aecfb28b66abb3bce577206a79fee559c230da","affectsGlobalScope":true,"impliedFormat":1},"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9","69274d91266b9bbba0f5d6f65075cace2a539c739fe73f22dfa053d7c013ebf9","5c0bf3f655393a93f5ac0894660863c4ce0c90062c17b5860950c432876e7fc8","81c42c754119ef4c29959980f1bde23bbe03a1b86177a8f968b2b4cbaafc1bcc","c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","0fb490a6869ddea3ec75f5f6d5a21054f82ce8cd60d472f9a1c70d42e295d4ac","ac1aadc908543ce94afbced5b8cc2d1b94b3b795a303e4c242004031b183765c","c30ca61bc62858baaf36ea887fba9d0032a5e060407a1deb3bf4dd38be64361b","9fb602236e65c57126f2d090c9968fd7ff6e406c350039e76831de069cc9d1f5","ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae","7ff10c73aab4f126ea1d1f7cd40c2b6c9057c974bde0fb75972d677f7ae67c26","3fdf6a42927e85ed94cc06a55b53b92bb0ab3f529fd3ffe15156a96748222915","2f59322b90429e64312dc6e75c9ed31123b0743e7358272cb5b42a586b5894ae","4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3",{"version":"41849007e704926b0a90d541cd4b27cb24ce250c86dae8cef37df96e55aaef21","signature":"dbe5e2e1be30c88d4492b8aaae9802d4bb9be42f992db4845a63fafc94d2b63b"},"42b300f515d975d3bf5777324b55b2231a7a7ae1c3a5d659248709cbbb987f9d","7446b5cbee5a79ada2657125cef88e0e64c722e35946da99f17515c645b4717f",{"version":"fa047096cf13a1fe0b45b2b4672e95fad831fc9a77be0516361eae6ec9454a3f","signature":"570cb6046f537533b9f8681667833b1bb6d5b57f002ca20169b4ea59a04c07b6"},"04adb19af4de59b923b996250d36447eed0cadec0a416ef7e4ded64a7afbe589",{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc2110f7decca6bfb9392e30421cfa1436479e4a6756e8fec6cbc22625d4f881","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"4137ebf04166f3a325f056aa56101adc75e9dceb30404a1844eb8604d89770e2","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"98498b101803bb3dde9f76a56e65c14b75db1cc8bec5f4db72be541570f74fc5","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"d2ae155afe8a01cc0ae612d99117cf8ef16692ba7c4366590156fdec1bcf2d8c","impliedFormat":1},{"version":"3f5e5d9be35913db9fea42a63f3df0b7e3c8703b97670a2125587b4dbbd56d7c","impliedFormat":1},{"version":"8caeb65fdc3bfe0d13f86f67324fcb2d858ed1c55f1f0cce892eb1acfb9f3239","impliedFormat":1},{"version":"57c23df0b5f7a8e26363a3849b0bc7763f6b241207157c8e40089d1df4116f35","affectsGlobalScope":true,"impliedFormat":1},{"version":"3b8bc0c17b54081b0878673989216229e575d67a10874e84566a21025a2461ee","impliedFormat":1},{"version":"5b0db5a58b73498792a29bfebc333438e61906fef75da898b410e24e52229e6f","impliedFormat":1},{"version":"dbe055b2b29a7bab2c1ca8f259436306adb43f469dca7e639a02cd3695d3f621","impliedFormat":1},{"version":"1678b04557dca52feab73cc67610918a7f5e25bfdba3e7fa081acd625d93106d","impliedFormat":1},{"version":"e3905f6902f0b69e5eefc230daa69fdd4ab707a973ec2d086d65af1b3ea47ef0","impliedFormat":1},{"version":"2ea729503db9793f2691162fec3dd1118cab62e96d025f8eeb376d43ec293395","impliedFormat":1},{"version":"9ec87fea42b92894b0f209931a880789d43c3397d09dd99c631ae40a2f7071d1","impliedFormat":1},{"version":"c68e88cdfadfb6c8ba5fc38e58a3a166b0beae77b1f05b7d921150a32a5ffb8d","impliedFormat":1},{"version":"2bc7aa4fba46df0bd495425a7c8201437a7d465f83854fac859df2d67f664df3","impliedFormat":1},{"version":"41d17e1ad9a002feb11c8cdd2777e5bbc0cdb1e3f595d237e4dded0b6949983b","impliedFormat":1},{"version":"07e4e61e946a9c15045539ecd5f5d2d02e7aab6fa82567826857e09cf0f37c2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"1c4714ccc29149efb8777a1da0b04b8d2258f5d13ddbf4cd3c3d361fb531ac86","impliedFormat":1},{"version":"3ff275f84f89f8a7c0543da838f9da9614201abc4ce74c533029825adfb4433d","impliedFormat":1},{"version":"0eb5d0cbf09de5d34542b977fd6a933bb2e0817bffe8e1a541b2f1ad1b9af1ff","impliedFormat":1},{"version":"10deca769dfed888051b1808d6746f8883a490a707f8bdf9367079146987d6d0","impliedFormat":1},{"version":"2c2bdaa1d8ead9f68628d6d9d250e46ee8e81aa4898b4769a36956ae15e060fe","impliedFormat":1},{"version":"c32c840c62d8bd7aeb3147aa6754cd2d922b990a6b6634530cb2ebdce5adc8e9","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"82b91e4e42e6c41bc7fc1b6c2dc5eba6a2ba98375eb1f210e6ff6bba2d54177e","impliedFormat":1},{"version":"6fe28249ac0c7bc19a79aa9264baf00efbd080e868dbe1d3052033ad1c64f206","affectsGlobalScope":true,"impliedFormat":1},{"version":"cbed824fec91efefc7bbdcb8b43d1a531fdbebd0e2ef19481501ff365a93cb70","impliedFormat":1},{"version":"4967529644e391115ca5592184d4b63980569adf60ee685f968fd59ab1557188","impliedFormat":1},{"version":"d0716593b3f2b0451bcf0c24cfa86dec2235c325c89f201934248b7c742715fc","impliedFormat":1},{"version":"ec501101c2a96133a6c695f934c8f6642149cc728571b29cbb7b770984c1088e","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"2991bca2cc0f0628a278df2a2ccdb8d6cbcb700f3761abbed62bba137d5b1790","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"230763250f20449fa7b3c9273e1967adb0023dc890d4be1553faca658ee65971","impliedFormat":1},{"version":"c3e9078b60cb329d1221f5878e88cecfa3e74460550e605a58fcfb41a66029ff","impliedFormat":1},{"version":"a74edb3bab7394a9dbde529d60632be590def2f5f01024dbd85441587fbfbbe0","impliedFormat":1},{"version":"0ea59f7d3e51440baa64f429253759b106cfcbaf51e474cae606e02265b37cf8","impliedFormat":1},{"version":"bc18a1991ba681f03e13285fa1d7b99b03b67ee671b7bc936254467177543890","impliedFormat":1},{"version":"00049ccc87f3f37726db03c01ca68fe74fd9c0109b68c29eb9923ebec2c76b13","impliedFormat":1},{"version":"fa94bbf532b7af8f394b95fa310980d6e20bd2d4c871c6a6cb9f70f03750a44b","impliedFormat":1},{"version":"68d3f35108e2608b1f2f28b36d19d7055f31c4465cc5692cbd06c716a9fe7973","impliedFormat":1},{"version":"a6d543044570fbeed13a7f9925a868081cd2b14ef59cdd9da6ae76d41cab03d3","affectsGlobalScope":true,"impliedFormat":1},{"version":"7fa2214bb0d64701bc6f9ce8cde2fd2ff8c571e0b23065fa04a8a5a6beb91511","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"016b29bf4926b80255a108c53a1451717350059da04fcae64d1075f5e93bbb39","impliedFormat":1},{"version":"841983e39bd4cbb463be385e92fda11057cab368bf27100a801c492f1d86cbaa","impliedFormat":1},{"version":"6f5383b3df1cdf4ff1aa7fb0850f77042b5786b5e65ec9a9b6be56ebfe4d9036","impliedFormat":1},{"version":"62fc21ed9ccbd83bd1166de277a4b5daaa8d15b5fa614c75610d20f3b73fba87","impliedFormat":1},{"version":"e4156ddb25aa0e3b5303d372f26957b36778f0f6bbd4326359269873295e3058","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc1b433a84cae05ddc5672d4823170af78606ad21ecef60dbc4570190cbf1357","impliedFormat":1},{"version":"9d3821bc75c59577e52643324cec92fc2145642e8d17cf7ee07a3181f21d985d","impliedFormat":1},{"version":"7f78cfb2b343838612c192cb251746e3a7c62ac7675726a47e130d9b213f6580","impliedFormat":1},{"version":"201db9cf1687fab1adf5282fcba861f382b32303dc4f67c89d59655e78a25461","impliedFormat":1},{"version":"c77fb31bc17fd241d3922a9f88c59e3361cdf76d1328ba9412fc6bf7310b638d","impliedFormat":1},{"version":"0a20eaf2e4b1e3c1e1f87f7bccb0c936375b23b022baeea750519b7c9bc6ce83","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"a16b91b27bd6b706c687c88cbc8a7d4ee98e5ed6043026d6b84bda923c0aed67","impliedFormat":1},{"version":"694b812e0ed11285e8822cf8131e3ce7083a500b3b1d185fff9ed1089677bd0a","impliedFormat":1},{"version":"99ab6d0d660ce4d21efb52288a39fd35bb3f556980ec5463b1ae8f304a3bbc85","impliedFormat":1},{"version":"6eeded8c7e352be6e0efb83f4935ec752513c4d22043b52522b90849a49a3a11","impliedFormat":1},{"version":"6c1ad90050ffbb151cacc68e2d06ea1a26a945659391e32651f5d42b86fd7f2c","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"0d759cc99e081cacd0352467a0c24e979a6ef748329aa6ddea2d789664580201","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"47767435860d3f8dccb0f6263bdca9ad112058014e1802e63c32bd0907e5c550","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"00a196792eed6e9b7f988db0d3ced11a94ecd1e258fd19124ce89fe7642df35a","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,79]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[231,1],[142,2],[143,2],[144,3],[82,4],[145,5],[146,6],[147,7],[80,8],[148,9],[149,10],[150,11],[151,12],[152,13],[153,14],[154,14],[155,15],[156,16],[157,17],[158,18],[83,8],[81,8],[159,19],[160,20],[161,21],[202,22],[162,23],[163,24],[164,23],[165,25],[166,26],[168,27],[169,28],[170,28],[171,28],[172,29],[173,30],[174,31],[175,32],[176,33],[177,34],[178,34],[179,35],[180,8],[181,8],[182,36],[183,37],[184,36],[185,38],[186,39],[187,40],[188,41],[189,42],[190,43],[191,44],[192,45],[193,46],[194,47],[195,48],[196,49],[197,50],[198,51],[199,52],[84,23],[85,8],[86,53],[87,54],[88,8],[89,55],[90,8],[133,56],[134,57],[135,58],[136,58],[137,59],[138,8],[139,60],[140,61],[141,57],[200,62],[201,63],[167,8],[207,64],[229,8],[228,8],[222,65],[209,66],[208,8],[205,67],[210,8],[203,68],[211,8],[230,69],[212,8],[206,8],[221,70],[223,71],[204,72],[227,73],[225,74],[224,75],[226,76],[213,8],[219,77],[216,78],[218,79],[217,80],[215,81],[214,8],[220,82],[59,8],[60,8],[10,8],[12,8],[11,8],[2,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],[20,8],[3,8],[21,8],[22,8],[4,8],[23,8],[27,8],[24,8],[25,8],[26,8],[28,8],[29,8],[30,8],[5,8],[31,8],[32,8],[33,8],[34,8],[6,8],[38,8],[35,8],[36,8],[37,8],[39,8],[7,8],[40,8],[45,8],[46,8],[41,8],[42,8],[43,8],[44,8],[8,8],[50,8],[47,8],[48,8],[49,8],[51,8],[9,8],[52,8],[53,8],[54,8],[56,8],[55,8],[57,8],[1,8],[58,8],[109,83],[121,84],[106,85],[122,86],[131,87],[97,88],[98,89],[96,90],[130,91],[125,92],[129,93],[100,94],[118,95],[99,96],[128,97],[94,98],[95,92],[101,99],[102,8],[108,100],[105,99],[92,101],[132,102],[123,103],[112,104],[111,99],[113,105],[116,106],[110,107],[114,108],[126,91],[103,109],[104,110],[117,111],[93,86],[120,112],[119,99],[107,110],[115,113],[124,8],[91,8],[127,114],[69,115],[70,116],[68,117],[72,118],[73,54],[61,8],[66,119],[67,120],[63,121],[65,54],[64,122],[71,123],[62,8],[78,124],[79,125],[75,8],[77,126],[76,121],[74,8]],"affectedFilesPendingEmit":[[69,17],[70,17],[68,17],[72,17],[73,17],[61,17],[66,17],[67,17],[63,17],[65,17],[64,17],[71,17],[62,17],[78,17],[79,17],[75,17],[77,17],[76,17],[74,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79],"version":"6.0.3"}
\ No newline at end of file
+{"fileNames":["../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es5.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.dom.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.core.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.collection.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.generator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.iterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.proxy.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.reflect.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2015.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.array.include.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2016.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.arraybuffer.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2017.typedarrays.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asyncgenerator.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.asynciterable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2018.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.symbol.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2019.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.bigint.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.date.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.sharedmemory.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.symbol.wellknown.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2020.number.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.promise.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.weakref.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2021.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.array.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.error.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.intl.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.object.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.string.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2022.regexp.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.es2025.float16.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.esnext.disposable.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.d.ts","../../node_modules/.bun/typescript@6.0.3/node_modules/typescript/lib/lib.decorators.legacy.d.ts","./src/lib/atrian.ts","./src/pii-patterns.ts","./src/lib/ner-rules.ts","./src/lib/pii-scanner.ts","./src/lib/public-guard.ts","./src/lib/provenance.ts","./src/lib/evidence-chain.ts","./src/lib/tokenizer.ts","./src/lib/index.ts","./src/guard.ts","./src/benchmark.ts","./src/demo.ts","./src/index.ts","./src/keys.ts","./src/telemetry.ts","./src/registry/pcmg-corpus.ts","./src/registry/types.ts","./src/registry/pcmg.ts","./src/registry/hitl-runner.ts","./src/registry/index.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/compatibility/iterators.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.typedarray.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/globals.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/abortcontroller.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/blob.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/domexception.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/encoding.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/events.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/utility.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/header.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/readable.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/fetch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/formdata.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/connector.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-dispatcher.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/global-origin.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool-stats.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/handlers.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/balanced-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/round-robin-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/h2c-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-call-history.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-client.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-pool.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/snapshot-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/mock-errors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/env-http-proxy-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-handler.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/retry-agent.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/api.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache-interceptor.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/interceptors.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/util.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cookies.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/patch.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/websocket.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/eventsource.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/diagnostics-channel.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/content-type.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/cache.d.ts","../../node_modules/.bun/undici-types@7.19.2/node_modules/undici-types/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/fetch.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/importmeta.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/messaging.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/navigator.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/performance.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/storage.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/streams.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/web-globals/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/assert/strict.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/async_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/buffer.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/child_process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/cluster.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/console.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/constants.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/crypto.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dgram.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/diagnostics_channel.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/dns/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/domain.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/fs/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/http2.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/https.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector.generated.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/inspector/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/module.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/net.d.ts","../../node_modules/.bun/buffer@6.0.3/node_modules/buffer/index.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/os.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/posix.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/path/win32.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/perf_hooks.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/process.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/punycode.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/querystring.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/quic.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/readline/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/repl.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sea.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/sqlite.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/consumers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/stream/web.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/string_decoder.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/test/reporters.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/timers/promises.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tls.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/trace_events.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/tty.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/url.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/util/types.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/v8.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/vm.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/wasi.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/worker_threads.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/zlib.d.ts","../../node_modules/.bun/@types+node@25.6.2/node_modules/@types/node/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/globals.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/s3.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/fetch.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsx.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/extensions.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/devserver.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/ffi.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/html-rewriter.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/jsc.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sqlite.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/utils.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/overloads.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/branding.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/messages.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/vendor/expect-type/index.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/test.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/wasm.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/overrides.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/deprecated.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/redis.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/shell.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/serve.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/sql.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/security.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bundle.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/bun.ns.d.ts","../../node_modules/.bun/bun-types@1.3.13/node_modules/bun-types/index.d.ts","../../node_modules/.bun/@types+bun@1.3.13/node_modules/@types/bun/index.d.ts"],"fileIdsList":[[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228,231],[83,143,144,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,147,152,154,157,158,161,163,164,165,167,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,147,148,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,149,154,158,161,163,164,165,178,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,150,151,154,158,161,163,164,165,169,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,183,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,152,154,157,158,161,163,164,165,167,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,153,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,155,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,156,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,145,146,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,159,161,163,164,165,178,183,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,157,158,159,161,163,164,165,178,183,186,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,133,146,154,157,158,160,161,163,164,165,167,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,160,161,163,164,165,167,178,183,192,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,160,161,162,163,164,165,178,183,192,195,204,205,206,208,210,221,222,223,224,225,226,227,228],[81,82,83,84,85,86,87,88,89,90,91,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,166,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,167,178,183,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,169,178,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,170,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,173,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,175,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,176,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,167,178,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,179,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,180,196,199,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,183,185,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,184,186,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,187,204,205,206,208,210,221,223,224,225,226,227,228],[83,143,146,154,158,161,163,164,165,178,183,189,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,188,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,157,158,161,163,164,165,178,190,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,190,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,167,178,183,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,193,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,167,178,194,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,160,161,163,164,165,176,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,196,197,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,197,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,198,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,166,178,199,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,200,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,149,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,151,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,196,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,201,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,173,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,186,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,191,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,154,157,158,159,161,163,164,165,173,178,183,186,195,198,199,201,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,133,146,151,154,158,160,161,163,164,165,178,192,196,201,204,205,206,207,210,211,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,221,223,224,225,226,227,228],[83,133,146,154,158,161,163,164,165,178,204,205,208,210,221,223,224,225,226,227,228],[83,133,146,151,154,158,161,163,164,165,173,178,183,186,192,196,201,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,203,204,205,206,208,209,210,211,212,213,214,220,221,222,223,224,225,226,227,228,229,230],[83,146,149,151,154,158,159,161,163,164,165,169,178,186,192,195,202,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,214,221,223,224,225,226,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,219,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,216,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,216,217,218,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,217,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,215,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,204,205,206,208,210,223,224,225,226,227,228],[83,98,101,104,105,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,146,154,158,161,163,164,165,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,105,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,183,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,98,101,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,167,178,192,204,205,206,208,210,221,222,223,224,225,226,227,228],[83,146,154,158,161,163,164,165,178,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,146,154,158,161,163,164,165,178,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,101,146,154,158,161,163,164,165,167,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,92,93,94,96,100,146,154,157,158,161,163,164,165,178,183,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,110,118,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,99,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,127,128,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,96,101,146,154,158,161,163,164,165,178,186,195,203,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,97,101,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,92,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,96,97,99,100,101,102,103,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,128,129,130,131,132,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,120,123,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,110,111,112,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,101,111,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,100,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,95,101,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,105,111,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,105,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,99,101,104,146,154,158,161,163,164,165,178,195,204,205,206,208,210,221,223,224,225,226,227,228],[83,93,97,101,110,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,101,120,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,113,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[83,95,101,127,146,154,158,161,163,164,165,178,186,201,203,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,69,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,63,68,69,70,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[66,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[61,63,64,65,66,67,68,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[64,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,63,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[64,83,146,151,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,64,76,78,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[77,78,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[77,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228],[62,83,146,154,158,161,163,164,165,178,204,205,206,208,210,221,223,224,225,226,227,228]],"fileInfos":[{"version":"bcd24271a113971ba9eb71ff8cb01bc6b0f872a85c23fdbe5d93065b375933cd","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f88bedbeb09c6f5a6645cb24c7c55f1aa22d19ae96c8e6959cbd8b85a707bc6","impliedFormat":1},{"version":"7fe93b39b810eadd916be8db880dd7f0f7012a5cc6ffb62de8f62a2117fa6f1f","impliedFormat":1},{"version":"bb0074cc08b84a2374af33d8bf044b80851ccc9e719a5e202eacf40db2c31600","impliedFormat":1},{"version":"1a7daebe4f45fb03d9ec53d60008fbf9ac45a697fdc89e4ce218bc94b94f94d6","impliedFormat":1},{"version":"f94b133a3cb14a288803be545ac2683e0d0ff6661bcd37e31aaaec54fc382aed","impliedFormat":1},{"version":"f59d0650799f8782fd74cf73c19223730c6d1b9198671b1c5b3a38e1188b5953","impliedFormat":1},{"version":"8a15b4607d9a499e2dbeed9ec0d3c0d7372c850b2d5f1fb259e8f6d41d468a84","impliedFormat":1},{"version":"26e0fe14baee4e127f4365d1ae0b276f400562e45e19e35fd2d4c296684715e6","impliedFormat":1},{"version":"d6b1eba8496bdd0eed6fc8a685768fe01b2da4a0388b5fe7df558290bffcf32f","affectsGlobalScope":true,"impliedFormat":1},{"version":"eadcffda2aa84802c73938e589b9e58248d74c59cb7fcbca6474e3435ac15504","affectsGlobalScope":true,"impliedFormat":1},{"version":"105ba8ff7ba746404fe1a2e189d1d3d2e0eb29a08c18dded791af02f29fb4711","affectsGlobalScope":true,"impliedFormat":1},{"version":"00343ca5b2e3d48fa5df1db6e32ea2a59afab09590274a6cccb1dbae82e60c7c","affectsGlobalScope":true,"impliedFormat":1},{"version":"ebd9f816d4002697cb2864bea1f0b70a103124e18a8cd9645eeccc09bdf80ab4","affectsGlobalScope":true,"impliedFormat":1},{"version":"2c1afac30a01772cd2a9a298a7ce7706b5892e447bb46bdbeef720f7b5da77ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"7b0225f483e4fa685625ebe43dd584bb7973bbd84e66a6ba7bbe175ee1048b4f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c0a4b8ac6ce74679c1da2b3795296f5896e31c38e888469a8e0f99dc3305de60","affectsGlobalScope":true,"impliedFormat":1},{"version":"3084a7b5f569088e0146533a00830e206565de65cae2239509168b11434cd84f","affectsGlobalScope":true,"impliedFormat":1},{"version":"c5079c53f0f141a0698faa903e76cb41cd664e3efb01cc17a5c46ec2eb0bef42","affectsGlobalScope":true,"impliedFormat":1},{"version":"32cafbc484dea6b0ab62cf8473182bbcb23020d70845b406f80b7526f38ae862","affectsGlobalScope":true,"impliedFormat":1},{"version":"fca4cdcb6d6c5ef18a869003d02c9f0fd95df8cfaf6eb431cd3376bc034cad36","affectsGlobalScope":true,"impliedFormat":1},{"version":"b93ec88115de9a9dc1b602291b85baf825c85666bf25985cc5f698073892b467","affectsGlobalScope":true,"impliedFormat":1},{"version":"f5c06dcc3fe849fcb297c247865a161f995cc29de7aa823afdd75aaaddc1419b","affectsGlobalScope":true,"impliedFormat":1},{"version":"b77e16112127a4b169ef0b8c3a4d730edf459c5f25fe52d5e436a6919206c4d7","affectsGlobalScope":true,"impliedFormat":1},{"version":"fbffd9337146eff822c7c00acbb78b01ea7ea23987f6c961eba689349e744f8c","affectsGlobalScope":true,"impliedFormat":1},{"version":"a995c0e49b721312f74fdfb89e4ba29bd9824c770bbb4021d74d2bf560e4c6bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"c7b3542146734342e440a84b213384bfa188835537ddbda50d30766f0593aff9","affectsGlobalScope":true,"impliedFormat":1},{"version":"ce6180fa19b1cccd07ee7f7dbb9a367ac19c0ed160573e4686425060b6df7f57","affectsGlobalScope":true,"impliedFormat":1},{"version":"3f02e2476bccb9dbe21280d6090f0df17d2f66b74711489415a8aa4df73c9675","affectsGlobalScope":true,"impliedFormat":1},{"version":"45e3ab34c1c013c8ab2dc1ba4c80c780744b13b5676800ae2e3be27ae862c40c","affectsGlobalScope":true,"impliedFormat":1},{"version":"805c86f6cca8d7702a62a844856dbaa2a3fd2abef0536e65d48732441dde5b5b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e42e397f1a5a77994f0185fd1466520691456c772d06bf843e5084ceb879a0ad","affectsGlobalScope":true,"impliedFormat":1},{"version":"f4c2b41f90c95b1c532ecc874bd3c111865793b23aebcc1c3cbbabcd5d76ffb0","affectsGlobalScope":true,"impliedFormat":1},{"version":"ab26191cfad5b66afa11b8bf935ef1cd88fabfcb28d30b2dfa6fad877d050332","affectsGlobalScope":true,"impliedFormat":1},{"version":"2088bc26531e38fb05eedac2951480db5309f6be3fa4a08d2221abb0f5b4200d","affectsGlobalScope":true,"impliedFormat":1},{"version":"cb9d366c425fea79716a8fb3af0d78e6b22ebbab3bd64d25063b42dc9f531c1e","affectsGlobalScope":true,"impliedFormat":1},{"version":"500934a8089c26d57ebdb688fc9757389bb6207a3c8f0674d68efa900d2abb34","affectsGlobalScope":true,"impliedFormat":1},{"version":"689da16f46e647cef0d64b0def88910e818a5877ca5379ede156ca3afb780ac3","affectsGlobalScope":true,"impliedFormat":1},{"version":"bc21cc8b6fee4f4c2440d08035b7ea3c06b3511314c8bab6bef7a92de58a2593","affectsGlobalScope":true,"impliedFormat":1},{"version":"7ca53d13d2957003abb47922a71866ba7cb2068f8d154877c596d63c359fed25","affectsGlobalScope":true,"impliedFormat":1},{"version":"54725f8c4df3d900cb4dac84b64689ce29548da0b4e9b7c2de61d41c79293611","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5594bc3076ac29e6c1ebda77939bc4c8833de72f654b6e376862c0473199323","affectsGlobalScope":true,"impliedFormat":1},{"version":"2f3eb332c2d73e729f3364fcc0c2b375e72a121e8157d25a82d67a138c83a95c","affectsGlobalScope":true,"impliedFormat":1},{"version":"6f4427f9642ce8d500970e4e69d1397f64072ab73b97e476b4002a646ac743b1","affectsGlobalScope":true,"impliedFormat":1},{"version":"48915f327cd1dea4d7bd358d9dc7732f58f9e1626a29cc0c05c8c692419d9bb7","affectsGlobalScope":true,"impliedFormat":1},{"version":"b7bf9377723203b5a6a4b920164df22d56a43f593269ba6ae1fdc97774b68855","affectsGlobalScope":true,"impliedFormat":1},{"version":"db9709688f82c9e5f65a119c64d835f906efe5f559d08b11642d56eb85b79357","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b25b8c874acd1a4cf8444c3617e037d444d19080ac9f634b405583fd10ce1f7","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be57d7c90cf1f8112ee2636a068d8fd181289f82b744160ec56a7dc158a9f5","affectsGlobalScope":true,"impliedFormat":1},{"version":"a917a49ac94cd26b754ab84e113369a75d1a47a710661d7cd25e961cc797065f","affectsGlobalScope":true,"impliedFormat":1},{"version":"6d3261badeb7843d157ef3e6f5d1427d0eeb0af0cf9df84a62cfd29fd47ac86e","affectsGlobalScope":true,"impliedFormat":1},{"version":"195daca651dde22f2167ac0d0a05e215308119a3100f5e6268e8317d05a92526","affectsGlobalScope":true,"impliedFormat":1},{"version":"8b11e4285cd2bb164a4dc09248bdec69e9842517db4ca47c1ba913011e44ff2f","affectsGlobalScope":true,"impliedFormat":1},{"version":"0508571a52475e245b02bc50fa1394065a0a3d05277fbf5120c3784b85651799","affectsGlobalScope":true,"impliedFormat":1},{"version":"8f9af488f510c3015af3cc8c267a9e9d96c4dd38a1fdff0e11dc5a544711415b","affectsGlobalScope":true,"impliedFormat":1},{"version":"fc611fea8d30ea72c6bbfb599c9b4d393ce22e2f5bfef2172534781e7d138104","affectsGlobalScope":true,"impliedFormat":1},{"version":"f128dae7c44d8f35ee42e0a437000a57c9f06cc04f8b4fb42eebf44954d53dc8","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ecb8e347cb6b2a8927c09b86263663289418df375f5e68e11a0ae683776978f","affectsGlobalScope":true,"impliedFormat":1},{"version":"1ce14b81c5cc821994aa8ec1d42b220dd41b27fcc06373bce3958af7421b77d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3a048b3e9302ef9a34ef4ebb9aecfb28b66abb3bce577206a79fee559c230da","affectsGlobalScope":true,"impliedFormat":1},"ea3fd9cae074785c6a26ca3abc8cd919215b14e61a8277af3652b7b6a469f5b9",{"version":"37c1c274663963b9523a92a179b3a61990c72cf48b3988b5206ba2d81ce99c18","signature":"d3cb22893cb5edb7106b4eded21d68368d6f3c3708503c4d9bd004d06c9fdcca"},{"version":"d54b42ead742ba384a980f4ebcc5268cb01f488628f0cad9b86bb005b8743d2d","signature":"fc33c4a582c06286bff462417e2cc70af81ee00776d67d721509436542efe678"},{"version":"9f6ce49396194e711657387adce9d76c0b01a62dddac7b208920e7a2bdeefb8d","signature":"de100b2e38b4f55c5a5a811160a857c39d19edd54b56bab8e4637dba7f90e6a4"},"81c42c754119ef4c29959980f1bde23bbe03a1b86177a8f968b2b4cbaafc1bcc","c67d9f219ccdc4f89f99a4f422917e413a8696e5795e79c988b8490fb14f7526","0fb490a6869ddea3ec75f5f6d5a21054f82ce8cd60d472f9a1c70d42e295d4ac",{"version":"403f53a2c52f9ffddb558ba4dc48311356b90973a8d9f8b5e53d5a2b68dbec2e","signature":"e1db751364925b3dfba458f35260f9c0e15e051eb62df1004c0bd15d61d555fb"},"40da64abbee19779c6387fd03f5f6e34d359f58d72b270c7b007db3f5b61da45","c30ca61bc62858baaf36ea887fba9d0032a5e060407a1deb3bf4dd38be64361b","9fb602236e65c57126f2d090c9968fd7ff6e406c350039e76831de069cc9d1f5","ee6b02cf76fb93a0fd2e3ff4b3c869855c291f06312f172d01b88e5618e9d5ae","a7e598fa841346a3e39c09240df4f5954927750ca374db1201dd2a8972aa54d1","2f59322b90429e64312dc6e75c9ed31123b0743e7358272cb5b42a586b5894ae","4992632dde6be5bc3e48393b29731e4fd0c058dc763b33b52b673b017f137bc3",{"version":"41849007e704926b0a90d541cd4b27cb24ce250c86dae8cef37df96e55aaef21","signature":"dbe5e2e1be30c88d4492b8aaae9802d4bb9be42f992db4845a63fafc94d2b63b"},"42b300f515d975d3bf5777324b55b2231a7a7ae1c3a5d659248709cbbb987f9d",{"version":"5fbdf456666df12fd510a501a039798d98fe7010632661b27b53ba91c2fb542b","signature":"95b527255091cb3dbc37f13abe8fe88cdd1a3d3b2e86b79436a10a84eee34b4f"},"fa047096cf13a1fe0b45b2b4672e95fad831fc9a77be0516361eae6ec9454a3f","04adb19af4de59b923b996250d36447eed0cadec0a416ef7e4ded64a7afbe589",{"version":"d153a11543fd884b596587ccd97aebbeed950b26933ee000f94009f1ab142848","affectsGlobalScope":true,"impliedFormat":1},{"version":"0ccdaa19852d25ecd84eec365c3bfa16e7859cadecf6e9ca6d0dbbbee439743f","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc2110f7decca6bfb9392e30421cfa1436479e4a6756e8fec6cbc22625d4f881","affectsGlobalScope":true,"impliedFormat":1},{"version":"096116f8fedc1765d5bd6ef360c257b4a9048e5415054b3bf3c41b07f8951b0b","affectsGlobalScope":true,"impliedFormat":1},{"version":"e5e01375c9e124a83b52ee4b3244ed1a4d214a6cfb54ac73e164a823a4a7860a","affectsGlobalScope":true,"impliedFormat":1},{"version":"f90ae2bbce1505e67f2f6502392e318f5714bae82d2d969185c4a6cecc8af2fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"4b58e207b93a8f1c88bbf2a95ddc686ac83962b13830fe8ad3f404ffc7051fb4","affectsGlobalScope":true,"impliedFormat":1},{"version":"1fefabcb2b06736a66d2904074d56268753654805e829989a46a0161cd8412c5","affectsGlobalScope":true,"impliedFormat":1},{"version":"9798340ffb0d067d69b1ae5b32faa17ab31b82466a3fc00d8f2f2df0c8554aaa","affectsGlobalScope":true,"impliedFormat":1},{"version":"c18a99f01eb788d849ad032b31cafd49de0b19e083fe775370834c5675d7df8e","affectsGlobalScope":true,"impliedFormat":1},{"version":"5247874c2a23b9a62d178ae84f2db6a1d54e6c9a2e7e057e178cc5eea13757fc","affectsGlobalScope":true,"impliedFormat":1},{"version":"cdcf9ea426ad970f96ac930cd176d5c69c6c24eebd9fc580e1572d6c6a88f62c","impliedFormat":1},{"version":"23cd712e2ce083d68afe69224587438e5914b457b8acf87073c22494d706a3d0","impliedFormat":1},{"version":"156a859e21ef3244d13afeeba4e49760a6afa035c149dda52f0c45ea8903b338","impliedFormat":1},{"version":"10ec5e82144dfac6f04fa5d1d6c11763b3e4dbbac6d99101427219ab3e2ae887","impliedFormat":1},{"version":"615754924717c0b1e293e083b83503c0a872717ad5aa60ed7f1a699eb1b4ea5c","impliedFormat":1},{"version":"074de5b2fdead0165a2757e3aaef20f27a6347b1c36adea27d51456795b37682","impliedFormat":1},{"version":"68834d631c8838c715f225509cfc3927913b9cc7a4870460b5b60c8dbdb99baf","impliedFormat":1},{"version":"4137ebf04166f3a325f056aa56101adc75e9dceb30404a1844eb8604d89770e2","impliedFormat":1},{"version":"ccab02f3920fc75c01174c47fcf67882a11daf16baf9e81701d0a94636e94556","impliedFormat":1},{"version":"3e11fce78ad8c0e1d1db4ba5f0652285509be3acdd519529bc8fcef85f7dafd9","impliedFormat":1},{"version":"ea6bc8de8b59f90a7a3960005fd01988f98fd0784e14bc6922dde2e93305ec7d","impliedFormat":1},{"version":"36107995674b29284a115e21a0618c4c2751b32a8766dd4cb3ba740308b16d59","impliedFormat":1},{"version":"914a0ae30d96d71915fc519ccb4efbf2b62c0ddfb3a3fc6129151076bc01dc60","impliedFormat":1},{"version":"9c32412007b5662fd34a8eb04292fb5314ec370d7016d1c2fb8aa193c807fe22","impliedFormat":1},{"version":"7fd1b31fd35876b0aa650811c25ec2c97a3c6387e5473eb18004bed86cdd76b6","impliedFormat":1},{"version":"4d327f7d72ad0918275cea3eee49a6a8dc8114ae1d5b7f3f5d0774de75f7439a","impliedFormat":1},{"version":"6ebe8ebb8659aaa9d1acbf3710d7dae3e923e97610238b9511c25dc39023a166","impliedFormat":1},{"version":"e85d7f8068f6a26710bff0cc8c0fc5e47f71089c3780fbede05857331d2ddec9","impliedFormat":1},{"version":"7befaf0e76b5671be1d47b77fcc65f2b0aad91cc26529df1904f4a7c46d216e9","impliedFormat":1},{"version":"0a60a292b89ca7218b8616f78e5bbd1c96b87e048849469cccb4355e98af959a","impliedFormat":1},{"version":"0b6e25234b4eec6ed96ab138d96eb70b135690d7dd01f3dd8a8ab291c35a683a","impliedFormat":1},{"version":"9666f2f84b985b62400d2e5ab0adae9ff44de9b2a34803c2c5bd3c8325b17dc0","impliedFormat":1},{"version":"40cd35c95e9cf22cfa5bd84e96408b6fcbca55295f4ff822390abb11afbc3dca","impliedFormat":1},{"version":"b1616b8959bf557feb16369c6124a97a0e74ed6f49d1df73bb4b9ddf68acf3f3","impliedFormat":1},{"version":"5b03a034c72146b61573aab280f295b015b9168470f2df05f6080a2122f9b4df","impliedFormat":1},{"version":"40b463c6766ca1b689bfcc46d26b5e295954f32ad43e37ee6953c0a677e4ae2b","impliedFormat":1},{"version":"249b9cab7f5d628b71308c7d9bb0a808b50b091e640ba3ed6e2d0516f4a8d91d","impliedFormat":1},{"version":"80aae6afc67faa5ac0b32b5b8bc8cc9f7fa299cff15cf09cc2e11fd28c6ae29e","impliedFormat":1},{"version":"f473cd2288991ff3221165dcf73cd5d24da30391f87e85b3dd4d0450c787a391","impliedFormat":1},{"version":"499e5b055a5aba1e1998f7311a6c441a369831c70905cc565ceac93c28083d53","impliedFormat":1},{"version":"8aee8b6d4f9f62cf3776cda1305fb18763e2aade7e13cea5bbe699112df85214","impliedFormat":1},{"version":"98498b101803bb3dde9f76a56e65c14b75db1cc8bec5f4db72be541570f74fc5","impliedFormat":1},{"version":"1cc2a09e1a61a5222d4174ab358a9f9de5e906afe79dbf7363d871a7edda3955","impliedFormat":1},{"version":"5d0375ca7310efb77e3ef18d068d53784faf62705e0ad04569597ae0e755c401","impliedFormat":1},{"version":"59af37caec41ecf7b2e76059c9672a49e682c1a2aa6f9d7dc78878f53aa284d6","impliedFormat":1},{"version":"addf417b9eb3f938fddf8d81e96393a165e4be0d4a8b6402292f9c634b1cb00d","impliedFormat":1},{"version":"b64d4d1c5f877f9c666e98e833f0205edb9384acc46e98a1fef344f64d6aba44","impliedFormat":1},{"version":"adf27937dba6af9f08a68c5b1d3fce0ca7d4b960c57e6d6c844e7d1a8e53adae","impliedFormat":1},{"version":"12950411eeab8563b349cb7959543d92d8d02c289ed893d78499a19becb5a8cc","impliedFormat":1},{"version":"2e85db9e6fd73cfa3d7f28e0ab6b55417ea18931423bd47b409a96e4a169e8e6","impliedFormat":1},{"version":"c46e079fe54c76f95c67fb89081b3e399da2c7d109e7dca8e4b58d83e332e605","impliedFormat":1},{"version":"c9381908473a1c92cb8c516b184e75f4d226dad95c3a85a5af35f670064d9a2f","impliedFormat":1},{"version":"c3f5289820990ab66b70c7fb5b63cb674001009ff84b13de40619619a9c8175f","affectsGlobalScope":true,"impliedFormat":1},{"version":"b3275d55fac10b799c9546804126239baf020d220136163f763b55a74e50e750","affectsGlobalScope":true,"impliedFormat":1},{"version":"fa68a0a3b7cb32c00e39ee3cd31f8f15b80cac97dce51b6ee7fc14a1e8deb30b","affectsGlobalScope":true,"impliedFormat":1},{"version":"1cf059eaf468efcc649f8cf6075d3cb98e9a35a0fe9c44419ec3d2f5428d7123","affectsGlobalScope":true,"impliedFormat":1},{"version":"6c36e755bced82df7fb6ce8169265d0a7bb046ab4e2cb6d0da0cb72b22033e89","affectsGlobalScope":true,"impliedFormat":1},{"version":"e7721c4f69f93c91360c26a0a84ee885997d748237ef78ef665b153e622b36c1","affectsGlobalScope":true,"impliedFormat":1},{"version":"7a93de4ff8a63bafe62ba86b89af1df0ccb5e40bb85b0c67d6bbcfdcf96bf3d4","affectsGlobalScope":true,"impliedFormat":1},{"version":"90e85f9bc549dfe2b5749b45fe734144e96cd5d04b38eae244028794e142a77e","affectsGlobalScope":true,"impliedFormat":1},{"version":"e0a5deeb610b2a50a6350bd23df6490036a1773a8a71d70f2f9549ab009e67ee","affectsGlobalScope":true,"impliedFormat":1},{"version":"d2ae155afe8a01cc0ae612d99117cf8ef16692ba7c4366590156fdec1bcf2d8c","impliedFormat":1},{"version":"3f5e5d9be35913db9fea42a63f3df0b7e3c8703b97670a2125587b4dbbd56d7c","impliedFormat":1},{"version":"8caeb65fdc3bfe0d13f86f67324fcb2d858ed1c55f1f0cce892eb1acfb9f3239","impliedFormat":1},{"version":"57c23df0b5f7a8e26363a3849b0bc7763f6b241207157c8e40089d1df4116f35","affectsGlobalScope":true,"impliedFormat":1},{"version":"3b8bc0c17b54081b0878673989216229e575d67a10874e84566a21025a2461ee","impliedFormat":1},{"version":"5b0db5a58b73498792a29bfebc333438e61906fef75da898b410e24e52229e6f","impliedFormat":1},{"version":"dbe055b2b29a7bab2c1ca8f259436306adb43f469dca7e639a02cd3695d3f621","impliedFormat":1},{"version":"1678b04557dca52feab73cc67610918a7f5e25bfdba3e7fa081acd625d93106d","impliedFormat":1},{"version":"e3905f6902f0b69e5eefc230daa69fdd4ab707a973ec2d086d65af1b3ea47ef0","impliedFormat":1},{"version":"2ea729503db9793f2691162fec3dd1118cab62e96d025f8eeb376d43ec293395","impliedFormat":1},{"version":"9ec87fea42b92894b0f209931a880789d43c3397d09dd99c631ae40a2f7071d1","impliedFormat":1},{"version":"c68e88cdfadfb6c8ba5fc38e58a3a166b0beae77b1f05b7d921150a32a5ffb8d","impliedFormat":1},{"version":"2bc7aa4fba46df0bd495425a7c8201437a7d465f83854fac859df2d67f664df3","impliedFormat":1},{"version":"41d17e1ad9a002feb11c8cdd2777e5bbc0cdb1e3f595d237e4dded0b6949983b","impliedFormat":1},{"version":"07e4e61e946a9c15045539ecd5f5d2d02e7aab6fa82567826857e09cf0f37c2e","affectsGlobalScope":true,"impliedFormat":1},{"version":"1c4714ccc29149efb8777a1da0b04b8d2258f5d13ddbf4cd3c3d361fb531ac86","impliedFormat":1},{"version":"3ff275f84f89f8a7c0543da838f9da9614201abc4ce74c533029825adfb4433d","impliedFormat":1},{"version":"0eb5d0cbf09de5d34542b977fd6a933bb2e0817bffe8e1a541b2f1ad1b9af1ff","impliedFormat":1},{"version":"10deca769dfed888051b1808d6746f8883a490a707f8bdf9367079146987d6d0","impliedFormat":1},{"version":"2c2bdaa1d8ead9f68628d6d9d250e46ee8e81aa4898b4769a36956ae15e060fe","impliedFormat":1},{"version":"c32c840c62d8bd7aeb3147aa6754cd2d922b990a6b6634530cb2ebdce5adc8e9","impliedFormat":1},{"version":"e1c1a0b4d1ead0de9eca52203aeb1f771f21e6238d6fcd15aa56ac2a02f1b7bf","impliedFormat":1},{"version":"82b91e4e42e6c41bc7fc1b6c2dc5eba6a2ba98375eb1f210e6ff6bba2d54177e","impliedFormat":1},{"version":"6fe28249ac0c7bc19a79aa9264baf00efbd080e868dbe1d3052033ad1c64f206","affectsGlobalScope":true,"impliedFormat":1},{"version":"cbed824fec91efefc7bbdcb8b43d1a531fdbebd0e2ef19481501ff365a93cb70","impliedFormat":1},{"version":"4967529644e391115ca5592184d4b63980569adf60ee685f968fd59ab1557188","impliedFormat":1},{"version":"d0716593b3f2b0451bcf0c24cfa86dec2235c325c89f201934248b7c742715fc","impliedFormat":1},{"version":"ec501101c2a96133a6c695f934c8f6642149cc728571b29cbb7b770984c1088e","impliedFormat":1},{"version":"b214ebcf76c51b115453f69729ee8aa7b7f8eccdae2a922b568a45c2d7ff52f7","impliedFormat":1},{"version":"429c9cdfa7d126255779efd7e6d9057ced2d69c81859bbab32073bad52e9ba76","impliedFormat":1},{"version":"2991bca2cc0f0628a278df2a2ccdb8d6cbcb700f3761abbed62bba137d5b1790","impliedFormat":1},{"version":"ce8653341224f8b45ff46d2a06f2cacb96f841f768a886c9d8dd8ec0878b11bd","affectsGlobalScope":true,"impliedFormat":1},{"version":"230763250f20449fa7b3c9273e1967adb0023dc890d4be1553faca658ee65971","impliedFormat":1},{"version":"c3e9078b60cb329d1221f5878e88cecfa3e74460550e605a58fcfb41a66029ff","impliedFormat":1},{"version":"a74edb3bab7394a9dbde529d60632be590def2f5f01024dbd85441587fbfbbe0","impliedFormat":1},{"version":"0ea59f7d3e51440baa64f429253759b106cfcbaf51e474cae606e02265b37cf8","impliedFormat":1},{"version":"bc18a1991ba681f03e13285fa1d7b99b03b67ee671b7bc936254467177543890","impliedFormat":1},{"version":"00049ccc87f3f37726db03c01ca68fe74fd9c0109b68c29eb9923ebec2c76b13","impliedFormat":1},{"version":"fa94bbf532b7af8f394b95fa310980d6e20bd2d4c871c6a6cb9f70f03750a44b","impliedFormat":1},{"version":"68d3f35108e2608b1f2f28b36d19d7055f31c4465cc5692cbd06c716a9fe7973","impliedFormat":1},{"version":"a6d543044570fbeed13a7f9925a868081cd2b14ef59cdd9da6ae76d41cab03d3","affectsGlobalScope":true,"impliedFormat":1},{"version":"7fa2214bb0d64701bc6f9ce8cde2fd2ff8c571e0b23065fa04a8a5a6beb91511","impliedFormat":1},{"version":"f1c93e046fb3d9b7f8249629f4b63dc068dd839b824dd0aa39a5e68476dc9420","impliedFormat":1},{"version":"016b29bf4926b80255a108c53a1451717350059da04fcae64d1075f5e93bbb39","impliedFormat":1},{"version":"841983e39bd4cbb463be385e92fda11057cab368bf27100a801c492f1d86cbaa","impliedFormat":1},{"version":"6f5383b3df1cdf4ff1aa7fb0850f77042b5786b5e65ec9a9b6be56ebfe4d9036","impliedFormat":1},{"version":"62fc21ed9ccbd83bd1166de277a4b5daaa8d15b5fa614c75610d20f3b73fba87","impliedFormat":1},{"version":"e4156ddb25aa0e3b5303d372f26957b36778f0f6bbd4326359269873295e3058","affectsGlobalScope":true,"impliedFormat":1},{"version":"cc1b433a84cae05ddc5672d4823170af78606ad21ecef60dbc4570190cbf1357","impliedFormat":1},{"version":"9d3821bc75c59577e52643324cec92fc2145642e8d17cf7ee07a3181f21d985d","impliedFormat":1},{"version":"7f78cfb2b343838612c192cb251746e3a7c62ac7675726a47e130d9b213f6580","impliedFormat":1},{"version":"201db9cf1687fab1adf5282fcba861f382b32303dc4f67c89d59655e78a25461","impliedFormat":1},{"version":"c77fb31bc17fd241d3922a9f88c59e3361cdf76d1328ba9412fc6bf7310b638d","impliedFormat":1},{"version":"0a20eaf2e4b1e3c1e1f87f7bccb0c936375b23b022baeea750519b7c9bc6ce83","impliedFormat":1},{"version":"b484ec11ba00e3a2235562a41898d55372ccabe607986c6fa4f4aba72093749f","impliedFormat":1},{"version":"a16b91b27bd6b706c687c88cbc8a7d4ee98e5ed6043026d6b84bda923c0aed67","impliedFormat":1},{"version":"694b812e0ed11285e8822cf8131e3ce7083a500b3b1d185fff9ed1089677bd0a","impliedFormat":1},{"version":"99ab6d0d660ce4d21efb52288a39fd35bb3f556980ec5463b1ae8f304a3bbc85","impliedFormat":1},{"version":"6eeded8c7e352be6e0efb83f4935ec752513c4d22043b52522b90849a49a3a11","impliedFormat":1},{"version":"6c1ad90050ffbb151cacc68e2d06ea1a26a945659391e32651f5d42b86fd7f2c","impliedFormat":1},{"version":"55cdbeebe76a1fa18bbd7e7bf73350a2173926bd3085bb050cf5a5397025ee4e","impliedFormat":1},{"version":"6e215dac8b234548d91b718f9c07d5b09473cd5cabb29053fcd8be0af190acb6","affectsGlobalScope":true,"impliedFormat":1},{"version":"0d759cc99e081cacd0352467a0c24e979a6ef748329aa6ddea2d789664580201","impliedFormat":1},{"version":"f3d3e999a323c85c8a63ce90c6e4624ff89fe137a0e2508fddc08e0556d08abf","impliedFormat":1},{"version":"314607151cc203975193d5f44765f38597be3b0a43f466d3c1bfb17176dd3bd3","impliedFormat":1},{"version":"47767435860d3f8dccb0f6263bdca9ad112058014e1802e63c32bd0907e5c550","impliedFormat":1},{"version":"f40aad6c91017f20fc542f5701ec41e0f6aeba63c61bbf7aa13266ec29a50a3b","impliedFormat":1},{"version":"fc9e630f9302d0414ccd6c8ed2706659cff5ae454a56560c6122fa4a3fac5bbd","affectsGlobalScope":true,"impliedFormat":1},{"version":"aa0a44af370a2d7c1aac988a17836f57910a6c52689f52f5b3ac1d4c6cadcb23","impliedFormat":1},{"version":"0ac74c7586880e26b6a599c710b59284a284e084a2bbc82cd40fb3fbfdea71ae","affectsGlobalScope":true,"impliedFormat":1},{"version":"2ce12357dadbb8efc4e4ec4dab709c8071bf992722fc9adfea2fe0bd5b50923f","impliedFormat":1},{"version":"b5a907deaba678e5083ccdd7cc063a3a8c3413c688098f6de29d6e4cefabc85f","impliedFormat":1},{"version":"ffd344731abee98a0a85a735b19052817afd2156d97d1410819cd9bcd1bd575e","impliedFormat":1},{"version":"475e07c959f4766f90678425b45cf58ac9b95e50de78367759c1e5118e85d5c3","impliedFormat":1},{"version":"a524ae401b30a1b0814f1bbcdae459da97fa30ae6e22476e506bb3f82e3d9456","impliedFormat":1},{"version":"7375e803c033425e27cb33bae21917c106cb37b508fd242cccd978ef2ee244c7","impliedFormat":1},{"version":"eeb890c7e9218afdad2f30ad8a76b0b0b5161d11ce13b6723879de408e6bc47a","impliedFormat":1},{"version":"998da6b85ebace9ebea67040dd1a640f0156064e3d28dbe9bd9c0229b6f72347","impliedFormat":1},{"version":"00a196792eed6e9b7f988db0d3ced11a94ecd1e258fd19124ce89fe7642df35a","affectsGlobalScope":true,"impliedFormat":1},{"version":"944d65951e33a13068be5cd525ec42bf9bc180263ba0b723fa236970aa21f611","affectsGlobalScope":true,"impliedFormat":1},{"version":"6b386c7b6ce6f369d18246904fa5eac73566167c88fb6508feba74fa7501a384","affectsGlobalScope":true,"impliedFormat":1},{"version":"592a109e67b907ffd2078cd6f727d5c326e06eaada169eef8fb18546d96f6797","impliedFormat":1},{"version":"f2eb1e35cae499d57e34b4ac3650248776fe7dbd9a3ec34b23754cfd8c22fceb","impliedFormat":1},{"version":"fbed43a6fcf5b675f5ec6fc960328114777862b58a2bb19c109e8fc1906caa09","impliedFormat":1},{"version":"9e98bd421e71f70c75dae7029e316745c89fa7b8bc8b43a91adf9b82c206099c","impliedFormat":1},{"version":"fc803e6b01f4365f71f51f9ce13f71396766848204d4f7a1b2b6154434b84b15","impliedFormat":1},{"version":"f3afcc0d6f77a9ca2d2c5c92eb4b89cd38d6fa4bdc1410d626bd701760a977ec","impliedFormat":1},{"version":"c8109fe76467db6e801d0edfbc50e6826934686467c9418ce6b246232ce7f109","affectsGlobalScope":true,"impliedFormat":1},{"version":"e6f803e4e45915d58e721c04ec17830c6e6678d1e3e00e28edf3d52720909cea","affectsGlobalScope":true,"impliedFormat":1},{"version":"37be812b06e518320ba82e2aff3ac2ca37370a9df917db708f081b9043fa3315","impliedFormat":1}],"root":[[61,80]],"options":{"allowImportingTsExtensions":true,"composite":true,"esModuleInterop":true,"module":99,"outDir":"./dist","rootDir":"./src","skipLibCheck":true,"strict":true,"target":9,"verbatimModuleSyntax":true},"referencedMap":[[232,1],[143,2],[144,2],[145,3],[83,4],[146,5],[147,6],[148,7],[81,8],[149,9],[150,10],[151,11],[152,12],[153,13],[154,14],[155,14],[156,15],[157,16],[158,17],[159,18],[84,8],[82,8],[160,19],[161,20],[162,21],[203,22],[163,23],[164,24],[165,23],[166,25],[167,26],[169,27],[170,28],[171,28],[172,28],[173,29],[174,30],[175,31],[176,32],[177,33],[178,34],[179,34],[180,35],[181,8],[182,8],[183,36],[184,37],[185,36],[186,38],[187,39],[188,40],[189,41],[190,42],[191,43],[192,44],[193,45],[194,46],[195,47],[196,48],[197,49],[198,50],[199,51],[200,52],[85,23],[86,8],[87,53],[88,54],[89,8],[90,55],[91,8],[134,56],[135,57],[136,58],[137,58],[138,59],[139,8],[140,60],[141,61],[142,57],[201,62],[202,63],[168,8],[208,64],[230,8],[229,8],[223,65],[210,66],[209,8],[206,67],[211,8],[204,68],[212,8],[231,69],[213,8],[207,8],[222,70],[224,71],[205,72],[228,73],[226,74],[225,75],[227,76],[214,8],[220,77],[217,78],[219,79],[218,80],[216,81],[215,8],[221,82],[59,8],[60,8],[10,8],[12,8],[11,8],[2,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],[20,8],[3,8],[21,8],[22,8],[4,8],[23,8],[27,8],[24,8],[25,8],[26,8],[28,8],[29,8],[30,8],[5,8],[31,8],[32,8],[33,8],[34,8],[6,8],[38,8],[35,8],[36,8],[37,8],[39,8],[7,8],[40,8],[45,8],[46,8],[41,8],[42,8],[43,8],[44,8],[8,8],[50,8],[47,8],[48,8],[49,8],[51,8],[9,8],[52,8],[53,8],[54,8],[56,8],[55,8],[57,8],[1,8],[58,8],[110,83],[122,84],[107,85],[123,86],[132,87],[98,88],[99,89],[97,90],[131,91],[126,92],[130,93],[101,94],[119,95],[100,96],[129,97],[95,98],[96,92],[102,99],[103,8],[109,100],[106,99],[93,101],[133,102],[124,103],[113,104],[112,99],[114,105],[117,106],[111,107],[115,108],[127,91],[104,109],[105,110],[118,111],[94,86],[121,112],[120,99],[108,110],[116,113],[125,8],[92,8],[128,114],[71,115],[72,116],[70,117],[73,118],[74,54],[61,8],[67,119],[69,120],[63,121],[64,122],[66,54],[65,123],[68,124],[62,8],[79,125],[80,126],[76,8],[78,127],[77,128],[75,8]],"affectedFilesPendingEmit":[[71,17],[72,17],[70,17],[73,17],[74,17],[61,17],[67,17],[69,17],[63,17],[64,17],[66,17],[65,17],[68,17],[62,17],[79,17],[80,17],[76,17],[78,17],[77,17],[75,17]],"emitSignatures":[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80],"version":"6.0.3"}
\ No newline at end of file
diff --git a/packages/mcp-unified-gateway/src/tools.ts b/packages/mcp-unified-gateway/src/tools.ts
index e109ee8b..f0192248 100644
--- a/packages/mcp-unified-gateway/src/tools.ts
+++ b/packages/mcp-unified-gateway/src/tools.ts
@@ -12,10 +12,15 @@
  * Changelog v0.2.0:
  *   GAP-002 — egos_repo_health: tokens group=core retornam só {branch,is_clean,commits_ahead}
  *   GAP-006 — egos_list_tasks: tokens não-full leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado)
+ *
+ * Changelog v0.3.0:
+ *   NEW — egos_notebooklm_query: consulta notebook via nlm CLI (subprocess)
+ *   NEW — egos_banda: roda Banda Cognitiva (mode=economico) com rate-guard 1/min por token
+ *   NEW — egos_capabilities_demo: resumo público de capacidades para visitantes na demo
  */
 
 import { z } from "zod";
-import { execSync } from "node:child_process";
+import { execSync, spawnSync } from "node:child_process";
 import { readFileSync, existsSync, readdirSync, appendFileSync } from "node:fs";
 import { join, dirname } from "node:path";
 import { fileURLToPath } from "node:url";
@@ -238,6 +243,82 @@ const toolGetMetaprompt: ToolDef = {
   },
 };
 
+/**
+ * egos_notebooklm_query — v0.3.0
+ *
+ * Consulta um notebook NotebookLM via `nlm notebook query <id> <question> --json`.
+ * O `nlm` CLI (~/.local/bin/nlm) é o único acesso viável ao NotebookLM a partir do
+ * gateway standalone (MCPs do Claude Code não estão disponíveis aqui).
+ *
+ * Restrição de dado soberano: esta tool NÃO aceita notebook_id cujo conteúdo possa
+ * conter PCMG/PII/intelink. Validação: o chamador é responsável — a tool não filtra IDs
+ * (não tem inventário de notebooks). Lembrete inline no retorno.
+ *
+ * Fronteira §4 EGOS_SURFACES_ROUTING.md: dado soberano → Odysseus LOCAL + modelo local.
+ */
+const toolNotebooklmQuery: ToolDef = {
+  name: "egos_notebooklm_query",
+  group: "knowledge",
+  scope: "read",
+  description:
+    "Consulta um notebook NotebookLM via nlm CLI. Informe notebook_id (ID do notebook no Google) e a pergunta. NUNCA usar com notebooks que contenham dado soberano (PCMG/PII/intelink).",
+  inputSchema: z.object({
+    notebook_id: z.string().min(1).describe("ID do notebook NotebookLM (ex: '1abc2...')"),
+    question: z.string().min(10).max(500).describe("Pergunta a fazer ao notebook"),
+  }),
+  handler: (input) => {
+    const { notebook_id, question } = input as { notebook_id: string; question: string };
+
+    // Verificação de disponibilidade do nlm CLI
+    const nlmPath = execSafe("which nlm 2>/dev/null || echo ''");
+    if (!nlmPath || nlmPath.startsWith("Erro")) {
+      return {
+        status: "requires_notebooklm_bridge",
+        note: "nlm CLI não encontrado no PATH. Instale via: pip install notebooklm-cli ou similar. O gateway precisa de nlm acessível no mesmo PATH do processo.",
+        missing: "nlm CLI (which nlm retornou vazio)",
+      };
+    }
+
+    // spawnSync para capturar stdout/stderr separadamente e evitar shell injection
+    const result = spawnSync(
+      nlmPath,
+      ["notebook", "query", notebook_id, question, "--json"],
+      { encoding: "utf8", timeout: 90_000 }
+    );
+
+    if (result.error) {
+      return { error: `Falha ao chamar nlm: ${result.error.message}` };
+    }
+    if (result.status !== 0) {
+      const stderr = (result.stderr ?? "").slice(0, 400);
+      return {
+        error: "nlm notebook query retornou erro",
+        stderr,
+        note: "Verifique se o notebook_id é válido e se o perfil nlm está autenticado (nlm login).",
+      };
+    }
+
+    // Tenta parsear JSON; fallback para texto bruto
+    const stdout = (result.stdout ?? "").trim();
+    try {
+      const parsed = JSON.parse(stdout) as unknown;
+      return {
+        notebook_id,
+        question,
+        answer: parsed,
+        sovereignty_reminder: "NÃO usar com notebooks contendo dado soberano (PCMG/PII). SSOT: docs/governance/EGOS_SURFACES_ROUTING.md §4.",
+      };
+    } catch {
+      return {
+        notebook_id,
+        question,
+        answer_raw: stdout.slice(0, 3_000),
+        sovereignty_reminder: "NÃO usar com notebooks contendo dado soberano (PCMG/PII). SSOT: docs/governance/EGOS_SURFACES_ROUTING.md §4.",
+      };
+    }
+  },
+};
+
 // ── OPS tools ────────────────────────────────────────────────────────────────
 // Operações de sistema: listar serviços, roteamento LLM.
 
@@ -299,6 +380,139 @@ const toolHealthCheck: ToolDef = {
   },
 };
 
+/**
+ * egos_banda — v0.3.0
+ *
+ * Roda a Banda Cognitiva (scripts/banda.ts --mode economico) para uma pergunta.
+ * Mode economico = Haiku 4.5 via OpenRouter (~$0.05/banda). NUNCA usa council (caro).
+ *
+ * RATE-GUARD: máximo 1 execução de banda por token por minuto.
+ * Decisão (ver §PENDENTE abaixo): tokens sem grupo "full" são BLOQUEADOS — custo recai
+ * no dono do gateway. Visitante não tem acesso a esta tool.
+ *
+ * Requisito MP-R1/R2: question ≥ 40 chars, context ≥ 200 chars (gate do próprio banda.ts).
+ * Se o gate falhar, o stderr é retornado com instrução de correção.
+ */
+
+// Rate-guard: 1 banda/min por token. Map em memória (reinicia com o processo).
+const _bandaRateMap = new Map<string, number>();
+const BANDA_COOLDOWN_MS = 60_000;
+
+const toolBanda: ToolDef = {
+  name: "egos_banda",
+  group: "ops",
+  scope: "read",
+  description:
+    "Roda a Banda Cognitiva EGOS (análise hierárquica: Crítico → Apoiador → Questionador → Maestro) em mode economico (Haiku). Requer grupo 'full'. Rate-limit: 1 execução/minuto por token. Pergunta mínima: 40 chars. Contexto mínimo: 200 chars (MP-R1/R2).",
+  inputSchema: z.object({
+    question: z.string().min(40).max(800).describe("Pergunta para a Banda (mínimo 40 chars com critério de aceite)"),
+    context: z.string().min(200).max(3000).describe("Contexto operacional da pergunta (mínimo 200 chars: paths, estado REAL/CONCEPT/PHANTOM, SHA se aplicável)"),
+  }),
+  handler: (input, tokenGroups, _tokenScopes) => {
+    // Acesso restrito a tokens com grupo "full" — custo recai no gateway owner
+    const isFullAccess = tokenGroups?.includes("full") ?? false;
+    if (!isFullAccess) {
+      return {
+        error: "egos_banda requer grupo 'full'. Tokens de visitante não têm acesso (custo LLM recairia no gateway). Solicite token full ao administrador EGOS.",
+        groups_needed: ["full"],
+      };
+    }
+
+    const { question, context } = input as { question: string; context: string };
+
+    // Rate-guard: 1 execução/minuto por token (identificador = join dos grupos, sem expor token bruto)
+    const ratKey = (tokenGroups ?? []).sort().join("|");
+    const lastCall = _bandaRateMap.get(ratKey) ?? 0;
+    const elapsed = Date.now() - lastCall;
+    if (elapsed < BANDA_COOLDOWN_MS) {
+      const waitSecs = Math.ceil((BANDA_COOLDOWN_MS - elapsed) / 1000);
+      return {
+        error: `Rate-limit egos_banda: 1 execução/minuto por token. Aguarde ${waitSecs}s.`,
+        retry_after_seconds: waitSecs,
+      };
+    }
+    _bandaRateMap.set(ratKey, Date.now());
+
+    // Verifica banda.ts existe
+    const bandaScript = join(REPO_ROOT, "scripts/banda.ts");
+    if (!existsSync(bandaScript)) {
+      return { error: `banda.ts não encontrado em ${bandaScript}` };
+    }
+
+    // Executa banda em mode economico. MP-gate cumpre-se via flags min-length do inputSchema
+    // (question ≥40, context ≥200). O gate do banda.ts reforça no process.
+    const result = spawnSync(
+      "bun",
+      ["run", bandaScript, "--question", question, "--context", context, "--mode", "economico"],
+      { encoding: "utf8", timeout: 120_000, cwd: REPO_ROOT }
+    );
+
+    if (result.error) {
+      return { error: `Falha ao executar banda.ts: ${result.error.message}` };
+    }
+
+    const stdout = (result.stdout ?? "").trim();
+    const stderr = (result.stderr ?? "").trim();
+
+    if (result.status !== 0) {
+      // stderr pode conter output útil do MP-gate (instrução de correção)
+      return {
+        error: "banda.ts terminou com erro",
+        stderr: stderr.slice(0, 600),
+        stdout: stdout.slice(0, 200),
+        note: "Verifique se question ≥40 chars com critério de aceite e context ≥200 chars (MP-R1/R2).",
+      };
+    }
+
+    return {
+      maestro_synthesis: stdout.slice(0, 4_000),
+      mode: "economico",
+      note: "Output é a síntese do Maestro. Para trace completo, veja docs/banda/ no repositório.",
+    };
+  },
+};
+
+/**
+ * egos_capabilities_demo — v0.3.0
+ *
+ * Retorna resumo público e curado do que o EGOS sabe fazer.
+ * Fonte: STATUS_PUBLIC.md (corpus sanitizado) + lista das tools disponíveis no gateway.
+ * ZERO menção a intelink / PCMG / clientes reais.
+ * Destinado a visitantes e demos em hub.egos.ia.br.
+ */
+const toolCapabilitiesDemo: ToolDef = {
+  name: "egos_capabilities_demo",
+  group: "core",
+  scope: "read",
+  description:
+    "Resumo público das capacidades do EGOS Framework para visitantes e demos. Baseado em STATUS_PUBLIC.md + tools do gateway. Sem dados internos.",
+  inputSchema: z.object({}),
+  handler: () => {
+    const publicStatus = readFileSafe(
+      join(REPO_ROOT, "docs/governance/STATUS_PUBLIC.md"),
+      6_000
+    );
+
+    // Lista as tools do próprio gateway (nomes e descrições) como prova de capacidade
+    const toolSummary = ALL_TOOLS.map((t) => ({
+      name: t.name,
+      group: t.group,
+      scope: t.scope,
+      description: t.description,
+    }));
+
+    return {
+      framework: "EGOS Framework",
+      version: "v0.3.0",
+      public_status: publicStatus || "(STATUS_PUBLIC.md não encontrado)",
+      gateway_tools: toolSummary,
+      total_tools: toolSummary.length,
+      note:
+        "Este resumo é o corpus público sanitizado. Não contém dados de clientes, sistemas internos ou dado soberano. Para acesso completo, solicite token ao administrador EGOS.",
+    };
+  },
+};
+
 // ── OPS / full scope — mutação ────────────────────────────────────────────────
 // Apenas para tokens com scope "full". Registrar anotação/learning.
 
@@ -332,12 +546,15 @@ export const ALL_TOOLS: ToolDef[] = [
   toolListTasks,
   toolRepoHealth,
   toolListCapabilities,
+  toolCapabilitiesDemo,
   // knowledge
   toolSearchKnowledge,
   toolGetMetaprompt,
+  toolNotebooklmQuery,
   // ops
   toolListServices,
   toolHealthCheck,
+  toolBanda,
   toolRecordLearning,
 ];
 
diff --git a/scripts/coordination-watcher.ts b/scripts/coordination-watcher.ts
index bb2865df..8fff006f 100755
--- a/scripts/coordination-watcher.ts
+++ b/scripts/coordination-watcher.ts
@@ -137,6 +137,7 @@ const PERSISTENT_BLACKBOARD_MD = resolve(EGOS_DIR, 'coordination-blackboard.md')
 const TELEMETRY_HISTORY_JSONL = resolve(EGOS_DIR, 'coordination-history.jsonl');
 
 let lastStatusString = '';
+let lastAnalysisTs = 0;
 
 function sh(cmd: string, cwd: string): string {
   try {
@@ -301,6 +302,43 @@ Be precise and avoid fluff.`;
   }
 }
 
+/**
+ * Estado "dirty" SEM chamada de LLM (COST-CONTROL 2026-06-10). Escreve git status
+ * real + heartbeat fresco + lista de arquivos — zero custo. O resumo LLM (luxo) só
+ * roda com EGOS_WATCHER_LLM=1. Coordenação entre janelas não depende do resumo.
+ */
+function writeDirtyStateNoLLM(status: string) {
+  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
+  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
+  const files = status.split('\n').filter(Boolean);
+  const md = [
+    `# 📋 EGOS Live Coordination Blackboard`,
+    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
+    `*Commit HEAD: ${headSha}* | *Ramo: ${branchName}*`,
+    `\n---`,
+    `🟡 **${files.length} arquivo(s) modificado(s)** (resumo LLM desligado — EGOS_WATCHER_LLM=1 p/ ligar).`,
+    ...files.slice(0, 40).map((f) => `- \`${f}\``),
+  ].join('\n');
+  const json = {
+    timestamp: new Date().toISOString(),
+    head: headSha,
+    branch: branchName,
+    status: 'dirty',
+    summary: `🟡 ${files.length} arquivo(s) modificado(s) (resumo LLM off).`,
+    rawStatus: status,
+    analysisDegraded: true,
+    repos: scanAllRepos(),
+  };
+  writeFileSync(VOLATILE_BLACKBOARD_MD, md, 'utf8');
+  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
+  writeFileSync(PERSISTENT_BLACKBOARD_MD, md, 'utf8');
+  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
+  logTelemetry({
+    timestamp: new Date().toISOString(), status: 'dirty', head: headSha, branch: branchName,
+    changedFilesCount: files.length, modelUsed: null, tokensUsed: null, costUsd: 0, latencyMs: 0,
+  });
+}
+
 function writeCleanState() {
   const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
   const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
@@ -395,9 +433,20 @@ async function checkWorkspace() {
     return;
   }
 
+  // COST-CONTROL (Enio 2026-06-10): a análise LLM é ENRIQUECIMENTO opcional, não
+  // crítico (o heartbeat/git-state já é escrito sem LLM). Rodava a CADA mudança de
+  // arquivo → 194 chamadas/$0.54 num dia intenso. Agora OFF por padrão; ligue com
+  // EGOS_WATCHER_LLM=1 (e mesmo ligado, throttle de 10min entre análises).
+  const LLM_ENABLED = process.env.EGOS_WATCHER_LLM === '1';
+  const THROTTLE_MS = 10 * 60 * 1000;
+  if (!LLM_ENABLED || Date.now() - lastAnalysisTs < THROTTLE_MS) {
+    // Estado completo SEM resumo LLM (git status real, heartbeat fresco, $0)
+    writeDirtyStateNoLLM(status);
+    return;
+  }
+  lastAnalysisTs = Date.now();
   const diff = sh('git diff --no-color', REPO_ROOT);
   const commits = sh('git log -n 5 --oneline', REPO_ROOT);
-  
   await runAnalysis(status, diff, commits);
 }
 

exec
/bin/bash -lc "sed -n '1,220p' packages/mcp-unified-gateway/src/tools.ts && sed -n '220,620p' packages/mcp-unified-gateway/src/tools.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * @egos/mcp-unified-gateway — tools.ts
 *
 * Catálogo de tools por feature group.
 * Cada tool tem: name, description, group, scope, inputSchema (zod), handler.
 *
 * Groups: core | knowledge | ops | full
 * Scopes: read (consulta) | full (mutação)
 *
 * REGRA: tools "full" scope nunca são expostas para tokens read-only.
 *
 * Changelog v0.2.0:
 *   GAP-002 — egos_repo_health: tokens group=core retornam só {branch,is_clean,commits_ahead}
 *   GAP-006 — egos_list_tasks: tokens não-full leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado)
 *
 * Changelog v0.3.0:
 *   NEW — egos_notebooklm_query: consulta notebook via nlm CLI (subprocess)
 *   NEW — egos_banda: roda Banda Cognitiva (mode=economico) com rate-guard 1/min por token
 *   NEW — egos_capabilities_demo: resumo público de capacidades para visitantes na demo
 */

import { z } from "zod";
import { execSync, spawnSync } from "node:child_process";
import { readFileSync, existsSync, readdirSync, appendFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import type { Group, Scope } from "./auth.js";

const __dir = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(__dir, "../../..");

// ── Tool definition ─────────────────────────────────────────────────────────
export interface ToolDef {
  name: string;
  description: string;
  group: Group;
  scope: Scope;
  inputSchema: z.ZodTypeAny;
  // groups e scopes do token são injetados pelo caller para filtros runtime
  handler: (input: unknown, tokenGroups?: string[], tokenScopes?: string[]) => Promise<unknown> | unknown;
}

// ── Helpers ──────────────────────────────────────────────────────────────────
function readFileSafe(path: string, maxBytes = 32_000): string {
  if (!existsSync(path)) return "";
  const content = readFileSync(path, "utf8");
  return content.length > maxBytes ? content.slice(0, maxBytes) + "\n… [truncado]" : content;
}

function execSafe(cmd: string, cwd: string = REPO_ROOT): string {
  try {
    return execSync(cmd, { cwd, timeout: 15_000, encoding: "utf8" }).trim();
  } catch (e) {
    return `Erro: ${(e as Error).message.slice(0, 300)}`;
  }
}

// ── CORE tools ───────────────────────────────────────────────────────────────
// Subset essencial: status do sistema, lista de tasks, health. Read-only.

const toolSystemStatus: ToolDef = {
  name: "egos_system_status",
  group: "core",
  scope: "read",
  description: "Status geral do sistema EGOS: commits recentes, tasks abertas, PM2 processes.",
  inputSchema: z.object({}),
  handler: () => {
    const recentCommits = execSafe("git log --oneline -5", REPO_ROOT);
    const tasksPreview = readFileSafe(join(REPO_ROOT, "TASKS.md"), 3_000);
    const pm2Status = execSafe("pm2 jlist 2>/dev/null || echo '[]'", REPO_ROOT);

    let pm2Summary = "PM2 não disponível";
    try {
      const procs = JSON.parse(pm2Status) as Array<{ name: string; pm2_env?: { status: string } }>;
      pm2Summary = procs.map((p) => `${p.name}: ${p.pm2_env?.status ?? "?"}`).join(", ");
    } catch {}

    return {
      commits: recentCommits,
      tasks_preview: tasksPreview,
      pm2: pm2Summary,
    };
  },
};

/**
 * GAP-006 — egos_list_tasks
 * Tokens com group "full" leem TASKS.md real.
 * Tokens sem "full" (ex: group=core) leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado,
 * zero referências a sistemas internos, clientes reais ou paths sensíveis).
 */
const toolListTasks: ToolDef = {
  name: "egos_list_tasks",
  group: "core",
  scope: "read",
  description: "Lista tasks/status do EGOS. Tokens externos recebem corpus público sanitizado.",
  inputSchema: z.object({
    filter: z.string().optional().describe("Texto para filtrar linhas (ex: 'P0', 'MCP', 'WIP')"),
  }),
  handler: (input, tokenGroups) => {
    const { filter } = input as { filter?: string };
    const isFullAccess = tokenGroups?.includes("full") ?? false;

    // GAP-006: seleciona corpus conforme nível de acesso
    const filePath = isFullAccess
      ? join(REPO_ROOT, "TASKS.md")
      : join(REPO_ROOT, "docs/governance/STATUS_PUBLIC.md");

    const content = readFileSafe(filePath, 8_000);

    if (!content) {
      return { tasks: "(corpus não disponível)", corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md" };
    }
    if (!filter) return { tasks: content, corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md" };

    const lines = content.split("\n").filter((l) => l.toLowerCase().includes(filter.toLowerCase()));
    return {
      tasks: lines.join("\n"),
      total_matches: lines.length,
      corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md",
    };
  },
};

/**
 * GAP-002 — egos_repo_health
 * Tokens com group "full" recebem git status completo (com paths).
 * Tokens sem "full" (ex: group=core) recebem apenas {branch, is_clean, commits_ahead}
 * — sem paths de arquivos modificados.
 */
const toolRepoHealth: ToolDef = {
  name: "egos_repo_health",
  group: "core",
  scope: "read",
  description: "Saúde do repositório: branch, status de limpeza, commits à frente.",
  inputSchema: z.object({}),
  handler: (_input, tokenGroups) => {
    const isFullAccess = tokenGroups?.includes("full") ?? false;
    const branch = execSafe("git branch --show-current", REPO_ROOT);
    const ahead = execSafe("git rev-list --count @{u}..HEAD 2>/dev/null || echo '?'", REPO_ROOT);

    if (isFullAccess) {
      // acesso completo: retorna status com paths (comportamento anterior)
      const status = execSafe("git status --short", REPO_ROOT);
      return { branch, status: status || "(limpo)", commits_ahead: ahead };
    }

    // GAP-002: grupo core — apenas metadados sem paths de arquivos
    const statusShort = execSafe("git status --short", REPO_ROOT);
    const is_clean = statusShort.trim() === "";
    return { branch, is_clean, commits_ahead: ahead };
  },
};

const toolListCapabilities: ToolDef = {
  name: "egos_list_capabilities",
  group: "core",
  scope: "read",
  description: "Lista capabilities registradas no CAPABILITY_REGISTRY.md com status REAL/CONCEPT/PHANTOM.",
  inputSchema: z.object({
    filter: z.string().optional().describe("Filtro por nome ou status"),
  }),
  handler: (input) => {
    const { filter } = input as { filter?: string };
    const content = readFileSafe(join(REPO_ROOT, "docs/CAPABILITY_REGISTRY.md"), 10_000);
    if (!filter) return { registry: content };
    const lines = content.split("\n").filter((l) => l.toLowerCase().includes(filter.toLowerCase()));
    return { registry: lines.join("\n") };
  },
};

// ── KNOWLEDGE tools ──────────────────────────────────────────────────────────
// Acesso a learnings, metaprompts, wiki interna.

const toolSearchKnowledge: ToolDef = {
  name: "egos_search_knowledge",
  group: "knowledge",
  scope: "read",
  description: "Busca em HARVEST.md (learnings), metaprompts e docs de governança.",
  inputSchema: z.object({
    query: z.string().describe("Termo de busca"),
    source: z.enum(["harvest", "metaprompts", "governance", "all"]).default("all"),
  }),
  handler: (input) => {
    const { query, source } = input as { query: string; source: string };

    const results: Record<string, string> = {};
    const q = query.toLowerCase();

    const searchFile = (label: string, path: string) => {
      const content = readFileSafe(path, 12_000);
      const lines = content.split("\n").filter((l) => l.toLowerCase().includes(q));
      if (lines.length > 0) results[label] = lines.slice(0, 30).join("\n");
    };

    if (source === "harvest" || source === "all") {
      searchFile("harvest", join(REPO_ROOT, "docs/knowledge/HARVEST.md"));
    }
    if (source === "metaprompts" || source === "all") {
      const mpDir = join(REPO_ROOT, "docs/metaprompts");
      if (existsSync(mpDir)) {
        for (const f of readdirSync(mpDir).filter((x) => x.endsWith(".md"))) {
          searchFile(`metaprompt:${f}`, join(mpDir, f));
        }
      }
    }
    if (source === "governance" || source === "all") {
      searchFile("agents_md", join(REPO_ROOT, "AGENTS.md"));
      searchFile("claude_md", join(REPO_ROOT, "CLAUDE.md"));
    }

    return Object.keys(results).length > 0 ? results : { message: "Nenhum resultado encontrado" };
  },
};

const toolGetMetaprompt: ToolDef = {
  name: "egos_get_metaprompt",
  group: "knowledge",
  scope: "read",
  description: "Retorna o conteúdo de um metaprompt pelo nome (ex: 'start', 'end', 'MP-001').",
  description: "Retorna o conteúdo de um metaprompt pelo nome (ex: 'start', 'end', 'MP-001').",
  inputSchema: z.object({
    name: z.string().describe("Nome do metaprompt (ex: 'start', 'end', 'MP-ITEM-INTAKE-001')"),
  }),
  handler: (input) => {
    const { name } = input as { name: string };
    const candidates = [
      join(REPO_ROOT, ".claude/commands", `${name}.md`),
      join(REPO_ROOT, "docs/metaprompts", `${name}.md`),
      join(REPO_ROOT, "docs/metaprompts", `${name.toUpperCase()}.md`),
    ];
    for (const c of candidates) {
      if (existsSync(c)) return { name, content: readFileSafe(c, 15_000) };
    }
    // Try partial match in metaprompts dir
    const mpDir = join(REPO_ROOT, "docs/metaprompts");
    if (existsSync(mpDir)) {
      const match = readdirSync(mpDir).find((f) =>
        f.toLowerCase().includes(name.toLowerCase())
      );
      if (match) return { name: match, content: readFileSafe(join(mpDir, match), 15_000) };
    }
    return { error: `Metaprompt '${name}' não encontrado` };
  },
};

/**
 * egos_notebooklm_query — v0.3.0
 *
 * Consulta um notebook NotebookLM via `nlm notebook query <id> <question> --json`.
 * O `nlm` CLI (~/.local/bin/nlm) é o único acesso viável ao NotebookLM a partir do
 * gateway standalone (MCPs do Claude Code não estão disponíveis aqui).
 *
 * Restrição de dado soberano: esta tool NÃO aceita notebook_id cujo conteúdo possa
 * conter PCMG/PII/intelink. Validação: o chamador é responsável — a tool não filtra IDs
 * (não tem inventário de notebooks). Lembrete inline no retorno.
 *
 * Fronteira §4 EGOS_SURFACES_ROUTING.md: dado soberano → Odysseus LOCAL + modelo local.
 */
const toolNotebooklmQuery: ToolDef = {
  name: "egos_notebooklm_query",
  group: "knowledge",
  scope: "read",
  description:
    "Consulta um notebook NotebookLM via nlm CLI. Informe notebook_id (ID do notebook no Google) e a pergunta. NUNCA usar com notebooks que contenham dado soberano (PCMG/PII/intelink).",
  inputSchema: z.object({
    notebook_id: z.string().min(1).describe("ID do notebook NotebookLM (ex: '1abc2...')"),
    question: z.string().min(10).max(500).describe("Pergunta a fazer ao notebook"),
  }),
  handler: (input) => {
    const { notebook_id, question } = input as { notebook_id: string; question: string };

    // Verificação de disponibilidade do nlm CLI
    const nlmPath = execSafe("which nlm 2>/dev/null || echo ''");
    if (!nlmPath || nlmPath.startsWith("Erro")) {
      return {
        status: "requires_notebooklm_bridge",
        note: "nlm CLI não encontrado no PATH. Instale via: pip install notebooklm-cli ou similar. O gateway precisa de nlm acessível no mesmo PATH do processo.",
        missing: "nlm CLI (which nlm retornou vazio)",
      };
    }

    // spawnSync para capturar stdout/stderr separadamente e evitar shell injection
    const result = spawnSync(
      nlmPath,
      ["notebook", "query", notebook_id, question, "--json"],
      { encoding: "utf8", timeout: 90_000 }
    );

    if (result.error) {
      return { error: `Falha ao chamar nlm: ${result.error.message}` };
    }
    if (result.status !== 0) {
      const stderr = (result.stderr ?? "").slice(0, 400);
      return {
        error: "nlm notebook query retornou erro",
        stderr,
        note: "Verifique se o notebook_id é válido e se o perfil nlm está autenticado (nlm login).",
      };
    }

    // Tenta parsear JSON; fallback para texto bruto
    const stdout = (result.stdout ?? "").trim();
    try {
      const parsed = JSON.parse(stdout) as unknown;
      return {
        notebook_id,
        question,
        answer: parsed,
        sovereignty_reminder: "NÃO usar com notebooks contendo dado soberano (PCMG/PII). SSOT: docs/governance/EGOS_SURFACES_ROUTING.md §4.",
      };
    } catch {
      return {
        notebook_id,
        question,
        answer_raw: stdout.slice(0, 3_000),
        sovereignty_reminder: "NÃO usar com notebooks contendo dado soberano (PCMG/PII). SSOT: docs/governance/EGOS_SURFACES_ROUTING.md §4.",
      };
    }
  },
};

// ── OPS tools ────────────────────────────────────────────────────────────────
// Operações de sistema: listar serviços, roteamento LLM.

const toolListServices: ToolDef = {
  name: "egos_list_services",
  group: "ops",
  scope: "read",
  description: "Lista serviços PM2 em execução com status e uso de memória.",
  inputSchema: z.object({}),
  handler: () => {
    const raw = execSafe("pm2 jlist 2>/dev/null || echo '[]'");
    try {
      const procs = JSON.parse(raw) as Array<{
        name: string;
        pm2_env?: { status: string; pm_uptime?: number };
        monit?: { memory: number; cpu: number };
      }>;
      return {
        services: procs.map((p) => ({
          name: p.name,
          status: p.pm2_env?.status ?? "?",
          memory_mb: p.monit ? Math.round(p.monit.memory / 1_048_576) : null,
          cpu_pct: p.monit?.cpu ?? null,
          uptime_s: p.pm2_env?.pm_uptime
            ? Math.round((Date.now() - p.pm2_env.pm_uptime) / 1000)
            : null,
        })),
      };
    } catch {
      return { raw };
    }
  },
};

const toolHealthCheck: ToolDef = {
  name: "egos_health_check",
  group: "ops",
  scope: "read",
  description: "Verifica saúde de uma URL (HTTP GET, timeout 5s).",
  inputSchema: z.object({
    url: z.string().url().describe("URL para verificar (somente HTTPS permitido em produção)"),
  }),
  handler: async (input) => {
    const { url } = input as { url: string };
    const IS_PROD_ENV = process.env.NODE_ENV === "production";
    if (IS_PROD_ENV && !url.startsWith("https://")) {
      return { error: "Somente HTTPS em produção" };
    }
    try {
      const res = await fetch(url, {
        signal: AbortSignal.timeout(5_000),
        method: "GET",
      });
      const text = (await res.text()).slice(0, 300);
      return { status: res.status, ok: res.ok, body_preview: text };
    } catch (e) {
      return { error: (e as Error).message };
    }
  },
};

/**
 * egos_banda — v0.3.0
 *
 * Roda a Banda Cognitiva (scripts/banda.ts --mode economico) para uma pergunta.
 * Mode economico = Haiku 4.5 via OpenRouter (~$0.05/banda). NUNCA usa council (caro).
 *
 * RATE-GUARD: máximo 1 execução de banda por token por minuto.
 * Decisão (ver §PENDENTE abaixo): tokens sem grupo "full" são BLOQUEADOS — custo recai
 * no dono do gateway. Visitante não tem acesso a esta tool.
 *
 * Requisito MP-R1/R2: question ≥ 40 chars, context ≥ 200 chars (gate do próprio banda.ts).
 * Se o gate falhar, o stderr é retornado com instrução de correção.
 */

// Rate-guard: 1 banda/min por token. Map em memória (reinicia com o processo).
const _bandaRateMap = new Map<string, number>();
const BANDA_COOLDOWN_MS = 60_000;

const toolBanda: ToolDef = {
  name: "egos_banda",
  group: "ops",
  scope: "read",
  description:
    "Roda a Banda Cognitiva EGOS (análise hierárquica: Crítico → Apoiador → Questionador → Maestro) em mode economico (Haiku). Requer grupo 'full'. Rate-limit: 1 execução/minuto por token. Pergunta mínima: 40 chars. Contexto mínimo: 200 chars (MP-R1/R2).",
  inputSchema: z.object({
    question: z.string().min(40).max(800).describe("Pergunta para a Banda (mínimo 40 chars com critério de aceite)"),
    context: z.string().min(200).max(3000).describe("Contexto operacional da pergunta (mínimo 200 chars: paths, estado REAL/CONCEPT/PHANTOM, SHA se aplicável)"),
  }),
  handler: (input, tokenGroups, _tokenScopes) => {
    // Acesso restrito a tokens com grupo "full" — custo recai no gateway owner
    const isFullAccess = tokenGroups?.includes("full") ?? false;
    if (!isFullAccess) {
      return {
        error: "egos_banda requer grupo 'full'. Tokens de visitante não têm acesso (custo LLM recairia no gateway). Solicite token full ao administrador EGOS.",
        groups_needed: ["full"],
      };
    }

    const { question, context } = input as { question: string; context: string };

    // Rate-guard: 1 execução/minuto por token (identificador = join dos grupos, sem expor token bruto)
    const ratKey = (tokenGroups ?? []).sort().join("|");
    const lastCall = _bandaRateMap.get(ratKey) ?? 0;
    const elapsed = Date.now() - lastCall;
    if (elapsed < BANDA_COOLDOWN_MS) {
      const waitSecs = Math.ceil((BANDA_COOLDOWN_MS - elapsed) / 1000);
      return {
        error: `Rate-limit egos_banda: 1 execução/minuto por token. Aguarde ${waitSecs}s.`,
        retry_after_seconds: waitSecs,
      };
    }
    _bandaRateMap.set(ratKey, Date.now());

    // Verifica banda.ts existe
    const bandaScript = join(REPO_ROOT, "scripts/banda.ts");
    if (!existsSync(bandaScript)) {
      return { error: `banda.ts não encontrado em ${bandaScript}` };
    }

    // Executa banda em mode economico. MP-gate cumpre-se via flags min-length do inputSchema
    // (question ≥40, context ≥200). O gate do banda.ts reforça no process.
    const result = spawnSync(
      "bun",
      ["run", bandaScript, "--question", question, "--context", context, "--mode", "economico"],
      { encoding: "utf8", timeout: 120_000, cwd: REPO_ROOT }
    );

    if (result.error) {
      return { error: `Falha ao executar banda.ts: ${result.error.message}` };
    }

    const stdout = (result.stdout ?? "").trim();
    const stderr = (result.stderr ?? "").trim();

    if (result.status !== 0) {
      // stderr pode conter output útil do MP-gate (instrução de correção)
      return {
        error: "banda.ts terminou com erro",
        stderr: stderr.slice(0, 600),
        stdout: stdout.slice(0, 200),
        note: "Verifique se question ≥40 chars com critério de aceite e context ≥200 chars (MP-R1/R2).",
      };
    }

    return {
      maestro_synthesis: stdout.slice(0, 4_000),
      mode: "economico",
      note: "Output é a síntese do Maestro. Para trace completo, veja docs/banda/ no repositório.",
    };
  },
};

/**
 * egos_capabilities_demo — v0.3.0
 *
 * Retorna resumo público e curado do que o EGOS sabe fazer.
 * Fonte: STATUS_PUBLIC.md (corpus sanitizado) + lista das tools disponíveis no gateway.
 * ZERO menção a intelink / PCMG / clientes reais.
 * Destinado a visitantes e demos em hub.egos.ia.br.
 */
const toolCapabilitiesDemo: ToolDef = {
  name: "egos_capabilities_demo",
  group: "core",
  scope: "read",
  description:
    "Resumo público das capacidades do EGOS Framework para visitantes e demos. Baseado em STATUS_PUBLIC.md + tools do gateway. Sem dados internos.",
  inputSchema: z.object({}),
  handler: () => {
    const publicStatus = readFileSafe(
      join(REPO_ROOT, "docs/governance/STATUS_PUBLIC.md"),
      6_000
    );

    // Lista as tools do próprio gateway (nomes e descrições) como prova de capacidade
    const toolSummary = ALL_TOOLS.map((t) => ({
      name: t.name,
      group: t.group,
      scope: t.scope,
      description: t.description,
    }));

    return {
      framework: "EGOS Framework",
      version: "v0.3.0",
      public_status: publicStatus || "(STATUS_PUBLIC.md não encontrado)",
      gateway_tools: toolSummary,
      total_tools: toolSummary.length,
      note:
        "Este resumo é o corpus público sanitizado. Não contém dados de clientes, sistemas internos ou dado soberano. Para acesso completo, solicite token ao administrador EGOS.",
    };
  },
};

// ── OPS / full scope — mutação ────────────────────────────────────────────────
// Apenas para tokens com scope "full". Registrar anotação/learning.

const toolRecordLearning: ToolDef = {
  name: "egos_record_learning",
  group: "ops",
  scope: "full",
  description: "Registra um learning em docs/knowledge/HARVEST.md (requer scope full).",
  inputSchema: z.object({
    learning: z.string().max(2000).describe("Texto do learning a registrar"),
    category: z.string().optional().describe("Categoria (ex: 'MCP', 'Auth', 'Gateway')"),
  }),
  handler: (input) => {
    const { learning, category } = input as { learning: string; category?: string };
    const harvestPath = join(REPO_ROOT, "docs/knowledge/HARVEST.md");
    if (!existsSync(harvestPath)) return { error: "HARVEST.md não encontrado" };

    const ts = new Date().toISOString().slice(0, 10);
    const cat = category ? ` [${category}]` : "";
    const entry = `\n- **${ts}**${cat}: ${learning}`;

    appendFileSync(harvestPath, entry, "utf8");
    return { ok: true, appended: entry };
  },
};

// ── Export all tools ─────────────────────────────────────────────────────────
export const ALL_TOOLS: ToolDef[] = [
  // core
  toolSystemStatus,
  toolListTasks,
  toolRepoHealth,
  toolListCapabilities,
  toolCapabilitiesDemo,
  // knowledge
  toolSearchKnowledge,
  toolGetMetaprompt,
  toolNotebooklmQuery,
  // ops
  toolListServices,
  toolHealthCheck,
  toolBanda,
  toolRecordLearning,
];

/**
 * Filtra tools pelo groups e scope do token.
 * - "full" group = acesso a todos os groups
 * - scope "read" = exclui tools que requerem scope "full"
 */
export function filterTools(
  groups: string[],
  scopes: string[]
): ToolDef[] {
  const hasFullGroup = groups.includes("full");
  const hasFullScope = scopes.includes("full");

  return ALL_TOOLS.filter((t) => {
    const groupOk = hasFullGroup || groups.includes(t.group);
    const scopeOk = hasFullScope || t.scope === "read";
    return groupOk && scopeOk;
  });
}

exec
/bin/bash -lc "git show 5bcc06c832a7beee1dfce1cb561ad5b123359b30:packages/mcp-unified-gateway/src/tools.ts | sed -n '1,420p'" in /home/enio/egos
 succeeded in 0ms:
/**
 * @egos/mcp-unified-gateway — tools.ts
 *
 * Catálogo de tools por feature group.
 * Cada tool tem: name, description, group, scope, inputSchema (zod), handler.
 *
 * Groups: core | knowledge | ops | full
 * Scopes: read (consulta) | full (mutação)
 *
 * REGRA: tools "full" scope nunca são expostas para tokens read-only.
 *
 * Changelog v0.2.0:
 *   GAP-002 — egos_repo_health: tokens group=core retornam só {branch,is_clean,commits_ahead}
 *   GAP-006 — egos_list_tasks: tokens não-full leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado)
 */

import { z } from "zod";
import { execSync } from "node:child_process";
import { readFileSync, existsSync, readdirSync, appendFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import type { Group, Scope } from "./auth.js";

const __dir = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(__dir, "../../..");

// ── Tool definition ─────────────────────────────────────────────────────────
export interface ToolDef {
  name: string;
  description: string;
  group: Group;
  scope: Scope;
  inputSchema: z.ZodTypeAny;
  // groups e scopes do token são injetados pelo caller para filtros runtime
  handler: (input: unknown, tokenGroups?: string[], tokenScopes?: string[]) => Promise<unknown> | unknown;
}

// ── Helpers ──────────────────────────────────────────────────────────────────
function readFileSafe(path: string, maxBytes = 32_000): string {
  if (!existsSync(path)) return "";
  const content = readFileSync(path, "utf8");
  return content.length > maxBytes ? content.slice(0, maxBytes) + "\n… [truncado]" : content;
}

function execSafe(cmd: string, cwd: string = REPO_ROOT): string {
  try {
    return execSync(cmd, { cwd, timeout: 15_000, encoding: "utf8" }).trim();
  } catch (e) {
    return `Erro: ${(e as Error).message.slice(0, 300)}`;
  }
}

// ── CORE tools ───────────────────────────────────────────────────────────────
// Subset essencial: status do sistema, lista de tasks, health. Read-only.

const toolSystemStatus: ToolDef = {
  name: "egos_system_status",
  group: "core",
  scope: "read",
  description: "Status geral do sistema EGOS: commits recentes, tasks abertas, PM2 processes.",
  inputSchema: z.object({}),
  handler: () => {
    const recentCommits = execSafe("git log --oneline -5", REPO_ROOT);
    const tasksPreview = readFileSafe(join(REPO_ROOT, "TASKS.md"), 3_000);
    const pm2Status = execSafe("pm2 jlist 2>/dev/null || echo '[]'", REPO_ROOT);

    let pm2Summary = "PM2 não disponível";
    try {
      const procs = JSON.parse(pm2Status) as Array<{ name: string; pm2_env?: { status: string } }>;
      pm2Summary = procs.map((p) => `${p.name}: ${p.pm2_env?.status ?? "?"}`).join(", ");
    } catch {}

    return {
      commits: recentCommits,
      tasks_preview: tasksPreview,
      pm2: pm2Summary,
    };
  },
};

/**
 * GAP-006 — egos_list_tasks
 * Tokens com group "full" leem TASKS.md real.
 * Tokens sem "full" (ex: group=core) leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado,
 * zero referências a sistemas internos, clientes reais ou paths sensíveis).
 */
const toolListTasks: ToolDef = {
  name: "egos_list_tasks",
  group: "core",
  scope: "read",
  description: "Lista tasks/status do EGOS. Tokens externos recebem corpus público sanitizado.",
  inputSchema: z.object({
    filter: z.string().optional().describe("Texto para filtrar linhas (ex: 'P0', 'MCP', 'WIP')"),
  }),
  handler: (input, tokenGroups) => {
    const { filter } = input as { filter?: string };
    const isFullAccess = tokenGroups?.includes("full") ?? false;

    // GAP-006: seleciona corpus conforme nível de acesso
    const filePath = isFullAccess
      ? join(REPO_ROOT, "TASKS.md")
      : join(REPO_ROOT, "docs/governance/STATUS_PUBLIC.md");

    const content = readFileSafe(filePath, 8_000);

    if (!content) {
      return { tasks: "(corpus não disponível)", corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md" };
    }
    if (!filter) return { tasks: content, corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md" };

    const lines = content.split("\n").filter((l) => l.toLowerCase().includes(filter.toLowerCase()));
    return {
      tasks: lines.join("\n"),
      total_matches: lines.length,
      corpus: isFullAccess ? "TASKS.md" : "STATUS_PUBLIC.md",
    };
  },
};

/**
 * GAP-002 — egos_repo_health
 * Tokens com group "full" recebem git status completo (com paths).
 * Tokens sem "full" (ex: group=core) recebem apenas {branch, is_clean, commits_ahead}
 * — sem paths de arquivos modificados.
 */
const toolRepoHealth: ToolDef = {
  name: "egos_repo_health",
  group: "core",
  scope: "read",
  description: "Saúde do repositório: branch, status de limpeza, commits à frente.",
  inputSchema: z.object({}),
  handler: (_input, tokenGroups) => {
    const isFullAccess = tokenGroups?.includes("full") ?? false;
    const branch = execSafe("git branch --show-current", REPO_ROOT);
    const ahead = execSafe("git rev-list --count @{u}..HEAD 2>/dev/null || echo '?'", REPO_ROOT);

    if (isFullAccess) {
      // acesso completo: retorna status com paths (comportamento anterior)
      const status = execSafe("git status --short", REPO_ROOT);
      return { branch, status: status || "(limpo)", commits_ahead: ahead };
    }

    // GAP-002: grupo core — apenas metadados sem paths de arquivos
    const statusShort = execSafe("git status --short", REPO_ROOT);
    const is_clean = statusShort.trim() === "";
    return { branch, is_clean, commits_ahead: ahead };
  },
};

const toolListCapabilities: ToolDef = {
  name: "egos_list_capabilities",
  group: "core",
  scope: "read",
  description: "Lista capabilities registradas no CAPABILITY_REGISTRY.md com status REAL/CONCEPT/PHANTOM.",
  inputSchema: z.object({
    filter: z.string().optional().describe("Filtro por nome ou status"),
  }),
  handler: (input) => {
    const { filter } = input as { filter?: string };
    const content = readFileSafe(join(REPO_ROOT, "docs/CAPABILITY_REGISTRY.md"), 10_000);
    if (!filter) return { registry: content };
    const lines = content.split("\n").filter((l) => l.toLowerCase().includes(filter.toLowerCase()));
    return { registry: lines.join("\n") };
  },
};

// ── KNOWLEDGE tools ──────────────────────────────────────────────────────────
// Acesso a learnings, metaprompts, wiki interna.

const toolSearchKnowledge: ToolDef = {
  name: "egos_search_knowledge",
  group: "knowledge",
  scope: "read",
  description: "Busca em HARVEST.md (learnings), metaprompts e docs de governança.",
  inputSchema: z.object({
    query: z.string().describe("Termo de busca"),
    source: z.enum(["harvest", "metaprompts", "governance", "all"]).default("all"),
  }),
  handler: (input) => {
    const { query, source } = input as { query: string; source: string };

    const results: Record<string, string> = {};
    const q = query.toLowerCase();

    const searchFile = (label: string, path: string) => {
      const content = readFileSafe(path, 12_000);
      const lines = content.split("\n").filter((l) => l.toLowerCase().includes(q));
      if (lines.length > 0) results[label] = lines.slice(0, 30).join("\n");
    };

    if (source === "harvest" || source === "all") {
      searchFile("harvest", join(REPO_ROOT, "docs/knowledge/HARVEST.md"));
    }
    if (source === "metaprompts" || source === "all") {
      const mpDir = join(REPO_ROOT, "docs/metaprompts");
      if (existsSync(mpDir)) {
        for (const f of readdirSync(mpDir).filter((x) => x.endsWith(".md"))) {
          searchFile(`metaprompt:${f}`, join(mpDir, f));
        }
      }
    }
    if (source === "governance" || source === "all") {
      searchFile("agents_md", join(REPO_ROOT, "AGENTS.md"));
      searchFile("claude_md", join(REPO_ROOT, "CLAUDE.md"));
    }

    return Object.keys(results).length > 0 ? results : { message: "Nenhum resultado encontrado" };
  },
};

const toolGetMetaprompt: ToolDef = {
  name: "egos_get_metaprompt",
  group: "knowledge",
  scope: "read",
  description: "Retorna o conteúdo de um metaprompt pelo nome (ex: 'start', 'end', 'MP-001').",
  inputSchema: z.object({
    name: z.string().describe("Nome do metaprompt (ex: 'start', 'end', 'MP-ITEM-INTAKE-001')"),
  }),
  handler: (input) => {
    const { name } = input as { name: string };
    const candidates = [
      join(REPO_ROOT, ".claude/commands", `${name}.md`),
      join(REPO_ROOT, "docs/metaprompts", `${name}.md`),
      join(REPO_ROOT, "docs/metaprompts", `${name.toUpperCase()}.md`),
    ];
    for (const c of candidates) {
      if (existsSync(c)) return { name, content: readFileSafe(c, 15_000) };
    }
    // Try partial match in metaprompts dir
    const mpDir = join(REPO_ROOT, "docs/metaprompts");
    if (existsSync(mpDir)) {
      const match = readdirSync(mpDir).find((f) =>
        f.toLowerCase().includes(name.toLowerCase())
      );
      if (match) return { name: match, content: readFileSafe(join(mpDir, match), 15_000) };
    }
    return { error: `Metaprompt '${name}' não encontrado` };
  },
};

// ── OPS tools ────────────────────────────────────────────────────────────────
// Operações de sistema: listar serviços, roteamento LLM.

const toolListServices: ToolDef = {
  name: "egos_list_services",
  group: "ops",
  scope: "read",
  description: "Lista serviços PM2 em execução com status e uso de memória.",
  inputSchema: z.object({}),
  handler: () => {
    const raw = execSafe("pm2 jlist 2>/dev/null || echo '[]'");
    try {
      const procs = JSON.parse(raw) as Array<{
        name: string;
        pm2_env?: { status: string; pm_uptime?: number };
        monit?: { memory: number; cpu: number };
      }>;
      return {
        services: procs.map((p) => ({
          name: p.name,
          status: p.pm2_env?.status ?? "?",
          memory_mb: p.monit ? Math.round(p.monit.memory / 1_048_576) : null,
          cpu_pct: p.monit?.cpu ?? null,
          uptime_s: p.pm2_env?.pm_uptime
            ? Math.round((Date.now() - p.pm2_env.pm_uptime) / 1000)
            : null,
        })),
      };
    } catch {
      return { raw };
    }
  },
};

const toolHealthCheck: ToolDef = {
  name: "egos_health_check",
  group: "ops",
  scope: "read",
  description: "Verifica saúde de uma URL (HTTP GET, timeout 5s).",
  inputSchema: z.object({
    url: z.string().url().describe("URL para verificar (somente HTTPS permitido em produção)"),
  }),
  handler: async (input) => {
    const { url } = input as { url: string };
    const IS_PROD_ENV = process.env.NODE_ENV === "production";
    if (IS_PROD_ENV && !url.startsWith("https://")) {
      return { error: "Somente HTTPS em produção" };
    }
    try {
      const res = await fetch(url, {
        signal: AbortSignal.timeout(5_000),
        method: "GET",
      });
      const text = (await res.text()).slice(0, 300);
      return { status: res.status, ok: res.ok, body_preview: text };
    } catch (e) {
      return { error: (e as Error).message };
    }
  },
};

// ── OPS / full scope — mutação ────────────────────────────────────────────────
// Apenas para tokens com scope "full". Registrar anotação/learning.

const toolRecordLearning: ToolDef = {
  name: "egos_record_learning",
  group: "ops",
  scope: "full",
  description: "Registra um learning em docs/knowledge/HARVEST.md (requer scope full).",
  inputSchema: z.object({
    learning: z.string().max(2000).describe("Texto do learning a registrar"),
    category: z.string().optional().describe("Categoria (ex: 'MCP', 'Auth', 'Gateway')"),
  }),
  handler: (input) => {
    const { learning, category } = input as { learning: string; category?: string };
    const harvestPath = join(REPO_ROOT, "docs/knowledge/HARVEST.md");
    if (!existsSync(harvestPath)) return { error: "HARVEST.md não encontrado" };

    const ts = new Date().toISOString().slice(0, 10);
    const cat = category ? ` [${category}]` : "";
    const entry = `\n- **${ts}**${cat}: ${learning}`;

    appendFileSync(harvestPath, entry, "utf8");
    return { ok: true, appended: entry };
  },
};

// ── Export all tools ─────────────────────────────────────────────────────────
export const ALL_TOOLS: ToolDef[] = [
  // core
  toolSystemStatus,
  toolListTasks,
  toolRepoHealth,
  toolListCapabilities,
  // knowledge
  toolSearchKnowledge,
  toolGetMetaprompt,
  // ops
  toolListServices,
  toolHealthCheck,
  toolRecordLearning,
];

/**
 * Filtra tools pelo groups e scope do token.
 * - "full" group = acesso a todos os groups
 * - scope "read" = exclui tools que requerem scope "full"
 */
export function filterTools(
  groups: string[],
  scopes: string[]
): ToolDef[] {
  const hasFullGroup = groups.includes("full");
  const hasFullScope = scopes.includes("full");

  return ALL_TOOLS.filter((t) => {
    const groupOk = hasFullGroup || groups.includes(t.group);
    const scopeOk = hasFullScope || t.scope === "read";
    return groupOk && scopeOk;
  });
}

exec
/bin/bash -lc "nl -ba packages/mcp-unified-gateway/src/tools.ts | sed -n '205,245p' && git diff 5bcc06c832a7beee1dfce1cb561ad5b123359b30 -- packages/mcp-unified-gateway/src/tools.ts | sed -n '1,90p'" in /home/enio/egos
 succeeded in 0ms:
   205	      }
   206	    }
   207	    if (source === "governance" || source === "all") {
   208	      searchFile("agents_md", join(REPO_ROOT, "AGENTS.md"));
   209	      searchFile("claude_md", join(REPO_ROOT, "CLAUDE.md"));
   210	    }
   211	
   212	    return Object.keys(results).length > 0 ? results : { message: "Nenhum resultado encontrado" };
   213	  },
   214	};
   215	
   216	const toolGetMetaprompt: ToolDef = {
   217	  name: "egos_get_metaprompt",
   218	  group: "knowledge",
   219	  scope: "read",
   220	  description: "Retorna o conteúdo de um metaprompt pelo nome (ex: 'start', 'end', 'MP-001').",
   221	  inputSchema: z.object({
   222	    name: z.string().describe("Nome do metaprompt (ex: 'start', 'end', 'MP-ITEM-INTAKE-001')"),
   223	  }),
   224	  handler: (input) => {
   225	    const { name } = input as { name: string };
   226	    const candidates = [
   227	      join(REPO_ROOT, ".claude/commands", `${name}.md`),
   228	      join(REPO_ROOT, "docs/metaprompts", `${name}.md`),
   229	      join(REPO_ROOT, "docs/metaprompts", `${name.toUpperCase()}.md`),
   230	    ];
   231	    for (const c of candidates) {
   232	      if (existsSync(c)) return { name, content: readFileSafe(c, 15_000) };
   233	    }
   234	    // Try partial match in metaprompts dir
   235	    const mpDir = join(REPO_ROOT, "docs/metaprompts");
   236	    if (existsSync(mpDir)) {
   237	      const match = readdirSync(mpDir).find((f) =>
   238	        f.toLowerCase().includes(name.toLowerCase())
   239	      );
   240	      if (match) return { name: match, content: readFileSafe(join(mpDir, match), 15_000) };
   241	    }
   242	    return { error: `Metaprompt '${name}' não encontrado` };
   243	  },
   244	};
   245	
diff --git a/packages/mcp-unified-gateway/src/tools.ts b/packages/mcp-unified-gateway/src/tools.ts
index e109ee8b..f0192248 100644
--- a/packages/mcp-unified-gateway/src/tools.ts
+++ b/packages/mcp-unified-gateway/src/tools.ts
@@ -12,10 +12,15 @@
  * Changelog v0.2.0:
  *   GAP-002 — egos_repo_health: tokens group=core retornam só {branch,is_clean,commits_ahead}
  *   GAP-006 — egos_list_tasks: tokens não-full leem docs/governance/STATUS_PUBLIC.md (corpus sanitizado)
+ *
+ * Changelog v0.3.0:
+ *   NEW — egos_notebooklm_query: consulta notebook via nlm CLI (subprocess)
+ *   NEW — egos_banda: roda Banda Cognitiva (mode=economico) com rate-guard 1/min por token
+ *   NEW — egos_capabilities_demo: resumo público de capacidades para visitantes na demo
  */
 
 import { z } from "zod";
-import { execSync } from "node:child_process";
+import { execSync, spawnSync } from "node:child_process";
 import { readFileSync, existsSync, readdirSync, appendFileSync } from "node:fs";
 import { join, dirname } from "node:path";
 import { fileURLToPath } from "node:url";
@@ -238,6 +243,82 @@ const toolGetMetaprompt: ToolDef = {
   },
 };
 
+/**
+ * egos_notebooklm_query — v0.3.0
+ *
+ * Consulta um notebook NotebookLM via `nlm notebook query <id> <question> --json`.
+ * O `nlm` CLI (~/.local/bin/nlm) é o único acesso viável ao NotebookLM a partir do
+ * gateway standalone (MCPs do Claude Code não estão disponíveis aqui).
+ *
+ * Restrição de dado soberano: esta tool NÃO aceita notebook_id cujo conteúdo possa
+ * conter PCMG/PII/intelink. Validação: o chamador é responsável — a tool não filtra IDs
+ * (não tem inventário de notebooks). Lembrete inline no retorno.
+ *
+ * Fronteira §4 EGOS_SURFACES_ROUTING.md: dado soberano → Odysseus LOCAL + modelo local.
+ */
+const toolNotebooklmQuery: ToolDef = {
+  name: "egos_notebooklm_query",
+  group: "knowledge",
+  scope: "read",
+  description:
+    "Consulta um notebook NotebookLM via nlm CLI. Informe notebook_id (ID do notebook no Google) e a pergunta. NUNCA usar com notebooks que contenham dado soberano (PCMG/PII/intelink).",
+  inputSchema: z.object({
+    notebook_id: z.string().min(1).describe("ID do notebook NotebookLM (ex: '1abc2...')"),
+    question: z.string().min(10).max(500).describe("Pergunta a fazer ao notebook"),
+  }),
+  handler: (input) => {
+    const { notebook_id, question } = input as { notebook_id: string; question: string };
+
+    // Verificação de disponibilidade do nlm CLI
+    const nlmPath = execSafe("which nlm 2>/dev/null || echo ''");
+    if (!nlmPath || nlmPath.startsWith("Erro")) {
+      return {
+        status: "requires_notebooklm_bridge",
+        note: "nlm CLI não encontrado no PATH. Instale via: pip install notebooklm-cli ou similar. O gateway precisa de nlm acessível no mesmo PATH do processo.",
+        missing: "nlm CLI (which nlm retornou vazio)",
+      };
+    }
+
+    // spawnSync para capturar stdout/stderr separadamente e evitar shell injection
+    const result = spawnSync(
+      nlmPath,
+      ["notebook", "query", notebook_id, question, "--json"],
+      { encoding: "utf8", timeout: 90_000 }
+    );
+
+    if (result.error) {
+      return { error: `Falha ao chamar nlm: ${result.error.message}` };
+    }
+    if (result.status !== 0) {
+      const stderr = (result.stderr ?? "").slice(0, 400);
+      return {
+        error: "nlm notebook query retornou erro",
+        stderr,
+        note: "Verifique se o notebook_id é válido e se o perfil nlm está autenticado (nlm login).",
+      };
+    }
+
+    // Tenta parsear JSON; fallback para texto bruto
+    const stdout = (result.stdout ?? "").trim();
+    try {
+      const parsed = JSON.parse(stdout) as unknown;
+      return {
+        notebook_id,
+        question,
+        answer: parsed,
+        sovereignty_reminder: "NÃO usar com notebooks contendo dado soberano (PCMG/PII). SSOT: docs/governance/EGOS_SURFACES_ROUTING.md §4.",
+      };

exec
/bin/bash -lc "ls packages/mcp-unified-gateway/src && sed -n '1,260p' packages/mcp-unified-gateway/src/*.ts" in /home/enio/egos
 succeeded in 0ms:
auth.ts
index.ts
setup-tokens.ts
tools.ts
/**
 * @egos/mcp-unified-gateway — auth.ts
 *
 * Middleware de autenticação Bearer por token/tenant para o gateway MCP.
 *
 * Config: ~/.egos/mcp-tokens.json (gitignored)
 * Shape:
 *   {
 *     "<token>": {
 *       "tenant": "enio",
 *       "scopes": ["read" | "full"],
 *       "groups": ["core", "knowledge", "ops", "full"],
 *       "label": "Claude Code local"
 *     }
 *   }
 *
 * Fail-closed: ausência de token válido = 401.
 * Fallback dev: EGOS_MCP_DEV_TOKEN env var (somente quando NODE_ENV !== "production").
 */

import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import type { IncomingMessage } from "node:http";

// ── Feature groups ──────────────────────────────────────────────────────────
export type Scope = "read" | "full";
export type Group = "core" | "knowledge" | "ops" | "full";

export interface TokenEntry {
  tenant: string;
  scopes: Scope[];
  groups: Group[];
  label?: string;
}

export interface AuthResult {
  ok: true;
  tenant: string;
  scopes: Scope[];
  groups: Group[];
  label: string;
}

export interface AuthFailure {
  ok: false;
  reason: string;
}

export type AuthCheck = AuthResult | AuthFailure;

// ── Token registry ──────────────────────────────────────────────────────────
const TOKEN_FILE = join(process.env.HOME ?? "/root", ".egos", "mcp-tokens.json");
const DEV_TOKEN = process.env.EGOS_MCP_DEV_TOKEN;
const IS_PROD = process.env.NODE_ENV === "production";

function loadTokens(): Record<string, TokenEntry> {
  if (existsSync(TOKEN_FILE)) {
    try {
      return JSON.parse(readFileSync(TOKEN_FILE, "utf8")) as Record<string, TokenEntry>;
    } catch {
      console.error(`[mcp-gateway/auth] Falha ao ler ${TOKEN_FILE} — fail-closed`);
      return {};
    }
  }
  return {};
}

// Cache tokens for the process lifetime (reload via SIGHUP handled in index.ts)
let _tokens: Record<string, TokenEntry> = loadTokens();

export function reloadTokens(): void {
  _tokens = loadTokens();
  console.error(`[mcp-gateway/auth] Tokens recarregados: ${Object.keys(_tokens).length} entradas`);
}

// ── Auth check ──────────────────────────────────────────────────────────────
export function checkAuth(req: IncomingMessage): AuthCheck {
  // Extract bearer token from header or ?token= query param
  let rawToken: string | undefined;

  const authHeader = req.headers["authorization"] ?? "";
  if (authHeader.startsWith("Bearer ")) {
    rawToken = authHeader.slice(7).trim();
  }

  if (!rawToken) {
    const url = req.url ?? "";
    const match = url.match(/[?&]token=([^&]+)/);
    if (match) rawToken = decodeURIComponent(match[1]);
  }

  if (!rawToken) {
    return { ok: false, reason: "Token ausente — use ?token=X ou Authorization: Bearer X" };
  }

  // Dev mode fallback (non-production only)
  if (!IS_PROD && DEV_TOKEN && rawToken === DEV_TOKEN) {
    return {
      ok: true,
      tenant: "dev",
      scopes: ["full"],
      groups: ["full"],
      label: "dev-token",
    };
  }

  const entry = _tokens[rawToken];
  if (!entry) {
    return { ok: false, reason: "Token inválido ou expirado" };
  }

  return {
    ok: true,
    tenant: entry.tenant,
    scopes: entry.scopes,
    groups: entry.groups,
    label: entry.label ?? entry.tenant,
  };
}

// ── Group membership ────────────────────────────────────────────────────────
/**
 * Retorna true se o token tem acesso ao grupo solicitado.
 * "full" group = acesso a todos os grupos.
 */
export function hasGroup(auth: AuthResult, group: Group): boolean {
  if (auth.groups.includes("full")) return true;
  return auth.groups.includes(group);
}

/**
 * Retorna true se o token tem o scope solicitado.
 * "full" scope inclui "read".
 */
export function hasScope(auth: AuthResult, scope: Scope): boolean {
  if (auth.scopes.includes("full")) return true;
  return auth.scopes.includes(scope);
}
#!/usr/bin/env bun
/**
 * @egos/mcp-unified-gateway v0.2.0 (MCP-EASY-INSTALL-001)
 *
 * Endpoint único /mcp com auth Bearer por token/tenant e feature groups.
 *
 * Uso (1 linha):
 *   claude mcp add --scope user --transport http egos "https://mcp.egos.ia.br/mcp?token=X"
 *
 * Variáveis de ambiente:
 *   GATEWAY_PORT      — porta HTTP (default: 3100)
 *   GATEWAY_HOST      — host (default: localhost)
 *   NODE_ENV          — "production" ativa verificações extras
 *   EGOS_MCP_DEV_TOKEN — token de dev (somente quando NODE_ENV !== "production")
 *
 * Config de tokens: ~/.egos/mcp-tokens.json (gitignored)
 *
 * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md
 *
 * Changelog v0.2.0:
 *   GAP-001 — GET /.well-known/oauth-protected-resource/mcp (RFC 9728 discovery mínimo)
 *   GAP-003 — Rate limiting: 60 req/min por token (janela deslizante, Map em memória)
 *   GAP-004 — DELETE /mcp com Mcp-Session-Id → encerra sessão explicitamente
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { checkAuth, reloadTokens, type AuthResult } from "./auth.js";
import { filterTools } from "./tools.js";

const PORT = parseInt(process.env.GATEWAY_PORT ?? "3100");
const HOST = process.env.GATEWAY_HOST ?? "localhost";
const IS_PROD = process.env.NODE_ENV === "production";

// ── GAP-003 Rate limiting ────────────────────────────────────────────────────
// 60 req/min por token, janela deslizante em memória. Sem dependência nova.
const RATE_LIMIT_MAX = 60;
const RATE_LIMIT_WINDOW_MS = 60_000;
const _rateMap = new Map<string, number[]>();

function checkRateLimit(tokenKey: string): { ok: true } | { ok: false; retryAfter: number } {
  const now = Date.now();
  const cutoff = now - RATE_LIMIT_WINDOW_MS;
  const timestamps = (_rateMap.get(tokenKey) ?? []).filter((t) => t > cutoff);
  if (timestamps.length >= RATE_LIMIT_MAX) {
    // tempo em segundos até o timestamp mais antigo sair da janela
    const retryAfter = Math.ceil((timestamps[0] + RATE_LIMIT_WINDOW_MS - now) / 1000);
    return { ok: false, retryAfter };
  }
  timestamps.push(now);
  _rateMap.set(tokenKey, timestamps);
  return { ok: true };
}

// ── Session store ────────────────────────────────────────────────────────────
// Uma instância McpServer + transport por sessão autenticada.
// Stateless mode (sessionIdGenerator: undefined) seria mais simples mas perde
// streaming SSE — usamos stateful para compatibilidade máxima com clientes.
interface GatewaySession {
  server: McpServer;
  transport: StreamableHTTPServerTransport;
  auth: AuthResult;
  createdAt: number;
}
const sessions = new Map<string, GatewaySession>();
const SESSION_TTL_MS = 30 * 60 * 1000; // 30min

function buildSession(auth: AuthResult, sessionId: string): GatewaySession {
  const tools = filterTools(auth.groups, auth.scopes);

  const mcpServer = new McpServer({
    name: "egos-gateway",
    version: "0.2.0",
  });

  // Registra tools filtradas pelo token via registerTool (API canônica v1.29+)
  // Cast shape to `any` to prevent TS2589 deep type inference — runtime validation
  // is handled by Zod inside each tool handler.
  for (const tool of tools) {
    const shape: Record<string, z.ZodTypeAny> =
      tool.inputSchema instanceof z.ZodObject
        ? (tool.inputSchema.shape as Record<string, z.ZodTypeAny>)
        : {};

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (mcpServer.registerTool as (...a: any[]) => void)(
      tool.name,
      { description: tool.description, inputSchema: shape },
      async (params: Record<string, unknown>) => {
        try {
          const result = await tool.handler(params, auth.groups, auth.scopes);
          return {
            content: [{ type: "text" as const, text: JSON.stringify(result, null, 2) }],
          };
        } catch (e) {
          return {
            content: [{ type: "text" as const, text: `Erro: ${(e as Error).message}` }],
            isError: true,
          };
        }
      }
    );
  }

  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: () => sessionId,
  });

  void mcpServer.connect(transport);

  const session: GatewaySession = { server: mcpServer, transport, auth, createdAt: Date.now() };
  sessions.set(sessionId, session);
  return session;
}

// ── Cleanup expired sessions ─────────────────────────────────────────────────
setInterval(() => {
  const now = Date.now();
  for (const [id, s] of sessions) {

exec
/bin/bash -lc "sed -n '260,620p' packages/mcp-unified-gateway/src/index.ts" in /home/enio/egos
 succeeded in 0ms:
    }
  }

  if (!session) {
    const sessionId = sessionHeader ?? randomUUID();
    session = buildSession(authResult, sessionId);
    console.error(
      `[mcp-gateway] Nova sessão: ${session.auth.label} (${session.auth.tenant}) ` +
      `groups=${session.auth.groups.join(",")} scopes=${session.auth.scopes.join(",")}`
    );
  }

  // Forward to MCP transport
  try {
    await session.transport.handleRequest(req, res);
  } catch (err) {
    if (!res.headersSent) {
      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: (err as Error).message }));
    }
  }
});

// ── SIGHUP → reload tokens ───────────────────────────────────────────────────
process.on("SIGHUP", () => {
  reloadTokens();
});

// ── Graceful shutdown ────────────────────────────────────────────────────────
process.on("SIGTERM", () => {
  console.error("[mcp-gateway] SIGTERM — encerrando sessões");
  for (const s of sessions.values()) void s.transport.close();
  httpServer.close(() => process.exit(0));
});

// ── Start ────────────────────────────────────────────────────────────────────
httpServer.listen(PORT, HOST, () => {
  console.error(`[mcp-gateway] EGOS Unified Gateway ouvindo em http://${HOST}:${PORT}/mcp`);
  console.error(`[mcp-gateway] Auth: ${IS_PROD ? "produção (tokens obrigatórios)" : "dev (EGOS_MCP_DEV_TOKEN aceito)"}`);
  console.error(`[mcp-gateway] Para adicionar ao Claude Code:`);
  console.error(`[mcp-gateway]   claude mcp add --scope user --transport http egos "http://localhost:${PORT}/mcp?token=<SEU_TOKEN>"`);
});

exec
/bin/bash -lc "sed -n '100,280p' packages/mcp-unified-gateway/src/index.ts" in /home/enio/egos
 succeeded in 0ms:
            content: [{ type: "text" as const, text: `Erro: ${(e as Error).message}` }],
            isError: true,
          };
        }
      }
    );
  }

  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: () => sessionId,
  });

  void mcpServer.connect(transport);

  const session: GatewaySession = { server: mcpServer, transport, auth, createdAt: Date.now() };
  sessions.set(sessionId, session);
  return session;
}

// ── Cleanup expired sessions ─────────────────────────────────────────────────
setInterval(() => {
  const now = Date.now();
  for (const [id, s] of sessions) {
    if (now - s.createdAt > SESSION_TTL_MS) {
      void s.transport.close();
      sessions.delete(id);
    }
  }
}, 5 * 60 * 1000);

// ── CORS helper ──────────────────────────────────────────────────────────────
function setCors(res: ServerResponse, origin: string): void {
  res.setHeader("Access-Control-Allow-Origin", origin || "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type, Mcp-Session-Id");
}

// ── HTTP server ──────────────────────────────────────────────────────────────
const httpServer = createServer(async (req: IncomingMessage, res: ServerResponse) => {
  const origin = (req.headers["origin"] as string) ?? "*";
  setCors(res, origin);

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = req.url ?? "/";

  // ── Health / liveness probe ────────────────────────────────────────────────
  if (url === "/healthz" || url === "/readyz") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({
      ok: true,
      gateway: "egos-unified",
      version: "0.2.0",
      sessions: sessions.size,
      env: IS_PROD ? "production" : "development",
    }));
    return;
  }

  // ── GAP-001: OAuth Protected Resource Discovery (RFC 9728 mínimo) ──────────
  // Clientes MCP modernos (SDK Python ≥1.x, Odysseus) fazem GET neste path
  // quando recebem 401. Retornamos metadata indicando Bearer sem fluxo OAuth,
  // para que o cliente entenda "precisa de token pré-configurado" e não fique
  // em "connecting" indefinidamente tentando descoberta OAuth.
  if (url === "/.well-known/oauth-protected-resource/mcp" || url === "/.well-known/oauth-protected-resource") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({
      resource: `http://${HOST}:${PORT}/mcp`,
      authorization_servers: [],
      bearer_methods_supported: ["header", "query"],
      resource_documentation: `http://${HOST}:${PORT}/mcp`,
      // Indica explicitamente que não há OAuth flow — token deve ser pré-configurado
      egos_auth_note: "Este servidor usa Bearer token pré-configurado. Sem fluxo OAuth. Configure o token em ~/.egos/mcp-tokens.json ou via EGOS_MCP_DEV_TOKEN.",
    }));
    return;
  }

  // ── Redirect root to /mcp (UX) ─────────────────────────────────────────────
  if (url === "/" || url === "") {
    res.writeHead(302, { Location: "/mcp" });
    res.end();
    return;
  }

  // ── Catch-all 404 para paths fora de /mcp ─────────────────────────────────
  if (!url.startsWith("/mcp")) {
    res.writeHead(404, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: "Endpoint não encontrado. Use POST /mcp" }));
    return;
  }

  // ── GAP-004: DELETE /mcp — cleanup explícito de sessão ───────────────────
  if (req.method === "DELETE") {
    const sessionId = req.headers["mcp-session-id"] as string | undefined;
    if (!sessionId) {
      res.writeHead(400, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "Header Mcp-Session-Id obrigatório para DELETE" }));
      return;
    }
    const existing = sessions.get(sessionId);
    if (!existing) {
      res.writeHead(404, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "Sessão não encontrada ou já encerrada" }));
      return;
    }
    void existing.transport.close();
    sessions.delete(sessionId);
    console.error(`[mcp-gateway] Sessão encerrada via DELETE: ${sessionId}`);
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true, session_id: sessionId, message: "Sessão encerrada" }));
    return;
  }

  // Auth gate — fail-closed
  const authResult = checkAuth(req);
  if (!authResult.ok) {
    res.writeHead(401, {
      "Content-Type": "application/json",
      // WWW-Authenticate clarifica ao cliente que Bearer é esperado (sem OAuth redirect)
      "WWW-Authenticate": 'Bearer realm="EGOS MCP Gateway", error="invalid_token"',
    });
    res.end(JSON.stringify({
      error: "Não autorizado",
      reason: authResult.reason,
      hint: "Adicione ?token=X ou header Authorization: Bearer X",
    }));
    return;
  }

  // GAP-003: Rate limiting por token (label como chave para robustez)
  const rateKey = authResult.tenant + ":" + authResult.label;
  const rateCheck = checkRateLimit(rateKey);
  if (!rateCheck.ok) {
    res.writeHead(429, {
      "Content-Type": "application/json",
      "Retry-After": String(rateCheck.retryAfter),
    });
    res.end(JSON.stringify({
      error: "Limite de requisições atingido",
      retry_after_seconds: rateCheck.retryAfter,
      limit: `${RATE_LIMIT_MAX} req/min por token`,
    }));
    return;
  }

  // Session: reuse by Mcp-Session-Id or create new
  const sessionHeader = req.headers["mcp-session-id"] as string | undefined;
  let session: GatewaySession | undefined;

  if (sessionHeader) {
    session = sessions.get(sessionHeader);
    // If session exists but belongs to a different tenant → reject (security)
    if (session && session.auth.tenant !== authResult.tenant) {
      res.writeHead(403, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "Session ID pertence a outro tenant" }));
      return;
    }
  }

  if (!session) {
    const sessionId = sessionHeader ?? randomUUID();
    session = buildSession(authResult, sessionId);
    console.error(
      `[mcp-gateway] Nova sessão: ${session.auth.label} (${session.auth.tenant}) ` +
      `groups=${session.auth.groups.join(",")} scopes=${session.auth.scopes.join(",")}`
    );
  }

  // Forward to MCP transport
  try {
    await session.transport.handleRequest(req, res);
  } catch (err) {
    if (!res.headersSent) {
      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: (err as Error).message }));
    }
  }

exec
/bin/bash -lc "sed -n '1,180p' scripts/coordination-watcher.ts && sed -n '180,470p' scripts/coordination-watcher.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * EGOS Coherence & Coordination Blackboard Watcher [GUARANI-006]
 * 
 * Runs as a background daemon to monitor local git status and diffs.
 * Leverages free-tier LLM models to organize changes and post them
 * to a shared blackboard in /tmp, preventing conflicts between parallel agents.
 */

import { writeFileSync, readFileSync, existsSync, appendFileSync, mkdirSync } from 'node:fs';
import { execSync } from 'node:child_process';
import { resolve } from 'node:path';
import { homedir } from 'node:os';
import { config } from 'dotenv';
import { chatWithLLM } from '../packages/shared/src/llm-provider';

// --- Machine-wide repo scan (MYCELIUM-003) ---

const MYCELIUM_SNAPSHOT = resolve(homedir(), '.egos', 'mycelium-snapshot.json');

interface RepoState {
  path: string;
  branch: string;
  dirty_count: number;
  ahead: number;
  behind: number;
  last_commit: string;
  last_commit_age: string;
  error?: string;
}

/** Load repo paths from the mycelium snapshot (type=repository nodes). */
function loadSnapshotRepos(): Array<{ name: string; path: string }> {
  try {
    if (!existsSync(MYCELIUM_SNAPSHOT)) return [];
    const raw = readFileSync(MYCELIUM_SNAPSHOT, 'utf8');
    const snapshot = JSON.parse(raw) as { nodes?: Array<{ type: string; label: string; sourcePath?: string }> };
    return (snapshot.nodes ?? [])
      .filter(n => n.type === 'repository' && n.sourcePath)
      .map(n => ({ name: n.label, path: n.sourcePath! }));
  } catch (e: any) {
    console.error(`[COORDINATION] loadSnapshotRepos failed: ${e.message}`);
    return [];
  }
}

/**
 * Collect git state for a single repo.
 * Each git call has a 5s timeout; any failure yields partial/error state.
 * Never throws — always returns RepoState.
 */
function collectRepoState(name: string, repoPath: string): RepoState {
  const state: RepoState = {
    path: repoPath,
    branch: '?',
    dirty_count: 0,
    ahead: 0,
    behind: 0,
    last_commit: '?',
    last_commit_age: '?',
  };

  try {
    if (!existsSync(repoPath)) {
      state.error = 'path_not_found';
      console.warn(`[COORDINATION] repo ${name}: path not found (${repoPath}), skipping.`);
      return state;
    }

    // Verify it's actually a git repo
    const gitCheck = sh('git rev-parse --git-dir 2>/dev/null', repoPath);
    if (!gitCheck) {
      state.error = 'not_a_git_repo';
      console.warn(`[COORDINATION] repo ${name}: not a git repo, skipping.`);
      return state;
    }

    state.branch = sh('git rev-parse --abbrev-ref HEAD 2>/dev/null', repoPath) || '?';

    const porcelain = sh('git status --porcelain 2>/dev/null', repoPath);
    state.dirty_count = porcelain ? porcelain.split('\n').filter(Boolean).length : 0;

    const aheadBehind = sh('git rev-list --count --left-right @{u}...HEAD 2>/dev/null', repoPath);
    if (aheadBehind && /^\d+\s+\d+$/.test(aheadBehind)) {
      const parts = aheadBehind.split(/\s+/);
      state.behind = parseInt(parts[0] ?? '0', 10);
      state.ahead = parseInt(parts[1] ?? '0', 10);
    }

    // Format: "<hash> <subject>" — one line
    state.last_commit = sh('git log -1 --format="%h %s" 2>/dev/null', repoPath) || '?';

    // Human-readable age of last commit
    state.last_commit_age = sh('git log -1 --format="%ar" 2>/dev/null', repoPath) || '?';

  } catch (e: any) {
    state.error = e.message?.slice(0, 100) ?? 'unknown';
    console.warn(`[COORDINATION] repo ${name}: collection error: ${state.error}`);
  }

  return state;
}

/**
 * Scan all repos from the snapshot and return a map of name → RepoState.
 * Skips repos with errors silently (logs warning). Never throws.
 */
function scanAllRepos(): Record<string, RepoState> {
  const repos = loadSnapshotRepos();
  const result: Record<string, RepoState> = {};

  for (const { name, path: repoPath } of repos) {
    try {
      const state = collectRepoState(name, repoPath);
      result[name] = state;
    } catch (e: any) {
      console.warn(`[COORDINATION] repo ${name}: unexpected error in scan: ${e.message}`);
    }
  }

  return result;
}

config({ override: true });

const REPO_ROOT = resolve(import.meta.dir, '..');
const VOLATILE_BLACKBOARD_JSON = '/tmp/egos-live-blackboard.json';
const VOLATILE_BLACKBOARD_MD = '/tmp/egos-live-blackboard.md';

const EGOS_DIR = resolve(homedir(), '.egos');
if (!existsSync(EGOS_DIR)) {
  mkdirSync(EGOS_DIR, { recursive: true });
}

const PERSISTENT_BLACKBOARD_JSON = resolve(EGOS_DIR, 'coordination-blackboard.json');
const PERSISTENT_BLACKBOARD_MD = resolve(EGOS_DIR, 'coordination-blackboard.md');
const TELEMETRY_HISTORY_JSONL = resolve(EGOS_DIR, 'coordination-history.jsonl');

let lastStatusString = '';
let lastAnalysisTs = 0;

function sh(cmd: string, cwd: string): string {
  try {
    return execSync(cmd, { cwd, encoding: 'utf8', timeout: 10000 }).trim();
  } catch (e) {
    return '';
  }
}

function logTelemetry(event: {
  timestamp: string;
  status: 'clean' | 'dirty' | 'error';
  head: string;
  branch: string;
  changedFilesCount: number;
  modelUsed: string | null;
  tokensUsed: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  } | null;
  costUsd: number | null;
  latencyMs: number;
  error?: string;
}) {
  try {
    appendFileSync(TELEMETRY_HISTORY_JSONL, JSON.stringify(event) + '\n', 'utf8');
  } catch (err: any) {
    console.error(`[COORDINATION] Failed to write telemetry: ${err.message}`);
  }
}

async function runAnalysis(status: string, diff: string, commits: string) {
  console.log(`[COORDINATION] Changes detected. Invoking AI summary...`);
  const startTime = Date.now();
  
  const systemPrompt = `You are the EGOS Coherence & Coordination Monitor. 
Analyze the current workspace modifications (git status, recent commits, and file diffs).
Your goal is to compile a clean, highly technical blackboard summary to coordinate between parallel AI agents.
Identify:
Identify:
1. Files modified/added/deleted.
2. High-level technical impact of the changes (what was implemented/fixed).
3. Potential conflicts (e.g. changes in package.json, configuration files, or database schemas).
4. Recommended validation commands (e.g. tsc, bun test, etc.) or alignment instructions.

Answer in a concise, bulleted markdown format in Portuguese (PT-BR) as this is used by Enio and the agents locally. 
Be precise and avoid fluff.`;

  const userPrompt = JSON.stringify({
    timestamp: new Date().toISOString(),
    gitStatus: status,
    gitDiff: diff.slice(0, 4000), // Cap at 4k chars to avoid token bloat
    recentCommits: commits,
  }, null, 2);

  try {
    const result = await chatWithLLM({
      tier: 'fast',
      temperature: 0.1,
      maxTokens: 1000,
      systemPrompt,
      userPrompt,
    });
    const latencyMs = Date.now() - startTime;
    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);

    const markdownContent = [
      `# 📋 EGOS Live Coordination Blackboard`,
      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
      `*Commit HEAD: ${headSha}*`,
      `*Ramo (Branch): ${branchName}*`,
      `\n---`,
      result.content,
    ].join('\n');

    const repos = scanAllRepos();
    const jsonContent = {
      timestamp: new Date().toISOString(),
      head: headSha,
      branch: branchName,
      status: 'dirty',
      summary: result.content,
      rawStatus: status,
      repos,
    };

    // Write to volatile
    writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');

    // Write to persistent
    writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
    console.log(`[COORDINATION] Blackboard successfully updated (both /tmp and ~/.egos).`);

    const changedFilesCount = status ? status.split('\n').filter(Boolean).length : 0;
    logTelemetry({
      timestamp: new Date().toISOString(),
      status: 'dirty',
      head: headSha,
      branch: branchName,
      changedFilesCount,
      modelUsed: result.model || 'unknown',
      tokensUsed: result.usage || null,
      costUsd: result.cost_usd ?? null,
      latencyMs,
    });
  } catch (err: any) {
    const latencyMs = Date.now() - startTime;
    const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
    const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
    console.error(`[COORDINATION] Failed to analyze changes: ${err.message}`);

    // WATCHER-STALE-ROOTCAUSE-001: o batimento (timestamp) NÃO pode depender do LLM.
    // Se a análise LLM falha (ex: modelo 404), ainda escrevemos um blackboard degradado
    // com timestamp fresco — senão o watcher parece morto, o pre-commit bloqueia e todos
    // caem no --no-verify (a doença-raiz do INC-2026-06-09). Análise é enriquecimento; o
    // heartbeat é crítico. Fail-safe, não fail-open.
    const repos = scanAllRepos();
    const degradedJson = {
      timestamp: new Date().toISOString(),
      head: headSha,
      branch: branchName,
      status: 'dirty',
      summary: `⚠️ Watcher VIVO; análise LLM indisponível (${err.message?.slice(0, 120)}). Heartbeat mantido.`,
      rawStatus: status,
      analysisDegraded: true,
      repos,
    };
    const degradedMd = [
      `# 📋 EGOS Live Coordination Blackboard`,
      `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
      `*Commit HEAD: ${headSha}*`,
      `*Ramo (Branch): ${branchName}*`,
      `\n---`,
      `🟡 **Watcher VIVO — análise LLM indisponível.** Heartbeat preservado (commits não serão bloqueados por stale).`,
      `\nErro: ${err.message}`,
    ].join('\n');
    try {
      writeFileSync(VOLATILE_BLACKBOARD_MD, degradedMd, 'utf8');
      writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
      writeFileSync(PERSISTENT_BLACKBOARD_MD, degradedMd, 'utf8');
      writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(degradedJson, null, 2) + '\n', 'utf8');
      console.log(`[COORDINATION] Blackboard mantido em modo degradado (heartbeat fresco).`);
    } catch (writeErr: any) {
      console.error(`[COORDINATION] Falha ao escrever heartbeat degradado: ${writeErr.message}`);
    }

    logTelemetry({
      timestamp: new Date().toISOString(),
      status: 'error',
      head: headSha,
      branch: branchName,
      changedFilesCount: status ? status.split('\n').filter(Boolean).length : 0,
      modelUsed: null,
      tokensUsed: null,
      costUsd: null,
      latencyMs,
      error: err.message,
    });
  }
}

/**
 * Estado "dirty" SEM chamada de LLM (COST-CONTROL 2026-06-10). Escreve git status
 * real + heartbeat fresco + lista de arquivos — zero custo. O resumo LLM (luxo) só
 * roda com EGOS_WATCHER_LLM=1. Coordenação entre janelas não depende do resumo.
 */
function writeDirtyStateNoLLM(status: string) {
  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
  const files = status.split('\n').filter(Boolean);
  const md = [
    `# 📋 EGOS Live Coordination Blackboard`,
    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
    `*Commit HEAD: ${headSha}* | *Ramo: ${branchName}*`,
    `\n---`,
    `🟡 **${files.length} arquivo(s) modificado(s)** (resumo LLM desligado — EGOS_WATCHER_LLM=1 p/ ligar).`,
    ...files.slice(0, 40).map((f) => `- \`${f}\``),
  ].join('\n');
  const json = {
    timestamp: new Date().toISOString(),
    head: headSha,
    branch: branchName,
    status: 'dirty',
    summary: `🟡 ${files.length} arquivo(s) modificado(s) (resumo LLM off).`,
    rawStatus: status,
    analysisDegraded: true,
    repos: scanAllRepos(),
  };
  writeFileSync(VOLATILE_BLACKBOARD_MD, md, 'utf8');
  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
  writeFileSync(PERSISTENT_BLACKBOARD_MD, md, 'utf8');
  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
  logTelemetry({
    timestamp: new Date().toISOString(), status: 'dirty', head: headSha, branch: branchName,
    changedFilesCount: files.length, modelUsed: null, tokensUsed: null, costUsd: 0, latencyMs: 0,
  });
}

function writeCleanState() {
  const headSha = sh('git rev-parse --short HEAD', REPO_ROOT);
  const branchName = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
  
  const markdownContent = [
    `# 📋 EGOS Live Coordination Blackboard`,
    `*Última atualização: ${new Date().toLocaleString('pt-BR')}*`,
    `*Commit HEAD: ${headSha}*`,
    `*Ramo (Branch): ${branchName}*`,
    `\n---`,
    `🟢 **Ecosystem is CLEAN.** Nenhum arquivo modificado ou não-rastreado detectado localmente.`,
  ].join('\n');

  const repos = scanAllRepos();
  const jsonContent = {
    timestamp: new Date().toISOString(),
    head: headSha,
    branch: branchName,
    status: 'clean',
    summary: '🟢 Ecosystem is CLEAN. No local changes.',
    rawStatus: '',
    repos,
  };

  // Write to volatile
  writeFileSync(VOLATILE_BLACKBOARD_MD, markdownContent, 'utf8');
  writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');

  // Write to persistent
  writeFileSync(PERSISTENT_BLACKBOARD_MD, markdownContent, 'utf8');
  writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(jsonContent, null, 2) + '\n', 'utf8');
  console.log(`[COORDINATION] Blackboard marked clean (both /tmp and ~/.egos). repos_scanned=${Object.keys(repos).length}`);

  logTelemetry({
    timestamp: new Date().toISOString(),
    status: 'clean',
    head: headSha,
    branch: branchName,
    changedFilesCount: 0,
    modelUsed: null,
    tokensUsed: null,
    costUsd: null,
    latencyMs: 0,
  });
}

/**
 * Heartbeat incondicional (WATCHER-STALE-ROOTCAUSE-001). Refresca apenas o timestamp do
 * blackboard persistente — preservando o último summary — para que um daemon VIVO num
 * workspace quieto nunca apareça stale ao pre-commit. Barato (read+write 1 JSON pequeno).
 */
// Heartbeat scan counter — scan repos every ~5 heartbeats (75s) to avoid thrashing
let _heartbeatCount = 0;

function touchHeartbeat() {
  try {
    let json: Record<string, any> = {};
    if (existsSync(PERSISTENT_BLACKBOARD_JSON)) {
      try { json = JSON.parse(readFileSync(PERSISTENT_BLACKBOARD_JSON, 'utf8')); } catch { json = {}; }
    }
    json.timestamp = new Date().toISOString();
    if (!json.head) json.head = sh('git rev-parse --short HEAD', REPO_ROOT);
    if (!json.branch) json.branch = sh('git rev-parse --abbrev-ref HEAD', REPO_ROOT);
    if (!json.status) json.status = 'clean';
    if (!json.summary) json.summary = '🟢 Heartbeat (sem mudanças).';

    // Refresh repos scan periodically (every 5 heartbeats ≈ 75s), not every tick
    _heartbeatCount++;
    if (_heartbeatCount % 5 === 1 || !json.repos) {
      json.repos = scanAllRepos();
    }

    writeFileSync(PERSISTENT_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
    writeFileSync(VOLATILE_BLACKBOARD_JSON, JSON.stringify(json, null, 2) + '\n', 'utf8');
  } catch (e: any) {
    console.error(`[COORDINATION] touchHeartbeat falhou: ${e.message}`);
  }
}

async function checkWorkspace() {
  const status = sh('git status --porcelain', REPO_ROOT);
  
  if (status === lastStatusString) {
    return; // No change in file status
  }
  
  lastStatusString = status;

  if (!status) {
    console.log(`[COORDINATION] Workspace is clean.`);
    writeCleanState();
    return;
  }

  // COST-CONTROL (Enio 2026-06-10): a análise LLM é ENRIQUECIMENTO opcional, não
  // crítico (o heartbeat/git-state já é escrito sem LLM). Rodava a CADA mudança de
  // arquivo → 194 chamadas/$0.54 num dia intenso. Agora OFF por padrão; ligue com
  // EGOS_WATCHER_LLM=1 (e mesmo ligado, throttle de 10min entre análises).
  const LLM_ENABLED = process.env.EGOS_WATCHER_LLM === '1';
  const THROTTLE_MS = 10 * 60 * 1000;
  if (!LLM_ENABLED || Date.now() - lastAnalysisTs < THROTTLE_MS) {
    // Estado completo SEM resumo LLM (git status real, heartbeat fresco, $0)
    writeDirtyStateNoLLM(status);
    return;
  }
  lastAnalysisTs = Date.now();
  const diff = sh('git diff --no-color', REPO_ROOT);
  const commits = sh('git log -n 5 --oneline', REPO_ROOT);
  await runAnalysis(status, diff, commits);
}

async function main() {
  console.log(`[COORDINATION] Starting background watcher on ${REPO_ROOT}...`);
  
  // Run an immediate check on startup
  await checkWorkspace();
  
  // Listen for SIGINT
  process.on('SIGINT', () => {
    console.log(`\n[COORDINATION] Watcher shutting down.`);
    process.exit(0);
  });

  // Watch loop every 15 seconds
  while (true) {
    try {
      await checkWorkspace();
    } catch (e: any) {
      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);

exec
/bin/bash -lc "sed -n '470,540p' scripts/coordination-watcher.ts" in /home/enio/egos
 succeeded in 0ms:
      console.error(`[COORDINATION] Error in watcher loop: ${e.message}`);
    }
    // WATCHER-STALE-ROOTCAUSE-001: heartbeat incondicional. checkWorkspace() faz early-return
    // quando o status não muda (e writeCleanState/runAnalysis só escrevem em mudança), então um
    // workspace quieto deixaria o timestamp envelhecer >120s → pre-commit bloqueia falsamente.
    // O batimento de vida do daemon precisa ser independente de mudança de arquivos e de LLM.
    touchHeartbeat();
    await new Promise((r) => setTimeout(r, 15000));
  }
}

main();

exec
/bin/bash -lc 'cat packages/mcp-unified-gateway/package.json 2>/dev/null || true; bun --filter @egos/mcp-unified-gateway typecheck 2>/tmp/type.err || (cat /tmp/type.err; true)' in /home/enio/egos
 succeeded in 2206ms:
@egos/mcp-unified-gateway typecheck: Exited with code 0

exec
/bin/bash -lc "sed -n '1,240p' scripts/banda.ts" in /home/enio/egos
 succeeded in 0ms:
#!/usr/bin/env bun
/**
 * OPUS-F4-001 — Banda Cognitiva executor (hierárquico sequencial)
 *
 * Protocolo (opção C aprovada):
 *   Crítico Extremo → Apoiador Máximo → Questionador → Maestro
 * Cada papel vê o output do anterior. Output final = síntese do Maestro.
 *
 * SSOT: docs/opus-mode/BANDA_COGNITIVA.md
 * Related: docs/opus-mode/OPUS_MODE_V1.md §4
 *
 * Usage:
 *   bun scripts/banda.ts --question "Devemos fazer X ou Y?" [--context "..."] [--mode economico|default|council]
 *   bun scripts/banda.ts --dry      # testa sem chamar LLMs
 *   bun scripts/banda.ts --verbose  # mostra os 4 outputs (default: só Maestro)
 *
 * Modes:
 *   default    — Sonnet 4.6 para todos (~$0.20/banda, rápido)
 *   economico  — Haiku 4.5 para todos (~$0.05/banda, muito rápido, qualidade menor)
 *   council    — GPT via Codex CLI + Claude via Claude CLI (subscriptions) +
 *                Gemini 3.1 Pro via OpenRouter (~$0.03/council medido 2026-06-10)
 *
 * Output:
 *   - Console: síntese do Maestro (ou verbose com todos)
 *   - Arquivo: docs/banda/YYYY-MM-DD-<slug>.yaml (trace completo)
 */

export {};

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

// ─── Config ────────────────────────────────────────────────────────────────────

const ARGS = process.argv.slice(2);
const DRY = ARGS.includes('--dry');
const VERBOSE = ARGS.includes('--verbose');
const QUESTION = ARGS.find((_, i) => ARGS[i - 1] === '--question') ?? '';
const CONTEXT_ARG = ARGS.find((_, i) => ARGS[i - 1] === '--context') ?? '';
const MODE = (ARGS.find((_, i) => ARGS[i - 1] === '--mode') ?? 'default') as
  'default' | 'economico' | 'council';

if (!QUESTION && !DRY) {
  console.error('Usage: bun scripts/banda.ts --question "<pergunta>" [--context "..."] [--context-file <path>] [--mode default|economico|council] [--verbose] [--dry]');
  process.exit(1);
}

// ─── METAPROMPT GATE (METAPROMPT-GATE-001, corte Enio 2026-06-10) ─────────────
// A Banda só aceita comando que cumpra requisitos mínimos (MP-R1 contexto +
// MP-R2 objetivo verificável). Fail-closed: recusa apontando onde as regras
// vivem. SSOT: docs/governance/METAPROMPT_STANDARD.md
const CONTEXT_FILE = ARGS.find((_, i) => ARGS[i - 1] === '--context-file') ?? '';
const CONTEXT_FROM_FILE = CONTEXT_FILE && existsSync(CONTEXT_FILE)
  ? readFileSync(CONTEXT_FILE, 'utf-8')
  : '';
const EFFECTIVE_CONTEXT = CONTEXT_FROM_FILE || CONTEXT_ARG;
const MP_GATE_OVERRIDE = process.env.EGOS_MP_GATE_OVERRIDE === '1';

if (!DRY && !MP_GATE_OVERRIDE) {
  const missing: string[] = [];
  if (EFFECTIVE_CONTEXT.trim().length < 200) {
    missing.push('MP-R1 CONTEXTO (--context/--context-file com ≥200 chars: paths, SHAs, estado REAL/CONCEPT/PHANTOM)');
  }
  if (QUESTION.trim().length < 40) {
    missing.push('MP-R2 OBJETIVO (--question com pergunta + critério de aceite, ≥40 chars)');
  }
  if (missing.length > 0) {
    console.error('⛔ METAPROMPT INCOMPLETO — Banda não executada.');
    for (const m of missing) console.error(`   Falta: ${m}`);
    console.error('   Regras: docs/governance/METAPROMPT_STANDARD.md (EGOS kernel)');
    console.error('   Override consciente (logado): EGOS_MP_GATE_OVERRIDE=1');
    process.exit(2);
  }
}
if (MP_GATE_OVERRIDE && !DRY) {
  console.error('🟡 [banda] EGOS_MP_GATE_OVERRIDE=1 — gate de metaprompt pulado (humano assume).');
}

// Load env
function loadEnv(path: string): Record<string, string> {
  if (!existsSync(path)) return {};
  const env: Record<string, string> = {};
  for (const line of readFileSync(path, 'utf-8').split('\n')) {
    const m = line.match(/^(?:export\s+)?([A-Z_]+)=(.*)$/);
    if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, '');
  }
  return env;
}

// process.env vence, EXCETO quando a var existe vazia (shell herda placeholder
// vazio e sombreava o .env — bug pego 2026-06-10 na missão Odysseus)
const PROC_ENV = Object.fromEntries(
  Object.entries(process.env).filter(([, v]) => v !== undefined && v !== ''),
) as Record<string, string>;
const ENV = { ...loadEnv('/home/enio/egos/.env'), ...PROC_ENV } as Record<string, string>;
const OPENROUTER_KEY = ENV.OPENROUTER_API_KEY ?? '';
const ANTHROPIC_KEY = ENV.ANTHROPIC_API_KEY ?? '';

if (!DRY && !OPENROUTER_KEY) {
  console.error('[banda] OPENROUTER_API_KEY missing in .env');
  process.exit(2);
}

// ─── Model mapping per mode ────────────────────────────────────────────────────

interface ModelMap { critic: string; supporter: string; questioner: string; maestro: string }

const MODELS: Record<string, ModelMap> = {
  default: {
    critic:     'anthropic/claude-sonnet-4.6',
    supporter:  'anthropic/claude-sonnet-4.6',
    questioner: 'anthropic/claude-sonnet-4.6',
    maestro:    'anthropic/claude-sonnet-4.6',
  },
  economico: {
    critic:     'anthropic/claude-haiku-4.5',
    supporter:  'anthropic/claude-haiku-4.5',
    questioner: 'anthropic/claude-haiku-4.5',
    maestro:    'anthropic/claude-haiku-4.5',
  },
  council: {
    critic:     'cli:codex:gpt-5.5',                 // Codex subscription (EGOS_CODEX_EFFORT=medium|high|xhigh)
    supporter:  'cli:claude:sonnet',                 // Claude subscription
    questioner: 'google/gemini-3.1-pro-preview',     // OpenRouter (~$0.03/council — testado 2026-06-10)
    maestro:    'cli:claude:opus',                   // Claude subscription
  },
};

// ─── Prompts por papel ─────────────────────────────────────────────────────────

const PROMPTS = {
  critic: (q: string, ctx: string) => `Você é o **Crítico Extremo** de uma Banda Cognitiva EGOS.

Postura: adversarial construtivo. Não está tentando ser legal. Aponte riscos reais.

Perguntas obrigatórias:
- O que pode dar errado nesta decisão?
- Existe risco de segurança ou privacidade?
- Cria dependência frágil? De qual lado?
- Risco de alucinação ou falsa confiança?
- Duplicamos algo que já existe?
- Pode quebrar deploy, dados ou fluxo de trabalho?
- Qual o pior cenário em 30/90/365 dias?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

Responda em YAML válido:
\`\`\`yaml
critico:
  riscos: [<lista priorizada — maior risco primeiro>]
  pior_cenario: <descrição concreta>
  duplicacoes_detectadas: [<se houver>]
  dependencias_frageis: [<lista>]
  recomendacao: ABORTAR | MITIGAR | SEGUIR_COM_RESSALVAS
  ressalvas: [<se aplicável>]
\`\`\`

Seja conciso. Máx 400 palavras no YAML.`,

  supporter: (q: string, ctx: string, criticOutput: string) => `Você é o **Apoiador Máximo** de uma Banda Cognitiva EGOS.

Postura: maximize o potencial. Não ignora a crítica — responde a ela construtivamente.

Perguntas obrigatórias:
- Qual o maior potencial desta ideia?
- Como as falhas apontadas pelo Crítico viram features?
- Como aproveitar o que já existe no EGOS?
- Como vira regra, ferramenta ou fluxo reusável?
- Que efeito de rede isso pode criar?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:
${criticOutput}

Responda em YAML válido:
\`\`\`yaml
apoiador:
  potencial_maximo: <descrição>
  falhas_do_critico_respondidas:
    - falha: <do crítico>
      resposta: <como vira feature>
  reuso_egos: [<o que já existe que se conecta>]
  efeito_rede: <se houver>
  recomendacao: AMPLIFICAR | EXECUTAR | REFINAR_PRIMEIRO
\`\`\`

Máx 400 palavras.`,

  questioner: (q: string, ctx: string, criticOutput: string, supporterOutput: string) => `Você é o **Questionador** de uma Banda Cognitiva EGOS.

Postura: socrático. Não defende nenhum lado — questiona as premissas.

Perguntas obrigatórias:
- Por que fazer assim?
- Existe caminho mais simples que resolve 80%?
- O objetivo está claro ou estamos em fuga?
- Estamos resolvendo causa ou sintoma?
- Respeita ética, autonomia e governança?
- O que está implícito que precisamos explicitar?
- Que pergunta ninguém fez ainda?

QUESTÃO: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:
${criticOutput}

OUTPUT DO APOIADOR:
${supporterOutput}

Responda em YAML válido:
\`\`\`yaml
questionador:
  premissas_implicitas: [<lista>]
  caminho_mais_simples: <se existir>
  causa_vs_sintoma: <análise>
  questoes_nao_feitas: [<lista>]
  alinhamento_egos: OK | TENSAO | CONTRADICAO
  reformulacao_sugerida: <se houver>
\`\`\`

Máx 400 palavras.`,

  maestro: (q: string, ctx: string, c: string, a: string, qs: string) => `Você é o **Maestro** de uma Banda Cognitiva EGOS.

Postura: executivo. Lê os 3 outputs anteriores e destila uma decisão concreta.

Não defende nenhum papel — sintetiza.

QUESTÃO ORIGINAL: ${q}

${ctx ? `CONTEXTO:\n${ctx}\n` : ''}

OUTPUT DO CRÍTICO:

exec
/bin/bash -lc "nl -ba packages/mcp-unified-gateway/src/tools.ts | sed -n '388,455p'" in /home/enio/egos
 succeeded in 0ms:
   388	 *
   389	 * RATE-GUARD: máximo 1 execução de banda por token por minuto.
   390	 * Decisão (ver §PENDENTE abaixo): tokens sem grupo "full" são BLOQUEADOS — custo recai
   391	 * no dono do gateway. Visitante não tem acesso a esta tool.
   392	 *
   393	 * Requisito MP-R1/R2: question ≥ 40 chars, context ≥ 200 chars (gate do próprio banda.ts).
   394	 * Se o gate falhar, o stderr é retornado com instrução de correção.
   395	 */
   396	
   397	// Rate-guard: 1 banda/min por token. Map em memória (reinicia com o processo).
   398	const _bandaRateMap = new Map<string, number>();
   399	const BANDA_COOLDOWN_MS = 60_000;
   400	
   401	const toolBanda: ToolDef = {
   402	  name: "egos_banda",
   403	  group: "ops",
   404	  scope: "read",
   405	  description:
   406	    "Roda a Banda Cognitiva EGOS (análise hierárquica: Crítico → Apoiador → Questionador → Maestro) em mode economico (Haiku). Requer grupo 'full'. Rate-limit: 1 execução/minuto por token. Pergunta mínima: 40 chars. Contexto mínimo: 200 chars (MP-R1/R2).",
   407	  inputSchema: z.object({
   408	    question: z.string().min(40).max(800).describe("Pergunta para a Banda (mínimo 40 chars com critério de aceite)"),
   409	    context: z.string().min(200).max(3000).describe("Contexto operacional da pergunta (mínimo 200 chars: paths, estado REAL/CONCEPT/PHANTOM, SHA se aplicável)"),
   410	  }),
   411	  handler: (input, tokenGroups, _tokenScopes) => {
   412	    // Acesso restrito a tokens com grupo "full" — custo recai no gateway owner
   413	    const isFullAccess = tokenGroups?.includes("full") ?? false;
   414	    if (!isFullAccess) {
   415	      return {
   416	        error: "egos_banda requer grupo 'full'. Tokens de visitante não têm acesso (custo LLM recairia no gateway). Solicite token full ao administrador EGOS.",
   417	        groups_needed: ["full"],
   418	      };
   419	    }
   420	
   421	    const { question, context } = input as { question: string; context: string };
   422	
   423	    // Rate-guard: 1 execução/minuto por token (identificador = join dos grupos, sem expor token bruto)
   424	    const ratKey = (tokenGroups ?? []).sort().join("|");
   425	    const lastCall = _bandaRateMap.get(ratKey) ?? 0;
   426	    const elapsed = Date.now() - lastCall;
   427	    if (elapsed < BANDA_COOLDOWN_MS) {
   428	      const waitSecs = Math.ceil((BANDA_COOLDOWN_MS - elapsed) / 1000);
   429	      return {
   430	        error: `Rate-limit egos_banda: 1 execução/minuto por token. Aguarde ${waitSecs}s.`,
   431	        retry_after_seconds: waitSecs,
   432	      };
   433	    }
   434	    _bandaRateMap.set(ratKey, Date.now());
   435	
   436	    // Verifica banda.ts existe
   437	    const bandaScript = join(REPO_ROOT, "scripts/banda.ts");
   438	    if (!existsSync(bandaScript)) {
   439	      return { error: `banda.ts não encontrado em ${bandaScript}` };
   440	    }
   441	
   442	    // Executa banda em mode economico. MP-gate cumpre-se via flags min-length do inputSchema
   443	    // (question ≥40, context ≥200). O gate do banda.ts reforça no process.
   444	    const result = spawnSync(
   445	      "bun",
   446	      ["run", bandaScript, "--question", question, "--context", context, "--mode", "economico"],
   447	      { encoding: "utf8", timeout: 120_000, cwd: REPO_ROOT }
   448	    );
   449	
   450	    if (result.error) {
   451	      return { error: `Falha ao executar banda.ts: ${result.error.message}` };
   452	    }
   453	
   454	    const stdout = (result.stdout ?? "").trim();
   455	    const stderr = (result.stderr ?? "").trim();

exec
/bin/bash -lc "nl -ba packages/mcp-unified-gateway/src/tools.ts | sed -n '246,292p'" in /home/enio/egos
 succeeded in 0ms:
   246	/**
   247	 * egos_notebooklm_query — v0.3.0
   248	 *
   249	 * Consulta um notebook NotebookLM via `nlm notebook query <id> <question> --json`.
   250	 * O `nlm` CLI (~/.local/bin/nlm) é o único acesso viável ao NotebookLM a partir do
   251	 * gateway standalone (MCPs do Claude Code não estão disponíveis aqui).
   252	 *
   253	 * Restrição de dado soberano: esta tool NÃO aceita notebook_id cujo conteúdo possa
   254	 * conter PCMG/PII/intelink. Validação: o chamador é responsável — a tool não filtra IDs
   255	 * (não tem inventário de notebooks). Lembrete inline no retorno.
   256	 *
   257	 * Fronteira §4 EGOS_SURFACES_ROUTING.md: dado soberano → Odysseus LOCAL + modelo local.
   258	 */
   259	const toolNotebooklmQuery: ToolDef = {
   260	  name: "egos_notebooklm_query",
   261	  group: "knowledge",
   262	  scope: "read",
   263	  description:
   264	    "Consulta um notebook NotebookLM via nlm CLI. Informe notebook_id (ID do notebook no Google) e a pergunta. NUNCA usar com notebooks que contenham dado soberano (PCMG/PII/intelink).",
   265	  inputSchema: z.object({
   266	    notebook_id: z.string().min(1).describe("ID do notebook NotebookLM (ex: '1abc2...')"),
   267	    question: z.string().min(10).max(500).describe("Pergunta a fazer ao notebook"),
   268	  }),
   269	  handler: (input) => {
   270	    const { notebook_id, question } = input as { notebook_id: string; question: string };
   271	
   272	    // Verificação de disponibilidade do nlm CLI
   273	    const nlmPath = execSafe("which nlm 2>/dev/null || echo ''");
   274	    if (!nlmPath || nlmPath.startsWith("Erro")) {
   275	      return {
   276	        status: "requires_notebooklm_bridge",
   277	        note: "nlm CLI não encontrado no PATH. Instale via: pip install notebooklm-cli ou similar. O gateway precisa de nlm acessível no mesmo PATH do processo.",
   278	        missing: "nlm CLI (which nlm retornou vazio)",
   279	      };
   280	    }
   281	
   282	    // spawnSync para capturar stdout/stderr separadamente e evitar shell injection
   283	    const result = spawnSync(
   284	      nlmPath,
   285	      ["notebook", "query", notebook_id, question, "--json"],
   286	      { encoding: "utf8", timeout: 90_000 }
   287	    );
   288	
   289	    if (result.error) {
   290	      return { error: `Falha ao chamar nlm: ${result.error.message}` };
   291	    }
   292	    if (result.status !== 0) {

codex
The new gateway tools add externally reachable subprocess capabilities without enforceable notebook restrictions, and one read-scoped tool performs filesystem writes. These are actionable security/authorization issues introduced by the patch.

Full review comments:

- [P1] Enforce NotebookLM allowlisting before querying — /home/enio/egos/packages/mcp-unified-gateway/src/tools.ts:283-286
  When any token with the `knowledge` group invokes this tool with an internal or sovereign NotebookLM ID, the gateway accepts the arbitrary `notebook_id` and immediately calls `nlm notebook query`, so the stated PCMG/PII/intelink restriction is only a post-response reminder and does not prevent leakage through the public gateway. Add an enforceable allowlist/denylist or restrict this tool to vetted notebook IDs before spawning the CLI.

- [P2] Require full scope for Banda trace writes — /home/enio/egos/packages/mcp-unified-gateway/src/tools.ts:401-404
  For tokens with group `full` but only read scope, this tool is exposed as `scope: "read"` even though `scripts/banda.ts` writes a trace file under `docs/banda/YYYY-MM-DD-*.yaml` on every successful run. That bypasses the gateway's scope contract that only `scope: "full"` tools can mutate state, so either suppress the trace write or mark this tool as full-scope.
The new gateway tools add externally reachable subprocess capabilities without enforceable notebook restrictions, and one read-scoped tool performs filesystem writes. These are actionable security/authorization issues introduced by the patch.

Full review comments:

- [P1] Enforce NotebookLM allowlisting before querying — /home/enio/egos/packages/mcp-unified-gateway/src/tools.ts:283-286
  When any token with the `knowledge` group invokes this tool with an internal or sovereign NotebookLM ID, the gateway accepts the arbitrary `notebook_id` and immediately calls `nlm notebook query`, so the stated PCMG/PII/intelink restriction is only a post-response reminder and does not prevent leakage through the public gateway. Add an enforceable allowlist/denylist or restrict this tool to vetted notebook IDs before spawning the CLI.

- [P2] Require full scope for Banda trace writes — /home/enio/egos/packages/mcp-unified-gateway/src/tools.ts:401-404
  For tokens with group `full` but only read scope, this tool is exposed as `scope: "read"` even though `scripts/banda.ts` writes a trace file under `docs/banda/YYYY-MM-DD-*.yaml` on every successful run. That bypasses the gateway's scope contract that only `scope: "full"` tools can mutate state, so either suppress the trace write or mark this tool as full-scope.
```
