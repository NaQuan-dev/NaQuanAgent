# Daily Review Core

This is the reusable core rule for cross-department daily reviews. A department or group enables, disables, or scopes the behavior through `agent_profile.json`. Existing department-specific review workflows must not be copied to other departments by default.

## Enable Conditions

- The current group or department profile has `daily_review.enabled = true`.
- The automation has a clear time window, read scope, and writeback permission.
- The read scope is limited to the current authorized group, department, or employee context.
- Cross-group reading is disabled unless explicitly allowed by policy and task necessity.

## Review Dimensions

- Work completed in the previous period.
- Follow-ups and unresolved tasks.
- Agent answer quality and improvement points.
- Stable collaboration preferences.
- Process, SOP, or knowledge-base candidates.
- Risks, permission gaps, and items needing confirmation.

## Write Boundaries

- Stable, low-risk conclusions that belong only to the current group may be written to `group_context.md` if the profile allows it.
- Open tasks, owner-confirmation items, skill suggestions, and process gaps may be written to `tasks/TODO.md`.
- Company-level facts, official knowledge-base text, rule files, and cross-department SOPs should become review candidates by default.
- Customer privacy, quotes, contracts, controlled materials, raw chats, and transcripts must not be written to long-term context.

## Knowledge Destinations

- Human-readable knowledge bases are for official SOPs, FAQs, templates, and documentation.
- Agent knowledge bases are for task manuals, retrieval maps, execution paths, and draft candidates.
- Automations prepare drafts by default; they do not directly publish official material.

## Send Policy

- Group summary sending is controlled by `agent_profile.json` at `daily_review.send_to_group`.
- Pilots should normally start without sending group summaries; collect internal memory and weekly review candidates first.
- Existing department-specific reviews keep their own send time, content style, and write boundaries.
