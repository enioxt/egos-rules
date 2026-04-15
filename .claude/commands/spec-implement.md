---
description: Implement a SPEC-*.md strictly from its API Contract and Acceptance Criteria
---

Implement the feature described in the spec for `$ARGUMENTS`.

Steps:
1. Resolve the spec file using the same logic as spec-plan: direct path, then `docs/specs/SPEC-<ARGUMENTS-UPPER>.md`, then glob fallback.
2. Read the entire spec. The **API Contract** is the source of truth for interfaces, types, and signatures. Do not deviate from it.
3. Before writing any code:
   - List all files that need to be created or modified.
   - Confirm the spec status is `approved` or `review`. If still `draft`, warn: "Spec is in draft status — proceeding anyway per invocation."
4. Implement each contract item strictly:
   - Match function signatures, parameter names, and return types exactly as specified.
   - Implement all Test Scenarios from the spec as tests (if a test file path is inferable).
5. After implementation, update the spec file:
   - Change `Status: draft | review | approved` to `Status: implemented`.
   - Mark each AC item as `- [x]` once the corresponding code is verified to exist.
6. Run `bun typecheck` (or `npx tsc --noEmit` if bun is unavailable). Fix ALL type errors before reporting done.
7. Report: list of files created/modified, AC items marked done, and typecheck result.

Do not gold-plate. Implement exactly what the spec says, nothing more.