# Governance Review Playbook

Use this when maintaining the agent system, changing runtime behavior, or consolidating rules and knowledge.

## Triggers

Read this playbook before changing:

- root `AGENTS.md`
- sub-agent inheritance
- connector hooks
- workers
- automation
- memory rules
- artifact delivery
- company-source routing
- Agent knowledge or human knowledge boundaries
- common-error rules
- Git publication safety

## Process

1. Inventory the affected live files and templates.
2. Identify whether the change is runtime behavior, business policy, knowledge content, or a reusable template.
3. Update the live system files first when the change affects runtime behavior.
4. If the change should be published, create a sanitized template update separately.
5. Update the rule index and registry when read timing or source-of-truth changes.
6. Add or update governance checks for regressions that should not recur.
7. Run JSON/PowerShell/Markdown checks and sensitive scans.

## Do Not

- Do not publish private live files directly to public repositories.
- Do not let templates override live runtime rules.
- Do not treat Graph diagnostics or memory recall as authoritative facts.
- Do not auto-repair high-risk governance problems without administrator review.

## Verification

- Rule registry parses.
- Root `AGENTS.md` routes to the right rule.
- Relevant rule file contains the new behavior.
- Governance check covers the regression.
- Sensitive scan passes before any public push.
