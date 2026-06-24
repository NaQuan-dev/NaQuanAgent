# COMMON_ERRORS

This file is the reusable framework's generic common-error playbook. It records general engineering and safety lessons only. Do not store real organization names, people, customers, sessions, secrets, local private paths, or business-system details here.

## Usage Principles

- Before a related high-risk task, read the relevant entries in this file.
- If a known issue applies, use the preflight strategy first and verify the result.
- New entries should describe only generic symptoms, causes, strategy, and verification.
- Automations and weekly memory jobs may only prepare update candidates. An administrator must review before this file is changed.
- Do not write real paths, real IDs, real tokens, real employee names, or real customer names.

## Entry Template

```text
### YYYY-MM-DD Short Title

Scenario:
-

Typical symptoms/errors:
-

Likely cause:
-

Preflight strategy:
-

Verification:
-

Notes:
-
```

## Generic Issue: UTF-8 BOM Breaks Strict Parsers

Scenario:
- JSON, TOML, YAML, or other strict config files are written with older shells or editors.

Typical symptoms/errors:
- The parser reports an illegal character at the beginning of the file.
- The file looks normal in an editor but the target program cannot read it.

Likely cause:
- The writer added a UTF-8 BOM.
- The target program does not tolerate BOM-prefixed config files.

Preflight strategy:
- Use a writer that explicitly supports UTF-8 without BOM.
- Do not overwrite critical config with uncertain shell encoding.

Verification:
- Run the target program's config validation command immediately after writing.
- Check the first bytes of the file when the parser is strict.

## Generic Issue: Long Or Non-ASCII Command Arguments Are Mangled

Scenario:
- A script receives Chinese text, multiline text, JSON, URLs, or long message bodies through command-line arguments.

Typical symptoms/errors:
- Non-ASCII text becomes mojibake.
- JSON parsing fails.
- Arguments are truncated or quote escaping breaks.

Likely cause:
- Shell, script runtime, and external program use different encoding or escaping rules.

Preflight strategy:
- Prefer UTF-8 temporary files, standard input, or UTF-8 Base64 for long text.
- Use native commands and literal path parameters when handling paths.

Verification:
- Check key non-ASCII fragments before and after writing or sending.
- Do not rely on exit code only.

## Generic Issue: Local Runtime Data Is Accidentally Committed

Scenario:
- A framework repository and a real runtime workspace share a directory tree.

Typical symptoms/errors:
- `git status` shows logs, caches, sessions, downloads, or private data.
- Template docs contain real organization names, people, or business descriptions.

Likely cause:
- `.gitignore` is not default-deny.
- A new directory was added without deciding whether it belongs to the reusable framework.

Preflight strategy:
- Use a default-deny `.gitignore`.
- Only allowlist docs, templates, and script skeletons.
- Scan both paths and file contents before commit.

Verification:
- Check `git diff --cached --name-status`.
- Run sensitive-keyword scans against the staged tree.

## Generic Issue: Model Capacity Is Exhausted

Scenario:
- A user request hits model capacity, concurrency, rate limit, or temporary model availability errors.

Typical symptoms/errors:
- Model capacity reached.
- Capacity unavailable, too many requests, rate limit, or temporary model unavailable.

Likely cause:
- The primary model is saturated.
- The input is too large and increases scheduling pressure.
- The connector retries the same request on the same model without reducing input.

Preflight strategy:
- Keep a private connector config with a primary model and a capacity fallback model.
- For capacity errors, retry the primary model at most once, then switch to the fallback.
- Before fallback, reduce input size by removing unnecessary history, full attachments, and nested quoted content.

Verification:
- Use dry-run or a test connector to simulate capacity errors and confirm fallback behavior.
- Store only error summaries, not real conversation text.

## Generic Issue: Context Window Is Full

Scenario:
- The task involves long messages, quoted threads, forwarded chains, group history, attachments, long documents, or transcripts.

Typical symptoms/errors:
- Context window full.
- Input too long, maximum token limit exceeded, or request body too large.

Likely cause:
- A single message includes a long quote or forwarded chain.
- The connector sends full group history, attachment text, or transcripts in one model request.
- `chat_history.md`, long-term context, or tool output is loaded as a whole file.

Preflight strategy:
- Default to the current message and one direct quote only.
- Search indexes and summaries first, then read only necessary source snippets.
- Summarize long content in batches and keep only task goal, key facts, permission conclusion, and current snippet in the model input.
- If too many results match, narrow by time, keyword, sender, or message count.

Verification:
- Test with nested quotes or long attachments and confirm the connector does not send the full chain.
- Confirm retry requests are shorter, not identical.

## Generic Issue: Default Search Hits Template Directories

Scenario:
- A framework repository contains both safe `templates/` and private runtime directories hidden by `.gitignore`.

Typical symptoms/errors:
- Default search returns `templates/AGENTS.md`, `SUB_AGENT.md`, or rule templates only.
- The Agent treats a skeleton template as the live runtime rule.
- The real runtime directory exists but default `rg --files` or default full-text search does not show it.

Likely cause:
- `.gitignore` hides private runtime directories to prevent accidental commits.
- `templates/` is allowlisted for GitHub and is easier to find.
- Search did not explicitly include ignored private directories.

Preflight strategy:
- Keep `.gitignore` default-deny.
- Optionally hide `templates/` from default local search with `.ignore`.
- For live runtime content, first list the private directory, then search that explicit directory with ignored files included.
- Read `templates/` only for template creation, template maintenance, or GitHub publishing.

Verification:
- Default searches should not be treated as proof that runtime files are missing.
- An ignored-file search against the explicit private directory can find live `SUB_AGENT.md` and rule files.

## Generic Issue: Template Skeleton Is Mistaken For Live Runtime Rules

Scenario:
- A model or automation is looking for active `AGENTS.md`, `SUB_AGENT.md`, `group_context.md`, or `agent_rules/*.md` files.
- The repository also contains redacted skeletons under `templates/`.

Typical symptoms/errors:
- The model follows placeholder rules such as `<WORKSPACE_ROOT>` or `<GROUP_NAME>`.
- A group or employee workflow behaves like the generic template instead of the configured live workspace.
- The model concludes that real runtime rules are missing because default search returned only `templates/`.

Likely cause:
- Default search found allowlisted GitHub templates while private runtime directories were hidden by `.gitignore`.
- The caller did not distinguish template maintenance from runtime operation.
- The template file name matched the live file name.

Preflight strategy:
- Treat every path containing `templates/` as non-runtime unless the task is template maintenance, framework publishing, or scaffold generation.
- For live runtime tasks, first locate the private workspace root, then search that explicit root with ignored files included if needed.
- Keep a local `.ignore` entry for `templates/` so default text search is less likely to return template hits.
- Add a clear TEMPLATE ONLY banner to template `AGENTS.md` and `SUB_AGENT.md` files.

Verification:
- A search for live runtime rules should return files outside `templates/`.
- Governance checks confirm `.ignore` hides `templates/` and root rules say template hits are not runtime context.
- Template files use placeholders only and never contain real organization data.

## Generic Issue: Pre-Model Connector Failure Makes The Model Blind To Events

Scenario:
- A messaging platform, hook, session recovery layer, or local connector processes events before calling the model.
- This can be labeled as `pre-model connector failure` for ASCII-only scans.

Typical symptoms/errors:
- The user sent a message, but the model thread has no new input.
- Connector logs show thread resume failure, session mapped to an archived thread, JSON parse failure, hook failure, or similar errors.
- Changing model rules alone does not fix the issue.

Likely cause:
- The event failed in the connector layer, hook layer, or session index layer before entering model context.
- The model can only follow rules it sees; it cannot handle an event that was blocked before the model call.

Preflight strategy:
- Use separate hooks or read-only checks for inbound messages, connector errors, and session recovery.
- Model rules govern behavior after events enter the model. Pre-model failures need logs, error hooks, repair scripts, and monitoring.
- Back up session indexes before repair, then verify the connector can read the updated mapping.
- Do not assume "the model ignored the rule" until connector logs and route snapshots have been checked.

Verification:
- Simulate or review one pre-model error and confirm monitoring detects it.
- Confirm repaired messages enter the correct personal or group long-term thread.
- Confirm read-only governance checks do not restart services, modify config, or rewrite session indexes.

## Generic Issue: Windows PowerShell 5.1 Misparses UTF-8 Without BOM Source Containing Non-ASCII Text

Scenario:
- A `.ps1` script containing non-ASCII string literals is run in Windows PowerShell 5.1.

Typical symptoms/errors:
- Source text becomes mojibake.
- The parser reports `Unexpected token` near a string that looks normal in the editor.
- The same file appears correct in other tools.

Likely cause:
- Windows PowerShell 5.1 may not reliably detect UTF-8 without BOM source and may parse it with the system ANSI code page.
- Strict JSON/TOML config often needs UTF-8 without BOM, but `.ps1` source compatibility is a separate issue.

Preflight strategy:
- For scripts that must run in Windows PowerShell 5.1, keep source ASCII when practical.
- Restore non-ASCII match text at runtime from UTF-8 bytes or external resource files if needed.
- If direct non-ASCII string literals are required, explicitly test both Windows PowerShell 5.1 and PowerShell 7.

Verification:
- Run the script in Windows PowerShell 5.1.
- Validate JSON/TOML config files separately for BOM and parser compatibility.
