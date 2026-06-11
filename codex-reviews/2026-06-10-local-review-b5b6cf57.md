# Codex Local Review — 2026-06-10T13:35:05Z

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
session id: 019eb1be-68c0-7322-b0ae-c70c532b8371
--------
user
changes against 'HEAD~3'
2026-06-10T13:35:07.322522Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T13:35:07.323202Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 4a44ae1bbfd0a4097dd715ded5349048434a4b19 --stat && git diff 4a44ae1bbfd0a4097dd715ded5349048434a4b19' in /home/enio/egos
 succeeded in 0ms:
 .husky/pre-commit                                  |  41 ++--
 AGENTS.md                                          |   2 +-
 apps/egos-landing/public/timeline/rss              |   2 +-
 apps/egos-landing/public/timeline/rss.xml          |   2 +-
 docs/drafts/conselho1.md                           | 259 +++++++++++++++++++++
 docs/jobs/2026-06-10-doc-drift-verifier.json       |   4 +-
 docs/jobs/2026-06-10-pre-commit-pipeline.json      |  48 ++++
 docs/knowledge/HARVEST.md                          |   4 +
 .../CURSO_CIBER_IA_LGPD_notebooklm.md              |   6 +-
 docs/presentations/mf-certificados-piloto.html     |  99 ++++++--
 10 files changed, 426 insertions(+), 41 deletions(-)
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
index 4fed15d9..4258afb7 100644
--- a/docs/jobs/2026-06-10-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-10-pre-commit-pipeline.json
@@ -238,5 +238,53 @@
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
diff --git a/docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md b/docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md
index 067cd249..ffe86ad2 100644
--- a/docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md
+++ b/docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md
@@ -1,7 +1,7 @@
 # Curso "Ciber + IA + LGPD para a investigação" — fonte para NotebookLM
 
 > **Evento:** curso/formação (magistério — vetor seguro, estatuto PCMG ativo · consulta Corregedoria)
-> **Versão:** v1.1 — 2026-06-02 · **Situação:** posições preenchidas (corte do Enio aplicado nos slides 5/8/11); gerar deck p/ revisão de copy
+> **Versão:** v1.2 — 2026-06-10 · **Situação:** auditada Banda Cognitiva — Slide 6 ATRiAN corrigido (telemetria, não "valida promessa"), Slide 10 Whisper marcado como referência conceitual. Labs 4+5 alinhados ao caso-alfa-sintetico.md.
 > **Geração:** NotebookLM Studio gera os slides a partir desta fonte.
 > **Regra:** este arquivo é SSOT da apresentação — qualquer versão antiga vai para `_drafts/`.
 > **Origem do conteúdo:** `docs/strategy/COURSES_FRAMEWORK_GOV_THESIS.md` (outline COURSE-MAP-001, 8 módulos) + `docs/cybersecurity/learning-roadmap.md` + artefatos reais do repositório EGOS.
@@ -56,7 +56,7 @@ A investigação está num **regime especial** da LGPD (segurança pública): is
 - Conteúdo legal completo: `docs/cybersecurity/lgpd-investigacao.md` (Art. 4º III/§1º, Art. 6º, Art. 20). Redação/ANPD a conferir; interpretação final = instrutor.
 
 ## Slide 6 — Guard Brasil: proteção na prática (laboratório)
-Como funciona, com texto **sintético** (nunca caso real): o sistema detecta e mascara o dado, valida a saída da IA contra promessa falsa (ATRiAN), e anexa **prova** a cada afirmação (cadeia de evidência: hash + fonte). (base real: `guard.ts`, Conector de Ferramentas validado ao vivo)
+Como funciona, com texto **sintético** (nunca caso real): o sistema detecta e mascara o dado (PII scanner com padrões brasileiros: MASP, REDS, CPF), registra telemetria ética (ATRiAN — camada de observabilidade), e anexa **prova** a cada saída (cadeia de evidência: hash SHA-256 + fonte). (base real: `packages/guard-brasil/src/guard.ts` — executável no repo EGOS)
 
 ## Slide 7 — Soberania: rodar o modelo próprio
 A instituição roda o **seu** modelo, localmente — o dado não viaja. Custo total ao longo do tempo de uma máquina local vs. mandar tudo para fora. (base real: `docs/strategy/MAC_STUDIO_LOCAL_AI.md` — modelo local + Guard Brasil local)
@@ -72,7 +72,7 @@ A instituição roda o **seu** modelo, localmente — o dado não viaja. Custo t
 Toda saída da IA vira documento defensável: cadeia de custódia digital (hash), aviso de tratamento LGPD, registro de auditoria. O que o curso ensina a proteger é o próprio exemplo do método. (base real: `evidence-chain.ts`)
 
 ## Slide 10 — IA no fluxo de investigação (OVM)
-A IA encaixada no fluxo real em fases (do cartório à delegacia), com transcrição **local** (Whisper) e regras de sigilo embutidas — sempre com exemplo **sintético**, nunca caso real.
+A IA encaixada no fluxo real em fases (do cartório à delegacia), com transcrição **local** (ex: Whisper open-source — referência conceitual; instalação independente necessária) e regras de sigilo embutidas — sempre com exemplo **sintético**, nunca caso real.
 - Lab pronto: `docs/cybersecurity/caso-alfa-sintetico.md` (caso 100% fictício + 5 laboratórios). Nunca caso real.
 
 ## Slide 11 — A tese vira política: ensinar → provar → propor
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index 7177c132..e2833546 100644
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
@@ -269,6 +269,7 @@ tr:hover td { background: var(--bg); }
   <a class="sidebar-link" href="#o-que-nao">O que NÃO inclui</a>
   <a class="sidebar-link" href="#proximos">Próximos passos</a>
   <a class="sidebar-link" href="#materiais">🎧 Materiais (áudio)</a>
+  <a class="sidebar-link" href="#fontes">Fontes</a>
 </nav>
 
 <!-- MAIN -->
@@ -412,11 +413,11 @@ tr:hover td { background: var(--bg); }
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
@@ -459,7 +460,31 @@ tr:hover td { background: var(--bg); }
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
@@ -533,7 +558,7 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
         <strong>Contexto real (jun/2026)</strong>
-        Na prática de jun/2026, grandes empresas e órgãos governamentais brasileiros já delegam funções e passam dados reais para modelos de LLM. O LGPD existe, mas tem enforcement limitado — a maioria das organizações opera com base em políticas internas e termos de uso dos provedores, não em mascaramento técnico. Apresentamos os dois caminhos com custo e benefício honesto.
+        O CPF é dado pessoal — não é dado sensível por si só, mas deve ser minimizado, protegido, tratado com base legal documentada e evitado em logs e modelos sempre que possível. Apresentamos dois caminhos com custo e benefício honesto. A escolha define a arquitetura do piloto desde a semana 1.
       </div>
     </div>
 
@@ -599,7 +624,7 @@ tr:hover td { background: var(--bg); }
       <span class="callout-icon">⚡</span>
       <div class="callout-body">
         <strong>Decisão incluída nas 3 perguntas ao Miguel</strong>
-        Qual cenário você prefere e com qual justificativa? A resposta define a arquitetura do piloto na semana 1. Sem essa decisão, implementamos o Cenário A (padrão, custo zero) e migramos para B se necessário.
+        Qual cenário você prefere e com qual justificativa? A resposta define a arquitetura do piloto na semana 1. <strong>Nossa recomendação padrão é o Cenário B (pseudonimização)</strong> — o CPF nunca chega ao modelo, os logs são limpos e a posição é defensável em qualquer auditoria LGPD. O custo é +2 semanas de engenharia no início. O Cenário A é válido para operações internas com equipe treinada e DPA assinado com o provedor; a MF escolhe.
       </div>
     </div>
   </div>
@@ -630,15 +655,25 @@ tr:hover td { background: var(--bg); }
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
@@ -650,7 +685,7 @@ tr:hover td { background: var(--bg); }
     <div class="callout callout-blue" style="margin-top:16px">
       <span class="callout-icon">ℹ️</span>
       <div class="callout-body">
-        A MF Certificados já tem obrigação LGPD pela atividade de AR/AC. O agente WhatsApp não cria novas obrigações — apenas automatiza um canal que já existe. O ponto crítico é garantir que o aviso de atendimento automatizado esteja presente.
+        A MF Certificados já tem obrigação LGPD pela atividade de AR/AC. O agente WhatsApp não cria novas obrigações — apenas automatiza um canal que já existe. Ponto importante: <strong>usar o WhatsApp como canal não transfere a responsabilidade pelo tratamento de dados — a MF Certificados permanece controladora</strong> e responde pelos dados tratados via esse canal perante a ANPD e os titulares. O WhatsApp (Meta) atua como operador/plataforma de terceiro, e isso deve estar refletido na Política de Privacidade da empresa.
       </div>
     </div>
   </div>
@@ -786,12 +821,28 @@ tr:hover td { background: var(--bg); }
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
@@ -932,11 +983,33 @@ tr:hover td { background: var(--bg); }
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
 

exec
/bin/bash -lc "nl -ba docs/drafts/conselho1.md | sed -n '1,80p'
nl -ba .husky/pre-commit | sed -n '350,410p'
python3 - <<'PY'
from pathlib import Path
for p in ['docs/drafts/conselho1.md']:
    for i,l in enumerate(Path(p).read_text().splitlines(),1):
        if 'AWSAccessKeyId' in l or 'x-amz-security-token' in l:
            print(i, l[:220])
PY" in /home/enio/egos
 succeeded in 0ms:
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
    36	  - Quando você usa WhatsApp Pay ou integrações Pix “oficiais”, a autenticação forte e a tokenização são tratadas pelo próprio WhatsApp + arranjo de pagamento (ex.: Visa/Mastercard, bancos parceiros). [leadersleague](https://www.leadersleague.com/en/news/whatsapp-payments-launches-in-brazil-with-nine-partner-banks)
    37	  - Mas, para fluxos próprios (cartão num gateway, tela de gestão de faturas, autenticação forte por Open Finance), os bancos e fintechs ainda redirecionam para app/site com sessão autenticada e MFA; a conversa no WhatsApp vira só “casca” de notificação/orquestração. [linkedin](https://www.linkedin.com/pulse/whatsapps-unexpected-journey-brazil-pix-marcel-van-oost-mi2bf)
    38	
    39	Além disso, há um ponto prático de segurança ofensiva: campanhas de malware via WhatsApp Web mirando clientes bancários brasileiros continuam aparecendo, inclusive com trojans que roubam sessão ou monitoram navegação de internet banking. [sophos](https://www.sophos.com/en-us/blog/whatsapp-worm-targets-brazilian-banking-customers)
    40	Isso não desabona o uso do WhatsApp como canal, mas **reforça a ideia de limitar ali o que é estritamente necessário** e deixar o resto em uma superfície sob seu controle.
    41	
    42	***
    43	
    44	## 2. LGPD + WhatsApp em 2026 (ajustes de narrativa)
    45	
    46	### O que continua correto no seu texto
    47	
    48	- Base legal como “execução de contrato” para tratar CPF e dados necessários à emissão do certificado continua alinhada com LGPD (art. 7). [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/iti-na-midia/icp-brasil-e-o-cenario-da-lgpd)
    49	- Diferenciar Cenário A (CPF indo ao LLM) e Cenário B (pseudonimização no gateway) é uma forma tecnicamente defensável de discutir risco x esforço. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/086c9ca0-c6a4-4224-9d32-d9bf3a39426d/mf-certificados-piloto.html?AWSAccessKeyId=ASIA2F3EMEYEWP7EZYD4&Signature=8P7eATTbymoROMf5u4%2FTJKzujWg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEB4aCXVzLWVhc3QtMSJIMEYCIQC1K3WQm99XGlRzpNYobfNcU0NbJ61J4YAV6BnURHTMTwIhAOHSWduDI38fOUnadIaBVws%2F%2FNH7uORla2H%2Boh98hg5mKvwECOb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igx5rlGkmXC9myFlQH4q0AQF0J%2FMsuauJwfRi03H%2BTSADj9L5SRF9zOXK%2FIPz8GGQjULTaHMrgXpvPTt9YAev6xl5zXM%2BqWlL%2FHaYqgbFVEAnrCVqfDVDmCafDRxgPdrhaAROrNYYbffM4h4McJyUt4708qFRgzgL5pfeT0ClrWyyd3wVpJnKmVZqZb31rmGGQvbdltrvHZdFenF1pHWAgmYInaGGoLCFZcz14r%2Fvqh6KtSar9t7E0Aj1%2BcNdpCzfQhjxyDJvj%2FTwbIFBztDpMVTfJhsmEOext%2BG24hRp%2BuCNgVRvvrVbNwXusfsuacgL%2BqSYZqkJnuO9RffUd5lcC9j8HME%2B0pl2cBOsHbmvnjesbsHuTnSUVWs0hmfRJgZSFpJcC1%2FeQlZ7J5l9088sgP8SNlXGMn8jsCue5BGavc%2Fi9aBEnl3MJnuj%2FBb0MvToEQPOWN8892XjhE5mE1Rotv%2Bk8r%2FEZFd%2B6l6zZWISSKUxbNx3DUkhubbnVqvj4AenHTKNZE4Wr0D9UQwpNrBr%2Fx%2FiWctp0ziiN97AWHX4HJmL%2BztpHZbqmCn%2B6Ta4RQlAFhvU6lFQkHXu8M5OTGLQQuBYKnoz7VhR9UzhaRPDuahaAZKFeW%2FMbuw%2Ff8AhaND6MYg8tiMg%2F12YcK7R4Nm5QXilQTE0Fmwt9jgPZ%2BqNa8ABLGW%2B7FpQyPFtnmWV%2BI5GL3Hd1mFVttLA4VKm9Y6SOj14bRFiyueBMi6OKkxx%2FBVaEcEUQ%2BnWzsS23UZXcUcV69hMvisRjHfDCpELOLSPOFbJFiR4k%2F7nBg2ilzzBP0tMPjCpdEGOpcBmUmIxKorG8Z%2F0pnOo9L1%2Bo2nLkTNYfJnaovYt4ZtkBjPeGTo9haPz9KKJvLKFSINxjbiysukjQrnJY1Vv6%2F494IlR6vleFeEBP9ykDszaE4hGzh8SjQV017STaA1aOlXrU48JzlR3oOXTGinHvQja%2B4P4KDAyDAtifxOYVJCNHsFr4TafkRxTm7Q9nJsZHTPrGaa5BGzmg%3D%3D&Expires=1781100363)
    50	- Deixar a decisão clara para o cliente (e registrar essa decisão) é bom design de governança.
    51	
    52	### O que vale atualizar na redação
    53	
    54	1) **ANPD já não é mais só um “enforcer fraco”**  
    55	Desde 2021 a ANPD vem apertando a supervisão de WhatsApp, inclusive com recomendações específicas sobre a política de privacidade do app e orientações sobre direitos dos titulares. [seguranca.tic.ufrj](https://seguranca.tic.ufrj.br/dicas/anpd-divulga-documento-com-informacoes-e-orientacoes-aos-usuarios-a-respeito-da-nova-politica-de-privacidade-do-whatsapp/)
    56	Em 2024 saiu, por exemplo, o Guia Orientativo sobre atuação do encarregado (DPO), reforçando boas práticas, logs e comunicação estruturada com titulares. [trenchrossi](https://www.trenchrossi.com/alertas-legais/anpd-publica-guia-orientativo-da-atuacao-do-encarregado-de-dados-pessoais/)
    57	
    58	Então, ao invés de dizer apenas que “o LGPD existe, mas o enforcement é limitado”, eu sugeriria algo como:
    59	
    60	> “A LGPD está em vigor desde 2020, e a ANPD vem aumentando gradualmente a fiscalização, especialmente em grandes plataformas como o WhatsApp. Na prática, empresas que usam WhatsApp em atendimento precisam combinar base legal clara (execução de contrato ou consentimento, conforme o caso) com políticas de privacidade acessíveis, registro do opt‑in e canal para exercício de direitos dos titulares.”
    61	
    62	2) **Usar a linha de ‘WhatsApp como operador/plataforma de terceiro’**  
    63	Há vários materiais jurídicos lembrando que, embora o WhatsApp seja um terceiro, isso não tira a responsabilidade do controlador (sua empresa) quanto ao tratamento feito ali, inclusive no canal de atendimento. [zapper](https://zapper.to/en/blog/seu-whatsapp-corporativo-atende-a-lgpd)
    64	No seu HTML, você pode deixar explícito:
    65	
    66	> “Usar o WhatsApp não elimina a responsabilidade da MF como controladora de dados. O canal precisa estar integrado à Política de Privacidade da empresa (link na primeira mensagem) e registrar o consentimento quando a base legal for consentimento — por exemplo, uso posterior dos dados para marketing.”
    67	
    68	3) **Novidades específicas de WhatsApp em 2026 que impactam a arquitetura**
    69	
    70	Em 2026, o WhatsApp começa a introduzir **usernames** e o conceito de **Business Scoped User ID (BSUID)** — um identificador opaco por negócio, que pode substituir o telefone como chave primária. [ezcontact](https://ezcontact.ai/en/blog/whatsapp-api-updates-2026/)
    71	
    72	Isso impacta seu backend e o texto pode sugerir boas práticas:
    73	
    74	> “O sistema armazena, além do telefone, o BSUID fornecido pelo WhatsApp para cada contato. Isso evita depender só do número de telefone, melhora a privacidade do usuário e acompanha a evolução da plataforma.”
    75	
    76	***
    77	
    78	## 3. ICP‑Brasil em 2026: reforçando sua “honestidade regulatória”
    79	
    80	Seu trecho de “Honestidade regulatória — ICP‑Brasil” está conceitualmente alinhado com o cenário atual, mas dá para deixá‑lo mais robusto citando explicitamente que: [gov](https://www.gov.br/iti/pt-br/assuntos/noticias/indice-de-noticias/publicada-instrucao-normativa-que-regulamenta-a-emissao-de-certificado-digital-por-videoconferencia)
   350	  ".guarani/orchestration/GATES.md"; do
   351	  if echo "$STAGED" | grep -q "^${frozen}$"; then
   352	    echo "  FROZEN ZONE: $frozen is staged for commit."
   353	    echo "   This file requires explicit user approval + proof-of-work."
   354	    FROZEN_VIOLATED=1
   355	  fi
   356	done
   357	
   358	if [ "$FROZEN_VIOLATED" -eq 1 ]; then
   359	  echo ""
   360	  echo "❌ BLOCKED: Frozen zone files modified."
   361	  echo "   To override: git commit --no-verify (requires proof-of-work in message)"
   362	  exit 1
   363	fi
   364	
   365	# 3.5. Frozen-zone / governance commit AUTHORITY gate (hardened GUARANI-004 + HITL_CATALOG §5.1)
   366	# Fail-closed-by-DEFAULT: a commit touching frozen zones / governance is blocked unless the window
   367	# is a Prime session (Claude Code sets CLAUDECODE automatically) OR Enio sets an explicit human
   368	# override. Guarani (Antigravity/Gemini) has no CLAUDECODE, so it is blocked WITHOUT relying on an
   369	# honor-system env var. THREAT MODEL (Codex 2026-05-31): these are process env vars and therefore
   370	# forgeable — this gate stops accidents/defaults and records intent, it is NOT tamper-proof authz.
   371	# Real enforcement still rests on process discipline (Guarani never commits) + sole-committer Prime;
   372	# a server-side pre-receive hook would be required for hard authz (not wired for this solo setup).
   373	# 3.5b (INC-STAGED-HIJACK 2026-06-10, corte Enio "já faça"): scope WIDENED from
   374	# GOV_FROZEN to ALL commits. Root cause: shared checkout + shared index — Guarani window
   375	# committed cbb0006e and swept Prime's staged files into it (same class as d988385b).
   376	# R10 says "Guarani proposes; Prime commits" but was will-only. This makes it a gate:
   377	# ANY kernel commit requires a Prime window (CLAUDECODE) or explicit human override.
   378	AUTHORIZED=0
   379	WHO="unknown"
   380	# Signal 1: explicit human override (Enio at a plain terminal — HITL authority)
   381	if [ "${EGOS_FROZEN_OVERRIDE:-0}" = "1" ]; then AUTHORIZED=1; WHO="human-override"; fi
   382	# Signal 2: verified Prime window — Claude Code sets CLAUDECODE automatically
   383	if [ -n "${CLAUDECODE:-}" ] && [ "${EGOS_WINDOW_OWNER:-egos-prime}" != "guarani" ]; then AUTHORIZED=1; WHO="egos-prime"; fi
   384	# Signal 3 (belt-and-suspenders): a window that declares itself guarani is never authorized here
   385	if echo "${EGOS_WINDOW_OWNER:-}" | grep -qEi "^guarani"; then AUTHORIZED=0; WHO="guarani"; fi
   386	if [ "$AUTHORIZED" -ne 1 ]; then
   387	  echo "❌ BLOCKED: kernel commits require a Prime window or explicit human override (R10)."
   388	  if [ -n "${CLAUDECODE:-}" ]; then CC_STATE=set; else CC_STATE=unset; fi
   389	  echo "   Detected owner: $WHO | CLAUDECODE=$CC_STATE"
   390	  echo "   Root cause INC-STAGED-HIJACK: shared index — a non-Prime commit sweeps the other window's staged files."
   391	  echo "   Guarani/Antigravity: deixe o trabalho na working tree + FOR_PRIME_*.md; o Prime commita."
   392	  echo "   Human override (Enio only): EGOS_FROZEN_OVERRIDE=1 git commit ..."
   393	  exit 1
   394	fi
   395	
   396	
   397	# 4.1. Frozen Zone — .guarani/ must stay REAL files (anti-symlink-conversion guard)
   398	# Root cause INC-SYMLINK-001 (2026-05-31, recurred same day): governance:sync:exec /
   399	# ~/.egos/sync.sh converts kernel .guarani/ into symlinks to ~/.egos/guarani/. The kernel
   400	# is the REAL source — symlink conversions must never be committed. Catches any window/script.
   401	GUARANI_SYMLINKED=$(git diff --cached --raw 2>/dev/null | awk '$2=="120000" && /\.guarani\// {print $NF}' || true)
   402	if [ -n "$GUARANI_SYMLINKED" ]; then
   403	  if [ "${EGOS_ALLOW_GUARANI_SYMLINK:-0}" != "1" ]; then
   404	    echo "❌ BLOCKED: .guarani/ files staged as SYMLINKS (kernel must be the real source)."
   405	    echo "   Offending paths:"
   406	    echo "$GUARANI_SYMLINKED" | sed 's/^/     - /'
   407	    echo "   Cause: governance:sync:exec / ~/.egos/sync.sh converted kernel .guarani/ to symlinks."
   408	    echo "   Fix:   git restore --staged .guarani/ && git checkout HEAD -- .guarani/"
   409	    echo "   Override (intentional migration ONLY): EGOS_ALLOW_GUARANI_SYMLINK=1 git commit ..."
   410	    exit 1
20 Boa parte da automação que você descreve (triagem, checagem de pendências, agendamento de videoconferência, acompanhamento do pedido) continua perfeitamente coerente em 2026. [ppl-ai-file-upload.s3.amazonaws](https://ppl
33   - Ou seja, o que você já diz no HTML (“o agente IA não substitui a etapa regulada”) continua 100% correto, e o ambiente dessa videoconferência/assinatura deve atender requisitos técnicos específicos além do canal de ch
49 - Diferenciar Cenário A (CPF indo ao LLM) e Cenário B (pseudonimização no gateway) é uma forma tecnicamente defensável de discutir risco x esforço. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaw
100 Hoje você já diz que o padrão é “WhatsApp inicia/acompanhando e tela segura para upload/assinatura”. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/107012856/08
139 Sua seção de “Contexto do setor” já fala de crescimento, participação PF/PJ e mudança regulatória do e‑CNPJ para selo eletrônico. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-f

exec
/bin/bash -lc "python3 - <<'PY'
import datetime
print(datetime.datetime.utcfromtimestamp(1781100363))
PY" in /home/enio/egos
 succeeded in 0ms:
<stdin>:2: DeprecationWarning: datetime.datetime.utcfromtimestamp() is deprecated and scheduled for removal in a future version. Use timezone-aware objects to represent datetimes in UTC: datetime.datetime.fromtimestamp(timestamp, datetime.UTC).
2026-06-10 14:06:03

exec
/bin/bash -lc 'git diff 4a44ae1bbfd0a4097dd715ded5349048434a4b19 --check' in /home/enio/egos
 exited 2 in 0ms:
docs/drafts/conselho1.md:3: trailing whitespace.
+Abaixo organizei em dois blocos:  
docs/drafts/conselho1.md:4: trailing whitespace.
+1) Resposta conceitual (WhatsApp vs tela segura, com exemplos reais)  
docs/drafts/conselho1.md:15: trailing whitespace.
+- Triagem, perguntas e coleta de dados cadastrais básicos (nome, tipo de certificado, e-mail, telefone).  
docs/drafts/conselho1.md:16: trailing whitespace.
+- Consulta de status, reenvio de documentos já armazenados, reagendamentos, cancelamentos.  
docs/drafts/conselho1.md:26: trailing whitespace.
+- **1. Upload de documentos “juridicamente sensíveis”**  
docs/drafts/conselho1.md:27: trailing whitespace.
+  - Documentos que vão para dossiê regulado (ICP‑Brasil, KYC mais pesado, processos jurídicos).  
docs/drafts/conselho1.md:30: trailing whitespace.
+- **2. Assinatura digital qualificada ou atos regulados (ICP‑Brasil)**  
docs/drafts/conselho1.md:35: trailing whitespace.
+- **3. Entrada de dados de cartão ou onboarding de Pix/Open Finance fora dos modelos nativos do WhatsApp**  
docs/drafts/conselho1.md:54: trailing whitespace.
+1) **ANPD já não é mais só um “enforcer fraco”**  
docs/drafts/conselho1.md:62: trailing whitespace.
+2) **Usar a linha de ‘WhatsApp como operador/plataforma de terceiro’**  
docs/drafts/conselho1.md:84: trailing whitespace.
+  - biometria com liveness e detecção de deepfake,  
docs/drafts/conselho1.md:85: trailing whitespace.
+  - criptografia ponta‑a‑ponta da videoconferência,  
docs/drafts/conselho1.md:90: trailing whitespace.
+> **Honestidade regulatória — ICP‑Brasil (jun/2026)**  
docs/drafts/conselho1.md:103: trailing whitespace.
+> ## 🔀 O fluxo: WhatsApp como porta, tela segura para o que é sensível  
docs/drafts/conselho1.md:104: trailing whitespace.
+>  
docs/drafts/conselho1.md:105: trailing whitespace.
+> O WhatsApp é o **canal de conversa**: ele recebe texto, áudio, fotos e documentos, e o agente de IA orquestra as ações no backend (consultar status, listar documentos, agendar videoconferência, gerar link de pagamento). A pessoa só conversa — não precisa entender a engrenagem.  
docs/drafts/conselho1.md:106: trailing whitespace.
+>  
docs/drafts/conselho1.md:107: trailing whitespace.
+> Para cada etapa, existem três modos de operação possíveis:  
docs/drafts/conselho1.md:108: trailing whitespace.
+>  
docs/drafts/conselho1.md:109: trailing whitespace.
+> 1. **Tudo no WhatsApp (baixo risco)** – Triagem, esclarecimento de dúvidas, escolha do tipo de certificado, reenvio de documentos já armazenados e consultas simples são feitas inteiras dentro da conversa.  
docs/drafts/conselho1.md:111: trailing whitespace.
+> 3. **App ou portal primeiro (alta maturidade)** – Para clientes que já usam um portal da MF, o WhatsApp pode funcionar só como “segunda tela”: notifica, responde dúvidas e envia links de ação para o ambiente principal.  
docs/drafts/conselho1.md:112: trailing whitespace.
+>  
docs/drafts/conselho1.md:154: trailing whitespace.
+- Atualizar a seção **“🔀 O fluxo: WhatsApp como porta…”** com o texto do modelo híbrido acima, deixando claro que essa é a arquitetura recomendada hoje.  
docs/drafts/conselho1.md:156: trailing whitespace.
+  - tirar a ideia de “enforcement limitado”;  
docs/drafts/conselho1.md:157: trailing whitespace.
+  - introduzir ANPD, transferência internacional e BSUID;  
docs/drafts/conselho1.md:248: trailing whitespace.
+Na parte regulatória, corrigi a linguagem sobre ICP-Brasil: a IA pode preparar, orientar, agendar e reduzir retrabalho, mas não deve prometer emissão nem substituir a validação regulada. A IN ITI nº 36/2026 detalha requisitos de confirmação de identidade, incluindo documentação, biometria, consulta a bases e termo de titularidade; e a videoconferência continua sendo procedimento regulado quando aplicável. 
docs/drafts/conselho1.md:259: trailing whitespace.
+ 
docs/drafts/conselho1.md:257: new blank line at EOF.

exec
/bin/bash -lc "grep -n \"diff --check\\|trailing\" -n .husky/pre-commit | head -20" in /home/enio/egos
 succeeded in 0ms:
codex
The patch introduces credential-bearing pre-signed URLs into a committed draft, which violates secret-handling expectations and should be fixed before merging. I did not identify other blocking code issues in the changed files.

Review comment:

- [P1] Remove signed S3 upload URLs from draft — /home/enio/egos/docs/drafts/conselho1.md:20-20
  This added draft embeds a pre-signed `ppl-ai-file-upload.s3.amazonaws.com` URL containing `AWSAccessKeyId`, `Signature`, `x-amz-security-token`, and `Expires`; if this branch is pushed or the repo is shared before the URL expires, anyone with access to the commit can fetch the private uploaded HTML, and the credential material will remain in git history. Replace these citations with a redacted/public source and invalidate or rotate the uploaded link if possible.
The patch introduces credential-bearing pre-signed URLs into a committed draft, which violates secret-handling expectations and should be fixed before merging. I did not identify other blocking code issues in the changed files.

Review comment:

- [P1] Remove signed S3 upload URLs from draft — /home/enio/egos/docs/drafts/conselho1.md:20-20
  This added draft embeds a pre-signed `ppl-ai-file-upload.s3.amazonaws.com` URL containing `AWSAccessKeyId`, `Signature`, `x-amz-security-token`, and `Expires`; if this branch is pushed or the repo is shared before the URL expires, anyone with access to the commit can fetch the private uploaded HTML, and the credential material will remain in git history. Replace these citations with a redacted/public source and invalidate or rotate the uploaded link if possible.
```
