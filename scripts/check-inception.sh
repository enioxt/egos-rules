#!/usr/bin/env bash
# Project Inception Gate (PIG) — pre-commit hook (warn-only)
# SSOT: docs/personal-os/FOCUS_GATES.md §6 + .claude/commands/inception.md
# Origem: A59 (entrevista 2026-05-08) — A60 (IA-flatter combustível A33)
#
# Dispara quando: primeiro commit em path NOVO (não em repos canonical)
# Modo: warn-only padrão | EGOS_INCEPTION_STRICT=1 → bloqueia
#
# Skip explícito: EGOS_INCEPTION_SKIP="motivo"

set -eu

# Repos canonical EXISTENTES (não acionam PIG)
CANONICAL_REPOS=(egos santiago carteira-livre 852 commons forja INPI smartbuscas br-acc intelink hermes-egos egos-lab egos-self arch ratio policia volante CEAP-Playbook career-ops omniview video-editor pixelart gem-hunter blueprint-egos egos-rules .egos hermes-agent intelink-legacy-2026-04-18 intelink-agente .nvm)

REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)")

# Se está em repo canonical → não dispara
for canon in "${CANONICAL_REPOS[@]}"; do
  if [ "$REPO_NAME" = "$canon" ]; then
    exit 0
  fi
done

# Skip explícito
if [ -n "${EGOS_INCEPTION_SKIP:-}" ]; then
  echo "🚪 INCEPTION: SKIP autorizado: $EGOS_INCEPTION_SKIP"
  exit 0
fi

# Conta commits — só dispara no PRIMEIRO
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -gt 0 ]; then
  exit 0
fi

# Procura INCEPTION_REPORT referenciado no commit msg
COMMIT_MSG_FILE="${1:-${GIT_DIR:-.git}/COMMIT_EDITMSG}"
if [ -f "$COMMIT_MSG_FILE" ]; then
  if grep -qE "\[INCEPTION:.*\]|INCEPTION_REPORT_PATH=" "$COMMIT_MSG_FILE" 2>/dev/null; then
    echo "✅ INCEPTION: report referenciado no commit msg"
    exit 0
  fi
fi

# REPO NOVO + sem INCEPTION_REPORT
echo ""
echo "🚪 PROJECT INCEPTION GATE — repo novo detectado: $REPO_NAME"
echo ""
echo "   Antes de criar projeto novo, executar /inception:"
echo "     1. Skill /inception <descrição> — recon obrigatório"
echo "     2. Output em docs/inception_reports/YYYY-MM-DD_<slug>.md"
echo "     3. Decisão GO/NO-GO/EXTRACT/STUDY"
echo "     4. Se GO, citar no commit msg: [INCEPTION: <path-to-report>]"
echo ""
echo "   Origem: A59 + A60 (IA-flatter combustível A33). 12 repos abandonados em 15m."
echo "   Skip explícito: EGOS_INCEPTION_SKIP='<motivo>' git commit ..."
echo ""

if [ "${EGOS_INCEPTION_STRICT:-0}" = "1" ]; then
  echo "🔒 STRICT MODE — commit bloqueado."
  exit 1
fi

echo "⚠️  WARN-ONLY MODE — commit prossegue. Set EGOS_INCEPTION_STRICT=1 para bloquear."
exit 0
