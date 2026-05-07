---
description: Session Initialization v6.3 — Force-Read All Layers + Handoff + Governance Smoke
---

# /start — Session Initialization v6.3 (EGOS)

> **Princípio:** Não basta verificar existência — é preciso LER o conteúdo.
> **Bug v5.9 corrigido:** `head -60` e `[ -f ]` perdiam 70%+ do contexto crítico.
> **Bug v6.1 corrigido:** handoff não lido + hook warnings ignorados + ADR sem Glob = próximos passos errados.
> **Bug v6.2 corrigido:** hook warnings grep no log JSON (sempre vazio) → smoke check direto (`runtime-smoke.ts`).
> **Pacto:** ao final, o agente DEVE provar leitura via verification checkpoint.

---

## CONTRATO COM O AGENTE (ler primeiro)

Você está executando `/start`. Sua obrigação:

1. **LER** (não verificar existência) cada arquivo das Layers 1-4.5 com a **Read tool**.
2. **NÃO** usar `head -N` ou `cat` para arquivos canonical — isso trunca contexto.
3. **PARALELIZAR** Read tools que não dependem entre si.
4. Ao final, preencher o **Verification Checkpoint** (Layer 7) com respostas concretas.
5. Se omitir uma layer, **declare explicitamente** o motivo (ex: "Layer 5 skipped: VPS unreachable").
6. **"Próximos passos"** = handoff.next PRIMEIRO, depois P0 do Single Pursuit. Nunca só grep P0.

---

## LAYER 1 — Global Rules (T0-T2 + Lazy-loaded T3)

**LEIA com Read tool (paralelo):**

- `/home/enio/.claude/CLAUDE.md` — completo (T0-T2 rules, ~250L)
- `/home/enio/.claude/egos-rules/enio-profile.md` — Single Pursuit + NO JOBS rule
- `/home/enio/.claude/egos-rules/posture-autonomy.md` — challenge mode, blockers
- `/home/enio/.claude/egos-rules/karpathy-principles.md` — simplicity, surgical, goal-driven
- `/home/enio/.claude/egos-rules/session-checklist.md` — formato ✅/🔄/⏳ no fim

**Após leitura, internalize (não repita ao usuário):**
- 5 regras T0 (force-push, secrets, publish, git add -A, COMMIT TASKS.md)
- Verification gates T1 (INC-005 external LLM, INC-006 subagent, INC-009 estimate)
- Edit safety T1 (read-before-edit, max 3 edits, simplicity-first)
- Token economy T2 (Sonnet default, alarme $2, nova sessão >$3)

---

## LAYER 2 — Project Bootstrap (canonical SSOT)

**LEIA completo com Read tool:**

- `/home/enio/egos/docs/EGOS_BOOTSTRAP.md` — TODAS as 191 linhas, 16 seções

**Internalize:**
- Single Pursuit ATIVO (data mais recente sempre vence)
- Architecture diagram 3-camadas (acquisition → deployment → operation)
- Stack tech (Bun+TS, Postgres RLS, Gemini 2.0 Flash, OpenRouter)
- SSOT map (18 domínios → 1 arquivo cada)
- Estado atual snapshot (último parágrafo do BOOTSTRAP)

---

## LAYER 3 — Tier 1 ADRs (decisões locked)

**Primeiro: verifique existência dos 3 ADRs (bash):**

```bash
ls /home/enio/egos/docs/governance/CENTRAL_EGOS_ARCHITECTURE_DECISION.md \
   /home/enio/egos/docs/governance/HERMES_EGOS_FORK_DECISION.md \
   /home/enio/egos/docs/capabilities/PRODUCT_NAMING_DECISION.md 2>&1 | \
   sed 's/^/  /'
```

**Depois: LEIA com Read tool (paralelo) os que existirem. Para os ausentes:** reportar "Layer 3: `<arquivo>` ausente" no checkpoint.

**Internalize:**
- 22 decisões locked (não re-discutir)
- Tiers Solo/Pro/Enterprise + setup + mensalidade
- Padrão PAI plugins-only (NUNCA modificar core Hermes)
- Naming map: deprecated → canonical

---

## LAYER 4 — Memory Top 3 (recência)

**LEIA com Read tool (paralelo, primeiros 3 arquivos referenciados em MEMORY.md):**

```bash
# Identificar os 3 arquivos top da MEMORY.md (sem ler ainda)
grep -E "^- \[" /home/enio/.claude/projects/-home-enio-egos/memory/MEMORY.md | head -3
```

Pegue os 3 primeiros paths citados (exceto MEMORY.md) e use Read tool em cada um.

**Por quê:** o reminder inicial trunca MEMORY.md em 200 linhas; os arquivos linkados precisam de Read explícita.

---

## LAYER 4.5 — Handoff Atual (in-progress state) ← NOVO em v6.2

**Esta é a fonte mais fresca de "o que estava em andamento". Sempre leia antes de recomendar próximos passos.**

```bash
# Encontrar o handoff mais recente
ls -t /home/enio/egos/docs/_current_handoffs/*.md 2>/dev/null | head -1
```

Pegue o path retornado e **use Read tool**. Foque em:
- Seção **"Next / Próximos Passos"** — o que o agente anterior pediu explicitamente
- Seção **"In Progress / Em Andamento"** — o que estava pela metade
- Seção **"Validações Pendentes"** — testes que o agente anterior pediu ao próximo

Se nenhum handoff existir: reportar "Layer 4.5: sem handoff ativo" no checkpoint.

**Por quê:** sem este layer, o agente usa só P0 do grep e ignora contexto de in-progress da sessão anterior. Resultado: recomendações genéricas em vez das realmente relevantes (bug detectado em v6.1).

---

## LAYER 5 — System State (bash, fatos)

```bash
# Repo state
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
echo "Repo: $(basename $ROOT) | Branch: $(git branch --show-current)"
git log --oneline -5
echo "Uncommitted: $(git status --short | wc -l) files"
git status --short

# Resources
df -h / | tail -1
free -h | head -2

# TASKS.md metrics
DONE=$(grep -c "^- \[x\]" TASKS.md 2>/dev/null || echo 0)
PEND=$(grep -c "^- \[ \]" TASKS.md 2>/dev/null || echo 0)
P0=$(grep -c "^- \[ \].*\[P0\]" TASKS.md 2>/dev/null || echo 0)
LINES=$(wc -l < TASKS.md 2>/dev/null || echo 0)
echo "TASKS: ${DONE} done, ${PEND} pending, ${P0} P0 | TASKS.md: ${LINES}L"

# Governance smoke check (fonte canônica de warnings — session log é JSON, não texto)
EGOS_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
if [ -f "$EGOS_ROOT/scripts/runtime-smoke.ts" ] && command -v bun >/dev/null 2>&1; then
  SMOKE=$(cd "$EGOS_ROOT" && bun scripts/runtime-smoke.ts --quiet 2>&1)
  WARN=$(echo "$SMOKE" | grep -E "(❌|⚠️)" | head -10)
  echo "=== Governance Smoke ==="
  echo "$SMOKE" | head -1
  [ -n "$WARN" ] && echo "$WARN" || echo "✅ sem warnings"
else
  echo "=== Governance Smoke: script ausente ou bun indisponível ==="
fi
```

---

## LAYER 6 — Skills/Tooling Inventory

```bash
# Skills (counts only, não listagem completa)
PERSONAS=$(ls -d docs/skills/personas/*/ 2>/dev/null | wc -l)
DPIO=$(ls docs/guides/dpio/*.md 2>/dev/null | wc -l)
SLASH=$(ls .claude/commands/*.md 2>/dev/null | wc -l)
SLASH_GLOBAL=$(ls /home/enio/.claude/commands/*.md 2>/dev/null | wc -l)
AGENT_TS=$(ls agents/skills/*.ts 2>/dev/null | wc -l)
HERMES=$(ls -d /home/enio/hermes-egos/plugins/egos-* 2>/dev/null | wc -l)

echo "Skills: ${PERSONAS} personas | ${DPIO} DPIO | ${SLASH} slash local | ${SLASH_GLOBAL} slash global | ${AGENT_TS} agent.ts | ${HERMES} hermes plugins"

# Tools
echo -n "Alibaba Qwen: "; grep -q ALIBABA_DASHSCOPE .env 2>/dev/null && echo "✅" || echo "❌"
echo -n "Supabase: "; grep -q SUPABASE_URL .env 2>/dev/null && echo "✅" || echo "❌"
echo -n "codebase-memory-mcp: "; command -v codebase-memory-mcp >/dev/null && echo "✅" || echo "❌"
```

---

## LAYER 7 — Verification Checkpoint (OBRIGATÓRIO)

**Após Layers 1-6, produza este briefing EXATO. Sem esta seção, /start está incompleto.**

```
═══════════════════════════════════════════════════════════
EGOS /start v6.3 — Verification Checkpoint
═══════════════════════════════════════════════════════════

🔒 LAYERS LOADED (prove leitura)

Layer 1 — Global Rules
  ✓ T0 #N citada de memória: [exemplo: "NEVER force-push main"]
  ✓ Lazy-loaded rules lidas: [enio-profile / posture / karpathy / outras]
  ✓ Single Pursuit identificado em enio-profile: [data + descrição]

Layer 2 — Bootstrap
  ✓ EGOS_BOOTSTRAP.md lido: [versão + última atualização]
  ✓ Single Pursuit canônico (BOOTSTRAP wins): [Central EGOS / outro]
  ✓ Architecture 3-camadas: [resumo de 1 linha]

Layer 3 — ADRs
  ✓ Total decisões locked: [N]
  ✓ Pricing tiers: Solo R$X/setup R$X/mês | Pro ... | Ent ...
  ✓ Padrão fork: PAI plugins-only / outro

Layer 4 — Memory Top 3
  ✓ Entry 1: [filename + 1 linha do conteúdo]
  ✓ Entry 2: ...
  ✓ Entry 3: ...

Layer 4.5 — Handoff Atual
  ✓ Arquivo lido: [path ou "sem handoff ativo"]
  ✓ In-Progress: [resumo 1 linha ou "N/A"]
  ✓ Validações pendentes: [pedidas pelo agente anterior, ou "N/A"]
  ✓ Next recomendado pelo handoff: [1-2 tasks, ou "N/A"]

Layer 5 — System State
  HEAD: [hash + msg curta] | Uncommitted: [N files]
  TASKS: [done/pending/P0] | Lines: [N]
  Disk: [N%] | RAM: [used/total]
  Governance Smoke: [summary line + ❌/⚠️ warnings, ou "✅ sem warnings"]

Layer 6 — Inventário
  Personas: N | DPIO: N | Slash: local/global | Agent.ts: N | Hermes plugins: N
  Tools: Alibaba ✅ | Supabase ✅ | codebase-memory-mcp ✅

⚠️  CONFLITOS/UPDATES DETECTADOS
  [listar se houver, ex: Single Pursuit mudou de X para Y]
  [listar arquivos uncommitted relevantes]
  [ADRs ausentes detectados no Layer 3]

🎯 SINGLE PURSUIT ATIVO
  [colar do BOOTSTRAP, NÃO do enio-profile se houver conflito]

🚨 P0 BLOCKERS
  [listar do TASKS.md ou "✅ nenhum P0 ativo"]

🔗 PRÓXIMOS PASSOS RECOMENDADOS (3 opções)
  REGRA: prioridade = (1) handoff.next, (2) validações pendentes, (3) P0 do Single Pursuit
  1. [do handoff.next se existir, senão P0 do Single Pursuit — com ID]
  2. [P0/P1 do Single Pursuit — com ID]
  3. [P0/P1 alternativo — com ID]

❓ Em qual quer trabalhar? Ou outra coisa?
═══════════════════════════════════════════════════════════
```

---

## REGRAS DE PARADA (skip allowed)

| Layer | Pode pular se | Reportar como |
|-------|---------------|---------------|
| 1 | NUNCA — global rules são obrigatórias | — |
| 2 | NUNCA — BOOTSTRAP é canonical | — |
| 3 | ADR verificado via bash e ausente | "Layer 3: `<arquivo>` ausente" |
| 4 | MEMORY.md vazio | "Layer 4: sem entries" |
| 4.5 | sem arquivos em `_current_handoffs/` | "Layer 4.5: sem handoff ativo" |
| 5 | bash falha | "Layer 5: comando X falhou" |
| 6 | skill dirs vazios | "Layer 6: 0 skills" |
| 7 | NUNCA — checkpoint é a prova | — |

---

## COMPARATIVO v5.9 → v6.1 → v6.2 → v6.3

| Aspecto | v5.9 | v6.1 | v6.2 | v6.3 (esta) |
|---------|------|------|------|-------------|
| BOOTSTRAP | `head -60` truncado | Read completo | Read completo | Read completo |
| CLAUDE.md global | não lido | Read completo | Read completo | Read completo |
| ADRs Tier 1 | `[ -f ]` checks | Read tool nos 3 (sem verificar) | **Glob bash primeiro, Read só se existir** | idem |
| Lazy-loaded | não lido | Read em 4 arquivos | Read em 4 arquivos | idem |
| Memory | MEMORY.md truncado | Read top 3 entries | Read top 3 entries | idem |
| Handoff atual | não lido | não lido | **Layer 4.5 — Read handoff mais recente** | idem |
| Governance smoke | ignorado | ignorado | grep no log JSON (sempre vazio ❌) | **`bun runtime-smoke.ts` direto ✅** |
| Próximos passos | grep P0 TASKS.md | grep P0 TASKS.md | **handoff.next → P0 Single Pursuit → P0 geral** | idem |
| Verification | declarativo | checkpoint forçado | checkpoint + Layer 4.5 | checkpoint + smoke real |
| Custo extra | — | ~10k tokens | ~12k tokens | ~13k tokens (vale) |

---

## /refresh — Recarregar mid-session

Se sessão >10 turnos ou trocou de assunto:

```bash
git log --oneline -3
git status --short
grep "^- \[ \].*\[P0\]" TASKS.md | head -3
ls -t docs/_current_handoffs/*.md 2>/dev/null | head -1
```

E re-leia EGOS_BOOTSTRAP.md (Layer 2) + handoff mais recente (Layer 4.5) — só esses dois.

---

*v6.3 — 2026-05-07 | Bug fix: governance smoke via `bun runtime-smoke.ts` (log JSON era sempre vazio)*
*v6.2 — 2026-05-07 | +Layer 4.5 (handoff) +F3 (ADR Glob) +F5 (próximos passos por prioridade)*
*v6.1 — 2026-05-07 | Force-read all layers + Verification Checkpoint*
*v5.9 bug: `head -60` perdia 70%+ do contexto.*
