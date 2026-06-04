---
description: /recon <CNPJ ou nome+cidade> — 8 sub-investigações paralelas de prospecção comercial. Gera PROSPECT_DOSSIER.md + hipóteses pricing + frame venda + 5 perguntas calibração.
---

# /recon — Recon Comercial EGOS

Dado um CNPJ ou nome+cidade, executa 8 sub-investigações paralelas e gera um dossier completo para decisão de abordagem comercial.

## Uso

```
/recon 57.450.277/0001-33
/recon "G Peças Eletrodomésticos Patos de Minas MG"
/recon <CNPJ> --output=docs/strategy/prospects/
```

## O que faz

### 8 Sub-investigações (paralelas via Agent tool)

1. **CNPJ — dados oficiais (Receita Federal via CNPJá)** — usar o tool real, NÃO adivinhar:
   ```bash
   export CNPJA_API_TOKEN="$(grep '^CNPJA_API_TOKEN=' .env | cut -d= -f2-)"
   bun packages/cnpj/src/cli.ts <cnpj> --simples --registrations BR --json
   ```
   Retorna razão social, porte, CNAE principal/secundários, situação cadastral, data abertura, capital social, endereço, telefones, emails, **sócios (QSA)**, Simples Nacional. Tempo real: `--online`. (capability §110)
2. **Google Maps / Place API** — endereço real, horário, avaliação média, número de reviews, fotos
3. **Web search** — site próprio, menções em notícias, LinkedIn, presença digital geral
4. **Facebook / Instagram** — perfil, última postagem, engajamento, tom de comunicação
5. **Marketplace** — presença em ML/Shopee/OLX, volume estimado, categorias principais, reputação
6. **Reclame Aqui** — reclamações, índice de resolução, temas recorrentes
7. **Concorrentes** — 3-5 empresas similares na mesma cidade+CNAE, comparativo de presença digital
8. **Google News** — menções em imprensa local, eventos recentes, crises ou destaque positivo

### Output: PROSPECT_DOSSIER.md

```markdown
# Prospect Dossier: <nome empresa>
Data: <data>
CNPJ: <cnpj>

## Perfil
- Porte: <MEI/ME/EPP/Médio>
- Setor: <CNAE principal>
- Localização: <cidade/estado>
- Fundação: <ano>

## Presença Digital (nota 1-10)
- Site: <url ou "ausente"> | nota: X/10
- Instagram: <handle ou "ausente"> | seguidores: N | última post: <data>
- Reclame Aqui: <index> | reclamações: N

## Dores detectadas
- [dor 1 com fonte]
- [dor 2 com fonte]

## Hipóteses de Pricing
- Tier recomendado: Solo/Pro/Enterprise
- Setup estimado: R$X.XXX
- Manutenção: R$XXX/mês
- Justificativa: <2 linhas>

## Frame de Venda
<2-3 frases: abordagem, prova de valor, urgência>

## 5 Perguntas de Calibração (para reunião de discovery)
1. <pergunta com contexto por que é relevante>
2. ...
```

## Execução

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
INPUT="$1"
OUTPUT_DIR="${2:-docs/strategy/prospects}"
mkdir -p "$ROOT/$OUTPUT_DIR"
```

O agente usa WebSearch + WebFetch para cada investigação em paralelo via Agent tool (subagents), depois sintetiza com LLM (qwen3-max via llm-router).

## Anti-patterns

- NÃO inventar dados — tudo com fonte citada ou marcado `[UNVERIFIED]`
- NÃO fazer hipóteses de pricing sem pelo menos 3 dados concretos do perfil
- NÃO incluir informações pessoais de sócios além do que está público no CNPJ
- **QSA (nomes de sócios) = PII** — ao expor em dossiê/relatório/produto, passar por guard-brasil/LGPD (mascarar/minimizar conforme finalidade). Dado de CNPJ é público; nome de sócio é dado pessoal (liga §110 + guard-brasil)

## Implementação

Ao invocar `/recon`, o agente executa `scripts/recon.ts`:

```bash
bun scripts/recon.ts --input="$INPUT" --output="$ROOT/$OUTPUT_DIR" --dry
# Confirmar antes do --exec
bun scripts/recon.ts --input="$INPUT" --output="$ROOT/$OUTPUT_DIR" --exec
```
