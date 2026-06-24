# Context Budget

This rule prevents long-term context and resident rule files from growing without limit. The goal is to reduce the chance that the model ignores earlier rules because the context is too long.

## Default Soft Budgets

| File | Soft Limit |
| --- | ---: |
| `SUB_AGENT.md` | 120 lines |
| `group_context.md` | 200 lines |
| `long_term_context.md` | 80 lines |
| `tasks/TODO.md` | 160 lines |
| `agent_profile.json` | 120 lines |

Exceeding a soft limit is not an immediate failure, but the next update should compress, deduplicate, or move details into archive/candidate files first.

## Before Writing

Check:

- Is this stable long-term information, or just one task's process detail?
- Is there an existing similar rule that should be merged instead of duplicated?
- Does the content include real users, customers, quotes, contracts, full chat text, logs, paths, tokens, or secrets?
- Does it belong in the current group/employee context, or should it become a company fact or formal knowledge candidate?
- Should this be a review candidate instead of a direct write?

## Compression Rules

- Keep rules, preferences, workflows, decisions, and open questions that are still useful.
- Remove or rewrite outdated temporary conclusions.
- Convert long lists into short summaries and archive references.
- Move company-level facts, cross-group rules, and formal SOP candidates out of group context and into review candidates.
