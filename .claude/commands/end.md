---
description: Session Finalization v6.1 — Force-Verify All Phases + Structured Handoff/Memory
---

# /end — Session Finalization v6.1 (EGOS)

> Sacred Code: 000.111.369.963.1618
> **Princípio:** /end é prova de trabalho. Sem checkpoint estruturado, encerrar sessão = perder estado.
> **Bug v5.7 corrigido:** Phase 2 (handoff) e Phase 7 (memory) eram descritivas → agente improvisava formato e omitia seções.

---

## CONTRATO COM O AGENTE (ler primeiro)

Você está executando `/end`. Sua obrigação:

1. **NÃO PULAR PHASES** — cada Phase tem checkpoint próprio. Se pular, declare motivo.
2. **CITAR SHAs** — toda claim de "feito" precisa hash de commit. Sem SHA = `[CONCEPT]`, não `[DONE]`.
3. **TEMPLATE LITERAL** — handoff e memory writes seguem formato fixo. Não improvisar.
4. **VERIFICATION CHECKPOINT** (Phase 10) é OBRIGATÓRIO. Sem ele, /end está incompleto.
5. **NEVER `git add -A`** — sempre `git add <specific-file>` (T0 rule, INC-002).

---

## PHASE 0 — Re-load Context (NOVO v6.1)

A sessão pode ter divergido do contexto inicial. Antes de fechar, re-carregar:

**LEIA com Read tool (paralelo):**

- `/home/enio/egos/docs/EGOS_BOOTSTRAP.md` — confirmar Single Pursuit ainda válido
- `/home/enio/.claude/egos-rules/session-checklist.md` — formato de saída obrigatório
- `/home/enio/egos/TASKS.md` — primeiras 60L (estado atual P0/P1)

**Internalize:**
- Single Pursuit ATIVO (BOOTSTRAP wins se houver conflito)
- Formato `✅ feito / 🔄 em progresso / ⏳ pendente` (session-checklist)
- P0 blockers existentes para incluir em "Next Steps"

---

## PHASE 1 — Central EGOS Coverage Check

Mudanças desta sessão exigem update em docs canonical?

```bash
# Skills/personas/dpio mudados → SKILLS_REGISTRY precisa update?
SKILLS_CHANGED=$(git diff --name-only HEAD~5 HEAD 2>/dev/null | grep -cE "skills/personas|guides/dpio|.claude/commands|hermes-egos/plugins")
[ "$SKILLS_CHANGED" -gt 0 ] && echo "⚠️  $SKILLS_CHANGED arquivos de skills mudados — update SKILLS_REGISTRY.md"

# ADRs/governance mudados → bootstrap reflete?
ADR_CHANGED=$(git diff --name-only HEAD~5 HEAD 2>/dev/null | grep -cE "governance/.*DECISION|capabilities/.*DECISION")
[ "$ADR_CHANGED" -gt 0 ] && echo "⚠️  $ADR_CHANGED ADRs mudados — verificar EGOS_BOOTSTRAP.md + SYSTEM_MAP.md"

# Hermes-egos sync
[ -d /home/enio/hermes-egos/.git ] && echo "Hermes-EGOS último commit: $(cd /home/enio/hermes-egos && git log -1 --format=%cr 2>/dev/null)"
```

---

## PHASE 2 — Session Data Collection

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
echo "Repo: $(basename $ROOT)"
echo "HEAD: $(git log --oneline -1)"
echo "Uncommitted: $(git status --short | wc -l) files"

echo ""
echo "=== Commits this session (8h window) ==="
git log --oneline --since='8 hours ago' 2>/dev/null

echo ""
echo "=== Files changed ==="
git log --since='8 hours ago' --name-only --pretty=format: 2>/dev/null | sort -u | grep -v '^$' | head -30
```

---

## PHASE 3 — Mandatory Session Review

**Antes de prosseguir, responda às 7 perguntas (formato literal):**

```
SESSION REVIEW
==============

1. ALL COMMITS (hash + subject):
   [colar saída de git log --oneline --since='8 hours ago']

2. REAL ADVANCES (idea/code → working/deployed):
   - [advance 1, com SHA]
   - [advance 2, com SHA]

3. USE CASES enabled:
   - [cenário concreto 1]
   - [cenário concreto 2]

4. WHO would use this:
   [persona específica — não "todos"]

5. OBJECTIVES achieved:
   - [objetivo 1 → resultado]

6. PROBLEMS solved:
   - [problema 1 → solução com referência]

7. CLAIM RECONCILIATION (INC-005 forçada):
   Para cada feature claimed "done" nesta sessão:
   - feature X → SHA abc123 ✅
   - feature Y → SEM SHA → marcar [CONCEPT] no handoff
   - feature Z → SEM SHA → marcar [CONCEPT] no handoff
   Features sem SHA NÃO entram em HARVEST.md ou CAPABILITY_REGISTRY.md.
```

> **Tool Result Budget (LEAK-006):** Se algum tool retornou >20K chars, escreva em
> `docs/jobs/YYYY-MM-DD-[topic].md` em vez de embedar em handoff. Handoff <4K total.

---

## PHASE 4 — Generate Handoff (TEMPLATE LITERAL)

Crie `docs/_current_handoffs/handoff_YYYY-MM-DD.md` usando este formato EXATO:

```markdown
# Handoff — YYYY-MM-DD HH:MM

## ✅ Accomplished (com SHAs)
- [feature/fix 1] — `SHA` — link para arquivo
- [feature/fix 2] — `SHA` — link para arquivo

## 🔄 In Progress
- [task] — N% — bloqueador (se houver) — próximo passo

## ⏳ Blocked
- [task] — motivo — ação necessária — quem decide

## 🔗 Next Steps (priority order)
1. [P0/P1 task com ID do TASKS.md]
2. [próxima ação concreta]

## 🌐 Environment State
- Build: ✅/❌
- Tests: ✅/❌ (N pass / N fail)
- Deploy: VPS healthy / blocked / N/A
- Disk: N% | RAM: used/total

## 📌 Decisions Made (architectural)
- [decisão 1] — referência ADR ou commit

## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
- [feature discutida mas não commitada]
```

---

## PHASE 5 — Update TASKS.md (BLOCKING)

```bash
# Tasks marcadas [x] precisam SHA
# Tasks marcadas [/] precisam % progresso
# Novas tasks descobertas → adicionar com [ ]
```

**Checklist obrigatório:**
- [ ] Tasks completed → marcadas `[x]` com SHA referencia
- [ ] Tasks in-progress → `[/]` com % e blocker
- [ ] Newly discovered tasks → adicionadas (não esquecer P0!)
- [ ] Commit TASKS.md IMEDIATAMENTE (T0 rule §0.5)

---

## PHASE 6 — Documentation Drift Check (BLOCKING)

Não pode finalizar se:
- Código mudou em `src/` AND `SYSTEM_MAP.md` desatualizado
- Nova capability AND `AGENTS.md` ou `CAPABILITY_REGISTRY.md` desatualizado
- Skills mudados AND `SKILLS_REGISTRY.md` desatualizado
- ADR mudou AND `EGOS_BOOTSTRAP.md` desatualizado

```bash
git diff --name-only HEAD~5 HEAD | grep -E '^src/|^packages/|^agents/' | head -10
git diff --name-only HEAD~5 HEAD | grep 'CAPABILITY_REGISTRY\|SYSTEM_MAP\|AGENTS\|BOOTSTRAP'
```

---

## PHASE 7 — Auto-Disseminate (conditional)

```bash
FEAT_COMMITS=$(git log --oneline origin/main..HEAD 2>/dev/null | grep "feat(" | wc -l)
echo "feat commits unpropagated: $FEAT_COMMITS"
```

- Se `feat commits > 0` AND `/disseminate` não rodou → invocar `/disseminate` antes da Phase 8
- Se `feat commits = 0` → skip

---

## PHASE 8 — Record Learnings + Memory Write (TEMPLATE LITERAL)

### 8.1 — Knowledge System
```bash
# Para cada learning significativo (1-3 max por sessão):
# Domain: general|architecture|deployment|monetization|governance|agents|security|dx
# Outcome: success|failure|insight
curl -s -X POST "https://gateway.egos.ia.br/knowledge/learnings" \
  -H "Content-Type: application/json" \
  -d '{"domain":"<dom>","outcome":"<out>","description":"<learning>","session_id":"'$(date +%Y%m%d)'"}'
```

### 8.2 — Wiki compile
```bash
cd /home/enio/egos && bun agents/agents/wiki-compiler.ts --compile 2>/dev/null || echo "skip"
bun obsidian:sync 2>/dev/null || echo "skip"
```

### 8.3 — Memory write OBRIGATÓRIO

**Crie `~/.claude/projects/-home-enio-egos/memory/session_YYYY-MM-DD_[topic].md`:**

```markdown
---
name: [Título curto da sessão]
description: [1 linha — usada para decidir relevância em sessões futuras]
type: project
originSessionId: [hash atual]
---
[Topic principal] — 1-2 linhas

**Real changes (com SHAs):**
- [SHA] [arquivo] — [o que mudou e por quê]

**Decisões arquiteturais:**
- [decisão] — [motivo]

**Blockers ativos:**
- [blocker] — [próximo agente faz X]

**Próxima sessão:**
- [P0/P1 task com ID]
```

**Update MEMORY.md index** (linha única <200 chars):
```
- [session_YYYY-MM-DD_topic.md](file.md) — 1-line hook do conteúdo
```

### 8.4 — Update feedback memory (se houver)

Se o usuário corrigiu approach OU validou approach não-óbvio durante a sessão:
- Update `feedback_*.md` existente OU criar novo
- Formato: rule + **Why:** + **How to apply:**

---

## PHASE 9 — Daily Article (CONDITIONAL)

**Skip se:**
- Sessão ZERO commits → skip + nota no handoff
- Weekend/holiday → opcional
- Commits puramente infra/chore sem learning user-facing → skip + nota

**Caso contrário, gerar bilíngue (PT-BR + EN):**

```bash
# Gem Hunter research first (referenciar honestamente projetos similares)
bun agents/agents/gem-hunter.ts --query "<topic>" --dry 2>/dev/null | tail -10

# Article-writer (drafts em Supabase, requer aprovação humana)
bun agents/agents/article-writer.ts --topic "<topic>" --lang pt-br --dry
bun agents/agents/article-writer.ts --topic "<topic>" --lang en --dry
```

**Guardrails (T0 #3 — NEVER publish without approval):**
- Tom: compartilhar/ensinar. Zero pitch comercial.
- Código reproduzível MIT, links públicos.
- Se referenciar player estabelecido: creditar + contrastar honestamente.
- ZERO claims de "único", "primeiro do Brasil", "melhor que X".
- HITL obrigatório: drafts em Supabase, aprovação humana antes de live.

---

## PHASE 10 — Verification Checkpoint (OBRIGATÓRIO)

**Sem este checkpoint, /end está incompleto.** Produzir output EXATO:

```
═══════════════════════════════════════════════════════════
EGOS /end v6.1 — Verification Checkpoint
═══════════════════════════════════════════════════════════

🔒 PHASES COMPLETED

Phase 0 — Re-load Context
  ✓ Single Pursuit confirmado: [Central EGOS / outro]
  ✓ session-checklist format: ✅/🔄/⏳

Phase 1 — Coverage Check
  ✓ Skills changed: [N] | ADRs changed: [N]
  ✓ Updates needed: [SKILLS_REGISTRY/SYSTEM_MAP/...]

Phase 2 — Session Data
  ✓ Commits this session: [N]
  ✓ Files changed: [N]
  ✓ Uncommitted at start of /end: [N]

Phase 3 — Session Review (7 questions answered):
  ✓ Real advances: [N] (todos com SHA)
  ✓ Use cases: [N]
  ✓ [CONCEPT] markers: [N] (sem SHA)

Phase 4 — Handoff
  ✓ Path: docs/_current_handoffs/handoff_YYYY-MM-DD.md
  ✓ All sections filled (Accomplished/InProgress/Blocked/Next/Env/Decisions)
  ✓ <4K chars total

Phase 5 — TASKS.md
  ✓ Tasks marked [x] with SHA: [N]
  ✓ Tasks marked [/] with %: [N]
  ✓ New tasks added: [N]
  ✓ TASKS.md committed: ✅/❌

Phase 6 — Doc Drift
  ✓ SYSTEM_MAP/AGENTS/CAPABILITY_REGISTRY/BOOTSTRAP: synced ✅ / drift detected ⚠️

Phase 7 — Auto-Disseminate
  ✓ Feat commits unpropagated: [N]
  ✓ /disseminate: ran ✅ / skipped (reason)

Phase 8 — Memory Write
  ✓ session_YYYY-MM-DD_topic.md: written
  ✓ MEMORY.md index updated: ✅
  ✓ feedback_*.md updates: [N]

Phase 9 — Daily Article
  ✓ Status: drafted (PT+EN, awaiting HITL) / skipped (reason)

📊 SESSION SUMMARY
  Repo: [name]
  Branch: [name]
  HEAD start → end: [SHA] → [SHA]
  Commits: [N]
  Files changed: [list top 5]
  Cost: $[X.XX] | Context used: [%]

🎯 NEXT SESSION OPENS WITH
  [task ID from TASKS.md] — [1-line hook]

═══════════════════════════════════════════════════════════
Signed: claude-[model] — [ISO8601]
═══════════════════════════════════════════════════════════
```

---

## PHASE 11 — Final Commit & Push

Se houver mudanças não-commitadas (TASKS.md, handoff, MEMORY.md):

```bash
git add TASKS.md docs/_current_handoffs/handoff_*.md
# Memory files: git add ~/.claude/... separately if tracked
git commit -m "chore(end): session close YYYY-MM-DD — [N] commits, [topic]"

# Push via safe-push (T0 rule §4)
bash scripts/safe-push.sh main
```

---

## REGRAS DE PARADA (skip allowed)

| Phase | Pode pular se | Reportar como |
|-------|---------------|---------------|
| 0 | NUNCA | — |
| 1 | Nenhum diff em skills/ADRs | "Phase 1: nada a verificar" |
| 2 | NUNCA | — |
| 3 | NUNCA — review é obrigatório | — |
| 4 | Sessão ZERO commits | "Phase 4: skip — sessão zero commits" |
| 5 | TASKS.md não mudou | "Phase 5: TASKS.md já atualizado" |
| 6 | NUNCA — drift check obrigatório | — |
| 7 | Feat commits = 0 | "Phase 7: nada a propagar" |
| 8 | NUNCA — memory write obrigatório | — |
| 9 | Sessão zero commits OU só infra/chore | "Phase 9: skip — [reason]" |
| 10 | NUNCA — checkpoint é a prova | — |
| 11 | Nada uncommitted | "Phase 11: nothing to commit" |

---

## COMPARATIVO v5.7 → v6.1

| Aspecto | v5.7 (anterior) | v6.1 (esta) |
|---------|-----------------|-------------|
| Re-load context | não fazia | Phase 0 obrigatória |
| Session Review | mandatory mas descritivo | template literal 7 perguntas |
| Handoff | seções listadas | template EXATO com formato |
| Memory write | template opcional | obrigatório com formato |
| Claim reconciliation | mencionada | enforced em Phase 3 #7 |
| Verification checkpoint | declarativo | Phase 10 obrigatória |
| Versões em conflito | 3 (v5.5/.egos, v5.7/egos, SKILLS-007/global) | 1 SSOT canonical |

---

*v6.1 — 2026-05-07 | Force-verify all phases + structured templates | Substitui v5.5 (.egos), v5.7 (egos), SKILLS-007 (~/.claude)*
*Bug fix: v5.7 era descritivo demais → handoffs e memory writes inconsistentes. v6.1 força templates literais.*