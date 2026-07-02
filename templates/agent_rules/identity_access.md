# Identity And Access

## Identity Records

Store real identity data only in the private workspace. Suggested fields:

- `user_id`: stable internal identifier.
- `display_name`: human-readable name.
- `department`: organization unit or team.
- `roles`: role labels or permission groups.
- `status`: active, inactive, pending, or blocked.
- `external_accounts`: connector-specific IDs stored privately.

All fields in framework templates must be placeholders or generic examples.

## Group Membership

Group membership is real runtime data and must stay in the private workspace. Maintain three views when possible:

- Group view: each group lists current active members.
- User view: each user lists current active groups.
- Relationship detail: one row per user-group membership interval, used as the authoritative source.

The group view and user view must be regenerable from the same relationship detail file. If they conflict, use the most recent trusted connector verification. Do not grant access based on names, nicknames, or informal descriptions.

## Permission Boundaries

- policy_anchor: `group_chat_isolation_active`
- policy_anchor: `conversation_context_isolation`
- Ordinary users may view and update only their own non-identity preferences.
- Administrators are required for role, status, stable identity key, or other-user record changes.
- Cross-project, cross-group, or cross-department data access requires both user permission and task necessity.
- Group workspaces are runtime context boundaries, not operating-system ACLs. Local filesystem readability is not authorization to read another group.
- If the current connector session is not routed to a group, do not read that group's chat history, files, workspace, archives, tasks, or outputs.
- Background workers must preserve the same route, identity, and permission boundary as the original message.

## Private Query Over Group Messages

When a user asks privately about group messages, perform these checks first:

- Resolve the requester's stable `user_id`; do not rely on name, nickname, or job title alone.
- Read the private user-group view to determine the requester's currently accessible groups.
- Search only groups where the requester is currently an active member and private query is allowed.
- For "messages I sent" queries, also filter `sender_user_id` to the requester.
- Before output, filter again by `user_id`, group scope, and private-query permission.

Do not reveal group messages, full member lists, raw platform identifiers, attachment contents, customer private data, or other sensitive context to users who are not active authorized members. If membership is missing, stale, or conflicting, verify access first. If access cannot be verified, refuse the read.

## Group Sub-Agent Inheritance

- Each registered group should have a `SUB_AGENT.md`, `group_context.md`, and optional `agent_profile.json`.
- A group sub-agent inherits the global `AGENTS.md`, organization facts, and organization-level rules, then applies its own group rules and memory.
- A private user chat shares the global Agent but uses the user's own private context. Do not merge private user context into group context unless explicitly authorized and task-relevant.
