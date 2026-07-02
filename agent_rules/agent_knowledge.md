# Agent Knowledge Base Read Rules

This rule keeps the Agent stable when reading the Agent-facing knowledge base. The Agent knowledge base is for retrieval maps, cross-links, task manuals, execution paths, permission boundaries, and knowledge candidates. The human knowledge base is for official documents that employees read.

## Entry Points

- Agent knowledge base name: `<AGENT_KB_NAME>`.
- Local or connected vault: `<AGENT_KB_PATH>`.
- Optional CLI: `<AGENT_KB_CLI>`.
- First-read pages: `<AGENT_KB_WELCOME>`, `<AGENT_RETRIEVAL_GUIDE>`.
- Human-KB current-version map: `<HUMAN_KB_CURRENT_MAP>`.
- Chat or experience intake overview: `<KNOWLEDGE_CANDIDATE_OVERVIEW>`.
- Graph diagnostics candidate page: `<GRAPH_DIAGNOSTIC_CANDIDATES>`.
- Agent dashboard or operations page: `<AGENT_DASHBOARD_PAGE>`.

## When To Read

Read this rule, then the Agent knowledge base, for:

- Any request to "check company files", "use company materials", "answer from the knowledge base", "find the manual", or "reference the docs".
- Company introductions, product materials, sales materials, marketing materials, shared materials, and controlled-material boundaries.
- SOPs, FAQs, templates, employee training, policy explanations, official directories, and publishable material.
- Product selection, customer pain points, sales reception, delivery/support, content workflows, quote/contract/certificate boundaries.
- Agent execution tasks such as document checks, cross-team sync, content intake, reporting, and meeting task extraction.
- Deciding whether chat experience or employee feedback should become human-KB content, Agent knowledge, or company facts.

## Recommended Read Order

Company-material tasks use this default read chain:

1. Read `<COMPANY_FACTS_FILE>` for stable facts, business boundaries, and external wording guardrails.
2. Read Agent knowledge topic maps and task manuals for executable paths.
3. If the answer references official employee-facing text, verify with the human-KB current-version map or current official human-KB text.
4. If the task depends on the current group, read the current routed `group_context.md` and only the necessary task fragments.
5. Do not use other groups' private chat history, files, or archives to supplement company facts.

## Search Method

Prefer the adopted organization's Agent knowledge CLI or API when available:

```powershell
& '<AGENT_KB_CLI>' search query='<KEYWORD>' format=json
```

Useful search concepts:

- Company: company profile, business boundary, capabilities, qualification, delivery process.
- Product: product overview, product family, low-risk wording, technical boundary, compatibility.
- Sales: sales process, personas, pain points, business system, quote, contract.
- Content: brand voice, content workflow, expression boundaries, copy library, topic library.
- Agent tasks: report generation, meeting task extraction, knowledge intake, document check.
- Governance: sensitivity levels, controlled materials, shared-material use, human-KB current-version map.
- Graph: relationship diagnostics, isolated nodes, rule conflicts, knowledge health.

If the CLI is unavailable, read the vault Markdown directly. Direct reads must start from the retrieval guide; do not infer from filenames alone.

## Use Boundaries

- Pages marked as internal/shareable and task-necessary can inform internal answers.
- Controlled indexes can be used only to decide boundaries, authorization, and next confirmation steps. Do not expose controlled source content.
- Prefer active and reviewed pages. Draft, candidate, review, or needs-review pages are not confirmed facts.
- Task manuals guide the Agent's work; do not paste internal manuals verbatim to ordinary employees.

## External Reply Boundary

- Do not mention local vault paths, internal retrieval process, `.obsidian`, private directories, or debug details to ordinary users.
- Reply with useful conclusions, wording, lists, drafts, or next actions.
- A generated artifact is complete only when delivered to the requesting conversation or an approved destination. Existence in the knowledge base is not delivery.
- Prices, contracts, customer information, finance, HR, drawings, certificate originals, system tokens, session IDs, and employee private information must not be sent directly from the Agent knowledge base.

## Knowledge Intake

- Stable company-level facts become candidates first; confirmed owners promote them to `<COMPANY_FACTS_FILE>`.
- Employee-readable SOPs, FAQs, templates, and official materials should become human-KB drafts or official documents, then be indexed in the Agent knowledge base.
- Agent execution paths, cross-team workflows, permission decisions, retrieval maps, and candidate notes belong in the Agent knowledge base.
- If the same content is useful for both people and agents, create the human-readable document first, then add an Agent index or task note.
- Graph diagnostics are candidates only. Confirm against source files before writing formal knowledge.
- Raw chats, transcripts, customer privacy, employee privacy, quotes, contracts, paths, and debug logs do not belong in ordinary knowledge pages.

## Conflict Handling

- If `<COMPANY_FACTS_FILE>` conflicts with Agent knowledge, use `<COMPANY_FACTS_FILE>` as the baseline and mark the Agent page for review.
- If official human-KB text conflicts with an imported Agent page, verify through the human-KB current-version map.
- If group context conflicts with company materials, do not turn group content into company fact. Mark it for confirmation.
