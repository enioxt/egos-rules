# Client Tiers Matrix — EGOS

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Status:** canonical T1
> **Origem:** Enio 2026-05-20 — "AnythingLLM não serve para todo cliente; nem todos têm requisitos"
> **SSOT:** este arquivo + [CLIENT_KB_DOCTRINE.md](CLIENT_KB_DOCTRINE.md) + [CLIENT_QUALIFICATION_INTERVIEW.md](CLIENT_QUALIFICATION_INTERVIEW.md)

---

## Princípio fundador

> **Nem todo cliente precisa de AnythingLLM. A maioria começa só com dashboard/site funcional via smartphone. KB inteligente é UPSELL após valor inicial entregue.**

Não tentar empurrar AnythingLLM para cliente sem requisitos = preserva qualidade, evita churn, mantém pricing R$500 entry viável.

---

## Matriz de tiers (3 níveis)

### TIER BASE — Dashboard + Site (90% dos casos iniciais)
**O que tem:**
- Site mobile-first responsivo (storefront tenantizado central-egos-template)
- Admin web (cadastro produtos, pedidos, FAQ, políticas)
- WhatsApp bot básico (FAQ, catálogo, leads)
- Métricas operacionais (vendas, pedidos, estoque)
- Hospedagem VPS EGOS (subdomínio.egos.ia.br)

**Quem se encaixa:**
- Cliente SEM funcionário fixo para operar sistema novo
- Cliente SEM computador dedicado na loja
- Cliente que ainda precisa entrar no digital primeiro
- Volume de docs internos baixo (<50 PDFs/manuais)
- Foco em vender mais / atender melhor (não em organizar conhecimento)

**Exemplo real:** G Peças HOJE (sem computador, funcionária de férias)

**Pricing:**
- Setup: R$ 500 (não-reembolsável)
- Mensal: R$ 100/mês (sem fidelidade)
- Upsells por demanda: design custom, integrações, automações

---

### TIER PLUS — Base + KB Inteligente (AnythingLLM)
**O que adiciona ao Base:**
- AnythingLLM em subdomínio próprio (`kb.<slug>.egos.ia.br`)
- N workspaces por departamento (catálogo, atendimento, técnico)
- KB com manuais fabricante, políticas internas, FAQ extensa
- Chat com docs próprios em PT-BR (mobile + desktop)
- Acesso via **Android app nativo** OU web responsive no celular
- Audit logs LGPD-compliant

**Quem se encaixa (REQUISITOS OBRIGATÓRIOS):**

```
☐ Cliente tem AO MENOS 1 funcionário fixo treinável para operar
☐ Cliente tem ≥ 30 documentos relevantes (manuais, políticas, FAQ)
☐ Cliente quer reduzir "tribal knowledge" risk
☐ Cliente está saturado de perguntas repetidas internas/clientes
☐ Cliente passou ≥ 3 meses no Tier Base (provou que opera sistema)
☐ Cliente concorda com R$300-500/mês adicional pela camada IA
```

**Quem NÃO se encaixa:**
- Cliente sem funcionário fixo (não tem quem alimentar o KB)
- Cliente com <20 docs (overkill)
- Cliente novo (sem track record Tier Base)
- Cliente em setor proibido (advocacia, saúde clínica — ver CLIENT_KB_DOCTRINE §Whitelist)

**Exemplo real:** Auto Peças Patense (candidato, mas precisa entrevista)

**Pricing:**
- Setup adicional: R$ 2.500-5.000 (one-time) — inclui Espiral diagnóstico + setup AnythingLLM + treinamento equipe 2h
- Mensal adicional: R$ 300-500/mês (atualização regras + suporte assíncrono + ajuste prompts)
- Mínimo: 3 meses

---

### TIER PREMIUM — Base + KB + Automação completa
**O que adiciona ao Plus:**
- Hermes-EGOS bot WhatsApp consultando KB automaticamente
- Cron jobs (relatórios diários, alertas estoque, lembretes)
- Integrações Gmail/Drive (ingest automático de docs)
- Dashboard EGOS-side com observabilidade
- Custom MCPs para ações no sistema do cliente
- Instância dedicada (Tier ALPHA da KB doctrine) se NDA/sensível

**Quem se encaixa:**
- Cliente PLUS validado (≥ 6 meses, ≥ R$3k/mês recorrente)
- Cliente com necessidade real de automação (não wishlist)
- Cliente com 2+ funcionários treinados no sistema
- Volume justifica: ≥ 500 conversas/mês WhatsApp OU ≥ 100 docs ingeridos

**Pricing:**
- Setup adicional: R$ 5.000-20.000 (escopo modular por feature)
- Mensal adicional: R$ 800-2.000/mês conforme integrações

---

## Tabela visual de qualificação

| Critério | Base | Plus | Premium |
|---|---|---|---|
| Site/admin/WA bot básico | ✅ obrigatório | ✅ herda | ✅ herda |
| Funcionário fixo treinável | — | ✅ obrigatório | ✅ ≥2 |
| Computador/smartphone na loja | smartphone OK | smartphone OK (mas dispositivo dedicado preferível) | dispositivo dedicado |
| Volume docs | < 20 | 30-100 | > 100 |
| Volume conversas WA/mês | < 200 | 200-500 | > 500 |
| LGPD sensitivity | baixa | média | qualquer |
| Setor | qualquer (exceto vetados) | whitelist KB doctrine | whitelist + isolamento dedicado |
| Track record | 0 (novo) | ≥3 meses Base | ≥6 meses Plus |
| Setup | R$ 500 | + R$ 2.500-5.000 | + R$ 5.000-20.000 |
| Mensal | R$ 100 | + R$ 300-500 | + R$ 800-2.000 |
| Fidelidade | sem | min 3 meses | contrato anual |

---

## Decisão de tier — fluxograma

```
Cliente novo entra
    ↓
[1] Entrevista qualificação (docs/governance/CLIENT_QUALIFICATION_INTERVIEW.md)
    ↓
[2] Score requisitos
    ↓
    ├─ Setor PROIBIDO (advocacia/psicologia/clínica)? → REJEITAR
    │
    ├─ Sem funcionário fixo + sem computador? → TIER BASE (apenas)
    │
    ├─ Tem funcionário fixo + computador + ≥30 docs + ≥3 meses estável? → BASE + PLUS oferecido
    │
    └─ Tem PLUS validado ≥6 meses + automação justificável? → PREMIUM oferecido
    ↓
[3] Proposta com Tier + setup + mensal
    ↓
[4] Cliente aceita → onboarding com checklist de tier
    ↓
[5] Validação 30/90/180 dias → considerar upsell para próximo tier
```

---

## Casos reais (estado 2026-05-20)

### G Peças (Julio, Patos de Minas)
- **Tier atual:** BASE
- **Status:** funcionalidades vivas, sem AnythingLLM
- **Razão não-Plus:** sem computador dedicado na loja + funcionária de férias + dashboard via smartphone resolve 100% das necessidades atuais
- **Caminho upsell futuro:** após 3+ meses estável + funcionário fixo retornar + acumular 30+ docs → reavaliar Tier Plus
- **Próxima ação:** continuar refinamento orgânico do dashboard via processo cadastro produtos

### Auto Peças Patense (Bernardo, candidato)
- **Tier candidato:** BASE → Plus (TBD)
- **Status:** discovery presencial pendente (CET-NEXT-CLIENT-002)
- **Próxima ação:** rodar CLIENT_QUALIFICATION_INTERVIEW para decidir Tier
- **Sinal positivo Plus:** se tem funcionário fixo + computador + interesse em organizar manuais → candidato Plus
- **Sinal Base:** se equipe pequena sem computador → começar Base como G Peças

### Ferro Velho Patense (Gilton, prospect)
- **Tier candidato:** BASE
- **Status:** aguarda site Ferro Velho pronto nos moldes G Peças
- **Caminho:** mesmo de G Peças — Base primeiro, Plus depois

---

## Implicações operacionais

### Para o EGOS-side (Enio)
- **Investimento mínimo por cliente Base:** ~5-10h setup (replica template, ajusta tenant, treina 1h)
- **Investimento por cliente Plus:** +8-15h (Espiral + AnythingLLM + treinamento + ajuste prompts)
- **Investimento por cliente Premium:** +20-40h (integrações + automação + observability)
- **Cap operacional:** com 4h/dia após-hours, suporta ~5 Base + 2 Plus + 1 Premium simultâneos

### Para o cliente
- **Base:** facilidade — não precisa de nada além do smartphone
- **Plus:** compromisso — precisa de pelo menos 1 funcionário treinável
- **Premium:** parceria — equipe + processos + investimento real

### Para vendas
- Foco inicial = Tier Base (volume + entrada baixa)
- Upsell para Plus = só após Base validado
- Premium = só por demanda explícita do cliente

---

## Anti-padrões (NÃO fazer)

- ❌ Vender AnythingLLM para cliente sem funcionário fixo (vira "white elephant", churn alto)
- ❌ Empacotar Plus no Tier Base como "tudo incluído" (margem ruim, suporte caro)
- ❌ Aceitar Premium sem track record Plus (alto risco operacional para você solo)
- ❌ Pular qualificação para "fechar venda" (CLIENT_QUALIFICATION_INTERVIEW é obrigatório)
- ❌ Cliente em setor proibido (advocacia, saúde clínica) — não negociar

---

## Referências

- [CLIENT_KB_DOCTRINE.md](CLIENT_KB_DOCTRINE.md) — 7 regras AnythingLLM
- [CLIENT_QUALIFICATION_INTERVIEW.md](CLIENT_QUALIFICATION_INTERVIEW.md) — questionário entrevista
- [IDENTITY_AND_METHOD.md](IDENTITY_AND_METHOD.md) — Espiral de Escuta como diagnóstico
- [MOBILE_ACCESS_GUIDE.md](../runbooks/MOBILE_ACCESS_GUIDE.md) — patterns Android/iOS/PWA
- [products/anythingllm/OPERATIONS.md](../products/anythingllm/OPERATIONS.md) — operations AnythingLLM
- Skills relevantes: `kbs-discovery` (Plus), `client-onboard` (Base), `central-egos` (provision)

*v1.0 — 2026-05-20 — Matriz de tiers + critérios de qualificação obrigatórios.*
