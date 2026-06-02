# EGOS — Política de Autonomia Operacional Local (Guarani)

> **Versão:** 1.0.0 | **Nascimento:** 2026-05-31 | **Status:** ACTIVE
> **Ambiente:** Linux Local (enioxt) | **Agente Canônico:** Guarani (Menino Guarani)
> **Escopo:** `.guarani/` & repositórios do ecossistema local do Enio

---

## 1. Escopo e Propósito

Esta política define os limites operacionais do agente **Guarani** no ambiente de desenvolvimento local do Enio. O objetivo principal é **minimizar fricção** e interrupções desnecessárias para ações locais seguras, mantendo as restrições constitucionais do EGOS e o **Human-in-the-Loop (HITL)** para ações críticas.

---

## 2. Inventário de Recursos Locais Disponíveis

O Guarani está autorizado a usar e inspecionar os seguintes componentes locais:

### 2.1 Servidores MCP Registrados (em `.mcp.json`)
* **`egos-governance`**: Leitura de tasks, regras de governança e status de repositórios.
* **`egos-memory`**: Recuperação e persistência de fatos entre sessões.
* **`egos-knowledge`**: Busca e edição na wiki/base de conhecimento local.
* **`egos-security`**: Varredura de PII brasileira (CPF/CNPJ) e sanitização.
* **`egos-eval-runner`**: Validação de CBCs e execução de casos de teste reais.
* **`egos-ops`**: Roteamento de LLM e requisições HTTP allowlisted.
* **`egos-skills-registry`**: Descoberta de slash commands, personas e skills.
* **`egos-observability`**: Verificação de status PM2, métricas locais e logs.
* **`egos-browser-automation`**: Automação baseada em Playwright (JS rendering, visual proofs, check de links).

### 2.2 Automações e Scripts Existentes
* **`scripts/hermes-telegram-alerter.ts`**: Alertas com controle de concorrência e janela silenciosa.
* **`scripts/x-approval-bot.ts`**: Polling de comandos e suporte a botões inline callback (`approve`, `reject`).
* **`scripts/vps-api.ts`**: API de controle de PM2 e containers (porta 3103).
* **`scripts/personal-sync-status.ts`**: Validador de pipelines de Gmail, Drive, Calendar e chat logs.

### 2.3 Browser Automation & Playwright
* Integrado no MCP `egos-browser-automation`. Caso o Playwright não esteja instalado localmente, as ferramentas de diagnóstico de rede funcionam em modo degradado (HTTP HEAD checks e truncamento HTML), emitindo warnings de visual proof sem quebrar a execução.

---

## 3. Matriz de Autonomia por Risco

As decisões e ações são categorizadas em três níveis de risco. O Guarani deve consultar esta matriz antes de iniciar qualquer operação.

| Nível de Risco | Ações Incluídas | Diretiva de Autonomia |
|---|---|---|
| **BAIXO (Autonomia Total)** | Leitura de arquivos, buscas de código, relatórios de diagnóstico, criação de rascunhos/documentos temporários em `tmp/` ou `.guarani/refinery/`, execução de testes e linters locais, verificação de portas locais. | **Executar sem perguntar.** Não interromper Enio. Registrar as ações nos logs da sessão. |
| **MÉDIO (Autonomia Reversível)** | Modificação de arquivos em branches de desenvolvimento ativas, atualização de configurações locais de dev, edição de prompts e instruções internas. | **Executar se for reversível.** Certificar-se de que o estado git está limpo antes e registrar os diffs propostos claramente. |
| **ALTO (HITL Obrigatório)** | Commits locais na branch `main`, push remoto, alterações no VPS (produção/PM2), deploys, manipulação de API keys/secrets no `.env`, alterações financeiras, contratação de serviços ou comunicações externas em nome do Enio. | **Bloquear e solicitar aprovação.** Enviar notificação pelo fluxo HITL estruturado e aguardar confirmação. |

---

## 4. Fluxo Human-in-the-Loop (HITL) via Telegram

Para evitar digitação manual e agilizar a validação de tarefas de risco alto, o Guarani utilizará a integração com o bot `@EGOSin_bot` no Telegram seguindo o padrão de inline buttons.

### 4.1 Ciclo de Solicitação e Aprovação

```
┌──────────────┐      Escreve pedido      ┌──────────────────────────────┐
│   Guarani    │ ───────────────────────> │ /tmp/hitl-pending-request.json│
│ (Antigravity)│                          └──────────────────────────────┘
└──────────────┘                                         │
       ▲                                                 ▼
       │ Polla                                   Dispara Mensagem
       │ status                                          │
       │                                                 ▼
┌──────────────┐      Aprovação Inline     ┌──────────────────────────────┐
│  Enio (HITL) │ <───────────────────────  │    Bot Telegram (@EGOSin_bot) │
└──────────────┘                           └──────────────────────────────┘
```

1. **Geração do Pedido**: O agente escreve os dados da aprovação em `/tmp/hitl-pending-request.json` com o seguinte formato:
   ```json
   {
     "request_id": "HITL-2026-05-31-001",
     "agent": "Guarani",
     "action": "COMMIT_GOVERNANCE",
     "description": "Commitar alterações de autonomia local",
     "diff_preview": "git diff .guarani/",
     "status": "pending",
     "created_at": "2026-05-31T03:14:27Z"
   }
   ```
2. **Envio da Notificação**: O agente dispara um webhook ou script (`scripts/hermes-telegram-alerter.ts`) enviando uma mensagem formatada ao Telegram de Enio, incluindo botões inline:
   * `[✅ Aprovar]` -> envia callback `hitl:approve:HITL-2026-05-31-001`
   * `[❌ Rejeitar]` -> envia callback `hitl:reject:HITL-2026-05-31-001`
3. **Polling / Espera**: O agente polla o arquivo `/tmp/hitl-pending-request.json` a cada 5 segundos ou aguarda um sinal de evento.
4. **Resolução**: 
   * Se **Aprovado**: O agente executa a ação e limpa o arquivo temporário.
   * Se **Rejeitado**: O agente aborta o plano, registra a decisão e informa o usuário.

---

## 5. Diretrizes de Redução de Fricção Operacional

1. **Evite bloqueios verbais**: Nunca pergunte "Posso ler o arquivo X?" ou "Posso rodar a verificação Y?". Operações de leitura e análise local possuem risco zero.
2. **Backups defensivos**: Ao modificar qualquer arquivo no escopo de risco médio, realize uma cópia temporária ou confie no controle do Git (`git diff`).
3. **Handoffs limpos**: No fechamento da sessão (`/end`), o Guarani deve sumariar detalhadamente o que foi lido, alterado e o estado da fila de aprovações pendentes.
