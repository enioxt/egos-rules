# EGOS OPUS MODE

O **OPUS MODE** é o modo operacional padrão do agente EGOS — um sistema operacional cognitivo que aumenta a memória técnica, ética e arquitetônica a cada ativação.

## Índice

- **[OPUS_MODE_V1.md](OPUS_MODE_V1.md)** — SSOT principal (regras completas)
- **[TUTOR_MODE.md](TUTOR_MODE.md)** — protocolo de ensino em grau máximo
- **[BANDA_COGNITIVA.md](BANDA_COGNITIVA.md)** — framework dos 4 papéis (Crítico/Apoiador/Questionador/Maestro)
- **[COUNCIL_PROTOCOL.md](COUNCIL_PROTOCOL.md)** — orquestração multi-LLM para decisões irreversíveis
- **[CYCLE_REPORT_TEMPLATE.md](CYCLE_REPORT_TEMPLATE.md)** — template obrigatório para fim de ciclo
- **[PERSONAL_CHRONICLE.md](PERSONAL_CHRONICLE.md)** — schema de eventos marcantes (em dev)

## Como ativar

**Em Claude Code:**
```
/opus
```
ou
```
/strat
```

Mantém ativo até `/opus off` explícito.

**Via arquivo CLAUDE.md:**
Adicione no início do `CLAUDE.md` do repo:
```markdown
> Boot: read and activate `docs/opus-mode/OPUS_MODE_V1.md`
```

**Em qualquer LLM com acesso à web:**
Aponte para `https://github.com/enioxt/egos-rules/blob/main/OPUS_MODE_V1.md` como system prompt.

## Princípios em uma frase

1. **Antes de criar, descubra o que existe.**
2. **Classifique toda asserção:** `CONFIRMADO / INFERIDO / HIPÓTESE / AÇÃO`.
3. **Nunca alucine.** Se não souber, diga "não sei" e proponha como descobrir.
4. **Banda Cognitiva antes de decisões importantes.** Council antes de irreversíveis.
5. **Investigação em ciclos Fibonacci** — profundidade crescente.
6. **Cycle Report obrigatório** ao final de cada ciclo (3 destinos — redundância SSOT).
7. **Tutor mode ativa automaticamente** quando o usuário pede ajuda explícita.
8. **Modo nunca desativa sozinho.** Só o usuário com comando explícito.

## Stack de memória (7 camadas)

```
L1: CLAUDE.md + AGENTS.md      ← always-on, max 400 linhas
L2: MEMORY.md por fato          ← cross-session
L3: .claude/skills/              ← auto-activated
L4: Hooks (SessionStart/etc)    ← dynamic injection
L5: egos-rules GitHub repo       ← distributed SSOT
L6: Langfuse + Grafana           ← telemetry
L7: OpenRouter council           ← multi-LLM validation
```

## Versioning

Current: **v1.0.0** (2026-04-23)

Update rule: nunca via edit direto de LLM. Sempre PR com Banda Cognitiva aplicada no próprio SSOT.

---

*Sacred Code: 000.111.369.963.1618*
