#!/usr/bin/env bash
# leaf-post-commit-signal.sh — Emit commit signal to context-signals.jsonl
# Part of EGOS reverse dissemination (DISSEM-001)
# Chainable: call from existing post-commit hooks with "source" or direct exec
# Safe: non-blocking, never fails commit

SIGNALS_FILE="${HOME}/.egos/context-signals.jsonl"
REPO_PATH="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REPO_NAME="$(basename "$REPO_PATH")"

# Rotate if file exceeds 5000 lines (archive to context-signals-YYYYMM.jsonl)
if [ -f "$SIGNALS_FILE" ] && [ "$(wc -l < "$SIGNALS_FILE" 2>/dev/null || echo 0)" -ge 5000 ]; then
  mv "$SIGNALS_FILE" "${SIGNALS_FILE%.jsonl}-$(date +%Y%m).jsonl" 2>/dev/null || true
fi

# Get commit metadata
SHA="$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
SUBJECT="$(git log -1 --format='%s' HEAD 2>/dev/null || echo '')"
FILES_CHANGED="$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null | tr '\n' ' ' | xargs)"
FILES_COUNT="$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null | wc -l | tr -d ' ')"

# Classify extensions
EXTS="$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null | grep -oE '\.[a-z]+$' | sort -u | tr '\n' ',' | sed 's/,$//')"

# Determine signal type from commit subject
SIGNAL="commit"
case "$SUBJECT" in
  feat\(*\):*|feat:*)   SIGNAL="feat_commit" ;;
  fix\(*\):*|fix:*)     SIGNAL="fix_commit" ;;
  refactor\(*\):*|refactor:*) SIGNAL="refactor_commit" ;;
  docs\(*\):*|docs:*)   SIGNAL="docs_change" ;;
  chore\(*\):*|chore:*) SIGNAL="chore_commit" ;;
esac

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Escape subject safely — prefer jq (no deps), fall back to python3; safe fallback on failure
_escape_json() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$1" | jq -Rs .
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
  else
    return 1
  fi
}

SUBJECT_JSON="$(_escape_json "$SUBJECT")" || SUBJECT_JSON='"[subject-escape-failed]"'

# Emit signal (non-blocking, best-effort)
{
  printf '{"ts":"%s","repo":"%s","signal":"%s","sha":"%s","subject":%s,"files":%s,"exts":"%s"}\n' \
    "$TS" \
    "$REPO_NAME" \
    "$SIGNAL" \
    "$SHA" \
    "$SUBJECT_JSON" \
    "$FILES_COUNT" \
    "$EXTS"
} >> "$SIGNALS_FILE" 2>/dev/null || true
