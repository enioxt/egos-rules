---
name: Stitch Design Workflow
description: Protocol for generating and validating UI components using the Stitch MCP.
triggers:
  - "stitch"
  - "ui component"
  - "gerar componente"
  - "design system"
  - "brand import"
  - "ui figma"
anti_triggers:
  - "git stitch"
  - "costurar"
---

# 🧵 Stitch Design Workflow

## Overview
This skill defines the standard procedure for creating and updating UI components in `marketplace-core` and other EGOS projects using the Stitch design system.

## Tools
- `mcp_stitch_create_project`: Initialize a design project.
- `mcp_stitch_generate_screen_from_text`: Create UI from prompts.
- `mcp_stitch_edit_screens`: Refine existing designs.

## Workflow

### 1. Concept Phase
Before coding, generate a visual representation:
```bash
# Example
fast strict "Create a project named 'Marketplace Core RFQ' in Stitch"
```

### 2. Generation Phase
Use `generate_screen_from_text` to visualize the flow:
- **Prompt Structure:** "[Role] wants to [Goal] using [Component Pattern]."
- **Example:** "A mobile-first RFQ form for driving students, using steps for Category, Location, and Date. Use Tailwind classes and Lucide icons."

### 3. Implementation Phase (Porting)
Once the design is validated (or if using existing patterns):
1. Use `shadcn/ui` components as the base.
2. Apply the generated Tailwind classes.
3. Ensure responsiveness (mobile-first).

### 4. Review
- Check against `SYSTEM_MAP.md` for consistency.
- Verify accessibility (aria-labels, contrast).
