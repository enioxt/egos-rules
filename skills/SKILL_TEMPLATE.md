# SKILL.md — EGOS Skill Template (EGOS-ARCH-001)
# Version: 1.0.0 | Based on: Hermes Agent Pattern + EGOS Governance
# Sacred Code: 000.111.369.963.1618

---

## Metadata (YAML Frontmatter)

```yaml
name: skill-name
category: [data-processing|web-automation|analysis|integration|ui|security]
version: 1.0.0
author: cascade-agent
created: YYYY-MM-DD
updated: YYYY-MM-DD
autocreation: eagle-eye  # Auto-created by Eagle-Eye after 3+ similar tasks
level: L1  # L0=index only, L1=full skill, L2=specific reference
```

---

## What It Is For

One-sentence description of what this skill enables.

> Example: "Automates browser-based data extraction with human-like delays and anti-detection measures."

---

## When to Use

### Trigger Conditions
- Task involves [specific condition 1]
- Input data format is [format type]
- Output needs to be [output requirement]

### Do NOT Use When
- [Condition where skill is inappropriate]
- [Alternative skill to use instead]

---

## Exact Procedure

### Level 0: Quick Reference (≤10 lines)
For experienced agents — minimal context.

```
1. Step one
2. Step two  
3. Step three
...
```

### Level 1: Full Procedure
For standard execution — complete context.

#### Phase 1: Setup
```typescript
// Code template or command sequence
```

#### Phase 2: Execution
```typescript
// Step-by-step implementation
```

#### Phase 3: Validation
```typescript
// Verification steps
```

### Level 2: Deep Reference
Links to specific files/templates:
- `references/schema.json` — Data schema
- `templates/starter.ts` — Boilerplate code
- `scripts/validate.sh` — Validation script

---

## Command Examples

### CLI Usage
```bash
# Example 1: Basic usage
bun run skill:skill-name --input data.json

# Example 2: With options
bun run skill:skill-name --input data.json --output result.json --verbose
```

### Agent Invocation
```
/skill-name [param1] [param2]
```

---

## Pitfalls & Warnings

| Pitfall | Prevention |
|---------|------------|
| [Common mistake 1] | [How to avoid] |
| [Common mistake 2] | [How to avoid] |
| [Edge case] | [Handling strategy] |

---

## Verification Steps

- [ ] Step 1 produces [expected output]
- [ ] Step 2 validates [condition]
- [ ] Final output matches [format/spec]
- [ ] ATRiAN ethics check passed (if applicable)

---

## Related Skills

- `../related-skill/SKILL.md` — Use when [condition]
- `../../other-category/skill/SKILL.md` — Alternative approach

---

## Changelog

| Version | Date | Change | Author |
|---------|------|--------|--------|
| 1.0.0 | YYYY-MM-DD | Initial creation | cascade-agent |

---

*Generated from EGOS-ARCH-001 — SKILL.md Template Padrão*
