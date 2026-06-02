# Codex Local Review — 2026-06-01T16:32:38Z

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
session id: 019e8407-b8b1-70f3-8af3-5fe630170c30
--------
user
changes against 'HEAD~3'
2026-06-01T16:32:41.075022Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T16:32:41.075019Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 39f9d31e40a578deb56f7d0e6fe8d39cee594374' in /home/enio/egos
 succeeded in 0ms:
diff --git a/docs/_current_handoffs/handoff_2026-06-01.md b/docs/_current_handoffs/handoff_2026-06-01.md
index 92124e94..d8f920f4 100644
--- a/docs/_current_handoffs/handoff_2026-06-01.md
+++ b/docs/_current_handoffs/handoff_2026-06-01.md
@@ -58,3 +58,47 @@ Landed + pushed (`f2a6a60f..57e05fd5`):
 3. Você NÃO commita/pusha — isso é correto, é meu papel. Continue entregando staged + handoff.
 
 **Diretiva do Enio (vale pra nós dois):** configure quantos subagentes forem necessários, orquestre-os, melhore-os; replique no Claude Code (arquivos compartilhados, nomes/lugares podem diferir). Estou desenhando a Resolver Doctrine (triagem matemática) que vai reger isso — será disseminada em pre-commit/start/end. Próximo handoff trará o SSOT.
+
+---
+
+# Handoff /end — 2026-06-01 (Prime — sessão maratona)
+
+## ✅ Accomplished (SHAs)
+- `49975b29` **MCP-SEC-001** — auth split (RED→401: memory/knowledge/ops/observability/browser; FREE→200: eval-runner/skills-registry/governance). Validado ao vivo + pm2 save.
+- `ae4da0c0` **mcp-bridge fix** — stdio newline framing + line-buffer + notification 202. Causa do "Erro ao criar conector" no ChatGPT. eval-runner validado e2e no ChatGPT.
+- `33292d04` **eval-runner data fix** — EGOS_REPO_ROOT + no-data guard; vê 79 CBCs reais no VPS.
+- `7ea70da6` **dashboard real** — status-snapshot coleta caps/agents/MCPs; /status.json ao vivo (era 15/abr). Manifest agents 23→27.
+- `c732bded` **registry parity** — batch Guarani (portabilidade + 3 agents + schema), 27 agents 0 ghosts.
+- `ab58d389` **open-access-fetch** — fonte legal (Unpaywall→OpenAlex→arXiv→Crossref) substitui Sci-Hub. Validado (Nature paywalled→OA PDF).
+- Docs/SSOT novos: RESOLVER_DOCTRINE, EXTERNAL_ARTIFACT_INTAKE_PROTOCOL, UI_FUNCTIONAL_TESTING_STANDARD, OPEN_ACCESS_SOURCING_RULE, COURSES_FRAMEWORK_GOV_THESIS, ENIO_CURRICULUM_POSITIONING, CAPABILITY_COVERAGE_F1, BLOCKCHAIN_GOVERNANCE_VALIDATION (`6f23ce27`).
+- NotebookLM: notebook framework (db55b6b8) 3→7 fontes (constituição).
+
+## 📌 Decisions Made (cortes do Enio — Resolver §3)
+- **$ETHIK dormente** + ancorar regras no Bitcoin. Workflow temperou: **Sigstore-first** (signed commits+Rekor+OTS ~R$0); blockchain agrega só trustless-operator + cross-org non-repudiation; EAS/Base adiado; NÃO é produto 2026.
+- **Sci-Hub → fonte legal** (Enio: conhecimento livre; implementei legal sem expor policial ativo).
+- **Transparência radical:** framework LIVRE; proteger só máquina + dado-por-natureza.
+- **UI testing obrigatório** (mapa + sign-off duplo prime+enio, 80/20).
+- **.md externo → protocolo de intake** (INC-005 classify; pegou 4 phantoms do ChatGPT).
+- **Blockchain: validar antes de assumir** (sem hype).
+
+## ⏳ Blocked / Red Zone (corte do Enio pendente)
+- **FE-SYNC-001** [P0] — egos.ia.br roda server.ts ~1931 linhas atrás (deploy drift). Release controlado = sessão dedicada + prova visual §10. Dado já live; HTML render falta rebuild.
+- **PROOF-VERDICT-001** / **BLOCKCHAIN-002-ETHIK-LEGAL** [P0] — vale a energia? + parecer estatuto/CVM do $ETHIK live.
+- **HANDOFF-SCIHUB-001** — Sci-Hub local-only (gitignored); trocado por open-access-fetch.
+
+## 🔗 Next Steps (prioridade)
+1. **FE-SYNC-001** release egos-site (frontend refletir) — sessão dedicada.
+2. **RULE-DISCOVERY-001** índice de regras kernel+leaf.
+3. **OTS-PROTO-001 / MVP1** anchoring $0 (signed-commit+Rekor+OTS + `egos proof verify`).
+4. **OA-API-001** API Mestra de literatura + MCP.
+5. **NLM-FW-002** auto-sync NotebookLM via Hermes post-push.
+6. **AGENT-EVAL-001** harness de avaliação de agentes (INC-008).
+
+## 🌐 Environment
+- Build: ✅ | Deploy VPS: MCPs live (eval-runner/skills-registry/governance FREE; RED protegidos 401). egos.ia.br: server.ts stale (FE-SYNC-001).
+- ⚠️ 4 stashes `wip` acumulados (cruft de colisão de janelas paralelas) — limpar.
+- ⚠️ Janelas paralelas colidiram (open-access-fetch duplicado) — coordenação via blackboard a melhorar.
+
+## 🚫 [CONCEPT] (não entrar em HARVEST)
+- Token próprio EGOS (descartado — $ETHIK dormente).
+- A↔B blockchain interop (INFERRED, não shipado).
diff --git a/docs/audits/premortem-kyte-strategy.md b/docs/audits/premortem-kyte-strategy.md
new file mode 100644
index 00000000..9a6f396e
--- /dev/null
+++ b/docs/audits/premortem-kyte-strategy.md
@@ -0,0 +1,95 @@
+# Premortem — Estratégia pós-benchmark Kyte
+
+> **Data:** 2026-06-01 · **Tipo:** Red Zone (pricing + monetização + contexto policial PCMG ativo)
+> **SSOT relacionado:** benchmark Kyte (síntese em sessão) · [[user_enio_active_police]] · [[user_enio_positioning]]
+
+## §1 — Contexto da decisão
+- **O quê:** (1) ligar split de pagamento (`allowPartnerGatewaySplit:false→on`) → escola payments-first → possuir dado de fluxo de caixa; (2) colapsar 6 repos num PDV mobile coeso; (3) vender "governança como feature" (vendedor-IA governado no WhatsApp + Pix/split).
+- **Por que agora:** benchmark mostrou que vencedores capturam pagamento → dado → crédito; EGOS tem IA/MCP/governança mas R$0 receita e produto fragmentado.
+- **Sucesso em 6 meses:** ≥1 produto coeso no ar com merchants reais pagando, monetização **fora do vetor que choca com o estatuto PCMG**, sem incidente legal.
+
+## §2 — Premissa
+São 6 meses depois. A decisão deu errado. A história:
+
+## §3 — Modos de falha (8)
+
+| ID | Falha | Prob | Sev | Sinal precoce |
+|---|---|---|---|---|
+| **F1** | **Split ligado = EGOS recebe % de transação = monetização comercial direta + sócio-gerente de fato → choca com estatuto PCMG/COI.** Processo administrativo, risco ao cargo. | **A** | **A** | Qualquer R$ de transação passando por CPF/CNPJ ligado ao Enio |
+| **F2** | "Colapsar 6 repos num PDV" vira mega-refactor de meses, mais um projeto inacabado, 0 tração no fim. | A | M | Prazo escorregando, nenhum cliente novo em 60d |
+| **F3** | Split estava desligado por razão real (Chesterton's fence): KYC do recebedor / responsabilidade tributária / compliance Asaas. Ligar sem entender = exposição. | M | A | Erro no onboarding Asaas; pendência fiscal |
+| **F4** | PDV de 3 toques é produto inteiro (Kyte: 8 anos, offline-first, 40k lojas). Entramos num mercado maduro com produto inferior e zero distribuição. | A | M | Time-to-first-sale alto; churn de demo |
+| **F5** | "Governança como feature" não converte: micro-merchant paga por **vender mais**, não por anti-alucinação/LGPD (mesmo learning do Guard Brasil opcional). | A | M | Pitch não fecha; ninguém valoriza o diferencial |
+| **F6** | Dado de fluxo→crédito embarcado = vira **fintech regulada** (SCD/IF, capital, licença) + de novo choca com estatuto. | M | A | Discussão de "emprestar"/"antecipar" recebível |
+| **F7** | Possuir dado de venda de clientes-do-merchant (terceiros) sem base legal robusta = exposição LGPD ampliada. | M | A | Dado de PII de comprador final armazenado sem DPA |
+| **F8** | Produto perfeito, **0 canal de aquisição**. Kyte tem app-store/SEO/mobile-first; EGOS não tem CAC viável. | A | A | CAC infinito; só GoW (~15-20) como base |
+
+## §4 — Mitigações (F-críticas: prob×sev ≥ M×M)
+
+**F1 + F6 (BLOQUEADORES LEGAIS — dominantes):**
+- **Preventiva:** monetização que toca % de transação / crédito **NÃO passa pelo Enio**. Roteia por **terceiro (CNPJ não-gerido por Enio: parceiro/sócio operacional)** ou pivota para vetores seguros já mapeados: **IP/licença do framework, magistério/curso, governança/advisory** ([[user_enio_active_police]]). EGOS-de-Enio = camada de IP/tecnologia; quem opera comércio/recebe = outra pessoa jurídica.
+- **Sentinela:** regra dura — nenhum fluxo financeiro de cliente final liquida em conta ligada ao Enio.
+- **Rollback:** manter split OFF até parecer jurídico (BLOCKCHAIN-002-ETHIK-LEGAL tem precedente desse tipo de gate).
+- **🔴 RED ZONE HALT:** decisão do Enio obrigatória antes de ligar qualquer captura de pagamento.
+
+**F3 (split desligado por quê):**
+- Preventiva: investigar o git-blame / commit que setou `false` + checar pendências Asaas KYC antes de ligar. Não ligar por suposição.
+
+**F7 (LGPD dado de terceiros):**
+- Preventiva: DPA + base legal explícita antes de armazenar PII de comprador final; guard-brasil já cobre detecção, falta o contrato.
+
+**F8 (sem canal de aquisição — crítico A×A):**
+- Preventiva: **antes de construir mais produto, validar 1 canal de aquisição** com os ~15-20 do GoW como design partners. Se não converte com quem já confia, produto novo não salva.
+- Sentinela: meta de N merchants ativos reais em 60d antes de qualquer refactor grande.
+
+**F2 + F4 + F5 (foco/produto):**
+- Preventiva: **NÃO colapsar tudo de uma vez.** Escolher 1 produto vivo (storefront, que está no ar) + 1 merchant real, e provar venda-via-WhatsApp-IA antes de construir PDV. Matar/arquivar forja (404) formalmente em vez de "ressuscitar".
+
+## §5 — Gate de execução
+- [x] Mitigações para F-críticas registradas (F1/F6/F8 acima)
+- [ ] **🔴 RED ZONE: split/payments-first BLOQUEADO até decisão explícita do Enio** (estatuto PCMG) — CLAUDE.md §0.5
+- [ ] Sentinela "zero R$ liquidando no Enio" wired antes de qualquer captura
+- [ ] Validação de 1 canal de aquisição (GoW design partners) ANTES de refactor de produto
+- [ ] git-blame do `allowPartnerGatewaySplit:false` investigado (F3)
+
+## Veredito
+**A jogada "payments-first → dado → crédito" (copiada dos vencedores globais) é exatamente o que o Enio NÃO pode fazer pessoalmente como policial ativo.** O premortem inverte a prioridade: (1) validar canal de aquisição com base GoW, (2) provar o vendedor-IA governado sobre storefront vivo (sem tocar em split), (3) só então estruturar captura de pagamento **via terceiro/CNPJ não-gerido por Enio**. Movimento "ligar split" rebaixado de #1 → bloqueado-pendente-jurídico.
+
+---
+
+## v2 — Após Codex (NEEDS-REWORK) + Banda Cognitiva (2026-06-01)
+
+> Codex acertou o descasamento legal (manter split bloqueado) mas apontou: falta **máquina executável sob capacidade-de-founder limitada** + modos ausentes + sequência (pilotos PAGOS antes de canal genérico). Banda Cognitiva sintetizou a v2 abaixo.
+
+### Tese v2
+Não vendo governança — vendo **"vendedor-IA que responde preço certo e fecha venda 24h, sem você no balcão"** para **1 merchant que JÁ pediu reunião (Julio/G Peças)**, cobrando como **serviço técnico/licença PF** (vetor seguro PCMG). Governança é o motor invisível que sustenta preço e protege. **Receita real em 30 dias destrava tudo; sem ela, pivota pra magistério.**
+
+### Modos de falha que o premortem v1 perdeu (Codex)
+| Modo | Mitigação |
+|------|-----------|
+| Colapso-capacidade-founder (polícia full-time, WIP≤2) | 1 piloto só (Julio), cadência fixa seg/qua/sex, runbook incidente WhatsApp escrito ANTES de cobrar |
+| Operador-terceiro fantasma | Piloto NÃO usa terceiro — Enio cobra direto PF; terceiro só entra quando houver receita que o pague |
+| Sociedade-oculta (substância>forma) | Enquanto Enio define preço/estratégia/dados, NÃO existe terceiro: ou é serviço PF puro, ou nada |
+| Canal-único (ban WhatsApp/Meta) | Storefront web é o ativo primário; WhatsApp é canal, não produto — vender o storefront, não o número |
+| Cópia-rápida Kyte-class | Não competir em feature; vender relacionamento + acompanhamento humano 30d (incumbente não faz) |
+| Viés-GoW (entusiastas ≠ SMB) | Cliente-alvo = merchant com orçamento e dor real (Julio), nunca os 15-20 do workshop |
+
+### Máquina de 90 dias (Enio solo, sem operador)
+- **Q1-2 — Oferta + gate legal (NÃO código):** 1pág de oferta ("setup R$1.500 + R$500/mês, NF PF serviço técnico/licença") + runbook incidente WhatsApp + reunião Julio. **Gate: parecer escrito sobre licença/advisory PF no estatuto PCMG ANTES do 1º real. Kill: sem parecer → não cobra → magistério.**
+- **Q3-4 — Fechar 1 piloto pago:** contrato PF assinado + 1º setup recebido. **Kill: Julio não paga setup em 14d → sem willingness-to-pay → pivota.**
+- **Q5-8 — Operar e medir:** storefront+vendedor-IA vivo no catálogo do Julio; relatório semanal (conversas/leads/erros de preço evitados). **Kill: <20 conversas reais OU ≥1 erro de preço grave não corrigido em 48h → matar.**
+- **Q9-12 — Renovação = go/no-go:** Julio renova R$500/mês ou não. **Go → merchant #2 (Bernardo). No-go → arquivar wedge, formalizar pivô magistério/curso.**
+- **Threshold:** 1 merchant pagando ≥R$500/mês recorrente após 30d de uso real. Abaixo = teatro.
+
+### 3 decisões Red Zone (só Enio)
+1. **Parecer formal do estatuto PCMG** — licença/advisory PF é permitido? Premissa-raiz [VERIFICAR]; sem parecer escrito, nenhum real entra.
+2. **Aceitar contato direto com o merchant** — Enio aparece em reunião/contrato/WhatsApp? Define se a forma colide com a substância.
+3. **Cravar o número kill/go** — R$500/mês recorrente é o threshold? Sem o Enio fixar, todo resultado vira racionalizável.
+
+### O que NÃO fazer (anti-dispersão — arquivar agora)
+- **Split de pagamento:** manter DESLIGADO; não tocar até haver receita + terceiro real.
+- **Estruturar PJ-terceiro/operador:** zero esforço; fantasma até existir receita que o pague.
+- **"Validar canal" genérico / dashboards de engajamento:** proibido como entrega; só conta dinheiro de merchant.
+- **5 produtos fragmentados (forja 404):** congelar; foco exclusivo no storefront/vendedor-IA G Peças.
+- **Pitch de governança/LGPD ao merchant:** nunca liderar com isso — motor invisível, não argumento de venda.
+- **Recrutar os 15-20 do GoW como pilotos:** viés amostral; ignorar até 1 merchant pagante validado.
diff --git a/docs/jobs/2026-06-01-doc-drift-verifier.json b/docs/jobs/2026-06-01-doc-drift-verifier.json
index 79da5414..613b10b4 100644
--- a/docs/jobs/2026-06-01-doc-drift-verifier.json
+++ b/docs/jobs/2026-06-01-doc-drift-verifier.json
@@ -1,7 +1,7 @@
 {
   "manifest": "/home/enio/egos/.egos-manifest.yaml",
   "repo": "egos",
-  "verified_at": "2026-06-01T01:19:46.492Z",
+  "verified_at": "2026-06-01T14:34:20.909Z",
   "summary": {
     "total_claims": 15,
     "passed": 14,
@@ -17,8 +17,8 @@
       "id": "total_agents",
       "description": "Agents registered in agents.json",
       "status": "ok",
-      "last_value": "23",
-      "current_value": "24",
+      "last_value": "27",
+      "current_value": "27",
       "tolerance": "min:18",
       "command": "python3 -c \"import json; print(len(json.load(open('agents/registry/agents.json')).get('agents', [])))\"",
       "severity": "ok"
@@ -72,7 +72,7 @@
       "description": "Total commits across all active EGOS repos in last 30 days",
       "status": "ok",
       "last_value": "1466",
-      "current_value": "1115",
+      "current_value": "1171",
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
index 55d5822b..19eec6a7 100644
--- a/docs/jobs/2026-06-01-pre-commit-pipeline.json
+++ b/docs/jobs/2026-06-01-pre-commit-pipeline.json
@@ -142,5 +142,69 @@
     "duration_ms": null,
     "event": "commit:chore files=1 sha=bcf19847",
     "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:29:27.473Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=0 sha=8e123152",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:31:10.653Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=2 sha=1bd668d8",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:32:15.166Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:fix files=1 sha=ab58d389",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T14:34:22.176Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=4 sha=9a6636e3",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T16:12:31.992Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:feat files=3 sha=2ad87195",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T16:14:03.219Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=1 sha=6f23ce27",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T16:16:34.704Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:docs files=2 sha=39f9d31e",
+    "repo": "/home/enio/egos"
+  },
+  {
+    "agent_id": "pre-commit-pipeline",
+    "ts": "2026-06-01T16:20:06.548Z",
+    "status": "ok",
+    "duration_ms": null,
+    "event": "commit:chore files=1 sha=bdafb778",
+    "repo": "/home/enio/egos"
   }
 ]

codex
The diff only updates documentation and operational JSON log artifacts, with no executable code or configuration behavior changes that would introduce a functional regression. I did not identify any discrete, actionable bugs in the modified lines.
The diff only updates documentation and operational JSON log artifacts, with no executable code or configuration behavior changes that would introduce a functional regression. I did not identify any discrete, actionable bugs in the modified lines.
```
