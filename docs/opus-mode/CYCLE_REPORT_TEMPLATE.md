# Cycle Report — Template Obrigatório

> **Parent:** [OPUS_MODE_V1.md](OPUS_MODE_V1.md) §9.3
> **Versão:** 1.0.0 — 2026-04-23

## Quando gerar

Ao final de **qualquer ciclo relevante**, obrigatoriamente:

### Ciclos que exigem report

- Ciclo Fibonacci 3+ completado (workflows, hooks, agents)
- Ciclo Fibonacci 5+ (integrações, deploy, VPS)
- Ciclo Fibonacci 8 (investigação histórica)
- `/end` da sessão
- Banda Cognitiva executada
- Council executado
- Gem Hunter scan

### Ciclos que NÃO exigem report

- Ciclo 1 sozinho (leitura de arquivos principais)
- Bugs simples
- Refactors triviais
- Comandos operacionais (git status, ls)

## Formato obrigatório

```markdown
# EGOS Cycle Report — <slug> — YYYY-MM-DD

## Metadata
- **Cycle ID:** <fibonacci-level>-<slug>
- **Fibonacci level:** 1 | 2 | 3 | 5 | 8
- **Duração:** <HH:MM>
- **Agente:** claude-opus-4-7 | claude-sonnet-4-6 | gemini-2.5-pro | ...
- **Modo:** opus | tutor | standard
- **Git SHA inicial:** <sha>
- **Git SHA final:** <sha>
- **Branch:** main | feature/x

## Estado inicial
<contexto em 2-3 linhas — o que existia quando o ciclo começou>

## Fontes investigadas
- <arquivo> — <o que buscamos lá>
- <comando> — <output relevante>
- <URL> — <o que confirmamos>

## Descobertas CONFIRMADAS
<asserções com evidência direta — formato: `file:line` ou SHA>

- [CONFIRMADO] Tabela `kb_pages` tem 369 rows tenant=enio
  - Evidência: `curl supabase/rest/v1/kb_pages?select=count` → 369

## HIPÓTESES (ainda não confirmadas)
- [HIPÓTESE] Gemini API deep research pode ser simulada via loop custom
  - Como testar: <comando/experimento>

## Riscos encontrados
- **Risco:** <descrição>
  - **Severidade:** baixa | média | alta | crítica
  - **Mitigação proposta:** <ação>

## Gems encontradas
(se Gem Hunter foi rodado — ver [BANDA_COGNITIVA §6])

## Arquivos alterados
```
<git diff --stat output>
```

## Testes executados
- `<comando>` → <resultado: pass/fail/n_tests>

## Decisões tomadas (se houver Banda ou Council)
- **Decisão:** <resumo em 1 linha>
- **Tipo:** Banda Cognitiva | Council | Direta
- **Próximo passo:** <concreto, executável>
- **Registro:** `docs/banda/<id>.yaml` ou `docs/quorum/<id>/`

## Pendências
- [ ] <item 1>
- [ ] <item 2>

## Próximo ciclo recomendado

```
/start
```
ou
```
<comando específico>
```

**Fibonacci level sugerido:** <1|2|3|5|8>
**Escopo:** <resumo>

---

*Sacred Code: 000.111.369.963.1618*
*Cycle complete. Clean handoff for next agent.*
```

## 3 destinos obrigatórios (redundância SSOT)

Ao fechar, salvar em:

### 1. Arquivo principal
`docs/jobs/cycles/YYYY-MM-DD-<slug>.md`

Razão: facilmente acessível via git log/grep, versionado.

### 2. Handoff diário
Append em `docs/_current_handoffs/handoff_YYYY-MM-DD.md` seção `## Cycles`.

Razão: consolidação diária, usuário lê de uma vez.

### 3. kb_pages row
```sql
INSERT INTO kb_pages (
  tenant, category, title, content, content_raw,
  entities, entity_hashes,
  quality_score, tags
) VALUES (
  'enio', 'meta/cycles', '<slug>', <content>, <content>,
  [], [],
  0.8, ARRAY['cycle-report', 'fibonacci-<level>']
);
```

Razão: queryável via dashboard, entra no entity graph, buscável.

## Script automatizador

`scripts/cycle-report.ts` (a ser criado):

```bash
# Gerar a partir de dados da sessão
bun scripts/cycle-report.ts --slug rbac-rollout --fibonacci 5 --exec

# Preview antes de salvar
bun scripts/cycle-report.ts --slug rbac-rollout --fibonacci 5 --dry
```

## Integração com `/end`

`/end` workflow deve:
1. Verificar se existem ciclos do dia que não foram fechados (`docs/jobs/cycles/YYYY-MM-DD-*.md` count)
2. Se houver gaps, gerar cycle report consolidado automaticamente
3. Atualizar handoff diário
4. Inserir row em `kb_pages`

## Exemplo real — ciclo desta sessão (2026-04-23)

```markdown
# EGOS Cycle Report — opus-mode-foundation — 2026-04-23

## Metadata
- Cycle ID: 5-opus-mode-foundation
- Fibonacci level: 5 (integrações estruturais)
- Duração: ~90min
- Agente: claude-opus-4-7
- Modo: opus
- Git SHA inicial: a93b2fd
- Git SHA final: <pending>

## Estado inicial
Enio pediu para desenhar o OPUS MODE baseado em ideianaroça.md + Gemini + GPT-5.4. Sessão começou com 19 perguntas checklist; 5 tracks decididos; implementação começada.

## Fontes investigadas
- `docs/concepts/architecture/ideianaroça.md` — intent original
- `docs/CROSS_REPO_CONTEXT_ROUTER.md` — infra existente
- `agents/agents/gem-hunter.ts` — extensibilidade confirmada
- API pricing de Claude/GPT/Gemini/DeepSeek/Kimi/Qwen

## Descobertas CONFIRMADAS
- Qwen 2.5 32B Coder + LoRA em sweet spot matemático para C2 (LLM vertical)
- Sonnet 4.6 wins em $/quality para code action (11× mais barato que Opus)
- Gemini 2.5 Pro tem 1-2M contexto via API (mas NÃO tem endpoint "Deep Research")
- DeepSeek V3 é 11× mais barato que Sonnet para bulk

## Arquivos alterados
5 novos arquivos em `docs/opus-mode/`:
- OPUS_MODE_V1.md (SSOT)
- README.md
- TUTOR_MODE.md
- BANDA_COGNITIVA.md
- COUNCIL_PROTOCOL.md

## Decisões tomadas
1. Ondas 1→2→3 (ordem de implementação)
2. Banda Cognitiva: modo hierárquico sequencial (opção C)
3. Cycle reports: 3 destinos (arquivo + handoff + kb_pages)
4. Distribuição: β (GitHub repo) → γ (API pública)
5. Agentes paralelos: 5 (researcher, critic, builder, synthesizer, librarian)
6. Gem Hunter: EXTEND (não v2)
7. Repo separado: `github.com/enioxt/egos-rules`

## Pendências
- [ ] PERSONAL_CHRONICLE.md (em progresso)
- [ ] Tasks OPUS-* em TASKS.md
- [ ] Commit + push F1
- [ ] Setup repo egos-rules

## Próximo ciclo recomendado
```
/start
```
**Fibonacci level:** 5
**Escopo:** F2 — camadas de memória L1-L5 (CLAUDE.md update + memory hooks + egos-rules sync)

---
*Sacred Code: 000.111.369.963.1618*
```

---

*Sacred Code: 000.111.369.963.1618*
