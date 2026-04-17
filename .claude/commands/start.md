---
description: Ativação canônica EGOS — validação de integrações + governança + plano de execução
---

# Workflow: /start (Full Integration Validation + Kernel Activation)

## Objetivo
Ativar o kernel EGOS validando TODAS as integrações do ambiente, testando cada uma, consertando o que puder e criando tasks para o que for complexo. NUNCA iniciar trabalho sem verificar o estado real do ecossistema.

## Ordem obrigatória (9 fases)

### 0. INTEGRATIONS (OBRIGATÓRIO — teste tudo)

**REGRA:** Toda ativação DEVE testar e reportar o estado de cada integração.

Verificar e testar (em paralelo quando possível):

| Integração | Teste | Como |
|-----------|-------|------|
| **MCP Servers** | Listar todos conectados | Verificar quais MCP servers estão ativos na sessão |
| **Guard Brasil API** | `curl -s https://guard.egos.ia.br/health` | Esperar `{"status":"healthy"}` |
| **ARCH API** | `curl -s https://arch.egos.ia.br/api/health` | Se ativo (pode estar pausado) |
| **Telegram Bot** | Verificar TELEGRAM_BOT_TOKEN em .env | Enviar /getMe via API |
| **HuggingFace** | `python3 -c "from huggingface_hub import HfApi; print(HfApi().whoami())"` | Login status |
| **Supabase** | Verificar SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY em .env | MCP test query |
| **VPS Hetzner** | `ssh hetzner 'uptime && docker ps --format "table {{.Names}}\t{{.Status}}"'` | Containers up |
| **Docker local** | `docker ps` | Se aplicável |
| **Git remotes** | `git remote -v` em egos + egos-lab | Push access |
| **NPM registry** | Verificar @egosbr/guard-brasil publicado | `npm view @egosbr/guard-brasil version` |
| **Gitleaks** | `which gitleaks` | Deve estar instalado |
| **Bun** | `bun --version` | Versão atual |
| **Agent registry** | `bun agent:lint` (egos-lab) | 0 errors |
| **Pre-commit hooks** | Verificar .husky/pre-commit existe | File intelligence ativo |
| **Env vars** | Contar keys em .env (egos + egos-lab) | Mínimo esperado: 6 |

**Para cada integração:**
- ✅ Funcionando → reportar versão/status
- ⚠️ Degradado → tentar consertar, reportar
- ❌ Falha → criar task, reportar blocker
- 🔇 Pausado → marcar como intencionalmente parado (ex: ARCH)

### 0.5 CONTEXT RECOVERY (auto-carrega estado da última sessão)

**OBRIGATÓRIO** — garante que toda nova sessão herda contexto completo:

1. **Memory index:** Ler primeiras 30 linhas de `~/.claude/projects/-home-enio-egos/memory/MEMORY.md` — mostra última sessão + sprint atual
2. **Latest handoff:** `ls -t docs/_current_handoffs/*.md 2>/dev/null | head -1` → ler primeiras 40 linhas (accomplished/blockers/next)
3. **Latest job reports:** `ls -t docs/jobs/*.md 2>/dev/null | head -3` → ler primeiras 5 linhas de cada (CCR outputs)
4. **Context signals (SKILLS-002):** Ler últimas 10 linhas de `~/.egos/context-signals.jsonl` — cada linha é `{ts, repo, signal, detail}`. Se `signal=governance_change` → propor `/sync`. Se `signal=hook_change` → verificar hooks. Agrupa por repo para mostrar atividade recente.
   ```bash
   tail -10 ~/.egos/context-signals.jsonl 2>/dev/null | python3 -c "
   import sys, json
   signals = [json.loads(l) for l in sys.stdin if l.strip()]
   repos = {}
   for s in signals:
       repos.setdefault(s['repo'], []).append(s['signal'])
   for r, sigs in repos.items():
       print(f'  {r}: {', '.join(sigs)}')" 2>/dev/null || true
   ```
5. **Resumo no output:** Incluir seção `## 🧠 Contexto Recuperado` com: última sessão ID, tasks concluídas, blockers ativos, repos ativos (from context signals)

**Se MEMORY.md menciona theater/cleanup pendente:** flaggar como P0 na seção Propostas.

### 1. INTAKE
- Ler: `AGENTS.md`, `TASKS.md`, `.guarani/RULES_INDEX.md`, `docs/SYSTEM_MAP.md`
- Ler: últimos 5 commits (`git log --oneline -5`) em egos + egos-lab
- Confirmar data da sessão e registrar no resumo

### 2. CHALLENGE
- Verificar contradições entre pedido e frozen zones
- Se houver ambiguidade sobre escopo, assumir postura conservadora
- Ler memory SSOT para contexto de sessões anteriores
- **Gem Hunter:** Ler último relatório em `egos-lab/docs/gem-hunter/gems-*.md` (mais recente). Flaggar CRITICAL como P0. Config SSOT: `egos/docs/gem-hunter/SSOT.md`

### 3. PLAN
- Definir onde cada artefato deve viver:
  - **Comandos `/` e operação**: `.agents/workflows/`
  - **Prioridades e fases**: `TASKS.md`
  - **Mapa arquitetural**: `docs/SYSTEM_MAP.md`
  - **Regras**: `.guarani/RULES_INDEX.md`

### 4. GATE
- `bun run governance:check` antes de mudanças estruturais
- `bun run doctor --json` se disponível (exit 2 = block)
- Nunca editar frozen zones sem pedido explícito

### 5. EXECUTE
- Aplicar mudanças de documentação/planejamento em SSOT
- Iniciar por contrato/interface, depois migração física

### 6. VERIFY
- `bun run agent:lint`
- `bun run typecheck` (quando houver mudança TS)
- `bash scripts/file-intelligence.sh` (se arquivos staged)

### 7. LEARN
- Registrar no retorno final:
  - O que foi alterado, onde, próximos passos (P0/P1/P2)
  - Estado das integrações (tabela resumo)

### 8. DISSEMINATE (se /disseminate estiver disponível)
- Extrair insights da sessão para HARVEST.md
- Atualizar ECOSYSTEM_REGISTRY.md se houve mudança em agents

## Formato de saída obrigatório

```
## 🔌 Estado das Integrações
| Integração | Status | Detalhe |
|-----------|--------|---------|
| Guard Brasil | ✅ | healthy, 4ms |
| Telegram | ✅ | @EGOSin_bot |
| VPS Hetzner | ✅ | 13 containers |
| ... | ... | ... |

## 📊 Governança
- Drift: X issues
- TASKS.md: Y/500 linhas
- Último commit: <hash> <msg>

## 🧠 Contexto Recuperado
- Última sessão: <P_ID> — <resumo 1 linha>
- Blockers ativos: <lista ou "nenhum">
- Theater pendente: <lista ou "limpo">

## ✅ Fatos Verificados
- <arquivo/comando> → <resultado observado>

## 🔮 Inferências
- <hipótese> (baseada em: <fato>)

## 📋 Propostas
- P0: <ação> (dono: <quem>)
- P1: <ação>
- P2: <ação>

✅ /start concluído — Kernel ativo | Integrações: X/Y OK
```

## Regras fundamentais
- Não afirmar leitura de "todos os repositórios" sem evidência
- Sempre separar: fatos verificados, inferências, propostas
- Se integração falhar, CRIAR TASK (não ignorar)
- NUNCA pular a fase INTEGRATIONS — é obrigatória em toda ativação

## 🔄 Session Init (T2.2 — INC-006 Sprint 1)
**SEMPRE executar no início de /start (em paralelo):**
```bash
bun /home/enio/egos/scripts/session-init.ts --reset
bash /home/enio/egos/scripts/sync-review-queue.sh
```
- `session-init --reset`: reinicia contadores da sessão
- `sync-review-queue.sh`: puxa findings do VPS Hermes reviewer

**Se output contiver `[CHECKPOINT-NEEDED]`:** reportar ao usuário antes de continuar.

**Se output contiver `CRITICAL=N` onde N>0:** reportar imediatamente com detalhes:
```bash
cat ~/.egos/review-queue.jsonl | python3 -c "
import sys,json
for l in sys.stdin:
    e=json.loads(l)
    if e.get('severity') in ('CRITICAL','HIGH'):
        print(f\"[{e['severity']}] {e['commit'][:7]} {e['subject']}\")
        for f in e.get('findings',[]): print(f'  → {f}')
"
```

**Ao fim de /start, verificar estado:**
```bash
bun /home/enio/egos/scripts/session-init.ts --status
```
