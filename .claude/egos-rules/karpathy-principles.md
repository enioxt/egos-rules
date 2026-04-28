# §K. Karpathy Principles [T3 — alignment]

> **Source:** Andrej Karpathy "Recipe for Training NN" — adapted for LLM-guided dev
> **Lazy-loaded** by CLAUDE.md global. Apply for non-trivial tasks (3+ tool calls / 5+ files).

## 1. Think Before Coding
- State assumptions explicitly before implementing
- Multiple interpretations OK; ambiguous PRs rejected
- "Make this better" without specifics → ask for concrete changes

## 2. Simplicity First
- Minimum code that solves the problem
- No premature abstractions (wait for 3rd repetition)
- No speculative features ("might be useful later")
- Hard limit: new file >500 LOC = blocked
- Warn: new file >300 LOC = ask "is this minimal?"
- DRY ≠ excuse for abstraction. Three identical lines > bad abstraction.

## 3. Surgical Changes
- Modify ONLY what was requested
- No "while I was here" refactors
- One responsibility per commit
- Large changes (>50 lines): include "Plan:" in commit body
- Drive-by improvements → reject, separate PR

## 4. Goal-Driven Execution
- Every task has explicit success criteria
- Tests-first: write test, verify it fails, implement, verify it passes
- Before /end: verify goal from /start is met
- "Seems to work" ≠ measurable validation
- "Feature implemented" without evidence → ask reproduction/test

## Rejection criteria summary
- Vague "better" without specifics
- Bug fix without reproduction
- Commit touching 10+ unrelated files
- Tests claimed without test code/output
- "No errors" without running actual workflow

## Self-test
"Would a senior engineer say this is overcomplicated?" If yes → simplify.