# Mobile Access Guide — EGOS Stack

> **Versão:** 1.0 | **Data:** 2026-05-20 | **Origem:** Enio 2026-05-20 — "AnythingLLM via smartphone, viável?"
> **Aplica a:** Tier BASE (dashboard) + Tier PLUS (AnythingLLM mobile)

---

## TL;DR por tier

| Tier | Mobile access | Como |
|---|---|---|
| **BASE — Dashboard** | ✅ web responsive (já entregue) | Browser do celular → site.egos.ia.br/admin |
| **PLUS — AnythingLLM** | ✅ 3 opções (Android nativo / web responsive / PWA) | Ver §2 abaixo |
| **PREMIUM — Hermes bot** | ✅ WhatsApp/Telegram (canais nativos do user) | Bot responde no canal preferido |

---

## §1 — Tier BASE: dashboard mobile-first (já vivo)

O central-egos-template já entrega:
- Site storefront responsive (Tailwind mobile-first)
- Admin web responsive (Next.js + dark mode + bottom nav drawer)
- WhatsApp bot via Evolution/WAHA
- Validado em G Peças hoje (Julio opera 100% pelo smartphone)

**Cliente acessa:**
- Storefront público: `gpecas.egos.ia.br`
- Admin: `gpecas.egos.ia.br/admin/<login>`
- WA: número `5534997934688` (instância `egos-gpecas`)

**Requisitos cliente:**
- Smartphone com browser moderno (qualquer Android 8+ / iOS 13+)
- WhatsApp instalado
- Conexão 4G+ ou WiFi
- **NÃO precisa:** computador, app extra, app store

---

## §2 — Tier PLUS: AnythingLLM mobile (3 caminhos)

### Opção A — App Android nativo (✅ disponível hoje)

[AnythingLLM Mobile no Google Play](https://play.google.com/store/apps/details?id=com.anythingllm)

- **Custo:** gratuito
- **Suporta:** Android 8+ (provavelmente)
- **Modos:**
  - Local: roda LLM no próprio celular (sem servidor)
  - **Cloud/Connect (nosso caso):** conecta ao servidor AnythingLLM do cliente em `kb.<slug>.egos.ia.br`
- **Setup cliente final (funcionário):**
  1. Instalar AnythingLLM da Google Play
  2. Abrir → "Connect to existing server"
  3. URL: `https://kb.<slug>.egos.ia.br`
  4. API key fornecida pelo cliente owner (gerada via UI)
  5. Selecionar workspace atribuído
  6. Pronto — chat normal

**Vantagem:** UX nativa (notificações, splash screen, ícone home).

### Opção B — Web responsive no browser do celular (✅ funciona já)

AnythingLLM web UI é totalmente responsive. Cliente final acessa direto:
- `https://kb.<slug>.egos.ia.br`
- Login com user/password do funcionário
- Chat funciona igual desktop

**Vantagem:** zero instalação, qualquer device (Android/iOS/Windows Phone).
**Desvantagem:** precisa abrir browser todo dia (sem ícone home dedicado).

### Opção C — Adicionar à Home Screen (PWA-like, funciona hoje)

Mesmo sem PWA full nativo (roadmap 2026), o browser permite "Adicionar à tela inicial":

**Android Chrome:**
1. Abrir `kb.<slug>.egos.ia.br` no Chrome
2. Menu (⋮) → "Adicionar à tela inicial"
3. Nome: "EGOS KB"
4. Ícone aparece como app

**iOS Safari:**
1. Abrir `kb.<slug>.egos.ia.br` no Safari
2. Botão Compartilhar (↑) → "Adicionar à Tela de Início"
3. Ícone aparece como app

**Resultado:** ícone home parecendo app nativo, abre em modo fullscreen.

**Status PWA full (offline, push, install banner):** roadmap AnythingLLM 2026 ([GitHub issue #4592](https://github.com/Mintplex-Labs/anything-llm/issues/4592)).

### Recomendação por cenário

| Cenário cliente | Opção recomendada |
|---|---|
| Funcionário usa Android, sem fricção | **A — App nativo** (melhor UX) |
| Funcionário usa iPhone (sem app nativo iOS ainda) | **C — Safari + Adicionar à Tela** |
| Equipe variada (Android+iOS) | **B+C — web responsive + ícone home** (consistência) |
| Onboarding rápido sem app store | **B — web direto** |

---

## §3 — Infraestrutura: onde rodar o AnythingLLM (Tier PLUS)

### Opção 1 — VPS na nuvem (RECOMENDADO ✅)

```
kb.<cliente>.egos.ia.br
  ↓ HTTPS via Caddy
  ↓ reverse proxy
Docker AnythingLLM no VPS EGOS (ou VPS próprio cliente)
  ↓
Storage volume (SSD), backups daily, observability (uptime, logs)
```

**Vantagens:**
- ✅ Sempre disponível (sem depender de computador da loja ligado)
- ✅ Observabilidade real (Prometheus, alertas, uptime monitor)
- ✅ Backup automatizado em cron
- ✅ Atualização controlada
- ✅ Mobile + desktop acessam o mesmo lugar
- ✅ Audit log centralizado

**Desvantagens:**
- Custo VPS (~$5-10/mês por instância)
- Cliente depende de internet para acessar

**Custo total cliente Tier PLUS:** R$ 500 entry + R$ 300-500/mês (inclui VPS)

### Opção 2 — Computador da loja "sempre ligado" (DESACONSELHADO ⚠️)

```
Computador na loja
  ↓ AnythingLLM Docker rodando em localhost:3001
  ↓ Acesso só na LAN da loja
Smartphone do funcionário (mesma WiFi)
  → http://192.168.X.Y:3001
```

**Vantagens:**
- Zero custo VPS
- Dados ficam fisicamente na loja
- Não depende de internet externa para LAN

**Desvantagens:**
- ❌ Computador pode desligar (queda energia, queda WiFi)
- ❌ Sem backup automático off-site
- ❌ Acesso só na LAN (não funciona fora da loja)
- ❌ Sem HTTPS válido (cert self-signed = browser block)
- ❌ Sem observabilidade
- ❌ Atualização manual presencial
- ❌ Risco se computador for roubado/danificado

**Quando aceitar:** cliente extremo no orçamento + LAN-only OK + tem PC dedicado já.
**Padrão EGOS:** evitar — propor VPS.

### Opção 3 — Híbrida (VPS principal + sync local opcional)

Para cliente que quer "redundância": VPS é primary, computador local sincroniza backup.

**Setup:**
- VPS: AnythingLLM rodando 24/7
- PC local: cron rsync do storage do VPS diário
- Se VPS cair: PC local serve temporário (fallback degradado)

**Complexidade:** alta. Só se cliente Premium pedir explicitamente.

---

## §4 — Segurança em mobile (cliente final acessa)

### Camadas obrigatórias (Tier PLUS+)

```
1. HTTPS (Caddy ou Cloudflare) — bloqueio total HTTP
2. Login user/password do funcionário (RBAC AnythingLLM)
3. (Opcional) IP allowlist se conexão for previsível (WiFi loja fixo)
4. Rate limit por IP no API gateway
5. Session timeout 8h (cliente final desloga ao fim do expediente)
6. Audit log: quem acessou, quando, de qual IP, o que perguntou
```

### Risco: cliente perde celular com app logado

**Mitigação:**
1. Cliente owner avisa Enio imediatamente
2. Enio revoga session via:
   ```bash
   KEY=$(cat ~/.egos/clients/<slug>/.api-key)
   # Forçar logout do user específico (próxima ação rede pede re-login)
   curl -X POST -H "Authorization: Bearer $KEY" \
     https://kb.<slug>.egos.ia.br/api/v1/admin/users/<user-id>/force-logout
   ```
3. Cliente reseta senha do funcionário
4. Audit: verificar event_logs últimas 24h (vazou algo?)

---

## §5 — Onboarding mobile do funcionário (script)

Roteiro de 10min para o Enio ou Tier PLUS owner:

```
1. Pergunta inicial: "Você usa Android ou iPhone?"
   - Android: vai para Opção A (app nativo)
   - iPhone: vai para Opção C (Safari + tela inicial)

2. Mostrar URL: kb.<slug>.egos.ia.br

3. Login: usuário + senha (fornecidos pelo owner)

4. Demonstrar 3 perguntas reais do cliente:
   "qual a garantia do freezer X?"
   "como é a política de troca?"
   "qual o procedimento para [tarefa]?"

5. Mostrar que cita fonte (modelo de transparência)

6. Mostrar quando "Não tenho essa informação" → o que fazer
   (Resposta: encaminhar para owner OU para canal humano)

7. Praticar 3 perguntas adicionais com o funcionário

8. Mostrar como atualizar workspace (quando aplicável):
   - Funcionário NÃO altera, só consulta
   - Owner alimenta novos docs

9. Limitações esperadas:
   - Não inventa resposta (chatMode=query)
   - Não fala sobre concorrentes
   - Não dá opinião sobre crítica/política

10. Contato suporte: WhatsApp Enio para dúvidas
```

---

## §6 — Casos comuns de troubleshooting mobile

| Sintoma | Causa provável | Solução |
|---|---|---|
| "Não consigo abrir" | Sem internet OU URL errada | Validar conexão + URL exata |
| "Login falha" | Senha errada / user revogado | Owner reseta no painel admin |
| "Diz não tem informação" | KB sem doc OU chatMode=query (esperado) | Owner ingere doc faltante |
| "Lento" | Rede ruim OU server sobrecarregado | Verificar OpenRouter status / VPS health |
| "App fechou sozinho" | OOM Android OU bug app | Reabrir, se persistir reportar |
| "Notificação não vem" | App nativo precisa permissão | Configurações → Notificações → AnythingLLM → permitir |

Detalhe completo: [CLIENT_INCIDENT_RUNBOOK.md](CLIENT_INCIDENT_RUNBOOK.md)

---

## Referências

- [CLIENT_TIERS_MATRIX.md](../governance/CLIENT_TIERS_MATRIX.md) — quando aplicar cada tier
- [CLIENT_KB_DOCTRINE.md](../governance/CLIENT_KB_DOCTRINE.md) — 7 regras de segurança
- [products/anythingllm/OPERATIONS.md](../products/anythingllm/OPERATIONS.md) — operações servidor
- [AnythingLLM Mobile](https://anythingllm.com/mobile)
- [AnythingLLM Mobile Overview docs](https://docs.anythingllm.com/mobile/overview)
- [AnythingLLM Google Play](https://play.google.com/store/apps/details?id=com.anythingllm)
- PWA Mobile Testing Checklist 2026 ([referência](https://mobileviewer.github.io/pwa-mobile-testing-checklist-2026))

*v1.0 — 2026-05-20 — Guia mobile para Tier BASE/PLUS/PREMIUM com 3 caminhos validados.*
