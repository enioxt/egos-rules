# REPO_MESH_STATUS.md — EGOS Ecosystem Snapshot

## Estado em 2026-03-11

| Repo | Tipo | Origin | Governança | Hook | Observação principal |
|------|------|--------|------------|------|----------------------|
| `852` | Next.js app institucional | `git@github.com:enioxt/852.git` | `AGENTS` + `TASKS` + `.windsurfrules` + `.egos` + `.guarani` + workflows | SSOT direto | referência atual para chat institucional, relatórios, dashboard e issues |
| `br-acc` | plataforma de inteligência | `git@github.com:enioxt/EGOS-Inteligencia.git` | completa | wrapper SSOT + legado | mantém checks avançados próprios |
| `carteira-livre` | app standalone | `git@github.com:enioxt/carteira-livre.git` | completa | SSOT direto | tinha lacuna de hook, já corrigida |
| `egos-lab` | monorepo lab | `git@github.com:enioxt/egos-lab.git` | completa | wrapper SSOT + legado | continua sendo fonte central de governança compartilhada |
| `forja` | SaaS privado | `git@github.com:enioxt/FORJA.git` | completa | SSOT direto | hook mínimo foi substituído por padrão universal |
| `policia` | workspace investigativo privado | `https://github.com/enioxt/DHPP.git` | bootstrap parcial | SSOT direto | recebeu `AGENTS`, `TASKS`, `SYSTEM_MAP`, workflow Windsurf e `.egos`; ainda sem `.guarani` |
| `egos-self` | CLI + Android app | `git@github.com:enioxt/egos-self.git` | completa | SSOT direto | hook mínimo foi substituído por padrão universal |

## Critérios de governança considerados

- `AGENTS.md`
- `TASKS.md`
- `.windsurfrules`
- `.egos`
- `.guarani`
- `.windsurf/workflows`
- `.git/hooks/pre-commit`

## Estados de hook

- **SSOT direto**: symlink para `/home/enio/.egos/hooks/pre-commit`
- **wrapper SSOT + legado**: roda primeiro o SSOT e depois o script específico do repo

## Próximos passos recomendados

1. Decidir se o repo `policia` terá `.guarani` local ou consumirá apenas `.windsurfrules` + `.egos`
2. Absorver no SSOT universal mais checks genéricos de `br-acc` e `egos-lab`, reduzindo divergência futura
3. Versionar formalmente a pasta `hooks/` no repositório-canônico da governança compartilhada
4. Criar rotina periódica para revalidar `AGENTS`/`TASKS`/hooks em todo o mesh
