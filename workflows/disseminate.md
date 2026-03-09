---
description: "Save knowledge and patterns to persistent memory (System v3.0)"
---

# /disseminate — Knowledge Persistence (System v3.0)

> **Works in:** ANY repo | **When:** You learn something worth remembering

---

## 1. When to Disseminate
```
⚠️  Save knowledge when:
- You discover a pattern that will be useful again (e.g., "Recursion Limit in Accessibility").
- You solve a tricky bug (save the solution).
- You learn about a library/API behavior.
- You find repo-specific conventions (e.g., "Use 'Bun' not 'Node'").
- You make an architectural decision (save rationale).
```

## 2. The Process (Dual-Layer)

### A. Fast Path (Code Comments)
Simply add a comment in the code with the `@disseminate` tag.
```typescript
// @disseminate: [Pattern] Always use Shannon Entropy for secret detection.
if (entropy > 4.5) { ... }
```
*The `scripts/disseminate.ts` will pick this up automatically.*

### B. Deep Path (Manual Tool Call)
Use the `mcp_memory` tools to create structured entities.

1. **CLASSIFY:**
   - 🧠 `Concept` (Architecture, Pattern)
   - 🔧 `Solution` (Bug fix, Config)
   - 📚 `Reference` (Docs, Library)
   - ⚠️ `Gotcha` (Edge case, Warning)

2. **SAVE (Memory MCP):**
   ```javascript
   mcp_memory_create_entities([{
     name: "Recursion Limit Pattern",
     entityType: "padrão_arquitetural",
     observations: [
       "Android Accessibility Services are prone to StackOverflow.",
       "ALWAYS set a MAX_DEPTH constant (e.g., 50).",
       "Log a warning when depth is exceeded."
     ]
   }])
   ```

3. **CONNECT (Mycelium):**
   Link this knowledge to the broader graph.
   ```javascript
   mcp_memory_create_relations([{
     from: "Recursion Limit Pattern",
     to: "Cortex Mobile",
     relationType: "used_in"
   }])
   ```

### C. Global Rule Propagation (For Structural/Security Fixes)
When you discover a critical vulnerability (like the APEX-SECURE findings) or a fundamental structural pattern, you MUST disseminate it across the entire system automatically.
1. **Update `.windsurfrules`:** Inject the pattern into `## SECURITY` or `## ARCHITECTURE` of the local repo.
2. **Update `.guarani/PREFERENCES.md`:** Ensure local code-quality standards reflect the new heuristic.
3. **If Multi-Repo:** Always ask the user if they want to propagate this critical pattern to other core repos (e.g., `carteira-livre`).
