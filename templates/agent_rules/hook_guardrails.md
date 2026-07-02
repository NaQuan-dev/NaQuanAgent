# Hook Guardrails

This file defines guardrails that must be enforced by hooks or read-only monitoring in the path from an external connector to Codex. The model can only handle events that reach the model call. If an event is blocked, misrouted, or fails in the connector layer, connector hooks, logs, and repair scripts must handle it.

## Principles

- Start with guardrail rules and read-only checks before changing live connector config.
- Hooks must be minimal-permission, repeatable, and auditable.
- Before writing session indexes or connector state, create a backup and prefer dry-run support.
- Hooks must not show local paths, user IDs, group IDs, session keys, log paths, or stack traces to ordinary users.
- Hooks handle routing, archiving, delivery, safety checks, and status recording. They do not replace business approvals, customer commitments, quote confirmation, or formal knowledge publication.
- Hooks must not send placeholder replies such as "processing", "received", `task_id`, or "please wait" unless the user must take action before work can continue.

## 1. Inbound Routing Hook

Trigger: `message.received` or an equivalent inbound event.

Goals:

- Determine whether the message belongs to a personal chat, registered group, unregistered session, or abnormal route.
- Create or refresh a route snapshot so the model reads the correct user/group context.
- Handle employee registration, personal-session consolidation, group archiving, and session-consistency checks.

Fallbacks:

- If the route snapshot is missing, stale, or inconsistent, resolve it again.
- If reliable routing still fails, treat the request as personal/unregistered and do not read group-private data.
- Do not route a group message based on a window title, old thread title, or administrator debug context.
- If a group route cannot be verified, do not read group-private context.

## 2. Pre-Model Connector Error Hook

Trigger: `error`, or any failure that happens after inbound receipt but before the model call.

Applies to:

- Thread resume failures.
- Sessions mapped to archived or missing Codex threads.
- Session index JSON corrupted by encoding or parse errors.
- Hook session mapped to the wrong local session.
- Route, archive, or registration scripts failing before the model receives the message.
- Connector process interruptions or active mappings reverting after restart.

Guardrails:

- These failures often never enter model context, so they must be logged and detected by monitoring.
- Back up session indexes before repair.
- Write strict config/session files with parser-compatible encoding and verify the connector can read the updated mapping.
- If one user or group is split across multiple local sessions, run a dry-run merge before repair.
- Do not delete old threads as part of automatic repair.

## 3. Outbound Safety Hook

Trigger: `message.sent`, active-send script calls, or model replies that mention generated artifacts or local paths.

Goals:

- Block local paths, internal directories, debug logs, session keys, unredacted IDs, tokens, secrets, and malformed links.
- Distinguish current-session bot sends, human-account sends, group sends, direct-message sends, and file/image delivery.
- Prevent user-requested artifacts from being sent to an administrator account by default.
- Verify links or multiline bodies after send when possible. If the service-side message contains only a title, empty body, or first line, retry with plain text or attachment before claiming completion.

## 4. Artifact Delivery Hook

Trigger: model claims such as "generated", "done", or "saved", or a new file appearing in an output directory.

Goals:

- An artifact is complete only after it is delivered to the original requester or an approved destination.
- Images, files, spreadsheets, documents, and archives must not remain only in local storage.
- If the route or destination is unclear, do not send to an administrator by default. Stop and ask for confirmation.

## 4a. Business-System Intake Gate

Trigger: inbound messages or files that might be interpreted as business-system or CRM work.

Goals:

- Treat audio, video, transcripts, and meeting notes as transcription/summarization input only.
- Require an allowed conversation/source context before any business-system read or write.
- Require a separate explicit text command before matching, querying, creating, or updating business-system records.
- Let the backend business system validate account mapping and permissions. Local department labels or hard-coded names must not replace backend authorization.
- In disallowed conversations, skip the business-system hook before any data access and continue with ordinary summary/minutes behavior when appropriate.

## 5. Memory Write Guard

Trigger: daily reviews, weekly compression, employee long-term memory updates, group context updates, or task-list updates.

Goals:

- Long-term context stores stable preferences, collaboration facts, process agreements, and reusable lessons only.
- One-off tasks, raw chats, customer private data, quotes, contracts, CRM details, employee privacy, and debug logs must not enter long-term context.
- Before writing, read `agent_profile.json` and `context_budget.md`; if the file is over budget, prepare a compression suggestion first.

## 6. Automation Writeback Guard

Trigger: daily reviews, weekly memory review, scheduled monitors, automatic sends, or automatic task creation.

Goals:

- Automations must read the relevant user/group profile before deciding whether they may send, write back, sync across groups, or create knowledge drafts.
- Automations must not copy one department's special workflow into other departments by default.
- Automations must not publish formal knowledge directly; they prepare drafts or candidates unless explicitly approved.
