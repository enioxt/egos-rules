#!/usr/bin/env bash
# EGOS CRCDM Workflow Integration
# Integrates with /start, /end, /disseminate workflows
# Part of Cross-Repo Change Detection Mesh (CRCDM)

set -euo pipefail

CRCDM_ROOT="${HOME}/.egos/crcdm"

crcdm_workflow_start() {
  # Called by /start workflow
  # Detects initial state and syncs with CRCDM
  
  echo "🔍 CRCDM /start — Initializing change detection..."
  
  # Ensure CRCDM is ready
  if [ ! -d "$CRCDM_ROOT" ]; then
    echo "  ⚠️ CRCDM not initialized. Running init..."
    crcdm_init_silent
  fi
  
  # Get current repo context
  REPO_PATH="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  REPO_NAME="$(basename "$REPO_PATH")"
  BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
  
  # Detect recent changes
  echo "  📊 Scanning for recent changes..."
  CHANGES=$(crcdm_detect_changes "1 hour ago" 2>/dev/null || echo "")
  
  if [ -n "$CHANGES" ]; then
    CHANGE_COUNT=$(echo "$CHANGES" | wc -l)
    echo "  📦 Found $CHANGE_COUNT recent changes in ecosystem"
  else
    echo "  ℹ️ No recent changes detected"
  fi
  
  # Check for critical notifications
  CRITICAL_NOTIFS=$(find "${CRCDM_ROOT}/notifications" -name "critical-*.json" -mmin -60 2>/dev/null || true)
  if [ -n "$CRITICAL_NOTIFS" ]; then
    CRIT_COUNT=$(echo "$CRITICAL_NOTIFS" | wc -l)
    echo "  🚨 $CRIT_COUNT CRITICAL notifications in last hour!"
    echo ""
    echo "  Recent critical changes:"
    for notif in $CRITICAL_NOTIFS; do
      if [ -f "$notif" ] && command -v jq >/dev/null 2>&1; then
        SOURCE=$(jq -r '.source' "$notif" 2>/dev/null || echo 'unknown')
        MSG=$(jq -r '.message' "$notif" 2>/dev/null | cut -c1-50 || echo '')
        echo "    🔴 $SOURCE: $MSG"
      fi
    done
    echo ""
  fi
  
  # Create /start node in DAG
  START_HASH=$(echo "${REPO_NAME}:start:$(date +%s)" | sha256sum | cut -d' ' -f1)
  START_ID="${START_HASH:0:16}"
  
  if command -v jq >/dev/null 2>&1; then
    DAG_FILE="${CRCDM_ROOT}/dag/dag.json"
    NODE=$(jq -n \
      --arg id "$START_ID" \
      --arg repo "$REPO_NAME" \
      --arg branch "$BRANCH" \
      --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      --arg changes "${CHANGE_COUNT:-0}" \
      '{id: $id, repo: $repo, branch: $branch, timestamp: $timestamp, type: "/start", status: "active", recent_changes: $changes}')
    
    if [ -f "$DAG_FILE" ]; then
      jq --argjson node "$NODE" '.nodes += [$node]' "$DAG_FILE" > "${DAG_FILE}.tmp" && mv "${DAG_FILE}.tmp" "$DAG_FILE"
    fi
  fi
  
  # Export for session context
  export CRCDM_SESSION_ID="$START_ID"
  export CRCDM_START_TIME="$(date -u +%s)"
  
  echo "  ✅ CRCDM session: ${START_ID}"
  echo ""
}

crcdm_workflow_end() {
  # Called by /end workflow
  # Records session completion and updates mesh
  
  echo "🔍 CRCDM /end — Finalizing change detection..."
  
  REPO_PATH="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  REPO_NAME="$(basename "$REPO_PATH")"
  BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
  
  # Get commits during this session
  if [ -n "${CRCDM_START_TIME:-}" ]; then
    SINCE="@${CRCDM_START_TIME}"
    SESSION_COMMITS=$(git log --since="$SINCE" --oneline 2>/dev/null || echo "")
    COMMIT_COUNT=$(echo "$SESSION_COMMITS" | grep -c . 2>/dev/null || echo '0')
  else
    COMMIT_COUNT=$(git log --since="1 hour ago" --oneline 2>/dev/null | grep -c . || echo '0')
  fi
  
  # Get uncommitted changes
  UNCOMMITTED=$(git status --short 2>/dev/null | wc -l)
  
  # Generate end hash
  END_HASH=$(echo "${REPO_NAME}:end:$(date +%s):${COMMIT_COUNT}" | sha256sum | cut -d' ' -f1)
  END_ID="${END_HASH:0:16}"
  
  # Create /end node
  if command -v jq >/dev/null 2>&1; then
    DAG_FILE="${CRCDM_ROOT}/dag/dag.json"
    NODE=$(jq -n \
      --arg id "$END_ID" \
      --arg repo "$REPO_NAME" \
      --arg branch "$BRANCH" \
      --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      --argjson commits "$COMMIT_COUNT" \
      --argjson uncommitted "$UNCOMMITTED" \
      '{id: $id, repo: $repo, branch: $branch, timestamp: $timestamp, type: "/end", status: "completed", commits: $commits, uncommitted: $uncommitted}')
    
    if [ -f "$DAG_FILE" ]; then
      jq --argjson node "$NODE" '.nodes += [$node]' "$DAG_FILE" > "${DAG_FILE}.tmp" && mv "${DAG_FILE}.tmp" "$DAG_FILE"
      
      # Create edge from /start to /end if we have session ID
      if [ -n "${CRCDM_SESSION_ID:-}" ]; then
        EDGE=$(jq -n \
          --arg from "$CRCDM_SESSION_ID" \
          --arg to "$END_ID" \
          --arg type "session-completes" \
          '{from: $from, to: $to, type: $type, timestamp: "'"$(date -u +"%Y-%m-%dT%H:%M:%SZ")"'"}')
        jq --argjson edge "$EDGE" '.edges += [$edge]' "$DAG_FILE" > "${DAG_FILE}.tmp" && mv "${DAG_FILE}.tmp" "$DAG_FILE"
      fi
    fi
  fi
  
  # Summary
  echo "  📊 Session Summary:"
  echo "    📝 Commits: $COMMIT_COUNT"
  echo "    ⚠️  Uncommitted: $UNCOMMITTED"
  
  if [ "$UNCOMMITTED" -gt 0 ]; then
    echo ""
    echo "    💡 Remember to commit before next session!"
  fi
  
  echo "  ✅ CRCDM session end: ${END_ID}"
  echo ""
  
  # Clean up session env
  unset CRCDM_SESSION_ID 2>/dev/null || true
  unset CRCDM_START_TIME 2>/dev/null || true
}

crcdm_workflow_disseminate() {
  # Called by /disseminate workflow
  # Prepares change data for cross-repo sync
  
  echo "🔍 CRCDM /disseminate — Preparing change report..."
  
  REPO_PATH="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  REPO_NAME="$(basename "$REPO_PATH")"
  
  # Get changes to disseminate
  CHANGES_SINCE="${1:-24 hours ago}"
  
  echo "  📦 Collecting changes since: $CHANGES_SINCE"
  
  # Generate dissemination report
  REPORT_FILE="${CRCDM_ROOT}/disseminate-report-$(date +%s).json"
  
  cat > "$REPORT_FILE" <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "source": "$REPO_NAME",
  "since": "$CHANGES_SINCE",
  "changes": [],
  "cross_repo_impact": [],
  "notifications": []
}
EOF
  
  # Collect recent DAG nodes
  if command -v jq >/dev/null 2>&1 && [ -f "${CRCDM_ROOT}/dag/dag.json" ]; then
    RECENT_NODES=$(jq --arg since "$CHANGES_SINCE" '
      .nodes | 
      map(select(.timestamp >= $since)) |
      group_by(.repo) |
      map({repo: .[0].repo, count: length, impacts: map(.impact) | unique})
    ' "${CRCDM_ROOT}/dag/dag.json" 2>/dev/null || echo '[]')
    
    echo "  📊 Changes by repository:"
    echo "$RECENT_NODES" | jq -r '.[] | "    \(.repo): \(.count) changes"' 2>/dev/null || true
  fi
  
  # Check for pending notifications
  NOTIFICATIONS=$(find "${CRCDM_ROOT}/notifications" -name "*.json" -mmin -1440 2>/dev/null || true)
  NOTIF_COUNT=$(echo "$NOTIFICATIONS" | grep -c . 2>/dev/null || echo '0')
  
  if [ "$NOTIF_COUNT" -gt 0 ]; then
    echo ""
    echo "  🔔 $NOTIF_COUNT pending notifications"
  fi
  
  # Update disseminate node in DAG
  DISS_HASH=$(echo "${REPO_NAME}:disseminate:$(date +%s)" | sha256sum | cut -d' ' -f1)
  DISS_ID="${DISS_HASH:0:16}"
  
  if command -v jq >/dev/null 2>&1; then
    DAG_FILE="${CRCDM_ROOT}/dag/dag.json"
    NODE=$(jq -n \
      --arg id "$DISS_ID" \
      --arg repo "$REPO_NAME" \
      --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      --argjson notif_count "$NOTIF_COUNT" \
      --arg report "$REPORT_FILE" \
      '{id: $id, repo: $repo, timestamp: $timestamp, type: "/disseminate", status: "prepared", notifications: $notif_count, report: $report}')
    
    if [ -f "$DAG_FILE" ]; then
      jq --argjson node "$NODE" '.nodes += [$node]' "$DAG_FILE" > "${DAG_FILE}.tmp" && mv "${DAG_FILE}.tmp" "$DAG_FILE"
    fi
  fi
  
  echo "  ✅ CRCDM disseminate: ${DISS_ID}"
  echo "  📝 Report: $REPORT_FILE"
  echo ""
  echo "  💡 Changes ready for cross-repo sync"
}

crcdm_init_silent() {
  mkdir -p "${CRCDM_ROOT}"/{logs,dag,state,notifications}
  
  if [ ! -f "${CRCDM_ROOT}/dag/dag.json" ]; then
    echo '{"nodes": [], "edges": [], "version": "1.0.0"}' > "${CRCDM_ROOT}/dag/dag.json"
  fi
}

crcdm_detect_changes() {
  # Simple change detection (fallback if main crcdm.sh not available)
  local since="${1:-1 hour ago}"
  
  for repo in egos egos-lab 852 forja carteira-livre br-acc smartbuscas; do
    repo_path="/home/enio/$repo"
    if [ -d "$repo_path/.git" ]; then
      git -C "$repo_path" log --since="$since" --format="%h %s" 2>/dev/null || true
    fi
  done
}

# Main entry point for workflow integration
case "${1:-}" in
  start)
    crcdm_workflow_start
    ;;
  end)
    crcdm_workflow_end
    ;;
  disseminate)
    crcdm_workflow_disseminate "${2:-}"
    ;;
  *)
    echo "Usage: $0 {start|end|disseminate}"
    exit 1
    ;;
esac
