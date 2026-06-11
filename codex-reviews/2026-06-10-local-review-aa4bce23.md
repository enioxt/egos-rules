# Codex Local Review — 2026-06-10T14:08:44Z

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
session id: 019eb1dd-3572-74f0-a6ef-06db3d1f5434
--------
user
changes against 'HEAD~3'
2026-06-10T14:08:45.782785Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-10T14:08:45.785922Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff b5b6cf57cac511c6b52151f30b439461d648779a --stat && git diff b5b6cf57cac511c6b52151f30b439461d648779a' in /home/enio/egos
 succeeded in 0ms:
 TASKS.md                                       |  21 ++-
 docs/guard-brasil/EXTENSIBILITY.md             | 181 +++++++++++++++++++++++++
 docs/presentations/mf-certificados-piloto.html |  93 +++++++++++++
 packages/guard-brasil/src/guard.ts             |  25 +++-
 packages/guard-brasil/src/lib/pii-scanner.ts   |   5 +-
 packages/guard-brasil/src/lib/public-guard.ts  |  18 ++-
 packages/guard-brasil/src/pii-patterns.ts      |  48 ++++++-
 packages/guard-brasil/src/registry/index.ts    |  21 +++
 packages/guard-brasil/src/registry/pcmg.ts     |  64 +++++++++
 packages/guard-brasil/src/registry/types.ts    |  81 +++++++++++
 10 files changed, 547 insertions(+), 10 deletions(-)
diff --git a/TASKS.md b/TASKS.md
index 2add7610..1cf6d466 100644
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
 
@@ -478,11 +479,25 @@ HERMES-DEDUP-001 (ec06bf81) · SCHEMA-001 (7b0d956c) · MIGRATE-001 (66b568ee 
 - [ ] **COURSE-INTEL-001** [P1] `hermes` 🆕 (Enio 2026-06-02) — Capability `course-market-scan` no Hermes/VPS: pesquisa contínua (semanal) do surgimento de cursos/áreas/players nas maiores plataformas, lente no espaço-branco do Enio (arquitetar+governar IA com IDE-nativo + governança + ética, ctx forense/lei). Reusa gem-hunter (descoberta) + keyword-temas (termos). Ruleset: `docs/strategy/COURSE_MARKET_RESEARCH_RULESET.md` (v1.0, escrito). **Gap confirmado:** DataVirtus/WB ensinam USAR IA; ninguém ensina ARQUITETAR/GOVERNAR. **Corte Banda:** inteligência-de-posicionamento p/ entrar em equipes, NÃO fábrica-de-curso. Build = sessão dedicada. Liga [[project_course_market_gap_research_capability]].
 - [ ] **COURSE-PROGRAM-002** [P1] `cursos-repo` — Construir MVP de conteúdo: Track 0 (M0.1–0.3) + M1.1–M1.3 (porquê governar + arquitetura + IDE-nativo). Suficiente p/ aula inaugural + 1ª turma. Conteúdo no repo de cursos separado, cada módulo referencia doc de módulo EGOS. Ondas 2-3 = guardrails/eval/MCP + co-criação + forense.
 - [ ] **COURSE-PROGRAM-003** [P1] `redzone` — Modelo de entrega (individual/grupo/turma) + estrutura comercial. **Red Zone:** pricing + estatuto PCMG (magistério=seguro, comércio=cuidado) + LGPD de dado de aluno na co-criação + banir absolutos. Corte Enio antes de publicar.
-- [/] **COURSE-LGPD-001** [P1] `redzone` — ✅ 80% feito 2026-06-02 (sessão Prime): curso "Ciber+IA+LGPD" CONSTRUÍDO — roteiro 11 slides (`docs/presentations/CURSO_CIBER_IA_LGPD_notebooklm.md`) + conteúdo legal (`docs/cybersecurity/lgpd-investigacao.md`) + Caso Alfa 5 labs (`caso-alfa-sintetico.md`) + plano de aula 8 módulos (`plano-de-aula.md`) + NotebookLM 5 fontes (`7d00074b`) + briefing fiel. **Posições do Enio aplicadas** (LGPD regime especial / human-in-command Art 20 / ensinar→provar→propor). **Resta:** (a) deck visual no Studio UI (API falha §7 SLIDE_STANDARD); (b) conferência redação LGPD/ANPD = área do Enio.
+- [/] **COURSE-LGPD-001** [P1] `redzone` — ✅ 90% feito 2026-06-10: HTML humano pronto (`docs/presentations/curso-ciber-ia-lgpd-lidia.html`), roteiro v1.2 auditado Banda, 9 módulos M0-M8 coerentes, labs 1-5 alinhados ao Caso Alfa. ZIP 28K em `/tmp/curso-ciber-lgpd-lidia-jun2026-v2.zip`. Slides PT-BR + vídeo gerando (NotebookLM `7d00074b`, artifact `57c73cbb`/`c8fcfe78`). **Resta:** (a) Enio revisar HTML + confirmar com Lídia; (b) conferência redação LGPD/ANPD antes de ministrar; (c) demo gravável Guard Brasil (`bun packages/guard-brasil/src/demo.ts`). **HITL Enio:** agendar sessão com Lídia para feedback do material.
 - [/] **COURSE-OVM-001** [P1] `redzone` 🆕 — ✅ CONSTRUÍDO 2026-06-02: curso OVM (Oitivas Virtuais Móveis) mesma receita — roteiro 11 slides (`CURSO_OVM_notebooklm.md`) + Caso Beta 5 labs (`docs/courses/ovm/ovm-caso-beta-sintetico.md`) + plano 6 módulos (sigilo=módulo crítico/reprovativo) + NotebookLM 3 fontes (`61befc41`) + briefing fiel. Estrutura lida só do workflow OVM; **zero dado real**. Resta: deck visual UI + limites operacionais de unidade (corte Enio).
 - [ ] **COURSE-CONVERGE-001** [P1] — Convergir os 2 cursos polícia-específicos (COURSE-LGPD + COURSE-OVM, Prime) com o COURSE-PROGRAM 4-tracks "Construa e Governe a SUA IA" (público geral, outra janela). **NÃO são duplicata:** programa = geral build+govern; meus 2 = polícia (cyber/LGPD + OVM). Decidir: viram tracks do programa? produto separado? Corte Enio. SSOT a unificar quando criar o repo de cursos.
 - [ ] **COURSE-GOV-PITCH-001** [P2] `redzone` — Proposta pro governo (polícia roda modelo próprio local/soberano + framework aberto auditável). Deriva do curso. HITL — nada de pitch público sem corte do Enio.
 
+## 🛡️ GUARD BRASIL — Extensibilidade e HITL
+
+> **Diferencial real:** Guard Brasil é agnóstico de formato. O núcleo é infraestrutura; cada instituição define seus padrões sem tocar no core. HITL valida antes de produção.
+> **SSOT:** `docs/guard-brasil/EXTENSIBILITY.md` | **Registry:** `packages/guard-brasil/src/registry/`
+> **Status:** `customPatterns` wired em `GuardBrasilConfig → maskPublicOutput → scanForPII`. PCMG profile v0.1.0 criado. 46/46 testes passando.
+
+- [ ] **GUARD-HITL-001** [P1] `enio` — **HITL Enio revisar corpus PCMG**: 20 matches sintéticos do perfil `pcmg`. Confirmar/rejeitar cada match → atualizar `hitlStats` em `pcmg.ts`. Falso positivo conhecido: `IPL-1234/2024` capturado como placa — ajustar regex do `pcmg:inquerito`. Objetivo: promover padrões de `low` → `medium`. Depende de GUARD-HITL-002.
+- [ ] **GUARD-HITL-002** [P1] `prime` — Corpus sintético PCMG: 10 frases por padrão (BO, IPL, REDS complementar, TC) + runner que exibe cada match para revisão humana. Output: `packages/guard-brasil/src/registry/pcmg-corpus.json`.
+- [ ] **GUARD-HITL-003** [P2] `prime` — Export/import de perfis como JSON portável (`export.ts` + `import.ts`). Serializa regex como string; compartilhável sem dependências de código.
+- [ ] **GUARD-HITL-004** [P2] `prime` — Perfis adicionais: TJMG (processo estadual MG), SES-MG (prontuário/SUS-MG), DETRAN-MG (RENAVAM-MG). Todos `confidence: 'low'`, aguarda HITL-001 como template.
+- [ ] **GUARD-HITL-005** [P2] `prime` — API `POST /guard/patterns` — adicionar padrão via formulário (label + regex + maskFormat) sem código. Retorna JSON + preview de matches. Gate: HITL Enio antes de prod.
+- [ ] **GUARD-HITL-006** [P3] `prime` — Auto-promoção de confiança: após N confirmações, `computeConfidenceFromHITL()` atualiza o `hitlStats`, exporta JSON atualizado, notifica mantenedor via Telegram.
+- [ ] **GUARD-VIDEO-001** [P1] `enio` — **HITL Enio gravar demo** (3min): `bun packages/guard-brasil/src/demo.ts` + `benchmark.ts` no terminal. Mostra: MASP+REDS+CPF detectados, ATRiAN flag "Com certeza", evidence hash SHA-256. Cobre Labs 1+2+4 do Caso Alfa ao vivo. Sem dado real.
+
 ## 🧠 CHATBOT QUALITY — GOV + Wave 0
 
 ### 🏛️ Governance pendente 2026-05-22
diff --git a/docs/guard-brasil/EXTENSIBILITY.md b/docs/guard-brasil/EXTENSIBILITY.md
new file mode 100644
index 00000000..3977b315
--- /dev/null
+++ b/docs/guard-brasil/EXTENSIBILITY.md
@@ -0,0 +1,181 @@
+# Guard Brasil — Extensibilidade e Treinamento HITL
+
+> **SSOT desta arquitetura:** este arquivo.
+> **Código:** `packages/guard-brasil/src/registry/`
+> **Versão:** v0.1.0 — 2026-06-10
+
+---
+
+## O que é o diferencial real
+
+Guard Brasil não é um scanner que conhece MASP e REDS.
+
+O diferencial é: **qualquer instituição adiciona seus próprios formatos sem tocar no núcleo**, com um ciclo de validação humana (HITL) que aumenta a confiança nos padrões ao longo do tempo.
+
+Cada estado, tribunal, secretaria de saúde, instituição policial tem identificadores em formatos que nenhum scanner genérico conhece. Guard Brasil é **agnóstico de formato** — o núcleo entrega a infraestrutura; cada perfil entrega os padrões.
+
+---
+
+## Arquitetura
+
+```
+GuardBrasil.create({
+  customPatterns: PCMG_PROFILE.patterns   ← perfil de instituição
+})
+
+↓
+
+maskPublicOutput(text, { customPatterns })
+
+↓
+
+scanForPII(text, { extraPatterns })       ← padrões built-in + customizados
+
+↓
+
+HITL Review Loop                          ← humano confirma/rejeita matches
+  → confirma: hitlStats.confirmations++
+  → rejeita:  hitlStats.rejections++
+  → após N confirmações: confidence 'low' → 'medium' → 'high'
+```
+
+---
+
+## Ciclo de vida de um padrão
+
+```
+1. Criar     → confidence: 'low'   (nunca viu dado real)
+2. Treinar   → rodar em corpus sintético / anonimizado
+3. Revisar   → HITL UI: humano confirma/rejeita cada match
+4. Promover  → 10 confirmações: 'medium' | 30 confirmações: 'high'
+5. Exportar  → JSON portável, sem código
+6. Importar  → qualquer ambiente sem rebuild
+```
+
+### Thresholds de promoção
+| Confirmações | Rejeição < 20% | Nível resultante |
+|---|---|---|
+| 0–9 | qualquer | `low` |
+| 10–29 | sim | `medium` |
+| 30+ | sim | `high` |
+| qualquer | ≥ 20% | rebaixa para `low` |
+
+---
+
+## Como criar um perfil de instituição
+
+```typescript
+// packages/guard-brasil/src/registry/meu-tribunal.ts
+import type { InstitutionProfile } from './types.js';
+
+export const TJSP_PROFILE: InstitutionProfile = {
+  id: 'tjsp',
+  name: 'Tribunal de Justiça de São Paulo',
+  scope: 'court',
+  state: 'SP',
+  version: '0.1.0',
+  updatedAt: '2026-06-10',
+  patterns: [
+    {
+      id: 'tjsp:processo_estadual',
+      label: 'Número de Processo TJSP (formato estadual)',
+      regex: /\b\d{7}-\d{2}\.\d{4}\.\d\.\d{2}\.\d{4}\b/g,
+      maskFormat: '[PROCESSO REMOVIDO]',
+      confidence: 'low',           // ← começa baixo sempre
+      hitlStats: { confirmations: 0, rejections: 0 },
+    },
+  ],
+};
+```
+
+Depois use assim:
+```typescript
+import { GuardBrasil } from '@egos/guard-brasil';
+import { TJSP_PROFILE } from './registry/meu-tribunal.js';
+
+const guard = GuardBrasil.create({
+  customPatterns: TJSP_PROFILE.patterns,
+});
+
+const result = guard.inspect(textoDoSistema);
+```
+
+---
+
+## Como exportar / importar sem código
+
+Padrões são JSON puro:
+```bash
+# Exportar perfil como JSON
+bun packages/guard-brasil/src/registry/export.ts --profile pcmg > pcmg-v0.1.0.json
+
+# Importar em outro ambiente
+bun packages/guard-brasil/src/registry/import.ts pcmg-v0.1.0.json
+```
+
+O JSON é auto-contido — regex serializada como string, confidence inclusa, hitlStats preservados. Compartilha entre equipes sem instalar dependências.
+
+---
+
+## HITL — Fluxo de validação humana
+
+### Por que HITL é obrigatório
+
+Um padrão regex sem validação humana tem dois riscos:
+- **Falso positivo**: mascara coisa que não é PII → destrói contexto
+- **Falso negativo**: não detecta o formato real → vaza dado
+
+O HITL fecha esse loop: o humano vê os matches reais (em dado sintético/anonimizado), confirma os corretos, rejeita os errados, e o sistema aprende.
+
+### Fluxo completo
+
+```
+[Novo padrão: confidence=low]
+        ↓
+[Corpus sintético ou anonimizado]
+        ↓
+[Guard escaneia → lista de matches suspeitos]
+        ↓
+[HITL UI: revisor vê texto + match destacado]
+  → ✅ Correto (é PII)     → confirmations++
+  → ❌ Errado (falso +)    → rejections++
+  → ⚠️  Parcial (regex ok, contexto não) → ambos++
+        ↓
+[computeConfidenceFromHITL() → novo nível]
+        ↓
+[Exportar padrão atualizado]
+```
+
+### Interface HITL (a implementar — GUARD-HITL-001)
+
+O revisor vê:
+```
+Padrão: pcmg:bo_numero | Texto: "BO nº 2024/098765 foi registrado"
+                                  ^^^^^^^^^^^^^^^^^^^
+Esse trecho é um número de BO? [✅ Sim] [❌ Não] [⚠️ Parcial]
+```
+
+---
+
+## Perfis disponíveis
+
+| Perfil | Instituição | Estado | Padrões | Status HITL |
+|---|---|---|---|---|
+| `pcmg` | Polícia Civil MG | MG | 4 | 🔴 Pendente (0 confirmações) |
+
+---
+
+## Roadmap HITL (tasks em TASKS.md)
+
+| Task | O que é | Prioridade |
+|---|---|---|
+| GUARD-HITL-001 | Interface web de revisão (próximo match → confirmar/rejeitar) | P1 |
+| GUARD-HITL-002 | Runner de corpus sintético + relatório de cobertura | P1 |
+| GUARD-HITL-003 | Export/import de perfis como JSON | P2 |
+| GUARD-HITL-004 | Perfis adicionais: TJMG, SES-MG, DETRAN-MG | P2 |
+| GUARD-HITL-005 | API `POST /guard/patterns` para adicionar padrões via UI, sem código | P2 |
+| GUARD-HITL-006 | Ciclo automático: N confirmações → promove → notifica mantenedor | P3 |
+
+---
+
+*EGOS Framework · Guard Brasil v0.2.0 · docs/guard-brasil/EXTENSIBILITY.md*
diff --git a/docs/presentations/mf-certificados-piloto.html b/docs/presentations/mf-certificados-piloto.html
index e2833546..40de3255 100644
--- a/docs/presentations/mf-certificados-piloto.html
+++ b/docs/presentations/mf-certificados-piloto.html
@@ -256,6 +256,7 @@ tr:hover td { background: var(--bg); }
   <a class="sidebar-link" href="#fluxo">Fluxo do cliente</a>
   <a class="sidebar-link" href="#canal-e-tela">Canal e tela segura</a>
   <a class="sidebar-link" href="#multitenant">Replicável por construção</a>
+  <a class="sidebar-link" href="#memoria-e-modelo">Como o agente lembra e decide</a>
   <a class="sidebar-link" href="#privacidade">Segurança do CPF</a>
   <a class="sidebar-link" href="#compliance">Compliance LGPD</a>
 
@@ -547,6 +548,98 @@ tr:hover td { background: var(--bg); }
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
diff --git a/packages/guard-brasil/src/guard.ts b/packages/guard-brasil/src/guard.ts
index ee54f1bf..53c8790a 100644
--- a/packages/guard-brasil/src/guard.ts
+++ b/packages/guard-brasil/src/guard.ts
@@ -22,7 +22,7 @@ import {
   type EvidenceChainOptions,
   type ConfidenceLevel,
 } from './lib/index.js';
-import { type MaskMode } from './pii-patterns.js';
+import { type MaskMode, type CustomPIIPattern } from './pii-patterns.js';
 
 // ─── Types ────────────────────────────────────────────────────────────────────
 
@@ -35,6 +35,27 @@ export interface GuardBrasilConfig {
   lgpdDisclosure?: boolean;
   /** Default confidence level for unattributed claims (default: 'medium') */
   defaultConfidence?: ConfidenceLevel;
+  /**
+   * Institution-specific custom PII patterns.
+   * Guard Brasil is format-agnostic — each state, court, health system, or
+   * police force defines their own identifier formats here without touching core.
+   *
+   * Example — PCMG profile:
+   *   customPatterns: PCMG_PROFILE.patterns
+   *
+   * Example — inline:
+   *   customPatterns: [{
+   *     id: 'tjmg:numero_externo',
+   *     label: 'Número Externo TJMG',
+   *     regex: /\bEXT-\d{4}-\d{6}\b/g,
+   *     maskFormat: '[NR EXTERNO REMOVIDO]',
+   *     confidence: 'medium',
+   *   }]
+   *
+   * HITL training: start with confidence 'low', validate via HITL UI,
+   * auto-promote to 'high' after N confirmations.
+   */
+  customPatterns?: CustomPIIPattern[];
 }
 
 export interface InspectOptions {
@@ -172,6 +193,7 @@ export class GuardBrasil {
       blockOnCriticalPII: config.blockOnCriticalPII ?? false,
       lgpdDisclosure: config.lgpdDisclosure ?? true,
       defaultConfidence: config.defaultConfidence ?? 'medium',
+      customPatterns: config.customPatterns ?? [],
     };
     this.atrian = createAtrianValidator(this.config.atrian);
   }
@@ -202,6 +224,7 @@ export class GuardBrasil {
     const maskingResult = maskPublicOutput(text, {
       criticalPiiAction: this.config.blockOnCriticalPII ? 'block' : 'redact',
       maskMode: options.maskMode,
+      customPatterns: this.config.customPatterns,
     });
 
     const blocked = maskingResult.masked.startsWith('[CONTEÚDO BLOQUEADO');
diff --git a/packages/guard-brasil/src/lib/pii-scanner.ts b/packages/guard-brasil/src/lib/pii-scanner.ts
index 8014df72..9b341def 100644
--- a/packages/guard-brasil/src/lib/pii-scanner.ts
+++ b/packages/guard-brasil/src/lib/pii-scanner.ts
@@ -55,9 +55,10 @@ DEFAULT_PII_PATTERNS.push(DATE_OF_BIRTH_PATTERN);
 const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
 const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);
 
-export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
+export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
   const findings: PIIFinding[] = [];
-  const patterns = options?.patterns ?? DEFAULT_PII_PATTERNS;
+  const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
+  const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
   for (const { category, label, suggestion, pattern } of patterns) {
     const activePattern = clonePattern(pattern);
     let match: RegExpExecArray | null;
diff --git a/packages/guard-brasil/src/lib/public-guard.ts b/packages/guard-brasil/src/lib/public-guard.ts
index 70a4e4b4..ad86cdb8 100644
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
@@ -29,6 +29,12 @@ export interface PublicGuardConfig {
    * - 'partial': banking-style partial reveal → ***.456.789-**
    */
   maskMode?: MaskMode;
+  /**
+   * Custom PII patterns to merge with built-in patterns.
+   * Each institution/state/situation defines their own identifiers.
+   * These run AFTER built-in patterns — no conflicts.
+   */
+  customPatterns?: CustomPIIPattern[];
 }
 
 export interface MaskingResult {
@@ -66,7 +72,13 @@ export function maskPublicOutput(text: string, config: PublicGuardConfig = {}):
   const piiAction = config.piiAction ?? 'mask';
   const criticalPiiAction = config.criticalPiiAction ?? 'redact';
 
-  const findings = scanForPII(text);
+  const extraPatterns: PIIPatternDefinition[] = (config.customPatterns ?? []).map(p => ({
+    category: p.id as never,
+    label: p.label,
+    pattern: p.regex,
+    suggestion: p.maskFormat,
+  }));
+  const findings = scanForPII(text, extraPatterns.length > 0 ? { extraPatterns } : undefined);
   const sensitivityLevel = computeSensitivity(findings);
 
   const actionsMap = new Map<string, MaskingAction>();
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
 
diff --git a/packages/guard-brasil/src/registry/index.ts b/packages/guard-brasil/src/registry/index.ts
new file mode 100644
index 00000000..7e424baa
--- /dev/null
+++ b/packages/guard-brasil/src/registry/index.ts
@@ -0,0 +1,21 @@
+/**
+ * Institution Profile Registry — index
+ *
+ * Available profiles:
+ *   - PCMG: Polícia Civil de Minas Gerais (v0.1.0 — HITL pending)
+ *
+ * Usage:
+ *   import { PCMG_PROFILE } from '@egos/guard-brasil/registry';
+ *   const guard = GuardBrasil.create({ customPatterns: PCMG_PROFILE.patterns });
+ *
+ * Contributing a new profile:
+ *   1. Create `<institution>.ts` in this directory
+ *   2. Export an `InstitutionProfile` following the type contract
+ *   3. Add patterns with `confidence: 'low'`
+ *   4. Run HITL validation: `bun packages/guard-brasil/src/registry/hitl-runner.ts --profile <id>`
+ *   5. Export as JSON for sharing: profiles are self-contained and require no code change to use
+ */
+
+export { PCMG_PROFILE } from './pcmg.js';
+export { computeConfidenceFromHITL, HITL_CONFIDENCE_THRESHOLDS } from './types.js';
+export type { InstitutionProfile, HITLReviewResult } from './types.js';
diff --git a/packages/guard-brasil/src/registry/pcmg.ts b/packages/guard-brasil/src/registry/pcmg.ts
new file mode 100644
index 00000000..8a0ca7e0
--- /dev/null
+++ b/packages/guard-brasil/src/registry/pcmg.ts
@@ -0,0 +1,64 @@
+/**
+ * PCMG Institution Profile
+ * Polícia Civil de Minas Gerais — identifiers specific to the MG state system.
+ *
+ * MASP and REDS are already in Guard Brasil core.
+ * This profile adds the remaining MG-specific formats not covered by built-ins.
+ *
+ * Status: v0.1.0 — DRAFT, awaiting HITL validation on synthetic corpus.
+ * All patterns start at confidence 'low' until validated.
+ */
+
+import type { InstitutionProfile } from './types.js';
+
+export const PCMG_PROFILE: InstitutionProfile = {
+  id: 'pcmg',
+  name: 'Polícia Civil de Minas Gerais',
+  scope: 'state',
+  state: 'MG',
+  version: '0.1.0',
+  updatedAt: '2026-06-10',
+  maintainer: 'EGOS Framework (hitl-pending)',
+  patterns: [
+    {
+      id: 'pcmg:bo_numero',
+      label: 'Número de BO (Boletim de Ocorrência MG)',
+      // Format observed: AAAA/NNNNNN e.g. 2024/098765 — similar to REDS but different prefix context
+      // REDS is in core; this catches plain BO references without REDS prefix
+      regex: /\bBO\s*n[ºo°.]?\s*\d{4}\/\d{6,8}\b/gi,
+      maskFormat: '[BO REMOVIDO]',
+      confidence: 'low',
+      description: 'Número de boletim de ocorrência no formato PCMG. REDS é o formato moderno; BO é o legado.',
+      hitlStats: { confirmations: 0, rejections: 0 },
+    },
+    {
+      id: 'pcmg:inquerito',
+      label: 'Número de Inquérito Policial MG',
+      // Format: IPL NNNN/AAAA or IP-NNNN/AAAA
+      regex: /\bI[Pp][Ll]?[-\s]*\d{3,6}\/\d{4}\b/g,
+      maskFormat: '[IPL REMOVIDO]',
+      confidence: 'low',
+      description: 'Número de inquérito policial. Formato PCMG.',
+      hitlStats: { confirmations: 0, rejections: 0 },
+    },
+    {
+      id: 'pcmg:reds_complemento',
+      label: 'REDS — formato complementar',
+      // Extended REDS variants seen in complementary records
+      regex: /\bREDS[-\s]?\d{4}[-\/]\d{9,12}[-\/]\d{3,4}\b/gi,
+      maskFormat: '[REDS REMOVIDO]',
+      confidence: 'medium',
+      description: 'Variante de REDS com campos extras (delegacia + número de registro).',
+      hitlStats: { confirmations: 0, rejections: 0 },
+    },
+    {
+      id: 'pcmg:termo_circunstanciado',
+      label: 'Número de Termo Circunstanciado MG',
+      regex: /\bTC[-\s]*\d{3,6}\/\d{4}\b/g,
+      maskFormat: '[TC REMOVIDO]',
+      confidence: 'low',
+      description: 'Termo Circunstanciado de Ocorrência — infrações de menor potencial ofensivo.',
+      hitlStats: { confirmations: 0, rejections: 0 },
+    },
+  ],
+};
diff --git a/packages/guard-brasil/src/registry/types.ts b/packages/guard-brasil/src/registry/types.ts
new file mode 100644
index 00000000..6f66ac0b
--- /dev/null
+++ b/packages/guard-brasil/src/registry/types.ts
@@ -0,0 +1,81 @@
+/**
+ * Institution Profile Registry — Guard Brasil extensibility layer
+ *
+ * Every state, court, health system or police force has identifiers
+ * in formats that generic scanners don't know. This registry lets each
+ * institution define its own PII patterns without touching Guard Brasil core.
+ *
+ * Design principle: Guard Brasil is format-agnostic.
+ * The core knows CPF, CNPJ, MASP, REDS. Everything else comes through profiles.
+ */
+
+import type { CustomPIIPattern, PatternConfidence } from '../pii-patterns.js';
+
+/**
+ * Institution profile — a named bundle of custom PII patterns.
+ *
+ * Lifecycle:
+ *   1. Create profile with patterns at confidence 'low'
+ *   2. Run guard on anonymized/synthetic corpus → review in HITL UI
+ *   3. Confirm/reject each match → confidence auto-upgrades
+ *   4. Export as JSON for sharing across environments (no code change)
+ *   5. Import in target environment: `GuardBrasil.create({ customPatterns: profile.patterns })`
+ */
+export interface InstitutionProfile {
+  /** Unique namespace — use in pattern IDs: `<id>:<pattern_name>` */
+  id: string;
+  /** Human-readable name */
+  name: string;
+  /** State or federal scope */
+  scope: 'federal' | 'state' | 'municipal' | 'court' | 'health' | 'education' | 'other';
+  /** Brazilian state code (e.g. 'MG', 'SP') if state-scoped */
+  state?: string;
+  /** Custom patterns defined by this institution */
+  patterns: CustomPIIPattern[];
+  /** Profile version — bump when patterns change */
+  version: string;
+  /** When this profile was last updated */
+  updatedAt: string;
+  /** Contact or responsible team */
+  maintainer?: string;
+}
+
+/**
+ * Result of a HITL review session.
+ * Each human-reviewed match updates the pattern's hitlStats.
+ */
+export interface HITLReviewResult {
+  patternId: string;
+  matchedText: string;
+  isCorrect: boolean;
+  reviewedBy: string;
+  reviewedAt: string;
+  note?: string;
+}
+
+/**
+ * Thresholds for confidence auto-promotion via HITL.
+ * After enough confirmations, the pattern earns more trust.
+ */
+export const HITL_CONFIDENCE_THRESHOLDS: Record<PatternConfidence, number> = {
+  low: 0,
+  medium: 10,
+  high: 30,
+};
+
+/**
+ * Computes updated confidence after a HITL review batch.
+ * Promotes when confirmations exceed threshold AND rejection rate < 20%.
+ */
+export function computeConfidenceFromHITL(
+  stats: NonNullable<CustomPIIPattern['hitlStats']>,
+  current: PatternConfidence,
+): PatternConfidence {
+  const total = stats.confirmations + stats.rejections;
+  if (total === 0) return current;
+  const rejectionRate = stats.rejections / total;
+  if (rejectionRate > 0.2) return 'low';
+  if (stats.confirmations >= HITL_CONFIDENCE_THRESHOLDS.high) return 'high';
+  if (stats.confirmations >= HITL_CONFIDENCE_THRESHOLDS.medium) return 'medium';
+  return current;
+}

exec
/bin/bash -lc "find packages/guard-brasil -maxdepth 3 -type f | sort && cat packages/guard-brasil/package.json && sed -n '1,280p' packages/guard-brasil/src/lib/public-guard.ts && sed -n '1,140p' packages/guard-brasil/src/lib/pii-scanner.ts && sed -n '1,280p' packages/guard-brasil/src/pii-patterns.ts" in /home/enio/egos
 succeeded in 0ms:
packages/guard-brasil/.git/AUTO_MERGE
packages/guard-brasil/.git/COMMIT_EDITMSG
packages/guard-brasil/.git/FETCH_HEAD
packages/guard-brasil/.git/HEAD
packages/guard-brasil/.git/ORIG_HEAD
packages/guard-brasil/.git/config
packages/guard-brasil/.git/description
packages/guard-brasil/.git/hooks/applypatch-msg.sample
packages/guard-brasil/.git/hooks/commit-msg.sample
packages/guard-brasil/.git/hooks/fsmonitor-watchman.sample
packages/guard-brasil/.git/hooks/post-update.sample
packages/guard-brasil/.git/hooks/pre-applypatch.sample
packages/guard-brasil/.git/hooks/pre-commit.sample
packages/guard-brasil/.git/hooks/pre-merge-commit.sample
packages/guard-brasil/.git/hooks/pre-push.sample
packages/guard-brasil/.git/hooks/pre-rebase.sample
packages/guard-brasil/.git/hooks/pre-receive.sample
packages/guard-brasil/.git/hooks/prepare-commit-msg.sample
packages/guard-brasil/.git/hooks/push-to-checkout.sample
packages/guard-brasil/.git/hooks/sendemail-validate.sample
packages/guard-brasil/.git/hooks/update.sample
packages/guard-brasil/.git/index
packages/guard-brasil/.git/info/exclude
packages/guard-brasil/.git/logs/HEAD
packages/guard-brasil/README.md
packages/guard-brasil/check.ts
packages/guard-brasil/dist/benchmark.d.ts
packages/guard-brasil/dist/benchmark.d.ts.map
packages/guard-brasil/dist/benchmark.js
packages/guard-brasil/dist/benchmark.js.map
packages/guard-brasil/dist/guard.d.ts
packages/guard-brasil/dist/guard.d.ts.map
packages/guard-brasil/dist/guard.js
packages/guard-brasil/dist/guard.js.map
packages/guard-brasil/dist/index.d.ts
packages/guard-brasil/dist/index.d.ts.map
packages/guard-brasil/dist/index.js
packages/guard-brasil/dist/index.js.map
packages/guard-brasil/dist/keys.d.ts
packages/guard-brasil/dist/keys.d.ts.map
packages/guard-brasil/dist/keys.js
packages/guard-brasil/dist/keys.js.map
packages/guard-brasil/dist/lib/atrian.d.ts
packages/guard-brasil/dist/lib/atrian.d.ts.map
packages/guard-brasil/dist/lib/atrian.js
packages/guard-brasil/dist/lib/atrian.js.map
packages/guard-brasil/dist/lib/evidence-chain.d.ts
packages/guard-brasil/dist/lib/evidence-chain.d.ts.map
packages/guard-brasil/dist/lib/evidence-chain.js
packages/guard-brasil/dist/lib/evidence-chain.js.map
packages/guard-brasil/dist/lib/index.d.ts
packages/guard-brasil/dist/lib/index.d.ts.map
packages/guard-brasil/dist/lib/index.js
packages/guard-brasil/dist/lib/index.js.map
packages/guard-brasil/dist/lib/pii-scanner.d.ts
packages/guard-brasil/dist/lib/pii-scanner.d.ts.map
packages/guard-brasil/dist/lib/pii-scanner.js
packages/guard-brasil/dist/lib/pii-scanner.js.map
packages/guard-brasil/dist/lib/provenance.d.ts
packages/guard-brasil/dist/lib/provenance.d.ts.map
packages/guard-brasil/dist/lib/provenance.js
packages/guard-brasil/dist/lib/provenance.js.map
packages/guard-brasil/dist/lib/public-guard.d.ts
packages/guard-brasil/dist/lib/public-guard.d.ts.map
packages/guard-brasil/dist/lib/public-guard.js
packages/guard-brasil/dist/lib/public-guard.js.map
packages/guard-brasil/dist/lib/tokenizer.d.ts
packages/guard-brasil/dist/lib/tokenizer.d.ts.map
packages/guard-brasil/dist/lib/tokenizer.js
packages/guard-brasil/dist/lib/tokenizer.js.map
packages/guard-brasil/dist/pii-patterns.d.ts
packages/guard-brasil/dist/pii-patterns.d.ts.map
packages/guard-brasil/dist/pii-patterns.js
packages/guard-brasil/dist/pii-patterns.js.map
packages/guard-brasil/dist/telemetry.d.ts
packages/guard-brasil/dist/telemetry.d.ts.map
packages/guard-brasil/dist/telemetry.js
packages/guard-brasil/dist/telemetry.js.map
packages/guard-brasil/package.json
packages/guard-brasil/src/benchmark.ts
packages/guard-brasil/src/demo.ts
packages/guard-brasil/src/guard.test.ts
packages/guard-brasil/src/guard.ts
packages/guard-brasil/src/index.ts
packages/guard-brasil/src/keys.ts
packages/guard-brasil/src/lib/atrian.ts
packages/guard-brasil/src/lib/evidence-chain.ts
packages/guard-brasil/src/lib/index.ts
packages/guard-brasil/src/lib/pii-scanner.ts
packages/guard-brasil/src/lib/provenance.ts
packages/guard-brasil/src/lib/public-guard.ts
packages/guard-brasil/src/lib/tokenizer.ts
packages/guard-brasil/src/pii-patterns.ts
packages/guard-brasil/src/registry/index.ts
packages/guard-brasil/src/registry/pcmg.ts
packages/guard-brasil/src/registry/types.ts
packages/guard-brasil/src/telemetry.ts
packages/guard-brasil/test_db.ts
packages/guard-brasil/tsconfig.build.json
packages/guard-brasil/tsconfig.json
packages/guard-brasil/tsconfig.tsbuildinfo
{
  "name": "@egosbr/guard-brasil",
  "version": "0.2.3",
  "description": "Brazilian AI safety layer — LGPD-compliant PII masking, ATRiAN ethical validation, and traceable evidence discipline for AI assistants",
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  },
  "files": [
    "dist",
    "README.md",
    "LICENSE"
  ],
  "keywords": [
    "lgpd",
    "pii",
    "brazil",
    "ai-safety",
    "guardrails",
    "compliance",
    "evidence-chain",
    "atrian",
    "brazilian",
    "cpf",
    "privacy",
    "masking"
  ],
  "author": "Enio Rocha <enio@egos.ia.br>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git",
    "directory": "packages/guard-brasil"
  },
  "homepage": "https://github.com/enioxt/egos/tree/main/packages/guard-brasil#readme",
  "scripts": {
    "build": "tsc -p tsconfig.build.json",
    "typecheck": "tsc --noEmit -p tsconfig.json",
    "test": "bun test src/guard.test.ts",
    "demo": "bun run src/demo.ts",
    "prepublishOnly": "npm run build"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.101.1"
  }
}
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
  /**
   * Custom PII patterns to merge with built-in patterns.
   * Each institution/state/situation defines their own identifiers.
   * These run AFTER built-in patterns — no conflicts.
   */
  customPatterns?: CustomPIIPattern[];
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

  const extraPatterns: PIIPatternDefinition[] = (config.customPatterns ?? []).map(p => ({
    category: p.id as never,
    label: p.label,
    pattern: p.regex,
    suggestion: p.maskFormat,
  }));
  const findings = scanForPII(text, extraPatterns.length > 0 ? { extraPatterns } : undefined);
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

export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
  const findings: PIIFinding[] = [];
  const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
  const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
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
  regex: /\b[A-Z]{3}[-\s]?\d{4}(?![-\d])/gi,
  maskFormat: '[PLACA REMOVIDA]',
  confidence: 'medium',
  description: 'Placa formato antigo — AAA-0000. Lookahead (?![-\\d]) prevents FP-001: ID patterns like INV-2024-001.',
};

/** Placa Mercosul — formato Mercosul (AAA0A00) */
export const PLACA_MERCOSUL_PATTERN: PIIPatternConfig = {
  id: 'placa_mercosul',
  label: 'Placa Veicular',
  regex: /\b[A-Z]{3}\d[A-Z]\d{2}\b/gi,
  maskFormat: '[PLACA REMOVIDA]',
  confidence: 'medium',
  description: 'Placa formato Mercosul — AAA0A00',
};

/** Telefone — números brasileiros (com ou sem DDI/DDD) */
export const TELEFONE_PATTERN: PIIPatternConfig = {
  id: 'telefone',
  label: 'Telefone',
  regex: /\b(?:\+55\s?)?(?:\(?\d{2}\)?\s?)\d{4,5}[-.\s]?\d{4}\b/g,
  maskFormat: '[TELEFONE REMOVIDO]',
  confidence: 'medium',
  description: 'Telefone brasileiro — +55 (00) 00000-0000',
  // (31) ****-5432 — keep area code + last 4 digits
  partialMaskFn: (matched) => {
    const d = matched.replace(/\D/g, '');
    if (d.length < 10) return '[TELEFONE REMOVIDO]';
    // last 4 digits always visible; first 2 = DDD
    const ddd = d.slice(0, 2);
    const last4 = d.slice(-4);
    return `(${ddd}) ****-${last4}`;
  },
};

/** Email */
export const EMAIL_PATTERN: PIIPatternConfig = {
  id: 'email',
  label: 'Email',
  regex: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g,
  maskFormat: '[EMAIL REMOVIDO]',
  confidence: 'high',
  description: 'Endereço de email',
  // j***@e*****.com.br — first char of local + first char of domain + extension
  partialMaskFn: (matched) => {
    const [local, domain] = matched.split('@');
    if (!local || !domain) return '[EMAIL REMOVIDO]';
    const dotIdx = domain.lastIndexOf('.');
    const domainName = dotIdx > 0 ? domain.slice(0, dotIdx) : domain;
    const tld = dotIdx > 0 ? domain.slice(dotIdx) : '';
    const maskedLocal = local[0] + '***';
    const maskedDomain = domainName[0] + '*'.repeat(Math.max(1, domainName.length - 1));
    return `${maskedLocal}@${maskedDomain}${tld}`;
  },
};

/** Cartão SUS — Cartão Nacional de Saúde (15 digits) */
export const SUS_PATTERN: PIIPatternConfig = {
  id: 'sus',
  label: 'Cartão SUS',

exec
/bin/bash -lc "sed -n '1,220p' packages/guard-brasil/src/index.ts && sed -n '1,300p' packages/guard-brasil/src/guard.ts && sed -n '1,220p' packages/guard-brasil/src/guard.test.ts && cat packages/guard-brasil/tsconfig.build.json" in /home/enio/egos
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
 * GuardBrasil — Unified facade for the Brazilian AI safety layer.
 *
 * Composes ATRiAN + PII Scanner + Public Guard + Evidence Chain
 * into a single call that validates, masks, and audits any LLM output.
 */

import {
  createAtrianValidator,
  maskPublicOutput,
  buildLGPDDisclosure,
  createEvidenceChain,
  formatEvidenceBlock,
  buildAuditFields,
  sha256Text,
  sourceFingerprint,
  type AtrianConfig,
  type AtrianResult,
  type MaskingResult,
  type EvidenceChain,
  type AuditFields,
  type EvidenceChainOptions,
  type ConfidenceLevel,
} from './lib/index.js';
import { type MaskMode, type CustomPIIPattern } from './pii-patterns.js';

// ─── Types ────────────────────────────────────────────────────────────────────

export interface GuardBrasilConfig {
  /** ATRiAN configuration — ethical validation */
  atrian?: AtrianConfig;
  /** Block output entirely if critical PII found (default: false — masks instead) */
  blockOnCriticalPII?: boolean;
  /** Add LGPD disclosure footer to masked outputs (default: true) */
  lgpdDisclosure?: boolean;
  /** Default confidence level for unattributed claims (default: 'medium') */
  defaultConfidence?: ConfidenceLevel;
  /**
   * Institution-specific custom PII patterns.
   * Guard Brasil is format-agnostic — each state, court, health system, or
   * police force defines their own identifier formats here without touching core.
   *
   * Example — PCMG profile:
   *   customPatterns: PCMG_PROFILE.patterns
   *
   * Example — inline:
   *   customPatterns: [{
   *     id: 'tjmg:numero_externo',
   *     label: 'Número Externo TJMG',
   *     regex: /\bEXT-\d{4}-\d{6}\b/g,
   *     maskFormat: '[NR EXTERNO REMOVIDO]',
   *     confidence: 'medium',
   *   }]
   *
   * HITL training: start with confidence 'low', validate via HITL UI,
   * auto-promote to 'high' after N confirmations.
   */
  customPatterns?: CustomPIIPattern[];
}

export interface InspectOptions {
  /** Optional session ID for evidence chain tracing */
  sessionId?: string;
  /** Claims to attach to the evidence chain (human-readable) */
  claims?: Array<{
    claim: string;
    source: string;
    excerpt?: string;
    confidence?: ConfidenceLevel;
  }>;
  provenance?: InspectProvenanceOptions;
  /** Masking mode: 'full' (default) fully redacts, 'partial' reveals enough for user confirmation */
  maskMode?: MaskMode;
}

export type ProvenanceLevel = 'inspection_only' | 'source_context' | 'source_row_bound';
export interface InspectProvenanceOptions {
  sourceUrl?: string;
  sourceMethod?: string;
  collectedAt?: string;
  rawRow?: Record<string, unknown>;
  query?: string;
  recordId?: string;
}
export type SourceReceipt = Partial<AuditFields> & {
  queryHash?: string;
  recordId?: string;
  provenanceLevel: Exclude<ProvenanceLevel, 'inspection_only'>;
};
export interface InspectionReceipt {
  inspectedAt: string;
  inputHash: string;
  outputHash: string;
  inspectionHash: string;
  guardVersion: string;
  evidenceHash?: string;
  provenanceLevel: ProvenanceLevel;
  source?: SourceReceipt;
}

export interface GuardBrasilResult {
  /** Original (untouched) text */
  original: string;
  /** Processed text — masked or blocked */
  output: string;
  /** Whether output is safe to publish as-is */
  safe: boolean;
  /** Whether output was blocked entirely (not just masked) */
  blocked: boolean;
  /** ATRiAN ethical validation result */
  atrian: AtrianResult;
  /** PII masking result */
  masking: MaskingResult;
  /** Evidence chain (if claims were provided) */
  evidenceChain?: EvidenceChain;
  /** Evidence block formatted for inclusion in response */
  evidenceBlock?: string;
  /** LGPD disclosure note (empty if no PII found) */
  lgpdDisclosure: string;
  /** Human-readable summary of all issues found */
  summary: string;
  /** Inspection receipt with hashes and optional source provenance */
  receipt: InspectionReceipt;
}

// Brazilian government acronyms that should never be flagged as invented
const BRAZILIAN_KNOWN_ACRONYMS = [
  // Identifiers
  'CPF', 'RG', 'MASP', 'REDS', 'BO', 'SINESP', 'LGPD', 'ANPD',
  'OAB', 'CNJ', 'CRM', 'PIX', 'INSS', 'SUS', 'STF', 'STJ',
  'PCMG', 'PMMG', 'TJMG', 'MPMG', 'CGU', 'TCU', 'AGU',
  // Brazilian states
  'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO',
  'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR',
  'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO',
  // Medical / health
  'HIV', 'AIDS', 'UTI', 'CTI', 'UPA', 'UBS', 'CID', 'SUS',
  'ANVISA', 'CFM', 'CFO', 'CFF', 'COREN',
  // Common BR abbreviations that are NOT invented
  'CEO', 'CTO', 'CFO', 'COO', 'API', 'URL', 'SQL', 'XML',
  'PDF', 'CPD', 'TI', 'RH', 'DP', 'PJ', 'PF', 'ME', 'MEI',
  'CNPJ', 'CEP', 'CNH', 'FGTS', 'CLT', 'PIS', 'NIS',
];
const GUARD_VERSION = '0.2.2';

function buildInspectionReceipt(
  text: string,
  output: string,
  evidenceChain: EvidenceChain | undefined,
  provenance: InspectProvenanceOptions | undefined,
): InspectionReceipt {
  const inspectedAt = new Date().toISOString();
  const inputHash = sha256Text(text);
  const outputHash = sha256Text(output);
  let provenanceLevel: ProvenanceLevel = 'inspection_only';
  let source: SourceReceipt | undefined;
  if (provenance?.sourceUrl && provenance?.sourceMethod) {
    const verifiedAt = provenance.collectedAt ?? inspectedAt;
    const audit = provenance.rawRow
      ? buildAuditFields({ rawRow: provenance.rawRow, sourceUrl: provenance.sourceUrl, method: provenance.sourceMethod, collectedAt: verifiedAt })
      : undefined;
    provenanceLevel = audit ? 'source_row_bound' : 'source_context';
    source = {
      ...audit,
      source_url: provenance.sourceUrl.trim(),
      source_method: provenance.sourceMethod.trim() || 'unknown',
      verified_at: audit?.verified_at ?? verifiedAt,
      source_fingerprint: audit?.source_fingerprint ?? sourceFingerprint(provenance.sourceUrl, provenance.sourceMethod, verifiedAt),
      ...(provenance.query ? { queryHash: sha256Text(provenance.query) } : {}),
      ...(provenance.recordId ? { recordId: provenance.recordId } : {}),
      provenanceLevel,
    };
  }
  const inspectionHash = sha256Text(JSON.stringify({ inputHash, outputHash, inspectedAt, evidenceHash: evidenceChain?.auditHash ?? null, sourceFingerprint: source?.source_fingerprint ?? null, guardVersion: GUARD_VERSION, provenanceLevel }));
  return { inspectedAt, inputHash, outputHash, inspectionHash, guardVersion: GUARD_VERSION, ...(evidenceChain ? { evidenceHash: evidenceChain.auditHash } : {}), ...(source ? { source } : {}), provenanceLevel };
}

// ─── GuardBrasil class ────────────────────────────────────────────────────────

export class GuardBrasil {
  private readonly atrian: ReturnType<typeof createAtrianValidator>;
  private readonly config: Required<GuardBrasilConfig>;

  private constructor(config: GuardBrasilConfig) {
    // Merge user-provided knownAcronyms with Brazilian defaults
    const mergedAcronyms = [
      ...BRAZILIAN_KNOWN_ACRONYMS,
      ...(config.atrian?.knownAcronyms ?? []),
    ];

    this.config = {
      atrian: { ...config.atrian, knownAcronyms: mergedAcronyms },
      blockOnCriticalPII: config.blockOnCriticalPII ?? false,
      lgpdDisclosure: config.lgpdDisclosure ?? true,
      defaultConfidence: config.defaultConfidence ?? 'medium',
      customPatterns: config.customPatterns ?? [],
    };
    this.atrian = createAtrianValidator(this.config.atrian);
  }

  /**
   * Creates a new GuardBrasil instance with the given configuration.
   */
  static create(config: GuardBrasilConfig = {}): GuardBrasil {
    return new GuardBrasil(config);
  }

  /**
   * Inspects a text through all guard layers.
   *
   * 1. ATRiAN — validates for absolute claims, false promises, fabricated data
   * 2. PII Scanner — detects Brazilian personal identifiers
   * 3. Public Guard — masks or blocks sensitive content
   * 4. Evidence Chain — builds audit trail for provided claims
   *
   * @param text — LLM output or any text to inspect
   * @param options — optional session ID and claims for evidence chain
   */
  inspect(text: string, options: InspectOptions = {}): GuardBrasilResult {
    // Step 1 — Ethical validation (ATRiAN)
    const atrianResult = this.atrian.validateAndReport(text);

    // Step 2 — PII masking (Public Guard)
    const maskingResult = maskPublicOutput(text, {
      criticalPiiAction: this.config.blockOnCriticalPII ? 'block' : 'redact',
      maskMode: options.maskMode,
      customPatterns: this.config.customPatterns,
    });

    const blocked = maskingResult.masked.startsWith('[CONTEÚDO BLOQUEADO');

    // Step 3 — Apply ATRiAN filter on top of masked output
    const filteredOutput = blocked
      ? maskingResult.masked
      : this.atrian.filterChunk(maskingResult.masked);

    // Step 4 — Evidence chain (optional)
    let evidenceChain: EvidenceChain | undefined;
    let evidenceBlock: string | undefined;

    if (options.claims && options.claims.length > 0) {
      const builder = createEvidenceChain({ sessionId: options.sessionId });
      for (const { claim, source, excerpt, confidence } of options.claims) {
        builder.addDocumentClaim(claim, source, excerpt ?? claim, confidence ?? this.config.defaultConfidence);
      }
      evidenceChain = builder.build();
      evidenceBlock = formatEvidenceBlock(evidenceChain);
    }

    // Step 5 — LGPD disclosure
    const lgpdDisclosure = this.config.lgpdDisclosure
      ? buildLGPDDisclosure(maskingResult)
      : '';

    // Step 6 — Summary
    const issues: string[] = [];
    if (!atrianResult.passed) {
      const errors = atrianResult.violations.filter(v => v.level === 'error' || v.level === 'critical');
      if (errors.length > 0) issues.push(`ATRiAN: ${errors.length} violation(s) (${errors.map(v => v.category).join(', ')})`);
    }
    if (!maskingResult.safe) {
      issues.push(`PII: ${maskingResult.findings.length} finding(s) (${maskingResult.sensitivityLevel})`);
    }

    const safe = maskingResult.safe && atrianResult.passed;
    const summary = issues.length === 0
      ? 'Output is clean — no violations found.'
      : `Issues found: ${issues.join(' | ')}`;
    const receipt = buildInspectionReceipt(text, filteredOutput, evidenceChain, options.provenance);

    return {
      original: text,
      output: filteredOutput,
      safe,
      blocked,
      atrian: atrianResult,
      masking: maskingResult,
      evidenceChain,
      evidenceBlock,
      lgpdDisclosure,
      summary,
      receipt,
    };
  }
}

/**
 * Convenience factory — same as `GuardBrasil.create(config)`.
 */
export function createGuardBrasil(config: GuardBrasilConfig = {}): GuardBrasil {
  return GuardBrasil.create(config);
}
/**
 * @egos/guard-brasil — Tests
 *
 * Tests the GuardBrasil facade end-to-end with realistic inputs.
 */

import { describe, expect, it } from 'bun:test';
import { GuardBrasil } from './guard.js';
import { detectPII, INFRASTRUCTURE_SECRET_PATTERNS } from './pii-patterns.js';

// ─── Helpers ──────────────────────────────────────────────────────────────────

function makeGuard(blockOnCriticalPII = false) {
  return GuardBrasil.create({ blockOnCriticalPII, lgpdDisclosure: true });
}

// ─── Clean output ─────────────────────────────────────────────────────────────

describe('GuardBrasil — clean output', () => {
  it('marks a clean response as safe', () => {
    const guard = makeGuard();
    const result = guard.inspect('O processo está em andamento. Aguarde contato.');
    expect(result.safe).toBe(true);
    expect(result.blocked).toBe(false);
    expect(result.masking.findings).toHaveLength(0);
    expect(result.atrian.passed).toBe(true);
    expect(result.lgpdDisclosure).toBe('');
  });
});

// ─── PII detection ────────────────────────────────────────────────────────────

describe('GuardBrasil — PII detection', () => {
  it('detects and masks CPF', () => {
    const guard = makeGuard();
    const result = guard.inspect('O CPF do solicitante é 123.456.789-09.');
    expect(result.masking.findings.some(f => f.category === 'cpf')).toBe(true);
    expect(result.output).not.toContain('123.456.789-09');
    expect(result.output).toContain('[CPF REMOVIDO]');
    expect(result.safe).toBe(false);
  });

  it('detects Registro Geral wording as RG', () => {
    const guard = makeGuard();
    const result = guard.inspect('Registro Geral 123456789 do paciente foi apresentado.');
    expect(result.masking.findings.some(f => f.category === 'rg')).toBe(true);
  });

  it('detects MASP', () => {
    const guard = makeGuard();
    const result = guard.inspect('Delegado MASP: 1234567 presente.');
    expect(result.masking.findings.some(f => f.category === 'masp')).toBe(true);
    expect(result.output).not.toContain('1234567');
  });

  it('detects REDS', () => {
    const guard = makeGuard();
    const result = guard.inspect('REDS 2024/0098765 foi registrado.');
    expect(result.masking.findings.some(f => f.category === 'reds')).toBe(true);
  });

  it('adds LGPD disclosure when PII found', () => {
    const guard = makeGuard();
    const result = guard.inspect('CPF: 111.222.333-44');
    expect(result.lgpdDisclosure).toContain('LGPD');
    expect(result.lgpdDisclosure).toContain('13.709/2018');
  });

  it('does NOT add LGPD disclosure for clean output', () => {
    const guard = makeGuard();
    const result = guard.inspect('Sem dados pessoais aqui.');
    expect(result.lgpdDisclosure).toBe('');
  });

  it('detects CEP without misclassifying it as phone', () => {
    const guard = makeGuard();
    const result = guard.inspect('CEP 01310100 informado para entrega.');
    expect(result.masking.findings.some(f => f.category === 'cep')).toBe(true);
    expect(result.masking.findings.some(f => f.category === 'phone')).toBe(false);
  });

  it('does not classify bare numeric codes as phone', () => {
    const guard = makeGuard();
    const result = guard.inspect('O código de barras é 789456123.');
    expect(result.masking.findings.some(f => f.category === 'phone')).toBe(false);
  });
});

// ─── ATRiAN validation ────────────────────────────────────────────────────────

describe('GuardBrasil — ATRiAN ethical validation', () => {
  it('flags absolute claim "com certeza"', () => {
    const guard = makeGuard();
    const result = guard.inspect('Com certeza o problema será resolvido.');
    expect(result.atrian.violations.some(v => v.category === 'absolute_claim')).toBe(true);
    // absolute claims are warnings, not errors — passes validation
    expect(result.atrian.score).toBeLessThan(100);
  });

  it('flags false promise', () => {
    const guard = makeGuard();
    const result = guard.inspect('Vamos resolver o caso imediatamente.');
    const hasFalsePromise = result.atrian.violations.some(v => v.category === 'false_promise');
    expect(hasFalsePromise).toBe(true);
    expect(result.atrian.passed).toBe(false);
  });

  it('flags fabricated data reference', () => {
    const guard = makeGuard();
    const result = guard.inspect('Segundo dados do Ministério da Justiça, 98% dos casos são resolvidos.');
    expect(result.atrian.violations.some(v => v.category === 'fabricated_data')).toBe(true);
    expect(result.atrian.passed).toBe(false);
  });

  it('blocks entity in blocklist', () => {
    const guard = GuardBrasil.create({ atrian: { blockedEntities: ['PROIBIDO'] } });
    const result = guard.inspect('Este sistema usa o módulo PROIBIDO para isso.');
    expect(result.atrian.violations.some(v => v.category === 'blocked_entity')).toBe(true);
    expect(result.atrian.passed).toBe(false);
    expect(result.output).toContain('***');
  });
});

// ─── blockOnCriticalPII ───────────────────────────────────────────────────────

describe('GuardBrasil — blockOnCriticalPII', () => {
  it('blocks output entirely when critical PII found and blockOnCriticalPII=true', () => {
    const guard = makeGuard(true);
    const result = guard.inspect('O CPF do agente é 999.888.777-66.');
    expect(result.blocked).toBe(true);
    expect(result.output).toContain('[CONTEÚDO BLOQUEADO');
  });

  it('masks (not blocks) critical PII by default', () => {
    const guard = makeGuard(false);
    const result = guard.inspect('CPF: 999.888.777-66');
    expect(result.blocked).toBe(false);
    expect(result.output).toContain('[CPF REMOVIDO]');
  });
});

// ─── Evidence chain ───────────────────────────────────────────────────────────

describe('GuardBrasil — evidence chain', () => {
  it('builds evidence chain when claims provided', () => {
    const guard = makeGuard();
    const result = guard.inspect('O suspeito foi identificado.', {
      sessionId: 'test-session',
      claims: [
        {
          claim: 'Suspeito identificado via sistema',
          source: 'boletim-interno',
          excerpt: 'registro #42',
          confidence: 'high',
        },
      ],
    });
    expect(result.evidenceChain).toBeDefined();
    expect(result.evidenceChain?.claims).toHaveLength(1);
    expect(result.evidenceChain?.auditHash).toMatch(/^ev-[0-9a-f]{64}$/);
    expect(result.evidenceBlock).toContain('[Evidências');
  });

  it('does not build evidence chain without claims', () => {
    const guard = makeGuard();
    const result = guard.inspect('Texto simples.');
    expect(result.evidenceChain).toBeUndefined();
    expect(result.evidenceBlock).toBeUndefined();
  });
});

describe('GuardBrasil — inspection receipt', () => {
  it('builds inspection hashes even without source provenance', () => {
    const guard = makeGuard();
    const result = guard.inspect('Texto simples.');
    expect(result.receipt.inputHash).toHaveLength(64);
    expect(result.receipt.outputHash).toHaveLength(64);
    expect(result.receipt.inspectionHash).toHaveLength(64);
    expect(result.receipt.provenanceLevel).toBe('inspection_only');
  });

  it('binds source provenance when source metadata is provided', () => {
    const guard = makeGuard();
    const result = guard.inspect('CPF 123.456.789-09', {
      provenance: {
        sourceUrl: 'https://dados.exemplo.gov.br/arquivo.csv',
        sourceMethod: 'api',
        rawRow: { id: 7, cpf: '123.456.789-09' },
        query: 'cpf=12345678909',
        recordId: 'row-7',
      },
    });
    expect(result.receipt.provenanceLevel).toBe('source_row_bound');
    expect(result.receipt.source?.source_fingerprint).toHaveLength(64);
    expect(result.receipt.source?.raw_line_hash).toHaveLength(64);
    expect(result.receipt.source?.queryHash).toHaveLength(64);
  });
});

// ─── Combined scenario ────────────────────────────────────────────────────────

describe('GuardBrasil — combined scenario', () => {
  it('handles text with PII + ATRiAN violations simultaneously', () => {
    const guard = makeGuard();
    const text = 'Com certeza o investigador de CPF 123.456.789-09 resolverá o caso. Vamos encaminhar isso agora.';
    const result = guard.inspect(text);

    expect(result.safe).toBe(false);
    expect(result.output).not.toContain('123.456.789-09');
    expect(result.atrian.violations.length).toBeGreaterThan(0);
    expect(result.summary).toContain('ATRiAN');
    expect(result.summary).toContain('PII');
    expect(result.lgpdDisclosure).toContain('LGPD');
  });
});

// ─── Missing PII patterns — full coverage ─────────────────────────────────────

describe('GuardBrasil — CNPJ detection', () => {
  it('detects and masks CNPJ formatted with dots and slash', () => {
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022"],
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "verbatimModuleSyntax": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["src/**/*.test.ts", "src/demo.ts", "node_modules", "dist"]
}

exec
/bin/bash -lc "grep -n \"function maskPII\\|export function maskPII\" -n packages/guard-brasil/src/pii-patterns.ts && sed -n '250,390p' packages/guard-brasil/src/pii-patterns.ts && bun test packages/guard-brasil/src/guard.test.ts" in /home/enio/egos
 succeeded in 0ms:
529:export function maskPII(text: string, patternIds?: PIIPatternId[], mode: MaskMode = 'full'): string {
    const ddd = d.slice(0, 2);
    const last4 = d.slice(-4);
    return `(${ddd}) ****-${last4}`;
  },
};

/** Email */
export const EMAIL_PATTERN: PIIPatternConfig = {
  id: 'email',
  label: 'Email',
  regex: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g,
  maskFormat: '[EMAIL REMOVIDO]',
  confidence: 'high',
  description: 'Endereço de email',
  // j***@e*****.com.br — first char of local + first char of domain + extension
  partialMaskFn: (matched) => {
    const [local, domain] = matched.split('@');
    if (!local || !domain) return '[EMAIL REMOVIDO]';
    const dotIdx = domain.lastIndexOf('.');
    const domainName = dotIdx > 0 ? domain.slice(0, dotIdx) : domain;
    const tld = dotIdx > 0 ? domain.slice(dotIdx) : '';
    const maskedLocal = local[0] + '***';
    const maskedDomain = domainName[0] + '*'.repeat(Math.max(1, domainName.length - 1));
    return `${maskedLocal}@${maskedDomain}${tld}`;
  },
};

/** Cartão SUS — Cartão Nacional de Saúde (15 digits) */
export const SUS_PATTERN: PIIPatternConfig = {
  id: 'sus',
  label: 'Cartão SUS',
  regex: /\b[1-9]\d{2}\s?\d{4}\s?\d{4}\s?\d{4}\b/g,
  maskFormat: '[SUS REMOVIDO]',
  confidence: 'medium',
  description: 'Cartão Nacional de Saúde — 15 dígitos (xxx xxxx xxxx xxxx)',
};

/** Título de Eleitor — 12 digits with state/sequence check */
export const TITULO_ELEITOR_PATTERN: PIIPatternConfig = {
  id: 'titulo_eleitor',
  label: 'Título de Eleitor',
  regex: /\b\d{4}\s?\d{4}\s?\d{4}\b/g,
  maskFormat: '[TÍTULO REMOVIDO]',
  confidence: 'low',
  description: 'Título de Eleitor — 12 dígitos (xxxx xxxx xxxx)',
};

/** NIS/PIS — Número de Identificação Social (11 digits, starts with specific ranges) */
export const NIS_PIS_PATTERN: PIIPatternConfig = {
  id: 'nis_pis',
  label: 'NIS/PIS',
  regex: /\b[12]\d{2}\.?\d{5}\.?\d{2}-?\d\b/g,
  maskFormat: '[NIS REMOVIDO]',
  confidence: 'medium',
  description: 'NIS/PIS/PASEP — 11 dígitos (xxx.xxxxx.xx-x)',
};

/** CEP — Código de Endereçamento Postal (8 digits) */
export const CEP_PATTERN: PIIPatternConfig = {
  id: 'cep',
  label: 'CEP',
  regex: /\b\d{5}[-.\s]?\d{3}\b/g,
  maskFormat: '[CEP REMOVIDO]',
  confidence: 'low',
  description: 'Código de Endereçamento Postal — 00000-000',
};

/** HEALTH_CONDITION — Condição médica / dado de saúde sensível (LGPD art.11)
 * Matches: "HIV positivo", "portador de diabetes", "diagnóstico de câncer", "soropositivo"
 * Context-required to avoid false positives in clinical docs discussing conditions generally.
 */
export const HEALTH_CONDITION_PATTERN: PIIPatternConfig = {
  id: 'health_condition',
  label: 'Dado de Saúde',
  regex: /\b(?:portador[ae]?\s+de|diagnos(?:tic|e)ado[ae]?\s+(?:com|de)|soropositivo|HIV\s*\+|HIV\s+positivo|resultado\s+positivo\s+para|condição\s+médica[:\s]+|doença\s+(?:crônica|grave)[:\s]+)\s*([A-Za-záéíóúãõâêîôûàèìòùüçñ][A-Za-záéíóúãõâêîôûàèìòùüçñ\s]{2,40})/gi,
  maskFormat: '[DADO DE SAÚDE REMOVIDO]',
  confidence: 'medium',
  description: 'Condição médica ou dado de saúde sensível (LGPD art.11 §1º I)',
};

// ─── Registry ─────────────────────────────────────────────────────────────────

/**
 * All registered PII patterns, ordered by specificity (most specific first).
 * Order matters: more specific patterns (processo, CNPJ) should match
 * before less specific ones (CPF, CEP, telefone) to avoid partial overlaps.
 */
export const ALL_PII_PATTERNS: readonly PIIPatternConfig[] = [
  PROCESSO_PATTERN,
  CNPJ_PATTERN,
  CPF_PATTERN,
  RG_PATTERN,
  CNH_PATTERN,
  SUS_PATTERN,
  NIS_PIS_PATTERN,
  MASP_PATTERN,
  REDS_PATTERN,
  PLACA_MERCOSUL_PATTERN,
  PLACA_ANTIGA_PATTERN,
  EMAIL_PATTERN,
  TELEFONE_PATTERN,
  TITULO_ELEITOR_PATTERN,
  CEP_PATTERN,
  HEALTH_CONDITION_PATTERN,
] as const;

// ─── Infrastructure Secret Patterns ──────────────────────────────────────────
// Ported from egos-cortex/src/privacy.ts — complement Brazilian PII with
// infrastructure credential detection. NOT included in ALL_PII_PATTERNS to
// avoid false positives in general text. Use INFRASTRUCTURE_SECRET_PATTERNS
// explicitly when scanning source code or config files.

/** AWS Access Key ID — AKIA + 16 uppercase alphanumeric chars */
export const AWS_KEY_PATTERN: PIIPatternConfig = {
  id: 'aws_key',
  label: 'AWS Access Key',
  regex: /\bAKIA[0-9A-Z]{16}\b/g,
  maskFormat: '[AWS_KEY REMOVIDO]',
  confidence: 'high',
  description: 'AWS Access Key ID — AKIA****************',
};

/** GitHub Token — gh[pousr]_ prefix patterns */
export const GITHUB_TOKEN_PATTERN: PIIPatternConfig = {
  id: 'github_token',
  label: 'GitHub Token',
  regex: /\bgh[pousr]_[A-Za-z0-9_]{36,}\b/g,
  maskFormat: '[GITHUB_TOKEN REMOVIDO]',
  confidence: 'high',
  description: 'GitHub personal/oauth/app token — ghp_*, gho_*, ghu_*, ghs_*, ghr_*',
};

/** Stripe API Key — live or test sk_ keys */
export const STRIPE_KEY_PATTERN: PIIPatternConfig = {
  id: 'stripe_key',
  label: 'Stripe API Key',
  regex: /\bsk_(?:live|test)_[A-Za-z0-9]{16,}\b/g,
  maskFormat: '[STRIPE_KEY REMOVIDO]',
  confidence: 'high',
  description: 'Stripe secret key — sk_live_* or sk_test_*',
};
bun test v1.3.9 (cf6cdbbb)

 46 pass
 0 fail
 106 expect() calls
Ran 46 tests across 1 file. [61.00ms]

exec
/bin/bash -lc "sed -n '500,570p' packages/guard-brasil/src/pii-patterns.ts" in /home/enio/egos
 succeeded in 0ms:
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
/bin/bash -lc "bun run --cwd packages/guard-brasil build && ls packages/guard-brasil/dist/registry && node -e \"import('@egosbr/guard-brasil/registry').then(console.log).catch(e=>{console.error(e.code,e.message); process.exit(1)})\"" in /home/enio/egos
 exited 2 in 733ms:
src/benchmark.ts(165,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(166,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(167,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(168,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(180,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(189,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(190,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(191,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(192,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(194,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(195,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(196,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(197,3): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(200,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(202,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/benchmark.ts(204,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/keys.ts(8,41): error TS2591: Cannot find name 'crypto'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(30,30): error TS2591: Cannot find name 'require'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(31,17): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(31,45): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(32,17): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(102,19): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(102,53): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(103,18): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(103,56): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/keys.ts(109,9): error TS2304: Cannot find name 'fetch'.
src/lib/provenance.ts(1,28): error TS2591: Cannot find name 'node:crypto'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/lib/tokenizer.ts(19,41): error TS2591: Cannot find name 'crypto'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/telemetry.ts(13,17): error TS2591: Cannot find name 'require'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/telemetry.ts(14,17): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/telemetry.ts(14,45): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/telemetry.ts(15,17): error TS2591: Cannot find name 'process'. Do you need to install type definitions for node? Try `npm i --save-dev @types/node` and then add 'node' to the types field in your tsconfig.
src/telemetry.ts(18,7): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/telemetry.ts(27,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/telemetry.ts(84,9): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/telemetry.ts(88,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/telemetry.ts(145,7): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.
src/telemetry.ts(151,5): error TS2584: Cannot find name 'console'. Do you need to change your target library? Try changing the 'lib' compiler option to include 'dom'.

mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (failed)
mcp: codebase-memory-mcp/search_graph started
mcp: codebase-memory-mcp/search_graph (completed)
exec
/bin/bash -lc "bun -e \"import { maskPublicOutput } from './packages/guard-brasil/src/lib/public-guard.ts'; const r=maskPublicOutput('BO nº 2024/098765 registrado',{maskMode:'partial',customPatterns:[{id:'pcmg:bo_numero',label:'BO',regex:/\\\\bBO\\\\s*n[ºo°.]?\\\\s*\\\\d{4}\\\\/\\\\d{6,8}\\\\b/gi,maskFormat:'[BO REMOVIDO]',confidence:'low'}]}); console.log(r.findings.length, r.masked)\"" in /home/enio/egos
 succeeded in 0ms:
1 BO nº 2024/098765 registrado

exec
/bin/bash -lc "bun -e \"import { scanForPII } from './packages/guard-brasil/src/lib/pii-scanner.ts'; import { PCMG_PROFILE } from './packages/guard-brasil/src/registry/pcmg.ts'; const extra=PCMG_PROFILE.patterns.map(p=>({category:p.id,label:p.label,pattern:p.regex,suggestion:p.maskFormat})); console.log(scanForPII('IPL-1234/2024 registrado',{extraPatterns:extra}))\"" in /home/enio/egos
 succeeded in 0ms:
[
  {
    category: "plate",
    label: "Placa Veicular",
    matched: "IPL-1234",
    start: 0,
    end: 8,
    suggestion: "[PLACA REMOVIDA]",
  }
]

exec
/bin/bash -lc "cat package.json | sed -n '1,160p'; bun -e \"import('@egosbr/guard-brasil/registry').then(m=>console.log('ok')).catch(e=>{console.error(e.name, e.code, e.message); process.exit(0)})\"" in /home/enio/egos
 succeeded in 0ms:
{
  "name": "egos",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "EGOS — Orchestration kernel for governed AI agents",
  "license": "MIT",
  "author": "Enio Rocha <enio@egos.ia.br>",
  "bin": {
    "egos": "./bin/egos.ts"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/enioxt/egos.git"
  },
  "workspaces": [
    "packages/*",
    "apps/*",
    "central-egos/*"
  ],
  "scripts": {
    "setup": "sh setup.sh",
    "egos:init": "sh scripts/egos-init.sh",
    "agent:list": "bun agents/cli.ts list",
    "agent:run": "bun agents/cli.ts run",
    "agent:lint": "bun agents/cli.ts lint-registry",
    "coordination:watch": "bun run scripts/coordination-watcher.ts",
    "typecheck": "/usr/bin/node --max-old-space-size=6144 node_modules/typescript/bin/tsc --noEmit",
    "lint": "eslint .",
    "prepare": "husky",
    "precommit": "bash .husky/pre-commit",
    "governance:sync": "sh scripts/governance-sync.sh --dry",
    "governance:sync:exec": "sh scripts/governance-sync.sh --exec --propagate",
    "governance:sync:local": "sh scripts/governance-sync.sh --exec --no-propagate",
    "governance:check": "sh scripts/governance-sync.sh --check",
    "template:check": "bun scripts/validate-inherits.ts && bun scripts/lint-domain-template.ts",
    "template:check:strict": "bun scripts/validate-inherits.ts --strict && bun scripts/lint-domain-template.ts --strict",
    "governance:runtime:smoke": "bun scripts/runtime-smoke.ts",
    "governance:runtime:smoke:json": "bun scripts/runtime-smoke.ts --json",
    "governance:runtime:report": "bun scripts/runtime-operator-report.ts",
    "governance:runtime:report:json": "bun scripts/runtime-operator-report.ts --json",
    "gov:check": "bun run scripts/runtime-smoke-validator.ts",
    "gov:telemetry": "bun run scripts/hook-telemetry-report.ts --week",
    "gov:telemetry:daily": "bun run scripts/hook-telemetry-report.ts --day",
    "gov:evidence-gate:dry": "bun run scripts/evidence-gate-disseminate.ts --dry-run",
    "gov:sync:dry": "bun run ~/.eos/scripts/core/governance-sync.sh --dry-run",
    "gov:sync": "bun run ~/.eos/scripts/core/governance-sync.sh --exec",
    "tasks:archive": "bun scripts/tasks-archive.ts --dry",
    "tasks:archive:exec": "bun scripts/tasks-archive.ts --exec",
    "tasks:reconcile": "bun scripts/task-reconciliation.ts --summary",
    "tasks:calibrate": "bun scripts/calibrate-tasks.ts",
    "tasks:audit": "bun scripts/hermes-task-audit.ts --dry",
    "tasks:audit:write": "bun scripts/hermes-task-audit.ts",
    "claude:telemetry": "bun scripts/claude-hook-telemetry.ts",
    "claude:telemetry:json": "bun scripts/claude-hook-telemetry.ts --json",
    "claude:telemetry:otel": "bun scripts/claude-hook-telemetry.ts --otel",
    "claude:telemetry:otel:json": "bun scripts/claude-hook-telemetry.ts --otel --json",
    "egos:boot": "bash scripts/egos-boot.sh",
    "ssot:check": "bun scripts/validate-ssot.ts",
    "ssot:claim-check": "bun scripts/ssot-claim-check.ts",
    "ssot:diagnostic": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --output /tmp/qa-ssot-check.md",
    "ssot:diagnostic:json": "python scripts/qa/ssot_check_diagnostic.py --command 'sh scripts/governance-sync.sh --check' --format json --output /tmp/qa-ssot-check.json",
    "smoke:api": "bun scripts/smoke-test-api.ts",
    "version:lock": "bun scripts/check-version-lock.ts",
    "integration:check": "bun scripts/integration-release-check.ts",
    "pr:pack": "bun scripts/pr-pack.ts",
    "pr:gate": "bun scripts/pr-gate.ts",
    "pr:audit": "bun scripts/pr-ecosystem-audit.ts",
    "ssot:link": "sh scripts/link-ssot-files.sh --dry",
    "ssot:link:exec": "sh scripts/link-ssot-files.sh --exec",
    "qa:observability": "bash scripts/qa/run_observability_suite.sh",
    "qa:pending": "python scripts/qa/list_pending_tasks.py --input TASKS.md",
    "qa:pending:json": "python scripts/qa/list_pending_tasks.py --input TASKS.md --format json",
    "qa:stalled": "python scripts/qa/stalled_tasks_report.py --input TASKS.md",
    "qa:evidence": "python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt",
    "qa:evidence:gate": "python scripts/qa/telemetry_guardrail.py --input tests/qa/fixtures/sample_telemetry.txt --output /tmp/qa-guardrail.txt && python scripts/qa/observability_evidence.py --telemetry-input tests/qa/fixtures/sample_telemetry.txt --guardrail-input /tmp/qa-guardrail.txt --enforce",
    "qa:compose": "python scripts/qa/compose_qa_envelope.py --guardrail /tmp/qa-guardrail.txt --ssot /tmp/qa-ssot-check.md --evidence /tmp/qa-evidence.md --output /tmp/qa-envelope.json",
    "security:audit": "bun scripts/security-audit.ts",
    "security:audit:json": "bun scripts/security-audit.ts --json",
    "security:audit:fix": "bun scripts/security-audit.ts --fix",
    "test": "bun test packages/shared/src/__tests__/",
    "test:hooks": "bun test tests/hooks/",
    "test:watch": "bun test --watch",
    "test:governance": "bun scripts/test-governance.ts",
    "capability:scan": "bun scripts/update-capability-registry.ts",
    "capability:scan:repo": "bun scripts/update-capability-registry.ts --repo",
    "duplication:scan": "bun scripts/governance/duplication-scanner.ts",
    "duplication:scan:json": "bun scripts/governance/duplication-scanner.ts --json",
    "ssot:crosslink": "bun scripts/governance/ssot-crosslink-validator.ts",
    "ssot:crosslink:staged": "bun scripts/governance/ssot-crosslink-validator.ts --staged",
    "activation:check": "bun scripts/activation-check.ts",
    "start": "bun scripts/start-v6.ts",
    "start:full": "bun scripts/start-v6.ts --full",
    "start:json": "bun scripts/start-v6.ts --json",
    "doctor": "bun scripts/doctor.ts",
    "doctor:codex": "sh scripts/codex-doctor.sh",
    "doctor:fix": "bun scripts/doctor.ts --fix",
    "personal:sync:status": "bun scripts/personal-sync-status.ts",
    "personal:sync:status:json": "bun scripts/personal-sync-status.ts --json",
    "phantom:tables:audit": "bun scripts/phantom-table-audit.ts",
    "phantom:tables:audit:json": "bun scripts/phantom-table-audit.ts --json",
    "chatgpt:ingest": "bun scripts/chatgpt-export-sync.ts --dry",
    "chatgpt:ingest:exec": "bun scripts/chatgpt-export-sync.ts --exec",
    "chatgpt:watch": "bun scripts/chatgpt-export-watch.ts --dry",
    "chatgpt:watch:exec": "bun scripts/chatgpt-export-watch.ts --exec",
    "wiki:repos-sync": "bun scripts/wiki-repos-sync.ts",
    "wiki:repos-sync:check": "bun scripts/wiki-repos-sync.ts --check",
    "wiki:compile": "bun agents/agents/wiki-compiler.ts --compile",
    "wiki:compile:dry": "bun agents/agents/wiki-compiler.ts --compile --dry",
    "wiki:heal": "bun agents/agents/wiki-compiler.ts --heal",
    "wiki:heal:dry": "bun agents/agents/wiki-compiler.ts --heal --dry",
    "wiki:lint": "bun agents/agents/wiki-compiler.ts --lint",
    "wiki:index": "bun agents/agents/wiki-compiler.ts --index",
    "wiki:dedup": "bun agents/agents/wiki-compiler.ts --dedup",
    "wiki:dedup:dry": "bun agents/agents/wiki-compiler.ts --dedup --dry",
    "wiki:enrich": "bun agents/agents/wiki-compiler.ts --enrich",
    "wiki:enrich:dry": "bun agents/agents/wiki-compiler.ts --enrich --dry",
    "deadcode": "knip",
    "deadcode:fix": "knip --fix",
    "skill:usage": "bun scripts/skill-usage-tracker.ts",
    "skill:usage:log": "bun scripts/skill-usage-tracker.ts --log",
    "skill:usage:30d": "bun scripts/skill-usage-tracker.ts --days=30",
    "gemhunter:dry": "bun agents/cli.ts run gem-hunter --dry",
    "gemhunter:exec": "bun agents/cli.ts run gem-hunter --exec",
    "gemhunter:quick": "bun agents/cli.ts run gem-hunter --exec --quick",
    "gemhunter:api": "bun agents/api/gem-hunter-server.ts"
  },
  "devDependencies": {
    "@anthropic-ai/sdk": "^0.100.0",
    "@types/bun": "^1.3.13",
    "@types/node": "^25.6.0",
    "eslint": "^10.2.1",
    "husky": "^9.1.7",
    "knip": "^6.9.0",
    "typescript": "^6.0.3"
  },
  "dependencies": {
    "@google/generative-ai": "^0.24.1",
    "@supabase/supabase-js": "^2.105.1",
    "ajv": "8.20.0",
    "axios": "^1.15.2",
    "cross-spawn": "7.0.6",
    "dotenv": "^17.4.2",
    "hono": "^4.12.16",
    "mammoth": "^1.12.0",
    "semver": "~7.7.4",
    "substack-api": "^4.0.0",
    "twitter-api-v2": "^1.29.0",
    "unpdf": "^1.6.2",
    "ws": "^8.20.0",
    "yaml": "^2.8.3",
    "zod": "^4.4.1"
  },
  "overrides": {
    "@xmldom/xmldom": "^0.8.13",
    "flatted": "^3.4.2",
    "uuid": ">=14.0.0",
    "fast-uri": "^3.1.2",
    "axios": "^1.16.0"
  }
ResolveMessage ERR_MODULE_NOT_FOUND Cannot find module '@egosbr/guard-brasil/registry' from '/home/enio/egos/[eval]'

exec
/bin/bash -lc "nl -ba packages/guard-brasil/src/lib/public-guard.ts | sed -n '68,92p'; nl -ba packages/guard-brasil/src/lib/pii-scanner.ts | sed -n '55,72p'; nl -ba packages/guard-brasil/src/registry/index.ts | sed -n '1,21p'" in /home/enio/egos
 succeeded in 0ms:
    68	 * Masks PII from a text according to Guard Brasil policy.
    69	 * Returns the masked text plus a full audit of all actions taken.
    70	 */
    71	export function maskPublicOutput(text: string, config: PublicGuardConfig = {}): MaskingResult {
    72	  const piiAction = config.piiAction ?? 'mask';
    73	  const criticalPiiAction = config.criticalPiiAction ?? 'redact';
    74	
    75	  const extraPatterns: PIIPatternDefinition[] = (config.customPatterns ?? []).map(p => ({
    76	    category: p.id as never,
    77	    label: p.label,
    78	    pattern: p.regex,
    79	    suggestion: p.maskFormat,
    80	  }));
    81	  const findings = scanForPII(text, extraPatterns.length > 0 ? { extraPatterns } : undefined);
    82	  const sensitivityLevel = computeSensitivity(findings);
    83	
    84	  const actionsMap = new Map<string, MaskingAction>();
    85	
    86	  for (const finding of findings) {
    87	    const isCritical = CRITICAL_CATEGORIES.has(finding.category);
    88	    const action = isCritical ? criticalPiiAction : piiAction;
    89	
    90	    if (!actionsMap.has(finding.category)) {
    91	      actionsMap.set(finding.category, {
    92	        category: finding.category,
    55	const DEFAULT_NAME_PATTERN = /\b(?:delegad[oa]|chefe|colega|servidor|investigador|escriv[aã]o?|comissário|perito|agente|[Nn]ome(?:\s+completo)?|[Pp]aciente|[Cc]liente|[Rr]esponsável|[Rr]equerente|[Rr]equerido|[Aa]utor|[Rr]éu|[Rr]é|[Dd]etentor|[Pp]ortador|[Tt]itular|[Ii]nteressado)\s*:?\s+([A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+(?:\s+(?:d[aeo]\s+)?[A-ZÁÉÍÓÚÃÕÂÊÎÔÛ][a-záéíóúãõâêîôû]+){1,4})\b/g;
    56	const clonePattern = (pattern: RegExp) => new RegExp(pattern.source, pattern.flags.includes('g') ? pattern.flags : `${pattern.flags}g`);
    57	
    58	export function scanForPII(text: string, options?: { patterns?: PIIPatternDefinition[]; extraPatterns?: PIIPatternDefinition[]; namePattern?: RegExp }): PIIFinding[] {
    59	  const findings: PIIFinding[] = [];
    60	  const base = options?.patterns ?? DEFAULT_PII_PATTERNS;
    61	  const patterns = options?.extraPatterns ? [...base, ...options.extraPatterns] : base;
    62	  for (const { category, label, suggestion, pattern } of patterns) {
    63	    const activePattern = clonePattern(pattern);
    64	    let match: RegExpExecArray | null;
    65	    while ((match = activePattern.exec(text)) !== null) findings.push({ category, label, matched: match[0], start: match.index, end: match.index + match[0].length, suggestion });
    66	  }
    67	  const namePattern = clonePattern(options?.namePattern ?? DEFAULT_NAME_PATTERN);
    68	  let nameMatch: RegExpExecArray | null;
    69	  while ((nameMatch = namePattern.exec(text)) !== null) {
    70	    const name = nameMatch[1];
    71	    if (name && name.length > 3) findings.push({ category: 'name', label: 'Possível nome', matched: name, start: nameMatch.index + nameMatch[0].indexOf(name), end: nameMatch.index + nameMatch[0].indexOf(name) + name.length, suggestion: '[NOME REMOVIDO]' });
    72	  }
     1	/**
     2	 * Institution Profile Registry — index
     3	 *
     4	 * Available profiles:
     5	 *   - PCMG: Polícia Civil de Minas Gerais (v0.1.0 — HITL pending)
     6	 *
     7	 * Usage:
     8	 *   import { PCMG_PROFILE } from '@egos/guard-brasil/registry';
     9	 *   const guard = GuardBrasil.create({ customPatterns: PCMG_PROFILE.patterns });
    10	 *
    11	 * Contributing a new profile:
    12	 *   1. Create `<institution>.ts` in this directory
    13	 *   2. Export an `InstitutionProfile` following the type contract
    14	 *   3. Add patterns with `confidence: 'low'`
    15	 *   4. Run HITL validation: `bun packages/guard-brasil/src/registry/hitl-runner.ts --profile <id>`
    16	 *   5. Export as JSON for sharing: profiles are self-contained and require no code change to use
    17	 */
    18	
    19	export { PCMG_PROFILE } from './pcmg.js';
    20	export { computeConfidenceFromHITL, HITL_CONFIDENCE_THRESHOLDS } from './types.js';
    21	export type { InstitutionProfile, HITLReviewResult } from './types.js';

exec
/bin/bash -lc "nl -ba packages/guard-brasil/src/lib/public-guard.ts | sed -n '98,120p'" in /home/enio/egos
 succeeded in 0ms:
    98	    const entry = actionsMap.get(finding.category)!;
    99	    entry.count++;
   100	    entry.positions.push({ start: finding.start, end: finding.end });
   101	  }
   102	
   103	  const blocked = sensitivityLevel === 'critical' && criticalPiiAction === 'block';
   104	  let masked: string;
   105	  if (blocked) {
   106	    masked = '[CONTEÚDO BLOQUEADO — DADOS SENSÍVEIS DETECTADOS]';
   107	  } else if (config.maskMode === 'partial') {
   108	    masked = maskPII(text, undefined, 'partial');
   109	  } else {
   110	    masked = sanitizeText(text, findings);
   111	  }
   112	
   113	  return {
   114	    original: text,
   115	    masked,
   116	    findings,
   117	    actionsApplied: [...actionsMap.values()],
   118	    safe: findings.length === 0,
   119	    sensitivityLevel,
   120	  };

codex
The custom-pattern feature can leak detected custom identifiers in partial masking mode, and overlapping custom patterns can be discarded behind generic built-ins. The new registry is also not reachable through the package API as documented.

Full review comments:

- [P1] Preserve custom masks in partial mode — /home/enio/egos/packages/guard-brasil/src/lib/public-guard.ts:107-108
  When callers use `maskMode: 'partial'` together with `customPatterns`, the scanner records the custom finding but this branch remasks the original text with `maskPII`, which only knows built-in patterns. For example, a configured PCMG BO pattern is reported in `findings` while the returned `masked` output still contains `BO nº 2024/098765`, leaking the custom identifier in the exact mode intended for safe disclosure.

- [P2] Prefer custom patterns over generic overlaps — /home/enio/egos/packages/guard-brasil/src/lib/pii-scanner.ts:60-61
  Appending `extraPatterns` after the built-ins means `deduplicateFindings` keeps the earlier generic match when ranges overlap, so institution-specific patterns can be dropped. With the new PCMG profile, `IPL-1234/2024` is matched first as the built-in plate `IPL-1234`, the custom `pcmg:inquerito` match is discarded, and full masking leaves `/2024` behind instead of replacing the whole inquiry number.

- [P2] Expose the registry through the package API — /home/enio/egos/packages/guard-brasil/src/registry/index.ts:19-21
  This new registry is documented for package consumers via a `@egos/guard-brasil/registry`-style import, but the package `exports` map still only exposes `.` and `src/index.ts` does not re-export these symbols. In any workspace/package setup that honors `exports`, consumers cannot import `PCMG_PROFILE` from the published package even though the registry module exists.
The custom-pattern feature can leak detected custom identifiers in partial masking mode, and overlapping custom patterns can be discarded behind generic built-ins. The new registry is also not reachable through the package API as documented.

Full review comments:

- [P1] Preserve custom masks in partial mode — /home/enio/egos/packages/guard-brasil/src/lib/public-guard.ts:107-108
  When callers use `maskMode: 'partial'` together with `customPatterns`, the scanner records the custom finding but this branch remasks the original text with `maskPII`, which only knows built-in patterns. For example, a configured PCMG BO pattern is reported in `findings` while the returned `masked` output still contains `BO nº 2024/098765`, leaking the custom identifier in the exact mode intended for safe disclosure.

- [P2] Prefer custom patterns over generic overlaps — /home/enio/egos/packages/guard-brasil/src/lib/pii-scanner.ts:60-61
  Appending `extraPatterns` after the built-ins means `deduplicateFindings` keeps the earlier generic match when ranges overlap, so institution-specific patterns can be dropped. With the new PCMG profile, `IPL-1234/2024` is matched first as the built-in plate `IPL-1234`, the custom `pcmg:inquerito` match is discarded, and full masking leaves `/2024` behind instead of replacing the whole inquiry number.

- [P2] Expose the registry through the package API — /home/enio/egos/packages/guard-brasil/src/registry/index.ts:19-21
  This new registry is documented for package consumers via a `@egos/guard-brasil/registry`-style import, but the package `exports` map still only exposes `.` and `src/index.ts` does not re-export these symbols. In any workspace/package setup that honors `exports`, consumers cannot import `PCMG_PROFILE` from the published package even though the registry module exists.
```
