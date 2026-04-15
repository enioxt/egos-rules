#!/usr/bin/env bash
# ~/.egos/hooks/package-naming.sh
# Enforces npm/Python package naming convention across EGOS repos.
#
# Rules (§17 ~/.claude/CLAUDE.md):
#   @egos/*        = private workspace-only packages (never publish to npm)
#   @egosbr/*      = public npm packages (account: egosbr)
#   egosbr-*       = public PyPI packages (Python)
#
# Blocks if staged files import @egos/* in a context that will be published,
# or use @egosbr/* in internal-only workspace.
#
# Installation: add to pre-commit hooks:
#   bash ~/.egos/hooks/package-naming.sh || exit 1
#
# Per-repo override: create .no-pkg-naming-check at repo root to skip.

set -u

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$REPO_ROOT" ] && { echo "[pkg-naming] not a git repo — skipping"; exit 0; }
[ -f "$REPO_ROOT/.no-pkg-naming-check" ] && { echo "[pkg-naming] skipped via .no-pkg-naming-check"; exit 0; }

STAGED=$(git diff --cached --name-only 2>/dev/null || true)
[ -z "$STAGED" ] && exit 0

VIOLATIONS=0

# Rule 1: @egos/* must NOT appear in files destined for npm publish
# (package.json with "private": false that references @egos/* as external dep)
STAGED_PKG_JSON=$(echo "$STAGED" | grep "^package\.json$" || true)
if [ -n "$STAGED_PKG_JSON" ]; then
  IS_PUBLIC=$(python3 -c "
import json, sys
try:
    d = json.load(open('package.json'))
    # Private flag missing or false = public
    print('yes' if not d.get('private', False) else 'no')
except: print('no')
" 2>/dev/null || echo "no")

  if [ "$IS_PUBLIC" = "yes" ]; then
    EGOS_DEPS=$(python3 -c "
import json
try:
    d = json.load(open('package.json'))
    deps = {**d.get('dependencies',{}), **d.get('devDependencies',{})}
    bad = [k for k in deps if k.startswith('@egos/')]
    print('\n'.join(bad))
except: pass
" 2>/dev/null || true)
    if [ -n "$EGOS_DEPS" ]; then
      echo "🔴 [pkg-naming] BLOCKED: public package.json references private @egos/* packages:"
      echo "$EGOS_DEPS" | sed 's/^/   - /'
      echo "   Use @egosbr/* for public packages or mark package as private:true"
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
  fi
fi

# Rule 2: Staged .ts/.tsx files should not import @egosbr/* in internal repos
# Internal repos: those without a public package.json
STAGED_TS=$(echo "$STAGED" | grep -E '\.(ts|tsx)$' || true)
if [ -n "$STAGED_TS" ]; then
  IS_INTERNAL="no"
  if [ -f "package.json" ]; then
    IS_INTERNAL=$(python3 -c "
import json
try:
    d = json.load(open('package.json'))
    print('yes' if d.get('private', False) else 'no')
except: print('no')
" 2>/dev/null || echo "no")
  fi

  # Check for @egosbr/* imports in internal packages
  if [ "$IS_INTERNAL" = "yes" ]; then
    for f in $STAGED_TS; do
      if [ -f "$f" ]; then
        BAD_IMPORTS=$(git diff --cached -- "$f" 2>/dev/null | grep '^+' | grep -v '^+++' | \
          grep -oE "from '@egosbr/[^']+'" | head -5 || true)
        if [ -n "$BAD_IMPORTS" ]; then
          echo "⚠️  [pkg-naming] WARNING: $f imports @egosbr/* in a private (internal) package"
          echo "   This is allowed for cross-package usage but verify intent:"
          echo "$BAD_IMPORTS" | sed 's/^/   /'
          echo "   Rule: @egos/* = internal workspace | @egosbr/* = published npm"
          # Warning only, not blocking (cross-repo usage can be valid)
        fi
      fi
    done
  fi
fi

# Rule 3: Python files — egosbr- prefix for public PyPI, plain names for internal
STAGED_PY=$(echo "$STAGED" | grep -E '(pyproject\.toml|setup\.py|setup\.cfg)' || true)
if [ -n "$STAGED_PY" ]; then
  for f in $STAGED_PY; do
    if [ -f "$f" ] && echo "$f" | grep -q "pyproject.toml"; then
      PKG_NAME=$(python3 -c "
import re, sys
try:
    content = open('$f').read()
    m = re.search(r'name\s*=\s*[\"']([^\"']+)[\"']', content)
    print(m.group(1) if m else '')
except: pass
" 2>/dev/null || true)
      # Check if being published (has [project.urls] with Repository)
      IS_PUBLISHED=$(grep -q "\[project.urls\]" "$f" && echo "yes" || echo "no")
      if [ "$IS_PUBLISHED" = "yes" ] && [ -n "$PKG_NAME" ]; then
        if ! echo "$PKG_NAME" | grep -qE "^(egosbr-|egos-)"; then
          echo "⚠️  [pkg-naming] WARNING: published Python package '$PKG_NAME' should use 'egosbr-' prefix"
          echo "   Convention: egosbr-guard-brasil, egosbr-atrian, egosbr-audit"
        fi
      fi
    fi
  done
fi

if [ "$VIOLATIONS" -gt 0 ]; then
  echo ""
  echo "🔴 [pkg-naming] BLOCKED: $VIOLATIONS naming violation(s)"
  echo "   Docs: ~/.claude/CLAUDE.md §17 — npm naming convention"
  exit 1
fi

exit 0
