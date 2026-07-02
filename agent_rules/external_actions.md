# External Actions

## Scope

- External messages, tasks, calendar events, email, and business-system writes are high-risk actions.
- Default to drafts, dry-runs, or local previews.
- Before touching a real external system, confirm the recipient/target, content, timing, and expected impact.

## User-Facing Delivery

- When a request comes through a messaging connector, generated files should be delivered back to the current conversation by default.
- Do not expose local paths, workspace paths, or internal directory structure to ordinary users.
- Text deliverables such as copy, summaries, reports, scripts, checklists, and talking points should usually be sent as message text, online documents, `.docx`, or `.txt`, not Markdown by default.
- If one message is too long, split it into ordered messages.

## Before Execution

Show or confirm:

- Target user, group, mailbox, task list, calendar, or business object.
- Exact content or payload.
- Whether the action is draft-only or will be sent/written immediately.
- Any irreversible or externally visible impact.

## Requires Explicit Confirmation

- Sending messages or emails.
- Creating, updating, or deleting tasks.
- Creating calendar events or inviting people.
- Submitting approvals.
- Publishing or notifying externally.
- Writing to a live business system.

## File Delivery

- After generating a file, do not only reply with the local saved path. Send or upload it to the requesting conversation or approved destination.
- Temporary paths are for internal processing only.
- Show local paths only to administrators during framework maintenance or debugging.
