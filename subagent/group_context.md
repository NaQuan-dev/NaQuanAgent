# Group Context

This file stores stable, long-term context for `<GROUP_NAME>`. It must not contain raw chat logs, secrets, customer private data, or one-off task details.

## Current Scope

- Group/project/domain: `<GROUP_NAME>`
- Main purpose: `<GROUP_PURPOSE>`
- Primary users: `<USER_GROUP_DESCRIPTION>`

## Stable Preferences

- `<PREFERENCE_1>`

## Workflows

- `<WORKFLOW_1>`

## Group Membership And Message Index

- `members.md`: group member cache.
- `group_memberships.csv`: relationship details, one row per user-group membership interval.
- `group_message_index.csv`: group message search index. Store only fields needed for retrieval and summaries, not unrelated small talk or full attachments.
- User-group views can be generated from membership details. If views conflict, use the most recent trusted connector verification.
- For private queries over group messages, confirm that the requester is currently in the group, then filter by message index and visibility. If permission is unclear, refuse by default.

## Open Questions

- `<OPEN_QUESTION_1>`

## Maintenance Notes

- Deduplicate before adding new items.
- Remove or rewrite stale one-off conclusions.
- Move company-wide facts, formal SOPs, and cross-group rules into review candidates.
