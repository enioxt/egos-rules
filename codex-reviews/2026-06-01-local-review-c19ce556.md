# Codex Local Review — 2026-06-01T12:45:42Z

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
session id: 019e8337-f315-7440-b254-d454165a96a0
--------
user
changes against 'HEAD~3'
2026-06-01T12:45:43.408322Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:45:43.418832Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T12:45:45.006411Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:45:48.705624Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:45:49.063631Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
2026-06-01T12:45:49.373227Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 2/5
2026-06-01T12:45:49.940817Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 3/5
2026-06-01T12:45:50.921427Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 4/5
2026-06-01T12:45:52.714440Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
ERROR: Reconnecting... 5/5
2026-06-01T12:45:56.156387Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 502 Bad Gateway, url: wss://chatgpt.com/backend-api/codex/responses
exec
/bin/bash -lc 'git diff f9df740fdecbace772d5d069b9263106eaaa4659' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index deb2ae33..17249086 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -508,6 +508,12 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 - [ ] **MCP-BRIDGE-003** [P0-RedZone] `2h` — Bridge `mcp-governance` + `mcp-knowledge` (RED ZONE — vaza contexto do kernel). Corte do Enio dado; ANTES de deploy: revisão Codex adversarial + confirmar que respostas usam template determinístico público (não arquivos reais), igual trava do meta-prompt API. NÃO expor sem esse gate.
 - [ ] **MCP-BRIDGE-004** [P2] `30min` — Atualizar `docs/guides/MCP_SETUP_CLIENTS.md` (tabela de endpoints LIVE) após cada bridge subir, com probe real.
 
+### MCP → ChatGPT (Apps SDK custom connector) — Enio 2026-06-01
+> Ref: https://developers.openai.com/apps-sdk · Conector custom do ChatGPT = Server URL (SSE) + Auth (OAuth / Sem-auth / Mista). `mcp-g-pecas` já rodou HTTPS-live no ChatGPT → caminho provado. Objetivo: validar uso real dos MCPs no ChatGPT.
+- [ ] **MCP-CHATGPT-001** [P1] `prime` — Validar `mcp-eval-runner` (GREEN: read-only, sem segredo) no conector ChatGPT. **Receita validada (Sonnet 2026-06-01):** ChatGPT exige **Streamable HTTP** em endpoint `/mcp` (auth=Bearer estático basta; OAuth exige auth-server+`/.well-known`). `mcp-bridge` já faz tudo (CORS/Origin/bearer/sessão). Passos: (1) PM2 `MCP_NAME=eval-runner MCP_CMD="bun packages/mcp-eval-runner/src/index.ts" MCP_PORT=7005 bun packages/mcp-bridge/src/index.ts`; (2) Caddy `handle /eval-runner* { uri strip_prefix /eval-runner; reverse_proxy localhost:7005 }` no bloco `mcp.egos.ia.br`; (3) token em `/etc/egos/eval-runner.env`; (4) probe `curl POST https://mcp.egos.ia.br/eval-runner/mcp` initialize; (5) colar URL no diálogo do ChatGPT, auth=Bearer. ~1h. **Toca prod+Caddy → go do Enio + review Codex antes.**
+- [ ] **MCP-CHATGPT-002** [P2] — Escalar p/ os demais MCPs de baixo/médio risco após 001 validado. Governança/knowledge só via MCP-BRIDGE-003 (Red Zone, review Codex adversarial antes).
+- [ ] **MCP-CHATGPT-003** [P2] `gemini/codex` — Cross-validar o conector em ChatGPT + medir fidelidade dos tools por modelo (liga a LLM-BENCH-001). Antigravity/Gemini + Codex executam probes; Prime sintetiza.
+
 ---
 
 ## 🔬 INV-* TASKS 2026-05-21
diff --git a/docs/personal-os/CAPABILITY_COVERAGE_F1.md b/docs/personal-os/CAPABILITY_COVERAGE_F1.md
new file mode 100644
index 00000000..4774796c
--- /dev/null
+++ b/docs/personal-os/CAPABILITY_COVERAGE_F1.md
@@ -0,0 +1,56 @@
+# Capability Coverage F1 — % vs topo do mercado (evidência > credencial)
+
+> **Status:** análise 2026-06-01 (Sonnet research + repo evidence, Prime sintetizou) · **Red Zone** (posicionamento) · pendente corte do Enio
+> **Tese (Enio):** pular cursos/certificados e PROVAR capacidade com número, código, arquitetura, testes, health, uptime. Mirar o topo, depois descer tiers.
+> **Base:** `CAREER_FIT_STUDY.md` (F1 venceu, 83.4) + `ENIO_CURRICULUM_POSITIONING.md`. Métricas CONFIRMADO no repo salvo marcação.
+
+---
+
+## Dashboard
+
+```
+TRACK: F1 — Forense blockchain + Investigador-arquiteto
+
+TOPO   (Tier-1 direto: emprego Chainalysis/TRM)        ████████████░░░░░░░░  61%
+TIER 2 (boutique / advisory / licenciar IP)            ██████████████░░░░░░  72%
+TIER 3 (governança de IA / Guard Brasil)               ████████████████░░░░  78%
+```
+
+**O arrasto do topo é quase só:** R02 (sem demo on-chain), R03/R04 (sem licença Reactor + cert customers-only). Fechar R02 + acesso a tooling free-tier → ~78% no topo, **sem nenhum certificado**.
+
+## Evidência mais forte (JÁ construída — isto é a prova)
+| Req | % | Evidência real |
+|---|--:|---|
+| R01 — background investigação criminal | 100% | 16 anos PCMG (em atividade), cadeia de custódia, testemunho |
+| R09 — fluência IA p/ acelerar investigação | 100% | 24 agentes, 11 MCPs, 148 stages de pre-commit, eval adversarial, ~2.628 commits em 2026 |
+| R14 — pipeline investigativo de IA governado | 90% | kernel EGOS aplicado a investigação (intelink). Diferencial raro [não-benchmarkado vs concorrentes — afirmar só com comparação reproduzível] |
+| R10 — sistema de gestão de caso | 75% | intelink É o sistema (investigações, suspeitos, timeline 15 tipos, NER, link prediction; 517 commits 2026) |
+| R06 — cadeia de evidência / OSINT infra | 75% | `evidence-chain.ts` (6 EvidenceType + testes), `provenance.ts`, pipeline NER |
+| R07 — laudo admissível | 50% | `packages/report-standard/` + gerador RCI (gold standard ERICO v2). Falta formato cripto-forense |
+
+## Gaps críticos (puxam o score — o que CONSTRUIR pra provar)
+| Gap | Esforço | O que construir |
+|---|---|---|
+| **G1 — Demo de rastreio on-chain** (R02/R03) CRÍTICO | 2-3 sessões | wallet → 3-5 hops → clusteriza → hipótese de atribuição → renderiza laudo. **Reusa Neo4j + orquestração do intelink.** É a prova que substitui o CRC. |
+| **G2 — Uptime/SLA não medido** | 1 sessão | `logs/health-report.json` está degraded e velho (2026-04-09). **Não medimos uptime.** Construir `status.egos.ia.br` público (30d). ⚠️ NÃO afirmar uptime em portfólio antes disso. |
+| G3 — Python p/ analytics blockchain (R12) | 1 dia | 1 notebook web3.py + NetworkX rastreando wallet pública conhecida (ex: OFAC SDN). |
+| G4 — Doc COAF/FATF Travel Rule (R08) | 2-4h | template: achado on-chain → formato notificação COAF → atestação de custódia. |
+| G5 — Metodologia DeFi/mixer/bridge (R13) | 1 dia | nota de 1 página (conhecimento, não código — F1 não exige código aqui). |
+
+## Tese credential-skip — o que substitui cada cert
+| Cert que o mercado pede | Substituto-prova | Status |
+|---|---|---|
+| **AIGP** (governança IA, $799) | `docs/governance/` (133) + `.guarani/` (66) + 148-gate pre-commit + eval adversarial + ATRiAN | ✅ **skip defensável AGORA** (artefatos já existem) |
+| **CFE** (fraud examiner) | 16 anos PCMG + `evidence-chain.ts` + intelink | ✅ skip forte (credibilidade prática) |
+| **ACAMS CCAS** (AML cripto) | Guard Brasil (514 LOC PII + guardrails.yaml) + laudo FATF→COAF | 🟡 75% — falta a camada documental FATF/COAF |
+| **Chainalysis CRC** (Reactor) | demo on-chain público + metodologia publicada (CRC é customers-only de qualquer forma) | 🔴 falta a demo (G1) — **construir primeiro** |
+
+---
+
+## Leitura do Prime (recomendação)
+1. **A prova-mãe é a demo on-chain (G1).** É o único item que fecha o maior gap E materializa a tese "faço sem cert". Reusa intelink. P0 se F1 virar foco ativo.
+2. **Uptime é uma armadilha:** você citou uptime como prova, mas hoje NÃO medimos — afirmar seria furar evidence-first. G2 (status page público) transforma a armadilha em prova real.
+3. **AIGP/CFE já estão "skipáveis" hoje** — o portfólio já supera o corpo de conhecimento. CCAS está a um documento de distância.
+4. **Tier 3 (governança IA) é onde você já está mais forte (78%)** — caminho de menor resistência se quiser monetizar advisory pelos vetores seguros (não-perito).
+
+*SSOT origem: CAREER-GAP-001 (TASKS.md). Fontes web: Chainalysis/TRM/ACAMS/IAPP/CipherBlade (ver task transcript).*

codex
The diff only adds planning/documentation content in `TASKS.md` and a new analysis markdown under `docs/personal-os/`, with no executable code, interfaces, or tests affected. I did not find a discrete, actionable defect that would break behavior.
The diff only adds planning/documentation content in `TASKS.md` and a new analysis markdown under `docs/personal-os/`, with no executable code, interfaces, or tests affected. I did not find a discrete, actionable defect that would break behavior.
```
