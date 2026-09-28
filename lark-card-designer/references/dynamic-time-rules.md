# Dynamic Time And Countdown Rules

Use this file when a Feishu/Lark card contains a deadline, countdown, elapsed duration, estimated completion time, cooldown, availability window, freshness age, or another time value that may change while the card remains visible.

Treat dynamic time as a scenario overlay, not as a standalone card pattern. Apply it to an approval, execution, alert, progress, report, or other card pattern. A changing time display may use repeated component updates, but it is not automatically text streaming.

## Classify The Time Intent

Classify the business meaning before choosing a countdown:

| Time role | Reader question | Default treatment |
| --- | --- | --- |
| `hard_deadline` | How long can I still act? | Absolute deadline plus relative time when urgency is material |
| `availability_window` | When does this action open or close? | Start/end time; countdown only near an actionable boundary |
| `cooldown` | When can I try again? | Relative remaining time plus next available absolute time |
| `soft_eta` | When is the result likely to be ready? | Approximate ETA or range; do not present as a hard countdown |
| `elapsed_duration` | How long has this process been running? | Elapsed time only when duration affects trust, escalation, or cancellation |
| `freshness_age` | How old is this data or status? | Last-updated time; relative age only when staleness changes interpretation |
| `sla_threshold` | When does this become late or severe? | Absolute target plus threshold state; count down only when action is expected |

Do not label an ETA, SLA estimate, or periodically refreshed value as a hard deadline. State uncertainty explicitly when the source can move.

## Decide Whether To Count Down

Use a live countdown only when all of these are true:

- the remaining time directly changes what the reader should do
- the boundary is close enough that relative time is more useful than an absolute timestamp alone
- the card has an authoritative deadline or remaining-time source
- the implementation can update the visible value with acceptable lag
- the zero boundary has a defined state and action consequence

Prefer an absolute timestamp, relative phrase, or threshold-only update when any of these apply:

- the deadline is hours or days away and no immediate action changes each minute
- the time is informational or audit-oriented
- the source is approximate, unstable, or frequently extended
- background, offline, or delayed-update behavior would make a live countdown misleading
- the card action is validated elsewhere and the timer would add urgency without clarity

Never add a countdown only to make a static card feel live.

## Choose Display Mode

Choose one display mode and explain why:

- `absolute_time`: use for audit, scheduling, long horizons, and cross-session reliability.
- `relative_time`: use for quick scanning when exact timing is secondary, such as `about 20 minutes remaining`.
- `countdown`: use for a short, actionable, authoritative window.
- `absolute_plus_relative`: default for consequential deadlines; show both `Ends at 18:00 (12 minutes remaining)`.
- `threshold_state`: update only when the card crosses meaningful phases such as normal, warning, critical, and closed.
- `elapsed_time`: use for long-running work only when elapsed duration changes confidence or action.

For timezone-sensitive use cases, show the absolute time in the relevant business timezone or use a verified localized-time rendering path. Do not assume the viewer's device timezone is the business timezone.

## Select Precision And Visible Refresh Cadence

Treat these as design heuristics for user-visible precision, not as CardKit request parameters:

| Remaining horizon | Recommended visible precision | Recommended design behavior |
| --- | --- | --- |
| Up to 5 minutes | Seconds only when every second changes action; otherwise minutes | Keep one stable timer region and define the exact zero transition |
| 5 to 60 minutes | Minutes | Periodic component update or threshold-only updates |
| 1 to 24 hours | Hours and minutes, or coarse relative time | Prefer absolute plus relative; update at meaningful thresholds rather than continuously |
| 1 to 7 days | Days and hours | Prefer absolute deadline with coarse relative context |
| More than 7 days | Date/time or days | Avoid continuous countdown; use reminders or threshold state changes |

Additional rules:

- Do not display more precision than the source and update path can sustain.
- Do not show seconds for a timer that may lag by many seconds.
- Avoid false percentage-style precision for approximate ETAs.
- Keep the displayed format stable within a phase. Avoid repeatedly changing between `2 days`, `47 hours`, and `2,819 minutes`.
- Define a `freshness_tolerance`: the maximum display lag after which the timer should show a stale or checking state instead of pretending to be current.

## Keep The Timer Region Stable

- Use one dedicated timer or dynamic-time region.
- Keep its label and position stable while the value changes.
- Prefer a compact format with a fixed semantic structure within each phase, such as `Remaining 05:32`.
- Reserve enough visual room for the longest expected value without prescribing unsupported font, width, or CSS behavior.
- Keep the absolute deadline visible nearby for consequential actions.
- Do not move the primary action, reorder facts, or resize the whole card on each update.
- On narrow screens, stack the timer above the action instead of compressing both into a crowded row.

## Define The Time State Model

Use only states that change interpretation or action:

```text
scheduled
-> active
-> warning
-> critical
-> boundary_reached
-> completed | expired | closed | extended

exception states:
stale
unknown
paused
syncing
```

State semantics:

- `scheduled`: the window has not opened; show opening time and unavailable action state.
- `active`: action is available; keep the timer neutral.
- `warning`: the business-defined warning threshold has been crossed.
- `critical`: use only when the remaining time and consequence justify urgent treatment.
- `boundary_reached`: the visible timer reached zero but the authoritative business outcome may still require confirmation.
- `completed`: the action or task finished before the boundary.
- `expired` or `closed`: the authoritative system confirms that the action is no longer available.
- `extended`: show the new deadline and make the extension explicit; do not silently jump the timer backward.
- `stale`: the displayed time may no longer be trustworthy because updates stopped beyond the freshness tolerance.
- `unknown`: no authoritative deadline is available.
- `paused`: use only for a business timer that is genuinely pausable; never freeze a wall-clock deadline because a client went to the background.
- `syncing`: use briefly while confirming the current deadline or terminal state.

Do not show negative countdown values. At zero, transition to `boundary_reached`, `expired`, `closed`, `completed`, or another explicit state.

## Link Time To Actions

- Define whether the primary action remains enabled in `active`, `warning`, and `critical` states.
- At the visible zero boundary, disable or replace the action only when the authoritative business rule requires it.
- Treat the displayed timer as guidance, not as the security or authorization boundary. The implementation owner must validate the action against the authoritative time source.
- If an action is submitted near zero, show `accepted` only after receipt. Do not claim success until the business result is known.
- If the deadline passes during processing, state whether accepted work continues, is cancelled, or requires review.
- If a grace period exists, design it as a named phase with its own copy and actions. Do not imply an undocumented grace period.
- If the deadline changes, show the updated absolute time and a concise reason when available.

## Use Color And Emphasis Carefully

- Keep active countdowns neutral by default.
- Use at most one warning threshold and one critical threshold unless the business process genuinely needs more.
- Use orange for an approaching consequential boundary and red only for severe imminent consequence or confirmed expiry/error semantics.
- Pair color with text such as `Ending soon`, `Expired`, or `Data may be stale`.
- Do not recolor the timer every few seconds, flash, pulse, or animate solely to manufacture urgency.
- Do not make a soft ETA red merely because its estimate has changed.
- Keep the absolute deadline and action consequence more prominent than decorative timer styling.

## Relationship To Streaming And Partial Updates

- A countdown is normally `component_partial_update`, `threshold_state`, or static time display, not `text_streaming`.
- Use `text_streaming` only for progressively revealed text content.
- A countdown may coexist with AI text streaming, but keep it in a separate stable region and require ordered updates.
- Do not let frequent timer updates compete with meaningful task-state, chart, or interaction updates.
- Close active streaming before enabling callback-driven final actions when platform behavior requires separate phases.
- Do not treat the platform's streaming timeout as the business countdown or deadline.

## JSON 2.0 And CardKit-Aware Constraints

State these as feasibility constraints for the implementation owner:

- The currently collected JSON 2.0 component documents do not establish a native `countdown` or `timer` body component. Treat those names as conceptual only, never as component tags.
- A verified `markdown` or `div`-based time region can display time text; a live countdown requires repeated content or component updates by the implementation owner.
- The documented rich-text `local_datetime` syntax can localize an absolute Unix-millisecond timestamp. It does not by itself establish a self-running countdown.
- `picker_datetime` is an input control for choosing a date and time, not a countdown display.
- Shared card updates, client compatibility, update ordering, content limits, interaction conflicts, and real render behavior remain implementation constraints.
- If individualized per-viewer timing is required, verify that the chosen delivery and update model actually supports it. Do not assume a shared card entity maintains independent countdown state for each viewer.

Do not output API payloads, timer loops, scheduler code, sequence values, request frequencies, or production JSON.

## Fallback Strategy

Every dynamic-time design must define a fallback:

1. Preserve the authoritative absolute time.
2. Show the last successful update time when the dynamic value may be stale.
3. Replace an untrustworthy countdown with `Checking status` or `Time may be outdated`.
4. Keep the business action server-validated even when the display lags.
5. Provide refresh, reopen, detail, or retry guidance only when a verified path exists.

## Conditional Output

When dynamic time is relevant, append this block to the structured decision:

```markdown
dynamic_time_design:
- use_dynamic_time:
- time_role:
- authority_source:
- timezone_policy:
- display_mode:
- absolute_time_display:
- relative_or_countdown_display:
- visible_precision:
- visible_refresh_policy:
- stable_region:
- phase_thresholds:
- color_and_emphasis:
- action_linkage:
- zero_boundary_behavior:
- extension_or_pause_behavior:
- freshness_tolerance:
- stale_or_offline_state:
- fallback:
- implementation_constraints:
```

## Preview And Acceptance States

Request real-client evidence for the states that materially affect the design:

- normal active state
- warning threshold
- critical or final minute when used
- zero boundary
- confirmed expired/closed/completed state
- deadline extension
- stale or delayed-update state
- mobile layout and long localized time text
- relevant timezone or locale variants

Do not approve a time-sensitive card from a single static screenshot when zero-state, action locking, or layout stability is part of the requirement.

## Red Lines

- Do not invent a native `countdown` or `timer` component.
- Do not classify every countdown as text streaming.
- Do not show seconds without second-level reader value and credible update accuracy.
- Do not rely on color alone to communicate urgency or expiry.
- Do not show negative time.
- Do not silently reset or extend a timer.
- Do not treat a soft ETA as a hard deadline.
- Do not let the visible zero state become the sole authorization check.
- Do not leave an expired card with an apparently enabled action.
- Do not omit absolute time, timezone, stale behavior, or zero-state semantics when they materially affect the decision.
