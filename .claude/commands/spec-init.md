---
description: Create a new SPEC-*.md from the canonical template
---

Create a new spec document for the feature named `$ARGUMENTS`.

Steps:
1. Derive the spec filename: `docs/specs/SPEC-<FEATURE-NAME-UPPERCASE>.md` where FEATURE-NAME is `$ARGUMENTS` normalized to UPPER-KEBAB-CASE (spaces → dashes, lowercase → uppercase).
2. Read the template at `docs/specs/SPEC-TEMPLATE.md`.
3. Copy the template content and replace:
   - `[NAME]` with the normalized feature name
   - `[Title]` with a human-readable title derived from `$ARGUMENTS`
   - `YYYY-MM-DD` with today's date in ISO format
   - `feat/[name]` with `feat/<feature-name-lowercase-kebab>`
   - Leave `Status: draft` as-is
4. Write the file to `docs/specs/SPEC-<FEATURE-NAME>.md`.
5. Report: "Created docs/specs/SPEC-<FEATURE-NAME>.md — status: draft"

Do not create any other files. Do not open the spec for editing. Just create and confirm.