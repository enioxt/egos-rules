---
description: "Intent Refinery — Translate vague instructions into precise technical prompts"
---

# /pre — Intent Refinery (Agnostic v2.0)

> **Works in:** ANY repo | **When:** User gives vague or ambiguous instructions

---

## Process

```
⚠️  AI AGENT: When user input is vague, process it through these steps:

1. EXTRACT INTENT
   - What does the user actually want to achieve?
   - What's the underlying problem/need?

2. IDENTIFY AMBIGUITIES
   - What's unclear or could be interpreted multiple ways?
   - What assumptions am I making?

3. MAP TO TECHNICAL ACTIONS
   - What specific files/modules/APIs are involved?
   - What's the scope (1 file? 10 files? architectural?)

4. GENERATE CLARIFYING QUESTIONS (if needed)
   - Ask max 3 targeted questions
   - Provide default options so user can just confirm

5. OUTPUT PRECISE PROMPT
   - Rewrite as clear, actionable technical specification
   - Include: scope, files affected, expected outcome, verification

TEMPLATE:
────────────────────────────────────────────
**Intent:** [clear 1-line summary]
**Scope:** [files/modules affected]
**Steps:**
  1. [specific action]
  2. [specific action]
**Verification:** [how to confirm it's done]
**Cost:** [estimated effort: low/medium/high]
────────────────────────────────────────────
```
