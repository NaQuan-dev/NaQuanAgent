# Rule Registry

This is the human-readable companion to `rule_registry.example.json`. For complex tasks, read the registry first, then load only the task-relevant rule files. This prevents every long rule file from being loaded into the model at once.

## Source Map

| Type | Source Of Truth | Purpose |
| --- | --- | --- |
| Company facts | `<COMPANY_FACTS_PATH>` | Stable company facts, business boundaries, and external wording guardrails |
| Human knowledge | `<HUMAN_KB_NAME>` | Official SOPs, FAQs, templates, and documentation for people |
| Agent knowledge | `<AGENT_KB_PATH>` | Retrieval maps, task manuals, execution paths, permission checks, and draft candidates |
| Company rules | `<RULES_DIR>/index.md` | Scenario-based routing for company-level rules |
| Common-error preflight | `COMMON_ERRORS.md` + `<RULES_DIR>/common_error_preflight.md` | Known engineering/runtime pitfalls, preflight strategy, and verification |
| Common-error candidates | `<MEMORY_REVIEW_DIR>/common_errors_update_pending.md` | Redacted candidates to merge into `COMMON_ERRORS.md` after review |
| Group entry | Group `SUB_AGENT.md` | Group identity, boundaries, resident rules, and on-demand routing |
| Group long-term context | Group `group_context.md` | Stable group background, collaboration habits, output preferences, and long-term rules |
| Employee long-term context | Employee `long_term_context.md` | Employee preferences, long-term task background, and open questions |
| Machine profile | Group `agent_profile.json` | Automation and hook policy for sends, writes, cross-group sync, and draft generation |
| Knowledge status | `<MEMORY_REVIEW_DIR>/knowledge_intake_status.csv` | Tracks whether knowledge candidates are reviewed, published, indexed, rejected, or archived |

## Update Principles

- Company facts, official human knowledge, and `SUB_AGENT.md` are not changed directly by automation by default; automations prepare candidates.
- `COMMON_ERRORS.md` is not changed directly by automation by default; automations prepare `common_errors_update_pending.md` candidates.
- `group_context.md` and `long_term_context.md` may be updated by authorized automations, but only after deduplication, compression, and sensitive-data checks.
- Human knowledge bases are primarily for people. Agent knowledge bases are primarily for agents.
- Raw chats, full transcripts, customer privacy, employee privacy, quotes, contracts, paths, and debug logs do not belong in ordinary knowledge documents.
