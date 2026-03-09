# 🌐 EGOS Shared Governance Framework

> **Location:** `/home/enio/.egos/`
> **Purpose:** Single source of truth for cross-repo rules, preferences, and agent memory
> **Version:** 1.0.0 | **Updated:** 2026-02-13

---

## Architecture

```
~/.egos/                           ← CENTRAL SOURCE OF TRUTH
├── README.md                      ← This file
├── guarani/
│   ├── IDENTITY.md                ← Shared agent identity
│   ├── PREFERENCES_SHARED.md      ← Cross-repo coding standards
│   └── SACRED_CODE.md             ← Sacred Code + core values
├── skills/
│   └── *.md                       ← Shared agent skills
├── workflows/
│   └── *.md                       ← Shared agent workflows
└── sync.sh                        ← Auto-sync to all repos

Repos that consume:
├── /home/enio/egos-lab/           ← symlinked .egos → ~/.egos
├── /home/enio/carteira-livre/     ← symlinked .egos → ~/.egos
└── (any future repo)              ← symlinked .egos → ~/.egos
```

## How It Works

1. **Central rules** live here in `~/.egos/`
2. **Each repo** has a symlink: `.egos → ~/.egos`
3. **Local overrides** live in each repo's `.guarani/` (NOT symlinked)
4. **sync.sh** propagates critical updates and validates consistency
5. **Agents read** both `.egos/` (shared) and `.guarani/` (local)

## Rule Precedence

```
1. Local .guarani/ rules     ← HIGHEST (repo-specific overrides)
2. Shared .egos/ rules       ← MEDIUM  (cross-repo standards)
3. .windsurfrules             ← AGENT-LEVEL (agent-specific behavior)
```

## Adding a New Repo

```bash
# In any new repo:
ln -sf ~/.egos .egos
echo ".egos" >> .gitignore  # Don't commit the symlink
```

## Editing Shared Rules

1. Edit files in `~/.egos/guarani/`
2. Run `~/.egos/sync.sh` to validate and propagate
3. All repos automatically see the changes (via symlink)
