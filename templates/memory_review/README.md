# Memory Review Area

This directory stores weekly memory-compression review materials. Real employees, groups, customers, sessions, logs, and business data must stay in a private workspace and must not be committed to the framework repository.

## Files

- `company_update_pending.md`: candidates for the company fact baseline. Administrator review is required before merging.
- `sub_agent_updates_pending.md`: candidate rule updates for group `SUB_AGENT.md` files. Review is required before merging.
- `employee_long_term_updates_summary.md`: weekly summary of employee `long_term_context.md` updates.
- `group_context_updates_summary.md`: weekly summary of group `group_context.md` updates.
- `common_errors_update_pending.md`: redacted generic engineering/runtime lessons to merge into root `COMMON_ERRORS.md` after review.
- `knowledge_intake_status.csv`: status table for knowledge candidates. It stores metadata only, not raw chats, customer privacy, employee privacy, quotes, contracts, or controlled materials.
- `inventory.json`: index of employee and group files included in the weekly run.
- `weekly_memory_run_log.md`: weekly job log.

## Safety Rules

- Weekly compression does not directly edit the company fact baseline, `SUB_AGENT.md`, `COMMON_ERRORS.md`, or official knowledge-base documents by default.
- Employee preferences go into the employee's own `long_term_context.md`.
- Group collaboration background goes into the current group's own `group_context.md`.
- Group behavior rules become `SUB_AGENT.md` candidates; they must not expand permissions.
- Compress long-term memory before archiving chat history.
- Send the weekly review checklist only to the administrator, not to department or management groups.
- Human-readable knowledge is primarily for people; Agent knowledge is primarily for agents.
- Knowledge candidates must enter `knowledge_intake_status.csv` or a draft file first. Formal publication requires human review.
