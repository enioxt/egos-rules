---
description: Session Finalization v6.5 — Force-Verify All Phases + Structured Handoff/Memory + Capability Auto-Propose + L0/Template Drift + Cross-Session Merge Handoff
---

# /end — Session Finalization v6.5 (EGOS)

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
5. **RESOLVER DOCTRINE — captura de padrões:** registre as **decisões humanas do Enio** desta sessão (cortes de Red Zone, escolhas entre opções, mudanças de prioridade) como padrão em memória (`feedback`/`project`), para que triagens futuras pré-preencham a preferência dele. SSOT: [RESOLVER_DOCTRINE](../../docs/governance/RESOLVER_DOCTRINE.md) §3.
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

## PHASE 1.6 — FLOW VALIDATION GATE [OBRIGATÓRIO — §10 CLAUDE.md]

> **Regra:** toda nova API route/endpoint criada nesta sessão DEVE ter smoke test executado ANTES de /end fechar.
> TypeScript limpo ≠ feature funcionando. Sem resposta real = [CONCEPT] no handoff, não [DONE].

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)

echo "=== Phase 1.6 — Rotas novas para validar ==="
NEW_ROUTES=$(git log --diff-filter=A --name-only --since='8 hours ago' --pretty=format: 2>/dev/null | grep "route\.ts$\|route\.js$")
if [ -z "$NEW_ROUTES" ]; then
  echo "✅ Nenhuma nova route — Phase 1.6 skip"
  exit 0
fi
echo "Rotas criadas:"
echo "$NEW_ROUTES" | sed 's/^/  - /'
echo ""
echo "Para cada rota acima, confirme:"
echo "  1. Executou curl/smoke test contra o sistema rodando?"
echo "  2. Colou HTTP status + resposta no commit message ou handoff?"
echo "  3. README do app foi atualizado com o novo endpoint?"
echo ""
echo "Se alguma rota NÃO foi testada → marcar [CONCEPT] no handoff, não [DONE]"
echo "Se gateway está no VPS: ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 'curl -s http://localhost:3050/v1/health'"
```

**Para cada nova rota desta sessão, preencher:**
```
FLOW VALIDATION
===============
Route: POST /api/ops/tenant-seed
Smoke: curl -X POST .../api/ops/tenant-seed -H "X-Ops-Token: ..." -d '{...}'
Result: HTTP 200 {"slug":"...","status":"seeded",...}  ← colar real
Status: [DONE] / [CONCEPT — não testado]
```

**Regra de skip:** rota existia antes da sessão → não precisa re-testar. Somente novas rotas.

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

# Phase 2.6 — Dispersion (fecha o loop medir-e-fluir; START-DISPERSION-001 mede na entrada, /end mede na saída) — END-DISPERSION-001
if [ -f "$ROOT/scripts/dispersion-meter.ts" ] && command -v bun >/dev/null 2>&1; then
  echo ""
  echo "=== Dispersão (saída da sessão — Norte: Pursuit A/intelink) ==="
  bun "$ROOT/scripts/dispersion-meter.ts" 2>/dev/null || echo "dispersion-meter: erro (skip)"
fi
```

> **Phase 2.6 — leitura de dispersão na saída.** Se 🔴 (ask_recentering), registrar no handoff/memory que a sessão foi alta-dispersão + se foi generativa (capabilities/descoberta) ou ruído (re-juggling/colisão). O delta com a leitura do /start mostra se a sessão concentrou ou espalhou. NÃO bloqueia — instrumento. SSOT: `scripts/dispersion-meter.ts` + `feedback_dispersion_norte_hybrid`.

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

## PHASE 3.5 — Rule Change Interview (END-EXPAND-002)

> **Origem:** 2026-05-29 — sessões mudavam regras/overrides sem capturar a intenção. Memory e HARVEST ficavam sem contexto sobre o porquê da mudança.

```bash
EGOS_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/egos")
# Detectar mudanças em arquivos de regras desta sessão
RULE_FILES=$(git diff --name-only origin/main..HEAD 2>/dev/null | grep -E \
  "(CLAUDE\.md|AGENTS\.md|OVERRIDES\.md|INHERITS\.md|\.guarani/|LAYER_0_SSOT|TEMPLATE_INHERITANCE|DOMAIN_TEMPLATE|egos-rules/)" || true)
if [ -z "$RULE_FILES" ]; then
  echo "✅ Phase 3.5: sem mudanças em arquivos de regras — skip"
else
  echo "⚠️  Phase 3.5: mudanças detectadas em arquivos de regras:"
  echo "$RULE_FILES" | sed 's/^/  - /'
  echo ""
  echo "Responda cada pergunta (sim/não/N-A) antes de prosseguir:"
fi
```

**Perguntas obrigatórias quando `RULE_FILES` não é vazio:**

```
RULE CHANGE INTERVIEW
=====================

[responder apenas as que forem "sim" — marcar as outras N-A]

R1. NOVA REGRA adicionada (T0/T1/T2/L0/REGRA)?
    → Se sim: qual regra, em qual arquivo, qual o motivo/incidente que gerou?

R2. REGRA EXISTENTE alterada (scope, default, comportamento)?
    → Se sim: qual era antes, o que mudou, por quê (incidente? feedback? nova evidência)?

R3. OVERRIDE criado/alterado em OVERRIDES.md?
    → Se sim: OVR-NNN, para qual produto/cliente, base legal/razão, quem aprovou?

R4. HERANÇA alterada (INHERITS.md, inherits: campo)?
    → Se sim: template afetado, o que mudou na cadeia de herança?

R5. ARQUIVO CRÍTICO editado (.guarani/, .husky/pre-commit, agents/runtime/)?
    → Se sim: o que mudou exatamente — VERIFICAR que não quebra pipeline

R6. MUDANÇA EM POSTURA/COMPORTAMENTO do agente (CLAUDE.md T0/T1)?
    → Se sim: contexto que levou à mudança — candidato a memory write (Phase 8)
```

**Ação pós-entrevista:**
- Respostas R1/R2 com motivo claro → candidato a `HARVEST.md` (comportamento novo) ou `docs/knowledge/`
- Respostas R3/R4 → verificar que INHERITS.md e OVERRIDES.md estão sincronizados
- R5 → rodar `bun run governance:check` antes de prosseguir
- R6 → garantir que Phase 8 (memory) vai capturar o contexto

**Skip:** todos N-A → "Phase 3.5: sem mudanças de regras nesta sessão"

---

## PHASE 3.6 — Varredura Anti-Atropelo: idéia/conceito → task (OBRIGATÓRIA — END-ANTIATROPELO-001)

> **Origem:** Enio 2026-06-03 — "documente tudo que falamos aqui, não deixe nenhuma task pendente, nenhuma idéia, conceito que deveria ter virado task, não virou mas é importante e fomos atropelando assuntos. Quero que vire regra, executada no final de cada /end."
> **Princípio:** numa sessão de fluxo, assuntos se atropelam — idéias boas são ditas de passagem e morrem. Esta fase **relê a sessão inteira** e força cada idéia/conceito/decisão importante a virar task em `TASKS.md` (ou nota deferida registrada), ANTES do handoff e do commit final. **Nada de valor pode morrer no transcript.**
> **Não-negociável:** /end SEM esta varredura = incompleto. NÃO é skipável (nem em sessão pequena — só read-only zero-commit pode declarar "Phase 3.6: skip — read-only").

### Procedimento (executar de fato, não declarar)

1. **Reler a sessão inteira** (não só os últimos turnos) procurando os GATILHOS abaixo. Inclui o que VOCÊ propôs, o que o Enio disse de passagem, e o que veio de fonte externa (LLM colado, doc, link).
2. Para CADA achado: triagem `R = L/C` (Resolver Doctrine): **RESOLVE-NOW** (barato+alta alavancagem, faça já antes de fechar) · **TASK** (vira `[ ]` em TASKS.md com ID + prioridade derivada de L) · **NOTA-DEFERIDA** (registrar como nota `>` no bloco da sessão p/ não perder, com motivo explícito de por que NÃO é task agora — ex: Karpathy/over-engineering).
3. Idéia da qual você não tem certeza se já virou task → **grep no TASKS.md primeiro**; só então decидir. Duplicar é melhor que perder, mas verifique.
4. Tasks novas entram na Phase 5 (TASKS.md) e vão no commit final (Phase 12).

### GATILHOS específicos (customizados — varrer por TODOS)

**Linguísticos (o que foi dito):**
- futuro/adiamento: "depois", "no futuro", "mais pra frente", "outra hora", "em algum momento", "quando der"
- desejo/sugestão: "seria bom", "podíamos", "dava pra", "vale a pena", "e se", "também", "ideia de", "imagina se"
- falta/lacuna: "falta", "ainda não", "precisa", "tem que", "o que falta", "limitação", "gap"
- corte/deferimento: "deferido", "adiar", "fica pra", "por enquanto não", "Red Zone → task", "depois a gente vê"
- decisão do Enio entre opções (cada opção NÃO escolhida pode virar task/nota)

**Estruturais (o que ficou nos artefatos):**
- seções "Próximos passos", "Limitações", "O que falta", "Future", "em breve", "TODO", "FIXME" em docs/README/STATUS criados ou tocados na sessão
- achados incidentais não corrigidos (bug visto de passagem, drift, dívida técnica)
- sugestões de LLM externo coladas na sessão (specs, listas numeradas, arquiteturas propostas) — cada item é candidato
- features mencionadas no commit/handoff como `[CONCEPT]` ou "próxima sessão"
- qualquer "opção" apresentada ao Enio que ele não escolheu mas não rejeitou

### Output OBRIGATÓRIO (formato literal)

```
VARREDURA ANTI-ATROPELO
=======================
Sessão relida: [N turnos / desde quando]
Achados: [N]  →  RESOLVE-NOW: [n]  ·  TASK nova: [n]  ·  NOTA-deferida: [n]  ·  já-existia: [n]

NOVAS TASKS criadas (com ID + prioridade):
- [ID] [P?] — [1 linha]
RESOLVIDO AGORA (antes de fechar):
- [o quê] — [SHA se commitado]
NOTAS DEFERIDAS (registradas, não-task, com motivo):
- [idéia] — por que NÃO é task agora: [motivo]
```

**Critério de aceite:** ao final, o agente afirma: *"Nenhuma idéia/conceito da sessão ficou sem destino (task, resolução ou nota com motivo)."* Se não puder afirmar isso → continuar varrendo.

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
- [opção rejeitada] — escolhi X em vez de Y porque Z (raciocínio que se perde se não escrito)

## ✅ Todos da sessão (snapshot literal do TodoWrite)
<!-- B: cole AQUI a lista TodoWrite atual. É o artefato 100% perdido no handoff se não persistir. -->
- [x] [todo concluído]
- [/] [todo em progresso — % + bloqueador]
- [ ] [todo pendente]

## 🚫 Marked [CONCEPT] (não entrar em HARVEST)
- [feature discutida mas não commitada]
```

> **Cross-window (Prime↔Guarani)?** Use `docs/_current_handoffs/_TEMPLATE_sync.md` (tem ownership por janela + estado retido).

---

## PHASE 4.1 — Handoff Fidelity Gate (NOVO 2026-05-31 — context-transfer telemetry)

> **Princípio:** mede quanto contexto sobrevive ao handoff. Read-only, não-bloqueante. KPI → `docs/jobs/` + Supabase.

```bash
bun scripts/handoff-fidelity.ts --quiet 2>/dev/null || echo "[handoff-fidelity] script indisponível — skip"
```

**Reportar no Verification Checkpoint:** `completeness_score` (alvo ≥80). Se <60 🟡 → reforçar: SHAs em claims-done, next-step em in-progress, snapshot dos todos (B), seção de decisões/rejeitadas (C).

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

### Phase 7.2 — Template/L0 Drift Check (NOVO 2026-05-29 — END-EXPAND-001)

> Se a sessão mudou regras Layer 0 OU arquivo de template de domínio, agente DEVE perguntar se inheritance/overrides precisam de update.
> **SSOT:** `docs/governance/LAYER_0_SSOT.md` + `TEMPLATE_INHERITANCE_PROTOCOL.md`

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
SESSION_FILES=$(git log --since='8 hours ago' --name-only --pretty=format: 2>/dev/null | sort -u | grep -v '^$')

# Detectar mudança em fontes Layer 0
L0_CHANGED=$(echo "$SESSION_FILES" | grep -E "^(AGENTS\.md|\.guarani/RULES_INDEX\.md|docs/governance/LAYER_0_SSOT\.md|docs/governance/TEMPLATE_INHERITANCE_PROTOCOL\.md|docs/governance/DOMAIN_TEMPLATE_SPEC\.md)$")

# Detectar mudança em template de domínio
TEMPLATE_CHANGED=$(echo "$SESSION_FILES" | grep -E "^central-egos/products/[^_][^/]+/")

if [ -n "$L0_CHANGED" ]; then
  echo "🟡 Phase 7.2: Layer 0 source files mudados:"
  echo "$L0_CHANGED" | sed 's/^/   - /'
  echo ""
  echo "Verificar templates que herdam (cada um precisa re-validação):"
  ls -d central-egos/products/[^_]*/ 2>/dev/null | sed 's/^/   - /'
  echo ""
  echo "❓ Para cada template ativo: a mudança em L0 muda comportamento herdado?"
  echo "   Se sim: atualizar INHERITS.md do template + nota em handoff."
fi

if [ -n "$TEMPLATE_CHANGED" ]; then
  TEMPLATES=$(echo "$TEMPLATE_CHANGED" | cut -d/ -f3 | sort -u)
  echo "🟡 Phase 7.2: Templates de domínio mudados: $TEMPLATES"
  echo ""
  echo "Verificar para cada template mudado:"
  echo "   1. INHERITS.md ainda consistente com mudanças no CLAUDE.md?"
  echo "   2. Algum override novo deveria virar entry em OVERRIDES.md?"
  echo "   3. Score do template (DOMAIN_TEMPLATE_SPEC §4) mudou?"
fi

if [ -z "$L0_CHANGED" ] && [ -z "$TEMPLATE_CHANGED" ]; then
  echo "✅ Phase 7.2: skip — nenhuma mudança em L0 ou templates"
fi
```

**Skip conditions:** session zero commits OR somente `docs/jobs/` `docs/audits/` mudaram → "Phase 7.2: skip — sem impacto em L0/templates"

### Phase 7.3 — NotebookLM Sync Check (NOVO 2026-05-30)

> Se a sessão mudou um doc canônico (README/arquitetura/regras) de um repo com notebook mapeado,
> a fonte correspondente no NotebookLM ficou desatualizada. SSOT: `docs/notebooklm/NOTEBOOKS_INDEX.md`.
> Limitação: NotebookLM não substitui fonte. Sync = **ADD-only**: `source_add(nova)` → verificar →
> enfileirar deleção da antiga para HITL batch. **Nunca deletar antes de confirmar o add** (evita órfão).

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
SESSION_FILES=$(git log --since='8 hours ago' --name-only --pretty=format: 2>/dev/null | sort -u | grep -v '^$')
# Docs canônicos que são fonte obrigatória de notebook
NLM_SOURCE_CHANGED=$(echo "$SESSION_FILES" | grep -iE "(^|/)README\.md$|SYSTEM_MAP|ARCHITECTURE|INHERITS\.md$|CLAUDE\.md$|AGENTS\.md$")
if [ -n "$NLM_SOURCE_CHANGED" ]; then
  echo "🟡 Phase 7.3: docs-fonte de notebook mudaram nesta sessão:"
  echo "$NLM_SOURCE_CHANGED" | sed 's/^/   - /'
  echo "   → Verificar NOTEBOOKS_INDEX.md: este repo tem notebook? a fonte precisa re-sync?"
  echo "   → Se sim (ADD-only): source_add(nova) → notebook_get verifica → enfileirar deleção da antiga p/ HITL"
  echo "   → Registrar em docs/notebooklm/sync-log.md. Boundary LGPD §5.5 antes de source_add."
  echo "   → NUNCA source_delete autônomo (nem da MESMA fonte) — deleção só em HITL batch."
else
  echo "✅ Phase 7.3: skip — nenhum doc-fonte de notebook mudou"
fi
```

**Ação (ADD-only):** se houver re-sync pendente e o `notebooklm-mcp` estiver autenticado **na máquina local** → `source_add(nova)`, verificar via `notebook_get`, e **enfileirar** a deleção da fonte antiga para aprovação HITL (nunca deletar inline). Registrar no op-ledger + sync-log. A VPS Hermes só detecta/notifica (sem credencial NotebookLM) — ver §9.3 da integração.

**Skip conditions:** zero commits OR nenhum doc-fonte mudou → "Phase 7.3: skip".

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

### 8.2 — (REMOVIDO 2026-05-29) Obsidian/wiki-compile retirado

> Camada Obsidian vault aposentada (Opção B — 2026-05-29). Vault local estava morto
> (0 edições em 7d, cron `daily-knowledge-sync` falhando há semanas com `bun: command not found`).
> Conhecimento vive em: Supabase `kb_pages` (via Phase 8.1 `record_learning`) + NotebookLM (síntese sob demanda).
> `wiki-compiler.ts` permanece como ferramenta manual do Supabase (`bun run wiki:compile`), apenas não é mais auto-invocado.

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

### 8.5 — Subagent/Research Intelligence Harvest (NOVO 2026-06-07 — END-HARVEST-001)

> **Origem:** sessão de propósito 2026-06-07 — o /end salvou as CONCLUSÕES mas deixou a INTELIGÊNCIA das sondas (7 relatórios: mapa forense, correlação traço↔arquitetura, inventário de monetização) viver só no transcript. Enio teve que pedir "verifique de novo, não percamos algo precioso" para o gap ser pego. Causa-raiz: subagent output tratado como andaime descartável após síntese. Ironia: numa sessão sobre "preserve a evidência", a evidência foi descartada.
> **Princípio:** numa sessão com `Agent`/`Explore`/`Workflow`, o subagente produz ANÁLISE/EVIDÊNCIA cara de re-derivar. A conclusão vai pra Phase 8; a EVIDÊNCIA que a sustenta NÃO PODE morrer no tool-result. Re-derivar custa tokens+tempo; o raciocínio é load-bearing.

**Dispara quando:** a sessão chamou ≥1 `Agent`/`Explore`/`Workflow`/sonda que retornou análise NÃO-commitada como código (inventário, mapa, tabela, comparação, refutação, forense, correlação).

**Ação (executar, não declarar):**
1. Listar os relatórios de subagente da sessão (o que cada sonda produziu).
2. Para cada um, triar: **JÁ-EM-CÓDIGO** (virou commit → ok) · **CONCLUSÃO-JÁ-EM-MEMORY** (a decisão está salva, mas e a evidência?) · **SÓ-NO-TRANSCRIPT** (perde no próximo chat).
3. Para os **SÓ-NO-TRANSCRIPT** com valor de referência → **condensar** (não colar inteiro — anti-bloat) num arquivo `type: reference` em `memory/session_YYYY-MM-DD_intelligence-*.md` (tabelas-chave + números + paths) OU, se >20K e operacional, `docs/jobs/YYYY-MM-DD-*.md`. Linkar `[[conclusão]]`.
4. Atualizar MEMORY.md index.

**Output obrigatório:**
```
INTELLIGENCE HARVEST
====================
Subagentes na sessão: [N]
  - [sonda] → JÁ-EM-CÓDIGO / CONCLUSÃO-EM-MEMORY / SÓ-NO-TRANSCRIPT
Harvested: [arquivo(s) criado(s) p/ os SÓ-NO-TRANSCRIPT valiosos]
Afirmação: "Nenhuma inteligência de subagente com valor de referência ficou só no transcript."
```

**Skip:** sessão sem subagente OU todo output já virou código/memory → "Phase 8.5: skip — sem inteligência órfã".

---

## PHASE 8.6 — Knowledge Ingest Gate [OBRIGATÓRIO — END-INGEST-PROMPT-001]

**SEMPRE executar — sem skip.** Perguntar ao Enio ANTES de fechar:

> "📥 **Tem algo a acrescentar desta sessão?**
> Notas soltas, resumos do ChatGPT/Grok, estudos lidos, áudios transcritos, ideias anotadas no celular — qualquer coisa que ficou fora da conversa.
> Se sim: drope aqui ou em `docs/_inbox/ingest/` e eu processo (atomizo → memória → RAG).
> Se não: 'nada' e seguimos."

**Processar resposta:**
- **"nada" / silêncio**: registrar no handoff: "Phase 8.6: nenhum ingest externo". Seguir.
- **Conteúdo dropado**: executar pipeline KNOWLEDGE-INGEST-CHANNEL-001 (quando implementado) OU atomizar manualmente → memory write → arquivar em `docs/_inbox/ingest/processed/`.
- **"tem mas não agora"**: criar task INGEST-PENDENTE-<data> no TASKS.md e registrar no handoff.

**Origem:** Enio 2026-06-08 — "todo /end talvez você deveria me perguntar se temos algo a acrescentar de anotações, chatgpt, grok, estudos — inclua isso, tornar obrigatório". SSOT: KNOWLEDGE-INGEST-CHANNEL-001.

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

Phase 3.6 — Varredura Anti-Atropelo (OBRIGATÓRIA)
  ✓ Achados: [N] → TASK nova: [n] · RESOLVE-NOW: [n] · NOTA-deferida: [n]
  ✓ Afirmação: "Nenhuma idéia/conceito ficou sem destino" ✅
  ✗ NÃO ACEITO: pular sem reler a sessão inteira

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

Phase 7.2 — Template/L0 Drift
  ✓ L0 sources changed: [lista ou nenhum]
  ✓ Templates changed: [lista ou nenhum]
  ✓ Inheritance reconciled: ✅ / ⚠️ (templates X, Y precisam update INHERITS.md)
  ✓ Action items added to handoff: [N]

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

> **MELHORIA 2026-06-02 (sessão maratona):** ANTES do commit final, **sincronizar espelhos** — senão /end deixa drift que o próximo /start/Sentinela pega (bati nisso ~6× numa sessão). E rodar a Sentinela pro relatório final.

```bash
# 0. Auto-heal mirrors (kernel→claude-runtime/egos-home/.guarani) — fim do drift de espelho
bun scripts/egos-autoheal.ts 2>/dev/null || echo "autoheal indisponível"
# 0.1 Sentinela: relatório + flags finais (o que fica pro próximo)
bun scripts/agent-sentinela.ts --force 2>/dev/null | tail -3 || true

# 1. Commit final (path-scoped, nunca -A; -m ANTES de qualquer --path)
git add TASKS.md docs/_current_handoffs/handoff_*.md
# Memory files: git add ~/.claude/... separately if tracked
# NOTA (2026-06-02): se a coordination-watcher estiver stale, o pre-commit BLOQUEIA com
# "❌ BLOCKED: Coordination watcher stale". Bypass sancionado: prefixar EGOS_WATCHER_OVERRIDE=1.
# (Recorrente em sessões longas sem watcher rodando — bati ~8× numa sessão.)
EGOS_WATCHER_OVERRIDE=1 git commit -m "chore(end): session close YYYY-MM-DD — [N] commits, [topic]"

# Push via safe-push (T0 rule §4)
bash scripts/safe-push.sh main
```

> **Lição de sintaxe (recorrente):** `git commit -m "msg" -- <path>` — a mensagem vem ANTES do `--`, senão vira pathspec ("did not match any file"). E `git checkout -- docs/jobs/` antes do commit limpa o ruído do hook-log auto-gerado.

> **Atrito recorrente — watcher stale (2026-06-02):** em sessão longa sem `coordination-watcher.ts` rodando, TODO commit do /end bate em "❌ BLOCKED: Coordination watcher stale (>Ns)". O bypass documentado é `EGOS_WATCHER_OVERRIDE=1 git commit ...`. Já está embutido no comando acima. (Idem para /start e commits intermediários.)

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

## PHASE 14 — Cross-Session Merge Handoff (NOVO v6.5 — multi-window merge)

> **Quando roda:** APENAS quando esta sessão faz parte de um merge de N janelas Claude Code numa
> sessão-mestre única. Gatilho: usuário pede "merge das janelas" / `/end merge` / `EGOS_MERGE=1`.
> **Princípio:** a sessão-mestre que sobrevive precisa reconstruir o CONTEXTO COMPLETO de cada janela
> encerrada sem ter visto a conversa dela. Handoff normal (Phase 4) é resumo de status; o MERGE BLOCK
> é auto-suficiente: estado git + trabalho in-flight + contexto EGOS necessário p/ continuar.
> **Por que é separado:** as janelas compartilham o mesmo `.git/index` por repo (INC-002). Merge mal-feito
> = colisão de index, trabalho não-commitado perdido, ou TASKS.md sobrescrito.

### 14.1 — Garantir que NADA fica não-commitado e invisível

```bash
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
cd "$ROOT"
echo "=== Uncommitted nesta janela (DEVE virar commit path-scoped OU constar no MERGE BLOCK) ==="
git status --short
echo "=== Commits locais ainda não no remoto ==="
git log --oneline origin/$(git branch --show-current)..HEAD 2>/dev/null
```

- Trabalho commitável → **commit path-scoped + push AGORA** (`git add <arquivos-desta-janela>`, nunca `-A`).
- Trabalho que NÃO dá pra commitar (rascunho, decisão pendente) → listar literalmente no MERGE BLOCK §Uncommitted.
- A sessão-mestre vai `git pull` antes de ler os blocks — então tudo que está no remoto ela enxerga.

### 14.2 — Escrever o MERGE BLOCK (formato literal, auto-suficiente)

> **INBOX DE MERGE = SEMPRE O KERNEL `egos`** (determinístico — INC-MERGE-001 2026-05-30).
> A janela-mestre dá `git pull` no kernel `egos`. Portanto **toda** janela — esteja ela no kernel
> OU num leaf-repo (intelink-platform, etc.) — escreve seu MERGE BLOCK dentro do kernel `egos`.
> O TRABALHO REAL (commits) continua no repo da janela; o BLOCK só **referencia os SHAs**.
> Sem isto, uma janela em leaf escreveria o block onde a mestre nunca olha (gap descoberto no
> merge de 3 janelas 2026-05-30: a janela intelink teve que improvisar o destino — não pode depender de improviso).

Cada janela escreve **seu próprio arquivo** (sem colisão), no kernel:
`<kernel>/docs/_current_handoffs/_merge_YYYY-MM-DD/<repo>__<branch>__<short-head>.md`

```bash
# Resolve o kernel egos de forma fixa (a mestre SEMPRE pulla aqui).
KERNEL=$(cd /home/enio/egos 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || echo "/home/enio/egos")
MERGE_REL="docs/_current_handoffs/_merge_$(date +%Y-%m-%d)"
MERGE_DIR="$KERNEL/$MERGE_REL"
mkdir -p "$MERGE_DIR"
REPO=$(basename "$ROOT"); BR=$(git branch --show-current); SH=$(git rev-parse --short HEAD)
CROSS=$([ "$ROOT" = "$KERNEL" ] && echo "nao" || echo "SIM (trabalho real está em $ROOT, NÃO no kernel)")
echo "MERGE BLOCK alvo: $MERGE_DIR/${REPO}__${BR}__${SH}.md | cross-repo=$CROSS"
```

> **Se cross-repo=SIM:** o cabeçalho do MERGE BLOCK DEVE abrir com um aviso explícito de que os
> commits vivem no repo leaf (`git@github.com:enioxt/<repo>.git`) e a mestre **NÃO deve tentar
> fundir esses commits no egos** — o block é registro/herança, não código a fundir.
> O vocab-guard do kernel roda sobre o block (é markdown no egos) → evite termos phantom.

Conteúdo OBRIGATÓRIO (preencher cada seção — a sessão-mestre depende disto):

```markdown
# MERGE BLOCK — <repo> / <branch> — YYYY-MM-DD HH:MM

## 🪟 Identidade da janela
- Repo / cwd: <path>
- Branch: <branch> | HEAD: <SHA> | pushed: sim/não
- Modelo: <claude-opus-4-X / sonnet>
- Foco desta janela (1 linha): <o que esta janela estava resolvendo>

## ✅ Entregue (com SHAs — só o que tem hash)
- <SHA> <arquivo> — <o que mudou e por quê>

## 🧠 Contexto EGOS que a sessão-mestre precisa herdar
> Não assuma que a mestre sabe. Escreva o que é load-bearing:
- Decisões arquiteturais tomadas + porquê
- SSOTs tocados (qual doc é a verdade agora)
- Repos/sistemas afetados (egos kernel? leaf? produto? VPS?)
- Convenções/regras descobertas ou alteradas nesta janela

## 🔗 In-flight / Uncommitted (CRÍTICO p/ não perder)
- Arquivos não-commitados: <lista ou "nenhum">
- Trabalho parcial: <descrição + onde parou>
- Índice .git compartilhado: <esta janela mexeu nos mesmos arquivos de outra? quais?>

## ⏳ Blockers + decisões pendentes Enio
- <blocker> — <quem decide / o que falta>

## 🎯 Next (priorizado) — o que a sessão-mestre deve fazer com isto
1. <ação concreta com task ID>

## ⚠️ Conflitos potenciais no merge
- TASKS.md: <esta janela editou? quais linhas/seções?>
- Mesmos arquivos de outra janela: <lista>
- Migrations/deploy/VPS em voo: <sim/não + detalhe>
```

### 14.3 — Commit + push do MERGE BLOCK (SEMPRE no kernel egos)

> ORDEM OBRIGATÓRIA: (1) primeiro commit+push do TRABALHO REAL no repo da janela (`$ROOT`, 14.1);
> (2) só então commit+push do BLOCK no kernel. Assim os SHAs citados no block já existem no remoto.

```bash
# O block vive no kernel — commitar/pushar SEMPRE a partir do kernel, nunca do leaf.
( cd "$KERNEL" \
  && git add "$MERGE_REL/" \
  && git commit -m "chore(merge): MERGE BLOCK ${REPO} ${SH} — handoff p/ sessão-mestre" \
  && bash scripts/safe-push.sh "$(git -C "$KERNEL" branch --show-current)" )
```

> Se safe-push falhar por não-FF (outra janela pushou antes) → `git -C "$KERNEL" fetch && git -C "$KERNEL" rebase origin/<branch>`,
> nunca `--no-verify`, nunca force. O MERGE BLOCK é aditivo (arquivo próprio, nome único) → rebase é trivial.
> O pre-commit do kernel (vocab-guard etc.) roda sobre o block — se bloquear por termo phantom, reescreva o block.

### 14.4 — Sinalizar pronto

Ao final, imprimir para o usuário (copiável para a janela-mestre):

```
✅ MERGE BLOCK pronto: <path> (pushed @ <SHA>)
   Janela-mestre: rode `git pull` e leia docs/_current_handoffs/_merge_YYYY-MM-DD/*.md
```

**Skip conditions:** sessão NÃO faz parte de merge multi-janela → "Phase 14: skip — sessão única".

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
| 3.5 | Nenhum arquivo de regra mudado | "Phase 3.5: sem mudanças de regras nesta sessão" |
| 3.6 | NUNCA (exceto read-only zero-commit) | "Phase 3.6: skip — read-only" |
| 7.2 | Zero commits OU só mudanças em docs/jobs+audits | "Phase 7.2: skip — sem impacto L0/templates" |
| 8 | NUNCA — memory write obrigatório | — |
| 8.5 | Sessão sem subagente OU output já em código/memory | "Phase 8.5: skip — sem inteligência órfã" |
| 9 | Sessão zero commits OU só infra/chore | "Phase 9: skip — [reason]" |
| 10 | NUNCA — checkpoint é a prova | — |
| 11.5 | NUNCA — Understanding Verification é Karpathy gate | — |
| 12 | Nada uncommitted | "Phase 12: nothing to commit" |
| 13 | Quota 🔴 OU commits < 3 sem paths críticos OU codex ausente | "Phase 13: skipped — [reason]" |
| 14 | Sessão NÃO faz parte de merge multi-janela | "Phase 14: skip — sessão única" |

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

*v6.7 — 2026-06-07 | Phase 8.5 Subagent/Research Intelligence Harvest (END-HARVEST-001, pedido Enio "por que errou no /end"): força colher a EVIDÊNCIA das sondas (Agent/Explore/Workflow) que vive só no transcript, condensada em memory `reference` ou docs/jobs. Causa-raiz: subagent output tratado como andaime descartável após síntese — /end salvava conclusão, perdia a análise que a sustenta. Pego só porque Enio mandou "verifique de novo, não percamos algo precioso".*
*v6.6 — 2026-06-03 | Phase 3.6 Varredura Anti-Atropelo (END-ANTIATROPELO-001, pedido Enio): relê a sessão INTEIRA por gatilhos linguísticos+estruturais e força cada idéia/conceito/decisão a virar task (ou nota deferida com motivo) antes do handoff/commit. Não-skipável (exceto read-only). Origem: sessão item-intake onde idéias boas (KYTE-API, DEDUP, GENERIC, TOOLS-INVENTORY…) foram ditas de passagem e só viraram task numa varredura manual pós-/end.*
*v6.5.1 — 2026-05-30 | Phase 14 cross-repo fix (INC-MERGE-001): inbox de merge SEMPRE no kernel egos (a mestre só pulla lá). Janela em leaf-repo escreve o block no kernel referenciando os SHAs do leaf; commit/push do block a partir do kernel. Descoberto no merge de 3 janelas onde a janela intelink-platform teve que improvisar o destino.*
*v6.5 — 2026-05-30 | Adiciona Phase 14 Cross-Session Merge Handoff — MERGE BLOCK auto-suficiente por janela quando N sessões Claude Code são fundidas numa sessão-mestre única (index .git compartilhado, INC-002).*
*v6.4 — 2026-05-29 | Adiciona Phase 3.5 Rule Change Interview (END-EXPAND-002) — 6 perguntas estruturadas quando CLAUDE.md/AGENTS.md/OVERRIDES.md/INHERITS.md/.guarani mudaram.*
*v6.3 — 2026-05-29 | Adiciona Phase 7.2 Template/L0 Drift Check (END-EXPAND-001) — detecta mudanças em Layer 0 ou templates de domínio e força reconciliação de inheritance/overrides.*
*v6.2 — Capability Auto-Propose (Phase 1.5) + Codex Adversarial Gate (Phase 13).*
*v6.1 — 2026-05-07 | Force-verify all phases + structured templates | Substitui v5.5 (.egos), v5.7 (egos), SKILLS-007 (~/.claude)*
*Bug fix: v5.7 era descritivo demais → handoffs e memory writes inconsistentes. v6.1 força templates literais.*
