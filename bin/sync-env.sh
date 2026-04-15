#!/usr/bin/env bash
# ~/.egos/bin/sync-env.sh — Sync canonical keys to a project .env
# Usage: bash ~/.egos/bin/sync-env.sh <project-path> [--profile <name>]
# Profiles: llm (LLM only), full (everything), search (search APIs)
#
# New project setup:
#   bash ~/.egos/bin/sync-env.sh /home/enio/contributions/my-project
#   → creates .env with canonical keys, skips if already set

set -euo pipefail
VAULT="$HOME/.egos/secrets.env"
PROJECT="${1:-$(pwd)}"
PROFILE="${3:-llm}"  # default: only LLM keys

if [ ! -f "$VAULT" ]; then
  echo "ERROR: $VAULT not found. Canonical vault missing." >&2
  exit 1
fi

TARGET="$PROJECT/.env"

# Keys by profile
LLM_KEYS="GEMINI_API_KEY OPENROUTER_API_KEY OPENROUTER_MODEL ANTHROPIC_API_KEY ALIBABA_DASHSCOPE_API_KEY ALIBABA_DASHSCOPE_BASE_URL GROQ_API_KEY"
SEARCH_KEYS="EXA_API_KEY SERPER_API_KEY BRAVE_API"
INFRA_KEYS="GITHUB_TOKEN SUPABASE_ACCESS_TOKEN HUGGINGFACE_TOKEN"
ALL_KEYS="$LLM_KEYS $SEARCH_KEYS $INFRA_KEYS X_API_KEY X_API_SECRET X_ACCESS_TOKEN X_ACCESS_TOKEN_SECRET"

case "$PROFILE" in
  llm)    KEYS="$LLM_KEYS" ;;
  search) KEYS="$LLM_KEYS $SEARCH_KEYS" ;;
  full)   KEYS="$ALL_KEYS" ;;
  *)      KEYS="$LLM_KEYS" ;;
esac

echo "Syncing to: $TARGET (profile: $PROFILE)"

# Source the vault
source "$VAULT"

# Touch or append — skip keys already in .env
touch "$TARGET"
for KEY in $KEYS; do
  VAL="${!KEY:-}"
  if [ -z "$VAL" ]; then continue; fi
  if grep -q "^${KEY}=" "$TARGET" 2>/dev/null; then
    echo "  SKIP (exists): $KEY"
  else
    echo "$KEY=$VAL" >> "$TARGET"
    echo "  ADDED: $KEY"
  fi
done

echo ""
echo "Done. Review $TARGET before committing."
echo "Make sure $TARGET is in .gitignore!"
