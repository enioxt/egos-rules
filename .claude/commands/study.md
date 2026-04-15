# /study — Gem Hunter Pair-Analysis Session (EGOS)

> Starts a side-by-side diagnostic between EGOS and exactly ONE reference repository.

## Arguments

`$ARGUMENTS` = reference repo URL or short name (e.g., `continuedev/continue`, `Aider-AI/aider`)

## Phase 1: Setup

```bash
REPO_URL="$ARGUMENTS"
REPO_SHORT=$(echo "$REPO_URL" | sed 's|.*/||' | tr '[:upper:]' '[:lower:]')
echo "=== Gem Hunter Pair-Analysis: EGOS ↔ $REPO_SHORT ==="
echo "Date: $(date -I)"
```

If the repo is a GitHub short name (org/repo), expand to full URL.
Clone into `/tmp/gem-hunter-study/$REPO_SHORT` (read-only — do NOT modify the reference repo).

## Phase 2: Map Both Repos

For EGOS, use the knowledge graph and existing docs:
```
Use codebase-memory-mcp get_architecture for EGOS overview
```

For the reference repo, inspect:
1. Top-level structure (folders, config files, entry points)
2. README, CONTRIBUTING, docs/
3. Agent/tool/skill system
4. Memory/state management
5. Testing/eval framework
6. CI/CD and deployment
7. MCP or protocol integration

Produce two repo maps.

## Phase 3: Architecture Comparison

Compare across the 10 Gem Hunter analytical categories:

| Category | EGOS State | Reference State | Gap Analysis |
|----------|-----------|----------------|--------------|
| coding_surface | | | |
| agent_runtime | | | |
| memory_context | | | |
| model_gateway | | | |
| observability_evals | | | |
| retrieval_context | | | |
| durable_workflow | | | |
| protocol_tooling | | | |
| product_surface | | | |
| governance_safety | | | |

## Phase 4: Transplant Extraction

For each promising pattern found in the reference repo:

| Pattern | Level | Complexity | Risk | Evidence (files) | Why it matters to EGOS |
|---------|-------|-----------|------|-------------------|----------------------|
| ... | Adopt/Adapt/Reimplement/Avoid | L/M/H | L/M/H | ... | ... |

## Phase 5: Score

Calculate weighted score using `docs/gem-hunter/weights.yaml`:
- egos_relevance (0.24)
- transplantability (0.18)
- architectural_complementarity (0.14)
- novelty (0.12)
- maintenance_signal (0.10)
- doc_quality (0.08)
- license_clarity (0.06)
- operational_fit (0.04)
- observability_maturity (0.04)

## Phase 6: Output

Save all artifacts to `docs/gem-hunter/pairs/egos__$REPO_SHORT/`:
1. `repo_profile.md` — reference repo profile
2. `architecture_diff.md` — comparison table
3. `transplant_candidates.md` — adopt/adapt/avoid
4. `blind_spots.md` — what this reveals about our gaps

Present summary to user. DO NOT close the session — that requires `/study-end`.

## Rules
- Reference repo is READ-ONLY. Never modify it.
- Distinguish facts from inferences from proposals (label them).
- No merge decisions automatically — only proposals.
- License check before any transplant recommendation.
- Clean-room only: never copy code directly, only patterns.
