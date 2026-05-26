# SSOT_REGISTRY.md — EGOS Cross-Repo Registry

<!-- llmrefs:start -->
## LLM Reference Signature

- **Role:** cross-repo SSOT ownership and freshness contract index
- **Summary:** Defines canonical surfaces (`kernel_canonical`, `leaf_local`, `shared_home`, `conflicted`) and who owns each truth source.
- **Read next:**
  - `TASKS.md` — open resolution tasks
  - `docs/CAPABILITY_REGISTRY.md` — capability adoption matrix
  - `docs/modules/DOCUMENTATION_ARCHITECTURE_MAP.md` — documentation navigation and permanence rules
<!-- llmrefs:end -->

> **VERSION:** 2.3.0 | **UPDATED:** 2026-05-14
> **PURPOSE:** canonical registry for all SSOT surfaces across the EGOS workspace.
> **TASK:** EGOS-083 (created), EGOS-085 (expanded)

## Registry Contract

- `kernel_canonical` — source lives in `egos`; propagates outward via `governance:sync`.
- `leaf_local` — source lives in the repo; must not be overwritten by kernel.
- `shared_home` — synced copy in `~/.egos/` used by leaf repos.
- `conflicted` — two competing canonical claims exist; resolution task is open.
- Every SSOT must declare owner, enforcement point, and freshness rule.

---

## Domain SSOT Table

| Domain | SSOT Location | Owner | Freshness Rule | Last Verified |
|--------|--------------|-------|----------------|---------------|
| Agent definitions (kernel) | `egos/agents/registry/agents.json` (live kernel registry; verify count from file before citing it) | enioxt | Update when agent added/changed; `bun run agent:lint` on commit | 2026-05-14 |
| Agent definitions (lab) | `egos-lab/agents/registry/agents.json` v1.0.0 | enioxt | Lab-local; NOT canonical for kernel — parallel registry | 2026-03-30 |
| Agent runtime (kernel) | `egos/agents/runtime/runner.ts` + `event-bus.ts` | enioxt | FROZEN — no change without explicit approval | 2026-03-30 |
| Agent runtime (lab) | `egos-lab/agents/runtime/runner.ts` | enioxt | Lab-local; must not diverge from kernel contract | 2026-03-30 |
| Shared packages (@egos/shared) | `egos/packages/shared/src/` | enioxt | Update kernel first; `bun run typecheck` required; lab copy DEPRECATED | 2026-03-30 |
| LLM routing | `egos/packages/shared/src/model-router.ts` + `llm-provider.ts` | enioxt | Update `MODEL_CATALOG` + `TaskType` + `.env.example` when adding provider | 2026-03-30 |
| Guard Brasil API | `egos/packages/guard-brasil/src/guard.ts` | enioxt | Update when data sources or scoring logic changes; `guard.test.ts` must pass | 2026-03-30 |
| Guard Brasil server | `egos/apps/api/src/server.ts` + `routes/` | enioxt | Update when adding endpoints; `docker-compose.prod.yml` for runtime | 2026-03-30 |
| Eagle Eye patterns | `egos-lab/apps/eagle-eye/src/` | enioxt | Lab-local; pattern updates require TASKS.md entry | 2026-03-30 |
| Supabase schemas (commons) | `egos/apps/commons/supabase/migrations/` | enioxt | New table = new migration file; RLS always on | 2026-03-30 |
| Supabase schemas (nexus) | `egos-lab/apps/nexus/supabase/` | enioxt | Lab-local; not mirrored to kernel | 2026-03-30 |
| Hetzner Docker configs | `egos/integrations/distribution/whatsapp-runtime/docker-compose.yml` + `egos/apps/api/docker-compose.prod.yml` | enioxt | Update when runtime topology changes; `integration:check` gate | 2026-03-30 |
| GitHub Actions (kernel) | `egos/.github/workflows/` | enioxt | Kernel CI/CD: `ci.yml`, `publish-npm.yml`, `spec-pipeline.yml` | 2026-03-30 |
| GitHub Actions (egos-lab) | `egos-lab/.github/workflows/` | enioxt | Lab-specific: eagle-eye-scan, gem-hunter-daily, ssot-drift-check, scorecard | 2026-03-30 |
| GitHub Actions (br-acc) | `br-acc/.github/workflows/` | enioxt | Leaf-local: bracc-monitor, ci, deploy, publish-release, claude-pr-governor | 2026-03-30 |
| Monetization & partnership strategy | `egos/docs/business/MONETIZATION_SSOT.md` | enioxt | kernel_canonical; update for ecosystem pricing, partner model, role maps, and founder/partner decisions | 2026-04-06 |
| Governance rules (.guarani) | `egos/.guarani/` | enioxt | kernel_canonical; propagate via `scripts/governance-sync.sh --exec` | 2026-03-30 |
| Governance rules (~/.egos) | `~/.egos/guarani/` | enioxt | shared_home; synced from kernel via `governance:sync:exec` | 2026-03-30 |
| Brand / visual identity | `egos-lab/branding/BRAND_GUIDE.md` (Cyan/Purple/Green, Space Grotesk) | enioxt | CONFLICTED — see EGOS-132 | 2026-03-30 |
| Brand / visual identity (alt) | `egos/docs/KERNEL_MISSION_CONTROL.md` (color refs) | enioxt | CONFLICTED — see EGOS-132 | 2026-03-30 |
| Telemetry schema | `egos/docs/TELEMETRY_SSOT.md` | enioxt | Update when telemetry fields change; consumers must implement | 2026-03-30 |
| Telemetry runtime | `egos/packages/shared/src/telemetry.ts` | enioxt | Implements TELEMETRY_SSOT.md contract; dual output (Supabase + JSON logs) | 2026-03-30 |
| WhatsApp integration | `egos/docs/knowledge/WHATSAPP_SSOT.md` | enioxt | kernel_canonical; validated 2026-03-30 with forja-notifications | 2026-03-30 |
| Integration release gate | `egos/integrations/manifests/` | enioxt | Update when new integration surface is added; `bun run integration:check` (INTEGRATION_RELEASE_CONTRACT.md archived) | 2026-04-18 |
| Integration manifests | `egos/integrations/manifests/` | enioxt | New bundle = new manifest; validated via `integration:check` | 2026-03-30 |
| BRACC Neo4j boundary | `br-acc/` + `docs/ECOSYSTEM_CLASSIFICATION_REGISTRY.md` | enioxt | leaf_local; BRACC remains standalone OSINT and must not be merged into kernel Mycelium/reference-graph surfaces | 2026-04-06 |
| Intelink (SSOT canônico) | `/home/enio/intelink/` (github.com/enioxt/intelink) | enioxt | leaf_local; repo privado, Next.js 15 + Neo4j 5 + Supabase. **DECISÃO 2026-04-18**: canônico é `/home/enio/intelink`. `egos-inteligencia` = LEGACY/ARCHIVED. | 2026-05-01 |
| Capability registry | `egos/docs/CAPABILITY_REGISTRY.md` | enioxt | kernel_canonical; update when capability added or removed | 2026-03-30 |
| System map (kernel) | `egos/docs/SYSTEM_MAP.md` | enioxt | kernel_canonical; update when architecture changes; LLM activation map | 2026-03-30 |
| SSOT Registry | `egos/docs/modules/SSOT_REGISTRY.md` (this file) | enioxt | kernel_canonical; update when SSOT added/changed/resolved | 2026-05-14 |
| ATRiAN ethics engine | `egos/packages/shared/src/atrian.ts` | enioxt | kernel_canonical; 7 axioms locked; update only for axiom expansion | 2026-03-30 |
| PII scanner | `egos/packages/shared/src/pii-scanner.ts` | enioxt | kernel_canonical; update when new PII patterns added (CPF, CNPJ, etc.) | 2026-03-30 |
| MCP governance | `egos/packages/mcp-governance/src/` | enioxt | kernel_canonical; governs MCP server contracts | 2026-03-30 |
| Mycelium graph | `egos/packages/shared/src/mycelium/reference-graph.ts` | enioxt | kernel_canonical; 27 nodes / 32 edges; update via mycelium workflow | 2026-03-30 |
| PRI protocol | `egos/apps/api/src/pri.ts` | enioxt | leaf_local; untracked file — needs registration in agents.json | 2026-03-30 |

---

## Conflicted Surfaces (Resolution Pending)

| Surface | Conflict | Resolution Task |
|---------|----------|----------------|
| Brand / visual identity | `egos-lab/branding/BRAND_GUIDE.md` (Cyan/Purple/Green, Space Grotesk) vs kernel color refs (different palette) | EGOS-132 |

---

## Required Local SSOTs per Repo

| Surface | Class | Required In | Notes |
|---------|-------|-------------|-------|
| `AGENTS.md` | `leaf_local` | every repo | identity, runtime, commands |
| `TASKS.md` | `leaf_local` | every repo | execution SSOT |
| `.windsurfrules` | `leaf_local` | every repo | repo-local governance |
| `docs/SYSTEM_MAP.md` or local equivalent | `leaf_local` | every repo | human + machine map |
| `docs/knowledge/HARVEST.md` | `leaf_local` | repos that keep knowledge docs | local learnings |

---

## Per-Repo SSOT Adoption Status

> Verificado 2026-05-14 — adoption status maintained here; treat repo counts as live data, not permanent prose.

| Repo | AGENTS.md | TASKS.md | README v+status | Status |
|------|-----------|----------|-----------------|--------|
| `egos` | ✅ | ✅ | ✅ v1.5.0 PROD | Full SSOT — kernel canônico |
| `intelink` | ✅ | ✅ | ✅ v2.0.0 PROD | Full SSOT — privado PCMG |
| `852` | ✅ | ✅ | ✅ v1.3.0 BETA | Partial — SSOT pointer ausente |
| `carteira-livre` | ✅ | ✅ | ✅ v2.0.0 PROD | Partial — SSOT pointer ausente |
| `policia` | ✅ | ✅ | ✅ v0.2.0 BETA | Partial — privado PCMG |
| `egos-lab` | ✅ | ✅ | ✅ v0.5.0 PAUSA | Partial — runtime migrado ao kernel |
| `br-acc` | ✅ | ✅ | ✅ v0.8.0 PAUSA | Partial — SSOT pointer ausente |
| `forja` | ✅ | ✅ | ✅ v0.3.0 PAUSA | Partial — SSOT pointer ausente |
| `arch` | ✅ | ✅ | ✅ v0.2.0 PAUSA | Partial — SSOT pointer ausente |

**Status values:** Full SSOT · Partial SSOT · Missing pointer · No governance · Unverified

---

## Workspace Adoption Rollout

### Completed (2026-05-01)

- [x] `egos` — kernel SSOT_REGISTRY + CAPABILITY_REGISTRY canonical
- [x] `egos` — README cross-reference v1.5.0
- [x] `intelink` — README cross-reference v2.0.0 + UPSTREAM_KERNEL.md
- [x] `852` — README cross-reference v1.3.0
- [x] `carteira-livre` — README cross-reference v2.0.0
- [x] `policia` — README cross-reference v0.2.0
- [x] `egos-lab` — README cross-reference v0.5.0
- [x] `br-acc` — README cross-reference v0.8.0
- [x] `forja` — README cross-reference v0.3.0
- [x] `arch` — README cross-reference v0.2.0

### Next Wave

- [ ] Adicionar seção `## Upstream SSOT` em AGENTS.md de cada leaf repo apontando para este arquivo
- [ ] `DOC-CLEAN-007`: resolver broken refs detectados pelo cross-ref checker atual

---

## Freshness Rules

1. New global governance surface: update this file + `docs/CAPABILITY_REGISTRY.md` + `docs/SYSTEM_MAP.md` in `egos`.
2. New repo-local capability: update local `AGENTS.md`, local `TASKS.md`, and local system map.
3. Any staged change to a `kernel_canonical` SSOT must pass `bun run governance:check`.
4. Any staged change to a repo-local SSOT must pass local doc freshness checks.
5. When a `conflicted` surface is resolved: update this table, mark EGOS task [x], run `governance:sync:exec`.

## Update Flow

1. Edit kernel canonical SSOT in `egos`.
2. Run `bun run governance:sync:exec`.
3. Run `bun run governance:check`.
4. Update affected leaf `TASKS.md` and system maps.
5. Record learnings in `docs/knowledge/HARVEST.md` and `/disseminate`.

---

## SSOT Visit Log (this session)

- [x] SSOT-VISIT 2026-03-30: `egos-lab/TASKS.md` lines 50-70 → LAB-ARCHIVE tasks read → kept-as-ref
- [x] SSOT-VISIT 2026-03-30: `egos-lab/apps/` → all 11 apps inventoried → classified in KERNEL_CONSOLIDATION_PLAN.md
- [x] SSOT-VISIT 2026-03-30: `egos-lab/packages/` → 4 packages inventoried → shared deprecated, nexus-shared independent
- [x] SSOT-VISIT 2026-03-30: `egos-lab/packages/shared/src/` → duplicate of kernel @egos/shared confirmed → superseded
- [x] SSOT-VISIT 2026-03-30: `egos-lab/agents/registry/agents.json` → v1.0.0 lab registry → independent (lab-local)
- [x] SSOT-VISIT 2026-03-30: `egos-lab/agents/agents/` → 24 agents inventoried → classified in Phase 2-C
- [x] SSOT-VISIT 2026-03-30: `egos/docs/strategy/EGOS_LAB_CONSOLIDATION_DIAGNOSTIC.md` → EGOS-073 output → gem-found (grounds this plan)
- [x] SSOT-VISIT 2026-03-30: `br-acc/docs/` → no SSOT_REGISTRY → stale-confirmed (grade C)
- [x] SSOT-VISIT 2026-03-30: `852/docs/` → no SSOT_REGISTRY → stale-confirmed (grade C)
- [x] SSOT-VISIT 2026-03-30: `carteira-livre/docs/` → no SSOT_REGISTRY → stale-confirmed (grade C)
- [x] SSOT-VISIT 2026-03-30: `commons/` → no AGENTS.md, no SSOT → stale-confirmed (grade D)
- [x] SSOT-VISIT 2026-03-30: `egos/docs/TELEMETRY_SSOT.md` → exists → confirmed canonical
- [x] SSOT-VISIT 2026-03-30: `egos-lab/branding/BRAND_GUIDE.md` → brand guide exists (Cyan/Purple/Green) → conflicted (EGOS-132)
- [x] SSOT-VISIT 2026-04-06: `docs/ECOSYSTEM_CLASSIFICATION_REGISTRY.md` + `docs/SSOT_REGISTRY.md` → BRACC boundary restated as standalone OSINT, not kernel Mycelium
