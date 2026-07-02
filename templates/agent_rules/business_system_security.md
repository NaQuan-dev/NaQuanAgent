# Business-System Security And Account Mapping

This rule applies to CRM, ERP, ticketing, work-order, finance, HR, and any other business system that stores operational or customer data.

## Core Boundaries

- Business-system data is controlled data.
- A business-system action must pass all three gates: allowed conversation/source, explicit user intent, and backend permission validation.
- Identity alone is not enough. An authorized person using the wrong conversation or source still does not authorize the action.
- Local department labels, names, or cached roles do not replace backend account mapping.
- Backend systems must enforce record scope, owner scope, administrator visibility, and write permissions.

## Allowed Entry Points

Define allowed locations in the private runtime workspace, for example:

- `<SALES_GROUP_OR_APPROVED_WORK_GROUP>`.
- Private chats where the backend maps the sender's platform identity to an active business-system account.
- Administrator maintenance contexts approved for diagnostics.

Do not perform business-system actions in other groups, even if the sender is an administrator, unless the local policy explicitly permits that source.

## Audio And Minutes Boundary

- Audio, video, transcripts, meeting notes, and minutes never imply business-system matching or write intent.
- Treat media messages as transcription, summary, or archive tasks unless the same conversation includes a separate explicit text command for the business system.
- Even in an allowed source, a separate explicit command is required before matching, querying, creating, updating, exporting, or analyzing business-system records.

## User And Data Scope

- Use the current platform stable user ID as the external identity passed to the backend.
- Sales or ordinary users may see only records allowed by the backend owner/scope model.
- Administrators may have global visibility only inside allowed entry points and with audit.
- High-risk writes, deletes, permission changes, ownership transfers, bulk exports, and irreversible submissions require explicit confirmation and audit.

## Data Retention

- Do not store customer or business-system details in ordinary chat memory, public templates, external memory tools, or ordinary Agent knowledge pages.
- Store business-system data only in the backend or approved controlled-material locations.
- Summaries may keep non-sensitive task state, but must not include raw customer private data, prices, contracts, credentials, or backend identifiers unless policy explicitly allows it.

## Hook Requirements

- Inbound hooks should skip business-system intake before any data access if the source conversation is not allowed.
- Hooks must not send placeholder replies like "matching", "processing", or `task_id` before completion.
- On failure, record status and safe error reason; do not expose backend credentials, raw IDs, stack traces, or local paths to ordinary users.
