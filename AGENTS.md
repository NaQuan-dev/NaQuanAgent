# AGENTS.md

This repository is a reusable Agent framework, not a live organization workspace. The root rules should only contain constraints that must always be present when maintaining the framework. Real organization data, people data, customer data, conversations, secrets, credentials, and operational records must stay in local private directories.

## Output And Collaboration

- Use Simplified Chinese with the user by default, unless the user explicitly asks for another language.
- Lead with the conclusion, the change result, and the verification result before adding process details.
- Keep code, commands, paths, config keys, and error messages in their original form.
- Do not guess real business facts, user identities, customer information, permissions, or live system state.
- Before known high-risk tasks, read the relevant `COMMON_ERRORS.md` entries and apply the preflight strategy. Do not wait until a recorded mistake happens again before using the known correct path.

## Repository Boundary

Only commit:

- Framework documentation.
- Root Agent rule templates and sub-agent templates.
- On-demand rule templates.
- Redacted configuration examples.
- Read-only or dry-run script skeletons that do not touch real external systems.

Do not commit:

- Real organization, employee, customer, quote, finance, HR, drawing, or business data.
- External messaging sessions, user identifiers, group identifiers, chat records, or attachments.
- Logs, caches, temporary files, downloads, model output archives, or local runtime state.
- Tokens, keys, account passwords, app secrets, cookies, private config, or `.env` files.
- Documents or paths containing real organization names, employee names, customer names, or internal project names.

## Template Boundary

- `templates/` stores redacted skeletons that are safe for GitHub; it is not the source of truth for a live Agent or sub-agent.
- Live rules should live in the adopter's private local workspace.
- Do not sync live `AGENTS.md`, `SUB_AGENT.md`, or private rules into `templates/` unless the user explicitly asks to publish redacted templates.
- When publishing to GitHub, first redact live rules into placeholder templates, then run a sensitive-data scan.

## File Search

- `.gitignore` may hide real runtime directories; not finding private files in default search does not mean they do not exist.
- When looking for live rules, employee records, group sub-agents, or private workspace content, do not rely only on default `rg --files` or default full-text search.
- First list the intended private directory, then search that explicit directory with ignored files included.
- If a default search hits `templates/`, treat it as a template hit only. Do not use template content as live runtime context unless the task is template maintenance or GitHub publishing.

## Edit Rules

- Read existing content before editing a file.
- Do not overwrite user changes unless explicitly requested.
- Do not delete, empty, or bulk-move local private directories.
- New templates must use placeholders such as `<WORKSPACE_ROOT>`, `<ORG_NAME>`, `<USER_ID>`, and `<CONNECTOR_NAME>`.
- Templates must not include real paths, real IDs, real names, real business system URLs, or real API parameters.

## Verification And Release

- Run static checks when available.
- For Markdown, JSON, TOML, and PowerShell templates, run at least basic format and sensitive-keyword checks.
- Before commit or push, confirm `git status` and `git diff --cached --name-status` contain no unexpected real data files.
- The staged tree must not contain real tokens, secrets, user IDs, session IDs, organization names, employee names, customer names, or internal business keywords.
- Removing a sensitive file from the current tree does not remove it from Git history. If old history contains sensitive data, evaluate history rewriting separately.
- If a risk cannot be verified, state the unverified scope and reason clearly.
