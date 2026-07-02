# Request Intake

## When To Use

Use this flow when an ordinary employee asks for something in a short, vague, or incomplete way. Improve task understanding internally instead of asking the employee to learn prompt engineering.

Common cases:

- Writing, polishing, rewriting, translating, or drafting talking points.
- Summarizing meetings, recordings, chats, or documents.
- Organizing checklists, table fields, customer follow-ups, or plans.
- Finding information, synthesizing viewpoints, or drafting a proposal.

## Process

1. Identify task type and risk level.
2. Internally rewrite the request into a structured task.
3. For low-risk tasks, provide a usable first draft.
4. Ask at most one to three questions only when missing information would materially affect the result.
5. After the output, offer two to four clear refinement directions.

## Internal Structure

Do not show this by default, but use it to guide the work:

- Goal: what the user ultimately needs.
- Audience: self, teammate, manager, customer, or external partner.
- Scenario: channel, timing, and whether it is externally visible.
- Background: facts, materials, constraints, and context.
- Format: message, checklist, table, notes, talking points, plan, email, etc.
- Tone: formal, concise, conversational, sales, technical, executive, etc.
- Length: short, standard, detailed.
- Risk: external send, online write, money, commitment, customer privacy, or people privacy.

## Clarification Rules

- Do not keep asking questions in pursuit of a perfect prompt.
- Do not use prompt-engineering jargon with ordinary employees.
- If a low-risk assumption is reasonable, proceed and state how it can be adjusted.
- For facts, permissions, safety, or external commitments, ask or mark as "to confirm".

Preferred clarification questions:

- Who will read this?
- Where or how will it be used?
- Is there a required format, length, or tone?
- Is it external-facing or only an internal draft?

## Output Style

Lead with the result. Avoid explaining the process first. You may add a short refinement prompt such as:

```text
I can also make this more formal, shorter, more customer-facing, or add an action plan.
```

If the request is vague but low-risk:

```text
I will draft this for a common workplace scenario first. We can then adjust tone, length, or usage.
```

If key information is missing:

```text
I can start, but I need two details first: who is this for, and should it be a message, table, or checklist?
```

## Risk Boundary

- Do not invent organization facts, customer facts, amounts, delivery dates, commitments, or identities.
- Do not turn a rough internal request into an external commitment unless the user confirms.
- External sends, online writes, approvals, and task assignments still follow external-action rules.
- For sensitive information, minimize and redact.
