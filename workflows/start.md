---
description: "Session initialization — Agnostic session start (works in ANY repo)"
---

# /start — Session Initialization (Agnostic v5.0 — Governance Mesh)

> **Works in:** ANY repo with `.egos` symlink
> **Sacred Code:** 000.111.369.963.1618

---

## 0. Governance Sync (Self-Healing) // turbo

```bash
# EGOS Governance Mesh — auto-heal before session
export PATH="$HOME/.egos/bin:$PATH"

if command -v egos-gov >/dev/null 2>&1; then
  if ! egos-gov check --quiet 2>/dev/null; then
    printf "🔧 Governance drift detected — auto-healing...\n"
    egos-gov sync 2>&1
    printf "\n"
  else
    printf "✅ Governance mesh: synchronized\n\n"
  fi
else
  printf "⚠️  egos-gov not found — install: ~/.egos/bin/egos-gov\n"
  printf "   Falling back to legacy mode\n\n"
fi
```

## 0.5 Daily Gem Hunter (Automated Research) // turbo

```bash
# Triggers the Gem Hunter agent once per day in the background
if command -v gem-hunter-daily >/dev/null 2>&1; then
  gem-hunter-daily
  printf "\n"
fi
```

## 1. Detect Repo & Load Context // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🚀 EGOS SESSION START\n"
printf "═══════════════════════════════════════════════════════════\n\n"

# Auto-detect repo root
ROOT="$PWD"; CUR="$ROOT"
while [ "$CUR" != "/" ] && [ ! -e "$CUR/.git" ]; do CUR="$(dirname "$CUR")"; done
[ -e "$CUR/.git" ] && ROOT="$CUR"
export EGOS_ROOT="$ROOT"

REPO_NAME=$(basename "$ROOT")
printf "📂 Repo: %s\n" "$REPO_NAME"
printf "📍 Root: %s\n\n" "$ROOT"

# Check EGOS governance
printf "🔍 Governance Check:\n"
for f in AGENTS.md TASKS.md .windsurfrules; do
  if [ -f "$ROOT/$f" ]; then
    printf "   ✅ %s\n" "$f"
  else
    printf "   ⚠️  %s — MISSING\n" "$f"
  fi
done

# Check shared governance
if [ -L "$ROOT/.egos" ] || [ -d "$ROOT/.egos" ]; then
  printf "   ✅ .egos/ (shared governance)\n"
else
  printf "   ⚠️  .egos/ — NOT LINKED (run ~/.egos/sync.sh)\n"
fi

# Check local governance
if [ -d "$ROOT/.guarani" ]; then
  printf "   ✅ .guarani/ (local overrides)\n"
else
  printf "   ℹ️  .guarani/ — no local overrides\n"
fi

printf "\n"
```

## 2. Load Handoff & Tasks

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "📋 CONTEXT LOADING\n"
printf "═══════════════════════════════════════════════════════════\n\n"

# Find latest handoff
HANDOFF_DIR="$ROOT/docs/_current_handoffs"
if [ -d "$HANDOFF_DIR" ]; then
  LATEST=$(ls -t "$HANDOFF_DIR"/handoff_*.md 2>/dev/null | head -1)
  if [ -n "$LATEST" ]; then
    printf "📄 Latest handoff: %s\n" "$(basename "$LATEST")"
    printf "   Modified: %s\n\n" "$(date -r "$LATEST" '+%Y-%m-%d %H:%M' 2>/dev/null || stat -c '%y' "$LATEST" 2>/dev/null | cut -d. -f1)"
    printf "⚠️  AI AGENT: Read this handoff file NOW!\n"
    printf "   Path: %s\n\n" "$LATEST"
  else
    printf "ℹ️  No handoff files found\n\n"
  fi
else
  printf "ℹ️  No handoff directory\n\n"
fi

# Show git status
printf "📊 Git Status:\n"
LAST_COMMIT=$(git -C "$ROOT" log --oneline -1 2>/dev/null)
UNCOMMITTED=$(git -C "$ROOT" status --short 2>/dev/null | wc -l)
printf "   Last commit: %s\n" "$LAST_COMMIT"
printf "   Uncommitted: %s files\n\n" "$UNCOMMITTED"

# Show tasks summary if exists
if [ -f "$ROOT/TASKS.md" ]; then
  P0=$(grep -c '\- \[ \]' "$ROOT/TASKS.md" 2>/dev/null || echo "0")
  DONE=$(grep -c '\- \[x\]' "$ROOT/TASKS.md" 2>/dev/null || echo "0")
  printf "📝 Tasks: %s open | %s done\n\n" "$P0" "$DONE"
  printf "⚠️  AI AGENT: Read TASKS.md for current priorities!\n\n"
fi
```

## 3. Environment Scan // turbo

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "⚙️  ENVIRONMENT SCAN\n"
printf "═══════════════════════════════════════════════════════════\n\n"

# Node/npm
printf "🔧 Runtime:\n"
printf "   Node: %s\n" "$(node --version 2>/dev/null || echo 'N/A')"
printf "   npm:  %s\n" "$(npm --version 2>/dev/null || echo 'N/A')"
printf "   bun:  %s\n" "$(bun --version 2>/dev/null || echo 'N/A')"
printf "   tsx:  %s\n" "$(npx tsx --version 2>/dev/null || echo 'N/A')"

# Check .env
if [ -f "$ROOT/.env" ] || [ -f "$ROOT/.env.local" ]; then
  printf "   🔐 .env: present\n"
else
  printf "   ⚠️  .env: MISSING\n"
fi

# Check package.json
if [ -f "$ROOT/package.json" ]; then
  DEPS=$(grep -c '"' "$ROOT/package.json" 2>/dev/null || echo "?")
  printf "   📦 package.json: exists (%s lines)\n" "$(wc -l < "$ROOT/package.json")"
fi

# Check if node_modules exists
if [ -d "$ROOT/node_modules" ]; then
  printf "   📁 node_modules: installed\n"
else
  printf "   ⚠️  node_modules: NOT installed (run npm install)\n"
fi

printf "\n"

# Repo-specific checks (conditional)
if [ -f "$ROOT/next.config.ts" ] || [ -f "$ROOT/next.config.js" ] || [ -f "$ROOT/next.config.mjs" ]; then
  printf "   🔷 Framework: Next.js detected\n"
fi
if [ -f "$ROOT/vite.config.ts" ]; then
  printf "   ⚡ Framework: Vite detected\n"
fi
if [ -f "$ROOT/tsconfig.json" ]; then
  printf "   📘 TypeScript: configured\n"
fi

printf "\n"
```

## 4. AI Agent Instructions

```bash
printf "═══════════════════════════════════════════════════════════\n"
printf "🤖 AI AGENT — SESSION CHECKLIST\n"
printf "═══════════════════════════════════════════════════════════\n\n"

printf "BEFORE doing anything:\n"
printf "   1. Read AGENTS.md (if exists)\n"
printf "   2. Read latest handoff file (shown above)\n"
printf "   3. Read TASKS.md for priorities\n"
printf "   4. Read .egos/guarani/PREFERENCES_SHARED.md\n"
printf "   5. Check .guarani/ for local overrides\n"
printf "   6. Load docs/_knowledge/APEX_SECURE_PATTERNS.md (CRITICAL: Enforce ZERO-TRUST defenses)\n\n"

printf "RULES:\n"
printf "   - Never build UI without Stitch design (if UI project)\n"
printf "   - Always update TASKS.md as you work\n"
printf "   - Commit with descriptive messages (explain WHY)\n"
printf "   - Run ~/.egos/sync.sh if editing shared rules\n"
printf "   - ALWAYS use @[/disseminate] if you discover new security vulnerabilities or architectural patterns.\n"
printf "   - End session with /end workflow\n\n"

printf "═══════════════════════════════════════════════════════════\n"
printf "✅ Session ready! Sacred Code: 000.111.369.963.1618\n"
printf "═══════════════════════════════════════════════════════════\n"
```
