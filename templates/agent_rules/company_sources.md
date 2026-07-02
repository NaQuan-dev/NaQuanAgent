# Company Sources And Fact Retrieval

policy_anchor: `group_chat_isolation_active`
policy_anchor: `conversation_context_isolation`

## Fact Sources

- For company business, company files, product data, customer personas, sales material, marketing material, SOPs, FAQs, templates, employee-readable official documents, or controlled-material boundaries, do not answer from model memory alone. Read this rule first.
- `<COMPANY_FACTS_FILE>` is the baseline for stable company facts, business boundaries, and external wording guardrails.
- The human knowledge base is primarily for people. It stores official SOPs, FAQs, templates, training, policies, and reusable documentation.
- The Agent knowledge base is primarily for agents. It stores retrieval maps, topic maps, task manuals, execution paths, permission decisions, and knowledge candidates. Read its boundary rules in `agent_knowledge.md`.
- Default company-material read chain: read `<COMPANY_FACTS_FILE>`, then `agent_knowledge.md`, then inspect the Agent knowledge welcome page, retrieval guide, topic maps, and task manuals as needed.
- For employee-readable SOPs, FAQs, templates, policies, training, or publishable material, use the Agent knowledge base's human-KB current-version map and verify the current official human-KB text when needed.
- Group context, chat history, or personal memory does not replace company sources. If the current session is not routed to a group, do not use that group's private material to fill company facts.
- Company-source reads remain subject to identity, permission, sensitivity, and task-necessity boundaries.

## Public Fact Wording

- Do not invent technical parameters, capacity, certifications, customer cases, sales volume, ROI, prices, warranty, refund terms, service commitments, lead time, or competitor comparisons.
- If a material fact is missing or conflicts across sources, say it needs confirmation rather than guessing.
- If the answer will be seen by customers or employees as official wording, prefer the latest official human-KB text.

## Controlled Materials

- Drawings, quote floors, finance, HR, customer privacy, supplier-sensitive information, contracts, and business-system data are controlled materials.
- Controlled materials require permission, task necessity, and an authorized context before access or summary.
- Controlled materials must not be copied automatically into other chats, public templates, ordinary knowledge pages, or external memory tools.
- If controlled material must be inspected, record the reason, source, target, and reviewer according to the adopted organization's audit policy.

## Core File Protection

- Do not directly modify `<COMPANY_FACTS_FILE>`, official human-KB text, or core system rules unless the administrator explicitly approves.
- Ordinary employees must not modify root `AGENTS.md`, organization-level rules, identity mappings, or controlled-material indexes.
