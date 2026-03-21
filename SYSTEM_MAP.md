# EGOS System Map — Shared Governance Home

> **Version:** 2.0.0 | **Updated:** 2026-03-13
> **Purpose:** global topological truth for the shared governance home at `~/.egos`

---

## What `~/.egos` Is

`~/.egos` is the cross-repo governance root.
It is not the product itself; it is the **mycelial root** that keeps truth synchronized across repos.

---

## Canonical Truth Chain

| Layer | SSOT | Purpose |
|------|------|---------|
| **Global topology** | `~/.egos/SYSTEM_MAP.md` | Cross-repo topology and sync policy |
| **Operational workspace** | `/home/enio/egos-lab/docs/EGOS_WORKSPACE_MAP.md` | Real loaded roots + adjacent active nodes |
| **Conceptual architecture** | `/home/enio/egos-lab/docs/EGOS_ECOSYSTEM_MAP.md` | Kernel, leaves, merge strategy |
| **Reference mesh** | `/home/enio/egos-lab/docs/research/MYCELIUM_REFERENCE_GRAPH_DESIGN_2026-03-07.md` | Mycelial reference/citation model |
| **Local project truth** | each repo `AGENTS.md` + `TASKS.md` + `.windsurfrules` | Domain truth and active work |

**Rule:** never create a parallel system/workspace/reference map without updating the canonical truth chain.

---

## Active Roots

| Root | Path | Sync Mode | Notes |
|------|------|-----------|-------|
| **egos** | `/home/enio/egos` | auto-sync | Framework core (governance + runtime + shared) |
| **egos-lab** | `/home/enio/egos-lab` | auto-sync | Lab/incubator (apps, agent implementations, experiments) |
| **852** | `/home/enio/852` | auto-sync | Institutional intelligence chatbot (852.egos.ia.br) |
| **carteira-livre** | `/home/enio/carteira-livre` | auto-sync | Production SaaS |
| **br-acc** | `/home/enio/br-acc` | auto-sync | Public-data intelligence graph |
| **forja** | `/home/enio/forja` | auto-sync | Private ERP in planning |
| **egos-self** | `/home/enio/egos-self` | auto-sync | Personal intelligence CLI/device channel |
| **policia** | `/home/enio/policia` | mapped only | Sensitive/private workflow silo |
| **personal** | `/home/enio/personal` | mapped only | Non-code/public identity artifacts |

---

## Adjacent Nodes

| Node | Path | Notes |
|------|------|-------|
| **Shared Governance Home** | `/home/enio/.egos` | This repo-less root |
| **Intelink** | `/home/enio/egos-lab/apps/intelink` | Specialized intelligence surface inside `egos-lab` |
| **egos-self snapshot** | `/home/enio/egos-lab/apps/egos-self` | Historical/internal monorepo surface |
| **Unified workspace file** | `/home/enio/egos-unified.code-workspace` | IDE-level loaded roots |

---

## Orchestrator Stack

### Layer 0 — Shared Governance Home

- `~/.egos`
- central preferences
- sync script
- topological memory

### Layer 1 — Canonical Kernel

Lives in `/home/enio/egos` (framework core):

- `.guarani/orchestration/*`
- `agents/runtime/*`
- `agents/registry/agents.json`
- `packages/shared/src/*`

Incubator in `/home/enio/egos-lab` (apps + agent implementations)

### Layer 2 — Domain Leaves

- `br-acc`
- `carteira-livre`
- `forja`
- `policia`
- `egos-self`
- `intelink`

### Layer 3 — Human/Public Surfaces

- GitHub repos/issues/PRs
- public apps
- bots
- reports
- personal artifacts

### Layer 4 — Infra Spine

- Vercel
- Railway
- Supabase
- Neo4j
- Redis
- GitHub

---

## Sync Policy

### Auto-Synced Standard Code Repos

- `/home/enio/egos`
- `/home/enio/egos-lab`
- `/home/enio/852`
- `/home/enio/carteira-livre`
- `/home/enio/br-acc`
- `/home/enio/forja`
- `/home/enio/egos-self`

### Mapped But Not Auto-Synced

- `/home/enio/policia` — sensitive/private; local rules dominate
- `/home/enio/personal` — non-code surface; mapping only

---

## Rule Precedence

1. `~/.egos/*`
2. repo-local `.windsurfrules`
3. repo-local `.guarani/*`
4. repo `AGENTS.md` + `TASKS.md`
5. feature/domain docs

Local domain rules may tighten shared rules, but should not silently replace the global topology.

---

## Quick Commands

```bash
~/.egos/sync.sh
python3 ~/egos-lab/scripts/sync-governance.sh --dry-run
python3 ~/egos-lab/scripts/sync-governance.sh
```

---

## Source Of Truth Reminder

If a new repo, app, agent surface, or adjacent root appears:

1. update this file
2. update `docs/EGOS_WORKSPACE_MAP.md`
3. update `TASKS.md`
4. only then describe the new topology elsewhere
