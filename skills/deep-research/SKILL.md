---
name: "deep-research"
description: "Master protocol for full-repository deep research, mapping, contextualization, and auto-healing."
triggers:
  - "deep research"
  - "pesquisa profunda"
  - "mapear repositório"
  - "auto-heal repo"
  - "analisar repo completo"
  - "full repository analysis"
anti_triggers:
  - "research paper"
  - "web research"
---

# Deep Research & Auto-Heal Protocol

When tasked to research a repository deeply, FOLLOW THESE EXACT PHASES sequentially:

## Phase 1: Contextual Setup
1. Create an artifact file `docs/diagnostics/RESEARCH_LOG.md` (or store it in the Antigravity artifact directory) to memorize, contextualize, and compress your findings as you progress.
2. Read the project's SSOT (Single Source of Truth) files (`README.md`, `TASKS.md`, `SYSTEM_MAP.md`, `AGENTS.md`) first. Do NOT skip this. It gives you the baseline of what *should* exist.

## Phase 2: Structural Sweep
1. Use `find_by_name` or `mcp_filesystem_directory_tree` to fetch the complete physical structure of key directories (e.g., `src`, `lib`, `api`, `frontend`).
2. Cross-reference the discovered physical files with the project's system map. Document any "drift" (unmapped files or missing files) directly in your `RESEARCH_LOG.md`.
3. Use `grep_search` to find instances of deprecated dependencies or hardcoded API keys if instructed.

## Phase 3: Auto-Healing & Corrections
1. As you discover structural drifts, bugs, or missing imports, **FIX THEM PROACTIVELY (Auto-Heal)**. You have the skills to edit files directly. Fix obvious documentation drift, standardizing headers, and fixing typos.
2. For severe architectural issues (e.g., broken build scripts that require user secrets), log them as `P0 Blockers` in `TASKS.md` instead of guessing.

## Phase 4: Final Compression
1. End your research by updating `SYSTEM_MAP.md` completely.
2. Provide the user a succinct executive summary of the repository's health, what you auto-healed, and what critical blockers remain.
