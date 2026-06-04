---
description: Cria novo Demo Central EGOS para cliente qualificado. Wrapper de provision-client.sh + checklist pós-provision (12 itens). Triggers — novo demo, criar demo, novo cliente, provisionar tenant. Pré-requisito — cliente passou Fase 0 (CNPJ, faturamento, reunião 30min).
---

# /novodemo — Criar Demo Central EGOS

> **Pré-requisito obrigatório (Fase 0):** cliente passou qualificação Bernardo
> Ver: [`docs/governance/CLIENT_ONBOARDING_CHECKLIST.md`](../../docs/governance/CLIENT_ONBOARDING_CHECKLIST.md) Fase 0
> Demo customizado custa 2-4h Enio sem cobrança — não desperdiçar com lead não qualificado.

## Quando invocar

- Bernardo enviou ficha cliente qualificado
- Cliente pediu reunião e bateu critério Fase 0
- Enio quer testar nova feature com tenant fictício (`<slug>=test-XXX`)

## Inputs obrigatórios (perguntar antes)

1. **Slug** (kebab-case): ex `farmacia-vivamais`
2. **Subdomain**: ex `farmaciavivamais.egos.ia.br`
3. **Porta PM2** (opcional, default 7080+offset)
4. **Nome comercial**: ex "Farmácia Viva+"
5. **Cores brand** (hex): primary + accent
6. **Logo URL ou path local**: cliente envia OR placeholder
7. **Segmento**: ex `farmácia, comércio, pet, peças`
8. **5-10 produtos exemplo** (nome + preço + categoria mínimo)

## Execução

### Via Ops API (canônico — INV-MON-002..006)

```bash
OPS_TOKEN="$EGOS_OPS_TOKEN"
BASE="https://gpecas.egos.ia.br"  # ou localhost:3080 pra testes

# 1. Provision — cria tenant em `tenants` + stub em `tenant_settings`
curl -s -X POST "$BASE/api/ops/tenant-provision" \
  -H "X-Ops-Token: $OPS_TOKEN" -H "Content-Type: application/json" \
  -d '{"slug":"<slug>","branding":{"name":"<Nome>","primaryColor":"<hex>","contactEmail":"<email>","whatsappNumber":"<ddi+numero>"},"dataNamespace":{"mode":"neutral-tables"},"runtime":{"whatsappInstance":"<slug>-wa","port":<porta>},"deployment":{"caddyDomain":"<subdomain>","repoUrl":"https://github.com/enioxt/egos","deployScript":"scripts/deploy-tenant.sh"}}'

# 2. Seed — popula consulting_clients (WHITELIST), tenant_bot_config, tenant_settings.sector
# ⚠️ CRÍTICO: sem este passo, chatbot WA NÃO aceita mensagens do tenant (bug 2026-05-25)
curl -s -X POST "$BASE/api/ops/tenant-seed" \
  -H "X-Ops-Token: $OPS_TOKEN" -H "Content-Type: application/json" \
  -d '{"slug":"<slug>","sector":"<segmento>","welcomeMessage":"Olá! Bem-vindo(a) à <Nome>!"}'

# 3. Config — branding avançado + feature flags
curl -s -X POST "$BASE/api/ops/tenant-config" \
  -H "X-Ops-Token: $OPS_TOKEN" -H "Content-Type: application/json" \
  -d '{"slug":"<slug>","branding":{"name":"<Nome>","primaryColor":"<hex>"},"featureFlags":{"chatbotEnabled":true,"catalogPublic":true}}'

# 4. Deploy — PM2 start + Caddy (requer vps-api online)
curl -s -X POST "$BASE/api/ops/tenant-deploy" \
  -H "X-Ops-Token: $OPS_TOKEN" -H "Content-Type: application/json" \
  -d '{"slug":"<slug>","port":<porta>,"domain":"<subdomain>","appPath":"/opt/apps/<slug>-standalone","envVars":{},"addCaddy":true}'

# 5. Smoke
curl -s "$BASE/api/ops/tenant-smoke?slug=<slug>"

# 6. Cadastrar produtos
bun central-egos/scripts/ingest-xlsx-products.ts --tenant <slug> --file <products.xlsx>
```

## Checklist pós-provision (13 itens)

- [ ] Tenant em `tenants` registrado (via `/api/ops/tenant-provision`)
- [ ] **`consulting_clients` INSERT confirmado** — smoke check `db.consulting_clients=pass` (⚠️ sem isto chatbot WA rejeita todas as mensagens — bug 2026-05-25)
- [ ] Tenant em `tenant_bot_config` criado
- [ ] Storage bucket `product-images/<slug>/` criado
- [ ] PM2 process `egos-<slug>` rodando
- [ ] Caddy bloco subdomain + MCP bloco adicionados
- [ ] DNS subdomain resolve
- [ ] Login admin/admin documentado
- [ ] Watermark "Preview" visível
- [ ] Checkout em modo fake (banner "Não homologado")
- [ ] 5-10 produtos cadastrados
- [ ] Cores brand aplicadas
- [ ] Logo carregado
- [ ] Smoke 7 rotas 200 OK

**Tempo total:** 2-5h Enio.

## Regra de ouro

> **Nunca crie hardcode em `central-egos/clients/<slug>/`**
> Regras gerais ficam no `central-egos/template/`.
> Cliente dir só tem overrides específicos (cores, segmento, produtos seed).
> Toda feature nova deve funcionar em TODOS os tenants — modular no template.

## Erros comuns

| Erro | Solução |
|---|---|
| `SUPABASE_URL` não definido | `source ~/.egos/.env.prod` antes |
| Caddy 502 | `pm2 restart egos-<slug>` + check logs |
| Smoke `db.consulting_clients=fail` | Executar passo 2 (`/api/ops/tenant-seed`) — **chatbot WA fica mudo sem isso** |
| Smoke `db.tenants=fail` | Executar passo 1 (`/api/ops/tenant-provision`) |
| Smoke falha rota X | Check `tenant_bot_config` campos obrigatórios |
| Ops API → 403 Forbidden | Token tem role insuficiente — usar master token (EGOS_OPS_TOKEN) |
| DNS não resolve | Cloudflare propaga em 5-15min |

## Pós-Demo

**Cliente fecha contrato** (em 7-14 dias): ver `CLIENT_ONBOARDING_CHECKLIST` Fase 2-6.

**Cliente NÃO fecha em 14d**: marcar tenant `inactive`, parar PM2 (preservar dados):
```bash
pm2 stop egos-<slug>
bun -e "import {createClient} from '@supabase/supabase-js'; const s = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY); await s.from('tenant_bot_config').update({status:'inactive', deactivated_at: new Date()}).eq('slug', '<slug>')"
```

## Referências

- `docs/governance/CLIENT_ONBOARDING_CHECKLIST.md` — fluxo completo 6 fases
- `docs/governance/EGOS_COMERCIO_PLANO_UNICO.md` v3.2 — preços canonical
- `central-egos/scripts/provision-client.sh` — automação técnica (263 LOC)
- `central-egos/README.md` — overview produto
