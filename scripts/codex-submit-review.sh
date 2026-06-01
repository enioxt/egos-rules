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

# Repo metadata for the review record (Codex auto-loads governance context from AGENTS.md)
REPO_NAME=$(basename "${REPO_PATH}")
BRANCH=$(git -C "${REPO_PATH}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# 2026-05-31: codex-cli 0.130.0 removed `cloud exec --repo` (now requires cloud --env <ID>,
# not discoverable from CLI). Switched to LOCAL synchronous review (`codex exec review`),
# which needs no cloud env id and works offline. Output written to a dated review file.
DATESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
SHORT_SHA=$(git -C "${REPO_PATH}" rev-parse --short HEAD 2>/dev/null || echo "nohead")
REVIEW_FILE="${REVIEWS_DIR}/$(date -u +%Y-%m-%d)-local-review-${SHORT_SHA}.md"
BASE_REF="HEAD~${COMMITS}"

log "Running local Codex review (codex exec review --base ${BASE_REF})..."

# NOTE: codex-cli 0.131+ makes scope flags (--base/--commit) mutually exclusive
# with the [PROMPT] positional. EGOS governance context is auto-loaded by Codex
# from the repo's AGENTS.md, so the custom PROMPT is no longer passed; scope flags win.
REVIEW_OUTPUT=$( (cd "${REPO_PATH}" && timeout 600 codex exec review --base "${BASE_REF}") 2>&1 ) || {
  log "WARN: --base review failed, retrying single-commit (HEAD)..."
  REVIEW_OUTPUT=$( (cd "${REPO_PATH}" && timeout 600 codex exec review --commit HEAD) 2>&1 ) || {
    log "ERROR: codex exec review failed: ${REVIEW_OUTPUT}"
    exit 1
  }
}

{
  echo "# Codex Local Review — ${DATESTAMP}"
  echo
  echo "- Repo: ${REPO_NAME} | Branch: ${BRANCH} | Base: ${BASE_REF} | Commits: ${COMMITS}"
  echo
  echo '```'
  echo "${REVIEW_OUTPUT}"
  echo '```'
} > "${REVIEW_FILE}"

# Record run (JSONL)
SUBMISSION=$(cat << JSONEOF
{
  "review_file": "${REVIEW_FILE}",
  "repo": "${REPO_NAME}",
  "branch": "${BRANCH}",
  "head": "${SHORT_SHA}",
  "submitted": "${DATESTAMP}",
  "commits": "${COMMITS}",
  "mode": "local-exec-review",
  "status": "DONE"
}
JSONEOF
)
echo "${SUBMISSION}" >> "${SUBMITTED_FILE}"

log "=== DONE: local review written to ${REVIEW_FILE} ==="
echo "✅ Codex local review done: ${REVIEW_FILE}"
