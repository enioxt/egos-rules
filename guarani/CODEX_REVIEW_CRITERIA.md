# CODEX_REVIEW_CRITERIA.md — Evaluation Rubric for Codex Reviews
# Version: 1.0.0 — 2026-04-15
# Used by: /start, /end, codex-fetch-reviews.sh
# SSOT: ~/.egos/guarani/CODEX_REVIEW_CRITERIA.md

---

## Purpose

Codex Cloud reviews arrive as diffs. They are NEVER auto-applied.
Claude evaluates each suggestion against this rubric before surfacing to Enio.
Suggestions with score ≥ 3 should be presented. Patterns tracked in `patterns.md`.

---

## Evaluation Dimensions (score 0-5 each)

### 1. Alignment with EGOS Governance (weight: 3x)
- Does it respect frozen zones? (`agents/runtime/`, `.husky/`, `.guarani/orchestration/PIPELINE.md`)
- Does it follow Replace-not-Add? (new file must replace old one)
- Does it maintain SSOT? (single canonical file per domain)
- Does it follow Karpathy Simplicity? (minimum code that solves the problem)
- **Score 0**: Violates frozen zones or SSOT
- **Score 3**: Neutral — doesn't touch governance
- **Score 5**: Actively improves governance compliance

### 2. Type Safety & Code Quality (weight: 2x)
- Fixes real TypeScript errors (not just adding `any`)
- Removes unused imports / dead code
- Improves type specificity (narrower types = better)
- Adds missing error handling at boundaries
- **Score 0**: Makes types worse, adds `any`
- **Score 3**: Neutral style changes
- **Score 5**: Fixes real type errors, improves safety

### 3. Test Coverage (weight: 2x)
- Does the suggestion add/fix tests?
- Does it test behavior (not just structure)?
- Do tests use real data (not string-matching grep)?
- **Score 0**: Removes or weakens tests
- **Score 3**: Adds structural tests (not behavioral)
- **Score 5**: Adds behavioral tests with real data

### 4. Evidence-First Compliance (weight: 2x)
- Every new capability claim backed by test/metric?
- No undocumented features?
- CAPABILITY_REGISTRY.md updated when needed?
- **Score 0**: Claims without proof, phantom capabilities
- **Score 3**: Neutral — no new claims
- **Score 5**: Adds evidence for existing claims

### 5. Karpathy Simplicity (weight: 2x)
- Is the change the minimum code that solves the problem?
- No speculative abstractions?
- No premature helpers for one-time ops?
- New files ≤300 LOC?
- **Score 0**: Adds speculative complexity, large abstractions
- **Score 3**: Reasonable, no over-engineering
- **Score 5**: Genuinely simpler than what exists

### 6. Security (weight: 3x)
- No hardcoded credentials?
- No new attack surfaces?
- No bypassed validation?
- **Score 0**: Introduces security risk
- **Score 3**: Neutral
- **Score 5**: Actively improves security posture

---

## Decision Matrix

| Weighted Score | Action |
|---------------|--------|
| ≥ 80 | **APPLY** — Present to Enio with strong recommendation |
| 60-79 | **CONSIDER** — Present to Enio with reasoning |
| 40-59 | **DISCUSS** — Flag for context, likely skip |
| < 40 | **SKIP** — Don't surface unless Enio asks |

**Weighted score formula:**
`(gov×3 + type×2 + test×2 + evidence×2 + simplicity×2 + security×3) / 14 × 100`

---

## Auto-Skip Rules (immediately SKIP without scoring)

1. **Modifies frozen zones** — `agents/runtime/runner.ts`, `agents/runtime/event-bus.ts`, `.husky/pre-commit`, `.guarani/orchestration/PIPELINE.md`
2. **Creates timestamped docs** — `docs/*_2026-*.md` outside `_archived/`
3. **Introduces `any` types** — without explicit justification
4. **git add -A** — any suggestion to stage all files
5. **Force-push** — any suggestion involving `--force` on main
6. **API key hardcoded** — any suggestion embedding credentials
7. **Breaks existing tests** — suggestions that remove test assertions

---

## Pattern Tracking

When 3+ reviews suggest the same type of change:
→ Promote to `~/.egos/codex-reviews/patterns.md` as a candidate
→ After 5 occurrences: propose adding to `.windsurfrules` or `CLAUDE.md`

Pattern categories to track:
- `ci_improvement` — CI/CD pipeline enhancements
- `type_safety` — TypeScript type fixes
- `test_coverage` — Missing test patterns
- `doc_drift` — Documentation out of sync with code
- `ssot_violation` — Duplicate logic/files
- `simplicity` — Over-engineered code
- `security` — Security hardening

---

## Review Workflow (mandatory at /start and /end)

```bash
# At /start: read pending reviews
~/.egos/scripts/codex-fetch-reviews.sh

# Claude evaluates using this rubric:
# 1. For each suggestion in the diff:
#    a. Check auto-skip rules first
#    b. Score all 6 dimensions
#    c. Compute weighted score
#    d. Surface APPLY/CONSIDER items to Enio
# 2. Track patterns in ~/.egos/codex-reviews/patterns.md
# 3. Update review file: evaluated_by_claude: true

# At /end: submit new review
~/.egos/scripts/codex-submit-review.sh /home/enio/egos 5
```

---

## Learning Loop

1. Enio reviews Claude's evaluation → provides feedback
2. Feedback updates patterns.md
3. After 5 pattern repetitions → candidate for CLAUDE.md rule
4. Claude proposes rule addition via `/disseminate`
5. Rule added → future reviews catch this automatically

**This is the self-healing loop. Each review makes EGOS smarter.**
