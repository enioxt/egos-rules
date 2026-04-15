---
description: Disseminar conhecimento e governanca do kernel para todo o ecossistema EGOS
---

# Workflow: /disseminate (Knowledge + Governance Propagation)

## Objetivo
Propagar conhecimento, governanca e workflows do kernel para todos os repositorios do ecossistema. Deve ser chamado ao final de toda sessao produtiva.

## Fase 1: Conhecimento (HARVEST.md + CAPABILITY_REGISTRY)

**Identificar o que foi criado/mudado nesta sessao:**
- Novo pattern? → Adicionar a `docs/knowledge/HARVEST.md`
- Nova capability? → Adicionar a `docs/CAPABILITY_REGISTRY.md`
- Bug fix com gotcha? → Adicionar a HARVEST.md
- Decisao arquitetural? → Documentar em HARVEST.md com problema/solucao/regra

**Formato HARVEST entry:**
```markdown
## {Nome do Pattern} ({data})

### Problem
{O que estava errado}

### Solution
{O que foi feito}

### Key Detail / Rule
{O detalhe que ninguem lembra}
```

## Fase 2: Governanca (kernel → ~/.egos → leaf repos)

```bash
# 1. Sync kernel para ~/.egos
cd ~/egos && bash scripts/governance-sync.sh --exec

# 2. Propagar para TODOS os leaf repos (9 repos)
bash ~/.egos/sync.sh

# 3. Verificar drift zero
bash scripts/governance-sync.sh --check
```

**Leaf repos cobertos:** 852, egos-lab, carteira-livre, br-acc, forja, egos-self, smartbuscas, santiago, arch

## Fase 3: TASKS.md Update

- Marcar tasks completadas como [x]
- Adicionar novas tasks descobertas
- Verificar que TASKS.md < 500 linhas (comprimir se necessario)
- Atualizar version e LAST SESSION header

## Fase 3B: Gem Hunter SSOT Sync

Se houve descoberta de repositório ou sessão `/study` nesta sessão:
- Atualizar `egos/docs/gem-hunter/registry.yaml` com status do repo estudado
- Mover relatórios de sessão para `egos/docs/gem-hunter/sessions/`
- Verificar que apenas `egos/docs/gem-hunter/SSOT.md` define a arquitetura (sem duplicatas)
- Reports gerados pelo CCR job: `egos-lab/docs/gem-hunter/gems-*.md` (não mover — CCR escreve lá)

## Fase 4: Meta-Prompt Triggers

```bash
cat .guarani/prompts/triggers.json 2>/dev/null | jq '.triggers | keys' 2>/dev/null
```
- Algum trigger se aplica a esta sessao?
- Deve ser criado um novo trigger?

## Fase 5: Memory

Salvar em `~/.claude/projects/-home-enio-egos/memory/` com:
- Session summary (key deliverables, decisions, state)
- Atualizar MEMORY.md index
- Remover memories obsoletas se encontrar

## Fase 6: Social (se milestone)

Canais disponiveis:
- **Telegram**: @ethikin (markdown completo, ate 4096 chars)
- **X.com**: @anoineim (280 chars + link)

Criterio: so postar se houve milestone visivel (API live, feature publica, release)

## Fase 7: Validacao Final

```bash
# Governanca
cd ~/egos && bun run governance:check

# TASKS.md size
wc -l TASKS.md  # deve ser < 500

# Pre-commit ativo
ls .husky/pre-commit

# Ultimo commit
git log --oneline -3
```

## Checklist de Saida

- [ ] HARVEST.md atualizado com patterns da sessao
- [ ] CAPABILITY_REGISTRY atualizado (se nova capability)
- [ ] Governance sync executado (drift = 0)
- [ ] Leaf repos sincronizados via ~/.egos/sync.sh
- [ ] TASKS.md atualizado e < 500 linhas
- [ ] Memory salvo
- [ ] Triggers revisados
- [ ] Social postado (se milestone)

## Regras
- Nunca alterar frozen zones sem autorizacao explicita
- Se drift > 0 apos sync, investigar e corrigir antes de encerrar
- Knowledge vai para HARVEST.md do KERNEL (~/egos), mesmo se descoberto em outro repo
- Governance e symlinkada para leaf repos (nao copiada)
