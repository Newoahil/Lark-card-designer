# Minimal Examples

These examples show design-output shape, not implementation. Component maps are conceptual handoff artifacts and must not be converted into sendable JSON without exact official verification.

## Daily/Weekly Report

Input: weekly business operations report with KPI, risk, and action items.

```markdown
card_intent:
- data_type: time series + KPI + action rows
- intent: report and execute
- audience: business operations
- assumptions: default to operations because owner/action items are present

card_pattern:
- name: ops_dashboard_card
- why: needs KPI health, trend, anomaly, and owner actions

information_architecture:
- first_screen: period, overall status, 3 key conclusions, top risk
- body: KPI group, trend evidence, bounded action table
- details: raw project rows folded or linked
- footer_or_note: source and update time

chart_decision:
- should_use_chart: conditional
- business_question: whether weekly KPI movement is persistent enough to change owner priority
- recommended_chart_type: compact trend chart if ordered weekly nodes are available
- data_requirements: same metric definition, unit, scope, and weekly grain
- why_not_table_or_kpi: KPI group states health; chart adds value only for persistence or volatility
- fallback: KPI delta plus one markdown comparison sentence
- implementation_verification_needed: chart_spec and mobile render

number_emphasis_rules:
- emphasized_numbers: [target_gap_delta, top_risk_impact]
- emphasis_method: risk tag plus at most one inline delta color
- color_semantics: red for severe missed target, orange for near-threshold warning, green only for recovered or target reached
- numbers_not_to_emphasize: [all secondary KPI values, unchanged metrics]
- missing_context: [target_or_previous_period_if_absent]

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: unknown
- official_components: [markdown, column_set, div, table]
- conditional_components: [chart, collapsible_panel]
- conceptual_only_patterns: [KPI group, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [vertical metric stack, markdown comparison, detail link]
- implementation_verification_needed: [column nesting, table columns, chart_spec, collapsible authoring path]

component_plan:
- content: markdown conclusion
- data_display: KPI group maps to column_set + column + div; table is bounded to actionable rows
- interactions: button only if view detail or refresh is a verified user action
- metadata: notation-sized neutral div for source, period, and owner
```

## Product Data

Input: SKU sales, inventory, conversion, refund rate, product image fields.

```markdown
card_intent:
- data_type: product rows + KPI + anomaly labels
- intent: diagnose and execute
- audience: business operations

card_pattern:
- name: ops_dashboard_card
- why: product data needs metric health plus object-level action

information_architecture:
- first_screen: category/store, period, inventory or conversion risk
- body: KPI group, Top/Bottom SKU, anomaly labels
- details: bounded SKU table
- footer_or_note: source table and update time

chart_decision:
- should_use_chart: no by default
- business_question: which SKU needs action first
- recommended_chart_type: none unless category-level trend or contribution is provided
- data_requirements: ordered time nodes for trend, or explicit denominator for contribution
- why_not_table_or_kpi: SKU rows need identity, status, decisive metric, and owner/action more than a decorative chart
- fallback: Top/Bottom SKU table with status tags
- implementation_verification_needed: chart_spec only if a trend/contribution chart is later added

number_emphasis_rules:
- emphasized_numbers: [stockout_count, severe_refund_rate_delta, conversion_drop]
- emphasis_method: table status column and short risk tag; inline color only for the decisive delta
- color_semantics: red for stockout or severe deterioration, orange for warning threshold, green only for recovered inventory or improved conversion when higher is good
- numbers_not_to_emphasize: [raw SKU IDs, image counts, unchanged sales values]
- missing_context: [thresholds, baseline, metric_direction]

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: unknown
- official_components: [markdown, div, table]
- conditional_components: [column_set, img]
- conceptual_only_patterns: [KPI group, anomaly label, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [vertical metric stack, SKU text identity instead of image]
- implementation_verification_needed: [column nesting, table columns, image resource and fields]

component_plan:
- data_display: bounded table for SKU rows; thumbnail only when recognition changes the decision
- interactions: verified button or detail link for product detail; assignment stays conceptual unless interaction support is confirmed
```

## Sales Data

Input: monthly revenue, target completion, forecast gap, opportunities by stage.

```markdown
card_intent:
- data_type: KPI + time series + funnel stages + opportunity rows
- intent: report and diagnose
- audience: management

card_pattern:
- name: executive_summary_card
- why: target completion and forecast gap require decision-level focus

information_architecture:
- first_screen: target completion, forecast gap, key risk
- body: trend evidence, stage composition, top risks
- details: opportunity rows folded or linked
- footer_or_note: CRM source, period, forecast assumptions

chart_decision:
- should_use_chart: conditional
- business_question: whether forecast gap is caused by trend weakness, stage conversion, or region/channel split
- recommended_chart_type: line chart for ordered revenue trend; funnel chart for stage conversion; stacked or grouped bar for compatible region/channel split
- data_requirements: consistent period, unit, scope, stage definitions, target/forecast baseline, and compatible denominators
- why_not_table_or_kpi: use KPI for headline completion; chart only if it explains movement or stage loss faster
- fallback: KPI completion plus staged markdown/table for funnel and Top-N opportunity risks
- implementation_verification_needed: VChart chart_spec, chart component fields, mobile render, and authoring path

number_emphasis_rules:
- emphasized_numbers: [target_completion_rate, forecast_gap, largest_negative_movement]
- emphasis_method: one key KPI hierarchy plus status tag; inline color only for the decisive gap/delta
- color_semantics: red for missed target or expanding negative gap, orange for near-risk, green for target reached or recovered forecast
- numbers_not_to_emphasize: [all region values, neutral opportunity amounts without risk ranking]
- missing_context: [target, forecast assumptions, whether higher/lower is good]

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: unknown
- official_components: [markdown, div, table]
- conditional_components: [column_set, chart, collapsible_panel]
- conceptual_only_patterns: [KPI group, funnel visualization, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [vertical metric stack, staged markdown or bounded stage table, detail link]
- implementation_verification_needed: [column nesting, chart_spec, table columns, collapsible authoring path]
```

## Article Or News Digest

Input: front-edge AI blog list with titles, links, sources, summaries.

```markdown
card_intent:
- data_type: article list + external links
- intent: preserve knowledge and triage reading
- audience: knowledge/news

card_pattern:
- name: digest_card
- why: reader needs priority, summary, source, and feedback

information_architecture:
- first_screen: topic, collection period, must-read items
- body: must-read, optional, and archive groups
- details: related links folded or linked
- footer_or_note: source count and collection time

chart_decision:
- should_use_chart: no
- business_question: not applicable; reader needs triage and source attribution
- recommended_chart_type: none
- data_requirements: none
- why_not_table_or_kpi: chart does not improve article selection
- fallback: categorized markdown list with source and priority tags
- implementation_verification_needed: none for chart

number_emphasis_rules:
- emphasized_numbers: [must_read_count only if it changes workload]
- emphasis_method: tag or short text, not inline color by default
- color_semantics: neutral unless priority or freshness is a real status
- numbers_not_to_emphasize: [source counts, collection totals]
- missing_context: []

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: unknown
- official_components: [markdown, div, button, overflow]
- conditional_components: [collapsible_panel]
- conceptual_only_patterns: [article group, button row, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [markdown article list, one primary button plus text links, archive link]
- implementation_verification_needed: [link syntax, button fields, interaction behavior, collapsible authoring path]

interaction_rules:
- primary_action: open must-read item when a verified button or link path is available
- secondary_actions: useful, not interested, or read later only when the host supports the callbacks
```

## Approval Card

Input: procurement approval with applicant, amount, reason, impact, approver.

```markdown
card_intent:
- data_type: process object + amount + risk fields
- intent: decide
- audience: frontline execution

card_pattern:
- name: action_approval_card
- why: user must make an auditable decision

information_architecture:
- first_screen: object, applicant, amount, current state, deadline
- body: reason, impact, risk, evidence
- details: purchase details and history folded or linked
- footer_or_note: audit fields

chart_decision:
- should_use_chart: no
- business_question: approval decision is based on facts and policy thresholds, not visual trend
- recommended_chart_type: none
- data_requirements: none
- why_not_table_or_kpi: amount and impact should be shown as decision facts
- fallback: labeled fact block
- implementation_verification_needed: none for chart

number_emphasis_rules:
- emphasized_numbers: [amount only when it crosses an approval or risk threshold]
- emphasis_method: risk tag or key fact hierarchy; avoid inline color if current state already uses a status header
- color_semantics: red for severe policy/risk breach, orange for pending or near-threshold, neutral for ordinary amount
- numbers_not_to_emphasize: [approval id, audit timestamp, ordinary amount below threshold]
- missing_context: [policy_threshold, budget_scope]

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: json
- official_components: [markdown, div, button, overflow]
- conditional_components: [column_set, form, input, collapsible_panel]
- conceptual_only_patterns: [decision facts, button row, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [labeled div facts, one primary button plus overflow, external reason form, detail link]
- implementation_verification_needed: [column nesting, button and form fields, callback behavior, idempotency, collapsible nesting]

interaction_rules:
- primary_action: approve
- secondary_actions: reject, return for changes, view details
- acceptance_state: lock controls and state that the interaction was received
- processing_state: show only when downstream work is genuinely asynchronous
- terminal_states: approved, rejected, returned, cancelled, expired, failed, needs_input
- audit_or_feedback: approver, time, comment
```

## Retrospective Analysis

Input: campaign performance dropped, with KPI comparison, suspected causes, action items.

```markdown
card_intent:
- data_type: KPI comparison + evidence + action rows
- intent: diagnose and improve
- audience: retrospective analysis

card_pattern:
- name: analysis_card
- why: needs conclusion, evidence, cause, and corrective action

information_architecture:
- first_screen: one-sentence conclusion, impact, baseline
- body: comparison evidence, evidence rows, cause hypothesis
- details: raw campaign data folded or linked
- footer_or_note: data source and limitations

chart_decision:
- should_use_chart: conditional
- business_question: whether the drop is sudden, persistent, or isolated to one segment
- recommended_chart_type: line chart for ordered performance trend; grouped bar for compatible segment comparison
- data_requirements: consistent time grain, baseline, unit, and segment scope
- why_not_table_or_kpi: KPI states impact; chart adds value only for persistence, volatility, or segment split
- fallback: markdown comparison with baseline plus bounded evidence table
- implementation_verification_needed: chart_spec, table columns, mobile render

number_emphasis_rules:
- emphasized_numbers: [drop_delta, impact_amount, confidence_level]
- emphasis_method: one inline delta color plus confidence/risk tag
- color_semantics: red for severe drop when lower is bad, orange for weak evidence or warning, gray for low-confidence unavailable data
- numbers_not_to_emphasize: [raw evidence row values not tied to cause]
- missing_context: [baseline, metric_direction, confidence_basis]

feasibility_check:
- target_schema: Feishu Card JSON 2.0
- authoring_path: unknown
- official_components: [markdown, div, table]
- conditional_components: [chart, collapsible_panel]
- conceptual_only_patterns: [comparison evidence, metadata note]
- unsupported_or_unverified_requests: []
- fallbacks: [markdown comparison with baseline, bounded evidence table, detail link]
- implementation_verification_needed: [chart_spec, table columns, collapsible authoring path]

component_plan:
- data_display: choose chart only after chart_spec validation; otherwise use a bounded evidence table or markdown comparison
- interactions: detail link; task creation remains conceptual unless a verified host action exists
```
