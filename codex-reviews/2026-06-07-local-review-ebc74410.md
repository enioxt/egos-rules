# Codex Local Review — 2026-06-07T20:05:07Z

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
session id: 019ea3b0-6957-77d0-b520-32a2b88aa0f9
--------
user
changes against 'HEAD~3'
2026-06-07T20:05:09.234217Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T20:05:09.237187Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63 --stat && git diff 563d8d0da0b6d5dc7a2cd70a8d31b316e04fdc63' in /home/enio/egos
 succeeded in 0ms:
 .claude/commands/purge.md                         | 63 ++++++++++++++++
 .egos-manifest.yaml                               | 27 ++++---
 TASKS.md                                          |  3 +-
 TASKS_ARCHIVE.md                                  |  6 ++
 apps/egos-landing/src/App.tsx                     | 70 +++++++++++------
 apps/egos-landing/src/components/MyceliumPage.tsx |  2 +-
 docs/knowledge/HARVEST.md                         | 46 +++++++++++-
 docs/strategy/APRESENTACAO_EGOS.md                | 92 +++++++++++++++++++++++
 scripts/security/purge-gate.sh                    | 53 +++++++++++++
 scripts/visual-audit.ts                           |  6 +-
 10 files changed, 325 insertions(+), 43 deletions(-)
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
index 00000000..c1058c54
--- /dev/null
+++ b/docs/strategy/APRESENTACAO_EGOS.md
@@ -0,0 +1,92 @@
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
+*DRAFT — HITL Enio antes de gravar/publicar. Para PDF: exportar esta Parte A (ex: pandoc/Obsidian/print-to-PDF). Ícone do grupo: ver VISUAL_IDENTITY (espiral Fibonacci azul #2563EB).*
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
/bin/bash -lc "sed -n '1,180p' apps/egos-landing/src/App.tsx && sed -n '440,650p' apps/egos-landing/src/App.tsx && sed -n '1,130p' scripts/visual-audit.ts" in /home/enio/egos
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
                style={{ color: currentRoute === 'home' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Home
              </button>
              <button
                onClick={() => navigateTo('timeline')}
                style={{ color: currentRoute === 'timeline' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Timeline
              </button>
              <button
                onClick={() => navigateTo('showcase')}
                style={{ color: currentRoute === 'showcase' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Showcase
              </button>
              <button
                onClick={() => navigateTo('transparencia')}
                style={{ color: currentRoute === 'transparencia' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Transparência
              </button>
              <button
                onClick={() => navigateTo('guard')}
                style={{ color: currentRoute === 'guard' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Guard Brasil
              </button>
              <button
                onClick={() => navigateTo('tools')}
                style={{ color: currentRoute === 'tools' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Ferramentas
              </button>
              <button
                onClick={() => navigateTo('grok')}
                style={{ color: currentRoute === 'grok' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Checador de IA
              </button>
              <button
                onClick={() => navigateTo('mycelium')}
                style={{ color: currentRoute === 'mycelium' ? 'var(--accent)' : 'var(--text-muted)', fontSize: '14px', fontWeight: 500 }}
              >
                Rede de conhecimento
              </button>
            </div>
          )}

          {/* Hamburger button (mobile only) */}
          {isMobile && (
            <button
              aria-label="Menu"
              aria-expanded={drawerOpen}
              onClick={() => setDrawerOpen(o => !o)}
              style={{
                background: 'none', border: 'none', cursor: 'pointer',
                color: 'var(--text-strong)', fontSize: '24px', padding: '8px',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                lineHeight: 1
              }}
            >
              {drawerOpen ? '✕' : '≡'}
            </button>
          )}
        </div>
      </nav>

      {/* Mobile Drawer overlay */}
      {isMobile && drawerOpen && (
        <div
          onClick={() => setDrawerOpen(false)}
          style={{
            position: 'fixed', inset: 0, zIndex: 99,
            background: 'rgba(0,0,0,0.5)'
          }}
        />
      )}

      {/* Mobile Drawer */}
      {isMobile && (
        <div
          style={{
            position: 'fixed', top: '64px', right: 0, bottom: 0, zIndex: 200,
            width: '240px',
            background: 'rgba(7, 9, 13, 0.97)', backdropFilter: 'blur(20px)',
            borderLeft: '1px solid var(--border)',
            display: 'flex', flexDirection: 'column', gap: '4px',
            padding: '16px 0',
            transform: drawerOpen ? 'translateX(0)' : 'translateX(100%)',
            transition: 'transform 0.22s cubic-bezier(0.4,0,0.2,1)'
          }}
        >
          {([
            { route: '', label: 'Home' },
            { route: 'timeline', label: 'Timeline' },
            { route: 'showcase', label: 'Showcase' },
            { route: 'transparencia', label: 'Transparência' },
            { route: 'guard', label: 'Guard Brasil' },
            { route: 'tools', label: 'Ferramentas' },
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

#!/usr/bin/env bun
/**
 * visual-audit.ts — Auditoria visual completa do egos-landing
 *
 * Uso: bun scripts/visual-audit.ts [--url <base>] [--out <dir>] [--mobile] [--json]
 *
 * O que faz:
 *   1. Sobe dev server (ou usa --url para produção)
 *   2. Navega todas as 8 páginas + faz testes de interação
 *   3. Salva screenshots em docs/_proofs/<data>/
 *   4. Reporta: JS errors, net errors, interações, acessibilidade básica
 *   5. Exit 1 se qualquer página tiver JS errors críticos
 *
 * Integração sugerida:
 *   - Pre-deploy: bash deploy.sh && bun scripts/visual-audit.ts --url https://egos.ia.br
 *   - Pre-commit (opcional, lento): VISUAL_AUDIT=1 bun scripts/visual-audit.ts
 *   - Baseline visual: bun scripts/visual-audit.ts --baseline (salva referência)
 *
 * Playwright instalado em: packages/mcp-browser-automation/node_modules/playwright
 */

import { execSync, spawn } from 'child_process'
import { existsSync, mkdirSync, writeFileSync } from 'fs'
import { resolve, join } from 'path'

// ── CLI args ──────────────────────────────────────────────────────────────────
const args = process.argv.slice(2)
const BASE_URL = args.includes('--url')
  ? args[args.indexOf('--url') + 1]
  : 'http://localhost:5181'
const MOBILE = args.includes('--mobile')
const AS_JSON = args.includes('--json')
const BASELINE = args.includes('--baseline')

const ROOT = resolve(import.meta.dir, '..')
const PLAYWRIGHT = resolve(ROOT, 'packages/mcp-browser-automation/node_modules/playwright')
const TODAY = new Date().toISOString().slice(0, 10)
const OUT_DIR = args.includes('--out')
  ? args[args.indexOf('--out') + 1]
  : resolve(ROOT, `docs/_proofs/${TODAY}`)

// ── Consent localStorage seed ─────────────────────────────────────────────────
const CONSENT_SEED = JSON.stringify({
  version: '1.0.0',
  timestamp: new Date().toISOString(),
  choices: { analytics: false, sentry: false, ai_context: false, registration: false, history: false },
  history: [],
})

// ── Page manifest ─────────────────────────────────────────────────────────────
const PAGES = [
  { name: 'home',          hash: '',              expect: 'O EGOS organiza' },
  { name: 'timeline',      hash: '#/timeline',    expect: 'Timeline' },
  { name: 'showcase',      hash: '#/showcase',    expect: 'Showcase' },
  { name: 'transparencia', hash: '#/transparencia', expect: 'Transparência' },
  { name: 'guard',         hash: '#/guard',       expect: 'Guard Brasil' },
  { name: 'grok',          hash: '#/grok',        expect: 'Checador de IA' },
  { name: 'mycelium',      hash: '#/mycelium',    expect: 'Rede de conhecimento' },
  { name: 'tools',         hash: '#/tools',       expect: 'Hub de Ferramentas' },
]

// ── Interaction tests ─────────────────────────────────────────────────────────
async function runInteractionTests(browser: any, results: any[]) {
  // T1: Consent gate shows on first visit, dismiss → badge appears
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1500)

    const modalOk = await page.locator('text=Antes de começar').isVisible().catch(() => false)
    await page.locator('text=Modo básico — sem dados').click().catch(() => {})
    await page.waitForTimeout(800)
    const badgeOk = await page.locator('text=Seus dados: 0 compartilhados').isVisible().catch(() => false)
    const heroOk  = await page.locator('text=IA que você pode').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-flow.png') })
    results.push({ name: 'interaction:consent-flow', ok: modalOk && badgeOk && heroOk,
      checks: { modal: modalOk, badge: badgeOk, hero: heroOk } })
    await page.close()
  }

  // T2: Consent detail → toggle analytics → badge shows "1 compartilhado"
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1000)

    await page.locator('text=Escolher o que ativo').click().catch(() => {})
    await page.waitForTimeout(500)
    const detailOk = await page.locator('text=Suas escolhas de privacidade').isVisible().catch(() => false)

    const toggle = page.locator('[role="switch"][aria-label="Ativar Analytics"]')
    await toggle.click().catch(() => {})
    await page.waitForTimeout(300)
    const toggleOn = (await toggle.getAttribute('aria-checked').catch(() => 'false')) === 'true'

    await page.locator('text=Salvar escolhas').click().catch(() => {})
    await page.waitForTimeout(800)
    const badge1 = await page.locator('text=Seus dados: 1 compartilhado').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-1-active.png') })
    results.push({ name: 'interaction:consent-detail', ok: detailOk && toggleOn && badge1,
      checks: { detail: detailOk, toggleOn, badge1 } })
    await page.close()
  }

  // T3: Guard Brasil local scanner — CPF + telefone sintéticos
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.addInitScript((c: string) => localStorage.setItem('egos_consent_v1', c), CONSENT_SEED)
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1500)

    const localScanner = page.locator('textarea[placeholder*="Entre em contato"]')
    // scan-ok: mock — synthetic PII for test, never real
    await localScanner.fill('CPF 987.654.321-00 e tel (31) 99999-8888')
    await page.waitForTimeout(1200)

    const cpfMask = await page.locator('text=[CPF MASCARADO]').isVisible().catch(() => false)
    const telMask = await page.locator('text=[TELEFONE MASCARADO]').isVisible().catch(() => false)
    const cpfTag  = await page.locator('text=CPF detectado').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-guard-pii.png') })
    results.push({ name: 'interaction:guard-pii-local', ok: cpfMask && telMask && cpfTag,
      checks: { cpfMask, telMask, cpfTag } })
    await page.close()
  }

exec
/bin/bash -lc "nl -ba apps/egos-landing/src/App.tsx | sed -n '560,585p'; nl -ba scripts/visual-audit.ts | sed -n '80,100p'" in /home/enio/egos
 succeeded in 0ms:
   560	
   561	      {/* Main Content */}
   562	      <main id="main-content" style={{ flexGrow: 1, paddingTop: '100px', paddingBottom: '60px' }}>
   563	        <div className="container" style={{ padding: '0 24px' }}>
   564	
   565	          {/* HOME VIEW */}
   566	          {currentRoute === 'home' && (
   567	            <div>
   568	              {/* Hero Banner */}
   569	              <section style={{ textAlign: 'center', padding: '60px 0', maxWidth: '800px', margin: '0 auto' }}>
   570	                <span className="eyebrow" style={{ display: 'block', marginBottom: '16px' }}>IA com método para profissionais brasileiros</span>
   571	                <h1 className="display-xl" style={{ marginBottom: '24px' }}>
   572	                  A IA ajuda. <span style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-glow))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>O EGOS organiza.</span>
   573	                </h1>
   574	                <p className="body-l muted" style={{ marginBottom: '32px' }}>
   575	                  O EGOS mostra como transformar a IA (ChatGPT, Claude, Gemini) numa assistente mais útil para o seu trabalho — com cuidados simples para evitar respostas inventadas e exposição de dados. Você recebe prompts, checklists e ferramentas prontas para usar com mais clareza.
   576	                </p>
   577	                <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
   578	                  <a href="#comece" className="btn btn-primary">Criar meu assistente de IA</a>
   579	                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
   580	                </div>
   581	              </section>
   582	
   583	              {/* How it works — 3 layers */}
   584	              <section style={{ margin: '40px 0' }}>
   585	                <h2 className="h2" style={{ textAlign: 'center', marginBottom: '32px' }}>Como o EGOS funciona</h2>
    80	    await page.close()
    81	  }
    82	
    83	  // T2: Consent detail → toggle analytics → badge shows "1 compartilhado"
    84	  {
    85	    const page = await browser.newPage()
    86	    await page.setViewportSize({ width: 1280, height: 900 })
    87	    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    88	    await page.waitForTimeout(1000)
    89	
    90	    await page.locator('text=Escolher o que ativo').click().catch(() => {})
    91	    await page.waitForTimeout(500)
    92	    const detailOk = await page.locator('text=Suas escolhas de privacidade').isVisible().catch(() => false)
    93	
    94	    const toggle = page.locator('[role="switch"][aria-label="Ativar Analytics"]')
    95	    await toggle.click().catch(() => {})
    96	    await page.waitForTimeout(300)
    97	    const toggleOn = (await toggle.getAttribute('aria-checked').catch(() => 'false')) === 'true'
    98	
    99	    await page.locator('text=Salvar escolhas').click().catch(() => {})
   100	    await page.waitForTimeout(800)

exec
/bin/bash -lc "nl -ba scripts/visual-audit.ts | sed -n '60,82p'" in /home/enio/egos
 succeeded in 0ms:
    60	]
    61	
    62	// ── Interaction tests ─────────────────────────────────────────────────────────
    63	async function runInteractionTests(browser: any, results: any[]) {
    64	  // T1: Consent gate shows on first visit, dismiss → badge appears
    65	  {
    66	    const page = await browser.newPage()
    67	    await page.setViewportSize({ width: 1280, height: 900 })
    68	    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    69	    await page.waitForTimeout(1500)
    70	
    71	    const modalOk = await page.locator('text=Antes de começar').isVisible().catch(() => false)
    72	    await page.locator('text=Modo básico — sem dados').click().catch(() => {})
    73	    await page.waitForTimeout(800)
    74	    const badgeOk = await page.locator('text=Seus dados: 0 compartilhados').isVisible().catch(() => false)
    75	    const heroOk  = await page.locator('text=IA que você pode').isVisible().catch(() => false)
    76	
    77	    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-flow.png') })
    78	    results.push({ name: 'interaction:consent-flow', ok: modalOk && badgeOk && heroOk,
    79	      checks: { modal: modalOk, badge: badgeOk, hero: heroOk } })
    80	    await page.close()
    81	  }
    82	

exec
/bin/bash -lc "grep -n \"hash\\|navigateTo\\|popstate\" -n apps/egos-landing/src/App.tsx | head -60 && sed -n '180,260p' apps/egos-landing/src/App.tsx" in /home/enio/egos
 succeeded in 0ms:
230:      const hash = window.location.hash
231:      if (hash.startsWith('#/timeline/')) {
232:        const slug = hash.replace('#/timeline/', '')
235:      } else if (hash === '#/timeline') {
238:      } else if (hash === '#/showcase') {
241:      } else if (hash === '#/transparencia') {
244:      } else if (hash === '#/guard') {
247:      } else if (hash === '#/grok') {
250:      } else if (hash === '#/mycelium') {
253:      } else if (hash === '#/tools') {
262:    window.addEventListener('hashchange', handleRouteChange)
265:    return () => window.removeEventListener('hashchange', handleRouteChange)
363:  const navigateTo = (route: string) => {
364:    window.location.hash = `#/${route}`
425:          <div style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }} onClick={() => navigateTo('')}>
439:                onClick={() => navigateTo('')}
445:                onClick={() => navigateTo('timeline')}
451:                onClick={() => navigateTo('showcase')}
457:                onClick={() => navigateTo('transparencia')}
463:                onClick={() => navigateTo('guard')}
469:                onClick={() => navigateTo('tools')}
475:                onClick={() => navigateTo('grok')}
481:                onClick={() => navigateTo('mycelium')}
545:              onClick={() => { navigateTo(route); setDrawerOpen(false) }}
579:                  <button onClick={() => navigateTo('guard')} className="btn btn-ghost">Detectar dados sensíveis</button>
982:                          <button onClick={() => navigateTo('timeline')} style={{ color: 'var(--accent)', fontSize: '14px', fontWeight: 600 }}>
1004:                      <button onClick={() => navigateTo('timeline')} className="btn btn-primary" style={{ marginTop: '16px' }}>Voltar</button>
1028:                          onClick={() => window.location.hash = `#/timeline/${art.slug}`}
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

exec
/bin/bash -lc "sed -n '260,380p' apps/egos-landing/src/App.tsx" in /home/enio/egos
 succeeded in 0ms:
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
  }, [inputText])

  const navigateTo = (route: string) => {
    window.location.hash = `#/${route}`
  }

  const formatDate = (iso: string): string => {
    return new Date(iso).toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    })
  }

  const getEpistemicBadge = (status?: string) => {
    const map: Record<string, { emoji: string; color: string; label: string }> = {
      seedling: { emoji: '🌱', color: '#4ade80', label: 'Seedling' },
      budding: { emoji: '🌿', color: '#fbbf24', label: 'Budding' },
      evergreen: { emoji: '🌲', color: '#38bdf8', label: 'Evergreen' }
    }

exec
/bin/bash -lc 'ls docs/knowledge/CAPABILITY_CROSS_INDEX.md docs/CAPABILITY_CROSS_INDEX.md 2>&1 || true; grep -R "cross_repo_capabilities" -n . --exclude-dir=.git | head -20' in /home/enio/egos
2026-06-07T20:06:00.630287Z ERROR codex_core::tools::router: error=write_stdin failed: stdin is closed for this session; rerun exec_command with tty=true to keep stdin open
exec
/bin/bash -lc "grep -n \"interaction\\|ok.*false\\|process.exit\\|results\" scripts/visual-audit.ts | tail -80" in /home/enio/egos
 succeeded in 0ms:
63:async function runInteractionTests(browser: any, results: any[]) {
77:    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-flow.png') })
78:    results.push({ name: 'interaction:consent-flow', ok: modalOk && badgeOk && heroOk,
103:    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-1-active.png') })
104:    results.push({ name: 'interaction:consent-detail', ok: detailOk && toggleOn && badge1,
126:    await page.screenshot({ path: join(OUT_DIR, 'interaction-guard-pii.png') })
127:    results.push({ name: 'interaction:guard-pii-local', ok: cpfMask && telMask && cpfTag,
149:    await page.screenshot({ path: join(OUT_DIR, 'interaction-badge-panel.png') })
150:    results.push({ name: 'interaction:badge-panel', ok: panelOk && closedOk,
210:      allResults.push({ name: p.name, ok: false, jsErrors, netErrors, error: e.message })
219:    const failedInteractions = allResults.filter(r => r.name.startsWith('interaction:') && !r.ok)
232:    results: allResults,
268:  process.exit(exitCode)
271:main().catch(e => { console.error('AUDIT ERROR:', e.message); process.exit(1) })

exec
/bin/bash -lc "sed -n '200,270p' scripts/visual-audit.ts" in /home/enio/egos
 succeeded in 0ms:

      const shot = join(OUT_DIR, `${p.name}${MOBILE ? '-mobile' : ''}.png`)
      await page.screenshot({ path: shot, fullPage: false })

      const expectedText = await page.locator(`text=${p.expect}`).first().isVisible({ timeout: 3000 }).catch(() => false)
      const ok = expectedText && jsErrors.length === 0

      allResults.push({ name: p.name, ok, jsErrors, netErrors, shot: shot.replace(ROOT, '.') })
      if (!ok) exitCode = 1
    } catch (e: any) {
      allResults.push({ name: p.name, ok: false, jsErrors, netErrors, error: e.message })
      exitCode = 1
    }
    await page.close()
  }

  // ── Interaction tests ───────────────────────────────────────────────────────
  if (!MOBILE) {
    await runInteractionTests(browser, allResults)
    const failedInteractions = allResults.filter(r => r.name.startsWith('interaction:') && !r.ok)
    if (failedInteractions.length > 0) exitCode = 1
  }

  await browser.close()
  if (devServer) devServer.kill()

  // ── Save JSON report ────────────────────────────────────────────────────────
  const report = {
    ts: new Date().toISOString(),
    base: BASE_URL,
    mobile: MOBILE,
    out: OUT_DIR,
    results: allResults,
    summary: {
      total: allResults.length,
      passed: allResults.filter(r => r.ok).length,
      failed: allResults.filter(r => !r.ok).length,
    },
  }
  writeFileSync(join(OUT_DIR, 'report.json'), JSON.stringify(report, null, 2))

  // ── Print report ────────────────────────────────────────────────────────────
  if (AS_JSON) {
    console.log(JSON.stringify(report))
  } else {
    const w = MOBILE ? '📱 mobile' : '🖥️  desktop'
    console.log(`\n╔══════════════════════════════════════╗`)
    console.log(`║  EGOS Visual Audit — ${TODAY}    ║`)
    console.log(`║  ${w.padEnd(35)} ║`)
    console.log(`╠══════════════════════════════════════╣`)

    for (const r of allResults) {
      const icon = r.ok ? '✅' : '❌'
      const errs = r.jsErrors?.length ? ` [${r.jsErrors.length} JS err]` : ''
      const net  = r.netErrors?.length ? ` [${r.netErrors.length} net err]` : ''
      console.log(`║ ${icon} ${r.name.padEnd(32)}║${errs}${net}`)
      if (r.jsErrors?.length) r.jsErrors.forEach((e: string) => console.log(`║   JS: ${e.slice(0,34).padEnd(34)} ║`))
      if (r.checks) {
        const checks = Object.entries(r.checks).map(([k,v]) => `${v ? '✓' : '✗'}${k}`).join(' ')
        console.log(`║   ${checks.slice(0,36).padEnd(36)} ║`)
      }
    }

    console.log(`╠══════════════════════════════════════╣`)
    console.log(`║  ${report.summary.passed}/${report.summary.total} passed  📁 ${OUT_DIR.split('/').slice(-2).join('/')}  ║`)
    console.log(`╚══════════════════════════════════════╝\n`)
  }

  process.exit(exitCode)
}


exec
/bin/bash -lc "nl -ba scripts/security/purge-gate.sh | sed -n '32,45p'" in /home/enio/egos
 succeeded in 0ms:
    32	fi
    33	
    34	if [ ! -f "$DICT" ]; then
    35	  echo "[purge-gate] SKIP — sem entity-dict ($DICT). Gate não-aplicável aqui (ok)."
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

codex
The patch introduces a security gate that can silently pass without performing verification when its runtime is unavailable, and it also leaves an existing visual audit interaction test failing after the hero text change. These are actionable regressions in security enforcement and validation.

Full review comments:

- [P1] Fail closed when the purge runtime is unavailable — /home/enio/egos/scripts/security/purge-gate.sh:39-41
  When an entity dict exists but `bun` is missing or not on `PATH`, this publish gate exits 0 without running `--verify-only`. In any pre-push/deploy environment with the dict configured but a broken runtime, known PII can be published because the gate reports a graceful skip instead of blocking; the no-dict case can remain optional, but once a dict is present this should fail closed.

- [P2] Update the consent-flow audit expectation — /home/enio/egos/apps/egos-landing/src/App.tsx:571-573
  After this hero copy change, `scripts/visual-audit.ts` still has the consent-flow interaction test checking for `text=IA que você pode`, so the desktop visual audit will now mark `interaction:consent-flow` as failed even though the page rendered correctly. The page manifest was updated to `O EGOS organiza`, but the interaction assertion needs the same update.
The patch introduces a security gate that can silently pass without performing verification when its runtime is unavailable, and it also leaves an existing visual audit interaction test failing after the hero text change. These are actionable regressions in security enforcement and validation.

Full review comments:

- [P1] Fail closed when the purge runtime is unavailable — /home/enio/egos/scripts/security/purge-gate.sh:39-41
  When an entity dict exists but `bun` is missing or not on `PATH`, this publish gate exits 0 without running `--verify-only`. In any pre-push/deploy environment with the dict configured but a broken runtime, known PII can be published because the gate reports a graceful skip instead of blocking; the no-dict case can remain optional, but once a dict is present this should fail closed.

- [P2] Update the consent-flow audit expectation — /home/enio/egos/apps/egos-landing/src/App.tsx:571-573
  After this hero copy change, `scripts/visual-audit.ts` still has the consent-flow interaction test checking for `text=IA que você pode`, so the desktop visual audit will now mark `interaction:consent-flow` as failed even though the page rendered correctly. The page manifest was updated to `O EGOS organiza`, but the interaction assertion needs the same update.
2026-06-07T20:06:34.872946Z ERROR codex_core::session: failed to record rollout items: thread 019ea3b0-6a27-7270-8db9-e17386ef863c not found
```
