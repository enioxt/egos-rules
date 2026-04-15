---
name: usage-report
description: Show Claude Code token usage and cost breakdown by project
type: skill
---

# /usage-report — Claude Code Cost Report

Shows token usage and estimated cost from `~/.claude/projects/` JSONL files.

## Usage

- `/usage-report` — last 30 days, all projects
- `/usage-report 7` — last 7 days
- `/usage-report egos` — filter to one project

## How it works

```bash
# Full report
bun /home/enio/egos/scripts/claude-cost.ts --days 30

# Filter by project
bun /home/enio/egos/scripts/claude-cost.ts --days 30 --project <project>

# JSON output for Supabase
bun /home/enio/egos/scripts/claude-cost.ts --days 30 --json
```

## Pricing used (USD per 1M tokens)

| Model | Input | Output | Cache Write | Cache Read |
|-------|-------|--------|-------------|------------|
| Haiku 4 | $0.80 | $4.00 | $1.00 | $0.08 |
| Sonnet 4 | $3.00 | $15.00 | $3.75 | $0.30 |
| Opus 4 | $15.00 | $75.00 | $18.75 | $1.50 |
