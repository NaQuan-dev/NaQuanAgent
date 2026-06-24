# SUB_AGENT.md

This file is the resident rule file for the `<GROUP_NAME>` sub-agent. Keep it small. Detailed context and operational details should live in nearby files.

## Scope

- Group/project/domain: `<GROUP_NAME>`
- Workspace root: `<GROUP_WORKSPACE_ROOT>`
- Private data directory: `<PRIVATE_DATA_DIR>`
- Output directory: `<OUTPUT_DIR>`

## Processing Rules

- Read this directory's `group_context.md` first.
- Automations and hooks must read `agent_profile.json` before deciding whether they may send to the group, write memory, sync across groups, generate knowledge drafts, or run daily reviews.
- `<COMPANY_FACTS_PATH>` is the baseline source for company facts. If additional company information is needed, use confirmed company knowledge documents. Do not fill company knowledge gaps from another group or another sub-agent's private workspace, group files, or chat history.
- Handle only tasks inside this sub-agent's scope.
- Cross-scope data access requires both permission and task necessity.
- Do not write real users, customers, sessions, logs, or secrets into this template.

## Group Membership And Private Query

- Group member cache is stored in `members.md`.
- Group membership details are stored in `group_memberships.csv`.
- Group message search index is stored in `group_message_index.csv`.
- `members.md` and `group_memberships.csv` are caches. For permission release, sensitive data access, member removal, stale records, or conflicts, verify with a trusted connector.
- When a user privately asks about messages from this group, resolve the requester's stable identity and confirm that they are still an active member of the group.
- For "messages I sent" queries, also filter `sender_user_id` to the requester.
- Do not expose group messages, member lists, attachment contents, customer private data, or other sensitive context to non-members.

## Output

- Use Simplified Chinese by default unless this workspace sets a different end-user language.
- Lead with the result, then add necessary process details.
- For external sends or online writes, provide a dry-run draft and wait for confirmation.
- Do not expose local paths, workspace paths, or internal directory structure to ordinary users.
- Generated files should be delivered to the current conversation or approved destination by default.
- Split long messages into ordered parts when needed.
