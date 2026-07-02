# Retention Policy

This template defines retention principles for a content-operations sub-agent. Replace placeholders only in a private workspace.

## Keep

- Confirmed content strategy.
- Approved reusable copy patterns.
- Published content references.
- Stable review conclusions.
- Asset indexes and authorization notes.

## Archive

- Drafts after final selection.
- Expired campaign materials.
- Old topic experiments.
- Raw processing records after summarization.

## Do Not Store Long-Term

- Raw full chat logs.
- Unauthorized customer or personal information.
- Quotes, contracts, finance, HR, drawings, accounts, secrets, or internal config.
- One-off task details that do not affect future behavior.

## Private Query And Message Index

- Group member cache is stored in `members.md`.
- Group membership details are stored in `group_memberships.csv`.
- Group message search index is stored in `group_message_index.csv`, with only message references, sender, time, type, summary, customer references, visibility scope, and retention date.
- Private query requires stable requester identity and current group membership. If the member has left, the group disables private query, the message is past retention, or permission cannot be confirmed, do not return message content.
