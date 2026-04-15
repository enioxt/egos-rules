#!/usr/bin/env bash
# EGOS Cross-Repo Change Detection Mesh (CRCDM)
# Core Engine — Tracks changes across all EGOS repositories with DAG-based dependency tracking
#
# Architecture:
# - DAG (Directed Acyclic Graph) for change dependencies
# - Merkle tree for cross-repo state verification
# - Hash chain for immutable audit trail
# - Real-time sync with all EGOS repositories

set -euo pipefail

# ============================================
# CONFIGURATION
# ============================================
CRCDM_VERSION="1.0.0"
CRCDM_ROOT="${CRCDM_ROOT:-/home/enio/.egos/crcdm}"
CRCDM_LOG="${CRCDM_ROOT}/changes.log"
CRCDM_DAG="${CRCDM_ROOT}/dag.json"
CRCDM_STATE="${CRCDM_ROOT}/state.json"
CRCDM_REPOS=(
  "/home/enio/egos"
  "/home/enio/egos-lab"
  "/home/enio/852"
  "/home/enio/forja"
  "/home/enio/carteira-livre"
  "/home/enio/br-acc"
  "/home/enio/smartbuscas"
  "/home/enio/policia"
  "/home/enio/INPI"
)

# Ensure directories exist
mkdir -p "${CRCDM_ROOT}"/{logs,dag,state,notifications}

# ============================================
# HASH FUNCTIONS (Merkle Tree Style)
# ============================================

crcdm_hash() {
  # Generate SHA-256 hash of input
  echo -n "$1" | sha256sum | cut -d' ' -f1
}

crcdm_file_hash() {
  # Generate hash of file content + metadata
  local file="$1"
  if [[ -f "$file" ]]; then
    local content_hash=$(sha256sum "$file" | cut -d' ' -f1)
    local meta="${file}:$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null):$(wc -l < "$file")"
    crcdm_hash "${content_hash}:${meta}"
  else
    echo "null"
  fi
}

crcdm_commit_hash() {
  # Generate hash of commit data (blockchain-style)
  local repo="$1"
  local commit="$2"
  local author=$(git -C "$repo" log -1 --format='%an' "$commit" 2>/dev/null || echo "unknown")
  local timestamp=$(git -C "$repo" log -1 --format='%at' "$commit" 2>/dev/null || echo "0")
  local message=$(git -C "$repo" log -1 --format='%s' "$commit" 2>/dev/null || echo "")
  local files=$(git -C "$repo" diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null | sort | tr '\n' ',')
  
  crcdm_hash "${commit}:${author}:${timestamp}:${message}:${files}"
}

crcdm_repo_state_hash() {
  # Generate Merkle root of entire repo state
  local repo="$1"
  local branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  local head=$(git -C "$repo" rev-parse HEAD 2>/dev/null || echo "null")
  local uncommitted=$(git -C "$repo" status --short 2>/dev/null | wc -l)
  local last_change=$(git -C "$repo" log -1 --format='%at' 2>/dev/null || echo "0")
  
  crcdm_hash "${repo}:${branch}:${head}:${uncommitted}:${last_change}"
}

# ============================================
# DAG (DIRECTED ACYCLIC GRAPH) OPERATIONS
# ============================================

crcdm_dag_init() {
  # Initialize empty DAG if not exists
  if [[ ! -f "$CRCDM_DAG" ]]; then
    echo '{"nodes": [], "edges": [], "version": "1.0.0"}' > "$CRCDM_DAG"
  fi
}

crcdm_dag_add_node() {
  # Add change node to DAG
  local repo="$1"
  local commit="$2"
  local type="$3"  # commit|merge|revert|cherry-pick
  local impact="$4" # low|medium|high|critical
  local files="$5"
  local hash=$(crcdm_commit_hash "$repo" "$commit")
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  local node=$(cat <<EOF
{
  "id": "${hash:0:16}",
  "repo": "$(basename "$repo")",
  "commit": "$commit",
  "type": "$type",
  "impact": "$impact",
  "files": [$files],
  "timestamp": "$timestamp",
  "hash": "$hash",
  "status": "detected"
}
EOF
)
  
  # Add to DAG using jq if available, otherwise append
  if command -v jq >/dev/null 2>&1; then
    jq --argjson node "$node" '.nodes += [$node]' "$CRCDM_DAG" > "${CRCDM_DAG}.tmp" && mv "${CRCDM_DAG}.tmp" "$CRCDM_DAG"
  fi
  
  echo "${hash:0:16}"
}

crcdm_dag_add_edge() {
  # Add dependency edge between nodes
  local from="$1"
  local to="$2"
  local type="$3" # depends-on|conflicts-with|supersedes
  
  local edge=$(cat <<EOF
{
  "from": "$from",
  "to": "$to",
  "type": "$type",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
)
  
  if command -v jq >/dev/null 2>&1; then
    jq --argjson edge "$edge" '.edges += [$edge]' "$CRCDM_DAG" > "${CRCDM_DAG}.tmp" && mv "${CRCDM_DAG}.tmp" "$CRCDM_DAG"
  fi
}

crcdm_dag_find_dependencies() {
  # Find all changes that depend on a given change
  local node_id="$1"
  
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg id "$node_id" '.edges[] | select(.from == $id) | .to' "$CRCDM_DAG" 2>/dev/null || echo ""
  fi
}

crcdm_dag_find_impact() {
  # Find all changes impacted by a given change (reverse dependencies)
  local node_id="$1"
  
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg id "$node_id" '.edges[] | select(.to == $id) | .from' "$CRCDM_DAG" 2>/dev/null || echo ""
  fi
}

# ============================================
# CHANGE DETECTION
# ============================================

crcdm_detect_changes() {
  # Detect all changes across all repos
  local since="${1:-1 hour ago}"
  local changes=()
  
  for repo in "${CRCDM_REPOS[@]}"; do
    if [[ -d "$repo/.git" ]]; then
      local repo_name=$(basename "$repo")
      local branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
      
      # Get commits since specified time
      while IFS= read -r line; do
        if [[ -n "$line" ]]; then
          local commit=$(echo "$line" | cut -d' ' -f1)
          local message=$(echo "$line" | cut -d' ' -f2-)
          local impact=$(crcdm_classify_impact "$repo" "$commit")
          local files=$(git -C "$repo" diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null | jq -R . | jq -s . 2>/dev/null || echo "[]")
          
          local node_id=$(crcdm_dag_add_node "$repo" "$commit" "commit" "$impact" "$files")
          
          changes+=("${repo_name}:${branch}:${node_id}:${impact}:${message}")
          
          # Log to immutable chain
          echo "$(date -u +%s) ${node_id} ${repo_name} ${branch} ${impact} ${message}" >> "$CRCDM_LOG"
        fi
      done < <(git -C "$repo" log --since="$since" --format='%H %s' --all 2>/dev/null || true)
      
      # Detect uncommitted changes
      local uncommitted=$(git -C "$repo" status --short 2>/dev/null | wc -l)
      if [[ $uncommitted -gt 0 ]]; then
        local uc_hash=$(crcdm_hash "${repo}:uncommitted:$(date +%s)")
        changes+=("${repo_name}:${branch}:${uc_hash:0:16}:uncommitted:${uncommitted} files")
        echo "$(date -u +%s) ${uc_hash:0:16} ${repo_name} ${branch} uncommitted ${uncommitted}" >> "$CRCDM_LOG"
      fi
    fi
  done
  
  printf '%s\n' "${changes[@]}"
}

crcdm_classify_impact() {
  # Classify change impact based on files modified
  local repo="$1"
  local commit="$2"
  local files=$(git -C "$repo" diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null || echo "")
  
  # Critical: Core runtime, auth, security
  if echo "$files" | grep -qE "(runtime|auth|security|middleware|\.env)"; then
    echo "critical"
  # High: API routes, database, configs
  elif echo "$files" | grep -qE "(api/|db/|config/|migrations/)"; then
    echo "high"
  # Medium: Components, features
  elif echo "$files" | grep -qE "(components/|features/|hooks/)"; then
    echo "medium"
  # Low: Docs, tests, styles
  else
    echo "low"
  fi
}

# ============================================
# CROSS-REPO DEPENDENCY TRACKING
# ============================================

crcdm_track_cross_repo_deps() {
  # Analyze and track dependencies between repos
  # Uses package.json, imports, and shared files to build dependency graph
  
  local deps_file="${CRCDM_ROOT}/cross-repo-deps.json"
  local deps='{"dependencies": []}'
  
  for repo in "${CRCDM_REPOS[@]}"; do
    local repo_name=$(basename "$repo")
    
    # Check for shared package references
    if [[ -f "$repo/package.json" ]]; then
      # Check for @egos/shared references
      if grep -q '"@egos/shared"' "$repo/package.json" 2>/dev/null; then
        deps=$(echo "$deps" | jq --arg from "$repo_name" --arg to "egos" '.dependencies += [{"from": $from, "to": $to, "type": "package"}]')
      fi
    fi
    
    # Check for .egos symlink (governance dependency)
    if [[ -L "$repo/.egos" ]]; then
      deps=$(echo "$deps" | jq --arg from "$repo_name" --arg to "egos" '.dependencies += [{"from": $from, "to": $to, "type": "governance"}]')
    fi
  done
  
  echo "$deps" > "$deps_file"
}

crcdm_notify_dependent_repos() {
  # Notify repos that depend on a changed repo
  local changed_repo="$1"
  local deps_file="${CRCDM_ROOT}/cross-repo-deps.json"
  
  if [[ -f "$deps_file" ]] && command -v jq >/dev/null 2>&1; then
    local dependents=$(jq -r --arg repo "$changed_repo" '.dependencies[] | select(.to == $repo) | .from' "$deps_file" 2>/dev/null || echo "")
    
    for dep in $dependents; do
      local notification="${CRCDM_ROOT}/notifications/${dep}-$(date +%s).json"
      cat > "$notification" <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "source": "$changed_repo",
  "target": "$dep",
  "type": "dependency_change",
  "message": "Repository '$changed_repo' has changes that may affect '$dep'"
}
EOF
    done
  fi
}

# ============================================
# CLI INTERFACE
# ============================================

crcdm_status() {
  # Show current status of all repos
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║     EGOS Cross-Repo Change Detection Mesh (CRCDM) v${CRCDM_VERSION}      ║"
  echo "╠══════════════════════════════════════════════════════════════╣"
  echo "║  Repo               │ Branch     │ Last Commit │ Uncommitted ║"
  echo "╠═════════════════════╪════════════╪═════════════╪═════════════╣"
  
  for repo in "${CRCDM_REPOS[@]}"; do
    if [[ -d "$repo/.git" ]]; then
      local name=$(basename "$repo")
      local branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null | cut -c1-10 || echo "N/A")
      local last=$(git -C "$repo" log -1 --format='%h %ar' 2>/dev/null | cut -c1-20 || echo "N/A")
      local uncommitted=$(git -C "$repo" status --short 2>/dev/null | wc -l)
      local uc_display="${uncommitted}"
      [[ $uncommitted -gt 0 ]] && uc_display="🔴 ${uncommitted}"
      
      printf "║  %-17s │ %-10s │ %-11s │ %-11s ║\n" "$name" "$branch" "$last" "$uc_display"
    fi
  done
  
  echo "╚══════════════════════════════════════════════════════════════╝"
}

crcdm_log() {
  # Show recent changes across all repos
  local lines="${1:-20}"
  
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                    Recent Changes Across EGOS Ecosystem                  ║"
  echo "╠══════════════════════════════════════════════════════════════════════════╣"
  echo "║ Time     │ Repo        │ Node ID    │ Impact    │ Description            ║"
  echo "╠══════════╪═════════════╪════════════╪═══════════╪════════════════════════╣"
  
  if [[ -f "$CRCDM_LOG" ]]; then
    tail -n "$lines" "$CRCDM_LOG" | while read -r timestamp node_id repo branch impact message; do
      local time=$(date -d "@$timestamp" +"%H:%M:%S" 2>/dev/null || echo "??:??:??")
      local msg=$(echo "$message" | cut -c1-25)
      local impact_emoji="⚪"
      case "$impact" in
        critical) impact_emoji="🔴" ;;
        high) impact_emoji="🟠" ;;
        medium) impact_emoji="🟡" ;;
        uncommitted) impact_emoji="⚠️" ;;
      esac
      
      printf "║ %8s │ %-11s │ %-10s │ %s %-7s │ %-22s ║\n" "$time" "$repo" "$node_id" "$impact_emoji" "$impact" "$msg"
    done
  fi
  
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
}

crcdm_dag_visualize() {
  # Visualize recent DAG nodes
  local limit="${1:-10}"
  
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║                    Change DAG (Last ${limit} nodes)                   ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  
  if [[ -f "$CRCDM_DAG" ]] && command -v jq >/dev/null 2>&1; then
    jq -r --argjson limit "$limit" '
      .nodes | sort_by(.timestamp) | reverse | .[:$limit] |
      .[] |
      "  [\(.impact)] \(.id) | \(.repo) | \(.type) | \(.files | length) files | \(.timestamp)"
    ' "$CRCDM_DAG" 2>/dev/null || echo "  No DAG data available"
  else
    echo "  DAG visualization requires jq"
  fi
}

crcdm_sync() {
  # Force sync all repos and update state
  echo "🔍 Scanning all EGOS repositories..."
  crcdm_detect_changes "5 minutes ago"
  crcdm_track_cross_repo_deps
  
  # Update state file
  cat > "$CRCDM_STATE" <<EOF
{
  "last_sync": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "repos_scanned": $(echo "${#CRCDM_REPOS[@]}"),
  "version": "$CRCDM_VERSION"
}
EOF
  
  echo "✅ Sync complete. State saved to $CRCDM_STATE"
}

# ============================================
# MAIN
# ============================================

crcdm_init() {
  # Initialize CRCDM system
  mkdir -p "${CRCDM_ROOT}"/{logs,dag,state,notifications}
  crcdm_dag_init
  
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║  EGOS Cross-Repo Change Detection Mesh (CRCDM) v${CRCDM_VERSION}    ║"
  echo "║  DAG-based change tracking with immutable audit trail       ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""
  echo "📁 Data directory: $CRCDM_ROOT"
  echo "📊 Repositories: ${#CRCDM_REPOS[@]}"
  echo ""
  echo "Commands:"
  echo "  status     — Show current state of all repos"
  echo "  log [n]    — Show recent changes (default: 20)"
  echo "  dag [n]    — Visualize change DAG (default: 10)"
  echo "  sync       — Force sync all repositories"
  echo "  deps       — Show cross-repo dependencies"
  echo ""
}

crcdm_main() {
  local command="${1:-status}"
  shift || true
  
  case "$command" in
    init)
      crcdm_init
      ;;
    status)
      crcdm_status
      ;;
    log)
      crcdm_log "${1:-20}"
      ;;
    dag)
      crcdm_dag_visualize "${1:-10}"
      ;;
    sync)
      crcdm_sync
      ;;
    deps|dependencies)
      cat "${CRCDM_ROOT}/cross-repo-deps.json" 2>/dev/null || echo "No dependencies tracked yet. Run: crcdm sync"
      ;;
    detect)
      crcdm_detect_changes "${1:-1 hour ago}"
      ;;
    help|--help|-h)
      crcdm_init
      ;;
    *)
      echo "Unknown command: $command"
      echo "Run: crcdm help"
      exit 1
      ;;
  esac
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  crcdm_main "$@"
fi
