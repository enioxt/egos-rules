#!/usr/bin/env bash
# codex-fetch-reviews.sh — EGOS Codex Review Fetcher
# Fetches READY reviews from Codex Cloud, saves as markdown.
# Called by: /start, /end, cron
# Output: ~/.egos/codex-reviews/INDEX.md + per-review files
# Does NOT apply diffs — human + Claude evaluation required.

set -euo pipefail

REVIEWS_DIR="${HOME}/.egos/codex-reviews"
INDEX_FILE="${REVIEWS_DIR}/INDEX.md"
PENDING_FILE="${REVIEWS_DIR}/pending.json"
LOG_FILE="${HOME}/.egos/codex-reviews/fetch.log"

mkdir -p "${REVIEWS_DIR}"

log() { echo "[$(date -u +%H:%M:%SZ)] $*" | tee -a "${LOG_FILE}"; }

log "=== codex-fetch-reviews START ==="

# Verify codex is available
if ! command -v codex >/dev/null 2>&1; then
  log "ERROR: codex CLI not found"
  exit 1
fi

# Fetch task list
log "Fetching Codex Cloud tasks..."
TASK_LIST=$(codex cloud list 2>&1) || { log "ERROR: codex cloud list failed"; exit 1; }

# Count READY tasks
READY_COUNT=$(echo "${TASK_LIST}" | grep -c "\[READY\]" || true)
log "Found ${READY_COUNT} READY task(s)"

if [ "${READY_COUNT}" -eq 0 ]; then
  log "No new reviews to fetch."
  echo "✅ No pending Codex reviews."
  exit 0
fi

FETCHED=0
SKIPPED=0

# Process each READY task
while IFS= read -r line; do
  # Extract task ID from URL line: https://chatgpt.com/codex/tasks/task_e_XXXX
  TASK_URL=$(echo "${line}" | grep -oE 'https://chatgpt.com/codex/tasks/[^ ]+' || true)
  [ -z "${TASK_URL}" ] && continue
  TASK_ID=$(basename "${TASK_URL}")

  # Check if already fetched
  SAFE_ID=$(echo "${TASK_ID}" | tr '/' '_')
  EXISTING=$(ls "${REVIEWS_DIR}"/*"${SAFE_ID}"* 2>/dev/null || true)
  if [ -n "${EXISTING}" ]; then
    log "SKIP: ${TASK_ID} already fetched"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Get metadata from next lines
  TITLE=$(echo "${TASK_LIST}" | grep -A2 "${TASK_ID}" | grep -v "${TASK_ID}" | head -1 | xargs || echo "Unknown")
  REPO=$(echo "${TASK_LIST}" | grep -A3 "${TASK_ID}" | grep "•" | sed 's/.*• //' | sed 's/ •.*//' | xargs || echo "unknown")
  DATE_RAW=$(echo "${TASK_LIST}" | grep -A3 "${TASK_ID}" | grep "ago\|Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec" | xargs || echo "unknown")

  log "Fetching diff for: ${TASK_ID} — ${TITLE}"

  # Fetch the diff
  DIFF_OUTPUT=$(codex cloud diff "${TASK_ID}" 2>&1) || {
    log "WARN: Failed to fetch diff for ${TASK_ID}"
    continue
  }

  # Count changes
  ADDS=$(echo "${DIFF_OUTPUT}" | grep -c "^+" 2>/dev/null || echo "0")
  DELS=$(echo "${DIFF_OUTPUT}" | grep -c "^-" 2>/dev/null || echo "0")
  FILES=$(echo "${DIFF_OUTPUT}" | grep -c "^diff --git" 2>/dev/null || echo "0")

  # Write review file
  DATESTAMP=$(date -u +%Y-%m-%d)
  REVIEW_FILE="${REVIEWS_DIR}/${DATESTAMP}-${SAFE_ID}.md"

  cat > "${REVIEW_FILE}" << EOF
---
task_id: ${TASK_ID}
task_url: ${TASK_URL}
repo: ${REPO}
submitted: ${DATE_RAW}
fetched: $(date -u +%Y-%m-%dT%H:%M:%SZ)
status: FETCHED
files_changed: ${FILES}
additions: ${ADDS}
deletions: ${DELS}
prompt: "${TITLE}"
evaluated_by_claude: false
apply_decision: PENDING
---

# Codex Review — ${REPO} — ${DATESTAMP}

**Task:** ${TITLE}
**Changes:** +${ADDS} -${DELS} across ${FILES} files
**Evaluate against:** \`~/.egos/guarani/CODEX_REVIEW_CRITERIA.md\`

## ⚠️ DO NOT APPLY WITHOUT CLAUDE EVALUATION
This diff has NOT been reviewed yet. Claude must evaluate each suggestion
against CODEX_REVIEW_CRITERIA.md before any changes are applied.

## Diff

\`\`\`diff
${DIFF_OUTPUT}
\`\`\`
EOF

  log "SAVED: ${REVIEW_FILE} (+${ADDS}/-${DELS}, ${FILES} files)"
  FETCHED=$((FETCHED + 1))

done <<< "${TASK_LIST}"

# Update INDEX.md
{
  echo "# Codex Reviews Index"
  echo ""
  echo "Last updated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo ""
  echo "| Date | Task ID | Repo | Changes | Status | Evaluated |"
  echo "|------|---------|------|---------|--------|-----------|"
  for f in "${REVIEWS_DIR}"/*.md; do
    [ "$(basename "${f}")" = "INDEX.md" ] && continue
    [ "$(basename "${f}")" = "patterns.md" ] && continue
    [ "$(basename "${f}")" = "learning-candidates.md" ] && continue
    # Extract frontmatter fields
    FDATE=$(grep "^fetched:" "${f}" 2>/dev/null | head -1 | sed 's/fetched: //' | cut -c1-10 || echo "-")
    FID=$(grep "^task_id:" "${f}" 2>/dev/null | head -1 | sed 's/task_id: //' || echo "-")
    FREPO=$(grep "^repo:" "${f}" 2>/dev/null | head -1 | sed 's/repo: //' || echo "-")
    FADD=$(grep "^additions:" "${f}" 2>/dev/null | head -1 | sed 's/additions: //' || echo "?")
    FDEL=$(grep "^deletions:" "${f}" 2>/dev/null | head -1 | sed 's/deletions: //' || echo "?")
    FSTATUS=$(grep "^status:" "${f}" 2>/dev/null | head -1 | sed 's/status: //' || echo "-")
    FEVAL=$(grep "^evaluated_by_claude:" "${f}" 2>/dev/null | head -1 | sed 's/evaluated_by_claude: //' || echo "false")
    FEVAL_ICON=$([ "${FEVAL}" = "true" ] && echo "✅" || echo "⏳")
    echo "| ${FDATE} | \`${FID:0:20}...\` | ${FREPO} | +${FADD}/-${FDEL} | ${FSTATUS} | ${FEVAL_ICON} |"
  done
} > "${INDEX_FILE}"

log "=== DONE: fetched=${FETCHED} skipped=${SKIPPED} ==="
echo "✅ Codex reviews: fetched ${FETCHED}, skipped ${SKIPPED}. Index: ${INDEX_FILE}"
