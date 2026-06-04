---
name: dead-code-cleanup
description: Detecta e remove código morto (exports/funções não usados) via dead_code_detector agent. Apresenta achados agrupados por arquivo, permite HITL approve/reject por item. Run com: /dead-code-cleanup
allowed-tools: Bash, Read, Edit, Grep, Glob
source_candidate: docs/_drafts/skill-candidates/qa-dead_code_dead_code_detector-2026-05-18.md
status: active
implemented: 2026-05-18
---

# /dead-code-cleanup — Dead Code Analysis + Cleanup

Você executou `/dead-code-cleanup`. Siga os passos abaixo.

## Passo 1 — Rodar análise

```bash
cd /home/enio/egos
bun agents/agents/dead-code-detector.ts 2>&1 | grep -E "^\s+(ℹ️|⚠️|❌)" | head -60
```

## Passo 2 — Agrupar por arquivo e priorizar

Após ver o output:
- Agrupe mentalmente as issues por arquivo
- Priorize: warnings (68 esperados) > info (355 esperados)
- Ignore arquivos em `agents/runtime/runner.ts` se exports forem API pública
- Foco principal: `packages/`, `apps/`, `scripts/` — não `agents/runtime/`

## Passo 3 — Apresentar ao usuário (formato compacto)

Mostre os **top 5 arquivos com mais dead code** neste formato:

```
📁 <arquivo>
   - <symbol> [remove|mark @public|keep]
   - <symbol> [remove|mark @public|keep]
```

Recomende ação padrão por tipo:
- `dead:function` com 0 imports → remover export (ou marcar `/** @public */` se API externa)
- `empty:file` → verificar se pode deletar
- `dead:const` → remover

## Passo 4 — Executar fixes aprovados

Para cada item aprovado:

**Remover export de função:**
```typescript
// Antes:
export function foo() { ... }

// Depois (remover apenas o 'export', manter a função se usada internamente):
function foo() { ... }
// OU deletar completo se também não usada internamente
```

Use `Edit` tool para mudanças, 1 arquivo por vez.

## Passo 5 — Verificar após cada arquivo

Após editar qualquer arquivo:
```bash
bun run typecheck 2>&1 | grep -E "error TS" | head -10
```

Se erros → reverter a mudança antes de continuar.

## Passo 6 — Commitar

```bash
git add <arquivos-editados>
git commit -m "chore(dead-code): remove N unused exports — /dead-code-cleanup"
```

## Anti-patterns

- ❌ Não remover exports de `packages/*/src/index.ts` sem verificar consumers externos
- ❌ Não deletar arquivos sem `git grep <symbol>` no repo inteiro
- ❌ Não commitar sem typecheck passar

## Estado atual (referência)

Últimos dados do dead_code_detector (2026-05-18, 656ms de scan):
- 781 arquivos analisados
- 961 exports
- 423 findings (68 warnings, 355 info)
- Top arquivos com dead code: `agents/skills/memory-ingest.ts`, `agents/agents/mcp-router.ts`

Execute `/dead-code-cleanup` a cada 2-4 semanas ou antes de refactors grandes.