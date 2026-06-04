---
description: /keyword-temas <tema> — keyword→pautas para SEO (substitui o fluxo SEMrush da Gabi). Expande via Google autocomplete (grátis) + GSC-CSV opcional, clusteriza por intenção, gera pautas blog/social/youtube com source-tag. Saída = relatório markdown → NotebookLM.
---

# /keyword-temas — Motor SEO keyword→temas (EGOS)

Transforma um tema em **clusters de keyword por intenção** + **pautas priorizadas** (blog/social/youtube), usando dados grátis + camada de IA. MVP da proposta para a Gabi (substituir SEMrush no fluxo keyword→temas).

> **SSOT da proposta:** [docs/strategy/SEO_ENGINE_PROPOSAL.md](../../docs/strategy/SEO_ENGINE_PROPOSAL.md)
> **Premortem (ler antes de evoluir):** [docs/audits/premortem-keyword-temas.md](../../docs/audits/premortem-keyword-temas.md)

## Uso

```
/keyword-temas "consórcio de imóveis"
/keyword-temas "consórcio de imóveis" --gsc data/gsc-export.csv
/keyword-temas "consórcio de imóveis" --hl pt-BR --gl br --output docs/seo-reports/
```

## Escopo MVP (TRAVADO — premortem F5)

Faz **só** keyword→temas (dores #2 e #3 da Gabi). **NÃO** faz concorrente (#4) nem GEO (#1-IA) — esses estão DEFER em TASKS (SEO-GEO-001). Não passar do gate de validação (SEO-MVP-005) sem o "sim" da Gabi.

## Fontes de dado (premortem F2 — estratégia invertida)

| Fonte | O que dá | Robustez | Tag |
|---|---|---|---|
| **Google autocomplete** | fraseado real de demanda (SEM volume) | alta (endpoint estável, sem auth) | `[fonte:autocomplete]` |
| **GSC-CSV** (opcional) | impressão/clique/posição REAIS do site | alta (export manual, sem OAuth) | `[fonte:GSC]` |
| Keyword Planner | faixas de volume | secundária (Fase 1, precisa Ads OAuth) | — |
| DataForSEO | volume/CPC exatos | Fase 1 ($, gate humano SEO-F1-001) | — |

MVP usa autocomplete (sempre) + GSC-CSV (quando a Gabi exporta do site dela). Volume exato é Fase 1.

> **Branch GSC-CSV validado (smoke 2026-05-29):** rodado com CSV sintético (headers PT-BR `Consulta,Cliques,Impressões,Posição`). As 8 consultas entraram no relatório com tag `[fonte:GSC | impr=… cliques=… pos=…]` e a IA priorizou por posição real (quick-win pos 5-20) na tabela de pautas. Quando a Gabi trouxer o export real do site dela, o caminho está provado.

## Regra dura de source-tag (premortem F1)

- **TODO número** no relatório carrega `[fonte:...]`.
- A IA **NUNCA inventa volume de busca ou CPC**. Prioriza por ranking qualitativo (alta/média/baixa) ou rotula `IA-sugerido (não-verificado)`.
- Keyword de autocomplete = demanda real de fraseado, mas **sem volume** — não atribuir número.

## Diferencial (premortem F3 — lidera pelo que a IA faz melhor)

Não é brainstorm de ideias óbvias. É **clusterização por intenção** (informacional/comercial/transacional) + **gap de SERP** + priorização por quick-win real (GSC posição 5-20). A expertise da Gabi + a orquestração da IA sobre dado grátis é o valor — não um banco de keyword pago.

## Legal (premortem F6)

Entrega **pautas para humano produzir**, nunca artigos prontos para auto-publicar em massa (penalidade Google scaled-content-abuse 2025). HITL obrigatório antes de qualquer publicação.

## Implementação

MVP é **puro TS + LLM** (premortem F7 — sem KeyBERT/Python na v1). Reusa `packages/shared/src/llm-providers/llm-router.ts` (`callHermes`).

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
# 1. DRY (só expande, mostra amostra, não chama LLM nem escreve)
bun "$ROOT/scripts/keyword-temas.ts" --tema "<tema>" --dry
# 2. EXEC (gera relatório markdown)
bun "$ROOT/scripts/keyword-temas.ts" --tema "<tema>" --gsc <csv-opcional> --exec
```

Saída: `docs/seo-reports/keyword-temas-<slug>-<data>.md`.

### Pipeline → NotebookLM (SEO-MVP-004)

Após gerar o relatório, suba-o para o vault da Gabi no NotebookLM (RAG persistente por projeto). O agente chama o MCP `notebooklm-mcp`:

```
mcp__notebooklm-mcp__source_add(notebook_id="<id-do-projeto-gabi>", source_type="file", file_path="docs/seo-reports/keyword-temas-<slug>-<data>.md", wait=true)
```

Um notebook por cliente/projeto. O relatório vira fonte pesquisável — a Gabi pergunta em linguagem natural sobre as pautas. (HITL: revisar o relatório antes de subir.)

**Curadoria — o que sobe (e o que NÃO sobe):** o notebook é compartilhado com a Gabi e *toda fonte alimenta tanto o RAG (Q&A) quanto o Studio (slides/áudio)* — não dá para marcar uma fonte como "só RAG". Logo, suba só o que é **client-facing**:
- ✅ Explicador/proposta (o que é, como ler um relatório) — alimenta os slides.
- ✅ Relatórios `keyword-temas-*` (o output real) — alto valor de RAG; a Gabi consulta as pautas dela.
- ❌ **Não** subir: premortem, `TASKS.md`/`ROADMAP`, a própria skill `.md`, rascunhos de pesquisa. São internos (jargão EGOS, análise de falha) → poluiriam tanto o Q&A quanto a regeneração de slides.

Para regenerar slides depois de adicionar relatórios, use `focus_prompt` no `studio_create` para manter o deck na mensagem da proposta (senão ele tende a "puxar" detalhe demais do relatório).

## Entrega (premortem F4)

No MVP **o Enio roda** e entrega o relatório markdown para a Gabi (→ upload no NotebookLM dela, que ela LÊ). **Não** prometer self-serve no terminal ainda — self-serve (web/dashboard) é Fase 3, só se validar.

## Anti-patterns

- NÃO imprimir volume/CPC sem tag de fonte → vira `IA-sugerido (não-verificado)`.
- NÃO gerar artigo pronto para auto-publicação (só pautas).
- NÃO expandir escopo para concorrente/GEO no MVP.
- NÃO prometer que a Gabi roda sozinha no terminal na v1.
