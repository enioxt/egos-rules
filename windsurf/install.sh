#!/usr/bin/env bash
# EGOS Windsurf Profile Installer — Linux / WSL2
# Applies .windsurfrules, settings.json, and mcp.json from this repo.
# Usage: bash install.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EGOS_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== EGOS Windsurf Profile Installer ==="
echo "Source: $SCRIPT_DIR"

# 1. .windsurfrules → global symlink
RULES_SRC="$EGOS_DIR/.windsurfrules"
RULES_DST="$HOME/.windsurfrules"
if [ -f "$RULES_SRC" ]; then
  ln -sf "$RULES_SRC" "$RULES_DST"
  echo "✓ .windsurfrules → $RULES_DST"
else
  echo "⚠ .windsurfrules not found at $RULES_SRC"
fi

# 2. settings.json → Windsurf user settings
SETTINGS_SRC="$SCRIPT_DIR/settings.json"
# Try both Windsurf paths
for WINDSURF_USER in \
  "$HOME/.windsurf-next/WindsurfNextUser/User" \
  "$HOME/.windsurf/WindsurfUser/User" \
  "$HOME/.config/Code/User"; do
  if [ -d "$WINDSURF_USER" ]; then
    cp "$SETTINGS_SRC" "$WINDSURF_USER/settings.json"
    echo "✓ settings.json → $WINDSURF_USER/settings.json"
    break
  fi
done

# 3. mcp.json — merge template with local .env secrets
MCP_TEMPLATE="$SCRIPT_DIR/mcp.template.json"
MCP_ENV="$EGOS_DIR/windsurf/.env.local"
MCP_DST="$HOME/.config/windsurf/mcp.json"

mkdir -p "$(dirname "$MCP_DST")"

if [ -f "$MCP_ENV" ]; then
  echo "✓ Found .env.local — substituting variables into mcp.json..."
  # Load env vars and substitute in template
  set -a; source "$MCP_ENV"; set +a
  envsubst < "$MCP_TEMPLATE" > "$MCP_DST"
  echo "✓ mcp.json written to $MCP_DST"
else
  echo "⚠ No .env.local found at $MCP_ENV"
  echo "  Copy mcp.template.json to mcp.json and fill in secrets manually:"
  echo "  cp $MCP_TEMPLATE $MCP_DST"
  echo "  Then edit: nano $MCP_DST"
fi

# 4. Extensions
echo ""
echo "=== Extensions to install (run in Windsurf terminal) ==="
echo "Paste this block in the Windsurf terminal:"
echo ""
echo "cat << 'EOF' | xargs -I{} windsurf --install-extension {}"
cat "$SCRIPT_DIR/extensions.list"
echo "EOF"

echo ""
echo "✅ Profile applied. Restart Windsurf to load new settings."
