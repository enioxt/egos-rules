#!/bin/bash
# ═══════════════════════════════════════════════════════════
# 🔗 EGOS Governance Symlink Converter
# Replaces local copies with symlinks to ~/.egos/ canonical source
# 
# DRY-RUN: ./governance-symlink.sh --dry
# EXECUTE: ./governance-symlink.sh --exec
# ═══════════════════════════════════════════════════════════

set -e

EGOS_HOME="$HOME/.egos"
MODE="${1:---dry}"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPOS=(
  "$HOME/852"
  "$HOME/egos-lab"
  "$HOME/carteira-livre"
  "$HOME/br-acc"
  "$HOME/forja"
  "$HOME/egos-self"
)

# Shared directories to symlink (whole directory)
SHARED_DIRS=(orchestration philosophy prompts refinery)

# Shared files to symlink (individual)
SHARED_FILES=(SEPARATION_POLICY.md preprocessor.md)

echo "🔗 EGOS Governance Symlink Converter (mode: $MODE)"
echo "═══════════════════════════════════════════════════"

CHANGES=0

for repo in "${REPOS[@]}"; do
  repo_name=$(basename "$repo")
  [ ! -d "$repo" ] && continue
  echo -e "\n${GREEN}📂 $repo_name${NC}"

  # ── .windsurfrules ──
  if [ -L "$repo/.windsurfrules" ]; then
    echo -e "  .windsurfrules: ${YELLOW}repo-local only — investigate manually${NC}"
  elif [ -f "$repo/.windsurfrules" ]; then
    echo -e "  .windsurfrules: ${GREEN}repo-local preserved${NC}"
  fi

  # ── Shared directories ──
  for dir in "${SHARED_DIRS[@]}"; do
    local_dir="$repo/.guarani/$dir"
    canonical_dir="$EGOS_HOME/guarani/$dir"
    if [ -d "$local_dir" ] && [ ! -L "$local_dir" ] && [ -d "$canonical_dir" ]; then
      echo -e "  .guarani/$dir/: LOCAL → symlink to ~/.egos/guarani/$dir/"
      if [ "$MODE" = "--exec" ]; then
        rm -rf "$local_dir"
        ln -sf "$canonical_dir" "$local_dir"
      fi
      CHANGES=$((CHANGES+1))
    elif [ -L "$local_dir" ]; then
      echo -e "  .guarani/$dir/: ${GREEN}already symlink${NC}"
    elif [ ! -e "$local_dir" ] && [ -d "$canonical_dir" ]; then
      echo -e "  .guarani/$dir/: MISSING → create symlink"
      if [ "$MODE" = "--exec" ]; then
        mkdir -p "$repo/.guarani"
        ln -sf "$canonical_dir" "$local_dir"
      fi
      CHANGES=$((CHANGES+1))
    fi
  done

  # ── Shared files ──
  for file in "${SHARED_FILES[@]}"; do
    local_file="$repo/.guarani/$file"
    canonical_file="$EGOS_HOME/guarani/$file"
    if [ -f "$local_file" ] && [ ! -L "$local_file" ] && [ -f "$canonical_file" ]; then
      echo -e "  .guarani/$file: LOCAL → symlink"
      if [ "$MODE" = "--exec" ]; then
        rm "$local_file"
        ln -sf "$canonical_file" "$local_file"
      fi
      CHANGES=$((CHANGES+1))
    elif [ -L "$local_file" ]; then
      echo -e "  .guarani/$file: ${GREEN}already symlink${NC}"
    elif [ ! -e "$local_file" ] && [ -f "$canonical_file" ]; then
      echo -e "  .guarani/$file: MISSING → create symlink"
      if [ "$MODE" = "--exec" ]; then
        mkdir -p "$repo/.guarani"
        ln -sf "$canonical_file" "$local_file"
      fi
      CHANGES=$((CHANGES+1))
    fi
  done
done

echo ""
echo "═══════════════════════════════════════════════════"
if [ "$MODE" = "--dry" ]; then
  echo -e "${YELLOW}DRY-RUN: $CHANGES changes would be made. Run with --exec to apply.${NC}"
else
  echo -e "${GREEN}DONE: $CHANGES changes applied.${NC}"
fi
