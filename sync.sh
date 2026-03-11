#!/bin/bash
# ═══════════════════════════════════════════════════════════
# 🔄 EGOS Sync v2.0 — Shared Governance + Workflows + Skills
# 
# Creates symlinks for governance, workflows, and skills
# in ALL registered repos. Works with both Windsurf and Gemini.
#
# Usage: ~/.egos/sync.sh
# ═══════════════════════════════════════════════════════════

set -e

EGOS_HOME="$HOME/.egos"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔄 EGOS Sync v2.0 — Governance + Workflows + Skills"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ── Registered repos ──
# Standard code repos that consume shared governance directly.
# Intentionally excluded:
# - "$HOME/policia"   (sensitive/private workflow, isolated rules)
# - "$HOME/personal"  (non-code/personal artifacts)
REPOS=(
  "$HOME/852"
  "$HOME/egos-lab"
  "$HOME/carteira-livre"
  "$HOME/br-acc"
  "$HOME/forja"
  "$HOME/egos-self"
)

# ── Step 1: Validate central governance ──
echo "📋 Step 1: Validating central governance..."
REQUIRED=(
  "guarani/IDENTITY.md"
  "guarani/PREFERENCES_SHARED.md"
  "guarani/SACRED_CODE.md"
  "README.md"
)
for file in "${REQUIRED[@]}"; do
  if [ -f "$EGOS_HOME/$file" ]; then
    echo -e "   ${GREEN}✅${NC} $file"
  else
    echo -e "   ${RED}❌${NC} MISSING: $file"
    exit 1
  fi
done

# Count workflows and skills
WF_COUNT=$(ls "$EGOS_HOME/workflows/"*.md 2>/dev/null | wc -l)
SKILL_COUNT=$(find "$EGOS_HOME/skills" -name "SKILL.md" 2>/dev/null | wc -l)
echo -e "   ${GREEN}✅${NC} $WF_COUNT workflows available"
echo -e "   ${GREEN}✅${NC} $SKILL_COUNT skills available"

# ── Step 2: Sync each repo ──
echo ""
echo "📋 Step 2: Syncing to repos..."

for repo in "${REPOS[@]}"; do
  repo_name=$(basename "$repo")
  
  if [ ! -d "$repo" ]; then
    echo -e "   ${YELLOW}⚠️${NC}  $repo_name — Not found, skipping"
    continue
  fi

  echo -e "\n   ${BLUE}📂 $repo_name${NC}"

  # ── A. Governance symlink (.egos → ~/.egos) ──
  if [ -L "$repo/.egos" ]; then
    target=$(readlink -f "$repo/.egos")
    if [ "$target" = "$EGOS_HOME" ]; then
      echo -e "      ${GREEN}✅${NC} .egos symlink OK"
    else
      rm "$repo/.egos"
      ln -sf "$EGOS_HOME" "$repo/.egos"
      echo -e "      ${GREEN}🔗${NC} .egos symlink fixed"
    fi
  elif [ ! -e "$repo/.egos" ]; then
    ln -sf "$EGOS_HOME" "$repo/.egos"
    echo -e "      ${GREEN}🔗${NC} .egos symlink created"
  fi

  # ── B. Workflow symlinks ──
  # Detect agent type
  IS_WINDSURF=false
  IS_GEMINI=false
  [ -d "$repo/.windsurf" ] && IS_WINDSURF=true
  [ -d "$repo/.agent" ] && IS_GEMINI=true
  
  # If neither exists, create both (new repo)
  if ! $IS_WINDSURF && ! $IS_GEMINI; then
    IS_GEMINI=true  # Default to Gemini format
  fi

  # Gemini: .agent/workflows/ 
  if $IS_GEMINI; then
    mkdir -p "$repo/.agent/workflows"
    for wf in "$EGOS_HOME/workflows/"*.md; do
      wf_name=$(basename "$wf")
      target="$repo/.agent/workflows/$wf_name"
      if [ ! -e "$target" ]; then
        ln -sf "$wf" "$target"
        echo -e "      ${GREEN}🔗${NC} .agent/workflows/$wf_name"
      elif [ -L "$target" ]; then
        echo -e "      ${GREEN}✅${NC} .agent/workflows/$wf_name"
      else
        echo -e "      ${YELLOW}⚠️${NC}  .agent/workflows/$wf_name — LOCAL override exists"
      fi
    done
  fi

  # Windsurf: .windsurf/workflows/
  if $IS_WINDSURF; then
    mkdir -p "$repo/.windsurf/workflows"
    for wf in "$EGOS_HOME/workflows/"*.md; do
      wf_name=$(basename "$wf")
      target="$repo/.windsurf/workflows/$wf_name"
      if [ ! -e "$target" ]; then
        ln -sf "$wf" "$target"
        echo -e "      ${GREEN}🔗${NC} .windsurf/workflows/$wf_name"
      elif [ -L "$target" ]; then
        # Update symlink to point to latest
        rm "$target"
        ln -sf "$wf" "$target"
        echo -e "      ${GREEN}🔄${NC} .windsurf/workflows/$wf_name (updated)"
      else
        echo -e "      ${YELLOW}⚠️${NC}  .windsurf/workflows/$wf_name — LOCAL override exists"
      fi
    done
  fi

  # ── C. Skills symlinks ──
  if [ -d "$EGOS_HOME/skills" ]; then
    # Gemini
    if $IS_GEMINI; then
      mkdir -p "$repo/.agent/skills"
      for skill_dir in "$EGOS_HOME/skills/"/*/; do
        skill_name=$(basename "$skill_dir")
        target="$repo/.agent/skills/$skill_name"
        if [ ! -e "$target" ]; then
          ln -sf "$skill_dir" "$target"
          echo -e "      ${GREEN}🔗${NC} .agent/skills/$skill_name"
        elif [ -L "$target" ]; then
          echo -e "      ${GREEN}✅${NC} .agent/skills/$skill_name"
        else
          echo -e "      ${YELLOW}⚠️${NC}  .agent/skills/$skill_name — LOCAL override"
        fi
      done
    fi
    
    # Windsurf (uses same .windsurf/skills/)
    if $IS_WINDSURF; then
      mkdir -p "$repo/.windsurf/skills"
      for skill_dir in "$EGOS_HOME/skills/"/*/; do
        skill_name=$(basename "$skill_dir")
        target="$repo/.windsurf/skills/$skill_name"
        if [ ! -e "$target" ]; then
          ln -sf "$skill_dir" "$target"
          echo -e "      ${GREEN}🔗${NC} .windsurf/skills/$skill_name"
        fi
      done
    fi
  fi

  # ── D. Update .gitignore ──
  if [ -f "$repo/.gitignore" ]; then
    for pattern in ".egos"; do
      if ! grep -q "^${pattern}$" "$repo/.gitignore" 2>/dev/null; then
        echo "$pattern" >> "$repo/.gitignore"
        echo -e "      ${GREEN}📝${NC} Added $pattern to .gitignore"
      fi
    done
  fi

  # ── E. Governance file check ──
  echo -e "      📋 Governance:"
  for f in AGENTS.md TASKS.md; do
    if [ -f "$repo/$f" ]; then
      echo -e "         ${GREEN}✅${NC} $f"
    else
      echo -e "         ${YELLOW}⚠️${NC}  $f — missing"
    fi
  done
done

# ── Step 3: Summary ──
echo ""
echo "═══════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ EGOS Sync v2.0 complete!${NC}"
echo ""
echo "Shared resources:"
echo "   📂 Governance: ~/.egos/guarani/ → all repos via .egos symlink"
echo "   ⚡ Workflows:  ~/.egos/workflows/ → .agent + .windsurf"
echo "   🎯 Skills:     ~/.egos/skills/ → .agent + .windsurf"
echo ""
echo "Rule precedence (per repo):"
echo "  1. Local files (.guarani/, workflows/)  ← HIGHEST"
echo "  2. Shared EGOS (~/.egos/)               ← MEDIUM"
echo "  3. Agent rules (.windsurfrules, etc.)   ← AGENT-SPECIFIC"
echo ""
echo "To add a new repo: add to REPOS array in ~/.egos/sync.sh"
