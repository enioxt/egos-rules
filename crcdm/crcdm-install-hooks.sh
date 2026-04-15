#!/usr/bin/env bash
# EGOS CRCDM Integration Script
# Installs CRCDM hooks to all EGOS repositories
# Part of Cross-Repo Change Detection Mesh

set -euo pipefail

CRCDM_ROOT="${HOME}/.egos/crcdm"
HOOKS_DIR="${CRCDM_ROOT}/hooks"

# All EGOS repositories
REPOS=(
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

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     EGOS CRCDM Hook Installer                                 ║"
echo "║     Cross-Repo Change Detection Mesh Setup                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if hooks exist
if [ ! -d "$HOOKS_DIR" ]; then
  echo "❌ CRCDM hooks not found at $HOOKS_DIR"
  echo "   Run: crcdm-init first"
  exit 1
fi

# Make hooks executable
chmod +x "${HOOKS_DIR}"/*

# Install to each repository
INSTALLED=0
SKIPPED=0

for repo in "${REPOS[@]}"; do
  repo_name=$(basename "$repo")
  git_dir="${repo}/.git"
  hooks_dir="${git_dir}/hooks"
  
  if [ ! -d "$git_dir" ]; then
    echo "  ⚠️  $repo_name — Not a git repository (skipped)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  
  echo "  📦 $repo_name — Installing hooks..."
  
  # Create hooks directory if needed
  mkdir -p "$hooks_dir"
  
  # Install each hook
  for hook in pre-commit post-commit pre-push post-push; do
    source_hook="${HOOKS_DIR}/${hook}"
    target_hook="${hooks_dir}/${hook}"
    
    if [ -f "$source_hook" ]; then
      # Check if hook already exists
      if [ -f "$target_hook" ] && [ ! -L "$target_hook" ]; then
        # Backup existing hook
        mv "$target_hook" "${target_hook}.backup.$(date +%s)"
        echo "     ↳ ${hook}: backed up existing"
      fi
      
      # Install new hook
      cp "$source_hook" "$target_hook"
      chmod +x "$target_hook"
      echo "     ✓ ${hook}"
    else
      echo "     ✗ ${hook}: not found in source"
    fi
  done
  
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  Installation Summary                                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
printf "║  Repositories installed: %-36s ║\n" "$INSTALLED"
printf "║  Repositories skipped:   %-36s ║\n" "$SKIPPED"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ CRCDM hooks installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Make a change and commit: git add . && git commit -m 'test'"
echo "  2. View mesh status:          crcdm status"
echo "  3. View change log:            crcdm log"
echo "  4. Visualize DAG:             crcdm dag"
echo ""
echo "To uninstall: crcdm-uninstall-hooks"
