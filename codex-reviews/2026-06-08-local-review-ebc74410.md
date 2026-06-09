# Codex Local Review — 2026-06-08T00:39:26Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
2026-06-08T00:39:32.313104Z ERROR codex_models_manager::manager: failed to refresh available models: timeout waiting for child process to exit
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.5
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019ea4ab-a2da-7903-aba4-053a45c68cef
--------
user
changes against 'HEAD~3'
2026-06-08T00:39:33.373728Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-08T00:39:37.512802Z ERROR codex_models_manager::manager: failed to refresh available models: timeout waiting for child process to exit
2026-06-08T00:39:39.316792Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63 --stat && git diff 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/purge.md                         |  63 ++++++++++
 .egos-manifest.yaml                               |  27 ++---
 TASKS.md                                          |   3 +-
 TASKS_ARCHIVE.md                                  |   6 +
 apps/egos-landing/public/timeline/rss             |   2 +-
 apps/egos-landing/public/timeline/rss.xml         |   2 +-
 apps/egos-landing/src/App.tsx                     |  70 +++++++----
 apps/egos-landing/src/components/MyceliumPage.tsx |   2 +-
 docs/knowledge/HARVEST.md                         |  46 ++++++-
 docs/strategy/APRESENTACAO_EGOS.md                | 140 ++++++++++++++++++++++
 scripts/security/purge-gate.sh                    |  53 ++++++++
 scripts/visual-audit.ts                           |   6 +-
 12 files changed, 375 insertions(+), 45 deletions(-)
diff --git a/.claude/commands/purge.md b/.claude/commands/purge.md
new file mode 100644
index 00000000..5df1503e
--- /dev/null
+++ b/.claude/commands/purge.md
@@ -0,0 +1,63 @@
+---
+name: purge
+description: Limpa dado sensível conhecido (PII de pessoas/operações) de QUALQUER sistema/repo antes de publicar — via motor packages/pii-purge. Monta dict (HITL), dry-run, revisão, apply (HITL), verify + sweep independente. Red Zone (dado real) → corte do Enio antes de --apply e antes de qualquer push.
+---
+
+# /purge — Limpeza de dado sensível em massa (motor pii-purge)
+
+> **Capacidade system-wide:** serve para limpar QUALQUER repo/sistema, não só o intelink.
+> **SSOT do motor:** `packages/pii-purge/README.md` · **Registry:** CAPABILITY_REGISTRY §114
+> **Gate:** `scripts/security/purge-gate.sh` (R-SEC-005)
+
+## Quando usar
+Antes de tornar público / compartilhar / fazer source_add / deploy de um repo que já teve dado real (PII de pessoa, nome/CPF/placa/telefone de operação, nº de inquérito). Ou quando o Enio pedir "limpa X".
+
+## Regras duras (T0/T1)
+- **Red Zone:** dado real de investigação/PII → o `--apply` e qualquer `push` exigem **corte do Enio** (HITL). Dry-run + relatório posso fazer sozinho.
+- **O entity-dict NUNCA é versionado** (R-SEC-002): vive em `~/.egos-purge-entities.json` (ou `$EGOS_PURGE_ENTITY_DICT`), gitignored/local. Apagar ou cifrar após uso.
+- **Nunca reproduzir o valor real** em commit, task, handoff ou log (T0 §3) — só tipo + localização.
+- **O `verifyCleanExit` do motor NÃO basta** (INC-006): sempre rodar o sweep independente.
+
+## Fluxo (passo a passo)
+
+### 1. Montar o entity-dict (HITL)
+Identificar as entidades a remover (do próprio repo sujo ou do Enio). Escrever em `~/.egos-purge-entities.json` (chmod 600), fora de qualquer repo:
+```json
+{ "entities": [
+  { "id": "pessoa-001", "names": ["NOME COMPLETO"], "cpfs": ["..."], "phones": ["..."], "plates": ["..."], "reds": ["nome de grupo/operação"] }
+]}
+```
+> Dica: nomes/identificadores **distintivos** (nome completo, CPF, placa). Evitar nome comum solo (over-match). Texto (grupo/operação) vai em `names` ou `reds` — o safety-net literal pega de qualquer jeito.
+
+### 2. DRY-RUN (posso sozinho)
+```bash
+bun packages/pii-purge/src/cli.ts --entity-dict ~/.egos-purge-entities.json --target <repo> --json
+```
+Apresentar o relatório (file:line + tipo + entidade, **nunca o valor**). Confirmar 0 `REVIEW_REQUIRED` ou tratá-los (nomes fuzzy → revisão humana).
+
+### 3. APPLY (corte do Enio)
+```bash
+bun packages/pii-purge/src/cli.ts --entity-dict ~/.egos-purge-entities.json --target <repo> --apply --json
+```
+Mascara com token coerente `[PESSOA_N]` + grava audit hash-chained.
+
+### 4. VERIFY independente (obrigatório — não confiar só no verifyCleanExit)
+```bash
+# a) o gate do motor
+bash scripts/security/purge-gate.sh <repo> ~/.egos-purge-entities.json
+# b) sweep manual exaustivo: tokens conhecidos + corrupção + genérico
+grep -rniE '<token1>|<token2>|\[PESSOA_[0-9]+\]_' --include='*.md' --include='*.ts' --include='*.py' --include='*.sql' <repo> | grep -v node_modules
+grep -rnE '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}' <repo>/... | grep -v '<sintéticos conhecidos>'
+```
+Spot-check os arquivos de CÓDIGO mascarados (sintaxe sã? sem `[PESSOA_N]_` corrompido?).
+
+### 5. Histórico (se o dado já foi commitado)
+Limpar só o HEAD **não basta** — `git log -S` ainda revela. Para repo jovem: backup branch + orphan squash + force-push (corte do Enio). Para repo grande: `git filter-repo`. GitHub retém o SHA antigo até GC → follow-up GitHub Support (vide INC-PII-001).
+
+### 6. Cleanup
+Apagar `~/.egos-purge-entities.json`. O audit log (`~/pii-purge-audit-*.jsonl`) só tem hashes — manter para proveniência.
+
+## Limitações conhecidas (honestidade)
+- Nomes fuzzy = `REVIEW_REQUIRED` (nunca auto-purgados — protege evidência).
+- O motor acha só o que está no dict — dict incompleto = leftover. Por isso o sweep independente.
+- Sem DB rodando, seeds/migrations limpos ficam `[CONCEPT]` até smoke.
diff --git a/.egos-manifest.yaml b/.egos-manifest.yaml
index 5199a4d7..f77236dd 100644
--- a/.egos-manifest.yaml
+++ b/.egos-manifest.yaml
@@ -88,7 +88,7 @@ claims:
   - id: completed_tasks_total
     description: "Total completed tasks in TASKS.md"
     readme_location: "TASKS.md"
-    command: "grep -c '^- \\[x\\]' TASKS.md"
+    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
     tolerance: "min:1"
     last_value: "1"
     last_verified_at: "2026-05-25"
@@ -167,6 +167,16 @@ claims:
     category: "governance"
     note: "Main stages: gitleaks, start-v6.0, tsc, doc-proliferation, governance-sync, SSOT-drift, doc-drift, evidence-gate, file-intelligence, vocab-guard, hook-telemetry-collector"
 
+  - id: cross_repo_capabilities
+    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
+    readme_location: "docs/knowledge/CAPABILITY_CROSS_INDEX.md"
+    command: "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
+    tolerance: "min:10"
+    last_value: "28"
+    last_verified_at: "2026-05-05"
+    category: "custom"
+    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+
 domains:
   - url: "https://guard.egos.ia.br/health"
     expected_status: "200"
@@ -177,7 +187,7 @@ domains:
     checked_at: "2026-04-29"
     note: "Redirects to /login"
   - url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
-    expected_status: "200"
+    expected_status: "301"
     checked_at: "2026-04-29"
   - url: "https://eagleeye.egos.ia.br/"
     expected_status: "200"
@@ -199,16 +209,5 @@ endpoints:
   - name: "gem_hunter_topics"
     url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
     method: "GET"
-    expected_status: "200"
-    expected_contains: "Gem Hunter"
-
-  - id: cross_repo_capabilities
-    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
-    readme_location: "docs/CAPABILITY_CROSS_INDEX.md"
-    command: "grep -c '^- \\*\\*' docs/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
-    tolerance: "min:10"
-    last_value: "28"
-    last_verified_at: "2026-05-05"
-    category: "custom"
-    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+    expected_status: "301"
 
diff --git a/TASKS.md b/TASKS.md
index 44cbdf18..4968af40 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -871,8 +871,7 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **PII-PURGE-004** [P0] `forja`+`prime` — Purge mode com token-map coerente (mesma entidade→mesmo `[PESSOA_N]` em todos arquivos) + audit hash-chained. `--dry-run` OBRIGATÓRIO antes de aplicar. Nomes fuzzy = `REVIEW_REQUIRED` (HITL), nunca purge silencioso.
 - [ ] **PII-PURGE-005** [P0] `prime` — Verify gate pós-purge (zero-tolerância) + wire no publish gate (R-SEC-005). Re-scan deve voltar vazio.
 - [ ] **PII-PURGE-006** [P1] `curador` — CBC-* doc + 3 golden cases (R-CAP-001) + entrada CAPABILITY_REGISTRY. Capacidade sem eval = `unverified:`.
-- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — Wire `--verify-only` no pre-commit (R-SEC-005) + paths de publicação (push/NotebookLM/deploy). Mecanismo pronto; falta plugar nos hooks.
-- [ ] **PII-PURGE-SKILL-001** [P2] `prime` — Skill `/purge <repo>`: monta dict (HITL) + dry-run + relatório + apply (HITL) + runbook "como limpar um sistema". Casca ergonômica para qualquer um/IA limpar com 1 comando.
+- [ ] **PII-PURGE-GATE-WIRE-001** [P1] `forja` — MECANISMO PRONTO: `scripts/security/purge-gate.sh` (roda `--verify-only`, skip gracioso sem dict, exit 1 detectando). FALTA: plugar nos hooks reais — pre-commit (frozen zone → mudança deliberada) + publish paths (push/NotebookLM/deploy). Opt-in por ora.
 - [ ] **INTELINK-PLATFORM-GH-CACHE-001** [P1] `prime`+`hermes-ops` — GitHub pode reter `f0cfdb7` (18 PII) por SHA até GC + em forks/PRs. Como INC-PII-001: contatar GitHub Support p/ purgar cache + checar forks/network. Force-push limpou o branch, não garante o cache.
 
 ### WS5 — Gate Discover-Before-Create (pre-commit bloqueante)
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 44eb39bc..4877cd6a 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3726,3 +3726,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **PII-PURGE-BUG-001** [P1] `prime` — FIX `e9886022`: dedupe de spans sobrepostos (longest-wins) em `applyReplacements`. Teste + smoke: placa com/sem traço → 1 token limpo, sem corrupção `[PESSOA_N]_`.
 - [x] **PII-PURGE-VERIFY-001** [P1] `prime` — FIX `e9886022`: safety-net de busca literal (`scanLiteralValues`/`flattenEntityValues`) ligado ao `verify` — independe da tipagem do campo; pega valor de texto em campo numérico. + `--verify-only` (publish gate) + exclui o próprio dict do scan. 31 testes verdes.
 
+
+## Archived 2026-06-07
+
+### WS4 — Motor de Purge Inteligente em Massa (`packages/pii-purge/`)
+- [x] **PII-PURGE-SKILL-001** [P2] `prime` — DONE: skill `/purge` em `.claude/commands/purge.md` (dict HITL → dry-run → review → apply HITL → verify + sweep independente + histórico + cleanup) com runbook embutido. Auto-descoberta.
+
diff --git a/apps/egos-landing/public/timeline/rss b/apps/egos-landing/public/timeline/rss
index 82db7ff4..ebe63be8 100644
--- a/apps/egos-landing/public/timeline/rss
+++ b/apps/egos-landing/public/timeline/rss
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:08:53 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/public/timeline/rss.xml b/apps/egos-landing/public/timeline/rss.xml
index 82db7ff4..ebe63be8 100644
--- a/apps/egos-landing/public/timeline/rss.xml
+++ b/apps/egos-landing/public/timeline/rss.xml
@@ -5,7 +5,7 @@
     <link>https://egos.ia.br/#/timeline</link>
     <description>Construindo o EGOS — framework de IA governado para PMEs brasileiras. Evidence-first, open-source.</description>
     <language>pt-BR</language>
-    <lastBuildDate>Fri, 05 Jun 2026 00:23:10 GMT</lastBuildDate>
+    <lastBuildDate>Mon, 08 Jun 2026 00:08:53 GMT</lastBuildDate>
     <atom:link href="https://egos.ia.br/timeline/rss" rel="self" type="application/rss+xml"/>
     
     <item>
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index ba3c38a8..1aca1271 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -475,13 +475,13 @@ function App() {
                 onClick={() => navigateTo('grok')}
                 style={{ color: currentRoute === 'grok' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Grok Hunter
+                Checador de IA
               </button>
               <button
                 onClick={() => navigateTo('mycelium')}
                 style={{ color: currentRoute === 'mycelium' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Mycelium
+                Rede de conhecimento
               </button>
             </div>
           )}
@@ -537,8 +537,8 @@ function App() {
             { route: 'transparencia', label: 'Transparência' },
             { route: 'guard', label: 'Guard Brasil' },
             { route: 'tools', label: 'Ferramentas' },
-            { route: 'grok', label: 'Grok Hunter' },
-            { route: 'mycelium', label: 'Mycelium' },
+            { route: 'grok', label: 'Checador de IA' },
+            { route: 'mycelium', label: 'Rede de conhecimento' },
           ] as { route: string; label: string }[]).map(({ route, label }) => (
             <button
               key={route || 'home'}
@@ -567,16 +567,16 @@ function App() {
             <div>
               {/* Hero Banner */}
               <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>Framework de IA Governada</span>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
                 <h1 className="display-xl" style={{ marginBottom: '24px' }}>
-                  IA que você pode <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>auditar, explicar e controlar</span>
+                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
                 </h1>
                 <p className="body-l muted" style={{ marginBottom: '32px' }}>
-                  EGOS é um framework de orquestração de agentes com governança embutida — rastreabilidade por design, conformidade LGPD, e gates de segurança que rodam antes de qualquer dado sair da sua máquina.
+                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
                 </p>
                 <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
-                  <a href="https://egos.ia.br/tools" className="btn btn-primary">Usar ferramentas →</a>
-                  <button onClick={() => navigateTo('timeline')} className="btn btn-ghost">Ver builds ao vivo</button>
+                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
+                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
                 </div>
               </section>
 
@@ -585,31 +585,59 @@ function App() {
                 <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
                 <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px' }}>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Governança</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🎯</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>1. Escolha seu tipo de trabalho</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      Regras constitucionais com precedência T0→T4. Cada decisão de agente é classificada antes de executar. Gates pré-commit bloqueiam dado sensível.
+                      O EGOS parte da sua realidade — advocacia, clínica, contabilidade, comércio, sala de aula. Assim a IA recebe instruções claras do que fazer e do que evitar.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🤖</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Agentes</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>2. Proteja as informações sensíveis</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      12 papéis especializados (Guardião, Curador, Investigador, Sentinela…) com escopo definido e HITL obrigatório em Red Zones.
+                      Antes de mandar algo para a IA, o EGOS ajuda a identificar dados como CPF, CNPJ, prontuário e dados de cliente — para diminuir o risco de expor o que não deve sair do seu controle.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>⚙️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Ferramentas</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>✅</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>3. Confira antes de confiar</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      MCPs, Guard Brasil (PII), eval-runner com casos dourados, e pipelines auditáveis. Cada capability tem evidência — stub sem teste é code morto.
+                      O EGOS organiza a resposta da IA para você separar o que é fato, o que precisa de conferência e o que é só sugestão. A decisão final continua com você.
                     </p>
                   </div>
                 </div>
               </section>
 
-              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              {/* ── Como você usa na sua área ── */}
               <section style={{ margin: '56px 0' }}>
+                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
+                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Para o seu dia a dia</span>
+                  <h2 className="h2">Como você usa na sua área</h2>
+                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
+                    O EGOS se adapta ao seu trabalho. Alguns exemplos de quem já pode usar hoje.
+                  </p>
+                </div>
+                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px' }}>
+                  {[
+                    { icon: '⚖️', area: 'Advogado', problema: 'Analisar documentos e responder clientes sem expor dados do processo.', ajuda: 'Um assistente que lê documentos com cuidado, responde pelo WhatsApp e guarda registro de cada atendimento.' },
+                    { icon: '🩺', area: 'Médico / Clínica', problema: 'Usar IA no dia a dia sem expor prontuário ou dados de paciente.', ajuda: 'Mostra como usar IA com os dados protegidos e revisão humana antes de qualquer orientação sensível.' },
+                    { icon: '🧾', area: 'Contador', problema: 'Dados fiscais, CPF e CNPJ passam por muitas tarefas repetitivas.', ajuda: 'Ajuda a organizar as informações para análise sem tratar dado sensível como texto comum.' },
+                    { icon: '🍽️', area: 'Comércio / Restaurante', problema: 'Cardápio e catálogo vivem em foto, papel ou mensagem de WhatsApp.', ajuda: 'Transforma a foto do cardápio ou catálogo em planilha pronta — com conferência humana antes de cadastrar.' },
+                    { icon: '📚', area: 'Professor', problema: 'IA cria material bonito, mas às vezes com erro ou fonte fraca.', ajuda: 'Organiza aulas, exercícios e resumos com pontos de conferência antes de usar com os alunos.' },
+                    { icon: '🌾', area: 'Agrônomo', problema: 'Laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.', ajuda: 'Um assistente da área que organiza as informações e destaca o que precisa ser validado por um profissional.' },
+                  ].map((c) => (
+                    <div key={c.area} className="card" style={{ padding: '28px' }}>
+                      <div style={{ fontSize: '28px', marginBottom: '12px' }}>{c.icon}</div>
+                      <h3 className="h3" style={{ marginBottom: '8px' }}>{c.area}</h3>
+                      <p style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.6, marginBottom: '10px' }}>{c.problema}</p>
+                      <p style={{ fontSize: '14px', color: 'var(--text-strong)', lineHeight: 1.6 }}>{c.ajuda}</p>
+                    </div>
+                  ))}
+                </div>
+              </section>
+
+              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              <section id="comece" style={{ margin: '56px 0' }}>
                 <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                   <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
                   <h2 className="h2">Comece aqui</h2>
@@ -1258,8 +1286,8 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
           {currentRoute === 'grok' && (
             <div>
               <section style={{ textAlign: 'center', marginBottom: '40px' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Inteligência em Tempo Real (X.com)</span>
-                <h1 className="h2">Grok Hunter Assistant</h1>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Pesquisa de tendências com IA</span>
+                <h1 className="h2">Checador de IA</h1>
                 <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '12px auto 0' }}>
                   Gere prompts otimizados para buscar tendências, repositórios e artigos no Grok e importe de graça no EGOS.
                 </p>
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 9e5abbd4..63e0a41d 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -330,7 +330,7 @@ export function MyceliumPage() {
             Sistema vivo · tempo real
           </span>
           <h1 style={{ fontSize: '30px', fontWeight: 800, color: 'var(--text-strong)', margin: '0 0 10px' }}>
-            Mycelium — o EGOS por dentro
+            Rede de conhecimento — o EGOS por dentro
           </h1>
           <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '0 auto', fontSize: '14px', lineHeight: 1.6 }}>
             Cada nó é uma peça real do sistema. As linhas são as conexões — quem fala com quem.
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index c4c9c6fc..8c95e42d 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,8 +1,50 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.15.0 | **UPDATED:** 2026-06-03 UTC-3
+> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P169 — Orquestração Local Rápida (Guarani e Prime/Claude Code)
+> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+
+---
+
+## P170 — 2026-06-07: Mapa de Consumo de Tokens LLM (OpenRouter/Gemini)
+
+**Trigger:** Contexto alarm mostrou $77.30 — usuário perguntou onde estamos gastando tanto com Gemini.
+
+**Achado crítico:** O $77.30 era custo da **sessão Claude Code** (Opus model, 429 msgs), NÃO do sistema EGOS.
+
+### Superfícies LLM ativas no EGOS (2026-06-07)
+
+| Superfície | Trigger | Modelo | Custo estimado |
+|-----------|---------|--------|---------------|
+| Gateway chatbot (WhatsApp/TG/web) | Por mensagem de usuário | gemini-2.0-flash-001 | ~$0.0001/msg |
+| HQ codex-review | Por PR review solicitado | gemini-2.0-flash-001 | ~$0.001/review |
+| HQ chat/banda | Por chamada manual | gemini-2.0-flash-001 | ~$0.0001/call |
+| x-opportunity-alert | VPS cron 0 */2 * * * (2h) | gemini-2.0-flash-001 | ~$0.001-0.01/run |
+| x-reply-bot | VPS cron 0 * * * * (1h) | gemini-2.0-flash-001 | ~$0.001/run |
+| llm-model-monitor | A cada 6h (polling /models) | N/A (API pública) | $0 (sem chat) |
+| Hermes cron jobs | 2 semanais (Mon+Sun) | claude-sonnet-4-6 via Anthropic | custo Anthropic API |
+| Scripts manuais | On-demand | gemini-2.0-flash-001 | ad hoc |
+
+**Dados reais Supabase `api_usage`:**
+- Total: 8 calls | $0.0145 USD | Google gemini-2.5-flash
+- Última entrada: 2026-06-03 — logging incompleto ou VPS scripts não rodando
+
+**Hermes default model:** `claude-sonnet-4-6` via Anthropic API — cron runners usam Anthropic, não OpenRouter.
+
+### Cadeia de fallback implementada (llm-provider.ts)
+
+1. **Google AI Studio (free):** gemini-2.5-flash (500 req/day) → gemma-4-31b-it (1500 req/day) — GRATUITO
+2. **OpenRouter (pago):** gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
+
+**Custo projetado mensal** (uso moderado — gateway 50 msgs/dia + VPS crons):
+- Google free tier absorve ~1500 req/dia → OpenRouter só entra no overflow
+- Estimativa conservadora: < $5/mês se free tier estiver funcionando
+
+### Maior fonte de custo real (não-Gemini)
+
+**Claude Code sessions com Opus:** $77.30/sessão longa. Este é o custo dominante — não o Gemini.
+- Usar Sonnet 4.6 (default) em vez de Opus reduz custo ~5x
+- Sessões com 429+ msgs = custo acumulado de cache_read crescente
 
 ---
 
diff --git a/docs/strategy/APRESENTACAO_EGOS.md b/docs/strategy/APRESENTACAO_EGOS.md
new file mode 100644
index 00000000..ec205399
--- /dev/null
+++ b/docs/strategy/APRESENTACAO_EGOS.md
@@ -0,0 +1,140 @@
+# EGOS — Apresentação (material inicial + roteiro de vídeo)
+
+**Versão:** 1.0 | **Data:** 2026-06-07 | **Status:** DRAFT — HITL antes de publicar/gravar.
+**Uso:** (A) exportar como **PDF** (material inicial); (B) base do **roteiro de vídeo** de apresentação (§ROTEIRO).
+**Voz:** PT-BR, EGOS-entidade, colaborativo, sem absoluto, **sem preço** (preço só no acesso), sem promessa de renda.
+**Telegram oficial:** https://t.me/ethikin
+
+---
+
+## PARTE A — Material escrito (vira PDF)
+
+### 1. Em uma frase
+O EGOS ajuda você a usar IA (ChatGPT, Claude, Gemini) com método — para a IA não inventar resposta, não vazar seus dados, e você saber o que é fato e o que é achismo.
+
+### 2. O problema
+A IA virou parte do trabalho de todo mundo. Mas ela: inventa com confiança, mistura fato com suposição, e — se você colar dados de cliente, CPF, prontuário — pode expor o que não devia. A maioria usa IA no escuro. O EGOS organiza esse uso.
+
+### 3. O que é o EGOS
+Três coisas juntas:
+- **Método** — um jeito de conversar com a IA que separa fato de achismo e protege seus dados.
+- **Ferramentas prontas** — metaprompts, um checklist de segurança, um detector de dados sensíveis (Guard Brasil), conversor de foto→planilha, e mais sendo construído.
+- **Comunidade** — um grupo onde a gente compartilha ferramentas, aprendizados e constrói junto, por área de trabalho.
+
+### 4. O básico (a metodologia, em linguagem simples)
+1. **Classifique** o que a IA diz: isso é fato confirmado, é dedução, é só suposição, ou ela não sabe? Nunca tratar achismo como verdade.
+2. **Proteja os dados** antes de colar: CPF, CNPJ, dados de cliente, prontuário ficam mascarados ou fora.
+3. **Confira antes de confiar**: a decisão final é sempre de uma pessoa. A IA propõe, você dispõe.
+4. **Deixe rastro**: registre o que foi feito, para poder revisar depois.
+
+### 5. O que você recebe (hoje, de graça)
+- **Metaprompt "Assistente Profissional Governado"** — cola no ChatGPT/Claude/Gemini, responde uma pergunta, e vira um assistente da sua área com esses cuidados embutidos.
+- **Checklist de Segurança de IA** (1 página) — o que conferir toda vez que usar IA no trabalho.
+- **Detector de dados sensíveis** (Guard Brasil) — mostra e mascara CPF/CNPJ/e-mail antes de enviar a qualquer IA.
+
+### 6. Como você usa na sua área
+- **Advogado** — assistente que lê documentos sem expor dados do processo, responde no WhatsApp, guarda registro.
+- **Médico/clínica** — IA com prontuário protegido e revisão humana antes de orientação sensível.
+- **Contador** — organiza dados fiscais sem tratar CPF/CNPJ como texto comum.
+- **Comércio/restaurante** — foto do cardápio/catálogo vira planilha pronta, com conferência humana.
+- **Professor** — monta aula/exercício/resumo com pontos de conferência antes de levar pro aluno.
+- **Agrônomo, corretor, representante, transportadora...** — um assistente da área, com os mesmos cuidados.
+
+### 7. A comunidade / o grupo
+- Um grupo onde você **aprende a montar seu próprio setup** de IA, com segurança, do seu jeito.
+- A gente **compartilha ferramentas e aprendizados** — o que funciona pra um ajuda os outros.
+- O conteúdo **cresce com o tempo**: novas ferramentas, novos metaprompts, novos casos por área são adicionados e ficam disponíveis pra quem está dentro.
+- **Colaboração de verdade**: quem contribui (com ideias, casos, código) ajuda a melhorar o material de todos.
+
+### 8. Ferramentas por área — construídas junto
+Cada área tem necessidades próprias. A ideia é ir construindo ferramentas específicas (do advogado, do comerciante, do professor...) com a comunidade — quem vive o problema ajuda a desenhar a solução.
+
+### 9. Espaço de criação e monetização na plataforma
+- Quem cria algo útil (uma ferramenta, um método, um material para uma área) pode **oferecer isso dentro da plataforma**.
+- Projetos que avançam e geram receita podem ter **participação proporcional à colaboração** (co-criação).
+- Não é promessa de renda — é um espaço aberto para quem quer construir e compartilhar valor.
+
+### 10. Como entrar
+- **Telegram (aberto, gratuito):** https://t.me/ethikin — comunidade, método público, porta de entrada.
+- **WhatsApp (grupo do EGOS):** [link a inserir quando o Enio criar] — agente vivo + acompanhamento.
+- **Comece agora, de graça:** o artefato e o checklist estão em https://egos.ia.br
+
+---
+
+## PARTE B — ROTEIRO DE VÍDEO (~8–10 min)
+
+> Tom: você (Enio) apresentando o EGOS, de gente pra gente. Calmo, claro, sem hype, sem jargão. Lidera pelo trabalho/método, não pela biografia. Sem falar preço.
+
+**[0:00–0:40] Abertura — o gancho**
+"Você já usou o ChatGPT pra te ajudar no trabalho e desconfiou se a resposta tava certa? Ou ficou com medo de colar um dado de cliente ali? Esse é o problema que o EGOS resolve. Em poucos minutos eu te mostro como usar IA com método — sem ela te enganar e sem vazar seus dados."
+
+**[0:40–2:00] O que é o EGOS (simples)**
+Explique as 3 partes: método + ferramentas prontas + comunidade. Frase-chave: "A IA ajuda. O EGOS organiza." Diga que tudo que mostra hoje já existe e parte é gratuito.
+
+**[2:00–4:00] O básico / metodologia**
+Mostre na tela os 4 passos (classificar fato/achismo, proteger dados, conferir antes de confiar, deixar rastro). Dê um exemplo real: "Pedi pra IA um resumo; ela inventou uma lei que não existe. Com o método, ela teria marcado 'isso é suposição, confira'."
+
+**[4:00–6:00] Demonstração — o artefato + a ferramenta**
+Mostre ao vivo: cola o metaprompt, ele pergunta "qual sua área?", você responde, e vira um assistente. Mostre o detector de dados sensíveis mascarando um CPF fictício. Mostre o conversor foto→planilha (se couber).
+
+**[6:00–7:30] A comunidade e como ela cresce**
+Explique o grupo: como a gente compartilha ferramentas e aprendizados, como o conteúdo cresce, como cada área vai ganhando ferramentas próprias. Fale do espaço de criação e monetização — quem constrói pode oferecer e participar.
+
+**[7:30–8:30] Como você usa na SUA área**
+Passe rápido pelos exemplos (advogado, médico, contador, comércio, professor). "Seja qual for seu trabalho, o método é o mesmo — muda só o que você coloca dentro."
+
+**[8:30–9:30] Convite (CTA)**
+"Entra no nosso Telegram — t.me/ethikin — é aberto e gratuito. Lá a gente troca, aprende e constrói junto. E o material inicial tá em egos.ia.br pra você começar hoje." (Mostrar o link e o ícone do grupo na tela.)
+
+**Notas de gravação:** legenda sempre (muita gente assiste sem som). Cortes curtos. Mostrar a tela nas demos. Nada de "garanto/100%/único". Sem falar valor.
+
+---
+---
+
+## PARTE C — ROTEIRO PERSONALIZADO (gravação 2026-06-08)
+
+> Tom: humano, honesto, sem hype/ostentação, sem promessa de riqueza/atalho/independência financeira, sem previsão de cripto, sem aconselhamento financeiro. Lidera pelo trabalho/método; credencial discreta, sem carteirada. NÃO dizer delegacia atual. Legenda sempre.
+
+**[1 · Abertura — 0:00–0:45]**
+"Oi, eu sou o Enio. Nos últimos 16 anos trabalhei como investigador da Polícia Civil — passei por homicídios consumados e tentados, roubos, furtos, investigações financeiras, e por praticamente todo tipo de delegacia, inclusive a área de inteligência. Não vou falar onde estou hoje, e não é disso que esse vídeo trata. Trago isso só pra você entender de onde vem meu jeito de pensar: investigar é separar o que é fato do que é história. E é exatamente isso que eu quero te ajudar a fazer com a inteligência artificial."
+
+**[2 · Cripto / trajetória — 0:45–2:00]**
+"Desde 2017 eu estudo e invisto em cripto. Passei por milhares de projetos, vivi as comunidades no Discord, no Telegram, no X, peguei vários ciclos — acertei muito e errei também. Aprendi na prática. E aprendi uma coisa simples sobre o Bitcoin: é uma forma de guardar valor na era digital, e te dá a liberdade de ter a sua própria carteira e transacionar com quem você quiser, no mundo inteiro. Sem promessa, sem previsão — só o que eu entendi vivendo isso. A responsabilidade é sempre individual."
+
+**[3 · Por que estou criando / o problema — 2:00–3:30]**
+"Hoje a IA está na mão de todo mundo — ChatGPT, Claude, Gemini, Grok. Mas a maioria usa no escuro: a IA inventa resposta com confiança, mistura fato com achismo, e se você colar um dado de cliente ali, pode expor o que não devia. Eu juntei duas coisas que vivo — investigação e tecnologia — pra criar um jeito de usar IA com método. É isso que eu chamo de EGOS."
+
+**[4 · O que é o EGOS / método — 3:30–5:00]**
+"O EGOS não é mais um amontoado de PDF. O material aqui é o código, as regras, o entendimento, a clareza — e principalmente as conversas, as trocas, a comunidade. A ideia é a gente colaborar pra você melhorar de verdade sua literacia em tecnologia, especialmente em IA.
+O método é simples: a gente ensina a IA a falar como um investigador. Ela não pode te dar uma resposta solta — é obrigada a classificar antes de entregar: **CONFIRMADO** (tem prova em documento), **INFERIDO** (é dedução lógica), **HIPÓTESE** (é só possibilidade, confira). Isso muda o jogo: a IA para de tentar te convencer e passa a te mostrar as pistas.
+Eu chamo isso de **Triplo Filtro**: (1) **Dado seguro** — o que é sensível não sai da sua máquina; (2) **Grau de certeza** — a IA separa fato de achismo; (3) **Revisão humana** — você decide. A IA propõe, a pessoa dispõe."
+
+**[5 · Ferramentas grátis (o GPT é o herói) — 5:00–6:30]**
+"E não é promessa pro futuro — já tem coisa pronta pra usar hoje, de graça. A melhor de todas é o nosso GPT personalizado. Ele não te joga um prompt gigante pra você se virar: quando você abre, ele entra em **modo tutor** — te faz uma pergunta simples por vez, te ouve, e propõe a configuração exata pra sua rotina. Você só confirma. É a IA se configurando pro seu trabalho.
+Tem também o **Guard Brasil** no site. Funciona assim: você cola um texto com dados de um cliente — nome, CPF, telefone. Ali mesmo, na sua tela, o sistema troca tudo por etiquetas seguras tipo `[PESSOA_1]`, `[CPF_1]`. É esse texto limpo que vai pra IA. Quando a resposta volta, ele recoloca os dados reais na sua tela. A IA trabalha, mas os dados reais nunca saíram do seu computador.
+Comece pelo GPT — é o atalho mais honesto que eu tenho pra te entregar."
+
+**[6 · Pra quem é / pra quem não é — 6:30–7:45]**
+"Vou ser honesto: isso não é pra todo mundo. Você aproveita mais se já tem alguma coisa do seu trabalho digitalizada, se usa o computador no dia a dia, se tem curiosidade. Mas se você ainda usa só o ChatGPT pra pesquisar, de forma básica — tudo bem, a gente te ajuda a evoluir: usar um GPT personalizado, decidir se vale assinar um modelo melhor, aprender a fazer perguntas melhores. O que eu não quero é gente esperando milagre. Aqui é método e prática."
+
+**[7 · Comunidade + criação/monetização — 7:45–9:00]**
+"O coração disso é a comunidade. A gente compartilha ferramentas e aprendizados, o conteúdo cresce com o tempo, e cada área vai ganhando ferramenta própria — construída com quem vive o problema. E tem espaço pra quem quer criar: se você desenvolve algo útil, pode oferecer dentro da plataforma, e projetos que avançam podem ter participação proporcional à colaboração. Não é promessa de renda — é espaço pra construir junto."
+
+**[8 · Preço / acesso — 9:00–9:45]**
+"O acesso é vitalício. Começa custando 4 reais — sim, 4 reais — e esse valor vai dobrando conforme a comunidade vai se formando. Quem entra antes, paga menos, pra sempre. Não vou ficar dizendo quando sobe nem quantas vagas tem — isso eu decido. Quem entra cedo, entra cedo."
+
+**[9 · Convite — 9:45–10:30]**
+"Se isso fez sentido pra você, entra no nosso Telegram — o link é **t.me/ethikin**, que vem de inteligência ética e comunidade. É aberto, é gratuito, e é lá que a gente conversa e constrói junto. E começa pelo GPT e pelo material em egos.ia.br. Não precisa decidir nada agora. Dá uma olhada, testa, e vê se faz sentido pra você."
+
+> Gravação: legenda sempre · cortes curtos · mostrar a tela nas demos (GPT + detector) · nada de "garanto/100%/único/fique rico" · sem dizer delegacia atual · sem previsão de preço de cripto.
+
+---
+
+## PARTE D — Hotmart "Sobre o que é o seu produto?" (colar, ≤500 chars)
+
+> O EGOS é uma comunidade e um método para usar inteligência artificial (ChatGPT, Claude, Gemini) com mais clareza e segurança — sem que ela invente respostas ou exponha seus dados. Acesso vitalício a ferramentas prontas, um GPT personalizado, regras, materiais e, principalmente, troca com a comunidade. Para profissionais e curiosos que querem evoluir sua literacia em IA, na prática. Não é promessa de renda — é método, colaboração e aprendizado contínuo.
+
+(Preço entra no campo de preço do Hotmart, não no "Sobre": começa em R$4, progressão ×2 — o fundador decide quando sobe; não anunciar tempo/quantidade.)
+
+---
+*DRAFT — HITL Enio antes de gravar/publicar. PDF: exportar Parte A (pandoc/print). Ícone: VISUAL_IDENTITY (espiral Fibonacci azul #2563EB). Telegram: t.me/ethikin.*
diff --git a/scripts/security/purge-gate.sh b/scripts/security/purge-gate.sh
new file mode 100755
index 00000000..2671b83d
--- /dev/null
+++ b/scripts/security/purge-gate.sh
@@ -0,0 +1,53 @@
+#!/usr/bin/env bash
+# purge-gate.sh — Publish gate do motor pii-purge (R-SEC-005 / WS4 PII-PURGE-GATE-WIRE-001)
+#
+# Roda `pii-purge --verify-only` contra um diretório-alvo SE houver um entity-dict
+# local. Bloqueia (exit 1) se restar qualquer entidade conhecida; passa (exit 0) e
+# faz SKIP GRACIOSO se não houver dict — assim NÃO quebra CI nem máquinas sem o dict.
+#
+# Uso:
+#   bash scripts/security/purge-gate.sh <target-dir> [entity-dict-path]
+#
+# Convenção do dict (local, gitignored, NUNCA versionado — R-SEC-002):
+#   $EGOS_PURGE_ENTITY_DICT  (env)  ou  ~/.egos-purge-entities.json
+#
+# Wire sugerido (opt-in, NÃO força): chame antes de push/deploy/source_add de
+# qualquer repo que já teve dado real. Pre-commit fica como task deliberada
+# (frozen zone) — este script é o mecanismo reusável.
+
+set -euo pipefail
+
+TARGET="${1:-}"
+DICT="${2:-${EGOS_PURGE_ENTITY_DICT:-$HOME/.egos-purge-entities.json}}"
+EGOS_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel 2>/dev/null || echo "$HOME/egos")"
+
+if [ -z "$TARGET" ]; then
+  echo "[purge-gate] uso: bash scripts/security/purge-gate.sh <target-dir> [entity-dict-path]" >&2
+  exit 2
+fi
+
+if [ ! -d "$TARGET" ]; then
+  echo "[purge-gate] target não é diretório: $TARGET" >&2
+  exit 2
+fi
+
+if [ ! -f "$DICT" ]; then
+  echo "[purge-gate] SKIP — sem entity-dict ($DICT). Gate não-aplicável aqui (ok)."
+  exit 0
+fi
+
+if ! command -v bun >/dev/null 2>&1; then
+  echo "[purge-gate] SKIP — bun indisponível." >&2
+  exit 0
+fi
+
+echo "[purge-gate] verificando $TARGET contra entidades conhecidas..."
+# --verify-only: só escaneia (pattern + literal), NÃO purga. exit 1 se achar.
+if bun "$EGOS_ROOT/packages/pii-purge/src/cli.ts" --entity-dict "$DICT" --target "$TARGET" --verify-only; then
+  echo "[purge-gate] ✅ limpo — nenhuma entidade conhecida no alvo."
+  exit 0
+else
+  echo "[purge-gate] ❌ BLOQUEADO — entidade conhecida detectada. NÃO publicar." >&2
+  echo "[purge-gate]    Rode o purge: bun packages/pii-purge/src/cli.ts --entity-dict $DICT --target $TARGET --apply" >&2
+  exit 1
+fi
diff --git a/scripts/visual-audit.ts b/scripts/visual-audit.ts
index d658d681..6d915eb8 100644
--- a/scripts/visual-audit.ts
+++ b/scripts/visual-audit.ts
@@ -49,13 +49,13 @@ const CONSENT_SEED = JSON.stringify({
 
 // ── Page manifest ─────────────────────────────────────────────────────────────
 const PAGES = [
-  { name: 'home',          hash: '',              expect: 'IA que você pode' },
+  { name: 'home',          hash: '',              expect: 'O EGOS organiza' },
   { name: 'timeline',      hash: '#/timeline',    expect: 'Timeline' },
   { name: 'showcase',      hash: '#/showcase',    expect: 'Showcase' },
   { name: 'transparencia', hash: '#/transparencia', expect: 'Transparência' },
   { name: 'guard',         hash: '#/guard',       expect: 'Guard Brasil' },
-  { name: 'grok',          hash: '#/grok',        expect: 'Grok Hunter' },
-  { name: 'mycelium',      hash: '#/mycelium',    expect: 'Mycelium' },
+  { name: 'grok',          hash: '#/grok',        expect: 'Checador de IA' },
+  { name: 'mycelium',      hash: '#/mycelium',    expect: 'Rede de conhecimento' },
   { name: 'tools',         hash: '#/tools',       expect: 'Hub de Ferramentas' },
 ]
 

exec
/bin/bash -lc 'git diff 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63 -- apps/egos-landing/src/App.tsx apps/egos-landing/src/components/MyceliumPage.tsx docs/knowledge/HARVEST.md scripts/security/purge-gate.sh .egos-manifest.yaml' in /home/enio/egos
 succeeded in 0ms:
diff --git a/.egos-manifest.yaml b/.egos-manifest.yaml
index 5199a4d7..f77236dd 100644
--- a/.egos-manifest.yaml
+++ b/.egos-manifest.yaml
@@ -88,7 +88,7 @@ claims:
   - id: completed_tasks_total
     description: "Total completed tasks in TASKS.md"
     readme_location: "TASKS.md"
-    command: "grep -c '^- \\[x\\]' TASKS.md"
+    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
     tolerance: "min:1"
     last_value: "1"
     last_verified_at: "2026-05-25"
@@ -167,6 +167,16 @@ claims:
     category: "governance"
     note: "Main stages: gitleaks, start-v6.0, tsc, doc-proliferation, governance-sync, SSOT-drift, doc-drift, evidence-gate, file-intelligence, vocab-guard, hook-telemetry-collector"
 
+  - id: cross_repo_capabilities
+    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
+    readme_location: "docs/knowledge/CAPABILITY_CROSS_INDEX.md"
+    command: "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
+    tolerance: "min:10"
+    last_value: "28"
+    last_verified_at: "2026-05-05"
+    category: "custom"
+    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+
 domains:
   - url: "https://guard.egos.ia.br/health"
     expected_status: "200"
@@ -177,7 +187,7 @@ domains:
     checked_at: "2026-04-29"
     note: "Redirects to /login"
   - url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
-    expected_status: "200"
+    expected_status: "301"
     checked_at: "2026-04-29"
   - url: "https://eagleeye.egos.ia.br/"
     expected_status: "200"
@@ -199,16 +209,5 @@ endpoints:
   - name: "gem_hunter_topics"
     url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
     method: "GET"
-    expected_status: "200"
-    expected_contains: "Gem Hunter"
-
-  - id: cross_repo_capabilities
-    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
-    readme_location: "docs/CAPABILITY_CROSS_INDEX.md"
-    command: "grep -c '^- \\*\\*' docs/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
-    tolerance: "min:10"
-    last_value: "28"
-    last_verified_at: "2026-05-05"
-    category: "custom"
-    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"
+    expected_status: "301"
 
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index ba3c38a8..1aca1271 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -475,13 +475,13 @@ function App() {
                 onClick={() => navigateTo('grok')}
                 style={{ color: currentRoute === 'grok' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Grok Hunter
+                Checador de IA
               </button>
               <button
                 onClick={() => navigateTo('mycelium')}
                 style={{ color: currentRoute === 'mycelium' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
               >
-                Mycelium
+                Rede de conhecimento
               </button>
             </div>
           )}
@@ -537,8 +537,8 @@ function App() {
             { route: 'transparencia', label: 'Transparência' },
             { route: 'guard', label: 'Guard Brasil' },
             { route: 'tools', label: 'Ferramentas' },
-            { route: 'grok', label: 'Grok Hunter' },
-            { route: 'mycelium', label: 'Mycelium' },
+            { route: 'grok', label: 'Checador de IA' },
+            { route: 'mycelium', label: 'Rede de conhecimento' },
           ] as { route: string; label: string }[]).map(({ route, label }) => (
             <button
               key={route || 'home'}
@@ -567,16 +567,16 @@ function App() {
             <div>
               {/* Hero Banner */}
               <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>Framework de IA Governada</span>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
                 <h1 className="display-xl" style={{ marginBottom: '24px' }}>
-                  IA que você pode <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>auditar, explicar e controlar</span>
+                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
                 </h1>
                 <p className="body-l muted" style={{ marginBottom: '32px' }}>
-                  EGOS é um framework de orquestração de agentes com governança embutida — rastreabilidade por design, conformidade LGPD, e gates de segurança que rodam antes de qualquer dado sair da sua máquina.
+                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
                 </p>
                 <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
-                  <a href="https://egos.ia.br/tools" className="btn btn-primary">Usar ferramentas →</a>
-                  <button onClick={() => navigateTo('timeline')} className="btn btn-ghost">Ver builds ao vivo</button>
+                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
+                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
                 </div>
               </section>
 
@@ -585,31 +585,59 @@ function App() {
                 <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
                 <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px' }}>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Governança</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🎯</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>1. Escolha seu tipo de trabalho</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      Regras constitucionais com precedência T0→T4. Cada decisão de agente é classificada antes de executar. Gates pré-commit bloqueiam dado sensível.
+                      O EGOS parte da sua realidade — advocacia, clínica, contabilidade, comércio, sala de aula. Assim a IA recebe instruções claras do que fazer e do que evitar.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🤖</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Agentes</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>2. Proteja as informações sensíveis</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      12 papéis especializados (Guardião, Curador, Investigador, Sentinela…) com escopo definido e HITL obrigatório em Red Zones.
+                      Antes de mandar algo para a IA, o EGOS ajuda a identificar dados como CPF, CNPJ, prontuário e dados de cliente — para diminuir o risco de expor o que não deve sair do seu controle.
                     </p>
                   </div>
                   <div className="card" style={{ padding: '28px' }}>
-                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>⚙️</div>
-                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Ferramentas</h3>
+                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>✅</div>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>3. Confira antes de confiar</h3>
                     <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
-                      MCPs, Guard Brasil (PII), eval-runner com casos dourados, e pipelines auditáveis. Cada capability tem evidência — stub sem teste é code morto.
+                      O EGOS organiza a resposta da IA para você separar o que é fato, o que precisa de conferência e o que é só sugestão. A decisão final continua com você.
                     </p>
                   </div>
                 </div>
               </section>
 
-              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              {/* ── Como você usa na sua área ── */}
               <section style={{ margin: '56px 0' }}>
+                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
+                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Para o seu dia a dia</span>
+                  <h2 className="h2">Como você usa na sua área</h2>
+                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
+                    O EGOS se adapta ao seu trabalho. Alguns exemplos de quem já pode usar hoje.
+                  </p>
+                </div>
+                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px' }}>
+                  {[
+                    { icon: '⚖️', area: 'Advogado', problema: 'Analisar documentos e responder clientes sem expor dados do processo.', ajuda: 'Um assistente que lê documentos com cuidado, responde pelo WhatsApp e guarda registro de cada atendimento.' },
+                    { icon: '🩺', area: 'Médico / Clínica', problema: 'Usar IA no dia a dia sem expor prontuário ou dados de paciente.', ajuda: 'Mostra como usar IA com os dados protegidos e revisão humana antes de qualquer orientação sensível.' },
+                    { icon: '🧾', area: 'Contador', problema: 'Dados fiscais, CPF e CNPJ passam por muitas tarefas repetitivas.', ajuda: 'Ajuda a organizar as informações para análise sem tratar dado sensível como texto comum.' },
+                    { icon: '🍽️', area: 'Comércio / Restaurante', problema: 'Cardápio e catálogo vivem em foto, papel ou mensagem de WhatsApp.', ajuda: 'Transforma a foto do cardápio ou catálogo em planilha pronta — com conferência humana antes de cadastrar.' },
+                    { icon: '📚', area: 'Professor', problema: 'IA cria material bonito, mas às vezes com erro ou fonte fraca.', ajuda: 'Organiza aulas, exercícios e resumos com pontos de conferência antes de usar com os alunos.' },
+                    { icon: '🌾', area: 'Agrônomo', problema: 'Laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.', ajuda: 'Um assistente da área que organiza as informações e destaca o que precisa ser validado por um profissional.' },
+                  ].map((c) => (
+                    <div key={c.area} className="card" style={{ padding: '28px' }}>
+                      <div style={{ fontSize: '28px', marginBottom: '12px' }}>{c.icon}</div>
+                      <h3 className="h3" style={{ marginBottom: '8px' }}>{c.area}</h3>
+                      <p style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.6, marginBottom: '10px' }}>{c.problema}</p>
+                      <p style={{ fontSize: '14px', color: 'var(--text-strong)', lineHeight: 1.6 }}>{c.ajuda}</p>
+                    </div>
+                  ))}
+                </div>
+              </section>
+
+              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              <section id="comece" style={{ margin: '56px 0' }}>
                 <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                   <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
                   <h2 className="h2">Comece aqui</h2>
@@ -1258,8 +1286,8 @@ Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde i
           {currentRoute === 'grok' && (
             <div>
               <section style={{ textAlign: 'center', marginBottom: '40px' }}>
-                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Inteligência em Tempo Real (X.com)</span>
-                <h1 className="h2">Grok Hunter Assistant</h1>
+                <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Pesquisa de tendências com IA</span>
+                <h1 className="h2">Checador de IA</h1>
                 <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '12px auto 0' }}>
                   Gere prompts otimizados para buscar tendências, repositórios e artigos no Grok e importe de graça no EGOS.
                 </p>
diff --git a/apps/egos-landing/src/components/MyceliumPage.tsx b/apps/egos-landing/src/components/MyceliumPage.tsx
index 9e5abbd4..63e0a41d 100644
--- a/apps/egos-landing/src/components/MyceliumPage.tsx
+++ b/apps/egos-landing/src/components/MyceliumPage.tsx
@@ -330,7 +330,7 @@ export function MyceliumPage() {
             Sistema vivo · tempo real
           </span>
           <h1 style={{ fontSize: '30px', fontWeight: 800, color: 'var(--text-strong)', margin: '0 0 10px' }}>
-            Mycelium — o EGOS por dentro
+            Rede de conhecimento — o EGOS por dentro
           </h1>
           <p style={{ color: 'var(--text-muted)', maxWidth: '600px', margin: '0 auto', fontSize: '14px', lineHeight: 1.6 }}>
             Cada nó é uma peça real do sistema. As linhas são as conexões — quem fala com quem.
diff --git a/docs/knowledge/HARVEST.md b/docs/knowledge/HARVEST.md
index c4c9c6fc..8c95e42d 100644
--- a/docs/knowledge/HARVEST.md
+++ b/docs/knowledge/HARVEST.md
@@ -1,8 +1,50 @@
 # HARVEST.md — EGOS Core Knowledge
 
-> **VERSION:** 5.15.0 | **UPDATED:** 2026-06-03 UTC-3
+> **VERSION:** 5.16.0 | **UPDATED:** 2026-06-07 UTC-3
 > **PURPOSE:** compact accumulation of reusable patterns discovered in the kernel repo
-> **Latest:** P169 — Orquestração Local Rápida (Guarani e Prime/Claude Code)
+> **Latest:** P170 — Mapa de Consumo de Tokens LLM no Sistema EGOS
+
+---
+
+## P170 — 2026-06-07: Mapa de Consumo de Tokens LLM (OpenRouter/Gemini)
+
+**Trigger:** Contexto alarm mostrou $77.30 — usuário perguntou onde estamos gastando tanto com Gemini.
+
+**Achado crítico:** O $77.30 era custo da **sessão Claude Code** (Opus model, 429 msgs), NÃO do sistema EGOS.
+
+### Superfícies LLM ativas no EGOS (2026-06-07)
+
+| Superfície | Trigger | Modelo | Custo estimado |
+|-----------|---------|--------|---------------|
+| Gateway chatbot (WhatsApp/TG/web) | Por mensagem de usuário | gemini-2.0-flash-001 | ~$0.0001/msg |
+| HQ codex-review | Por PR review solicitado | gemini-2.0-flash-001 | ~$0.001/review |
+| HQ chat/banda | Por chamada manual | gemini-2.0-flash-001 | ~$0.0001/call |
+| x-opportunity-alert | VPS cron 0 */2 * * * (2h) | gemini-2.0-flash-001 | ~$0.001-0.01/run |
+| x-reply-bot | VPS cron 0 * * * * (1h) | gemini-2.0-flash-001 | ~$0.001/run |
+| llm-model-monitor | A cada 6h (polling /models) | N/A (API pública) | $0 (sem chat) |
+| Hermes cron jobs | 2 semanais (Mon+Sun) | claude-sonnet-4-6 via Anthropic | custo Anthropic API |
+| Scripts manuais | On-demand | gemini-2.0-flash-001 | ad hoc |
+
+**Dados reais Supabase `api_usage`:**
+- Total: 8 calls | $0.0145 USD | Google gemini-2.5-flash
+- Última entrada: 2026-06-03 — logging incompleto ou VPS scripts não rodando
+
+**Hermes default model:** `claude-sonnet-4-6` via Anthropic API — cron runners usam Anthropic, não OpenRouter.
+
+### Cadeia de fallback implementada (llm-provider.ts)
+
+1. **Google AI Studio (free):** gemini-2.5-flash (500 req/day) → gemma-4-31b-it (1500 req/day) — GRATUITO
+2. **OpenRouter (pago):** gemini-2.0-flash-001 (~$0.10/1M input, $0.40/1M output)
+
+**Custo projetado mensal** (uso moderado — gateway 50 msgs/dia + VPS crons):
+- Google free tier absorve ~1500 req/dia → OpenRouter só entra no overflow
+- Estimativa conservadora: < $5/mês se free tier estiver funcionando
+
+### Maior fonte de custo real (não-Gemini)
+
+**Claude Code sessions com Opus:** $77.30/sessão longa. Este é o custo dominante — não o Gemini.
+- Usar Sonnet 4.6 (default) em vez de Opus reduz custo ~5x
+- Sessões com 429+ msgs = custo acumulado de cache_read crescente
 
 ---
 
diff --git a/scripts/security/purge-gate.sh b/scripts/security/purge-gate.sh
new file mode 100755
index 00000000..2671b83d
--- /dev/null
+++ b/scripts/security/purge-gate.sh
@@ -0,0 +1,53 @@
+#!/usr/bin/env bash
+# purge-gate.sh — Publish gate do motor pii-purge (R-SEC-005 / WS4 PII-PURGE-GATE-WIRE-001)
+#
+# Roda `pii-purge --verify-only` contra um diretório-alvo SE houver um entity-dict
+# local. Bloqueia (exit 1) se restar qualquer entidade conhecida; passa (exit 0) e
+# faz SKIP GRACIOSO se não houver dict — assim NÃO quebra CI nem máquinas sem o dict.
+#
+# Uso:
+#   bash scripts/security/purge-gate.sh <target-dir> [entity-dict-path]
+#
+# Convenção do dict (local, gitignored, NUNCA versionado — R-SEC-002):
+#   $EGOS_PURGE_ENTITY_DICT  (env)  ou  ~/.egos-purge-entities.json
+#
+# Wire sugerido (opt-in, NÃO força): chame antes de push/deploy/source_add de
+# qualquer repo que já teve dado real. Pre-commit fica como task deliberada
+# (frozen zone) — este script é o mecanismo reusável.
+
+set -euo pipefail
+
+TARGET="${1:-}"
+DICT="${2:-${EGOS_PURGE_ENTITY_DICT:-$HOME/.egos-purge-entities.json}}"
+EGOS_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel 2>/dev/null || echo "$HOME/egos")"
+
+if [ -z "$TARGET" ]; then
+  echo "[purge-gate] uso: bash scripts/security/purge-gate.sh <target-dir> [entity-dict-path]" >&2
+  exit 2
+fi
+
+if [ ! -d "$TARGET" ]; then
+  echo "[purge-gate] target não é diretório: $TARGET" >&2
+  exit 2
+fi
+
+if [ ! -f "$DICT" ]; then
+  echo "[purge-gate] SKIP — sem entity-dict ($DICT). Gate não-aplicável aqui (ok)."
+  exit 0
+fi
+
+if ! command -v bun >/dev/null 2>&1; then
+  echo "[purge-gate] SKIP — bun indisponível." >&2
+  exit 0
+fi
+
+echo "[purge-gate] verificando $TARGET contra entidades conhecidas..."
+# --verify-only: só escaneia (pattern + literal), NÃO purga. exit 1 se achar.
+if bun "$EGOS_ROOT/packages/pii-purge/src/cli.ts" --entity-dict "$DICT" --target "$TARGET" --verify-only; then
+  echo "[purge-gate] ✅ limpo — nenhuma entidade conhecida no alvo."
+  exit 0
+else
+  echo "[purge-gate] ❌ BLOQUEADO — entidade conhecida detectada. NÃO publicar." >&2
+  echo "[purge-gate]    Rode o purge: bun packages/pii-purge/src/cli.ts --entity-dict $DICT --target $TARGET --apply" >&2
+  exit 1
+fi

exec
/bin/bash -lc 'ls docs/knowledge/CAPABILITY_CROSS_INDEX.md docs/CAPABILITY_CROSS_INDEX.md 2>/dev/null; grep -R "expected_contains" -n scripts packages . | head -20; grep -R "domains:" -n scripts packages | head -20; grep -R "endpoints:" -n scripts packages | head -20' in /home/enio/egos
exec
/bin/bash -lc 'rg "expected_contains|domains:|endpoints:" scripts packages apps -n' in /home/enio/egos
 succeeded in 0ms:
apps/api/src/server.ts:170:        endpoints: [
apps/api/src/server.ts:915:      endpoints: { health: 'GET /health', keys: 'POST /v1/keys', inspect: 'POST /v1/inspect', checkout: 'POST /v1/stripe/checkout', webhook: 'POST /v1/stripe/webhook', 'crypto-checkout': 'POST /v1/crypto/checkout', 'crypto-webhook': 'POST /v1/crypto/webhook', 'cost-dashboard': 'GET /api/admin/cost-dashboard', 'skills-discover': 'GET /api/v1/skills/discover', 'meta-prompts': 'GET /api/v1/meta-prompts', 'meta-prompts-generate': 'POST /api/v1/meta-prompts/generate' },
scripts/vault-knowledge-pipeline.ts:198:    domains: [...new Set(memos.map(m => m.source.split('/')[1] || 'uncategorized'))],
packages/audit/tests/a2a.test.ts:38:      endpoints: {
packages/audit/tests/a2a.test.ts:85:      endpoints: {
packages/audit/tests/a2a.test.ts:106:      endpoints: {
packages/audit/src/a2a-auditor.ts:13:  endpoints: {
apps/egos-hq/next.config.ts:6:    domains: ['pbs.twimg.com', 'abs.twimg.com'],
packages/eval-runner/src/mcp-runner.ts:27:  expected_contains?: string[];
packages/eval-runner/src/mcp-runner.ts:83:    for (const expected of c.expected_contains ?? []) {
packages/shared/src/world-model.ts:82:    domains: CapabilitySnapshot[];
packages/shared/src/world-model.ts:155:    const domains: CapabilitySnapshot[] = [];
packages/shared/src/world-model.ts:334:      domains: capDomains,
apps/egos-hq/app/api/hq/world-model/route.ts:15:  domains: Record<string, { status: string; last_activity: string }>;
apps/egos-hq/app/api/hq/world-model/route.ts:54:    domains: {
apps/egos-hq/app/api/hq/gateway/route.ts:8:    endpoints: {
apps/egos-hq/app/api/hq/governance/route.ts:24:    endpoints: {
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:857:**Live endpoints:**
scripts/autores-ingest-harvest.ts:316:  const domains: Record<string, number> = {};
scripts/ui-sync-check.ts:41:async function parseTenantProfiles(): Promise<Array<{ slug: string; domains: string[] }>> {
scripts/ui-sync-check.ts:47:    const profiles: Array<{ slug: string; domains: string[] }> = [];
scripts/ui-sync-check.ts:58:      const domainsMatch = block.match(/domains:\s*\[([\s\S]*?)\]/);
scripts/ui-sync-check.ts:59:      const domains: string[] = [];
scripts/ssot-router.ts:42:  domains: SsotDomain[];
scripts/ssot-router.ts:160:SSOT domains:
scripts/health-check-full.ts:124:function testEndpoints(base: string, endpoints: { path: string; expected?: string; note?: string }[]): EndpointResult[] {
apps/egos-gateway/src/channels/gem-hunter-api.ts:465:    endpoints: {
apps/egos-gateway/src/channels/v1.ts:21: *   - Proxy para Next.js ops endpoints: requer EGOS_OPS_URL + EGOS_OPS_TOKEN

exec
/bin/bash -lc 'rg "egos-manifest|claims" scripts packages -n | head -80' in /home/enio/egos
 succeeded in 0ms:
packages/atomizer/src/default-atomizer.ts:47:      claims: [],
scripts/audit-article-enc-l7-009.ts:6: * 1. No absolute claims without evidence
scripts/audit-article-enc-l7-009.ts:28:  claims: ClaimEntry[];
scripts/audit-article-enc-l7-009.ts:91:  console.log(`  Absolute claims without evidence: ${absoluteClaimsUnsupported.length}`);
scripts/audit-article-enc-l7-009.ts:130:    claims: extractClaims(content),
scripts/audit-article-enc-l7-009.ts:165:  const claims: ClaimEntry[] = [];
scripts/audit-article-enc-l7-009.ts:171:    claims.push({
scripts/audit-article-enc-l7-009.ts:179:  return claims;
scripts/autores-ingest-incidents.ts:137:    proposed_rule_text: "Subagent/Explore/Plan outputs = UNVERIFIED CLAIMS. Re-verificar top 3 claims via codebase-memory-mcp. Absolutos sem file:line = PHANTOM. Tabelas com Score/%/Coverage DEVEM ter AUTO-GEN-BEGIN OU VERIFIED_AT + method + evidence por linha.",
scripts/openrouter-benchmark-advanced.ts:172:    atrianCompliance: number;      // 0-10: Epistemic markers, no absolute claims
scripts/evidence-gate.ts:7: *   Extends Doc-Drift Shield (§27) to cover capability claims in docs/products/,
scripts/evidence-gate.ts:8: *   docs/agents/, and CAPABILITY_REGISTRY.md — not just .egos-manifest.yaml.
scripts/evidence-gate.ts:54:  /\.egos-manifest\.yaml/,
scripts/evidence-gate.ts:261:    console.log("[evidence-gate] ✅ all claims in scope have evidence markers");
scripts/evidence-gate.ts:279:  console.log("  1. Add <!-- evidence: <claim-id> --> pointing to a claim in .egos-manifest.yaml");
packages/guard-brasil/README.md:14:2. **Hallucination and epistemic violations** — models make absolute claims, invent data sources, and issue false promises — especially in sensitive contexts like police, health, or legal systems.
packages/guard-brasil/README.md:24:| **ATRiAN** | Absolute claims, fabricated data, false promises, blocked entities | Score (0–100) + flag |
packages/guard-brasil/README.md:87:Attach traceable claims to your response for audit compliance:
packages/guard-brasil/README.md:92:  claims: [
scripts/hermes-patterns-detector.ts:186:      message_normalized: "claims without file:line anchors detected",
scripts/hermes-patterns-detector.ts:198:      message_normalized: "claims without file:line anchors detected",
scripts/hermes-patterns-detector.ts:210:      message_normalized: "claims without file:line anchors detected",
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:653:| L1 | `.egos-manifest.yaml` per repo | Manual + generator | claim contracts |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:671:- `scripts/manifest-generator.ts` — DRIFT-011: auto-extract claims from READMEs via LLM
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1248:**Trigger:** N parallel agent sessions in different EGOS repos (kernel + leaf-apps) need to coordinate without falling into wrong "merge/absorb" frames or phantom claims about each other.
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:1313:4. Each turn ends with `git push` — never trust verbal/textual claims about other repos
packages/guard-brasil/src/demo.ts:47:// Inspect with evidence claims
packages/guard-brasil/src/demo.ts:50:  claims: [
scripts/system-map-gen.ts:89:*Validação: \`bun scripts/system-map-gen.ts --check\` (axis/status/depends_on). Dono da não-degradação: doc-drift shield (\`.egos-manifest.yaml\` claim \`operating_surface_entries\`).*
packages/guard-brasil/src/index.ts:7: *   - ATRiAN ethical validation (absolute claims, false promises, fabricated data)
packages/guard-brasil/src/guard.ts:36:  /** Default confidence level for unattributed claims (default: 'medium') */
packages/guard-brasil/src/guard.ts:44:  claims?: Array<{
packages/guard-brasil/src/guard.ts:93:  /** Evidence chain (if claims were provided) */
packages/guard-brasil/src/guard.ts:189:   * 1. ATRiAN — validates for absolute claims, false promises, fabricated data
packages/guard-brasil/src/guard.ts:192:   * 4. Evidence Chain — builds audit trail for provided claims
packages/guard-brasil/src/guard.ts:195:   * @param options — optional session ID and claims for evidence chain
packages/guard-brasil/src/guard.ts:218:    if (options.claims && options.claims.length > 0) {
packages/guard-brasil/src/guard.ts:220:      for (const { claim, source, excerpt, confidence } of options.claims) {
packages/knowledge-mcp/src/vault.schema.ts:121:  verified_from_claims: string[]; // Claim.id[]
packages/knowledge-mcp/src/vault-store.ts:142:    const { error } = await this.supabase.from("evidence_claims").insert(row);
packages/knowledge-mcp/src/vault-store.ts:151:      .from("evidence_claims")
packages/knowledge-mcp/src/vault-store.ts:166:      verified_from_claims: [payload.claim_id],
packages/knowledge-mcp/src/vault-store.ts:181:      .from("evidence_claims")
packages/knowledge-mcp/src/vault-store.ts:194:      claim: "evidence_claims",
scripts/check-cbc-proof-paths.ts:67:// a `live`/`in-progress` CBC whose proof file is missing claims maturity it cannot back (BLOCK).
packages/guard-brasil/src/lib/evidence-chain.ts:28:  claims: ClaimWithEvidence[];
packages/guard-brasil/src/lib/evidence-chain.ts:65:    claims: chain.claims.map(c => ({ claim: c.claim, confidence: c.confidence })),
packages/guard-brasil/src/lib/evidence-chain.ts:80:  private claims: ClaimWithEvidence[] = [];
packages/guard-brasil/src/lib/evidence-chain.ts:96:    this.claims.push({
packages/guard-brasil/src/lib/evidence-chain.ts:139:    const overallConfidence = lowestConfidence(this.claims.map(c => c.confidence));
packages/guard-brasil/src/lib/evidence-chain.ts:144:      claims: this.claims,
packages/guard-brasil/src/lib/evidence-chain.ts:156:  for (const { claim, evidence, confidence } of chain.claims) {
packages/guard-brasil/src/guard.test.ts:96:    // absolute claims are warnings, not errors — passes validation
packages/guard-brasil/src/guard.test.ts:145:  it('builds evidence chain when claims provided', () => {
packages/guard-brasil/src/guard.test.ts:149:      claims: [
packages/guard-brasil/src/guard.test.ts:159:    expect(result.evidenceChain?.claims).toHaveLength(1);
packages/guard-brasil/src/guard.test.ts:164:  it('does not build evidence chain without claims', () => {
scripts/hermes-commit-review.ts:46:1. Phantom-prone patterns (scored tables without evidence, claims without file:line anchors)
packages/guard-brasil/dist/index.js:7: *   - ATRiAN ethical validation (absolute claims, false promises, fabricated data)
scripts/manifest-generator.ts:5: * Auto-generates or updates .egos-manifest.yaml from a repo's README.md
scripts/manifest-generator.ts:8: * Extracts quantitative claims like:
scripts/manifest-generator.ts:57:  claims: Array<{
scripts/manifest-generator.ts:149:  const claims: ExtractedClaim[] = [];
scripts/manifest-generator.ts:157:      claims.push({
scripts/manifest-generator.ts:167:  return claims;
scripts/manifest-generator.ts:178:  const prompt = `Extract ALL quantitative claims from this README. Return a JSON array only.
scripts/manifest-generator.ts:186:Examples of claims to find:
scripts/manifest-generator.ts:193:Return [] if no quantitative claims found. JSON array only, no markdown.`;
scripts/manifest-generator.ts:233:  const prompt = `Extract quantitative claims from README. JSON array: [{"id":"snake_id","description":"...","value":"numeric_string","unit":"...","raw":"..."}]
scripts/manifest-generator.ts:301:  claims: ExtractedClaim[]
scripts/manifest-generator.ts:303:  const manifestPath = join(repoDir, ".egos-manifest.yaml");
scripts/manifest-generator.ts:315:    (existing?.claims ?? []).map((c) => [c.id, c])
scripts/manifest-generator.ts:318:  // Only add NEW claims (don't overwrite manually curated ones)
scripts/manifest-generator.ts:319:  for (const claim of claims) {
scripts/manifest-generator.ts:336:    claims: Array.from(existingClaims.values()),
scripts/manifest-generator.ts:355:  let claims = await llmExtractOpenRouter(repoName, content);
scripts/manifest-generator.ts:358:  if (claims.length === 0) {
scripts/manifest-generator.ts:359:    claims = await llmExtractGemini(repoName, content);
scripts/manifest-generator.ts:363:  if (claims.length === 0) {
scripts/manifest-generator.ts:364:    claims = regexExtract(content);

exec
/bin/bash -lc "sed -n '1,180p' apps/egos-landing/src/App.tsx && sed -n '540,660p' apps/egos-landing/src/App.tsx" in /home/enio/egos
 succeeded in 0ms:
import { useState, useEffect, useRef } from 'react'
import { supabase } from './lib/supabase'
import { ConsentGate } from './components/ConsentGate'
import { ConsentBadge } from './components/ConsentBadge'
import { loadConsent } from './lib/consent'
import type { ConsentChoices, ConsentState } from './lib/consent'
import { MyceliumPage } from './components/MyceliumPage'
import { ToolsHub } from './components/ToolsHub'

import './App.css'

// ─── TYPES ───────────────────────────────────────────────────────────────────
interface Article {
  slug: string
  title: string
  body_html: string
  body_markdown?: string
  published_at: string
  epistemic_status?: string
  tags?: string[]
  word_count?: number
  views?: number
  lang: string
}

interface Product {
  id: string
  title: string
  subtitle: string
  description: string
  icon: string
  tier: 'free' | 'pro' | 'enterprise'
  category: string
  tags: string[]
  badge?: string
}

// ─── CONSTANTS & DATA ────────────────────────────────────────────────────────
const PRODUCTS: Product[] = [
  {
    id: 'egos-kernel',
    title: 'EGOS Kernel',
    subtitle: 'Orchestration Engine',
    description: 'O núcleo de governança, pipeline de prompts e runtime base para construir agentes baseados em TypeScript/Node com soberania e LGPD.',
    icon: '⚙️',
    tier: 'pro',
    category: 'tool',
    tags: ['kernel', 'governança', 'runtime'],
    badge: 'Produção'
  },
  {
    id: 'carteira-livre',
    title: 'Carteira Livre',
    subtitle: 'SaaS Marketplace Base',
    description: 'Plataforma Next.js pronto para uso comercial com autenticação Supabase, gateway Asaas integrado, onboarding e fluxo financeiro.',
    icon: '💳',
    tier: 'pro',
    category: 'template',
    tags: ['SaaS', 'Asaas', 'Next.js'],
    badge: 'Produção'
  },
  {
    id: '852-inteligencia',
    title: '852 Inteligência',
    subtitle: 'Chatbot Institucional Seguro',
    description: 'Chatbot corporativo robusto com detecção PII agressiva de dados sensíveis e segurança ATRiAN level 1 embutida.',
    icon: '🛡️',
    tier: 'pro',
    category: 'agent',
    tags: ['chatbot', 'ATRiAN', 'segurança'],
    badge: 'Produção'
  },
  {
    id: 'br-acc',
    title: 'Inteligência de Dados Públicos',
    subtitle: 'Base de Grafo BR/ACC',
    description: 'Plataforma de inteligência e cruzamento de dados de CNPJs/CPFs via grafos com ETL avançado e suporte Neo4j para OSINT.',
    icon: '🌐',
    tier: 'enterprise',
    category: 'tool',
    tags: ['ETL', 'Neo4j', 'OSINT'],
    badge: 'Forense'
  },
  {
    id: 'inpi-ratio',
    title: 'Assistentes Guiados',
    subtitle: 'Modelos INPI / Ratio Jurídico',
    description: 'Assistentes de IA para processos burocráticos guiados, gerando relatórios com lastro documental e RAG com zero alucinação.',
    icon: '📝',
    tier: 'pro',
    category: 'agent',
    tags: ['wizard', 'legal', 'RAG'],
    badge: 'Produção'
  },
  {
    id: 'egos-lab',
    title: 'Ferramentas EGOS-Lab',
    subtitle: 'Micro-SaaS Utilitários',
    description: 'Utilitários prontos para uso em investigações e análises rápidas, como CV Builder, Calculador de Valor Real e Auditadores de Contratos.',
    icon: '⚡',
    tier: 'pro',
    category: 'tool',
    tags: ['micro-saas', 'utilitários', 'lab'],
    badge: 'POC Madura'
  }
]

function App() {
  // Consent gate — nothing external loads until user chooses
  const [consentState, setConsentState] = useState<ConsentState | null>(() => loadConsent())

  const handleConsent = (choices: ConsentChoices) => {
    const state = loadConsent()
    if (state) setConsentState(state)
    else setConsentState({ version: '1.0.0', timestamp: new Date().toISOString(), choices, history: [] })
  }

  const handleConsentRevoke = () => {
    setConsentState(null)
  }

  const [currentRoute, setCurrentRoute] = useState<'home' | 'timeline' | 'showcase' | 'transparencia' | 'guard' | 'grok' | 'mycelium' | 'tools'>('home')
  const [selectedArticleSlug, setSelectedArticleSlug] = useState<string | null>(null)
  const [isMobile, setIsMobile] = useState(() => typeof window !== 'undefined' && window.innerWidth < 768)
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [articles, setArticles] = useState<Article[]>([])
  const [loadingArticles, setLoadingArticles] = useState(false)
  const [selectedArticle, setSelectedArticle] = useState<Article | null>(null)
  const [loadingSingle, setLoadingSingle] = useState(false)

  // Guard Brasil Simulator State (Local)
  const [inputText, setInputText] = useState('')
  const [maskedText, setMaskedText] = useState('')
  const [detectedPII, setDetectedPII] = useState<string[]>([])

  // Guard Brasil Real Inspect State (Remote API)
  const [apiKey, setApiKey] = useState(() => localStorage.getItem('guard_api_key') || '')
  const [keyName, setKeyName] = useState('')
  const [keyEmail, setKeyEmail] = useState('')
  const [keyLoading, setKeyLoading] = useState(false)
  const [keyError, setKeyError] = useState('')
  
  const [inspectInput, setInspectInput] = useState('')
  const [inspectLoading, setInspectLoading] = useState(false)
  const [inspectResult, setInspectResult] = useState<any>(null)
  const [inspectError, setInspectError] = useState('')

  // Grok Hunter State
  const [grokTopic, setGrokTopic] = useState('')
  const [grokPrompt, setGrokPrompt] = useState('')
  const [grokLoading, setGrokLoading] = useState(false)

  // Free Artifact — metaprompt copy button state
  const [copied, setCopied] = useState(false)
  const copyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  useEffect(() => () => { if (copyTimerRef.current) clearTimeout(copyTimerRef.current) }, [])

  // Handlers for dynamic actions
  const handleGenerateKey = async () => {
    if (!keyName.trim() || !keyEmail.trim()) return
    setKeyLoading(true)
    setKeyError('')
    try {
      const res = await fetch('https://api.egos.ia.br/v1/keys', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: keyName.trim(), email: keyEmail.trim() })
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.error || 'Erro ao gerar chave')
      setApiKey(data.key)
      localStorage.setItem('guard_api_key', data.key)
    } catch (err: any) {
      setKeyError(err.message || 'Erro ao gerar chave')
    } finally {
      setKeyLoading(false)
    }
  }

  const handleInspectText = async () => {
            { route: 'grok', label: 'Checador de IA' },
            { route: 'mycelium', label: 'Rede de conhecimento' },
          ] as { route: string; label: string }[]).map(({ route, label }) => (
            <button
              key={route || 'home'}
              onClick={() => { navigateTo(route); setDrawerOpen(false) }}
              style={{
                background: 'none', border: 'none', cursor: 'pointer',
                textAlign: 'left', padding: '14px 24px',
                color: (currentRoute === (route || 'home')) ? 'var(--accent)' : 'var(--text-muted)',
                fontSize: '15px', fontWeight: 500,
                borderLeft: (currentRoute === (route || 'home')) ? '3px solid var(--accent)' : '3px solid transparent',
                width: '100%'
              }}
            >
              {label}
            </button>
          ))}
        </div>
      )}

      {/* Main Content */}
      <main id="main-content" style={{ flexGrow: 1, paddingTop: '100px', paddingBottom: '60px' }}>
        <div className="container" style={{ padding: '0 24px' }}>

          {/* HOME VIEW */}
          {currentRoute === 'home' && (
            <div>
              {/* Hero Banner */}
              <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
                <h1 className="display-xl" style={{ marginBottom: '24px' }}>
                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
                </h1>
                <p className="body-l muted" style={{ marginBottom: '32px' }}>
                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
                </p>
                <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
                </div>
              </section>

              {/* How it works — 3 layers */}
              <section style={{ margin: '40px 0' }}>
                <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px' }}>
                  <div className="card" style={{ padding: '28px' }}>
                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🎯</div>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>1. Escolha seu tipo de trabalho</h3>
                    <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
                      O EGOS parte da sua realidade — advocacia, clínica, contabilidade, comércio, sala de aula. Assim a IA recebe instruções claras do que fazer e do que evitar.
                    </p>
                  </div>
                  <div className="card" style={{ padding: '28px' }}>
                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>2. Proteja as informações sensíveis</h3>
                    <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
                      Antes de mandar algo para a IA, o EGOS ajuda a identificar dados como CPF, CNPJ, prontuário e dados de cliente — para diminuir o risco de expor o que não deve sair do seu controle.
                    </p>
                  </div>
                  <div className="card" style={{ padding: '28px' }}>
                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>✅</div>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>3. Confira antes de confiar</h3>
                    <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
                      O EGOS organiza a resposta da IA para você separar o que é fato, o que precisa de conferência e o que é só sugestão. A decisão final continua com você.
                    </p>
                  </div>
                </div>
              </section>

              {/* ── Como você usa na sua área ── */}
              <section style={{ margin: '56px 0' }}>
                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Para o seu dia a dia</span>
                  <h2 className="h2">Como você usa na sua área</h2>
                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
                    O EGOS se adapta ao seu trabalho. Alguns exemplos de quem já pode usar hoje.
                  </p>
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px' }}>
                  {[
                    { icon: '⚖️', area: 'Advogado', problema: 'Analisar documentos e responder clientes sem expor dados do processo.', ajuda: 'Um assistente que lê documentos com cuidado, responde pelo WhatsApp e guarda registro de cada atendimento.' },
                    { icon: '🩺', area: 'Médico / Clínica', problema: 'Usar IA no dia a dia sem expor prontuário ou dados de paciente.', ajuda: 'Mostra como usar IA com os dados protegidos e revisão humana antes de qualquer orientação sensível.' },
                    { icon: '🧾', area: 'Contador', problema: 'Dados fiscais, CPF e CNPJ passam por muitas tarefas repetitivas.', ajuda: 'Ajuda a organizar as informações para análise sem tratar dado sensível como texto comum.' },
                    { icon: '🍽️', area: 'Comércio / Restaurante', problema: 'Cardápio e catálogo vivem em foto, papel ou mensagem de WhatsApp.', ajuda: 'Transforma a foto do cardápio ou catálogo em planilha pronta — com conferência humana antes de cadastrar.' },
                    { icon: '📚', area: 'Professor', problema: 'IA cria material bonito, mas às vezes com erro ou fonte fraca.', ajuda: 'Organiza aulas, exercícios e resumos com pontos de conferência antes de usar com os alunos.' },
                    { icon: '🌾', area: 'Agrônomo', problema: 'Laudos de solo, orientações de plantio e relatórios de campo exigem cuidado.', ajuda: 'Um assistente da área que organiza as informações e destaca o que precisa ser validado por um profissional.' },
                  ].map((c) => (
                    <div key={c.area} className="card" style={{ padding: '28px' }}>
                      <div style={{ fontSize: '28px', marginBottom: '12px' }}>{c.icon}</div>
                      <h3 className="h3" style={{ marginBottom: '8px' }}>{c.area}</h3>
                      <p style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.6, marginBottom: '10px' }}>{c.problema}</p>
                      <p style={{ fontSize: '14px', color: 'var(--text-strong)', lineHeight: 1.6 }}>{c.ajuda}</p>
                    </div>
                  ))}
                </div>
              </section>

              {/* ── Comece aqui — grátis em 2 minutos ── */}
              <section id="comece" style={{ margin: '56px 0' }}>
                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
                  <h2 className="h2">Comece aqui</h2>
                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
                    Três artefatos prontos para usar hoje no ChatGPT, Claude ou Gemini.
                  </p>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px', alignItems: 'start' }}>

                  {/* Bloco 1 — Metaprompt */}
                  <div className="card" style={{ padding: '28px' }}>
                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>01</span>
                    <h3 className="h3" style={{ marginBottom: '8px' }}>Metaprompt: Assistente Profissional Governado</h3>
                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
                      Cole no campo de instruções do ChatGPT (ou system prompt do Claude/Gemini) e troque os <code style={{ background: 'var(--bg-deep)', padding: '1px 4px', borderRadius: '3px' }}>[colchetes]</code>. Pronto.
                    </p>
                    <div style={{
                      position: 'relative',
                      background: 'var(--bg-deep)',

exec
/bin/bash -lc "sed -n '180,360p' apps/egos-landing/src/App.tsx" in /home/enio/egos
 succeeded in 0ms:
  const handleInspectText = async () => {
    if (!inspectInput.trim()) return
    setInspectLoading(true)
    setInspectError('')
    setInspectResult(null)
    try {
      const headers: Record<string, string> = { 'Content-Type': 'application/json' }
      if (apiKey) {
        headers['Authorization'] = `Bearer ${apiKey}`
      }
      const res = await fetch('https://api.egos.ia.br/v1/inspect', {
        method: 'POST',
        headers,
        body: JSON.stringify({ content: inspectInput })
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.error || 'Erro na inspeção')
      setInspectResult(data)
    } catch (err: any) {
      setInspectError(err.message || 'Erro de rede ou permissão')
    } finally {
      setInspectLoading(false)
    }
  }

  const handleGenerateGrokPrompt = async () => {
    if (!grokTopic.trim()) return
    setGrokLoading(true)
    try {
      const res = await fetch('https://api.egos.ia.br/api/v1/meta-prompts/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: 'grok', task: grokTopic })
      })
      const data = await res.json()
      if (data.prompt) {
        setGrokPrompt(data.prompt)
      } else {
        throw new Error(data.error || 'Erro ao gerar prompt')
      }
    } catch (err: any) {
      alert(err.message || 'Erro ao comunicar com a API do Meta-Prompt')
    } finally {
      setGrokLoading(false)
    }
  }

  // Dynamic Routing Handler
  useEffect(() => {
    const handleRouteChange = () => {
      const hash = window.location.hash
      if (hash.startsWith('#/timeline/')) {
        const slug = hash.replace('#/timeline/', '')
        setCurrentRoute('timeline')
        setSelectedArticleSlug(slug)
      } else if (hash === '#/timeline') {
        setCurrentRoute('timeline')
        setSelectedArticleSlug(null)
      } else if (hash === '#/showcase') {
        setCurrentRoute('showcase')
        setSelectedArticleSlug(null)
      } else if (hash === '#/transparencia') {
        setCurrentRoute('transparencia')
        setSelectedArticleSlug(null)
      } else if (hash === '#/guard') {
        setCurrentRoute('guard')
        setSelectedArticleSlug(null)
      } else if (hash === '#/grok') {
        setCurrentRoute('grok')
        setSelectedArticleSlug(null)
      } else if (hash === '#/mycelium') {
        setCurrentRoute('mycelium')
        setSelectedArticleSlug(null)
      } else if (hash === '#/tools') {
        setCurrentRoute('tools')
        setSelectedArticleSlug(null)
      } else {
        setCurrentRoute('home')
        setSelectedArticleSlug(null)
      }
    }

    window.addEventListener('hashchange', handleRouteChange)
    handleRouteChange() // initial run

    return () => window.removeEventListener('hashchange', handleRouteChange)
  }, [])

  // Mobile resize listener
  useEffect(() => {
    const handleResize = () => {
      const mobile = window.innerWidth < 768
      setIsMobile(mobile)
      if (!mobile) setDrawerOpen(false)
    }
    window.addEventListener('resize', handleResize)
    return () => window.removeEventListener('resize', handleResize)
  }, [])

  // Fetch all articles when route is 'timeline' and no slug is selected
  useEffect(() => {
    if (currentRoute === 'timeline' && !selectedArticleSlug) {
      setLoadingArticles(true)
      supabase
        .from('timeline_articles')
        .select('slug, title, body_html, published_at, epistemic_status, tags, word_count, lang')
        .eq('lang', 'pt-br')
        .order('published_at', { ascending: false })
        .then(({ data, error }) => {
          if (!error && data) {
            setArticles(data as Article[])
          }
          setLoadingArticles(false)
        })
    }
  }, [currentRoute, selectedArticleSlug])

  // Fetch single article details when slug changes
  useEffect(() => {
    if (selectedArticleSlug) {
      setLoadingSingle(true)
      supabase
        .from('timeline_articles')
        .select('*')
        .eq('slug', selectedArticleSlug)
        .eq('lang', 'pt-br')
        .maybeSingle()
        .then(({ data, error }) => {
          if (!error && data) {
            setSelectedArticle(data as Article)
          } else {
            setSelectedArticle(null)
          }
          setLoadingSingle(false)
        })
    } else {
      setSelectedArticle(null)
    }
  }, [selectedArticleSlug])

  // Guard Brasil PII Simulator logic
  useEffect(() => {
    if (!inputText) {
      setMaskedText('')
      setDetectedPII([])
      return
    }

    let tempText = inputText
    const piiFound: string[] = []

    // 1. CPF (###.###.###-##)
    const cpfRegex = /\b\d{3}\.\d{3}\.\d{3}-\d{2}\b/g
    if (cpfRegex.test(tempText)) {
      piiFound.push('CPF detectado')
      tempText = tempText.replace(cpfRegex, '[CPF MASCARADO]')
    }

    // 2. CNPJ (##.###.###/####-##)
    const cnpjRegex = /\b\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}\b/g
    if (cnpjRegex.test(tempText)) {
      piiFound.push('CNPJ detectado')
      tempText = tempText.replace(cnpjRegex, '[CNPJ MASCARADO]')
    }

    // 3. Email
    const emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g
    if (emailRegex.test(tempText)) {
      piiFound.push('E-mail detectado')
      tempText = tempText.replace(emailRegex, '[E-MAIL MASCARADO]')
    }

    // 4. Telefone
    const phoneRegex = /\b(?:\+?55\s?)?(?:\(?\d{2}\)?\s?)?\d{4,5}-\d{4}\b/g
    if (phoneRegex.test(tempText)) {
      piiFound.push('Telefone detectado')
      tempText = tempText.replace(phoneRegex, '[TELEFONE MASCARADO]')
    }

    setMaskedText(tempText)
    setDetectedPII(piiFound)

exec
/bin/bash -lc "rg \"last_value|tolerance|\\.egos-manifest\" scripts packages -n | head -120" in /home/enio/egos
 succeeded in 0ms:
scripts/manifest-generator.ts:5: * Auto-generates or updates .egos-manifest.yaml from a repo's README.md
scripts/manifest-generator.ts:61:    tolerance: string;
scripts/manifest-generator.ts:62:    last_value: string;
scripts/manifest-generator.ts:303:  const manifestPath = join(repoDir, ".egos-manifest.yaml");
scripts/manifest-generator.ts:325:        tolerance: "±10%",
scripts/manifest-generator.ts:326:        last_value: claim.value,
scripts/manifest-generator.ts:376:    console.log(`  [dry] Would write ${manifest.claims.length} claims to .egos-manifest.yaml`);
scripts/manifest-generator.ts:380:  const manifestPath = join(repoDir, ".egos-manifest.yaml");
scripts/manifest-generator.ts:381:  const header = `# .egos-manifest.yaml — ${manifest.repo}\n# Auto-generated/updated by manifest-generator.ts (DRIFT-011)\n# Full spec: /home/enio/egos/docs/DOC_DRIFT_SHIELD.md\n\n`;
scripts/evidence-gate.ts:8: *   docs/agents/, and CAPABILITY_REGISTRY.md — not just .egos-manifest.yaml.
scripts/evidence-gate.ts:54:  /\.egos-manifest\.yaml/,
scripts/evidence-gate.ts:279:  console.log("  1. Add <!-- evidence: <claim-id> --> pointing to a claim in .egos-manifest.yaml");
packages/shared/src/__tests__/rate-limiter.test.ts:70:    expect(elapsed).toBeGreaterThanOrEqual(50); // Allow some tolerance
scripts/system-map-gen.ts:89:*Validação: \`bun scripts/system-map-gen.ts --check\` (axis/status/depends_on). Dono da não-degradação: doc-drift shield (\`.egos-manifest.yaml\` claim \`operating_surface_entries\`).*
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:653:| L1 | `.egos-manifest.yaml` per repo | Manual + generator | claim contracts |
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:661:- **`readme-syncer`** — patches `<!-- metric:ID -->` annotations from manifest `last_value`

exec
/bin/bash -lc "rg \"expected_status|readme_location|last_verified_at|tolerance\" -n . --glob '"'!node_modules'"' --glob '"'!**/.git/**'"' | head -200" in /home/enio/egos
 succeeded in 0ms:
./agents/agents/doc-drift-analyzer.ts:156:      `High-drift claim: \`${topDriftingClaims[0].claimId}\` drifted ${topDriftingClaims[0].driftCount}x — consider loosening tolerance`
./agents/agents/doc-drift-sentinel.ts:56:  tolerance: string;
./agents/agents/doc-drift-sentinel.ts:65:  expected_status: string;
./agents/agents/doc-drift-sentinel.ts:235:  const manifest = parseYaml(content) as { claims?: Array<{ id: string; last_value: string; last_verified_at: string }> };
./agents/agents/doc-drift-sentinel.ts:242:      claim.last_verified_at = today;
./agents/agents/doc-drift-sentinel.ts:329:      : "exceeds tolerance";
./agents/agents/doc-drift-sentinel.ts:337:    `**Drift:** ${claim.last_value} → ${claim.current_value} (tolerance: ${claim.tolerance})`,
./agents/agents/doc-drift-sentinel.ts:446:        console.log(`     - ${c.id}: ${c.last_value} → ${c.current_value} (${c.tolerance})`);
./agents/agents/doc-drift-sentinel.ts:473:              : "exceeded tolerance";
./agents/agents/doc-drift-sentinel.ts:498:        console.log(`     - ${d.url}: expected ${d.expected_status} got ${d.actual_status}`);
./agents/agents/doc-drift-sentinel.ts:504:        ...domainFails.map((d) => `URL: \`${d.url}\` — expected ${d.expected_status}, got ${d.actual_status}`),
./docs/jobs/2026-05-15-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/2026-05-15-doc-drift-verifier.json:32:      "tolerance": "±5",
./docs/jobs/2026-05-15-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/2026-05-15-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/2026-05-15-doc-drift-verifier.json:65:      "tolerance": "±3",
./docs/jobs/2026-05-15-doc-drift-verifier.json:76:      "tolerance": "min:50",
./docs/jobs/2026-05-15-doc-drift-verifier.json:86:      "tolerance": "min:6",
./docs/jobs/2026-05-15-doc-drift-verifier.json:96:      "tolerance": "min:4",
./docs/jobs/2026-05-15-doc-drift-verifier.json:107:      "tolerance": "min:5",
./docs/jobs/2026-05-15-doc-drift-verifier.json:117:      "tolerance": "min:10",
./docs/jobs/2026-05-15-doc-drift-verifier.json:127:      "tolerance": "min:2",
./docs/jobs/2026-05-15-doc-drift-verifier.json:137:      "tolerance": "min:1",
./docs/jobs/2026-05-15-doc-drift-verifier.json:147:      "tolerance": "eq:2",
./docs/jobs/2026-05-15-doc-drift-verifier.json:157:      "tolerance": "min:2",
./docs/jobs/2026-05-15-doc-drift-verifier.json:167:      "tolerance": "min:15",
./docs/jobs/2026-05-15-doc-drift-verifier.json:176:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:182:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:188:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:194:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:200:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:206:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:212:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:219:      "expected_status": "200",
./docs/jobs/2026-05-15-doc-drift-verifier.json:225:      "expected_status": "undefined",
./agents/agents/gem-hunter.ts:301:      "quantum-inspired software architecture fault tolerance",
./docs/jobs/2026-05-05-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/2026-05-05-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/2026-05-05-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/2026-05-05-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/2026-05-05-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/2026-05-05-doc-drift-verifier.json:76:      "tolerance": "min:50",
./docs/jobs/2026-05-05-doc-drift-verifier.json:86:      "tolerance": "min:6",
./docs/jobs/2026-05-05-doc-drift-verifier.json:96:      "tolerance": "min:8",
./docs/jobs/2026-05-05-doc-drift-verifier.json:106:      "tolerance": "min:5",
./docs/jobs/2026-05-05-doc-drift-verifier.json:116:      "tolerance": "min:10",
./docs/jobs/2026-05-05-doc-drift-verifier.json:126:      "tolerance": "min:2",
./docs/jobs/2026-05-05-doc-drift-verifier.json:136:      "tolerance": "min:1",
./docs/jobs/2026-05-05-doc-drift-verifier.json:146:      "tolerance": "eq:2",
./docs/jobs/2026-05-05-doc-drift-verifier.json:156:      "tolerance": "min:2",
./docs/jobs/2026-05-05-doc-drift-verifier.json:166:      "tolerance": "min:15",
./docs/jobs/2026-05-05-doc-drift-verifier.json:175:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:181:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:187:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:193:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:199:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:205:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:211:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:218:      "expected_status": "200",
./docs/jobs/2026-05-05-doc-drift-verifier.json:224:      "expected_status": "undefined",
./docs/jobs/2026-06-01-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/2026-06-01-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/2026-06-01-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/2026-06-01-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/2026-06-01-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/2026-06-01-doc-drift-verifier.json:76:      "tolerance": "min:50",
./docs/jobs/2026-06-01-doc-drift-verifier.json:86:      "tolerance": "min:6",
./docs/jobs/2026-06-01-doc-drift-verifier.json:96:      "tolerance": "min:1",
./docs/jobs/2026-06-01-doc-drift-verifier.json:107:      "tolerance": "min:5",
./docs/jobs/2026-06-01-doc-drift-verifier.json:117:      "tolerance": "min:10",
./docs/jobs/2026-06-01-doc-drift-verifier.json:127:      "tolerance": "min:2",
./docs/jobs/2026-06-01-doc-drift-verifier.json:137:      "tolerance": "min:1",
./docs/jobs/2026-06-01-doc-drift-verifier.json:147:      "tolerance": "eq:2",
./docs/jobs/2026-06-01-doc-drift-verifier.json:157:      "tolerance": "min:2",
./docs/jobs/2026-06-01-doc-drift-verifier.json:167:      "tolerance": "min:15",
./docs/jobs/2026-06-01-doc-drift-verifier.json:176:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:182:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:188:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:194:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:200:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:206:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:212:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:219:      "expected_status": "200",
./docs/jobs/2026-06-01-doc-drift-verifier.json:225:      "expected_status": "undefined",
./agents/agents/doc-drift-verifier.ts:6: * against declared tolerances, and outputs a verification report.
./agents/agents/doc-drift-verifier.ts:35:  readme_location?: string;
./agents/agents/doc-drift-verifier.ts:37:  tolerance: string; // "exact" | "±N" | "±N%" | "min:N" | "max:N"
./agents/agents/doc-drift-verifier.ts:39:  last_verified_at?: string;
./agents/agents/doc-drift-verifier.ts:45:  expected_status: string;
./agents/agents/doc-drift-verifier.ts:52:  expected_status: string;
./agents/agents/doc-drift-verifier.ts:77:  tolerance: string;
./agents/agents/doc-drift-verifier.ts:88:  expected_status: string;
./agents/agents/doc-drift-verifier.ts:309:function evaluateTolerance(lastVal: string, currentVal: string, tolerance: string): ToleranceResult {
./agents/agents/doc-drift-verifier.ts:313:  if (tolerance === "exact") {
./agents/agents/doc-drift-verifier.ts:318:  if (tolerance.startsWith("min:")) {
./agents/agents/doc-drift-verifier.ts:319:    const min = parseFloat(tolerance.slice(4));
./agents/agents/doc-drift-verifier.ts:324:  if (tolerance.startsWith("max:")) {
./agents/agents/doc-drift-verifier.ts:325:    const max = parseFloat(tolerance.slice(4));
./agents/agents/doc-drift-verifier.ts:330:  if (tolerance.endsWith("%")) {
./agents/agents/doc-drift-verifier.ts:331:    const pct = parseFloat(tolerance.replace("±", "").replace("%", ""));
./agents/agents/doc-drift-verifier.ts:339:  if (tolerance.startsWith("±")) {
./agents/agents/doc-drift-verifier.ts:340:    const allowedAbs = parseFloat(tolerance.slice(1));
./agents/agents/doc-drift-verifier.ts:347:  if (tolerance.startsWith("eq:")) {
./agents/agents/doc-drift-verifier.ts:348:    const expected = tolerance.slice(3).trim();
./agents/agents/doc-drift-verifier.ts:353:  // Unknown tolerance format
./agents/agents/doc-drift-verifier.ts:402:    const expectedStatus = String(domain.expected_status);
./agents/agents/doc-drift-verifier.ts:416:      expected_status: expectedStatus,
./agents/agents/doc-drift-verifier.ts:424:      expected_status: String(domain.expected_status),
./agents/agents/doc-drift-verifier.ts:473:        tolerance: claim.tolerance,
./agents/agents/doc-drift-verifier.ts:483:    const tolResult = evaluateTolerance(claim.last_value, currentValue, claim.tolerance);
./agents/agents/doc-drift-verifier.ts:509:      tolerance: claim.tolerance,
./agents/agents/doc-drift-verifier.ts:523:      console.error(`  ${icon} ${domain.url} → ${result.actual_status} (expected ${result.expected_status})`);
./agents/agents/doc-drift-verifier.ts:589:      return `| \`${r.id}\` | ${icon} ${r.status} | ${r.last_value} | ${r.current_value || "-"} | \`${r.tolerance}\` | ${drift} |`;
./agents/agents/doc-drift-verifier.ts:602:        return `| ${d.url} | ${d.expected_status} | ${d.actual_status} | ${icon} |`;
./agents/agents/doc-drift-verifier.ts:628:      console.log(`     ❌ ${r.id}: ${r.last_value} → ${r.current_value} ${drift} [tolerance: ${r.tolerance}]`);
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:75:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:81:      "expected_status": "307",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:87:      "expected_status": "502",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:93:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:99:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:105:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:111:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:117:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:124:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:130:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:136:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:142:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:148:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-12-doc-drift-verifier.json:154:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:76:      "tolerance": "min:50",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:86:      "tolerance": "min:6",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:96:      "tolerance": "min:100",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:106:      "tolerance": "min:5",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:116:      "tolerance": "min:10",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:126:      "tolerance": "min:2",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:136:      "tolerance": "min:1",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:146:      "tolerance": "eq:2",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:156:      "tolerance": "min:2",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:166:      "tolerance": "min:15",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:175:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:181:      "expected_status": "307",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:187:      "expected_status": "502",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:193:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:199:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:205:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:211:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:217:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-16-doc-drift-verifier.json:224:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:76:      "tolerance": "min:50",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:86:      "tolerance": "min:6",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:96:      "tolerance": "min:100",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:106:      "tolerance": "min:5",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:116:      "tolerance": "min:10",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:126:      "tolerance": "min:2",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:136:      "tolerance": "min:1",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:146:      "tolerance": "eq:2",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:156:      "tolerance": "min:2",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:166:      "tolerance": "min:15",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:175:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:181:      "expected_status": "307",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:187:      "expected_status": "502",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:194:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:200:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:206:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:212:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:218:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-28-doc-drift-verifier.json:225:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:22:      "tolerance": "min:18",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:32:      "tolerance": "±10",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:43:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:54:      "tolerance": "±5",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:65:      "tolerance": "±2",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:75:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:81:      "expected_status": "307",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:87:      "expected_status": "502",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:93:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:99:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:105:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:111:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:117:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:124:      "expected_status": "200",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:130:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:136:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:142:      "expected_status": "undefined",
./docs/jobs/_archived/2026-04/2026-04-10-doc-drift-verifier.json:148:      "expected_status": "undefined",

exec
/bin/bash -lc "sed -n '430,500p' agents/agents/doc-drift-verifier.ts && sed -n '300,330p' agents/agents/doc-drift-verifier.ts" in /home/enio/egos
 succeeded in 0ms:

// ─── Manifest verifier ────────────────────────────────────────────────────────

async function verifyManifest(manifestPath: string, opts: { failOnDrift: boolean }): Promise<VerificationReport> {
  const repoDir = dirname(manifestPath);

  let content: string;
  try {
    content = await Bun.file(manifestPath).text();
  } catch {
    console.error(`[doc-drift] ERROR: Cannot read manifest: ${manifestPath}`);
    process.exit(2);
  }

  const manifest = parseYaml(content) as Manifest;

  if (!manifest || typeof manifest !== "object") {
    console.error(`[doc-drift] ERROR: Invalid manifest YAML: ${manifestPath}`);
    process.exit(2);
  }

  const claims: ManifestClaim[] = manifest.claims ?? [];
  const domains: (ManifestDomain | ManifestEndpoint)[] = [
    ...(manifest.domains ?? []),
    ...(manifest.endpoints ?? []),
  ];

  const results: ClaimResult[] = [];
  const domainResults: DomainResult[] = [];

  // ── Run claim commands ──
  console.error(`\n[doc-drift] Verifying ${claims.length} claims in ${manifest.repo ?? "?"} ...`);

  for (const claim of claims) {
    const { output, error, exitCode } = await runCommand(claim.command, repoDir);

    if (exitCode !== 0 || output === "") {
      results.push({
        id: claim.id,
        description: claim.description,
        status: "error",
        last_value: claim.last_value,
        current_value: "",
        tolerance: claim.tolerance,
        command: claim.command,
        error: error || `exit code ${exitCode}`,
        severity: "error",
      });
      console.error(`  [error] ${claim.id}: command failed — ${error.slice(0, 80)}`);
      continue;
    }

    const currentValue = output.trim();
    const tolResult = evaluateTolerance(claim.last_value, currentValue, claim.tolerance);

    const severity =
      tolResult.status === "ok" ? "ok"
      : tolResult.status === "warn" ? "warn"
      : tolResult.status === "drifted" ? "drift"
      : "error";

    const icon =
      tolResult.status === "ok" ? "✅"
      : tolResult.status === "warn" ? "⚠️"
      : tolResult.status === "drifted" ? "❌"
      : "💥";

    console.error(
      `  ${icon} ${claim.id}: ${claim.last_value} → ${currentValue}` +
      (tolResult.drift_abs !== undefined ? ` (Δ${tolResult.drift_abs})` : "") +
      (tolResult.drift_pct !== undefined ? ` (${tolResult.drift_pct.toFixed(1)}%)` : "")

// ─── Tolerance evaluation ─────────────────────────────────────────────────────

interface ToleranceResult {
  status: ClaimStatus;
  drift_abs?: number;
  drift_pct?: number;
}

function evaluateTolerance(lastVal: string, currentVal: string, tolerance: string): ToleranceResult {
  const last = parseFloat(lastVal);
  const current = parseFloat(currentVal);

  if (tolerance === "exact") {
    if (lastVal.trim() === currentVal.trim()) return { status: "ok" };
    return { status: "drifted", drift_abs: Math.abs(current - last) };
  }

  if (tolerance.startsWith("min:")) {
    const min = parseFloat(tolerance.slice(4));
    if (current >= min) return { status: "ok" };
    return { status: "drifted", drift_abs: min - current };
  }

  if (tolerance.startsWith("max:")) {
    const max = parseFloat(tolerance.slice(4));
    if (current <= max) return { status: "ok" };
    return { status: "drifted", drift_abs: current - max };
  }

  if (tolerance.endsWith("%")) {

exec
/bin/bash -lc "grep -c '"'^- '"\\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md; grep -c '"'^- '"\\[x\\]' TASKS.md || echo 0" in /home/enio/egos
 succeeded in 0ms:
23
0
0

exec
/bin/bash -lc 'bun agents/agents/doc-drift-verifier.ts --manifest .egos-manifest.yaml --fail-on-drift' in /home/enio/egos
 exited 1 in 11834ms:

[doc-drift] Verifying 17 claims in egos ...
  ✅ total_agents: 27 → 27
  ✅ total_capabilities: 168 → 168 (Δ0)
  ✅ guarani_governance_files: 97 → 97 (Δ0)
  ✅ slash_commands: 61 → 61 (Δ0)
  ✅ operating_surface_entries: 35 → 35 (Δ0)
  ✅ kernel_packages: 36 → 37 (Δ1)
  ✅ commits_30d_all_repos: 1466 → 1264
  ✅ unique_differentials: 22 → 22
  ❌ completed_tasks_total: 1 → 0
0 (Δ1)
  ✅ active_products: 7 → 7
  ✅ capability_registry_sections: 19 → 97
  ✅ evg008_simplicity_check_function: 2 → 2
  ✅ karpathy_principles_in_global_claude: 1 → 1
  ✅ disseminate_pipeline_scripts: 2 → 2
  ✅ evidence_gate_blocking_schedule: 2 → 2
  ✅ pre_commit_hook_chain_stages: 70 → 168
  ✅ cross_repo_capabilities: 28 → 23

[doc-drift] Checking 8 domain(s) ...
  ✅ https://guard.egos.ia.br/health → 200 (expected 200)
  ✅ https://hq.egos.ia.br/ → 200 (expected 200)
  ✅ https://gemhunter.egos.ia.br/gem-hunter/topics → 301 (expected 301)
  ✅ https://eagleeye.egos.ia.br/ → 200 (expected 200)
  ✅ https://852.egos.ia.br/ → 200 (expected 200)
  ✅ https://inteligencia.egos.ia.br/ → 200 (expected 200)
  ✅ https://guard.egos.ia.br/health → 200 (expected 200)
  ✅ https://gemhunter.egos.ia.br/gem-hunter/topics → 301 (expected 301)

❌ Doc-Drift Verification — egos
   Claims: 16/17 passed | 1 drifted | 0 errors
   Domains: 8/8 reachable

   Drifted claims:
     ❌ completed_tasks_total: 1 → 0
0 (Δ1) [tolerance: min:1]

exec
/bin/bash -lc "ls packages/pii-purge/src && sed -n '1,220p' packages/pii-purge/src/cli.ts" in /home/enio/egos
 succeeded in 0ms:
cli.ts
dictionary.ts
patterns.ts
pii-purge.test.ts
purge.ts
scanner.ts
verify.ts
#!/usr/bin/env bun
/**
 * CLI — pii-purge
 *
 * Usage:
 *   bun packages/pii-purge/src/cli.ts \
 *     --entity-dict <path-to-dict.json> \
 *     --target <directory> \
 *     [--apply] \
 *     [--json]
 *
 * Defaults to --dry-run (safe). Writing requires explicit --apply.
 * Exits 1 if: verify fails OR REVIEW_REQUIRED findings remain (blocks publish).
 *
 * NEVER prints matched values (T0 §3).
 */

import { loadDictionary } from './dictionary.js';
import { generateAllPatterns } from './patterns.js';
import { scanDirectory, scanDirectoryLiteral, flattenEntityValues } from './scanner.js';
import { buildTokenMap, runPurge } from './purge.js';
import { verify } from './verify.js';
import { resolve, dirname } from 'node:path';
import { mkdirSync } from 'node:fs';

// ─── Arg parsing ──────────────────────────────────────────────────────────────

function parseArgs(argv: string[]): {
  entityDict: string;
  target: string;
  apply: boolean;
  json: boolean;
  verifyOnly: boolean;
} {
  const args: Record<string, string | boolean> = {};
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i]!;
    if (arg === '--apply') { args['apply'] = true; }
    else if (arg === '--dry-run') { args['dry-run'] = true; }
    else if (arg === '--json') { args['json'] = true; }
    else if (arg === '--verify-only') { args['verify-only'] = true; }
    else if (arg.startsWith('--')) {
      const key = arg.slice(2);
      args[key] = argv[i + 1] ?? true;
      i++;
    }
  }

  const entityDict = args['entity-dict'];
  const target = args['target'];

  if (!entityDict || typeof entityDict !== 'string') {
    console.error('[pii-purge] ERROR: --entity-dict <path> is required');
    process.exit(1);
  }
  if (!target || typeof target !== 'string') {
    console.error('[pii-purge] ERROR: --target <directory> is required');
    process.exit(1);
  }

  return {
    entityDict: resolve(entityDict),
    target: resolve(target),
    apply: args['apply'] === true,
    json: args['json'] === true,
    verifyOnly: args['verify-only'] === true,
  };
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const opts = parseArgs(process.argv.slice(2));
  const mode = opts.apply ? 'apply' : 'dry-run';

  if (!opts.json) {
    console.log(`[pii-purge] mode=${mode} dict=${opts.entityDict} target=${opts.target}`);
  }

  // 1. Load dictionary
  const dict = await loadDictionary(opts.entityDict);
  if (!opts.json) {
    console.log(`[pii-purge] Loaded ${dict.entities.length} entities`);
  }

  // 2. Generate patterns + flatten raw values (literal safety net — VERIFY-001)
  const patterns = generateAllPatterns(dict.entities);
  const literalValues = flattenEntityValues(dict.entities);

  // 2b. --verify-only (publish gate): scan + literal scan, NO purge, exit 1 if anything found.
  // Wire this into pre-commit / publish paths (R-SEC-005) to block on known entities.
  if (opts.verifyOnly) {
    const patternHits = (await scanDirectory(opts.target, patterns, opts.entityDict)).filter(f => f.matchType !== 'fuzzy-REVIEW');
    const literalHits = await scanDirectoryLiteral(opts.target, literalValues, opts.entityDict);
    const total = patternHits.length + literalHits.length;
    if (opts.json) {
      console.log(JSON.stringify({
        mode: 'verify-only',
        clean: total === 0,
        findings: [...patternHits, ...literalHits].map(f => ({
          file: f.file, line: f.line, entityId: f.entityId, type: f.type, matchType: f.matchType,
        })),
      }, null, 2));
    } else if (total === 0) {
      console.log('[pii-purge] VERIFY-ONLY: clean — zero known-entity findings');
    } else {
      console.error(`[pii-purge] VERIFY-ONLY FAILED: ${total} known-entity finding(s) remain`);
      for (const f of [...patternHits, ...literalHits]) {
        console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}`);
      }
    }
    process.exit(total === 0 ? 0 : 1);
  }

  // 3. Scan
  const findings = await scanDirectory(opts.target, patterns, opts.entityDict);

  const autoFindings = findings.filter(f => f.matchType !== 'fuzzy-REVIEW');
  const reviewFindings = findings.filter(f => f.matchType === 'fuzzy-REVIEW');

  if (!opts.json) {
    console.log(`[pii-purge] Scan complete: ${findings.length} total findings`);
    console.log(`  auto-purgeable: ${autoFindings.length}`);
    console.log(`  REVIEW_REQUIRED (fuzzy): ${reviewFindings.length}`);
    for (const f of findings) {
      // NEVER print matched value — only metadata
      const flag = f.matchType === 'fuzzy-REVIEW' ? ' [REVIEW_REQUIRED]' : '';
      console.log(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type} matchType=${f.matchType}${flag}`);
    }
  }

  // 4. Build token map
  const tokenMap = buildTokenMap(dict.entities);

  // 5. Purge (or dry-run)
  const auditLogDir = dirname(opts.entityDict);
  mkdirSync(auditLogDir, { recursive: true });

  const purgeResult = await runPurge(findings, tokenMap, mode, auditLogDir);

  if (!opts.json) {
    if (mode === 'dry-run') {
      console.log(`[pii-purge] DRY-RUN: would modify ${purgeResult.planned.length} file(s)`);
      for (const p of purgeResult.planned) {
        console.log(`  ${p.file} → ${p.findingsCount} replacement(s) with ${p.token}`);
      }
    } else {
      console.log(`[pii-purge] APPLIED to ${purgeResult.applied.length} file(s)`);
      if (purgeResult.auditLogPath) {
        console.log(`[pii-purge] Audit log: ${purgeResult.auditLogPath}`);
      }
    }
  }

  // 6. Verify (only in apply mode — meaningful post-write)
  let verifyResult = { cleanExit: true, remaining: [] as typeof findings, reviewRequired: reviewFindings };
  if (mode === 'apply') {
    verifyResult = await verify(opts.target, patterns, literalValues, opts.entityDict);
    if (!opts.json) {
      if (verifyResult.cleanExit) {
        console.log('[pii-purge] VERIFY: clean — zero auto-purgeable findings remain');
      } else {
        console.error(`[pii-purge] VERIFY FAILED: ${verifyResult.remaining.length} auto-purgeable finding(s) remain`);
        for (const f of verifyResult.remaining) {
          console.error(`  ${f.file}:${f.line} entity=${f.entityId} type=${f.type}`);
        }
      }
    }
  }

  if (opts.json) {
    console.log(JSON.stringify({
      mode,
      findings: findings.map(f => ({
        file: f.file,
        line: f.line,
        entityId: f.entityId,
        type: f.type,
        matchType: f.matchType,
        // matched value intentionally omitted (T0 §3)
      })),
      planned: purgeResult.planned,
      applied: purgeResult.applied,
      skippedFuzzy: purgeResult.skippedFuzzy,
      verifyCleanExit: verifyResult.cleanExit,
      reviewRequiredCount: verifyResult.reviewRequired.length,
      auditLogPath: purgeResult.auditLogPath ?? null,
    }, null, 2));
  }

  // 7. Exit code
  const hasFuzzy = verifyResult.reviewRequired.length > 0;
  const hasRemaining = !verifyResult.cleanExit;

  if (hasFuzzy || hasRemaining) {
    if (!opts.json) {
      if (hasFuzzy) {
        console.warn(`[pii-purge] ${verifyResult.reviewRequired.length} REVIEW_REQUIRED finding(s) — resolve manually before publishing`);
      }
    }
    process.exit(1);
  }

  process.exit(0);
}

main().catch(err => {
  console.error('[pii-purge] Fatal error:', err instanceof Error ? err.message : String(err));
  process.exit(1);
});

exec
/bin/bash -lc 'cat apps/egos-landing/package.json 2>/dev/null || cat package.json | head -80' in /home/enio/egos
 succeeded in 0ms:
{
  "name": "egos-landing",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "bun run scripts/generate-rss.ts && tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.107.0",
    "react": "^19.2.6",
    "react-dom": "^19.2.6"
  },
  "devDependencies": {
    "@eslint/js": "^10.0.1",
    "@types/node": "^24.12.3",
    "@types/react": "^19.2.14",
    "@types/react-dom": "^19.2.3",
    "@vitejs/plugin-react": "^6.0.1",
    "eslint": "^10.3.0",
    "eslint-plugin-react-hooks": "^7.1.1",
    "eslint-plugin-react-refresh": "^0.5.2",
    "globals": "^17.6.0",
    "typescript": "~6.0.2",
    "typescript-eslint": "^8.59.2",
    "vite": "^8.0.12"
  }
}

exec
/bin/bash -lc 'bun run build' in /home/enio/egos/apps/egos-landing
 succeeded in 6729ms:
$ bun run scripts/generate-rss.ts && tsc -b && vite build
📡 Buscando artigos no Supabase para gerar o RSS feed...
✅ RSS feed gerado com sucesso em public/timeline/rss!
vite v8.0.16 building client environment for production...
[2Ktransforming...✓ 65 modules transformed.
rendering chunks...
computing gzip size...
dist/index.html                   1.06 kB │ gzip:   0.58 kB
dist/assets/index-B66jEp7s.css    7.12 kB │ gzip:   2.12 kB
dist/assets/index-CQ1A26w1.js   475.83 kB │ gzip: 132.59 kB

✓ built in 282ms

exec
/bin/bash -lc 'git status --short' in /home/enio/egos
 succeeded in 0ms:
 M .egos-manifest.yaml
 M apps/egos-landing/public/timeline/rss
 M apps/egos-landing/public/timeline/rss.xml
 M docs/knowledge/HARVEST.md
M  docs/strategy/APRESENTACAO_EGOS.md
M  scripts/visual-audit.ts
?? docs/jobs/2026-06-07-doc-drift-verifier.json
?? docs/jobs/2026-06-07-pre-commit-pipeline.json
?? docs/jobs/2026-06-08-doc-drift-verifier.json
?? docs/strategy/landing-copy-v2-pessoa-comum.md

exec
/bin/bash -lc "sed -n '1,260p' .egos-manifest.yaml && sed -n '380,430p' agents/agents/doc-drift-verifier.ts" in /home/enio/egos
 succeeded in 0ms:
# EGOS Kernel — Doc-Drift Manifest
# Schema: docs/DOC_DRIFT_SHIELD.md
# This file declares every quantitative claim in README.md as a reproducible contract.

schema_version: "1.0.0"
repo: "egos"
updated_at: "2026-04-29"
updated_by: "enioxt"
manifest_doc: "docs/DOC_DRIFT_SHIELD.md"

claims:
  - id: total_agents
    description: "Agents registered in agents.json"
    readme_location: "CLAUDE.md / AGENTS.md"
    command: "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\""
    tolerance: "min:18"
    last_value: "27"
    last_verified_at: "2026-06-01"
    category: "integrations"

  - id: total_capabilities
    description: "Capabilities declared in CAPABILITY_REGISTRY.md"
    readme_location: "docs/CAPABILITY_REGISTRY.md"
    command: "grep -c '^### ' docs/CAPABILITY_REGISTRY.md"
    tolerance: "±10"
    last_value: "168"
    last_verified_at: "2026-05-28"
    category: "custom"
    note: "REG-PARITY-BACKFILL-001 — §90-§100 added (11 entries from grace) 2026-05-28"

  - id: guarani_governance_files
    description: "Governance rule files in .guarani/"
    readme_location: "CLAUDE.md §5"
    command: "find .guarani/ -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '"
    tolerance: "±5"
    last_value: "97"
    last_verified_at: "2026-06-01"
    category: "custom"

  - id: slash_commands
    description: "User-invocable slash commands in .claude/commands/"
    readme_location: "CLAUDE.md §6"
    command: "find /home/enio/.claude/commands /home/enio/.egos/.claude/commands -maxdepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' '"
    tolerance: "±5"
    last_value: "61"
    last_verified_at: "2026-06-03"
    category: "custom"

  - id: operating_surface_entries
    description: "Entradas no mapa machine-wide da superfície de operação (EGOS_OPERATING_SURFACE.yaml)"
    readme_location: "docs/governance/EGOS_OPERATING_SURFACE.md"
    command: "grep -cE '^  - id:' docs/governance/EGOS_OPERATING_SURFACE.yaml 2>/dev/null | tr -d ' '"
    tolerance: "±4"
    last_value: "35"
    last_verified_at: "2026-06-04"
    category: "custom"

  - id: kernel_packages
    description: "Packages in packages/ directory"
    readme_location: "CLAUDE.md"
    command: "ls -d packages/*/ 2>/dev/null | wc -l | tr -d ' '"
    tolerance: "±2"
    last_value: "36"
    last_verified_at: "2026-06-03"
    category: "custom"

  # ============================================================
  # CAPABILITY CLAIMS — moved from endpoints section (bug fix 2026-04-14)
  # ============================================================
  - id: commits_30d_all_repos
    description: "Total commits across all active EGOS repos in last 30 days"
    readme_location: "docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md — header stats"
    command: "for r in /home/enio/egos /home/enio/egos-lab /home/enio/852 /home/enio/br-acc /home/enio/forja /home/enio/carteira-livre; do git -C \"$r\" log --oneline --since='30 days ago' 2>/dev/null | wc -l; done | awk '{s+=$1} END {print s}'"
    tolerance: "min:50"
    last_value: "1466"
    last_verified_at: "2026-04-29"
    category: "custom"

  - id: unique_differentials
    description: "Unique technical differentials documented in EGOS_STATE"
    readme_location: "docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md — PONTOS FORTES ÚNICOS"
    command: "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md"
    tolerance: "min:6"
    last_value: "22"
    last_verified_at: "2026-04-14"
    category: "custom"

  - id: completed_tasks_total
    description: "Total completed tasks in TASKS.md"
    readme_location: "TASKS.md"
    command: "grep -c '^- \\[x\\]' TASKS.md || echo 0"
    tolerance: "min:1"
    last_value: "1"
    last_verified_at: "2026-05-25"
    category: "custom"
    note: "TASKS.md agressivamente arquivado (TASKS-SLIM-001). Completed tasks movidos para TASKS_ARCHIVE.md. Tolerância mínima = 1 (apenas task corrente do sprint ativo)."

  - id: active_products
    description: "Live products with public URLs in EGOS ecosystem"
    readme_location: "docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md — PRODUTOS"
    command: "grep -c '\\*\\*URL:\\*\\*' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md"
    tolerance: "min:5"
    last_value: "7"
    last_verified_at: "2026-04-08"
    category: "custom"

  - id: capability_registry_sections
    description: "Sections in CAPABILITY_REGISTRY.md (§N entries)"
    readme_location: "docs/CAPABILITY_REGISTRY.md"
    command: "grep -c '^## §' docs/CAPABILITY_REGISTRY.md"
    tolerance: "min:10"
    last_value: "19"
    last_verified_at: "2026-04-29"
    category: "custom"
    note: "Added §36 (Google AI) in GOV-RUNTIME-003 wave"

  # ============================================================
  # CAPABILITY CLAIMS — verifiable assertions that features work
  # Added 2026-04-14 (EVG-005) — coverage beyond metric counts
  # ============================================================

  - id: evg008_simplicity_check_function
    description: "EVG-008: detectSimplicityViolations function present in evidence-gate.ts (§K.2 enforcement)"
    readme_location: "~/.claude/CLAUDE.md §K.2 + scripts/evidence-gate.ts"
    command: "grep -c 'detectSimplicityViolations' scripts/evidence-gate.ts"
    tolerance: "min:2"
    last_value: "2"
    last_verified_at: "2026-04-14"
    category: "governance"

  - id: karpathy_principles_in_global_claude
    description: "§K Karpathy Principles in egos-rules lazy-load (moved from CLAUDE.md core in GOV-W2-009)"
    readme_location: "~/.claude/egos-rules/karpathy-principles.md"
    command: "grep -c 'Simplicity First' ~/.claude/egos-rules/karpathy-principles.md"
    tolerance: "min:1"
    last_value: "1"
    last_verified_at: "2026-04-28"
    category: "governance"
    note: "ENC-L0-006 — 4 principles: Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution"

  - id: disseminate_pipeline_scripts
    description: "Auto-disseminate pipeline scripts present (propagator + scanner)"
    readme_location: "docs/CAPABILITY_REGISTRY.md §25 + §26"
    command: "test -f scripts/disseminate-propagator.ts && test -f scripts/disseminate-scanner.ts && echo 2 || echo 0"
    tolerance: "eq:2"
    last_value: "2"
    last_verified_at: "2026-04-14"
    category: "governance"
    note: "ENC-L0-005 validated — pipeline propagates kernel rules to 10+ leaf repos post-commit"

  - id: evidence_gate_blocking_schedule
    description: "Evidence gate blocking activation date configured (WEEK2_START = 2026-04-16)"
    readme_location: "~/.claude/CLAUDE.md §8 + scripts/evidence-gate.ts"
    command: "grep -c 'WEEK2_START' scripts/evidence-gate.ts"
    tolerance: "min:2"
    last_value: "2"
    last_verified_at: "2026-04-14"
    category: "governance"

  - id: pre_commit_hook_chain_stages
    description: "Pre-commit hook chain has minimum required governance stages"
    readme_location: "CLAUDE.md §9 (Governance)"
    command: "grep -c '\\[' .husky/pre-commit"
    tolerance: "min:15"
    last_value: "70"
    last_verified_at: "2026-04-29"
    category: "governance"
    note: "Main stages: gitleaks, start-v6.0, tsc, doc-proliferation, governance-sync, SSOT-drift, doc-drift, evidence-gate, file-intelligence, vocab-guard, hook-telemetry-collector"

  - id: cross_repo_capabilities
    description: "Capabilities documented across all repos (carteira-livre, intelink, 852, gem-hunter, egos-lab)"
    readme_location: "docs/knowledge/CAPABILITY_CROSS_INDEX.md"
    command: "grep -c '^- \\*\\*' docs/knowledge/CAPABILITY_CROSS_INDEX.md 2>/dev/null || echo 0"
    tolerance: "min:10"
    last_value: "28"
    last_verified_at: "2026-05-05"
    category: "custom"
    note: "Cross-repo capabilities: carteira-livre(9) + intelink(15) + 852(4) = 28 verified"

domains:
  - url: "https://guard.egos.ia.br/health"
    expected_status: "200"
    checked_at: "2026-04-29"
    note: "Guard Brasil API health"
  - url: "https://hq.egos.ia.br/"
    expected_status: "200"
    checked_at: "2026-04-29"
    note: "Redirects to /login"
  - url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
    expected_status: "301"
    checked_at: "2026-04-29"
  - url: "https://eagleeye.egos.ia.br/"
    expected_status: "200"
    checked_at: "2026-04-29"
  - url: "https://852.egos.ia.br/"
    expected_status: "200"
    checked_at: "2026-04-29"
    note: "Restored to active Caddyfile 2026-04-07"
  - url: "https://inteligencia.egos.ia.br/"
    expected_status: "200"
    checked_at: "2026-04-29"

endpoints:
  - name: "guard_brasil_health"
    url: "https://guard.egos.ia.br/health"
    method: "GET"
    expected_status: "200"
    expected_contains: '"status":"healthy"'
  - name: "gem_hunter_topics"
    url: "https://gemhunter.egos.ia.br/gem-hunter/topics"
    method: "GET"
    expected_status: "301"

      exitCode: proc.exitCode ?? 0,
    };
  } catch (err) {
    return {
      output: "",
      error: String(err),
      exitCode: 127,
    };
  }
}

// ─── Domain checker ───────────────────────────────────────────────────────────

async function checkDomain(domain: ManifestDomain | ManifestEndpoint): Promise<DomainResult> {
  try {
    const response = await fetch(domain.url, {
      method: "GET",
      redirect: "manual",
      signal: AbortSignal.timeout(10_000),
    });

    const actualStatus = String(response.status);
    const expectedStatus = String(domain.expected_status);
    const statusOk = actualStatus === expectedStatus;

    let containsCheck: boolean | undefined;
    if ("expected_contains" in domain && domain.expected_contains) {
      const body = await response.text().catch(() => "");
      containsCheck = body.includes(domain.expected_contains);
    }

    const ok = statusOk && (containsCheck === undefined || containsCheck);

    return {
      url: domain.url,
      status: ok ? "ok" : "drifted",
      expected_status: expectedStatus,
      actual_status: actualStatus,
      contains_check: containsCheck,
    };
  } catch (err) {
    return {
      url: domain.url,
      status: "error",
      expected_status: String(domain.expected_status),
      actual_status: "connection_error",
      error: String(err),
    };
  }
}


exec
/bin/bash -lc 'git diff --check 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63' in /home/enio/egos
 succeeded in 0ms:
exec
/bin/bash -lc 'tmp=$(mktemp -d); printf '"'{\"entities\":[{\"id\":\"x\",\"names\":[\"Alice Example\"]}]}' > \""'$tmp/dict.json"; echo '"'Alice Example' > \""'$tmp/file.txt"; bash scripts/security/purge-gate.sh "$tmp" "$tmp/dict.json"; echo exit=$?' in /home/enio/egos
 succeeded in 122ms:
[pii-purge] Loaded 1 entities
[pii-purge] VERIFY-ONLY FAILED: 2 known-entity finding(s) remain
  /tmp/tmp.8k92M8wJaI/file.txt:1 entity=x type=name matchType=exact
  /tmp/tmp.8k92M8wJaI/file.txt:1 entity=x type=name matchType=literal-LEFTOVER
[purge-gate] ❌ BLOQUEADO — entidade conhecida detectada. NÃO publicar.
[purge-gate]    Rode o purge: bun packages/pii-purge/src/cli.ts --entity-dict /tmp/tmp.8k92M8wJaI/dict.json --target /tmp/tmp.8k92M8wJaI --apply
exit=1

exec
/bin/bash -lc "git show 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63:TASKS.md | grep -c '"'^- '"\\[x\\]' || echo 0; git show 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63:.egos-manifest.yaml | sed -n '82,100p'" in /home/enio/egos
 succeeded in 0ms:
0
0
    command: "grep -c '^### [0-9]' docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md"
    tolerance: "min:6"
    last_value: "22"
    last_verified_at: "2026-04-14"
    category: "custom"

  - id: completed_tasks_total
    description: "Total completed tasks in TASKS.md"
    readme_location: "TASKS.md"
    command: "grep -c '^- \\[x\\]' TASKS.md"
    tolerance: "min:1"
    last_value: "1"
    last_verified_at: "2026-05-25"
    category: "custom"
    note: "TASKS.md agressivamente arquivado (TASKS-SLIM-001). Completed tasks movidos para TASKS_ARCHIVE.md. Tolerância mínima = 1 (apenas task corrente do sprint ativo)."

  - id: active_products
    description: "Live products with public URLs in EGOS ecosystem"
    readme_location: "docs/governance/EGOS_STATE_OF_THE_ECOSYSTEM.md — PRODUTOS"

 succeeded in 132140ms:
packages/eval-runner/src/mcp-runner.ts:27:  expected_contains?: string[];
packages/eval-runner/src/mcp-runner.ts:83:    for (const expected of c.expected_contains ?? []) {
packages/mcp-eval-runner/node_modules/.bin/egos-mcp-eval:27:  expected_contains?: string[];
packages/mcp-eval-runner/node_modules/.bin/egos-mcp-eval:83:    for (const expected of c.expected_contains ?? []) {
packages/mcp-eval-runner/node_modules/@egos/eval-runner/src/mcp-runner.ts:27:  expected_contains?: string[];
packages/mcp-eval-runner/node_modules/@egos/eval-runner/src/mcp-runner.ts:83:    for (const expected of c.expected_contains ?? []) {
./.egos-manifest.yaml:208:    expected_contains: '"status":"healthy"'
./docs/governance/DOC_DRIFT_SHIELD.md:71:    expected_contains: <substring in body>
./docs/governance/MCP_ARCHITECTURE_DECISIONS.md:180:    expected_contains: ['MCP-N1-001', 'MCP-F1-001'],
./docs/governance/GOLDEN_CASES_CONTRACT.md:58:  expected_contains?: string[];                    // substrings that MUST appear (case-insensitive)
./docs/governance/GOLDEN_CASES_CONTRACT.md:87:  expected_contains: ["<keyword característico do response>"],
./docs/governance/GOLDEN_CASES_CONTRACT.md:96:  expected_contains: ["No results", "empty", "0 found"],
./docs/governance/GOLDEN_CASES_CONTRACT.md:124:  expected_contains: ["success", "<id_returned>"],
./docs/governance/GOLDEN_CASES_CONTRACT.md:133:  expected_contains: ["error", "invalid", "required"],
./docs/governance/GOLDEN_CASES_CONTRACT.md:142:  expected_contains: ["<expected_response_hash_indicator>"],
./docs/_archived_handoffs/2026-04/handoff_2026-04-07_doc-drift-shield-plan.md:183:- [ ] Check `endpoints` list: curl + verify `expected_contains`
./docs/_archived_handoffs/2026-04/handoff_2026-04-14.md:22:- **BUG-GOV-004** — gem-hunter endpoint: `expected_contains: "sectors"` → `"Gem Hunter"` (URL retorna HTML)
./docs/audits/PROOF_ENGINE_AUDIT_2026-05-30.md:60:   c. Checa `expected_contains` (case-insensitive substring match).
./docs/audits/PROOF_ENGINE_AUDIT_2026-05-30.md:89:      expected_contains: ["tasks"],                  // assertiva de conteúdo
./docs/audits/PROOF_ENGINE_AUDIT_2026-05-30.md:233:      expected_contains: ["<keyword>"],
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/__pycache__/waas_policy.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/__pycache__/update_waas_policy_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/__pycache__/create_waas_policy_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/__pycache__/identity_domains_client.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/__pycache__/self_registration_profile.cpython-312.pyc: binary file matches
scripts/ui-sync-check.ts:41:async function parseTenantProfiles(): Promise<Array<{ slug: string; domains: string[] }>> {
scripts/ui-sync-check.ts:47:    const profiles: Array<{ slug: string; domains: string[] }> = [];
scripts/ui-sync-check.ts:58:      const domainsMatch = block.match(/domains:\s*\[([\s\S]*?)\]/);
scripts/ui-sync-check.ts:59:      const domains: string[] = [];
scripts/ssot-router.ts:42:  domains: SsotDomain[];
scripts/ssot-router.ts:160:SSOT domains:
scripts/autores-ingest-harvest.ts:316:  const domains: Record<string, number> = {};
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/update_waas_policy_details.py:29:        :param additional_domains:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/update_waas_policy_details.py:31:        :type additional_domains: list[str]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/update_waas_policy_details.py:130:        :param additional_domains: The additional_domains of this UpdateWaasPolicyDetails.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/create_waas_policy_details.py:37:        :param additional_domains:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/create_waas_policy_details.py:39:        :type additional_domains: list[str]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/create_waas_policy_details.py:196:        :param additional_domains: The additional_domains of this CreateWaasPolicyDetails.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/waas_policy.py:65:        :param additional_domains:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/waas_policy.py:67:        :type additional_domains: list[str]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/waas/models/waas_policy.py:278:        :param additional_domains: The additional_domains of this WaasPolicy.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/identity_domains_client.py:26:    Use this pattern to construct endpoints for identity domains: `https://<domainURL>/admin/v1/`. See [Finding an Identity Domain URL](https://docs.oracle.com/en-us/iaas/Content/Identity/api-getstarted/locate-identity-domain-url.htm) to locate the domain URL you need.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/self_registration_profile.py:113:        :param allowed_email_domains:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/self_registration_profile.py:115:        :type allowed_email_domains: list[str]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/self_registration_profile.py:117:        :param disallowed_email_domains:
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/identity_domains/models/__pycache__/setting.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/__pycache__/external_listener.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/__pycache__/discovered_cloud_listener.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/__pycache__/discovered_external_listener.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/__pycache__/cloud_listener.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/dns/models/__pycache__/resolver.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_catalog/models/__pycache__/catalog.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_catalog/models/__pycache__/catalog_summary.cpython-312.pyc: binary file matches
scripts/egos-home/docs/CAPABILITY_REGISTRY.md:857:**Live endpoints:**
scripts/health-check-full.ts:124:function testEndpoints(base: string, endpoints: { path: string; expected?: string; note?: string }[]): EndpointResult[] {
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_external_listener.py:110:        :param endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_external_listener.py:112:        :type endpoints: list[oci.database_management.models.ExternalListenerEndpoint]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_external_listener.py:423:        :param endpoints: The endpoints of this DiscoveredExternalListener.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_cloud_listener.py:114:        :param endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_cloud_listener.py:116:        :type endpoints: list[oci.database_management.models.CloudListenerEndpoint]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/discovered_cloud_listener.py:430:        :param endpoints: The endpoints of this DiscoveredCloudListener.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/external_listener.py:151:        :param endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/external_listener.py:153:        :type endpoints: list[oci.database_management.models.ExternalListenerEndpoint]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/external_listener.py:810:        :param endpoints: The endpoints of this ExternalListener.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/cloud_listener.py:155:        :param endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/cloud_listener.py:157:        :type endpoints: list[oci.database_management.models.CloudListenerEndpoint]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/database_management/models/cloud_listener.py:845:        :param endpoints: The endpoints of this CloudListener.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/dns/models/resolver.py:103:        :param endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/dns/models/resolver.py:105:        :type endpoints: list[oci.dns.models.ResolverEndpointSummary]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/dns/models/resolver.py:515:        :param endpoints: The endpoints of this Resolver.
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_catalog/models/catalog.py:109:        :param attached_catalog_private_endpoints:
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_catalog/models/catalog.py:111:        :type attached_catalog_private_endpoints: list[str]
scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/data_catalog/models/catalog.py:533:        :param attached_catalog_private_endpoints: The attached_catalog_private_endpoints of this Catalog.
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/log_analytics/models/__pycache__/log_analytics_source.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/log_analytics/models/__pycache__/endpoint_result.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/log_analytics/models/__pycache__/log_list_type_endpoint.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/log_analytics/models/__pycache__/upsert_log_analytics_source_details.cpython-312.pyc: binary file matches
grep: scripts/oracle-instance-launcher/.venv/lib/python3.12/site-packages/oci/log_analytics/models/__pycache__/log_analytics_source_summary.cpython-312.pyc: binary file matches

exec
/bin/bash -lc "curl -I -s https://gemhunter.egos.ia.br/gem-hunter/topics | sed -n '1,10p'; curl -L -s -o /tmp/gem.txt -w '%{http_code} %{url_effective}\\n' https://gemhunter.egos.ia.br/gem-hunter/topics; head -c 120 /tmp/gem.txt" in /home/enio/egos
 succeeded in 2814ms:
HTTP/2 301 
alt-svc: h3=":443"; ma=2592000
location: https://egos.ia.br/#/showcase
server: Caddy
date: Mon, 08 Jun 2026 00:42:23 GMT

200 https://egos.ia.br/#/showcase
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href
exec
/bin/bash -lc "sed -n '1,240p' packages/pii-purge/src/patterns.ts && sed -n '1,260p' packages/pii-purge/src/scanner.ts" in /home/enio/egos
 succeeded in 0ms:
/**
 * Pattern Generator — Builds all format-variant RegExps for a given Entity.
 *
 * Safety rules:
 * - CPF: formatted (NNN.NNN.NNN-NN) AND unformatted (NNNNNNNNNNN) → exact/format-variant
 * - Phone: with/without DDD parens/spaces/dash → exact/format-variant
 * - Plate: old AAA-0000/AAA0000 AND Mercosul AAA0A00 → exact/format-variant (scan-ok: format-spec)
 * - Name: exact string case-insensitive → exact match
 *         normalizeOrtho variant → fuzzy-REVIEW only (NEVER auto-purge)
 * - REDS: raw number match → exact
 *
 * Helpers are reimplemented locally — do NOT import from intelink.
 */

import type { Entity } from './dictionary.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export type MatchType = 'exact' | 'format-variant' | 'fuzzy-REVIEW' | 'literal-LEFTOVER';
export type EntityFieldType = 'cpf' | 'phone' | 'plate' | 'name' | 'reds';

export interface EntityPattern {
  entityId: string;
  fieldType: EntityFieldType;
  matchType: MatchType;
  /** The compiled regex. Always has 'g' flag. */
  regex: RegExp;
}

// ─── Local format helpers (no intelink import) ────────────────────────────────

/** Strip all non-digit chars */
function digitsOnly(s: string): string {
  return s.replace(/\D/g, '');
}

/**
 * Strip combining diacritics (accents) and lower-case.
 * Used for fuzzy name normalization.
 */
export function normalizeOrtho(s: string): string {
  return s
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .trim();
}

/** Escape all regex-special chars in a string */
function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// ─── Per-type pattern builders ────────────────────────────────────────────────

/**
 * CPF — generates two patterns per CPF value:
 *   1. exact match (the string as given, escaped)
 *   2. all format variants (with/without dots and dash)
 * Both are `format-variant` matchType because they are structural equivalents.
 */
function cpfPatterns(entityId: string, cpfs: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const cpf of cpfs) {
    const digits = digitsOnly(cpf);
    if (digits.length !== 11) continue; // skip malformed

    // Formatted: DDD.DDD.DDD-DD
    const formatted = `${digits.slice(0, 3)}\\.${digits.slice(3, 6)}\\.${digits.slice(6, 9)}-${digits.slice(9)}`;
    // Unformatted: DDDDDDDDDDD (word boundary to avoid partial matches)
    const unformatted = digits;

    // Single pattern that matches both variants
    const src = `\\b(?:${formatted}|${unformatted})\\b`;
    results.push({
      entityId,
      fieldType: 'cpf',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Phone — matches with/without DDD parens, spaces, dashes.
 * Ex.: (11) 90000-0000 → 11900000000 → various delimiters (scan-ok: synthetic example)
 */
function phonePatterns(entityId: string, phones: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const phone of phones) {
    const digits = digitsOnly(phone);
    if (digits.length < 10 || digits.length > 13) continue; // skip malformed

    // Strip country code if present (+55)
    const local = digits.startsWith('55') && digits.length > 11 ? digits.slice(2) : digits;
    const ddd = local.slice(0, 2);
    const num = local.slice(2);

    // num may be 8 or 9 digits
    const half1 = num.slice(0, num.length - 4);
    const half2 = num.slice(-4);

    // Pattern: optional +55, optional parens on DDD, various delimiters
    const dddPart = `(?:\\+55[\\s-]?)?(?:\\(?${escapeRegex(ddd)}\\)?[\\s-]?)`;
    const numPart = `${escapeRegex(half1)}[-\\s]?${escapeRegex(half2)}`;
    const src = `\\b${dddPart}${numPart}\\b`;

    results.push({
      entityId,
      fieldType: 'phone',
      matchType: 'format-variant',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Plate — matches old format (AAA-0000 / AAA0000) and Mercosul (AAA0A00). (scan-ok: format-spec)
 * We also handle the reverse: given Mercosul, emit both.
 */
function platePatterns(entityId: string, plates: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const plate of plates) {
    // Normalize: strip spaces/dashes, upper-case
    const clean = plate.replace(/[\s-]/g, '').toUpperCase();

    // Detect old format: 3 letters + 4 digits
    const isOld = /^[A-Z]{3}\d{4}$/.test(clean);
    // Detect Mercosul: 3 letters + digit + letter + 2 digits
    const isMercosul = /^[A-Z]{3}\d[A-Z]\d{2}$/.test(clean);

    if (!isOld && !isMercosul) continue;

    const escaped = escapeRegex(clean);
    let src: string;

    if (isOld) {
      // Match with or without dash: ABC-1234 or ABC1234 (scan-ok: format-spec)
      const letters = escapeRegex(clean.slice(0, 3));
      const digits = escapeRegex(clean.slice(3));
      src = `\\b${letters}[-]?${digits}\\b`;
    } else {
      // Mercosul — exact only (no dash variant exists)
      src = `\\b${escaped}\\b`;
    }

    results.push({
      entityId,
      fieldType: 'plate',
      matchType: isOld ? 'format-variant' : 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

/**
 * Name — two patterns per name:
 *   1. Exact case-insensitive string match (matchType: 'exact') → auto-purgeable
 *   2. Accent-stripped/ortho-normalized version (matchType: 'fuzzy-REVIEW') → flag only
 */
function namePatterns(entityId: string, names: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const name of names) {
    const trimmed = name.trim();
    if (!trimmed) continue;

    // Exact match (case-insensitive)
    const exactSrc = `\\b${escapeRegex(trimmed)}\\b`;
    results.push({
      entityId,
      fieldType: 'name',
      matchType: 'exact',
      regex: new RegExp(exactSrc, 'gi'),
    });

    // Ortho-normalized (accent-stripped) variant — REVIEW only
    const normalized = normalizeOrtho(trimmed);
    if (normalized !== trimmed.toLowerCase()) {
      const fuzzyEscaped = escapeRegex(normalized);
      results.push({
        entityId,
        fieldType: 'name',
        matchType: 'fuzzy-REVIEW',
        regex: new RegExp(`\\b${fuzzyEscaped}\\b`, 'gi'),
      });
    }
  }
  return results;
}

/**
 * REDS — matches the raw REDS number (digits only) with optional keyword prefix.
 */
function redsPatterns(entityId: string, reds: string[]): EntityPattern[] {
  const results: EntityPattern[] = [];
  for (const r of reds) {
    const digits = digitsOnly(r);
    if (!digits) continue;
    const src = `\\b(?:REDS[:\\s]*)?${escapeRegex(digits)}\\b`;
    results.push({
      entityId,
      fieldType: 'reds',
      matchType: 'exact',
      regex: new RegExp(src, 'gi'),
    });
  }
  return results;
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * Generate all EntityPatterns for a single Entity.
 * Returns patterns in a deterministic order: cpf → phone → plate → reds → name.
 * Name fuzzy patterns are always last (lowest priority for matching).
 */
export function generateEntityPatterns(entity: Entity): EntityPattern[] {
  const patterns: EntityPattern[] = [];
  if (entity.cpfs?.length) patterns.push(...cpfPatterns(entity.id, entity.cpfs));
  if (entity.phones?.length) patterns.push(...phonePatterns(entity.id, entity.phones));
  if (entity.plates?.length) patterns.push(...platePatterns(entity.id, entity.plates));
  if (entity.reds?.length) patterns.push(...redsPatterns(entity.id, entity.reds));
  if (entity.names?.length) patterns.push(...namePatterns(entity.id, entity.names));
  return patterns;
}

/**
 * Generate all EntityPatterns for every entity in the dictionary.
 * Entities are processed in dict order (index 0 first).
 */
export function generateAllPatterns(entities: Entity[]): EntityPattern[] {
  return entities.flatMap(generateEntityPatterns);
}
/**
 * Scanner — Walks a target directory and returns Findings for each entity match.
 *
 * Safety rules:
 * - NEVER include the matched value in a Finding (T0 §3)
 * - Skip binary files, node_modules, .git
 * - Only process git-tracked text files (falls back to all text if not in a git repo)
 * - fuzzy-REVIEW matches are flagged but never auto-purgeable
 */

import { readdir, readFile, stat } from 'node:fs/promises';
import { join, extname } from 'node:path';
import { execSync } from 'node:child_process';
import type { EntityPattern, MatchType, EntityFieldType } from './patterns.js';
import type { Entity } from './dictionary.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface Finding {
  /** Absolute or relative path of the file containing the match */
  file: string;
  /** 1-based line number */
  line: number;
  /** Entity id from the dictionary */
  entityId: string;
  /** Which field type matched (cpf, phone, plate, name, reds) */
  type: EntityFieldType;
  /** Whether this is auto-purgeable or requires human review */
  matchType: MatchType;
  /** Byte offset of match start within the line (for stable replacements) */
  lineOffset: number;
  /** Length of matched text (never the value itself) */
  matchLength: number;
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

const BINARY_EXTENSIONS = new Set([
  '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp',
  '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
  '.zip', '.tar', '.gz', '.bz2', '.rar', '.7z',
  '.mp3', '.mp4', '.avi', '.mov', '.wav', '.flac',
  '.woff', '.woff2', '.ttf', '.eot',
  '.lock', '.bin', '.exe', '.dll', '.so', '.dylib',
  '.db', '.sqlite', '.sqlite3',
]);

function isBinary(filePath: string): boolean {
  return BINARY_EXTENSIONS.has(extname(filePath).toLowerCase());
}

function isSkippedDir(name: string): boolean {
  return name === 'node_modules' || name === '.git' || name === 'dist' || name === '.next';
}

/**
 * Returns the set of git-tracked files under `dir`, relative to `dir`.
 * Falls back to null if not in a git repo — caller handles fallback.
 */
function getGitTrackedFiles(dir: string): Set<string> | null {
  try {
    const out = execSync('git ls-files', { cwd: dir, encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] });
    return new Set(out.trim().split('\n').filter(Boolean).map(f => join(dir, f)));
  } catch {
    return null;
  }
}

/**
 * Recursively collect all candidate file paths under `dir`.
 */
async function collectFiles(dir: string): Promise<string[]> {
  const results: string[] = [];
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (isSkippedDir(entry.name)) continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...(await collectFiles(full)));
    } else if (entry.isFile() && !isBinary(full)) {
      results.push(full);
    }
  }
  return results;
}

// ─── Core scanner ─────────────────────────────────────────────────────────────

/**
 * Scan a single file for all entity patterns.
 * NEVER includes matched values in returned findings.
 */
export function scanText(
  text: string,
  filePath: string,
  patterns: EntityPattern[],
): Finding[] {
  const findings: Finding[] = [];
  const lines = text.split('\n');

  for (const pattern of patterns) {
    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const line = lines[lineIdx]!;
      // Reset regex state for each line (patterns have 'g' flag)
      const re = new RegExp(pattern.regex.source, pattern.regex.flags);
      let match: RegExpExecArray | null;
      while ((match = re.exec(line)) !== null) {
        findings.push({
          file: filePath,
          line: lineIdx + 1, // 1-based
          entityId: pattern.entityId,
          type: pattern.fieldType,
          matchType: pattern.matchType,
          lineOffset: match.index,
          matchLength: match[0].length,
          // NEVER include match[0] — T0 §3
        });
      }
    }
  }

  return findings;
}

/**
 * Resolve the list of readable text files under `targetDir`, preferring git-tracked.
 * Yields { path, text } for each, skipping binaries and files >2MB.
 */
async function readScannableFiles(targetDir: string): Promise<Array<{ path: string; text: string }>> {
  const allFiles = await collectFiles(targetDir);
  const gitTracked = getGitTrackedFiles(targetDir);
  const filesToScan = gitTracked ? allFiles.filter(f => gitTracked.has(f)) : allFiles;

  const out: Array<{ path: string; text: string }> = [];
  for (const path of filesToScan) {
    const s = await stat(path);
    if (s.size > 2 * 1024 * 1024) continue; // skip very large files
    try {
      out.push({ path, text: await readFile(path, 'utf-8') });
    } catch {
      // Binary or unreadable — skip
    }
  }
  return out;
}

/**
 * Walk a target directory and scan all eligible files.
 * Returns a deduplicated, stable list of findings.
 *
 * @param targetDir  - directory to scan
 * @param patterns   - compiled entity patterns to search for
 */
export async function scanDirectory(
  targetDir: string,
  patterns: EntityPattern[],
  excludeFile?: string,
): Promise<Finding[]> {
  const files = await readScannableFiles(targetDir);
  const allFindings: Finding[] = [];
  for (const { path, text } of files) {
    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
    allFindings.push(...scanText(text, path, patterns));
  }
  return allFindings;
}

// ─── Literal-value safety net (VERIFY-001) ─────────────────────────────────────
// The pattern generator's output depends on the dict FIELD TYPE (a text value put
// in a numeric `reds` field generates no working pattern → escapes silently).
// This literal scan searches for each raw dict value case-insensitively, independent
// of field typing — the catch-all that makes a mis-typed dict field non-fatal.

export interface LiteralValue {
  raw: string;
  entityId: string;
  type: EntityFieldType;
}

/** Flatten every raw identifier value from the entity dictionary. */
export function flattenEntityValues(entities: Entity[]): LiteralValue[] {
  const out: LiteralValue[] = [];
  for (const e of entities) {
    for (const v of e.cpfs ?? []) out.push({ raw: v, entityId: e.id, type: 'cpf' });
    for (const v of e.phones ?? []) out.push({ raw: v, entityId: e.id, type: 'phone' });
    for (const v of e.plates ?? []) out.push({ raw: v, entityId: e.id, type: 'plate' });
    for (const v of e.names ?? []) out.push({ raw: v, entityId: e.id, type: 'name' });
    for (const v of e.reds ?? []) out.push({ raw: v, entityId: e.id, type: 'reds' });
  }
  return out;
}

/**
 * Case-insensitive literal substring search for raw dict values.
 * NEVER includes the matched value in a Finding (T0 §3).
 */
export function scanLiteralValues(
  text: string,
  filePath: string,
  values: LiteralValue[],
): Finding[] {
  const findings: Finding[] = [];
  const lines = text.split('\n');
  for (const v of values) {
    const needle = (v.raw ?? '').toLowerCase();
    if (needle.length < 3) continue; // avoid trivial/noisy short matches
    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const hay = lines[lineIdx]!.toLowerCase();
      let from = 0;
      let idx: number;
      while ((idx = hay.indexOf(needle, from)) !== -1) {
        findings.push({
          file: filePath,
          line: lineIdx + 1,
          entityId: v.entityId,
          type: v.type,
          matchType: 'literal-LEFTOVER',
          lineOffset: idx,
          matchLength: v.raw.length,
        });
        from = idx + needle.length;
      }
    }
  }
  return findings;
}

/** Walk a directory and literal-scan all eligible files for raw dict values. */
export async function scanDirectoryLiteral(
  targetDir: string,
  values: LiteralValue[],
  excludeFile?: string,
): Promise<Finding[]> {
  const files = await readScannableFiles(targetDir);
  const allFindings: Finding[] = [];
  for (const { path, text } of files) {
    if (excludeFile && path === excludeFile) continue; // never scan the entity-dict itself
    allFindings.push(...scanLiteralValues(text, path, values));
  }
  return allFindings;
}

exec
/bin/bash -lc 'tmp=$(mktemp -d); printf '"'{\"entities\":[{\"id\":\"p1\",\"names\":[\"José Silva\"]}]}' > \""'$tmp/dict.json"; echo '"'Jose Silva' > \""'$tmp/file.txt"; bash scripts/security/purge-gate.sh "$tmp" "$tmp/dict.json"; echo exit=$?; bun packages/pii-purge/src/cli.ts --entity-dict "$tmp/dict.json" --target "$tmp" >/tmp/dry.out 2>&1; echo dry_exit=$?; cat /tmp/dry.out' in /home/enio/egos
 succeeded in 139ms:
dry_exit=1
[pii-purge] mode=dry-run dict=/tmp/tmp.iUZa8wWarr/dict.json target=/tmp/tmp.iUZa8wWarr
[pii-purge] Loaded 1 entities
[pii-purge] Scan complete: 1 total findings
  auto-purgeable: 0
  REVIEW_REQUIRED (fuzzy): 1
  /tmp/tmp.iUZa8wWarr/file.txt:1 entity=p1 type=name matchType=fuzzy-REVIEW [REVIEW_REQUIRED]
[pii-purge] DRY-RUN: would modify 0 file(s)
[pii-purge] 1 REVIEW_REQUIRED finding(s) — resolve manually before publishing

exec
/bin/bash -lc "nl -ba scripts/security/purge-gate.sh | sed -n '36,48p'" in /home/enio/egos
 succeeded in 0ms:
    36	  exit 0
    37	fi
    38	
    39	if ! command -v bun >/dev/null 2>&1; then
    40	  echo "[purge-gate] SKIP — bun indisponível." >&2
    41	  exit 0
    42	fi
    43	
    44	echo "[purge-gate] verificando $TARGET contra entidades conhecidas..."
    45	# --verify-only: só escaneia (pattern + literal), NÃO purga. exit 1 se achar.
    46	if bun "$EGOS_ROOT/packages/pii-purge/src/cli.ts" --entity-dict "$DICT" --target "$TARGET" --verify-only; then
    47	  echo "[purge-gate] ✅ limpo — nenhuma entidade conhecida no alvo."
    48	  exit 0

codex
The new purge publish gate can report a target as clean while the purge engine itself flags unresolved fuzzy PII matches requiring human review, so it is not safe as a publishing blocker.

Review comment:

- [P1] Block REVIEW_REQUIRED matches in the publish gate — /home/enio/egos/scripts/security/purge-gate.sh:46-46
  When the target contains only a fuzzy name variant, such as a dict entry `José Silva` and repo text `Jose Silva`, this gate passes because `--verify-only` filters out `fuzzy-REVIEW` findings, while the normal purge dry-run exits 1 and requires HITL review. That lets exactly the unresolved cases the purge flow says must be reviewed slip through before publish; the gate should fail on REVIEW_REQUIRED matches as well or run an additional dry-run/review check.
The new purge publish gate can report a target as clean while the purge engine itself flags unresolved fuzzy PII matches requiring human review, so it is not safe as a publishing blocker.

Review comment:

- [P1] Block REVIEW_REQUIRED matches in the publish gate — /home/enio/egos/scripts/security/purge-gate.sh:46-46
  When the target contains only a fuzzy name variant, such as a dict entry `José Silva` and repo text `Jose Silva`, this gate passes because `--verify-only` filters out `fuzzy-REVIEW` findings, while the normal purge dry-run exits 1 and requires HITL review. That lets exactly the unresolved cases the purge flow says must be reviewed slip through before publish; the gate should fail on REVIEW_REQUIRED matches as well or run an additional dry-run/review check.
```
