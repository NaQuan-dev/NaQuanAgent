# agent_rules index

This directory stores detailed rules loaded on demand. The root `AGENTS.md` remains the live global entry and should stay short. For each task, read only the relevant rule files below.

## Routing Table

| Scenario | Read First |
| --- | --- |
| Vague employee requests, prompt intake, clarification, default assumptions | `request_intake.md` |
| Personal identity, employee registration, permissions, task routing | `identity_access.md` |
| Group context, group members, cross-group data, group-private history | `identity_access.md` + `memory_context.md` |
| Business-system query, intake, update, ownership, admin visibility, allowed conversation locations | `business_system_security.md` |
| Connector sessions, pre-model failures, hooks, outbound guards, artifact delivery | `hook_guardrails.md` |
| Background worker, long tasks, async execution, worker state | `worker_runtime.md` |
| Known-error preflight, repeated failure modes, encoding, arguments, Git, connector pitfalls | `common_error_preflight.md` + `COMMON_ERRORS.md` |
| Company files, product facts, SOP/FAQ/templates, official employee-readable material, controlled-material boundaries | `company_sources.md` + `agent_knowledge.md` |
| Agent knowledge base, retrieval maps, task manuals, human-KB current-version map, knowledge candidates | `agent_knowledge.md` |
| Graph diagnostics, structural relationships, rule conflicts, isolated knowledge nodes | `graph_diagnostics.md` |
| Agent governance, system-file sync, rule review, hook/common-error/knowledge structure | `governance_review.md` |
| Agent system slimming, startup-file boundaries, moving detail into Agent knowledge | `system_slimming.md` |
| Daily review, department memory, knowledge candidates, automation writeback | `daily_review_core.md` |
| Rule source of truth, read timing, write permissions, review requirements | `rule_registry.md` / `rule_registry.example.json` |
| Context budget, long-term memory slimming, file length thresholds | `context_budget.md` |
| External messages, tasks, mail, scheduled sends, online writes | `external_actions.md` |
| Long-term context, memory compression, project memory | `memory_context.md` |
| Audio/video files, transcript/minutes retention, audio business-system boundary | `voice_note_minutes_retention.md` + `business_system_security.md` |
| GitHub publishing, public/private repository safety | `git_publish_safety.md` |
| Filesystem, temporary files, Windows/PowerShell/UTF-8 details | `workspace_io.md` |

## Use Principles

- Load only task-relevant rules. Do not load the entire directory by default.
- When multiple risks apply, prioritize controlled data, business-system writes, external actions, identity/permission checks, and Git publishing.
- If a rule conflicts with a user request, follow the stricter safety rule and ask an administrator if needed.
- This directory is a private runtime rule directory after adoption. Public repositories should contain only sanitized templates.
