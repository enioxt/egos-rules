---
description: Revisão de componente React/Tailwind — UX, acessibilidade, responsividade, padrões EGOS
---

# Skill: /ui-review

> Analisa um componente ou tela React/Tailwind e retorna feedback estruturado sobre UX, acessibilidade, responsividade e conformidade com padrões EGOS.

## Quando usar

- Antes de abrir PR com mudanças de UI
- Ao revisar uma tela nova ou refatorada
- Quando o usuário pede "como está esse componente" ou "revisa essa tela"

## Processo

### 1. Identificar o alvo

Ler o arquivo apontado (ou seleção IDE) e entender:
- Qual componente / página?
- Stack: Next.js App Router? Pages? Tailwind v3/v4?
- Tem dados reais ou mocados?

### 2. Checklist de revisão

Execute cada item e reporte ✅ / ⚠️ / ❌:

#### Acessibilidade (a11y)
- [ ] Imagens têm `alt` descritivo (não vazio, não "image")
- [ ] Botões têm texto ou `aria-label`
- [ ] Formulários têm `<label>` ou `aria-labelledby` em cada input
- [ ] Ordem de foco (`tabIndex`) lógica
- [ ] Contraste mínimo 4.5:1 (texto normal) / 3:1 (texto grande) — verificar cores Tailwind usadas
- [ ] Não usa apenas cor para transmitir informação

#### Responsividade
- [ ] Mobile-first (base sem prefixo → md: → lg:)
- [ ] Nenhum valor fixo `w-[NNNpx]` ou `h-[NNNpx]` que quebre em telas pequenas
- [ ] Flex/grid colapsa corretamente abaixo de 640px
- [ ] Texto legível em 320px (min-width)

#### Padrões EGOS
- [ ] Usa cores do design system (`primary`, `muted`, `destructive` etc.) — não hardcode hex
- [ ] Loading state presente para operações assíncronas
- [ ] Error state presente (não só happy path)
- [ ] Empty state presente se lista pode ser vazia
- [ ] Nenhum `console.log` em produção

#### Performance
- [ ] Imagens usam `next/image` (não `<img>`)
- [ ] Sem re-renders desnecessários (funções inline em JSX que criam nova referência por render)
- [ ] Listas longas (>50 itens) têm paginação ou virtualização

#### Código
- [ ] Componente tem responsabilidade única (não faz fetch + exibe + valida tudo junto)
- [ ] Props tipadas (não `any`)
- [ ] Nenhum segredo hardcoded

### 3. Formato de saída

```
## UI Review — [NomeDoComponente]

### Sumário
| Categoria | Status | Issues |
|-----------|--------|--------|
| Acessibilidade | ⚠️ | 2 warnings |
| Responsividade | ✅ | Nenhum |
| Padrões EGOS | ❌ | 1 erro |
| Performance | ✅ | Nenhum |

### Issues Críticos (❌)
1. **[EGOS-001]** `<img>` usado em vez de `next/image` — linha XX
   Fix: `import Image from 'next/image'; <Image src={...} alt="..." width={} height={} />`

### Warnings (⚠️)
1. **[A11Y-001]** Botão sem aria-label — linha XX
   Fix: `<button aria-label="Fechar modal">`

### Aprovado ✅
- Mobile-first correto
- Todas as props tipadas

### Estimativa de esforço para corrigir: ~Xmin
```

## Regras

- Reportar apenas o que foi observado no código — não inventar
- Se não tiver acesso ao design system, indicar `[sem design system visível]`
- Máximo 10 issues por categoria — priorizar os mais impactantes
- Não sugerir refactoring além do solicitado (§2 Karpathy)