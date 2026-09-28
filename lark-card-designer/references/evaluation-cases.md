# Evaluation Cases

Use this file to check whether the skill is producing stable design decisions. These are golden behavior cases, not user-facing examples and not production test fixtures.

For each case, compare the output against expected pattern, key data, component choices, and red lines. A good output may use different wording, but it must preserve the design decision.

## Case Matrix

| Case | Input signal | Expected pattern | Must include | Fail if |
| --- | --- | --- | --- | --- |
| Weekly operations report | Weekly KPI, trend, risks, owners | `ops_dashboard_card` | period, status, 3 to 5 KPI, trend, top risk, owner/action, source/update time | raw rows appear before conclusion; more than 6 flat KPI compete |
| Operational anomaly reminder | Daily operations, product group, sameSkuGroup, mapping gaps, fallback, or anomaly triage | `ops_dashboard_card`, `analysis_card`, or `alert_card` depending on depth | primary subject, reader first question, data freshness/confidence when relevant, trend or baseline, prioritized object, evidence strength, suggested next step or verification action | source-by-source dump leads; weak attribution is stated as fact; low confidence is hidden; static value is used as trend without baseline |
| Relative contribution analysis | Object performance within a total market, catalog, channel, or portfolio | `ops_dashboard_card` or `analysis_card` | contribution/share or rank, explicit denominator/scope, compatible period/grain, missing-value semantics, evidence boundary for stage gaps | raw scale answers a relative-position question; denominator is hidden; 1d/7d/30d windows are drawn as a continuous trend; missing is treated as zero |
| Executive sales report | Revenue, target, forecast gap, region split | `executive_summary_card` | target completion, forecast gap, risk, biggest movement, period, source | opportunity rows dominate first screen |
| Product/SKU operations | SKU rows, inventory, sales, conversion, refund | `ops_dashboard_card` | scope, health, anomaly, Top/Bottom SKU, bounded SKU table, unit | product images dominate metrics; unbounded SKU table |
| Article/blog digest | Titles, links, sources, summaries | `digest_card` | topic, collection time, must-read/optional/archive, source, link, priority | full articles pasted; summaries lack source |
| Procurement approval | Applicant, object, amount, reason, impact, deadline | `action_approval_card` | object, applicant, current state, amount/scope, risk, deadline, approve/reject/return, audit fields | treated as report; action buried or no final state |
| Long-running card action | Button, form, approval, clarification, or execution action starts planning, external reads, or batch work | original action pattern with acceptance/progress state overlay | accepted versus completed semantics, locked controls, truthful processing phase when needed, side-effect boundary, visible duplicate-action feedback, complete terminal states, safe-to-leave guidance when relevant | accepted state claims success; duplicate click is silent or starts another progress card; processing has no terminal state; clarification selection is described as executed; callback code or payloads are emitted |
| Metric retrospective | KPI drop, baseline, cause hypothesis, actions | `analysis_card` | conclusion, impact, baseline, evidence, cause confidence, action owner/deadline | cause stated without evidence; raw logs first |
| Incident alert | Severity, impacted object, cause, mitigation | `alert_card` unless action is required | status, impact, cause, mitigation, update time, action link if needed | decorative urgency; vague "something is wrong" wording |
| Long-running task | Current step, partial results, logs | `progress_card` | current state, step, blocker/next update, latest result, folded logs, explicit final pattern | many separate result cards; logs dominate first screen; final card stays process-first |
| Streaming AI response | Progressive answer, tool steps, feedback after completion | `progress_card` with streaming overlay, then result pattern | reason for streaming, update mode, one primary streaming region, stable regions, exception states, interaction transition, finalization and fallback | short content streams for effect; multiple text regions compete; hidden reasoning or raw logs are exposed; active streaming contains complex approval/form interaction |
| Time-limited approval or execution | Deadline, countdown, cooldown, expiring action, or SLA boundary | original action/approval/progress pattern plus dynamic-time overlay | time role, authority, timezone, absolute time, display mode, precision, refresh policy, thresholds, action linkage, zero state, stale fallback | invented countdown component; every deadline gets seconds; visible zero is treated as authoritative completion; no absolute time, stale state, or terminal action behavior |
| Real-client preview review | Feishu desktop/mobile screenshots, preview version, rendered interaction states, or visual acceptance request | existing scenario pattern plus `preview_review` overlay | version, evidence reviewed, observed issues versus inferred risks, responsive behavior, interaction safety, prioritized revisions, verdict, acceptance criteria | JSON or source is treated as visual proof; implementation/send/deployment steps are produced; IDs or credentials are repeated; no version or viewport is identified |
| JSON 2.0 feasibility handoff | Any design expected to become Feishu Card JSON 2.0 | original scenario pattern plus mandatory feasibility gate | target schema, authoring path, exact official component tags, conceptual mappings, conditions, fallbacks, implementation verification | invented/deprecated tag; pseudo schema; root elements; guessed field/style; compatibility claimed without exact verification |
| Visual-builder handoff | Card must be authored in the visual builder | original scenario pattern with authoring-path constraints | only builder-supported capabilities or explicit fallback; unsupported JSON-only components remain conditional | `collapsible_panel`, `select_img`, `checker`, or `audio` is prescribed as directly available in the visual builder |
| Chart recommendation | Trend, composition, funnel, or target-gap visual | original scenario pattern with conditional chart | business question, chart type intent, compatible data grain, `chart_spec` verification requirement, non-chart fallback | chart is called sendable or compatible from the `chart` tag alone; fabricated VChart fields or no fallback |
| Chart rejection | Single KPI, article digest, approval amount, or raw rows without a visual question | original scenario pattern without chart | explicit `chart_decision.should_use_chart: no` or equivalent, reason why KPI/table/text is clearer | decorative chart is added; chart chosen because data is numeric only |
| Number emphasis | Deltas, threshold breaches, inverse metrics, risk counts, missing/low-confidence values | original scenario pattern plus number emphasis rules | emphasized values, method, color semantics, metric direction, numbers not emphasized | every number is colored; positive/negative color ignores metric direction; color carries meaning without text/tag |
| Daily report datasource timeouts with expired credentials (Case A) | 5 datasource timeouts, 3 credential expiries, source, update time, and recovery status omitted | `alert_card` or `ops_dashboard_card` (exception state) | truthful representation of 5 datasource timeouts and 3 credential expiries, unknown/placeholder status for unprovided source, update time, impacted scope, and recovery status, proposed retry action, semantic consistency across conclusion, interactions, and sketch | claiming self-healing or automatic recovery; fabricating source, update time, or scope; escalating proposed retry into executed fact; hiding unverified "system auto-downgraded" or "task center archive" facts in the structure sketch or metadata while claiming unrecovered at the top |
| Shared card read-only review window (Case B) | Read-only reconciliation review, typical duration 2-5 min, shared group card, multi-user audience | `progress_card` or `analysis_card` | processing/read-only review state, 2-5 min labeled as expected range rather than hard failure timeout, shared card semantics (unverified per-user isolation is not assumed), final reconciliation status kept conditional/pending | failing automatically at 5 min with retry trigger; treating review start or review success as final account settled/reconciled; writing "12 differences reconciled and balanced" in terminal state or declaring "reconciliation triggered by final action" in side_effect/actions when the task was explicitly read-only review; assuming unverified per-user private views on a shared card |
| Long English notice without render (Case C) | Long English notification, localized/multilingual context, no client preview render available | `alert_card` or `digest_card` | default evidence status `pre_render_design`, localized multilingual typography design intent, mobile density and text wrap marked as `pending_real_render` (never `[x]`), validation checklist containing only applicable items | claiming visual acceptance without client render evidence; checking `[x]` on mobile density without render; rejecting design or blocking delivery solely because render evidence is absent |
| Authoritative verified handoff (Case D) | Explicit authoritative deadline provided, actual reconciliation result available, verified JSON 2.0 delivery model | original scenario pattern matching verified inputs (e.g. `action_approval_card` or `ops_dashboard_card`) | fully adopting authoritative deadline and verified reconciliation result, assigning verified status matched strictly to verified scope (`checked` at design layer, conditional on implementation/rendering), preserving closed fact scope and field roles; explicit numeric/format derivations only | blanket rejection of authoritative inputs; marking explicitly provided facts as unknown; claiming full client visual acceptance beyond the verified scope; inventing owner/status/result/time/side effect, treating `update_time` as completion, or treating `completed` as passed/no outstanding items |

## Review Procedure

1. Identify which case is closest to the user input.
2. Check that `card_pattern.name` matches the expected pattern or has a clear justified alternative.
3. Check that `key_data_rules.must_show` includes the required trust fields: period, source, unit, owner, deadline, or audit trail when relevant.
4. Check that `component_plan.data_display` matches the data shape: conceptual KPI groups map to verified components, bounded rows use `table`, charts stay conditional until `chart_spec` validation, and folded evidence has an authoring-path fallback.
5. Check that `chart_decision` says whether a chart is useful, names the business question, selects a chart type only when data grain is compatible, and provides a non-chart fallback.
6. Check that `number_emphasis_rules` names only decision-changing values, states the emphasis method, and handles inverse metrics such as refund rate, defect rate, cost, latency, or risk count.
7. Check that `visual_rules.color_policy` starts neutral and adds color only for status, risk, priority, trend, or action focus.
8. When `column_set` is used for KPI or peer comparison, check that `design_constraints.column_treatment` defaults to shared weak neutral contrast; alignment-only rows may remain plain, and different chromatic column backgrounds require real semantic differences.
9. For operational analytics, check that the card is organized by decision or action priority rather than data-source order, and that low-confidence conclusions remain visibly uncertain.
10. For relative contribution or position analysis, check denominator, scope, time grain, and missing-value semantics.
11. For streaming, check the reason, update mode, one primary streaming region, active-to-final interaction transition, exception states, and final result pattern.
12. For countdowns or other dynamic time, check the authority, timezone, absolute-time fallback, display mode, precision, visible refresh policy, threshold semantics, zero behavior, stale fallback, and action linkage. Confirm that a changing time value is not mislabeled as text streaming.
13. For real-client preview review, check that findings are tied to a version and evidence, observed issues are separated from inferred risks, sample data is anonymized, interactions are non-production, and the verdict does not imply deployment approval.
14. Check that action cards include button layout, disabled/accepted/processing/final states, and audit feedback.
15. For long-running actions, check that acceptance does not claim completion, duplicate clicks receive a visible stable state, side-effect boundaries are clear, and every processing state has a terminal or needs-input path.
16. Check that implementation constraints remain handoff requirements and do not turn into callback payloads, HTTP handling, queue design, API calls, or code.
17. Check that `feasibility_check` separates `official_components`, `conditional_components`, `conceptual_only_patterns`, and `unsupported_or_unverified_requests`.
18. Check every implementation-facing body component against the exact JSON 2.0 whitelist. Nested tags may appear only as nested mappings, never as generic `body.elements` components.
19. Check that authoring-path restrictions are explicit. JSON-only and visual-builder-only capabilities must not be transferred across authoring paths without a fallback.
20. Check that `structure_sketch` is labeled as a design handoff component map only, not production-sendable Feishu JSON, and that it contains no JSON-looking envelope.
21. Check that `design_red_lines` names the main failure modes for this scenario, not generic advice only.
22. For Case A, verify that input facts (e.g. 5 datasource timeouts, 3 credential expiries) are not upgraded to self-healed, unprovided sources, update times, recovery status, or scopes remain unknown/placeholder, proposed actions are not described as executed, and structure sketches or metadata do not sneak in fabricated "auto-downgrade" or "archived" facts.
23. For Case B, verify that read-only review periods (e.g. 2-5 min) are not turned into automatic failure timeouts, review progress is not conflated with final balanced accounts, terminal states and side effects do not exceed the original read-only semantics (never claim 12 differences reconciled or action-triggered balance adjustments), and shared cards do not assume unverified per-user personalization.
24. For Case C, verify that unrendered cards default to `pre_render_design`, mobile density is marked as `pending_real_render` (never `checked`), the checklist outputs only applicable items using the selective template, and the skill does not block design by demanding mandatory screenshots.
25. For Case D, verify that explicitly provided authoritative deadlines and verified review results are respected and used, with verification status strictly matching the proven scope; business people, states, results, times, and side effects come only from `provided_facts`; missing people use `<owner>`; `derived_facts` contains only explicit numeric/format derivations (for example, `12 - 2 = 10`, never "10 verified / no errors"); a date supplied only as Sep 21 does not gain a year; `update_time` is not completion; `completed` does not imply passed/no outstanding items; and owner/source/time/outcome references remain slots rather than value authorization.

## JSON 2.0 Hard Failures

Fail the output immediately when any item below is present in an implementation-facing recommendation:

- An invented or deprecated body tag such as `note`, `action`, `collapsible`, `button_group`, `form_optional`, or any `_or_` combination.
- An invented dynamic-time body tag such as `countdown` or `timer`.
- A pseudo-schema such as `schema: json_2_0_like` or a structure that places body components under root `elements` instead of `body.elements`.
- Arbitrary CSS-like properties, generic style objects, HTML layout, gradients, shadows, fonts, flex/grid declarations, or unverified fields/enums presented as Feishu support.
- A component or feature is declared supported without checking its exact official document when fields, nesting, authoring path, client version, resources, forwarding, or interaction behavior matter.
- A nested tag such as `column`, `plain_text`, `lark_md`, `text_tag`, `standard_icon`, `custom_icon`, or `fallback_text` is used as a generic body component.
- `chart` is declared implementation-compatible without requiring validation of its VChart `chart_spec` and providing a non-chart fallback.
- A JSON-only component is prescribed for a visual-builder implementation, or a visual-builder-only capability is represented as a JSON tag.
- A conditional or unsupported/unverified request has no conservative fallback.
- The handoff claims production sendability, successful validation, or API acceptance without a real implementation-side validation and send/render test.

Allowed occurrences of invalid names are limited to explicit warnings, negative examples, and compatibility tests that clearly say never to use them.

## Common Regression Signals

- Every dataset becomes a table-first dashboard.
- Every card receives a strong color theme.
- Approval cards omit final locked state.
- Long-running actions confuse accepted with completed, hide duplicate-click feedback, or remain permanently processing.
- Clarification cards describe a selected option as already executed instead of continuing understanding or planning.
- Digests lose source attribution.
- Reports omit period, unit, source, or baseline.
- Chart decisions omit the business question, data grain, chart fallback, or `chart_spec` verification requirement.
- Numeric emphasis colors every number, ignores thresholds/baselines, or treats all positive deltas as healthy.
- Operational analytics cards show many metrics but no primary subject, priority order, confidence, or next-step judgment.
- Relative-position cards use raw values without denominator, scope, or a valid comparison grain.
- Streaming cards expose logs or reasoning, keep several regions moving, or never transition to a stable final pattern.
- Countdown designs default to seconds, omit the authoritative absolute time, silently reset, show negative time, or leave actions enabled after confirmed expiry.
- Preview reviews trust code instead of rendered evidence, omit mobile or state coverage when relevant, or drift into sender scripts and deployment instructions.
- Long evidence is not folded.
- Conceptual labels look like component tags or are placed in JSON-looking structures.
- Authoring-path restrictions are absent, so JSON-only components leak into visual-builder designs.
- A valid component tag is treated as proof that all fields, nesting, or chart specs are valid.
- The output claims to generate production-ready JSON, field-level schemas, callback contracts, or implementation code.
- Input facts, assumptions, and proposed actions are conflated (e.g. timeouts self-heal, unverified update times or scopes are invented, proposed retries become completed transactions).
- Sketch or metadata sneaks in fabricated facts (e.g. "auto-downgraded" or "archive center") even when top text acknowledges unrecovered status.
- Shared read-only cards enforce hard timeout failures on estimated review durations, treat progress as settled accounts, write balance reconciliation into terminal state/side effects, or invent unverified per-user view logic.
- Outputting the full candidate checklist unconditionally, providing subjective "self-checked" claims as evidence_scope, or marking unrendered visual items (like mobile density) as checked.
- Blanket rejection of authoritative provided facts or claiming visual acceptance beyond the verified scope.
- Facts escape their closed scope or field roles change: invented owner/status/result/time/side effect; inferred year for a partial date; `update_time` presented as completion; `completed` presented as passed or no outstanding items; arithmetic relabeled as a business verdict; or reference slots treated as permission to populate values.
- A subtraction-derived value is labeled as "settled", "verified", "normal", or "no discrepancy" rather than its literal numeric meaning.
- An unsupported persistence or notification claim such as "persisted to DB", "archived", "notified", "synced", "auto-refreshing", or "viewable anytime" is stated as fact.

## Validation Checklist Candidate Reference

When constructing the selective `validation_checklist` in the structured decision block, choose only items that apply to the current scenario. Do not output all candidate items.

- [ ] first screen states the point
- [ ] required key data for this data type is visible
- [ ] operational analytics cards define the primary subject, reader first question, confidence, priority order, and supported next step when relevant
- [ ] relative-position or contribution claims show the denominator/scope and use a valid comparison grain
- [ ] key numbers include period, unit, and baseline when needed (only required when input provides them or they are explicitly known; do not fabricate)
- [ ] chart_decision explains whether a chart is useful, which business question it answers, and why KPI/table is not enough or is better
- [ ] recommended chart type matches the data shape and uses compatible grain, denominator, scope, unit, and series definitions
- [ ] every chart remains conditional until `chart_spec`, component fields, client behavior, and real render are verified, with a non-chart fallback
- [ ] number_emphasis_rules identify only decision-changing values for tag, bold, or inline color emphasis
- [ ] positive/negative colors follow the metric's business direction, especially inverse metrics such as refund rate, defect rate, cost, latency, or risk count
- [ ] feasibility check classifies official, conditional, conceptual-only, and unsupported/unverified capabilities
- [ ] every implementation-facing component name is an official JSON 2.0 tag or a clearly labeled nested tag
- [ ] conceptual names are mapped to real components and never presented as JSON tags
- [ ] conditional components include authoring-path, client, resource, nesting, chart-spec, or interaction constraints and a fallback
- [ ] no fields, enum values, Markdown extensions, HTML tags, or CSS-like properties are guessed
- [ ] any implementation JSON uses schema 2.0 and body.elements; the design handoff itself remains a non-JSON component map
- [ ] component choice matches the data shape
- [ ] KPI and comparison-oriented column groups default to one shared weak neutral background with adequate padding and spacing
- [ ] columns used only for label-value, button, form, or image-text alignment may remain backgroundless
- [ ] sibling columns use different chromatic backgrounds only when they represent real semantic differences, with text or tags carrying the same meaning
- [ ] tables are bounded or folded
- [ ] any used status colors carry semantic meaning
- [ ] inline text color is omitted unless local semantic emphasis is needed
- [ ] actions, button layout, and disabled/accepted/processing/final states are clear
- [ ] long-running actions separate accepted from completed, define truthful processing only when needed, and include complete terminal or needs-input states
- [ ] repeated actions receive a visible stable state, and clarification selections are not described as already executed
- [ ] side-effect boundaries and whether the reader may leave are clear when relevant
- [ ] streaming cards use one primary streaming region, explicit exception states, and a stable final-result pattern when relevant
- [ ] dynamic time defines its authority, timezone, display mode, visible precision, refresh policy, zero-boundary behavior, stale fallback, and action linkage when relevant
- [ ] countdowns map to a static or repeatedly updated verified text region rather than an invented timer component, and text streaming is used only for progressive text
- [ ] input/select/form controls have labels, defaults, validation, and empty/error states when used
- [ ] source, period, owner, or audit fields are present when needed (keep as pending confirmation or omit when not provided; do not force fabrication)
- [ ] mobile reading density is acceptable (mark as pending_real_render when corresponding real-client render evidence is unavailable; never mark checked)
- [ ] real-client preview evidence is requested when rendering-dependent risk cannot be resolved from a structure sketch
