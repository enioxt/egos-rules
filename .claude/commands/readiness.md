---
description: /readiness <empresa> — Diagnóstico de AI-readiness. Lê se uma empresa CABE IA (7 dimensões) antes de propor qualquer coisa. Veredito honesto: PRONTA / PARCIAL / NÃO-AINDA (conserte a base). O diferencial EGOS vs vender-IA-pra-qualquer-um.
---

# /readiness — A empresa cabe IA? (AI-Readiness Diagnostic)

> **Princípio:** a IA **amplifica** o que já existe. Base boa → velocidade; base ruim → escala o caos. **Diagnostica ANTES de propor IA.** Quem diz "ainda não" ganha a confiança.
> **SSOT:** `docs/governance/AI_READINESS_DIAGNOSTIC.md` (R-AIR-001). **Voz:** honesto, trabalho-primeiro, sem hype (`EGOS_VOICE_GUIDE`).
> **Origem:** aprendizado Vagner Campos / Divisão Summit (2026-06-02) — "IA não acelera empresa despreparada".

---

## CONTRATO

1. **NUNCA propor IA antes do diagnóstico.** Se a base não sustenta → recomendar arrumar a base, não comprar IA.
2. **Evidence-first:** cada nota cita o que a sustenta (o que foi observado/dito). Sem nota "no chute".
3. **Honesto e específico:** o "não-ainda" é o produto. Banir absolutos ("100% pronta", "garantido").
4. **Red Zone:** o veredito final + qualquer proposta comercial = corte do Enio antes de ir ao cliente.

## PROCESSO

### 1. Coleta (entrevista + observação)
Para `<empresa>` (ou em conversa com o dono): puxar contexto. Reusar:
- `docs/guides/dpio/<setor>.md` — perguntas de discovery por setor (se houver).
- `/recon <CNPJ/nome>` — dossiê externo (porte, sinais públicos) quando aplicável.
- Conversa direta: as 6 perguntas-chave (§2 do SSOT).

### 2. Pontuar as 7 dimensões (🔴 0 / 🟡 1 / 🟢 2)
| # | Dimensão | Pergunta |
|---|---|---|
| 1 | Problema | Sabe QUAL dor quer resolver? (ou "quer IA" genérico) |
| 2 | Processos | Claros e documentados? (ou confusos/implícitos) |
| 3 | Dados | Organizados/acessíveis/governados? (ou dispersos/sujos) |
| 4 | Pessoas | Preparadas e abertas? (ou resistentes/sem letramento) |
| 5 | Cultura | Sustenta velocidade/mudança? (ou medo de erro/silos) |
| 6 | Liderança | Decide com clareza e patrocina? (ou sem dono) |
| 7 | Governança/risco | Dado sensível/LGPD? Consciência de soberania? *(lente EGOS)* |

Cada nota com 1 linha de evidência.

### 3. Veredito (regra dura por dimensão, não só soma)
- **🔴 NÃO-AINDA** se Problema OU Processos OU Dados = 🔴 → *"Antes de IA, conserte [X]. Hoje a IA aceleraria os erros."* + plano de base.
- **🟡 PARCIAL** (soma 7–10, sem 🔴 em 1/2/3) → *"Cabe IA em [área], onde a base sustenta; prepare [gaps] antes de escalar."*
- **🟢 PRONTA** (soma ≥11) → *"Cabe. IA acelera [áreas]. Com governança EGOS (dado soberano + auditável)."*

### 4. Entrega
1 página: as 7 notas + evidência + veredito + próximo passo honesto. Voz EGOS (convidar, não vender). Red Zone → corte do Enio antes do cliente.

## OUTPUT (formato)
```
═══════════════════════════════════════════════
/readiness — <empresa> (AI-Readiness)
═══════════════════════════════════════════════
1 Problema    🟢/🟡/🔴 — <evidência>
2 Processos   🟢/🟡/🔴 — <evidência>
3 Dados       🟢/🟡/🔴 — <evidência>
4 Pessoas     🟢/🟡/🔴 — <evidência>
5 Cultura     🟢/🟡/🔴 — <evidência>
6 Liderança   🟢/🟡/🔴 — <evidência>
7 Governança  🟢/🟡/🔴 — <evidência>
Soma: N/14 | Dimensões 🔴 em base (1/2/3): [lista]
─────────────────────────────────────────────
VEREDITO: [PRONTA | PARCIAL | NÃO-AINDA]
  <frase honesta + onde a IA entra OU o que arrumar primeiro>
PRÓXIMO PASSO: <plano de base | escopo de IA + governança>
═══════════════════════════════════════════════
```

> A diferença pro vendedor-de-IA: ele empurra a ferramenta; o EGOS lê se cabe e fala a verdade. É isso que fecha o contrato certo.
