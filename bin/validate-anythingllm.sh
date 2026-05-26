#!/usr/bin/env bash
# validate-anythingllm.sh — guardrail executável para AnythingLLM EGOS
# Codex P0 fix (E2): "Próximo agente pode quebrar config sem guardrails executáveis"
#
# Uso:
#   bash scripts/validate-anythingllm.sh                     # validação local
#   ALLM_URL=https://kb.gpecas.egos.ia.br bash $0            # validação remota
#   ALLM_URL=... KEY_FILE=~/.egos/clients/gpecas/.api-key bash $0
#
# Exit codes:
#   0 = tudo OK
#   1 = warnings (não-bloqueante)
#   2 = falhas P0 (não pode subir cliente)

set -uo pipefail

URL="${ALLM_URL:-http://localhost:3001}"
KEY_FILE="${KEY_FILE:-/home/enio/anythingllm/.api-key}"
DB="${ALLM_DB:-/home/enio/anythingllm/storage/anythingllm.db}"
PINNED_VERSION="${PINNED_VERSION:-1.12.1}"

FAIL=0
WARN=0

red() { printf "\033[31m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }
yellow() { printf "\033[33m%s\033[0m\n" "$*"; }

check() {
  local name="$1"; local pass="$2"; local level="$3"  # info|warn|fail
  if [ "$pass" = "true" ]; then
    green "  ✓ $name"
  elif [ "$level" = "fail" ]; then
    red "  ✗ $name [P0]"; FAIL=$((FAIL+1))
  else
    yellow "  ⚠ $name [P1]"; WARN=$((WARN+1))
  fi
}

echo "=== validate-anythingllm.sh — $(date +%Y-%m-%dT%H:%M:%S%z) ==="
echo "URL: $URL"
echo ""

# === I1: Versão pinada (não 'latest') ===
echo "I. INFRA"
if [ "$URL" = "http://localhost:3001" ]; then
  RUNNING_IMAGE=$(docker inspect anythingllm --format '{{.Config.Image}}' 2>/dev/null || echo "absent")
  if echo "$RUNNING_IMAGE" | grep -q ":$PINNED_VERSION$"; then
    check "I1 — Versão pinada $PINNED_VERSION" true fail
  elif echo "$RUNNING_IMAGE" | grep -q ":latest$"; then
    check "I1 — Versão pinada (NÃO 'latest')" false fail
  else
    check "I1 — Versão pinada [$RUNNING_IMAGE]" true fail
  fi
else
  check "I1 — Versão pinada (remoto: validar manualmente)" true info
fi

# === I2: Backup recente ===
LAST_BACKUP=$(ls -t /home/enio/anythingllm/storage/anythingllm.db.bak.* 2>/dev/null | head -1)
if [ -n "$LAST_BACKUP" ]; then
  AGE_HOURS=$(( ($(date +%s) - $(stat -c %Y "$LAST_BACKUP")) / 3600 ))
  if [ "$AGE_HOURS" -lt 168 ]; then
    check "I2 — Backup recente (${AGE_HOURS}h)" true fail
  else
    check "I2 — Backup velho (${AGE_HOURS}h > 168h)" false warn
  fi
else
  check "I2 — Nenhum backup encontrado" false fail
fi

# === I3: API key existe + chmod 600 ===
if [ -f "$KEY_FILE" ]; then
  PERMS=$(stat -c %a "$KEY_FILE")
  if [ "$PERMS" = "600" ]; then
    check "I3 — API key file chmod 600" true fail
  else
    check "I3 — API key file chmod errado ($PERMS, esperado 600)" false fail
  fi
else
  check "I3 — API key file ausente em $KEY_FILE" false fail
fi

echo ""
echo "II. AUTH (R6 defense-in-depth)"

# === N1: HTTPS se remoto ===
if echo "$URL" | grep -q "^https://"; then
  check "N1 — HTTPS ativo" true fail
elif [ "$URL" = "http://localhost:3001" ]; then
  check "N1 — Localhost OK sem HTTPS" true info
else
  check "N1 — Produção sem HTTPS" false fail
fi

# === N2: Auth funcional ===
if [ -f "$KEY_FILE" ]; then
  KEY=$(cut -d= -f2 "$KEY_FILE")
  AUTH_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -H "Authorization: Bearer $KEY" "$URL/api/v1/auth")
  if [ "$AUTH_CODE" = "200" ]; then
    check "N2 — Auth bearer válido" true fail
  else
    check "N2 — Auth bearer falhou (HTTP $AUTH_CODE)" false fail
  fi
fi

# === N3: Endpoint público inacessível sem auth ===
NOAUTH_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$URL/api/v1/workspaces")
if [ "$NOAUTH_CODE" = "403" ] || [ "$NOAUTH_CODE" = "401" ]; then
  check "N3 — /api/v1/* protegido (HTTP $NOAUTH_CODE sem token)" true fail
else
  check "N3 — /api/v1/* SEM AUTH (HTTP $NOAUTH_CODE)" false fail
fi

echo ""
echo "III. RBAC (R2)"

# === R1: Multi-user mode (só relevante se remoto) ===
if [ -f "$DB" ]; then
  MU=$(sqlite3 "$DB" "SELECT value FROM system_settings WHERE label='multi_user_mode'" 2>/dev/null)
  if [ "$URL" = "http://localhost:3001" ]; then
    check "R1 — Multi-user mode opcional em dev local" true info
  else
    if [ "$MU" = "true" ]; then
      check "R1 — Multi-user mode ATIVO" true fail
    else
      check "R1 — Multi-user mode INATIVO em produção" false fail
    fi
  fi
fi

echo ""
echo "IV. ANTI-ALUCINAÇÃO (R3)"

# === A1: chatMode=query em workspaces de cliente ===
if [ -f "$DB" ]; then
  CLIENT_WS=$(sqlite3 "$DB" "SELECT slug, chatMode FROM workspaces WHERE slug != 'meu-workspace'" 2>/dev/null)
  if [ -n "$CLIENT_WS" ]; then
    BAD=$(echo "$CLIENT_WS" | awk -F'|' '$2 != "query" {print $1}')
    if [ -z "$BAD" ]; then
      check "A1 — Todos workspaces cliente com chatMode=query" true fail
    else
      check "A1 — Workspaces sem chatMode=query: $BAD" false fail
    fi
  else
    check "A1 — Nenhum workspace cliente ainda (só meu-workspace)" true info
  fi
fi

echo ""
echo "V. KEY LIFECYCLE (R7)"

# === K1: Naming convention ===
if [ -f "$DB" ]; then
  UNNAMED=$(sqlite3 "$DB" "SELECT COUNT(*) FROM api_keys WHERE name IS NULL OR name = ''" 2>/dev/null)
  if [ "$UNNAMED" = "0" ]; then
    check "K1 — Todas API keys com name" true fail
  else
    check "K1 — $UNNAMED API keys sem name (anti-padrão R7)" false warn
  fi
fi

echo ""
echo "════════════════════════════════════════════════════════════"
if [ "$FAIL" -gt 0 ]; then
  red "FAIL: $FAIL P0 issues — não onboard cliente até resolver"
  exit 2
elif [ "$WARN" -gt 0 ]; then
  yellow "WARN: $WARN P1 issues — resolver antes de Tier ALPHA"
  exit 1
else
  green "OK: todos os checks passaram"
  exit 0
fi
