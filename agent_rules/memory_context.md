# Memory And Context

## Files

Suggested runtime files:

- `long_term_context.md`: stable long-term information.
- `chat_history.md`: recent raw conversation or summarized history.
- `context_review.md`: memory candidates awaiting review.
- `archive/voice_notes/`: source files, transcripts, summaries, and metadata for audio/video requests.

These files are real runtime data and must stay in a private workspace.

## Group Message Index

Group message indexes, membership records, raw chats, and attachments are real runtime data. Keep raw messages and searchable indexes separate:

- `chat_groups.md`: group view with current active members.
- `user_groups.md`: user view with current active groups.
- `group_memberships.csv`: relationship details, the authoritative source for both views.
- `group_message_index.csv` or equivalent index directory.

Each message index row should include:

- `message_ref`
- `chat_ref`
- `sender_user_id`
- `sent_at`
- `message_type`
- `content_summary`
- `customer_refs`
- `acl_chat_refs`
- `private_query_allowed`
- `retention_until`

For private queries over group messages, resolve the requester's `user_id`, determine accessible groups, search the index, then filter again before output.

## Keep During Compression

- User-confirmed decisions.
- Stable preferences.
- Long-running tasks and unresolved follow-ups.
- Reusable process rules.
- Important permission or safety constraints.

## Do Not Keep

- Raw full chat unless explicitly needed and allowed.
- One-off temporary details.
- Sensitive customer or employee data.
- Credentials, tokens, paths, or logs.
- Guesswork or unverified facts.

## Update Rules

- Prefer short summaries over long copied text.
- Preserve source references without exposing private identifiers to ordinary users.
- If a memory candidate may affect future behavior broadly, write it to a review candidate file instead of directly updating resident rules.
- Official company facts, formal knowledge-base content, sub-agent rules, and `COMMON_ERRORS.md` require review candidates unless an administrator explicitly approves a direct edit.
