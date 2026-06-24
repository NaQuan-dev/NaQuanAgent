# Common Error Preflight

This rule turns `COMMON_ERRORS.md` from a postmortem record into a preflight checklist. For known high-risk tasks, read the relevant entry and apply the strategy before using tools or editing files.

## When To Read

Read the relevant `COMMON_ERRORS.md` entry before:

- Editing JSON, TOML, YAML, PowerShell, script entrypoints, connector config, or automation config.
- Passing non-ASCII text, multiline text, long copy, JSON, Base64, URLs, or long command arguments.
- Handling model capacity, rate limits, context windows, long attachments, quoted chains, group history, or transcripts.
- Searching live runtime directories, employee records, group sub-agents, private knowledge bases, or ignored files.
- Preparing Git commits, template syncs, public repository updates, or sensitive scans.
- Handling connectors, hooks, session recovery, archived threads, route snapshots, message archiving, or events that never reached the model layer.

## Preflight Steps

1. Classify the risk: encoding, command arguments, context size, search scope, Git publishing, model capacity, or pre-model connector failure.
2. Read only the relevant `COMMON_ERRORS.md` entry. Do not load the entire playbook unnecessarily.
3. Apply the preflight strategy before the first risky tool call or file edit.
4. After execution, run the entry's verification step.
5. If a new error appears, decide whether it is a variant of an existing entry. If not, prepare a redacted candidate for administrator review.

## Update Workflow

Updating `COMMON_ERRORS.md` has three stages: candidate, review, merge.

1. During daily work or weekly memory review, write reusable error lessons to `<MEMORY_REVIEW_DIR>/common_errors_update_pending.md`.
2. Candidates must be redacted and include only scenario, typical symptoms, likely cause, preflight strategy, and verification.
3. Check for duplicates first. If an existing entry already covers the issue, propose a supplement or rewrite instead of a duplicate entry.
4. Merge into root `COMMON_ERRORS.md` only after administrator review.
5. After merging, run governance checks to confirm root rules, rule index, registry, and sensitive scans still pass.

## Not Allowed

- Do not use `COMMON_ERRORS.md` as chat history, business facts, or runtime logs.
- Do not write real organization names, employees, customers, session IDs, user IDs, group IDs, tokens, secrets, external system URLs, or private local path details.
- Do not bypass permission checks, redaction, delivery confirmation, or review because a common-error entry exists.
- Do not treat "fail first, retry later" as the default when a known preflight strategy exists.
