# AUTORES Mine Calibration Report
**Generated:** 2026-05-26 | **Model:** Groq/llama-3.1-8b-instant
**Task:** AUTORES-MINE-CALIBRATE-001
**Decision:** ✅ GO — All 3 thresholds passed

## Metrics

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Commits fetched | 80 | — | — |
| Skipped (chore/docs) | 20 | — | — |
| Classified | 20 | ≥5 | ✅ |
| Precisão | 100.0% | ≥70% | ✅ |
| False Positive | 0.0% | ≤30% | ✅ |
| Mock/Error | 0.0% | <5% | ✅ |

## Positive Classifications

- **`a227636f`** `feat(autores): INGEST-INCIDENTS-001 — 9 INC-* como rule candidates (dr`
  - Domain: `governance` | Conf: 0.80
  - Pattern: *Ingesting draft incidents with IDs INC-001 to INC-009 as rule candidates*
- **`98a85e69`** `feat(autores): INGEST-HARVEST-001 — 158 learnings curados como SEED PR`
  - Domain: `governance` | Conf: 0.80
  - Pattern: *Learnings from external sources should be ingested as primary seed data.*
- **`e85798a9`** `feat(autores): SCHEMA-FOUNDATION-001 — RULE proposal schema completo (`
  - Domain: `governance` | Conf: 0.90
  - Pattern: *A rule proposal schema should include states, supersede, and conflict resolution.*
- **`25cb0774`** `feat(hermes): LIFECYCLE-001 + DASHBOARD-001 — Wave 2 completa (Sonnets`
  - Domain: `architecture` | Conf: 0.80
  - Pattern: *Use environment-specific file paths to avoid hardcoded paths.*
  - HARVEST: "Pattern (2026-04-16) — Focus-enforcement v5.0: CLEAN_PATTERNS first, FORBIDDEN n"
- **`67acc7a4`** `fix(hooks): DISS-BUG-003 auto-disseminate skip on negative-completion `
  - Domain: `security` | Conf: 0.90
  - Pattern: *Auto-dissemination should be skipped if the commit subject contains negative-completion keywords.*
- **`aefca149`** `feat(hermes): BLOCK-001 hook integrated + restore SEC-EMERGENCY-001 (a`
  - Domain: `security` | Conf: 0.80
  - Pattern: *When integrating external hooks, ensure SEC-EMERGENCY-001 is restored to prevent false positives.*
- **`51e7e39d`** `feat(security): SEC-EMERGENCY-001/002 — secrets reais expostos no git `
  - Domain: `security` | Conf: 0.90
  - Pattern: *Secrets should not be exposed in public Git repositories.*
- **`8ab6aa78`** `feat(hermes): TASKS-LOCK-001 — flock-based transactional lock para her`
  - Domain: `governance` | Conf: 0.90
  - Pattern: *Detects emerging patterns in review queue findings to prevent anti-corrida Codex audits.*
  - HARVEST: "Patterns (2026-04-06 — Codex + HQ + Governance)"

## False Positives

*(none)*

## Decision

All thresholds passed. **Next:** `bun scripts/autores-mine-history.ts`

---
*autores-mine-calibrate.ts — 2026-05-26T20:51:26.282Z*