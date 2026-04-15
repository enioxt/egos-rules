---
description: Read a SPEC-*.md and produce a numbered task breakdown with TASKS.md IDs and time estimates
---

Analyze the spec for `$ARGUMENTS` and produce an implementation plan.

Steps:
1. Resolve the spec file:
   - If `$ARGUMENTS` ends with `.md`, treat it as a path directly.
   - Otherwise, search for `docs/specs/SPEC-<ARGUMENTS-UPPER>.md`. If not found, glob `docs/specs/SPEC-*$ARGUMENTS*.md` and take the first match.
2. Read the resolved spec file.
3. Extract: Goals, API Contract section, and Acceptance Criteria items.
4. For each logical unit of work (group related ACs and contract items), produce one numbered task entry:

```
N. [PREFIX-NNN P1] <task title>
   Files: <comma-separated target file paths>
   Estimate: <Xh>
   AC: <which AC items this covers>
```

5. Suggest a task ID prefix based on the spec name (e.g., SPEC-GUARD → GUARD-NNN).
6. Output the full numbered list, then a one-line summary: "N tasks, ~Xh total estimate".

Do not write anything to disk. Output only the plan to the conversation.