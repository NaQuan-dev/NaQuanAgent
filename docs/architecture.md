# Architecture

This framework uses a "small resident rules, detailed rules on demand" structure. The goal is to reduce context load while preserving auditable safety boundaries.

## Core Layer

- The root `AGENTS.md` contains only high-frequency, low-change rules that must always be followed.
- Root rules must not contain real organization data, people data, or private system parameters.
- Root rules route task-specific behavior to on-demand rule files.

## Rule Layer

`templates/agent_rules/` provides reusable rule templates:

- `rule_registry.md` / `rule_registry.example.json`: source of truth, read timing, write permissions, and review requirements.
- `common_error_preflight.md`: known-error preflight and update-candidate workflow.
- `hook_guardrails.md`: inbound routing, pre-model errors, outbound safety, artifact delivery, memory writes, and automation writeback.
- `context_budget.md`: line budgets and compression rules for long-term context and resident rules.
- `daily_review_core.md`: reusable daily review rules for departments or groups.
- `request_intake.md`: handling vague employee requests without requiring prompt-writing skill.
- `identity_access.md`: user identity, permissions, group membership, and private-query boundaries.
- `external_actions.md`: external messages, tasks, calendar, mail, and write actions.
- `memory_context.md`: long-term context, compression, history, and message indexes.
- `workspace_io.md`: files, logs, temporary directories, and encoding.
- `voice_note_minutes_retention.md`: audio/video transcript artifact retention and cleanup.
- `git_publish_safety.md`: commit and push safety checks.

## Sub-Agent Layer

`templates/SUBAGENTS.md` indexes reusable sub-agent templates. It is a template directory file, not live runtime routing.

`templates/subagent/` is for projects, groups, departments, or business domains:

- `SUB_AGENT.md`: minimal resident rules for the sub-agent.
- `agent_profile.example.json`: machine-readable policy for automations and hooks.
- `group_context.md`: long-term background, preferences, workflow, and responsibilities.
- `workspace/`: local processing area; real content must not be committed to this framework repository.

`templates/subagents/new_media/` is a more complete scenario template for content strategy, topic planning, scripts, asset libraries, and pre-publish review. It contains only placeholders and no real organization, product, customer, or account data.

## Memory Review Layer

`templates/memory_review/` is for weekly memory compression, knowledge draft review, and `COMMON_ERRORS.md` update candidates:

- Official company facts, sub-agent rules, official knowledge-base documents, and `COMMON_ERRORS.md` are not changed directly by default.
- Automations prepare candidates and review lists; an administrator reviews and merges them.
- Human-readable knowledge bases are for SOPs, FAQs, templates, and official documents.
- Agent knowledge bases are for task manuals, retrieval maps, execution paths, and draft candidates.

## Script Layer

`templates/scripts/` contains skeletons only:

- Default behavior is read-only or dry-run.
- Scripts must not touch real external systems by default.
- Real connectors should be implemented only after copying the skeleton into a private workspace.

## Data Layer

Real data belongs in the adopter's private local workspace and should be ignored by Git. The framework repository provides only example files and empty templates.

`templates/data/` provides redacted example data structures, including users, groups, group membership details, user-group views, group-message indexes, and NAS import planning. Real runtime data must be synchronized by trusted private connectors and must not be committed.
