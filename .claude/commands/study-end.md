# /study-end — Gem Hunter Mandatory Session Closure (EGOS)

> Closes a pair-analysis session with all 9 required sections. Session is INCOMPLETE without this.

## Pre-check

Verify a `/study` session is active (pair artifacts should exist in `docs/gem-hunter/pairs/`).

## Section 1: Session Classification

- Primary category (from 10 Gem Hunter categories)
- Secondary categories
- Maturity level of reference repo
- Maintenance signal (high/medium/low/abandoned)
- EGOS fit level (0-100)

## Section 2: Final Scorecard

Calculate using `docs/gem-hunter/weights.yaml` rubric:
- Weighted total score
- All 9 component scores
- Confidence level (high/medium/low)
- Unresolved uncertainties

## Section 3: Top Patterns

- Top 10 patterns discovered
- Top 5 transplantable patterns (with evidence)
- Top 5 anti-patterns or cautions

## Section 4: Adopt / Adapt / Avoid

Final categorized decision set. Each entry needs: title, source files, complexity, risk, confidence, rationale.

## Section 5: Blind Spots

- What did this session show our search process was missing?
- What are our recurring analytical blind spots?
- What category is still underexplored?

## Section 6: Next Search Update

- Recommend next 3 repos (with reasoning)
- Which category gap each covers
- Expected marginal learning value

## Section 7: EGOS Improvement Patches

Concrete suggestions for: prompts, skills, workflows, scoring weights, report templates, queue logic.

## Section 8: SSOT Commit Package

Write artifacts to `docs/gem-hunter/pairs/egos__<repo>/`:
- `scorecard.md`, `session_close.md`, `next_recommendation.md`

Update `docs/gem-hunter/registry.yaml` with the new repo entry.

## Section 9: Executive Retrospective

- What we learned (3-5 bullets)
- What changed in our mental model
- What should change in the Gem Hunter system itself

## Completion Rule

Session is ONLY complete when all 9 sections are present.
Mark the corresponding GH-0xx task in TASKS.md as done.

## Cleanup

```bash
rm -rf /tmp/gem-hunter-study/<repo_short>
```
