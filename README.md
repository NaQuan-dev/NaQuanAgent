# Reusable Agent Framework

This repository provides a reusable local Agent workspace framework. It stores only framework documentation, redacted templates, script skeletons, and safe examples. Real organization data, employee records, external messaging sessions, logs, runtime state, and secrets must stay in the adopter's private local workspace and be ignored by Git.

## Use Cases

- Create a local Agent workspace for a team.
- Keep root `AGENTS.md` small and route detailed instructions to on-demand rule files.
- Create sub-agent workspaces for projects, groups, departments, or business domains.
- Add skeletons for messaging platforms, task systems, business systems, and governance checks without committing real connectors or credentials.
- Maintain common-error preflight rules so Agents use known safe paths before repeating known failures.

## Repository Contents

```text
AGENTS.md                  # Maintenance rules for this framework repository
COMMON_ERRORS.md           # Generic common-error playbook
SUBAGENTS.md               # Sub-agent template index
docs/                      # Architecture and publishing safety docs
templates/AGENTS.md        # Root rules template for a real workspace
templates/agent_rules/     # On-demand rule templates
templates/memory_review/   # Weekly memory review and common-error candidate templates
templates/subagent/        # Generic sub-agent template
templates/subagents/       # Scenario-specific sub-agent templates
templates/data/            # Redacted example data structures
templates/scripts/         # Dry-run script skeletons
scripts/README.md          # Note explaining why real local scripts are not versioned
```

## Not Included

- Real company or organization data.
- Real users, employees, customers, vendors, or contacts.
- External platform conversations, chat records, attachments, groups, or user IDs.
- Logs, caches, downloads, temporary files, and runtime state.
- Tokens, keys, account passwords, app secrets, cookies, and private config.

## Getting Started

1. Copy `templates/AGENTS.md` into your real private workspace root.
2. Copy `templates/agent_rules/` into your private rules directory.
3. Copy `templates/subagent/` for each project, group, department, or business domain.
4. Copy `templates/memory_review/` if you want weekly memory compression and review candidates.
5. Copy `templates/scripts/` into your private workspace before implementing real connectors.
6. Add all real data directories, runtime directories, logs, and secrets to local `.gitignore`.
7. Use `docs/publish_safety.md` before committing or pushing.

## Safety Principles

- GitHub stores reusable framework assets only, never live runtime data.
- Every example must use `<PLACEHOLDER>` values.
- Any script that could touch an external system must be dry-run by default.
- Official knowledge, root facts, sub-agent rules, and `COMMON_ERRORS.md` should be updated through review candidates unless an administrator explicitly approves a direct edit.
- Removing sensitive data from the latest commit does not clean old Git history.
