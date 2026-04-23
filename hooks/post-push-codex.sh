#!/bin/bash
# Post-push hook — Codex Cloud Review Submission
# Installed in: .git/hooks/post-push
# Usage: Called automatically after git push
# 
# CODEX-015: Install in forja, 852, carteira-livre repos

set -euo pipefail

# Only submit if push was successful
if [ $? -ne 0 ]; then
  exit 0
fi

REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME=$(basename "${REPO_PATH}")

# Skip if not an EGOS-related repo
case "${REPO_NAME}" in
  egos|852|forja|carteira-livre|smartbuscas) ;;
  *) exit 0 ;;
esac

echo "🤖 Codex: Submitting review for ${REPO_NAME}..."

# Call codex-submit-review.sh in background (non-blocking)
(
  if [ -f "${HOME}/.egos/scripts/codex-submit-review.sh" ]; then
    bash "${HOME}/.egos/scripts/codex-submit-review.sh" "${REPO_PATH}" 3 &
  fi
) >/dev/null 2>&1 &

echo "✅ Codex review queued (background)"
exit 0
