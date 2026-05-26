# Client Incident Runbook — AnythingLLM KB

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Status:** canonical
> **Codex P0 fix (E4):** "Falta playbook de incidente cliente"
> **SLA:** triagem em 15 minutos | resolução conforme severidade

---

## Triagem em 15 minutos

Quando cliente reporta problema:

```
┌─ 1. CLASSIFICAR (2 min) ────────────────────────────────┐
│  □ S0 — Vazamento dados / outro cliente vê os dados     │
│  □ S1 — Sistema parou / inacessível                     │
│  □ S2 — Resposta errada / alucinação confirmada         │
│  □ S3 — Lentidão / UX ruim                              │
│  □ S4 — Dúvida de uso (não é incidente)                 │
└─────────────────────────────────────────────────────────┘
            ↓
┌─ 2. CONTER (5 min) ──────────────────────────────────────┐
│  S0 → DESLIGAR instância: docker stop allm-<slug>       │
│  S1 → Verificar health + restart se preciso              │
│  S2 → Adicionar workspace ao queryRefusalResponse review │
│  S3 → Log de latência + rate limit check                 │
│  S4 → Responder via WhatsApp/email                       │
└──────────────────────────────────────────────────────────┘
            ↓
┌─ 3. COMUNICAR (3 min) ───────────────────────────────────┐
│  Mensagem cliente:                                       │
│  "Recebido. Severidade [S?]. Status: investigando.       │
│  Próxima atualização em [Y] minutos. ID: INC-[date]-[n]"│
│  Telegram interno: Enio + cliente owner                  │
└──────────────────────────────────────────────────────────┘
            ↓
┌─ 4. INVESTIGAR (5 min) ──────────────────────────────────┐
│  bash scripts/validate-anythingllm.sh URL=<cliente>      │
│  docker logs anythingllm --tail 200                      │
│  sqlite3 .db "SELECT * FROM event_logs ORDER BY occurredAt DESC LIMIT 50"│
└──────────────────────────────────────────────────────────┘
```

---

## SLA por severidade

| Severidade | Triagem | 1ª resposta | Resolução | Comunicação |
|---|---|---|---|---|
| **S0 — Vazamento** | Imediato | 30 min | 4h | A cada 30 min |
| **S1 — Parou** | 15 min | 30 min | 4h | A cada 1h |
| **S2 — Errou** | 1h | 4h | 24h | Status diário |
| **S3 — Lentidão** | 4h | 24h | 72h | Status semanal |
| **S4 — Dúvida** | 24h | 48h | 7d | Conforme conversa |

---

## Playbook por cenário

### S0 — Vazamento de dados

```bash
# 1. CONTER (imediato)
docker stop allm-<slug>

# 2. SNAPSHOT forense
cp /opt/anythingllm-<slug>/storage/anythingllm.db /tmp/forense-INC-$(date +%Y%m%d-%H%M).db

# 3. AUDIT query
sqlite3 /tmp/forense-*.db "
SELECT u.username, u.role, wc.workspace_id, COUNT(*) chats, MIN(wc.createdAt), MAX(wc.createdAt)
FROM workspace_chats wc
JOIN users u ON wc.user_id = u.id
WHERE wc.createdAt > datetime('now', '-7 days')
GROUP BY u.username, wc.workspace_id"

# 4. NOTIFICAR cliente owner em WhatsApp (texto preparado abaixo)

# 5. NOTIFICAR DPO se aplicável (Art. 48 LGPD: 72h ANPD se afetar direitos)

# 6. INVESTIGAR root cause:
#    - Cross-tenant query?
#    - workspace_users wrong assignment?
#    - manager role em uso indevido?
#    - SQL direto recente?

# 7. APÓS conter: documentar em docs/INCIDENTS/INC-YYYY-MM-DD-vazamento-<slug>.md
```

**Texto canonical para cliente:**
```
[CLIENT NAME], identifiquei [DESCRIÇÃO] no seu KB. Suspendi o acesso para investigar.
Histórico forense preservado. Vou retornar em [TEMPO] com causa raiz e plano de remediação.
Se você ou seus clientes finais foram afetados, comunicação adicional será feita conforme LGPD Art. 48.
ID: INC-YYYY-MM-DD-<n>
```

---

### S1 — Sistema parou (HTTP 5xx, container morto)

```bash
# 1. Health check
curl -fsS -o /dev/null http://kb.<slug>.egos.ia.br/api/ping; echo $?

# 2. Container status
docker ps -a --filter name=allm-<slug>

# 3. Se container down:
docker start allm-<slug>
until curl -fsS http://localhost:<port>/api/ping; do sleep 1; done
docker ps --filter name=allm-<slug>  # confirma healthy

# 4. Se container recovered: validar
KEY=$(cat ~/.egos/clients/<slug>/.api-key)
curl -H "Authorization: Bearer $KEY" https://kb.<slug>.egos.ia.br/api/v1/workspaces

# 5. Se NÃO recuperou: ROLLBACK para versão anterior
docker rm -f allm-<slug>
docker run -d --name allm-<slug> -p <port>:3001 \
  -v /opt/anythingllm-<slug>/storage:/app/server/storage \
  --restart unless-stopped \
  mintplexlabs/anythingllm:<PREVIOUS_TAG>
# (mantenha tag anterior sempre que upgrade for feito — Codex C4)

# 6. ROOT CAUSE:
docker logs allm-<slug> --since 1h | grep -E "(ERROR|FATAL|panic)"
df -h /opt/  # storage cheio?
free -m     # OOM?
```

---

### S2 — Resposta errada / alucinação

```bash
# 1. Cliente envia screenshot da resposta + workspace + query
# 2. Reproduzir:
KEY=$(cat ~/.egos/clients/<slug>/.api-key)
curl -X POST -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"message":"<query reportada>","mode":"query"}' \
  https://kb.<slug>.egos.ia.br/api/v1/workspace/<ws-slug>/chat | jq .

# 3. Inspecionar:
#    - chatMode é "query"?
#    - similarityThreshold adequado? (default 0.25)
#    - topN adequado? (default 4)
#    - queryRefusalResponse válido?
#    - prompt system tem guard-rail anti-injection?

# 4. Inspecionar fontes:
sqlite3 /opt/anythingllm-<slug>/storage/anythingllm.db "
  SELECT * FROM workspace_documents wd
  JOIN workspaces w ON wd.workspaceId = w.id
  WHERE w.slug = '<ws-slug>'"

# 5. Verificar RAG poisoning (R5):
#    - Algum doc contém "ignore instructions"?
#    - Algum doc tem PII vazada de teste?
grep -ri "ignore\|admin mode\|reveal" /opt/anythingllm-<slug>/storage/documents/<ws-slug>/

# 6. Fix:
#    - Ajustar prompt
#    - Re-treinar embeddings após mudar threshold
#    - Remover doc problemático
#    - Adicionar caso ao golden test
```

---

### S3 — Lentidão

```bash
# 1. Latência atual
time curl -s -H "Authorization: Bearer $KEY" \
  -X POST -d '{"message":"teste","mode":"query"}' \
  https://kb.<slug>.egos.ia.br/api/v1/workspace/<ws-slug>/chat -o /dev/null

# 2. Provider check
#    OpenRouter status: https://openrouter.ai/status
#    Gemini status: https://status.cloud.google.com/

# 3. Fallback provider (R4)
sqlite3 .db "UPDATE system_settings SET value='anthropic' WHERE label='LLMProvider'"
docker restart allm-<slug>

# 4. Container resources
docker stats allm-<slug> --no-stream
```

---

### S4 — Dúvida (não é incidente)

Responder pelo canal regular. Adicionar ao FAQ interno se for pergunta recorrente.

---

## Pós-incidente obrigatório

1. **Postmortem em `docs/INCIDENTS/INC-YYYY-MM-DD-<slug>-<short>.md`**
   - Timeline (detecção → conter → comunicar → resolver)
   - Root cause
   - O que funcionou / o que falhou
   - Action items com owner + ETA

2. **Action items viram tasks em TASKS.md** (prefixo INC-)

3. **Atualizar runbook** se cenário novo apareceu

4. **Cliente comunicação final** com:
   - Causa raiz
   - Remediação aplicada
   - Prevenção futura
   - Se LGPD afetada: Art. 48 cumprido (ANPD + titular)

---

## Quem aciona o quê

| Quem | Pode acionar | Não pode |
|---|---|---|
| Cliente owner | Qualquer severidade direto Enio | Mexer em container EGOS-managed |
| Funcionário cliente | Via cliente owner (escalation) | Contato direto Enio |
| Enio (EGOS) | Pode pausar instância em S0 | Acessar workspaces sem trigger documentado |
| Codex/Claude assistant | Identificar + propor | Executar sem confirmação Enio |

---

## Templates de comunicação

### Aviso recebimento (1ª resposta cliente)
```
Recebido seu reporte. Classifiquei como [S?]. Estou [conteindo/investigando/...].
Próxima atualização em [X] minutos.
ID do incidente: INC-YYYY-MM-DD-<n>
```

### Postmortem público (3-5 dias após resolver)
```
Resumo: O que aconteceu em [data], por quanto tempo, quem foi afetado.

Causa raiz: [técnica em linguagem clara, sem culpa]

O que fizemos: [ações concretas, com timestamps]

Prevenção: [novos checks/runbooks/limites adicionados]

Compromisso: [SLA atualizado, se aplicável]
```

---

## Referências
- [CLIENT_KB_DOCTRINE.md](../governance/CLIENT_KB_DOCTRINE.md)
- [SETUP.md AnythingLLM](../products/anythingllm/SETUP.md)
- [API_KEY_ROTATION.md](API_KEY_ROTATION.md)
- LGPD Art. 48 (comunicação de incidente)
- [validate-anythingllm.sh](../../scripts/validate-anythingllm.sh)

*v1.0 — 2026-05-20 — Codex review P0 (E4) — runbook executável para incidentes de cliente.*
