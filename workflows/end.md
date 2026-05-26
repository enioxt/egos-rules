---
description: Canonical EGOS finalization wrapper — Windsurf must follow the same /end contract used by Claude surfaces.
---

# Workflow: /end (Canonical Wrapper)

## Canonical Source of Truth

Windsurf `/end` MUST follow the same contract as:

1. `docs/agents/end.md`
2. `.claude/commands/end.md`
3. `AGENTS.md`

If these surfaces diverge, precedence is:

1. `AGENTS.md`
2. `docs/agents/end.md`
3. `.claude/commands/end.md`
4. this wrapper

## Required Behavior

- Run the canonical EGOS finalization protocol, not a Windsurf-specific variant.
- Preserve the same close-out discipline already frozen for Claude:
  - SHA-backed accomplishment claims
  - handoff generation
  - TASKS reconciliation
  - documentation drift check
  - capability auto-propose
  - highest-leverage closing classification

## Windsurf-Specific Rule

Do not add extra shutdown phases here unless they are first promoted into:

1. `AGENTS.md`, and then
2. `docs/agents/end.md`

This file is a wrapper, not an independent workflow contract.
