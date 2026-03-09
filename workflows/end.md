---
description: "Session finalization — Agnostic session end with handoff (works in ANY repo)"
---

# /end — Session Finalization (Agnostic v5.0 — Governance Mesh)

> **Works in:** ANY repo with `.egos` symlink
> **Sacred Code:** 000.111.369.963.1618

---

## Phase 1: Collect Session Data // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🏁 EGOS SESSION END\n"
printf "═══════════════════════════════════════════════════════════\n\n"

# Auto-detect repo root
ROOT="$PWD"; CUR="$ROOT"
while [ "$CUR" != "/" ] && [ ! -e "$CUR/.git" ]; do CUR="$(dirname "$CUR")"; done
[ -e "$CUR/.git" ] && ROOT="$CUR"
export EGOS_ROOT="$ROOT"

REPO_NAME=$(basename "$ROOT")
printf "📂 Repo: %s\n\n" "$REPO_NAME"

# Recent commits (this session)
printf "📋 Recent commits:\n"
git -C "$ROOT" log --oneline --no-merges -10
printf "\n"

# Files changed (uncommitted)
UNCOMMITTED=$(git -C "$ROOT" status --short 2>/dev/null | wc -l)
if [ "$UNCOMMITTED" -gt 0 ]; then
  printf "⚠️  Uncommitted changes: %s files\n" "$UNCOMMITTED"
  git -C "$ROOT" status --short | head -15
  printf "\n"
fi

# LOC delta (if available)
printf "📊 Session stats:\n"
INSERTIONS=$(git -C "$ROOT" diff --stat HEAD~5..HEAD 2>/dev/null | tail -1 | grep -oP '\d+(?= insertions)' || echo "?")
DELETIONS=$(git -C "$ROOT" diff --stat HEAD~5..HEAD 2>/dev/null | tail -1 | grep -oP '\d+(?= deletions)' || echo "?")
printf "   Recent +%s /-%s lines\n\n" "$INSERTIONS" "$DELETIONS"
```

## Phase 2: AI Agent Generates Handoff

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "📝 HANDOFF GENERATION\n"
printf "═══════════════════════════════════════════════════════════\n\n"

printf "⚠️  AI AGENT: Generate the handoff using this template:\n\n"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat << EOF
# 🔄 HANDOFF — [SESSION_NAME]

**Repo:** $REPO_NAME
**Date:** $TIMESTAMP
**Agent:** [Antigravity/Windsurf]
**Commits:** [N]

---

## 📊 Summary
[2-4 lines: what was accomplished]

## 🔍 Key Files Changed
\`\`\`
[list the important files]
\`\`\`

## 🚀 Next Priorities
- [ ] P0: [urgent]
- [ ] P1: [important]
- [ ] P2: [nice to have]

## ⚠️ Alerts
[Things the next agent MUST know]

## 🏁 Quick Start
\`\`\`bash
cd $ROOT
[startup command]
\`\`\`

---
**Signed by:** [agent] — $TIMESTAMP
EOF

printf "\n\n📁 Save to: %s/docs/_current_handoffs/handoff_[topic].md\n\n" "$ROOT"
```

## Phase 3: Update TASKS.md // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "📝 TASKS.md CLEANUP\n"
printf "═══════════════════════════════════════════════════════════\n\n"

if [ -f "$ROOT/TASKS.md" ]; then
  LINE_COUNT=$(wc -l < "$ROOT/TASKS.md")
  OPEN=$(grep -c '\- \[ \]' "$ROOT/TASKS.md" 2>/dev/null || echo "0")
  DONE=$(grep -c '\- \[x\]' "$ROOT/TASKS.md" 2>/dev/null || echo "0")
  
  printf "📊 Current TASKS.md:\n"
  printf "   Lines: %s\n" "$LINE_COUNT"
  printf "   Open:  %s\n" "$OPEN"
  printf "   Done:  %s\n\n" "$DONE"
  
  printf "⚠️  AI AGENT:\n"
  printf "   1. Mark completed tasks with [x]\n"
  printf "   2. Add new tasks discovered\n"
  printf "   3. Update priorities if needed\n\n"
else
  printf "⚠️  No TASKS.md found\n\n"
fi
```

## Phase 4: Memory Update

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🧠 MEMORY UPDATE\n"
printf "═══════════════════════════════════════════════════════════\n\n"

printf "⚠️  AI AGENT: Save session knowledge:\n"
printf "   1. Key decisions made\n"
printf "   2. Patterns discovered\n"
printf "   3. Architecture changes\n"
printf "   4. Technical debt identified\n"
printf "   5. Bugs found/fixed\n\n"

printf "🚨 CRITICAL: If you discovered a critical bug, vulnerability, or systemic pattern:\n"
printf "   -> You MUST trigger the @[/disseminate] workflow and explicitly follow 'C. Global Rule Propagation'.\n"
printf "   -> Ensure .windsurfrules and PREFERENCES.md are updated across the ecosystem.\n\n"

printf "Use: Memory MCP (create_entities / add_observations)\n"
printf "Or:  /disseminate workflow\n\n"
```

## Phase 4.5: Ambient Evolution (Autonomous) // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🌌 AMBIENT EVOLUTION LOOP\n"
printf "═══════════════════════════════════════════════════════════\n\n"

# Run the autonomous intelligence harvester
if [ -f "$ROOT/scripts/ambient_disseminator.ts" ]; then
  bun run "$ROOT/scripts/ambient_disseminator.ts"
fi

```

## Phase 4.8: Governance Sync // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🔱 GOVERNANCE SYNC\n"
printf "═══════════════════════════════════════════════════════════\n\n"

export PATH="$HOME/.egos/bin:$PATH"
if command -v egos-gov >/dev/null 2>&1; then
  egos-gov sync 2>&1
  printf "\n"
else
  printf "⚠️  egos-gov not installed — run: ~/.egos/bin/egos-gov sync\n\n"
fi
```

## Phase 5: Final Commit // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🎯 FINAL COMMIT\n"
printf "═══════════════════════════════════════════════════════════\n\n"

UNCOMMITTED=$(git -C "$ROOT" status --short 2>/dev/null | wc -l)
if [ "$UNCOMMITTED" -gt 0 ]; then
  printf "⚠️  %s uncommitted files — commit before ending!\n\n" "$UNCOMMITTED"
  printf "Suggested commit:\n"
  printf "   git add -A\n"
  printf "   git commit -m \"chore: end session + handoff\"\n"
  printf "   git push\n\n"
else
  printf "✅ Working directory clean\n\n"
fi

printf "═══════════════════════════════════════════════════════════\n"
printf "✅ Session complete! Sacred Code: 000.111.369.963.1618\n"
printf "═══════════════════════════════════════════════════════════\n"
```
