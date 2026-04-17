---
description: Hard Reset de contexto — spawna nova sessão limpa, preserva commits pendentes
---

# /checkpoint — Context Hard Reset (INC-006 Sprint 2 / T2.4)

## Objetivo
Quando o contexto da sessão atingiu os limiares (turns≥10, elapsed≥90min, commits≥15),
executar um Hard Reset: comprimir o estado essencial + guiar o usuário a abrir nova sessão.

**Estratégia:** Context Window Hard Reset (Gemini's recommendation)
Não tenta limpar contexto in-place — mata a sessão e inicia fresh com estado mínimo.

## Quando invocar
- Pre-commit emitiu `[CHECKPOINT-NEEDED]`
- `bun scripts/session-init.ts --check` retornou exit 1
- CLAUDE.md §18 detectou padrão `[CHECKPOINT-NEEDED]` no output
- Usuário pede explicitamente "/checkpoint"

## Protocolo Hard Reset (4 passos)

### 1. COMMIT QUEUE — Esvaziar pending writes
```bash
# Verificar se há trabalho não commitado
git status --short
git stash list
```
Se houver changes não commitados, commitar ou stash ANTES do reset.
Commit label: `[CHECKPOINT] wip: <descrição breve>`

### 2. SNAPSHOT — Capturar estado essencial
Escrever em `~/.egos/checkpoint-snapshot.md`:
```
# Checkpoint Snapshot — {DATE}
## Sessão
- session_id: {ID}
- turns: {N} | elapsed: {M}min | commits: {C}
## Contexto ativo
- Repo: {repo}
- Último P0: {task}
- Último commit: {hash} {msg}
## Próximos passos
- {lista ordenada P0→P1}
## Blockers
- {lista ou "nenhum"}
```

### 3. STATE RESET
```bash
bun /home/enio/egos/scripts/session-init.ts --checkpoint-done
```
Reseta contadores (turn_count=0, commit_count=0) sem apagar session_id.

### 4. HANDOFF — Instruções para nova sessão
Produzir mensagem clara:

```
## ✅ /checkpoint concluído

**Estado salvo:** ~/.egos/checkpoint-snapshot.md
**Próximo passo:** Abra uma nova sessão Claude Code e cole:

> /start
> [cole o conteúdo do checkpoint-snapshot.md]
> Continue de onde parou: {próximo P0}

**Por que nova sessão?** Contexto acumulado ({N} turns, {M}min) degrada qualidade
de raciocínio em 15-30%. Hard Reset preserva foco.
```

## Regras
- NUNCA perder trabalho: verificar git status ANTES de qualquer reset
- NUNCA spawnar subagent com contexto poluído (T2.5): o subagent tem sua própria janela
- Deferred commit queue (T2.6): se pre-commit travar por `.git/index.lock`, usar queue
- Bypass: `[CHECKPOINT]` no commit message suprime stage 0.5 do pre-commit

## Deferred Commit Queue (T2.6)
Se `.git/index.lock` existir durante checkpoint:
```bash
# Salvar para queue
echo '{"ts":"'$(date -Iseconds)'","files":["file1"],"msg":"wip: desc"}' >> ~/.egos/pending-checkpoint-writes.jsonl
# Aplicar quando lock for liberado
bun scripts/session-init.ts --apply-queue 2>/dev/null || echo "queue empty"
```
