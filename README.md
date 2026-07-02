# Reusable Agent Workspace Template

This repository is a sanitized template mirror of a private Agent workspace. It is intended to be copied into a private runtime workspace and filled with organization-specific values.

The private runtime workspace may keep a local `templates/` directory as the publishing source. When publishing to GitHub, publish the contents of that local `templates/` directory to the repository root, not the live runtime files around it.

## Contents

```text
AGENTS.md                 # Root Agent rules template
SUBAGENTS.md              # Sub-agent template index
COMMON_ERRORS.md          # Generic common-error playbook
agent_rules/              # On-demand rule templates
config/                   # Redacted connector config examples
data/                     # Redacted data shape examples
docs/                     # Architecture and publish-safety docs
memory_review/            # Memory review and update-candidate templates
scripts/                  # Dry-run or read-only script skeletons
subagent/                 # Generic sub-agent template
subagents/                # Scenario-specific sub-agent templates
```

## Not Included

- Real organization, employee, customer, vendor, or business data.
- External platform sessions, chat records, attachments, user IDs, group IDs, or message IDs.
- Logs, caches, downloads, generated artifacts, temporary files, and runtime state.
- Tokens, keys, account passwords, cookies, app secrets, private config, or local machine paths.

## Adoption

1. Copy this template into a private workspace.
2. Replace all `<PLACEHOLDER>` values.
3. Keep live data, logs, attachments, and secrets out of Git.
4. Update `AGENTS.md`, `agent_rules/`, sub-agent files, and `COMMON_ERRORS.md` together when runtime behavior changes.
5. Run `scripts/Test-AgentGovernance.ps1` and publish-safety checks before committing.
