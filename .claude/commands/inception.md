---
description: Project Inception Gate (PIG) — recon obrigatório antes de aceitar nova ideia/projeto/domínio. Bloqueia validação por simpatia. Origem A59 (entrevista 2026-05-08). Trigger automático em ideias novas + git init em path novo + domínio fora de §🟢 do ENIO_UNDERSTANDING_MAP.
---

# /inception — Project Inception Gate (A59)

> **Princípio governante:** Karpathy Doctrine + A59 (PIG) + A57 (cada erro vira regra).
> **Origem:** INC-2026-05-08 — IA-flatter como combustível invisível de A33 (12 repos abandonados em 15m).
> **Reframe Enio (A53):** "resistente, auditável, recuperável" — NÃO "infalível".

## TRIGGER

Auto-disparar quando QUALQUER um:

1. Enio diz: "vou criar X", "novo projeto", "vamos fazer Y", "que tal um sistema de Z"
2. Repositório novo detectado: `mkdir <novo>` + `git init` em path fora dos canonical
3. Domínio mencionado NÃO está em §🟢 do `docs/personal-os/ENIO_UNDERSTANDING_MAP.md`
4. Side project diferente do Single Pursuit aparece em conversa
5. Comando manual: `/inception <descrição-projeto>`

## CONTRATO COM AGENTE

Você está executando `/inception`. Sua obrigação:

1. **NÃO escrever 1 linha de código** antes de Phase 4 completar
2. **NÃO validar conceito entusiasticamente** antes de recon — A60 (IA-flatter combustível)
3. **Output template fixo** com 6 gap categories (Aperture-style)
4. **Esperar Enio decidir** GO/NO-GO/EXTRACT/STUDY antes de qualquer ação subsequente
5. Aceita override consciente de Enio (A8 reversibilidade) — mas LOG override

---

## PHASE 1 — Capture (5min)

Pergunte:

```
1. Nome de trabalho do projeto (~3 palavras)
2. Em 1 frase: que problema resolve?
3. Quem é o usuário NOMEADO nos próximos 30 dias? (cliente real, não "PMEs em geral")
4. Qual domínio principal? (varejo, saúde, jurídico, fintech, dev tools, etc)
5. Quanto tempo aceita gastar antes de validar?
```

Se Enio responder vago ("mais ou menos", "sei lá") → marca `task_underspecified` e pergunta de novo. NÃO avança.

---

## PHASE 2 — Domain Mastery Check (instant)

```bash
# Cross-ref com ENIO_UNDERSTANDING_MAP §🟢
grep -i "<domain>" /home/enio/egos/docs/personal-os/ENIO_UNDERSTANDING_MAP.md
```

Classifica:
- 🟢 Master zone — execução direta autorizada (skip pra Phase 3 light)
- 🟡 Em desenvolvimento — recon + advisor mode (Phase 3 full)
- 🟠 IA executa mas explica — recon + tutoring (Phase 3 full + tutor on)
- ❌ Não mapeado — recon obrigatório (Phase 3 full + STUDY-FIRST default)

---

## PHASE 3 — 8-Source Recon Paralelo (3-5min)

**Roda em paralelo** (Bash multi-call ou Agent Explore se complexo):

| Source | Tool | Pergunta investigativa |
|---|---|---|
| 1. Codebase | `mcp__codebase-memory-mcp__search_code` ou `grep -r` | Já temos algo similar em `packages/`? |
| 2. HARVEST | `grep "<domain>" docs/knowledge/HARVEST.md` | Já aprendemos lição relevante? |
| 3. Exa search | `mcp__exa__web_search_exa` | Mercado: players, soluções existentes |
| 4. GitHub | `mcp__exa__web_search_exa "category:repo <domain> open source"` | Open source equivalente? Forkavável? |
| 5. arxiv (se técnico) | exa query "site:arxiv.org <domain>" | Literatura acadêmica? |
| 6. Reddit | exa "site:reddit.com <domain> failure pattern" | Discussões, problemas conhecidos |
| 7. X.com | exa "site:x.com <domain> 2026" | Tendência, comunidade ativa |
| 8. Gem-hunter | `bun agents/agents/gem-hunter.ts --query "<domain>"` | Ferramentas/repos descobertos |

Sintetize achados em TEMPLATE FIXO abaixo.

---

## PHASE 4 — Output (TEMPLATE LITERAL)

```
═══════════════════════════════════════════════════════════
🚪 PROJECT INCEPTION GATE — <nome>
═══════════════════════════════════════════════════════════

DOMÍNIO: <X>
Status no MAP: 🟢/🟡/🟠/❌ não-mapeado
Single Pursuit alignment: aligned / divergent / orthogonal

JÁ EXISTE NO MUNDO:
- [<projeto/ferramenta 1>] (<URL>) — cobre ~X% do que você quer
- [<projeto/ferramenta 2>] (<URL>) — cobre ~Y%
- [open source equivalente?] — sim/não

JÁ EXISTE NO NOSSO CODEBASE:
- packages/<X>/ se aplica? sim/não
- HARVEST P-N relevante? sim/não — link

MERCADO/COMUNIDADE APRENDEU:
- <insight 1 do reddit/X/blog>
- <padrão de fracasso conhecido>

CUSTO ESTIMADO (com scan, regra §1.6):
- Construir do zero: <X horas>
- Fork+ajuste: <Y horas>
- Comprar pronto: <Z reais ou USD>
- Custo opportunity vs Single Pursuit Central EGOS: <impact>

GAP CATEGORIES (typed failure — Aperture pattern):
[ ] not_in_master_zones — domínio fora §🟢 (mastery check)
[ ] similar_exists_open_source — fork ao invés de construir
[ ] similar_exists_commercial — comprar/usar SaaS ao invés de construir
[ ] no_named_user_in_30d — sem cliente nomeado, é [SPECULATION]
[ ] single_pursuit_drain — divergente do Single Pursuit ativo
[ ] no_market_demand_signal — nenhum reddit/X/forum/issue mostra demanda
[ ] domain_already_solved — solução madura existe, custo fraqueja vs comprar

DECISÃO RECOMENDADA:
[ ] GO — vale construir. Justificativa: <razão concreta>
[ ] NO-GO — não vale. Alternativas: <X>, <Y>
[ ] EXTRACT-FROM-EXISTING — fork de <repo>, ajusta
[ ] STUDY-FIRST — antes de construir, leia <link 1>, <link 2>; reavalie em 7d

PERGUNTAS CALIBRAÇÃO PRA ENIO:
1. Você está disposto a ser sub-ótimo a curto prazo pra aprender o domínio?
2. Cliente nomeado nos próximos 30d? Se ninguém, marca [SPECULATION]
3. Custo opportunity vs Single Pursuit aceito?

⏸️ AGUARDANDO ENIO DECIDIR
═══════════════════════════════════════════════════════════
```

Salva como `docs/inception_reports/YYYY-MM-DD_<slug>.md` automaticamente.

---

## PHASE 5 — Override consciente (A8)

Enio pode dizer "GO mesmo assim" mesmo com gap categories acionados. Aceita, MAS:

1. LOG override em `docs/inception_reports/YYYY-MM-DD_<slug>.md` — campo `override_reason`
2. Cria task em TASKS.md: `INCEPTION-OVERRIDE-<slug>` com prazo de re-eval em 30d
3. Adiciona ao próximo `/end` Phase 11.5 — "esse projeto foi override consciente, ainda gera caixa? cliente nomeado entrou?"

---

## REGRAS DE PARADA (skip allowed)

| Phase | Pode pular se | Reportar como |
|-------|---------------|---------------|
| 1 | NUNCA | — |
| 2 | NUNCA | — |
| 3 | Domain = 🟢 master + Single Pursuit alignment = aligned | "Phase 3: skip — master zone, aligned. Recon light apenas via codebase+HARVEST" |
| 4 | NUNCA | — |
| 5 | Enio aceitou recomendação default | — |

---

## INTEGRAÇÃO COM SISTEMA

- `/start` Layer 0 — checa "abrindo projeto novo nesta sessão? roda /inception"
- `/end` Phase 11.5 — pergunta sobre projetos overridados em 30d
- Pre-commit hook `check-inception.sh` — warn se primeiro commit em repo novo sem `INCEPTION_REPORT` referenciado em commit msg

---

## MÉTRICA

Após 30d de uso:
- Quantos `/inception` rodados?
- Quantas decisões GO/NO-GO/EXTRACT/STUDY?
- Quantos projetos NO-GO foram retomados depois (false positive)?
- Quantos projetos GO foram abandonados < 30d (gate falhou)?

Calibra warn-only → strict baseado em ratio de false positive < 20%.

---

*v1.0 — 2026-05-08 | Atom A59 | Inspirado em fgrehm/dot-ai project-inception + Davin Hills Aperture (gap categories)*