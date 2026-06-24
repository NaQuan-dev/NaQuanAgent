# Weekly Memory Compression Prompt

Run weekly Agent context compression, archive maintenance, knowledge-draft preparation, and `COMMON_ERRORS.md` update-candidate collection. The goal is to keep the Agent aligned with the work environment while reducing long-context drift.

## Execution Order

1. Read this automation's memory, root `AGENTS.md`, and relevant `agent_rules`. Prioritize `memory_context.md`, `daily_review_core.md`, `common_error_preflight.md`, `hook_guardrails.md`, and `context_budget.md`.
2. For each group sub-agent workspace:
   - Summarize and archive new group content for the period, keeping key facts, decisions, tasks, preferences, output requirements, and unresolved issues.
   - Compress `chat_history.md`, keeping only necessary recent context, indexes, summaries, and traceable archive references.
   - Check whether `group_context.md` needs updates. Write only stable, reusable, evidence-backed information.
   - Check whether `SUB_AGENT.md` needs rule or description updates. Generate candidates by default; do not edit directly.
3. For each employee one-on-one Agent history:
   - Compress employee `chat_history.md`, keeping necessary identity, team, preference, task, and business-context summaries.
   - Before updating `long_term_context.md`, deduplicate, merge similar items, and remove or rewrite outdated one-off conclusions.
4. Prepare knowledge drafts:
   - Company fact update candidates.
   - Human-readable SOP / FAQ / template drafts.
   - Agent knowledge task manuals / retrieval-map drafts.
   - Department `group_context.md` suggested updates.
5. Prepare `COMMON_ERRORS.md` update candidates:
   - Read root `COMMON_ERRORS.md` and `common_error_preflight.md`.
   - From weekly failures, retries, pre-model connector errors, encoding/argument/search/Git/context issues, extract reusable, redacted candidates with preflight strategy and verification.
   - Write only to `common_errors_update_pending.md`; do not directly modify `COMMON_ERRORS.md`.
   - If an existing entry already covers the issue, record a proposed supplement or rewrite instead of duplicating it.
6. Run sensitive-data and path-boundary checks on all actual edits. Do not store real customer data, employee privacy, raw chats, tokens, secrets, session IDs, group IDs, quotes, contracts, drawings, or controlled materials in ordinary memory.
7. Generate a run log and review checklist. Send the checklist only to the administrator. If the admin delivery path is not reliable, output the checklist in the automation result and do not send it elsewhere.

## Constraints

- Do not delete raw chat records unless a safe archive mechanism exists and the task explicitly requires replacing history with compressed memory.
- Do not guess real business facts, identities, customer information, or live system state.
- Do not copy a department-specific workflow into other departments by default.
- Do not directly edit `COMMON_ERRORS.md`; only prepare candidates.
