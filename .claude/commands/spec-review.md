---
description: Compare implementation against a SPEC-*.md and report ALIGNED / DRIFT / MISSING items
---

Review implementation status against the spec for `$ARGUMENTS`.

Steps:
1. Resolve the spec file using the same logic as spec-plan: direct path, then `docs/specs/SPEC-<ARGUMENTS-UPPER>.md`, then glob fallback.
2. Read the spec. Extract:
   - API Contract: every function signature, type, or REST route defined.
   - Acceptance Criteria: every `- [ ]` and `- [x]` item.
3. For each API contract item, grep the codebase for the function name, type name, or route path. Note whether it exists and in which file:line.
4. For each AC item, determine if observable behavior is implemented by searching relevant code.
5. Categorize every item as one of:
   - **ALIGNED** — spec says X, code implements X
   - **DRIFT** — spec says X, code does Y (describe the difference)
   - **MISSING** — spec defines it, no implementation found
6. Output a report with three sections (ALIGNED / DRIFT / MISSING), each as a markdown list.
7. End with a summary line: "X aligned, Y drift, Z missing".

Do not modify any files. Output only the review report to the conversation.
