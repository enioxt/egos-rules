#!/usr/bin/env bash
# ~/.egos/hooks/readme-freshness.sh
# Enforces README freshness: warns at 30 days, blocks at 60 days.
# Override: add "DOC-STALE-ACCEPTED: <reason>" to commit body.
#
# Installation: source from .husky/pre-commit in each repo:
#   bash ~/.egos/hooks/readme-freshness.sh || exit 1
#
# Per-repo override: create .no-readme-check file at repo root to skip.

set -u

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$REPO_ROOT" ] && { echo "[readme-freshness] not a git repo — skipping"; exit 0; }
[ -f "$REPO_ROOT/.no-readme-check" ] && { echo "[readme-freshness] skipped via .no-readme-check"; exit 0; }

README="$REPO_ROOT/README.md"

# No README = block commit unless repo is a placeholder
if [ ! -f "$README" ]; then
  echo "🔴 [readme-freshness] BLOCKED: $REPO_ROOT has no README.md"
  echo "   Create a minimal README (purpose, stack, quickstart) or add .no-readme-check to suppress."
  exit 1
fi

# Days since README last committed (not file mtime — committed mtime)
README_LAST_COMMIT=$(git log -1 --format=%ct -- README.md 2>/dev/null || echo 0)
NOW=$(date +%s)

if [ "$README_LAST_COMMIT" = "0" ]; then
  # Never committed — probably new, allow
  exit 0
fi

AGE_DAYS=$(( (NOW - README_LAST_COMMIT) / 86400 ))

# Check if commit message/body contains override
OVERRIDE=0
COMMIT_MSG_FILE="${1:-}"
if [ -n "$COMMIT_MSG_FILE" ] && [ -f "$COMMIT_MSG_FILE" ]; then
  grep -q "DOC-STALE-ACCEPTED:" "$COMMIT_MSG_FILE" 2>/dev/null && OVERRIDE=1
fi

if [ "$AGE_DAYS" -gt 60 ] && [ "$OVERRIDE" -eq 0 ]; then
  echo "🔴 [readme-freshness] BLOCKED: README.md not updated in ${AGE_DAYS} days (>60)."
  echo "   Option 1: update README.md to reflect current state"
  echo "   Option 2: add 'DOC-STALE-ACCEPTED: <reason>' to commit body"
  exit 1
elif [ "$AGE_DAYS" -gt 30 ]; then
  echo "⚠️  [readme-freshness] README.md is ${AGE_DAYS} days old — consider updating"
  # non-blocking warn
fi

exit 0
