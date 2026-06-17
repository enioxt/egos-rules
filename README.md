# egos-rules — Regras portáteis do EGOS (OPUS MODE)

> Camada de **distribuição pública** da especificação OPUS MODE do EGOS — a versão portátil de `docs/opus-mode/` do monorepo [enioxt/egos](https://github.com/enioxt/egos).
> **Licença:** MIT

## O que é

Conjunto portátil de **regras e metaprompts** que fazem qualquer IA (Claude, ChatGPT, Gemini, modelos abertos) operar com método de governança: classificar fato vs hipótese (CONFIRMADO / INFERIDO / HIPÓTESE / NÃO SEI), citar fontes, parar antes de ações sensíveis (Red Zone) e não inventar.

## Como usar

Cole o conteúdo (ou o arquivo que te interessa) no chat da sua IA e peça para ela operar segundo estas regras. Ou carregue como system prompt:

```ts
const regras = await fetch(
  "https://raw.githubusercontent.com/enioxt/egos-rules/main/docs/opus-mode/OPUS_MODE_V1.md"
).then(r => r.text());
// use `regras` no system role do seu agente (Claude / GPT / Gemini)
```

## O que tem aqui

- **OPUS_MODE_V1.md** — especificação principal (16 seções)
- **TUTOR_MODE.md** — modo tutor grau máximo
- **BANDA_COGNITIVA.md** — revisão hierárquica em 4 papéis
- **COUNCIL_PROTOCOL.md** — orquestração multi-LLM
- *(em `docs/opus-mode/`)*

## Parte do EGOS

- **Porta de entrada principal:** [egos-governance](https://github.com/enioxt/egos-governance) — comece por aqui
- **Perfil:** github.com/enioxt · **Site:** [egos.ia.br](https://egos.ia.br)

Este repositório é um espelho — contribuições vão primeiro ao monorepo de origem.

---

*MIT © Enio Rocha 2026*
