---
description: Disseminate kernel rules, governance, skills & tooling to the whole ecosystem (mirrors + leaf repos + VPS) via a safe, zero-downtime patch pipeline. Use when governance/skills/hooks changed, 3+ feat: commits unpropagated, or user asks to sync/patch the system.
---

# /disseminate v2 — Patch Propagation System (anéis + pipeline seguro + zero-downtime)

> **Princípio (corte Enio 2026-06-03):** quanto melhor a capacidade de aplicar patches importantes RÁPIDO no sistema inteiro SEM comprometer nada (downtime 0), melhor. Disseminação não é "copiar arquivo" — é **propagar uma mudança por anéis, com dry-run, verificação e rollback**.
> **SSOT do mapa de regras:** `docs/governance/RULE_SETS_INDEX.md` · **Mirrors:** `egos-autoheal.ts` · **Leaves:** `disseminate-propagator.ts` + `.egos-disseminate-manifest.json` + `~/.egos/sync.sh`.

---

## §1. ANÉIS (de onde a mudança parte e até onde vai)

| Anel | Alvo | Mecanismo | Risco |
|------|------|-----------|-------|
| **R0 — Kernel** | `egos/` (SSOT) | edição + commit + push | — (origem) |
| **R1 — Mirrors runtime** | `~/.egos`, `~/.claude` | `egos-autoheal.ts` (10 arquivos) + `~/.egos/sync.sh` (commands, .guarani) | baixo (cópia idempotente) |
| **R2 — Leaf repos** | manifest `existing_repos` (852, egos-lab, br-acc, forja, egos-self, smartbuscas, santiago, arch, …) | `disseminate-propagator.ts --all` (bloco PROPAGATE-RULES) + `sync.sh` (symlinks) | médio (commita em outros repos) |
| **R3 — VPS (serviços vivos)** | gateway, MCPs, storefronts (Docker/pm2) | `git pull` em `/opt/egos-git` → rebuild/reload **swap** | alto (produção — gated, zero-downtime) |

Regra: propaga **de dentro pra fora** (R0→R1→R2→R3). Nunca pula verificação entre anéis.

## §2. CLASSES DE ARTEFATO (o que se copia vs o que se ADAPTA)

| Classe | Exemplos | Como propaga |
|--------|----------|--------------|
| **Universal (copia verbatim)** | bloco de regras (`PROPAGATE-RULES`), agent defs `.claude/agents/`, standards de governança | propagator/sync — idêntico em todo lugar |
| **Mirror (kernel↔home)** | skills `/start` `/end` `/disseminate`, hooks, `.guarani/**` | autoheal + sync.sh |
| **Per-repo (ADAPTA, não copia)** | README (conteúdo), config específica | **metaprompt copy-adapt** (`docs/metaprompt-generator/`) — NUNCA cópia cega; adapta nomes/caminhos/integrações |
| **Frozen (nunca auto)** | `.husky/pre-commit`, `.guarani` core | só kernel + HITL/`EGOS_FROZEN_OVERRIDE` |

> **Anti-cópia-cega:** artefato per-repo viaja como *instrução de adaptação*, não como arquivo bruto. README padrão = `docs/governance/README_PADRAO_OURO.md` (o STANDARD propaga; o conteúdo cada repo adapta).

## §3. PIPELINE SEGURO (a capacidade de patch rápido sem comprometer)

```bash
cd ~/egos
# 1. SCAN — o que mudou + o que está drifted
git log --oneline "$(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~10)"..HEAD 2>/dev/null | head
bun scripts/egos-autoheal.ts --check 2>/dev/null | tail -1      # drift dos mirrors
bun scripts/disseminate-propagator.ts --all --dry 2>&1 | tail -3 # escopo nos leaves

# 2. DRY-RUN (preview, zero escrita) — já no scan acima (--dry / --check)

# 3. APPLY (idempotente, de dentro pra fora)
bun scripts/egos-autoheal.ts 2>/dev/null | tail -1              # R1 mirrors
bash scripts/governance-sync.sh --exec                          # R1 kernel→~/.egos
bun scripts/disseminate-propagator.ts --all                    # R2 leaves (bloco de regras) — COMMITA local
bash ~/.egos/sync.sh                                            # R2 symlinks + commands
# ⚠️ GAP CRÍTICO (achado 2026-06-03): o propagator COMMITA nos leaves mas NÃO PUSHA.
# "Disseminado" ≠ "commitado local" — só está disseminado quando está no GitHub.
# PUSH OBRIGATÓRIO dos leaves que ficaram ahead.
# Lista canônica lida de agents/registry/leaf-repos.json (MYCELIUM-006 — não editar aqui):
LEAF_REPOS_JSON=~/egos/agents/registry/leaf-repos.json
for d in $(jq -r '.leaf_repos[].path' "$LEAF_REPOS_JSON"); do
  [ -d "$d/.git" ] || continue
  ahead=$(git -C "$d" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  [ "$ahead" -gt 0 ] && echo "push $(basename $d) ($ahead ahead)" && git -C "$d" push origin "$(git -C "$d" branch --show-current)" 2>&1 | grep -E "\->|rejected|error" | head -1
done

# 4. VERIFY (drift=0 + saúde)
bun scripts/egos-autoheal.ts --check 2>/dev/null | tail -1      # drift==0
bash scripts/governance-sync.sh --check
bun scripts/runtime-smoke.ts --quiet 2>&1 | head -1            # 0 fail
bun run typecheck 2>&1 | grep -c "error TS"                    # 0 (se tocou código)

# 5. ROLLBACK (se VERIFY falhar)
#   - leaf repo: git -C <repo> revert --no-edit HEAD  (mudança é path-scoped/idempotente)
#   - mirror: re-rodar autoheal (re-copia do kernel)
#   - VPS: ver §4 (backup+swap)
```

**Gate:** só avança de APPLY p/ próximo anel se o VERIFY do anterior passou. Drift>0 após apply → investigar antes de seguir.

## §4. R3 VPS — zero-downtime (serviços vivos)

> Só quando a mudança precisa chegar na produção (gateway, MCPs). Red Zone — gated.
```bash
SSH="ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125"
# backup antes (rollback): $SSH "cp <file> <file>.bak-$(date +%s)"  + tag da imagem
$SSH "cd /opt/egos-git && git pull --ff-only origin main"        # traz o patch
# copiar arquivo(s) p/ o build-context não-git (/opt/<svc>), depois SWAP:
# Docker: docker compose build <svc> && docker compose up -d <svc>  (recreate atômico)
# pm2:    pm2 reload <svc> --update-env                            (reload sem downtime)
# smoke:  curl health + docker logs/pm2 logs (sem 409/erro)
```
Nunca `restart` destrutivo sem `build`/`reload`. Backup + smoke obrigatórios. SSOT deploy: `docs/governance/PRODUCTION_DEPLOY_RULES.md` (INC-PROD-001).

---

## §5. Conhecimento + estado (fases de fechamento — preserva v1)

- **HARVEST.md** — novo pattern/gotcha/decisão da sessão (formato Problem/Solution/Rule).
- **CAPABILITY_REGISTRY** — nova capability (Status+Evidence+Owner; R-CAP-001 ciclo de vida).
- **TASKS.md** — marcar [x], adicionar descobertas, manter < limite.
- **Memory** — `~/.claude/projects/-home-enio-egos/memory/` + índice.
- **NotebookLM** — doc canônico mudou → re-sync ADD-only (HITL deleção).
- **Social** (só milestone): Telegram @ethikin · X @anoineim.

## §6. Checklist de saída

- [ ] SCAN feito (git diff + autoheal --check + propagator --dry)
- [ ] APPLY por anel (R1→R2[→R3 se gated])
- [ ] VERIFY: drift=0 · governance:check ok · smoke 0-fail · typecheck 0-erro
- [ ] Per-repo/README via adapt (não cópia cega)
- [ ] HARVEST/CAPABILITY/TASKS/Memory atualizados
- [ ] Rollback pronto (path-scoped) se algo falhar

## §7. Regras
- Frozen zones (`.husky/pre-commit`, `.guarani` core) nunca auto — só kernel + HITL.
- `egos-autoheal` SEMPRE antes de propagar (senão dissemina drift).
- Conhecimento vai pro HARVEST.md do KERNEL mesmo se descoberto em leaf.
- Governança é symlinkada nos leaves (não copiada) — não editar lá.
- Drift>0 pós-sync = bloqueador: investigar antes de encerrar.

*v2 2026-06-03 — modelo de anéis + pipeline seguro (scan→dry→apply→verify→rollback) + zero-downtime VPS + classes de artefato (adapt-not-copy liga ao metaprompt-generator). v1 era checklist; v2 é sistema de patch.*
