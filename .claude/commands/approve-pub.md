---
name: approve-pub
description: Approve a queued PUBLISH and trigger article-writer
type: skill
---

# /approve-pub — Approve Queued Publication

Approves a queued PUBLISH: item and triggers article-writer.

Usage:
- `/approve-pub` — list all pending publications
- `/approve-pub <hash>` — approve specific commit hash

## How it works

1. Read `/tmp/egos-publish-pending.json` for queued items
2. If hash provided, run `bun agents/agents/article-writer.ts --hash <hash> --topic <topic>`
3. Remove approved item from queue
4. Confirm to user

## Manual equivalent

```bash
# List pending
cat /tmp/egos-publish-pending.json 2>/dev/null || echo "No pending publications"

# Approve specific
bun agents/agents/article-writer.ts --hash <hash> --topic "<topic>"
```