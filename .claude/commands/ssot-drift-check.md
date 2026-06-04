---
name: ssot-drift-check
description: Detecta violações de SSOT (Single Source of Truth) — módulos que driftam de definição canonical. Stub from skill candidate architecture.ssot_violation/ssot_auditor (168 events).
allowed-tools: Bash, Read, Grep, Glob
source_candidate: docs/_drafts/skill-candidates/architecture-ssot_violation_ssot_auditor-2026-05-18.md
status: stub
implemented: false
---

# /ssot-drift-check — Skill Stub (GROK-INV-T5 approved)

> **Status:** STUB — aprovada por Enio 2026-05-18 (Q5).
> **Origem:** 168 eventos `architecture.ssot_violation` do agente `ssot_auditor` em 30 dias.

## Trigger

- Quando novo módulo é adicionado
- Auditoria semanal de governança
- Manual: usuário pede "verifica drift SSOT"

## Action (proposta)

1. Rodar `bun agents/agents/ssot-auditor.ts`
2. Comparar cada módulo contra SSOT map (CLAUDE.md §7 + AGENTS.md tabela)
3. Flag entries: missing, misaligned, score <70
4. Output: drift report com severidade + suggested fix path

## Output

- Tabela de drift: módulo, score, status, suggested SSOT path
- Recomendação de ação por severidade

## Implementação completa

Pendente em `SKILL-IMPL-FROM-APPROVED-001`.

---
*Stub generated 2026-05-18 from approved skill candidate. GROK-INV-T5 Q5.*