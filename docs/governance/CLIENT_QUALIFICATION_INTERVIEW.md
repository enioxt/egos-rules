# Client Qualification Interview — EGOS

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Status:** canonical T1
> **Origem:** Enio 2026-05-20 — "ali na entrevista vou saber se encaixa ou não, o que encaixa"
> **SSOT:** [CLIENT_TIERS_MATRIX.md](CLIENT_TIERS_MATRIX.md) — esta entrevista decide o tier
> **Aplicado por:** Enio na conversa Espiral de Escuta com prospect

---

## Como usar

A entrevista é a **Espiral de Escuta aplicada** (método-mãe EGOS). Não é checklist robotizado — é conversa guiada que coleta sinais nas categorias abaixo. Ao final, você responde "Score Sheet" e decide o tier.

**Duração esperada:** 30-60min, presencial ou videocall.
**Quem responde:** ideal owner do negócio + se possível 1 funcionário operacional.
**Saída:** Score Sheet preenchido + recomendação de Tier (Base/Plus/Premium) + proposta.

---

## Bloco 1 — Identidade do negócio (5min)

Perguntas para conhecer o cliente humano antes do diagnóstico técnico:

1. Me conta um pouco do negócio: o que vocês fazem, há quanto tempo, quantas pessoas?
2. Qual o tamanho atual da equipe operacional? (1 / 2-5 / 6-15 / 16+)
3. Há quem da família ou sócio também opera o sistema?
4. Há quem do time tem mais familiaridade com tecnologia/celular?
5. Qual é a dor mais urgente AGORA? (não daqui 6 meses — agora)

**Sinais coletados:**
- Porte: micro / pequeno / médio
- Maturidade digital da equipe: baixa / média / alta
- Urgência: baixa / média / alta

---

## Bloco 2 — Infraestrutura existente (10min)

Perguntas que filtram BASE vs PLUS imediatamente:

1. **Têm computador na loja/escritório?**
   - Não → BASE only (smartphone-first)
   - Sim, mas usado raramente → BASE (ou Plus se outros critérios fortes)
   - Sim, ligado todo dia, alguém usa → candidato Plus

2. **Têm internet estável?**
   - Não / instável → BASE (offline-first patterns)
   - Sim, fibra/4G/5G OK → qualquer tier

3. **Equipe usa celular para trabalho?**
   - Maioria sim → confirma viabilidade mobile-first
   - Apenas WA pessoal → BASE com onboarding mobile UX cuidadoso

4. **Já usam algum sistema de gestão?**
   - Não, papel/planilha → Tier BASE simples
   - Sim, ERP/PDV → integração possível (Tier Plus/Premium)
   - Sim, mas não usam direito → diagnóstico cuidadoso antes de proposta

5. **Têm WhatsApp Business?**
   - Sim → integração WA bot Tier BASE
   - Não, só pessoal → propor migrar antes
   - Não usam WA → mercado raro

6. **Conexão entre quem opera (loja, casa, oficina)?**
   - 1 ponto → simples
   - Múltiplos pontos → multi-tenant ou multi-acesso

**Sinais coletados:**
- Infra mínima: smartphone OK / desktop disponível / multi-device
- Dependência de internet: alta/baixa
- Gap de digitalização: pequeno / grande

---

## Bloco 3 — Funcionário/operação (10min)

Perguntas que decidem Plus viable ou não:

1. **Quem vai operar o sistema novo no dia-a-dia?**
   - Você (owner) só → BASE only (owner sobrecarregado = churn)
   - Funcionário fixo dedicado → Plus viable
   - Estagiário rotativo → BASE only
   - Ninguém claro ainda → ❌ NÃO vender sistema avançado

2. **Esse funcionário tem como aprender e treinar 1-2h?**
   - Sim, paciente, gosta de aprender → Plus excelente
   - Sim, mas só com você junto → Plus com onboarding presencial
   - Não, mal usa celular → BASE simples + WA bot

3. **A pessoa é estável ou alta rotatividade?**
   - Estável (>1 ano de casa) → Plus seguro
   - Recém-contratada → BASE primeiro, Plus depois
   - Rotativa (estagiários, ajudantes) → BASE only

4. **Quanto tempo/semana essa pessoa tem para alimentar o sistema?**
   - Tem rotina dedicada → Plus
   - Encaixa quando dá → BASE com automações
   - Não tem tempo → BASE only

5. **Quem decide o que o sistema deve fazer?** (donos? gerente?)
   - Owner pragmático → decisão rápida
   - Comitê → propostas estruturadas
   - Confuso → mais Espiral de Escuta antes de proposta

**Sinais coletados:**
- Funcionário fixo treinável: SIM / NÃO / TBD
- Capacidade operacional: alta / média / baixa
- Decisão estruturada: clara / confusa

---

## Bloco 4 — Volume de conhecimento (10min)

Perguntas que decidem se KB AnythingLLM agrega ou é overkill:

1. **Tipos de documentos importantes:**
   - Manuais técnicos de produtos/fabricantes
   - Políticas internas (troca, devolução, garantia)
   - Tabelas de preços, listas, planilhas
   - Contratos modelos
   - Histórico de tickets/atendimentos
   - Procedimentos operacionais (SOPs)
   - Outros: _____

2. **Quantos arquivos aproximadamente?**
   - < 20 → KB overkill, dashboard FAQ resolve
   - 20-100 → KB viable (Plus)
   - 100-500 → KB recomendado
   - 500+ → KB essencial (Plus ou Premium)

3. **Esses arquivos mudam com que frequência?**
   - Raramente (1x/ano) → upload manual OK
   - Mensalmente → cron de re-ingest
   - Semanalmente → integração Drive/Gmail (Premium)
   - Diariamente → automação dedicada (Premium)

4. **Equipe perde tempo procurando informação?**
   - Não, sabem onde tudo está → KB pouco valor
   - Às vezes, especialmente quando alguém pergunta novidade → Plus viable
   - Sempre, é caos → Plus alta prioridade

5. **Clientes perguntam as mesmas coisas repetidas?**
   - Não, sempre diferentes → FAQ básico no site resolve
   - Sim, mas atendentes sabem responder → FAQ + WA bot Tier Base
   - Sim e atendentes têm dúvida sempre → Plus + bot consultando KB

**Sinais coletados:**
- Volume docs: baixo / médio / alto
- Frequência update: baixa / média / alta
- Dor de "tribal knowledge": baixa / média / alta

---

## Bloco 5 — Dados sensíveis e LGPD (5min)

Perguntas para filtrar setores proibidos:

1. **Vocês lidam com:**
   - Dados de saúde mental / clínicos → 🔴 NÃO (CFP/CFM)
   - Documentos jurídicos com privilégio cliente-advogado → 🔴 NÃO (Heppner 2026)
   - CPF/RG/cartão de clientes frequentemente → 🟡 Tier ALPHA isolado (instância dedicada)
   - Dados pessoais leves (nome, telefone) → 🟢 qualquer tier
   - Só dados de produtos/operacional → 🟢 qualquer tier

2. **Há requisitos regulatórios específicos?** (CRC, CRECI, CRM, etc)
   - Sim → cuidado adicional + revisão jurídica

3. **Cliente final exige privacidade reforçada?**
   - Sim → Tier ALPHA (instância dedicada) obrigatório

**Sinais coletados:**
- Setor: aprovado / cautela / proibido
- Sensibilidade: baixa / média / alta

---

## Bloco 6 — Modelo econômico (5min)

Perguntas para validar que cliente pode pagar pelo tier proposto:

1. **Faturamento estimado:**
   - < R$ 30k/mês → BASE só (R$100 mensalidade é viável)
   - R$ 30-100k/mês → BASE com upgrade Plus em 3-6m
   - > R$ 100k/mês → Plus já na partida (se requisitos)

2. **Já investem em tecnologia?**
   - Não, primeira vez → BASE como porta de entrada
   - Sim, ERP/site/marketing → propor evolução
   - Sim, mas insatisfeitos → diagnosticar antes

3. **Qual o ROI esperado?** (em palavras do cliente)
   - "Vender mais" → focar dashboard + WA bot
   - "Atender melhor" → focar FAQ + chat
   - "Economizar tempo da equipe" → considerar Plus
   - "Profissionalizar imagem" → site + branding

4. **Topam ciclo: setup → 3 meses observação → upsell?**
   - Sim → pricing tier funciona
   - Querem "tudo já" → educar sobre risco de overkill
   - Não querem mensalidade → BASE pontual (raro, baixa margem)

---

## Score Sheet (preencher após entrevista)

```
Cliente: _______________________________
Setor: _________________________________
Data entrevista: 2026-__-__
Entrevistador: Enio

=== INFRA (Bloco 2) ===
Computador na loja:        [ ] Não   [ ] Sim
Internet estável:          [ ] Não   [ ] Sim
WA Business:               [ ] Não   [ ] Sim
Equipe usa celular:        [ ] Não   [ ] Sim
ERP atual:                 [ ] Não   [ ] Sim ______

=== FUNCIONÁRIO (Bloco 3) ===
Funcionário fixo treinável: [ ] NÃO  [ ] SIM
Estabilidade equipe:       [ ] alta  [ ] média  [ ] rotativa
Tempo p/ alimentar sistema: [ ] sim  [ ] não

=== VOLUME DOCS (Bloco 4) ===
Estimativa docs:           [ ] <20   [ ] 20-100   [ ] 100+
Tribal knowledge dor:      [ ] baixa [ ] média    [ ] alta
Perguntas repetidas:       [ ] não   [ ] às vezes [ ] sempre

=== LGPD (Bloco 5) ===
Setor permitido:           [ ] sim   [ ] cautela  [ ] PROIBIDO
PII sensível:              [ ] baixa [ ] média    [ ] alta (precisa ALPHA)

=== ECONÔMICO (Bloco 6) ===
Pode pagar R$100/mês:      [ ] sim   [ ] não
Pode pagar R$500 setup:    [ ] sim   [ ] não
Aceita modelo upsell:      [ ] sim   [ ] não

=== DECISÃO ===
Tier recomendado:          [ ] BASE  [ ] PLUS  [ ] PREMIUM  [ ] REJEITAR
Justificativa: _____________________________________________
Próxima ação: _____________________________________________
Data próxima conversa: ____________________________________
```

---

## Tabela de decisão automática

| Condição | Decisão |
|---|---|
| Setor proibido (advocacia/psicologia/clínica) | ❌ REJEITAR |
| Sem funcionário fixo OU sem computador OU <20 docs | 🟢 BASE only |
| Tem funcionário fixo + computador + 30+ docs + dor tribal knowledge média/alta | 🟡 PLUS (após Base 3m OU direto se sinais muito fortes) |
| PLUS validado ≥6 meses + ≥2 funcionários treinados + volume alto | 🔵 PREMIUM elegível |
| PII sensível alta | Tier ALPHA obrigatório (instância dedicada) — só Plus/Premium |

---

## Template proposta pós-entrevista

```markdown
# Proposta EGOS — [Cliente]

Data: 2026-__-__
Tier recomendado: BASE / PLUS / PREMIUM

## O que entrego

### Tier BASE (R$ 500 setup + R$ 100/mês)
- Site mobile-first em [slug].egos.ia.br
- Admin web (catálogo, FAQ, pedidos)
- WhatsApp bot básico
- Hospedagem + monitoramento + backups
- Suporte assíncrono via WhatsApp

### Próximos passos
1. Você confirma essa proposta
2. Pago R$500 não-reembolsável
3. Setup em 7-10 dias úteis
4. Treinamento 1h via call
5. 90 dias de uso real → reavaliamos upsell (Plus)

## O que NÃO está incluído neste tier
- KB inteligente AnythingLLM (Plus — disponível quando atingir requisitos)
- Bot WA com IA consultando documentos (Plus)
- Integrações Gmail/Drive/CRM (Premium)
- Dashboard custom (Premium)

## Por que recomendei este tier
[texto curto baseado no Score Sheet]

## Setup com Enio
- Pagamento: [forma]
- Início: [data]
- Treinamento: [agendar]
- Contato suporte: [canal]
```

---

## Casos reais — aplicação

### G Peças (entrevista retrospectiva 2026-05-20)
```
Funcionário fixo treinável:  ❌ NÃO (de férias, situação temporária)
Computador na loja:          ❌ NÃO (só smartphone Julio)
Volume docs:                 < 20 (catálogo + FAQ)
Decisão:                    🟢 BASE
Status atual:               implementado, funcional, refinamento orgânico
Próxima reavaliação:        quando funcionária retornar + acumular 30+ docs
```

### Auto Peças Patense (entrevista pendente)
```
Status:                     CET-NEXT-CLIENT-002 — entrevista a marcar
Decisão preliminar:         BASE de início (mesmo padrão G Peças)
Sinais Plus se aparecerem:  funcionário fixo experiente + manuais Brastemp/Consul ricos + interesse em organizar
```

### Ferro Velho Patense (entrevista futura)
```
Status:                     aguarda site nos moldes G Peças primeiro
Decisão preliminar:         BASE
```

---

## Anti-padrões

- ❌ Pular entrevista para "fechar venda rápido" → cliente errado no tier errado
- ❌ Empurrar Plus para cliente sem funcionário fixo → "white elephant" + churn
- ❌ Aceitar setor proibido → risco legal sem retorno
- ❌ Vender mensalidade < R$100 → margem ruim, suporte caro
- ❌ Pular Score Sheet → decisões por simpatia em vez de evidência

---

## Referências
- [CLIENT_TIERS_MATRIX.md](CLIENT_TIERS_MATRIX.md) — matriz de tiers
- [CLIENT_KB_DOCTRINE.md](CLIENT_KB_DOCTRINE.md) — 7 regras AnythingLLM
- [IDENTITY_AND_METHOD.md](IDENTITY_AND_METHOD.md) — Espiral de Escuta (método entrevista)
- Skills relacionadas: `kbs-discovery`, `client-onboard`, `consulting-onboarding`
- BUSINESS_CASE.md Espiral — modelo de validação por experimento

*v1.0 — 2026-05-20 — questionário Espiral aplicado para qualificação por tier.*
