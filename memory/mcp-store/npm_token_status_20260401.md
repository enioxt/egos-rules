---
date: 2026-04-01T20:47:13.174Z
tags: [npm, guard-brasil, credentials, 2026-04-01]
---

---
name: npm token status 2026-04-01
description: Active npm token for @egosbr/guard-brasil publishes, expires ~2026-04-08 (7-day expiry)
type: project
---

# npm Token Status (2026-04-01)

## Current State
- **Active token:** npm_3YNS...FANJ (id 243c17) created 2026-04-01
- **Previous token:** npm_ijZg...omSf (id a9c36c) created 2026-03-30
- **Storage:** ~/.npmrc (permissions 0600)
- **Expiry:** ~2026-04-08 (7-day expiry)
- **Status:** ✅ ACTIVE

## Recent Activity
- @egosbr/guard-brasil@0.2.0 published 2026-04-01 (using this token)
- Token is in .npmrc locally
- GitHub Action workflow `publish-npm.yml` references `NPM_TOKEN` secret (assumed set)

## Next Actions
- **Before 2026-04-08:** If any `npm publish` needed after expiry, create new token via `npm token create --type=publish`
- If longer-lived token preferred: create granular access token on npmjs.com (no auto-expiry)

**Why:** Short-lived tokens reduce attack surface if compromised. But 7-day expiry requires frequent refresh for continuous publishing.
