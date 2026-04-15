# /end — Session Finalization (EGOS v5.5)

> Sacred Code: 000.111.369.963.1618

Finalize session. Create handoff, update docs, commit if needed.

## Phase 1: Collect Data
```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
echo "Repo: $(basename $ROOT)"
echo "Last commit: $(git log --oneline -1 2>/dev/null)"
echo "Uncommitted: $(git status --short 2>/dev/null | wc -l) files"
echo "Session commits: $(git log --oneline --since='6 hours ago' 2>/dev/null | wc -l)"
```

> **Tool Result Budget (LEAK-006):** If any tool returned >20K chars this session,
> write it to `docs/jobs/YYYY-MM-DD-[topic].md` instead of embedding in handoff.
> Keep handoff under 4K total. Never paste raw API responses into memory.

## Phase 2: Generate Handoff
Create `docs/_current_handoffs/handoff_YYYY-MM-DD.md` with:
- **Accomplished** — bullet list with file links
- **In Progress** — % completion
- **Blocked** — reason + action needed
- **Next Steps** — ordered by priority
- **Environment State** — builds/tests status

## Phase 3: Update TASKS.md
- Mark completed tasks `[x]`
- Mark in-progress `[/]`
- Add newly discovered tasks

## Phase 4: Documentation Check (BLOCKING)
Cannot finalize if:
- Code changed in `src/` AND `SYSTEM_MAP.md` not updated
- New capability AND `AGENTS.md` not updated
- `TASKS.md` not current

## Phase 5: Record Learnings + Disseminate Knowledge

Record session learnings to the Knowledge System (what worked, what failed, insights):
```bash
# Gateway endpoint: https://gateway.egos.ia.br/knowledge/learnings (or http://localhost:3050)
# Domain: general|architecture|deployment|monetization|governance|agents|security|dx
# Outcome: success|failure|insight
GW="https://gateway.egos.ia.br"
# Record each significant learning (call once per learning):
curl -s -X POST "$GW/knowledge/learnings" \
  -H "Content-Type: application/json" \
  -d '{"domain":"<domain>","outcome":"<outcome>","description":"<what you learned>","session_id":"'$(date +%Y%m%d)'"}'

# Verify it was saved:
curl -s "$GW/knowledge/learnings?limit=3" | python3 -c "import sys,json; [print(l['domain'],l['outcome'],l['description'][:60]) for l in json.load(sys.stdin).get('learnings',[])]"
```

Also compile any new raw sources into wiki (cross-repo, all 7 repos):
```bash
# Run from egos kernel — compiles egos + egos-inteligencia + 852 + forja + carteira-livre + br-acc + policia
cd /home/enio/egos && bun agents/agents/wiki-compiler.ts --compile 2>/dev/null || echo "wiki:compile not available"
# Then sync Obsidian vault
bun obsidian:sync 2>/dev/null || echo "obsidian:sync not available"
# Show metrics (count by repo)
bun agents/agents/wiki-compiler.ts --index 2>/dev/null | head -20
```

- Save key patterns to memory
- Update HARVEST.md with learnings
- Update CAPABILITY_REGISTRY.md if new capabilities
- **Gem Hunter:** Se uma sessão `/study` esteve ativa, verificar que `/study-end` foi executado (9 seções). Registrar em `egos/docs/gem-hunter/sessions/`. SSOT: `egos/docs/gem-hunter/SSOT.md`

## Phase 6: Commit If Needed
```bash
git status --short | wc -l
# If > 0: prompt to commit
```

## Phase 7: Session Summary Output

> **Structured Memory (LEAK-007):** Write to `~/.claude/projects/*/memory/` using fixed
> sections with ~2K chars/section max. Use the format below. Never mix sections.

```
SESSION SUMMARY
===============
Repo: [name]
Commits: [N] this session
Security: [Clean]
Files changed: [list top 5]
Context Tracker: [value/280]
Signed by: claude-code — [ISO8601]
```

**Memory sections to write** (2K cap each):
1. `session_YYYY-MM-DD_[topic].md` — type:project — What changed, blockers, decisions
2. Update relevant `feedback_*.md` if behavior guidance confirmed or corrected
3. Do NOT write ephemeral state (in-progress files, temp vars, current context)
