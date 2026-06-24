# AGENTS.md

This file is the resident Agent rule file for `<WORKSPACE_NAME>`. Keep it small. Detailed procedures should be loaded on demand from `<RULES_DIR>`.

## Core Principles

- Use Simplified Chinese with end users by default, unless the user explicitly asks for another language.
- If this workspace is adapted for an English-speaking team, change the default response language here.
- Lead with the result, draft, or change outcome before adding necessary explanation.
- Keep code, commands, paths, config keys, and error messages in their original form.
- Do not guess organization facts, identities, permissions, customer information, or live system state.
- For vague low-risk requests, internally convert the request into a structured task and produce a useful first draft instead of teaching the user how to write prompts.

## Local Environment

- Workspace root: `<WORKSPACE_ROOT>`
- Private data directory: `<PRIVATE_DATA_DIR>`
- Rules directory: `<RULES_DIR>`
- Memory review directory: `<MEMORY_REVIEW_DIR>`
- Log directory: `<LOG_DIR>`
- Temporary directory: `<TEMP_DIR>`
- For non-ASCII text, long text, or JSON parameters, prefer UTF-8 files, standard input, or Base64.

## On-Demand Rules

| Scenario | Read First |
| --- | --- |
| Rule source of truth, read timing, write permission, review requirements | `<RULES_DIR>/rule_registry.md` / `<RULES_DIR>/rule_registry.example.json` |
| Known-error preflight, encoding/arguments/search/Git/connector pitfalls | `<RULES_DIR>/common_error_preflight.md` + `COMMON_ERRORS.md` |
| Vague employee requests, prompt intake, clarification | `<RULES_DIR>/request_intake.md` |
| User identity, permissions, data access | `<RULES_DIR>/identity_access.md` |
| Private query over group messages, group membership checks | `<RULES_DIR>/identity_access.md` and `<RULES_DIR>/memory_context.md` |
| External messages, file delivery, tasks, calendar, mail, online writes | `<RULES_DIR>/external_actions.md` |
| Long-term context, memory compression, history consolidation | `<RULES_DIR>/memory_context.md` |
| Hook guardrails, inbound/outbound/artifact/memory/automation boundaries | `<RULES_DIR>/hook_guardrails.md` |
| Context budget, memory slimming, file length thresholds | `<RULES_DIR>/context_budget.md` |
| Daily review, department memory, knowledge candidates, automation writeback | `<RULES_DIR>/daily_review_core.md` |
| File I/O, logs, temporary directories, encoding | `<RULES_DIR>/workspace_io.md` |
| Audio/video transcription artifacts and generated-minutes cleanup | `<RULES_DIR>/voice_note_minutes_retention.md` |
| Git commit, push, and public repository safety | `<RULES_DIR>/git_publish_safety.md` |

## Safety Baseline

- Read existing content before editing a file.
- Do not overwrite user changes unless explicitly requested.
- Do not delete, empty, or bulk-move important directories without explicit confirmation.
- Do not write secrets, tokens, private config, real sessions, people data, or customer data into docs, code, or replies.
- Any action that touches an external system requires confirmation of target, content, impact, and whether it should execute immediately.
- Generated artifacts are not complete until delivered to the requesting user or the approved destination; a local path alone is not delivery.

## Verification

- Run relevant tests when available.
- If there are no tests, run the smallest meaningful smoke check.
- If verification is not possible, state the unverified scope, reason, and remaining risk.
