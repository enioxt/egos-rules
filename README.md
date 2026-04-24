# EGOS Rules

> **Mirror SSOT** — distributed version of `docs/opus-mode/` from [enioxt/egos](https://github.com/enioxt/egos).
> **License:** MIT
> **Auto-sync:** via `scripts/sync-egos-rules.sh` in the source monorepo.

## Purpose

This repo is the **public distribution layer** of the EGOS OPUS MODE specification. Any AI agent (Claude/GPT/Gemini/open-source) with web access can:

1. Read the meta-prompt as system prompt
2. Load rules dynamically at session start
3. Validate behavior against the canonical spec

## What's here

- **[OPUS_MODE_V1.md](docs/opus-mode/OPUS_MODE_V1.md)** — SSOT principal (16 seções)
- **[TUTOR_MODE.md](docs/opus-mode/TUTOR_MODE.md)** — tutor grau máximo protocol
- **[BANDA_COGNITIVA.md](docs/opus-mode/BANDA_COGNITIVA.md)** — 4-role hierarchical review
- **[COUNCIL_PROTOCOL.md](docs/opus-mode/COUNCIL_PROTOCOL.md)** — multi-LLM orchestration
- **[CYCLE_REPORT_TEMPLATE.md](docs/opus-mode/CYCLE_REPORT_TEMPLATE.md)** — obligatory end-of-cycle format
- **[PERSONAL_CHRONICLE.md](docs/opus-mode/PERSONAL_CHRONICLE.md)** — life-event schema

## How to use in YOUR agent

```python
# Python example
import httpx
rules_url = "https://raw.githubusercontent.com/enioxt/egos-rules/main/docs/opus-mode/OPUS_MODE_V1.md"
system_prompt = httpx.get(rules_url).text
# Use `system_prompt` in Claude/GPT/Gemini system role
```

```typescript
// TypeScript
const rules = await fetch("https://raw.githubusercontent.com/enioxt/egos-rules/main/docs/opus-mode/OPUS_MODE_V1.md").then(r => r.text());
```

## Contributing

This is a mirror — PRs should go to the source monorepo first. See [CONTRIBUTING.md](CONTRIBUTING.md) (TBD).

## License

MIT © Enio Rocha 2026

---

*Sacred Code: 000.111.369.963.1618*
