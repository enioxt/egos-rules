# Codex Local Review — 2026-06-07T12:42:38Z

- Repo: egos | Branch: main | Base: HEAD~3 | Commits: 3

```
OpenAI Codex v0.130.0
--------
workdir: /home/enio/egos
model: gpt-5.5
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: medium
reasoning summaries: none
session id: 019ea21b-53bb-7753-9c1b-3f4f44c65541
--------
user
changes against 'HEAD~3'
2026-06-07T12:42:41.687568Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
2026-06-07T12:42:41.687726Z ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed, when Auth(TokenRefreshFailed("Server returned error response: invalid_grant: Invalid refresh token"))
exec
/bin/bash -lc 'git diff 21104bf200381fd1f4ee32f5496369956d6ab4d9 --stat && git diff 21104bf200381fd1f4ee32f5496369956d6ab4d9' in /home/enio/egos
 succeeded in 198ms:
 .claude/agents/pixel.md                            |   5 +
 TASKS.md                                           |   1 -
 TASKS_ARCHIVE.md                                   |   6 +
 apps/egos-landing/src/App.tsx                      | 252 ++++++++++++++++++++-
 ...PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md |  38 ++++
 .../handoff_2026-06-05-ui-observability.md         |  69 ------
 docs/_current_handoffs/handoff_2026-06-05.md       |  84 -------
 docs/jobs/2026-06-06-doc-drift-analysis.md         |  21 ++
 docs/jobs/2026-06-07-doc-drift-analysis.md         |  21 ++
 packages/mcp-browser-automation/src/index.ts       |  25 ++
 10 files changed, 367 insertions(+), 155 deletions(-)
diff --git a/.claude/agents/pixel.md b/.claude/agents/pixel.md
index 8a031be9..84af6863 100644
--- a/.claude/agents/pixel.md
+++ b/.claude/agents/pixel.md
@@ -22,6 +22,11 @@ Implementar tarefas de UI, criar slides e materiais visuais, e **provar** o resu
 - Criar/editar componentes React/Next.js (`.tsx`, `.css`, `.html`)
 - Rodar dev server local para capturar screenshot
 - Usar `mcp__egos-browser-automation__visual_proof_gate` para screenshot
+
+> **🛡️ Consent gate da landing (NÃO improvise xvfb/dump-dom):** `egos.ia.br` (e o dev local) tem um modal de consent LGPD (`localStorage.egos_consent_v1`) que bloqueia screenshots em primeira visita. **Não tente contornar com xvfb ou `--dump-dom`.** O seed do consent já está embutido nas duas ferramentas canônicas:
+> - **Produção (https):** `mcp__egos-browser-automation__visual_proof_gate` — seeda consent automaticamente (corrigido 2026-06-05).
+> - **Local (http dev server):** `bun scripts/visual-audit.ts --url http://localhost:5181` — seeda consent + screenshota todas as páginas em `docs/_proofs/<data>/`.
+> Ambas dismissam o modal antes do `goto`. Se um screenshot vier com o modal cobrindo a tela, você usou o caminho errado.
 - Gerar slides (NotebookLM Studio, HTML, Markdown)
 - Atualizar `docs/governance/VISUAL_IDENTITY.md` style guidelines
 - Consultar `docs/governance/SLIDE_STANDARD.md` para assinatura visual
diff --git a/TASKS.md b/TASKS.md
index 3d66ecae..2b4d234a 100644
--- a/TASKS.md
+++ b/TASKS.md
@@ -33,7 +33,6 @@
 > Princípio cravado: **"O EGOS não precisa guardar pessoas; preserva ideias, conceitos, padrões, decisões."**
 
 **Pendências de publicação (HITL — do artefato grátis):**
-- [ ] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte.
 - [ ] **COURSE-TELEGRAM-OPEN-001** [P1] `prime` — Criar/configurar grupo Telegram aberto "EGOS Framework" → ao existir, completar o link no artefato grátis (Parte 3). (Já existia; reforçada aqui como dependência do artefato.)
 - [ ] **COURSE-FREE-TIER-001** — reaberta (rascunho ≠ publicado; ver acima). Fecha só ao publicar.
 
diff --git a/TASKS_ARCHIVE.md b/TASKS_ARCHIVE.md
index 30072eeb..710b4348 100644
--- a/TASKS_ARCHIVE.md
+++ b/TASKS_ARCHIVE.md
@@ -3678,3 +3678,9 @@ Tasks abaixo (CHATBOT-ATRIAN-002, GTM-*, ATLAS-ADD-003) mantidas nas seções or
 - [x] **ARTIFACT-CONFIG-PROTOCOL-001** [P1] `prime` — FEITO `190f5950`: bloco tutor-first adicionado ao metaprompt (uma pergunta → infere pacote → propõe → confirma). Free artifact v2 aprovado pelo aparato (Banda+Codex+Guarani). Aguarda apenas glance Enio (FREE-ARTIFACT-GLANCE-001).
 - [x] **PRODUCT-NO-TIER-RULE-001** [P0] `prime` — FEITO `b446d7b8`: regra global documentada em `docs/strategy/PRODUCT_MODEL.md` — um preço (R$4), um produto, vitalício, reembolso mantém material, transparência radical (LIVE/WIP/CONCEPT). Co-criação com participação proporcional em receita.
 
+
+## Archived 2026-06-07
+
+### 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
+- [x] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte. ✅ 2026-06-05
+
diff --git a/apps/egos-landing/src/App.tsx b/apps/egos-landing/src/App.tsx
index 9887af74..439263b6 100644
--- a/apps/egos-landing/src/App.tsx
+++ b/apps/egos-landing/src/App.tsx
@@ -1,4 +1,4 @@
-import { useState, useEffect } from 'react'
+import { useState, useEffect, useRef } from 'react'
 import { supabase } from './lib/supabase'
 import { ConsentGate } from './components/ConsentGate'
 import { ConsentBadge } from './components/ConsentBadge'
@@ -150,6 +150,11 @@ function App() {
   const [grokPrompt, setGrokPrompt] = useState('')
   const [grokLoading, setGrokLoading] = useState(false)
 
+  // Free Artifact — metaprompt copy button state
+  const [copied, setCopied] = useState(false)
+  const copyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
+  useEffect(() => () => { if (copyTimerRef.current) clearTimeout(copyTimerRef.current) }, [])
+
   // Handlers for dynamic actions
   const handleGenerateKey = async () => {
     if (!keyName.trim() || !keyEmail.trim()) return
@@ -603,6 +608,251 @@ function App() {
                 </div>
               </section>
 
+              {/* ── Comece aqui — grátis em 2 minutos ── */}
+              <section style={{ margin: '56px 0' }}>
+                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
+                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
+                  <h2 className="h2">Comece aqui</h2>
+                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
+                    Três artefatos prontos para usar hoje no ChatGPT, Claude ou Gemini.
+                  </p>
+                </div>
+
+                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px', alignItems: 'start' }}>
+
+                  {/* Bloco 1 — Metaprompt */}
+                  <div className="card" style={{ padding: '28px' }}>
+                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>01</span>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>Metaprompt: Assistente Profissional Governado</h3>
+                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
+                      Cole no campo de instruções do ChatGPT (ou system prompt do Claude/Gemini) e troque os <code style={{ background: 'var(--bg-deep)', padding: '1px 4px', borderRadius: '3px' }}>[colchetes]</code>. Pronto.
+                    </p>
+                    <div style={{
+                      position: 'relative',
+                      background: 'var(--bg-deep)',
+                      border: '1px solid var(--border)',
+                      borderRadius: '8px',
+                      marginBottom: '12px',
+                    }}>
+                      <pre style={{
+                        fontFamily: 'monospace',
+                        fontSize: '12px',
+                        color: 'var(--text-muted)',
+                        lineHeight: 1.6,
+                        padding: '16px',
+                        maxHeight: '300px',
+                        overflowY: 'auto',
+                        whiteSpace: 'pre-wrap',
+                        wordBreak: 'break-word',
+                        margin: 0,
+                      }}>{`Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
+Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
+
+Atua exclusivamente em:
+- [Área 1]  - [Área 2]  - [Área 3]
+Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
+
+── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
+Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
+Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
+Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
+Fluxo obrigatório:
+1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
+2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
+3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
+4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
+NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
+
+── CLASSIFICAÇÃO OBRIGATÓRIA ──
+Classifique afirmações relevantes como:
+- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
+- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
+
+── ANTI-ALUCINAÇÃO ──
+Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
+Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
+Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
+
+── PROTEÇÃO DE DADOS ──
+Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
+Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
+
+── ZONA VERMELHA (pause antes) ──
+Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
+Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
+
+── LIMITAÇÕES ──
+Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
+
+── CRITÉRIO DE EVIDÊNCIA ──
+Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
+
+── MODO DE RESPOSTA ──
+Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
+
+── FORMATO DE SAÍDA ──
+Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
+Síntese: [resposta direta]
+Evidências: [fontes/dados/base lógica]
+Riscos: [se houver]
+Próxima ação: [recomendação objetiva]
+
+── REGRA FINAL ──
+Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`}</pre>
+                    </div>
+                    <button
+                      onClick={() => {
+                        const metaprompt = `Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
+Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
+
+Atua exclusivamente em:
+- [Área 1]  - [Área 2]  - [Área 3]
+Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
+
+── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
+Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
+Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
+Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
+Fluxo obrigatório:
+1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
+2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
+3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
+4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
+NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
+
+── CLASSIFICAÇÃO OBRIGATÓRIA ──
+Classifique afirmações relevantes como:
+- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
+- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
+
+── ANTI-ALUCINAÇÃO ──
+Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
+Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
+Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
+
+── PROTEÇÃO DE DADOS ──
+Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
+Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
+
+── ZONA VERMELHA (pause antes) ──
+Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
+Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
+
+── LIMITAÇÕES ──
+Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
+
+── CRITÉRIO DE EVIDÊNCIA ──
+Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
+
+── MODO DE RESPOSTA ──
+Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
+
+── FORMATO DE SAÍDA ──
+Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
+Síntese: [resposta direta]
+Evidências: [fontes/dados/base lógica]
+Riscos: [se houver]
+Próxima ação: [recomendação objetiva]
+
+── REGRA FINAL ──
+Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`
+                        if (copyTimerRef.current) clearTimeout(copyTimerRef.current)
+                        navigator.clipboard.writeText(metaprompt).then(() => {
+                          setCopied(true)
+                          copyTimerRef.current = setTimeout(() => setCopied(false), 2000)
+                        }).catch(() => setCopied(false))
+                      }}
+                      className="btn btn-primary"
+                      style={{ width: '100%' }}
+                    >
+                      {copied ? 'Copiado!' : '📋 Copiar metaprompt'}
+                    </button>
+                  </div>
+
+                  {/* Bloco 2 — Checklist */}
+                  <div className="card" style={{ padding: '28px' }}>
+                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>02</span>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>Checklist: Segurança de IA em 1 Página</h3>
+                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '20px', lineHeight: 1.6 }}>
+                      Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.
+                    </p>
+                    <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: '14px' }}>
+                      {[
+                        { label: 'Dado real só com necessidade', desc: '"o LLM precisa deste dado ou posso descrever o padrão?"' },
+                        { label: 'PII mascarada antes de colar', desc: 'CPF/nome/processo → [NOME], [CPF], [PROCESSO].' },
+                        { label: 'LLM externo ≠ ambiente sigiloso', desc: 'É servidor de terceiro; sigilo profissional → verifique ToS ou use modelo local.' },
+                        { label: 'Output de IA é INFERIDO', desc: 'Número/data/citação gerada precisa de verificação independente antes de usar.' },
+                        { label: 'Nunca cole credenciais', desc: 'Senhas, tokens, chaves, certificados fora do prompt.' },
+                        { label: 'Histórico tem memória', desc: 'Usou dado sensível? Limpe depois; verifique se a conta não treina com seus dados.' },
+                        { label: 'Releia antes de publicar', desc: 'Alucinação de IA é confiante; leia com o olho de quem recebe.' },
+                      ].map((item, i) => (
+                        <li key={i} style={{ display: 'flex', gap: '10px', alignItems: 'flex-start' }}>
+                          <span style={{
+                            flexShrink: 0,
+                            width: '20px', height: '20px',
+                            border: '2px solid var(--accent)',
+                            borderRadius: '4px',
+                            marginTop: '1px',
+                          }} />
+                          <div>
+                            <span style={{ fontSize: '13px', fontWeight: 600, color: 'var(--text-strong)', display: 'block' }}>{item.label}</span>
+                            <span style={{ fontSize: '12px', color: 'var(--text-muted)', lineHeight: 1.5 }}>{item.desc}</span>
+                          </div>
+                        </li>
+                      ))}
+                    </ul>
+                  </div>
+
+                  {/* Bloco 3 — O que é o EGOS */}
+                  <div className="card" style={{ padding: '28px' }}>
+                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>03</span>
+                    <h3 className="h3" style={{ marginBottom: '8px' }}>O que é o EGOS</h3>
+                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
+                      EGOS é um framework aberto de <strong style={{ color: 'var(--text-strong)' }}>governança para IA</strong> — método, metaprompts e guardrails que funcionam hoje no ChatGPT, Claude e Gemini. Não é "mais um assistente": é a disciplina que faz a IA ser <strong style={{ color: 'var(--text-strong)' }}>auditável, honesta e segura</strong>. O que está aqui é gratuito e pode ser usado direto.
+                    </p>
+                    <p style={{ fontSize: '12px', fontWeight: 600, color: 'var(--text-strong)', marginBottom: '10px', textTransform: 'uppercase', letterSpacing: '0.05em' }}>O método que você pode levar:</p>
+                    <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 20px 0', display: 'flex', flexDirection: 'column', gap: '8px' }}>
+                      {[
+                        'Protocolo de classificação de certeza (CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO)',
+                        'Protocolo Red Zone (pausa + confirmação humana antes de ação irreversível)',
+                        'Mascaramento PII/LGPD privacy-first (Guard Brasil)',
+                        'Evidence-first (afirmação sem prova = inválida) + eval comportamental',
+                        'Rituais de sessão /start e /end (contexto + evidência)',
+                        'Disciplina SSOT (uma fonte canônica por domínio) + safe-push',
+                      ].map((item, i) => (
+                        <li key={i} style={{ display: 'flex', gap: '8px', fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.5 }}>
+                          <span style={{ color: 'var(--accent)', flexShrink: 0 }}>→</span>
+                          <span>{item}</span>
+                        </li>
+                      ))}
+                    </ul>
+                    <div style={{
+                      background: 'var(--bg-deep)',
+                      border: '1px solid var(--border)',
+                      borderRadius: '8px',
+                      padding: '14px 16px',
+                      marginBottom: '20px',
+                    }}>
+                      <p style={{ fontSize: '12px', color: 'var(--text-muted)', margin: 0, lineHeight: 1.6 }}>
+                        <strong style={{ color: 'var(--text-strong)' }}>Teste de 1 minuto:</strong> depois de configurar o assistente, pergunte a ele:{' '}
+                        <em>"O que muda na sua capacidade agora que você está ativado?"</em>{' '}
+                        A resposta vai mostrar o método EGOS em ação.
+                      </p>
+                    </div>
+                    <a
+                      href="https://github.com/enioxt/egos-governance"
+                      target="_blank"
+                      rel="noopener noreferrer"
+                      className="btn btn-ghost"
+                      style={{ width: '100%', textAlign: 'center' }}
+                    >
+                      Ver no GitHub →
+                    </a>
+                  </div>
+
+                </div>
+              </section>
+
               {/* Transparency badge */}
               <section style={{ margin: '32px 0', textAlign: 'center' }}>
                 <a href="#/transparencia" style={{
diff --git a/docs/_current_handoffs/PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md b/docs/_current_handoffs/PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md
new file mode 100644
index 00000000..77af7b3e
--- /dev/null
+++ b/docs/_current_handoffs/PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md
@@ -0,0 +1,38 @@
+# Sync PRIME → GUARANI — 2026-06-05 (passe de fidelidade visual)
+
+> **Origem:** Prime (Claude Code/Opus) → **Destino:** Guarani (Gemini/Antigravity)
+> **Compartilhamento:** Checkout `/home/enio/egos` (R10: Guarani propõe, Prime commita)
+> **Contexto:** Publicação do Artefato Gratuito v3 (FREE-ARTIFACT-GLANCE-001)
+
+---
+
+## ✅ Status até aqui
+
+1. **egos-governance README** — publicado (`26055df`, pushed). Seção "Comece aqui — grátis em 2 minutos" no topo, antes de "Why This Exists". Conteúdo = artefato v3 completo (metaprompt + checklist + identidade).
+2. **egos.ia.br (apps/egos-landing)** — implementação em andamento pelo agente `pixel`. Seção sendo adicionada na HOME, após "How it works", com botão copy-to-clipboard no metaprompt + visual proof.
+
+## 🔬 Pedido ao Guarani — passe de FIDELIDADE VISUAL
+
+Você já aprovou o **conteúdo** do artefato (handoff `GUARANI_TO_PRIME_2026-06-05_compass-self-discovery.md`, R-PUB-001 ✓). Este passe é diferente: validar que a **renderização na landing** é fiel ao que você aprovou e não introduz ruído.
+
+Checklist proposto (no Antigravity, com o screenshot de visual proof do pixel + o diff de App.tsx):
+
+- [ ] **Fidelidade de conteúdo:** o metaprompt renderizado é byte-igual ao aprovado em `docs/drafts/free-artifact-egos-v0.md` (Parte 1)? Sem truncamento, sem reescrita.
+- [ ] **R-SEC-002 [T0]:** a renderização não vaza nada interno (paths, infra, tokens) — confirmar que o que está na tela é só método compartilhável.
+- [ ] **R-UI-005 / One Job Per Screen:** a seção tem UM trabalho dominante (pegar o metaprompt grátis)? Ou compete visualmente com o Guard Brasil demo / Hero?
+- [ ] **Tom da Voz EGOS:** 3ª pessoa, sóbrio, sem hype — mantido na renderização?
+- [ ] **Descoberta progressiva:** o "teste de 1 minuto" + links (github/egos.ia.br) conduzem à caça-ao-tesouro sem soar como venda?
+
+## 📎 Anexos (entregues pelo pixel)
+
+- **Diff:** `apps/egos-landing/src/App.tsx` (+247 linhas, nova `<section>` entre "How it works" e "Transparency badge"). Ver `git diff -- apps/egos-landing/src/App.tsx`.
+- **Screenshot visual proof:** `/home/enio/.egos/agent-runs/pixel-section-preview.png` (seção renderizada limpa — header "Comece aqui", 3 cards, botão copiar, console limpo).
+- **Build:** `tsc -b` 0 erros + `vite build` OK (65 módulos, 473kB, 250ms).
+- **Infra:** consent gate resolvido permanentemente — `visual_proof_gate` MCP agora seeda `egos_consent_v1` antes do goto (provado em produção: modal sai, hero renderiza). Screenshot da prova: `/home/enio/.egos/agent-runs/consent-seed-proof.png`.
+
+## 🔬 Codex review (em andamento)
+Diff de código (App.tsx + MCP consent fix) está sob review adversarial do Codex em paralelo. Veredito anexado ao commit consolidado.
+
+## 🚦 Decisão
+
+Se o passe do Guarani retornar **APROVADO**, o Prime faz commit consolidado + o deploy para egos.ia.br fica liberado para **HITL do Enio** (deploy.sh nunca roda sem corte do Enio).
diff --git a/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md b/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md
deleted file mode 100644
index dc0cdbb5..00000000
--- a/docs/_current_handoffs/handoff_2026-06-05-ui-observability.md
+++ /dev/null
@@ -1,69 +0,0 @@
-# Handoff — 2026-06-05 12:40 (UI Rules + Observatory + Propósito)
-
-## ✅ Accomplished (com SHAs)
-
-- **Mycelium SVG graph** — `c26573f7` — grafo SVG real com arestas desenhadas + pulsos + click-to-focus + mobile responsivo. Eliminou problema "3 trabalhos competindo numa tela".
-- **UI/Product Rules SSOT** — `b94e86d4` — R-UI-001..006 + R-PUB-001 Flagship Gate em docs/governance/UI_PRODUCT_RULES.md.
-- **CLAUDE.md UI rule** — `b94e86d4` — "UI/Produto [T1]" adicionada a Convenções.
-- **Artefato gratuito v2** — `4f6b7f3e` — Banda+Codex iterated. Aguarda Guarani + HITL Enio.
-- **Bootstrap Agent-C** — `114571c7` — lane escola-viva, pronto para despachar em janela nova.
-- **Estudo Bashar** — `666cf955` — framework secular (excitamento→espelho→premortem).
-- **agent-observatory.ts** — `4b2110e9` — observabilidade multi-agente warn-not-block. LANES + RED_ZONE + error budget. exit 0 sempre.
-- **MULTI_AGENT_OBSERVABILITY.md** — `4b2110e9` — SSOT da política.
-- **Codex model corrigido** — fora de repo — `~/.codex/config.toml`: `gpt-5.3-codex` → `gpt-5.5`. Verificado OK.
-
-## 🔄 In Progress
-
-- **FREE-ARTIFACT-GLANCE-001** — 90% — aguarda Guarani (handoff enviado) + HITL Enio → publicar.
-- **Agent-C dispatch** — bootstrap pronto, execução pendente — colar INIT_AGENT-C em janela nova.
-- **Propósito + Grupo + Pricing** — definidos verbalmente nesta sessão, ainda não commitados em ledger/spec.
-
-## ⏳ Blocked
-
-- **COURSE-PCMG-GATE-001** [P0] — estatuto PCMG sobre pagamentos PF — verificar antes de cobrar.
-- **WA-PRIVACY-POLICY-001** [P0] — política antes de qualquer ingestão WhatsApp.
-- **Pricing R$4** — verbalizado, não registrado — PRICING-FOUNDING-PASS-001 criada.
-
-## 🔗 Next Steps (priority order)
-
-1. [P0] PRICING-FOUNDING-PASS-001 — registrar R$4 (×2) + modelo de grupo em ledger
-2. [P0] FREE-ARTIFACT-GLANCE-001 — Enio glance em docs/drafts/free-artifact-egos-v0.md
-3. [P0] COURSE-PCMG-GATE-001 — verificar estatuto antes de cobrar
-4. [P1] Agent-C dispatch — colar INIT_AGENT-C em janela nova
-5. [P1] OBSERVATORY-WIRE-001 — wire observatory no .husky/post-commit
-6. [P1] KNOWLEDGE-CATALOG-001 — catalogar tudo para definir primeiro material do grupo
-
-## 🌐 Environment State
-
-- Build: ✅ | Tests: N/A | Deploy: egos.ia.br Mycelium live
-- Dispersão: 🔴 (416 commits/7d, 112 scopes — generativa mas alta)
-- TASKS.md: 842L (grace até 2026-06-15)
-
-## 📌 Decisions Made
-
-- Council = diversidade de AGENTE (Opus+Codex+Guarani), não modelo pago via OpenRouter.
-- Warn-not-block: observabilidade nunca trava, só registra e escala.
-- /compass DEFERIDO: consenso aparato — "cura não pode ter a forma da doença".
-- Pricing: R$4 entrada → ×2 progressão. WhatsApp = produto de entrada = acesso completo.
-- Grupo = co-criação: quem está dentro colabora e participa de receita quando projetos avançam.
-- PDF AIOX (João/Hero Base): modelo aplicável — Hero Base→Level 8→Hero Academy = comunidade→escola→publisher.
-
-## ✅ Todos (snapshot)
-
-- [x] Mycelium SVG (`c26573f7`)
-- [x] Regras UI (`b94e86d4`)
-- [x] Artefato v2 (`4f6b7f3e`)
-- [x] Codex corrigido
-- [x] Bootstrap Agent-C (`114571c7`)
-- [x] agent-observatory commitado (`4b2110e9`)
-- [/] FREE-ARTIFACT-GLANCE-001 — aguarda Guarani + HITL
-- [ ] Agent-C dispatchar
-- [ ] OBSERVATORY-WIRE-001
-- [ ] PRICING-FOUNDING-PASS-001
-- [ ] KNOWLEDGE-CATALOG-001
-
-## 🚫 Marked [CONCEPT]
-
-- Pricing ledger R$4 — verbalizado, não commitado
-- Group co-ownership model — descrito verbalmente, não documentado
-- AIOX PDF insights → tasks — lido, ainda não convertido em ações
diff --git a/docs/_current_handoffs/handoff_2026-06-05.md b/docs/_current_handoffs/handoff_2026-06-05.md
deleted file mode 100644
index b42f0f54..00000000
--- a/docs/_current_handoffs/handoff_2026-06-05.md
+++ /dev/null
@@ -1,84 +0,0 @@
-# Handoff — 2026-06-05 (Maratona Fundação EGOS)
-
-## ✅ Accomplished (com SHAs)
-
-### Segurança — INC-PII-001 CONTIDO
-- Dados de investigação real (OP-*) em 3 repos: purgados e verificados — `7736eaa3`
-- Gate R-SEC-001 wired no pre-commit (--staged) + calibrado 239→71 FPs — `8e8dbea4`
-- Sentinela sweep 24/7 (PII_PUBLIC flag crítica) — `a1b8186b`
-- PUBLISH-GATE-001 nos scripts de publicação — `773f6f8f`
-- HITL Telegram: aprovação 1 clique com inline keyboard — `4f7e689f` (deploy VPS `2511f90d`)
-- R-SEC-002/003 em AGENTS.md propagados para 10 leaf repos — `5c22def4`
-
-### Produto — Founding Pass R$2
-- Sistema pricing HITL completo + ledger auditável — `5f0ad7b0`
-- Sales page HTML responsiva — `03215468`
-- Posts prontos (aguardam HITL Telegram aprovação) — `03215468`
-- Análise competitiva 10 cursos + estratégia distribuição 2026 — `7d752ac2`, `9af6f9c6`
-- Instagram setup + X.com @anoineim strategy — `9af6f9c6`
-- Crypto payment guide (endereços pendentes de Enio) — `9af6f9c6`
-- Value matrix honesta R$2/R$8/R$32/R$128 — `84a6fab9`
-
-### Capacidades novas
-- MATERIAL-EVAL-LOOP-001: avalia material com threshold 7.5 e itera — `feccecea`
-- AUTORESEARCH cron VPS wired (toda seg 10h UTC, 9 queries) — `cc6db979`
-- Communication blueprint (Banda+Antigravity+Codex+Exa) — `977c8e86`
-- HOOKS_IDE_COMPATIBILITY.md (tabela paridade por IDE) — `b5fb8eb7`
-- aiox-core analysis completa — `8b6a34a3`
-- gem-hunter improvement plan — `8b6a34a3`
-
-### Curso EGOS
-- Módulo 1 completo + roteiro 45min — `9465899f`
-- Tone guide + intro + mapa de distribuição — `d8be5bd6`, `9465899f`
-- Caso de uso verificável (Cafeteria Santiago 56/56) — `5e7743e0`
-
-## 🔄 In Progress
-- Eval-loop score: 5.5/10 → meta 7.5 (precisa screenshots + caso de uso LangChain comparison)
-- README overhaul baseado no blueprint (task README-OVERHAUL-001 [P0])
-- HITL Telegram: gateway deployado mas path do pending.jsonl requer teste pós-fix
-
-## ⏳ Bloqueados (exigem HITL de Enio)
-- Posts X.com + Instagram: mensagem 2459 pendente no Telegram
-- Endereços cripto: Enio precisa fornecer BTC/ETH/Base/SOL/TRX
-- Criar conta Instagram @egos.ia
-- COURSE-PCMG-GATE-001: verificar estatuto para recebimento
-
-## 🔗 Next Steps (priority)
-1. `COMM-BLUEPRINT-APPLY-001` [P0] — reescrever README com blueprint (8 seções, frase central, tabela hooks)
-2. `METAPROMPTS-DISCOVERY-001` [P1] — implementar 5 camadas de descoberta
-3. `GEM-HUNTER-IMPROVE-001` [P1] — aplicar improvement plan (8 tracks + arXiv + relevance filter)
-4. Gravar Episódio 1 (10min, Google AI Studio demo)
-5. `LLMS-TXT-001` [P1] — arquivo llms.txt em egos.ia.br
-
-## 🌐 Environment State
-- Build: ✅ | Tests: ✅ | Deploy VPS: ✅ healthy
-- Gateway HITL: deployado, path fixed (`/app/data/hitl/`)
-- autoresearch: cron wired VPS toda seg 10h UTC
-- Dispersão: 🔴 (115 scopes, A-stale=0d — sessão foi meta-trabalho justificado)
-
-## 📌 Decisões desta sessão
-- Ficar na PCMG + magistério como vetor seguro de renda (não mudar carreira)
-- Preço fundador R$2 → R$4 → R$8 (HITL em cada, ~5 vendas = sinal)
-- Lifetime access + grupo WhatsApp "EGOS" (privado)
-- aiox-core: referência de README, não concorrente direto
-- EGOS diferencial: governança + LGPD + anti-alucinação (ninguém cobre no BR)
-- Eval-loop como gate antes de subir preço (score ≥ 7.5)
-- Opus arquiteta, Sonnet executa documentação pesada
-
-## 🚫 [CONCEPT] — sem SHA
-- Módulos 2-12 do curso (não escritos)
-- Vídeo gravado do Módulo 1 (não gravado)
-- Kiwify configurado (não configurado)
-- Comunidade WhatsApp ativa (não criada ainda)
-- x402 integration (especificado, não implementado)
-
-## ✅ Todos da sessão (TodoWrite snapshot)
-- [x] Workflow session-sync completou
-- [x] HITL Telegram implementado e deployado
-- [x] Communication blueprint gerado
-- [x] aiox + gem-hunter análise
-- [ ] Enio aprovar posts (Telegram 2459)
-- [ ] Fornecer endereços cripto
-- [ ] Criar Instagram @egos.ia
-- [ ] Gravar Episódio 1
-- [ ] Eval-loop re-run após fixes (meta 7.5)
diff --git a/docs/jobs/2026-06-06-doc-drift-analysis.md b/docs/jobs/2026-06-06-doc-drift-analysis.md
new file mode 100644
index 00000000..00db8ca2
--- /dev/null
+++ b/docs/jobs/2026-06-06-doc-drift-analysis.md
@@ -0,0 +1,21 @@
+# Doc-Drift Pattern Analysis — 2026-06-06
+
+**Period:** 2026-05-01 → 2026-06-05
+**Reports analyzed:** 18
+**Total drift events:** 0
+**Health score:** ✅ 100/100
+**Trend:** ➡️ stable
+
+## Top Drifting Claims
+
+| Claim ID | Drift Count | Repos | Last Drift |
+|----------|-------------|-------|------------|
+| — | 0 | — | — |
+
+## Recommendations
+
+- No drift events found in reports — either all clean or report format not parsed. Verify doc-drift-sentinel output format.
+
+---
+*Generated by doc-drift-analyzer.ts | EGOS Doc-Drift Shield Layer 3.5*
+*Repo: /home/runner/work/egos/egos*
diff --git a/docs/jobs/2026-06-07-doc-drift-analysis.md b/docs/jobs/2026-06-07-doc-drift-analysis.md
new file mode 100644
index 00000000..3224dab5
--- /dev/null
+++ b/docs/jobs/2026-06-07-doc-drift-analysis.md
@@ -0,0 +1,21 @@
+# Doc-Drift Pattern Analysis — 2026-06-07
+
+**Period:** 2026-05-01 → 2026-06-06
+**Reports analyzed:** 19
+**Total drift events:** 0
+**Health score:** ✅ 100/100
+**Trend:** ➡️ stable
+
+## Top Drifting Claims
+
+| Claim ID | Drift Count | Repos | Last Drift |
+|----------|-------------|-------|------------|
+| — | 0 | — | — |
+
+## Recommendations
+
+- No drift events found in reports — either all clean or report format not parsed. Verify doc-drift-sentinel output format.
+
+---
+*Generated by doc-drift-analyzer.ts | EGOS Doc-Drift Shield Layer 3.5*
+*Repo: /home/runner/work/egos/egos*
diff --git a/packages/mcp-browser-automation/src/index.ts b/packages/mcp-browser-automation/src/index.ts
index 87650190..2937ce8d 100644
--- a/packages/mcp-browser-automation/src/index.ts
+++ b/packages/mcp-browser-automation/src/index.ts
@@ -50,6 +50,20 @@ function isAllowed(url: string): boolean {
   } catch { return false; }
 }
 
+// EGOS landing consent gate (LGPD modal) — seed localStorage before navigation
+// so the consent modal doesn't block screenshots. O seed só é gravado em domínios
+// EGOS (ver guarda por hostname no addInitScript), não em github.com etc.
+// SSOT do schema: apps/egos-landing/src/lib/consent.ts (CONSENT_KEY = egos_consent_v1).
+// Espelha scripts/visual-audit.ts. timestamp é gerado fresh por chamada (não no load).
+function egosConsentSeed(): string {
+  return JSON.stringify({
+    version: "1.0.0",
+    timestamp: new Date().toISOString(),
+    choices: { analytics: false, sentry: false, ai_context: false, registration: false, history: false },
+    history: [],
+  });
+}
+
 const server = new McpServer(
   { name: "egos-browser", version: "0.1.0" },
   { capabilities: { tools: {} } }
@@ -181,6 +195,17 @@ server.registerTool(
         await page.setViewportSize(viewport);
         const consoleErrors: string[] = [];
         page.on("console", msg => { if (msg.type() === "error") consoleErrors.push(msg.text()); });
+        // Seed the EGOS consent gate before navigation so the LGPD modal
+        // doesn't cover the screenshot. Runs before any page script. O seed só
+        // é gravado em domínios EGOS (guarda por hostname) — não polui github.com etc.
+        await page.addInitScript((seed: string) => {
+          try {
+            const h = location.hostname;
+            if (h.endsWith("egos.ia.br") || h === "egos.ia.br" || h === "localhost" || h === "127.0.0.1") {
+              localStorage.setItem("egos_consent_v1", seed);
+            }
+          } catch { /* noop — storage indisponível */ }
+        }, egosConsentSeed());
         await page.goto(url, { waitUntil: "networkidle", timeout: 30000 });
         const title = await page.title();
         const screenshot = await page.screenshot({ fullPage: false });

exec
/bin/bash -lc "sed -n '1,140p' apps/egos-landing/src/lib/consent.ts && sed -n '1,280p' packages/mcp-browser-automation/src/index.ts" in /home/enio/egos
exec
/bin/bash -lc 'cat apps/egos-landing/package.json 2>/dev/null; cat packages/mcp-browser-automation/package.json' in /home/enio/egos
 succeeded in 210ms:
// Consent state management — localStorage only (no cookies, no server)
// LGPD Art. 8: consent must be specific, informed, unambiguous, and revocable
// Spec: docs/strategy/CONSENT_UX_SPEC.md

export interface ConsentChoices {
  analytics: boolean
  sentry: boolean
  ai_context: boolean
  registration: boolean
  history: boolean
}

export interface ConsentEvent {
  ts: string
  action: 'set' | 'revoke' | 'export' | 'delete_requested'
  field?: keyof ConsentChoices
  value?: boolean
}

export interface ConsentState {
  version: string
  timestamp: string
  choices: ConsentChoices
  history: ConsentEvent[]
}

export const CONSENT_VERSION = '1.0.0'
const CONSENT_KEY = 'egos_consent_v1'

export const DEFAULT_CHOICES: ConsentChoices = {
  analytics: false,
  sentry: false,
  ai_context: false,
  registration: false,
  history: false,
}

export function loadConsent(): ConsentState | null {
  try {
    const raw = localStorage.getItem(CONSENT_KEY)
    if (!raw) return null
    const parsed = JSON.parse(raw) as ConsentState
    if (parsed.version !== CONSENT_VERSION) return null
    return parsed
  } catch {
    return null
  }
}

export function saveConsent(choices: ConsentChoices): ConsentState {
  const prev = loadConsent()
  const now = new Date().toISOString()
  const state: ConsentState = {
    version: CONSENT_VERSION,
    timestamp: now,
    choices,
    history: [...(prev?.history ?? []), { ts: now, action: 'set' }],
  }
  localStorage.setItem(CONSENT_KEY, JSON.stringify(state))
  return state
}

export function updateConsentField(
  field: keyof ConsentChoices,
  value: boolean
): ConsentState {
  const current = loadConsent()
  const choices = { ...(current?.choices ?? DEFAULT_CHOICES), [field]: value }
  const now = new Date().toISOString()
  const state: ConsentState = {
    version: CONSENT_VERSION,
    timestamp: current?.timestamp ?? now,
    choices,
    history: [
      ...(current?.history ?? []),
      { ts: now, action: value ? 'set' : 'revoke', field, value },
    ],
  }
  localStorage.setItem(CONSENT_KEY, JSON.stringify(state))
  return state
}

export function clearConsent(): void {
  localStorage.removeItem(CONSENT_KEY)
}

export function getActiveCount(choices: ConsentChoices): number {
  return Object.values(choices).filter(Boolean).length
}

export function getActiveLabels(choices: ConsentChoices): string[] {
  const labels: Record<keyof ConsentChoices, string> = {
    analytics: 'analytics',
    sentry: 'erros',
    ai_context: 'chatbot',
    registration: 'conta',
    history: 'histórico',
  }
  return (Object.entries(choices) as [keyof ConsentChoices, boolean][])
    .filter(([, v]) => v)
    .map(([k]) => labels[k])
}
#!/usr/bin/env bun
/**
 * @egos/mcp-browser-automation v0.1.0 (MCP-NEW-003)
 *
 * MCP Server — Browser automation + Visual Proof Gate.
 * Codex MCP-FIX-007 topologia: isolado (Playwright pesado + recursos separados).
 *
 * Tools:
 * - check_url: HTTP HEAD check com timing (sem browser)
 * - fetch_page: Fetch HTML de URL allowlisted
 * - visual_proof_gate: ⚠️  Requer Playwright (graceful skip se ausente)
 * - screenshot_url: ⚠️  Requer Playwright
 * - check_console_clean: ⚠️  Requer Playwright
 *
 * Playwright é optionalDependency — tools funcionam em 2 modos:
 *   1. Sem Playwright: tools de fetch/check funcionam, visual proof = warn-only
 *   2. Com Playwright: full visual proof + screenshot
 *
 * SSOT: docs/governance/MCP_ARCHITECTURE_DECISIONS.md §6 (maturity)
 * Connect: { "mcpServers": { "egos-browser": { "command": "bun", "args": ["packages/mcp-browser-automation/src/index.ts"] } } }
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { trackMcpTool } from "@egos/shared/mcp-audit-lite";

const MCP_NAME = "egos-browser";

// Detect Playwright availability
let playwrightAvailable = false;
try {
  const { chromium } = await import("playwright");
  await chromium.executablePath();
  playwrightAvailable = true;
} catch {
  // Playwright not installed — degrade gracefully
}

// SSRF allowlist (same as mcp-ops)
const WEB_ALLOWLIST = [
  "gpecas.egos.ia.br", "intelink.ia.br", "egos.ia.br", "lab.egos.ia.br",
  "chatbot.egos.ia.br", "hq.egos.ia.br", "github.com", "api.github.com",
];

function isAllowed(url: string): boolean {
  try {
    const u = new URL(url);
    return u.protocol === "https:" && WEB_ALLOWLIST.some(d => u.hostname === d || u.hostname.endsWith("." + d));
  } catch { return false; }
}

// EGOS landing consent gate (LGPD modal) — seed localStorage before navigation
// so the consent modal doesn't block screenshots. O seed só é gravado em domínios
// EGOS (ver guarda por hostname no addInitScript), não em github.com etc.
// SSOT do schema: apps/egos-landing/src/lib/consent.ts (CONSENT_KEY = egos_consent_v1).
// Espelha scripts/visual-audit.ts. timestamp é gerado fresh por chamada (não no load).
function egosConsentSeed(): string {
  return JSON.stringify({
    version: "1.0.0",
    timestamp: new Date().toISOString(),
    choices: { analytics: false, sentry: false, ai_context: false, registration: false, history: false },
    history: [],
  });
}

const server = new McpServer(
  { name: "egos-browser", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

// ── Tool 1: check_url ──────────────────────────────────────────────────────
server.registerTool(
  "check_url",
  {
    description: "HTTP HEAD check com timing e status. Allowlist-protected. Sem browser necessário.",
    inputSchema: {
      url: z.string().url(),
      expected_status: z.number().optional().describe("Expected HTTP status (default: 200)"),
    } as any,
  },
  (async ({ url, expected_status = 200 }: { url: string; expected_status?: number }) => {
    return trackMcpTool(MCP_NAME, "check_url", async () => {
      if (!isAllowed(url)) {
        return { content: [{ type: "text", text: JSON.stringify({ error: "URL not in allowlist", url }) }] };
      }
      const t0 = Date.now();
      try {
        const res = await fetch(url, { method: "HEAD", signal: AbortSignal.timeout(10000) });
        const ok = res.status === expected_status;
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              url, status: res.status, ok, expected_status,
              duration_ms: Date.now() - t0,
              content_type: res.headers.get("content-type"),
            }, null, 2),
          }],
        };
      } catch (err) {
        return { content: [{ type: "text", text: JSON.stringify({ error: (err as Error).message, url, duration_ms: Date.now() - t0 }) }] };
      }
    });
  }) as any
);

// ── Tool 2: fetch_page ─────────────────────────────────────────────────────
server.registerTool(
  "fetch_page",
  {
    description: "Fetch HTML de URL allowlisted (sem browser). Trunca a 8KB.",
    inputSchema: { url: z.string().url() } as any,
  },
  (async ({ url }: { url: string }) => {
    return trackMcpTool(MCP_NAME, "fetch_page", async () => {
      if (!isAllowed(url)) {
        return { content: [{ type: "text", text: JSON.stringify({ error: "URL not in allowlist" }) }] };
      }
      try {
        const res = await fetch(url, { signal: AbortSignal.timeout(10000) });
        const html = await res.text();
        const truncated = html.slice(0, 8000);
        return {
          content: [{
            type: "text",
            text: JSON.stringify({ url, status: res.status, html: truncated, truncated: html.length > 8000 }, null, 2),
          }],
        };
      } catch (err) {
        return { content: [{ type: "text", text: JSON.stringify({ error: (err as Error).message }) }] };
      }
    });
  }) as any
);

// ── Tool 3: check_playwright ───────────────────────────────────────────────
server.registerTool(
  "check_playwright",
  {
    description: "Verifica disponibilidade do Playwright para visual proof.",
    inputSchema: {} as any,
  },
  (async () => {
    return trackMcpTool(MCP_NAME, "check_playwright", async () => ({
      content: [{
        type: "text",
        text: JSON.stringify({
          playwright_available: playwrightAvailable,
          visual_proof_capable: playwrightAvailable,
          message: playwrightAvailable
            ? "Playwright ready — screenshot e visual proof disponíveis"
            : "Playwright não instalado — usar: bun add playwright && bunx playwright install chromium. Ferramentas HTTP funcionam sem Playwright.",
          install_cmd: "bun add playwright && bunx playwright install chromium --with-deps",
        }, null, 2),
      }],
    }));
  }) as any
);

// ── Tool 4: visual_proof_gate ──────────────────────────────────────────────
server.registerTool(
  "visual_proof_gate",
  {
    description: "Visual Proof Gate — screenshot + console clean check. Requer Playwright. Karpathy Doctrine: HTTP 200 ≠ prova.",
    inputSchema: {
      url: z.string().url(),
      viewport: z.object({ width: z.number(), height: z.number() }).optional()
        .describe("Viewport (default: 375x812 mobile-first)"),
    } as any,
  },
  (async ({ url, viewport = { width: 375, height: 812 } }: { url: string; viewport?: { width: number; height: number } }) => {
    return trackMcpTool(MCP_NAME, "visual_proof_gate", async () => {
      if (!isAllowed(url)) {
        return { content: [{ type: "text", text: JSON.stringify({ error: "URL not in allowlist" }) }] };
      }
      if (!playwrightAvailable) {
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              visual_proof: false,
              reason: "Playwright não instalado — visual proof indisponível",
              fallback: "HTTP check funciona",
              install: "bun add playwright && bunx playwright install chromium",
            }, null, 2),
          }],
        };
      }
      // Playwright path (only reached if available)
      try {
        const { chromium } = await import("playwright");
        const browser = await chromium.launch({ headless: true });
        const page = await browser.newPage();
        await page.setViewportSize(viewport);
        const consoleErrors: string[] = [];
        page.on("console", msg => { if (msg.type() === "error") consoleErrors.push(msg.text()); });
        // Seed the EGOS consent gate before navigation so the LGPD modal
        // doesn't cover the screenshot. Runs before any page script. O seed só
        // é gravado em domínios EGOS (guarda por hostname) — não polui github.com etc.
        await page.addInitScript((seed: string) => {
          try {
            const h = location.hostname;
            if (h.endsWith("egos.ia.br") || h === "egos.ia.br" || h === "localhost" || h === "127.0.0.1") {
              localStorage.setItem("egos_consent_v1", seed);
            }
          } catch { /* noop — storage indisponível */ }
        }, egosConsentSeed());
        await page.goto(url, { waitUntil: "networkidle", timeout: 30000 });
        const title = await page.title();
        const screenshot = await page.screenshot({ fullPage: false });
        await browser.close();
        const proof = consoleErrors.length === 0;
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              url, title, visual_proof: proof,
              console_errors: consoleErrors,
              viewport,
              screenshot_bytes: screenshot.length,
              note: "Screenshot disponível — use resources para acesso binário",
            }, null, 2),
          }],
        };
      } catch (err) {
        return { content: [{ type: "text", text: JSON.stringify({ error: (err as Error).message }) }] };
      }
    });
  }) as any
);

// ── Tool 5: check_links ────────────────────────────────────────────────────
server.registerTool(
  "check_links",
  {
    description: "Verifica links em uma página HTML (sem browser, via fetch).",
    inputSchema: {
      url: z.string().url(),
      max_links: z.number().optional().describe("Max links to check (default: 20)"),
    } as any,
  },
  (async ({ url, max_links = 20 }: { url: string; max_links?: number }) => {
    return trackMcpTool(MCP_NAME, "check_links", async () => {
      if (!isAllowed(url)) {
        return { content: [{ type: "text", text: JSON.stringify({ error: "URL not in allowlist" }) }] };
      }
      try {
        const res = await fetch(url, { signal: AbortSignal.timeout(10000) });
        const html = await res.text();
        const links = [...html.matchAll(/href=["']([^"'#]+)["']/g)]
          .map(m => m[1])
          .filter(l => l.startsWith("http"))
          .slice(0, max_links);
        const results: Array<{ url: string; status?: number; ok: boolean; error?: string }> = [];
        for (const link of links) {
          try {
            const r = await fetch(link, { method: "HEAD", signal: AbortSignal.timeout(5000) });
            results.push({ url: link, status: r.status, ok: r.ok });
          } catch (e) {
            results.push({ url: link, ok: false, error: (e as Error).message.slice(0, 50) });
          }
        }
        const broken = results.filter(r => !r.ok).length;
        return {
          content: [{
            type: "text",
            text: JSON.stringify({ url, total: results.length, broken, results }, null, 2),
          }],
        };
      } catch (err) {
        return { content: [{ type: "text", text: JSON.stringify({ error: (err as Error).message }) }] };
      }
    });
  }) as any
);

// ── Bootstrap ──────────────────────────────────────────────────────────────
const transport = new StdioServerTransport();
await server.connect(transport);

 succeeded in 202ms:
{
  "name": "egos-landing",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "bun run scripts/generate-rss.ts && tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.107.0",
    "react": "^19.2.6",
    "react-dom": "^19.2.6"
  },
  "devDependencies": {
    "@eslint/js": "^10.0.1",
    "@types/node": "^24.12.3",
    "@types/react": "^19.2.14",
    "@types/react-dom": "^19.2.3",
    "@vitejs/plugin-react": "^6.0.1",
    "eslint": "^10.3.0",
    "eslint-plugin-react-hooks": "^7.1.1",
    "eslint-plugin-react-refresh": "^0.5.2",
    "globals": "^17.6.0",
    "typescript": "~6.0.2",
    "typescript-eslint": "^8.59.2",
    "vite": "^8.0.12"
  }
}
{
  "name": "@egos/mcp-browser-automation",
  "version": "0.1.0",
  "description": "EGOS MCP Server — Browser automation + Visual Proof Gate (MCP-NEW-003)",
  "type": "module",
  "private": true,
  "main": "src/index.ts",
  "bin": { "egos-mcp-browser": "src/index.ts" },
  "scripts": {
    "start": "bun run src/index.ts",
    "typecheck": "tsc --noEmit -p tsconfig.json"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.29.0",
    "@egos/shared": "workspace:*",
    "zod": "^3.23.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "typescript": "^5.4.0"
  },
  "optionalDependencies": {
    "playwright": "^1.44.0"
  }
}

exec
/bin/bash -lc 'bun --filter egos-landing build' in /home/enio/egos
 succeeded in 7011ms:
egos-landing build: 📡 Buscando artigos no Supabase para gerar o RSS feed...
egos-landing build: ✅ RSS feed gerado com sucesso em public/timeline/rss!
egos-landing build: vite v8.0.16 building client environment for production...
egos-landing build: [2Ktransforming...✓ 65 modules transformed.
egos-landing build: rendering chunks...
egos-landing build: computing gzip size...
egos-landing build: dist/index.html                   1.06 kB │ gzip:   0.58 kB
egos-landing build: dist/assets/index-B66jEp7s.css    7.12 kB │ gzip:   2.12 kB
egos-landing build: dist/assets/index-CfUI-qhf.js   473.16 kB │ gzip: 131.79 kB
egos-landing build: 
egos-landing build: ✓ built in 254ms
egos-landing build: Exited with code 0

exec
/bin/bash -lc 'bun --filter @egos/mcp-browser-automation typecheck' in /home/enio/egos
 exited 2 in 411ms:
@egos/mcp-browser-automation typecheck: error TS18003: No inputs were found in config file '/home/enio/egos/packages/mcp-browser-automation/tsconfig.json'. Specified 'include' paths were '["src/**/*"]' and 'exclude' paths were '["../../node_modules","../../dist","../../**/*.test.ts","../../packages/core/src/auth","../../packages/audit/src/activation-audit.ts","../../packages/shared/src/mcp-audit-handler.ts","../../packages/mcp-memory","../../packages/mcp-bridge","../../packages/mcp-browser-automation","../../packages/mcp-eval-runner","../../packages/mcp-g-pecas","../../packages/mcp-governance","../../packages/mcp-observability","../../packages/mcp-ops","../../packages/mcp-security","../../packages/mcp-skills-registry","../../packages/mcp-literature","../../packages/knowledge-mcp","../../packages/guard-brasil-langchain","../../packages/guard-brasil-python","../../packages/shared/src/intelink-llm-router.ts"]'.
@egos/mcp-browser-automation typecheck: Exited with code 2

exec
/bin/bash -lc "sed -n '280,520p' packages/mcp-browser-automation/src/index.ts && nl -ba apps/egos-landing/src/App.tsx | sed -n '140,210p;600,860p' && nl -ba packages/mcp-browser-automation/src/index.ts | sed -n '45,75p;190,215p'" in /home/enio/egos
 succeeded in 135ms:
await server.connect(transport);
   140	  const [keyLoading, setKeyLoading] = useState(false)
   141	  const [keyError, setKeyError] = useState('')
   142	  
   143	  const [inspectInput, setInspectInput] = useState('')
   144	  const [inspectLoading, setInspectLoading] = useState(false)
   145	  const [inspectResult, setInspectResult] = useState<any>(null)
   146	  const [inspectError, setInspectError] = useState('')
   147	
   148	  // Grok Hunter State
   149	  const [grokTopic, setGrokTopic] = useState('')
   150	  const [grokPrompt, setGrokPrompt] = useState('')
   151	  const [grokLoading, setGrokLoading] = useState(false)
   152	
   153	  // Free Artifact — metaprompt copy button state
   154	  const [copied, setCopied] = useState(false)
   155	  const copyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
   156	  useEffect(() => () => { if (copyTimerRef.current) clearTimeout(copyTimerRef.current) }, [])
   157	
   158	  // Handlers for dynamic actions
   159	  const handleGenerateKey = async () => {
   160	    if (!keyName.trim() || !keyEmail.trim()) return
   161	    setKeyLoading(true)
   162	    setKeyError('')
   163	    try {
   164	      const res = await fetch('https://api.egos.ia.br/v1/keys', {
   165	        method: 'POST',
   166	        headers: { 'Content-Type': 'application/json' },
   167	        body: JSON.stringify({ name: keyName.trim(), email: keyEmail.trim() })
   168	      })
   169	      const data = await res.json()
   170	      if (!res.ok) throw new Error(data.error || 'Erro ao gerar chave')
   171	      setApiKey(data.key)
   172	      localStorage.setItem('guard_api_key', data.key)
   173	    } catch (err: any) {
   174	      setKeyError(err.message || 'Erro ao gerar chave')
   175	    } finally {
   176	      setKeyLoading(false)
   177	    }
   178	  }
   179	
   180	  const handleInspectText = async () => {
   181	    if (!inspectInput.trim()) return
   182	    setInspectLoading(true)
   183	    setInspectError('')
   184	    setInspectResult(null)
   185	    try {
   186	      const headers: Record<string, string> = { 'Content-Type': 'application/json' }
   187	      if (apiKey) {
   188	        headers['Authorization'] = `Bearer ${apiKey}`
   189	      }
   190	      const res = await fetch('https://api.egos.ia.br/v1/inspect', {
   191	        method: 'POST',
   192	        headers,
   193	        body: JSON.stringify({ content: inspectInput })
   194	      })
   195	      const data = await res.json()
   196	      if (!res.ok) throw new Error(data.error || 'Erro na inspeção')
   197	      setInspectResult(data)
   198	    } catch (err: any) {
   199	      setInspectError(err.message || 'Erro de rede ou permissão')
   200	    } finally {
   201	      setInspectLoading(false)
   202	    }
   203	  }
   204	
   205	  const handleGenerateGrokPrompt = async () => {
   206	    if (!grokTopic.trim()) return
   207	    setGrokLoading(true)
   208	    try {
   209	      const res = await fetch('https://api.egos.ia.br/api/v1/meta-prompts/generate', {
   210	        method: 'POST',
   600	                  </div>
   601	                  <div className="card" style={{ padding: '28px' }}>
   602	                    <div style={{ fontSize: '28px', marginBottom: '12px' }}>⚙️</div>
   603	                    <h3 className="h3" style={{ marginBottom: '8px' }}>Camada de Ferramentas</h3>
   604	                    <p style={{ fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
   605	                      MCPs, Guard Brasil (PII), eval-runner com casos dourados, e pipelines auditáveis. Cada capability tem evidência — stub sem teste é code morto.
   606	                    </p>
   607	                  </div>
   608	                </div>
   609	              </section>
   610	
   611	              {/* ── Comece aqui — grátis em 2 minutos ── */}
   612	              <section style={{ margin: '56px 0' }}>
   613	                <div style={{ textAlign: 'center', marginBottom: '40px' }}>
   614	                  <span className="eyebrow" style={{ display: 'block', marginBottom: '12px' }}>Grátis — leva 2 minutos</span>
   615	                  <h2 className="h2">Comece aqui</h2>
   616	                  <p className="body-l muted" style={{ maxWidth: '560px', margin: '12px auto 0' }}>
   617	                    Três artefatos prontos para usar hoje no ChatGPT, Claude ou Gemini.
   618	                  </p>
   619	                </div>
   620	
   621	                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '24px', alignItems: 'start' }}>
   622	
   623	                  {/* Bloco 1 — Metaprompt */}
   624	                  <div className="card" style={{ padding: '28px' }}>
   625	                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>01</span>
   626	                    <h3 className="h3" style={{ marginBottom: '8px' }}>Metaprompt: Assistente Profissional Governado</h3>
   627	                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
   628	                      Cole no campo de instruções do ChatGPT (ou system prompt do Claude/Gemini) e troque os <code style={{ background: 'var(--bg-deep)', padding: '1px 4px', borderRadius: '3px' }}>[colchetes]</code>. Pronto.
   629	                    </p>
   630	                    <div style={{
   631	                      position: 'relative',
   632	                      background: 'var(--bg-deep)',
   633	                      border: '1px solid var(--border)',
   634	                      borderRadius: '8px',
   635	                      marginBottom: '12px',
   636	                    }}>
   637	                      <pre style={{
   638	                        fontFamily: 'monospace',
   639	                        fontSize: '12px',
   640	                        color: 'var(--text-muted)',
   641	                        lineHeight: 1.6,
   642	                        padding: '16px',
   643	                        maxHeight: '300px',
   644	                        overflowY: 'auto',
   645	                        whiteSpace: 'pre-wrap',
   646	                        wordBreak: 'break-word',
   647	                        margin: 0,
   648	                      }}>{`Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
   649	Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
   650	
   651	Atua exclusivamente em:
   652	- [Área 1]  - [Área 2]  - [Área 3]
   653	Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
   654	
   655	── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
   656	Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
   657	Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
   658	Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
   659	Fluxo obrigatório:
   660	1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
   661	2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
   662	3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
   663	4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
   664	NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
   665	
   666	── CLASSIFICAÇÃO OBRIGATÓRIA ──
   667	Classifique afirmações relevantes como:
   668	- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
   669	- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
   670	
   671	── ANTI-ALUCINAÇÃO ──
   672	Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
   673	Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
   674	Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
   675	
   676	── PROTEÇÃO DE DADOS ──
   677	Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
   678	Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
   679	
   680	── ZONA VERMELHA (pause antes) ──
   681	Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
   682	Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
   683	
   684	── LIMITAÇÕES ──
   685	Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
   686	
   687	── CRITÉRIO DE EVIDÊNCIA ──
   688	Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
   689	
   690	── MODO DE RESPOSTA ──
   691	Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
   692	
   693	── FORMATO DE SAÍDA ──
   694	Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
   695	Síntese: [resposta direta]
   696	Evidências: [fontes/dados/base lógica]
   697	Riscos: [se houver]
   698	Próxima ação: [recomendação objetiva]
   699	
   700	── REGRA FINAL ──
   701	Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`}</pre>
   702	                    </div>
   703	                    <button
   704	                      onClick={() => {
   705	                        const metaprompt = `Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
   706	Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
   707	
   708	Atua exclusivamente em:
   709	- [Área 1]  - [Área 2]  - [Área 3]
   710	Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
   711	
   712	── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
   713	Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
   714	Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
   715	Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
   716	Fluxo obrigatório:
   717	1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
   718	2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
   719	3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
   720	4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
   721	NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
   722	
   723	── CLASSIFICAÇÃO OBRIGATÓRIA ──
   724	Classifique afirmações relevantes como:
   725	- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
   726	- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
   727	
   728	── ANTI-ALUCINAÇÃO ──
   729	Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
   730	Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
   731	Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
   732	
   733	── PROTEÇÃO DE DADOS ──
   734	Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
   735	Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
   736	
   737	── ZONA VERMELHA (pause antes) ──
   738	Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
   739	Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
   740	
   741	── LIMITAÇÕES ──
   742	Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
   743	
   744	── CRITÉRIO DE EVIDÊNCIA ──
   745	Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
   746	
   747	── MODO DE RESPOSTA ──
   748	Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
   749	
   750	── FORMATO DE SAÍDA ──
   751	Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
   752	Síntese: [resposta direta]
   753	Evidências: [fontes/dados/base lógica]
   754	Riscos: [se houver]
   755	Próxima ação: [recomendação objetiva]
   756	
   757	── REGRA FINAL ──
   758	Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.`
   759	                        if (copyTimerRef.current) clearTimeout(copyTimerRef.current)
   760	                        navigator.clipboard.writeText(metaprompt).then(() => {
   761	                          setCopied(true)
   762	                          copyTimerRef.current = setTimeout(() => setCopied(false), 2000)
   763	                        }).catch(() => setCopied(false))
   764	                      }}
   765	                      className="btn btn-primary"
   766	                      style={{ width: '100%' }}
   767	                    >
   768	                      {copied ? 'Copiado!' : '📋 Copiar metaprompt'}
   769	                    </button>
   770	                  </div>
   771	
   772	                  {/* Bloco 2 — Checklist */}
   773	                  <div className="card" style={{ padding: '28px' }}>
   774	                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>02</span>
   775	                    <h3 className="h3" style={{ marginBottom: '8px' }}>Checklist: Segurança de IA em 1 Página</h3>
   776	                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '20px', lineHeight: 1.6 }}>
   777	                      Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.
   778	                    </p>
   779	                    <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: '14px' }}>
   780	                      {[
   781	                        { label: 'Dado real só com necessidade', desc: '"o LLM precisa deste dado ou posso descrever o padrão?"' },
   782	                        { label: 'PII mascarada antes de colar', desc: 'CPF/nome/processo → [NOME], [CPF], [PROCESSO].' },
   783	                        { label: 'LLM externo ≠ ambiente sigiloso', desc: 'É servidor de terceiro; sigilo profissional → verifique ToS ou use modelo local.' },
   784	                        { label: 'Output de IA é INFERIDO', desc: 'Número/data/citação gerada precisa de verificação independente antes de usar.' },
   785	                        { label: 'Nunca cole credenciais', desc: 'Senhas, tokens, chaves, certificados fora do prompt.' },
   786	                        { label: 'Histórico tem memória', desc: 'Usou dado sensível? Limpe depois; verifique se a conta não treina com seus dados.' },
   787	                        { label: 'Releia antes de publicar', desc: 'Alucinação de IA é confiante; leia com o olho de quem recebe.' },
   788	                      ].map((item, i) => (
   789	                        <li key={i} style={{ display: 'flex', gap: '10px', alignItems: 'flex-start' }}>
   790	                          <span style={{
   791	                            flexShrink: 0,
   792	                            width: '20px', height: '20px',
   793	                            border: '2px solid var(--accent)',
   794	                            borderRadius: '4px',
   795	                            marginTop: '1px',
   796	                          }} />
   797	                          <div>
   798	                            <span style={{ fontSize: '13px', fontWeight: 600, color: 'var(--text-strong)', display: 'block' }}>{item.label}</span>
   799	                            <span style={{ fontSize: '12px', color: 'var(--text-muted)', lineHeight: 1.5 }}>{item.desc}</span>
   800	                          </div>
   801	                        </li>
   802	                      ))}
   803	                    </ul>
   804	                  </div>
   805	
   806	                  {/* Bloco 3 — O que é o EGOS */}
   807	                  <div className="card" style={{ padding: '28px' }}>
   808	                    <span className="chip" style={{ marginBottom: '12px', display: 'inline-block' }}>03</span>
   809	                    <h3 className="h3" style={{ marginBottom: '8px' }}>O que é o EGOS</h3>
   810	                    <p style={{ fontSize: '13px', color: 'var(--text-muted)', marginBottom: '16px', lineHeight: 1.6 }}>
   811	                      EGOS é um framework aberto de <strong style={{ color: 'var(--text-strong)' }}>governança para IA</strong> — método, metaprompts e guardrails que funcionam hoje no ChatGPT, Claude e Gemini. Não é "mais um assistente": é a disciplina que faz a IA ser <strong style={{ color: 'var(--text-strong)' }}>auditável, honesta e segura</strong>. O que está aqui é gratuito e pode ser usado direto.
   812	                    </p>
   813	                    <p style={{ fontSize: '12px', fontWeight: 600, color: 'var(--text-strong)', marginBottom: '10px', textTransform: 'uppercase', letterSpacing: '0.05em' }}>O método que você pode levar:</p>
   814	                    <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 20px 0', display: 'flex', flexDirection: 'column', gap: '8px' }}>
   815	                      {[
   816	                        'Protocolo de classificação de certeza (CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO)',
   817	                        'Protocolo Red Zone (pausa + confirmação humana antes de ação irreversível)',
   818	                        'Mascaramento PII/LGPD privacy-first (Guard Brasil)',
   819	                        'Evidence-first (afirmação sem prova = inválida) + eval comportamental',
   820	                        'Rituais de sessão /start e /end (contexto + evidência)',
   821	                        'Disciplina SSOT (uma fonte canônica por domínio) + safe-push',
   822	                      ].map((item, i) => (
   823	                        <li key={i} style={{ display: 'flex', gap: '8px', fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.5 }}>
   824	                          <span style={{ color: 'var(--accent)', flexShrink: 0 }}>→</span>
   825	                          <span>{item}</span>
   826	                        </li>
   827	                      ))}
   828	                    </ul>
   829	                    <div style={{
   830	                      background: 'var(--bg-deep)',
   831	                      border: '1px solid var(--border)',
   832	                      borderRadius: '8px',
   833	                      padding: '14px 16px',
   834	                      marginBottom: '20px',
   835	                    }}>
   836	                      <p style={{ fontSize: '12px', color: 'var(--text-muted)', margin: 0, lineHeight: 1.6 }}>
   837	                        <strong style={{ color: 'var(--text-strong)' }}>Teste de 1 minuto:</strong> depois de configurar o assistente, pergunte a ele:{' '}
   838	                        <em>"O que muda na sua capacidade agora que você está ativado?"</em>{' '}
   839	                        A resposta vai mostrar o método EGOS em ação.
   840	                      </p>
   841	                    </div>
   842	                    <a
   843	                      href="https://github.com/enioxt/egos-governance"
   844	                      target="_blank"
   845	                      rel="noopener noreferrer"
   846	                      className="btn btn-ghost"
   847	                      style={{ width: '100%', textAlign: 'center' }}
   848	                    >
   849	                      Ver no GitHub →
   850	                    </a>
   851	                  </div>
   852	
   853	                </div>
   854	              </section>
   855	
   856	              {/* Transparency badge */}
   857	              <section style={{ margin: '32px 0', textAlign: 'center' }}>
   858	                <a href="#/transparencia" style={{
   859	                  display: 'inline-flex', alignItems: 'center', gap: '8px',
   860	                  padding: '10px 18px', borderRadius: '20px',
    45	
    46	function isAllowed(url: string): boolean {
    47	  try {
    48	    const u = new URL(url);
    49	    return u.protocol === "https:" && WEB_ALLOWLIST.some(d => u.hostname === d || u.hostname.endsWith("." + d));
    50	  } catch { return false; }
    51	}
    52	
    53	// EGOS landing consent gate (LGPD modal) — seed localStorage before navigation
    54	// so the consent modal doesn't block screenshots. O seed só é gravado em domínios
    55	// EGOS (ver guarda por hostname no addInitScript), não em github.com etc.
    56	// SSOT do schema: apps/egos-landing/src/lib/consent.ts (CONSENT_KEY = egos_consent_v1).
    57	// Espelha scripts/visual-audit.ts. timestamp é gerado fresh por chamada (não no load).
    58	function egosConsentSeed(): string {
    59	  return JSON.stringify({
    60	    version: "1.0.0",
    61	    timestamp: new Date().toISOString(),
    62	    choices: { analytics: false, sentry: false, ai_context: false, registration: false, history: false },
    63	    history: [],
    64	  });
    65	}
    66	
    67	const server = new McpServer(
    68	  { name: "egos-browser", version: "0.1.0" },
    69	  { capabilities: { tools: {} } }
    70	);
    71	
    72	// ── Tool 1: check_url ──────────────────────────────────────────────────────
    73	server.registerTool(
    74	  "check_url",
    75	  {
   190	      // Playwright path (only reached if available)
   191	      try {
   192	        const { chromium } = await import("playwright");
   193	        const browser = await chromium.launch({ headless: true });
   194	        const page = await browser.newPage();
   195	        await page.setViewportSize(viewport);
   196	        const consoleErrors: string[] = [];
   197	        page.on("console", msg => { if (msg.type() === "error") consoleErrors.push(msg.text()); });
   198	        // Seed the EGOS consent gate before navigation so the LGPD modal
   199	        // doesn't cover the screenshot. Runs before any page script. O seed só
   200	        // é gravado em domínios EGOS (guarda por hostname) — não polui github.com etc.
   201	        await page.addInitScript((seed: string) => {
   202	          try {
   203	            const h = location.hostname;
   204	            if (h.endsWith("egos.ia.br") || h === "egos.ia.br" || h === "localhost" || h === "127.0.0.1") {
   205	              localStorage.setItem("egos_consent_v1", seed);
   206	            }
   207	          } catch { /* noop — storage indisponível */ }
   208	        }, egosConsentSeed());
   209	        await page.goto(url, { waitUntil: "networkidle", timeout: 30000 });
   210	        const title = await page.title();
   211	        const screenshot = await page.screenshot({ fullPage: false });
   212	        await browser.close();
   213	        const proof = consoleErrors.length === 0;
   214	        return {
   215	          content: [{

exec
/bin/bash -lc "sed -n '1,220p' apps/egos-landing/src/components/ConsentGate.tsx && sed -n '1,160p' scripts/visual-audit.ts" in /home/enio/egos
 succeeded in 102ms:
#!/usr/bin/env bun
/**
 * visual-audit.ts — Auditoria visual completa do egos-landing
 *
 * Uso: bun scripts/visual-audit.ts [--url <base>] [--out <dir>] [--mobile] [--json]
 *
 * O que faz:
 *   1. Sobe dev server (ou usa --url para produção)
 *   2. Navega todas as 8 páginas + faz testes de interação
 *   3. Salva screenshots em docs/_proofs/<data>/
 *   4. Reporta: JS errors, net errors, interações, acessibilidade básica
 *   5. Exit 1 se qualquer página tiver JS errors críticos
 *
 * Integração sugerida:
 *   - Pre-deploy: bash deploy.sh && bun scripts/visual-audit.ts --url https://egos.ia.br
 *   - Pre-commit (opcional, lento): VISUAL_AUDIT=1 bun scripts/visual-audit.ts
 *   - Baseline visual: bun scripts/visual-audit.ts --baseline (salva referência)
 *
 * Playwright instalado em: packages/mcp-browser-automation/node_modules/playwright
 */

import { execSync, spawn } from 'child_process'
import { existsSync, mkdirSync, writeFileSync } from 'fs'
import { resolve, join } from 'path'

// ── CLI args ──────────────────────────────────────────────────────────────────
const args = process.argv.slice(2)
const BASE_URL = args.includes('--url')
  ? args[args.indexOf('--url') + 1]
  : 'http://localhost:5181'
const MOBILE = args.includes('--mobile')
const AS_JSON = args.includes('--json')
const BASELINE = args.includes('--baseline')

const ROOT = resolve(import.meta.dir, '..')
const PLAYWRIGHT = resolve(ROOT, 'packages/mcp-browser-automation/node_modules/playwright')
const TODAY = new Date().toISOString().slice(0, 10)
const OUT_DIR = args.includes('--out')
  ? args[args.indexOf('--out') + 1]
  : resolve(ROOT, `docs/_proofs/${TODAY}`)

// ── Consent localStorage seed ─────────────────────────────────────────────────
const CONSENT_SEED = JSON.stringify({
  version: '1.0.0',
  timestamp: new Date().toISOString(),
  choices: { analytics: false, sentry: false, ai_context: false, registration: false, history: false },
  history: [],
})

// ── Page manifest ─────────────────────────────────────────────────────────────
const PAGES = [
  { name: 'home',          hash: '',              expect: 'IA que você pode' },
  { name: 'timeline',      hash: '#/timeline',    expect: 'Timeline' },
  { name: 'showcase',      hash: '#/showcase',    expect: 'Showcase' },
  { name: 'transparencia', hash: '#/transparencia', expect: 'Transparência' },
  { name: 'guard',         hash: '#/guard',       expect: 'Guard Brasil' },
  { name: 'grok',          hash: '#/grok',        expect: 'Grok Hunter' },
  { name: 'mycelium',      hash: '#/mycelium',    expect: 'Mycelium' },
  { name: 'tools',         hash: '#/tools',       expect: 'Hub de Ferramentas' },
]

// ── Interaction tests ─────────────────────────────────────────────────────────
async function runInteractionTests(browser: any, results: any[]) {
  // T1: Consent gate shows on first visit, dismiss → badge appears
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1500)

    const modalOk = await page.locator('text=Antes de começar').isVisible().catch(() => false)
    await page.locator('text=Modo básico — sem dados').click().catch(() => {})
    await page.waitForTimeout(800)
    const badgeOk = await page.locator('text=Seus dados: 0 compartilhados').isVisible().catch(() => false)
    const heroOk  = await page.locator('text=IA que você pode').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-flow.png') })
    results.push({ name: 'interaction:consent-flow', ok: modalOk && badgeOk && heroOk,
      checks: { modal: modalOk, badge: badgeOk, hero: heroOk } })
    await page.close()
  }

  // T2: Consent detail → toggle analytics → badge shows "1 compartilhado"
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1000)

    await page.locator('text=Escolher o que ativo').click().catch(() => {})
    await page.waitForTimeout(500)
    const detailOk = await page.locator('text=Suas escolhas de privacidade').isVisible().catch(() => false)

    const toggle = page.locator('[role="switch"][aria-label="Ativar Analytics"]')
    await toggle.click().catch(() => {})
    await page.waitForTimeout(300)
    const toggleOn = (await toggle.getAttribute('aria-checked').catch(() => 'false')) === 'true'

    await page.locator('text=Salvar escolhas').click().catch(() => {})
    await page.waitForTimeout(800)
    const badge1 = await page.locator('text=Seus dados: 1 compartilhado').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-consent-1-active.png') })
    results.push({ name: 'interaction:consent-detail', ok: detailOk && toggleOn && badge1,
      checks: { detail: detailOk, toggleOn, badge1 } })
    await page.close()
  }

  // T3: Guard Brasil local scanner — CPF + telefone sintéticos
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.addInitScript((c: string) => localStorage.setItem('egos_consent_v1', c), CONSENT_SEED)
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1500)

    const localScanner = page.locator('textarea[placeholder*="Entre em contato"]')
    // scan-ok: mock — synthetic PII for test, never real
    await localScanner.fill('CPF 987.654.321-00 e tel (31) 99999-8888')
    await page.waitForTimeout(1200)

    const cpfMask = await page.locator('text=[CPF MASCARADO]').isVisible().catch(() => false)
    const telMask = await page.locator('text=[TELEFONE MASCARADO]').isVisible().catch(() => false)
    const cpfTag  = await page.locator('text=CPF detectado').isVisible().catch(() => false)

    await page.screenshot({ path: join(OUT_DIR, 'interaction-guard-pii.png') })
    results.push({ name: 'interaction:guard-pii-local', ok: cpfMask && telMask && cpfTag,
      checks: { cpfMask, telMask, cpfTag } })
    await page.close()
  }

  // T4: ConsentBadge panel — open/close/revoke
  {
    const page = await browser.newPage()
    await page.setViewportSize({ width: 1280, height: 900 })
    await page.addInitScript((c: string) => localStorage.setItem('egos_consent_v1', c), CONSENT_SEED)
    await page.goto(BASE_URL, { waitUntil: 'load', timeout: 15000 })
    await page.waitForTimeout(1500)

    const badge = page.locator('button[aria-label="Gerenciar preferências de privacidade"]')
    await badge.click().catch(() => {})
    await page.waitForTimeout(400)
    const panelOk = await page.locator('text=Privacidade').isVisible().catch(() => false)

    await page.locator('button[aria-label="Fechar"]').click().catch(() => {})
    await page.waitForTimeout(300)
    const closedOk = !(await page.locator('text=Revogar tudo').isVisible().catch(() => false))

    await page.screenshot({ path: join(OUT_DIR, 'interaction-badge-panel.png') })
    results.push({ name: 'interaction:badge-panel', ok: panelOk && closedOk,
      checks: { panelOpen: panelOk, closeWorks: closedOk } })
    await page.close()
  }
}

// ── Main ──────────────────────────────────────────────────────────────────────
async function main() {
  const { chromium } = await import(`${PLAYWRIGHT}/index.js`)

  mkdirSync(OUT_DIR, { recursive: true })

exec
/bin/bash -lc 'bun --filter egos-landing lint' in /home/enio/egos
 exited 1 in 4040ms:
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/App.tsx
egos-landing lint:   145:54  error  Unexpected any. Specify a different type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          @typescript-eslint/no-explicit-any
egos-landing lint:   173:19  error  Unexpected any. Specify a different type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          @typescript-eslint/no-explicit-any
egos-landing lint:   198:19  error  Unexpected any. Specify a different type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          @typescript-eslint/no-explicit-any
egos-landing lint:   220:19  error  Unexpected any. Specify a different type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          @typescript-eslint/no-explicit-any
egos-landing lint:   282:7   error  Error: Calling setState synchronously within an effect can trigger cascading renders
egos-landing lint: 
egos-landing lint: Effects are intended to synchronize state between React and external systems such as manually updating the DOM, state management libraries, or other platform APIs. In general, the body of an effect should do one or both of the following:
egos-landing lint: * Update external systems with the latest state from React.
egos-landing lint: * Subscribe for updates from some external system, calling setState in a callback function when external state changes.
egos-landing lint: 
egos-landing lint: Calling setState synchronously within an effect body causes cascading renders that can hurt performance, and is not recommended. (https://react.dev/learn/you-might-not-need-an-effect).
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/App.tsx:282:7
egos-landing lint:   280 |   useEffect(() => {
egos-landing lint:   281 |     if (currentRoute === 'timeline' && !selectedArticleSlug) {
egos-landing lint: > 282 |       setLoadingArticles(true)
egos-landing lint:       |       ^^^^^^^^^^^^^^^^^^ Avoid calling setState() directly within an effect
egos-landing lint:   283 |       supabase
egos-landing lint:   284 |         .from('timeline_articles')
egos-landing lint:   285 |         .select('slug, title, body_html, published_at, epistemic_status, tags, word_count, lang')  react-hooks/set-state-in-effect
egos-landing lint:   300:7   error  Error: Calling setState synchronously within an effect can trigger cascading renders
egos-landing lint: 
egos-landing lint: Effects are intended to synchronize state between React and external systems such as manually updating the DOM, state management libraries, or other platform APIs. In general, the body of an effect should do one or both of the following:
egos-landing lint: * Update external systems with the latest state from React.
egos-landing lint: * Subscribe for updates from some external system, calling setState in a callback function when external state changes.
egos-landing lint: 
egos-landing lint: Calling setState synchronously within an effect body causes cascading renders that can hurt performance, and is not recommended. (https://react.dev/learn/you-might-not-need-an-effect).
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/App.tsx:300:7
egos-landing lint:   298 |   useEffect(() => {
egos-landing lint:   299 |     if (selectedArticleSlug) {
egos-landing lint: > 300 |       setLoadingSingle(true)
egos-landing lint:       |       ^^^^^^^^^^^^^^^^ Avoid calling setState() directly within an effect
egos-landing lint:   301 |       supabase
egos-landing lint:   302 |         .from('timeline_articles')
egos-landing lint:   303 |         .select('*')                                                                                                                   react-hooks/set-state-in-effect
egos-landing lint:   323:7   error  Error: Calling setState synchronously within an effect can trigger cascading renders
egos-landing lint: 
egos-landing lint: Effects are intended to synchronize state between React and external systems such as manually updating the DOM, state management libraries, or other platform APIs. In general, the body of an effect should do one or both of the following:
egos-landing lint: * Update external systems with the latest state from React.
egos-landing lint: * Subscribe for updates from some external system, calling setState in a callback function when external state changes.
egos-landing lint: 
egos-landing lint: Calling setState synchronously within an effect body causes cascading renders that can hurt performance, and is not recommended. (https://react.dev/learn/you-might-not-need-an-effect).
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/App.tsx:323:7
egos-landing lint:   321 |   useEffect(() => {
egos-landing lint:   322 |     if (!inputText) {
egos-landing lint: > 323 |       setMaskedText('')
egos-landing lint:       |       ^^^^^^^^^^^^^ Avoid calling setState() directly within an effect
egos-landing lint:   324 |       setDetectedPII([])
egos-landing lint:   325 |       return
egos-landing lint:   326 |     }                                                                                                                                                               react-hooks/set-state-in-effect
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/components/MyceliumPage.tsx
egos-landing lint:   279:11  error  Error: Cannot call impure function during render
egos-landing lint: 
egos-landing lint: `Math.random` is an impure function. Calling an impure function can produce unstable results that update unpredictably when the component happens to re-render. (https://react.dev/reference/rules/components-and-hooks-must-be-pure#components-and-hooks-must-be-idempotent).
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/components/MyceliumPage.tsx:279:11
egos-landing lint:   277 |   const triggerSimulation = async (nodeId: string, eventType: string, label: string, color: string, detail: string) => {
egos-landing lint:   278 |     const event: LiveEvent = {
egos-landing lint: > 279 |       id: Math.random().toString(36).substring(2, 9),
egos-landing lint:       |           ^^^^^^^^^^^^^ Cannot call impure function
egos-landing lint:   280 |       nodeId, eventType, label, color, detail,
egos-landing lint:   281 |       timestamp: new Date().toLocaleTimeString('pt-BR'),
egos-landing lint:   282 |     }  react-hooks/purity
egos-landing lint: 
egos-landing lint: /home/enio/egos/apps/egos-landing/src/lib/markdown.ts
egos-landing lint:   37:25  error  Unnecessary escape character: \>  no-useless-escape
egos-landing lint: 
egos-landing lint: ✖ 9 problems (9 errors, 0 warnings)
egos-landing lint: 
egos-landing lint: Exited with code 1

exec
/bin/bash -lc 'git log --oneline --decorate --max-count=6 && git show --stat --oneline --max-count=3' in /home/enio/egos
 succeeded in 179ms:
f8e3c27d (HEAD -> main, origin/main) feat(landing+mcp): seção artefato grátis em egos.ia.br + fix permanente do consent gate no visual proof
5113c4e4 chore(drift): governance drift report [2026-06-07]
20b05775 chore(drift): governance drift report [2026-06-06]
21104bf2 feat(artifact): artefato gratuito v3 — todos os gates passados, pronto para publicar
6e09fcdc chore(end): session close 2026-06-05 FINAL — no-tier rule + A81 + tasks atualizadas
b446d7b8 feat(product): PRODUCT_MODEL.md — regra global sem tiers (R\$4 vitalicio + transparencia radical)
f8e3c27d feat(landing+mcp): seção artefato grátis em egos.ia.br + fix permanente do consent gate no visual proof
 .claude/agents/pixel.md                            |   5 +
 TASKS.md                                           |   1 -
 TASKS_ARCHIVE.md                                   |   6 +
 apps/egos-landing/src/App.tsx                      | 252 ++++++++++++++++++++-
 ...PRIME_TO_GUARANI_2026-06-05_landing-fidelity.md |  38 ++++
 .../handoff_2026-06-05-ui-observability.md         |  69 ------
 docs/_current_handoffs/handoff_2026-06-05.md       |  84 -------
 packages/mcp-browser-automation/src/index.ts       |  25 ++
 8 files changed, 325 insertions(+), 155 deletions(-)
5113c4e4 chore(drift): governance drift report [2026-06-07]
 docs/jobs/2026-06-07-doc-drift-analysis.md | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
20b05775 chore(drift): governance drift report [2026-06-06]
 docs/jobs/2026-06-06-doc-drift-analysis.md | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

exec
/bin/bash -lc "grep -n \"Você é \\[Nome do Assistente\\]\" -A60 docs/drafts/free-artifact-egos-v0.md | sed -n '1,130p'" in /home/enio/egos
 succeeded in 114ms:
15:Você é [Nome do Assistente], um assistente profissional governado especializado em [área], trabalhando com [usuário/equipe] em [contexto].
16-Seu propósito é apoiar [atividades] com precisão, ética e foco em valor prático.
17-
18-Atua exclusivamente em:
19-- [Área 1]  - [Área 2]  - [Área 3]
20-Fora do escopo, responda: "Isso está fora do meu escopo atual. Posso ajudar com [alternativas]."
21-
22-── CONFIGURAÇÃO INICIAL (se houver [colchetes] não preenchidos) ──
23-Se este prompt tiver campos entre colchetes, você ainda NÃO está configurado. Entre em modo TUTOR DE CONFIGURAÇÃO:
24-Regra de ouro: UMA pergunta por vez. Nunca liste todos os gaps. Conduza — não espere.
25-Neste modo, use linguagem natural e conversacional — sem o formato estruturado de classificação (Síntese/Evidências/Riscos). Esse formato é para o modo operacional, não para o tutor.
26-Fluxo obrigatório:
27-1. Pergunta única de abertura: "Olá! Antes de começar, preciso entender em qual área você quer que eu atue. Pode ser algo como: jurídico, saúde, finanças, cripto, conteúdo digital, vendas... Qual é a sua área?"
28-2. Com a resposta, infira HIPÓTESES para todos os outros campos ([nome], [contexto], [atividades], [Áreas], [alternativas]) com base no que o usuário disse.
29-3. Apresente o pacote completo: "Com base na sua área ([área]), aqui está como me configuraria: [Nome]: [sugestão] | Escopo: [Área 1], [Área 2], [Área 3] | Atividades: [sugestão] | Contexto: [sugestão]. Confirma ou quer ajustar algo?"
30-4. Usuário confirma → entra no modo operacional imediatamente. Usuário ajusta → refaz só o ponto ajustado.
31-NÃO peça o nome do assistente antes da área. NÃO explique por que cada campo existe. NÃO liste gaps. Seja tutor: lidere, infira, proponha, confirme.
32-
33-── CLASSIFICAÇÃO OBRIGATÓRIA ──
34-Classifique afirmações relevantes como:
35-- CONFIRMADO: base verificável  - INFERIDO: deduzido dos dados  - HIPÓTESE: plausível, não verificado
36-- NÃO SEI: base insuficiente  - AÇÃO: passo a executar
37-
38-── ANTI-ALUCINAÇÃO ──
39-Nunca invente datas, nomes, valores, leis, decisões, diagnósticos, estatísticas, referências, links ou fatos.
40-Sem fonte/base lógica = HIPÓTESE ou NÃO SEI. Diga "não sei" e qual informação falta.
41-Proibido: "100%", "garantido", "infalível", "único", "sem risco". Prefira: "alta confiança baseada em evidências".
42-
43-── PROTEÇÃO DE DADOS ──
44-Sensíveis: CPF/RG/CNH/passaporte, dados bancários, endereço/telefone/e-mail privado, prontuários, dados de menores, dados de terceiros.
45-Ao receber: avise, mascare (ex: CPF ***.***.***-**), não repita literal, não retenha além da sessão.
46-
47-── ZONA VERMELHA (pause antes) ──
48-Ação de alto impacto: enviar comunicação oficial, publicar, deletar, assinar, comprometer recursos, opinião conclusiva sobre pessoa, expor terceiro, decisão irreversível.
49-Protocolo: (1) identifique a ação (2) liste riscos (3) proponha alternativa mais segura (4) aguarde confirmação explícita (5) registre no resumo.
50-
51-── LIMITAÇÕES ──
52-Não substituo profissional habilitado. Decisão de consequência jurídica/médica/financeira/reputacional → "Esta análise é auxiliar. Consulte um profissional habilitado."
53-
54-── CRITÉRIO DE EVIDÊNCIA ──
55-Antes de afirmar: verifique a fonte, cheque consistência, separe fato de inferência/hipótese, indique lacunas.
56-
57-── MODO DE RESPOSTA ──
58-Direto, profissional, sem jargão. Resumo executivo no início de respostas longas. Foco no próximo passo. Pedido ambíguo → pergunte antes.
59-
60-── FORMATO DE SAÍDA ──
61-Classificação: [CONFIRMADO/INFERIDO/HIPÓTESE/NÃO SEI/AÇÃO]
62-Síntese: [resposta direta]
63-Evidências: [fontes/dados/base lógica]
64-Riscos: [se houver]
65-Próxima ação: [recomendação objetiva]
66-
67-── REGRA FINAL ──
68-Em dúvida relevante: pare, classifique a dúvida, apresente opções, aguarde instrução. Nunca adivinhe silenciosamente.
69-```
70-
71----
72-
73-# PARTE 2 — Checklist: Segurança de IA em 1 Página
74-
75-> Para qualquer profissional que usa ChatGPT/Claude/Gemini no trabalho. Concreto, verificável.

exec
/bin/bash -lc 'nl -ba TASKS_ARCHIVE.md | tail -n 15' in /home/enio/egos
 succeeded in 111ms:
  3672	- [x] **COURSE-FREE-TIER-001** [P1] `voz`+`prime` `gated:HITL` — Definir e publicar conteúdo gratuito útil que atrai para o curso: (a) qual o "útil já na parte gratuita" — proposta: 1 metaprompt pronto para download, 1 checklist de segurança de IA, 1 vídeo curto de 5min "o que é o EGOS Framework"; (b) onde fica: egos.ia.br + Telegram aberto + README do repo público; (c) o gratuito deve ser genuinamente útil — não teaser vazio. 🔄 2026-06-05: RASCUNHO pronto em `docs/drafts/free-artifact-egos-v0.md` (metaprompt + checklist + 3 opções de tom). PENDENTE corte Enio (5 pontos 🔴) + publicação HITL — NÃO fechar até publicar. ✅ 2026-06-05
  3673	
  3674	
  3675	## Archived 2026-06-05
  3676	
  3677	### 🎯 SESSÃO 2026-06-05 TARDE — Propósito + Grupo + Observatory + AIOX
  3678	- [x] **ARTIFACT-CONFIG-PROTOCOL-001** [P1] `prime` — FEITO `190f5950`: bloco tutor-first adicionado ao metaprompt (uma pergunta → infere pacote → propõe → confirma). Free artifact v2 aprovado pelo aparato (Banda+Codex+Guarani). Aguarda apenas glance Enio (FREE-ARTIFACT-GLANCE-001).
  3679	- [x] **PRODUCT-NO-TIER-RULE-001** [P0] `prime` — FEITO `b446d7b8`: regra global documentada em `docs/strategy/PRODUCT_MODEL.md` — um preço (R$4), um produto, vitalício, reembolso mantém material, transparência radical (LIVE/WIP/CONCEPT). Co-criação com participação proporcional em receita.
  3680	
  3681	
  3682	## Archived 2026-06-07
  3683	
  3684	### 🧭 SESSÃO 2026-06-05 — UI rules, autodescoberta, privacidade radical (Enio)
  3685	- [x] **FREE-ARTIFACT-GLANCE-001** [P1] `prime` `gated:HITL` — Enio dá glance final em `docs/drafts/free-artifact-egos-v0.md` (v1 pronto). Se aprovar → publicar nos 3 canais (README egos-governance + egos.ia.br + Telegram). Nada publica sem corte. ✅ 2026-06-05
  3686	

codex
The code builds, but the patch changes the project’s canonical task state by closing a gated HITL item without verifiable evidence. That can break the documented publication governance flow.

Review comment:

- [P2] Keep HITL task evidence with the archived completion — /home/enio/egos/TASKS_ARCHIVE.md:3685-3685
  This archives `FREE-ARTIFACT-GLANCE-001` as done and removes it from active tasks, but the completion only has a date and no verifiable HITL evidence, SHA, artifact link, or publication proof. For gated HITL tasks, agents use `TASKS.md`/`TASKS_ARCHIVE.md` as workflow state; without evidence this can let later publication/deploy steps proceed as if Enio’s approval was recorded when it is not auditable.
The code builds, but the patch changes the project’s canonical task state by closing a gated HITL item without verifiable evidence. That can break the documented publication governance flow.

Review comment:

- [P2] Keep HITL task evidence with the archived completion — /home/enio/egos/TASKS_ARCHIVE.md:3685-3685
  This archives `FREE-ARTIFACT-GLANCE-001` as done and removes it from active tasks, but the completion only has a date and no verifiable HITL evidence, SHA, artifact link, or publication proof. For gated HITL tasks, agents use `TASKS.md`/`TASKS_ARCHIVE.md` as workflow state; without evidence this can let later publication/deploy steps proceed as if Enio’s approval was recorded when it is not auditable.
```
