# Visual And Status Rules

Visual design should make state and hierarchy easier to scan. It should not add decoration that competes with meaning.

## Status Color Semantics

| State | Suggested color | Use for |
| --- | --- | --- |
| Success, healthy, recovered, completed, approved | Green | Target reached, approval passed, incident recovered |
| Failure, rejected, severe risk, urgent | Red | Deployment failed, approval rejected, stockout, severe target gap |
| Warning, pending, needs attention, near risk | Orange or yellow | Pending approval, metric fluctuation, inventory warning |
| Informational, running, analysis, neutral notice | Blue or cyan | In-progress task, normal report, informational digest |
| Historical, archived, disabled, secondary | Gray | Closed item, audit history, disabled button, appendix |

Use only one dominant status color per card header. Use tags for secondary statuses.

## Emphasis Rules

- Emphasize the answer, not every interesting number.
- Use emphasis color on header, key number, risk tag, or primary action area.
- Use bold text for labels or conclusions sparingly.
- If every row is highlighted, nothing is highlighted.

## Data-Driven Design Strategies

| Data Type | Design Focus | Aesthetic Goal | Avoid |
| --- | --- | --- | --- |
| **Agent / Permission** | Scope, Impact, Risk Level | Technical Rigor (Security-first) | Social elements (avatars), vague descriptions |
| **KPI / Reports** | Hierarchy, Order, Benchmarks | Structural Clarity (Information-rich) | Over-simplification, hiding key context |
| **Alerts / Incident** | Status, Root Cause, Action | Urgent Clarity (Speed-first) | Decoration, long explanations |

## Scene-Specific Rules

### 1. Agent & Tech Approvals (De-personalized)
- **Identify the Identity**: Avatars are allowed for identity verification (e.g., Requesting User/Agent).
- **Strictly No Emojis**: Keep the visual language professional and technical. Do not use emojis for status or decoration.
- **Visuals**: Use `Tag` for permissions (e.g., `read_only`, `admin`). Use `Note` for technical logs/audit trails.

### 2. High-Density Reports (The Order Principle)
- **Complexity is OK**: For weekly/monthly reports, users expect data. Do not cut data; organize it.
- **Mobile Pivot Strategy**: When data exceeds 3 columns, **do not delete context**. Instead, pivot the layout:
    - **Vertical Stacking**: Convert secondary columns into a list or `Markdown` description below the primary data.
    - **Note Component**: Move audit-level strings (IDs, timestamps) to a `Note` area to keep main columns readable.
- **Visual Anchors**: Use `Divider` to separate modules. Use `ColumnSet` for side-by-side KPI comparison.

## Density Rules

- Management: Result-first, low density.
- Operations/Professional Reports: Structured high density (ensure visual alignment).
- Agent/Technical: Clean, high-contrast focus on critical fields.

## Label Rules

- Use labels for status, priority, type, owner, and action needed.
- Keep labels short: "高风险", "待审批", "缺货", "必读".
- Do not encode critical meaning only in color. Pair color with text.

## Approval State Machine

| State | Header meaning | Button state | Required visible fields |
| --- | --- | --- | --- |
| Pending | Needs decision | Approve/reject/return enabled | Applicant, object, reason, impact, deadline |
| Approved | Completed successfully | Primary buttons disabled or replaced | Approver, approval time, comment |
| Rejected | Completed negatively | Primary buttons disabled or replaced | Rejector, reject time, reason |
| Returned | Needs applicant revision | Decision buttons disabled for approver | Return reason, next owner |
| Expired | No longer actionable | All action buttons disabled | Expiry time, fallback path |
| Cancelled | Request withdrawn | All action buttons disabled | Canceller, cancel time, reason |

## Risk Language

- State risk as impact plus object, not vague alarm.
- Prefer "库存断货影响 3 个核心 SKU" over "库存有风险".
- For uncertain analysis, mark confidence or missing evidence.

## Mobile Readability

- Keep first-screen paragraphs short.
- Prefer 3 to 5 KPI blocks over many columns.
- Avoid wide tables on first screen.
- Put detailed tables behind collapsible panels or links.
