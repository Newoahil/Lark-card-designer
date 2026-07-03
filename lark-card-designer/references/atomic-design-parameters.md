# Atomic Design Parameters

Use this file when the output needs to guide implementation choices, not only high-level card style. Keep parameters scoped to the components used in the proposed card.

## Parameter Layers

| Layer | Parameters | Use when |
| --- | --- | --- |
| Typography | text size, text weight, text alignment, line count | hierarchy or mobile readability matters |
| Color | header template, inline text color, tag color, icon color, border/background color | status, risk, trend, or priority needs visual encoding |
| Spacing | divider, margin, section grouping, collapsible boundary | the card has multiple modules or dense data |
| Data display | table columns, column width priority, data type, sort key, empty state | rows/columns drive comprehension or action |
| Interaction | primary/secondary/destructive button, disabled state, confirm copy | user action changes state |
| Metadata | period, source, update time, owner, audit trail, confidence | data needs trust, traceability, or compliance |
| Responsive | desktop/mobile priority, vertical stacking, folded details | content may be wide or dense |

## Inline Text Color

Use inline color as micro-emphasis, not as a layout system.

- Use for short semantic fragments: status words, risk words, deltas, abnormal values, target gaps, approval result.
- Prefer one inline color family per sentence or row.
- Pair color with explicit text. Do not rely on color alone.
- Do not color full paragraphs. Use tags, key numbers, or section status instead.
- Do not attempt to customize link text color; links should keep platform behavior.
- Prefer Feishu color enums for consistency. Use RGBA custom colors only when brand or accessibility requirements justify it.

Implementation-facing hints:

- Rich text / markdown: use inline font color syntax for short fragments.
- Plain text component: use `text_color` when the whole text element has one semantic state.
- Tags: use `text_tag` or option tags when the colored item is a status or category.
- Table cells: prefer `options`, `lark_md`, or `markdown` data types for colored/status content instead of coloring a whole row.

Recommended mapping:

| Meaning | Inline color intent | Example fragment |
| --- | --- | --- |
| Positive delta, recovered, approved | green | `+12%`, `已恢复`, `已批准` |
| Severe risk, rejected, failed | red | `-18%`, `拒绝`, `断货` |
| Pending, warning, near threshold | orange/yellow | `待审批`, `库存预警` |
| Neutral info, running, analysis | blue/cyan | `分析中`, `执行中` |
| Historical, disabled, secondary | gray | `已归档`, `历史记录` |

## Tags

Use tags for compact classification.

- Status tags: `高风险`, `待审批`, `已完成`, `已过期`.
- Priority tags: `P0`, `P1`, `必读`, `可选`.
- Object tags: `SKU`, `商机`, `权限`, `发布`.
- Keep tag text short. Long explanations belong in markdown or notes.
- Use tag color from semantic state. Do not invent decorative tag palettes.

## Typography

- Use larger or stronger text only for the conclusion, card title, or key number.
- Use small or notation-level text for source, update time, audit IDs, limitations, and secondary notes.
- Avoid using multiple text sizes in the same small module.
- If a text block is likely to wrap on mobile, shorten it or split it into label/value rows.

## Spacing And Dividers

- Use dividers between modules with different decisions: summary, metrics, actions, evidence, audit.
- Avoid dividers inside a tightly related metric group.
- Use collapsible boundaries for raw evidence, old history, logs, and long rows.
- If the first screen feels crowded, reduce competing modules before reducing required context.

## Table Parameters

Specify table parameters when rows are central:

- primary_key: row identity such as SKU, customer, approval ID, article title
- visible_columns: columns shown on first screen
- folded_columns: columns moved to detail, note, or source table
- sort_key: risk, delta, priority, amount, update time
- row_limit: default visible row count
- data_type: text, lark_md, markdown, options, number, persons, date
- status_column: field that drives tag or color

Avoid deleting context just to fit width. Prefer vertical stacking, folded columns, or links to source.

## Button And State Parameters

Specify these for action cards:

- primary_action: the intended next action
- secondary_actions: alternatives that do not compete with primary action
- destructive_action: action that requires confirmation
- disabled_state: how the button changes after completion, expiry, or rejection
- confirmation_copy: short copy for irreversible or high-risk actions
- callback_payload_hint: semantic payload fields only, not implementation code

## Fallback Parameters

Specify fallback behavior when the chosen component may not render well everywhere:

- long_text_fallback: fold, split, or link to source
- mobile_fallback: vertical stack, reduce visible columns, or show summary row
- unsupported_component_fallback: replace with markdown/list/table
- missing_media_fallback: show text title and source link
- stale_data_fallback: show update time and refresh action

## Atomic Parameter Output Shape

When useful, add this compact block:

```markdown
atomic_parameters:
- typography: title=plain_text/heading, body=normal, metadata=notation
- color_tokens: header=orange, inline_delta=red, tag_risk=red
- inline_text_color: only color status words and metric deltas; no full-paragraph coloring
- tags: risk=red, pending=orange, archive=neutral
- table_columns: visible=[name,status,delta,owner], folded=[id,raw_update_time]
- buttons: primary=approve, secondary=[reject,return], disabled_after=final_state
- responsive_behavior: stack secondary fields on mobile; fold raw evidence
```
