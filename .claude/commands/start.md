---
description: Ativação EGOS v6.0 — Kernel → Seleção de Projeto → Deep-dive Focado
---

# /start — Session Initialization v6.0

> **Princípio:** Não carregue tudo. Carregue o certo.
> **Fluxo:** KERNEL (sempre) → ESCOLHA DO PROJETO (interativo) → DEEP-DIVE (focado)

---

## FASE 1 — KERNEL (sempre, ~2min, antes de qualquer outra coisa)

Lê o que é imutável entre projetos: regras globais, saúde do sistema, última sessão.

### 1.1 Regras globais (T0-T4)

```bash
# Hierarquia de regras — ler nesta ordem exata
cat ~/.claude/CLAUDE.md | head -80          # T0-T2 críticos
cat ~/.claude/egos-rules/posture-autonomy.md 2>/dev/null | head -30  # postura
```

**Regras que NUNCA mudam (memorize, não releia):**
- T0: nunca force-push main, nunca log secrets, nunca publicar sem aprovação, nunca `git add -A` em agentes
- T1: read antes de edit, grep antes de referenciar função, verificar claims com evidência
- T2: Sonnet por padrão (Opus só para decisões críticas), nova sessão quando custo > $3

### 1.2 Saúde do sistema (paralelo — 30s)

```bash
# VPS + sites críticos
echo "=== VPS ===" && ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 "
  free -h | grep Mem | awk '{print \"RAM:\", \$3\"/\"\$2}';
  df -h / | tail -1 | awk '{print \"Disk:\", \$3\"/\"\$2, \"(\"\$5\")\"}';
  docker ps --format '{{.Names}}:{{.Status}}' | grep -v healthy | grep -v 'Up [0-9]' | head -5
" 2>/dev/null

# WhatsApp instâncias
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 '
APIKEY=$(grep EVOLUTION_API_KEY /opt/evolution-api/.env | cut -d= -f2)
curl -s http://localhost:8080/instance/fetchInstances -H "apikey: $APIKEY"
' 2>/dev/null | python3 -c "
import json,sys
try:
  d=json.load(sys.stdin)
  for i in d: print(f'WA {i[\"name\"]}: {i.get(\"connectionStatus\",\"?\")}')
except: pass
" 2>/dev/null

# Sites principais
for s in "https://hq.egos.ia.br" "https://intelink.ia.br" "https://guard.egos.ia.br/health"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$s" 2>/dev/null)
  echo "$code $s"
done
```

### 1.3 Última sessão (memory index)

```bash
head -15 ~/.claude/projects/-home-enio-egos/memory/MEMORY.md 2>/dev/null
```

### 1.4 Output da Fase 1

Apresentar ao usuário:

```
🧠 KERNEL ATIVO — [data]

⚡ Sistema:
  RAM: X/Y | Disk: X% | VPS: [ok/alerta]
  WA enio-personal: [open/connecting]
  Sites: hq ✅ | intelink ✅ | guard ✅

📝 Última sessão:
  [1 linha do MEMORY.md]

💰 Custo desta sessão: $X.XX (alarme em $2)
```

---

## FASE 2 — SELEÇÃO DO PROJETO (interativo)

**PARE AQUI e pergunte ao usuário.**

Não assuma o projeto. Não carregue docs de nenhum projeto ainda.

### 2.1 Listar projetos ativos

```bash
echo "=== Repos com atividade recente ==="
for repo in /home/enio/egos /home/enio/intelink /home/enio/egos-lab /home/enio/pixelart /home/enio/852; do
  if [ -d "$repo/.git" ]; then
    name=$(basename $repo)
    last=$(git -C "$repo" log --oneline -1 2>/dev/null | cut -c1-60)
    p0=$(grep -c "^\- \[ \].*\[P0\]" "$repo/TASKS.md" 2>/dev/null || echo 0)
    pending=$(grep -c "^\- \[ \]" "$repo/TASKS.md" 2>/dev/null || echo 0)
    echo "  $name | P0: $p0 | Pendentes: $pending | $last"
  fi
done

echo ""
echo "=== Sites live ==="
echo "  hq.egos.ia.br | lab.egos.ia.br | chatbot.egos.ia.br"
echo "  intelink.ia.br | pixelart.egos.ia.br | 852.egos.ia.br"
```

### 2.2 Pergunta ao usuário

```
Em qual projeto/área vamos trabalhar hoje?

  1. egos (kernel, regras, capacidades, Atlas)
  2. intelink (delegacia, Neo4j, agente policial)
  3. egos-lab (lab-kb, chatbot qualificador, WhatsApp agent)
  4. pixelart (bot PixelArt, Lucas)
  5. 852 (Tira-Voz)
  6. infra/VPS (segurança, containers, deploy)
  7. estratégia (LinkedIn, consulting kit, EGOS instalável)
  8. outro: [diga qual]
```

**Aguardar resposta antes de continuar.**

---

## FASE 3 — DEEP-DIVE DO PROJETO ESCOLHIDO

Após a escolha, carregar APENAS o contexto daquele projeto.

### Se escolheu: `egos`

```bash
cd /home/enio/egos
echo "=== README ===" && head -60 README.md
echo "=== P0 ===" && grep "^\- \[ \].*\[P0\]" TASKS.md
echo "=== P1 top 10 ===" && grep "^\- \[ \].*\[P1\]" TASKS.md | head -10
echo "=== Capabilities (seções) ===" && grep "^## §" docs/CAPABILITY_REGISTRY.md | tail -10
echo "=== Último handoff ===" && ls -t docs/_current_handoffs/*.md | head -1 | xargs head -25
echo "=== Last 5 commits ===" && git log --oneline -5
```

**Output:** briefing egos + recomendação de task

---

### Se escolheu: `intelink`

```bash
cd /home/enio/intelink
echo "=== README ===" && head -50 README.md
echo "=== P0 ===" && grep "^\- \[ \].*\[P0\]" TASKS.md | head -10
echo "=== Neo4j stats ==="
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 '
  curl -s -u neo4j:IntelinkReds2026! http://localhost:7475/db/neo4j/tx/commit \
    -H "Content-Type: application/json" \
    -d "{\"statements\":[{\"statement\":\"MATCH (p:Person) RETURN count(p) as pessoas, sum(coalesce(toInteger(p.reds_count),0)) as reds\"}]}"
' 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin); r=d['results'][0]['data'][0]['row']
print(f'Pessoas: {r[0]:,} | REDS: {r[1]:,}')
" 2>/dev/null
echo "=== Operações ativas ===" && grep "^\- \[ \].*OP-" TASKS.md | head -5
echo "=== Last 5 commits ===" && git log --oneline -5
echo ""
echo "⚠️ Máquina split: intelink pesado → delegacia (Windows). Aqui: deploy + fixes VPS."
echo "❓ O que avança a investigação hoje?"
```

---

### Se escolheu: `egos-lab` / chatbot / WhatsApp

```bash
cd /home/enio/egos-lab
echo "=== README ===" && head -40 README.md 2>/dev/null
echo "=== CHATBOT-Q tasks ===" && grep "CHATBOT-Q\|WA-AGENT" /home/enio/egos/TASKS.md
echo "=== Lab KB status ===" && ls /home/enio/egos-lab/apps/egos-lab-kb/ 2>/dev/null
echo "=== Qualification Protocol ===" && head -30 /home/enio/egos/docs/guides/CHATBOT_QUALIFICATION_PROTOCOL.md
echo "=== WA instances ===" 
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 '
  APIKEY=$(grep EVOLUTION_API_KEY /opt/evolution-api/.env | cut -d= -f2)
  curl -s http://localhost:8080/instance/fetchInstances -H "apikey: $APIKEY"
' 2>/dev/null | python3 -c "
import json,sys; [print(f'{i[\"name\"]}: {i.get(\"connectionStatus\")} | msgs={i.get(\"_count\",{}).get(\"Message\",0)}') for i in json.load(sys.stdin)]
" 2>/dev/null
```

---

### Se escolheu: `pixelart`

```bash
cd /home/enio/pixelart
echo "=== README ===" && head -40 README.md 2>/dev/null
echo "=== CBC Cards Pixel ===" && ls /home/enio/egos/docs/capabilities/CBC-PIXELART-*.md
echo "=== Pixel tasks no egos ===" && grep "BOT-\|IG-\|IMG-\|LUCAS\|PIXEL" /home/enio/egos/TASKS.md | grep "^\- \[ \]" | head -10
echo "=== WA pixelart-bot ===" 
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 '
  APIKEY=$(grep EVOLUTION_API_KEY /opt/evolution-api/.env | cut -d= -f2)
  curl -s http://localhost:8080/instance/connectionState/pixelart-bot -H "apikey: $APIKEY"
' 2>/dev/null
```

---

### Se escolheu: `infra/VPS`

```bash
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125 "
echo '=== Containers ===' && docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | head -30
echo '=== Swap ===' && free -h | grep Swap
echo '=== Portas expostas ==='
ss -tlnp | grep -v '127.0.0.1\|::1' | grep LISTEN | grep -v '0.0.0.53'
echo '=== Disk ===' && df -h / | tail -1
" 2>/dev/null

echo "=== Vulnerabilidades conhecidas ==="
echo "  🔴 PostgreSQL sinapi exposto (0.0.0.0:5432)"
echo "  🔴 Firewall rule ACCEPT all (rule 7)"
echo "  🟡 Ollama 11434 exposto (tem bearer, mas exposto)"
echo "  🟡 8090/3071/3070 diretos sem Caddy"
```

---

### Se escolheu: `estratégia`

```bash
echo "=== EGOS instalável — contexto atual ===" && head -30 /home/enio/egos/docs/strategy/EGOS_PROJECT_ATLAS.md
echo "=== Consulting kit tasks ===" && grep "CHATBOT-Q\|WA-AGENT\|create-egos\|consulting" /home/enio/egos/TASKS.md | grep "^\- \[ \]" | head -15
echo "=== LinkedIn post draft ===" && ls /home/enio/egos/docs/drafts/ | grep -i "linkedin\|post" | head -3
echo "=== CBC cards existentes ===" && ls /home/enio/egos/docs/capabilities/
```

---

## /refresh — Recarregar contexto mid-session

**Usar quando:** sessão longa, mudou de assunto, esqueceu onde estava.

```bash
# Roda durante a sessão (não reinicia)
REPO=$(git rev-parse --show-toplevel 2>/dev/null || echo "?")
echo "=== Repo atual: $REPO ==="
head -30 README.md 2>/dev/null
grep "^\- \[ \].*\[P0\]" TASKS.md 2>/dev/null | head -5
ls -t docs/_current_handoffs/*.md 2>/dev/null | head -1 | xargs head -15 2>/dev/null
git log --oneline -3 2>/dev/null
```

---

## Regras fundamentais do /start

1. **NUNCA pule a Fase 1** — kernel sempre, mesmo sessão rápida
2. **SEMPRE pergunte o projeto** — nunca assuma, nunca carregue tudo
3. **Fase 3 é seletiva** — só o projeto escolhido, só o que for necessário
4. **README desatualizado** (>7 dias + commits) → adicionar `README-UPDATE` ao P1
5. **Custo > $1.60** → mencionar `/compact` ou troca de modelo
6. **Custo > $3** → sugerir nova sessão

---

## Output final (após Fase 3)

```
✅ /start completo — [PROJETO] | [data]

🧠 Kernel: regras T0-T2 ativas | custo $X.XX
⚡ Sistema: [status resumido]
📋 [PROJETO]: P0=[N] | P1=[N] | Último commit: [hash msg]

🎯 Próxima ação recomendada:
  [task específica baseada no P0 do projeto]

❓ Confirma ou quer mudar o foco?
```

---

*v6.0 — 2026-05-04 | Kernel → Seleção → Deep-dive | Substitui v5.8*
