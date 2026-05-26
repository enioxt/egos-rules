---
description: Session Finalization v6.2 — Force-Verify All Phases + Structured Handoff/Memory + Capability Auto-Propose
---

# /end — Session Finalization v6.2 (EGOS)

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

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
cd "$ROOT"
git fetch origin --quiet 2>/dev/null || echo "🟡 git fetch failed (offline?)"
BEHIND=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo 0)
AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)
if [ "$BEHIND" -gt 0 ]; then
  echo "🔴 DRIFT DETECTED BEFORE /end: local is $BEHIND commits behind origin/main."
  git log --oneline --max-count=3 HEAD..origin/main 2>/dev/null | sed 's/^/   - /'
  [ "$AHEAD" -gt 0 ] && echo "🟡 local also has $AHEAD commits ahead — final push may require rebase."
fi
```

**LEIA com Read tool (paralelo):**

- `/home/enio/egos/docs/EGOS_BOOTSTRAP.md` — confirmar Single Pursuit ainda válido
- `/home/enio/.claude/egos-rules/session-checklist.md` — formato de saída obrigatório
- `/home/enio/egos/TASKS.md` — primeiras 60L (estado atual P0/P1)

**Internalize:**
- Single Pursuit ATIVO (BOOTSTRAP wins se houver conflito)
- Formato `✅ feito / 🔄 em progresso / ⏳ pendente` (session-checklist)
- P0 blockers existentes para incluir em "Next Steps"
- Drift remoto detectado aqui é P0 antes do commit final

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

## PHASE 1.5 — Capability Auto-Propose (NOVO v6.2 — END-V6.4-001)

> **Origem:** 2026-05-11 — capabilities criadas em sessões não eram documentadas no mesmo dia. CAPABILITY_REGISTRY ficava para trás, forçando sessões futuras a redescobrir código existente.
> **Regra:** se qualquer condição abaixo for verdadeira → agente propõe entry para CAPABILITY_REGISTRY antes de fechar sessão.

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)

echo "=== Phase 1.5 — Capability signal detection ==="

# Sinal 1: +20 LOC em packages/ (nova capability de baixo nível)
PKG_LOC=$(git diff --since='8 hours ago' HEAD 2>/dev/null | grep "^+" | grep -v "^+++" | wc -l)
PKG_FILES=$(git log --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "^packages/" | sort -u | wc -l)
[ "$PKG_FILES" -gt 0 ] && echo "⚡ Sinal 1: $PKG_FILES arquivos em packages/ mudados — propor capability?"

# Sinal 2: novo script de utilidade em scripts/
NEW_SCRIPTS=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "^scripts/" | wc -l)
[ "$NEW_SCRIPTS" -gt 0 ] && echo "⚡ Sinal 2: $NEW_SCRIPTS novos scripts criados — registrar como capability?"

# Sinal 3: nova route API em apps/
NEW_ROUTES=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "route\.ts$\|route\.js$" | wc -l)
[ "$NEW_ROUTES" -gt 0 ] && echo "⚡ Sinal 3: $NEW_ROUTES novas API routes criadas — documentar no registry?"

# Sinal 4: nova migration Supabase
NEW_MIGRATIONS=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep -i "migration\|supabase" | wc -l)
[ "$NEW_MIGRATIONS" -gt 0 ] && echo "⚡ Sinal 4: $NEW_MIGRATIONS migrations — atualizar INTEGRATION_REGISTRY?"

# Sinal 5 (MCP-F5-003): novo MCP package detectado
NEW_MCP=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "^packages/mcp-" | sed 's|/.*||' | sort -u | wc -l)
[ "$NEW_MCP" -gt 0 ] && {
  NEW_MCP_NAMES=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "^packages/mcp-" | sed 's|/.*||' | sort -u | tr '\n' ' ')
  echo "⚡ Sinal 5: $NEW_MCP novo(s) MCP package(s): $NEW_MCP_NAMES"
  echo "   → Criar CBC docs/capabilities/CBC-EGOS-${NEW_MCP_NAMES// /-}-001.md"
  echo "   → Validar: bun packages/eval-runner/src/mcp-runner.ts --capability <CBC-ID>"
}

# Sumário
TOTAL_SIGNALS=$(( (PKG_FILES>0) + (NEW_SCRIPTS>0) + (NEW_ROUTES>0) + (NEW_MIGRATIONS>0) + (NEW_MCP>0) ))
echo ""
echo "Sinais detectados: $TOTAL_SIGNALS/5"
[ "$TOTAL_SIGNALS" -eq 0 ] && echo "✅ Nenhum sinal — Phase 1.5 skip" && exit 0
echo "→ Propor entry §N em docs/CAPABILITY_REGISTRY.md antes de commitar /end"
echo "→ Usar mcp__egos-governance__get_meta_prompt para recuperar contexto se necessário"
```

**Se qualquer sinal detectado, o agente DEVE:**

1. Listar os arquivos novos/mudados relevantes
2. **Gerar rascunho automático via LLM** (bun inline, qwen-turbo, fail-open):

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
NEW_FILES=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep -vE "^(TASKS|docs/|\.claude/|package\.json)" | head -10)
COMMITS=$(git log --oneline --since='8 hours ago' 2>/dev/null | head -5)
LAST_SEC=$(grep "^## §" docs/CAPABILITY_REGISTRY.md 2>/dev/null | tail -1 | grep -oP '§\d+' | grep -oP '\d+')
NEXT_SEC=$(( ${LAST_SEC:-69} + 1 ))

if command -v bun >/dev/null 2>&1 && [ -n "$NEW_FILES" ]; then
  bun -e "
    import { callHermes } from '$ROOT/packages/shared/src/llm-providers/llm-router.ts'
    const prompt = 'Draft a CAPABILITY_REGISTRY entry for section §${NEXT_SEC}. New files: ${NEW_FILES}. Commits: ${COMMITS}. Format: ## §${NEXT_SEC} — <Name> ($(date +%Y-%m-%d))\n\n**SSOT:** <main file path>\n**Quality:** B\n**Tags:** <3-5 tags>\n\n<2 sentences what it does and how to reuse>. Be concise.'
    try {
      const r = await callHermes(prompt, { maxTokens: 200, timeoutMs: 8000, systemPrompt: 'CAPABILITY_REGISTRY entry writer. Follow format exactly.' })
      console.log(r.content.trim())
    } catch { console.log('[draft] LLM unavailable — write entry manually') }
  " 2>/dev/null
fi
```

3. Perguntar: "Posso adicionar §N ao CAPABILITY_REGISTRY agora?" — Enio responde sim/não/editar
4. Se sim → `git add docs/CAPABILITY_REGISTRY.md` junto com os demais arquivos do /end

**Critério de skip (não propor):** apenas mudanças em TASKS.md, docs/, .claude/, ou arquivos de config (.env.example, package.json deps).

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

8. HIGHEST-LEVERAGE CLASSIFICATION:
   - strengthened: [proof | extraction | canon | traceability | replication]
   - if none: state explicit justification for the detour
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

### Phase 7.1 — SSOT Location Audit (NOVO 2026-05-18)

> Se sessão tocou em decisão arquitetural cross-projeto, agente DEVE garantir que canonical mora no kernel egos, não em leaf-repo.
> **SSOT:** `egos/docs/governance/SSOT_LOCATION_POLICY.md`

```bash
# Check: criaram-se docs/SSOT em algum leaf-repo nesta sessão?
SESSION_SHA=$(git log --since="6 hours ago" --pretty=format:"%H" -- '**/docs/' 2>/dev/null | tail -1)
if [ -n "$SESSION_SHA" ]; then
  LEAF_SSOT_NEW=$(git log --since="6 hours ago" --name-only --pretty=format:"" -- '**/docs/' 2>/dev/null \
    | grep -vE "^egos/|^docs/" \
    | grep -iE "canonical|SSOT" | head -5)
  if [ -n "$LEAF_SSOT_NEW" ]; then
    echo "🟡 Phase 7.1: SSOT criado em leaf-repo nesta sessão — verificar migração"
    echo "$LEAF_SSOT_NEW"
  fi
fi
```

- Se detectado → **bloquear `/end`** até consolidação no kernel + `UPSTREAM_KERNEL.md` apontar
- Override: `EGOS_SKIP_LEAF_CANONICAL=1 /end` (apenas migração)

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

Phase 11.5 — Understanding Verification (Karpathy Doctrine)
  ✓ Artefatos significativos auditados: [N]
  ✓ Visual Proof (se UI mudou): screenshot path / N/A
  ✓ Console clean: ✅ / ❌ (erros: ___)
  ✓ Red Zones tocadas + confirmações Enio: [N/N]
  ✓ Artefatos rebaixados a [/] por falta de prova: [N]

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

## PHASE 11 — Blind-Spot Detection (NOVO v6.2 — super-hermes pattern)

> **Origem:** super-hermes community extension + Opus pass 2026-05-11.
> **Princípio:** o agente pergunta "o que eu pode ter perdido?" ANTES de declarar /end completo.
> **Custo:** ~500 tokens extra. **Ganho:** detecta oversights que passam no Verification Checkpoint.

Para cada bloco de trabalho desta sessão, responder em PT-BR:

```
🔍 BLIND-SPOT CHECK
──────────────────────────────────────────────
O que foi feito: [1 linha — o bloco principal]

O que pode estar FALTANDO ou ERRADO:
- [ ] Existe alguma edge case não testada?
- [ ] Algum arquivo relacionado que deveria ter sido atualizado mas não foi?
- [ ] Alguma dependência quebrada por esta mudança?
- [ ] Alguma task em TASKS.md que deveria ter sido marcada [x] mas não foi?
- [ ] Existe versão mais nova de algo que invalidaria este trabalho?

Se sim → criar task P1 ou corrigir antes de fechar.
Se não → declarar "Blind-spot check: clean ✅"
──────────────────────────────────────────────
```

**Skip conditions:** sessão foi só leitura/pesquisa (zero commits) → escrever "Phase 11: skipped (read-only session)"

---

## PHASE 11.5 — Understanding Verification (NOVO v6.3 — Karpathy Doctrine)

> **Sem este check, /end está incompleto.** Nasce da INC-2026-05-08.
> Princípio: nenhuma sessão fecha com Enio sem entender o que foi entregue.

**Para CADA artefato significativo desta sessão (commits feat/fix grandes, docs novos, mudanças em UI deployada), responder em PT-BR:**

```
ENTENDIMENTO — <artefato>
─ O que foi feito (1-2 linhas, sem jargão):
─ Por que importa:
─ Como funciona (modelo mental, não código):
─ Onde a IA pode estar errada (suposições embutidas):
─ Red Zones tocadas (do ENIO_UNDERSTANDING_MAP §🔴):
─ O que Enio precisa entender antes de delegar mais:
─ Próximo passo seguro:
```

**Visual Proof check (se houver mudança em apps/*-landing/, src/components/*, qualquer rota pública):**
- [ ] Screenshot Playwright capturado nesta sessão? (path: ___)
- [ ] Console do navegador limpo (zero `Error:` no log)?
- [ ] Se NÃO → marcar artefato como **NÃO ENTREGUE** no handoff, mover de `[x]` para `[/]` em TASKS.md, criar P0 para próxima sessão
- [ ] HTTP 200 NÃO substitui prova visual

**Red Zone audit:**
- Listar decisões de Red Zone tomadas nesta sessão
- Para cada uma: Enio confirmou explicitamente? Se não → flag e adiar artefato

---

## PHASE 12 — Final Commit & Push

Se houver mudanças não-commitadas (TASKS.md, handoff, MEMORY.md):

```bash
git add TASKS.md docs/_current_handoffs/handoff_*.md
# Memory files: git add ~/.claude/... separately if tracked
git commit -m "chore(end): session close YYYY-MM-DD — [N] commits, [topic]"

# Push via safe-push (T0 rule §4)
bash scripts/safe-push.sh main
```

---

## PHASE 13 — Codex Adversarial Pre-Push Gate (NOVO v6.3 — Codex+Claude pipeline)

> **Origem:** 2026-05-12 — gpt-5.5 adversarial review antes de push quando sessão foi substancial.
> **SSOT:** `docs/governance/MULTI_LLM_ORCHESTRATION.md` §4
> **Nunca bloqueia push** — só informa. Enio decide.

```bash
EGOS_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/egos")
COMMITS=$(git log origin/main..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
CRITICAL=$(git diff origin/main..HEAD --name-only 2>/dev/null | grep -E "^(auth|migrations|lib/prompts|docs/governance|\.husky|agents/runtime)/" | head -1 || true)

# Verificar quota antes de gastar gpt-5.5
ALARM="unknown"
if command -v bun >/dev/null 2>&1 && [ -f "$EGOS_ROOT/scripts/codex-usage.ts" ]; then
  ALARM=$(bun "$EGOS_ROOT/scripts/codex-usage.ts" --json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('alarm_level','unknown'))" 2>/dev/null || echo "unknown")
fi

if { [ "${COMMITS:-0}" -ge 3 ] || [ -n "$CRITICAL" ]; } && [ "$ALARM" != "red" ] && command -v codex >/dev/null 2>&1; then
  echo ""
  echo "🔍 Phase 13: Codex adversarial review disponível"
  echo "   Commits: $COMMITS | Critical paths: ${CRITICAL:-nenhum} | Quota: $ALARM"
  echo "   → Execute: /codex:adversarial-review --background"
  echo "   → Depois: /codex:result antes do push"
  echo "   → Ou skip: pressione Enter para continuar sem review"
elif [ "$ALARM" = "red" ]; then
  echo "⚪ Phase 13: quota Codex 🔴 — skipped (Claude-only fallback)"
elif [ "${COMMITS:-0}" -lt 3 ] && [ -z "$CRITICAL" ]; then
  echo "⚪ Phase 13: skipped — ${COMMITS} commits, sem paths críticos"
fi
```

**Skip conditions:**
- Quota Codex 🔴 → "Phase 13: skipped — quota crítica"
- Commits < 3 E sem paths críticos → "Phase 13: skipped — sessão pequena"
- Codex não instalado → "Phase 13: skipped — codex não disponível"

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
| 11.5 | NUNCA — Understanding Verification é Karpathy gate | — |
| 12 | Nada uncommitted | "Phase 12: nothing to commit" |
| 13 | Quota 🔴 OU commits < 3 sem paths críticos OU codex ausente | "Phase 13: skipped — [reason]" |

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
