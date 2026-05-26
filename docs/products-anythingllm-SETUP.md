# AnythingLLM — Setup EGOS

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Status:** local dev (não produção)
> **Decisão:** stack base para KB cliente (Espiral de Escuta v3.1)
> **Owner ops:** Enio + Claude Code (operação automatizada via API+SQL)

---

## §1 — Por que AnythingLLM

Validado em sessão 2026-05-20 após pesquisa profunda (premortem + market + LGPD).
Elimina ~80% do build de "KB local" — restante coberto por Hermes-EGOS + skills EGOS existentes (`kbs-discovery`, `client-onboard`, `central-egos`).

**Alternativas avaliadas e descartadas:**
- Open WebUI: UX melhor mas RAG mais simples
- LibreChat: foco em chat, não KB enterprise
- Onyx (ex-Danswer): too complex para SMB
- Custom EGOS: 40h+ a mais, sem ganho frente a OSS maduro

---

## §2 — Estado atual (local dev)

| Item | Valor |
|---|---|
| Container Docker | `mintplexlabs/anythingllm:latest` |
| Imagem digest | `sha256:2d72b54951db807c1ddb5eaa1bd2c461ba1377d1c947c30d59795249f4a940cc` |
| Versão release | unverified: v1.12.1 |
| Porta | 3001 |
| URL local | http://localhost:3001 |
| Storage host | `/home/enio/anythingllm/storage/` |
| DB SQLite | `/home/enio/anythingllm/storage/anythingllm.db` |
| API key (gitignored) | `/home/enio/anythingllm/.api-key` |
| Restart policy | `unless-stopped` |
| Onboarding | ✅ completo |
| Workspaces | 4 (Meu Workspace + catalogo-g-pecas + atendimento-g-pecas + suporte-tecnico-g-pecas) |
| LLM | OpenRouter → google/gemini-2.0-flash-001 |
| Embedding | native (LanceDB built-in) |
| Vector DB | LanceDB |
| Modo | single-user (multi-user OFF — ativar antes de cliente) |
| API key master | gerada (chmod 600, gitignored) |

---

## §3 — Comandos operacionais

### Container lifecycle
```bash
# Status
docker ps --filter name=anythingllm

# Logs
docker logs -f anythingllm

# Restart
docker restart anythingllm

# Stop / Start
docker stop anythingllm
docker start anythingllm

# Atualizar versão (NÃO ROTINEIRO — testar primeiro)
docker pull mintplexlabs/anythingllm:latest
docker rm -f anythingllm
# rerodar comando de §4

# Apagar TUDO (CUIDADO — perde dados)
docker rm -f anythingllm && rm -rf /home/enio/anythingllm
```

### Launcher GUI
- App entry: `~/.local/share/applications/anythingllm.desktop`
- Script: `~/.local/bin/anythingllm-launcher` (sobe container + abre Chrome --app)
- Buscar "AnythingLLM" no menu GNOME (Super key)
- Ações secundárias (clique direito no ícone): Restart / Logs / Stop

---

## §4 — Comando de instalação canônico (reprodução)

```bash
mkdir -p /home/enio/anythingllm/storage
touch /home/enio/anythingllm/.env

docker pull mintplexlabs/anythingllm:latest

docker run -d --name anythingllm \
  -p 3001:3001 \
  --cap-add SYS_ADMIN \
  -v /home/enio/anythingllm/storage:/app/server/storage \
  -v /home/enio/anythingllm/.env:/app/server/.env \
  -e STORAGE_DIR=/app/server/storage \
  --restart unless-stopped \
  mintplexlabs/anythingllm:latest
```

`--cap-add SYS_ADMIN`: necessário para Puppeteer/Playwright em agent skills de scraping.

---

## §5 — Operação automatizada (Claude Code-side)

### 5.1 — Via API REST (recomendado para mudanças)

API key: ler de `/home/enio/anythingllm/.api-key`

```bash
KEY=$(cut -d= -f2 /home/enio/anythingllm/.api-key)
H="Authorization: Bearer $KEY"
BASE=http://localhost:3001/api/v1
```

**Health & auth:**
```bash
curl -H "$H" $BASE/auth
# → {"authenticated":true}
```

**Listar workspaces:**
```bash
curl -H "$H" $BASE/workspaces | jq
```

**Criar workspace:**
```bash
curl -X POST -H "$H" -H "Content-Type: application/json" \
  -d '{"name":"gpecas-catalog"}' $BASE/workspace/new | jq
```

**Upload documento (raw text):**
```bash
curl -X POST -H "$H" -H "Content-Type: application/json" \
  -d '{"textContent":"...","metadata":{"title":"Manual Brastemp X","docSource":"upload"}}' \
  $BASE/document/raw-text | jq
```

**Upload arquivo (multipart):**
```bash
curl -X POST -H "$H" \
  -F "file=@/path/to/manual.pdf" \
  $BASE/document/upload | jq
```

**Embed documento num workspace:**
```bash
curl -X POST -H "$H" -H "Content-Type: application/json" \
  -d '{"adds":["custom-documents/manual-brastemp.pdf-uuid.json"]}' \
  $BASE/workspace/<slug>/update-embeddings | jq
```

**Chat com workspace:**
```bash
curl -X POST -H "$H" -H "Content-Type: application/json" \
  -d '{"message":"qual a garantia do freezer Brastemp BVR28?","mode":"chat"}' \
  $BASE/workspace/<slug>/chat | jq
```

**Documentação completa:** `http://localhost:3001/api/docs` (Swagger UI).

### 5.2 — Via SQL direto (low-level, para CRUD de massa ou settings que API não expõe)

```bash
DB=/home/enio/anythingllm/storage/anythingllm.db

# Listar tabelas
sqlite3 $DB ".tables"

# System settings
sqlite3 $DB "SELECT label, value FROM system_settings"

# Mudar LLM provider sem UI
sqlite3 $DB "INSERT OR REPLACE INTO system_settings (label, value) VALUES ('LLMProvider','gemini')"

# Listar API keys
sqlite3 $DB "SELECT id, substr(secret,1,12)||'...', createdAt FROM api_keys"

# Gerar nova API key
SECRET=$(openssl rand -hex 32)
sqlite3 $DB "INSERT INTO api_keys (secret) VALUES ('$SECRET')"
echo $SECRET  # SALVAR

# Backup DB
cp $DB $DB.bak.$(date +%Y%m%d_%H%M%S)
```

⚠️ **Cuidados SQL direto:**
- Container precisa estar parado para writes em alguns casos (`docker stop anythingllm` antes)
- Sempre fazer backup antes
- Tabelas críticas: `users`, `api_keys`, `workspaces`, `workspace_documents`, `system_settings`, `embed_configs`

---

## §6 — Configurações canônicas (default escolhido)

Quando configurar via UI ou API, manter este padrão:

| Setting | Valor | Razão |
|---|---|---|
| LLM Provider | OpenRouter (Gemini Flash) primário | barato, rápido, multilíngue |
| LLM Fallback | Anthropic Haiku | qualidade quando Gemini falha |
| Embedding | built-in (LanceDB) ou Voyage Multilingual | Voyage paga mas tem PT-BR melhor |
| Vector DB | LanceDB (built-in) | zero-config, performance OK p/ <100k docs |
| Chunk size | 1000 tokens | balance entre contexto e custo |
| Chunk overlap | 200 tokens | padrão da indústria |
| Top N retrieval | 4 | reduz alucinação |
| Similarity threshold | 0.25 | corta lixo sem perder relevância |
| Vector search mode | default (`rerank` se >50k docs) | reranking custa, só vale em escala |

---

## §7 — Agent skills habilitadas vs políticas EGOS

| Skill | Status | Política EGOS |
|---|---|---|
| RAG & memória longa | ✅ ON | sempre on |
| Visualizar & resumir | ✅ ON | sempre on |
| Extrair sites | ✅ ON | OK p/ research interno; NUNCA em workspace de cliente sem consent |
| Acesso ao sistema de arquivos | ✅ ON | ⚠️ **APENAS pasta autorizada do cliente** — nunca `~/` ou `/`. Política: limitar a `/data/cliente-<slug>/` |
| Criação de documentos | ❌ OFF | habilitar caso a caso |
| Gerar gráficos | ❌ OFF | habilitar caso a caso |
| Busca na web | ❌ OFF | **mantenha OFF para clientes com dados sensíveis** (vazamento via query) |
| Conector SQL | ❌ OFF | habilitar apenas com banco do cliente, RLS ativo |

---

## §8 — MCP servers (EGOS plugins)

AnythingLLM suporta MCP servers nativo. Para plugar MCPs EGOS:

**Settings → Tools → MCP Servers → Adicionar**

```json
{
  "name": "egos-g-pecas",
  "type": "sse",
  "url": "https://mcp.gpecas.egos.ia.br/sse",
  "auth": {
    "type": "bearer",
    "token": "<MCP_BEARER_TOKEN>"
  }
}
```

**MCPs EGOS candidatos a plugar:**
| MCP | Use case AnythingLLM |
|---|---|
| `mcp-g-pecas` (30 tools) | Workspace "gpecas-catalog" consegue consultar produtos via tools, não só RAG |
| `guard-brasil-mcp` | PII scan automático em uploads (call em pre-write hook) |
| `knowledge-mcp` | Cross-workspace search (KB EGOS interna do Enio) |
| `mcp-governance` | Auditoria de queries do cliente (capture mcp_audit_events) |
| `mcp-memory` | Memória cross-session por usuário |

---

## §9 — Multi-tenant: workspaces por cliente

Padrão escolhido (vez de instâncias Docker separadas):

```
Instância única AnythingLLM → workspaces nomeados por cliente

Workspace naming:
  <client_slug>-<scope>

Exemplos:
  gpecas-catalogo
  gpecas-atendimento
  gpecas-tecnico
  ap-patense-catalogo
  ferro-velho-faq
```

**Vantagens vs instância por cliente:**
- 1 container, menos recursos
- RBAC nativo (multi-user mode) controla acesso
- Backup centralizado
- API única

**Quando migrar para instância dedicada:**
- Cliente exige isolamento físico (advocacia, saúde)
- Cliente tem >50GB docs
- Cliente quer subdomínio próprio com Hermes integrado

---

## §10 — Deploy produção (futuro — não fazer ainda)

```
Quando validar com piloto G Peças:
1. Subir container em VPS EGOS (mesmo padrão local)
2. Caddyfile: kb.gpecas.egos.ia.br → reverse proxy → :3001
3. HTTPS automático via Caddy
4. Multi-user mode ON (config UI ou system_settings.multi_user_mode=true)
5. Backup diário do DB SQLite via cron (egos-gateway)
6. Monitor uptime via egos-observability (pm2_status)
```

---

## §11 — Configuração G Peças (executada 2026-05-20)

3 workspaces criados via API + system prompts especializados + `chatMode=query` (anti-alucinação):

| id | slug | name | Prompt | chatMode |
|---|---|---|---|---|
| 2 | `catalogo-g-pecas` | Catálogo G Peças | 459 chars (PT-BR, cita fonte, refusa sem KB) | query |
| 3 | `atendimento-g-pecas` | Atendimento G Peças | 394 chars (humano, transfere se não souber) | query |
| 4 | `suporte-tecnico-g-pecas` | Suporte Técnico G Peças | 438 chars (manual técnico, cita página) | query |

**Settings comuns:** topN=4, similarityThreshold=0.25, openAiTemp=0.2, openAiHistory=20.

**Refusal texts** (LGPD-friendly, evita alucinação):
- Catálogo → "Não tenho essa informação no catálogo G Peças..."
- Atendimento → "Não tenho essa resposta. Vou anotar sua dúvida e transferir..."
- Técnico → "Informação não encontrada nos manuais técnicos..."

⚠️ **CRÍTICO — chatMode=query vs chat:**
- `chat`: LLM responde mesmo sem match no KB (RISCO ALUCINAÇÃO)
- `query`: LLM SÓ responde se houver match. Senão refusal_text aciona
- **Sempre usar `query` em workspaces de cliente** — política EGOS

---

## §12 — Manutenção remota e RBAC (perguntas Enio 2026-05-20)

### Manutenção remota via API
Quando AnythingLLM rodar no VPS do cliente (ex: `kb.gpecas.egos.ia.br`), você opera 100% remoto daqui:

```bash
# Seu .ssh/.api-key contém uma cópia da master key do cliente
KEY=$(cat ~/.egos/clients/gpecas/.api-key)
BASE=https://kb.gpecas.egos.ia.br/api/v1

# Curl direto, exatamente como local:
curl -H "Authorization: Bearer $KEY" $BASE/workspaces
# Atualizar prompt:
curl -X POST -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"openAiPrompt":"novo prompt"}' $BASE/workspace/<slug>/update
```

**Tudo que fizer aqui localhost funciona remoto** se DNS + bearer auth estão OK.

### RBAC + NDA — limites de atuação Enio quando cliente não quer expor tudo

**Cenário:** cliente assina contrato, mas não quer Enio lendo documentos sensíveis.

#### Opção 1 — Multi-user mode com 3 níveis (recomendado)

```sql
-- Ativar multi-user mode (UMA VEZ por instância cliente)
UPDATE system_settings SET value='true' WHERE label='multi_user_mode';
```

| Role | O que vê | O que faz | Para quem |
|---|---|---|---|
| `admin` | TUDO | criar/deletar workspaces, users, configs globais | **Cliente owner** (Julio) |
| `manager` | Workspaces que admin atribuir | criar prompts, configurar embeddings, treinar funcionários | **Enio** |
| `default` | Só workspaces atribuídos | chat + upload em workspaces específicos | Funcionários cliente |

Comando para criar usuário Enio como manager limitado:
```bash
KEY=$(cat .api-key)
curl -X POST -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"username":"enio-egos","password":"<rotacionar>","role":"manager"}' \
  https://kb.gpecas.egos.ia.br/api/v1/admin/users/new
```

Cliente owner pode então em qualquer momento:
- Atribuir workspace específico ao manager → manager vê
- Remover atribuição → manager perde acesso instantâneo
- Auditar via `event_logs` table (timestamp + user + action)

#### Opção 2 — Instâncias físicas separadas

Workspace "públicos" (catálogo, FAQ) na instância padrão.
Workspace "confidenciais" (financeiro, contratos) em **container Docker separado** que só o cliente acessa, com bearer key não compartilhada com Enio.

```bash
# Cliente roda 2ª instância isolada:
docker run -d --name anythingllm-confidencial -p 3002:3001 \
  -v /opt/anythingllm-confidencial/storage:/app/server/storage \
  mintplexlabs/anythingllm:latest
```

#### Opção 3 — API key revogável + log de auditoria

Cliente entrega chave temporária, revoga depois:
```bash
# Cliente cria chave 30 dias, entrega
sqlite3 db.db "INSERT INTO api_keys (secret, name) VALUES ('temp-key', 'enio-30d-suporte')"
# Após 30d:
sqlite3 db.db "DELETE FROM api_keys WHERE name='enio-30d-suporte'"
# Log audit:
sqlite3 db.db "SELECT * FROM event_logs WHERE userId IS NULL ORDER BY occurredAt DESC LIMIT 20"
```

### Política de transparência EGOS recomendada

Documentar **explícito em contrato** com cliente:

```
1. Manager EGOS (Enio) acessa apenas workspaces atribuídos pelo cliente
2. Cliente owner mantém controle exclusivo de:
   - Criar/deletar workspaces
   - Adicionar/remover usuários
   - Revogar API key do EGOS
3. Toda ação do EGOS é auditada em event_logs (timestamp + ação)
4. Cliente pode pedir export do event_logs a qualquer momento (LGPD Art. 19)
5. Suporte EGOS opera por mensagem documentada (não acesso silencioso)
```

---

## §13 — Vantagens reais para o cliente (proposta de valor)

Diferente de "comprar mais um SaaS", AnythingLLM + EGOS traz:

| Vantagem | Como vira valor concreto |
|---|---|
| **Linguagem natural vs dashboard** | Funcionário pergunta "quanto temos do freezer X em estoque?" em vez de navegar 5 telas |
| **Centraliza conhecimento disperso** | PDFs, planilhas, manuais, e-mails, políticas — tudo num único cérebro consultável |
| **Onboarding de funcionário 10x mais rápido** | Novato pergunta ao bot em vez de "achar a pessoa que sabe" |
| **Reduz tribal knowledge risk** | Quando funcionário sai, conhecimento não vai junto |
| **Mobile + desktop** | Atendente consulta no celular durante atendimento ao cliente |
| **Audit log nativo** | Cliente vê quem perguntou o quê (`event_logs` table) |
| **Plug-and-play com MCPs** | Catálogo, ordens, pagamentos — tudo conectado via MCP G Peças |
| **Sem vendor lock-in** | Trocar Gemini por Claude, OpenAI ou Ollama local em 1 config |
| **LGPD-friendly** | Dados ficam no servidor do cliente (BR), refusal customizado evita resposta inventada |
| **Anti-alucinação** | `chatMode=query` força LLM a só responder do KB próprio |
| **Era das IAs sem complexidade** | Cliente fala português, sistema entende — sem precisar virar engenheiro de prompts |

**Frase pitch comercial sintetizada:**
> *"Não é um chatbot. É a memória viva da sua empresa, consultável por linguagem natural, com você no controle de quem vê o quê."*

---

## §14 — Próximos passos (rastreados em TASKS.md como ALLM-EGOS-*)

Ver TASKS.md seção 🟦 ANYTHINGLLM EGOS para tasks numeradas com status/prioridade.

---

## §15 — Risco conhecido & mitigação

| Risco | Mitigação |
|---|---|
| Container morre, perde estado | Volume montado externo (`/home/enio/anythingllm/storage`) — DB persiste mesmo se container removido |
| API key vaza | Arquivo chmod 600, gitignored. Rotacionar via `DELETE FROM api_keys WHERE id=X` + gerar nova |
| Upgrade quebra DB | Backup antes de `docker pull` (Prisma migrations rodam no startup — leia release notes) |
| Filesystem agent skill expõe ~/ | Política: limitar a pasta específica do cliente. Default skill `filesystem-agent` está ON — **revisar antes de subir cliente** |
| Multi-tenant cruzamento de docs | RBAC do AnythingLLM enforce per-workspace, mas auditar antes de cliente real |
| MCP injection via prompt | Guard-brasil-mcp como pre-write hook + idempotency em tools sensíveis (mesmo padrão mcp-g-pecas) |

---

## §16 — Referências

- Site: https://anythingllm.com/
- Docs: https://docs.useanything.com/
- GitHub: https://github.com/Mintplex-Labs/anything-llm
- Swagger local: http://localhost:3001/api/docs
- OpenAPI JSON: http://localhost:3001/api/v1/openapi.json
- SSOT Espiral de Escuta v3.1: `docs/products/espiral-de-escuta/ARCHITECTURE.md` (a criar)
- Skills relacionadas: `egos/.claude/skills/kbs-discovery/`, `egos/.claude/commands/client-onboard.md`, `egos/.claude/commands/central-egos.md`

---

*v1.0 — 2026-05-20 — Setup local dev validado. Próximo update após Onda 1 completar.*
