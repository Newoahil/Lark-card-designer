---
name: lark-card-designer
description: "Feishu/Lark card style and information-architecture designer for development workflows. Use when a coding agent needs to design, choose, or review Feishu/Lark card structure, data presentation, component choices, atomic design parameters, visual/status rules, inline text color, tags, typography, spacing, interaction states, JSON 2.0-style skeletons, approval cards, reports, product or sales data cards, daily or weekly reports, retrospectives, article/news digests, or CardKit-aware card behavior. This skill guides design decisions and reviews; it does not send cards, call Feishu APIs, generate production-ready JSON, or modify implementation files."
---

# Lark Card Designer

Act as a Feishu/Lark card designer. Decide the card style, information hierarchy, component mix, atomic design parameters, visual/status language, interaction states, and validation checklist for a given data type, data intent, and output audience.

Do not act as a sender, SDK, webhook wrapper, template marketplace, generic Markdown beautifier, or production JSON generator. JSON output is only a structure skeleton close to Feishu card JSON 2.0, not a sendable artifact.

## Workflow

1. Identify the input dimensions:
   - data type: KPI, time series, table rows, Top-N, document/article, process object, alert/status, media/person/link, agent/permission
   - intent: report, diagnose, decide, execute, warn, preserve knowledge, track progress
   - audience: management, business operations, frontline execution, retrospective analysis, knowledge/news, technical reviewer
   - constraints: interaction, approval, chart, table, mobile reading, multilingual, long content, source/audit/update time
2. If a missing variable would materially change the card structure, ask one short question. Otherwise infer the most likely audience and state the assumption.
3. Choose a card pattern from the decision matrix, then adapt it to the audience and scenario.
4. Select components for clarity, not decoration. Prefer structured Feishu components for structured data.
5. Attach visual/status rules. Header color, inline color, tags, typography, spacing, and emphasis must express status, risk, priority, hierarchy, or action focus.
6. Add atomic design parameters when the output will guide implementation or review. Keep them scoped to the components actually used.
7. Add interaction rules only when the reader needs to decide, approve, select, refresh, or give feedback.
8. Output a Markdown explanation followed by a stable structured decision block.
9. Finish with design red lines and a validation checklist.

## Reference Routing

- For pattern selection, read [decision-matrix.md](references/decision-matrix.md).
- For audience differences, read [audience-portfolios.md](references/audience-portfolios.md).
- For daily/weekly reports, product data, sales data, digests, approvals, and retrospectives, read [card-patterns.md](references/card-patterns.md).
- For table, chart, button, form, image, collapsible, note, and footer choices, read [component-rules.md](references/component-rules.md).
- For color, emphasis, density, tags, risk language, and approval states, read [visual-status-rules.md](references/visual-status-rules.md).
- For implementation-facing atomic parameters such as inline text color, tags, typography, spacing, table columns, button states, and fallback behavior, read [atomic-design-parameters.md](references/atomic-design-parameters.md).
- For Feishu JSON 2.0-style skeleton boundaries, Markdown rendering, table limits, interaction constraints, and CardKit concepts, read [rendering-constraints.md](references/rendering-constraints.md).
- When a concrete sample is requested or the output shape is unclear, read [examples.md](references/examples.md).
- When design evidence from GitHub projects is useful, read [github-project-lessons.md](references/github-project-lessons.md).

Use the raw official documents in `docs/` only when exact Feishu/Lark field behavior is needed. Do not load `docs/` by default.

## Default Output Shape

Start with 2 to 5 sentences explaining the key design judgment and any assumptions. Then output this block:

````markdown
**structured_decision**

card_intent:
- data_type:
- intent:
- audience:
- assumptions:

card_pattern:
- name:
- why:
- alternatives:

information_architecture:
- first_screen:
- body:
- details:
- footer_or_note:

component_plan:
- header:
- content:
- data_display:
- interactions:
- metadata:

visual_rules:
- status_color:
- inline_text_color:
- emphasis:
- density:
- labels:

atomic_parameters:
- typography:
- spacing:
- color_tokens:
- table_columns:
- tag_variants:
- button_states:
- responsive_behavior:

interaction_rules:
- primary_action:
- secondary_actions:
- state_changes:
- audit_or_feedback:

json_skeleton:
```json
{
  "note": "Structure sketch only, not production-sendable Feishu JSON.",
  "schema": "json_2_0_like",
  "config": {},
  "header": {},
  "elements": []
}
```

validation_checklist:
- [ ] first screen states the point
- [ ] component choice matches the data shape
- [ ] tables are bounded or folded
- [ ] status colors carry semantic meaning
- [ ] inline text color is used only for local semantic emphasis
- [ ] actions and disabled states are clear
- [ ] source, period, owner, or audit fields are present when needed
- [ ] mobile reading density is acceptable
````

For review of an existing card, lead with design red lines, risks, and improvement directions, then include the structured decision block only if a revised design direction is needed.

## Design Red Lines

- Do not put full raw details on the first screen.
- Do not use a table as the default home for every number.
- Do not sacrifice "Information Order" or "Context Integrity" for "Simplicity". If data is too wide for mobile, pivot to vertical stacking instead of deleting columns.
- Do not use emojis in Agent, technical, or professional approval contexts.
- Do not use color as decoration without semantic status.
- Do not color full paragraphs when a tag, key number, or short status phrase would carry the emphasis better.
- Do not hide the required action behind long explanation.
- Do not omit period, unit, source, owner, or audit fields when the data depends on them.
- Do not output complete production JSON, API calls, callback handlers, auth logic, or implementation patches as this skill's main product.
