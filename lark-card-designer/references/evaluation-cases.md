# Evaluation Cases

Use this file to check whether the skill is producing stable design decisions. These are golden behavior cases, not user-facing examples and not production test fixtures.

For each case, compare the output against expected pattern, key data, component choices, and red lines. A good output may use different wording, but it must preserve the design decision.

## Case Matrix

| Case | Input signal | Expected pattern | Must include | Fail if |
| --- | --- | --- | --- | --- |
| Weekly operations report | Weekly KPI, trend, risks, owners | `ops_dashboard_card` | period, status, 3 to 5 KPI, trend, top risk, owner/action, source/update time | raw rows appear before conclusion; more than 6 flat KPI compete |
| Executive sales report | Revenue, target, forecast gap, region split | `executive_summary_card` | target completion, forecast gap, risk, biggest movement, period, source | opportunity rows dominate first screen |
| Product/SKU operations | SKU rows, inventory, sales, conversion, refund | `ops_dashboard_card` | scope, health, anomaly, Top/Bottom SKU, bounded SKU table, unit | product images dominate metrics; unbounded SKU table |
| Article/blog digest | Titles, links, sources, summaries | `digest_card` | topic, collection time, must-read/optional/archive, source, link, priority | full articles pasted; summaries lack source |
| Procurement approval | Applicant, object, amount, reason, impact, deadline | `action_approval_card` | object, applicant, current state, amount/scope, risk, deadline, approve/reject/return, audit fields | treated as report; action buried or no final state |
| Metric retrospective | KPI drop, baseline, cause hypothesis, actions | `analysis_card` | conclusion, impact, baseline, evidence, cause confidence, action owner/deadline | cause stated without evidence; raw logs first |
| Incident alert | Severity, impacted object, cause, mitigation | `alert_card` unless action is required | status, impact, cause, mitigation, update time, action link if needed | decorative urgency; vague "something is wrong" wording |
| Long-running task | Current step, partial results, logs | `progress_card` | current state, step, blocker/next update, latest result, folded logs | many separate result cards; logs dominate first screen |

## Review Procedure

1. Identify which case is closest to the user input.
2. Check that `card_pattern.name` matches the expected pattern or has a clear justified alternative.
3. Check that `key_data_rules.must_show` includes the required trust fields: period, source, unit, owner, deadline, or audit trail when relevant.
4. Check that `component_plan.data_display` matches the data shape: KPI blocks for few metrics, native table for bounded rows, chart for trend/composition/funnel, collapsible panel for raw evidence.
5. Check that `visual_rules.color_policy` starts neutral and adds color only for status, risk, priority, trend, or action focus.
6. Check that action cards include button layout, disabled/loading/final states, and audit feedback.
7. Check that `structure_sketch` is labeled as a design handoff sketch only, not production-sendable Feishu JSON.
8. Check that `design_red_lines` names the main failure modes for this scenario, not generic advice only.

## Common Regression Signals

- Every dataset becomes a table-first dashboard.
- Every card receives a strong color theme.
- Approval cards omit final locked state.
- Digests lose source attribution.
- Reports omit period, unit, source, or baseline.
- Long evidence is not folded.
- The output claims to generate production-ready JSON, field-level schemas, callback contracts, or implementation code.
