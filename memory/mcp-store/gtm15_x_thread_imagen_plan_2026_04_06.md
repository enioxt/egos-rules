---
date: 2026-04-06T12:14:04.769Z
tags: [gtm, x-com, imagen, automation, 2026-04-06]
---

## GTM-015 + X-Thread Poster + Imagen 3 Plan (2026-04-06 late)

**Status:** ✅ PLANNED, READY FOR EXECUTION

**Problem statement:** 
- OG image (PNG) needs to be JPG and automated (currently manual)
- PART002 social posts drafted but not posted on X.com
- Imagen 3 for future social card generation not integrated (only chat/text in llm-provider.ts)

**Solution (3 phases):**

### Phase 1: GTM-015 OG image (30min)
- Use Playwright MCP to screenshot `scripts/assets/guard-og.html` (1200x630)
- Save as JPG to `apps/guard-brasil-web/public/og-image.jpg`
- Update `layout.tsx:8` reference from .png → .jpg
- Verify: `curl -I https://guard.egos.ia.br/og-image.jpg`

### Phase 2: X.com thread poster (1h)
- Create `scripts/x-post-thread.ts`
- Posts 4 tweets from PART002_SOCIAL_POSTS.md in order
- Attaches og-image.jpg to tweet 1 (base64 media_upload)
- OAuth via existing X API route (apps/guard-brasil-web/app/api/x/route.ts)
- Flags: `--dry-run` (test), `--confirm` (prod)

### Phase 3: Imagen 3 integration (45min)
- Create `scripts/generate-social-image.ts`
- Endpoint: `generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-001:predict`
- Auth: Bearer token (GOOGLE_AI_STUDIO_API_KEY)
- Generates: scan result cards, banners, LGPD thread replies

**Plan file:** `/home/enio/.claude/plans/precious-doodling-clover.md`

**Why:** Google AI key available, X.com OAuth ready, Playwright MCP installed. GTM requires visual assets for social (X.com thread). Imagen 3 = foundation for future social card generation (zero cost via free quota).

**Dependencies:** None blocking (all APIs/libraries present)

**When:** Next session, execute all 3 phases sequentially
