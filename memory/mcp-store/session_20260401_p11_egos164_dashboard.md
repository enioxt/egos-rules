---
date: 2026-04-01T21:54:42.691Z
tags: [egos-164, dashboard, telemetry, supabase, polling, 2026-04-01]
---

---
name: P11 Session — EGOS-164 Dashboard Real Data Complete (2026-04-01)
description: Telemetry pipeline wired end-to-end, dashboard polling Supabase events in real-time
type: project
---

# P11 Session — EGOS-164 Dashboard Real Data

## Completed Tasks

### EGOS-164: Dashboard Real Data from guard_brasil_events ✅

**Implementation:**
1. **Created telemetry.ts** (`packages/guard-brasil/src/telemetry.ts`)
   - `recordApiCall(result, meta)` → fire-and-forget to Supabase
   - `getRecentEvents(limit, tenantId)` → fetch from guard_brasil_events
   - Lazy Supabase init (non-fatal if unavailable)

2. **Wired API Server** (`apps/api/src/server.ts`)
   - Added `recordApiCall()` after each `/v1/inspect` call
   - Captures: duration_ms, cost_usd, pii_types, atrian_score, status_code
   - Fire-and-forget: errors don't block responses

3. **Created /api/events route** (`apps/guard-brasil-web/app/api/events/route.ts`)
   - Next.js server route: `GET /api/events?limit=50&since=<ts>`
   - Queries guard_brasil_events via SUPABASE_SERVICE_ROLE_KEY
   - Returns: `{events: [...], total, timestamp}`

4. **Updated Dashboard** (`apps/guard-brasil-web/components/DashboardV2Lean.tsx`)
   - Replaced mock data with real polling
   - `fetch('/api/events')` every 5 seconds
   - Graceful degradation on errors (keeps existing events)

5. **Added Supabase dependency** and .env.example files
   - `@supabase/supabase-js@^2.40.0` in guard-brasil-web
   - `.env.example` templates for API server and dashboard

## Database Status

**Table:** `guard_brasil_events` already exists in Supabase (lhscgsqhiooyatkebose)

Schema includes:
- id (uuid), tenant_id, event_type, created_at
- tokens_in/out, cost_usd, duration_ms, model_id
- pii_types (array), pii_count, verdict
- atrian_score, atrian_violations, pri_output, pri_confidence, policy_pack
- status_code, session_id, api_version

Indexes: timestamp DESC, event_type, api_key_hash

## Commits

```
af74139 feat(egos-164): Guard Brasil Dashboard with Real Data
2ac25bf fix: remove unused import recordApiError
291e86f docs: mark EGOS-164 complete (Dashboard real data)
```

## Configuration Required

**For next session:** Set environment variables:
```
# apps/api/.env (or Hetzner Docker env)
SUPABASE_URL=https://lhscgsqhiooyatkebose.supabase.co
SUPABASE_SERVICE_ROLE_KEY=<from Supabase console>

# apps/guard-brasil-web/.env.local
NEXT_PUBLIC_SUPABASE_URL=https://lhscgsqhiooyatkebose.supabase.co
SUPABASE_SERVICE_ROLE_KEY=<from Supabase console>
```

Then run:
- `npm install` in guard-brasil-web (to get @supabase/supabase-js)
- Restart API server to load telemetry
- Dashboard will auto-poll /api/events

## Next Steps

**P1 Priorities (33 remaining):**
1. **EGOS-163: Pix billing** (blocker for revenue) — ~5-6 days
2. **EGOS-168: llmrefs docs** (quick win) — ~1h manual
3. **EAGLE-015: Dashboard filters** (UI) — ~1-2 days
4. **EGOS-169: Pattern detect pre-commit** — ~1-2 days

**Why this session succeeded:**
- Supabase table already existed (saved 2h)
- Minimal scope: telemetry recording + API route + polling
- No new domains (reused guard-brasil + Next.js patterns)
- Clean separation: API → Telemetry → Query API → Dashboard

---

*Session 2026-04-01 P11 — Dashboard real-time data complete. Health: 55% (70/127).*
