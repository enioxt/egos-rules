---
description: Central EGOS client lifecycle management — provision, ingest, configure channels, handoff, update and monitor client instances. Use when: onboarding new client (provision), loading documents (ingest), setting up WhatsApp/Telegram (canais), training client (handoff), updating plugins (update), or health-checking (monitor). Args: /central-egos <subcommand> <slug> [options]. Subcommands: provision ingest canais handoff update monitor.
---

# /central-egos — Central EGOS Client Lifecycle

> **Subcommands:** `provision` | `ingest` | `canais` | `handoff` | `update` | `monitor`
> **Usage:** `/central-egos <subcommand> <slug> [flags]`
> **Flow:** provision → ingest → canais → handoff → (update / monitor ongoing)

---

## Routing

When user types `/central-egos <subcommand>`, load the full instructions for that subcommand only:

- **provision** `<slug> --tier=solo|pro|enterprise` — new client onboarding (30–60min)
  → Load: `.claude/commands/_central-egos/provision.md`

- **ingest** `<slug> <fonte>` — load client KB from documents (15min–2h)
  → Load: `.claude/commands/_central-egos/ingest.md`

- **canais** `<slug> [--wa] [--tg] [--email]` — configure WhatsApp/Telegram channels (15–30min)
  → Load: `.claude/commands/_central-egos/canais.md`

- **handoff** `<slug>` — train client and deliver system (45–90min session)
  → Load: `.claude/commands/_central-egos/handoff.md`

- **update** `<slug>` — sync new plugin versions to client instance (15–30min)
  → Load: `.claude/commands/_central-egos/update.md`

- **monitor** `<slug>` — health check OpenRouter/Hermes/WhatsApp (daily/on-demand)
  → Load: `.claude/commands/_central-egos/monitor.md`

## Quick Reference

```bash
# New client
/central-egos provision dr-joao --tier=solo
/central-egos ingest dr-joao ~/docs/escritorio/
/central-egos canais dr-joao --wa --tg
/central-egos handoff dr-joao

# Ongoing
/central-egos update dr-joao
/central-egos monitor dr-joao
```

## Client State Location

`~/egos/docs/clientes/<slug>/` — profile, KB, logs, config

## Tiers

| Tier | Setup | Mensalidade | Infra |
|------|-------|-------------|-------|
| Solo | R$3.500 | R$500/mês | VPS EGOS compartilhada |
| Pro | R$6.500 | R$900/mês | Docker dedicado |
| Enterprise | R$12.000 | R$1.800/mês | VPS cliente |

