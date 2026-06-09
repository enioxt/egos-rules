---
name: purge
description: Limpa dado sensível conhecido (PII de pessoas/operações) de QUALQUER sistema/repo antes de publicar — via motor packages/pii-purge. Monta dict (HITL), dry-run, revisão, apply (HITL), verify + sweep independente. Red Zone (dado real) → corte do Enio antes de --apply e antes de qualquer push.
---

# /purge — Limpeza de dado sensível em massa (motor pii-purge)

> **Capacidade system-wide:** serve para limpar QUALQUER repo/sistema, não só o intelink.
> **SSOT do motor:** `packages/pii-purge/README.md` · **Registry:** CAPABILITY_REGISTRY §114
> **Gate:** `scripts/security/purge-gate.sh` (R-SEC-005)

## Quando usar
Antes de tornar público / compartilhar / fazer source_add / deploy de um repo que já teve dado real (PII de pessoa, nome/CPF/placa/telefone de operação, nº de inquérito). Ou quando o Enio pedir "limpa X".

## Regras duras (T0/T1)
- **Red Zone:** dado real de investigação/PII → o `--apply` e qualquer `push` exigem **corte do Enio** (HITL). Dry-run + relatório posso fazer sozinho.
- **O entity-dict NUNCA é versionado** (R-SEC-002): vive em `~/.egos-purge-entities.json` (ou `$EGOS_PURGE_ENTITY_DICT`), gitignored/local. Apagar ou cifrar após uso.
- **Nunca reproduzir o valor real** em commit, task, handoff ou log (T0 §3) — só tipo + localização.
- **O `verifyCleanExit` do motor NÃO basta** (INC-006): sempre rodar o sweep independente.

## Fluxo (passo a passo)

### 1. Montar o entity-dict (HITL)
Identificar as entidades a remover (do próprio repo sujo ou do Enio). Escrever em `~/.egos-purge-entities.json` (chmod 600), fora de qualquer repo:
```json
{ "entities": [
  { "id": "pessoa-001", "names": ["NOME COMPLETO"], "cpfs": ["..."], "phones": ["..."], "plates": ["..."], "reds": ["nome de grupo/operação"] }
]}
```
> Dica: nomes/identificadores **distintivos** (nome completo, CPF, placa). Evitar nome comum solo (over-match). Texto (grupo/operação) vai em `names` ou `reds` — o safety-net literal pega de qualquer jeito.

### 2. DRY-RUN (posso sozinho)
```bash
bun packages/pii-purge/src/cli.ts --entity-dict ~/.egos-purge-entities.json --target <repo> --json
```
Apresentar o relatório (file:line + tipo + entidade, **nunca o valor**). Confirmar 0 `REVIEW_REQUIRED` ou tratá-los (nomes fuzzy → revisão humana).

### 3. APPLY (corte do Enio)
```bash
bun packages/pii-purge/src/cli.ts --entity-dict ~/.egos-purge-entities.json --target <repo> --apply --json
```
Mascara com token coerente `[PESSOA_N]` + grava audit hash-chained.

### 4. VERIFY independente (obrigatório — não confiar só no verifyCleanExit)
```bash
# a) o gate do motor
bash scripts/security/purge-gate.sh <repo> ~/.egos-purge-entities.json
# b) sweep manual exaustivo: tokens conhecidos + corrupção + genérico
grep -rniE '<token1>|<token2>|\[PESSOA_[0-9]+\]_' --include='*.md' --include='*.ts' --include='*.py' --include='*.sql' <repo> | grep -v node_modules
grep -rnE '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}' <repo>/... | grep -v '<sintéticos conhecidos>'
```
Spot-check os arquivos de CÓDIGO mascarados (sintaxe sã? sem `[PESSOA_N]_` corrompido?).

### 5. Histórico (se o dado já foi commitado)
Limpar só o HEAD **não basta** — `git log -S` ainda revela. Para repo jovem: backup branch + orphan squash + force-push (corte do Enio). Para repo grande: `git filter-repo`. GitHub retém o SHA antigo até GC → follow-up GitHub Support (vide INC-PII-001).

### 6. Cleanup
Apagar `~/.egos-purge-entities.json`. O audit log (`~/pii-purge-audit-*.jsonl`) só tem hashes — manter para proveniência.

## Limitações conhecidas (honestidade)
- Nomes fuzzy = `REVIEW_REQUIRED` (nunca auto-purgados — protege evidência).
- O motor acha só o que está no dict — dict incompleto = leftover. Por isso o sweep independente.
- Sem DB rodando, seeds/migrations limpos ficam `[CONCEPT]` até smoke.
