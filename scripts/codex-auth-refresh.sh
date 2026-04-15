#!/usr/bin/env bash
# codex-auth-refresh.sh — EGOS Codex Auth Maintenance
# Keeps Codex CLI tokens alive. Syncs local <-> VPS.
# Called by: cron (daily), /start
#
# Auth strategy:
#   Local: run 'codex login' to get fresh OAuth tokens (requires browser once)
#   VPS: sync from local OR run headless token refresh via codex command
#
# IMPORTANT: Never store actual token values in scripts or logs.

set -euo pipefail

AUTH_FILE="${HOME}/.codex/auth.json"
LOG_FILE="${HOME}/.egos/codex-reviews/auth.log"
VPS_HOST="root@204.168.217.125"
VPS_KEY="${HOME}/.ssh/hetzner_ed25519"
VPS_AUTH_PATH="/root/.codex/auth.json"

mkdir -p "$(dirname "${LOG_FILE}")"

log() { echo "[$(date -u +%H:%M:%SZ)] $*" | tee -a "${LOG_FILE}"; }

log "=== codex-auth-refresh START ==="

# Step 1: Verify local auth is working
if ! command -v codex >/dev/null 2>&1; then
  log "ERROR: codex CLI not installed locally"
  exit 1
fi

# Test if local auth works by running a lightweight command
log "Testing local auth..."
if codex cloud list >/dev/null 2>&1; then
  LOCAL_OK=true
  log "✅ Local auth: working"
else
  LOCAL_OK=false
  log "⚠️  Local auth: NOT working"
fi

# Step 2: Check auth.json last_refresh age
if [ -f "${AUTH_FILE}" ]; then
  LAST_REFRESH=$(python3 -c "
import json, datetime
with open('${AUTH_FILE}') as f:
    d = json.load(f)
lr = d.get('last_refresh', '')
if lr:
    dt = datetime.datetime.fromisoformat(lr.replace('Z',''))
    age = (datetime.datetime.utcnow() - dt).days
    print(age)
else:
    print(999)
" 2>/dev/null || echo "999")
  log "Auth last_refresh age: ${LAST_REFRESH} days"
else
  LAST_REFRESH=999
  log "No auth.json found"
fi

# Step 3: Test VPS auth
log "Testing VPS auth..."
VPS_OK=false
if ssh -i "${VPS_KEY}" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "${VPS_HOST}" \
   "codex cloud list >/dev/null 2>&1" 2>/dev/null; then
  VPS_OK=true
  log "✅ VPS auth: working"
else
  log "⚠️  VPS auth: NOT working"
fi

# Step 4: Sync strategy
if [ "${LOCAL_OK}" = "true" ] && [ "${VPS_OK}" = "false" ]; then
  log "Syncing local auth → VPS..."
  scp -i "${VPS_KEY}" -o StrictHostKeyChecking=no "${AUTH_FILE}" "${VPS_HOST}:${VPS_AUTH_PATH}"
  log "✅ Auth synced to VPS"
elif [ "${LOCAL_OK}" = "false" ] && [ "${VPS_OK}" = "true" ]; then
  log "Syncing VPS auth → local..."
  scp -i "${VPS_KEY}" -o StrictHostKeyChecking=no "${VPS_HOST}:${VPS_AUTH_PATH}" "${AUTH_FILE}"
  log "✅ Auth synced from VPS"
elif [ "${LOCAL_OK}" = "false" ] && [ "${VPS_OK}" = "false" ]; then
  log "⚠️  BOTH local and VPS auth are invalid"
  log "   Action required: run 'codex login' (opens browser for ChatGPT OAuth)"
  log "   Then re-run: ~/.egos/scripts/codex-auth-refresh.sh"
  echo "⚠️  Codex auth expired on both local and VPS."
  echo "   Run: codex login"
  exit 1
fi

# Step 5: Trigger token refresh on VPS by running a lightweight command
log "Triggering VPS token refresh..."
ssh -i "${VPS_KEY}" -o StrictHostKeyChecking=no "${VPS_HOST}" \
  "codex cloud list >/dev/null 2>&1 && echo refreshed" 2>/dev/null || true

log "=== DONE ==="
echo "✅ Codex auth: local=${LOCAL_OK} vps=${VPS_OK}"
