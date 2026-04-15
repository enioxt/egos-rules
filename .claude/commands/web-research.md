---
description: Pesquisa web estruturada — busca, sintetiza e salva em HARVEST.md como padrão técnico
---

# Skill: /web-research

> Pesquisa um tópico na web (via Brave MCP ou Exa MCP), sintetiza os resultados e salva o aprendizado em `docs/knowledge/HARVEST.md` como padrão técnico.

## Quando usar

- Usuário pede "pesquisa sobre X", "como funciona Y", "melhores práticas de Z"
- Antes de implementar algo novo sem base de conhecimento interna
- Ao investigar um erro ou vulnerabilidade não documentada no ecosistema

## Processo

### 1. Formular a query

- Extrair o conceito-chave do pedido do usuário
- Montar 2-3 queries de busca (geral + específica + "best practices")

### 2. Buscar (em ordem de preferência)

```
# Opção A: Brave Search MCP
mcp__brave-search__brave_web_search(query="...", count=5)

# Opção B: Exa MCP
mcp__exa__web_search_exa(query="...", numResults=5)

# Opção C: Firecrawl (para scrape de página específica)
mcp__firecrawl__firecrawl_scrape(url="...")
```

### 3. Sintetizar

Agregar os resultados em:
- **O que é:** 2-3 frases
- **Quando usar:** casos de uso concretos
- **Como funciona:** mecanismo técnico essencial
- **Gotchas:** armadilhas comuns
- **Alternativas:** 2-3 opções com trade-offs
- **Fontes:** URLs das principais referências

### 4. Verificar relevância para o EGOS

Antes de salvar, checar:
- [ ] Conflita com algo já em HARVEST.md?
- [ ] É específico ao nosso stack (Bun/TypeScript/Next.js/Supabase)?
- [ ] Tem aplicação concreta em algum repo ativo?

### 5. Salvar em HARVEST.md

Formato de adição ao `docs/knowledge/HARVEST.md`:

```markdown
## P[N+1] — [Título do Padrão]
**Fonte:** web-research via [Brave/Exa] | **Data:** YYYY-MM-DD
**Contexto:** [por que pesquisamos isso]
**Aprendizado:**
[síntese de 3-5 bullets]
**Aplicação EGOS:** [onde isso se aplica no ecossistema]
**Referências:** [URLs]
```

### 6. Formato de saída ao usuário

```
## Pesquisa: [Tópico]

### Síntese
[3-5 parágrafos cobrindo o essencial]

### Principais pontos
- ...

### Gotchas / Armadilhas
- ...

### Alternativas
| Opção | Quando usar | Trade-off |
|-------|------------|-----------|

### Salvo em HARVEST.md
→ P[N] adicionado (ou: "já coberto em P[X]")

### Fontes
- [URL] — [título]
```

## Regras

- Sempre verificar se o tópico já está em HARVEST.md antes de pesquisar
- Não salvar informação que já está documentada no ecosistema (§7 SSOT)
- Marcar claims não verificados como `unverified:` (§8 Evidence-First)
- Se busca retornar >10 resultados, usar apenas os 3-5 mais relevantes
- Nunca citar fonte sem ter lido o conteúdo (não só o título)