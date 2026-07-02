# Worker Runtime

This rule defines when work may leave the foreground connector path and run in a background worker.

## When To Use A Worker

Use a worker for:

- Large file processing.
- Long reports.
- Batch generation.
- Cross-system read workflows.
- Scheduled automation.
- Long-running tasks where foreground model sessions may time out.

Do not default to a worker for:

- Short chat replies.
- Simple drafts.
- Lightweight Q&A.
- Clarification.
- High-risk approval or confirmation tasks.

## User Experience

- Do not send "processing", "received", "please wait", or `task_id` placeholder replies before the task is complete.
- Reply through the connector only when the task is complete, failed, or needs required user input.
- Completion means the requested result or artifact has been delivered to the original conversation or approved destination.

## Identity And Context

- The worker inherits the original route, user identity, group sub-agent identity, permissions, and delivery boundary.
- A worker task does not become a new agent identity.
- Group tasks must still read global `AGENTS.md`, the routed group `SUB_AGENT.md`, and routed `group_context.md`.
- Private user tasks must not read unrelated group context.

## State

Track at minimum:

- `task_id`
- source conversation reference
- requester identity
- route or workspace
- status: `queued`, `running`, `done`, `failed`
- current step for recovery
- final delivery status
- safe error reason

Worker failures must be explicit. Do not hide a failed task behind "still processing".
