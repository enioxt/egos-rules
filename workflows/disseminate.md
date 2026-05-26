---
description: Canonical EGOS dissemination wrapper — Windsurf must follow the same dissemination contract used by Claude surfaces.
---

# Workflow: /disseminate (Canonical Wrapper)

## Canonical Source of Truth

Windsurf `/disseminate` MUST follow the same contract as:

1. `.claude/commands/disseminate.md`
2. `AGENTS.md`

If these surfaces diverge, precedence is:

1. `AGENTS.md`
2. `.claude/commands/disseminate.md`
3. this wrapper

## Required Behavior

- Treat dissemination as kernel-first:
  - update `HARVEST.md` when real learnings were produced
  - update `CAPABILITY_REGISTRY.md` when capability reality changed
  - run governance sync/check when kernel governance changed
  - propagate knowledge without inventing new parallel doc surfaces

## Windsurf-Specific Rule

Do not maintain a separate dissemination doctrine here.

Any new dissemination behavior must first be promoted to the Claude canonical surface and then inherited by Windsurf through this wrapper.
