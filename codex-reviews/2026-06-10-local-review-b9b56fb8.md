# Codex Local Review — 2026-06-10T14:01:20Z

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
session id: 019eb1d6-72fd-7101-9804-a6016be85929
--------
user
changes against 'HEAD~3'
2026-06-10T14:01:22.880233Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T14:01:22.883267Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff eb3edd983411d6e230148496c4f4b07426063221 --stat && git diff eb3edd983411d6e230148496c4f4b07426063221' in /home/enio/egos
 succeeded in 0ms:
 .husky/pre-commit                              |  41 ++--
 AGENTS.md                                      |   2 +-
 TASKS.md                                       |   5 +-
 apps/egos-landing/public/timeline/rss          |   2 +-
 apps/egos-landing/public/timeline/rss.xml      |   2 +-
 docs/drafts/conselho1.md                       | 259 +++++++++++++++++++++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json   |   4 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json  |  56 ++++++
 docs/knowledge/HARVEST.md                      |   4 +
 docs/presentations/mf-certificados-piloto.html | 192 ++++++++++++++++--
 packages/guard-brasil/src/lib/public-guard.ts  |   4 +-
 packages/guard-brasil/src/pii-patterns.ts      |  48 ++++-
 12 files changed, 576 insertions(+), 43 deletions(-)
diff --git a/.husky/pre-commit b/.husky/pre-commit
index c68f84a4..d94686b0 100755
--- a/.husky/pre-commit
+++ b/.husky/pre-commit
@@ -370,26 +370,27 @@ fi
 # forgeable — this gate stops accidents/defaults and records intent, it is NOT tamper-proof authz.
 # Real enforcement still rests on process discipline (Guarani never commits) + sole-committer Prime;
 # a server-side pre-receive hook would be required for hard authz (not wired for this solo setup).
-GOV_FROZEN=$(echo "$STAGED" | grep -E '^\.guarani/|^\.husky/|^docs/governance/|^AGENTS\.md$|^CLAUDE\.md$|^agents/runtime/' || true)
-if [ -n "$GOV_FROZEN" ]; then
-  AUTHORIZED=0
-  WHO="unknown"
-  # Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
-  if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
-  # Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
-  if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
-  # Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
-  if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
-  if [ "$AUTHORIZED" -ne 1 ]; then
-    echo "❌ BLOCKED: frozen-zone/governance commit requires a Prime window or explicit human override."
-    if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
-    echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
-    echo "   Offending staged files:"
-    echo "$GOV_FROZEN" | sed 's/^/     - /'
-    echo "   Guarani proposes diffs; Prime/Enio reviews and commits. See GUARANI.md §12.1 + HITL_CATALOG §5.1."
-    echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
-    exit 1
-  fi
+# 3.5b (INC-STAGED-HIJACK 2026-06-10, corte Enio "já faça"): scope WIDENED from
+# GOV_FROZEN to ALL commits. Root cause: shared checkout + shared index — Guarani window
+# committed cbb0006e and swept Prime's staged files into it (same class as d988385b).
+# R10 says "Guarani proposes; Prime commits" but was will-only. This makes it a gate:
+# ANY kernel commit requires a Prime window (CLAUDECODE) or explicit human override.
+AUTHORIZED=0
+WHO="unknown"
+# Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
+if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
+# Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
+if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
+# Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
+if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
+if [ "$AUTHORIZED" -ne 1 ]; then
+  echo "❌ BLOCKED: kernel commits require a Prime window or explicit human override (R10)."
+  if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
+  echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
+  echo "   Root cause INC-STAGED-HIJACK: shared index — a non-Prime commit sweeps the other window's staged files."
+  echo "   Guarani/Antigravity: deixe o trabalho na working tree + FOR_PRIME_*.md; o Prime commita."
+  echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
+  exit 1
 fi
 
 
diff --git a/AGENTS.md b/AGENTS.md
index 054f7a83..9aa5a5e3 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -189,7 +189,7 @@ Full tree in `docs/SYSTEM_MAP.md`. Summary: `.guarani/` (governance), `agents/ru
 **Agents:** `bun agent:list/run/lint` **Governance:** `bun governance:sync|check` **PR:** `bun pr:pack|gate|audit` **Integration:** `bun integration:check` **Type:** `bun typecheck` **Lint:** `bun lint` **Context:** `bun agent:run context_tracker --dry` (mandatory before multi-step tasks)
 
 ## Skill Orchestration · Slash · Block Model
-**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.windsurf/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
+**65+ skills:** Discovery API `/api/skills/discover` · unified registry. Slash workflows: `.agents/workflows/` (start, end, pre, prompt, regras, research, disseminate, mycelium, stitch, diag, busca). Agent roles: `agents/registry/agents.json`. Four Pillars: World Model → Intelligence Layer → Atomic Capabilities → Signal Layer.
 
 ## Central EGOS — Regras de Desenvolvimento (D8 — 2026-05-21)
 **API-FIRST:** Toda feature → API mestre primeiro. UI/MCP/AnythingLLM consomem API. Bearer auth + X-Tenant-ID + rate limit + RBAC + audit em ops sensíveis. **GOV-BOUNDARY:** Governança NUNCA em `central-egos/clients/<slug>/` — herda de `central-egos/docs/governance/`. Pre-commit enforced. **PRODUTO:** `central-egos/` raiz · clientes em `clients/` · template em `template/` · scripts em `scripts/` · docs em `docs/`.
diff --git a/TASKS.md b/TASKS.md
index 2add7610..c8222b5a 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -37,9 +37,10 @@
 - [ ] **RULES-ENCODE-PENDING-001** [P1] `prime` — 8 regras pendentes em `/home/enio/.egos/rules-pending.jsonl` (hook /rules avisou). Rodar `/rules` para encodar no CLAUDE.md/.guarani/ antes que se percam.
 
 **WIP ≤ 2 — só estas duas frentes ativas até fecharem:**
-- [ ] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — Rodar `/recon` + `/readiness` no negócio do Miguel (MF Certificados) → gerar 1 HTML de diagnóstico com 2 cenários (proteção CPF vs dados reais) → enviar + 3 perguntas → **esperar o "funcionou"**. Construir `scripts/readiness.ts` + `report_html_render` puxados por esta necessidade (gap #1 do cinto). Primeiro `cliente_confirmou=true` do portfólio.
+- [/] **FOCUS-MIGUEL-DIAG-001** [P0] `prime` — HTML diagnóstico PRONTO (1045L: 2 cenários CPF, fluxo híbrido 3 modos, replicabilidade multi-tenant, conselho 3-IA verificado em fonte primária, IN ITI 36/37/2026 confirmadas gov.br/iti) + notebook NotebookLM PÚBLICO (HTTP 200 sem login) + draft de mensagem com 3 perguntas. **AGUARDA: Enio revisar e ENVIAR** → resposta às 3 perguntas = `cliente_confirmou=true`. Path: `docs/presentations/mf-certificados-piloto.html`.
+  **Cortes Enio 2026-06-10 (desenho do piloto MF):** (1) piloto nasce com roteamento por tier (nano default + escalação por evidência), documentado em HTML vivo + slides + vídeo NotebookLM incrementais; (2) memória = Supabase (Postgres-as-memory é o padrão validado; smoke LIVE 2026-06-10: egos_chat_history 534 rows HTTP 206); (3) eval-runner com golden cases do fluxo MF = ENTREGÁVEL do piloto (gap de mercado confirmado por pesquisa 2026-06-10: nenhum BSP entrega evidência).
 - [/] **FOCUS-ITEMINTAKE-CLOSE-001** [P0] `prime` — Enio enviou a mensagem ao Diesom (Kyte) 2026-06-09 (outreach feito). AGUARDA resposta do cliente para `cliente_confirmou=true`. Fecha quando Diesom responder ("abriu? subiu no Kyte? o que faltou?").
-- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). ✅ 2026-06-10
+- [ ] **WA-AGENT-ASYNC-ARCH-001** [P1] `prime` `research` — Desenhar o padrão do agente assíncrono (Enio 2026-06-09): agente IA com KB + chamadas MCP que geram info e gravam questões → traduz resultado em resposta, iterando com o cliente → SEMPRE espera o resultado de cada ação → AVISA que pode demorar e pede pra pessoa enviar outra mensagem em segundos/minutos pra confirmar → tudo com hash + provenance. Reaproveitar: tool loop (whatsapp.ts), Evidence Footer, provenance.ts, egos-memory KB. Design antes de implementar (corte Enio). [resíduo ✅ removido 2026-06-10 — design NÃO feito]
 
 **🧩 MCP CUSTOMIZADO = FEATURE PRINCIPAL DO EGOS (corte Enio 2026-06-10):**
 
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index adc532e6..35245a85 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index adc532e6..35245a85 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Tue, 09 Jun 2026 18:41:15 GMT</lastBuildDate>
+    <lastBuildDate>Wed, 10 Jun 2026 11:18:52 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/docs/drafts/conselho1.md b/docs/drafts/conselho1.md
new file mode 100644
index 00000000..f8b3b03e
--- /dev/null
+++ b/docs/drafts/conselho1.md
@@ -0,0 +1,259 @@
+agora veja a resposta do perplexity sobre o html: Hoje, para jun/2026, o desenho mais sólido é manter o WhatsApp como “casca” conversacional e orquestrar o máximo possível no backend, mas ainda assim **usar tela/app seguro para etapas de alto risco regulatório ou de segurança** (identidade ICP‑Brasil, assinatura, onboarding de pagamento), em linha com o que bancos e fintechs fazem no mundo. [leadersleague](https://www.leadersleague.com/en/news/whatsapp-payments-launches-in-brazil-with-nine-partner-banks)
+
+Abaixo organizei em dois blocos:  
+1) Resposta conceitual (WhatsApp vs tela segura, com exemplos reais)  
+2) Sugestão concreta de como reescrever e atualizar trechos do seu HTML.
+
+***
+
+## 1. WhatsApp como canal x tela segura
+
+### O que o WhatsApp aguenta fazer “sem sair da tela”
+
+Hoje o WhatsApp Business API/Cloud API suporta com segurança: [developers.facebook](https://developers.facebook.com/documentation/business-messaging/whatsapp/templates/authentication-templates/authentication-best-practices/)
+
+- Triagem, perguntas e coleta de dados cadastrais básicos (nome, tipo de certificado, e-mail, telefone).  
+- Consulta de status, reenvio de documentos já armazenados, reagendamentos, cancelamentos.  
+- Disparos transacionais (lembretes, confirmações, OTP) com criptografia de ponta a ponta entre usuário e servidores WhatsApp. [gov](https://www.gov.br/anpd/pt-br/assuntos/noticias/a-nova-politica-de-privacidade-do-whatsapp)
+- Pagamentos iniciados no próprio WhatsApp em modelos homologados (ex.: WhatsApp Pay e integrações com Pix), em que o app faz a camada de segurança e tokenização junto ao arranjo de pagamento parceiro. [americasmi](https://americasmi.com/insights/whatsapp-payments-in-brazil-nothing-to-panic-about/)
+
+Boa parte da automação que você descreve (triagem, checagem de pendências, agendamento de videoconferência, acompanhamento do pedido) continua perfeitamente coerente em 2026. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
+
+### Onde a tela segura continua fazendo sentido
+
+Mesmo com a evolução do WhatsApp, três tipos de etapa continuam sendo tipicamente movidas para um ambiente próprio (web/app) pelas empresas mais maduras: [blog.dito.com](https://blog.dito.com.br/lgpd-e-whatsapp/)
+
+- **1. Upload de documentos “juridicamente sensíveis”**  
+  - Documentos que vão para dossiê regulado (ICP‑Brasil, KYC mais pesado, processos jurídicos).  
+  - Motivo: precisa de política de retenção própria, logs de acesso, controles finos de quem pode ver; você não controla a infraestrutura do WhatsApp nem o armazenamento do lado do usuário. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/iti-na-midia/icp-brasil-e-o-cenario-da-lgpd)
+
+- **2. Assinatura digital qualificada ou atos regulados (ICP‑Brasil)**  
+  - A validação de identidade para emissão de certificado digital continua sendo atividade regulada, conduzida por Agente de Registro autorizado e seguindo DOC‑ICP‑05.x, Resolução 170/2020 e normas posteriores. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/publicada-instrucao-normativa-que-regulamenta-a-emissao-de-certificado-digital-por-videoconferencia)
+  - As novas IN ITI nº 36 e 37/2026 reforçam requisitos pesados de biometria, liveness, proteção contra deepfake e trilha de auditoria, inclusive na “AR Eletrônica”. [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
+  - Ou seja, o que você já diz no HTML (“o agente IA não substitui a etapa regulada”) continua 100% correto, e o ambiente dessa videoconferência/assinatura deve atender requisitos técnicos específicos além do canal de chat. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
+
+- **3. Entrada de dados de cartão ou onboarding de Pix/Open Finance fora dos modelos nativos do WhatsApp**  
+  - Quando você usa WhatsApp Pay ou integrações Pix “oficiais”, a autenticação forte e a tokenização são tratadas pelo próprio WhatsApp + arranjo de pagamento (ex.: Visa/Mastercard, bancos parceiros). [leadersleague](https://www.leadersleague.com/en/news/whatsapp-payments-launches-in-brazil-with-nine-partner-banks)
+  - Mas, para fluxos próprios (cartão num gateway, tela de gestão de faturas, autenticação forte por Open Finance), os bancos e fintechs ainda redirecionam para app/site com sessão autenticada e MFA; a conversa no WhatsApp vira só “casca” de notificação/orquestração. [linkedin](https://www.linkedin.com/pulse/whatsapps-unexpected-journey-brazil-pix-marcel-van-oost-mi2bf)
+
+Além disso, há um ponto prático de segurança ofensiva: campanhas de malware via WhatsApp Web mirando clientes bancários brasileiros continuam aparecendo, inclusive com trojans que roubam sessão ou monitoram navegação de internet banking. [sophos](https://www.sophos.com/en-us/blog/whatsapp-worm-targets-brazilian-banking-customers)
+Isso não desabona o uso do WhatsApp como canal, mas **reforça a ideia de limitar ali o que é estritamente necessário** e deixar o resto em uma superfície sob seu controle.
+
+***
+
+## 2. LGPD + WhatsApp em 2026 (ajustes de narrativa)
+
+### O que continua correto no seu texto
+
+- Base legal como “execução de contrato” para tratar CPF e dados necessários à emissão do certificado continua alinhada com LGPD (art. 7). [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/iti-na-midia/icp-brasil-e-o-cenario-da-lgpd)
+- Diferenciar Cenário A (CPF indo ao LLM) e Cenário B (pseudonimização no gateway) é uma forma tecnicamente defensável de discutir risco x esforço. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
+- Deixar a decisão clara para o cliente (e registrar essa decisão) é bom design de governança.
+
+### O que vale atualizar na redação
+
+1) **ANPD já não é mais só um “enforcer fraco”**  
+Desde 2021 a ANPD vem apertando a supervisão de WhatsApp, inclusive com recomendações específicas sobre a política de privacidade do app e orientações sobre direitos dos titulares. [seguranca.tic.ufrj](https://seguranca.tic.ufrj.br/dicas/anpd-divulga-documento-com-informacoes-e-orientacoes-aos-usuarios-a-respeito-da-nova-politica-de-privacidade-do-whatsapp/)
+Em 2024 saiu, por exemplo, o Guia Orientativo sobre atuação do encarregado (DPO), reforçando boas práticas, logs e comunicação estruturada com titulares. [trenchrossi](https://www.trenchrossi.com/alertas-legais/anpd-publica-guia-orientativo-da-atuacao-do-encarregado-de-dados-pessoais/)
+
+Então, ao invés de dizer apenas que “o LGPD existe, mas o enforcement é limitado”, eu sugeriria algo como:
+
+> “A LGPD está em vigor desde 2020, e a ANPD vem aumentando gradualmente a fiscalização, especialmente em grandes plataformas como o WhatsApp. Na prática, empresas que usam WhatsApp em atendimento precisam combinar base legal clara (execução de contrato ou consentimento, conforme o caso) com políticas de privacidade acessíveis, registro do opt‑in e canal para exercício de direitos dos titulares.”
+
+2) **Usar a linha de ‘WhatsApp como operador/plataforma de terceiro’**  
+Há vários materiais jurídicos lembrando que, embora o WhatsApp seja um terceiro, isso não tira a responsabilidade do controlador (sua empresa) quanto ao tratamento feito ali, inclusive no canal de atendimento. [zapper](https://zapper.to/en/blog/seu-whatsapp-corporativo-atende-a-lgpd)
+No seu HTML, você pode deixar explícito:
+
+> “Usar o WhatsApp não elimina a responsabilidade da MF como controladora de dados. O canal precisa estar integrado à Política de Privacidade da empresa (link na primeira mensagem) e registrar o consentimento quando a base legal for consentimento — por exemplo, uso posterior dos dados para marketing.”
+
+3) **Novidades específicas de WhatsApp em 2026 que impactam a arquitetura**
+
+Em 2026, o WhatsApp começa a introduzir **usernames** e o conceito de **Business Scoped User ID (BSUID)** — um identificador opaco por negócio, que pode substituir o telefone como chave primária. [ezcontact](https://ezcontact.ai/en/blog/whatsapp-api-updates-2026/)
+
+Isso impacta seu backend e o texto pode sugerir boas práticas:
+
+> “O sistema armazena, além do telefone, o BSUID fornecido pelo WhatsApp para cada contato. Isso evita depender só do número de telefone, melhora a privacidade do usuário e acompanha a evolução da plataforma.”
+
+***
+
+## 3. ICP‑Brasil em 2026: reforçando sua “honestidade regulatória”
+
+Seu trecho de “Honestidade regulatória — ICP‑Brasil” está conceitualmente alinhado com o cenário atual, mas dá para deixá‑lo mais robusto citando explicitamente que: [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/publicada-instrucao-normativa-que-regulamenta-a-emissao-de-certificado-digital-por-videoconferencia)
+
+- A emissão por videoconferência virou prática consolidada desde Resolução CG ICP‑Brasil nº 170/2020 e IN ITI nº 05/2021. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/comite-gestor-icp-brasil-regulamenta-emissao-de-certificados-digitais-a-distancia-por-videoconferencia)
+- Em 2026, as IN ITI nº 36 e 37/2026 reforçam a exigência de:
+  - biometria com liveness e detecção de deepfake,  
+  - criptografia ponta‑a‑ponta da videoconferência,  
+  - AR Eletrônica com requisitos próprios e trilha de auditoria reforçada. [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
+
+Sugestão de reescrita (para substituir aquele parágrafo):
+
+> **Honestidade regulatória — ICP‑Brasil (jun/2026)**  
+> A validação de identidade para emissão de certificados ICP‑Brasil continua sendo uma etapa regulada, conduzida por uma Autoridade de Registro (AR) e por um Agente de Registro humano, seja presencialmente, seja por videoconferência, conforme Resolução 170/2020, IN ITI nº 05/2021 e as novas IN ITI nº 36 e 37/2026. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/publicada-instrucao-normativa-que-regulamenta-a-emissao-de-certificado-digital-por-videoconferencia)
+> O agente de IA prepara tudo antes dessa etapa (triagem, documentos, agendamento), mas não substitui a videoconferência nem a emissão sob responsabilidade da AR. Isso protege a MF: automatizamos o máximo do que é automatizável, e mantemos a etapa regulada exatamente dentro do que a norma exige.
+
+***
+
+## 4. WhatsApp x tela segura: como escrever isso melhor no HTML
+
+### Nova versão da seção “🔀 O fluxo: WhatsApp como porta, tela segura quando precisar”
+
+Hoje você já diz que o padrão é “WhatsApp inicia/acompanhando e tela segura para upload/assinatura”. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
+Eu sugeriria explicitar as opções arquiteturais e indicar qual é a recomendada, algo assim:
+
+> ## 🔀 O fluxo: WhatsApp como porta, tela segura para o que é sensível  
+>  
+> O WhatsApp é o **canal de conversa**: ele recebe texto, áudio, fotos e documentos, e o agente de IA orquestra as ações no backend (consultar status, listar documentos, agendar videoconferência, gerar link de pagamento). A pessoa só conversa — não precisa entender a engrenagem.  
+>  
+> Para cada etapa, existem três modos de operação possíveis:  
+>  
+> 1. **Tudo no WhatsApp (baixo risco)** – Triagem, esclarecimento de dúvidas, escolha do tipo de certificado, reenvio de documentos já armazenados e consultas simples são feitas inteiras dentro da conversa.  
+> 2. **Modelo híbrido (recomendado)** – O WhatsApp conduz a jornada, mas etapas sensíveis (upload de documentos que compõem o dossiê regulado, pagamento com cartão, assinatura digital qualificada) acontecem em uma **tela segura da MF**, com sessão autenticada, logs próprios e controles de acesso. Após concluir, o cliente volta automaticamente para a conversa. É o mesmo padrão que bancos e fintechs usam: WhatsApp inicia, acompanha e fecha; o app/site faz o que exige mais segurança. [wsla](https://wsla.io/blog/whatsapp-security-guide.html)
+> 3. **App ou portal primeiro (alta maturidade)** – Para clientes que já usam um portal da MF, o WhatsApp pode funcionar só como “segunda tela”: notifica, responde dúvidas e envia links de ação para o ambiente principal.  
+>  
+> Para o piloto com a MF, propomos o **modo híbrido**: o máximo possível automatizado dentro do próprio WhatsApp, mas com tela segura para tudo que é regulado ou de alto impacto em LGPD (ICP‑Brasil, pagamento, assinatura).
+
+Se quiser, você pode ainda incluir 2–3 bullets de exemplos reais:
+
+> - Bancos brasileiros utilizam WhatsApp para triagem, notificações e envio de links de acompanhamento, mas concentram assinatura de contratos, cadastro e onboarding forte no app ou internet banking. [wsla](https://wsla.io/blog/whatsapp-security-guide.html)
+> - O arranjo de pagamentos no WhatsApp no Brasil (WhatsApp Pay, Pix integrado) funciona com segurança própria e parceiros regulados, sem o banco “improvisar” captura de cartão via chat. [americasmi](https://americasmi.com/insights/whatsapp-payments-in-brazil-nothing-to-panic-about/)
+> - Campanhas recentes de malware focadas em usuários de WhatsApp Web mostram a importância de não transformar o chat no único lugar onde o cliente faz tudo, e sim em uma camada de experiência por cima de sistemas mais controlados. [sophos](https://www.sophos.com/en-us/blog/whatsapp-worm-targets-brazilian-banking-customers)
+
+***
+
+## 5. Seções LGPD/dados pessoais: ajustes finos
+
+Na sua seção “CPF e dados pessoais: dois caminhos”, eu manteria a estrutura A/B, mas ajustaria algumas frases e encaixaria as novidades:
+
+- Em “Contexto real (jun/2026)”, reescrever para algo tipo:
+
+> “Na prática de 2026, grandes empresas brasileiras já usam modelos de IA em atendimento com dados pessoais reais, inclusive em canais como WhatsApp. A ANPD vem aumentando o nível de fiscalização, especialmente em plataformas de grande porte, e orienta sobre adequação de políticas de privacidade e transparência com o titular.  A decisão importante aqui não é ‘usar ou não IA’, e sim **como** o CPF e outros dados circulam: diretamente no modelo (Cenário A) ou via pseudonimização (Cenário B).” [seguranca.tic.ufrj](https://seguranca.tic.ufrj.br/dicas/anpd-divulga-documento-com-informacoes-e-orientacoes-aos-usuarios-a-respeito-da-nova-politica-de-privacidade-do-whatsapp/)
+
+- Em “Quando faz sentido” e “Riscos” dos dois cenários, eu incluiria explicitamente:
+  - referência a **transferência internacional de dados** (por ser provável com provedores de LLM estrangeiros); [tavernard.adv](https://tavernard.adv.br/artigos/direito-empresarial/reforma-das-politicas-de-privacidade-do-whatsapp-anpd-divulga-orientacoes-a-respeito/)
+  - menção a **BSUID**/identificadores opacos para canal WhatsApp. [ezcontact](https://ezcontact.ai/en/blog/whatsapp-api-updates-2026/)
+
+***
+
+## 6. Contexto de mercado ICP‑Brasil: pequenos ajustes
+
+Sua seção de “Contexto do setor” já fala de crescimento, participação PF/PJ e mudança regulatória do e‑CNPJ para selo eletrônico. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
+Com as IN 36 e 37/2026, você pode reforçar que:
+
+- O movimento de migração para selo eletrônico vem acompanhado de **reforço de requisitos de identidade digital e biometria**, o que torna ainda mais relevante a automação da “parte não regulada” do fluxo (triagem, documentos, agenda) para liberar a equipe de AR. [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
+
+Um parágrafo possível:
+
+> “Com as novas IN ITI nº 36 e 37/2026, a ICP‑Brasil sobe a barra técnica de identidade digital (biometria com liveness, deteção de deepfake, AR Eletrônica) ao mesmo tempo em que caminha para substituir parte dos certificados PJ tradicionais por selo eletrônico.  Para uma AR como a MF, isso significa mais responsabilidade na etapa regulada e, na prática, mais ganho em automatizar tudo que vem antes dela.” [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
+
+***
+
+## 7. Resumindo o que eu mudaria no HTML
+
+Em termos práticos, se você for editar o arquivo:
+
+- Atualizar a seção **“🔀 O fluxo: WhatsApp como porta…”** com o texto do modelo híbrido acima, deixando claro que essa é a arquitetura recomendada hoje.  
+- Refinar a seção **“🔒 CPF e dados pessoais: dois caminhos”** para:
+  - tirar a ideia de “enforcement limitado”;  
+  - introduzir ANPD, transferência internacional e BSUID;  
+  - manter a decisão A/B, mas com linguagem mais madura de risco. [gov](https://www.gov.br/anpd/pt-br/assuntos/noticias/a-nova-politica-de-privacidade-do-whatsapp)
+- Reforçar a seção de **honestidade regulatória/ICP‑Brasil** com referências explícitas a Resolução 170/2020, IN 05/2021 e IN 36/37/2026, deixando claro que o IA não entra na etapa de AR / videoconferência. [redgealc](https://www.redgealc.org/site/assets/files/15034/1_5033246481688036133.pdf)
+- Ajustar o **contexto do setor** com uma frase ligando selo eletrônico + novas normas de identidade digital ao benefício de automatizar o pré‑atendimento. [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
+
+Se você quiser, no próximo passo posso te devolver blocos HTML prontos (já com tags `<section>`, `<h2>`, `<p>`, etc.) para colar diretamente no arquivo em cada seção.
+
+e gemini: Essa é uma excelente reflexão arquitetural. O documento atual está muito bem estruturado como diagnóstico, mas a seção sobre o "link para tela segura" realmente precisa ser atualizada para refletir o estado da arte do WhatsApp Business API em meados de 2026.
+
+A resposta direta é: **Não, na maioria das etapas, o cliente não precisa mais sair do WhatsApp.** Forçar o usuário para um navegador webview externo (tela segura) gera atrito e queda na taxa de conversão.
+
+Aqui está a validação técnica de como o fluxo deve funcionar hoje, exemplos reais, e o código HTML atualizado para você inserir no seu documento.
+
+---
+
+### 1. O Fluxo de Atendimento Nativo no WhatsApp (2026)
+
+Com a maturidade da API Oficial do WhatsApp e ferramentas como o **WhatsApp Flows**, a jornada pode ocorrer quase 100% no *backend*, mantendo o cliente no ambiente familiar do chat.
+
+* **Coleta de Dados Estruturados:** Em vez de mandar um link para um formulário seguro, o EGOS pode renderizar um *WhatsApp Flow* (um formulário nativo que abre sobrepondo o chat, sem sair do app). O usuário digita os dados, e o payload JSON vai direto para o seu gateway de forma criptografada de ponta a ponta.
+* **Envio de Documentos (CNH, RG, Contrato Social):** O cliente tira a foto e envia direto no chat. O webhook do WhatsApp entrega a mídia ao backend do EGOS. O seu sistema baixa o arquivo, aplica OCR (visão computacional para extrair os dados), verifica a integridade e apaga a mídia do servidor temporário, enviando os dados validados para o sistema de gestão.
+* **Liveness Check (Prova de Vida):** Grandes bancos já pedem a "selfie segurando o documento" ou um vídeo curto pelo próprio WhatsApp. O backend recebe a mídia e cruza com a foto do documento usando APIs de biometria facial.
+
+**Onde a saída do WhatsApp ainda é obrigatória?**
+Avaliando rigorosamente as normas da **ICP-Brasil** para emissão de certificados digitais, a única etapa que **exige** um ambiente externo é a **Videoconferência com o Agente de Registro (AGR)**. Como a norma exige a gravação audiovisual em tempo real e a guarda dessa evidência com requisitos técnicos específicos, uma chamada de vídeo nativa do WhatsApp não atende aos requisitos de auditoria.
+
+**Exemplos no Mundo Real (2026):**
+
+* **Bancos Digitais (Nubank, Inter) e Gov.br:** Realizam recuperação de senha, renegociação de dívidas e prova de vida recebendo PDFs e selfies diretamente no canal do WhatsApp. O mascaramento de dados (como o Cenário B que você propôs no HTML) ocorre no middleware, exatamente como arquitetado no EGOS.
+* **Seguradoras:** Sinistros automotivos são abertos enviando fotos da colisão e da CNH no próprio chat. A IA avalia a foto no backend e devolve o orçamento sem que o usuário acesse nenhum site.
+
+---
+
+### 2. Atualização do HTML (Refatorando a Seção)
+
+Para refletir essa arquitetura moderna e dar mais autoridade à proposta da MF Certificados, proponho substituir todo o bloco do `id="canal-e-tela"` por este abaixo. Ele elimina a ideia de "tela segura para tudo" e foca na inteligência do backend:
+
+```html
+<div class="card card-purple" id="canal-e-tela">
+  <div class="card-header">
+    <h2>🔀 O fluxo: 100% Nativo no WhatsApp (Fricção Zero)</h2>
+  </div>
+  <div class="card-body">
+    <p style="font-size:14px; color:var(--muted); margin-bottom:16px">Em 2026, forçar o cliente a clicar em links para "telas seguras" gera abandono. A arquitetura do EGOS utiliza o WhatsApp como um <strong>super-app</strong>. A inteligência, a segurança e o processamento de documentos ocorrem de forma invisível no nosso backend.</p>
+
+    <div style="margin-bottom:20px">
+      <div style="font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:8px">Como lidamos com envios sensíveis</div>
+      <p style="font-size:14px; color:var(--muted); margin-bottom:12px">
+        <strong>Documentos e Fotos:</strong> O cliente envia a foto da CNH ou o Contrato Social em PDF diretamente no chat. Nosso gateway captura a mídia com criptografia de ponta a ponta, extrai os dados via OCR, valida as pendências e descarta o arquivo temporário. Tudo sem o cliente sair do aplicativo.<br><br>
+        <strong>Formulários Complexos:</strong> Se precisarmos de dados estruturados, utilizamos <em>WhatsApp Flows</em> — formulários nativos que abrem dentro do próprio chat de forma segura.
+      </p>
+    </div>
+
+    <div style="font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:8px">Visão do fluxo otimizado</div>
+    <div class="flow" style="margin-bottom:20px">
+      <div class="flow-node fn-blue">WhatsApp<br><span style="font-size:11px; font-weight:400">Conversa, OCR de Docs e Dados</span></div>
+      <span class="flow-arrow">→</span>
+      <div class="flow-node fn-orange">Backend EGOS<br><span style="font-size:11px; font-weight:400">Validação e Mascaramento</span></div>
+      <span class="flow-arrow">→</span>
+      <div class="flow-node fn-green">WhatsApp<br><span style="font-size:11px; font-weight:400">Confirmação e Agendamento</span></div>
+    </div>
+
+    <div class="callout callout-orange">
+      <span class="callout-icon">⚖️</span>
+      <div class="callout-body">
+        <strong>A única exceção: A Videoconferência (ICP-Brasil)</strong><br>
+        Automatizamos toda a triagem, coleta e validação. Porém, a <strong>videoconferência final para emissão</strong> com o Agente de Registro ainda exige um link externo (Zoom, Teams, etc.) por exigência regulatória da ICP-Brasil, que demanda auditoria e gravação rigorosa do vídeo. O agente prepara o terreno perfeitamente até este clique final.
+      </div>
+    </div>
+  </div>
+</div>
+
+```
+
+### 3. Validações Adicionais do Documento
+
+* **Pseudonimização (Cenário B no card Laranja):** A sua proposta de converter o CPF em um token (`PSE-A3F2`) antes de enviar ao LLM é o design ideal de segurança e resolve objeções de gestores receosos com a LGPD. Mantenha isso intacto; é um forte diferencial competitivo.
+* **Métricas de Sucesso:** A meta de *≤ 30 segundos* para tempo de resposta está excelente para um agente orquestrador que precisa consultar APIs externas antes de responder.
+* **Contexto de Mercado (Selo e-CNPJ):** A menção à transição regulatória do ICP-Brasil e do Selo Eletrônico posiciona a solução não apenas como um chatbot de atendimento, mas como uma infraestrutura de sobrevivência para o aumento de demanda que as ARs vão enfrentar.
+
+Gostaria de explorar como integrar o webhook de recebimento de mídia do WhatsApp no fluxo de orquestração dos agentes do EGOS para garantir essa extração de dados sem falhas?
+
+e chatgpt: Enio, revisei o HTML original e gerei uma versão nova, mais forte tecnicamente e mais defensável para apresentar:
+[Baixar HTML revisado — MF Certificados × EGOS v2 jun/2026](sandbox:/mnt/data/mf_certificados_egos_whatsapp_piloto_v2_jun2026.html)
+
+Usei o arquivo que você mandou como base  e fiz a principal correção estratégica: **não vender “sair do WhatsApp” como regra**. O melhor desenho para junho de 2026 é **WhatsApp-first**: conversa, triagem, status, agendamento, lembretes e formulários simples ficam no WhatsApp; o backend executa as ações; e a tela segura só entra quando houver upload documental, biometria, termo, pagamento, autenticação forte ou exigência do fluxo regulado.
+
+O ponto mais importante que atualizei: **WhatsApp Flows permite jornadas estruturadas dentro do próprio WhatsApp**, inclusive com endpoint conectado para consultar disponibilidade em tempo real em agendamentos. Isso valida a sua hipótese de que a pessoa pode fazer muita coisa sem sair da conversa. ([WhatsApp for Business][1])
+
+Também incluí exemplos reais: a Farmacias del Ahorro usou WhatsApp Flows para solicitação de consulta médica e reportou aumento de consultas; a Vitaldent integrou WhatsApp Business Platform com ERP/CRM para lembretes, confirmação e reagendamento. Esses exemplos ajudam a explicar para o Miguel que o padrão de mercado é “chat + backend”, não “chat que manda a pessoa para fora o tempo todo”. ([WhatsApp for Business][2])
+
+Na parte regulatória, corrigi a linguagem sobre ICP-Brasil: a IA pode preparar, orientar, agendar e reduzir retrabalho, mas não deve prometer emissão nem substituir a validação regulada. A IN ITI nº 36/2026 detalha requisitos de confirmação de identidade, incluindo documentação, biometria, consulta a bases e termo de titularidade; e a videoconferência continua sendo procedimento regulado quando aplicável. 
+
+Também endureci a parte de LGPD: tirei a ideia de que “CPF no LLM é o padrão barato”. A versão nova recomenda **tokenização/minimização como padrão**. OpenAI, Anthropic e Google Cloud publicam compromissos comerciais de não usar dados de API/serviços empresariais para treino por padrão, mas isso não elimina a obrigação de minimização, logs, DPA, transferência internacional e base legal. ([OpenAI][3])
+
+Também coloquei uma matriz de validação separando: **validado**, **corrigido**, **parcial** e **precisa de prova interna**. Isso é importante porque alguns pontos do HTML original dependem de evidência operacional do EGOS, como G Peças em produção, WhatsApp em validação, multi-tenant real e não armazenamento de CPF. Esses pontos podem continuar no material, mas eu marcaria como “REAL” só com print, log, demo, commit, painel ou evidência auditável.
+
+[1]: https://business.whatsapp.com/blog/whatsapp-flows-101 "WhatsApp Flows 101: An Introduction | WhatsApp for Business"
+[2]: https://business.whatsapp.com/resources/success-stories/farmacias-del-ahorro "Farmacias del Ahorro | WhatsApp for Business"
+[3]: https://openai.com/policies/how-your-data-is-used-to-improve-model-performance/ "How your data is used to improve model performance | OpenAI"
+
+
+ 
\ No newline at end of file
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..b39c5e51 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T12:06:39.878Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1379",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 4fed15d9..1d874cc3 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -238,5 +238,61 @@
     "duration_ms": null,
     "event": "commit:fix files=6 sha=749d8d59",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:56:17.090Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=807ad918",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:07:01.640Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=cbb0006e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:13:39.265Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=4a44ae1b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:19:55.220Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=eb3edd98",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:34:56.370Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=b5b6cf57",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:01:11.829Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b9b56fb8",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 5b2c4f56..297c304d 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -6081,3 +6081,7 @@ Nunca competir por commits. O Guarani propõe patches e rascunha as análises de
 ### Auto-harvested — 9af71508 (2026-06-09)
 
 - model-ID hardcoded em 20+ arquivos = sem fonte única; candidato a MODEL_CONFIG central (liga Patch 3 papel→modelo).
+
+### INC-STAGED-HIJACK (2026-06-10)
+
+Checkout + index compartilhados entre janelas: o commit cbb0006e (Guarani) varreu 91 inserts staged do Prime (mesma classe d988385b). R10 "Guarani propõe, Prime commita" era vontade — virou gate: pre-commit §3.5b bloqueia QUALQUER commit no kernel sem CLAUDECODE (Prime) ou EGOS_FROZEN_OVERRIDE=1 (humano). Smoke: janela guarani → BLOCKED. Higiene complementar do Prime: nunca deixar arquivos staged aguardando enquanto background roda — stage só na hora do commit.
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index 7177c132..40de3255 100644
--- a/docs/presentations/mf-certificados-piloto.html
+++ b/docs/presentations/mf-certificados-piloto.html
@@ -236,7 +236,7 @@ tr:hover td { background: var(--bg); }
 
 <div class="top-header">
   <h1>MF Certificados × EGOS</h1>
-  <span class="meta">Diagnóstico — Agente WhatsApp · Atualizado 2026-06-09</span>
+  <span class="meta">Diagnóstico — Agente WhatsApp · Atualizado 2026-06-10</span>
   <div class="header-btns">
     <button onclick="document.body.classList.toggle('dark')">Modo Escuro</button>
     <span class="badge badge-green">DIAGNÓSTICO</span>
@@ -256,6 +256,7 @@ tr:hover td { background: var(--bg); }
   <a class="sidebar-link" href="#fluxo">Fluxo do cliente</a>
   <a class="sidebar-link" href="#canal-e-tela">Canal e tela segura</a>
   <a class="sidebar-link" href="#multitenant">Replicável por construção</a>
+  <a class="sidebar-link" href="#memoria-e-modelo">Como o agente lembra e decide</a>
   <a class="sidebar-link" href="#privacidade">Segurança do CPF</a>
   <a class="sidebar-link" href="#compliance">Compliance LGPD</a>
 
@@ -269,6 +270,7 @@ tr:hover td { background: var(--bg); }
   <a class="sidebar-link" href="#o-que-nao">O que NÃO inclui</a>
   <a class="sidebar-link" href="#proximos">Próximos passos</a>
   <a class="sidebar-link" href="#materiais">🎧 Materiais (áudio)</a>
+  <a class="sidebar-link" href="#fontes">Fontes</a>
 </nav>
 
 <!-- MAIN -->
@@ -412,11 +414,11 @@ tr:hover td { background: var(--bg); }
       <div class="flow">
         <div class="flow-node fn-purple">Agente verifica disponibilidade</div>
         <span class="flow-arrow">→</span>
-        <div class="flow-node fn-green">Apresenta horários</div>
+        <div class="flow-node fn-green">Apresenta horários (WhatsApp Flow ou lista interativa)</div>
         <span class="flow-arrow">→</span>
         <div class="flow-node fn-blue">Confirma por WhatsApp</div>
       </div>
-      <p style="font-size:13px; color:var(--muted); padding:0 4px">Automatizado. A equipe da MF Certificados recebe a confirmação no sistema interno — nenhuma digitação manual.</p>
+      <p style="font-size:13px; color:var(--muted); padding:0 4px">Automatizado. Quando usando WhatsApp Business Platform, é possível usar <strong>WhatsApp Flows</strong> — formulários nativos dentro do próprio WhatsApp, sem redirecionar o cliente para fora. A equipe da MF Certificados recebe a confirmação no sistema interno.</p>
     </div>
 
     <div>
@@ -459,7 +461,31 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">⚖️</span>
       <div class="callout-body">
         <strong>Honestidade regulatória — ICP-Brasil</strong>
-        Na certificação digital, a <strong>validação de identidade para emissão é etapa regulada</strong> (ICP-Brasil — videoconferência ou presencial, conduzida por agente de registro humano). O agente IA prepara tudo: coleta documentos, confere pendências, agenda, conduz o cliente até essa etapa — mas <strong>não a substitui</strong>. Isso protege a MF: automatizamos o máximo do que é automatizável, e a etapa regulada continua exatamente como a regulação exige.
+        Na certificação digital, a <strong>validação de identidade para emissão é etapa regulada</strong> (ICP-Brasil — videoconferência ou presencial, conduzida por agente de registro humano), conforme a <strong>Resolução CG ICP-Brasil nº 170/2020</strong> e a <strong>IN ITI nº 05/2021</strong>, que consolidaram a emissão por videoconferência. As <strong>IN ITI nº 36 e 37/2026</strong> (publicadas em 04/05/2026) reforçam os requisitos de confirmação de identidade, biometria, proteção contra deepfake e trilha de auditoria. O agente IA prepara tudo: coleta documentos, confere pendências, agenda, conduz o cliente até essa etapa — mas <strong>não a substitui</strong>. Isso protege a MF: automatizamos o máximo do que é automatizável, e a etapa regulada continua exatamente como a norma exige.
+      </div>
+    </div>
+
+    <div class="callout callout-blue" style="margin-top:12px">
+      <span class="callout-icon">📡</span>
+      <div class="callout-body">
+        <strong>Canal oficial vs conector não oficial</strong>
+        Para um primeiro teste técnico, um conector como Evolution API pode acelerar a prova de conceito. Para um cliente de certificação digital — com CPF, documentos e reputação envolvidos — a recomendação é migrar para <strong>WhatsApp Business Platform / Cloud API</strong> (canal oficial Meta) assim que o piloto sair do laboratório. O canal oficial oferece templates, Flows nativos, webhooks, menor risco de bloqueio e maior previsibilidade contratual. Custo e aprovação de templates fazem parte do planejamento.
+      </div>
+    </div>
+
+    <div style="margin-top:20px; margin-bottom:8px; font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase">3 modos de operação possíveis</div>
+    <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:14px; margin-bottom:16px">
+      <div class="mini-card">
+        <h3>Modo 1 — Tudo no WhatsApp</h3>
+        <p style="font-size:13px">Triagem, dúvidas, escolha do tipo de certificado, lembretes, status e confirmação de dados não críticos. Para fluxos simples e de baixo risco.</p>
+      </div>
+      <div class="mini-card" style="border:2px solid var(--green)">
+        <h3 style="color:var(--green)">Modo 2 — Híbrido <span style="font-size:11px; font-weight:400; background:var(--green); color:#fff; padding:2px 6px; border-radius:4px; margin-left:4px">RECOMENDADO</span></h3>
+        <p style="font-size:13px">WhatsApp conduz a jornada; tela segura da MF para upload de documentos, pagamento, assinatura e etapas ICP-Brasil. Após concluir, o cliente volta para a conversa. Padrão de bancos e fintechs.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Modo 3 — Portal primeiro</h3>
+        <p style="font-size:13px">Para clientes que já usam um portal da MF. O WhatsApp funciona como segunda tela: notifica, responde dúvidas e envia links de ação para o ambiente principal.</p>
       </div>
     </div>
   </div>
@@ -522,6 +548,98 @@ tr:hover td { background: var(--bg); }
   </div>
 </div>
 
+<!-- MEMÓRIA E MODELO -->
+<div class="card card-blue" id="memoria-e-modelo">
+  <div class="card-header">
+    <h2>🧠 Como o agente lembra e decide</h2>
+    <span class="badge badge-blue">CONCEITO</span>
+  </div>
+  <div class="card-body">
+
+    <p style="font-size:14px; color:var(--muted); margin-bottom:20px">Para entender por que o agente "lembra" de uma conversa de três dias atrás ou responde como a MF em vez de genérico, ajuda conhecer as quatro camadas de memória por trás de cada resposta.</p>
+
+    <!-- Bloco 1: 4 camadas de memória -->
+    <div style="font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:12px">As 4 camadas de memória</div>
+    <table style="margin-bottom:8px">
+      <tr>
+        <th style="width:30%">Camada</th>
+        <th>O que armazena</th>
+        <th>Durabilidade</th>
+      </tr>
+      <tr>
+        <td><strong>1. Conversa corrente</strong></td>
+        <td>As últimas mensagens da conversa — mantém o fio da interação em curso</td>
+        <td>Dura a sessão; vive no banco de dados, não no chat</td>
+      </tr>
+      <tr>
+        <td><strong>2. Estado do processo</strong></td>
+        <td>Em que etapa o pedido está — documentos pendentes, agendamento confirmado, tipo de certificado selecionado</td>
+        <td>Sobrevive a pausas: a pessoa pode voltar 3 dias depois e o agente retoma do ponto exato</td>
+      </tr>
+      <tr>
+        <td><strong>3. Perfil do cliente</strong></td>
+        <td>Quem é, histórico de atendimentos, preferências registradas</td>
+        <td>Cresce com o relacionamento — cada interação enriquece</td>
+      </tr>
+      <tr>
+        <td><strong>4. Conhecimento do negócio</strong></td>
+        <td>FAQ, regras, tipos de certificado, preços e procedimentos da MF</td>
+        <td>É o que faz o agente responder como a MF — não genérico</td>
+      </tr>
+    </table>
+    <div class="callout callout-blue" style="margin-bottom:20px">
+      <span class="callout-icon">ℹ️</span>
+      <div class="callout-body">
+        Esse desenho em camadas sobre banco de dados padrão (PostgreSQL) é o mesmo usado por sistemas de produção e validado em pesquisa publicada em 2025–2026 — não é experimento nosso.
+      </div>
+    </div>
+
+    <!-- Bloco 2: Escopo fechado e custo -->
+    <div style="font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:12px">Por que escopo fechado torna o custo pequeno</div>
+    <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:16px">
+      <div class="mini-card">
+        <h3>Princípio de custo</h3>
+        <p style="font-size:13px">Quanto mais definido o escopo (certificação digital, não "assistente que fala de tudo"), menor e mais barato o modelo de IA necessário. As <strong>ações</strong> vêm das ferramentas conectadas — o modelo conversa e roteia.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Referência de mercado</h3>
+        <p style="font-size:13px">Uma conversa típica de atendimento custa frações de centavo de dólar em modelos econômicos atuais. O roteamento por camadas (modelo barato para o comum, modelo maior só quando o caso exige) é o padrão de produção em 2026.</p>
+      </div>
+    </div>
+    <div class="callout callout-orange" style="margin-bottom:16px">
+      <span class="callout-icon">⚖️</span>
+      <div class="callout-body">
+        <strong>Fato regulatório (política Meta jan/2026)</strong>
+        O WhatsApp Business API <strong>proíbe chatbots de propósito geral</strong>; só automação estruturada com escopo definido é permitida. Ou seja: escopo fechado não é limitação — é o único desenho permitido pela plataforma e, de bônus, o mais barato de operar.
+      </div>
+    </div>
+    <div class="callout callout-blue" style="margin-bottom:20px">
+      <span class="callout-icon">📐</span>
+      <div class="callout-body">
+        <strong>Honestidade obrigatória</strong>
+        O custo real do piloto se mede no piloto — os números acima são referências públicas de mercado, não orçamento. Custos reais dependem do volume de conversas e das ferramentas integradas, que só sabemos depois do diagnóstico.
+      </div>
+    </div>
+
+    <!-- Bloco 3: Modelo como configuração -->
+    <div style="font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase; margin-bottom:12px">Modelo de IA como configuração, não dogma</div>
+    <p style="font-size:14px; color:var(--muted); margin-bottom:20px">O modelo de linguagem é uma peça <strong>trocável por configuração</strong> — definida por cliente e por função (<code>LLM_TIER</code> no sistema). Para a MF isso significa: começamos no tier econômico, escalamos por evidência, e cada cliente replicado pode ter o seu tier independente. Nenhum vendor está fechado — a arquitetura é agnóstica por design.</p>
+
+    <!-- Bloco 4: Medição como entregável -->
+    <div class="callout callout-green">
+      <span class="callout-icon">📋</span>
+      <div class="callout-body">
+        <strong>Medição como entregável — o que o piloto inclui além do agente</strong>
+        O piloto inclui uma suíte de avaliação com casos reais do fluxo da MF (golden cases) rodando contra o agente. No fim dos 30 dias, a MF recebe não só o agente, mas a <strong>evidência de onde ele acerta e onde escala para humano</strong> — material que praticamente nenhum fornecedor de chatbot entrega.
+      </div>
+    </div>
+
+    <p style="font-size:11px; color:var(--muted); margin-top:20px; line-height:1.7">
+      Referências: política WhatsApp Business jan/2026 (Meta/Turn.io) · RouteLLM (ICLR 2025) · preços oficiais Google AI / OpenAI / Anthropic acessados em 10/06/2026 · padrão Postgres-como-memória (Letta/AWS, 2025–2026)
+    </p>
+  </div>
+</div>
+
 <!-- SEGURANÇA CPF -->
 <div class="card card-orange" id="privacidade">
   <div class="card-header">
@@ -533,7 +651,7 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
         <strong>Contexto real (jun/2026)</strong>
-        Na prática de jun/2026, grandes empresas e órgãos governamentais brasileiros já delegam funções e passam dados reais para modelos de LLM. O LGPD existe, mas tem enforcement limitado — a maioria das organizações opera com base em políticas internas e termos de uso dos provedores, não em mascaramento técnico. Apresentamos os dois caminhos com custo e benefício honesto.
+        O CPF é dado pessoal — não é dado sensível por si só, mas deve ser minimizado, protegido, tratado com base legal documentada e evitado em logs e modelos sempre que possível. Apresentamos dois caminhos com custo e benefício honesto. A escolha define a arquitetura do piloto desde a semana 1.
       </div>
     </div>
 
@@ -599,7 +717,7 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">⚡</span>
       <div class="callout-body">
         <strong>Decisão incluída nas 3 perguntas ao Miguel</strong>
-        Qual cenário você prefere e com qual justificativa? A resposta define a arquitetura do piloto na semana 1. Sem essa decisão, implementamos o Cenário A (padrão, custo zero) e migramos para B se necessário.
+        Qual cenário você prefere e com qual justificativa? A resposta define a arquitetura do piloto na semana 1. <strong>Nossa recomendação padrão é o Cenário B (pseudonimização)</strong> — o CPF nunca chega ao modelo, os logs são limpos e a posição é defensável em qualquer auditoria LGPD. O custo é +2 semanas de engenharia no início. O Cenário A é válido para operações internas com equipe treinada e DPA assinado com o provedor; a MF escolhe.
       </div>
     </div>
   </div>
@@ -630,15 +748,25 @@ tr:hover td { background: var(--bg); }
         <td style="color:var(--orange); font-weight:700">⚠ DEPENDE DO CENÁRIO</td>
         <td><strong>Cenário A:</strong> CPF vai ao LLM — mitigação via DPA com provedor. <strong>Cenário B:</strong> token vai ao LLM, CPF nunca exposto. A escolha é do cliente — ver seção Segurança.</td>
       </tr>
+      <tr>
+        <td><strong>Base legal (complemento)</strong></td>
+        <td style="color:var(--orange); font-weight:700">⚠ MAPEAR</td>
+        <td>Além da execução de contrato, mapear por campo: cumprimento de obrigação regulatória (ICP-Brasil) e legítimo interesse onde aplicável. Confirmar no RIPD da empresa.</td>
+      </tr>
+      <tr>
+        <td><strong>Aviso ao usuário</strong></td>
+        <td style="color:var(--orange); font-weight:700">⚠ RECOMENDADO</td>
+        <td>Primeira mensagem do agente deve informar: atendimento automatizado, uso de dados, canal para falar com humano e link de política de privacidade — boas práticas ANPD.</td>
+      </tr>
       <tr>
         <td><strong>Transferência internacional</strong></td>
         <td style="color:var(--orange); font-weight:700">⚠ CONDICIONAL</td>
-        <td>Cenário B: token (não CPF) vai ao LLM — mitigação robusta. Cenário A: DPA com provedor é a mitigação adequada. Recomendado para qualquer cenário com clientes EU.</td>
+        <td>Se dados pessoais trafegarem para provedor LLM fora do Brasil (OpenAI/Google/Anthropic), observar <strong>Resolução CD/ANPD nº 19/2024</strong> — cláusulas-padrão contratuais e DPA com o provedor. Cenário B (tokenização) reduz a exposição.</td>
       </tr>
       <tr>
-        <td><strong>Aviso ao usuário</strong></td>
+        <td><strong>Rastreabilidade de atendimento</strong></td>
         <td style="color:var(--orange); font-weight:700">⚠ RECOMENDADO</td>
-        <td>Primeira mensagem do agente deve informar que está em atendimento automatizado — boas práticas ANPD.</td>
+        <td>Todo atendimento deve ter log: ferramenta usada, decisão tomada, escalada humana e motivo. O Evidence Footer do EGOS registra isso internamente — não necessariamente visível ao cliente final.</td>
       </tr>
       <tr>
         <td><strong>Retenção de dados</strong></td>
@@ -650,7 +778,7 @@ tr:hover td { background: var(--bg); }
     <div class="callout callout-blue" style="margin-top:16px">
       <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
-        A MF Certificados já tem obrigação LGPD pela atividade de AR/AC. O agente WhatsApp não cria novas obrigações — apenas automatiza um canal que já existe. O ponto crítico é garantir que o aviso de atendimento automatizado esteja presente.
+        A MF Certificados já tem obrigação LGPD pela atividade de AR/AC. O agente WhatsApp não cria novas obrigações — apenas automatiza um canal que já existe. Ponto importante: <strong>usar o WhatsApp como canal não transfere a responsabilidade pelo tratamento de dados — a MF Certificados permanece controladora</strong> e responde pelos dados tratados via esse canal perante a ANPD e os titulares. O WhatsApp (Meta) atua como operador/plataforma de terceiro, e isso deve estar refletido na Política de Privacidade da empresa.
       </div>
     </div>
   </div>
@@ -786,12 +914,28 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
         <strong>O que isso significa para uma AR como a MF Certificados:</strong>
-        Volume crescente de emissões + mudança regulatória (Selo e-CNPJ) = aumento de demanda de atendimento simultâneo a uma reestruturação de fluxo. ARs que automatizarem o atendimento de triagem (identificação de tipo de certificado, coleta de docs, agendamento) antes dessa transição saem na frente. A pergunta não é "se" automatar — é "qual fluxo automatar primeiro".
+        Volume crescente de emissões + mudança regulatória (Selo e-CNPJ + AR Eletrônica em pauta no Comitê Gestor 2026) = aumento de demanda de atendimento simultâneo a uma reestruturação de fluxo. ARs que automatizarem o atendimento de triagem (identificação de tipo de certificado, coleta de docs, agendamento) antes dessa transição saem na frente. A pergunta não é "se" automatar — é "qual fluxo automatar primeiro".
+      </div>
+    </div>
+
+    <div style="margin-top:20px; margin-bottom:8px; font-size:13px; font-weight:700; color:var(--muted); text-transform:uppercase">Referências: WhatsApp-first em outros setores</div>
+    <div style="display:grid; grid-template-columns:repeat(3, 1fr); gap:14px; margin-bottom:16px">
+      <div class="mini-card">
+        <h3>Meta Business Agent</h3>
+        <p style="font-size:13px">Lançado em jun/2026 para WhatsApp, Messenger e Instagram. Valida a direção "chat + ações no backend" — agendar, qualificar, escalar para humano e conectar sistemas como Shopify e Zendesk.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Farmacias del Ahorro</h3>
+        <p style="font-size:13px">Case oficial de WhatsApp Flows para solicitação de consulta médica dentro do próprio WhatsApp, sem redirecionar o cliente — demonstra formulário nativo conectado a backend.</p>
+      </div>
+      <div class="mini-card">
+        <h3>Vitaldent (Espanha)</h3>
+        <p style="font-size:13px">Rede odontológica integrou WhatsApp Business Platform a ERP/CRM para lembretes, confirmações e reagendamentos — alta taxa de confirmação sem digitação manual.</p>
       </div>
     </div>
 
     <p style="font-size:11px; color:var(--muted); margin-top:12px">
-      Fontes: <a href="https://ancd.org.br/icp-brasil-comeca-2025-com-numeros-positivos/" target="_blank" style="color:var(--blue)">ANCD — jan/2025</a> · <a href="https://ancd.org.br/icp-brasil-apresenta-crescimento-em-agosto-de-2025/" target="_blank" style="color:var(--blue)">ANCD — ago/2025</a> · <a href="https://cryptoid.com.br/icp-brasil/certisign-traz-pauta-da-icp-brasil-e-e-autoridade-certificadora/" target="_blank" style="color:var(--blue)">Certisign/CryptoID — 2026</a>
+      Fontes: <a href="https://ancd.org.br/icp-brasil-comeca-2025-com-numeros-positivos/" target="_blank" style="color:var(--blue)">ANCD — jan/2025</a> · <a href="https://ancd.org.br/icp-brasil-apresenta-crescimento-em-agosto-de-2025/" target="_blank" style="color:var(--blue)">ANCD — ago/2025</a> · <a href="https://cryptoid.com.br/icp-brasil/certisign-traz-pauta-da-icp-brasil-e-e-autoridade-certificadora/" target="_blank" style="color:var(--blue)">Certisign/CryptoID — 2026</a> · <a href="https://whatsappbusiness.com/resources/success-stories/farmacias-del-ahorro/" target="_blank" style="color:var(--blue)">Meta — Farmacias del Ahorro</a> · <a href="https://whatsappbusiness.com/resources/success-stories/vitaldent/" target="_blank" style="color:var(--blue)">Meta — Vitaldent</a>
     </p>
   </div>
 </div>
@@ -932,11 +1076,33 @@ tr:hover td { background: var(--bg); }
   </div>
 </div>
 
+<!-- FONTES -->
+<div class="card card-blue" id="fontes" style="margin-top:8px">
+  <div class="card-header">
+    <h2>🔎 Fontes consultadas</h2>
+    <span class="badge badge-blue">jun/2026</span>
+  </div>
+  <div class="card-body">
+    <p style="font-size:13px; color:var(--muted); margin-bottom:12px">Fontes públicas verificadas usadas neste diagnóstico. Dados de mercado e regulatórios foram checados antes de incluir.</p>
+    <ul style="font-size:13px; color:var(--muted); line-height:2; padding-left:18px">
+      <li>ANCD — ICP-Brasil começa 2025 com números positivos: <a href="https://ancd.org.br/icp-brasil-comeca-2025-com-numeros-positivos/" target="_blank" style="color:var(--blue)">ancd.org.br</a></li>
+      <li>ANCD — AR Eletrônica em pauta no Comitê Gestor 2026: <a href="https://ancd.org.br/comite-gestor-publica-resolucao-que-viabiliza-a-ar-eletronica/" target="_blank" style="color:var(--blue)">ancd.org.br</a></li>
+      <li>ITI — IN ITI nº 36/2026 (confirmação de identidade de requerente, publicada 04/05/2026): <a href="https://www.gov.br/iti/pt-br/assuntos/legislacao/instrucoes-normativas" target="_blank" style="color:var(--blue)">gov.br/iti</a></li>
+      <li>ITI — IN ITI nº 37/2026 (identificação biométrica ICP-Brasil, publicada 04/05/2026): <a href="https://www.gov.br/iti/pt-br/assuntos/legislacao/instrucoes-normativas" target="_blank" style="color:var(--blue)">gov.br/iti</a></li>
+      <li>ANPD — Resolução CD/ANPD nº 19/2024 (transferência internacional de dados): <a href="https://www.gov.br/anpd/pt-br/assuntos/assuntos-internacionais/transferencia-internacional-de-dados" target="_blank" style="color:var(--blue)">gov.br/anpd</a></li>
+      <li>Meta / WhatsApp Business — WhatsApp Flows (formulários nativos com endpoint de backend): <a href="https://whatsappbusiness.com/products/business-platform/" target="_blank" style="color:var(--blue)">whatsappbusiness.com</a></li>
+      <li>Meta / WhatsApp Business — Case Farmacias del Ahorro: <a href="https://whatsappbusiness.com/resources/success-stories/farmacias-del-ahorro/" target="_blank" style="color:var(--blue)">whatsappbusiness.com</a></li>
+      <li>Meta / WhatsApp Business — Case Vitaldent: <a href="https://whatsappbusiness.com/resources/success-stories/vitaldent/" target="_blank" style="color:var(--blue)">whatsappbusiness.com</a></li>
+      <li>Certisign/CryptoID — Pauta ICP-Brasil 2026: <a href="https://cryptoid.com.br/icp-brasil/certisign-traz-pauta-da-icp-brasil-e-e-autoridade-certificadora/" target="_blank" style="color:var(--blue)">cryptoid.com.br</a></li>
+    </ul>
+  </div>
+</div>
+
 </main>
 </div>
 
 <footer class="page-footer">
-  <strong>EGOS Framework</strong> — Documento gerado em 2026-06-09 para uso exclusivo MF Certificados × EGOS<br>
+  <strong>EGOS Framework</strong> — Documento atualizado em 2026-06-10 para uso exclusivo MF Certificados × EGOS<br>
   <span style="font-size:12px">Confidencial — compartilhar apenas com a equipe MF Certificados e EGOS</span>
 </footer>
 
diff --git a/packages/guard-brasil/src/lib/public-guard.ts b/packages/guard-brasil/src/lib/public-guard.ts
index 70a4e4b4..0591679b 100644
--- a/packages/guard-brasil/src/lib/public-guard.ts
+++ b/packages/guard-brasil/src/lib/public-guard.ts
@@ -6,8 +6,8 @@
  * in AI-generated responses.
  */
 
-import { scanForPII, sanitizeText, type PIIFinding } from './pii-scanner.js';
-import { maskPII, type MaskMode } from '../pii-patterns.js';
+import { scanForPII, sanitizeText, type PIIFinding, type PIIPatternDefinition } from './pii-scanner.js';
+import { maskPII, type MaskMode, type CustomPIIPattern } from '../pii-patterns.js';
 
 export type GuardAction = 'mask' | 'redact' | 'block' | 'warn';
 export type SensitivityLevel = 'low' | 'medium' | 'high' | 'critical';
diff --git a/packages/guard-brasil/src/pii-patterns.ts b/packages/guard-brasil/src/pii-patterns.ts
index b55b733d..6efc5459 100644
--- a/packages/guard-brasil/src/pii-patterns.ts
+++ b/packages/guard-brasil/src/pii-patterns.ts
@@ -9,7 +9,7 @@
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
-/** Identifier for each PII pattern category */
+/** Identifier for each built-in PII pattern category */
 export type PIIPatternId =
   | 'cpf'
   | 'cnpj'
@@ -36,6 +36,52 @@ export type PIIPatternId =
   | 'bearer_token'
   | 'private_key';
 
+/**
+ * Custom pattern ID — any string prefixed with the institution/domain namespace.
+ * Convention: `<namespace>:<identifier>` e.g. `pcmg:bo_numero`, `tjmg:processo_estadual`.
+ * The namespace prevents collisions across institutions and makes origin traceable.
+ */
+export type CustomPIIPatternId = string;
+
+/** Union: built-in or custom. Use this when accepting any pattern ID. */
+export type AnyPIIPatternId = PIIPatternId | CustomPIIPatternId;
+
+/**
+ * Custom PII pattern — same shape as PIIPatternConfig but with open-ended id.
+ * Institutions define their own patterns without modifying Guard Brasil core.
+ *
+ * HITL training cycle:
+ *   1. Add pattern with `confidence: 'low'`
+ *   2. Run on real data (synthetic/anonymized for training)
+ *   3. Human reviews flagged matches → confirms/rejects via HITL UI
+ *   4. After N confirmations, confidence auto-upgrades to 'medium' then 'high'
+ *   5. Export/import via JSON — no code change required
+ */
+export interface CustomPIIPattern {
+  /** Namespaced ID: `<institution>:<type>` */
+  id: CustomPIIPatternId;
+  /** Human-readable label (PT-BR) */
+  label: string;
+  /** Detection regex — MUST use the `g` flag */
+  regex: RegExp;
+  /** Replacement shown in redacted output */
+  maskFormat: string;
+  /** Initial confidence — start low, elevate via HITL */
+  confidence: PatternConfidence;
+  /** Optional description for documentation / HITL UI */
+  description?: string;
+  /** Who defined this pattern */
+  author?: string;
+  /** When this pattern was created (ISO 8601) */
+  createdAt?: string;
+  /** HITL stats — updated by the training loop */
+  hitlStats?: {
+    confirmations: number;
+    rejections: number;
+    lastReviewedAt?: string;
+  };
+}
+
 /** Confidence that a regex match is actually the claimed PII type */
 export type PatternConfidence = 'high' | 'medium' | 'low';
 

exec
/bin/bash -lc 'git diff eb3edd983411d6e230148496c4f4b07426063221 -- packages/guard-brasil/src/pii-patterns.ts packages/guard-brasil/src/lib/public-guard.ts' in /home/enio/egos
 succeeded in 0ms:
diff --git a/packages/guard-brasil/src/lib/public-guard.ts b/packages/guard-brasil/src/lib/public-guard.ts
index 70a4e4b4..0591679b 100644
--- a/packages/guard-brasil/src/lib/public-guard.ts
+++ b/packages/guard-brasil/src/lib/public-guard.ts
@@ -6,8 +6,8 @@
  * in AI-generated responses.
  */
 
-import { scanForPII, sanitizeText, type PIIFinding } from './pii-scanner.js';
-import { maskPII, type MaskMode } from '../pii-patterns.js';
+import { scanForPII, sanitizeText, type PIIFinding, type PIIPatternDefinition } from './pii-scanner.js';
+import { maskPII, type MaskMode, type CustomPIIPattern } from '../pii-patterns.js';
 
 export type GuardAction = 'mask' | 'redact' | 'block' | 'warn';
 export type SensitivityLevel = 'low' | 'medium' | 'high' | 'critical';
diff --git a/packages/guard-brasil/src/pii-patterns.ts b/packages/guard-brasil/src/pii-patterns.ts
index b55b733d..6efc5459 100644
--- a/packages/guard-brasil/src/pii-patterns.ts
+++ b/packages/guard-brasil/src/pii-patterns.ts
@@ -9,7 +9,7 @@
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
-/** Identifier for each PII pattern category */
+/** Identifier for each built-in PII pattern category */
 export type PIIPatternId =
   | 'cpf'
   | 'cnpj'
@@ -36,6 +36,52 @@ export type PIIPatternId =
   | 'bearer_token'
   | 'private_key';
 
+/**
+ * Custom pattern ID — any string prefixed with the institution/domain namespace.
+ * Convention: `<namespace>:<identifier>` e.g. `pcmg:bo_numero`, `tjmg:processo_estadual`.
+ * The namespace prevents collisions across institutions and makes origin traceable.
+ */
+export type CustomPIIPatternId = string;
+
+/** Union: built-in or custom. Use this when accepting any pattern ID. */
+export type AnyPIIPatternId = PIIPatternId | CustomPIIPatternId;
+
+/**
+ * Custom PII pattern — same shape as PIIPatternConfig but with open-ended id.
+ * Institutions define their own patterns without modifying Guard Brasil core.
+ *
+ * HITL training cycle:
+ *   1. Add pattern with `confidence: 'low'`
+ *   2. Run on real data (synthetic/anonymized for training)
+ *   3. Human reviews flagged matches → confirms/rejects via HITL UI
+ *   4. After N confirmations, confidence auto-upgrades to 'medium' then 'high'
+ *   5. Export/import via JSON — no code change required
+ */
+export interface CustomPIIPattern {
+  /** Namespaced ID: `<institution>:<type>` */
+  id: CustomPIIPatternId;
+  /** Human-readable label (PT-BR) */
+  label: string;
+  /** Detection regex — MUST use the `g` flag */
+  regex: RegExp;
+  /** Replacement shown in redacted output */
+  maskFormat: string;
+  /** Initial confidence — start low, elevate via HITL */
+  confidence: PatternConfidence;
+  /** Optional description for documentation / HITL UI */
+  description?: string;
+  /** Who defined this pattern */
+  author?: string;
+  /** When this pattern was created (ISO 8601) */
+  createdAt?: string;
+  /** HITL stats — updated by the training loop */
+  hitlStats?: {
+    confirmations: number;
+    rejections: number;
+    lastReviewedAt?: string;
+  };
+}
+
 /** Confidence that a regex match is actually the claimed PII type */
 export type PatternConfidence = 'high' | 'medium' | 'low';
 

exec
/bin/bash -lc "sed -n '1,240p' packages/guard-brasil/src/lib/public-guard.ts && sed -n '1,220p' packages/guard-brasil/src/pii-patterns.ts && cat packages/guard-brasil/tsconfig.json" in /home/enio/egos
 succeeded in 0ms:
/**
 * Public Guard — Safe output masking for Brazilian AI systems
 *
 * Masks sensitive public data references to comply with LGPD
 * and prevent inadvertent exposure of personal information
 * in AI-generated responses.
 */

import { scanForPII, sanitizeText, type PIIFinding, type PIIPatternDefinition } from './pii-scanner.js';
import { maskPII, type MaskMode, type CustomPIIPattern } from '../pii-patterns.js';

export type GuardAction = 'mask' | 'redact' | 'block' | 'warn';
export type SensitivityLevel = 'low' | 'medium' | 'high' | 'critical';

export interface PublicGuardConfig {
  /** Action when PII is found */
  piiAction?: GuardAction;
  /** Action for critical PII (CPF, MASP, REDS) */
  criticalPiiAction?: GuardAction;
  /** Threshold: score below this blocks the output */
  blockThreshold?: number;
  /** Add audit trail to each masking action */
  auditTrail?: boolean;
  /** Custom replacement templates */
  replacements?: Partial<Record<string, string>>;
  /**
   * Masking mode:
   * - 'full' (default): fully redact → [CPF REMOVIDO]
   * - 'partial': banking-style partial reveal → ***.456.789-**
   */
  maskMode?: MaskMode;
}

export interface MaskingResult {
  original: string;
  masked: string;
  findings: PIIFinding[];
  actionsApplied: MaskingAction[];
  safe: boolean;
  sensitivityLevel: SensitivityLevel;
}

export interface MaskingAction {
  category: string;
  action: GuardAction;
  count: number;
  positions: Array<{ start: number; end: number }>;
}

const CRITICAL_CATEGORIES = new Set(['cpf', 'masp', 'reds', 'rg']);
const HIGH_CATEGORIES = new Set(['process_number', 'date_of_birth']);

function computeSensitivity(findings: PIIFinding[]): SensitivityLevel {
  if (findings.some(f => CRITICAL_CATEGORIES.has(f.category))) return 'critical';
  if (findings.some(f => HIGH_CATEGORIES.has(f.category))) return 'high';
  if (findings.length > 3) return 'medium';
  if (findings.length > 0) return 'low';
  return 'low';
}

/**
 * Masks PII from a text according to Guard Brasil policy.
 * Returns the masked text plus a full audit of all actions taken.
 */
export function maskPublicOutput(text: string, config: PublicGuardConfig = {}): MaskingResult {
  const piiAction = config.piiAction ?? 'mask';
  const criticalPiiAction = config.criticalPiiAction ?? 'redact';

  const findings = scanForPII(text);
  const sensitivityLevel = computeSensitivity(findings);

  const actionsMap = new Map<string, MaskingAction>();

  for (const finding of findings) {
    const isCritical = CRITICAL_CATEGORIES.has(finding.category);
    const action = isCritical ? criticalPiiAction : piiAction;

    if (!actionsMap.has(finding.category)) {
      actionsMap.set(finding.category, {
        category: finding.category,
        action,
        count: 0,
        positions: [],
      });
    }
    const entry = actionsMap.get(finding.category)!;
    entry.count++;
    entry.positions.push({ start: finding.start, end: finding.end });
  }

  const blocked = sensitivityLevel === 'critical' && criticalPiiAction === 'block';
  let masked: string;
  if (blocked) {
    masked = '[CONTEÚDO BLOQUEADO — DADOS SENSÍVEIS DETECTADOS]';
  } else if (config.maskMode === 'partial') {
    masked = maskPII(text, undefined, 'partial');
  } else {
    masked = sanitizeText(text, findings);
  }

  return {
    original: text,
    masked,
    findings,
    actionsApplied: [...actionsMap.values()],
    safe: findings.length === 0,
    sensitivityLevel,
  };
}

/**
 * Quick check: returns true if the text is safe to output publicly.
 */
export function isPublicSafe(text: string): boolean {
  return scanForPII(text).length === 0;
}

/**
 * Generates a LGPD-compliant disclosure note for masked outputs.
 */
export function buildLGPDDisclosure(result: MaskingResult): string {
  if (result.safe) return '';
  const categories = [...new Set(result.findings.map(f => f.label))].join(', ');
  return `[LGPD] Dados pessoais detectados e mascarados nesta resposta: ${categories}. Conforme Lei 13.709/2018.`;
}
/**
 * PII Patterns — Centralized Brazilian PII detection and masking
 *
 * Single source of truth for all Brazilian personally identifiable
 * information patterns used across Guard Brasil modules.
 *
 * Compliance: Lei 13.709/2018 (LGPD)
 */

// ─── Types ────────────────────────────────────────────────────────────────────

/** Identifier for each built-in PII pattern category */
export type PIIPatternId =
  | 'cpf'
  | 'cnpj'
  | 'rg'
  | 'cnh'
  | 'sus'
  | 'titulo_eleitor'
  | 'nis_pis'
  | 'masp'
  | 'reds'
  | 'processo'
  | 'placa_antiga'
  | 'placa_mercosul'
  | 'telefone'
  | 'email'
  | 'cep'
  | 'health_condition'
  // Infrastructure secrets (ported from egos-cortex privacy.ts)
  | 'aws_key'
  | 'github_token'
  | 'stripe_key'
  | 'db_connection'
  | 'api_key_assignment'
  | 'bearer_token'
  | 'private_key';

/**
 * Custom pattern ID — any string prefixed with the institution/domain namespace.
 * Convention: `<namespace>:<identifier>` e.g. `pcmg:bo_numero`, `tjmg:processo_estadual`.
 * The namespace prevents collisions across institutions and makes origin traceable.
 */
export type CustomPIIPatternId = string;

/** Union: built-in or custom. Use this when accepting any pattern ID. */
export type AnyPIIPatternId = PIIPatternId | CustomPIIPatternId;

/**
 * Custom PII pattern — same shape as PIIPatternConfig but with open-ended id.
 * Institutions define their own patterns without modifying Guard Brasil core.
 *
 * HITL training cycle:
 *   1. Add pattern with `confidence: 'low'`
 *   2. Run on real data (synthetic/anonymized for training)
 *   3. Human reviews flagged matches → confirms/rejects via HITL UI
 *   4. After N confirmations, confidence auto-upgrades to 'medium' then 'high'
 *   5. Export/import via JSON — no code change required
 */
export interface CustomPIIPattern {
  /** Namespaced ID: `<institution>:<type>` */
  id: CustomPIIPatternId;
  /** Human-readable label (PT-BR) */
  label: string;
  /** Detection regex — MUST use the `g` flag */
  regex: RegExp;
  /** Replacement shown in redacted output */
  maskFormat: string;
  /** Initial confidence — start low, elevate via HITL */
  confidence: PatternConfidence;
  /** Optional description for documentation / HITL UI */
  description?: string;
  /** Who defined this pattern */
  author?: string;
  /** When this pattern was created (ISO 8601) */
  createdAt?: string;
  /** HITL stats — updated by the training loop */
  hitlStats?: {
    confirmations: number;
    rejections: number;
    lastReviewedAt?: string;
  };
}

/** Confidence that a regex match is actually the claimed PII type */
export type PatternConfidence = 'high' | 'medium' | 'low';

/** Definition of a single PII pattern */
/** Whether to fully redact or partially reveal (banking-style) */
export type MaskMode = 'full' | 'partial';

export interface PIIPatternConfig {
  /** Unique identifier */
  id: PIIPatternId;
  /** Human-readable label (PT-BR) */
  label: string;
  /** Detection regex — MUST use the `g` flag */
  regex: RegExp;
  /** Mask format shown in redacted output (full mode) */
  maskFormat: string;
  /** How confident we are that a match is real (not a false positive) */
  confidence: PatternConfidence;
  /** Optional description for documentation / tooling */
  description?: string;
  /**
   * Partial mask — show enough digits for user confirmation (banking-style).
   * E.g. CPF 123.456.789-09 → ***.456.789-**
   * Falls back to maskFormat if undefined.
   */
  partialMaskFn?: (matched: string) => string;
}

/** A single PII match found in text */
export interface PIIMatch {
  /** Which pattern matched */
  patternId: PIIPatternId;
  /** PT-BR label */
  label: string;
  /** The matched substring */
  matched: string;
  /** Start index in the original text */
  start: number;
  /** End index in the original text */
  end: number;
  /** Confidence level */
  confidence: PatternConfidence;
  /** The mask string that would replace this match */
  maskFormat: string;
}

// ─── Pattern Definitions ──────────────────────────────────────────────────────

/** CPF — Cadastro de Pessoas Físicas (11 digits) */
export const CPF_PATTERN: PIIPatternConfig = {
  id: 'cpf',
  label: 'CPF',
  regex: /\b\d{3}[.\s-]?\d{3}[.\s-]?\d{3}[.\s/-]?\d{2}\b/g,
  maskFormat: '[CPF REMOVIDO]',
  confidence: 'high',
  description: 'Cadastro de Pessoas Físicas — 000.000.000-00',
  // Banking-style: ***.456.789-** (middle 6 digits visible)
  partialMaskFn: (matched) => {
    const d = matched.replace(/\D/g, '');
    if (d.length !== 11) return '[CPF REMOVIDO]';
    return `***.${d.slice(3, 6)}.${d.slice(6, 9)}-**`;
  },
};

/** CNPJ — Cadastro Nacional de Pessoas Jurídicas (14 digits) */
export const CNPJ_PATTERN: PIIPatternConfig = {
  id: 'cnpj',
  label: 'CNPJ',
  regex: /\b\d{2}[.\s]?\d{3}[.\s]?\d{3}[/\s]?\d{4}[-.\s]?\d{2}\b/g,
  maskFormat: '[CNPJ REMOVIDO]',
  confidence: 'high',
  description: 'Cadastro Nacional de Pessoas Jurídicas — 00.000.000/0000-00',
  // **.333.000/****-** (show digits 3-8, hide qualifier + check)
  partialMaskFn: (matched) => {
    const d = matched.replace(/\D/g, '');
    if (d.length !== 14) return '[CNPJ REMOVIDO]';
    return `**.${d.slice(2, 5)}.${d.slice(5, 8)}/****-**`;
  },
};

/** RG — Registro Geral (with OR without "RG" keyword) */
export const RG_PATTERN: PIIPatternConfig = {
  id: 'rg',
  label: 'RG',
  // Matches with keyword: "RG 12.345.678-9", "Registro Geral 12.345.678-9"
  // Matches standalone canonical format (dots+dash required): "12.345.678-9"
  regex: /(?:(?:RG|rg|Rg|Registro\s+Geral|registro\s+geral)[\s:nº°.]*(?:[A-Z]{2}[\s-]?)?\d{1,2}[.\s]?\d{3}[.\s]?\d{3}[.\s-]?\d?|\b\d{1,2}\.\d{3}\.\d{3}-\d\b)/gi,
  maskFormat: '[RG REMOVIDO]',
  confidence: 'high',
  description: 'Registro Geral — RG 00.000.000-0',
};

/** CNH — Carteira Nacional de Habilitação (11 digits, preceded by keyword) */
export const CNH_PATTERN: PIIPatternConfig = {
  id: 'cnh',
  label: 'CNH',
  regex: /\b(?:CNH|cnh|Cnh|habilitação|habilitacao)[:\s]*\d{9,11}\b/gi,
  maskFormat: '[CNH REMOVIDO]',
  confidence: 'medium',
  description: 'Carteira Nacional de Habilitação — 00000000000',
};

/** MASP — Matrícula de Servidor Público (Minas Gerais) */
export const MASP_PATTERN: PIIPatternConfig = {
  id: 'masp',
  label: 'MASP',
  regex: /\b(?:MASP|masp|Masp)[:\s]*\d{1,3}[.\s]?\d{3,5}[.\s-]?\d{0,2}\b/gi,
  maskFormat: '[MASP REMOVIDO]',
  confidence: 'high',
  description: 'Matrícula de Servidor Público — MASP 0000000-0',
};

/** REDS — Registro de Eventos de Defesa Social (Minas Gerais) */
export const REDS_PATTERN: PIIPatternConfig = {
  id: 'reds',
  label: 'REDS',
  regex: /\b(?:REDS|reds|Reds)[:\s]*\d{4,}[-./]?\d{0,}\b/gi,
  maskFormat: '[REDS REMOVIDO]',
  confidence: 'high',
  description: 'Registro de Eventos de Defesa Social — REDS 0000000000',
};

/** Processo Judicial — CNJ numbering format (NNNNNNN-DD.AAAA.J.TR.OOOO) */
export const PROCESSO_PATTERN: PIIPatternConfig = {
  id: 'processo',
  label: 'Processo Judicial',
  regex: /\b\d{7}[-.]?\d{2}[.]?\d{4}[.]?\d[.]?\d{2}[.]?\d{4}\b/g,
  maskFormat: '[PROCESSO REMOVIDO]',
  confidence: 'high',
  description: 'Número de processo judicial CNJ — 0000000-00.0000.0.00.0000',
};

/** Placa Antiga — formato brasileiro antigo (AAA-0000) */
export const PLACA_ANTIGA_PATTERN: PIIPatternConfig = {
  id: 'placa_antiga',
  label: 'Placa Veicular',
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist",
    "composite": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["src/**/*.test.ts", "node_modules", "dist"]
}

exec
/bin/bash -lc "cat tsconfig.json | sed -n '1,160p'; grep -R \"noUnused\" -n tsconfig* packages/guard-brasil || true" in /home/enio/egos
 succeeded in 0ms:
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM"],
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "strict": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "types": ["node", "bun"],
    "paths": {
      "@egos/shared": ["./packages/shared/src"],
      "@egos/shared/*": ["./packages/shared/src/*"],
      "@egos/search-engine": ["./packages/search-engine/src"],
      "@egos/search-engine/*": ["./packages/search-engine/src/*"],
      "@egos/atomizer": ["./packages/atomizer/src"],
      "@egos/atomizer/*": ["./packages/atomizer/src/*"],
      "@egos/types": ["./packages/types/src"],
      "@egos/types/*": ["./packages/types/src/*"],
      "@egos/core": ["./packages/core/src"],
      "@egos/core/*": ["./packages/core/src/*"],
      "@egos/audit": ["./packages/audit/src"],
      "@egos/audit/*": ["./packages/audit/src/*"],
      "@egos/registry": ["./packages/registry/src"],
      "@egos/registry/*": ["./packages/registry/src/*"],
      "@egos/guard-brasil": ["./packages/guard-brasil/src"],
      "@egos/guard-brasil/*": ["./packages/guard-brasil/src/*"]
    }
  },
  "include": [
    "agents/**/*.ts",
    "packages/**/*.ts",
    "scripts/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "**/*.test.ts",
    "packages/core/src/auth",
    "packages/audit/src/activation-audit.ts",
    "packages/shared/src/mcp-audit-handler.ts",
    "packages/mcp-memory",
    "packages/mcp-bridge",
    "packages/mcp-browser-automation",
    "packages/mcp-eval-runner",
    "packages/mcp-g-pecas",
    "packages/mcp-governance",
    "packages/mcp-observability",
    "packages/mcp-ops",
    "packages/mcp-security",
    "packages/mcp-skills-registry",
    "packages/mcp-literature",
    "packages/knowledge-mcp",
    "packages/guard-brasil-langchain",
    "packages/guard-brasil-python",
    "packages/shared/src/intelink-llm-router.ts"
  ]
}
packages/guard-brasil/node_modules/@egos/shared/node_modules/zod/src/v4/classic/tests/fix-json-issue.test.ts:3:// biome-ignore lint/correctness/noUnusedImports: This import verifies the type is exported

exec
/bin/bash -lc "grep -R \"PIIPatternDefinition\" -n packages/guard-brasil/src || true; sed -n '1,220p' packages/guard-brasil/src/lib/pii-scanner.ts" in /home/enio/egos
 succeeded in 0ms:
packages/guard-brasil/src/lib/index.ts:10:export type { PIICategory, PIIFinding, PIIPatternDefinition } from './pii-scanner.js';
packages/guard-brasil/src/lib/pii-scanner.ts:8:export interface PIIPatternDefinition { category: PIICategory; label: string; pattern: RegExp; suggestion: string; }
packages/guard-brasil/src/lib/pii-scanner.ts:11: * Bridge from centralized PIIPatternConfig to legacy PIIPatternDefinition format.
packages/guard-brasil/src/lib/pii-scanner.ts:30:function toPIIPatternDefinition(config: PIIPatternConfig): PIIPatternDefinition {
packages/guard-brasil/src/lib/pii-scanner.ts:40:export const DEFAULT_PII_PATTERNS: PIIPatternDefinition[] = ALL_PII_PATTERNS.map(toPIIPatternDefinition);
packages/guard-brasil/src/lib/pii-scanner.ts:43:const DATE_OF_BIRTH_PATTERN: PIIPatternDefinition = {
packages/guard-brasil/src/lib/pii-scanner.ts:58:export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
packages/guard-brasil/src/lib/public-guard.ts:9:import { scanForPII, sanitizeText, type PIIFinding, type PIIPatternDefinition } from './pii-scanner.js';
packages/guard-brasil/src/index.ts:33:export type { PIICategory, PIIFinding, PIIPatternDefinition } from './lib/index.js';
import {
  ALL_PII_PATTERNS,
  type PIIPatternConfig,
} from '../pii-patterns.js';

export type PIICategory = 'cpf' | 'rg' | 'masp' | 'phone' | 'email' | 'reds' | 'process_number' | 'name' | 'address' | 'plate' | 'date_of_birth' | 'cnpj' | 'cnh' | 'cep' | 'health_data';
export interface PIIFinding { category: PIICategory; label: string; matched: string; start: number; end: number; suggestion: string; }
export interface PIIPatternDefinition { category: PIICategory; label: string; pattern: RegExp; suggestion: string; }

/**
 * Bridge from centralized PIIPatternConfig to legacy PIIPatternDefinition format.
 * Maps pii-patterns.ts IDs to the PIICategory values used by existing consumers.
 */
const PATTERN_ID_TO_CATEGORY: Record<string, PIICategory> = {
  cpf: 'cpf',
  cnpj: 'cnpj',
  rg: 'rg',
  cnh: 'cnh',
  masp: 'masp',
  reds: 'reds',
  processo: 'process_number',
  placa_antiga: 'plate',
  placa_mercosul: 'plate',
  telefone: 'phone',
  email: 'email',
  cep: 'cep',
  health_condition: 'health_data',
};

function toPIIPatternDefinition(config: PIIPatternConfig): PIIPatternDefinition {
  return {
    category: PATTERN_ID_TO_CATEGORY[config.id] ?? (config.id as PIICategory),
    label: config.label,
    pattern: config.regex,
    suggestion: config.maskFormat,
  };
}

/** Default PII patterns derived from the centralized pii-patterns.ts registry */
export const DEFAULT_PII_PATTERNS: PIIPatternDefinition[] = ALL_PII_PATTERNS.map(toPIIPatternDefinition);

/** Legacy date-of-birth pattern (kept for backward compatibility) */
const DATE_OF_BIRTH_PATTERN: PIIPatternDefinition = {
  category: 'date_of_birth',
  label: 'Data de Nascimento',
  pattern: /\b(?:nascido|nascimento|nasc\.?|DN|dn)[:\s]*\d{1,2}[\/.-]\d{1,2}[\/.-]\d{2,4}\b/gi,
  suggestion: '[DATA REMOVIDA]',
};

// Append date-of-birth (not yet in centralized patterns — context-dependent)
DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);

// Catches names preceded by role/title (law enforcement) OR explicit label fields (Nome:, Paciente:, etc.)
// Uses /g (not /gi) so character classes remain case-sensitive — prevents over-matching.
const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);

export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
  const findings: PIIFinding[] = [];
  const patterns = options?.patterns ?? DEFAULT_PII_PATTERNS;
  for (const { category, label, suggestion, pattern } of patterns) {
    const activePattern = clonePattern(pattern);
    let match: RegExpExecArray | null;
    while ((match = activePattern.exec(text)) !== null) findings.push({ category, label, matched: match[0], start: match.index, end: match.index + match[0].length, suggestion });
  }
  const namePattern = clonePattern(options?.namePattern ?? DEFAULT_NAME_PATTERN);
  let nameMatch: RegExpExecArray | null;
  while ((nameMatch = namePattern.exec(text)) !== null) {
    const name = nameMatch[1];
    if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
  }
  return deduplicateFindings(findings.sort((a, b) => a.start - b.start));
}

export function sanitizeText(text: string, findings: PIIFinding[]): string {
  let result = text;
  for (const finding of [...findings].sort((a, b) => b.start - a.start)) result = result.slice(0, finding.start) + finding.suggestion + result.slice(finding.end);
  return result;
}

export function getPIISummary(findings: PIIFinding[]): string {
  if (findings.length === 0) return 'Nenhum dado sensível detectado.';
  return `Detectamos ${findings.length} dado(s) sensível(is): ${[...new Set(findings.map((finding) => finding.label))].join(', ')}.`;
}

function deduplicateFindings(findings: PIIFinding[]) {
  const result: PIIFinding[] = [];
  let lastEnd = -1;
  for (const finding of findings) if (finding.start >= lastEnd) { result.push(finding); lastEnd = finding.end; }
  return result;
}

exec
/bin/bash -lc "sed -n '330,410p' .husky/pre-commit && bash -n .husky/pre-commit" in /home/enio/egos
 succeeded in 0ms:
  fi
  exit 1
fi

# 2.5. TypeScript — Strict type check
echo "  [2.5/5] tsc: running strict type check..."
npx tsc --noEmit 2>/dev/null || bun run typecheck 2>/dev/null || {
  echo "❌ BLOCKED: TypeScript errors found. Fix before committing."
  exit 1
}

# 3. Frozen Zones — Check for unauthorized changes
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
FROZEN_VIOLATED=0

for frozen in \
  "agents/runtime/runner.ts" \
  "agents/runtime/event-bus.ts" \
  ".husky/pre-commit" \
  ".guarani/orchestration/PIPELINE.md" \
  ".guarani/orchestration/GATES.md"; do
  if echo "$STAGED" | grep -q "^${frozen}$"; then
    echo "  FROZEN ZONE: $frozen is staged for commit."
    echo "   This file requires explicit user approval + proof-of-work."
    FROZEN_VIOLATED=1
  fi
done

if [ "$FROZEN_VIOLATED" -eq 1 ]; then
  echo ""
  echo "❌ BLOCKED: Frozen zone files modified."
  echo "   To override: git commit --no-verify (requires proof-of-work in message)"
  exit 1
fi

# 3.5. Frozen-zone / governance commit AUTHORITY gate (hardened GUARANI-004 + HITL_CATALOG §5.1)
# Fail-closed-by-DEFAULT: a commit touching frozen zones / governance is blocked unless the window
# is a Prime session (Claude Code sets CLAUDECODE automatically) OR Enio sets an explicit human
# override. Guarani (Antigravity/Gemini) has no CLAUDECODE, so it is blocked WITHOUT relying on an
# honor-system env var. THREAT MODEL (Codex 2026-05-31): these are process env vars and therefore
# forgeable — this gate stops accidents/defaults and records intent, it is NOT tamper-proof authz.
# Real enforcement still rests on process discipline (Guarani never commits) + sole-committer Prime;
# a server-side pre-receive hook would be required for hard authz (not wired for this solo setup).
# 3.5b (INC-STAGED-HIJACK 2026-06-10, corte Enio "já faça"): scope WIDENED from
# GOV_FROZEN to ALL commits. Root cause: shared checkout + shared index — Guarani window
# committed cbb0006e and swept Prime's staged files into it (same class as d988385b).
# R10 says "Guarani proposes; Prime commits" but was will-only. This makes it a gate:
# ANY kernel commit requires a Prime window (CLAUDECODE) or explicit human override.
AUTHORIZED=0
WHO="unknown"
# Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
# Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
# Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
if [ "$AUTHORIZED" -ne 1 ]; then
  echo "❌ BLOCKED: kernel commits require a Prime window or explicit human override (R10)."
  if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
  echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
  echo "   Root cause INC-STAGED-HIJACK: shared index — a non-Prime commit sweeps the other window's staged files."
  echo "   Guarani/Antigravity: deixe o trabalho na working tree + FOR_PRIME_*.md; o Prime commita."
  echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
  exit 1
fi


# 4.1. Frozen Zone — .guarani/ must stay REAL files (anti-symlink-conversion guard)
# Root cause INC-SYMLINK-001 (2026-05-31, recurred same day): governance:sync:exec /
# ~/.egos/sync.sh converts kernel .guarani/ into symlinks to ~/.egos/guarani/. The kernel
# is the REAL source — symlink conversions must never be committed. Catches any window/script.
GUARANI_SYMLINKED=$(git diff --cached --raw 2>/dev/null | awk '$2=="120000" && /\.guarani\// {print $NF}' || true)
if [ -n "$GUARANI_SYMLINKED" ]; then
  if [ "${EGOS_ALLOW_GUARANI_SYMLINK:-0}" != "1" ]; then
    echo "❌ BLOCKED: .guarani/ files staged as SYMLINKS (kernel must be the real source)."
    echo "   Offending paths:"
    echo "$GUARANI_SYMLINKED" | sed 's/^/     - /'
    echo "   Cause: governance:sync:exec / ~/.egos/sync.sh converted kernel .guarani/ to symlinks."
    echo "   Fix:   git restore --staged .guarani/ && git checkout HEAD -- .guarani/"
    echo "   Override (intentional migration ONLY): EGOS_ALLOW_GUARANI_SYMLINK=1 git commit ..."
    exit 1

exec
/bin/bash -lc "python3 - <<'PY'
import datetime
print(datetime.datetime.utcfromtimestamp(1781100363))
PY
nl -ba docs/drafts/conselho1.md | sed -n '1,35p'" in /home/enio/egos
 succeeded in 0ms:
2026-06-10 14:06:03
<stdin>:2: DeprecationWarning: datetime.datetime.utcfromtimestamp() is deprecated and scheduled for removal in a future version. Use timezone-aware objects to represent datetimes in UTC: datetime.datetime.fromtimestamp(timestamp, datetime.UTC).
     1	agora veja a resposta do perplexity sobre o html: Hoje, para jun/2026, o desenho mais sólido é manter o WhatsApp como “casca” conversacional e orquestrar o máximo possível no backend, mas ainda assim **usar tela/app seguro para etapas de alto risco regulatório ou de segurança** (identidade ICP‑Brasil, assinatura, onboarding de pagamento), em linha com o que bancos e fintechs fazem no mundo. [leadersleague](https://www.leadersleague.com/en/news/whatsapp-payments-launches-in-brazil-with-nine-partner-banks)
     2	
     3	Abaixo organizei em dois blocos:  
     4	1) Resposta conceitual (WhatsApp vs tela segura, com exemplos reais)  
     5	2) Sugestão concreta de como reescrever e atualizar trechos do seu HTML.
     6	
     7	***
     8	
     9	## 1. WhatsApp como canal x tela segura
    10	
    11	### O que o WhatsApp aguenta fazer “sem sair da tela”
    12	
    13	Hoje o WhatsApp Business API/Cloud API suporta com segurança: [developers.facebook](https://developers.facebook.com/documentation/business-messaging/whatsapp/templates/authentication-templates/authentication-best-practices/)
    14	
    15	- Triagem, perguntas e coleta de dados cadastrais básicos (nome, tipo de certificado, e-mail, telefone).  
    16	- Consulta de status, reenvio de documentos já armazenados, reagendamentos, cancelamentos.  
    17	- Disparos transacionais (lembretes, confirmações, OTP) com criptografia de ponta a ponta entre usuário e servidores WhatsApp. [gov](https://www.gov.br/anpd/pt-br/assuntos/noticias/a-nova-politica-de-privacidade-do-whatsapp)
    18	- Pagamentos iniciados no próprio WhatsApp em modelos homologados (ex.: WhatsApp Pay e integrações com Pix), em que o app faz a camada de segurança e tokenização junto ao arranjo de pagamento parceiro. [americasmi](https://americasmi.com/insights/whatsapp-payments-in-brazil-nothing-to-panic-about/)
    19	
    20	Boa parte da automação que você descreve (triagem, checagem de pendências, agendamento de videoconferência, acompanhamento do pedido) continua perfeitamente coerente em 2026. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
    21	
    22	### Onde a tela segura continua fazendo sentido
    23	
    24	Mesmo com a evolução do WhatsApp, três tipos de etapa continuam sendo tipicamente movidas para um ambiente próprio (web/app) pelas empresas mais maduras: [blog.dito.com](https://blog.dito.com.br/lgpd-e-whatsapp/)
    25	
    26	- **1. Upload de documentos “juridicamente sensíveis”**  
    27	  - Documentos que vão para dossiê regulado (ICP‑Brasil, KYC mais pesado, processos jurídicos).  
    28	  - Motivo: precisa de política de retenção própria, logs de acesso, controles finos de quem pode ver; você não controla a infraestrutura do WhatsApp nem o armazenamento do lado do usuário. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/iti-na-midia/icp-brasil-e-o-cenario-da-lgpd)
    29	
    30	- **2. Assinatura digital qualificada ou atos regulados (ICP‑Brasil)**  
    31	  - A validação de identidade para emissão de certificado digital continua sendo atividade regulada, conduzida por Agente de Registro autorizado e seguindo DOC‑ICP‑05.x, Resolução 170/2020 e normas posteriores. [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/publicada-instrucao-normativa-que-regulamenta-a-emissao-de-certificado-digital-por-videoconferencia)
    32	  - As novas IN ITI nº 36 e 37/2026 reforçam requisitos pesados de biometria, liveness, proteção contra deepfake e trilha de auditoria, inclusive na “AR Eletrônica”. [cryptoid.com](https://cryptoid.com.br/criptografia-identificacao-digital-id-biometria/iti-publica-as-normas-mais-abrangentes-da-historia-da-icp-brasil-para-identificacao-de-titulares-de-certificados-digitais/)
    33	  - Ou seja, o que você já diz no HTML (“o agente IA não substitui a etapa regulada”) continua 100% correto, e o ambiente dessa videoconferência/assinatura deve atender requisitos técnicos específicos além do canal de chat. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
    34	
    35	- **3. Entrada de dados de cartão ou onboarding de Pix/Open Finance fora dos modelos nativos do WhatsApp**  

exec
/bin/bash -lc "sed -n '1,120p' packages/guard-brasil/src/index.ts; sed -n '1,120p' packages/guard-brasil/src/lib/index.ts; tail -n 80 packages/guard-brasil/src/pii-patterns.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * @egos/guard-brasil — Brazilian AI Safety Layer
 *
 * A compliance and trust layer for AI assistants operating in Brazilian
 * public-sector and enterprise contexts. Provides:
 *
 *   - ATRiAN ethical validation (absolute claims, false promises, fabricated data)
 *   - PII Scanner BR (CPF, RG, MASP, REDS, processo, placa, nome)
 *   - Public Guard — LGPD-compliant output masking
 *   - Evidence Chain — traceable response discipline
 *   - GuardBrasil facade — unified one-call API
 *
 * Compliance: Lei 13.709/2018 (LGPD)
 *
 * @example
 * ```ts
 * import { GuardBrasil } from '@egos/guard-brasil';
 *
 * const guard = GuardBrasil.create();
 * const result = await guard.inspect(llmResponse);
 * if (!result.safe) console.log(result.masked);
 * ```
 */

export { GuardBrasil, createGuardBrasil } from './guard.js';
export type { GuardBrasilConfig, GuardBrasilResult, InspectOptions } from './guard.js';

// Re-export individual modules for fine-grained usage
export { createAtrianValidator } from './lib/index.js';
export type { AtrianConfig, AtrianResult, AtrianViolation, ViolationLevel } from './lib/index.js';

export { scanForPII, sanitizeText, getPIISummary } from './lib/index.js';
export type { PIICategory, PIIFinding, PIIPatternDefinition } from './lib/index.js';

export { maskPublicOutput, isPublicSafe, buildLGPDDisclosure } from './lib/index.js';
export type { PublicGuardConfig, MaskingResult, MaskingAction, GuardAction, SensitivityLevel } from './lib/index.js';

export { createEvidenceChain, EvidenceChainBuilder, formatEvidenceBlock, validateChain } from './lib/index.js';
export type { EvidenceChain, EvidenceItem, ClaimWithEvidence, EvidenceType, ConfidenceLevel, EvidenceChainOptions } from './lib/index.js';

export { buildAuditFields, canonicalRowJson, rawRowHash, sha256Text, sourceFingerprint } from './lib/index.js';
export type { AuditFields } from './lib/index.js';

// Centralized PII patterns — shared constants + detect/mask API
export { detectPII, maskPII, getPatternById, ALL_PII_PATTERNS } from './pii-patterns.js';
export {
  CPF_PATTERN, CNPJ_PATTERN, RG_PATTERN, CNH_PATTERN,
  MASP_PATTERN, REDS_PATTERN, PROCESSO_PATTERN,
  PLACA_ANTIGA_PATTERN, PLACA_MERCOSUL_PATTERN,
  TELEFONE_PATTERN, EMAIL_PATTERN, CEP_PATTERN,
} from './pii-patterns.js';
export type { PIIPatternId, PatternConfidence, PIIPatternConfig, PIIMatch, MaskMode } from './pii-patterns.js';

// Reversible tokenized redaction (EGOS-160)
export { tokenize, restore, hasTokens } from './lib/tokenizer.js';
export type { TokenVault, TokenizedResult } from './lib/tokenizer.js';
/**
 * Internal barrel — re-exports all Guard Brasil modules.
 * These are inlined copies of @egos/shared modules for standalone distribution.
 */

export { createAtrianValidator } from './atrian.js';
export type { AtrianConfig, AtrianResult, AtrianViolation, ViolationLevel } from './atrian.js';

export { scanForPII, sanitizeText, getPIISummary } from './pii-scanner.js';
export type { PIICategory, PIIFinding, PIIPatternDefinition } from './pii-scanner.js';

export { maskPublicOutput, isPublicSafe, buildLGPDDisclosure } from './public-guard.js';
export type { PublicGuardConfig, MaskingResult, MaskingAction, GuardAction, SensitivityLevel } from './public-guard.js';

export { createEvidenceChain, EvidenceChainBuilder, formatEvidenceBlock, validateChain } from './evidence-chain.js';
export type { EvidenceChain, EvidenceItem, ClaimWithEvidence, EvidenceType, ConfidenceLevel, EvidenceChainOptions } from './evidence-chain.js';

export { buildAuditFields, canonicalRowJson, rawRowHash, sha256Text, sourceFingerprint } from './provenance.js';
export type { AuditFields } from './provenance.js';
 * ```ts
 * const matches = detectPII('CPF do titular: 123.456.789-00');
 * // [{ patternId: 'cpf', matched: '123.456.789-00', ... }]
 * ```
 */
export function detectPII(
  text: string,
  patterns: readonly PIIPatternConfig[] = ALL_PII_PATTERNS,
): PIIMatch[] {
  const matches: PIIMatch[] = [];

  for (const config of patterns) {
    const re = cloneRegex(config.regex);
    let execResult: RegExpExecArray | null;

    while ((execResult = re.exec(text)) !== null) {
      matches.push({
        patternId: config.id,
        label: config.label,
        matched: execResult[0],
        start: execResult.index,
        end: execResult.index + execResult[0].length,
        confidence: config.confidence,
        maskFormat: config.maskFormat,
      });
    }
  }

  return deduplicateMatches(matches);
}

/**
 * Masks all detected PII in the text, replacing matches with their mask format.
 *
 * @param text — The text to mask
 * @param patternIds — Optional list of pattern IDs to mask (defaults to all).
 *                     Pass e.g. `['cpf', 'cnpj']` to only mask those types.
 * @returns The masked text with PII replaced by mask labels
 *
 * @example
 * ```ts
 * maskPII('CPF: 123.456.789-00, email: fulano@email.com');
 * // 'CPF: [CPF REMOVIDO], email: [EMAIL REMOVIDO]'
 *
 * maskPII('CPF: 123.456.789-00, email: fulano@email.com', ['cpf']);
 * // 'CPF: [CPF REMOVIDO], email: fulano@email.com'
 * ```
 */
export function maskPII(text: string, patternIds?: PIIPatternId[], mode: MaskMode = 'full'): string {
  const patterns = patternIds
    ? ALL_PII_PATTERNS.filter(p => patternIds.includes(p.id))
    : ALL_PII_PATTERNS;

  const matches = detectPII(text, patterns);

  if (matches.length === 0) return text;

  // Replace from end to start so indices stay valid
  let result = text;
  const reversed = matches.slice().sort((a, b) => b.start - a.start);
  for (const match of reversed) {
    let replacement: string;
    if (mode === 'partial') {
      const config = ALL_PII_PATTERNS.find(p => p.id === match.patternId);
      replacement = config?.partialMaskFn?.(match.matched) ?? match.maskFormat;
    } else {
      replacement = match.maskFormat;
    }
    result = result.slice(0, match.start) + replacement + result.slice(match.end);
  }

  return result;
}

/**
 * Returns a pattern config by its ID, or undefined if not found.
 */
export function getPatternById(id: PIIPatternId): PIIPatternConfig | undefined {
  return ALL_PII_PATTERNS.find(p => p.id === id);
}

exec
/bin/bash -lc 'bun run typecheck' in /home/enio/egos
 succeeded in 10007ms:
exec
/bin/bash -lc 'git diff eb3edd983411d6e230148496c4f4b07426063221 -- docs/jobs/2026-06-10-pre-commit-pipeline.json docs/jobs/2026-06-10-doc-drift-verifier.json docs/knowledge/HARVEST.md' in /home/enio/egos
 succeeded in 0ms:
diff --git a/docs/jobs/2026-06-10-doc-drift-verifier.json b/docs/jobs/2026-06-10-doc-drift-verifier.json
index 0dd6c1c7..b39c5e51 100644
--- a/docs/jobs/2026-06-10-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-10-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-10T11:31:40.007Z",
+  "verified_at": "2026-06-10T12:06:39.878Z",
   "summary": {
     "total_claims": 17,
     "passed": 17,
@@ -83,7 +83,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1369",
+      "current_value": "1379",
       "tolerance": "min:50",
       "command": "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'",
       "severity": "ok"
diff --git a/docs/jobs/2026-06-10-pre-commit-pipeline.json b/docs/jobs/2026-06-10-pre-commit-pipeline.json
index 4fed15d9..1d874cc3 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -238,5 +238,61 @@
     "duration_ms": null,
     "event": "commit:fix files=6 sha=749d8d59",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:06:41.638Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=41 sha=c80c2fa9",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T12:56:17.090Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=3 sha=807ad918",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:07:01.640Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=cbb0006e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:13:39.265Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=4a44ae1b",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:19:55.220Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=eb3edd98",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T13:34:56.370Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=2 sha=b5b6cf57",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-10T14:01:11.829Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=b9b56fb8",
+    "repo": "/home/enio/egos"
   }
 ]
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index 5b2c4f56..297c304d 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -6081,3 +6081,7 @@ Nunca competir por commits. O Guarani propõe patches e rascunha as análises de
 ### Auto-harvested — 9af71508 (2026-06-09)
 
 - model-ID hardcoded em 20+ arquivos = sem fonte única; candidato a MODEL_CONFIG central (liga Patch 3 papel→modelo).
+
+### INC-STAGED-HIJACK (2026-06-10)
+
+Checkout + index compartilhados entre janelas: o commit cbb0006e (Guarani) varreu 91 inserts staged do Prime (mesma classe d988385b). R10 "Guarani propõe, Prime commita" era vontade — virou gate: pre-commit §3.5b bloqueia QUALQUER commit no kernel sem CLAUDECODE (Prime) ou EGOS_FROZEN_OVERRIDE=1 (humano). Smoke: janela guarani → BLOCKED. Higiene complementar do Prime: nunca deixar arquivos staged aguardando enquanto background roda — stage só na hora do commit.

exec
/bin/bash -lc "grep -R \"AWSAccessKeyId\\|x-amz-security-token\\|Signature=\" -n docs/drafts/conselho1.md docs/presentations/mf-certificados-piloto.html || true" in /home/enio/egos
 succeeded in 0ms:
docs/drafts/conselho1.md:20:Boa parte da automação que você descreve (triagem, checagem de pendências, agendamento de videoconferência, acompanhamento do pedido) continua perfeitamente coerente em 2026. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
docs/drafts/conselho1.md:33:  - Ou seja, o que você já diz no HTML (“o agente IA não substitui a etapa regulada”) continua 100% correto, e o ambiente dessa videoconferência/assinatura deve atender requisitos técnicos específicos além do canal de chat. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
docs/drafts/conselho1.md:49:- Diferenciar Cenário A (CPF indo ao LLM) e Cenário B (pseudonimização no gateway) é uma forma tecnicamente defensável de discutir risco x esforço. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
docs/drafts/conselho1.md:100:Hoje você já diz que o padrão é “WhatsApp inicia/acompanhando e tela segura para upload/assinatura”. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
docs/drafts/conselho1.md:139:Sua seção de “Contexto do setor” já fala de crescimento, participação PF/PJ e mudança regulatória do e‑CNPJ para selo eletrônico. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)

exec
/bin/bash -lc 'bun run lint' in /home/enio/egos
 exited 2 in 197ms:

Oops! Something went wrong! :(

ESLint: 10.3.0

ESLint couldn't find an eslint.config.(js|mjs|cjs) file.

From ESLint v9.0.0, the default configuration file is now eslint.config.js.
If you are using a .eslintrc.* file, please follow the migration guide
to update your configuration file to the new format:

https://eslint.org/docs/latest/use/configure/migration-guide

If you still have problems after following the migration guide, please stop by
https://eslint.org/chat/help to chat with the team.


codex
The patch introduces credential-bearing presigned S3 URLs into a committed markdown draft. This is a security issue that should be fixed before the change is considered correct.

Review comment:

- [P1] Remove signed S3 URLs from the draft — /home/enio/egos/docs/drafts/conselho1.md:20-20
  This new draft commits a presigned `ppl-ai-file-upload.s3.amazonaws.com` URL containing `AWSAccessKeyId`, `Signature`, and `x-amz-security-token` query parameters; the same credential-bearing URL is repeated later in the file. Even if the token is temporary, putting it in git history exposes access to the uploaded document until expiry and violates the repo’s no-secrets rule, so replace these with a plain source reference or a redacted URL before merging.
The patch introduces credential-bearing presigned S3 URLs into a committed markdown draft. This is a security issue that should be fixed before the change is considered correct.

Review comment:

- [P1] Remove signed S3 URLs from the draft — /home/enio/egos/docs/drafts/conselho1.md:20-20
  This new draft commits a presigned `ppl-ai-file-upload.s3.amazonaws.com` URL containing `AWSAccessKeyId`, `Signature`, and `x-amz-security-token` query parameters; the same credential-bearing URL is repeated later in the file. Even if the token is temporary, putting it in git history exposes access to the uploaded document until expiry and violates the repo’s no-secrets rule, so replace these with a plain source reference or a redacted URL before merging.
```
