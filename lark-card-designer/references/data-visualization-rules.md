# Data Visualization And Number Emphasis Rules

Use this file whenever the input contains metrics, trends, composition, rankings, funnel stages, target gaps, anomalies, or any request about charts or colored numbers.

This skill recommends chart intent and number emphasis rules only. It does not generate VChart specs, production JSON, field-level syntax, or color enum values without official verification.

## Chart Suitability Gate

Recommend a chart only when all gates pass:

1. The card has a visual question: change over time, composition, ranking, funnel movement, target gap, distribution, correlation, or anomaly context.
2. The data has enough compatible points: consistent period, unit, denominator, scope, and calculation definition.
3. The chart answers the reader's decision faster than a sentence, KPI group, or bounded table.
4. The chart can stay small and legible on Feishu/Lark desktop and mobile.
5. The implementation owner can verify the `chart` component and the exact VChart `chart_spec`.

If any gate fails, prefer KPI + delta, markdown comparison, Top-N table, staged list, or bounded evidence table.

## Chart Type Decision Matrix

| Data question | Prefer | Required data condition | Fallback |
| --- | --- | --- | --- |
| Is a metric rising, falling, or volatile over ordered time? | line chart or compact trend chart | 3+ ordered time points using the same grain | latest KPI + delta + short trend sentence |
| How do categories contribute to a whole? | donut, pie, stacked bar, or horizontal bar | explicit denominator, scope, period, and share definition | ranked contribution table with share |
| Which items are top/bottom or moving most? | horizontal bar or Top-N table | clear rank key and bounded N | Top-N table/list |
| Where does a sales or conversion path lose volume? | funnel-style chart when spec is verified | ordered stages with comparable stage counts/rates | staged table or markdown stage list |
| How far are we from target or forecast? | target-gap chart only when visual adds value | current, target/forecast, period, unit, gap definition | KPI value + gap delta + status tag |
| Which stage/category changed between periods? | grouped or stacked bar | compatible periods, categories, denominator, and unit | comparison table with change column |
| Is an anomaly isolated or persistent? | line chart with highlighted context | ordered baseline and current value | abnormal label + baseline sentence |

## Do Not Use A Chart When

- There is only one decisive value and one comparison baseline.
- The input has raw rows but no visual question.
- Periods are aggregate windows such as 1-day, 7-day, and 30-day without underlying ordered nodes.
- Categories exceed the card's readable capacity; use Top-N plus folded details.
- Values use incompatible units, scopes, denominators, or calculation definitions.
- The chart would be decorative, harder to read than text, or impossible to validate before handoff.

## Chart Handoff Requirements

Every recommended chart must state:

- `should_use_chart`: yes, no, or conditional
- `business_question`: the exact question the chart answers
- `chart_type`: design intent, not production spec
- `data_requirements`: period, grain, unit, denominator, scope, series, rank key, or baseline
- `why_not_table_or_kpi`: one short reason, or state that table/KPI is better
- `fallback`: non-chart fallback if `chart_spec`, authoring path, mobile rendering, or data quality fails
- `implementation_verification_needed`: VChart spec, component fields, nesting, client behavior, and real render

## Number Emphasis Gate

Emphasize a number only when it changes interpretation or action.

Use emphasis for:

- status-changing values: pass/fail, approved/rejected, completed/failed
- deltas against a baseline: YoY, MoM, previous period, target, forecast, threshold
- abnormal values: outliers, stockout, severe drop, stale data, missing coverage
- priority values: P0/P1 risk, top loss, biggest movement, highest opportunity
- confidence or data quality values when trust affects the decision

Do not emphasize:

- every metric in a KPI group
- raw counts without baseline or action meaning
- table rows just because they contain numbers
- values whose positive/negative meaning depends on context that is missing
- decorative increases where higher is actually bad, such as defect rate or refund rate

## Number Emphasis Method

Choose the smallest emphasis that works:

1. Text label or tag for status, risk, priority, confidence, or missing data.
2. Bold or stronger hierarchy for the one decisive KPI.
3. Inline color for 1 to 3 short fragments such as a delta, target gap, or status word.
4. Table status column for row-level scanning.
5. Header color only when the whole card has one dominant state.

Color must be semantic and paired with text. If many values need color, redesign the structure with tags or a status column instead of coloring many fragments.

## Numeric Color Semantics

| Meaning | Suggested intent | Examples |
| --- | --- | --- |
| Healthy, recovered, target reached, positive when higher is good | green | `+12%`, `达标`, `已恢复` |
| Severe risk, target missed, failed, negative when lower is bad | red | `-18%`, `缺口 32 万`, `断货` |
| Warning, near threshold, pending, unstable | orange or yellow | `库存预警`, `距阈值 3%`, `待确认` |
| Running, informational, neutral analysis | blue or cyan | `分析中`, `执行中` |
| Historical, disabled, unavailable, secondary | gray | `无数据`, `已归档` |

For inverse metrics, state the business direction before applying color. Example: refund rate `+2.3pp` is usually risk/red, while revenue `+2.3%` may be healthy/green.

## Required Output Additions

When metrics or charts are relevant, include:

```markdown
chart_decision:
- should_use_chart:
- business_question:
- recommended_chart_type:
- data_requirements:
- why_not_table_or_kpi:
- fallback:
- implementation_verification_needed:

number_emphasis_rules:
- emphasized_numbers:
- emphasis_method:
- color_semantics:
- numbers_not_to_emphasize:
- missing_context:
```

If no chart or colored number is useful, still say so briefly in these fields when the user explicitly asks about visualization or emphasis.
