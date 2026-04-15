---
date: 2026-04-07T01:12:31.611Z
tags: [windsurf-conflict, task-safety, workspace-config, p34-planning]
---

# Investigation: Windsurf Conflict Zone & Safe Task Map (2026-04-07)

## FILE-LEVEL CHANGES DETECTED (not just commits)

### EGOS-LAB — **52 ACTIVE CHANGES** ⚠️
Windsurf is actively editing:
- `.guarani/PREFERENCES.md` (governance)
- `agents/agents/gem-hunter.ts` (core agent code)
- `apps/agent-commander/src/` (orchestrator, executor)
- `apps/eagle-eye/src/lib/shared.ts`
- `apps/egos-inteligencia/` (full nested app, TASKS.md, API routes, frontend)
- `.github/workflows/gem-hunter-daily.yml` (DELETED)

**Risk:** MAXIMUM — do NOT touch egos-lab/* right now.

### Other repos with LOCAL CHANGES:
- **forja:** 2 changes (.guarani/PREFERENCES.md + RULES_INDEX.md)
- **852:** 2 changes (inode issue on .guarani/PREFERENCES.md)
- **santiago:** 2 changes
- **smartbuscas:** 2 changes
- **arch:** 2 changes
- **egos:** 8 changes (.egos-manifest.yaml, .husky/pre-commit, bun.lock, package.json)

**Pattern:** Windsurf is modifying `.guarani/PREFERENCES.md` across ALL repos (inode-tracked via git, not edited).

## SAFE RESEARCH/DOCUMENTATION RESOURCES

### Personal Folder (/home/enio/personal/) — ISOLATED
- `X_POST_5_VERCOES_LOW_PROFILE.md` — 6 versions ready
- `RELATORIO_VALIDACAO_EGOS_2026-04-06.md` — validation report
- `MENSAGEM_VALIDACAO_PARA_IAS.md` — AI validation message

### Downloads (/home/enio/Downloads/) — ARCHIVED
- booking-agent/ (multi-tenant app, complete)
- intelink-project-starter/
- Research docs: conversaaistudio.md, Forja migration docs, etc.

### Obsidian Vault (/home/enio/Obsidian Vault/)
- Exists but not explored yet

### Special repo: egos-lab/egos-autoresearch/
- `autoresearch.ts` (14KB, last modified Mar 31)
- `results.tsv` (evaluation results)
- `program.md` (methodology)
- `README.md` (purpose)

## SAFE PAIR STUDY ZONES

GH-013..017 pair studies are 100% safe because:
1. Zero local files modified in egos repo
2. Research outputs don't commit to repo
3. External repos (OpenHands, LangGraph, etc.) are cloned/read-only
4. Results → HARVEST.md merge later (no conflicts)

## WORKSPACE CONFIGURATION NEEDED

Need access to:
- /home/enio/personal/
- /home/enio/Downloads/
- /home/enio/egos-lab/egos-autoresearch/ (for research context)
- /home/enio/Obsidian Vault/
- /home/enio/commons/
- /home/enio/INPI/
- /home/enio/INTELINK/
- /home/enio/santiago/

These are all safe from Windsurf's current edits.
