---
description: Canonical protocol for hardening and deploying any anonymous institutional chatbot on VPS + Caddy + Docker
---

# /chatbot-vps-hardening — Canonical EGOS Workflow

> **Applies to:** Any Next.js chatbot deployed on VPS with Caddy reverse proxy and anonymous public routes.
> **Origin:** Reverse-engineered from the 852 Inteligência production hardening.
> **Sacred Code:** 000.111.369.963.1618

---

## Phase 0: Pre-flight // turbo

```bash
# Governance check
export PATH="$HOME/.egos/bin:$PATH"
egos-gov check 2>&1 || true
```

**AI AGENT:** Read `AGENTS.md`, `.windsurfrules`, `TASKS.md`, `.guarani/PREFERENCES.md` to understand the deploy surface, frozen zones, and current state.

---

## Phase 1: Governance Sync

```bash
egos-gov sync 2>&1 || true
```

Verify that `.egos` symlink is present and shared governance is current.

---

## Phase 2: Brand Assets (if applicable)

If new visual assets (Stitch ZIP, Figma export) are provided:

```bash
npm run brand:import -- /path/to/assets.zip
```

- Extract with short deterministic filenames into `public/brand/`.
- Update `layout.tsx` metadata (icons, OG images).
- Update landing page and chat UI to reference new assets.

---

## Phase 3: API Hardening

**MANDATORY for any public anonymous route (`/api/chat`, `/api/report`, etc.):**

1. **Payload validation** — reject malformed or empty bodies with `400`.
2. **Provider availability check** — return `503` if no LLM key is configured.
3. **Rate limiting** — sliding window per client IP. Recommended: 12 req / 5 min.
4. **Message sanitization** — cap history length (12), cap message size (4000 chars), strip invalid roles.
5. **Security headers** — `X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`, `Referrer-Policy`, `Strict-Transport-Security` (via Caddy).
6. **No PII retention** — messages processed in-memory only, no server-side logging of content.

**Verification:**
```bash
# Smoke tests: expect 200, 400, 429
npm run smoke:local

# Rate limit verification: expect 200×N then 429
npm run verify:rate-limit
```

---

## Phase 4: Local Production Verification

```bash
npm run verify:local-prod
```

This should:
1. Build the app (`npm run build`).
2. Start a temporary production server on a free port.
3. Run smoke tests (landing 200, chat 200, API 200, invalid 400).
4. Run rate-limit verification (12×200 then 429).
5. Kill the temporary server.

---

## Phase 5: Docker Compose Contract

**Rules (SSOT):**
- `docker-compose.yml` MUST be versioned in the repo (never only on VPS).
- App container MUST be on the same Docker network as the reverse proxy.
- If Caddy resolves containers by name, use `networks.aliases`.
- Healthcheck should use `curl -f http://localhost:<PORT>/` or equivalent.

```yaml
# Example structure
services:
  app:
    build: .
    container_name: myapp
    ports:
      - "HOST_PORT:CONTAINER_PORT"
    env_file: .env
    networks:
      proxy_network:
        aliases:
          - myapp
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/"]
      interval: 30s
      timeout: 5s
      retries: 3

networks:
  proxy_network:
    external: true
```

---

## Phase 6: Deploy to VPS

```bash
npm run release:prod
```

This should:
1. Run governance check.
2. Lint + build locally.
3. Run local production verification (Phase 4).
4. `rsync` to VPS — **excluding** `.egos`, `.agent`, `.windsurf`, `.guarani/orchestration`, `.guarani/philosophy`, `.guarani/prompts`, `.guarani/refinery`, `node_modules`, `.next`, `.env`, `.git`.
5. SSH to VPS: `docker compose build --no-cache && docker compose up -d --force-recreate`.
6. Run remote smoke tests against the public URL.

**Critical rsync rule:** NEVER use `--delete` if there are VPS-only files (like `.env`). Always exclude local-only symlinks and mesh artifacts.

---

## Phase 7: Post-Deploy Validation

```bash
# Public smoke
npm run smoke:public

# Check container health
ssh $VPS_HOST "docker ps --filter name=<container> --format '{{.Status}}'"

# Check logs for errors
ssh $VPS_HOST "docker logs <container> --tail 20 2>&1"
```

---

## Phase 8: Disseminate & Close

```bash
# Disseminate patterns learned
# Use /disseminate workflow

# End session
# Use /end workflow
```

---

## Anti-Patterns (Lessons Learned)

| Anti-Pattern | Fix |
|---|---|
| `rsync --delete` removes VPS-only `.env` | Never `--delete`; exclude sensitive files |
| `docker-compose.yml` only on VPS | Version it in the repo |
| Container not on proxy network | Add `networks` block with alias |
| Rate-limit test reuses same IP | Generate unique synthetic IP per run |
| Local verification assumes server running | Wrapper script boots temporary server |
| Long Stitch filenames break extraction | Extract with short deterministic names |
| Mixed package managers (bun/npm) | Pick one and stick with it |

---

*"Harden before you ship. Verify before you trust. Codify before you forget."*
