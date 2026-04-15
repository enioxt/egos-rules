# 🌐 EGOS Shared Governance Framework

> **Location:** `/home/enio/.egos/`
> **Purpose:** Synced governance mirror for cross-repo rules, workflows, hooks, and adapters
> **Version:** 1.1.0 | **Updated:** 2026-04-06

---

## Architecture

```
kernel egos/.guarani/              ← CANONICAL GOVERNANCE SOURCE
        ↓ governance-sync.sh
~/.egos/                           ← SHARED MIRROR / DISTRIBUTION LAYER
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
2. **Each repo** has a symlink: `.egos → ~/.egos`
3. **`scripts/governance-sync.sh`** mirrors kernel governance into `~/.egos/`
4. **`~/.egos/sync.sh`** propagates workflows, hooks, and selected governance surfaces
5. **Agents read** `.guarani/` as canon and treat adapter files as environment-specific views

## Rule Precedence

```
1. Kernel `.guarani/` canon   ← HIGHEST
2. Shared `~/.egos/` mirror   ← synced distribution layer
3. `CLAUDE.md` / `.windsurfrules` ← adapter surfaces only
```

## Adding a New Repo

```bash
# In any new repo:
ln -sf ~/.egos .egos
echo ".egos" >> .gitignore  # Don't commit the symlink
```

## Editing Shared Rules

1. Edit canonical files in `/home/enio/egos/.guarani/` or other kernel SSOT surfaces
2. Run `bun run governance:sync:exec` from the kernel
3. Run `bun run governance:check` to verify mirror drift = 0
4. Use `~/.egos/sync.sh` only as the distribution step to repos/IDEs
