#!/usr/bin/env bash
# codex-submit-review.sh — EGOS Codex Review Submitter
# Submits a new Codex Cloud review task for recent commits.
# Called by: /end, post-push hook
# Output: task_id stored in ~/.egos/codex-reviews/submitted.json

set -euo pipefail

REVIEWS_DIR="${HOME}/.egos/codex-reviews"
SUBMITTED_FILE="${REVIEWS_DIR}/submitted.json"
LOG_FILE="${REVIEWS_DIR}/submit.log"

mkdir -p "${REVIEWS_DIR}"

log() { echo "[$(date -u +%H:%M:%SZ)] $*" | tee -a "${LOG_FILE}"; }

REPO_PATH="${1:-$(pwd)}"
COMMITS="${2:-5}"  # Number of recent commits to review

log "=== codex-submit-review START ==="
log "Repo: ${REPO_PATH}"
log "Commits: ${COMMITS}"

# Verify we're in a git repo
if ! git -C "${REPO_PATH}" rev-parse --git-dir >/dev/null 2>&1; then
  log "ERROR: Not a git repository: ${REPO_PATH}"
  exit 1
fi

# Verify codex is available
if ! command -v codex >/dev/null 2>&1; then
  log "ERROR: codex CLI not found"
  exit 1
fi

# Build context from recent commits
REPO_NAME=$(basename "${REPO_PATH}")
BRANCH=$(git -C "${REPO_PATH}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
RECENT_COMMITS=$(git -C "${REPO_PATH}" log --oneline -"${COMMITS}" 2>/dev/null || echo "no commits")
CHANGED_FILES=$(git -C "${REPO_PATH}" diff HEAD~"${COMMITS}" --name-only 2>/dev/null | head -20 || echo "none")

PROMPT="Review the last ${COMMITS} commits in the ${REPO_NAME} repository (branch: ${BRANCH}).

Recent commits:
${RECENT_COMMITS}

Changed files:
${CHANGED_FILES}

EGOS governance context:
- Governance rules: .windsurfrules + CLAUDE.md
- Frozen zones (DO NOT modify): agents/runtime/runner.ts, agents/runtime/event-bus.ts, .husky/, .guarani/orchestration/PIPELINE.md
- Coding standards: .guarani/PREFERENCES.md
- Replace-not-Add rule: before creating new files, name what they replace
- Evidence-First: every capability claim must have a test or metric
- Karpathy Simplicity: minimum code that solves the problem

Review for:
1. TypeScript type safety issues (any implicit, missing return types)
2. Test coverage gaps (new functions without tests)
3. SSOT violations (duplicate logic, new files that should update existing ones)
4. Dead code or unused imports
5. Security issues (hardcoded values, missing validation)
6. Performance issues (N+1, missing indexes, large payloads)
7. Documentation drift (CAPABILITY_REGISTRY.md not updated)

Output format: for each suggestion, include:
- Severity: CRITICAL | HIGH | MODERATE | LOW
- File: path/to/file.ts:line
- Problem: what is wrong
- Fix: minimal change needed"

log "Submitting Codex Cloud task..."
log "Prompt: ${PROMPT:0:200}..."

# Submit the task
TASK_OUTPUT=$(codex cloud exec --repo "${REPO_NAME}" "${PROMPT}" 2>&1) || {
  log "ERROR: codex cloud exec failed: ${TASK_OUTPUT}"
  exit 1
}

# Extract task ID from output
TASK_ID=$(echo "${TASK_OUTPUT}" | grep -oE 'task_e_[a-f0-9]+' | head -1 || echo "")
TASK_URL=$(echo "${TASK_OUTPUT}" | grep -oE 'https://[^ ]+' | head -1 || echo "")

if [ -z "${TASK_ID}" ]; then
  log "WARN: Could not extract task ID from output: ${TASK_OUTPUT}"
  TASK_ID="unknown-$(date +%s)"
fi

log "Submitted: ${TASK_ID}"

# Record submission
DATESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
SUBMISSION=$(cat << JSONEOF
{
  "task_id": "${TASK_ID}",
  "task_url": "${TASK_URL}",
  "repo": "${REPO_NAME}",
  "branch": "${BRANCH}",
  "submitted": "${DATESTAMP}",
  "commits": "${COMMITS}",
  "status": "PENDING",
  "prompt": "${PROMPT:0:200}..."
}
JSONEOF
)

# Append to submitted.json (as JSONL)
echo "${SUBMISSION}" >> "${SUBMITTED_FILE}"

log "=== DONE: ${TASK_ID} submitted ==="
echo "✅ Codex review submitted: ${TASK_ID}"
echo "   Check status: codex cloud list"
echo "   Fetch when ready: ~/.egos/scripts/codex-fetch-reviews.sh"
