# Personal Chronicle — Schema de Eventos Marcantes

> **Parent:** [OPUS_MODE_V1.md](OPUS_MODE_V1.md) §10
> **Versão:** 1.0.0 — 2026-04-23
> **Status:** schema definido, implementação pendente (track OPUS-CHRONICLE-*)

## O que é

Camada de memória **diferente** do `kb_pages` genérico. Personal Chronicle guarda **eventos marcantes** da vida do Enio com schema rico, permitindo referência por codinome, cross-reference entre eventos, timeline visual, e contexto pessoal para o agente "lembrar como tutor".

## Por que separar de kb_pages

- `kb_pages` é generic content (emails, docs, notas). Schema simples: title + content + category.
- Eventos marcantes exigem: data, pessoas, lugar, contexto, aprendizado, codinome, relações com outros eventos.
- Precisam ser **citáveis por codinome** ("lembra da ideianaroça?").
- Privacidade mais estrita — owner-only por default.

## Schema PostgreSQL (proposto)

```sql
CREATE TABLE personal_events (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant           text NOT NULL,                  -- 'enio'
  codinome         text NOT NULL,                  -- ex: 'ideianaroca'
  titulo           text NOT NULL,                  -- ex: 'Primeira noite legal de cannabis'
  data             date NOT NULL,                  -- ISO8601
  data_precisa     boolean DEFAULT false,          -- true se hora/minuto conhecidos
  hora             time,                           -- opcional
  categoria        text NOT NULL CHECK (categoria IN (
                      'marco','ritual','decisao','aprendizado',
                      'crise','celebracao','encontro','perda','criacao'
                    )),
  contexto         text NOT NULL,                  -- narrativa em 2-5 parágrafos
  lugar            text,                           -- 'sítio dos pais — Patos de Minas/MG'
  lugar_geo        point,                          -- lat,lng opcional
  participantes    text[] DEFAULT '{}',            -- ['José Angelo', ...]
  tags             text[] DEFAULT '{}',            -- ['cannabis', 'ritual', 'pais']
  related_events   text[] DEFAULT '{}',            -- [codinome, ...]
  aprendizado      text,                           -- o que Enio extraiu
  referencias_kb   uuid[] DEFAULT '{}',            -- page_ids de kb_pages relacionados
  referencias_externas text[] DEFAULT '{}',       -- URLs, docs
  media            jsonb DEFAULT '[]'::jsonb,      -- [{type, path, caption}, ...]
  privacidade      text DEFAULT 'owner_only' CHECK (privacidade IN (
                      'owner_only',                -- só Enio vê
                      'close_circle',              -- parceiros/família marcados
                      'tutorial',                  -- agente pode referenciar no ensino
                      'public'                     -- aparece em timeline pública
                    )),
  mood             text,                           -- 'feliz', 'reflexivo', 'crise'
  artefatos        text[] DEFAULT '{}',            -- 'receita médica', 'foto X', 'contrato'
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (tenant, codinome)
);

CREATE INDEX idx_personal_events_tenant_date
  ON personal_events (tenant, data DESC);

CREATE INDEX idx_personal_events_codinome
  ON personal_events (tenant, codinome);

CREATE INDEX idx_personal_events_tags
  ON personal_events USING GIN (tags);

CREATE INDEX idx_personal_events_participantes
  ON personal_events USING GIN (participantes);

CREATE INDEX idx_personal_events_related
  ON personal_events USING GIN (related_events);

-- Full-text search em título + contexto + aprendizado
CREATE INDEX idx_personal_events_fts
  ON personal_events USING GIN (
    to_tsvector('portuguese',
      coalesce(titulo,'') || ' ' ||
      coalesce(contexto,'') || ' ' ||
      coalesce(aprendizado,'')
    )
  );

-- RLS: só owner vê owner_only
ALTER TABLE personal_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "service_role_all" ON personal_events
  FOR ALL TO service_role USING (true);

CREATE POLICY "owner_sees_own_events" ON personal_events
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM kb_users u
      WHERE u.supabase_auth_uid = auth.uid()
        AND u.tenant = personal_events.tenant
        AND u.role = 'owner'
    )
  );
```

## Schema de codinome

Codinomes são **primary keys semânticas**. Regras:

- Formato: lowercase, sem espaços, sem acentos (slug)
- Único por tenant
- Imutável após criação (rename = migration)
- 3-40 caracteres
- Permitido: `a-z`, `0-9`, `-`, `_`

**Exemplos válidos:**
- `ideianaroca` — noite no sítio, cannabis legal
- `noite-hermes-deploy` — primeira vez que Hermes foi ao ar no VPS
- `reuniao-lidia-2026-04` — início da parceria com Lídia
- `crise-supabase-quota` — incidente de quota
- `sprint-kbs-enio-fase0` — marco técnico

## Categorias

| Categoria | Uso |
|-----------|-----|
| `marco` | Milestone importante (primeiro cliente, primeiro deploy) |
| `ritual` | Momento recorrente com significado (primeiro uso legal, ano novo) |
| `decisao` | Escolha que mudou direção (pivot, rompimento, parceria) |
| `aprendizado` | Insight profundo (novo framework mental, erro que ensinou) |
| `crise` | Evento difícil (incidente, conflito, perda) |
| `celebracao` | Conquista comemorada |
| `encontro` | Primeira reunião com pessoa relevante |
| `perda` | Luto, término, despedida |
| `criacao` | Produção artística ou intelectual significativa |

## Relações entre eventos

Eventos podem referenciar outros por codinome (`related_events`). Tipos implícitos:

- **Causal:** `crise-X` → `decisao-Y` (crise causou decisão)
- **Sequencial:** `reuniao-lidia-abril` → `reuniao-lidia-maio`
- **Temático:** `ideianaroca` relacionado a outros rituais
- **Espacial:** eventos no mesmo lugar

Queries futuras via entity graph:
```sql
-- Tudo relacionado a José Angelo
SELECT * FROM personal_events
WHERE 'José Angelo' = ANY(participantes)
ORDER BY data;

-- Cadeia causal a partir de um evento
WITH RECURSIVE chain AS (
  SELECT codinome, related_events, titulo, 1 AS depth
  FROM personal_events
  WHERE codinome = 'ideianaroca'
  UNION
  SELECT pe.codinome, pe.related_events, pe.titulo, c.depth + 1
  FROM personal_events pe, chain c
  WHERE pe.codinome = ANY(c.related_events)
    AND c.depth < 5
)
SELECT * FROM chain;
```

## Comando no agente

| Comando | Ação |
|---------|------|
| `/chronicle` | Lista eventos recentes |
| `/chronicle <codinome>` | Lê evento específico |
| `/chronicle new` | Inicia wizard de criação |
| `/chronicle search <termo>` | Busca em título/contexto/tags |
| `/chronicle timeline` | Abre no HQ `/enio/chronicle/timeline` |
| `/chronicle related <codinome>` | Eventos relacionados |

## Wizard de criação (`/chronicle new`)

Protocolo interativo:

```
Agente: "Vamos registrar um novo evento marcante. Me conta brevemente o que aconteceu?"
Enio: "Primeira vez que a Lídia veio conhecer o sistema EGOS em ação. Ela ficou impressionada com o dashboard."
Agente: "Entendi. Algumas perguntas rápidas:
  1. Quando foi? (data aproximada ou precisa)
  2. Onde foi?
  3. Quem mais participou?
  4. Qual categoria: marco/ritual/decisao/aprendizado/encontro/crise/celebracao/perda/criacao?
  5. Quer sugerir um codinome ou deixo eu propor?
  6. Privacidade: owner_only / close_circle / tutorial / public?"
Enio: <responde>
Agente: <propõe codinome + draft do contexto>
Enio: <edita ou aprova>
Agente: <salva no Supabase + confirma com link>
```

## Integração com Tutor Mode

Quando o agente está em modo tutor, pode referenciar eventos do Chronicle marcados como `tutorial`:

> "Lembra quando a gente decidiu unificar /end e /checkpoint? Essa decisão segue o mesmo padrão..."

Isso só se o evento tem `privacidade: tutorial` ou `public`. Eventos `owner_only` **nunca** são citados pelo agente fora de chats diretos com o Enio.

## Integração com dashboard /enio

Nova aba **"Chronicle"** em `hq.egos.ia.br/enio/chronicle`:

```
┌─────────────────────────────────────────────────┐
│  Chronicle — Timeline                           │
├─────────────────────────────────────────────────┤
│  ● 2026-04-23  opus-mode-foundation    [marco]  │
│  ● 2026-04-18  intelink-auth-fix      [crise]   │
│  ● 2026-04-12  ideianaroca-origin     [ritual]  │
│  ● 2026-03-28  primeiro-cliente        [marco]  │
└─────────────────────────────────────────────────┘

[Novo evento]  [Timeline view]  [Graph view]
```

Graph view: força-direta dos eventos com edges `related_events`, clusters por `tags` ou `participantes`.

## Migração e versionamento

Primeiro evento a registrar: `ideianaroca-origin`.

Dados parcialmente disponíveis do documento original:
- Codinome: `ideianaroca`
- Título: "Primeira noite de cannabis com receita médica"
- Categoria: `ritual`
- Lugar: "sítio dos pais"
- Participantes: `['José Angelo']`
- Contexto: "Primeiro uso legalizado, comprado com receita médica + laudo + nota fiscal, do Instituto Damascendo (CE). Noite muito especial que decidi dormir no sítio dos pais."
- Artefatos: `['receita médica', 'laudo', 'nota fiscal Instituto Damascendo']`
- Privacidade: `tutorial` (pode ser citado como aprendizado)

**Data:** dado pendente — Enio precisa confirmar data exata.

## Implementação (tasks)

Ver track `OPUS-CHRONICLE-*` no TASKS.md:

1. **OPUS-CHRONICLE-001** — migration `personal_events` com schema acima
2. **OPUS-CHRONICLE-002** — seed do primeiro evento (ideianaroca)
3. **OPUS-CHRONICLE-003** — CLI script `scripts/chronicle.ts` (new/list/search)
4. **OPUS-CHRONICLE-004** — API routes `/api/enio/chronicle/*`
5. **OPUS-CHRONICLE-005** — UI `/enio/chronicle` com timeline + graph view
6. **OPUS-CHRONICLE-006** — integração com Tutor Mode (citar eventos `tutorial`)
7. **OPUS-CHRONICLE-007** — wizard `/chronicle new` no Claude Code
8. **OPUS-CHRONICLE-008** — entity graph entre personal_events e kb_pages

---

*Sacred Code: 000.111.369.963.1618*
