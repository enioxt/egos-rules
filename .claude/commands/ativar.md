---
description: Ativa o modo operacional para um cliente EGOS — lê o contexto do MCP, exibe KPIs, lista todas as ações disponíveis e orienta o próximo passo.
---

# /ativar — Painel Operacional EGOS

Você está ativando o modo operacional para gerenciamento de uma loja via MCP.

## Instruções para o agente

1. **Chamar `mcp__egos-g-pecas__kpi_summary`** para obter o estado atual da loja
2. **Chamar `mcp__egos-g-pecas__inventory_lowstock`** com threshold=3 para alertas
3. **Exibir painel** com os dados reais obtidos

## Formato de exibição obrigatório

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏪 PAINEL G PEÇAS — [data atual]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 ESTOQUE
   Produtos ativos: [N]
   Novos: [N] | Usados: [N]
   ⚠️ Estoque crítico (≤3): [N] produtos

📋 PEDIDOS (30 dias)
   Total: [N] | Pendentes: [N]
   💰 Receita: R$ [valor]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧 AÇÕES DISPONÍVEIS AGORA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📖 CONSULTAS (leitura)
   1. "Busca produtos" — catalog_search
   2. "Lista por categoria" — catalog_list  
   3. "Detalhe do produto [nome]" — catalog_get
   4. "Pedidos recentes" — orders_list
   5. "Detalhe do pedido [id]" — orders_get
   6. "Estoque crítico" — inventory_lowstock
   7. "KPI da loja" — kpi_summary
   8. "FAQ e políticas" — faq_search / policies_get

✏️ ESCRITA (cria rascunho)
   9. "Cadastra produto [nome]" — product_create_draft
      → Conversa guiada para preencher todos os campos
      → Produto fica como RASCUNHO (não aparece no site)
      → Você recebe o link do admin para adicionar foto e publicar

📱 REQUER PAINEL WEB (gpecas.egos.ia.br/admin)
   → Upload de fotos
   → Publicar/despublicar produto
   → Editar preço e estoque
   → Ver financeiro e auditoria

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
O que quer fazer?
```

## Se alguma tool falhar

- Se `kpi_summary` falhar: exibir "⚠️ KPI indisponível" e continuar
- Se MCP não estiver configurado: orientar para adicionar `egos-g-pecas` no settings.json
- Nunca inventar dados — todos os números vêm do MCP

## Argumentos opcionais

`$ARGUMENTS` pode conter o nome do cliente ou contexto adicional para personalizar a saudação.