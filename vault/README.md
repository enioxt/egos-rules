# EGOS Obsidian Vault

Personal knowledge base integrated with EGOS agent ecosystem.

## Structure

- `inbox/` — raw captures, unprocessed notes, quick thoughts
- `active/` — notes actively being worked on
- `archive/` — completed/closed notes
- `resources/` — reference material, links, documentation
- `daily/` — daily notes (auto-created by /daily skill)

## Integration

- `/kb:init <topic>` — creates a structured note in active/
- `/daily` — creates today's note with P0s + VPS health
- `scripts/vault-to-graph.ts` — syncs [[wikilinks]] to codebase-memory-mcp

## Conventions

- Filename: `YYYY-MM-DD-topic-slug.md` for dated notes
- Tags: `#egos`, `#guard-brasil`, `#gem-hunter`, `#research`
- Links: `[[SPEC-NAME]]` links to docs/specs/, `[[TASK-ID]]` to TASKS.md
