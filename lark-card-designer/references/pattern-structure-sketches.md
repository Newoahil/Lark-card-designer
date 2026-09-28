# Pattern Structure Sketches

Use this file when design handoff needs a more concrete structure sketch than the default output. Every sketch is a conceptual component map, not production-sendable Feishu JSON, a field-level schema, or an implementation template.

Before using a sketch, complete the feasibility check in `json-2.0-compatibility-rules.md`. Use exact official component names only in the mapping lines. Labels such as KPI group, article group, metadata note, button row, and step summary are design concepts, not component tags.

## Contents

- Executive Summary Card
- Ops Dashboard Card
- Digest Card
- Action Approval Card
- Analysis Card
- Alert Card
- Progress Card

## Executive Summary Card

Use for management reporting, business health, decision summaries, and high-level risk.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): input-provided period and scope when relevant, plus conclusion; neutral or one semantic status intent; omit unavailable slots or use explicit placeholders
  body.elements
    markdown: one-sentence conclusion and decision point
    KPI group (conceptual)
      preferred mapping: column_set -> column -> div or markdown
      fallback: vertically stacked div or markdown metrics
    trend evidence, only when it changes the decision
      conditional mapping: chart after VChart chart_spec verification
      fallback: markdown with current value, baseline, and delta
    metadata note (conceptual)
      mapping: notation-sized neutral div; concise markdown is acceptable
    supporting details
      conditional mapping for JSON authoring: collapsible_panel
      fallback for visual builder or unknown authoring path: summary + detail link
```

Conditional checks: chart spec, column nesting, text styling, and collapsible authoring path. Do not prescribe a chart when the implementation owner cannot validate the spec.

## Ops Dashboard Card

Use for daily/weekly operations, product operations, sales operations, anomalies, and owner follow-up.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): input-provided period and scope when relevant, plus health/status; omit unavailable slots or use explicit placeholders
  body.elements
    markdown: what changed and what needs attention
    KPI group (conceptual)
      preferred mapping: column_set -> column -> div or markdown
      fallback: vertical metric stack
    trend, composition, funnel, or target-gap evidence
      conditional mapping: chart after chart_spec verification
      fallback: bounded table or staged markdown comparison
    prioritized actionable rows
      mapping: bounded table, normally 5 to 10 visible rows
      fallback: compact markdown list
    raw rows, older periods, or long evidence
      conditional mapping for JSON authoring: collapsible_panel
      fallback: detail link or separate detail card
    metadata note (conceptual)
      mapping: notation-sized neutral div listing only input-provided source, owner, and update time; omit unavailable slots or use explicit placeholders, never fill values from field names
```

Product variant: make row identity SKU/category; prioritize inventory, sales, conversion, margin/refund, and status; include owner only when input-provided and relevant.

Sales variant: prioritize revenue/orders, target, forecast gap, funnel stage, and region/channel; include owner only when input-provided and relevant.

## Digest Card

Use for blog, article, research, industry news, and knowledge aggregation.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): topic plus collection period only when input-provided and relevant; otherwise omit it or use an explicit placeholder; normally neutral
  body.elements
    markdown: why this collection matters
    must-read article group (conceptual)
      mapping: markdown or repeated div items
      fields by intent: title, summary, source, time, priority label, link; list only input-provided fields, omitting unavailable slots or using explicit placeholders
    optional article group (conceptual)
      mapping: markdown or repeated div items with lower visual emphasis
    archive or related material
      conditional mapping for JSON authoring: collapsible_panel
      fallback: concise archive summary + detail link
    actions, only when feedback or saving is supported
      mapping: individual button components
      multi-action layout: column_set -> column -> button after nesting verification
      fallback: one primary button + overflow or text links for secondary actions
```

Do not imply that a generic rich-text component or button-group component exists. Choose `markdown` or `div`, and map each action to a verified `button` or `overflow` component.

## Action Approval Card

Use for approvals, confirmations, parameterized execution, permission changes, procurement, releases, and auditable decisions.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): approval object + current state
  body.elements
    markdown: decision object, consequence, and deadline
    decision facts
      choose column_set for a small fact set after nesting verification
      choose table for bounded structured rows after column-definition verification
      fallback: labeled div blocks
    policy or audit caveat
      mapping: notation-sized neutral div or concise markdown
    required input, only when submission truly needs it
      mapping: form containing verified input/select components
      fallback: link to an external form or workflow
    decision actions
      mapping: individual button components
      preferred hierarchy: one primary button; secondary actions in verified columns or overflow
    history and evidence
      conditional mapping for JSON authoring: collapsible_panel
      fallback: summary + detail link
    terminal audit state
      mapping: div or markdown listing only input-provided outcome, operator, time, and comment; omit unavailable slots or use explicit placeholders, never fill values from field names
```

Always specify the interaction state model:

```text
pending
  -> accepted (the interaction was received; controls lock)
  -> processing, only when business work continues asynchronously
  -> terminal: approved | rejected | returned | cancelled | expired | failed
  -> needs_input, when the flow cannot continue without user information
```

Exact button fields, form nesting, callback values, and state mutation remain implementation-owner verification. This skill does not emit callback schemas.

## Analysis Card

Use for retrospectives, root-cause analysis, evidence-backed diagnosis, and campaign/project reviews.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): topic + result state
  body.elements
    markdown: one-sentence conclusion, impact, and confidence
    comparison evidence
      choose chart only after chart_spec validation
      choose bounded table when exact values or evidence rows matter more
      fallback: markdown comparison with explicit baseline
    markdown: cause hypothesis with evidence boundary
    corrective actions
      mapping: bounded table listing only input-provided action, owner, deadline, and state; omit unavailable slots or use explicit placeholders, never fill values from field names
      fallback: compact markdown list
    raw data, logs, timeline, or references
      conditional mapping for JSON authoring: collapsible_panel
      fallback: detail link or separate appendix card
    metadata note (conceptual)
      mapping: notation-sized neutral div listing only input-provided source, limitation, and update time; omit unavailable slots or use explicit placeholders, never fill values from field names
```

## Alert Card

Use for incidents, warnings, short abnormal notifications, and single-status updates.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): severity + impacted object; one semantic status intent
  body.elements
    markdown: current status, impact, and likely cause
    div or markdown: input-provided mitigation and next update time only; omit unavailable slots or use explicit placeholders, never fill values from field names
    actions, only when the reader has a valid next step
      mapping: individual button components
      fallback: one detail link
    logs and secondary context
      conditional mapping for JSON authoring: collapsible_panel
      fallback: detail link or separate detail card
```

Escalate to the action approval pattern when the reader must approve, confirm, or execute a consequential action.

## Progress Card

Use for long-running tasks, streaming updates, and process tracking.

```text
Design handoff component map only; not production-sendable Feishu JSON.
card
  header (top-level): task + current state; keep stable during updates
  body.elements
    primary streaming region
      mapping: one markdown component with the latest useful result
    step summary (conceptual)
      mapping: markdown or repeated div blocks for current step, blocker, and next event
    state-valid actions
      mapping: individual button components for stop, retry, input, or feedback
      fallback: one primary action or a read-only status
    tool output, logs, or historical steps
      conditional mapping for JSON authoring: collapsible_panel
      fallback: concise summary + detail link
    metadata note (conceptual)
      mapping: notation-sized neutral div listing only input-provided run stats, source, update time, and fallback state; omit unavailable slots or use explicit placeholders, never fill values from field names
```

Keep the header and primary content region stable during updates. On completion, close streaming, remove generating language, and switch to the appropriate result-oriented pattern. CardKit update operations, element IDs, sequencing, and send behavior remain implementation responsibilities.
