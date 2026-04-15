---
description: Diagnostic completo do ecossistema EGOS — agentes, VPS, telemetria, governanca, integrações
---

# Workflow: /diag (Full Ecosystem Diagnostic)

## Objetivo
Executar um diagnostic completo e honesto do EGOS em menos de 5 minutos. Separar FATOS de INFERENCIAS. Nunca inventar dados.

## Execucao (todas as fases em paralelo quando possivel)

### Fase 1: Agentes (3 sub-agents em paralelo)

**1A — Registry vs Filesystem:**
```bash
# Kernel
cd /home/enio/egos && bun agents/agents/ssot-auditor.ts --dry 2>&1 | tail -5
cat agents/registry/agents.json | jq '[.agents[] | select(.status=="active")] | length'
cat agents/registry/agents.json | jq '[.agents[] | select(.status=="dead")] | length'

# Lab
cd /home/enio/egos-lab && bun agent:lint 2>&1 | tail -3
cat agents/registry/agents.json | jq '[.agents[] | select(.status=="active")] | length'
```

**1B — VPS Agents:**
```bash
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 '
  echo "=== CONTAINERS ==="
  docker ps --format "table {{.Names}}\t{{.Status}}" | head -20
  echo "=== CRON ==="
  crontab -l 2>/dev/null | grep -v "^#" | grep -v "^$"
  echo "=== AGENT LOGS (last 24h) ==="
  find /var/log/egos-agents/ -name "*.log" -mtime -1 -exec wc -l {} \; 2>/dev/null
'
```

**1C — Agent Health Quick-Test (--dry on key agents):**
```bash
cd /home/enio/egos-lab
timeout 10 bun agents/agents/uptime-monitor.ts --dry 2>&1 | tail -5
timeout 10 bun agents/agents/quota-guardian.ts --dry 2>&1 | tail -5
```

### Fase 2: Integrações

| Integracao | Teste |
|-----------|-------|
| Guard Brasil API | `curl -s https://guard.egos.ia.br/health` |
| Guard Brasil Web | `curl -s -o /dev/null -w "%{http_code}" https://guard.egos.ia.br/` |
| Supabase | MCP `mcp__claude_ai_Supabase__list_tables` (project lhscgsqhiooyatkebose) |
| VPS SSH | `ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 'uptime'` |
| NPM Package | `npm view @egosbr/guard-brasil version 2>/dev/null` |
| Bun | `bun --version` |
| Gitleaks | `gitleaks version 2>/dev/null` |
| Git remotes | `cd /home/enio/egos && git remote -v` |

### Fase 3: Governanca

```bash
cd /home/enio/egos
bun run governance:check 2>&1 | tail -3
bash scripts/governance-sync.sh --check 2>&1 | tail -3
wc -l TASKS.md
git log --oneline -5
```

### Fase 4: Telemetria

Verificar:
- Event bus: `packages/shared/src/event-bus.ts` existe e compila?
- Supabase tables: agent_events, gem_hunter_gems, telemetry_events_v2 existem?
- VPS agents emitem eventos? (grep "emit" nos 4 agentes VPS)

### Fase 4B: Gem Hunter SSOT Health

```bash
# Verificar integridade do SSOT
ls /home/enio/egos/docs/gem-hunter/         # registry.yaml, weights.yaml, SSOT.md
ls /home/enio/egos-lab/docs/gem-hunter/ | wc -l   # reports count
cat /home/enio/egos-lab/docs/gem-hunter/latest-run.json 2>/dev/null | head -5
# Duplicatas removidas?
[ -L /home/enio/852/scripts/gem-hunter-secops.ts ] && echo "symlink OK" || echo "DUPLICATE STILL EXISTS"
[ -f /home/enio/egos/agents/agents/aiox-gem-hunter.ts ] && echo "DEAD CODE STILL EXISTS" || echo "cleaned OK"
```

### Fase 5: Memoria e Ativacao

```bash
ls ~/.claude/projects/-home-enio-egos/memory/ | wc -l
cat ~/.claude/projects/-home-enio-egos/memory/MEMORY.md | wc -l
ls ~/.egos/.claude/commands/
cat ~/.claude/CLAUDE.md | head -3
```

## Formato de Saida Obrigatorio

```
## EGOS Diagnostic — {data}

### Agentes
| Metrica | Valor |
|---------|-------|
| Kernel ativos | X |
| Lab ativos | X |
| Mortos | X |
| VPS containers | X (Y healthy) |
| VPS cron jobs | X |

### Integrações
| Integracao | Status | Detalhe |
|-----------|--------|---------|
| Guard API | ✅/❌ | {latency} |
| ... | ... | ... |

### Governanca
- Drift: {count}
- TASKS.md: {lines}/500
- Pre-commit: {status}
- Ultimo commit: {hash} {msg}

### Telemetria
- Event bus: ✅/❌
- Supabase tables: X/3
- Agentes com emit(): X/4

### Memoria
- Memory files: X
- MEMORY.md: X lines
- CLAUDE.md: v{version}
- Commands: {list}

### Problemas Encontrados
1. {problema} — {severidade}
2. ...

### Recomendacoes
- P0: ...
- P1: ...
- P2: ...

✅ /diag concluido — {X}/{Y} sistemas OK
```

## Regras
- NUNCA inventar numeros — todos devem vir de comandos reais
- Se um teste falhar, reportar o erro exato
- Separar FATOS (observados) de INFERENCIAS (deduzidos)
- Tempo maximo: 5 minutos
