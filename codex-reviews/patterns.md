# Codex Review Patterns — EGOS Learning Tracker
# Updated: 2026-04-15
# Auto-learn loop: 3 occurrences → candidate | 5 occurrences → propose rule

---

## Active Pattern Candidates

### [ci_improvement] CI/CD Python setup missing (count: 3/3) ✅ CANDIDATE
- **Seen in:** task_e_69cd8d2fa9cc832fba11aa7ebe835163 (2026-04-14, +3761)
- **Pattern:** CI workflow missing `actions/setup-python@v5` for Python scripts in `scripts/qa/`
- **Suggestion score:** 72/100 — CONSIDER
- **Status:** candidate (reached threshold — awaiting Enio decision to promote to rule)

### [ci_improvement] CI missing SSOT diagnostic step (count: 1/3)
- **Seen in:** task_e_69cd8d2fa9cc832fba11aa7ebe835163 (2026-04-14)
- **Pattern:** `bun run ssot:diagnostic` and `bun run qa:observability` not in CI steps
- **Suggestion score:** 68/100 — CONSIDER
- **Status:** tracking

### [ci_improvement] PR template missing Codex attribution (count: 1/3)
- **Seen in:** task_e_69cd8d2fa9cc832fba11aa7ebe835163 (2026-04-14)
- **Pattern:** PR template has no checkbox for Codex-generated PRs
- **Suggestion score:** 45/100 — SKIP (low value, governance overhead)
- **Status:** SKIP

### [doc_drift] QA docs not in QA README (count: 1/3)
- **Seen in:** task_e_69cd8d2fa9cc832fba11aa7ebe835163 (2026-04-14)
- **Pattern:** New QA scripts added without README index entry
- **Suggestion score:** 55/100 — DISCUSS
- **Status:** tracking

---

## Promoted Rules (≥5 occurrences → added to CLAUDE.md or .windsurfrules)

*None yet — pipeline started 2026-04-15*

---

## Review History

| Date | Task | Repo | Score | Decision | Patterns |
|------|------|------|-------|----------|---------|
| 2026-04-15 | task_e_69cd8d2fa9cc832fba11aa7ebe835163 | enioxt/egos | 68/100 | CONSIDER | ci_improvement(×3), doc_drift(×1) |

---

## How This Works

1. **Every /start + /end**: `codex-fetch-reviews.sh` fetches new reviews
2. **Claude evaluates**: against `CODEX_REVIEW_CRITERIA.md` (6 dimensions × weights)
3. **Patterns tracked here**: count occurrences per category
4. **At 3 occurrences**: pattern becomes a candidate — flagged to Enio
5. **At 5 occurrences**: Claude proposes adding to `.windsurfrules` or `CLAUDE.md`
6. **Self-healing**: over time, EGOS avoids the patterns Codex catches repeatedly
