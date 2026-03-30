---
description: start workflow (compatibility wrapper)
---

# /start (Compatibility Wrapper)

Este arquivo mantém compatibilidade com superfícies legadas do Windsurf.

## Fonte canônica
- Workflow canônico operacional: `.agents/workflows/start-workflow.md`

## Comportamento
1. Carregar e executar `.agents/workflows/start-workflow.md` como SSOT.
2. Tratar regras específicas do cliente Windsurf apenas como camada de compatibilidade.
3. Em caso de conflito, prevalece o conteúdo de `.agents/workflows/start-workflow.md`.

## Doctor Command Integration
O workflow /start executa a validação de ambiente via `bun run doctor --json` na fase GATE:
- **Report Location**: `docs/_generated/doctor-report.json` (timestamped)
- **Health Categories**: env, file, provider, hooks, workspace, governance
- **Exit Codes**: 0 (ok), 1 (warnings), 2 (failures)
- **Flags**: `--doctor-skip` para contorno, `--fix` para auto-fixes

## SSOT Gem Scan (run at end of startup checks)

A 30-second scan — not exhaustive. Surface unlinked files before work begins.

```bash
# From repo root — find files in key dirs not referenced in TASKS.md
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
for dir in docs archive _current_handoffs; do
  [ -d "$ROOT/$dir" ] && find "$ROOT/$dir" -maxdepth 2 -name "*.md" \
    | while read f; do
        base=$(basename "$f")
        grep -q "$base" "$ROOT/TASKS.md" 2>/dev/null || echo "UNLINKED: $f"
      done
done
```

For each UNLINKED file found:
- Read a 5-line summary
- Log in TASKS.md: `- [x] SSOT-VISIT [date]: [path] → [disposition]`
- Flag as `gem-found` if content appears valuable and unmerged

This step is advisory — do not block /start if gems are found, but do log them.

## Saída obrigatória
- `✅ /start concluído — Kernel ativo`
- Resumo com fatos verificados, inferências e propostas
- Doctor health score e recommendations (se houver alertas)
- SSOT Gem Scan result: N unlinked files found, M logged
