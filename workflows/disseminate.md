---
description: disseminate workflow
---
# /disseminate — Knowledge Dissemination (v5.5 SecOps Edition)

> **Works in:** ANY EGOS repo
> **When to Use:** After implementing a feature, fixing a bug, making an architectural decision, **mitigating a CVE**, or completing a milestone.
> **Repo-role:** Check `egos.config.json` for `role` and `surfaces`. If absent, assume `leaf` and skip surfaces like gem-hunter, report-generator, session:guard, and activation:check.

---

## 0. SSOT Visit Audit (Run First)

Before disseminating, check for unlogged visits made this session.

**Triggers to check** (per DOMAIN_RULES.md §7):
- Any file read outside the current repo
- Any file in `archive/`, `docs/`, `legacy/`, `old/`, `_current_handoffs/`
- Any file discovered via search/grep (not directly navigated)
- Any file >2 directory levels from working root not in TASKS.md/AGENTS.md/SYSTEM_MAP.md

**Action:** For each unlogged visit found, add to the nearest `TASKS.md` before proceeding:
```
- [x] SSOT-VISIT [date]: [path-or-repo/path] → read [what] → [disposition]
```

**Block dissemination if any unlogged visit is found and not yet resolved.**

---

## 1. Identify New Knowledge

What was created or changed?

- **Infrastructure**: Docker, caching, ETL, deployment?
- **Feature**: New component, API endpoint, agent?
- **Architecture**: Design pattern, data flow, integration?
- **Bug fix**: Root cause, prevention mechanism?
- **Governance**: Security policy, workflow, meta-prompt?
- **[NEW] SecOps**: Patched a CVE? What was the mitigation strategy?

## 2. Save to Cascade Memory

```ts
create_memory({
  Title: "Session — [description]",
  Content: "Detailed markdown with files, decisions, gotchas. If SecOps related, list the CVE ID and the applied fix.",
  CorpusNames: ["enioxt/REPO_NAME"],
  Tags: ["relevant", "tags", "secops", "cve"],
  Action: "create"
})
```

## 3. Check Meta-Prompt Triggers

```text
Read .guarani/prompts/triggers.json
- Did any trigger apply this session?
- Should a new trigger be added?
- Was a meta-prompt useful? Document the outcome.
```

## 4. Update Documentation

- `docs/knowledge/HARVEST.md` — Add patterns, gotchas, learnings. **(Mandatory for CVE Mitigations)**
- `TASKS.md` — Mark completed, add discovered tasks
- `.guarani/` — If architecture decisions were made
- Record Codex usage: availability, mode used (`review`, `read-only`, `cloud`), suggestions applied/rejected
- Record Alibaba orchestration status and whether the repo's readiness surface (`session:guard` when present, otherwise local activation checks) was updated
- If mesh, agents, workflows, or event-bus reality changed, include a `/mycelium` snapshot with maturity, connected systems, and drift notes

## 5. Post on Social Channels (if milestone or CVE patched)

Use `/postar` workflow for unified posting:

- **Telegram** (@ethikin): Full markdown, up to 4096 chars (Alert Mycelium network if critical CVE patched)
- **Discord**: Markdown, up to 2000 chars
- **X.com** (@anoineim): 280 chars max + link

## 6. Update Bot/AI System Prompts (if applicable)

If new data sources, tools, or capabilities were added, update relevant system prompts.

## 7. Update Capability Registry (if applicable)

If a new capability was created, improved, or adopted:

- Update `egos/docs/CAPABILITY_REGISTRY.md` — add/modify capability entry with SSOT ref, quality rating, adoption status
- If chatbot-related, verify compliance with `egos/docs/modules/CHATBOT_SSOT.md`
- If a module was ported to `packages/shared/`, update the SSOT column in the registry

---

## SSOT Visit Summary

Include this section in every disseminate output:

```
SSOT VISIT SUMMARY
==================
Repos/files visited this session:
- [path] → [disposition tag]
- [path] → [disposition tag]

Intra-repo gems (archive/, docs/, legacy/ checked):
- [file] → [gem-found / stale-confirmed / kept-as-ref]

Unlogged visits found: [N] — all resolved before disseminate: [yes/no]
```

Disposition tags: `archived` | `merged` | `kept-as-ref` | `superseded` | `independent` | `gem-found` | `stale-confirmed`

---

## Checklist

- [ ] SSOT Visit Audit completed (Step 0 — all unlogged visits resolved)
- [ ] SSOT Visit Summary written above
- [ ] Intra-repo gems checked (archive/, docs/, legacy/ scanned)
- [ ] Cascade Memory updated (create_memory)
- [ ] Meta-prompt triggers reviewed
- [ ] Codex usage recorded (or explicit reason why not used)
- [ ] TASKS.md updated
- [ ] Documentation updated (HARVEST.md, .guarani/)
- [ ] Capability Registry updated (if new capability created/adopted)
- [ ] Social channels posted (if milestone or CVE patched)
