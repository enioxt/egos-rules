---
description: /rules — EGOS self-improvement. Varre a sessão por aprendizados que devem virar regra, classifica, escreve no SSOT canônico certo, dissemina e commita. Invocável manualmente ou por trigger (Stop hook). É o EGOS se melhorando 24/7.
---

# /rules — Codificação e Disseminação de Regras (EGOS self-improvement)

> **Princípio:** o EGOS melhora a si mesmo. Toda sessão que ensina algo sobre **como o sistema deveria operar** deve virar regra codificada no SSOT certo — não ficar só na memória de uma janela.
> **Trigger ideal:** automático no fim de sessão (Stop/SessionEnd hook chama `/rules`). Manual: `/rules` a qualquer momento.
> **Âncora:** RULE PRECEDENCE (CLAUDE.md), [[PRIME_OPERATING_PROCESS]] §7 (persiste padrões), RESOLVER_DOCTRINE §3 (cortes do Enio viram padrão).

---

## CONTRATO

1. **Não inventar regra.** Só codificar o que a sessão **provou** (falha real, descoberta, padrão repetido ≥2×, corte explícito do Enio). Dúvida = não virar regra, virar `LEARNING:` no commit.
2. **Cada regra tem 1 SSOT.** Achar o lugar canônico pela precedência — não criar arquivo novo se já existe o domínio.
3. **Frozen zones** (`.guarani/` core, `.husky/pre-commit`) → commit isolado + proof. Nunca em batch.
4. **Banidos absolutos** na redação ("100%", "garantido", "sempre"). Regra é condicional e verificável.
5. **Disseminar** se for regra de kernel que vale para leaves → `/disseminate` depois.

---

## PROCESSO (5 passos)

### 0. CONSUMIR a fila de pendências (loop de auto-melhoria)
Antes de varrer a sessão atual, ler `~/.egos/rules-pending.jsonl` — o **SessionEnd hook** (`rules-pending-scan.sh`) flagga ali os commits de governança/regra de sessões anteriores que não foram codificados. Processar essas entradas junto com a sessão atual. Ao terminar, **marcar como processadas** (reescrever a linha com `"status":"processed"`) para não re-surfaçar. Isto fecha o loop 24/7: sessão termina → flagga → próximo /start surfaça → /rules codifica → marca processado.

### 1. VARRER a sessão — candidatos a regra
Revisar o que esta sessão (ou as N últimas) ensinou. Fontes:
- **Falhas reais** que se evitariam com uma regra (ex: "slide_deck do NotebookLM falha via API → documentar, não retentar 3×").
- **Descobertas que mudam o fluxo** (ex: "discover-before-create salvou duplicata 2× → checar índice/SSOT antes de criar artefato").
- **Padrões repetidos ≥2×** (ex: "toda re-sync de fonte NotebookLM = source_add nova → verificar → delete antiga").
- **Cortes do Enio** (Red Zone decididas, preferências confirmadas) → memória `feedback`/`project` + regra se for comportamental.
- **Drift detectado** (SSOT invertido, phantom em índice, doc desatualizado).

Para cada candidato, escrever 1 linha: *o que aconteceu → que regra evita/melhora.*

### 2. CLASSIFICAR cada candidato

| Tipo | Onde mora |
|---|---|
| **T0** (dano irreversível) | `~/.claude/CLAUDE.md §0` + `egos/CLAUDE.md` |
| **T1** (integridade código/dado) | `CLAUDE.md §1-§4` ou `AGENTS.md §R*` ou `.guarani/` |
| **T2** (operação dentro do EGOS) | `CLAUDE.md §5-§9` ou `docs/governance/<dominio>.md` |
| **T3** (comportamento Enio-específico) | `~/.claude/egos-rules/<arquivo>.md` |
| **Reference** (tabela/lookup) | `~/.claude/egos-rules/` ou `docs/governance/` |
| **Skill-pattern** (workflow repetível) | virar/atualizar skill em `.claude/commands/` (rodar `/skillify`) |
| **Memória só** (contexto, não regra) | `~/.claude/projects/.../memory/` |
| **Nenhum** | `LEARNING:` no commit, não codifica |

### 3. ESCREVER no SSOT canônico
- Editar o arquivo existente do domínio (nunca criar novo se já existe).
- Redação: condicional, verificável, com a origem (incidente/data) entre parênteses.
- Se tocar CLAUDE.md: respeitar Gate A (Conservação) — listar o que foi considerado remover.
- Se for skill nova: usar `/skillify` (3-Question + 3-Scenario test).

### 4. DISSEMINAR (se kernel→leaves)
- Regra de kernel que vale para leaf-repos → rodar `/disseminate` após commit.
- Atualizar `.guarani/RULES_INDEX.md` se for regra constitucional indexada.

### 5. COMMIT + PUSH
- Path-scoped (`git add <arquivos>`, nunca `-A`). Frozen → `--no-verify` + proof.
- Mensagem: `chore(rules): <regra> (origem: <incidente/sessão>)`.
- Push via `safe-push.sh`.

---

## OUTPUT (checkpoint obrigatório)

```
═══════════════════════════════════════════════
/rules — Self-Improvement Checkpoint
═══════════════════════════════════════════════
Candidatos varridos: [N]
Viraram regra: [N]
  - [regra] → [SSOT] (tipo) — SHA [hash]
LEARNING (não-regra): [N] — [1 linha cada]
Disseminado p/ leaves: [sim/não]
Frozen zone tocada: [lista ou nenhum]
═══════════════════════════════════════════════
```

---

## TRIGGER AUTOMÁTICO (a wirear — ideal)

Para o EGOS se melhorar 24/7 sem o Enio pedir:
- **Stop hook** (`~/.claude/settings.json`): ao fim de sessão com commits, rodar `/rules` em modo varredura-rápida (só flagga candidatos fortes; não commita sem revisão se Red Zone).
- **Hermes (VPS)**: detector de drift recorrente já existe; quando achar SSOT invertido/phantom, escreve no blackboard → próxima sessão Claude Code roda `/rules` no achado.
- Cuidado: regra que toca Red Zone (pricing, estatuto, legal, copy pública) **nunca** auto-commita — vira candidato para corte do Enio.

> Versão skill: v1.0 — 2026-06-02 (origem: pedido do Enio "precisamos de skill pra isso, /rules"). Self-improvement é o que faz o EGOS ser levado completo para vários ambientes.
