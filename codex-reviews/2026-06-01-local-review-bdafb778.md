# Codex Local Review — 2026-06-01T16:20:17Z

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
session id: 019e83fc-68a5-7c70-8b75-3d8178c0f1f8
--------
user
changes against 'HEAD~3'
2026-06-01T16:20:19.274374Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-01T16:20:19.274374Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 2ad8719588bd91279661207d1881469166f03bcb' in /home/enio/egos
 succeeded in 0ms:
diff --git a/TASKS.md b/TASKS.md
index 23c7520d..9b852cba 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -549,7 +549,11 @@ PATTERNS-001 → AUTORES-CONSUMER-001 → AUTORES-PROPOSE-001 → AUTORES-LOOP-0
 ## 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
 
 > SSOT: `docs/governance/EXTERNAL_ARTIFACT_INTAKE_PROTOCOL.md` v1.0. Quando Enio traz .md externo (ChatGPT/Grok/etc): land em _inbox → classifica INC-005 (REAL/CONCEPT/PHANTOM) → grande delega a agente → mapeia vs existente (não reinventar) → triagem Resolver → tasks/memória.
-- [/] **INTAKE-CHATGPT-001** [P1] — Processar `~/Downloads/ChatGPT-Análise de documento EGOS (1).md` (13k linhas) via protocolo (agente Sonnet rodando). Extrair acionáveis classificados → tasks.
+- [ ] **PRICING-CLARITY-001** [P2] — Doc-fix (não muda preço): deixar legível no strategy doc que R$100/mês é o piso de recorrência (Demo Starter), não a âncora; receita 30d = setup fees, não MRR. (ChatGPT criticou baseado em leitura incompleta.)
+- [ ] **AGENT-EVAL-001** [P2] — Construir o benchmark de avaliação de agentes descrito em `agent_scopes_and_governance.md §3`: scoring por critério de Prime/Operator/Codex/?!? em tasks reais (≥3 golden cases/agente — INC-008). Hoje a capability é alegada sem harness.
+- [ ] **HITL-MULTICHANNEL-001** [P3] — Wire a política HITL multi-canal (Telegram+WhatsApp+email) que aparece em `.guarani/GUARANI.md` mas só tem Telegram parcial. Dispatcher único por policy.
+- [ ] **PUBLIC-CHATBOT-001** [P3] `redzone` — Chatbot escopado no egos.ia.br que carrega contexto via MCPs e explica o EGOS. Pré-req: SITE-VOICE-001 + landing estável. Não iniciar antes da copy aprovada.
+- [ ] **INTAKE-CHATGPT-001b** [P2] `redzone` — `egos_copy_5_versoes_meta_prompt.md` alimenta SITE-VOICE-001: composite V1(alma)+V2(investigação/ciber, MAIOR risco institucional, revisão PCMG)+V3(README técnico)+V5(convite). NADA publicado verbatim sem corte do Enio.
 - [ ] **RULE-DISCOVERY-001** [P1] `prime` — Sweep de TODOS os conjuntos de regras (kernel + leaf repos `/home/enio/*`): glob CLAUDE.md/AGENTS.md/SOUL.md/RULES_INDEX/.guarani/INHERITS/governance → índice `docs/governance/RULE_SETS_INDEX.md` (repo→regras→tier→última verificação) + detectar conflito (`.guarani` prevalece). Alimenta /start + herança Layer 0.
 - [ ] **INTAKE-WIRE-001** [P2] — Wire o protocolo em /start (rule-set awareness) + gatilho comportamental do Prime + considerar virar skill `/intake`.
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 54544abe..5b1d2fb8 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3333,3 +3333,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 ### 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
 - [x] **INTAKE-PROTO-001** — Protocolo escrito (5 passos + roteamento por tipo + segurança anti-injection).
 
+
+## Archived 2026-06-01
+
+### 📥 EXTERNAL ARTIFACT INTAKE — protocolo + auto-aprendizado de regras (Enio 2026-06-01)
+- [x] **INTAKE-CHATGPT-001** — Processado via protocolo (agente Sonnet). 35 claims: 22 REAL / 9 CONCEPT / **4 PHANTOM** (não agir: "R$100/mês" leitura stale do pricing; arquivos de agente que já existem; path `docs/policies/` inexistente; "não há agent registry" falso). Raw fica local (~/Downloads, não commitar 700KB de chat). Acionáveis ↓.
+
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
diff --git a/docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md b/docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md
new file mode 100644
index 00000000..be2a2e47
--- /dev/null
+++ b/docs/strategy/BLOCKCHAIN_GOVERNANCE_VALIDATION.md
@@ -0,0 +1,265 @@
+# Blockchain × EGOS AI Governance — Decision Dossier
+
+> **Status:** RESEARCH-ONLY · no implementation · v1.0 · 2026-06-01
+> **Owner:** EGOS Prime (Resolver Doctrine — last layer of resolution)
+> **Mission framing:** the goal is **NOT** to put blockchain in EGOS. The goal is to discover **IF** blockchain improves AI governance. If it does not, recommend the proven alternative: Git + signed commits + audit logs + OpenTelemetry + Guard Brasil + capability-registry.
+> **SSOT for this question.** Grounded in 5 research inputs (internal inventory, external/interop, cost, personas/viability, telemetry/KPI). Inferred claims are marked `INFERRED`.
+
+---
+
+## TL;DR (read this first)
+
+Blockchain adds exactly **two** honest things over what EGOS already has or can get for free: (1) **removal of the trusted operator** (a public chain has no single party who can be coerced or go down), and (2) **cross-org non-repudiation** when parties distrust each other and share no CA. Everything else — authorship, integrity, timing, immutability, transparency-log — is **already** delivered by signed git commits + Sigstore/Rekor + in-toto/SLSA at **~R$0** marginal cost.
+
+**Verdict:** build a **thin, no-token "governance provenance" skill**, Sigstore-first, with **OpenTimestamps as an optional free Bitcoin anchor** and **EAS-on-Base deferred** until a concrete external verifier demands it. Worth a **time-boxed Fibonacci-3 cycle** as internal dogfood + F1 (forensic) demo + one article. **Not** a product to sell in 2026 (no buyer exists). **Never a token.** Red Zone gate before any investigation-data touches any anchor.
+
+---
+
+## 1. Internal inventory — what EGOS already has (reuse, don't reinvent)
+
+EGOS already operates most of a provenance/attestation system. The proof layer is **half-built**.
+
+| System | Path | Status | Proof-layer reuse |
+|--------|------|--------|-------------------|
+| Audit logs | `packages/audit/` (`activation-audit.ts`: UUID, timestamp, identity, action, resource, result, reasoning + Zod) | REAL | HIGH — extend `AuditLogger` to a Merkle accumulator / external sink |
+| Versioned records | `packages/audit/src/versioned-record.ts` (`version`, `canonicalId`, `supersedes`, `disputeOf`, `status`) | REAL | HIGH — lightweight ledger; add `hash`/`parentHash` for chain-of-custody |
+| PII detection | `packages/guard-brasil/` (16+ patterns: CPF, CNPJ, RG, REDS, secrets) + `guard-brasil-mcp` `POST /v1/inspect` | REAL | HIGH — mandatory gate before any hash is anchored (never anchor PII) |
+| Capability evidence | `docs/governance/CAPABILITY_PROMOTION_RULES.md` (6 maturity levels + behavioral eval CI, INC-008) | REAL SSOT | HIGH — `evidence` field already exists; add `attestation_uid` |
+| Decision records | `docs/governance/ADR_DIGEST.md` (hash-based cache of locked ADRs) | REAL SSOT | MEDIUM — hash == commitment; the anchoring pattern already exists |
+| Doc-drift contract | `.egos-manifest.yaml` (claims-as-code, reproducible shell verification) | REAL | MEDIUM — refactor to link external attestation UID/CID |
+| HITL approval | `docs/governance/human-in-the-loop.md` (`@EGOSin_bot`, risk levels, escalation) | REAL | MEDIUM — adds a human "witness" signature to proof-worthy decisions |
+| Governance enforcement | `.husky/pre-commit` (gitleaks, tsc, frozen zones, drift) | REAL (locked) | HIGH — natural place to require/append a proof before commit |
+| Capability registry | `docs/CAPABILITY_REGISTRY.md` (168 entries) + `CBC-*.md` + `CAPABILITY_SCHEMA.md` | REAL | HIGH — the registry *is* the governance object to anchor |
+
+**Already on-chain (but unrelated):** `$ETHIK` token lives on Base L2 (`docs/ETHIK_COMPLETE.md`, `egos-lab/apps/egos-web/api/ethik-*.ts`). This is a **fair-launch community token**, NOT an attestation service — **do not conflate**. Mission explicitly excludes a tradeable token; ETHIK is out of scope here.
+
+**Confirmed gaps (NOT yet built):** no SHA-256 Merkle chaining, no OpenTimestamps client, no EAS integration, no receipts system, no Merkle accumulator. So the build is *additive over* a mature base, not greenfield.
+
+**Conclusion of §1:** EGOS is ~70% of the way to "signed, versioned, evidence-backed governance records" without any chain. The missing 30% is *hashing + anchoring + verify CLI* — small.
+
+---
+
+## 2. External proof-architecture comparison + interoperability + minimum stack
+
+### Layer-by-layer verdict (from external research)
+
+| Primitive | Verdict | What it proves | Cost surface |
+|-----------|---------|----------------|--------------|
+| **Bitcoin / OpenTimestamps (OTS)** | **CONFIRMED best for Layer A** | "this hash existed before block N" — neutral, vendor-independent, Merkle-aggregates millions of hashes into 1 BTC tx | **Free** via public calendars; TS impl `typescript-opentimestamps` |
+| **Base + EAS** | **CONFIRMED best for Layer B** | per-decision attestation referencing a rule hash; schema registry + attest contracts; on/offchain; revocation; delegated | gas only, **<$0.01–$0.50** on-chain; **offchain = free** (`eas-sdk`) |
+| Ethereum mainnet EAS | skip | same as Base | too expensive per attestation |
+| Bitcoin L2s (Stacks, RSK, Liquid, RGB, Taproot Assets, Lightning) | **SKIP** | target BTCFi/DeFi/asset issuance, not attestation; add token/asset baggage | adds cost + token surface, zero attestation benefit |
+| Sigstore/Rekor (v2 GA 2025) | **CONFIRMED complementary** | signed, witnessed, append-only transparency log; BigQuery-queryable | free public-good log; operator-run (foundation) |
+| in-toto / SLSA | **CONFIRMED complementary** | build/code provenance envelope; GitHub default for public repos | free |
+| Signed git commits (GPG/SSH) | **CONFIRMED baseline** | authorship + integrity | free |
+| Arweave | optional | pay-once permanent storage (~$6.35–12/GB) | content-addressed via hash/CID |
+| IPFS | optional | cheap working storage, needs pinning | folds into an always-on node |
+
+### Interoperability: Layer A (OTS/Bitcoin) ↔ Layer B (EAS/Base) — `INFERRED` composition pattern
+
+The link is **hash-as-pointer**, bidirectional (this is an engineering composition, not a shipped product):
+
+1. **Constitution v1.3** → canonical JSON → `sha256 = RULE_HASH`. Body stored on Arweave/IPFS → `CID`. **OTS-stamp `RULE_HASH` on Bitcoin → `.ots` proof.** (Layer A: existence + time, maximally decentralized.)
+2. **Each AI decision** → **EAS attestation on Base** whose schema embeds `ruleHash (=RULE_HASH)`, `ruleCID`, `decisionCID`, `parentAttestationUID`. (Layer B: programmable decision graph.)
+3. **Cross-reference:** the Layer B attestation *embeds* `RULE_HASH`/`CID` → cryptographically binds every decision to the Bitcoin-anchored rule version. Chain-of-custody = linked `parentAttestationUID` DAG on Base; **root = the OTS-anchored constitution**. Content integrity = CID; existence/time = OTS; decision graph = EAS.
+
+> **Caveat (must verify before build):** the A↔B linking is INFERRED. Verify EAS schema field limits and the OTS-TS verification API against current docs.
+
+### Minimum viable interoperable stack
+
+- **Layer A (anchor):** OpenTimestamps on Bitcoin for the constitution/rule-set hash. Free, neutral.
+- **Layer B (attest):** EAS **offchain** for routine decisions (free, signed, self-stored); **onchain on Base** only for high-stakes checkpoints.
+- **Storage:** IPFS + pinning for working data; Arweave only for must-be-permanent artifacts (the constitution).
+- **Provenance (cheap, optional):** signed git commits + Sigstore/Rekor for the code/agent build.
+
+**Cut everything else.** Absolute minimum = **OTS + EAS(Base) + IPFS** — three TS libraries, **zero token.**
+
+---
+
+## 3. Context boundary map — what goes where
+
+Four concentric layers. **Sensitivity decreases outward; permanence increases outward.** PII/secrets NEVER cross past layer (b).
+
+| Layer | What lives here | Concrete content | Approx size | Mutability |
+|-------|-----------------|------------------|-------------|------------|
+| **(a) IA context window** | Live reasoning of the agent for the current turn/decision | prompt, retrieved rules, tool outputs, the decision being made | ~200k tokens (autocompact ~167k) | ephemeral, never persisted raw |
+| **(b) Off-chain operational memory** | EGOS working state — full content, including sensitive | `docs/` SSOTs, blackboard (`~/.egos/`), path-memory (`mcp-memory`), `agents/.logs/events.jsonl`, Supabase tables (`mcp_audit_events`, `api_usage`), CBC files | MB–GB | mutable, governed, may contain PII (Guard Brasil applies) |
+| **(c) Proof layer (hash/manifest/attestation)** | Cryptographic commitments only — NO content | `sha256` of canonical rule JSON (32 bytes); manifest of `{ruleHash, ruleCID, decisionHash, timestamp, version}` (~0.5–2 KB JSON); `.ots` proof (~0.5–4 KB); EAS attestation UID (32 bytes) | bytes–KB per item | append-only / immutable |
+| **(d) Public layer** | What any stranger can see & verify — zero PII, zero secrets | proof id (attestation UID / `.ots` ref), timestamp, semantic version (`v1.3`), content hash, verify link (BaseScan/EASScan/opentimestamps.org) | ~200–500 bytes per record | immutable, permanent |
+
+**Rules:**
+- Guard Brasil (`POST /v1/inspect`) runs at the **(b)→(c) boundary** — if any PII/secret is detected in what's about to be hashed, **block**. (Already real infra; `status-snapshot.ts` already runs a Guard Brasil audit before writing public JSON.)
+- Layer (c) anchors **hashes only**. The body never goes on-chain (LGPD right-to-erasure: immutable PII is permanent harm).
+- Layer (d) carries a **pointer + proof**, never the artifact. Example public record: `{"id":"0xabc…","v":"1.3","sha256":"…","ts":"2026-06-01T13:28Z","verify":"https://easscan…"}`.
+
+---
+
+## 4. Cost table (BRL + USD)
+
+**Assumptions:** USD/BRL = 5.04 (1 Jun 2026); BTC ≈ US$73k; ETH ≈ US$2,600; Base eff. gas ~0.01 gwei; EAS onchain attestation ≈ 175k gas ≈ **US$0.01 / R$0.05** (band US$0.002–0.05); OTS via public calendar = **free**. Excludes Enio's labor.
+
+### Decision attestations per month (EAS on Base, ~US$0.01 each)
+
+| Volume / mo | USD | BRL | Upper band ($0.05/ea) BRL |
+|---|---|---|---|
+| 10 | $0.10 | R$0.50 | R$2.52 |
+| 100 | $1.00 | R$5.04 | R$25.20 |
+| 1,000 | $10 | R$50 | R$252 |
+| 10,000 | $100 | R$504 | R$2,520 |
+
+### Component costs
+
+| Component | Cost | Note |
+|-----------|------|------|
+| OpenTimestamps (Bitcoin anchor) | **R$0** | free public calendars batch thousands of hashes into 1 tx |
+| OTS self-submitted BTC tx (alt) | ~US$0.51 / R$2.58 per anchor (R$25.70 at congestion) | unnecessary — use free calendar |
+| Off-chain proof in Git | **R$0** | proofs are KB-sized |
+| IPFS self-pinned | **R$0** marginal | needs always-on node |
+| Arweave permanent | <US$0.001 / <R$0.005 per proof; 10k×5KB = R$1.77 one-time | only for the constitution itself |
+| Self-hosted explorer | US$5–20/mo (R$25–100/mo) | **skip** — BaseScan/EASScan/OTS verify free |
+
+### Git-only baseline (the alternative to beat)
+
+| | Value |
+|---|---|
+| **Cost** | **≈ R$0** — Git yours, GPG/SSH signing free, Rekor public log free (99.5% SLO) |
+| **Gained** | zero cost, instant, no wallet/key-custody, no token, no volatility, simple to explain, cryptographically verifiable + transparency-logged |
+| **Lost vs on-chain** | no *permissionless* independent timestamp (Rekor is foundation-operated, can be coerced/go down); no public-chain "notary" narrative; weaker vs adversary who controls your infra |
+| **~R$0 mitigation** | Git + signed commits + Rekor **+ free OTS on repo HEAD** → real Bitcoin anchor at **zero marginal cost** |
+
+**Bottom line:** on-chain cost only "matters" financially above **~10k attestations/month** (R$504–2,520/mo). Below that it's rounding error. **The real cost is always human/cognitive + key custody, not gas.** OTS+Git+Rekor = lowest cognitive load (one cron line, no keys, easy to explain to a non-crypto auditor). EAS/Base = highest tax (fund wallet, key custody = Red Zone, monitor gas, explain L2+blob to stakeholders).
+
+---
+
+## 5. Personas + clients + who pays NOW
+
+| Role | Who | Reality |
+|------|-----|---------|
+| **User** | (a) EGOS itself (dogfood — strongest, honest use); (b) dev teams running autonomous agents; (c) compliance analysts | genuine emerging pain for (b): "prove agent X's change was gated by policy v7, not v6" |
+| **Beneficiary** | auditors, regulators, courts | want tamper-evidence of *why* a decision was made |
+| **Buyer / Decider** | CISO, Head of Compliance, GRC lead | **today they buy AI-governance platforms (Modulos, Credo, IBM)** that satisfy the checkbox **without** on-chain anchoring |
+| **Operator** | platform / SRE team | runs the anchoring cron + key custody |
+| **Special fit** | **Forensic / investigation (Enio's F1 track)** | chain-of-custody for AI-assisted analysis maps directly onto crypto-forensics positioning |
+
+**Who pays NOW: nobody — for on-chain AI attestation specifically.** This is **pre-market in 2026.** Enterprises buy governance dashboards and audit trails, not blockchain proofs. The only honest near-term "client" is **EGOS itself** (credibility/dogfood) and the **F1 demo** (portfolio/positioning), not a paying account.
+
+---
+
+## 6. Real gains vs today's alternatives; real losses/risks
+
+### Gains the chain *actually* adds (narrow & honest)
+
+Today's free stack (git history + GPG/Sigstore-keyless + Rekor + in-toto/SLSA + OpenTelemetry + RFC-3161) already delivers **authorship, integrity, timing, AND immutability**. On-chain adds only:
+1. **No trusted operator** — Rekor/timestamp authorities are run by *someone*; a public chain removes that single party.
+2. **Cross-org non-repudiation** — when parties distrust each other and share no CA.
+
+For a solo arquiteto and most single-org cases, **Rekor + Sigstore + signed commits already suffice** — cheaper, standard, auditor-recognized, no chain. **The marginal honest gain is narrow.**
+
+### Losses / risks
+
+- **Hype / Web3-for-Web3** — biggest reputational risk; dilutes the credible "arquiteto de IA" positioning (memory: lead with architecture, not a blockchain vitrine).
+- **Immutable-by-mistake** — anchoring a wrong or PII-bearing hash is permanent; LGPD right-to-erasure tension → **anchor hashes only, never content.**
+- **Legal / privacy + active police officer (Red Zone)** — public-chain anchoring of investigation artifacts could collide with *sigilo*, custody rules, and COI monetization constraints (Enio is PCMG **in active duty**). Must stay hash-only, off-chain content, **never touch case data**. Any investigation-data use → task + Enio cut, never auto-resolve.
+- **Maintenance + external infra dependence** — chain/RPC uptime, key rotation, wallet funding (Red Zone key custody).
+
+---
+
+## 7. KPIs — reusing EGOS's existing telemetry
+
+No new telemetry sink needed for an MVP; everything maps onto confirmed existing logs.
+
+**Technical proof KPIs**
+- **Time-per-proof** = avg `mcp_audit_events.duration_ms` per anchor op
+- **Cost-per-proof** = Σ `api_usage.cost_usd` by proof type (table created 2026-06-01)
+- **Verification rate** = passing evals in `tests/eval/capabilities/` ÷ total
+- **Latency SLA** = `snapshot.services[].latencyMs` (status-snapshot.ts, every 5 min)
+
+**Value KPIs**
+- **Critical decisions anchored** = correlation_id chains in `agents/.logs/events.jsonl`
+- **Audit ease** = time to regenerate `workflow-override-audit.md`
+- **Drift caught** = doc-drift/task-drift/schema-drift detections per week
+
+**Risk / safety KPIs**
+- **PII avoided** = Guard Brasil audit pass rate at the (b)→(c) boundary (already runs in snapshot)
+- **HITL/override rate** = custom-edit % (signals missing model signal)
+- **Schema failures** per audit cycle
+- **Provider-key health** = dead-key detection latency (target <1 day)
+
+**Gap:** no OpenTelemetry traces today (custom JSONL only); no unified KPI sink. Existing recommendation stands: wire `events.jsonl` + `mcp_audit_events` + `api_usage` + hook telemetry + `snapshot.json` into a `egos_kpi_aggregates` table, expose `/status/api/kpis`. **This is independent of blockchain and worth doing regardless.**
+
+---
+
+## 8. Viability matrix
+
+Scores 1–5 (5 = best/easiest/most-mature). Classification per component.
+
+| Component | Val-tech | Val-comm | Val-rep | Cost⁺ | Cmplx⁺ | Risk⁺ | Time⁺ | Tooling | Enio-fit | Demo-speed | Σ | **Class** |
+|-----------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|---|
+| Signed commits + Rekor + in-toto (baseline) | 4 | 2 | 4 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | **45** | **ADVANCE NOW** |
+| Governance manifest + sha256 + verify CLI | 5 | 2 | 4 | 5 | 4 | 5 | 4 | 5 | 5 | 5 | **44** | **ADVANCE NOW** |
+| OpenTimestamps anchor (Layer A) | 4 | 2 | 4 | 5 | 4 | 4 | 4 | 4 | 4 | 4 | **39** | **PROTOTYPE SMALL** |
+| Proof dashboard (no sensitive data) | 3 | 3 | 5 | 4 | 3 | 4 | 3 | 4 | 4 | 4 | **37** | **PROTOTYPE SMALL** |
+| EAS attestation on Base (Layer B) | 4 | 3 | 3 | 4 | 2 | 2 | 3 | 4 | 2 | 3 | **30** | **RESEARCH MORE** |
+| A↔B interop (OTS+EAS bound) | 5 | 3 | 3 | 4 | 2 | 2 | 2 | 3 | 2 | 2 | **28** | **RESEARCH MORE** |
+| Arweave permanent storage | 3 | 1 | 3 | 4 | 3 | 3 | 4 | 4 | 3 | 3 | **31** | **KEEP AS VISION** |
+| Tradeable token / $ETHIK in governance | 1 | 1 | 1 | 2 | 1 | 1 | 2 | 3 | 1 | 1 | **14** | **DISCARD** |
+| Self-hosted chain explorer | 2 | 1 | 2 | 3 | 2 | 3 | 2 | 3 | 2 | 2 | **22** | **DISCARD** |
+
+⁺ Cost/Complexity/Risk/Time scored *inverted* (5 = cheap/simple/low-risk/fast) so higher Σ = better overall.
+
+---
+
+## 9. The 80/20 recommendation — smallest thing that proves value
+
+**Anchor ONE governance object's hash, and ship a `verify` command anyone can run.**
+
+Concretely: take the **canonical `CAPABILITY_REGISTRY.md` (or constitution/rule-set)** → canonical JSON → `sha256` → (1) commit it signed, (2) push to Rekor (free), (3) OTS-stamp on Bitcoin (free), (4) write the `.ots` + manifest into git. Then a one-command `egos proof verify <file>` reproduces the hash and checks all three.
+
+This proves the entire value proposition — *"this exact rule version provably existed at time T, signed, and independently verifiable on Bitcoin"* — for **R$0 marginal**, zero token, zero wallet, zero Red Zone key custody. It is the honest core; everything else (EAS, dashboard, decision DAG) is incremental on top.
+
+---
+
+## 10. Internal MVPs — prove inside EGOS first
+
+| MVP | Scope | Proof of value | Cost | Verdict |
+|-----|-------|----------------|------|---------|
+| **MVP1 — manifest + hash + OTS + local verify** | sha256 of governance manifest → signed commit + Rekor + OTS stamp; `egos proof verify` CLI reproduces & checks | runnable demo: "verify this rule version yourself" | R$0 | **DO — this is the 80/20** |
+| **MVP2 — decision attestation on Base testnet / local sim** | EAS schema `{ruleHash, decisionHash, parentUID}`; attest a sample decision on **Base Sepolia testnet or local sim** (no mainnet spend) | shows the decision DAG bound to MVP1's rule hash | ~R$0 (testnet) | **PROTOTYPE only after MVP1 lands** |
+| **MVP3 — proof dashboard (no sensitive data)** | public read-only view: proof id, version, timestamp, verify link; pulls from `snapshot.json` pattern + Guard Brasil gate | the "radical transparency" story, demo-able in 3 min | low (reuse status-site) | **PROTOTYPE after MVP1** |
+
+All three reuse existing EGOS infra (`packages/audit`, Guard Brasil, status-snapshot, pre-commit). None requires mainnet spend or a token.
+
+---
+
+## 11. VERDICT — worth Enio's energy NOW?
+
+**Yes — as a small, bounded, no-token "governance provenance" skill + F1 demo + one article. Not as a product. Time-box to a Fibonacci-3 cycle.**
+
+**Reasoning (unbiased):**
+- **For (build it small):** the *work itself* is credibility proof for the F1 forensic track — it unites investigation chain-of-custody + AI governance + crypto-forensics into a clean 3-minute demo ("this rule version + this AI decision, cryptographically anchored, verify it yourself"). EGOS is already ~70% there; the marginal build is small. The 80/20 (MVP1) costs R$0 and carries no Red Zone surface.
+- **Against (don't over-invest):** there is **no paying buyer** for on-chain AI attestation in 2026 (pre-market); the honest marginal gain over free Sigstore/Rekor is **narrow** (only "no trusted operator" + "cross-org distrust"); and over-indexing on "blockchain" *dilutes* the "arquiteto de IA" positioning into Web3 hype.
+- **Guardrails that make it defensible:** (1) build on Sigstore/Rekor/in-toto FIRST (recognized, standard, auditor-friendly); (2) on-chain (OTS, then EAS) is an **optional last layer** for the no-trusted-party case; (3) **no token, ever**; (4) **anchor hashes only**; (5) **Red Zone gate** before any investigation data touches any anchor.
+- **Stop condition:** if MVP1 cannot produce a working demo + article inside the Fibonacci-3 box, **pause and refocus on the forensic-crypto curriculum** — F1 credibility arrives faster from curriculum than from speculative attestation infra.
+
+**One line:** *Yes to a small Sigstore-first, chain-optional, no-token provenance skill (internal dogfood + F1 demo + one article); no to a 2026 product; Red Zone gate on any case data.*
+
+---
+
+## 12. Proposed modular packages (brief)
+
+Mirrors EGOS's existing `packages/` split; each is independently publishable and small.
+
+| Package | Responsibility |
+|---------|----------------|
+| **`egos-proof-core`** | canonical JSON serialization, sha256 hashing, manifest schema (`{id, version, hash, cid, ts, parent}`), Merkle helpers, `verify` orchestration. Extends `packages/audit/versioned-record.ts`. Chain-agnostic. |
+| **`egos-proof-bitcoin`** | OpenTimestamps client (Layer A): stamp a hash via free calendar, store `.ots`, verify against Bitcoin. Thin wrapper over `typescript-opentimestamps`. |
+| **`egos-proof-eas`** | EAS adapter (Layer B): schema registration, offchain + onchain (Base) attestation, `parentAttestationUID` DAG, revocation. Wraps `eas-sdk`. **Deferred until MVP2.** |
+| **`egos-proof-registry`** | binds proofs to the capability/decision registry: adds `attestation_uid` to CBC files; reconciles `CAPABILITY_REGISTRY.md` ↔ anchored hashes. |
+| **`egos-proof-ui`** | public read-only proof dashboard (Layer d): proof id, version, timestamp, verify links. Reuses status-site pattern; Guard Brasil-gated. |
+| **`egos-proof-policy`** | the Red Zone / LGPD guardrail layer: enforces "hash-only, no PII" at the (b)→(c) boundary via `guard-brasil-mcp`; blocks anchoring of investigation/case data; HITL hooks. **Build alongside core, not after.** |
+
+> Build order: `egos-proof-core` + `egos-proof-policy` + `egos-proof-bitcoin` (= MVP1). Then `egos-proof-ui` (MVP3). `egos-proof-eas` + `egos-proof-registry` only on a real external-verifier requirement (MVP2 / RESEARCH MORE).
+
+---
+
+*Sources: 5 EGOS research inputs (2026-06-01) — internal inventory, external/interop, cost, personas/viability, telemetry/KPI. External refs cited inline within those inputs: opentimestamps.org, attest.org/eas-sdk, Base network fees, Sigstore/Rekor v2 GA, SLSA/in-toto, Arweave, Modulos AI governance guide. Interop A↔B pattern marked INFERRED. No implementation performed — research-only.*

codex
The diff only adds and updates planning/handoff/strategy documentation and task tracking entries; it does not introduce executable code changes or observable regressions. I did not find discrete, actionable defects that would break behavior or require urgent correction.
The diff only adds and updates planning/handoff/strategy documentation and task tracking entries; it does not introduce executable code changes or observable regressions. I did not find discrete, actionable defects that would break behavior or require urgent correction.
```
