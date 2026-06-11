---
description: /pesquisa <tema> — Protocolo de pesquisa rigorosa multi-modal do EGOS. DATE-FIRST + fontes obrigatórias (arXiv/GitHub/X/Reddit/web/docs) + classificação REAL/CONCEPT/PHANTOM + tabela de achados + síntese + lacunas + 3 perguntas afiadas.
---

# /pesquisa — Protocolo de Pesquisa Rigorosa EGOS

> **Composável com:** `/deep-research` (para relatório longo com fan-out) | **Escopo:** pesquisa curta a média, invocável inline | **Idioma de saída:** PT-BR

---

## REGRA DE OURO — DATE-FIRST [OBRIGATÓRIO, sem exceção]

**ANTES de qualquer busca:**

```bash
date +%F   # usar a data real do sistema, não a data de treinamento do modelo
```

Se `date` não estiver acessível, usar a data fornecida no contexto da sessão (campo `currentDate` no system prompt ou memória). Hoje é **2026-06-09** (âncora desta versão).

**Por que isso importa:** modelos de linguagem têm cutoff de treinamento. Pesquisa sobre tecnologia, papers e mercado de 2024/2025 é frequentemente desconhecida. Toda busca usa a data atual como âncora de recência: descarta fontes sem data ou com data >18 meses sem avisar explicitamente.

---

## Fase 0 — Briefing da pesquisa (30 segundos)

Antes de buscar, articular em voz alta:

```
TEMA: <o que exatamente estou pesquisando>
DECISÃO DEPENDENTE: <que decisão ou ação depende desta pesquisa>
PROFUNDIDADE: surface (5min) | standard (15min) | deep (composar com /deep-research)
DATA ÂNCORA: <data de hoje obtida acima>
```

Se o tema for ambíguo (ex: "pesquisa IA para mim"), fazer **2-3 perguntas de escopo** antes de executar — não adivinhar.

---

## Fase 1 — Fontes obrigatórias multi-modais

Executar as buscas **em paralelo** quando possível (Agent tool ou múltiplas chamadas simultâneas).

### 1a. arXiv — Papers acadêmicos

**Ferramenta:** `mcp__claude_ai_Hugging_Face__paper_search` (se disponível) OU WebSearch com operador `site:arxiv.org`

```
Query pattern: "<tema> arxiv <ano_atual> OR <ano_anterior>"
Fallback query: "site:arxiv.org <tema> 2025 OR 2026"
```

Extrair: título, autores, data de submissão, abstract, link. Descartar papers >2 anos sem contexto histórico explícito.

### 1b. GitHub — Repos, issues, trending

**Ferramenta:** WebSearch ou `mcp__claude_ai_Exa__web_search_exa`

```
Query pattern: "site:github.com <tema> stars:>100"
Query pattern: "github <tema> trending 2025 OR 2026"
```

Extrair: repo, stars, última atualização, linguagem, README summary. Repos sem commit nos últimos 6 meses = STALE (avisar).

### 1c. X.com — Opinião de praticantes e novidades

**Ferramenta:** WebSearch

```
Query pattern: "site:x.com OR site:twitter.com <tema> since:<ano-mes-atual>"
Query pattern: "<tema> x.com 2025 OR 2026"
```

Extrair: handle do autor, data do post, claim principal. Classificar como PRÁTICA-COMUM ou HEURÍSTICA (X raramente = OFICIAL).

### 1d. Reddit — Discussão de comunidade e casos reais

**Ferramenta:** WebSearch ou `mcp__claude_ai_Exa__web_search_exa`

```
Query pattern: "site:reddit.com/r/<subreddit_relevante> <tema>"
Subreddits de fallback: r/MachineLearning, r/LocalLLaMA, r/programming, r/devops
```

Extrair: subreddit, upvotes (se visível), data, claim principal, consenso da thread.

### 1e. Web geral — Notícias, blogs técnicos, benchmarks

**Ferramenta:** WebSearch + `mcp__claude_ai_Exa__web_fetch_exa` para páginas completas

```
Query pattern: "<tema> 2026 OR 2025 site:techcrunch.com OR site:huggingface.co OR site:openai.com"
Query pattern: "<tema> benchmark results 2025"
```

Prioridade de fontes confiáveis: documentação oficial > paper peer-reviewed > blog técnico com dados > blog opinião.

### 1f. Documentação oficial

**Ferramenta:** `mcp__claude_ai_Context7__resolve-library-id` + `mcp__claude_ai_Context7__query-docs` (se for biblioteca/SDK/framework)

```
Quando usar: usuário menciona ferramenta específica (React, LangChain, etc.)
Sempre preferir sobre memória de treinamento — docs podem ter mudado
```

---

## Fase 2 — Rigor e classificação

Para **cada claim coletado**, aplicar dupla classificação:

### Classificação A — Existência/Verificação

| Label | Critério |
|-------|----------|
| `REAL` | Verificado via fonte primária (paper, doc oficial, repo com código rodando) |
| `CONCEPT` | Proposto/publicado mas sem implementação verificada ou produção |
| `PHANTOM` | Mencionado por modelo de linguagem ou source não-verificável; pode não existir |

### Classificação B — Tipo de fonte

| Label | Critério |
|-------|----------|
| `OFICIAL` | Doc oficial, paper peer-reviewed, anúncio do maintainer |
| `PRÁTICA-COMUM` | Amplamente adotado pela comunidade com evidência (repos, threads, casos) |
| `HEURÍSTICA` | Opinião de praticante, regra de polegar sem validação formal |

**Anti-alucinação obrigatório:**
- Nunca inventar nome de ferramenta, paper, repo ou API
- Se não encontrou via busca real: declarar `[BUSCA SEM RESULTADO]` — nunca preencher com memória de treinamento como se fosse achado atual
- Data de publicação da fonte é obrigatória — fonte sem data = `[DATA DESCONHECIDA]`

---

## Fase 3 — Verificação de lacunas de acesso

Após as buscas, verificar quais fontes não foram acessadas e por quê:

```
[ ] arXiv — OK / FALHOU (motivo: ___)
[ ] GitHub — OK / FALHOU
[ ] X.com — OK / FALHOU
[ ] Reddit — OK / FALHOU
[ ] Web geral — OK / FALHOU
[ ] Docs oficiais — OK / N/A
[ ] Exa MCP — DISPONÍVEL / INDISPONÍVEL
[ ] HuggingFace MCP — DISPONÍVEL / INDISPONÍVEL
```

**Se Exa não disponível:** avisar o usuário com instrução de configuração:
```
⚠️ Exa MCP não disponível. Para habilitar:
   1. Obter API key em exa.ai
   2. Adicionar ao MCP config: { "mcp__claude_ai_Exa": { "apiKey": "..." } }
   Alternativa: WebSearch padrão cobre a maioria dos casos.
```

**Se HuggingFace MCP não disponível:** usar `site:arxiv.org` e `site:huggingface.co` via WebSearch como fallback.

---

## Fase 4 — Tabela de achados (formato AI→AI)

```markdown
## Achados — <TEMA> | Data pesquisa: <DATA>

| # | Fonte | URL | Data pub. | Claim | Existência | Tipo fonte |
|---|-------|-----|-----------|-------|------------|------------|
| 1 | arXiv | https://... | 2026-05-XX | <claim em 1 frase> | REAL | OFICIAL |
| 2 | GitHub | https://... | 2026-04-XX | <claim> | REAL | PRÁTICA-COMUM |
| 3 | Reddit r/ML | https://... | 2026-03-XX | <claim> | CONCEPT | HEURÍSTICA |
| 4 | Blog | https://... | [DATA DESCONHECIDA] | <claim> | PHANTOM | HEURÍSTICA |
```

Regras da tabela:
- Mínimo 5 linhas para `standard`, 10 para `deep`
- Ordenar por data decrescente (mais recente primeiro)
- Claims PHANTOM aparecem na tabela mas marcados — nunca omitir, nunca promover

---

## Fase 5 — Síntese executiva

Formato denso AI→AI (sem prosa, máximo 10 linhas):

```markdown
## Síntese — <TEMA>

**Estado atual (DATA):** <1 frase do estado da arte>
**Achado principal:** <claim mais robusto com fonte>
**Consenso:** <há ou não consenso na comunidade — com evidência>
**Tendência:** <direção observada nos últimos 6 meses>
**Conflito/debate:** <onde há discordância entre fontes>
**Relevância para EGOS:** <implicação direta para o sistema/decisão>
```

---

## Fase 6 — Lacunas identificadas

```markdown
## Lacunas

- **Não encontrado:** <o que foi buscado e não achou — NÃO INVENTAR>
- **Fonte ausente:** <fonte que existiria mas não foi acessada — ex: paywall, login>
- **Dado desatualizado:** <o que existe mas é velho demais para confiar>
- **Busca limitada por:** <restrição técnica, rate limit, MCP indisponível>
```

---

## Fase 7 — 3 Perguntas afiadas

Gerar 3 perguntas que o usuário deveria se fazer a partir dos achados. Critérios:
- Cada pergunta aponta para uma **decisão ou ação concreta**
- Não são perguntas retóricas — têm resposta buscável
- Ordenadas por impacto (maior primeiro)

```markdown
## 3 Perguntas afiadas

1. **[IMPACTO ALTO]** <pergunta concreta que o achado levanta>
2. **[IMPACTO MÉDIO]** <pergunta de aprofundamento>
3. **[VALIDA PREMISSA]** <pergunta que testa a premissa central da pesquisa>
```

---

## Fluxo completo (resumo operacional)

```
1. DATE-FIRST — obter data real do sistema
2. Briefing — articular tema + decisão dependente + profundidade
3. Buscas paralelas — 1a-1f (arXiv + GitHub + X + Reddit + web + docs)
4. Classificar — REAL/CONCEPT/PHANTOM + OFICIAL/PRÁTICA-COMUM/HEURÍSTICA
5. Verificar lacunas de acesso — avisar sobre MCPs indisponíveis
6. Tabela de achados — mínimo 5 linhas com URL + data + claim + classificação
7. Síntese — 10 linhas densas
8. Lacunas — o que não foi encontrado (honesto, sem inventar)
9. 3 Perguntas afiadas — apontam para decisão/ação
```

---

## Integração com deep-research

`/pesquisa` = protocolo curto (surface a standard). Para relatório longo com fan-out adversarial de múltiplas fontes:

```
/pesquisa <tema>           → 5-20 min, tabela + síntese + perguntas
/deep-research <tema>      → 30-60 min, relatório completo com citações em profundidade
```

Quando invocar deep-research: pesquisa retornar lacunas críticas + decisão irreversível dependente + tema com alta ambiguidade entre fontes.

---

## Anti-patterns desta skill

- `[PROIBIDO]` Iniciar busca sem estabelecer data atual (DATE-FIRST é gate, não sugestão)
- `[PROIBIDO]` Retornar achados de memória de treinamento como se fossem buscas recentes
- `[PROIBIDO]` Omitir fonte PHANTOM da tabela — deve aparecer marcado
- `[PROIBIDO]` Misturar síntese com claims não verificados sem classificação explícita
- `[PROIBIDO]` Criar arquivo de relatório em `docs/` sem pedido explícito — retornar inline
- `[PROIBIDO]` Pesquisa sobre decisão irreversível sem oferecer escalar para `/deep-research`

---

*Versão: 1.0.0 — 2026-06-09 | SSOT: `.claude/commands/pesquisa.md` | Composável com: `/deep-research`, `/recon`, `/banda`*
