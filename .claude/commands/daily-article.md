---
description: Publish daily bilingual article (PT-BR + EN) to egos.ia.br/timeline. Use when session had feat: commits. Generates draft from commits + learnings, requires HITL approval before going live. Skip on zero-commit or infra-only sessions.
---

# /daily-article — Daily Bilingual Article (EGOS v1.0)

> Direction pivot (2026-04-16): Open source sharing, not SaaS marketing.
> Revenue comes from consulting when people ask for implementation help.

Publish 1 article per working day in EN + PT-BR to egos.ia.br/timeline.
Share what was built, problem it solves, who it's for, code. Zero pitch.

---

## Phase 1: Session Review

```bash
echo "=== Commits this session ==="
git log --oneline --since='8 hours ago' 2>/dev/null

echo ""
echo "=== Files changed ==="
git log --since='8 hours ago' --name-only --pretty=format: 2>/dev/null | sort -u | grep -v '^$' | head -20
```

**Answer before proceeding:**
1. Which commit/change represents the most teachable advance today?
2. What problem did it solve (concrete, not abstract)?
3. Who would actually use this (persona/role)?
4. Is there reproducible code/config to show?
5. What didn't work — what's the honest caveat?

If answer to any of 1–4 is "nothing substantial" → skip today. Note in handoff.

---

## Phase 2: Gem Hunter Context

```bash
bun agents/agents/gem-hunter.ts --query "<topic>" --dry 2>/dev/null | tail -20
```

If similar projects exist:
- Credit them
- Contrast honestly (what's different about this approach, not "better")
- Link to their work

**Never:** claim "unique", "first in Brazil", "better than X".

---

## Phase 3: Draft Bilingual Article

```bash
# PT-BR draft
bun agents/agents/article-writer.ts --topic "<topic>" --lang pt-br --dry

# EN draft
bun agents/agents/article-writer.ts --topic "<topic>" --lang en --dry
```

**Structure (both languages):**
1. **What I built** (1 paragraph — concrete)
2. **Why** (problem in plain language, not marketing)
3. **How it works** (code/config snippet, reproducible)
4. **Who would use this** (honest persona)
5. **What didn't work** (caveats, open questions)
6. **Code** (link to MIT repo)
7. **Want help implementing this?** (DM open for consulting — one line, not CTA)

**Tom rules (guardrail):**
- Zero pitch. Zero "contrate".
- Zero claims of uniqueness or superiority.
- First-person, honest, technical.
- Code must run. If can't run → don't publish.

---

## Phase 4: Guard Brasil PII Check

```bash
# Guard Brasil scan before draft enters Supabase
# Auto-triggered by article-writer.ts pipeline
```

Block publish if PII detected in draft.

---

## Phase 5: Publish

1. Human approval in Supabase `timeline_drafts` table
2. Article goes live at egos.ia.br/timeline
3. X.com thread (≤3 tweets) with article link + 1 key learning
4. No other distribution (no email blast, no LinkedIn auto-post)

---

## Phase 6: Record

```bash
# Update docs/knowledge/HARVEST.md with article reference
# Update docs/GTM_SSOT.md §1 status counter (articles published +1)
```

---

*Version: 1.0.1 — 2026-04-16*
*SSOT rules: [docs/social/ARTICLE_VOICE.md](../../docs/social/ARTICLE_VOICE.md) (voice, structure, footer, interconnection), docs/social/X_POSTS_SSOT.md v3.0, docs/GTM_SSOT.md v2.0*

**Antes de escrever:** ler `docs/social/ARTICLE_VOICE.md` §1 (voz) + §2 (estrutura) + §4 (interconexão).