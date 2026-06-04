---
description: Audit hermes-egos fork against NousResearch upstream. Use when: checking for SECURITY or BREAKING upstream changes, before merging upstream commits, or when pre-commit warns >14d without sync.
---

# /hermes-upstream-watch — Hermes Upstream Audit

> **GROK-KBN-003** | Promovido de HERMES-FORK-011 (P2 → P1)
> **Propósito:** Auditar commits do upstream NousResearch/hermes-agent, categorizar, decidir ação.

## O que faz

1. Faz `git fetch upstream` no fork hermes-egos
2. Lista commits novos desde último sync
3. Categoriza: SECURITY / BREAKING / BUGFIX / FEATURE
4. Sugere ação: merge agora / wait / abrir issue
5. Salva report em `docs/jobs/<DATE>-hermes-upstream-status.json`

## Quando usar

- Toda semana (ou quando pre-commit hook `09-hermes-upstream.sh` avisar)
- Antes de fazer merge de features upstream

## Execução

```bash
bun /home/enio/egos/scripts/hermes-upstream-audit.ts
```

Ou com saída em JSON:

```bash
bun /home/enio/egos/scripts/hermes-upstream-audit.ts --save
```

## Categorias

| Categoria | Critério | Ação recomendada |
|---|---|---|
| SECURITY | commit msg contém "security", "CVE", "vuln", "fix auth" | **Merge imediato** |
| BREAKING | "breaking", "BREAKING CHANGE", "removed", "deprecated API" | **Testar em branch antes** |
| BUGFIX | "fix", "patch", "bug", "revert" | Merge na próxima janela |
| FEATURE | "feat", "add", "new", "kanban", "agent" | Avaliar impacto nos plugins |
| CHORE | "chore", "docs", "style", "refactor" | Merge opcional |

## Arquivos

- Script: `scripts/hermes-upstream-audit.ts`
- Reports: `docs/jobs/<DATE>-hermes-upstream-status.json`
- Fork: `/home/enio/hermes-egos/`
- Hook: `.husky/_checks/09-hermes-upstream.sh` (warn 14d, block 30d)
