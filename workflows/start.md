---
description: Canonical EGOS activation wrapper — Windsurf must follow the same /start contract used by Claude surfaces.
---

# Workflow: /start (Canonical Wrapper)

## Canonical Source of Truth

Windsurf `/start` MUST follow the same contract as:

1. `docs/agents/start.md`
2. `.claude/commands/start.md`
3. `AGENTS.md`

If these surfaces diverge, precedence is:

1. `AGENTS.md`
2. `docs/agents/start.md`
3. `.claude/commands/start.md`
4. this wrapper

## Required Behavior

- Run the canonical `/start` initialization flow, not a Windsurf-specific variant.
- Preserve the highest-leverage framing:
  - `proof`
  - `extraction`
  - `canon`
  - `traceability`
  - `replication`
- Respect the same activation discipline already frozen for Claude:
  - remote staleness check
  - EPOS continuation
  - canonical SSOT reading
  - capability delta / governance smoke
  - verification checkpoint

## Windsurf-Specific Rule

Do not introduce additional activation obligations here unless they are first promoted into:

1. `AGENTS.md`, and then
2. `docs/agents/start.md`

This file is a wrapper, not an independent workflow contract.
