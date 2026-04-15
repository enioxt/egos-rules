---
description: Initialize a structured knowledge note in the EGOS vault for a new topic
---

Create a new knowledge note in `~/.egos/vault/active/` for the topic provided in $ARGUMENTS.

Steps:
1. Derive filename: today's date + slug of the topic. Example: `2026-04-09-guard-brasil-pii.md`
2. Create `~/.egos/vault/active/<filename>.md` with this structure:

```markdown
# <Topic Title>

**Created:** <today>  
**Tags:** #egos #<topic-slug>  
**Status:** active

## Summary

[2-3 sentence overview of what this note covers]

## Key Concepts

- 

## Links

- Related specs: [[SPEC-<RELEVANT>]]
- Related tasks: <TASK-IDs>
- HARVEST reference: docs/knowledge/HARVEST.md

## Notes

[Working notes, observations, open questions]

## Sources

- 
```

3. Report the file path created.

If $ARGUMENTS is empty, ask what topic to document.
