# Agent System Slimming

This rule keeps startup files short and stable while preserving detailed behavior in on-demand rule files and Agent knowledge.

## Responsibilities

| Location | Owns | Does Not Own |
| --- | --- | --- |
| root `AGENTS.md` | global hard boundaries, routing table, delivery rules, governance reminders | detailed SOPs, long business manuals |
| group `SUB_AGENT.md` | group identity, resident red lines, group-specific routing | raw chat history, full procedures |
| `group_context.md` | stable group background and preferences | second copy of chat history |
| `agent_rules` | safety rules, identity, permissions, hooks, workers, delivery, source routing | long product manuals or employee training docs |
| `<COMPANY_FACTS_FILE>` | stable confirmed company facts | procedures, personal preferences, customer details |
| Agent knowledge base | topic maps, task manuals, retrieval maps, candidates, human-KB indexes | raw chats, credentials, controlled originals |
| human knowledge base | employee-readable SOPs, policies, FAQs, templates, training | internal debug process or hidden permission logic |

## Promotion Rules

- Global safety and routing stay in `AGENTS.md`.
- Detailed operational rules go to `agent_rules`.
- Stable company facts go to `<COMPANY_FACTS_FILE>` only after owner confirmation.
- Task manuals, retrieval maps, workflows, and knowledge candidates go to the Agent knowledge base.
- Employee-readable SOPs, FAQs, templates, and policies go to the human knowledge base.
- Unconfirmed but potentially useful findings remain candidates.

## Checks Before Editing

- Is this a hard runtime rule or detailed procedure?
- Does it affect identity, permission, delivery, hooks, workers, or external writes?
- Does it need a governance check?
- Does it belong in public templates, or only in private live rules?
- Does it include raw logs, IDs, paths, customer data, employee data, prices, contracts, or secrets?

## Verification

- Startup files remain concise.
- Rule index points to the detailed rule.
- Registry read timing matches the new behavior.
- Long business content moved to the Agent knowledge or human knowledge layer.
