# 🌐 EGOS Shared Governance Framework

> **Canonical Source:** `/home/enio/egos/scripts/egos-home/`
> **Mirror Location:** `/home/enio/.egos/`
> **Purpose:** Versioned kernel source mirrored into `~/.egos/` for cross-repo rules, workflows, hooks, and adapters
> **Version:** 1.1.1 | **Updated:** 2026-04-23

---

## Architecture

```
kernel egos/.guarani/ + scripts/egos-home/  ← CANONICAL GOVERNANCE SOURCE
                          ↓ governance-sync.sh
~/.egos/                                  ← SHARED MIRROR / DISTRIBUTION LAYER
├── README.md                      ← This file
├── guarani/
│   ├── IDENTITY.md                ← Shared agent identity
│   ├── PREFERENCES.md             ← Cross-repo coding standards
│   └── RULES_INDEX.md             ← Canonical rule lookup
├── skills/
│   └── */SKILL.md                 ← Shared agent skills
├── workflows/
│   └── *.md                       ← Shared agent workflows
└── sync.sh                        ← Auto-sync to all repos

Repos that consume:
├── /home/enio/egos-lab/           ← symlinked .egos → ~/.egos
├── /home/enio/carteira-livre/     ← symlinked .egos → ~/.egos
└── (any future repo)              ← symlinked .egos → ~/.egos
```

## How It Works

1. **Canonical rules** live in `kernel/.guarani/`
2. **Canonical shared-home assets** live in `kernel/scripts/egos-home/`
3. **Each repo** has a symlink: `.egos → ~/.egos`
4. **`scripts/governance-sync.sh`** mirrors kernel governance into `~/.egos/`
5. **`~/.egos/sync.sh`** propagates workflows, hooks, and selected governance surfaces
6. **Agents read** `.guarani/` as canon and treat adapter files as environment-specific views

## Rule Precedence

```
1. Kernel `.guarani/` canon   ← HIGHEST
2. Shared `~/.egos/` mirror   ← synced distribution layer
3. `CLAUDE.md` / `.windsurfrules` ← adapter surfaces only
```

## Operational Checks

```bash
cd /home/enio/egos
bun run governance:check
bun run governance:runtime:smoke
bun run governance:runtime:report
bun run claude:telemetry
```

## Adding a New Repo

```bash
# In any new repo:
ln -sf ~/.egos .egos
echo ".egos" >> .gitignore  # Don't commit the symlink
```

## Editing Shared Rules

1. Edit canonical files in `/home/enio/egos/.guarani/` or `/home/enio/egos/scripts/egos-home/`
2. Run `bun run governance:sync:local` to refresh `~/.egos/`; use `bun run governance:sync:exec` only when leaf propagation is intended
3. Run `bun run governance:check` to verify kernel → `~/.egos` drift = 0
4. Run `bun run governance:runtime:smoke` to validate kernel → `~/.egos` → `~/.claude` → leaf wiring read-only
5. Run `bun run governance:runtime:report` to inspect the operator summary and local hook telemetry
