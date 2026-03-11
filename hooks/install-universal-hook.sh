#!/usr/bin/env bash
set -euo pipefail

SOURCE_HOOK="/home/enio/.egos/hooks/pre-commit"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

if [ ! -f "$SOURCE_HOOK" ]; then
  echo "✗ Hook fonte não encontrado: $SOURCE_HOOK" >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  REPOS=(
    "/home/enio/852"
    "/home/enio/carteira-livre"
    "/home/enio/forja"
    "/home/enio/egos-self"
    "/home/enio/policia"
  )
else
  REPOS=("$@")
fi

for repo in "${REPOS[@]}"; do
  if [ ! -d "$repo/.git/hooks" ]; then
    echo "· Ignorando $repo (não parece repo git com hooks)"
    continue
  fi

  target="$repo/.git/hooks/pre-commit"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$SOURCE_HOOK" ]; then
    echo "✓ $(basename "$repo"): já aponta para o hook universal"
    continue
  fi

  if [ -f "$target" ] && [ ! -L "$target" ]; then
    backup="$repo/.git/hooks/pre-commit.backup.$TIMESTAMP"
    mv "$target" "$backup"
    echo "↺ $(basename "$repo"): hook local movido para $(basename "$backup")"
  fi

  ln -sf "$SOURCE_HOOK" "$target"
  chmod +x "$SOURCE_HOOK"
  echo "✓ $(basename "$repo"): hook universal instalado"

done
