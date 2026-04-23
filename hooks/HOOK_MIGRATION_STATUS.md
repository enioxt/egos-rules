# Hook Migration Status — EGOS Mesh

Fonte canônica versionada: `/home/enio/egos/scripts/egos-home/hooks/`
Mirror consumido pelos repos: `/home/enio/.egos/hooks/`

## Estado em 2026-03-11

| Repo | AGENTS | TASKS | .windsurfrules | .egos | .guarani | workflows | hook atual | dirty files | ação recomendada |
|------|--------|-------|----------------|-------|----------|-----------|------------|-------------|------------------|
| 852 | yes | yes | yes | yes | yes | yes | symlink universal | 0 | referência do SSOT |
| br-acc | yes | yes | yes | yes | yes | yes | wrapper SSOT + legado | 0 | concluído |
| carteira-livre | yes | yes | yes | yes | yes | yes | symlink universal | 45 | concluído |
| egos-lab | yes | yes | yes | yes | yes | yes | wrapper SSOT + legado | 2 | concluído |
| forja | yes | yes | yes | yes | yes | yes | symlink universal | 0 | concluído |
| policia | yes | yes | yes | yes | no | yes* | symlink universal | 13 | bootstrap parcial concluído |
| egos-self | yes | yes | yes | yes | yes | yes | symlink universal | 0 | concluído |

* O repo `policia` recebeu `.windsurf/workflows/ovm.md` e link `.egos` nesta sessão; `.guarani` ainda não existe.

## Observações

### Hooks robustos migrados com wrapper conservador

* `br-acc/.git/hooks/pre-commit`
  * segurança ampliada
  * checks de tamanho
  * checks Python
  * checks TS
  * awareness de sync e contexto
  * agora roda **após** o hook universal do SSOT

* `egos-lab/.git/hooks/pre-commit`
  * segurança focada em secrets
  * variações específicas do repo
  * agora roda **após** o hook universal do SSOT

### Hooks mínimos / inexistentes resolvidos

* `forja` e `egos-self` tinham apenas checagem mínima de governança
* `carteira-livre` e `policia` estavam sem hook instalado
* todos esses repos agora apontam para o hook universal em `/home/enio/.egos/hooks/pre-commit`

## Estratégia de migração

### Fase 1 — imediata

* instalar hook universal onde não há hook ou ele é mínimo
* manter registro de backups locais do hook anterior
* status: **concluída**

### Fase 2 — convergência controlada

* comparar `br-acc` e `egos-lab` com o universal
* decidir entre:
  * wrapper (universal + legado)
  * absorção de checks específicos no SSOT
  * split entre core + extensões por repo
* status: **wrapper aplicado**, absorção parcial já feita no SSOT (`governança`, `personal files`, `setInterval sem cleanup`)

## Comando canônico

```bash
/home/enio/.egos/hooks/install-universal-hook.sh
```
