---
name: dep-audit
description: Auditoria de dependências — detecta packages declaradas mas não importadas, ou imports sem package declarada. Stub from skill candidate architecture.drift/dep_auditor (134 events).
allowed-tools: Bash, Read, Grep, Glob
source_candidate: docs/_drafts/skill-candidates/architecture-drift_dep_auditor-2026-05-18.md
status: stub
implemented: false
---

# /dep-audit — Skill Stub (GROK-INV-T5 approved)

> **Status:** STUB — aprovada por Enio 2026-05-18 (Q5).
> **Origem:** 134 eventos `architecture.drift` do agente `dep_auditor` em 30 dias.

## Trigger

- Antes de adicionar nova dependência
- Auditoria semanal
- Manual: usuário pede "audita deps"

## Action (proposta)

1. Rodar `bun agents/agents/dep-auditor.ts`
2. Identificar: deps declaradas + não importadas / imports sem declaração / version conflicts
3. Para cada caso: sugerir remoção, instalação ou pin de versão
4. HITL antes de aplicar (especialmente para remoção)

## Output

- Lista de deps unused (candidatas a remoção)
- Lista de imports não-declarados (precisam install)
- Conflitos de versão (precisam pin)

## Implementação completa

Pendente em `SKILL-IMPL-FROM-APPROVED-001`.

---
*Stub generated 2026-05-18 from approved skill candidate. GROK-INV-T5 Q5.*