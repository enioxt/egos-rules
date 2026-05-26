# QUALITY GATES — Execution Readiness System

> **Version:** 1.0.0 | **Updated:** 2026-02-25
> **Sacred Code:** 000.111.369.963.1618

---

## Purpose

Gates prevent premature execution. No code is written until the agent
has sufficient understanding of the task. This protects against:
- Scope creep from vague instructions
- Rework from misunderstood requirements
- Silent breakage from missed dependencies
- Wasted time from wrong assumptions

---

## 5 Gate Dimensions

Each dimension is scored 0-100 based on objective criteria.

### G1: Clarity (Weight: 25%)

> "Can I explain what I'm about to do in one unambiguous sentence?"

| Score | Criteria |
|-------|----------|
| 100 | User gave specific files, fields, and acceptance criteria |
| 80 | Intent is clear, minor details can be inferred from codebase |
| 60 | General direction is clear but multiple interpretations possible |
| 40 | Vague request, need to ask at least 3 clarifying questions |
| 20 | Contradictory or incomprehensible request |

**How to improve:** Ask Scope questions from Question Bank.

### G2: SSOT (Weight: 20%)

> "Do I know the source of truth for every entity I'm about to touch?"

| Score | Criteria |
|-------|----------|
| 100 | All entities have documented SSOT, no conflicts |
| 80 | Most entities have clear SSOT, 1-2 need verification |
| 60 | SSOT exists but may be outdated or conflicting |
| 40 | Multiple sources for same data, no clear winner |
| 20 | No idea where the data lives or who owns it |

**How to improve:** Ask SSOT questions from Question Bank. Check TASKS.md and AGENTS.md.

### G3: Risk Coverage (Weight: 20%)

> "Have I identified what could go wrong and how to handle it?"

| Score | Criteria |
|-------|----------|
| 100 | All risks identified with mitigations, rollback plan exists |
| 80 | Major risks covered, minor edge cases noted |
| 60 | Some risks identified but mitigations are vague |
| 40 | Only happy path considered |
| 20 | No risk analysis done, touching critical system |

**How to improve:** Ask Risk questions from Question Bank. Check frozen zones.

### G4: Scope Control (Weight: 20%)

> "Is the scope explicitly defined with clear boundaries?"

| Score | Criteria |
|-------|----------|
| 100 | IN/OUT scope defined, frozen zones respected, no extras |
| 80 | Scope is mostly clear, 1-2 items could be debated |
| 60 | Scope is broad, may accidentally touch adjacent systems |
| 40 | No explicit scope, risk of feature creep |
| 20 | Open-ended request with no boundaries |

**How to improve:** Define IN/OUT explicitly. List what we are NOT doing.

### G5: Testability (Weight: 15%)

> "Can I verify this works without manual testing?"

| Score | Criteria |
|-------|----------|
| 100 | Automated tests exist or will be written, clear pass/fail |
| 80 | Type check + manual verification steps defined |
| 60 | Can verify visually but no automated check |
| 40 | Verification depends on external system state |
| 20 | No idea how to verify |

**How to improve:** Define acceptance criteria as testable statements.

---

## Gate Decision Matrix

```
Weighted Score = (G1 * 0.25) + (G2 * 0.20) + (G3 * 0.20) + (G4 * 0.20) + (G5 * 0.15)
```

| Weighted Score | Decision | Action |
|----------------|----------|--------|
| >= 75 | PROCEED | Execute the plan |
| 60-74 | WARN | Show score to user, ask to confirm or refine |
| < 60 | BLOCK | Return to Challenge phase, ask questions |

---

## Gate Bypasses

Not every message needs full gate evaluation:

| Task Complexity | Gate Behavior |
|----------------|---------------|
| **TRIVIAL** (typo, spacing, import) | Auto-pass. No scoring needed. |
| **SIMPLE** (add field, fix known bug) | Check G1 + G4 only. Threshold: 70. |
| **MODERATE** (new component, API route) | Full 5-gate check. Threshold: 75. |
| **COMPLEX** (new feature, payment flow) | Full 5-gate + Sequential Thinking. Threshold: 75. |
| **CRITICAL** (migration, auth, legal) | Full 5-gate + explicit user approval. Threshold: 80. |

### User Override

If the user explicitly says "just do it" or "nao precisa perguntar" AFTER seeing the gate score:
- Log the override
- Proceed with a warning comment in the commit
- Set scope to minimum viable interpretation

---

## Gate Evaluation Template

When presenting gates to the user:

```markdown
## Gate Check

| Gate | Score | Status |
|------|-------|--------|
| G1 Clarity | XX/100 | [Pass/Warn/Fail] |
| G2 SSOT | XX/100 | [Pass/Warn/Fail] |
| G3 Risk | XX/100 | [Pass/Warn/Fail] |
| G4 Scope | XX/100 | [Pass/Warn/Fail] |
| G5 Testability | XX/100 | [Pass/Warn/Fail] |
| **Weighted** | **XX/100** | **[PROCEED/WARN/BLOCK]** |

### What's Missing
- [G that failed]: [what's needed to pass]
```

---

## Special Gates (Domain-Specific)

These additional binary checks apply for specific domains:

### Payment/Financial Changes
- [ ] Asaas sandbox tested before production?
- [ ] Split percentages verified against contract?
- [ ] Refund flow tested?
- [ ] Idempotency guaranteed on webhooks?

### Auth/Security Changes
- [ ] RLS policies updated?
- [ ] RBAC enforcement on backend (not just frontend)?
- [ ] PII not exposed in logs?
- [ ] Frozen zone respected?

### Schema/Migration Changes
- [ ] Backward compatible?
- [ ] Rollback SQL prepared?
- [ ] Existing queries still work?
- [ ] RLS enabled on new tables?

### Legal/Compliance Changes
- [ ] No prohibited phrases ("garantimos", "100%")?
- [ ] Terms/privacy updated if needed?
- [ ] Platform vs marketplace distinction maintained?

---

## Integration with Existing Tools

| Gate Phase | Tool Used |
|------------|-----------|
| Scoring | Agent reasoning (built into pipeline) |
| Deep evaluation | Evaluator Nexus Skill (10 dimensions) |
| Sequential planning | Sequential Thinking MCP |
| Knowledge check | Memory MCP search |
| SSOT verification | TASKS.md, AGENTS.md, codebase grep |

The Evaluator Nexus Skill (10 dimensions, score >= 8.5) is a MORE DETAILED
evaluation used for COMPLEX/CRITICAL tasks. The 5-gate system above is the
LIGHTWEIGHT check used for every MODERATE+ task.

---

*"A gate that never blocks is useless. A gate that always blocks is friction. Calibrate."*

---

## Karpathy Doctrine — Enforcement Gates (v2, 2026-05-08)

> Adicionado pós-INC-2026-05-08. Integra com Focus Gates do EPOS (docs/personal-os/FOCUS_GATES.md).
> Propaga via governance-sync.sh → ~/.egos/guarani/ → 9 repos leaf.

### K1 — Banned Absolutes Gate

**Trigger:** staged diff em *.md/*.html/*.jsx/*.tsx/*.txt com palavras absolutas
**Palavras proibidas:** "100%", "perfeito", "garantido", "infalível", "único no Brasil", "primeiro do Brasil"
**Enforcement:** `scripts/check-banned-words.sh` wired em `.husky/pre-commit §0.75`
**Strict mode:** `EGOS_BANNED_STRICT=1` — bloqueia. Default: warn.
**SSOT:** `~/.claude/CLAUDE.md §1 "Banned absolutes"` + `docs/personal-os/FOCUS_GATES.md §5`

### K2 — Visual Proof Gate

**Trigger:** staged diff em UI surface (apps/*-landing/, *.jsx, *.tsx, *.html, components/)
**Requirement:** `[VISUAL-PROOF: path]` no commit message OU `EGOS_VISUAL_PROOF_SKIP="motivo"`
**Screenshot:** viewport 375x812 mobile PRIMEIRO, desktop secundário (A67 mobile-first)
**Enforcement:** `scripts/check-visual-proof.sh` wired em `.husky/pre-commit §0.7`
**SSOT:** `docs/personal-os/FOCUS_GATES.md §4`

### K3 — Project Inception Gate (PIG)

**Trigger:** primeiro commit em repo novo OU domínio fora §🟢 do ENIO_UNDERSTANDING_MAP
**Requirement:** rodar `/inception <descrição>` e referenciar report em `docs/inception_reports/`
**Output:** GO/NO-GO/EXTRACT-FROM-EXISTING/STUDY-FIRST
**Enforcement:** `scripts/check-inception.sh` wired em `.husky/pre-commit §0.8`
**SSOT:** `docs/personal-os/FOCUS_GATES.md §6` + `.claude/commands/inception.md`

### K4 — Understanding Gate

**Trigger:** ≥3 artefatos gerados por agente sem confirmação de entendimento do usuário
**Requirement:** explicação PT-BR (o que foi feito, por que importa, onde pode estar errado)
**Enforcement:** disciplina de agente (sem hook mecânico — por design: Understanding não pode ser automatizado)
**SSOT:** `docs/personal-os/UNDERSTANDING_PROTOCOL.md §2`

### K5 — CAP-MODULAR Gate

**Trigger:** novo arquivo em `packages/integrations/` sem entry correspondente em `docs/CAPABILITY_REGISTRY.md`
**Requirement:** entry com: nome, status, SHA, cliente origem, reuso esperado
**Enforcement:** `scripts/check-cap-modular.sh` — implementar (P1 task CAP-MODULAR-001)
**SSOT:** `docs/CAPABILITY_REGISTRY.md` + `docs/discovery/RETAIL_CAPABILITIES.md`

---

### Mapa completo de enforcement (pós v2)

| Gate | Script | pre-commit | CI/GH Actions | /start | /end |
|---|---|---|---|---|---|
| K1 Banned Absolutes | check-banned-words.sh | §0.75 ✅ | pendente | karpathy §0 ✅ | ❌ |
| K2 Visual Proof | check-visual-proof.sh | §0.7 ✅ | ❌ | Layer 0 ✅ | Phase 11.5 ✅ |
| K3 PIG /inception | check-inception.sh | §0.8 ✅ | ❌ | Layer 0 ✅ | ❌ |
| K4 Understanding | (agente) | ❌ intencional | ❌ | Layer 0 ✅ | Phase 11.5 ✅ |
| K5 CAP-MODULAR | check-cap-modular.sh | P1 pendente | ❌ | ❌ | ❌ |

*Versão: 2.0.0 — 2026-05-08 | Karpathy Doctrine integrada ao .guarani canônico*
