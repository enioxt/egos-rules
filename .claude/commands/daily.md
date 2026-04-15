---
description: Create today's daily note with P0 tasks, VPS health, and pending gems
---

Create today's daily note at `~/.egos/vault/daily/YYYY-MM-DD.md`.

Steps:
1. Check if today's note already exists — if so, just open/show it.
2. Read TASKS.md: extract all `- [ ] **[A-Z]+-[0-9]+ [P0]**` entries (P0 tasks only).
3. Run `curl -s https://hq.egos.ia.br/api/health 2>/dev/null || echo "HQ unreachable"` to get VPS health.
4. Create `~/.egos/vault/daily/<today>.md`:

```markdown
# Daily — <YYYY-MM-DD>

## P0 Tasks

<list of P0 pending tasks from TASKS.md, max 10>

## VPS Health

<result from health check, one line>

## Focus

- [ ] Morning priority 1:
- [ ] Morning priority 2:

## Notes

[Add your notes here]

## Done Today

[Track what you actually shipped]
```

5. Report the file path.
