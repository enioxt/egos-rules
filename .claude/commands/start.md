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

### 0.4 README + DOCS CORE (novo — 2026-05-04)

**OBRIGATÓRIO para qualquer sessão em repo ativo** — READMEs são a fonte de verdade do estado do projeto.

```bash
# 1. README do repo atual
head -80 README.md 2>/dev/null

# 2. Documentação SSOT crítica (ler pelo menos os títulos)
echo "=== CAPABILITY_REGISTRY (seções) ===" && grep "^## " docs/CAPABILITY_REGISTRY.md 2>/dev/null | head -20
echo "=== TASKS P0 ===" && grep "^\- \[ \].*\[P0\]" TASKS.md 2>/dev/null | head -10

# 3. Docs de guias ativos (ler se o projeto tem)
ls docs/guides/ 2>/dev/null | head -10

# 4. Handoffs e estratégia
ls docs/strategy/ 2>/dev/null | head -5
```

**Regra:** Se o README não foi atualizado nos últimos 7 dias e houve commits → adicionar `README-UPDATE` ao P1 da sessão.

**Skill `/refresh`** — quando o usuário pede para recarregar contexto sem reiniciar sessão:
```bash
# Roda durante a sessão, não no início
cat README.md | head -50
grep "^\- \[ \].*\[P0\]" TASKS.md | head -10
ls -t docs/_current_handoffs/*.md | head -1 | xargs head -20
```

---

### 0.5 CONTEXT RECOVERY (auto-carrega estado da última sessão)

**OBRIGATÓRIO** — garante que toda nova sessão herda contexto completo:

1. **Memory index:** Ler primeiras 30 linhas de `~/.claude/projects/-home-enio-egos/memory/MEMORY.md` — mostra última sessão + sprint atual
2. **Latest handoff:** `ls -t docs/_current_handoffs/*.md 2>/dev/null | head -1` → ler primeiras 40 linhas (accomplished/blockers/next)
3. **Latest job reports:** `ls -t docs/jobs/*.md 2>/dev/null | head -3` → ler primeiras 5 linhas de cada (CCR outputs)
4. **Context signals + skill suggestions (SKILL-AUTO-001):** Rodar o skill-resolver para obter sugestões baseadas em sinais recentes + git:
   ```bash
   bun /home/enio/egos/scripts/skill-resolver.ts 2>/dev/null || true
   ```
   Cada linha `[SKILL-SUGGEST] /skillname PRIORITY — reason` indica uma skill a invocar. Invocar as de CRITICAL/ALWAYS imediatamente; HIGH/MEDIUM apresentar ao usuário.
   Para matching com o primeiro prompt do usuário:
   ```bash
   bun /home/enio/egos/scripts/skill-resolver.ts --prompt="<primeiro prompt>" 2>/dev/null || true
   ```
5. **Context signals raw (debug):** Agrupar por repo para mostrar atividade recente:
   ```bash
   tail -10 ~/.egos/context-signals.jsonl 2>/dev/null | python3 -c "
   import sys, json
   signals = [json.loads(l) for l in sys.stdin if l.strip()]
   repos = {}
   for s in signals:
       repos.setdefault(s['repo'], []).append(s['signal'])
   for r, sigs in repos.items():
       print(f'  {r}: {\", \".join(sigs)}')" 2>/dev/null || true
   ```
6. **Resumo no output:** Incluir seção `## 🧠 Contexto Recuperado` com: última sessão ID, tasks concluídas, blockers ativos, repos ativos (from context signals), skills sugeridas

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

### 7.5 CAPABILITY SCAN (se in egos repo)
- Rodar `bun capability:scan` e reportar candidatos não registrados (★)
- Se houver ★ não registrados: sugerir atualização do CAPABILITY_REGISTRY.md como próximo passo
- Não bloqueia sessão — informativo apenas

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

## 🚔 INTELINK STATUS (nova fase obrigatória — 2026-05-03)

Enio trabalha no Setor de Inteligência da delegacia. O Intelink é o SSOT operacional.
**Toda sessão deve verificar o estado do Intelink ANTES de qualquer outra coisa.**

```bash
# 1. Site up?
curl -s -o /dev/null -w "%{http_code}" https://intelink.ia.br/ && echo ""

# 2. Neo4j — quantos dados temos?
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 'curl -s -u neo4j:IntelinkReds2026! http://localhost:7475/db/neo4j/tx/commit -H "Content-Type: application/json" -d "{\"statements\":[{\"statement\":\"MATCH (p:Person) RETURN count(p) as pessoas, sum(coalesce(toInteger(p.reds_count),0)) as total_reds\"}]}"' 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); r=d['results'][0]['data'][0]['row']; print(f'Pessoas: {r[0]:,} | REDS: {r[1]:,}')" 2>/dev/null

# 3. Evolution API (WhatsApp)
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 'APIKEY=$(grep EVOLUTION_API_KEY /opt/evolution-api/.env | cut -d= -f2); curl -s http://localhost:8080/instance/fetchInstances -H "apikey: $APIKEY"' 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); [print(f'WA: {i[\"name\"]} — {i[\"connectionStatus\"]}') for i in d]" 2>/dev/null

# 4. Última ingestão BISP
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 "ls -lt /tmp/bisp-xlsx/*.xlsx 2>/dev/null | head -3 || echo 'Sem XLSX pendente'" 2>/dev/null
```

**Incluir no briefing:**
- Intelink HTTP status
- Contagem Neo4j (pessoas / registros REDS)
- WhatsApp: instância conectada? (sim/não)
- Operações ativas (se aplicável)

**Pergunta obrigatória ao usuário no final do /start:**
> "O que avança a investigação hoje?" (Single Pursuit — delegacia/Lídia até 2026-05-12)

## 🧠 Nova forma de agir (2026-05-03)

Após meses de construção, o Intelink passou a ser usado operacionalmente por investigadores.
Isso muda como o agente deve se comportar:

1. **INTELINK = SSOT das investigações** — toda referência a dados de pessoas, crimes, veículos deve confirmar no Intelink antes de afirmar qualquer coisa.
2. **Tool Registry ativo** — quando uma pessoa tem dados faltantes (sem endereço, sem telefone, sem foto), o agente deve sugerir a ferramenta correta via `lib/config/tool-registry.ts`.
3. **BISP pipeline** — XLSX do BISP → `bun scripts/ingest-xlsx-reds.ts --file <arquivo>` → Neo4j. Dedup por número REDS normalizado (remove hífens). 33REGIAO1.xlsx (61k linhas) ainda pendente.
4. **WhatsApp** — Evolution API em `127.0.0.1:8080` no VPS. Instância `forja-notifications` (reconectar se `connectionStatus != open`). Para nova instância do número do Enio: criar via API e escanear QR.
5. **Privacidade é crítica** — CPF, RG, nome completo, histórico policial são dados sensíveis. NUNCA logar em arquivos públicos, commits, ou output de CI. Guard Brasil audita antes de qualquer publicação.
6. **Máquina split** — Linux (esta máquina) = kernel EGOS + VPS + intelink deploy. Windows = LLM local (Ollama) + NER + ETL pesado. Não misturar.
7. **Operação 100kg ativa** — tarefas `OP-100KG-*` são urgentes e têm prioridade sobre refatoração técnica.

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
- `session-init --reset`: reinicia contadores da sessão + emite `[SKILL-SUGGEST]` via skill-resolver (SKILL-AUTO-001)
- `sync-review-queue.sh`: puxa findings do VPS Hermes reviewer

**Se output contiver `[SKILL-SUGGEST]`:** coletar todas as linhas e apresentar ao usuário como ações recomendadas. CRITICAL/ALWAYS = invocar imediatamente; HIGH = recomendar fortemente; MEDIUM/LOW = mencionar.

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
