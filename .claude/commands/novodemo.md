# /novodemo — Nova Loja Demo EGOS

Cria uma nova demo white-label a partir do template Central EGOS (base G Peças).

## Como usar

```
/novodemo <nome-do-cliente>
/novodemo "Peças Patense" --tipo=autopecas
/novodemo --ajuda
```

## Fluxo de execução (6 fases)

### Fase 1 — Intake (5 min)
Coletar do usuário ou inferir do nome:
- Nome comercial e nome curto
- Setor (eletrodomésticos / auto peças / outro)
- Cidade e estado
- WhatsApp e telefone (opcional)
- Cores: primária + accent (sugerir paleta por setor se não informado)

### Fase 2 — Research (automático)
- Checar se já existe `TenantProfile` para o slug em `apps/central-egos-template/src/lib/tenant.ts`
- Gerar slug a partir do nome (ex: "Peças Patense" → `pecas-patense`)
- Sugerir categorias baseadas no setor (eletrodomésticos vs auto peças vs genérico)
- Gerar headline candidata

### Fase 3 — Config (escrita em código)
Criar `TenantProfile` completo e adicionar em `tenant.ts`:
```typescript
const NOVA_LOJA_PROFILE: TenantProfile = {
  slug: "<slug>",
  domains: ["<slug>.egos.ia.br", "localhost:<porta>"],
  branding: {
    name: "<Nome Completo>",
    shortName: "<Nome Curto>",
    logoText: "<Inicial>",
    primaryColor: "<#hex>",
    accentColor: "<#hex>",
    headline: "<headline>",
    categories: [/* setor-appropriate */],
  },
  contact: { phone: "", whatsapp: "", address: "", hours: "" },
  seo: { /* derivado do nome + setor */ },
  runtime: {
    publicBaseUrl: "https://<slug>.egos.ia.br",
    caddyDomain: "<slug>.egos.ia.br",
    pm2AppName: "<slug>-app",
    port: <próxima porta disponível>,
    remoteAppPath: "/opt/apps/<slug>",
    whatsappInstance: "egos-<slug>",
  },
  dataNamespace: { mode: "neutral-tables", tablePrefix: "" },
  storage: {
    productImagesBucket: "product-images",
    strategy: "shared-bucket",
    basePath: "<slug>/products",
  },
  adminBootstrap: {
    ownerEmail: "admin@<slug>.local",
    ownerName: "Owner <Nome Curto>",
    initialRole: "owner",
    passwordDelivery: "manual",
  },
};
```

### Fase 4 — Design Handoff
Gerar checklist de assets necessários:
- [ ] Logo (SVG ou PNG, fundo transparente)
- [ ] Cor primária confirmada (hex)
- [ ] Cor accent confirmada (hex)
- [ ] Foto hero (opcional)
- [ ] Descrição SEO (1-2 frases)
- [ ] 3-5 categorias de produtos

### Fase 5 — Infrastructure
Gerar comandos para o VPS (não executar — apresentar para aprovação):
```bash
# Caddy: adicionar bloco em /opt/bracc/infra/Caddyfile
# PM2: criar ecosystem entry
# Supabase: garantir tenant_slug nos produtos existentes
```

### Fase 6 — QA Checklist
- [ ] `getTenantFromHost("<slug>.egos.ia.br")` retorna slug correto
- [ ] Storefront home mostra nome, headline, categorias corretos
- [ ] Catálogo com filtro `tenant_slug` ativo (neutral-tables)
- [ ] Dark mode desabilitado no storefront (light wrapper)
- [ ] MCP: verificar se precisa de instância nova ou compartilha existente
- [ ] `bun run typecheck` limpo

## Paletas por setor

| Setor | Primária | Accent |
|-------|----------|--------|
| Auto peças | #1565C0 | #FFC107 |
| Eletrodomésticos | #1a56b0 | #f5c518 |
| Ferragens | #37474F | #FF6F00 |
| Materiais de construção | #2E7D32 | #FF8F00 |
| Móveis usados | #4A148C | #FFD600 |
| Genérico | #1E88E5 | #FFA000 |

## Próximas portas disponíveis

Verificar em `tenant.ts`: porta atual maior + 1.
- G Peças: 3080
- Auto Peças Patense (FVP): 3081
- Próxima: 3082

## SSOT

- Template base: `apps/central-egos-template/`
- Perfis de tenant: `apps/central-egos-template/src/lib/tenant.ts`
- Caddyfile: `/opt/bracc/infra/Caddyfile` (VPS)
- Deploy: `scripts/deploy-gpecas.sh` (adaptar para novo slug)
