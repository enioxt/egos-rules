#!/usr/bin/env bash
# EGOS Cross-Repo Change Detection Mesh (CRCDM)
# CLI Tool — Unified command interface
#
# USAGE: crcdm [command] [options]

set -euo pipefail

CRCDM_ROOT="${HOME}/.egos/crcdm"
CRCDM_VERSION="1.0.0"

# ============================================
# UTILITIES
# ============================================

crcdm_ensure_init() {
  if [ ! -d "$CRCDM_ROOT" ]; then
    echo "🔧 Initializing CRCDM..."
    mkdir -p "${CRCDM_ROOT}"/{logs,dag,state,notifications}
    echo '{"nodes": [], "edges": [], "version": "1.0.0"}' > "${CRCDM_ROOT}/dag/dag.json"
    echo "✅ CRCDM initialized at $CRCDM_ROOT"
  fi
}

crcdm_hash() {
  echo -n "$1" | sha256sum | cut -d' ' -f1
}

# ============================================
# COMMANDS
# ============================================

cmd_init() {
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║  EGOS Cross-Repo Change Detection Mesh (CRCDM) v${CRCDM_VERSION}    ║"
  echo "║  DAG-based change tracking with immutable audit trail       ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""
  
  crcdm_ensure_init
  
  echo "📁 Data directory: $CRCDM_ROOT"
  echo ""
  echo "Subsystems:"
  echo "  📊 DAG (Directed Acyclic Graph) — Change dependency tracking"
  echo "  🔗 Hash Chain — Immutable audit trail"
  echo "  🌐 Cross-Repo — Dependency mapping"
  echo "  🔔 Notifications — Real-time change alerts"
  echo ""
  echo "Commands:"
  echo "  status     — Show current state of all repos"
  echo "  log [n]    — Show recent changes (default: 20)"
  echo "  dag [n]    — Visualize change DAG"
  echo "  sync       — Force sync all repositories"
  echo "  deps       — Show cross-repo dependencies"
  echo "  mesh       — Full mesh visualization"
  echo "  install    — Install hooks to all EGOS repos"
  echo "  workflow   — Workflow integration (start/end/disseminate)"
  echo ""
  echo "Aliases (add to .bashrc):"
  echo '  alias crcdm="source ~/.egos/crcdm/crcdm-cli.sh"'
  echo '  alias egos-mesh="crcdm mesh"'
  echo '  alias egos-changes="crcdm log"'
  echo ""
}

cmd_status() {
  crcdm_ensure_init
  
  local repos=(
    "/home/enio/egos:egos"
    "/home/enio/egos-lab:egos-lab"
    "/home/enio/852:852"
    "/home/enio/forja:forja"
    "/home/enio/carteira-livre:carteira-livre"
    "/home/enio/br-acc:br-acc"
    "/home/enio/smartbuscas:smartbuscas"
    "/home/enio/policia:policia"
    "/home/enio/INPI:INPI"
  )
  
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║        EGOS Change Detection Mesh — Repository Status        ║"
  echo "╠════════════════════════════════════════════════════════════════╣"
  printf "║ %-15s │ %-10s │ %-20s │ %-10s ║\n" "Repository" "Branch" "Last Commit" "Changes"
  echo "╠═════════════════╪════════════╪══════════════════════╪════════════╣"
  
  local total_commits=0
  local total_uncommitted=0
  
  for repo_info in "${repos[@]}"; do
    IFS=':' read -r path name <<< "$repo_info"
    
    if [ -d "$path/.git" ]; then
      local branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null | cut -c1-10 || echo "N/A")
      local last_commit=$(git -C "$path" log -1 --format='%h %ar' 2>/dev/null | cut -c1-20 || echo "N/A")
      local uncommitted=$(git -C "$path" status --short 2>/dev/null | wc -l)
      local recent=$(git -C "$path" log --since="1 hour ago" --oneline 2>/dev/null | wc -l)
      
      local changes=""
      [ "$uncommitted" -gt 0 ] && changes="⚠️ ${uncommitted}"
      [ "$recent" -gt 0 ] && changes="${changes} 📦${recent}"
      [ -z "$changes" ] && changes="✓"
      
      total_commits=$((total_commits + recent))
      total_uncommitted=$((total_uncommitted + uncommitted))
      
      printf "║ %-15s │ %-10s │ %-20s │ %-10s ║\n" "$name" "$branch" "$last_commit" "$changes"
    else
      printf "║ %-15s │ %-10s │ %-20s │ %-10s ║\n" "$name" "N/A" "Not a repo" "—"
    fi
  done
  
  echo "╚═════════════════╧════════════╧══════════════════════╧════════════╝"
  echo ""
  echo "Summary: $total_commits commits in last hour, $total_uncommitted uncommitted files"
  
  # Show CRCDM state
  if [ -f "${CRCDM_ROOT}/dag/dag.json" ] && command -v jq >/dev/null 2>&1; then
    local node_count=$(jq '.nodes | length' "${CRCDM_ROOT}/dag/dag.json" 2>/dev/null || echo "0")
    local edge_count=$(jq '.edges | length' "${CRCDM_ROOT}/dag/dag.json" 2>/dev/null || echo "0")
    echo "CRCDM DAG: $node_count nodes, $edge_count edges"
  fi
}

cmd_log() {
  crcdm_ensure_init
  local lines="${1:-20}"
  
  # Aggregate all log files
  local all_logs="${CRCDM_ROOT}/logs/all.log"
  cat "${CRCDM_ROOT}/logs/"*.log 2>/dev/null | sort -t' ' -k1 -n -r | head -n "$lines" > "$all_logs" 2>/dev/null || true
  
  echo "╔════════════════════════════════════════════════════════════════════════════╗"
  echo "║                    Recent Changes Across EGOS Ecosystem                  ║"
  echo "╠════════════════════════════════════════════════════════════════════════════╣"
  printf "║ %-8s │ %-11s │ %-10s │ %-8s │ %-28s ║\n" "Time" "Repository" "Node ID" "Impact" "Description"
  echo "╠══════════╪═════════════╪════════════╪══════════╪════════════════════════════╣"
  
  if [ -f "$all_logs" ]; then
    while IFS=' ' read -r timestamp node_id repo branch impact message; do
      [ -z "$timestamp" ] && continue
      
      local time=$(date -d "@$timestamp" +"%H:%M:%S" 2>/dev/null || echo "??:??:??")
      local msg=$(echo "$message" | cut -c1-28)
      local impact_emoji="⚪"
      
      case "$impact" in
        critical) impact_emoji="🔴" ;;
        high) impact_emoji="🟠" ;;
        medium) impact_emoji="🟡" ;;
        low) impact_emoji="⚪" ;;
        uncommitted) impact_emoji="⚠️" ;;
      esac
      
      printf "║ %8s │ %-11s │ %-10s │ %s %-6s │ %-28s ║\n" "$time" "$repo" "$node_id" "$impact_emoji" "$impact" "$msg"
    done < "$all_logs"
  fi
  
  echo "╚══════════╧═════════════╧════════════╧══════════╧════════════════════════════╝"
  echo ""
  echo "Showing last $lines entries. Run 'crcdm log 50' for more."
}

cmd_dag() {
  crcdm_ensure_init
  local limit="${1:-15}"
  
  echo "╔════════════════════════════════════════════════════════════════════════════╗"
  echo "║                      Change DAG (Last $limit nodes)                      ║"
  echo "╚════════════════════════════════════════════════════════════════════════════╝"
  echo ""
  
  if [ -f "${CRCDM_ROOT}/dag/dag.json" ] && command -v jq >/dev/null 2>&1; then
    echo "Recent nodes:"
    jq -r --argjson limit "$limit" '
      .nodes | 
      sort_by(.timestamp) | 
      reverse | 
      .[:$limit] |
      .[] |
      "  [\(.impact // "low")] \(.id) | \(.repo // "unknown") | \(.type // "unknown") | \(.timestamp // "N/A")"
    ' "${CRCDM_ROOT}/dag/dag.json" 2>/dev/null || echo "  No DAG data available"
    
    echo ""
    echo "Dependency edges:"
    jq -r '
      .edges |
      .[] |
      "  \(.from) → \(.to) [\(.type)]"
    ' "${CRCDM_ROOT}/dag/dag.json" 2>/dev/null | head -10 || echo "  No edges"
  else
    echo "  DAG data requires jq. Install: sudo apt install jq"
  fi
  
  echo ""
}

cmd_sync() {
  crcdm_ensure_init
  
  echo "🔍 Scanning all EGOS repositories..."
  echo ""
  
  local repos=(
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
  
  local total_changes=0
  
  for repo in "${repos[@]}"; do
    if [ -d "$repo/.git" ]; then
      local name=$(basename "$repo")
      local recent=$(git -C "$repo" log --since="5 minutes ago" --oneline 2>/dev/null | wc -l)
      local uncommitted=$(git -C "$repo" status --short 2>/dev/null | wc -l)
      
      if [ "$recent" -gt 0 ] || [ "$uncommitted" -gt 0 ]; then
        echo "  📦 $name: $recent recent commits, $uncommitted uncommitted"
        total_changes=$((total_changes + recent + uncommitted))
      fi
    fi
  done
  
  echo ""
  echo "✅ Sync complete. Detected $total_changes changes."
  
  # Update state
  cat > "${CRCDM_ROOT}/state/last-sync.json" <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "changes_detected": $total_changes,
  "repos_scanned": ${#repos[@]}
}
EOF
}

cmd_deps() {
  crcdm_ensure_init
  
  echo "╔════════════════════════════════════════════════════════════════════════════╗"
  echo "║                    Cross-Repository Dependencies                           ║"
  echo "╚════════════════════════════════════════════════════════════════════════════╝"
  echo ""
  
  # Build dependency map
  local deps="{"
  
  for repo_path in /home/enio/egos-lab /home/enio/852 /home/enio/forja /home/enio/carteira-livre /home/enio/br-acc /home/enio/smartbuscas; do
    if [ -d "$repo_path/.git" ]; then
      local name=$(basename "$repo_path")
      local deps_list=""
      
      # Check for .egos symlink (governance dependency)
      if [ -L "$repo_path/.egos" ]; then
        deps_list="${deps_list}egos (governance), "
      fi
      
      # Check for @egos/shared reference
      if [ -f "$repo_path/package.json" ] && grep -q '"@egos/shared"' "$repo_path/package.json" 2>/dev/null; then
        deps_list="${deps_list}egos (package), "
      fi
      
      # Check for shared imports in code
      if grep -r "from.*@egos/shared" "$repo_path/src" 2>/dev/null | head -1 >/dev/null; then
        deps_list="${deps_list}egos (code), "
      fi
      
      if [ -n "$deps_list" ]; then
        echo "  📦 $name depends on: ${deps_list%, }"
      fi
    fi
  done
  
  echo ""
  echo "Legend:"
  echo "  governance — .egos symlink (shared rules)"
  echo "  package   — @egos/shared npm package"
  echo "  code      — Direct imports in source code"
}

cmd_mesh() {
  crcdm_ensure_init
  
  echo "╔════════════════════════════════════════════════════════════════════════════╗"
  echo "║                    EGOS Change Detection Mesh                             ║"
  echo "╚════════════════════════════════════════════════════════════════════════════╝"
  echo ""
  
  cmd_status
  echo ""
  cmd_deps
  echo ""
  cmd_dag 10
  
  # Recent notifications
  local notifs=$(find "${CRCDM_ROOT}/notifications" -name "*.json" -mmin -1440 2>/dev/null | wc -l)
  if [ "$notifs" -gt 0 ]; then
    echo ""
    echo "🔔 Recent notifications: $notifs (last 24h)"
  fi
}

cmd_install() {
  if [ -f "${CRCDM_ROOT}/crcdm-install-hooks.sh" ]; then
    bash "${CRCDM_ROOT}/crcdm-install-hooks.sh"
  else
    echo "❌ Hook installer not found"
    exit 1
  fi
}

cmd_workflow() {
  if [ -f "${CRCDM_ROOT}/crcdm-workflow-integration.sh" ]; then
    bash "${CRCDM_ROOT}/crcdm-workflow-integration.sh" "$@"
  else
    echo "❌ Workflow integration not found"
    exit 1
  fi
}

cmd_help() {
  echo "EGOS CRCDM (Cross-Repo Change Detection Mesh) v${CRCDM_VERSION}"
  echo ""
  echo "USAGE: crcdm [command] [options]"
  echo ""
  echo "Commands:"
  echo "  init              Initialize CRCDM (first time setup)"
  echo "  status            Show repository status across all EGOS repos"
  echo "  log [n]           Show recent changes (default: 20 lines)"
  echo "  dag [n]           Visualize change DAG (default: 15 nodes)"
  echo "  sync              Force sync all repositories"
  echo "  deps              Show cross-repo dependencies"
  echo "  mesh              Full mesh visualization (status + deps + dag)"
  echo "  install           Install hooks to all EGOS repositories"
  echo "  workflow [cmd]    Workflow integration (start|end|disseminate)"
  echo "  help              Show this help"
  echo ""
  echo "Examples:"
  echo "  crcdm status                    # Quick status check"
  echo "  crcdm log 50                  # Show last 50 changes"
  echo "  crcdm mesh                    # Full mesh view"
  echo "  crcdm install                 # Install hooks"
  echo "  crcdm workflow start          # /start integration"
  echo ""
  echo "Environment:"
  echo "  CRCDM_ROOT    — Data directory (default: ~/.egos/crcdm)"
  echo ""
}

# ============================================
# MAIN
# ============================================

main() {
  local cmd="${1:-status}"
  shift || true
  
  case "$cmd" in
    init|setup)
      cmd_init
      ;;
    status|st)
      cmd_status
      ;;
    log|history|changes)
      cmd_log "${1:-20}"
      ;;
    dag|graph|visualize)
      cmd_dag "${1:-15}"
      ;;
    sync|scan|update)
      cmd_sync
      ;;
    deps|dependencies|links)
      cmd_deps
      ;;
    mesh|full|all)
      cmd_mesh
      ;;
    install|hooks|setup-hooks)
      cmd_install
      ;;
    workflow|wf)
      cmd_workflow "$@"
      ;;
    help|--help|-h)
      cmd_help
      ;;
    *)
      echo "Unknown command: $cmd"
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
