---
description: Full client KB onboarding: interview, data inventory, LGPD scan, ingest pipeline. Use when: first engagement with new client, building knowledge base from scratch. Follows KBS discovery protocol.
---

# /client-onboard — Diagnóstico e Onboarding na Máquina do Cliente

> **Produto:** D — Leitor de Documentos EGOS
> **Quando usar:** primeiro dia de implementação na máquina/servidor do cliente
> **Tempo estimado:** 30–60 min (depende do volume de documentos)
> **Modelo:** Gemini 2.0 Flash via OpenRouter (padrão)

---

## Fase 0: Verificar pré-requisitos

```bash
echo "=== EGOS Client Onboard — verificando ambiente ==="
node --version 2>/dev/null || echo "Node: não encontrado"
bun --version 2>/dev/null || echo "Bun: não encontrado"
python3 --version 2>/dev/null || echo "Python3: não encontrado"
echo "OPENROUTER_API_KEY: ${OPENROUTER_API_KEY:0:8}... (${#OPENROUTER_API_KEY} chars)"
if [ -z "$OPENROUTER_API_KEY" ]; then
  echo "⚠️  OPENROUTER_API_KEY não configurada."
  echo "   Configure com: export OPENROUTER_API_KEY=sk-or-..."
fi
```

Se a chave não estiver configurada, instrua o cliente ou use a chave EGOS:
- Chave EGOS: usar apenas para piloto (limite contratual)
- Chave do cliente: criar no painel OpenRouter, budget cap por chave

---

## Fase 1: Inventário de documentos

```bash
echo "=== Fase 1: Inventário de documentos ==="
TARGET_DIR="${1:-$HOME}"
echo "Diretório alvo: $TARGET_DIR"
echo ""

# Contar por tipo
echo "PDFs encontrados:"
find "$TARGET_DIR" -name "*.pdf" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l

echo "Documentos Word:"
find "$TARGET_DIR" \( -name "*.docx" -o -name "*.doc" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l

echo "Planilhas:"
find "$TARGET_DIR" \( -name "*.xlsx" -o -name "*.xls" -o -name "*.csv" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l

echo "TXT/Markdown:"
find "$TARGET_DIR" \( -name "*.txt" -o -name "*.md" \) -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l

echo ""
echo "Tamanho total estimado:"
find "$TARGET_DIR" \( -name "*.pdf" -o -name "*.docx" -o -name "*.doc" \) -not -path "*/node_modules/*" 2>/dev/null -exec du -sh {} + 2>/dev/null | awk '{sum += $1} END {print sum " MB total"}'

# Listar os 10 maiores PDFs
echo ""
echo "Top 10 PDFs por tamanho:"
find "$TARGET_DIR" -name "*.pdf" -not -path "*/node_modules/*" 2>/dev/null -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh | head -10 | awk '{print $5, $9}'
```

Anote os resultados e pergunte ao cliente:
- Quais pastas contêm os documentos mais importantes?
- Existe alguma pasta que NÃO deve ser processada (confidencial, pessoal)?
- Qual o período de interesse (ex: contratos dos últimos 2 anos)?

---

## Fase 2: Amostra NER (10 documentos)

```bash
echo "=== Fase 2: NER em amostra ==="
TARGET_DIR="${1:-$HOME}"
OUTPUT_DIR="./egos-client-results"
mkdir -p "$OUTPUT_DIR"

# Selecionar 10 PDFs aleatórios para amostra
find "$TARGET_DIR" -name "*.pdf" -not -path "*/node_modules/*" 2>/dev/null | shuf | head -10 > /tmp/egos_sample_files.txt
echo "Arquivos selecionados para amostra:"
cat /tmp/egos_sample_files.txt
```

Para cada arquivo da amostra, executar extração de entidades:

```bash
# Instalar dependências se necessário
cd /home/enio/egos
bun install 2>/dev/null || npm install 2>/dev/null

# Executar NER na amostra
bun scripts/extract-pdf-entities.ts \
  --files /tmp/egos_sample_files.txt \
  --model "google/gemini-2.0-flash-001" \
  --output "$OUTPUT_DIR/sample_entities.csv" \
  --format csv
```

Se o script não existir ainda (FOCUS-D-002 pendente), usar extração manual via Claude:

Para cada PDF da amostra, abra e peça ao Claude Code para extrair:
- **Pessoas:** nomes completos, cargos
- **Organizações:** empresas, órgãos, CNPJs
- **Datas:** datas de início, término, vencimento
- **Valores:** valores monetários, quantidades
- **Documentos:** CPF, CNPJ, contratos, processos

Salve em `$OUTPUT_DIR/sample_entities.csv` com colunas: `arquivo,tipo,valor,contexto,confiança`

---

## Fase 3: Estimativa de custo e prazo

Com base na amostra, calcule:

```bash
echo "=== Fase 3: Estimativa ==="
TOTAL_DOCS=$(find "$TARGET_DIR" -name "*.pdf" -not -path "*/node_modules/*" 2>/dev/null | wc -l)
SAMPLE_DOCS=10

echo "Total de documentos: $TOTAL_DOCS"
echo "Custo estimado por documento (Gemini 2.0 Flash): ~R$0.05-0.15"
echo "Custo estimado total: R$$(echo "$TOTAL_DOCS * 0.10" | bc) (estimativa média)"
echo "Prazo estimado (processamento sequencial): $(echo "$TOTAL_DOCS / 60" | bc) horas"
echo "Prazo com paralelismo (8 workers): $(echo "$TOTAL_DOCS / 480" | bc) horas"
```

Regras de custo:
- Gemini 2.0 Flash: ~$0.000075/1k tokens input, $0.0003/1k tokens output
- Documento de 2 páginas típico: ~1500 tokens → ~$0.0002 USD → ~R$0.001
- Para 1000 documentos: ~R$1-5 de custo de API (absorvido na mensalidade)

---

## Fase 4: Relatório de saída

Gerar relatório para o cliente em `$OUTPUT_DIR/relatorio-diagnostico.md`:

```markdown
# Diagnóstico EGOS — [Nome do Cliente] — [Data]

## Resumo executivo
- **Total de documentos encontrados:** X
- **Tipos:** X PDFs, X DOCX, X planilhas
- **Amostra processada:** 10 documentos
- **Entidades encontradas na amostra:** X pessoas, X empresas, X CNPJs, X datas

## O que foi encontrado
[Lista das entidades mais relevantes da amostra]

## Estimativa para processamento completo
- **Custo de API:** R$ X (absorvido na mensalidade EGOS)
- **Prazo:** X horas de processamento
- **Entrega:** CSV + relatório por categoria de entidade

## Próximos passos recomendados
1. Confirmar pastas para processar / excluir
2. Assinar contrato + definir modelo de chave (EGOS ou cliente)
3. Executar lote completo
4. Validar amostra de resultados com cliente
5. Entrega final: CSV + sumário executivo

## Precificação
- Setup + processamento do lote: R$ [X]
- Critério de done: lote processado + cliente validou amostra de 50 docs
```

---

## Fase 5: Comprimir e enviar resultados

```bash
echo "=== Fase 5: Compactando resultados ==="
OUTPUT_DIR="./egos-client-results"
DATE=$(date +%Y-%m-%d)
CLIENT_NAME="${2:-cliente}"
ZIP_NAME="egos-diagnostico-${CLIENT_NAME}-${DATE}.zip"

zip -r "$ZIP_NAME" "$OUTPUT_DIR/"
echo "Pacote criado: $ZIP_NAME"
echo "Enviar para o cliente via: WeTransfer, Google Drive, ou link seguro"
ls -lh "$ZIP_NAME"
```

---

## Checklist de conclusão

Antes de sair da máquina do cliente, confirmar:
- [ ] Relatório de diagnóstico gerado e revisado
- [ ] CSV com entidades da amostra salvo e enviado
- [ ] Estimativa de custo e prazo comunicada
- [ ] Próximos passos definidos e acordados
- [ ] Chave de API removida do ambiente (se foi a chave EGOS)
- [ ] Nenhum dado do cliente ficou em repositório ou cloud sem autorização

```bash
# Limpar chave da sessão antes de sair
unset OPENROUTER_API_KEY
echo "✅ Chave removida do ambiente"
```

---

## Referências
- Capacidade: `docs/capabilities/014-ner-extracao-entidades.md`
- Pipeline NER: `intelink/scripts/ner-mass-run.sh`
- Scripts de extração: `intelink/scripts/extract-pdf-entities.ts`
- Modelo padrão: `google/gemini-2.0-flash-001` via OpenRouter
- FOCUS_SELECTION: `docs/capabilities/FOCUS_SELECTION_v1.md`
