# EGOS Hooks — SSOT

## Fonte canônica

- `pre-commit` — hook universal do ecossistema EGOS
- `install-universal-hook.sh` — instalador em lote ou por repo

## Objetivo

Centralizar os checks mínimos obrigatórios do ecossistema em um único ponto:

- governança (`egos-gov check`)
- secrets / credenciais
- arquivos grandes
- qualidade TypeScript básica
- sintaxe Python
- lembrete de `TASKS.md`
- detecção básica de PII

## Estratégia de adoção

### Repos padrão

Use symlink direto:

```bash
ln -sf /home/enio/.egos/hooks/pre-commit .git/hooks/pre-commit
```

### Repos com hook legado robusto

Antes de substituir, comparar lógica local com o hook universal.

Situação atual:

- `br-acc` — hook robusto próprio
- `egos-lab` — hook robusto próprio
- `forja` — hook mínimo de governança
- `egos-self` — hook mínimo de governança
- `carteira-livre` — sem hook
- `policia` — sem hook

## Regra operacional

- Se o repo não tem hook ou tem hook mínimo, instalar o universal imediatamente.
- Se o repo tem hook robusto específico, migrar com wrapper ou convergência funcional, não sobrescrever às cegas.

## Instalação em lote

```bash
/home/enio/.egos/hooks/install-universal-hook.sh
```

## Instalação por repo

```bash
/home/enio/.egos/hooks/install-universal-hook.sh /home/enio/carteira-livre /home/enio/forja
```
