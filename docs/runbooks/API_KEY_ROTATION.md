# API Key Rotation Runbook — AnythingLLM EGOS

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Codex P0 fix (R7):** "API key sem TTL vira credencial eterna"

---

## TL;DR

```
Mensalmente: rotacionar key manager Enio em cada cliente
Trimestralmente: revisar todas as keys ativas (audit)
Sob demanda: revogar imediato se key vazada
Automático: cron daily revoga keys inativas >90 dias
```

---

## Naming convention obrigatório

```
<cliente-slug>-<role>-<purpose>-<YYYYMM>

Exemplos:
  gpecas-admin-julio-202605
  gpecas-manager-enio-202605
  gpecas-default-equipe-202605
  gpecas-mcp-bearer-202605
```

---

## Procedimento canonical (rotação mensal)

```bash
CLIENT_SLUG=gpecas
DB=/opt/anythingllm-${CLIENT_SLUG}/storage/anythingllm.db
KEY_DIR=~/.egos/clients/${CLIENT_SLUG}
MONTH=$(date +%Y%m)

# 1. Criar nova key
NEW_KEY=$(openssl rand -hex 32)
NEW_NAME="${CLIENT_SLUG}-manager-enio-${MONTH}"

sqlite3 "$DB" "INSERT INTO api_keys (secret, name, createdAt, lastUpdatedAt)
  VALUES ('$NEW_KEY', '$NEW_NAME', datetime('now'), datetime('now'))"

# 2. Validar nova key funciona
KEY=$NEW_KEY
curl -fsS -H "Authorization: Bearer $KEY" \
  https://kb.${CLIENT_SLUG}.egos.ia.br/api/v1/auth || { echo "✗ NEW KEY INVALID"; exit 1; }

# 3. Backup arquivo .api-key antigo
mv $KEY_DIR/.api-key $KEY_DIR/.api-key.bak.$(date +%Y%m%d-%H%M%S)

# 4. Persistir nova key (chmod 600 obrigatório)
echo "ANYTHINGLLM_API_KEY=$NEW_KEY" > $KEY_DIR/.api-key
chmod 600 $KEY_DIR/.api-key

# 5. Revogar key antiga (lista existentes primeiro)
sqlite3 "$DB" "SELECT id, name, lastUpdatedAt FROM api_keys
  WHERE name LIKE '${CLIENT_SLUG}-manager-enio-%' AND name != '$NEW_NAME'
  ORDER BY lastUpdatedAt DESC"

# Confirmar manualmente que está revogando a antiga:
read -p "ID da key a revogar: " OLD_ID
sqlite3 "$DB" "DELETE FROM api_keys WHERE id = $OLD_ID"

# 6. Log audit
sqlite3 "$DB" "INSERT INTO event_logs (event, metadata, occurredAt)
  VALUES ('api_key_rotated',
          '{\"old_id\":$OLD_ID,\"new_name\":\"$NEW_NAME\",\"actor\":\"enio-egos\"}',
          datetime('now'))"

# 7. Notificar cliente
echo "Rotacionei a chave manager EGOS conforme política mensal. Sem ação necessária do seu lado."
# Enviar via WhatsApp/email
```

---

## Procedimento: revogação imediata (key vazada)

```bash
# 1. Identificar key
sqlite3 "$DB" "SELECT id, name, substr(secret,1,12)||'...', createdAt
  FROM api_keys ORDER BY id DESC"

# 2. Revogar (DELETE direto)
sqlite3 "$DB" "DELETE FROM api_keys WHERE id = <ID_VAZADA>"

# 3. Log emergency
sqlite3 "$DB" "INSERT INTO event_logs (event, metadata, occurredAt)
  VALUES ('api_key_emergency_revoke',
          '{\"id\":<ID>,\"reason\":\"leaked\",\"actor\":\"<who>\"}',
          datetime('now'))"

# 4. Audit últimas atividades dessa key
sqlite3 "$DB" "SELECT * FROM event_logs WHERE metadata LIKE '%apikey:<ID>%' ORDER BY occurredAt DESC LIMIT 100"

# 5. Notificar cliente owner IMEDIATO
echo "Identifiquei comprometimento de chave API. Revogada. Auditoria em curso. ID: SEC-INC-YYYY-MM-DD-<n>"

# 6. Documentar em docs/INCIDENTS/SEC-YYYY-MM-DD-key-leak-<slug>.md
```

---

## Procedimento: cron automático (revogar inativas)

Adicionar em `/etc/cron.daily/anythingllm-key-lifecycle`:

```bash
#!/bin/bash
# Revoga keys inativas >90 dias (Codex C2)

for SLUG_DIR in /opt/anythingllm-*; do
  SLUG=$(basename $SLUG_DIR | sed 's/anythingllm-//')
  DB=$SLUG_DIR/storage/anythingllm.db

  [ -f "$DB" ] || continue

  # Keys sem atividade em 90 dias
  STALE=$(sqlite3 "$DB" "SELECT id, name FROM api_keys
    WHERE lastUpdatedAt < datetime('now', '-90 days')")

  if [ -n "$STALE" ]; then
    # Alertar 24h antes (não deletar ainda)
    if [ ! -f "/var/lib/anythingllm-revoke/${SLUG}-pending.txt" ]; then
      mkdir -p /var/lib/anythingllm-revoke
      echo "$STALE" > /var/lib/anythingllm-revoke/${SLUG}-pending.txt
      # Notificar Telegram
      curl -X POST "https://api.telegram.org/bot${TG_BOT}/sendMessage" \
        -d "chat_id=171767219&text=⚠️ AnythingLLM key revoke pending in 24h for $SLUG: $STALE"
    else
      # 24h se passou — revogar
      sqlite3 "$DB" "DELETE FROM api_keys
        WHERE lastUpdatedAt < datetime('now', '-90 days')"
      sqlite3 "$DB" "INSERT INTO event_logs (event, metadata, occurredAt)
        VALUES ('api_key_auto_revoked',
                '{\"count\":$(echo "$STALE" | wc -l),\"slug\":\"$SLUG\"}',
                datetime('now'))"
      rm /var/lib/anythingllm-revoke/${SLUG}-pending.txt
    fi
  fi
done
```

---

## Audit trimestral (manual, 30 min)

```bash
# Para CADA cliente:
DB=/opt/anythingllm-<slug>/storage/anythingllm.db

# 1. Listar todas keys ativas
sqlite3 "$DB" "SELECT id, name, createdAt, lastUpdatedAt FROM api_keys"

# 2. Cruzar com naming convention
#    - Tem cliente_slug? role? purpose? YYYYMM?
#    - YYYYMM ≥ 3 meses atrás? → rotacionar
#    - Sem name? → renomear ou revogar (anti-padrão R7)

# 3. Verificar event_logs de uso
sqlite3 "$DB" "SELECT metadata, COUNT(*) FROM event_logs
  WHERE metadata LIKE '%apikey%' GROUP BY metadata"

# 4. Documentar audit em docs/audits/KEY_AUDIT_YYYYQN.md
```

---

## Procedimento: cliente revoga acesso Enio

Cliente pode revogar acesso EGOS a qualquer momento (contratual R1):

```bash
# Cliente (admin) executa via UI ou pede via WhatsApp:
# Settings → Tools → Developer API → revogar key 'gpecas-manager-enio-*'

# Verificação Enio (que perdeu acesso):
KEY=$(cat ~/.egos/clients/gpecas/.api-key)
curl -H "Authorization: Bearer $KEY" https://kb.gpecas.egos.ia.br/api/v1/auth
# HTTP 403 → confirmado revogado

# Limpar localmente
rm ~/.egos/clients/gpecas/.api-key

# Confirmar com cliente:
echo "Confirmo que perdi acesso ao KB conforme sua solicitação."
```

---

## Anti-padrões (NÃO fazer)

- ❌ Criar key sem `name` (auditoria impossível)
- ❌ Reutilizar mesma key entre clientes
- ❌ Compartilhar key com colaborador EGOS (cria chave PRÓPRIA)
- ❌ Manter key revogada num backup que pode ser restaurado
- ❌ Logar key em texto claro (terminal, log, mensagem)
- ❌ Rotacionar sem revogar antiga (key órfã ativa = vetor)
- ❌ Auto-revogar sem alerta 24h ao cliente

---

## Checklist mensal Enio

```
Primeira segunda do mês:
[ ] Rodar bash scripts/rotate-keys-monthly.sh (a criar como helper)
[ ] Para cada cliente Tier ALPHA/BETA: rotacionar manager-enio-YYYYMM
[ ] Para cada cliente: audit visual no `event_logs` da semana
[ ] Confirmar cron daily de auto-revoke rodou (último 7d)
[ ] Verificar nenhuma key órfã (sem name)
[ ] Notificar cliente owner: "rotacionei conforme política mensal"
[ ] Tempo total: ~30min para 5 clientes
```

---

## Referências
- [CLIENT_KB_DOCTRINE.md §REGRA 7](../governance/CLIENT_KB_DOCTRINE.md#regra-7)
- [CLIENT_INCIDENT_RUNBOOK.md](CLIENT_INCIDENT_RUNBOOK.md)
- [validate-anythingllm.sh](../../scripts/validate-anythingllm.sh)
- OWASP API Security Top 10 2023 (API2:2023 Broken Authentication)

*v1.0 — 2026-05-20 — Codex review R7 — lifecycle obrigatório de chaves.*
